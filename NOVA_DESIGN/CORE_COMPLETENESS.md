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

**Shipped tonight (each: production-grade, cross-platform, fully wired across all 4 builtin sites,
bootstrap-reconverged gen5==gen6 byte-identical, full regression green before commit):**

- ✅ **File I/O completeness** (committed `a15b6e2`) — `remove_file`, `remove_dir`, `rename_path`,
  `copy_file`, `file_size`, `file_mtime`, `is_dir`, `is_file`, `write_bytes`, `read_lines`,
  `temp_dir`. (Cat. 12; `seek`/`truncate`/mmap still open.)
- ✅ **Regex `{n}`/`{n,m}`/`{n,}` counted quantifiers** (committed `0d16e68`) — exact/range/at-least-n,
  deep-copying class sets to avoid double-free. Runtime-only. (Cat. 17.)
- ✅ **Unicode codepoint views + numerics** — *Batch A* (committed `f07dc1b`, 139/139) — `char_count`,
  `char_at`, `code_points`, `from_codepoint`, `is_valid_utf8` (UTF-8 codepoint layer, additive — byte
  `len`/`ord` unchanged); `sinh`/`cosh`/`tanh`/`cbrt`/`hypot`/`gcd`/`lcm`/`pi`/`e`/`fmod`. Also fixed
  `fmod` (was name-mapped+declared+classified but never type-registered → would fail type-check). (Cats. 9, 11.)
- ✅ **OS / process** — *Batch B* (committed `f5eae3f`, 140/140) — `chdir`, `getpid`, `which`
  (cross-platform PATH resolution). Plus a **soundness fix**: pre-existing `set_env` returned
  `0`=success/`-1`=fail — backwards under NOVA truthiness (0 is falsy, so `if set_env(...)` read
  inverted). Now `1`=success/`0`=fail, consistent with `chdir`/`mkdir_p`/file ops. (Cat. 12.)
- ✅ **Networking identity** — *Batch C* (committed `198c943`, 141/141) — `dns_resolve(host)→str`
  (forces AF_INET, strict-aliasing-safe via memcpy, `""`-on-failure), `hostname()→str`. Closes the
  DNS row. (Cat. 13.)
- ✅ **Bit manipulation** — *Batch D* (committed `47af07c`, 147/147) — `popcount`, `clz`, `ctz`
  (0 guarded to 64, no UB), `rotl`, `rotr` (count masked 0..63, no shift-by-64 UB). Closes the cat-11
  bit-ops row that the audit caught the doc *claiming* but not having. Also added the 5 verified
  concurrency tests (`async`/`select`/`select_multi`/`yield`/`parallel`) to the regression. (Cat. 11.)

**Shipped tonight — pure-NOVA stdlib (no bootstrap; self-contained `.nova` modules, exhaustive inline
tests) + the regex `|` rewrite:**

- ✅ **Ordered search + integer numerics** — *Batch E* `corex.nova` (committed `b6a3e02`, 148/148) —
  `binary_search`/`lower_bound`/`upper_bound`/`count_sorted`/`contains_sorted`; `sign`/`clamp_int`/
  `isqrt` (exact integer Newton)/`ilog2`/`next_pow2`. **Closes the cat-10 `binary_search` honesty debt.**
- ✅ **URL / web encoding** — *Batch F* `urlx.nova` (committed `99ca666`, 149/149) — `url_encode`/
  `url_decode` (RFC-3986, byte-level so UTF-8 round-trips), `parse_query`/`build_query`, `html_escape`
  (anti-XSS). **Closes the cat-14 URI row.**
- ✅ **CSV + config parsing** — *Batch G* `csvx.nova` (committed `6841eee`, 150/150) — `parse_csv_line`/
  `parse_csv`/`csv_field` (RFC-4180-ish: quotes, embedded commas, doubled-quote escaping, CRLF),
  `parse_config` (key=value, `#`/`;` comments). **Closes the cat-18 config row.**
