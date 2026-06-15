#include <stdio.h>
struct V { long x, y; };
int main(void){
    long s = 0;
    for(long i=0;i<20000000;i++){
        struct V v = { i, i + 1 };
        s += v.x + v.y;
    }
    printf("%ld\n", s);
    return 0;
}
