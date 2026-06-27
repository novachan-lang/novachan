/* Minimal NOVA wasm runtime: enough for string LITERALS and string BUILDING (concat) in wasm. Self-
   consistent layout (the compiler only CALLS these fns with opaque handles, so we choose the layout):
     - a heap string is [i64 len][bytes...\0]; its HANDLE points at the bytes; len is at handle-8.
     - a string LITERAL is a bare char* in the wasm data segment (outside our bump heap).
   len_any distinguishes them by whether the handle is inside the bump heap. Build with -fno-builtin so
   clang doesn't rewrite the strlen loop into an (undefined) libc strlen import. Heap exhaustion returns "";
   a real port uses nova_runtime.c's NOVA_FREESTANDING allocator + the full value model (find_tag/RC). */
typedef long long i64;
typedef unsigned long usz;            /* 32-bit in wasm32 */

static unsigned char nv_heap[1 << 20];
static usz nv_off = 0, nv_base = 0, nv_top = 0;

static void* nv_alloc(usz n) {
    if (nv_base == 0) nv_base = (usz)&nv_heap[0];
    n = (n + 7u) & ~7u;
    if (nv_off + n > sizeof(nv_heap)) return 0;
    void* p = &nv_heap[nv_off];
    nv_off += n;
    nv_top = (usz)&nv_heap[nv_off];
    return p;
}
static usz nv_strlen(const char* s) { usz n = 0; while (s[n]) n++; return n; }
static int nv_in_heap(i64 h) { usz a = (usz)h; return a >= nv_base && a < nv_top; }

i64 nova_rt_len_any(i64 h) {
    if (!h) return 0;
    if (nv_in_heap(h)) return *(i64*)((usz)h - 8);       /* heap string: length header */
    return (i64)nv_strlen((const char*)(usz)h);          /* literal: measure in place */
}
i64 nova_rt_len(i64 h) { return nova_rt_len_any(h); }

i64 nova_rt_create_string(void* cstr) {
    const char* s = (const char*)cstr;
    usz n = nv_strlen(s);
    char* m = (char*)nv_alloc(8 + n + 1);
    if (!m) return (i64)(usz)"";
    *(i64*)m = (i64)n;
    char* d = m + 8;
    for (usz i = 0; i <= n; i++) d[i] = s[i];
    return (i64)(usz)d;
}

i64 nova_rt_str_concat(i64 a, i64 b) {
    i64 la = nova_rt_len_any(a), lb = nova_rt_len_any(b);
    usz tot = (usz)(la + lb);
    char* m = (char*)nv_alloc(8 + tot + 1);
    if (!m) return (i64)(usz)"";
    *(i64*)m = la + lb;
    char* d = m + 8;
    const char* sa = (const char*)(usz)a;
    const char* sb = (const char*)(usz)b;
    for (usz i = 0; i < (usz)la; i++) d[i] = sa[i];
    for (usz i = 0; i < (usz)lb; i++) d[la + i] = sb[i];
    d[tot] = '\0';
    return (i64)(usz)d;
}

/* NovaList = { i64 data; i64 size; i64 cap }; the compiler reads list size INLINE at handle+8 (so the
   fields are i64-wide). Fixed cap (no grow) is enough for demo lists; the real port uses nova_runtime.c's
   growable NovaList + find_tag tag-disambiguation (so len_any/index_get work on lists too). */
i64 nova_rt_list_create(void) {
    i64* s = (i64*)nv_alloc(24);
    i64* buf = (i64*)nv_alloc(8 * 8);
    if (!s || !buf) return 0;
    s[0] = (i64)(usz)buf; s[1] = 0; s[2] = 8;
    return (i64)(usz)s;
}
i64 nova_rt_list_append(i64 h, i64 e) {
    if (!h) return h;
    i64* s = (i64*)(usz)h;
    if (s[1] >= s[2]) {                  /* GROW: double the buffer (bump-copy; old buffer leaks in the bump heap) */
        i64 ncap = s[2] * 2;
        i64* nb = (i64*)nv_alloc(8 * (usz)ncap);
        if (!nb) return h;
        i64* ob = (i64*)(usz)s[0];
        for (i64 i = 0; i < s[1]; i++) nb[i] = ob[i];
        s[0] = (i64)(usz)nb; s[2] = ncap;
    }
    ((i64*)(usz)s[0])[s[1]] = e; s[1]++;
    return h;
}
/* The compiler emits the no-RC append variant inside loops (no refcount bump). With no RC in the minimal
   runtime it is just append. (Without this it would be an undefined import -> dummy no-op -> empty list.) */
i64 nova_rt_list_append_no_rc(i64 h, i64 e) { return nova_rt_list_append(h, e); }
i64 nova_rt_list_get(i64 h, i64 i) {
    if (!h) return 0;
    i64* s = (i64*)(usz)h;
    if (i < 0 || i >= s[1]) return 0;
    return ((i64*)(usz)s[0])[i];
}
i64 nova_rt_list_free_local(i64 h) { (void)h; return 0; }   /* bump heap -> no-op */

/* Minimal dynamic add: raw-int addition (the demo's list/dict values are ints). The real nova_rt_add
   discriminates int/float/string via find_tag. */
i64 nova_rt_add(i64 a, i64 b) { return a + b; }

/* String-key equality (handles literal or heap keys via len_any, same as the string runtime). */
static int nv_streq(i64 a, i64 b) {
    i64 la = nova_rt_len_any(a), lb = nova_rt_len_any(b);
    if (la != lb) return 0;
    const char* sa = (const char*)(usz)a;
    const char* sb = (const char*)(usz)b;
    for (i64 i = 0; i < la; i++) if (sa[i] != sb[i]) return 0;
    return 1;
}
/* NovaDict (minimal): {i64 pairs; i64 count; i64 cap}; pairs -> [key0,val0,key1,val1,...]. Linear scan.
   Opaque to the compiler (it only CALLS create/set/get), so the layout is ours. A real port uses the hashed
   NovaDict + find_tag (so len_any/keys/values work on a dict value too). */
i64 nova_rt_dict_create(void) {
    i64* s = (i64*)nv_alloc(24);
    i64* p = (i64*)nv_alloc(8 * 2 * 64);
    if (!s || !p) return 0;
    s[0] = (i64)(usz)p; s[1] = 0; s[2] = 64;
    return (i64)(usz)s;
}
i64 nova_rt_dict_set(i64 h, i64 key, i64 val) {
    if (!h) return h;
    i64* s = (i64*)(usz)h; i64* p = (i64*)(usz)s[0]; i64 n = s[1];
    for (i64 i = 0; i < n; i++) if (nv_streq(p[2*i], key)) { p[2*i+1] = val; return h; }
    if (n < s[2]) { p[2*n] = key; p[2*n+1] = val; s[1] = n + 1; }
    return h;
}
i64 nova_rt_dict_get(i64 h, i64 key) {
    if (!h) return 0;
    i64* s = (i64*)(usz)h; i64* p = (i64*)(usz)s[0]; i64 n = s[1];
    for (i64 i = 0; i < n; i++) if (nv_streq(p[2*i], key)) return p[2*i+1];
    return 0;
}
i64 nova_rt_dict_free_local(i64 h) { (void)h; return 0; }
