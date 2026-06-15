#include <stdio.h>
int main(void){
    double s = 0.0, x = 1.0;
    for(long i=0;i<200000000;i++){
        x = x * 1.0000000001 + 0.5;
        s = s + x * 2.0 - x;
    }
    printf("%g\n", s);
    return 0;
}
