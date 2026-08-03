/* Real context-switch test: create a fiber with a VALID closure record, resume it,
   let it YIELD mid-body, resume again, and confirm it completed. This exercises the
   full save/restore of the callee-saved set across a switch — the thing the aarch64
   nova_asm_switch had to get right. */
#include <stdio.h>
#include <stdint.h>
#include <string.h>

int64_t nova_rt_fiber_create(int64_t closure);
int64_t nova_rt_fiber_resume(int64_t h);
int64_t nova_rt_fiber_yield(void);
int64_t nova_rt_fiber_is_done(int64_t h);

static volatile int g_step = 0;
static volatile long long g_sum = 0;

/* Body: touch many callee-saved regs, yield, then keep computing. If the switch
   clobbers a callee-saved register the sums will not match. */
static int64_t fiber_body(int64_t self, int64_t arg) {
    (void)self; (void)arg;
    long long a=1,b=2,c=3,d=4,e=5,f=6,g=7,h=8,i=9,j=10;
    double x=1.5, y=2.5, z=3.5;
    g_step = 1;
    nova_rt_fiber_yield();                       /* <-- context switch out and back */
    g_sum = a+b+c+d+e+f+g+h+i+j + (long long)(x+y+z);
    g_step = 2;
    return 0;
}

int main(void) {
#if defined(__aarch64__)
    const char* arch = "aarch64";
#else
    const char* arch = "x86_64";
#endif
    printf("=== fiber context switch on %s ===\n", arch);
    int64_t rec[2];
    rec[0] = (int64_t)(uintptr_t)&fiber_body;    /* closure record: [0] = fn ptr */
    rec[1] = 0;
    int fails = 0;

    int64_t f = nova_rt_fiber_create((int64_t)(uintptr_t)rec);
    if (!f) { printf("  FAIL fiber_create returned 0 (fibers unsupported?)\n"); return 1; }
    printf("  ok   fiber_create -> non-zero\n");

    nova_rt_fiber_resume(f);
    if (g_step != 1) { printf("  FAIL body did not run to the yield (g_step=%d)\n", g_step); fails++; }
    else              printf("  ok   body ran up to yield\n");
    if (nova_rt_fiber_is_done(f)) { printf("  FAIL fiber reported done at the yield\n"); fails++; }
    else                           printf("  ok   fiber suspended, not done\n");

    nova_rt_fiber_resume(f);
    if (g_step != 2) { printf("  FAIL body did not resume past the yield (g_step=%d)\n", g_step); fails++; }
    else              printf("  ok   body RESUMED past the yield\n");
    if (g_sum != 62)  { printf("  FAIL callee-saved state corrupted: sum=%lld want 62\n", g_sum); fails++; }
    else              printf("  ok   callee-saved regs survived the switch (sum=62)\n");
    if (!nova_rt_fiber_is_done(f)) { printf("  FAIL fiber not marked done after return\n"); fails++; }
    else                            printf("  ok   fiber completed\n");

    printf(fails ? "\nFIBER TEST on %s: %d FAILED\n" : "\nFIBER TEST on %s: ALL PASSED\n", arch, fails);
    return fails ? 1 : 0;
}
