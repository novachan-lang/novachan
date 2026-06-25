#include <stdio.h>
int main(){
    double xs[1000];
    for(int i=0;i<1000;i++) xs[i]=(double)i*0.5;
    double s=0.0;
    for(int r=0;r<1000000;r++)
        for(int j=0;j<1000;j++)
            s += xs[j];
    printf("%f\n", s);
    return 0;
}
