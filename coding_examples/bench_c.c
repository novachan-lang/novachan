#include <stdio.h>
#include <stdlib.h>
#include <time.h>

// Fibonacci (recursive) — pure compute benchmark
int fib(int n) {
    if (n <= 1) return n;
    return fib(n - 1) + fib(n - 2);
}

// Prime sieve — memory + branching benchmark
int count_primes(int limit) {
    int count = 0;
    for (int n = 2; n <= limit; n++) {
        int is_p = 1;
        for (int d = 2; d * d <= n; d++) {
            if (n % d == 0) { is_p = 0; break; }
        }
        if (is_p) count++;
    }
    return count;
}

// Sum of squares — tight loop benchmark
long long sum_squares(int n) {
    long long sum = 0;
    for (int i = 0; i < n; i++) {
        sum += (long long)i * i;
    }
    return sum;
}

int main() {
    clock_t t1, t2;

    // Benchmark 1: fib(40)
    t1 = clock();
    int f = fib(40);
    t2 = clock();
    double fib_ms = (double)(t2 - t1) / CLOCKS_PER_SEC * 1000.0;
    printf("fib(40) = %d  [%.0fms]\n", f, fib_ms);

    // Benchmark 2: count primes up to 100000
    t1 = clock();
    int p = count_primes(100000);
    t2 = clock();
    double prime_ms = (double)(t2 - t1) / CLOCKS_PER_SEC * 1000.0;
    printf("primes <= 100000: %d  [%.0fms]\n", p, prime_ms);

    // Benchmark 3: sum of squares 0..10M
    t1 = clock();
    long long s = sum_squares(10000000);
    t2 = clock();
    double sum_ms = (double)(t2 - t1) / CLOCKS_PER_SEC * 1000.0;
    printf("sum_squares(10M) = %lld  [%.0fms]\n", s, sum_ms);

    return 0;
}
