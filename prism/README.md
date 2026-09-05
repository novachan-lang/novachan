# NOVA Prism

Prism is NOVA's presentation-layer framework — **Framework #5 of the 9 designated frameworks**
in `NOVA_DESIGN/FRAMEWORK_ECOSYSTEM_STRATEGY.md` (Forge, Cortex, Pulse, Mesh, Sentinel, Ops,
Reactor, **Prism**, Edge). A **v0.1** (ANSI terminal helpers) already shipped; **v1.0 is in active
design** and is what this folder builds toward.

## What Prism is

A UI is the Three Primitives (Values / Processes / Channels) applied to presentation: a `face` is a
process, its output is a value (a node tree), its input is a channel. Prism owns its own closed
vocabulary (`stack`, `band`, `press`, `entry`, `each`, …) rather than borrowing React/SwiftUI/Flutter
nouns, because a Prism face is a *supervised process*, not a re-invoked function or an immutable
config object — see `PRISM_SPEC.md` §2 for why that distinction is load-bearing, not cosmetic.

Two backends exist by design, not by accident: the **web** target emits real DOM elements (so a11y,
Ctrl+F, IME, and text shaping come from the platform for free); **native** targets (desktop, mobile,
embedded) get an owned GPU renderer, because there is no DOM there and pixel parity genuinely pays.
A **terminal/ANSI** backend (`backend/ansi/`) is a fourth, already-real target for CLI/TUI tools.

## Status

**The library is COMPLETE — 130 modules, 127 KATs, ~55.1k lines**, across all six library layers
plus `app/` (Tier 2). Phase A (MA.1–MA.8) is done: the node-tree value type, the **22 primitives**
as plain functions, typed `look`/`palette` values, an HTML server-side renderer, and the ANSI
backend — all pure NOVA, no compiler changes, no WASM, no closures.

What is **not** built is the part that makes it a *reactive* framework:

* **Reactivity (M3.4)** — designed, not implemented. `prism_exp_readsets_available()` returns
  `false` deliberately rather than fabricating a number. The gating experiment (**M1.7**) has now
  RUN and **Bet 1 survives**: on a real 109-leaf application state tree, the marginal read-set per
  face is a median of **2 leaves**. See `NOVA_DESIGN/M1_7_FALSIFIER_RESULT.md` and
  `PRISM_M3_4_REACTIVITY_DESIGN.md`.
* **The browser path (M0.3)** — blocked on splitting the 32k-line runtime into a wasm-capable core
  and a native-only host. This is the single remaining blocker on running PRISM in a browser.

So PRISM today renders **server-side HTML, ANSI, canvas, PDF, CSV and PNG** from one node tree, and
is usable from Forge now. The `face`/`look`/`palette`/`->` *syntax* is compiler sugar added later
(Phase 3); until then a face is just a NOVA function returning a node tree, exactly how
`forge_html` builds pages today.

See `NOVA_DESIGN/PRISM_STATUS.md` for the live task tracker — it is the single source of
truth for what is actually built versus designed.

## Read these, in order

1. **`NOVA_DESIGN/PRISM_STATUS.md`** — live status tracker. Start here. What's verified, what's next.
2. **`NOVA_DESIGN/PRISM_SPEC.md`** — normative language specification: axioms, the 44 keywords, the
   grammar, the vocabulary, the reactivity algorithm, the threat model.
3. **`NOVA_DESIGN/PRISM_UNIVERSAL_UI_PLAN.md`** — architecture: the layers, the seven bets, and the
   falsification evidence that revised the plan (web-DOM / native-GPU split).
4. **`NOVA_DESIGN/PRISM_ROADMAP.md`** — execution plan: every milestone, its exit criterion, and the
   kill gates.

## Hard constraint: the flat symbol space

NOVA module top-level function (and type) names share **one LLVM symbol space**, even across modules
and even when called qualified (`prism_ansi.prism_ansi_clear()`). This has caused real,
hard-to-diagnose type-inference bugs elsewhere in this repo (see `forge/forge_html.nova`'s header on
the `text`/`forge.text` collision). **Every symbol Prism exports is prefixed `prism_*` /
`Prism*` for exactly this reason — including inside subfolders.** Folders are for humans; prefixes
are for the linker.

## Layout

14 top-level folders (`core/`, `widget/`, `style/`, `layout/`, `text/`, `backend/` with `dom/` /
`gpu/` / `ansi/`, `app/`, `intl/`, `ui/`, `obs/`, `dev/`, `render/`, `embed/`, `kat/`) — the complete,
feature-numbered map is in `PRISM_STATUS.md`'s "REPOSITORY STRUCTURE" section. Each folder not yet
populated carries its own `README.md` describing what will live there.
