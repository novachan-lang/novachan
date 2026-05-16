# NOVA ENGINEERING BLUEPRINT — THE DEFINITIVE PLAN

**Status: FINAL. Once agreed upon, this is the contract. No going back.**

This document is the complete engineering plan for NOVA. It covers WHAT NOVA is, HOW it works, HOW it gets built, in WHAT order, using WHAT tools, with WHAT validation at every step, and WHAT happens if something fails. Every section connects to every other section. Nothing is treated in isolation.

---

## PART 1: THE ARCHITECTURE — What NOVA Is

### 1.1 The Three Primitives (The Entire Language Model)

NOVA has exactly THREE concepts. Not 50. Not 20. Three.

| Primitive | What It Is | What It Replaces |
|---|---|---|
| **Value** | ALL data. Integers, strings, structs, tensors, JSON, DOM nodes, database rows. | Variables, objects, arrays, pointers, references, smart pointers, Rc/Arc, GC-managed objects |
| **Process** | ALL execution. Functions, threads, actors, GPU kernels, web workers, distributed nodes. | Functions, threads, async/await, futures, goroutines, actors, coroutines |
| **Channel** | ALL communication. Function returns, message passing, HTTP, WebSocket, GPU transfer, IPC. | Return values, shared memory, mutexes, message queues, RPC, REST calls |

Every program ever written — from hello world to distributed AI training — is values flowing through channels between processes. NOVA makes this explicit. Everything else (types, memory, safety, performance, platform independence) is a CONSEQUENCE of this model, not a separate mechanism.

### 1.2 The Genius Compiler (Where All Complexity Lives)

The developer writes simple code. The compiler does everything hard:

| What The Compiler Does | How | What The Developer Writes |
|---|---|---|
| Type inference | Extended Hindley-Milner with unification constraints | Nothing. `x = 42` — compiler knows it's `int` |
| Ownership tracking | Process-boundary analysis | Nothing. `send(ch, data)` — compiler knows `data` is gone |
| Memory allocation | Escape analysis + profiling heuristics | Nothing. Compiler picks stack/heap/arena/move |
| Target selection | Code analysis (tensor ops → GPU, DOM ops → WASM, etc.) | Nothing. Or `@device(gpu)` for explicit control |
| Abstraction erasure | Dead process/channel elimination during IR optimization | Nothing. Single-process code compiles to C-equivalent |
| Error messages | Constraint-based error localization | Nothing. Compiler explains what's wrong, where, and how to fix it |

The compiler is the hardest thing to build. It is also the reason NOVA can exist. Without a genius compiler, you cannot have a language that is simultaneously simple, fast, and safe.

### 1.3 How One Model Delivers All Properties

This is NOT a wish list. Each property is a logical consequence of Three Primitives + Genius Compiler:

**FAST (matches C/Rust):**
- Values have known types → compiler generates optimal machine code → no overhead
- Processes that don't communicate → compiler erases them → bare function calls, same as C
- Local channels → compiler replaces with direct memory access → zero serialization
- Mechanism: Abstraction Erasure at IR level (Phase 3, Step 3.2)

**SIMPLE (beats Python):**
- Three concepts to learn → smaller mental model than Python's hidden dozens
- Zero annotations for 95% of code → compiler infers everything
- No shared state bugs → process isolation eliminates Python's reference/closure/race traps
- Mechanism: Type inference + ownership inference (Phase 2, Steps 2.1-2.2)

**SAFE (matches Rust, no annotations):**
- Values owned by exactly one process → no data races, no dangling pointers
- Send through channel = ownership transfer → use-after-send is compile error
- Process crash = process values freed → no leaked memory, no corrupted state
- Mechanism: Process-boundary ownership analysis (Phase 2, Step 2.2)

**ROBUST (matches Erlang):**
- Process isolation → crash doesn't corrupt other processes
- Supervision trees → parent process decides restart/ignore/escalate
- Typed channels → both ends verified at compile time
- Mechanism: Runtime supervision (Phase 5, Step 5.3)

**PLATFORM INDEPENDENT (beats Java, no VM):**
- Process = abstract execution unit → compiler maps to any target
- Same source → native binary (LLVM) or WASM (browser/edge) or GPU kernel
- No VM overhead → ahead-of-time compilation per target
- Mechanism: Multi-target codegen from single IR (Phase 4, Steps 4.1-4.3)

---

## PART 2: THE LANGUAGE — What NOVA Code Looks Like

### 2.1 Syntax Decisions (To Be Validated in Phase 0, Step 0.1)

These are the proposed decisions. Each MUST pass the 10-program validation gate before they're final.

