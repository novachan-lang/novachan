/* C reference for _f31_scalar.nova — identical shape, same iteration count, same
   runtime-derived seed so neither side can constant-fold the loop away. */
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <sys/timeb.h>

static double axpy(double a, double x, double y) { return a * x + y; }

static long now_ms(void) {
    struct timeb tb;
    ftime(&tb);
    return (long)(tb.time * 1000 + tb.millitm);
}

int main(void) {
    long seed = now_ms() % 3 + 1;
    double a = 1.0000001 + (double)seed * 0.0000001;
    long n = 20000000;
    double acc = 0.0;
    long t0 = now_ms();
    for (long i = 0; i < n; i++) acc = axpy(a, acc, 0.5);
    long el = now_ms() - t0;
    printf("BENCH scalar_axpy elapsed_ms=%ld\n", el);
    printf("%f\n", acc);
    return 0;
}
