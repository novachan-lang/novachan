# NOVA — Verified State Ledger (2026-06-01)

**Purpose:** The honest, evidence-verified record of what is COMPLETED vs NOT in NOVA
today. Built by auditing the self-hosted codebase (`nova_compiler.nova`,
`output/nova_runtime.c`, the 137-test regression suite, `docs/`) against an external
critique. Every line below was checked against real files, not memory.

**Headline:** The external critique largely audited the *old Java-bootstrap, design-doc-era*
NOVA. The current **self-hosted** compiler (`gen3_test.exe`, native PE32+, ~0.98× C,
137/137 tests) is far more complete than that critique claimed. Roughly half its
"blocking" items are already done. The genuinely-missing items are finite and listed
below — those are the real work. **Do not spend effort "fixing" the stale non-problems.**

---

## ✅ COMPLETED — verified real

### Language & compiler
- Self-hosted compiler: `nova_compiler.nova` (~12k LOC) → LLVM IR → clang → native; deterministic byte-identical bootstrap; ~0.98× C on GATE-5 (primes 0.87×, sieve 1.07×, matmul 0.99×).
- Hindley-Milner type inference; generics (compile-time erased, uniform i64 slots); traits (bounds, default methods, dynamic dispatch, operator overloading).
- Pattern matching (exhaustive), closures, default args, modules (`import`/`as`/selective, merged IR — verified live on 4 multi-file tests).
- **Diagnostics are rustc-class** (critique WRONG): error codes (E0001, E0010-13, E1000-E1012, E1003), `file:line:col`, source snippets, `help:` text, Levenshtein "did you mean?".

### Error handling (functionally real, type-unsafe)
- `error`/`catch`/`try`/`?` unified; `?` does real cross-function early-return propagation (verified).
- `Result`/`Option` runtime value type (`NovaResult{tag,value}`) + ~15 combinators (ok/err/some/none/is_ok/unwrap/unwrap_or/map/and_then/…).
- ⚠️ **Gap:** type-ERASED — result-returning fns still declare `-> int`; `unwrap` mismatch is runtime `exit(1)`, not a compile error. No statically-typed `Result<T,E>`/`Option<T>`.

### Stdlib & runtime
- Strings: split/join/trim/upper/lower/slice/find/replace/pad/center; **`format()`** Python-style mini-language; **f-string interpolation** over arbitrary expressions (critique WRONG on "no format").
- Regex: real backtracking NFA — char classes/ranges, `* + ?`, anchors, `\d \w \s`, groups (6 builtins, tested).
- File I/O: read/write/append, `file_exists`, **`list_dir`** (critique WRONG on "can't list a dir"), `read_bytes`, `mkdir`/`mkdir_p`, `path_join`.
- Collections: list/dict/set/deque/priority-queue/sorted-map/LRU/counter/ring-buffer; iterators; JSON encode/decode.
- Crypto (from-scratch, oracle-verified): SHA-256, HMAC-SHA256, CRC-32 (ISO-HDLC correct), base64, random_bytes.
- Tensors: matmul/add/mul/scale/relu/softmax/zeros (real C). Domain modules: math3d, ecs, nn, physics2d, stats, router, netutil, compress_rle, crypto_util.

### Networking & data
- TCP/UDP/TLS primitives; HTTP server primitives + **Forge** framework (routing with `:param`/`*`, query, response builders, **custom headers**, **CORS** — critique WRONG on those), static-file serving.
- **SQLite via FFI works end-to-end** (critique WRONG on "no DB") — live REST TODO API on it, links the 257k-line amalgamation.
- WebSocket (RFC-6455), HTTP client (http+https), length-framed distributed transport.

### Toolchain & DX
- Build system `nova_build` (init/build/run/test/fmt/clean, incremental hash cache, cross-compile flag, idempotent formatter).
- Package manager `nova_pkg` (semver parse/cmp/satisfies, local registry, lockfile).
- LSP: diagnostics + hover + go-to-definition + autocomplete.
- Test framework: `assert_eq/ne/near/true/false`, `test_run` suites, `test_summary` pass/fail + exit codes; 137-test regression harness.
- Coverage LCOV export, profiler flamegraph export, ABI version stamp.
- Docs: 9 markdown docs (tutorial, spec, 250-entry stdlib API, FFI, frameworks, getting-started, reference, examples) + 98KB website (`site/index.html` + `site/docs.html`).

