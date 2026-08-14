# NOVA PRISM — The Universal Presentation Layer

**Status:** DESIGN PROPOSAL — awaiting owner GO/NO-GO
**Created:** 2026-08-14
**Scope:** RED (compiler + runtime + type system). Multi-year.
**Companion:** Forge = server framework. Prism = its client twin.
**EXECUTION PATH:** → **[`PRISM_ROADMAP.md`](PRISM_ROADMAP.md)** — 34 milestones, verifiable exit
criteria, kill gates. *Note: the roadmap's deeper decomposition revised §17's estimate upward —
trust the roadmap's numbers (5-6 mo to the decision gate, ~2.5 yr to browser v1, ~3.5 yr to full
parity).*

---

## 0. The Mandate

NOVA gets its **OWN** UI stack. **No HTML. No CSS. No DOM. No JSX.** NOVA's own widget
vocabulary, own typed styling, own layout engine, own text stack, own paint pipeline, own GPU
abstraction. The compiler must **detect everything** — zero annotations. The developer-facing
surface must be **simpler to write than Python**.

The browser is **one backend**, not the target.

### Why "no HTML" is the correct call, not the ambitious one

Three independent arguments, each sufficient on its own:

1. **Constitutional.** *"Platform independent — same code runs on any OS, any architecture, any
   target."* HTML/CSS/DOM exist only inside browsers. An HTML-based UI layer makes NOVA UI
   browser-only and forces a *second* UI system for desktop/mobile/embedded. That is a direct
   violation of a non-negotiable.

2. **Detection is impossible through HTML.** Handing a browser a markup string forfeits all
   visibility: layout happens in a black box, a `<div>` carries no semantics (so ARIA re-adds by
   hand what the markup destroyed), and CSS's cascade means no compiler can prove what a rule
   does. **Owning the vocabulary is the precondition for total detection**, not a nice-to-have.

3. **The boundary tax.** Every WASM UI framework pays JS-interop cost per DOM operation — this is
   what made Blazor WASM slow. Own the renderer and there is exactly ONE handle (the GPU context).
   The tax goes to **zero**, not "amortized."

### What we deliberately give up

| Loss | Severity | Mitigation |
|---|---|---|
| **SEO** — canvas is invisible to crawlers | Acceptable | Irrelevant behind a login. Public/marketing pages stay on Forge SSR (`forge_html`), which already exists. Prism is for **apps**, not documents. |
| **Browser find-in-page** (Ctrl+F) | Real | Must reimplement in-app. We own the text model, so we can do it *better* (scoped, typed, filterable) — but it is work. |
| **Pixel-identity across platforms** | Chosen | We use per-platform text shaping (see §9). Native text quality beats cross-platform pixel-identity for real apps. |
| **Existing JS library ecosystem** | Real | See §16 (migration). Escape hatch: an embedded native view. |
| **Browser devtools element inspector** | Real | We must ship our own inspector (§15). Non-optional. |

---

## 1. Verified Ground Truth (audited 2026-08-13/14, not assumed)

| Fact | Evidence |
|---|---|
| `nova wasm <file>` is a first-class CLI command; triple `wasm32-unknown-unknown` | `nova_compiler.nova:31579`, `:22228` |
| `extern fn name(a) -> r` + `unsafe` call declares host imports — **works** | `test_programs/_wasm_dom_event_demo.nova:4-8` |
| DOM create/set_text/set_attr/append/clear + click events **run in a real browser** | `test_programs/web__wasm_dom_event_demo/` |
| Value model (str/list/dict/struct/float) runs on wasm32 **byte-identical to native** (m6) | `BEAT_EVERY_LANGUAGE_PLAN.md:112` |
| Measured bundle: **490 B gzip** (no value model), **134 KB gzip** (todo w/ lists+strings) | measured via gzip |
| **No dead-code elimination** — every demo ≈459 KB raw regardless of content | measured |
| **BLOCKER: host→NOVA callbacks are by EXPORT-NAME STRING only.** No fn pointers, no closures, no table dispatch | `_wasm_cb_probe.nova:2` |
| **BLOCKER: WASM runtime is 698 lines of JS with a bump allocator that NEVER frees** | `_wasm_runtime.cjs:21` |
| **BLOCKER: no value tags** → ints ≥256 through polymorphic ops diverge from native | `_wasm_runtime.cjs:26-37` |
| Named fix = **m7, tagged C-runtime→wasm32**; recorded blocked *only* on missing wasi-sdk sysroot | `FRONTIER_REAUDIT_4/5` |
| **WASM is NOT in the CI gate** — zero refs in `nova_ci.ps1` | grep |

