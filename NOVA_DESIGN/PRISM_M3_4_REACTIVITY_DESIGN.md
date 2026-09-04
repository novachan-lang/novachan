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

**Recommendation: (b), with (a) as the sound fallback when a key cannot be inferred, and (c)
explicitly rejected** — a hybrid means two dependency systems, two failure modes, and two mental
models, which violates "one obvious way" and is how frameworks become C++.

## 5. Failure hunt — where this breaks

| Case | Static read-set | Consequence | Verdict |
|---|---|---|---|
| Conditional read `if s.a then s.b else s.c` | `{a,b,c}` | spurious re-run when `c` changes | **Acceptable** — over-approximation, still 3 leaves |
| Dynamic index `s.items[i].x` | `items.*.x` | see §4 | **The real problem**; §4(b) is the answer |
| Face takes `any` | undecidable | must assume "reads everything" ⇒ re-runs always | **Sound but useless.** This is a hard argument for the standing project law that `any` is only for genuinely dynamic data |
| Higher-order face (takes a fn) | depends on the passed closure | conservative union over all call sites, or specialise per site | **Open.** Specialisation is the right answer and needs measuring |
| Face reads a module-level `let` | not a parameter, so invisible | stale UI — a **correctness** bug, not a perf bug | ⛔ **Must reject at compile time.** A face reading mutable module state is unsound and must be an error, not a warning |
| Recursive state (tree of nodes) | cycle-safe closure gives finite paths | coarse over depth | Acceptable; same as §4 |

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
4. **Changeset construction is not cheap.** The design assumes a functional update knows which
   fields it replaced. If the compiler cannot derive that, the changeset needs a tree diff and the
   runtime advantage over React narrows.

## 8. Recommended sequence (if GO)

1. **Measure on `prism_app_console`** — the M1.7 scale question. Cheap, and gates everything.
2. **Prototype the pass out-of-tree**, as `tools/m17_readset.py` already is. No compiler edit until
   the numbers hold on a real app.
3. **Design keyed sub-face inference** (§4b) against a real table before writing any of it.
4. **Reject faces reading module state** — smallest, highest-value correctness gate; independently
   useful even if reactivity is deferred.
5. Only then: compiler pass, RED tier, full arc (reconverge + both memory modes).

Steps 1–4 need no compiler change and no GO. **Step 5 does.**
