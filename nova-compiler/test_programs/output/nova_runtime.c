#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#include <math.h>
#include <ctype.h>
#include <errno.h>

#ifdef _WIN32
#include <windows.h>
#include <winhttp.h>
#pragma comment(lib, "winhttp.lib")
#else
#include <pthread.h>
#include <sched.h>
#include <unistd.h>
#include <sys/time.h>
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

/* ── Fat Strings: [hash:8][len:8][char data...]['\0'] ─────────────────────
   Pointer returned to user code points to char data (offset +16 from base).
   This IS a valid const char* for printf, strcmp, memcpy, etc.
   Hash/length accessible via negative indexing from the char pointer.
   Eliminates per-lookup FNV-1a traversal in dict/intern operations. */

#define NOVA_FAT_HDR_SIZE 16
#define NOVA_FAT_HASH(p) (((const uint64_t*)(p))[-2])
#define NOVA_FAT_LEN(p)  (((const int64_t*)(p))[-1])

typedef struct {
    void*      ptr;
    NovaMemTag tag;
    int32_t    rc;
    int32_t    pad_;
} NovaMemSlot;

#define NOVA_MEM_HT_INIT_CAP 4096

static NovaMemSlot* nova_mem_ht      = NULL;
static int64_t      nova_mem_ht_cap  = 0;
static int64_t      nova_mem_ht_used = 0;
static int64_t      nova_mem_total   = 0;
static volatile int nova_is_multithreaded = 0;

#ifdef _WIN32
static CRITICAL_SECTION nova_mem_lock;
#else
static pthread_mutex_t nova_mem_lock = PTHREAD_MUTEX_INITIALIZER;
#endif

static void nova_mem_lock_acquire(void) {
    if (!nova_is_multithreaded) return;
#ifdef _WIN32
    EnterCriticalSection(&nova_mem_lock);
#else
    pthread_mutex_lock(&nova_mem_lock);
#endif
}

static void nova_mem_lock_release(void) {
    if (!nova_is_multithreaded) return;
#ifdef _WIN32
    LeaveCriticalSection(&nova_mem_lock);
#else
    pthread_mutex_unlock(&nova_mem_lock);
#endif
}

void nova_rc_inc(int64_t val);
void nova_rc_dec(int64_t val);

static uint64_t nova_ptr_hash(void* p) {
    uint64_t v = (uint64_t)(uintptr_t)p;
    v ^= v >> 3;
    v *= 0x9E3779B97F4A7C15ULL;
    v ^= v >> 16;
    return v;
}

static void nova_mem_ht_insert_internal(NovaMemSlot* ht, int64_t cap,
                                         void* ptr, NovaMemTag tag, int32_t rc) {
    uint64_t idx = nova_ptr_hash(ptr) & (uint64_t)(cap - 1);
    while (ht[idx].ptr != NULL && ht[idx].ptr != ptr)
        idx = (idx + 1) & (uint64_t)(cap - 1);
    ht[idx].ptr = ptr;
    ht[idx].tag = tag;
    ht[idx].rc  = rc;
}

static void nova_mem_ht_grow(void) {
    int64_t old_cap = nova_mem_ht_cap;
    NovaMemSlot* old = nova_mem_ht;
    int64_t new_cap = old_cap * 2;
    NovaMemSlot* fresh = (NovaMemSlot*)calloc((size_t)new_cap, sizeof(NovaMemSlot));
    if (!fresh) return;
    int64_t live = 0;
    for (int64_t i = 0; i < old_cap; i++) {
        if (old[i].ptr) {
            nova_mem_ht_insert_internal(fresh, new_cap, old[i].ptr, old[i].tag, old[i].rc);
            live++;
        }
    }
    nova_mem_ht = fresh;
    nova_mem_ht_cap = new_cap;
    nova_mem_ht_used = live;
    free(old);
}

