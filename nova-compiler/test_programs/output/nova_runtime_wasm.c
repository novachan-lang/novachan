/* WASM value-model translation unit (NOVA #27 carve, S1 scaffold).
   Compiles the NOVA runtime's HEAP VALUE-MODEL (strings/lists/dicts/structs + RC + find_tag + arena) to
   wasm32 by #define NOVA_FREESTANDING -- which gates out the system headers and (incrementally, S2+) the
   I/O/socket/thread/scheduler sections inside nova_runtime.c -- plus tiny freestanding libc primitives below
   (there is no wasi-sysroot offline). The NATIVE build NEVER compiles this file: nova_runtime.c is compiled
   directly with NOVA_FREESTANDING absent, so it is unaffected.
   Build: clang --target=wasm32 -ffreestanding -nostdlib -fno-builtin -O2 -c nova_runtime_wasm.c -o _wasm_vm.o
   (-fno-builtin is MANDATORY: -O2 loop-idiom otherwise re-emits a libc strlen/memcpy import that traps in V8.) */
#define NOVA_FREESTANDING 1

#include <stdint.h>
#include <stddef.h>

/* --- tiny freestanding libc (no sysroot). clang lowers struct copies + aggregate initializers to memcpy/
   memset, so those MUST exist as REAL symbols (not just inline). Provided non-static so the whole TU + the
   linked NOVA program can resolve them. snprintf/malloc/etc. are handled in later carve steps. --- */
void* memcpy(void* d, const void* s, size_t n) {
    unsigned char* a = (unsigned char*)d; const unsigned char* b = (const unsigned char*)s;
    for (size_t i = 0; i < n; i++) a[i] = b[i];
    return d;
}
void* memmove(void* d, const void* s, size_t n) {
    unsigned char* a = (unsigned char*)d; const unsigned char* b = (const unsigned char*)s;
    if (a < b) { for (size_t i = 0; i < n; i++) a[i] = b[i]; }
    else       { for (size_t i = n; i > 0; i--) a[i-1] = b[i-1]; }
    return d;
}
void* memset(void* d, int v, size_t n) {
    unsigned char* a = (unsigned char*)d;
    for (size_t i = 0; i < n; i++) a[i] = (unsigned char)v;
    return d;
}
int memcmp(const void* x, const void* y, size_t n) {
    const unsigned char* a = (const unsigned char*)x; const unsigned char* b = (const unsigned char*)y;
    for (size_t i = 0; i < n; i++) { if (a[i] != b[i]) return (int)a[i] - (int)b[i]; }
    return 0;
}
size_t strlen(const char* s) { size_t n = 0; while (s[n]) n++; return n; }
int strcmp(const char* a, const char* b) { while (*a && *a == *b) { a++; b++; } return (int)(unsigned char)*a - (int)(unsigned char)*b; }
int strncmp(const char* a, const char* b, size_t n) {
    for (size_t i = 0; i < n; i++) { if (a[i] != b[i] || !a[i]) return (int)(unsigned char)a[i] - (int)(unsigned char)b[i]; }
    return 0;
}
char* strchr(const char* s, int c) { for (; *s; s++) { if (*s == (char)c) return (char*)s; } return c ? (char*)0 : (char*)s; }

#include "nova_runtime.c"
