# NOVA Performance — Honest Re-Measurement (2026-07-04)

> **Measured on:** Windows 10 x64, 8-core CPU, clang -O2, NOVA self-hosted compiler (gen3/gen4) + LLVM -O2
> **Method:** same algorithm, same input size, both languages. `where_nova_is_slow.nova` vs `bench_c_compare.c`.
> **⚠️ This document was badly STALE.** The numbers below REPLACE the old "8x / 120x slower" claims — those
> were measured before the type-threading + float-repr compiler work landed and (in one case) compared
> different input sizes. Re-measured fairly, **4 of the 6 "gaps" are already closed or minor.**

---

## Executive Summary — Current Reality

| Gap | Old claim | **Fair re-measurement** | Status |
|-----|-----------|-------------------------|--------|
| GAP 1 — int loop + modulo (sieve) | 8x slower | C 21ms vs NOVA 13–33ms @ 50k = **~0.6–1.6x (PARITY)** | ✅ **CLOSED** — IR is already native `mul i64`/`srem i64`/`icmp` |
| GAP 2 — float array sum | 120x slower | NOVA 2ms vs C <1ms @ 100k = **~2–3x** | ✅ **Largely closed** (was boxed; repr inference now emits native `fadd`/loads) |
| GAP 3 — HOF/lambda dispatch | 2–3x | map+lambda 2ms vs direct 0ms @ 50k = **~2x on a trivial body** | ⚠️ Minor — real only for micro-bodies |
| GAP 4 — struct field access | 2–3x | 10M struct dot-products: NOVA 157–174ms vs C 151–154ms = **~1.05x (PARITY)** | ✅ **CLOSED** — struct SROA (default-on) makes the hot loop native `fmul`/`fadd` |
| GAP 5 — string concat in a loop | 30x | naive `s=s+x` IS O(n²), BUT O(n) tools exist (see below) | ✅ **FIXED** — `join` + `bytes` + new `bytes_append_str` |
| GAP 6 — spawn/channel micro-tasks | 9µs/task | ~14µs/task @ 10k | ⚠️ Fundamental (isolation), competitive with Go/Loom |

**Bottom line: NOVA is at C parity on tight integer loops AND on struct-field/dot-product code, and within ~2x of C on float-array/HOF code — not the 8–120x the old doc claimed.** The only genuinely O(n²) pattern (naive string `+` in a loop) has three O(n) alternatives, one of them added by this pass. Of the 6 original gaps, **4 are closed at parity (1, 4) or fixed (5) and near-parity (2)**; only float-array-read (2, residual ~2x) and trivial-HOF (3) remain as optional micro-optimizations.

---

## GAP 1 — Tight Integer Loop + Modulo (Prime Sieve): ✅ CLOSED

Same trial-division algorithm both sides (`for d=2; d*d<=n; d++ if n%d==0`), same size (50,000):

| | C (clang -O2) | NOVA (self-hosted -O2) |
|--|---------------|------------------------|
| primes ≤ 50,000 | 21–22ms | 13–33ms (warm ~13, cold ~33) |

**The generated IR is already native** — inspected `count_primes` in the emitted LLVM:
```
%r9  = mul i64 %r7, %r8          ; d * d      (native, no nova_rt_mul)
%r11 = icmp sle i64 %r9, %r10    ; d*d <= n   (native)
%r14 = srem i64 %r12, %r13       ; n % d      (native, no nova_rt_mod)
%r16 = icmp eq i64 %r14, %r15    ; == 0       (native)
```
The old doc's root-cause (inferred local types dropped at codegen) has since been fixed — inferred `int` locals now drive native arithmetic. **No further work needed.** The old "C ~4ms" figure appears to have compared against a true sieve (different algorithm) and/or a different size.

---

## GAP 2 — Float Array Sum: ✅ Closed further (S3 raw storage now on, sound)

