#include <stdio.h>

typedef struct { double x, y, z; } V;

__attribute__((noinline))
double dot(V a, V b) {
    return a.x * b.x + a.y * b.y + a.z * b.z;
}

int main(void) {
    V a = {1.5, 2.5, 3.5};
    V b = {0.5, 1.5, 2.5};
    double s = 0.0;
    for (int i = 0; i < 200000000; i++) {
        s += dot(a, b);
    }
    printf("%.1f\n", s);
    return 0;
}