**Calibration:** react+react-dom ≈45 KB gzip. Leptos hello-world ≈100-300 KB. Blazor WASM
≈1.5-2 MB. Flutter Web ≈1.5-2 MB. **NOVA's 134 KB todo already beats Blazor ~10× and matches
Leptos** — a strong starting position, and the 490 B floor proves there is no fixed runtime tax.

---

## 2. Architecture — Eight Layers

```
              ONE NOVA UI PROGRAM
                       │
   ┌───────┬───────────┼───────────┬────────┬──────────┐
   ▼       ▼           ▼           ▼        ▼          ▼
Browser  Windows     macOS      Linux   iOS/Android  Embedded
WASM+GL   D3D12      Metal      Vulkan   Metal/Vk   framebuffer
```

| L | Layer | Owns | Radius | Delegable |
|---|---|---|---|---|
| **L7** | App | Routing, forms, data, full-stack channels | GREEN | yes |
| **L6** | Components | ~50 Ant-class widgets composed from L4 | GREEN | **yes — fleet** |
| **L5** | Reactivity | Compiler-inferred dep graph → minimal repaint | **RED** | no |
| **L4** | Widget core | The primitive vocabulary. *Replaces HTML.* | **RED** | no |
| **L3** | Layout | Single-pass box constraints + compile-time solve | YELLOW | partly |
| **L2** | Text | Glyph atlas, shaping, bidi, caret, selection | YELLOW | no — **hardest** |
| **L1** | Paint | Display lists, batching, damage tracking | YELLOW | partly |
| **L0** | GPU | WebGL2/WebGPU/Vulkan/Metal/D3D12 + software | YELLOW | partly |

---

## 3. The Seven Structural Bets

Each is either impossible for existing frameworks to retrofit, or requires them to become NOVA.

### Bet 1 — Zero-annotation reactivity
No `useState`, no `$state`, no `createSignal`, no `mutableStateOf`, no dependency arrays. The
compiler computes which mutations affect which pixels. See §8 for the analysis and its limits.

*Prior art:* React Compiler exists **specifically** to auto-insert memoization — an admission the
model needs a compiler. Svelte 5 *retreated* from implicit to explicit runes. Compose still needs
`@Stable`/`@Immutable`. **We must beat all three or admit the wall.**

### Bet 2 — Owning the vocabulary enables total detection
When the compiler knows a widget **is** a `Button`, it derives automatically and un-driftably:
accessibility role/label/state, keyboard contract, focus order, focus trapping, escape-to-dismiss,
hit geometry, and *whether a subtree is interactive at all* (feeding island inference).

In HTML, `<div role="button" aria-pressed="true" tabindex="0">` is manual restoration of semantics
the markup destroyed. **React cannot retrofit this** — the information is not in the type system.
Ant Design ships a11y bugs for exactly this reason.

### Bet 3 — One struct, compiler-verified across the wire
The target app declares `User` **four times**: `types/models.ts` (57 fields), `users/models.py`
(~50), `users/serializers.py` (again, hand-mapped camelCase), and `zod` (validation, *because TS
types are erased at runtime*). Nothing verifies they agree. A rename fails silently in production.

