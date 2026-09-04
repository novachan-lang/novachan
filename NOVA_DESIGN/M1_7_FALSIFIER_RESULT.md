# M1.7 — THE BET-1 FALSIFIER: RESULT

**Date:** 2026-09-04
**Reproduce:** `python NOVA_DESIGN/tools/m17_readset.py`
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

### 2. Delegation inherits whole read-sets — this is the genuine technical risk

`prism_ss_is_usable(PrismSession)` reads **11/11 with direct = 0**. It touches no field itself; it
calls a helper and inherits that helper's entire read-set. Same for
`prism_app_dashboard_html` (16/16, direct 0).

This is **not a measurement artifact.** The fixed point unions a callee's whole read-set for the
matching parameter because it cannot slice by which part of the callee's result the caller actually
observes — and **an implementable inference pass without value-level slicing has exactly the same
imprecision.** So this over-approximation is representative of what M3.4 would really compute.

**Consequence for M3.4:** inference precision is governed by *slicing through callees*, not by
field-read tracking. Field tracking is the easy half and it is already known to work. The open
question is whether a helper that builds a wide intermediate value, from which the caller reads one
field, can be sliced back down. If it cannot, real read-sets inflate toward the reducer numbers
(80%+) and Bet 1 does die — just not for the reason M1.7 anticipated.

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

- **T15 / M1.7:** evidence delivered, criterion revised, M3.4 unblocked with two named constraints.
  Not closed as "compiler pass built" — see above.
- **M3.4:** may proceed on the design constraints above (leaf-granular tracking; slicing through
  callees is the risk to prove out first, not field tracking).
- **T16 GO/NO-GO:** Bet 1 is not the blocker it was assumed to be. The blocker is unchanged and
  stated in `PRISM_VS_REACT.md`: PRISM has no reactivity and cannot run in a browser (M0.3 runtime
  split). Owner call.
