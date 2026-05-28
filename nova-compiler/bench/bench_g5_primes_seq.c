#include <stdio.h>

int is_prime(int n) {
    if (n < 2) return 0;
    if (n == 2) return 1;
    if (n % 2 == 0) return 0;
    for (int d = 3; (long)d * d <= n; d += 2)
        if (n % d == 0) return 0;
    return 1;
}

int main() {
    int count = 0;
    for (int n = 2; n <= 1000000; n++)
        if (is_prime(n)) count++;
    printf("Primes 1-1000000 (seq): %d\n", count);
    return 0;
}
