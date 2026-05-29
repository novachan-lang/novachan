# NOVA Master Execution Plan

> **AS-BUILT NOTE (2026-05-29):** This plan is largely executed. NOVA has a self-hosting compiler at
> 0.98× C with Phases 0–14 substantially implemented. For the real implemented architecture and the
> per-feature status, see [AS_BUILT_ARCHITECTURE.md](AS_BUILT_ARCHITECTURE.md) and
> [IMPLEMENTATION_AUDIT.md](IMPLEMENTATION_AUDIT.md). The plan below remains the canonical record of
> *intent and sequencing*; the audit is the canonical record of *what is actually real*.

## The Rule

**Nothing moves forward until the step before it is validated.** Every step has a validation gate. If it fails the gate, we STOP, fix it, re-validate, and only THEN proceed. No exceptions. No "we'll fix it later." Later never comes — it just becomes 10x harder to fix.

**Every change is checked against everything else.** Before writing any piece, we ask: "If this is wrong, what else breaks? If we change this later, what must be rewritten?" The earlier something is in the chain, the more catastrophic a mistake is.

---

## Dependency Chain — What Depends on What

```
LAYER 0: Language Specification
    ├── Formal Grammar (syntax rules)
    ├── Semantic Rules (what syntax means)
    └── Type System Rules (how types work)
         │
         ▼
LAYER 1: Compiler Frontend
    ├── Lexer (depends on: grammar)
    ├── Parser (depends on: lexer + grammar)
    └── AST Design (depends on: parser + semantic rules)
         │
         ▼
LAYER 2: Semantic Analysis
    ├── Symbol Resolution (depends on: AST + module system)
    ├── Type Inference Engine (depends on: AST + type rules)
    └── Ownership Analysis (depends on: type inference + process model)
         │
         ▼
LAYER 3: Intermediate Representation
    ├── IR Design (depends on: semantic output + ALL target requirements)
    ├── Optimization Passes (depends on: IR design)
    └── Abstraction Erasure (depends on: IR + process analysis)
         │
         ▼
LAYER 4: Code Generation
    ├── Native via LLVM (depends on: IR)
    ├── WASM Backend (depends on: IR)
    └── GPU Kernel Generation (depends on: IR + tensor analysis)
         │
         ▼
LAYER 5: Runtime
    ├── Process Scheduler (depends on: process model validated)
    ├── Channel Implementation (depends on: channel types validated)
    └── Supervision Trees (depends on: scheduler)
         │
         ▼
LAYER 6: Standard Library
    ├── Core Types & Operations (depends on: type system stable)
    ├── I/O, HTTP, JSON, File (depends on: runtime stable)
    └── AI/Tensor Operations (depends on: GPU codegen working)
         │
         ▼
LAYER 7: Toolchain
    ├── CLI (nova build/run/test)
    ├── Package Manager
    ├── Formatter + Linter
    └── Language Server (LSP)
```

---

## The Critical Rule: Upstream Mistakes Are Catastrophic

| If this is wrong... | ...these must be REWRITTEN |
|---|---|
| Grammar/syntax | Lexer, parser, AST, EVERYTHING below |
| Type system rules | Type inference, semantic analysis, IR, codegen, standard library |
| Process/channel model | Ownership analysis, runtime, codegen, standard library |
| IR design | ALL backends (native, WASM, GPU), all optimizations |
| Runtime design | Standard library, deployment, tooling |

**This is why we start from the top and validate each layer before building the next.** A grammar mistake caught at Layer 0 costs hours. The same mistake caught at Layer 4 costs weeks of rewriting.

---

## PHASE 0: Language Specification (MOST CRITICAL)

### Step 0.1: Syntax Design
**What:** Define exactly what NOVA code looks like. Every keyword, every operator, every delimiter.
**Why first:** EVERYTHING depends on syntax. Parser, AST, semantic analysis, error messages — all shaped by syntax. Get this wrong, rewrite everything.