/* Robin Hood backward-shift deletion: removes entry at del_idx and
   shifts subsequent entries back to preserve probe-chain continuity.
   After this call, every non-NULL slot is a live tracked object —
   there are no tombstones. This prevents stale RC decs from accidentally
   hitting a reactivated slot for a different object. */
static void nova_mem_ht_delete(uint64_t del_idx) {
    uint64_t mask = (uint64_t)(nova_mem_ht_cap - 1);
    nova_mem_ht[del_idx].ptr  = NULL;
    nova_mem_ht[del_idx].rc   = 0;
    nova_mem_ht[del_idx].pad_ = 0;
    nova_mem_ht_used--;

    uint64_t gap = del_idx;
    uint64_t j   = (gap + 1) & mask;
    while (nova_mem_ht[j].ptr != NULL) {
        uint64_t h = nova_ptr_hash(nova_mem_ht[j].ptr) & mask;
        /* Shift entry at j to gap if gap is on the probe path from h to j,
           i.e., gap is closer to h than j is (in forward circular distance). */
        if (((gap - h) & mask) < ((j - h) & mask)) {
            nova_mem_ht[gap] = nova_mem_ht[j];
            nova_mem_ht[j].ptr  = NULL;
            nova_mem_ht[j].rc   = 0;
            nova_mem_ht[j].pad_ = 0;
            gap = j;
        }
        j = (j + 1) & mask;
    }
}

static void nova_mem_track(void* ptr, NovaMemTag tag) {
    if (!ptr) return;
    nova_mem_lock_acquire();
    if (!nova_mem_ht) {
        nova_mem_ht_cap = NOVA_MEM_HT_INIT_CAP;
        nova_mem_ht = (NovaMemSlot*)calloc((size_t)nova_mem_ht_cap, sizeof(NovaMemSlot));
    }
    if (nova_mem_ht_used * 2 >= nova_mem_ht_cap) nova_mem_ht_grow();
    uint64_t idx = nova_ptr_hash(ptr) & (uint64_t)(nova_mem_ht_cap - 1);
    while (nova_mem_ht[idx].ptr != NULL)
        idx = (idx + 1) & (uint64_t)(nova_mem_ht_cap - 1);
    nova_mem_ht[idx].ptr = ptr;
    nova_mem_ht[idx].tag = tag;
    nova_mem_ht[idx].rc  = 1;
    nova_mem_ht_used++;
    nova_mem_total++;
    nova_mem_lock_release();
}

static NovaMemTag nova_mem_find_tag(void* ptr) {
    if (!ptr || !nova_mem_ht) return (NovaMemTag)-1;
    nova_mem_lock_acquire();
    uint64_t idx = nova_ptr_hash(ptr) & (uint64_t)(nova_mem_ht_cap - 1);
    while (nova_mem_ht[idx].ptr != NULL) {
        if (nova_mem_ht[idx].ptr == ptr) {
            NovaMemTag t = nova_mem_ht[idx].tag;
            nova_mem_lock_release();
            return t;
        }
        idx = (idx + 1) & (uint64_t)(nova_mem_ht_cap - 1);
    }
    nova_mem_lock_release();
    return (NovaMemTag)-1;
}

