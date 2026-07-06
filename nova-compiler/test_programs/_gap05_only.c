#include <stdint.h>
#include <stdio.h>
#include "output/nova_runtime.c"
int main(void) {
    char* s = nova_strpool_alloc();
    nova_strpool_rc_dec(s);                 /* free (1->0) */
    int top0 = nova_strpool_top;
    for (int i = 0; i < NOVA_STRPOOL_COUNT + 100; i++) nova_strpool_rc_dec(s);  /* double-decs */
    printf("top_after_free=%d  top_now=%d  buffer_max=%d\n", top0, nova_strpool_top, NOVA_STRPOOL_COUNT-1);
    if (nova_strpool_top > NOVA_STRPOOL_COUNT - 1) { printf("0.5 OOB: top past buffer end\n"); return 1; }
    printf("0.5 OK\n"); return 0;
}
