# NOVA WEAPON PARITY PLAN — Every Language Feature, 100% Complete

> **Created:** 2026-08-20 · **Purpose:** Close every gap vs C/C++/Rust/Go/Erlang/Python/JS.
> **Rule:** Nothing is "done" until it works cross-module, at scale, both modes, in real framework code.
> **Ecosystem (Java ecosystem scale, npm scale) is OUT OF SCOPE — decade-scale, can't solo.**

---

## PHASE 1 — SOUNDNESS (blocks everything else)

| # | Feature | From | Effort | Status |
|---|---------|------|--------|--------|
| 1.1 | Cross-module exhaustiveness (E1009) | Rust | S | **✅ DONE 2026-08-20** |
| 1.2a | Cross-module **enum variant** constructors | Rust | S | **✅ DONE 2026-08-20** |
| 1.2b | Cross-module **plain struct** constructors | Rust | S | **✅ DONE 2026-08-20** |
| 1.3 | Cross-module default params | Rust/Python | M | **✅ DONE 2026-08-20** |
| 1.4 | Field-slot collision → sound resolution | Rust | **M** (was S) | MEASURED + DESIGNED, not implemented |
| 1.5 | `?` in lambda silent corruption | Rust | M | **✅ CLOSED (fail-closed) — gated 2026-08-20** |
| 1.6 | null ≠ 0 (indistinguishable) | All | L | TODO |
| 1.7 | RC cycle collector (Tier 4.7) | Rust/Erlang | L | DESIGNED |
| 1.8 | Reject a non-defaulted param AFTER a defaulted one | Python/C++ | S | FOUND 2026-08-20, pre-existing |
| 1.9 | Variadic (`T...`) + named args across the module boundary | Python | S | FOUND 2026-08-20, pre-existing |

### 1.8 Defaults must be trailing — currently unenforced (found while doing 1.3)

Nothing in the parser or checker rejects `fn f(a, b = 5, c)`. The arity logic — **same-file and
cross-module alike** — counts params with no default, so `min_arity` is 2 (`a` and `c`). A call
`f(x, y)` therefore passes the arity check, `y` binds **positionally to `b`**, and `c` is padded
with a fresh type var that no default can fill. Python raises `SyntaxError` for this at def time and
C++ rejects it at declaration; NOVA silently accepts it.

Not introduced by 1.3 (the same-file path has always counted this way) and not exercised by any
current code, so it is a latent hole rather than a live bug. Fix: at `tag == "fn"` registration,
error once a defaulted param is followed by a non-defaulted one. Cheap and self-contained; deferred
only to keep the 1.1–1.3 commit's blast radius to what CI actually verified.

### 1.9 Variadic + named args still don't cross the boundary (found while doing 1.3d)

The same-file IR call path does three things in order before emitting the call: **named-arg
reordering** (~12072), **variadic rest-packing** (~12126), then **default padding** (~12152). The
module-qualified path (~12379) had none of the three; 1.3d added only the third. So
`mod.f(1, 2, 3)` on a variadic `fn f(a, rest: int...)` does not pack the tail into a list, and
`mod.f(b: 2, a: 1)` is not reordered.

Both were equally broken before 1.3d — this is a pre-existing gap, not a regression, and CI green
confirms nothing currently relies on either. The clean fix is to **extract the three-step actual-
argument normalization into one shared function** and call it from both paths, rather than adding a
third divergent copy. That refactor is exactly what would have prevented 1.3 from being four
separate bugs, so it is worth doing properly rather than patching in place.

### ✅ 1.1–1.3 landed — one root cause, four separate registration gaps

All three holes had the SAME root cause: `ti_infer_program_named`'s import scan processed
**only** `mtag == "fn"`. Everything an imported module declared that was not a function was
invisible to the type checker. Fixes, all in `nova_compiler.nova`:

