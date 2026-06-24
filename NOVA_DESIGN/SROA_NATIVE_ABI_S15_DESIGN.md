# #15 — Struct SROA + native NOVA->NOVA ABI (Stage 2/3) — VETTED DESIGN

Workflow wggmcmz3f (7 agents). Verdict: 4-edit naive design UNSAFE; sound 5-edit version at ~75%% confidence, gated NOVA_S5_ABI default-OFF. Implement BOTH Edit1(use-set) AND Edit2(address-taken guard) with the escaping canary, or DO NOT ship flag-ON.

## SYNTHESIS

Both load-bearing facts are confirmed against the actual source:

- L12898–12913: `ti_fn_param_types[d_fn_name]` is populated from `d_resolved = ti_zonk(st, d_fn_type)` — the **generalized body resolution**. The comment at L14948 itself names this as the mis-specialization hazard ("math3d mis-specialization").
- L16680: `b.ir_fn_param_stypes = ti_state.ti_fn_param_types` — confirming the design's Edit 1 source is exactly the forbidden body-resolution map.
- L14893: `ir_collect_param_types` exists as the separate, sound use-set union (the `fpt` source used at L17913/17924).

The adversary is correct on both fatal points. Here is the synthesized final plan.

---

# #15 FINAL PLAN — `NOVA_S5_ABI`: by-value struct ABI (smallest sound increment)

## (1) Honest verdict — is a sound increment implementable now?

**Yes, a sound increment is implementable now — but it is NOT the 4-edit design as written, and it is NOT as "small" as that design framed it.** Confidence: **medium-high (75%)** that the corrected scope below is sound; **high (90%)** that the original 4-edit design as written is unsound and would miscompile.

The adversary verdict is correct and I verified its two load-bearing claims against the source. The original design has two fatal defects:

- **E1 (verified):** Edit 1 reads `b.ir_fn_param_stypes` (L16680 ← `ti_fn_param_types`, L12913 ← `d_resolved` body resolution). This is the *exact* source the project's own memory and the L14948 in-code comment flag as UNSOUND for any monomorphization decision, because a generalized function's body type can be more specific than its real call sites. Today this map is used only for *field-offset lowering* (L9856), which is tolerant of being wrong (a GEP at the wrong-but-layout-compatible offset still loads a value). An **ABI signature** is not tolerant: if the body resolves param 0 to `A{x,y}` (2 fields → `@f(double,double)`) but a real site instantiates `f` at `B{x,y,z}` (3 fields), the define and that caller disagree on arity/types → silent wrong bits, same class as the float CVE the project just fixed (19ca6cd).

- **E2 (verified by absence):** An ABI change is a **whole-program global contract**, not a local call-boundary rewrite. Once `@f`'s signature is scalarized, *every* reference to `f` must agree — including indirect ones (`make_closure` capture, `call_by_name`, `dyn_call`, stored function values, and the in-flight #8 interface/vtable entries). The 4 edits only rewrite *direct* `op=="call"` sites they can see; they cannot retract the signature change at sites they can't see → LLVM signature mismatch / verifier failure. The design's own fallback (Edit 4: non-stackable callers `inttoptr`+load fields off an `any`-typed i64) is an **unchecked wild read** that re-opens the find_tag/readable-ptr CVE class (429305a).

**The design's framing error:** "smallest sound increment touching ONLY the call boundary" understates what a calling convention is. The two things that make it global — sound signature source, and provable absence of indirect references — are precisely the two things omitted.

A sound version exists. It requires fixing the source (use-set, not body) and adding a global address-taken guard. With those, the case (e) attack surface collapses to "every call to `@f` is a direct call passing a known stackable `S`," which IS sound. That is a larger analysis than 4 edits, but still single-session-tractable.

---

## (2) The smallest SOUND increment — precise implementation terms

Gated behind `let do_s5abi = env("NOVA_S5_ABI")==["1"]`, computed once next to `do_sroa` (~L17991). When OFF, `_s5_byval` is empty and every new branch is `if do_s5abi`/`if contains(_s5_byval, ...)` → output byte-identical.

Cases (a)(b)(c)(d) from the design are genuinely closed and reused verbatim. The corrected increment changes ONLY how case (e) is established. **Five edits, not four** (the extra one is the mandatory global guard).

### Edit 1 (CORRECTED) — eligibility from the SOUND use-set, with conflict→exclude

Place after `_esumm = ir_escape_summaries(all_fns)` and after `fpt = ir_collect_param_types(...)` (L17924), so both sound analyses are available. **Do NOT read `ir_fn_param_stypes`.** Instead, for each non-extern `f`, for each param position `i`, compute the **set of concrete struct types observed across ALL direct call sites** (the same use-set discipline `ir_collect_param_types` already implements — it unions all direct sites and collapses conflicts to `any`). Param `i` is by-value-eligible iff:

1. Every observed call site passes the *identical* concrete struct `S` (any conflict, any `any`, any non-struct → param ineligible). This is the use-set, not `d_resolved`. If `fpt` already exposes the per-param unioned type with a conflict sentinel, read it directly; if it only exposes the collapsed result, that collapsed result (concrete `S` vs `any`) IS the soundness signal — `any` means conflict → exclude.
2. `S ∈ _allscalar` (L17963 set).
3. param `i` does NOT escape inside `f`: `not contains(_esumm[f], str(i))`.

