# Tier 1.1 (unification budget) — soundness & codegen-impact analysis

**Date:** 2026-07-06. **Context:** CORE_GAPS_2026_07_03.md Tier 1.1 fix planning.

## The gap (as filed)
Default type checker: after **5,000** unifications per *whole compile*, `ti_unify_d`
becomes a silent no-op ([nova_compiler.nova:10596](../nova-compiler/test_programs/nova_compiler.nova#L10596)).
`ti_unify_count` is **never reset** in the default path (only reset per-drain in strict —
[:10685](../nova-compiler/test_programs/nova_compiler.nova#L10685)). The compiler's *own*
self-compile needs **9,664** unifications → its later declarations are not fully checked.
This is a fail-**open** soundness hole.

## Critical second-order finding: the budget feeds CODEGEN
The type inferrer is **not** checking-only. At
[:17180](../nova-compiler/test_programs/nova_compiler.nova#L17180):
```
b.ir_fn_param_stypes = ti_state.ti_fn_param_types
```
`ti_fn_param_types` is populated at
[:13196](../nova-compiler/test_programs/nova_compiler.nova#L13196) **after** the whole program
is inferred + final `ti_solve`, reading each function's *fully-zonked* param types via
`ti_to_ir_stype`. Codegen consumes it at
[:10104-10105](../nova-compiler/test_programs/nova_compiler.nova#L10104): an **unannotated
struct param** whose type the inferrer resolved gets **native field-access lowering**
(`a.x*b.x` → `fmul`, not `nova_rt_mul`) — gated on `contains(b.ir_sdefs, ...)` so only genuine
struct types take effect.

**Consequence:** raising the budget lets more params resolve to their struct → more native
lowering → **codegen bytes change**. So the fix needs its **own reconverge + perf gate +
both-mode regression**, NOT a byte-identical check against the pre-fix output.

## Is it SOUND? Yes.
`ti_to_ir_stype` ([:12772](../nova-compiler/test_programs/nova_compiler.nova#L12772)) returns a
struct name **only** when the resolved type is `kind == "struct"` with a non-empty name;
otherwise it falls through to `ti_to_ir_kind` (int/float/any/… — none in `ir_sdefs`).
Unification is monotonic: it either binds a var correctly per the constraints, leaves it a var
(→ `any`), or **errors** on a genuine conflict. It never produces a *wrong* concrete binding.
Therefore a higher budget can only:
1. turn `any` → **correct** struct (faster native lowering, still sound), or
2. **surface** a genuine type error that the low budget had masked (fail-open → fail-closed).

It can **never** turn a correct type into a wrong one. So the budget raise cannot introduce
unsound codegen. The only risk is (2): a program that "compiled" before (with an unchecked
genuine error) could now be rejected — which is *correct behavior*, but must be verified against
the compiler's own source + all regression tests before shipping.

## Two implementation options
- **A. Raise the global cap** (e.g. 5000 → 100000). Keeps global-accumulate semantics with
  headroom; self-compile (9,664) now fully checked. Programs > cap still fail open silently.
  Minimal change; still needs reconverge (codegen shifts per above).
- **B. Make strict the default** (per-drain reset + fail-**closed** at 1,000,000/drain — the
  behavior already implemented behind `NOVA_TI_STRICT`). The ledger's recommended real fix:
  per-function budget so no realistic program fails open; exhaustion is an error, not a silent
  skip. Bigger blast radius (max param-type resolution → max codegen change) but truly closes
  the hole.

**Recommendation: B**, contingent on resolving the stale-looking comment at
[:10583-10586](../nova-compiler/test_programs/nova_compiler.nova#L10583) claiming strict
surfaces an `IrInst` constructor arity mis-inference (2 vs 8) in the compiler's own source.
A gen4 smoke test (`NOVA_TI_STRICT=1` compiling `nova_compiler.nova`) produced **zero errors** —
suggesting the comment is stale and 1.2 is already unblocked. **Must confirm** with a careful
exit-code + error-count check on the reconverged compiler before flipping the default. If strict
genuinely errors on some regression test, fall back to A and document B as tracked-partial.

**Sequencing discipline:** one behavior change per reconverge. 0.3 (unary-neg) reconverges
first; the budget fix is its own separate change + reconverge afterward.

---

## Tier 1.3 (occurs-check) — scoped while in the inference code

`ti_occurs` ([:10344](../nova-compiler/test_programs/nova_compiler.nova#L10344)) is a **real,
correct** occurs-check and it **is** called at both var-bind sites in `ti_unify_d`
([:10630](../nova-compiler/test_programs/nova_compiler.nova#L10630),
[:10635](../nova-compiler/test_programs/nova_compiler.nova#L10635)). When it detects a cycle it
does `return` — **skips the bind, no error**. The `ti_walk_depth` depth-500 valve
([:10326](../nova-compiler/test_programs/nova_compiler.nova#L10326)) is pure defense-in-depth
(it should be unreachable if occurs-check holds).

**Verdict:** this is a **diagnostics/completeness** gap, **not** a soundness hole. A genuinely
infinite type (`let x = [x]`) silently leaves the var unbound → degrades to `any` (a *safe*
over-approximation), rather than being reported. No garbage, no UB.

**Fix (low-risk):** at the two occurs-true sites, emit
`ti_error(st, "recursive type: '<var>' would be infinite", line)` instead of a bare `return`.
NOVA's recursive **nominal** structs (`type Node ... next: Node`) do **not** create unification
var-cycles (they're nominal), so they won't trip this. Still needs reconverge + full regression
(the compiler's own source must not contain a legitimate var-cycle that currently rides the
silent-degrade path). Effort: S. Do after 1.1.

---

## ★ THE REAL 1.1/1.2 BLOCKER (discovered 2026-07-06): strict-mode surfaces 7 return-inference false-rejections

**What happened.** `NOVA_TI_STRICT=1 ./gen3_test.exe nova_compiler.nova` fails with **7 type
errors** — so the "IrInst arity" comment at `:10583` is *not* stale; strict genuinely can't be the
default yet. But the deeper find: **any budget fix that increases checking (per-drain reset OR a
raised cap) surfaces these SAME 7 errors** — they are ordinary type-mismatch errors detected once
more unifications complete, NOT budget-exhaustion errors. The budget hole was *masking* them. So
these 7 must be resolved BEFORE (or together with) any budget change, or the budget change breaks
the compiler's own self-compile.

**The 7, two classes (both = return-position inference is too strict):**
- **Class A (2) — `-> any` heterogeneous returns.** `eval_expr(env, e) -> any` returns bool
  (`==`), string (`str(...)`), int (`len(...)`), … Root cause: at
  [nova_compiler.nova:12240-12245](../nova-compiler/test_programs/nova_compiler.nova#L12240) the
  code *skips* constraining `ret_var` to the annotation when the annotation is `any` (guards
  `rxv != "any"` + `if ak != "any"`). So `ret_var` stays a free var, binds to the *first* concrete
  return, then conflicts with the rest. **A `-> any` function should accept any return type.**
- **Class B (5) — unannotated procedure with `return 0` early-exit + unit fall-through.**
  e.g. `move_expr_uses` ([:12909](../nova-compiler/test_programs/nova_compiler.nova#L12909)) uses
  `return 0` as "return early" (the 0 is a dummy) but falls through to a `for` loop (unit) at the
  end. `ret_var` binds to `int` (from `return 0`), then the fall-through constraint
  [:12280](../nova-compiler/test_programs/nova_compiler.nova#L12280)
  `ti_constrain(ret_var, last_t=unit)` conflicts → "expected int, found unit". Same for
  `ire_emit_function`, `nova_pkg_init`, `nova_fmt_file_ast`, `nova_pkg_install`.

**Confirmed it's a REAL bug, not just strict-only:** the minimal `_anyret_repro.nova`
(`fn poly(k)->any` returning 42 / "hello" / true) **fails to compile in DEFAULT mode** — the
budget only masks it in *large* files (the compiler) where 5000 unifications exhaust before the
offending declaration. So today, a small `-> any` (or early-`return`-in-procedure) program
false-rejects. This is a **soundness/usability defect in its own right** (independent of the
budget) and arguably deserves a Tier-0-adjacent priority.

**Fix direction — make return-position unification tolerant, WITHOUT losing perf:**
- Class A: at :12240, when the annotation is `any`, DO constrain `ret_var` to `nt_any()` (drop the
  `!= "any"` exclusion). Returns then unify with `any` → success. Unambiguously correct, low risk.
- Class B (harder): return-position unification at :12481 (each `return`) and :12280 (fall-through)
  must **widen `ret_var` to `any` on a genuine conflict** for functions with **no concrete non-any
  annotation** — instead of erroring. Preserve STRICT for annotated functions (`-> int` returning a
  string must still error) and preserve the **inferred concrete type when returns agree** (else every
  zero-annotation function's return deopts to boxed `any` → GATE-4/5 perf regression). So the fix is
  *not* "blanket ret_var = any" (too aggressive) but "infer normally; on conflict among returns of an
  un-annotated fn, widen to any". Needs a widen-on-conflict mechanism at the return sites (a
  new tolerant path, distinct from `ti_unify_arms` which only *skips* when a side is any/var/unit).

**THE ONE DESIGN DECISION for the user:** should an un-annotated function whose `return`s genuinely
disagree (int in one branch, string in another) be (a) **accepted, return type widened to `any`**
(Python-like, zero-ceremony, matches "simpler than Python"), or (b) **rejected** with "this function
returns inconsistent types; annotate `-> any` if intended" (stricter, catches real mistakes)?
Recommendation: **(a) widen to `any`** for un-annotated, because NOVA's thesis is zero-annotation +
`any` is a first-class type; but emit the strict error for a **concrete** annotation mismatch. Class B's
`return 0`-as-early-exit is the common idiom (a procedure), so widening there specifically to *unit*
(treat a bare early `return`/`return 0` in an otherwise-unit fn as unit) may be cleaner than `any`.

**Sequence:** (1) land Class A + Class B return-inference fix → strict self-compiles clean →
reconverge + FULL regression under BOTH default and (spot) strict. (2) THEN the budget per-drain
reset (1.1) lands safely. (3) THEN flip strict/fail-closed default (1.2). Each its own reconverge.
Repros saved: `_anyret_repro.nova`; strict error dump `_strict_errors_full.log`.
