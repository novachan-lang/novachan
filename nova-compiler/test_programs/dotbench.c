#include <stdio.h>
typedef struct { double x, y, z; } V3;
double dot(V3 a, V3 b) { return a.x*b.x + a.y*b.y + a.z*b.z; }
int main(void){
    long n = 30000000; double acc = 0.0, t = 0.0;
    for (long i = 0; i < n; i++){
        V3 a = { t, t+1.0, t+2.0 }; V3 b = { 0.5, 0.25, 0.125 };
        acc += dot(a,b); t += 1.0;
    }
    printf("%f\n", acc); return 0;
}