Store `_s5_byval[f] = list of (i, S)`.

### Edit 2 (NEW, MANDATORY) — global address-taken guard

Before finalizing `_s5_byval`, scan ALL functions' instructions once. If `f`'s name appears in ANY position other than the callee `value` of a direct `op=="call"` — specifically as an arg to `make_closure`, a target of `call_by_name`, a value stored via `slot_store`/`field_set`/`make_list`/`make_dict`, or any future interface/vtable construction — **remove `f` from `_s5_byval` entirely.** A function whose signature we cannot prove is referenced only by direct calls is never scalarized. (Reuse the `ir_escaping_set` arg-walking machinery, L13245–13333, which already enumerates every instruction's value operands.) This is the edit the original design omitted and the reason E2 was fatal.

### Edit 3 — callee parameter reconstruction (`ire_emit_function`, L16396–16464)

For a by-value param `i` of struct `S` with `k` scalar fields (kinds from `ir_sdefs[S]`):
- **Header (L16396–16409):** emit `k` typed params (`double` per float field, `i64` per int/bool) named `%pi.f0..%pi.f<k-1>` instead of one `i64 %pi`.
- **Entry (L16452–16464):** emit the *identical* `[k+1 x i64]` alloca as today's stackable struct; store the type-hash into slot 0 (dead, DCE'd — kept for layout invariance); store each incoming field param (bitcast `double`→`i64` for float fields) into slots 1..k; set `%slot.<pname>` to `ptrtoint` of that alloca.

The callee body is then **100% unchanged** — every `field_get`/`field_set` works against the identical memory image. Because the param was proven non-escaping (`_esumm`), the alloca address is never taken → mem2reg promotes it, params stay in registers.

### Edit 4 — caller call-site scalarization (`op=="call"`, L15814–15821)

When `do_s5abi and contains(_s5_byval, value)`: by Edits 1+2, *every* surviving call site is a direct call whose argument is a known stackable `S` (cond verified at the site via `e.ire_stackable`). **There is no non-stackable-caller path** — if any caller's arg were not stackable, the use-set in Edit 1 would have seen a non-matching/any type and excluded the param, OR the address-taken guard excluded `f`. Emit field reads by GEP+load from the caller's existing `<arg>.ptr` alloca (float field: `load i64`+`bitcast`→`double`; int/bool: `load i64`), then `call i64 @f(double %..., ...)`. SROA folds the store→load round-trip into SSA field values on both sides.

### Edit 5 — record `.ptr` for stackable make_struct dests (L15845–15873)

At make_struct, when the dest is stackable, record `e.ire_struct_ptr[dest] = dest + ".ptr"` so Edit 4 can GEP from it. Purely additive map write.

**Scope cap for this increment:** N struct params by-value, scalar int/float/bool fields only, **i64 return preserved** (no return-by-value). Return-by-value (`{double,double}` multi-value returns) is a clean, independently-gateable follow-on.

---

## (3) Soundness argument — every adversary case

- **(a) escape after call → SAFE.** Dual-gated independently: callee param scalarized only if `not contains(_esumm[f], i)` (Edit 1.3 — does not escape inside `f`); caller arg scalarized only if in `e.ire_stackable` (Edit 4 — proven non-escaping in caller). `ir_escaping_set` (L13245–13333) escapes args of return/field_set/index_set/make_*/closure/eq, so any escaping struct fails one gate.

- **(b) alias/mutation → SAFE.** A stackable struct is non-escaping in the caller ⇒ no alias can exist (any aliasing op forces escape, L13275/13292). Only its own field_sets precede the call; Edit 4 loads fields *after* them (from `.ptr` post-mutation). The callee receives a fresh copy; since the param is non-escaping in `f`, callee mutations were already unobservable to the caller under the current pointer-passing ABI → by-value copy is observationally equivalent. This is the load-bearing link and it is exactly what `_esumm[f]` certifies.

- **(c) any / reflection / to_json → SAFE.** Any path to a tag-reading op is a `call` whose callee is `nova_rt_*`/`dyn_call` (not summarized) ⇒ `ir_escaping_set` escapes ALL its args (L13263–13267) ⇒ the struct escapes ⇒ excluded from both `ire_stackable` and `_esumm`-non-escaping. A by-value struct is never reflected. (Slot-0 type-hash still written for layout invariance; dead.)

- **(d) scalar-field reinterpret / RC → SAFE.** `_allscalar` (L17950–17963) requires every field ∈ {int,float,bool}, excludes `@repr(C)`/aligned ⇒ no managed pointers ⇒ no inc/dec exists on these structs today ⇒ by-value copy touches zero RC. Float passes as `double`, reconstructed via bit-preserving `bitcast` → preserves the raw-double invariant of CVE fix 19ca6cd. No box/unbox involved (Stage 2/3 guarantee on stackable all-scalar).

- **(e) ABI consistency → SAFE (corrected).** Two prior holes closed:
  - **E1 closed:** eligibility now derives from the use-set (every observed call site passes identical concrete `S`), NOT `d_resolved` body resolution (L12913). A polymorphic helper instantiated at two different structs presents conflicting/`any` use-set → excluded. The arity/field-kind of `@f`'s signature is therefore guaranteed to match every caller.
  - **E2 closed:** the global address-taken guard (Edit 2) excludes any `f` referenced anywhere except as a direct call callee. So no indirect/`call_by_name`/closure/interface site can hold a stale i64 signature. Combined, every surviving call site is a direct call passing a known stackable `S` → the unchecked `inttoptr`+load path is *deleted*, not merely guarded.

