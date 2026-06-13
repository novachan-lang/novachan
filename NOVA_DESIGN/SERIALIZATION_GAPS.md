# NOVA Serialization Gap: top-level list-of-structs (and why the obvious fix is unsound)

**Status:** characterized + deferred (iter 31, 2026-06-14). Code-verified via a 3-agent design
workflow (compiler-architect + devils-advocate + synthesis). The clean fix is infrastructure
(inferer-to-codegen type threading OR tagged structs) — staged, not rushed. Partial fixes trade a
loud bug for a silent one and are REJECTED.

## What works, what doesn't

NOVA's automatic structural reflection (innovation D1) is complete for a struct value:
`to_json(p)` / `json_stringify(p)` / `==` / `copy` / `from_json` / struct-as-dict-key all work
zero-annotation (guarded by `auto_reflect_test`, `auto_json_test`, `from_json_test`). A struct
**field** of type `list<Struct>` also serializes correctly — `_make_to_json_method`
(nova_compiler.nova ~L3278) emits `"[" + join(map(self.f, fn(e) <Elem>__to_json(e)), ",") + "]"` as
AST during `expand_derives`.

**The gap is a TOP-LEVEL list of structs** — two distinct symptoms, two subsystems:

- **A (silent, dangerous):** `json_stringify([Point{1,2}, Point{3,4}])` COMPILES + RUNS but emits the
  raw element pointers, e.g. `[2318333718168,2318333717928]`, not `[{"x":1,"y":2},{"x":3,"y":4}]`.
  The codegen dispatch (nova_compiler.nova ~L7332) only fires for a *struct*-typed arg; a list arg
  falls through to the generic runtime encoder `nova_rt_json_stringify`, whose `NOVA_MEM_STRUCT`
  element case is unhandled (structs are tagless → the integer printer at nova_runtime.c ~L1790).
- **B (loud):** `to_json([Point{1,2}])` → E1001 at **inference**: "expected Point, found List<any>
  (in Point__to_json)". `to_json` is NOT in `ti_stdlib`; it exists only as a per-struct method, so
  the method-dispatch (ti ~L10706) resolves `to_json(list)` to the sole `Point__to_json` and unifies
  the list arg with `self: Point`.

## Why the obvious fix is UNSOUND (rejected)

The tempting fix: detect `list<Struct>` at the call site, reuse the field-level map+join pattern,
and register `to_json` in `ti_stdlib` to stop the E1001. The design workflow found this **trades a
loud bug for a silent one** — worse, not better:

1. **It only covers `let`-bound list LITERALS.** `ir_expr_struct_type` (~L7996) returns bare
   `"list"` for any list IDENT (~L8019) and any function-RETURNED list (~L8015). The literal-only
   element-type recovery (a let-lowering `ir_field_types["#name"]` hack) does nothing for the
   **dominant** pattern — build a list with `push` in a loop, or return it from a function. Those
   stay SILENTLY wrong.
2. **Registering `to_json` as `T -> string`** makes `to_json(unresolvable-list)` type-check and then
   emit raw pointers at runtime — converting symptom B from a **loud** compile error into **silent**
   data corruption. It also risks the *working* `to_json(struct)` path (a bare `to_json(p)` call
   would resolve generically and miss `Point__to_json` unless the codegen struct-dispatch is also
   added and kept correct).
3. **A pure-runtime fix is architecturally blocked.** Record structs are TAGLESS — the runtime has
   no way to identify a struct pointer's type to look up and call its `__to_json`. So the generic
   encoder *cannot* be taught to recurse into struct elements without a type identity.

NOVA rule: never trade a loud failure for a silent one. So the partial fix is rejected, and the
status quo is preserved (json_stringify(list<struct>) stays pre-existingly silent; to_json(list)
stays loud) until the real fix lands.

## The two real solution paths (either unblocks all list shapes)

- **Path A — thread the inferer's list-element type to codegen (RECOMMENDED).** The inferer already
  knows `list<Point>` (that is how it type-checks); the loss is at the codegen boundary, where
  `ir_expr_struct_type` is a deferred-types heuristic that collapses every list to `"list"`. Threading
  the element struct type (for idents, returns, params, index results — not just literals) lets the
  json dispatch emit `map(e, Elem__to_json) |> join` for ANY list<Struct>. This is the SAME
  "inferer knows the type but codegen has only a heuristic" gap that limits perf specialization
  (PERFORMANCE_SPECIALIZATION.md) and total-RC ownership (RC_COMPLETENESS.md) — a foundational,
  high-leverage piece. Reconverge-risky (ir_locals/ir_expr_struct_type feed many dispatches), so
  staged: S1 record the element type as pure metadata (byte-identical reconverge) → S2 consume it in
  the json dispatch only (additive; the compiler has no top-level to_json/json_stringify-on-
  list<Struct>, so its .ll stays identical) → verify with push-built / fn-returned / nested cases.
- **Path B — give record structs a runtime type identity (header type-id).** Then a generic runtime
  serializer can dispatch `<type>__to_json` by id (the struct-name registry + the fn registry
  already exist for `call_by_name`/`remote_spawn`). Covers all shapes at runtime, but it is a
  value-model change (every struct grows a tag) with its own reconverge + perf (GATE 4/5) gate, and
  it taxes the tagless-struct fast path NOVA deliberately chose.

Path A is preferred: it is additive at the json dispatch, reuses the proven field-level pattern, and
its first stage is the same provenance work other deep features need.

## Interim guidance

Use `json_stringify(struct_with_a_list<Struct>_field)` (works) rather than a top-level list, or
build the array string manually, until Path A lands. Do NOT register `to_json` as a stdlib function
in isolation — that silences symptom B. `auto_reflect_test` already guards the working struct cases.