Prism: **one struct declaration** → ORM row + server handler type + wire format + client model +
form fields + validation, all derived, all verified. A rename is a compile error on **both ends
simultaneously**.

*Why others structurally can't:* tRPC needs both ends in TypeScript and is type-only (no runtime
verification). GraphQL adds a schema language + codegen + resolver overhead. OpenAPI codegen
drifts on hand-edit. Protobuf adds a build step. **All fail because client and server are not one
compilation unit.** NOVA's typed `Channel` already verifies both ends.

*Enabler already shipped:* the RTTI keystone (`field_names`/`type_of`/`field_get` through erased
types) means validation is **derived from the type**, not declared. `forge_admin.nova`'s
`admin_resource_model(app, pool, table, User())` already auto-derives an entire CRUD admin from a
plain struct with zero annotations. **Prism generalizes a pattern that already works.**

### Bet 4 — Component = supervised process
Per-component crash isolation and restart, from machinery already shipped. React error boundaries
are manual and coarse (one throw white-screens the app). And because state changes are messages,
**the message log IS the replay log** → Elm's beloved time-travel debugging structurally, not as a
DevTools plugin. Erasure guarantees zero cost in the single-threaded browser case.

*No prior art found* — plausibly because no language has processes cheap enough.

### Bet 5 — Zero boundary crossings *(own-renderer only)*
One GPU context handle. Not "batched," not "amortized" — **zero** per-widget crossings. This is
the tax that killed Blazor, deleted structurally.

### Bet 6 — Compile-time layout partial evaluation *(own-renderer only)*
Because NOVA owns the layout language, the compiler can identify a subtree whose geometry does not
depend on runtime data, **solve its layout at compile time**, and emit fixed coordinates — zero
runtime layout cost. No existing framework has a compiler that owns its layout language, so **none
can copy this.** See §7.

### Bet 7 — 3D stops being a special case *(own-renderer only)*
The target app needs Three.js (600K lines) for its galaxy chart because the DOM cannot draw. When
we own a GPU pipeline, a custom-shader 3D scene is **the same primitive as a button** — a different
draw call. The hardest feature in the target app becomes one of the easier ones.

---

## 4. L4 — The Widget Vocabulary (replaces HTML)

Smallest orthogonal core. Everything else composes.

**Layout:** `col` `row` `stack` `grid` `scroll` `spacer` `wrap`
**Content:** `text` `image` `icon` `canvas` (raw GPU draw) `shape`
**Interactive:** `button` `field` `toggle` `slider` `choice` `menu` `link`
**Structure:** `list` (keyed/virtualized) `table` `tabs` `dialog` `sheet` `tooltip`
**Meta:** `portal` `focus_scope` `clip` `transform` `animate`

~26 primitives. The ~50 Ant-Design-class components in the target app are **compositions**, not
new primitives — `DatePicker` = `field` + `dialog` + `grid` + `button`.

Every primitive carries its semantics **in its type**, which is what makes Bet 2 work.

---

## 5. Proposed Syntax

> ⚠️ **SUPERSEDED — see [`PRISM_SPEC.md`](PRISM_SPEC.md) Parts II-III.**
> The syntax below used `view`/`col`/`row`/`text`/`button`/`style`/`theme`, which are borrowed from
> Flutter, SwiftUI, and CSS. The spec replaces them with Prism's own vocabulary
> (`face`/`stack`/`band`/`label`/`press`/`look`/`palette`) for reasons of semantic honesty and
> identity — a Prism `face` is a *supervised process*, not a React component, and naming it
> `component` would promise semantics we do not have. The *shape* of the syntax below still holds;
> only the names changed. **The spec is normative.**

A `view` declaration form — indentation-structured, reading like the tree it produces. **No
template language, no JSX**; this is NOVA syntax.

### Counter

```nova
view counter
    let count = 0
    col
        text "Count: {count}"
        button "Increment" -> count += 1
        button "Reset"     -> count = 0
```

