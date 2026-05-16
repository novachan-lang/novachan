#include <stdio.h>

double integrate_sin_approx(long n) {
    double h = 3.14159265358979 / n;
    double total = 0.0;
    long i = 0;
    while (i < n) {
        double x = i * h;
        double sin_x = x - x*x*x/6.0 + x*x*x*x*x/120.0;
        total += sin_x * h;
        i++;
    }
    return total;
}

int main() {
    printf("%f\n", integrate_sin_approx(10000000));
    return 0;
}
