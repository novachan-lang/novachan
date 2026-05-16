/* C sequential prime count 1-1M. Fair baseline: same algorithm, no threads. */
#include <stdio.h>
#include <stdint.h>

static int is_prime(int64_t n) {
    if (n < 2) return 0;
    if (n == 2) return 1;
    if (n % 2 == 0) return 0;
    for (int64_t d = 3; d * d <= n; d += 2)
        if (n % d == 0) return 0;
    return 1;
}

int main(void) {
    int64_t count = 0;
    for (int64_t n = 2; n <= 1000000; n++)
        if (is_prime(n)) count++;
    printf("Primes 1-1000000 (C seq): %lld\n", (long long)count);
    return 0;
}