| Fix | Site | Change |
|---|---|---|
| 1.1 + 1.2a | TI import scan (~19434) | Added `mtag=="enum"` + `mtag=="type"` branches: register `ti_variant_enum`, `ti_enum_variants`, `ti_variant_ptypes`, `ti_structs` (per variant) and `ti_define` the variant constructor — mirroring the same-file pre-pass |
| 1.3a | TI import scan (~19421) | `ti_min_arity` was hardcoded `len(mparams)`; now counts only params with NO default. Also written under a **module-qualified** key (`alias + "." + name`) so a same-file fn of the same name cannot clobber it |
| 1.3b | TI module-call path (~17934) | The `mod.f(args)` branch unified the arrow types directly with no arity padding; now pads actuals with fresh vars up to the callee's full arity, exactly like the bare-call path |
| 1.3c | IR `compile_module_ir` (~27664) | `b.ir_fn_defaults[name] = params` was never written for imported fns |
| 1.3d | IR module-call path (~12386) | Pads `arg_regs` with each omitted param's **lowered default expression** |

**Still owed on 1.3 — the dogfood step.** Per the 100%-complete rule, a feature is not done until
real framework code uses it. Nothing in `forge/`/`prism/`/`std/` uses a cross-module default yet,
because every one of those APIs was written under the old constraint (full arity, or `T?` + match —
`prism_gap()` is the canonical example: the spec wanted both `gap()` and `gap(n)` and got `int?`
instead). Converting one real API and re-running the gate is what turns 1.3 from "proven by probe"
into "proven in production". Do NOT mass-rewrite existing APIs — `T?` is still better typing when
"absent" is genuinely part of the domain; pick one API where the default is the honest signature.

**The 1.3c/1.3d lesson — why value assertions are mandatory.** The first cut fixed only the type
checker (1.3a+1.3b). The program then compiled clean, linked, ran, and exited 0 — while printing
`", World"` for `greet("World")` and `1` for `add(1)` (correct: `"Hello, World"` and `111`),
because IR still passed 0/null for every omitted argument. **A loud E1003 had become a silent
wrong answer** — strictly worse than the original bug. An exit-code-only gate is green for that.
Gated by `_xm_soundness_gate.ps1` (CI stage 2k2), which asserts all 7 output values exactly, plus
`_xm_exhaustive_neg.nova` in `_neg_type_tests.ps1` (stage 2k) for the E1009 rejection.

### ✅ 1.2b Cross-module plain-struct constructors — landed

The import scan's `mtag == "type"` branch registered the struct's **field map** but not a
**constructor**. The same-file path (~18590) does both:

```
st.ti_structs[name] = field_map                                  // <- import scan did this
let ctor_type = nt_fn(field_types, nt_struct(name))              // <- and NOT this
ti_define(st, name, ti_generalize(st, ti_zonk(st, ctor_type)))
```

So `mod.make_point(1,2)` (wrapper) and `XmRed(7)` (enum variant) worked, but a bare `Point(1,2)` on
an imported struct was `E1002`. **Fixed** by mirroring those lines, with generic type params
threaded through a `ti_extract_generics(man)` map so `type Box<T>` gets a polymorphic ctor
(`ti_generalize`) and a plain struct stays monomorphic (`ti_mono`).

**IR needed no change** — `compile_module_ir` already registered `ir_sdefs` for imported types, so
construction lowered correctly the moment TI stopped rejecting it. That matches the diagnosis:
`E1002 unknown identifier` is a *type-checker* error, so TI was the only blocker. Verified by
value: `struct=11/22` (bare ctor + field reads) and `wrapper=11/22` (existing route unchanged).

**Deliberately did NOT add `ti_min_arity` for ctors.** A first cut set
`ti_min_arity[name] = len(mparams)`. Removed: the same-file handler sets none, so a wrong-arity ctor
call is reported by unification in both cases. Adding one would give imported ctors a *different
diagnostic* than same-file ones, and would be outright wrong if struct fields ever gain defaults.
**Parity with the same-file path is the fix** — every divergence is a future bug, which is the whole
lesson of 1.1–1.3.

