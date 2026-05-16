#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>

// Fair comparison: uses int64_t* like NOVA's list, not char*
int64_t count_primes(int64_t limit) {
    int64_t* sieve = (int64_t*)calloc(limit + 1, sizeof(int64_t));
    int64_t count = 0;
    for (int64_t i = 2; i <= limit; i++) {
        if (!sieve[i]) {
            count++;
            for (int64_t j = i * i; j <= limit; j += i)
                sieve[j] = 1;
        }
    }
    free(sieve);
    return count;
}

int main(void) {
    printf("%lld\n", count_primes(1000000));
    return 0;
}
