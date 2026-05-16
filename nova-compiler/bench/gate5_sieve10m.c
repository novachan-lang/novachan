#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>

int main(void) {
    int64_t limit = 10000000;
    int64_t* sieve = calloc(limit + 1, sizeof(int64_t));

    int64_t count = 0;
    for (int64_t i = 2; i <= limit; i++) {
        if (sieve[i] == 0) {
            count++;
            for (int64_t j = i * i; j <= limit; j += i) {
                sieve[j] = 1;
            }
        }
    }
    printf("Primes up to 10M: %lld\n", (long long)count);
    free(sieve);
    return 0;
}