- ✅ **Regex `|` alternation** (committed `a449401`, 151/151) — the `|` case was a **stub** (emitted a
  literal `|`); now a real `SPLIT(A,B); A; JMP(END)` with bounded index-fixup (`re_bump`) for the
  absolute-index VM. Handles `a|b|c`, grouped `(cat|dog)s`, nested `(a|b)|c`, anchored, quantified
  branches. Runtime-only, 35-case test. **cat-17 regex-engine row PARTIAL→HAVE.**
- ✅ **Collection helpers** — *Batch H* `collx.nova` (`take`/`drop`/`chunk`/`zip`/`unique`/`windows`/
  `flatten1`/`count_elem`/`reverse_list`/`sum_int`). Strengthens cat-10 functional algorithms.

**Verified audit (2026-06-02):** ran a 22-agent evidence-based audit of every feature against the
*self-hosted* codebase, then **independently re-verified every load-bearing claim myself** (read the
runtime, ran the cited tests through `gen3_test.exe`). Findings rewrote the scorecard in BOTH
directions — see **"Verified audit"** below. Headline correction: the prior ledger's "Concurrency 10% /
Async 13% / Time-Date 0%" was **stale** — real thread-pool `spawn` (with process-isolation-by-deep-copy),
channels, `select`, `async`/`await`, `pmap`/`pfilter`, and `yield` generators all exist and pass tests.
The *only* true 0% is **Reflection/runtime**.

- ⏭ **Next (deferred to a user-present session — too risky to rush autonomously):** regex `|`
  alternation (the VM uses absolute pc indices, so `|` needs a recursive-descent rewrite, not
  fixup-laden insertion); typed `Result<T,E>`/`Option<T>` in the type system (deep type-system
  change); Unicode-correct `len`/indexing (high blast radius).

---

> **Authoritative status note (2026-06-02):** the per-row **NOVA status** cells in sections 1–22 below
> are the original 2026-06-01 snapshot, kept for context. Where the **VERIFIED AUDIT** section (above)
> lists a discrepancy, *that* evidence-backed status is authoritative and supersedes the cell. The
> SCORECARD and per-category table reflect the verified numbers. When in doubt, trust the audit section.

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

**Verified 2026-06-02** by 22-agent evidence-based audit + independent re-verification of every
load-bearing claim (ran the cited tests through the self-hosted `gen3_test.exe`, read the runtime).
The earlier headline said "156" but the per-category table actually summed to **189** — that
inconsistency is now resolved; 189 is the real deduplicated feature count.

**Total deduplicated core features: 189**

| NOVA status | Count | % |
|---|---|---|
| ✅ HAVE | 79 | 42% |
| 🟡 PARTIAL | 55 | 29% |
| ❌ MISSING | 55 | 29% |
| **Weighted "done"** (HAVE = 1.0, PARTIAL = 0.5) | **106.5 / 189** | **56%** |

The audit's corrections roughly cancelled, but the *composition* changed materially and the
*narrative* changed completely (see below); the number is now **evidence-backed**, not aspirational.
Then tonight's batches moved it from 55%→56% by closing real rows: **Batch D** bit-ops (cat-11 2→3
HAVE), **Batch E** `binary_search` (cat-10 PARTIAL→HAVE), **Batch F** URI encoding (cat-14 PARTIAL→HAVE),
**Batch G** config parsing (cat-18 MISSING→HAVE), and the **regex `|`** rewrite (cat-17 PARTIAL→HAVE).
Every one is backed by a passing test in the 151-test regression.

## Per-category completion

Completion % = (HAVE + 0.5·PARTIAL) / total in category.

Verified status (✅ HAVE / 🟡 PARTIAL / ❌ MISSING) per the 2026-06-02 audit. Arrows mark the
categories the audit corrected vs. the stale 2026-06-01 snapshot.

