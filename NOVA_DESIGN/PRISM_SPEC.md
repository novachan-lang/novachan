# PRISM — Language Specification

**Status:** SPECIFICATION DRAFT v0.1
**Companions:** `PRISM_UNIVERSAL_UI_PLAN.md` (architecture) · `PRISM_ROADMAP.md` (execution) ·
`PRISM_FEATURE_MATRIX.md` (competitive position)

This is the normative document. Where the other three describe intent, this one defines behaviour.
A junior engineer must be able to implement from this without asking what a construct means.

---

# PART I — FOUNDATIONS

## 1. Design axioms

These are inviolable. Every construct below is justified against them.

| # | Axiom | Consequence |
|---|---|---|
| **A1** | **A face is a process; its output is a value; its input is a channel.** | Prism introduces no fourth primitive. The UI is the Three Primitives applied to presentation. |
| **A2** | **No annotation the compiler could infer.** | No reactive API, no dependency lists, no memo hints, no `client:`/`server:` directives, no ARIA. |
| **A3** | **Data is never markup.** | There is no string→UI evaluation path anywhere in the system. This is the root of §12's security claims. |
| **A4** | **Over-invalidate, never under-invalidate.** | When the compiler cannot prove update granularity it repaints more, never less. A silent stale pixel is a correctness bug. |
| **A5** | **Every host power is a capability value.** | A face cannot touch a resource it was not handed. Enforced by the type system. |
| **A6** | **Unprovable is not unsupported.** | Analysis failure degrades performance, never correctness or expressiveness. |
| **A7** | **The vocabulary is closed and owned.** | A finite widget set the compiler fully understands — the precondition for deriving a11y, focus, layout, and staticness (A2). |

## 2. Naming philosophy — why Prism's vocabulary is its own

Prism does **not** reuse `component`, `widget`, `div`, `Column`, `VStack`, `Text`, `Button`,
`className`, `style`, `theme`, `useState`, `onClick`, or `props`. Three reasons, in order of weight:

1. **Semantic honesty.** Prism's concepts are not the borrowed concepts. A Prism face is a
   *supervised process*, not a React component (a re-invoked function) nor a Flutter widget (an
   immutable config object). Naming it `component` would promise semantics we deliberately do not
   have — that is a lie in the API surface, and lies in vocabulary cost years of confusion.
2. **Identity.** A framework assembled from three other frameworks' nouns *is* a clone, and will be
   evaluated as one.
3. **Coherence.** Borrowed names arrive from incompatible systems with incompatible mental models
   (CSS's cascade, SwiftUI's `stack`-as-overlay, React's props-down). A vocabulary designed as one
   system is learnable as one system.

**The constraint on originality:** novelty must never cost clarity. Every name below is a common
English word whose everyday meaning matches its technical meaning. We reject invented words
(`flexbox`, `hstack`, `memo`) and abbreviations. A reader who has never seen Prism should guess
correctly more often than not.

**Test applied to every name:** *given the rendered result, would a developer guess this word?*

## 3. Reserved keywords (complete)

```
DECLARATIONS   face  look  palette  motion  wire  route  guard
ARRANGEMENT    stack band layer mesh flow pane gap
CONTENT        label art draw glyph
INTERACTION    press entry pick flag range link
STRUCTURE      each grid sheet hint tabs
BEHAVIOUR      when while on bind
BINDING        as by it self
CAPABILITY     grant needs
```

**39 keywords total** (7 declarations + 22 primitives + 4 behaviour + 4 binding + 2 capability).
For comparison, React's public surface requires learning ~30 hook and API names plus JSX plus CSS's
~500 properties plus the ARIA vocabulary.

### ⚠️ Canonical counts — corrected 2026-08-15 during MA.2 implementation

Two arithmetic errors were caught when the vocabulary was first built as real code. Recorded rather
than quietly patched, because the wrong numbers had already propagated into three other documents:

- **Primitives: 22, not 26.** Part III's tables enumerate exactly 22 (arrangement 7 + content 4 +
  interaction 6 + structure 5). `PRISM_STATUS.md` and `PRISM_UNIVERSAL_UI_PLAN.md` both said "26",
  and the plan doc listed a **Meta** group (`portal` `focus_scope` `clip` `transform` `animate`) that
  Part III never specified. **22 is canonical.**
- **Keywords: 39, not 44.**

**The Meta group is real but DEFERRED, and deliberately so** — it is not part of the foundational
vocabulary:
- `portal`, `focus_scope` — modal/a11y concerns; they belong with **semantic derivation (M3.3)**,
  where focus trapping and dismissal are already derived from `sheet`.
- `clip`, `transform`, `animate` — paint concerns; they belong with the **backends** and with
  `motion` (which is already a declaration form in §3).

Adding them later is purely additive: `PrismNodeKind` is a closed enum matched exhaustively with no
wildcard arm, so extending it is a **compile error until every match is updated** — which is exactly
the safety property axiom A7 was chosen for. Do not add them speculatively.

**Not keywords, deliberately:** anything for state, memoization, effects-with-dependencies,
placement, or accessibility. Those are inferred (A2).

---

# PART II — GRAMMAR

## 4. Lexical structure

Prism is not a separate language. It is **declaration forms added to NOVA**, sharing NOVA's lexer,
indentation rules, expression grammar, type system, and string interpolation (`"text {expr}"`).

Indentation is significant and follows NOVA's existing rules exactly. A child block is indented
relative to its parent. No braces, no closing tags.

## 5. Core grammar (EBNF)

