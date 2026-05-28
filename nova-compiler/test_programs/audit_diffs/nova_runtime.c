#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#include <math.h>

#ifdef _WIN32
#include <windows.h>
#else
#include <pthread.h>
#include <sched.h>
#include <unistd.h>
#include <sys/time.h>
#endif

/* ── Memory Tracking ────────────────────────────────────────────────────── */

typedef enum {
    NOVA_MEM_RAW     = 0,
    NOVA_MEM_LIST    = 1,
    NOVA_MEM_DICT    = 2,
    NOVA_MEM_CHANNEL = 3
} NovaMemTag;

typedef struct {
    void*      ptr;
    NovaMemTag tag;
    int32_t    rc;
    int32_t    pad_;
} NovaMemEntry;

static NovaMemEntry* nova_mem_registry = NULL;
static int64_t nova_mem_count = 0;
static int64_t nova_mem_cap   = 0;

static void nova_mem_track(void* ptr, NovaMemTag tag) {
    if (nova_mem_count >= nova_mem_cap) {
        nova_mem_cap = nova_mem_cap == 0 ? 4096 : nova_mem_cap * 2;
        nova_mem_registry = (NovaMemEntry*)realloc(nova_mem_registry,
            (size_t)nova_mem_cap * sizeof(NovaMemEntry));
    }
    nova_mem_registry[nova_mem_count].ptr = ptr;
    nova_mem_registry[nova_mem_count].tag = tag;
    nova_mem_registry[nova_mem_count].rc  = 1;
    nova_mem_count++;
}

void nova_rt_track_raw(void* ptr) {
    nova_mem_track(ptr, NOVA_MEM_RAW);
}

void nova_rc_inc(int64_t val) {
    if (val == 0) return;
    void* ptr = (void*)(uintptr_t)val;
    for (int64_t i = nova_mem_count - 1; i >= 0; i--) {
        if (nova_mem_registry[i].ptr == ptr) {
            nova_mem_registry[i].rc++;
            return;
        }
    }
}

void nova_rc_dec(int64_t val) {
    if (val == 0) return;
    void* ptr = (void*)(uintptr_t)val;
    for (int64_t i = nova_mem_count - 1; i >= 0; i--) {
        if (nova_mem_registry[i].ptr == ptr) {
            nova_mem_registry[i].rc--;
            if (nova_mem_registry[i].rc <= 0) {
                if (nova_mem_registry[i].tag == NOVA_MEM_RAW) free(ptr);
                nova_mem_registry[i].ptr = NULL;
            }
            return;
        }
    }
}

/* ── List ─────────────────────────────────────────────────────────────────── */

typedef struct {
    int64_t* data;
    int64_t  size;
    int64_t  cap;
} NovaList;

int64_t nova_rt_list_create(void) {
    NovaList* list = malloc(sizeof(NovaList));
    list->data = malloc(8 * sizeof(int64_t));
    list->size = 0;
    list->cap  = 8;
    nova_mem_track(list, NOVA_MEM_LIST);
    return (int64_t)(uintptr_t)list;
}

int64_t nova_rt_list_create_filled(int64_t count, int64_t value) {
    NovaList* list = malloc(sizeof(NovaList));
    int64_t cap = count < 8 ? 8 : count;
    list->data = malloc((size_t)cap * sizeof(int64_t));
    list->size = count;
    list->cap  = cap;
    if (value == 0) {
        memset(list->data, 0, (size_t)count * sizeof(int64_t));
    } else {
        for (int64_t i = 0; i < count; i++) list->data[i] = value;
    }
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
    return 0;
}

int64_t nova_rt_list_get(int64_t handle, int64_t index) {
    NovaList* list = (NovaList*)(uintptr_t)handle;
    return list->data[index];
}

int64_t nova_rt_list_set(int64_t handle, int64_t index, int64_t value) {
    NovaList* list = (NovaList*)(uintptr_t)handle;
    list->data[index] = value;
    return 0;
}

int64_t nova_rt_list_len(int64_t handle) {
    NovaList* list = (NovaList*)(uintptr_t)handle;
    return list->size;
}

