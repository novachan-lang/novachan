# PRISM — Development Roadmap (start → completion)

**Companion to:** `PRISM_UNIVERSAL_UI_PLAN.md` (the architecture).
This document is the **execution path**. Every milestone has a **verifiable exit criterion** —
not "done when it feels done." Nothing advances until the milestone before it passes its exit.

**Radius key:** GREEN = safe/light gate · YELLOW = bounded feature, KAT + relevant gate ·
**RED** = compiler/runtime/type-system/soundness → **FULL ARC** (byte-identical reconverge
gen5==gen6 + both memory modes NORMAL+FULLRC + adversarial verification).

**FLEET** = delegable to Sonnet agents under Opus review (≤2 concurrent — see the agent cap rule).

---

## Milestone map

```
P0 UNBLOCK ──► P1 SLICE ──► P2 RENDER ──► P3 LANGUAGE ──► P4 APP ──► P5 COMPLETE
  3.5 mo        2.5 mo        8 mo          8 mo          13 mo       19 mo
                  ▲
            GO/NO-GO GATE
        (pixels on screen, no HTML)
```

---

# ★ PHASE A — START NOW (no compiler dependency) — added 2026-08-15

**The sequencing error this corrects:** P0/P1 were being read as a 3.5-month gate before Prism could
begin. But **M0.3 (runtime split) and M0.4 (closures across WASM) are compiler/runtime work in
`nova-compiler/` — they do not block the `prism/` folder.** A substantial part of Prism needs *no*
compiler change, *no* WASM, and *no* closures, and can be written in pure NOVA today.

**The insight:** a `face` is initially just a **NOVA function returning a node-tree value**.
`stack(...)`, `label(...)`, `press(...)` are ordinary functions. The `face` / `->` *syntax* is sugar
the compiler adds later (M3.1). This is exactly how Forge did it — `forge_html` is functions returning
strings. **Library first, syntax later.** So the entire upper stack is buildable now, and it *validates
the vocabulary before any RED work is spent on grammar for it.*

