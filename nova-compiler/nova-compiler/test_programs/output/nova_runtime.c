#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <stdint.h>
#include <math.h>
#include <ctype.h>
#include <errno.h>

#ifdef _WIN32
#include <winsock2.h>
#include <ws2tcpip.h>
#include <windows.h>
#include <winhttp.h>
#pragma comment(lib, "winhttp.lib")
#pragma comment(lib, "ws2_32.lib")
#else
#include <pthread.h>
#include <sched.h>
#include <unistd.h>
#include <sys/time.h>
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
    NovaSlabPage* page = (NovaSlabPage*)malloc(sizeof(NovaSlabPage*) + page_data_size);
    if (!page) return;
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
    if (!nova_strpool_inited) nova_strpool_init();
    if (nova_strpool_top < 0) return NULL;
    int idx = nova_strpool_stack[nova_strpool_top--];
    nova_strpool_rc[idx] = 1;
    return nova_strpool_data[idx];
}

static inline void nova_strpool_free(char* ptr) {
    int idx = (int)((ptr - nova_strpool_data[0]) / NOVA_STRPOOL_SLOT_SIZE);
    nova_strpool_rc[idx] = 0;
    nova_strpool_stack[++nova_strpool_top] = idx;
}

static inline void nova_strpool_rc_inc(const void* ptr) {
    int idx = (int)(((const char*)ptr - nova_strpool_data[0]) / NOVA_STRPOOL_SLOT_SIZE);
    nova_strpool_rc[idx]++;
}

static inline int nova_strpool_rc_dec(const void* ptr) {
    int idx = (int)(((const char*)ptr - nova_strpool_data[0]) / NOVA_STRPOOL_SLOT_SIZE);
    if (--nova_strpool_rc[idx] <= 0) {
        nova_strpool_stack[++nova_strpool_top] = idx;
        return 1;
    }
    return 0;
}

/* ── Memory Registry (thread-safe hash map, O(1) lookup) ─────────────────── */

typedef enum {
    NOVA_MEM_RAW     = 0,
    NOVA_MEM_LIST    = 1,
    NOVA_MEM_DICT    = 2,
    NOVA_MEM_CHANNEL = 3,
    NOVA_MEM_FAT_STR = 4
} NovaMemTag;

static int64_t      nova_mem_live    = 0;
static int64_t      nova_mem_total   = 0;
static volatile int nova_is_multithreaded = 0;
static uintptr_t    nova_heap_base   = 0;  /* lowest address from CRT heap — fast filter for RC */

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

static void* nova_heap_alloc(size_t size, NovaMemTag tag) {
    size_t total = NOVA_RC_HDR_SIZE + size;
    char* base;
    if (!nova_slab_inited) nova_slab_init();
    if (tag == NOVA_MEM_LIST && total <= SLAB_32_OBJ_SIZE)
        base = (char*)nova_slab_alloc(&nova_slab_32);
    else if (tag == NOVA_MEM_DICT && total <= SLAB_64_OBJ_SIZE)
        base = (char*)nova_slab_alloc(&nova_slab_64);
    else
        base = (char*)calloc(1, total);
    if (!base) return NULL;
    ((int32_t*)base)[0] = 1;
    ((int32_t*)base)[1] = NOVA_RC_ENCODE(tag);
    nova_mem_total++;
    nova_mem_live++;
    return base + NOVA_RC_HDR_SIZE;
}

