#include <stdio.h>
#include <stdint.h>
int main() {
    int64_t arr[10] = {1,2,3,4,5,6,7,8,9,10};
    int64_t total = 0;
    for (int64_t i = 0; i < 10000000; i++) {
        total += arr[i % 10];
    }
    printf("%lld\n", total);
    return 0;
}
