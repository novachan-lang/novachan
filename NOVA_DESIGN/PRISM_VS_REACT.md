# PRISM vs React — an honest scorecard (2026-09-04)

Written because the owner's target is "PRISM must be better than React". That is achievable, but
only if we are precise about *at what*, because on today's numbers PRISM already beats React
decisively on one axis and **cannot run in a browser at all** on another. Both are true.

---

## 1. Where PRISM ALREADY beats React — and why React structurally cannot catch up

These are not aspirations. Every row is built, KAT-gated, and verified in this repo.

| Property | React | PRISM | Why React cannot simply fix it |
|---|---|---|---|
| **a11y role** | hand-written `role="button"`; `<div onClick>` compiles fine and is unusable by keyboard/AT | **DERIVED from the widget type** (`prism_node_role_of`, §9) — one derivation, used by query, audit and backends | React's element vocabulary is open (`div`), so no role can be derived. Fixing it means closing the vocabulary — i.e. becoming PRISM |
| **Captions on video** | optional prop | **UNREPRESENTABLE without them**; the escape hatch is named `prism_md_video_no_captions` and demands a reason | An optional prop cannot be made required without breaking every existing call site |
| **Autoplay with sound** | convention + browser policy | **constructor-enforced**, and unmuting CLEARS autoplay so the pair is unreachable backwards | Same |
| **Output targets** | one implementation per target — a chart needs a browser lib AND a server PDF lib | **ONE tree → HTML, ANSI, canvas, PDF, CSV, PNG** | React's model is DOM-shaped; non-DOM targets are re-implementations |
| **Visual regression** | flaky screenshots, per-platform baselines, tolerance thresholds that hide real regressions | **byte-reproducible renders → EXACT sha256, zero tolerance** | Determinism must hold in the renderer; the DOM/GPU/font stack does not provide it |
| **Test queries** | `getByRole` is *best practice*, easy to bypass with test-ids | query by DERIVED role, and **0 matches AND >1 match are BOTH errors** | Convention vs construction |
| **Secrets in telemetry/crash** | discipline ("don't log PII") | **structurally absent** — a crash step is a 2-field value with no field that *could* hold a payload | A JS object can always hold anything |
| **Ambiguity** | first match wins, silently | **rejected**: two same-shape routes, two identically-labelled buttons | Would break existing apps |
| **Component sprawl** | unbounded | **closed 22-primitive vocabulary** (A7); 67 `ui/` components are compositions, not new primitives | Cannot close an open vocabulary retroactively |

**The pattern:** React expresses these as *conventions, lint rules and best practices*. PRISM
expresses them as *types and constructors*. A lint rule is advisory; a constructor that refuses to
build the bad state is not. That difference is not something React can retrofit, because its
element vocabulary is open by design.

---

## 2. ⛔ Where PRISM LOSES TODAY — and the honest size of the gap

| Gap | Status | Blocking |
|---|---|---|
| **Reactivity — there is NONE** | `prism_exp_readsets_available()` returns **false** | **M3.4** — **M1.7 gate CLEARED 2026-09-04** |
| **Cannot run in a browser** | no DOM backend, no WASM closures | **T11 / M0.3 runtime split** → T12, T14 |
| **Ecosystem** | zero third-party components | decade-scale; explicitly out of scope |
| **DevTools / Fast Refresh** | none | after M0.3 |
| **Hiring pool** | zero | n/a |

### The one that matters

**React's entire value proposition is "state changes → the right thing re-renders."** PRISM does
not have that yet. It has a node tree, six output backends, an event model, a journal, and a
testing story — all of which are *better* than React's equivalents — but the loop that makes a UI
framework a UI framework is still unbuilt.

**M1.7 has now been run (2026-09-04) and Bet 1 is not dead** — see
`M1_7_FALSIFIER_RESULT.md`. Two findings changed the plan:

* **M1.7's own kill criterion was invalid.** It compared a *ratio* against 20–30%, but PRISM's
  state types average 5 reachable leaves, so a face reading **one single field already scores
  20%**. Measured absolutely, the median face reads **1 leaf** and the mean **1.87** — exactly the
  granularity Bet 1 needs. Had the compiler pass been built first, it would have reported 35.9%
  and killed Bet 1 on a denominator artifact.
* **The one genuine risk — a face inheriting a helper's whole read-set — is recoverable.**
  `prism_ss_is_usable` reads 11/11 leaves while touching no field itself; constructor slicing
  brings it to **4/11**, the same answer derivable by hand. Both techniques M3.4 needs
  (leaf-granular tracking, field-to-field flow through a reconstructor) are now measured
  tractable. Neither is research.

**What remains unknown is SCALE, not mechanism.** The corpus is a library; its deepest app-state
type is 16 *flat* leaves. Whether read-sets stay ~1–2 leaves on a >100-leaf nested application
tree is the open question, and it needs a real app — not more library modules.

---

## 3. What "better than React" actually requires

Three things, in dependency order. Nothing else is on the critical path.

1. ~~**M1.7 — run the falsifier.**~~ ✅ **DONE 2026-09-04**, and not in 3–4 weeks: a static
   read-set analyser over the existing 55k-line corpus answered it in one session, and caught that
   the milestone's own pass/fail criterion was unusable. Bet 1 survives; the residual question is
   scale, which needs an app with a nested state tree.
2. **M0.3 — the runtime split.** 6–10 weeks, RED tier, full arc. Without it PRISM cannot execute in
   a browser, and "better than React" is not assessable by anyone who would compare them.
3. **M3.4 — reactivity**, in whatever form M1.7 licenses.

Everything currently green — six library layers plus `app/`, **130 modules, 127 KATs, ~55.1k
lines** — is real and is a genuine advantage on correctness. It is not a substitute for the items
above.

---

## 4. The honest one-line answer

> **PRISM is already better than React at every property React can only express as a convention.
> React is better than PRISM at being a UI framework that runs in a browser today.**

The second half is closed by ~~M1.7~~ → **M0.3** → **M3.4**, and by nothing else. M1.7 is cleared;
M0.3 (the runtime split, RED tier) is now the single blocker on the browser path.
