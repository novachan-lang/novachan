# NOVA Core Innovations — What Makes NOVA Worth Existing

**Status:** 2026-06-02 · **Scope:** the *original* core-language features that are uniquely NOVA's.
Companion to `CORE_COMPLETENESS.md` (the problems every language solves, answered the NOVA way).

## The design law

NOVA is built on **three primitives** — **Values** (all data; owner-tracked; the compiler infers
type, layout, and capabilities), **Processes** (all execution; zero overhead when not distributed),
**Channels** (all communication; typed; ownership *moves* at the boundary) — plus a **genius compiler**
that sees the whole program as one unit.

1. **Never copy a feature.** Absorb the *problem* the feature solves and solve it the NOVA way.
2. **Unify.** One NOVA primitive should replace many features from many languages.
3. **Invent.** Add original features no language has — each justified by *how it helps the world*.
4. **Frameworks fall out for free.** The core is engineered so Forge/Mesh/Ops/Cortex/Pulse/Reactor/
   Prism/Edge/Sentinel become *thin and fast* — the language does the heavy lifting.

The throughline of every innovation below: **a Process's entire identity is a Sendable Value reachable
only through the Channels it was handed — so the whole-program compiler can prove protocols, place
processes, size buffers, fold config, choose layouts, pick targets, and erase everything unused.**

Tiers: **near** = buildable on today's foundation (escape analysis, channel runtime, const-fold) ·
**medium** = lands with the lightweight-process runtime · **research** = ambitious, with a concrete first step.

---

## A. Processes, Concurrency & Distribution

### A1. One Process for All Execution — the death of async coloring
- **Kills:** every language has *separate* APIs for threads, async/await, coroutines/generators, futures, actors, and GPU kernels — plus the "function color" tax where `async` infects every caller.
- **Mechanism:** a thread, an actor, a generator, a future, a GPU kernel, and a remote node are **all a Process**. The compiler picks the implementation (inline call → green process → OS thread → GPU dispatch → remote node) from how it's used. A future *is* a Channel you receive from.
- **Makes thin:** Forge (100k connections in blocking style), Mesh (workers = processes), Cortex/Pulse (parallel stages = processes), Reactor (systems = processes).
- **Impact:** one concept to learn for all concurrency on Earth; eliminates the async/sync schism that fractures Python/JS/Rust.
- **Tier:** medium

