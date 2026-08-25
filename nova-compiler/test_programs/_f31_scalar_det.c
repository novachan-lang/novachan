#include <stdio.h>
#include <time.h>
static double axpy(double a, double x, double y) { return a * x + y; }
int main(void) {
    double a = 0.9999999;
    long n = 20000000;
    double acc = 0.0;
    clock_t t0 = clock();
    for (long i = 0; i < n; i++) acc = axpy(a, acc, 0.5);
    clock_t t1 = clock();
    printf("C scalar_axpy_det elapsed_ms=%ld\n", (long)((t1 - t0) * 1000 / CLOCKS_PER_SEC));
    printf("%.6f\n", acc);
    return 0;
}