int64_t nova_rt_iter_has_next(int64_t handle, int64_t index) {
    NovaList* list = (NovaList*)(uintptr_t)handle;
    return (index < list->size) ? 1 : 0;
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

int64_t nova_rt_len_any(int64_t handle) {
    int64_t* p = (int64_t*)(uintptr_t)handle;
    int64_t maybe_size = p[1];
    int64_t maybe_cap = p[2];
    if (maybe_size >= 0 && maybe_cap >= maybe_size && maybe_cap < (1LL << 30)) {
        return maybe_size;
    }
    return (int64_t)strlen((const char*)(uintptr_t)handle);
}

int64_t nova_rt_list_to_str(int64_t handle) {
    NovaList* list = (NovaList*)(uintptr_t)handle;
    size_t cap = 256;
    char* buf = malloc(cap);
    size_t pos = 0;
    buf[pos++] = '[';
    for (int64_t i = 0; i < list->size; i++) {
        if (i > 0) { buf[pos++] = ','; buf[pos++] = ' '; }
        char tmp[32];
        int n = snprintf(tmp, sizeof(tmp), "%lld", (long long)list->data[i]);
        while (pos + n + 4 >= cap) { cap *= 2; buf = realloc(buf, cap); }
        memcpy(buf + pos, tmp, n);
        pos += n;
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
    char* result = malloc(la + lb + 1);
    memcpy(result, sa, la);
    memcpy(result + la, sb, lb + 1);
    nova_mem_track(result, NOVA_MEM_RAW);
    return (int64_t)(uintptr_t)result;
}

int64_t nova_rt_int_to_str(int64_t v) {
    char* buf = malloc(32);
    snprintf(buf, 32, "%lld", (long long)v);
    nova_mem_track(buf, NOVA_MEM_RAW);
    return (int64_t)(uintptr_t)buf;
}

int64_t nova_rt_float_to_str(int64_t bits) {
    double v;
    memcpy(&v, &bits, sizeof(double));
    char* buf = malloc(32);
    snprintf(buf, 32, "%g", v);
    nova_mem_track(buf, NOVA_MEM_RAW);
    return (int64_t)(uintptr_t)buf;
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
    return (int64_t)strlen((const char*)(uintptr_t)handle);
}

int64_t nova_rt_len(int64_t handle) {
    return (int64_t)strlen((const char*)(uintptr_t)handle);
}

int64_t nova_rt_contains(int64_t s, int64_t sub) {
    const char* str = (const char*)(uintptr_t)s;
    const char* needle = (const char*)(uintptr_t)sub;
    return strstr(str, needle) != NULL ? 1 : 0;
}

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
    size_t result_len = strlen(str) + count * (new_len - old_len);
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
    for (int64_t i = 0; i < la->size; i++)
        result->data[result->size++] = la->data[i];
    for (int64_t i = 0; i < lb->size; i++)
        result->data[result->size++] = lb->data[i];
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

/* ── Dict (Phase 1: ordered key-value array, O(n) lookup) ────────────────── */

typedef struct {
    int64_t* keys;
    int64_t* vals;
    int64_t  size;
    int64_t  cap;
} NovaDict;

int64_t nova_rt_dict_create(void) {
    NovaDict* d = malloc(sizeof(NovaDict));
    d->keys = malloc(8 * sizeof(int64_t));
    d->vals = malloc(8 * sizeof(int64_t));
    d->size = 0;
    d->cap  = 8;
    nova_mem_track(d, NOVA_MEM_DICT);
    return (int64_t)(uintptr_t)d;
}

int64_t nova_rt_dict_set(int64_t handle, int64_t key, int64_t val) {
    NovaDict* d = (NovaDict*)(uintptr_t)handle;
    const char* k = (const char*)(uintptr_t)key;
    for (int64_t i = 0; i < d->size; i++) {
        if (strcmp((const char*)(uintptr_t)d->keys[i], k) == 0) {
            d->vals[i] = val;
            return 0;
        }
    }
    if (d->size >= d->cap) {
        d->cap *= 2;
        d->keys = realloc(d->keys, (size_t)d->cap * sizeof(int64_t));
        d->vals = realloc(d->vals, (size_t)d->cap * sizeof(int64_t));
    }
    d->keys[d->size] = key;
    d->vals[d->size] = val;
    d->size++;
    return 0;
}

int64_t nova_rt_dict_get(int64_t handle, int64_t key) {
    NovaDict* d = (NovaDict*)(uintptr_t)handle;
    const char* k = (const char*)(uintptr_t)key;
    for (int64_t i = 0; i < d->size; i++) {
        if (strcmp((const char*)(uintptr_t)d->keys[i], k) == 0)
            return d->vals[i];
    }
    return 0;
}

int64_t nova_rt_dict_has(int64_t handle, int64_t key) {
    NovaDict* d = (NovaDict*)(uintptr_t)handle;
    const char* k = (const char*)(uintptr_t)key;
    for (int64_t i = 0; i < d->size; i++) {
        if (strcmp((const char*)(uintptr_t)d->keys[i], k) == 0)
            return 1;
    }
    return 0;
}

int64_t nova_rt_dict_del(int64_t handle, int64_t key) {
    NovaDict* d = (NovaDict*)(uintptr_t)handle;
    const char* k = (const char*)(uintptr_t)key;
    for (int64_t i = 0; i < d->size; i++) {
        if (strcmp((const char*)(uintptr_t)d->keys[i], k) == 0) {
            for (int64_t j = i; j < d->size - 1; j++) {
                d->keys[j] = d->keys[j+1];
                d->vals[j] = d->vals[j+1];
            }
            d->size--;
            return 1;
        }
    }
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
    FILE* f = fopen(p, "r");
    if (!f) { char* e = malloc(1); e[0] = '\0'; nova_mem_track(e, NOVA_MEM_RAW); return (int64_t)(uintptr_t)e; }
    fseek(f, 0, SEEK_END);
    long sz = ftell(f);
    fseek(f, 0, SEEK_SET);
    char* buf = malloc((size_t)sz + 1);
    size_t nr = fread(buf, 1, (size_t)sz, f);
    buf[nr] = '\0';
    fclose(f);
    nova_mem_track(buf, NOVA_MEM_RAW);
    return (int64_t)(uintptr_t)buf;
}

int64_t nova_rt_write_file(int64_t path, int64_t content) {
    const char* p = (const char*)(uintptr_t)path;
    const char* c = (const char*)(uintptr_t)content;
    FILE* f = fopen(p, "w");
    if (!f) return -1;
    fputs(c, f);
    fclose(f);
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
        for (int64_t i = 0; i < ch->count; i++)
            new_buf[i] = ch->buf[(ch->head + i) % ch->cap];
        free(ch->buf);
        ch->buf = new_buf;
        ch->head = 0;
        ch->cap = new_cap;
    }
    int64_t tail = (ch->head + ch->count) % ch->cap;
    ch->buf[tail] = value;
    ch->count++;
}

static int64_t channel_dequeue(NovaChannel* ch) {
    int64_t value = ch->buf[ch->head];
    ch->head = (ch->head + 1) % ch->cap;
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
    channel_enqueue(ch, value);
    WakeConditionVariable(&ch->not_empty);
    LeaveCriticalSection(&ch->lock);
#else
    pthread_mutex_lock(&ch->lock);
    if (ch->closed) {
        pthread_mutex_unlock(&ch->lock);
        return -1;
    }
    channel_enqueue(ch, value);
    pthread_cond_signal(&ch->not_empty);
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

/* ── Process / Spawn ─────────────────────────────────────────────────────── */

typedef void (*nova_spawn_entry)(void*);

typedef struct {
    nova_spawn_entry fn;
    void*    ctx;
    int64_t* monitors;
    int64_t  monitor_count;
    int64_t  monitor_cap;
    int64_t  finished;
    int64_t  exit_status;
#ifdef _WIN32
    HANDLE thread_handle;
    CRITICAL_SECTION lock;
#else
    pthread_t thread;
    pthread_mutex_t lock;
#endif
} NovaProcessInfo;

#define MAX_PROCESSES 4096
static NovaProcessInfo* nova_processes[MAX_PROCESSES];
static int64_t nova_process_count = 0;

#ifdef _WIN32
static CRITICAL_SECTION nova_proc_registry_lock;
static int nova_proc_registry_init = 0;

static void ensure_registry_init(void) {
    if (!nova_proc_registry_init) {
        InitializeCriticalSection(&nova_proc_registry_lock);
        nova_proc_registry_init = 1;
    }
}
#else
static pthread_mutex_t nova_proc_registry_lock = PTHREAD_MUTEX_INITIALIZER;
static void ensure_registry_init(void) {}
#endif

#ifdef _WIN32
static DWORD WINAPI nova_thread_start(LPVOID param) {
    NovaProcessInfo* proc = (NovaProcessInfo*)param;
    proc->fn(proc->ctx);

    EnterCriticalSection(&proc->lock);
    proc->exit_status = 0;
    for (int64_t i = 0; i < proc->monitor_count; i++)
        nova_rt_channel_send(proc->monitors[i], proc->exit_status);
    proc->finished = 1;
    LeaveCriticalSection(&proc->lock);
    return 0;
}
#else
static void* nova_thread_start(void* param) {
    NovaProcessInfo* proc = (NovaProcessInfo*)param;
    proc->fn(proc->ctx);

    pthread_mutex_lock(&proc->lock);
    proc->exit_status = 0;
    for (int64_t i = 0; i < proc->monitor_count; i++)
        nova_rt_channel_send(proc->monitors[i], proc->exit_status);
    proc->finished = 1;
    pthread_mutex_unlock(&proc->lock);
    return NULL;
}
#endif

int64_t nova_rt_spawn(int64_t fn_ptr, int64_t ctx_ptr) {
    ensure_registry_init();

    NovaProcessInfo* proc = malloc(sizeof(NovaProcessInfo));
    proc->fn = (nova_spawn_entry)(uintptr_t)fn_ptr;
    proc->ctx = (void*)(uintptr_t)ctx_ptr;
    proc->monitors = NULL;
    proc->monitor_count = 0;
    proc->monitor_cap = 0;
    proc->finished = 0;
    proc->exit_status = 0;

#ifdef _WIN32
    InitializeCriticalSection(&proc->lock);
    proc->thread_handle = CreateThread(NULL, 0, nova_thread_start, proc, 0, NULL);

    EnterCriticalSection(&nova_proc_registry_lock);
    if (nova_process_count < MAX_PROCESSES)
        nova_processes[nova_process_count++] = proc;
    LeaveCriticalSection(&nova_proc_registry_lock);

    return (int64_t)(uintptr_t)proc;
#else
    pthread_mutex_init(&proc->lock, NULL);
    pthread_create(&proc->thread, NULL, nova_thread_start, proc);

    pthread_mutex_lock(&nova_proc_registry_lock);
    if (nova_process_count < MAX_PROCESSES)
        nova_processes[nova_process_count++] = proc;
    pthread_mutex_unlock(&nova_proc_registry_lock);

    return (int64_t)(uintptr_t)proc;
#endif
}

/* Monitor: returns a channel that receives the exit status when the process
   finishes. If the process has already finished, the channel immediately
   receives the exit status. */
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
        proc->monitors = realloc(proc->monitors, (size_t)proc->monitor_cap * sizeof(int64_t));
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
        proc->monitors = realloc(proc->monitors, (size_t)proc->monitor_cap * sizeof(int64_t));
    }
    proc->monitors[proc->monitor_count++] = ch;
    pthread_mutex_unlock(&proc->lock);
#endif
    return ch;
}

