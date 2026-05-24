#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <stdint.h>
#include <stddef.h>
#include <math.h>
#include <ctype.h>
#include <errno.h>

#ifdef _WIN32
#include <io.h>
#include <fcntl.h>
#include <winsock2.h>
#include <ws2tcpip.h>
#include <windows.h>
#include <wincrypt.h>
#include <winhttp.h>
#pragma comment(lib, "winhttp.lib")
#pragma comment(lib, "ws2_32.lib")
#else
#include <pthread.h>
#include <sched.h>
#include <unistd.h>
#include <sys/time.h>
#include <sys/stat.h>
#include <dirent.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <netdb.h>
#endif

/* ── Error flag (TLS, defined in LLVM IR, accessed from C runtime) ─────── */
#ifdef _WIN32
extern __declspec(thread) int64_t __nova_error_flag;
extern __declspec(thread) int64_t __nova_error_msg;
#else
extern __thread int64_t __nova_error_flag;
extern __thread int64_t __nova_error_msg;
#endif

static void nova_set_error(const char* msg) {
    if (__nova_error_msg != 0) {
        free((void*)(uintptr_t)__nova_error_msg);
    }
    size_t len = strlen(msg);
    char* m = malloc(len + 1);
    if (!m) { __nova_error_flag = 1; __nova_error_msg = 0; return; }
    memcpy(m, msg, len + 1);
    __nova_error_flag = 1;
    __nova_error_msg = (int64_t)(uintptr_t)m;
}

/* ─�� Slab Allocator (fast fixed-size pools for hot-path objects) ──────────── */

#define SLAB_32_OBJ_SIZE  32
#define SLAB_64_OBJ_SIZE  64
#define SLAB_PAGE_OBJECTS 128

static uintptr_t nova_heap_base;
static uintptr_t nova_heap_top;

typedef struct NovaSlabPage {
    struct NovaSlabPage* next;
    char data[1]; /* flexible: SLAB_PAGE_OBJECTS * obj_size bytes follow */
} NovaSlabPage;

typedef struct {
    void*          free_list;   /* linked list of free slots */
    NovaSlabPage*  pages;       /* linked list of allocated pages */
    int64_t        obj_size;    /* size of each object in this pool */
#ifdef _WIN32
    CRITICAL_SECTION lock;
#else
    pthread_mutex_t lock;
#endif
} NovaSlabPool;

static NovaSlabPool nova_slab_32;
static NovaSlabPool nova_slab_64;
static int nova_slab_inited = 0;

static void nova_slab_pool_init(NovaSlabPool* pool, int64_t obj_size) {
    pool->free_list = NULL;
    pool->pages = NULL;
    pool->obj_size = obj_size;
#ifdef _WIN32
    InitializeCriticalSection(&pool->lock);
#else
    pthread_mutex_init(&pool->lock, NULL);
#endif
}

static void nova_slab_init(void) {
    if (nova_slab_inited) return;
    nova_slab_pool_init(&nova_slab_32, SLAB_32_OBJ_SIZE);
    nova_slab_pool_init(&nova_slab_64, SLAB_64_OBJ_SIZE);
    nova_slab_inited = 1;
}

static void nova_slab_grow(NovaSlabPool* pool) {
    size_t page_data_size = (size_t)(SLAB_PAGE_OBJECTS * pool->obj_size);
    /* Reserve room for the `next` pointer header AND the data payload.
       Use offsetof so we do not depend on the platform's padding rules. */
    size_t header_size = offsetof(NovaSlabPage, data);
    NovaSlabPage* page = (NovaSlabPage*)malloc(header_size + page_data_size);
    if (!page) return;
    uintptr_t page_addr = (uintptr_t)page;
    uintptr_t page_end = page_addr + header_size + page_data_size;
    if (nova_heap_base && page_addr < nova_heap_base)
        nova_heap_base = page_addr;
    if (page_end > nova_heap_top)
        nova_heap_top = page_end;
    page->next = pool->pages;
    pool->pages = page;
    char* base = page->data;
    for (int i = 0; i < SLAB_PAGE_OBJECTS; i++) {
        void* slot = base + (size_t)(i * pool->obj_size);
        *(void**)slot = pool->free_list;
        pool->free_list = slot;
    }
}

static void* nova_slab_alloc(NovaSlabPool* pool) {
#ifdef _WIN32
    EnterCriticalSection(&pool->lock);
#else
    pthread_mutex_lock(&pool->lock);
#endif
    if (!pool->free_list) nova_slab_grow(pool);
    void* obj = pool->free_list;
    if (obj) {
        pool->free_list = *(void**)obj;
        memset(obj, 0, (size_t)pool->obj_size);
    }
#ifdef _WIN32
    LeaveCriticalSection(&pool->lock);
#else
    pthread_mutex_unlock(&pool->lock);
#endif
    return obj;
}

static void nova_slab_free(NovaSlabPool* pool, void* ptr) {
    if (!ptr) return;
#ifdef _WIN32
    EnterCriticalSection(&pool->lock);
#else
    pthread_mutex_lock(&pool->lock);
#endif
    *(void**)ptr = pool->free_list;
    pool->free_list = ptr;
#ifdef _WIN32
    LeaveCriticalSection(&pool->lock);
#else
    pthread_mutex_unlock(&pool->lock);
#endif
}

static void* nova_fast_alloc(size_t size) {
    if (!nova_slab_inited) nova_slab_init();
    if (size <= SLAB_32_OBJ_SIZE) return nova_slab_alloc(&nova_slab_32);
    if (size <= SLAB_64_OBJ_SIZE) return nova_slab_alloc(&nova_slab_64);
    return calloc(1, size);
}

static void nova_fast_free(void* ptr, size_t size) {
    if (!ptr) return;
    if (size <= SLAB_32_OBJ_SIZE) { nova_slab_free(&nova_slab_32, ptr); return; }
    if (size <= SLAB_64_OBJ_SIZE) { nova_slab_free(&nova_slab_64, ptr); return; }
    free(ptr);
}

/* ── String Pool (ultra-fast alloc/free for short strings, bypasses HT) ─── */

#define NOVA_STRPOOL_SLOT_SIZE 16
#define NOVA_STRPOOL_COUNT     16384

static char     nova_strpool_data[NOVA_STRPOOL_COUNT][NOVA_STRPOOL_SLOT_SIZE];
static int32_t  nova_strpool_rc[NOVA_STRPOOL_COUNT];
static int      nova_strpool_stack[NOVA_STRPOOL_COUNT];
static int      nova_strpool_top = -1;
static int      nova_strpool_inited = 0;

/* Forward-declared so the inline lock helpers below can read it. */
static volatile int nova_is_multithreaded;

#ifdef _WIN32
static CRITICAL_SECTION nova_strpool_lock;
#else
static pthread_mutex_t nova_strpool_lock = PTHREAD_MUTEX_INITIALIZER;
#endif
static int nova_strpool_lock_inited = 0;

static void nova_strpool_lock_init(void) {
    if (nova_strpool_lock_inited) return;
#ifdef _WIN32
    InitializeCriticalSection(&nova_strpool_lock);
#endif
    nova_strpool_lock_inited = 1;
}

static inline void nova_strpool_acquire(void) {
    if (!nova_is_multithreaded) return;
    if (!nova_strpool_lock_inited) nova_strpool_lock_init();
#ifdef _WIN32
    EnterCriticalSection(&nova_strpool_lock);
#else
    pthread_mutex_lock(&nova_strpool_lock);
#endif
}

static inline void nova_strpool_release(void) {
    if (!nova_is_multithreaded) return;
#ifdef _WIN32
    LeaveCriticalSection(&nova_strpool_lock);
#else
    pthread_mutex_unlock(&nova_strpool_lock);
#endif
}

static void nova_strpool_init(void) {
    for (int i = NOVA_STRPOOL_COUNT - 1; i >= 0; i--)
        nova_strpool_stack[++nova_strpool_top] = i;
    nova_strpool_inited = 1;
}

static inline int nova_strpool_contains(const void* ptr) {
    return (const char*)ptr >= nova_strpool_data[0] &&
           (const char*)ptr < nova_strpool_data[0] + sizeof(nova_strpool_data);
}

static inline char* nova_strpool_alloc(void) {
    nova_strpool_acquire();
    if (!nova_strpool_inited) nova_strpool_init();
    if (nova_strpool_top < 0) { nova_strpool_release(); return NULL; }
    int idx = nova_strpool_stack[nova_strpool_top--];
    nova_strpool_rc[idx] = 1;
    char* result = nova_strpool_data[idx];
    nova_strpool_release();
    return result;
}

static inline void nova_strpool_free(char* ptr) {
    nova_strpool_acquire();
    int idx = (int)((ptr - nova_strpool_data[0]) / NOVA_STRPOOL_SLOT_SIZE);
    nova_strpool_rc[idx] = 0;
    nova_strpool_stack[++nova_strpool_top] = idx;
    nova_strpool_release();
}

static inline void nova_strpool_rc_inc(const void* ptr) {
    nova_strpool_acquire();
    int idx = (int)(((const char*)ptr - nova_strpool_data[0]) / NOVA_STRPOOL_SLOT_SIZE);
    nova_strpool_rc[idx]++;
    nova_strpool_release();
}

static inline int nova_strpool_rc_dec(const void* ptr) {
    nova_strpool_acquire();
    int idx = (int)(((const char*)ptr - nova_strpool_data[0]) / NOVA_STRPOOL_SLOT_SIZE);
    int freed = 0;
    if (--nova_strpool_rc[idx] <= 0) {
        nova_strpool_stack[++nova_strpool_top] = idx;
        freed = 1;
    }
    nova_strpool_release();
    return freed;
}

/* ── Memory Registry (thread-safe hash map, O(1) lookup) ─────────────────── */

typedef enum {
    NOVA_MEM_RAW     = 0,
    NOVA_MEM_LIST    = 1,
    NOVA_MEM_DICT    = 2,
    NOVA_MEM_CHANNEL = 3,
    NOVA_MEM_FAT_STR = 4,
    NOVA_MEM_STRUCT  = 5,
    NOVA_MEM_ITER    = 6
} NovaMemTag;

static int64_t      nova_mem_live    = 0;
static int64_t      nova_mem_total   = 0;
static volatile int nova_is_multithreaded = 0;
/* nova_heap_base declared near slab allocator — tracks lowest heap address for fast RC filter */

#ifdef _WIN32
static CRITICAL_SECTION nova_mem_lock;
#else
static pthread_mutex_t nova_mem_lock = PTHREAD_MUTEX_INITIALIZER;
#endif

/* ── Embedded RC Header ────────────────────────────────────────────────────
   Every heap allocation prepends: [rc:int32 | tag_magic:int32]
   User pointer points past the header. RC ops are O(1) header dereferences.
   Tag uses magic prefix 0x4E56xxxx ('NV') to distinguish from unmanaged ptrs.
   Layout for regular objects: [rc:4][tag:4][object data...]
   Layout for fat strings:     [hash:8][len:8][rc:4][tag:4][char data...]
   In both cases, RC macros index from the user pointer at [-2] and [-1]. */

#define NOVA_RC_HDR_SIZE 8
#define NOVA_RC_MAGIC    0x4E560000
#define NOVA_RC_ENCODE(tag) (NOVA_RC_MAGIC | (int32_t)(tag))
#define NOVA_RC_TAG(ptr)    ((NovaMemTag)(((const int32_t*)(ptr))[-1] & 0xFFFF))
#define NOVA_RC_VALID(ptr)  ((((const int32_t*)(ptr))[-1] & 0xFFFF0000) == (uint32_t)NOVA_RC_MAGIC)
#define NOVA_RC_COUNT(ptr)  (((int32_t*)(ptr))[-2])
/* Structs/closures pack their slot count into the tag word's free bits:
   low 3 bits = kind (NOVA_MEM_STRUCT=5), bits 3..15 = slot count (0..8191).
   Non-struct objects keep slot bits 0, so their tag stays exactly 0..4. */
#define NOVA_STRUCT_NSLOTS(ptr) ((int64_t)((((const uint32_t*)(ptr))[-1] & 0xFFFFu) >> 3))

static void* nova_heap_alloc(size_t size, NovaMemTag tag) {
    size_t total = NOVA_RC_HDR_SIZE + size;
    char* base;
    if (!nova_slab_inited) nova_slab_init();
    if (tag == NOVA_MEM_LIST && total <= SLAB_32_OBJ_SIZE)
        base = (char*)nova_slab_alloc(&nova_slab_32);
    else if (tag == NOVA_MEM_DICT && total <= SLAB_64_OBJ_SIZE)
        base = (char*)nova_slab_alloc(&nova_slab_64);
    else {
        base = (char*)calloc(1, total);
        if (base) {
            uintptr_t baddr = (uintptr_t)base;
            if (nova_heap_base && baddr < nova_heap_base)
                nova_heap_base = baddr;
            uintptr_t bend = baddr + total;
            if (bend > nova_heap_top)
                nova_heap_top = bend;
        }
    }
    if (!base) return NULL;
    ((int32_t*)base)[0] = 1;
    ((int32_t*)base)[1] = NOVA_RC_ENCODE(tag);
    nova_mem_total++;
    nova_mem_live++;
    return base + NOVA_RC_HDR_SIZE;
}

void* nova_rt_struct_alloc(int64_t size) {
    /* Tag structs/closures distinctly and record their slot count so the
       deep-copy path can walk their fields. size is always a multiple of 8. */
    int64_t nslots = size / 8;
    if (nslots < 0) nslots = 0;
    if (nslots > 0x1FFF) nslots = 0x1FFF;
    NovaMemTag packed = (NovaMemTag)(((int32_t)nslots << 3) | NOVA_MEM_STRUCT);
    return nova_heap_alloc((size_t)size, packed);
}

/* ── Fat Strings: [hash:8][len:8][rc:4][tag:4][char data...]['\0'] ────────
   Pointer returned to user code points to char data (offset +24 from base).
   This IS a valid const char* for printf, strcmp, memcpy, etc.
   RC header at ptr[-8..0] (same position as all other objects).
   Hash at ptr[-24..-16], len at ptr[-16..-8]. */

#define NOVA_FAT_HDR_SIZE 16
#define NOVA_FAT_HASH(p) (((const uint64_t*)(p))[-3])
#define NOVA_FAT_LEN(p)  (((const int64_t*)(p))[-2])

void nova_rc_inc(int64_t val);
void nova_rc_dec(int64_t val);

/* Forward declarations for int_to_str cache (needed by nova_mem_find_tag) */
static char     nova_int_str_cache[10000][8];
static uint64_t nova_int_str_cache_hash[10000];
static int      nova_int_str_cache_inited;

static NovaMemTag nova_mem_find_tag(void* ptr) {
    if (!ptr) return (NovaMemTag)-1;
    uintptr_t addr = (uintptr_t)ptr;
    if (addr < 0x10000ULL) return (NovaMemTag)-1;
    if (nova_heap_base && addr < nova_heap_base) return (NovaMemTag)-1;
    if (nova_heap_top && addr > nova_heap_top + 0x10000000000ULL) return (NovaMemTag)-1;
    if (nova_int_str_cache_inited &&
        (char*)ptr >= nova_int_str_cache[0] &&
        (char*)ptr < nova_int_str_cache[0] + sizeof(nova_int_str_cache))
        return (NovaMemTag)-1;
    if (nova_strpool_contains(ptr)) return NOVA_MEM_RAW;
#ifdef _WIN32
    if (IsBadReadPtr((char*)ptr - NOVA_RC_HDR_SIZE, NOVA_RC_HDR_SIZE)) return (NovaMemTag)-1;
#endif
    /* Mask to the low 3 kind bits: structs pack a slot count above them. */
    if (NOVA_RC_VALID(ptr)) return (NovaMemTag)(NOVA_RC_TAG(ptr) & 0x7);
    return (NovaMemTag)-1;
}

void nova_rt_track_raw(void* ptr) {
    (void)ptr;
    nova_mem_total++;
    nova_mem_live++;
}

static int nova_is_readable_str(const void* ptr) {
#ifdef _WIN32
    return !IsBadReadPtr(ptr, 1);
#else
    ssize_t r = 0;
    int fd[2];
    if (pipe(fd) != 0) return 0;
    r = write(fd[1], ptr, 1);
    close(fd[0]); close(fd[1]);
    return r == 1;
#endif
}

/* nova_rt_init is defined later (after all lock declarations) */

/* int_to_str cache declared above (before nova_mem_find_tag) */

/* ── String Intern Table (dedup string constants, enable pointer equality) ── */

#define NOVA_INTERN_INIT_CAP 1024

static const char** nova_intern_table = NULL;
static uint64_t*    nova_intern_hashes = NULL;
static int64_t      nova_intern_cap   = 0;
static int64_t      nova_intern_used  = 0;

static uint64_t nova_intern_hash(const char* s) {
    uint64_t h = 14695981039346656037ULL;
    while (*s) {
        h ^= (uint64_t)(unsigned char)*s++;
        h *= 1099511628211ULL;
    }
    return h;
}

static void nova_intern_grow(void) {
    int64_t old_cap = nova_intern_cap;
    const char** old = nova_intern_table;
    uint64_t* old_h = nova_intern_hashes;
    int64_t new_cap = old_cap * 2;
    const char** fresh = (const char**)calloc((size_t)new_cap, sizeof(const char*));
    uint64_t* fresh_h = (uint64_t*)calloc((size_t)new_cap, sizeof(uint64_t));
    if (!fresh || !fresh_h) return;
    for (int64_t i = 0; i < old_cap; i++) {
        if (old[i]) {
            uint64_t h = old_h[i];
            uint64_t idx = h & (uint64_t)(new_cap - 1);
            while (fresh[idx]) idx = (idx + 1) & (uint64_t)(new_cap - 1);
            fresh[idx] = old[i];
            fresh_h[idx] = h;
        }
    }
    nova_intern_table = fresh;
    nova_intern_hashes = fresh_h;
    nova_intern_cap = new_cap;
    free(old);
    free(old_h);
}

static const char* nova_intern_h(const char* s, uint64_t* out_hash) {
    if (!s) { *out_hash = 0; return NULL; }
    if (!nova_intern_table) {
        nova_intern_cap = NOVA_INTERN_INIT_CAP;
        nova_intern_table = (const char**)calloc((size_t)nova_intern_cap, sizeof(const char*));
        nova_intern_hashes = (uint64_t*)calloc((size_t)nova_intern_cap, sizeof(uint64_t));
    }
    uint64_t h;
    if (nova_int_str_cache_inited &&
        s >= nova_int_str_cache[0] &&
        s < nova_int_str_cache[0] + sizeof(nova_int_str_cache)) {
        int idx = (int)((s - nova_int_str_cache[0]) / 8);
        h = nova_int_str_cache_hash[idx];
    } else {
        NovaMemTag tag = nova_mem_find_tag((void*)s);
        if (tag == NOVA_MEM_FAT_STR) {
            h = NOVA_FAT_HASH(s);
        } else {
            h = nova_intern_hash(s);
        }
    }
    *out_hash = h;
    uint64_t idx = h & (uint64_t)(nova_intern_cap - 1);
    while (nova_intern_table[idx]) {
        if (nova_intern_table[idx] == s) return s;
        if (nova_intern_hashes[idx] == h && strcmp(nova_intern_table[idx], s) == 0)
            return nova_intern_table[idx];
        idx = (idx + 1) & (uint64_t)(nova_intern_cap - 1);
    }
    if (nova_intern_used * 2 >= nova_intern_cap) {
        nova_intern_grow();
        idx = h & (uint64_t)(nova_intern_cap - 1);
        while (nova_intern_table[idx]) idx = (idx + 1) & (uint64_t)(nova_intern_cap - 1);
    }
    nova_intern_table[idx] = s;
    nova_intern_hashes[idx] = h;
    nova_intern_used++;
    return s;
}

static const char* nova_intern(const char* s) {
    uint64_t h;
    return nova_intern_h(s, &h);
}

static int nova_str_eq(const char* a, const char* b) {
    if (a == b) return 1;
    return strcmp(a, b) == 0;
}

/* ── Fat String Constructor ──────────────────────────────────────────────
   Layout: [hash:8][len:8][rc:4][tag:4][char data...]['\0']
   Returns pointer to char data. RC header is embedded between fat header
   and data so RC macros work at the same offsets as regular objects. */

static char* nova_fat_str_create(const char* src, size_t len) {
    char* base = (char*)malloc(NOVA_FAT_HDR_SIZE + NOVA_RC_HDR_SIZE + len + 1);
    if (!base) return NULL;
    char* str = base + NOVA_FAT_HDR_SIZE + NOVA_RC_HDR_SIZE;
    uint64_t h = 14695981039346656037ULL;
    for (size_t i = 0; i < len; i++) {
        str[i] = src[i];
        h ^= (uint64_t)(unsigned char)src[i];
        h *= 1099511628211ULL;
    }
    str[len] = '\0';
    ((uint64_t*)base)[0] = h;
    ((int64_t*)base)[1] = (int64_t)len;
    ((int32_t*)(base + NOVA_FAT_HDR_SIZE))[0] = 1;
    ((int32_t*)(base + NOVA_FAT_HDR_SIZE))[1] = NOVA_RC_ENCODE(NOVA_MEM_FAT_STR);
    nova_mem_total++;
    nova_mem_live++;
    return str;
}

static char* nova_fat_str_concat(const char* sa, size_t la,
                                  const char* sb, size_t lb) {
    size_t total = la + lb;
    char* base = (char*)malloc(NOVA_FAT_HDR_SIZE + NOVA_RC_HDR_SIZE + total + 1);
    if (!base) return NULL;
    char* str = base + NOVA_FAT_HDR_SIZE + NOVA_RC_HDR_SIZE;
    uint64_t h = 14695981039346656037ULL;
    for (size_t i = 0; i < la; i++) {
        str[i] = sa[i];
        h ^= (uint64_t)(unsigned char)sa[i];
        h *= 1099511628211ULL;
    }
    for (size_t i = 0; i < lb; i++) {
        str[la + i] = sb[i];
        h ^= (uint64_t)(unsigned char)sb[i];
        h *= 1099511628211ULL;
    }
    str[total] = '\0';
    ((uint64_t*)base)[0] = h;
    ((int64_t*)base)[1] = (int64_t)total;
    ((int32_t*)(base + NOVA_FAT_HDR_SIZE))[0] = 1;
    ((int32_t*)(base + NOVA_FAT_HDR_SIZE))[1] = NOVA_RC_ENCODE(NOVA_MEM_FAT_STR);
    nova_mem_total++;
    nova_mem_live++;
    return str;
}

/* ── Forward struct definitions (used across sections) ─────────────────── */
#define DICT_IDX_EMPTY (-1)

typedef struct NovaDict {
    int64_t* keys;      /* dense entries in insertion order              */
    int64_t* vals;      /* parallel values                               */
    uint64_t* hashes;   /* cached hash per key for fast mismatch         */
    int64_t  size;      /* live entry count (always compacted, no holes) */
    int64_t  cap;       /* capacity of keys/vals/hashes arrays           */
    int64_t* idx;       /* hash index: slot → entry index, or -1 empty   */
    int64_t  idx_cap;   /* hash index capacity (power of 2)              */
} NovaDict;

static void dict_rebuild_index(NovaDict* d) {
    memset(d->idx, 0xFF, (size_t)d->idx_cap * sizeof(int64_t));
    for (int64_t i = 0; i < d->size; i++) {
        int64_t slot = (int64_t)(d->hashes[i] & (uint64_t)(d->idx_cap - 1));
        while (d->idx[slot] != DICT_IDX_EMPTY)
            slot = (slot + 1) & (d->idx_cap - 1);
        d->idx[slot] = i;
    }
}

static void dict_maybe_grow(NovaDict* d) {
    if (d->size * 3 < d->idx_cap * 2) return;
    d->idx_cap *= 2;
    d->idx = realloc(d->idx, (size_t)d->idx_cap * sizeof(int64_t));
    dict_rebuild_index(d);
}

/* forward decl — used by nova_rt_contains before dict section */
int64_t nova_rt_dict_has(int64_t handle, int64_t key);

/* ── List ─────────────────────────────────────────────────────────────────── */

typedef struct {
    int64_t* data;
    int64_t  size;
    int64_t  cap;
} NovaList;

int64_t nova_rt_list_create(void) {
    NovaList* list = (NovaList*)nova_heap_alloc(sizeof(NovaList), NOVA_MEM_LIST);
    if (!list) return 0;
    list->data = malloc(8 * sizeof(int64_t));
    list->size = 0;
    list->cap  = 8;
    return (int64_t)(uintptr_t)list;
}

int64_t nova_rt_list_create_filled(int64_t count, int64_t value) {
    if (count < 0) count = 0;
    NovaList* list = (NovaList*)nova_heap_alloc(sizeof(NovaList), NOVA_MEM_LIST);
    if (!list) return 0;
    int64_t cap = count < 8 ? 8 : count;
    if (value == 0) {
        list->data = calloc((size_t)cap, sizeof(int64_t));
    } else {
        list->data = malloc((size_t)cap * sizeof(int64_t));
        if (list->data) {
            for (int64_t i = 0; i < count; i++) {
                list->data[i] = value;
                nova_rc_inc(value);
            }
        }
    }
    list->size = count;
    list->cap  = cap;
    return (int64_t)(uintptr_t)list;
}

int64_t nova_rt_list_append(int64_t handle, int64_t elem) {
    NovaList* list = (NovaList*)(uintptr_t)handle;
    if (list->size >= list->cap) {
        list->cap *= 2;
        list->data = realloc(list->data, (size_t)list->cap * sizeof(int64_t));
    }
    list->data[list->size++] = elem;
    nova_rc_inc(elem);
    return 0;
}

int64_t nova_rt_list_get(int64_t handle, int64_t index) {
    NovaList* list = (NovaList*)(uintptr_t)handle;
    if (index < 0) index += list->size;
    if (index < 0 || index >= list->size) {
        char buf[128];
        snprintf(buf, sizeof(buf), "list index %lld out of range for list of size %lld",
                 (long long)(index < 0 ? index - list->size : index),
                 (long long)list->size);
        nova_set_error(buf);
        return 0;
    }
    return list->data[index];
}

int64_t nova_rt_list_set(int64_t handle, int64_t index, int64_t value) {
    NovaList* list = (NovaList*)(uintptr_t)handle;
    if (index < 0) index += list->size;
    if (index < 0 || index >= list->size) {
        char buf[128];
        snprintf(buf, sizeof(buf), "list index %lld out of range for list of size %lld",
                 (long long)(index < 0 ? index - list->size : index),
                 (long long)list->size);
        nova_set_error(buf);
        return 0;
    }
    nova_rc_dec(list->data[index]);
    list->data[index] = value;
    nova_rc_inc(value);
    return 0;
}

int64_t nova_rt_list_len(int64_t handle) {
    NovaList* list = (NovaList*)(uintptr_t)handle;
    return list->size;
}

int64_t nova_rt_iter_has_next(int64_t handle, int64_t index) {
    void* ptr = (void*)(uintptr_t)handle;
    NovaMemTag tag = nova_mem_find_tag(ptr);
    if (tag == NOVA_MEM_DICT) {
        NovaDict* d = (NovaDict*)ptr;
        return (index < d->size) ? 1 : 0;
    }
    NovaList* list = (NovaList*)ptr;
    return (index < list->size) ? 1 : 0;
}

int64_t nova_rt_list_iter_has_next(int64_t handle, int64_t index) {
    NovaList* list = (NovaList*)(uintptr_t)handle;
    return (index < list->size) ? 1 : 0;
}

int64_t nova_rt_list_iter_get(int64_t handle, int64_t index) {
    NovaList* list = (NovaList*)(uintptr_t)handle;
    return list->data[index];
}

int64_t nova_rt_list_print(int64_t handle) {
    NovaList* list = (NovaList*)(uintptr_t)handle;
    printf("[");
    for (int64_t i = 0; i < list->size; i++) {
        if (i > 0) printf(", ");
        printf("%lld", (long long)list->data[i]);
    }
    printf("]\n");
    return 0;
}

int64_t nova_rt_iter_get(int64_t handle, int64_t index) {
    void* ptr = (void*)(uintptr_t)handle;
    NovaMemTag tag = nova_mem_find_tag(ptr);
    if (tag == NOVA_MEM_DICT) {
        NovaDict* d = (NovaDict*)ptr;
        if (index < 0 || index >= d->size) return 0;
        return d->keys[index];
    }
    return nova_rt_list_get(handle, index);
}

int64_t nova_rt_len_any(int64_t handle) {
    if (handle == 0) return 0;
    void* ptr = (void*)(uintptr_t)handle;
    NovaMemTag tag = nova_mem_find_tag(ptr);
    if (tag == NOVA_MEM_LIST) return ((NovaList*)ptr)->size;
    if (tag == NOVA_MEM_DICT) return ((NovaDict*)ptr)->size;
    if (tag == NOVA_MEM_FAT_STR) return NOVA_FAT_LEN((const char*)ptr);
    return (int64_t)strlen((const char*)ptr);
}

int64_t nova_rt_any_to_str(int64_t val); /* forward decl */

int64_t nova_rt_list_to_str(int64_t handle) {
    NovaList* list = (NovaList*)(uintptr_t)handle;
    size_t cap = 256;
    char* buf = malloc(cap);
    size_t pos = 0;
    buf[pos++] = '[';
    for (int64_t i = 0; i < list->size; i++) {
        if (i > 0) { buf[pos++] = ','; buf[pos++] = ' '; }
        int64_t s = nova_rt_any_to_str(list->data[i]);
        const char* elem = (const char*)(uintptr_t)s;
        size_t n = strlen(elem);
        NovaMemTag etag = nova_mem_find_tag((void*)(uintptr_t)list->data[i]);
        int is_str = (etag == NOVA_MEM_RAW || etag == NOVA_MEM_FAT_STR)
                  || (etag == (NovaMemTag)-1 && (uint64_t)list->data[i] > 0x10000
                      && nova_is_readable_str((void*)(uintptr_t)list->data[i]));
        while (pos + n + 6 >= cap) { cap *= 2; buf = realloc(buf, cap); }
        if (is_str) buf[pos++] = '"';
        memcpy(buf + pos, elem, n);
        pos += n;
        if (is_str) buf[pos++] = '"';
    }
    buf[pos++] = ']';
    buf[pos] = '\0';
    char* tracked = (char*)nova_heap_alloc(pos + 1, NOVA_MEM_RAW);
    if (tracked) memcpy(tracked, buf, pos + 1);
    free(buf);
    return (int64_t)(uintptr_t)tracked;
}

/* ── Strings ──────────────────────────────────────────────────────────────── */

int64_t nova_rt_str_concat(int64_t a, int64_t b) {
    const char* sa = (const char*)(uintptr_t)a;
    const char* sb = (const char*)(uintptr_t)b;
    size_t la = strlen(sa), lb = strlen(sb);
    size_t total = la + lb;
    char* result = (char*)nova_heap_alloc(total + 1, NOVA_MEM_RAW);
    if (!result) return 0;
    memcpy(result, sa, la);
    memcpy(result + la, sb, lb + 1);
    return (int64_t)(uintptr_t)result;
}

static void nova_int_str_cache_init(void) {
    for (int i = 0; i < 10000; i++) {
        snprintf(nova_int_str_cache[i], 8, "%d", i);
        uint64_t h = 14695981039346656037ULL;
        for (const char* p = nova_int_str_cache[i]; *p; p++) {
            h ^= (uint64_t)(unsigned char)*p;
            h *= 1099511628211ULL;
        }
        nova_int_str_cache_hash[i] = h;
    }
    nova_int_str_cache_inited = 1;
}

int64_t nova_rt_int_to_str(int64_t v) {
    if (v >= 0 && v < 10000) {
        if (!nova_int_str_cache_inited) nova_int_str_cache_init();
        return (int64_t)(uintptr_t)nova_int_str_cache[v];
    }
    char tmp[32];
    int len = snprintf(tmp, 32, "%lld", (long long)v);
    char* result = nova_fat_str_create(tmp, (size_t)len);
    if (!result) return 0;
    return (int64_t)(uintptr_t)result;
}

int64_t nova_rt_float_to_str(int64_t bits) {
    double v;
    memcpy(&v, &bits, sizeof(double));
    char tmp[32];
    int len = snprintf(tmp, 32, "%g", v);
    char* result = nova_fat_str_create(tmp, (size_t)len);
    if (!result) return 0;
    return (int64_t)(uintptr_t)result;
}

int64_t nova_rt_bool_to_str(int64_t v) {
    const char* s = v ? "true" : "false";
    size_t len = strlen(s) + 1;
    char* buf = (char*)nova_heap_alloc(len, NOVA_MEM_RAW);
    if (!buf) return 0;
    memcpy(buf, s, len);
    return (int64_t)(uintptr_t)buf;
}

int64_t nova_rt_str_len(int64_t handle) {
    const char* s = (const char*)(uintptr_t)handle;
    NovaMemTag tag = nova_mem_find_tag((void*)s);
    if (tag == NOVA_MEM_FAT_STR) return NOVA_FAT_LEN(s);
    return (int64_t)strlen(s);
}

int64_t nova_rt_len(int64_t handle) {
    const char* s = (const char*)(uintptr_t)handle;
    NovaMemTag tag = nova_mem_find_tag((void*)s);
    if (tag == NOVA_MEM_FAT_STR) return NOVA_FAT_LEN(s);
    return (int64_t)strlen(s);
}

// nova_rt_contains: generic version below nova_rt_list_slice (handles list, dict, string)

int64_t nova_rt_slice(int64_t s, int64_t start, int64_t end) {
    const char* str = (const char*)(uintptr_t)s;
    int64_t len = (int64_t)strlen(str);
    if (start < 0) start = 0;
    if (end > len) end = len;
    if (start >= end) { char* r = (char*)nova_heap_alloc(1, NOVA_MEM_RAW); if(r) r[0] = '\0'; return (int64_t)(uintptr_t)r; }
    int64_t n = end - start;
    char* result = (char*)nova_heap_alloc((size_t)n + 1, NOVA_MEM_RAW);
    if (!result) return 0;
    memcpy(result, str + start, (size_t)n);
    result[n] = '\0';
    return (int64_t)(uintptr_t)result;
}

int64_t nova_rt_upper(int64_t s) {
    const char* str = (const char*)(uintptr_t)s;
    size_t len = strlen(str);
    char* result = (char*)nova_heap_alloc(len + 1, NOVA_MEM_RAW);
    if (!result) return 0;
    for (size_t i = 0; i <= len; i++)
        result[i] = (str[i] >= 'a' && str[i] <= 'z') ? str[i] - 32 : str[i];
    return (int64_t)(uintptr_t)result;
}

