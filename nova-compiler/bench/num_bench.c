#include <stdio.h>
#include <stdint.h>

double integrateSin(int64_t n) {
    double h = 3.14159265358979 / n;
    double total = 0.0;
    int64_t i = 0;
    while (i < n) {
        double x = i * h;
        double sinX = x - x*x*x/6.0 + x*x*x*x*x/120.0;
        total += sinX * h;
        i += 1;
    }
    return total;
}

int main(void) {
    printf("%.15g\n", integrateSin(10000000));
    return 0;
}
