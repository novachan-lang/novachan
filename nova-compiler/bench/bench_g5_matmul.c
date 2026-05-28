#include <stdio.h>
#include <stdlib.h>

int main() {
    int n = 300;
    long* a = malloc(n * n * sizeof(long));
    long* b = malloc(n * n * sizeof(long));
    long* c = calloc(n * n, sizeof(long));
    for (int i = 0; i < n*n; i++) { a[i] = 1 + i % 7; b[i] = 2 + i % 7; }
    for (int i = 0; i < n; i++)
        for (int j = 0; j < n; j++) {
            long s = 0;
            for (int k = 0; k < n; k++)
                s += a[i*n+k] * b[k*n+j];
            c[i*n+j] = s;
        }
    long total = 0;
    for (int i = 0; i < n*n; i++) total += c[i];
    printf("Matmul 300x300 checksum: %ld\n", total);
    free(a); free(b); free(c);
    return 0;
}