**Consequence worth noting:** the long-standing rule "one wrapper fn per constructor, in the
declaring file" is now obsolete for both enums and structs. `prism_node.nova` alone ships 22 such
wrappers, and `prism_arrange`/`prism_content`/`prism_interact`/`prism_structure` each ship their
own. They still work and are not worth a mass deletion, but new multi-module types no longer need
them — which removes the single biggest piece of ceremony in Prism's module layer.

### 1.4 Field-slot collision — measured, and it is NOT the small fix it looked like

`ir_fmap` is a flat `field_name → slot` map with no struct qualification. Last writer wins, so any
**untyped** `.field` access reads whatever slot that name last resolved to.

**Measured blast radius** (static audit of every `type`/`enum` block; slot 1-based, `@repr(C)` 0-based):

| Tree | struct/enum blocks | distinct field names | genuinely ambiguous |
|---|---|---|---|
| `forge/` + `prism/` + `std/` | 166 | 325 | **15** |
| `nova-compiler/compiler/` | 21 | 195 | 8 |

Worst offenders are the hottest types in the framework:
- `body` → **4 distinct slots**: `Response`@3, `MpPart`@4, `Request`@7, `PgMsg`@2
- `path` → 3: `AppRoute`@1, `Request`@2, `WsConn`@3
- `value` → 3 · `kind` → `PrismNode`@1 vs `XlsxCell`@3 (the one that crashed the HTML renderer)
- plus `name`, `data`, `params`, `headers`, `payload`, `state`, `conn`, `message`, `rows`, `label`, `leftover`

**Why the compiler itself is immune** despite 8 ambiguous names (`Stmt.name`@2 vs `Param.name`@1,
`Expr.value`@2 vs `IrInst.value`@5): it destructures with `match Stmt(tag, name, ...)`, which binds
**positionally from the pattern** and never consults `ir_fmap`. forge/prism use dot-access heavily.
So this bug is invisible to reconverge — the deepest gate we have cannot see it.

**Rejected fix — "on collision return 0".** Tried and reverted. With `A{shared@1,x@2}` and
`B{y@1,shared@2}`, `ir_fmap[shared]=2`, so an untyped access on a `B` receiver is currently
**correct by luck**; forcing 0 makes it read the type-hash slot and breaks working code. It trades
one silent corruption for a broader one.

**Correct design.** Only 2 of the 4 `get_ir_field_index_for` call sites can reach the ambiguous
fallback (12523 and 12607 pass a known struct type):
- **Read** (~12685, `recv_stype == ""`): emit `call @nova_rt_field_get(obj, "name")`. That runtime
  fn already resolves by name against the object's actual slot-0 type hash via
  `nova_struct_meta_fname`, and re-boxes float/bool correctly. Always right, no new runtime code.
  This is also the precedent the codebase already set at ~12533 for un-inferrable closure-field calls.
- **Write** (~14429, `mstype == ""`): `nova_rt_field_set(val, **slot**, ...)` is slot-based, so this
  needs a NEW `nova_rt_field_set_by_name` in `nova_runtime.c` — a runtime ABI addition, hence RED
  tier and its own full arc. This is what re-rated 1.4 from S to M and why it is not in the 1.1–1.3
  commit. It must **delegate** to `nova_rt_field_set` after resolving the name, never re-implement
  it: that function carries the managed-slot bitmap check, the arena-bit bypass, and the inc-NEW-only
  rule (it deliberately does *not* dec the old value, because NOVA field reads are borrow-based and
  dec'ing would free a live un-counted borrow in the `saved = obj.f; obj.f = new; obj.f = saved`
  idiom — the self-compile reconverge caught exactly that). A second copy is a second place to drift.

