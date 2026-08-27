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
| 1.4 | Field-slot collision → sound resolution | Rust | **M** (was S) | **✅ DONE 2026-08-20** + both refinements applied `3a8e64a1` |
| 1.5 | `?` in lambda silent corruption | Rust | M | **✅ CLOSED (fail-closed) — gated 2026-08-20** |
| 1.6 | null ≠ 0 (indistinguishable) | All | L | **✅ DONE 2026-08-27** — null-as-*value* `a7e5fc76`; null-as-*absence* cause FOUND (`nova_rt_truthy` returned 1 for a NULL box) + absent-reader builtins. Gate `_null_absence_gate` 5/5, CI 2m |
| 1.7 | RC cycle collector (Tier 4.7) | Rust/Erlang | L | **✅ DONE 2026-08-27** — detector `2026-08-23` (`NOVA_CYCLE_DETECT`, SCC-based, CI 2k6) + **collector now closed**: exit reclamation and proof-gated `cycle_collect()`. Gate `_cyc_collect_gate` 7/7, CI 2m2 |
| 1.8 | Reject a non-defaulted param AFTER a defaulted one | Python/C++ | S | **✅ DONE 2026-08-20** `3a8e64a1` |
| 1.9 | Variadic (`T...`) + named args across the module boundary | Python | S | **✅ DONE 2026-08-20** `3a8e64a1` |

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

### ✅ 1.4 Field-slot collision — LANDED. Reproduced first, then fixed, reads and writes

**Reproduced before fixing** (`_xm_slot_probe.nova`, two modules, `xs_shared` at slot 1 in `XsAlpha`
and slot 3 in `XsBeta`):

| | pre-fix | post-fix |
|---|---|---|
| `typed_a` / `typed_b` | 1 / 3 ✓ | 1 / 3 ✓ (control — receiver type known) |
| `untyped_a` | **300** ✗ read `xs_a_three` | **1** ✓ |
| `untyped_b` | 3 ✓ **by luck** (XsBeta registered last) | 3 ✓ still right |
| `wrote_a` / `wrote_b` | — | 91 / 93 ✓ |
| `intact_a` / `intact_b` | — | 300 / 10 ✓ neighbours not clobbered |

Compiled clean, exited 0, wrong data — exactly the `body`→4-slots situation in forge. The asymmetry
(`untyped_b` correct, `untyped_a` not) is the concrete proof that the rejected "fall back to slot 0"
shortcut would have *broken the currently-working half*.

**What landed:**
- `nova_rt_field_set_by_name` in `nova_runtime.c` — resolves the name against the object's slot-0
  type hash (identical resolution to `nova_rt_field_get`, so a read and a write of the same name can
  never disagree), then **delegates** to `nova_rt_field_set` so the managed-slot bitmap, arena bypass
  and inc-NEW-only rule are inherited rather than duplicated.
- `ir_fmap_collision` on `IrBuilder`, marked at all 4 `ir_fmap` write sites when a name lands on a
  different slot than previously recorded.
- **Read** (`ir_lower_expr` ~12685): ambiguous + `recv_stype == ""` lowers a direct
  `nova_rt_field_get(obj, "name")`, materializing the name via `Expr("str", …)`.
- **Write** (`ir_lower_assign_target` ~14426): sets slot `-1`, and `ire_emit_inst`'s `field_set`
  turns `num < 0` into `nova_rt_field_set_by_name`, interning the name with `ire_intern_string`.
  It stays an *instruction* rather than a lowered call **because `do_inc` is decided at emit time**
  (from `ire_load_origin`): guessing it would either leak on every fresh temp (`do_inc=1`, and FULLRC
  would flag it) or free a value the source slot still holds (`do_inc=0` → use-after-free).
- Gate `_xm_slot_gate.ps1` at CI stage **2k3**, 8 exact value assertions.

Only `ire_emit_inst` needed touching — 21599/21915/22125 are inference/rewrite passes, not emitters.
Note the rewrite pass at ~21915 rebuilds `field_set` with only 2 args, which is why a "pass the name
as a 3rd operand" variant was avoided; the sentinel carries no extra operand to lose.

**Verified:** reconverge byte-identical, 2858/0 both modes (FULLRC = leak-checked), gates 8/8 + 9/9.

### 1.4 background — the measurement that re-scoped this from S to M

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

**Two refinements identified while implementing — apply in a follow-up cycle, not urgent:**

1. **The read guard is narrower than the condition it protects.** I gate on `recv_stype == ""`, but
   `get_ir_field_index_for` also falls through to the guessing path when `recv_stype != ""` and
   `not contains(b.ir_sdefs, recv_stype)` — e.g. the inferrer returns a builtin name like `"list"`.
   The guard should be exactly *"the typed lookup cannot resolve"*:
   `(recv_stype == "" or not contains(b.ir_sdefs, recv_stype)) and contains(b.ir_fmap_collision, value)`.
   The write side needs no such change: `mstype` is only ever set after a `contains(b.ir_sdefs, ...)`
   check, so it is already either `""` or a valid key.

2. **`@repr(C)` structs must be excluded from collision marking.** `get_ir_field_index_for` numbers
   `@repr(C)` fields from **0** (no type-hash slot) while every `ir_fmap` write site numbers from
   **1** unconditionally — a pre-existing inconsistency. Worse, the by-name runtime helpers both
   guard on `nova_rt_is_struct_value` / `NOVA_STRUCT_HASHED`, which a `@repr(C)` FFI struct is not,
   so routing such a field by name would return 0 / no-op: a *regression* for repr(C) code. Fix:
   skip `ir_fmap_collision` marking when the owning struct is in `ir_repr_c_types`, so those names
   keep their existing (guessing) behaviour rather than silently becoming no-ops. Narrow — it needs a
   repr(C) struct to share a field name at a differing slot AND an un-inferrable receiver — but it is
   a correctness hole in the fix, not in the original bug.

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

### 📊 1.6 BLAST RADIUS MEASURED (2026-08-22) — 28/2862, and the "one root cause" theory was TESTED and DISPROVED

Ran the full regression with `NOVA_FIRSTCLASS_NULL=1`. Result: **2835 PASS, 28 FAIL** — under 1%,
against 510 `== null` call sites.

| family | count | examples |
|---|---|---|
| tree / list / heap structures (mostly **TIMEOUT**) | 11 | `_linkedlist`, `_treap`, `_avltree`, `_skiplist`, `_splaytree`, `_ostree`, `_pairingheap`, `_skewheap`, `_leftistheap`, `_bktree`, `forge_treap` |
| serialization codecs | 10 | msgpack, cbor, bson, ubjson, yaml, mongodb |
| singles | 7 | `forge_pg`, `forge_kafka`, `_tdiff`, `_mock`, `_asn1_time`, `_kat_validate`, `_kat_cli` |

**The hypothesis.** Every tree/list TIMEOUT is one line: `nova_rt_dict_get` returns raw `0` for a
missing key, so `let nx = h["next"]` on an unset key yields `0`, `nx == null` is false, and the
traversal never terminates. Fix the *absent-value producers* (`dict_get` miss, unknown field) to
yield the null singleton and the whole family clears: **predicted 28 → ~17**.

**❌ FALSIFIED.** Implemented exactly that (`nova_absent()` helper, applied at both producers),
rebuilt, re-ran the full 2862: **2831 PASS, 32 FAIL**. Not 17 — *worse than the 28 baseline*, and
**every tree/list test still TIMED OUT**. Both halves of the theory were wrong.

**Why it is worse — `0`-as-absent is load-bearing across the stdlib.** A missing key feeding
arithmetic (`d["count"] + 1`) must be `1`, not pointer arithmetic on a box; the codecs test absence
with `== 0`. Routing absent through the singleton silently corrupts all of that — hence the 4 *new*
failures. And since the timeouts survived the change, their termination depends on something other
than the `dict_get` path I blamed; that cause is still unidentified.

**Consequence — 1.6 is rescoped, and the estimate revised UP, not down.**
- **In scope, and landed (`a7e5fc76`):** the `null` **literal** lowers to a distinct singleton;
  `nova_rt_eq` tests null-boxness *before* unboxing; `nova_rt_is_null` knows the singleton. This is
  the actual JSON-fidelity gap (`null` vs `0` as *values*). Flag default **OFF** → zero behaviour
  change → CI green.
- **Out of scope:** making *absent* first-class null. That is a whole-stdlib semantic migration
  touching every implicit-zero read, not "a handful of producers". The ~2–4 day estimate was based
  on the falsified theory and is withdrawn; it is not costed until the timeout cause is actually
  found.

The producer change was reverted; `nova_runtime.c` carries a comment at the `nova_rt_bool` site
recording *why* absent deliberately stays `0`, so this is not re-attempted from scratch.

**The tension that remains genuinely unresolved:**
- `let z = 0; z == null` must be **false** (that is the fix, and it works)
- `node.next == null` where `next` was never set must be **true** (and this is NOT solved)

Under the flag these are still incompatible. That is the honest state: 1.6 fixes null-as-a-*value*
and does **not** fix null-as-*absence*. Anything claiming otherwise is contradicted by the 32.

### 🔑 1.6 DESIGN (2026-08-21) — the representation ALREADY EXISTS; this is a wiring + migration job

**The single most important finding of the audit.** I estimated 4–6 weeks assuming a value-model
invention. That was wrong: `nova_runtime.c` already carries a first-class null, built for the
JSON value model and proven in production:

```c
#define NOVA_BOX_NULL  2   /* JSON-native value model: first-class null (singleton oddball) */
/* pinned singleton oddball cells (null/true/false) so bool/null survive as
   first-class values DISTINCT FROM INTEGER 0/1 */
static int64_t g_null_box = 0, g_true_box = 0, g_false_box = 0;
int64_t nova_rt_null(void) { nova_rt_oddballs_init(); return g_null_box; }
```

It is **lazy and inert** — nothing mints the cells until first use, so a program that never touches
them is byte-identical. That is exactly the property a migration needs.

**The gap is one line.** The language-level `null` literal lowers to a raw zero:

```nova
else if tag == "null"
    ir_emit_inst(b, "const_int", dest, ir_type_any(), [], "0", 0)   // <- the whole bug
```

So `null` is `0` *in the language* while the runtime has a perfectly good distinct null sitting
unused. Point the literal at `nova_rt_null()` and `null` becomes distinguishable.

**Therefore the work is NOT invention — it is migration, and the risk lives entirely there.**
`== null` appears **510 times** (std 157, tests 322, forge 23, compiler 8). Today many of those
rely, knowingly or not, on `null == 0`. After the change:
- `x == null` where `x` is integer `0` becomes **false** — which is *correct*, and is precisely what
  makes it a breaking change.
- An uninitialised slot reads `0`, which will no longer equal `null`. That is arguably a second bug
  this exposes rather than causes.
- `is_null()` must recognise the singleton (and decide, deliberately, whether raw `0` still counts).
- Every `null` literal becomes a call rather than a constant. `nova_rt_null()` is
  `oddballs_init()` (idempotent branch) + a global read — cheap, but it should be hoisted/cached
  before this ships.

**How to land it safely — flag-first, measure the blast radius, then decide.**
This codebase already has the pattern (`NOVA_DWARF_VARS`, `NOVA_NO_SROA`, `NOVA_T8_FULLRC`):
1. Put the new lowering behind `NOVA_FIRSTCLASS_NULL=1`. **Flag off ⇒ byte-identical** — provable by
   reconverge, so the change is zero-risk until deliberately enabled.
2. Run the full 2861-test regression with the flag **on**. The suite then *tells us* exactly what
   depends on `null == 0` instead of us guessing. That converts the scariest unknown in the whole
   plan into a measured list.
3. Triage that list. Each failure is either a real latent bug (fix it) or intentional
   `null`-as-zero (migrate it).
4. Flip the default only once the list is empty, and gate it.

**Revised estimate: ~1 week to build + 1–3 weeks of migration, driven by what step 2 reports** —
not 4–6 weeks of invention. And step 1 alone is a day's work that makes the remaining cost
*knowable* rather than estimated, which is the highest-value next action on this entire plan.

### 1.6 — the cheap shortcut (reject-`== null`-on-non-optional) was investigated and REJECTED

**Root cause:** NOVA represents null as integer 0, so `null == 0` is true and no type-tag check can
separate them.

**The tempting shortcut — reject `x == null` when `x`'s static type is not optional — does not
survive contact with the codebase.** Measured usage of `== null` / `!= null`:

| tree | uses |
|---|---|
| `std/` | 157 |
| `nova-compiler/test_programs/` | 322 |
| `forge/` | 23 |
| `nova-compiler/compiler/` | 8 |
| **total** | **510** |

Turning that into an error breaks 510 call sites; turning it into a warning produces noise at a
volume nobody will read, which trains people to ignore warnings. Neither is a fix.

**So 1.6 stays a representation problem, and the honest options are:**
1. **Type-driven optionals** (recommended): the checker already distinguishes `T?` from `T`, so only
   `T?` needs a distinguishable representation (tag bit or box) while plain `T` stays unboxed —
   the same shape as Rust's `Option<T>` with niche optimisation. Bounded blast radius (only
   optional-typed values), but it touches every `T?` in `std`/`forge`/`prism` and `orm_null()`.
2. NaN-boxing / tagged pointers everywhere — touches every value operation. Rejected as
   disproportionate.
3. A distinct non-zero null sentinel — merely moves the collision to whichever integer is chosen.

This needs its own `design-decision` pass, not a patch bolted onto a soundness sweep. **Do not
attempt it piecemeal** — a half-migrated optional representation is worse than the current honest
limitation, because today at least the rule ("null is 0, use `orm_null()`") is simple and known.

### 1.7 RC cycle collector — the leak COUNT already exists; attribution is the gap

`A → B → A` still leaks. What is already there, and it is more than the plan implied: with
`NOVA_HEAP_PROFILE` set, `nova_rt_cleanup` prints a per-tag allocation breakdown plus
**`still-live objects=N`** at exit. For a program that should have released everything, a non-zero N
*is* the leak signal, and once total-RC (`NOVA_T8_FULLRC`) is on, cycles are the dominant cause.

What is missing is **attribution**: which objects, and proof they form a cycle rather than being
legitimately reachable. That needs (a) a registry of live RC objects — a doubly-linked list threaded
through every allocation, i.e. a hot-path cost that must be compiled out when off — and (b)
Bacon–Rajan synchronous cycle collection (trial deletion: decrement internal edges, see what
reaches zero, restore what does not).

**Staging, so this can land safely:** a *detector* first (opt-in env flag, reports suspected cycles
at exit with type names), and only then a *collector*. The detector is diagnostic-only and cannot
corrupt memory; the collector touches the RC hot path and needs the full RED-tier arc. For a
language that prizes predictability, being *told* about a cycle may well be better than having it
silently collected — so the detector may be most of the value.

