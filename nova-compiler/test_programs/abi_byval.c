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