**Work:**
- Choose: indentation-based (Python) or brace-based (Go/Rust) or something new
- Define all keywords (keep MINIMAL — every keyword is permanent)
- Define operator set and precedence
- Define how values, processes, channels look in code
- Define function syntax, control flow, pattern matching
- Define how annotations/hints work (`@device`, `@stack`, etc.)

**Validation gate:**
Write these 10 programs in the proposed syntax:
1. Hello world (must be 1 line)
2. Variables, math, strings (must need zero type annotations)
3. Functions and control flow (must read like English)
4. Error handling with `or` and pattern matching
5. A simple HTTP server (must be under 5 lines)
6. A concurrent program with processes and channels
7. A simple AI inference call
8. A full-stack app skeleton (server + browser + AI)
9. A systems-level memory operation (with `@low_level`)
10. A distributed service with supervision

**Pass criteria:**
- Every program is simpler than the Python/Go/Rust equivalent
- A developer who's never seen NOVA can read each program and roughly understand it
- There is ONE obvious way to write each program, not multiple
- The syntax is internally consistent — no special cases, no exceptions
- Every piece of the Three Primitives model is expressible

**If it FAILS:** Redesign syntax. Do NOT proceed to lexer. Iterate on paper until all 10 programs feel right. This step might take multiple rounds. That's fine. Rushing past this is the worst mistake we can make.

**Consequences if we skip validation:** If syntax is wrong, we build a lexer and parser for a language that feels wrong. Then we either live with it forever (C++ mistake) or rewrite the entire frontend (wasted months).

### Step 0.2: Type System Rules
**What:** Define the exact rules for how types work. What types exist, how inference works, how channel types are derived, how process types are derived, how capability traits are auto-inferred.

**Depends on:** Step 0.1 (syntax must be settled — type syntax is part of the grammar)

**Work:**
- Define primitive types (int, float, string, bool, etc.)
- Define compound types (structs, enums/sum types, lists, maps, tensors)
- Define channel types (`channel<T>`)
- Define process types (inferred from channels)
- Define the inference algorithm (Hindley-Milner + constraints)
- Define where inference CAN'T work and annotations are required
- Define auto-derived capabilities (Sendable, GpuSafe, Copyable, etc.)
- Define how tensor shapes participate in types

**Validation gate:**
Take the 10 programs from Step 0.1. For each one:
- Walk through type inference BY HAND. Can the algorithm infer every type?
- Identify every place where inference fails and an annotation is needed
- Count: what percentage of code needs annotations? Must be <5%
- Write 5 WRONG programs (type errors). What error message does the compiler produce? Is it helpful?

**Pass criteria:**
- Inference works for 95%+ of the 10 programs without annotations
- Error messages explain WHAT went wrong, WHERE, and HOW to fix it
- Channel types and process types are correctly inferred from usage
- Capability traits are correctly derived from type structure
- Tensor shape checking catches dimension mismatches

**If it FAILS:**
- If inference fails in <90% of cases → simplify the type system. Reduce the number of type features until inference handles them.
- If inference fails in specific patterns (e.g., higher-order functions) → add targeted annotation requirements for those patterns only, not everywhere
- If tensor shape inference is too complex → make shapes runtime-checked for now, add compile-time checking later

**Consequences if we skip validation:** If type rules are wrong, the inference engine will be wrong. Building a compiler around wrong type rules means rewriting semantic analysis, IR, and potentially syntax (if we need new annotation syntax). Months of waste.

### Step 0.3: Process and Channel Semantic Rules
**What:** Define the EXACT semantics of processes and channels. When a process spawns, what happens? When a value is sent through a channel, what happens to ownership? When a process crashes, what happens to its values?

**Depends on:** Step 0.1 (syntax) + Step 0.2 (types)

**Work:**
- Define process lifecycle: spawn → running → terminated/crashed
- Define channel lifecycle: create → open → closed
- Define ownership transfer: send = move by default, copy = explicit
- Define supervision: what does a supervisor see when a child crashes?
- Define process isolation guarantees: can a process EVER access another's values? (answer: NO)
- Define what happens to channels when a process crashes (closed automatically? error propagated?)
- Define local process optimization: when does a process compile away to a function call?

