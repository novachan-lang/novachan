# Beating C: Resolving the i64-ABI Performance Gap — Type-Driven Specialization

**Status:** DESIGN / ROADMAP (2026-06-10). Grounded in real generated IR (evidence below).
This is the plan to close NOVA's one fundamental performance gap and move from "match C" to
"beat C", WITHOUT sacrificing zero-annotation or the one-body dynamic model.

## The problem (uniform i64 ABI)
Every NOVA value/param/return/struct-field is `i64`, so ONE function body handles all types (no
monomorphization → simple compiler, fast builds, self-hosting feasible solo). The cost: where a
value's concrete type isn't carried to codegen, arithmetic falls back to runtime tag-dispatch
(`nova_rt_mul`/`nova_rt_add` → ~50-100ns vs ~0.3ns native = 150-300×), structs are heap `i64*`
(no SROA), floats bounce `i64↔double` across calls (no XMM), and float arrays don't vectorize.

## Evidence (actual IR, 2026-06-10)
`fn dot(a, b) = a.x*b.x + a.y*b.y` — **unannotated**:
```llvm
%r4 = call i64 @nova_rt_mul(i64 %r1, i64 %r3)   ; dynamic dispatch
%r10 = call i64 @nova_rt_add(i64 %r4, i64 %r9)
```
Same body with **`a: Point, b: Point`**:
```llvm
%r4.rf = fmul double %r4.af, %r4.bf             ; NATIVE
%r10.rf = fadd double %r10.af, %r10.bf          ; NATIVE
```
**The fast path already exists — it is gated only on whether codegen has the type.**

## The root cause (and why it is NOT fundamental)
NOVA's HM inferer ALREADY infers every concrete type (the language's premise). But the IR lowering
records a param's type for codegen ONLY when the SOURCE wrote an annotation:
`nova_compiler.nova` ir_lower_function ~L8869: `if ptype != "" and contains(ir_sdefs,ptype) ...
ir_locals[pname]=ptype  else  ir_locals[pname]=1`. The inferred-but-unannotated type is discarded
at the codegen boundary. **The fix is plumbing the inferred types through — not a redesign.**

## Prior art
- **Julia**: dynamically-typed feel, native-C speed via aggressive type-inference-driven
  specialization + LLVM. Beats C on some benchmarks. This is the exact model NOVA should follow.
- **C#/.NET, Java JIT**: runtime specialization/devirtualization — but need warmup; NOVA is AOT.
- **Rust/C**: programmer writes concrete types (ceremony) + monomorphization. Fast but no dynamic
  fallback (generics/async coloring). NOVA keeps the i64 fallback → no coloring.

## The plan — Type-Driven Specialization (staged; each behind the verified gate + GATE 4/5)

**Stage 1 — Plumb HM-inferred types into codegen (THE 80% WIN, zero annotations, do FIRST).**
Feed the inferer's local/param types into `ir_locals` (and IR inst types), not just source
annotations. Then unannotated `a.x*b.x` lowers to native `fmul` exactly like the annotated case.
Closes dynamic dispatch for ALL monomorphic code with no language change. Tractable — the types
exist; it is wiring the ti type-environment into the IR builder. Measure `_dot_untyped` → `fmul`
and GATE 4/5.

**Stage 2 — Unbox typed struct fields.** A struct with `float` fields stores raw `double`s (typed
layout) instead of boxed — removes the residual `nova_rt_unbox` per field read seen even in the
typed IR above. With Stage 1: struct float math = pure `fmul`/`fadd`.

> **Stage 2 ATTEMPT 1 (2026-06-11) — REVERTED. Read before retrying.** Implemented the
> redundant-INTERMEDIATE-unbox slice: mark const_float + the 6 float-arith results (fmul/fadd/…)
> as `"float"` in `ire_reg_types`, and make `ire_float_load` emit a plain `bitcast` (skip
> `nova_rt_unbox`) when `src` is a known-`"float"` register. VERIFIED at the IR level: `dot_typed`/
> `dot_unann` went 6→4 `nova_rt_unbox` (the two fmul-result unboxes feeding the `fadd` removed);
> `idot` stayed pure `mul i64`; bootstrap reconverged (CC2FED00). BUT the full regression dropped to
> **391/393 — `nn` and `stats` FAIL under the PARALLEL regression load yet pass 8/8 in isolation**
> (real value, e.g. `assert_near expected 0 got 0.6487…` = e^0.5−1). Reverting restored 393/393,
> confirming Stage 2 as the cause. Codegen is deterministic, so a load-dependent flake is NOT a simple
> wrong-skip. Prime suspect: `ire_reg_types` is a FLAT, non-control-flow map and the `"float"` mark
> PROPAGATES through slot_store/slot_load (~13931-13961) — a loop-carried/reused float-accumulator slot
> can read `"float"` in the map while holding a boxed value on some path → load wrongly skips the unbox.
> PRECISE RETRY: mark only DIRECT same-expression arith/const results; do NOT let `"float"` flow through
> slots (don't inherit on slot_load / don't set on slot_store). Keeps the dot-product win (direct
> fmul→fadd, no slot), drops the slot imprecision. The load-dependence still needs explaining (rule out
> a green-runtime/heap-layout interaction). The verified gate CAUGHT this — do not ship until nn/stats
> stay green under the FULL parallel regression repeatedly.

**Stage 3 — Struct SROA.** Non-escaping structs (escape analysis exists — Track 8) lower to LLVM
`{double,double}` value aggregates, not heap `i64*` → LLVM splits into registers, zero malloc.

**Stage 4 — floatlist-raw (`double[]`).** The deferred raw-array floatlist (needs a NovaList
element-kind tag) → LLVM auto-vectorizes float loops (SSE/AVX). `intlist` already proves the
typed-array (raw `i64[]`) fast path.

**Stage 5 — Monomorphic function specialization (the Julia endgame).** A function called with one
type combo (`fpt` already detects this from call sites) gets a native-ABI variant
(`dot$Point(ptr,ptr)->double`, register-passed, no boxing); the i64 body stays as the polymorphic
fallback for genuinely-dynamic call sites. No coloring.

## Why this WINS (not just ties C)
- Zero ceremony: C/Rust make the dev write concrete types; NOVA infers + specializes → same machine
  code, less developer work ("Python to write, C to run").
- Whole-program type view (`fpt` sees every call site) → more aggressive specialization + inlining
  than C's per-TU view → the "better-informed compiler" path PAST C (see project_performance_thesis).
- i64 fallback preserves true polymorphism → specialization never forces async/generics coloring.
- Concrete types + escape facts unlock auto-vectorization & auto-parallelization the dev never wrote.

## Achievability / cost
Stages 1-3 are mostly plumbing + escape-driven layout — high-leverage, tractable, no language
change. Stages 4-5 are genuine multi-month compiler investments (the endgame, like growable stacks).
Pieces already in place: HM inferer (types), `fpt` (monomorphism detection), typed IR ops
(`fmul`/typed `field_get`, fire for annotated code today), escape analysis (Track 8), `intlist`.

## Falsification
- If Stage 1 plumbing does NOT turn `_dot_untyped`'s `nova_rt_mul` into `fmul` → the inferred types
  aren't reaching the field-access lowering; find where they're dropped.
- If Stage 1 regresses GATE 4/5 (it should IMPROVE typed code, leave int code unchanged) → a
  mis-typing made a dynamic path worse; bisect.
- If specialized + i64-fallback diverge on a polymorphic call → the dispatch/selection is wrong.
