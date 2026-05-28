#include <stdio.h>
#include <stdlib.h>

int main() {
    int limit = 10000000;
    char* sieve = calloc(limit + 1, 1);
    int count = 0;
    for (int i = 2; i <= limit; i++) {
        if (!sieve[i]) {
            count++;
            for (long j = (long)i * i; j <= limit; j += i)
                sieve[j] = 1;
        }
    }
    printf("Primes up to 10M: %d\n", count);
    free(sieve);
    return 0;
}