```ebnf
prism_decl   = face_decl | look_decl | palette_decl | motion_decl | wire_decl | route_decl ;

face_decl    = "face" ident [ "(" param_list ")" ] NEWLINE INDENT face_body DEDENT ;
face_body    = { local_decl | lifecycle | node } ;
local_decl   = nova_let_stmt ;                  (* ordinary NOVA `let`; reactive by inference *)
lifecycle    = "on" life_event [ "->" expr | NEWLINE INDENT stmt+ DEDENT ] ;
life_event   = "show" | "hide" | "fail" | "load" ;

node         = node_head [ node_args ] { modifier } [ action ] [ NEWLINE INDENT node_body DEDENT ] ;
node_head    = widget_name { "." look_ref } ;
widget_name  = "stack" | "band" | "layer" | "mesh" | "flow" | "pane" | "gap"
             | "label" | "art"  | "draw"  | "glyph"
             | "press" | "entry"| "pick"  | "flag" | "range" | "link"
             | "each"  | "grid" | "sheet" | "hint" | "tabs"
             | ident ;                          (* a user-defined face, invoked by name *)
node_args    = expr { "," expr } ;
node_body    = { node | when_clause | while_clause | lifecycle } ;

modifier     = ident expr                       (* e.g. `size 14`, `align center`  *)
             | "bind" lvalue                    (* two-way binding                 *)
             | "by" selector                    (* identity for `each`             *)
             | "as" ident                       (* element binding for `each`      *)
             | "needs" capability_list ;        (* required capabilities           *)

action       = "->" ( expr | NEWLINE INDENT stmt+ DEDENT ) ;   (* default event    *)
when_clause  = "when" event_name action ;
while_clause = "while" expr NEWLINE INDENT node_body DEDENT ;   (* conditional      *)

look_decl    = "look" ident NEWLINE INDENT { look_prop | look_state } DEDENT ;
look_prop    = prop_name expr ;
look_state   = "when" state_name "->" NEWLINE? INDENT { look_prop } DEDENT ;
state_name   = "hover" | "focus" | "active" | "off" | "chosen"
             | "narrow" | "wide" | "print" ;

palette_decl = "palette" ident NEWLINE INDENT { ident "=" expr } DEDENT ;
motion_decl  = "motion" ident NEWLINE INDENT { motion_step } DEDENT ;
wire_decl    = "wire" ident "(" param_list ")" "->" type NEWLINE INDENT stmt+ DEDENT ;
route_decl   = "route" path_pattern "->" ident [ "guard" ident ] ;
```

## 6. The default-action rule

`->` binds a widget's **default event**. Each interactive widget declares exactly one:

| Widget | Default event | Payload (`it`) |
|---|---|---|
| `press` | activation (click / Enter / Space / tap) | — |
| `entry` | committed value change | `string` |
| `pick` | selection change | the chosen value |
| `flag` | toggle | `bool` |
| `range` | value settled | `int` or `float` |
| `link` | activation | — |
| `each` row | row activation | the bound element |

All non-default events use `when`. This means the 90% case (`press "Save" -> save(x)`) needs no
event name, and the remaining 10% is explicit. There is no `onClick`-style prefix convention.

**`it`** is the default event payload. **`self`** is the enclosing face's own handle.

---

# PART III — THE VOCABULARY

## 7. Arrangement primitives

Layout is **single-pass box-constraint** (constraints descend, sizes ascend, parent positions child).
This makes layout thrash structurally impossible: a child cannot query its own final position during
layout, so no read-after-write cycle can exist. O(n) per frame, always.

| Widget | Meaning | Signature | Notes |
|---|---|---|---|
| `stack` | Children along the **block** axis | `stack(children)` | Vertical in LTR/TTB scripts; the layout engine mirrors for RTL and rotates for vertical writing modes automatically |
| `band` | Children along the **inline** axis | `band(children)` | Horizontal in LTR; mirrored in RTL with no code change |
| `layer` | Children **overlaid**, later on top | `layer(children)` | Explicit z-order by source order. No `z-index` integer wars |
| `mesh` | Two-dimensional grid | `mesh(cols, children)` | `cols` accepts fixed, `fill`, or `fit` tracks |
| `flow` | Inline children that **wrap** | `flow(children)` | For tag lists, toolbars |
| `pane` | **Scrollable** viewport | `pane(child)` | Virtualizes automatically when the child is an `each` |
| `gap` | Flexible or fixed **space** | `gap()` / `gap(n)` | `gap()` absorbs remaining space |

**Why `stack` is vertical and not overlay:** the everyday meaning of "a stack of papers" is
vertical accumulation. SwiftUI's `ZStack`-as-overlay is the surprising reading. `layer` says overlay
unambiguously. This is A-2 of the naming test applied literally.

**Sizing modifiers** (uniform across all arrangement widgets): `size`, `wide`, `tall`, `least`,
`most`, `grow`, `align`, `space`.

## 8. Content primitives

| Widget | Meaning | Signature |
|---|---|---|
| `label` | Text. **Renders as glyphs, never as markup** (A3) | `label(text: string)` |
| `art` | Raster or vector image | `art(source: Image)` |
| `glyph` | Icon from a typed icon set | `glyph(icon: Icon)` |
| `draw` | Direct GPU surface — the 3D/chart escape hatch | `draw(paint: fn(Surface))` |

`draw` is how a custom-shader 3D scene enters the tree. It is a **first-class primitive**, not a
foreign integration: it receives a `Surface` with the same GPU context the rest of the frame uses.
This is why a 3D scene and a `press` cost the same architecturally.

## 9. Interaction primitives

| Widget | Meaning | Signature | Derived a11y role |
|---|---|---|---|
| `press` | Activatable control | `press(text \| child)` | `button` |
| `entry` | Text input | `entry(prompt: string)` | `textbox` |
| `pick` | Choice among options | `pick(options: list<T>)` | `combobox` / `radiogroup` |
| `flag` | Boolean | `flag(state: bool)` | `checkbox` / `switch` |
| `range` | Bounded numeric | `range(min, max)` | `slider` |
| `link` | Navigation | `link(target: Route)` | `link` |

The **derived role** column is not documentation — it is the compiler's a11y output (§13). The
developer never writes a role, and the role can never drift from the behaviour, because both come
from the same type.

## 10. Structure primitives

