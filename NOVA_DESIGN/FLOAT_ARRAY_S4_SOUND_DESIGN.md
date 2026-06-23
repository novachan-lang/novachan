# #13 — Sound Float-Array C-Parity (Stage 4), design-first

**Status:** design. No code changes until each stage below passes the full gate
(reconverge gen5.ll==gen6.ll + 571 tests × {NORMAL, NOVA_T8_FULLRC} + ASAN + a
leak/perf probe). Soundness is the gate; performance is the goal.

## The problem (measured 2026-06-23)

`floatlist[i]` is typed `float` and reads natively (S4.2, `nova_rt_list_get_f`) ONLY
when the list register is statically typed `floatlist` — which happens for float
**literals** (`[1.5, 2.5]`). For float arrays built with `push` or received as a
parameter, the register is `list`/`any`, so `s + fl[i]` lowers to a dynamic, BOXING
`nova_rt_add`. Evidence: a local push-built float sum leaks 2 GB over 100M ops; a
literal float sum is native `fadd`, zero dynamic adds, no leak.

## Why the obvious fix is a landmine (do NOT repeat)

Promoting a push-built float list to `floatlist` (so its reads go native) was tried
on 2026-06-20 and **reverted** — it corrupted stats `median` and geox `haversine`.
Mechanism: a native `double` produced by a typed float-index that then flows to a
sink expecting a boxed `any` value — **call-argument bound to a `val`/`any` param,
cross-basic-block comparison, `index_set` of the value back into an `any` container** —
was passed as raw IEEE-754 bits. The sink read those bits as a box pointer →
out-of-bounds/garbage deref. The win needs a robust foundation, not an inferred mode.

## The invariant that makes it sound

> A value typed `float` (unboxed `double` bits in an `i64` slot) must be **boxed at
> every egress to an `any` context**, and unboxed at every entry from one. The set of
> egress points must be COMPLETE — a single missed sink is a corruption, not a
> slowdown.

This is the same discipline as the int/float `any`-soundness work
(`project_any_int_float_soundness`, fixed 2026-06-11) but must be proven complete for
the *float-array-element* source specifically, because that source is new on the hot
path.

## Egress-sink audit (the gate for Stage 1 — must be exhaustive)

Every place a `float`-typed register can be consumed where the consumer expects an
`any`/boxed value. Enumerate from the IR lowering (`ir_lower_*`) and verify each
either (a) already boxes a float operand, or (b) gets a box inserted:

1. **call argument** bound to a non-float (`val`/`any`/generic) parameter — the
   2026-06-20 corruptor. (Typed-float param → pass unboxed; any/val param → box.)
2. **return value** where the function's return type is `any`/inferred-non-float.
3. **cross-block / phi merge** where one predecessor has `float` and another `any`
   (the comparison corruptor — a float compared against an `any`).
4. **`index_set`** storing the value into a non-floatlist container (`list`/`dict`).
5. **`make_list`/`make_dict`** element that lands in a heterogeneous/`any` container.
6. **string interpolation / `str()` / `print`** of the value (typed float→str exists;
   verify the generic path boxes).
7. **channel send / spawn capture** (deep-copy path must see a box, not raw bits).
8. **struct field store** into an `any`-typed field.
9. **assignment to a slot previously typed `any`** (slot-type widening).

Deliverable: a checklist with the file:line of the boxing for each, or a new box
inserted + a negative test that would corrupt without it.

## Staged plan (each stage independently gated; STOP if any regression/ASAN fails)

- **S0 (no behavior change):** add a focused corruption oracle to the suite — a test
  that builds a push float array and pushes its elements through EACH sink above
  (call-arg val, comparison, index_set into a list, channel send, struct field, str).
  It must PASS today (proving the current conservative `any` path is sound) and must
  remain the guard when promotion is enabled. This is the safety net before any change.
- **S1 (egress completeness):** with the audit, insert any missing box-on-egress for
  `float` operands. No promotion yet. Gate. (Pure soundness hardening; if green, the
  foundation is ready.)
- **S2 (gated promotion):** promote a push-built / parameter float list to `floatlist`
  ONLY behind the S1 foundation, and ONLY where the read result is `float`. The runtime
  `elem_kind`/deopt already protects storage; S1 protects egress. Gate INCLUDING the S0
  oracle + stats/geox/math3d/complexnum (the historical corruptors) + the 2 GB-leak
  probe (must now be flat) + a perf probe (float sum should approach the int-array
  ratio, killing the ~120× gap).
- **S3 (optional, perf):** inlined guarded native `load double` (branch on
  `elem_kind==2`, hoisted) to remove the per-element call + enable vectorization. Only
  after S2 is green; this is the last few ×, not correctness.

## Falsification / what would prove this wrong

If the egress audit cannot be made exhaustive (a sink that can't be statically
identified, e.g. value flows through fully-dynamic dispatch), then inferred-list-mode
promotion is fundamentally unsound and #13 needs a **declared** typed-array type
(`[float]` surface syntax) so the type is never inferred-and-lost — a larger language
change. Decide this at the end of the S1 audit, not before.

## Relationship to #9

Independent: S1/S2 *remove* float-array boxing (fewer allocations), which *reduces*
the #9 default-memory burden. #13 does not depend on #9.
