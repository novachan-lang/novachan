#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <math.h>

/* NOVA @cdecl entry points. Each is declared with its TRUE C prototype -- 7.3 makes the
   emitted wrapper match these exactly, so a regression here is a real ABI break. */
extern int64_t my_compare__cdecl(int64_t a, int64_t b);
extern int64_t on_event__cdecl(int64_t code);
extern int32_t narrow_i32__cdecl(int32_t a, int32_t b);
extern uint8_t narrow_u8__cdecl(uint8_t x);
extern double  dmul__cdecl(double x, double k);
extern float   fhalf__cdecl(float x);

static int64_t vals[6] = {5, 3, 9, 1, 7, 2};
static int cmp_shim(const void* x, const void* y) {
    return (int)my_compare__cdecl(*(const int64_t*)x, *(const int64_t*)y);
}

static int failures = 0;
static void check(const char* what, long long got, long long want) {
    if (got == want) { printf("  ok   %s = %lld\n", what, got); }
    else { printf("  FAIL %s = %lld (want %lld)\n", what, got, want); failures++; }
}
static void checkd(const char* what, double got, double want) {
    if (fabs(got - want) < 1e-9) { printf("  ok   %s = %g\n", what, got); }
    else { printf("  FAIL %s = %g (want %g)\n", what, got, want); failures++; }
}

int main(void) {
    /* Deliberately call the NOVA callback with NO prior NOVA init — this is the case
       nova_rt_ensure_init() exists for. */
    printf("event(21) = %lld\n", (long long)on_event__cdecl(21));
    qsort(vals, 6, sizeof(int64_t), cmp_shim);
    printf("sorted:");
    for (int i = 0; i < 6; i++) printf(" %lld", (long long)vals[i]);
    printf("\n");

    printf("7.3 sized/float ABI:\n");
    /* Narrow SIGNED: -7 + 3 = -4. A wrong zext would make the first arg 4294967289. */
    check("narrow_i32(-7, 3)", (long long)narrow_i32__cdecl(-7, 3), -4);
    /* Narrow UNSIGNED: 200 must stay 200. A wrong sext would make it -56. */
    check("narrow_u8(200)", (long long)narrow_u8__cdecl((uint8_t)200), 200);
    /* Doubles travel in XMM registers — the old i64 wrapper read the wrong registers. */
    checkd("dmul(2.5, 4.0)", dmul__cdecl(2.5, 4.0), 10.0);
    checkd("dmul(-1.5, 3.0)", dmul__cdecl(-1.5, 3.0), -4.5);
    /* 32-bit float: fpext on the way in, fptrunc on the way out. */
    checkd("fhalf(3.0f)", (double)fhalf__cdecl(3.0f), 1.5);

    if (failures) { printf("CDECL ABI FAIL (%d)\n", failures); return 1; }
    printf("CDECL ABI OK\n");
    return 0;
}
