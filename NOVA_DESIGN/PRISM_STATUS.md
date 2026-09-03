# PRISM — STATUS TRACKER

**This is the single entry point for the Prism campaign.** Read this first; every other Prism
document is indexed here with its real completeness.

> Subordinate to `EXECUTION_STATE.md`, which remains THE master tracker for the whole project.
> This file tracks the Prism campaign only. Do not create further Prism trackers.

---

## ✅ 2026-08-14 — PRISM ALREADY EXISTS. This work is its **v1.0**, not a new framework.

Verified against `FRAMEWORK_ECOSYSTEM_STRATEGY.md`. **Prism is Framework #5 of the designated 9**
(Forge, Cortex, Pulse, Mesh, Sentinel, Ops, Reactor, **Prism**, Edge) and **v0.1 already shipped**
(`bccc2fd`). The name was not available to invent — it was already assigned, **to exactly this job.**

**Existing implementation:** `nova-compiler/test_programs/prism.nova` — **140 lines** of ANSI
terminal helpers (`clear`/`move`/`color_fg`/`box`/`table`/`progress_bar`/`spinner`/`bold`/`link`).
Its own header states the intent plainly:

> *"v0.1 ships text-mode (ANSI escape) helpers because the target machine has no wgpu/Vulkan SDK
> installed; **v0.2+ will add GPU-accelerated GUI rendering via FFI to wgpu.** The API SHAPE is the
> same: build a frame string, write it to the screen."*

**The strategy doc's Prism mandate already matches this design almost exactly:**

| Strategy doc (pre-existing) | This design |
|---|---|
| *"Each window is a process. Each heavy computation is a process. The UI process sends render commands over a channel to the platform renderer."* | Bet 4 — **component = supervised process**; patches over a channel |
| *"GPU-accelerated via wgpu from V1. Not a web view. Not a CPU-rasterized toolkit."* | The **native GPU backend** (`backend/gpu/`) |
| *"GPU-rendered custom widgets with pixel-identical rendering across Windows/macOS/Linux"* | §9.14 deterministic rendering |
| *"Full accessibility support (screen reader, keyboard nav, high contrast) built in from day one — not an afterthought"* | Bet 2 — **derived** a11y, spec §13 |
| *"Replaces Electron, Tauri, Qt, GTK, SwiftUI, WPF/WinUI, JavaFX, Dear ImGui"* | the competitive frame |
| *"Ship on ALL Tier 1 platforms from day one: Linux, macOS, Windows, WASM, iOS, Android"* | backend-swappable, §2 |

**⇒ Nothing about the name or the direction needs to change.** This work adds four things the
existing mandate did not specify: the **`face` vocabulary**, **zero-annotation reactivity**, the
**web/DOM backend**, and **full-stack typed channels**.

### ⚠️ ONE divergence that must be stated explicitly

The strategy doc says **"Not a web view. Not web-in-a-box."** The F1-F6 evidence says the **web
backend should emit real DOM elements.** These are **not** in conflict, and the distinction matters:

- **What the doc rejects (correctly):** shipping a browser engine inside a desktop app — Electron/
  Tauri, a webview wrapping HTML, "web-in-a-box." Prism still rejects that absolutely. The desktop
  target is GPU/wgpu with no webview anywhere.
- **What Prism now does on the *web* target:** a compiled NOVA/WASM program emitting real DOM
  elements from a closed, typed vocabulary. There is no webview, no HTML authoring, no JS framework,
  no npm — the developer writes `face`, never markup. Using the browser's *own* native widgets when
  running *inside a browser* is not web-in-a-box; it is using the platform's native toolkit, exactly
  as the desktop backend uses the platform's GPU.

**Recorded as a deliberate refinement of the strategy doc, backed by F1-F6** (the interop premise is
false, the batched protocol already lost, and browser text shaping is inaccessible — see below).

### Migration note
The existing 140-line `prism.nova` lives in `nova-compiler/test_programs/`, which is the wrong home.
It moves to `prism/` per the structure below. Its ANSI helpers stay useful as a **terminal backend**
(`backend/ansi/`) — a genuinely valuable fourth target for CLI/TUI tools, and already written.

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

## WHERE WE ARE RIGHT NOW — updated 2026-09-02

⚠ **This block said "PRE-PHASE-0 — nothing is built, ≈2%" until 2026-09-02, long after Phases A
and B had shipped ~42k lines.** It was written before MA.1 and never revised, so it misdescribed
the campaign by two whole phases. Corrected here; keep it corrected.

**Phase:** A ✅ complete · B ✅ (67 `ui/` components) · **C in progress — the SUPPORTING layers**.

**As built, counted not estimated:** 93 modules + 90 KATs, **42,163 lines**, all CI-gated through
`_prism_kat_gate.ps1` (`[CI 2m/3]`, which DISCOVERS `prism/kat/_kat_*.nova` rather than taking a
hard-coded list).

**Where the real gap is, and it is NOT `ui/`:** `ui/` is OVER-delivered (67 vs ~50 planned) while
the layers beneath it are near-empty. Built / planned:

| folder | built | planned | still missing |
|---|---|---|---|
| `core/` | 3 | 7 | `prism_caps` `prism_key` `prism_journal` `prism_secret` |
| `text/` | 2 | 4 | `prism_select` `prism_find` `prism_richedit` |
| `obs/` | 1 | 4 | `prism_telemetry` `prism_perf` `prism_crash` `prism_flag` |
| `dev/` | 2 | 8 | `prism_test` `prism_visual` `prism_explain` `prism_size` `prism_tokens` `prism_audit_a11y` |
| `intl/` | 1 | 4 | `prism_i18n` `prism_datetime` `prism_number` |
| `render/` | 1 | 4 | `prism_render_image` `prism_render_pdf` `prism_render_sheet` |

**★ The finding that reordered the work:** `core/prism_event.nova` did not exist, so **67 UI
components existed and NOT ONE could respond to anything** — `press`/`entry`/`pick`/`flag` all
constructed and rendered, but no value represented "this was activated". PRISM rendered; it was
not interactive. `core/` therefore comes before component #68, and `text/` selection, `a11y/`
focus and `dev/` interaction tooling all sit on top of it.

**Blocking decision (unchanged):** owner GO/NO-GO on **T11 / M0.3, the runtime split** — RED, full
arc, and the gate for everything browser-side (T12 closures-across-WASM, T13 DCE, T14 the DOM
vertical slice, T15 the Bet-1 falsifier). Phase C needs no compiler work, so it proceeds without
that decision.

**Tracked debt:** MB.1–MB.59 (~29,887 lines) predate the 2026-08-18 high-level-NOVA mandate and
carry 346 banned low-level patterns; MB.60+ comply. That retrofit is unscheduled. `T8b` is still
⛔ BLOCKED (taskboard sources overwritten with LLVM IR dumps).

### Honest completeness

The old ≈2% figure measured the SPECIFICATION against a hypothetical buildable spec. That is the
wrong denominator now that the library exists and is gated: the `ui/` vocabulary is complete and
proven to compose, and what is genuinely unbuilt is (a) the ~23 supporting modules above and
(b) all of Phase 0's runtime work, which is a compiler campaign rather than a spec gap.

---

## ⛔ 2026-08-18 — STANDARD CHANGE: Prism must be written in HIGH-LEVEL NOVA (owner-mandated)

The owner has said this repeatedly and I ignored it for 59 milestones. Measured across the
**29,887 lines** of Prism NOVA written up to MB.59:

| High-level feature | Uses | | Banned low-level pattern | Uses |
|---|---|---|---|---|
| `.map()` | **0** | | `" + str(` concat | 234 |
| `.filter()` | **0** | | `idx += 1` | 58 |
| `.zip()` | **0** | | `let mut idx` | 54 |
| list comprehension | **0** | | | |
| interpolation `"{x}"` | 9 | | | |
| ternary | 5 | | | |
| **total high-level** | **14** | | **total low-level** | **346** |

**25 low-level constructs for every 1 high-level one, and literally zero uses of map/filter/zip/
comprehensions in 30k lines of a language that has all four.** The cost was ~2x the line count, so
~2x compile time and token spend, and NOVA's best features sat untested — the same rot that left
generics effectively unused for a year. It also made the flagship UI framework a poor advertisement
for the language it is written in.

**The law is now recorded in memory** (`feedback_use_nova_high_level_features_mandatory.md`) with a
banned→required substitution table, and it is pasted into every implementation agent's prompt.
Enforcement is a pre-commit grep that must return zero:
`grep -nE 'let mut idx|idx \+= 1|" \+ str\(|\? for '`.

### 🔴 …but auditing WHY those counts were zero found a real soundness bug

Before mandating `map`, I probed whether NOVA's HOFs actually compose with `Result` — every
`prism_*` constructor returns `Result<PrismNode>`, so mapping a list means `?` inside a lambda.
Evidence: `nova-compiler/test_programs/_probe_hof_{result,err,safe}.nova` + `_probe_collect.nova`,
committed as `17b00011`.

| Construct | Failing element | Verdict |
|---|---|---|
| `xs.map(fn(s) mk(s)?)` | `is_ok=TRUE`, element becomes `"<struct>"` | ⛔ **silent corruption** |
| `[mk(s)? for s in xs]` | `is_ok=TRUE`, element becomes `"<struct>"` | ⛔ **silent corruption** |
| `for s in xs: out.push(mk(s)?)` | `is_err=true`, `"REJECTED_EMPTY"` | ✅ correct |

`?` in a lambda body neither propagates to the enclosing fn nor surfaces as a `Result` — the
un-unwrapped error struct is pushed into the output list. **It compiles clean with no warning, and
the happy path returns correct values, so no non-error test can catch it.**

**Consequence: Prism's hand-rolled collect loops were CORRECT.** Blanket-converting them to
`map(fn(x) f(x)?)` — exactly what the new law would naively instruct — would have injected silent
data corruption into all 60 modules. Verified-safe traverses instead:
`prism_ui_kit.prism_ui_collect` (already existed at `prism_ui_kit.nova:57`, propagates correctly),
`map` without `?` + `any_match(is_err)` + `map(unwrap)`, or validate-first-then-`map(unwrap)`.

⇒ So the split is: **Result-mapping loops stay**; the 234 string concats, plain-value index loops,
value-returning if/else ladders, and copy-pasted KAT blocks are the real waste and are being fixed.
Compiler fix for the `?`-in-lambda bug is **deferred — RED blast radius, needs explicit go-ahead.**
Tracked in memory as `reference_question_mark_in_lambda_silently_corrupts`.

### Measured effect of the standard change

| Milestone | Comp LOC | KAT LOC | Banned | Interp | Compr | Lambda | Assertions |
|---|---|---|---|---|---|---|---|
| MB.60 as first written | 244 | 318 | **23** | ~0 | 0 | 0 | ~60 |
| MB.60 rewritten | 147 | 253 | 0 | 39 | 0 | 2 | 118 |
| MB.61 tabs | 114 | 212 | 0 | 17 | 0 | 0 | 54 |
| MB.62 slider | 158 | 210 | 0 | 39 | 3 | 2 | **193** |

Component LOC roughly halved; KAT assertion density went from ~2.5 lines/assertion to ~1.
Also dropped: the full 79-KAT gate no longer runs per milestone (only the new KAT compiles+runs),
since a purely additive library file cannot regress the others — the full gate runs at batch
boundaries instead.

---

## ★ LIVE TASK LIST — tick this on START and on COMPLETION, same commit as the work

**Statuses:** `⬜ TODO` · `🔄 IN PROGRESS` · `✅ DONE` · `⛔ BLOCKED` · `❌ KILLED`
**Rule:** set `🔄` + start date when beginning. Set `✅` + date + **the measured result** when the exit
criterion passes. Never "done" without the measurement. Killed items stay, with the evidence.

