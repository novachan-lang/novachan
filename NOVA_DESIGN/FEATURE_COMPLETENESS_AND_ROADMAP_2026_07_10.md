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
