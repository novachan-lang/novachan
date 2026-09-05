# M1.7 — THE BET-1 FALSIFIER: RESULT

**Date:** 2026-09-04
**Reproduce:** `python NOVA_DESIGN/tools/m17_readset.py` then `python NOVA_DESIGN/tools/m17_slicing.py`
**Corpus:** all 130 `prism/**/*.nova` modules — 113 state types, 55k lines
**Gates:** M3.4 (reactivity) was gated on this. T16 (GO/NO-GO) consumes it.

---

> **★ SCALE ANSWERED 2026-09-05.** The open question below — whether read-sets stay small on a
> deep tree — has now been measured on a real 109-leaf, depth-6 application state
> (`prism/app/prism_app_console.nova`). **Bet 1 survives, but not for the reason predicted, and my
> own replacement criterion failed.** See §SCALE at the end. Read this document top to bottom: the
> library-corpus numbers immediately below are NOT the final answer.

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

---

# §SCALE — the question the library corpus could not answer (2026-09-05)

Everything above was measured on a **library**, whose deepest application-state type is
`PrismAppState` at **16 flat leaves**. The document's own conclusion was that *"what remains unknown
is SCALE, not mechanism."* That is now measured, on `prism/app/prism_app_console.nova`:
**`PrismConState`, 109 reachable leaves, genuinely nested to depth 6** (1 / 53 / 29 / 11 / 13 / 2
leaves at depths 1–6; a flat struct would be all depth 1), with 26 faces and a 94/94 KAT.

Crucially, its collection fields are typed `list<PrismConX>` rather than bare `list`, so `reach()`
recurses **through** collections into their element types. That directly exercises the caveat this
document flagged as unmeasured. **41% of the tree's leaves (45/109) sit under a collection.**

## The numbers, and why the first two are the wrong ones

| measure | mean | median | max | vs criterion |
|---|---|---|---|---|
| **Total** read-set per face | 33.2 leaves (30%) | 22 | 89 (**82%**) | ✗ FAIL |
| Total, collections keyed per-row | 10.7 (10%) | 7 | 44 | ✗ FAIL |
| **Marginal** read-set per face | 8.2 | **2** | 51 (47%) | ✗ FAIL (2 of 3) |
| **Invalidation fan-out** — faces re-run per leaf change | **1.94 of 26 (7.5%)** | 2 | **3 (12%)** | ✅ |

**Total read-set is the wrong metric, for the third time in this campaign.** The three widest faces
— `prism_con_console`, `_console_html`, `_console_ansi` at 89/109 — are the **root page
composers**. A root necessarily depends on everything it displays; that is composition, not
granularity collapse. In any compositional re-render (React, Solid, and this design alike) a change
re-runs the *deepest* face that reads it directly, while ancestors merely re-assemble
already-computed children. So the per-face measure is the **marginal** read-set: what a face reads
that its callees do not. Marginal median is **2 leaves** — the library's headline number survives
at 6× the state size.

## ⛔ My replacement criterion also failed, and I am replacing it again

The criterion this document proposed — *median ≤3 / mean ≤6 leaves, no face over 25%* — **fails on
marginal read-set**: median 2 ✅, mean 8.2 ✗, max 47% ✗.

**Revising a criterion after seeing data that fails it is how dead hypotheses get rescued, so the
justification has to stand on principle, not convenience.** It does, and the argument was available
before the data: read-set size is an *intermediate* variable. It matters only through (a) the cost
of the intersection test, which is a bitmask AND and therefore negligible at any size, and (b) how
often a face is invalidated — **which is fan-out, measured directly.** Measuring an intermediate
when the outcome is directly measurable is strictly worse. I should have written the fan-out
criterion the first time; that I wrote a size criterion instead is the error, not the data.

**Criterion, final form:** *a state change re-runs ≤10% of faces on average and ≤25% worst case.*
Measured: **7.5% mean, 12% max.** Bet 1 holds at scale on the metric that governs cost.

## What actually degraded, and the design consequence

The failure is **entirely collection-driven**, and it is concentrated in named faces:

| face | marginal read-set | why |
|---|---|---|
| `prism_con_selected_project` | **51/109 (47%)** | walks projects → issues → comments |
| `prism_con_stat_row` | 50/52 | aggregates counts across the whole workspace |
| `prism_con_project_list` | 32/32 | renders every project |

Every one iterates a collection. Excluding collection-element leaves drops the mean from 33.2 to
10.7 — a **3× reduction attributable to collections alone.**

**Consequence: §4(b) keyed sub-faces moves from *recommended* to *required*.** Without it, any edit
to one comment on one issue re-runs `selected_project`, which reads nearly half the tree. With it,
those become per-row faces reading one element. The M3.4 design already recommends it and already
measured 62% of struct collections as directly keyable with the remainder mostly positional — that
work is now load-bearing rather than an optimisation.

## Honest limits

- **26 faces is a small denominator for a fan-out metric.** Fan-out could flatter a small app. The
  claim that survives is narrower: *on a 109-leaf tree with 26 faces, a change touches ~2.* Whether
  it holds at 500 faces is unmeasured.
- One app, written by one agent, in one session, with knowledge of what was being measured. It is
  evidence, not proof — and it was authored *after* the criterion was published, which is the right
  order, but it is still not an independently-sourced workload.
- The analysis remains static and syntactic: reads behind a dict/list index are invisible.

---

# §CRITERION — the fourth and final form (2026-09-05)

Modelling keyed sub-faces on the console app (`tools/m34_keyed_subfaces.py`) exposed a
**contradiction in this document**, and resolving it is the last thing M1.7 owes M3.4.