---

### ✅ 1.7 DETECTOR LANDED (2026-08-23) — `NOVA_CYCLE_DETECT=1`, and it beats Swift/Rust here

**First, a correction to this plan's own premise.** The competitive framing above implied NOVA
was behind on cycles generally. Grepping the runtime says otherwise: **weak references already
exist and are exposed as builtins** — `weak_create` / `weak_upgrade` / `weak_alive` /
`weak_invalidate`, auto-invalidated in `nova_rc_free`. So the real standing is:

| Language | Cycle story | vs NOVA |
|---|---|---|
| Python | automatic cycle GC | NOVA loses |
| **Swift** | no collector — you write `weak`/`unowned` | **tie** |
| **Rust** | no collector — you write `Weak` | **tie** |
| Go/Java | tracing GC | different memory model |

NOVA was already at parity with the two languages closest to its memory model. What *none* of the
three gives you is a built-in answer to **"where is my cycle"** — Xcode needs Instruments, Rust has
nothing. That is the gap this closes, and it is a genuine WIN rather than catching up.

**Why a graph search and not the refcount test.** The plan's implied approach — an object whose
refcount is entirely internal to the live set is unreachable, therefore cycle-held — was
implemented and **measured wrong**. A real `A <-> B` cycle reported `rc=2, internal=1` on both
nodes and the test called it clean. Reason: NOVA's compiler conservatively emits **no drop** for a
local that escapes (both nodes escape into each other's fields), so a *dead stack slot* still holds
a count. The refcount test answers "is this unreachable", which cannot be answered at exit. **A
cycle is a graph property**, so the detector runs **Tarjan SCC** over the live object graph
instead: it does not care how many stale references exist — if the objects point at each other,
that is a cycle. Iterative, not recursive, so a deep list cannot blow the C stack.

**How it enumerates children.** `nova_cyc_walk` mirrors `nova_rc_free`'s traversal *structurally* —
same tag dispatch, same per-type managed-slot bitmap, same `elem_kind == 2` exclusion (raw doubles
are never heap refs; feeding a double's bit pattern to `find_tag` is exactly the bug that exclusion
prevents). Any divergence would misreport, so it is kept identical rather than re-derived.

**Gated (CI 2k6, `_cycle_detect_gate.ps1`), 5 assertions:**
- POSITIVE `_cyc_pos`: 6 objects in 3 distinct cycles — a 2-node pair, a **self-loop** (an SCC of
  size 1, which Tarjan calls acyclic unless the self-edge is checked), and a 3-node ring
- attribution: reported by type name (`CycNode`), not just a count
- **NEGATIVE `_cyc_neg`: 0 cycles** across lists, dicts, strings and an acyclic chain — the
  load-bearing half, since a detector that flags healthy programs is worse than none
- opt-in: completely silent when the env flag is unset

**Cost, measured not asserted.** The first cut regressed an allocation-saturated microbenchmark by
a best-of-7 **24.8%** — the hook sat inline in the two hottest runtime functions
(`nova_heap_alloc`, `nova_rc_free`) and could call the resolver. Fixed by resolving the flag
eagerly in `nova_rt_init` and marking the branch cold: now **~2% (min 1.9%, median 2.4%)** on 1.5M
dict+list allocations in a tight loop, at that machine's noise floor, and 0% on anything not
allocation-bound. `-DNOVA_NO_CYCLE_DETECT` compiles the hooks out for literal zero.

**`NOVA_CYCLE_DETECT=2`** additionally dumps every live object (address, type, refcount, out-degree,
IN-CYCLE flag) — which is what turned the falsified refcount theory into a diagnosis in minutes.

**Still open: the COLLECTOR.** Detection tells you; it does not free. That remains the larger,
RED-tier piece (Bacon–Rajan trial deletion touching the RC hot path).

---

## PHASE 2 — EXPRESSIVENESS (what makes code powerful)

| # | Feature | From | Effort | Status |
|---|---------|------|--------|--------|
| 2.1 | Nested pattern matching `Ok(Some(x))` | Rust/Haskell | M | **✅ DONE 2026-08-20** |
| 2.2 | Pattern guards `x if x > 0` | Rust/Haskell | S | **✅ ALREADY EXISTED — verified + gated** |
| 2.3 | Operator overloading | C++/Rust/Swift/Kotlin | M | **✅ ALREADY EXISTED — verified + gated** |
| 2.4 | RAII / drop trait (scope-exit cleanup) | C++/Rust | M | **✅ ALREADY EXISTS** (`<Type>__drop`) — gated via `_chan_drop_test` |
| 2.5 | Extended @comptime (full language at compile time) | Zig/C++ | L | **✅ DONE 2026-08-27** — lists/`for`/`break`/`continue`/`while`/builtins/str+list folding all evaluate at compile time; impure initializers and float results correctly FALL BACK to runtime (no frozen clock, no lossy decimal literal). Gate `_comptime_gate` 9/9, CI 2m3 |
| 2.6 | Generics proven in framework code | C++/Rust/Swift | M | **✅ TRUE — 74 in `std/`, 9 in `forge/`** (0 in `prism/`) |
| 2.7 | Error message suggestions ("did you mean X?") | Python/Rust/Elm | S | **✅ ALREADY EXISTS** (edit-distance) |
| 2.8 | Move semantics / move(x) builtin | Rust | M | **DONE 2026-08-25** — general `move(x)`: identity at runtime (0 runtime calls), use-after-move + double-move are E1003 BY DEFAULT, cross-module, diagnostics name which construct moved it and where; `send()`-moves stay opt-in for back-compat. Gate 2q, 14/14 |
| 2.9 | Nested-pattern exhaustiveness | Rust/Haskell | L→M | **✅ DONE 2026-08-21** |

### ✅ 2.1 Nested patterns — landed

**The gap was in the parser, one line deep.** `parse_pattern`'s `pat_ctor` branch read exactly ONE
token per field and always wrapped it as a binder:

```
push(fields, Expr("pat_var", tv(tokens, p), 0, [], [], ln))
p = p + 1
```

So `Wrap(IntVal(n))` read `IntVal` as a *variable name* and then met `(` where it expected `,` or
`)`. Downstream, both `ti_infer_pattern` pat_ctor branches iterated `children` acting only on
`ct == "pat_var"`, so a nested child would have been silently ignored — no binding, no check.

**Three parts, all required:**
1. **Parser** — recurse into `parse_pattern` for each field. Because that function already handles
   `pat_var`/`pat_wild`/`pat_lit`/`pat_str`/`pat_tuple`/`pat_ctor`, nesting composes to any depth for
   free, and a bare identifier still parses to `pat_var` so every existing flat pattern is unchanged.
2. **TI** — recurse for non-`pat_var` children in *both* pat_ctor branches, passing the payload's
   declared type as `expected` (from `ti_variant_ptypes` for user enums, from the sum's payload type
   for built-in `Ok`/`Err`/`Some`/`None`). Two separate branches, so two separate fixes.
3. **IR** — nesting needs an extra *runtime test*, not just an extra binding. New
   `ir_destructure_ctor` extracts the payload, compares its own slot-0 type hash against the inner
   ctor's tag, and branches to **the arm's existing mismatch label** on failure — so no new control
   flow is introduced — then recurses inside the success block.

**One helper, three call sites** (`ir_lower_expr`, `ir_lower_stmt`, `ir_lower_last_stmt`) which each
had their own inline copy of the flat destructuring loop. Extracting it *before* adding the feature
is the 1.9 lesson applied: a fourth divergent copy is how 1.3 became four separate bugs.

Two supporting helpers keep the emitted IR honest: `ir_variant_field_name` recovers the payload's
**declared** field name from `ir_sdefs` (a nested extraction names a field the source never wrote,
and `ir_infer_one` keys resolved field types on `"@sf@<recv>.<value>"` and special-cases
`"__type_hash"` — a synthetic label would poison type inference), and `ir_ctor_expected_tag`
centralises the tag rule that was duplicated at all three sites.

Label uniqueness needs no counter: `ir_fresh_label` already bumps `ir_lc` and appends it. A first
cut threaded a `nest_id` *and* wrote it back to `b.ir_lc`, which could have **regressed** the counter
and produced colliding labels — removed.

**Verified:** depth-3 `L1(L2(L3(n)))` → 7 · nested inside built-in `Result` (`Ok(IntVal(n))`, the
`is_sum_match` branch) → correct · sibling inner ctors dispatch to the right arm · zero-payload outer
ctors unaffected. Gate `_p2_pattern_gate.ps1`, CI stage **2k4**, 16 assertions across both probes.

### ✅ 2.9 Nested-pattern exhaustiveness — CLOSED (supersedes the 2.1 limitation below)

2.1 made nested patterns run correctly and, in doing so, **added a soundness hole**: the
exhaustiveness check only verified that every variant of the scrutinee enum was *named* by some arm.
`Wrap(IntVal(n))` + `Empty()` names both `Outer` variants, so it passed — while a
`Wrap(StrVal(…))` value matched no arm and fell through to `""`. Adding a feature created exactly
the silent-fallthrough class this campaign exists to remove.

`ti_check_nested_exhaustive` closes it. Rather than a full Maranget pattern matrix, it groups arms
by outer constructor and, for any constructor whose arms *all* destructure their payload with a
nested ctor, requires those inner ctors to cover the payload enum:

```
error[E1000]: non-exhaustive nested match: 'Wrap' is only matched with IntVal(...),
so a 'Wrap' holding StrVal(...) matches no arm and would fall through
```

**Sound by construction — it can report a missing variant but never rejects a valid match.** Every
bail-out is deliberate: a payload bound by a binder or `_` covers everything; a **guarded** arm is
treated as covering everything (a guard may not fire, so counting it as *not* covering would produce
false rejections); a variant with more than one payload field needs the genuine cross-product of
positions, so multi-field payloads are skipped rather than guessed; inner ctors from mixed or unknown
enums are skipped.

**Zero risk to existing code, by construction:** nested ctor patterns were a *parse error* before
2.1 landed earlier the same day, so no pre-existing source can trigger this check. The only code it
can fire on is code written against the new feature.

Guard information had to be threaded in — the arm's guard lives in `annotations[0]` for the
statement form and as the third child for the expression form — so `ti_check_exhaustive_g` now takes
a parallel `guarded` list. Gated by `_negty_nested_exhaustive.nova` in `_neg_type_tests.ps1`.

**The `n8=[]` assertion in the pattern gate was deliberately removed**, which is precisely what its
own comment demanded ("if that ever becomes a hard error, this line is the intentional record of the
old behaviour and should be updated deliberately, not silently"). Pinning a known limitation in a
gate worked exactly as intended: the limitation could not be fixed *quietly*.

### ⚠ 2.1's ORIGINAL limitation (now fixed by 2.9 above — kept for the record)

`ti_check_exhaustive` collects outer ctor names, so `Wrap(IntVal(n))` + `Wrap(StrVal(s))` +
`Empty()` reports `{Wrap, Empty}` = exhaustive and is correctly accepted. But a match covering only
`Wrap(IntVal(n))` + `Empty()` is **also** accepted, and a `Wrap(StrVal(…))` subject falls through to
the match's fall label, yielding `""` — the same silent behaviour a missing arm has always had.
Pinned deliberately by the gate as `n8=[]`, so if it ever becomes a hard error that is a conscious
change, not a silent one.

Real nested exhaustiveness needs Rust's usefulness/witness algorithm over a pattern matrix
(specialize by constructor, recurse on the residual matrix). That is a genuine piece of work and is
tracked as **2.9** below, not hand-waved as done.

### ✅ 2.2 Pattern guards — already existed; the gap was that nothing tested them

The plan listed this TODO, but the live code already had it: parsed in `parse_match_stmt` (~3688,
guard stored in `annotations[0]`) and in `parse_match_expr` (~2101, as a third arm child), and
lowered at **all three** match sites (`~13103` match-expr, `~14144` match-stmt, `~14434`
result-match). Verified by probe rather than taken on trust: guards on the first/middle/last arm, on
literal and binder patterns, and on constructor patterns with the payload binder in scope inside the
guard — all correct. Now gated, because an implemented-but-untested feature is one refactor away
from being un-implemented (the same finding as 1.5).

*This is the second time in this campaign that "TODO" in a plan turned out to mean "done but
ungated". Grep the live code before scheduling work.*

### ✅ 2.3 Operator overloading — already existed; verified + gated

No trait plumbing was needed because NOVA resolves operators by **method name**, not by a declared
trait. `ir_resolve_op_overload` (~11693) maps `+ - * / % == != < <= > >= **` to
`add sub mul div rem eq neq lt le gt ge pow` and the binary-op lowering (~11953) dispatches to
`<Type>__<method>` when the left operand's struct type defines it. Declaration syntax is just a
method: `fn Vec2.add(other: Vec2) -> Vec2`.

Two special cases are already handled: `*` on a string falls back to `nova_rt_repeat`, and `**` on
an int keeps the integer power path — so overloading never shadows a builtin for primitives.

`phase75_opoverload_test.nova` already covered it thoroughly (Vec2 add/sub/mul/neg/eq/show plus
Complex add/mul with float fields, all `assert`-ed) — **but it was not in the regression manifest.**
Verified passing in NORMAL *and* FULLRC, then added to `_orphan_coverage_manifest.txt`.

Not "trait-based" as the original plan assumed. That is a deliberate design difference worth
keeping: Rust needs `impl Add for T` because coherence/orphan rules demand a nameable trait; NOVA
has one flat method namespace per type, so the method name *is* the contract. Simpler, and it costs
nothing here.

### ✅ 2.4 Drop trait — already exists

A struct declaring `fn <Type>.drop()` gets its address registered at startup via
`nova_rt_register_struct_drop(type_hash, ptr)` (emitted at ~27734), stored in the struct's RTTI
metadata as `drop_fn`, and **called by `rc_free` BEFORE the fields are released** — the same order
Rust uses, so a destructor can still read its own fields. Gated by `_chan_drop_test` (already in the
manifest).

This is genuine RAII, not `defer`: it is keyed on the value's lifetime, not on a lexical scope exit.
`defer` remains available and complementary (see the crash-safe shadow-stack work).

---

### 2.5–2.8 audited against live code 2026-08-20 — the plan was badly stale

- **2.6 generics in framework code: the earlier "ZERO in forge/prism" claim is WRONG.** Counting
  `^(fn|type) <T…>` declarations (generics go BEFORE the name in NOVA — `fn <T> name(...)`, which is
  why an `fn name<T>` grep finds nothing): **`std/` 74, `forge/` 9**, `prism/` 0,
  `test_programs/` 36, compiler 0. So generics *are* load-bearing in the standard library. The real
  remaining gap is narrower and worth stating precisely: **Prism uses none**, and the self-hosted
  compiler uses none.
- **2.7 did-you-mean: exists.** Edit-distance suggestion machinery at ~17405, wired into unknown-
  identifier errors (~17487) and ORM column errors (E1013, ~18549 — "the struct IS the schema").
- **2.8 move semantics: partial, and the partial half is the important half.** Use-after-move is
  *enforced* — `send()` moves its argument and a later use is `E1003 value 'x' used after move`,
  with the line of the move reported. There is no general user-facing `move(x)` builtin. Since NOVA's
  ownership story is "channel boundaries ARE the transfer points", enforcing it exactly at `send()`
  is arguably the whole feature; a general `move()` would be a second, weaker mechanism. Needs a
  design decision before implementing, not just code.
- **2.5 @comptime: partial.** `@comptime` exists and 16 uses appear across the trees, plus
  `ce_try_fold_const` folds pure call-rooted `const` initializers (e.g. `const X = fib(10)`) at
  compile time and fails closed to runtime. "Full language at compile time" (Zig parity) is the part
  still open.

**Score-keeping correction.** Of the 8 original Phase 2 items, 5 were already implemented (2.2, 2.3,
2.4, 2.6, 2.7), 2 are partial (2.5, 2.8), and exactly 1 needed building (2.1). The plan was written
from assumption rather than measurement. Every future item gets grepped before it gets scheduled.

## PHASE 3 — PERFORMANCE (match C, beat Python 100x)

| # | Feature | From | Effort | Status |
|---|---------|------|--------|--------|
| 3.1 | Float/array perf 1.7x → 1.0x C | C | L | **✅ DONE 2026-08-27** — float ARRAY **1.60x → 1.09x C** (`2026-08-25`: element read inlined, bounds+kind checked, gate 2r 11/11); **scalar float parity now DEFAULT** — the three experiment flags removed, unbox-elimination proven by the `_f31_unbox_elim_gate` probe (all four call-site classes closed). Gate 9/9, CI 2k9 |
| 3.2 | SIMD | C/C++/Rust | M | **✅ ALREADY EXISTS** — `simd_add/sub/mul/scale/dot/sum/ready` builtins |
| 3.3 | Verify generics monomorphize to zero-cost | C++ | S | **✅ DONE 2026-08-22 — zero-cost PROVEN structurally (byte-identical IR)** |
| 3.4 | Buffer views (read-only, no copy) | C/Rust | M | **✅ DONE 2026-08-24** — `bytes_view` is O(1) zero-copy; `bytes_slice` still copies (contract kept); writes through a view abort; gated CI 2k8 |
| 3.5 | Process-scoped arena allocators | C/Zig | M | **✅ ALREADY EXISTS** — per-task arenas, `nova_task_arena_cleanup` |
| 3.6 | `@stack` hints for stack allocation | C/Zig | S | **❌ REJECTED 2026-08-21 — already automatic (SROA), a hint would be redundant** |

---

### 🔧 3.1 PARTIAL (2026-08-23) — scalar float 2.21x → 1.69x C, and the real numbers measured

**The plan's "1.7x" was one stale number covering two very different paths.** Measured against C
(-O2), best-of-3:

| path | before | after | benchmark |
|---|---|---|---|
| **scalar float through function calls** | **2.21x** | **1.69x** | `_f31_scalar.nova` vs `_f31_scalar.c` |
| float array sum | 1.60x | **1.09x** (element read inlined, 2026-08-25) | `_fa_bench.nova` vs `_fa_bench.c` |

The scalar call path — not arrays — was the worse offender, exactly as 3.3 predicted.

**Root cause, confirmed in the IR.** `axpy(a: float, x: float, y: float) -> float` emits **three
`nova_rt_unbox` calls, one per declared-float parameter**. Not a generics problem (3.3 proved
erasure is free): an i64 float argument may be a box OR a raw IEEE-754 pattern and the callee
cannot tell, so it unboxes defensively. Each of those was a full `nova_mem_find_tag` — range +
alignment + ownership-table + header reads.

Note what the compiler *already* gets right: `%r4.af = bitcast i64 %r2 to double` — the
intermediate is NOT unboxed, because the compiler tracks that it just produced a raw value.
**Parameters simply are not in that known-raw set.**

**The fix (runtime only — zero compiler change).** The managed object space is ONE contiguous
reservation, so a value outside `[base, cap)` cannot be a NOVA object, and a raw double is nowhere
near it (`1.5` = `0x3FF8000000000000` ≈ 4.6e18). `nova_rt_unbox`/`nova_rt_unbox_elem` now reject on
two loads, a subtract and a compare, with the structural check behind a `noinline` slow path.

**Why `base`/`cap` and NOT `g_oa_region_end`:** base and cap are written once in `nova_oa_reserve`
and never change, so LLVM may hoist the loads out of loops. `g_oa_region_end` **grows** — hoisting
a load of a moving bound would let a box allocated later fall outside a stale range and be silently
misread as a raw double. `[base, cap)` is a conservative *superset*, so the reject stays sound.

**Correctness gated** (`_f31_float_unbox_test.nova`, auto-discovered): boxed floats via
`list<any>` and dict, boxed→float-param, raw→float-param, `any` round-trip, negative and zero —
the cases where a wrong reject would return a pointer bit-pattern as an astronomical double.

**⚠️ Two measurements that redirected the work:**
1. **LTO buys nothing.** `-flto -fuse-ld=lld` measured **59 ms vs 59 ms** — identical. The residual
   call overhead is free; it was `find_tag`'s *body* that cost. Do not reach for LTO here.
2. Without `-flto` there is **no cross-TU inlining**, so `nova_rt_unbox` is still a real call in the
   shipped build. It just got cheap. That is why the win is 24% and not more.

**What is left, and the decisive experiment for it.** Closing the remaining 1.69x needs declared-
`float` params to be treated as **known-raw**, eliminating the unbox rather than cheapening it. That
is a parameter-representation change and is genuinely risky: if a boxed float ever reaches a callee
that assumes raw, a *pointer* is read as a double — silent wrong answers, the worst failure class.
The blocking question is whether NOVA inserts a coercion when an `any` holding a boxed float is
passed to a `float` param. **Test that first** (pass `mixed[0]` from a `list<any>` to a float param
and read the emitted call site); the answer decides whether the safe form is caller-side
normalisation or a non-address-taken specialised entry point.

#### 3.1 Phase 2 (2026-08-23) — the decisive experiment ran, and the answer was worse than either option

The experiment above (`_f31_poison_probe.nova`) was run. The answer to "does NOVA insert a coercion?"
is **neither** of the two anticipated designs, because the premise was wrong: **a declared `float`
parameter had no guaranteed representation at all.**

`clean_f(x: float)` and `poisoned_f(x: float)` have **identical signatures**. `clean_f` is called only
with raw floats; `poisoned_f` is called with the same raw floats *plus* one `mixed[0]` from a
`list<any>`. They compiled **differently** — every raw call site of `poisoned_f` emitted
`nova_rt_box_float`, a **heap allocation**, to pass a float into a parameter explicitly annotated
`float`.

**Mechanism — two independent defects, both required.**
1. `source_type_to_ir` mapped `int`/`str`/`list`/`dict`/`bool` but let **`float` fall through to
   `any`**, discarding the annotation before inference ever ran.
2. `ir_collect_param_types` therefore derived param types **purely from call sites**, and collapsed
   any disagreement to `"any"`. So ONE dynamic call site anywhere in the program degraded the
   parameter for **every other caller**.

That is textbook **action-at-a-distance plus a hidden cost** — both explicitly forbidden by this
project's design rules. Two functions with the same signature must not compile differently because of
who *else* calls them.

**The fix (compiler only — runtime untouched).** Map `float` through `source_type_to_ir`, seed
`ir_collect_param_types` from the **declaration** first, and record those entries in `fpt_decl` so the
call-site conflict rule cannot downgrade an annotated parameter.

**⚠ The trap that cost a build — do NOT re-add call-site narrowing.** The obvious companion change is
to coerce at the call site with `nova_rt_to_float` "for safety". It was tried and it **broke `nn` and
`optimizers_lib_test`**: a register typed `"val"`/`"any"` can already hold **raw IEEE-754 bits** (e.g.
`floatlist[i]` via `get_f`), and `to_float` cannot distinguish those from a genuine int — so it
converted `2.0`'s bit pattern *numerically* to `4.61168601842739e+18`. Silent wrong answers, the worst
class. **The coercion was never needed:** the callee retains its own defensive `nova_rt_unbox` on
float params, so it is box-**tolerant** and handles a boxed argument from a genuinely `any` call site
by itself. Declaring the parameter is sufficient; layering a coercion on top of a tolerant callee only
creates a second, worse ambiguity. The gate asserts box-tolerance is retained precisely so this cannot
be "optimised" away later.

**⚠ The second defect, found by the full gate — the BUILTIN raw-float ABI.** The change above passed
its own gate, reconverged byte-identically, and still **broke `_avro_kat_test`**: `av_encode_double(1.0)`
emitted `00 00 00 00 00 F8 CF 43` instead of `00 00 00 00 00 00 F0 3F`. Nothing crashed — the number
was simply wrong.

Cause: `ir_collect_param_types` records `fpt[callee][i]` from call sites **for every callee, builtins
included** — and that inference is *circular* for a builtin, whose C ABI cannot be learned from
whoever calls it. Passing a float taught the compiler "this builtin wants a raw float", so it skipped
the widen-box. The runtime has exactly two float-argument readers and they are **not**
interchangeable:

| reader | box | RAW i64 | verdict |
|---|---|---|---|
| `nova_float_arg(x)` | unboxes | `i2f(x)` — **reinterprets** the bits | raw-SAFE |
| `nova_elem_to_double(x)` | unboxes | `(double)x` — converts **numerically** | raw-UNSAFE |

`nova_rt_float_to_bits` uses the second, so raw `1.0` (`0x3FF0000000000000`) was read as `4.6e18`.
`nova_rt_tensor_scale` had the identical defect. This was **already a known bug class** — the
any-storing fns `format_one`/`ok`/`err`/`some` carry a hand-written exception — but making declared
`float` params raw turned a rare case into a broad one.

**Fix: declare the ABI, don't guess it, and fail safe.** `ir_builtin_raw_float_safe` holds the 44
runtime fns extracted **mechanically** from `nova_runtime.c` as "calls `nova_float_arg`". For a
`nova_rt_*` callee the call-site-inferred `pm` is ignored entirely; anything not on the list gets its
float args boxed. The asymmetry is the whole point: **a missing entry costs one heap box (slower, still
correct); a wrong entry returns a silently wrong number.** `nova_rt_format` could not be confirmed, so
it is deliberately omitted and boxes. User functions are untouched, so the 3.1 perf win stands.

**This also closed a pre-existing bug.** `float_to_bits(1.0)` returned `4886396799603965952` on the
*old* compiler too — wrong before this work started, now correct at `4607182418800017408`.

**Gated** — `_f31_param_repr_gate.ps1` (CI 2k7), **5 assertions**. Structure (no `nova_rt_box_float`
at a raw call site, both functions), box-tolerance retained, values on raw *and* boxed paths
(`7.0 14.5 7.0 14.5 3.0`), and the builtin ABI (`bits 4607182418800017408 …`). Structure alone would
pass if the coercion were simply dropped, which would be worse than the original bug.

**Reconverge:** gen4 == gen5 == gen6 byte-identical (`B96BEAD9…`) — fixpoint reached immediately.

**Lesson worth carrying:** a representation change is not done when its own gate is green. Making one
class of value *more common* re-prices every consumer that was quietly relying on it being rare. The
full 2862-test regression is what caught this; the targeted gate could not have.

`bool` deliberately still maps to `int`. That is a separate representation question with its own blast
radius (and the root of the documented "a bool cannot be type-validated" behaviour). Not bundled in.

#### 3.1 Phase 2 completion (2026-08-24) — two more defects closed, int-to-float conversion added

**Defect 3 (any-typed call site skipped by `ir_collect_param_types`).** When `atype == "any"`, the
inference loop skipped the argument entirely (`if atype != "any"` guard at line ~22907). A function
like `_statsd_fmt_num(value: any)` called with float from `_statsd_line` and with int from
`fmt_gauge` recorded `fpt["_statsd_fmt_num"]["0"] = "float"` from the float call site, and the
int call site was silently ignored — no conflict, no downgrade. The body then inferred `value`
as float and dispatched `str(value)` to `nova_rt_float_to_str`, corrupting every int caller:
`fmt_gauge("g", 1)` → `g:4.94065645841247e-324`. **Fix:** an `else` branch for `atype == "any"`
that (1) conflicts with existing non-`any` entries (unless `fpt_decl`) and (2) records `"any"` for
new entries, making the fix order-independent.

**Defect 4 (int literal at a declared-float call site).** `statsd_format_counter("x", 1, 1, [])`
— the third arg `1` (int) is passed to `rate: float`. With Phase 1's change, the body treats
`rate` as raw float and does `rate * 1.0` via bitcast-to-double. Int `1` bitcast → `4.94e-324`.
**Fix:** in the widen logic, when `ir_reg_type(rt, a) == "int"` and the callee param is declared
float (detected via `pm["d" + str(ai)]` marker set during seeding), insert `nova_rt_int_to_float`
conversion at the call site. Safe because a register typed "int" is definitively an integer value
(not ambiguous like "any"/"val" which might hold raw float bits).

**Gated:** `_f31_param_repr_gate.ps1` now **6/6 assertions** — Rule 1 (no hidden box), Rule 2
(builtin ABI), Rule 3 (int-to-float conversion: `poisoned_f(3) → 6.0`).

#### Defect 5 — the Defect-3 fix was too broad, and "pre-existing failure" was the wrong call

Defect 3's first cut made an unknown-typed argument collapse the parameter for **every** kind, not
just float. That regressed three tests — `struct_perf_test`, `_pack_float_kat`, `_antimeridian_test`
— and they were initially written up here as *pre-existing* failures. **They were not.** Running the
committed HEAD compiler against the same three programs passes all three; only the patched compiler
fails them. The lesson is cheap to state and was expensive to skip: a failure is pre-existing only
once the previous binary has been *run*, never because the failure looks unrelated.

What the over-broad collapse actually destroyed:

```nova
fn dot(a, b)          // unannotated — Point inferred from the call site
    a.x * b.x + a.y * b.y
fn norm_sq(a)
    dot(a, a)         // `a` here is untyped, so this call site types the arg "unknown"
```

`norm_sq`'s forwarding call was enough to erase `dot`'s inferred `Point`, and the whole body
dropped from `fmul`/`fadd` to `nova_rt_mul`/`nova_rt_add`. `_antimeridian_test` showed the second,
nastier consequence: once `ckf(label, got, expected, eps)` was demoted to `any`, callers that
*could* see a float boxed it while callers that could not passed raw double bits — the **same
parameter reached both boxed and raw**, and `str(got)` printed `4631530004285489152` instead of
`45.0`. A mixed representation is worse than either representation.

**Fix — narrow the rule to what the author actually declared.** Only a parameter written `any` in
the source is protected from call-site narrowing:

| parameter | narrowed from call sites? | why |
|---|---|---|
| declared `float` | no — annotation wins (`fpt_decl`) | Phase 1's whole point |
| declared `any` | **no — new** | an explicit `any` promises polymorphism; narrowing it to raw float is unsound |
| unannotated | yes, as before | no promise was made; this is what makes struct params lower to `fmul` |

Written-`any` and omitted-annotation both lower to `IrType("any")`, so the distinction is captured
in `ir_lower_function` while the source text is still in hand (`b.ir_any_params`, keyed
`"<emit_name>#<index>"`) and reaches `ir_collect_param_types` on the existing out-of-band `frt`
channel as `@anyp@`, alongside `@sf@`/`@sfkinds@`.

Why *float* is the one representation worth this care: an int is a raw i64 and a box/string/list/
dict/struct is a tagged pointer, so a too-narrow guess is still recoverable at runtime. A raw double
is the only NOVA value whose bits are indistinguishable from an i64 — nothing downstream can tell
them apart, so a wrong guess becomes a silently wrong number rather than a slow one.

**Reconverge:** byte-identical, and reached at gen4 already — `gen4 == gen5 == gen6`
(`68B90E26757CF6EE2DA36B7582562866B262A485C394A64170B37D860D604EAE`), which is itself evidence the
change is representation-stable.

**Verified green:** `struct_perf_test`, `_pack_float_kat`, `_antimeridian_test`, `statsd_kat`,
`statsd_ratefix_kat`, `_avro_kat_test`, and `_f31_param_repr_gate.ps1` **11/11**. Full CI both modes:
2862 PASS / 1 FAIL, the one failure being `forge_tls_upgrade_test`, which does live HTTPS to
example.com and badssl.com and passes 4/4 in isolation on both this compiler and the previous one.

**The gate was checked for teeth, not just for green.** Run against the previously committed
compiler it reports exactly 3 failures — one per fix (`poisoned_f` boxes, `bits 4886396799603965952`,
`anyp 2.5 3.45845952088873e-323`). A gate that has never been observed to fail is not evidence.

#### ⚠ OPEN DEFECT found by the new gate — an inferred param type does not chain through a second function

Discovered while writing Rule 4; **pre-existing**, verified by running the previously committed
compiler, which produces the identical wrong answer. Not caused by 3.1 and not fixed by it.

```nova
fn sdot(a, b)          // unannotated, and NO direct call anywhere
    a.fx * b.fx + a.fy * b.fy
fn fwd(p, q)
    sdot(p, q)         // the only call — p/q are themselves untyped
main: fwd(FPt{fx:1.5, fy:2.5}, FPt{fx:3.0, fy:4.0})   // → 0, want 14.5
```

`main` teaches the pass that `fwd` takes `FPt`, but `ir_collect_param_types` reseeds `st` from
**declared** types on every pass, so what it learned about `fwd` is never available when it walks
`fwd`'s body. `sdot`'s params therefore resolve to nothing. The driver loop at `compile_ir_core_named`
already iterates to a fixpoint — but only over *return* types (`frt`), never param types.

The consequence is worse than slow code. Field *offsets* still resolve (a field slot comes from the
global name→slot map, which needs no struct type), so the GEPs are right and only the *type* is
lost — the multiply then goes through `nova_rt_mul`, which integer-multiplies two double bit
patterns. `bits(1.5)` and `bits(3.0)` each carry 51 trailing zero bits, so the product has more than
64 and the answer is **exactly 0**. Silently wrong data, no crash.

Fixing it means chaining param types to a fixpoint, which widens types program-wide — and a wrong
struct type there is not a slow path, it is a wrong field slot, i.e. memory corruption. Full-arc
work, tracked as its own item rather than smuggled into this one. Rule 4 asserts the shape that
*does* work today (direct call typed, forwarding call must not erase it — exactly the regression
above) and documents this case in the probe.

#### ✅ CLOSED — an inferred param type now CHAINS through a second function

This was recorded above as an open defect and is now fixed. `ir_collect_param_types` learned param
types from call sites but reseeded `st` from **declared** types every round, so what it learned
about one function was never available when it walked that function's body. An inferred type died
after one hop:

```nova
fn cdot(a, b)          // reached ONLY through cfwd -- no direct call anywhere
    a.cx * b.cx + a.cy * b.cy
fn cfwd(p, q)
    cdot(p, q)         // main taught the pass that cfwd takes CPt; cdot still saw two unknowns
```

**Fix.** Thread the previous round's result back in (`prev_fpt`) and seed `st` from it, so types
propagate; and report movement (`chg["n"]`) so the driver's existing fixpoint keeps iterating.
That last part is load-bearing and was easy to miss: the loop already ran up to six rounds, but
`changed` was set only by **return**-type refinement, so it stopped as soon as those settled and
dropped a param type mid-propagation. Verified at two hops, not one, so it is a real fixpoint
rather than one extra hardcoded level.

`chain1 0` / `chain2 0` → `14.5` / `14.5`, and `@cdot` lowers to `fmul`/`fadd` with zero
`nova_rt_*`. Both are now gated (Rules 6, below).

**It also exposed a latent library bug, which is the interesting part.** `_pack_float_kat`'s
round-trip started failing: 1.0 packed as ~4.6e18. Not a compiler regression — chaining resolved a
call site that had previously been invisible, and that new knowledge *conflicted*, so
`pack_f64_be(v)` correctly widened from `float` to `any`. The two have **opposite** conventions:

| param | who is responsible for boxing a float |
|---|---|
| declared `float` | the CALLEE — it unboxes defensively, so raw *or* boxed both read correctly |
| `any` | the CALLER — and a caller holding an already-`any` value has nothing to box with |

`_pack_one` passes a list element it cannot type, so raw double bits reached `float_to_bits`, which
converts NUMERICALLY. The right fix is the annotation the function always deserved —
`pack_f64_be(v: float)` (and `_le`, plus both `f32` forms) — because a declared-`float` param is
the representation-**tolerant** contract. Left unannotated, a function that takes a float is one
un-typeable caller away from silently wrong bytes on the wire.

### ⚠ 3.1 SCALAR PARITY — MEASURED AT 1.00x C, THEN **REVERTED**. Read this before retrying.

**The win is real and reproducible: 34 ms vs C's 34 ms**, down from 61 ms (1.74x), on
`_f31_scalar.nova` vs `_f31_scalar.c`. It required exactly two changes together:

| variant | time | vs C (34 ms) |
|---|---|---|
| shipped HEAD | 61 ms | 1.74x |
| remove the callee-entry unbox only | 63 ms | 1.80x |
| `internal` linkage only | 60 ms | 1.71x |
| **both** | **34 ms** | **1.00x** |

**Neither does anything alone.** LLVM will not inline a function with external linkage, and will not
keep an inlined body in registers while it still calls into the runtime. The plan previously blamed
the residual purely on `nova_rt_unbox`; that is at most half right — Phase 1 had already reduced the
unbox to a two-load fast reject, so removing it changes nothing on its own. The missing half is that
NOVA emits every user function `external`, so LLVM can never prove there are no other callers. C's
`axpy` is `static`.

**WHY IT WAS REVERTED.** Removing the callee-entry unbox makes every float-param callee assume raw
bits, which is only sound if EVERY call site normalises. Four separate classes of call site turned
out to violate that, three of which were found and fixed, and one of which is still unexplained:

| # | invisible/unsound call site | symptom | status |
|---|---|---|---|
| 1 | address-taken fn reached via a `__fnref_` closure | pointer read as double | fixed (exclude from `b.ir_tramps`) |
| 2 | `frt[fn] == "float"` is NOT "returns raw" — `determinant` returns a box on one of two paths | `linalg_lib_test: det=5` | fixed (proof-gate on `ir_reg_is_raw_double`) |
| 3 | the `@cdecl` ABI wrapper — emitted directly by the backend, never lowered as an IrFunction, and it BOXES its incoming C double | `dmul(2.5,4.0) = 0` | fixed (pass raw; gate on the NOVA annotation, since `float`/`f64`/`double` all map to C `double` but only `float` becomes an IrType float) |
| 4 | **unexplained** — still unidentified; see the correction below | `_polyderiv_test: got=4.886e18 want=2.0` | **NOT understood** |

25 float-math tests regressed in total (`_poly*`, `_dist_*`, `_geo_*`, `_dms`, `_shannon`,
`_matsolve`, …). Fixing #1-#3 recovered 23 of them. The last two (`_polyderiv_test`,
`_polyinterp_test`) resisted, and a three-way toggle bisect gave a result that contradicts the
runtime source:

- all three sub-changes OFF -> PASS
- call-site normalisation ON -> value corrupted to 4.886e18
- normalisation OFF, callee-raw ON -> value CORRECT (2.0) but the comparison fails

**CORRECTION (2026-08-25), tested directly.** The first write-up blamed the normalisation
insertion itself. That is WRONG, and the experiment is cheap enough that it should have been run
before writing the claim down: take the HEAD compiler's own `_polyderiv_test.ll` (which passes),
hand-insert exactly one `nova_rt_unbox` at the `approx` call site, change nothing else, relink --
**it still passes**. So inserting the call is innocent, which also matches the runtime source
(`if (cannot_be_box) return handle;` over a `NOVA_NOINLINE` slow path that only dereferences a
genuine box).

The corruption therefore comes from a SIDE EFFECT of how the compiler inserts it, not from the call.
The prime suspect is the type assigned to the new register (`ir_type_float()` plus `rt[nmr] =
"float"`), which is visible to later inference and can change downstream decisions for the callee --
but that was not confirmed, so it stays an open question rather than a conclusion.

Shipping on top of an unexplained float corruption is not acceptable, so the whole change was
reverted to HEAD and `_f31_unbox_elim_gate.ps1` was UNWIRED from nova_ci (stage 2k9 removed) because
it fails without it.

**⚠ AND RESTORE THE BINARY WHEN REVERTING SOURCE.** The 3.1 arc reconverged successfully before the
regression failed, so it had already installed its gen5 as `gen3_test.exe`. Reverting
`nova_compiler.nova` alone left the working-tree binary containing the reverted-away code -- every
later test would have silently run the wrong compiler. Same class as the stale-`.ll` trap above:
after a revert, `git checkout` the built artifacts too.

**WHAT SURVIVES for the next attempt** (all committed, all currently passing):
- `_f31_unbox_elim_probe.nova` + `_f31_export_linkage_probe.nova` + `_f31_unbox_elim_gate.ps1`
  (9/9 when the change is present) — the falsifiable spec, teeth-checked.
- The measurement table above, and the fact that BOTH changes are required.
- `_f31_scalar_run`-style runners now ASSERT the IR they are about to time (`define internal i64
  @axpy`). Without that assertion the first reading was 1.69x from a STALE `.ll` served by the mtime
  cache, and the change would have been discarded as useless.

**THE LESSON, which generalises past 3.1.** "Remove the defensive unbox" is a whole-program
obligation, not a local optimisation: it is sound only if every call site normalises, and NOVA has at
least four ways for a call site to be invisible to an IR-level pass — closures via trampolines,
box-on-one-path returns, backend-generated ABI wrappers, and inferred (not declared) float params
that `ir_infer_types` rewrites so they look declared. A future attempt should enumerate call-site
kinds FIRST and prove coverage, rather than fixing them one regression at a time.

**THE UNEXPLAINED #4 NOW HAS A MECHANISM (2026-08-25, from the float-array work).**

The array half of 3.1 reproduced the same failure shape in miniature, which is what finally named it.
Inlining the float element read measured 120 ms instead of the expected 99 ms. Cause: the inline
changed the value's PROVENANCE. The emitter recognises `call nova_rt_list_get_f` as proven-raw but
does NOT recognise a `phi`, so it silently inserted a defensive `nova_rt_unbox` before every `fadd` --
trading one call per element for a different call per element, with every correctness test green. One
`ire_mark_float` fixed it.

So the rule, stated generally: **inserting or replacing an instruction changes what the emitter
believes about that register, and it silently adds or removes unboxes downstream.** The value is
unchanged; the emitter's belief about its REPRESENTATION is not.

That is almost certainly what corrupted `_polyderiv_test`. Reading the working HEAD IR for `approx`
shows the callee does NOT unbox at entry -- it unboxes AT THE POINT OF USE, on the slot load:
```
%r0       = load i64, ptr %slot.a
%r2.af.ub = call i64 @nova_rt_unbox(i64 %r0)   ; a slot_load is not proven-raw
%r2.af    = bitcast i64 %r2.af.ub to double
%r2.rf    = fsub double %r2.af, %r2.bf
```
The reverted change inserted a normalisation register at the CALL SITE and marked it `rt[nmr] =
"float"`. Everything downstream that consults that marking -- `ir_reg_is_raw_double`, the float-slot
pre-pass, `ire_float_load` -- then saw a different answer for that register, which is exactly the
mechanism above. The bisect fits: corruption appeared whenever normalisation was ON, independent of
the callee-side marking, because the damage was on the CALLER side.

**The bounded experiment for the next attempt** (do this FIRST, before re-applying anything):
insert the normalisation WITHOUT marking the new register float, and see whether `_polyderiv_test`
passes. That isolates the marking from the instruction in one build. If it passes, the fix is to make
the marking match reality rather than asserting it -- the same one-line shape as `ire_mark_float` on
the array read.

Note the array fix also changed `ck_flist`'s `got[i] * 1.0` codegen, so this experiment must be
re-run against current HEAD rather than reasoning from yesterday's IR.

**EXPERIMENT RUN 2026-08-26 — four hypotheses tested, three ELIMINATED.**

Rebuilt the change as four independent toggles rather than one patch, so each claim could be tested
on its own. Reproducer narrowed to THREE tests: `_polyderiv_test`, `_polyinterp_test`,
`optimizers_lib_test`.

| # | configuration | result |
|---|---|---|
| 1 | control (nothing on) | all 10 clean |
| 2 | call-site normalisation, keyed on the ARGUMENT being float-typed | all 10 clean |
| 3 | + callee-side param-slot marked raw | **6 broken** |
| 4 | normalisation keyed on the PARAM type (the correct rule) | **3 broken** |
| 5 | 4, but without `rt[nmr] = "float"` | 3 broken (same) |
| 6 | 5, but instruction typed `any` instead of `float` | 3 broken (same) |

What this establishes, and it is the opposite of what the revert note assumed:

* **The callee-side marking is what needs normalisation** (row 3): with the callee still unboxing,
  narrow normalisation is harmless; the moment the callee assumes raw, six tests break. So the
  call-site coverage is the real problem, exactly as the "whole-program obligation" lesson said.
* **Normalisation must be keyed on the PARAM type, not the argument type.** Row 2 looked clean only
  because it did almost nothing -- an `any`-typed argument reaching a float param got no
  normalisation at all, which is precisely the hole.
* **Three suspects are ELIMINATED.** Rows 4/5/6 are identical, so the breakage is NOT the `rt[]`
  float marking, NOT the instruction's IR type, and NOT the two combined. The provenance theory from
  2026-08-25 was reasonable -- it is what the float-array bug turned out to be -- but it is wrong
  here, and the toggles say so unambiguously.

**What is left, and the next experiment.** A bare `nova_rt_unbox` is semantically a NO-OP on a
non-box (`if (cannot_be_box) return handle;`), so inserting one cannot change a value. Yet inserting
it breaks three tests. The remaining candidate is therefore not the value but the OWNERSHIP: the
inserted SSA temp holds a heap pointer and is tagged `effect = "pure"`, and the RC pass inserts
drops for temps. A `rc_drop_temp` on that new register would free a value still live through the
original register -- which would present exactly like this, as a use-after-free that only shows up
in float-heavy code where the same value flows through several calls.

Next: emit the normalisation with a non-droppable effect tag (or exclude `%wnorm*` from the RC
temp-drop set) and re-run rows 4-6. If that clears them, the whole 3.1 scalar path is unblocked,
because rows 2/3 already show the rest of the mechanism works.

**Also relevant:** the array fix of 2026-08-25 changed the codegen of `got[i] * 1.0`, and the
2026-08-25 "unexplained #4" no longer reproduces at all under row 2. So do NOT reason from
yesterday's IR dumps; re-measure.

### ROOT CAUSE FOUND 2026-08-26 — the "unexplained #4" was a missing builtin exclusion

**It was one condition.** Normalisation was firing on `nova_rt_*` BUILTINS as well as user
functions, because `fpt` carries entries for both. The damage:

```
-  %r47 = call i64 @nova_rt_list_append(i64 %r45, i64 %r46)
+  %r47 = call i64 @nova_rt_list_append(i64 %r45, i64 %wnorm3)
```

`nova_rt_list_append` expects a BOXED float so the list stays heterogeneous-safe. Unboxing the
argument stored raw double bits where a box belongs, and the value was misread coming out. Fix:
`and not starts_with(value, "nova_rt_")`.

**How it was finally found, after three wrong theories** (provenance marking, instruction type, the
RC pass -- all eliminated by toggles): by diffing the WHOLE emitted module instead of the two
functions the failing assertion named. The diff inside `approx`/`ck_flist` was real but HARMLESS --
hand-inserting exactly those unboxes into the working IR changed nothing. The damage was in a
`list_append` the assertion never mentioned. The lesson is cheap and general: **diff the whole
module, not the function the error points at.**

With that one condition added: **38/38 float tests clean**, including all 25 that regressed on
2026-08-25, with call-site normalisation AND the callee-side param slot marked raw.

### What the change now produces (structural, verified)

`axpy(a: float, x: float, y: float) -> float` emits exactly what C does:
```
define internal i64 @axpy(i64 %p0, i64 %p1, i64 %p2)
  %r2.af = bitcast i64 %r0 to double      ; no nova_rt_unbox
  %r2.rf = fmul double %r2.af, %r2.bf
  %r4.rf = fadd double %r4.af, %r4.bf
```
`internal` linkage + zero defensive unboxes. Whole-module unbox count 5 -> 4.

### WHAT IS STILL MISSING, precisely

Two unboxes remain AT THE CALL SITE in the hot loop:
```
%wnorm0 = call i64 @nova_rt_unbox(i64 %r8)   ; %r8 = load slot.a
%wnorm1 = call i64 @nova_rt_unbox(i64 %r9)   ; %r9 = load slot.acc
%r11    = call i64 @axpy(i64 %wnorm0, i64 %wnorm1, i64 %r10)
```
Both arguments are `slot_load`s, and the proof-gate correctly refuses to call a slot raw (a slot can
hold a box on another path). So the cost was RELOCATED from callee to caller, not removed.

The fix needs an ALWAYS-FLOAT SLOT analysis: a slot is raw everywhere iff every store into it stores
a provably-raw value. Written and working (`ire_float_slot_prepass`), but in the wrong LAYER -- it
marks the EMITTER's slot table, while the proof-gate that decides normalisation runs at the IR level
in `ir_infer_block`. Those are separate states, so the marks are invisible to it. The remaining work
is to run that analysis at the IR level and stash it in `rt` (e.g. `rt["@fslot@"]`) so the proof-gate
can consult it, then treat a `slot_load` from an always-float slot as proven raw.

### Measurement is NOT yet possible on this machine

Three interleaved best-of-5 runs of a deterministic benchmark gave baseline 1.36x / 1.82x / 2.04x and
the change 1.14x / 1.61x / 2.09x. C itself swung 47-69 ms. Two of three favour the change and one
does not: the noise (IDE + browser on the same box) exceeds the effect. **Do not claim a ratio from
this machine.** `_f31_scalar_det.nova` / `.c` were added for exactly this reason -- the original
`_f31_scalar` seeds `a` from `time_ms()`, and since `acc = a*acc + 0.5` compounds 20M times the seed
decides whether it overflows to inf, which changes the RUNTIME as well as the value. A benchmark
whose speed depends on the clock cannot measure a 10% codegen effect.

The experiment is preserved at `/tmp/_nc_31exp.nova` (all behind `NOVA_EXP_NORM` / `NOVA_EXP_PSLOT` /
`NOVA_EXP_LINK`) and is NOT committed: the remaining layer fix and a quiet-machine measurement both
have to land before it is worth an arc.

**STILL OPEN — the float ARRAY half.** ~1.7x, a different mechanism (element representation, not the
call boundary), untouched by any of this. The reading was taken with an arc running (167/247/176 ms
spread) so it needs a quiet machine before being trusted.

#### ⚠ OPEN GAP — address-taken function + raw float field (`_f31_polyfield_known_gap.nova`)

Found by the adversarial half of the same probe. Pre-existing, verified against the previously
committed compiler. Prints `poly 1.5 3.45845952088873e-323` where `poly 1.5 7` is correct.

Specializing a parameter from call sites is only valid when every call site is visible. A function
referenced by name lowers to a `make_closure` over a `__fnref_` trampoline, and that closure can be
invoked from anywhere. `poly` is specialized to `CPt` on the strength of its one visible direct
call, `frt["poly"]` is then labelled float, and the closure path reads `QPt`'s **int** field through
that float label.

**Three fixes were tried and every one was a lateral move — a different wrong answer, not a better
one.** Recording them so they are not re-attempted:

| attempt | result |
|---|---|
| Exclude address-taken fns from specialization | closure call right, **direct** call now wrong (`poly(p)` → `4609434218613702656`, the bits of 1.5 as an integer) |
| Route un-inferrable field reads via `nova_rt_field_get` at **lowering** | correct mechanism, wrong time — the param fixpoint has not run, so every unannotated struct param still looks un-inferrable and `sdot` fell from `fmul` to a runtime name walk |
| Same routing, **after** the fixpoint (right placement) | still wrong: non-`@repr(C)` structs are SROA'd onto the stack, and `field_get`'s tag guard accepts only heap structs → returned null, `poly(p)` → `0` |

A real fix has to establish the invariant *a float in an `any` context is always boxed*, and that
spans three things at once: struct float fields are stored as raw doubles; SROA removes the runtime
tag the by-name helper depends on; and `frt` is monotone-refining, so a return type once published
as float cannot be widened. That is VALUE_MODEL_OVERHAUL work, not a patch — which is why it is
tracked here with an executable repro instead of being half-done.

### ✅ 3.4 CLOSED (2026-08-24) — zero-copy read-only buffer views

`bytes_slice` memcpy's, which was the confirmed gap. The fix is **additive**: `bytes_view(b, start,
end)` is O(1) with no payload allocation, and `bytes_slice` keeps copying.

**Why not just make `slice` a view.** Copying IS slice's contract — callers are entitled to mutate
the result. Turning it into a view would silently alias every existing caller's buffer, which is the
same silent-corruption class as the float bugs above. The KAT asserts this directly, so it FAILS if
anyone later "optimises" slice into a view.

**How zero-copy is proven.** By observable aliasing — write the parent, read it back through the
view — not by timing and not by reading IR. Aliasing can only hold if no copy was made, and unlike a
benchmark it cannot pass by luck on a fast machine.

**Encoding.** `NovaBytes` gains one field, `owner`: non-zero means the struct borrows `data` from
that parent, which is `rc_inc`'d at creation and `rc_dec`'d in `rc_free` (so a view outliving the
scope that built its parent — the ordinary case — is safe, and a chain of views unwinds one hop at a
time). `NOVA_BYTES_IS_VIEW` is the single predicate.

**Writes through a view abort loudly.** A silent no-op loses data; an allowed write corrupts a
buffer the writer does not own. Both are the silent-wrong-data class. `bytes_append` is why the guard
is mandatory rather than cosmetic: on a view `size >= cap` holds by construction, so an unguarded
append would call `nova_back_grow` on **borrowed** storage and realloc the parent's buffer out from
under it. The audit surface is exactly three functions — `bytes_set`, `bytes_append`,
`bytes_append_str` — because `NovaBuffer` is a separate type.

**Two bugs the probes caught before this could ship, both worth remembering:**

1. The first encoding also set `cap = 0` as a redundant view marker. That silently broke `find_tag`,
   whose structural validation is `cap < size -> reject` — a *security* predicate whose own comment
   warns that weakening it reintroduces a CVE-class wild read. So a view stopped being recognised as
   bytes by every polymorphic path: `==`, `str()`, `deep_copy`, `json`. Caught **only** by the
   `view == copy` assertion in the integration section — the happy-path assertions all passed.
   Fixed with `cap = size`; `owner` is the sole marker. Lesson: assert that a new value type works
   everywhere its type works, not just in the feature's own code path.
2. `sizeof(NovaBytes)` went 24 -> 32, but `find_tag` still bounds-checked `ptr + 24` while the
   mutation guards read offset 24..32. Tightened to `+32`, which rejects nothing legitimate (every
   bytes struct is now a 32-byte allocation) and matches the `TARRAY` arm's existing `+32`.

**Gated:** `_bytes_view_gate.ps1`, CI stage 2k8, 4/4 — including a NEGATIVE test
(`_bytes_view_ro_neg.nova`) that must abort. A gate checking only the happy path would pass just as
well with the read-only guard deleted.

**Also fixed in the harness:** `_impact_gate.ps1` now understands the `*_neg` expected-fail
convention (non-zero exit = pass, and a `_neg` test that *succeeds* is a real failure). Without it a
`-Match` sweep reported every negative test as broken, which trains you to ignore gate output.

#### Tooling: `_impact_gate.ps1` — the fast loop

`nova_ci.ps1` is all-2862-or-nothing at ~35 min, which made it useless for iteration and meant
compiler changes were being checked either far too slowly or not at all. `_impact_gate.ps1` runs a
NAMED subset plus named gate scripts through the **same** worker as the full regression — extracted
to `_test_worker.ps1` and dot-sourced by both, so the two can never drift about what PASS means.

The six tests above plus the 9/9 gate: **35 seconds**. Same evidence, 60x faster.

It is explicitly *not* a substitute for `nova_ci` before committing compiler or runtime changes,
and the script says so at the top: param-type and return-type inference are whole-program analyses,
so those changes have no local blast radius to reason about. This session is the proof — three
lines changed in `ir_collect_param_types` broke three tests that have nothing to do with the
feature, via a forwarding call in a file nobody had opened.

---

### ✅ 3.3 CLOSED (2026-08-22) — erasure is zero-cost; the float tax is the CALLING CONVENTION, not generics

The item's title was premised on monomorphization. NOVA does **type erasure** (one i64-shaped
function), so the real question is "does erasure cost anything at runtime". Measured, not argued —
`_gen_zerocost.nova` + `_gz_run.ps1`.

**Structural evidence (decisive).** The erased generic and the fully-typed concrete function emit
**byte-identical LLVM IR** — same instructions, same registers, same order:

| pair | result |
|---|---|
| `gadd(a, b)` (erased) vs `iadd(a: int, b: int) -> int` | identical: `load`/`load`/`add i64`/`ret` |
| `gmul(a, b)` (erased) vs `fmul_c(a: float, b: float) -> float` | identical: 2×`nova_rt_unbox`/`bitcast`/`fmul double`/`bitcast`/`ret` |

Identical code cannot be systematically slower, so this settles it without needing timings. Timings
agree anyway: float 101/102, 104/104, 103/91 ms over 20M iterations — the ordering flips, so the
gap is run-to-run noise.

**⚠️ Two measurement traps caught here, both worth remembering:**
1. The first int benchmark reported `generic=0ms concrete=0ms`. Not "infinitely fast" — LLVM
   recognised the arithmetic series and replaced the whole loop with a closed form. The accumulator
   was *correct*, which is what made it look like a valid result. Fixed by deriving every input from
   `time_ms()` so nothing is compile-time knowable. **A benchmark that folds away measures nothing
   and looks fantastic** — same lesson as the module-`let`-reads-0 bug.
2. I predicted the float generic would cost more (boxing at the any-widen). **Wrong** — and the
   reason matters more than the prediction.

**The real finding, and it belongs to 3.1.** `fmul_c` is declared `(a: float, b: float) -> float`
with zero generics involved, and it *still* calls `nova_rt_unbox` on both parameters. The float
boxing tax is not a generics problem — it is in the **uniform i64 calling convention**: every float
crossing a call boundary is boxed regardless of how precisely it is typed. That is the mechanism
behind the long-standing "float ≈1.7× C" number, and it is the concrete lead for **3.1**. The
earlier `readonly` work on `nova_rt_unbox` (CI gate 2b4, 8→2 surviving calls at -O2) was already
chipping at exactly this surface.

---

### ❌ 3.6 `@stack` — REJECTED: NOVA already does this automatically, and better

`ir_stackable_structs(typed_fn, escape_summary, all_scalar)` computes the set of structs that
provably do not escape, and the emitter turns each one into
`alloca [N x i64], align 8` instead of a heap allocation. **SROA is ON BY DEFAULT** —
`NOVA_NO_SROA=1` opts *out*, not in — and `sroa_stress_test` is in the regression.

So a `@stack` annotation would be **redundant with an existing automatic optimisation**, and worse,
it would violate the project's own principle: *the compiler is the genius, not the developer.* A hint
can only agree with escape analysis (adds nothing) or contradict it (must be ignored, or it is a
use-after-free). Zig needs explicit allocators because it has no GC/RC and refuses hidden control
flow; NOVA has escape analysis and can simply decide. Nothing to build.

### ✅ 7.2 C header import — already exists as `bindgen`

`bindgen.nova` parses C prototypes and emits `extern fn name(args) -> ret`, mapping C types to NOVA
(`char*` -> string, `double`/`float` -> float, other pointers -> int, `int`/`long`/`short`/`size_t`
-> int, `void` return -> int). Wrapping a C library is a one-liner instead of hand-writing every
extern. Already in `_run_final_regression.ps1` and passing.

Not a full C preprocessor — it handles simple prototypes, "the common 90%" by its own description.
A real header parser (macros, typedefs, structs, conditional compilation) is a much larger thing, and
worth doing only if the 90% proves insufficient in practice.

### ⚠ 3.4 Buffer views — genuinely open, and now precisely scoped

Confirmed by reading the runtime: `nova_rt_bytes_slice` **allocates and `memcpy`s**:

```c
if (nb && nb->data) memcpy(nb->data, b->data + start, (size_t)new_size);
```

So every slice is a copy. A real zero-copy view needs a **new value kind** carrying a pointer into
the parent's buffer, a length, and — critically — a **reference to the parent** so RC keeps the
backing store alive. That last part is the whole difficulty: without it, a view outliving its parent
is a use-after-free, and NOVA has no borrow checker to prevent it statically.

It also touches every consumer that assumes bytes own their data: indexing, `len`, equality,
hashing, printing, channel send (deep copy), and the RC drop path. That is a value-model change with
a memory-safety failure mode — a multi-session item with its own full arc, not something to bolt on.

## PHASE 4 — CONCURRENCY (match Go, approach Erlang)

| # | Feature | From | Effort | Status |
|---|---------|------|--------|--------|
| 4.1 | N>1 concurrency scaling | Go | L | **✅ MEASURED GOOD 2026-08-20 — 1.95x at 4 carriers** |
| 4.2 | Work-stealing between carriers | Go/Java FJP | L | **❌ REJECTED 2026-08-21 — measured strictly worse than decomposition** |
| 4.3 | Preemptive scheduling (yield at loop back-edges) | Erlang | M | **✅ DONE 2026-08-27** — safepoints on green-reachable loop headers ONLY, so spawn-free compute code stays UNinstrumented (0 checks) and GATE 4/5 perf is untouched. Fairness holds with `NOVA_CARRIERS=1`, and `kill()` now reaches a compute-bound task (previously documented as impossible). `NOVA_REDUCTIONS=0` genuinely disables it. Gate `_preempt_gate` 5/5, CI 2m4 |
| 4.4 | Supervision trees (library) | Erlang | S | **✅ ALREADY EXISTS** (`forge_otp.nova`: `sup_new`/`child_add`/`sup_start`/restart intensity) |
| 4.5 | Small fiber stacks (4KB initial, grow on demand) | Erlang | M | **✅ ALREADY EXISTS** — `NOVA_FIBER_COMMIT_SIZE 4096` |
| 4.6 | `nova watch` (fast restart < 0.5s) | Erlang/Go | S | **✅ DONE 2026-08-21 — 369 ms save-to-running** |
| 4.6b | Incremental cache ignored IMPORTED files (stale builds) | — | S | **✅ FIXED 2026-08-21 — found via 4.6** |
| 4.7 | Distributed channels (network transport) | Erlang | XL | **✅ DONE 2026-08-27** — the transport already existed and was *ungated*, which is the real failure this closed: `remote_send` moved off lossy JSON framing onto the lossless term codec, a wire-version byte is now written AND validated (an incompatible peer gets a clean error, not JSON term-decoded into plausible garbage), and four formerly-unrun programs are in the manifest. Gate `_remote_gate` 7/7, CI 2m5 |

---

### ✅ 4.1 N>1 scaling — the "regression" was never measured, and it isn't one

This item was carrying the label *"the one fix worth more than everything else combined"*, on the
strength of a **0.76–0.82× single-core** figure. That figure had **no live measurement anywhere**:
`_n_carriers_ci` (CI stage 2b) proves *correctness* at 4/8 carriers and says nothing about speed,
and all six `bench/programs` are single-threaded. Nothing in the repo measured parallel speedup.

Built `_par_scale_bench.nova` + `_par_scale_bench.ps1` — strong scaling (total work held constant,
per-worker slice shrinks), CPU-bound allocation-free inner loop, one channel fan-in, best-of-3 per
carrier count, and a **carrier-independent checksum** so a run that lost or duplicated work is
rejected instead of timed.

| NOVA_CARRIERS | 1 | 2 | 4 | 8 |
|---|---|---|---|---|
| best of 3 | 287.9 ms | 227.8 ms | 147.3 ms | 129.4 ms |
| speedup | 1.00x | 1.26x | **1.95x** | 2.23x |

Host is 4 physical / 8 logical cores, so 1.95x at N=4 is ~49% parallel efficiency and 2.23x at N=8
is hyperthreading behaving as expected. **1.95x exceeds the 1.8x four-worker bar** in
`.claude/rules/compiler-architecture.md`.

**Why this matters competitively.** Rust's async is *colored*, permanently, at the language level;
its core team has been publicly stuck on effect-polymorphism/keyword-generics for years. A `spawn`
that scales positively with cores and needs no `async`/`await` coloring is an advantage Rust cannot
retrofit. That claim was previously unavailable because the number said the opposite. It is now
available and measured.

**Gated** at CI stage **2b2**, threshold 1.30x at N=4 — deliberately well below the measured 1.95x,
because the gate's job is to catch a return to <1.0x, not to police a few percent on a
memory-pressured host. The real speedup prints on every run, so erosion is visible early.

**Honest remaining headroom:** there is still **no work-stealing** between carriers, so an unbalanced
workload can leave carriers idle; ~49% efficiency at 4 cores says fan-in and scheduling overhead are
real. That is item 4.2, and it is now an *optimization* rather than a rescue.

**⚠ The measurement trap this exposed — worth more than the number.** The benchmark's first run
reported a healthy 60 ms and a checksum of `36`, which is exactly `1+2+…+8`: every worker had
returned its seed untouched, because `let PER = TOTAL / WORKERS` at module level silently evaluated
to **0** (a genuine compiler bug, found and fixed because of this). Without the checksum, "60 ms"
would have been recorded as an excellent result. **Every benchmark must assert that the work
happened.** A number measured against a silently-empty loop is worse than no number.

### ❌ 4.2 Work-stealing — REJECTED on evidence, not deferred

Three measurements, total work held constant, 4 carriers, best-of-3 (`_par_grain_probe.nova`,
`_par_skew_probe.nova`):

**1. On a BALANCED load, speedup is flat across granularity** — so the loss is not uneven initial
claim, which finer tasks would average out:

| equal tasks | 4 | 8 | 16 | 32 | 64 |
|---|---|---|---|---|---|
| speedup | 2.68x | 2.58x | **2.72x** | 2.45x | 1.93x (spawn overhead) |

**2. Skew is where it hurts** — and the N=1 times confirm identical total work:

| shape | N=1 | N=4 | speedup |
|---|---|---|---|
| balanced, 8 × 2 units | 366.4 ms | 181.1 ms | 2.02x |
| skewed, 7 × 1 + 1 × 9 units | 370.2 ms | 272.3 ms | **1.36x** |
| **split, 16 × 1 units** (same work as skewed) | 363.7 ms | **134.1 ms** | **2.71x** |

**3. Why stealing loses to decomposition, structurally.** Work-stealing can only relocate *whole
tasks*, so on the skewed shape its best possible result is bounded by the single longest task:
9/16 × 370 ms ≈ 208 ms ≈ 1.78x. Decomposition measured **134 ms / 2.71x** — better than *perfect*
stealing could ever be, because it removes the bound rather than routing around it.

**4. And stealing is the one thing this scheduler must not do.** Green tasks are pinned to a home
carrier on first claim, immutable thereafter (`71a651d`). That pinning was not a convenience — it was
the *fix* for the carrier-wedge hang (a migrated fiber wedges its carrier inside `SwitchToFiber`, so
`park_committed` never advances and the waker spins forever). Three separate wake-side fixes
(deferred-wake, per-park epoch, rescue sweep) all failed; only eliminating migration worked.
**Work-stealing IS migration.** Re-introducing it would restore the precondition of a bug that took
multiple sessions and two independent investigations to kill.

**Conclusion:** worse payoff, higher ceiling already beaten by a safe technique, and it reopens the
worst bug in the runtime's history. The correct deliverable is a **decomposition helper** —
a `parallel_map`-style chunker targeting ~4× carrier count — plus the guidance that a parallel job
should be split into many small tasks rather than a few large ones. Tracked as **4.2b**.

*Generalisable: "add work-stealing" was in the plan as an obvious-sounding L-effort item. One
afternoon of measurement showed the cheap alternative is strictly better AND safer. Measure the
alternative before building the sophisticated thing.*

| 4.2b | Decomposition helper | — | S | **✅ ALREADY EXISTED (`pmap`/`pfilter`/`pfor`) — found a silent threshold trap and fixed it** |

### ✅ 4.2b — the helper already existed, and measuring it found a real trap

Grepped before building (fourth time this saved rebuilding something): **`pmap`, `pfilter` and
`pfor` are already builtins** with proper generic signatures —
`pmap(list<T>, fn(T) -> U) -> list<U>` — so no new helper was needed. What *was* needed was
measuring them, which surfaced two facts that decide when they help.

**Fact 1 — `nova_pmap_threshold = 256` is a hard cliff, and it counts ELEMENTS, not WORK.**
Total work held constant (24M iterations either way), uniform per-element cost:

| elements | 32 | 255 | **256** |
|---|---|---|---|
| time | 228 ms | 212 ms | **82 ms** |

255 elements runs entirely serial; 256 runs parallel. **A 2.7x difference decided by one element** —
and below the threshold a short list of expensive items gets *no parallelism and no diagnostic*.
`nova_pmap_thread_count` returns 1, so `pmap` quietly falls back to `list_map`.

**Fix: `NOVA_PMAP_THRESHOLD`** (all three builtins share `nova_pmap_thread_count`, so one change
covers them). There is no sound way to auto-detect per-element cost — you would have to run the
closure to find out — so rather than guess, the threshold is now settable. Unset ⇒ 256 ⇒
byte-identical to before. Measured with `NOVA_PMAP_THRESHOLD=1`:

| elements | 32 | 255 | 256 |
|---|---|---|---|
| default | 228 ms | 212 ms | 82 ms |
| threshold=1 | **87 ms** | **77 ms** | 65 ms |

**2.6–2.7x unlocked** for small-but-expensive lists, with byte-identical checksums in every
configuration. Gated by `_pmap_threshold_gate.ps1` (CI stage **2b3**), which asserts the serial and
threaded paths agree **order-exactly** — `pmap` writes an indexed output array, so a chunking bug
would silently reorder or drop results, and a length-or-sum check would miss it. Correctness only:
the speedup lives in this document because a timing gate would flake on this host.

**Fact 2 — `pmap` uses static contiguous chunking, so it does NOT fix skew.** With all the work in
one element the skewed case stays at serial speed (~210–234 ms) at every element count and threshold
setting, because one chunk pins one thread. That is consistent with the 4.2 finding and completes the
guidance:

| your workload | use |
|---|---|
| many elements, **uniform** cost | `pmap`/`pfilter`/`pfor` (2.7x; already parallel above 256) |
| **few** elements, expensive, uniform | same, plus `NOVA_PMAP_THRESHOLD=1` (2.6x) |
| **skewed** per-element cost | `spawn` + channel fan-in, decomposed into many small tasks (2.71x) |

*Note: `pmap` runs on the OS thread pool, NOT the green carriers — so it is orthogonal to the
`NOVA_CARRIERS` scaling in 4.1, and the 4.2 rejection of green-scheduler work-stealing does not
apply to it.*

### ✅ 4.6 `nova watch` — and the much bigger bug it uncovered

**`nova watch <file.nova>`**: rebuild + rerun on save, **369 ms** from edit to running output.
The 170 ms self-compile speed already existed; nothing surfaced it. Two deliberate choices:

- **Watches every `.nova` in the entry file's directory**, not just the entry file. A project's
  imports sit beside it, and a watcher that misses them silently reruns stale code — worse than not
  watching at all.
- **Re-invokes `self run <file>` as a child process** rather than compiling in-process, so a compile
  error, panic or crash kills only the child. The watch loop is the one thing that must not die.

### ⚠ 4.6b The real find: the incremental cache ignored IMPORTED files

Building `watch` exposed a **pre-existing bug that hits every multi-file project**.
`nova_compile_file`'s cache check compared **only the entry file's mtime** against the output:

```nova
// app.nova imports helper.nova, and app.nova is never edited
let in_mt = build_file_mtime(input_path)     // <- entry file ONLY
if in_mt > 0 and out_mt >= in_mt: return output_path
```

Reproduced directly: change `helper.compute()` from 41 → 99 → 777 and `nova run app.nova` keeps
printing the previous value. **Edit a library module, run your app, get the old behaviour with no
warning.** Silent stale builds — the same class this whole campaign exists to remove, sitting in the
build path the entire time.

**Fix:** compare against the newest mtime across the entry file **and its transitive imports**
(`nova_newest_source_mtime`). The dependency scan is **lexical**, not a parse — this check runs
*before* parsing on purpose, and `import <name>` at line start is enough to find the file set. It
**fails safe**: an unreadable mtime or an unresolvable import returns 0, which the caller treats as
"cache unusable" and rebuilds. Being wrong costs a recompile; being wrong the other way runs old code.
A `seen` set handles import cycles and diamond dependencies.

**Gate `_incr_import_gate.ps1` (CI stage 2c3) asserts BOTH directions**, because either alone is
passable by a broken build: an import edit must invalidate, **and** an unchanged rerun must still hit
the cache — a "fix" that simply disabled caching would pass the first test while destroying the
170 ms build that makes `watch` worth having. Verified the gate genuinely detects the defect: it
**fails on the pre-fix compiler** and passes after.

*How it surfaced: `watch` originally forced `NOVA_NO_CACHE=1` through a
`cmd /c "set X=1 && ..."` wrapper. The nested quoting silently failed to pass the variable — so the
rebuild used the cache and printed stale output, which is what made the underlying bug visible. The
wrapper is gone now (the cache is correct, so it is unnecessary), but note the Windows quoting rule
it taught: `cmd /c ""prog" "args""` needs the doubled outer quotes, because cmd strips them when a
command both begins and ends with a quote — the bare form exits 1 in ~45 ms before any compile.*

## PHASE 5 — PLATFORM REACH (run everywhere)

| # | Feature | From | Effort | Status |
|---|---------|------|--------|--------|
| 5.1 | Linux native build | Go/Rust/all | M | WSL-once exists |
| 5.2 | macOS native build | Swift/all | L | needs hardware |
| 5.3 | WASM compilation target (LLVM wasm32) | JS/Rust | L | **✅ SUBSTANTIALLY EXISTS** — 9 WASM CI gates incl. native-vs-wasm agreement |
| 5.4 | Cross-compilation (target triple param) | Go/Zig/Rust | M | **DONE 2026-08-25** — 6 targets emit correct triple+datalayout; IR lowers to a valid target OBJECT from any host with no sysroot; `nova emit --obj`; cross-link refuses with the real reason + `NOVA_SYSROOT` escape hatch. Gate 2p, 13/13 |
| 5.5 | Single-command toolchain (bundle clang) | Go/Zig | M | **DONE 2026-08-26** — `nova_find_clang()`/`nova toolchain status` resolve `NOVA_CLANG` → `NOVA_HOME`-relative → install-relative → PATH → clear error (already landed in `ba86be42` alongside 5.4; this session verified it end-to-end). Dev bundler `tools/bundle_toolchain.{ps1,sh}` + gate `_toolchain_bundle_gate.ps1`, 6/6 cases incl. a PATH-scrubbed build, ALL GREEN. Dev bundle 202.0 MB (stock LLVM, PATH-independent, not zero-dep); shipping RELEASE bundle (llvm-mingw, zero-dep) already 81 MB Windows / 86 MB Linux via `install.ps1`/`install.sh` |
| 5.6 | Prism → Canvas for browser (NOT WebGL — see below) | JS | XL | **✅ DONE 2026-08-27** — renderer + native KAT + JS decoder + `_prism_canvas_gate` all green through the full arc. (Live *wasm* execution of this path remains blocked by an unrelated, pre-existing runtime-carve gap — tracked separately; the Canvas backend itself is complete and gated natively.) |
| 5.7 | ARM/AArch64 native | Go/Rust/all | L | needs hardware |

---

### ✅ 5.5 CLOSED (2026-08-26) — the resolver already existed; what was missing was the dev-loop bundle and the gate that proves it

**What was already true, but unverified.** `nova_find_clang()` — landed in `ba86be42`, the same commit as 5.4 cross-compilation, not new this session — already implements the exact discovery ladder this item asks for: `NOVA_CLANG` (explicit override, `path_exists()`-guarded so a stale value degrades to the next rung instead of hard-failing) → `NOVA_HOME`-relative bundled toolchain → install-relative bundled toolchain (via `self_exe_path()`, so a fresh download works with zero env vars) → cwd-relative → PATH via `which()` → a diagnostic that names every rung it checked. `nova toolchain status|path|install` expose it; `nova_find_runtime()` and `nova_find_version()` mirror the same ladder for the runtime source and the VERSION file. Grepped every bare `"clang"` literal in `nova_compiler.nova`: the only ones outside `_clang_exe_name()`/`nova_find_clang()` itself are the `setup` and `toolchain status` commands' own re-checks (`which("clang")`, used only to phrase the warning) — every real invocation site (`build`, `run`, `--emit obj`, the wasm path) routes through the one resolver. **No compiler change was needed for this item; it needed proof.**

**Naming note.** The task brief for this item named the override `$NOVA_CC`. The shipping name is `NOVA_CLANG`, predating this session. Renaming or aliasing it would touch `nova_compiler.nova`, off-limits this session — and `NOVA_CLANG` is arguably the more correct name anyway (unambiguous: it names *clang* specifically; `NOVA_CC` reads like a generic "which C compiler" knob NOVA doesn't actually offer a choice over). No action taken; not a gap.

**What this session built on.** `tools/bundle_toolchain.ps1`/`.sh` were already fully written — not "died partway" in the sense of missing code; every case was implemented, down to symlink-preserving copies on Unix (`cp -P`, avoiding ~670MB of dereferenced-symlink duplication) and asking `clang -print-resource-dir`/`-###` rather than guessing the version or the linker. What had never happened was running it end-to-end or gating it. Two modes, confirmed by reading and (dev mode) execution:
- **`-Mode dev`** (default): stages a bundle from whatever clang is *already installed* on this machine. Zero network calls. This is what makes the PATH-scrubbed gate runnable on a developer laptop instead of only by hand on a release candidate.
- **`-Mode release`**: delegates to (does not reimplement) `nova-compiler/scripts/package_release.sh`, the same script `.github/workflows/release.yml` already drives to produce what `install.ps1`/`install.sh` ship. `-Fetch`/`--fetch` is the *only* path in either script that touches the network, gated behind an explicit switch even inside release mode, and downloads the version-pinned archive named in-code (`llvm-mingw 20260616` for Windows, `LLVM 22.1.8` for Linux/macOS) — never the default.