**Validation gate:**
Write 5 scenarios and trace execution step by step:
1. Process A sends value to Process B. Trace ownership at every step.
2. Process B crashes while holding a value. What happens to the value? What does the supervisor see?
3. Process A sends a value through a channel that nobody is reading. What happens? (Backpressure? Buffer? Error?)
4. Two processes both try to send to the same channel simultaneously. What happens?
5. A process sends a value to a remote machine. Trace: serialization, transfer, deserialization, ownership.

**Pass criteria:**
- Every scenario has ONE clear answer (no ambiguity)
- Ownership is always clear — at every moment, exactly one process owns each value
- No scenario can cause memory corruption, data races, or undefined behavior
- The rules are simple enough to explain in one page

**If it FAILS:**
- If ownership transfer has ambiguous cases → add explicit rules for those cases
- If crash semantics are unclear → study BEAM (Erlang VM) more deeply, adopt proven patterns
- If channel semantics create deadlock possibilities → add deadlock detection rules or bounded channels

**Consequences if we skip validation:** If process semantics are ambiguous, the ownership analysis in the compiler will have bugs. These bugs will cause either: false rejections (compiler rejects valid code) or false acceptances (compiler allows unsafe code). Both destroy trust in the language.

---

## PHASE 1: Compiler Frontend

### Step 1.1: Lexer
**Depends on:** Phase 0 COMPLETE (all three steps validated)
**What:** Tokenize NOVA source code into a stream of tokens.
**Risk level:** LOW — lexers are well-understood. Unlikely to fail if grammar is correct.

**Validation gate:**
- Tokenize all 10 programs from Step 0.1
- Every token is correct
- Error messages for invalid tokens are helpful ("unexpected character '$' — NOVA uses 'or' for alternatives, not '$'")

**If it FAILS:** Grammar has a problem. Go back to Step 0.1.

### Step 1.2: Parser
**Depends on:** Step 1.1 (lexer working)
**What:** Parse token stream into an AST.
**Risk level:** MEDIUM — recursive descent + Pratt parsing is well-understood, but NOVA's syntax (especially process/channel syntax) may have ambiguities.

**Validation gate:**
- Parse all 10 programs into correct ASTs
- AST is printable and inspectable
- Parse errors have helpful messages with source location
- No ambiguities: every valid program has exactly ONE parse tree

**If it FAILS:** Grammar has ambiguities. Go back to Step 0.1 to fix. DO NOT "hack around" parser ambiguities — they will haunt every future stage.

### Step 1.3: AST Design
**Depends on:** Step 1.2 (parser working)
**What:** Ensure the AST cleanly represents ALL NOVA constructs including values, processes, channels, annotations.

**Validation gate:**
- Every construct from the 10 programs has a clear AST node
- AST is suitable for type inference (carries enough information)
- AST can represent error recovery (partial parses for IDE support)

**If it FAILS:** Parser needs adjustment. May need grammar revision.

---

## PHASE 2: Semantic Analysis (HIGHEST RISK — Novel Ideas Tested Here)

### Step 2.1: Type Inference Engine
**Depends on:** Phase 1 COMPLETE
**What:** Implement the type inference algorithm. THIS IS WHERE WE TEST IF "95% NO ANNOTATIONS" IS REAL.
**Risk level:** HIGH — This is a novel combination of Hindley-Milner + channel types + process types + tensor shapes. It might not work as smoothly as theorized.

**Validation gate (CRITICAL — NO EXCEPTIONS):**
- Run inference on all 10 programs
- Count annotations needed: MUST be <5% of code
- Error messages for type mismatches: MUST be helpful, not cryptic
- Channel type inference: compiler correctly infers what flows through each channel
- Tensor shape inference: compiler catches dimension mismatches

