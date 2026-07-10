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