**Gate run this session (`_toolchain_bundle_gate.ps1`, kill-on-timeout via `Invoke-Timed`), ALL GREEN, 6/6 cases:**

| Case | Assertion | Result |
|---|---|---|
| 1 — THE CLAIM | bundle present, every clang/LLVM/MSVC dir stripped from PATH → `nova build` produces a binary that runs and prints the sentinel | PASS |
| 2 — negative control | identical scrubbed PATH, bundle *absent* → must NOT produce a working binary | PASS (build exit 1) |
| 3 — no regression | no bundle, normal PATH → today's system-clang behaviour untouched | PASS |
| 4 — precedence | `NOVA_CLANG` set → beats a present bundle | PASS |
| 5 — robustness | `NOVA_CLANG` pointing at nothing → ignored, falls through to the bundle | PASS |
| 6 — `NOVA_HOME` rung | `nova.exe` from a bundle-less tree, `NOVA_HOME` pointing at the bundle → resolves | PASS |

Case 2 is load-bearing, not decorative: it is what makes case 1 mean anything. The obvious-but-worthless version of this gate — "assert `toolchains/clang/bin/clang.exe` exists in the staged tree" — passes even with `nova_find_clang()` completely broken, because the real build just falls through to a system clang and succeeds anyway. Case 2 proves the scrub actually removed something case 1 depended on.

