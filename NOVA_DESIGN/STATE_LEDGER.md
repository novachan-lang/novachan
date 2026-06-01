# NOVA — Verified State Ledger (updated 2026-06-02)

**Purpose:** The honest, evidence-verified record of what is COMPLETED vs NOT in NOVA
today. Built by auditing the self-hosted codebase (`nova_compiler.nova`,
`output/nova_runtime.c`, the **141-test** regression suite, `docs/`) against an external
critique. Every line below was checked against real files, not memory.

**2026-06-02 update:** a 22-agent evidence audit + independent re-verification corrected the
record in BOTH directions (full discrepancy list in `CORE_COMPLETENESS.md` → "VERIFIED AUDIT").
Biggest correction: **concurrency is real, not missing** — `nova_rt_spawn` runs on a real
OS-thread pool with process-isolation-by-deep-copy; channels/`select`/`async`/`await`/`pmap`/
`pfilter`/`yield` all exist and pass tests. Also shipped tonight: File-I/O completeness, regex
`{n}`, Unicode codepoint views, OS builtins (`chdir`/`getpid`/`which`, `set_env` truthiness fix),
DNS (`dns_resolve`/`hostname`), and 10 math builtins. Five commits: `a15b6e2`, `0d16e68`,
`f07dc1b`, `f5eae3f`, `198c943`.

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
- Regex: real backtracking NFA — char classes/ranges, `* + ?`, **`{n}`/`{n,m}`/`{n,}` counted quantifiers** (added `0d16e68`), anchors, `\d \w \s`, groups (tested). *Gap: `|` alternation.*
- File I/O: read/write/append, `file_exists`, **`list_dir`**, `read_bytes`/**`write_bytes`**, `read_lines`, `mkdir`/`mkdir_p`, `path_join`, and full FS ops — **`remove_file`/`remove_dir`/`rename_path`/`copy_file`/`file_size`/`file_mtime`/`is_dir`/`is_file`/`temp_dir`** (added `a15b6e2`, `file_io_test` passes). *Gap: seek/truncate/mmap.*
- OS/process: `env`, **`set_env`** (truthiness-fixed), **`chdir`**, **`getpid`**, **`which`**, `cwd`, `spawn`/`exec` (added `f5eae3f`, `os_test` passes).
- Networking identity: **`dns_resolve`** (IPv4, `""`-on-fail), **`hostname`** (added `198c943`, `net_test` passes).
- Unicode codepoint layer: `char_count`/`char_at`/`code_points`/`from_codepoint`/`is_valid_utf8` (additive — byte `len`/`ord` unchanged). Math: `sinh`/`cosh`/`tanh`/`cbrt`/`hypot`/`gcd`/`lcm`/`pi`/`e`/`fmod` (added `f07dc1b`).
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

### Concurrency runtime (verified real 2026-06-02 — prior ledger was STALE here)
- **`spawn` is real:** `nova_rt_spawn` lazily inits an OS-thread pool (`pthread_create`/`CreateThread` + join), deep-copies the spawned process's captured environment (process isolation *by construction*, no shared mutable heap), registers it in a locked process table with monitors/exit-status. `spawn_test` → 42.
- **Channels:** `nova_rt_channel_create/send/recv`, `nova_rt_select`/`channel_select` over multiple channels. `select_test` → 30, `select_multi_test` → 1500.
- **Async:** `nova_rt_async/await/await_all/await_any` (futures + composition). `async_test` passes.
- **Data parallelism:** `nova_rt_pmap`/`pfilter`/`pfor` — real worker threads, dynamic thread-count by CPU/size. `parallel_test`: "pmap correctness: OK / pfilter correctness: OK".
- **Generators:** `yield` parsed + codegen'd. `yield_test` → `[0,1,2,3,4]`.
- ⚠️ **Still missing (the *structured* layer, not the primitives):** supervision trees (`monitor` registers listeners but `link`/`exit` are log-only stubs — no restart), structured concurrency, GenServer, bounded/back-pressured channels, hot-reload (infra only). This is the real remaining concurrency work — far smaller than "build a runtime from scratch."

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
1. **Typed `Result<T,E>` / `Option<T>` in the type system** — make errors statically checked, not erased to `int` with runtime `exit(1)`. **Now the #1 gap** (deep type-system change; do it user-present).
2. **Structured concurrency layer** — the *primitives* are done (see Concurrency above); missing is the *structure*: **supervision/restart** (today log-only stubs), structured concurrency, GenServer, bounded channels. This is where the Erlang-beating thesis is won — and it's a far smaller lift than the old "no runtime" framing implied.
3. ~~File I/O completeness~~ — **DONE** (`a15b6e2`): delete/rmdir/stat/rename/copy/temp/`write_bytes`/`read_lines` all shipped. *Only seek/truncate/mmap remain.*
4. **Regex `|` alternation** — `{n}`/`{n,m}`/`{n,}` **DONE** (`0d16e68`); `|` remains (needs a recursive-descent regex rewrite — the VM uses absolute pc indices).
5. **Unicode-correct `len`/indexing** — codepoint **views** added (`char_count`/`char_at`/`code_points`/…, `f07dc1b`); default `len`/indexing/`ord`/`chr`/regex still byte-level (`len("café")==5`). No grapheme/normalization/non-ASCII case-fold.
6. **HTTP depth + thread-pooled serve** — the thread pool now exists, so `serve()` should dispatch connections onto it (no longer blocked on a missing runtime). Still missing: cookies, sessions, auth, multipart, streaming/chunked, **middleware chain**, request timeouts.
7. **DB driver layer** — connection abstraction + parameter binding (SQL is string-concat today, injection-prone); Postgres/MySQL drivers.

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

- **Wave F0 — Foundations (gate everything):** typed `Result<T,E>` (the remaining big one), the **structured concurrency layer** (supervision/bounded channels — primitives already exist) + dispatch `serve` onto the existing thread pool. (File-I/O completeness — *done*.) Almost every framework's depth depends on these.
- **Wave F1 — Forge → production (web):** highest-leverage first framework; forces TIER-1 fixes (typed errors, HTTP depth, threaded serve, DB driver); where the first real users live. Dogfood a real app on it.
- **Wave F2 — Cortex (AI) + Mesh (distributed):** leverage tensors + channels; Cortex needs autodiff (training) and benefits from real GPU; Mesh needs the thread pool wired + real cross-node transport.
- **Wave F3 — Pulse, Sentinel, Prism, Reactor, Edge, Ops:** several gate on Phase-12 real GPU / real targets (Reactor renderer, Prism GUI, Edge MCU backend).

**Planning method (per feature):** ID · purpose · API surface (actual fns/types) · depends-on
· today/net-new · design + novel mechanism · acceptance test · complexity · wave. Captured
in `FRAMEWORK_MASTER_PLAN.md` (to be built domain-by-domain, with the user driving).