vs React+TS:
```tsx
function Counter() {
  const [count, setCount] = useState(0);
  return (
    <div className="col">
      <span>Count: {count}</span>
      <button onClick={() => setCount(count + 1)}>Increment</button>
      <button onClick={() => setCount(0)}>Reset</button>
    </div>
  );
}
```

**6 lines vs 10. No `useState`, no setter, no JSX, no className, no import, no type params.**

### Multi-statement handlers — solves the single-expression-lambda constraint

`-> expr` for one expression; an **indented block** for many. No lambda syntax needed at all:

```nova
        button "Save"
            validate(form)
            save(pool, form)
            notify("Saved")
            close()
```

This works *around* NOVA's single-expression-lambda limit rather than requiring a language change
to it. (The compiler still needs closure capture across the WASM boundary — see §12.)

### Keyed list with add/remove

```nova
view todo_list
    let items: list<Todo> = []
    col
        field "New todo" -> add(items, Todo{title: it})
        list items key=.id as t
            row
                toggle t.done
                text t.title
                button "x" -> remove(items, t.id)
```

`as t` binds the row; `key=.id` gives identity; `it` is the field's current value. Reordering,
insertion, and removal are diffed by key.

### Form derived from a type — zero declaration

```nova
view employee_form
    let e = Employee{}
    form_of e                      // fields, labels, types, validation ALL derived
        on submit -> save(pool, e)
```

`form_of` reads the struct via RTTI: field names → labels, field types → input widgets and
validators, `Option<T>` → optional. **The 9-step 50-field wizard becomes a struct plus step
grouping.** This is the existing `forge_admin`/`forge_forms` pattern, generalized.

Contrast: React needs `react-hook-form` + `zod` + a 50-field JSX form + a duplicate TS interface.

---

## 6. Styling (replaces CSS) — typed, no cascade

```nova
theme light
    surface   = #ffffff
    on_surface = #1a1a1a
    primary   = #4f46e5

theme dark
    surface   = #111827
    on_surface = #f9fafb
    primary   = #818cf8

style card
    pad 16
    radius 8
    bg theme.surface
    shadow 2

style primary_btn
    bg theme.primary
    on hover    -> bg theme.primary.lighten(10)
    on disabled -> opacity 0.5
```

Applied by composition: `col.card` or `button.primary_btn "Save"`.

**Properties are typed** — `pad` takes a length, `bg` takes a color. An invalid property or unit
is a **compile error**, not a silently-ignored rule.

**Deliberately absent, and this is the feature:** no cascade, no specificity, no `!important`, no
selector matching at runtime, no global namespace. A style is a **typed value**, resolvable to a
flat constant at compile time.

The target app's 9 presets × light/dark with per-component token overrides = 18 `theme` blocks
plus per-component overrides — all type-checked, all statically resolvable.

---

## 7. L3 — Layout Engine

**Recommendation: Flutter's single-pass box-constraint model.** Constraints flow down, sizes flow
up, parent sets child position. O(n) per frame, **layout thrash is structurally impossible** (no
child can query its own final position mid-layout, so there is no read-after-write cycle).

Rejected: CSS flexbox/grid semantics (too many interacting special cases to verify),
Cassowary/AutoLayout constraint solving (superlinear, notoriously hard to debug, well-documented
performance cliffs in AutoLayout).

Must specify: intrinsic sizing, min/max constraints, baseline alignment, text-wrap interaction,
scroll viewports with virtualization.

### Bet 6 in detail — compile-time layout partial evaluation

**Analysis:** for each layout node, compute whether its constraint inputs are compile-time
constants. A node is *statically solvable* iff (a) its own style contributes only literal lengths,
(b) all children are statically solvable, and (c) no child's size depends on runtime text content
or data-driven counts. Propagate bottom-up to a fixpoint.

**Emission:** a statically-solvable subtree compiles to a **constant display list with baked
coordinates** — zero layout work at runtime, and combined with §11 island inference, potentially
zero shipped code.