| Widget | Meaning | Signature |
|---|---|---|
| `each` | Keyed repetition | `each(items) by selector as binding` |
| `grid` | Tabular data | `grid(rows) by selector` |
| `sheet` | Modal surface (dialog / drawer / popover) | `sheet(child) needs exclusive` |
| `hint` | Transient overlay (tooltip) | `hint(child)` |
| `tabs` | Mutually exclusive panels | `tabs(panels)` |

**`by` is mandatory on `each` and `grid`.** A missing identity selector is a **compile error**, not
a runtime warning. React's missing-key warning is a diagnostic for a mistake Prism makes
unrepresentable.

## 11. Style: `look` and `palette`

No cascade. No specificity. No global namespace. A `look` is a **typed value**, resolvable to a flat
constant at compile time.

```nova
palette day
    ground = #ffffff
    ink    = #1a1a1a
    accent = #4f46e5
    edge   = #e5e7eb

palette night
    ground = #111827
    ink    = #f9fafb
    accent = #818cf8
    edge   = #374151

look card
    inset 16
    round 8
    fill  palette.ground
    edge  palette.edge
    lift  2
    when hover ->
        lift 4
```

Applied by composition on the node head: `stack.card`, or `stack.card.tight` to merge two looks
(later wins on conflict — a deterministic, order-based rule, not a specificity computation).

### Complete property set (v1)

| Group | Properties | Value type |
|---|---|---|
| **Space** | `inset` `outset` `space` | `Length` \| `Length×2` \| `Length×4` |
| **Size** | `size` `wide` `tall` `least` `most` `grow` | `Length` \| `Fraction` \| `Fit` |
| **Paint** | `fill` `edge` `round` `lift` `fade` | `Color` \| `Length` \| `Elevation` \| `Fraction` |
| **Text** | `ink` `font` `weight` `leading` `tracking` `case` `wrap` | typed enums + `Length` |
| **Position** | `align` `anchor` `offset` | enum + `Length×2` |
| **Behaviour** | `clip` `cursor` `pass` | enum |
| **Motion** | `ease` `over` `delay` | `Curve` + `Duration` |

Every value is **typed**. `inset "16px"` is a type error — `inset` takes a `Length`, and `16` is
implicitly device-independent pixels. `fill #gg0000` is a lexical error. **There is no way to write
a style that silently does nothing**, which is CSS's single most common failure mode.

**Deliberately absent, and this is a feature:** cascade, inheritance (except text properties, which
inherit explicitly down `stack`/`band`), `!important`, selectors, runtime rule matching, and the
entire `float`/`position: absolute`/`z-index` model. `layer` and `anchor` replace them.

---

# PART IV — SEMANTICS

## 12. Reactivity — the inference algorithm

The normative definition of Prism's central claim (A2, A4).

### 12.1 Definitions

- **Cell** — a mutable binding in a face body (`let n = 0`). Not a signal; there is no wrapper.
- **Read set** `R(node)` — the set of cells whose value is observed while producing `node`.
- **Write set** `W(action)` — the set of cells an action may mutate, transitively.
- **Dependency map** `D: Cell → Set<Node>` — the inversion of `R`.

### 12.2 Algorithm

```
PASS 1  BUILD  (intraprocedural, over NOVA's existing SSA IR)
  for each face F:
    for each node N in F's tree:
      R(N) := { cells appearing in N's arguments, modifiers, or interpolations }
    for each action A in F:
      W(A) := { cells assigned in A's body }

PASS 2  PROPAGATE  (interprocedural, to fixpoint)
  repeat until no change:
    for each call site c: f(...) inside node N:
      R(N) := R(N) ∪ summary_reads(f)
    for each call site c: g(...) inside action A:
      W(A) := W(A) ∪ summary_writes(g)
  // Summaries are computed bottom-up over the call graph.
  // Recursion and indirect calls: see 12.3 ESCALATION.

PASS 3  INVERT
  D := {}
  for each node N, for each cell x in R(N):  D[x] := D[x] ∪ {N}

PASS 4  LOWER
  for each action A, for each cell x in W(A):
    emit invalidation of D[x] at the FINEST provable granularity:
      TEXT     — x appears only in one label's interpolation  → retarget that text run
      PROP     — x appears only in one modifier value          → set that property
      ROW      — x is reached through an `each` binding         → invalidate that keyed row
      SUBTREE  — x is read by a bounded set of nodes           → rebuild that subtree
      FACE     — otherwise                                     → rebuild the face
```

### 12.3 Escalation table — the honest part

Every case the analysis cannot resolve, and its mandated fallback. **Every fallback is coarser
invalidation. None is "no invalidation" (A4).**

| # | Situation | Resolution | Granularity |
|---|---|---|---|
| 1 | Mutation through an alias | NOVA's ownership tracking maps the alias to its owning binding | unchanged |
| 2 | Mutation via a captured reference in a stored closure | `W` computed at closure *creation*, unioned into the storing face | SUBTREE |
| 3 | Mutation from a spawned process / channel receive | The channel boundary is an ownership transfer point; the receiving face is the unit | FACE |
| 4 | Dynamic index `items[i].field`, `i` runtime | The `by` selector gives row identity for free | ROW |
| 5 | Mutation across a module boundary | Module summary: exported mutable state carries a write set | SUBTREE |
| 6 | Conditional mutation, branch unresolvable | Union both branches | union of both |
| 7 | Recursive / mutually recursive faces | Fixpoint with a depth cap; on cap, escalate | FACE |
| 8 | Indirect call through a `fn` value of unknown target | Union of `W` over all functions of that type in the program | FACE |
| 9 | Mutation via RTTI / reflection | Unprovable | FACE |
| 10 | Mutation from a host callback (FFI) | The `extern` boundary carries no summary | FACE |
| 11 | Collection mutated in place (`push`, `sort`) | Container identity is the unit | SUBTREE / ROW |
| 12 | Time-based mutation (`motion`, timers) | Motion runs on the compositor; no tree invalidation at all | none needed |

### 12.4 The soundness obligation