**Measured sizes — dev and release bundles are not the same artifact, and conflating them would be dishonest:**

| Bundle | Source | Zero-dependency? | Measured size |
|---|---|---|---|
| Dev (`tools/bundle_toolchain.ps1`, this session, this machine) | Stock LLVM 22 already installed at `C:\Program Files\LLVM` | **No** — that clang targets `*-pc-windows-msvc`; linking needs the MSVC CRT + Windows SDK, found via registry probe, not PATH. PATH-independent (proven above), not dependency-free. | **202.0 MB** total — `toolchains\clang\bin` 168.0 MB + `lib` 15.1 MB, `bin`+`compiler`+`lib`+`std` (nova + stdlib) 19.0 MB |
| Release (`package_release.sh`, from llvm-mingw, already shipping) | Downloaded llvm-mingw archive (bundles its own UCRT sysroot) | **Yes** — previously verified building with a completely empty PATH | 81 MB Windows zip / 86 MB Linux tar.xz (measured in an earlier session, unchanged here — release mode needs a downloaded archive this session did not fetch) |

The dev bundle exists solely to make the gate runnable without a release archive on hand; `bundle_toolchain.ps1`'s own header comment says as much. The number a user actually downloads is the release one, and that was already measured and already ships via `install.ps1`/`install.sh`.

