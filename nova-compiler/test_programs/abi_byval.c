/* C host for the LOCK-11 struct-by-value FFI gate. These take their structs BY VALUE,
   which is exactly what the NOVA declarations mirror. */
#include <stdint.h>
typedef struct { double x; double y; } Vec2;
typedef struct { int64_t a; int64_t b; } Pair;
typedef struct { double v; } One;
typedef struct { int64_t n; } OneI;

double  abi_vec2_sum(Vec2 v)   { return v.x + v.y; }
int64_t abi_pair_diff(Pair p)  { return p.a - p.b; }
double  abi_one_d(One o)       { return o.v * 2.0; }
int64_t abi_one_i(OneI o)      { return o.n + 1; }
int64_t abi_pair_and_scalar(Pair p, int64_t k) { return (p.a + p.b) * k; }

/* Larger-than-two-eightbyte structs: passed BY REFERENCE on Win64 and AAPCS64 (caller owns
   the copy) and on the STACK on SysV (`byval`). The mutating variant proves the callee
   cannot write through to NOVA's live heap object. */
typedef struct { int64_t a, b, c; } I3;
typedef struct { double a, b, c; } F3;
int64_t abi_i3_sum(I3 v)     { return v.a + v.b + v.c; }
double  abi_f3_sum(F3 v)     { return v.a + v.b + v.c; }
int64_t abi_i3_mutate(I3 v)  { v.a = 999; return v.b + v.c; }

/* Struct RETURNS by value. Every target lowers these differently: Win64 returns a <=8-byte
   struct as raw bits in RAX and everything larger via sret; SysV returns up to two eightbytes
   in registers; AAPCS64 returns an HFA of up to four floats in the SIMD registers. */
typedef struct { double x, y; } RV2;
typedef struct { int64_t a, b; } RP2;
typedef struct { double v; } RD1;
typedef struct { int64_t n; } RI1;
typedef struct { double a, b, c; } RF3;
typedef struct { int64_t a, b, c; } RI3;
RV2 abi_r_v2(double k) { RV2 r = { k, k * 2.0 }; return r; }
RP2 abi_r_p2(int64_t k){ RP2 r = { k, k * 2 };   return r; }
RD1 abi_r_d1(double k) { RD1 r = { k * 3.0 };    return r; }
RI1 abi_r_i1(int64_t k){ RI1 r = { k + 5 };      return r; }
RF3 abi_r_f3(double k) { RF3 r = { k, k+1.0, k+2.0 }; return r; }
RI3 abi_r_i3(int64_t k){ RI3 r = { k, k+1, k+2 };     return r; }
