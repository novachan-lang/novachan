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
| 1.6 | null ≠ 0 (indistinguishable) | All | L | **PARTIAL** — null-as-*value* done `a7e5fc76` (flag, default off); null-as-*absence* NOT solved, cause unknown |
| 1.7 | RC cycle collector (Tier 4.7) | Rust/Erlang | L | DESIGNED |
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

## PHASE 2 — EXPRESSIVENESS (what makes code powerful)

| # | Feature | From | Effort | Status |
|---|---------|------|--------|--------|
| 2.1 | Nested pattern matching `Ok(Some(x))` | Rust/Haskell | M | **✅ DONE 2026-08-20** |
| 2.2 | Pattern guards `x if x > 0` | Rust/Haskell | S | **✅ ALREADY EXISTED — verified + gated** |
| 2.3 | Operator overloading | C++/Rust/Swift/Kotlin | M | **✅ ALREADY EXISTED — verified + gated** |
| 2.4 | RAII / drop trait (scope-exit cleanup) | C++/Rust | M | **✅ ALREADY EXISTS** (`<Type>__drop`) — gated via `_chan_drop_test` |
| 2.5 | Extended @comptime (full language at compile time) | Zig/C++ | L | PARTIAL — `@comptime` + const-fn fold exist |
| 2.6 | Generics proven in framework code | C++/Rust/Swift | M | **✅ TRUE — 74 in `std/`, 9 in `forge/`** (0 in `prism/`) |
| 2.7 | Error message suggestions ("did you mean X?") | Python/Rust/Elm | S | **✅ ALREADY EXISTS** (edit-distance) |
| 2.8 | Move semantics / move(x) builtin | C++/Rust | M | PARTIAL — use-after-move enforced for `send()`; no general `move()` |
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
| 3.1 | Float/array perf 1.7x → 1.0x C | C | L | S4.2 shipped, extend |
| 3.2 | SIMD | C/C++/Rust | M | **✅ ALREADY EXISTS** — `simd_add/sub/mul/scale/dot/sum/ready` builtins |
| 3.3 | Verify generics monomorphize to zero-cost | C++ | S | **✅ DONE 2026-08-22 — zero-cost PROVEN structurally (byte-identical IR)** |
| 3.4 | Buffer views (read-only, no copy) | C/Rust | M | **OPEN — confirmed: `bytes_slice` memcpy's** |
| 3.5 | Process-scoped arena allocators | C/Zig | M | **✅ ALREADY EXISTS** — per-task arenas, `nova_task_arena_cleanup` |
| 3.6 | `@stack` hints for stack allocation | C/Zig | S | **❌ REJECTED 2026-08-21 — already automatic (SROA), a hint would be redundant** |

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
| 4.3 | Preemptive scheduling (yield at loop back-edges) | Erlang | M | TODO |
| 4.4 | Supervision trees (library) | Erlang | S | **✅ ALREADY EXISTS** (`forge_otp.nova`: `sup_new`/`child_add`/`sup_start`/restart intensity) |
| 4.5 | Small fiber stacks (4KB initial, grow on demand) | Erlang | M | **✅ ALREADY EXISTS** — `NOVA_FIBER_COMMIT_SIZE 4096` |
| 4.6 | `nova watch` (fast restart < 0.5s) | Erlang/Go | S | **✅ DONE 2026-08-21 — 369 ms save-to-running** |
| 4.6b | Incremental cache ignored IMPORTED files (stale builds) | — | S | **✅ FIXED 2026-08-21 — found via 4.6** |
| 4.7 | Distributed channels (network transport) | Erlang | XL | TODO |

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
| 5.4 | Cross-compilation (target triple param) | Go/Zig/Rust | M | TODO |
| 5.5 | Single-command toolchain (bundle clang) | Go/Zig | M | TODO |
| 5.6 | Prism → Canvas/WebGL for browser | JS | XL | TODO |
| 5.7 | ARM/AArch64 native | Go/Rust/all | L | needs hardware |

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