| # | Category | Features | ✅ | 🟡 | ❌ | Completion | vs prior |
|---|---|---|---|---|---|---|---|
| 1 | Types, literals & syntax | 16 | 8 | 5 | 3 | **66%** | = |
| 2 | Functions & closures | 11 | 6 | 2 | 3 | **64%** | ↓ named-params not real |
| 3 | OOP / polymorphism / interfaces | 9 | 4 | 4 | 1 | **67%** | = |
| 4 | Generics & metaprogramming | 13 | 3 | 2 | 8 | **31%** | ↓ src-loc/cfg not real |
| 5 | Memory & resource management | 11 | 4 | 6 | 1 | **64%** | ↑ |
| 6 | Concurrency & parallelism | 15 | 5 | 5 | 5 | **50%** | ⇈ **was 10% (stale)** |
| 7 | Error handling | 9 | 3 | 5 | 1 | **61%** | = |
| 8 | Modules & packaging | 9 | 4 | 3 | 2 | **61%** | = |
| 9 | Strings & Unicode | 8 | 4 | 2 | 2 | **63%** | ↑ codepoint views added |
| 10 | Collections & iterators | 12 | 5 | 5 | 2 | **63%** | ↑ binary_search added (Batch E) |
| 11 | Numerics & math | 9 | 3 | 3 | 3 | **50%** | ↑ π/e found; popcount/clz/ctz/rotate added (Batch D) |
| 12 | File / OS / process | 8 | 4 | 1 | 3 | **56%** | ↑ FS-ops + OS added |
| 13 | Networking & sockets | 6 | 2 | 3 | 1 | **58%** | DNS now real |
| 14 | HTTP & WebSockets | 5 | 3 | 1 | 1 | **70%** | ↑ URI encode/parse added (Batch F) |
| 15 | Async / event I/O | 4 | 2 | 1 | 1 | **63%** | ⇈ **was 13% (stale)** |
| 16 | Time & date | 4 | 1 | 2 | 1 | **50%** | ⇈ **was 0% (stale)** |
| 17 | Regex & parsing | 5 | 1 | 0 | 4 | **20%** | ↑ regex engine now full ({n}+`\|` done) |
| 18 | Serialization | 6 | 2 | 1 | 3 | **42%** | ↑ key=value config parsing added (Batch G) |
| 19 | Testing | 5 | 2 | 0 | 3 | **40%** | ↓ no process isolation |
| 20 | FFI / native interop | 7 | 3 | 1 | 3 | **50%** | = |
| 21 | Reflection / runtime | 5 | 0 | 0 | 5 | **0%** | = (the only true 0%) |
| 22 | Tooling | 12 | 10 | 2 | 0 | **92%** | ↑ REPL is real |

**Reading the scorecard (corrected by the 2026-06-02 audit):** NOVA's *sequential single-process*
language is largely done — types, functions, OOP, modules, collections, error propagation, strings,
and tooling all sit in the 56–92% band, and tooling is the strongest area (92%).

The big correction: **Concurrency is NOT the catastrophic hole the prior ledger claimed.** It audited
at **50%, not 10%** — and I independently verified it: `nova_rt_spawn` lazily inits a real OS-thread
pool and runs the spawned process on it with its *own deep-copied environment* (process isolation by
construction, not by annotation); `nova_rt_channel_create/send/recv`, `nova_rt_select`, `nova_rt_async/
await/await_all/await_any`, and `nova_rt_pmap/pfilter/pfor` (real `pthread_create`/`CreateThread` +
join) are all present; and `spawn_test`, `async_test`, `select_test`, `select_multi_test`, `yield_test`,
`parallel_test` **all pass through the self-hosted compiler**. The old "forge.serve() is single-threaded,
no spawn that runs" claim was auditing a stale snapshot. Likewise **Async I/O is 63% not 13%** (async
composition + event-loop/select are real) and **Time/Date is 50% not 0%** (`datetime.nova`: 14 builtins,
formatting/parsing, calendar helpers, `track7_datetime_test` passes).

