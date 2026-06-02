# Typed `Result<T,E>` / `Option<T>` — Implementation Plan (the #1 core gap)

**Status:** Designed & de-risked 2026-06-02 (findings verified against `nova_compiler.nova`). Ready to
implement in a focused session with full context budget. This is the **#1 remaining core gap**.

## The gap (verified)

- The **runtime** machinery already exists and works: `NovaResult{tag,value}`, the `?` operator does real
  cross-function early-return, and ~15 combinators (`ok`/`err`/`some`/`none`/`is_ok`/`unwrap`/`unwrap_or`/
  `map`/`and_then`/…) are implemented and pass `result_test.nova`.
- The **type system** is the hole. In `ti_build_stdlib_ext` (~line 7072) every Result/Option builtin is
  registered as `nt_any() -> nt_any()`:
  ```
  reg["ok"]     = NTypeScheme([], nt_fn([nt_any()], nt_any()))
  reg["err"]    = NTypeScheme([], nt_fn([nt_any()], nt_any()))
  reg["unwrap"] = NTypeScheme([], nt_fn([nt_any()], nt_any()))   // <- erased
  ...
  ```
  So `unwrap` of the wrong type, or `unwrap` of a non-Result, is **not** caught — it's a runtime
  `exit(1)`. Result-returning user functions infer `-> int` (the NovaResult pointer as i64).

## Why this is more contained than it looks (the key findings)

1. **The unifier already supports the `sum` kind.** `ti_unify_d` (line 6723) unifies `"sum"` exactly like
   `list`/`tuple`/`fn`: component-wise over `params`. So `Sum<T,E>` unification is FREE — no unifier change.
2. **`any` is permissive** (line 6747: `if wak == "any" or wbk == "any": return`). So *adding* precise
   Result types only produces errors on **genuine concrete conflicts** (the desired new behavior); any code
   still flowing `any` into `unwrap` keeps type-checking. This is what makes the migration small.
3. **The `sum` type constructor exists** — `fn nt_sum(ok, err) -> NType` → `NType("sum","",[ok,err],0)`
   (line 6411) — but currently has **zero call sites**. Type printing already handles `sum` (line 6580).
4. **Type-var scheme pattern is established:** `let T = nt_var(-1)` / `let U = nt_var(-2)` (lines 6799,
   6859); `reg["map"] = NTypeScheme([-1,-2], nt_fn([nt_list(T), nt_fn([T],U)], nt_list(U)))`. Use the same
   for Result with an added `E = nt_var(-3)`.

## Representation

- `Result<T,E>` := `nt_sum(T, E)`.
- `Option<T>`  := `nt_sum(T, nt_unit())`  (none = the err(unit) side). Keeps ONE runtime rep + ONE unify path.

## Step-by-step (each step: bootstrap-reconverge gen5==gen6, then full regression; commit only when green)

**Step 1 — Registry schemes.** In `ti_build_stdlib_ext`, with `let RT = nt_var(-1)` (T), `let RE = nt_var(-2)` (E),
`let RU = nt_var(-3)` (U), replace the erased entries:
```
reg["ok"]        = NTypeScheme([-1,-2], nt_fn([RT], nt_sum(RT, RE)))
reg["err"]       = NTypeScheme([-1,-2], nt_fn([RE], nt_sum(RT, RE)))
reg["some"]      = NTypeScheme([-1],    nt_fn([RT], nt_sum(RT, nt_unit())))
reg["none"]      = NTypeScheme([-1],    nt_fn([],   nt_sum(RT, nt_unit())))
reg["is_ok"]     = NTypeScheme([-1,-2], nt_fn([nt_sum(RT,RE)], nt_int()))
reg["is_err"]    = NTypeScheme([-1,-2], nt_fn([nt_sum(RT,RE)], nt_int()))
reg["is_some"]   = NTypeScheme([-1],    nt_fn([nt_sum(RT,nt_unit())], nt_int()))
reg["unwrap"]    = NTypeScheme([-1,-2], nt_fn([nt_sum(RT,RE)], RT))          // <- the win: Sum<T,E> -> T
reg["unwrap_or"] = NTypeScheme([-1,-2], nt_fn([nt_sum(RT,RE), RT], RT))
reg["and_then"]  = NTypeScheme([-1,-2,-3], nt_fn([nt_sum(RT,RE), nt_fn([RT], nt_sum(RU,RE))], nt_sum(RU,RE)))
```
NOTE: do NOT touch `reg["map"]` (that is list-map; Result-map would need a separate name or overload — defer).
NOTE: each scheme must instantiate fresh vars per use-site — confirm `ti_instantiate` already freshens the
quantified vars (it does for `map`), so the same machinery applies.

**Step 2 — `?` / `try` inference (line 7764 / codegen 5243).** Make the `try` expression type-aware: if the
inner expr has type `nt_sum(T,E)`, then `inner?` has type `T`, and unify the enclosing function's return type
with `nt_sum(<fresh>, E)` (propagating the error type). If the inner is `any`, fall back to current behavior
(stays permissive). This is the only genuinely new inference rule.

**Step 3 — codegen lowering of `sum`-typed returns.** Result-returning fns will now infer `-> sum` instead
of `-> int`. Verify the NType→IR lowering maps `kind=="sum"` to the same i64/pointer rep the NovaResult uses
today (it already lowered Result as i64 under the `-> int` erasure). Find the NType→IrType switch and add/confirm
a `sum -> i64` (pointer) case. THIS IS THE STEP MOST LIKELY TO SURFACE A SECOND-ORDER BREAK — test after it.

**Step 4 — migration.** Blast radius (files using Result builtins): `result_test`, `framework_test`,
`http_mt_demo`, `iter_test`, `shadow_test`, `try_unwrap_debug`, `selfhost_tinyB`. Of these the regression
includes `shadow_test`/`iter_test` (and the self-host path). Most should still pass via `any`-permissiveness;
fix any genuine concrete-type conflicts (those are real bugs the new typing correctly surfaces). Add a new
`typed_result_test.nova` asserting: `unwrap(ok(5))` types as int; a `Result<int,string>` used as a string is
a COMPILE error (negative test via the existing error-expectation harness if present, else document).

**Step 5 — docs.** Move cat-7 "Value-based error returns" and "Typed Option" from 🟡 to ✅; update the
scorecard and the "Result is type-erased" notes in STATE_LEDGER + IMPLEMENTATION_AUDIT.

## Risks & mitigations

- **Codegen sum-lowering (Step 3)** — highest risk. Mitigate: implement Step 1 first, bootstrap, and read the
  inferred types / IR for a tiny `fn f() return ok(1)` before wiring `?`; confirm `sum` reaches codegen as i64.
- **Over-strictness breaking the self-host** (`nova_compiler.nova` itself uses Result internally) — if the
  compiler's own Result usage stops type-checking, the bootstrap fails. Mitigate: `any`-permissiveness should
  cover it; if not, the failing site is a precise, fixable location. Keep each step revertible via git.
- **Estimated effort:** 3–5 bootstrap iterations (~20 min each) + migration. Do it with full context budget,
  NOT at the tail of a long session.

## Why deferred from the 2026-06-02 autonomous push

13 safe batches (A–M) shipped that night took the scorecard 55%→58% with every increment test-backed. Typed
Result is the next big win but is a cross-cutting inferrer+codegen change with expensive (bootstrap) iterations
— starting it at extreme context depth risked a half-done/broken compiler, violating the production-grade bar.
The design above removes the unknowns so it can be executed cleanly and confidently.
