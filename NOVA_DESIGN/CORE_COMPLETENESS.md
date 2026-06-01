# NOVA Core Completeness — Definition of Done

**Status date:** 2026-06-01
**Scope:** This is the canonical **definition of done for NOVA's CORE language** — the language, its
type/ownership/process model, and the *standard library that every serious general-purpose language
ships in-box*. Frameworks (Forge/Cortex/Mesh/Sentinel/Reactor/Prism/Pulse/Edge/Ops and every
aspirational domain headline) are **explicitly OUT OF SCOPE** here and parked in
`FRAMEWORK_MASTER_PLAN.md`. The bet is simple: NOVA cannot be "best-in-class across all domains"
until the *core* is complete. This document is the gate.

## How to read this

- Features are **deduplicated across all 7 reference languages**. A capability like "closures" or
  "TCP sockets" appears once, with every language that has it listed under **Seen in**.
- **Seen in** abbreviations: `C`, `C++`, `Java`, `Py` (Python), `JS` (JavaScript), `Erl` (Erlang),
  `Elx` (Elixir).
- **Tier**: `table-stakes` (a language without it is incomplete) · `important` (expected by
  practitioners) · `signature` (a defining strength of at least one reference language; where NOVA
  must *win*, not just match).
- **NOVA status** is derived from the verified `STATE_LEDGER.md` (2026-06-01):
  - ✅ **HAVE** — verified real in the self-hosted compiler/runtime.
  - 🟡 **PARTIAL** — exists but with a named gap (type-erased, single-threaded, byte-only, etc.).
  - ❌ **MISSING** — not present in the ledger (anything the ledger does not evidence is MISSING).
- **How NOVA beats it** — the one-phrase advantage from the `nova_target` design intent.

> **Data note:** The reference inventories for C, C++, Java, and Elixir were captured in full. The
> Python, JavaScript, and Erlang inventory agents failed to produce output, so their *feature
> selection* is supplied from authoritative core-language knowledge (these are universally documented
> languages) and their presence is marked conservatively in **Seen in**. The NOVA status is unaffected
> — it comes only from the ledger.

---

## Build progress (live)

Execution started 2026-06-02. Rule: **verify each gap against the real code before building** —
the scorecard's MISSING/0% counts came partly from a conservative ledger and several were stale.

- ✅ **File I/O completeness** (Feature 1, committed `a15b6e2`) — added `remove_file`, `remove_dir`,
  `rename_path`, `copy_file`, `file_size`, `file_mtime`, `is_dir`, `is_file`, `write_bytes`,
  `read_lines`, `temp_dir`. Cross-platform, full error handling, 138/138 regression. (Cat. 12 now
  largely closed; `seek`/`truncate`/mmap still open.)
- ✅ **Time & date** — found ALREADY COMPLETE on verification (14 `datetime_*` builtins fully
  registered + runtime + `track7_datetime_test`). The scorecard's "0%" was wrong. No work needed.
- ⏭ **Next verified-real gaps:** regex `{n}`/`|` (confirmed missing), Unicode-correct strings
  (`len("café")==5`), typed `Result<T,E>` (type-erased today).

---

## 1. Types, literals & syntax

