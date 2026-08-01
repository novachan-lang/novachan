#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
/* NOVA @cdecl entry points, emitted as i64 f(i64...) — C-callable directly. */
extern int64_t my_compare__cdecl(int64_t a, int64_t b);
extern int64_t on_event__cdecl(int64_t code);

static int64_t vals[6] = {5, 3, 9, 1, 7, 2};
static int cmp_shim(const void* x, const void* y) {
    return (int)my_compare__cdecl(*(const int64_t*)x, *(const int64_t*)y);
}
int main(void) {
    /* Deliberately call the NOVA callback with NO prior NOVA init — this is the case
       nova_rt_ensure_init() exists for. */
    printf("event(21) = %lld\n", (long long)on_event__cdecl(21));
    qsort(vals, 6, sizeof(int64_t), cmp_shim);
    printf("sorted:");
    for (int i = 0; i < 6; i++) printf(" %lld", (long long)vals[i]);
    printf("\n");
    return 0;
}