**Rejected, and why:**
1. **A second `NOVA_CC` override** duplicating `NOVA_CLANG` — needless surface area over a name that already ships and is already gate-proven.
2. **Making `-Fetch` implicit** when the dev-bundle directory is missing — the task's hard constraint and the script's own design both require explicit opt-in; a first `nova build` must never silently pull ~400MB over the network.
3. **A standalone resolver script** re-implementing `nova_find_clang()`'s ladder in PowerShell/bash (the task allowed for this if the compiler lacked the logic) — not needed, since the in-compiler resolver already exists and is now gate-proven; a parallel implementation would just be a second place the two ladders could silently drift apart.

**Compiler-side change needed: none.** `nova_find_clang()` / `nova_find_runtime()` / `nova_find_version()` / `nova toolchain status|path|install` are complete and correctly wired to every call site.

---

### 🔧 5.6 PARTIAL (2026-08-26) — the renderer, the decoder, and the gate all work; the wasm carve does not

**What this is, precisely, restated because the title above is a correction.** This is a **Canvas2D** backend, not WebGL — nothing here emits a shader, a vertex buffer, or a GPU handle. It walks the same `PrismNode` tree `prism/render/prism_render_html.nova` (Milestone MA.5) and `prism/backend/ansi/prism_render_ansi.nova` (MA.6) already render, making it Prism's **third** backend and the first real falsifier of "backend-agnostic node tree" against a medium with no built-in layout engine (HTML gets CSS, a terminal gets its own grid; a `<canvas>` gets neither). It is also the first backend that needs a browser-side companion — a `<canvas>` element has no DOM to receive markup, so the NOVA side cannot hand off a string the way `prism_html_render` does; it has to hand off *something else* across the wasm boundary, which is most of what makes this item different from 5.3's existing WASM plumbing.

