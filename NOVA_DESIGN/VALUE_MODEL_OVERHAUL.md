# Value-Model Overhaul — Staged, Test-Backed Plan

**Status:** DESIGN (2026-06-09). Not yet executed. This is the missing artifact that has
caused the overhaul to be deferred repeatedly: a concrete stage sequence + a differential-test
oracle, so it can be done safely instead of as risky whack-a-mole.

Related: memory `project_any_int_float_soundness`, `project_int_float_valuemodel_fix`,
`project_boxed_float_invariant`.

---

## 1. Problem

NOVA stores both `int` and `float` as a bare `int64`. When a value is **type-erased to `any`**
(stored in a generic container, returned through `-> any`, passed to an `any` param, captured in
a closure, sent on a channel), the runtime later has to decide int-vs-float to print, stringify,
compare, or do arithmetic. Two mechanisms exist:

1. **Box tag** — `NovaBox{kind, payload}` with `NOVA_BOX_FLOAT`. Authoritative when present.
2. **Magnitude heuristic** — `nova_is_likely_float(v)` (nova_runtime.c:3008): for a *raw* (unboxed)
   int64, guess "float" if `|v| ≥ 2^52` and the IEEE-754 exponent bits are normal.

The heuristic is **unsound**: a large integer (hash, snowflake ID, bitset, packed field) whose bit
pattern happens to have a normal double exponent is misread as a float. `str(big_int)` can yield a
float string — violating NOVA's *Robust* and *Secure* non-negotiables (`str()` of an integer must
NEVER produce a float string).

The heuristic exists only because **boxing is applied inconsistently**: some widen points box
(collections, dynamic arith, lambda returns), others don't (named `-> any` returns, `any` locals/
params, closures, channels). Where boxing is missing, the raw float bits force the heuristic.

**The fix is structural, not a patch:** box floats at *every* widen point. Then a raw int64 in an
`any` context is *unambiguously* an int, and the heuristic is deletable.

---

## 2. Surface audit (2026-06-09, against the real tree)

### 2a. Widen points that ALREADY box (sound — keep)
| Path | Site |
|---|---|
| list literal float elements | compiler `make_list` "f" markers → `nova_rt_box_float` (nova_compiler 12837, 13840) |
| dict literal float values | compiler 12736 |
| `index_set` of a float (`x[i] = f`) | `fbox` marker (12886, 13933) → runtime 1624 |
| list append of a float | runtime `nova_rt_list_append` boxes (nova_runtime 908) |
| `map` over a NAMED fn returning float | `nova_rt_list_map_fbox` (compiler 7167) |
| anonymous lambda (`__lambda_*`) float return | compiler 14104 — gated on `ire_cur_fn_lambda` |
| dynamic `add/sub/mul/div` float result | runtime 3049/3055/3077/3083 box |
| reflect / typed-record read float | runtime 2530, 2885 |

### 2b. Widen points that DO NOT box (the gaps — each a latent misread)
| # | Gap | Why it leaks raw float bits |
|---|---|---|
| G1 | **named `fn f() -> any` (or generic) returning a float** | compiler 14104 boxes ONLY `__lambda_*`; a concrete-named fn keeps the raw-float ABI |
| G2 | **float assigned into an `any`-typed local/slot** | `slot_store` of a float-typed reg into an `any` slot does not box |
| G3 | **float passed as an `any`-typed parameter** at a call site | call-arg lowering does not box float→any args |
| G4 | **float captured in a closure** (as any) | `make_closure` capture path does not box |
| G5 | **float sent on a channel** (any payload) | channel send does not box |
| G6 | **`float(list<float>[i])` / element type lost** | `make_list` only tracks `intlist`; a `list<float>` is generic `list`, so `index_get`→`val` (not `float`); `float()` then misreads the already-unboxed raw double. (Also the perf item — see Stage 4.) |

### 2c. Heuristic READ points (delete-after-all-widens-box)
- `nova_is_likely_float` (3008) — the heuristic itself.
- Consumers: `nova_to_double` (3027) → used by dynamic `add/sub/mul/div` (3048–3083);
  serialization/print paths (9195, 9217, 9233).
- Already de-heuristic'd (box-only, no magnitude): `nova_elem_is_float` (580–585). Good — proof the
  box-only model works.

---

## 3. The differential-test oracle (BUILD FIRST — Stage 0)

Before changing any widen point, build `value_model_golden.nova` that systematically covers the
**matrix** {large-int, negative-large-int, small-int, float, neg-float, 0, 0.0} × {scalar local,
`-> any` return, `any` param, closure capture, channel round-trip, list elem, dict value, nested
list, nested dict} × {`str()`, `print`, `==`, `+` arith, `<` compare}. Each cell asserts the exact
expected rendering/result. This is the completeness oracle: a stage is "done" only when it adds
boxing AND its matrix rows flip from wrong→right with zero regressions elsewhere.

Large-int probe values must include bit patterns that TRIP the current heuristic (e.g.
`4613303441197561744`, `-4610549147222700502`) so the oracle proves the heuristic path is killed,
not merely bypassed.

