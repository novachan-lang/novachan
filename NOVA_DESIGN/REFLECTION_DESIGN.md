# NOVA Reflection / Comptime — Production-Grade Design (real-compiler-grounded)

**Status:** 2026-06-02. The keystone deep-tier item (gates Serde-derive → DB/HTTP, units, DI patterns).

> ## ✅ STATUS (2026-06-02): AUTOMATIC **Show** LANDED — `@derive` retired for rendering
> `str(p)`/`print(p)` on ANY record struct now auto-render `Type { f: v, ... }` with **zero annotation**,
> nested structs included — no `@derive(Show)`, no `.show()`. RECONVERGED gen5==gen6 byte-identical;
> installed as gen3_test.exe; **174/174 regression PASS** (the four `@derive` tests still pass — the
> annotation survives as a harmless optional override). Implementation differs from the original plan below
> in ONE key way: dispatch is resolved at **codegen** (`ir_expr_struct_type`), NOT post-inference — NOVA's
> Hindley-Milner defers type constraints, so the static struct type isn't known at `ti_infer_expr` time but
> IS at codegen (same place `.show()` already dispatched). Added a `member`/`field` case to
> `ir_expr_struct_type` (nested fields), and an `_is_valid_struct_name` guard (a struct field named with a
> keyword like `type:` spawns a parser-phantom `":"` type that must not be derived). Next: same pattern for
> `to_json` (via `json_stringify(struct)` dispatch) and — carefully, it changes equality semantics — `==`.
> See memory [[project-automatic-structural-show]].
>
> ## ⚠ COURSE CORRECTION (2026-06-02): AUTOMATIC, not `@derive`
> The first implementation shipped `@derive(Show/Eq/Clone/Hash/Serialize)` — an opt-in annotation.
> **That is Rust's model (and `@` reads like a Python decorator); it is NOT NOVA's way and violates our own
> law:** "the compiler is the genius; the developer writes zero annotations," and **NOVA_INNOVATIONS D1
> (Structural Value Identity)** verbatim: *"the compiler derives the wire codec … from that one structure —
> no schema files, **no `derive(Serialize)`**."* So `print(p)` returning `<struct>` until you annotate and
> call `.show()` is exactly the ceremony NOVA exists to delete.
>
> **Canonical model (this supersedes the `@derive` opt-in):** struct behavior is **automatic and
> structural** — `print(p)`/`str(p)` render fields, `a == b` is structural, `to_json(p)` derives — all
> with **zero annotation**, compiler-derived from the struct's structure, and **generated only where the
> program uses them** (usage-driven, whole-program) so there's no bloat (the "erase-unused" + genius-compiler
> resolution). Non-renderable/non-comparable fields (channel/process/fn) are handled gracefully, not errored.
> `@derive(...)` survives only as an **optional explicit override** (force-generate, or future custom impls),
> never the default path.
>
> **Why the shipped `@derive` work is still a valid stepping stone:** the per-derive *generators*
> (`_make_show_method`/`_make_eq_method`/`_make_clone_method`/`_make_hash_method`/`_make_to_json_method` in
> `expand_derives`) ARE the field-walk codegen the automatic model reuses verbatim. What changes is the
> *trigger* (annotation → usage) and the *dispatch* (explicit `.show()` → automatic at `str`/`==`/`to_json`
> call sites). The machinery stays; the API becomes invisible.
>
> **Implementation path for AUTOMATIC (the real next step, architectural — do it carefully, not rushed):**
> 1. **Usage discovery (post-inference):** the inferrer knows the static type at each `str(x)`/`print(x)`,
>    `x == y`, `to_json(x)` site. Collect the set of struct types used in each context.
> 2. **Generate** the structural method for exactly those (struct, capability) pairs — reusing the existing
>    `_make_*` generators — gracefully skipping/placeholder-ing non-renderable fields.
> 3. **Dispatch:** rewrite `str(structexpr)`→`S__show(structexpr)`, `a==b` (structs)→`S__eq(a,b)`,
>    `to_json(structexpr)`→`S__to_json(structexpr)` where the inferred type is a struct `S`.
> 4. This requires a **post-inference / type-aware lowering hook** (NOVA's codegen is currently type-erased,
>    so this is a real architectural addition — the reason it must be built deliberately, not at the tail of a
>    marathon session). Once it lands, every struct is showable/comparable/serializable with **zero ceremony**.
>
> The rest of this document (the `@derive` mechanics) is retained as the *generator* spec; read it through the
> lens of "generators triggered automatically by usage," not "annotations the developer writes."

