#include <stdio.h>
#include <time.h>
#include <stdint.h>

#ifdef _WIN32
#include <windows.h>
static int64_t clock_ns_c(void) {
    LARGE_INTEGER freq, cnt;
    QueryPerformanceFrequency(&freq);
    QueryPerformanceCounter(&cnt);
    return (int64_t)((double)cnt.QuadPart / freq.QuadPart * 1e9);
}
#else
static int64_t clock_ns_c(void) {
    struct timespec ts;
    clock_gettime(CLOCK_MONOTONIC, &ts);
    return (int64_t)ts.tv_sec * 1000000000LL + ts.tv_nsec;
}
#endif

int64_t sum_loop(int64_t n) {
    int64_t total = 0;
    for (int64_t i = 0; i < n; i++)
        total += i;
    return total;
}

int64_t count_primes(int64_t limit) {
    int64_t count = 0;
    for (int64_t n = 2; n < limit; n++) {
        int is_prime = 1;
        for (int64_t d = 2; d * d <= n; d++) {
            if (n % d == 0) { is_prime = 0; }
        }
        if (is_prime) count++;
    }
    return count;
}

int main() {
    int64_t t0 = clock_ns_c();
    int64_t r1 = sum_loop(10000000);
    int64_t t1 = clock_ns_c();
    int64_t r2 = count_primes(50000);
    int64_t t2 = clock_ns_c();
    printf("sum(10M)    = %lld in %lld ms\n", r1, (t1-t0)/1000000);
    printf("primes(50K) = %lld in %lld ms\n", r2, (t2-t1)/1000000);
    return 0;
}