**Files.**
| File | Role |
|---|---|
| `prism/backend/canvas/prism_render_canvas.nova` (also copied to `nova-compiler/lib/`) | The renderer: `PrismNode` → a self-describing i64 draw-command stream. Layout, all 22 primitives, framing, checksum, hit-testing, typed events. |
| `prism/kat/_kat_prism_render_canvas.nova` | Native KAT. Hand-derives the exact expected stream for a known tree and asserts it byte-for-byte; isolates each of the three framing checks; proves all 22 primitives map. |
| `prism/backend/canvas/prism_canvas_host.js` | The JS half: a pure `decode(words, sink)`, an independent `verify()` re-implementation, a real `canvas2DSink(ctx)` Canvas2D adapter, a `recordingSink()` for headless tests, and `pullWordsFromWasmExports()`. UMD-style (CommonJS for Node, `window.PrismCanvasHost` for a `<script>` tag) so there is exactly one implementation, not a Node copy and a browser copy that can drift. |
| `prism/backend/canvas/prism_canvas_harness.html` | The browser page — fetches the `.wasm`, instantiates it, pulls the words, decodes them onto a real `<canvas>`, wires click-to-hit-test. Written against the working contract; currently cannot fetch a `.wasm` that does not yet exist (see below). |
| `nova-compiler/test_programs/_wasm_canvas_probe.nova` | The wasm-targeted entry program: builds the KAT's tree and exports `canvas_len()` / `canvas_word(i)` / `canvas_verify_ok()`. Compiles cleanly to `wasm32` LLVM IR and to a wasm32 object today. |
| `nova-compiler/test_programs/_canvas_words_dump.nova` | A tiny native helper that prints the same tree's word stream one integer per line, so the Node-side test consumes a *real renderer output*, not 61 hand-retyped numbers. |
| `nova-compiler/test_programs/_prism_canvas_import_check.js`, `_prism_canvas_decode_check.js`, `_prism_canvas_gate.ps1` | The gate (3 stages, detailed below). |

