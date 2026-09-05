# PRISM M3.4 — REACTIVITY: DESIGN

**Date:** 2026-09-04
**Status:** DESIGN ONLY. No compiler or runtime code. Implementation needs owner GO/NO-GO.
**Licensed by:** `M1_7_FALSIFIER_RESULT.md` (Bet 1 survives; two techniques measured tractable)
**Blocked behind:** T11 / M0.3 (runtime split) for the *browser* path only — the model below is
testable on the ANSI/HTML backends first, which is how it should be proven.

---

## 1. The problem, stated precisely

A face is a pure function `f(s: T) -> PrismNode`. A screen is many faces over one state tree. When
state changes, **which faces must re-run?**

Getting this wrong in either direction is fatal:
- Re-run everything ⇒ O(screen) work per keystroke. This is React's default, and the reason
  `memo`/`useMemo`/`useCallback` exist.
- Re-run too little ⇒ stale UI. A correctness bug, and the worst kind: intermittent and invisible
  in tests that re-render from scratch.

## 2. Why NOVA can do this statically when nobody else does

Every shipping framework tracks dependencies **at runtime**, and that is not a coincidence:

| Framework | Mechanism | Why not static |
|---|---|---|
| React | re-render subtree, diff a virtual DOM | JS components read arbitrary dynamic properties; no static read-set is derivable |
| Solid / Svelte 5 | signals — reads recorded via getters during execution | same; the wrapper *is* the tracking |
| Vue / MobX | observable proxies | same |

The blocker in all four is the host language: dynamic property access, mutable closure scope,
`eval`, and `any`-typed state make a static read-set undecidable in practice. **PRISM's faces are
different in four ways that together make static inference possible:**

1. State is an **immutable value**, not a mutable object graph.
2. Faces are **pure functions of their parameters** (PRISM axiom — no ambient state).
3. NOVA already runs **whole-program Hindley–Milner inference**, so every field access has a known
   type and a known owner.
4. There is no `eval` and no dynamic property naming on the common path.

**This is the actual novelty, and it is the answer to "why hasn't anyone tried this."** They have
not tried it because no mainstream UI framework's host language offers all four. It is not that
static inference was tried and failed; it is that it was never available.

**Consequence: PRISM pays zero runtime tracking cost.** Solid's fine granularity costs a getter on
every read plus a reactive wrapper on all state. PRISM's costs a compile-time pass and an integer
set-intersection per update. That is the performance case against Solid, and it is the one place
PRISM can beat the best reactive framework rather than tie it.

## 3. The mechanism

**Compile time.** For each face `f(s: T) -> Node`, compute `reads(f) ⊆ leafpaths(T)`:
- direct field reads `s.a.b`, at **leaf granularity** — required, because M1.7 measured that a
  god-object state type otherwise collapses granularity to 100% (`PrismCanvasCtx`: 88% mean,
  median 100%) and no amount of inference cleverness recovers it;
- transitively through callees, via the fixed point M1.7 prototyped;
- **sliced through field-wise reconstructors** — `g(p: T, …) -> T` returning `T(p.f0, p.f1, …)`.
  Result field *i* flows from arg *i*. M1.7 measured 90 such reconstructors in the corpus with a
  mean 49% identical pass-through, and slicing took `prism_ss_is_usable` from 11/11 leaves to
  **4/11**, matching a hand-derived answer.

**Runtime.** A state update produces a new immutable tree plus a **changeset**: the set of leaf
paths that differ. This is cheap precisely because updates are already functional reconstructions —
`_ss_advance` *knows* it replaced `ss_seen_ms` and passed ten fields through. The changeset is a
by-product of the update, not a diff.

**Invalidate** `f` iff `reads(f) ∩ changeset ≠ ∅`. Re-run only those faces.

Both sides are static integer sets, so the intersection is a bitmask AND — not a graph walk.

## 4. ⛔ The hard part: collections