> **Provenance note (important):** a specialist design pass produced a *sound model* but grounded its
> implementation sites in the **dead Java/Kotlin bootstrap** (`LlvmCodegen.kt`, `AstToIr.kt`,
> `emitMakeRecord`, `@extern at AstToIr.kt:505`). Those are **not** the shipping compiler. This document
> keeps the sound model and **re-grounds every implementation site in the real self-hosted
> `nova_compiler.nova`** (verified line regions below). Building against the Kotlin sites would be writing
> code for a compiler we don't ship — rejected.

## The model (sound, kept): Static Reflection by Derivation, dead-strippable

Reflection is a **closed, compiler-internal set of `@derive(...)` generators** that run **after type
inference** (when struct field types are fully known) and emit **monomorphic IR** + optional
**dead-strippable metadata**. NOT user macros, NOT token rewriting, NOT always-on runtime reflection.

- **Compile-time-only by default.** `@derive(Show/Eq/Hash/Clone/Serialize)` generate concrete functions
  specialized per struct type. Dispatch is resolved at compile time (the inferrer knows the static type),
  so calls lower to direct field access — never a name-keyed dict lookup.
- **Dead-strippable** (NOVA's edge over Java/Go): generated functions/tables are referenced only from real
  call sites; `globaldce`/`--gc-sections` (LTO is already on) removes them when unused → a non-reflecting
  program pays **zero bytes**.
- **Sound:** generators see fully-checked field types, so `@derive(Show)` on a type containing a
  non-renderable field (e.g. `Channel`) is an **error at the derive site**, not broken generated code.
- **`from_*` returns `Result<T, …>`** — typed Result (just landed) is the error channel.
- **General `comptime` is deferred** as a later strict superset (Phase 5), never a conflicting direction.

## Real-compiler grounding (verified in `nova_compiler.nova`)

| Mechanism | Where (real) | Use for reflection |
|---|---|---|
| Annotations on statements | `Stmt.annotations` (line 33); `@`/`AT` token (237); `@extern` parsed → `Expr("extern",…)` (1441) and consumed (1221-1232) | Add a closed-allowlist `@derive(<names>)` parsed onto a `type` decl's annotations; unknown name = located error (NEVER silently dropped) |
| Struct field metadata | inference: `st.ti_structs[name] = field_map` (~7936); codegen: `cg.struct_defs[name] = params` (~10849) | The generator reads field names+types from here — they're already resolved |
| Function → IR | `ir_lower_function(b, stmt) -> IrFunction` (6255); `b.ir_lambdas`/`b.ir_fnames` (4517+) | Synthesize a `<Type>__show` fn (as a Stmt or directly as an IrFunction) and register it |
| Current struct rendering | `nova_rt_any_to_str` returns `"<struct>"` for structs (verified at runtime) | Phase 1 replaces this placeholder for derived types via compile-time dispatch |

**Dispatch (the resolved key question):** at a `str(p)` / `print(p)` / interpolation site where `p`'s
**inferred** type is a struct with `@derive(Show)`, codegen emits a call to the synthesized `<Type>__show`
instead of the generic `nova_rt_any_to_str`. Compile-time, monomorphic, dead-strippable. (A runtime mirror —
type-tag→table lookup inside `nova_rt_any_to_str` — is Phase 4, opt-in per `@reflectable` type only, so it
never defeats dead-strip for everyone else.)

## Phased plan (each phase independently shippable + tested + bootstrap-reconverged)

- **Phase 1 — `@derive(Show)` → structural `<Type>__show`** (the whole substrate on the smallest feature):
  1. Parse `@derive(Show)` onto a `type` decl (extend the annotation path that handles `@extern`).
  2. Record derived structs; after inference, synthesize `<Type>__show(self) -> string` that walks fields
     (from `st.ti_structs`/`cg.struct_defs`) and concatenates `"<Type> { f1: <v1>, f2: <v2> }"`, rendering
     each field by its **statically inferred scalar type** (int/float/str — so float prints correctly, not
     via the unsound `any` magnitude heuristic in `project_any_int_float_soundness`).
  3. Lower it via `ir_lower_function`; register the name.
  4. Rewrite `str(p)`/`print(p)`/interp of a derived-struct-typed expr to call `<Type>__show`.
  5. Emit nothing global unless referenced → dead-strips.
- **Phase 2 — `@derive(Eq, Hash, Clone)`** — same field-walk, different fold. No new substrate.
- **Phase 3 — `@derive(Serialize/Deserialize)` (JSON)** — the ergonomic payoff and the **keystone for DB/
  HTTP**; `to_json` from the field-walk, `from_json -> Result<T, ParseError>`.
- **Phase 4 — reachability-gated runtime mirror** (`type_of`/field enumeration on `@reflectable` types) —
  for the distributed/channel "identify a received value" case, opt-in, never defeating dead-strip.
- **Phase 5 — general `comptime`** evaluation — strict superset, only after 1-4 prove dead-strip + perf.

## Phase 1 acceptance (NOT done until ALL pass)
- **Correctness:** `type Point { x:int, y:float }` `@derive(Show)`; `print(Point{x:3,y:2.5})` → exactly
  `Point { x: 3, y: 2.5 }` (float NOT printed as garbage — the soundness guard).
- **Nested:** a field that is itself `@derive(Show)` renders recursively.
- **Perf:** the emitted `.ll` for the printer uses direct field GEP/loads, **zero `nova_rt_dict_get`** on
  the derived path.
- **Dead-strip:** a program defining a `@derive(Show)` type but never showing it → binary contains **no**
  `<Type>__show` symbol (prove by symbol diff).
- **Error quality:** `@derive(Show)` on a struct with a `Channel` field errors at the derive site.
- **Determinism:** compile twice → byte-identical `.ll`.
- **Bootstrap:** port to `nova_compiler.nova`, reconverge gen5==gen6, full regression green.

## Honest effort + sequencing

Phase 1 is a genuine multi-part compiler change (annotation parse + post-inference generator + IR lowering +
call-site dispatch) with ≥1 bootstrap iteration; realistically a **focused session** (3-5 bootstraps). It is
**not** something to slam in at the tail of a long session — that produces the patchy result we explicitly
forbid. The design above removes the unknowns (model decided, real sites located, dispatch resolved) so a
fresh session implements it cleanly and incrementally, exactly as typed Result was de-risked then landed.

**Other deep items, recommended order (production-grade):** Phase 3 (derive-Serialize) is the true keystone —
**DB driver** (typed connection + sqlite3 prepare/bind/step **parameter binding**, returning
`Result<Rows,DbError>`; kills SQL injection) and **HTTP depth** (cookies/sessions/auth/multipart/middleware)
both want struct↔bytes derive, so build them *after* Phase 3 rather than hand-routing the slow path. **Units**
(compile-time phantom dimensions) gate on Phase 5 comptime. **OS-crash fault-isolation** (a child `exit(1)`
currently kills the process) is the deep Track-8 ownership work. **Unicode `len`:** keep byte-`len` official +
the existing codepoint views (`char_count`/`char_at`) — changing default `len` to scalar-count is high blast
radius (the self-hosted lexer relies on byte-`len`; it would break the bootstrap).
