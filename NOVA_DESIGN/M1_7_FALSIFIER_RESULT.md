# M1.7 — THE BET-1 FALSIFIER: RESULT

**Date:** 2026-09-04
**Reproduce:** `python NOVA_DESIGN/tools/m17_readset.py` then `python NOVA_DESIGN/tools/m17_slicing.py`
**Corpus:** all 130 `prism/**/*.nova` modules — 113 state types, 55k lines
**Gates:** M3.4 (reactivity) was gated on this. T16 (GO/NO-GO) consumes it.

---

## VERDICT

**Bet 1 is NOT falsified. But M1.7's stated kill criterion is invalid and is replaced below.**

The criterion as written — *"mean inferred read-set per face >20–30% of reachable state ⇒ Bet 1
dead"* — is a **ratio**, and it cannot decide anything on state types this size. PRISM's state
types average **5 reachable leaves**. On a 5-leaf type, a face reading **one single field** already
scores 20% and trips the line. The metric measures *type size*, not inference quality. Measured
against it, the corpus reads 35.9% and "fails". Measured in the units that actually generalise, the
same corpus says the opposite:

| Measure | Value | Reading |
|---|---|---|
| **Median read-set per face** | **1 leaf** | A face depends on one thing |
| **Mean read-set per face** | **1.87 leaves** | Two, with a tail |
| Mean as % of reachable | 35.9% | An artifact of 5-leaf types — see above |
| Scaling slope vs state size | 0.334, **r² = 0.15** | No correlation; read-set is ~flat, not proportional |
| Faces measured | 535 | app-state faces, reducers and plumbing excluded |

**Absolute read-set is the measure that survives contact with a real app.** A face reads one or two
leaves whether the type has 3 or 16. That is precisely the granularity Bet 1 requires. If it holds
at app scale, a 500-leaf state tree yields read-sets of ~0.4%, not 33%.

### ⛔ The caveat that bounds this verdict: a collection counts as ONE leaf

`reach()` has no element type to recurse into for a bare `list`/`dict`, so a collection field is
**one leaf**. Measured over the corpus: **61 of 448 reachable leaves (14%) are collection-backed.**

So "this face reads 1 leaf" can mean "this face depends on a 10,000-row table." The *ratio* is
unaffected — numerator and denominator both treat a list as one leaf — but **invalidation
granularity over collections is not measured by this experiment at all**, and collections are
exactly what a UI renders most expensively (tables, lists, trees). This is the one place where the
M1.7 numbers are optimistic rather than conservative, and it is why M3.4's design must treat keyed
collection granularity as a separate first-class problem rather than a special case. See
`PRISM_M3_4_REACTIVITY_DESIGN.md` §4.

**The honest limit: this corpus cannot prove it holds at app scale.** The largest app-state type
here is `PrismAppState` at 16 leaves. Nothing in this data supports extrapolation to a 200- or
500-leaf application state tree, and the two candidate models disagree wildly there (flat ⇒ 0.4%,
linear ⇒ 33%). The linear model has r² = 0.15 and no large-type data to fit against; it should not
be believed, but it also cannot be dismissed by this corpus alone.

---

## THE FOUR CORRECTIONS THAT CHANGED THE ANSWER

Each of these flipped or moved the result materially. They are the substance of the measurement:

1. **Faces vs reducers.** A function returning its own state type is a state *transition*, not a
   face — it reads everything by construction. Counting reducers put the mean at **71.9%**, which
   would have "killed" Bet 1 on a category error. Reducers measured separately: **80.7% mean,
   slope 0.846, r² = 0.63** — they genuinely do read all of state, exactly as expected, which is a
   useful sanity check that the method detects a wide read-set when one is really there.

2. **Transitive reachable state as the denominator** — the leaf closure through nested state types,
   not the parameter's own field count.

3. **Transitive read-set via a fixed point over delegation edges.** Counting only `p.field` in the
   immediate body **undercounts by 36%**: 206 of 572 faces read more once helpers are followed
   (mean 1.46 → 2.49 leaves). Every number in earlier drafts was a lower bound.

4. **Renderer plumbing is not application state.** `PrismCanvasCtx` bundles theme + cursor +
   metrics + output buffer and is threaded into every painter — which is why **20 unrelated
   painters all read exactly 12/13 of it**. Reactivity never tracks a canvas context; it *is* the
   face's output channel. Left in the sample, this one type drove the regression slope from
   **0.13 to 0.46** — i.e. it alone would have produced a "Bet 1 dead" verdict.

---

## THE TWO REAL FAILURE MODES (these are the actionable output)

The corpus does not kill Bet 1, but it locates precisely where Bet 1 dies. Both are visible in the
data and both are now design constraints on M3.4:

### 1. A god-object state type collapses granularity completely

| Type | Mean read-set | Median |
|---|---|---|
| `PrismCanvasCtx` (plumbing) | **88.2%** | **100%** |
| `PrismAppState` (16 leaves) | 16/16 on all 3 faces | **100%** |