### Memory & performance
- Track 8 process-isolated RC + escape analysis; **RC-elision codegen is DONE and ON BY DEFAULT** (critique WRONG on "next/not done") — `_no_rc` rewrites + `list_free_local` drops, ~20% measured gain; auto-arena for no-spawn programs.

### Targets (partial but real)
- WASM compute-only pipeline (real: sum 1..100 → 5050 in Node).
- GPU: **real OpenCL device-dispatch path for vector-add** (dlopen, `clEnqueueNDRangeKernel`, runs on Intel Iris Xe) + CPU kernels for the rest.
- Live cloud deploy: `ai_serve` Dockerized on Railway over HTTPS.

### Frameworks (9 × v0.1 seeds — REAL, compiling, demo-tested)
Forge (web), Cortex (AI), Mesh (distributed), Sentinel (security), Reactor (games),
Prism (GUI), Pulse (data), Edge (embedded), Ops (devops). ~1,372 LOC source + ~942 LOC
demos, backed by genuine primitives. **Honestly labeled v0.1; ~0% of aspirational
headline features exist.**

---

## ❌ NOT COMPLETED — verified real gaps (this is the work)

### TIER 1 — blocks real production apps
1. **Typed `Result<T,E>` / `Option<T>` in the type system** — make errors statically checked, not erased to `int` with runtime `exit(1)`.
2. **File I/O completeness** — delete/remove, rmdir, stat (size/mtime/permissions), rename/move, copy, temp files, **`write_bytes`** (binary write), seek/truncate, per-line file streaming (today `read_line` is stdin-only).
3. **Regex** — `{n}` counted quantifier, `|` alternation (source admits "not supported in v1").
4. **Unicode** — everything is byte-level (`len`, indexing, `ord`/`chr`, case, regex). `len("café")==5`. No codepoint awareness, no non-ASCII case folding.
5. **HTTP depth** — cookies, sessions, auth, file uploads/multipart, streaming/chunked responses, **middleware chain**, request timeouts. And **`forge.serve()` is single-threaded** (its "spawn per conn" comment is false) — must become concurrent to scale.
6. **DB driver layer** — connection abstraction + parameter binding (SQL is string-concat today, injection-prone); Postgres/MySQL drivers.

### TIER 2 — usability for others
7. **Remote package registry** + network fetch (today local-only); transitive import resolution; fix `nova_pkg` installs-to-`deps/` vs compiler reads-`nova_packages/` wiring gap.
8. **`curl | sh` installer**; remove the stale Java JAR + root `nova.bat` (the only residual truth in the "Java" critique).

### TIER 3 — differentiators
9. **Interactive debugger** — real breakpoints/stepping/variable inspection (today: DAP logging stub + `lldb` shell-out).
10. **WASM I/O** — file/net/print, DOM/browser host, imported functions, `memory.grow`.
11. **GPU** — arbitrary kernels on real device; CUDA/Metal/Vulkan/WebGPU (only OpenCL vadd today).

---

## 🛣 Framework path (recommended sequencing — for confirmation)

The bet that's actually novel: **one language, best-in-class across all domains** (no
language is — C/Rust/Go/Python/JS are all specialists). The frameworks PROVE the
unification; the unification is the product. Categories are crowded; that's expected.

- **Wave F0 — Foundations (gate everything):** typed `Result<T,E>`, a concurrent/async runtime (so `serve` scales), file-I/O completeness. Almost every framework's depth depends on these.
- **Wave F1 — Forge → production (web):** highest-leverage first framework; forces TIER-1 fixes (typed errors, HTTP depth, threaded serve, DB driver); where the first real users live. Dogfood a real app on it.
- **Wave F2 — Cortex (AI) + Mesh (distributed):** leverage tensors + channels; Cortex needs autodiff (training) and benefits from real GPU; Mesh needs the thread pool wired + real cross-node transport.
- **Wave F3 — Pulse, Sentinel, Prism, Reactor, Edge, Ops:** several gate on Phase-12 real GPU / real targets (Reactor renderer, Prism GUI, Edge MCU backend).

**Planning method (per feature):** ID · purpose · API surface (actual fns/types) · depends-on
· today/net-new · design + novel mechanism · acceptance test · complexity · wave. Captured
in `FRAMEWORK_MASTER_PLAN.md` (to be built domain-by-domain, with the user driving).