void nova_rt_track_raw(void* ptr) {
    nova_mem_track(ptr, NOVA_MEM_RAW);
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

/* Forward declarations for int_to_str cache (used by nova_intern_h) */
static char     nova_int_str_cache[10000][8];
static uint64_t nova_int_str_cache_hash[10000];
static int      nova_int_str_cache_inited;

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
   Allocates [hash:8][len:8][data...]['\0'], returns pointer to data.
   Hash is computed during the copy in a single pass — zero extra cost. */

static char* nova_fat_str_create(const char* src, size_t len) {
    char* base = (char*)malloc(NOVA_FAT_HDR_SIZE + len + 1);
    if (!base) return NULL;
    uint64_t h = 14695981039346656037ULL;
    char* str = base + NOVA_FAT_HDR_SIZE;
    for (size_t i = 0; i < len; i++) {
        str[i] = src[i];
        h ^= (uint64_t)(unsigned char)src[i];
        h *= 1099511628211ULL;
    }
    str[len] = '\0';
    ((uint64_t*)base)[0] = h;
    ((int64_t*)base)[1] = (int64_t)len;
    return str;
}

static char* nova_fat_str_concat(const char* sa, size_t la,
                                  const char* sb, size_t lb) {
    size_t total = la + lb;
    char* base = (char*)malloc(NOVA_FAT_HDR_SIZE + total + 1);
    if (!base) return NULL;
    char* str = base + NOVA_FAT_HDR_SIZE;
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
    NovaList* list = (NovaList*)nova_fast_alloc(sizeof(NovaList));
    if (!list) return 0;
    list->data = malloc(8 * sizeof(int64_t));
    list->size = 0;
    list->cap  = 8;
    nova_mem_track(list, NOVA_MEM_LIST);
    return (int64_t)(uintptr_t)list;
}

int64_t nova_rt_list_create_filled(int64_t count, int64_t value) {
    if (count < 0) count = 0;
    NovaList* list = (NovaList*)nova_fast_alloc(sizeof(NovaList));
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
    nova_mem_track(list, NOVA_MEM_LIST);
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
    nova_mem_track(buf, NOVA_MEM_RAW);
    return (int64_t)(uintptr_t)buf;
}

/* ── Strings ──────────────────────────────────────────────────────────────── */

int64_t nova_rt_str_concat(int64_t a, int64_t b) {
    const char* sa = (const char*)(uintptr_t)a;
    const char* sb = (const char*)(uintptr_t)b;
    size_t la = strlen(sa), lb = strlen(sb);
    size_t total = la + lb;
    char* result = (char*)malloc(total + 1);
    if (!result) return 0;
    memcpy(result, sa, la);
    memcpy(result + la, sb, lb + 1);
    nova_mem_track(result, NOVA_MEM_RAW);
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
    nova_mem_track(result, NOVA_MEM_FAT_STR);
    return (int64_t)(uintptr_t)result;
}

int64_t nova_rt_float_to_str(int64_t bits) {
    double v;
    memcpy(&v, &bits, sizeof(double));
    char tmp[32];
    int len = snprintf(tmp, 32, "%g", v);
    char* result = nova_fat_str_create(tmp, (size_t)len);
    if (!result) return 0;
    nova_mem_track(result, NOVA_MEM_FAT_STR);
    return (int64_t)(uintptr_t)result;
}

int64_t nova_rt_bool_to_str(int64_t v) {
    const char* s = v ? "true" : "false";
    size_t len = strlen(s) + 1;
    char* buf = malloc(len);
    memcpy(buf, s, len);
    nova_mem_track(buf, NOVA_MEM_RAW);
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
    if (start >= end) { char* r = malloc(1); r[0] = '\0'; nova_mem_track(r, NOVA_MEM_RAW); return (int64_t)(uintptr_t)r; }
    int64_t n = end - start;
    char* result = malloc((size_t)n + 1);
    memcpy(result, str + start, (size_t)n);
    result[n] = '\0';
    nova_mem_track(result, NOVA_MEM_RAW);
    return (int64_t)(uintptr_t)result;
}

int64_t nova_rt_upper(int64_t s) {
    const char* str = (const char*)(uintptr_t)s;
    size_t len = strlen(str);
    char* result = malloc(len + 1);
    for (size_t i = 0; i <= len; i++)
        result[i] = (str[i] >= 'a' && str[i] <= 'z') ? str[i] - 32 : str[i];
    nova_mem_track(result, NOVA_MEM_RAW);
    return (int64_t)(uintptr_t)result;
}

int64_t nova_rt_lower(int64_t s) {
    const char* str = (const char*)(uintptr_t)s;
    size_t len = strlen(str);
    char* result = malloc(len + 1);
    for (size_t i = 0; i <= len; i++)
        result[i] = (str[i] >= 'A' && str[i] <= 'Z') ? str[i] + 32 : str[i];
    nova_mem_track(result, NOVA_MEM_RAW);
    return (int64_t)(uintptr_t)result;
}

int64_t nova_rt_trim(int64_t s) {
    const char* str = (const char*)(uintptr_t)s;
    while (*str == ' ' || *str == '\t' || *str == '\n' || *str == '\r') str++;
    size_t len = strlen(str);
    while (len > 0 && (str[len-1] == ' ' || str[len-1] == '\t' || str[len-1] == '\n' || str[len-1] == '\r')) len--;
    char* result = malloc(len + 1);
    memcpy(result, str, len);
    result[len] = '\0';
    nova_mem_track(result, NOVA_MEM_RAW);
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
            char* part = malloc(rem + 1);
            memcpy(part, pos, rem + 1);
            nova_mem_track(part, NOVA_MEM_RAW);
            nova_rt_list_append(list, (int64_t)(uintptr_t)part);
            break;
        }
        size_t n = (size_t)(found - pos);
        char* part = malloc(n + 1);
        memcpy(part, pos, n);
        part[n] = '\0';
        nova_mem_track(part, NOVA_MEM_RAW);
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
    char* result = malloc(result_len + 1);
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
    nova_mem_track(result, NOVA_MEM_RAW);
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
    if (l->size == 0) { char* r = malloc(1); r[0] = '\0'; nova_mem_track(r, NOVA_MEM_RAW); return (int64_t)(uintptr_t)r; }
    size_t total = 0;
    for (int64_t i = 0; i < l->size; i++) {
        total += strlen((const char*)(uintptr_t)l->data[i]);
        if (i < l->size - 1) total += sep_len;
    }
    char* result = malloc(total + 1);
    char* dst = result;
    for (int64_t i = 0; i < l->size; i++) {
        const char* elem = (const char*)(uintptr_t)l->data[i];
        size_t elen = strlen(elem);
        memcpy(dst, elem, elen); dst += elen;
        if (i < l->size - 1) { memcpy(dst, s, sep_len); dst += sep_len; }
    }
    *dst = '\0';
    nova_mem_track(result, NOVA_MEM_RAW);
    return (int64_t)(uintptr_t)result;
}