What remains genuinely weak, and is honest: **Reflection/runtime (0% — the only true zero)**;
**Regex & *parsing* (10%)** — the regex *engine* is solid (classes/quantifiers/`{n}`/anchors/groups,
tested) but `|` alternation, a user-facing tokenizer, `Result`-returning number parsing, and
parser-combinators are missing; **Generics & metaprogramming (31%)** — no macros/comptime/reflection
derive; **Serialization (33%)** — JSON is real but Serde-style derive + gzip/deflate are missing;
**Testing (40%)** — runner + assertions are real but test execution is sequential (no process
isolation). The concurrency *primitives* are real; what's still missing on top of them is the
*structured* layer — **supervision trees, structured concurrency, GenServer, bounded channels** — and
that, plus typed `Result<T,E>`, is the honest remaining core work.

**The thesis holds:** a language built on "Processes + Channels" now actually has working processes and
channels — verified, not promised.

---

# VERIFIED AUDIT — every discrepancy (2026-06-02)

Method: 22 parallel agents re-checked each category's rows against the **self-hosted** codebase
(`nova_runtime.c`, `nova_compiler.nova`, the `.nova` tests run through `gen3_test.exe`) — NOT the dead
Java/Kotlin bootstrap. I then **personally re-verified every load-bearing claim** (read `nova_rt_spawn`/
the thread pool; ran the cited concurrency tests; grepped to confirm each absence). Every row below has
concrete evidence.

### ⇧ Stale-PESSIMISTIC — the doc undersold what's real (corrected upward)

| Cat | Feature | was → now | Evidence (verified) |
|---|---|---|---|
| 6 | Message passing / selective receive | 🟡→✅ | `nova_rt_channel_create/send/recv` (2514/2557/2618), `nova_rt_select` (2745); `select_test`, `select_multi_test` pass |
| 6 | Async task + future/await + compose | ❌→✅ | `nova_rt_async/await/await_all/await_any` (7285+); `async_test` passes |
| 6 | Auto-parallel data pipelines | ❌→✅ | `nova_rt_pmap` (rt 7518 / compiler 2894), dynamic thread-count by CPU/size; `parallel_test`: "pmap correctness: OK" |
| 6 | Select/poll over many channels | ❌→✅ | `nova_rt_channel_select` (2705) / `nova_rt_select` (2745); `select_test` passes |
| 6 | Coroutines / generators (yield) | ❌→🟡 | `yield` parsed (1042/1293), codegen 8015; `yield_test` → `[0,1,2,3,4]` |
| 6 | Supervision trees | ❌→🟡 | `nova_rt_monitor` (3379) registers listeners; `process_link/exit_notify` (9383+) are **stubs** (log-only, no restart) |
| 6 | Hot code reload | ❌→🟡 | `nova_rt_hot_reload_watch/check/path` (10732+) exist; mtime/migration **not** implemented (infra only) |
| 12 | Buffered read/write/append (text+binary) | 🟡→✅ | `read/write/append_file` + `read_bytes/write_bytes/read_lines`; `file_io_test` passes |
| 12 | FS ops delete/rmdir/stat/rename/copy/temp | ❌→✅ | 9 builtins (Batch A); `file_io_test` exercises all; passes |
| 12 | Subprocess + env + pid | ❌→🟡 | `spawn`/`exec`/`set_env`/`getpid`/`chdir`/`which`; `os_test` passes. Missing: stdio-as-Channels, signals |
| 15 | Async composition (futures/then) | ❌→✅ | `nova_rt_async/await/await_all`; `async_test` |
| 15 | Event loop / reactor | ❌→✅ | `nova_rt_select/channel_select`; `select_test`/`select_multi_test` |
| 16 | Date/time formatting + parsing | ❌→✅ | `datetime.nova` `dt_format_*`; `datetime_parse` registered; `track7_datetime_test` passes |
| 16 | Durations; Calendar/tz | ❌→🟡 | `dt_diff_ms/add_days/add_seconds`, `dt_to_parts/day_name/is_leap_year` (untyped ints, UTC-only) |
| 9 | Charset encode/decode | ❌→🟡 | `str_to_bytes/bytes_to_str` exist but return values, not `Result` |
| 11 | Complex + math constants (π, e) | ❌→🟡 | `nova_rt_pi/e` (3722); no `Complex` type |
| 5 | (ownership/persistent rows) | →↑ | RC + escape analysis + spawn deep-copy isolation verified |
| 22 | REPL / interactive eval | ❌→✅ | **`repl.nova`** (self-hosted: stdin loop, session accretion, compiles each entry with the real compiler). *Audit mis-cited `Repl.kt` (dead Kotlin); the real evidence is `repl.nova`.* |

