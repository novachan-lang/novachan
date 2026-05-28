#include <stdio.h>
#include <stdint.h>
#include <string.h>

static const char* nova_intern(const char* s) { return s; }
static int nova_strpool_contains(const void* ptr) { return 0; }

int64_t nova_rt_bin(int64_t val) {
    char buf[68];
    if (val == 0) { buf[0] = '0'; buf[1] = 0; return (int64_t)(uintptr_t)nova_intern(buf); }
    int bpos = 0;
    int64_t v = val < 0 ? -val : val;
    char tmp[66];
    int ti = 0;
    while (v > 0) { tmp[ti++] = '0' + (int)(v & 1); v >>= 1; }
    if (val < 0) buf[bpos++] = '-';
    for (int j = ti - 1; j >= 0; j--) buf[bpos++] = tmp[j];
    buf[bpos] = 0;
    printf("bin(%lld) = '%s' (bpos=%d, ti=%d)\n", (long long)val, buf, bpos, ti);
    return (int64_t)(uintptr_t)buf;
}

int main() {
    nova_rt_bin(255);
    nova_rt_bin(42);
    nova_rt_bin(0);
    nova_rt_bin(1);
    return 0;
}
