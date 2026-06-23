# NOVA Interfaces / Constrained Generics — Design (backlog #8, XL)

Synthesized 2026-06-23 from two adversarial passes over the REAL compiler (the multi-agent design workflow's
synthesis stage was API-overloaded, but its devils-advocate ran twice and produced consistent constraints).
This is the design the next session implements from. #8 is XL / multi-session — staged below.

## Goal
User-facing abstraction so framework APIs (handler/middleware/DB-driver/serialization/orderable/iterable
contracts) are typed, not built on untyped `any`. Must fit NOVA's laws: inference-first (bounds inferred,
minimal annotation), zero hidden cost (static dispatch is free), no UB (dynamic dispatch is sound), beat
Rust traits / Go interfaces / Elixir behaviours.

## Core decisions
1. **STRUCTURAL conformance (Go-style), not nominal.** A type satisfies an interface if it has the required
   methods (name + matching signature) — NO `type Foo : Iface` opt-in. This fits zero-annotation + means a
   framework adding a new interface does NOT force downstream types to be re-annotated. (Rust's nominal
   `impl Trait for T` is the ceremony NOVA must avoid.)
2. **Interface as a first-class NType kind** (currently absent — NType has no trait/dyn kind). Enables
   interface-typed params/returns/fields: `fn render(s: Drawable)`, `list[Drawable]`. An interface value is a
   FAT POINTER `(data_ptr, vtable_ptr)`.
3. **Dispatch:**
   - **Static** when the concrete type is known at the call site → emit a direct call (zero-cost). This is the
     common case and ships first.
   - **Dynamic** via a real **VTABLE** (per (type, interface) pair) → O(1) `(data, vtable)` indirect call.
     This REPLACES the current O(n) DJB2-hash if-else chain.
4. **Bounds inferred:** a generic that calls interface methods on a param infers the interface bound from
   use (reuse the HM machinery / NTypeScheme); explicit `fn<T: Ord> max(...)` allowed but rarely needed.

## FATAL holes in the EXISTING trait/dispatch system this design MUST fix (adversary-found, verified in code)
- **Silent-0 dispatch** (nova_compiler.nova ~8124-8127): when no implementor matches, dispatch emits
  `const_int 0` and continues → garbage value, violates "no UB". FIX: emit a trap/panic ("no impl of <iface>.<m>
  for <type>") on the no-match fallback.
- **Name-only conformance** (~12912-12943): `ti_check_trait_conformance` checks the method NAME exists, not the
  SIGNATURE (arity/types). A wrong-arity/return impl silently passes → ABI garbage. FIX: signature-check
  (arity + param/return types) against the interface declaration.
- **O(n) DJB2-hash dispatch + no collision check** (~7314 hash, ~8085-8132 chain): linear scan; two type names
  that hash-collide dispatch to the WRONG method (type confusion). FIX: vtable (collision-free, O(1)).
- **`any`/`var` bound-skip** (~12900: `if rk=="any" or rk=="var" continue`): a bound silently passes when a
  value flows through `any` (dict/json/heterogeneous list) or when inference doesn't resolve. FIX: at minimum,
  a runtime conformance check when an `any` is coerced to an interface type (insert a vtable lookup that traps
  on no-impl); document that fully-static enforcement needs the unification-budget fix (#16) too.
- **Unification budget (5000, never reset)** silently disables checking late in big compiles (audit + adversary).
  Interfaces ADD constraints → hit it sooner. Coordinate with #16 (reset/scope the budget) — likely a prerequisite.
- **No monomorphization** (Stage-5, XL/PhD-grade; the `ti_fn_param_types→fpt` shortcut already broke
  math3d/complexnum). So generic-over-interface code is dynamic-dispatch speed until #14 lands. Accept this:
  ship interfaces with dynamic dispatch + static-where-known; monomorphization is a later perf layer (#14).

## Staged rollout (each gated: reconverge + 552 both modes + ASAN)
- **S8.0 (M)** — Fix the existing dispatch soundness FIRST (independent value, de-risks everything): no-match
  fallback traps instead of returning 0; conformance becomes signature-checked. Add negative tests.
- **S8.1 (L)** — Interface declaration syntax + a first-class interface NType kind + STRUCTURAL conformance
  checking (compiler builds the per-(type,interface) method set). No new dispatch yet (reuse current).
- **S8.2 (L)** — Vtable codegen: emit a vtable per (type, interface); an interface value = (data, vtable);
  dynamic calls go indirect (O(1)). Replace the DJB2 chain. This is the core codegen change.
- **S8.3 (M)** — Interface-typed params/returns/fields + `list[Iface]`; inferred bounds on generics.
- **S8.4 (M)** — default methods on interfaces.
- **(later, #14)** monomorphization → static specialization for zero-cost generic-over-interface.

## Why this beats them
- vs Rust: structural (no `impl` ceremony) + inferred bounds → far less annotation, same safety.
- vs Go: signature-checked + inferred bounds + (later) monomorphized zero-cost path Go can't do.
- vs Elixir behaviours: compile-time checked, not runtime-only.

## Open questions
- Coherence: with structural conformance, two interfaces with the same method name — ambiguity at a call on an
  `any`? (Likely resolve by the interface type at the call site.)
- Vtable identity across separately-compiled modules (ties to #38 ABI versioning).
- How aggressively to infer bounds vs require annotation for readability.
