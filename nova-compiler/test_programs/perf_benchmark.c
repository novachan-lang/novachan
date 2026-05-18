#include <stdio.h>
#include <stdint.h>
#include <time.h>
#ifdef _WIN32
#include <windows.h>
#endif

static int64_t clock_ns_val(void) {
#ifdef _WIN32
    LARGE_INTEGER freq, count;
    QueryPerformanceFrequency(&freq);
    QueryPerformanceCounter(&count);
    return (int64_t)((double)count.QuadPart / freq.QuadPart * 1000000000.0);
#else
    struct timespec ts;
    clock_gettime(CLOCK_MONOTONIC, &ts);
    return (int64_t)ts.tv_sec * 1000000000LL + ts.tv_nsec;
#endif
}

static int64_t fib(int64_t n) {
    if (n <= 1) return n;
    return fib(n - 1) + fib(n - 2);
}

static int64_t sum_loop(int64_t n) {
    int64_t total = 0;
    for (int64_t i = 0; i < n; i++) {
        total += i;
    }
    return total;
}

static int64_t count_primes(int64_t limit) {
    int64_t count = 0;
    for (int64_t n = 2; n < limit; n++) {
        int is_prime = 1;
        for (int64_t d = 2; d * d <= n; d++) {
            if (n % d == 0) { is_prime = 0; break; }
        }
        if (is_prime) count++;
    }
    return count;
}

int main(void) {
    int64_t t0 = clock_ns_val();
    int64_t r1 = fib(38);
    int64_t t1 = clock_ns_val();
    int64_t r2 = sum_loop(100000000);
    int64_t t2 = clock_ns_val();
    int64_t r3 = count_primes(100000);
    int64_t t3 = clock_ns_val();

    printf("fib(38)       = %lld  (%lld ms)\n", (long long)r1, (long long)((t1-t0)/1000000));
    printf("sum(100M)     = %lld  (%lld ms)\n", (long long)r2, (long long)((t2-t1)/1000000));
    printf("primes(100K)  = %lld  (%lld ms)\n", (long long)r3, (long long)((t3-t2)/1000000));
    printf("TOTAL         = %lld ms\n", (long long)((t3-t0)/1000000));
    return 0;
}