- **Flag OFF → byte-identical.** `_s5_byval` empty; all branches `if do_s5abi`/`if contains(...)`; header/alloca/call/make_struct fall through to existing code.

### Oracle

1. **Perf win:** `dotbench` (`test_programs/dotbench.ll`, `_dotn.ps1`, `dotbench.c`) standalone non-inlined `dot(a,b)` with `NOVA_S5_ABI=1`. **Accept iff ≤ 1.10× C** (target ≤1.05×; falsified combined-approach reached 1.15×). Verify emitted `.ll`: `define i64 @dot(double,double,double,double)`, and after `opt -O2` the loop body has **0 `inttoptr`, 0 surviving `alloca`, only `fmul`/`fadd`**. If it does not beat 1.10× C, **reject the increment** (falsifiable).
2. **Flag-ON bootstrap FIRST, expecting trouble:** compile `nova_compiler.nova` with `NOVA_S5_ABI=1` through gen5/gen6; require `gen5.ll == gen6.ll`. Run this BEFORE the regression suite — the compiler's own all-scalar structs + helper functions are the highest-risk surface for E1/E2 residue (adversary case f). If bootstrap diverges, the use-set or address-taken guard has a gap → do not proceed.
3. **Full regression 581×2:** all green with flag ON (every test compiled with it); byte-identical `.ll` on a diff sample with flag OFF.
4. **ASAN** clean on `sroa_stress_test`, `_dotn` under the flag.
5. **By-value correctness canary** (`_s5_byval_test.nova`): non-escaping all-scalar struct → leaf that (a) reads fields, (b) mutates its own copy then reads back (callee-copy isolation), (c) float field with a NaN/large payload (bit-exact `double` round-trip), (d) int field at the boundary value. Assert stdout equals the flag-OFF (i64-ABI) build.
6. **Escaping-struct ANTI-REGRESSION canary** (`_s5_escape_canary.nova`): the SAME all-scalar struct type, but at one call site it ALSO escapes (returned / stored in a list / captured by a closure / passed to `to_json`). Assert: (i) that `f` is NOT in `_s5_byval` (or that escaping site uses the pointer ABI), (ii) stdout identical flag-ON vs flag-OFF, (iii) ASAN clean. This canary directly guards E1/E2 — it must pass or the increment is unsound.

---

## (4) What of #15 is genuinely multi-session XL

- **Return-by-value (`{double,double}`/sret multi-field returns)** — #15.2. Independent lowering of the return path; requires multi-value return type emission and every `return struct`/call-result-consume site. Separately gateable. Single-to-double session.
- **Tagless raw-typed local struct layout** (drop the slot-0 type-hash, native field types in the local aggregate) — #15.3. This is the entangled change the falsification warned about: it touches make_struct, field_get, field_set, the alloca hoist, the type-hash slot, RC, and reflection simultaneously. **Genuinely multi-session XL** and must be staged with its own canaries; do NOT attempt with this increment.
- **ptr-typed local handles (eliminate `ptrtoint`/`inttoptr` for ALL struct locals, not just the call boundary)** — XL, entangled with the value-model and the i64 uniform ABI that the whole compiler assumes. This is the rest of the 1.2→1.0× gap after the boundary is fixed. Multi-session.
- **Extending by-value past all-scalar (structs with heap fields)** — requires coordinated RC inc/dec across the copy. Out of scope indefinitely for the "smallest sound" line; only after the tagless layout lands.

**Honest bottom line:** the corrected 5-edit increment is sound and worth building, but it is genuinely larger than the original "4 local edits" claim because a calling convention is a whole-program contract. If the implementer cannot complete BOTH the use-set re-pointing (Edit 1) AND the global address-taken guard (Edit 2) with the escaping-struct anti-regression canary passing, **do not ship it** — a partial version (the original design) miscompiles silently in the float path, which is the worst possible failure for this project. The perf payoff (boundary `ptrtoint` elimination → SROA on both frames) is the single highest-value remaining scalar-perf move and directly attacks the measured 1.2–1.3× gap, so the effort is justified — but only at full correctness, default-OFF, gated exactly as above.

**Edit sites (verified):** `nova_compiler.nova` — eligibility/guard after L17924 (`fpt`) and L17964 (`_esumm`); flag ~L17991; header+entry L16396–16464; call-site L15814–15821; `.ptr` record L15845–15873. Sound sources to USE: `ir_collect_param_types` (L14893), `ir_escape_summaries` (L13338), `ir_stackable_structs` (L13375), `_allscalar` (L17950). Forbidden source to AVOID: `ir_fn_param_stypes`/`ti_fn_param_types` (L16680/L12913, the `d_resolved` body type). Runtime `nova_runtime.c`: **no changes**.

## DESIGN

I now have a complete and precise understanding of the entire pipeline. I have everything needed to design the smallest sound increment. Let me write the design.

---

# #15 Smallest Sound Increment — Design: `NOVA_S5_ABI` (caller-builds, callee-reconstructs by-value struct ABI)

## The decision: what NOT to do, and why

