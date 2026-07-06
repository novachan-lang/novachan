/* CORE_GAP 0.1 runtime unit repro: self-assign use-after-free in nova_rt_list_set.
 * A struct element is calloc-backed (ASAN-instrumented, unlike slab-allocated small lists/dicts) and
 * held uniquely (rc==1) by the list slot. `list[0] = list[0]` runs dec-before-inc: the dec frees the
 * struct, the store writes the freed pointer back, and reading it afterward is a heap-use-after-free.
 * ASAN detects it deterministically. After the fix (inc-before-dec) the struct is never freed. */
#include <stdint.h>
#include <stdio.h>

extern void*   nova_rt_struct_alloc(int64_t size);
extern int64_t nova_rt_list_create(void);
extern int64_t nova_rt_list_append(int64_t, int64_t);
extern int64_t nova_rt_list_set(int64_t, int64_t, int64_t);
extern int64_t nova_rt_list_get(int64_t, int64_t);
extern void    nova_rc_inc(int64_t);
extern void    nova_rc_dec(int64_t);

int main(void) {
    int64_t s   = (int64_t)(uintptr_t)nova_rt_struct_alloc(16); /* calloc-backed, rc = 1 */
    int64_t lst = nova_rt_list_create();
    nova_rt_list_append(lst, s);   /* append INCs s -> rc = 2 */
    nova_rc_dec(s);                /* rc 2 -> 1: struct now uniquely held by lst[0] */

    /* self-assign: lst[0] = lst[0]  (list_get borrows -> value has the same rc-1 handle) */
    int64_t v = nova_rt_list_get(lst, 0);
    nova_rt_list_set(lst, 0, v);   /* BUG: nova_rc_dec(lst[0]) frees the struct, then stores it back */

    /* read the element back and touch its memory -> UAF read if it was freed */
    int64_t got = nova_rt_list_get(lst, 0);
    volatile int32_t hdr = ((int32_t*)(uintptr_t)got)[-1]; /* reads the (possibly-freed) rc header */
    printf("survived hdr=%d\n", (int)hdr);
    return 0;
}