void nova_rt_wait_all(void) {
    for (int64_t i = 0; i < nova_process_count; i++) {
        NovaProcessInfo* proc = nova_processes[i];
#ifdef _WIN32
        WaitForSingleObject(proc->thread_handle, INFINITE);
        CloseHandle(proc->thread_handle);
        DeleteCriticalSection(&proc->lock);
#else
        pthread_join(proc->thread, NULL);
        pthread_mutex_destroy(&proc->lock);
#endif
        if (proc->monitors) free(proc->monitors);
        free(proc);
    }
    nova_process_count = 0;
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

/* ── Memory Cleanup ─────────────────────────────────────────────────────── */

int64_t nova_rt_alloc_count(void) {
    return nova_mem_count;
}

void nova_rt_cleanup(void) {
    for (int64_t i = nova_mem_count - 1; i >= 0; i--) {
        void* p = nova_mem_registry[i].ptr;
        if (!p) continue;
        switch (nova_mem_registry[i].tag) {
            case NOVA_MEM_LIST: {
                NovaList* l = (NovaList*)p;
                if (l->data) free(l->data);
                free(l);
                break;
            }
            case NOVA_MEM_DICT: {
                NovaDict* d = (NovaDict*)p;
                if (d->keys) free(d->keys);
                if (d->vals) free(d->vals);
                free(d);
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
            default:
                free(p);
                break;
        }
    }
    free(nova_mem_registry);
    nova_mem_registry = NULL;
    nova_mem_count = 0;
    nova_mem_cap = 0;
}