The research correctly establishes the **falsification of three partial approaches** (commit 285846e / `PERF_ENDGAME_STAGES_3_5.md:132-152`):
- i64-ABI alone = 1.20× C
- `internal double @dot(ptr,ptr)` clone = 1.28× C (WORSE — inlines but can't SROA the `[N x i64]` alloca)
- native-call + pass-alloca-ptr = 1.15× C (modest, not parity)

The conclusion was that beating C needs **all three coordinated**: (a) tagless raw-typed local layout, (b) ptr-typed local handles (no `ptrtoint`), (c) register-passing ABI. That is a large, entangled change. The task asks for the **smallest sound increment that gives real perf**, gated behind `NOVA_S5_ABI` default-OFF.

The smallest increment that escapes the falsification trap is **NOT** a representation change at the construction site (that touches make_struct, field_get, field_set, the alloca hoist, the type-hash slot, RC, and reflection all at once — too broad, and the falsification shows partial versions regress). Instead:

**Change ONLY the calling convention for a tightly-restricted class of call, leaving the in-memory struct layout 100% untouched.** Pass the struct's scalar fields as individual `i64`/`double` LLVM arguments. The callee reconstructs the struct into its own local alloca on entry. This is the classic C ABI lowering ("scalarize small aggregates across the call boundary"), and it is what lets LLVM keep both the caller's and callee's structs in registers — because once the only cross-boundary artifact is N scalar SSA values (not a pointer), neither alloca is address-taken across the call, so mem2reg/SROA promotes both.

This is strictly smaller than the full plan because it does not touch field layout, the type-hash slot, RC, or reflection. It reuses the existing make_struct / field_get / field_set emission verbatim. It only adds (1) a per-callee "by-value-eligible" decision, (2) caller-side field-scalarization at the call site, (3) callee-side parameter reconstruction in the entry block.

---

## The exact narrow case (the eligibility predicate)

A direct call `dest = f(a0, a1, ...)` is rewritten to the by-value ABI **iff ALL of**:

1. **`f` is a known, non-extern, user IR function** with a body (in `all_fns`, `fex==0`) — direct, statically resolved (the `op=="call"` `value` is exactly the emitted function name; not `nova_rt_*`, not `dyn_call`, not `make_closure`, not `call_by_name`). This is already how monomorphic direct calls appear.
2. **`f` is monomorphic in its struct params** — `fpt`/`ir_collect_param_types` already unions all direct-call-site param types and sets conflicting params to `any`. We require: for each parameter position `i` we want to scalarize, `f`'s inferred param type is a concrete struct name `S` present in `ir_sdefs` (the same `_inf_pst` the existing `ir_lower_function` adopts at line 9864), AND that param is NOT in `summaries[f]` (the existing escape summary: param `i` does not escape inside `f`).
3. **`S` is in `_allscalar`** (every field int/float/bool, not @repr(C), not custom-aligned) — the existing keystone set. All-scalar ⇒ no heap fields ⇒ **RC=0 concern**: reconstructing the struct in the callee touches no managed pointers, so no inc/dec is needed and none is skipped.
4. **The actual argument register at the call site is itself a `make_struct` dest that is in `e.ire_stackable`** for the *caller* (proven non-escaping in the caller AND all-scalar). This guarantees the caller's struct is a known local aggregate whose fields we can re-derive, not an opaque i64 of unknown provenance.
5. **The struct is not mutated through an alias between its construction and the call** — guaranteed transitively: it is in `ire_stackable` (non-escaping in caller, so no alias can be created — any `field_set` through it, any `slot_store` of it, any container insertion, any second call all force escape and remove it from `ire_stackable`). The only operations a stackable struct supports before the call are its own `make_struct` field stores and the `field_get`s. So at the call site the field values are exactly the `make_struct` arg registers.

**For the FIRST increment, restrict further to a single struct parameter and integer/float scalar fields only (no return-by-value yet).** Returns stay i64. This is the narrowest slice that is measurable on the `dot(a,b)` benchmark (two struct params) — so actually we allow **N struct params, scalar args by-value, i64 return**. Return-by-value is a clean follow-on (#15.2) because it requires the multiple-value return lowering (`{double,double}` return type), which is independent.

---

## The exact compiler change (4 edit sites)

All gated behind `let do_s5abi = env("NOVA_S5_ABI")==["1"...]`, computed once next to `do_sroa` (line ~17991). When OFF, every branch below is skipped and output is **byte-identical** (the new code is purely additive `if do_s5abi` branches).

### Edit 1 — compute the by-value-eligible callee set (orchestration, near line 17964)

After `_esumm = ir_escape_summaries(all_fns)`, add:

```
let _s5_byval = {}    // fname -> list of param indices to scalarize (only when do_s5abi)
if do_s5abi
    for fnx in all_fns
        match fnx
            IrFunction(fnname, fparams, _, _, _, fex) =>
                if fex == 0
                    let idxs = []
                    let pi = 0
                    for p in fparams
                        match p
                            IrParam(pn, pt) =>
                                let pst = ""   // f's inferred struct type for param pi
                                // from b.ir_fn_param_stypes[fnname][pi], same source as line 9856
                                if contains(b.ir_fn_param_stypes, fnname) and pi < len(b.ir_fn_param_stypes[fnname])
                                    pst = b.ir_fn_param_stypes[fnname][pi]
                                let esc_param = contains(_esumm, fnname) and contains(_esumm[fnname], str(pi))
                                if pst != "" and contains(_allscalar, pst) and not esc_param
                                    push(idxs, pi)   // store [index, structname] pairs in practice
                        pi = pi + 1
                    if len(idxs) > 0
                        _s5_byval[fnname] = idxs
```

(In the real edit, store `(index, structName)` so the callee/caller know the field count and types from `b.ir_sdefs[structName]`.)

### Edit 2 — callee parameter reconstruction (entry block, `ire_emit_function`, line 16452-16464)

The function header still emits `define i64 @f(...)` — but for a by-value param `i` of struct `S` with `k` fields, instead of one `i64 %pi`, emit `k` typed params (`double`/`i64` per field kind from `ir_sdefs[S]`). The signature build at 16396-16409 and the alloca loop at 16452-16464 both consult `_s5_byval[name]`:

- **Header**: for a by-value param, emit `<llvmty> %pi.f0, <llvmty> %pi.f1, ...` (double for float fields, i64 for int/bool) instead of `i64 %pi`.
- **Entry reconstruction**: emit a `[k+1 x i64]` alloca (identical layout to today's stackable struct), store the type-hash into slot 0, store each incoming field param (bitcast double→i64 for float fields) into slots 1..k, then `%slot.<pname> = alloca i64` holding `ptrtoint` of that alloca — i.e. **reuse the exact stackable-struct memory image**, just sourced from params instead of from the caller. From this point the callee body is **100% unchanged**: every `field_get`/`field_set` on `%slot.<pname>` works verbatim because the in-memory layout is identical.

The key SROA win: the reconstructed alloca's address is never passed anywhere (the callee was proven non-escaping for this param ⇒ no call/return/container/eq uses it), so LLVM's mem2reg promotes it and the incoming `double`/`i64` params stay in registers. The slot-0 type-hash store is dead (no reader, since non-escaping) and DCE'd.

### Edit 3 — caller call-site scalarization (`op=="call"`, line 15814-15821)

When `do_s5abi and contains(_s5_byval, value)` and the matching actual arg register is in `e.ire_stackable`:

For each by-value param, emit the field values directly from the caller's stackable struct. Two sub-cases:
- **The simplest, soundest source**: re-`getelementptr`+`load` the fields from the caller's `<arg>.ptr` alloca (which already exists — the stackable struct's hoisted alloca). For a float field, `load i64` then `bitcast i64→double`; for int/bool, `load i64`. Then pass these as the scalar args. This is trivially correct (reads the exact current field values, post any field_set) and lets LLVM SROA fold the store-then-load into the SSA field values, eliminating the round-trip.
- The call becomes `call i64 @f(double %..., double %..., i64 %..., ...)`.

The `.ptr` alloca is reachable: a stackable make_struct emits `dest.ptr = alloca` and `dest = ptrtoint dest.ptr`. We track `e.ire_struct_ptr[dest] = dest+".ptr"` at make_struct so the call site can GEP from it. (One tiny addition to make_struct: record the `.ptr` name in a map when stackable.)

### Edit 4 — declaration/signature consistency

User functions are defined and called within the same module (NOVA emits one `.ll`), so there are no `declare` stubs to keep in sync — the `define` IS the declaration. But **call sites and the define must agree on the scalarized signature**, which they do because both consult the same `_s5_byval[fname]` set computed once in Edit 1. Any caller where the actual arg is NOT a stackable struct (eligibility cond 4 fails) **must still call the scalarized signature** — so it must scalarize from whatever i64 it holds: `inttoptr` + GEP-load the fields. This is the one subtle correctness point: **once `f`'s signature is scalarized, ALL call sites must scalarize**, even non-stackable callers (they just load fields from the heap struct pointer they hold; correct because all-scalar = the fields are raw at those offsets). This keeps the ABI globally consistent and is sound because reading scalar fields from any valid S-pointer is always well-defined.

---

## Soundness argument

- **Escape**: param `i` is by-value only if `summaries[f]` says it does not escape `f`. So the reconstructed struct never reaches return/send/spawn/container/closure/eq/hash/deep_copy/type_name/any-call — exactly the set `ir_escaping_set` guards. A non-escaping struct cannot outlive the callee frame, so reconstructing it in the callee's frame is semantically identical to passing the pointer.
- **Aliasing / mutation**: the caller's source struct is in `ire_stackable` ⇒ proven non-escaping in the caller ⇒ no alias of it exists; the only mutations are its own field_sets, all sequenced before the call. We load fields at the call site (after all field_sets), so we pass the current values. The callee gets a **fresh copy** — but since the param does not escape and NOVA struct params are already pass-by-value-of-the-pointer with copy-on-... no: NOVA today passes the same pointer, so callee mutations to a non-escaping param were already invisible to the caller (the caller's struct is dead after a non-escaping call, OR the callee's writes don't escape). Either way, by-value copy is observationally equivalent **precisely because the param is non-escaping in `f`** (any field_set inside `f` is to f's private copy whose effects don't leave `f`). This is the load-bearing soundness link and it is exactly what `summaries[f]` certifies.
- **RC**: `S` is all-scalar ⇒ no managed fields ⇒ no inc/dec exists today on construction (stackable structs skip RC) and none is needed on copy. Zero RC interaction. This is why we hard-gate on `_allscalar`.
- **Type-hash / reflection / `match` / `type_name`**: these read slot 0. Reflection requires the struct to reach an any-typed/tag-reading op ⇒ that forces escape ⇒ the param would NOT be in `summaries[f]` as non-escaping ⇒ not by-value. So no by-value struct is ever reflected. We still write slot 0 in the reconstruction (cheap, DCE'd) to keep the layout invariant byte-identical in case a future non-escaping `type_name` is added; it is currently dead.
- **NaN/float bit-exactness**: float fields are passed as `double` and bitcast back to i64 in the reconstruction; `bitcast` is bit-preserving (including NaN payloads and the raw-double invariant the CVE fix 19ca6cd depends on). No `nova_rt_box`/`unbox` is involved because the field is already raw (Stage 2/3 guarantee on stackable all-scalar structs).

## Byte-identical when OFF

Every change is inside `if do_s5abi` / `if contains(_s5_byval, ...)` (and `_s5_byval` is empty when the flag is off). The header build, param alloca loop, call_str loop, and make_struct all fall through to their existing code paths unchanged. **Oracle for this**: with `NOVA_S5_ABI` unset, `gen5.ll == gen6.ll == <prior fixpoint hash>` (the standing bootstrap reconvergence check), and full regression byte-for-byte unchanged `.ll` on a diff sample.

## Perf + correctness oracle

- **Perf oracle**: the existing `dotbench` (`test_programs/dotbench.ll`, `_dotn.ps1`, `dotbench.c`). Build the non-inlined `dot(a,b)` standalone bench (the one measuring 1.20× C today) with `NOVA_S5_ABI=1`. **Target: ≤ 1.05× C** (the falsification's combined-approach reached 1.15×; this approach should beat it because it scalarizes to pure SSA `double` args with no surviving alloca address-taking on either side — verify the emitted `.ll` for `dot` has `define i64 @dot(double %p0.f0, double %p0.f1, double %p1.f0, double %p1.f1)` and the loop body has 0 `inttoptr`, 0 `alloca` surviving after `opt -O2`, only `fmul`/`fadd`). If it does not beat 1.10× C, **the increment is rejected** (falsifiable, per the rules).
- **Correctness oracle**:
  1. Full regression suite with `NOVA_S5_ABI=1` (every test compiled with the flag) — must be green (currently 551/551-class), AND with the flag OFF byte-identical `.ll`.
  2. **Bootstrap reconvergence with the flag ON**: compile `nova_compiler.nova` with `NOVA_S5_ABI=1` through gen5/gen6, require `gen5.ll == gen6.ll` (self-hosting still converges under the new ABI — the compiler itself uses all-scalar structs).
  3. ASAN clean on the struct/escape stress tests (`sroa_stress_test`, `_dotn`) under the flag.
  4. **A targeted by-value correctness test** (`_s5_byval_test.nova`): a non-escaping all-scalar struct passed to a leaf that (a) reads fields, (b) mutates its own copy and reads back (proves callee-copy isolation), (c) a float field carrying a NaN/large value (proves bit-exact `double` round-trip), (d) an int field at the boundary value — asserting results equal the i64-ABI build (run same source both flag states, diff stdout).

## Why this is the right smallest step

It is the only slice that (1) reuses every existing analysis (`_allscalar`, `_esumm`, `summaries`, `ire_stackable`) with **zero changes to their logic**, (2) touches **only the call boundary** — not field layout, not RC, not reflection, (3) is independently gateable and falsifiable, and (4) directly attacks the measured 1.2-1.3× gap by removing the `ptrtoint`/`inttoptr` laundering *specifically at the boundary that defeats SROA*, which the falsification identified as the dominant blocker. Return-by-value (`{double,double}` returns) and the tagless-typed-aggregate local layout are the clean, separately-gateable follow-ons (#15.2, #15.3) — explicitly out of scope for this increment to keep it provably sound and byte-identical-when-off.

**Relevant file**: `c:/Users/mange/Crypto/AI/New folder/New folder/nova-compiler/test_programs/nova_compiler.nova` — edit sites: ~17964 (eligibility set, after `_esumm`), ~17991 (`do_s5abi` flag), 16396-16464 (`ire_emit_function` header + entry reconstruction), 15814-15821 (call-site scalarization), 15845-15873 (record `ire_struct_ptr` for stackable dests). Runtime `nova_runtime.c`: **no changes** (no new runtime function; the ABI is pure LLVM-level).

## ADVERSARY

I now have full verification. This is the `d_resolved` body-resolution type — exactly the source the memory index flags as UNSOUND for monomorphization, because for a generalized polymorphic function its body type can be more specific than its real call sites. I have everything needed for the verdicts. No need to run programs; the analysis is structural and the repros are reasoning about the emitted ABI.

---

# DEVIL'S ADVOCATE VERDICT — #15 `NOVA_S5_ABI` by-value struct ABI

I verified the design against the actual code (`nova_compiler.nova`): `ir_escaping_set` (L13245), `ir_escape_summaries` (L13338), `ir_stackable_structs` (L13375), the make_struct/call emission (L15814–15873), the function header + entry reconstruction (L16396–16485), and the proposed eligibility source `b.ir_fn_param_stypes = ti_state.ti_fn_param_types` (L16680 ← L12913, the `d_resolved` BODY type).

**Headline: the design has TWO real holes, one of them fatal-class. NEEDS_MORE_DESIGN overall. Most individual attack cases (a–d) are genuinely closed by the predicate — credit where due — but the design's own keystone (case e, ABI consistency) is built on an unsound type source and contains a concrete miscompile.**

---

## Case (a) — struct escapes after the call (stored/returned/captured/sent) but passed natively → SAFE

The predicate gates the *callee's* param on `summaries[f]` (does param `i` escape inside `f`), and separately gates the *caller's* argument on `ire_stackable` (proven non-escaping in the caller). Verified `ir_escaping_set` escapes args of `make_closure`/`dyn_call`/`make_struct`/`make_list`/`make_dict`/`return`/`field_set`/`index_set`/`eq`/`ne` (L13268–13304) and propagates through `copy`/`slot_load`/`slot_store` (L13305–13332). A struct that escapes the caller is removed from `ire_stackable` (cond 4 fails) → the call site falls to the non-stackable path. A struct that escapes the *callee* sets `summaries[f][i]=1` → cond 2 fails → param not scalarized. **Both ends are independently guarded. This case is closed.** No repro survives.

## Case (b) — alias/mutation while a scalar copy is in registers → SAFE (for the gated class)

A stackable struct is non-escaping in the caller, so no alias of it can exist (`slot_store` of it, `field_set` into another struct, container insert all force escape — verified L13275, L13292). The only pre-call mutations are its own `field_set`s, sequenced before the call. Edit 3 loads fields from `<arg>.ptr` at the call site (after those stores). **No stale-read repro survives within the gated class** — precisely because the gate is so narrow.

## Case (c) — all-scalar struct read via any/reflection/to_json expecting a box pointer → SAFE

Any path to `to_json`/`type_name`/any-typed dispatch is a `call` with the struct as an arg. If the callee isn't summarized (e.g. `nova_rt_*`, `dyn_call`), `ir_escaping_set` escapes ALL args (L13263–13267). So the struct escapes → not stackable / param escapes → not by-value. **A by-value struct is never reflected. Closed.**

## Case (d) — field looks scalar but is reinterpreted (RC/ownership) → SAFE

`_allscalar` requires every field ∈ {int,float,bool} (L17960) and excludes `@repr(C)`/aligned (L17955). All-scalar ⇒ no managed pointers ⇒ no inc/dec exists today on these structs (SROA already skips RC for them) ⇒ copying by value touches no RC. Float round-trips as `double`/`bitcast` (bit-preserving, preserves the raw-double invariant from CVE fix 19ca6cd). **Closed.**

---

## Case (e) — ABI mismatch caller vs callee → **UNSAFE as specified. Two concrete defects.**

### Defect E1 (FATAL): the eligibility source is the UNSOUND `d_resolved` body type

Edit 1 reads the callee's struct param type from `b.ir_fn_param_stypes` = `ti_state.ti_fn_param_types` (L16680), which is populated at L12913 from `d_resolved` — the **generalized function's BODY resolution**. The memory index flags this exact source as UNSOUND for any monomorphization decision:

> "d_fn_type is the BODY resolution, which for a GENERALIZED fn can be more specific than its real uses (poly helper body-forced int but instantiated at float)."

Today this source is used only to type `b.ir_locals[pname]` for *field-access lowering* (L9864). That use is **tolerant of being wrong**: if the body says `Point` but a call site passes a different-but-layout-compatible struct, the GEP `a.x` still reads the right offset — it's just a load. The ABI is **not** tolerant. If `f`'s body resolves param 0 to struct `S` (3 fields) and the design scalarizes `@f` to `(double,double,double)`, but a real call site instantiates `f` with a *different* struct `T` (2 fields), the define and that call site now disagree on argument count and types. **That is exactly the "reads wrong bits" miscompile** — and it's silent.

Concrete repro shape (a generic identity-like helper monomorphized by body but polymorphic in use):
```
struct A { x: float, y: float }
struct B { x: float, y: float, z: float }
fn first(p) -> float   // body unifies p to whichever site solves first
    return p.x
fn main()
    let a = A(1.0, 2.0)
    let b = B(3.0, 4.0, 5.0)
    print(first(a))   // site 1
    print(first(b))   // site 2 — different arity struct
```
If `ti_fn_param_types["first"]` resolves to `A` (2-field), Edit 1 marks `first` by-value `(double,double)`. The `first(b)` site (cond 4: is `b` stackable? if non-escaping, yes) would scalarize `b` to... what? Even if you scalarize from `b`'s own 3 fields, the **define `@first` only declares 2 params**. Caller passes 3, callee reads 2 → 3rd dropped, or with float/int field-kind mismatch the bits are reinterpreted. **Silent wrong answer, and on the float path it's the same class as the CVE the project just fixed.**

The design *assumes* `fpt`/`ir_collect_param_types` already collapsed conflicting params to `any` — but that is a DIFFERENT map (`ir_collect_param_types`, the sound use-set union) than the one Edit 1 actually reads (`ir_fn_param_stypes` = body resolution). The design cites the wrong, unsound source. **This must be re-pointed at the use-set/monomorphization analysis (S5-style whole-program use-set), not `d_resolved`.** Until then: UNSAFE.

### Defect E2 (FATAL): "all callers must scalarize" is unenforceable from the call site as designed

Edit 4 concedes the real invariant: *once `@f` is scalarized, EVERY call site must scalarize, including non-stackable callers* (load fields from the i64 heap pointer). But this requires that at **every** call site the compiler knows (1) the call resolves to user-fn `f` and (2) which scalarized signature `f` has. Problems:

1. **`call_by_name` / `dyn_call` / closures.** If `f` is ever invoked indirectly (passed as a value, called via `call_by_name`, stored in a vtable/interface — note #8 interfaces is in-flight), there is NO `op=="call"` with `value=="f"` at that site. That indirect site emits `call i64 @f(i64 ...)` (or a generic dispatch) against a `define` that now says `(double,double)`. **LLVM-level signature mismatch → wrong bits / verifier failure.** The predicate guards the *direct* call sites it can see; it cannot retract the signature change it forced on `@f` for sites it can't see. The design has no "is `f` ever taken by reference anywhere in the program?" check. That check is mandatory and is not in the 4 edits.

2. **The non-stackable caller path is under-specified and itself risky.** Edit 4 says a non-stackable caller holding an i64 must `inttoptr`+GEP-load fields. But a non-stackable arg may be an `any`-typed value whose runtime tag is NOT a struct pointer (it could be a boxed int, a different struct, etc. — that's *why* it's any/non-stackable). `inttoptr` + load 3 fields off it is an **unchecked wild read** — OOB/UAF class. The soundness note "reading scalar fields from any valid S-pointer is well-defined" silently assumes the pointer IS a valid S-pointer; at an `any` site that's not guaranteed. This re-opens exactly the CVE class (find_tag / readable-ptr) the project closed in 429305a.

---

## Case (f) — self-compiling-compiler divergence → NEEDS_MORE_DESIGN (cannot certify SAFE)

The compiler itself is built from all-scalar structs (IrType, IrInst, etc. are heavily used). Turning the flag ON for the bootstrap (oracle #2 in the design) means the compiler's own hot structs get the by-value ABI. Given Defects E1/E2, bootstrap is the *most* likely place to trip them: the compiler has many generic-ish helpers and stores function values. I cannot certify reconvergence will hold; the design's own oracle is the thing most at risk. This isn't a repro so much as: **the flag-ON bootstrap is not a safety net here, it's a minefield, and must be the FIRST thing run, expecting failure.**

---

## Bottom line

| Case | Verdict |
|---|---|
| (a) escape-after-call | **SAFE** — dual-gated (`summaries` + `ire_stackable`) |
| (b) alias/mutation | **SAFE** — non-escaping ⇒ no alias |
| (c) reflection/any/to_json | **SAFE** — forces escape ⇒ excluded |
| (d) scalar-field reinterpret/RC | **SAFE** — `_allscalar` hard gate |
| (e) ABI mismatch | **UNSAFE** — E1: built on unsound `d_resolved` body type (the explicitly-forbidden source); E2: signature change can't be retracted for indirect/`call_by_name`/closure/interface sites, and the non-stackable-caller `inttoptr` path is an unchecked wild read |
| (f) bootstrap divergence | **NEEDS_MORE_DESIGN** — highest-risk surface, not a safety net |

**OVERALL: NEEDS_MORE_DESIGN (bordering UNSAFE if implemented as written).**

The narrow-case soundness reasoning (a–d) is genuinely sound and well-constructed. The fatal flaw is that the design's claim of "smallest sound increment touching ONLY the call boundary" **understates what a calling-convention change actually is**: an ABI change is inherently a *whole-program global* contract, not a local rewrite. The two things that make it global — (1) the signature source must be the sound whole-program use-set, not the body resolution, and (2) the signature change must be provably absent from *all* indirect call sites — are exactly the two things omitted. 

### Minimum changes to reach SAFE_TO_IMPLEMENT:
1. **Re-point eligibility off `ir_fn_param_stypes`** onto a sound monomorphic use-set (the same discipline as the existing struct-S1 / `ir_collect_param_types`, which is why it only does structs and unions ALL direct sites to `any` on conflict). Require the param's type to be identical across *every* observed call site.
2. **Add a global "address-taken" check**: scalarize `@f` only if `f` is NEVER referenced except as the callee of a direct `call` (no `make_closure` capture, no `call_by_name`, no being stored, no interface/vtable entry). If taken by reference anywhere, exclude `f` entirely.
3. **Drop the non-stackable-caller `inttoptr`+load path** (Edit 4) — it's the wild-read. Combined with (2), every surviving call site is a direct call whose arg is a known stackable struct, so there is no "load fields off an unknown i64" case at all.
4. Keep flag-OFF byte-identical (verified achievable — all branches are additive `if do_s5abi`) and run flag-ON bootstrap FIRST.

With (1)+(2)+(3), case (e) collapses to "every call to `@f` is a direct call passing a known stackable `S`," which IS sound — but that is a meaningfully larger analysis than the 4 edits claim, so the "smallest increment" framing is the design's actual error.

**Relevant verified sites:** `nova_compiler.nova` L12913 (unsound `d_resolved` source), L16680 (the map the design reads), L9862-9867 (current tolerant use of it), L13245-13333 (`ir_escaping_set`), L13375-13389 (`ir_stackable_structs`), L15814-15821 (call emission, fixed `i64` ABI), L16396-16485 (header + entry reconstruction).
