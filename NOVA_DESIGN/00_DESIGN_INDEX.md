# NOVA Design System — Master Index

> **IMPLEMENTATION STATUS (as-built, 2026-05-29):** NOVA is no longer at "Phase 0." There is a
> **self-hosting NOVA compiler** (~11.4K lines) emitting LLVM IR + a C runtime, self-compiling to a
> deterministic byte-identical fixpoint at **~0.98× C**, with **Phases 0–14 substantially implemented**
> and Phases 7–14 made genuinely real + oracle-verified (71/71 regression green). The plan docs below
> describe the original design; for **what is actually built** and the key as-built decisions (notably the
> value model) see **[AS_BUILT_ARCHITECTURE.md](AS_BUILT_ARCHITECTURE.md)**, and for **per-feature
> REAL/PARTIAL/STUB status** see **[IMPLEMENTATION_AUDIT.md](IMPLEMENTATION_AUDIT.md)** (single source of truth).

## The Unified Architecture

NOVA is built on ONE model that delivers ALL properties simultaneously:

**Three Primitives:** Values (all data) + Processes (all execution) + Channels (all communication)
**Genius Compiler:** Infers types, infers ownership, infers targets, erases abstractions, catches bugs, optimizes to C-level performance — all invisibly to the developer
**Result:** A language simpler than Python, faster than C, safer than Rust, more fault-tolerant than Erlang, more portable than JavaScript — from ONE unified design

## How Everything Connects

The Three Primitives model is not just the "core model." It IS the answer to every design question:

- **Memory model** = Values are owned by processes. Send through channel = transfer ownership. Compiler picks allocation strategy. (See [Memory Model](open_problems/02_memory_model.md))
- **Type system** = Values have types (inferred). Channels have types (inferred from values). Processes have types (inferred from channels). (See [Type System](research/03_type_system_research.md))
- **Error handling** = Process crashes are contained by supervision. Local errors use `or` for defaults. Sum types for explicit handling.
- **Unification** = Three primitives express ALL domains. Compiler erases unused abstractions. (See [Unification](open_problems/01_unification.md))
- **Simplicity** = Three concepts to learn. Zero annotations for 95% of code. Compiler does the hard work. (See [Developer Experience](research/04_beating_python_simplicity.md))
- **Cross-domain safety** = Channels are typed boundaries. Compiler auto-derives capability traits (Sendable, GpuSafe, etc). (See [Type Safety](open_problems/03_type_safety_across_domains.md))

## Non-Negotiable Properties

ALL delivered by the same model:
1. **Fast** — Values compile to optimal machine code. Processes compile away when not distributed.
2. **Effective** — Three concepts. Zero ceremony. One model for every task.
3. **Robust** — Process isolation + supervision = automatic fault recovery.
4. **Secure** — Ownership through processes. No data races. No memory corruption. Compile-time verified.
5. **Platform independent** — Processes are abstract. Compiler maps to any target.
6. **Simpler than Python** — Zero annotations. Compiler infers everything. Code reads like English.

## Languages NOVA Beats (And How)

C (performance without danger), C++ (power without complexity), Rust (safety without annotations), Python (simplicity without slowness), Go (simplicity without limitations), Java (portability without boilerplate), JavaScript (reach without unsafety), Erlang (fault tolerance with static typing and performance), Julia (write-simple-run-fast for ALL domains), Swift/Kotlin (modern safety, platform independent), Mojo (unified, not AI-only), Zig (systems + everything else)

## Research Documents

All documents analyze their topic as part of the unified model, not in isolation:

- [Core Model — Values, Processes, Channels](research/01_core_model_deep_analysis.md) — The foundational architecture. How one model delivers every property. Stress tests against 5 real scenarios.
- [Language Autopsy](research/02_language_autopsy.md) — Why C++, Java, Scala, D failed. Why Rust, Go, TypeScript, Elixir succeeded. Meta-patterns for NOVA.
- [Type System](research/03_type_system_research.md) — Types as the static description of the Three Primitives. Inferred values, typed channels, process signatures.
- [Developer Experience](research/04_beating_python_simplicity.md) — How the unified model is inherently simpler than Python. Python's hidden complexity that NOVA eliminates.

## Problem Documents (Resolved at Architecture Level)

These were originally "unsolved" problems. The unified model resolves them in principle. Engineering details remain.

- [Unification — RESOLVED](open_problems/01_unification.md) — Three Primitives + abstraction erasure. Not feature accumulation.
- [Memory Model — RESOLVED](open_problems/02_memory_model.md) — Process ownership IS the memory model. Compiler picks strategy.
- [Cross-Domain Type Safety — RESOLVED](open_problems/03_type_safety_across_domains.md) — Typed channels ARE the safety boundaries. Compiler derives capabilities.

## Decisions Made
- The core architecture is Values, Processes, Channels
- All properties emerge from ONE model (not separate mechanisms)
- The compiler absorbs all complexity (types, ownership, targeting, optimization)
- The developer experience bar is: simpler than Python, safer than Rust
- NOVA beats every listed language through unified design, not feature accumulation

## Master Execution Plan

See [MASTER_EXECUTION_PLAN.md](MASTER_EXECUTION_PLAN.md) for the complete build plan.

**The Rule:** Nothing moves forward until the step before it is validated. Every change is checked against everything else. Upstream mistakes are catastrophic.

**Current Phase (as-built 2026-05-29):** Phases 0–14 substantially implemented; self-hosting compiler at
0.98× C. Both compiler-soundness findings resolved (value model #1, shadowing #2). Remaining work = the
honest STUB/PARTIAL rows in IMPLEMENTATION_AUDIT.md (TLS server, real-device GPU, distributed fault-
tolerance, WASM control-flow, ONNX/GGUF model formats, archetype ECS, interactive debugger, deploy). The
"Phase 0" plan below is historical. See AS_BUILT_ARCHITECTURE.md.

**Five Risk Gates:**
1. Syntax: simpler than Python? (blocks everything)
2. Type inference: 95%+ zero annotations? (blocks compiler)
3. Process ownership: works without annotations? (blocks safety promise)
4. Abstraction erasure: C-equivalent code? (blocks performance promise)
5. Code generation: matches C/Rust benchmarks? (blocks release)

**Dependency chain:** Specification → Frontend → Semantic Analysis → IR → Codegen → Runtime → Stdlib → Toolchain. Each layer validated before the next begins.
