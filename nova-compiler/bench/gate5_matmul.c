#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>

int main(void) {
    int n = 300;
    int64_t total_cells = (int64_t)n * n;
    int64_t* a = malloc(total_cells * sizeof(int64_t));
    int64_t* b = malloc(total_cells * sizeof(int64_t));
    int64_t* c = calloc(total_cells, sizeof(int64_t));

    for (int64_t i = 0; i < total_cells; i++) {
        a[i] = 1 + i % 7;
        b[i] = 2 + i % 7;
    }

    for (int i = 0; i < n; i++) {
        for (int j = 0; j < n; j++) {
            int64_t s = 0;
            for (int k = 0; k < n; k++) {
                s += a[i*n+k] * b[k*n+j];
            }
            c[i*n+j] = s;
        }
    }

    int64_t sum = 0;
    for (int64_t i = 0; i < total_cells; i++) sum += c[i];
    printf("Matmul 300x300 checksum: %lld\n", (long long)sum);

    free(a); free(b); free(c);
    return 0;
}
