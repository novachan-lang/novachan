# Sound Inference Plan — removing the 95% Job-1 annotation noise (no new syntax)

> Build-ready, adversarially-reviewed plan (design workflow w46vvc89a). This is the **primary**
> zero-annotation work: make the inferer pin a struct type where it's *provably* one struct, so
> annotations like `req: Request` and `-> Point` become unnecessary — **without** the `$`/quasi-quote
> syntax (that's the deferred boilerplate half). PURELY ADDITIVE + flag-gated; byte-identical when off.

## Two CVEs the review caught (and how the revised plan closes them — fail-closed)
1. **Null-return → native null-deref.** A fn `if flag { return Point(..) }; null` has HM unify its
   return to `Point` (null/any absorbs at ti_unify ~10461). Naively pinning `ir_fn_returns[f]=Point`
   makes a caller's `p.x` a native GEP+load on a null pointer → **segfault**. (This path does NOT exist
   today — only source `-> Type` populates `ir_fn_returns`; the spec would *introduce* it.)
   **FIX:** a **syntactic all-paths-return-struct walker** over the fn body AST — pin ONLY if *every*
   terminal path is an explicit `return <struct-init / known-struct-call>` (or trailing struct expr).
   Any non-struct/none/fallthrough terminal → no pin → keeps the existing dynamic path. Fail-closed.
   (Must be **syntactic**, not HM-type-based — HM already laundered the null via the any-absorb.)
2. **Lambda pinning ignored the caller.** Pinning a lambda param to `S` from what the body *forwards
   to* says nothing about what the HOF *passes in* — a HOF passing null/dict → native slot-read on a
   non-struct → segfault. **FIX:** require **caller-side proof** — the HOF's higher-order param must
   itself be typed `fn(S)->_`, proving every invocation passes an `S`. No proof → no pin (dynamic).

## Stages (all additive, separately flag-gated, gated by reconverge gen5.ll==gen6.ll + 588 both modes)
- **S0 — Canaries (DONE, committed).** `_null_return_canary` (positive struct-return-without-annotation
  + null-safety) and `_hof_intfloat_canary` (HOF int+float, the scalar-mono CVE oracle). Both PASS on
  clean HEAD. These are the oracles every later stage runs against.
- **S1 — Nominal struct-return flow** (flag `NOVA_STRUCT_RET`, default OFF). New `TiState.ti_fn_ret_stypes`
  dict; in the deferred loop (post-`ti_solve`, ~nova_compiler.nova:12991) store `ti_to_ir_stype(ti_apply(
  st,d_ret_var))` **only if** `contains(ir_sdefs,result)` **AND** the all-paths-return-struct walker
  passes. Consumption (~16941, flag-gated): for a fn WITHOUT a source rettype, set `ir_fn_returns[f]=S`
  (source annotations always win via `not contains(ir_fn_returns,f)`). Closes B12 for these returns.
  *(Drop architect "Edit B" at 12121 — dead code; the deferred loop reprocesses it post-solve.)*
- **S2 — Lambda param struct-pinning** (separate flag `NOVA_LAMBDA_PIN`, default OFF). Analysis runs
  **inside `ir_lift_lambda`** (~7216, BEFORE the lower at 7228 — *not* ir_collect_param_types, which
  runs too late). Pin `pname→S` only with **body-forward evidence AND caller-side proof**; store in new
  `ir_lambda_param_stypes[lname.pname]`; consume via a new else-if in `ir_lower_function` (~9925).
- **S2b (conditional)** — strengthen Forge route-registration HOF fn-type to `fn(Request)->Response` so
  S2's caller-side proof fires on the real dispatch and the hero loses `req: Request`. Additive metadata.
- **S3 — Scalar use-set monomorphization: DEFERRED** (flag `NOVA_SCALAR_MONO`). The int/float landmine.
  Whole-program JOIN of **caller** arg scalar types per param (NEVER `d_fn_type` body-resolution — the
  proven 1.97e-323 corruptor); specialize only if all call sites agree, else `any`. Not on the critical
  path; ships only after the nominal half is default-ON + stable + its canaries pass.

## Gate per stage
Flag OFF: 588 regression NORMAL + NOVA_T8_FULLRC + `gen5.ll==gen6.ll` byte-identical. Flag ON: 588 both
modes + `_null_return_canary` stays on the dynamic path (no segfault) + math3d/complexnum/colorconvx/
float_int_mix correct (no scalar leak) + ASAN clean. Two flags ⇒ test OFF/OFF (byte-identical) + ON/ON.

## The win (demoOracle)
`fn make_point(x,y) Point(x,y)` (no `-> Point`) then `let p=make_point(1.0,2.0); p.x` resolves nominally;
and (after S2/S2b) the Forge handler `fn _hello(req) json(req.body)` works with **no `req: Request`** —
`req` resolves to Request, `req.body` hits the native slot, returns the posted JSON. Float canaries stay
correct throughout (the nominal half never specializes a scalar).
