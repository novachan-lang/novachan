#include <stdio.h>
#include <string.h>
#include <stdint.h>
extern int64_t nova_rt_null(void);
extern int64_t nova_rt_bool(int64_t v);
extern int64_t nova_rt_json_encode(int64_t val);
int main(void) {
    int64_t nb = nova_rt_null();
    int64_t tb = nova_rt_bool(1);
    int64_t fb = nova_rt_bool(0);
    /* singletons must be stable + distinct */
    if (nb == 0 || tb == 0 || fb == 0) { printf("ODDBALL_FAIL alloc nb=%lld tb=%lld fb=%lld\n",(long long)nb,(long long)tb,(long long)fb); return 1; }
    if (nova_rt_null() != nb || nova_rt_bool(1) != tb || nova_rt_bool(0) != fb) { printf("ODDBALL_FAIL not-singleton\n"); return 1; }
    if (nb == tb || nb == fb || tb == fb) { printf("ODDBALL_FAIL not-distinct\n"); return 1; }
    const char* n = (const char*)(uintptr_t)nova_rt_json_encode(nb);
    const char* t = (const char*)(uintptr_t)nova_rt_json_encode(tb);
    const char* f = (const char*)(uintptr_t)nova_rt_json_encode(fb);
    printf("encode null=[%s] true=[%s] false=[%s]\n", n?n:"(null)", t?t:"(null)", f?f:"(null)");
    int ok = n && t && f && !strcmp(n,"null") && !strcmp(t,"true") && !strcmp(f,"false");
    printf(ok ? "ODDBALL_OK\n" : "ODDBALL_FAIL encode\n");
    return ok ? 0 : 1;
}