**What defeats it:** any text whose content is dynamic (measurement depends on the string), any
`list` with a runtime-length collection, any percentage/fill sizing whose parent is dynamic, any
style value read from a runtime theme variable.

**Honest expected win:** most *app chrome* (toolbars, nav rails, card frames, icon rows, fixed
labels) is statically solvable; most *data regions* are not. Guess: 30-60% of nodes in a typical
enterprise screen. **Must be measured, not assumed** — this is a falsifiable claim (§18).

---

## 8. L5 — Zero-Annotation Reactivity (the hardest problem)

**Premise:** no reactive API. Any mutable value read while producing a view node becomes that
node's dependency, computed by the compiler.

### The analysis
1. Per view node, build a **read-set** (values read while producing it) and a **write-set** per
   handler, over NOVA's existing SSA/dataflow IR.
2. Propagate interprocedurally to a fixpoint (a handler calling `save()` inherits `save`'s writes).
3. Invert to a **dependency map**: value → set of nodes to invalidate.
4. Lower to patch ops at the finest provable granularity: text-node retarget > attribute set >
   subtree rebuild > full view rebuild.

### THE SAFETY RULE (must hold, or the design is dead)
> When the compiler cannot prove granularity, it must **OVER-invalidate** (merely slower) and
> **NEVER UNDER-invalidate** (silently wrong).

A silent missed update is a correctness bug users cannot diagnose, and would sink the framework.
Every fallback below resolves to *coarser invalidation*, never to *no invalidation*.

### Counterexamples and their fallbacks

| Case | Fallback |
|---|---|
| Mutation through alias / captured reference | Ownership tracking already exists; alias sets escalate to the owning binding → invalidate all nodes reading it |
| Mutation from a spawned process / channel receive | Channel boundary is an ownership transfer point → invalidate the receiving component wholesale |
| Dynamic index `items[i].name`, `i` runtime | Invalidate the *keyed row* (not the cell, not the whole list) — the key gives us row granularity for free |
| Cross-module mutation | Module-level summary: exported mutable state carries a write-set; unresolved → invalidate all readers |
| Closure stored in a dict, invoked later | Closure's write-set is known at *creation*; union into the storing component |
| Conditional mutation in an unresolvable branch | Union both branches (conservative) |
| Mutation via reflection/RTTI | **Cannot prove** → invalidate the whole component. Escape hatch of last resort. |

### The honest risk — and what must be researched before committing
Svelte 4 had implicit compile-time reactivity (`$:`) and Svelte 5 **retreated** to explicit
`$state` runes. Compose does automatic recomposition scoping and **still** needs
`@Stable`/`@Immutable` plus "strong skipping mode."

**Open question, must be answered before Phase 3 starts:** exactly what defeated Svelte's
compiler. My hypothesis is unrestricted aliasing, cross-module mutation, and dynamic property
access in a JS superset.

**NOVA's claimed structural advantages over both:** it owns its entire type system (no JS-superset
legacy), has no unrestricted aliasing, already tracks ownership for the memory model, and already
runs interprocedural dataflow in its optimizer. These are real but **narrow**. If NOVA hits the
same wall, the fallback is a *minimum-annotation* design (one opt-in marker on state the compiler
cannot track), which is still strictly better than React's four APIs.

---

## 9. L2 — The Text Stack (where own-renderer designs die)

Required: font loading/parsing, glyph rasterization, shaping (kerning, ligatures, complex scripts
at harfbuzz difficulty), bidirectional text, color-font emoji, subpixel AA, hinting, Unicode UAX
#14 line breaking, selection hit-testing, caret.

### Recommendation: per-backend native shaping + a NOVA-owned GPU glyph atlas

**Web backend — the key idea.** Rasterize glyphs using the **browser's own canvas `fillText`**
into an offscreen canvas, upload into a **GPU texture atlas**, cache by `(glyph, size, weight,
subpixel-offset)`, then draw cached glyphs as GPU quads.