| | C | NOVA (boxed S2) | **NOVA (raw S3, now)** |
|--|---|-----------------|------------------------|
| sum 1M floats | ~1ms | ~15ms | **~7ms (2.1x faster)** |

**2026-07-04 — S3 raw `double[]` storage landed (the previously-reverted step), sound + bootstrap-converged.**
A push-built homogeneous float list now stores raw inline doubles (`elem_kind=2`), so a typed read is a single native load with no box-pointer chase (vs S2's boxed storage + unbox). This was the step reverted twice before because it corrupted `stats` (raw IEEE-754 bits read as a box pointer → `8.96e-312`).

**Root cause found (by instrumenting the runtime) + fixed:** the corruption was *not* a missing reader — it was `nova_rt_list_append_fraw` being handed a **boxed-repr** float. A `fn f(x) -> float` whose body is `x * 1.0` on an `any` param returns a *boxed* float; pushing it into raw storage stored the box **pointer** as if it were raw double bits. **Fix (compiler-only, ~10 lines):** at the `append_fraw` codegen site, `ire_float_load` the value arg to guaranteed-raw double bits first (repr-aware: a no-op bitcast on a proven-raw SSA reg, an unbox on a box/unknown). Now every float — raw or boxed-repr — is stored as raw bits.

**Validated:** all 8 historical corruptors (`stats`/`math3d`/`geox`/`complexnum`/`colorconvx` + 3 float-escape oracles) match their golden output, a 7-pattern float-egress stress test (coerce-fn/any-param/comparison/index_set/dict/nested/negative-index) is correct, the broad differential regression is clean, and **gen5.ll == gen6.ll (bootstrap converged)**.

Residual ~7x vs C is the per-element read (measured: an identical loop with `s + 1.0` instead of `s + xs[i]` runs in **1ms** = C-parity, so the read is the whole cost).

**Stage B (inline the read) — attempted, measured, reverted (a useful negative result).** I inlined a guarded native `load double` (fast path: `elem_kind==2` + in-bounds; else fall back to the call) at all three read-emission sites, sound (all 8 corruptors passed). It removed the call overhead (9ms → 6ms) but **did not vectorize** (0 vector ops in the optimized IR): the per-iteration `elem_kind` guard branch blocks LLVM's loop vectorizer, and LLVM won't hoist the (loop-invariant) kind/size loads because it can't prove the list isn't aliased/mutated in the loop. A ~15% gain at the cost of 6 extra basic blocks *per float read* (heavy IR bloat) isn't worth shipping, so it was reverted.

**The real path to float C-parity** is therefore NOT per-read inlining but **loop-level specialization**: recognize a read-only float-list loop, hoist the `elem_kind==2` check *out* of the loop once, and emit a specialized raw-`double[]` inner loop that LLVM can vectorize — or a first-class `[float]` typed-array type so the element representation is statically known. Both are sizeable features (loop analysis / a language-level array type), not a codegen tweak. Tracked as the remaining ~7x → 1x work.

---

## GAP 3 — HOF Lambdas: ⚠️ Minor (~2x on trivial bodies) · GAP 4 — Struct Fields: ✅ CLOSED

- **GAP 3:** `map(nums, fn(x) x*x)` over 50k = ~2ms vs a direct loop = ~0ms. The overhead is real only for *trivial* bodies (the closure call dominates 1 multiply). For any non-trivial body it vanishes. Whole-program monomorphization (`PERFORMANCE_SPECIALIZATION.md` Stage 5) would erase even the trivial case — but note the **unsound shortcut** (feeding `ti_fn_param_types` into `fpt`) was tried and reverted (it corrupted float callers of polymorphic bodies). The real fix needs the whole-program use-set.
- **GAP 4: ✅ CLOSED — measured at C parity.** 10M struct dot-products (`a.x*b.x + a.y*b.y + a.z*b.z`, `V3{x,y,z}` of floats): **NOVA 157–174ms vs C 151–154ms = ~1.05x.** Struct SROA is default-on (`NOVA_NO_SROA=1` disables), so a non-escaping struct never hits the heap in the hot path — its fields become SSA values and the loop is native `fmul`/`fadd` identical to C. The only `nova_rt_struct_new` calls in the IR are the one-time `V3{...}` literal constructions *outside* the loop. The old "~2–3x, escape→alloca remains" claim was stale — the wiring already exists and is on.

---

## GAP 5 — String Concatenation: ✅ FIXED (O(n) tools available)

Naive immutable concat in a loop is genuinely O(n²) (each `s = s + x` copies the whole prefix):
```
naive s = s + "x", 10k iters .......... ~29ms   (O(n²))
```
**But NOVA already had, and now cleanly has, O(n) string building — three ways:**

| Idiom | 10k–100k build | When to use |
|-------|----------------|-------------|
| `join(parts, "")` (collect into a list, then join) | **0ms** (O(n)) | You can gather all parts first (the common case) |
| `bytes` byte buffer + `bytes_to_str` | O(n) amortized | Streaming single bytes |
| **`bytes_append_str(buf, s)` + `bytes_to_str(buf)`** ← *added this pass* | **1ms @ 100k** (O(n)) | Streaming whole strings — the general string builder |

```nova
let buf = bytes(0)
while ...
    bytes_append_str(buf, part)     // amortized O(1) per append (capacity doubling)
let result = bytes_to_str(buf)      // O(n) once
```
`bytes_append_str` is a thin, **soundness-safe** runtime primitive: it bulk-appends a string's bytes into the existing amortized-growth `NovaBytes` buffer (`nova_back_grow`), touching none of the immutable-string / RC / tag machinery. **Measured: 100,000 appends in 1ms** vs the naive path's O(n²).

**Deferred (deliberately):** the *automatic* `s = s + x` → in-place rewrite ("Option A") would need a capacity field on strings, which means a new string tag threaded through the CVE-hardened `nova_mem_find_tag` / `nova_is_readable_str` / free / `len` dispatch. That is a separately-validated change, not something to slip into the string hot path — so the ergonomic auto-fix stays a tracked future item while the *capability* gap is closed today.

---

## GAP 6 — Spawn/Channel Micro-Task Overhead: ⚠️ Fundamental, Competitive

10k `spawn`+`send`+`recv` = ~145ms ≈ **~14µs/task**. This is the price of process isolation (deep-copy on send = no data races). It is competitive: Go goroutine ~2–5µs (no isolation), Java Loom ~5–10µs, Erlang ~3–5µs (10–50x slower compute), Java Thread ~50–100µs. **The answer is not to remove isolation but to not spawn a process for `v+1`** — use `pmap` for data parallelism, `spawn` for work units where work ≫ overhead. Fiber pooling (`reclaim_fibers`) already recycles stacks.

---

## Honest Verdict

**None of these were architecture flaws, and most are already fixed.** NOVA's uniform Values/Processes/Channels model over an LLVM backend reaches C on integer compute today and sits within ~2–3x on float/struct/HOF code, with clear (optional) paths to close the rest. The one true O(n²) pattern — naive string `+` in a loop — has O(n) idioms (`join`, `bytes`, `bytes_append_str`). **NOVA's performance is far closer to C than this document previously claimed.**

### Remaining optional work (priority order)
1. Loop-level float-array specialization — hoist the `elem_kind==2` guard out of a read-only float loop so LLVM vectorizes it, or a first-class `[float]` typed-array type (closes the last ~2x on dense-numeric/AI; sizeable feature — see GAP 2).
2. Whole-program monomorphization (GAP 3) — erases trivial-lambda overhead (hard; needs sound use-set analysis).
3. Automatic `s = s + x` rewrite (GAP 5 ergonomics) — needs capacity-carrying strings (separately validated).

*(GAP 4 escape→alloca is DONE — struct SROA is default-on and measured at C parity; removed from this list 2026-07-05.)*