Where one type bundles unrelated concerns, **every face depends on everything**. No inference pass
can fix this by being cleverer — the dependency is real. M3.4 must therefore either (a) track at
**leaf granularity** so that bundling is harmless, or (b) structurally discourage bundled state.
Option (a) is strictly better and is the recommendation: it makes the framework robust to a design
mistake the developer will inevitably make, rather than relying on them not making it.

### 2. Delegation inherits whole read-sets — MEASURED, AND RECOVERABLE

`prism_ss_is_usable(PrismSession)` reads **11/11 with direct = 0**. It touches no field itself; it
calls a helper and inherits that helper's entire read-set. Same for
`prism_app_dashboard_html` (16/16, direct 0).

This is **not a measurement artifact.** The fixed point unions a callee's whole read-set for the
matching parameter because it cannot slice by which part of the callee's result the caller actually
observes — and an implementable inference pass without value-level slicing has exactly the same
imprecision. So the over-approximation is representative of what M3.4 would really compute.

**This was originally recorded as M3.4's open risk. It has now been measured, and the answer is
that the cheapest available slicing technique recovers it** (`tools/m17_slicing.py`).

The helpers causing the inflation are **field-wise reconstructors** — `f(p: T, ...) -> T` whose body
is `T(p.f0, p.f1, …, expr, …)`, i.e. a functional "with"-style update. `_ss_advance` passes **10 of
11 fields through unchanged** and rewrites one. That is not a hard dataflow problem: result field
*i* flows from whatever arg *i* mentions — a direct field-to-field map. Across the corpus there are
**90 such reconstructors, with a mean 49% of fields passing through identically** (median 50%).

| | unsliced | sliced |
|---|---|---|
| `prism_ss_is_usable` | 11/11 | **4/11** |
| `prism_sy_flush_ready` | 9/9 | **2/9** |
| `prism_app_dashboard` | 16/16 | **9/16** |
| scaling slope | 0.255 (r²=0.11) | **0.146 (r²=0.07)** |

**Validation:** the slicer independently returns exactly the four fields derivable by hand from
`prism_ss_is_usable`'s source — `ss_access_sec`, `ss_status`, `ss_seen_ms`, `ss_expires_at`.

The aggregate mean barely moves (1.77 → 1.58 leaves) because most faces were already narrow —
**the tail is what matters.** A face reading 100% of state re-runs on every change, which is exactly
what destroys reactivity; those are the cases that collapse to 18–36%. And the scaling slope halves,
flattening further: slicing removes most of what little size-correlation remained.

**Consequence for M3.4:** the two required techniques are now both known-tractable — leaf-granular
tracking, and field-to-field flow through a reconstructor. Neither is research. The slicer here is
deliberately the simplest possible version (one level, syntactic, matching only
`let v = recon(p, …)`), so its numbers are an **upper bound** on the read-set: a real pass iterating
to a fixed point can only do better.

---

## WHAT WAS AND WAS NOT BUILT

**Not built:** the dependency-inference compiler pass. M1.7 was scoped at 3–4 weeks to build one
and measure it.

**Built instead:** a static read-set analyser over the existing 55k-line corpus
(`NOVA_DESIGN/tools/m17_readset.py`) that computes the same quantity — transitive read-set per face
over transitive reachable state — from source. This is a **proxy, not the compiler pass**, and it is
weaker in a specific way: it is syntactic, so reads behind a dict/list indirection are invisible to
it. It is stronger in a specific way too: it ran against a real 130-module corpus today rather than
against whatever toy program a from-scratch pass could have compiled in week four.

The measurement was worth doing first regardless of that trade, because it found that **the
milestone's pass/fail criterion was unusable**. Building the compiler pass first would have produced
a 35.9% reading, compared against a 30% threshold, and killed Bet 1 on an artifact of denominator
choice.

---

## REPLACEMENT CRITERION FOR M3.4

M1.7's ratio test is retired. The criterion that should gate M3.4:

> **Median read-set ≤ 3 leaves and mean ≤ 6 leaves, measured on an application whose state tree
> exceeds 100 reachable leaves, with leaf-granular tracking and slicing through callees enabled.**
> Additionally: no single face may read >25% of the tree. A violation localises to either a
> god-object (fix the state shape) or a slicing failure (fix the pass) — and the two are
> distinguishable by whether `direct` reads are 0.

Absolute, not fractional; median as the headline because the distribution has a long tail; and it
names which of the two failure modes a violation belongs to.

**This still requires a real application to measure.** The corpus is a library. Nothing about
Bet 1's behaviour at 100+ leaves is settled, and the next evidence step is an app with a deep state
tree — not more library modules.

---

## STATUS

- **T15 / M1.7:** evidence delivered, criterion revised, M3.4 unblocked with two named constraints —
  **both now measured as tractable.** Not closed as "compiler pass built" — see above.
- **M3.4:** may proceed. Required techniques: leaf-granular tracking + field-to-field flow through
  reconstructors. Both measured on the real corpus; neither is research. The remaining unknown is
  scale (>100-leaf state tree), not mechanism.
- **T16 GO/NO-GO:** Bet 1 is not the blocker it was assumed to be. The blocker is unchanged and
  stated in `PRISM_VS_REACT.md`: PRISM has no reactivity and cannot run in a browser (M0.3 runtime
  split). Owner call.
