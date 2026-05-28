#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <time.h>
int main() {
    int N = 300;
    long long *a = (long long*)calloc(N*N, sizeof(long long));
    long long *b = (long long*)calloc(N*N, sizeof(long long));
    long long *c = (long long*)calloc(N*N, sizeof(long long));
    for (int i = 0; i < N*N; i++) { a[i] = (i % 7) + 1; b[i] = (i % 7) + 2; }
    clock_t t0 = clock();
    for (int i = 0; i < N; i++)
        for (int j = 0; j < N; j++) {
            long long s = 0;
            for (int k = 0; k < N; k++) s += a[i*N+k] * b[k*N+j];
            c[i*N+j] = s;
        }
    clock_t t1 = clock();
    long long cksum = 0;
    for (int i = 0; i < N*N; i++) cksum += c[i];
    printf("C matmul checksum: %lld, time: %dms\n", cksum, (int)((t1-t0)*1000/CLOCKS_PER_SEC));
    free(a); free(b); free(c);
    return 0;
}
