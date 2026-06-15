/* _arena_harness.c — iter-90 validation of the transparent per-request arena.
   Exercises nova_heap_alloc redirection + ARENA_BIT (rc no-op) + wholesale free.
   STRUCTs are self-contained (no side malloc) so the foundation alone makes them
   fully arena-safe. The key claim under test: a reference CYCLE (which RC can NEVER
   collect) is reclaimed with the arena, with NO use-after-free / double-free, and
   live_count stays flat. Run under ASAN to catch any UAF/double-free on the
   wholesale free. Links against nova_runtime.c (which has no main of its own). */
#include <stdio.h>
#include <stdint.h>

extern int64_t nova_rt_arena_scope_enter(void);
extern void    nova_rt_arena_scope_exit(int64_t prev);
extern void*   nova_rt_struct_alloc(int64_t size);
extern int64_t nova_rt_live_count(void);

int main(void) {
    /* Warm the allocator OUTSIDE any scope so lazy init doesn't skew the baseline. */
    void* warm = nova_rt_struct_alloc(16);
    if (((int64_t*)warm)[1] == -999) return 7; /* touch to defeat DCE */

    int64_t base = nova_rt_live_count();

    /* ---- Scenario 1: many structs spanning multiple arena chunks + a cycle ---- */
    int64_t prev = nova_rt_arena_scope_enter();
    for (int i = 0; i < 100000; i++) {
        void* s = nova_rt_struct_alloc(32);      /* 4 slots */
        ((int64_t*)s)[1] = i;                    /* slot 1 = field */
    }
    /* A reference CYCLE: a<->b. RC could never free this; the arena must. */
    void* a = nova_rt_struct_alloc(16);          /* 2 slots */
    void* b = nova_rt_struct_alloc(16);
    ((int64_t*)a)[1] = (int64_t)(uintptr_t)b;
    ((int64_t*)b)[1] = (int64_t)(uintptr_t)a;
    nova_rt_arena_scope_exit(prev);              /* wholesale free incl the cycle */

    int64_t mid = nova_rt_live_count();
    int64_t d1 = mid - base;

    /* ---- Scenario 2: nested scopes restore correctly + inner cycle freed ---- */
    int64_t p_outer = nova_rt_arena_scope_enter();
    void* outer = nova_rt_struct_alloc(24);
    int64_t p_inner = nova_rt_arena_scope_enter();
    void* in1 = nova_rt_struct_alloc(16);
    void* in2 = nova_rt_struct_alloc(16);
    ((int64_t*)in1)[1] = (int64_t)(uintptr_t)in2;
    ((int64_t*)in2)[1] = (int64_t)(uintptr_t)in1;   /* inner cycle */
    nova_rt_arena_scope_exit(p_inner);              /* free inner only */
    /* outer scope still active: allocate more to prove the enclosing arena survived */
    void* outer2 = nova_rt_struct_alloc(16);
    ((int64_t*)outer)[1] = (int64_t)(uintptr_t)outer2;
    nova_rt_arena_scope_exit(p_outer);              /* free outer */

    int64_t after = nova_rt_live_count();
    int64_t d2 = after - mid;

    printf("ARENA probe: base=%lld mid=%lld after=%lld  d1=%lld d2=%lld\n",
           (long long)base, (long long)mid, (long long)after,
           (long long)d1, (long long)d2);
    if (d1 != 0 || d2 != 0) {
        printf("ARENA FAIL: live_count not flat across arena scopes (d1=%lld d2=%lld)\n",
               (long long)d1, (long long)d2);
        return 1;
    }
    printf("ARENA PASS: 100002 + nested structs incl 2 cycles freed wholesale; live_count flat (run under sanitizer to catch dangling reuse)\n");
    return 0;
}
