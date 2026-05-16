#include <stdio.h>
#include <stdint.h>

int64_t sum_to(int64_t n) {
    int64_t total = 0;
    int64_t i = 0;
    while (i <= n) {
        total = total + i;
        i = i + 1;
    }
    return total;
}

int main(void) {
    printf("%lld\n", sum_to(1000000000));
    return 0;
}