**This is the one thing M1.7 did not measure, and it is where this design earns or loses.**

A `list` field is one leaf to the analyser (14% of reachable leaves in the corpus are
collection-backed). At runtime it is N elements. A face reading `s.rows` scores one leaf and
depends on all N rows — so naive leaf invalidation re-renders a 10,000-row table when one cell
changes. That is worse than React, which at least diffs.

Three candidate designs, and the tradeoff is real:

**(a) Path wildcards.** Read-set entries become `rows.*.name`. Changing row 3's `name` matches, so
the whole table re-runs. Simple, sound, and insufficient — it is the naive case above.

**(b) Keyed sub-faces (recommended).** A face that renders a collection is *structurally* a face
per element: `row_face(item)` applied over `rows`. Each element face gets its own read-set over the
element type, and the changeset carries `rows[key].name`. Invalidation then hits exactly one row
face. This is what React's `key` and Solid's `<For>` achieve — but here it is **derived from the
program's shape rather than requested by the developer**, which is the whole point of Bet 1.
Cost: the compiler must recognise "map a face over a collection" as a first-class pattern, and the
element type needs a stable identity (a key) to address the changeset. Requiring a key is
acceptable *only* if it is inferred where derivable and diagnosed clearly where not — "this
collection needs an identity to update incrementally; `id` looks like one" beats React's silent
index-key correctness trap.

**(c) Runtime granularity for collections only.** Static for scalars, signal-style tracking for
collection elements. Hybrid, and honest about the fact that the static approach's weak point is
exactly the dynamic one's strong point. Falls back to Solid's per-read cost, but only for
collections.

★ **UPGRADED TO REQUIRED 2026-09-05 — on COST, not read-set size.** Modelling this on the 109-leaf console app (`tools/m34_keyed_subfaces.py`) showed the reason first given here (read-set size) was the metric M1.7 had just retired, and that fan-out passes with or without keying. The real argument is **invalidated WORK** (`M1_7_FALSIFIER_RESULT.md` §CRITERION): without keying, editing one comment re-runs `prism_con_selected_project`, which walks every project × issue × comment — **O(rows), unbounded in collection size**. With keying it re-runs one comment face, O(1). Marginal read-set mean 8.15 → 2.85, max 51 → 13; `selected_project` 51 → 1, `project_list` 32 → 0. That is a categorical difference, not a constant factor, and it is the one place PRISM would otherwise lose outright to React — which at least diffs its output. §4(b) is **load-bearing.**

**Recommendation: (b), with (a) as the sound fallback when a key cannot be inferred, and (c)
explicitly rejected** — a hybrid means two dependency systems, two failure modes, and two mental
models, which violates "one obvious way" and is how frameworks become C++.

### §4b measured against the corpus (2026-09-04)

Before designing key inference, I measured whether the pattern it depends on actually occurs.

**Getting the population right mattered, exactly as it did in M1.7.** A first pass found 132
"per-element faces" of which only **8%** read a key-ish field — apparently fatal. But that
population included `for sep in ["/", "\\"]` and loops over characters, where a key is meaningless.
Restricted to loops whose element is a **struct** (the body reads a declared field of it), the real
population is **43 faces**, and:

| | count | |
|---|---|---|
| element type resolvable from the read-set alone | **42/43** | key inference has something to work with |
| ...whose type carries an identity field (`id`/`key`/`name`/`slug`/`code`/`label`/`title`) | **26** | **62% directly keyable** |
| ...lacking any identity field | 16 | falls back to §4(a) |

**The 38% without an identity field are mostly POSITIONAL collections, where the index genuinely
*is* the identity** — `rt_seg_*` (route segments: segment 0, 1, 2 — the order *is* the meaning),
`a11y_*` findings, `gd_issue_*` audit issues. React's index-key trap is specifically about
**reordering and insertion**; a positional list that is rebuilt wholesale from a parse is not
subject to it, so index-keying those is correct rather than a compromise.