- Inherits the browser's **complete** shaping, bidi, and color-emoji support **for free** — we
  never write a shaper for the web backend.
- Cost: **one boundary crossing per NEW glyph, zero for cached.** A typical app converges to a
  few hundred glyphs; steady-state text cost approaches zero.
- Risks to validate: `fillText` metrics vs. our own positioning (need `measureText` +
  `TextMetrics`), subpixel positioning quality, atlas eviction under many font sizes, and
  correctness of *our* line-breaking versus the browser's when we do the layout ourselves.

**Native backends:** DirectWrite (Windows), CoreText (macOS/iOS), harfbuzz+FreeType (Linux/Android).
Same atlas, different rasterizer. Roughly the approach Zed's GPUI takes.

**Accepted loss:** pixel-identity across platforms. **Gained:** native text quality, free complex
scripts, dramatically smaller payload than bundling a shaper (Flutter bundles everything and pays
1.5-2 MB).

**This remains the single highest-risk subsystem.** It is where I would expect schedule overrun.

---

## 10. L1/L0 — Paint and GPU

**Paint:** retained display list; damage/dirty-region tracking so only changed regions repaint;
draw-call batching by material; layer compositing for opacity/transform groups; clipping;
blur/shadow as shader effects.

**GPU abstraction:** one NOVA-level API over WebGL2 (baseline web), WebGPU (when available),
Vulkan, Metal, D3D12, plus a **CPU software rasterizer** fallback for embedded/no-GPU.

**Shaders:** the target app has hand-written GLSL. Decision needed — transpile GLSL, or design a
NOVA shader language that compiles to SPIR-V/WGSL/GLSL/MSL. *Recommendation: NOVA shader language*,
because it preserves "the developer never leaves NOVA" and gives type-checked uniforms. Defer to
Phase 5; accept raw GLSL strings for the web backend in the interim.

**Frame budget target (60fps = 16.6 ms):** reactivity/invalidation ≤1 ms, layout ≤2 ms (less with
Bet 6), text shaping ≈0 ms steady-state, paint/display-list ≤3 ms, GPU submit ≤2 ms. Leaves >8 ms
headroom. **Must be measured.**

---

## 11. Erasure and Island Inference

Apply GATE 4 to UI. A subtree is **static** iff it has no reactive dependency (§8), no event
handler, and no animation. Static subtrees compile to a constant display list and **ship zero
code**.

Astro requires hand-written `client:load` directives. Marko infers partially. **Prism infers
fully** — because it owns both the vocabulary and the reactivity analysis.

**Tree-shaking:** the widget vocabulary is a closed set, so reachability from `main` is decidable.
Ship only the widgets actually used. This is the missing piece that turns the measured 134 KB into
a target well under React's 45 KB for simple apps.

**Byte budget target (gzip):** allocator+RC ≈8 KB · scheduler ≈6 KB · widget tree ≈10 KB · layout
≈12 KB · text+atlas ≈15 KB · paint ≈12 KB · GPU backend ≈10 KB · **floor ≈75 KB**; plus only the
widgets used. Enterprise app target **≈150-250 KB** vs the React stack's ~1.5-2 MB (antd + Three.js
+ Recharts). **Must be measured; treat as a hypothesis.**

---

## 12. The Critical Path — three blockers

Nothing above works until these land.

| # | Blocker | Why fatal | Mechanism | Est. |
|---|---|---|---|---|
| **1** | **Closures across the WASM boundary** | Handlers are export-name strings today. `button "+" -> count += 1` is **inexpressible**. | WASM function table (`call_indirect`); host holds a table index, not a name. Captured environment must be RC-rooted while the node lives and dropped on node removal. | 4-8 wk **RED** |
| **2** | **Real allocator + RC on WASM (m7)** | Bump allocator **never frees** — fine for a demo, fatal for an app open 8 hours. Also closes the untagged-value soundness hole. | Compile `nova_runtime.c` → wasm32 via wasi-sdk, replacing the JS runtime. | 3-6 wk **RED** |
| **3** | **WASM in `nova_ci.ps1`** | Working browser demos are **unprotected** — they can break silently. | Add wasm build + run to the gate. | **days GREEN** |

