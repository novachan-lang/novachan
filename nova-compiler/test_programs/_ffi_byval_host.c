/* C host for struct-by-value FFI. These take/return structs BY VALUE, which is what
   NOVA currently cannot express: @repr(C) lowers to `ptr`, so NOVA hands C a POINTER
   where C expects the struct itself, and the callee reads the pointer's bits as its
   first field. */
#include <stdint.h>
typedef struct { double x; double y; } Vec2;
typedef struct { int64_t a; int64_t b; } Pair;

double vec2_sum(Vec2 v)        { return v.x + v.y; }
int64_t pair_diff(Pair p)      { return p.a - p.b; }
Vec2    vec2_scale(Vec2 v, double k) { Vec2 r; r.x = v.x * k; r.y = v.y * k; return r; }