int64_t nova_rt_lower(int64_t s) {
    const char* str = (const char*)(uintptr_t)s;
    size_t len = strlen(str);
    char* result = (char*)nova_heap_alloc(len + 1, NOVA_MEM_RAW);
    if (!result) return 0;
    for (size_t i = 0; i <= len; i++)
        result[i] = (str[i] >= 'A' && str[i] <= 'Z') ? str[i] + 32 : str[i];
    return (int64_t)(uintptr_t)result;
}

int64_t nova_rt_repeat(int64_t s, int64_t count) {
    if (count <= 0) {
        char* r = (char*)nova_heap_alloc(1, NOVA_MEM_RAW);
        if (r) r[0] = '\0';
        return (int64_t)(uintptr_t)r;
    }
    const char* str = (const char*)(uintptr_t)s;
    size_t len = strlen(str);
    size_t total = len * (size_t)count;
    char* result = (char*)nova_heap_alloc(total + 1, NOVA_MEM_RAW);
    if (!result) return 0;
    for (int64_t i = 0; i < count; i++)
        memcpy(result + i * len, str, len);
    result[total] = '\0';
    return (int64_t)(uintptr_t)result;
}

int64_t nova_rt_trim(int64_t s) {
    const char* str = (const char*)(uintptr_t)s;
    while (*str == ' ' || *str == '\t' || *str == '\n' || *str == '\r') str++;
    size_t len = strlen(str);
    while (len > 0 && (str[len-1] == ' ' || str[len-1] == '\t' || str[len-1] == '\n' || str[len-1] == '\r')) len--;
    char* result = (char*)nova_heap_alloc(len + 1, NOVA_MEM_RAW);
    if (!result) return 0;
    memcpy(result, str, len);
    result[len] = '\0';
    return (int64_t)(uintptr_t)result;
}

int64_t nova_rt_split(int64_t s, int64_t delim) {
    const char* str = (const char*)(uintptr_t)s;
    const char* d = (const char*)(uintptr_t)delim;
    size_t dlen = strlen(d);
    if (dlen == 0) {
        nova_set_error("split: empty delimiter");
        return nova_rt_list_create();
    }
    int64_t list = nova_rt_list_create();
    const char* pos = str;
    while (1) {
        const char* found = strstr(pos, d);
        if (!found) {
            size_t rem = strlen(pos);
            char* part = (char*)nova_heap_alloc(rem + 1, NOVA_MEM_RAW);
            if (part) memcpy(part, pos, rem + 1);
            nova_rt_list_append(list, (int64_t)(uintptr_t)part);
            break;
        }
        size_t n = (size_t)(found - pos);
        char* part = (char*)nova_heap_alloc(n + 1, NOVA_MEM_RAW);
        if (part) { memcpy(part, pos, n); part[n] = '\0'; }
        nova_rt_list_append(list, (int64_t)(uintptr_t)part);
        pos = found + dlen;
    }
    return list;
}

int64_t nova_rt_replace(int64_t s, int64_t old_s, int64_t new_s) {
    const char* str = (const char*)(uintptr_t)s;
    const char* old_str = (const char*)(uintptr_t)old_s;
    const char* new_str = (const char*)(uintptr_t)new_s;
    size_t old_len = strlen(old_str);
    size_t new_len = strlen(new_str);
    if (old_len == 0) return s;
    size_t count = 0;
    const char* p = str;
    while ((p = strstr(p, old_str)) != NULL) { count++; p += old_len; }
    int64_t diff = (int64_t)new_len - (int64_t)old_len;
    size_t result_len = (size_t)((int64_t)strlen(str) + (int64_t)count * diff);
    char* result = (char*)nova_heap_alloc(result_len + 1, NOVA_MEM_RAW);
    if (!result) return 0;
    char* dst = result;
    p = str;
    while (1) {
        const char* found = strstr(p, old_str);
        if (!found) { strcpy(dst, p); break; }
        size_t n = (size_t)(found - p);
        memcpy(dst, p, n); dst += n;
        memcpy(dst, new_str, new_len); dst += new_len;
        p = found + old_len;
    }
    return (int64_t)(uintptr_t)result;
}

int64_t nova_rt_starts_with(int64_t s, int64_t prefix) {
    const char* str = (const char*)(uintptr_t)s;
    const char* pre = (const char*)(uintptr_t)prefix;
    return strncmp(str, pre, strlen(pre)) == 0 ? 1 : 0;
}

int64_t nova_rt_ends_with(int64_t s, int64_t suffix) {
    const char* str = (const char*)(uintptr_t)s;
    const char* suf = (const char*)(uintptr_t)suffix;
    size_t str_len = strlen(str), suf_len = strlen(suf);
    if (suf_len > str_len) return 0;
    return strcmp(str + str_len - suf_len, suf) == 0 ? 1 : 0;
}

int64_t nova_rt_find(int64_t s, int64_t sub) {
    const char* str = (const char*)(uintptr_t)s;
    const char* needle = (const char*)(uintptr_t)sub;
    const char* found = strstr(str, needle);
    return found ? (int64_t)(found - str) : -1;
}

int64_t nova_rt_join(int64_t list_handle, int64_t sep) {
    NovaList* l = (NovaList*)(uintptr_t)list_handle;
    const char* s = (const char*)(uintptr_t)sep;
    size_t sep_len = strlen(s);
    if (l->size == 0) { char* r = (char*)nova_heap_alloc(1, NOVA_MEM_RAW); if(r) r[0] = '\0'; return (int64_t)(uintptr_t)r; }
    size_t total = 0;
    for (int64_t i = 0; i < l->size; i++) {
        total += strlen((const char*)(uintptr_t)l->data[i]);
        if (i < l->size - 1) total += sep_len;
    }
    char* result = (char*)nova_heap_alloc(total + 1, NOVA_MEM_RAW);
    if (!result) return 0;
    char* dst = result;
    for (int64_t i = 0; i < l->size; i++) {
        const char* elem = (const char*)(uintptr_t)l->data[i];
        size_t elen = strlen(elem);
        memcpy(dst, elem, elen); dst += elen;
        if (i < l->size - 1) { memcpy(dst, s, sep_len); dst += sep_len; }
    }
    *dst = '\0';
    return (int64_t)(uintptr_t)result;
}

int64_t nova_rt_chars(int64_t s) {
    const char* str = (const char*)(uintptr_t)s;
    size_t len = strlen(str);
    int64_t list = nova_rt_list_create();
    for (size_t i = 0; i < len; i++) {
        char* ch = (char*)nova_heap_alloc(2, NOVA_MEM_RAW);
        if (ch) { ch[0] = str[i]; ch[1] = '\0'; }
        nova_rt_list_append(list, (int64_t)(uintptr_t)ch);
    }
    return list;
}

/* ── List stdlib ──────────────────────────────────────────────────────────── */

int64_t nova_rt_list_concat(int64_t a, int64_t b) {
    NovaList* la = (NovaList*)(uintptr_t)a;
    NovaList* lb = (NovaList*)(uintptr_t)b;
    int64_t new_list = nova_rt_list_create();
    NovaList* result = (NovaList*)(uintptr_t)new_list;
    int64_t total = la->size + lb->size;
    if (total > result->cap) {
        result->cap = total;
        result->data = realloc(result->data, (size_t)total * sizeof(int64_t));
    }
    for (int64_t i = 0; i < la->size; i++) {
        result->data[result->size++] = la->data[i];
        nova_rc_inc(la->data[i]);
    }
    for (int64_t i = 0; i < lb->size; i++) {
        result->data[result->size++] = lb->data[i];
        nova_rc_inc(lb->data[i]);
    }
    return new_list;
}

int64_t nova_rt_range(int64_t n) {
    if (n < 0) n = 0;
    NovaList* list = (NovaList*)nova_heap_alloc(sizeof(NovaList), NOVA_MEM_LIST);
    if (!list) return 0;
    list->data = (n > 0) ? (int64_t*)malloc(n * sizeof(int64_t)) : NULL;
    if (n > 0 && !list->data) return 0;
    list->size = n;
    list->cap  = n;
    for (int64_t i = 0; i < n; i++) list->data[i] = i;
    return (int64_t)(uintptr_t)list;
}

int64_t nova_rt_range_from_to(int64_t from, int64_t to) {
    int64_t n = to - from;
    if (n < 0) n = 0;
    NovaList* list = (NovaList*)nova_heap_alloc(sizeof(NovaList), NOVA_MEM_LIST);
    if (!list) return 0;
    list->data = (n > 0) ? (int64_t*)malloc(n * sizeof(int64_t)) : NULL;
    if (n > 0 && !list->data) return 0;
    list->size = n;
    list->cap  = n;
    for (int64_t i = 0; i < n; i++) list->data[i] = from + i;
    return (int64_t)(uintptr_t)list;
}

int64_t nova_rt_list_reverse(int64_t handle) {
    NovaList* l = (NovaList*)(uintptr_t)handle;
    int64_t new_list = nova_rt_list_create();
    for (int64_t i = l->size - 1; i >= 0; i--)
        nova_rt_list_append(new_list, l->data[i]);
    return new_list;
}

static int cmp_int64(const void* a, const void* b) {
    int64_t va = *(const int64_t*)a;
    int64_t vb = *(const int64_t*)b;
    return (va > vb) - (va < vb);
}

int64_t nova_rt_list_sort(int64_t handle) {
    NovaList* l = (NovaList*)(uintptr_t)handle;
    qsort(l->data, (size_t)l->size, sizeof(int64_t), cmp_int64);
    return handle;
}

typedef int64_t (*nova_fn1)(int64_t env, int64_t arg);

int64_t nova_rt_list_map(int64_t handle, int64_t closure) {
    NovaList* l = (NovaList*)(uintptr_t)handle;
    int64_t* rec = (int64_t*)(uintptr_t)closure;
    nova_fn1 fn = (nova_fn1)(uintptr_t)rec[0];
    int64_t new_list = nova_rt_list_create();
    for (int64_t i = 0; i < l->size; i++)
        nova_rt_list_append(new_list, fn(closure, l->data[i]));
    return new_list;
}

int64_t nova_rt_list_filter(int64_t handle, int64_t closure) {
    NovaList* l = (NovaList*)(uintptr_t)handle;
    int64_t* rec = (int64_t*)(uintptr_t)closure;
    nova_fn1 fn = (nova_fn1)(uintptr_t)rec[0];
    int64_t new_list = nova_rt_list_create();
    for (int64_t i = 0; i < l->size; i++) {
        if (fn(closure, l->data[i])) nova_rt_list_append(new_list, l->data[i]);
    }
    return new_list;
}

int64_t nova_rt_list_slice(int64_t handle, int64_t start, int64_t end) {
    NovaList* l = (NovaList*)(uintptr_t)handle;
    if (start < 0) start += l->size;
    if (end < 0) end += l->size;
    if (start < 0) start = 0;
    if (end > l->size) end = l->size;
    if (start >= end) return nova_rt_list_create();
    int64_t new_list = nova_rt_list_create();
    NovaList* result = (NovaList*)(uintptr_t)new_list;
    int64_t n = end - start;
    if (n > result->cap) {
        result->cap = n;
        result->data = realloc(result->data, (size_t)n * sizeof(int64_t));
    }
    for (int64_t i = start; i < end; i++) {
        result->data[result->size++] = l->data[i];
        nova_rc_inc(l->data[i]);
    }
    return new_list;
}

int64_t nova_rt_contains(int64_t container, int64_t item) {
    if (container == 0) return 0;
    void* ptr = (void*)(uintptr_t)container;
    NovaMemTag tag = nova_mem_find_tag(ptr);
    if (tag == NOVA_MEM_LIST) {
        NovaList* l = (NovaList*)ptr;
        for (int64_t i = 0; i < l->size; i++) {
            if (l->data[i] == item) return 1;
        }
        return 0;
    }
    if (tag == NOVA_MEM_DICT) {
        return nova_rt_dict_has((int64_t)(uintptr_t)ptr, item);
    }
    // String containment: strstr
    const char* haystack = (const char*)ptr;
    const char* needle = (const char*)(uintptr_t)item;
    return strstr(haystack, needle) != NULL ? 1 : 0;
}

/* ── Dict (Phase 2: FNV-1a hash map, O(1) amortized lookup) ─────────────── */

int64_t nova_rt_dict_create(void) {
    NovaDict* d = (NovaDict*)nova_heap_alloc(sizeof(NovaDict), NOVA_MEM_DICT);
    if (!d) return 0;
    d->cap     = 8;
    d->keys    = malloc(8 * sizeof(int64_t));
    d->vals    = malloc(8 * sizeof(int64_t));
    d->hashes  = malloc(8 * sizeof(uint64_t));
    d->size    = 0;
    d->idx_cap = 16;
    d->idx     = malloc(16 * sizeof(int64_t));
    memset(d->idx, 0xFF, 16 * sizeof(int64_t));
    return (int64_t)(uintptr_t)d;
}

static inline uint64_t nova_dict_hash_key(const char* s) {
    uint64_t h = 14695981039346656037ULL;
    while (*s) {
        h ^= (uint64_t)(unsigned char)*s++;
        h *= 1099511628211ULL;
    }
    return h;
}

int64_t nova_rt_dict_set(int64_t handle, int64_t key, int64_t val) {
    NovaDict* d = (NovaDict*)(uintptr_t)handle;
    const char* k = (const char*)(uintptr_t)key;
    uint64_t h = nova_dict_hash_key(k);
    int64_t slot = (int64_t)(h & (uint64_t)(d->idx_cap - 1));
    while (d->idx[slot] != DICT_IDX_EMPTY) {
        int64_t ei = d->idx[slot];
        if (d->hashes[ei] == h && strcmp((const char*)(uintptr_t)d->keys[ei], k) == 0) {
            nova_rc_dec(d->vals[ei]);
            d->vals[ei] = val;
            nova_rc_inc(val);
            return 0;
        }
        slot = (slot + 1) & (d->idx_cap - 1);
    }
    if (d->size >= d->cap) {
        d->cap *= 2;
        d->keys = realloc(d->keys, (size_t)d->cap * sizeof(int64_t));
        d->vals = realloc(d->vals, (size_t)d->cap * sizeof(int64_t));
        d->hashes = realloc(d->hashes, (size_t)d->cap * sizeof(uint64_t));
    }
    d->keys[d->size] = key;
    d->vals[d->size] = val;
    d->hashes[d->size] = h;
    nova_rc_inc(key);
    nova_rc_inc(val);
    d->idx[slot] = d->size;
    d->size++;
    dict_maybe_grow(d);
    return 0;
}

int64_t nova_rt_dict_get(int64_t handle, int64_t key) {
    NovaDict* d = (NovaDict*)(uintptr_t)handle;
    const char* k = (const char*)(uintptr_t)key;
    uint64_t h = nova_dict_hash_key(k);
    int64_t slot = (int64_t)(h & (uint64_t)(d->idx_cap - 1));
    while (d->idx[slot] != DICT_IDX_EMPTY) {
        int64_t ei = d->idx[slot];
        if (d->hashes[ei] == h && strcmp((const char*)(uintptr_t)d->keys[ei], k) == 0)
            return d->vals[ei];
        slot = (slot + 1) & (d->idx_cap - 1);
    }
    return 0;
}

int64_t nova_rt_dict_has(int64_t handle, int64_t key) {
    NovaDict* d = (NovaDict*)(uintptr_t)handle;
    const char* k = (const char*)(uintptr_t)key;
    uint64_t h = nova_dict_hash_key(k);
    int64_t slot = (int64_t)(h & (uint64_t)(d->idx_cap - 1));
    while (d->idx[slot] != DICT_IDX_EMPTY) {
        int64_t ei = d->idx[slot];
        if (d->hashes[ei] == h && strcmp((const char*)(uintptr_t)d->keys[ei], k) == 0) return 1;
        slot = (slot + 1) & (d->idx_cap - 1);
    }
    return 0;
}

int64_t nova_rt_dict_del(int64_t handle, int64_t key) {
    NovaDict* d = (NovaDict*)(uintptr_t)handle;
    const char* k = (const char*)(uintptr_t)key;
    uint64_t h = nova_dict_hash_key(k);
    int64_t slot = (int64_t)(h & (uint64_t)(d->idx_cap - 1));
    int64_t found = -1;
    while (d->idx[slot] != DICT_IDX_EMPTY) {
        int64_t ei = d->idx[slot];
        if (d->hashes[ei] == h && strcmp((const char*)(uintptr_t)d->keys[ei], k) == 0) {
            found = ei;
            break;
        }
        slot = (slot + 1) & (d->idx_cap - 1);
    }
    if (found < 0) return 0;
    nova_rc_dec(d->keys[found]);
    nova_rc_dec(d->vals[found]);
    for (int64_t j = found; j < d->size - 1; j++) {
        d->keys[j] = d->keys[j+1];
        d->vals[j] = d->vals[j+1];
        d->hashes[j] = d->hashes[j+1];
    }
    d->size--;
    dict_rebuild_index(d);
    return 1;
}

/* ── Fused concat-key dict ops (zero-allocation for GET, single-alloc for SET) ── */

int64_t nova_rt_dict_get_concat2(int64_t handle, int64_t a, int64_t b) {
    NovaDict* d = (NovaDict*)(uintptr_t)handle;
    const char* sa = (const char*)(uintptr_t)a;
    const char* sb = (const char*)(uintptr_t)b;

    uint64_t h = 14695981039346656037ULL;
    const char* p = sa;
    while (*p) { h ^= (uint64_t)(unsigned char)*p; h *= 1099511628211ULL; p++; }
    size_t la = (size_t)(p - sa);
    for (p = sb; *p; p++) { h ^= (uint64_t)(unsigned char)*p; h *= 1099511628211ULL; }

    int64_t slot = (int64_t)(h & (uint64_t)(d->idx_cap - 1));
    while (d->idx[slot] != DICT_IDX_EMPTY) {
        int64_t ei = d->idx[slot];
        if (d->hashes[ei] == h) {
            const char* stored = (const char*)(uintptr_t)d->keys[ei];
            if (memcmp(stored, sa, la) == 0 && strcmp(stored + la, sb) == 0)
                return d->vals[ei];
        }
        slot = (slot + 1) & (d->idx_cap - 1);
    }
    return 0;
}

int64_t nova_rt_dict_set_concat2(int64_t handle, int64_t a, int64_t b, int64_t val) {
    NovaDict* d = (NovaDict*)(uintptr_t)handle;
    const char* sa = (const char*)(uintptr_t)a;
    const char* sb = (const char*)(uintptr_t)b;

    uint64_t h = 14695981039346656037ULL;
    const char* p = sa;
    while (*p) { h ^= (uint64_t)(unsigned char)*p; h *= 1099511628211ULL; p++; }
    size_t la = (size_t)(p - sa);
    p = sb;
    while (*p) { h ^= (uint64_t)(unsigned char)*p; h *= 1099511628211ULL; p++; }
    size_t lb = (size_t)(p - sb);

    int64_t slot = (int64_t)(h & (uint64_t)(d->idx_cap - 1));
    while (d->idx[slot] != DICT_IDX_EMPTY) {
        int64_t ei = d->idx[slot];
        if (d->hashes[ei] == h) {
            const char* stored = (const char*)(uintptr_t)d->keys[ei];
            if (memcmp(stored, sa, la) == 0 && strcmp(stored + la, sb) == 0) {
                nova_rc_dec(d->vals[ei]);
                d->vals[ei] = val;
                nova_rc_inc(val);
                return 0;
            }
        }
        slot = (slot + 1) & (d->idx_cap - 1);
    }

    char* combined = (char*)nova_heap_alloc(la + lb + 1, NOVA_MEM_RAW);
    if (!combined) return 0;
    memcpy(combined, sa, la);
    memcpy(combined + la, sb, lb + 1);

    if (d->size >= d->cap) {
        d->cap *= 2;
        d->keys = realloc(d->keys, (size_t)d->cap * sizeof(int64_t));
        d->vals = realloc(d->vals, (size_t)d->cap * sizeof(int64_t));
        d->hashes = realloc(d->hashes, (size_t)d->cap * sizeof(uint64_t));
    }
    d->keys[d->size] = (int64_t)(uintptr_t)combined;
    d->vals[d->size] = val;
    d->hashes[d->size] = h;
    nova_rc_inc(val);
    d->idx[slot] = d->size;
    d->size++;
    dict_maybe_grow(d);
    return 0;
}

/* ── Deep copy: ownership safety — send/spawn copy values across processes ──
   Produces a structurally independent copy so two processes never share
   mutable heap state. Strings (immutable) and channels are shared by ref.
   A visited map handles cycles; a depth cap guards the C stack. */

typedef struct { int64_t* olds; int64_t* news; int64_t n; int64_t cap; } NovaCopyMap;

static int64_t nova_copymap_find(NovaCopyMap* m, int64_t key) {
    for (int64_t i = 0; i < m->n; i++)
        if (m->olds[i] == key) return m->news[i];
    return 0;
}

static void nova_copymap_put(NovaCopyMap* m, int64_t key, int64_t val) {
    if (m->n >= m->cap) {
        int64_t nc = m->cap < 16 ? 16 : m->cap * 2;
        int64_t* no = (int64_t*)realloc(m->olds, (size_t)nc * sizeof(int64_t));
        if (!no) return;                 /* OOM: keep old map; depth cap backstops */
        m->olds = no;
        int64_t* nn = (int64_t*)realloc(m->news, (size_t)nc * sizeof(int64_t));
        if (!nn) return;
        m->news = nn;
        m->cap = nc;
    }
    m->olds[m->n] = key; m->news[m->n] = val; m->n++;
}

static int64_t nova_deep_copy_rec(int64_t v, NovaCopyMap* m, int depth) {
    if ((uint64_t)v < 0x10000ULL) return v;
    if (depth > 10000) { nova_rc_inc(v); return v; }   /* stack guard: share */
    void* p = (void*)(uintptr_t)v;
    NovaMemTag tag = nova_mem_find_tag(p);
    if (tag == NOVA_MEM_LIST) {
        int64_t hit = nova_copymap_find(m, v);
        if (hit) { nova_rc_inc(hit); return hit; }
        NovaList* src = (NovaList*)p;
        int64_t dst = nova_rt_list_create();
        if (!dst) { nova_rc_inc(v); return v; }
        nova_copymap_put(m, v, dst);
        for (int64_t i = 0; i < src->size; i++) {
            int64_t e = nova_deep_copy_rec(src->data[i], m, depth + 1);
            nova_rt_list_append(dst, e);
            nova_rc_dec(e);
        }
        return dst;
    }
    if (tag == NOVA_MEM_DICT) {
        int64_t hit = nova_copymap_find(m, v);
        if (hit) { nova_rc_inc(hit); return hit; }
        NovaDict* src = (NovaDict*)p;
        int64_t dst = nova_rt_dict_create();
        if (!dst) { nova_rc_inc(v); return v; }
        nova_copymap_put(m, v, dst);
        for (int64_t i = 0; i < src->size; i++) {
            int64_t k   = nova_deep_copy_rec(src->keys[i], m, depth + 1);
            int64_t val = nova_deep_copy_rec(src->vals[i], m, depth + 1);
            nova_rt_dict_set(dst, k, val);
            nova_rc_dec(k);
            nova_rc_dec(val);
        }
        return dst;
    }
    if (tag == NOVA_MEM_STRUCT) {
        int64_t hit = nova_copymap_find(m, v);
        if (hit) { nova_rc_inc(hit); return hit; }
        int64_t nslots = NOVA_STRUCT_NSLOTS(p);
        int64_t* src = (int64_t*)p;
        int64_t* dst = (int64_t*)nova_rt_struct_alloc(nslots * 8);
        if (!dst) { nova_rc_inc(v); return v; }
        nova_copymap_put(m, v, (int64_t)(uintptr_t)dst);
        if (nslots > 0) dst[0] = src[0];               /* type hash / fn ptr */
        for (int64_t i = 1; i < nslots; i++)
            dst[i] = nova_deep_copy_rec(src[i], m, depth + 1);
        return (int64_t)(uintptr_t)dst;
    }
    if (tag == NOVA_MEM_RAW || tag == NOVA_MEM_FAT_STR || tag == NOVA_MEM_CHANNEL) {
        /* strings are immutable; channels are the shared comm primitive */
        nova_rc_inc(v);
        return v;
    }
    return v;   /* unmanaged pointer or scalar — nothing to copy */
}

int64_t nova_rt_deep_copy(int64_t v) {
    NovaCopyMap m;
    m.olds = NULL; m.news = NULL; m.n = 0; m.cap = 0;
    int64_t r = nova_deep_copy_rec(v, &m, 0);
    free(m.olds);
    free(m.news);
    return r;
}

int64_t nova_rt_dict_len(int64_t handle) {
    NovaDict* d = (NovaDict*)(uintptr_t)handle;
    return d->size;
}

int64_t nova_rt_dict_keys(int64_t handle) {
    NovaDict* d = (NovaDict*)(uintptr_t)handle;
    int64_t list = nova_rt_list_create();
    for (int64_t i = 0; i < d->size; i++)
        nova_rt_list_append(list, d->keys[i]);
    return list;
}

int64_t nova_rt_dict_values(int64_t handle) {
    NovaDict* d = (NovaDict*)(uintptr_t)handle;
    int64_t list = nova_rt_list_create();
    for (int64_t i = 0; i < d->size; i++)
        nova_rt_list_append(list, d->vals[i]);
    return list;
}

int64_t nova_rt_dict_items(int64_t handle) {
    NovaDict* d = (NovaDict*)(uintptr_t)handle;
    int64_t list = nova_rt_list_create();
    for (int64_t i = 0; i < d->size; i++) {
        int64_t pair = nova_rt_list_create();
        nova_rt_list_append(pair, d->keys[i]);
        nova_rt_list_append(pair, d->vals[i]);
        nova_rt_list_append(list, pair);
    }
    return list;
}

int64_t nova_rt_for_iter_init(int64_t obj) {
    if (obj == 0) return nova_rt_list_create();
    void* ptr = (void*)(uintptr_t)obj;
    NovaMemTag tag = nova_mem_find_tag(ptr);
    if (tag == NOVA_MEM_DICT) {
        return nova_rt_dict_keys(obj);
    }
    return obj;
}

/* ── Character operations ────────────────────────────────────────────────── */

int64_t nova_rt_ord(int64_t s) {
    const char* p = (const char*)(uintptr_t)s;
    if (!p || !*p) return 0;
    return (int64_t)(unsigned char)p[0];
}

int64_t nova_rt_chr(int64_t n) {
    char* buf = (char*)nova_heap_alloc(2, NOVA_MEM_RAW);
    if (!buf) return 0;
    buf[0] = (char)(n & 0xFF);
    buf[1] = '\0';
    return (int64_t)(uintptr_t)buf;
}

/* ── Process control ─────────────────────────────────────────────────────── */

void nova_rt_cleanup(void);  /* forward declaration */
void nova_rt_exit(int64_t code) {
    nova_rt_cleanup();
    exit((int)code);
}

/* ── Process execution ────────────────────────────────────────────────────── */

int64_t nova_rt_system(int64_t cmd_str) {
    const char* cmd = (const char*)(uintptr_t)cmd_str;
    if (!cmd) return -1;
    int ret = system(cmd);
    return (int64_t)ret;
}

int64_t nova_rt_exec(int64_t cmd_str) {
    const char* cmd = (const char*)(uintptr_t)cmd_str;
    if (!cmd) return (int64_t)(uintptr_t)nova_fat_str_create("", 0);
#ifdef _WIN32
    FILE* fp = _popen(cmd, "r");
#else
    FILE* fp = popen(cmd, "r");
#endif
    if (!fp) return (int64_t)(uintptr_t)nova_fat_str_create("", 0);
    char buf[4096];
    size_t total_len = 0;
    size_t cap = 4096;
    char* result = (char*)malloc(cap);
    if (!result) {
#ifdef _WIN32
        _pclose(fp);
#else
        pclose(fp);
#endif
        return (int64_t)(uintptr_t)nova_fat_str_create("", 0);
    }
    result[0] = '\0';
    while (fgets(buf, sizeof(buf), fp)) {
        size_t chunk_len = strlen(buf);
        if (total_len + chunk_len + 1 > cap) {
            cap = (total_len + chunk_len + 1) * 2;
            char* tmp = (char*)realloc(result, cap);
            if (!tmp) break;
            result = tmp;
        }
        memcpy(result + total_len, buf, chunk_len);
        total_len += chunk_len;
        result[total_len] = '\0';
    }
#ifdef _WIN32
    _pclose(fp);
#else
    pclose(fp);
#endif
    int64_t s = (int64_t)(uintptr_t)nova_fat_str_create(result, total_len);
    free(result);
    return s;
}

/* ── Filesystem utilities ────────────────────────────────────────────────── */

int64_t nova_rt_mkdir(int64_t path_val) {
    const char* path = (const char*)(uintptr_t)path_val;
    if (!path) return 0;
#ifdef _WIN32
    BOOL ok = CreateDirectoryA(path, NULL);
    if (!ok && GetLastError() != ERROR_ALREADY_EXISTS) return 0;
#else
    int ret = mkdir(path, 0755);
    if (ret != 0 && errno != EEXIST) return 0;
#endif
    return 1;
}

int64_t nova_rt_mkdir_p(int64_t path_val) {
    const char* path = (const char*)(uintptr_t)path_val;
    if (!path) return 0;
    size_t len = strlen(path);
    if (len == 0) return 0;
    char* buf = (char*)malloc(len + 1);
    if (!buf) return 0;
    memcpy(buf, path, len + 1);
    for (size_t i = 1; i <= len; i++) {
        if (buf[i] == '/' || buf[i] == '\\' || buf[i] == '\0') {
            char saved = buf[i];
            buf[i] = '\0';
#ifdef _WIN32
            CreateDirectoryA(buf, NULL);
#else
            mkdir(buf, 0755);
#endif
            buf[i] = saved;
        }
    }
    free(buf);
    return 1;
}

int64_t nova_rt_path_join(int64_t base_val, int64_t child_val) {
    const char* base = (const char*)(uintptr_t)base_val;
    const char* child = (const char*)(uintptr_t)child_val;
    if (!base || !child) return (int64_t)(uintptr_t)nova_fat_str_create("", 0);
    size_t blen = strlen(base);
    size_t clen = strlen(child);
    int need_sep = 0;
    if (blen > 0 && base[blen-1] != '/' && base[blen-1] != '\\') need_sep = 1;
    size_t total = blen + need_sep + clen;
    char* buf = (char*)malloc(total + 1);
    if (!buf) return (int64_t)(uintptr_t)nova_fat_str_create("", 0);
    memcpy(buf, base, blen);
#ifdef _WIN32
    if (need_sep) buf[blen] = '\\';
#else
    if (need_sep) buf[blen] = '/';
#endif
    memcpy(buf + blen + need_sep, child, clen);
    buf[total] = '\0';
    int64_t s = (int64_t)(uintptr_t)nova_fat_str_create(buf, total);
    free(buf);
    return s;
}

int64_t nova_rt_path_exists(int64_t path_val) {
    const char* path = (const char*)(uintptr_t)path_val;
    if (!path) return 0;
#ifdef _WIN32
    DWORD attr = GetFileAttributesA(path);
    return (attr != INVALID_FILE_ATTRIBUTES) ? 1 : 0;
#else
    struct stat st;
    return (stat(path, &st) == 0) ? 1 : 0;
#endif
}

/* ── Type conversions ─────────────────────────────────────────────────────── */

int64_t nova_rt_parse_int(int64_t s) {
    return atoll((const char*)(uintptr_t)s);
}

int64_t nova_rt_parse_float(int64_t s) {
    double d = atof((const char*)(uintptr_t)s);
    int64_t bits;
    memcpy(&bits, &d, sizeof(double));
    return bits;
}

/* ── IO ───────────────────────────────────────────────────────────────────── */

int64_t nova_rt_read_line(void) {
    char* buf = (char*)nova_heap_alloc(4096, NOVA_MEM_RAW);
    if (!buf) return 0;
    if (!fgets(buf, 4096, stdin)) { buf[0] = '\0'; return (int64_t)(uintptr_t)buf; }
    size_t len = strlen(buf);
    if (len > 0 && buf[len-1] == '\n') buf[len-1] = '\0';
    if (len > 1 && buf[len-2] == '\r') buf[len-2] = '\0';
    return (int64_t)(uintptr_t)buf;
}

/* Read exactly N bytes from stdin. Returns a heap-tracked string. */
int64_t nova_rt_stdin_read_n(int64_t n) {
    if (n <= 0) return (int64_t)(uintptr_t)"";
    size_t want = (size_t)n;
    char* buf = (char*)nova_heap_alloc(want + 1, NOVA_MEM_RAW);
    if (!buf) return (int64_t)(uintptr_t)"";
    size_t got = 0;
    while (got < want) {
        size_t r = fread(buf + got, 1, want - got, stdin);
        if (r == 0) break;
        got += r;
    }
    buf[got] = '\0';
    return (int64_t)(uintptr_t)buf;
}

/* Write raw bytes to stdout — no newline appended, no buffering surprises.
   On Windows, the C runtime defaults stdout to text mode and translates
   `\n` -> `\r\n`. For LSP/JSON-RPC framing where Content-Length must match
   actual bytes, we put stdout in binary mode on first use. */
static int nova_stdout_binary_inited = 0;
void nova_rt_stdout_write(int64_t s_ptr) {
    const char* s = (const char*)(uintptr_t)s_ptr;
    if (!s) return;
#ifdef _WIN32
    if (!nova_stdout_binary_inited) {
        _setmode(_fileno(stdout), 0x8000 /* _O_BINARY */);
        nova_stdout_binary_inited = 1;
    }
#endif
    size_t len = strlen(s);
    fwrite(s, 1, len, stdout);
    fflush(stdout);
}

/* Write raw bytes to stderr. Used by `write_raw` builtin so LSP servers and
   other stdio-protocol tools can log without corrupting their stdout stream. */
void nova_rt_write_raw(int64_t s_ptr) {
    const char* s = (const char*)(uintptr_t)s_ptr;
    if (!s) return;
    size_t len = strlen(s);
    fwrite(s, 1, len, stderr);
    fflush(stderr);
}

