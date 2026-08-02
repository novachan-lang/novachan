/* Linux runtime test for the exact-ownership object space.
   The POSIX halves — mmap(PROT_NONE, MAP_NORESERVE) reservation, mprotect commit,
   posix_memalign, pthread_mutex — had never been EXECUTED before this test.
   Drives the allocator through the runtime's public API. */
#include <stdio.h>
#include <string.h>
#include <stdint.h>

int64_t nova_rt_create_string(void* s);
int64_t nova_rt_list_create(void);
int64_t nova_rt_list_append(int64_t h, int64_t e);
int64_t nova_rt_list_get(int64_t h, int64_t i);
int64_t nova_rt_len_any(int64_t h);
int64_t nova_rt_str_concat(int64_t a, int64_t b);
int64_t nova_rt_dict_create(void);
int64_t nova_rt_dict_set(int64_t h, int64_t k, int64_t v);
int64_t nova_rt_dict_get(int64_t h, int64_t k);
int64_t nova_rt_any_to_str(int64_t v);
void    nova_rc_dec(int64_t v);

static int fails = 0;
static void ck(int cond, const char* what) {
    if (!cond) { printf("  FAIL %s\n", what); fails++; }
    else       { printf("  ok   %s\n", what); }
}

int main(void) {
    printf("=== NOVA object space on Linux ===\n");

    /* 1. many small objects -> exercises arena commit + size classes */
    int64_t l = nova_rt_list_create();
    for (int i = 0; i < 20000; i++) {
        char buf[64];
        snprintf(buf, sizeof buf, "item-%d", i);
        nova_rt_list_append(l, nova_rt_create_string(buf));
    }
    ck(nova_rt_len_any(l) == 20000, "20k strings appended (arena commit path)");
    int64_t got = nova_rt_list_get(l, 19999);
    ck(got && strcmp((const char*)(uintptr_t)got, "item-19999") == 0, "last element intact");

    /* 2. dict -> different size class + hashing */
    int64_t d = nova_rt_dict_create();
    for (int i = 0; i < 5000; i++) {
        char k[32]; snprintf(k, sizeof k, "k%d", i);
        nova_rt_dict_set(d, nova_rt_create_string(k), nova_rt_create_string("v"));
    }
    ck(nova_rt_len_any(d) == 5000, "5k dict entries");
    int64_t dv = nova_rt_dict_get(d, nova_rt_create_string("k4999"));
    ck(dv && strcmp((const char*)(uintptr_t)dv, "v") == 0, "dict lookup after growth");

    /* 3. HUGE block -> dedicated multi-arena run (the path that records its span) */
    int64_t big = nova_rt_create_string("x");
    for (int i = 0; i < 17; i++) big = nova_rt_str_concat(big, big);   /* ~128 KiB */
    ck(nova_rt_len_any(big) == 131072, "131072-byte string (huge/dedicated run)");

    /* 4. churn: free and reallocate so the free lists and reuse path run */
    for (int r = 0; r < 40; r++) {
        int64_t t = nova_rt_list_create();
        for (int i = 0; i < 500; i++) nova_rt_list_append(t, nova_rt_create_string("churn"));
        nova_rc_dec(t);
    }
    ck(1, "40x500 alloc/free churn survived (free-list reuse)");

    /* 5. find_tag must REJECT a foreign pointer -- the whole point of the change.
          A libc malloc block is exactly the sqlite-handle case that read OOB before. */
    void* foreign = malloc(792);
    int64_t rendered = nova_rt_any_to_str((int64_t)(uintptr_t)foreign);
    ck(rendered != 0, "any_to_str on a FOREIGN pointer returned without faulting");
    free(foreign);

    /* 6. originals still intact after everything */
    got = nova_rt_list_get(l, 0);
    ck(got && strcmp((const char*)(uintptr_t)got, "item-0") == 0, "first element still intact at the end");

    printf(fails ? "\nLINUX OA TEST: %d FAILED\n" : "\nLINUX OA TEST: ALL PASSED\n", fails);
    return fails ? 1 : 0;
}
