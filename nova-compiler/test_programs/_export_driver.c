/* #25: a pure-C host calling NOVA functions exported via @export. */
#include <stdio.h>
#include <stdint.h>
extern void nova_rt_init(void);
extern int64_t novalib_add(int64_t, int64_t);
extern int64_t novalib_mul(int64_t, int64_t);
extern int64_t novalib_fib(int64_t);
int main(void) {
    nova_rt_init();
    int64_t r = novalib_add(3, 4) + novalib_mul(5, 6) + novalib_fib(10);
    printf("C host -> NOVA @export: add(3,4)+mul(5,6)+fib(10) = %lld\n", (long long)r);
    return (r == (7 + 30 + 55)) ? 0 : 1;   /* expect 92 */
}