int64_t nova_rt_read_file(int64_t path) {
    const char* p = (const char*)(uintptr_t)path;
    FILE* f = fopen(p, "rb");
    if (!f) {
        char errbuf[512];
        snprintf(errbuf, sizeof(errbuf), "cannot open file '%s': %s", p, strerror(errno));
        nova_set_error(errbuf);
        char* e = (char*)nova_heap_alloc(1, NOVA_MEM_RAW); if(e) e[0] = '\0';
        return (int64_t)(uintptr_t)e;
    }
#ifdef _WIN32
    _fseeki64(f, 0, SEEK_END);
    int64_t sz = _ftelli64(f);
    _fseeki64(f, 0, SEEK_SET);
#else
    fseeko(f, 0, SEEK_END);
    int64_t sz = (int64_t)ftello(f);
    fseeko(f, 0, SEEK_SET);
#endif
    if (sz < 0 || sz > (int64_t)512 * 1024 * 1024) {
        fclose(f);
        nova_set_error(sz < 0 ? "read_file: cannot determine size"
                               : "read_file: file exceeds 512MB limit");
        char* e = (char*)nova_heap_alloc(1, NOVA_MEM_RAW); if(e) e[0] = '\0';
        return (int64_t)(uintptr_t)e;
    }
    char* buf = (char*)nova_heap_alloc((size_t)sz + 1, NOVA_MEM_RAW);
    if (!buf) {
        fclose(f);
        nova_set_error("read_file: out of memory");
        return 0;
    }
    size_t nr = fread(buf, 1, (size_t)sz, f);
    buf[nr] = '\0';
    fclose(f);
    return (int64_t)(uintptr_t)buf;
}

int64_t nova_rt_write_file(int64_t path, int64_t content) {
    const char* p = (const char*)(uintptr_t)path;
    const char* c = (const char*)(uintptr_t)content;
    FILE* f = fopen(p, "wb");
    if (!f) {
        char errbuf[512];
        snprintf(errbuf, sizeof(errbuf), "cannot write file '%s': %s", p, strerror(errno));
        nova_set_error(errbuf);
        return -1;
    }
    size_t len = strlen(c);
    fwrite(c, 1, len, f);
    fclose(f);
    return 0;
}

int64_t nova_rt_append_file(int64_t path, int64_t content) {
    const char* p = (const char*)(uintptr_t)path;
    const char* c = (const char*)(uintptr_t)content;
    FILE* f = fopen(p, "ab");
    if (!f) {
        char errbuf[512];
        snprintf(errbuf, sizeof(errbuf), "cannot append to file '%s': %s", p, strerror(errno));
        nova_set_error(errbuf);
        return -1;
    }
    size_t len = strlen(c);
    fwrite(c, 1, len, f);
    fclose(f);
    return 0;
}

int64_t nova_rt_file_exists(int64_t path) {
    const char* p = (const char*)(uintptr_t)path;
    FILE* f = fopen(p, "r");
    if (f) { fclose(f); return 1; }
    return 0;
}

/* ── JSON Parser (recursive descent) ──────────────────────────────────────── */

#define JSON_MAX_DEPTH 128

typedef struct {
    const char* src;
    int64_t     pos;
    int64_t     len;
    int         depth;
} JsonParser;

static void json_skip_ws(JsonParser* p) {
    while (p->pos < p->len) {
        char c = p->src[p->pos];
        if (c == ' ' || c == '\t' || c == '\n' || c == '\r') p->pos++;
        else break;
    }
}

static int json_at_end(JsonParser* p) { return p->pos >= p->len; }

static int64_t json_parse_value(JsonParser* p);

static int64_t json_make_str(const char* s, int64_t len) {
    char* buf = (char*)nova_heap_alloc((size_t)len + 1, NOVA_MEM_RAW);
    if (!buf) return 0;
    memcpy(buf, s, (size_t)len);
    buf[len] = '\0';
    return (int64_t)(uintptr_t)buf;
}

static int64_t json_parse_string(JsonParser* p) {
    p->pos++; // skip opening "
    int64_t start = p->pos;
    int has_escape = 0;
    while (p->pos < p->len && p->src[p->pos] != '"') {
        if (p->src[p->pos] == '\\') {
            has_escape = 1;
            p->pos++;
            if (p->pos < p->len) p->pos++;
        }
        else p->pos++;
    }
    int64_t raw_len = p->pos - start;
    if (p->pos < p->len) p->pos++; // skip closing " (only if present)

    if (!has_escape) {
        return json_make_str(p->src + start, raw_len);
    }
    char* buf = (char*)nova_heap_alloc((size_t)raw_len + 1, NOVA_MEM_RAW);
    if (!buf) return 0;
    int64_t out = 0;
    for (int64_t i = start; i < start + raw_len; ) {
        if (p->src[i] == '\\' && i + 1 < start + raw_len) {
            i++;
            switch (p->src[i]) {
                case '"':  buf[out++] = '"'; break;
                case '\\': buf[out++] = '\\'; break;
                case '/':  buf[out++] = '/'; break;
                case 'n':  buf[out++] = '\n'; break;
                case 't':  buf[out++] = '\t'; break;
                case 'r':  buf[out++] = '\r'; break;
                case 'b':  buf[out++] = '\b'; break;
                case 'f':  buf[out++] = '\f'; break;
                case 'u': {
                    int64_t remain = (start + raw_len) - (i + 1);
                    int skip = remain >= 4 ? 4 : (int)remain;
                    buf[out++] = '?';
                    i += skip;
                    break;
                }
                default:   buf[out++] = p->src[i]; break;
            }
            i++;
        } else {
            buf[out++] = p->src[i++];
        }
    }
    buf[out] = '\0';
    return (int64_t)(uintptr_t)buf;
}

static int64_t json_parse_number(JsonParser* p) {
    int64_t start = p->pos;
    int is_float = 0;
    if (p->pos < p->len && p->src[p->pos] == '-') p->pos++;
    while (p->pos < p->len && p->src[p->pos] >= '0' && p->src[p->pos] <= '9') p->pos++;
    if (p->pos < p->len && p->src[p->pos] == '.') {
        is_float = 1; p->pos++;
        while (p->pos < p->len && p->src[p->pos] >= '0' && p->src[p->pos] <= '9') p->pos++;
    }
    if (p->pos < p->len && (p->src[p->pos] == 'e' || p->src[p->pos] == 'E')) {
        is_float = 1; p->pos++;
        if (p->pos < p->len && (p->src[p->pos] == '+' || p->src[p->pos] == '-')) p->pos++;
        while (p->pos < p->len && p->src[p->pos] >= '0' && p->src[p->pos] <= '9') p->pos++;
    }
    if (is_float) {
        double val = strtod(p->src + start, NULL);
        int64_t bits;
        memcpy(&bits, &val, sizeof(bits));
        return bits;
    } else {
        int64_t val = 0;
        int neg = 0;
        int64_t i = start;
        if (p->src[i] == '-') { neg = 1; i++; }
        while (i < p->pos) { val = val * 10 + (p->src[i] - '0'); i++; }
        return neg ? -val : val;
    }
}

static int64_t json_parse_object(JsonParser* p) {
    p->pos++; // skip {
    int64_t dict = nova_rt_dict_create();
    json_skip_ws(p);
    if (!json_at_end(p) && p->src[p->pos] == '}') { p->pos++; return dict; }
    for (;;) {
        json_skip_ws(p);
        if (json_at_end(p)) { nova_set_error("JSON: unterminated object"); break; }
        if (p->src[p->pos] != '"') { nova_set_error("JSON: expected string key"); break; }
        int64_t key = json_parse_string(p);
        json_skip_ws(p);
        if (json_at_end(p) || p->src[p->pos] != ':') { nova_set_error("JSON: expected ':'"); break; }
        p->pos++; // skip :
        int64_t val = json_parse_value(p);
        nova_rt_dict_set(dict, key, val);
        json_skip_ws(p);
        if (json_at_end(p)) break;
        if (p->src[p->pos] == ',') { p->pos++; continue; }
        if (p->src[p->pos] == '}') { p->pos++; break; }
        nova_set_error("JSON: unexpected char in object");
        break;
    }
    return dict;
}

static int64_t json_parse_array(JsonParser* p) {
    p->pos++; // skip [
    int64_t list = nova_rt_list_create();
    json_skip_ws(p);
    if (!json_at_end(p) && p->src[p->pos] == ']') { p->pos++; return list; }
    for (;;) {
        int64_t val = json_parse_value(p);
        nova_rt_list_append(list, val);
        json_skip_ws(p);
        if (json_at_end(p)) break;
        if (p->src[p->pos] == ',') { p->pos++; continue; }
        if (p->src[p->pos] == ']') { p->pos++; break; }
        nova_set_error("JSON: unexpected char in array");
        break;
    }
    return list;
}

static int json_remaining(JsonParser* p, int64_t need) {
    return (p->len - p->pos) >= need;
}

static int64_t json_parse_value(JsonParser* p) {
    json_skip_ws(p);
    if (json_at_end(p)) { nova_set_error("JSON: unexpected end of input"); return 0; }
    if (p->depth >= JSON_MAX_DEPTH) { nova_set_error("JSON: nesting too deep"); return 0; }
    p->depth++;
    int64_t result;
    char c = p->src[p->pos];
    switch (c) {
        case '"': result = json_parse_string(p); break;
        case '{': result = json_parse_object(p); break;
        case '[': result = json_parse_array(p); break;
        case 't':
            if (json_remaining(p, 4) && memcmp(p->src + p->pos, "true", 4) == 0) { p->pos += 4; result = 1; }
            else { nova_set_error("JSON: expected 'true'"); p->pos = p->len; result = 0; }
            break;
        case 'f':
            if (json_remaining(p, 5) && memcmp(p->src + p->pos, "false", 5) == 0) { p->pos += 5; result = 0; }
            else { nova_set_error("JSON: expected 'false'"); p->pos = p->len; result = 0; }
            break;
        case 'n':
            if (json_remaining(p, 4) && memcmp(p->src + p->pos, "null", 4) == 0) { p->pos += 4; result = 0; }
            else { nova_set_error("JSON: expected 'null'"); p->pos = p->len; result = 0; }
            break;
        default:
            if (c == '-' || (c >= '0' && c <= '9'))
                result = json_parse_number(p);
            else {
                nova_set_error("JSON: unexpected character");
                result = 0;
            }
            break;
    }
    p->depth--;
    return result;
}

int64_t nova_rt_json_parse(int64_t input) {
    const char* s = (const char*)(uintptr_t)input;
    if (!s || *s == '\0') {
        nova_set_error("JSON: empty input");
        return 0;
    }
    JsonParser parser;
    parser.src = s;
    parser.pos = 0;
    parser.len = (int64_t)strlen(s);
    parser.depth = 0;
    return json_parse_value(&parser);
}

/* ── JSON Stringify ────────────────────────────────────────────────────────── */

typedef struct {
    char*   buf;
    int64_t len;
    int64_t cap;
} JsonBuf;

static void jbuf_init(JsonBuf* b) {
    b->cap = 256;
    b->buf = malloc((size_t)b->cap);
    b->len = 0;
}

static void jbuf_append(JsonBuf* b, const char* s, int64_t n) {
    while (b->len + n >= b->cap) {
        b->cap *= 2;
        b->buf = realloc(b->buf, (size_t)b->cap);
    }
    memcpy(b->buf + b->len, s, (size_t)n);
    b->len += n;
}

static void jbuf_char(JsonBuf* b, char c) { jbuf_append(b, &c, 1); }

static void json_stringify_value(JsonBuf* b, int64_t val, int depth);

static void json_stringify_str(JsonBuf* b, const char* s) {
    jbuf_char(b, '"');
    while (*s) {
        switch (*s) {
            case '"':  jbuf_append(b, "\\\"", 2); break;
            case '\\': jbuf_append(b, "\\\\", 2); break;
            case '\n': jbuf_append(b, "\\n", 2); break;
            case '\t': jbuf_append(b, "\\t", 2); break;
            case '\r': jbuf_append(b, "\\r", 2); break;
            default:   jbuf_char(b, *s); break;
        }
        s++;
    }
    jbuf_char(b, '"');
}

/* nova_mem_find_tag is defined above in the memory registry section */

static void json_stringify_value(JsonBuf* b, int64_t val, int depth) {
    if (depth > 32) { jbuf_append(b, "null", 4); return; }
    if (val == 0) { jbuf_append(b, "null", 4); return; }

    void* ptr = (void*)(uintptr_t)val;
    NovaMemTag tag = nova_mem_find_tag(ptr);
    if (tag == NOVA_MEM_DICT) {
        NovaDict* d = (NovaDict*)ptr;
        jbuf_char(b, '{');
        for (int64_t i = 0; i < d->size; i++) {
            if (i > 0) jbuf_char(b, ',');
            json_stringify_str(b, (const char*)(uintptr_t)d->keys[i]);
            jbuf_char(b, ':');
            json_stringify_value(b, d->vals[i], depth + 1);
        }
        jbuf_char(b, '}');
        return;
    }
    if (tag == NOVA_MEM_LIST) {
        NovaList* l = (NovaList*)ptr;
        jbuf_char(b, '[');
        for (int64_t i = 0; i < l->size; i++) {
            if (i > 0) jbuf_char(b, ',');
            json_stringify_value(b, l->data[i], depth + 1);
        }
        jbuf_char(b, ']');
        return;
    }
    if (tag == NOVA_MEM_RAW) {
        json_stringify_str(b, (const char*)ptr);
        return;
    }
    if ((uint64_t)val > 0x10000 && nova_is_readable_str(ptr)) {
        unsigned char c = *(unsigned char*)ptr;
        if (c == 0 || (c >= 0x20 && c < 0x7F)) {
            json_stringify_str(b, (const char*)ptr);
            return;
        }
    }
    if (val == 1) { jbuf_append(b, "true", 4); return; }
    char nbuf[32];
    snprintf(nbuf, sizeof(nbuf), "%lld", (long long)val);
    jbuf_append(b, nbuf, (int64_t)strlen(nbuf));
}

int64_t nova_rt_json_stringify(int64_t val) {
    JsonBuf b;
    jbuf_init(&b);
    json_stringify_value(&b, val, 0);
    jbuf_char(&b, '\0');
    char* tracked = (char*)nova_heap_alloc((size_t)b.len, NOVA_MEM_RAW);
    if (tracked) memcpy(tracked, b.buf, (size_t)b.len);
    free(b.buf);
    return (int64_t)(uintptr_t)tracked;
}

/* ── Runtime type dispatch for Any-typed values ──────────────────────────── */

int64_t nova_rt_any_to_str(int64_t val) {
    if (val == 0) return nova_rt_int_to_str(0);
    void* ptr = (void*)(uintptr_t)val;
    NovaMemTag tag = nova_mem_find_tag(ptr);
    switch (tag) {
        case NOVA_MEM_RAW:      return val;
        case NOVA_MEM_FAT_STR:  return val;
        case NOVA_MEM_LIST:     return nova_rt_list_to_str(val);
        case NOVA_MEM_DICT:     return nova_rt_json_stringify(val);
        case NOVA_MEM_STRUCT:   return (int64_t)(uintptr_t)"<struct>";
        case NOVA_MEM_ITER:     return (int64_t)(uintptr_t)"<iter>";
        default:
            if ((uint64_t)val > 0x10000 && nova_is_readable_str(ptr)) {
                unsigned char c = *(unsigned char*)ptr;
                if (c == 0 || (c >= 0x20 && c < 0x7F)) return val;
            }
            if (val < -(1LL << 52) || val > (1LL << 52)) {
                uint64_t exp = ((uint64_t)val >> 52) & 0x7FF;
                if (exp > 0 && exp < 0x7FF)
                    return nova_rt_float_to_str(val);
            }
            return nova_rt_int_to_str(val);
    }
}

int64_t nova_rt_str_concat_safe(int64_t a, int64_t b) {
    if (a == 0 && b == 0) {
        char* r = (char*)nova_heap_alloc(1, NOVA_MEM_RAW); if(r) r[0] = '\0';
        return (int64_t)(uintptr_t)r;
    }
    int64_t sa = (a != 0) ? a : nova_rt_any_to_str(0);
    int64_t sb = (b != 0) ? b : nova_rt_any_to_str(0);
    void* pa = (void*)(uintptr_t)sa;
    void* pb = (void*)(uintptr_t)sb;
    NovaMemTag ta = nova_mem_find_tag(pa);
    NovaMemTag tb = nova_mem_find_tag(pb);
    if (ta != NOVA_MEM_RAW && ta != NOVA_MEM_FAT_STR && ta != (NovaMemTag)-1) sa = nova_rt_any_to_str(sa);
    if (tb != NOVA_MEM_RAW && tb != NOVA_MEM_FAT_STR && tb != (NovaMemTag)-1) sb = nova_rt_any_to_str(sb);
    return nova_rt_str_concat(sa, sb);
}

static inline int nova_is_likely_float(int64_t v) {
    if (v == 0) return 0;
    if (v > -(1LL << 52) && v < (1LL << 52)) return 0;
    uint64_t exp = ((uint64_t)v >> 52) & 0x7FF;
    return (exp > 0 && exp < 0x7FF);
}

static inline double nova_to_double(int64_t v) {
    if (nova_is_likely_float(v)) {
        double d; memcpy(&d, &v, 8); return d;
    }
    return (double)v;
}

static inline int64_t nova_from_double(double d) {
    int64_t v; memcpy(&v, &d, 8); return v;
}

int64_t nova_rt_add(int64_t a, int64_t b) {
    void* pa = (void*)(uintptr_t)a;
    void* pb = (void*)(uintptr_t)b;
    NovaMemTag ta = nova_mem_find_tag(pa);
    NovaMemTag tb = nova_mem_find_tag(pb);
    int a_is_str = (ta == NOVA_MEM_RAW || ta == NOVA_MEM_FAT_STR ||
                    ((uint64_t)a > 0x10000 && ta == (NovaMemTag)-1 && nova_is_readable_str(pa)));
    int b_is_str = (tb == NOVA_MEM_RAW || tb == NOVA_MEM_FAT_STR ||
                    ((uint64_t)b > 0x10000 && tb == (NovaMemTag)-1 && nova_is_readable_str(pb)));
    if (a_is_str || b_is_str)
        return nova_rt_str_concat_safe(a, b);
    if (nova_is_likely_float(a) || nova_is_likely_float(b))
        return nova_from_double(nova_to_double(a) + nova_to_double(b));
    return a + b;
}

int64_t nova_rt_sub(int64_t a, int64_t b) {
    if (nova_is_likely_float(a) || nova_is_likely_float(b))
        return nova_from_double(nova_to_double(a) - nova_to_double(b));
    return a - b;
}

int64_t nova_rt_mul(int64_t a, int64_t b) {
    if (nova_is_likely_float(a) || nova_is_likely_float(b))
        return nova_from_double(nova_to_double(a) * nova_to_double(b));
    return a * b;
}

int64_t nova_rt_div(int64_t a, int64_t b) {
    if (nova_is_likely_float(a) || nova_is_likely_float(b))
        return nova_from_double(nova_to_double(a) / nova_to_double(b));
    if (b == 0) return 0;
    return a / b;
}

int64_t nova_rt_print_float(int64_t bits) {
    int64_t s = nova_rt_float_to_str(bits);
    puts((const char*)(uintptr_t)s);
    return 0;
}

int64_t nova_rt_eq(int64_t a, int64_t b) {
    if (a == b) return 1;
    void* pa = (void*)(uintptr_t)a;
    void* pb = (void*)(uintptr_t)b;
    NovaMemTag ta = nova_mem_find_tag(pa);
    NovaMemTag tb = nova_mem_find_tag(pb);
    if (ta == NOVA_MEM_RAW || ta == NOVA_MEM_FAT_STR ||
        ((uint64_t)a > 0x10000 && ta == (NovaMemTag)-1 && nova_is_readable_str(pa))) {
        if ((uint64_t)b < 0x10000) return 0;
        return (strcmp((const char*)pa, (const char*)pb) == 0) ? 1 : 0;
    }
    if (ta == NOVA_MEM_LIST && tb == NOVA_MEM_LIST) {
        NovaList* la = (NovaList*)(uintptr_t)a;
        NovaList* lb = (NovaList*)(uintptr_t)b;
        if (la->size != lb->size) return 0;
        for (int64_t i = 0; i < la->size; i++) {
            if (!nova_rt_eq(la->data[i], lb->data[i])) return 0;
        }
        return 1;
    }
    if (ta == NOVA_MEM_DICT && tb == NOVA_MEM_DICT) {
        NovaDict* da = (NovaDict*)(uintptr_t)a;
        NovaDict* db = (NovaDict*)(uintptr_t)b;
        if (da->size != db->size) return 0;
        for (int64_t i = 0; i < da->size; i++) {
            int found = 0;
            for (int64_t j = 0; j < db->size; j++) {
                if (nova_rt_eq(da->keys[i], db->keys[j])) {
                    if (!nova_rt_eq(da->vals[i], db->vals[j])) return 0;
                    found = 1;
                    break;
                }
            }
            if (!found) return 0;
        }
        return 1;
    }
    return 0;
}

int64_t nova_rt_neq(int64_t a, int64_t b) {
    return nova_rt_eq(a, b) ? 0 : 1;
}

int64_t nova_rt_type_of(int64_t val) {
    if (val == 0) return (int64_t)(uintptr_t)"int";
    void* ptr = (void*)(uintptr_t)val;
    NovaMemTag tag = nova_mem_find_tag(ptr);
    switch (tag) {
        case NOVA_MEM_LIST:     return (int64_t)(uintptr_t)"list";
        case NOVA_MEM_DICT:     return (int64_t)(uintptr_t)"dict";
        case NOVA_MEM_CHANNEL:  return (int64_t)(uintptr_t)"channel";
        case NOVA_MEM_RAW:      return (int64_t)(uintptr_t)"string";
        case NOVA_MEM_FAT_STR:  return (int64_t)(uintptr_t)"string";
        case NOVA_MEM_STRUCT:   return (int64_t)(uintptr_t)"struct";
        case NOVA_MEM_ITER:     return (int64_t)(uintptr_t)"iter";
        default:
            if ((uint64_t)val > 0x10000 && nova_is_readable_str(ptr))
                return (int64_t)(uintptr_t)"string";
            return (int64_t)(uintptr_t)"int";
    }
}

int64_t nova_rt_print_any(int64_t val) {
    int64_t s = nova_rt_any_to_str(val);
    puts((const char*)(uintptr_t)s);
    return 0;
}

int64_t nova_rt_print_bool(int64_t val) {
    puts(val ? "true" : "false");
    return 0;
}

int64_t nova_rt_print_int(int64_t val) {
    char buf[32];
    snprintf(buf, sizeof(buf), "%lld", (long long)val);
    puts(buf);
    return 0;
}

int64_t nova_rt_print_str(int64_t val) {
    puts((const char*)(uintptr_t)val);
    return 0;
}

/* ── Channel (thread-safe blocking queue with close support) ─────────────── */

typedef struct {
    int64_t* buf;
    int64_t  cap;
    int64_t  head;
    int64_t  count;
    int64_t  closed;
#ifdef _WIN32
    CRITICAL_SECTION lock;
    CONDITION_VARIABLE not_empty;
#else
    pthread_mutex_t lock;
    pthread_cond_t not_empty;
#endif
} NovaChannel;

int64_t nova_rt_channel_create(void) {
    NovaChannel* ch = (NovaChannel*)nova_heap_alloc(sizeof(NovaChannel), NOVA_MEM_CHANNEL);
    if (!ch) return 0;
    ch->buf = malloc(16 * sizeof(int64_t));
    ch->cap = 16;
    ch->head = 0;
    ch->count = 0;
    ch->closed = 0;
#ifdef _WIN32
    InitializeCriticalSection(&ch->lock);
    InitializeConditionVariable(&ch->not_empty);
#else
    pthread_mutex_init(&ch->lock, NULL);
    pthread_cond_init(&ch->not_empty, NULL);
#endif
    return (int64_t)(uintptr_t)ch;
}

static void channel_enqueue(NovaChannel* ch, int64_t value) {
    if (ch->count >= ch->cap) {
        int64_t new_cap = ch->cap * 2;
        int64_t* new_buf = malloc((size_t)new_cap * sizeof(int64_t));
        int64_t mask = ch->cap - 1;
        for (int64_t i = 0; i < ch->count; i++)
            new_buf[i] = ch->buf[(ch->head + i) & mask];
        free(ch->buf);
        ch->buf = new_buf;
        ch->head = 0;
        ch->cap = new_cap;
    }
    int64_t tail = (ch->head + ch->count) & (ch->cap - 1);
    ch->buf[tail] = value;
    ch->count++;
}

static int64_t channel_dequeue(NovaChannel* ch) {
    int64_t value = ch->buf[ch->head];
    ch->head = (ch->head + 1) & (ch->cap - 1);
    ch->count--;
    return value;
}

/* Returns 0 on success, -1 if channel is closed (sets __nova_error_flag). */
int64_t nova_rt_channel_send(int64_t handle, int64_t value) {
    NovaChannel* ch = (NovaChannel*)(uintptr_t)handle;
    /* Ownership: the receiver gets an independent deep copy, so sender and
       receiver never share mutable heap state across the process boundary. */
    int64_t copy = nova_rt_deep_copy(value);
#ifdef _WIN32
    EnterCriticalSection(&ch->lock);
    if (ch->closed) {
        LeaveCriticalSection(&ch->lock);
        nova_rc_dec(copy);
        return -1;
    }
    int was_empty = (ch->count == 0);
    channel_enqueue(ch, copy);
    if (was_empty) WakeConditionVariable(&ch->not_empty);
    LeaveCriticalSection(&ch->lock);
#else
    pthread_mutex_lock(&ch->lock);
    if (ch->closed) {
        pthread_mutex_unlock(&ch->lock);
        nova_rc_dec(copy);
        return -1;
    }
    int was_empty = (ch->count == 0);
    channel_enqueue(ch, copy);
    if (was_empty) pthread_cond_signal(&ch->not_empty);
    pthread_mutex_unlock(&ch->lock);
#endif
    return 0;
}

/* Move-send: compiler proved sender never uses value after this call,
   so we skip the deep copy and transfer the value directly. */
int64_t nova_rt_channel_send_move(int64_t handle, int64_t value) {
    NovaChannel* ch = (NovaChannel*)(uintptr_t)handle;
#ifdef _WIN32
    EnterCriticalSection(&ch->lock);
    if (ch->closed) {
        LeaveCriticalSection(&ch->lock);
        return -1;
    }
    int was_empty = (ch->count == 0);
    channel_enqueue(ch, value);
    if (was_empty) WakeConditionVariable(&ch->not_empty);
    LeaveCriticalSection(&ch->lock);
#else
    pthread_mutex_lock(&ch->lock);
    if (ch->closed) {
        pthread_mutex_unlock(&ch->lock);
        return -1;
    }
    int was_empty = (ch->count == 0);
    channel_enqueue(ch, value);
    if (was_empty) pthread_cond_signal(&ch->not_empty);
    pthread_mutex_unlock(&ch->lock);
#endif
    return 0;
}

/* Blocks until a value is available. Returns 0 with error flag set if
   the channel is closed and empty. */
int64_t nova_rt_channel_recv(int64_t handle) {
    NovaChannel* ch = (NovaChannel*)(uintptr_t)handle;
#ifdef _WIN32
    EnterCriticalSection(&ch->lock);
    while (ch->count == 0) {
        if (ch->closed) {
            LeaveCriticalSection(&ch->lock);
            return -1;
        }
        SleepConditionVariableCS(&ch->not_empty, &ch->lock, INFINITE);
    }
    int64_t value = channel_dequeue(ch);
    LeaveCriticalSection(&ch->lock);
#else
    pthread_mutex_lock(&ch->lock);
    while (ch->count == 0) {
        if (ch->closed) {
            pthread_mutex_unlock(&ch->lock);
            return -1;
        }
        pthread_cond_wait(&ch->not_empty, &ch->lock);
    }
    int64_t value = channel_dequeue(ch);
    pthread_mutex_unlock(&ch->lock);
#endif
    return value;
}

/* Close a channel: prevents further sends, wakes blocked receivers. */
int64_t nova_rt_channel_close(int64_t handle) {
    NovaChannel* ch = (NovaChannel*)(uintptr_t)handle;
#ifdef _WIN32
    EnterCriticalSection(&ch->lock);
    ch->closed = 1;
    WakeAllConditionVariable(&ch->not_empty);
    LeaveCriticalSection(&ch->lock);
#else
    pthread_mutex_lock(&ch->lock);
    ch->closed = 1;
    pthread_cond_broadcast(&ch->not_empty);
    pthread_mutex_unlock(&ch->lock);
#endif
    return 0;
}

/* Non-blocking try-receive: returns 1 and stores value if available, 0 otherwise.
   Used internally by select. */
static int channel_try_recv(NovaChannel* ch, int64_t* out_value) {
#ifdef _WIN32
    EnterCriticalSection(&ch->lock);
#else
    pthread_mutex_lock(&ch->lock);
#endif
    if (ch->count > 0) {
        *out_value = channel_dequeue(ch);
#ifdef _WIN32
        LeaveCriticalSection(&ch->lock);
#else
        pthread_mutex_unlock(&ch->lock);
#endif
        return 1;
    }
#ifdef _WIN32
    LeaveCriticalSection(&ch->lock);
#else
    pthread_mutex_unlock(&ch->lock);
#endif
    return 0;
}

static int channel_is_closed(NovaChannel* ch) {
#ifdef _WIN32
    EnterCriticalSection(&ch->lock);
    int closed = (int)ch->closed;
    LeaveCriticalSection(&ch->lock);
#else
    pthread_mutex_lock(&ch->lock);
    int closed = (int)ch->closed;
    pthread_mutex_unlock(&ch->lock);
#endif
    return closed;
}

/* Select: wait on multiple channels, return (index, value) tuple.
   channels_ptr points to an array of i64 channel handles.
   Returns pointer to [index, value] tuple.
   If all channels are closed and empty, returns (-1, 0). */
int64_t nova_rt_channel_select(int64_t channels_ptr, int64_t count) {
    int64_t* channels = (int64_t*)(uintptr_t)channels_ptr;
    int64_t spins = 0;
    int64_t value;

    while (1) {
        int64_t all_closed_empty = 1;
        for (int64_t i = 0; i < count; i++) {
            NovaChannel* ch = (NovaChannel*)(uintptr_t)channels[i];
            if (channel_try_recv(ch, &value)) {
                int64_t* tup = (int64_t*)nova_heap_alloc(2 * sizeof(int64_t), NOVA_MEM_RAW);
                if (tup) { tup[0] = i; tup[1] = value; }
                return (int64_t)(uintptr_t)tup;
            }
            if (!channel_is_closed(ch) || ch->count > 0)
                all_closed_empty = 0;
        }
        if (all_closed_empty) {
            int64_t* tup = (int64_t*)nova_heap_alloc(2 * sizeof(int64_t), NOVA_MEM_RAW);
            if (tup) { tup[0] = -1; tup[1] = 0; }
            return (int64_t)(uintptr_t)tup;
        }
        if (++spins < 64) {
#ifdef _WIN32
            SwitchToThread();
#else
            sched_yield();
#endif
        } else {
#ifdef _WIN32
            Sleep(1);
#else
            usleep(500);
#endif
        }
    }
}

/* Select from a NovaList of channels. Returns NovaList [index, value].
   If all channels are closed and empty, returns [-1, 0]. */
int64_t nova_rt_select(int64_t list_handle) {
    NovaList* channels = (NovaList*)(uintptr_t)list_handle;
    if (!channels || channels->size == 0) {
        int64_t result = nova_rt_list_create();
        nova_rt_list_append(result, -1);
        nova_rt_list_append(result, 0);
        return result;
    }

    int64_t spins = 0;
    int64_t value;

    while (1) {
        int64_t all_closed_empty = 1;
        for (int64_t i = 0; i < channels->size; i++) {
            NovaChannel* ch = (NovaChannel*)(uintptr_t)channels->data[i];
            if (channel_try_recv(ch, &value)) {
                int64_t result = nova_rt_list_create();
                nova_rt_list_append(result, i);
                nova_rt_list_append(result, value);
                return result;
            }
            if (!channel_is_closed(ch) || ch->count > 0)
                all_closed_empty = 0;
        }
        if (all_closed_empty) {
            int64_t result = nova_rt_list_create();
            nova_rt_list_append(result, -1);
            nova_rt_list_append(result, 0);
            return result;
        }
        if (++spins < 64) {
#ifdef _WIN32
            SwitchToThread();
#else
            sched_yield();
#endif
        } else {
#ifdef _WIN32
            Sleep(1);
#else
            usleep(500);
#endif
        }
    }
}

/* Receive with timeout (milliseconds). Returns value on success,
   -1 on timeout or closed channel. */
int64_t nova_rt_channel_recv_timeout(int64_t handle, int64_t timeout_ms) {
    NovaChannel* ch = (NovaChannel*)(uintptr_t)handle;
#ifdef _WIN32
    EnterCriticalSection(&ch->lock);
    DWORD start = GetTickCount();
    while (ch->count == 0) {
        if (ch->closed) {
            LeaveCriticalSection(&ch->lock);
            return -1;
        }
        DWORD elapsed = GetTickCount() - start;
        if (elapsed >= (DWORD)timeout_ms) {
            LeaveCriticalSection(&ch->lock);
            return -1;
        }
        DWORD remaining = (DWORD)timeout_ms - elapsed;
        if (!SleepConditionVariableCS(&ch->not_empty, &ch->lock, remaining)) {
            LeaveCriticalSection(&ch->lock);
            return -1;
        }
    }
    int64_t value = channel_dequeue(ch);
    LeaveCriticalSection(&ch->lock);
    return value;
#else
    pthread_mutex_lock(&ch->lock);
    struct timeval now;
    gettimeofday(&now, NULL);
    struct timespec deadline;
    int64_t total_us = (int64_t)now.tv_sec * 1000000LL + now.tv_usec + timeout_ms * 1000LL;
    deadline.tv_sec = total_us / 1000000LL;
    deadline.tv_nsec = (total_us % 1000000LL) * 1000LL;
    while (ch->count == 0) {
        if (ch->closed) {
            pthread_mutex_unlock(&ch->lock);
            return -1;
        }
        int rc = pthread_cond_timedwait(&ch->not_empty, &ch->lock, &deadline);
        if (rc != 0) {
            pthread_mutex_unlock(&ch->lock);
            return -1;
        }
    }
    int64_t value = channel_dequeue(ch);
    pthread_mutex_unlock(&ch->lock);
    return value;
#endif
}

/* ── Thread Pool + Process / Spawn ───────────────────────────────────────── */

typedef void (*nova_spawn_entry)(void*);

typedef struct {
    nova_spawn_entry fn;
    void*    ctx;
    int64_t* monitors;
    int64_t  monitor_count;
    int64_t  monitor_cap;
    volatile int64_t finished;
    int64_t  exit_status;
#ifdef _WIN32
    CRITICAL_SECTION lock;
#else
    pthread_mutex_t lock;
#endif
} NovaProcessInfo;

