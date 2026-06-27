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
