# NOVA — MASTER PLAN (Consolidated) · 2026-07-10

> **This is THE single source of truth** for NOVA's multi-month build to *"do everything C/C++/Java/Python/
> Go/Erlang/Elixir/Rust can do, and do it BETTER — the NOVA way, so developers CHOOSE NOVA."* It consolidates
> four code-verified workstreams into one file (nothing scattered):
>
> - **PART I — Strategy, Competitive Positioning & Roadmap** — the master plan: NOVA vs all 9 languages + a
>   scorecard; every feature stated as *NOVA-way design → the drawback it avoids → effort → what it unlocks*;
>   the 7-phase dependency-aware roadmap.
> - **PART II — Framework Foundation Readiness** — the *"once we write we can't go back"* analysis: the
>   framework × core-requirement matrix for all 9 frameworks, and the **LOCK-NOW foundational decisions** that
>   must be designed into the core BEFORE the frameworks that depend on them.
> - **PART III — Verified Gap Backlog** — ~45 code-verified (file:line) bug/soundness/leak gaps + a
>   stale-claims appendix (generics/traits/LSP/REPL/exhaustive-match were falsely "missing").
> - **PART IV — Feature Completeness Inventory** — exhaustive sweep of all 238 md+memory files: what NOVA HAS
>   (559 Forge modules) vs LACKS (60 feature gaps). Line count is the wrong metric; breadth is the real gap.
>
> ## The verdict in five lines
> 1. NOVA already **leads or ties** on every *language-design* dimension (concurrency, safety, error handling,
>    whole-program HM inference, automatic zero-annotation reflection, fault tolerance, AOT perf, deploy).
> 2. NOVA **loses** only on *buildable capability + ecosystem time* — and that loss column IS the roadmap.
> 3. The **architecture EXTENDS cleanly**: the Three Primitives (Values/Processes/Channels), the process/channel
>    model, RC/arena memory, and HM inference are **safe as-is** for all 9 frameworks — this is not a redesign.
> 4. The real risk is a **bounded set of 12 LOCK-NOW decisions** that must be *designed into the core before*
>    their dependent frameworks begin (retrofitting them = the catastrophic "go back").
> 5. **Foundation first, always:** don't build breadth on a cracked foundation; every feature must avoid the
>    drawback that made it painful elsewhere — else we've built C++.
>
> ## THE LOCK-NOW foundational decisions (ordered by blast radius — the heart of "can't go back")
> | # | Decision | Frameworks | Why it can't be retrofitted |
> |---|---|---|---|
> | LOCK-1 | **Module symbol namespacing (`@mod__fn`)** | **9/9** | bare `@name` symbols collide across packages → ABI break if changed later. Do FIRST. |
> | LOCK-2 | **Annotation → compile-time codegen hook (L1/L2)** | 8/9 | the imperative→declarative migration breaks every user if the hook shape changes. |
> | LOCK-3 | **Trait-conformance signature type-check** | 7/9 | a live soundness hole gating every trait-based API. |
> | LOCK-4 | **Sized/unsigned numerics + f32/f16 (NType width/signed + ABI + elem_kind)** | 6/9 | the widest representation change — **the #1 risk**; touches type system, ABI, arrays. |
> | LOCK-5 | **Safepoint preemption + `kill`** | 6/9 | Mesh supervision & Reactor frame-budget are fiction without it; scheduler-deep. |
> | LOCK-6 | **`@cdecl` FFI callbacks** | 5/9 | Prism-desktop / Edge / Reactor are dead without it (also Forge-ALPN). |
> | LOCK-7 | **Constant-time `@ct` + `secure_zero` + `@redact` (`Secret<T>`)** | Sentinel + Forge | Forge's LIVE crypto is already `-O2`-vulnerable; can't be bolted onto crypto after the fact. |
> | LOCK-8/9 | **IR pointer address-space + GPU-buffer-as-Value + autodiff adjoint-rule table** | Cortex/Reactor | the GPU + training substrate; design-lock now, implement later. |
> | LOCK-10/11/12 | **Const generics · struct-by-value FFI · Mesh wire-protocol + NodeRef** | Cortex/Reactor/Prism/Mesh | shape-checked tensors, native GUI/physics FFI, distribution identity. |
>
> **Core-ready vs blocked (post Phase-0 hardening):** READY = **Forge** (its locks harden paths it already
> has) and **Ops** (only shares LOCK-1). BLOCKED on their locks = **Cortex** (heaviest: L4+L5+L8+L9+L10),
> **Reactor** (nearly every lock), **Edge** (L6+L4+freestanding+ARM+MCU), **Prism** (L6+L11+L4+WASM),
> **Mesh** (L5+L12), **Sentinel** (L7+L4), **Pulse** (lightest — viable soonest after L4/sized numerics).
>
> *Sources folded in below verbatim; see PART II for the full per-framework matrix + NOVA-way designs.*

---
---

# ═══════════════════════ PART I — STRATEGY, COMPETITIVE POSITIONING & ROADMAP ═══════════════════════

---

# NOVA — THE GRAND MASTER PLAN (2026-07-10)

> **What this is.** The single authoritative north-star for NOVA's multi-month build to "everything,
> better." It answers the owner's vision directly: *NOVA must do EVERYTHING C/C++/Java/Python/Go/Erlang/
> Elixir/Rust/Swift/Zig can do, and do it BETTER — so developers CHOOSE NOVA, and everything is done THE
> NOVA WAY.* It is self-contained: competitive positioning, honest current state, the full feature plan
> (each feature with its NOVA-way design + the drawback it avoids + effort + what it unlocks), the
> soundness last-mile that goes first, and a dependency-aware sequenced roadmap.
>
> **Sources folded in (read in full):** the six competitive analyses (C/C++, Java/C#/Kotlin, Python, Go,
> Erlang/Elixir, Rust/Swift/Zig), the four NOVA-way design docs (language ceilings, stdlib/OS,
> domain/presentation, tooling), and the two verified 2026-07-10 audits
> ([`REMAINING_GAPS_AUDIT_2026_07_10.md`](REMAINING_GAPS_AUDIT_2026_07_10.md),
> [`FEATURE_COMPLETENESS_AND_ROADMAP_2026_07_10.md`](FEATURE_COMPLETENESS_AND_ROADMAP_2026_07_10.md)).
>
> **The one governing rule (repeat it before every feature):** *Do not build breadth on a cracked
> foundation. Soundness first, then correctness-edge stdlib, then ecosystem sharing, then the declarative
> multiplier, then presentation, then domain frameworks, then numeric-at-scale. And every single feature
> must avoid the drawback that made it painful everywhere else — otherwise we have built C++.*

---

## 1. Vision & the honest bar

**The thesis.** ONE developer, ONE language, builds ANYTHING, runs ANYWHERE — and never has to leave.
Systems, backend, frontend, AI, distributed, embedded, cloud: all expressed in the same three primitives
(Values, Processes, Channels) over a genius compiler that infers types, ownership, allocation, and target.
The developer writes code simpler than Python; the compiler hands back a binary as fast as C, as safe as
Rust, as concurrent as Go, and as fault-tolerant as Erlang.

**This is not aspiration — the core already exists.** NOVA self-hosts to a *byte-identical fixpoint*
(gen5.ll == gen6.ll); the compiler is ~22k lines of NOVA compiling itself. The runtime is ~21k lines of
real C: RC (no GC), a green-task M:N scheduler, a netpoller, pure-NOVA TLS 1.3, atomics, mmap. Scalar
performance is at or near C on the measured benchmarks. Forge (the web framework) has 3 live wire-protocol
DB drivers, a universal ORM, OTP supervision, and ~570 KAT-gated algorithm modules. This is a real
language, not a manifesto.

**The honest scale framing — line count is the WRONG metric.** The instinct "22k lines vs the JDK's 200k+,
so we're 10% done" measures the wrong thing, in two directions at once:

1. **Fewer lines is partly by design and is the point.** HM inference (zero annotations for ~95% of code),
   automatic zero-annotation reflection (no `@derive`), and implicit async (no `Future<T>` machinery) mean
   a NOVA program expressing the same capability is *legitimately* shorter than its Java/Rust equivalent.
   Comparing raw line counts penalizes exactly what NOVA is built to win on.
2. **The real gap is BREADTH, and it is real.** The JDK's 200k lines are not ceremony — they are a correct
   IANA/DST timezone engine, `BigDecimal`, locale collation, an image codec, an XML parser, a GUI toolkit,
   plus 25 years of ecosystem. That *breadth* — "someone already wrote the correct edge case" — is where
   NOVA is genuinely thin, and no compiler cleverness substitutes for it.

So the bar is not "write more code." The bar is: **close the last soundness gaps, then acquire breadth the
NOVA way (each feature leveraging the compiler, each avoiding its historical drawback), in the sequence that
keeps the foundation trustworthy the whole way up.**

**The non-negotiables (every feature is checked against ALL of these, not some):** Fast (C-class), Effective
(minimal code), Robust (self-healing), Secure (safe by default), Platform-independent, and Simpler than
Python. If any addition narrows NOVA to "just another systems language" or "just another AI framework," or
if it wins on breadth but loses on simplicity, it has failed the vision.

---

## 2. Competitive positioning — how NOVA wins THE NOVA WAY

The pattern across every language family is the same: **NOVA already wins on language design (it flows from
the Three Primitives + HM inference); NOVA loses on ecosystem maturity and a bounded set of buildable
capabilities.** The wins are structural and permanent. The losses are a work list — and every one has a
concrete NOVA-way closure path that *avoids the drawback* that made the incumbent's version painful.

### 2.1 C / C++ — the systems incumbent

**What they win.** Raw scalar throughput with zero hidden cost; total manual memory control; sized/unsigned
numeric types that map 1:1 to hardware; SIMD intrinsics; C++ templates/constexpr; RAII; the embedded
monopoly; and the 50-year FFI/legacy moat.

**NOVA today.** Ties C on tight integer loops (0.87–1.07× via the same LLVM `-O2` backend) and struct-local
SROA math (~1.05×). Wins outright on memory safety (process isolation, no borrow-checker ceremony),
concurrency (no data races by construction), error handling (Result, no exceptions), developer experience
(10× less code), and compile speed vs C++ (no templates, no headers). Loses on float-array vectorization
(1.2–2.2×, boxed for `any`-soundness), cross-function struct ABI (10–20% gap, S5 gated OFF), sized/unsigned
numerics (i64-only), SIMD intrinsics, templates/comptime, bare-metal/embedded, and C-callback FFI.

**Verdict & the NOVA way to win.** NOVA does NOT match C++ feature-for-feature — that path is the complexity
explosion NOVA exists to escape. Instead: (a) sized types as *value refinements* inside HM inference (`let
x: u32 = 42` still infers, still auto-promotes, but rejects lossy narrowing that C silently truncates); (b)
a sound `floatlist ⟹ kind==2` invariant so float arrays become bare `double*` that LLVM auto-vectorizes —
recovering C's speed *with* bounds-safety; (c) comptime-is-the-language (typed, debuggable NOVA at build
time) replacing templates without the 100-line error cascades; (d) `--freestanding` capability-gating so the
compiler *refuses* to emit `malloc`/`socket` for a bare-metal target. **The two widest levers here: sized
numerics (unblocks embedded, wire codecs, crypto, GPU) and comptime (unblocks metaprogramming) close ~80% of
the C/C++ gap while keeping NOVA simpler than Python.**

### 2.2 Java / C# / Kotlin — the enterprise triad

**What they win.** A colossal battle-tested stdlib (IANA timezones, `BigDecimal`, Collator); annotation-
driven declarative frameworks (Spring/ASP.NET/Ktor); JIT+mature-GC effortless throughput; the generics +
reflection + annotations metaprogramming stack; best-in-class IDE tooling; and the 25-year Maven/NuGet moat.

**NOVA today.** Wins structurally on type inference (HM vs local-`var`), implicit async (no coloring), AOT
performance (no JIT warmup, C-class from the first request), binary size (1–5 MB vs 200 MB+ JVM), zero-GC
deterministic latency, automatic zero-annotation reflection, error handling (Result vs abandoned checked
exceptions), and null safety. Loses on stdlib correctness-edge, declarative frameworks (blocked on
annotations), DI, IDE depth, ecosystem breadth, RC leak-freedom, and maturity/hiring.

**Verdict & the NOVA way to win.** The #1 enterprise gap is the *declarative surface* — Spring's
`@GetMapping` vs Forge's imperative `route(m, "/users", h)`. NOVA closes it with **user-extensible
annotations + COMPILE-TIME processing** (not runtime reflection): the compiler reads `@Route`, generates the
wiring at compile time, and erases the annotation — zero runtime cost, zero classpath scan, zero proxy
magic, and invalid annotations are compile errors, not the silent `@Transactional`-only-works-on-public-
methods failures Java developers memorize. This is C#'s source-generator model made a first-class language
feature. Combined with the correctness-edge stdlib (`BigDecimal` with operator overloading, not
`a.add(b.multiply(c))`; zoned datetime; regex captures) and RC completeness (so "no GC pauses" is not
undercut by "but it leaks"), NOVA becomes a *better language* than the triad — the remaining gap is time and
community, which the registry + docs + installer bootstrap.

### 2.3 Python — the productivity/AI incumbent

**What they win.** "It just works" productivity; the data/ML/scientific ecosystem (NumPy/pandas/PyTorch —
a network-effect moat); REPL/notebook culture; dynamic flexibility; batteries-included glue.

**NOVA today.** Ties on zero-annotation brevity (HM = duck typing but *safe*) and read-like-English syntax.
Wins decisively on execution speed (50–100× for CPU-bound, no two-language problem), type safety (sound
static types, no 3am `TypeError`), concurrency (no GIL, no `asyncio` coloring), error handling, memory
safety, and automatic serialization. Loses on startup/scripting feel (AOT has a compile step), the REPL
(recompiles per line today), the data/ML ecosystem, training (forward-only tensors), and the package
ecosystem.

**Verdict & the NOVA way to win.** The transition pitch is *"code that looks like Python, runs like C, and
catches your bugs before production."* The blockers are the *try* step (a competitive REPL — the `eval_expr`
interpreter already exists, it just isn't wired) and the *stay* step (regex captures, `BigDecimal`,
timezones — the papercuts that make a developer leave). The differentiators that make Python developers
*advocate*: a typed compiled dataframe (Pulse: pandas API, Polars speed, same language — no FFI to extend),
and **autodiff as a compiler pass** (`grad(loss)` is an IR transform, not a runtime tape — the first
language where training is a language primitive). Never mock Python's speed, never claim ecosystem parity,
never sacrifice simplicity for speed — the compiler must infer column types and vectorize *silently*.

### 2.4 Go — the cloud-native incumbent

**What they win.** Goroutines+channels (15 years of hardening); radical simplicity (25 keywords); sub-second
compiles; single static binary; the k8s/devops ecosystem; gofmt/pprof/testing built in.

**NOVA today.** Wins on channel safety (typed vs untyped `interface{}`), error handling (`try`/`?` vs `if
err != nil`), type system (HM + generics + sum types + exhaustive match), fault tolerance (OTP vs *nothing*
— a panicking goroutine kills the process), concurrency safety (process isolation vs shared-memory + race
detector), raw performance (LLVM `-O2` vs Go's SSA backend), and memory predictability (RC/arena, no GC
tuning). Loses on compile speed (LLVM pipeline is inherently slower), cloud SDK breadth, profiler (pprof is
best-in-class; NOVA has nothing), package system (link collisions + unwired resolver), docs, and testing
ergonomics. Ties on the single-binary deploy story.