**Design dead-end, recorded so it is not re-attempted.** The tempting minimal fix is a *sentinel
slot*: have `get_ir_field_index_for` return `-1` when ambiguous, and let both backends' `field_get`/
`field_set` handlers emit the by-name runtime call on `-1`. That would leave all four call sites
untouched and auto-cover future ones. **It does not work:** the by-name call needs the field name as
an i64 string pointer, and string literals are interned into `ir_strlits`/`ir_strmap` during IR
*lowering* — the backend cannot mint a new constant at emit time. So the change must happen at the
two lowering sites, materializing the name with `ir_lower_expr(b, Expr("str", value, 0, [], [], 0))`
— exactly the pattern already used at ~12538 for the un-inferrable closure-field call.

**Perf note, and the staged answer.** An immediate-slot `field_get` is one load; `nova_rt_field_get`
is a call plus a `strcmp` walk over the field list — call it 20–50× for that access. Acceptable,
because it fires *only* where the current code is silently wrong, and "slower and right" beats "fast
and wrong". If the perf gate ever flags it, the faster fix is available without changing semantics:
the compiler knows every candidate struct for an ambiguous field name, so it can emit an inline
slot-0 type-hash dispatch (compare hash, then use that struct's immediate slot) instead of a runtime
string walk. Ship the correct version first; optimize only on evidence.

### 1.1 Cross-module exhaustiveness
**Root cause:** `ti_infer_program_named` import scan (19357–19434) only processes `mtag=="fn"`.
Never reads `mtag=="enum"` → `ti_enum_variants`/`ti_variant_enum` empty for imported enums.
**Fix:** In the import scan loop, add `mtag=="enum"` branch that mirrors 19478–19494:
```
if mtag == "enum"
    // register variant→enum and enum→variants exactly like the pre-pass at 19478-19494
    st.ti_variant_enum[vname] = name
    st.ti_enum_variants[name] = variant_names
```

### 1.2 Cross-module enum constructors
**Root cause:** Same as 1.1 — `ti_variant_enum` not populated for imports.
**Fix:** Same code block as 1.1. Once `ti_variant_enum` has the imported enum's variants,
`ti_infer_pattern` (18907/18953/18971) will correctly resolve `Ok(x)` / `Some(v)` patterns
on imported enums, and `ti_check_exhaustive` (19014–19036) will see them.

### 1.3 Cross-module default params
**Root cause (TI):** Line 19418 sets `st.ti_min_arity[mname] = len(mparams)` (full arity).
The same-file path (18507–18515) computes `min_ar` by counting params with non-null defaults.
**Root cause (IR):** `compile_module_ir` (27568–27632) never writes `b.ir_fn_defaults[fn_name]`.
**Fix (TI):** In import scan, count defaulted params: `if param.default != null_expr() then min_ar stays`.
**Fix (IR):** In `compile_module_ir`'s `tag=="fn"` branch, add `b.ir_fn_defaults[fn_name] = params`.

### 1.4 Field-slot collision
**Root cause:** `ir_fmap` is flat `field_name → slot` (24844/27702 write, 12513/13017 read).
Last-registered struct wins. Two structs with field `kind` at different slots → silent corruption.
**Fix:** At write sites (24844/24857/27702/27715), detect collision:
```
if contains(b.ir_fmap, pname) and b.ir_fmap[pname] != fi
    // Different slot for same field name — flag it
    b.ir_fmap_collision[pname] = true
```
At read site (13017 `get_ir_field_index`), if `ir_fmap_collision[field_name]` is true AND we're
on the untyped path, emit a compile error: "ambiguous field '{name}' — multiple structs define it
at different positions. Use typed access or prefix the field name."

### 1.5 `?` in lambda — already closed in the compiler; the GAP was that nothing gated it

**Verified against live code 2026-08-20, and the earlier root-cause note above was wrong.** `?`
lowers to a `return` of the ctx-wrapped error (`ir_lower_expr`, `tag == "try_unwrap"`, ~12740).
Inside a lambda that `return` leaves **the lambda**, not the enclosing fn — which is exactly Rust's
closure semantics. The corruption came from the next step: NOVA's `map` is not Result-aware and
there is no `collect::<Result<Vec<_>>>` equivalent, so the error struct became an ordinary list
element. Compiled clean, ran, wrong data.

`ti_infer_expr`'s `tag == "lambda"` branch (~18155) already rejects this with a message naming
three alternatives (explicit loop with `?`, `prism_ui_collect`, or `map` + `any_match(is_err)` +
`map(unwrap)`). **But no test covered it** — a refactor of lambda inference could have dropped the
check and silently reinstated the corruption. Now gated: `_negty_qmark_lambda.nova` in
`_neg_type_tests.ps1`.

This is a **fail-closed** resolution, not the "compiler is the genius" one. The ideal — `map(fn(x)
f(x)?)` short-circuiting and yielding `Result<list>`, which would beat Rust's mandatory turbofish
`collect` — requires making the core HOFs Result-aware. That is a real semantic fork (a list may
legitimately hold error values, and NOVA cannot distinguish `null` from `0`; see 1.6), so it is
deliberately NOT bundled here. Tracked as a Phase 2 candidate.

### 1.6 null ≠ 0
**Root cause:** NOVA represents null as integer 0. `null == 0` is true. Type-tag check can't
distinguish. Fundamental representation issue.
**Fix:** Reserve a sentinel value (e.g., a specific tagged pointer or a dedicated null tag bit)
that is distinct from integer 0. This affects the entire runtime. Deferred — needs careful design.

### 1.7 RC cycle collector
**Root cause:** Circular references (A→B→A) leak. Confirmed Tier 4.7.
**Fix:** Epoch-based cycle detector (designed in CORE_GAPS). Trial-deletion algorithm.
Runs periodically or on suspected cycles. Deferred — needs careful implementation.

---

## PHASE 2 — EXPRESSIVENESS (what makes code powerful)

| # | Feature | From | Effort | Status |
|---|---------|------|--------|--------|
| 2.1 | Nested pattern matching `Ok(Some(x))` | Rust/Haskell | M | TODO |
| 2.2 | Pattern guards `x if x > 0` | Rust/Haskell | S | TODO |
| 2.3 | Operator overloading (trait-based) | C++/Rust/Swift/Kotlin | M | TODO |
| 2.4 | RAII / drop trait (scope-exit cleanup) | C++/Rust | M | TODO |
| 2.5 | Extended @comptime (full language at compile time) | Zig/C++ | L | TODO |
| 2.6 | Generics proven in framework code | C++/Rust/Swift | M | TODO |
| 2.7 | Error message suggestions ("did you mean X?") | Python/Rust/Elm | S | TODO |
| 2.8 | Move semantics / move(x) builtin | C++/Rust | M | TODO |

### 2.1 Nested patterns
Parser: recursive `parse_pattern` that handles `Ctor(pattern)` not just `Ctor(var)`.
Codegen: nested destructuring — extract outer, then extract inner.

### 2.2 Pattern guards
Parser: after pattern, accept `if <expr>`. Codegen: emit guard condition check, fall to next arm if false.

### 2.3 Operator overloading
Define operator traits: `trait Add<T> { fn add(self, other: T) -> T }` etc.
Type inferrer: on `a + b`, check if type(a) conforms to `Add<type(b)>`.
Codegen: emit method call instead of builtin op.
~200-300 lines compiler.

### 2.4 Drop trait
Compiler pass: at scope exits, for values whose type declares `fn drop(self)`, emit the call.
This replaces/extends `defer` for resource cleanup.

---

## PHASE 3 — PERFORMANCE (match C, beat Python 100x)

| # | Feature | From | Effort | Status |
|---|---------|------|--------|--------|
| 3.1 | Float/array perf 1.7x → 1.0x C | C | L | S4.2 shipped, extend |
| 3.2 | SIMD / @simd annotation | C/C++/Rust | M | TODO |
| 3.3 | Verify generics monomorphize to zero-cost | C++ | S | TODO |
| 3.4 | Buffer views (read-only, no copy) | C/Rust | M | TODO |
| 3.5 | Process-scoped arena allocators | C/Zig | M | TODO |
| 3.6 | @stack hints for stack allocation | C/Zig | S | TODO |

---

## PHASE 4 — CONCURRENCY (match Go, approach Erlang)

| # | Feature | From | Effort | Status |
|---|---------|------|--------|--------|
| 4.1 | N>1 concurrency fix (scheduler lock) | Go | L | REGRESSED |
| 4.2 | Work-stealing between carriers | Go/Java FJP | L | TODO |
| 4.3 | Preemptive scheduling (yield at loop back-edges) | Erlang | M | TODO |
| 4.4 | Supervision trees (library) | Erlang | S | TODO |
| 4.5 | Small fiber stacks (4KB initial, grow on demand) | Erlang | M | TODO |
| 4.6 | nova watch (fast restart < 0.5s) | Erlang/Go | S | TODO |
| 4.7 | Distributed channels (network transport) | Erlang | XL | TODO |

---

## PHASE 5 — PLATFORM REACH (run everywhere)

| # | Feature | From | Effort | Status |
|---|---------|------|--------|--------|
| 5.1 | Linux native build | Go/Rust/all | M | WSL-once exists |
| 5.2 | macOS native build | Swift/all | L | needs hardware |
| 5.3 | WASM compilation target (LLVM wasm32) | JS/Rust | L | TODO |
| 5.4 | Cross-compilation (target triple param) | Go/Zig/Rust | M | TODO |
| 5.5 | Single-command toolchain (bundle clang) | Go/Zig | M | TODO |
| 5.6 | Prism → Canvas/WebGL for browser | JS | XL | TODO |
| 5.7 | ARM/AArch64 native | Go/Rust/all | L | needs hardware |

---

## PHASE 6 — TOOLCHAIN (developer experience)

| # | Feature | From | Effort | Status |
|---|---------|------|--------|--------|
| 6.1 | AST-based formatter (real nova fmt) | Go/Rust | M | whitespace-only exists |
| 6.2 | REPL polish (multi-line, completion, history) | Python | S | basic exists |
| 6.3 | Debugger integration (nova debug) | All | L | DWARF emitted |
| 6.4 | Linter / nova lint | Rust clippy | L | TODO |
| 6.5 | Wire package manager CLI | Go/Rust/Python | S | resolver built |

---

## PHASE 7 — SAFETY HARDENING

| # | Feature | From | Effort | Status |
|---|---------|------|--------|--------|
| 7.1 | Inline asm / LLVM IR blocks | C/Zig | M | TODO |
| 7.2 | C header import (extern fn auto-gen) | Zig | L | manual extern exists |
| 7.3 | @cdecl improvements | C/Rust | S | basic exists |
| 7.4 | unsafe {} blocks for raw pointer work | Rust | M | TODO |

---

## STRUCTURALLY IMPOSSIBLE (by design — NOVA's trade-offs)

These are NOT gaps to close. They're design choices that define what NOVA IS.

| Feature | From | Why NOVA doesn't have it | What NOVA offers instead |
|---|---|---|---|
| Manual malloc/free | C | Breaks safety-by-default thesis | RC + arenas + @stack = predictable, safe |
| Explicit allocator params | Zig | Contradicts zero-annotation goal | Implicit RC + escape analysis |
| Lifetime annotations | Rust | Contradicts simplicity goal | Process isolation + RC |
| Apple platform integration | Swift | Needs Apple cooperation | Cross-platform via WASM/Prism |
| JVM bytecode target | Java/Kotlin | Different compilation model | Native AOT via LLVM |

---

## EXECUTION ORDER (dependency-aware)

**NOW (Phase 1.1-1.5):** Cross-module soundness → reconverge → CI → commit
**NEXT:** Phase 2.1-2.3 (nested patterns + guards + operator overloading)
**THEN:** Phase 4.1-4.3 (N>1 concurrency + preemption)
**THEN:** Phase 3.1-3.2 (float perf + SIMD)
**THEN:** Phase 5.1-5.5 (platform reach)
**THEN:** Phase 6 (toolchain polish)
**THEN:** Phase 7 (safety hardening)