So key inference has three tiers, and only the third is a real loss:
1. **natural key present** — 62% of struct collections;
2. **positional, rebuilt wholesale** — index-keyed soundly, covering most of the remainder;
3. **genuinely unkeyable and reorderable** — falls back to §4(a) whole-collection invalidation,
   and must emit a diagnostic naming the collection, because this is the case where PRISM would
   silently re-render a large table.

**This does not settle §4** — it shows the pattern is present and mostly keyable in a *library*.
The load-bearing test is still a real table over a large collection, which is step 3 of §8.

## 5. Failure hunt — where this breaks

| Case | Static read-set | Consequence | Verdict |
|---|---|---|---|
| Conditional read `if s.a then s.b else s.c` | `{a,b,c}` | spurious re-run when `c` changes | **Acceptable** — over-approximation, still 3 leaves |
| Dynamic index `s.items[i].x` | `items.*.x` | see §4 | **The real problem**; §4(b) is the answer |
| Face takes `any` | undecidable | must assume "reads everything" ⇒ re-runs always | **Sound but useless.** This is a hard argument for the standing project law that `any` is only for genuinely dynamic data |
| Higher-order face (takes a fn) | depends on the passed closure | conservative union over all call sites, or specialise per site | **Open.** Specialisation is the right answer and needs measuring |
| Face reads a module-level `let` | not a parameter, so invisible | stale UI — a **correctness** bug, not a perf bug | ⛔ **Must reject at compile time.** A face reading mutable module state is unsound and must be an error, not a warning |
| Recursive state (tree of nodes) | cycle-safe closure gives finite paths | coarse over depth | Acceptable; same as §4 |

★ **A gap the original hunt missed: AGGREGATES.** `prism_con_stat_row` counts across every element of a collection (50 of 52 leaves). Keying cannot reduce it — an aggregate genuinely depends on every element, so any insert, delete or field change invalidates it. Keyed sub-faces solve *per-row rendering*; they do nothing for *fold over all rows*. Making that incremental needs a separate mechanism (maintain the aggregate as state and update it from the changeset, i.e. incremental view maintenance), which this design does **not** currently address. Every realistic dashboard has counts and totals, so this is not an edge case — it is the next design question after §4.

**The one that must not be waved away is the module-level `let`.** Every other row costs
performance; that row costs correctness, silently. PRISM already has the mechanism to catch it —
faces are declared, so the pass can prove a face's inputs are exactly its parameters and reject
otherwise.

## 6. Competitive scorecard

| Property | React | Solid / Svelte 5 | PRISM (this design) |
|---|---|---|---|
| Dependency tracking cost at runtime | none (re-renders instead) | getter per read + reactive wrapper | **none — compile-time** ✅ |
| Granularity | component subtree | per-signal | **per state leaf** ✅ |
| Annotation burden | `memo`/`useMemo`/`useCallback`/`key` | runes / signals / `<For>` | **zero for scalars**; key inferred or diagnosed for collections ✅ |
| Collections | `key` (silent index-key trap) | `<For>` | inferred keyed sub-faces; **explicit diagnostic** when not derivable ✅ |
| Stale-UI risk | low (re-renders everything) | real (untracked async reads) | **rejected at compile time** ✅ |
| Escape hatch to dynamic state | ubiquitous | ubiquitous | `any` ⇒ degrades to always-re-run ⚠️ **loses** |
| Proven at scale | 10+ years, millions of apps | years, large apps | **zero apps** ⛔ **loses decisively** |

Two honest losses. The `any` fallback is a real regression versus a runtime tracker, which handles
dynamic state natively. And "zero apps" is not a detail — every row above is a design claim, and
none of it is evidence until a real application runs on it.

## 7. What would prove this WRONG

Falsifiable, in order of cost:

1. **Read-sets do not stay small on a nested >100-leaf app state tree.** Measured directly by
   `tools/m17_readset.py` on `prism_app_console` (in progress). Criterion: median ≤3 / mean ≤6
   leaves, no face >25%.