**If it FAILS:**
- If annotations needed are 5-15%: ACCEPTABLE with adjustment. Identify which patterns need annotations and document them. Refine inference algorithm.
- If annotations needed are 15-30%: CONCERNING. Simplify type system. Remove features that break inference. Re-validate.
- If annotations needed are >30%: VISION AT RISK. The "simpler than Python" bar is not met. Major redesign needed. STOP all forward progress. Think deeply about what's breaking inference and whether the type system can be fundamentally simplified.

**Consequences of skipping:** If we build the IR and codegen on top of a type inference engine that only works 70% of the time, every future stage will deal with "annotation needed" cases that pollute the whole codebase. The language will FEEL like Rust, not Python. Vision fails.

### Step 2.2: Ownership Analysis (Process-Based)
**Depends on:** Step 2.1 (type inference working)
**What:** Implement the analysis that verifies ownership through process boundaries. THIS IS THE MOST NOVEL PART OF NOVA. No existing language does this.
**Risk level:** VERY HIGH — This is genuinely new. The theory is sound but has never been implemented.

**Work:**
- Build analysis that tracks which process owns each value
- Detect: value used after being sent through a channel (ERROR)
- Detect: value shared between two processes without channel (ERROR)
- Prove: all local processes with no channels compile to plain functions (abstraction erasure prep)