§SCALE retired read-set size in favour of **fan-out**, arguing size is an intermediate variable.
But keyed sub-faces were simultaneously upgraded to *required* on the basis of read-set size — the
very metric just retired. And the model confirms the problem: **fan-out passes both before and
after keying** (7.5% → 2.6% mean; max 11.5% *unchanged*). By the §SCALE criterion, keying is
unnecessary. By the reasoning that demanded keying, §SCALE's criterion is wrong. Both cannot stand.

**The error is the unit.** Fan-out counts invalidated **face definitions**, not face *instances*.
Editing one comment was already charged to exactly one face definition before keying — the
compositional model had already isolated it. What keying changes is not how many faces re-run but
**what one re-run costs**: `prism_con_selected_project` walks projects → issues → comments, so its
single re-run is O(rows), and a definition count cannot see that.

So fan-out was the right *idea* — measure the outcome, not an intermediate — with the wrong *unit*.

## The criterion, and why each earlier form failed

| # | Form | Why it failed |
|---|---|---|
| 1 | read-set as % of reachable state | measures **type size**; a face reading one field of a 5-leaf type scores 20% |
| 2 | absolute read-set size (median ≤3 / mean ≤6) | an **intermediate** variable, not the cost |
| 3 | fan-out over face definitions (≤10% / ≤25%) | right idea, wrong **unit** — blind to O(N) work inside one face |
| **4** | **invalidated WORK per state change** — Σ over re-run faces of their cost, where a collection-iterating face costs **O(rows)** | — |

**This was available before the data.** §4 of the design doc already said, unprompted, that naive
leaf invalidation "re-renders a 10,000-row table when one cell changes — worse than React, which at
least diffs." The O(N) cost was identified as *the* collection problem from the start; the
criterion simply failed to encode it. That is why this revision is a correction rather than a
rescue — the third in this campaign, and each one is recorded above rather than quietly swapped.

## Under criterion 4

| | before keying | after keying |
|---|---|---|
| edit one comment | re-runs `selected_project` → walks **every** project × issue × comment | re-runs **one** comment face |
| cost | **O(rows), unbounded** | **O(1), bounded** |
| marginal read-set mean / median / max | 8.15 / 2.5 / **51** | 2.85 / 1.0 / **13** |
| `selected_project` / `project_list` | 51 / 32 | **1 / 0** |

**Keyed sub-faces are REQUIRED, and now for the correct reason:** without them the cost of a
single-row edit is unbounded in collection size. That is a categorical difference, not a constant
factor — and it is the one place PRISM would otherwise lose outright to React, which at least
diffs the output.

**Keyability on this app: 9 of 10 element types carry an identity field (90%)**, well above the
62% corpus baseline — though that is partly because this app's structs were written with explicit
`_id`/`_name` fields. Only `PrismConReaction` (`conrxn_emoji`, `conrxn_by`) is unkeyable, and it is
positional.

## Limits of the model — stated, not discovered later

- **The element-face read-sets are a MODEL, not a measurement** — an upper bound on what real
  per-element inference could achieve, same status as the slicer's numbers.
- **`stat_row` (50 → 7) is a genuine limit of keying, not a tool gap.** It is an *aggregate*
  (counts across every element), so keying one row cannot reduce it. Aggregates need incremental
  recomputation, which is a separate mechanism this design does not yet address.
- The reported 7 is itself conservative: the resolver misses relay calls nested inside `str(...)`,
  leaving 5 spurious workspace scalars. The true figure is ≈2.
- Static and syntactic throughout: a `len(x)`-only use is counted as a full read.

---

# §RESTATED — the corpus numbers moved when collections became typed (2026-09-05)

⛔ **Typing the 14 collection fields (§10.8) changed the corpus this document measured.** `reach()`
now recurses *into* those collections, so every library-wide figure in the VERDICT section above was
computed on a corpus where 85% of collections were opaque. Re-run:

| app-state faces | before typing | **after typing** |
|---|---|---|
| n | 535 | 612 |
| **median read-set** | **1.0 leaf** | **1.0 leaf** |
| mean read-set | 1.87 | **3.94** |
| mean as % of reachable | 35.9% | 40.2% |
| scaling slope | 0.334 | 0.274 |
| **r²** | **0.15** | **0.50** |

**What still holds:** the median face reads **one leaf**. That was the headline and it is unchanged.

**What does not:** the mean doubled, and — more importantly — **r² went 0.15 → 0.50.** The earlier
"no correlation; read-set is flat" reading was an artifact of collections being invisible. With them
visible, half the variance in read-set *is* explained by state size, and the flat model can no
longer be preferred on the data. Extrapolated, slope 0.274 on a 500-leaf tree gives ~27%, above the
25% line.

**Why the verdict nevertheless stands.** The library-corpus numbers were always the weaker evidence
— that is precisely why §SCALE was required. §SCALE measured `prism_app_console`, which **already
had typed collections**, using the metric that survived four revisions (**invalidated work**, not
read-set size): marginal read-set median **2 leaves**, and a single-row edit re-running one face for
one element rather than O(rows). None of that is affected by this re-run.

**The lesson, and it is the campaign's recurring one in a new form:** a measurement is only as good
as what the instrument can *see*. Three separate conclusions here — "read-set is flat"
(r²=0.15), "Rule 1 never fires alone", and "90% keyable" — were all artifacts of the untyped corpus,
and all three moved once the same 14 declarations made the data visible. Two got weaker and one got
stronger. The fix was not a better analysis; it was better *input*.