typedef struct NovaFuture {
    int64_t result;
    volatile int completed;
#ifdef _WIN32
    CRITICAL_SECTION lock;
    CONDITION_VARIABLE cv;
#else
    pthread_mutex_t lock;
    pthread_cond_t cv;
#endif
} NovaFuture;

typedef struct {
    NovaProcessInfo* proc;
    NovaFuture* future;
    int64_t closure;
} NovaPoolTask;

#define NOVA_POOL_QUEUE_CAP  4096
#define NOVA_POOL_MAX_WORKERS 16

typedef struct {
#ifdef _WIN32
    HANDLE workers[NOVA_POOL_MAX_WORKERS];
#else
    pthread_t workers[NOVA_POOL_MAX_WORKERS];
#endif
    int worker_count;

    NovaPoolTask queue[NOVA_POOL_QUEUE_CAP];
    int64_t head;
    int64_t tail;
    int64_t size;

#ifdef _WIN32
    CRITICAL_SECTION lock;
    CONDITION_VARIABLE not_empty;
    CONDITION_VARIABLE not_full;
    CONDITION_VARIABLE all_done;
#else
    pthread_mutex_t lock;
    pthread_cond_t  not_empty;
    pthread_cond_t  not_full;
    pthread_cond_t  all_done;
#endif

    volatile int shutdown;
    volatile int64_t tasks_submitted;
    volatile int64_t tasks_completed;
} NovaThreadPool;

static NovaThreadPool* nova_pool = NULL;

#define MAX_PROCESSES 4096
static NovaProcessInfo* nova_processes[MAX_PROCESSES];
static int64_t nova_process_count = 0;

#ifdef _WIN32
static CRITICAL_SECTION nova_proc_registry_lock;
#else
static pthread_mutex_t nova_proc_registry_lock = PTHREAD_MUTEX_INITIALIZER;
#endif

/* ── Pool Worker ────────────────────────────────────────────────────────── */

#ifdef _WIN32
static DWORD WINAPI nova_pool_worker(LPVOID arg) {
    NovaThreadPool* pool = (NovaThreadPool*)arg;
    while (1) {
        EnterCriticalSection(&pool->lock);
        while (pool->size == 0 && !pool->shutdown)
            SleepConditionVariableCS(&pool->not_empty, &pool->lock, INFINITE);

        if (pool->shutdown && pool->size == 0) {
            LeaveCriticalSection(&pool->lock);
            break;
        }

        NovaPoolTask task = pool->queue[pool->head];
        pool->head = (pool->head + 1) % NOVA_POOL_QUEUE_CAP;
        pool->size--;
        WakeConditionVariable(&pool->not_full);
        LeaveCriticalSection(&pool->lock);

        if (task.proc) {
            NovaProcessInfo* proc = task.proc;
            proc->fn(proc->ctx);

            EnterCriticalSection(&proc->lock);
            proc->exit_status = 0;
            for (int64_t i = 0; i < proc->monitor_count; i++)
                nova_rt_channel_send(proc->monitors[i], proc->exit_status);
            proc->finished = 1;
            LeaveCriticalSection(&proc->lock);
        } else if (task.future) {
            int64_t* rec = (int64_t*)(uintptr_t)task.closure;
            nova_fn1 fn = (nova_fn1)(uintptr_t)rec[0];
            int64_t result = fn(task.closure, 0);

            EnterCriticalSection(&task.future->lock);
            task.future->result = result;
            task.future->completed = 1;
            WakeAllConditionVariable(&task.future->cv);
            LeaveCriticalSection(&task.future->lock);
        }

        EnterCriticalSection(&pool->lock);
        pool->tasks_completed++;
        WakeAllConditionVariable(&pool->all_done);
        LeaveCriticalSection(&pool->lock);
    }
    return 0;
}
#else
static void* nova_pool_worker(void* arg) {
    NovaThreadPool* pool = (NovaThreadPool*)arg;
    while (1) {
        pthread_mutex_lock(&pool->lock);
        while (pool->size == 0 && !pool->shutdown)
            pthread_cond_wait(&pool->not_empty, &pool->lock);

        if (pool->shutdown && pool->size == 0) {
            pthread_mutex_unlock(&pool->lock);
            break;
        }

        NovaPoolTask task = pool->queue[pool->head];
        pool->head = (pool->head + 1) % NOVA_POOL_QUEUE_CAP;
        pool->size--;
        pthread_cond_signal(&pool->not_full);
        pthread_mutex_unlock(&pool->lock);

        if (task.proc) {
            NovaProcessInfo* proc = task.proc;
            proc->fn(proc->ctx);

            pthread_mutex_lock(&proc->lock);
            proc->exit_status = 0;
            for (int64_t i = 0; i < proc->monitor_count; i++)
                nova_rt_channel_send(proc->monitors[i], proc->exit_status);
            proc->finished = 1;
            pthread_mutex_unlock(&proc->lock);
        } else if (task.future) {
            int64_t* rec = (int64_t*)(uintptr_t)task.closure;
            nova_fn1 fn = (nova_fn1)(uintptr_t)rec[0];
            int64_t result = fn(task.closure, 0);

            pthread_mutex_lock(&task.future->lock);
            task.future->result = result;
            task.future->completed = 1;
            pthread_cond_broadcast(&task.future->cv);
            pthread_mutex_unlock(&task.future->lock);
        }

        pthread_mutex_lock(&pool->lock);
        pool->tasks_completed++;
        pthread_cond_broadcast(&pool->all_done);
        pthread_mutex_unlock(&pool->lock);
    }
    return NULL;
}
#endif

/* ── Pool Lifecycle ─────────────────────────────────────────────────────── */

static int nova_detect_cpu_count(void) {
#ifdef _WIN32
    SYSTEM_INFO si;
    GetSystemInfo(&si);
    int n = (int)si.dwNumberOfProcessors;
#else
    int n = (int)sysconf(_SC_NPROCESSORS_ONLN);
#endif
    if (n < 2) n = 2;
    if (n > NOVA_POOL_MAX_WORKERS) n = NOVA_POOL_MAX_WORKERS;
    return n;
}

static void nova_pool_init(void) {
    NovaThreadPool* pool = (NovaThreadPool*)calloc(1, sizeof(NovaThreadPool));
    if (!pool) return;

#ifdef _WIN32
    InitializeCriticalSection(&pool->lock);
    InitializeConditionVariable(&pool->not_empty);
    InitializeConditionVariable(&pool->not_full);
    InitializeConditionVariable(&pool->all_done);
#else
    pthread_mutex_init(&pool->lock, NULL);
    pthread_cond_init(&pool->not_empty, NULL);
    pthread_cond_init(&pool->not_full, NULL);
    pthread_cond_init(&pool->all_done, NULL);
#endif

    pool->worker_count = nova_detect_cpu_count();
    for (int i = 0; i < pool->worker_count; i++) {
#ifdef _WIN32
        pool->workers[i] = CreateThread(NULL, 0, nova_pool_worker, pool, 0, NULL);
#else
        pthread_create(&pool->workers[i], NULL, nova_pool_worker, pool);
#endif
    }

    nova_pool = pool;
}

static void nova_pool_shutdown(void) {
    if (!nova_pool) return;
    NovaThreadPool* pool = nova_pool;

#ifdef _WIN32
    EnterCriticalSection(&pool->lock);
    pool->shutdown = 1;
    WakeAllConditionVariable(&pool->not_empty);
    LeaveCriticalSection(&pool->lock);

    for (int i = 0; i < pool->worker_count; i++) {
        WaitForSingleObject(pool->workers[i], INFINITE);
        CloseHandle(pool->workers[i]);
    }
    DeleteCriticalSection(&pool->lock);
#else
    pthread_mutex_lock(&pool->lock);
    pool->shutdown = 1;
    pthread_cond_broadcast(&pool->not_empty);
    pthread_mutex_unlock(&pool->lock);

    for (int i = 0; i < pool->worker_count; i++)
        pthread_join(pool->workers[i], NULL);

    pthread_mutex_destroy(&pool->lock);
    pthread_cond_destroy(&pool->not_empty);
    pthread_cond_destroy(&pool->not_full);
    pthread_cond_destroy(&pool->all_done);
#endif

    free(pool);
    nova_pool = NULL;
}

/* ── Public API ─────────────────────────────────────────────────────────── */

/* ── Stored argc/argv for args() ─────────────────────────────────────────── */
static int    nova_argc = 0;
static char** nova_argv = NULL;

void nova_rt_init(void) {
    setvbuf(stdout, NULL, _IONBF, 0);
    setvbuf(stderr, NULL, _IONBF, 0);
#ifdef _WIN32
    InitializeCriticalSection(&nova_mem_lock);
    InitializeCriticalSection(&nova_proc_registry_lock);
#endif
    nova_slab_init();
    void* probe = malloc(64);
    if (probe) {
        nova_heap_base = (uintptr_t)probe;
        nova_heap_top = (uintptr_t)probe + 64;
        free(probe);
    }
    srand((unsigned int)time(NULL));
}

void nova_rt_init_args(int64_t argc, int64_t argv_ptr) {
    nova_argc = (int)argc;
    nova_argv = (char**)(uintptr_t)argv_ptr;
    nova_rt_init();
}

/* ── args() — returns list of CLI argument strings ───────────────────────── */
int64_t nova_rt_args(void) {
    int64_t list = nova_rt_list_create();
    for (int i = 0; i < nova_argc; i++) {
        const char* arg = nova_argv[i];
        size_t len = strlen(arg);
        char* copy = (char*)nova_heap_alloc(len + 1, NOVA_MEM_RAW);
        if (copy) { memcpy(copy, arg, len + 1); }
        else { copy = (char*)""; }
        nova_rt_list_append(list, (int64_t)(uintptr_t)copy);
    }
    return list;
}

/* ── env(name) — get environment variable value (empty string if not set) ─ */
int64_t nova_rt_env(int64_t name_ptr) {
    const char* name = (const char*)(uintptr_t)name_ptr;
    const char* val = getenv(name);
    if (!val) return (int64_t)(uintptr_t)"";
    size_t len = strlen(val);
    char* copy = (char*)nova_heap_alloc(len + 1, NOVA_MEM_RAW);
    if (!copy) return (int64_t)(uintptr_t)"";
    memcpy(copy, val, len + 1);
    return (int64_t)(uintptr_t)copy;
}

/* ── random(min, max) — random integer in [min, max] inclusive ────────────── */
int64_t nova_rt_random_int(int64_t min, int64_t max) {
    if (max <= min) return min;
    uint64_t range = (uint64_t)(max - min + 1);
    uint64_t r = ((uint64_t)rand() << 32) | (uint64_t)rand();
    return min + (int64_t)(r % range);
}

/* ── random() — random float 0.0 to 1.0 ──────────────────────────────────── */
int64_t nova_rt_random_float(void) {
    double d = (double)rand() / (double)RAND_MAX;
    int64_t result;
    memcpy(&result, &d, sizeof(result));
    return result;
}

/* ── Path manipulation ────────────────────────────────────────────────────── */

int64_t nova_rt_path_parent(int64_t path_ptr) {
    const char* p = (const char*)(uintptr_t)path_ptr;
    size_t len = strlen(p);
    if (len == 0) return (int64_t)(uintptr_t)"";
    size_t i = len - 1;
    while (i > 0 && p[i] != '/' && p[i] != '\\') i--;
    if (i == 0 && p[0] != '/' && p[0] != '\\') return (int64_t)(uintptr_t)"";
    char* result = (char*)nova_heap_alloc(i + 1, NOVA_MEM_RAW);
    if (!result) return (int64_t)(uintptr_t)"";
    memcpy(result, p, i);
    result[i] = '\0';
    return (int64_t)(uintptr_t)result;
}

int64_t nova_rt_path_name(int64_t path_ptr) {
    const char* p = (const char*)(uintptr_t)path_ptr;
    size_t len = strlen(p);
    size_t i = len;
    while (i > 0 && p[i-1] != '/' && p[i-1] != '\\') i--;
    const char* name = p + i;
    size_t nlen = len - i;
    char* result = (char*)nova_heap_alloc(nlen + 1, NOVA_MEM_RAW);
    if (!result) return (int64_t)(uintptr_t)"";
    memcpy(result, name, nlen + 1);
    return (int64_t)(uintptr_t)result;
}

int64_t nova_rt_path_ext(int64_t path_ptr) {
    const char* p = (const char*)(uintptr_t)path_ptr;
    size_t len = strlen(p);
    size_t i = len;
    while (i > 0 && p[i-1] != '.' && p[i-1] != '/' && p[i-1] != '\\') i--;
    if (i == 0 || p[i-1] != '.') return (int64_t)(uintptr_t)"";
    const char* ext = p + i - 1;
    size_t elen = len - i + 1;
    char* result = (char*)nova_heap_alloc(elen + 1, NOVA_MEM_RAW);
    if (!result) return (int64_t)(uintptr_t)"";
    memcpy(result, ext, elen + 1);
    return (int64_t)(uintptr_t)result;
}

/* ── shell(cmd) — execute command, return stdout as string ─────────────────── */
int64_t nova_rt_shell(int64_t cmd_ptr) {
    const char* cmd = (const char*)(uintptr_t)cmd_ptr;
#ifdef _WIN32
    FILE* fp = _popen(cmd, "r");
#else
    FILE* fp = popen(cmd, "r");
#endif
    if (!fp) {
        nova_set_error("shell: failed to execute command");
        return (int64_t)(uintptr_t)"";
    }
    size_t cap = 1024, len = 0;
    char* buf = (char*)malloc(cap);
    if (!buf) {
#ifdef _WIN32
        _pclose(fp);
#else
        pclose(fp);
#endif
        return (int64_t)(uintptr_t)"";
    }
    size_t n;
    while ((n = fread(buf + len, 1, cap - len - 1, fp)) > 0) {
        len += n;
        if (len + 1 >= cap) { cap *= 2; buf = (char*)realloc(buf, cap); if (!buf) break; }
    }
#ifdef _WIN32
    _pclose(fp);
#else
    pclose(fp);
#endif
    if (!buf) return (int64_t)(uintptr_t)"";
    buf[len] = '\0';
    /* Trim trailing newline */
    while (len > 0 && (buf[len-1] == '\n' || buf[len-1] == '\r')) buf[--len] = '\0';
    return (int64_t)(uintptr_t)buf;
}

int64_t nova_rt_spawn(int64_t fn_ptr, int64_t ctx_ptr) {
    nova_is_multithreaded = 1;
    if (!nova_pool) nova_pool_init();

    NovaProcessInfo* proc = (NovaProcessInfo*)malloc(sizeof(NovaProcessInfo));
    if (!proc) return 0;
    proc->fn = (nova_spawn_entry)(uintptr_t)fn_ptr;
    /* Ownership: the spawned process gets its own deep copy of the captured
       environment, so it never shares mutable heap state with the spawner. */
    proc->ctx = (void*)(uintptr_t)nova_rt_deep_copy(ctx_ptr);
    proc->monitors = NULL;
    proc->monitor_count = 0;
    proc->monitor_cap = 0;
    proc->finished = 0;
    proc->exit_status = 0;

#ifdef _WIN32
    InitializeCriticalSection(&proc->lock);
#else
    pthread_mutex_init(&proc->lock, NULL);
#endif

    /* Register in process table */
#ifdef _WIN32
    EnterCriticalSection(&nova_proc_registry_lock);
    if (nova_process_count < MAX_PROCESSES)
        nova_processes[nova_process_count++] = proc;
    LeaveCriticalSection(&nova_proc_registry_lock);
#else
    pthread_mutex_lock(&nova_proc_registry_lock);
    if (nova_process_count < MAX_PROCESSES)
        nova_processes[nova_process_count++] = proc;
    pthread_mutex_unlock(&nova_proc_registry_lock);
#endif

    /* Enqueue task on thread pool */
    NovaThreadPool* pool = nova_pool;
#ifdef _WIN32
    EnterCriticalSection(&pool->lock);
    while (pool->size >= NOVA_POOL_QUEUE_CAP)
        SleepConditionVariableCS(&pool->not_full, &pool->lock, INFINITE);
    pool->queue[pool->tail].proc = proc;
    pool->queue[pool->tail].future = NULL;
    pool->queue[pool->tail].closure = 0;
    pool->tail = (pool->tail + 1) % NOVA_POOL_QUEUE_CAP;
    pool->size++;
    pool->tasks_submitted++;
    WakeConditionVariable(&pool->not_empty);
    LeaveCriticalSection(&pool->lock);
#else
    pthread_mutex_lock(&pool->lock);
    while (pool->size >= NOVA_POOL_QUEUE_CAP)
        pthread_cond_wait(&pool->not_full, &pool->lock);
    pool->queue[pool->tail].proc = proc;
    pool->queue[pool->tail].future = NULL;
    pool->queue[pool->tail].closure = 0;
    pool->tail = (pool->tail + 1) % NOVA_POOL_QUEUE_CAP;
    pool->size++;
    pool->tasks_submitted++;
    pthread_cond_signal(&pool->not_empty);
    pthread_mutex_unlock(&pool->lock);
#endif

    return (int64_t)(uintptr_t)proc;
}

int64_t nova_rt_monitor(int64_t proc_handle) {
    NovaProcessInfo* proc = (NovaProcessInfo*)(uintptr_t)proc_handle;
    int64_t ch = nova_rt_channel_create();

#ifdef _WIN32
    EnterCriticalSection(&proc->lock);
    if (proc->finished) {
        LeaveCriticalSection(&proc->lock);
        nova_rt_channel_send(ch, proc->exit_status);
        return ch;
    }
    if (proc->monitor_count >= proc->monitor_cap) {
        proc->monitor_cap = proc->monitor_cap == 0 ? 4 : proc->monitor_cap * 2;
        proc->monitors = (int64_t*)realloc(proc->monitors, (size_t)proc->monitor_cap * sizeof(int64_t));
    }
    proc->monitors[proc->monitor_count++] = ch;
    LeaveCriticalSection(&proc->lock);
#else
    pthread_mutex_lock(&proc->lock);
    if (proc->finished) {
        pthread_mutex_unlock(&proc->lock);
        nova_rt_channel_send(ch, proc->exit_status);
        return ch;
    }
    if (proc->monitor_count >= proc->monitor_cap) {
        proc->monitor_cap = proc->monitor_cap == 0 ? 4 : proc->monitor_cap * 2;
        proc->monitors = (int64_t*)realloc(proc->monitors, (size_t)proc->monitor_cap * sizeof(int64_t));
    }
    proc->monitors[proc->monitor_count++] = ch;
    pthread_mutex_unlock(&proc->lock);
#endif
    return ch;
}

void nova_rt_wait_all(void) {
    if (!nova_pool) {
        nova_process_count = 0;
        return;
    }
    NovaThreadPool* pool = nova_pool;

    /* Wait for all submitted tasks to complete */
#ifdef _WIN32
    EnterCriticalSection(&pool->lock);
    while (pool->tasks_completed < pool->tasks_submitted)
        SleepConditionVariableCS(&pool->all_done, &pool->lock, INFINITE);
    LeaveCriticalSection(&pool->lock);
#else
    pthread_mutex_lock(&pool->lock);
    while (pool->tasks_completed < pool->tasks_submitted)
        pthread_cond_wait(&pool->all_done, &pool->lock);
    pthread_mutex_unlock(&pool->lock);
#endif

    /* Clean up process info structs */
    for (int64_t i = 0; i < nova_process_count; i++) {
        NovaProcessInfo* proc = nova_processes[i];
#ifdef _WIN32
        DeleteCriticalSection(&proc->lock);
#else
        pthread_mutex_destroy(&proc->lock);
#endif
        if (proc->monitors) free(proc->monitors);
        free(proc);
    }
    nova_process_count = 0;

    /* Shut down pool — workers join cleanly */
    nova_pool_shutdown();
}

/* ── Auto-Parallelization Primitives ──────────────────────────────────────── */

int64_t nova_rt_cpu_count(void) {
#ifdef _WIN32
    SYSTEM_INFO si;
    GetSystemInfo(&si);
    int64_t n = (int64_t)si.dwNumberOfProcessors;
    return n > 0 ? n : 1;
#else
    long n = sysconf(_SC_NPROCESSORS_ONLN);
    return n > 0 ? (int64_t)n : 1;
#endif
}

typedef struct {
    NovaList* input;
    int64_t  start;
    int64_t  end;
    int64_t  closure;
    int64_t* output;
    uint8_t* keep;
} NovaPTask;

