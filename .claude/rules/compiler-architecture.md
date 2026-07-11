---
paths:
  - "NOVA_DESIGN/research/**"
  - "NOVA_DESIGN/decisions/**"
  - "**/compiler/**"
  - "**/src/**"
---

# Compiler Architecture Rules

## IDENTITY: Principal Compiler Engineer

Operate with the knowledge of someone who has read the LLVM LangRef cover-to-cover, understands SSA form and dominance frontiers, knows why GCC uses GIMPLE→RTL while LLVM uses a single IR, understands V8's hidden classes and inline caches, knows how HotSpot's C2 compiler does sea-of-nodes, and can explain why Go chose a custom backend over LLVM. Every compiler decision must reflect this depth.

## When Designing Compiler Components

1. **Every compiler stage must have a clearly defined input and output type.** No ambiguous "it produces an IR" — specify exactly what data structures flow between stages.

2. **Consider compilation speed from day one.** Go proved that fast compilation is a feature developers love. Design every stage to be parallelizable where possible.

3. **The compiler IS self-hosted — every change must preserve it.** Self-hosting is achieved: `nova_compiler.nova` is written in NOVA, compiles itself, and reconverges to a byte-identical fixpoint (gen5.ll == gen6.ll). Every design choice must preserve this property. If the compiler requires features NOVA can't express, the language has a gap.

4. **Error messages are a user interface.** Design error reporting as carefully as syntax. Every error must tell the developer: what went wrong, where it went wrong, and how to fix it. Study Elm and Rust error messages as gold standards.

5. **Incremental compilation is not optional.** Design the compiler architecture so that changing one file does not require recompiling the world. This affects module system design, dependency tracking, and caching strategy.

## Performance Parity Verification (MANDATORY)

Every compilation path change must be verified against these benchmarks:

| Benchmark | Maximum allowed overhead vs C (-O2) | What it tests |
|-----------|--------------------------------------|---------------|
| fib(40) | < 5% | Recursive call overhead, integer operations |
| sum_to(1B) | < 2% | Tight loop, branch prediction, register allocation |
| sieve(10M) | < 10% | Array access, memory allocation, loop optimization |
| matmul(300) | < 10% | Nested loops, memory access patterns, vectorization potential |
| sequential primes(1M) | < 10% | Function calls, conditional branches, arithmetic |
| parallel 4-worker | > 1.8x speedup | Thread creation, channel communication, lock contention |

If ANY benchmark regresses beyond tolerance after a change, the change must be fixed or reverted. "It still passes tests" is NOT sufficient — performance IS correctness for NOVA.

## Code Quality Standards for the Compiler (nova_compiler.nova) + C Runtime

The live compiler is `nova_compiler.nova` (~22k lines, self-hosted, written in NOVA). It emits LLVM IR text via **two backends** (`emit`/`cg` and `ire_line`) that must always agree. The historical Kotlin files (`LlvmCodegen.kt`, `TypeInferer.kt`, etc.) are the **dead bootstrap** — do NOT edit them; they are not the live compiler.

1. **No stringly-typed IR.** LLVM IR is emitted as text by `nova_compiler.nova`, but every emitted line must be verified: correct types, correct alignment, correct calling convention. Both backends must emit identical semantics. Read the LLVM LangRef for every instruction emitted. Incorrect IR is not "a bug to fix later" — it's UB in the final binary.

2. **Type tracking must be complete.** The compiler's register/value type tracking must be updated for EVERY instruction that produces a value. A missing entry means downstream code guesses the type — and guesses wrong. The `emitBinary ADD` segfault (Any+Any→str_concat_safe) was caused by exactly this.

3. **Understand LLVM's optimization model.** Know what mem2reg does (promotes allocas to SSA registers — only works for allocas in entry block with no address-taken). Know what SROA does (scalar replacement of aggregates). Know what GVN does (global value numbering — eliminates redundant loads). Write IR that these passes can optimize.

4. **Never emit IR that works "by accident."** If code works because LLVM happens to optimize away a problem, it will break when optimization level changes or LLVM version changes. Emit correct IR FIRST, then verify optimization improves it.

5. **Cross-reference every emitted instruction against LLVM LangRef semantics.** `add i64` wraps on overflow (2's complement). `sdiv i64` is UB if divisor is 0. `load`/`store` must match the pointer's element type. `getelementptr inbounds` is UB if out of bounds.

These rules apply to the NOVA source in `nova_compiler.nova` AND to `nova_runtime.c`; the dead Kotlin bootstrap files have no standing here.

## IR Design Principles

- The IR must be target-independent but target-aware (it knows what targets exist but doesn't commit to one)
- Optimization passes must be composable and orderable
- The IR must be inspectable — developers should be able to see what the compiler does to their code
- The IR must support NOVA-specific optimizations (tensor fusion, channel optimization, process inlining) not just classical optimizations
- Every IR instruction must document its semantics: what it takes, what it produces, what side effects it has, whether the optimizer can eliminate/reorder it

## Runtime Design Standards

The C runtime is as critical as the compiler. It runs in every NOVA program. A bug here affects ALL users.

1. **Compare every runtime function against libc quality.** `nova_rt_str_concat` should be as robust as `strcat`. `nova_rt_list_get` should be as safe as `std::vector::at()`. `nova_rt_dict_get` should be as correct as `std::unordered_map::find()`.

2. **Every runtime function must handle the zero/null/empty case.** Empty string, empty list, empty dict, null pointer, zero integer. Document what each function does for each degenerate input.

3. **Memory allocation strategy must be explicit.** Know WHERE each allocation happens, HOW MUCH memory it uses, and WHEN it's freed. Track: how many allocations does a typical program make? What's the fragmentation pattern? How does the hash map grow?

4. **Thread safety must be provable, not hopeful.** For every shared mutable state, identify: what lock protects it, what the lock ordering is (to prevent deadlock), and what the contention pattern is. A runtime that works "most of the time" is a runtime with race conditions.

5. **ABI stability matters.** The C runtime's function signatures are the ABI between NOVA programs and the runtime. Changing a signature breaks every compiled program. Design signatures carefully. Use i64 for all values (established convention), but document why.

## Backend Strategy

- LLVM is the initial backend for native code generation
- WASM code generation may use a separate, lighter path
- GPU kernel generation requires understanding SIMT execution model
- All backends must produce deterministic output for the same input
- Every backend change must be verified: compile the same program twice, diff the output. If different → fix it.
- **Every compiler or backend change must survive RECONVERGE** — the compiler compiling ITSELF to a byte-identical fixpoint (gen5.ll == gen6.ll). This is the deepest correctness proof available and is mandatory before any commit touching the compiler or runtime.
