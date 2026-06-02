# NOVA Reflection / Comptime — Production-Grade Design (real-compiler-grounded)

**Status:** 2026-06-02. The keystone deep-tier item (gates Serde-derive → DB/HTTP, units, DI patterns).

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