### ⇩ Stale-OPTIMISTIC — the doc oversold; corrected downward (these matter most for honesty)

| Cat | Feature | was → now | Evidence (verified absence) |
|---|---|---|---|
| 2 | Default **+ named** parameters | ✅→🟡 | defaults work (`defaults_test`); **named-argument calls** not in parser/codegen/tests (grep: 0) |
| 4 | Source-location intrinsics `__FILE__`/`__LINE__` | ✅→❌ | no user-facing builtin (grep: 0); only internal compiler tracking |
| 4 | Conditional compilation (`cfg`/`#if`) | 🟡→❌ | no `cfg`/`#if`/typed compile-time conditions found |
| 10 | Linked lists (as a type) | ✅→🟡 | no `LinkedList` type; only "compiler may pick layout" prose |
| 10 | Comparable + **binary search** | ✅→🟡→✅ | was absent; **CLOSED in Batch E** (`b6a3e02`): `binary_search`/`lower_bound`/`upper_bound` in `corex.nova`, tested |
| 11 | Bit ops **popcount/clz/ctz/rotate** | ✅→🟡→✅ | was absent; **CLOSED in Batch D** (`47af07c`): `popcount`/`clz`/`ctz`/`rotl`/`rotr` added, `bit_ops_test` passes. Doc claim is now true. |
| 17 | Number↔text conversion (Result) | 🟡→❌ | `parse_int/parse_float` = `atoll`/`atof`, silent 0 on fail, no `Result` |
| 17 | Tokenizer / scanner | 🟡→❌ | lexer is **compiler-internal only**; no user-facing builtin |
| 18 | Compact binary term format | 🟡→❌ | no reusable codec; only ad-hoc length-framing in one demo |
| 18 | Safe deserialization | ✅→🟡 | true for JSON only; general derive-(de)serialize doesn't exist |
| 19 | Process-isolated parallel tests | 🟡→❌ | `nova_rt_test_run` calls `fn()` directly — sequential, **zero isolation** |

**Lesson recorded:** the stale-pessimistic rows came from auditing an old snapshot; the stale-optimistic
rows came from crediting "How NOVA beats it" *aspiration* as if it were *implementation*. Both are now
evidence-gated. This is why the rule is **verify each claim against the self-hosted code before writing it.**

---

# TOP PRIORITY GAPS

These are the **table-stakes and signature items** (❌ MISSING or 🟡 PARTIAL) that block NOVA from
being a complete core language. **Re-ordered 2026-06-02 after the audit** — the old #1 ("no concurrent
runtime / no spawn") was *stale*: the lightweight-process runtime, channels, `select`, `async`, and
parallel map already exist and pass tests. What remains is the *structured* layer on top, plus the
items below. Ordered by leverage.

1. **Typed `Result<T,E>` / `Option<T>` in the type system.** *(Error handling, signature, 🟡)* **Now
   the single highest-leverage gap.** Errors are erased to `int` with a runtime `exit(1)` on mismatch;
   result-returning fns declare `-> int`. Until errors are statically checked, NOVA loses to Rust, C++
   (`expected`), and even Go on safety, and exhaustive error handling is impossible. (Deep type-system
   change — do it carefully, user-present.)

