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
| **Reactivity — there is NONE** | `prism_exp_readsets_available()` returns **false** | **M3.4**, gated on **M1.7 (the Bet-1 falsifier)** |
| **Cannot run in a browser** | no DOM backend, no WASM closures | **T11 / M0.3 runtime split** → T12, T14 |
| **Ecosystem** | zero third-party components | decade-scale; explicitly out of scope |
| **DevTools / Fast Refresh** | none | after M0.3 |
| **Hiring pool** | zero | n/a |

### The one that matters

**React's entire value proposition is "state changes → the right thing re-renders."** PRISM does
not have that yet. It has a node tree, six output backends, an event model, a journal, and a
testing story — all of which are *better* than React's equivalents — but the loop that makes a UI
framework a UI framework is unbuilt and is gated on a **falsifier that has not been run**.

M1.7 exists precisely because zero-annotation reactivity may be impossible: if the measured
read-set per face exceeds 20–30% of reachable state, Bet 1 is dead and the design must change.
**Building more library modules does not move this.** `app/` (route, form, wire, guard, …) is
genuinely useful Tier-2 work, but every one of those modules will sit on top of whatever
reactivity model M1.7 permits — and none of them tests the bet.

---

## 3. What "better than React" actually requires

Three things, in dependency order. Nothing else is on the critical path.

1. **M1.7 — run the falsifier.** 3–4 weeks. Build ONLY the dependency-inference pass and measure
   the read-set. Cheapest experiment that can invalidate the most work: if Bet 1 is dead, we learn
   it before writing the reactivity layer, not after.
2. **M0.3 — the runtime split.** 6–10 weeks, RED tier, full arc. Without it PRISM cannot execute in
   a browser, and "better than React" is not assessable by anyone who would compare them.
3. **M3.4 — reactivity**, in whatever form M1.7 licenses.

Everything currently green — six library layers, 120 modules, 117 KATs, ~49.5k lines — is real and
is a genuine advantage on correctness. It is not a substitute for the three items above.

---

## 4. The honest one-line answer

> **PRISM is already better than React at every property React can only express as a convention.
> React is better than PRISM at being a UI framework that runs in a browser today.**

The second half is closed by M1.7 → M0.3 → M3.4, and by nothing else.