#ifdef _WIN32
static DWORD WINAPI nova_pmap_worker(LPVOID arg) {
#else
static void* nova_pmap_worker(void* arg) {
#endif
    NovaPTask* t = (NovaPTask*)arg;
    int64_t* rec = (int64_t*)(uintptr_t)t->closure;
    nova_fn1 fn = (nova_fn1)(uintptr_t)rec[0];
    for (int64_t i = t->start; i < t->end; i++)
        t->output[i] = fn(t->closure, t->input->data[i]);
#ifdef _WIN32
    return 0;
#else
    return NULL;
#endif
}

#ifdef _WIN32
static DWORD WINAPI nova_pfilter_worker(LPVOID arg) {
#else
static void* nova_pfilter_worker(void* arg) {
#endif
    NovaPTask* t = (NovaPTask*)arg;
    int64_t* rec = (int64_t*)(uintptr_t)t->closure;
    nova_fn1 fn = (nova_fn1)(uintptr_t)rec[0];
    for (int64_t i = t->start; i < t->end; i++)
        t->keep[i] = fn(t->closure, t->input->data[i]) ? 1 : 0;
#ifdef _WIN32
    return 0;
#else
    return NULL;
#endif
}

static int64_t nova_pmap_threshold = 256;

static int nova_pmap_thread_count(int64_t n) {
    int64_t cpus = nova_rt_cpu_count();
    if (cpus < 1) cpus = 1;
    if (cpus > 16) cpus = 16;
    if (n < nova_pmap_threshold) return 1;
    if (cpus > n) cpus = n;
    return (int)cpus;
}

int64_t nova_rt_pmap(int64_t handle, int64_t closure) {
    NovaList* l = (NovaList*)(uintptr_t)handle;
    if (!l || l->size == 0) return nova_rt_list_create();
    int64_t n = l->size;
    int nt = nova_pmap_thread_count(n);
    if (nt == 1) return nova_rt_list_map(handle, closure);

    int64_t* output = (int64_t*)malloc((size_t)n * sizeof(int64_t));
    if (!output) return nova_rt_list_map(handle, closure);

    NovaPTask* tasks = (NovaPTask*)malloc((size_t)nt * sizeof(NovaPTask));
    if (!tasks) { free(output); return nova_rt_list_map(handle, closure); }

    int64_t chunk = n / nt;
    for (int i = 0; i < nt; i++) {
        tasks[i].input = l;
        tasks[i].start = (int64_t)i * chunk;
        tasks[i].end = (i == nt - 1) ? n : (int64_t)(i + 1) * chunk;
        tasks[i].closure = closure;
        tasks[i].output = output;
        tasks[i].keep = NULL;
    }

#ifdef _WIN32
    HANDLE* threads = (HANDLE*)malloc((size_t)nt * sizeof(HANDLE));
    for (int i = 0; i < nt; i++)
        threads[i] = CreateThread(NULL, 0, nova_pmap_worker, &tasks[i], 0, NULL);
    WaitForMultipleObjects((DWORD)nt, threads, TRUE, INFINITE);
    for (int i = 0; i < nt; i++) CloseHandle(threads[i]);
    free(threads);
#else
    pthread_t* threads = (pthread_t*)malloc((size_t)nt * sizeof(pthread_t));
    for (int i = 0; i < nt; i++)
        pthread_create(&threads[i], NULL, nova_pmap_worker, &tasks[i]);
    for (int i = 0; i < nt; i++) pthread_join(threads[i], NULL);
    free(threads);
#endif

    int64_t result = nova_rt_list_create();
    NovaList* res = (NovaList*)(uintptr_t)result;
    if (n > res->cap) {
        res->cap = n;
        res->data = (int64_t*)realloc(res->data, (size_t)n * sizeof(int64_t));
    }
    memcpy(res->data, output, (size_t)n * sizeof(int64_t));
    res->size = n;
    /* Result list owns its elements: rc_inc each managed pointer so they survive
       independently of the closure's transient returns. */
    for (int64_t i = 0; i < n; i++) nova_rc_inc(res->data[i]);

    free(output);
    free(tasks);
    return result;
}

int64_t nova_rt_pfilter(int64_t handle, int64_t closure) {
    NovaList* l = (NovaList*)(uintptr_t)handle;
    if (!l || l->size == 0) return nova_rt_list_create();
    int64_t n = l->size;
    int nt = nova_pmap_thread_count(n);
    if (nt == 1) return nova_rt_list_filter(handle, closure);

    uint8_t* keep = (uint8_t*)calloc((size_t)n, 1);
    if (!keep) return nova_rt_list_filter(handle, closure);

    NovaPTask* tasks = (NovaPTask*)malloc((size_t)nt * sizeof(NovaPTask));
    if (!tasks) { free(keep); return nova_rt_list_filter(handle, closure); }

    int64_t chunk = n / nt;
    for (int i = 0; i < nt; i++) {
        tasks[i].input = l;
        tasks[i].start = (int64_t)i * chunk;
        tasks[i].end = (i == nt - 1) ? n : (int64_t)(i + 1) * chunk;
        tasks[i].closure = closure;
        tasks[i].output = NULL;
        tasks[i].keep = keep;
    }

#ifdef _WIN32
    HANDLE* threads = (HANDLE*)malloc((size_t)nt * sizeof(HANDLE));
    for (int i = 0; i < nt; i++)
        threads[i] = CreateThread(NULL, 0, nova_pfilter_worker, &tasks[i], 0, NULL);
    WaitForMultipleObjects((DWORD)nt, threads, TRUE, INFINITE);
    for (int i = 0; i < nt; i++) CloseHandle(threads[i]);
    free(threads);
#else
    pthread_t* threads = (pthread_t*)malloc((size_t)nt * sizeof(pthread_t));
    for (int i = 0; i < nt; i++)
        pthread_create(&threads[i], NULL, nova_pfilter_worker, &tasks[i]);
    for (int i = 0; i < nt; i++) pthread_join(threads[i], NULL);
    free(threads);
#endif

    int64_t result = nova_rt_list_create();
    for (int64_t i = 0; i < n; i++)
        if (keep[i]) nova_rt_list_append(result, l->data[i]);

    free(keep);
    free(tasks);
    return result;
}

typedef struct {
    int64_t start;
    int64_t end;
    int64_t closure;
} NovaPForTask;

#ifdef _WIN32
static DWORD WINAPI nova_pfor_worker(LPVOID arg) {
#else
static void* nova_pfor_worker(void* arg) {
#endif
    NovaPForTask* t = (NovaPForTask*)arg;
    int64_t* rec = (int64_t*)(uintptr_t)t->closure;
    nova_fn1 fn = (nova_fn1)(uintptr_t)rec[0];
    for (int64_t i = t->start; i < t->end; i++)
        fn(t->closure, i);
#ifdef _WIN32
    return 0;
#else
    return NULL;
#endif
}

int64_t nova_rt_pfor(int64_t start, int64_t end, int64_t closure) {
    int64_t n = end - start;
    if (n <= 0) return 0;
    int nt = nova_pmap_thread_count(n);
    if (nt == 1) {
        int64_t* rec = (int64_t*)(uintptr_t)closure;
        nova_fn1 fn = (nova_fn1)(uintptr_t)rec[0];
        for (int64_t i = start; i < end; i++) fn(closure, i);
        return 0;
    }

    NovaPForTask* tasks = (NovaPForTask*)malloc((size_t)nt * sizeof(NovaPForTask));
    if (!tasks) return 0;

    int64_t chunk = n / nt;
    for (int i = 0; i < nt; i++) {
        tasks[i].start = start + (int64_t)i * chunk;
        tasks[i].end = (i == nt - 1) ? end : start + (int64_t)(i + 1) * chunk;
        tasks[i].closure = closure;
    }

#ifdef _WIN32
    HANDLE* threads = (HANDLE*)malloc((size_t)nt * sizeof(HANDLE));
    for (int i = 0; i < nt; i++)
        threads[i] = CreateThread(NULL, 0, nova_pfor_worker, &tasks[i], 0, NULL);
    WaitForMultipleObjects((DWORD)nt, threads, TRUE, INFINITE);
    for (int i = 0; i < nt; i++) CloseHandle(threads[i]);
    free(threads);
#else
    pthread_t* threads = (pthread_t*)malloc((size_t)nt * sizeof(pthread_t));
    for (int i = 0; i < nt; i++)
        pthread_create(&threads[i], NULL, nova_pfor_worker, &tasks[i]);
    for (int i = 0; i < nt; i++) pthread_join(threads[i], NULL);
    free(threads);
#endif

    free(tasks);
    return 0;
}

/* ── Integer power (fast exponentiation by squaring) ─────────────────────── */

int64_t nova_rt_int_pow(int64_t base, int64_t exp) {
    if (exp < 0) return 0;
    int64_t result = 1;
    while (exp > 0) {
        if (exp & 1) result *= base;
        base *= base;
        exp >>= 1;
    }
    return result;
}

/* ── Math stdlib ──────────────────────────────────────────────────────────── */

static inline double i2f(int64_t v) { double d; memcpy(&d, &v, 8); return d; }
static inline int64_t f2i(double d)  { int64_t v; memcpy(&v, &d, 8); return v; }

int64_t nova_rt_sin(int64_t x)   { return f2i(sin(i2f(x))); }
int64_t nova_rt_cos(int64_t x)   { return f2i(cos(i2f(x))); }
int64_t nova_rt_tan(int64_t x)   { return f2i(tan(i2f(x))); }
int64_t nova_rt_asin(int64_t x)  { return f2i(asin(i2f(x))); }
int64_t nova_rt_acos(int64_t x)  { return f2i(acos(i2f(x))); }
int64_t nova_rt_atan(int64_t x)  { return f2i(atan(i2f(x))); }
int64_t nova_rt_atan2(int64_t y, int64_t x) { return f2i(atan2(i2f(y), i2f(x))); }
int64_t nova_rt_log(int64_t x)   { return f2i(log(i2f(x))); }
int64_t nova_rt_log2(int64_t x)  { return f2i(log2(i2f(x))); }
int64_t nova_rt_log10(int64_t x) { return f2i(log10(i2f(x))); }
int64_t nova_rt_exp(int64_t x)   { return f2i(exp(i2f(x))); }
int64_t nova_rt_fabs(int64_t x)  { return f2i(fabs(i2f(x))); }
int64_t nova_rt_fmod(int64_t x, int64_t y) { return f2i(fmod(i2f(x), i2f(y))); }
int64_t nova_rt_round(int64_t x) { return f2i(round(i2f(x))); }
int64_t nova_rt_sqrt(int64_t x)  { return f2i(sqrt(i2f(x))); }
int64_t nova_rt_pow(int64_t x, int64_t y) { return f2i(pow(i2f(x), i2f(y))); }
int64_t nova_rt_floor(int64_t x) { return (int64_t)floor(i2f(x)); }
int64_t nova_rt_ceil(int64_t x)  { return (int64_t)ceil(i2f(x)); }
int64_t nova_rt_abs(int64_t x) {
    uint64_t ux = (uint64_t)x;
    uint64_t exp = (ux >> 52) & 0x7FF;
    if (exp > 0 && exp < 0x7FF) return (int64_t)(ux & 0x7FFFFFFFFFFFFFFFULL);
    return x < 0 ? -x : x;
}
int64_t nova_rt_max(int64_t a, int64_t b) { return a > b ? a : b; }
int64_t nova_rt_min(int64_t a, int64_t b) { return a < b ? a : b; }
int64_t nova_rt_fmax(int64_t a, int64_t b) { return f2i(fmax(i2f(a), i2f(b))); }
int64_t nova_rt_fmin(int64_t a, int64_t b) { return f2i(fmin(i2f(a), i2f(b))); }
int64_t nova_rt_float_to_int(int64_t x) { return (int64_t)i2f(x); }
int64_t nova_rt_int_to_float(int64_t x) { return f2i((double)x); }

int64_t nova_rt_to_int(int64_t val) {
    if (val == 0) return 0;
    void* ptr = (void*)(uintptr_t)val;
    NovaMemTag tag = nova_mem_find_tag(ptr);
    if (tag == NOVA_MEM_RAW || tag == NOVA_MEM_FAT_STR) return nova_rt_parse_int(val);
    if ((uint64_t)val > 0x10000 && tag == (NovaMemTag)-1 && nova_is_readable_str(ptr)) {
        unsigned char c = *(unsigned char*)ptr;
        if (c >= 0x20 && c < 0x7F) return nova_rt_parse_int(val);
    }
    if (val < -(1LL << 52) || val > (1LL << 52)) {
        uint64_t exp = ((uint64_t)val >> 52) & 0x7FF;
        if (exp > 0 && exp < 0x7FF) return (int64_t)i2f(val);
    }
    return val;
}

int64_t nova_rt_to_float(int64_t val) {
    if (val == 0) return f2i(0.0);
    void* ptr = (void*)(uintptr_t)val;
    NovaMemTag tag = nova_mem_find_tag(ptr);
    if (tag == NOVA_MEM_RAW || tag == NOVA_MEM_FAT_STR) return nova_rt_parse_float(val);
    if ((uint64_t)val > 0x10000 && tag == (NovaMemTag)-1 && nova_is_readable_str(ptr)) {
        unsigned char c = *(unsigned char*)ptr;
        if (c >= 0x20 && c < 0x7F) return nova_rt_parse_float(val);
    }
    return f2i((double)val);
}

/* ── Reference Counting ────────────────────────────────────────────────── */

static void nova_rc_dec_internal(int64_t val);

/* ── Debug: freed-pointer tracking (compile with -DNOVA_DEBUG_RC) ─────────── */
#ifdef NOVA_DEBUG_RC
#define NOVA_DEBUG_FREE_CAP 131072
static void*    nova_debug_freed_ptr[NOVA_DEBUG_FREE_CAP];
static int32_t  nova_debug_freed_rc [NOVA_DEBUG_FREE_CAP];  /* rc at time of free */
static int      nova_debug_freed_count = 0;

static void nova_debug_record_free(void* p, int32_t rc) {
    if (nova_debug_freed_count < NOVA_DEBUG_FREE_CAP) {
        nova_debug_freed_ptr[nova_debug_freed_count] = p;
        nova_debug_freed_rc [nova_debug_freed_count] = rc;
        nova_debug_freed_count++;
    }
}
static int nova_debug_was_freed(void* p) {
    for (int i = 0; i < nova_debug_freed_count; i++)
        if (nova_debug_freed_ptr[i] == p) return i;
    return -1;
}
#endif

static void nova_rc_free(void* ptr) {
    NovaMemTag tag = NOVA_RC_TAG(ptr);
    nova_mem_live--;
#ifdef NOVA_DEBUG_RC
    {
        int prev = nova_debug_was_freed(ptr);
        if (prev >= 0) {
            fprintf(stderr, "BUG-DOUBLE-FREE-RC: ptr=%p tag=%d\n", ptr, (int)tag);
            fflush(stderr);
        }
        nova_debug_record_free(ptr, 0);
    }
#endif
    switch (tag) {
        case NOVA_MEM_LIST: {
            NovaList* l = (NovaList*)ptr;
            for (int64_t i = 0; i < l->size; i++)
                nova_rc_dec_internal(l->data[i]);
            if (l->data) free(l->data);
            nova_fast_free((char*)ptr - NOVA_RC_HDR_SIZE,
                           NOVA_RC_HDR_SIZE + sizeof(NovaList));
            break;
        }
        case NOVA_MEM_DICT: {
            NovaDict* d = (NovaDict*)ptr;
            for (int64_t i = 0; i < d->size; i++) {
                nova_rc_dec_internal(d->keys[i]);
                nova_rc_dec_internal(d->vals[i]);
            }
            if (d->keys) free(d->keys);
            if (d->vals) free(d->vals);
            if (d->hashes) free(d->hashes);
            if (d->idx)  free(d->idx);
            nova_fast_free((char*)ptr - NOVA_RC_HDR_SIZE,
                           NOVA_RC_HDR_SIZE + sizeof(NovaDict));
            break;
        }
        case NOVA_MEM_CHANNEL: {
            NovaChannel* ch = (NovaChannel*)ptr;
            if (ch->buf) free(ch->buf);
#ifdef _WIN32
            DeleteCriticalSection(&ch->lock);
#else
            pthread_mutex_destroy(&ch->lock);
            pthread_cond_destroy(&ch->not_empty);
#endif
            free((char*)ptr - NOVA_RC_HDR_SIZE);
            break;
        }
        case NOVA_MEM_FAT_STR:
            free((char*)ptr - NOVA_FAT_HDR_SIZE - NOVA_RC_HDR_SIZE);
            break;
        default:
            free((char*)ptr - NOVA_RC_HDR_SIZE);
            break;
    }
}

static inline int nova_rc_is_managed(void* ptr) {
    uintptr_t addr = (uintptr_t)ptr;
    if (nova_heap_base && addr < nova_heap_base) return 0;
    if (nova_int_str_cache_inited &&
        (char*)ptr >= nova_int_str_cache[0] &&
        (char*)ptr < nova_int_str_cache[0] + sizeof(nova_int_str_cache))
        return 0;
    if (nova_strpool_contains(ptr)) return -1;
#ifdef _WIN32
    if (IsBadReadPtr((char*)ptr - NOVA_RC_HDR_SIZE, NOVA_RC_HDR_SIZE)) return 0;
#endif
    return NOVA_RC_VALID(ptr) ? 1 : 0;
}

void nova_rc_inc(int64_t val) {
    if ((uint64_t)val < 0x10000ULL) return;
    void* ptr = (void*)(uintptr_t)val;
    int kind = nova_rc_is_managed(ptr);
    if (kind == 0) return;
    if (kind == -1) { nova_strpool_rc_inc(ptr); return; }
    if (nova_is_multithreaded) {
#ifdef _WIN32
        InterlockedIncrement((volatile LONG*)&NOVA_RC_COUNT(ptr));
#else
        __sync_add_and_fetch(&NOVA_RC_COUNT(ptr), 1);
#endif
    } else {
        NOVA_RC_COUNT(ptr)++;
    }
}

static void nova_rc_dec_internal(int64_t val) {
    if ((uint64_t)val < 0x10000ULL) return;
    void* ptr = (void*)(uintptr_t)val;
    int kind = nova_rc_is_managed(ptr);
    if (kind == 0) return;
    if (kind == -1) { nova_strpool_rc_dec(ptr); return; }
    int32_t new_count;
    if (nova_is_multithreaded) {
#ifdef _WIN32
        new_count = (int32_t)InterlockedDecrement((volatile LONG*)&NOVA_RC_COUNT(ptr));
#else
        new_count = __sync_sub_and_fetch(&NOVA_RC_COUNT(ptr), 1);
#endif
    } else {
        new_count = --NOVA_RC_COUNT(ptr);
    }
    if (new_count <= 0) {
        nova_rc_free(ptr);
    }
}

void nova_rc_dec(int64_t val) {
    nova_rc_dec_internal(val);
}

/* ── Memory Cleanup ─────────────────────────────────────────────────────── */

int64_t nova_rt_alloc_count(void) {
    return nova_mem_total;
}

int64_t nova_rt_live_count(void) {
    return nova_mem_live;
}

void nova_rt_cleanup(void) {
    /* With embedded RC, all objects free themselves when RC hits 0.
       Cleanup frees infrastructure only — slab pages, intern table. */
    if (nova_intern_table) { free(nova_intern_table); nova_intern_table = NULL; }
    if (nova_intern_hashes) { free(nova_intern_hashes); nova_intern_hashes = NULL; }
    nova_intern_cap = 0;
    nova_intern_used = 0;
    /* Free slab pages */
    NovaSlabPage* pg = nova_slab_32.pages;
    while (pg) { NovaSlabPage* next = pg->next; free(pg); pg = next; }
    nova_slab_32.pages = NULL; nova_slab_32.free_list = NULL;
    pg = nova_slab_64.pages;
    while (pg) { NovaSlabPage* next = pg->next; free(pg); pg = next; }
    nova_slab_64.pages = NULL; nova_slab_64.free_list = NULL;
    nova_mem_total = 0;
    nova_mem_live = 0;
}

/* ── HTTP Client (WinHTTP on Windows, stub on others) ──────────────────────── */

#ifdef _WIN32

typedef struct {
    char*   data;
    int64_t len;
    int64_t cap;
} HttpBuf;

static void hbuf_init(HttpBuf* b) {
    b->cap = 4096;
    b->data = malloc((size_t)b->cap);
    b->len = 0;
}

static void hbuf_append(HttpBuf* b, const char* chunk, int64_t n) {
    while (b->len + n >= b->cap) {
        b->cap *= 2;
        b->data = realloc(b->data, (size_t)b->cap);
    }
    memcpy(b->data + b->len, chunk, (size_t)n);
    b->len += n;
}

static int parse_url(const char* url, wchar_t* host, int host_cap,
                     wchar_t* path, int path_cap, int* port, int* use_ssl) {
    *use_ssl = 0;
    *port = 80;
    const char* p = url;
    if (strncmp(p, "https://", 8) == 0) { *use_ssl = 1; *port = 443; p += 8; }
    else if (strncmp(p, "http://", 7) == 0) { p += 7; }

    const char* slash = strchr(p, '/');
    const char* colon = strchr(p, ':');
    int host_len;
    if (colon && (!slash || colon < slash)) {
        host_len = (int)(colon - p);
        *port = atoi(colon + 1);
    } else if (slash) {
        host_len = (int)(slash - p);
    } else {
        host_len = (int)strlen(p);
    }
    if (host_len >= host_cap) return 0;
    for (int i = 0; i < host_len; i++) host[i] = (wchar_t)p[i];
    host[host_len] = 0;

    const char* path_start = slash ? slash : "/";
    int path_len = (int)strlen(path_start);
    if (path_len >= path_cap) return 0;
    for (int i = 0; i < path_len; i++) path[i] = (wchar_t)path_start[i];
    path[path_len] = 0;
    if (!slash) { path[0] = L'/'; path[1] = 0; }
    return 1;
}

static int64_t http_request(const char* url, const char* method,
                            const char* body, int64_t body_len,
                            const char* content_type) {
    wchar_t host[512], path[2048];
    int port, use_ssl;
    if (!parse_url(url, host, 512, path, 2048, &port, &use_ssl)) {
        nova_set_error("HTTP: invalid URL");
        char* e = (char*)nova_heap_alloc(1, NOVA_MEM_RAW); if(e) e[0] = '\0';
        return (int64_t)(uintptr_t)e;
    }

    HINTERNET session = WinHttpOpen(L"NOVA/1.0",
        WINHTTP_ACCESS_TYPE_DEFAULT_PROXY, WINHTTP_NO_PROXY_NAME,
        WINHTTP_NO_PROXY_BYPASS, 0);
    if (!session) {
        nova_set_error("HTTP: failed to open session");
        char* e = (char*)nova_heap_alloc(1, NOVA_MEM_RAW); if(e) e[0] = '\0';
        return (int64_t)(uintptr_t)e;
    }
    WinHttpSetTimeouts(session, 10000, 10000, 30000, 30000);

    HINTERNET connect = WinHttpConnect(session, host, (INTERNET_PORT)port, 0);
    if (!connect) {
        nova_set_error("HTTP: failed to connect");
        WinHttpCloseHandle(session);
        char* e = (char*)nova_heap_alloc(1, NOVA_MEM_RAW); if(e) e[0] = '\0';
        return (int64_t)(uintptr_t)e;
    }

    wchar_t wmethod[16];
    for (int i = 0; method[i] && i < 15; i++) { wmethod[i] = (wchar_t)method[i]; wmethod[i+1] = 0; }

    DWORD flags = use_ssl ? WINHTTP_FLAG_SECURE : 0;
    HINTERNET request = WinHttpOpenRequest(connect, wmethod, path,
        NULL, WINHTTP_NO_REFERER, WINHTTP_DEFAULT_ACCEPT_TYPES, flags);
    if (!request) {
        nova_set_error("HTTP: failed to create request");
        WinHttpCloseHandle(connect);
        WinHttpCloseHandle(session);
        char* e = (char*)nova_heap_alloc(1, NOVA_MEM_RAW); if(e) e[0] = '\0';
        return (int64_t)(uintptr_t)e;
    }

    if (content_type && content_type[0]) {
        wchar_t hdr[256];
        int ct_len = (int)strlen(content_type);
        const char* prefix = "Content-Type: ";
        int prefix_len = 14;
        for (int i = 0; i < prefix_len; i++) hdr[i] = (wchar_t)prefix[i];
        for (int i = 0; i < ct_len && (prefix_len + i) < 254; i++)
            hdr[prefix_len + i] = (wchar_t)content_type[i];
        hdr[prefix_len + ct_len] = 0;
        WinHttpAddRequestHeaders(request, hdr, (DWORD)-1L, WINHTTP_ADDREQ_FLAG_ADD);
    }

    BOOL ok = WinHttpSendRequest(request,
        WINHTTP_NO_ADDITIONAL_HEADERS, 0,
        body ? (LPVOID)body : WINHTTP_NO_REQUEST_DATA,
        body ? (DWORD)body_len : 0,
        body ? (DWORD)body_len : 0, 0);
    if (!ok) {
        DWORD err = GetLastError();
        char errbuf[256];
        snprintf(errbuf, sizeof(errbuf), "HTTP: send failed (error %lu)", err);
        nova_set_error(errbuf);
        WinHttpCloseHandle(request);
        WinHttpCloseHandle(connect);
        WinHttpCloseHandle(session);
        char* e = (char*)nova_heap_alloc(1, NOVA_MEM_RAW); if(e) e[0] = '\0';
        return (int64_t)(uintptr_t)e;
    }

    ok = WinHttpReceiveResponse(request, NULL);
    if (!ok) {
        DWORD err = GetLastError();
        char errbuf[256];
        snprintf(errbuf, sizeof(errbuf), "HTTP: receive failed (error %lu)", err);
        nova_set_error(errbuf);
        WinHttpCloseHandle(request);
        WinHttpCloseHandle(connect);
        WinHttpCloseHandle(session);
        char* e = (char*)nova_heap_alloc(1, NOVA_MEM_RAW); if(e) e[0] = '\0';
        return (int64_t)(uintptr_t)e;
    }

    #define NOVA_HTTP_MAX_RESPONSE (100LL * 1024 * 1024)
    HttpBuf buf;
    hbuf_init(&buf);
    DWORD bytes_available = 0;
    for (;;) {
        if (!WinHttpQueryDataAvailable(request, &bytes_available)) break;
        if (bytes_available == 0) break;
        if (buf.len + (int64_t)bytes_available > NOVA_HTTP_MAX_RESPONSE) {
            nova_set_error("HTTP: response exceeds 100MB limit");
            free(buf.data);
            WinHttpCloseHandle(request); WinHttpCloseHandle(connect); WinHttpCloseHandle(session);
            char* e = (char*)nova_heap_alloc(1, NOVA_MEM_RAW); if(e) e[0] = '\0';
            return (int64_t)(uintptr_t)e;
        }
        char* chunk = malloc(bytes_available);
        if (!chunk) break;
        DWORD bytes_read = 0;
        if (WinHttpReadData(request, chunk, bytes_available, &bytes_read)) {
            hbuf_append(&buf, chunk, (int64_t)bytes_read);
        }
        free(chunk);
    }
    hbuf_append(&buf, "\0", 1);

    WinHttpCloseHandle(request);
    WinHttpCloseHandle(connect);
    WinHttpCloseHandle(session);

    char* tracked = (char*)nova_heap_alloc((size_t)buf.len, NOVA_MEM_RAW);
    if (tracked) memcpy(tracked, buf.data, (size_t)buf.len);
    free(buf.data);
    return (int64_t)(uintptr_t)tracked;
}

int64_t nova_rt_http_get(int64_t url) {
    const char* u = (const char*)(uintptr_t)url;
    return http_request(u, "GET", NULL, 0, NULL);
}

int64_t nova_rt_http_post(int64_t url, int64_t body, int64_t content_type) {
    const char* u = (const char*)(uintptr_t)url;
    const char* b = (const char*)(uintptr_t)body;
    const char* ct = (const char*)(uintptr_t)content_type;
    int64_t body_len = (int64_t)strlen(b);
    return http_request(u, "POST", b, body_len, ct);
}

#else

int64_t nova_rt_http_get(int64_t url) {
    (void)url;
    nova_set_error("HTTP: not implemented on this platform");
    char* e = (char*)nova_heap_alloc(1, NOVA_MEM_RAW); if(e) e[0] = '\0';
    return (int64_t)(uintptr_t)e;
}

int64_t nova_rt_http_post(int64_t url, int64_t body, int64_t content_type) {
    (void)url; (void)body; (void)content_type;
    nova_set_error("HTTP: not implemented on this platform");
    char* e = (char*)nova_heap_alloc(1, NOVA_MEM_RAW); if(e) e[0] = '\0';
    return (int64_t)(uintptr_t)e;
}

#endif

/* -- Time Operations -------------------------------------------------------- */

int64_t nova_rt_time_ms(void) {
#ifdef _WIN32
    FILETIME ft;
    GetSystemTimeAsFileTime(&ft);
    uint64_t t = ((uint64_t)ft.dwHighDateTime << 32) | ft.dwLowDateTime;
    return (int64_t)((t / 10000ULL) - 11644473600000ULL);
#else
    struct timeval tv;
    gettimeofday(&tv, NULL);
    return (int64_t)(tv.tv_sec * 1000LL + tv.tv_usec / 1000LL);
#endif
}

int64_t nova_rt_clock_ns(void) {
#ifdef _WIN32
    LARGE_INTEGER freq, counter;
    QueryPerformanceFrequency(&freq);
    QueryPerformanceCounter(&counter);
    return (int64_t)((double)counter.QuadPart / (double)freq.QuadPart * 1000000000.0);
#else
    struct timespec ts;
    clock_gettime(CLOCK_MONOTONIC, &ts);
    return (int64_t)(ts.tv_sec * 1000000000LL + ts.tv_nsec);
#endif
}

void nova_rt_sleep_ms(int64_t ms) {
#ifdef _WIN32
    Sleep((DWORD)ms);
#else
    usleep((useconds_t)(ms * 1000));
#endif
}

void nova_rt_assert(int64_t cond, int64_t msg) {
    if (!cond) {
        const char* s = (const char*)(uintptr_t)msg;
        fprintf(stderr, "Assertion failed: %s\n", s ? s : "(no message)");
        exit(1);
    }
}

/* ── Regex Engine (compact NFA, cross-platform) ───────────────────────────── */

typedef enum {
    RE_LIT, RE_DOT, RE_CLASS, RE_NCLASS,
    RE_DIGIT, RE_WORD, RE_SPACE,
    RE_NDIGIT, RE_NWORD, RE_NSPACE,
    RE_START, RE_END,
    RE_SPLIT, RE_JMP, RE_MATCH, RE_SAVE
} ReOp;

typedef struct {
    ReOp op;
    int c;
    int x, y;
    char* cls;
    int cls_len;
} ReInst;

#define RE_MAX_INST 1024
#define RE_MAX_SAVE 20

typedef struct {
    ReInst code[RE_MAX_INST];
    int len;
} ReProg;

static int re_class_match(const char* cls, int cls_len, int c) {
    int i = 0;
    while (i < cls_len) {
        if (i + 2 < cls_len && cls[i+1] == '-') {
            if (c >= (unsigned char)cls[i] && c <= (unsigned char)cls[i+2]) return 1;
            i += 3;
        } else {
            if (c == (unsigned char)cls[i]) return 1;
            i++;
        }
    }
    return 0;
}

static int re_is_digit(int c) { return c >= '0' && c <= '9'; }
static int re_is_word(int c) { return (c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z') || (c >= '0' && c <= '9') || c == '_'; }
static int re_is_space(int c) { return c == ' ' || c == '\t' || c == '\n' || c == '\r' || c == '\f' || c == '\v'; }

static int re_compile(const char* pattern, ReProg* prog) {
    int pc = 0;
    int len = (int)strlen(pattern);
    int pstack[64];
    int pstack_top = 0;
    int i = 0;

    #define EMIT(OP) do { if (pc >= RE_MAX_INST-2) return -1; prog->code[pc].op = (OP); prog->code[pc].cls = NULL; prog->code[pc].cls_len = 0; pc++; } while(0)

    while (i < len) {
        char c = pattern[i];
        switch (c) {
        case '.':
            EMIT(RE_DOT);
            i++;
            break;
        case '^':
            EMIT(RE_START);
            i++;
            break;
        case '$':
            EMIT(RE_END);
            i++;
            break;
        case '\\':
            i++;
            if (i >= len) return -1;
            switch (pattern[i]) {
            case 'd': EMIT(RE_DIGIT); break;
            case 'D': EMIT(RE_NDIGIT); break;
            case 'w': EMIT(RE_WORD); break;
            case 'W': EMIT(RE_NWORD); break;
            case 's': EMIT(RE_SPACE); break;
            case 'S': EMIT(RE_NSPACE); break;
            default:
                EMIT(RE_LIT);
                prog->code[pc-1].c = (unsigned char)pattern[i];
                break;
            }
            i++;
            break;
        case '[': {
            i++;
            int negate = 0;
            if (i < len && pattern[i] == '^') { negate = 1; i++; }
            int cls_start = i;
            while (i < len && pattern[i] != ']') {
                if (pattern[i] == '\\') i++;
                i++;
            }
            if (i >= len) return -1;
            int cls_len = i - cls_start;
            char* cls = (char*)malloc(cls_len + 1);
            if (!cls) return -1;
            memcpy(cls, pattern + cls_start, cls_len);
            cls[cls_len] = 0;
            EMIT(negate ? RE_NCLASS : RE_CLASS);
            prog->code[pc-1].cls = cls;
            prog->code[pc-1].cls_len = cls_len;
            i++;
            break;
        }
        case '|': {
            /* Patch: insert SPLIT before left, JMP at end of left */
            /* Simple approach: treat | as alternation of the last atom */
            /* For full correctness, handle with groups. Simple impl for now: */
            /* We'll handle | inside parentheses only. Bare | not supported in v1. */
            EMIT(RE_LIT);
            prog->code[pc-1].c = '|';
            i++;
            break;
        }
        case '(': {
            pstack[pstack_top++] = pc;
            EMIT(RE_SAVE);
            prog->code[pc-1].x = -1;
            i++;
            break;
        }
        case ')': {
            if (pstack_top <= 0) return -1;
            pstack_top--;
            EMIT(RE_SAVE);
            prog->code[pc-1].x = -2;
            i++;
            break;
        }
        case '*': case '+': case '?': {
            if (pc == 0) return -1;
            int atom_start = pc - 1;
            if (c == '*') {
                /* SPLIT(atom, after) ... JMP(atom) */
                /* Shift atom right by 1, insert SPLIT before */
                if (pc + 2 >= RE_MAX_INST) return -1;
                memmove(&prog->code[atom_start+1], &prog->code[atom_start], (pc - atom_start) * sizeof(ReInst));
                pc++;
                prog->code[atom_start].op = RE_SPLIT;
                prog->code[atom_start].x = atom_start + 1;
                prog->code[atom_start].y = pc + 1;
                prog->code[atom_start].cls = NULL;
                EMIT(RE_JMP);
                prog->code[pc-1].x = atom_start;
            } else if (c == '+') {
                /* atom ... SPLIT(atom, after) */
                EMIT(RE_SPLIT);
                prog->code[pc-1].x = atom_start;
                prog->code[pc-1].y = pc;
            } else { /* ? */
                if (pc + 1 >= RE_MAX_INST) return -1;
                memmove(&prog->code[atom_start+1], &prog->code[atom_start], (pc - atom_start) * sizeof(ReInst));
                pc++;
                prog->code[atom_start].op = RE_SPLIT;
                prog->code[atom_start].x = atom_start + 1;
                prog->code[atom_start].y = pc;
                prog->code[atom_start].cls = NULL;
            }
            i++;
            if (i < len && pattern[i] == '?') i++; /* non-greedy marker, skip */
            break;
        }
        default:
            EMIT(RE_LIT);
            prog->code[pc-1].c = (unsigned char)c;
            i++;
            break;
        }
    }
    EMIT(RE_MATCH);
    prog->len = pc;
    #undef EMIT
    return 0;
}

typedef struct {
    int pc;
    const char* saves[RE_MAX_SAVE];
} ReThread;

static int re_exec(ReProg* prog, const char* text, const char** saves, int nsaves) {
    /* Simple recursive backtracking VM — adequate for patterns < 1000 chars */
    int text_len = (int)strlen(text);

    /* Try matching at each position (for unanchored match) */
    int anchored = (prog->len > 0 && prog->code[0].op == RE_START);

    for (int start = 0; start <= text_len; start++) {
        /* Recursive backtracking */
        int sp_stack[RE_MAX_INST];
        int tp_stack[RE_MAX_INST];
        int stack_top = 0;
        int pc = 0, tp = start;
        int matched = 0;

        if (saves && nsaves > 0) saves[0] = text + start;

        while (1) {
            if (pc >= prog->len) break;
            ReInst* inst = &prog->code[pc];
            switch (inst->op) {
            case RE_LIT:
                if (tp >= text_len || text[tp] != inst->c) goto backtrack;
                tp++; pc++;
                break;
            case RE_DOT:
                if (tp >= text_len || text[tp] == '\n') goto backtrack;
                tp++; pc++;
                break;
            case RE_DIGIT:
                if (tp >= text_len || !re_is_digit(text[tp])) goto backtrack;
                tp++; pc++;
                break;
            case RE_NDIGIT:
                if (tp >= text_len || re_is_digit(text[tp])) goto backtrack;
                tp++; pc++;
                break;
            case RE_WORD:
                if (tp >= text_len || !re_is_word(text[tp])) goto backtrack;
                tp++; pc++;
                break;
            case RE_NWORD:
                if (tp >= text_len || re_is_word(text[tp])) goto backtrack;
                tp++; pc++;
                break;
            case RE_SPACE:
                if (tp >= text_len || !re_is_space(text[tp])) goto backtrack;
                tp++; pc++;
                break;
            case RE_NSPACE:
                if (tp >= text_len || re_is_space(text[tp])) goto backtrack;
                tp++; pc++;
                break;
            case RE_CLASS:
                if (tp >= text_len || !re_class_match(inst->cls, inst->cls_len, text[tp])) goto backtrack;
                tp++; pc++;
                break;
            case RE_NCLASS:
                if (tp >= text_len || re_class_match(inst->cls, inst->cls_len, text[tp])) goto backtrack;
                tp++; pc++;
                break;
            case RE_START:
                if (tp != 0) goto backtrack;
                pc++;
                break;
            case RE_END:
                if (tp != text_len) goto backtrack;
                pc++;
                break;
            case RE_SPLIT:
                /* Try x first, save y for backtrack */
                if (stack_top >= RE_MAX_INST) goto backtrack;
                sp_stack[stack_top] = inst->y;
                tp_stack[stack_top] = tp;
                stack_top++;
                pc = inst->x;
                break;
            case RE_JMP:
                pc = inst->x;
                break;
            case RE_SAVE:
                pc++;
                break;
            case RE_MATCH:
                if (saves && nsaves > 1) saves[1] = text + tp;
                matched = 1;
                goto done;
            }
            continue;
backtrack:
            if (stack_top == 0) goto done;
            stack_top--;
            pc = sp_stack[stack_top];
            tp = tp_stack[stack_top];
        }
done:
        if (matched) return 1;
        if (anchored) break;
    }
    return 0;
}

static void re_free(ReProg* prog) {
    for (int i = 0; i < prog->len; i++) {
        if (prog->code[i].cls) { free(prog->code[i].cls); prog->code[i].cls = NULL; }
    }
}

/* text matches "pattern" — returns 1 if pattern matches anywhere in text */
int64_t nova_rt_regex_match(int64_t text_ptr, int64_t pattern_ptr) {
    const char* text = (const char*)(uintptr_t)text_ptr;
    const char* pattern = (const char*)(uintptr_t)pattern_ptr;
    if (!text || !pattern) return 0;

    ReProg prog;
    memset(&prog, 0, sizeof(prog));
    if (re_compile(pattern, &prog) != 0) {
        nova_set_error("regex: invalid pattern");
        re_free(&prog);
        return 0;
    }
    int result = re_exec(&prog, text, NULL, 0);
    re_free(&prog);
    return (int64_t)result;
}

/* regex_find(text, pattern) — returns first match substring, or "" */
int64_t nova_rt_regex_find(int64_t text_ptr, int64_t pattern_ptr) {
    const char* text = (const char*)(uintptr_t)text_ptr;
    const char* pattern = (const char*)(uintptr_t)pattern_ptr;
    if (!text || !pattern) return (int64_t)(uintptr_t)"";

    ReProg prog;
    memset(&prog, 0, sizeof(prog));
    if (re_compile(pattern, &prog) != 0) {
        nova_set_error("regex: invalid pattern");
        re_free(&prog);
        return (int64_t)(uintptr_t)"";
    }
    const char* saves[2] = {NULL, NULL};
    int found = re_exec(&prog, text, saves, 2);
    re_free(&prog);
    if (!found || !saves[0] || !saves[1]) return (int64_t)(uintptr_t)"";
    size_t mlen = saves[1] - saves[0];
    char* result = (char*)nova_heap_alloc(mlen + 1, NOVA_MEM_RAW);
    if (!result) return (int64_t)(uintptr_t)"";
    memcpy(result, saves[0], mlen);
    result[mlen] = 0;
    return (int64_t)(uintptr_t)result;
}

/* regex_replace(text, pattern, replacement) — replaces first match */
int64_t nova_rt_regex_replace(int64_t text_ptr, int64_t pattern_ptr, int64_t repl_ptr) {
    const char* text = (const char*)(uintptr_t)text_ptr;
    const char* pattern = (const char*)(uintptr_t)pattern_ptr;
    const char* repl = (const char*)(uintptr_t)repl_ptr;
    if (!text || !pattern || !repl) return text_ptr;

    ReProg prog;
    memset(&prog, 0, sizeof(prog));
    if (re_compile(pattern, &prog) != 0) {
        nova_set_error("regex: invalid pattern");
        re_free(&prog);
        return text_ptr;
    }
    const char* saves[2] = {NULL, NULL};
    int found = re_exec(&prog, text, saves, 2);
    re_free(&prog);
    if (!found || !saves[0] || !saves[1]) return text_ptr;

    size_t prefix_len = saves[0] - text;
    size_t match_len = saves[1] - saves[0];
    size_t suffix_len = strlen(saves[1]);
    size_t repl_len = strlen(repl);
    size_t total = prefix_len + repl_len + suffix_len + 1;
    char* result = (char*)nova_heap_alloc(total, NOVA_MEM_RAW);
    if (!result) return text_ptr;
    memcpy(result, text, prefix_len);
    memcpy(result + prefix_len, repl, repl_len);
    memcpy(result + prefix_len + repl_len, saves[1], suffix_len + 1);
    return (int64_t)(uintptr_t)result;
}

/* regex_split(text, pattern) — splits text by pattern, returns list */
int64_t nova_rt_regex_split(int64_t text_ptr, int64_t pattern_ptr) {
    const char* text = (const char*)(uintptr_t)text_ptr;
    const char* pattern = (const char*)(uintptr_t)pattern_ptr;

    /* Create empty list */
    int64_t list = nova_rt_list_create();

    if (!text || !pattern) return list;

    ReProg prog;
    memset(&prog, 0, sizeof(prog));
    if (re_compile(pattern, &prog) != 0) {
        nova_set_error("regex: invalid pattern");
        re_free(&prog);
        return list;
    }

    const char* cur = text;
    while (*cur) {
        const char* saves[2] = {NULL, NULL};
        int found = re_exec(&prog, cur, saves, 2);
        if (!found || !saves[0] || !saves[1] || saves[0] == saves[1]) {
            /* No more matches — add rest of string */
            size_t rest_len = strlen(cur);
            char* seg = (char*)nova_heap_alloc(rest_len + 1, NOVA_MEM_RAW);
            if (seg) { memcpy(seg, cur, rest_len + 1); }
            else { seg = (char*)""; }
            nova_rt_list_append(list, (int64_t)(uintptr_t)seg);
            break;
        }
        /* Add segment before match */
        size_t seg_len = saves[0] - cur;
        char* seg = (char*)nova_heap_alloc(seg_len + 1, NOVA_MEM_RAW);
        if (seg) { memcpy(seg, cur, seg_len); seg[seg_len] = 0; }
        else { seg = (char*)""; }
        nova_rt_list_append(list, (int64_t)(uintptr_t)seg);
        cur = saves[1];
        if (*cur == 0) {
            /* Pattern matched at end — add empty string */
            nova_rt_list_append(list, (int64_t)(uintptr_t)"");
            break;
        }
    }
    re_free(&prog);
    return list;
}

/* ── TCP/UDP Sockets (cross-platform) ──────────────────────────────────────── */

#ifdef _WIN32
static int nova_wsa_inited = 0;
static void nova_wsa_init(void) {
    if (!nova_wsa_inited) {
        WSADATA wsa;
        WSAStartup(MAKEWORD(2, 2), &wsa);
        nova_wsa_inited = 1;
    }
}
#define NOVA_SOCKET SOCKET
#define NOVA_INVALID_SOCKET INVALID_SOCKET
#define NOVA_CLOSE_SOCKET closesocket
#else
#define NOVA_SOCKET int
#define NOVA_INVALID_SOCKET (-1)
#define NOVA_CLOSE_SOCKET close
static void nova_wsa_init(void) {}
#endif

int64_t nova_rt_tcp_connect(int64_t host_ptr, int64_t port_val) {
    nova_wsa_init();
    const char* host = (const char*)(uintptr_t)host_ptr;
    int port = (int)port_val;
    if (!host) { nova_set_error("tcp_connect: null host"); return -1; }

    struct addrinfo hints, *res;
    memset(&hints, 0, sizeof(hints));
    hints.ai_family = AF_INET;
    hints.ai_socktype = SOCK_STREAM;
    char port_str[16];
    snprintf(port_str, sizeof(port_str), "%d", port);
    if (getaddrinfo(host, port_str, &hints, &res) != 0) {
        nova_set_error("tcp_connect: cannot resolve host");
        return -1;
    }
    NOVA_SOCKET sock = socket(res->ai_family, res->ai_socktype, res->ai_protocol);
    if (sock == NOVA_INVALID_SOCKET) {
        freeaddrinfo(res);
        nova_set_error("tcp_connect: socket creation failed");
        return -1;
    }
    if (connect(sock, res->ai_addr, (int)res->ai_addrlen) != 0) {
        NOVA_CLOSE_SOCKET(sock);
        freeaddrinfo(res);
        nova_set_error("tcp_connect: connection failed");
        return -1;
    }
    freeaddrinfo(res);
    return (int64_t)sock;
}

int64_t nova_rt_tcp_listen(int64_t port_val) {
    nova_wsa_init();
    int port = (int)port_val;
    NOVA_SOCKET sock = socket(AF_INET, SOCK_STREAM, 0);
    if (sock == NOVA_INVALID_SOCKET) {
        nova_set_error("tcp_listen: socket creation failed");
        return -1;
    }
    int opt = 1;
    setsockopt(sock, SOL_SOCKET, SO_REUSEADDR, (const char*)&opt, sizeof(opt));
    struct sockaddr_in addr;
    memset(&addr, 0, sizeof(addr));
    addr.sin_family = AF_INET;
    addr.sin_addr.s_addr = INADDR_ANY;
    addr.sin_port = htons((unsigned short)port);
    if (bind(sock, (struct sockaddr*)&addr, sizeof(addr)) != 0) {
        NOVA_CLOSE_SOCKET(sock);
        nova_set_error("tcp_listen: bind failed");
        return -1;
    }
    if (listen(sock, 128) != 0) {
        NOVA_CLOSE_SOCKET(sock);
        nova_set_error("tcp_listen: listen failed");
        return -1;
    }
    return (int64_t)sock;
}

int64_t nova_rt_tcp_accept(int64_t server_val) {
    NOVA_SOCKET server = (NOVA_SOCKET)server_val;
    struct sockaddr_in client_addr;
    int addrlen = sizeof(client_addr);
#ifdef _WIN32
    NOVA_SOCKET client = accept(server, (struct sockaddr*)&client_addr, &addrlen);
#else
    socklen_t slen = (socklen_t)addrlen;
    NOVA_SOCKET client = accept(server, (struct sockaddr*)&client_addr, &slen);
#endif
    if (client == NOVA_INVALID_SOCKET) {
        nova_set_error("tcp_accept: accept failed");
        return -1;
    }
    return (int64_t)client;
}

int64_t nova_rt_tcp_send(int64_t sock_val, int64_t data_ptr) {
    NOVA_SOCKET sock = (NOVA_SOCKET)sock_val;
    const char* data = (const char*)(uintptr_t)data_ptr;
    if (!data) return 0;
    int len = (int)strlen(data);
    int sent = send(sock, data, len, 0);
    if (sent < 0) {
        nova_set_error("tcp_send: send failed");
        return -1;
    }
    return (int64_t)sent;
}

int64_t nova_rt_tcp_recv(int64_t sock_val) {
    NOVA_SOCKET sock = (NOVA_SOCKET)sock_val;
    char buf[4096];
    int n = recv(sock, buf, sizeof(buf) - 1, 0);
    if (n <= 0) return (int64_t)(uintptr_t)"";
    buf[n] = 0;
    char* result = (char*)nova_heap_alloc(n + 1, NOVA_MEM_RAW);
    if (!result) return (int64_t)(uintptr_t)"";
    memcpy(result, buf, n + 1);
    return (int64_t)(uintptr_t)result;
}

void nova_rt_tcp_close(int64_t sock_val) {
    NOVA_SOCKET sock = (NOVA_SOCKET)sock_val;
    NOVA_CLOSE_SOCKET(sock);
}

int64_t nova_rt_udp_bind(int64_t port_val) {
    nova_wsa_init();
    int port = (int)port_val;
    NOVA_SOCKET sock = socket(AF_INET, SOCK_DGRAM, 0);
    if (sock == NOVA_INVALID_SOCKET) {
        nova_set_error("udp_bind: socket creation failed");
        return -1;
    }
    struct sockaddr_in addr;
    memset(&addr, 0, sizeof(addr));
    addr.sin_family = AF_INET;
    addr.sin_addr.s_addr = INADDR_ANY;
    addr.sin_port = htons((unsigned short)port);
    if (bind(sock, (struct sockaddr*)&addr, sizeof(addr)) != 0) {
        NOVA_CLOSE_SOCKET(sock);
        nova_set_error("udp_bind: bind failed");
        return -1;
    }
    return (int64_t)sock;
}

int64_t nova_rt_udp_send(int64_t sock_val, int64_t host_ptr, int64_t port_val, int64_t data_ptr) {
    NOVA_SOCKET sock = (NOVA_SOCKET)sock_val;
    const char* host = (const char*)(uintptr_t)host_ptr;
    int port = (int)port_val;
    const char* data = (const char*)(uintptr_t)data_ptr;
    if (!host || !data) return -1;
    struct sockaddr_in dest;
    memset(&dest, 0, sizeof(dest));
    dest.sin_family = AF_INET;
    dest.sin_port = htons((unsigned short)port);
    inet_pton(AF_INET, host, &dest.sin_addr);
    int len = (int)strlen(data);
    int sent = sendto(sock, data, len, 0, (struct sockaddr*)&dest, sizeof(dest));
    if (sent < 0) {
        nova_set_error("udp_send: sendto failed");
        return -1;
    }
    return (int64_t)sent;
}

int64_t nova_rt_udp_recv(int64_t sock_val) {
    NOVA_SOCKET sock = (NOVA_SOCKET)sock_val;
    char buf[4096];
    struct sockaddr_in from;
    int fromlen = sizeof(from);
#ifdef _WIN32
    int n = recvfrom(sock, buf, sizeof(buf) - 1, 0, (struct sockaddr*)&from, &fromlen);
#else
    socklen_t slen = (socklen_t)fromlen;
    int n = recvfrom(sock, buf, sizeof(buf) - 1, 0, (struct sockaddr*)&from, &slen);
#endif
    if (n <= 0) return (int64_t)(uintptr_t)"";
    buf[n] = 0;
    char* result = (char*)nova_heap_alloc(n + 1, NOVA_MEM_RAW);
    if (!result) return (int64_t)(uintptr_t)"";
    memcpy(result, buf, n + 1);
    return (int64_t)(uintptr_t)result;
}

/* ── HTTP Server (minimal, single-threaded) ────────────────────────────────── */

int64_t nova_rt_http_listen(int64_t port_val) {
    return nova_rt_tcp_listen(port_val);
}

int64_t nova_rt_http_accept(int64_t server_val) {
    NOVA_SOCKET client = (NOVA_SOCKET)nova_rt_tcp_accept(server_val);
    if ((int64_t)client == -1) return 0;
    char buf[8192];
    int n = recv(client, buf, sizeof(buf) - 1, 0);
    if (n <= 0) { NOVA_CLOSE_SOCKET(client); return 0; }
    buf[n] = 0;

    /* Parse: METHOD PATH HTTP/1.x\r\n... */
    char method[16] = "", path[2048] = "", body[4096] = "";
    char* line = buf;
    char* sp1 = strchr(line, ' ');
    if (sp1) {
        size_t mlen = sp1 - line;
        if (mlen > 15) mlen = 15;
        memcpy(method, line, mlen); method[mlen] = 0;
        char* sp2 = strchr(sp1 + 1, ' ');
        if (sp2) {
            size_t plen = sp2 - sp1 - 1;
            if (plen > 2047) plen = 2047;
            memcpy(path, sp1 + 1, plen); path[plen] = 0;
        }
    }
    /* Find body after \r\n\r\n */
    char* body_start = strstr(buf, "\r\n\r\n");
    if (body_start) {
        body_start += 4;
        size_t blen = strlen(body_start);
        if (blen > 4095) blen = 4095;
        memcpy(body, body_start, blen); body[blen] = 0;
    }

    /* Return a dict-like struct: {client, method, path, body} packed as a list */
    int64_t list = nova_rt_list_create();
    /* [0] = client socket, [1] = method, [2] = path, [3] = body */
    nova_rt_list_append(list, (int64_t)client);
    char* m = (char*)nova_heap_alloc(strlen(method)+1, NOVA_MEM_RAW);
    if (m) { strcpy(m, method); } else m = (char*)"";
    nova_rt_list_append(list, (int64_t)(uintptr_t)m);
    char* p = (char*)nova_heap_alloc(strlen(path)+1, NOVA_MEM_RAW);
    if (p) { strcpy(p, path); } else p = (char*)"";
    nova_rt_list_append(list, (int64_t)(uintptr_t)p);
    char* b = (char*)nova_heap_alloc(strlen(body)+1, NOVA_MEM_RAW);
    if (b) { strcpy(b, body); } else b = (char*)"";
    nova_rt_list_append(list, (int64_t)(uintptr_t)b);
    return list;
}

/* Read an HTTP request from an already-connected client socket. Returns the
   raw request bytes (headers + body, up to Content-Length). Empty string on
   connection error. Used by multi-threaded HTTP servers — accept first, then
   spawn a worker that reads + parses + responds on a different thread. */
int64_t nova_rt_http_read_request(int64_t client_val) {
    NOVA_SOCKET client = (NOVA_SOCKET)client_val;
    size_t cap = 65536;
    char* buf = (char*)malloc(cap);
    if (!buf) return (int64_t)(uintptr_t)"";
    size_t total = 0;
    int header_done = 0;
    size_t content_length = 0;
    size_t body_start = 0;
    while (total < cap - 1) {
        int n = recv(client, buf + total, (int)(cap - 1 - total), 0);
        if (n <= 0) break;
        total += (size_t)n;
        buf[total] = 0;
        if (!header_done) {
            char* end = strstr(buf, "\r\n\r\n");
            if (end) {
                header_done = 1;
                body_start = (size_t)(end - buf) + 4;
                char* cl = strstr(buf, "Content-Length:");
                if (!cl) cl = strstr(buf, "content-length:");
                if (cl) {
                    cl += 15;
                    while (*cl == ' ') cl++;
                    content_length = (size_t)atol(cl);
                }
            }
        }
        if (header_done && total - body_start >= content_length) break;
    }
    char* tracked = (char*)nova_heap_alloc(total + 1, NOVA_MEM_RAW);
    if (tracked) { memcpy(tracked, buf, total); tracked[total] = 0; }
    else { tracked = (char*)""; }
    free(buf);
    return (int64_t)(uintptr_t)tracked;
}

/* Accept a connection and return [client_socket, raw_request_string].
   Lets NOVA-side code parse HTTP without a C dependency on format details. */
int64_t nova_rt_http_accept_raw(int64_t server_val) {
    NOVA_SOCKET client = (NOVA_SOCKET)nova_rt_tcp_accept(server_val);
    if ((int64_t)client == -1) return nova_rt_list_create();

    /* Read up to 64K — enough for most requests including reasonable bodies */
    size_t cap = 65536;
    char* buf = (char*)malloc(cap);
    if (!buf) { NOVA_CLOSE_SOCKET(client); return nova_rt_list_create(); }
    size_t total = 0;
    int header_done = 0;
    size_t content_length = 0;
    size_t body_start = 0;
    while (total < cap - 1) {
        int n = recv(client, buf + total, (int)(cap - 1 - total), 0);
        if (n <= 0) break;
        total += (size_t)n;
        buf[total] = 0;
        if (!header_done) {
            char* end = strstr(buf, "\r\n\r\n");
            if (end) {
                header_done = 1;
                body_start = (size_t)(end - buf) + 4;
                /* Look for Content-Length */
                char* cl = strstr(buf, "Content-Length:");
                if (!cl) cl = strstr(buf, "content-length:");
                if (cl) {
                    cl += 15;
                    while (*cl == ' ') cl++;
                    content_length = (size_t)atol(cl);
                }
            }
        }
        if (header_done) {
            if (total - body_start >= content_length) break;
        }
    }

    int64_t list = nova_rt_list_create();
    nova_rt_list_append(list, (int64_t)client);
    char* tracked = (char*)nova_heap_alloc(total + 1, NOVA_MEM_RAW);
    if (tracked) { memcpy(tracked, buf, total); tracked[total] = 0; }
    else { tracked = (char*)""; }
    nova_rt_list_append(list, (int64_t)(uintptr_t)tracked);
    free(buf);
    return list;
}

/* Send raw response bytes and close the connection.
   The NOVA-side framework constructs the full response string. */
void nova_rt_http_send_raw(int64_t client_val, int64_t response_ptr) {
    NOVA_SOCKET client = (NOVA_SOCKET)client_val;
    const char* response = (const char*)(uintptr_t)response_ptr;
    if (!response) { NOVA_CLOSE_SOCKET(client); return; }
    size_t len = strlen(response);
    size_t sent = 0;
    while (sent < len) {
        int n = send(client, response + sent, (int)(len - sent), 0);
        if (n <= 0) break;
        sent += (size_t)n;
    }
    NOVA_CLOSE_SOCKET(client);
}

void nova_rt_http_respond(int64_t client_val, int64_t status_val, int64_t body_ptr) {
    NOVA_SOCKET client = (NOVA_SOCKET)client_val;
    int status = (int)status_val;
    const char* body = (const char*)(uintptr_t)body_ptr;
    if (!body) body = "";

    const char* status_text = "OK";
    if (status == 404) status_text = "Not Found";
    else if (status == 500) status_text = "Internal Server Error";
    else if (status == 201) status_text = "Created";
    else if (status == 204) status_text = "No Content";
    else if (status == 400) status_text = "Bad Request";
    else if (status == 301) status_text = "Moved Permanently";
    else if (status == 302) status_text = "Found";

    size_t body_len = strlen(body);
    char header[512];
    int hlen = snprintf(header, sizeof(header),
        "HTTP/1.1 %d %s\r\nContent-Length: %zu\r\nContent-Type: text/plain\r\nConnection: close\r\n\r\n",
        status, status_text, body_len);
    send(client, header, hlen, 0);
    if (body_len > 0) send(client, body, (int)body_len, 0);
    NOVA_CLOSE_SOCKET(client);
}

/* ── Extended Standard Library ──────────────────────────────────────────────── */

typedef int64_t (*nova_fn2)(int64_t env, int64_t arg1, int64_t arg2);

int64_t nova_rt_enumerate(int64_t handle) {
    NovaList* l = (NovaList*)(uintptr_t)handle;
    if (!l) return nova_rt_list_create();
    int64_t result = nova_rt_list_create();
    for (int64_t i = 0; i < l->size; i++) {
        int64_t pair = nova_rt_list_create();
        nova_rt_list_append(pair, i);
        nova_rt_list_append(pair, l->data[i]);
        nova_rt_list_append(result, pair);
    }
    return result;
}

int64_t nova_rt_zip(int64_t handle_a, int64_t handle_b) {
    NovaList* a = (NovaList*)(uintptr_t)handle_a;
    NovaList* b = (NovaList*)(uintptr_t)handle_b;
    if (!a || !b) return nova_rt_list_create();
    int64_t n = a->size < b->size ? a->size : b->size;
    int64_t result = nova_rt_list_create();
    for (int64_t i = 0; i < n; i++) {
        int64_t pair = nova_rt_list_create();
        nova_rt_list_append(pair, a->data[i]);
        nova_rt_list_append(pair, b->data[i]);
        nova_rt_list_append(result, pair);
    }
    return result;
}

int64_t nova_rt_reduce(int64_t handle, int64_t closure, int64_t init) {
    NovaList* l = (NovaList*)(uintptr_t)handle;
    int64_t* rec = (int64_t*)(uintptr_t)closure;
    nova_fn2 fn = (nova_fn2)(uintptr_t)rec[0];
    int64_t acc = init;
    if (!l) return acc;
    for (int64_t i = 0; i < l->size; i++) {
        acc = fn(closure, acc, l->data[i]);
    }
    return acc;
}

int64_t nova_rt_any_match(int64_t handle, int64_t closure) {
    NovaList* l = (NovaList*)(uintptr_t)handle;
    int64_t* rec = (int64_t*)(uintptr_t)closure;
    nova_fn1 fn = (nova_fn1)(uintptr_t)rec[0];
    if (!l) return 0;
    for (int64_t i = 0; i < l->size; i++) {
        if (fn(closure, l->data[i])) return 1;
    }
    return 0;
}

int64_t nova_rt_all_match(int64_t handle, int64_t closure) {
    NovaList* l = (NovaList*)(uintptr_t)handle;
    int64_t* rec = (int64_t*)(uintptr_t)closure;
    nova_fn1 fn = (nova_fn1)(uintptr_t)rec[0];
    if (!l) return 1;
    for (int64_t i = 0; i < l->size; i++) {
        if (!fn(closure, l->data[i])) return 0;
    }
    return 1;
}

int64_t nova_rt_sum(int64_t handle) {
    NovaList* l = (NovaList*)(uintptr_t)handle;
    if (!l || l->size == 0) return 0;
    int64_t acc = 0;
    for (int64_t i = 0; i < l->size; i++) {
        acc += l->data[i];
    }
    return acc;
}

int64_t nova_rt_index_of(int64_t handle, int64_t item) {
    NovaList* l = (NovaList*)(uintptr_t)handle;
    if (!l) return -1;
    for (int64_t i = 0; i < l->size; i++) {
        if (nova_rt_eq(l->data[i], item)) return i;
    }
    return -1;
}

static int64_t nova_sort_by_closure;
static int nova_sort_by_cmp(const void* a, const void* b) {
    int64_t va = *(const int64_t*)a;
    int64_t vb = *(const int64_t*)b;
    int64_t* rec = (int64_t*)(uintptr_t)nova_sort_by_closure;
    nova_fn1 fn = (nova_fn1)(uintptr_t)rec[0];
    int64_t ka = fn(nova_sort_by_closure, va);
    int64_t kb = fn(nova_sort_by_closure, vb);
    if (ka < kb) return -1;
    if (ka > kb) return 1;
    return 0;
}

int64_t nova_rt_sort_by(int64_t handle, int64_t closure) {
    NovaList* l = (NovaList*)(uintptr_t)handle;
    if (!l || l->size <= 1) return handle;
    int64_t new_list = nova_rt_list_create();
    NovaList* result = (NovaList*)(uintptr_t)new_list;
    result->cap = l->size;
    result->data = realloc(result->data, (size_t)l->size * sizeof(int64_t));
    memcpy(result->data, l->data, (size_t)l->size * sizeof(int64_t));
    result->size = l->size;
    for (int64_t i = 0; i < result->size; i++) nova_rc_inc(result->data[i]);
    nova_sort_by_closure = closure;
    qsort(result->data, (size_t)result->size, sizeof(int64_t), nova_sort_by_cmp);
    return new_list;
}

int64_t nova_rt_dict_merge(int64_t handle_a, int64_t handle_b) {
    int64_t result = nova_rt_dict_create();
    NovaDict* a = (NovaDict*)(uintptr_t)handle_a;
    NovaDict* b = (NovaDict*)(uintptr_t)handle_b;
    if (a) {
        for (int64_t i = 0; i < a->size; i++)
            nova_rt_dict_set(result, a->keys[i], a->vals[i]);
    }
    if (b) {
        for (int64_t i = 0; i < b->size; i++)
            nova_rt_dict_set(result, b->keys[i], b->vals[i]);
    }
    return result;
}

int64_t nova_rt_str_count(int64_t s, int64_t sub) {
    const char* str = (const char*)(uintptr_t)s;
    const char* pat = (const char*)(uintptr_t)sub;
    if (!str || !pat) return 0;
    size_t plen = strlen(pat);
    if (plen == 0) return 0;
    int64_t count = 0;
    const char* p = str;
    while ((p = strstr(p, pat)) != NULL) {
        count++;
        p += plen;
    }
    return count;
}

int64_t nova_rt_lstrip(int64_t s) {
    const char* str = (const char*)(uintptr_t)s;
    if (!str) return (int64_t)(uintptr_t)"";
    while (*str && isspace((unsigned char)*str)) str++;
    size_t len = strlen(str);
    char* result = (char*)nova_heap_alloc(len + 1, NOVA_MEM_RAW);
    if (!result) return (int64_t)(uintptr_t)"";
    memcpy(result, str, len + 1);
    return (int64_t)(uintptr_t)result;
}

int64_t nova_rt_rstrip(int64_t s) {
    const char* str = (const char*)(uintptr_t)s;
    if (!str) return (int64_t)(uintptr_t)"";
    size_t len = strlen(str);
    while (len > 0 && isspace((unsigned char)str[len - 1])) len--;
    char* result = (char*)nova_heap_alloc(len + 1, NOVA_MEM_RAW);
    if (!result) return (int64_t)(uintptr_t)"";
    memcpy(result, str, len);
    result[len] = '\0';
    return (int64_t)(uintptr_t)result;
}

int64_t nova_rt_pad_left(int64_t s, int64_t width, int64_t fill_char) {
    const char* str = (const char*)(uintptr_t)s;
    if (!str) str = "";
    size_t slen = strlen(str);
    int64_t w = width;
    if (w < 0) w = 0;
    if ((int64_t)slen >= w) {
        char* r = (char*)nova_heap_alloc(slen + 1, NOVA_MEM_RAW);
        if (!r) return s;
        memcpy(r, str, slen + 1);
        return (int64_t)(uintptr_t)r;
    }
    size_t pad = (size_t)(w - (int64_t)slen);
    char fc = fill_char ? (char)(fill_char & 0xFF) : ' ';
    char* result = (char*)nova_heap_alloc((size_t)w + 1, NOVA_MEM_RAW);
    if (!result) return s;
    memset(result, fc, pad);
    memcpy(result + pad, str, slen);
    result[w] = '\0';
    return (int64_t)(uintptr_t)result;
}

int64_t nova_rt_pad_right(int64_t s, int64_t width, int64_t fill_char) {
    const char* str = (const char*)(uintptr_t)s;
    if (!str) str = "";
    size_t slen = strlen(str);
    int64_t w = width;
    if (w < 0) w = 0;
    if ((int64_t)slen >= w) {
        char* r = (char*)nova_heap_alloc(slen + 1, NOVA_MEM_RAW);
        if (!r) return s;
        memcpy(r, str, slen + 1);
        return (int64_t)(uintptr_t)r;
    }
    size_t pad = (size_t)(w - (int64_t)slen);
    char fc = fill_char ? (char)(fill_char & 0xFF) : ' ';
    char* result = (char*)nova_heap_alloc((size_t)w + 1, NOVA_MEM_RAW);
    if (!result) return s;
    memcpy(result, str, slen);
    memset(result + slen, fc, pad);
    result[w] = '\0';
    return (int64_t)(uintptr_t)result;
}

int64_t nova_rt_cwd(void) {
#ifdef _WIN32
    char buf[MAX_PATH];
    DWORD len = GetCurrentDirectoryA(sizeof(buf), buf);
    if (len == 0 || len >= sizeof(buf)) return (int64_t)(uintptr_t)"";
#else
    char buf[4096];
    if (!getcwd(buf, sizeof(buf))) return (int64_t)(uintptr_t)"";
    size_t len = strlen(buf);
#endif
    char* result = (char*)nova_heap_alloc(len + 1, NOVA_MEM_RAW);
    if (!result) return (int64_t)(uintptr_t)"";
    memcpy(result, buf, len);
    result[len] = '\0';
    return (int64_t)(uintptr_t)result;
}

int64_t nova_rt_list_dir(int64_t path_ptr) {
    const char* path = (const char*)(uintptr_t)path_ptr;
    int64_t list = nova_rt_list_create();
    if (!path) return list;
#ifdef _WIN32
    char pattern[MAX_PATH + 3];
    snprintf(pattern, sizeof(pattern), "%s\\*", path);
    WIN32_FIND_DATAA fd;
    HANDLE hFind = FindFirstFileA(pattern, &fd);
    if (hFind == INVALID_HANDLE_VALUE) return list;
    do {
        if (strcmp(fd.cFileName, ".") == 0 || strcmp(fd.cFileName, "..") == 0) continue;
        size_t nlen = strlen(fd.cFileName);
        char* name = (char*)nova_heap_alloc(nlen + 1, NOVA_MEM_RAW);
        if (name) { memcpy(name, fd.cFileName, nlen + 1); }
        else name = (char*)"";
        nova_rt_list_append(list, (int64_t)(uintptr_t)name);
    } while (FindNextFileA(hFind, &fd));
    FindClose(hFind);
#else
    DIR* d = opendir(path);
    if (!d) return list;
    struct dirent* ent;
    while ((ent = readdir(d)) != NULL) {
        if (strcmp(ent->d_name, ".") == 0 || strcmp(ent->d_name, "..") == 0) continue;
        size_t nlen = strlen(ent->d_name);
        char* name = (char*)nova_heap_alloc(nlen + 1, NOVA_MEM_RAW);
        if (name) { memcpy(name, ent->d_name, nlen + 1); }
        else name = (char*)"";
        nova_rt_list_append(list, (int64_t)(uintptr_t)name);
    }
    closedir(d);
#endif
    return list;
}

int64_t nova_rt_hash(int64_t val) {
    if (val == 0) return 0;
    void* ptr = (void*)(uintptr_t)val;
    NovaMemTag tag = nova_mem_find_tag(ptr);
    if (tag == NOVA_MEM_RAW || tag == NOVA_MEM_FAT_STR ||
        ((uint64_t)val > 0x10000 && tag == (NovaMemTag)-1 && nova_is_readable_str(ptr))) {
        const char* s = (const char*)ptr;
        uint64_t h = 14695981039346656037ULL;
        while (*s) {
            h ^= (uint64_t)(unsigned char)*s++;
            h *= 1099511628211ULL;
        }
        return (int64_t)h;
    }
    uint64_t h = (uint64_t)val;
    h ^= h >> 33;
    h *= 0xff51afd7ed558ccdULL;
    h ^= h >> 33;
    h *= 0xc4ceb9fe1a85ec53ULL;
    h ^= h >> 33;
    return (int64_t)h;
}

int64_t nova_rt_flatten(int64_t handle) {
    NovaList* l = (NovaList*)(uintptr_t)handle;
    int64_t result = nova_rt_list_create();
    if (!l) return result;
    for (int64_t i = 0; i < l->size; i++) {
        void* ptr = (void*)(uintptr_t)l->data[i];
        NovaMemTag tag = nova_mem_find_tag(ptr);
        if (tag == NOVA_MEM_LIST) {
            NovaList* sub = (NovaList*)ptr;
            for (int64_t j = 0; j < sub->size; j++) {
                nova_rt_list_append(result, sub->data[j]);
            }
        } else {
            nova_rt_list_append(result, l->data[i]);
        }
    }
    return result;
}

/* ── Tensor (n-dimensional double array) ──────────────────────────────────── */

typedef struct {
    double*  data;
    int64_t* shape;     /* dimension sizes */
    int64_t  rank;      /* number of dimensions */
    int64_t  size;      /* total element count */
} NovaTensor;

static int64_t nova_tensor_size_from_shape(NovaList* shape) {
    if (!shape || shape->size == 0) return 0;
    int64_t s = 1;
    for (int64_t i = 0; i < shape->size; i++) s *= shape->data[i];
    return s;
}

int64_t nova_rt_tensor_zeros(int64_t shape_handle) {
    NovaList* shape = (NovaList*)(uintptr_t)shape_handle;
    if (!shape) return 0;
    NovaTensor* t = (NovaTensor*)nova_heap_alloc(sizeof(NovaTensor), NOVA_MEM_RAW);
    if (!t) return 0;
    t->rank = shape->size;
    t->size = nova_tensor_size_from_shape(shape);
    t->shape = (int64_t*)malloc((size_t)t->rank * sizeof(int64_t));
    t->data = (double*)calloc((size_t)t->size, sizeof(double));
    if (!t->shape || !t->data) { free(t->shape); free(t->data); return 0; }
    for (int64_t i = 0; i < t->rank; i++) t->shape[i] = shape->data[i];
    return (int64_t)(uintptr_t)t;
}

int64_t nova_rt_tensor_from_list(int64_t data_handle, int64_t shape_handle) {
    NovaList* data = (NovaList*)(uintptr_t)data_handle;
    NovaList* shape = (NovaList*)(uintptr_t)shape_handle;
    if (!data || !shape) return 0;
    int64_t expected = nova_tensor_size_from_shape(shape);
    if (data->size != expected) return 0;
    int64_t handle = nova_rt_tensor_zeros(shape_handle);
    NovaTensor* t = (NovaTensor*)(uintptr_t)handle;
    if (!t) return 0;
    for (int64_t i = 0; i < t->size; i++) {
        /* Caller stored each element as either an int (raw bits) or float bits */
        int64_t raw = data->data[i];
        double d;
        memcpy(&d, &raw, sizeof(double));
        /* If the integer is "small" we treat it as an int value */
        if (raw >= -1000000 && raw <= 1000000) {
            d = (double)raw;
        }
        t->data[i] = d;
    }
    return handle;
}

int64_t nova_rt_tensor_shape(int64_t t_handle) {
    NovaTensor* t = (NovaTensor*)(uintptr_t)t_handle;
    if (!t) return nova_rt_list_create();
    int64_t list = nova_rt_list_create();
    for (int64_t i = 0; i < t->rank; i++) nova_rt_list_append(list, t->shape[i]);
    return list;
}

int64_t nova_rt_tensor_size(int64_t t_handle) {
    NovaTensor* t = (NovaTensor*)(uintptr_t)t_handle;
    return t ? t->size : 0;
}

int64_t nova_rt_tensor_rank(int64_t t_handle) {
    NovaTensor* t = (NovaTensor*)(uintptr_t)t_handle;
    return t ? t->rank : 0;
}

static int64_t nova_tensor_flat_index(NovaTensor* t, NovaList* indices) {
    if (!t || !indices) return -1;
    if (indices->size != t->rank) return -1;
    int64_t flat = 0;
    int64_t stride = 1;
    for (int64_t i = t->rank - 1; i >= 0; i--) {
        int64_t idx = indices->data[i];
        if (idx < 0 || idx >= t->shape[i]) return -1;
        flat += idx * stride;
        stride *= t->shape[i];
    }
    return flat;
}

int64_t nova_rt_tensor_get(int64_t t_handle, int64_t indices_handle) {
    NovaTensor* t = (NovaTensor*)(uintptr_t)t_handle;
    NovaList* indices = (NovaList*)(uintptr_t)indices_handle;
    int64_t flat = nova_tensor_flat_index(t, indices);
    if (flat < 0) return 0;
    int64_t bits;
    memcpy(&bits, &t->data[flat], sizeof(bits));
    return bits;
}

void nova_rt_tensor_set(int64_t t_handle, int64_t indices_handle, int64_t val_bits) {
    NovaTensor* t = (NovaTensor*)(uintptr_t)t_handle;
    NovaList* indices = (NovaList*)(uintptr_t)indices_handle;
    int64_t flat = nova_tensor_flat_index(t, indices);
    if (flat < 0) return;
    double d;
    memcpy(&d, &val_bits, sizeof(d));
    /* Accept ints stored as raw int64 too */
    if (val_bits >= -1000000 && val_bits <= 1000000) d = (double)val_bits;
    t->data[flat] = d;
}

static int nova_tensor_shapes_equal(NovaTensor* a, NovaTensor* b) {
    if (!a || !b || a->rank != b->rank) return 0;
    for (int64_t i = 0; i < a->rank; i++) if (a->shape[i] != b->shape[i]) return 0;
    return 1;
}

static int64_t nova_tensor_alloc_like(NovaTensor* like) {
    int64_t shape_list = nova_rt_list_create();
    for (int64_t i = 0; i < like->rank; i++) nova_rt_list_append(shape_list, like->shape[i]);
    return nova_rt_tensor_zeros(shape_list);
}

int64_t nova_rt_tensor_add(int64_t a_h, int64_t b_h) {
    NovaTensor* a = (NovaTensor*)(uintptr_t)a_h;
    NovaTensor* b = (NovaTensor*)(uintptr_t)b_h;
    if (!nova_tensor_shapes_equal(a, b)) return 0;
    int64_t r = nova_tensor_alloc_like(a);
    NovaTensor* result = (NovaTensor*)(uintptr_t)r;
    for (int64_t i = 0; i < a->size; i++) result->data[i] = a->data[i] + b->data[i];
    return r;
}

int64_t nova_rt_tensor_mul(int64_t a_h, int64_t b_h) {
    NovaTensor* a = (NovaTensor*)(uintptr_t)a_h;
    NovaTensor* b = (NovaTensor*)(uintptr_t)b_h;
    if (!nova_tensor_shapes_equal(a, b)) return 0;
    int64_t r = nova_tensor_alloc_like(a);
    NovaTensor* result = (NovaTensor*)(uintptr_t)r;
    for (int64_t i = 0; i < a->size; i++) result->data[i] = a->data[i] * b->data[i];
    return r;
}

int64_t nova_rt_tensor_scale(int64_t a_h, int64_t scalar_bits) {
    NovaTensor* a = (NovaTensor*)(uintptr_t)a_h;
    if (!a) return 0;
    double s;
    memcpy(&s, &scalar_bits, sizeof(s));
    if (scalar_bits >= -1000000 && scalar_bits <= 1000000) s = (double)scalar_bits;
    int64_t r = nova_tensor_alloc_like(a);
    NovaTensor* result = (NovaTensor*)(uintptr_t)r;
    for (int64_t i = 0; i < a->size; i++) result->data[i] = a->data[i] * s;
    return r;
}

int64_t nova_rt_tensor_matmul(int64_t a_h, int64_t b_h) {
    NovaTensor* a = (NovaTensor*)(uintptr_t)a_h;
    NovaTensor* b = (NovaTensor*)(uintptr_t)b_h;
    if (!a || !b || a->rank != 2 || b->rank != 2) return 0;
    int64_t m = a->shape[0];
    int64_t k = a->shape[1];
    int64_t k2 = b->shape[0];
    int64_t n = b->shape[1];
    if (k != k2) return 0;

    int64_t shape_list = nova_rt_list_create();
    nova_rt_list_append(shape_list, m);
    nova_rt_list_append(shape_list, n);
    int64_t r = nova_rt_tensor_zeros(shape_list);
    NovaTensor* result = (NovaTensor*)(uintptr_t)r;
    if (!result) return 0;

    /* Standard ijk matmul. For larger sizes, blocked + parallel would be a win. */
    for (int64_t i = 0; i < m; i++) {
        for (int64_t kk = 0; kk < k; kk++) {
            double aik = a->data[i * k + kk];
            for (int64_t j = 0; j < n; j++) {
                result->data[i * n + j] += aik * b->data[kk * n + j];
            }
        }
    }
    return r;
}

int64_t nova_rt_tensor_sum(int64_t t_handle) {
    NovaTensor* t = (NovaTensor*)(uintptr_t)t_handle;
    if (!t) return 0;
    double s = 0;
    for (int64_t i = 0; i < t->size; i++) s += t->data[i];
    int64_t bits;
    memcpy(&bits, &s, sizeof(bits));
    return bits;
}

int64_t nova_rt_tensor_relu(int64_t t_handle) {
    NovaTensor* t = (NovaTensor*)(uintptr_t)t_handle;
    if (!t) return 0;
    int64_t r = nova_tensor_alloc_like(t);
    NovaTensor* result = (NovaTensor*)(uintptr_t)r;
    for (int64_t i = 0; i < t->size; i++) result->data[i] = t->data[i] > 0 ? t->data[i] : 0;
    return r;
}

int64_t nova_rt_tensor_to_list(int64_t t_handle) {
    NovaTensor* t = (NovaTensor*)(uintptr_t)t_handle;
    if (!t) return nova_rt_list_create();
    int64_t list = nova_rt_list_create();
    for (int64_t i = 0; i < t->size; i++) {
        int64_t bits;
        memcpy(&bits, &t->data[i], sizeof(bits));
        nova_rt_list_append(list, bits);
    }
    return list;
}

/* ── Byte Arrays ───────────────────────────────────────────────────────────── */

typedef struct {
    uint8_t* data;
    int64_t size;
    int64_t cap;
} NovaBytes;

int64_t nova_rt_bytes_create(int64_t size_val) {
    int64_t sz = size_val < 0 ? 0 : size_val;
    NovaBytes* b = (NovaBytes*)nova_heap_alloc(sizeof(NovaBytes), NOVA_MEM_RAW);
    if (!b) return 0;
    b->data = (uint8_t*)calloc((size_t)sz, 1);
    b->size = sz;
    b->cap = sz < 16 ? 16 : sz;
    if (!b->data && sz > 0) { b->data = (uint8_t*)calloc(16, 1); b->size = 0; b->cap = 16; }
    return (int64_t)(uintptr_t)b;
}

int64_t nova_rt_bytes_get(int64_t handle, int64_t index) {
    NovaBytes* b = (NovaBytes*)(uintptr_t)handle;
    if (!b || index < 0 || index >= b->size) return 0;
    return (int64_t)b->data[index];
}

void nova_rt_bytes_set(int64_t handle, int64_t index, int64_t value) {
    NovaBytes* b = (NovaBytes*)(uintptr_t)handle;
    if (!b || index < 0 || index >= b->size) return;
    b->data[index] = (uint8_t)(value & 0xFF);
}

int64_t nova_rt_bytes_len(int64_t handle) {
    NovaBytes* b = (NovaBytes*)(uintptr_t)handle;
    if (!b) return 0;
    return b->size;
}

int64_t nova_rt_bytes_slice(int64_t handle, int64_t start, int64_t end) {
    NovaBytes* b = (NovaBytes*)(uintptr_t)handle;
    if (!b) return nova_rt_bytes_create(0);
    if (start < 0) start = 0;
    if (end > b->size) end = b->size;
    if (start >= end) return nova_rt_bytes_create(0);
    int64_t new_size = end - start;
    int64_t result = nova_rt_bytes_create(new_size);
    NovaBytes* nb = (NovaBytes*)(uintptr_t)result;
    if (nb && nb->data) memcpy(nb->data, b->data + start, (size_t)new_size);
    return result;
}

int64_t nova_rt_bytes_to_str(int64_t handle) {
    NovaBytes* b = (NovaBytes*)(uintptr_t)handle;
    if (!b || b->size == 0) return (int64_t)(uintptr_t)"";
    char* s = (char*)nova_heap_alloc((size_t)b->size + 1, NOVA_MEM_RAW);
    if (!s) return (int64_t)(uintptr_t)"";
    memcpy(s, b->data, (size_t)b->size);
    s[b->size] = 0;
    return (int64_t)(uintptr_t)s;
}

int64_t nova_rt_str_to_bytes(int64_t str_ptr) {
    const char* s = (const char*)(uintptr_t)str_ptr;
    if (!s) return nova_rt_bytes_create(0);
    size_t len = strlen(s);
    int64_t result = nova_rt_bytes_create((int64_t)len);
    NovaBytes* b = (NovaBytes*)(uintptr_t)result;
    if (b && b->data) memcpy(b->data, s, len);
    return result;
}

int64_t nova_rt_str_char_at(int64_t str_val, int64_t index) {
    const char* s = (const char*)(uintptr_t)str_val;
    if (!s) return (int64_t)(uintptr_t)"";
    int64_t len = (int64_t)strlen(s);
    int64_t idx = index;
    if (idx < 0) idx += len;
    if (idx < 0 || idx >= len) return (int64_t)(uintptr_t)"";
    char* result = (char*)nova_heap_alloc(2, NOVA_MEM_RAW);
    if (!result) return (int64_t)(uintptr_t)"";
    result[0] = s[idx];
    result[1] = '\0';
    return (int64_t)(uintptr_t)result;
}

int64_t nova_rt_index_get(int64_t obj, int64_t index) {
    void* ptr = (void*)(uintptr_t)obj;
    NovaMemTag tag = nova_mem_find_tag(ptr);
    if (tag == NOVA_MEM_LIST) {
        return nova_rt_list_get(obj, index);
    }
    if (tag == NOVA_MEM_DICT) {
        return nova_rt_dict_get(obj, index);
    }
    return nova_rt_str_char_at(obj, index);
}

int64_t nova_rt_slice_any(int64_t obj, int64_t start, int64_t end) {
    void* ptr = (void*)(uintptr_t)obj;
    NovaMemTag tag = nova_mem_find_tag(ptr);
    if (tag == NOVA_MEM_LIST) {
        return nova_rt_list_slice(obj, start, end);
    }
    return nova_rt_slice(obj, start, end);
}

int64_t nova_rt_float_bits(int64_t str_val) {
    const char* s = (const char*)(uintptr_t)str_val;
    if (!s) return 0;
    double d = strtod(s, NULL);
    int64_t bits;
    memcpy(&bits, &d, sizeof(bits));
    return bits;
}

int64_t nova_rt_index_set(int64_t obj, int64_t index, int64_t value) {
    void* ptr = (void*)(uintptr_t)obj;
    NovaMemTag tag = nova_mem_find_tag(ptr);
    if (tag == NOVA_MEM_LIST) {
        return nova_rt_list_set(obj, index, value);
    }
    if (tag == NOVA_MEM_DICT) {
        return nova_rt_dict_set(obj, index, value);
    }
    return 0;
}

/* ── Result<T,E> and Option<T> ──────────────────────────────────────────── */

typedef struct {
    int64_t tag;   /* 0 = Ok/Some, 1 = Err/None */
    int64_t value; /* payload (i64-encoded) */
} NovaResult;

static int64_t nova_result_pack(int64_t tag, int64_t value) {
    NovaResult* r = (NovaResult*)nova_heap_alloc(sizeof(NovaResult), NOVA_MEM_RAW);
    if (!r) { fprintf(stderr, "nova: OOM allocating Result\n"); exit(1); }
    r->tag = tag;
    r->value = value;
    return (int64_t)(uintptr_t)r;
}

int64_t nova_rt_ok(int64_t value) {
    return nova_result_pack(0, value);
}

int64_t nova_rt_err(int64_t value) {
    return nova_result_pack(1, value);
}

int64_t nova_rt_some(int64_t value) {
    return nova_result_pack(0, value);
}

int64_t nova_rt_none(void) {
    return nova_result_pack(1, 0);
}

int64_t nova_rt_is_ok(int64_t handle) {
    NovaResult* r = (NovaResult*)(uintptr_t)handle;
    return r->tag == 0 ? 1 : 0;
}

int64_t nova_rt_is_err(int64_t handle) {
    NovaResult* r = (NovaResult*)(uintptr_t)handle;
    return r->tag == 1 ? 1 : 0;
}

int64_t nova_rt_is_some(int64_t handle) {
    NovaResult* r = (NovaResult*)(uintptr_t)handle;
    return r->tag == 0 ? 1 : 0;
}

int64_t nova_rt_is_none(int64_t handle) {
    NovaResult* r = (NovaResult*)(uintptr_t)handle;
    return r->tag == 1 ? 1 : 0;
}

int64_t nova_rt_unwrap(int64_t handle) {
    NovaResult* r = (NovaResult*)(uintptr_t)handle;
    if (r->tag != 0) {
        if (r->value != 0) {
            void* vp = (void*)(uintptr_t)r->value;
            if (nova_strpool_contains(vp)) {
                fprintf(stderr, "nova: unwrap called on Err/None: %s\n", (const char*)vp);
            } else {
                fprintf(stderr, "nova: unwrap called on Err/None (value=%lld)\n", (long long)r->value);
            }
        } else {
            fprintf(stderr, "nova: unwrap called on None\n");
        }
        exit(1);
    }
    return r->value;
}

int64_t nova_rt_unwrap_err(int64_t handle) {
    NovaResult* r = (NovaResult*)(uintptr_t)handle;
    if (r->tag != 1) {
        fprintf(stderr, "nova: unwrap_err called on Ok/Some\n");
        exit(1);
    }
    return r->value;
}

int64_t nova_rt_unwrap_or(int64_t handle, int64_t default_val) {
    NovaResult* r = (NovaResult*)(uintptr_t)handle;
    if (r->tag == 0) return r->value;
    return default_val;
}

int64_t nova_rt_result_tag(int64_t handle) {
    NovaResult* r = (NovaResult*)(uintptr_t)handle;
    return r->tag;
}

int64_t nova_rt_result_map(int64_t handle, int64_t closure) {
    NovaResult* r = (NovaResult*)(uintptr_t)handle;
    if (r->tag != 0) return handle;
    int64_t* rec = (int64_t*)(uintptr_t)closure;
    nova_fn1 fn = (nova_fn1)(uintptr_t)rec[0];
    return nova_result_pack(0, fn(closure, r->value));
}

int64_t nova_rt_result_map_err(int64_t handle, int64_t closure) {
    NovaResult* r = (NovaResult*)(uintptr_t)handle;
    if (r->tag == 0) return handle;
    int64_t* rec = (int64_t*)(uintptr_t)closure;
    nova_fn1 fn = (nova_fn1)(uintptr_t)rec[0];
    return nova_result_pack(1, fn(closure, r->value));
}

int64_t nova_rt_result_and_then(int64_t handle, int64_t closure) {
    NovaResult* r = (NovaResult*)(uintptr_t)handle;
    if (r->tag != 0) return handle;
    int64_t* rec = (int64_t*)(uintptr_t)closure;
    nova_fn1 fn = (nova_fn1)(uintptr_t)rec[0];
    return fn(closure, r->value);
}

int64_t nova_rt_result_or_else(int64_t handle, int64_t closure) {
    NovaResult* r = (NovaResult*)(uintptr_t)handle;
    if (r->tag == 0) return handle;
    int64_t* rec = (int64_t*)(uintptr_t)closure;
    nova_fn1 fn = (nova_fn1)(uintptr_t)rec[0];
    return fn(closure, r->value);
}

/* ── String formatting: format(template, args_list) ─────────────────────── */

static void fmt_pad(char* out, int* pos, int max, const char* val, int vlen,
                    int width, char fill, char align) {
    if (width <= vlen || width <= 0) {
        for (int i = 0; i < vlen && *pos < max - 1; i++)
            out[(*pos)++] = val[i];
        return;
    }
    int pad = width - vlen;
    if (align == '>') {
        for (int i = 0; i < pad && *pos < max - 1; i++) out[(*pos)++] = fill;
        for (int i = 0; i < vlen && *pos < max - 1; i++) out[(*pos)++] = val[i];
    } else if (align == '^') {
        int lpad = pad / 2;
        int rpad = pad - lpad;
        for (int i = 0; i < lpad && *pos < max - 1; i++) out[(*pos)++] = fill;
        for (int i = 0; i < vlen && *pos < max - 1; i++) out[(*pos)++] = val[i];
        for (int i = 0; i < rpad && *pos < max - 1; i++) out[(*pos)++] = fill;
    } else {
        for (int i = 0; i < vlen && *pos < max - 1; i++) out[(*pos)++] = val[i];
        for (int i = 0; i < pad && *pos < max - 1; i++) out[(*pos)++] = fill;
    }
}

int64_t nova_rt_format(int64_t template_s, int64_t args_handle) {
    const char* tmpl = (const char*)(uintptr_t)template_s;
    NovaList* args = (NovaList*)(uintptr_t)args_handle;
    int tlen = (int)strlen(tmpl);

    char out[8192];
    int pos = 0;
    int arg_idx = 0;
    int max = sizeof(out);

    for (int i = 0; i < tlen && pos < max - 1; i++) {
        if (tmpl[i] == '{' && i + 1 < tlen && tmpl[i+1] == '{') {
            out[pos++] = '{';
            i++;
            continue;
        }
        if (tmpl[i] == '}' && i + 1 < tlen && tmpl[i+1] == '}') {
            out[pos++] = '}';
            i++;
            continue;
        }
        if (tmpl[i] == '{') {
            int spec_start = i + 1;
            int spec_end = spec_start;
            while (spec_end < tlen && tmpl[spec_end] != '}') spec_end++;
            char spec[128] = {0};
            int slen = spec_end - spec_start;
            if (slen > 0 && slen < 127)
                memcpy(spec, tmpl + spec_start, (size_t)slen);
            i = spec_end;

            int64_t val = (args && arg_idx < args->size) ? args->data[arg_idx++] : 0;

            char fill = ' ';
            char align = '<';
            int width = 0;
            int precision = -1;
            char type_ch = 's';
            int zero_pad = 0;

            char* sp = spec;
            if (*sp == ':') sp++;
            if (sp[0] && sp[1] && (sp[1] == '<' || sp[1] == '>' || sp[1] == '^')) {
                fill = sp[0];
                align = sp[1];
                sp += 2;
            } else if (*sp == '<' || *sp == '>' || *sp == '^') {
                align = *sp;
                sp++;
            }
            if (*sp == '0') {
                zero_pad = 1;
                fill = '0';
                align = '>';
                sp++;
            }
            while (*sp >= '0' && *sp <= '9') {
                width = width * 10 + (*sp - '0');
                sp++;
            }
            if (*sp == '.') {
                sp++;
                precision = 0;
                while (*sp >= '0' && *sp <= '9') {
                    precision = precision * 10 + (*sp - '0');
                    sp++;
                }
            }
            if (*sp == 'd' || *sp == 'f' || *sp == 's' || *sp == 'x' || *sp == 'o' || *sp == 'b') {
                type_ch = *sp;
            } else if (*sp == 0 && slen == 0) {
                type_ch = 0;
            }

            char vbuf[256];
            int vlen = 0;

            if (type_ch == 0 && precision < 0) {
                int is_str = 0;
                if (val != 0 && (uint64_t)val > 0x10000) {
                    void* vp = (void*)(uintptr_t)val;
                    NovaMemTag mt = nova_mem_find_tag(vp);
                    if (mt == NOVA_MEM_RAW || mt == NOVA_MEM_FAT_STR) {
                        is_str = 1;
                    } else if (mt == (NovaMemTag)-1 && nova_is_readable_str(vp)) {
                        is_str = 1;
                    }
                }
                if (is_str) {
                    const char* s = (const char*)(uintptr_t)val;
                    if (s) { vlen = (int)strlen(s); if (vlen > 255) vlen = 255; memcpy(vbuf, s, (size_t)vlen); vbuf[vlen] = 0; }
                } else {
                    vlen = snprintf(vbuf, sizeof(vbuf), "%lld", (long long)val);
                }
            } else if (type_ch == 'd') {
                vlen = snprintf(vbuf, sizeof(vbuf), "%lld", (long long)val);
            } else if (type_ch == 'x') {
                vlen = snprintf(vbuf, sizeof(vbuf), "%llx", (long long)val);
            } else if (type_ch == 'o') {
                vlen = snprintf(vbuf, sizeof(vbuf), "%llo", (long long)val);
            } else if (type_ch == 'b') {
                int64_t v = val;
                if (v == 0) { vbuf[0] = '0'; vlen = 1; }
                else {
                    char tmp[66];
                    int ti = 0;
                    int64_t uv = v < 0 ? -v : v;
                    while (uv > 0) { tmp[ti++] = '0' + (int)(uv & 1); uv >>= 1; }
                    if (v < 0) { vbuf[0] = '-'; vlen = 1; }
                    for (int j = ti - 1; j >= 0; j--) vbuf[vlen++] = tmp[j];
                }
                vbuf[vlen] = 0;
            } else if (type_ch == 'f') {
                double d;
                memcpy(&d, &val, sizeof(d));
                if (precision < 0) precision = 6;
                vlen = snprintf(vbuf, sizeof(vbuf), "%.*f", precision, d);
            } else if (type_ch == 's' || type_ch == 0) {
                const char* s = (const char*)(uintptr_t)val;
                if (s) {
                    vlen = (int)strlen(s);
                    if (precision >= 0 && vlen > precision) vlen = precision;
                    if (vlen > 255) vlen = 255;
                    memcpy(vbuf, s, (size_t)vlen);
                    vbuf[vlen] = 0;
                }
            }

            fmt_pad(out, &pos, max, vbuf, vlen, width, fill, align);
        } else {
            out[pos++] = tmpl[i];
        }
    }
    out[pos] = 0;
    char* result = nova_fat_str_create(out, (size_t)pos);
    return result ? (int64_t)(uintptr_t)result : 0;
}

int64_t nova_rt_center(int64_t s_handle, int64_t width, int64_t fill_char) {
    const char* s = (const char*)(uintptr_t)s_handle;
    if (!s) s = "";
    size_t slen = strlen(s);
    int64_t w = width;
    if (w < 0) w = 0;
    if ((int64_t)slen >= w) {
        char* r = (char*)nova_heap_alloc(slen + 1, NOVA_MEM_RAW);
        if (!r) return s_handle;
        memcpy(r, s, slen + 1);
        return (int64_t)(uintptr_t)r;
    }
    char fc = fill_char ? (char)(fill_char & 0xFF) : ' ';
    char* result = (char*)nova_heap_alloc((size_t)w + 1, NOVA_MEM_RAW);
    if (!result) return s_handle;
    size_t pad = (size_t)(w - (int64_t)slen);
    size_t lpad = pad / 2;
    size_t rpad = pad - lpad;
    memset(result, fc, lpad);
    memcpy(result + lpad, s, slen);
    memset(result + lpad + slen, fc, rpad);
    result[w] = '\0';
    return (int64_t)(uintptr_t)result;
}

int64_t nova_rt_hex(int64_t val) {
    char buf[32];
    int len = snprintf(buf, sizeof(buf), "%llx", (long long)val);
    char* r = nova_fat_str_create(buf, (size_t)len);
    return r ? (int64_t)(uintptr_t)r : 0;
}

int64_t nova_rt_oct(int64_t val) {
    char buf[32];
    int len = snprintf(buf, sizeof(buf), "%llo", (long long)val);
    char* r = nova_fat_str_create(buf, (size_t)len);
    return r ? (int64_t)(uintptr_t)r : 0;
}

int64_t nova_rt_bin(int64_t val) {
    char buf[68];
    if (val == 0) {
        char* r = nova_fat_str_create("0", 1);
        return r ? (int64_t)(uintptr_t)r : 0;
    }
    int bpos = 0;
    int64_t v = val < 0 ? -val : val;
    char tmp[66];
    int ti = 0;
    while (v > 0) { tmp[ti++] = '0' + (int)(v & 1); v >>= 1; }
    if (val < 0) buf[bpos++] = '-';
    for (int j = ti - 1; j >= 0; j--) buf[bpos++] = tmp[j];
    buf[bpos] = 0;
    char* r = nova_fat_str_create(buf, (size_t)bpos);
    return r ? (int64_t)(uintptr_t)r : 0;
}

/* ── Lazy Iterator Protocol ────────────────────────────────────────────────
 *
 * An iterator is a heap-allocated record (int64_t[]) tagged NOVA_MEM_ITER:
 *   rec[0] = next function pointer (nova_fn1: (self, dummy) -> Option)
 *   rec[1..N] = state (varies by iterator kind)
 *
 * Calling iter_next(it) invokes rec[0](it, 0) and returns some(val) or none().
 * Transform iterators (map, filter, take, ...) wrap a source iterator and
 * return a new iterator — no intermediate lists are created.
 * Terminal operations (collect, reduce, sum, ...) consume the iterator.
 * ──────────────────────────────────────────────────────────────────────── */

static int64_t* nova_iter_alloc(int count) {
    int64_t* rec = (int64_t*)nova_heap_alloc((size_t)count * sizeof(int64_t), NOVA_MEM_ITER);
    if (!rec) { fprintf(stderr, "nova: OOM allocating iterator\n"); exit(1); }
    return rec;
}

/* ── Source: array ─────────────────────────────────────────────────────── */
/* rec: [next_fn, list_handle, index, length] */

static int64_t nova_iter_array_next(int64_t self, int64_t dummy) {
    int64_t* rec = (int64_t*)(uintptr_t)self;
    int64_t idx = rec[2];
    int64_t len = rec[3];
    if (idx >= len) return nova_rt_none();
    rec[2] = idx + 1;
    NovaList* l = (NovaList*)(uintptr_t)rec[1];
    return nova_rt_some(l->data[idx]);
}

int64_t nova_rt_iter(int64_t list_handle) {
    NovaList* l = (NovaList*)(uintptr_t)list_handle;
    int64_t len = l ? l->size : 0;
    int64_t* rec = nova_iter_alloc(4);
    rec[0] = (int64_t)(uintptr_t)nova_iter_array_next;
    rec[1] = list_handle;
    rec[2] = 0;
    rec[3] = len;
    return (int64_t)(uintptr_t)rec;
}

/* ── Source: range ─────────────────────────────────────────────────────── */
/* rec: [next_fn, current, end, step] */

static int64_t nova_iter_range_next(int64_t self, int64_t dummy) {
    int64_t* rec = (int64_t*)(uintptr_t)self;
    int64_t cur  = rec[1];
    int64_t end  = rec[2];
    int64_t step = rec[3];
    if (step > 0 && cur >= end) return nova_rt_none();
    if (step < 0 && cur <= end) return nova_rt_none();
    if (step == 0) return nova_rt_none();
    rec[1] = cur + step;
    return nova_rt_some(cur);
}

int64_t nova_rt_iter_range(int64_t start, int64_t end) {
    int64_t* rec = nova_iter_alloc(4);
    rec[0] = (int64_t)(uintptr_t)nova_iter_range_next;
    rec[1] = start;
    rec[2] = end;
    rec[3] = 1;
    return (int64_t)(uintptr_t)rec;
}

int64_t nova_rt_iter_range_step(int64_t start, int64_t end, int64_t step) {
    int64_t* rec = nova_iter_alloc(4);
    rec[0] = (int64_t)(uintptr_t)nova_iter_range_next;
    rec[1] = start;
    rec[2] = end;
    rec[3] = step;
    return (int64_t)(uintptr_t)rec;
}

/* ── Transform: map ───────────────────────────────────────────────────── */
/* rec: [next_fn, source_iter, transform_closure] */

static int64_t nova_iter_map_next(int64_t self, int64_t dummy) {
    int64_t* rec = (int64_t*)(uintptr_t)self;
    int64_t src = rec[1];
    int64_t* src_rec = (int64_t*)(uintptr_t)src;
    nova_fn1 src_next = (nova_fn1)(uintptr_t)src_rec[0];
    int64_t opt = src_next(src, 0);
    if (nova_rt_is_none(opt)) return opt;
    int64_t val = nova_rt_unwrap(opt);
    int64_t* tf_rec = (int64_t*)(uintptr_t)rec[2];
    nova_fn1 tf_fn = (nova_fn1)(uintptr_t)tf_rec[0];
    return nova_rt_some(tf_fn(rec[2], val));
}

int64_t nova_rt_iter_map(int64_t iter, int64_t closure) {
    int64_t* rec = nova_iter_alloc(3);
    rec[0] = (int64_t)(uintptr_t)nova_iter_map_next;
    rec[1] = iter;
    rec[2] = closure;
    return (int64_t)(uintptr_t)rec;
}

/* ── Transform: filter ────────────────────────────────────────────────── */
/* rec: [next_fn, source_iter, predicate_closure] */

static int64_t nova_iter_filter_next(int64_t self, int64_t dummy) {
    int64_t* rec = (int64_t*)(uintptr_t)self;
    int64_t src = rec[1];
    int64_t* src_rec = (int64_t*)(uintptr_t)src;
    nova_fn1 src_next = (nova_fn1)(uintptr_t)src_rec[0];
    int64_t* pred_rec = (int64_t*)(uintptr_t)rec[2];
    nova_fn1 pred_fn = (nova_fn1)(uintptr_t)pred_rec[0];
    for (;;) {
        int64_t opt = src_next(src, 0);
        if (nova_rt_is_none(opt)) return opt;
        int64_t val = nova_rt_unwrap(opt);
        if (pred_fn(rec[2], val)) return nova_rt_some(val);
    }
}

int64_t nova_rt_iter_filter(int64_t iter, int64_t closure) {
    int64_t* rec = nova_iter_alloc(3);
    rec[0] = (int64_t)(uintptr_t)nova_iter_filter_next;
    rec[1] = iter;
    rec[2] = closure;
    return (int64_t)(uintptr_t)rec;
}

/* ── Transform: take ──────────────────────────────────────────────────── */
/* rec: [next_fn, source_iter, remaining] */

static int64_t nova_iter_take_next(int64_t self, int64_t dummy) {
    int64_t* rec = (int64_t*)(uintptr_t)self;
    if (rec[2] <= 0) return nova_rt_none();
    rec[2]--;
    int64_t* src_rec = (int64_t*)(uintptr_t)rec[1];
    nova_fn1 src_next = (nova_fn1)(uintptr_t)src_rec[0];
    return src_next(rec[1], 0);
}

int64_t nova_rt_iter_take(int64_t iter, int64_t n) {
    int64_t* rec = nova_iter_alloc(3);
    rec[0] = (int64_t)(uintptr_t)nova_iter_take_next;
    rec[1] = iter;
    rec[2] = n;
    return (int64_t)(uintptr_t)rec;
}

/* ── Transform: skip ──────────────────────────────────────────────────── */
/* rec: [next_fn, source_iter, remaining_to_skip] */

static int64_t nova_iter_skip_next(int64_t self, int64_t dummy) {
    int64_t* rec = (int64_t*)(uintptr_t)self;
    int64_t src = rec[1];
    int64_t* src_rec = (int64_t*)(uintptr_t)src;
    nova_fn1 src_next = (nova_fn1)(uintptr_t)src_rec[0];
    while (rec[2] > 0) {
        int64_t opt = src_next(src, 0);
        if (nova_rt_is_none(opt)) return opt;
        rec[2]--;
    }
    return src_next(src, 0);
}

int64_t nova_rt_iter_skip(int64_t iter, int64_t n) {
    int64_t* rec = nova_iter_alloc(3);
    rec[0] = (int64_t)(uintptr_t)nova_iter_skip_next;
    rec[1] = iter;
    rec[2] = n;
    return (int64_t)(uintptr_t)rec;
}

/* ── Transform: zip ───────────────────────────────────────────────────── */
/* rec: [next_fn, iter1, iter2]  — yields [a, b] pairs as 2-element lists */

static int64_t nova_iter_zip_next(int64_t self, int64_t dummy) {
    int64_t* rec = (int64_t*)(uintptr_t)self;
    int64_t* r1 = (int64_t*)(uintptr_t)rec[1];
    int64_t* r2 = (int64_t*)(uintptr_t)rec[2];
    nova_fn1 n1 = (nova_fn1)(uintptr_t)r1[0];
    nova_fn1 n2 = (nova_fn1)(uintptr_t)r2[0];
    int64_t o1 = n1(rec[1], 0);
    if (nova_rt_is_none(o1)) return o1;
    int64_t o2 = n2(rec[2], 0);
    if (nova_rt_is_none(o2)) return o2;
    int64_t pair = nova_rt_list_create();
    nova_rt_list_append(pair, nova_rt_unwrap(o1));
    nova_rt_list_append(pair, nova_rt_unwrap(o2));
    return nova_rt_some(pair);
}

int64_t nova_rt_iter_zip(int64_t iter1, int64_t iter2) {
    int64_t* rec = nova_iter_alloc(3);
    rec[0] = (int64_t)(uintptr_t)nova_iter_zip_next;
    rec[1] = iter1;
    rec[2] = iter2;
    return (int64_t)(uintptr_t)rec;
}

/* ── Transform: chain ─────────────────────────────────────────────────── */
/* rec: [next_fn, iter1, iter2, phase]  — phase 0=first, 1=second */

static int64_t nova_iter_chain_next(int64_t self, int64_t dummy) {
    int64_t* rec = (int64_t*)(uintptr_t)self;
    if (rec[3] == 0) {
        int64_t* r1 = (int64_t*)(uintptr_t)rec[1];
        nova_fn1 n1 = (nova_fn1)(uintptr_t)r1[0];
        int64_t opt = n1(rec[1], 0);
        if (!nova_rt_is_none(opt)) return opt;
        rec[3] = 1;
    }
    int64_t* r2 = (int64_t*)(uintptr_t)rec[2];
    nova_fn1 n2 = (nova_fn1)(uintptr_t)r2[0];
    return n2(rec[2], 0);
}

int64_t nova_rt_iter_chain(int64_t iter1, int64_t iter2) {
    int64_t* rec = nova_iter_alloc(4);
    rec[0] = (int64_t)(uintptr_t)nova_iter_chain_next;
    rec[1] = iter1;
    rec[2] = iter2;
    rec[3] = 0;
    return (int64_t)(uintptr_t)rec;
}

/* ── Transform: enumerate ─────────────────────────────────────────────── */
/* rec: [next_fn, source_iter, counter]  — yields [index, value] pairs */

static int64_t nova_iter_enumerate_next(int64_t self, int64_t dummy) {
    int64_t* rec = (int64_t*)(uintptr_t)self;
    int64_t src = rec[1];
    int64_t* src_rec = (int64_t*)(uintptr_t)src;
    nova_fn1 src_next = (nova_fn1)(uintptr_t)src_rec[0];
    int64_t opt = src_next(src, 0);
    if (nova_rt_is_none(opt)) return opt;
    int64_t idx = rec[2];
    rec[2] = idx + 1;
    int64_t pair = nova_rt_list_create();
    nova_rt_list_append(pair, idx);
    nova_rt_list_append(pair, nova_rt_unwrap(opt));
    return nova_rt_some(pair);
}

int64_t nova_rt_iter_enumerate(int64_t iter) {
    int64_t* rec = nova_iter_alloc(3);
    rec[0] = (int64_t)(uintptr_t)nova_iter_enumerate_next;
    rec[1] = iter;
    rec[2] = 0;
    return (int64_t)(uintptr_t)rec;
}

/* ── Transform: flat_map ──────────────────────────────────────────────── */
/* rec: [next_fn, source_iter, transform_closure, current_inner_iter]
 * transform returns an iterator; we flatten all inner iterators */

static int64_t nova_iter_flat_map_next(int64_t self, int64_t dummy) {
    int64_t* rec = (int64_t*)(uintptr_t)self;
    for (;;) {
        if (rec[3] != 0) {
            int64_t* inner_rec = (int64_t*)(uintptr_t)rec[3];
            nova_fn1 inner_next = (nova_fn1)(uintptr_t)inner_rec[0];
            int64_t opt = inner_next(rec[3], 0);
            if (!nova_rt_is_none(opt)) return opt;
            rec[3] = 0;
        }
        int64_t src = rec[1];
        int64_t* src_rec = (int64_t*)(uintptr_t)src;
        nova_fn1 src_next = (nova_fn1)(uintptr_t)src_rec[0];
        int64_t outer_opt = src_next(src, 0);
        if (nova_rt_is_none(outer_opt)) return outer_opt;
        int64_t* tf_rec = (int64_t*)(uintptr_t)rec[2];
        nova_fn1 tf_fn = (nova_fn1)(uintptr_t)tf_rec[0];
        rec[3] = tf_fn(rec[2], nova_rt_unwrap(outer_opt));
    }
}

int64_t nova_rt_iter_flat_map(int64_t iter, int64_t closure) {
    int64_t* rec = nova_iter_alloc(4);
    rec[0] = (int64_t)(uintptr_t)nova_iter_flat_map_next;
    rec[1] = iter;
    rec[2] = closure;
    rec[3] = 0;
    return (int64_t)(uintptr_t)rec;
}

/* ── Terminal: next ───────────────────────────────────────────────────── */

int64_t nova_rt_iter_next(int64_t iter) {
    if (!iter) return nova_rt_none();
    int64_t* rec = (int64_t*)(uintptr_t)iter;
    nova_fn1 next_fn = (nova_fn1)(uintptr_t)rec[0];
    return next_fn(iter, 0);
}

/* ── Terminal: collect ────────────────────────────────────────────────── */

int64_t nova_rt_iter_collect(int64_t iter) {
    int64_t list = nova_rt_list_create();
    if (!iter) return list;
    int64_t* rec = (int64_t*)(uintptr_t)iter;
    nova_fn1 next_fn = (nova_fn1)(uintptr_t)rec[0];
    for (;;) {
        int64_t opt = next_fn(iter, 0);
        if (nova_rt_is_none(opt)) break;
        nova_rt_list_append(list, nova_rt_unwrap(opt));
    }
    return list;
}

/* ── Terminal: reduce ─────────────────────────────────────────────────── */

int64_t nova_rt_iter_reduce(int64_t iter, int64_t init, int64_t closure) {
    int64_t acc = init;
    if (!iter) return acc;
    int64_t* rec = (int64_t*)(uintptr_t)iter;
    nova_fn1 next_fn = (nova_fn1)(uintptr_t)rec[0];
    int64_t* cf = (int64_t*)(uintptr_t)closure;
    nova_fn2 fn = (nova_fn2)(uintptr_t)cf[0];
    for (;;) {
        int64_t opt = next_fn(iter, 0);
        if (nova_rt_is_none(opt)) break;
        acc = fn(closure, acc, nova_rt_unwrap(opt));
    }
    return acc;
}

/* ── Terminal: for_each ───────────────────────────────────────────────── */

int64_t nova_rt_iter_for_each(int64_t iter, int64_t closure) {
    if (!iter) return 0;
    int64_t* rec = (int64_t*)(uintptr_t)iter;
    nova_fn1 next_fn = (nova_fn1)(uintptr_t)rec[0];
    int64_t* cf = (int64_t*)(uintptr_t)closure;
    nova_fn1 fn = (nova_fn1)(uintptr_t)cf[0];
    for (;;) {
        int64_t opt = next_fn(iter, 0);
        if (nova_rt_is_none(opt)) break;
        fn(closure, nova_rt_unwrap(opt));
    }
    return 0;
}

/* ── Terminal: count ──────────────────────────────────────────────────── */

int64_t nova_rt_iter_count(int64_t iter) {
    if (!iter) return 0;
    int64_t* rec = (int64_t*)(uintptr_t)iter;
    nova_fn1 next_fn = (nova_fn1)(uintptr_t)rec[0];
    int64_t n = 0;
    for (;;) {
        int64_t opt = next_fn(iter, 0);
        if (nova_rt_is_none(opt)) break;
        n++;
    }
    return n;
}

/* ── Terminal: sum ────────────────────────────────────────────────────── */

int64_t nova_rt_iter_sum(int64_t iter) {
    if (!iter) return 0;
    int64_t* rec = (int64_t*)(uintptr_t)iter;
    nova_fn1 next_fn = (nova_fn1)(uintptr_t)rec[0];
    int64_t acc = 0;
    for (;;) {
        int64_t opt = next_fn(iter, 0);
        if (nova_rt_is_none(opt)) break;
        acc += nova_rt_unwrap(opt);
    }
    return acc;
}

/* ── Terminal: any ────────────────────────────────────────────────────── */

int64_t nova_rt_iter_any(int64_t iter, int64_t closure) {
    if (!iter) return 0;
    int64_t* rec = (int64_t*)(uintptr_t)iter;
    nova_fn1 next_fn = (nova_fn1)(uintptr_t)rec[0];
    int64_t* cf = (int64_t*)(uintptr_t)closure;
    nova_fn1 fn = (nova_fn1)(uintptr_t)cf[0];
    for (;;) {
        int64_t opt = next_fn(iter, 0);
        if (nova_rt_is_none(opt)) return 0;
        if (fn(closure, nova_rt_unwrap(opt))) return 1;
    }
}

/* ── Terminal: all ────────────────────────────────────────────────────── */

int64_t nova_rt_iter_all(int64_t iter, int64_t closure) {
    if (!iter) return 1;
    int64_t* rec = (int64_t*)(uintptr_t)iter;
    nova_fn1 next_fn = (nova_fn1)(uintptr_t)rec[0];
    int64_t* cf = (int64_t*)(uintptr_t)closure;
    nova_fn1 fn = (nova_fn1)(uintptr_t)cf[0];
    for (;;) {
        int64_t opt = next_fn(iter, 0);
        if (nova_rt_is_none(opt)) return 1;
        if (!fn(closure, nova_rt_unwrap(opt))) return 0;
    }
}

/* ── Terminal: find ───────────────────────────────────────────────────── */

int64_t nova_rt_iter_find(int64_t iter, int64_t closure) {
    if (!iter) return nova_rt_none();
    int64_t* rec = (int64_t*)(uintptr_t)iter;
    nova_fn1 next_fn = (nova_fn1)(uintptr_t)rec[0];
    int64_t* cf = (int64_t*)(uintptr_t)closure;
    nova_fn1 fn = (nova_fn1)(uintptr_t)cf[0];
    for (;;) {
        int64_t opt = next_fn(iter, 0);
        if (nova_rt_is_none(opt)) return opt;
        int64_t val = nova_rt_unwrap(opt);
        if (fn(closure, val)) return nova_rt_some(val);
    }
}

/* ── Async/Await (Future-based thread pool scheduling) ─────────────────────
 *
 * async(closure)      — submit closure to thread pool, returns future handle
 * await(future)       — block until done, return result
 * await_all(futures)  — block until all done, return list of results
 * await_any(futures)  — block until first done, return [index, result]
 * ──────────────────────────────────────────────────────────────────────── */

static NovaFuture* nova_future_create(void) {
    NovaFuture* f = (NovaFuture*)calloc(1, sizeof(NovaFuture));
    if (!f) { fprintf(stderr, "nova: OOM allocating future\n"); exit(1); }
    f->result = 0;
    f->completed = 0;
#ifdef _WIN32
    InitializeCriticalSection(&f->lock);
    InitializeConditionVariable(&f->cv);
#else
    pthread_mutex_init(&f->lock, NULL);
    pthread_cond_init(&f->cv, NULL);
#endif
    return f;
}

int64_t nova_rt_async(int64_t closure) {
    if (!nova_pool) nova_pool_init();
    NovaThreadPool* pool = nova_pool;
    NovaFuture* f = nova_future_create();

#ifdef _WIN32
    EnterCriticalSection(&pool->lock);
    while (pool->size >= NOVA_POOL_QUEUE_CAP)
        SleepConditionVariableCS(&pool->not_full, &pool->lock, INFINITE);
    pool->queue[pool->tail].proc = NULL;
    pool->queue[pool->tail].future = f;
    pool->queue[pool->tail].closure = closure;
    pool->tail = (pool->tail + 1) % NOVA_POOL_QUEUE_CAP;
    pool->size++;
    pool->tasks_submitted++;
    WakeConditionVariable(&pool->not_empty);
    LeaveCriticalSection(&pool->lock);
#else
    pthread_mutex_lock(&pool->lock);
    while (pool->size >= NOVA_POOL_QUEUE_CAP)
        pthread_cond_wait(&pool->not_full, &pool->lock);
    pool->queue[pool->tail].proc = NULL;
    pool->queue[pool->tail].future = f;
    pool->queue[pool->tail].closure = closure;
    pool->tail = (pool->tail + 1) % NOVA_POOL_QUEUE_CAP;
    pool->size++;
    pool->tasks_submitted++;
    pthread_cond_signal(&pool->not_empty);
    pthread_mutex_unlock(&pool->lock);
#endif

    return (int64_t)(uintptr_t)f;
}

int64_t nova_rt_await(int64_t handle) {
    NovaFuture* f = (NovaFuture*)(uintptr_t)handle;
    if (!f) return 0;
#ifdef _WIN32
    EnterCriticalSection(&f->lock);
    while (!f->completed)
        SleepConditionVariableCS(&f->cv, &f->lock, INFINITE);
    int64_t result = f->result;
    LeaveCriticalSection(&f->lock);
#else
    pthread_mutex_lock(&f->lock);
    while (!f->completed)
        pthread_cond_wait(&f->cv, &f->lock);
    int64_t result = f->result;
    pthread_mutex_unlock(&f->lock);
#endif
    return result;
}

int64_t nova_rt_await_all(int64_t list_handle) {
    NovaList* list = (NovaList*)(uintptr_t)list_handle;
    int64_t results = nova_rt_list_create();
    if (!list) return results;
    for (int64_t i = 0; i < list->size; i++) {
        int64_t r = nova_rt_await(list->data[i]);
        nova_rt_list_append(results, r);
    }
    return results;
}

int64_t nova_rt_await_any(int64_t list_handle) {
    NovaList* list = (NovaList*)(uintptr_t)list_handle;
    if (!list || list->size == 0) return nova_rt_none();
    for (;;) {
        for (int64_t i = 0; i < list->size; i++) {
            NovaFuture* f = (NovaFuture*)(uintptr_t)list->data[i];
            if (f->completed) {
                int64_t pair = nova_rt_list_create();
                nova_rt_list_append(pair, i);
                nova_rt_list_append(pair, f->result);
                return pair;
            }
        }
#ifdef _WIN32
        NovaFuture* first = (NovaFuture*)(uintptr_t)list->data[0];
        EnterCriticalSection(&first->lock);
        if (!first->completed)
            SleepConditionVariableCS(&first->cv, &first->lock, 1);
        LeaveCriticalSection(&first->lock);
#else
        struct timespec ts;
        clock_gettime(CLOCK_REALTIME, &ts);
        ts.tv_nsec += 1000000;
        if (ts.tv_nsec >= 1000000000) { ts.tv_sec++; ts.tv_nsec -= 1000000000; }
        NovaFuture* first = (NovaFuture*)(uintptr_t)list->data[0];
        pthread_mutex_lock(&first->lock);
        if (!first->completed)
            pthread_cond_timedwait(&first->cv, &first->lock, &ts);
        pthread_mutex_unlock(&first->lock);
#endif
    }
}

/* ── Test Framework ────────────────────────────────────────────────────────
 *
 * assert_eq / assert_ne / assert_true / assert_false — track pass/fail
 * test_run(name, closure) — runs a test, reports result
 * test_summary() — prints totals, returns 0 if all pass, 1 if any fail
 * ──────────────────────────────────────────────────────────────────────── */

static int64_t nova_test_pass = 0;
static int64_t nova_test_fail = 0;

static void nova_test_print_val(int64_t val) {
    int64_t s = nova_rt_any_to_str(val);
    const char* str = (const char*)(uintptr_t)s;
    if (str) fprintf(stderr, "%s", str);
    else fprintf(stderr, "%lld", (long long)val);
}

int64_t nova_rt_assert_eq(int64_t actual, int64_t expected) {
    if (nova_rt_eq(actual, expected)) {
        nova_test_pass++;
        return 1;
    }
    nova_test_fail++;
    fprintf(stderr, "  FAIL assert_eq: expected ");
    nova_test_print_val(expected);
    fprintf(stderr, " but got ");
    nova_test_print_val(actual);
    fprintf(stderr, "\n");
    return 0;
}

int64_t nova_rt_assert_ne(int64_t actual, int64_t expected) {
    if (!nova_rt_eq(actual, expected)) {
        nova_test_pass++;
        return 1;
    }
    nova_test_fail++;
    fprintf(stderr, "  FAIL assert_ne: values should differ but both are ");
    nova_test_print_val(actual);
    fprintf(stderr, "\n");
    return 0;
}

int64_t nova_rt_assert_true(int64_t val) {
    if (val) {
        nova_test_pass++;
        return 1;
    }
    nova_test_fail++;
    fprintf(stderr, "  FAIL assert_true: got falsy value\n");
    return 0;
}

int64_t nova_rt_assert_false(int64_t val) {
    if (!val) {
        nova_test_pass++;
        return 1;
    }
    nova_test_fail++;
    fprintf(stderr, "  FAIL assert_false: got truthy value %lld\n", (long long)val);
    return 0;
}

int64_t nova_rt_assert_near(int64_t actual_bits, int64_t expected_bits, int64_t eps_bits) {
    double a, e, eps;
    memcpy(&a, &actual_bits, sizeof(double));
    memcpy(&e, &expected_bits, sizeof(double));
    memcpy(&eps, &eps_bits, sizeof(double));
    if (fabs(a - e) <= eps) {
        nova_test_pass++;
        return 1;
    }
    nova_test_fail++;
    fprintf(stderr, "  FAIL assert_near: expected %.15g ± %.15g but got %.15g (diff=%.15g)\n",
            e, eps, a, fabs(a - e));
    return 0;
}

int64_t nova_rt_test_run(int64_t name, int64_t closure) {
    const char* n = (const char*)(uintptr_t)name;
    if (!n) n = "<unnamed>";
    int64_t before_fail = nova_test_fail;
    int64_t before_pass = nova_test_pass;

    int64_t* rec = (int64_t*)(uintptr_t)closure;
    nova_fn1 fn = (nova_fn1)(uintptr_t)rec[0];
    fn(closure, 0);

    int64_t new_fails = nova_test_fail - before_fail;
    int64_t new_pass  = nova_test_pass - before_pass;
    if (new_fails > 0) {
        fprintf(stderr, "FAIL %s (%lld passed, %lld failed)\n",
                n, (long long)new_pass, (long long)new_fails);
        return 0;
    }
    printf("  ok %s (%lld assertions)\n", n, (long long)new_pass);
    return 1;
}

int64_t nova_rt_test_summary(void) {
    int64_t total = nova_test_pass + nova_test_fail;
    if (nova_test_fail == 0) {
        printf("\nAll tests passed: %lld assertions in total\n", (long long)total);
    } else {
        fprintf(stderr, "\nTest results: %lld passed, %lld FAILED, %lld total\n",
                (long long)nova_test_pass, (long long)nova_test_fail, (long long)total);
    }
    return nova_test_fail == 0 ? 0 : 1;
}

int64_t nova_rt_test_reset(void) {
    nova_test_pass = 0;
    nova_test_fail = 0;
    return 0;
}

/* ── Date/Time Library ─────────────────────────────────────────────────── */

int64_t nova_rt_datetime_now(void) {
    time_t t = time(NULL);
    struct tm* tm = localtime(&t);
    if (!tm) return (int64_t)(uintptr_t)"1970-01-01T00:00:00";
    char buf[32];
    int len = snprintf(buf, sizeof(buf), "%04d-%02d-%02dT%02d:%02d:%02d",
                       tm->tm_year + 1900, tm->tm_mon + 1, tm->tm_mday,
                       tm->tm_hour, tm->tm_min, tm->tm_sec);
    char* r = nova_fat_str_create(buf, (size_t)len);
    return r ? (int64_t)(uintptr_t)r : 0;
}

int64_t nova_rt_datetime_timestamp(void) {
    return (int64_t)time(NULL);
}

int64_t nova_rt_datetime_year(int64_t ts) {
    time_t t = (time_t)ts;
    struct tm* tm = localtime(&t);
    return tm ? (int64_t)(tm->tm_year + 1900) : 0;
}

int64_t nova_rt_datetime_month(int64_t ts) {
    time_t t = (time_t)ts;
    struct tm* tm = localtime(&t);
    return tm ? (int64_t)(tm->tm_mon + 1) : 0;
}

int64_t nova_rt_datetime_day(int64_t ts) {
    time_t t = (time_t)ts;
    struct tm* tm = localtime(&t);
    return tm ? (int64_t)tm->tm_mday : 0;
}

int64_t nova_rt_datetime_hour(int64_t ts) {
    time_t t = (time_t)ts;
    struct tm* tm = localtime(&t);
    return tm ? (int64_t)tm->tm_hour : 0;
}

int64_t nova_rt_datetime_minute(int64_t ts) {
    time_t t = (time_t)ts;
    struct tm* tm = localtime(&t);
    return tm ? (int64_t)tm->tm_min : 0;
}

int64_t nova_rt_datetime_second(int64_t ts) {
    time_t t = (time_t)ts;
    struct tm* tm = localtime(&t);
    return tm ? (int64_t)tm->tm_sec : 0;
}

int64_t nova_rt_datetime_weekday(int64_t ts) {
    time_t t = (time_t)ts;
    struct tm* tm = localtime(&t);
    return tm ? (int64_t)tm->tm_wday : 0;
}

int64_t nova_rt_datetime_format(int64_t ts, int64_t fmt_str) {
    time_t t = (time_t)ts;
    struct tm* tm = localtime(&t);
    if (!tm) return (int64_t)(uintptr_t)"";
    const char* fmt = (const char*)(uintptr_t)fmt_str;
    if (!fmt || *fmt == '\0') fmt = "%Y-%m-%d %H:%M:%S";
    char buf[256];
    size_t len = strftime(buf, sizeof(buf), fmt, tm);
    if (len == 0) return (int64_t)(uintptr_t)"";
    char* r = nova_fat_str_create(buf, len);
    return r ? (int64_t)(uintptr_t)r : 0;
}

int64_t nova_rt_datetime_parse(int64_t str_val, int64_t fmt_str) {
    const char* s = (const char*)(uintptr_t)str_val;
    const char* fmt = (const char*)(uintptr_t)fmt_str;
    if (!s || !fmt) return 0;
    struct tm tm;
    memset(&tm, 0, sizeof(tm));
    tm.tm_isdst = -1;
    int y = 0, mo = 0, d = 0, h = 0, mi = 0, se = 0;
    if (sscanf(s, "%d-%d-%d %d:%d:%d", &y, &mo, &d, &h, &mi, &se) >= 3 ||
        sscanf(s, "%d-%d-%dT%d:%d:%d", &y, &mo, &d, &h, &mi, &se) >= 3) {
        tm.tm_year = y - 1900;
        tm.tm_mon = mo - 1;
        tm.tm_mday = d;
        tm.tm_hour = h;
        tm.tm_min = mi;
        tm.tm_sec = se;
        return (int64_t)mktime(&tm);
    }
    return 0;
}

int64_t nova_rt_datetime_diff(int64_t ts1, int64_t ts2) {
    return ts1 - ts2;
}

int64_t nova_rt_datetime_add_days(int64_t ts, int64_t n) {
    return ts + n * 86400;
}

int64_t nova_rt_datetime_add_hours(int64_t ts, int64_t n) {
    return ts + n * 3600;
}

/* ── SHA-256 (FIPS 180-4, pure C, no external deps) ──────────────────────── */

static const uint32_t sha256_k[64] = {
    0x428a2f98,0x71374491,0xb5c0fbcf,0xe9b5dba5,0x3956c25b,0x59f111f1,0x923f82a4,0xab1c5ed5,
    0xd807aa98,0x12835b01,0x243185be,0x550c7dc3,0x72be5d74,0x80deb1fe,0x9bdc06a7,0xc19bf174,
    0xe49b69c1,0xefbe4786,0x0fc19dc6,0x240ca1cc,0x2de92c6f,0x4a7484aa,0x5cb0a9dc,0x76f988da,
    0x983e5152,0xa831c66d,0xb00327c8,0xbf597fc7,0xc6e00bf3,0xd5a79147,0x06ca6351,0x14292967,
    0x27b70a85,0x2e1b2138,0x4d2c6dfc,0x53380d13,0x650a7354,0x766a0abb,0x81c2c92e,0x92722c85,
    0xa2bfe8a1,0xa81a664b,0xc24b8b70,0xc76c51a3,0xd192e819,0xd6990624,0xf40e3585,0x106aa070,
    0x19a4c116,0x1e376c08,0x2748774c,0x34b0bcb5,0x391c0cb3,0x4ed8aa4a,0x5b9cca4f,0x682e6ff3,
    0x748f82ee,0x78a5636f,0x84c87814,0x8cc70208,0x90befffa,0xa4506ceb,0xbef9a3f7,0xc67178f2
};

static uint32_t sha256_rotr(uint32_t x, int n) { return (x >> n) | (x << (32 - n)); }
static uint32_t sha256_ch(uint32_t x, uint32_t y, uint32_t z) { return (x & y) ^ (~x & z); }
static uint32_t sha256_maj(uint32_t x, uint32_t y, uint32_t z) { return (x & y) ^ (x & z) ^ (y & z); }
static uint32_t sha256_ep0(uint32_t x) { return sha256_rotr(x,2) ^ sha256_rotr(x,13) ^ sha256_rotr(x,22); }
static uint32_t sha256_ep1(uint32_t x) { return sha256_rotr(x,6) ^ sha256_rotr(x,11) ^ sha256_rotr(x,25); }
static uint32_t sha256_sig0(uint32_t x) { return sha256_rotr(x,7) ^ sha256_rotr(x,18) ^ (x >> 3); }
static uint32_t sha256_sig1(uint32_t x) { return sha256_rotr(x,17) ^ sha256_rotr(x,19) ^ (x >> 10); }

typedef struct {
    uint32_t state[8];
    uint8_t  buf[64];
    uint64_t total;
    size_t   buflen;
} Sha256Ctx;

static void sha256_init(Sha256Ctx* ctx) {
    ctx->state[0] = 0x6a09e667; ctx->state[1] = 0xbb67ae85;
    ctx->state[2] = 0x3c6ef372; ctx->state[3] = 0xa54ff53a;
    ctx->state[4] = 0x510e527f; ctx->state[5] = 0x9b05688c;
    ctx->state[6] = 0x1f83d9ab; ctx->state[7] = 0x5be0cd19;
    ctx->total = 0;
    ctx->buflen = 0;
}

static void sha256_transform(Sha256Ctx* ctx, const uint8_t block[64]) {
    uint32_t w[64];
    for (int i = 0; i < 16; i++)
        w[i] = ((uint32_t)block[i*4]<<24) | ((uint32_t)block[i*4+1]<<16) |
                ((uint32_t)block[i*4+2]<<8) | (uint32_t)block[i*4+3];
    for (int i = 16; i < 64; i++)
        w[i] = sha256_sig1(w[i-2]) + w[i-7] + sha256_sig0(w[i-15]) + w[i-16];
    uint32_t a=ctx->state[0], b=ctx->state[1], c=ctx->state[2], d=ctx->state[3];
    uint32_t e=ctx->state[4], f=ctx->state[5], g=ctx->state[6], h=ctx->state[7];
    for (int i = 0; i < 64; i++) {
        uint32_t t1 = h + sha256_ep1(e) + sha256_ch(e,f,g) + sha256_k[i] + w[i];
        uint32_t t2 = sha256_ep0(a) + sha256_maj(a,b,c);
        h=g; g=f; f=e; e=d+t1; d=c; c=b; b=a; a=t1+t2;
    }
    ctx->state[0]+=a; ctx->state[1]+=b; ctx->state[2]+=c; ctx->state[3]+=d;
    ctx->state[4]+=e; ctx->state[5]+=f; ctx->state[6]+=g; ctx->state[7]+=h;
}

static void sha256_update(Sha256Ctx* ctx, const uint8_t* data, size_t len) {
    for (size_t i = 0; i < len; i++) {
        ctx->buf[ctx->buflen++] = data[i];
        if (ctx->buflen == 64) { sha256_transform(ctx, ctx->buf); ctx->buflen = 0; }
    }
    ctx->total += len;
}

static void sha256_final(Sha256Ctx* ctx, uint8_t hash[32]) {
    size_t i = ctx->buflen;
    ctx->buf[i++] = 0x80;
    if (i > 56) {
        while (i < 64) ctx->buf[i++] = 0;
        sha256_transform(ctx, ctx->buf);
        i = 0;
    }
    while (i < 56) ctx->buf[i++] = 0;
    uint64_t bits = ctx->total * 8;
    for (int j = 7; j >= 0; j--)
        ctx->buf[56 + (7-j)] = (uint8_t)(bits >> (j*8));
    sha256_transform(ctx, ctx->buf);
    for (int j = 0; j < 8; j++) {
        hash[j*4]   = (uint8_t)(ctx->state[j] >> 24);
        hash[j*4+1] = (uint8_t)(ctx->state[j] >> 16);
        hash[j*4+2] = (uint8_t)(ctx->state[j] >> 8);
        hash[j*4+3] = (uint8_t)(ctx->state[j]);
    }
}

int64_t nova_rt_sha256(int64_t input) {
    const char* s = (const char*)(uintptr_t)input;
    if (!s) s = "";
    Sha256Ctx ctx;
    sha256_init(&ctx);
    sha256_update(&ctx, (const uint8_t*)s, strlen(s));
    uint8_t hash[32];
    sha256_final(&ctx, hash);
    static const char hex_chars[] = "0123456789abcdef";
    char* out = (char*)malloc(65);
    if (!out) return (int64_t)(uintptr_t)"";
    for (int i = 0; i < 32; i++) {
        out[i*2]   = hex_chars[hash[i] >> 4];
        out[i*2+1] = hex_chars[hash[i] & 0x0f];
    }
    out[64] = '\0';
    return (int64_t)(uintptr_t)out;
}

int64_t nova_rt_sha256_bytes(int64_t data, int64_t len_val) {
    const uint8_t* ptr = (const uint8_t*)(uintptr_t)data;
    size_t len = (size_t)len_val;
    if (!ptr) { ptr = (const uint8_t*)""; len = 0; }
    Sha256Ctx ctx;
    sha256_init(&ctx);
    sha256_update(&ctx, ptr, len);
    uint8_t hash[32];
    sha256_final(&ctx, hash);
    static const char hex_chars[] = "0123456789abcdef";
    char* out = (char*)malloc(65);
    if (!out) return (int64_t)(uintptr_t)"";
    for (int i = 0; i < 32; i++) {
        out[i*2]   = hex_chars[hash[i] >> 4];
        out[i*2+1] = hex_chars[hash[i] & 0x0f];
    }
    out[64] = '\0';
    return (int64_t)(uintptr_t)out;
}

/* ── HMAC-SHA256 (RFC 2104) ──────────────────────────────────────────────── */

int64_t nova_rt_hmac_sha256(int64_t key_val, int64_t msg_val) {
    const char* key = (const char*)(uintptr_t)key_val;
    const char* msg = (const char*)(uintptr_t)msg_val;
    if (!key) key = "";
    if (!msg) msg = "";
    size_t key_len = strlen(key);
    size_t msg_len = strlen(msg);
    uint8_t k_pad[64];
    memset(k_pad, 0, 64);
    if (key_len > 64) {
        Sha256Ctx hk;
        sha256_init(&hk);
        sha256_update(&hk, (const uint8_t*)key, key_len);
        uint8_t kh[32];
        sha256_final(&hk, kh);
        memcpy(k_pad, kh, 32);
    } else {
        memcpy(k_pad, key, key_len);
    }
    uint8_t i_pad[64], o_pad[64];
    for (int i = 0; i < 64; i++) {
        i_pad[i] = k_pad[i] ^ 0x36;
        o_pad[i] = k_pad[i] ^ 0x5c;
    }
    Sha256Ctx inner;
    sha256_init(&inner);
    sha256_update(&inner, i_pad, 64);
    sha256_update(&inner, (const uint8_t*)msg, msg_len);
    uint8_t inner_hash[32];
    sha256_final(&inner, inner_hash);
    Sha256Ctx outer;
    sha256_init(&outer);
    sha256_update(&outer, o_pad, 64);
    sha256_update(&outer, inner_hash, 32);
    uint8_t final_hash[32];
    sha256_final(&outer, final_hash);
    static const char hex_chars[] = "0123456789abcdef";
    char* out = (char*)malloc(65);
    if (!out) return (int64_t)(uintptr_t)"";
    for (int i = 0; i < 32; i++) {
        out[i*2]   = hex_chars[final_hash[i] >> 4];
        out[i*2+1] = hex_chars[final_hash[i] & 0x0f];
    }
    out[64] = '\0';
    return (int64_t)(uintptr_t)out;
}

/* ── Hex encode/decode ────────────────────────────────────────────────────── */

int64_t nova_rt_hex_encode(int64_t input) {
    const char* s = (const char*)(uintptr_t)input;
    if (!s) return (int64_t)(uintptr_t)"";
    size_t len = strlen(s);
    char* out = (char*)malloc(len * 2 + 1);
    if (!out) return (int64_t)(uintptr_t)"";
    static const char hex_chars[] = "0123456789abcdef";
    for (size_t i = 0; i < len; i++) {
        out[i*2]   = hex_chars[(uint8_t)s[i] >> 4];
        out[i*2+1] = hex_chars[(uint8_t)s[i] & 0x0f];
    }
    out[len*2] = '\0';
    return (int64_t)(uintptr_t)out;
}

int64_t nova_rt_hex_decode(int64_t input) {
    const char* s = (const char*)(uintptr_t)input;
    if (!s) return (int64_t)(uintptr_t)"";
    size_t len = strlen(s);
    if (len % 2 != 0) {
        nova_set_error("hex_decode: odd-length input");
        return (int64_t)(uintptr_t)"";
    }
    size_t out_len = len / 2;
    char* out = (char*)malloc(out_len + 1);
    if (!out) return (int64_t)(uintptr_t)"";
    for (size_t i = 0; i < out_len; i++) {
        int hi = s[i*2], lo = s[i*2+1];
        int hv = (hi >= '0' && hi <= '9') ? hi-'0' : (hi >= 'a' && hi <= 'f') ? hi-'a'+10 : (hi >= 'A' && hi <= 'F') ? hi-'A'+10 : -1;
        int lv = (lo >= '0' && lo <= '9') ? lo-'0' : (lo >= 'a' && lo <= 'f') ? lo-'a'+10 : (lo >= 'A' && lo <= 'F') ? lo-'A'+10 : -1;
        if (hv < 0 || lv < 0) {
            nova_set_error("hex_decode: invalid hex character");
            free(out);
            return (int64_t)(uintptr_t)"";
        }
        out[i] = (char)((hv << 4) | lv);
    }
    out[out_len] = '\0';
    return (int64_t)(uintptr_t)out;
}

/* ── Base64 encode/decode (RFC 4648) ─────────────────────────────────────── */

static const char b64_enc[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

int64_t nova_rt_base64_encode(int64_t input) {
    const uint8_t* s = (const uint8_t*)(uintptr_t)input;
    if (!s) return (int64_t)(uintptr_t)"";
    size_t len = strlen((const char*)s);
    size_t out_len = 4 * ((len + 2) / 3);
    char* out = (char*)malloc(out_len + 1);
    if (!out) return (int64_t)(uintptr_t)"";
    size_t j = 0;
    for (size_t i = 0; i < len; i += 3) {
        uint32_t a = s[i];
        uint32_t b = (i+1 < len) ? s[i+1] : 0;
        uint32_t c = (i+2 < len) ? s[i+2] : 0;
        uint32_t triple = (a << 16) | (b << 8) | c;
        out[j++] = b64_enc[(triple >> 18) & 0x3f];
        out[j++] = b64_enc[(triple >> 12) & 0x3f];
        out[j++] = (i+1 < len) ? b64_enc[(triple >> 6) & 0x3f] : '=';
        out[j++] = (i+2 < len) ? b64_enc[triple & 0x3f] : '=';
    }
    out[j] = '\0';
    return (int64_t)(uintptr_t)out;
}

static int b64_decode_char(char c) {
    if (c >= 'A' && c <= 'Z') return c - 'A';
    if (c >= 'a' && c <= 'z') return c - 'a' + 26;
    if (c >= '0' && c <= '9') return c - '0' + 52;
    if (c == '+') return 62;
    if (c == '/') return 63;
    return -1;
}

int64_t nova_rt_base64_decode(int64_t input) {
    const char* s = (const char*)(uintptr_t)input;
    if (!s) return (int64_t)(uintptr_t)"";
    size_t len = strlen(s);
    while (len > 0 && s[len-1] == '=') len--;
    size_t out_len = (len * 3) / 4;
    char* out = (char*)malloc(out_len + 1);
    if (!out) return (int64_t)(uintptr_t)"";
    size_t j = 0;
    for (size_t i = 0; i < len; i += 4) {
        int a = b64_decode_char(s[i]);
        int b = (i+1 < len) ? b64_decode_char(s[i+1]) : 0;
        int c = (i+2 < len) ? b64_decode_char(s[i+2]) : 0;
        int d = (i+3 < len) ? b64_decode_char(s[i+3]) : 0;
        if (a < 0 || b < 0 || c < 0 || d < 0) {
            nova_set_error("base64_decode: invalid character");
            free(out);
            return (int64_t)(uintptr_t)"";
        }
        uint32_t triple = ((uint32_t)a << 18) | ((uint32_t)b << 12) | ((uint32_t)c << 6) | (uint32_t)d;
        if (j < out_len) out[j++] = (char)((triple >> 16) & 0xff);
        if (j < out_len) out[j++] = (char)((triple >> 8) & 0xff);
        if (j < out_len) out[j++] = (char)(triple & 0xff);
    }
    out[j] = '\0';
    return (int64_t)(uintptr_t)out;
}

/* ── UUID v4 (cryptographic random on Windows, /dev/urandom on Linux) ────── */

static void nova_secure_random_bytes(uint8_t* buf, size_t len) {
#ifdef _WIN32
    HCRYPTPROV hProv = 0;
    if (CryptAcquireContextW(&hProv, NULL, NULL, PROV_RSA_FULL, CRYPT_VERIFYCONTEXT)) {
        CryptGenRandom(hProv, (DWORD)len, buf);
        CryptReleaseContext(hProv, 0);
    } else {
        for (size_t i = 0; i < len; i++)
            buf[i] = (uint8_t)(rand() & 0xff);
    }
#else
    FILE* f = fopen("/dev/urandom", "rb");
    if (f) {
        size_t got = fread(buf, 1, len, f);
        fclose(f);
        if (got < len) {
            for (size_t i = got; i < len; i++)
                buf[i] = (uint8_t)(rand() & 0xff);
        }
    } else {
        for (size_t i = 0; i < len; i++)
            buf[i] = (uint8_t)(rand() & 0xff);
    }
#endif
}

int64_t nova_rt_uuid4(void) {
    uint8_t bytes[16];
    nova_secure_random_bytes(bytes, 16);
    bytes[6] = (bytes[6] & 0x0f) | 0x40;
    bytes[8] = (bytes[8] & 0x3f) | 0x80;
    char* out = (char*)malloc(37);
    if (!out) return (int64_t)(uintptr_t)"";
    static const char hx[] = "0123456789abcdef";
    int pos = 0;
    for (int i = 0; i < 16; i++) {
        if (i == 4 || i == 6 || i == 8 || i == 10) out[pos++] = '-';
        out[pos++] = hx[bytes[i] >> 4];
        out[pos++] = hx[bytes[i] & 0x0f];
    }
    out[pos] = '\0';
    return (int64_t)(uintptr_t)out;
}

int64_t nova_rt_random_bytes(int64_t n) {
    if (n <= 0 || n > 1048576) return (int64_t)(uintptr_t)"";
    char* buf = (char*)malloc((size_t)n + 1);
    if (!buf) return (int64_t)(uintptr_t)"";
    nova_secure_random_bytes((uint8_t*)buf, (size_t)n);
    buf[n] = '\0';
    return (int64_t)(uintptr_t)buf;
}

/* ── Recursive directory walk ────────────────────────────────────────────── */

int64_t nova_rt_dir_walk(int64_t path_val) {
    const char* path = (const char*)(uintptr_t)path_val;
    if (!path || !*path) return (int64_t)(uintptr_t)nova_rt_list_create();
    int64_t result = nova_rt_list_create();

#ifdef _WIN32
    char pattern[MAX_PATH + 4];
    size_t plen = strlen(path);
    if (plen >= MAX_PATH) return result;
    memcpy(pattern, path, plen);
    if (plen > 0 && path[plen-1] != '\\' && path[plen-1] != '/') {
        pattern[plen++] = '\\';
    }
    pattern[plen] = '*';
    pattern[plen+1] = '\0';

    WIN32_FIND_DATAA fd;
    HANDLE hFind = FindFirstFileA(pattern, &fd);
    if (hFind == INVALID_HANDLE_VALUE) return result;

    char stack_paths[256][MAX_PATH];
    int stack_top = 0;
    strncpy(stack_paths[0], path, MAX_PATH - 1);
    stack_paths[0][MAX_PATH - 1] = '\0';
    stack_top = 1;
    FindClose(hFind);

    while (stack_top > 0 && stack_top < 256) {
        stack_top--;
        char cur[MAX_PATH];
        strncpy(cur, stack_paths[stack_top], MAX_PATH - 1);
        cur[MAX_PATH - 1] = '\0';

        size_t clen = strlen(cur);
        char search[MAX_PATH + 4];
        if (clen >= MAX_PATH) continue;
        memcpy(search, cur, clen);
        if (clen > 0 && cur[clen-1] != '\\') { search[clen++] = '\\'; }
        search[clen] = '*';
        search[clen+1] = '\0';

        hFind = FindFirstFileA(search, &fd);
        if (hFind == INVALID_HANDLE_VALUE) continue;
        do {
            if (fd.cFileName[0] == '.' && (fd.cFileName[1] == '\0' ||
                (fd.cFileName[1] == '.' && fd.cFileName[2] == '\0'))) continue;
            char full[MAX_PATH * 2];
            snprintf(full, sizeof(full), "%s\\%s", cur, fd.cFileName);
            size_t flen = strlen(full);
            char* dup = (char*)malloc(flen + 1);
            if (dup) { memcpy(dup, full, flen + 1); nova_rt_list_append(result, (int64_t)(uintptr_t)dup); }
            if ((fd.dwFileAttributes & FILE_ATTRIBUTE_DIRECTORY) && stack_top < 255) {
                strncpy(stack_paths[stack_top], full, MAX_PATH - 1);
                stack_paths[stack_top][MAX_PATH - 1] = '\0';
                stack_top++;
            }
        } while (FindNextFileA(hFind, &fd));
        FindClose(hFind);
    }
#else
    char stack_paths[256][4096];
    int stack_top = 0;
    strncpy(stack_paths[0], path, 4095);
    stack_paths[0][4095] = '\0';
    stack_top = 1;

    while (stack_top > 0 && stack_top < 256) {
        stack_top--;
        DIR* d = opendir(stack_paths[stack_top]);
        if (!d) continue;
        char cur[4096];
        strncpy(cur, stack_paths[stack_top], 4095);
        cur[4095] = '\0';
        struct dirent* ent;
        while ((ent = readdir(d)) != NULL) {
            if (ent->d_name[0] == '.' && (ent->d_name[1] == '\0' ||
                (ent->d_name[1] == '.' && ent->d_name[2] == '\0'))) continue;
            char full[8192];
            snprintf(full, sizeof(full), "%s/%s", cur, ent->d_name);
            size_t flen = strlen(full);
            char* dup = (char*)malloc(flen + 1);
            if (dup) { memcpy(dup, full, flen + 1); nova_rt_list_append(result, (int64_t)(uintptr_t)dup); }
            struct stat st;
            if (stat(full, &st) == 0 && S_ISDIR(st.st_mode) && stack_top < 255) {
                strncpy(stack_paths[stack_top], full, 4095);
                stack_paths[stack_top][4095] = '\0';
                stack_top++;
            }
        }
        closedir(d);
    }
#endif
    return result;
}
