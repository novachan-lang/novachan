# PRISM — STATUS TRACKER

**This is the single entry point for the Prism campaign.** Read this first; every other Prism
document is indexed here with its real completeness.

> Subordinate to `EXECUTION_STATE.md`, which remains THE master tracker for the whole project.
> This file tracks the Prism campaign only. Do not create further Prism trackers.

---

## ⛔ 2026-08-14 — THREE CORE PREMISES FALSIFIED BY EVIDENCE. ARCHITECTURE REVISED.

Step-2 research (primary sources, all cited below) **destroyed the technical justification for a
canvas own-renderer on the web backend.** Recording this against my own earlier recommendation.

### F1 — "Per-operation JS interop is what makes WASM UI slow" is **FALSE**
Mozilla measured the boundary over **100 million calls**: **4.5 ns per call, 2.5 ns monomorphic** —
and states optimized JS→WASM calls are **faster than non-inlined JS→JS calls**
([hacks.mozilla.org](https://hacks.mozilla.org/2018/10/calls-between-javascript-and-webassembly-are-finally-fast-%F0%9F%8E%89/)).
A DOM mutation is microseconds; the crossing is 0.1-1% of it. **The boundary cannot be the bottleneck.**

Blazor is slow for a different reason, per Microsoft's own docs: *"Parameters and return values are
JSON-serialized"* and *"Calls are asynchronous."* That is an implementation choice, not physics.
Blazor's signature proves it — **33.3× vanilla on select-row (one class toggle) vs 3.35× on
create-1k-rows.** Penalty scales *inversely* with work per operation = high fixed per-call cost.

**Controls that break the general claim:** Leptos (1.24×) and Dioxus (1.08×) cross the *same*
boundary on the *same* test and pay nothing. And **Blazor AOT is slower (5.82 vs 5.73) while shipping
2.14× more bytes** — so native codegen quality is *not* the lever. **NOVA's ~1.04×C speed buys
nothing for UI throughput.**

### F2 — The batched linear-memory patch protocol **ALREADY EXISTS AND LOST**
Dioxus ships `sledgehammer_bindgen`: DOM ops as a byte stream in linear memory, read four-at-a-time
as `u32`, one `TextDecoder` per batch, string interning
([github](https://github.com/ealmloff/sledgehammer_bindgen)). **That is exactly the architecture in
`PRISM_UNIVERSAL_UI_PLAN.md` Bet 5.** Leptos uses naive per-node `wasm-bindgen` calls.

**Result: Dioxus 1.26 geomean, Leptos 1.23.** The batched protocol is marginally **behind** — and
Dioxus pays **2.4× Leptos's bytes** (114.9 vs 48.8 KB brotli) and **2.3× its first paint** (529 vs
230 ms). My exact design, measured on my exact workload, by a third party. **It bought nothing.**

### F3 — "Inherit the browser's shaping via `fillText` into a glyph atlas" is **IMPOSSIBLE**
To cache per-glyph you must know which glyphs the browser produced and where it placed them.
`TextMetrics` exposes **12 whole-string properties and zero per-glyph data**
([MDN](https://developer.mozilla.org/en-US/docs/Web/API/TextMetrics)). WICG's own explainer:
*"There is currently no way to know which characters in a string correspond to individual glyphs
rendered to screen"*
([canvas-formatted-text](https://github.com/WICG/canvas-formatted-text/blob/main/explainer-metrics.md)).
The fix (`TextCluster`) is a **Chrome-only origin trial through milestone 155, with no signal from
Mozilla and no signal from WebKit.**

So the only paths are: cache whole runs (hit rate collapses on dynamic/editable text), or **bundle
HarfBuzz + ICU — which IS Flutter's payload.** Measured from Google's CDN this session:
`skwasm.wasm` **1.17 MB brotli**, generic `canvaskit.wasm` **2.18 MB brotli**. Flutter didn't
overlook the browser's shaper; **it couldn't use it, for exactly this reason.**
Cautionary tale: **egui** shipped an atlas without a real shaper → open bug for complex Unicode,
degraded CJK (zero sub-pixel binning), now migrating to Parley/HarfBuzz.

### F4 — Compile-time layout solving has **NO PRIOR ART**
Every layout engine found is runtime (Yoga, Taffy/Stretch, browser engines). Layout depends on
viewport, font metrics, and content length — **none compile-time known.** Bet 6 is an unvalidated
novel claim, not an application of prior art. **Reduced to compile-time *specialization*** (resolve
the constraint graph's shape, hoist invariants, monomorphize the solver) with the numeric solve at
runtime.

### F5 — What owning the renderer on the web actually costs (Flutter's documented bill)
Google's **own FAQ**: Flutter is *"**not suitable** for static websites with text-rich flow-based
content"* and *"application output **doesn't align with what search engines need** to properly
index"* — and recommends a **two-framework architecture**
([docs.flutter.dev](https://docs.flutter.dev/platform-integration/web/faq)). After ~7 years.
- **Ctrl+F: [open since 2020-09-09](https://github.com/flutter/flutter/issues/65504)** — ~6 years.
- **A11y is opt-in for performance**, activated by finding an **invisible button**; **no `<label>`
  elements** (fields announce *"edit, blank"*); no `listbox`/`option` roles; virtual scrolling breaks
  the a11y contract ([flutter.dev blog](https://flutter.dev/blog/accessibility-in-flutter-on-the-web)).

### F6 — In our favour: WASM does **not** imply a big download
**Leptos ships 48.8 KB brotli vs React+react-dom's 51.4 KB.** All four Rust frameworks (Leptos 1.23,
Dioxus 1.26, Sycamore 1.29, Yew 1.49) **beat React (1.80)**. Size is not the argument against us —
**it only becomes fatal if we bundle a text stack.**

### ⇒ THE DECIDING ARITHMETIC
vanilla **1.00** · Solid **1.11** · Leptos **1.23**. **Total headroom from eliminating ALL interop is
under 25%** — which Leptos already banks *while keeping the DOM, and with it a11y, Ctrl+F, text
selection, IME, autofill, SEO, and the entire text stack for free.*

**An own-renderer web backend cannot pay for itself on interop grounds.** It would spend a multi-year
build and a ~1.2 MB payload floor to compete for a margin already available.

### ⇒ REVISED ARCHITECTURE: **backend-swappable, DOM on web, own renderer on native**

The vision survives; only the *web renderer* changes. Everything above the renderer is
backend-agnostic and unaffected.

| Layer | Decision |
|---|---|
| `face` vocabulary, `look`/`palette`, zero-annotation reactivity, derived a11y, full-stack typed channels, capabilities, security model | **KEEP — all backend-agnostic** |
| **Web backend** | **Emit real DOM elements** from the closed vocabulary. No canvas, no own layout, no own text stack |
| **Native backends** (desktop/mobile/embedded) | **Own GPU renderer** — there is no DOM there, so this is required anyway, and it is where pixel parity genuinely pays |
| GPU-heavy surfaces (the 3D galaxy chart) | **`draw` primitive** → WebGL on web, native GPU elsewhere. Keeps Bet 7 intact |
| Bet 5 (zero boundary crossings) | **DROPPED — falsified (F1, F2)** |
| Bet 6 (compile-time layout) | **REDUCED to compile-time specialization (F4)** |

**Derived a11y gets STRONGER, not weaker.** Because the vocabulary is closed and typed, the web
backend emits a real `<button>`, not a `<div role="button">` — so we get the platform's native
semantics, keyboard behaviour, focus ring, IME, autofill, find-in-page, and selection **for free**,
while still deriving everything from the type with no developer annotation. This was the single best
claim in the matrix and the DOM backend *improves* it.

**Effort impact: large reduction.** No web text stack (was 8-12 wk, the #1 risk), no web layout
engine, no web paint pipeline, no web GPU abstraction for v1. **Roadmap Phase 2 largely collapses for
the web target.** Native backends keep that work, but they move to Phase 5 where they already were.

**Honest note:** my earlier DOM-native recommendation was correct, and I abandoned it for a
*vision-alignment* argument while dropping the *engineering* argument. The hybrid keeps both — and it
is what the evidence supports.

---

## WHERE WE ARE RIGHT NOW

**Phase:** PRE-PHASE-0 — design proposal exists, nothing is built, nothing is funded.
**Last action:** wrote the normative spec skeleton (`PRISM_SPEC.md`).
**Current action:** **STEP 2 — verifying competitive claims** (2 agents dispatched).
**Blocking decision:** owner GO/NO-GO on Phase 0-1 (~5-6 months to a NOVA app drawing its own pixels).

### Honest completeness

| | |
|---|---|
| Specification written | **~30 pages** |
| Specification needed to build from | **~1,400 pages** |
| **Actual completeness** | **≈2%** |

**What exists is enough to decide whether to fund Phase 0-1. It is NOT enough to build from.**
Do not treat any document here as buildable yet.

---

## ★ LIVE TASK LIST — tick this on START and on COMPLETION, same commit as the work

**Statuses:** `⬜ TODO` · `🔄 IN PROGRESS` · `✅ DONE` · `⛔ BLOCKED` · `❌ KILLED`
**Rule:** set `🔄` + start date when beginning. Set `✅` + date + **the measured result** when the exit
criterion passes. Never "done" without the measurement. Killed items stay, with the evidence.

| # | Task | Status | Started | Finished | Result / note |
|---|---|---|---|---|---|
| T0 | Prism status tracker created | ✅ DONE | 2026-08-14 | 2026-08-14 | This file; single entry point |
| T1 | Architecture + roadmap + matrix + spec skeleton | ✅ DONE | 2026-08-13 | 2026-08-14 | 4 docs; honest completeness ≈2% of a buildable spec |
| T2 | **Q8 — probe wasi-sdk / m7 blocker** | ✅ DONE | 2026-08-14 | 2026-08-14 | **Blocker MISDIAGNOSED.** clang 22.1.0 emits wasm32 fine; libc surface is only ~46 fns; but runtime needs a **SPLIT** (32,244 lines incl. sockets/epoll/pthreads/OpenSSL/dlopen). M0.3 rescoped 3-6wk → **6-10wk**, now the true critical path |
| T3 | **Q1 — research reactivity inference limits** | ✅ DONE | 2026-08-14 | 2026-08-14 | **Risk INVERTED.** Svelte 4 was *unsound* (syntactic, no call-graph); Compose tracks at *runtime* so it is not evidence. Real wall = **granularity collapse**. Added `face`-as-boundary + runtime keyed identity + mandatory diagnostics + **new milestone M1.7** |
| T4 | **Verify WASM/interop/bundle/text claims** | ✅ DONE | 2026-08-14 | 2026-08-14 | **3 PREMISES FALSIFIED (F1-F6).** Boundary is 4.5 ns; batched patch protocol already exists (Dioxus `sledgehammer`) and **lost** to Leptos; `fillText`→glyph-atlas is **impossible** (no per-glyph metrics). **Architecture revised to DOM-on-web / GPU-on-native** |
| T5 | Tier-2/3 feature expansion | ✅ DONE | 2026-08-14 | 2026-08-14 | 60 → **~132 features**. Found 9 features FREE from the process/channel model; found 2 large absences (data grid 3-5pm, rich text 3-4pm). Roadmap +10-14pm |
| T6 | `prism/` structure — all 132 features placed | ✅ DONE | 2026-08-14 | 2026-08-14 | 14 folders, ~70 modules, every feature has a home + feature number |
| T7 | Revised phase totals | ✅ DONE | 2026-08-14 | 2026-08-14 | 69pm sequential; ~6-7mo to gate, ~2.7yr browser v1, ~4-4.5yr everything |
| T8 | **Commit all work so far** | 🔄 IN PROGRESS | 2026-08-14 | — | Prism docs + taskboard ORM sources; artifacts excluded |
| T9 | **Step 3 — vertical-slice spec at buildable depth** | ⬜ TODO | — | — | grammar + lowering · DOM emission map for all 26 primitives · update path · closure→WASM table · event loop · 3 widgets fully specified. **~80 pp. Docs only, no permission needed** |
| T10 | **M0.1 — WASM into `nova_ci.ps1`** | ⬜ TODO | — | — | ~0.5wk GREEN. **Do regardless of GO/NO-GO** — working browser demos are currently unprotected. **CODE → needs go-ahead** |
| T11 | **M0.3 — runtime split** (`core` vs `host`) | ⬜ TODO | — | — | 6-10wk **RED**, full arc. True critical path. **CODE → needs go-ahead** |
| T12 | **M0.4 — closures across the WASM boundary** | ⬜ TODO | — | — | 4-8wk **RED**. Function table + RC-rooted captured env. **CODE → needs go-ahead** |
| T13 | M0.5 — dead-code elimination | ⬜ TODO | — | — | 2-3wk YELLOW. Target: hello-world 459KB → <50KB raw |
| T14 | **P1 — vertical slice (DOM backend)** | ⬜ TODO | — | — | 6 sub-milestones M1.1-M1.6 → **a NOVA counter drawing through the DOM backend, clickable, 60fps** |
| T15 | **M1.7 — THE BET-1 FALSIFIER** | ⬜ TODO | — | — | 3-4wk. Measure read-set per face as % of reachable state. **>20-30% ⇒ Bet 1 dead.** M3.4 is gated on this |
| T16 | ★ **GO/NO-GO decision point** | ⬜ TODO | — | — | After T14+T15. ~6-7 months in. Owner call |

**Owner decision currently pending:** go-ahead on T10 (half a week, protects existing capability) and
on the P0 code path (T11/T12).

## HOW TO NAVIGATE — read in this order

```
PRISM_STATUS.md          ← YOU ARE HERE. Always start here. Live status, what's verified, what's next.
   │
   ├─ PRISM_SPEC.md              NORMATIVE. What the language IS. Grammar, vocabulary, algorithms, threat model.
   ├─ PRISM_UNIVERSAL_UI_PLAN.md Architecture. Layers, the bets, falsification criteria.
   ├─ PRISM_ROADMAP.md           Execution. 35 milestones, exit criteria, kill gates.
   └─ PRISM_FEATURE_MATRIX.md    Competitive position. 60 features, what only Prism can do.
```

**Rule:** if two documents disagree, **PRISM_SPEC.md wins**, and this file records the correction.

## HOW I WORK ON THIS (the process, so it is predictable)

| Step | What I do |
|---|---|
| **1. Verify before designing** | Grep/probe the live code first. Docs drift, code does not. Every claim gets `file:line` evidence or a measurement, or it is labelled a GUESS |
| **2. Separate fact from assertion** | Every number lands in one of three buckets in this file: ✅ VERIFIED · ❌ UNVERIFIED · 🎲 GUESS. I do not let a guess wear a table cell like a measurement |
| **3. Cheapest falsifier first** | Do the thing that can invalidate the most work, first. Q8 (30 min) rescoped a blocker; step 2 (2 days) killed three premises and saved a multi-year build |
| **4. Depth-first, not breadth-first** | One layer specified to buildable depth, then built, then measured — measurement corrects the spec. Never write 300 pages ahead of a prototype that could invalidate them |
| **5. Report against myself** | When evidence contradicts my own recommendation, that goes in the doc in bold. F1-F6 killed my own architecture; that is the process working, not failing |
| **6. Tick the tracker in the same commit** | This file is updated with any Prism work, never after |
| **7. ≤2 agents, never recursive, never `Workflow` fan-out** | Pro-plan constraint. Agents are told explicitly not to spawn children |
| **8. Ask before writing code** | Design and structure are written freely. **No `.nova` implementation lands without an explicit go-ahead.** |

## REPOSITORY STRUCTURE (proposed — not yet created)

**Learning from `forge/`:** it is **1,013 files completely flat**, with `.ll` and `.exe` build
artifacts interleaved among sources. Navigable only by prefix search. **Prism is foldered from day
one** and artifacts are git-ignored.

**Hard constraint that shapes this:** NOVA module top-level function names share **one LLVM symbol
space** (a documented gotcha — it has caused real inference bugs, e.g. `el` colliding between
`forge_admin` and `forge_html`). So every file keeps the `prism_*` prefix **even inside folders**;
folders are for humans, prefixes are for the linker.

**Every one of the ~132 features has an assigned home below.** `#n` = feature number in
`PRISM_FEATURE_MATRIX.md`. ★ = added by the 2026-08-14 scope correction.

```
prism/
├── nova.toml · README.md
│
├── core/                        # runtime spine — backend-agnostic
│   ├── prism_face.nova              # lifecycle, process wiring, supervision/restart   #12
│   ├── prism_node.nova              # the node tree value type
│   ├── prism_key.nova               # runtime keyed identity map        ← spec §12.6
│   ├── prism_event.nova             # event model, default-event, provenance tags  §15.7
│   ├── prism_caps.nova              # capability values                 §15.2 #112 #124
│   ├── ★ prism_journal.nova         # THE MESSAGE LOG → undo/redo, replay, audit  #61 #114
│   └── ★ prism_secret.nova          # Secret<T>, no serializer → structural PII redaction  §15.3 #123
│
├── widget/                      # the primitives (spec Part III)
│   ├── prism_arrange.nova           # stack band layer mesh flow pane gap
│   ├── prism_content.nova           # label art glyph draw
│   ├── prism_input.nova             # press entry pick flag range link
│   ├── prism_structure.nova         # each grid sheet hint tabs
│   ├── ★ prism_media.nova           # video / audio playback            #82
│   └── ★ prism_notice.nova          # toasts / snackbars / notification centre  #71
│
├── style/
│   ├── prism_look.nova              # typed style values, merge order
│   ├── prism_palette.nova           # tokens, light/dark, 9 presets, multi-tenant  #101
│   ├── prism_motion.nova            # + reduced-motion respected BY DEFAULT  #70 #102
│   └── ★ prism_print.nova           # print layout                      #115
│
├── layout/                      # box constraints (GPU backend; DOM backend defers to CSS)
│   ├── prism_constraint.nova
│   ├── prism_solve.nova
│   └── ★ prism_rtl.nova             # RTL mirroring — a layout flag, not a CSS rewrite  #121
│
├── ★ text/                      # the text model — needed by BOTH backends
│   ├── prism_textmodel.nova         # document model
│   ├── prism_richedit.nova          # RICH TEXT EDITING  #62  ← 3-4 pm, no contenteditable on GPU
│   ├── prism_select.nova            # selection + caret
│   └── prism_find.nova              # in-app find (replaces Ctrl+F on the GPU backend)
│
├── backend/                     # ★ THE SWAPPABLE PART (post-falsification)
│   ├── prism_backend.nova           # the interface both implement
│   ├── dom/                         # WEB — primary, per F1-F6
│   │   ├── prism_dom_emit.nova          # vocabulary → REAL DOM elements
│   │   ├── prism_dom_patch.nova         # update path
│   │   ├── prism_dom_a11y.nova          # derived semantics → native <button>, not div+role
│   │   ├── ★ prism_dom_csp.nova         # CSP / security headers, no inline script  #113
│   │   └── prism_dom_host.js            # thin host shim — the ONLY JS in the project
│   └── gpu/                         # NATIVE desktop / mobile / embedded
│       ├── prism_gpu_api.nova           # WebGPU/Vulkan/Metal/D3D12 abstraction
│       ├── prism_paint.nova             # display list, batching, damage tracking
│       ├── prism_atlas.nova             # alpha-only glyph atlas, bin packing, 16 subpixel variants
│       ├── prism_text_shape.nova        # platform shaping (DirectWrite/CoreText/harfbuzz)
│       └── ★ prism_gpu_a11y.nova        # UIA / NSAccessibility / AT-SPI
│
├── app/                         # the application platform (Tier 2)
│   ├── prism_route.nova             # + deep-linked sheets #89, breadcrumbs #100, scroll restore #69
│   ├── prism_form.nova              # form_of + autosave / draft recovery  #87
│   ├── prism_wire.nova              # typed channel + dedup/retry/backoff #92, versioning #125
│   ├── prism_guard.nova             # RBAC-conditional UI — unreachable UI is a COMPILE ERROR  #90
│   ├── ★ prism_session.nova         # silent token refresh, logout-everywhere  #91
│   ├── ★ prism_sync.nova            # offline queue #75 · multi-tab #74 · presence #77 · conflict #76
│   ├── ★ prism_wizard.nova          # stepper state machine, typed ADT + exhaustive match  #88
│   ├── ★ prism_shortcut.nova        # keyboard shortcuts + command palette  #67 #99
│   ├── ★ prism_clipboard.nova       # clipboard, paste-a-range-from-Excel into a grid  #63
│   └── ★ prism_download.nova        # streaming download  #80
│
├── ★ intl/
│   ├── prism_i18n.nova              # typed catalogs, compile-checked keys  #66 #120
│   ├── prism_datetime.nova          # Instant / ZonedDateTime / PlainDate  #64  ← CRITICAL for tiger1
│   └── prism_number.nova            # locale number + currency  #65
│
├── ui/                          # component library — FLEET-DELEGABLE
│   ├── ★★ prism_ui_grid.nova        # THE DATA GRID #85 — cell edit, fill-down, resize/reorder/
│   │                                #   pin/freeze, multi-select, grouping, aggregation. 3-5 pm.
│   │                                #   AG Grid is a ~1 MB commercial product. Biggest component.
│   ├── prism_ui_table.nova · prism_ui_datepicker.nova · prism_ui_cascader.nova …
│   ├── prism_ui_chart_*.nova        # #84 — renders client AND server (one impl for PDF)
│   ├── ★ prism_ui_skeleton.nova     # DERIVED from the face's static layout  #73
│   ├── ★ prism_ui_tour.nova         # product tours / onboarding  #98
│   └── ★ prism_ui_map.nova          # maps / geospatial  #83
│
├── ★ obs/                       # observability
│   ├── prism_telemetry.nova         # typed analytics events — schema change breaks the BUILD  #96
│   ├── prism_crash.nova             # crash report WITH the replay log attached  #97 #128
│   ├── prism_perf.nova              # per-face invalidation counts, latency profiling  #107
│   └── prism_flag.nova              # feature flags + A/B (wraps existing forge modules)  #94 #95
│
├── dev/                         # DX tooling — MANDATORY per spec §12.7, not optional
│   ├── prism_explain.nova           # `nova prism explain <face>` — read-sets + why escalated
│   ├── prism_inspect.nova           # tree / state inspector, repaint flashing
│   ├── ★ prism_catalog.nova         # Storybook equivalent — GENERATED, no .stories files  #103
│   ├── prism_test.nova              # testing API, query by DERIVED role/label  #47
│   ├── ★ prism_visual.nova          # pixel-exact visual regression (deterministic render)  #104
│   ├── ★ prism_audit_a11y.nova      # audits only the 4 residual annotations  #105
│   ├── ★ prism_size.nova            # per-route bundle budget  #106
│   └── ★ prism_tokens.nova          # design-token export  #108
│
├── ★ render/                    # non-screen render targets — SAME faces, different output
│   ├── prism_render_html.nova       # server-side HTML: SSR / SSG / email templates  #116
│   ├── prism_render_pdf.nova        # → PDF  #117
│   ├── prism_render_sheet.nova      # → Excel  #117
│   └── prism_render_image.nova      # → PNG, deterministic  #118
│
├── ★ embed/
│   └── prism_embed.nova             # sandboxed native/iframe escape hatch  §17 #110 #131
│
└── kat/  _kat_prism_*.nova          # known-answer tests (project gate culture)
```

**14 folders, ~70 modules, all ~132 features placed.** Note `render/` — the same `face` produces
screen pixels, server HTML, an email, a PDF, and a PNG. That is §9.10, and it is why tiger1's
duplicate "bar chart" implementations (Recharts in the browser + xhtml2pdf on the server) collapse
into one.

**Critical split — what is NOT in `prism/`:** the language forms themselves. `face`, `look`,
`palette`, `motion`, `wire`, `route`, the `->` action form, the reactivity inference pass, and island
inference all live in **`nova-compiler/compiler/nova_compiler.nova`** (RED blast radius, full arc).
`prism/` is the **library**; the **grammar and the compiler passes are compiler work**. Conflating
those two is how this project would lose months.

**Build artifacts:** `.ll`, `.exe`, `.wasm` git-ignored under `prism/` from the first commit — do not
repeat the `forge/` sprawl.

## DOCUMENT INDEX

| Doc | Purpose | Status | Complete | Biggest gap |
|---|---|---|---|---|
| **PRISM_STATUS.md** | *this file* — index + live status | LIVE | — | keep it ticked |
| **PRISM_SPEC.md** | **NORMATIVE.** Axioms, 44 keywords, EBNF, vocabulary, reactivity algorithm, threat model | DRAFT v0.1 | **~2%** | 26 widgets are one-line table rows (need ~8 pp each); layout algorithm cited not written; zero patch opcodes defined; soundness theorem stated not proved |
| **PRISM_UNIVERSAL_UI_PLAN.md** | Architecture — 8 layers, 7 bets, blockers, falsification | DRAFT | ~60% | GPU abstraction and platform shims are one-liners. §5 syntax is SUPERSEDED by the spec |
| **PRISM_ROADMAP.md** | Execution — 34 milestones, exit criteria, 8 kill gates | DRAFT | ~70% | milestone-internal task breakdown missing |
| **PRISM_FEATURE_MATRIX.md** | **132 features** in 3 tiers vs best-in-class; 16 unique capabilities | DRAFT | ~45% | Tier-1 verdicts partly verified by step 2; Tier-2/3 verdicts are still assertions |

### ⚠️ SCOPE CORRECTION 2026-08-14 — the feature count was 60, the real number is ~132

The original 60 features were **framework core only** — what React/Vue/Svelte ship. **React lets npm's
2M packages supply the rest; Prism has no npm, so Prism must ship it or the developer is stuck.**

| Tier | Scope | Count | Supplied in React-land by |
|---|---|---|---|
| 1 | Framework core | 60 | the framework |
| 2 | Application platform | ~42 | **npm libraries — Prism must build these** |
| 3 | Product / enterprise concerns | ~30 | hand-built by every team |
| | **TOTAL** | **~132** | |

**Three findings from the expansion:**
1. **Nine Tier-2 features come out FREE from the process/channel model** — undo/redo, multi-tab sync,
   offline queue, presence, long-running progress, audit trail, crash-reports-with-replay, crash-free
   metrics, micro-frontend isolation. React teams buy or build each one separately. **This was the
   most under-stated argument in the whole design and all nine were missing.**
2. **`Secret<T>` makes PII redaction structural, not a logging discipline** — a compliance argument
   that may outweigh anything about frame times for an enterprise buyer.
3. **Two large items were absent entirely:** the **data grid** (#85 — cell edit, fill-down,
   resize/reorder/pin/freeze, grouping, aggregation; AG Grid is a ~1 MB commercial product; tiger1's
   editable time-grid needs most of it) at **3-5 pm**, and **rich text editing** (#62, ProseMirror
   class; tiger1's document editor needs it) at **3-4 pm** — with no `contenteditable` shortcut at all
   on the GPU backend.

**⇒ `PRISM_ROADMAP.md` totals are understated by ~10-14 person-months.** Must be revised at the next pass.

---

## THE STEP ORDER (from step 0)

| Step | Action | Why this order | Status |
|---|---|---|---|
| **0** | Status tracker | Single source of truth for the campaign | ✅ **DONE** |
| **1** | Architecture + roadmap + matrix + spec skeleton | Enough to make a funding decision | ✅ DONE (at 2%) |
| **2** | **Verify competitive claims** | **Cheapest thing that can invalidate the most work.** If Bet 1 is impossible, ~1,400 pages are wasted. Days of research vs months of writing | 🔄 **IN PROGRESS** |
| **3** | Spec the **vertical slice** to buildable depth (~80 pp) | Only Phase-1 scope: patch opcodes byte-by-byte, closure/WASM mechanism, 3 widgets fully, software rasterizer, frame loop | ⬜ next |
| **4** | **Build the vertical slice** (Phase 0-1) | Settles in weeks what writing cannot settle at all: text quality, bundle floor, frame budget, static-layout fraction | ⬜ |
| **5** | Deep-spec each layer as reached, corrected by measurement | Spec-then-measure interleaved. **Never write 300 pp ahead of a prototype that could invalidate it** | ⬜ |

**Sequencing rule learned the hard way:** breadth-first at 2% depth produced four documents that
read like summaries. Go **depth-first**, one layer at a time, measurement correcting spec.

---

## DECISIONS TAKEN (log)

| # | Decision | Rationale |
|---|---|---|
| D1 | **Own renderer — no HTML/CSS/DOM** | HTML exists only in browsers → violates "runs anywhere"; and you cannot *detect everything* through a black box. Owning the vocabulary is the precondition for derived a11y/focus/staticness |
| D2 | **Prism's own vocabulary**, not borrowed names | Semantic honesty first: a `face` is a supervised process, not a React component. Borrowed names promise semantics we don't have |
| D3 | Layout = **single-pass box constraints** | O(n), thrash structurally impossible. Rejected CSS semantics (too many interacting cases) and Cassowary (superlinear, bad debuggability) |
| D4 | Text = **per-backend native shaping + GPU glyph atlas**; on web via `fillText` | Inherits shaping/bidi/emoji free; ~0 steady-state cost. Rejected bundling a shaper (Flutter pays 1.5-2 MB) |
| D5 | **Vertical slice before deep layers** | Worst bugs in a layered graphics stack live at the seams |
| D6 | **Security is a design pillar** | Injection unrepresentable (no HTML sink), capability-gated host access, `Secret<T>` unserializable |
| D7 | `->` binds each widget's **default event** | 90% case needs no event name; `when` covers the rest |
| D8 | `by` (identity) **mandatory** on `each` | React's missing-key runtime warning becomes a Prism compile error |
| D9 | **Step 2 before step 3** | Verify before writing 1,400 pages on unverified premises |

---

## VERIFIED vs UNVERIFIED — read before trusting any number

### ✅ VERIFIED (audited in-repo, evidence cited)
- `nova wasm <file>` is a real CLI command; triple `wasm32-unknown-unknown`
- `extern fn` + `unsafe` host imports **work**
- **DOM create/append/set_text + click events ALREADY RUN IN A REAL BROWSER** —
  `test_programs/_wasm_dom_event_demo.nova`, `web__wasm_dom_event_demo/`, `_wasm_todo.nova`
- Value model (str/list/dict/struct/float) runs on wasm32 byte-identical to native (m6)
- Measured gzip: **490 B** (no value model) → **134 KB** (todo with lists+strings)
- **No dead-code elimination** — every demo ≈459 KB raw regardless of content
- **Callbacks are export-name strings only** — no fn pointers, no closures, no table dispatch
- **Bump allocator never frees**; **no value tags** (ints ≥256 diverge through polymorphic ops)
- **WASM is NOT in `nova_ci.ps1`** — zero references; the working demos are unprotected

### ❌ UNVERIFIED — my assertions, not evidence (step 2 is fixing these)
- ~~Why Svelte 5 retreated from implicit reactivity~~ → ✅ **VERIFIED** with primary sources (Q1)
- ~~Why Compose needs `@Stable`/strong-skipping~~ → ✅ **VERIFIED** with official docs + design doc (Q1)
- Blazor's measured per-call JSInterop overhead
- Leptos/Dioxus real bundle sizes and benchmark positions
- Flutter Web's measured payload and the specifics of its a11y criticism
- **All 47 "WIN" verdicts in `PRISM_FEATURE_MATRIX.md`**

### 🎲 GUESSES I labeled as hypotheses — only a prototype settles these
- 75 KB bundle floor / 150-250 KB for an enterprise app
- Frame budget breakdown (1 ms reactivity, 2 ms layout, 3 ms paint, 2 ms submit)
- "30-60% of nodes statically layout-solvable"
- Atlas hit rate >99% in steady state
- `fillText`-into-atlas reaching native text quality

---

## OPEN QUESTIONS (each blocks a named milestone)

| # | Question | Blocks | Resolved by |
|---|---|---|---|
| Q1 | What exactly defeated Svelte 5's implicit reactivity / forced Compose's `@Stable`? | M3.4 · Bet 1 | ✅ **RESOLVED 2026-08-14 — see below. Risk assessment INVERTED.** |

### ✅ Q1 RESOLVED — the risk was misidentified. Soundness is reachable; GRANULARITY is the wall.

Full evidence in `PRISM_SPEC.md` §12.5-12.8 (with source URLs). Decision-relevant summary:

**1. Svelte 4's sin was UNSOUNDNESS, not implicitness.** Its inference was *purely syntactic
free-variable collection with no call-graph walk* — its own docs say *"the compiler cannot 'see' the
dependency."* It **silently missed updates** (under-invalidated), which is exactly what axiom A4
forbids. Its structural cause was per-file compilation (*"the compiler only operates on one file at a
time"*) — an artifact of being a JS build plugin. **Svelte never attempted interprocedural analysis.
It did not hit the wall; it never walked up to it.**

**2. Compose is not evidence against static inference — its tracking is RUNTIME.** The snapshot
system records reads at execution; the compiler only supplies scope boundaries and skip guards.
`@Stable` exists for (i) a Kotlin type-system defect (`MutableList` implements `List`) and (ii)
separate compilation — **the annotation is a hand-written cross-module summary.** Both dissolve under
whole-program compilation with an owned type system. "Strong skipping" moved Compose *toward fewer*
annotations. **Compose's default is already over-invalidate; its one mandatory annotation is
`mutableStateOf` — precisely what Prism eliminates.**

**3. Positive prior art exists.** **Marko 6** ships compile-time reactive-graph discovery that
*"transcends files"*, at a cost of one declaration form (`<let>`) — the closest proof of concept for
Prism. **Vue** shipped zero-annotation reactivity with the annotation at the *boundary*, not on
variables. **React Compiler v1.0** proves the analysis is tractable even in JavaScript and **bails
safe**. **No academic source claims impossibility** — exact inference is undecidable, but sound
over-approximation always exists.

**⇒ Verdict: nobody with a whole-program compiler and an ownership model has tried this. The wall is
unexplored, not proven.** Every documented failure traces to per-file compilation, syntactic
collection, or JavaScript's absence of aliasing info — none of which NOVA has.

**4. THE REAL WALL (this changed the spec): granularity collapse.** Static read-sets are the union
over all paths/callees/branches, so over-approximation is **transitively contagious** — one cell deep
in a list item can become a dependency of the whole page. **That is zone.js, which Angular abandoned
for performance and predictability.** Field-sensitivity is achievable; **index-sensitivity is not**
(`items[i]` collapses to all of `items`), so **sub-list granularity requires a runtime keyed identity
map — it cannot be purely static.**

**5. Two defenses, now normative in the spec:**
- **`face` IS the reactive boundary** — a cell is reactive only within the transitive read-set of its
  declaring `face`, so over-approximation is bounded **per face**, not program-wide. Prism pays *no
  extra keyword*: the boundary marker is a declaration form it already had. (This is what Marko's
  `<let>` and Vue's `data` actually do.)
- **`by` gives runtime keyed identity** for collection rows (already mandatory).

**Honest consequence:** the achievable design is *compiler-inferred scopes + runtime keyed identity*
— architecturally closer to **Compose than to Svelte 4**. Prism's real advantages: **zero annotation
on state**, soundness by default from ownership tracking, no `@Stable` because the type system is
owned. **The spec must NOT claim "pure compile-time reactivity with zero runtime machinery."**

**6. NEW REQUIREMENT — diagnostics and escape hatches are mandatory for v1.** Every system that
shipped inferred reactivity also shipped them. A developer facing a slow list with zero annotations
*and* zero escape hatch **has no move at all** — that is a product failure closer to what actually
drove Svelte's retreat (predictability) than any missed update. Required: `nova prism explain <face>`
(print read-sets + why escalation happened), escalation warnings, repaint visibility, and — only if
measurement demands it — a `fine`/`coarse` **granularity hint that cannot change semantics**, so a
wrong one can never cause stale UI (strictly safer than `@Stable`, which can).

**7. NEW MILESTONE M1.7 — THE FALSIFIER.** Build *only* the dependency-inference pass and measure the
average inferred read-set per face as a fraction of reachable program state. **>20-30% ⇒ granularity
collapsed ⇒ zero-annotation reactivity is not survivable.** 3-4 weeks, and **M3.4 is now gated on it.**
| Q2 | Does `fillText`→atlas reach native text quality? Metric fidelity limits? | M2.3 | Prototype in Phase 1 |
| Q3 | Is compiler-decided client/server placement achievable, or must it be annotated? | M4.3 | Design spike; annotated form is the accepted fallback |
| Q4 | Closure-across-WASM lifetime under FULLRC — does function-table + RC-root hold? | M0.4 | Phase 0, deliberately first |
| Q5 | What fraction of a real screen is statically layout-solvable? | Bet 6's value | Measure a tiger1 page in Phase 2 |
| Q6 | Does `look` merge order (later-wins) cover theming without a cascade? | M3.2 | Validate vs tiger1's 9 presets |
| Q7 | Minimum viable capability set for v1 | Spec §15.2 | Enumerate in Phase 3 |
| Q8 | Is the wasi-sdk blocker (for m7) stale? | M0.3 | ✅ **RESOLVED 2026-08-14 — see below. The recorded blocker was MISDIAGNOSED.** |

### ✅ Q8 RESOLVED — m7 is not a toolchain problem, it is a runtime-split problem

**Probed directly on this machine (evidence, not assumption):**

| Probe | Result |
|---|---|
| `clang --version` | **22.1.0 present**, knows `wasm32` and `wasm64` targets |
| Freestanding wasm32 compile + link (`--target=wasm32 -nostdlib -Wl,--no-entry`) | ✅ **WORKS** — emitted a 664-byte `.wasm` |
| libc headers for wasm32 (`#include <stdlib.h>`) | ❌ `file not found` — no sysroot |
| wasi-sdk installed anywhere on the box | ❌ not present |

**The recorded status "m7 HARD-BLOCKED on no wasi-sdk sysroot" is wrong in both directions:**

1. **Less blocked than recorded** — clang already emits wasm32 fine. No toolchain work is needed for
   codegen. And the libc surface `nova_runtime.c` actually calls is only **~46 functions**
   (`memcpy` 391×, `strlen` 346×, `free` 318×, `malloc` 205×, plus mem/string/printf/file/math/convert),
   nearly all trivially shimmable. **wasi-sdk is optional, not required.**
2. **More blocked than recorded, and this is the real finding** — `nova_runtime.c` is **32,244 lines**
   and includes `sys/socket.h`, `sys/epoll.h`, `pthread.h`, `openssl/ssl.h`, `dlfcn.h`, `execinfo.h`,
   `sys/mman.h`, `signal.h`, `setjmp.h`, `sys/wait.h`, `dirent.h`, plus Windows `winsock2`/`schannel`/
   `winhttp`/`wincrypt`. **None of that exists on wasm32 — and a full WASI sysroot would not provide
   it either** (no BSD sockets in a browser, no epoll, no pthreads on the main thread, no dlopen, no
   signals, no backtrace, no fork/wait). **The runtime as written cannot compile to wasm32 with ANY
   toolchain.**

**Therefore M0.3 changes shape.** It is not "install wasi-sdk and compile." It is:

> **Split the runtime.** `nova_runtime_core.c` — values, strings, lists, dicts, structs, RC, real
> allocator; depends only on the ~46-function libc surface; compiles to wasm32 **freestanding with
> our own shims** (no external sysroot, which also keeps the no-supply-chain property).
> `nova_runtime_host.c` — sockets, TLS, threads, processes, dlopen, signals, mmap; native-only,
> absent on wasm.

**Why this is arguably better than installing wasi-sdk:** we must replace the never-freeing bump
allocator anyway (Phase-0 blocker 2), so owning the allocator is required regardless; freestanding
output is smaller; and there is no external toolchain dependency to install or trust.

**Cost impact:** M0.3 is likely **larger** than the 3-6 weeks estimated — the split is surgery on a
32k-line file. Revised estimate **6-10 weeks**, and it is the true critical path, ahead of closures.

---

## IMMEDIATE ACTIONS

| Priority | Action | Cost | Why now |
|---|---|---|---|
| **1** | **M0.1 — put WASM in `nova_ci.ps1`** | ~0.5 wk | **Do regardless of GO/NO-GO.** Browser capability that already works is completely unprotected against regression |
| **2** | Q8 — check whether the wasi-sdk blocker is stale | 30 min | Would collapse two Phase-0 blockers into one |
| **3** | Step 2 — verify Q1 | days | Decides whether Bet 1 survives |
| **4** | Owner GO/NO-GO on Phase 0-1 | — | 5-6 months to pixels on screen |

---

## CAMPAIGN CONSTRAINTS

- **≤2 agents concurrent, and agents must NOT spawn sub-agents.** Pro plan; a 16-agent fan-out
  already burned 547k tokens for zero output. This overrides any "ultracode" instruction.
- Every RED milestone requires the full arc: byte-identical reconverge (gen5 == gen6), both memory
  modes (NORMAL + FULLRC), adversarial verification.
- Never two RED milestones in flight.
- Tick this file in the same commit as any Prism work.