Gate per stage: edit → bootstrap gen3→gen6 → gen5==gen6 converged → `value_model_golden` all-pass
→ full regression (selfhost_test*, 26/26) → GATE 4/5 perf within 5% → commit. Kill-on-timeout
mandatory.

---

## 4. Stages (each independently shippable + reversible)

**Stage 0 — Oracle.** Write `value_model_golden.nova`. Run against today's compiler; record the
matrix of CURRENTLY-passing vs CURRENTLY-failing cells. This baseline is the contract.

**Stage 1 — G1: named `-> any` float returns.** At `op == "return"` (compiler 14097), box a
float-typed return value when the enclosing fn's declared return type is `any`/generic (NOT concrete
`float` — a concrete `-> float` keeps the raw-double ABI; its callers expect raw bits). Requires
threading the fn's `ret_type` to the return emitter. Flips the scalar-any-return rows.

**Stage 2 — G2/G3: any locals + any params.** Box float→any at `slot_store` into an any slot, and
at call-arg lowering when the callee param is `any` and the arg reg is float. Symmetric unbox already
exists (`ire_float_load`/`nova_rt_unbox`) on the read side; verify every consumer unboxes.

**Stage 3 — G4/G5: closures + channels.** Box float captures in `make_closure`; box float channel
sends. Channels already deep-copy; ensure the copy preserves the float box tag.

**Stage 4 — G6 + heuristic deletion + `floatlist` fast path.**
  (a) ✅ SHIPPED (2026-06-10, commit after 8da4b0c). Added a `floatlist` compile-time type:
      `make_list` all-float → `floatlist`; propagated through slots/append/iteration; `index_get`
      → TYPED float read (full unbox → raw double → fadd/fcmp/float_to_str instead of dynamic
      dispatch). **KEY SAFETY DECISION:** storage stays BOXED (not a raw `double[]`). A raw
      `double[]` (true mirror of `intlist`) is UNSAFE in NOVA — raw doubles are not valid `any`
      values (unlike raw ints), so a float list flowing to generic code would corrupt, and a
      heterogeneous push would need an O(n) runtime re-box. With boxed storage, `floatlist` is a
      pure read-optimization hint: any unhandled `== "list"/"intlist"` site degrades to correct-
      but-slow dynamic dispatch, NEVER corruption. Fixes `float(xs[1])` and gives float vectors
      typed-float arithmetic/iteration. (The raw-`double[]` no-boxing variant would need a runtime
      NovaList element-kind tag + escape-to-box discipline — a larger follow-up, deferred.)
  (b) With ALL widens boxing (Stages 1–3) and `floatlist` carrying float lists losslessly, a raw
      int64 in any `any` context is unambiguously int. DELETE `nova_is_likely_float` and switch its
      consumers (`nova_to_double`, serialization) to box-tag-only. This is the payoff: the unsound
      heuristic is gone.

**Stage 5 — Perf certification.** Boxing adds allocation at widen points. Measure GATE 4/5. If a hot
path regresses, consider: (i) `floatlist`/`intlist` fast paths already avoid boxing for homogeneous
collections; (ii) NaN-boxing or a low tag bit for scalar any (avoids heap box) as a follow-up. Do NOT
prematurely optimize — correctness first, then measure, then optimize the proven-hot path.

---

## 5. Risk & falsifiability

- **Risk:** missing ONE widen point = a raw float leaks and, after heuristic deletion, renders as a
  garbage int (no heuristic to rescue it). Mitigation: the Stage-0 oracle must enumerate EVERY widen
  path; the heuristic is deleted ONLY in Stage 4, after Stages 1–3 prove every scalar/aggregate path
  boxes. Until then the heuristic stays as a safety net.
- **Falsifiable:** if after Stages 1–3 any `value_model_golden` cell still needs the heuristic to pass
  (i.e. deleting it in a Stage-4 dry-run breaks a cell), a widen point was missed — find it before
  deleting.
- **Reversibility:** Stages 1–3 are additive (extra boxing) and independently revertible. Stage 4(b)
  (heuristic deletion) is the one-way door — gated behind the full oracle.

---

## 6. Competitive framing

- **Python**: all numbers are heap objects (PyLong/PyFloat) — always "boxed", never ambiguous, but
  slow. NOVA boxes ONLY at `any` widen points; monomorphic int/float code stays raw i64/double (C
  speed). NOVA wins on perf, matches on correctness.
- **Go `interface{}`**: boxes via itab+data word — unambiguous, but every int-in-interface allocates.
  NOVA's `intlist`/`floatlist` fast paths avoid boxing for homogeneous collections; Go cannot.
- **Java**: autoboxing (Integer/Double) — correct, with a known perf cliff and `==` identity traps.
  NOVA avoids the `==` trap (value equality on unboxed) and the cliff (fast paths).
- **C / Zig**: no type erasure — the programmer tracks it. NOVA gives the convenience of `any` WITH
  soundness, which C/Zig don't attempt.

NOVA's target: **Python's "it just works" for `any`, at C's speed for monomorphic code** — achieved by
boxing only at the erasure boundary and keeping homogeneous fast paths unboxed.