int64_t nova_rt_chars(int64_t s) {
    const char* str = (const char*)(uintptr_t)s;
    size_t len = strlen(str);
    int64_t list = nova_rt_list_create();
    for (size_t i = 0; i < len; i++) {
        char* ch = malloc(2);
        ch[0] = str[i]; ch[1] = '\0';
        nova_mem_track(ch, NOVA_MEM_RAW);
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
    NovaDict* d = (NovaDict*)nova_fast_alloc(sizeof(NovaDict));
    if (!d) return 0;
    d->cap     = 8;
    d->keys    = malloc(8 * sizeof(int64_t));
    d->vals    = malloc(8 * sizeof(int64_t));
    d->hashes  = malloc(8 * sizeof(uint64_t));
    d->size    = 0;
    d->idx_cap = 16;
    d->idx     = malloc(16 * sizeof(int64_t));
    memset(d->idx, 0xFF, 16 * sizeof(int64_t));
    nova_mem_track(d, NOVA_MEM_DICT);
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

    char* combined = (char*)malloc(la + lb + 1);
    if (!combined) return 0;
    memcpy(combined, sa, la);
    memcpy(combined + la, sb, lb + 1);
    nova_mem_track(combined, NOVA_MEM_RAW);

    if (d->size >= d->cap) {
        d->cap *= 2;
        d->keys = realloc(d->keys, (size_t)d->cap * sizeof(int64_t));
        d->vals = realloc(d->vals, (size_t)d->cap * sizeof(int64_t));
        d->hashes = realloc(d->hashes, (size_t)d->cap * sizeof(uint64_t));
    }
    d->keys[d->size] = (int64_t)(uintptr_t)combined;
    d->vals[d->size] = val;
    d->hashes[d->size] = h;
    nova_rc_inc((int64_t)(uintptr_t)combined);
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
    char* buf = malloc(2);
    nova_mem_track(buf, NOVA_MEM_RAW);
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
    char* buf = malloc(4096);
    nova_mem_track(buf, NOVA_MEM_RAW);
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
        char* e = malloc(1); e[0] = '\0';
        nova_mem_track(e, NOVA_MEM_RAW);
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
        char* e = malloc(1); if (e) { e[0] = '\0'; nova_mem_track(e, NOVA_MEM_RAW); }
        return (int64_t)(uintptr_t)e;
    }
    char* buf = malloc((size_t)sz + 1);
    if (!buf) {
        fclose(f);
        nova_set_error("read_file: out of memory");
        char* e = malloc(1); if (e) { e[0] = '\0'; }
        return (int64_t)(uintptr_t)e;
    }
    size_t nr = fread(buf, 1, (size_t)sz, f);
    buf[nr] = '\0';
    fclose(f);
    nova_mem_track(buf, NOVA_MEM_RAW);
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
    char* buf = malloc((size_t)len + 1);
    memcpy(buf, s, (size_t)len);
    buf[len] = '\0';
    nova_mem_track(buf, NOVA_MEM_RAW);
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
    char* buf = malloc((size_t)raw_len + 1);
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
    nova_mem_track(buf, NOVA_MEM_RAW);
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
    nova_mem_track(b.buf, NOVA_MEM_RAW);
    return (int64_t)(uintptr_t)b.buf;
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
        char* r = malloc(1); r[0] = '\0';
        nova_mem_track(r, NOVA_MEM_RAW);
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
    NovaChannel* ch = malloc(sizeof(NovaChannel));
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
    nova_mem_track(ch, NOVA_MEM_CHANNEL);
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
                int64_t* tup = malloc(2 * sizeof(int64_t));
                tup[0] = i;
                tup[1] = value;
                nova_mem_track(tup, NOVA_MEM_RAW);
                return (int64_t)(uintptr_t)tup;
            }
            if (!channel_is_closed(ch) || ch->count > 0)
                all_closed_empty = 0;
        }
        if (all_closed_empty) {
            int64_t* tup = malloc(2 * sizeof(int64_t));
            tup[0] = -1;
            tup[1] = 0;
            nova_mem_track(tup, NOVA_MEM_RAW);
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

void nova_rt_init(void) {
#ifdef _WIN32
    InitializeCriticalSection(&nova_mem_lock);
    InitializeCriticalSection(&nova_proc_registry_lock);
#endif
    nova_slab_init();
    if (!nova_mem_ht) {
        nova_mem_ht_cap = NOVA_MEM_HT_INIT_CAP;
        nova_mem_ht = (NovaMemSlot*)calloc((size_t)nova_mem_ht_cap, sizeof(NovaMemSlot));
    }
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

static void nova_rc_free_entry(int64_t idx) {
    void* p = nova_mem_ht[idx].ptr;
    if (!p) return;
    NovaMemTag tag = nova_mem_ht[idx].tag;
    /* Remove from hash table BEFORE cascading frees. Robin Hood backward-shift
       ensures the slot is truly gone — no tombstone left behind. Stale RC decs
       from outer stack frames will probe past NULL and silently no-op instead
       of hitting a reactivated slot for a different object. */
    nova_mem_ht_delete((uint64_t)idx);
#ifdef NOVA_DEBUG_RC
    {
        int prev = nova_debug_was_freed(p);
        if (prev >= 0) {
            fprintf(stderr, "BUG-DOUBLE-FREE-RC: ptr=%p freed again via nova_rc_free_entry "
                    "(first freed at debug_idx=%d with rc=%d, tag=%d)\n",
                    p, prev, nova_debug_freed_rc[prev], (int)tag);
            fflush(stderr);
        }
        nova_debug_record_free(p, 0);
    }
#endif
    switch (tag) {
        case NOVA_MEM_LIST: {
            NovaList* l = (NovaList*)p;
            for (int64_t i = 0; i < l->size; i++)
                nova_rc_dec_internal(l->data[i]);
            if (l->data) free(l->data);
            nova_fast_free(l, sizeof(NovaList));
            break;
        }
        case NOVA_MEM_DICT: {
            NovaDict* d = (NovaDict*)p;
            for (int64_t i = 0; i < d->size; i++) {
                nova_rc_dec_internal(d->keys[i]);
                nova_rc_dec_internal(d->vals[i]);
            }
            if (d->keys) free(d->keys);
            if (d->vals) free(d->vals);
            if (d->idx)  free(d->idx);
            nova_fast_free(d, sizeof(NovaDict));
            break;
        }
        case NOVA_MEM_CHANNEL:
            break;
        case NOVA_MEM_FAT_STR:
            free((char*)p - NOVA_FAT_HDR_SIZE);
            break;
        default:
            free(p);
            break;
    }
}

void nova_rc_inc(int64_t val) {
    if ((uint64_t)val < 0x10000ULL) return;
    void* ptr = (void*)(uintptr_t)val;
    if (nova_int_str_cache_inited &&
        ptr >= (void*)nova_int_str_cache[0] &&
        ptr < (void*)(nova_int_str_cache[0] + sizeof(nova_int_str_cache)))
        return;
    if (!nova_mem_ht) return;
    nova_mem_lock_acquire();
    uint64_t idx = nova_ptr_hash(ptr) & (uint64_t)(nova_mem_ht_cap - 1);
    while (nova_mem_ht[idx].ptr != NULL) {
        if (nova_mem_ht[idx].ptr == ptr && nova_mem_ht[idx].rc > 0) {
            nova_mem_ht[idx].rc++;
            nova_mem_lock_release();
            return;
        }
        idx = (idx + 1) & (uint64_t)(nova_mem_ht_cap - 1);
    }
    nova_mem_lock_release();
}

static void nova_rc_dec_internal(int64_t val) {
    if ((uint64_t)val < 0x10000ULL) return;
    void* ptr = (void*)(uintptr_t)val;
    if (!nova_mem_ht) return;
    uint64_t idx = nova_ptr_hash(ptr) & (uint64_t)(nova_mem_ht_cap - 1);
    while (nova_mem_ht[idx].ptr != NULL) {
        if (nova_mem_ht[idx].ptr == ptr && nova_mem_ht[idx].rc > 0) {
            nova_mem_ht[idx].rc--;
            if (nova_mem_ht[idx].rc <= 0) {
                nova_rc_free_entry(idx);
            }
            return;
        }
        idx = (idx + 1) & (uint64_t)(nova_mem_ht_cap - 1);
    }
}

void nova_rc_dec(int64_t val) {
    if ((uint64_t)val < 0x10000ULL) return;
    void* ptr = (void*)(uintptr_t)val;
    if (nova_int_str_cache_inited &&
        ptr >= (void*)nova_int_str_cache[0] &&
        ptr < (void*)(nova_int_str_cache[0] + sizeof(nova_int_str_cache)))
        return;
    if (!nova_mem_ht) return;
    nova_mem_lock_acquire();
    nova_rc_dec_internal(val);
    nova_mem_lock_release();
}

/* ── Memory Cleanup ─────────────────────────────────────────────────────── */

int64_t nova_rt_alloc_count(void) {
    return nova_mem_total;
}

int64_t nova_rt_live_count(void) {
    return nova_mem_ht_used;
}

void nova_rt_cleanup(void) {
    if (!nova_mem_ht) return;
    /* All non-NULL slots are live tracked objects (Robin Hood: no tombstones). */
    for (int64_t i = 0; i < nova_mem_ht_cap; i++) {
        void* p = nova_mem_ht[i].ptr;
        if (!p) continue;
        switch (nova_mem_ht[i].tag) {
            case NOVA_MEM_LIST: {
                NovaList* l = (NovaList*)p;
                if (l->data) free(l->data);
                nova_fast_free(l, sizeof(NovaList));
                break;
            }
            case NOVA_MEM_DICT: {
                NovaDict* d = (NovaDict*)p;
                if (d->keys) free(d->keys);
                if (d->vals) free(d->vals);
                if (d->idx)  free(d->idx);
                nova_fast_free(d, sizeof(NovaDict));
                break;
            }
            case NOVA_MEM_CHANNEL: {
                NovaChannel* ch = (NovaChannel*)p;
                if (ch->buf) free(ch->buf);
#ifdef _WIN32
                DeleteCriticalSection(&ch->lock);
#else
                pthread_mutex_destroy(&ch->lock);
                pthread_cond_destroy(&ch->not_empty);
#endif
                free(ch);
                break;
            }
            case NOVA_MEM_FAT_STR:
                free((char*)p - NOVA_FAT_HDR_SIZE);
                break;
            default:
                free(p);
                break;
        }
    }
    free(nova_mem_ht);
    nova_mem_ht = NULL;
    nova_mem_ht_used = 0;
    nova_mem_ht_cap = 0;
    nova_mem_total = 0;
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
        char* e = malloc(1); e[0] = '\0'; nova_mem_track(e, NOVA_MEM_RAW);
        return (int64_t)(uintptr_t)e;
    }

    HINTERNET session = WinHttpOpen(L"NOVA/1.0",
        WINHTTP_ACCESS_TYPE_DEFAULT_PROXY, WINHTTP_NO_PROXY_NAME,
        WINHTTP_NO_PROXY_BYPASS, 0);
    if (!session) {
        nova_set_error("HTTP: failed to open session");
        char* e = malloc(1); e[0] = '\0'; nova_mem_track(e, NOVA_MEM_RAW);
        return (int64_t)(uintptr_t)e;
    }
    WinHttpSetTimeouts(session, 10000, 10000, 30000, 30000);

    HINTERNET connect = WinHttpConnect(session, host, (INTERNET_PORT)port, 0);
    if (!connect) {
        nova_set_error("HTTP: failed to connect");
        WinHttpCloseHandle(session);
        char* e = malloc(1); e[0] = '\0'; nova_mem_track(e, NOVA_MEM_RAW);
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
        char* e = malloc(1); e[0] = '\0'; nova_mem_track(e, NOVA_MEM_RAW);
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
        char* e = malloc(1); e[0] = '\0'; nova_mem_track(e, NOVA_MEM_RAW);
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
        char* e = malloc(1); e[0] = '\0'; nova_mem_track(e, NOVA_MEM_RAW);
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
            char* e = malloc(1); e[0] = '\0'; nova_mem_track(e, NOVA_MEM_RAW);
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

    nova_mem_track(buf.data, NOVA_MEM_RAW);
    return (int64_t)(uintptr_t)buf.data;
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
    char* e = malloc(1); e[0] = '\0'; nova_mem_track(e, NOVA_MEM_RAW);
    return (int64_t)(uintptr_t)e;
}

int64_t nova_rt_http_post(int64_t url, int64_t body, int64_t content_type) {
    (void)url; (void)body; (void)content_type;
    nova_set_error("HTTP: not implemented on this platform");
    char* e = malloc(1); e[0] = '\0'; nova_mem_track(e, NOVA_MEM_RAW);
    return (int64_t)(uintptr_t)e;
}

#endif