**The encoding, and why.** Three candidates, and this is not a preference — one of the rejected two is actively unsound on this project's own wasm host. (1) A flat numeric list is fast across the boundary but cannot carry text. (2) A string protocol (`"rect 10 20 100 40 #4f46e5;..."`) is debuggable but was rejected on **soundness**, not speed: building it routes coordinates through `+`, and the existing wasm host runtime is untagged — it decides string-vs-int by inspecting the byte at a value's address, and a coordinate above 256 is precisely the kind of value that lands on a printable byte and gets misread as a string pointer. That is a silent wrong pixel with no error anywhere. (3) — **chosen** — a flat i64 list with text inlined as one full word per UTF-8 byte. Every word in the buffer is unambiguously an integer, so no pointer-shaped value ever crosses the boundary and the untagged-value heuristic never runs on this stream at all. Cost, stated rather than buried: 8 bytes per text byte is 8× what the text needs; acceptable next to a framebuffer, not free, and the documented v2 fix (pack 8 bytes/word) is confined to `_emit_text` and the host decoder.

**Self-describing framing — three checks, each proven to fire ALONE.** A truncated stream that looks plausible is worse than one that errors — it reads like a layout bug, not a transport bug. The KAT does not just assert "verify() rejects a bad buffer somewhere"; it constructs three buffers, each defeating two of the three checks on purpose, to prove the third is load-bearing on its own:
1. **Header/length mismatch** — drop the trailing END+checksum (a plain short read). Caught before any record is even walked.
2. **Checksum-only** — flip one word deep inside a record's fixed args (the label colour), leaving `argc` and the record count untouched. Only the DJB2 checksum catches this.
3. **The interesting one** — a buffer with a *forged-consistent* header (`word_count` rewritten to match its own truncated length) and a *forged-consistent* checksum (recomputed over the truncated content), cut off mid-record. This is what a truncated buffer looks like to a naive "re-checksum it" guard — clean. Only the per-record `argc` walk catches it, independently of the other two.

All three are separate assertions in `_kat_prism_render_canvas.nova` §2, and `prism_canvas_host.js`'s `verify()` reimplements the same three checks independently in JS (not "trust the NOVA side already checked it" — a buffer can reach a browser over `postMessage`/IndexedDB/a future `fetch`, each with its own way to truncate bytes that has nothing to do with NOVA).

**Text: Canvas2D `fillText`, named honestly.** The TEXT record carries position/colour/size/weight/alignment and the raw bytes; the host issues `fillText`. That buys the browser's complete shaping, bidi, font fallback and colour emoji for free, and it costs exactly what the renderer's own header says: no glyph-level control (no caret placement, no per-glyph hit-testing, no letter-spacing), host font/advance-width dependence (mitigated, not solved, by `prism_canvas_render_with`'s pluggable `measure` closure — a browser host passes one backed by `measureText`; the KAT's default is a monospace-ish approximation), and no subpixel positioning. The eventual answer — a glyph atlas rasterized once through the browser's own `fillText`, cached as GPU-texture quads — needs a GPU context and belongs with `backend/gpu/` (a distinct, later milestone), not here. **This is not WebGL and does not claim to be.**

**Events: the same rule the HTML backend enforces, restated for this medium.** `prism_render_html.nova`'s binding rule is that interactivity binds against node identity at runtime, never smuggled through markup. There is no "callback" opcode here for the same reason — the stream carries a `HIT` record (pre-order node index + a semantic role) per interactive node, and which nodes get one is **derived from the widget kind** (`press`/`link`/`flag`/`entry`/`range`/`pick`/`tabs`), not annotated: a developer cannot forget to make a button clickable and cannot accidentally make a caption clickable. This also dissolves a documented blocker (PRISM_UNIVERSAL_UI_PLAN §12 Blocker 1: host→NOVA callbacks are export-name-string only, so per-handler wasm exports don't scale) — dispatching on an integer node index needs exactly **one** export for the whole application, because the fan-out happens inside NOVA where closures already work.