void* nova_rt_struct_alloc(int64_t size) {
    return nova_heap_alloc((size_t)size, NOVA_MEM_RAW);
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
    if (nova_int_str_cache_inited &&
        (char*)ptr >= nova_int_str_cache[0] &&
        (char*)ptr < nova_int_str_cache[0] + sizeof(nova_int_str_cache))
        return (NovaMemTag)-1;
    if (nova_strpool_contains(ptr)) return NOVA_MEM_RAW;
#ifdef _WIN32
    if (IsBadReadPtr((char*)ptr - NOVA_RC_HDR_SIZE, NOVA_RC_HDR_SIZE)) return (NovaMemTag)-1;
#endif
    if (NOVA_RC_VALID(ptr)) return NOVA_RC_TAG(ptr);
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
        int is_str = (nova_mem_find_tag((void*)(uintptr_t)list->data[i]) == NOVA_MEM_RAW)
                  || ((uint64_t)list->data[i] > 0x10000 && nova_is_readable_str((void*)(uintptr_t)list->data[i]));
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
    return (int64_t)(uintptr_t)buf;
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
        if (c >= 0x20 && c < 0x7F) {
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
        default:
            if ((uint64_t)val > 0x10000 && nova_is_readable_str(ptr)) {
                unsigned char c = *(unsigned char*)ptr;
                if (c >= 0x20 && c < 0x7F) return val;
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
    return a + b;
}

int64_t nova_rt_eq(int64_t a, int64_t b) {
    void* pa = (void*)(uintptr_t)a;
    void* pb = (void*)(uintptr_t)b;
    NovaMemTag ta = nova_mem_find_tag(pa);
    if (ta == NOVA_MEM_RAW || ta == NOVA_MEM_FAT_STR ||
        ((uint64_t)a > 0x10000 && ta == (NovaMemTag)-1 && nova_is_readable_str(pa))) {
        if ((uint64_t)b < 0x10000) return 0;
        return (strcmp((const char*)pa, (const char*)pb) == 0) ? 1 : 0;
    }
    return (a == b) ? 1 : 0;
}

int64_t nova_rt_neq(int64_t a, int64_t b) {
    return nova_rt_eq(a, b) ? 0 : 1;
}

int64_t nova_rt_print_any(int64_t val) {
    int64_t s = nova_rt_any_to_str(val);
    puts((const char*)(uintptr_t)s);
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

typedef struct {
    NovaProcessInfo* proc;
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

        NovaProcessInfo* proc = task.proc;
        proc->fn(proc->ctx);

        EnterCriticalSection(&proc->lock);
        proc->exit_status = 0;
        for (int64_t i = 0; i < proc->monitor_count; i++)
            nova_rt_channel_send(proc->monitors[i], proc->exit_status);
        proc->finished = 1;
        LeaveCriticalSection(&proc->lock);

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

        NovaProcessInfo* proc = task.proc;
        proc->fn(proc->ctx);

        pthread_mutex_lock(&proc->lock);
        proc->exit_status = 0;
        for (int64_t i = 0; i < proc->monitor_count; i++)
            nova_rt_channel_send(proc->monitors[i], proc->exit_status);
        proc->finished = 1;
        pthread_mutex_unlock(&proc->lock);

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
    /* Probe heap base — all calloc/malloc addresses will be at or above this.
       Integers from arithmetic (e.g. i*i) are far below this, enabling O(1) filter. */
    void* probe = malloc(64);
    if (probe) {
        nova_heap_base = (uintptr_t)probe;
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
int64_t nova_rt_path_join(int64_t a_ptr, int64_t b_ptr) {
    const char* a = (const char*)(uintptr_t)a_ptr;
    const char* b = (const char*)(uintptr_t)b_ptr;
    size_t alen = strlen(a), blen = strlen(b);
    char sep = '/';
#ifdef _WIN32
    sep = '\\';
#endif
    size_t total = alen + 1 + blen + 1;
    char* result = (char*)nova_heap_alloc(total, NOVA_MEM_RAW);
    if (!result) return (int64_t)(uintptr_t)"";
    memcpy(result, a, alen);
    if (alen > 0 && a[alen-1] != '/' && a[alen-1] != '\\') {
        result[alen] = sep; alen++;
    }
    memcpy(result + alen, b, blen);
    result[alen + blen] = '\0';
    return (int64_t)(uintptr_t)result;
}

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
    proc->ctx = (void*)(uintptr_t)ctx_ptr;
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
    NOVA_RC_COUNT(ptr)++;
}

static void nova_rc_dec_internal(int64_t val) {
    if ((uint64_t)val < 0x10000ULL) return;
    void* ptr = (void*)(uintptr_t)val;
    int kind = nova_rc_is_managed(ptr);
    if (kind == 0) return;
    if (kind == -1) { nova_strpool_rc_dec(ptr); return; }
    if (--NOVA_RC_COUNT(ptr) <= 0) {
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
