#include <stdio.h>
#include <stdint.h>

double integrate_sin(int64_t n) {
    double h = 3.14159265358979 / (double)n;
    double total = 0.0;
    for (int64_t i = 0; i < n; i++) {
        double x = (double)i * h;
        double sinX = x - x*x*x/6.0 + x*x*x*x*x/120.0;
        total += sinX * h;
    }
    return total;
}

int main(void) {
    printf("%f\n", integrate_sin(10000000));
    return 0;
}