**Validation gate (CRITICAL):**
- Run analysis on all 10 programs
- Zero false positives (compiler doesn't reject valid code)
- Zero false negatives (compiler doesn't accept unsafe code)
- Developer-friendly error messages: "You sent X on line 5, can't use it on line 8"
- The analysis does NOT require any annotations from the developer

**If it FAILS:**
- If there are specific patterns where ownership is ambiguous → add MINIMAL hints. NOT Rust-style lifetimes. At most: `copy(x)` to explicitly copy, `move(x)` to explicitly transfer. Two keywords, not a whole annotation system.
- If the analysis is too expensive (slow compilation) → optimize the algorithm. Consider making some checks incremental.
- If the analysis fundamentally can't work without annotations → THIS IS A CRITICAL FAILURE. The core innovation of NOVA is at stake. We need to deeply rethink whether process-based ownership works or whether we need a different approach. DO NOT PROCEED until this is resolved.

**Consequences of skipping:** If ownership analysis doesn't work, NOVA either has memory safety bugs (unacceptable) or needs explicit annotations everywhere (becomes Rust, vision fails). This step is make-or-break.

---

## PHASE 3: Intermediate Representation

### Step 3.1: IR Design
**Depends on:** Phase 2 COMPLETE (inference + ownership validated)
**What:** Design the intermediate representation. Must be high-level enough to preserve process/channel semantics, low-level enough for optimization.
**Risk level:** MEDIUM — IR design is well-understood but multi-target adds complexity.

**Key constraint:** The IR must support ALL targets (native, WASM, GPU) from the same representation. If we design an IR that's too native-focused, WASM and GPU backends will be painful. If it's too abstract, native performance suffers.

**Validation gate:**
- Lower all 10 programs to IR
- IR is inspectable (developer can see what the compiler produces)
- IR preserves enough information for all backends
- IR preserves process/channel information for abstraction erasure

**If it FAILS:** Redesign IR. This affects ALL backends but does NOT affect the frontend (Phases 0-2 are safe).

### Step 3.2: Abstraction Erasure
**Depends on:** Step 3.1 (IR design)
**What:** The optimization pass that removes process/channel overhead for local, non-distributed code. THIS IS WHERE WE PROVE "FAST AS C."
**Risk level:** HIGH — Concept is sound but proving zero overhead requires careful work.

**Validation gate:**
- Take a simple NOVA program (no channels, no distribution)
- Compare generated IR to what a C compiler would produce for equivalent code
- They must be functionally identical (same operations, same memory access patterns)
- Benchmark: NOVA simple program vs C equivalent. Must be within 5% performance.

**If it FAILS:**
- If overhead is 5-15%: Acceptable initially. Optimize erasure passes.
- If overhead is 15-30%: Concerning. Study where overhead comes from. Fix specific cases.
- If overhead is >30%: IR design might be wrong. Go back to Step 3.1.

---

## PHASE 4: Code Generation (First Target: Native)

### Step 4.1: Native Code via LLVM
**Depends on:** Phase 3 COMPLETE
**What:** Generate native executables via LLVM.
**Risk level:** LOW-MEDIUM — LLVM is well-documented, but NOVA's IR to LLVM IR mapping needs design.

**Validation gate:**
- All 10 programs compile to native executables
- Executables run correctly
- Performance benchmarks against C equivalents: within 10% for compute-bound code

**If it FAILS:** LLVM IR generation needs fixing. Does NOT affect Phases 0-3.

### Step 4.2: WASM Backend (LATER — NOT UNTIL NATIVE WORKS)
**Depends on:** Step 4.1 (native working)
**What:** Same IR, different target.

### Step 4.3: GPU Backend (LATER — NOT UNTIL NATIVE + WASM WORK)
**Depends on:** Step 4.1 (native) + tensor operations validated
**What:** Generate GPU kernels for tensor/parallel operations.

---

## PHASE 5: Runtime

### Step 5.1: Process Scheduler
**Depends on:** Phase 4.1 (can generate native code)
**What:** Green thread scheduler for lightweight processes. Work-stealing for load balancing.
**Risk level:** MEDIUM — Well-studied (Go, Tokio) but must match NOVA's process model.

### Step 5.2: Channel Implementation
**Depends on:** Step 5.1 (scheduler)
**What:** Typed, bounded channels with backpressure, ownership transfer, and optional network transparency.

### Step 5.3: Supervision Trees
**Depends on:** Step 5.1 + 5.2
**What:** Parent-child process relationships, crash detection, restart policies.

---

## PHASE 6: Standard Library + PHASE 7: Toolchain
(Detailed planning deferred until Phase 5 is complete — we need a working runtime to design the standard library against.)

---

## THE FIVE RISK GATES (Where NOVA Lives or Dies)

| Gate | Phase | Question | If Fail |
|---|---|---|---|
| GATE 1 | 0.1 | Does the syntax feel simpler than Python? | Redesign syntax. Everything depends on this. |
| GATE 2 | 2.1 | Does type inference work for 95%+ of code? | Simplify types, or vision fails. |
| GATE 3 | 2.2 | Does process-based ownership work without annotations? | Add minimal hints, or core innovation fails. |
| GATE 4 | 3.2 | Does abstraction erasure produce C-equivalent code? | Optimize IR, or performance promise fails. |
| GATE 5 | 4.1 | Do compiled programs match C/Rust benchmarks? | Fix codegen, or "fast" promise fails. |

If Gate 1 fails → fix before ANYTHING else
If Gate 2 fails → fix before building ownership analysis
If Gate 3 fails → fix before building IR
If Gate 4 fails → fix before releasing anything
If Gate 5 fails → fix before claiming performance parity

---

## WHAT WE BUILD THE COMPILER IN

The compiler itself will be written in Java (the creator's strongest language). This gives:
- Fastest development speed (familiar territory)
- Rich ecosystem for compiler tooling
- Cross-platform from day one (JVM runs everywhere)
- Good enough performance for a compiler

Once NOVA is mature enough, we can self-host (rewrite the compiler in NOVA). But that's Phase 8+, not now.

---

## ORDER OF WORK — WHAT WE DO FIRST

1. **RIGHT NOW:** Step 0.1 — Design the syntax. Write the 10 programs. Validate.
2. **Next:** Step 0.2 — Type system rules. Hand-trace inference on the 10 programs.
3. **Next:** Step 0.3 — Process/channel semantics. Trace 5 scenarios.
4. **THEN:** Build the compiler, one layer at a time, validating at every gate.

We do NOT skip to compiler building until the specification is validated. We do NOT skip to IR until semantic analysis is validated. We do NOT skip to code generation until IR is validated.

Every step checks against the whole. Every step has a clear pass/fail. Every failure has a response plan.