2. **Keyed sub-faces cannot be inferred** for a realistic table/list without developer annotation.
   Then §4 degrades to (a) and PRISM loses to React on the most common UI shape.
3. **Higher-order faces force a conservative union that swamps the read-set.** If specialisation is
   not tractable, HOF-heavy code loses granularity — and HOFs are mandated project style, so this
   would be self-inflicted.
4. ~~**Changeset construction is not cheap.**~~ ✅ **MEASURED 2026-09-04 — not a risk.** The design
   assumes a functional update knows which fields it replaced. Over the 90 reconstructors in the
   corpus, the changeset (fields *not* passed through identically) is **median 1 field, mean 1.99,
   and ≤2 fields for 88% of them**:

   | fields changed | 0 | 1 | 2 | 3 | ≥6 |
   |---|---|---|---|---|---|
   | reconstructors | 8 | **47** | 24 | 2 | 8 |

   Two notes on reading this. The *fractional* form says "51% of fields change", which is the same
   small-denominator artifact M1.7 exposed — a 2-field change on a 4-field type is 50%. Absolute is
   the meaningful measure. And the 8 wide outliers are **detector artifacts, not wide updates**:
   `prism_ss_begin_refresh` shows 11/11 because it constructs from `adv` (the result of
   `_ss_advance(s, now_ms)`) rather than from `s`, so no argument matches `s.field`. Its true
   changeset is 3 fields — `ss_status`, `ss_inflight_since`, `ss_seen_ms`. Composing reconstructors
   transitively removes these, so **1.99 is an upper bound; the real mean is lower.**

## 8. Recommended sequence (if GO)

1. **Measure on `prism_app_console`** — the M1.7 scale question. Cheap, and gates everything.
2. **Prototype the pass out-of-tree**, as `tools/m17_readset.py` already is. No compiler edit until
   the numbers hold on a real app.
3. **Design keyed sub-face inference** (§4b) against a real table before writing any of it.
4. **Reject faces reading module state** — smallest, highest-value correctness gate; independently
   useful even if reactivity is deferred. Split in two, because only the second half touches the
   compiler:
   - ✅ **detection — DONE**, `tools/m34_face_purity.py`, exit-code gated. Result over all 130
     modules: 21 declare a module-level `let`, 41 function-to-binding references, **0 mutating** —
     every one is a read-only constant — and **0 computed initialisers** (the separate known
     import-zero defect class). **The library is structurally compatible with this design today**,
     which also means the enforcement gate can be added without first fixing violations.
   - ⬜ enforcement in the compiler — a rejection, not a warning. Needs GO.
5. Only then: compiler pass, RED tier, full arc (reconverge + both memory modes).

Steps 1–3 and 4(detection) need no compiler change and no GO. **Step 4(enforcement) and step 5
do.**

---

## 9. Aggregates — incremental view maintenance

§5 identified aggregates as the gap keyed sub-faces cannot close: `prism_con_stat_row` reads 50 of
52 leaves because it *folds over every element*, so any insert, delete or field change invalidates
it. Keying fixes per-row rendering; it does nothing for a fold. This section designs the mechanism.
**Whether to build it is gated on measurement** (`tools/m34_aggregates.py`) — see §9.5.

### 9.1 Prior art, and why no frontend framework does this

| System | Approach | Relevance |
|---|---|---|
| Materialized views (Oracle, PG) | maintain the view, apply deltas | The classic result below comes from here |
| Differential Dataflow / DBSP (Materialize, Feldera) | Z-sets with multiplicities; aggregates as deltas | Strongest theory; proven at scale in databases |
| Adapton / self-adjusting computation | general incremental recomputation | General, but high constant factor per node |
| React / Solid / Vue / MobX | **none — the fold is recomputed in full** | A `computed` count over 10k rows re-runs entirely |