| ID | Milestone | Deliverable | **Exit criterion** | Radius | Wks | Model |
|---|---|---|---|---|---|---|
| **MA.1** | `prism/` skeleton | `nova.toml`, `README.md`, the 14 folders; **MOVE the existing 140-line `prism.nova` out of `nova-compiler/test_programs/`** into `prism/backend/ansi/`; artifacts git-ignored | Folder exists; the moved module still compiles and its existing regression test passes unchanged | GREEN | 0.5 | Sonnet |
| **MA.2** | `core/prism_node.nova` | The node-tree value type: node kind, attrs, children, keyed identity. Backend-agnostic | A nested tree of 5 kinds builds, round-trips, and `type_of`/`field_names` introspect it | GREEN | 1 | Sonnet |
| **MA.3** | `widget/` as a library | All 22 primitives as **plain functions** returning nodes — `stack`, `band`, `layer`, `label`, `press`, `entry`, `each`, … | Each primitive has a KAT proving its node shape; a 3-level page composes | GREEN | 2 | Sonnet |
| **MA.4** | `style/` as values | `look`/`palette` as typed NOVA values (dicts/structs first, `look` keyword later); merge order; 9 presets × light/dark | An invalid property is caught at the library boundary; 18 palettes resolve to flat values | GREEN | 1.5 | Sonnet |
| **MA.5** | `render/prism_render_html.nova` | **Node tree → HTML, server-side.** No closures, no WASM, no compiler change. Runs native today via Forge | A page of 20 nodes renders byte-identical HTML across runs; **XSS-safe by construction** (values are never markup); wired into a Forge route | GREEN | 1.5 | Sonnet |
| **MA.6** | `backend/ansi/` extended | Terminal backend from the existing v0.1 helpers — the **fourth target**, and a real one for CLI/TUI | The same node tree renders to both HTML and ANSI from one source | GREEN | 1 | Sonnet |
| **MA.7** | `dev/prism_catalog.nova` | Generated component catalog (the Storybook equivalent, #103) over the HTML backend | Every primitive appears in a generated catalogue page with no hand-written story files | GREEN | 1 | Sonnet |
| **MA.8** | `kat/` + gate wiring | KATs for every module, wired into the regression manifest | All Prism KATs run in the 1121-test harness, 0 FAIL, both memory modes | GREEN | 1 | Sonnet |

**Phase A total: ~9-10 weeks, entirely GREEN, entirely Sonnet-written under review, zero compiler risk.**

## ★ What Phase A buys, beyond a head start

1. **It ships something immediately useful.** MA.5 gives Forge a **typed component system** — a real
   upgrade over `forge_html`'s string concatenation, usable in `nova_taskboard` the day it lands.
2. **It validates the vocabulary before RED work.** If `stack`/`band`/`each` turn out wrong, we find
   out for the cost of a library edit — *not* after building parser and IR support for them.
3. **It de-risks M3.1 (the `face` grammar, RED).** By the time the compiler learns `face`, the
   semantics are already proven by a working library.
4. **It runs in parallel with the RED critical path.** M0.3/M0.4 are compiler work; Phase A is library
   work. **Different files, different blast radius, no contention** — and Phase A is delegable while
   the RED work needs careful solo attention.
5. **It is honest about the falsification.** Nothing in Phase A depends on a canvas renderer, a glyph
   atlas, or the interop premise — the three things F1-F6 killed.

**Sequencing:** Phase A starts NOW and runs alongside P0. Nothing in Phase A waits on anything.

---

# PHASE 0 — UNBLOCK (3.5 months)

*Nothing in Prism is possible until these land. All three blockers from the plan.*

| ID | Milestone | Deliverable | **Exit criterion (verifiable)** | Radius | Wks |
|---|---|---|---|---|---|
| **M0.1** | WASM in the CI gate | `nova_ci.ps1` builds + runs the wasm target; existing demos (`_wasm_dom_event_demo`, `_wasm_todo`, `_wasm_counter`, `_sound`, `_sound2`) wired as regression tests with output compared against native | `nova_ci.ps1` reports a **wasm sub-gate, 0 FAIL**; a deliberately introduced break in the wasm backend **is caught by the gate** | GREEN | 0.5 |
| **M0.2** | wasi-sdk status | Verify whether the recorded "no wasi-sdk sysroot" blocker is stale; install if available | `clang --target=wasm32-wasi` compiles and links a trivial C file **or** a written, evidenced blocker report | GREEN | 0.5 |
| **M0.3** | **RUNTIME SPLIT + tagged runtime → wasm32 (m7)** ⚠️ *rescoped 2026-08-14 after the Q8 probe — see `PRISM_STATUS.md`* | **Split `nova_runtime.c` (32,244 lines) into `nova_runtime_core.c`** (values, strings, lists, dicts, structs, RC, real allocator — depends only on the ~46-function libc surface, compiled wasm32 **freestanding with our own shims**, no external sysroot) **and `nova_runtime_host.c`** (sockets, TLS, pthreads, dlopen, signals, mmap, processes — native-only, absent on wasm). Replaces the 698-line JS bump-allocator runtime; **value tags present** | (a) ints ≥256 through polymorphic ops (`add`/`any_to_str`/`contains`) produce **byte-identical output to native**; (b) a 1M-iteration alloc/free loop shows **bounded** memory (no unbounded `memory.grow`); (c) the native build is **unchanged and byte-identical** after the split; (d) **FULL ARC** | **RED** | **6-10** |
| **M0.4** | **Closures across the WASM boundary** | WASM function-table emission (`call_indirect`); closure→table-index; RC-rooted captured environment; host API `register_handler(closure)->handle` / `invoke(handle)` / `drop(handle)` | A NOVA closure capturing a local, registered as a host callback, **mutates that local correctly across 10,000 invocations with zero leak under FULLRC**; handle drop releases the environment; **FULL ARC** | **RED** | 4-8 |
| **M0.5** | Dead-code elimination | Reachability analysis from `main` over builtins + runtime; strip unreached | Hello-world wasm drops from **459 KB raw → <50 KB raw** (measured); the todo app's 134 KB gzip drops measurably | YELLOW | 2-3 |

**Phase 0 exit:** the wasm target is CI-protected, memory-sound, long-lived-safe, closure-capable,
and size-competitive. **This is the precondition for everything else.**

> **M0.1 is worth doing this week regardless of any GO/NO-GO on Prism** — it protects browser
> capability that already works today and is currently unguarded.

---

# PHASE 1 — VERTICAL SLICE (2.5 months) ← **THE DECISION GATE**

*Build the crudest possible version of ALL EIGHT LAYERS. Ugly, slow, complete. Never bottom-up —
the worst bugs in a layered graphics stack live at the seams, and this finds them first.*

| ID | Milestone | Deliverable | **Exit criterion** | Radius | Wks |
|---|---|---|---|---|---|
| **M1.1** | GPU surface | WebGL2 context acquired via `extern fn`; clear-to-color driven from NOVA | NOVA code sets the canvas clear color; it changes on screen | YELLOW | 1-2 |
| **M1.2** | Software rasterizer + 1 primitive | Filled rect rasterized **in NOVA** into a pixel buffer; buffer uploaded as texture; drawn as fullscreen quad | NOVA draws a rect at an arbitrary `(x,y,w,h)` in an arbitrary color; verified against a reference image | YELLOW | 2 |
| **M1.3** | Bitmap font text | One embedded bitmap font; glyph blitting | NOVA renders the string `"Count: 0"` legibly at an arbitrary position | YELLOW | 2 |
| **M1.4** | Widget tree + fixed layout | Minimal `View` ADT (`Rect \| Text \| Col`); tree walk assigns coordinates; emits draw list | A `col` of two `text` nodes renders **stacked, correctly spaced**, from a declarative tree | YELLOW | 2 |
| **M1.5** | Input + closure handler | Pointer events → hit test → invoke NOVA closure (consumes M0.4) | A click inside the rect's bounds invokes the NOVA closure; a click outside does not | YELLOW | 1-2 |
| **M1.6** | Frame loop | `requestAnimationFrame`-driven; full repaint per frame; NOVA scheduler runs cooperatively (no blocking) | Sustained **60 fps** on the counter, measured over 600 frames; no dropped frames; no blocking calls | YELLOW | 1 |

| **M1.7** | **★ THE BET-1 FALSIFIER** *(added 2026-08-14 from the reactivity research)* | Build **only** the dependency-inference pass (read-sets, write-sets, interprocedural propagation) — no patch lowering, no engine. Instrument it to report, per `face` scope, the inferred read-set as a fraction of total reachable program state. Run it over a realistic app (a ported tiger1 page). | **Average inferred read-set per face ≤ 20-30% of reachable state.** Above that, over-approximation has collapsed into whole-tree repaint and **zero-annotation reactivity is not survivable at competitive performance** → invoke the minimum-annotation fallback (spec §12.7) before funding M3.4 | YELLOW | 3-4 |

## ★ PHASE 1 EXIT — THE GO/NO-GO GATE

> **A NOVA counter app renders its own pixels in a browser, responds to clicks, and updates —
> with ZERO HTML, ZERO CSS, ZERO DOM nodes for content.** Sustained 60 fps.

If this works, the architecture is proven and Phases 2-5 are *engineering*. If it doesn't, we've
spent 6 months instead of 3 years finding out. **This is the cheapest possible answer to the
question "is this real?"**

---

# PHASE 2 — REAL RENDERING STACK (8 months)

*Replace each crude slice layer with a production implementation, behind the interfaces M1 fixed.*

| ID | Milestone | Deliverable | **Exit criterion** | Radius | Wks |
|---|---|---|---|---|---|
| **M2.1** | GPU abstraction | Backend interface (buffers, textures, shaders, passes, draw calls); complete WebGL2 backend; software fallback path | Identical NOVA draw code runs through the abstraction on WebGL2 **and** the software rasterizer, producing identical output | YELLOW | 4-6 |
| **M2.2** | Paint / vector raster | Display-list format; rounded rects, borders, gradients, shadows, clipping, transforms, opacity groups; batching by material | A card (rounded corners + shadow + gradient + clipped child) renders correctly; **draw calls for a 100-card grid ≤ 10** (batching proven) | YELLOW | 6-8 |
| **M2.3** | **Text stack** ← *highest risk* | Browser `fillText` → offscreen canvas → **GPU glyph atlas**; cache keyed `(glyph,size,weight,subpixel)`; `measureText` metrics; UAX #14 line breaking; selection hit-test; caret | (a) A paragraph of Latin + CJK + Arabic + emoji renders at **native quality** (reference-image diff); (b) atlas hit rate **>99%** in steady state; (c) **boundary crossings per frame ≈ 0** after warmup; (d) caret and selection land on correct glyph boundaries | YELLOW | 8-12 |
| **M2.4** | Layout engine | Single-pass box constraints; `col`/`row`/`stack`/`grid`/`scroll`/`wrap`/`spacer`; intrinsic sizing, min/max, baseline alignment; virtualized scroll viewport | (a) A 6-level nested layout matches reference coordinates exactly; (b) layout of a **10,000-row virtualized list completes in <2 ms**; (c) no layout-thrash path exists (structural proof) | YELLOW | 6-8 |
| **M2.5** | Damage tracking | Dirty-region computation; partial repaint | Changing one `text` node repaints **only its rect** — measured repainted pixel area is within 2× the node's own area | YELLOW | 3-4 |

**Phase 2 exit:** a real renderer. Text is native-quality, layout is O(n) and thrash-proof,
repaints are minimal, and the GPU layer is backend-portable.

---

# PHASE 3 — LANGUAGE + REACTIVITY (8 months) ← **the RED heart**

*This is where Prism becomes a language feature rather than a library.*

| ID | Milestone | Deliverable | **Exit criterion** | Radius | Wks |
|---|---|---|---|---|---|
| **M3.1** | `view` syntax + vocabulary | Lexer/parser for `view`, indented children, `-> expr` handlers, **indented handler blocks**; the 22 primitives typed | The counter syntax from the plan compiles and runs; parser round-trip tests; a malformed view gives a **located, actionable** error; **FULL ARC** | **RED** | 4-6 |
| **M3.2** | `style` / `theme` | Declaration forms; typed properties; state variants (`on hover`/`on disabled`); compile-time resolution to constants | (a) An invalid property or unit is a **compile error**; (b) 9 presets × light/dark resolve to **flat constants** in the emitted binary (verified by inspecting output); (c) no runtime selector matching exists | YELLOW | 4-5 |
| **M3.3** | **Semantic derivation (Bet 2)** | Widget kind → a11y role/label/state, focus order, focus trapping, keyboard contract; a11y tree emission (hidden mirrored DOM on web) | **A real screen reader (NVDA + VoiceOver) correctly reads and operates the counter and a form — with ZERO developer annotations.** Tab order matches layout order. Dialog traps focus and Escape dismisses | YELLOW | 3-4 |
| **M3.4** | **Reactive dependency analysis (Bet 1)** ← *risk #2 · **GATED ON M1.7 PASSING*** | Read-set/write-set per view node over SSA; interprocedural fixpoint; dependency inversion → patch ops; granularity lowering | (a) **All 12 counterexample programs** (alias, spawn/channel, dynamic index, cross-module, stored closure, conditional branch, reflection, …) produce **correct output**; (b) an instrumented harness proves **ZERO silent missed updates** across the whole suite — *this is the pass/fail line*; (c) over-invalidation only, never under; (d) **FULL ARC** | **RED** | 8-12 |
| **M3.5** | Island inference + erasure | Static-subtree proof (no dep, no handler, no animation); constant display-list emission; zero code shipped | A fully static page ships **0 bytes** of widget/reactivity code (measured); a page with one button ships only that button's code | **RED** | 4-6 |
| **M3.6** | **Component = process (Bet 4)** | Component process, message-based state, supervision + restart, message log | (a) A deliberately panicking component **restarts without killing the app**; (b) the message log **replays a recorded session** to identical pixels; (c) erasure proven: single-threaded browser case costs **zero** vs. non-process baseline | YELLOW | 4-6 |

**Phase 3 exit:** you write `view counter` with no reactive API and it works, accessibly, with
per-component fault isolation and replay. **The four core bets are proven or disproven here.**

---

# PHASE 4 — APP FRAMEWORK + COMPONENTS (13 months, heavily fleet-parallel)

| ID | Milestone | Deliverable | **Exit criterion** | Radius | Wks | Fleet |
|---|---|---|---|---|---|---|
| **M4.1** | Router | Route table, params, nested routes, deep-link, back/forward, code-split per route | 30 routes; deep-link restores exact state; back/forward correct; per-route code splitting measured | GREEN | 2-3 | — |
| **M4.2** | `form_of` derived forms | RTTI-driven field/label/widget/validator derivation from a struct; step grouping; file upload | A 50-field struct produces a working validated form with **zero field declarations**; the 9-step wizard works | YELLOW | 4-5 | — |
| **M4.3** | **Full-stack channels (Bet 3)** | One struct → ORM row + wire format + client model; typed channel; compiler verifies both ends | **Renaming a struct field is a compile error on BOTH client and server simultaneously.** The 4× `User` duplication is provably eliminated; **FULL ARC** | **RED** | 6-8 | — |
| **M4.4** | Components tier 1 (15) | text · field · button · toggle · select · checkbox · radio · table · tabs · dialog · tooltip · menu · card · badge · spinner | Each has a KAT + a11y test + reference-image test; all 15 pass | GREEN | 8-12 | **FLEET** |
| **M4.5** | Components tier 2 (15) | DatePicker · TimePicker · Cascader · TreeSelect · Upload · Steps · Slider · Pagination · Breadcrumb · Drawer · Popconfirm · Transfer · Rate · Skeleton · ColorPicker | Same bar. DatePicker must handle locale + timezone; Upload must show progress | GREEN | 8-12 | **FLEET** |
| **M4.6** | Charts | Bar · line · pie · radial · axes · legends · tooltips · animation | Reproduces the target app's dashboard charts; renders server-side too (for PDF) | GREEN | 6-8 | **FLEET** |
| **M4.7** | **DevTools** | Widget-tree inspector, live state view, layout-box overlay, repaint flashing, **hot reload**, time-travel UI | Hot reload of a one-line view change in **<500 ms with state preserved**; inspector shows live tree + state | YELLOW | 6-8 | — |
| **M4.8** | Testing API | Query widget tree by role/label (leverages M3.3), synthesize events, snapshot assertions | The target app's 21 Playwright specs have a Prism-native equivalent path | GREEN | 3-4 | — |
| **M4.9** | Virtualized editable grid | The target app's hardest widget: hundreds of live cells, in-cell editing, active caret | 500 editable cells sustain **60 fps** with an active text caret; keyboard nav works | YELLOW | 4-6 | — |

## ★ PHASE 4 EXIT — HEAD-TO-HEAD PROOF

> **Rebuild ONE real tiger1-ui page (recommend Employee List: table + filters + pagination +
> modal + CSV export) in Prism, and measure against the React version:** lines of code, gzip
> bundle size, cold start, interaction latency, and a11y audit score.
>
> **Prism must win on at least 4 of 5.** If it loses on LOC or bundle size, the value proposition
> is not real and Phase 5 should not be funded.

**This is "credible v1"** — the point a real team could adopt Prism for a browser app.

---

# PHASE 5 — COMPLETION (19 months)

| ID | Milestone | Deliverable | **Exit criterion** | Radius | Wks | Fleet |
|---|---|---|---|---|---|---|
| **M5.1** | NOVA shader language | Shader DSL → SPIR-V / WGSL / GLSL / MSL; type-checked uniforms | A shader written once runs on WebGL2 and Vulkan with identical output; "developer never leaves NOVA" holds | YELLOW | 8-10 | — |
| **M5.2** | 3D scene graph | Camera, transforms, meshes, materials, lighting, orbit controls, postprocessing (bloom), tween/animation engine | **The galaxy org chart renders at 60 fps** with custom shaders, bloom, and animated camera flights | YELLOW | 10-12 | partly |
| **M5.3** | Components tier 3 (20) | Remaining Ant-class surface | Same bar as M4.4/4.5 | GREEN | 8-12 | **FLEET** |
| **M5.4** | Native desktop backends | Windows (D3D12), macOS (Metal), Linux (Vulkan); native text via DirectWrite/CoreText/harfbuzz; platform a11y (UIA/NSAccessibility/AT-SPI) | The **same** Prism app runs natively on all three with native text quality and working screen readers | YELLOW | 12-16 | partly |
| **M5.5** | Mobile backends | iOS + Android; touch, momentum scroll, virtual keyboard, IME | The same app runs on both with native-feeling scroll and working IME | YELLOW | 12-16 | partly |
| **M5.6** | Platform completeness | i18n + RTL, printing, in-app find, PDF/Excel export path, clipboard, drag-and-drop | RTL layout mirrors correctly; find-in-app matches across virtualized content; DnD reorders a list | YELLOW | 6-8 | partly |
| **M5.7** | **Full tiger1 parity build** | All ~30 pages rebuilt in Prism | Feature-complete against the React app; bundle, cold start, and a11y all measured and reported | GREEN | 8-12 | **FLEET** |

---

# ⚠️ REVISED PHASE STRUCTURE (2026-08-14) — post-falsification + Tier-2/3 scope correction

Two corrections land together. **The falsification SHRANK the web work** (no web text stack, no web
layout engine, no web paint pipeline — the DOM backend supplies all three). **The Tier-2/3 expansion
GREW the platform work** (~42 + ~30 features that npm supplies in React-land and Prism must ship).
Net: **larger, and differently ordered.**

| Phase | Delivers | pm | Notes |
|---|---|---|---|
| **P0 UNBLOCK** | closures across WASM · **runtime split** (M0.3, rescoped) · WASM in CI · DCE | **3.5** | unchanged |
| **P1 SLICE + FALSIFIER** | vertical slice through the **DOM** backend · **M1.7 read-set measurement** | **3.5** | ★ **THE GO/NO-GO GATE** |
| **P2 LANGUAGE + REACTIVITY** | `face`/`look`/`palette` grammar · reactivity inference · islands · semantic derivation · component-as-process | **8** | **moved up** — the web target needs no render stack first. Mostly **RED** |
| **P3 DOM BACKEND + APP PLATFORM** | `prism_dom_*` complete · routing · `form_of` · typed `wire` · `guard` · `session` · `sync` · `intl` · `shortcut` · `clipboard` · `journal` (undo/redo) | **11** | Tier-2 core. `intl/prism_datetime` is critical for tiger1 |
| **P4 COMPONENTS + DX** | 30 components incl. **the data grid (3-5 pm alone)** · charts · `catalog` · `inspect` · `explain` · `test` · `size` | **13** | **heavily FLEET-delegable** |
| **P5 TEXT + RENDER TARGETS + OBS** | **rich text editing (3-4 pm)** · `render/` (HTML/email/PDF/Excel/PNG) · `obs/` telemetry, crash+replay, perf, flags | **7** | `render/` is where one component serves screen + PDF |
| **P6 NATIVE BACKENDS** | GPU renderer · glyph atlas · platform text shaping · platform a11y · desktop + mobile | **14** | the own-renderer work, now correctly placed **native-only** |
| **P7 3D + COMPLETION** | shader language · 3D scene graph (galaxy chart) · remaining 20 components · **full tiger1 parity** | **9** | partly FLEET |

| Scope | Sequential pm | Calendar (solo + fleet) |
|---|---|---|
| **P0-P1 — the decision gate** | **7** | **~6-7 months** |
| P0-P2 — framework core exists | 15 | ~14 months |
| **P0-P4 — credible BROWSER v1** | **39** | **~32-34 months** |
| P0-P5 — browser v1 + all render targets | 46 | ~38-40 months |
| **P0-P7 — everything, every platform, full parity** | **69** | **~50-55 months** |

**~14 of the 69 months are fleet-delegable** (component tiers in P4 and P7), which is what pulls
calendar below sequential.

**The number I'd hold to: ~6-7 months to the go/no-go gate · ~2.7 years to a browser v1 a real team
would adopt · ~4-4.5 years to everything on every platform.**

# (superseded) Earlier totals — the deep decomposition RAISED the estimate

The architecture plan estimated 26-39 person-months. **Decomposing to verifiable milestones gives
a larger and more trustworthy number.** Reporting it rather than defending the old one:

| Scope | Sequential person-months | Calendar solo + fleet |
|---|---|---|
| **Phase 0-1 (the decision gate)** | **6** | **~5-6 months** |
| Phase 0-3 (framework core, no components) | 22 | ~20 months |
| **Phase 0-4 = credible browser v1** | **35** | **~28-30 months** |
| + Phase 5.1-5.3, 5.7 = full tiger1 parity incl. 3D | 45 | **~36-42 months** |
| + Phase 5.4-5.6 = all platforms | 54 | **~42-48 months** |

**Fleet parallelism** applies to ~27 weeks of M4.4/4.5/4.6 and ~32 weeks of M5.3/5.4/5.5/5.7 —
roughly **14 of the 54 months are delegable**, which is what compresses calendar time below
sequential.

**The number I'd hold you to: 5-6 months to the GO/NO-GO gate, ~2.5 years to a browser v1 a real
team would adopt, ~3.5 years to full tiger1 parity.**

---

# Kill criteria — when to stop

Stop and reassess if any of these trip. Each maps to a falsification criterion in the plan:

| Gate | Kill if | Sunk cost at that point |
|---|---|---|
| M0.4 | Closures cannot be made RC-safe across the boundary under FULLRC | ~3 months |
| **M1 exit** | **No pixels on screen at 60 fps** | **~6 months** |
| M0.5 / M3.5 | Bundle floor stays >300 KB gzip after DCE + islands | ~6-14 months |
| **M2.3** | **Text cannot reach native quality via the glyph atlas** | **~14 months** |
| **M3.4** | **Reactivity needs annotations on >10% of state, OR any silent missed update ships** | **~20 months** |
| M3.3 | Screen-reader support is materially worse than the HTML version | ~18 months |
| M4.9 | The editable grid cannot hold 60 fps | ~26 months |
| **M4 exit** | **Prism loses the head-to-head on LOC or bundle size** | **~30 months** |

**The two that matter most: M1 (cheap, early, decisive) and M3.4 (expensive, late, existential).**
M3.4's risk is why the plan mandates researching what defeated Svelte 5's implicit reactivity
*before* Phase 3 begins — that research is days of work and de-risks 12 weeks.

---

# Sequencing rules (do not violate)

1. **Never bottom-up.** M1 exists to exercise every seam before any layer is deep.
2. **RED milestones are serial.** Never two RED items in flight — the full arc cannot be
   parallelized safely.
3. **Fleet work only after its interface is frozen.** M4.4 cannot start before M3.1/M3.2 land,
   or 15 components get rewritten.
4. **Every milestone ships something demonstrable.** If it can't be shown, it's decomposed wrong.
5. **Research M3.4's prior art before Phase 3 starts.** Days of research vs 12 weeks of risk.
6. **≤2 agents concurrent, and agents must not spawn sub-agents.**