| # | Task | Status | Started | Finished | Result / note |
|---|---|---|---|---|---|
| **MC.23** | `dev/prism_visual.nova` — visual regression on deterministic renders (#104) | ✅ **DONE** | 2026-09-03 | 2026-09-03 | **31 assertions ALL PASS.** Screenshot testing is flaky everywhere else because the render is not deterministic (font hinting, GPU driver, subpixel AA), so teams keep per-platform baselines and a tolerance that hides real regressions. Prism's renderers are byte-reproducible (§15.9), so a baseline is an EXACT sha256 with **no tolerance at all** — sound only because determinism is a property the renderers actually hold, which `prism_render_pdf` asserts directly. ★ **A mismatch LOCALISES**: first differing offset, both sizes, and a window from each side — "snapshot differs" is why people stop trusting snapshot suites, since it cannot tell a one-word copy edit from a layout collapse, so the habit becomes re-baseline-and-move-on and the test becomes decoration. ★ **Re-recording a reviewed baseline is an ERROR** (silent overwrite lets a regression become the new truth) and **a MISSING baseline is a FAILURE, not an implicit pass** (otherwise a renamed snapshot stops testing anything while the suite stays green). ⛔ Caught my own design flaw mid-build: the first version stored only the hash and then tried to report a first-differing offset — impossible, nothing to diff against. The baseline now keeps its text; localisation is the whole point |
| **MC.24** | ★ `dev/prism_explain.nova` — why a subtree repaints — **`dev/` NOW 8/8** | ✅ **DONE** | 2026-09-03 | 2026-09-03 | **25 assertions ALL PASS.** ⛔ **READ-SETS ARE DELIBERATELY NOT IMPLEMENTED, and `prism_exp_readsets_available()` returns FALSE.** The dependency-inference pass is M3.4, which is gated on **M1.7 — the Bet-1 falsifier**, whose entire purpose is to measure whether zero-annotation reactivity is survivable (>20–30% read-set per face kills the bet). Emitting a plausible-looking read-set would **fabricate the very number the falsifier exists to measure**, and would make the bet look settled. The report states the limitation **to the reader**, not just in a source comment — a tool that quietly omits half of what it promised teaches users to over-trust the other half. ★ What it DOES explain is real today: **INVALIDATION SCOPE from IDENTITY.** A keyed node can be matched across renders; an unkeyed one must be replaced with everything beneath it — so the cost is the DESCENDANT COUNT, and hotspots are ranked widest-first because "this unkeyed band repaints 340 nodes" is actionable while "this node is unkeyed" is not. Childless unkeyed leaves are excluded so the signal does not drown in noise |
| **MC.21** | `render/prism_render_sheet.nova` — grid → delimited text (#117) | ✅ **DONE** | 2026-09-03 | 2026-09-03 | **23 assertions ALL PASS.** ★ **RFC 4180 quoting**, which is the classic silent CSV corruption: a cell containing the delimiter, a quote or a newline is quoted (embedded quotes DOUBLED, not backslashed), and a plain value is NOT quoted — over-quoting is not "safe", it changes the value for readers that treat quotes literally. Quoting is delimiter-aware, so a comma is plain in TSV. ★ **A header-count mismatch is an ERROR**, as is a ragged row: padding would shift every later column under the wrong header, which produces a file that looks plausible and is wrong — the failure mode worth refusing. ⛔ **Found a `widget/` gap: `prism_grid` validates its column names then stores only `{columns: N}`, dropping the names** — so a sheet cannot recover its own header row and headers are a required argument. **Scope stated honestly: CSV/TSV, not .xlsx** — a real xlsx is a ZIP of XML and deflate does not exist in this runtime, so emitting a file named .xlsx that is not one would be worse than honest CSV |
| **MC.22** | ★ `render/prism_render_pdf.nova` — a real, openable PDF (#117) | ✅ **DONE** | 2026-09-03 | 2026-09-03 | **34 assertions ALL PASS.** ★ **DETERMINISTIC BY CONSTRUCTION** — no CreationDate, no Producer, no order-dependent IDs; two renders of one tree are asserted BYTE-IDENTICAL, and a different title is asserted to change the bytes so "identical" cannot pass vacuously. §15.9 makes this a security property ("a rendered frame can be hashed and attested") and a PDF is the output people actually archive, so a timestamp would destroy it for the format that needs it most. ★ **The xref table is the whole difficulty:** a PDF carries BYTE OFFSETS a reader seeks by, fixed-width at 10 digits, and one short field shifts every later entry — so offsets are ACCUMULATED as objects are emitted, never recomputed from a second pass (which is how the table and body drift). Asserted structurally: object 1's offset must be exactly `0000000009`, just past the 9-byte header. Overflowing content is an ERROR, not a truncation — a PDF that silently drops content is worse than one that refuses to build |
| **MC.19** | `intl/prism_datetime.nova` — civil date/time from an epoch second | ✅ **DONE** | 2026-09-03 | 2026-09-03 | **26 assertions ALL PASS, first run.** ⛔ **UTC only, offset is an EXPLICIT argument** — a formatter that silently uses the host zone renders the same instant differently on a server than on a laptop, and only in production. **DST is deliberately NOT modelled:** a correct answer needs the IANA database this runtime lacks, and a WRONG DST answer is worse than none because it looks authoritative. Uses Hinnant's civil-from-days (exact integer arithmetic, no month-length table). Three cases chosen because naive implementations fail them: **1900 is NOT a leap year while 2000 IS** (a `% 4` rule gets exactly that pair wrong); **pre-1970 instants need FLOOR division**, since NOVA's `/` truncates toward zero so `-1/86400` is 0 and every negative epoch lands a day late; and **12-hour midnight/noon** (`0 → 12 AM`, `12 → 12 PM`, which `hour % 12` renders as "0 AM"/"0 PM") |
| **MC.20** | ★ `intl/prism_i18n.nova` — catalogues, interpolation, plurals — **`intl/` NOW 4/4** | ✅ **DONE** | 2026-09-03 | 2026-09-03 | **37 assertions ALL PASS.** ★ **A MISSING KEY IS AN ERROR, never the key echoed back** — echoing is the industry default and it ships `checkout.submit` to users in exactly the locale nobody on the team reads, with the build still green. ★ **Plurals are a CATEGORY FUNCTION, not `n == 1`:** Polish 2–4 → `few` but **12–14 → `many`** is asserted, and an UNIMPLEMENTED rule is REJECTED at catalogue construction rather than falling back to English's two forms, which would mis-pluralise every number in that locale silently. The audit reports BOTH directions — missing keys AND stale ones, since reporting only the first lets catalogues accumulate dead weight after a rename. ⛔ **Cost me two debugging rounds: a bare `{` in the KAT's catalogue DATA is interpolated by NOVA at COMPILE time**, so the stored template contained no placeholder and every interpolation test passed vacuously. Second time this session a bare brace silently changed a test — noted in-file |
| **MC.18** | `intl/prism_number.nova` — locale number/percent/currency | ✅ **DONE** | 2026-09-03 | 2026-09-03 | **35 assertions ALL PASS.** ⛔ **NO FLOATS ANYWHERE, and that IS the design.** Money is INTEGER MINOR UNITS with an explicit scale (1234 @2 = $12.34). Every currency bug of consequence starts with a float: 0.1+0.2 != 0.3, a rounding mode nobody chose, a total that disagrees with the sum of its rows by a cent — and NOVA adds its own reasons, since float compare is documented unsound here and float FORMATTING is platform-sensitive, so the same invoice could render differently on two machines. Same call `obs/prism_telemetry` made omitting float fields. ★ **Grouping is DERIVED from three locale parameters, not tabulated per locale** — a table of formatted examples rots, three parameters cannot. **Indian grouping (2;3 → 1,23,45,678) is included deliberately: it is the case a naive "every three digits" implementation gets wrong, and the error is invisible to anyone who only tests en-US.** The KAT caught my first separator condition, which produced `1,234567` — a separator belongs where `from_right == lead` OR `(from_right - lead) % size == 0`, and I had only the second clause, so the trailing group never got its separator. Zero-padding asserted too: 5 minor units @2 is `0.05`, not `0.5` |
| **MC.16** | `dev/prism_tokens_dev.nova` — design-token export (#108) | ✅ **DONE** | 2026-09-03 | 2026-09-03 | **24 assertions ALL PASS.** ★ **An exporter, NOT a second source of truth** — every value is read back through `style/prism_tokens`' own accessors and the KAT asserts EQUALITY with them, so "the export says 16px, the app renders 14px" is impossible rather than merely unlikely. That drift is the classic way a design system rots, because the two numbers live in different files and nothing compares them. Enumerates the CLOSED enums MB.7 built, so a token added without being exported is unrepresentable — there is no list to remember to update. WCAG 1.4.8's 3:2 leading ratio is asserted THROUGH the export. Names are `--prism-*`/`prism.*` prefixed because CSS custom properties land in the HOST PAGE's global namespace. ⛔ **Named `prism_tokens_dev`, not `prism_tokens`** as dev/README.md says: `prism/**/*.nova` is FLATTENED into `lib/`, so two files with that basename would collide and one would silently win — module basenames are a GLOBAL namespace here, not a per-folder one |
| **MC.17** | `dev/prism_audit_a11y.nova` — the a11y report + gate (#105) | ✅ **DONE** | 2026-09-03 | 2026-09-03 | **18 assertions ALL PASS.** Separate from `a11y/prism_a11y` on purpose: that module holds the RULES, this one answers "can I ship this?". A new rule is therefore added in exactly one place and this file never learns it exists — the audit enumerates whatever the engine returns. ★ **The gate fails on ERRORS ONLY, and that is load-bearing:** a gate that blocks on advisory findings gets switched off within a week, and then the blocking ones stop being seen too. Both halves asserted — warnings are reported and counted but never fatal. `clean()` is deliberately STRICTER than the gate (no findings at all), because naming them the same would let a team believe warnings had been dealt with. ★ Testing it surfaced better news than expected: the WIDGET layer already REJECTS a nameless press, so that state is unrepresentable through the sanctioned constructor and the audit is a second line of defence — the KAT now asserts both, and drives the audit through the lower-level node API, which is the route a backend-generated tree actually takes |
| **MC.15** | `dev/prism_size.nova` — per-route size budgets (#106) | ✅ **DONE** | 2026-09-03 | 2026-09-03 | **31 assertions ALL PASS.** A size REPORT is read once, when someone is already worried; a size BUDGET fails the build on the commit that crossed it — the only moment the information is cheap, because the diff that added 40 KB is still on screen. Every route regression that ever shipped got there one harmless commit at a time. ★ **The error names the LIMIT and the OVERAGE**: "too large" cannot be acted on, and 2% over (trim something) vs 4x over (wrong import) are different bugs. ★ **EVERY exceeded limit is reported, not just the first**, so one build tells the whole story instead of making the author fix-rebuild-discover. `0` means unlimited; NEGATIVE is rejected, because a negative limit is far likelier a computed value gone wrong than an intention. **Backend-agnostic by construction** — it never imports a renderer, since a tree costs different bytes as HTML than as canvas ops; the caller passes the rendered string. Bytes are BYTE length (the one place `len()`'s byte semantics is correct rather than a trap): a 3-code-point CJK string costs 9, asserted. ⛔ KAT gotcha recorded in-file: a BARE `{` in a string is parsed as an INTERPOLATION, so `starts_with(rj, "{")` does not test what it looks like — the module was right, the assertion was wrong |
| **MC.14** | ★ `dev/prism_test.nova` — testing API, query by DERIVED role/label (#47) | ✅ **DONE** | 2026-09-03 | 2026-09-03 | **31 assertions ALL PASS, first run** (+ prism_node and widget KATs re-run, since core/ was touched). A test that says "the second child of the third band" asserts the IMPLEMENTATION — it breaks on every harmless refactor and passes when the UI is unusable. Query-by-role asserts what a user (and an assistive technology) can perceive. §9 makes this stronger than the web equivalent: the role is DERIVED FROM THE TYPE, so it cannot drift from behaviour the way a hand-written `role=` can. ★ **The derivation was added to `core/prism_node.nova` (`prism_node_role_of`), NOT re-implemented in dev/** — §9's guarantee only holds if there is exactly ONE derivation, and three copies (test, a11y, backends) would be three chances to disagree, invisibly, until an assistive technology got it wrong. ★ **ZERO matches and MULTIPLE matches are BOTH errors:** returning the first of several is the most damaging convenience a testing API can offer — the test goes green while asserting against an element the user never sees, and keeps passing after the real one is deleted. Ambiguity is also an a11y defect in the UI itself (two identically-labelled buttons), so it is reported, never resolved by guessing. Layout kinds return `""`, never a magic `"generic"` |
| **MC.12** | ★ `obs/prism_telemetry.nova` — typed analytics (#96) | ✅ **DONE** | 2026-09-03 | 2026-09-03 | **33 assertions ALL PASS, first run.** README's contract is "a schema change breaks the BUILD", because analytics is the one subsystem whose breakage is SILENT — rename a field and events keep flowing, the dashboard keeps drawing, and the number is quietly wrong for a month. ★ **A field value is RENDERED AT CONSTRUCTION**, so `prism_tel_secret` stores only `sec_redacted(s)` and the plaintext is never copied into the event at all — there is no later code path, however wrong, that could emit it. Asserted against the RENDERED string (what the sink sees) with a distinctive marker, not against a getter. ★ **Schema drift errors in BOTH directions**: an UNDECLARED key is rejected as firmly as a missing one, because a rename presents exactly as "new key arrives, old key stops" and tolerating the extra is how the dashboard goes wrong. Duplicate keys rejected (last-write-wins silently discards data); rejection proven NON-mutating. Float fields deliberately omitted — analytics floats should be scaled ints, since float formatting is platform-sensitive and NOVA's float compare is unsound |
| **MC.13** | ★ `obs/prism_crash.nova` — crash reports + replay log (#97 #128) — **`obs/` NOW 4/4** | ✅ **DONE** | 2026-09-03 | 2026-09-03 | **28 assertions ALL PASS, first run.** ⛔ **THE TRAP IN "ATTACH THE REPLAY LOG":** a replay log is a list of `PrismEvent`, and an `entry` event carries THE TEXT THE USER TYPED — so attaching it verbatim ships every password, card number and private message to a crash sink. The feature that makes crashes debuggable is, implemented naively, the largest exfiltration channel in the framework, and it would pass review because "attach the replay log" is literally what the roadmap asks for. Fixed structurally: a step is a two-field value (`cs_kind`, `cs_target`) with **no field that COULD hold a payload**. `prism_ev_describe` is deliberately NOT used — it interpolates `text='...'`/`route='...'` into its output. The KAT types a marker into an `entry`, attaches it, and asserts the marker appears NOWHERE in the rendered report while the reproduction path (`entry@form.password` → `press@btn.submit`) survives. Also honours the undo cursor: an undone step is excluded, because the report must describe what actually ran |
| **MC.11** | ★ `core/prism_journal.nova` — undo/redo/replay/audit — **`core/` NOW 7/7 COMPLETE** | ✅ **DONE** | 2026-09-03 | 2026-09-03 | **31 assertions ALL PASS, first run.** ★ **AUDIT AND UNDO WANT OPPOSITE THINGS, so they get SEPARATE STRUCTURES.** The obvious one-list implementation truncates on undo-then-act: undo three, do something new, and the undone entries are dropped so redo cannot resurrect them — correct for UNDO, catastrophic for AUDIT, because "what did this user actually do" is precisely what an audit must answer, and an attacker who can undo their way out of the record is the reason audit logs exist. So `jrn_log` is APPEND-ONLY (every event ever recorded, original origins, never truncated or reordered) while `jrn_time`+`jrn_pos` carry the undoable timeline. **The invariant asserted: `len(jrn_log)` NEVER decreases** — after undo-twice-then-record the timeline forks to 2 entries while the audit GROWS to 4. ★ **Replay is re-tagged via `prism_ev_replay`, so §15.7's `prism_ev_require_user` REJECTS the whole replay stream** — replaying history restores UI state WITHOUT re-granting the privilege the original action carried. The KAT proves the rejection is not vacuous by asserting the ORIGINAL events still pass the gate, and that the audit deliberately keeps `user` origin while the replay stream reads `replay`. Boundaries `err` rather than clamp, so a caller looping on undo terminates on a value it must handle |
| **MC.4** | `text/prism_select.nova` — selection + caret | ✅ **DONE** | 2026-09-02 | 2026-09-02 | **44 assertions ALL PASS** (Sonnet-built, re-run by me — agent numbers are never taken on report). **anchor+head, NOT lo/hi**, so a BACKWARDS selection survives continued extension instead of silently flipping. ★ The clamp-vs-reject split is made explicit and load-bearing: validated CONSTRUCTION rejects out-of-range like `prism_textmodel`, but interactive MOVEMENT (`extend_to/_by`, `move_to/_by`) CLAMPS — an editor that errors on "pressed End" is unusable, and conflating the two is how a model ends up either unusable or unsound. `select_range` reuses `prism_tm_slice`'s range check rather than re-deriving it |
| **MC.5** | `text/prism_find.nova` — in-app find | ✅ **DONE** | 2026-09-02 | 2026-09-02 | **30 assertions ALL PASS** (re-run by me). Match ranges are CODE POINTS via `code_points()`, never a byte `index_of`. Deliberately NON-overlapping (the scan jumps past each hit), proven against `"ababa"`/`"aba"` where a naive slide-by-1 over-reports. Empty needle REJECTED (an infinite match, not a no-op); needle longer than haystack returns zero matches rather than an error. ★ Case-insensitive is documented ASCII-only with a CORRECT invariant argument: `str_to_lower` is byte-wise C `tolower`, and **no ASCII byte 'A'-'Z' can occur inside a multi-byte UTF-8 sequence** (continuation bytes are >= 0x80), so it provably cannot corrupt UTF-8 or shift a reported position -- it only means accented letters do not case-fold. Limitation stated, not hidden |
| **MC.6** | `obs/prism_perf.nova` — frame/render timing | ✅ **DONE** | 2026-09-02 | 2026-09-02 | **42 assertions ALL PASS** (re-run by me). Functional/immutable like `prism_face`: every op returns a NEW `PrismPerf`, proven by asserting older snapshots stay frozen after later writes. `begin`/`end` misuse (double-begin, end-without-begin) rejected with a typed `err`. ★ `avg/min/max` REJECT at zero samples instead of answering 0 ms -- a 0 that is indistinguishable from "genuinely sub-millisecond" is a lie the caller cannot detect |
| **MC.7** | `obs/prism_flag.nova` — feature flags | ✅ **DONE** | 2026-09-02 | 2026-09-02 | **30 assertions ALL PASS** (re-run by me). WRAPS the existing `forge_flags` (actor-based) and `forge_ab_test` (Result-based) instead of reimplementing them — CLAUDE.md's "does this already exist?" rule, which has caught a duplicated `is_dir` and a redundant PRNG before. ★ Documented as a **HANDLE, not an immutable value** — the OPPOSITE property from the other three modules in this batch — and the KAT PROVES it: an older `PrismFlags` reference observes later writes, because it is the same live actor. Recording the difference matters more than making it uniform: a caller who assumes value semantics here would be wrong |
| **MC.1** | ★★ `core/prism_event.nova` — the event model | ✅ **DONE** | 2026-09-02 | 2026-09-02 | **50 assertions ALL PASS.** ★ **THE FINDING: 67 `ui/` components existed and NOT ONE could respond to anything** — no value represented "this was activated", so PRISM rendered but was not interactive. Closed 6-kind vocabulary, one per §9 primitive (A7: a 7th event kind would need a 7th primitive). **Origin is an ENUM, not a bool** for two independent reasons: a NOVA bool CANNOT be type-validated (`type_name()` never returns `"bool"`, `is_bool()` is self-inconsistent) and a security tag that cannot be validated is a hole; and REPLAY genuinely needs its own state — folded into "synthetic" it makes undo/redo indistinguishable from a self-attack, folded into "user" it lets a replay authorise a privileged action. **Invalid kind/payload combinations are UNREPRESENTABLE**: one constructor per kind, every payload accessor errors on the wrong kind, proven for ALL 30 kind×accessor pairs rather than a sample. §15.7's gate is executable (`Result`), rejecting synthetic AND replay. ⛔ **OPEN REDIRECT found while writing the KAT:** `//evil.example` satisfies "route starts with `/`" but is PROTOCOL-RELATIVE and navigates off-site — §15.1 claims injection is unrepresentable, so accepting it would have made the claim false. Now rejected. **Honest limitation recorded in-file:** NOVA has no module-private linkage, so nothing prevents app code calling a user-origin constructor; the guarantee is conventional until the compositor (§15.8) becomes the sole producer |
| **MC.2** | `core/prism_face.nova` — the face/view abstraction | ✅ **DONE** | 2026-09-02 | 2026-09-02 | **31 assertions ALL PASS.** Hook registration (show/hide/load/fail) with re-registration rejected. Drafted by a Sonnet agent that **hit its session limit before verifying anything**; I compiled and ran it rather than taking unverified agent output on trust |
| **MC.3** | ★ `text/prism_textmodel.nova` — document model | ✅ **DONE** | 2026-09-02 | 2026-09-02 | **41 assertions ALL PASS.** One type behind BOTH labels and rich text (a label is a document with one unmarked run), so nothing converts when text becomes editable. **POSITIONS ARE CODE POINTS** — bytes would corrupt every non-ASCII edit (NOVA strings are byte strings, so that is the DEFAULT failure), and cells belong to `prism_text.nova`, which already owns width/wrap/truncate; `prism_tm_width` DELEGATES rather than re-implementing. **Canonical form is an invariant** (empties dropped, equal-mark neighbours merged) because otherwise `mark(0,2)+mark(2,4)` and `mark(0,4)` are the same document with different structures, breaking structural equality AND §15.9 byte-reproducible rendering. Marks payload-free + stored as sorted names (MB.7's rule: a payload needs a field name, and the field→slot table is GLOBAL). ⛔ **TWO NOVA STRING FACTS MEASURED:** `str_chars` is **BYTE-wise** despite its name (`str_chars("héllo")` → SIX elements, é split into two invalid bytes) and `slice` is **STRING-ONLY** (it `strlen`s its argument) so slicing a LIST returns empty **silently**. Correct trio: `char_count` + `code_points` + `from_codepoint`. **Lesson that generalises: an ASCII-only test passes against a completely broken position API** |
| T0 | Prism status tracker created | ✅ DONE | 2026-08-14 | 2026-08-14 | This file; single entry point |
| T1 | Architecture + roadmap + matrix + spec skeleton | ✅ DONE | 2026-08-13 | 2026-08-14 | 4 docs; honest completeness ≈2% of a buildable spec |
| T2 | **Q8 — probe wasi-sdk / m7 blocker** | ✅ DONE | 2026-08-14 | 2026-08-14 | **Blocker MISDIAGNOSED.** clang 22.1.0 emits wasm32 fine; libc surface is only ~46 fns; but runtime needs a **SPLIT** (32,244 lines incl. sockets/epoll/pthreads/OpenSSL/dlopen). M0.3 rescoped 3-6wk → **6-10wk**, now the true critical path |
| T3 | **Q1 — research reactivity inference limits** | ✅ DONE | 2026-08-14 | 2026-08-14 | **Risk INVERTED.** Svelte 4 was *unsound* (syntactic, no call-graph); Compose tracks at *runtime* so it is not evidence. Real wall = **granularity collapse**. Added `face`-as-boundary + runtime keyed identity + mandatory diagnostics + **new milestone M1.7** |
| T4 | **Verify WASM/interop/bundle/text claims** | ✅ DONE | 2026-08-14 | 2026-08-14 | **3 PREMISES FALSIFIED (F1-F6).** Boundary is 4.5 ns; batched patch protocol already exists (Dioxus `sledgehammer`) and **lost** to Leptos; `fillText`→glyph-atlas is **impossible** (no per-glyph metrics). **Architecture revised to DOM-on-web / GPU-on-native** |
| T5 | Tier-2/3 feature expansion | ✅ DONE | 2026-08-14 | 2026-08-14 | 60 → **~132 features**. Found 9 features FREE from the process/channel model; found 2 large absences (data grid 3-5pm, rich text 3-4pm). Roadmap +10-14pm |
| T6 | `prism/` structure — all 132 features placed | ✅ DONE | 2026-08-14 | 2026-08-14 | 14 folders, ~70 modules, every feature has a home + feature number |
| T7 | Revised phase totals | ✅ DONE | 2026-08-14 | 2026-08-14 | 69pm sequential; ~6-7mo to gate, ~2.7yr browser v1, ~4-4.5yr everything |
| T8 | **Commit all work so far** | ✅ DONE | 2026-08-14 | 2026-08-14 | **`9084dcb2`** — 5 Prism docs + 5 clean taskboard files, 2,912 insertions. Build artifacts excluded |
| T8b | ⛔ **TASKBOARD SOURCE CORRUPTION** | ⛔ BLOCKED | 2026-08-14 | — | `app.nova` `db.nova` `routes_api.nova` `routes_web.nova` all overwritten with **identical 402,441-line LLVM IR dumps**. Cause: a malformed `nova build -o` on 2026-08-08 (the 3 MB file literally named `-o` is still in `nova_taskboard/`). **`app.nova`+`db.nova` recoverable from git at pre-ORM-upgrade state (64/121 lines). `routes_api.nova`+`routes_web.nova` were NEVER committed → NO RECOVERY.** Awaiting owner decision |
| T9 | **Step 3 — vertical-slice spec at buildable depth** | 🔄 IN PROGRESS | 2026-08-15 | — | grammar + lowering · ~~DOM emission map for all 22 primitives~~ **✅ DONE 2026-08-15 → spec §17A** · update path · closure→WASM table · event loop · 3 widgets fully specified. **~80 pp. Docs only, no permission needed** |
| T9a | ★ **§17A — the HTML emission map + the honest sink argument** | ✅ **DONE** | 2026-08-15 | 2026-08-15 | Written ahead of MA.5, because **MA.5 is the moment §15.1's "no sink" claim stops being free.** Native/terminal backends genuinely have no markup; the HTML renderer **creates a sink**, and the spec said nothing about it. Restated honestly: the guarantee doesn't collapse, it changes form — *exactly one* function may emit a `<`, and the positions where data reaches output are **finite and enumerable because the vocabulary is closed** (the real payoff of axiom A7). Enumerated: of 5 output-byte sources only **2 are data** (text content, attribute values); element names and attribute names are enum/literal-driven and structurally not attacker-controllable. 8 binding rules incl. **no `on*` handlers ever**, always-quoted attrs, `rel="noopener noreferrer"` on external links (tabnabbing is orthogonal to URL allowlisting), no `script`/`style`/`iframe` element in the map at all. Full 22-row element+ARIA map. Plus a falsifier section: what would prove §17A wrong |
| T9b | **Dict iteration determinism probed (MA.5 de-risk)** | ✅ **DONE** | 2026-08-15 | 2026-08-15 | MA.5's exit criterion is "byte-identical HTML across runs", and a node's `attrs` is a `dict` — so dict order **is** emission order. Probed rather than assumed: NOVA dicts iterate in **strict insertion order**, identical across separate runs, **stable across internal resize** (verified at 20 keys past initial capacity), and **overwriting an existing key keeps its position** rather than moving it to the end. ⇒ byte-identity needs **no key sorting** in the renderer. Creates one obligation, now recorded in spec §15.9: a constructor that builds `attrs` conditionally in a varying key order would silently break attestation while every test still passed |
| **MA.1** | `prism/` skeleton + relocate v0.1 | ✅ **DONE** | 2026-08-15 | 2026-08-15 | **`prism/` EXISTS.** 14 folders + `backend/{dom,gpu,ansi}`, `nova.toml`, `README.md`, own `.gitignore`. Old `nova-compiler/test_programs/prism.nova` **moved** to `prism/backend/ansi/prism_ansi.nova` (140→155 lines), all 17 fns re-prefixed `prism_ansi_*`. **Reference audit found MORE than briefed:** `demo_prism_test.nova` **plus `demo_frameworks_v2_test.nova` and `demo_full_stack_test.nova`**, all three in `_run_final_regression.ps1`'s `$core_tests`. All updated; **all three re-verified passing identically.** Module resolution solved by extending `_proc_util.ps1`'s existing forge→`lib/` sync with a `prism/` block (recursive source → flat dest); `nova_ci.ps1` untouched |
| **MA.2** | `core/prism_node.nova` — node-tree type | ✅ **DONE** | 2026-08-15 | 2026-08-15 | 338 lines + 172-line KAT. **Design: struct tree + enum tag, not an all-enum ADT** — a per-widget-payload ADT would bake MA.3's shapes into the foundation and force every tree-walker to match 22 variants to reach `children`. Enum kept for the tag so `prism_node_kind_name` is exhaustive with **no wildcard** → adding primitive #23 without updating it is a compile error (axiom A7). Depth/count **cached at construction** → O(1) bounds checks instead of O(n²) re-walking. **KAT: 6/6 pass**, incl. exact boundaries (depth 256 ok / 257 rejected; count 100,000 ok / 100,001 rejected) and RTTI (`type_name`→`PrismNode`, all 6 fields via `field_names`, `field_get` round-trip). `gen3_test.exe check` = `ok` on both files |
| **MA.2b** | ★ **Language limitation found + verified** | ✅ **DONE** | 2026-08-15 | 2026-08-15 | **Enum variant constructors are FILE-LOCAL.** Cross-module: bare `Variant()` → `E1002 unknown identifier`; qualified `mod.Variant()` → `E1000 no exported function`. **I re-verified independently with my own 2-file probe — confirmed all 3 cases.** Would have blocked MA.3 entirely (every widget file must produce a `PrismNodeKind`). Worked around with 22 `prism_kind_*()` wrappers in the declaring file. Saved to memory as a permanent gotcha — **it blocks ANY multi-module ADT design**, not just Prism |
| **MA.2c** | Doc count errors corrected | ✅ **DONE** | 2026-08-15 | 2026-08-15 | Agent flagged "26 primitives" vs the spec's actual **22**; I also found "44 keywords" is actually **39**. Both corrected in the spec, with the unspecified **Meta** group (`portal`/`focus_scope`/`clip`/`transform`/`animate`) explicitly marked **deferred** to M3.3 + the backends rather than invented |
| **MA.3** | `widget/` — all 22 primitives as functions | ✅ **DONE** | 2026-08-15 | 2026-08-15 | **~730 lines across 4 modules + 4 KATs, all green (re-run by me, not taken on report).** `prism_arrange` (§7) · `prism_content` (§8) · `prism_interact` (§9) · `prism_structure` (§10). **Not thin wrappers:** 5 new closed enums (`PrismMeshTrack`, `PrismIcon`, `PrismEntryKind`, `PrismLinkTarget`, + structs `PrismPickOption`/`PrismTabPanel`) so an invalid value is a COMPILE error where possible and a typed `err` otherwise. `each`/`grid` take a REQUIRED identity selector and reject duplicate keys. `_kat_prism_widget_all` links **all four modules in one program** — no symbol collision — and composes a 6-level app screen asserting exact `depth=6, count=23` |
| **MA.3b** | ⛔→✅ ★ **SEGFAULT: §16 "never a crash" was FALSE** | ✅ **DONE** | 2026-08-15 | 2026-08-15 | **I found it in review, not the agents.** `prism_stack([1, 2, 3])` → **exit -1073741819 (0xC0000005 ACCESS VIOLATION)**. Widget ctors take `children: list` untyped (correctly — mirrors `PrismNode.children`), and `prism_node_new` read `c.depth` on each child: a **wild pointer dereference** on any non-node element. Latent since MA.2; MA.3 made it reachable from ordinary calling code. **Fixed at the single chokepoint** — `type_name(c) != "PrismNode"` guard placed FIRST in the loop, before any field read, naming the child index + actual type; one string compare per child, still O(children), closes it for all 22 primitives at once. **4 more instances of the identical class** found and closed: `prism_each` read `rendered.kind`, `prism_tabs` read `p.content`, `prism_pick` read `o.value`, and `key_fn`'s return was assumed `string`. Lesson: an untyped `list` field is a memory-safety boundary, and every read through one needs an RTTI guard |
| **MA.3c** | ★ **3 URL holes found by probing the ACCEPTED set** | ✅ **DONE** | 2026-08-15 | 2026-08-15 | The KAT tested only the obvious rejections (`javascript:`/`data:`/`vbscript:` — all correctly denied). **Probing what gets ADMITTED found 3 real defects:** (1) `/\evil.com` accepted — browsers normalize `\`→`/` in the authority, so this is the exact open-redirect the `//` check exists to stop; (2) CRLF stored verbatim in `href` → **HTTP response splitting** once MA.5 or a `Location:` header emits it; (3) `https://example.com@evil.com/` accepted — browser navigates to **evil.com**, and a scheme allowlist structurally cannot see the host. All 3 closed; **22-case independent re-verify by me** incl. 4 vectors the agent never tried (backslash-before-userinfo, tab-in-authority, DEL byte, and a deep-path backslash that must STAY accepted). Rules promoted to **NORMATIVE spec §15.1.1**. `/redirect?next=javascript:...` deliberately still accepted — an app's own query param is not `link`'s business |
| **MA.3d** | ★ 2 more NOVA limitations found + verified | ✅ **DONE** | 2026-08-15 | 2026-08-15 | Both **re-probed by me** before recording. (1) **Struct positional ctors are file-local too**, not just enum variants — `mod.Struct(...)` = E1000, bare = E1002. Widens the known limitation from "blocks multi-module ADTs" to "blocks multi-module **types**" (config records, DTOs, protocol tags). (2) ★ **Default parameter values die at the module boundary** — `fn f(a, b = 5)` called `mod.f(10)` = **E1003 expects 2 arguments, got 1**; works same-file, breaks for every real consumer, so an API's shape silently differs by caller location. NOVA also has **no arity overloading** (E1012). Both written into `NOVA_LANGUAGE_FEATURES.md` §7 traps 11–12 and memory |
| **MA.4** | `style/` — typed `look` + `palette` values | 🔄 **IN PROGRESS** | 2026-08-15 | — | Spec §11: "No cascade. No specificity. No global namespace. A `look` is a **typed value**." **Design decision (mine, before delegating): one typed setter function PER property, not a `set(look, name, value)` pair.** ~30 setters (`prism_inset`, `prism_fill`, `prism_round`, …) makes an invalid property name **unrepresentable** — there is no string to misspell — and makes a wrong value type a compile error rather than a runtime `err`. That is strictly stronger than the roadmap's exit criterion ("an invalid property is caught at the library boundary") and it is what §11 means by "there is no way to write a style that silently does nothing", CSS's single most common failure mode. Split with a fixed API contract so both halves run in parallel with no circular import: **A** = `style/prism_color.nova` + `style/prism_palette.nova` (Color, hex validation, 9 presets × light/dark = 18); **B** = `style/prism_look.nova` (property setters, merge = later-wins, `when` state variants, resolve-against-palette taking a plain slot dict so it never imports palette) |
| **MA.4a** | `style/prism_color.nova` + `prism_palette.nova` | ✅ **DONE** | 2026-08-15 | 2026-08-15 | 184 + 384 lines + a 227-line KAT, **ALL PASS**. Hex parse for `#rgb`/`#rrggbb`/`#rrggbbaa` with shorthand expansion by digit duplication, canonical round-trip, 7 rejection cases incl. spec §11's own `#gg0000`; rgba channel bounds asserted at the EXACT boundary (0 and 255 accepted, -1 and 256 rejected). **9 presets × light/dark = 18 palettes, every one asserted ≥ 4.5:1 WCAG AA for ink-on-ground with the ratio COMPUTED, not assumed** (actual range **12.88:1 – 21.0:1**; `mono` hits the 21.0 theoretical max). Contrast math **reuses `std/color/contrast.nova`** rather than re-deriving WCAG — CLAUDE.md's "does this already exist?" rule. `classic/light` reproduces spec §11's `palette day` verbatim (`#ffffff`/`#1a1a1a`/`#4f46e5`), asserted. **Agent died on session limit mid-file; I finished, debugged and verified it myself** |
| **MA.4x** | ⛔ ★★ **COMPILER BUG: module-level `let` list/dict is EMPTY when imported** | ✅ FOUND+RECORDED | 2026-08-15 | 2026-08-15 | **Silent — no error, just an empty collection.** Probed 3 ways: the *same* declaration gives `len`=**3** in a main file and **0** in an imported module, read even from INSIDE the declaring module. Scalars (`let N = 42`) are unaffected — it is specifically **collection literals** whose initializer never runs. **Writes through it are silently DROPPED**: `BX[0] = 7` leaves `len`=0 and reads back 0. **Live bugs in shipped code:** `forge.set_max_body()` is a **silent no-op** (always reads 0 → always the 8 MiB default; an app *hardening* its limit silently keeps 8 MiB); `std/os/tempfile`'s uniqueness counter never increments; `std/util/coro.nova` has 6 more boxes. **⚠️ CORRECTION (measured 2026-08-15):** I first wrote that the tempfile defect meant "two temp files in the same millisecond **collide**." **That was wrong** — inferred from reading the code rather than measured. `tf_create` has a `while file_exists(path)` retry loop that preserves correctness; the real defect is a **busy-spin** — with the counter stuck at 1 the suffix is identical until `time_ms()` ticks, capping creation at ~1/ms. **Measured: 200 `tf_create` = 201 ms before, 39 ms after (5.2x).** Recorded because the lesson generalizes: *measure the consequence, don't infer it.* **How it hid:** `prism_palette_names()` returned empty → the KAT's `for nm in names` ran **zero times**, so 18 contrast assertions "passed" without executing. *A loop over a wrongly-empty collection is a green test that proves nothing.* Prism worked around it (constants → functions returning fresh literals); **the root fix is RED compiler work and needs the owner's go-ahead** |
| **MA.4y** | NOVA syntax limits found while writing MA.4 | ✅ **DONE** | 2026-08-15 | 2026-08-15 | (1) **A qualified type annotation `mod.Type` is a PARSE ERROR** — but the **bare imported type name works** (`c: PrismColor` after `import prism_color`). So **types cross the module boundary by bare name while their constructors do not cross at all** — a sharp asymmetry, and the cause of all 39 parse errors in the half-written palette file. (2) **No multi-line call arguments** — splitting a call's args across lines is `E0001 unexpected NEWLINE in expression`. (3) Postfix `?` error propagation **does** work cross-module |
| **MA.4b** | `style/prism_look.nova` — the `look` value | ✅ **DONE** | 2026-08-15 | 2026-08-15 | 500 lines + a 200-line KAT, **ALL PASS**. **Agent B died on the session limit before writing a line; I wrote the whole module and its KAT myself.** All 30 §11 properties across the 7 groups, **one typed setter per property** — so an unknown property is an *unknown identifier* (compile error) and there is **no string to misspell**. That is stronger than the roadmap's exit criterion and is what §11's "there is no way to write a style that silently does nothing" actually requires. `PrismValue` is one closed 9-variant enum with an **exhaustive, wildcard-free** renderer. **Enum-valued properties get named constructors instead of 8 more NOVA enums** — the caller still cannot express an invalid value (there is no public raw-string constructor), and each setter validates the value's *group*, so `prism_cursor_grab()` handed to `prism_align_of` is rejected by name rather than silently stored. Merge is **later-wins, associative, and mutates neither input** — all three asserted; a mutating merge would let one caller's `.tight` silently restyle every other user of `card`, the action-at-a-distance a cascade-free design exists to prevent. Merge key ORDER is asserted too (spec §15.9) since MA.5's byte-identity depends on it. 12 rejection cases + 7 must-accept boundary cases |
| **MA.4c** | Integration KAT — the contract nobody had executed | ✅ **DONE** | 2026-08-15 | 2026-08-15 | The two halves were written against each other's **contract**, never each other's **code**. Concretely: `prism_look_resolve` accepts a slot dict of *either* hex strings *or* `PrismColor` structs, and KAT B only exercised the **string** path — while production (`prism_palette_slots()`) returns **PrismColor structs**, the path no test had ever run. **A contract agreed on paper and never executed is not a verified contract.** `_kat_prism_style_all.nova` links **all 8 modules in one program** (no symbol collision in NOVA's flat LLVM space), resolves against a real palette asserting the flattened hex `==` `prism_color_to_hex` of the same slot, carries a resolved look on a real MA.3 widget tree, and flattens against **all 18 palettes** — asserting the preset count **before** the loop, since a loop over a wrongly-empty list is exactly how the MA.4a compiler bug hid. **Full suite: 7/7 KATs green, 0 FAIL** |
| **MA.5** | `render/prism_render_html.nova` — **Prism's first sink** | ✅ **DONE** | 2026-08-15 | 2026-08-15 | 300 lines + a 200-line KAT that is **a security test first and a rendering test second**. Implements spec §17A's 22-row element map and all 8 binding rules. **Two escapers, not one** — text (`& < >`) and attribute (`& < > " '`) contexts have different dangerous characters, and using one for both is the classic mistake that leaves `"` live inside an attribute. `&` is replaced FIRST or `<`→`&lt;`→`&amp;lt;`. **XSS asserted un-expressible at every position data can reach** — label, press, link, entry value (attribute ctx), textarea (text ctx), option label, tooltip, page title; one unescaped position is total failure so all 8 are asserted. **Byte-identity proven 3 ways**: repeated renders, and a *freshly rebuilt structurally-identical tree* rendering identically (proves output depends only on the tree's value, never allocation order). `rel="noopener noreferrer"` on external links only. `each` emits **no wrapper** (would break the parent's layout contract). **8/8 Prism KATs green; 3 demo tests unchanged** |
| **MA.5x** | ⛔ ★★ **Exhaustiveness does NOT cross module boundaries** | ✅ **DONE** | 2026-08-15 | 2026-08-15 | **Falsified my own design claim within minutes of writing it.** The renderer originally dispatched via `match prism_node_kind(n)` over `PrismNodeKind` with no wildcard, documented as "adding primitive #23 is a compile error". **Probed it by deleting the `Tabs()` arm — and it compiled clean.** Precise behaviour: a match in the **same file as the enum IS** checked (`error[E1009]: non-exhaustive match … missing Tabs`), the **same match cross-module is NOT** — it compiles silently and the un-matched variant returns **`""`** at runtime. So in Prism's one security-critical file the enum match bought **nothing** while *looking* like it carried a guarantee — primitive #23 would have rendered as **silent nothingness**. Restructured: dispatch on `prism_node_kind_str()`, whose own match lives beside the enum and IS exhaustiveness-checked, plus an explicit `_ =>` arm returning a **loud typed error**. The guarantee now spans two files because exhaustiveness will not span one boundary. ⇒ **MA.2's exhaustiveness claim is TRUE (same-file); any cross-module "closed vocabulary is compiler-enforced" claim is FALSE** |
| **MA.5y** | KAT assertion was wrong, renderer was right | ✅ **DONE** | 2026-08-15 | 2026-08-15 | Two red assertions on the quote-breakout probe. Output was `value="&quot; onmouseover=&quot;alert(1)"` — the injected quote **became an entity**, so the attribute never closes and ` onmouseover=` is **inert text inside one properly-quoted value**. I had asserted that bare substring must be absent, which is **the wrong property** and fails on correct output. Corrected to assert no **attribute-shaped** `onmouseover="` (live quote after `=`) exists, plus a positive assertion that the quote was neutralized. **Fixed the test, not the code** — recorded here because "make the assertion pass" would have been the wrong instinct |
| **MA.6** | `backend/ansi/prism_render_ansi.nova` — the 2nd backend | ✅ **DONE** | 2026-08-15 | 2026-08-15 | 270 lines + a 150-line KAT. **The real job of this milestone is to FALSIFY MA.2's design**, not to do TUIs: until a second backend exists, "backend-agnostic node tree" is an untested claim, because a single-backend abstraction is indistinguishable from no abstraction — every leaky assumption about the one backend stays invisible. **Result: the node tree held.** All 22 primitives map from the attrs already present; **zero new fields needed on `PrismNode`**. The two genuinely medium-bound things (`draw`'s pixel callback, `art`'s raster) degrade to a labelled placeholder, which is honest. **Exit criterion met:** ONE tree rendered through BOTH backends in one KAT, asserting each produces its own medium and that neither mutates the tree. Reuses the v0.1 `prism_ansi_table`/`progress_bar`/`bold` helpers MA.1 relocated — a `range` on a terminal genuinely IS a progress bar |
| **MA.6x** | ★ **Terminal security: ESC is this backend's `<`** | ✅ **DONE** | 2026-08-15 | 2026-08-15 | A terminal is **not a passive display** — ANSI sequences are *commands*: move the cursor, repaint the screen, set the window title, switch buffers, and on several terminals trigger clipboard writes or **reply-injection** (the `CSI…n` device-status family, which makes the terminal *type text back on the app's stdin*). So §17A's argument restated for this medium: **`\x1b` in user data is this backend's `<`.** Every data path goes through `prism_ansi_sanitize`, which **strips** ESC + all C0 controls + DEL (keeping TAB). Deliberately a **strip, not an escape** — there is no "show this literally" encoding for a control byte the way `&lt;` exists for `<`, so the only safe rendering is not to emit it. KAT fires a full `ESC[2J` + `ESC]0;pwned` + BEL payload at **every** data position. Also: **a `password` entry is never echoed** (terminals scroll back, and scrollback gets logged) — with a control assertion that a *text* entry DOES show its value, so the mask assertion is not vacuous |
| **MA.6y** | ⛔ **Private `_`-prefixed helpers COLLIDE across modules** | ✅ **DONE** | 2026-08-15 | 2026-08-15 | The link failed: `error: invalid redefinition of function '_render_gap'` — defined in both `prism_render_html.nova` and `prism_render_ansi.nova`. **NOVA's one flat LLVM symbol space does not exempt a leading underscore**; there is no module-private linkage. The known rule was "prefix your *public* fns"; the true rule is **prefix EVERY top-level fn, private helpers included**. Fixed by renaming all 20 ANSI helpers to `_ansi_*`. This will bite any two modules that independently pick an obvious helper name (`_esc`, `_indent`, `_fmt`) |
| **MA.7** | `dev/prism_catalog.nova` — generated catalog | ✅ **DONE** | 2026-08-15 | 2026-08-15 | 150 lines + a 120-line KAT. **Storybook's real cost is the story FILES** — one hand-written module per component, kept in sync by discipline alone, which rots in every codebase that ships them. Prism needs none, for a structural reason rather than a clever one: **the vocabulary is closed (A7)**, so `prism_node_kind_all()` enumerates it and the catalog walks the vocabulary itself. No per-component file to write ⇒ none to rot. **Every example is built by the primitive's REAL constructor**, so the catalog cannot display a component the widget layer would refuse to build. It renders through the ordinary backends with **no private rendering path**, so it cannot drift from what apps get — and doubles as an end-to-end exercise of all 22 primitives. **The coverage assertion IS the exit criterion, mechanized:** adding primitive #23 without an example turns the KAT red **by name** instead of yielding a page that quietly omits it. Added `prism_node_kind_all()` to `prism_node.nova` with its residual drift risk **stated in the file**, not hidden |
| **MA.8** | KATs wired into the CI gate | ✅ **DONE** | 2026-08-15 | 2026-08-15 | `_prism_kat_gate.ps1` + `nova_ci.ps1` stage **`[CI 2m/3]`**. **DISCOVERS `prism/kat/_kat_*.nova` rather than taking a hard-coded list** — a hard-coded list is a second place to remember whose failure mode is *silent*: the new KAT never runs and CI still reports all-green. Fails on **either** a non-zero exit **or** a `FAIL` line in stdout, since a KAT could in principle mis-count its own failures. **Verified it can actually fail** by deliberately sabotaging a KAT: exit 1, the KAT named, and the remaining 9 still run so every failure is reported rather than just the first. Kill-on-timeout on every binary. **`$LASTEXITCODE` checked IMMEDIATELY after its own invocation** — the exact discipline whose absence made the Tier-1.5 gate unfailable (`a2e7aaa1`); ran an adjacency audit over all 15 stages and confirmed none has drifted. **10/10 Prism KATs green through the gate** |
| **MA.5b** | ★ **Forge bridge — MA.5's last exit clause, END-TO-END** | ✅ **DONE** | 2026-08-15 | 2026-08-15 | **I had marked MA.5 DONE while one clause of its own exit criterion — "wired into a Forge route" — was not met. Closing it here rather than leaving it silently unmet.** `app/prism_forge.nova` (78 lines) + a 105-line KAT that is **end-to-end, not mocked**: it starts a real Forge server, fetches over a real socket, and asserts on the bytes off the wire — `Prism constructors → node tree → HTML renderer → Forge response → HTTP → client`. A mock at any layer could hide exactly the integration bug this milestone exists to rule out. **Deliberately a separate module, not a function in the renderer**: `prism_render_html.nova` is the security boundary, and importing a web framework into it would make the sink's dependency surface the *framework's* dependency surface, weakening the §17A claim that exactly one small function can emit a `<`. **★ The error path is the real content:** a page can legitimately fail to build (`Result`), but a handler must return a response — and the tempting shortcut of rendering the error text into the page is a genuine security bug, because error strings quote the offending INPUT back, handing an attacker a reflected-content primitive on precisely the page where escaping is most often forgotten. So the body is a **fixed 500 with zero detail**; diagnostics go to an explicit logger. Asserted with a sentinel string that must appear in the log and never on the wire. **⇒ NOVA's full-stack claim is real today for the server-rendered case: typed UI values served from an ordinary route — no template language, no npm, no build step, no WASM, no compiler change** |
| **MA.8b** | ⛔ **The gate itself had a false-positive** | ✅ **DONE** | 2026-08-15 | 2026-08-15 | Caught by the gate's own first real use: `_kat_prism_forge` exits 0 with zero failures and was still reported **FAIL**. Cause — **PowerShell's `-match` is case-INSENSITIVE**, so the scan for a `FAIL` token matched the word *"failed"* inside the KAT's own prose (`== 2. a failed build leaks NOTHING ==`). **A gate that cries wolf ends up ignored, which is the same end state as a gate that cannot fail** (`a2e7aaa1`) — opposite defect, identical consequence. Fixed to `-cmatch '(?m)^\s*FAIL\b'`: case-sensitive and line-anchored to the KATs' actual convention. **Re-ran the deliberate-sabotage self-test afterwards** to confirm the fix did not disarm it — 11/11 pass clean, and a sabotaged KAT still gives exit 1 and is named |
| **MB.1** | ★ **PHASE B — `ui/` composition layer, first 2 components** | ✅ **DONE** | 2026-08-15 | 2026-08-15 | **1,559 lines** — `ui/prism_ui_form.nova` (590) + `ui/prism_ui_table.nova` (411) + 2 KATs (558). **13/13 Prism KATs green** (re-run by me, not taken on report). **No new `PrismNodeKind` invented** — both compose only the existing 22 primitives, so axiom A7 holds. **Form:** 7 typed field constructors (one per kind, so an invalid field kind is *unrepresentable*), validation rules as a closed 3-variant enum with exhaustive 3x7 kind/rule compatibility checking, duplicate field names rejected, and a `<script>`-bearing label proven to render as escaped text through `prism_render_html`. **Table:** sorting is a closed enum not a string; an unknown sort key is **rejected** rather than silently ignored (the exact failure class §11 rails against for styles); descending is NOT "ascending then reverse" (which would wrongly reverse tied groups) but a run-wise walk giving Python `reverse=True` semantics — **stability and non-mutation both asserted with a deliberate tie** |
| **MB.67** | `ui/prism_ui_toast.nova` — toast/snackbar notifications | ✅ **DONE** | 2026-08-20 | 2026-08-20 | **84/84 assertions, 86/86 Prism KATs green.** 5 fns in 154 lines + 187-line KAT. `prism_tst_toast` (band[glyph, label]), `prism_tst_toast_action` (band[glyph, label, press] — delegates validation to `prism_tst_toast`), `prism_tst_toast_stack` (vertical stack with type_name check), `prism_tst_toast_timed` (toast + `tst_duration` attr via `dict_merge` re-tag idiom), `prism_tst_toast_progress` (stack[label, "[====------] 40%"] — 10-char bar via `str_repeat`). Icon mapping follows `prism_ui_alert`'s existing precedent: error→Close(), not an invented AlertTriangle. Toast severity is a validated string (not a new enum) — `PRISM_TST_TYPES` list + `in`/`not in`, matching `prism_fab_positioned`'s corner pattern. 15 rejection cases |
| **MB.66** | `ui/prism_ui_mention.nova` — mentions/autocomplete | ✅ **DONE** | 2026-08-18 | 2026-08-18 | **112/112 assertions, 86/86 Prism KATs green.** 5 fns in 123 lines + 263-line KAT. `prism_mnt_input`, `prism_mnt_suggestions` (case-sensitive substring filter, explicit "no matches" label), `prism_mnt_mention_box` (open/closed — suggestions always validated regardless of `open`), `prism_mnt_highlight` (@-mention marking via split+filter+map), `prism_mnt_trigger_hint`. 14 rejection cases |
| **MB.65** | `ui/prism_ui_fab.nova` — floating action button / speed dial | ✅ **DONE** | 2026-08-18 | 2026-08-18 | **86/86 Prism KATs green.** 5 fns in 135 lines + 256-line KAT. `prism_fab_button`, `prism_fab_group` (zipped parallel lists via `prism_ui_collect`), `prism_fab_speed_dial` (open/closed shape), `prism_fab_positioned` (corner-pinned, vertical axis via stack ordering), `prism_fab_badge_button` (capped at "99+", zero→no badge child). Corner set validated by list membership |
| **MB.64** | `ui/prism_ui_splitter.nova` — splitter/resizable panes | ✅ **DONE** | 2026-08-18 | 2026-08-18 | **85/85 Prism KATs green.** 5 fns in 125 lines + 255-line KAT. `prism_spl_splitter` (band[pane, handle, pane]), `prism_spl_vertical`, `prism_spl_three_way`, `prism_spl_collapsed` (side-pinned indicator), `prism_spl_nested` |
| **MB.63** | `ui/prism_ui_switch.nova` — switch/checkbox/radio | ✅ **DONE** | 2026-08-18 | 2026-08-18 | **84/84 Prism KATs green.** 5 fns in 173 lines + 230-line KAT. `prism_swt_switch` (press[band[indicator, label]]), `prism_swt_checkbox`, `prism_swt_radio_group` (only one marked), `prism_swt_toggle` (generic on/off with custom labels), `prism_swt_switch_group`. Shared `_prism_swt_check_labels` validation |
| **MB.62** | ★ `ui/prism_ui_slider.nova` — slider/range | ✅ **DONE** | 2026-08-18 | 2026-08-18 | **193 assertions in a 210-line KAT** — ~1 assertion/line vs the old ~2.5 lines/assertion. 5 fns in 158 lines. `prism_sld_slider`, `prism_sld_range` (dual-thumb, `lo == hi` overlap falls out of ONE ternary formula rather than a separate code path), `prism_sld_stepped` (tick marks via a comprehension-over-range-with-filter), `prism_sld_vertical` (lambda closing over 2 outer vars + `prism_ui_collect`), `prism_sld_percent` (`"{pct:03d}%"`). **Highest high-level-feature density in the repo:** 39 interpolations, 5 ternaries, 3 comprehensions, 2 lambdas, 1 `collect`, 10 membership ops, and the **first-ever use of the `str_repeat` builtin in `prism/`** (a real registered `nova_rt_str_repeat` that had sat with zero callers) |
| **MB.61** | `ui/prism_ui_tabs.nova` — tabs (was genuinely missing from all 60 modules) | ✅ **DONE** | 2026-08-18 | 2026-08-18 | **114 lines** — less than half the prior ~244-line average. 5 fns + 54-assertion data-driven KAT (212 lines). `prism_tbs_tab_bar` (active tab marked via ternary), `prism_tbs_tabs`, `prism_tbs_closable`, `prism_tbs_vertical`, `prism_tbs_card_tabs`. 17 interpolations, 2 ternaries, 4 `for i, v in` loops, **zero banned low-level patterns** — verified by independent grep + KAT re-run, not taken on report |
| **MB.60** | ★ `ui/prism_ui_pager.nova` — pagination, **rewritten as the high-level reference** | ✅ **DONE** | 2026-08-18 | 2026-08-18 | **First component written under the high-level law.** Initially landed at 244+318 lines with **23 banned low-level patterns**; rewritten to 147+253 with **zero**. `while p <= hi: push; p += 1` → `list_range_inclusive` + spread; clamp if-ladders → `max`/`min`; multi-line if/else returning one `Result` → ternary chains; every `" + str(x)` → interpolation. KAT made data-driven: ~60 hand-copied assertion blocks → row-walked tables, rejection tally computed from the data. **118/118 assertions pass** |
| **MB.59** | `ui/prism_ui_activity.nova` — activity feed | ✅ **DONE** | 2026-08-18 | 2026-08-18 | **79/79 Prism KATs green.** 5 fns + KAT (54 assertions). `PrismActivityEvent{ac_time, ac_title, ac_detail}` + ctor/accessors, `prism_ac_event_node`, `prism_ac_feed`, `prism_ac_compact`, `prism_ac_grouped`, `prism_ac_latest`. **Renamed mid-flight:** the brief said `prism_ui_timeline`/`prism_tl_*`, but that file already exists as MB.15 and `prism_ui_data.nova` already claims the `tl_` prefix — overwriting would have destroyed committed gated work, so it shipped as `activity`/`ac_` with the collision documented in its header |
| **MB.58** | `ui/prism_ui_profile.nova` — profile/user info card | ✅ **DONE** | 2026-08-18 | 2026-08-18 | **78/78 Prism KATs green.** 5 fns + KAT (65 assertions). `prism_pf_header` (single-letter avatar + gap(8) + stack[name, role]), `prism_pf_stats` (via `prism_ui_collect` + lambda over zipped parallel lists), `prism_pf_bio`, `prism_pf_card`, `prism_pf_contact`. Deliberately does NOT reuse the two existing avatar families (both build richer multi-letter/image-backed values) — the local one-char `_prism_pf_initial` helper is documented as the honest minimal fit |
| **MB.57** | `ui/prism_ui_search.nova` — search/filter bar | ✅ **DONE** | 2026-08-18 | 2026-08-18 | **77/77 Prism KATs green.** 5 fns + KAT (64 assertions). `prism_sr_search_bar` (entry + button), `prism_sr_filter_bar` (search + filter chips), `prism_sr_search_results` (query + count + items), `prism_sr_instant_search` (search bar + live results panel), `prism_sr_advanced` (search bar + expandable filters section) |
| **MB.56** | `ui/prism_ui_card.nova` — card/panel | ✅ **DONE** | 2026-08-18 | 2026-08-18 | **76/76 Prism KATs green.** 5 fns + KAT (125 assertions). `prism_cd2_card` (stack[header, body, footer]), `prism_cd2_media_card` (art + body), `prism_cd2_stat_card` (value + label + optional trend), `prism_cd2_action_card` (card + action buttons), `prism_cd2_card_group` (band of cards) |
| **MB.55** | `ui/prism_ui_copy.nova` — copy-to-clipboard | ✅ **DONE** | 2026-08-18 | 2026-08-18 | **75/75 Prism KATs green.** 5 fns + KAT (74 assertions). `prism_cp_copy_button` (text + button), `prism_cp_code_block` (labeled code with copy), `prism_cp_inline_copy` (compact inline), `prism_cp_share_link` (URL copy + label), `prism_cp_multi_copy` (list of copyable items) |
| **MB.54** | `ui/prism_ui_error.nova` — error boundary/display | ✅ **DONE** | 2026-08-18 | 2026-08-18 | **74/74 Prism KATs green.** 5 fns + KAT (53 assertions). `prism_er_error` (icon + message), `prism_er_detailed` (error + stacktrace), `prism_er_boundary` (try content, show fallback on error), `prism_er_retry` (error + retry button), `prism_er_error_list` (multiple errors stacked) |
| **MB.53** | `ui/prism_ui_scroll.nova` — scroll area/virtual | ✅ **DONE** | 2026-08-18 | 2026-08-18 | **73/73 Prism KATs green.** 5 fns + KAT (72 assertions). `prism_sc_scroll_area` (content + scrollbar indicator), `prism_sc_virtual_list` (window of visible items from total), `prism_sc_infinite` (items + load-more trigger), `prism_sc_sticky_header` (header + scrollable body), `prism_sc_scroll_to_top` (content + back-to-top button) |
| **MB.52** | `ui/prism_ui_header.nova` — page/section header | ✅ **DONE** | 2026-08-18 | 2026-08-18 | **72/72 Prism KATs green.** 5 fns + KAT (79 assertions). `prism_hd_header` (title + optional subtitle), `prism_hd_page_header` (breadcrumb + title + actions), `prism_hd_section_header` (title + optional right content), `prism_hd_hero` (large title + description + CTA), `prism_hd_nav_header` (logo + nav items + actions band) |
| **MB.51** | `ui/prism_ui_tag.nova` — tag/label display | ✅ **DONE** | 2026-08-18 | 2026-08-18 | **71/71 Prism KATs green.** 4 fns + KAT (43 assertions). `prism_tg_tag` (bracketed label), `prism_tg_colored` (tag + color attr), `prism_tg_closable` (tag + close button), `prism_tg_tag_group` (flow of tags with gap) |
| **MB.50** | 🎉 `ui/prism_ui_countdown.nova` — countdown/timer display | ✅ **DONE** | 2026-08-18 | 2026-08-18 | **70/70 Prism KATs green.** 5 fns + KAT (63 assertions). `prism_cd_timer` (HH:MM:SS from seconds), `prism_cd_compact` (MM:SS), `prism_cd_labeled` (title + timer), `prism_cd_segmented` (band of separate H/M/S labels), `prism_cd_progress` (timer + text bar). **MILESTONE 50: 50 ui/ modules, 70 KATs, ~430+ public functions** |
| **MB.49** | `ui/prism_ui_watermark.nova` — watermark/stamp overlay | ✅ **DONE** | 2026-08-18 | 2026-08-18 | **69/69 Prism KATs green.** 5 fns + KAT (55 assertions). `prism_wm_watermark` (layer overlay), `prism_wm_stamp` (bracketed badge), `prism_wm_confidential`/`prism_wm_draft` (presets), `prism_wm_repeated` (N-times overlay stack) |
| **MB.48** | `ui/prism_ui_segment.nova` — segmented control/toggle group | ✅ **DONE** | 2026-08-18 | 2026-08-18 | **68/68 Prism KATs green.** 4 fns + KAT (63 assertions). `prism_sg_option` ([*]/[ ] prefix), `prism_sg_segment` (horizontal band), `prism_sg_toggle_group` (vertical stack), `prism_sg_multi` (multi-select via index set) |
| **MB.47** | `ui/prism_ui_steps.nova` — steps/process indicator | ✅ **DONE** | 2026-08-18 | 2026-08-18 | **67/67 Prism KATs green.** 5 fns + KAT (68 assertions). `prism_st_step` (done/active/pending markers), `prism_st_connector`, `prism_st_steps` (horizontal bar), `prism_st_auto` (auto-assign status by current index), `prism_st_vertical` (vertical layout with "|" connectors) |
| **MB.46** | `ui/prism_ui_confirm.nova` — popconfirm/dialog | ✅ **DONE** | 2026-08-18 | 2026-08-18 | **66/66 Prism KATs green.** 4 fns + KAT (67 assertions). `prism_cf_confirm` (layer[backdrop, panel] with cancel+confirm buttons), `prism_cf_delete` (preset), `prism_cf_popconfirm` (trigger + dialog), `prism_cf_alert` (single OK button) |
| **MB.45** | `ui/prism_ui_toolbar.nova` — toolbar/action bar | ✅ **DONE** | 2026-08-18 | 2026-08-18 | **65/65 Prism KATs green.** 5 fns + KAT (56 assertions). `prism_tb_action`, `prism_tb_separator`, `prism_tb_toolbar` (band with gaps), `prism_tb_group` (no gaps), `prism_tb_action_bar` (left + flexible spacer + right) |
| **MB.44** | `ui/prism_ui_spinner.nova` — spinner/loader | ✅ **DONE** | 2026-08-18 | 2026-08-18 | **64/64 Prism KATs green.** 5 fns + KAT (64 assertions). `prism_sp_spinner` (frame-cycling |/-\), `prism_sp_loading` (spinner + message), `prism_sp_dots` (1-3 dots), `prism_sp_progress` (spinner + percentage), `prism_sp_overlay` (layer content + loader when loading) |
| **MB.43** | `ui/prism_ui_drawer.nova` — drawer/sidebar | ✅ **DONE** | 2026-08-18 | 2026-08-18 | **63/63 Prism KATs green.** 4 fns + KAT (70 assertions). `prism_dr_drawer` (layer[backdrop, panel] when open, empty label when closed), `prism_dr_sidebar` (permanent band[nav, main]), `prism_dr_triggered` (trigger button + drawer), `prism_dr_nav` (active-index marker) |
| **MB.42** | `ui/prism_ui_accordion.nova` — accordion/collapsible | ✅ **DONE** | 2026-08-18 | 2026-08-18 | **62/62 Prism KATs green.** 4 fns + KAT (66 assertions). `prism_ac_panel` (expandable with chevron indicator), `prism_ac_group` (stacked with gaps), `prism_ac_text` (simple text shorthand), `prism_ac_faq` (Q/A format) |
| **MB.41** | `ui/prism_ui_list.nova` — list/description list | ✅ **DONE** | 2026-08-18 | 2026-08-18 | **61/61 Prism KATs green.** 5 fns + KAT (56 assertions). `prism_ls_item` (bullet), `prism_ls_numbered`, `prism_ls_desc` (term + description), `prism_ls_list` (gap-separated container), `prism_ls_check` (checklist with [x]/[ ]) |
| **MB.40** | `ui/prism_ui_progress.nova` — progress/stepper | ✅ **DONE** | 2026-08-18 | 2026-08-18 | **60/60 Prism KATs green.** 4 fns + KAT (54 assertions). `prism_pg_bar` (proportional =/- bar), `prism_pg_percent` (clamped %), `prism_pg_labeled` (stack[label, bar, %]), `prism_pg_steps` (step markers with > prefix) |
| **MB.39** | `ui/prism_ui_alert.nova` — alert/banner | ✅ **DONE** | 2026-08-17 | 2026-08-17 | **59/59 Prism KATs green.** 3 fns + KAT (38 assertions). `prism_al_alert` (type + message + optional detail), `prism_al_banner` (full-width alert), `prism_al_dismissable` (alert with close button). PrismAlertType closed enum (Info/Success/Warning/Error with mapped icons) |
| **MB.38** | `ui/prism_ui_quote.nova` — blockquote/citation | ✅ **DONE** | 2026-08-17 | 2026-08-17 | **58/58 Prism KATs green.** 4 fns + KAT (46 assertions). `prism_qt_quote` (text + optional attribution), `prism_qt_pullquote` (large-style quote), `prism_qt_citation` (source + optional URL via PrismLinkTarget), `prism_qt_epigraph` (quote + author + work) |
| **MB.37** | `ui/prism_ui_chip.nova` — chip/tag display | ✅ **DONE** | 2026-08-17 | 2026-08-17 | **57/57 Prism KATs green.** 4 fns + KAT (28 assertions). `prism_ch_chip` (label + optional icon), `prism_ch_chip_group` (flow layout), `prism_ch_dismissable` (chip with close button), `prism_ch_filter_chip` (selected/unselected state via attr) |
| **MB.36** | `ui/prism_ui_comment.nova` — comment/thread | ✅ **DONE** | 2026-08-17 | 2026-08-17 | **56/56 Prism KATs green.** 6 fns + KAT (34 assertions). `prism_cm_comment` (author + text + timestamp), `prism_cm_reply`, `prism_cm_thread` (nested comment tree), `prism_cm_action_bar` (reply/like/share buttons), `prism_cm_editor` (compose area), `prism_cm_count` (reply count display) |
| **MB.35** | `ui/prism_ui_empty.nova` — empty state/placeholder | ✅ **DONE** | 2026-08-17 | 2026-08-17 | **55/55 Prism KATs green.** 4 fns + KAT (38 assertions). `prism_em_empty` (icon + message + optional action), `prism_em_no_data` (preset for data screens), `prism_em_no_results` (search-specific), `prism_em_error` (error state with retry). Validated empty-message rejection, icon presence, action button wiring |
| **MB.34** | `ui/prism_ui_anchor.nova` — anchor/link list + breadcrumb | ✅ **DONE** | 2026-08-17 | 2026-08-17 | **54/54 Prism KATs green.** 6 fns + KAT (33 assertions). `prism_an_anchor` (text + target), `prism_an_anchor_list` (vertical nav links), `prism_an_breadcrumb` (band with separator), `prism_an_back_link`, `prism_an_external` (external icon marker), `prism_an_anchor_group` (titled section). ★ Agent found `prism_link` real signature is `prism_link(text, PrismLinkTarget)` via `prism_link_target_url(url)` — documented for all future agents. Also found potential `panic()` unwind use-after-free with many struct/Result/list locals live — flagged, not fixed per compiler policy |
| **MB.33** | `ui/prism_ui_skeleton.nova` — skeleton/loading placeholder | ✅ **DONE** | 2026-08-17 | 2026-08-17 | **53/53 Prism KATs green.** 4 fns + KAT (18 assertions). `prism_sk_line` (text placeholder), `prism_sk_block` (rectangular placeholder), `prism_sk_card` (card-shaped skeleton), `prism_sk_list` (repeated skeleton rows). Width/height validated, count must be > 0 |
| **MB.32** | `ui/prism_ui_divider.nova` — divider/separator | ✅ **DONE** | 2026-08-17 | 2026-08-17 | **52/52 Prism KATs green.** 5 fns + KAT (27 assertions). `prism_dv_horizontal` (label "---"), `prism_dv_vertical` (label "|"), `prism_dv_labeled` (band["---", text, "---"]), `prism_dv_spaced` (stack[gap, hr, gap] via `prism_arrange.prism_gap(some(px))`), `prism_dv_section` (stack[labeled_divider, children]). ★ Manual fix needed: agent used wrong `match ok(n)` syntax and nonexistent `prism_style` module |
| **MB.31** | `ui/prism_ui_avatar.nova` — avatar/user card | ✅ **DONE** | 2026-08-17 | 2026-08-17 | **51/51 Prism KATs green.** 7 fns + KAT (82 assertions). `prism_av_avatar` (initials from name), `prism_av_avatar_image` (art-based), `prism_av_status` (avatar with online/offline/away/busy indicator), `prism_av_group` (flow layout with max + overflow count), `prism_av_card` (avatar + name + role), `prism_av_badge` (avatar with numeric badge), `prism_av_stack` (overlapping avatar group). PrismAvStatus closed 4-variant enum |
| **MB.30** | `ui/prism_ui_tooltip.nova` — tooltip/popover | ✅ **DONE** | 2026-08-17 | 2026-08-17 | **50/50 Prism KATs green.** 4 fns + KAT (33 assertions). `prism_tp_tooltip` (target + text), `prism_tp_popover` (target + rich content), `prism_tp_info_tip` (info icon + tooltip), `prism_tp_help` (help icon trigger). Layer-based overlay model via `prism_arrange.prism_layer` |
| **MB.29** | `ui/prism_ui_carousel.nova` — carousel/slideshow | ✅ **DONE** | 2026-08-17 | 2026-08-17 | **49/49 Prism KATs green.** 6 fns + KAT (28 assertions). `prism_cr_slide` (content wrapper), `prism_cr_carousel` (stack[content, nav]), `prism_cr_indicator` (dot indicators), `prism_cr_prev`/`prism_cr_next` (navigation), `prism_cr_auto_carousel` (with interval attr). ★ Agent found `prism_heading`/`prism_image`/`prism_icon` module don't exist — used `prism_label`/`prism_art`/`prism_content.prism_icon_*()` correctly |
| **MB.28** | `ui/prism_ui_settings.nova` — settings/preferences panel | ✅ **DONE** | 2026-08-17 | 2026-08-17 | **48/48 Prism KATs green.** 4 fns in 187 lines + 200-line KAT (76 assertions). `prism_cfg_toggle` (flag + optional description), `prism_cfg_choice` (pick with membership validation), `prism_cfg_group` (gap 8), `prism_cfg_page` (gap 16). Two-level gap hierarchy (8 within, 16 between) |
| **MB.27** | `ui/prism_ui_wizard.nova` — multi-step wizard/form | ✅ **DONE** | 2026-08-17 | 2026-08-17 | **47/47 Prism KATs green.** 4 fns in 180 lines + 249-line KAT (80 assertions, 16 rejections). `prism_wz_step_header` (band; completed=check, current=chevron_right, future=bare label), `prism_wz_page` (stack[label(title), content]), `prism_wz_nav` (press back/next; both labels validated unconditionally even at step 0), `prism_wz_wizard` (stack[header, content, nav]) |
| **MB.26** | `ui/prism_ui_result.nova` — error/result state components | ✅ **DONE** | 2026-08-17 | 2026-08-17 | **46/46 Prism KATs green.** 4 fns in 146 lines + 200-line KAT. `prism_rs_success` (check icon + message), `prism_rs_error` (warning icon + message + optional detail), `prism_rs_empty` (info icon + configurable action label), `prism_rs_loading` (spinner-like label + optional progress). Error paths validated for empty messages |
| **MB.25** | `ui/prism_ui_kv.nova` — key-value / description list | ✅ **DONE** | 2026-08-17 | 2026-08-17 | **45/45 Prism KATs green.** 4 fns in 207 lines + 221-line KAT (76 assertions, 9 rejections). `prism_kv_pair`, `prism_kv_list`, `prism_kv_table` (PrismKvEntry struct with `kv_`-prefixed fields + optional note), `prism_kv_section`. Not a duplicate of `prism_ui_kit.prism_ui_kv` (that adapts raw tuples; this adds typed struct + note/section layers) |
| **MB.24** | `ui/prism_ui_code.nova` — code/syntax display | ✅ **DONE** | 2026-08-17 | 2026-08-17 | **44/44 Prism KATs green.** 4 fns in 222 lines + 265-line KAT (108 assertions). `prism_cd_block` (lang attr), `prism_cd_inline`, `prism_cd_diff` (side-by-side), `prism_cd_snippet` (titled card + optional line numbering via `split`). Known limitation: multi-line code in `prism_cd_block` loses line breaks at ANSI backend (sanitizer strips byte 10); `prism_cd_snippet` with `cd_line_start` is the workaround |
| **MB.23** | `ui/prism_ui_upload.nova` — file upload/attachment | ✅ **DONE** | 2026-08-17 | 2026-08-17 | **43/43 Prism KATs green.** 4 fns in 230 lines + 223-line KAT (66 assertions, 12 rejections). `prism_up_dropzone`, `prism_up_file_item` (PrismUpStatus enum: Uploading/Done/Failed with distinct icons), `prism_up_file_list`, `prism_up_preview` (mandatory alt for a11y) |
| **MB.22** | `ui/prism_ui_sort.nova` — sortable/reorderable list | ✅ **DONE** | 2026-08-17 | 2026-08-17 | **42/42 Prism KATs green.** 4 fns in 263 lines + 286-line KAT (105 assertions, 14 rejections). `prism_so_sortable` (keyed via `prism_each`, Menu icon drag handle), `prism_so_move` (pure non-mutating reorder), `prism_so_ranked` (numbered), `prism_so_checklist` (check/minus icons, membership validated) |
| **MB.21** | `ui/prism_ui_pager.nova` — pagination | ✅ **DONE** | 2026-08-17 | 2026-08-17 | **41/41 Prism KATs green.** 5 fns in 244 lines + 318-line KAT (108 assertions, 20 rejections). `prism_pg_pager` (windowed with ellipsis, O(window) nodes), `prism_pg_size_select`, `prism_pg_info` (0-total edge case algebraically forced), `prism_pg_compact`, `prism_pg_load_more`. Not a duplicate of `prism_nav_pages` (that shows all pages with press; this is windowed with links and ellipsis) |
| **MB.20** | `ui/prism_ui_notice.nova` — notification/badge | ✅ **DONE** | 2026-08-17 | 2026-08-17 | **40/40 Prism KATs green.** 5 fns in 198 lines + 218-line KAT (65 assertions). `prism_nt_badge` (layer overlay, 0=hidden, max+ overflow), `prism_nt_dot` (indicator), `prism_nt_item` (nt_read attr), `prism_nt_list` (empty-text validated unconditionally), `prism_nt_group` |
| **MB.19** | `ui/prism_ui_rating.nova` — rating/review | ✅ **DONE** | 2026-08-17 | 2026-08-17 | **39/39 Prism KATs green.** 5 fns in 290 lines + 298-line KAT (122 assertions, 19 rejections). `prism_rt_stars` (check/minus icons), `prism_rt_review`, `prism_rt_summary` (average in tenths, 5-row distribution bars), `prism_rt_review_list`, `prism_rt_score_badge`. Not a duplicate of `prism_in_rating` (different shape: inline display vs editable form field) |
| **MB.18** | `ui/prism_ui_color_pick.nova` — color picker/swatch | ✅ **DONE** | 2026-08-17 | 2026-08-17 | **38/38 Prism KATs green.** 5 fns in 315 lines + 256-line KAT. `prism_cp_swatch`, `prism_cp_palette`, `prism_cp_picker` (cp_selected attr), `prism_cp_gradient` (linear RGB interpolation, integer-only), `prism_cp_display` (hex/rgb/hsl). PrismCpFormat enum. Agent found `ascii()`/`char()` don't exist — used `ord()`/`chr()` instead. HSL conversion integer-only, no float anywhere |
| **MB.17** | `ui/prism_ui_stat.nova` — dashboard stat/metric cards | ✅ **DONE** | 2026-08-17 | 2026-08-17 | **37/37 Prism KATs green.** 5 fns in 230 lines + 260-line KAT (~90 assertions, 13 rejection paths). `prism_st_stat` (prefix/suffix formatting), `prism_st_trend` (direction icon + change text via `PrismStDirection` closed 3-variant enum — chevron_up/down/minus), `prism_st_comparison` (current vs previous), `prism_st_card` (titled wrapper with gap), `prism_st_dashboard` (flow grid). No structs needed, so no field-prefix question arose. Agent correctly identified overlap with `prism_ui_data.prism_ui_stat` and documented the distinction (the new module adds formatted display, comparisons, and dashboard layout that the data module does not have) |
| **MB.16** | `ui/prism_ui_tree.nova` — hierarchical tree view | ✅ **DONE** | 2026-08-17 | 2026-08-17 | **36/36 Prism KATs green.** 5 fns in 347 lines + 409-line KAT (~65 assertions). `prism_tv_leaf` (band: icon+label), `prism_tv_branch` (stack: header + children, `tv_expanded` attr), `prism_tv_tree` (root container), `prism_tv_file_tree` (recursive from `PrismTvEntry` structs, `tve_`-prefixed fields), `prism_tv_search_tree` (case-insensitive filter with ancestor preservation, force-expands matched branches). ★ **Agent caught a real segfault bug during build:** the recursive converter took a typed `PrismTvEntry` parameter but was called via `prism_ui_collect` on a bare untyped `list` — feeding a non-entry element forced a struct-shaped memory read on string data before any `type_name` guard could run. Fixed by making the parameter untyped, matching the proven idiom everywhere else in this codebase. ★ **Collapsing discards children, so search can't see collapsed subtrees** — documented explicitly as a design choice |
| **MB.15** | `ui/prism_ui_timeline.nova` — vertical timeline | ✅ **DONE** | 2026-08-17 | 2026-08-17 | **35/35 Prism KATs green.** 4 fns in 244 lines + 247-line KAT (~90 assertions). `prism_tl_item` (icon-by-status + label + optional description), `prism_tl_timeline` (vertical stack), `prism_tl_step_timeline` (wizard progress — auto-assigns Pending/Active/Done by index), `prism_tl_changelog` (version/date/summary via `PrismTlChange` struct, `tlc_`-prefixed fields). `PrismTlStatus` closed 4-variant enum. ★ Agent found spec's `prism_icon_more()` and `prism_icon_edit()` don't exist in the closed 12-icon set; substituted `prism_icon_minus()` (Pending) and `prism_icon_chevron_right()` (Active) with documented reasoning |
| **MB.14** | `ui/prism_ui_calendar.nova` — month-view calendar | ✅ **DONE** | 2026-08-17 | 2026-08-17 | **ALL PASS** (manually verified). 281 lines + 235-line KAT. Pure integer date math (Sakamoto's algorithm for day-of-week, Gregorian leap rule) — no external date lib imported. Fixed 8-child structure: nav header, day-of-week labels, 6 week rows of 7 cells (always 6 rows regardless of month layout — stable shape contract). `PrismCalendarEvent` struct (`cal_ev_`-prefixed fields). KAT verifies leap year boundaries indirectly through `selected_day` validation (Feb 2024 accepts 29, rejects 30; Feb 1900 accepts 28, rejects 29). Day-of-week verified against 4 hand-computed real dates (2026-08-17=Mon, 2024-07-04=Thu, 2000-01-01=Sat, 2026-01-01=Thu) |
| **MB.13** | `ui/prism_ui_transfer.nova` — dual-list transfer picker | ✅ **DONE** | 2026-08-17 | 2026-08-17 | **33/33 Prism KATs green.** 3 fns in 230 lines + 181-line KAT. `prism_xf_transfer` (band[left, buttons, right]), `prism_xf_move_right`, `prism_xf_move_left`. `PrismTransferItem` struct (`xf_`-prefixed fields). Pure value functions — caller owns state, re-renders after mutation. Rejects duplicate keys, disabled items block move |
| **MB.12** | `ui/prism_ui_token.nova` — tags/chips | ✅ **DONE** | 2026-08-17 | 2026-08-17 | **76/76 KAT assertions pass** (32/32 gate green at commit time). 4 components in 238 lines: `prism_tk_tag`, `prism_tk_tag_closable`, `prism_tk_tag_group`, `prism_tk_tag_input`. `PrismTagVariant` closed 4-variant enum with exhaustive match. Tag input rejects duplicates, hides entry at capacity, close button has mandatory accessible name (§13). First `ui/` module to import `prism_node` directly (needed for variant attr on band node — see header for why) |
| **MB.11b** | `dev/prism_inspect.nova` — tree inspector | ✅ **DONE** | 2026-08-17 | 2026-08-17 | **32/32 KAT assertions pass.** 317 lines + 170-line KAT. 6 public fns: `prism_inspect_pretty` (max_width-aware), `prism_inspect_at` (index-path navigation), `prism_inspect_find_kind`/`prism_inspect_find_key` (return paths), `prism_inspect_summary`, `prism_inspect_tree` (renderable inspector node). Byte-length truncation (not UTF-8 cell width) — deliberate, documented tradeoff for a dev tool. Import surface kept to 3 modules |
| **MB.11** | ★ **ANSI `cols` finally means something** | ✅ **DONE** | 2026-08-16 | 2026-08-16 | **30/30 Prism KATs green.** `prism_ansi_render_width(node, cols)` has taken a width parameter since MA.6 that it **could not honour** — nothing could wrap, so long text overflowed and `cols` was a parameter that lied. Labels now wrap to `cols - indent`, UTF-8 aware: **ASCII @40 → max line 39; CJK @20 → max line 20** (10 chars × 2 cells, not 20 bytes). Deep indent clamps to a floor of 8 cells so the available width can never reach 0 (which would make wrapping loop). **Only `label` is wrapped, deliberately:** `_ansi_inline` composes text containing ANSI escapes (OSC-8 links, bold) which occupy **zero display cells but many bytes**, so measuring composed output would wrap far too early and split an escape sequence into garbage. `label` is the case that actually overflows and is pure sanitized text. Stated in-file rather than left implicit |
| **MB.11x** | ⛔★ **Importing `prism_text` into the backend made every label render EMPTY** | ✅ **DONE** | 2026-08-16 | 2026-08-16 | The obvious implementation — import `prism/text` and call `prism_text_wrap` — **broke rendering silently**: every label came out as `""` while the same `text` attr read correctly through `prism_node`. The node was intact; the read *inside the renderer* was not. Cause is the wide import surface: `prism_text` → `prism_ui_kit` → `prism_arrange`/`prism_content`/`prism_interact`, and NOVA's field-name→slot table is **global, last-registration-wins** — the same condition that made `PrismNode.kind` read the wrong slot and crash the HTML renderer (MB.6x). **Fixed by implementing width+wrap locally (~60 lines) and keeping the backend's import surface at two modules.** Better layering regardless: a *backend* must not depend on the component kit. The duplication is deliberate and cheap; the coupling would not have been. **Also found en route:** `for ln in unwrap(lines)` iterated **zero times** while the same unwrap returned a 1-element list one line earlier — bind the unwrap to a local first |
| **MB.10** | `obs/` + `text/` | ✅ **DONE** | 2026-08-16 | 2026-08-16 | **30/30 Prism KATs green.** `obs/prism_obs.nova` (594) — stats, §16 budgets, keyed structural diff; `text/prism_text.nova` (439) — measurement, wrapping, truncation, padding. **Measured MB.6 docs page: 573 nodes, depth 9, 398 attrs, 4,483 text bytes.** ★ **Keyed diff works as specified:** a child list is diffed BY KEY whenever every child on both sides carries one (true for `each`/`grid` rows), so inserting a row at the top reports **ONE addition, not N changes** — proven directly. At most one `reordered` change per container, never per row. Unkeyed containers fall back to positional diffing, documented as precisely the failure mode §12.6's identity model exists to prevent. ★ **`text/` closes a real gap:** `prism_ansi_render_width` has always taken a `cols` parameter it could not honour, because nothing could wrap. Prism must own measurement anyway — `PRISM_STATUS`'s F3 records that per-glyph browser metrics are impossible |
| **MB.10x** | ⛔★ **`std/text/wcwidth.nova` returns BYTE counts, not display width** | ✅ FOUND+RECORDED | 2026-08-16 | 2026-08-16 | A module whose entire purpose is display-width measurement charges **1 cell per byte > 127**. Measured: `café`→**5** (should be 4), `中`→**3** (should be 2), `中文`→**6** (should be 4). ⇒ **anything using it for terminal alignment is misaligned for any non-ASCII text**; the other `std/text/*` and `std/textlayout/*` modules share the failure mode since they all measure in `len()`. Root cause is trap 15: **`len()` counts BYTES** (`len("é")==2`, `len("中")==3`), `ord()` returns the first byte, `chr()` masks `& 0xFF`. `prism_text` decodes UTF-8 itself and measures correctly (4/2/4). **`std` NOT edited** — added to the after-Prism backlog as item 7 |
| **MB.10y** | Trap 16: module constants are not exported | ✅ **DONE** | 2026-08-16 | 2026-08-16 | `mod.SOME_CONST` fails `E1002: unknown identifier 'mod'` — the module name does not resolve in a *value* position, only a *call* position. A module-scope `let` is private however it is spelled. With traps 11-13 the rule is now simple: **a NOVA module's public surface is its functions**; types cross by bare name, everything else needs a wrapper. `prism_obs` mirrors §16's ceilings as local literal-returning functions for this reason |
| **MB.9** | ★ **`a11y/` — §13's claim becomes a CHECK, and it found a real defect** | ✅ **DONE** | 2026-08-16 | 2026-08-16 | **28/28 Prism KATs green.** `a11y/prism_a11y.nova` (230) + KAT (150). §13 says accessibility is **derived, not annotated** — but that was only half true: constructors enforce accessible names for their OWN primitive and the HTML renderer emits §17A's roles, so **every guarantee was local and nothing looked at a finished tree.** A page can be assembled entirely from valid components and still be unusable. 9 rules over a walked tree, severity-split (error = unusable by some input method; warning = degrades), with an **exhaustive wildcard-free** rule-name match so adding a rule without naming it is a compile error. **Deliberately does NOT re-check what a constructor already rejects** — `prism_each`/`prism_grid` reject duplicate keys at construction, so such a rule would be dead code reading like coverage; that reasoning is stated in-file. ★ **FOUND A REAL DEFECT IN A SHIPPED PAGE:** the MB.6 docs reference contained an **exclusive (modal) sheet with nothing focusable** — a focus trap the user can neither act on nor leave. **Fixed the page, not the rule** (the brief explicitly forbade weakening it), and the example is now better documentation because it shows the correct shape of a modal. Dashboard audited clean first time |
| **MB.9x** | `obs/` deferred — agents lost to session limit | ✅ **DONE in MB.10** | 2026-08-16 | 2026-08-16 | Both MB.9 agents died at the file-reading stage; `a11y/` was written by hand instead. `obs/` (tree stats, budget enforcement against §16, and a **keyed** structural diff) is still to do. The headline requirement for it: a diff of two trees differing by one inserted keyed row must report **ONE addition, not N changes** — a positional diff would report the whole list as changed and quietly defeat §12.6's identity model |
| **MB.8** | Data grid (increment 1) + `intl/` | ✅ **DONE** | 2026-08-16 | 2026-08-16 | **27/27 Prism KATs green.** `ui/prism_ui_grid.nova` (595) — column pin/freeze, resize, single+multi selection, cell-edit state, reorder; `intl/prism_intl.nova` (631) — message catalog, CLDR plurals, number grouping, locale fallback, direction. **Grid scope is explicit:** virtualization, grouping, aggregation, fill-down, clipboard, infinite scroll and edit-commit are named IN THE HEADER as future increments rather than silently omitted (`ui/README.md` sizes the full grid at 3-5 person-months). ★ **My spec item "reject more pinned than total" was DEAD CODE** — pin is per-column, so it can never fire; the agent recognised that and substituted a reachable invariant (at least one column must stay unpinned) instead of implementing an unreachable check. ★ **`intl` deliberately does NOT reuse `std/i18n/locale.nova`**, and says why: its `i18n_translate` does the **silent key-echo fallback this milestone explicitly forbids** (that is how untranslated strings ship looking intentional), and its plurals are binary with no CLDR categories. Polish plural rules implemented with the real teen-exception boundaries (1→one; 2-4→few *unless* n%100 in 12-14; 5-11→many; 12-14→many; 22-24→few), asserted at each |
| **MB.8x** | ★ **New lexer trap found: a literal `{` breaks strings** | ✅ **DONE** | 2026-08-16 | 2026-08-16 | `{...}` is interpolation syntax, so an unmatched `{` makes the lexer scan for an interpolation expression to **end-of-file** and report **`E0010: unterminated string literal`** — which is actively wrong, the string IS terminated, and the reported location is meaningless (often `1:1`). Anyone hitting it hunts for a missing quote that does not exist. Verified by me independently: `"a { b"` → E0010; `"a {} b"` → E0001 `unexpected INTERP_END`; `"a {x} b"` → ok. Workaround is `chr(123)`/`chr(125)`. Recorded as `NOVA_LANGUAGE_FEATURES.md` §7 **trap 14** — affects any code emitting brace-delimited text: templates, JSON, code generators |
| **MB.7** | `style/` theme + design tokens — `style/` finally meets `ui/` | ✅ **DONE** | 2026-08-16 | 2026-08-16 | **25/25 Prism KATs green.** `style/prism_theme.nova` (227) + `style/prism_tokens.nova` (461). Closes a real gap: MA.4 built 18 WCAG-verified palettes, MB.1-6 built 37 components, and **nothing connected them** — every palette was unused by the component layer. **Theme design:** role looks are built purely from symbolic `prism_paint_slot` references, never literal hex, so the SAME 6 role looks serve all 18 palette×mode combinations and only `prism_theme_resolved` produces 18 different flattened answers. `prism_theme_with` is later-wins and **non-mutating** (asserted on the original) — a theme is shared by every component using it. **Tokens:** every scale is a **closed enum, not a raw int**, so an off-scale value is unrepresentable. Type scale derives leading = size × 3/2 (WCAG 1.4.8), proven by cross-multiplication rather than trusting truncation. **Enums are deliberately payload-free** — a payload needs a field name, and the field→slot table is global; zero-arg variants cannot collide at all. The neutral ramp's formula was validated by offline simulation that found real degeneracies, then **298,376 boundary combinations** tested |
| **MB.7x** | ⛔★ **4 of 18 palettes shipped BELOW WCAG AA on accent** | ✅ **DONE** | 2026-08-16 | 2026-08-16 | The theme agent flagged honestly that `action_primary`'s text-on-accent color was an **approximation, not verified**. I measured it: **ocean/light 3.54, forest/light 3.09, sunset/light 3.42, rose/light 4.28 — all below 4.5:1.** The palettes had only ever asserted **ink-on-ground**, so the moment a component put text ON the accent, 4 themes shipped an accessibility defect. A design system whose stated value is *measured* contrast cannot leave one of its own pairings unmeasured. Fixed by darkening those four light accents (15/21/16/5%, computed not guessed) and adding `prism_palette_contrast_ground_accent` **asserted for all 18 in the KAT**, so it cannot regress the way it silently arrived. Dark variants already passed (5.6-10.3) and were left alone. **Now all 18 pass AA on BOTH pairings** |
| **MB.6** | ★ **Real app + generated `ui/` reference — the falsifier for `ui/`** | ✅ **DONE** | 2026-08-16 | 2026-08-16 | **23/23 Prism KATs green.** `app/prism_app_dashboard.nova` (a real admin screen: shell, breadcrumb, stat row, chart+legend, sorted table, validated form, overlay, alert, empty state) + `app/prism_app_docs.nova` (generated `ui/` reference with a mechanized coverage check, following MA.7's catalog design). 37 components were each proven in isolation and **none had been proven to COMPOSE**; this is the falsifier, the same role MA.6's ANSI backend played for the node tree. Docs page: **depth 9, 571 nodes**, well inside the 256/100,000 bounds. **Both agents died on the session limit at the verification step; I finished and debugged it.** Also corrected a layering inversion: the docs route had been added *into* `prism_forge.nova`, which would make the generic bridge import a specific page — and thus the whole `ui/` layer — for every Forge user. Moved into `prism_app_docs.nova`; dependencies point specific→generic, never back |
| **MB.6x** | ⛔★★ **`PrismNode.kind` read the WRONG SLOT — the renderer segfaulted** | ✅ **DONE** | 2026-08-16 | 2026-08-16 | The docs page is the first program to import **all 11 `ui/` modules + `widget/` + `core/` + both renderers at once**, and `prism_html_render` **crashed**. Root cause: NOVA's field-name→slot table is **global, last-registration-wins**, and severity scales with import count. `PrismNode.kind` is slot **1**; `PrismFormField` declares `kind` at slot **3** — so importing the form module made every node's `kind` read slot 3 (`children`, a **list**), the exhaustive match fell through to `""`, and rendering died. Same for `PrismNode.key` (slot 4) vs `PrismTableColumn.key` (slot 1). **A wrong-slot read on a struct-typed field is a wild pointer read — a crash, not a wrong answer.** `label` had survived earlier collisions only by accidentally being slot 0/1 everywhere. Fixed by prefixing the non-core structs (`field_kind`, `col_key_name`, `cat_kind`, `pick_value`/`pick_label`) — the shared foundation keeps the plain names. **Still latent, recorded not fixed:** `std/core/tree.nova` declares `children` at a different slot than `PrismNode`; harmless only because Prism does not import it. Compiler-side fix (per-struct slot tables) added to the after-Prism backlog |
| **MB.5** | `ui/` charts + overlays | ✅ **DONE** | 2026-08-16 | 2026-08-16 | **21/21 Prism KATs green** (gate re-run by me). `ui/prism_ui_chart.nova` (267) — bar, sparkline, pie, gauge, legend; `ui/prism_ui_overlay.nova` (249) — dropdown, popover, modal, command palette, skeleton. **10 components in 516 lines. `ui/` now: 27→37 components across 11 modules, 3,130 lines.** ★ **Pie apportionment REUSES `std/money/allocate.nova`'s `alloc_weighted`** rather than reimplementing largest-remainder — cent-safe money splitting is the identical problem, and CLAUDE.md's "does this already exist?" rule applies. Percentages sum to **exactly 100** on three awkward splits (`[1,1,1]→34/33/33`, seven equal parts, a 1:2:3 skew), verified by independent simulation before asserting. ★ Bar is built on `prism_grid` rather than hand-stacked bands, so column alignment comes free in **both** backends — and a `gap(size)` bar would have been **invisible in ANSI**, which renders every gap as one space regardless of its size attr. ★ Gauge calls `prism_range` directly instead of delegating to `prism_fb_progress`, because delegating would rewrite the stored range's min/max to `0..span` and **silently lie about the gauge's real domain** to any downstream reader. Overlay's dropdown validates **before** the open/closed fork, so a *closed* dropdown over invalid items still rejects |
| **MB.4** | `ui/` advanced inputs + media/disclosure | ✅ **DONE** | 2026-08-16 | 2026-08-16 | **19/19 Prism KATs green** (gate re-run by me). `ui/prism_ui_input.nova` (199) — date, multi-select, search, stepper, rating; `ui/prism_ui_media.nova` (272) — avatar, figure, gallery, accordion, card. **10 components in 471 lines.** Date does **real calendar validation** — pure-integer Gregorian leap rule, every month's true length, proven both ways in the KAT (2024-02-29 accepted, 2023-02-29 rejected); **36 rejection cases** in the input KAT alone. Stepper reuses nav's inert-but-present rule and asserts the node count is IDENTICAL at both bounds, so "disabled" cannot silently become "hidden". **★ Accordion is stronger than `tabs`:** collapsed content is excluded at **construction**, not filtered per-backend — `prism_tabs` relies on every renderer remembering to hide it (HTML marks `hidden`, ANSI special-cases selected-only), whereas here there is nothing for a backend to forget. Proven twice: exact node count, and by rendering through `prism_render_ansi` and asserting the collapsed body text never appears. Figure makes `alt` **mandatory** with a separate explicit `_decorative` constructor rather than letting it default blank |
| **MB.4x** | Icon-set gap noted (not acted on) | ⬜ TODO | 2026-08-16 | — | The closed 12-icon `PrismIcon` set has **no star**, so `prism_in_rating` stands in `Check()`/`Minus()` for filled/empty (same precedent as `prism_ui_data`'s `StatFlat()` reusing `Minus()`). Extending the set is purely additive — add the variant, add its `prism_icon_*` wrapper, and the exhaustive `prism_icon_name` match forces every consumer to be updated. Deferred rather than done silently |
| **MB.3** | `ui/` layout + data display | ✅ **DONE** | 2026-08-16 | 2026-08-16 | **17/17 Prism KATs green** (gate re-run by me). `ui/prism_ui_layout.nova` (206) — shell, split, drawer, grid, toolbar; `ui/prism_ui_data.nova` (277) — list, tree, descriptions, stat, timeline. **10 more components in 483 lines**, holding MB.2's density. Split's ratio is a **closed enum** encoded as mesh-track weights (half `[1,1]`, third `[1,2]`, golden `[382,618]`) — necessary because all four ratios otherwise produce an identical `d=2/c=3` tree, so "each ratio differs" is only testable through the weights; the KAT reads them back via `prism_mesh_cols`. Toolbar always emits exactly 3 group bands so a group's index is fixed regardless of which are populated. Grid propagates `prism_mesh`'s non-positive-track rejection rather than duplicating it. **Tree's cycle guard is the notable piece:** children are INDICES into the node list, which makes a cycle genuinely representable, so the "must not hang" requirement is testable rather than theatre — guarded by ancestor-path tracking *and* an independent depth ceiling |
| **MB.2** | ★★ **`@nova_rt_sql` FIXED PERMANENTLY — the gate's blocker is gone** | ✅ **DONE** | 2026-08-15 | 2026-08-15 | **Root cause was a THIRD omission in `compile_module_ir`** — the same function that was missing module-level `let`/`const` baking (`b37f501d`). The main-module path registers every `Type__method` into `ir_methods` keyed by bare suffix (~24714) so a call `q.sql()` still resolves when the inferrer cannot type `q`; **an IMPORTED module's methods were never registered**, so the dot-call fell past every resolution branch to `resolve_method_fn`'s catch-all, which fabricates `@nova_rt_sql` — a symbol that does not exist. Failure surfaced at **LINK, never at type-check**, and only for un-inferrable receivers, which is exactly why it looked ORM-specific rather than structural. **Result: 10 of the 11 ORM tests now LINK *and* PASS** (all 11 previously could not link at all). Registration is made **collision-safe** — `ir_methods` is keyed by bare suffix, so two types both defining `.size()` would dispatch one onto the other's receiver (type confusion, not a link error); an ambiguous suffix is **dropped**, falling back to today's behaviour, so the change can only ever be as good as before. Second, independent fix in the same area: `obj.field(args)` on an un-inferrable receiver whose name matches a declared struct field now lowers to a by-name `field_get` + indirect call instead of fabricating a symbol (fixes `@nova_rt_extract`, hit by MB.1's table). **Reconverged byte-identical**; Prism 13/13 and wasm 4/4 green on the reconverged compiler |
| **MB.2x** | ⚠️ `_kat_orm_phase3` — newly VISIBLE pre-existing ORM defect | ⬜ **TODO** | 2026-08-15 | — | With the link failure gone, this KAT now runs — and **crashes with an ACCESS VIOLATION inside `orm_ensure`**, a Phase-0 API, before printing anything. **Proven NOT caused by the compiler fix**, by elimination: the unpatched compiler cannot even LINK this path (so it has *never* been executable and there is no prior behaviour to regress from), and the crash persists identically across every variant — method-registration only, collision-safe registration, and with the field-fallback branch removed. ⇒ a latent ORM defect that the link failure was masking for its entire life. **This is ORM work, not compiler work** — tracked here so it is not mistaken for a Prism or compiler regression. It is the ONLY remaining regression failure |
| **MB.2** | ★ **`ui/` kit + nav + feedback — the LOC problem addressed** | ✅ **DONE** | 2026-08-16 | 2026-08-16 | **15/15 Prism KATs green** (gate re-run by me). MB.1's 1,001 lines for two components were mostly ONE hand-written loop repeated — build a list, call a fallible maker, bail on first error — which appears in `prism_each`, `prism_grid`, both renderers, the catalog, form and table. Six lines per site, and every copy is a chance to omit the `is_err` check, which fails **silently** by pushing a `Result` where a node was expected. `ui/prism_ui_kit.nova` (175) makes it one function, `prism_ui_collect`, plus 9 composition helpers. **Result: `prism_ui_feedback` delivers 5 components in 178 lines** vs form's 590 for one; `prism_ui_nav` 4 components in 306. Kit also owns the `err(unwrap_err(r))` re-wrap that exists because returning an element's `Result` directly unifies two different type parameters (E1001 — hit for real in `prism_look`), so no caller meets it again. **Uniform design rule across nav:** a control whose action is "go where you already are" is rendered present but NOT as a link — never hidden, since a vanishing control makes the layout jump under the cursor. Severity→icon is an **exhaustive wildcard-free** match; progress uses integer arithmetic |
| **MB.2x** | Agent-reported "enum variant collision" — **did NOT reproduce** | ✅ **DONE** | 2026-08-16 | 2026-08-16 | The feedback agent reported that a local enum variant named `Info()` would collide with `PrismIcon`'s `Info()` in the flat symbol space, and prefixed its variants `FbInfo`/`FbSuccess`/… to avoid it. **I probed three shapes — two modules each declaring `Info()`, a local enum vs an imported one, and an inline `match` on the imported type while a local enum shares the name — all compile, link and run correctly.** Variant constructors are mangled per-enum. The prefixing is harmless style; the stated reason is wrong, so **no trap was recorded**. Third agent claim today that did not survive a probe — the others being a mis-scoped tempfile consequence and a mis-diagnosed link error |
| **MB.2y** | ★ Real defect hit + worked around: struct field-name collision | ✅ **DONE** | 2026-08-16 | 2026-08-16 | `PrismBreadcrumbItem{label, route}` and `PrismMenuEntry{label, …, route}` sharing bare field names **corrupted `route` reads** (returned `""` instead of `"/"`) on a receiver whose type was not statically pinned. This is the documented pre-existing global field→slot table defect (last-registration-wins). **`label` survived only because it is slot 0 in every colliding struct; `route` differs in slot index (1 vs 2) and broke** — a precise illustration of why the workaround is mandatory rather than stylistic. Fixed by prefixing every field (`crumb_*`, `menu_*`) and documented in the file header. See [[reference_struct_field_name_collision]] |
| **MB.1x** | ★★ **ROOT CAUSE of the `@nova_rt_sql` bug found** | ✅ **DONE** | 2026-08-15 | 2026-08-15 | The table work hit `undefined value '@nova_rt_extract'` — the *same class* as the deferred ORM bug. **A/B probe pinned it exactly:** `obj.field(args)` where the field holds a closure resolves through **method dispatch** (struct method → module fn → builtin → *guess the runtime symbol*), not "read the field then invoke". It works when the compiler statically knows the receiver type (`cols[0].extract(41)` ✅) and emits an undefined `@nova_rt_<field>` when it does not (`unwrap(find_col(...)).extract(41)` ❌). **A LINK error, not a compile error** — silent at type-check. **⇒ the deferred ORM bug is NOT ORM-specific**; it bites any callback-in-a-struct design. Workaround `let f = obj.field; f(args)` applied in the table module. Recorded as `NOVA_LANGUAGE_FEATURES.md` §7 trap 13 + memory. **My first two repro attempts FAILED to reproduce it** (receiver type was known); only the via-`Result` shape triggers it — a reminder that a negative probe result is not proof of absence | `prism/ui/README.md` gated this on *"`widget/` (MA.3) and `style/` (MA.4) interfaces frozen"* — **both are now done and CI-gated, so it is unblocked.** This is the layer that delivers the actual target: the ~50 Ant-Design-class components are **compositions of the 22 primitives**, not new primitives (the vocabulary stays closed — axiom A7). First two modules chosen to prove the composition model on the two hardest-earning surfaces: **`prism_ui_form.nova`** (typed fields + validation + error display — where Ant's value actually lives, and it exercises `entry`/`pick`/`flag`/`range` + layout together) and **`prism_ui_table.nova`** (columns, sorting, empty/loading states over `grid`). Both are pure GREEN library work — no compiler dependency, so unaffected by the deferred `@nova_rt_sql` fix |
| **TA** | ★ **PHASE A — COMPLETE (MA.1→MA.8)** | ✅ **DONE** | 2026-08-15 | 2026-08-15 | **All 8 milestones landed in one day.** ~4,900 lines across 12 modules + 10 KATs, every one gated. Prism now: a bounds-checked backend-agnostic node tree · all 22 primitives as validated constructors · typed `look`/`palette` with 18 WCAG-verified themes · **two working backends** (HTML + ANSI) proving the tree is genuinely backend-agnostic · a generated catalog · CI enforcement. **Zero compiler or runtime files touched — entirely GREEN blast radius.** Found and recorded **5 NOVA compiler/language defects** along the way, 2 of which break shipped code (`forge.set_max_body`, `tempfile` uniqueness) | Split into two independent halves so neither agent blocks the other and neither touches the other's files. **A:** `widget/prism_arrange.nova` (§7 — `stack` `band` `layer` `mesh` `flow` `pane` `gap`) + `widget/prism_content.nova` (§8 — `label` `art` `glyph` `draw`), KAT `_kat_prism_widget_a.nova`. **B:** `widget/prism_interact.nova` (§9 — `press` `entry` `pick` `flag` `range` `link`) + `widget/prism_structure.nova` (§10 — `each` `grid` `sheet` `hint` `tabs`), KAT `_kat_prism_widget_b.nova`. **Not thin wrappers** — enumerated attributes must be validated and invalid values rejected with a typed `err`. Two spec obligations are enforced AT THIS LAYER, not deferred: §10's mandatory identity selector (`by` is a REQUIRED param on `each`/`grid`; a duplicate key inside one of them is an error, not last-write-wins) and §15.1's injection-unrepresentable guarantee (`prism_link` takes an ALLOWLIST of schemes — `javascript:`/`data:`/`vbscript:` are REJECTED, never escaped). Every fn `prism_`-prefixed: NOVA's flat LLVM symbol space means a bare `link` collides with `forge_html.link` |
| **TA** | ★ **PHASE A — MA.3→MA.8 remaining** | 🔄 **IN PROGRESS** | 2026-08-15 | — | **Sequencing error corrected 2026-08-15:** M0.3/M0.4 are compiler work in `nova-compiler/` and do **NOT** block the `prism/` folder. A `face` is initially just a NOVA fn returning a node tree; the `face`/`->` syntax is sugar the compiler adds later (M3.1) — **library first, syntax later**, exactly how `forge_html` was built. **8 milestones MA.1-MA.8, ~9-10 weeks, ALL GREEN, ALL Sonnet-written under review, ZERO compiler risk.** Delivers: `prism/` skeleton (+ the existing 140-line `prism.nova` moved out of `test_programs/`) · node tree · all 22 primitives as functions · typed `look`/`palette` · **server-side HTML renderer usable by Forge immediately** · extended ANSI backend · generated component catalog · KATs in the gate. **Runs in PARALLEL with P0 — different files, no contention.** Awaiting go-ahead |
| T10 | **M0.1 — WASM execution gate in CI** | ✅ **DONE** | 2026-08-15 | 2026-08-15 | `_wasm_exec_gate.ps1` + `_wasm_exec_run.js` + 4 cases, wired as **`[CI 2n/3]`**. **★ FOUND A REAL BUG ON THE FIRST COMPARISON EVER RUN:** the wasm target was **silently computing wrong answers**. `i % 2` returned **0**, so Collatz(300) took the even branch every iteration (**native 16 steps, wasm 8**) and `odd_count(10)` gave **0 instead of 5**. **Cause is a three-step silent chain, not a codegen bug** — both targets emit *identical* IR (`call @nova_rt_mod`): (1) `nova_rt_mod` was never defined in `nova_runtime_wasm.c`; (2) **`-Wl,--allow-undefined` turns an undefined symbol into a wasm IMPORT rather than a link error**; (3) the JS harness filled *every* unresolved import with `() => 0n`. Net: any forgotten `nova_rt_*` becomes "returns 0" at instantiation — no link error, no trap, no failing test. Verified directly: the module's import list was exactly `[env.nova_rt_mod]`. Fixed by implementing `nova_rt_mod` (mirroring native's `b == -1` INT64_MIN guard). **★ The gate asserts the IMPORT LIST, not just the value** — a value comparison only catches functions a test happens to exercise, an import assertion catches every missing one (proved: `wx_recursion` passed the sabotage run purely because it uses no `%`). **Both failure paths sabotage-verified.** |
| T10c | ⚠️ **M0.1 rescoped — its written exit criterion is unreachable until M0.3** | ✅ **DONE** | 2026-08-15 | 2026-08-15 | The roadmap says M0.1 compares the wasm **demos'** output against native. **Not possible today:** `nova_runtime_wasm.c` is a **241-line compute-only shim** where all 166 runtime entries are no-op stubs — no strings, no lists, no allocator, and `print_*`/`printf` are stubs, so **a wasm module cannot produce any output at all**. Comparing output is meaningless when one side has none. Delivered instead: cross-target agreement on **computed values** for pure-scalar programs (native PRINTS the result, wasm RETURNS it from `nova_user_main` — same number, two channels) plus the structural import check. Once M0.3 lands a real wasm runtime this compares stdout directly. Recorded rather than silently narrowed |
| T10x | *(superseded by T10 above)* | ✅ DONE | 2026-08-15 | 2026-08-15 | **CORRECTION: my earlier "zero wasm references in nova_ci.ps1" was WRONG** — I grepped `nova-compiler/nova_ci.ps1`, which does not exist. The real file is `nova-compiler/test_programs/nova_ci.ps1` (136 lines) and it **already has** a wasm sub-gate at `[CI 2l/3]` (`_wasm_stackguard_probe.ps1`). **The real gap is narrower:** nothing builds a wasm module, runs it under node, and verifies output byte-identity against native. `node v20.19.5` is present. Remaining work: add a `[CI 2m/3]` wasm-execution gate |
| T10b | ⛔→✅ **CI BUG FOUND + FIXED: Tier-1.5 soundness gate could never fail** | ✅ DONE | 2026-08-15 | 2026-08-15 | While reading `nova_ci.ps1` for T10 I found the `[CI 2k/3]` negative-type-error gate's exit-code check had been **displaced below the 2l wasm probe**, so `_wasm_stackguard_probe.ps1` overwrote `$LASTEXITCODE` before it was read. `_neg_type_tests.ps1:85` does `if ($fail -gt 0) { exit 1 }` — **that exit code was silently discarded, so the Tier-1.5 soundness gate could NEVER fail the CI.** Fixed: check moved to immediately follow its own invocation. Parse-verified clean; every other stage confirmed to have its check adjacent. **Full CI not re-run (hours); the change is a one-line move with unambiguous PowerShell semantics** |
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
