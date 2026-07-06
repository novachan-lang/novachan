#include <stdio.h>
#include <stdlib.h>
#include <time.h>
int main(void) {
    long n = 2000000;
    double *xs = malloc(n * sizeof(double));
    for (long i = 0; i < n; i++) xs[i] = (double)i * 1.5;
    int reps = 50;
    clock_t t0 = clock();
    double total = 0.0;
    for (int r = 0; r < reps; r++) {
        double s = 0.0;
        for (long j = 0; j < n; j++) s += xs[j];
        total += s;
    }
    clock_t t1 = clock();
    printf("C fa_sum elapsed_ms=%ld\n", (long)((t1 - t0) * 1000 / CLOCKS_PER_SEC));
    printf("%f\n", total);
    return 0;
}