**Blocker 2 note:** recorded as blocked on "no wasi-sdk sysroot." That is a **toolchain download**,
not a design problem, and a bundled-toolchain installer already shipped. **I believe this status is
stale — verify first; it may already be unblocked.**

**Do Blocker 3 this week regardless of the GO/NO-GO decision.** Days of work, pure downside
protection on capability that already exists.

---

## 13. Compiler Work, Itemized

| Item | Touches | Radius |
|---|---|---|
| `view` declaration form | lexer, parser, AST | YELLOW |
| Indented handler blocks | parser, closure conversion | YELLOW |
| `style`/`theme` declaration forms + typed properties | lexer, parser, TiState | YELLOW |
| Widget type hierarchy + semantic derivation (Bet 2) | TiState, RTTI | YELLOW |
| **Reactive dependency analysis (Bet 1)** | new IR pass, interprocedural | **RED** |
| **Static-subtree / island inference (§11)** | new IR pass | **RED** |
| **Compile-time layout partial evaluation (Bet 6)** | new IR pass | **RED** |
| **Closure→WASM function table (Blocker 1)** | IR, both LLVM backends, runtime | **RED** |
| **Tagged runtime → wasm32 (Blocker 2)** | nova_runtime.c, build | **RED** |
| Widget tree-shaking / DCE | IR optimize, linker | YELLOW |
| Placement/target split for full-stack channels (Bet 3) | new pass, channel typing | **RED** |
| WASM debug info / source maps | backend | YELLOW |

Every RED item requires the full arc: byte-identical reconverge (gen5 == gen6), both memory modes
(NORMAL + FULLRC), adversarial verification.

---

## 14. Build Order — do NOT go bottom-up

The instinct is L0→L7 (GPU, paint, text, layout, widgets). **Reject it.** That is ~12 months before
anything is visible, and in a layered graphics stack the worst bugs live at the **seams** — so
bottom-up discovers them last, when they are most expensive.

**Build a vertical slice first.** A counter app traversing all eight layers with the crudest
possible implementation of each: software rasterizer, one bitmap font, hard-coded layout, one
widget, no reactivity (manual repaint). Ugly, slow, **complete**.

Then deepen each layer behind a stable interface.

Payoff: something on screen in **month 2, not month 12**, and every integration seam is exercised
from day one.

---

## 15. Developer Experience (where frameworks actually die)

Non-optional, and historically underbudgeted:

- **Error messages** in NOVA's established style — point at the developer's line with a fix
  ("You read `count` on line 12 but never mutate it; did you mean `let mut`?").
- **Hot reload** — target <500 ms for a one-line view change; preserve component state across
  reload. Incremental compile is already 170 ms, so this is reachable.
- **Inspector** — we lose the browser element inspector, so we must ship our own: widget tree,
  live state, layout boxes, repaint flashing.
- **Time-travel** — free from Bet 4; expose it.
- **Stack traces / source maps** across WASM.
- **Testing** — no DOM to query, so we need a NOVA-native testing API (query the widget tree by
  role/label, synthesize events). Bet 2 makes role-based queries natural.

---

## 16. Migration and Adoption

**Elm's lesson:** ports-only JS interop was a major factor in its stall. Do not repeat it.

- **Incremental mount:** Prism must be able to render into a single element of an existing React
  app, so the target app can migrate page by page rather than by rewrite.
- **Escape hatch:** an `embed_native` widget hosting a platform view (an `<iframe>`/element on web),
  so a irreplaceable JS library remains usable.
- **First win:** rebuild ONE real page of the target app (recommend the employee list — table,
  filters, pagination, modal) and compare LOC, bundle size, and interaction latency head-to-head.

---