**A real compiler defect found and worked around (not fixed — out of scope).** The prior attempt's file used `match true` with boolean-guard arms (`b >= 240 => 4`, …) for `_utf8_seq_len`. Bisecting the file by line count (compiling successively longer prefixes with `gen3_test.exe`) showed this construct **parses on its own but corrupts the parser's state for every top-level `fn` declared AFTER it in the same file** — every subsequent function then fails with a cascading `expected ','` error far downstream, which is exactly what made the file look "died partway" rather than "one function is wrong": from the outside, ~85% of the file appeared broken. `match true` with comparison-expression arms has **zero other users anywhere in this codebase**, including the 22k-line self-hosted compiler itself — confirmed by grep. Fixed by replacing it with an if-chain (the same shape `prism_render_ansi.nova`'s `_ansi_seq_len` already uses successfully). **Not reported as a builtin gap — this is a parser bug in `nova_compiler.nova`, left unfixed per this task's hard constraint** (another session owns that file); flagging it here and in the handoff for whoever picks it up next.

**The wasm blocker — verified precisely, and shown to be unrelated to this renderer.** `nova-compiler/compiler/nova_runtime_wasm.c` is the value-model wasm runtime carve documented end-to-end in `NOVA_DESIGN/WASM_RUNTIME_PORT.md` (strings/lists/dicts/structs/RC, `#include "nova_runtime.c"` under `NOVA_FREESTANDING`) — dated to that document's 2026-06-28 S1–S6 milestones (`git log` confirms no commit has touched it since a structural file move). `nova_runtime.c` has grown substantially since — `clang --target=wasm32 -ffreestanding -nostdlib -fno-builtin -O2 -c nova_runtime_wasm.c` now fails with 20 errors (`-ferror-limit` truncated) for symbols the carve's freestanding shim never gated or stubbed: `sigjmp_buf`, a `nova_task_arena_cleanup` redefinition, `pthread_once_t`/`PTHREAD_ONCE_INIT`/`pthread_once`, `lgamma`/`erf`, `getpeername`, `SO_KEEPALIVE`/`SO_BROADCAST`/`SO_RCVBUF`/`SO_SNDBUF` — and, since `nova_runtime.c` is one translation unit, almost certainly more once those are resolved. This is **entirely unrelated to `prism_render_canvas.nova`'s own content** — proven, not assumed: linking the renderer's compiled wasm **object alone**, no runtime at all, against `wasm-ld --allow-undefined` enumerates the *complete* closure of runtime symbols the renderer's wasm output needs (79 imports — every `nova_rt_*`/`nova_rc_*` value-model primitive: arithmetic, string, list, dict, `Result`/`Option`, struct/RTTI, iteration, refcounting — plus the generic entrypoint bootstrap present in every compiled NOVA program, `nova_rt_main_dispatch`/`nova_rt_init_args`/`nova_rt_wait_all`/`nova_rt_cleanup`. Zero sockets, files, threads, or process symbols). Patching the carve was judged out of scope for this task: it is a large, separately-trackable fix (the carve's own methodology in `WASM_RUNTIME_PORT.md` calls for line-by-line gating plus a native-token-identical verification pass), and `nova_runtime.c` — the file the carve `#include`s wholesale — is explicitly under concurrent edit by another session this task was told not to touch.

**Gate (`_prism_canvas_gate.ps1`), run this session, kill-on-timeout via `Invoke-Timed`, exit 0 — three real stages, one honestly-reported blocker:**

| Stage | What it does | Result |
|---|---|---|
| 1. Native exact-match | Compiles+links+runs `_kat_prism_render_canvas.nova` natively; scans stdout for `ALL PASS` and a case-sensitive line-anchored `FAIL` | **PASS** — 27 assertions, every x/y/w/h/colour/text word hand-derived and matched exactly |
| 2. wasm import surface | Compiles `_wasm_canvas_probe.nova` to wasm32, links the **program object alone** (no runtime) with `wasm-ld --allow-undefined`, enumerates imports via `WebAssembly.Module.imports` in Node, asserts every one matches `nova_rt_*`/`nova_rc_*`/`strcmp` and none matches a socket/file/thread/process deny-list | **PASS** — 79/79 expected, 0 denied |
| best-effort (non-fatal) | Attempts to build the FULL value-model runtime and, if it succeeds, link a real `.wasm`, copy it beside the HTML harness, and upgrade stage 3 to a live execution check | **currently fails** — reported loudly with the compiler's own error tail, not silently skipped |
| 3. Node harness decode | Runs `_canvas_words_dump.nova` natively to get a *real* renderer-produced word stream, decodes it with `prism_canvas_host.js` (`verify` + `decode` + `canvas2DSink` against a fake `CanvasRenderingContext2D`), asserts the exact same draw-call text stage 1 already hand-proved | **PASS** |

The gate is written to **self-upgrade**: the best-effort block runs every time, and the moment the runtime carve is resynced, the very same script starts producing a real `_wasm_canvas_probe.wasm`, copying it next to `prism_canvas_harness.html`, and running a genuine live-wasm-execution assertion — no further edits to this gate needed.

**What renders and what does not, stated without hedging.**
| | Status |
|---|---|
| All 22 `PrismNodeKind` primitives → some canvas encoding | ✅ proven (KAT §4, broad tree, `verify()` Ok) |
| Exact geometry/colour/text for a known tree | ✅ proven byte-for-byte (KAT §1) |
| Truncation/corruption detectable, not silently mis-rendered | ✅ proven, 3 independent checks (KAT §2) |
| Hit-testing + typed pointer/key events | ✅ proven (KAT §3) |
| `art` (images), `draw` (host paint callback) | Honest placeholder box — no image decoder or user callback crosses this boundary in v1 (same call the ANSI backend made) |
| `flexible` gap expansion | Not implemented — visible-but-not-expanding; needs a second constraint pass (the layout engine, a different milestone) |
| Baseline alignment, bidi, RTL, subpixel text | Not implemented — v1 scope, stated in the renderer's own header |
| Scrolling | Not implemented — a `pane` clips only |
| **Live wasm execution in a real browser/Node** | ❌ **blocked upstream** by the runtime-carve gap above — everything feeding into it is done and verified |

**Rejected, and why:**
1. **Reading `NovaList`'s raw `{data,size,cap,elem_kind}` struct directly out of wasm linear memory**, which would make word-pulling "zero crossings" instead of one call per word — rejected because it means depending on the RC-header offset and the S4 typed-array `elem_kind` tagging state, both runtime internals and neither part of `prism_render_canvas.nova`'s public contract; either can change shape with no compile error here to catch it. `pullWordsFromWasmExports()` instead calls the program's own exported `canvas_len()`/`canvas_word(i)` — for a UI-sized command stream (a screen, not a video frame) the call overhead is not the risk that matters; silently decoding a stale struct layout is.
2. **Patching `nova_runtime_wasm.c` to close the drift** — a real, mechanical-in-kind but potentially large fix, explicitly out of scope per this task's hard constraints (`nova_runtime.c`, which it wholesale `#include`s, is under concurrent edit by another session).
3. **Hand-retyping the expected word array into JavaScript** for the Node decode test — would test a human's transcription, not the decoder. `_canvas_words_dump.nova` instead hands the Node test a real, natively-produced stream.
4. **Claiming WebGL** because "canvas" is in the title — this is Canvas2D, stated plainly in the renderer's own header and repeated here per the task's instruction not to overclaim.

**Compiler-side change needed: none from this task's hard-constrained scope.** What a *future* session needs, precisely: (a) resync `nova-compiler/compiler/nova_runtime_wasm.c` against the current `nova_runtime.c` (the missing-symbol list above is the starting point; expect more once those clear), verified with the carve's own native-token-identical methodology; (b) separately, `nova_compiler.nova`'s parser has a real defect where `match true` with comparison-expression arms corrupts parse state for the remainder of the file — worth a minimal repro and a fix, independent of Prism.

---

## PHASE 6 — TOOLCHAIN (developer experience)

| # | Feature | From | Effort | Status |
|---|---------|------|--------|--------|
| 6.1 | AST-based formatter (real `nova fmt`) | Go/Rust | M | **✅ ALREADY EXISTS** — CI stage 2i gates canonical+faithful+idempotent |
| 6.2 | REPL | Python | S | **✅ EXISTS + GATED** — CI stage 2e2 (end-to-end compile+link+run) |
| 6.3 | Debugger integration (`nova debug`) | All | L | **✅ EXISTS + GATED** — `debug` subcommand + DWARF gate 2j |
| 6.4 | Linter / `nova lint` | Rust clippy | L | **✅ EXISTS** — `lint` subcommand + `linter_test` in regression |
| 6.5 | Wire package manager CLI | Go/Rust/Python | S | **✅ DONE** — `install`/`add` wired, CI stage 2c2 gates offline+transitive+cycle |

---

## PHASE 7 — SAFETY HARDENING

| # | Feature | From | Effort | Status |
|---|---------|------|--------|--------|
| 7.1 | Inline asm | C/Zig | M | **✅ DONE 2026-08-21** — `asm(template, constraints)` |
| 7.2 | C header import (extern fn auto-gen) | Zig | L | **✅ ALREADY EXISTS** — `bindgen.nova`, gated |
| 7.3 | @cdecl improvements | C/Rust | S | **✅ DONE 2026-08-22 — ABI-correct sized ints + floats, gated from a real C host (CI 2k5)** |
| 7.4 | `unsafe {}` blocks for raw pointer work | Rust | M | **✅ ALREADY EXISTS** (`unsafe` block + expression forms) |

---

### ✅ 7.3 CLOSED (2026-08-22) — @cdecl is ABI-correct; NO new syntax was needed

**What was actually broken.** The old wrapper was i64-everywhere. The in-code comment called
that "not ABI-correct in general" — an understatement. Measured severity:

| C callback shape | Old behaviour | Severity |
|---|---|---|
| `int cmp(void*, void*)` | i64 in/out; caller reads EAX | worked by **x86-64 ABI accident** |
| `int` **params** | caller sets only EDI; RDI's top 32 bits are ABI-*unspecified* | **latent garbage** |
| `double` **params** | C passes in XMM0; wrapper read RDI | **hard break** |
| struct-by-value | unhandled | hard break (out of scope) |

**The design fork, and why it was not really a fork.** The original author proposed putting an
exact prototype on the annotation: `@cdecl("i32(ptr,ptr)")`. That is a second, stringly-typed type
language embedded in a string — which `compiler-architecture.md` forbids outright ("No stringly-typed
IR") and which breaks "one obvious way". **The prototype is derived from the NOVA signature
instead**, reusing the annotations the language already has. Zero new syntax; the type checker
already validates it.

**Implementation.** `cdecl_c_type()` + `cdecl_c_unsigned()` map an annotation to its true C type,
and the wrapper marshals each edge:
- narrow ints → explicit `sext`/`zext` (never trust the caller to have extended)
- `double`/`f32` → boxed in, `nova_rt_unbox` out (`f32` also `fpext`/`fptrunc`)
- unannotated params → `i64`, so every pre-existing @cdecl fn emits **byte-identical IR**

Kept **deliberately separate** from `ffi_llvm_type` (the inbound direction, NOVA→C): that mapping
coarsens all ints to i64 and every existing `extern fn` depends on it — widening it here would
silently change the ABI of working code.

**⚠️ The bug the first implementation had, and why it matters.** Passing the raw double bit pattern
as i64 looked obviously right (it is exactly what `bitcast double .. to i64` produces everywhere
else) — and it returned **`dmul(2.5, 4.0) = 0`**. Reason: a @cdecl fn usually has *no NOVA call
site*, so type inference never specializes it and its body falls back to the generic `nova_rt_mul`,
which read the bit pattern as an **integer** and overflowed to 0. A raw float pattern is not
self-describing. Boxing is correct in **both** directions: a specialized body unboxes it, a generic
body dispatches on the tag. Same root cause as the long-standing float-boxing tax (see 3.3/3.1).

**Gated (CI 2k5, `_cdecl_abi_gate.ps1`).** The KAT existed since `808342ca` but was **never wired
into CI** — verified once by hand, then unguarded. It now links `_kat_cdecl.nova` against a real C
host declaring each callback with its TRUE prototype, and asserts on **output content**, not just
exit code: sext discriminator (`narrow_i32(-7,3) = -4`, a wrong zext gives 4294967289), zext
discriminator (`narrow_u8(200) = 200`, a wrong sext gives -56), doubles, and f32. 8/8 assertions.

**Known limitations (deliberate, documented in-code):**
- `bool` stays i64 — a NOVA bool can be a *boxed* value, so `trunc i64 to i8` on a returned bool
  would truncate a **pointer**. Declare `-> int` for a `_Bool` callback; the caller reads AL fine.
- struct-by-value is out of scope — SysV eightbyte classification vs Win64 by-reference differ per
  platform, and it is genuinely rare in callbacks.

---

### ✅ 7.1 Inline asm — `asm(template, constraints) -> int`

Emits `call i64 asm sideeffect "<tmpl>", "<cons>"()`, or `call void asm …` when the constraints
declare no output. Requires `unsafe` (added to `_is_unsafe_builtin` — inline asm is the definition of
outside-the-safety-envelope). `sideeffect` is **always** set: LLVM cannot reason about the body, so
without it a block whose result is unused — a fence, a `cpuid`, an `int3` — is legally deleted or
hoisted, which is precisely the surprise inline asm exists to avoid.

Verified: `asm("mov $$42, $0", "=r")` returns **42**; `asm("nop", "")` lowers to `call void asm` and
still yields a defined `0`. Gated by `_asm_inline_test`.

**Three real constraints, all found by probing rather than assumed:**

1. **Operands must be string LITERALS.** They are emitted into the module, so a computed string
   cannot work. Rejected with `E1014` rather than silently emitting malformed asm — malformed asm
   *assembles fine* and fails at runtime, the worst possible outcome.
2. **Clobber lists work — via the `\{` escape that already existed.** LLVM's `~{reg}` syntax meets
   NOVA's brace interpolation, but the lexer already accepts `\{` / `\}` for a literal brace (its own
   error message lists `\n \t \r \\ \" \0 \u{XXXX} \{ \}`). So `asm("nop", "~\{memory}")` emits
   `"~{memory}"` — verified in the IR.
   *I first documented this as an unfixable limitation and proposed adding a `{{` escape. Both were
   wrong.* The escape existed, and `{{` would have been actively harmful: **123 occurrences of `{{`
   already exist** across `std/text/template.nova`, `std/parsing/template.nova` and others whose
   entire syntax *is* `{{var}}` — adding it would have silently changed their meaning. Checking
   before building saved a real regression here, not just effort.
3. **Fixed-register constraints (`"=a"`) fail to allocate on this target** — "couldn't allocate
   output register for constraint 'a'". `"=r"` and letting the register allocator choose is the
   portable form. (My first probe also got this *wrong* in a second way — `rdtsc` clobbers `rdx`
   without declaring it — and LLVM correctly refused. Constraints are a contract; the hard error is
   the system working.)

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
