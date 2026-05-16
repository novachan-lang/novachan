#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>

int64_t count_primes(int64_t limit) {
    char* sieve = (char*)calloc(limit + 1, 1);
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