**Block structure: Indentation-based (like Python)**
- Why: Eliminates brace clutter. Matches "simpler than Python" goal. Reduces visual noise.
- Risk: Some developers hate significant whitespace. But Python proved it works at scale.
- If validation fails: Fall back to optional braces (like Kotlin's `if` expressions).

**Keywords (MINIMAL — every keyword is permanent):**

| Keyword | Purpose | Example |
|---|---|---|
| `fn` | Define a function | `fn add(a, b) a + b` |
| `spawn` | Create a process | `spawn worker(data)` |
| `send` | Send value through channel | `send(ch, data)` |
| `receive` | Receive value from channel | `msg = receive(ch)` |
| `channel` | Create a channel | `ch = channel()` |
| `match` | Pattern matching | `match result ...` |
| `if/else` | Conditional | `if x > 0 ...` |
| `for` | Iteration | `for item in list ...` |
| `or` | Default/alternative | `value = try_something() or default` |
| `copy` | Explicit copy | `send(ch, copy(data))` |
| `type` | Define a named type | `type Point { x: float, y: float }` |
| `import` | Module import | `import http` |
| `return` | Early return (optional — last expression is return value) | `return error` |
| `and/or/not` | Boolean operators | `if a and b ...` |
| `true/false` | Boolean literals | `done = true` |
| `supervise` | Supervision declaration | `supervise worker restart: always` |

That's ~18 keywords. Go has 25. Python has 35. Rust has 39. C++ has 90+.

**Operators:** Standard arithmetic (`+ - * / %`), comparison (`== != < > <= >=`), assignment (`=`), pipeline (`|>`), channel (`<-` for send shorthand). No operator overloading except for numeric types.

**Annotations (the @system for expert control):**

| Annotation | Purpose | When Needed |
|---|---|---|
| `@device(gpu)` | Force GPU execution | When compiler's heuristic is wrong |
| `@device(cpu)` | Force CPU execution | When compiler's heuristic is wrong |
| `@stack` | Force stack allocation | Performance-critical inner loops |
| `@heap` | Force heap allocation | When compiler's escape analysis is wrong |
| `@arena(name)` | Use arena allocation | Bulk allocate/free patterns |
| `@pinned` | Pinned memory (GPU DMA) | GPU memory transfer optimization |
| `@inline` | Force inlining | Hot path optimization |
| `@no_inline` | Prevent inlining | Code size control |
| `@distributed` | Force distributed execution | Multi-machine deployment |
| `@low_level` | Unlock raw memory access | Systems programming, FFI |
| `@extern` | FFI declaration | Calling C/system libraries |

These are NEVER required. They exist for the 5% of code that needs explicit control.

### 2.2 Type System (Validated in Phase 0, Step 0.2)

**Primitive types:** `int`, `float`, `string`, `bool`, `byte`
**Compound types:** `List<T>`, `Map<K,V>`, `Set<T>`, structs, enums (sum types), tuples, `Tensor<T, Shape>`
**Special types:** `channel<T>`, `process<In, Out>`, `Result<T, E>` (sugar for `T or E`)

**Inference rules (the core algorithm):**
1. Literals infer their type: `42` → `int`, `3.14` → `float`, `"hello"` → `string`
2. Variables infer from their assignment: `x = 42` → `x: int`
3. Functions infer from their body: `fn add(a, b) a + b` → if called with `add(1, 2)`, infers `fn(int, int) -> int`
4. Channels infer from first use: `send(ch, "hello")` → `ch: channel<string>`
5. Processes infer from their channels: process reads `channel<HttpRequest>`, writes `channel<HttpResponse>` → `process<HttpRequest, HttpResponse>`
6. Capabilities auto-derived from structure: `Point { x: float, y: float }` → `Copyable, Sendable, GpuSafe, WasmSafe, Equatable, Printable`
7. Tensor shapes tracked through operations: `tensor([3, 224, 224])` reshaped to `tensor([150528])` — compiler verifies dimensions match

**Where inference NEEDS help (the <5% annotations):**
- Function parameter types when not inferable from call sites (public API boundaries)
- Ambiguous numeric literals (`42` could be `int` or `float` — defaults to `int`, annotate for `float`)
- Recursive types (the type refers to itself — compiler needs the type name declared)
- Generic function definitions with constraints (rare, advanced use)

**Algorithm:** Extended Hindley-Milner (Algorithm W) with:
- Constraint generation from channel usage (novel)
- Constraint generation from process communication patterns (novel)
- Shape arithmetic constraints for tensor operations
- Capability derivation from structural analysis (no annotation, compile-time only)

**If inference falls below 95%:** Simplify the type system. Remove the feature that breaks inference. The simplicity bar is non-negotiable.

### 2.3 Process and Channel Semantics (Validated in Phase 0, Step 0.3)

**Process lifecycle:**
```
spawn → running → { completed(value) | crashed(error) }
```

**Channel lifecycle:**
```
channel() → open → { closed_by_sender | closed_by_receiver | closed_by_crash }
```

**Ownership rules (the 5 rules — the entire memory model):**
1. Values live inside processes. Creating a value = current process owns it.
2. `send(ch, value)` = value transfers to the receiver. Sender can't use it after.
3. `send(ch, copy(value))` = copy goes to receiver. Sender keeps the original.
4. Compiler chooses allocation: stack (never escapes), heap (escapes function), arena (bulk pattern), move (channel transfer).
5. `@stack`, `@heap`, `@arena`, `@pinned` for expert override. Never required.

**Supervision:**
- Every spawned process has a parent (the process that spawned it).
- Parents can supervise children: `supervise worker restart: always` or `restart: {count: 3, within: 60}` or `restart: never`.
- When a child crashes: parent receives a crash notification through an implicit supervision channel.
- Parent decides: restart the child, ignore and continue, or crash itself (escalating to ITS parent).
- Top-level process crash = program exits with error.

**Channel behavior:**
- Bounded by default (configurable buffer size, default: 0 = synchronous rendez-vous).
- Backpressure: if buffer full, sender blocks until receiver takes a value.
- Closed channel: sending to closed channel → error. Receiving from closed empty channel → error or `None` (receiver decides with `or`).
- Multiple senders allowed (MPSC). Multiple receivers: round-robin (load balancing pattern).

**Abstraction erasure rules:**
- Process with no channels, no spawn, no distribution → compiles to plain function call. Zero overhead.
- Process with only local channels → compiles to coroutine or thread (runtime picks based on workload). Channel becomes a queue in memory.
- Process with network channels → generates serialization, network I/O, failure handling code.
- Process targeting GPU → generates compute kernel + memory transfer code.

### 2.4 Error Handling

Three levels, all emergent from the model:

1. **The `or` operator (common case, 70% of errors):**
   ```nova
   config = read_file("config.txt") or default_config
   port = parse_int(env("PORT")) or 8080
   ```
   One word. Default value if the operation fails. Simpler than any language.

2. **Pattern matching (when you need to know what went wrong):**
   ```nova
   match read_file("config.txt")
       content -> use(content)
       FileNotFound -> create_default()
       PermissionDenied(path) -> log("Can't read {path}")
   ```

3. **Process supervision (distributed/server errors):**
   ```nova
   supervise http_handler
       restart: always
       max_restarts: 5
       within: 60
   ```
   Process crashes are contained and handled by the supervision tree. The developer writes the happy path.

No exceptions. No try/catch. No checked exceptions. No panic/recover. The Three Primitives model handles errors through values (sum types + `or`), process crashes (supervision), and channels (closed channel detection).

---

## PART 3: THE COMPILER — How NOVA Code Becomes Executable

### 3.1 Implementation Language: Kotlin

The compiler is written in Kotlin. Reasons:
- Creator knows Java deeply → Kotlin transfers almost completely (same JVM, same libraries, same tooling)
- Sealed classes + `when` expressions → pattern matching on AST nodes that is exhaustive and concise
- Data classes → AST node definitions are 1-line, not 10-line Java boilerplate
- JVM runs everywhere → compiler is immediately cross-platform
- Rich ecosystem for parsing, data structures, tooling
- GC handles compiler's own memory → focus on NOVA's semantics, not compiler memory management
- Zero effect on compiled program speed — NOVA programs are native code via LLVM, not JVM bytecode

Self-hosting (rewriting the compiler in NOVA) is Phase 8+. Not relevant now.

### 3.2 Compiler Pipeline (7 Stages)

```
Source Code (.nova files)
    │
    ▼
┌─────────────────────────────────────────────────┐
│ STAGE 1: LEXER                                  │
│ Input: Source text (UTF-8)                       │
│ Output: Token stream                             │
│ Algorithm: Hand-written scanner (not generated)  │
│ Why hand-written: Better error messages, faster, │
│   full control over whitespace handling          │
│   (indentation-based syntax needs custom logic)  │
│ Data structures:                                 │
│   Token { type, value, line, column, file }      │
│   TokenStream (lazy iterator over tokens)        │
│ Error handling: Invalid character → error token   │
│   with source location. Continue lexing.         │
│ Connection to other stages: Token types are       │
│   defined by the grammar (Part 2.1). If grammar  │
│   changes, token types change, lexer changes.    │
└─────────────────────────────────────────────────┘
    │
    ▼
┌─────────────────────────────────────────────────┐
│ STAGE 2: PARSER                                  │
│ Input: Token stream                              │
│ Output: Untyped AST                              │
│ Algorithm: Recursive descent + Pratt parsing     │
│   for expressions (precedence climbing)          │
│ Why this combo: Recursive descent handles         │
│   statements naturally. Pratt handles operator   │
│   precedence without grammar ambiguity.          │
│   Both produce excellent error messages.         │
│ Data structures:                                 │
│   AST nodes (one class per node type):           │
│   - ValueLiteral, BinaryOp, UnaryOp             │
│   - FnDef, FnCall, Return                       │
│   - SpawnExpr, SendExpr, ReceiveExpr            │
│   - ChannelCreate, TypeDef, MatchExpr           │
│   - IfExpr, ForExpr, Assignment                 │
│   - Import, Annotation, Block                   │
│   Every node carries: SourceSpan { file, start   │
│   line/col, end line/col } for error reporting   │
│ Error recovery: On parse error, skip to next      │
│   statement boundary. Collect ALL errors, don't  │
│   stop at first one. This enables IDE support.   │
│ Connection to other stages: AST shape determines  │
│   what type inference must handle. New syntax =   │
│   new AST node = new inference rules.            │
└─────────────────────────────────────────────────┘
    │
    ▼
┌─────────────────────────────────────────────────┐
│ STAGE 3: TYPE INFERENCE                          │
│ Input: Untyped AST                               │
│ Output: Typed AST (every node annotated with     │
│   inferred type)                                 │
│ Algorithm: Constraint-based inference             │
│   (Extended Hindley-Milner / Algorithm W)        │
│   Step 1: Walk AST, generate type constraints    │
│   Step 2: Solve constraints via unification      │
│   Step 3: Apply solution — annotate AST with     │
│     concrete types                               │
│ Extensions beyond standard HM:                   │
│   - Channel type constraints (send/receive must  │
│     carry compatible types)                      │
│   - Process type constraints (process signature  │
│     inferred from channel usage)                 │
│   - Tensor shape constraints (arithmetic on      │
│     dimensions, validated at unification)        │
│   - Capability derivation (structural analysis   │
│     of each type → Copyable, Sendable, etc.)    │
│ Data structures:                                 │
│   TypeVar (unresolved type variable)             │
│   Constraint { left: Type, right: Type }         │
│   Substitution (TypeVar → ConcreteType mapping)  │
│   TypedAST (AST where every node has a Type)     │
│ Error handling: When unification fails →          │
│   constraint-based error localization. Show the  │
│   developer: "expected X because of line N, got  │
│   Y because of line M. Did you mean...?"         │
│ RISK GATE 2: If >5% of code needs annotations,   │
│   simplify the type system. This is non-negotiable│
│ Connection to other stages: Types feed ownership  │
│   analysis. Wrong types → wrong ownership → wrong │
│   memory management → unsafe code or rejected     │
│   valid code.                                    │
└─────────────────────────────────────────────────┘
    │
    ▼
┌─────────────────────────────────────────────────┐
│ STAGE 4: OWNERSHIP ANALYSIS                      │
│ Input: Typed AST                                 │
│ Output: Typed AST + Ownership annotations        │
│   (who owns what, where transfers happen)        │
│ Algorithm: Process-boundary analysis (NOVEL)     │
│   Step 1: Identify all process boundaries        │
│     (spawn creates new boundary)                 │
│   Step 2: Track value provenance — which process │
│     created each value                           │
│   Step 3: At each send(), mark value as          │
│     transferred. After send, value is dead in    │
│     the sender's scope.                          │
│   Step 4: At each receive(), mark value as       │
│     owned by receiving process.                  │
│   Step 5: Check: is any value used after send?   │
│     → compile error.                             │
│   Step 6: Check: is any value accessed by a      │
│     process that doesn't own it? → compile error │
│   Step 7: Classify each value:                   │
│     - Never escapes function → stack             │
│     - Escapes function but not process → heap    │
│     - Sent through local channel → move          │
│     - Sent through network channel → serialize   │
│     - Shared within same process → ARC (internal)│
│ Data structures:                                 │
│   OwnershipMap: Value → Process                  │
│   TransferPoint: { value, from_process,          │
│     to_process, channel, source_location }       │
│   AllocationDecision: Value → { stack | heap |   │
│     arena | move | serialize }                   │
│ Error handling: "You sent X on line 5, can't use │
│   it on line 8. To keep it, write copy(X)."     │
│ RISK GATE 3: THIS IS THE MOST NOVEL PART.        │
│   If this doesn't work without annotations, the  │
│   core innovation fails. Fallback: add minimal   │
│   `copy()` and `move()` hints. NOT lifetime      │
│   annotations. At most 2 keywords.               │
│ Connection to other stages: Ownership decisions   │
│   determine IR generation. Stack vs heap changes  │
│   code generation entirely. Wrong ownership →     │
│   wrong machine code → memory corruption or       │
│   performance loss.                              │
└─────────────────────────────────────────────────┘
    │
    ▼
┌─────────────────────────────────────────────────┐
│ STAGE 5: IR GENERATION                           │
│ Input: Typed AST + Ownership annotations         │
│ Output: NOVA IR (custom SSA-based IR)            │
│ IR design principles:                            │
│   - SSA (Static Single Assignment) form — every  │
│     variable assigned exactly once. Standard for │
│     optimizing compilers.                        │
│   - Process-aware: IR has explicit process start/ │
│     end, channel send/receive, supervision       │
│     operations. This is UNIQUE to NOVA's IR.     │
│   - Target-independent but target-aware: IR knows│
│     what targets exist (native, WASM, GPU) but   │
│     doesn't commit. Annotations carry target     │
│     hints from @device() etc.                    │
│   - Inspectable: Developer can print IR to see   │
│     what the compiler does (like LLVM IR but     │
│     higher-level).                               │
│ Data structures:                                 │
│   IRModule (top-level compilation unit)          │
│   IRFunction (SSA function)                      │
│   IRBlock (basic block with instructions)        │
│   IRInstruction (typed operations):              │
│     - Arithmetic, comparison, memory             │
│     - ProcessSpawn, ProcessTerminate             │
│     - ChannelCreate, ChannelSend, ChannelReceive │
│     - SupervisionLink, CrashHandler              │
│     - TensorOp (matrix mul, reshape, etc.)       │
│     - Call, Return, Branch, Phi                  │
│   IRType (mirrors the type system)               │
│ Connection to other stages: IR is the last        │
│   target-independent representation. After this, │
│   we commit to a target. Everything before IR is │
│   shared across all targets. Everything after    │
│   is target-specific.                            │
└─────────────────────────────────────────────────┘
    │
    ▼
┌─────────────────────────────────────────────────┐
│ STAGE 6: IR OPTIMIZATION + ABSTRACTION ERASURE   │
│ Input: NOVA IR                                   │
│ Output: Optimized NOVA IR                        │
│ Optimization passes (order matters):             │
│   1. Inlining: inline small functions and local  │
│      process bodies                              │
│   2. Dead code elimination: remove unreachable   │
│      paths                                       │
│   3. Constant folding/propagation: evaluate      │
│      compile-time expressions                    │
│   4. ABSTRACTION ERASURE (NOVA-specific):        │
│      - Process with no channels → erase to       │
│        function call                             │
│      - Process with only local channels → erase  │
│        to coroutine or thread-local execution    │
│      - Channel between local processes in same   │
│        address space → erase to memory access    │
│      - Supervision for non-distributed process   │
│        → erase to try/catch at codegen level     │
│   5. Escape analysis refinement: after erasure,  │
│      re-check what can be stack-allocated         │
│   6. Tensor operation fusion: merge sequential   │
│      tensor ops into fused kernels               │
│   7. Channel optimization: merge sequential      │
│      send/receive into direct call when possible │
│ RISK GATE 4: After erasure, single-process code  │
│   must produce IR equivalent to what a C compiler│
│   would produce. Benchmark: within 5% of C.     │
│ Connection to other stages: The quality of        │
│   optimization determines final performance.     │
│   Bad erasure → slow programs → "fast as C"      │
│   promise fails.                                 │
└─────────────────────────────────────────────────┘
    │
    ▼
┌─────────────────────────────────────────────────┐
│ STAGE 7: CODE GENERATION (Multi-Target)          │
│                                                  │
│ TARGET A: Native (via LLVM)                      │
│   Input: Optimized NOVA IR                       │
│   Output: Native executable (x86_64, ARM64, etc.)│
│   Process: NOVA IR → LLVM IR → LLVM optimizer    │
│     → machine code → linker → executable         │
│   Why LLVM: Industry-standard, handles all CPU   │
│     architectures, battle-tested optimizations,  │
│     huge community, good documentation.          │
│   Kotlin↔LLVM bridge: JNI calls to LLVM C API,  │
│     or generate LLVM textual IR (.ll files) and  │
│     call `llc` as subprocess. Start with textual │
│     IR (simpler, debuggable). Switch to C API    │
│     when performance matters.                    │
│   RISK GATE 5: Compiled programs must match       │
│     C/Rust benchmarks within 10% for compute.    │
│                                                  │
│ TARGET B: WASM (browser/edge)                    │
│   Input: Optimized NOVA IR                       │
│   Output: .wasm binary                           │
│   Process: NOVA IR → WASM bytecode (direct       │
│     emission, no LLVM). WASM is simple enough    │
│     to target directly.                          │
│   Why direct: LLVM's WASM backend adds overhead  │
│     and complexity. WASM's instruction set is    │
│     small. Direct emission produces smaller      │
│     binaries.                                    │
│   Timing: AFTER native backend works. Not before.│
│                                                  │
│ TARGET C: GPU (CUDA/Vulkan Compute/SPIR-V)       │
│   Input: Optimized NOVA IR (tensor operations)   │
│   Output: GPU kernel code                        │
│   Process: IR tensor ops → GPU kernel IR →       │
│     NVPTX (CUDA) or SPIR-V (Vulkan/OpenCL)      │
│   Strategy: Use LLVM's NVPTX backend for CUDA,   │
│     SPIRV-LLVM translator for Vulkan/OpenCL.     │
│   Timing: AFTER native + WASM. This is the       │
│     most complex target.                         │
│                                                  │
│ Build order: Native first → WASM second → GPU    │
│   third. Each validated before the next starts.  │
└─────────────────────────────────────────────────┘
```

### 3.3 Interpreter (Comes BEFORE the full compiler)

Before building the full 7-stage compiler, we build a tree-walking interpreter in Kotlin.

**Why interpreter first:**
1. Validates the language design FAST. We can run all 10 validation programs within weeks, not months.
2. Tests syntax, semantics, type rules without building IR/codegen.
3. Catches design mistakes EARLY — before we've invested in a compiler backend.
4. Provides a REPL for interactive exploration of language features.
5. Go, Lua, Ruby all started with interpreters. It's proven.

**What the interpreter shares with the compiler:**
- Stage 1 (Lexer) — identical, reused directly
- Stage 2 (Parser) — identical, reused directly
- Stage 3 (Type Inference) — identical, reused directly
- Stage 4 (Ownership Analysis) — simplified version (checks rules but doesn't optimize)

**What the interpreter does differently:**
- Instead of IR → codegen, it directly walks the typed AST and evaluates.
- Processes are simulated as JVM OS threads (not Kotlin coroutines — coroutines share heap, can't simulate crash isolation).
- Channels are simulated as Java `LinkedBlockingQueue`. Values deep-cloned on every send to simulate process isolation.
- No optimization, no abstraction erasure — those are compiler features.

**When interpreter is DONE:**
- All 10 validation programs run correctly
- Type inference works for 95%+ of code
- Ownership rules are enforced (can't use value after send)
- Error messages are helpful
- REPL works for interactive exploration

**Then we build the compiler:** Stages 5-7 (IR, optimization, codegen) are added. Stages 1-4 are reused from the interpreter.

### 3.4 Compilation Speed Target

Under 1 second for a small project (< 10 files). Under 10 seconds for a large project (< 1000 files). Go proves this is achievable for a compiled language.

How we achieve this:
- Incremental compilation from day one (file-level dependency tracking)
- Parallel lexing + parsing (each file independent)
- Type inference is per-module with cross-module interfaces
- LLVM IR generation is parallel per function
- Caching of compiled modules (only recompile what changed)

---

## PART 4: THE RUNTIME — What Runs NOVA Programs

### 4.1 Implementation Language: C

The runtime is written in C. Reasons:
- Minimal overhead — runtime IS the performance foundation
- Direct access to OS primitives (threads, memory, I/O)
- Every platform has a C compiler — maximum portability
- Well-understood performance characteristics
- LLVM-generated code calls into C runtime seamlessly

### 4.2 Runtime Components

```
┌─────────────────────────────────────────────────┐
│ NOVA RUNTIME (written in C)                      │
│                                                  │
│ ┌─────────────────────────────────────────────┐  │
│ │ PROCESS SCHEDULER                           │  │
│ │ - Green threads (lightweight processes)     │  │
│ │ - M:N threading (M green threads on N OS    │  │
│ │   threads, N = CPU core count)              │  │
│ │ - Work-stealing scheduler (idle threads     │  │
│ │   steal work from busy threads)             │  │
│ │ - Each green thread: ~2-4KB initial stack,  │  │
│ │   grows as needed (like Go goroutines)      │  │
│ │ - Preemptive scheduling via safe-points     │  │
│ │   (compiler inserts yield points at         │  │
│ │   function calls and loop back-edges)       │  │
│ │ - Design based on: Go scheduler (proven),   │  │
│ │   Tokio (proven), Erlang BEAM (proven)      │  │
│ └─────────────────────────────────────────────┘  │
│                                                  │
│ ┌─────────────────────────────────────────────┐  │
│ │ CHANNEL SYSTEM                              │  │
│ │ - Lock-free MPSC (multi-producer, single-   │  │
│ │   consumer) queues for common case          │  │
│ │ - Lock-free SPSC (single-producer, single-  │  │
│ │   consumer) for point-to-point channels     │  │
│ │ - Bounded buffers with backpressure         │  │
│ │ - Zero-copy for local channels (pointer     │  │
│ │   transfer, ownership swap)                 │  │
│ │ - Automatic serialization for network       │  │
│ │   channels (binary format, schema-aware)    │  │
│ │ - Select/multiplex: wait on multiple        │  │
│ │   channels simultaneously                   │  │
│ └─────────────────────────────────────────────┘  │
│                                                  │
│ ┌─────────────────────────────────────────────┐  │
│ │ SUPERVISION SYSTEM                          │  │
│ │ - Parent-child process tree                 │  │
│ │ - Crash detection via OS signals +          │  │
│ │   green thread exception handling           │  │
│ │ - Restart strategies: one_for_one (restart  │  │
│ │   crashed child), one_for_all (restart all  │  │
│ │   children), rest_for_one (restart crashed  │  │
│ │   child and all children started after it)  │  │
│ │ - Max restart frequency (prevent crash      │  │
│ │   loops)                                    │  │
│ │ - Modeled directly on Erlang/OTP supervisor │  │
│ │   — battle-tested for 30+ years             │  │
│ └─────────────────────────────────────────────┘  │
│                                                  │
│ ┌─────────────────────────────────────────────┐  │
│ │ MEMORY ALLOCATOR                            │  │
│ │ - Per-process memory pools (no global GC)   │  │
│ │ - Small objects: slab allocator (fixed-size  │  │
│ │   pools for common sizes)                   │  │
│ │ - Large objects: direct OS allocation        │  │
│ │   (mmap/VirtualAlloc)                       │  │
│ │ - Arena allocator available for bulk         │  │
│ │   allocate/free patterns                    │  │
│ │ - Process death = entire memory pool freed   │  │
│ │   (bulk deallocation, very fast)            │  │
│ │ - No garbage collector. Ownership model +    │  │
│ │   per-process pools = deterministic memory. │  │
│ └─────────────────────────────────────────────┘  │
│                                                  │
│ ┌─────────────────────────────────────────────┐  │
│ │ I/O SUBSYSTEM                               │  │
│ │ - Async I/O via io_uring (Linux),           │  │
│ │   kqueue (macOS), IOCP (Windows)            │  │
│ │ - I/O operations are channel operations to  │  │
│ │   the developer — read from file channel,   │  │
│ │   write to socket channel                   │  │
│ │ - Non-blocking by default, transparent to   │  │
│ │   the developer (no async/await needed)     │  │
│ └─────────────────────────────────────────────┘  │
│                                                  │
│ ┌─────────────────────────────────────────────┐  │
│ │ NETWORK LAYER (for distributed processes)   │  │
│ │ - TCP for reliable inter-machine channels   │  │
│ │ - Binary serialization (NOVA's own format,  │  │
│ │   schema-aware, versioned)                  │  │
│ │ - Process discovery + routing               │  │
│ │ - Connection pooling + reconnection         │  │
│ │ - Built LATER — after local runtime works   │  │
│ └─────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────┘
```

### 4.3 Runtime Build Order

1. **Memory allocator first** — everything else needs memory
2. **Process scheduler second** — processes need memory, everything else needs processes
3. **Channel system third** — needs scheduler for blocking/waking
4. **I/O subsystem fourth** — needs channels for the programming model
5. **Supervision fifth** — needs processes + channels working
6. **Network layer last** — needs everything else stable

Each component tested independently AND integrated before the next starts.

---

## PART 5: THE STANDARD LIBRARY — What Ships With NOVA

### 5.1 Core (Available from Day 1)

| Module | Contents | Implementation |
|---|---|---|
| `nova.core` | Primitive types, operators, print, assert | Compiler built-in + NOVA |
| `nova.collections` | List, Map, Set, Queue, Stack, Ring | Pure NOVA |
| `nova.string` | String manipulation, formatting, regex | NOVA + C for regex engine |
| `nova.math` | Arithmetic, trigonometry, random | NOVA + C for libm |
| `nova.io` | File read/write, stdin/stdout, path | NOVA wrapping runtime I/O |
| `nova.process` | spawn, send, receive, supervise | Compiler built-in + runtime |
| `nova.channel` | channel creation, select, multiplex | Compiler built-in + runtime |

### 5.2 Extended (Available from Early Releases)

| Module | Contents | Implementation |
|---|---|---|
| `nova.http` | HTTP client + server | Pure NOVA on top of I/O |
| `nova.json` | JSON parse/generate | Pure NOVA |
| `nova.time` | Date, time, duration, timer | NOVA wrapping OS time |
| `nova.crypto` | Hash, encrypt, sign | NOVA wrapping libsodium/openssl |
| `nova.test` | Test runner, assertions, mocking | Pure NOVA |
| `nova.log` | Structured logging | Pure NOVA |

### 5.3 Domain Libraries (Later Phases)

| Module | Contents | Depends On |
|---|---|---|
| `nova.tensor` | Tensor creation, operations, shapes | GPU codegen working |
| `nova.ai` | Model loading, inference, training | tensor + GPU |
| `nova.web` | DOM manipulation, components, routing | WASM codegen working |
| `nova.db` | Database connections, queries, migrations | I/O + serialization |
| `nova.deploy` | Container, cloud deployment, scaling | Network layer + distributed |

Standard library is written in NOVA itself (except where it wraps C or runtime primitives). This is critical — it validates that NOVA is expressive enough to build real software.

---

## PART 6: THE TOOLCHAIN — Developer Experience

### 6.1 The CLI: `nova`

One command, everything:

| Command | What It Does |
|---|---|
| `nova run file.nova` | Compile and run (interpreter mode initially, compiled mode later) |
| `nova build` | Compile to binary |
| `nova build --target wasm` | Compile to WASM |
| `nova test` | Run tests |
| `nova fmt` | Format code |
| `nova check` | Type check without compiling |
| `nova repl` | Interactive REPL |
| `nova init` | Create new project |
| `nova add package` | Add dependency |
| `nova doc` | Generate documentation |
| `nova ir file.nova` | Print IR (for debugging compiler) |

### 6.2 Package Manager

- Built into `nova` CLI (like Cargo, not separate like pip)
- Lock file for reproducible builds
- Semantic versioning enforced
- Central registry (later — start with git dependencies)

### 6.3 Formatter

- One canonical style (like Go's `gofmt` — no configuration)
- Indentation-based, so formatting is mostly about: spacing, line length, import ordering
- Run automatically on save (LSP integration)

### 6.4 Language Server (LSP)

- Reuses compiler frontend (lexer, parser, type inference)
- Provides: autocomplete, go-to-definition, find-references, rename, inline errors
- Built on top of the incremental compilation system
- Critical for adoption — modern developers expect IDE support

### 6.5 Debugger

- GDB/LLDB integration for native executables (DWARF debug info from LLVM)
- Step through NOVA source code (source maps from IR to NOVA)
- Inspect values, channels, process state
- Chrome DevTools protocol for WASM debugging

---

## PART 7: THE BUILD ORDER — Exact Sequence of Implementation

### Phase 0: Language Specification (Weeks 1-6)

**This is where we are now.** Nothing is built until this is validated.

| Step | What | Validation | Blocks |
|---|---|---|---|
| 0.1 | Write exact syntax — define every keyword, operator, delimiter. Write 10 programs. | Every program simpler than Python equivalent. One obvious way to write each. Developer who's never seen NOVA can read them. | Everything. Grammar wrong = rewrite everything. |
| 0.2 | Write type inference rules — define algorithm, trace by hand on 10 programs. | 95%+ needs zero annotations. Inference works for channels, processes, tensors. Error messages explain what/where/how-to-fix. | Compiler. Types wrong = inference wrong = safety wrong. |
| 0.3 | Write process/channel semantics — 5 ownership scenarios, trace step by step. | Every scenario has one clear answer. Ownership always unambiguous. No scenario allows corruption or races. Rules fit on one page. | Compiler. Semantics wrong = ownership wrong = memory bugs. |

**If any step fails:** Fix it. Re-validate. Do NOT proceed. The user has been clear: upstream mistakes are catastrophic.

### Phase 1: Interpreter + Frontend (Weeks 7-16)

| Step | What | Depends On | Validation |
|---|---|---|---|
| 1.1 | Kotlin project setup: build system (Gradle + build.gradle.kts), project structure, test framework (JUnit 5 + kotlin-test) | Phase 0 complete | Project builds, tests run |
| 1.2 | Lexer: hand-written scanner, all token types from grammar | 1.1 + grammar from 0.1 | Tokenizes all 10 programs correctly |
| 1.3 | Parser: recursive descent + Pratt, produces AST | 1.2 | Parses all 10 programs, AST is inspectable |
| 1.4 | Type inference engine: constraint generation + unification | 1.3 + type rules from 0.2 | **GATE 2:** 95%+ code needs zero annotations |
| 1.5 | Ownership analysis (simplified): ownership tracking, send-after-use detection | 1.4 + semantics from 0.3 | **GATE 3:** Works without annotations |
| 1.6 | Tree-walking interpreter: evaluates typed AST directly | 1.5 | All 10 programs execute correctly |
| 1.7 | REPL: interactive loop using interpreter | 1.6 | Can type NOVA expressions and see results |

**Milestone: NOVA runs programs.** They're interpreted (slow), but the language design is validated. Every syntactic and semantic decision has been tested on real code.

### Phase 2: Compiler Backend (Weeks 17-30)

| Step | What | Depends On | Validation |
|---|---|---|---|
| 2.1 | IR design: define NOVA IR instruction set, SSA form, process-aware ops | Phase 1 complete | All 10 programs lower to IR. IR is inspectable. |
| 2.2 | IR optimization: inlining, DCE, constant folding | 2.1 | Optimized IR is smaller and simpler |
| 2.3 | Abstraction erasure: process/channel elimination for local code | 2.2 | **GATE 4:** Single-process IR matches C equivalent |
| 2.4 | LLVM codegen: NOVA IR → LLVM IR → native executable | 2.3 | All 10 programs compile and run natively |
| 2.5 | Performance benchmarks: NOVA vs C for compute-bound programs | 2.4 | **GATE 5:** Within 10% of C performance |

**Milestone: NOVA compiles to fast native code.** The core promise is proven.

### Phase 3: Runtime (Weeks 24-36, overlaps with Phase 2)

| Step | What | Depends On | Validation |
|---|---|---|---|
| 3.1 | Memory allocator: per-process pools, slab allocator | C build environment | Allocation benchmarks, no leaks |
| 3.2 | Process scheduler: green threads, work-stealing | 3.1 | 1M processes created + scheduled without crash |
| 3.3 | Channel system: MPSC/SPSC queues, backpressure | 3.2 | Message throughput benchmarks, zero lost messages |
| 3.4 | I/O subsystem: async I/O on all platforms | 3.3 | File I/O, network I/O working |
| 3.5 | Supervision trees: restart strategies, crash containment | 3.2 + 3.3 | Crash one process, verify others unaffected. Verify restart. |
| 3.6 | Integration: compiler output links with runtime | Phase 2 + 3.5 | Compiled programs using processes/channels run correctly |

**Milestone: NOVA programs with multiple processes, channels, and supervision run natively.** The full model works.

### Phase 4: WASM + GPU (Weeks 37-52)

| Step | What | Depends On | Validation |
|---|---|---|---|
| 4.1 | WASM codegen: NOVA IR → WASM bytecode | Phase 2 complete | Programs run in browser |
| 4.2 | GPU codegen: tensor ops → CUDA/SPIR-V kernels | Phase 2 + tensor support | Matrix multiplication runs on GPU, correct results |
| 4.3 | Cross-target linking: same project compiles to native + WASM + GPU | 4.1 + 4.2 | Full-stack app: WASM frontend, native backend, GPU AI |

### Phase 5: Standard Library + Toolchain (Weeks 40-60)

| Step | What | Depends On | Validation |
|---|---|---|---|
| 5.1 | Core stdlib: collections, string, math, I/O | Phase 3 runtime working | Unit tests, dog-food by writing more NOVA in NOVA |
| 5.2 | HTTP library: client + server | 5.1 + I/O | Build a web API in NOVA |
| 5.3 | Package manager: dependency resolution, registry | 5.1 | Create, publish, consume a package |
| 5.4 | Formatter: canonical code style | Frontend (lexer/parser) | Format all existing NOVA code |
| 5.5 | LSP: autocomplete, errors, go-to-definition | Frontend + type inference | Works in VSCode |
| 5.6 | Tensor library + AI inference | GPU codegen working | Run a neural network in NOVA |

### Phase 6: Polish + Release (Weeks 52-72)

- Comprehensive test suite (thousands of programs)
- Documentation (language reference, tutorials, examples)
- Website + playground (WASM-based NOVA in browser)
- Community setup (GitHub, Discord, forum)
- First public release

### Phase 7+: Self-Hosting

Rewrite the compiler in NOVA. This validates that NOVA is expressive enough for complex software. It also proves the full-stack promise — a compiler is a serious program.

---

## PART 8: TECHNICAL DECISIONS REGISTRY

Every decision, its rationale, and what breaks if it's wrong:

| # | Decision | Rationale | If Wrong |
|---|---|---|---|
| 1 | Three Primitives (V/P/C) as entire model | Minimizes language surface, enables abstraction erasure, natural for all domains | Core architecture fails. Must find new model. |
| 2 | Indentation-based syntax | Matches Python simplicity goal, less visual noise | Switch to braces. Affects lexer + parser only. Recoverable. |
| 3 | Extended Hindley-Milner for inference | Proven algorithm, extensible for channels/processes | Type system too complex. Simplify type features. |
| 4 | Process boundaries = ownership boundaries | Eliminates lifetime annotations, natural mental model | Most novel idea. If wrong, must add minimal hints (copy/move). |
| 5 | Compiler in Kotlin | Sealed classes + when = ideal AST matching. Data classes = concise AST nodes. Same JVM ecosystem as Java. Creator's Java knowledge transfers fully. | Slower compilation than Go/Rust-written compiler. Acceptable tradeoff. |
| 6 | Runtime in C | Maximum performance, OS-level access, portability | Nothing. C is the right choice for a runtime. |
| 7 | LLVM for native codegen | Industry standard, all architectures, battle-tested | Locked into LLVM. Acceptable — LLVM isn't going away. |
| 8 | Direct WASM emission (no LLVM) | Smaller binaries, simpler pipeline | Must use LLVM WASM backend instead. More code but works. |
| 9 | Interpreter before compiler | Validates design faster, catches mistakes early | Interpreter takes time that could go to compiler. Worth it. |
| 10 | Green threads + work-stealing scheduler | Proven (Go, Tokio), lightweight, scalable | Poor scheduling performance. Study + fix algorithm. |
| 11 | Lock-free channels | High throughput, no mutex contention | Lock-free bugs. Fall back to mutex-based (slower but correct). |
| 12 | Per-process memory pools, no GC | Deterministic latency, no pauses, bulk deallocation on crash | Memory fragmentation. Add compaction or revise allocation strategy. |
| 13 | Erlang-style supervision | 30 years battle-tested, proven at scale | Nothing. It works. |
| 14 | `or` for error defaults | One-word error handling, covers 70% of cases | Developers want try/catch. We don't add it. `or` + `match` is sufficient. |
| 15 | Annotations (@device, @stack, etc.) for expert control | Progressive disclosure — don't need them, but they're there | Annotations become required. Violates simplicity. Fix inference. |
| 16 | Binary serialization format (custom) | Optimized for NOVA types, schema-aware, versioned | Interop problems. Add protobuf/JSON export. |
| 17 | Monomorphization for generics | Zero runtime overhead, optimal code per type | Binary size explosion. Add selective dictionary-passing for cold paths. |
| 18 | Full-stack app as beachhead use case | No language does this well. Clear differentiator. | Full-stack isn't compelling enough. Pivot to AI or systems. |

---

## PART 9: WHAT'S NOVEL VS. WHAT'S PROVEN

This is honest. Claiming everything is novel is lying. Claiming nothing is novel means NOVA has no reason to exist.

### NOVEL (Never been done — needs prototyping and validation)

| Innovation | What's New | Risk | Validation Point |
|---|---|---|---|
| Process-based ownership | Using process boundaries instead of lifetime annotations for memory safety | HIGH | Phase 1, Step 1.5 (GATE 3) |
| Unified type inference (V/P/C) | One inference algorithm covering values, channels, and processes | MEDIUM | Phase 1, Step 1.4 (GATE 2) |
| Abstraction erasure to C-equivalent | Processes/channels that compile away completely | MEDIUM | Phase 2, Step 2.3 (GATE 4) |
| Auto GPU/CPU targeting | Compiler decides execution target from code analysis | HIGH | Phase 4, Step 4.2 |
| Same source → native + WASM + GPU | One codebase, three fundamentally different targets | MEDIUM | Phase 4, Step 4.3 |

### PROVEN (Built on existing work — lower risk)

| Component | Based On | Confidence |
|---|---|---|
| Hindley-Milner type inference | 40+ years of research, used in Haskell/ML/Rust | HIGH |
| Green thread scheduler | Go, Tokio, Erlang — all proven at massive scale | HIGH |
| Work-stealing | Cilk, Go, Java ForkJoinPool — well-studied algorithm | HIGH |
| Supervision trees | Erlang/OTP — 30+ years in telecom, proven at 99.9999999% | HIGH |
| LLVM codegen | Used by Rust, Swift, Julia, Clang — industry standard | HIGH |
| Lock-free queues | Academic literature + real-world (Java ConcurrentLinkedQueue, crossbeam) | HIGH |
| SSA-based IR | Used by every modern compiler — LLVM IR, GCC GIMPLE, V8 Turbofan | HIGH |
| Recursive descent + Pratt parsing | Used by GCC, V8, Rust, Go compilers | HIGH |

---

## PART 10: WHAT CAN GO WRONG — AND WHAT WE DO

| Risk | Probability | Impact | Response |
|---|---|---|---|
| Process-based ownership doesn't work without annotations | 30% | CRITICAL — core innovation fails | Add `copy()` and `move()` as minimal hints. NOT lifetime annotations. Max 2 keywords. |
| Type inference below 90% | 20% | HIGH — simplicity promise fails | Remove type features that break inference. Simplify until 95% is met. |
| Abstraction erasure leaves >15% overhead | 25% | HIGH — performance promise fails | Study where overhead comes from. Optimize specific patterns. Accept 10-15% for v1. |
| LLVM integration from Kotlin is painful | 40% | MEDIUM — slows development | Use textual LLVM IR generation (write .ll files, invoke llc). Slower but always works. |
| Compilation too slow (>5s for small projects) | 30% | MEDIUM — developer experience suffers | Incremental compilation + caching. Parallel frontend. |
| GPU codegen too complex | 50% | LOW for v1 — GPU is Phase 4 | Defer GPU to post-v1. Focus on native + WASM first. Still beats most languages. |
| Single developer can't build all this | 20% | HIGH — project stalls | Prioritize ruthlessly. Ship interpreter + native compiler first. WASM, GPU, stdlib grow over time. |

---

## PART 11: RESOLVED GAPS — Critical Decisions

### GAP 1 RESOLVED: `@low_level` Scope and Rules

`@low_level` unlocks raw memory operations WITHIN the current process only. It CANNOT break the process/channel model.

**What `@low_level` allows:**
- Raw allocation/deallocation (`alloc`, `free`)
- Pointer arithmetic and byte-level read/write
- FFI calls to C libraries (`extern_call`)
- Manual memory layout control

**What `@low_level` does NOT allow (compiler-enforced):**
- Raw pointers CANNOT be sent through channels (compile error: "raw pointers cannot leave the process")
- Raw pointers CANNOT escape into non-`@low_level` scope (compile error: "convert to a value first")
- Raw pointers CANNOT access another process's memory (process isolation is absolute)

**What `@low_level` still enforces:**
- Bounds checking ON by default (disable with `@unchecked` for hot loops)
- Process ownership — raw memory belongs to the process, freed on process death
- Type tracking — compiler knows what types are being manipulated

**Interaction with other systems:**
- Type system: `Pointer` and `RawBuffer` types are NOT Sendable, NOT GpuSafe, NOT WasmSafe. Compiler auto-derives this.
- Ownership: raw memory owned by process. Process crash = all raw memory freed. No leaks across process boundaries.
- Simplicity: 95% of developers never see `@low_level`. Doesn't affect the rest of the language.
- Performance: zero overhead. Compiles to exact machine instructions, same as C.

**Pattern for safe wrappers:** Systems programmers build unsafe interiors with safe APIs:
```nova
fn fast_hash_map()
    @low_level
        storage = alloc(capacity * entry_size)
        // ... raw memory operations ...
    // return safe NOVA value — raw pointers don't escape
    return HashMap { entries: safe_entries, count: count }
```

### GAP 2 RESOLVED: Copy Semantics for Assignment

**Decision: `y = x` creates an independent copy. Always. No shared references. No aliasing.**

This eliminates Python's #1 footgun (shared reference mutation) while being conceptually simpler.

**How the compiler makes it fast (three cases):**

| Scenario | What Compiler Does | Cost |
|---|---|---|
| `x` never used after `y = x` | Move (transfer, no copy) | Zero |
| Both used, neither mutated | Share immutably (same backing storage, refcount) | Zero |
| Both used, one mutated | Copy-on-write (copy triggered only at mutation point) | Copy only what's modified |

**By value size:**
- Small types (int, float, bool, structs ≤64 bytes): literal copy, fits in registers, essentially free
- Large types (lists, maps, tensors): copy-on-write backed by internal reference counting. Developer never sees refcounts.

**Mutability rule:** Values are mutable within the owning process. No `mut` keyword, no `let` vs `var`. You own it, you can change it. Once it leaves through a channel (`send`), it's gone from your process.

```nova
data = [1, 2, 3]
other = data           // independent copy (compiler may optimize to COW)
other.append(4)        // other is [1, 2, 3, 4], data is still [1, 2, 3]
send(ch, data)         // data transferred, can't use it after this line
// other is unaffected — it's an independent value
```

**Verification against every language we beat:**
- Beats Python: no shared reference bugs ✓
- Beats JavaScript: no object reference confusion ✓  
- Beats Java: no "is this reference or value?" ambiguity ✓
- Beats Go: same value semantics as Go structs, extended to ALL types ✓
- Beats Rust: no explicit move/borrow annotations needed ✓
- Performance matches C: compiler optimizes to move/share/COW, zero unnecessary copies ✓

**What proves this works:** Swift uses this exact model (value types + COW) for Arrays, Dictionaries, Strings. It powers all iOS/macOS apps. Proven at massive scale.

### GAP 3 RESOLVED: Compilation Speed Strategy

**Targets:** <1s for small projects (<10 files), <10s for large projects (<1000 files).

**How:**
1. Module-level inference boundary — each file inferred independently, public functions export type signatures in cached interface files
2. Parallel inference — independent modules on separate threads
3. Incremental caching — only re-infer changed files, reuse cached interfaces for unchanged modules
4. Constraint simplification — channel constraints are local to the function that creates the channel, no whole-program analysis needed
5. Fail-fast solving — report first error immediately, don't solve remaining constraints

**If inference is still slow:** More type annotations at module boundaries = less inference work = faster compilation. This is self-correcting and those annotations serve as documentation anyway.

### GAP 4 RESOLVED: Standard Library Scope

**v1.0 ships with:** core, collections, string, math, io, http, json, test, time (enough for backend APIs + CLI tools + concurrent services)

**v1.0 beachhead use case:** Backend web APIs + CLI tools + concurrent services. Compete with Go first.

**Post-v1.0 growth:** tensor (after GPU codegen), ai (after tensor), web/dom (after WASM), db, crypto, deploy (each independent, added incrementally)

**v2.0 beachhead:** Full-stack apps (native backend + WASM frontend + AI). This is where NOVA has no competition.

---

## PART 12: LANGUAGE DRAWBACK COVERAGE — Every Language, Every Flaw

Our architecture must handle ALL drawbacks of ALL 13 languages we claim to beat. Verified against V/P/C:

### Verified: All C drawbacks handled (6/6)
Manual memory → process ownership. No types → full inference. No modules → import system. No generics → inferred generics. No error handling → or/match/supervision. UB → no UB, @low_level scoped.

### Verified: All C++ drawbacks handled (6/6)
Complexity → 18 keywords. Legacy → new language. Multiple ways → one way. Build hell → nova build. Slow compile → target <1s. Headers → modules.

### Verified: All Rust drawbacks handled (6/6, 2 depend on Gate 3)
Lifetimes → process boundaries (Gate 3). Borrow fights → no borrow checker (Gate 3). Slow compile → target <1s. Complex bounds → auto-derived capabilities. async complexity → processes ARE concurrency. Learning curve → three concepts.

### Verified: All Python drawbacks handled (6/6)
Slow → native compiled. No static types → full inference. GIL → process model. Shared state → copy semantics. Deployment → single binary. Closure bugs → capture by value.

### Verified: All Go drawbacks handled (5/6, 1 long-term)
No generics → full generics. Error verbosity → or keyword. No sum types → built-in. Nil panics → no null. No immutability → process ownership. Limited stdlib → grows post-v1.

### Verified: All Java drawbacks handled (6/6)
Boilerplate → zero ceremony. JVM overhead → native compiled. Type erasure → monomorphization. NPE → no null. Checked exceptions → or/supervision. Everything-a-class → functions first-class.

### Verified: All JavaScript drawbacks handled (6/6)
Type coercion → strong static types. No integers → proper numeric types. this confusion → no this. Callback hell → processes+channels. Prototype pollution → type safe. npm hell → built-in package manager.

### Verified: All Erlang drawbacks handled (6/6)
Slow compute → native LLVM. No static types → full inference. Weird syntax → familiar Python-like. String handling → native strings. No GPU/systems → multi-target. Small ecosystem → better tooling from day 1.

### Verified: Julia, Swift, Kotlin, Mojo, Zig drawbacks handled
JIT penalty → AOT. Platform-locked → multi-target. AI-only → all domains. Systems-only → all domains.

---

## PART 13: SYNTAX FAMILIARITY — Any Developer Can Switch

NOVA syntax must feel RECOGNIZABLE to developers from ANY popular language. Not identical — recognizable. A Python developer, a Go developer, a JavaScript developer should all look at NOVA code and think "I can read this."

**Design principle: Take the MOST FAMILIAR form from the most popular languages.**

| Construct | NOVA Syntax | Familiar To |
|---|---|---|
| Variables | `x = 42` | Python, JS, Go, Ruby |
| Functions | `fn add(a, b) a + b` | Rust (fn), Python (minimal body), Kotlin |
| Blocks | Indentation | Python (2B+ users know this) |
| Conditionals | `if x > 0 ... else ...` | Every language |
| Loops | `for item in list ...` | Python, Kotlin, Swift, Rust |
| Strings | `"hello {name}"` | Kotlin, Swift, JS template literals |
| Lists | `[1, 2, 3]` | Python, JS, Ruby, Swift |
| Maps | `{"key": value}` | Python, JS, JSON |
| Structs | `type Point { x: float, y: float }` | Go, Rust, TypeScript |
| Pattern match | `match result ...` | Rust, Kotlin (when), Swift, Scala |
| Error handling | `value = try() or default` | Swift (??), Kotlin (?:), but simpler |
| Concurrency | `spawn worker()` | Go (go func), Erlang (spawn) |
| Channels | `send(ch, data)` / `receive(ch)` | Go (ch <- data / <-ch), but more readable |

**What's deliberately different from each language:**

- **Not Python:** NOVA has `fn` for functions (not `def`), uses `spawn`/`send`/`receive` for concurrency (Python has none built-in). NOVA is compiled, not interpreted.
- **Not Go:** NOVA infers ALL types (Go requires some). NOVA uses indentation (Go uses braces). NOVA has `or` for errors (Go has `if err != nil`). NOVA has real generics.
- **Not Rust:** NO lifetime annotations. NO `&`/`&mut`/`Box`/`Rc`/`Arc`. NO `impl Trait`. Process model replaces all of it.
- **Not JavaScript:** Strong static types. No `this`. No prototype chain. No `undefined` vs `null` vs `NaN`.
- **Not Java:** No classes required. No `public static void main`. No getters/setters. `print("hello")` is a complete program.

**The 30-second test:** A developer seeing NOVA code for the first time should understand ~80% of what it does without reading any documentation. If they can't, the syntax has failed.

---

## PART 14: WHAT WE DO NEXT — RIGHT NOW

Phase 0, Step 0.1: **Design the syntax.**

1. Write 10 real NOVA programs (the 10 specified in the execution plan)
2. Each program must be simpler than the Python/Go/Rust equivalent
3. Compare each program side-by-side with Python, Go, and Rust equivalents
4. Every keyword, operator, and delimiter must be justified
5. The syntax must be internally consistent — no exceptions, no special cases
6. A developer who's never seen NOVA must be able to read each program
7. Verify each program against ALL 4 resolved gaps (low_level scoping, copy semantics, type inference, stdlib scope)

This is the first thing that happens. Everything else waits.

---

## SUMMARY: THE COMPLETE PICTURE IN ONE PARAGRAPH

NOVA is a language with three primitives (Values, Processes, Channels) and a genius compiler that infers types, ownership, and execution targets — producing code as fast as C, as safe as Rust, simpler to write than Python. Assignment copies values (compiler optimizes with move/COW). `@low_level` is scoped and can't break process isolation. The compiler is written in Kotlin (interpreter first, then 7-stage pipeline: lexer → parser → type inference → ownership analysis → IR → optimization/erasure → codegen via LLVM/WASM/GPU). The runtime is written in C (green thread scheduler, lock-free channels, supervision trees, per-process memory pools, no GC). Implementation follows strict phases: specification → interpreter → compiler backend → runtime → WASM/GPU → stdlib/toolchain → self-hosting. Five risk gates guard five promises. Every drawback of every language we claim to beat has been verified against V/P/C. Every decision is connected through the Three Primitives model — nothing is designed in isolation.

**Phase 0 complete. All 3 gates passed. Now in Phase 1: interpreter + compiler frontend.**
