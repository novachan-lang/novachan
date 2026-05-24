#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include <math.h>

int64_t my_c_add(int64_t a, int64_t b) { return a + b; }
int64_t my_c_mul(int64_t a, int64_t b) { return a * b; }
int64_t my_c_factorial(int64_t n) {
    int64_t r = 1;
    for (int64_t i = 2; i <= n; i++) r *= i;
    return r;
}

double my_c_sqrt(double x) { return sqrt(x); }

int64_t my_c_strlen(const char* s) {
    return s ? (int64_t)strlen(s) : 0;
}

int64_t my_c_strchr_idx(const char* s, int64_t ch) {
    if (!s) return -1;
    const char* p = strchr(s, (int)ch);
    return p ? (int64_t)(p - s) : -1;
}

static int64_t g_log_calls = 0;
void my_c_log_msg(const char* s) {
    g_log_calls++;
    fprintf(stdout, "[c-log] %s\n", s ? s : "(null)");
    fflush(stdout);
}

int64_t my_c_count_calls(void) { return g_log_calls; }