### A2. Session-Typed Channels — protocol-as-a-value
- **Kills:** a "typed channel" today checks each message's type but never the **order** — so HTTP (headers→body→response), WebSocket upgrades, auth→query, and 2-phase commit are hand-guarded with runtime state machines and "reply exactly once" bugs.
- **Mechanism:** a Channel's type is a **protocol state machine** (`Recv<Request> then Send<Response>`). The compiler tracks each endpoint's state through the IR; out-of-order use is a compile error in plain English. Because send is a move, protocol state travels with ownership and can't be duplicated or skipped. The two ends are proven mirror-images → client and server are *provably* compatible, with **zero runtime state bytes** (the machine erases).
- **Makes thin:** Forge (request lifecycle + WS, compile-checked), Mesh (RPC/consensus with no IDL), Ops (deploy handshakes can't half-apply).
- **Impact:** protocol bugs — a top cause of outages and security holes — become impossible to compile, with no IDL and no runtime cost.
- **Tier:** near

### A3. Location Transparency — the same Process runs local or remote, zero rewrite
- **Kills:** the local↔distributed discontinuity — a function call becomes gRPC + protobuf + stub + mesh + manifest; 95% plumbing, and the boundary is hard-coded so you can't relocate a component without a rewrite.
- **Mechanism:** placement is a property the compiler infers / the runtime resolves, not something the source encodes. `spawn worker()` is local; a placement hint changes only *where*. Capability inference decides transfer per channel: local → zero-copy pointer handoff (send-as-move makes it safe); cross-node → the compiler **generates serialization from the Value's structure** (types ARE the schema) over the length-framed transport. A non-Sendable Value sent remote is a compile error.
- **Makes thin:** Mesh (this *is* Mesh — `spawn`+`send` instead of stubs/manifests), Forge/Ops (scale-out = a placement change, not a rewrite).
- **Impact:** lets one developer build systems that today need a platform team + Kubernetes + a service mesh.
- **Tier:** medium

### A4. Typed Backpressure — flow control & autoscaling from the channel type
- **Kills:** backpressure and autoscaling are bolted on (reactive `request(n)` protocols, queue-depth dashboards, HPA YAML).
- **Mechanism:** a bounded Channel's fullness is a first-class scheduling signal — a full channel blocks the sender (native backpressure) and is the trigger the runtime uses to spawn/retire consumers.
- **Makes thin:** Forge (no overload collapse), Mesh/Pulse (pipelines self-balance), Ops (autoscaling falls out of the type, not a controller).
- **Impact:** the single hardest property of production systems — graceful behavior under overload — becomes a default.
- **Tier:** near

### A5. Supervision-as-Types — "let it crash," compiler-verified
- **Kills:** Erlang's reliability requires *remembering* to wire OTP supervisors; an unsupervised process silently leaks.
- **Mechanism:** supervision is a Process-graph property the compiler checks — an **unsupervised Process is a compile error**. Restart strategy is part of the spawn relationship.
- **Makes thin:** Mesh (supervision trees for free), Forge (a crashing handler can't take the server down), Ops (self-healing services).
- **Impact:** self-healing systems by default, not by discipline — Erlang's 99.9999% uptime as a language guarantee.
- **Tier:** medium

### A6. Verified Hot Reload — state migration the compiler proves
- **Kills:** live code upgrade is either impossible (most languages) or unsafe (you hope the old state fits the new code).
- **Mechanism:** at a Channel/checkpoint boundary the compiler proves the old Value layout maps to the new one (or generates the migration), then hot-swaps the Process.
- **Makes thin:** Mesh/Forge (zero-downtime deploys), Reactor/Prism (live-edit game/UI logic).
- **Impact:** update running systems without dropping a connection or losing state — safely.
- **Tier:** research

### A7. Deterministic Replay & Time-Travel
- **Kills:** concurrency heisenbugs — the hardest bugs in software — are non-reproducible.
- **Mechanism:** because *all* cross-process communication is typed Channels, the runtime can record the message order and **replay it deterministically**, stepping forward and backward through a distributed execution.
- **Makes thin:** Mesh (debug a cluster), Reactor (deterministic multiplayer/lockstep), every concurrent program.
- **Impact:** makes the previously-undebuggable debuggable.
- **Tier:** research

### A8. Channel-Graph Observability — traces/metrics/logs as one inferred model
- **Kills:** observability is three bolted-on subsystems (tracing, metrics, logging) wired by hand.
- **Mechanism:** the program *is* a graph of Processes and Channels; the compiler/runtime derive distributed traces, throughput metrics, and structured logs from that graph automatically, with the failed Channel protocol and Process role named in every crash report.
- **Makes thin:** Mesh/Forge/Ops (production observability with no instrumentation code).
- **Impact:** every NOVA system is observable by construction.
- **Tier:** medium

---

## B. Safety, Capabilities & Ownership

### B1. Capability Lattice Inference — no `Send`/`Sync`/`Copy`/`'static`, ever
- **Kills:** Rust makes you annotate `Send`/`Sync`; Haskell makes you track purity; C makes you pray.
- **Mechanism:** the compiler **derives** every capability (`Sendable`, `GpuSafe`, `WasmSafe`, `Pure`, `Deterministic`) from the code itself, as a lattice fact propagated through the IR. You never write them; you only see them at a Channel boundary if something is wrong.
- **Makes thin:** *everything* — it's what makes A1/A3/E1 safe automatically.
- **Impact:** Rust-grade safety with Python-grade ceremony (none).
- **Tier:** near

### B2. Channel-Boundary Ownership — a borrow checker without borrows, no GC
- **Kills:** the trilemma — manual memory (C: unsafe), GC (Java/Go: pauses), or a borrow checker (Rust: hard).
- **Mechanism:** the **move happens exactly at `send`**; a single-owner Value needs no refcount (Track 8 already elides it); escape analysis stack-allocates the rest. No `&'a mut`, no lifetimes, no GC.
- **Makes thin:** every framework gets C-class memory behavior for free; Reactor/Edge get no-GC determinism.
- **Impact:** the safety Rust fights for and the ease Go promises, in one mechanism with no pauses.
- **Tier:** near

### B3. Authority Values — unforgeable capability tokens, no ambient authority
- **Kills:** ambient authority — any code can open a file, hit the network, read env. The root of most security holes.
- **Mechanism:** the right to touch a resource is an **unforgeable Value** a Process must be *handed* (via a Channel). No handle → can't do it, enforced by ownership. Authority *attenuates* at the channel boundary (you can pass a weaker capability than you hold).
- **Makes thin:** Sentinel (least-privilege by construction), Ops (a deploy process can only touch what it was given), Forge (handlers sandboxed).
- **Impact:** capability security — proven safer for 40 years, never mainstream because no language made it free. NOVA does.
- **Tier:** medium

### B4. `Secret<T>` — a poison dimension flow analysis refuses to leak
- **Kills:** keys/passwords/PII leaking into logs, error messages, swap, or crash dumps.
- **Mechanism:** `Secret<T>` is a Value dimension the compiler tracks; it **cannot be printed, logged, serialized, or copied** into a non-secret sink (compile error), and it **auto-zeroizes** on the owned static-drop path.
- **Makes thin:** Sentinel (secrets correct-by-construction), Forge (session tokens can't leak).
- **Impact:** an entire class of breaches (secret-in-logs) becomes unrepresentable.
- **Tier:** near

### B5. Constant-Time Processes — timing-leak-free codegen
- **Kills:** crypto comparisons/branches that leak secrets through timing.
- **Mechanism:** a Process marked constant-time gets codegen with no secret-dependent branches/memory access; the compiler rejects code it can't make constant-time.
- **Makes thin:** Sentinel (side-channel-resistant crypto by default).
- **Impact:** timing-attack resistance without hand-written assembly.
- **Tier:** medium

### B6. Sandbox Processes — untrusted code isolated by an empty Channel set
- **Kills:** running plugins/user code safely requires VMs, containers, or WASM sandboxes bolted on.
- **Mechanism:** a Process spawned with **no outbound Channels and no Authority Values** literally cannot affect anything but its return Channel — isolation is the *default*, not an add-on.
- **Makes thin:** Sentinel, Ops (run third-party policy safely), Forge (untrusted handlers).
- **Impact:** safe plugin/extension execution with zero infrastructure.
- **Tier:** medium

### B7. Integrity/Trust Dimension — anti-injection by type
- **Kills:** SQL/command/XSS injection — attacker-controlled data treated as trusted.
- **Mechanism:** Values from the outside carry a **tainted** dimension; using a tainted Value where a trusted one is required (SQL string, shell command, HTML) is a compile error until it passes a typed sanitizer.
- **Makes thin:** Forge (injection-proof routing/DB), Sentinel.
- **Impact:** the OWASP top-3 vulnerability class becomes a compile error.
- **Tier:** near

### B8. Provenance-Tracked Slices — zero-UB systems memory
- **Kills:** buffer overruns, use-after-free, dangling pointers — without a borrow checker's ceremony.
- **Mechanism:** a slice/span carries compiler-tracked provenance (which allocation, what bounds, what lifetime via ownership); out-of-bounds and dangling uses are proven absent or guarded.
- **Makes thin:** Edge (safe MMIO/DMA), Cortex/Pulse (zero-copy buffers).
- **Impact:** C's performance with none of C's UB.
- **Tier:** medium

### B9. Capability-Scoped FFI — the unsafe boundary is contained, not global
- **Kills:** FFI/`unsafe` as a global escape hatch that poisons safety reasoning everywhere.
- **Mechanism:** `unsafe`/FFI is a **tracked capability** confined to a Process; a crash-prone native call can be auto-isolated in its own Process (NIF speed, Port safety).
- **Makes thin:** every framework that wraps a C lib (Sentinel/crypto, Cortex/BLAS, Pulse/Arrow).
- **Impact:** use the C ecosystem without surrendering memory safety.
- **Tier:** medium

---

## C. Compile-time & Metaprogramming

### C1. Comptime IS the Language — one metaprogramming substrate
- **Kills:** the zoo — C macros, C++ templates + constexpr, Rust macros, Java annotations + reflection, Lisp macros — each a separate, often-untyped sub-language with its own debugger story (or none).
- **Mechanism:** compile-time code is **ordinary, typed, debuggable NOVA** that runs at build time over typed AST/Values. It replaces macros, templates, functors, constexpr, and typeclass resolution with *one* thing.
- **Makes thin:** all frameworks (their "magic" is plain comptime NOVA, not reflection or codegen tools).
- **Impact:** metaprogramming without macro-hell or reflection bloat — and it dead-strips when unused.
- **Tier:** medium

### C2. Comptime Folding — routes/SQL/config/wire-formats validated and folded into the binary
- **Kills:** framework "magic" that costs runtime (route tables built at startup, ORM query building, config parsing, reflection-based serialization).
- **Mechanism:** because comptime can evaluate Values, embedded DSLs (routes, SQL, format strings, config schemas) are **checked at compile time and folded into the binary** — invalid SQL or a bad route is a compile error; the framework layer erases to nothing.
- **Makes thin:** Forge (compile-time-validated routes + SQL, zero-overhead), Ops (config = a compiled type-checker, not a YAML interpreter).
- **Impact:** whole classes of runtime errors become compile errors, and "framework overhead" disappears.
- **Tier:** near

### C3. Refinement-Typed Values — types that DELETE runtime checks
- **Kills:** redundant runtime validation (`if x >= 0 && x < len`) and the bugs when you forget it.
- **Mechanism:** the pragmatic 90% of dependent types (Liquid/F\*-style), **inferred** — the compiler proves a Value's refinement (`NonEmpty`, `0..len`, `Validated`) and *removes* the check, or rejects the program.
- **Makes thin:** Cortex/Pulse (bounds checks elided in hot loops), Forge (validated request data).
- **Impact:** faster *and* safer than dynamic checking — the proof replaces the branch.
- **Tier:** research

### C4. Inferred Dispatch + Specialization-on-Demand
- **Kills:** the generics tax — Java erases & boxes, C++ bloats with monomorphization, Go had none for a decade.
- **Mechanism:** type params are inferred from call sites; the compiler chooses **monomorphize-vs-dictionary per instantiation** to avoid bloat, with zero annotations and zero default dispatch cost.
- **Makes thin:** all frameworks (generic containers/algorithms with no ceremony or bloat).
- **Impact:** Haskell's power, Go's simplicity, C++'s speed — without their costs.
- **Tier:** near

---

## D. The Unified Value Model

### D1. Structural Value Identity — one layout IS wire / GPU / DB-row / FFI
- **Kills:** the glue-code industry — ORMs, serialization libraries, protobuf schemas, FFI marshalling — all bridging the same data across representations.
- **Mechanism:** a Value's structure *is* its layout; the compiler **derives** the wire codec, the GPU buffer layout, the DB row mapping, and the C-ABI layout from that one structure. No schema files, no `derive(Serialize)`.
- **Makes thin:** Cortex (model weights ↔ GPU), Pulse (rows ↔ columnar ↔ disk), Mesh (Value ↔ wire), Forge (request ↔ JSON ↔ DB).
- **Impact:** the impedance-mismatch tax that every app pays simply disappears.
- **Tier:** near

### D2. Compiler-Owned Physical Layout — AoS ↔ SoA ↔ packed ↔ columnar
- **Kills:** hand-optimizing memory layout for cache/SIMD (the ECS "archetype" problem, the dataframe columnar rewrite).
- **Mechanism:** for process-owned collections the compiler **chooses the physical layout** from observed access patterns — array-of-structs for random access, struct-of-arrays/columnar for scans, packed for the wire.
- **Makes thin:** Reactor (cache-optimal ECS for free), Pulse (columnar SIMD scans), Cortex (tensor packing).
- **Impact:** data-oriented-design performance without data-oriented-design labor.
- **Tier:** medium

### D3. Shape-Refined Tensors — dimensions in the type
- **Kills:** runtime shape errors (the `matmul` dimension-mismatch crash 3 hours into training).
- **Mechanism:** tensor/array dimensions live in the type; a shape mismatch is a **compile error**; index-notation/einsum is a first-class Value expression the compiler lowers optimally.
- **Makes thin:** Cortex (correct-by-construction nets), Pulse (typed columns).
- **Impact:** the most expensive class of ML bugs caught before the GPU spins up.
- **Tier:** medium

### D4. Allocation-Strategy Inference — GC vs RC vs arena vs malloc as one inferred fact
- **Kills:** the language-defining memory tradeoff (GC ease vs manual control) forced on you globally.
- **Mechanism:** one IR fact per allocation — the compiler picks stack / arena / refcount / manual from escape + ownership analysis. Optional `Allocator`-as-a-Value for explicit control (Zig transparency), inferred by default (Python ergonomics).
- **Makes thin:** Edge/Reactor (no-alloc hot paths proven), all frameworks (right strategy per allocation).
- **Impact:** no global GC-vs-manual decision — every allocation gets the optimal strategy.
- **Tier:** near

### D5. Time as Typed Values
- **Kills:** the `gmtime` static-buffer hazard, subtracting wall-clock across an NTP adjustment, duration-unit confusion.
- **Mechanism:** `Instant` (monotonic) and `DateTime` (wall) are **distinct types** you can't mix; durations are inferred Values; a `Deadline` schedules a Process.
- **Makes thin:** Mesh/Forge (timeouts/deadlines), Reactor (frame/tick clocks), Edge (real-time).
- **Impact:** an entire category of time bugs becomes a type error. (Also fills the 0% Time/Date gap.)
- **Tier:** near

### D6. Relational / Datalog Values — declarative query built-in
- **Kills:** reaching for SQL/an ORM/a graph DB for in-memory relational data.
- **Mechanism:** a relation is a Value shape with a built-in declarative query (logic programming's useful core, none of Prolog's nondeterministic failure modes).
- **Makes thin:** Pulse (joins/aggregations), Mesh (service registry queries), Ops (policy as queries).
- **Impact:** query power without an embedded database.
- **Tier:** research

### D7. Reactive Dataflow Values — state-change = message, zero diffing
- **Kills:** virtual-DOM diffing (React) and manual observer wiring — the cost of keeping UI/derived state in sync.
- **Mechanism:** a derived Value is a compile-time dataflow graph; a state change is a typed message on a Channel that recomputes only the dependents — no diffing, no re-render tax.
- **Makes thin:** Prism (GUI with no virtual-DOM), Reactor (reactive game state), Pulse (incremental views).
- **Impact:** reactive UIs and live data faster than Flutter/React, by construction.
- **Tier:** medium

---

## E. Performance & Targets (CPU / SIMD / GPU / WASM / embedded)

### E1. Write-Once Kernel / Device-Retargeted Regions
- **Kills:** rewriting the same logic for CPU, SIMD intrinsics, CUDA/Metal, a WASM build, a shader, and an interrupt handler.
- **Mechanism:** a pure `Value → Value` region is **retargeted by the compiler** to scalar / SIMD / GPU / WASM / firmware from *one source*; a cost model picks the target per call site from shape + device. Shaders, compute kernels, and ISRs are ordinary NOVA functions.
- **Makes thin:** Cortex (kernels on any device), Reactor (shaders in NOVA), Pulse (GPU aggregations), Edge (ISRs).
- **Impact:** true write-once-run-anywhere *including* the GPU, the browser, and the microcontroller.
- **Tier:** research (CPU/SIMD near; GPU/firmware ambitious)

### E2. Differentiation as a Compiler Pass — `grad` is a pass, not a library
- **Kills:** autograd machinery (tapes, `requires_grad`, graph capture) and its overhead.
- **Mechanism:** automatic differentiation is an **IR transform** over a pure Value→Value function — the compiler emits the gradient function directly.
- **Makes thin:** Cortex (training falls out — this is what lets Cortex beat PyTorch).
- **Impact:** training as a language capability, not a framework; differentiable programming everywhere.
- **Tier:** research

### E3. Cross-Process Deforestation — fused, allocation-free, parallel pipelines
- **Kills:** intermediate allocations in `map/filter/reduce` chains and the manual work of parallelizing them.
- **Mechanism:** chained Sequence operations **fuse into one pass** (deforestation) with no intermediate collections, and fan across Processes/Channels automatically when pure.
- **Makes thin:** Pulse (dataframe ops), Cortex (data pipelines), Mesh (map-reduce).
- **Impact:** Polars/Spark-class pipeline performance from ordinary `xs.map(...).filter(...)`.
- **Tier:** medium

### E4. Stream-as-Channel-of-Chunks — larger-than-memory = same code
- **Kills:** the rewrite when data outgrows RAM (batch → streaming) and the batch/stream API split.
- **Mechanism:** a stream is a Channel of chunks; the *same* code processes an in-memory list, a file bigger than RAM, or a live socket — the compiler/runtime handle chunking and backpressure.
- **Makes thin:** Pulse (unified batch+streaming), Forge (streaming responses/uploads), Cortex (data loaders).
- **Impact:** the batch-vs-streaming dichotomy that splits the data world disappears.
- **Tier:** near

### E5. Effect-Typed Realtime / No-std Regions + Freestanding lowering
- **Kills:** "you can't use this language for real-time or bare-metal" — GC pauses, hidden allocations, a mandatory runtime.
- **Mechanism:** a `realtime` / `no_alloc` / `nostd` capability the compiler **verifies** (no allocation, bounded time); single-Process NOVA already erases its runtime, so the *same language* lowers to freestanding firmware.
- **Makes thin:** Edge (microcontrollers from NOVA), Reactor (frame-budget-safe regions).
- **Impact:** one language from datacenter to 64KB MCU — the unification claim made real at the bottom of the stack.
- **Tier:** research

### E6. Typed Binary Patterns — zero-copy parsing
- **Kills:** hand-written byte-fiddling parsers (network packets, file formats) and their overflow CVEs.
- **Mechanism:** Erlang-style bit-syntax — match a request/packet **directly from bytes** into typed Values, compiled to branch-free state machines with bounds proven absent. Zero copy.
- **Makes thin:** Forge (HTTP parsing), Mesh (wire decode), Edge (protocol frames), Pulse (binary formats).
- **Impact:** C-speed parsing with no buffer-overflow class.
- **Tier:** near

### E7. Progressive Lowering + Per-Target Autotuning
- **Kills:** "portable but slow" or "fast but locked to one machine."
- **Mechanism:** MLIR-style lowering through dialects, with the compiler autotuning per target (tile sizes, vector widths) — one source, best-in-class codegen on each machine.
- **Makes thin:** Cortex/Pulse (peak numeric perf per device), all frameworks (peak portable perf).
- **Impact:** one codebase that is *fastest* on every machine it runs on, not just portable.
- **Tier:** research

---

## F. Developer Experience

### F1. The Explaining Compiler — decision provenance you can query
- **Kills:** the opacity — *why* did it allocate here, infer this type, pick this target, reject this program?
- **Mechanism:** the compiler records its decisions as a queryable graph and explains them in plain language (already seeded in rustc-class diagnostics with "did you mean?"). Ask "why is this on the heap?" and get an answer + a fix.
- **Makes thin:** every developer; flattens the learning curve so NOVA's power is approachable.
- **Impact:** a compiler that *teaches* — the difference between a language experts use and a language everyone uses.
- **Tier:** near

### F2. Drift-as-a-Channel — declarative infra without a controller framework
- **Kills:** Terraform/Kubernetes controllers — thousands of lines reconciling desired vs actual state.
- **Mechanism:** desired-state and observed-state are two Values; the *difference* flows on a Channel, and a Process reconciles it — declarative infra as a few lines, not a control-plane framework.
- **Makes thin:** Ops (this *is* Ops — drift detection + reconcile, compiled, not a YAML engine).
- **Impact:** infrastructure-as-code as actual typed code, with drift handled by the language.
- **Tier:** medium

---

## Framework Enablement Matrix

`●` = load-bearing (the framework is *thin because of this*) · `·` = helps.

| Innovation | Forge | Mesh | Ops | Cortex | Pulse | Reactor | Prism | Edge | Sentinel |
|---|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|
| A1 One Process for All Execution | ● | ● | · | ● | ● | ● | · | · | · |
| A2 Session-Typed Channels | ● | ● | ● | · | · | · | · | ● | ● |
| A3 Location Transparency | · | ● | ● | · | ● | · | · | · | · |
| A4 Typed Backpressure | ● | ● | ● | · | ● | · | · | · | · |
| A5 Supervision-as-Types | ● | ● | ● | · | · | · | · | · | · |
| A8 Channel-Graph Observability | ● | ● | ● | · | · | · | · | · | · |
| B1 Capability Inference | ● | ● | · | ● | ● | ● | ● | ● | ● |
| B2 Channel-Boundary Ownership | ● | ● | · | ● | ● | ● | ● | ● | ● |
| B3 Authority Values | · | · | ● | · | · | · | · | ● | ● |
| B4 Secret<T> | ● | · | ● | · | · | · | · | · | ● |
| B7 Integrity/Trust Dimension | ● | · | · | · | · | · | · | · | ● |
| C1 Comptime IS the Language | ● | ● | ● | ● | ● | ● | ● | ● | ● |
| C2 Comptime Folding | ● | · | ● | · | ● | · | · | · | · |
| D1 Structural Value Identity | ● | ● | · | ● | ● | · | · | ● | · |
| D2 Compiler-Owned Layout | · | · | · | ● | ● | ● | · | ● | · |
| D3 Shape-Refined Tensors | · | · | · | ● | ● | · | · | · | · |
| D7 Reactive Dataflow Values | · | · | · | · | · | ● | ● | · | · |
| E1 Write-Once Kernel/Device | · | · | · | ● | ● | ● | ● | ● | · |
| E2 Differentiation Pass | · | · | · | ● | · | · | · | · | · |
| E5 Realtime/No-std Regions | · | · | · | · | · | ● | · | ● | · |
| E6 Typed Binary Patterns | ● | ● | · | · | ● | · | · | ● | ● |
| F2 Drift-as-a-Channel | · | · | ● | · | · | · | · | · | · |

**Reading it:** every framework rests on **B1/B2 (capability inference + channel-ownership)** and **C1 (comptime)** — those three are the universal foundation. Then each framework has its own load-bearing few: Forge = A2+A4+C2+B7; Mesh = A3+A5+A8; Cortex = D3+E1+E2; Reactor = D2+D7+E5; Edge = E5+B8+E6; Sentinel = B3+B4+B5.

---

## Tiered build order

**Near (buildable on today's foundation — do alongside Wave 0 of CORE_COMPLETENESS):**
B1 Capability inference · B2 Channel-boundary ownership (extend Track 8) · A2 Session-typed channels ·
A4 Typed backpressure · C2 Comptime folding · C4 Inferred dispatch · D1 Structural Value identity ·
D4 Allocation-strategy inference · D5 Time as typed Values · B4 Secret<T> · B7 Integrity/trust ·
E4 Stream-as-channel · E6 Typed binary patterns · F1 Explaining compiler.

**Medium (land with the lightweight-process runtime — Wave 1):**
A1 One Process for All Execution · A3 Location transparency · A5 Supervision-as-types ·
A8 Channel-graph observability · B3 Authority Values · B5 Constant-time Processes · B6 Sandbox Processes ·
B8 Provenance slices · B9 Capability-scoped FFI · C1 Comptime-is-the-language · D2 Compiler-owned layout ·
D3 Shape-refined tensors · D7 Reactive dataflow · E3 Cross-process deforestation · F2 Drift-as-a-channel.

**Research (ambitious — concrete first step exists, schedule after the core is complete):**
A6 Verified hot reload · A7 Deterministic replay · C3 Refinement types · D6 Relational Values ·
E1 Write-once kernel (GPU/firmware) · E2 Differentiation pass · E5 Realtime/no-std/freestanding ·
E7 Progressive lowering + autotuning.

---

## Appendix — CS-history lessons (what to adopt the NOVA way, what to avoid)

| Idea (source) | Why it did / didn't change the world | NOVA's lesson |
|---|---|---|
| Lisp macros / homoiconicity | Immense power; stayed niche — untyped, hard to tool, parens barrier | **Adopt the power, not the form:** C1 comptime is typed + debuggable, not a separate macro language |
| Smalltalk live image | Inspiring; died on reproducibility + deployment ("image" ≠ source) | **Adopt liveness, keep source-of-truth:** A6 hot reload is reproducible-from-source |
| Erlang processes + supervision + hot reload | Won telecom (9 nines); niche elsewhere — slow sequential, odd syntax, no types | **The crown jewels:** A1/A5/A6 — but typed, fast, and with a familiar surface |
| Haskell purity + laziness + typeclasses + effects | Changed *thinking*; niche in industry — laziness space-leaks, steep curve | **Adopt inference + effects, drop laziness:** B1 capability/effect inference, eager by default |
| ML/OCaml inference + modules | Inference went everywhere; the language stayed academic | **Adopt HM inference** (done) as the default, not an option |
| Rust ownership / borrow checker | Proved safety-without-GC is possible; adoption gated by difficulty | **Keep the guarantee, drop the ceremony:** B2 ownership only at channel boundaries, inferred |
| Go goroutines + GC | Won cloud services on simplicity; GC pauses + weak generics ceiling it | **Adopt the simplicity, beat the ceiling:** A1 + C4 generics + no-GC ownership |
| Zig comptime + no hidden allocation | Rising; comptime is the standout idea | **Adopt both:** C1 comptime + D4 allocation transparency (inferred by default) |
| Pony reference capabilities | Brilliant; near-zero adoption — annotation burden too high | **Adopt caps, infer them:** B1 lattice inference makes Pony's safety free |
| Algebraic effects (Koka/OCaml 5) | The async/coloring cure; still emerging | **Adopt inferred effects:** A1 — one mechanism for async/generators/cancellation/DI |
| Dependent types (Idris/Lean) | Maximal safety; too heavy for general use | **Adopt the pragmatic 90%:** C3 inferred refinement types that erase checks |
| APL / array languages / kdb | Unmatched data-parallel density; alien syntax | **Adopt rank-polymorphism, readable syntax:** D3 + E1 |
| Mojo (Python + MLIR + autotune) | The current "fast Python for AI" bet | **Adopt MLIR lowering + autotune:** E7 — but on NOVA's unified model, not Python's |
| Prolog / Datalog | Logic programming's reasoning power; failure modes scared people | **Adopt Datalog's useful core:** D6 relational Values, no nondeterministic backtracking |

**The white space NOVA claims:** no language unifies *capability-inferred safety* + *one-process-for-all-execution* + *comptime-is-the-language* + *one-value-model-across-domains* on a single substrate. That intersection — not any single feature — is NOVA.