## 17. Effort and Staging

| Phase | Delivers | Radius | Time |
|---|---|---|---|
| **0** | Unblock: closures across boundary, m7 allocator, **WASM in CI** | RED | 2-3 mo |
| **1** | **Vertical slice** — ugly counter through all 8 layers | YELLOW | 1-2 mo |
| **2** | Real L0-L3: GPU abstraction, paint, glyph-atlas text, layout engine | YELLOW | 6-9 mo |
| **3** | L4-L5: widget core + zero-annotation reactivity + island inference | **RED** | 5-7 mo |
| **4** | L6 (30 components, **fleet-delegable**) + L7 app framework + full-stack channels | GREEN/YELLOW | 6-9 mo |
| **5** | Shader language + 3D, remaining 20 components, native backends | YELLOW | 6-9 mo |

**Total to target-app parity: ~26-39 person-months.** Solo: **2-3 years**, with Phase 4
compressible by an agent fleet under review.
**Credible v1 a real team would adopt: Phases 0-4, ~20-30 months.**

---

## 18. Falsification — what would prove this WRONG

Concrete, measurable, and to be tested at the phase boundary that first permits it:

1. **Bundle floor exceeds 300 KB gzip** for a hello-world after DCE → the own-renderer payload
   thesis fails; reconsider DOM-native.
2. **Reactivity inference requires an annotation on >10% of state** → Bet 1 collapses to
   "Svelte with extra steps"; the simplicity claim dies.
3. **Any silent missed update ships** → the safety rule (§8) is violated; halt and redesign.
4. **Compile-time layout solves <15% of nodes** in a real screen → Bet 6 is not worth its
   compiler complexity; cut it.
5. **Text rendering cannot reach native quality** on the web backend via the atlas approach →
   L2 strategy fails; the fallback (bundling a shaper) costs +300 KB and months.
6. **Frame budget exceeded** on the virtualized editable grid (>16.6 ms) → the architecture cannot
   serve the target app's hardest screen.
7. **Screen-reader support is materially worse** than the HTML version → Bet 2's central claim is
   false, and we have taken Flutter Web's punishment without its payoff.

## 19. Top Risks

| # | Risk | P × Damage | Retirement |
|---|---|---|---|
| 1 | **Text stack** underestimated | High × High | Prototype the glyph-atlas approach in Phase 1, before committing to Phase 2 |
| 2 | **Reactivity inference hits Svelte's wall** | Med-High × High | Research what defeated Svelte 5 **before** Phase 3; design the minimum-annotation fallback up front |
| 3 | **a11y worse than HTML** | Med × High | Test with a real screen reader in Phase 3, not Phase 5 |
| 4 | **Opportunity cost vs CORE_GAPS Tier 2** | High × Med | An explicit owner decision, not a drift — see §20 |
| 5 | **Closure/WASM-table mechanism fights FULLRC** | Med × High | It is Phase 0 for exactly this reason — fail fast |

**The one that kills the project if unretired: #1, the text stack.** Everything renders text.

---

## 20. The Strategic Tension (stated, not hidden)

This competes for the same months as **CORE_GAPS Tier 2** — non-scalar/float performance — which
the project's own docs call *"the real mountain."* Tiers 3-6 (exhaustive-match ADTs/interfaces,
N>1 concurrency, platform reach, toolchain) are also open.

Prism is a **2-3 year commitment**. The bets are genuinely un-copyable and the vision alignment is
far stronger than a DOM-based framework would be — *"ONE developer, ONE language, builds ANYTHING,
runs ANYWHERE"* is literally what an own-renderer UI layer delivers, and an HTML-based one
structurally cannot.

But the number is the number. This should be a deliberate owner decision, not momentum.

**Recommended immediate action regardless of the GO/NO-GO:** Blocker 3 (WASM in CI) this week, and
verify whether Blocker 2's wasi-sdk status is stale. Days of work; protects capability that
already exists and already runs in a browser.
