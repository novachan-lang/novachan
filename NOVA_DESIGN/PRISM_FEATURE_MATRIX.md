# PRISM — Complete Feature Matrix & The Case That This Is The Future

**Companion to:** `PRISM_UNIVERSAL_UI_PLAN.md` (architecture) · `PRISM_ROADMAP.md` (execution)

Three questions answered here:
1. **Does Prism have every feature modern frameworks have?** (§1-§8 — 60 features, no gaps)
2. **Is each one BETTER?** (verdict column, honest — including where we lose)
3. **What can Prism do that NOTHING else can?** (§9 — 16 capabilities, each with prior-art rebuttal)
4. **Why is this the future?** (§11 — the industry is converging on where Prism starts)

**Verdict key:** **WIN** = structurally better · **TIE** = parity, no advantage claimed ·
**MATCH** = must work hard to reach parity, no win expected · **LOSE** = we are worse, stated plainly.

---

## §1 Rendering & Reactivity

| # | Feature | Best today | Prism | Verdict |
|---|---|---|---|---|
| 1 | **Component model** | React function components | `face` declaration — a NOVA fn returning a widget tree. No JSX, no `return`, no wrapper element | **WIN** — 6 lines vs 10 for a counter |
| 2 | **Reactive state** | Solid `createSignal` / Svelte `$state` | **No API at all.** `let count = 0` — compiler infers dependencies | **WIN** — the only zero-API model |
| 3 | **Derived/computed** | Solid `createMemo`, Vue `computed` | Plain function. Compiler caches it if it proves purity + dependency set | **WIN** — no API |
| 4 | **Effects** | `useEffect` (React's own docs say it's overused) | Explicit `on mount` / `on change` blocks; the *common* cases (fetch on mount, sync on change) are derived | **WIN** — no dependency arrays, so no stale-closure bug class |
| 5 | **Rendering strategy** | Solid fine-grained (no VDOM) | Compiled fine-grained → binary patch ops into a display list. No VDOM, no diff | **WIN** — no diff pass at all |
| 6 | **Keyed lists / reconciliation** | React keys, Solid `<For>` | `list items key=.id as t` — key is part of the syntax, not a convention | **WIN** — a missing key is a compile error, not a runtime warning |
| 7 | **Conditional rendering** | `{cond && <X/>}` | `if cond` as a normal NOVA statement inside a `face` | **WIN** — no `&&` / ternary gymnastics |
| 8 | **Fragments / portals** | React `<>` and `createPortal` | Fragments unnecessary (children aren't wrapped); `portal` primitive | **WIN** — one fewer concept to learn |
| 9 | **Refs / imperative escape** | `useRef` + `forwardRef` | Widget handles are values; `focus(field)` just works. No forwarding ceremony | **WIN** |
| 10 | **Context / DI** | React Context (re-render cascades) | Process-scoped state, read down the tree; no cascade because reactivity is fine-grained | **WIN** |
| 11 | **Async boundaries / Suspense** | React Suspense | `on load` / `on error` blocks per view; typed `Result` from the channel | **WIN** — errors are typed values, not thrown promises |
| 12 | **Error boundaries** | React (manual, coarse — one throw white-screens) | **Per-component supervised process**: crash → restart that component only | **WIN** — Erlang-grade, automatic |
| 13 | **Concurrent / transitions** | React 18 `startTransition` | Component = process; the scheduler preempts by priority natively | **WIN** — no scheduling API |
| 14 | **Memoization** | `useMemo`/`useCallback`/`React.memo`; React Compiler auto-inserts | Compiler-inferred, always. Nothing to write | **WIN** — React needed a whole compiler to reach this |
| 15 | **Code splitting / lazy** | `React.lazy` + bundler config | Per-route splitting inferred from the route table; islands ship zero for static | **WIN** — no manual boundaries |

## §2 Styling

| # | Feature | Best today | Prism | Verdict |
|---|---|---|---|---|
| 16 | **Scoped styles** | CSS Modules, styled-components | `style` blocks are typed values. No global namespace exists to leak into | **WIN** — scoping is structural |
| 17 | **Theming / tokens** | Ant Design ConfigProvider tokens | `theme` declaration; tokens are typed constants; per-component override | **WIN** — invalid token = compile error |
| 18 | **Dark mode** | CSS `prefers-color-scheme` + class swap | Second `theme` block; swap is one value | **TIE** — equally easy, but ours type-checks |
| 19 | **Responsive** | Media queries | `on width < 768` state variants in the style block | **WIN** — same mechanism as hover/disabled, one concept not two |
| 20 | **Animation / transitions** | CSS transitions, Framer Motion, GSAP | `animate` primitive + tween engine on the compositor thread | **WIN** — no layout-thrash class of bug; GPU by default |
| 21 | **Utility/atomic CSS** | Tailwind | Style composition (`col.card.pad_lg`) with typed values | **TIE** — similar terseness, but no string-class typos |

## §3 Forms & Input

| # | Feature | Best today | Prism | Verdict |
|---|---|---|---|---|
| 22 | **Form state** | react-hook-form | `form_of e` — struct IS the state | **WIN** — 50-field wizard = one struct |
| 23 | **Validation** | zod / yup | **Derived from field types via RTTI** | **WIN** — zod exists only because TS types are erased; ours aren't |
| 24 | **File upload** | Ant Upload + multipart plumbing | `field kind=file`; typed channel handles transport + progress | **WIN** — no FormData assembly |
| 25 | **Controlled inputs** | React's controlled/uncontrolled split | One model. `field x` binds bidirectionally; no split exists | **WIN** — a whole concept deleted |
| 26 | **IME / autofill / password managers** | Native browser inputs | Hidden native input overlaid on the focused field | **MATCH** — must reach parity, no win claimed. Real risk. |

## §4 Routing

| # | Feature | Best today | Prism | Verdict |
|---|---|---|---|---|
| 27 | **Client routing** | react-router / TanStack Router | Typed route table; params typed | **WIN** — a bad route param is a compile error |
| 28 | **Nested routes / layouts** | react-router outlets | Nested `face` composition — no special outlet concept | **WIN** |
| 29 | **Guards / auth** | Manual wrappers | Route guard is a typed fn; role gating derives from the session type | **WIN** — the 10-role RBAC becomes typed |
| 30 | **Deep linking / back-forward** | History API | Same, via platform shim; state restoration is typed | **TIE** |

## §5 Data

| # | Feature | Best today | Prism | Verdict |
|---|---|---|---|---|
| 31 | **Data fetching** | TanStack Query | Typed channel to a Forge handler. **One struct, both ends** | **WIN** — no client type declaration at all |
| 32 | **Caching / invalidation** | TanStack Query keys | Cache keyed by the typed channel call; invalidation derived from the mutation's write-set | **WIN** — no manual key management |
| 33 | **Optimistic updates** | TanStack manual rollback | Compiler-split client shadow + server authority; rollback automatic | **WIN** |
| 34 | **Real-time / subscriptions** | Socket.io / STOMP | Channels ARE the primitive. `forge` already has WebSocket | **WIN** — same syntax local and remote |
| 35 | **Pagination / infinite scroll** | Manual + TanStack | `orm_paginate_keyset` already exists server-side; virtualized `list` client-side | **WIN** — already half-built |
| 36 | **Mutations** | TanStack `useMutation` | A typed channel call. `orm_tx_batch` already exists | **WIN** |

## §6 SSR & Delivery

| # | Feature | Best today | Prism | Verdict |
|---|---|---|---|---|
| 37 | **SSR** | Next.js | Forge already does SSR; Prism views render server-side to the same display list | **WIN** — one renderer, two transports |
| 38 | **SSG** | Astro / Next | A view with no runtime deps is statically evaluated at compile time | **WIN** — SSG is just island inference |
| 39 | **Hydration** | React (mismatch errors, double fetch, TTI cliff) | **Does not exist.** Initial paint and updates are the same patch protocol | **WIN** — an entire problem class deleted |
| 40 | **Streaming** | React 18 streaming SSR | Patch stream is incremental by construction | **TIE** |
| 41 | **Islands / partial hydration** | Astro (`client:load`, manual) · Marko (partial infer) | **Fully inferred** — zero bytes for provably static subtrees | **WIN** — no directives |
| 42 | **Resumability** | Qwik | Unnecessary — no hydration to resume from | **WIN** — solves the problem by not having it |

## §7 Developer Experience

| # | Feature | Best today | Prism | Verdict |
|---|---|---|---|---|
| 43 | **Hot reload** | Vite HMR (~50-200 ms) | Incremental compile is already 170 ms; target <500 ms with state preserved | **MATCH** |
| 44 | **DevTools** | React DevTools (mature) | Must build: tree inspector, live state, layout overlay, repaint flash, **time-travel** | **MATCH** early → **WIN** later (time-travel is free) |
| 45 | **Type safety** | TypeScript (erased at runtime) | NOVA types, **present at runtime via RTTI**, verified across the wire | **WIN** — decisively |
| 46 | **Error messages** | Svelte/Elm are best-in-class | NOVA's established style: located + actionable + suggested fix | **MATCH** — must earn it, achievable |
| 47 | **Testing** | Playwright + testing-library | Query the widget tree by role/label (roles are derived, so queries are exact) | **WIN** — role queries can't drift from markup |
| 48 | **Debugging** | Browser devtools + source maps | WASM source maps; own inspector; time-travel | **MATCH** — genuine early weakness |
| 49 | **Build / bundling** | Vite (fast, but webpack config, package.json, node_modules) | **`nova build`. No bundler, no npm, no node_modules, no config file** | **WIN** — and eliminates the npm supply-chain attack surface entirely |
| 50 | **Source maps** | Standard | Must implement for WASM | **MATCH** |

## §8 Advanced

| # | Feature | Best today | Prism | Verdict |
|---|---|---|---|---|
| 51 | **i18n / RTL** | react-i18next + CSS logical props | Typed message catalogs; layout engine mirrors natively (we own layout) | **WIN** — RTL is a layout-engine flag, not a CSS rewrite |
| 52 | **Accessibility** | ARIA APG patterns, all manual | **Derived from the widget type. Cannot drift.** | **WIN** — structurally impossible for div-soup HTML |
| 53 | **Virtualization** | react-window / TanStack Virtual | Built into `list` + scroll viewport | **WIN** — not a library, a primitive |
| 54 | **Drag & drop** | @hello-pangea/dnd | Pointer primitives + typed drop targets | **TIE** |
| 55 | **Gestures / touch** | Hammer.js, RN Gesture Handler | Unified pointer/touch/stylus model across all backends | **WIN** — one model, every platform |
| 56 | **Offline / PWA** | Service workers + manifest | Native app on desktop/mobile backends; SW shim on web | **WIN** — real native beats PWA |
| 57 | **Web Workers / parallelism** | postMessage (serializes everything) | Component = process. Compiler places heavy components on workers | **WIN** — no worker plumbing written by hand |
| 58 | **Animation orchestration** | GSAP timelines | Tween engine + typed timelines | **TIE** |
| 59 | **3D / canvas** | Three.js (600K lines, foreign body) | **Native primitive** — `canvas` widget with our own GPU pipeline | **WIN** — see §9.11 |
| 60 | **Charts** | Recharts / D3 | NOVA chart library; **renders client AND server** (same code for PDF) | **WIN** — see §9.10 |

---

# ⚠️ SCOPE CORRECTION (2026-08-14) — §1-§8 is only TIER 1

§1-§8 above covers **60 features: the framework core** — what React, Vue, Svelte, and Solid actually
ship. That is **not** what an enterprise application needs.

**The structural problem, and it is specific to Prism:** React ships ~60 features and lets **npm's 2
million packages** supply the rest. **Prism has no npm.** So every feature a React team installs, a
Prism team must find inside Prism — or they are stuck with no move at all.

**Therefore Tier 2 is not optional for Prism the way it is for React.** This is the true scope:

| Tier | What it is | Count | Who provides it in React-land |
|---|---|---|---|
| **1** | Framework core (§1-§8) | **60** | The framework |
| **2** | Application platform | **~42** | **npm libraries** — Prism must ship these itself |
| **3** | Product & enterprise concerns | **~30** | Teams hand-build them every time |
| | **TOTAL REAL SCOPE** | **~132** | |

**Documented before this correction: 60 of ~132 ≈ 46%.**

## §8b — TIER 2: Application platform (Prism MUST ship these; there is no npm)

| # | Feature | React-land solution | Prism | Verdict |
|---|---|---|---|---|
| 61 | **Undo / redo** | Manual, or immer+zustand history | **FREE from the message log** (Bet 4) — state changes ARE messages, so history is structural | **WIN — decisive** |
| 62 | **Rich text editing** | ProseMirror / Slate / TipTap (~100-300 KB) | Must build. `entry rich` over our own document model | **MATCH — major work, see risk note** |
| 63 | **Clipboard / paste-from-Excel into a grid** | Hand-rolled per app | Typed clipboard payloads; `grid` accepts a tabular paste natively | **WIN** |
| 64 | **Timezone-correct date/time** | date-fns-tz / Luxon / dayjs+plugins | Typed `Instant`/`ZonedDateTime`/`PlainDate` in std, not strings | **WIN** — tiger1's timesheets span timezones; string dates are the #1 source of these bugs |
| 65 | **Locale number / currency formatting** | Intl + wrappers | Typed, locale-parameterized | **TIE** |
| 66 | **Pluralization / ICU messages** | react-intl / i18next | Typed message catalogs, compile-checked placeholders | **WIN** — a missing placeholder is a compile error |
| 67 | **Keyboard shortcuts / command palette** | react-hotkeys + custom | First-class: shortcuts derive from the `press`/`route` vocabulary, so the palette is generated | **WIN** |
| 68 | **Focus restoration** (after modal close, route change) | Manual, frequently wrong | Derived from `sheet`/`focus_scope` | **WIN** |
| 69 | **Scroll restoration** | react-router + manual | Derived from `pane` + route identity | **WIN** |
| 70 | **View / page transitions** | Framer Motion, View Transitions API | `motion` on route boundaries | **TIE** |
| 71 | **Toasts / snackbars / notification center** | react-hot-toast etc. | `notice` surface (add to vocabulary) | **TIE** |
| 72 | **Empty / loading / error states** | Ad-hoc per component | `on load` / `on fail` are already in the grammar (§5) | **WIN** — states are structural, not conventional |
| 73 | **Skeleton placeholders** | react-loading-skeleton | Derived from the face's own layout shape | **WIN** — the skeleton IS the static layout, auto-generated |
| 74 | **Multi-tab / multi-window state sync** | BroadcastChannel + manual | **FREE — channels already cross process boundaries** | **WIN** |
| 75 | **Offline mutation queue + sync** | TanStack persist + custom | Typed channel with a durable outbox; replay on reconnect | **WIN** |
| 76 | **Optimistic concurrency / conflict resolution** | Hand-rolled per endpoint | Version field on the ORM row; typed conflict as a `Result` variant | **WIN** |
| 77 | **Presence ("who else is viewing")** | Liveblocks / custom WS | **FREE — channels + processes** | **WIN** |
| 78 | **Real-time collaborative editing (CRDT)** | Yjs / Automerge | std already has CRDT KATs (`_kat_crdt_counter`) | **MATCH** |
| 79 | **Long-running task progress** | Custom polling/WS | Channel stream with typed progress messages | **WIN** |
| 80 | **File download / streaming download** | Blob + anchor hacks | Typed streaming response (ORM streaming already exists) | **WIN** |
| 81 | **Image optimization / lazy / responsive** | next/image | `art` with derived srcset + lazy from viewport | **TIE** |
| 82 | **Video / audio playback** | react-player | `media` primitive (add to vocabulary) | **MATCH** |
| 83 | **Maps / geospatial** | Mapbox / Leaflet | `draw` + tile fetch; std has geo/bearing already | **MATCH — real work** |
| 84 | **Charts (deep: axes, brush, zoom, tooltip)** | Recharts / D3 / ECharts | `prism_ui_chart_*`; renders client AND server | **WIN** (§9.10) |
| 85 | **Data grid: cell edit, fill-down, column resize/reorder/pin/freeze, multi-select, grouping, aggregation** | AG Grid (commercial, ~1 MB) | `grid` must ship all of this | **MATCH — the single biggest component** |
| 86 | **Saved views / layout persistence** (user's column widths, filters) | Hand-rolled | Typed view state, serializable by construction | **WIN** |
| 87 | **Form autosave / draft recovery** | Hand-rolled | Derived: the face's state IS the draft (tiger1 has an `employee_draft` JSON column for exactly this) | **WIN** |
| 88 | **Wizard / stepper state machine** | XState or ad-hoc | Typed ADT + exhaustive match — the compiler proves no unreachable step | **WIN** |
| 89 | **Deep-link into modal / drawer state** | Manual URL sync | `sheet` participates in routing | **WIN** |
| 90 | **RBAC-conditional UI** (10 roles in tiger1) | `{can('x') && <Y/>}` scattered everywhere | `guard` in the grammar; capability-typed. **Unreachable UI is a compile error** | **WIN — decisive** |
| 91 | **Session lifecycle** (silent token refresh, logout-everywhere) | axios interceptors | Typed session capability with derived refresh | **WIN** |
| 92 | **Request dedup / rate limit / retry-backoff** | TanStack + custom | Channel-level policy; `forge_retry`/`forge_limits` exist server-side | **WIN** |
| 93 | **WebSocket reconnect / backoff / resume** | socket.io | Channel reconnection semantics | **WIN** |
| 94 | **Feature flags** | LaunchDarkly SDK | `forge_feature_flag` already exists — extend to faces | **WIN** |
| 95 | **A/B testing** | Optimizely | `forge_ab_router` already exists | **TIE** |
| 96 | **Analytics events** | Segment / GA | Typed event schema, compile-verified | **WIN** — an event schema change breaks the build, not the dashboard |
| 97 | **Error / crash telemetry** | Sentry | Per-face process crash reports (Bet 4) with the message log attached | **WIN** — a crash report includes the exact replay |
| 98 | **Product tours / onboarding** | Shepherd / Intro.js | Anchored `hint` sequence | **TIE** |
| 99 | **Global search (Cmd-K)** | Algolia + custom UI | Derived from the route table + typed searchables | **WIN** |
| 100 | **Breadcrumbs** | Manual | Derived from nested route structure | **WIN** |
| 101 | **Multi-tenant / white-label theming** | CSS var swapping | `palette` is a value — per-tenant is a parameter | **WIN** |
| 102 | **Reduced-motion / high-contrast / text-scale preferences** | Media queries, often ignored | `look` state variants; **`motion` respects reduced-motion by default** | **WIN** — safe default, not opt-in |

## §8c — TIER 3: Product & enterprise concerns (teams hand-build these every time)

| # | Feature | Prism | Verdict |
|---|---|---|---|
| 103 | **Component catalog** (Storybook equivalent) | Must ship. Every `face` is independently mountable, so the catalog is **generated** from the vocabulary | **WIN** — no `.stories` files to write |
| 104 | **Visual regression testing** | Byte-reproducible rendering (GPU backend) → **pixel-exact**, not fuzzy-threshold | **WIN** (§9.14) |
| 105 | **Accessibility linting / audit** | Derived semantics mean most a11y defects are **unrepresentable**; the audit checks the 4 residual annotations | **WIN** |
| 106 | **Performance budgets / bundle analysis** | `nova prism size` per route; islands make it exact | **WIN** |
| 107 | **Interaction latency profiling** | Per-face invalidation counts (spec §12.7) | **WIN** |
| 108 | **Design-token export** (to Figma) | `palette` is structured data — export is trivial | **TIE** |
| 109 | **Documentation generation** | Doc comments + derived signatures | **TIE** |
| 110 | **Migration / incremental adoption** | Mount inside an existing React app; `embed_native` escape hatch | **MATCH** |
| 111 | **Micro-frontend / independent deploy** | Faces are processes — natural isolation boundary | **WIN** |
| 112 | **Plugin / extension system** | Capability-gated third-party faces | **WIN** — a plugin cannot exceed its granted capabilities |
| 113 | **CSP / security headers** (DOM backend) | Emitted by Forge; no inline script needed | **WIN** |
| 114 | **Audit trail of user actions** | The message log IS the audit trail | **WIN** |
| 115 | **Print layout** | `look when print` state variant | **TIE** |
| 116 | **Email template rendering** | Same faces render to constrained HTML server-side | **WIN** — one component for app + email |
| 117 | **PDF / Excel export** | Server-side, same component (§9.10) | **WIN** |
| 118 | **Screenshot / share-view** | Deterministic render → stable image | **WIN** |
| 119 | **SLA / uptime instrumentation** | Forge-side, exists | **TIE** |
| 120 | **Localization workflow** (extract → translate → merge) | Compile-checked catalogs; missing key = build error | **WIN** |
| 121 | **RTL mirroring** | Layout engine flag; `stack`/`band` mirror natively | **WIN** |
| 122 | **Data residency / field-level encryption** | `Secret<T>` + capabilities (§15.3) | **WIN** |
| 123 | **PII redaction in logs/telemetry** | `Secret<T>` has no serializer — **redaction is structural** | **WIN — decisive** |
| 124 | **Consent / cookie management** | Capability-gated storage | **WIN** |
| 125 | **Versioned API compatibility** | Typed channel with explicit version negotiation | **WIN** |
| 126 | **Blue/green + rollback of UI** | Single binary per version | **WIN** |
| 127 | **Hot patching a live UI** | NOVA hot-reload machinery exists (`dlopen` path, native) | **MATCH** |
| 128 | **Crash-free-session metrics** | Per-face supervision counts | **WIN** |
| 129 | **Onboarding a new developer** | 44 keywords vs React+CSS+ARIA+npm | **WIN** |
| 130 | **Hiring / training material** | Nothing exists | **LOSE** |
| 131 | **Third-party integration widgets** (Stripe Elements, Google Maps, OAuth popups) | `embed_native`, sandboxed | **LOSE / MATCH** |
| 132 | **Ecosystem of paid component vendors** | None (AG Grid, Telerik, Syncfusion have no equivalent) | **LOSE** |

## What the corrected inventory reveals

**Three things, and they are the most useful output of this whole matrix:**

**1. Prism's channel/process model pays off far more than I credited.** Nine Tier-2 features come out
**free or nearly free** because state changes are process messages and channels already cross
boundaries: **undo/redo** (#61), **multi-tab sync** (#74), **offline queue** (#75), **presence**
(#77), **long-running progress** (#79), **audit trail** (#114), **crash reports with replay** (#97),
**crash-free metrics** (#128), **micro-frontend isolation** (#111). React teams buy or build every one
of these separately. **This is the strongest under-stated argument in the entire design** — and I had
omitted all nine.

**2. `Secret<T>` makes PII redaction structural** (#123), not a logging discipline. That is a
compliance argument, not a performance argument, and it may matter more to an enterprise buyer than
anything about frame times.

**3. Two Tier-2 items are genuinely large and were completely absent from the plan:**
- **#85 the data grid** — cell editing, fill-down, column resize/reorder/pin/freeze, multi-select,
  grouping, aggregation. AG Grid is a **commercial product**, ~1 MB, with a company behind it. tiger1's
  editable time-grid needs most of it. **Estimate: 3-5 person-months on its own.**
- **#62 rich text editing** — ProseMirror/Slate class. tiger1's document editor needs it.
  **Estimate: 3-4 person-months.** No `contenteditable` shortcut exists on the GPU backend at all.

**Revised scope: ~132 features, not 60.** The added Tier-2/Tier-3 work is roughly **+10-14
person-months** beyond the roadmap's current estimate, concentrated in the data grid, rich text, maps,
media, and the platform layer. **`PRISM_ROADMAP.md` totals are understated by that amount** and must
be revised at the next pass.

### Where we honestly LOSE

The rules require this section. Ignoring it would be dishonest.

| Feature | Verdict | Reality |
|---|---|---|
| **Ecosystem breadth** | **LOSE — badly, for years** | npm has ~2M packages. Prism starts at 0. This is the single biggest adoption obstacle and no amount of design fixes it. Mitigation: `embed_native` escape hatch + incremental mount inside an existing React app. |
| **Hiring pool** | **LOSE** | Millions of React developers, zero Prism developers. |
| **StackOverflow / LLM training data** | **LOSE** | No answers exist. Docs must be exceptional to compensate. |
| **SEO** | **LOSE (deliberately)** | Canvas is invisible to crawlers. Public pages stay on Forge SSR. Prism is for apps behind a login. |
| **Browser find-in-page** | **LOSE until reimplemented** | Ctrl+F won't work until we build in-app find. |
| **Third-party JS libraries** | **LOSE** | Stripe Elements, Google Maps, rich-text editors — all need re-implementation or `embed_native`. |
| **Text rendering maturity** | **LOSE initially** | Browsers have decades of edge-case handling. Our atlas approach inherits shaping but not everything. |

---

## §9 What ONLY Prism can do

Each with the closest prior art and why that prior art does not count.

### 9.1 — One codebase → browser + desktop + mobile + **embedded/bare-metal**
*Closest:* Flutter. *Why it doesn't count:* Dart is not a systems language — it cannot target
firmware or run without an OS. React Native is three runtimes duct-taped together.
**NOVA is the only language that legitimately spans a browser tab and a microcontroller.**

### 9.2 — Compile-time layout solving
The compiler proves a subtree's geometry is data-independent and bakes fixed coordinates —
**zero runtime layout cost.**
*Closest:* nothing. *Why:* no framework's compiler owns its layout language. React/Vue/Svelte hand
CSS to a black box. Even Flutter computes layout only at runtime.

### 9.3 — A field rename is a compile error on client AND server simultaneously
*Closest:* tRPC. *Why it doesn't count:* requires both ends in TypeScript, and is **type-only** —
no runtime verification. GraphQL needs a schema language + codegen. OpenAPI drifts on hand-edit.
**None is a single compilation unit. Prism is.**

### 9.4 — Validation derived from the type, never declared
*Closest:* zod. *Why:* **zod exists precisely because TypeScript types vanish at runtime.**
NOVA's RTTI keystone means the type is present. `form_of e` needs no schema.

### 9.5 — Reactivity with literally zero API
*Closest:* Svelte 5. *Why it doesn't count:* Svelte **retreated** from implicit to explicit `$state`.
Compose still needs `@Stable`. React needed an entire compiler to auto-memoize.

### 9.6 — Accessibility that cannot drift
Roles, labels, states, focus order, keyboard contracts derived from the widget type.
*Closest:* SwiftUI/Compose (partial derivation). *Why:* they still need manual `Semantics`/
`accessibilityLabel` for anything non-trivial. In HTML, `<div role="button">` means the information
was destroyed and manually restored — **it can always drift from behaviour. Ours cannot.**

### 9.7 — Per-component crash isolation and restart
*Closest:* React error boundaries. *Why:* manual, coarse, and a throw during render can still
white-screen. Prism gets Erlang-grade supervision from the process model, automatically.

### 9.8 — Time-travel debugging, structurally free
*Closest:* Redux DevTools (requires pure-reducer discipline) and Elm (had it, then stalled).
*Why:* state changes ARE process messages, so the message log IS the replay log. No discipline
required, nothing to opt into.

### 9.9 — Provably zero-byte static subtrees
*Closest:* Astro (manual `client:*` directives) and Marko (partial inference).
*Why:* Prism owns both the vocabulary and the reactivity analysis, so staticness is **proven**,
not declared.

### 9.10 — The SAME component renders to pixels on the client AND to PDF/PNG/HTML on the server
tiger1 today has **Recharts** (browser) *and* **xhtml2pdf** (Python, server) — two independent
implementations of "bar chart" that must be kept visually consistent by hand.
Prism: one chart component, one implementation, three outputs.
*Closest:* nothing. Server-side chart rendering is always a separate library.

### 9.11 — A 3D scene and a button are the same primitive
*Closest:* react-three-fiber. *Why:* Three.js is a **foreign body** — its own scene graph,
renderer, and lifecycle, bridged into React. Prism already owns a GPU pipeline, so a custom-shader
scene is just another draw call. **tiger1's hardest feature becomes one of the easier ones.**

### 9.12 — GPU compute and UI in ONE language, ONE binary, sharing memory
NOVA already beats C by 1.45-1.72× on matmul/tensor work. So an inference pipeline and its UI
share memory with **zero serialization**.
*Closest:* React + ONNX.js / TF.js. *Why:* two worlds with a copy between them, and the model
code is not the app's language. **This is the one that matters most for the next decade.**

### 9.13 — Runs with NO operating system
The same UI code on bare metal. *Closest:* nothing — LVGL is C-only and has no web/desktop story.

### 9.14 — Deterministic, byte-reproducible rendering
Because we own the rasterizer, output is reproducible → **pixel-exact** visual regression tests.
*Closest:* browser screenshot tests, which need fuzzy thresholds because rendering varies by
browser version, platform, and installed fonts.

### 9.15 — No build step, no bundler, no npm, no `node_modules`
`nova build`. *Closest:* Vite (still needs `package.json`, a config file, and a dependency tree).
**Also deletes the entire npm supply-chain attack surface** — a real, repeatedly-exploited risk class.

### 9.16 — Compiler-decided client/server placement
The compiler decides where a component runs (latency/trust/data-gravity analysis) and picks the
transport. *Closest:* RSC's `"use client"`, Qwik, Leptos server functions — **all manual directives.**
*(Ambitious; may reduce to an annotated form. Flagged as the least certain item here.)*

---

## §10 The competitive scorecard (as the project's rules require)

| Competitor | Its strength | Prism's answer |
|---|---|---|
| **React** | Ecosystem, mindshare | Lose on ecosystem. Beat on every mechanism: no VDOM, no hooks rules, no memo tax, no hydration, typed across the wire |
| **Solid** | Fastest fine-grained updates | Match the model, remove the API (`createSignal` → nothing), add cross-platform + full-stack types |
| **Svelte** | Smallest bundles, best DX | Match compile-time approach; go further (zero-annotation where they retreated); add native targets |
| **Vue** | Gentle learning curve | Simpler still — no template language, no SFC format, no `ref`/`reactive` distinction |
| **Angular** | Enterprise structure, DI | Structure from the type system + process model, without the boilerplate or RxJS |
| **Qwik** | Resumability, O(1) JS | We have no hydration to resume from |
| **Astro** | Islands, content sites | Islands inferred not declared. But Astro wins for content/SEO — use Forge SSR there |
| **Flutter** | True cross-platform, own renderer | Same bet, but: real DOM-free *and* systems-language *and* embedded-capable, keeping a11y honest, and 5-10× smaller payload |
| **Blazor** | C# in the browser | Zero boundary crossings vs its per-op JSInterop; ~10× smaller payload |
| **Leptos/Dioxus** | Rust WASM, fine-grained | No borrow-checker fight in UI code; own renderer so no DOM interop tax; far better compile times |
| **Phoenix LiveView** | Server-driven productivity | Same patch protocol, but can run client-side when latency demands — not all-or-nothing |
| **Elm** | Guarantees, time-travel | Same guarantees, none of the boilerplate (no Msg enum per interaction), real JS interop escape hatch |

---

## §11 Why this is the future

**Every trend the industry is currently chasing, Prism has structurally rather than bolted on.**

| Industry direction | Evidence | Prism |
|---|---|---|
| **Move reactivity to compile time** | React shipped a *compiler* to auto-memoize; Svelte/Solid/Vue Vapor/Angular all went fine-grained; VDOM is over | Compile-time native. No VDOM ever existed |
| **Ship less JavaScript** | Islands (Astro), partial hydration (Marko), resumability (Qwik) | Inferred islands; zero bytes for static; no hydration concept |
| **Fix the client/server boundary** | RSC, server functions, tRPC, GraphQL — a decade of attempts | One compilation unit. Solved by construction, not by protocol |
| **Types that survive runtime** | zod, valibot, ArkType all exist to re-add what TS erases | RTTI: types are present. Validation derived |
| **WASM as the universal target** | Every major language is targeting it | NOVA is native there; JS frameworks are guests in their own runtime |
| **One codebase, every platform** | React Native, Flutter, Tauri, Capacitor | One language, one compiler, browser → firmware |
| **AI in the application** | Every app is adding inference | GPU compute in the same language, same binary, zero-copy |
| **Supply-chain security** | npm attacks are now routine | No npm, no node_modules, no transitive dependencies |

Every one of these is a **retrofit** for existing frameworks and a **starting condition** for Prism.
That is the argument. Not "Prism is faster" — **"Prism starts where the industry is trying to get to,
and the things it does that others can't are precisely the things they cannot retrofit without
becoming a new language with a new compiler."**

### The honest counter-argument

Ecosystem beats architecture in the short run, every time. React won over better-designed
competitors because of npm, hiring, and inertia — and Prism's ecosystem is zero for years.

**So Prism's adoption case is not "it's better." It is: *for the class of app where the ecosystem
does not save you* — internal enterprise apps behind a login, apps that must also be native, apps
with AI inference in-process, apps where a client/server type mismatch is a production incident —
Prism is not incrementally better. It is the only option.**

tiger1 is exactly that class of app. That is why it is the right first target.