**No mainstream UI framework maintains aggregates incrementally.** Solid's memo avoids recomputing
when inputs are unchanged, but when one row *does* change it re-folds all N. So this is a genuine
differentiator — and also a warning: the reason nobody ships it is that the general case is
complex, and complexity is the thing PRISM must not accumulate.

### 9.2 The classical result that makes it tractable

An aggregate is **self-maintainable** iff its combining operator forms a **group** — associative,
with an identity and an **inverse**. The inverse is what lets a departing element be subtracted
without rescanning.

| Class | Examples | Insert | Delete |
|---|---|---|---|
| **Group** | `count`, `sum`, XOR-fold | O(1) | **O(1)** — subtract |
| **Semigroup only** | `min`, `max` | O(1) — compare | **O(N) rescan** when the current extreme leaves |
| **Holistic** | median, percentile, distinct-count, top-N | — | no bounded update |

This three-way split is not a heuristic; it is a property of the operator, so the compiler can
classify a recognised fold **statically and with certainty**, which is exactly what a
zero-annotation design needs.

### 9.3 Mechanism, and its dependency on §4

For a recognised fold `agg(op, xs, f)`:

1. Maintain the aggregate's current value as derived state beside the collection.
2. On a changeset entry for element `E` field `F` (`v → v'`), apply the delta:
   `count` → `p(E') - p(E) ∈ {-1, 0, +1}`; `sum` → `f(E') - f(E)`.
3. `min`/`max`: update on insert and on a non-extreme change; **rescan only** when the current
   extreme is removed or worsened.
4. Holistic: no incremental path — rescan, and **emit a diagnostic** so the developer knows that
   particular readout is O(N) per change rather than discovering it as jank.

⛔ **This depends on §4(b), and that ordering is not optional.** Computing a delta requires knowing
*which element* changed — i.e. element identity. Without keyed collections the changeset says only
"something under `rows` changed", which is precisely the information a delta cannot be derived
from. **Keyed sub-faces are a prerequisite for incremental aggregates, not a parallel feature.**

### 9.4 Failure hunt

| Case | Consequence | Handling |
|---|---|---|
| **Insert / delete** changes the *collection*, not a leaf | §3's changeset carries leaf paths only, so a structural edit is invisible | ⛔ **Extends §3**: the changeset must also carry structural deltas (element added / removed, with key) |
| **Predicate reads other state** — `count(issues where status == s.filter)` | changing `filter` invalidates the whole count | Correct and unavoidable: the aggregate's dependencies include its predicate's free variables. Full rescan, and it is *rare* — a filter change is a deliberate user action, not a data tick |
| **Float `sum`** | subtracting on delete accumulates rounding error | Real: databases hit this. Periodic full recomputation, or restrict incremental `sum` to integers. **Integer-only is the right v1** — silently drifting totals are worse than an O(N) recount |
| Fold not statically recognised | falls back to full recompute | Sound, and the honest default |
| Nested aggregate (count of projects whose issue-count > 0) | delta must propagate through two levels | Deferred. Compose only if the measurement shows nested aggregates actually occur |

### 9.5 Is it worth building? — gated on data

The mechanism above is sound, but it is **new machinery**, and this project's design principles say
a feature must justify itself against the complexity it adds. The deciding question is empirical:
**how many faces are aggregates, and what share are group-class (the cheap, high-value case)?**

- If aggregates are rare and mostly holistic → **do not build this.** Diagnose the O(N) readouts
  and move on; `stat_row` alone does not justify incremental view maintenance.
- If aggregates are common and mostly `count`/`sum` → build **Tier 1 only** (group class over keyed
  collections). That is a small, closed, statically-decidable mechanism covering the dashboard case
  every real app has.
- Tiers 2 (min/max) and 3 (holistic) are **not** v1 under any outcome — semigroup rescan-on-delete
  and holistic folds add real complexity for cases the data is unlikely to show as hot.

Measurement pending; the verdict is recorded here when it lands rather than assumed now.