> **THEOREM (required).** For every cell `x` and action `A` with `x ∈ W(A)`, the emitted
> invalidation set is a **superset** of the set of nodes whose rendered output depends on `x`.

Proof obligation: `R` must be an over-approximation of true reads, and `D` its faithful inversion.
Passes 1-2 must never *remove* an element on escalation — only Pass 4's granularity choice may vary.

**Test gate (roadmap M3.4):** the twelve programs in §12.3 each run under an instrumented harness
that records every rendered value and every actual dependency. **Any single silent stale value is a
release blocker**, not a bug to triage.

### 12.5 Evidence — what actually defeated the prior art (researched 2026-08-14)

The research obligation is **discharged**. The findings invert the risk assessment, and two of them
change this specification.

#### Svelte 4's sin was UNSOUNDNESS, not implicitness

Svelte 4's dependency inference was **purely syntactic free-variable collection with no call-graph
walk.** Its own docs state it: *"The dependencies of a `$:` statement are determined at compile time
— they are whichever variables are referenced (but not assigned to) inside the statement,"* and
*"a statement like this will **not** re-run when `count` changes, because the compiler cannot 'see'
the dependency."*

The canonical failure from the runes announcement:
```js
const multiplyByHeight = (width) => width * height;
$: area = multiplyByHeight(width);   // never recomputes when `height` changes
```

**Svelte 4 silently missed updates. It under-invalidated. That is the exact failure axiom A4
forbids.** Svelte did not hit a wall in static analysis — **it never attempted interprocedural
analysis at all.** The retreat was to *runtime* tracking (`$derived` evaluates dependencies when
run), and the `arr.push()` problem was fixed with deep **Proxies**, not with better analysis.

The structural cause was per-file compilation: *"the compiler only operates on one file at a time, if
another file imports `count` Svelte doesn't know that it needs to wrap each reference."* That is an
artifact of being a JavaScript build plugin. **It does not transfer to NOVA.**

#### Compose is not evidence about static dependency inference

**Compose's dependency tracking is RUNTIME.** The snapshot system records which `State` objects were
*read* inside the open recompose scope; a write invalidates that scope. The compiler contributes only
scope boundaries and skip guards (`$changed` bitmasks, slot table, positional memoization).
**Compose never attempted static dependency inference**, so it cannot be cited against it. It is
evidence about static *stability* inference — a different problem.

`@Stable`/`@Immutable` exist for two reasons, **neither an analysis limitation**:
1. **A Kotlin type-system defect** — `MutableList` implements `List`, and Kotlin has no immutable
   collection type, so a declared `List` may be mutable at runtime.
2. **Separate compilation** — *"Compose always considers unstable [types] from modules in which the
   Compose compiler does not run."* **The annotation is literally a hand-written cross-module summary.**

Both dissolve under whole-program compilation with an owned type system. And "strong skipping" moved
Compose **toward fewer annotations**: the annotation only ever chose the comparison operator
(`===` vs `.equals()`), never enabled skipping.

Critically: **Compose's default is already A4** — an unstable type is *always* recomposed. Its one
mandatory annotation is `mutableStateOf`, i.e. **on state declaration — exactly what Prism
eliminates.** Its real silent-stale hole is state that is *not* snapshot state, which invalidates no
scope anywhere.

#### Positive prior art
- **Marko 6** ships compile-time reactive graph discovery that *"transcends files"*, with automatic
  dependency detection. Annotation cost: `<let>` — **a declaration form, not a state modifier.**
  This is the closest existing proof of concept for what Prism intends.
- **Vue** shipped zero-annotation reactivity dynamically, with the annotation at the **boundary**
  (`data`/`reactive`), not on variables.
- **React Compiler v1.0** proves the analysis is tractable *even in JavaScript*: HIR + CFG →
  `InferMutationAliasingEffects` → mutable ranges → `InferReactiveScopeVariables`, whole-program,
  with the alias rule *"mutating an alias mutates the source"* — and it **bails safe** (more
  rendering, never less).
- **No academic source claims impossibility.** The literature's limit is about *restricted program
  classes*. Exact dependency inference is undecidable (it subsumes alias analysis), but **sound
  over-approximation always exists.** That distinction is the whole game.

**Verdict: nobody with a whole-program compiler and an ownership model has tried this. The wall is
unexplored, not proven.** Every documented cause traces to per-file compilation, syntactic
non-interprocedural collection, or JavaScript's total absence of aliasing information — none of which
Prism has.

### 12.6 THE REAL WALL: granularity collapse (this is not the risk we thought)

The risk is **not** unsoundness. Ownership tracking gives Prism something no JS framework has: a
mutable borrow **is** an invalidation event, and an alias is a tracked place. Soundness is reachable.

The real risk is that **over-approximation is transitively contagious.** A static read-set is the
union over all paths, all callees, all branches. Dynamic tracking gets the exact set for the path
actually taken. In a UI tree, that union tends toward *everything*: one cell read deep inside a list
item becomes a dependency of the whole page.

**If that happens, Prism has rebuilt zone.js** — and Angular abandoned zone.js for precisely this:
*"zone.js does not provide 'fine-grained' information about changes in the model… The Zone approach
isn't scalable."* Angular dropped it for **performance and predictability, not correctness**.

Two specific limits, stated plainly:

1. **Field-sensitivity is achievable; index-sensitivity is not.** `&mut model.title` narrows
   correctly. `items[i]` with runtime `i` collapses to all of `items`. **Sub-list granularity
   therefore requires a runtime keyed identity map — it cannot be purely static.**
2. **Higher-order and dynamic dispatch widen read-sets.** `list.map(f)` depends on the call graph;
   monomorphization recovers most, but closures in data structures, erased types, and interface
   dispatch force "reads everything reachable."

#### The two defenses, both now normative

**Defense 1 — `face` IS the reactive boundary.** Prism already has the right shape: the ONE
annotation that bounds over-approximation is the *render-function marker*, and `face` is already a
declaration form in this spec (§5). Its consequence is now normative:

> **A cell is reactive only within the transitive read-set of the `face` that declares it.**
> Over-approximation is bounded **per face**, not program-wide. A face is the unit of scope collapse.

This is exactly what Marko does with `<let>` and Vue does with `data` — the annotation lives at the
boundary, so there are **zero annotations on state** while over-approximation stays bounded. Prism
pays no extra keyword for this: the boundary marker is the declaration form it already needed.

**Defense 2 — runtime keyed identity for collections.** `by` (mandatory on `each` and `grid`, §10)
supplies row identity at runtime. Static analysis resolves *which collection*; the keyed map resolves
*which row*.

**Honest architectural consequence:** the achievable design is **compiler-inferred scopes + runtime
keyed identity** — which is architecturally closer to **Compose than to Svelte 4.** Prism's
advantage over Compose is real but must be stated precisely: **zero annotation on state**
(no `mutableStateOf`), soundness by default from ownership tracking, and no `@Stable` because the
type system is owned. It is not "pure compile-time reactivity with zero runtime machinery," and this
spec must not claim that.

**NOVA-specific strength no prior art has:** if a cell is process-owned and mutated only via message
passing, then **channel receive points form a complete invalidation set** — a stronger position than
any framework surveyed. Faces holding state as process state get exact invalidation for free.

#### Escalation-cycle handling (a gap in §12.3, now closed)
Over-approximated dependencies can create cycles the true graph lacks, so no valid static evaluation
order exists. **Mandated behaviour:** iterate to quiescence with a bounded iteration count; on
exceeding the bound, raise a located, actionable diagnostic (React's precedent: "Too many
re-renders"). This must never silently loop or silently stop.

### 12.7 MANDATORY: diagnostics and escape hatches

**Every system that shipped inferred reactivity also shipped an escape hatch and a diagnostic
surface** — Compose has stability reports, recomposition counts, `@NonSkippableComposable`,
`@DontMemoize`; React Compiler has `"use no memo"` and lint diagnostics.

**A developer facing a slow list with zero annotations and zero escape hatch has no move at all** —
they cannot see the inferred read-set, cannot narrow it, cannot opt out. This is a product failure
closer to what actually drove Svelte's retreat (predictability, per its own blog) than any missed
update was. Therefore, **required for v1, not deferred**:

| Requirement | Form |
|---|---|
| **Inspect the inferred read-set** | `nova prism explain <face>` prints each node's read-set, chosen granularity, and *why* it escalated |
| **Escalation warnings** | compile-time diagnostic when a face's read-set exceeds a threshold fraction of reachable state |
| **Repaint visibility** | devtools repaint flashing + per-face invalidation counts |
| **Granularity hint** (only if measurement demands it) | `fine` / `coarse` on a field. **An optimization hint that cannot change semantics — so a wrong one can never cause stale UI.** Strictly safer than Compose's `@Stable`, which can |

**Explicitly rejected:** `$state`-style per-variable annotation. Nothing in the evidence requires it
once the compiler is whole-program and tracks ownership.

### 12.8 THE FALSIFIER — the one measurement that decides Bet 1

> **Build only the dependency-inference pass. On a realistic application, measure the average
> inferred read-set per face scope as a fraction of total reachable program state.**
>
> **If it exceeds ~20-30%, granularity has collapsed into whole-tree repaint, and zero-annotation
> reactivity is not survivable at competitive performance.**

Weeks of work, not months. It is the single decision-relevant number for the entire bet, and it must
be measured **before** the full reactivity engine (M3.4) is funded. See roadmap **M1.7**.

## 13. Derived semantics — what the compiler emits with no annotation

Because the vocabulary is closed and typed (A7), each of these is a **function of the widget type**,
not developer-supplied metadata. This is the mechanism behind the a11y claim.

| Derived | Source | Emitted as |
|---|---|---|
| a11y **role** | widget kind | platform a11y node (hidden mirrored DOM on web; UIA/NSAccessibility/AT-SPI native) |
| a11y **label** | `label` child, `prompt` arg, or `art` alt | accessible name |
| a11y **state** | bound cell (`flag`'s bool, `entry`'s value, disabled) | checked / expanded / invalid / disabled |
| **focus order** | source order, mirrored under RTL | tab ring |
| **focus trapping** | `sheet needs exclusive` | modal focus scope |
| **dismissal** | `sheet` | Escape handler |
| **keyboard contract** | widget kind | `press`→Enter/Space · `pick`→arrows/type-ahead · `range`→arrows/Home/End · `tabs`→arrows |
| **hit geometry** | layout box + `pass` | pointer routing |
| **staticness** | `R(N) = ∅` ∧ no action ∧ no motion | island elision (ship zero bytes) |
| **static layout** | all constraint inputs compile-time constant | baked coordinates, zero runtime layout |

**Why HTML frameworks cannot do this:** `<div role="button" aria-pressed="true" tabindex="0">`
re-states, by hand, information the markup discarded. Nothing checks it against behaviour, so it
drifts. Ant Design ships a11y defects for exactly this reason. In Prism the role and the behaviour
have **one shared source**, so drift is unrepresentable.

**Where derivation genuinely fails** (annotation unavoidable, stated honestly): decorative-vs-meaningful
distinction for `art` (needs alt text or an explicit "decorative" marker); reading order that
intentionally differs from visual order; live-region politeness for async announcements; and
human-language tagging for screen-reader pronunciation. **Four annotations total**, versus ARIA's
entire vocabulary.

---

# PART V — SECURITY

## 14. Threat model

Prism claims to be the most trustworthy UI framework available. That claim is only meaningful
against a stated threat model with stated mechanisms.

**Assets:** user data in the face tree · secrets on the server · host resources (files, camera,
clipboard, network) · session credentials · rendering integrity.

**Adversaries:** (T1) a malicious *user* of the app · (T2) a malicious *data source* (a compromised
API, another user's stored content) · (T3) a malicious *dependency* · (T4) a network attacker ·
(T5) a malicious *page* co-resident in the browser · (T6) a malicious *asset* (font, image, shader).

## 15. Structural guarantees

These hold by construction, not by developer discipline. Each is a **deleted vulnerability class**.

### 15.1 Injection is unrepresentable (T2)
There is no HTML, no `innerHTML`, no template language, no string→UI evaluation, and no markup
parser anywhere in Prism (A3). `label(user_input)` renders the string as **glyphs**. There is no
code path from data to executable content or to structural markup.

**This is categorically stronger than escaping.** Escaping is a mitigation applied at every sink and
fails when one sink is missed — the recurring root cause of XSS. Prism has **no sink**. XSS, template
injection, and DOM-clobbering are not "prevented"; they are **not expressible**.

#### 15.1.1 The one exception, and its rules (NORMATIVE — added 2026-08-15 after adversarial testing)

`link` is the **single primitive whose payload a platform will interpret rather than display.** A
URL is not glyphs; the browser executes its scheme. So `link` is the one place the "no sink"
argument does not carry itself, and it needs explicit rules. These were derived by probing the
**accepted** set — an allowlist is only as strong as what it admits, and testing only the obvious
rejections is how this class of bug survives.

`link` takes a **typed destination** (`ExternalUrl` | `AppRoute`), never a bare string, so there is
no constructor a caller can pick to skip validation. Both variants MUST enforce:

| Rule | Rejects | Why |
|---|---|---|
| **Scheme allowlist** — `{http, https}` only, never a denylist of bad schemes | `javascript:` (any casing, with or without `//`, with leading whitespace or embedded control chars), `data:`, `vbscript:`, `file:` | A denylist is a list of the attacks you thought of. |
| **No control characters** — reject any byte `< 0x20` or `== 0x7F`, checked **before** scheme extraction | `https://example.com/` + CRLF + `X: 1` | A stored CR/LF is HTTP **response splitting** the moment a renderer or `Location:` header emits it. Browsers strip these; storing them verbatim is worse than rejecting. Checking first also stops a control char from corrupting scheme extraction. |
| **No userinfo in the authority** — reject `@` between `://` and the next `/`, `?`, or `#` | `https://example.com@evil.com/` | The browser navigates to **evil.com**; `example.com` is a username. A scheme allowlist structurally cannot catch this — the scheme really is `https`. Scope to the authority: `@` in a path (`/users/@handle`) or query (`?to=a@b.com`) is legitimate and MUST still be accepted. |
| **Route authority-escape** — an `AppRoute` must begin with exactly one `/`, where neither `/` **nor `\`** may follow | `//evil.com`, `/\evil.com` | Browsers normalize backslash to forward-slash in the authority position, so `/\` is `//` — a well-known open-redirect bypass that defeats a `//`-only check. |

**Explicitly NOT rejected:** `/redirect?next=javascript:alert(1)`. That is an in-app route whose
*query parameter* contains a string. What an application does with its own query params is not
`link`'s concern, and rejecting it would break legitimate return-URL patterns.

**Implementation note (soundness of the current check).** Prism's URL scheme extraction recognizes
only hierarchical `scheme://` forms, so an opaque scheme like `javascript:alert(1)` extracts as `""`
rather than `"javascript"`. The rejection is still sound — the allowlist denies **both** `""` and
`"javascript"` — but the code reads as though the scheme were extracted and denied, which it was
not. Recorded here so the next reader does not "fix" the extractor and assume the allowlist was
depending on it.

### 15.2 Capability-gated host access (T1, T3)
Every host power is a value that must be threaded from `main`:

```nova
face profile_editor(user: User) needs camera, files
    ...
```

A face that was not granted `camera` **cannot** open the camera — the call does not type-check.
There is no ambient authority. Contrast a browser page, where any script can call any Web API, and
a compromised dependency inherits the whole origin's authority.

Capabilities are **unforgeable** (no constructor exposed), **attenuable** (`files.read_only()`), and
**revocable** (dropping the value revokes it).

### 15.3 Secrets cannot reach the client (T4, T5)
A `Secret<T>` has **no serializer**. It cannot be encoded into a patch buffer or a wire payload.
Attempting it is a **compile error**, not a runtime redaction.

This is also the soundness argument that makes compiler-decided placement (§16) safe: the placement
analysis is *conservative for trust* — any computation whose read set contains a `Secret` is **pinned
to the server**. A wrong placement guess can therefore only cost latency, never confidentiality.

### 15.4 No deserialization attack surface (T2, T4)
The wire format is **generated from the struct declaration**. There is no dynamic deserialization,
no reflective object construction from untrusted input, no `eval`, no prototype chain to pollute.
A malformed payload fails the type check at the channel boundary and is dropped with a typed error.
Prototype pollution and insecure-deserialization classes are absent.

### 15.5 No supply chain (T3)
No npm, no `node_modules`, no transitive dependency graph, no install-time script execution.
`nova build`. The dependency-confusion, typosquatting, and malicious-postinstall classes — all
repeatedly exploited in the JavaScript ecosystem — have no surface here.

### 15.6 Memory safety under hostile assets (T6)
Font, image, and shader parsing are the classic renderer CVE surface (FreeType, libpng, libwebp).
Prism's parsers are written in NOVA: bounds-checked, no UB, no manual free. A malicious font cannot
produce a buffer overflow. **This is a direct advantage over every C/C++-based renderer**, including
Skia — and therefore over Flutter and over the browsers themselves.

### 15.7 Input-origin integrity (T1, T5)
Every event carries a provenance tag: real user input vs. programmatically synthesized.
Security-relevant actions may require genuine user origin, blocking automated self-attack flows.

### 15.8 Compositor-enforced input exclusivity (T5)
Because Prism owns the compositor, it can **prove** which face receives a pointer event.
`sheet needs exclusive` guarantees no other face receives input while it is presented. A browser
cannot make this guarantee against a malicious transparent overlay — clickjacking is mitigated by
`X-Frame-Options` at the page level, never at the widget level.

### 15.9 Deterministic rendering as attestation (T5)
Byte-reproducible output (we own the rasterizer) means a rendered frame can be hashed and attested —
"this UI displayed what the code specifies." No browser can offer this; rendering varies by version,
platform, and installed fonts.

**The mechanism, measured (2026-08-15, ahead of MA.5).** Determinism is not a hope here; it rests on
a property of NOVA I probed directly rather than assumed. A node carries `attrs: dict`, so any
renderer walks a dict to emit attributes, and dict iteration order therefore *is* emission order.
Probe result — **NOVA dicts iterate in strict insertion order**, and that order is:

- identical across separate runs of the same binary,
- identical between a dict built by successive assignment and the same keys written as a literal,
- **stable across internal resize** (verified past initial capacity at 20 keys — no rehash reordering),
- **unperturbed by overwriting an existing key** (the key keeps its original position; it does not
  move to the end).

**Consequence, and it is a binding obligation on widget authors:** byte-identical output needs **no
key sorting** in the renderer — but only because every widget constructor builds its `attrs` from a
**fixed literal key order**. A constructor that assembled `attrs` conditionally, in an order varying
with its arguments, would silently break attestation while every test still passed. Where a
constructor genuinely has two attr shapes (`gap` flexible vs fixed), each branch must itself be a
fixed literal — which is how MA.3's constructors are written.

## 16. Resource bounds — denial of service (T2)

A malicious payload must not be able to exhaust the renderer. Every limit is explicit, enforced at
the boundary, and configurable with a safe default.

| Limit | Default | Enforced at |
|---|---|---|
| Face tree depth | 256 | tree construction |
| Nodes per frame | 100,000 | tree construction |
| `each` element count | 1,000,000 (virtualized beyond viewport) | list binding |
| Layout iterations | 1 (single-pass — structurally bounded) | layout engine |
| Text run length | 64 KiB | text shaping |
| Glyph atlas | 64 MiB, LRU eviction | atlas manager |
| Image decode | 8192×8192, 128 MiB | asset loader |
| Patch buffer | 16 MiB per frame | patch encoder |
| Motion concurrency | 1,024 active tweens | compositor |
| Wire payload | 8 MiB (configurable) | channel boundary |

Exceeding a limit yields a **typed error** surfaced to the nearest `on fail` handler, never a crash
or an unbounded allocation. Single-pass layout is itself a DoS defence: no adversarial content can
induce layout thrash, because the algorithm admits no iteration.

## 17. The escape hatch, and its containment

`embed_native` hosts a platform view (an `<iframe>` on web, a native subview elsewhere). It is the
**only** untrusted-content surface in Prism and is therefore:

- **capability-gated** — requires an explicit `needs embed` grant;
- **sandboxed** — on web, `sandbox` with no `allow-same-origin` by default;
- **isolated** — no shared memory with the face tree; communication only over a typed channel;
- **visually attributed** — the compositor marks embedded regions so overlay attacks on them are
  detectable.

## 17A. The HTML emission map — Prism's first sink, and how §15.1 survives it (NORMATIVE)

Added 2026-08-15, ahead of milestone MA.5 (the server-side HTML renderer). This section exists
because MA.5 is the moment the "no sink" argument stops being free.

### 17A.1 The honest restatement

§15.1 says injection is unrepresentable because Prism has **no markup sink**. On the native GPU and
terminal backends that is literally true — there is no markup anywhere. **The HTML renderer creates
one.** Pretending otherwise would be the exact "silence in a spec is a hidden gap" failure this
project's own quality rules forbid.

The guarantee does not collapse; it changes form, and the new form is still strong — but it must be
argued, not asserted:

> On the HTML target there is **exactly one** function in the entire system that may emit a `<`, and
> the set of positions where data can reach the output is **finite and enumerable**, because the
> vocabulary is closed.

That enumerability is the whole payoff of axiom A7 (a closed 22-primitive vocabulary). Concretely,
every byte the renderer emits comes from one of five sources, and only two of them are data:

| Output position | Source | Attacker-controllable? |
|---|---|---|
| Element names | a fixed 22-entry `PrismNodeKind` → element map | **No** — enum-driven, never data-derived |
| Attribute names | fixed literals in the widget constructors | **No** — same reason |
| Structural punctuation (`<`, `>`, `/`, `=`, `"`) | the renderer itself | **No** |
| **Text content** | data | **Yes → MUST escape `&` `<` `>`** |
| **Attribute values** | data | **Yes → MUST escape `&` `<` `>` `"` `'`, and MUST always be quoted** |

A template language has an unbounded number of sinks and fails when one is missed. Prism has two,
both in one file. That is the difference worth defending, and it is defensible only as long as the
element and attribute-name maps stay enum-driven.

### 17A.2 Binding rules for MA.5

1. **No `<script>`, no `<style>`, no `<iframe>`, no `<object>`, no `<embed>`, ever.** No entry in the
   kind map may produce one. This is structural, not a filter: those elements have no primitive.
2. **No event-handler attributes.** Prism never emits `onclick=` or any `on*`. Interactivity is bound
   by the runtime against node identity, not smuggled through markup. An `on*` attribute appearing in
   output is a defect, not a feature.
3. **No comments and no CDATA.** `<!--` never appears; there is no context for it to be escaped in.
4. **Attribute values are always double-quoted**, without exception. Unquoted attribute values make
   a space or `>` in data a structural break, which no amount of entity-escaping fixes.
5. **`href` is emitted only from a destination already validated per §15.1.1.** The renderer does not
   re-validate and must not be the place that first decides a URL is safe — but it still
   attribute-escapes, because escaping and allowlisting answer different questions.
6. **External links carry `rel="noopener noreferrer"`.** Without `noopener` the opened page gets a
   live `window.opener` handle back into the origin — a tabnabbing vector that has nothing to do with
   the URL being on the allowlist.
7. **`draw` renders a placeholder server-side.** Its `paint` callback is client-side by nature; the
   server emits the element and no script.
8. **Determinism.** Attribute emission order is `attrs` insertion order (§15.9). No key sorting; no
   run-varying order.

### 17A.3 The map (all 22)

`each` deliberately emits **no wrapper element** — a wrapper would break the parent's layout
contract, and it is unnecessary because MA.3's `each` already attaches the identity key to each row
node, so the key rides on the row rather than on a container.

| Primitive | Element | Derived a11y / attrs |
|---|---|---|
| `stack` | `div` | block axis |
| `band` | `div` | inline axis |
| `layer` | `div` | overlay; later children paint on top |
| `mesh` | `div` | grid tracks from `cols` |
| `flow` | `div` | wrapping inline |
| `pane` | `div` | scroll viewport |
| `gap` | `div` | `aria-hidden="true"` — a spacer is not content |
| `label` | `span` | text content, escaped |
| `art` | `img` | `alt` derived per §13 |
| `glyph` | inline `svg` | `aria-hidden="true"` when decorative; from the closed icon set |
| `draw` | `canvas` | placeholder server-side (rule 7) |
| `press` | `button` | `type="button"` — never a bare `div` with a handler |
| `entry` | `input` / `textarea` | `type` from `PrismEntryKind`; `aria-label` from `prompt` |
| `pick` | `select` + `option` | `aria-label` |
| `flag` | `input type="checkbox"` | `aria-label` |
| `range` | `input type="range"` | `min` `max` `step` `value`, `aria-label` |
| `link` | `a` | validated `href`; `rel="noopener noreferrer"` when external |
| `each` | *(none — children in sequence)* | key rides on each row node |
| `grid` | `table` / `tr` / `td` | `role="table"` |
| `sheet` | `dialog` | `aria-modal` when `exclusive` |
| `hint` | `span` + `role="tooltip"` | `aria-describedby` wiring |
| `tabs` | `div` | `role="tablist"` / `role="tab"` / `role="tabpanel"` |

### 17A.4 What would prove this section wrong

A renderer that passes every escaping test but emits an element name derived from data; an `on*`
attribute reaching output by any path; a primitive added later whose element is chosen by a string
rather than the enum. Each would move a position out of the "not attacker-controllable" column, and
the argument in 17A.1 would no longer hold.

---

## 18. Known limitations (stated, not hidden)

| Limitation | Status |
|---|---|
| **Timing side channels** — render time may correlate with secret content length | Mitigated for `entry` in password mode (constant-time layout path). Not solved generally. |
| **GPU driver bugs** | Out of our trust boundary. Software fallback available. |
| **Screenshot / screen-recording by other apps** | OS-level, outside scope. |
| **The `embed_native` surface** | Contained (§17), never eliminated. |
| **Shader compilation on untrusted GLSL** | Only the app author's shaders are accepted; user-supplied shaders are unsupported in v1. |

---

# PART VI — WORKED EXAMPLES

## 19. Counter — the full round trip

```nova
face counter
    let n = 0
    stack.card
        label "Counted {n} times"
        band
            press "Add"   -> n += 1
            press "Clear" -> n = 0
```

Compiler output: `R(label) = {n}`, `W(press "Add") = {n}`, `D[n] = {label}` →
granularity **TEXT**. A click emits **one** patch opcode retargeting one text run. `press` nodes are
static (`R = ∅`) → their geometry is baked at compile time (§13). Derived: role `button`, Enter/Space
activation, tab order, accessible names.

## 20. List with identity

```nova
face task_list(tasks: list<Task>)
    stack
        entry "New task" -> add(tasks, Task{title: it})
        each tasks by .id as t
            band.row
                flag t.done -> toggle(tasks, t.id)
                label t.title
                press "×"   -> drop(tasks, t.id)
```

`by .id` is mandatory. Mutating `t.done` escalates to **ROW** (§12.3 case 4) — one row repaints, not
the list. `pane` is unnecessary here; wrapping in `pane` would virtualize automatically.

## 21. Form derived from a type, hitting the database

```nova
wire save_employee(e: Employee) -> Result<Id>
    orm_insert(db, "employees", e)

face employee_form
    let e = Employee{}
    stack
        form_of e                       // fields, labels, widgets, validators — all derived
        press "Save" -> save_employee(e)
        on fail -> label "Could not save: {it.message}"
```

`form_of` reads `Employee` through NOVA's RTTI keystone: field names → labels, field types →
widgets and validators, `Option<T>` → optional. **Zero field declarations.** `Employee` is declared
**once** and is simultaneously the ORM row, the wire payload, the client model, and the form schema
— a rename is a compile error on both sides of `wire`.

The React + Django equivalent requires: a TypeScript interface, a Django model, a DRF serializer, a
zod schema, and ~50 lines of JSX — five declarations of one entity, verified by nothing.

---

# PART VII — OPEN QUESTIONS

Recorded honestly; each blocks a specific roadmap milestone.

| # | Question | Blocks | Resolution |
|---|---|---|---|
| 1 | What exactly defeated Svelte 5's implicit reactivity and forced Compose's `@Stable`? | M3.4 | **Research before Phase 3.** Days of work, de-risks 12 weeks |
| 2 | Can `fillText`-into-atlas reach native text quality, and what are its metric fidelity limits? | M2.3 | Prototype in Phase 1 |
| 3 | Is compiler-decided client/server placement (§16) achievable, or must it reduce to an annotated form? | M4.3 | Design spike; the annotated form is the accepted fallback |
| 4 | Closure-across-WASM lifetime under FULLRC — does the function-table + RC-root design hold? | M0.4 | Phase 0, deliberately first |
| 5 | What fraction of a real screen's nodes are statically layout-solvable? | Bet 6 value | Measure on a tiger1 page in Phase 2 |
| 6 | Does `look` merge order (later-wins) cover real theming needs without a cascade? | M3.2 | Validate against tiger1's 9 presets |
| 7 | Minimum viable capability set for v1 | §15.2 | Enumerate during Phase 3 |

---

**Normative status:** Parts I-V are binding. Part VI is illustrative. Part VII must be emptied
before v1.0 is declared.