2. **Structured concurrency layer on the existing runtime.** *(Concurrency, signature, 🟡/❌)* The
   *primitives* are real (spawn/channels/select/async/pmap — verified). Missing is the *structure*:
   **supervision trees / "let it crash"** (today `monitor` registers listeners but `link`/`exit` are
   log-only stubs — no restart), **structured concurrency** (child-outlives-scope prevention),
   **GenServer-style** typed servers, and **bounded/back-pressured channels**. This is where NOVA's
   Erlang-beating thesis is *won* — and it's now a far smaller lift than the old ledger implied.

3. **Compile-time metaprogramming + reflection.** *(Generics 31% / Reflection 0%, signature, ❌)* No
   hygienic macros, no comptime evaluation surface, no compile-time reflection, no `derive`.
   Reflection/runtime is the only true **0%**. Load-bearing for serialization derive (#6), ORM/DI
   patterns, and is a Java/Elixir/Zig signature strength NOVA must answer the NOVA way (typed comptime).

4. **Unicode-correct `len`/indexing.** *(Strings, important, 🟡)* Codepoint **views** now exist
   (`char_count`/`char_at`/`code_points`/`from_codepoint`/`is_valid_utf8`, Batch A) — but default
   `len`/indexing/`ord`/`chr`/regex are still **byte-level** (`len("café")==5`), and there's no
   grapheme/normalization/non-ASCII case-fold. Decide the default-view semantics (high blast radius).

5. **HTTP depth + thread-pooled serve.** *(HTTP, important, 🟡/❌)* The thread pool now exists, so
   `serve()` should dispatch each connection onto it (no longer gated on a missing runtime). Still
   missing: cookies, sessions, auth, multipart uploads, streaming/chunked responses, middleware chain,
   request timeouts. Blocks the full-stack first-run identity.

6. **Serialization derive + compression.** *(Serialization 33%, signature, ❌)* JSON encode/decode is
   real; missing is Serde-style **derive-(de)serialize for any Value** (gated on #3 reflection/comptime)
   and **gzip/deflate/zip** codecs. The derive machinery is the same one that marshals Channel wire data.

7. **Regex parsing surface.** *(Regex/parsing 20%, table-stakes, 🟡/❌)* The regex **engine is now
   complete** — `{n}` (`0d16e68`) and `|` alternation (`a449401`) both **done**, so classes/quantifiers/
   anchors/groups/counted/alternation all work. Remaining in this category: a user-facing **tokenizer**,
   **`Result`-returning number parsing** (today `atoll`/`atof` silently return 0), and parser-combinators.

8. **DB driver layer + remote package registry.** *(Modules/persistence, important, 🟡)* SQL is
   string-concatenated (injection-prone) with no connection/parameter-binding abstraction; the package
   registry is local-only (no network fetch / transitive resolution). Both block others shipping on NOVA.

9. **Numeric + collection table-stakes.** *(Numerics/Collections, important, 🟡)* bit ops
   popcount/clz/ctz/rotate — **DONE** (Batch D, `47af07c`); `binary_search`/`lower_bound`/`upper_bound`
   — **DONE** (Batch E, `b6a3e02`). Remaining: bignum + decimal numeric tower (deep — auto-promote on
   i64 overflow). Honesty debt on the small table-stakes items is now largely cleared.

10. **OS subprocess depth + file seek.** *(File/OS, important, 🟡/❌)* `spawn`/`exec`/`set_env`/`getpid`/
    `chdir`/`which` exist; missing is **subprocess stdio-as-Channels**, **signal-as-message** delivery,
    and file **seek/truncate/mmap**.

**Process-isolated test execution** *(Testing, 🟡→❌)* — `test_run` is sequential with zero isolation
despite the "tests run in isolated Processes" claim; an easy win once #2's spawn-per-test is wired.
