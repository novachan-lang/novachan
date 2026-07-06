/* Runtime unit repros for CORE_GAP 0.4 (wild reads in list_len/dict_len) and 0.5 (strpool double-dec OOB).
 * Includes the runtime directly so the static-inline strpool functions are reachable.
 *   0.4: nova_rt_list_len/dict_len on a NULL handle must return 0, not dereference (NULL) -> ->size.
 *   0.5: decrementing an already-freed strpool slot must be a no-op, never re-pushing it and never
 *        driving nova_strpool_top past the end of nova_strpool_stack (an out-of-bounds global write). */
#include <stdint.h>
#include <stdio.h>
#include "output/nova_runtime.c"

int main(void) {
    int fails = 0;

    /* ---- 0.4: guarded length ---- */
    if (nova_rt_list_len(0) != 0) { printf("0.4 FAIL: list_len(NULL) != 0\n"); fails++; }
    if (nova_rt_dict_len(0) != 0) { printf("0.4 FAIL: dict_len(NULL) != 0\n"); fails++; }
    /* a genuine list still reports the right length (guard must not break correct code) */
    int64_t lst = nova_rt_list_create();
    nova_rt_list_append(lst, 42);
    nova_rt_list_append(lst, 43);
    if (nova_rt_list_len(lst) != 2) { printf("0.4 FAIL: real list_len wrong\n"); fails++; }

    /* ---- 0.5: strpool double-dec ---- */
    char* s = nova_strpool_alloc();       /* rc = 1 */
    nova_strpool_rc_dec(s);               /* 1 -> 0: frees, pushes once */
    int top_after_free = nova_strpool_top;
    /* Hammer with double-decs of the already-freed slot. Pre-fix each one re-pushes and drives top
       past NOVA_STRPOOL_COUNT-1 (out-of-bounds write into nova_strpool_stack). Post-fix: all no-ops. */
    for (int i = 0; i < NOVA_STRPOOL_COUNT + 100; i++) nova_strpool_rc_dec(s);
    if (nova_strpool_top != top_after_free) {
        printf("0.5 FAIL: strpool top moved on double-dec: %d -> %d (OOB)\n", top_after_free, nova_strpool_top);
        fails++;
    }
    if (nova_strpool_top > NOVA_STRPOOL_COUNT - 1) {
        printf("0.5 FAIL: strpool top past buffer end: %d\n", nova_strpool_top);
        fails++;
    }

    printf("REPRO %s\n", fails ? "FAIL" : "PASS");
    return fails ? 1 : 0;
}