**Verdict & the NOVA way to win.** Go wins on tooling *depth*, not language *design*. Close the five
buildable gaps and NOVA's structural advantages take over: (1) safepoint preemption + per-carrier I/O
(beat the goroutine runtime — Go solved preemption in 1.14; NOVA has no GC to complicate it); (2)
signal-handling-as-channel + cancellation tokens (Go's `context.Context` is opaque `interface{}` threaded
through every signature — NOVA's token propagates through the process tree automatically); (3) module-symbol
namespacing + wired resolver (skip Go's decade of GOPATH chaos — the resolver is *already built*); (4) a
sampling profiler on the DWARF already emitted (structurally richer than pprof: not just "where is CPU time"
but "which channel is the bottleneck"); (5) `nova doc` from the compiler's own AST + inferred types (docs
that are useful with *zero* comments, because inference derived the signatures Go makes you write).

### 2.5 Erlang / Elixir (BEAM) — the fault-tolerance gold standard

**What they win.** Lightweight processes at civilization scale (1–2M/node, ~300 bytes each); preemptive
scheduling (a CPU loop cannot starve the node); OTP supervision trees; hot code reload; transparent
distribution; per-process GC (no global pauses); soft-realtime; Phoenix/LiveView.

**NOVA today.** Wins decisively on sequential performance (10–50× faster per-core; no NIF escape hatch that
breaks isolation), static type safety + exhaustive match (vs BEAM's dynamic `CaseClauseError`), arena/RC
memory (no GC at all — arena death is O(1) like BEAM, but long-lived values are deterministic RC), and typed
channels (protocol bugs are compile errors). Loses on preemption (cooperative-only — the single most
important gap), production distribution (p2p primitive, not a mesh; unauthenticated), millions-of-processes
density (tested at 10k, 32KB fiber stacks), hot reload, and LiveView.

**Verdict & the NOVA way to win.** NOVA's three primitives *are* the BEAM model — but typed, native-compiled,
and compiler-verified instead of runtime-convention. The critical path: (1) **safepoint-based preemption** —
the compiler inserts a yield-check (one predicted branch) at loop back-edges; the runtime sets a flag on a
timer; `kill(process)` sets a doomed flag checked at the next safepoint. This is precise where BEAM's
reduction-counting is imprecise (a single BIF can blow the budget), and LLVM hoists the check out of tight
loops so C-parity survives. (2) Production distribution with TLS + per-node identity from day one (BEAM's
cookie auth is network-adjacent RCE). (3) Lazy 4KB fiber stacks (Go model) to hit 1M processes in ~4GB.
(4) LiveView-equivalent on the existing WebSocket + statics/dynamics diff core — but hybrid: the *same*
`view_fn` runs server-side (SEO/fast-paint) AND client-side in WASM (instant interaction), which the BEAM
structurally cannot do. Plus **supervision-as-types**: an unsupervised `spawn` is a compile diagnostic —
something Erlang cannot check.

### 2.6 Rust / Swift / Zig — the modern safety+systems bar

**What they win.** Rust: ownership/borrow-checker (formally proven), fearless concurrency via `Send`/`Sync`,
zero-cost abstractions, Cargo/crates.io, proc-macros. Swift: value semantics + COW, protocol-oriented
generics with associated types, ARC, modern macros. Zig: comptime-is-the-language, no hidden allocations,
best-in-class C interop, fast compiles.

**NOVA today.** Ahead of all three on developer experience (zero annotations, automatic reflection, no async
coloring), fault tolerance (OTP — none of the three have it), and automatic structural serialization (a
genuine innovation — Rust needs 4–5 derives, Swift 3–4 conformances, Zig nothing). At parity on the memory-
safety *guarantee* (process isolation + RC ≈ Rust, better than Swift/Zig) and error handling. Behind on
compile-time metaprogramming (behind all three), package ecosystem (behind Rust heavily), sized numerics
(behind all three), the type-system ceiling (variance/associated-types/const-generics — behind Rust/Swift),
multi-target production reach (ARM/macOS/WASM not production-verified), and immutability enforcement.

**Verdict & the NOVA way to win.** The governing thesis: NOVA's edge is NOT "more features" — it is "the
same safety and performance with radically less friction." So every addition must *preserve* that: adding
comptime must not add C++'s template hell (typed quasi-quote, fuel-bounded, same-language); adding sized
numerics must not add C's implicit-promotion CVEs (implicit widening, explicit checked narrowing); adding
associated types must not add Rust's 6-year GAT complexity (infer from implementations); adding variance
must not add Java's PECS wildcards (infer declaration-site, surface only in errors); adding a cycle collector
must not reject valid graph structures the way Rust's ownership does (opt-in trial-deletion, transparent).
Close the RC leaks (Rust has zero by construction) and NOVA matches the safety guarantee with none of the
lifetime ceremony.

### 2.7 Master scorecard

Rows = capability dimensions; cells = **who leads today**. "NOVA" = NOVA already leads or ties-at-the-top.
Grounded in the six competitive analyses and the two audits; honest where NOVA loses.

| Capability dimension | C/C++ | Java/C# | Python | Go | Erlang | Rust/Swift/Zig | **NOVA** | Leader today |
|---|:---:|:---:|:---:|:---:|:---:|:---:|:---:|---|
| Scalar/int throughput | ★ | | | | | ★ | ★ | **TIE (C = NOVA = Rust)** |
| Float-array / SIMD | ★ | | (NumPy) | | | ★ | ~ | C/Rust (NOVA 1.2–2.2×) |
| Cross-fn struct ABI | ★ | | | | | ★ | ~ | C/Rust (S5 gated OFF) |
| Memory safety (no GC) | | | | | | ★ | ★ | **TIE (Rust = NOVA); NOVA wins ergonomics** |
| Memory: no leaks | | ★(GC) | ★(GC) | ★(GC) | ★(GC) | ★ | ~ | Others (RC leaks open) |
| Sized/unsigned numerics | ★ | ★ | | ★ | | ★ | ✗ | Everyone but NOVA |
| Concurrency model | | | | ★ | ★ | | ★ | **NOVA (implicit async + typed chan + OTP)** |
| Concurrency safety | | | | | ★ | ★ | ★ | **NOVA/Rust/Erlang (isolation vs races)** |
| Preemption / soft-realtime | | ★ | | ★ | ★ | | ✗ | BEAM/Go (NOVA cooperative) |
| Fault tolerance / supervision | | | | | ★ | | ★ | **TIE (NOVA = Erlang API; needs kill)** |
| Error handling | | | | | | ★ | ★ | **NOVA/Rust (Result/`?`)** |
| Type inference depth | | | (dynamic) | | | | ★ | **NOVA (whole-program HM)** |
| Type-system ceiling (variance/assoc/const) | ★(C++) | ★ | | | | ★ | ✗ | Rust/Swift |
| Compile-time metaprogramming | ★(C++) | ★ | | | | ★ | ✗ | Zig/Rust/Swift |
| Automatic reflection/serialization | | | | | | | ★ | **NOVA (zero-annotation, an innovation)** |
| Peak perf / no warmup | ★ | | | ★ | | ★ | ★ | **NOVA/C/Rust (AOT, no JIT warmup)** |
| Binary size / deploy | ★ | | | ★ | | ★ | ★ | **NOVA/Go/C (1–5MB static)** |
| Compile speed | ★(C) | | | ★ | | | ~ | Go/C (NOVA 3–5× slower) |
| Declarative frameworks | | ★ | ★ | | ★(Phoenix) | ★ | ✗ | Java/Rails (blocked on annotations) |
| Stdlib correctness-edge | ★ | ★ | ★ | ★ | | ★ | ✗ | Everyone (no tz/decimal/regex-caps) |
| Presentation layer (GUI/web) | ★(Qt) | ★ | ★ | | ★(LiveView) | ★ | ✗ | Everyone (frontend hole) |
| AI / training | | | ★ | | | | ✗ | Python (forward-only tensors) |
| Data / dataframe | | | ★ | | | ★ | ✗ | Python/Rust (Pulse is seed) |
| Package ecosystem | ★ | ★ | ★ | ★ | ★ | ★ | ✗ | Everyone (no registry) |
| IDE / tooling depth | ★ | ★ | ★ | ★ | | ★ | ~ | Java/Rust (LSP is regex-scan) |
| Profiler | ★ | ★ | ★ | ★ | | ★ | ✗ | Go (pprof) |
| Embedded / bare-metal | ★ | | | | ★ | ★(Rust/Zig) | ✗ | C |
| Platform reach | ★ | ★(JVM) | ★ | ★ | | ★ | ~ | Rust/Python (Win+Linux x86_64 today) |
| Maturity / ecosystem / hiring | ★ | ★ | ★ | ★ | ★ | ★ | ✗ | Everyone (time gap) |

**Net read.** NOVA already *leads or ties at the top* on the dimensions that are language-design questions:
concurrency model, concurrency safety, error handling, type-inference depth, automatic reflection, memory-
safety ergonomics, fault tolerance, AOT performance, and deploy. It *loses* on exactly the dimensions that
are buildable-capability or ecosystem-time questions: sized numerics, metaprogramming, the type-system
ceiling, stdlib correctness-edge, presentation, AI/data, package ecosystem, tooling depth, embedded, and
maturity. **The strategy writes itself: the wins are permanent; the roadmap is the loss column, in
dependency order, each item closed the NOVA way.**

---

## 3. Where NOVA stands today — honest inventory

### 3.1 What is genuinely strong (verified at source level, not aspiration)

- **A trustworthy, rare foundation.** Self-hosts to a byte-identical fixpoint. The Tier-0 UB/UAF class is
  genuinely closed and hard-asserted (incl. the 0.8 struct-field-leak, CLOSED 2026-07-10). The type checker
  is **sound by default** (strict is the default; it no longer fails open). ASAN-clean.
- **Language core deeper than the mainstream.** Whole-program HM inference (zero annotations ~95% —
  deeper than Java/Kotlin/C#/Swift, which all annotate signatures); generics with *enforced* trait bounds
  (erased, no monomorphization bloat); traits with default methods + dynamic dispatch + conformance; full
  sum-type enums with rich `match` (ranges, or-patterns, guards, **exhaustiveness**); `Result`/`Option` +
  one-word `try`/`?`; default/named/variadic params; operator overloading; UFCS; string interpolation;
  **implicit async** (no coloring — beats Rust/C#/Kotlin); Option null-safety; **automatic zero-annotation
  structural reflection** (compiler-derived print/eq/to_json/from_json/RTTI — a genuine differentiator).
- **Performance at/near C on the common cases.** Tight int loops 0.87–1.07×C; struct SROA default-on
  ~1.05×C; built-in float reductions at parity; the #1 float-array cliff (S4.2 escape-versioning) is
  **shipped and default-on** (160×C → ~1.2–2.2×C). LLVM `-O2` backend, no JIT warmup, no GC pauses.
- **A surprisingly broad stdlib + Forge.** ~250 runtime builtins (full collections + specialized containers
  + lazy iterators + transcendental math + PCRE-subset regex + JSON/typed-serde + buffered I/O + mmap +
  subprocess + TCP/UDP/DNS/WebSocket/TLS). **559 Forge modules:** HTTP/1.1+WS+h2c+gRPC(unary), 3 live
  raw-TCP DB drivers (PG/MySQL/SQLite), a universal ORM, pure-NOVA crypto + TLS 1.3, JWT/CSRF/RBAC, AWS
  SigV4/S3/DynamoDB, Prometheus metrics, and ~570 KAT-gated algorithm/DS modules (most of the CS canon).
- **Real concurrency + fault tolerance.** Green tasks on an M:N scheduler (N=1 production; N>1 correctness-
  gated at 4/8 carriers, N=1 byte-identical); typed channels + `select`; `pmap`/`pfilter`/`pfor`; OTP
  supervisors with per-child restart policies + windowed intensity + one_for_all/rest_for_one; panic
  containment verified.
- **A genuinely strong build toolchain.** One `nova` CLI: build/run (`-O0/-O2`, incremental, LTO,
  cross-compile), `fmt` (AST-reprint), lint/check/cov/bench/test/eval/repl/lsp/debug(DWARF)/wasm/pkg, a
  shipping VS Code extension.

**Honest position:** *the core is production-trustworthy for Windows/Linux x86_64 single-node Forge apps.*
The gaps are the frontier (ARM/browser/GPU/distribution/multi-core throughput) and the last-mile
fidelity/leak items — **not architecture flaws.** 17 dogfooded showcase apps validate clean.

### 3.2 The verified soundness / bug / leak backlog (the foundation that goes FIRST)

From [`REMAINING_GAPS_AUDIT_2026_07_10.md`](REMAINING_GAPS_AUDIT_2026_07_10.md) — the single code-verified,
file:line-grounded backlog. These are NOT stale ledger claims; every one has evidence. The top items:

| # | Gap | Area | Sev | Effort | Status |
|---|---|---|---|---|---|
| 1 | **Float-return reads an UNINIT float slot → silent garbage (0.11)** | Runtime/Perf/Type | High | XL | The one remaining silent-wrong-answer bug. `sqrt(variance)`→3e-156. Layout-dependent Heisenbug; same class as geo_bearing/atan2. |
| 2 | No ARM/aarch64 fiber context switch — concurrency compiled OUT on ARM | Platform | High | L | `nova_asm_switch` has no aarch64 branch and no `#else`. `spawn`/generators silently no-op on ARM. |
| 3 | N>1 I/O throughput regresses (0.76–0.82× single-core) | Concurrency | High | L | Single global `nova_io_waiters` under `g_sched_lock`; per-carrier sharding absent. More cores = slower I/O. |
| 4 | HTTP/2 & gRPC over TLS impossible — ALPN missing | Forge-core | High | L | `grep -i alpn` = 0. h2/gRPC exist only as cleartext h2c. No browser HTTP/2. |
| 5 | Windows TLS *server* is a hard stub | Forge-core | High | L | `nova_rt_tls_listen/accept` return 0. TLS server only on Linux/macOS. The dev is on Windows. |
| 6 | gRPC-from-types (`service` marquee) not built | Forge-core | High | XL | Depends on interfaces + `chan T` returns. gRPC today = manual string-path register. |
| 7 | `orm_exec` returns wrong affected-row count for PG/MySQL | Forge-lib | High | M | PG/MySQL branches `return ok(0)`; no CommandComplete/OK-packet parse. |
| 8 | base32/TOTP + PG DataRow + Redis RESP NUL-truncate on 0x00 | Forge-lib+Runtime | High | M | ~7.5% of random secrets give a wrong OTP; BYTEA/binary DB values corrupt. |
| 9 | LSP hover/completion is a regex text-scan, not the inferer | Toolchain | High | L | Hover shows `x : variable`, not `x : int`. The inferer already runs for diagnostics; wiring job. |
| 10 | Package manager: no transitive solver/semver/lockfile in the CLI path | Toolchain | High | L | A full resolver EXISTS in `nova_pkg.nova` but is UNWIRED. |
| 11 | No preemption (cooperative-only); CPU-bound task starves; OTP can't kill | Concurrency | High | XL | Blocks soft-realtime + true Erlang-parity supervision (zombies survive restart). |
| 12 | Closure captures leak on closure death (memory-SAFE) | Runtime/RC | Med | M | `make_closure` stores captures raw + marks source ESCAPED; header-only free. |
| 13 | Trait conformance checks name+arity only, NOT param/return types | Type-system | Med (soundness) | M | `Shape{area()->float}` satisfied by `area()->string` → mistyped through dynamic dispatch. |
| 14 | User-enum match-arm payload degrades to `any` (float reads raw bits) | Type-system | Med (soundness) | M | The Result/Option fix, still open for user enums. |
| 15 | RC cycles leak forever (no cycle collector, memory-SAFE) | Runtime/RC | Med | XL | `Node{nxt=self}` never reclaimed. Slow RAM leak, not a crash. |

Runner-ups: **string `==` ignores the shipped NFC/NFD normalizers** (auth-bypass-adjacent), **Linux
FD_SETSIZE unguarded at fd≥1024** (CVE-class on high-concurrency Linux), **native by-value struct ABI gated
OFF**, and **remote_spawn is p2p-only, unauthenticated, non-TLS**.

**Do NOT re-chase ghosts.** The audit appendix confirms CLOSED/stale: 0.8/0.9/0.10/0.12 + Tier-0 UB/UAF;
generics + traits + exhaustive ADTs all EXIST; the type checker is sound-by-default; S4.2 float arrays are
default-on; SROA is default-on. The old "8×/120×/281×C" and "no generics/no traits" claims are stale.

---

## 4. What we will ADD — the NOVA way (the heart of the plan)

Every feature below is stated as: **the NOVA-way design → THE DRAWBACK AVOIDED → effort → what it unlocks.**
Grouped by area. Effort: S/M/L/XL. This section is the consolidated feature plan from the four NOVA-way
design docs, folded against the audit backlog. It is the work list; §6 sequences it.

### 4.A Language ceilings (compiler/language features) — the abstraction + systems layer

**L11 — Module-symbol namespacing (`@mod__fn` mangling).** [lang] **M.**
*NOVA way:* deterministic `@<mod>__<fn>` mangling for module-scoped symbols; root module + `extern fn` stay
bare. The developer writes `forge_pg.connect(...)`; the compiler resolves via the existing `ir_module_of`
map. Debug info emits the short name. 4 compiler edit sites + runtime fn-table registration + reconverge.
*Drawback avoided:* C's 40-year prefix gymnastics (`sqlite3_open`); C++'s unreadable mangling
(`_ZN5boost...`); Rust's opaque hash-mangling that needs `#[no_mangle]` for FFI. NOVA's is deterministic,
debug-friendly, invisible to the developer.
*Unlocks:* a real package ecosystem where independently-authored packages coexist without name collisions.
**This is a hard link-error wall today and a prerequisite for L1 and the registry — do it early.**

**L1 — User-extensible annotations + compile-time codegen.** [lang] **XL** (Phase-1 built-in hooks = L,
delivers 80%).
*NOVA way:* annotations are compile-time-only typed metadata on Values (structs/fns/fields/params). A codegen
hook is an ordinary NOVA function that runs *inside the compiler at IR-gen time over typed AST nodes* and
emits IR — not a separate crate, not a token stream, not runtime reflection. `@route("GET","/users")` is read
by the compiler, generates the dispatch wiring, and erases the annotation. User-defined annotations (Phase 2)
declare a type + a `codegen` handler using typed quasi-quotation (`quote { ... $(...) }`, MetaOCaml/Template-
Haskell-style, hygienic). Sandboxed (no I/O authority), fuel-bounded (`ce_budget_ok`).
*Drawback avoided:* Java's runtime-reflection cost + classpath magic + `@Transactional`-only-on-public
silent failures; Rust proc-macros' separate crate + untyped token surgery + opaque errors + non-reproducible
I/O; C++ templates' 100-line error cascades + compile explosion; C# source generators' separate-assembly +
stale-file fragility. NOVA's hooks are same-unit, typed, zero-runtime-cost, and their output is visible via
`--emit-ir`.
*Unlocks:* **THE multiplier.** Declarative Forge (`@route`/`@service`/`@middleware`), declarative ORM
(`@Entity`/`@Column`), declarative testing (`@test`/`@property`), compile-time DI (Dagger model), validation.
The Spring/ASP.NET/Rails experience in NOVA with zero runtime cost — turns all 8 sibling frameworks
declarative.

**L2 — Hygienic macros / general comptime.** [lang] **XL** (Phase-1 comptime-fn-returning-values = M).
*NOVA way:* comptime IS the language — a `comptime fn` is a regular NOVA function the compiler evaluates at
build time (all of NOVA except I/O/randomness/time, enforced by the authority-value model). Typed
quasi-quotation with `$()` splices; hygiene by default; fuel-bounded; incremental-safe (cached by input
hash). L1 annotation handlers ARE comptime functions.
*Drawback avoided:* C macros' unhygienic text substitution; C++ templates' error-message hell + compile
explosion; Rust `macro_rules!`' separate mini-language + no type info + recursion-limit errors; Zig comptime's
no-runtime-fallback + no-heap + no-quasiquote; Swift macros' 800k-line SwiftSyntax dependency + 5-macro-kind
complexity.
*Unlocks:* user-authored codegen, compile-time-checked DSLs (SQL/regex/format strings), conditional
compilation without a preprocessor, and erasing the compiler's own ~700 hand-built `Expr(`/`Stmt(` sites.

**L7 — Sized/unsigned numerics + f32.** [lang] **M.**
*NOVA way:* `let x = 42` stays i64 (zero ceremony for 95%); sized types via suffix literals (`255u8`,
`1.5f32`) or annotation. Internal `Int(width, signed)` + `Float(32/64)` participate in HM inference.
Implicit widening (`u8 + u32 → u32`), explicit *checked* narrowing (`u32(x)` panics on overflow; `u32!(x)`
wraps). Overflow is defined (checked by default in both debug and release — no Rust behavior-split). Arrays
of sized types store as flat buffers (8× smaller, and the vectorizable path).
*Drawback avoided:* C's implicit integer promotion (a CVE factory — `unsigned - unsigned` underflow); Rust's
`as`-cast-everywhere (itself unsound — `as` truncates silently); Go's no-implicit-conversion verbosity;
Python's per-op bignum overhead + no unsigned.
*Unlocks:* embedded/Edge (register-width types), wire codecs (binary pack/unpack), crypto (unsigned modular
arithmetic — fixes the `1<<64` UB), GPU/graphics (`f32`), memory efficiency, and const generics (`[T; N]`
needs `N: usize`). **The second-widest C/C++/systems lever after comptime.**

**L6 — Enforced immutability (`let` vs `let mut`).** [lang] **M.**
*NOVA way:* `let` is immutable by default; `let mut` opts into reassignment. Shallow (rebinding protection —
`push(x, 4)` still works, matching Kotlin/Swift and keeping the simpler-than-Python bar). No mut-coloring
cascade (NOVA functions take values, not references). Inference-assisted gradual migration: existing code
compiles with *warnings*, not errors.
*Drawback avoided:* Rust's `mut`-coloring cascade (`&mut self` propagates through every caller) + `RefCell`
runtime escape; Kotlin/Swift's shallow-only confusion presented without the compiler reasoning; Java's
verbose late `final` that doesn't help thread safety.
*Unlocks:* accidental-mutation bugs caught at compile time; better alias analysis (SROA/dead-store); immutable
= trivially Sendable for concurrency reasoning; prep for the capability lattice and const generics.

**L3 — Variance (inferred, surfaced only in errors).** [lang] **L.**
*NOVA way:* the compiler infers per-type-parameter variance (return position = out, param = in, mutable field
= both) — the developer writes nothing. Surfaced only in error messages, which *explain why*
(`"Box<T> is invariant because T appears in both read and write positions..."`).
*Drawback avoided:* Java's PECS wildcard confusion (`? extends ? super T` is legal) + use-site repetition;
Kotlin/C#'s opaque declaration-site errors; Rust's invisible-until-a-lifetime-error variance + PhantomData tax.
*Unlocks:* generic collections that compose with subtype hierarchies; trait-object containers; removes a class
of `any`-holes in Forge. Prerequisite for associated types (L4).

**L5 — Const generics.** [lang] **L** (needs L7 + L2-Phase-1).
*NOVA way:* `const N: int` type parameters inferred from context (`matmul(a, b)` infers M/N/K from the
argument types); dictionary-dispatch by default, monomorphize only when it proves a benefit (loop-unroll,
SIMD width). Const arithmetic (`Array<T, N+1>`) via L2 comptime. Errors cite dimensions
(`"a has shape [1,768] but b has [512,768]..."`).
*Drawback avoided:* Rust's 4-year stabilization + still-unstable `generic_const_exprs` + monomorphization
bloat; C++ NTTP template hell.
*Unlocks:* shape-checked tensors (Cortex), stack-allocated fixed buffers (Edge/systems), type-safe packet
headers, the `[T; N]` every systems language needs.

**L8 — Custom index/iterator/call operators.** [lang] **M.**
*NOVA way:* three structural conventions the compiler recognizes with zero-cost desugaring — `fn index(self,
i, j)`/`index_set` → `m[i, j]`; `fn iter(self)` + `fn next(self) -> Option<T>` → `for x in myType`; `fn
call(self, ...)` → `mw(request)`. Multi-argument indexing (unlike C++/Rust single-arg). No trait-impl
ceremony (structural, like `print`).
*Drawback avoided:* Python's untyped `__getitem__` (returns `Any`) + per-access dispatch cost; Rust's
`Fn`/`FnMut`/`FnOnce` triple + `Index`-returns-reference borrow tie + 75-method `Iterator`; C++'s
`operator[]`-by-reference aliasing + iterator-invalidation UB.
*Unlocks:* first-class custom containers (matrices, tensors, sparse collections), lazy iteration over user
types, callable objects (middleware). Prerequisite for Cortex/Pulse ergonomics.

**L4 — Associated types.** [lang] **XL** (after L3 + L1).
*NOVA way:* `trait Iterator { type Item }` where the compiler *infers* `type Item = int` from a `fn next ->
Option<int>` impl — a syntactic shorthand over a hidden type parameter, not a parallel system.
*Drawback avoided:* Rust GATs (6-year stabilization, verbose `where T: Iterator<Item=X>`, no HKT); Haskell
type-family non-injectivity + overlapping instances.
*Unlocks:* generic algorithms over abstract collection/iterator types; one `Serialize` trait for all formats.
The abstraction ceiling for library authors.

**L9 — Automatic numeric tower (auto-bignum + decimal literals).** [lang] **L** (after L7).
*NOVA way:* overflow-checked i64 that promotes to `forge_bignum` at *identified* overflow sites only (not
Python's per-op check); `19.99m` decimal-literal suffix (the language surface for `BigDecimal`).
*Drawback avoided:* Python/Ruby's 10–100× overhead on ALL ints; Scheme's multi-way dispatch complexity.
*Unlocks:* the "no overflow surprise" promise; money-safe arithmetic; crypto large-number work.

**L10 — Weak references + user-defined Drop.** [lang] **M** (after Wave-B RC completeness).
*NOVA way:* `fn drop(self)` recognized structurally and called when RC hits zero (no trait impl); `weak<T>`
as a typed surface over the existing `weak_create`/`weak_deref` builtins.
*Drawback avoided:* Rust `Drop`'s borrow-checker interaction (no partial move; `ManuallyDrop`); Swift `deinit`
class-only; C++'s rule-of-5 boilerplate explosion.
*Unlocks:* RAII for FFI/file/socket/GPU/DB handles; caches with weak refs (no RC cycles); observers.

**L12 / L13 — Multi-line collection literals + keyword-as-variable diagnostic.** [lang] **S each.**
*NOVA way:* treat newlines as whitespace inside `[...]`/`{...}` (as already done inside `(...)`); check `let`
binding names against the keyword set and emit a clean E-code. Pure parser fixes, zero semantic change.
*Drawback avoided:* none — these are NOVA-only artifacts (no other language has them).
*Unlocks:* readable lookup tables/config maps; eliminates the silent `let match = ...` mis-codegen class.

### 4.B Stdlib + OS/IO correctness-edge — the "never leave NOVA" layer

**D3 — Regex capture groups (numbered + named).** [runtime] **M.**
*NOVA way:* the NFA engine already emits `RE_SAVE` opcodes and allocates save slots — write them on match,
snapshot/restore on backtrack, expose `regex_captures(text, pat) -> list<string>` and `regex_named_captures
-> dict`. Pure function (pattern in, list out); empty list on no-match (falsy).
*Drawback avoided:* Java's stateful `Matcher` (`find()` before `group()` → `IllegalStateException`); Python's
`None`-return (`AttributeError` without an `if m:` guard); Go RE2's no-backreference surprise.
*Unlocks:* structured text parsing (logs, URLs, dates, key=value) — a daily-use gap. **must-have.**

**D1 — IANA timezone database + DST engine.** [lib] **XL.**
*NOVA way:* pure-NOVA `forge_tz` over a bundled binary `tz.dat` (like Go/Java/Python bundle theirs);
`tz_to_local(epoch, "America/New_York")` / `tz_offset_at` / `tz_next_transition` — functions on ints + strings,
no class hierarchy. All epochs are UTC by definition (no "naive datetime" wrong-by-default). tzdata bundled
INTO the binary (no Alpine/scratch runtime failure).
*Drawback avoided:* Java's 15-class hierarchy (`ZoneId`/`ZonedDateTime`/...); Python's naive-vs-aware silent-
wrong; Go's filesystem-zoneinfo Docker failure.
*Unlocks:* correct cross-timezone scheduling, recurring events, historical timestamps — the calendar/booking/
finance blocker. **must-have.**

**D2 — BigDecimal / arbitrary-precision decimal.** [lib] **L** (needs signed bignum D4).
*NOVA way:* `Decimal{digits, scale, sign}` over `forge_bignum`; `dec("123.45")`, `dec_round(t, 2,
"half_even")`, and — the key — operator overloading so `price + tax * rate` reads naturally. HM infers
`Decimal + Decimal → Decimal`. Precision is per-operation (no global mutable context).
*Drawback avoided:* Java's 50-method mutable-looking-but-immutable API + `new BigDecimal(0.1)` float trap +
`equals`-vs-`compareTo`; Python's global `getcontext().prec` shared mutable state.
*Unlocks:* finance/tax/invoicing, exact decimal reporting, `0.1 + 0.2 == 0.3`. **THE classic reason developers
leave a language. must-have.**

**S1 — OS signal handling (graceful shutdown).** [runtime] **M.**
*NOVA way:* `on_signal("SIGTERM", fn() { server_drain(); db_close(pool); exit(0) })`. Signal-as-channel: the
handler runs as a green task (NOT in signal context — the signal handler only sets a flag + writes a
self-pipe, both async-signal-safe). Windows maps to `SetConsoleCtrlHandler`.
*Drawback avoided:* C's `signal()` UB (async-signal-unsafe handler bodies); Java's shutdown-hook thread with
no ordering + hang-hangs-the-JVM; Go's `signal.Notify` verbosity (channel + goroutine + `signal.Stop`).
*Unlocks:* graceful server shutdown, container/k8s lifecycle compliance, CLI cleanup. **Table stakes for
any deployed service. must-have.**

**D4 — Signed bignum.** [lib] **M.**
*NOVA way:* add a sign to `forge_bignum` (`"-12345"`); all ops handle sign (dividend-sign mod, XOR-sign mul).
*Drawback avoided:* Python's per-op bignum overhead on small ints; Java `BigInteger`'s `a.add(b).multiply(c)`
allocation-heavy chains.
*Unlocks:* exact-integer domains with subtraction (accounting deltas, crypto intermediates, signed modular
math). Prerequisite for D2.

**Sentinel-Argon2id — memory-hard KDF.** [lib] **M.**
*NOVA way:* pure-NOVA `argon2id_hash`/`argon2id_verify` (RFC 9106, OWASP recommendation) over Blake2b +
a `bytes` memory array; lane parallelism maps to `pfor`; PHC-format self-describing output.
*Drawback avoided:* everyone else FFI-binds `libargon2` (native dependency, platform build issues). NOVA's is
pure — same binary Windows/Linux/macOS/WASM.
*Unlocks:* best-practice password storage (Sentinel uses SHA-256 today = not best practice). Independent of
the Sentinel framework. **high.**

**S2 — HTTP client redirects + cookie jar + proxy.** [lib] **M.**
*NOVA way:* auto-follow 301/302/307/308 (up to 10 hops, method-correct); an explicit cookie-jar Value passed
per-request (no hidden Session state); HTTP CONNECT tunneling for HTTPS-through-proxy.
*Drawback avoided:* Python `requests`' massive dependency tree + Session hidden-mutable-state credential
leaks; Go's nil-default cookie jar + `CheckRedirect` function-field ceremony.
*Unlocks:* real API integration (OAuth redirects), CDN compatibility, corporate proxy, session-auth scraping.
The single most-used networking surface. **high.**

**S3 — Thread sync primitives (mutex/rwlock/semaphore/barrier).** [runtime] **M.**
*NOVA way:* green-task-aware locks (`mutex_new`/`lock`/`unlock`, `rwlock_*`, `semaphore_*`) — park on
contention (like channels), fast-path trylock uncontended (Go `sync.Mutex` model, not raw `pthread_mutex`
which would starve the carrier). `with_lock(m, fn())` after L10 lands.
*Drawback avoided:* Rust's `MutexGuard` lifetime + `Poisoned` verbosity; Java's two systems (`synchronized`
keyword vs `j.u.c.locks` hierarchy).
*Unlocks:* guarded caches, resource pools, startup barriers — intra-process shared-state patterns channels
are awkward for. **high.**

**S4/S5/S7/S8/S6 — POSIX last-mile.** [runtime/lib] **S–M each.**
Glob (`glob("src/**/*.nova")`, `**` always recursive — no Python `recursive=True` trap); file
permissions + symlinks (`file_chmod(0o600)` for TLS keys, documented best-effort on Windows); socket options
(`socket_option(fd, "reuseport", true)` — string-keyed, extensible without new API); UDP peer address
(`udp_recv → [data, host, port]` — one call, no `DatagramPacket` pre-allocation); Unix domain sockets
(`unix_listen("/var/run/app.sock")` — Docker/nginx/systemd sidecars).
*Unlocks:* build tools, secure file creation, latency tuning, UDP servers, local IPC. **high, cheap.**

**D8 — Seedable/deterministic PRNG.** [runtime] **S.**
*NOVA way:* `rng_new(42)` returns an independent stream (xoshiro256**); `random_int/float` stay
non-deterministic (CSPRNG). Two use cases, two APIs — no confusion.
*Drawback avoided:* Python's global `random.seed` shared mutable state; Go's pre/post-1.20 seed-default flip.
*Unlocks:* deterministic tests, reproducible simulations, procedural generation. **high, cheap.**

**D11 — Extended math builtins.** [runtime] **S.**
`isnan`/`isinf`/`clamp`/`copysign`/`fma`/`nextafter`/`lgamma`/`erf` — thin `<math.h>` wrappers. `isnan` is
the primary special-float check (no surprising `nan == nan`); `clamp` is one function (not the `max(lo,
min(hi,x))` developers get wrong). *Unlocks:* stats/ML/scientific code. **cheap.**

**D9 — Binary pack/unpack + endianness codec.** [runtime+lib] **M.**
*NOVA way:* typed reads/writes (`bytes_write_u32_be`, `bytes_read_f64_le` — self-documenting) + an optional
Python-style `pack(">Ihd", [...])` format-string API. A future comptime pass validates format strings at
compile time.
*Drawback avoided:* Python `struct`'s cryptic format strings + runtime-only type errors; Go's verbose
per-field `binary.BigEndian.PutUint32`.
*Unlocks:* file formats (PNG/WAV/ELF), removes per-driver wire-encoding duplication, embedded/IoT.

**D6 — Unicode casefold + graphemes (+ collation later).** [lib] **L** (collation XL, deferred).
*NOVA way:* `casefold(s)` (pure function, no stateful Collator) + `graphemes(s)` (UAX-29 state machine, so
`len(graphemes(s))` is visual length and emoji don't split). Plus the `str_eq_canon` helper for the
audit's `==`-ignores-NFC/NFD correctness bug.
*Drawback avoided:* Java's non-thread-safe stateful `Collator`; Go/Rust's external-module requirement.
*Unlocks:* correct case-insensitive compare (auth/search/dedup), correct truncation, emoji, i18n. **high.**

**D5 — XML parser.** [lib] **L.**
*NOVA way:* `xml_parse` returns a dict tree (`{tag, attrs, children, text}`) — dicts and lists, no special
XML types; `xml_find`/`xml_text`/`xml_attr`. Safe-by-default (no DTD/external-entity/billion-laughs).
*Drawback avoided:* Java's three-parser (DOM/SAX/StAX) + JAXB + XPath overwhelm; Python's unsafe-by-default
`expat` (needed a separate `defusedxml`).
*Unlocks:* SOAP/RSS/Atom/sitemap/config-XML consumption. **high.**

**D7 — Persistent/immutable collections.** [lib] **L.**
*NOVA way:* HAMT map + bitmapped-vector-trie vector; being immutable, they cross channels WITHOUT deep-copy
(O(log32 n) update + O(1) send vs O(n) copy for mutable collections). Explicit opt-in — regular list/dict
stay mutable+fast.
*Drawback avoided:* Clojure/Scala paying trie overhead on ALL operations (transients are a separate concept).
*Unlocks:* efficient cross-process sharing, snapshot/undo, functional-update. **nice-to-have.**

### 4.C Domain + presentation layer — the "build anything" half of the identity

**F1 — Browser DOM / reactive UI runtime (Prism-web).** [lib] **XL.** (depends on WASM productization,
audit 5.3.)
*NOVA way:* a UI component is a plain struct holding state; `view : State -> [Statics, Dynamics]` (the
statics/dynamics split `forge_live.nova` already implements). Each live instance is a Process; events flow
in on a channel, patches out on a channel; the developer pattern-matches typed event Values (never touches
`addEventListener`). The killer move: the **SAME `view_fn` runs server-side (LiveView, zero client JS) AND
client-side (WASM, direct DOM)** — server/client is a build flag, not a rewrite.
*Drawback avoided:* React's O(tree) vDOM diff + JS bundle + separate language + no shared types (NOVA diffs at
the dynamics-slot level, ships a smaller WASM binary, and the types are literally the same structs);
Leptos's full Rust complexity; Go's GC pauses in WASM; Phoenix LiveView's every-interaction-round-trips.
*Unlocks:* **the "one developer, one language, builds anything" identity — the frontend half. The adoption
magnet: the reason someone downloads NOVA instead of reaching for Next.js. must-have.**

**F2 — Native GUI / desktop toolkit (Prism-desktop).** [lib] **XL.** (depends on FFI callbacks + L7.)
*NOVA way:* the widget tree is a `Widget` enum Value; the app is a Process, each window a child Process with
its own event channel; the event loop is `recv(events)` in a `loop` with `match`. wgpu via FFI (Vulkan/Metal/
DX12/WebGPU — cross-platform); text via FreeType/HarfBuzz. Channels replace signals/slots (typed, no moc).
*Drawback avoided:* Electron's 200MB Chromium; Qt's moc second-compiler + manual memory; SwiftUI's Apple-only
+ property-wrapper/result-builder complexity; Gio's no-widget-library + GC pauses; Tkinter's 1990s look +
GIL-blocked UI.
*Unlocks:* desktop apps, dev tools in NOVA (a NOVA IDE in NOVA), the Reactor rendering foundation. **must-have
(the biggest single domain hole), but sequenced after FFI maturity + sized numerics.**

**F3 — Autodiff / training (Cortex grad-as-compiler-pass).** [lib+lang] **XL.**
*NOVA way:* `grad(f)` is a **compiler IR transform**, not a runtime tape. It takes `f: Tensor -> Tensor`,
emits `f_grad` returning (output, gradient), and optimizes the combined forward+backward graph as ONE
compilation unit. No tape allocation, no `requires_grad` flag infecting the tensor API, no operator-dispatch
overhead, full cross-op fusion. A training loop is `let (l, g) = grad_fn(weights, batch); weights =
adam_step(weights, g)` — the compiler does the calculus.
*Drawback avoided:* PyTorch's per-forward tape allocation + Python dispatch + no forward/backward fusion +
`requires_grad` API infection; JAX's tracing latency + functional-purity friction; TensorFlow's two-language
graph/eager split; Mojo's closed-source Python-shaped MLIR.
*Unlocks:* **training, fine-tuning — the AI domain, and the reason an ML engineer chooses NOVA over Python.
Without this Cortex is an inference wrapper. high** (interim: ONNX/GGUF/SafeTensors loaders, L, let NOVA
*serve* any pre-trained model now).

**F4 — Columnar dataframe (Pulse).** [lib] **L.**
*NOVA way:* a `DataFrame` is a dict of typed column Values (float columns hit the S4.2 native `double*` path);
lazy plan + materialize; `pmap` fans partitions across processes; streaming = a channel of chunks (same code
on 100-row CSV and 100M-row Parquet). Expressions are plain NOVA lambdas.
*Drawback avoided:* pandas' eager O(n)-temp-per-op + GIL; polars' separate-from-the-web-stack Rust + DSL
that can't call arbitrary code; Spark's distributed overhead for single-node + JVM GC.
*Unlocks:* data analysis, reporting, ML feature engineering, ETL, dashboard backends. **high, viable now that
typed float-array perf landed.**

**F5 — Image codecs (PNG/JPEG) + 2D canvas.** [lib] **L.**
*NOVA way:* an `Image` is a struct with a `bytes` RGBA buffer; PNG = `deflatex` (exists) + chunk/filter
layer; JPEG = baseline DCT decode; the hot loops hit S4.2 typed arrays. Pure NOVA — no libpng/ImageMagick FFI.
*Drawback avoided:* Pillow's C extension + slow pixel ops; Go image/*'s no-SIMD slowness; Sharp's Node native
addon CI failures.
*Unlocks:* avatars, thumbnails, charts (SVG→PNG), QR, ML vision preprocessing, PDF images. **high.**

**F6 — Message-broker wire clients (Kafka/NATS/MQTT).** [lib] **L each.**
*NOVA way:* the proven raw-TCP + `bytes` pattern (PG/MySQL/Redis/TLS). A consumer's output IS a NOVA channel
(`for msg in consumer.messages`); backpressure is native (a full channel pauses the consumer). Config structs
with defaults.
*Drawback avoided:* kafka-python's C extension + GIL; sarama's 200-type API + goroutine leaks + GC; Java's
500-class + XML config + JVM startup.
*Unlocks:* distributed/event-driven apps that integrate with existing infra. **high — cheap pattern-repeats,
ship EARLY to prove integration. Every microservice shop uses a broker.**

**F8 — GCP/Azure cloud SDKs + broader AWS.** [lib] **L each.**
*NOVA way:* pure-NOVA request builders on the existing HTTP client + crypto + JWT (proven by `forge_aws`).
GCP = service-account JWT → REST; Azure = AD client-credentials → REST; AWS extension = SQS/SNS/Lambda/KMS
over SigV4. Typed structs with defaults.
*Drawback avoided:* AWS-SDK-Java's 800 generated classes + 50MB JAR; boto3's dynamic dispatch (no
autocompletion) + runtime errors; Google-Cloud-Go's protobuf-heavy + `if err != nil` ×1000.
*Unlocks:* multi-cloud "run anywhere," enterprise adoption. **high.**

**F9 — PDF generation + XLSX.** [lib] **L.**
*NOVA way:* a `PdfDocument`/`XlsxWorkbook` is a Value; PDF = byte-level container generator over `bytes`
(cross-ref + content streams + font/image embed); XLSX = ZIP (`deflatex`) + templated XML. Pure NOVA.
*Drawback avoided:* reportlab's C extensions + commercial license; PDFBox's 3MB JAR + JVM; gofpdf's staleness
+ no XLSX.
*Unlocks:* invoices, reports, exports, statements — table-stakes for business/SaaS backends. **high.**

**F10 — OpenTelemetry tracing.** [lib] **M.**
*NOVA way:* a `Span` is a Value; span reporting is a background Process; completed spans flow on a channel to
an OTLP/HTTP exporter with backpressure (drop, not unbounded-queue). Forge middleware auto-creates a root
span per request; ORM/HTTP-client child spans auto-instrument (the compiler sees all call sites — no agent).
Context propagates via the process's channel-carried TraceContext.
*Drawback avoided:* OTel-Java's bytecode-agent magic + startup cost; OTel-Go's manual `ctx` threading through
every signature; OTel-Python's monkey-patching + GIL.
*Unlocks:* the third observability pillar (metrics + logs already ship), enterprise readiness. **high, cheap.**

**F7 — GPU kernel lowering (NOVA → SPIR-V/PTX).** [lang/tool] **XL** (hardware-gated).
*NOVA way:* a pure data-parallel `Value -> Value` function over arrays IS a GPU kernel. The compiler verifies
purity (capability inference) + supported ops, lowers the body via LLVM's `nvptx`/`spirv` backends (same
pipeline, different triple), and generates host dispatch. Buffer transfer = a channel send. `@gpu` annotation
(or inferred).
*Drawback avoided:* CUDA/C++'s separate language + manual `cudaMalloc`; PyTorch's precompiled-kernel dispatch
+ Triton JIT latency; wgpu's WGSL separate shader language + manual bind groups.
*Unlocks:* real GPU compute — Cortex training at speed, Pulse aggregations, Reactor. **high, medium-term.**

**F11 — The 8 sibling frameworks.** THIN layers (~500–2000 lines each) mapping a domain to
Values/Processes/Channels, reusing the shared foundation (processes = concurrency, channels = comms, implicit
async = no coloring tax, OTP = fault tolerance, automatic reflection = serialization, LiveView diff core =
reactive state, RC+arena = memory). Cortex (F3+F7), Mesh (distributed — CRDTs on typed channels, consistent
hashing, Raft, `spawn @node("worker-2")`), Prism (F1+F2), Pulse (F4), Sentinel (Argon2id + post-quantum + ZK
+ HSM + `Secret<T>` + constant-time Processes), Edge (freestanding + MCU triples + MMIO in confined `unsafe` +
I2C/SPI drivers), Ops (drift-as-a-channel + multi-cloud F8 + k8s manifests), Reactor (wgpu + ECS-as-Values +
physics FFI + shaders-in-NOVA). *Drawbacks avoided:* Erlang's registry bottleneck (typed channels carry
CRDTs); Terraform's non-language HCL + state-file liability (state is a Value, plan/apply is an inspectable
Process); Rust-embedded's `#![no_std]` ecosystem split (capability-gated no-std doesn't split); Unity's GC
pauses + bolted-on DOTS (ECS is the natural Values+Processes model).

### 4.D Tooling + ecosystem — the connective tissue

**T-LSP — Inferer-backed hover/completion/refactor.** [tool] **L.**
*NOVA way:* the diagnostics path already calls `ti_infer_program_named` and produces a full typed state —
hover/completion just don't use it. Route them through it: hover shows the inferred type; completion suggests
fields/methods by type + dot-completion; add signatureHelp/references/rename off the same AST. Cache TiState
per (uri, version). **A wiring job, not a research project.**
*Drawback avoided:* Java (Eclipse ECJ vs javac) and Rust (rust-analyzer vs rustc) maintaining TWO drifting
compilers. NOVA has ONE — the TypeScript model (the compiler IS the language server), zero drift by
construction.
*Unlocks:* transforms the IDE from "regex hover" to "knows every type." Affects every keystroke; the highest-
leverage DevX win. Foundation for docs, profiler source-mapping, test discovery. **must-have.**

**T-Pkg — Wire the transitive resolver + Vault registry.** [tool] **L (wire) / XL (hosted).**
*NOVA way:* a full transitive+semver+lockfile+integrity resolver EXISTS in `nova_pkg.nova` — wire it into
`nova get`/`install` (Phase A, L); local publish/search (Phase B, M); the hosted Vault registry is itself a
**Forge app** — NOVA's framework serving NOVA's ecosystem (Phase C, XL). ABI check at load time (T-ABI).
*Drawback avoided:* npm's 7-years-to-a-lockfile + left-pad; pip's 17-years-to-a-resolver + numpy conflicts;
crates.io-right-but-slow-compiles. NOVA's resolver + integrity exist BEFORE the registry launches;
content-addressed + ABI-verified + curated = supply-chain security by design.
*Unlocks:* the "build ON, not just IN" transition. **must-have** (Phase A first — cheap, unblocks
multi-package).

**T-Doc — Docs generator (`nova doc`).** [tool] **L.**
*NOVA way:* walk the compiler's own AST + inferred types + RTTI → HTML/JSON/Markdown. `///` comments ADD
description; they don't ENABLE docs — a NOVA fn's signature, a struct's fields, an enum's variants are all
documented from inference with ZERO comments. Examples in ``` blocks are syntax-checked at gen time.
*Drawback avoided:* javadoc's `@param`/`@return` ceremony documenting types you already wrote; Sphinx's
three-docstring-format fragmentation. Go does zero-ceremony docs for *comments*; NOVA does it for *types*.
*Unlocks:* makes the 559 Forge modules discoverable; docs.nova.dev (a docs.rs equivalent). **must-have.**

**T-Profile — Sampling profiler + flamegraph (`nova profile`).** [tool] **L.**
*NOVA way:* sample the IP + unwind via the DWARF already emitted (`nova debug`); map to source, fold stacks,
render SVG (`forge_svg` exists). Richer than pprof from day one: the profiler is a channel observer — not
just "where is CPU time" but "which channel is the bottleneck."
*Drawback avoided:* C's `perf`/gprof fragmentation; Go pprof's import-a-library-run-an-HTTP-server (NOVA's is
a `nova profile` CLI that attaches to any binary, like `perf`/`py-spy`); Java JFR's safepoint bias.
*Unlocks:* makes "NOVA is fast" verifiable on the developer's own code. **high.**

**T-Test — Property-based testing + mocks + DB-rollback + per-fn ergonomics.** [tool/lib] **M each.**
*NOVA way:* the compiler derives GENERATORS from RTTI (like QuickCheck, but zero `@derive` — `string` gen
includes 0x00, catching NUL-truncation by default; `struct` gen combines field generators). A mock IS a
Process responding on a Channel (no framework — channels ARE mocks). DB-rollback = `with_tx` auto-rolled-back.
Per-fn discovery by convention (`test_*`, no `@Test`), rich assert diffs (RTTI-derived show), `--filter`,
parallel (green tasks), TAP/JSON.
*Drawback avoided:* JUnit/Mockito's annotation ceremony + bytecode-gen fighting encapsulation; hypothesis's
90%-rejected-inputs from dynamic typing; proptest/mockall's proc-macro compile explosion.
*Unlocks:* finds NOVA's own bug class (NUL/shift/float-compare) by construction; offline DB testing; a test
story that beats Go and matches pytest/Rust. Critical for the registry quality gate. **high.**

**T-ABI — ABI-version enforcement.** [tool] **S.**
*NOVA way:* the stamp is emitted (`__nova_abi_version`) and `pkg_abi_compatible()` exists — connect them.
Emit a numeric packed version; check it at runtime startup + on package load; fail loud on major mismatch.
*Drawback avoided:* C's DLL-hell silent struct corruption; Python's abi3-15-years-late; Rust's no-stable-ABI
(can never ship precompiled binaries).
*Unlocks:* safe precompiled packages (the registry can serve binaries, not just source). **must-have, cheap.**

**T-Install — Signed one-command installer.** [tool] **M.**
*NOVA way:* `curl -fsSL https://nova-lang.dev/install.sh | sh` / `.msi` — bundles the compiler + runtime +
clang into `~/.nova/toolchains/`, signature-verified, with a version manager (rustup model). The developer
never invokes clang.
*Drawback avoided:* Python's five-installer mess ("which Python?"); Node's nvm/n/volta/fnm fragmentation.
*Unlocks:* 60-seconds-from-never-heard-of-NOVA-to-full-stack-app. First-run friction is the #1 adoption
barrier. **the difference between 100 early adopters and 10.**

**T-REPL/Debug — REPL + CLI debugger productization.** [tool] **S / M.**
*NOVA way:* REPL — resolve the compiler via `argv[0]`/`NOVA_HOME` (not the hardcoded `gen3_test.exe`), back
interactive eval with the existing `eval_expr` interpreter (instant, no per-line clang), show inferred types
after each expression (no other REPL does this). Debugger — drive `lldb`/`lldb-dap` from the CLI (delve model).
*Drawback avoided:* gdb's hostile UX; Julia's 30s REPL JIT warmup; Rust's no-REPL.
*Unlocks:* the "try NOVA in 30 seconds" interactive discovery moment — how Python/Ruby acquired their first
developers. **REPL is cheap + high-impact.**

---

## 5. The gaps we must fix FIRST — the soundness last-mile (Wave A + Wave B)

**The governing rule, restated:** *do not build breadth on a cracked foundation, and do not pour frontier
code onto an unclosed soundness hole.* Everything in §4 assumes these are closed first. These are the
verified backlog from §3.2, ordered as the mandatory foundation.

### Wave A — Soundness (silent-wrong-answer bugs). These block correctness; nothing ships until they close.

1. **0.11 float-return-uninit (XL, High).** A float-returning helper reads an uninitialized float slot →
   silent garbage (`sqrt(variance)` → 3e-156). The ONE remaining silent-wrong-answer bug. Needs a dedicated
   codegen session: LLVM-IR diff working-vs-garbage layouts, zero-init / correctly wire the float return slot
   (the S1 float ABI). Same class as geo_bearing/atan2. **This gates every numeric/AI/data claim.**
2. **Trait-conformance signature check (M, soundness).** Conformance checks name+arity only — `Shape{area()
   ->float}` is satisfied by `area()->string`, mistyped through dynamic dispatch. Record + unify per-method
   param/return types; emit E1006-family on mismatch. **Gates the type-system-soundness claim and L1/L4.**
3. **User-enum payload typing (M, soundness).** Match-arm payload binds to a fresh unconstrained var →
   degrades to `any` (a float field reads raw IEEE bits). The Result/Option fix, still open for user enums.
   Unify each binder against the recorded variant field types.
4. **String `==` NFC/NFD (S/M, correctness/auth-adjacent).** `==` is byte-wise, ignoring the shipped
   normalizers → `"é"` (U+00E9) ≠ `"e"`+U+0301 despite canonical equality. Add `str_eq_canon` + document (and
   the D6 casefold/graphemes library on top).
5. **Scalar `1<<64` UB (S).** Bare `shl i64` with no guard ≥ bitwidth = poison. Clamp in codegen. (Folds into
   L7 sized numerics, but the guard is trivial and independent.)

### Wave B — RC completeness + memory leaks (memory-SAFE, but "it leaks" is not production-acceptable).

6. **Push-of-fresh-temp leak (M)** — the shared root: MOVE-on-insert via a borrow-provenance bit (skip the
   insert-inc when the arg is a proven fresh temp). Same analysis unblocks #7 and #8.
7. **Closure-capture leak (M)** — route `make_closure` through hashed-alloc + a capture managed-slot bitmap
   so `rc_free` dec's boxed captures; relax the escape-mark.
8. **Managed-field-reassignment leak (M)** — owning field reads (`field_get`-inc / borrow tracking) so
   dec-old becomes sound. Shares the root with #6.
9. **RC cycles (XL, supervised)** — opt-in CPython-style trial-deletion collector (per-object `gc_refs`,
   subtract internal refs via the existing per-type child enumeration, free the unreachable set). Enables
   L10 weak/Drop. **Rust has zero leaks by construction; this closes the last memory gap so "no GC pauses"
   is not undercut by "but it leaks."**

### Wave C — Platform + Forge-transport last-mile (unblocks reach + the deploy story). Parallel with Wave B.

10. **ARM/aarch64 fiber context switch (L)** — add the `nova_asm_switch` aarch64 branch. Concurrency silently
    no-ops on ARM today (blocks Apple Silicon + mobile + macOS CI).
11. **N>1 per-carrier I/O + work-stealing (L)** — shard `nova_io_waiters` into per-carrier queues; eliminate
    the global `g_sched_lock` on the hot path. (Beats Go's goroutine runtime.)
12. **Safepoint preemption + `kill` (XL, supervised)** — compiler-inserted yield-checks at loop back-edges;
    timer flag; doomed-flag kill. **The single most important concurrency item — gates soft-realtime and
    true Erlang-parity supervision.**
13. **ALPN + Windows TLS server (L each)** — add ALPN to the TLS accept path (enables h2/gRPC over TLS +
    browser HTTP/2); implement the SChannel server handshake (HTTPS on the dev's own Windows OS).
14. **Linux FD_SETSIZE ≥1024 (M)** — move the Linux netpoller to `poll`/`epoll` (CVE-class stack corruption
    at high concurrency today).
15. **DB fidelity (M)** — `orm_exec` affected-row counts (parse PG CommandComplete / MySQL OK-packet); the
    base32/TOTP/PG-DataRow/Redis NUL-truncation class (byte-based end-to-end, never round-trip binary through
    a NOVA string).

---

## 6. Sequenced roadmap to "everything, better"

Phased waves, dependency-aware, each item tagged **[lang]/[stdlib]/[lib]/[tool]**. The sequence encodes the
governing rule: soundness → correctness-edge stdlib → ecosystem sharing → the declarative multiplier →
presentation → domain frameworks → numeric-at-scale. **Nothing in a later phase starts while its blocking
gap is open.**

### PHASE 0 — Foundation soundness (Waves A + B + C). NOTHING ELSE SHIPS FIRST.

- **[foundation]** Wave A soundness: 0.11 float-return · trait-conformance signature check · user-enum payload
  typing · `==` NFC/NFD · `1<<64` guard.
- **[foundation]** Wave B RC completeness: MOVE-on-insert · closure-capture bitmap · field-reassignment
  ownership · opt-in cycle collector.
- **[foundation]** Wave C reach/transport (parallel): ARM fibers · per-carrier I/O · ALPN + Windows TLS
  server · FD_SETSIZE · DB affected-rows + NUL-safety. Safepoint preemption is XL/supervised — start it here,
  it lands across phases.
- *Governing rule:* a cracked foundation makes every breadth feature above it untrustworthy. This phase is
  the price of the "production-grade everywhere" bar.

### PHASE 1 — Stdlib correctness-edge (the cheapest high-trust breadth; the "never leave NOVA" papercuts).

- **[stdlib]** D3 regex captures (M) · D8 seedable PRNG (S) · D11 extended math (S) · S4 glob (S) · S8 UDP
  peer (S) · S7 socket options (S).
- **[stdlib]** S1 signal handling (M) — the deploy/container blocker.
- **[lib]** D4 signed bignum (M) → D2 BigDecimal (L) — the finance blocker.
- **[lib]** Argon2id (M) — password-storage best practice.
- **[lib]** S2 HTTP-client redirects/cookies/proxy (M) · **[runtime]** S3 sync primitives (M) · S5 file
  perms/symlinks (M) · S6 unix sockets (M) · D9 binary pack/unpack (M).
- **[lib]** D6 casefold + graphemes (L) · D5 XML parser (L) · D1 IANA timezones (XL).
- *Governing rule:* each is self-contained, avoids its drawback (see §4.B), and pays immediate daily value —
  no dependency on the language ceilings.

### PHASE 2 — Ecosystem connective tissue (turns "a language you build IN" into "a platform you build ON").

- **[tool]** T-ABI ABI enforcement (S) — do first; the resolver/registry need it.
- **[tool]** T-LSP inferer-backed hover/completion/refs/rename (L) — the highest-leverage DevX win; shares
  TiState with docs.
- **[tool]** T-Pkg wire the transitive resolver + `nova.lock` (L) — cheap, unblocks multi-package.
- **[tool]** T-Doc `nova doc` (L) — makes 559 modules discoverable; shares the LSP TiState.
- **[tool]** T-Test property-based + mocks + DB-rollback + per-fn ergonomics (M) — the registry quality gate.
- **[tool]** T-Profile sampling profiler (L) · T-REPL productization (S) · T-Install signed installer (M).
- *Governing rule:* every tool reuses the compiler's existing knowledge (one truth source — the TypeScript
  model), avoiding the two-compiler drift that plagues Java/Rust IDEs.

### PHASE 3 — The declarative multiplier (language ceilings that turn Forge + all 8 siblings declarative).

- **[lang]** L11 module namespacing (M) — do first (hard link-error wall; prerequisite for L1).
- **[lang]** L12 + L13 (S each) — parser gotchas, do anytime.
- **[lang]** L6 enforced immutability (M) — gradual migration; correctness + concurrency + optimization lever.
- **[lang]** L7 sized numerics + f32 (M) — unblocks embedded/wire/GPU + L5; folds in the `1<<64` guard.
- **[lang]** L8 custom operators (M) — library ergonomics; unblocks Cortex/Pulse indexing.
- **[lang]** L3 variance (L) — after the trait-conformance fix.
- **[lang]** **L1 annotations + codegen (XL)** — THE #1 lever. Phase-1 built-in hooks (L) deliver 80%.
- **[lang]** **L2 macros/comptime (XL)** — provides L1's substrate; erases the compiler's own ~700 AST sites.
- **[lang]** L5 const generics (L, after L7+L2) · L9 auto-bignum (L, after L7) · L10 weak/Drop (M, after Wave
  B) · L4 associated types (XL, after L3+L1).
- *Governing rule:* each ceiling avoids its drawback (comptime ≠ template hell; sized numerics ≠ C's promotion
  CVEs; variance ≠ Java wildcards; associated types ≠ 6-year GATs). L1+L2 are the widest-blast-radius bet —
  they turn every framework from imperative-registration to declarative.

### PHASE 4 — Presentation layer (the frontend half of NOVA's own full-stack identity).

- **[lib]** F1 browser DOM/reactive UI — Prism-web (XL) — depends on WASM productization (Wave C-adjacent) +
  FFI callbacks. **The adoption magnet.** The hybrid LiveView/WASM (same `view_fn` both sides) is the
  capability no JS framework offers.
- **[lib]** F5 image codecs + 2D canvas (L) — self-contained on `deflatex` + `bytes`; unblocks charts/avatars.
- **[lib]** F2 native GUI — Prism-desktop (XL) — depends on FFI callbacks (`@cdecl`, struct-by-value) + L7 +
  wgpu bindings. The biggest single domain hole; sequenced after FFI maturity.
- *Governing rule:* the presentation layer is the other widest-blast-radius bet — it delivers the "one
  developer, one language, real frontend" identity that makes someone download NOVA.

### PHASE 5 — Domain frameworks + wire-protocol clients (cheap pattern-repeats first, then the frameworks).

- **[lib]** F6 broker clients Kafka/NATS/MQTT (L each) · F8 GCP/Azure/AWS SDKs (L each) · F10 OpenTelemetry
  (M) · F9 PDF/XLSX (L) — pattern-repeats of the proven raw-TCP + HTTP + `bytes` stack. **Ship EARLY to prove
  integration** ("I can actually use this for real work").
- **[lib]** F4 Pulse dataframe (L) — viable now that typed float arrays landed.
- **[framework]** Sentinel (Argon2id done in Phase 1 + post-quantum + `Secret<T>` + constant-time) · Mesh
  (production distribution: node links + registry + remote monitor + TLS + CRDTs — depends on
  remote_spawn hardening + safepoint kill) · Ops (drift-as-a-channel on F8).
- *Governing rule:* do not start a framework whose blocking core gap is still open (Mesh needs distribution
  hardening + kill; Edge needs sized numerics + ARM fibers + freestanding).

### PHASE 6 — Numeric-at-scale frontier (owns AI/data; XL, hardware-gated, interlocking).

- **[lang/tool]** F7 GPU kernel lowering → SPIR-V/PTX (XL, hardware-gated) — the compute frontier under
  F3/F4/Reactor.
- **[lib+lang]** F3 autodiff/training — Cortex grad-as-compiler-pass (XL) — depends on F7 for real speed;
  interim ONNX/GGUF/SafeTensors loaders (L) serve pre-trained models now. **The "never seen this before"
  differentiator — training as a language primitive.**
- **[framework]** Reactor (wgpu + ECS-as-Values + physics FFI + shaders-in-NOVA — depends on F2+F7+F5) ·
  Edge (freestanding MCU targets + drivers — depends on L7 + ARM fibers + `--freestanding` capability-gating).
- *Governing rule:* these interlock (train → GPU → dataframe → game engine); each waits on its dependency.
  Frontier code never lands on an unclosed soundness hole (Phase 0 gates it).

**The full dependency spine, one line:** *Wave A soundness → Wave B RC + Wave C reach (parallel) → stdlib
correctness-edge → ecosystem sharing (ABI → LSP → resolver → docs → test → registry) → module-namespacing →
annotations + comptime (the declarative multiplier) → presentation (browser + desktop) → wire clients +
domain frameworks → GPU + autodiff + Reactor/Edge.*

---

## 7. The two widest-blast-radius bets

Everything above sequences toward two investments whose blast radius dwarfs the rest. If the multi-month
build has two north stars inside the north star, these are them.

### BET 1 — Annotations + macros/comptime (L1 + L2): the declarative multiplier.

This is the #1 lever because **every declarative framework in Java/C#/Kotlin/Rust rides annotations or
macros, and NOVA has neither.** Without them, Forge stays imperative (`route(m, "/users", h)`) where Spring is
declarative (`@GetMapping`), and the type-driven `service` marquee, declarative ORM/DI/routing/validation/
test-discovery — the entire declarative-framework class — stay blocked. With them, all 8 sibling frameworks
become declarative *at once*, and the compiler's own ~700 hand-built AST sites collapse into quasi-quotation.

The NOVA way makes this a *language* feature, not a bolted-on toolchain: comptime is ordinary typed
debuggable NOVA running at build time over typed AST; annotations are typed metadata read by same-unit
codegen hooks that emit IR; both are sandboxed, fuel-bounded, and zero-runtime-cost. This is the one place
NOVA can leapfrog *every* incumbent — Java's runtime reflection, Rust's separate-crate untyped proc-macros,
C++'s template error hell, C#'s separate-assembly source generators — with a single, simpler, typed
substrate. **It is XL, it is sequenced after module-namespacing + soundness, and it is the highest-value
work in the entire plan.**

### BET 2 — The presentation layer (F1 browser + F2 desktop): the frontend half of the identity.

NOVA's flagship promise is "backend + **frontend** + deploy, one language." Today the frontend is
server-rendered HTML or ANSI text — a native window has never opened, and the browser has only string
templates. **This is the single biggest domain hole and the literal other half of NOVA's identity.** The
adoption magnet is a full-stack app with shared front-and-back types in ONE language: the hybrid LiveView/
WASM model (the *same* `view_fn` server-rendered for SEO/fast-paint AND client-side in WASM for instant
interaction) is a capability *no* framework — not React, not Leptos, not Phoenix — can match, because the
types are literally the same structs and there is no serialization boundary.

It is XL and depends on WASM productization + FFI callbacks + (for desktop) sized numerics, which is why it
is sequenced after the language ceilings. But it is the reason someone downloads NOVA instead of reaching for
Next.js — and downloading is where every adoption story begins.

**Both bets share one truth:** they are only trustworthy on a closed foundation. That is why Phase 0 comes
first, and why the governing rule — *don't build breadth on a cracked foundation; every feature avoids its
drawback* — is the discipline that carries NOVA from "a better language" to "everything, better."

---
---

# ═══════════════════════ PART II — FRAMEWORK FOUNDATION READINESS ═══════════════════════

---

# NOVA — FRAMEWORK FOUNDATION READINESS (2026-07-10)

> **The owner's insight, stated exactly:** *the core is the foundation for all 9 frameworks; once we write
> a framework on top of it, we can't go back.* An upstream mistake in the core does not cost one framework —
> it costs every framework built after it, plus every user who wrote code against the framework's public
> API. A grammar error costs hours at Layer 0 but months at Layer 4. This document is the answer: **it
> identifies the small set of core DESIGN decisions that MUST be locked NOW — before the frameworks are
> built — so that no framework is ever built on a core that has to change under it.**
>
> **Sources folded in (read in full):** the five cluster foundation-readiness analyses
> (numeric/type-system/GPU · native/embedded/GUI · concurrency/distribution · security/ops ·
> the 7-capability foundation-lock), the [`NOVA_GRAND_PLAN_2026_07_10.md`](NOVA_GRAND_PLAN_2026_07_10.md)
> §6 roadmap + §7 two-bets, and the code-verified [`REMAINING_GAPS_AUDIT_2026_07_10.md`](REMAINING_GAPS_AUDIT_2026_07_10.md).
> Every LOCK-NOW verdict below is grounded in file:line evidence in those cluster docs.
>
> **What this document is NOT.** It is not a new plan competing with the Grand Plan. It **sharpens** the
> Grand Plan by answering one question the phase list does not answer head-on: *which core decisions are
> irreversible once a framework rides them, and therefore must be DESIGNED (spec-locked, representation
> reserved) before the framework begins — even if the full implementation lands incrementally?* The Grand
> Plan's Phase-3 language ceilings + Wave-C reach/preemption + FFI/GPU work **ARE** the framework
> foundations. This doc names them as such and pins the exact lock points.

---

## 1. The principle — why "lock now" is not premature

NOVA's architecture is settled and trustworthy: it self-hosts to a byte-identical fixpoint, the Tier-0
UB/UAF class is closed, the type checker is sound by default, and Forge proves the framework-on-core model
works. That trustworthiness is exactly why the next mistake is dangerous: **the core is now stable enough
that frameworks will be built on it, and a framework's public API is a contract that outlives the core
version it was written against.**

There are three distinct categories of core change, and only one of them is safe to defer:

1. **ADDITIVE (safe to defer).** A new runtime builtin, a new backend triple, a new library. Adding
   `ptr_read_volatile_u32`, `epoll` on Linux, or an XML parser invalidates no code already written. These
   are ACCOMMODATES — build the framework, add the capability when needed, nothing breaks.

2. **REPRESENTATION-CHANGING (must lock the DESIGN now, implement incrementally).** A change to `NType`
   (width/signedness fields), to the IR (address-space attributes on pointers, per-opcode adjoint rules), to
   the value ABI (sized numerics through the i64-everywhere convention), to the symbol model (mangling), or
   to the calling convention (C-callable `@cdecl`). These change the SHAPE of the thing every framework
   references. A framework built before the shape is fixed encodes the old shape into its API, its stored
   data, its FFI bindings — and changing the shape later is an ABI break that invalidates every downstream
   artifact. **These are the LOCK-NOW items.** The implementation can be phased; the DESIGN (the reserved
   fields, the promotion rules, the mangling scheme, the hook point) cannot.

3. **SEMANTICS-DEFINING (must lock now because the framework's model depends on it existing).** `kill(pid)`
   for supervision, the distribution wire protocol's control frames, the annotation processing hook point. A
   framework built assuming these work (Mesh's supervision trees, Forge's declarative routes) becomes fiction
   if the capability turns out to be un-retrofittable. The framework's entire model is wrong.

The catastrophe scenario is concrete and named in all five cluster analyses: **build Cortex on i64-only
values → every tensor API takes and returns f64, every model-format loader up-converts, every GPU buffer is
the wrong type; then sized numerics land and the entire Cortex tensor API must change — breaking every Cortex
user.** Or: **ship Forge packages with bare symbols → the second package that also defines `connect()` fails
to link; add mangling later → every precompiled package is invalid, the ABI stamp bumps, the whole registry
is void.** Each is an *upstream-mistake-costs-months* failure, and each is avoidable by locking one
representation NOW.

**The discipline this document enforces:** for every core decision, classify it PROVIDES / ACCOMMODATES /
LOCK-NOW, and for every LOCK-NOW item state the decision, whether the current core accommodates it or needs a
change now, the NOVA-way design, and what breaks if we defer it. Then sequence the LOCK-NOW work so no
framework is built before its core prerequisites exist.

---

## 2. Framework → core-requirement matrix

Rows = the 9 frameworks. Columns = the core capabilities the cluster analyses identified. Each cell:

- **PROVIDES** — the core has it today; the framework uses it as-is.
- **EXTEND** — additive work needed (ACCOMMODATES); build the framework, add the capability, nothing breaks.
- **LOCK-NOW** — a representation- or semantics-level decision that must be locked before this framework is
  built, or retrofitting breaks the framework's API. **The heart of the risk.**
- **n·a** — the framework does not need this capability.

| Framework ↓ / Capability → | Sized numerics (f32/u·) | Const generics | Autodiff (grad) | GPU lowering + GPU-mem | FFI callbacks (`@cdecl`) | Struct-by-val FFI | Freestanding + MCU triples | ARM/aarch64 fibers | Safepoint preempt + `kill` | Dist. wire protocol + NodeRef | Annotations → codegen hook | Const-time + `Secret<T>` | Module namespacing | Trait-conformance sig-check |
|---|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|
| **Forge** (web) | EXTEND | n·a | n·a | n·a | **LOCK**¹ | EXTEND | n·a | **LOCK**² | **LOCK** | EXTEND | **LOCK** | **LOCK**³ | **LOCK** | **LOCK** |
| **Cortex** (AI/ML) | **LOCK** | **LOCK** | **LOCK** | **LOCK** | EXTEND | EXTEND | n·a | EXTEND | EXTEND | n·a | **LOCK** | n·a | **LOCK** | **LOCK** |
| **Mesh** (distributed) | EXTEND | n·a | n·a | n·a | EXTEND | n·a | n·a | **LOCK** | **LOCK** | **LOCK** | **LOCK** | EXTEND | **LOCK** | **LOCK** |
| **Prism** (GUI web+desktop) | **LOCK** | n·a | n·a | EXTEND⁴ | **LOCK** | **LOCK** | **LOCK**⁵ | **LOCK** | EXTEND | n·a | **LOCK** | n·a | **LOCK** | **LOCK** |
| **Pulse** (data) | **LOCK** | **LOCK** | EXTEND | EXTEND | n·a | n·a | n·a | EXTEND | EXTEND | n·a | **LOCK** | n·a | **LOCK** | **LOCK** |
| **Sentinel** (security) | **LOCK** | n·a | n·a | EXTEND | EXTEND | n·a | n·a | EXTEND | EXTEND | n·a | **LOCK** | **LOCK** | **LOCK** | **LOCK** |
| **Edge** (embedded/MCU) | **LOCK** | EXTEND | n·a | n·a | **LOCK** | **LOCK** | **LOCK** | **LOCK** | EXTEND | n·a | EXTEND | EXTEND | **LOCK** | EXTEND |
| **Ops** (DevOps) | EXTEND | n·a | n·a | n·a | EXTEND | n·a | n·a | EXTEND | EXTEND | EXTEND | EXTEND | n·a | **LOCK** | EXTEND |
| **Reactor** (games) | **LOCK** | EXTEND | EXTEND | **LOCK** | **LOCK** | **LOCK** | n·a | **LOCK** | **LOCK** | n·a | **LOCK** | n·a | **LOCK** | **LOCK** |

**Footnotes.** ¹ Forge needs `@cdecl` specifically for OpenSSL's `SSL_CTX_set_alpn_select_cb` (the ALPN
callback) — the #1 Forge-transport blocker; without it h2/gRPC-over-TLS is impossible. ² Forge on Apple
Silicon / ARM servers has no concurrency without aarch64 fibers. ³ Sentinel's `Secret<T>`/const-time
primitives are used *by Forge* (passwords/tokens in every handler; three live `_ct_eq` copies) — they are
Forge-relevant, not Sentinel-only. ⁴ Reactor/Prism-desktop GPU is EXTEND for *rendering* (WGSL-via-FFI works)
but the RC-managed GPU-buffer-as-Value + IR address-space decision is LOCK for Cortex/Reactor *compute*.
⁵ Prism-web (WASM) needs the freestanding/WASM-value-model link; Prism-desktop does not.

### The shared-dependency read (a capability needed by 3+ frameworks is top-priority)

Counting LOCK-NOW cells per column reveals the true priority order — the widest-blast-radius core decisions:

| Core capability | # frameworks that LOCK on it | Priority |
|---|:--:|---|
| **Module namespacing (L11)** | **9 of 9** | **P0 — universal, and ABI-breaking if retrofitted** |
| **Annotations → codegen hook (L1)** | **8 of 9** (Edge/Ops = EXTEND) | **P0 — THE declarative multiplier** |
| **Trait-conformance signature check** | **7 of 9** | **P0 — a soundness hole; gates all trait-based APIs** |
| **Sized numerics + f32 (L7)** | **6 of 9** | **P0 — widest representation change** |
| **Safepoint preemption + `kill`** | **6 of 9** | **P1 — semantics-defining for supervision/frame-budget** |
| **ARM/aarch64 fibers** | **5 of 9** | **P1 — additive but blocking; Apple Silicon + servers** |
| **FFI callbacks (`@cdecl`)** | **5 of 9** | **P1 — calling-convention decision, per-`extern-fn` blast** |
| **Const-time + `Secret<T>`** | **3 of 9** (Forge/Sentinel + Forge's live crypto) | **P1 — API-breaking if retrofitted onto crypto** |
| **GPU lowering + GPU-mem-as-Value** | **3 of 9** | **P2 — IR address-space + RC-buffer; hardware-gated** |
| **Const generics (L5)** | **3 of 9** | **P2 — depends on L7; shape-checked tensor APIs** |
| **Struct-by-value FFI** | **3 of 9** | **P2 — depends on L7 for field types** |
| **Distribution wire protocol + NodeRef** | **2 of 9** (Mesh/Ops) | **P2 — Mesh-specific but ABI-locked once built** |
| **Autodiff (`grad`)** | **1 of 9** (Cortex) | **P2 — IR-transform design; adjoint-rule table** |
| **Freestanding + MCU triples** | **3 of 9** (Edge/Prism-web) | **P2 — coupled runtime split + gating** |

**The four P0 columns are where "we can't go back" bites hardest**, because they are either universal (module
namespacing touches every symbol every framework emits), the multiplier (annotations turn all 8 sibling
frameworks declarative at once, and an imperative→declarative migration breaks every user), a live soundness
hole (trait-conformance — every trait-based framework API is unsound until fixed), or the widest
representation change (sized numerics reshape `NType` + the ABI + runtime array storage, and 6 frameworks
encode f32/u· into their public types).

---

## 3. The LOCK-NOW foundational decisions (the heart)

For each: **the decision**, **whether the current core accommodates it or needs a change now**, **the
NOVA-way design**, and **what breaks if we defer it.** Ordered by blast radius.

---

### LOCK-1 — Module-symbol namespacing (`@mod__fn` mangling) · [lang] L11 · M · 9/9 frameworks

**The decision.** Every module-scoped NOVA symbol emits as a deterministic mangled name `@<mod>__<fn>`;
root-module symbols and `extern fn` declarations stay bare. The developer writes `forge_pg.connect(...)`; the
compiler resolves through the existing `ir_module_of` map and emits `@forge_pg__connect`.

**Does the core accommodate it?** **NO — this is a change that must be made now.** Today all NOVA functions
emit as bare LLVM symbols; two independently-authored packages defining `connect()` collide at link with an
undiagnosable error. This is *already* a hard link-error wall (Forge works around it with manual `forge_`
prefixes — the 40-year C gymnastics NOVA exists to escape). `ir_modules` tracks membership but does not mangle
output.

**The NOVA-way design.** Deterministic `@<mod>__<fn>` (not C++'s unreadable `_ZN5boost...`, not Rust's opaque
hash-mangling needing `#[no_mangle]` for FFI). Debug info emits the SHORT name so the debugger and LSP show
`connect`. 4 compiler edit sites + runtime fn-table registration (`call_by_name` dispatch) + reconverge.
Invisible to the developer, reproducible for builds.

**What breaks if deferred.** **The single most irreversible item — an ABI break by construction.** If any
framework ships as a package with bare symbols and mangling lands later: (a) every precompiled package binary
becomes invalid; (b) every `extern fn` reference to a NOVA function by name breaks; (c) the ABI version stamp
bumps, voiding the entire registry; (d) the T-Pkg resolver — which CANNOT function without namespacing — must
be re-validated against every package. **Do this FIRST. No dependencies; unblocks L1 and the registry; every
day a package ships without it deepens the ABI debt.**

---

### LOCK-2 — Annotations → compile-time codegen hook point · [lang] L1/L2 · XL (Phase-1 hooks = L) · 8/9

**The decision.** Fix, NOW, *where in the compiler pipeline* annotation processing runs, *what it receives*,
and *what it may do* — even if the full user-extensible system (L1 Phase 2) is XL and lands later. Phase 1 can
hardcode a closed set of built-in annotations (`@route`, `@service`, `@middleware`, `@test`, `@gpu`,
`@cdecl`, `@redact`) and still deliver 80% of the value.

**Does the core accommodate it?** **The mechanism does NOT exist, but the AST substrate is ready.** `Stmt`
nodes already carry an `annotations` list (used internally for `generics`/`ensures`/`memo`); the parser
recognizes annotations but only rejects `@derive`. There is no annotation-processing pass, no codegen hook, no
comptime engine. **What must be locked now is the HOOK POINT, not the full engine.**

**The NOVA-way design.** The hook runs **after `ti_infer_program_named` (typed AST available), before
`ir_gen`** — the only point where typed information exists AND codegen is still open. A codegen hook is an
ordinary NOVA function that runs *inside the compiler at IR-gen time over typed AST nodes* and emits IR — not
a separate crate (Rust proc-macros), not a token stream, not runtime reflection (Java/Spring), not a separate
assembly (C# source generators). `@route("GET","/users")` on a function emits the dispatch wiring at compile
time and erases the annotation → zero runtime cost, zero classpath scan, invalid annotations are compile
errors. Sandboxed (no I/O authority via the authority-value model), fuel-bounded (`ce_budget_ok`).

**What breaks if deferred.** **This is BET 1 in the Grand Plan and the reason it is a bet.** If frameworks
ship with imperative registration (`route(m, "/users", handler)`) and annotations land later: (a) every
framework's public API changes from imperative to declarative — a breaking change for ALL users of ALL 8
sibling frameworks at once; (b) the hook's representation must accommodate all 9 frameworks' needs
simultaneously — if Forge ships `@route` first and the design is not general enough, the second framework
forces a redesign that breaks Forge; (c) if the comptime authority/IO model is designed *after* Forge's
annotations, Forge's annotations may need redesigning. **The hook point + annotation schema (name, typed args,
target restrictions) must be locked before ANY framework goes declarative. An imperative API can exist as a
Phase-0 stopgap ONLY if the declarative layer is designed to subsume it without breaking it** — i.e., `@route`
desugars to the same `forge_route_register` call the imperative API uses, so both coexist and no user
migration is forced.

---

### LOCK-3 — Trait-conformance signature check · [type-system] · M · 7/9 frameworks · SOUNDNESS

**The decision.** Trait conformance must verify per-method **parameter and return TYPES**, not just method
name + arity. The decision is already made; the fix is unimplemented.

**Does the core accommodate it?** **NO — it is a live soundness hole that must close before trait-based
framework APIs are built.** Today `ti_check_trait_conformance` (nova_compiler.nova:13680-13734) checks only
name (`list_contains`) + arity. `Shape{area()->float}` is satisfied by an impl `area()->string` — the wrong
type is then mistyped through dynamic dispatch (a float slot reads a string pointer's raw bits).

**The NOVA-way design.** Record per-method param + return types at trait declaration and at impl; unify the
impl signature against the trait signature in conformance; emit an E1006-family error on mismatch. Guard with
a negative test. Additive to the existing trait infrastructure (`ti_traits` already stores method names — it
gains type bindings).

**What breaks if deferred.** Every trait-based framework API is unsound. Forge's `service` block, Cortex's
`Optimizer`/`Layer` traits, Sentinel's `Cipher` trait, Pulse's `Column` trait, Reactor's `System`/`Component`
traits — all rely on trait dispatch. Built on name+arity-only conformance, every `impl` that
type-checks-but-mismatches is a silent wrong-answer bug in the framework; the fix later does not break the API
but *does* suddenly reject implementations users already wrote (a source break). **Close it before any
framework's trait surface is designed** — it is Wave-A in the Grand Plan and gates L1/L4.

---

### LOCK-4 — Sized/unsigned numerics + f32 (`NType` width/signed + ABI + array storage) · [lang] L7 · M · 6/9

**The decision.** `NType` gains a numeric width and signedness (`Int(width, signed)`, `Float(32|64)`); the
value model stops being uniformly `i64`; runtime collections gain multi-kind element storage; the FFI ABI
learns `f32`/`u·`. `let x = 42` stays i64 and `3.14` stays f64 (zero ceremony for 95% of code); sized types
arise from suffix literals (`255u8`, `1.5f32`) or annotations.

**Does the core accommodate it?** **NO — the widest representation change in the entire plan, and it must at
minimum be SPEC-LOCKED now (fields reserved, promotion lattice defined, runtime `elem_kind` extension
documented) before any framework stores typed arrays or calls an f32 C API.** Today the entire value model is
one `i64`: `NType` has no width/signed field; every user function is `define i64 @fn(i64...)`; all arithmetic
is `mul i64`/`srem i64`; floats are bit-punned through i64; `ffi_llvm_type` knows only `double/ptr/void/i32/
i64`; `NovaList` stores `int64_t*`. The `1<<64` UB (bare `shl i64`) is this model producing actual UB.

**The NOVA-way design.** Sized types as **value refinements inside HM inference** (Grand Plan L7): default
i64/f64 (zero ceremony); implicit *safe* widening (`u8 + u32 → u32`, `f32 + f64 → f64`); explicit *checked*
narrowing (`u32(x)` panics on overflow, `u32!(x)` wraps) — avoiding both C's implicit-promotion CVE factory
and Rust's silently-truncating `as`. Codegen emits the correct LLVM type per value (`i32`, `float`, `half`,
`bfloat16`). `NovaList` `elem_kind` extends: 0=boxed-any, 2=raw-f64, 3=raw-f32, 4=raw-i32, … — array ops
dispatch on kind. Folds in the `1<<64` guard.

**What breaks if deferred.** The named catastrophe in every cluster analysis:
- **Cortex** tensors are f64-only → bf16/f16 (the training/inference standard since 2020) cannot exist; model
  weights up-convert to f64 (4× memory, no native-width SIMD); the `Tensor<T,...>` API bakes f64 into every
  signature, and sized numerics later forces an API-breaking rewrite of every tensor operation.
- **Pulse** columns are f64-only (a 100M-row f32 column wastes 400MB); unsigned ID/timestamp columns mis-sort
  (`icmp slt` treats bit 63 as sign).
- **Reactor**/**Prism-desktop** GPU APIs require f32 uniforms/vertices, u8 color channels — passing i64 means
  conversion on every buffer transfer, and vertex-format types are wrong.
- **Sentinel** post-quantum (ML-KEM/ML-DSA) NTT needs 16/32-bit modular arithmetic — without sized types it
  is `(((a*b)&65535)+c)&65535` on every operation (a bug farm), and the `1<<64` UB makes shift-based crypto
  unsound.
- **Edge** MCU registers are 8/16/32-bit; a `u8` GPIO as i64 wastes 7 bytes and cannot represent unsigned
  wrap; `thumbv7m` is a 32-bit target with no native i64.

Retrofitting touches `NType` (~100+ `kind=="int"`/`"float"` sites), unification (promotion lattice), every
`ire_emit_*` path, runtime collection layout, and the FFI ABI. **Lock the representation now; implement
incrementally.** L5 (const generics), struct-by-value FFI, and f32-in-FFI all depend on it.

---

### LOCK-5 — Safepoint preemption + `kill(pid)` / linked-exit · [runtime+compiler] · XL supervised · 6/9

**The decision.** The compiler inserts a safepoint check (load a per-task `doomed` flag + conditional branch)
at loop back-edges; the runtime defines a `doomed` flag on `NovaSchedTask`, a `kill(pid)` that sets it (and
wakes a parked fiber), and a next-safepoint unwind (panic/longjmp through the existing fiber-entry path).
Design this NOW even though implementation lands across phases.

**Does the core accommodate it?** **NO — the runtime is cooperative-only with no kill, and the fiber
entry/exit + monitor-notification protocols must be DESIGNED to accommodate preemption before supervision is
built on them.** Today `nova_rt_reschedule` yields only at park points; there is no `kill`/`doomed`/safepoint
anywhere; `forge_otp.nova` documents "NOVA has no preemptive kill — restart = spawn a fresh instance; a
healthy sibling is NOT stopped." A zombie CPU-bound child keeps consuming its carrier's run slot forever.

**The NOVA-way design.** One predicted-not-taken branch per loop iteration
(`%sf = load volatile i1 %task_doomed; br i1 %sf, kill_unwind, continue`); LLVM hoists it out of tight loops
the optimizer proves side-effect-free, so C-parity survives. Precise where BEAM's reduction-counting is
imprecise; no GC to complicate it (Go solved this in 1.14). `kill` sets the flag; the next safepoint raises a
`Killed` unwind; `link`/`monitor` already exist and just observe the exit.

**What breaks if deferred.** **Mesh supervision is fiction without kill** — a supervisor that restarts a
crashed child but cannot stop a still-running one is not Erlang-equivalent; zombies accumulate carriers, and
at N=1 (the production default) a single CPU-bound zombie blocks ALL green tasks on that carrier forever.
**Reactor's frame budget is impossible** — a physics computation overrunning 16ms cannot be preempted.
**Forge's graceful shutdown is incomplete** — a handler stuck in a CPU loop cannot be killed on SIGTERM. This
is LOCK-NOW rather than EXTEND because if Mesh builds supervision trees assuming `kill` works and it turns out
un-retrofittable (the fiber unwind protocol wasn't designed for it), the entire Mesh supervision model — its
public API, its restart semantics — is wrong. **Design the safepoint + unwind protocol in Phase 0; it lands
incrementally but the fiber-entry contract must reserve for it now.**

---

### LOCK-6 — FFI callbacks (`@cdecl`) · [lang+runtime] · L-XL · 5/9 frameworks

**The decision.** A `@cdecl` annotation marks a NOVA function as C-ABI-callable (emitted with C calling
convention, no environment pointer), plus a trampoline that bridges C-ABI → NOVA's `i64(i64,i64)` convention
for closures that carry state. The calling-convention decision — *does the callback run on the calling C
thread (blocking the carrier) or trampoline into the green-task scheduler?* — must be locked because it
affects the entire concurrency-model/FFI interaction.

**Does the core accommodate it?** **NO — FFI is strictly one-way (NOVA calls C, never C calls NOVA), and the
calling-convention decision is per-`extern-fn` blast radius.** Every NOVA function takes `(i64 env, i64
arg0…)` with an environment pointer C cannot manufacture; there is no function-pointer FFI type, no reverse
trampoline, no `@cdecl`.

**The NOVA-way design.** `@cdecl fn on_resize(w: i32, h: i32) -> void { … }` emits
`define void @on_resize(i32, i32)` — standard C convention, no closure record. For stateful
closures-as-callbacks, a static trampoline table stores the NOVA closure pointer (thread-local/global slot)
and the trampoline loads it + calls the real function — exactly how Go cgo, Rust `extern "C" fn`, and Zig
`@ptrCast` work (well-understood, no novel research). The callback enters the NOVA scheduler as a green task
(or runs inline under `--freestanding`).

**What breaks if deferred.** **Prism-desktop and Edge are DEAD without this** — wgpu/Vulkan/DX12/Metal need
device-lost/resize/input callbacks; glfw/SDL/winit need window-event callbacks; MCU ISRs and RTOS
(FreeRTOS/Zephyr) callbacks are C function pointers. Without C→NOVA re-entry a GUI cannot receive any event
(poll-loop workarounds miss events and waste CPU) and an MCU cannot respond to any hardware interrupt.
**Forge is also blocked** — OpenSSL's `SSL_CTX_set_alpn_select_cb` (the ALPN callback, the #1 Forge-transport
blocker for h2/gRPC-over-TLS) cannot be provided. If Prism ships with poll-loop workarounds or Edge with C ISR
stubs, every event binding is throw-away work and the NOVA-in-NOVA promise breaks. **The `@cdecl` calling
convention must be locked before any callback-using framework is built.**

---

### LOCK-7 — Constant-time code region (`@ct`) + `Secret<T>` primitives · [compiler+runtime] · M+S · 3/9

**The decision.** Three coupled locks: (a) a `@ct` annotation that emits a function with LLVM `optnone
noinline` + entry/exit `asm volatile("" ::: "memory")` barriers so `-O2` cannot transform a constant-time
comparison into a short-circuiting `memcmp`; (b) a `nova_rt_secure_zero(ptr, len)` runtime primitive
(`SecureZeroMemory`/`explicit_bzero`, NOT `memset` which the optimizer elides); (c) a `@redact` annotation
that makes the compiler's automatic `show`/`to_json` emit `"***"` for a marked type/field.

**Does the core accommodate it?** **NO — there is source-level constant-time discipline with ZERO
compiler/runtime backing.** THREE independent copies of the XOR-accumulate `_ct_eq` exist (forge.nova,
forge_captcha.nova, sentinel.nova), each hoping LLVM does not recognize the pattern and replace it with a
branching `bcmp`. All user functions get only `nounwind uwtable` — no mechanism to emit per-function
attributes. No `secure_zero` (freed secrets persist in memory). Automatic reflection prints any struct's
fields (a `Secret<T>` would log its contents).

**The NOVA-way design.** `@ct` → `optnone noinline` + volatile barriers is the Clang approach for
security-critical code — a sledgehammer but correct. `@redact` is a ~20-line codegen change in the generated
`show`/`to_json` methods. `secure_zero` is a one-function runtime addition. The full `Secret<T>`
taint-tracking layers later on L1 (annotations) + L10 (user Drop for zeroize-on-drop) + the authority model.

**What breaks if deferred.** **The three existing `_ct_eq` copies are already vulnerable** — they back Forge's
live HMAC verify, CSRF verify, and JWT verify paths; under `-O2` each is a potential timing oracle for
key/token extraction. **Post-quantum crypto is broken without it** — ML-KEM/ML-DSA rejection sampling MUST be
constant-time or the private key leaks (shipping timing-vulnerable PQ crypto is worse than shipping none).
**Secrets leak to logs and memory** — `print(request)` in a Forge handler leaks credentials (the #1
real-world security bug class); freed secrets sit in core dumps/swap (PCI/SOC2 violation). Retrofitting is
API-breaking: if `constant_time_eq(a,b) -> bool` ships as a regular function and later must become a
compiler-special or `Secret<T>`-only, every call site breaks. **`@ct` + `secure_zero` + `@redact` are S/M
effort and must be locked before ANY Sentinel work or any new crypto path** — and because Forge already
depends on `_ct_eq`, they are effectively Phase-0 hardening.

---

### LOCK-8 — GPU kernel lowering + GPU-memory-as-Value · [compiler+runtime] · XL hardware-gated · 3/9

**The decision.** Two coupled locks: (a) the IR must carry an **address-space attribute on pointer-typed
values** so GPU-kernel IR can distinguish global/local/private memory — decided ALONGSIDE L7, because
sized-type pointers (`f32*`, `bf16*`) in GPU address spaces are the intersection point, and it must be
compatible with the autodiff pass (LOCK-9); (b) a **GPU buffer must be a Value with an RC header and type
identity** (so it can be sent on a channel = DMA transfer, and released on last dec), NOT the current opaque
i64 handle.

**Does the core accommodate it?** **NO for the representation locks; EXTEND for the backend triples.** Adding
`nvptx64-nvidia-cuda`/`spirv64` to `resolve_target` is additive (backend model is text-LLVM-IR → clang, so new
targets are a table extension). But: the IR emits ALL pointers as generic `ptr` (address space 0) — a GPU
kernel's global buffers need `ptr addrspace(1)`; and the GPU buffer API is a 64-slot fixed array of
i64-read/write handles, incompatible with an RC-managed typed Value.

**The NOVA-way design.** A pure data-parallel `Value -> Value` function over arrays IS a GPU kernel; the
compiler verifies purity (no allocating/IO `nova_rt_*` calls) + supported ops, and lowers the body via LLVM's
`nvptx`/`spirv` backends (same pipeline, different triple). Host dispatch is generated from the call site; a
GPU buffer is a channel-carried Value (`send(gpu_chan, data)` = host→device). `@gpu` annotation (or inferred
by capability analysis).

**What breaks if deferred.** The backend triples are EXTEND (add when hardware is available). But **the IR
address-space attribute and the GPU-buffer-as-Value decision are LOCK-NOW representation choices**: if the IR
is frozen with address-space-0-everywhere and the autodiff pass + optimizers assume it, adding address spaces
later touches every IR consumer. And if **Cortex builds on the current i64-handle GPU API, adding RC-managed
GPU buffers later means rewriting every tensor operation's memory management.** Reactor's shaders have the
same problem (WGSL-in-strings defeats "one language"). **Lock the IR pointer address-space attribute with L7;
lock the GPU-buffer-as-Value model before Cortex/Reactor; defer the actual nvptx/spirv lowering to the
hardware-gated phase.**

---

### LOCK-9 — Autodiff adjoint-rule table (`grad` as IR transform) · [compiler] · XL · 1/9 (Cortex, decisive)

**The decision.** `grad(f)` is a compiler IR-to-IR reverse-mode transform, not a runtime tape. The
foundational lock: **every IR arithmetic opcode must carry a registered adjoint rule** (`fadd → [1,1]`,
`fmul → [arg1, arg0]`, `fdiv → [1/arg1, -arg0/arg1²]`, …), and any NEW opcode (from L7 sized arithmetic, from
GPU lowering) must arrive WITH its adjoint or be marked non-differentiable (so `grad` rejects functions using
it with a clear error).

**Does the core accommodate it?** **NO autodiff infrastructure exists, but the IR is structurally
compatible.** The linear-block SSA-like IR supports reverse traversal; `fadd`/`fmul`/`fdiv` have standard
adjoints. The risk is a *later* GPU-kernel-lowering pass transforming the IR into a form the AD pass cannot
differentiate through — which is why the adjoint table must be locked *with* the address-space decision.

**The NOVA-way design.** Walk the forward IR in reverse topological order, emit adjoint instructions, handle
phi (gradient fan-out) / loop (reverse-iteration or checkpointing) / call (compose the adjoint). The result is
`f_grad` in the same IR that the same LLVM backend optimizes — no tape, no `requires_grad` API infection, full
cross-op fusion. Grand Plan §2.3's "first language where training is a language primitive."

**What breaks if deferred.** Cortex is the only framework that needs it, but the failure mode is decisive:
without compiler-pass AD, Cortex must implement PyTorch-style runtime-tape autodiff (per-forward tape
allocation, per-op dispatch overhead, no fusion, a `requires_grad` flag infecting every tensor operation).
Retrofitting compiler-pass AD later means redesigning the entire Cortex API and migration-breaking every
user. And the subtler lock: **a missing adjoint rule is a silent wrong-gradient bug — the worst ML failure
mode.** If the adjoint table is defined only for today's opcodes and L7/GPU opcodes are added without their
adjoints, `grad` silently produces wrong gradients. **Lock the adjoint-rule table as a compiler invariant now
(every opcode registers an adjoint or is non-differentiable); implement the transform in the hardware-gated
numeric phase.**

---

### The three representation locks that DEPEND on the above (design-lock now, implement later)

- **LOCK-10 — Const generics (L5) · depends on L7 + L2.** `NType`/`NTypeScheme` gain integer-valued
  parameters; unification gains integer-equality checking (`K == K` between matmul inner dims). **Cortex
  shape-checked tensors and Pulse schema types encode this into their public types** — if built without it,
  shape errors are runtime crashes (Python-tier) and the tensor API must be redesigned when const generics
  land. The `NType.params` list already accommodates a const-type node structurally; **reserve the
  representation now, implement after L7.**

- **LOCK-11 — Struct-by-value FFI return · depends on L7.** `ffi_llvm_type` must recognize `@repr(C)` struct
  types and emit the correct ABI (`sret` for large, register-return for small) instead of flattening to i64.
  **Prism-desktop/Reactor call `Vec2`/`Color`/`Mat4`-returning math/physics libs thousands of times per
  frame** — pointer-only FFI heap-allocates per call and breaks the C ABI. Depends on L7 for typed struct
  fields; **lock with L7, the S5 by-value ABI (`ire_s5_byval`, gated OFF) extends to FFI without redesign.**

- **LOCK-12 — Distribution wire protocol + `NodeRef` type · [runtime+lang] · L-XL · Mesh.** The Mesh wire
  format must carry **control frames (LINK/UNLINK/MONITOR/EXIT/HEARTBEAT)**, a first-class **`NodeRef` Value**
  and **remote PID** (`(node, local_pid)`), and a **TLS + cookie/mutual-auth handshake** — from day one. The
  current JSON `remote_send`/`recv` CANNOT be extended to carry these; `call_by_name` is unauthenticated RCE.
  **If Mesh builds supervision/registry on the current p2p JSON primitive, every distributed app is locked to
  a format that cannot carry the control plane, and migration breaks all distributed code.** Design the
  protocol + node-identity type NOW; the low-level `remote_send`/`recv` remain as primitives but Mesh must not
  build its supervision/registry directly on them.

---

## 4. Verdict per framework

Is the core ready to build it, or blocked on which LOCK-NOW items? "Ready" = all its LOCK-NOW prerequisites
are closed or design-locked; "blocked" lists the specific gates.

| Framework | Verdict | Blocked on (LOCK-NOW prerequisites) | Notes |
|---|---|---|---|
| **Forge** | **READY after Phase-0 hardening** | LOCK-1 (namespacing) · LOCK-3 (trait sig) · LOCK-5 (kill for graceful shutdown) · LOCK-6 (`@cdecl` for ALPN) · LOCK-7 (`@ct`/redact — already in live paths) · LOCK-2 (declarative `@route`, or ship imperative-that-desugars) | Forge already exists and works on x86_64. Its LOCK items are hardening of paths it ALREADY has (ALPN callback, kill for shutdown, const-time for its live crypto). The declarative `@route` layer must desugar to the imperative API without breaking it. |
| **Cortex** | **BLOCKED** | LOCK-4 (sized/f32 — hard block) · LOCK-10 (const generics for shapes) · LOCK-9 (autodiff adjoint table) · LOCK-8 (GPU lowering + GPU-mem-as-Value) · LOCK-3 (trait sig for `Layer`/`Optimizer`) · LOCK-2 (`@gpu`/`@differentiable`) · LOCK-1 | Most core-dependent framework. **Do NOT start Cortex's tensor API until L7 + const-generics + the adjoint-table + GPU-buffer-as-Value are at least design-locked** — every one is baked into the public tensor type. Interim: ONNX/GGUF/SafeTensors loaders serve pre-trained f32 models once L7 f32 exists. |
| **Mesh** | **BLOCKED** | LOCK-5 (kill — supervision is fiction without it) · LOCK-12 (dist wire protocol + NodeRef) · LOCK-1 · LOCK-3 · LOCK-2 (`@service`/`@rpc`) · ARM fibers (servers) | Supervision trees + remote monitors + the NodeRef type must be designed before Mesh's API. The current JSON `remote_send`/`recv` CANNOT carry control frames; `call_by_name` is unauthenticated RCE — the wire protocol + auth handshake are ABI-locked once Mesh apps ship. |
| **Prism** (web+desktop) | **BLOCKED** | LOCK-6 (`@cdecl` — desktop is dead without it) · LOCK-11 (struct-by-value FFI) · LOCK-4 (f32 for GPU/vertex) · WASM value-model link + freestanding (web) · ARM fibers (Apple Silicon) · LOCK-2 (`@component`) · LOCK-1 · LOCK-3 | Prism-web needs the WASM value-model actually linked (audit 5.3) + host-import bindings; Prism-desktop needs callbacks + struct-by-value + f32. **The single widest blocker is LOCK-6 (`@cdecl`)** — it blocks desktop entirely and is shared with Edge and Forge-ALPN. |
| **Pulse** | **BLOCKED (lighter)** | LOCK-4 (f32/u· columns) · LOCK-10 (schema/fixed-window types) · LOCK-2 (`@column`) · LOCK-1 · LOCK-3 | Once L7 + const-generics land, Pulse is mostly EXTEND (S4.2 float columns exist; SIMD is incremental). Viable relatively early after the language ceilings. |
| **Sentinel** | **BLOCKED on 3 small locks + L7** | LOCK-7 (`@ct` + `secure_zero` + `@redact` — the whole point) · LOCK-4 (sized/u· for PQ crypto; fixes `1<<64` UB) · LOCK-1 · LOCK-3 (`Cipher` trait) · LOCK-2 | LOCK-7 is S/M effort and gates all Sentinel crypto. Argon2id, HSM (via existing FFI, callback-limited), multi-cloud, ZK are EXTEND. **The 3 const-time/secret primitives are cheap and must go before any Sentinel code.** |
| **Edge** | **BLOCKED (hardest platform)** | LOCK-6 (`@cdecl` for ISRs) · LOCK-4 (register-width types) · Freestanding + MCU triples (coupled) · ARM fibers · LOCK-1 · struct-by-value FFI (sensor structs) | Needs the full freestanding runtime split + `--freestanding` capability-gating + MCU backend triples + ARM/RISC-V context switch. MMIO/volatile is EXTEND (additive volatile `ptr_*` variants). Heaviest platform lift; sequence last. |
| **Ops** | **READY after Phase-0** | LOCK-1 (namespacing to avoid Forge symbol collisions) only | **Ops has NO core blockers.** HTTP client, cloud SDKs, YAML, subprocess, channels, OTP all exist or are pure library work. Drift-as-a-channel is a natural Three-Primitives pattern. Only shares the universal LOCK-1. |
| **Reactor** | **BLOCKED (heaviest)** | LOCK-6 (`@cdecl`) · LOCK-11 (struct-by-value for physics `Vec3`) · LOCK-4 (f32) · LOCK-8 (GPU + shaders) · LOCK-5 (frame-budget preemption) · ARM fibers · LOCK-2 (`@system`/`@component` ECS) · LOCK-1 · LOCK-3 | Depends on nearly every LOCK item — the last framework, correctly sequenced in Phase 6 after Prism-desktop (F2) + GPU (F7) + image codecs (F5) mature. |

**The clean read:** **Forge and Ops are the only two ready after Phase-0 hardening** (Forge's locks are
hardening of paths it already has; Ops has essentially none). Everything else is genuinely blocked on the
representation/semantics locks — and **sized numerics (LOCK-4), `@cdecl` (LOCK-6), and the annotation hook
(LOCK-2) are the three that unblock the most frameworks at once.**

---

## 5. Revised sequencing — how LOCK-NOW slots into the Grand Plan

This **sharpens, does not replace** the Grand Plan's Phase 0-6. The insight it adds: the Grand Plan's Phase-3
language ceilings + Wave-C reach/preemption + FFI/GPU ARE the framework foundations — so the LOCK-NOW items
are the *design-lock subset* of those phases that must be settled before the corresponding framework starts.
The rule: **design-lock a representation in the phase where the Grand Plan already places its implementation,
but never START a framework before its LOCK-NOW prerequisites are at least design-locked.**

### PHASE 0 (Grand Plan: Foundation soundness) — add the design-locks that cost nothing to reserve

- Keep all of Wave A/B/C as written. **Add these framework-gating design-locks:**
  - **LOCK-3 trait-conformance signature check** — already Wave-A; a framework-gating soundness lock.
  - **LOCK-7 `@ct` + `secure_zero` + `@redact`** (S/M) — Forge's live crypto ALREADY depends on `_ct_eq`;
    Phase-0 hardening, not a Sentinel-only deferral.
  - **The IR pointer address-space attribute reservation** (part of LOCK-8) — reserve it now so the AD pass
    (LOCK-9) and optimizers are designed address-space-aware from the start. Zero framework cost to reserve.
  - **The safepoint + fiber-unwind protocol DESIGN** (LOCK-5) — the Grand Plan already starts safepoint
    preemption in Phase 0 (XL/supervised); lock the fiber-entry contract to reserve for `kill` now.

### PHASE 2 (Grand Plan: Ecosystem) — pull LOCK-1 EARLY (the universal, ABI-breaking lock)

- **LOCK-1 module namespacing (L11)** — the Grand Plan places it atop Phase 3; **this doc argues it is the
  single most irreversible item and should land as early as Phase 2, before T-Pkg**, because the resolver
  cannot function without it and every package that ships without it deepens the ABI debt. No dependencies. Do
  it with T-ABI (both are ABI-integrity locks).

### PHASE 3 (Grand Plan: Declarative multiplier) — this IS the framework-foundation phase

- **LOCK-4 sized numerics + f32 (L7)** — the widest representation change; design-lock the `NType`
  width/signed fields + promotion lattice + `elem_kind` extension + FFI `f32`/`u·`. Gates Cortex, Pulse,
  Sentinel-PQ, Reactor, Edge, Prism.
- **LOCK-2 annotations + codegen hook (L1/L2)** — BET 1. Lock the hook point + schema; Phase-1 built-in hooks
  (`@route`/`@service`/`@gpu`/`@cdecl`/`@redact`) deliver 80%.
- **LOCK-6 `@cdecl` FFI callbacks** — the calling-convention decision (blocks Prism-desktop, Edge, Forge-ALPN,
  Reactor). Depends on L7 for f32 params.
- **LOCK-10 const generics (L5)** and **LOCK-11 struct-by-value FFI** — reserve the representation with L7,
  implement after L7 + L2.
- **LOCK-9 autodiff adjoint-rule table** — lock the compiler invariant (every opcode registers an adjoint)
  here, so L7/GPU opcodes arrive with their adjoints; implement the transform in Phase 6.

### PHASE 4-6 (Presentation → domain frameworks → numeric-at-scale) — start frameworks ONLY behind their locks

- **Phase 4 Presentation:** Prism-web (needs LOCK-6 + WASM value-model link + LOCK-2) and Prism-desktop (needs
  LOCK-6 + LOCK-11 + LOCK-4) — all design-locked in Phase 3, so Phase 4 is safe.
- **Phase 5 Domain:** Forge-declarative + Ops (ready) ship first; Mesh waits on LOCK-5 (kill) + LOCK-12 (dist
  protocol); Sentinel waits on LOCK-7 (done Phase-0) + LOCK-4; Pulse on LOCK-4 + LOCK-10.
- **Phase 6 Numeric-at-scale:** LOCK-8 GPU lowering + LOCK-9 autodiff implementation (hardware-gated) → Cortex
  training; Reactor (needs every lock) + Edge (needs LOCK-6 + LOCK-4 + freestanding + ARM fibers) last.

**The one-line spine (framework-foundation view):** *Phase 0 closes soundness + reserves the address-space
attr + locks const-time/kill design → Phase 2 lands module-namespacing (the ABI lock) → Phase 3 design-locks
sized-numerics + annotations + `@cdecl` + const-generics + struct-by-val + the adjoint table (the framework
foundations) → Phases 4-6 build each framework ONLY after its locks are settled, presentation before domain
before numeric-at-scale.* No framework is ever built on a core that must change under it.

---

## 6. The reassurance and the risk

Honest and decisive means separating the parts of the core that are **safe as-is** (they EXTEND cleanly —
build on them without fear) from the parts that are **genuine lock-now risks** (defer them and a framework's
API breaks). This is the bottom line the owner needs.

### SAFE AS-IS — these EXTEND cleanly; frameworks can rely on them today (the architecture was right)

- **The Three Primitives (Values, Processes, Channels)** — every framework maps onto them without strain:
  ECS-as-Values (Reactor), drift-as-a-Channel (Ops), a live UI instance as a Process (Prism), a GPU buffer
  transfer as a channel send, CRDTs on typed channels (Mesh). No framework needs a fourth primitive. This is
  the architectural bet, and it holds.
- **The process/channel isolation model** — deep-copy-on-send gives process isolation = memory safety for
  free; it is the substrate for Mesh distribution, Forge per-request isolation, and Reactor system parallelism
  without a redesign.
- **RC + arena dual memory model** — per-request arenas (Forge), retained trees + per-frame arenas (Prism),
  streaming chunks (Pulse), deep-copy across nodes (Mesh) all work today. GPU-buffer-as-Value is the one RC
  extension (LOCK-8), but the model itself extends.
- **Whole-program HM inference + erased generics + traits** — extends to variance (inferred, additive),
  associated types (additive to traits), const generics (a new `NType` kind in the existing `params` list).
  The representation is flexible; the extensions are additive. (The ONE exception is the trait-conformance
  soundness hole — LOCK-3 — which is a *fix*, not a redesign.)
- **The text-LLVM-IR → clang backend** — inherently multi-target; new triples (nvptx/spirv/thumbv7m/riscv32)
  are table extensions, not redesigns. Backend reach is EXTEND, not LOCK.
- **The N=1 green-task scheduler** — solid and production-default; per-carrier I/O and work-stealing are
  additive runtime changes (the per-carrier deque infra already exists). Concurrency *throughput* is EXTEND.

### THE GENUINE LOCK-NOW RISKS — defer these and a framework's API breaks (must not be deferred)

1. **Sized numerics (LOCK-4)** — the widest representation change; 6 frameworks bake f32/u· into public types.
   **This is the #1 risk.** Reserve `NType` width/signed + the promotion lattice + `elem_kind` extension + FFI
   ABI NOW, before any tensor/column/vertex/register API is written.
2. **Module namespacing (LOCK-1)** — the most *irreversible* (an ABI break by construction); 9/9 frameworks;
   retrofitting invalidates every precompiled package and voids the registry. Cheap; do it early.
3. **The annotation hook point (LOCK-2)** — 8/9 frameworks; an imperative→declarative migration breaks every
   user of every sibling framework. Lock the hook + schema before any framework goes declarative (imperative
   APIs must desugar to the same calls the declarative layer emits).
4. **`kill` + safepoint protocol (LOCK-5)** — Mesh supervision and Reactor frame budgets are *fiction*
   without it, and it must be un-retrofittably designed into the fiber-unwind contract now.
5. **`@cdecl` calling convention (LOCK-6)** — per-`extern-fn` blast radius; Prism-desktop/Edge/Reactor are
   dead without it and their bindings are throw-away if built on poll-loop/shim workarounds.
6. **Const-time + `Secret<T>` primitives (LOCK-7)** — Forge's live crypto is *already* vulnerable; API-
   breaking if retrofitted onto shipped crypto. Cheap; treat as Phase-0 hardening.
7. **The IR address-space attribute + GPU-buffer-as-Value + adjoint-rule table (LOCK-8/9), and the Mesh wire
   protocol + NodeRef (LOCK-12)** — reserve the IR representation, the adjoint invariant, and the distribution
   control-plane format NOW even though implementation is later/hardware-gated, or the AD pass, Cortex's
   tensor memory model, and every Mesh distributed app must be rewritten.

**The verdict on the owner's insight.** The insight is correct and the news is good: **the architecture — the
Three Primitives, process/channel isolation, RC/arena, HM inference — is safe to build all 9 frameworks on; it
EXTENDS cleanly and does not need to change.** The risk is NOT architectural; it is a **small, bounded,
nameable set of representation and semantics locks (LOCK-1 through LOCK-12)** that must be *designed* (fields
reserved, conventions fixed, hook points chosen) before their dependent frameworks begin — even where the full
implementation lands incrementally. Lock those, in the sequence above, and NOVA can be *one language, 9
frameworks, never go back.* Defer any of the seven genuine risks and the framework built on it becomes the
upstream mistake that costs months.

---
---

# ═══════════════════════ PART III — VERIFIED GAP BACKLOG (code-verified) ═══════════════════════

---

# NOVA + Forge — Consolidated Remaining-Gaps Audit (2026-07-10)

> **What this is.** The single authoritative, code-verified list of what NOVA (the self-hosted
> compiler + C runtime + type system) and Forge (the framework on top) *still lack*, as of
> **2026-07-10**. It consolidates 9 independent domain audits (type-system, runtime/RC, performance,
> concurrency, platform, toolchain, Forge-core, Forge-lib, roadmap-crosscut), de-dupes overlapping
> claims, and drops every finding that turned out to be a stale doc claim. It is framed against the
> canonical tier model in [`CORE_GAPS_2026_07_03.md`](CORE_GAPS_2026_07_03.md).
>
> **Method.** Static verification only (grep + read at file:line depth) against
> `nova-compiler/test_programs/nova_compiler.nova` (~22k lines), `output/nova_runtime.c` (~20.9k lines),
> the `forge/*.nova` library (~560 files), CI, and design docs. No compile/run (a heavy build was in
> progress during the audit). **Every gap below is a VERIFIED real or partial gap with file:line
> evidence** — nothing here is a stale ledger claim (those are corrected in the appendix).

---

## 1. Executive summary — overall completeness

NOVA's **foundation is trustworthy and rare**: it self-hosts to a byte-identical fixpoint, the runtime
UB/UAF class (CORE_GAPS Tier 0, incl. **0.8 struct-field-leak CLOSED 2026-07-10**) is genuinely closed
and hard-asserted, the type checker is **sound by default** (Tier 1), and expressiveness (Tier 3 —
generics, traits with bounds/default-methods/dynamic-dispatch/conformance, exhaustive-match ADTs) is
**mostly already built** — the audit's original "unbuilt" tone on those was badly stale. Perf is
at/near C on the common cases (tight int loops, struct SROA default-on, built-in float reductions), and
the #1 float-array cliff (S4.2 escape-survival) is **shipped and default-on** (160×C → ~1.2-2.2×C).
Forge's HTTP/routing/middleware/OTP-supervision core is done and tested; it has 3 live DB drivers,
pure-NOVA TLS 1.3 + full crypto, a universal ORM, and ~570 KAT-gated algorithm/DS modules.

**What remains is real but bounded, and clusters in five places:** (1) a small set of **memory-SAFE RC
leaks** (closure captures, managed-field reassignment, push-of-fresh-temp, RC cycles) — none are UAF,
all are correctly tracked; (2) the **float-return-uninit codegen Heisenbug (0.11)** — the one remaining
silent-wrong-answer soundness bug; (3) **performance frontier** work gated OFF by default (native
by-value struct ABI, HOF monomorphization) plus the narrow S4.2 qualification window; (4) **platform
reach** — no ARM fibers (concurrency silently no-ops on ARM), WASM/GPU are proof-level not
productized, macOS never run against the real runtime; (5) **Forge productization** — HTTP/2+gRPC are
cleartext-only/unary-only (ALPN missing, Windows TLS-server stubbed), the type-driven `service` marquee
isn't built, distribution is a p2p protocol primitive not a mesh, and the S14-S19 productivity wave +
several DB-fidelity items (affected-row counts, binary/NUL-safety, typed decode) are unfinished.
Net honest position: **the core is production-trustworthy for Windows/Linux x86_64 single-node Forge
apps; the gaps are the frontier (ARM/browser/GPU/distribution/multi-core-throughput) and the last-mile
fidelity/leak items — not architecture flaws.**

---

## 2. Top gaps (prioritized, ~15 highest-impact REAL gaps across all domains)

Ordered by impact = severity × blast-radius, dependency-aware.

| # | Gap | Area | Severity | Effort | One-line status |
|---|-----|------|----------|--------|-----------------|
| 1 | Float-returning helper reads an UNINITIALIZED float slot → silent garbage (CORE_GAP 0.11) | Runtime/Perf/Type (S1 float ABI) | **High** | XL | REAL, open. Layout-dependent Heisenbug; `sqrt(variance)`→3e-156. The one remaining silent-wrong-answer bug. Same class as geo_bearing/atan2. |
| 2 | No ARM/aarch64 fiber context switch — green tasks/generators compiled OUT on ARM | Platform | **High** | L | REAL. `nova_asm_switch` is `#ifdef _WIN32 … #elif __x86_64__` with NO aarch64 branch and NO `#else`. `spawn`/generators silently no-op on ARM. |
| 3 | N>1 I/O throughput regresses (0.76-0.82× single-core); per-carrier I/O unbuilt | Concurrency | **High** | L | REAL. Single GLOBAL `nova_io_waiters` under `g_sched_lock`; `g_carrier_io` sharding confirmed absent. More cores = slower I/O. |
| 4 | HTTP/2 & gRPC over TLS impossible — ALPN missing from runtime | Forge-core | **High** | L | REAL. `grep -i alpn nova_runtime.c` = 0 matches. h2/gRPC exist ONLY as cleartext h2c. No browser HTTP/2, no h2-over-TLS. |
| 5 | Windows TLS *server* is a hard stub (no HTTPS on the dev's own OS) | Forge-core | **High** | L | REAL. `nova_rt_tls_listen`/`accept` return 0. TLS server exists only on Linux/macOS (OpenSSL). Dev is on Windows 10. |
| 6 | gRPC-from-types (`service`/`impl` block) NOT built — the "no .proto" marquee is absent | Forge-core | **High** | XL | REAL. `grep '"service"'` = 0, no `parse_service`. gRPC today = manual string-path `grpc_register`. Depends on interfaces + `chan T` returns. |
| 7 | `orm_exec` never returns real affected-row count for PG/MySQL | Forge-lib | **High** | M | REAL. PG/MySQL branches `return ok(0)`; no PG CommandComplete parse, no MySQL OK-packet affected_rows read. Only SQLite is correct. |
| 8 | base32/TOTP secrets (and PG DataRow, Redis RESP) NUL-truncate on a 0x00 byte | Forge-lib + Runtime | **High** | M | REAL. String-based binary paths truncate at first NUL → ~7.5% of random secrets give a wrong OTP; BYTEA/binary DB values corrupt. |
| 9 | LSP hover/completion is a regex text-scan, not the inferer | Toolchain | **High** | L | REAL. Shipped `lsp_infer_type_hint` returns literal "variable"/"number" by first RHS char; never calls `ti_infer_program_named`. Hover shows `x : variable`, not `x : int`. |
| 10 | Package manager: no transitive solver / semver / lockfile in the CLI path | Toolchain | **High** | L | REAL (partial). CLI fetches direct deps only, ignores versions, writes no `nova.lock`. A full resolver EXISTS but UNUSED in standalone `nova_pkg.nova`. Registry infra is external. |
| 11 | No preemption (cooperative-only); CPU-bound task starves its carrier; OTP restart can't kill | Concurrency | **High** | XL | REAL. `nova_rt_reschedule` yields only at park points. Blocks Reactor frame budget, true Erlang-parity supervision (zombies survive restart). |
| 12 | Closure captures leak on closure death (Stage 2 of the 0.8 fix) | Runtime/RC | Medium | M | REAL, memory-SAFE. `make_closure` stores captures raw (no rc_inc) + marks source ESCAPED; unhashed record → rc_free frees header only. |
| 13 | Trait conformance checks method name+arity only, NOT param/return TYPES | Type-system | Medium (soundness) | M | PARTIAL. `ti_check_trait_conformance` never compares signatures. A `Shape{area()->float}` is satisfied by `area()->string` → mistyped through dynamic dispatch. |
| 14 | User-enum variant match-arm payload degrades to `any` (float field reads raw IEEE bits) | Type-system | Medium (soundness) | M | REAL. `pat_ctor` binds payload to a fresh unconstrained var; `ir_match_ok_payload_stype` returns "" for non-Ok/Some. The Result/Option fix, still open for user enums. |
| 15 | RC cycles leak forever (no cycle collector, 4.7) | Runtime/RC + Concurrency | Medium | XL | REAL, memory-SAFE. No `gc_refs`/trial-deletion code; no live-object registry. `Node{nxt=self}` never reclaimed. Slow RAM leak, not a crash. |

Runner-up high-impact items that just miss the top 15: **String `==` ignores the shipped NFC/NFD
normalizers** (auth-bypass-adjacent, cross-cutting #2), **native by-value struct ABI gated OFF**
(perf #2), **remote_spawn is p2p-only, no mesh/auth/TLS** (concurrency 4.6 / Forge-core #5), and
**Linux FD_SETSIZE unguarded at fd≥1024** (concurrency 4.2, CVE-class on high-concurrency Linux).

---

## 3. Gaps by area

Within each area, ordered by severity. **PARTIAL** is marked explicitly; everything else is a REAL
(fully-open) gap. Cross-domain duplicates are merged and noted.

### 3.1 NOVA — Type system

| Gap | Verdict | Sev | Effort | Evidence (code-verified) | Next step |
|-----|---------|-----|--------|--------------------------|-----------|
| Trait conformance ignores method param/return TYPES (name+arity only) | PARTIAL | high (soundness) | M | `ti_check_trait_conformance` (nova_compiler.nova:13680-13734) checks only name (`list_contains`) + arity (`_tr_ar[rm] != _ty_ar[rm]`). No `ti_trait_method_param_types`/`ret_types` exist anywhere. `Shape{area()->float}` accepts an impl `area()->string`. | Record per-method param+return types at trait decl + impl; unify impl sig against trait sig in conformance; emit E1006-family on mismatch + negative test. |
| User-enum variant match-arm payload → fresh var → degrades to `any` (float field reads raw bits) | REAL | high (soundness) | M | ti_ side: `ti_infer_pattern` `pat_ctor` else-branch (:13139-13143) binds each payload child via `ti_define(... ti_fresh)` — NOT the recorded `nt_fn(vfield_types,...)` (:12837). IR side: `ir_match_ok_payload_stype` (:7479-7486) returns "" for any ctor ≠ Ok/Some. Same class closed for Result/Option, still open for user enums. `to_json` masks it; arithmetic/`str()` returns garbage. | ti_: in `pat_ctor` else-branch look up the variant's recorded field types and unify each binder. IR: extend the payload-stype resolver to recover user-enum struct-typed payloads. Guard with a float-payload enum test. |
| `from_json_safe<T>` validates object-ness only, not field types | PARTIAL | medium | M | `_make_from_json_safe_method` (:3511-3520) guards non-dict → err, else delegates to the silent `<T>__from_json`. Own comment (:3508) admits `{bad`→ok(defaults). `{"age":"x"}` for `User(age:int)` → `ok(User(age=0))` with no error. (`form_as<T>` DOES per-field-validate; gap is JSON-path-specific.) | Generate a validating `<T>__from_json_safe` mirroring `<T>__from_dict`'s per-field parse-and-error (parse_int_safe/parse_float_safe; missing key → err) instead of delegating. |
| Float-return uninit codegen Heisenbug (0.11) | REAL | high | XL | *(shared — see Runtime/RC #4 and Performance #4; owned there. Type-system view: it lives in the S1 float return-slot ABI.)* | See Runtime/RC #4. |
| Trait-bound check skips `any`/`var` (unresolved generic) | PARTIAL | low | S | `ti_check_bounds` (:13668-13669) `if rk=="any" or rk=="var": continue`. HM-standard (can't check an unresolved var); low risk. | Acceptable as-is. Optionally re-drive bound checks after `ti_solve` so late-resolved vars are validated. |
| Exhaustiveness silently skipped for depth>50 types + mixed/guarded patterns | PARTIAL | low | S | `ti_unify` strict path (:11015-11016) returns silently at depth>50 (documented incompleteness). `ti_check_exhaustive` fires only for pure enum/Result/Option ctors; a match mixing `pat_lit`/`pat_str`/`pat_range` sets `ex_is_enum=false` (:13182) and does no check; guards not modeled. | Low priority. Document the depth-50 bound; non-enum exhaustiveness is intentionally unchecked. |
| No Zig-style comptime / compile-time execution (3.4) | REAL | low | L | grep `comptime` → only const-fn-eval (:17934, :21863) + `ti_const_eval`/`static_assert`. No general engine. Ledger marks 3.4 explicitly OPTIONAL. | Optional; defer. If pursued, a bounded AST interpreter gated by `ce_budget_ok`. Not on the critical path. |

### 3.2 NOVA — Runtime & reference counting

The Tier-0 UB/UAF class is genuinely closed and hard-asserted (see appendix). What remains is a tight
cluster of memory-SAFE leaks + the one float codegen wrong-answer bug + the known scalar limits.

| Gap | Verdict | Sev | Effort | Evidence (code-verified) | Next step |
|-----|---------|-----|--------|--------------------------|-----------|
| **Float-return reads an UNINITIALIZED float slot → garbage (CORE_GAP 0.11)** | REAL | high | XL | `_floatret_uninit_test.nova` preserves the repro CI-safely (always exit 0): `stddev(xs)=sqrt(variance(xs))`→~3.08e-156 not sqrt(2), cascading Pearson r→inf. Two tells it is an uninitialized READ: `variance(xs)` prints 2.0 the line before; a `print` inside the helper fixes it (layout shift). The documented let-binding workaround does NOT fix this instance. Same class as geo_bearing/atan2 (`reference_nova_float_codegen_geo_bearing`). **Cross-domain: also owned by Performance #4 and Type-system.** | Dedicated codegen session: LLVM-IR diff working-vs-garbage layouts; zero-init or correctly wire the float return slot (S1 float ABI). Needs a reliable minimal repro (extraction masks it). |
| Closure captures leak on closure death (Stage 2 of 0.8) | REAL | medium | M | `make_closure` (nova_compiler.nova:17005-17028) allocates via `nova_rt_struct_alloc` (NOT hashed), stores each capture with a bare `store i64` (**no `nova_rt_inc`**, :17020), and marks each source slot ESCAPED (:17025) so W5b never drops it. Unhashed → `nova_rc_free` pre-switch struct block (nova_runtime.c:9867) frees header only. `_closure_capture_leak_test.nova` (sibling=2001, frame=4000). Memory-SAFE. | Route make_closure through hashed-alloc + a capture managed-slot bitmap (or trampoline→bitmap map) so rc_free dec's boxed captures; then relax the escape-mark. |
| push(container, freshHeapValue) leaks the element's creation ref | REAL | medium | M | `nova_rt_list_append` (nova_runtime.c:1442-1459) + `nova_rt_dict_set` (:2529) ALWAYS `nova_rc_inc(elem)` on insert (:1457). A fresh element at rc=1 pushed → rc=2, creation ref never dropped (no MOVE-on-insert). `push(list,[k,k])` in a loop leaks the inner list (pre-existing; gen3 too). `_no_rc` fast paths were DISABLED as part of the 0.10 fix (:1509-1526, :2576). | MOVE-on-insert: borrow-provenance bit → skip the insert-inc when the arg is a proven fresh temp (same analysis Stage 1/2 of RC completeness needs). |
| Managed struct-field REASSIGNMENT leaks the old value | REAL | low | M | `nova_rt_field_set` (nova_runtime.c:15888-15912) is inc-NEW only — deliberately does NOT dec-old (comment :15896-15905): NOVA field reads are borrow-based, so `saved=obj.f; obj.f=new; obj.f=saved` holds a live borrow; dec-old freed it under the borrow (a self-compile UAF the reconverge caught). Pinned by `_struct_field_reassign_test.nova` (UAF-safe + delta ~2000, not 0). | field_get-inc / borrow tracking (owning field reads with dec-on-drop) so dec-old becomes sound. Shares the root with push #3. |
| RC cycles leak forever (4.7) | REAL | medium | XL (supervised) | *(shared — see Concurrency 4.7; owned there.)* No `gc_refs`/cycle-collector code exists in `nova_runtime.c`; `_cycle_leak.nova` = 1000× `Node{nxt=self}` → struct count 1000 / 32000 bytes still-live at exit. No live-object registry to drive trial-deletion. Slow RAM leak, not a crash. | See Concurrency 4.7 (opt-in CPython-style trial-deletion collector). |
| Mixed int/float comparison promotion incomplete | PARTIAL | low | M | Compare codegen DOES emit `sitofp` promotion, but only when the register-type pass tags an operand "L"/"R" (nova_compiler.nova:16311-16316). Where the pass fails to mark float-var-vs-int-literal, no promotion. `max`/`min` explicitly lack it (comment :15051; `nova_rt_fmax/fmin` selected only when BOTH operands are static float, :15053). `reference_nova_float_int_compare_unsound`: float VAR vs INT value can read as always-true (found in forge_aabb). Workaround: `intExpr*1.0`. | Make the register-type pass insert an unconditional promotion whenever exactly one operand is float across ALL numeric ops (compare + max/min/abs). |
| Scalar `1<<64` / shift ≥ 64 is UB | REAL | low | S | Shift codegen (nova_compiler.nova:16463) emits bare `shl i64` with no guard for amount ≥ 64. LLVM `shl` by ≥ bitwidth is poison/UB. `reference_nova_shift64_broken`: `1<<64`→0xFFFFFFFF, not 0. | Clamp/guard in codegen (`amt>=64 ? 0 : shl`) or a runtime `nova_rt_shl`. |
| String NUL-truncation for binary data | REAL | low | M | Runtime string ops use C-string `strlen` (nova_runtime.c:140,148 + `nova_str_slice` paths), so an embedded `chr(0)` truncates at the first NUL. `"A"+chr(0)+"B"` has len 2. `reference_nova_string_nul_truncation`; latent in forge_totp/base32/redis (**see Forge-lib #2/#3/#9**). | By-design for fat-strings (strlen-based C interop is pervasive). Document; steer binary to `bytes`. |

### 3.3 NOVA — Performance

Perf is at/near C on the common cases and the #1 float-array cliff is closed default-on. The residuals
are bounded feature-frontier work, mostly gated OFF by default.

| Gap | Verdict | Sev | Effort | Evidence (code-verified) | Next step |
|-----|---------|-----|--------|--------------------------|-----------|
| S4.2 escape-versioner has a narrow qualification window — code outside it hits the boxed ~160×C path | PARTIAL | high | L | `s4_versioning` (nova_compiler.nova:10361) qualifies only when `xs` is not mutated in the loop (`s4_s_mutates==0`), not passed to a fn INSIDE the loop (`s4_s_escapes==0`, :10382), and DID escape before the loop (:10385). So `for x in xs: acc = acc + process(xs, x)` (array re-passed inside the read loop — very common) does NOT qualify → boxed `nova_rt_index_get`. Even when it fires, per-element `list_get_f` doesn't vectorize → ~1.2-2.2×C (S4_TYPED_ARRAYS_DESIGN.md:342), not full parity. | Broaden qualification to N accumulators + loops passing `xs` to a provably-non-mutating callee (`ir_escape_summaries` exists); and/or a sound `floatlist ⟹ kind==2` invariant so a typed read is an unguarded raw `load double` (removes the per-read call + enables vectorization). |
| Cross-function struct math capped ~1.0-1.2×C — native by-value struct ABI gated OFF | PARTIAL | medium | L | Uniform i64 ABI → a struct across a fn boundary is a heap `i64*` (no register-split/SROA across the call). The fix (`NOVA_S5_ABI`, `@f(double,double)`) is designed (SROA_NATIVE_ABI_S15_DESIGN.md) + partly implemented (`ire_s5_byval`/`ire_s5_struct_ptr` :15971, call-site scalarization :16691-16731) but **default-OFF**: nova_compiler.nova:19121-19122 `do_s5abi = env("NOVA_S5_ABI")=="1"`. OFF → byte-identical i64. Non-escaping single-fn struct math IS at parity (SROA default-on). | Finish the design's 5-edit sound version (use-set eligibility + global address-taken guard — the naive 4-edit version is unsound); reconverge + both-mode regression; flip default-on. |
| HOF/closure arithmetic stays fully dynamic — monomorphization gated OFF | PARTIAL | medium | XL | `map`/`filter`/`reduce`/`pmap` callback bodies use runtime dispatch (~50-100ns/op). The S5 HOF-monomorph path exists (nova_compiler.nova:15749-15791, harvest table `_s5_tramp_map` :19046) but **default-OFF**: :19047-19048 `NOVA_S5_HOF=="1"`. So `map(nums, fn(x) x*x)` still lowers to `nova_rt_mul`. ~2× on trivial bodies; vanishes for heavy bodies. The `ti_fn_param_types→fpt` shortcut was reverted as unsound (corrupted float callers). | Validate the gated path against float-caller soundness (the class that broke the shortcut), extend to non-inline closures via whole-program use-set, flip default-on. Low priority vs the two above. |
| Float-return uninit Heisenbug (0.11) | REAL | high | XL | *(shared — owned in Runtime/RC #4; a perf-domain-adjacent S1 float-ABI bug.)* | See Runtime/RC. |

### 3.4 NOVA — Concurrency

The N=1 green-task runtime is solid and is the production default; N>1 is **correctness-gated** (CI green
at N=4/8, N=1 byte-identical). The open Tier-4 gaps are throughput, preemption, cycles, distribution.

| Gap | Verdict | Sev | Effort | Evidence (code-verified) | Next step |
|-----|---------|-----|--------|--------------------------|-----------|
| N>1 I/O throughput regresses (0.76-0.82× single-core); per-carrier I/O unbuilt (4.1) | REAL | high | L | `nova_sched_park_io_ex` (nova_runtime.c:6321) links every waiter onto the single GLOBAL `nova_io_waiters` under `nova_sched_lock()` (:6331,:6347); `nova_sched_poll_io` (:6440) drains it under the same lock. grep `g_carrier_io`/`nova_carrier_io` = **0 matches** → sharding absent (PER_CARRIER_IO_DESIGN.md = DESIGN ONLY). Single-poller mode is still a single-thread funnel on `g_sched_lock`. | Implement PC-1 (shard `nova_io_waiters` into `g_carrier_io[NCAR]`, per-carrier poll incl. timed-io) + PC-2 (pin handler to accepting carrier), with RC-1/RC-2 prereqs; gated session; re-measure keep-alive /ping at N=1/4/8. |
| No preemption (cooperative-only); CPU-bound task starves its carrier; OTP restart can't kill (4.4) | REAL | high | XL | `nova_runtime.c:6275` "signal-based preemption is post-v1"; `nova_rt_reschedule` (:6276) yields only if `in_task` — a tight loop hitting no park point never yields (by design, for the C-speed promise). `forge_otp.nova:113`: "NOVA has no preemptive kill — 'restart' = spawn a fresh instance; a healthy sibling is NOT stopped." Blocks Reactor frame budget + Erlang-parity supervision (zombies). | Design signal (SIGURG/timer) or safepoint preemption + a runtime linked-exit/kill primitive; XL, supervised (safepoint insertion interacts with the value model + fiber stacks). Interim: document `reschedule()` discipline. |
| remote_spawn is client-side RPC-by-name only; full distribution + auth/TLS unbuilt (4.6) | PARTIAL | high | L-XL | `nova_rt_remote_spawn` (nova_runtime.c:11649) is NOT a null stub — sends `[name,args]` via `remote_send`, returns the channel; caller hand-writes the peer dispatch loop. But DISTRIBUTION_DESIGN.md model is unbuilt (grep `node_connect|node_registry|remote_pid|router|heartbeat` → only an unrelated `node_id`); `forge_dist.nova` = protocol layer only ("LIVE 2-node link deferred"). **Security:** `remote_send`/`recv` (:11608/:11623) are length-prefixed JSON over raw TCP, **unauthenticated + non-TLS**; + `call_by_name` (:16034) = unauthenticated remote-code-by-registered-name; `remote_recv` mallocs attacker-controlled `len+1` (64MB cap, repeatable). **Merged with Forge-core #5.** | Build fn-id registry + node link manager + router (pid demux) + cross-node DOWN + heartbeats; ADD a link auth handshake + optional TLS before any "production distributed" claim; gate on the 2-process kill-and-DOWN test. |
| RC cycles leak forever (4.7) | REAL | medium | XL (supervised) | grep `gc_refs|cycle_collect|trial.delet|tp_clear|collect_cycles|mark.*sweep` = **0 matches**. RC only; `_cycle_leak.nova` (1000× `Node{nxt=self}`) → 32000 bytes still-live at exit. No live-object registry (heap profiler tracks COUNTS only). **Merged with Runtime/RC #5.** | Opt-in CPython-style trial-deletion collector (per-object gc_refs, subtract internal refs via the existing per-type child enumeration in `nova_rc_free`, free the unreachable set); gated + adversarial-validated before any reconverge. |
| Linux FD_SETSIZE / fd≥1024 `select()` corruption (Windows raised to 4096; Linux unguarded) (4.2) | PARTIAL | medium | M | `nova_runtime.c:27` `#define FD_SETSIZE 4096` is inside `#ifdef _WIN32` (:22) — works on Windows (array-shaped fd_set). On Linux/glibc `fd_set` is a fixed 1024-bit bitmap; `#define` does NOT resize it; `nova_sched_poll_io` (:6493) `select(maxfd+1,...)` + `FD_SET(w->fd,&rfds)` (:6474) with no `fd < FD_SETSIZE` check → ≥1024 connections write past the bitmap = stack corruption (CVE-class). Windows N=1 default not hit today; high-concurrency Linux unsafe. | Move the Linux netpoller to `poll`/`epoll` (no FD_SETSIZE limit), OR add a hard `if (fd >= FD_SETSIZE) reject/fallback` on every POSIX `FD_SET`. Folds into Tier 5 Linux reach + macOS kqueue. |
| Cross-carrier wake spins on `park_committed` while holding `ch->lock` (latent; benign under pinning) (4.3) | PARTIAL | medium | M | `nova_sched_wake_one` (:6281) + `nova_sched_wake_send_one` (:6301) do `while(!t->park_committed){ spin }` at N>1 (:6296,:6309), called from `nova_rt_channel_send` while `ch->lock` is held (:4862,:4897,:4911). Under current no-migration pinning it's a guaranteed near-instant no-op (home carrier set the flag first), so no deadlock today — but a busy-spin under a channel lock and a live hazard if work-stealing/migration is re-introduced. | Track as latent hazard tied to the work-stealing plan; if migration/stealing is ever re-enabled, land the deferred-wake fix (pop-under-lock, spin+enqueue after `ch->lock` release) FIRST. No action while pinned + steal-free. |
| N>1 fiber load-imbalance (no work-stealing) — bounded residual | PARTIAL | low | L | Task-slot reclaim is ON by default at N>1 (nova_runtime.c:7511), bounding the slot pool. But NO work-stealing (per-carrier deque Stage A exists; Stage B/C push-to-local + steal reverted for lost-wakeup at N=4) → a task pinned to a busy carrier can't migrate to an idle one; skewed load leaves cores idle. | Only if N>1 becomes a production target: complete MN_PER_CARRIER_DEQUE Stages B-D on top of pinning, each gated on green_scale N=4/8 + ASAN + clean watchdog exit. N=1 is production today. |

### 3.5 NOVA — Platform reach ("runs anywhere")

Verified reach = **Windows x86_64 (first-class) + Linux x86_64 (real: cross-compile pipeline + 40/40
sweep + 10k-task scheduler)**. The Tier-5 ledger is ACCURATE here (not over-pessimistic like Tiers 0/1/3).

| Gap | Verdict | Sev | Effort | Evidence (code-verified) | Next step |
|-----|---------|-----|--------|--------------------------|-----------|
| No ARM/aarch64 fiber context switch — green tasks/generators compiled OUT on ARM (5.1) | REAL | high | L | Fiber block: `nova_runtime.c:5517` `#ifdef _WIN32` (CreateFiber), `:5707` `#elif defined(__x86_64__)` (POSIX naked-asm `nova_asm_switch`). **NO `#elif __aarch64__` and NO `#else` before `#endif`** → on aarch64 `nova_asm_switch`, `nova_rt_fiber_create/resume/yield`, trampoline are ABSENT. `nova_rt_arch_name` (:15821) reports "arm64" but nothing implements the switch. `spawn`/generators silently no-op on ARM. | Add an aarch64 `nova_asm_switch` (save x19-x30 + sp + fp, swap sp) mirroring x86_64 + an aarch64 fiber-create stack layout. Needs an ARM host (Apple Silicon / Linux aarch64). |
| `nova build --target wasm` does NOT link the C value-model runtime (5.3) | PARTIAL | high | XL | nova_compiler.nova:22441-22444 wasm link line: `clang --target=wasm32 … -nostdlib -Wl,--no-entry --export=nova_user_main --allow-undefined <prog.wasm.ll>` — links NO runtime object, `--allow-undefined`, ships JS loader `_wasm_runtime.cjs`. The full C value-model wasm runtime (`nova_runtime_wasm.c`) is compiled+linked ONLY by the standalone `_wasm_vm_one.sh`, never by the built-in command → strings/lists/dicts stub to `()=>0n` unless run through the ad-hoc script. | Wire `nova build --target wasm` to compile+link `nova_runtime_wasm.o` (as `_wasm_vm_one.sh` does) → self-contained wasm. Then a real DOM/reactive stdlib + headless-browser CI. |
| GPU is one hardcoded OpenCL `vadd` + 4 CPU-loop named kernels — no kernel-lowering path (5.4) | REAL | medium | XL | `nova_runtime.c:20622` `g_gpu_vadd_src` = one hardcoded `__kernel void vadd`; :20694 the only `clCreateKernel`. `nova_rt_gpu_kernel_run` (:20227) dispatches by string name to CPU `for` loops (scale2/square/add1/negate, :20237-20240) — "Real device dispatch is future." Compiler only types `gpu_kernel_run` as opaque (nova_compiler.nova:5951,:11864); no `@gpu`, no SPIR-V/PTX. | Design NOVA→GPU kernel lowering (annotate fn as kernel → emit SPIR-V/PTX via LLVM nvptx/spir; generate clCreateProgramWithSource/Kernel glue). Needs GPU hardware. |
| macOS never run against the self-hosted runtime; cross-platform CI stale (builds dead Kotlin compiler) (5.2/5.6) | PARTIAL | medium | M | `.github/workflows/cross-platform.yml` linux-test (:44) + macos-test (:175) run `./gradlew fatJar` + `java -jar …all.jar` = the historical Kotlin bootstrap CLAUDE.md says is NOT the live compiler. So Linux/macOS CI exercises the dead interpreter, never `nova_compiler.nova` or its runtime's platform paths. `macos-latest` is Apple-Silicon (ARM) — and P1 means real fibers are absent on ARM anyway. No epoll→kqueue: poller (nova_runtime.c:19606) is Linux-`epoll` only. | Rewrite Linux/macOS CI to build+run the self-hosted compiler (ship a prebuilt bootstrap or clang-build), run the real regression; add a macOS `kqueue` poller branch. |
| Embedded / no_std / true freestanding = only the wasm value-model carve (5.5-leaf) | REAL | low | XL | The only freestanding path is `NOVA_FREESTANDING` in `nova_runtime_wasm.c` (bump allocator, no libc), targeting wasm32 in a JS host — not a real MCU (no interrupt model, MMIO, static-memory budget, `thumbv7`/`riscv32` in `resolve_target`; nova_compiler.nova:15904 emits only x86_64/wasm32/aarch64 triples). ~285 other `malloc`s + sockets/threads/printf are unconditionally linked. **Merged with Cross-cutting #5.** | Post-MVP: reuse `NOVA_FREESTANDING` as the seed for a `thumbv7m`/`riscv32` bare-metal target (static arena, no scheduler, MMIO via ptr_read/write); capability-gate non-freestanding builtins at type-check under `--freestanding`. Needs hardware/QEMU. |

### 3.6 NOVA — Toolchain & developer experience

The build side (`nova build` incremental + cross-compile + LTO, `nova fmt` AST-reprint, check/lint/cov/
bench/eval/wasm) is genuinely strong. The interactive/DevX side is weaker than memory claims.

| Gap | Verdict | Sev | Effort | Evidence (code-verified) | Next step |
|-----|---------|-----|--------|--------------------------|-----------|
| Shipped LSP hover/completion is a regex text-scan, not the inferer | REAL | high | L | `lsp_infer_type_hint` (nova_compiler.nova:21537) does a lexical line scan returning literal "number"/"variable"/"list"/"dict"/"bool" by first RHS char — never calls `ti_infer_program_named`. `lsp_get_completions` (:21647) scans `fn `/`type ` prefixes, no types, not context-aware. The extension launches THIS (`extension.ts:22 args:['lsp']`); the Kotlin `LspAnalyzer.kt` (which memory's v0.2.0 upgrades targeted) is dead code. Hover a local → `x : variable`, not `x : int`. | Route hover/completion through the same `ti_infer_program_named` result the diagnostics path already builds; look up inferred type at cursor from the node-type map. |
| Package manager: no transitive solver / semver / lockfile in the CLI path | REAL | high | L | CLI install/get → `nova_pkg_install`/`nova_pkg_get` (nova_compiler.nova:21357/:21376). `nova_pkg_install` iterates ONLY `nova.toml` direct deps; a package's own `[dependencies]` are never recursed; `nova_pkg_download` (:21319) takes `pkg_version` but NEVER uses it; no `nova.lock` written; registry targets an unpopulated repo. A FULL transitive+semver+lockfile+integrity resolver EXISTS but UNUSED in standalone `nova_pkg.nova` (`resolve` ~:261, `write_lockfile` :360, `semver_satisfies` :78). **= CORE_GAPS 6.1.** | Wire CLI install/get to `nova_pkg.nova`'s resolver (transitive recursion + visited-set + semver intersection + `nova.lock`). The registry itself is external infra → supervised. |
| LSP missing signatureHelp / inlayHint / references / rename / semanticTokens | REAL | medium | L | `initialize` reply (nova_compiler.nova:21691) advertises ONLY hover/definition/completion/diagnostic/textDocumentSync. grep `signatureHelp|inlayHint|references|rename|semanticTokens` → NO LSP handlers in the shipped server. Memory marks signature-help + inlay-hints "DONE" — true only of the DEAD Kotlin server. | Add the providers to initialize caps + the `textDocument/*` branches in `lsp_server_main`, backed by the inferer + an AST ident-walk for refs/rename. |
| `nova repl` is dev-tree-only and recompiles the whole session per line | PARTIAL | high | M | `repl.nova:146` hard-codes `exec(".\\gen3_test.exe repl_session.nova")` + :154 clang-links against `output\nova_runtime.c` → only works from `test_programs/` with `gen3_test.exe` present. Every line rewrites the full session + relinks via clang (O(session)/line); no readline/history. A tree-walking `eval_expr` interpreter EXISTS (:21788, backs `nova eval`) but the REPL doesn't use it. | Resolve the compiler via `arguments[0]`/`NOVA_HOME` (not `.\gen3_test.exe`); back interactive eval with `eval_expr` (instant, no per-line clang), full-compile fallback only when the interpreter can't handle it. |
| `nova debug` (CLI) has no interactive stepping despite its banner | PARTIAL | medium | M | nova_compiler.nova:22329-22354: compiles `NOVA_DBG=1` at -O0 + DWARF, prints "NOVA interactive debugger" with s/n/o/c/bt/p/bp/q, then the final stmt is `exit(system(<exe>))` — runs to completion. NO command REPL, no ptrace/lldb driver, no breakpoint loop. Real debugging exists ONLY in VS Code via DAP handoff to external `lldb-dap` (extension.ts:65-95; DWARF vars `ire_dwarf_local` :15996). | Drive `lldb`/`lldb-dap` from the CLI to honor the banner, OR replace the banner with an accurate "compiled with debug info; open in VS Code or run under lldb". |
| Onboarding: no real quickstart / ONBOARDING.md; GETTING_STARTED has a stale build line | PARTIAL | low | S | `GETTING_STARTED.md:9-13` shows `nova --version` with no acquisition/build steps; the compile example (`nova hello.nova` then manual `clang -O2 … nova_runtime.c`) predates `nova build`/`nova run`. CORE_GAPS 6.5 flags the broader onboarding polish as still not done. | Rewrite the quickstart around `nova build`/`nova run`; add ONBOARDING.md covering install + first full-stack app; drop the manual-clang path from the beginner flow. |

### 3.7 Forge — Framework core

HTTP/routing/middleware/OTP-supervision core is done and tested. The REAL gaps cluster in HTTP/2+gRPC
transport, the type-driven `service` marquee, distribution, and the untested S14-S19 productivity wave.

| Gap | Verdict | Sev | Effort | Evidence (code-verified) | Next step |
|-----|---------|-----|--------|--------------------------|-----------|
| HTTP/2 & gRPC over TLS impossible — ALPN missing from runtime | REAL | high | L | `grep -i alpn nova_runtime.c` → **0 matches**. HTTP2_PLAN.md D2.1 (the one runtime dep) unbuilt. h2/gRPC exist ONLY as cleartext h2c (`serve_h2c`, `serve_grpc_h2c`). | Add ALPN offer/select to the TLS accept path (OpenSSL `SSL_CTX_set_alpn_select_cb`; SChannel equivalent); expose `nova_rt_tls_alpn_selected`; gate under full nova_ci. |
| Windows TLS server is a hard stub (no HTTPS on the dev's own OS) | REAL | high | L | `nova_runtime.c:18848-18853`: `nova_rt_tls_listen` returns 0 ("TLS server not implemented — needs cert provisioning"), `nova_rt_tls_accept` = `{ return 0; }`. Real TLS server exists only on Linux/macOS via OpenSSL (:19087+). Dev is on Windows 10. | Implement SChannel server-side handshake (`AcceptSecurityContext` loop) mirroring the OpenSSL path + cert loading. |
| gRPC is unary-only — no server/client/bidi streaming | PARTIAL | high | L | `forge_grpc.nova:197` "Streaming RPCs are future work; this layer is unary-only." `grpc_dispatch` = one framed msg → one reply. No stream shapes anywhere. | Build stream dispatch over the h2 DATA-frame loop (`_grpc_h2c_conn`); map channel directionality to the 3 stream shapes; needs per-stream flow-control. |
| gRPC-from-types (`service`/`impl` block) NOT built — the "no .proto" beat is absent | REAL | high | XL | `grep '"service"' nova_compiler.nova` → **0 matches**; no `parse_service`. FORGE_STATUS §7 marquee (`service Orders {...}`) requires interfaces #8 + `chan T` returns. gRPC today = manual `grpc_register(m,"/pkg.Svc/Method",h)`. | Design `service`/`impl` top-level syntax on the existing trait/impl parser (`parse_trait_decl` :2791); lower to a codegen'd service map + protobuf codec from struct RTTI. |
| remote_spawn = p2p protocol only; no production distribution | PARTIAL | high | XL | *(merged with Concurrency 4.6.)* `forge_dist.nova` = registry + JSON encode/decode only ("LIVE 2-node link deferred"). Runtime `nova_rt_remote_spawn` (:11649) is real but needs a pre-existing `conn` channel. No mesh/gossip/global-registry/remote-monitor; unauthenticated + non-TLS. | See Concurrency 4.6: live node link + cross-node DOWN + mesh membership + global registry + auth/TLS. |
| Plain HTTP/2 server serves ONE stream per connection (no real multiplex) | PARTIAL | medium | M | `forge_h2_server.nova:187` `_h2c_serve_conn`: `if served >= 1: alive = false` — closes after the first HEADERS/DATA exchange ("multi-stream is a follow-up"). | Replace the single-stream loop with a per-stream state map keyed by stream_id; interleave concurrent streams on the netpoller. |
| S14-S19 productivity wave (config/DI, declarative tx/cache/retry/schedule, template, event bus, i18n, test harness, method-security) — code exists, ZERO functionally tested | PARTIAL | medium | L | Modules present (`forge_config`/`forge_aspects`/`forge_repo`/`forge_template`/`forge_forms`/`forge_events`/`forge_i18n`/`forge_test`) but `grep _run_final_regression.ps1` for any of their `_test` names → **0 matches** (only grpc/h2c tests). "gen3 syntax-checked, functional tests deferred." | Write functional `*_test.nova` for each; register in `_run_final_regression.ps1`; run both RC modes; flip DEV_TRACK rows to tested. |
| Spring/Django "batteries" depth (declarative `@Transactional` propagation, method-level security, derived queries, entity auditing, soft-deletes, test factories/DB-rollback) | PARTIAL | medium | XL | FORGE_FEATURE_AUDIT §B/D/E/F/G/H/K mark these 🟡/❌; `with tx{}` blocked (`with` taken by another construct). Template engine now a 61-line unproven module. | Sequence per FEATURE_AUDIT: P0 config+profiles+DI + declarative tx w/ propagation + method cache; P1 template + event bus + i18n + test harness. Each needs a functional test to count as shipped. |
| GraphQL/gRPC-over-WebSocket subscriptions = codec only, not wired to a live subscribe→push loop | PARTIAL | low | M | `forge_graphql_ws.nova:20` "This module is the CODEC only." Needs pairing with ws server + `gql_execute_limited_vars` + hub — not a shipped/tested end-to-end path. | Wire the graphql-ws codec to `ws_room` + a hub topic; on publish, run resolver and push `next`; add an end-to-end test. |
| Trait/interface dispatch uses djb2 name-hash — latent hash-collision mis-dispatch | PARTIAL | low | M | `type_name_hash` (nova_compiler.nova:7374) = djb2; match ctor arms compare `type_name_hash(pv)` vs `field_get __type_hash` (:9387,:9669). Two distinct struct names colliding → wrong arm. Traits/impl parse + dispatch DO exist; collision-handling soundness unverified. **Related to Type-system trait-conformance gap.** | Verify/repro collision behavior; if real, switch to a monotonic per-type interned id, or add a secondary name compare on hash match. |

### 3.8 Forge — Libraries (DB / crypto / serialization / HTTP)

Broad and battle-tested (3 live DB drivers, pure-NOVA TLS 1.3 + crypto, universal ORM). Most memory
"gap" claims are STALE (see appendix). REAL gaps cluster in DB write-result fidelity, binary/NUL-safety,
and typed-decode/full-auth completeness.

| Gap | Verdict | Sev | Effort | Evidence (code-verified) | Next step |
|-----|---------|-----|--------|--------------------------|-----------|
| `orm_exec` never returns real affected-row count for PG/MySQL | REAL | high | M | `forge/forge_orm.nova:264` PG branch `return ok(0)`; :270/:274 MySQL `return ok(0)`. Only SQLite (:258) returns `db_affected(c)`. PG never parses CommandComplete ('C', no `_pg_parse_complete`); MySQL never reads the OK-packet `affected_rows` lenenc. | Parse PG CommandComplete tag suffix ("UPDATE 3"→3, "INSERT 0 5"→5) in `pg_query_params`; read MySQL OK-packet affected_rows; thread up through `orm_exec`. |
| base32 / TOTP secrets NUL-truncate on a 0x00 byte | REAL | high | M | `forge/forge_base32.nova:38-62` `base32_decode` builds `out = out + chr(...)` (string); no bytes variant. `forge/forge_totp.nova:11` `_totp_key` calls `base32_decode` then `char_at`; :76-83 `totp_secret` builds `s = s + chr(bytes_get(b,i))`. Per `reference_nova_string_nul_truncation` a `chr(0)` truncates → wrong HMAC key. ~7.5% of random 20-byte secrets contain a 0x00 → wrong OTP. **Same class as Runtime NUL-truncation.** | Add `base32_decode_bytes`/`base32_encode_bytes` over a byte list; make `_totp_key`/`totp_secret` byte-based end-to-end (never round-trip a binary secret through a NOVA string). |
| PG DataRow NUL-truncates binary values + can't distinguish NULL from "" | PARTIAL | high | M | `forge/forge_pg.nova:84-103` `pg_parse_data_row` builds `s = s + chr(bytes_get(b, p+j))` → BYTEA/text-with-0x00 truncates. :82 comment: `"" for SQL NULL` — SQL NULL and empty-string both return `""`, indistinguishable. | Return column values as byte lists (or a bytes-carrying dict) to preserve binary; carry a distinct NULL sentinel (not `""`). |
| MySQL 8.x caching_sha2 cold-cache full auth (0x04) unimplemented — blocked on missing RSA-OAEP | REAL | medium | L | `forge/forge_mysql.nova:248` returns `err("caching_sha2 full authentication required — needs TLS or RSA")`; only the 0x03 fast-path works. `forge/forge_rsa.nova` has only verify (`rsa_pkcs1_sha256_verify` :68, `rsa_pss_sha256_verify` :144) — NO OAEP/encrypt. Cold-cache 8.x connect requires priming or a native_password account. | Implement RSA-OAEP encrypt in forge_rsa (encrypt the scrambled password to the server pubkey), OR route full-auth over the existing `nova_rt_tls_upgrade` TLS transport. |
| No statement/connection timeout in any DB driver (primitive exists, unused) | PARTIAL | medium | M | `nova_runtime.c:11475 nova_rt_tcp_wait_readable(fd, timeout_ms)` exists, but grep `timeout|deadline|reconnect|health` in forge_pg.nova/forge_mysql.nova → **0 matches**. Both loop on blocking `tcp_recv_bytes` with no deadline → a stalled server hangs the green task indefinitely; no health-check/reconnect. | Add a per-call timeout that calls `tcp_wait_readable(fd, ms)` before each `tcp_recv_bytes`; `err("timeout")` on expiry; pool health-check/reconnect on a dead conn. |
| MySQL FLOAT/DOUBLE/DATE binary decode returns "" (undecoded) | REAL | medium | S | `forge/forge_mysql.nova:334-346` `_my_bin_val`: `t==4` (FLOAT)→`["", off+4]`, `t==5` (DOUBLE)→`["", off+8]`; DATE/TIME fall through to lenenc-string (wrong). Only reached via prepared/parameterized (binary protocol). | Decode IEEE-754 LE 4/8-byte floats to a decimal string; decode the MySQL binary DATE/DATETIME/TIME layout to ISO. |
| Raw PG driver cannot bind a NULL param (ORM works around via literal-NULL text rewrite) | PARTIAL | medium | S | `forge/forge_pg.nova:429-441` `_pg_bind_msg` always emits `pg_be32(bytes_len(pb))` — never the `-1` NULL length (comment :456-457). ORM papers over it: `orm_null()` (:79) + `_orm_apply_nulls` (:85) rewrite each `?`-bound `orm_null()` into a literal SQL `NULL`. Functional but text-substitution, not a real bind. | Make `_pg_bind_msg` accept a NULL sentinel per-param and emit int32 `-1` (no bytes); then `orm_null()` flows as a true bound NULL. |
| No PG type-OID decoding — all values are text, typing is struct-field-driven only | PARTIAL | low | M | `forge/forge_pg.nova:420-425` sends `pg_be16(0)` param OIDs (server infers) + Bind requests "all text"; RowDescription type-OID parsed for names only. No native decode of arrays/json/jsonb/timestamp/numeric/uuid/bytea; ORM coerces text by struct field type. | If richer typing is wanted, request binary result format for known OIDs and decode; otherwise document text-only as the intended boundary (struct-driven coercion is arguably sufficient). |
| Redis RESP bulk strings NUL-truncate on binary values | PARTIAL | low | S | `forge/forge_redis.nova:11/25/38` parse RESP with `char_at`/`chr(13)` string ops; bulk-string values assembled as NOVA strings → a value with 0x00 truncates. **Same class as base32/PG-DataRow.** Fine for text, broken for binary. | Assemble RESP bulk strings as byte lists; keep a string convenience wrapper for text. |

### 3.9 Cross-cutting

Items no single domain owns — roadmap/serialization/RTTI/normalization/ABI. The roadmap/feature docs
here are overwhelmingly stale (RTTI, from_json, reflection, serialization all shipped — see appendix).

| Gap | Verdict | Sev | Effort | Evidence (code-verified) | Next step |
|-----|---------|-----|--------|--------------------------|-----------|
| String `==` is byte-wise, ignoring the shipped NFC/NFD normalizers | REAL | medium | S/M | Full canonical normalization EXISTS (`nova_rt_normalize_nfc`/`nfd` nova_runtime.c:9744-9745, real NFD table + composition `nova_unorm_run` :9721). But `nova_str_eq` (:1201) is `strcmp==0` and `nova_rt_eq`'s string branch compares "by bytes" (:2519). `"é"` (U+00E9) `==` `"e"+U+0301` is FALSE despite canonical equality → a web app comparing usernames/paths/tokens across normal forms silently mismatches (correctness + auth-bypass-adjacent). | Keep `==` byte-fast; add a `str_eq_canon`/normalize-then-compare helper + document; if canonical `==` is wanted, gate it and normalize both operands in the string branch of `nova_rt_eq`. |
| ABI version stamp is emitted but never CHECKED | REAL | medium | M | `NOVA_ABI_VERSION_*` + `nova_rt_abi_version()` exist (nova_runtime.c:21057-21066), `__nova_abi_version = "nova-abi-1.0.0"`, but grep `version.*mismatch`/`abi.*check` → no verification; pkg resolver does sha256 integrity but no ABI gate. The struct value model (slot-0 DJB2 hash, packed NSLOTS tag) is exactly what a compiler change shifts → a pre-compiled package built against an old layout loads with no guard → silent corruption, not a clean "rebuild needed". | Stamp the ABI version into emitted objects/package artifacts; add a load-time check (`nova_rt_abi_version()` vs recorded stamp) that fails loud on major mismatch. |
| `serialize`/`deserialize`/`serialize_hex` are dead type-registry stubs — calling them fails at link | REAL | low | S (delete) / M (implement) | `reg["serialize"]`/`reg["deserialize"]` (nova_compiler.nova:11321-11322) exist ONLY in the type registry. NO name→fn map entry (`resolve_runtime_fn("serialize")` returns unchanged), NO `nova_rt_serialize`/`deserialize` in the runtime, no LLVM declare → `serialize(x)` type-checks but emits `call @serialize` with no declaration → link failure. The typed `json_stringify`/`from_json` already cover the real need. | Delete the two registry entries (make the surface honest) OR wire a real binary codec (name-map + 2 runtime fns + 2 declares). Deletion is the clean minimal fix. |
| No dynamic struct construction / field-set-by-name (fully-dynamic ORM/deserializer path blocked) | PARTIAL | low | L | READ side complete (field_names/types/get through-any nova_runtime.c:4358-4399; `call_by_name` :16034; per-struct `from_json`). WRITE side partial: `nova_rt_field_set` mutates by SLOT INDEX (:15888); NO field-set-BY-NAME, NO construct-struct-of-type-X-from-a-dict-at-runtime (grep `construct_by_name`/`struct_from_fields`/`new_by_name` → 0). RTTI already has fnames/ftypes to power it. | Add `nova_rt_construct_by_name(type_name, dict)` (walk `g_struct_meta`, alloc, populate slots by fname) + a field-set-by-name wrapper; wire as builtins for the ORM deserialize path. |
| No native freestanding / no_std profile (only WASM uses `-nostdlib`) | REAL | low | XL | *(merged with Platform embedded-leaf.)* grep `freestanding|no_std|nostdlib|bare_metal|NOVA_FREESTANDING` in the compiler → only the WASM link line. The runtime has a `NOVA_FREESTANDING` bump-allocator #ifdef, but no compiler mode refuses heap/IO builtins for bare-metal or emits a native no-libc binary; ~285 mallocs + sockets/threads/printf unconditionally linked. | (Long-horizon) capability-gate non-freestanding builtins at type-check under `--freestanding` + #ifdef the remaining runtime allocs. Needs a real embedded target. |

---

## 4. Appendix — Recently CLOSED / stale doc claims corrected (don't chase ghosts)

These were once real but are now verified DONE (or were never real). Do NOT re-open them.

**Runtime / RC**
- **CORE_GAP 0.8 struct heap-field leak — CLOSED 2026-07-10.** Type-directed ownership: `NOVA_STRUCT_HASHED_BIT 0x10000` tag bit + `nova_rt_hashed_struct_alloc` + per-type managed-slot bitmap (`nova_rt_register_struct_bitmap`/`nova_struct_bitmap_for_hash`) + rc_free pre-switch managed-slot dec (nova_runtime.c:9867-9881) + make_struct MOVE/SHARE + field_set inc-new + FULLRC field-read-drop. `_struct_field_leak_test.nova` now hard-asserts `listbox <= 100` (was ~4000). Reconverged byte-identical (gen5==gen6 SHA 712A475A), ASAN-clean, 6 probes. The old "dead case NOVA_MEM_STRUCT" framing is stale.
- **CORE_GAP 0.10 (aliased dict-key/list-element swap UAF) — CLOSED 2026-07-09** (`_no_rc` insert delegated to counted siblings; `_alias_swap_leak_test.nova:45` is a hard assert).
- **CORE_GAP 0.9 (`any==string`/ordering `any<string` segfault) — CLOSED** (str OR→str AND lowering routes to box-aware eq/neq/cmp).
- **CORE_GAP 0.12 (`list + any` wild-deref) — CLOSED** (tag-guard → defined panic; runtime-only, no reconverge).
- **Tier 0 UB/UAF class (0.1-0.7) — CLOSED** with C-unit repros; the magnitude float heuristic is gone (box-tag is sole authority); box-aware truthy/neg/div/mod.
- **FULLRC reassignment loop-leak — CLOSED (default-ON)**; `leak_baseline_test.nova` asserts list/dict/chan deltas ≤ 10. The RC_COMPLETENESS "2000/2001" numbers predate the default-on flip and are stale.

**Type system**
- **Generics EXIST and bounds are ENFORCED** (`ti_extract_bounds`, `ti_check_bounds` real "does not implement trait" rejection; `fn<T,U>`, `List<T>`, generic structs via `tgmap`, HM let-poly). The "no generics" claim was stale.
- **Traits/interfaces EXIST** with conformance ("does not fully implement trait"), default methods, dynamic dispatch. (Only the *type-level* signature check is missing — §3.1 gap #1.)
- **Exhaustive-match ADTs EXIST** (`ti_check_exhaustive` → E1009 for user-enum/Result/Option). Was audited "unbuilt" — false.
- **Type checker is SOUND BY DEFAULT** (strict default unless `NOVA_TI_STRICT=0`; per-drain budget; fail-closed at exhaustion). The "fails open / GATE 2 is a lie" hole is gone (1.0-1.3, 1.5).
- **Enum variant managed-payload OWNERSHIP (0.8-adjacent) is CLOSED** (HASHED-tag + bitmap; `_struct_enum_payload_test.nova`). The *memory* side is closed; the *typing* side is §3.1 gap #2.

**Performance**
- **"Float arrays 281×C on escape" — STALE as the default.** S4.2 escape-versioning is SHIPPED + DEFAULT-ON (nova_compiler.nova:10468; runtime `nova_rt_list_is_kind2` :1584, `nova_rt_floatlist_view` :1590) → ~1.2-2.2×C for qualifying loops.
- **"Struct field access 2-3×C" — STALE.** SROA is DEFAULT-ON (nova_compiler.nova:19236-19237); ~1.05×C on 10M struct dot-products.
- **"Float array sum 120×C" — STALE.** Built-in reductions at C-parity via `nova_rt_sum_f`; ~2× homogeneous non-escape.
- **"Tight int loop + modulo 8×C" — STALE.** IR is native `mul/srem/icmp i64`; at parity.
- **"String concat in a loop 30×C" — STALE.** O(n) tools exist (`join`, `bytes`, `bytes_append_str`).

**Concurrency**
- **`remote_spawn` is a bare stub — STALE.** It's a real client-side primitive; what's missing is the distribution FRAMEWORK (captured as §3.4 4.6 PARTIAL).
- **FD_SETSIZE overflow at fd≥1024 on Windows — FIXED** (`#define FD_SETSIZE 4096`). Only the Linux/glibc path remains unguarded (§3.4 4.2).
- **Supervision/link/exit are log-only stubs — STALE.** `forge_otp.nova` has a real supervisor (sup_new/child_add/sup_start, per-child restart policies, windowed intensity, one_for_all/rest_for_one). The residual is preemptive-kill (§3.4 4.4).
- **N>1 grows memory unbounded — STALE** (task-slot reclaim defaults ON). **N>1 unvalidated for correctness — STALE** (scheduler/HTTP/WS-SSE gated at N=4/8). Throughput still regresses (the real 4.1).

**Platform**
- **"WASM is a no-op stub / no frontend" — STALE** for the value-model layer (wasm32 codegen real; heap value-model RUNS in node wasm via `nova_runtime_wasm.c` + `_wasm_vm_one.sh`). Residual = productization (§3.5).
- **"Linux = WSL-once, unverified" — UNDERSTATED.** Real cross-compile pipeline + 40/40 sweep + 10k-task scheduler + first-class `--target=x86_64-unknown-linux-gnu`. Reach = Windows + Linux x86_64.
- **DOM/event/interactivity "deferred" — DONE at proof level** (WASM_FRONTEND_PLAN Stages 0-5 ran against a node oracle). The gap is a real browser CI + framework.

**Toolchain**
- **6.2 REPL exists**, **6.4 LSP exists and diagnostics use the real inferer** (`lsp_collect_diagnostics` → tokenize→parse→`ti_infer_program_named`). The "LSP runs a stale Kotlin inferer" claim is stale. (Hover/completion are still text-scans — §3.6.)
- **`nova build` incremental + cross-compile + LTO** and **`nova fmt` AST-reprint** are real, not stubs. `check`/`lint`/`cov`/`bench`/`eval`/`wasm` all dispatch. A full package resolver + `eval_expr` interpreter EXIST (just unwired into CLI install / REPL).

**Forge core**
- **B1 read/idle timeout (Slowloris) — DONE** (`recv_request_bin`+`_read_timeout_ms`, forge.nova:467-506,4833). **B4 accept backpressure/conn cap — DONE** (`_conn_sem`/`_acceptor`, :4925-5035). Docs still list both open — stale.
- **OTP declarative API (supervisor trees + GenServer + child specs) — DONE**, not "API ⬜". GenServer `on_info`/LiveView prerequisite done via `monitor_into`.
- **Route-param percent-decode (B2), JWT external interop (B6), static symlink containment (B7), `nova new` scaffolder (B9), Struct→JSON keystone — all FIXED.** gRPC + HTTP/2 h2c framing/HPACK/cleartext-serving DONE + TESTED (the gap is TLS/ALPN + streaming + type-driven service).

**Forge libraries**
- **PG/MySQL `match Ok/Err` on any-typed value bug — FIXED** (compiler `84c70d55`; `is_ok`/`unwrap` workaround still correct but the "tracked compiler bug" note is stale).
- **ORM NULL params — DONE at the ORM layer** (`orm_null()`+`_orm_apply_nulls`). Raw-driver NULL bind is still open (§3.8).
- **MySQL caching_sha2 fast-path (8.x) — DONE**, proven live on 8.4.10 (only 0x04 cold-cache remains).
- **ORM CRUD / fluent builder / repository / relations / migrations / one-code-across-3-DBs — DONE.** **PG params/pool/txn/TLS verify-full — DONE.** **JSON true/null round-trip fidelity — DONE** (Stages 0-2). **`json_stringify(list-of-structs)` — FIXED.**

**Cross-cutting / roadmap**
- **Struct RTTI (hash-keyed field metadata) — FULLY BUILT** (`nova_rt_register_struct_meta`/`_field` emitted; json/show/field-reflection consume it). STRUCT_RTTI_DESIGN's "staged/future" is stale.
- **`json_stringify(list-of-structs)` silent-raw-pointer + struct-through-any — FIXED** (compile-time list-elem-struct dispatch + runtime RTTI case).
- **`from_json`/derive-able deserialization "ABSENT" — DONE** (`_make_from_json`(_safe)_method per struct, incl. nested + list<Struct>). **Reflection / dynamic invoke / automatic Show/Eq/Hash/Serialize (no @derive) — DONE.**
- **ABI stamp + NFC/NFD normalizers — the FUNCTIONS are DONE**; only their *enforcement* (package check / `==`) is open (§3.9).
- **F001-F110 catalog + TASK_TRACKER.md — massively stale historical snapshots** (FFI/crypto/db/TLS/self-hosting all shipped; catalog still lists them NOT_STARTED). Do NOT mine these for gaps.

---

## 5. Recommended sequencing (dependency-aware)

The tier build order still holds: **don't do frontier work on a cracked foundation.** But the foundation
(Tiers 0/1/3) is now largely closed, so the next moves are narrower and can partly parallelize.

**Wave A — foundation last-mile (do these first; small, high-trust, unblock everything).**
1. **Float-return uninit (0.11)** — the single remaining silent-wrong-answer soundness bug and it's cross-domain (blocks any float-heavy code / Cortex / Pulse / stats). XL only because it needs a reliable repro; get the repro, LLVM-IR-diff the float return slot, fix the S1 float ABI. **This is the #1 correctness item.**
2. **Trait conformance type check (§3.1 #1) + user-enum payload typing (§3.1 #2)** — two M-effort soundness holes in the *upstream* (type system) of the Tier-0 CVE class ("degrade to any → raw-bit reinterpretation"). Closing them prevents the next 0.11-class bug. They also de-risk the Forge `service`/interfaces marquee (#6), which leans on trait dispatch.
3. **String `==` NFC/NFD (cross-cutting #1)** — S/M, auth-bypass-adjacent, trivially fixable (add `str_eq_canon` + document `==` as byte-fast). Cheap security win.

**Wave B — the RC-completeness cluster (one campaign, shared root).**
4. Closure-capture leak (§3.2 #2), push-of-fresh-temp leak (§3.2 #3), and managed-field-reassign leak (§3.2 #4) **share ONE root: no owned-vs-borrowed provenance at insert/store, and no field_get-inc borrow tracking.** Do them together (MOVE-on-insert + field-borrow tracking + capture managed-slot bitmap = Stage 2 of the 0.8 fix). Then the **RC cycle collector (4.7)** as a supervised XL follow-on — but only after provenance exists, because the collector's safe-free phase reuses the same child-enumeration machinery. All memory-SAFE today, so this is important-not-urgent.

**Wave C — Forge production transport (unblocks real HTTPS/gRPC deployment).**
5. **ALPN in the runtime (Forge #1)** + **Windows SChannel TLS server (Forge #2)** — both L, both gate every HTTPS/h2/gRPC-over-TLS claim on the dev's own OS. Do ALPN first (it's the one dependency for h2-over-TLS), then Windows TLS server, then **gRPC streaming (#3)** and **h2 multi-stream (#6)** on top. The **type-driven `service` block (#6, XL)** comes after Wave A #2 (needs sound trait dispatch).
6. **DB fidelity + binary-safety (Forge-lib)** in parallel — affected-row counts (#1), the base32/TOTP/PG-DataRow/Redis NUL-truncation family (#2/#3/#9 — one `bytes`-based fix pattern), DB timeouts (#6). These are M/S and directly affect correctness of live apps.
7. **Wire the package-manager resolver (Toolchain #10 / CORE_GAPS 6.1)** — the resolver already EXISTS in `nova_pkg.nova`; wiring it into the CLI is L and unblocks any ecosystem story. Registry infra is external → supervised.

**Wave D — DevX polish (adoption, not correctness).**
8. **LSP inferer-backed hover/completion (#9)** + the missing providers (§3.6 #3) — route through the diagnostics path's existing `ti_infer_program_named` result. **REPL via `eval_expr` (#T3)** and an honest `nova debug` banner (#T4). Onboarding quickstart. All L/M/S, all high-leverage for a first-time developer (NOVA's stated identity).

**Wave E — platform reach (each gated on hardware / a specific framework need).**
9. **ARM aarch64 fibers (#2)** — L, needs an ARM host; the highest-value platform item (concurrency silently no-ops on ARM today; blocks Apple Silicon / Edge / mobile). **N>1 per-carrier I/O (4.1)** — L, only when multi-core throughput becomes a production target (N=1 is production today). **Linux epoll/kqueue + FD_SETSIZE guard (4.2/5.2)** folds into real Linux/macOS CI (5.6). **WASM productization (5.3), GPU lowering (5.4), preemption (4.4), distribution/mesh (4.6)** are XL and each waits on its dependent framework (Prism / Cortex / Reactor / Mesh) — do not start them until that framework is the active target.

**The rule that still governs everything:** do not start a framework whose blocking core gap is still
open, and do not pour frontier code onto an unclosed soundness hole. Wave A closes the last soundness
cracks; after that, Forge production transport (Wave C) is the highest-leverage build because its
blockers (TLS/ALPN, sound dispatch) are the same ones every other framework will also need.

---
---

# ═══════════════════════ PART IV — FEATURE COMPLETENESS INVENTORY ═══════════════════════

---

# NOVA — Feature Completeness vs Mature Languages, and the Add-Features Roadmap (2026-07-10)

> **The owner's question this answers:** *"We have a ~22k-line compiler, but Java/JDK is 200k+ lines with
> far more features and libraries — what are we missing?"*
>
> **Companion document.** This is the *breadth / capability* map: what NOVA already **has**, what it
> genuinely **lacks** vs Java/Rust/Go/Python/C#/Swift/JS, and a prioritized roadmap of features and
> libraries to **add**. It deliberately does **NOT** re-derive the verified soundness/bug/leak gaps —
> those are the authoritative, code-verified backlog in
> [`REMAINING_GAPS_AUDIT_2026_07_10.md`](REMAINING_GAPS_AUDIT_2026_07_10.md), which this doc references
> and does not repeat. Read that one for *"what's broken."* Read this one for *"what's missing."*

---

## 1. Framing: line count is the wrong metric

The instinct — "22k lines vs 200k+ lines, so we're 10% done" — is measuring the wrong thing. The honest
decomposition:

| Component | NOVA | Comparison |
|---|---|---|
| Compiler | `nova_compiler.nova` ~**22k lines** (self-hosted, byte-identical fixpoint) | `javac` alone is ~**100k lines** — and it is *only* the compiler |
| Runtime | `nova_runtime.c` ~**21k lines** (real C runtime: GC-free RC, green-task scheduler, netpoller, TLS, mmap, atomics) | HotSpot JVM is ~**1M+ lines** of C++ |
| "Standard library" | **559 `forge/` modules** (~570 DEV_TRACK rows) + ~250 runtime builtins | The JDK's **200k+ lines** is *25 years of stdlib*, thousands of classes |

Two things are true simultaneously, and both matter:

1. **Line count is not the metric — and fewer lines is partly by design.** NOVA's thesis is *"genius
   compiler, simple language."* Hindley-Milner inference means the developer writes zero annotations for
   ~95% of code; automatic zero-annotation reflection means no `@derive` boilerplate; implicit async
   means no colored `Future<T>` machinery. Where Java needs a `Serializable` interface + getters/setters
   + a builder, NOVA derives `print`/`==`/`to_json`/`from_json` from the struct at codegen with **zero**
   source. So a NOVA program expressing the same capability is *legitimately* shorter. Comparing raw
   line counts penalizes the exact thing NOVA is trying to win on.

2. **The real gap is stdlib/ecosystem BREADTH, and it is real.** The JDK's 200k lines are not ceremony —
   they are `java.time` (a correct IANA/DST timezone engine), `java.text` (collation, locale-aware
   formatting), `BigDecimal`, `javax.imageio` (PNG/JPEG), `javax.xml` (a real parser), `java.awt`/Swing
   (a GUI toolkit), plus 25 years of first-party and Maven-Central libraries. That *breadth* — decades of
   "someone already wrote the correct edge-case handling" — is where NOVA is genuinely thin, and no
   amount of compiler cleverness substitutes for it.

**Where NOVA is already strong** (verified at source level, not aspirationally):

- **Language core** — HM inference (deeper than Java/Kotlin/C#/Swift, which all require signature
  annotations); generics with **enforced** trait bounds; traits with default methods + dynamic dispatch +
  conformance; full sum-type enums with rich `match` (ranges, or-patterns, guards, **exhaustiveness**);
  `Result`/`Option` + one-word `try`/`?`; default/named/variadic params; operator overloading; UFCS;
  string interpolation; **implicit async** (no function coloring — beats Rust/C#/Kotlin colored async);
  Option-based null-safety; **automatic zero-annotation structural reflection** (print/eq/json/RTTI —
  genuinely differentiated).
- **Everyday stdlib** — this is *stronger* than the "thin stdlib" worry implies: dict/set/list with full
  functional surface, **specialized containers as builtins** (priority queue, deque, sorted map, LRU,
  Counter, ring buffer), a real **lazy iterator** suite, complete float transcendental math, PCRE-subset
  regex, JSON + typed (de)serialization, bytes/buffer, time components, and Forge adds ordered map/set,
  bignum, rational, complex, money, date/calendar/duration, CSV/TOML/YAML/base32/base64url.
- **I/O / net / OS** — *far* stronger than `STDLIB_API.md` advertises: buffered file streams with
  seek/flush, recursive dir walk, read-only mmap, subprocess-with-pipes, full DNS, binary-safe TCP with
  per-fd timeouts, UDP, OS + pure-NOVA TLS 1.3 client, integer atomics, HTTP client (chunked + SSE),
  URL/IP tooling.
- **Tooling** — one integrated `nova` CLI: build/**cross-compile**/`fmt`(AST-reprint)/lint/check/cov/
  bench/test/repl/LSP/DWARF-debug/wasm/pkg, plus a **shipping VS Code extension**.
- **Domain breadth (backend quadrant)** — 3 live DB drivers over raw TCP (PG/MySQL/SQLite), a universal
  ORM, HTTP/1.1 + WS + h2c + gRPC(unary), OTP supervision, pure-NOVA crypto + TLS 1.3, AWS SigV4/S3/
  DynamoDB, Prometheus metrics, and ~570 KAT-gated algorithm/DS modules (most of the CS canon).

**Where NOVA is genuinely thin** (the honest gaps, expanded in §3):

- **Presentation layer** — no GUI/desktop/mobile toolkit; no browser DOM/reactive UI runtime. The
  "frontend" half of NOVA's own full-stack identity is server-rendered HTML or ANSI text only.
- **Binary media & documents** — no image codecs (PNG/JPEG), no PDF/office, no audio/video.
- **Numeric-at-scale** — no autodiff/trainable ML, no GPU kernel lowering, no columnar dataframe.
- **Correctness-edge stdlib** — no IANA/DST timezones, no `BigDecimal`, no signed bignum, no regex
  capture-group extraction, no XML parser, no Unicode collation/casefold/graphemes.
- **A few language ceilings** — no user-extensible annotations, no macros/general comptime, no variance,
  no associated types, no const generics — which is *why* Forge stays imperative-registration-heavy where
  Spring/ASP.NET are declarative.
- **Ecosystem connective tissue** — no live package registry, no docs generator, no profiler; the
  transitive dependency resolver is *built but unwired*.

---

## 2. What NOVA already HAS (so the reader sees it is NOT "just a compiler")

### 2.1 Language features (verified in `nova_compiler.nova`)

Type system: HM inference + constraint solving (zero-annotation ~95%); generics `fn<T,U>`/`List<T>`/
generic structs with **enforced** trait bounds (erased, no monomorphization cost); traits/interfaces with
default methods, dynamic dispatch, conformance; structural width subtyping on records; **sound-by-default
type checker**. ADTs: full sum-type `enum` with payload variants; `match` with constructor/literal/string/
**range**/**or**/wildcard/binder patterns + **guards** + **exhaustiveness** (E1009). Errors: built-in
`Result`/`Option` + `try`/`catch` + `?`-style early return. Functions: first-class fns, lambdas,
automatic closures, **default params**, optional-param sugar `T?`, **variadic** `T...`, **named args**,
struct spread, UFCS, operator overloading (`+ - * / % == != < <= > >= **`). Concurrency: **implicit async**
(no coloring) — `spawn`, channels + `select`, `async`/`await`/`await_all`/`await_any`, `pmap`/`pfilter`/
`pfor`, monitors, OTP supervisors. FFI: `extern fn` + `@link`/`@repr(C)`/`@opaque`/`out<T>`/`unsafe`.
Null-safety via `Option`. Metaprogramming (bounded): `static_assert` + const-fn eval; **automatic
zero-annotation reflection** (compiler-derived print/eq/to_json, `field_names`/`field_types`/`type_of`/
`call_by_name`, per-struct `from_json`/`from_dict`, slot-0 RTTI hash). Modules: file = module, `_`-private,
`import`/`import as`/selective. Attributes (non-user-extensible): `@link`/`@repr(C)`/`@inline`/`@gpu`/etc.
String interpolation `"{expr}"`.

### 2.2 Standard library / builtins (~250 runtime builtins + Forge)

Collections: dict, set, list (map/filter/reduce/sum/min/max/any/all/zip/enumerate/flatten/sort/slice/…),
priority queue, deque, sorted-map `smap`, LRU, Counter, ring buffer, weak refs. Lazy iterators (full
non-materializing suite). Strings: full manipulation set + bytes + O(1) buffer + NFC/NFD normalizers.
Regex: PCRE-subset (match/find/replace/split). Time: components + strftime/strptime + diff/add. Math:
full transcendentals + `checked_add/sub/mul` + hex/oct/bin + parse. Random: `random_int/float` + CSPRNG
`random_bytes`. Encoding: JSON + typed (de)serialize via RTTI, hex. I/O: file read/write/append/bytes/
lines + buffered stream (open/read_line/seek/tell/flush/eof) + dir ops + metadata + path manip + read-only
mmap. Process: subprocess-with-pipes + system/exec/which/env. Net: TCP (binary-safe + per-fd timeout),
UDP, TLS client (OS + pure-NOVA 1.3), DNS, WebSocket, distributed channels. Sync: integer atomics +
channels/select.

### 2.3 Forge's 559 modules by category (the "third-party ecosystem" substitute)

- **Web**: HTTP/1.1 server + routing + middleware + timeouts + backpressure; WebSocket (RFC-6455 + hub/
  rooms); HTTP/2 h2c; gRPC (unary h2c); GraphQL (schema + HTTP + WS codec); JSON-RPC; protobuf codec;
  OpenAPI 3.0 gen; templating; i18n; markdown/html; feeds/sitemap/robots.
- **Data / DB**: PostgreSQL (SCRAM + TLS), MySQL (native_password + caching_sha2 fast-path), SQLite —
  all over raw TCP; universal **ORM** (typed `orm_all<T>`/`orm_one<T>`, fluent builder, relations,
  migrations); Redis. Parsers: CSV/TSV/NDJSON/TOML/YAML/INI/CBOR/msgpack/bencode/XML(emit). Streaming
  stats (histogram/online-stat/IQR/moving-avg/running-median).
- **Auth / security**: JWT, CSRF, RBAC/ACL, API keys, OAuth-PKCE, TOTP/OTP, password policy, sessions,
  rate-limiting, CSP/security-headers, cookie signing, webhook verify, validators/forms + typed
  extraction (`form_as<T>`, `from_json_safe<T>`).
- **Crypto / blockchain**: SHA-2/3, HMAC, PBKDF2/HKDF, AES-GCM, ChaCha20, X25519, Ed25519, P-256,
  RSA-verify, Shamir, Paillier; TLS 1.3 (offline KAT/RFC-8448); base58/base58check/bech32/base45;
  Merkle audit chains; ULID/UUID/snowflake; DEFLATE/gzip.
- **Scientific / numeric**: matrix/linsolve/matexp, complex, poly, NTT + FWHT, rational, bignum, Kalman,
  simplex (LP), spline, geometry (convex hull, polygon clip), combinatorics/number-theory.
- **ML (classic, inference-only)**: tensor builtins (matmul/relu/softmax forward), Cortex linear
  classifier; k-means, kNN, linear regression, naive Bayes, k-fold CV, confusion-matrix/F1, DBSCAN,
  TF-IDF, cosine/Jaccard, MinHash/SimHash.
- **Cloud / ops / observability**: AWS SigV4 + S3 + DynamoDB request builders; CloudEvents; Prometheus
  metrics + health probes + structured logs; profiling + flamegraph export; coverage (LCOV); Ops
  Dockerfile/CI-YAML codegen.
- **Messaging (in-process)**: `forge_mq` actor broker (FIFO, work-sharing, dead-letter); pub/sub hub.
- **Algorithm/DS canon**: 300+ modules — trees, graphs (Dinic/HLD/link-cut/blossom), strings (suffix
  automaton/aho-corasick/eertree), DP, number theory (Tonelli/Pollard/Pohlig), geometry.

### 2.4 Tooling

One integrated `nova` CLI: `build`/`run`/`compile` (`-O0/-O2`, incremental, LTO, **cross-compile** to
linux/linux-arm64/macos/macos-arm64/windows/wasm), `fmt` (AST-reprint), `lint`, `check`, `cov`, `bench`,
`test` (auto-discovers `*_test.nova`), `eval`, `repl`, `lsp`, `debug` (DWARF + lldb-dap handoff), `wasm`,
`init`/`new` (5 scaffold templates), `get`/`install` (semver primitive + sha256 integrity). Shipping
**VS Code extension** (`nova-lang-0.3.0.vsix`). ABI version stamp emitted.

---

## 3. What NOVA LACKS — by dimension

> **Dedup rule.** Every item below is a **capability/breadth** gap, deduped across dimensions and against
> the prior audit. Verified soundness/bug/leak gaps (float-return-uninit 0.11, trait-conformance
> signature check, user-enum payload typing, RC leaks/cycles, NUL-truncation, ALPN/Windows-TLS-server,
> gRPC streaming, package-resolver-wiring, LSP inferer-backed hover, etc.) are **owned by the prior
> audit** and only cross-referenced here, never re-argued. Importance = **must-have** / **high** /
> **nice-to-have**. Effort = S / M / L / XL.

### 3.1 Language features

| # | Missing feature | Present in | Imp. | Effort | Why it matters |
|---|---|---|---|---|---|
| L1 | **User-extensible annotations + annotation processing** (`@Entity`/`@Route`/`@Test` readable at compile/run time → codegen hook) | Java (APT), Kotlin (KSP), C# (attributes+reflection), Swift (property wrappers/macros), Rust (proc-macro) | high | XL | **The #1 lever.** Forge already *fakes* this with string-path registration (`grpc_register`, manual routes). The type-driven `service` marquee is blocked precisely on the absence of an attribute→codegen hook. Every declarative framework (ORM, DI, routing, validation, test discovery) rides annotations. Without them Forge stays imperative where Spring/ASP.NET are declarative. |
| L2 | **Hygienic macros / general (Zig-style) comptime** — run the language at compile time; quasi-quote AST | Rust (`macro_rules!`+proc-macro), Swift macros, C# source generators, Zig comptime | high | XL | Only `static_assert` + const-fn eval ship (audit 3.4, OPTIONAL). Real metaprogramming is how ecosystems generate serializers/DI-graphs/SQL-mappers/DSLs without hand-writing. NOVA's auto reflection covers *derivation*; not *user-authored* codegen. The design docs' own `quote(...)`/`$splice` idea would erase ~700 hand-built `Expr(`/`Stmt(` sites in the compiler itself. |
| L3 | **Variance annotations** (declaration-site `out`/`in` or use-site) | Kotlin, C#, Java (`? extends`/`? super`), Swift | high | L | With erased generics + width subtyping but no variance, NOVA cannot soundly express `List<Cat>` where `List<Animal>` is wanted, or contravariant callbacks. Forces `any`-holes or copies for a language leaning on generic collections + trait objects. |
| L4 | **Associated types / higher-kinded abstraction on traits** (`trait Iterator { type Item }`) | Rust (assoc types/GATs), Swift (assoc types) | high | XL | Traits are method-set-only; no type-constructor abstraction. Caps how generic the stdlib/Forge can be — you cannot write one `Collection`/`Serialize` trait over element/output type families. (Java/Kotlin/C# also lack true HKT — this is "match Rust/Swift, not lose to Java," but it is the abstraction ceiling.) |
| L5 | **Const generics / type-level values** (`[T; N]`, dimensions in the type) | Rust, C++, Swift (limited) | high | L | Tensors (Cortex) and fixed-size buffers (Edge) carry dimensions only at runtime. Const generics let the compiler verify matmul shape compatibility and stack-allocate fixed buffers — directly relevant to AI + embedded reach and zero-overhead systems code. Also unblocks fixed-size stack arrays. |
| L6 | **Enforced immutability distinction** (`val`/`var`, `let`/`mut`, `readonly`) | Rust, Swift, Kotlin, C#, Java | high | M | `let` exists but reassignment is permitted; no `mut`/`val` enforcing immutability. Mature langs make immutability default, mutation opt-in — a correctness + concurrency lever (immutable data is trivially Sendable). Some intra-process aliasing bugs trace to this being unenforced. |
| L7 | **First-class sized numeric types** (`i32`/`u8`/`u32`/`u64` as value types, not just FFI annotations) + **`f32`** + **unsigned arithmetic** | Rust, C#, Swift, Zig | high | M | Narrow/unsigned ints exist ONLY in `extern fn` signatures; in-language every int is signed i64. Blocks embedded/Edge (registers, byte protocols), wire-format codecs, hashing/crypto (unsigned), and GPU/graphics/DSP interop (`f32`). Combined with `1<<64` UB (audit 3.2) this is a real systems/wire gap. |
| L8 | **User-definable indexing / iteration / call operators** (`[]` overload, `for x in myType` via iterator protocol) | Rust (`Index`/`IntoIterator`/`Fn`), Swift (`subscript`/`Sequence`), Kotlin, C# | nice-to-have | M | Operator overloading covers arithmetic/comparison but NOT `[]`, the call operator, or a user-facing iterator protocol. Custom containers can't feel first-class vs built-in list/dict — a papercut for battery authors. |
| L9 | **Automatic numeric tower** — auto-bignum on i64 overflow + decimal/money/scientific literals (a stated NOVA vision item) | Python (native bigint), Ruby | nice-to-have | L | Vision says i64 auto-promotes to arbitrary precision on overflow and money/scientific literals infer to decimal. Today ints silently **wrap**; no bigint promotion, no decimal literal. (This is the language-surface version of the `BigDecimal`/signed-bignum stdlib gaps in §3.2.) |
| L10 | **Weak references as a language/RC feature** + **user-defined Drop/RAII destructors on scope exit** | Rust (`Weak`/`Drop`), Swift (`weak`/`deinit`), C# (`IDisposable`) | nice-to-have | M | `weak_create` builtins exist but no `weak<T>` language surface for caches/observer/parent-pointers; no synthesized `<Type>__drop` for struct-held FFI/file/socket handles (`defer` + auto-drop of list/dict locals ship). RC-cycle-adjacent. |
| L11 | **Richer module system** — hierarchical namespaced paths + per-module symbol mangling + visibility tiers (`pub(crate)`/`internal`) + re-exports | Rust (`mod` tree/`pub(crate)`), C# (namespaces/`internal`), Kotlin, Swift | high | M | **Two problems, one root.** (a) Visibility is binary (public / `_`-private), no re-export. (b) *Critically:* every top-level fn emits a **bare `@name` LLVM symbol** — two co-imported modules sharing a fn name **fail to link** ("invalid redefinition"), even `_private` names. This has bitten Forge repeatedly and is a **hard scalability cap on a package ecosystem** (every new module must hand-pick globally-unique names). Proper fix = `@mod__fn` mangling + call qualification. |
| L12 | **Multi-line collection literals** (parser) | every mainstream language | nice-to-have | S | Any `[...]`/`{...}` spanning newlines fails `E0001`. Forces lookup tables / config maps onto one physical line — a real authoring wall vs Python/Java table-stakes. |
| L13 | **Reserved-keyword-as-variable diagnostic** | every mainstream language | nice-to-have | S | `let match = …` (also `while`/`if`/`select`/`unsafe`) SILENTLY mis-codegens with no error. A missing frontend guard (should be a clean E-code reject). |

*Also folded in from the prior audit (referenced, not re-argued): trait-conformance signature check
(audit §3.1 #1), user-enum payload typing (audit §3.1 #2), and general comptime (audit 3.4).*

### 3.2 Standard library — data / text / time / math / encoding

> This is one of NOVA's *stronger* dimensions for everyday work; the gaps are the **correctness edge** a
> universal language cannot skip.

| # | Missing feature | Present in | Imp. | Effort | Why it matters |
|---|---|---|---|---|---|
| D1 | **IANA timezone database + DST** (zoned datetime) | Java `java.time.ZoneId`, Python `zoneinfo`, Go `time.LoadLocation` | **must-have** | XL | `forge_tzoffset` is fixed-offset only. Cannot answer "9am America/New_York on a DST-transition day in UTC," cannot schedule recurring zoned events, cannot correctly convert historical timestamps. Any calendar/scheduling/cross-region-logging app is blocked. Needs bundled tzdata + transition rules. |
| D2 | **Arbitrary-precision decimal / `BigDecimal`** (rounding modes, fixed-point) | Java `BigDecimal`, Python `decimal.Decimal` | **must-have** | L | No exact base-10 fractional type. `forge_money` is integer-cents (fixed 2dp). Finance, tax, invoicing, scientific reporting, "0.1+0.2" correctness all need a real Decimal. **THE** classic reason devs leave a language for money/data work. |
| D3 | **Regex capture-group extraction** (named + numbered groups) | Java `Matcher.group`, Python `re` groups, Go `FindStringSubmatch` | **must-have** | M | `regex_find` returns the whole match only — no API for `\1`/`(?<name>…)`. Parsing structured text (log lines, URLs, dates, key=value) is crippled: you get "did it match" and "the whole hit," never the fields. A daily-use gap. |
| D4 | **Signed arbitrary-precision integer** (bignum handles negatives) | Java `BigInteger`, Python `int`, Go `math/big` | high | M | `forge_bignum` is documented **non-negative only** (`big_sub` requires a≥b). Any exact-integer domain with subtraction below zero (accounting deltas, crypto intermediates, signed modular math) breaks. A universal language cannot ship a bigint that can't be negative. |
| D5 | **XML parser** (only a serializer ships) | Java `javax.xml`, Python `xml.etree`, Go `encoding/xml` | high | L | `forge_xml` is emit-only. SOAP responses, RSS/Atom, sitemaps, config XML, legacy enterprise APIs are read-impossible without hand-rolling. "Never leave NOVA" fails the moment you must *consume* XML. |
| D6 | **Unicode collation + case-folding + grapheme segmentation** (+ make `==`/dict-keys optionally normalization-aware) | Java `Collator`/`java.text`, Python `unicodedata`+`casefold`, Go `x/text` | high | L (+S for the `==` helper) | NFC/NFD normalizers exist but nothing above: no locale-aware sort, no `casefold`, no grapheme iteration (`chars()` splits bytes → emoji/combining marks break). *(The `==`-ignores-normalization correctness bug is owned by audit §3.9; the collation/casefold/grapheme LIBRARY on top is the new breadth gap.)* |
| D7 | **Immutable / persistent collections** (structural sharing) | Java `List.of`/unmodifiable, Python `frozenset`/tuple, Clojure/Scala (the bar) | high | L | No `frozenset`, no HAMT map/vector, no `freeze`. Concurrency-safe sharing, defensive snapshots, functional-update (`v2 = v.set(k,x)` without copy) have no answer — process isolation deep-copies (correct but O(n); persistent structures give O(log n) across channels). |
| D8 | **Seedable / deterministic PRNG stream** (reproducible) | Java `Random(seed)`, Python `random.seed`, Go `math/rand` | high | S | Only unseedable global `random_int/float` + CSPRNG `random_bytes`. No reproducible stream from a seed → blocks deterministic tests, simulations, procedural generation, replayable shuffles, seeded sampling. |
| D9 | **Binary struct pack/unpack + endianness codec** (`pack("<Iih")`, read-LE-u32, write-BE-f64) | Python `struct`, Go `encoding/binary`, Java `ByteBuffer` | nice-to-have | M | `bytes_get/set` are byte-at-a-time. Forge drivers hand-roll wire encoding per protocol (PG/MySQL/TLS). A reusable binary codec removes that duplication and enables file-format work (images, archives, custom protocols). Directly enables L7 (sized ints) use. |
| D10 | **URL/percent + multipart codecs as standalone stdlib** | Java `URLEncoder`/`URI`, Python `urllib.parse`, Go `net/url` | nice-to-have | S | Percent-encoding/URI-building/multipart live *inside* Forge's HTTP layer, not as reusable APIs. Non-HTTP data-munging re-implements them. |
| D11 | **Extended math builtins** (`gamma`/`erf`/`nextafter`/`copysign`/`fma`/`isnan`/`isinf`, fast int `gcd`/`lcm`, `clamp`) | Java `Math`, Python `math`, Go `math` | nice-to-have | S | Core trig/log is complete but statistical/IEEE helpers are absent; `gcd`/`lcm` only exist over string-bignum, not as fast int builtins. Scientific/ML/stats code (Cortex, Pulse) reaches for these constantly. |
| D12 | **RFC-complete CSV/TOML/YAML** (multiline, anchors/aliases, complex tables, typed scalars) | Python `csv`/`tomllib`/PyYAML, Go `encoding/csv` | nice-to-have | M | Forge parsers are pragmatic subsets — fine for config-you-control, risky for arbitrary third-party documents. Needs conformance tests or documented subset boundaries. |

### 3.3 I/O / networking / OS / filesystem

> Stronger than `STDLIB_API.md` advertises; the gaps cluster in POSIX-completeness and production-
> networking last-mile.

| # | Missing feature | Present in | Imp. | Effort | Why it matters |
|---|---|---|---|---|---|
| S1 | **OS signal handling** (SIGINT/SIGTERM/Ctrl-C/SIGHUP → graceful shutdown) | Go `os/signal`, Java shutdown hooks, Python `signal`, Rust `ctrlc` | **must-have** | M | Zero user-facing signal API. Every long-running server/CLI needs "catch Ctrl-C, drain, flush, exit 0." A Forge server cannot do graceful shutdown or clean SIGTERM in a container/k8s. Runtime already registers `SIGURG` internally → an `on_signal(sig,handler)` builtin is small. Table-stakes for the deploy/cloud/edge story. |
| S2 | **HTTP client: redirect following + cookie jar + proxy** | Go `net/http`, Java `HttpClient`, Python `requests`, Rust `reqwest` | high | M | Forge client does verbs + chunked + SSE, but no 301/302 follow breaks most real API/CDN calls; no cookie jar breaks any session-authenticated integration; no proxy breaks corporate/edge egress. The single most-used networking surface, silently under-delivering vs `requests`. |
| S3 | **OS thread sync primitives** (mutex/rwlock/condvar/semaphore/barrier) as a user library | Go `sync`, Java `j.u.c.locks`, Python `threading`, Rust `std::sync` | high | M | CSP+atomics cover most cases, but a guarded cache, read-mostly config, bounded-resource semaphore, or startup barrier has NO NOVA idiom. `pthread_mutex` already links — exposing `mutex_new/lock/unlock`/`rwlock_*`/`sem_*` is mechanical. |
| S4 | **Filesystem glob** (`*.nova`, `**/*.png`) | Go `filepath.Glob`, Java `PathMatcher`, Python `glob`, Rust `glob` | high | S | `dir_walk` + manual `ends_with` is the only path. Build tools, asset pipelines, test runners, static servers all need it — including NOVA's own toolchain. Small: walk + fnmatch over existing `dir_walk`. |
| S5 | **File permissions & symlinks** (`chmod`/mode bits, `symlink`/`readlink`/`lstat`, `+x`) | Go, Java `Files`, Python `os`, Rust `std::fs` | high | M | A package manager/installer/deploy tool writing an executable script cannot mark it `+x`; secure-file creation (0600 for secrets/keys) is impossible → a **security gap** for the crypto/TLS story (private keys world-readable). "Run anywhere" implies real POSIX file semantics. |
| S6 | **Unix domain sockets** (`AF_UNIX`) | Go, Java (JDK16+), Python, Rust | high | M | The standard local-IPC transport: Docker daemon, systemd activation, local Postgres/Redis `.sock`, sidecars. A backend framework that can't `listen` on a `.sock` can't sit behind nginx/Envoy idiomatically. |
| S7 | **User-controllable socket options** (`TCP_NODELAY`, `SO_REUSEADDR/REUSEPORT`, keepalive, buffers) | Go, Java, Python, Rust `socket2` | high | S | Runtime calls `setsockopt` internally but nothing is user-tunable. `TCP_NODELAY` matters for latency-sensitive RPC; `SO_REUSEPORT` for multi-carrier accept load-balancing. NOVA can't tune the socket path it claims C-parity on. |
| S8 | **UDP with peer address** (`recvfrom`/`sendto` carrying `(host,port)`) | Go `ReadFromUDP`, Java `DatagramPacket`, Python, Rust | high | S | `udp_recv` returns only the datagram, no sender address → UDP servers (DNS server, game netcode, STUN, syslog, metrics) are impossible (can't reply to the sender). Small fix: return `[data,host,port]`. |
| S9 | **File locking** (`flock`/`LockFileEx`), **RW mmap**, **async DNS on the netpoller**, **explicit worker-pool** | Go/Java/Python/Rust equivalents | nice-to-have | S–M | File locks needed for correct multi-process tooling (pkg cache, pidfile). RW mmap unlocks storage engines (relevant to the post-Forge NOVA-native DB). Async DNS matters only at fan-out scale. A named bounded worker-pool with backpressure is what server authors expect (composable from channels+spawn, but not provided). |

### 3.4 Tooling & ecosystem

> Tooling *breadth* is ahead of where a solo project should be; the gaps are **depth + connective tissue**
> (sharing, observability, IDE semantics).

| # | Missing item | Present in | Imp. | Effort | Why it matters |
|---|---|---|---|---|---|
| T1 | **Docs generator + hosted docs** (`nova doc`, `///` extraction, HTML) | Rust (rustdoc/docs.rs), Go (godoc/pkg.go.dev), Java (javadoc), Python (Sphinx) | **must-have** | L | A solo dev on 559 forge modules + their own code needs generated browsable API docs. Every mature lang treats this as table stakes; its absence makes a growing library unnavigable and blocks any publish story. |
| T2 | **Live public registry** (publish flow, index, hosted search, checksum/transparency log) | crates.io, proxy.golang.org, Maven Central, PyPI | **must-have** | XL | "The developer never leaves" needs a place to SHARE code. Forge covers std needs; community libs (a Stripe SDK, a Kafka client) need a registry + publish + discovery. External infra (hosting/moderation/availability) → XL. Without it NOVA is a language you build IN, not an ecosystem you build ON. *(The transitive-resolver wiring that consumes it is audit Toolchain #10 — built-but-unwired.)* |
| T3 | **Profiler** (`nova profile`, sampling CPU + flamegraph) | Go pprof (best-in-class), Rust flamegraph, Java JFR/async-profiler, Python py-spy | high | L | NOVA sells C-class perf; a dev chasing a hot path or allocation leak has no way to SEE where time/memory goes (only whole-program `nova bench` + a heap COUNT profiler). Go's pprof is a headline feature. Without it the "fast" promise is unverifiable on the user's own code. |
| T4 | **Property-based testing + mocks/stubs + fixtures/DB-rollback** | Rust proptest/mockall, Java jqwik/Mockito, Python hypothesis/unittest.mock, Go testing/quick | high | M | "Robust" is a NOVA non-negotiable. Property testing is exactly how you find NOVA's own bug class (NUL-truncation, shift≥64, float-compare). Mocks + DB-rollback fixtures test the 3 drivers/handlers without live infra. Composes on existing `nova test` + `forge_test`. |
| T5 | **Test framework ergonomics** (per-`fn` discovery/reporting, rich assert diffs, `--run` filter, parallel exec, TAP/JSON report) | Rust `#[test]`, Go `func TestX`+`-run`, JUnit, pytest | high | M | `nova test` is file-granular (one binary = one pass/fail). Real suites need per-case granularity ("3 of 200 failed, here's the diff"), filtering, parallelism. The difference between a toy runner and a trusted suite. |
| T6 | **CI templates beyond one shape** (matrix/cache/release, GitLab CI, `nova ci init`) | goreleaser, actions-rs, tox/nox | nice-to-have | S | Ops generates a single GH-Actions YAML + Dockerfile. A starter matrix build + release-artifact template + `nova new`-integrated CI scaffold makes "run anywhere" turnkey. Small on existing Ops codegen. |
| T7 | **Signed one-command installer** (`curl\|sh` / msi / brew / apt) bundling runtime+clang | rustup, go install, most langs | high | M | No hosted installer; onboarding still has a residual dev-tree/Java-launcher flavor in places. First-run friction directly hits NOVA's "download → build a full-stack app" identity. |
| T8 | **CLI-native interactive debugger** + **productized REPL** | Go delve, Python pdb/IPython, Java jshell | nice-to-have | M | *(Both owned as PARTIAL by audit §3.6 — referenced.)* The DWARF+lldb-dap plumbing exists; the CLI just needs to drive it. `eval_expr` interpreter exists; the REPL just needs to use it instead of per-line clang recompile. |

*Also folded in from the prior audit (referenced): LSP inferer-backed hover/completion + refs/rename/
signatureHelp/inlayHint/semanticTokens (audit §3.6), transitive dependency resolver wiring (§3.6 / 6.1),
ABI-version load-time check (§3.9).*

### 3.5 Domain libraries

> Lopsided by design: backend/algorithmic/crypto is astonishingly complete; the gaps are **presentation
> layer + binary media + numeric-at-scale + wire-protocol clients**.

| # | Missing feature | Present in | Imp. | Effort | Why it matters |
|---|---|---|---|---|---|
| G1 | **GUI / desktop / mobile toolkit** (windowing, canvas, widgets, layout, event loop) | JS (Electron/RN), Java (Swing/JavaFX), Python (Qt/Tk), Go (Fyne/Gio) | **must-have** | XL | NOVA's flagship promise is "backend + **frontend** + deploy, one language." Today the frontend is server-rendered HTML or ANSI text — a native window has never opened. A rich client is impossible in-language → the developer MUST leave NOVA, which the vision defines as failure. **The single biggest domain hole.** *(Depends on FFI callbacks — audit-adjacent §3.5-platform.)* |
| G2 | **Browser / WASM UI runtime** (DOM bindings + reactive/component model) | JS (React/Vue/Svelte), Go (syscall/js), Rust (Leptos) | **must-have** | XL | The "one-language full-stack" story needs a browser frontend. WASM value-model *runs* (proof-level) but there is no DOM/event binding and no component framework. Without it "frontend" means string-templated HTML only — losing to JS on its home turf. *(WASM productization itself is audit 5.3; this is the DOM/framework LIBRARY on top.)* |
| G3 | **Image codecs** (PNG/JPEG/GIF/WebP encode+decode) + 2D raster/canvas | Python Pillow, Java ImageIO, JS canvas/sharp, Go image/* | high | L | `deflatex` gives zlib but no PNG chunk/filter layer, no JPEG DCT, no pixel buffer. Avatars, thumbnails, charts, QR rendering, ML vision preprocessing all need it. Any app touching user images must leave NOVA. |
| G4 | **Autodiff / trainable deep learning** (backward pass, loss, SGD/Adam, conv/attention) | PyTorch/TF/JAX, tfjs, DJL, candle/burn | high | XL | "AI" is a named NOVA domain (Cortex). Tensors are forward-only; no `backward`/`grad`/optimizer. NOVA can *serve* a pre-trained model but cannot *train* one. A defining gap vs the Python ecosystem it must beat. *(GPU kernel lowering it depends on is audit 5.4.)* |
| G5 | **Dataframe / analytics engine** (columnar df, joins, window fns, Parquet/Arrow) | Python pandas/polars, Java Tablesaw, Rust polars | high | L | Pulse is CSV group-by over `list<row-of-strings>`; no columnar store, no typed columns, no out-of-core, no Parquet. Losing to pandas/polars undercuts the "data" pillar. (Now viable perf-wise since typed float-array perf landed.) |
| G6 | **Message-broker wire clients** (Kafka, RabbitMQ/AMQP, NATS, MQTT) | native clients in Java/Go/Python/JS | high | L each | `forge_mq` is in-process single-node; nothing speaks a broker protocol on the wire. Distributed/cloud apps integrate with existing infra. Each is a bounded TCP-protocol client — the PG/MySQL/Redis drivers prove NOVA can do wire protocols → **cheap high-value wins**. |
| G7 | **PDF / office document generation** (PDF, DOCX, XLSX) | Python reportlab/openpyxl, Java PDFBox/POI, JS pdfkit, Go gofpdf | high | L | Invoices, reports, exports, statements — table-stakes for business/SaaS backends. Absent entirely. PDF is a self-contained spec (in-language achievable); XLSX needs zip+XML (zip = `deflatex` + a container). |
| G8 | **GCP / Azure cloud SDKs + broader AWS** (SQS/SNS/Lambda/KMS/Secrets) | first-party SDKs for all 3 clouds | high | L each | "Run ANYWHERE" for cloud means multi-cloud. NOVA can sign AWS requests but has no GCP (OAuth2 service-account + GCS/Firestore/PubSub) or Azure path, and even AWS misses the messaging/serverless/secrets most apps use. Request-builder pattern scales, but each service is manual. |
| G9 | **Distributed tracing / OpenTelemetry** (spans, W3C `traceparent`, OTLP exporter) | OTel SDKs (Go first-class) | nice-to-have | M | `forge_obs` has metrics + logs but no traces — the missing third pillar of microservice debugging. Bounded: span model + context propagation through Forge middleware + OTLP/HTTP exporter reusing the JSON/protobuf codecs already present. |
| G10 | **Charts/plotting** (bar/line/scatter with axes/legends → SVG now, PNG after G3) | Python matplotlib/plotly, JS d3/chart.js, Java JFreeChart | nice-to-have | M | Dashboards, reports, ML viz. Partially reachable via `forge_svg` today (SVG charts achievable now); PNG depends on G3. |
| G11 | **Audio / video codecs & processing** (WAV/MP3/Opus, H.264, resample, mux) | Python librosa/av, JS Web Audio, Java JavaSound | nice-to-have | XL | Media apps, transcription, game audio. Full codecs are XL and often FFI-bound even in mature ecosystems; lower priority than image/GUI but a real "build ANYTHING" hole (also a Reactor v0.2 promise). |

### 3.6 The 8 unbuilt sibling frameworks (the largest strategic breadth gap)

NOVA's own roadmap names **9** frameworks; only **Forge** (web) is built. The other 8 are v0.1 seeds
(~100-line demos, ~0% of headline features). This is *why* domain coverage is lopsided — each is its own
multi-month framework, and together they are NOVA's "build ANYTHING, run ANYWHERE" surface:

| Framework | Domain | Status | Headline unbuilt capabilities |
|---|---|---|---|
| **Cortex** | AI/ML | seed | ONNX/GGUF/SafeTensors loaders, autograd/training/optimizers, KV-cache, continuous batching, Flash Attention, INT4/INT8 quantized kernels, vector DB, RAG (⟵ G4) |
| **Mesh** | distributed | seed | node discovery/registry, transparent remote placement (`@node`), CRDT state, consistent hashing, Raft locks, chaos/time-travel debug (⟵ audit 4.6) |
| **Prism** | desktop GUI | seed (ANSI only) | wgpu renderer, reactive state, spring-physics animation, accessibility, HBox/VBox/Grid layout (⟵ G1) |
| **Pulse** | data | seed | streaming pipelines (file > memory), relational join, inline SQL, time-series/geospatial types, Parquet (⟵ G5) |
| **Sentinel** | security | seed | **Argon2id** password hashing, ML-KEM/ML-DSA post-quantum, ZK proofs, HSM, homomorphic, compliance |
| **Edge** | embedded | seed | real MCU backend (ESP32/Cortex-M/RISC-V), peripheral drivers (I2C/SPI/UART/GPIO), OTA, RTOS hooks (⟵ L7) |
| **Ops** | DevOps | seed | multi-cloud provider abstraction, drift detection, canary, k8s manifests, Prometheus scrape (⟵ G8) |
| **Reactor** | games | plan-only | wgpu render, archetype/sparse-set ECS, physics FFI, shaders-in-NOVA, GPU particles, input polling, audio mixing (⟵ G1/G4/G11) |

Plus **Vault** (the hosted package registry + quality gate — external infra, ⟵ T2).

*Notable within these: **Argon2id / scrypt / bcrypt** (memory-hard KDF) is genuinely absent — Sentinel
uses SHA-256 today; forge_crypto has PBKDF2 but no memory-hard KDF → password storage is not
best-practice. This is a **high-importance, M-effort** self-contained win worth doing independent of the
Sentinel framework.*

---

## 4. Coverage confirmation

**Read exhaustively:** the 7 completeness-sweep sections cover **~113 `NOVA_DESIGN`/docs Markdown files**
(A–F: 43, G–N: 21, O–Z: 33, docs-root: 16) and **~125 memory files** (a–f: 28, g–p: 81, q–z: 15 +
`MEMORY.md`) — **~238 md + memory files total**, deduped against the prior audit. Plus the 5
feature-comparison sections (language, stdlib-data, io-net-sys, tooling-ecosystem, domain-libs) and the
prior [`REMAINING_GAPS_AUDIT_2026_07_10.md`] (read in full, twice).

**NEW items the exhaustive sweep surfaced beyond the prior audit** (the prior audit is scoped to
soundness/bugs + Forge productization; these are *capability/breadth* items it does not enumerate):

- **The 8 unbuilt sibling frameworks** (Cortex/Mesh/Prism/Pulse/Sentinel/Edge/Ops/Reactor) — the single
  largest breadth gap; verified absent (`grep forge/` = 0 files each). (§3.6)
- **Language ceilings**: user-extensible annotations (L1), macros/comptime (L2), variance (L3),
  associated types (L4), const generics (L5), enforced immutability (L6), sized/`f32`/unsigned numerics
  (L7), custom index/iterator/call operators (L8), automatic numeric tower (L9), weak-ref/Drop language
  surface (L10). (§3.1)
- **The module-symbol-namespacing link limitation (L11)** — bare `@name` LLVM symbols cause hard link
  errors on duplicate public fn names across modules; a real **ecosystem-scalability cap**, and an
  authoring wall (multi-line literals L12, keyword-as-var mis-codegen L13).
- **Stdlib correctness-edge**: IANA/DST timezones (D1), `BigDecimal` (D2), regex capture groups (D3),
  **signed** bignum (D4), XML **parser** (D5), Unicode collation/casefold/graphemes (D6), persistent
  collections (D7), seedable PRNG (D8), binary pack/unpack (D9), extended math builtins (D11).
- **I/O/OS last-mile**: signal handling (S1), HTTP-client redirects/cookies/proxy (S2), thread sync
  primitives (S3), glob (S4), file perms/symlinks (S5), unix domain sockets (S6), socket options (S7),
  UDP peer address (S8).
- **Tooling depth**: docs generator (T1), live registry (T2), profiler (T3), property-based testing +
  mocks + DB-rollback (T4), per-`fn` test ergonomics (T5), signed installer (T7).
- **Domain libraries**: GUI/desktop (G1), browser DOM/reactive UI (G2), image codecs (G3), autodiff/
  training (G4), dataframe (G5), broker wire clients (G6), PDF/office (G7), GCP/Azure SDKs (G8),
  OpenTelemetry tracing (G9), Argon2id (§3.6). Plus FFI callbacks (`@cdecl`/C→NOVA re-entry), struct-by-
  value FFI return, and `f32` at the FFI boundary — noted in the sweeps as concrete FFI-completeness
  gaps.

*Doc-hygiene items the sweep also caught (fix opportunistically, not roadmap):* several **stale normative
docs** — the perf guide falsely says NOVA has no TCO (it has `ir_tco`); tutorial vs spec disagree on
negative indexing; README/spec quote stale line counts and stale "what works" lists; `type_of(true)=="int"`
and boolean-expr results stringify `"1"/"0"`.

---

## 5. Recommended feature roadmap (the discussion starting point)

> Tagged: **[lang]** = compiler/language feature · **[stdlib]** = builtin or runtime · **[lib]** =
> pure-NOVA/Forge library · **[tool]** = tooling. "Forge covers" notes what's already partly there.
> This roadmap adds **capability**; it assumes the prior audit's Wave A (soundness last-mile: 0.11,
> trait-conformance, user-enum payload, `==` NFC/NFD) runs **first** — do not build breadth on a cracked
> foundation.

### Phase 1 — Stdlib "correctness edge" (must-haves; unblock finance/i18n/text; mostly self-contained)

The cheapest high-value breadth, each a bounded library/runtime task with immediate daily payoff:

1. **`BigDecimal` / arbitrary-precision decimal** with rounding modes — **[stdlib/lib]**, L. *(Forge covers
   integer-cents money only.)* THE money/data blocker.
2. **Signed bignum** — **[lib]**, M. Extend `forge_bignum` to negatives (sign + `big_sub` below zero).
3. **Regex capture-group extraction** (numbered + named) — **[stdlib]**, M. Extend the PCRE engine to
   return submatches. *(Forge covers whole-match only.)*
4. **IANA timezone + DST engine** — **[stdlib/lib]**, XL (bundle tzdata + transition rules). *(Forge covers
   fixed-offset only.)* The scheduling/logging blocker.
5. **XML parser** — **[lib]**, L. *(Forge covers emit only.)*
6. **Seedable/deterministic PRNG** — **[stdlib]**, S. Reproducible stream object from a seed.
7. **Argon2id / scrypt / bcrypt** memory-hard KDF — **[lib]**, M. *(Forge covers PBKDF2/HKDF; not memory-
   hard.)* Password-storage best practice; independent of the Sentinel framework.
8. **Extended math builtins** (`isnan`/`isinf`/`fma`/`copysign`/`gcd`/`lcm`/`clamp`) — **[stdlib]**, S.
9. **Binary pack/unpack + endianness codec** — **[stdlib]**, M. Removes per-driver hand-rolling; enables
   file-format work.

### Phase 2 — I/O / OS / networking last-mile (must-have deploy story + high-value app surface)

Mostly small mechanical builtins over syscalls the runtime *already links* (pthread, setsockopt, signal):

10. **OS signal handling** (`on_signal`, graceful shutdown) — **[stdlib]**, M. **Must-have** for any
    deployed server/CLI/container.
11. **HTTP-client redirects + cookie jar + proxy** — **[lib]**, M. *(Forge covers verbs/chunked/SSE.)* The
    most-used app-dev networking surface.
12. **Filesystem glob** — **[stdlib]**, S. Needed by NOVA's own toolchain too.
13. **File permissions + symlinks** (`+x`, 0600) — **[stdlib]**, M. Security-relevant (private-key perms).
14. **Thread sync primitives** (mutex/rwlock/semaphore/barrier) — **[stdlib]**, M.
15. **Unix domain sockets**, **socket options** (`TCP_NODELAY`/`SO_REUSEPORT`), **UDP peer address** —
    **[stdlib]**, S–M. Unblocks sidecars, latency tuning, and UDP servers respectively.

### Phase 3 — Ecosystem connective tissue (must-have for "share code"; unblocks everything downstream)

16. **Wire the transitive dependency resolver into the CLI** (+ `nova.lock`) — **[tool]**, L. *(Prior audit
    Toolchain #10 — the resolver EXISTS, just unwired.)* Do this first; it's cheap and unblocks multi-package.
17. **Docs generator** (`nova doc`, `///` extraction → HTML) — **[tool]**, L. Table stakes for a library
    ecosystem.
18. **Live package registry + publish flow** (Vault) — **[tool/infra]**, XL. External infra; the "build
    ON, not just IN" enabler. Needs the ABI-version load-time check (audit §3.9) first.
19. **Signed one-command installer** (`curl\|sh`/msi/brew/apt) — **[tool]**, M. First-run friction on the
    full-stack identity.

### Phase 4 — Quality & observability tooling (the "robust"/"fast" promises, verifiable by the user)

20. **Property-based testing + mocks + DB-rollback fixtures** — **[tool/lib]**, M. Finds NOVA's own bug
    class; composes on `nova test` + `forge_test`.
21. **Per-`fn` test ergonomics** (discovery/reporting/filter/parallel/diff) — **[tool]**, M.
22. **Profiler** (sampling CPU + flamegraph) — **[tool]**, L. Makes the "fast" promise self-verifiable.
23. **LSP inferer-backed hover/completion + refs/rename** — **[tool]**, L. *(Prior audit §3.6 — the
    inferer's answers already exist on the diagnostics path; wiring job.)*

### Phase 5 — Language ceilings (unlock declarative frameworks; the multiplier for all future libraries)

Sequenced because L1/L2 are the *multiplier* that lets Forge and the sibling frameworks stop hand-
registering and become declarative:

24. **Module-symbol namespacing** (`@mod__fn` mangling + call qualification) — **[lang]**, M. Do early:
    it's a **hard cap on stdlib/ecosystem scale** (L11) and cheap relative to its blast radius.
25. **User-extensible annotations → codegen hook** — **[lang]**, XL. The #1 lever (L1); unblocks the
    type-driven `service` marquee (audit Forge #6), declarative ORM/DI/routing/validation/test-discovery.
26. **Macros / general comptime** (quasi-quote AST) — **[lang]**, XL (L2). Pairs with #25; would also
    erase the compiler's own ~700 hand-built AST sites.
27. **Sized numeric types + `f32` + unsigned** — **[lang]**, M (L7). Unblocks embedded/Edge, wire codecs,
    GPU/graphics interop.
28. **Const generics** (L5, L) + **variance** (L3, L) + **associated types** (L4, XL) — **[lang]**. The
    abstraction ceiling; raises how generic the stdlib/frameworks can be. Const generics also unblock
    fixed-size stack arrays + shape-checked tensors.
29. **Enforced immutability distinction** (L6, M) + **custom index/iterator operators** (L8, M) + **weak-
    ref/Drop language surface** (L10, M) — **[lang]**. Correctness + battery-author ergonomics.

### Phase 6 — Domain libraries: presentation layer (the frontend half of NOVA's own identity)

The highest-leverage breadth hole, but XL and dependent on FFI-callback + WASM-DOM foundations:

30. **Browser DOM/reactive UI runtime (Prism-web / LiveView-in-wasm)** — **[lib]**, XL (G2). Depends on
    WASM productization (audit 5.3). The "one language, real frontend" killer app.
31. **Native GUI toolkit (Prism desktop)** — **[lib/framework]**, XL (G1). Depends on FFI callbacks
    (`@cdecl`, struct-by-value) + a wgpu/window binding. The biggest domain hole.
32. **Image codecs (PNG/JPEG) + 2D canvas** — **[lib]**, L (G3). Self-contained on `deflatex` + `bytes`;
    unblocks avatars/thumbnails/charts/QR and PNG plotting (G10).

### Phase 7 — Domain libraries: wire-protocol clients & documents (cheap high-value; pattern-repeats)

NOVA's proven raw-TCP driver ability (PG/MySQL/Redis/TLS) makes these **pattern-repeats, not new
capability** — the cheapest way to broaden "integrates with everything":

33. **Message-broker clients** (Kafka, NATS, MQTT, AMQP) — **[lib]**, L each (G6).
34. **GCP + Azure cloud SDKs + broader AWS** (SQS/SNS/Lambda/KMS) — **[lib]**, L each (G8).
35. **OpenTelemetry tracing** (spans + `traceparent` + OTLP) — **[lib]**, M (G9). Reuses existing JSON/
    protobuf codecs + Forge middleware.
36. **PDF / office generation** (PDF, XLSX) — **[lib]**, L (G7). PDF self-contained; XLSX = zip + XML.

### Phase 8 — Numeric-at-scale frontier (owns "AI/data"; XL, hardware-gated, interlocking)

Do last — these interlock (train → GPU → dataframe) and each waits on its dependency:

37. **Dataframe / columnar analytics engine (Pulse)** — **[lib]**, L (G5). Viable now that typed float-
    array perf landed.
38. **Autodiff / training (Cortex)** — **[lib+lang]**, XL (G4). Needs a `grad`/backward pass; benefits
    from a `grad` compiler pass. Depends on GPU (audit 5.4) for real training speed.
39. **GPU kernel lowering** (NOVA → SPIR-V/PTX) — **[lang/tool]**, XL. *(Prior audit 5.4.)* The compute
    frontier under G4/G5/Reactor; hardware-gated.
40. **ONNX/GGUF/SafeTensors model loaders** — **[lib]**, L. Lets NOVA *serve* any pre-trained model even
    before training (G4) lands.

**The governing rule** (inherited from the prior audit): *do not start a framework whose blocking core
gap is still open, and do not pour frontier code onto an unclosed soundness hole.* Wave A (soundness) →
Phase 1–2 (stdlib/OS correctness edge, cheap + high-trust) → Phase 3 (ecosystem sharing) → Phase 5's
annotations/macros (the declarative-framework multiplier) → then the domain frameworks in dependency
order. The two investments with the widest blast radius are **(a) user-extensible annotations + macros**
(Phase 5 — turns Forge and all 8 siblings declarative) and **(b) the presentation layer** (Phase 6 —
delivers the frontend half of NOVA's own full-stack identity).