| Feature | Seen in | Tier | NOVA status | How NOVA beats it |
|---|---|---|---|---|
| Fixed-width numeric types (i8..i64/u8..u64/f32/f64/bool/char) with guaranteed widths | C, C++, Java | table-stakes | ✅ HAVE | Infers narrowest sound width from value-range; guaranteed widths so cross-compile never shifts size |
| Integer/float/char/string literals with bases (0x/0o/0b) + digit separators + escapes | C, C++, Java, Py, JS, Erl, Elx | table-stakes | ✅ HAVE | Literals are polymorphic Values; type solved by inference, no suffix noise |
| Multi-line / raw strings (text blocks, heredocs) | C++, Java, Py, JS, Elx | important | 🟡 PARTIAL | Compile-time-checked interpolation inside multi-line text (Java text blocks are untyped) |
| Immutability default + explicit mutability (const/final/let) | C, C++, Java, JS, Erl, Elx | signature | 🟡 PARTIAL | Immutable-by-default Values; mutation only inside an owning Process — `const` is implicit |
| Local + whole-program type inference (`var`/`auto`/`:=`) | C++, Java, Py, JS | important | ✅ HAVE | Hindley-Milner across fields/params/returns — 95% zero annotations, IDE shows inferred type |
| Type aliases AND distinct/newtypes (UserId ≠ Int) | C, C++, Java, Elx | table-stakes | 🟡 PARTIAL | Transparent alias vs distinct type so the compiler catches mixing semantic ints |
| Optional/gradual type annotations that the compiler verifies | Py, Elx | important | 🟡 PARTIAL | `@spec` becomes a constraint checked against inference — no separate Dialyzer pass |
| struct/record (immutable data carrier, structural compare) | C, C++, Java, Elx | signature | ✅ HAVE | Records by default; compiler picks inline-vs-boxed layout; structural eq/hash/inspect derived |
| Tagged unions / sum types / sealed hierarchies (ADTs) | C++, Java, Erl, Elx | signature | ✅ HAVE | Sealed-by-default unions with enforced exhaustive match everywhere |
| Strongly-typed enums carrying data + methods | C++, Java, Elx | table-stakes | ✅ HAVE | Enums are distinct sum types, not assignable from arbitrary ints |
| Tuples + heterogeneous fixed pairs | C++, Py, JS, Erl, Elx | important | ✅ HAVE | Structural tuple Values |
| Atoms / interned symbols | Erl, Elx, JS | important | ❌ MISSING | Interned-symbol Value type with O(1) equality |
| Optionality in the type system (T?) instead of null | C++, Java, Erl, Elx | signature | 🟡 PARTIAL | No null in safe code; `Option` baked in, flow-analysis proves non-null at call sites |
| Bitfields with target-stable layout | C, C++ | important | ❌ MISSING | Pinned MSB/LSB bit layout as a compile-time Value (defeats C's portability nightmare) |
| Designated / named-field initialization with narrowing rejection | C, C++ | important | ✅ HAVE | One record-literal form; narrowing rejected by value-range analysis |
| Pin/match-vs-rebind semantics (`^`) | Erl, Elx | important | ❌ MISSING | Rebind is a new immutable Value (enables dead-value reuse); pin intent statically enforced |

## 2. Functions & closures

| Feature | Seen in | Tier | NOVA status | How NOVA beats it |
|---|---|---|---|---|
| Function definition/declaration, recursion, module-private default | C, C++, Java, Py, JS, Erl, Elx | table-stakes | ✅ HAVE | Auto-private; tail recursion lowered to machine loops (register accumulator) |
| First-class closures capturing the lexical environment | C++, Java, Py, JS, Erl, Elx | signature | ✅ HAVE | Non-capturing closures erase to bare fn pointers; capture set inferred & made Sendable |
| Default + named parameters | C++, Py, Elx | table-stakes | ✅ HAVE | Real defaults collapsed to one specialized entry point per call site |
| Function overloading + deterministic resolution | C++, Java | table-stakes | ❌ MISSING | Full resolution ranking reported on ambiguity (no C++ "error novel") |
| Type-safe variadics | C, C++, Java, Py, JS, Elx | important | ❌ MISSING | Compile-time-expanded variadic generics — kills printf format-string CVEs |
| Function references / partial application / capture operator (`&`) | C, C++, Java, Py, JS, Elx | important | ✅ HAVE | Callable is a Process you send to; statically-known callee = zero heap |
| Must-use enforcement (`[[nodiscard]]`) on error/resource returns | C++ | important | ❌ MISSING | Ignoring a `Result`/resource Value is a compile error by default |
| Guaranteed tail-call optimization | Erl, Elx, JS | signature | ✅ HAVE | TCO lowered to an LLVM loop, matching C loop performance |
| Multi-clause function heads with guards | Erl, Elx | signature | 🟡 PARTIAL | Overlapping clauses compiled to a decision tree with compile-time exhaustiveness warnings |
| Expression-oriented control flow (if/case/cond yield values) | Py, JS, Erl, Elx | table-stakes | ✅ HAVE | Compiler proves `case` exhaustiveness over the inferred Value domain |
| Inlining as a pure optimizer decision (no `inline` keyword) | C, C++ | important | ✅ HAVE | Inline decided from size/profile heuristics; abstractions erase to nothing |

## 3. OOP / polymorphism / interfaces

| Feature | Seen in | Tier | NOVA status | How NOVA beats it |
|---|---|---|---|---|
| Stateful types with constructors + deterministic destructors | C++, Java, Py, JS | signature | 🟡 PARTIAL | All five special members synthesized from field ownership graph — rule-of-5 cannot occur |
| Virtual/dynamic dispatch + abstract interfaces | C++, Java, Py, JS, Elx | signature | ✅ HAVE | Devirtualize when concrete type known — single-impl interfaces cost zero vtable |
| Traits / interfaces with default methods | Java, Elx | signature | ✅ HAVE | Trait composition with explicit conflict resolution; Channel-Sendable methods verified |
| Interface/protocol composition replacing implementation inheritance | C++, Java, Elx | important | ✅ HAVE | `impl Trait for T` gives CRTP-grade static polymorphism without recursive templates |
| Universal Object protocol (equals/hash/toString/inspect) | Java, Py, Elx | table-stakes | 🟡 PARTIAL | Auto-derived structural eq/hash/display; eq/hash consistency guaranteed by compiler |
| Pattern matching with binding/destructuring + guards | C++, Py, Erl, Elx, Java | signature | ✅ HAVE | Nested destructuring + or/range patterns + flow-typing narrowing after match |
| Safe runtime downcast / type identity (RTTI) | C++, Java | important | ❌ MISSING | Exhaustive sum-type match removes most downcasts; runtime type is a typed dynamic Value |
| Protocols — open, retroactive, data-type dispatch with consolidation | Elx, Py, JS | signature | 🟡 PARTIAL | Whole-program devirtualization of ALL protocol calls when concrete type known |
| Associated constants / static members / controlled conversions | C++, Java | important | 🟡 PARTIAL | Module-scoped privacy replaces `friend`; conversions explicit-only by default |

## 4. Generics & metaprogramming

| Feature | Seen in | Tier | NOVA status | How NOVA beats it |
|---|---|---|---|---|
| Parametric generics (function + type), bounded type params | C++, Java, Elx | signature | ✅ HAVE | Type params inferred from call sites; per-instantiation mono-vs-dictionary choice avoids bloat |
| Named, composable type constraints (concepts/traits-as-bounds) | C++, Java | signature | ✅ HAVE | Traits are the only way to write generics — every error points at the unmet requirement |
| Reified / non-erased generics (runtime type info preserved) | C++ | signature | 🟡 PARTIAL | Retain reified type params (Java erases & boxes) while monomorphizing hot paths |
| Variance (declaration-site or use-site) | C++, Java | important | ❌ MISSING | Declaration-site variance *inferred* from usage — developers never write PECS |
| Const-generic / non-type template params (array length in type) | C++ | important | ❌ MISSING | Const-generics via the same comptime-Value machinery; length carried in the type |
| Specialization / type-driven dispatch (SFINAE done right) | C++ | important | ❌ MISSING | Explicit constrained `impl` blocks + `if type T satisfies Trait` |
| Turing-complete compile-time evaluation (constexpr/comptime) | C++, Java, Elx, Erl | signature | 🟡 PARTIAL | Same language runs at compile time when inputs are known — no constexpr keyword split |
| Compile-time type introspection (type traits / `type` is a Value) | C++, Java, Elx | important | ❌ MISSING | Type info is a queryable compile-time Value — `is_integral` is an ordinary function |
| Hygienic AST macros (quote/unquote, code-as-data) | Elx, JS | signature | ❌ MISSING | Macros receive typed AST; compiler verifies macro output is well-typed at expansion |
| Compile-time code injection / mixins (`use`/`__using__`/derive) | Elx, Java | important | ❌ MISSING | Injected code participates in capability inference (proven well-formed at injection site) |
| Conditional compilation by config/target (`#if` / `cfg`) | C, C++, Py | important | 🟡 PARTIAL | Typed compile-time conditions — dead-config branches still type-check |
| Source-location intrinsics (`__FILE__`/`__LINE__`/`__func__`) | C, C++, Elx, JS | table-stakes | ✅ HAVE | Source location is a structured compile-time Value usable by any comptime fn |
| Replace textual preprocessor with semantic module/comptime model | C, C++ | signature | ✅ HAVE | No token-paste/header-guards/hygiene bugs — comptime is debuggable typed code |

## 5. Memory & resource management

| Feature | Seen in | Tier | NOVA status | How NOVA beats it |
|---|---|---|---|---|
| Automatic, safe memory reclamation (no manual free, no UAF) | Java, Py, JS, Erl, Elx | signature | ✅ HAVE | Process-local arenas + ownership erasure → zero-GC C-equivalent for single-process code |
| Deterministic scope-bound resource cleanup (RAII / try-with-resources / `with`) | C++, Java, Py, Elx | signature | ✅ HAVE | Ownership-driven Drop at scope exit / Channel-send — no destructor boilerplate |
| Single/shared/weak ownership (unique/shared/weak ptr) | C++ | signature | 🟡 PARTIAL | Unique by default with zero syntax; refcount erased when single-owner provable |
| Stack vs heap chosen by escape analysis | C, C++ | signature | ✅ HAVE | Escape analysis stack-allocates non-escaping Values automatically |
| Explicit allocators / arenas / pools (pmr) | C, C++, Java | important | 🟡 PARTIAL | Per-Process arenas freed en masse at exit (auto-arena for no-spawn programs is done) |
| Alignment / packing / cache-line control | C, C++ | important | 🟡 PARTIAL | repr(C)/packed available; hot Values auto-aligned to cache lines (false-sharing avoidance) |
| Weak/soft references + post-mortem cleanup hooks | Java, JS | important | ❌ MISSING | Typed Cache Value with compiler-chosen eviction + typed finalization Channel |
| No-alias / restrict guarantees for optimization | C, C++ | important | ✅ HAVE | Process isolation gives restrict-level no-alias everywhere for free |
| Immutable persistent data with structural sharing | Erl, Elx, JS | signature | 🟡 PARTIAL | Uniqueness proven → in-place mutation with immutable source semantics (C-array speed) |
| Process linking / monitoring / resource lifecycle | Erl, Elx | important | 🟡 PARTIAL | Resource ownership is a Channel-boundary property — "who closes this" statically answered |
| Off-heap / direct memory regions (safe) | C, C++, Java | important | 🟡 PARTIAL | First-class Arena Value with compiler-enforced bounds + lifetime (never UB) |

## 6. Concurrency & parallelism

| Feature | Seen in | Tier | NOVA status | How NOVA beats it |
|---|---|---|---|---|
| Lightweight processes / green threads (spawn) | Erl, Elx, Java, Go-class | signature | ❌ MISSING | Processes erased to function calls/threads when they don't distribute — zero scheduler tax |
| Message passing (send/receive) + selective receive + mailbox | Erl, Elx | signature | 🟡 PARTIAL | Typed Channels → selective receive compiles to indexed dispatch (no O(mailbox) scan) |
| OS threads + thread-local storage | C, C++, Java, Py, JS(worker) | signature | 🟡 PARTIAL | `spawn` is the unit; no shared mutable state so no data races by construction |
| Mutexes/locks/condvars/semaphores | C, C++, Java | signature | ❌ MISSING | Channels are the default sync; compiler verifies lock-ordering (deadlock-free) where used |
| Atomics + defined memory model (happens-before) | C, C++, Java, Erl | signature | ❌ MISSING | Happens-before established by Channel send/receive — model trivial by construction |
| Concurrent collections (ConcurrentHashMap / ETS / atomics arrays) | Java, Erl, Elx | important | ❌ MISSING | Channel-fronted shared Value; compiler emits lock-free impl from access pattern |
| Async task launch + future/await + composition | C++, Java, Py, JS, Elx | signature | ❌ MISSING | Future IS a Channel you receive from — one mechanism, errors arrive as values |
| Bounded/back-pressured channels (GenStage/Flow/reactive) | Erl, Elx, Java | important | 🟡 PARTIAL | Bounded typed Channels give back-pressure natively (full channel blocks sender) |
| Auto-parallelized data pipelines (parallel streams/par_unseq) | C++, Java, Elx | important | ❌ MISSING | Compiler auto-parallelizes pure map/reduce; can target CPU or GPU |
| Coroutines / generators (yield) | C++, Py, JS, Elx | signature | ❌ MISSING | A generator is a Process that yields Values onto a Channel — no coroutine_handle machinery |
| GenServer-style stateful server behaviour | Erl, Elx | signature | ❌ MISSING | Generated from a typed Channel protocol; every message proven to have a handler |
| Supervision trees / "let it crash" self-healing | Erl, Elx | signature | ❌ MISSING | Supervision is a Process-graph property the compiler verifies (no unsupervised processes) |
| Structured concurrency (child cannot outlive scope) | Java, Py, Elx | signature | ❌ MISSING | The only model — children cannot outlive spawn scope unless detached via a Channel |
| Hot code reloading / live upgrade | Erl, Elx, Java | signature | ❌ MISSING | Native hot-swap with compiler-verified type-compatible state migration |
| Select/poll over multiple channels/sources | C, Erl, Go-class | important | ❌ MISSING | CSP `select` over Channels — runtime maps to best OS multiplexer (epoll/kqueue/IOCP) |

## 7. Error handling

| Feature | Seen in | Tier | NOVA status | How NOVA beats it |
|---|---|---|---|---|
| Value-based error returns (Result/expected/tagged tuples) | C, C++, Erl, Elx | signature | 🟡 PARTIAL | **Today type-erased to `int` with runtime `exit(1)`** — must become statically-checked `Result<T,E>` |
| Typed `Option<T>` for absence (no null) | C++, Java, Erl, Elx | important | 🟡 PARTIAL | Make Option the *only* way to express absence — eliminates the NPE class language-wide |
| One-word error propagation (`?`) | C++, Erl, Elx | signature | ✅ HAVE | `?` does real cross-function early return; verified live |
| Exceptions with stack unwinding + guaranteed cleanup | C++, Java, Py, JS, Elx | signature | ✅ HAVE | `error`/`catch`/`try` unified; cleanup via ownership Drop |
| Recoverable-vs-fatal distinction + crash isolation | Java, Erl, Elx | table-stakes | 🟡 PARTIAL | Fatal faults crash the Process and are supervised; happy path pays nothing |
| `with`/`else` happy-path chaining | Elx | signature | ❌ MISSING | Sugar over first-class Result; compiler infers union of error shapes & checks else exhaustive |
| Runtime assert + compile-time static_assert + contracts | C, C++, Java, Py, Elx | table-stakes | 🟡 PARTIAL | Contracts discharged statically where provable; assertions carry source-location Value |
| Structured leveled logging + crash reports | Java, Py, Elx | important | 🟡 PARTIAL | Crash reports name the failed Channel protocol & Process role; metadata flows with the Process |
| `errno`/return-code interop without thread-unsafe globals | C | important | ✅ HAVE | Value-based errors, no global `errno`, no "forgot to check" bug class |

## 8. Modules & packaging

| Feature | Seen in | Tier | NOVA status | How NOVA beats it |
|---|---|---|---|---|
| Real module system (file = module, import/as/selective) | C++, Java, Py, JS, Erl, Elx | signature | ✅ HAVE | Semantic imports, no headers/ODR/include-order; true dependency graph |
| Hierarchical namespaces / nested modules | C++, Java, Py, Elx | table-stakes | ✅ HAVE | Names resolved by content, not directory layout; ADL dropped |
| Public/private visibility (export control) | C, C++, Java, Py, Elx | table-stakes | ✅ HAVE | Two clear levels; `_prefix` private; capability-based exposure across Channels |
| Separate + incremental compilation | C, C++, Java, Elx | signature | ✅ HAVE | Precise dependency graph; only changed modules + dependents recompile; merged-IR LTO-by-default |
| Static + dynamic linking, shared libs, symbol visibility | C, C++, Java | important | 🟡 PARTIAL | Stripped static binary by default + C-ABI shared lib with explicit export list |
| Package manager: semver, lockfile, registry | C++(ext), Java(ext), Py, JS, Elx | important | 🟡 PARTIAL | `nova_pkg` has semver/lockfile/**local** registry — **remote registry + network fetch missing** |
| Transitive dependency resolution + reproducible builds | Java, Py, JS, Elx | important | 🟡 PARTIAL | Deterministic resolution; **transitive import resolution + deps/-vs-nova_packages wiring gap** |
| Service/provider discovery (SPI) | Java | important | ❌ MISSING | Compile-time service resolution (static when known, dynamic only when required) |
| `curl \| sh` installer / distribution | Py, JS, Elx, Go-class | important | ❌ MISSING | One-line install; remove residual Java JAR + root `nova.bat` |

## 9. Strings & Unicode

| Feature | Seen in | Tier | NOVA status | How NOVA beats it |
|---|---|---|---|---|
| Length-carrying immutable strings (no NUL reliance) + builder | C, C++, Java, Py, JS, Erl, Elx | signature | ✅ HAVE | O(1) length, bounds-checked, SSO; builder/rope chosen by compiler for concat-heavy code |
| String methods (split/join/trim/case/slice/find/replace/pad) | all | table-stakes | ✅ HAVE | Standard set present and tested |
| UTF-8 native + codepoint/grapheme/byte views (Unicode-correct) | C++, Java, Py, JS, Erl, Elx | important | 🟡 PARTIAL | **Today byte-level: `len("café")==5`, no codepoint/grapheme/case-fold.** Must be UTF-8 with explicit views |
| Unicode normalization (NFC/NFD) + collation + grapheme breaking | Java, Py, JS, Elx | important | ❌ MISSING | Grapheme cluster as default "character"; ASCII fast-path inferred |
| String interpolation / f-strings | C++, Py, JS, Elx | important | ✅ HAVE | Type-checked interpolation (format error = compile error) |
| Compile-time-checked typed formatting (printf replacement) | C, C++, Java, Py | important | ✅ HAVE | `format()` mini-language + f-strings; `%d`-with-string is a compile error |
| Charset encode/decode returning Result on malformed bytes | C, Java, Py | table-stakes | ❌ MISSING | Total conversions returning Result (no silent replacement/throw) |
| Binaries / bitstrings with bit-level pattern matching | Erl, Elx | signature | ❌ MISSING | Binary matchers compiled to branch-free state machines, OOB proven absent — C-speed parsing |

## 10. Collections & iterators

| Feature | Seen in | Tier | NOVA status | How NOVA beats it |
|---|---|---|---|---|
| Growable array/vector + fixed array | C, C++, Java, Py, JS, Erl, Elx | signature | ✅ HAVE | One `List` Value; layout specialized from observed access patterns |
| Hash + ordered map/set | C++, Java, Py, JS, Elx | signature | ✅ HAVE | `Map`/`Set` present; hash derived from key fields automatically |
| Deque / queue / stack / priority queue / ring buffer | C++, Java, Py, Elx | important | ✅ HAVE | Present (deque/pq/sorted-map/LRU/counter/ring-buffer verified) |
| Linked lists | C, C++, Java, Erl, Elx | important | ✅ HAVE | Compiler can choose list layout from access pattern |
| Uniform iteration protocol (iterators/iterable) + for-each | C++, Java, Py, JS, Erl, Elx | signature | ✅ HAVE | Single Sequence Value/Channel; specializes to pointer arithmetic for contiguous data |
| Generic algorithm library (sort/find/transform/reduce, ~100+) | C++, Java, Py, Elx | signature | 🟡 PARTIAL | Methods on any Sequence; auto-parallelize + fuse chained ops into one pass |
| Lazy composable pipelines / streams / views (filter\|map\|take) | C++, Java, Py, JS, Elx | signature | 🟡 PARTIAL | Lazy by default; deforestation fuses; pipelines fan across Processes/Channels |
| Comprehensions (multi-generator, filters, into, reduce) | Py, JS, Elx, Erl | important | 🟡 PARTIAL | Compiler picks eager/lazy/parallel from inferred sizes; binary generators → zero-copy |
| Comparable/Comparator + adaptive sort + binary search | C, C++, Java, Py, Elx | table-stakes | ✅ HAVE | Default structural total order derived; compiler-selected sort (insertion/TimSort/radix) |
| Immutable / unmodifiable collections | Java, Py, JS, Erl, Elx | important | 🟡 PARTIAL | Immutability inferred → Sendable across Channels without copy |
| Non-owning contiguous + multidim views (span/mdspan) | C++ | important | ❌ MISSING | Compiler-tracked borrow that cannot dangle; mdspan shares the tensor view abstraction |
| Deep nested access (`get_in`/`put_in`/path updates) | Elx, JS | important | ❌ MISSING | Path type-checked end-to-end; in-place update when root uniquely owned |

## 11. Numerics & math

| Feature | Seen in | Tier | NOVA status | How NOVA beats it |
|---|---|---|---|---|
| Integer/float arithmetic with defined overflow semantics | C, C++, Java, Py, JS, Erl, Elx | table-stakes | ✅ HAVE | Overflow defined (wrap/checked/saturating per type), never UB; proven-safe checks elided |
| Full math library (sin/cos/sqrt/pow/log/exp, IEEE-754, NaN/Inf) | C, C++, Java, Py, JS, Erl, Elx | table-stakes | ✅ HAVE | Maps to hardware FP/vector; auto-vectorizes array math; scoped fast-math |
| Complex numbers + math constants (π, e) | C++, Py | important | ❌ MISSING | Ordinary Value operations; constants as compile-time Values |
| Bit manipulation (popcount/clz/ctz/rotate) + type limits | C, C++, Java, Py, JS, Erl, Elx | important | ✅ HAVE | First-class bit ops → single hardware instructions; limits are compile-time Values |
| Arbitrary-precision integers (bignum) | Java, Py, Erl, Elx | important | ❌ MISSING | Compiler proves bignum-vs-i64 by range; native i64 when it fits, auto-promote on overflow |
| Decimal / exact / rational arithmetic | Java, Py | important | ❌ MISSING | Money literals infer to decimal, scientific to f64 — no external dependency |
| Quality PRNG (seedable) + cryptographic RNG distinguished | C, C++, Java, Py, JS, Erl, Elx | important | 🟡 PARTIAL | `random_bytes` exists; need CSPRNG-vs-PRNG type distinction + Process-local seeding |
| SIMD-friendly numeric vectors / valarray | C++ | important | 🟡 PARTIAL | Auto-vectorized numeric Value arrays (tensors exist) |
| Compile-time-checked units / dimensional analysis | C++(ratio) | important | ❌ MISSING | Adding meters to seconds is a type error |

## 12. File / OS / process

| Feature | Seen in | Tier | NOVA status | How NOVA beats it |
|---|---|---|---|---|
| Buffered file read/write/append + text & binary | C, C++, Java, Py, JS, Erl, Elx | table-stakes | 🟡 PARTIAL | Files are byte/line Channels; **missing `write_bytes`, seek/truncate, per-line streaming** |
| Filesystem ops: exists/list-dir/mkdir/path-join | C, C++, Java, Py, JS, Elx | table-stakes | ✅ HAVE | `file_exists`/`list_dir`/`mkdir`/`mkdir_p`/`path_join`/`read_bytes` verified |
| Filesystem ops: delete/rmdir/stat/rename/move/copy/temp | C, C++, Java, Py, JS, Elx | table-stakes | ❌ MISSING | All FS ops return Result; capability-gated; async = same API on a Process |
| Memory-mapped files + raw fd + fsync/buffering control | C, C++, Java | important | ❌ MISSING | mmap as a bounds-tracked slice Value; fd lifetime managed by ownership (no leaks) |
| Directory watching / change notification | Java | important | ❌ MISSING | Directory iteration/watch as a Channel of entries |
| Subprocess spawn + stdio redirect + env + exit hooks + signals | C, C++, Java, Py, JS, Erl, Elx | important | ❌ MISSING | External process = a Process with stdio Channels; signals delivered as Channel messages |
| Standard streams (stdin/stdout/stderr) | C, C++, Java, Py, JS, Erl, Elx | table-stakes | ✅ HAVE | Console I/O present; modeled as Channels |
| Freestanding / no-runtime (bare-metal) mode | C | signature | ❌ MISSING | Single-Process NOVA already erases its runtime — same language to bare metal |

## 13. Networking & sockets

| Feature | Seen in | Tier | NOVA status | How NOVA beats it |
|---|---|---|---|---|
| TCP sockets (stream) | C, C++(ext), Java, Py, JS, Erl, Elx | table-stakes | ✅ HAVE | TCP primitive present; a connection IS a typed byte Channel |
| UDP sockets (datagram) | C, Java, Py, Erl, Elx | table-stakes | ✅ HAVE | UDP primitive present; datagram Channel |
| DNS / name resolution + address handling + byte order | C, Java, Py, Erl, Elx | important | 🟡 PARTIAL | Network byte order handled by the Channel serializer; addresses are validated typed Values |
| TLS/SSL (cert verification, SNI, ALPN) | Java, Py, Erl, Elx | important | 🟡 PARTIAL | TLS primitive present; make it a Channel transform `secure(channel)` with safe defaults |
| Active(message-driven) + passive(recv) socket modes + framing | Erl, Elx | important | 🟡 PARTIAL | Length-framed transport exists; active mode = packets as typed Channel messages |
| Scalable multiplexed non-blocking I/O (selectors) | C, C++(ext), Java, Erl | important | ❌ MISSING | Developer writes blocking-style on cheap Processes; runtime multiplexes via epoll/io_uring/IOCP |

## 14. HTTP & WebSockets

| Feature | Seen in | Tier | NOVA status | How NOVA beats it |
|---|---|---|---|---|
| HTTP client (HTTP/1.1 + 2, sync + async) | Java, Py, JS, Erl, Elx | important | ✅ HAVE | HTTP client (http+https) present; sync-or-async by calling Process, no duplicated API |
| HTTP server (request/response, routing) | Java, Py, JS, Erl, Elx | important | 🟡 PARTIAL | Server primitives + Forge routing exist; **`serve()` is single-threaded — must become concurrent** |
| HTTP depth: cookies, sessions, auth, multipart, streaming, middleware | Java, Py, JS, Elx | important | ❌ MISSING | Typed request/response Values; middleware chain; same code targets native or WASM/edge |
| WebSockets (RFC-6455) | Java, Py, JS, Erl, Elx | important | ✅ HAVE | WebSocket implemented; modeled as a typed bidirectional Channel |
| URI parsing/building/encoding | Java, Py, JS, Erl, Elx | important | 🟡 PARTIAL | netutil exists; needs full URI parse/build/query-encode |

## 15. Async / event / non-blocking I/O

| Feature | Seen in | Tier | NOVA status | How NOVA beats it |
|---|---|---|---|---|
| Non-blocking I/O without function coloring (implicit async) | Erl, Elx, Java(Loom) | signature | ❌ MISSING | Every blocking call on a Process is non-blocking under the hood — no async/await coloring |
| Async composition (futures/promises/then) | C++, Java, Py, JS, Elx | important | ❌ MISSING | No separate async API — composition is Channel piping |
| Event loop / reactor over many sources | JS, Py, Erl | important | ❌ MISSING | Reactor is the runtime scheduler; `select` over Channels is the user surface |
| Back-pressured reactive streams | Java, Elx | important | 🟡 PARTIAL | Bounded Channels = native back-pressure (no request(n) protocol) |

## 16. Time & date

| Feature | Seen in | Tier | NOVA status | How NOVA beats it |
|---|---|---|---|---|
| Monotonic + wall clock as distinct types | C, C++, Java, Py, Erl, Elx | table-stakes | ❌ MISSING | `Instant`(monotonic) vs `DateTime`(wall) at the type level — can't subtract across clock adjust |
| Durations + type-safe duration arithmetic | C++, Java, Py, Elx | signature | ❌ MISSING | Durations as inferred Values (no `chrono::duration<…>` verbosity) |
| Calendar / date / time + timezone database | C++, Java, Py, Erl, Elx | important | ❌ MISSING | tz data compile-time-embeddable; cross-tz arithmetic must be explicit |
| Date/time formatting + parsing | C, C++, Java, Py, JS, Elx | table-stakes | ❌ MISSING | Validated typed Values; thread-safe (no `gmtime` static-buffer hazard) |

## 17. Regex & parsing

| Feature | Seen in | Tier | NOVA status | How NOVA beats it |
|---|---|---|---|---|
| Regex engine: classes, quantifiers `* + ?`, anchors, groups | C, C++, Java, Py, JS, Erl, Elx | table-stakes | 🟡 PARTIAL | Real NFA present; **missing `{n}` counted quantifier and `\|` alternation** |
| Regex: named captures, lookaround, Unicode mode, linear-time | Java, Py, JS, Erl, Elx | important | ❌ MISSING | Compile regex literals to a specialized DFA/NFA at build time; RE2-class (no ReDoS) |
| Fast locale-independent number↔text conversion | C, C++, Java, Py, JS, Elx | important | 🟡 PARTIAL | Parsing returns Result (no silent `atoi` 0); format length-aware |
| Tokenizer / scanner | C++, Java, Py, Elx | important | 🟡 PARTIAL | Lexer infra exists internally |
| Parser-combinator / PEG support | Elx, Py(ext) | important | ❌ MISSING | Typed parser-combinators over Sequence Values in core |

## 18. Serialization

| Feature | Seen in | Tier | NOVA status | How NOVA beats it |
|---|---|---|---|---|
| JSON encode/decode | Py, JS, Erl, Elx | important | ✅ HAVE | JSON encode/decode present; derive typed mapping from Value structure (zero-annotation) |
| Compact native binary term format | Java, Erl, Elx | important | 🟡 PARTIAL | length-framed transport exists; need a general derive-able binary codec for any Value |
| Derive-able (de)serialization for any Value (Serde-style) | C++(ext), Erl, Elx | signature | ❌ MISSING | Compile-time reflection derives codecs; same machinery = Channel wire-marshalling |
| Base64 / gzip / zip / deflate codecs | C++(ext), Java, Py, JS, Elx | important | 🟡 PARTIAL | base64 present (crypto); need gzip/zip/deflate |
| Key-value config / properties parsing | Java, Py | important | ❌ MISSING | Structured config as typed Values |
| Safe deserialization (no RCE gadget surface) | Java | important | ✅ HAVE | Deserialization reconstructs data only — never invokes constructors (no Java-style RCE) |

## 19. Testing

| Feature | Seen in | Tier | NOVA status | How NOVA beats it |
|---|---|---|---|---|
| Built-in test runner + assertions + fixtures | Py, Elx | important | ✅ HAVE | `assert_eq/ne/near/true/false`, `test_run`, `test_summary`; 137-test harness |
| Process-isolated parallel test execution | Erl, Elx | important | 🟡 PARTIAL | Tests run in isolated Processes → free parallelism + crash isolation |
| Property-based / fuzz testing | Erl(ext), Elx(ext) | important | ❌ MISSING | Generate inputs from a function's inferred Value domains (no StreamData dep) |
| Doctests (executable doc examples) | Py, Elx | signature | ❌ MISSING | Doctests participate in incremental compilation; output-type checked before running |
| Code coverage | Java(ext), Py, JS | important | ✅ HAVE | LCOV export present |

## 20. FFI / native interop

| Feature | Seen in | Tier | NOVA status | How NOVA beats it |
|---|---|---|---|---|
| C ABI interop (call C, be callable as C) | C, C++, Java, Py, Erl, Elx | signature | ✅ HAVE | Emit/consume C ABI; auto-generate extern-C shims for exports (zero glue) |
| `repr(C)` / layout control for FFI | C, C++, Java | signature | ✅ HAVE | repr(C) implemented; layout is a Value attribute |
| `unsafe` escape-hatch boundary | C++, Erl, Elx | important | ✅ HAVE | Unsafe localizes raw behavior with documented semantics |
| Auto-generate bindings from C headers | Java(jextract), Py | important | ❌ MISSING | Import a `.h`, get typed bounds-checked NOVA signatures |
| Inline assembly + portable SIMD intrinsics | C, C++, Java | important | ❌ MISSING | Auto-vectorize Value arrays (AVX/NEON); raw asm reserved for last-mile in `unsafe` |
| Safe out-of-process native escape hatch (Port) | Erl, Elx | important | ❌ MISSING | Crash-prone native fn auto-isolated in its own Process (NIF speed, Port safety) |
| Transparent distributed cross-node messaging | Erl, Elx | signature | 🟡 PARTIAL | Channels ARE the distribution boundary; type IS the wire contract (length-framed transport exists) |

## 21. Reflection / runtime

| Feature | Seen in | Tier | NOVA status | How NOVA beats it |
|---|---|---|---|---|
| Runtime introspection (fields/methods, dynamic invoke) | Java, Py, JS, Elx | signature | ❌ MISSING | Capability-scoped reflection — "no reflection" code provably free of it (enables AOT/dead-strip) |
| Annotations / decorators / module attributes as metadata | Java, Py, JS, Elx | signature | ❌ MISSING | Annotations run typed compile-time NOVA code over the AST, generating type-checked code |
| Dynamic proxy / interface synthesis | Java, JS | important | ❌ MISSING | Compile-time proxy generation via comptime (zero reflection overhead) |
| Dynamic code loading / eval at runtime | Java, Py, JS, Erl, Elx | important | ❌ MISSING | Gated behind a capability so closed programs dead-strip the metadata tables |
| Low-overhead dynamic-call / atomic-access primitive | Java | important | ❌ MISSING | VarHandle-equivalent atomic ops as typed Channel operations |

## 22. Tooling

| Feature | Seen in | Tier | NOVA status | How NOVA beats it |
|---|---|---|---|---|
| Single optimizing compiler + linker (LTO/PGO) | C, C++, Java | signature | ✅ HAVE | One canonical compiler; whole-program opt via merged IR; ~0.98× C on GATE-5 |
| Built-in build system (incremental + parallel + cross-compile) | C++(ext), Java(ext), Elx | important | ✅ HAVE | `nova_build` (init/build/run/test/fmt/clean, hash cache, cross-compile, idempotent fmt) |
| Rich diagnostics (codes, file:line:col, snippets, suggestions) | C++, Java, Elx | important | ✅ HAVE | rustc-class: error codes, snippets, `help:`, Levenshtein "did you mean?" |
| Canonical formatter (idempotent, opinionated) | Py, JS, Elx | important | ✅ HAVE | gofmt-style single style; idempotence verified; AST/type-aware rewrites possible |
| LSP / IDE language server | C++, Java, Py, JS, Elx | important | ✅ HAVE | Diagnostics + hover + go-to-def + autocomplete |
| Interactive debugger (breakpoints, stepping, inspection) | C, C++, Java, Py, JS, Elx | important | 🟡 PARTIAL | **Today DAP logging stub + lldb shell-out** — needs real breakpoints/stepping/inspection that understands Process/Channel state |
| Profiler (low-overhead, flamegraphs) | C, C++, Java, Py, Elx | important | ✅ HAVE | Flamegraph export; can attribute time per-Process |
| REPL / interactive evaluation | Py, JS, Erl, Elx, Java | important | ❌ MISSING | REPL backed by the same compiler (JIT each entry to native) — Python-like UX, C-like speed |
| Documentation generation from doc-comments | C, C++, Java, Py, Elx | important | ✅ HAVE | 9 markdown docs + 250-entry stdlib API + website |
| Disassembler / IR dumper | C, C++, Java | important | 🟡 PARTIAL | LLVM IR is emitted; needs a user-facing IR-dump/disassemble surface |
| Sanitizers folded into the compiler (no separate instrumented build) | C, C++ | signature | ✅ HAVE | OOB/UAF/overflow proven absent or guarded at compile time — no ASan/UBSan build needed |
| ABI version stamping | C, C++ | important | ✅ HAVE | ABI version stamp present |

---

# SCORECARD

**Total deduplicated core features: 156**

| NOVA status | Count | % |
|---|---|---|
| ✅ HAVE | 66 | 42% |
| 🟡 PARTIAL | 41 | 26% |
| ❌ MISSING | 49 | 31% |
| **Weighted "done"** (HAVE = 1.0, PARTIAL = 0.5) | **86.5 / 156** | **55%** |

## Per-category completion

Completion % = (HAVE + 0.5·PARTIAL) / total in category.

| # | Category | Features | ✅ | 🟡 | ❌ | Completion |
|---|---|---|---|---|---|---|
| 1 | Types, literals & syntax | 16 | 8 | 5 | 3 | **66%** |
| 2 | Functions & closures | 11 | 7 | 1 | 3 | **68%** |
| 3 | OOP / polymorphism / interfaces | 9 | 4 | 4 | 1 | **67%** |
| 4 | Generics & metaprogramming | 13 | 3 | 3 | 7 | **35%** |
| 5 | Memory & resource management | 11 | 3 | 6 | 2 | **55%** |
| 6 | Concurrency & parallelism | 15 | 0 | 3 | 12 | **10%** |
| 7 | Error handling | 9 | 3 | 5 | 1 | **61%** |
| 8 | Modules & packaging | 9 | 4 | 3 | 2 | **61%** |
| 9 | Strings & Unicode | 8 | 4 | 1 | 3 | **56%** |
| 10 | Collections & iterators | 12 | 5 | 5 | 2 | **63%** |
| 11 | Numerics & math | 9 | 3 | 2 | 4 | **44%** |
| 12 | File / OS / process | 8 | 3 | 1 | 4 | **44%** |
| 13 | Networking & sockets | 6 | 2 | 3 | 1 | **58%** |
| 14 | HTTP & WebSockets | 5 | 2 | 2 | 1 | **60%** |
| 15 | Async / event I/O | 4 | 0 | 1 | 3 | **13%** |
| 16 | Time & date | 4 | 0 | 0 | 4 | **0%** |
| 17 | Regex & parsing | 5 | 0 | 3 | 2 | **30%** |
| 18 | Serialization | 6 | 2 | 2 | 2 | **50%** |
| 19 | Testing | 5 | 2 | 1 | 2 | **50%** |
| 20 | FFI / native interop | 7 | 3 | 1 | 3 | **50%** |
| 21 | Reflection / runtime | 5 | 0 | 0 | 5 | **0%** |
| 22 | Tooling | 12 | 9 | 2 | 1 | **83%** |

**Reading the scorecard:** NOVA's *sequential single-process* language is largely done — types,
functions, OOP, modules, collections, error propagation, strings, and tooling all sit in the 55–83%
band, and tooling is the strongest area (83%). The catastrophic holes are exactly the things that make
the **Three Primitives** vision real: **Concurrency & parallelism (10%)**, **Async I/O (13%)**, and the
two domains with literally **0% — Time/Date and Reflection/runtime**. Concurrency is the single
biggest risk: NOVA has Channels-as-transport primitives and a process-isolated *memory* model, but the
ledger evidences **no real lightweight-process runtime, no scheduler, no spawn, no supervision, no
async** — `forge.serve()` is single-threaded. A language whose entire thesis is "Processes + Channels"
cannot ship its core with a 10% concurrency score.

---

# TOP PRIORITY GAPS

These are the **table-stakes and signature items** (❌ MISSING or 🟡 PARTIAL) that block NOVA from
being a complete core language. Ordered by leverage — earlier items gate later work and gate the
frameworks.

1. **Concurrent / async runtime (lightweight Processes + scheduler + spawn).** *(Concurrency,
   signature, ❌)* The entire vision rests on Processes and Channels, yet there is no real runtime:
   no green-process scheduler, no `spawn` that runs, no async. `forge.serve()` is single-threaded.
   This gates almost every other gap (HTTP scale, async I/O, supervision, distributed). **The
   highest-leverage work in the whole project.**

2. **Typed `Result<T,E>` / `Option<T>` in the type system.** *(Error handling, signature, 🟡)*
   Errors are currently erased to `int` with a runtime `exit(1)` on mismatch. Until errors are
   statically checked, NOVA loses to Rust, C++ (`expected`), and even Go on safety, and exhaustive
   error handling is impossible.

3. **Unicode-correct strings.** *(Strings, important, 🟡)* Everything is byte-level today —
   `len("café") == 5`, no codepoint/grapheme awareness, no non-ASCII case folding, byte-only regex.
   Every modern language (Java/Py/JS/Erl/Elx) is Unicode-correct; this is table-stakes.

4. **File-I/O completeness.** *(File/OS, table-stakes, ❌/🟡)* Missing delete/rmdir, stat
   (size/mtime/perms), rename/move, copy, temp files, `write_bytes` (binary write), seek/truncate,
   and per-line file streaming (`read_line` is stdin-only). Real apps cannot ship without these.

5. **Time & date library (currently 0%).** *(Time, table-stakes, ❌)* No monotonic/wall clock
   distinction, no durations, no calendar/timezone, no formatting/parsing. Every reference language
   ships this; NOVA ships none of it.

6. **HTTP depth + concurrent serve.** *(HTTP, important, 🟡/❌)* Single-threaded server (gated on #1),
   plus missing cookies, sessions, auth, multipart uploads, streaming/chunked responses, middleware
   chain, and request timeouts. Blocks the full-stack first-run identity.

7. **Regex completeness.** *(Regex, table-stakes, 🟡)* Missing `{n}` counted quantifiers and `|`
   alternation — both table-stakes regex features the source itself admits are unsupported.

8. **Compile-time metaprogramming + reflection.** *(Generics/Metaprogramming + Reflection, signature,
   ❌)* No hygienic macros, no compile-time reflection, no derive. Reflection/runtime is at 0%. This is
   load-bearing for serialization derive, ORM/DI-class patterns, and is a Java/Elixir signature
   strength NOVA must answer.

9. **OS subprocess + signals + select/poll multiplexing.** *(File/OS + Concurrency, important, ❌)*
   No subprocess spawning with stdio Channels, no signal-as-message delivery, no multi-source `select`.
   Needed for real systems/tooling work and gated partly on #1.

10. **DB driver layer + remote package registry.** *(Modules/packaging + persistence, important, 🟡)*
    SQL is string-concatenated (injection-prone) with no connection/parameter-binding abstraction;
    the package registry is local-only with no network fetch or transitive resolution. Both block
    others from actually building and shipping on NOVA.

**Honorable mention (signature gaps that define the vision, just below the cut):** supervision trees /
"let it crash" self-healing (Concurrency, ❌), bignum + decimal numeric tower (Numerics, ❌), and
derive-able Serde-style serialization (Serialization, ❌). These are where NOVA *wins* once #1 lands —
prioritize them immediately after the runtime exists.
