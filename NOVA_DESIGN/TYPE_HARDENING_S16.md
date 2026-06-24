# #16 — Type-System Hardening: per-drain unification budget (NOVA_TI_STRICT)

Workflow-designed + adversary-vetted (wzusj0lji). Status: **opt-in (NOVA_TI_STRICT), default-OFF, shipped + gated.**

## The soundness hole (real, verified)
The unifier's fuel counter `ti_unify_count` (TiState) was a **single global, monotonic, per-program budget** — incremented at every unification step, capped at 5000, and **never reset** between functions or between the 6 `ti_solve` drain batches. On exhaustion (`> 5000` or `depth > 50`) `ti_unify_d` did a **bare `return` BEFORE the mismatch detector** — i.e. **fail-open: skip-and-accept**.

Consequence (traced end-to-end): a large early program burns the 5000 budget, then a genuine concrete-vs-concrete type mismatch in a *later* declaration is never checked → no `ti_error` → the error-count gate passes → the offending type var stays unbound → `ti_apply` resolves it to `any` → it reaches codegen as the dynamic `any` representation → the runtime reads raw bits under the wrong tag. This is the same `any`-reinterpretation class as the prior CVE-class soundness bugs. **Measured:** the self-compile's per-drain peak is **9664** unifications — so the old global 5000 cap was being hit *mid-self-compile*; the compiler was NOT fully type-checking its own later code.

## The fix (gated NOVA_TI_STRICT)
1. **Per-drain reset** (`ti_solve` entry): reset `ti_unify_count` so each batch-resolution unit gets a fresh budget — later declarations are no longer starved.
2. **Fail-closed exhaustion** (`ti_unify_d`): on `> 1,000,000` (per drain; ~100× the measured 9664 peak) push **one** `ti_error` (guarded by `ti_budget_reported`) instead of silently accepting. The cap is a backstop for an *unbounded* runaway (e.g. infinite type via occurs-check bypass); any finite cap catches it, so it's set generously to avoid false-positives on large legal programs.
3. **depth bound stays silent** (a legitimately deep type is incompleteness, never a mismatch).

DEFAULT (flag off) preserves the historical global fail-open behavior **EXACTLY** → byte-identical codegen (reconverge gen5==gen6 + 583×2 both modes green). Strict mode validated: negative tests (`_s16_neg1` string-vs-struct, `_s16_neg2` int-vs-list) are correctly REJECTED (E1001); `math3d`/`complexnum`/`_s16_pos1` compile + run clean (no false-positives).

## ⚠️ Bonus finding (tracked) — why strict is not yet the default
Strict mode (full per-drain checking) **surfaced a latent inferer inconsistency in the compiler's OWN source**, previously masked by the budget hole: the `IrInst` constructor (8 fields: op,dest,type,args,value,num,effect,line) is somewhere mis-inferred as a **2-arg `(string,string) -> IrInst`** function type. With full checking, the genuine 8-arg `IrInst(...)` calls in `ir_emit_inst`/`ir_emit_side`/`ir_lower_expr` fail the arity check (E1003) against that wrong 2-arg belief. The compiler *runs* correctly because the mis-typed value degrades to `any` + dynamic dispatch. This is a **real pre-existing inferer bug** (constructor-arity mis-inference), NOT a source bug and NOT introduced by #16.

**UPDATE (3e5bf94): the IrInst 2-arg mis-inference is FIXED.** Root cause was NOT the inferer — it was the PARSER: `parse_type_decl`'s field loop only accepted `IDENT` field names, so an indented keyword-named field (`type:`) hit the else-branch and silently TRUNCATED the struct at that field. IrInst (op,dest,TYPE,...) was parsed as a 2-field struct; it worked at runtime only via positional construction/matching. Fix: accept a keyword token followed by `:` as a field name. This was a GENERAL correctness bug (any struct with a `type` field was broken). Gated: reconverge byte-identical + 584×2.

**Remaining before strict-default (tracked):** with IrInst fixed, the strict self-compile now surfaces **4 more latent inconsistencies** — "expected int, found unit" in `move_expr_uses`, `ire_emit_function`, `nova_pkg_init`, `nova_pkg_install` (a unit-typed expression used where int is expected; benign because unit→any→dynamic). These need an iterative cleanup (fix each, re-check — strict may surface more) before flipping strict to default. Not blocking; strict ships as a validated opt-in.

## Deferred (out of scope, tracked)
- Var-bind mismatch path (unbound var binds wrong concrete type silently) — standard HM, needs an expected-vs-bound reconciliation pass.
- Enum-payload fresh-var drop (the data-dependent `any` slice) — entangled with #13's value model.
- The `IrInst` inferer bug above (the gate to default-on).
