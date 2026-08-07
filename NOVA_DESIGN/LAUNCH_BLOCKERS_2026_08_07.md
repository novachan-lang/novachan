# NOVA Launch Blockers — Fix List

> **Created:** 2026-08-07 | **Updated:** 2026-08-08
> **Purpose:** Every issue that must be fixed before NOVA can go public. Work through top-to-bottom.
> **Status:** IN PROGRESS — 13 of 24 items closed. CI: **2852 PASS, 0 FAIL, 33 SKIP — ALL GREEN.**

## Verification pass 2026-08-07 (grep/run against live code, not docs)

| # | Doc claimed | Actually |
|---|---|---|
| 1 | Windows-hardcoded `resolve_target("")` | **CONFIRMED, FIX LANDED** — `native_target_triple()` added; also fixes `@cfg(os=...)` which answered "windows" on every host |
| 4 | No README | **DONE** — README.md committed (`0566f47e`) |
| 5 | No LICENSE | **DONE** — Apache 2.0 + NOTICE committed (`0566f47e`) |
| 6 | WASM `print(int)` broken | **CONFIRMED, FIXED** (`b97adc9d`) — was a LinkError, not just print; 5 specializations were missing |
| 7 | Defaults to single core | **ALREADY FIXED — doc was stale.** `nova_runtime.c:10485-10496` auto-detects CPU count (capped 16) when `NOVA_CARRIERS` is unset |
| 8 | 8 Forge blockers open | **ALREADY FIXED — doc was stale.** 8/8 closed per `FORGE_PRODUCTION_GAPS_2026_08_03.md` (wss:// + inflight gauge closed 2026-08-06; client-IP + POSIX stack overflow closed 2026-08-04) |
| 9 | Linux CI tests dead Kotlin | **PARTIALLY FIXED** — `linux-selfhosted` job added (`ce4bd6a9`) builds the real compiler + reconverges; macOS still stale |
| 16 | `target_list` advertises fake targets | **CONFIRMED** — riscv64/armv7 unsupported, AND its macOS triples (`-apple-macosx`) don't match what `resolve_target` emits (`-apple-darwin`) |

---

## CRITICAL — Must fix before any public release

### 1. Native Linux/macOS Self-Hosting
- **Problem:** `resolve_target("")` in `nova_compiler.nova:21886` is hardcoded to `x86_64-pc-windows-msvc` with zero host OS detection. The compiler cannot compile itself (or anything) natively on Linux or macOS.
- **Problem:** No Linux/macOS bootstrap binary exists in git. A clean checkout on Linux has no way to build the compiler.
- **Problem:** GitHub Actions Linux/macOS CI jobs test the dead Kotlin bootstrap, not the live self-hosted compiler.
- **Extra bug found while fixing:** `_eval_cfg` (conditional compilation) calls `resolve_target("")`, so
  `@cfg(os = "linux")` evaluated as *windows* on every host — Linux-only code was silently compiled out.
- **Fix required:**
  - [x] Add real host OS detection in `resolve_target("")` — new `native_target_triple()` uses the existing
        `os_name()`/`arch_name()` builtins (which are already correct `#ifdef` checks in the C runtime).
        Safe by construction: on Windows x86_64 it returns the exact string that was hardcoded, so the
        Windows reconverge stays byte-identical; only non-Windows hosts change behavior.
  - [x] `target_datalayout()` already handles linux/apple/wasm correctly — it dispatches on the triple
        string, so it was never the problem; it was only ever fed a wrong triple.
  - [x] **Linux bootstrap IR checked in** (`compiler/nova_compiler_linux.ll`, 2026-08-07). Cross-compiled
        from Windows with `--target linux` so it carries the ELF datalayout (`e-m:e`) rather than the
        Windows one. **The previously-referenced `nova_compiler.ll` was NEVER TRACKED IN GIT** — the CI job
        added in `ce4bd6a9` would have failed on a clean checkout — and the local copy was Windows-targeted
        anyway, so it could not have produced a working Linux compiler.
  - [x] **`bootstrap_linux.sh`** — one command to build natively on Linux, with `--check` to run a full
        self-host reconverge. Guards against a wrong-target seed and a missing toolchain.
  - [x] **PROVEN ON REAL LINUX (WSL2 Ubuntu):** the bootstrap IR → ELF object → linked with gcc → the
        binary runs (`NOVA v0.1.0 (self-hosted, IR pipeline)`) → and compiling a program on Linux with NO
        `--target` flag autonomously emits `x86_64-unknown-linux-gnu`. That last part is `native_target_triple`
        confirmed on a real native host, not inferred.
  - [x] CI hardened: asserts the seed is Linux-targeted, and asserts native host targeting resolves to Linux.
        Also fixed a CLI bug in the job — bare `nova -o out.ll in.nova` does NOT work (`-o` is not a
        top-level flag; the form is positional, or `nova compile -o`).
  - [ ] Green run of the Linux CI job on GitHub's runners (needs a push; the local WSL equivalent passed)
- **Files:** `nova-compiler/compiler/nova_compiler.nova` (`native_target_triple`/`resolve_target` ~21889),
  `.github/workflows/cross-platform.yml`
- **Why critical:** 70%+ of developers use Linux/macOS. No Linux = no adoption.

### 2. Package Registry — ✅ TOOLING FIXED 2026-08-07 (one hosting step left, see below)
- **Problem:** `nova_registry_url()` pointed at a dead Bitbucket URL (HTTP 404), `nova install` fetched
  ONLY direct deps, and the working solver prototype was never wired in.
- **Fixed:**
  - [x] **`NOVA_REGISTRY` env var** — retarget the registry (any host, or a local dir) WITHOUT rebuilding
        the compiler. The dead URL is now only a fallback default.
  - [x] **Filesystem registries** — if `NOVA_REGISTRY` is a path, packages are read off disk. The registry
        bundled in `packages/registry/` now resolves with **zero network**, which is what turns
        "0 installable packages" into 5 working ones today.
  - [x] **Relative `source` paths** — `source = "greet/greet.nova"` resolves relative to the registry root,
        so a registry VENDORS its sources beside each `index.toml`. One repo is enough; you no longer need
        a separate hosted repo per package. Falls back to the `<pkg>/<pkg>.nova` convention if `source` is absent.
  - [x] **TRANSITIVE resolution** (`nova_pkg_resolve_all`) — a package's own `[dependencies]` are now pulled
        in. Before, a dependency-of-a-dependency silently never arrived and the build failed at `import`
        with no hint why. Worklist, not recursion, so a dependency CYCLE terminates instead of hanging.
  - [x] **Two TOML parser bugs** — a trailing `# comment` was swallowed INTO the value, so
        `source = "x.nova"  # note` resolved to the literal `x.nova"  # note`. The identical bug corrupted
        dependency VERSIONS in `nova_parse_toml_deps`. Both now end a quoted value at its closing quote.
  - [x] **CI gate** — `_pkg_install_gate.ps1`, wired as stage 2c2. Proves offline install + import + correct
        runtime output + transitive + cycle. **Verified it FAILS on the pre-fix compiler (5 checks) and
        passes on the fixed one**, so it is a real gate, not decoration.
- **Verified end-to-end:** fresh project → `nova install` (offline, local registry) → `import greet` →
  compiles → runs → prints `Hello, NOVA!`.
- **STILL NEEDS A HUMAN (cannot be automated from here):**
  - [ ] Push `packages/registry/` to a public host and publish the raw base URL. Documented as a
        copy-paste sequence in `packages/README.md`. This needs your credentials — it is the only
        remaining step, and the tooling no longer depends on it (a local registry works today).
  - [ ] Grow the registry beyond the 5 bundled packages.
  - [ ] Real semver CONSTRAINT SOLVING — versions are recorded and pinned, but on conflict first-writer
        wins rather than computing a compatible intersection. `test_programs/nova_pkg.nova` already has
        semver with caret/tilde matching to lift.
- **Why critical:** A language with zero installable packages is a dead end for any real project.

### 3. Clean Repo for Public
- **Problem:** Repo has temp files, personal paths, Windows-specific paths, build artifacts, stale copies.
- **Fix required:**
  - [ ] Remove all `.exe` files from git tracking (add to .gitignore, keep only gen3_test.exe as bootstrap seed)
  - [ ] Remove `bash.exe.stackdump`, `NUL`, `-o` and other junk files from repo root
  - [ ] Grep for any hardcoded `C:\Users\mange` paths in source and replace with relative paths or env vars
  - [ ] Remove the ~10 stale copies of `nova_runtime.c` (only `nova-compiler/compiler/nova_runtime.c` is live)
  - [ ] Add comprehensive `.gitignore` (*.exe, *.ll, *.o, *.obj, *.class, *.stackdump, NUL)
  - [ ] Remove `coding_examples/BenchJava.class` and other non-NOVA build artifacts
- **Why critical:** A messy repo looks amateur and undermines credibility instantly.

### 4. README.md — ✅ DONE (`0566f47e`)
- README.md committed at repo root.
- **Why critical:** README is the first thing anyone sees. No README = no one stays.

### 5. LICENSE File — ✅ DONE (`0566f47e`)
- Apache 2.0 chosen; `LICENSE` + `NOTICE` at repo root, copyright headers added to key sources.
- **Why critical:** No license = no one can legally use it. Literally unusable.

---

## HIGH — Should fix before public launch

### 6. WASM `print(int)` Gap — ✅ FIXED 2026-08-07 (`b97adc9d`)
- **Problem (confirmed, worse than described):** the compiler's print specializer rewrites a generic
  `nova_rt_print_any` into a type-specific variant once inference proves the operand type. The JS runtime
  provided ONLY `nova_rt_print_str`, so the module failed at *instantiation* with
  `LinkError: function import requires a callable` — not a wrong-output bug, a hard link failure.
  Five imports were missing, not one.
- **Fix landed:**
  - [x] Added `nova_rt_print_int`, `_bool`, `_float`, `_any`, `_intlist` + the `intlist_to_str` helper,
        each mirroring native semantics in `nova_runtime.c`. Purely additive (wasm binds only what it declares).
  - [x] `_wasm_runtime.cjs` is now TRACKED IN GIT — it never was, despite the whole wasm path depending on it.
  - [x] Regression probe `_wasm_print_probe.nova` + `.run.cjs` harness committed.
  - [ ] Wire the probe into CI (still open)
- **Verified:** probe prints `42 / -7 / 3.5 / true / false / done` under node; replaying the pre-fix import
  set reproduces the LinkError exactly.

### 7. Concurrency Defaults to Single Core — ✅ NOT A BUG (doc was stale)
- **Verified 2026-08-07** at `nova-compiler/compiler/nova_runtime.c:10485-10496`: when `NOVA_CARRIERS` is
  unset or empty the runtime calls `nova_rt_cpu_count()` (GetSystemInfo / sysconf) and uses the detected
  count, capped at 16. Changed 2026-08 once N>1 passed the full arc. An explicit `NOVA_CARRIERS` still wins,
  including `NOVA_CARRIERS=1` to force the deterministic single-carrier hot path.
- **Remaining (nice-to-have, not a blocker):**
  - [ ] `serve_app(app, port: 8080, workers: 4)` convenience option
  - [ ] Document the auto-detection in Forge docs so users know it is automatic

### 8. Forge Production Blockers — ✅ 8/8 CLOSED (doc was stale)
- **Verified 2026-08-07** against `NOVA_DESIGN/FORGE_PRODUCTION_GAPS_2026_08_03.md`, which this list
  predates by four days of fixes:
  1. Graceful shutdown — ✅ `shutdown_requested()` wired into the accept loops
  2. Rate limiter / real client IP — ✅ `tcp_peer_addr`/`tcp_peer_port` shipped 2026-08-04 (`10818a43`)
  3. Connection pool leak — ✅ MITIGATED (acquire timeout; residual needs runtime panic-recovery)
  4. TLS capacity — ✅ `forge_limits.conn_guard` gates before the handshake
  5. TLS cert (CA-issued) — ✅ `forge_serve_tls_file` routes through `nova_rt_tls_listen`
  6. Fake health check — ✅ `health_route_checked(a, checks)` does real 503-on-failure
  7. POSIX stack overflow — ✅ `sigaltstack`+SIGSEGV/SIGBUS handler in the POSIX fiber trampoline (2026-08-04)
  8. `mw_metrics`+`dispatch_safe` inflight-gauge leak — ✅ `on_crash` hook + `mw_metrics_wire_crash` (2026-08-06)
- **Still genuinely open (needs the runtime team, tracked in `PER_CARRIER_IO_DESIGN.md`):**
  - [ ] N>1 I/O throughput regression (`g_sched_lock` / PC-1) — this is the one real remaining item

### 9. CI on Real Compiler (All Platforms) — 🟡 PARTIALLY FIXED
- **Problem:** Only Windows CI tests the real compiler. Linux/macOS CI tests dead Kotlin bootstrap.
- **Local CI: ✅ 2852 PASS, 0 FAIL, 33 SKIP — ALL GREEN (2026-08-08)**
  - 11 regressions from the `highlevel-upgrade` branch found and fixed:
    - `_run_final_regression.ps1` never set `NOVA_HOME` → all `std/` module imports failed silently
    - 3 De Morgan's law bugs in `std/parsing/glob.nova`, `std/numeric/bignum.nova`, `std/numeric/decimal.nova`
      (mechanical `while X == false` → `while not (X)` rewrite didn't account for compound conditions)
    - BFS worklist `while qi < len(queue)` → `for qi in 0..len(queue)` in `std/tree/tree_dp_mis.nova`
      (range bounds evaluated once; the growing queue was silently truncated)
    - Comprehension body can't do L8 struct-index dispatch in `std/data/dataframe.nova` (reverted to loop)
- **Fix required:**
  - [x] `linux-selfhosted` job added (`ce4bd6a9`): installs clang/lld, builds the native Linux compiler from
        the checked-in `nova_compiler.ll`, then runs a gen5==gen6 reconverge check. This tests the REAL
        self-hosted compiler, not the Kotlin bootstrap.
  - [x] `_run_final_regression.ps1` now auto-sets `NOVA_HOME` if unset — `std/` imports resolve in CI
  - [ ] Job needs a green run on GitHub's runners (needs a push; local equivalent passed)
  - [ ] Add macOS runner (GitHub Actions has macOS runners)
  - [ ] Add WASM compile+run tests to CI — the harness now exists (`_wasm_print_probe.run.cjs`), just needs wiring
- **Files:** `.github/workflows/cross-platform.yml`, `_run_final_regression.ps1`
- **Depends on:** #1 (Linux self-hosting)

### 10. Getting Started Tutorial — ✅ DEMOS DONE 2026-08-07
- **Fix required:**
  - [x] Tutorial already existed and is thorough — `docs/TUTORIAL.md`, 6,513 lines, with DO/DON'T boxes and
        explicit comparisons to Python/Go/Rust/JS. The real gap was runnable demos, not prose.
  - [x] **3 demos in `examples/`, each verified compiling AND running** (outputs in `examples/README.md`
        are captured from real runs):
    - `rest_api.nova` (85 lines) — CRUD over real SQLite. Every endpoint exercised with curl:
      POST/GET/GET-by-id/404/400-validation/DELETE. **Injection safety was TESTED, not asserted** —
      a `'); DROP TABLE tasks; --` payload stored as literal text, table intact.
    - `pipeline.nova` (45 lines) — spawn/channel fan-out/fan-in; prints 9592, the true count of primes
      below 100,000.
    - `cli_wordcount.nova` (30 lines) — args, file IO, dicts, `sort_by`, comprehensions, zero local
      type annotations.
  - [ ] Test on a genuinely fresh machine (dev machine only so far)
- **Four real bugs surfaced while writing these — fixed, not shipped:**
  1. tokenizer merged `dog\nthe` into `dogthe` (normalize whitespace BEFORE splitting)
  2. `else` fallback does not parse inside an argument list (trap #3)
  3. a literal `{` in a string got interpolated away (trap #5)
  4. **POST returned `"id":1` but GET returned `"id":"1"`** — SQLite returns TEXT columns and the struct's
     declared `int` fields do not coerce, so the same resource serialized differently by path
- **NEW papercut found (not blocking, worth fixing):** `slice()` is string-only, so `slice(list, 0, n)` is a
  type error; lists need `xs[0:n]` or `list_slice`. A beginner hits this within minutes and the error message
  ("use str() to convert to string") points the wrong way.
- **Why:** Without a tutorial, even interested developers bounce.

### 11. CONTRIBUTING.md + CODE_OF_CONDUCT.md
- **Fix required:**
  - [ ] Write CONTRIBUTING.md: how to build, how to run tests, PR process, coding style
  - [ ] Write CODE_OF_CONDUCT.md (use Contributor Covenant as base)
- **Why:** Required for community trust. GitHub shows a warning without these.

---

## MEDIUM — Fix after launch for credibility

### 12. Compiler Dogfooding
- **Problem:** The compiler (28k lines) uses 0 generic functions, 0 closures, 0 HOF in its own code. It uses Result (30 times) but otherwise writes C-style NOVA. The libraries (forge, std) now use these features, but the compiler — the biggest NOVA program — doesn't.
- **Fix required:**
  - [ ] Identify 10-20 places in the compiler where generics/closures/HOF would be natural
  - [ ] Refactor incrementally, reconverging after each batch
  - [ ] Track progress: goal is compiler demonstrates NOVA's own high-level style
- **Why:** "The compiler that implements generics doesn't use generics" undermines credibility.

### 13. Duplicate Modules (166 forge/std overlaps) — ✅ CLOSED
- **Problem:** 166 modules exist in both `forge/` and `std/` (independently authored during different campaigns). See `NOVA_DESIGN/DUPLICATE_MODULES_TRACKER.md`.
- **Fix required:**
  - [x] Audit all 166 pairs: 64 safe to delete (zero imports), 20 false positives (keep), 102 need wrapper conversion
  - [x] Delete 64 zero-import forge duplicates (+ their nova-compiler/lib/ mirrors)
  - [x] Clean up `_sweeplist.txt` (6 stale entries removed)
  - [x] Update `DUPLICATE_MODULES_TRACKER.md` with `[D]` markers for all 64
  - [x] Convert 102 remaining to thin wrappers with suffix-based + manual function name mapping
  - [x] Fix wrappers: restore private helper functions needed by non-delegated public functions
  - [x] Sync all wrappers to nova-compiler/lib/ mirror
  - [x] Update tracker with `[W]` markers for all 102 wrappers + `[F]` for 20 false positives
- **Result:** 64 deleted + 102 wrapped + 20 false positives (different concepts, keep both) = 186 pairs resolved. Zero `[ ]` entries remain in tracker Section A.
- **Why:** Duplicates confuse contributors and waste maintenance effort.

### 14. Untested Forge Modules (~115 of 570)
- **Problem:** ~115 forge modules are marked `untested (syntax✓)` — compiled but never functionally tested.
- **Fix required:**
  - [ ] Run KAT tests on all 115 modules
  - [ ] Fix any that fail
  - [ ] Remove or deprecate any that are fundamentally broken
- **Why:** Claiming 570 modules when 115 are untested is misleading.

### 15. `deploy_config` / `deploy_validate` Stubs
- **Problem:** These builtins return fake dicts with no real provider integration.
- **Fix required:**
  - [ ] Either implement real deployment (Railway/Fly.io API integration) OR
  - [ ] Remove these builtins entirely (dead code is worse than missing code)
- **Files:** `nova_runtime.c` ~line 25235
- **Why:** Fake builtins that do nothing erode trust.

### 16. `target_list()` Advertises Unsupported Targets — CONFIRMED, worse than described
- **Problem:** `nova_rt_target_list()` (`nova_runtime.c:22451-22462`) claims riscv64 and armv7 support, but
  `resolve_target()` and `target_datalayout()` have no paths for these triples — they fall through to the
  generic ELF datalayout, which is WRONG for riscv32/thumb and silently miscompiles.
- **Second bug found 2026-08-07:** `target_list` also emits `aarch64-apple-macosx` / `x86_64-apple-macosx`,
  but `resolve_target("macos")` emits `x86_64-apple-**darwin**`. The advertised list and the accepted list
  disagree, so a user copying a triple straight out of `target_list()` gets a triple the compiler's own
  `resolve_target` passes through unrecognized.
- **Fix required:**
  - [x] ✅ FIXED 2026-08-07. Dropped `riscv64-unknown-linux-gnu` and `armv7-unknown-linux-gnueabihf`, and
        aligned the macOS entries `*-apple-macosx` → `*-apple-darwin` to match `resolve_target`. Added a
        comment tying the list to `resolve_target`/`target_datalayout` so it cannot drift again.
        Verified no test asserts the list contents. Rode the same reconverge arc as #24.
- **Files:** `nova_runtime.c:22451`, `nova_compiler.nova` (`resolve_target` ~21889)
- **Why:** Advertising capabilities that don't work is worse than not having them.

### 17. ARM aarch64 Fibers Broken
- **Problem:** Confirmed by measurement via Docker+QEMU: `fiber_create` fails, `fiber_resume` returns "already done," spawned task bodies never run on ARM.
- **Fix required:**
  - [ ] Fix the aarch64 fiber context switch assembly
  - [ ] Test via Docker `--platform linux/arm64`
- **Why:** Blocks Apple Silicon (M1/M2/M3) and ARM server deployments.

### 18. HTTP Client Missing Features
- **Problem:** No connection pooling/keep-alive (every request opens fresh TCP + sends `Connection: close`). Single cookie per response (flat header dict). GET-only redirect following.
- **Fix required:**
  - [ ] Add connection pooling with keep-alive
  - [ ] Support multiple Set-Cookie headers per response
  - [ ] Support POST/PUT redirect following (307/308)
- **Files:** `forge/forge_http_client.nova`
- **Why:** Connection pooling is essential for any app making multiple API calls.

---

## LOW — Nice to have, not blockers

### 19. GPU Acceleration
- **Problem:** GPU builtins are CPU stubs. Dev machine lacks SPIR-V/PTX clang targets.
- **Fix required:** Real OpenCL or Vulkan compute integration (future — needs hardware)
- **Status:** Env-blocked on current dev machine. Defer until hardware available.

### 20. Embedded / Bare Metal
- **Problem:** Freestanding allocator works (KAT-tested), but no bare-metal _start, no UART, no linker scripts.
- **Fix required:** Real embedded hello-world on actual hardware (future)
- **Status:** Defer. Prerequisite: fix ARM fibers (#17).

### 21. Frontend Framework (Prism-web)
- **Problem:** WASM codegen works, but no SPA framework, no in-browser concurrency, no DOM bindings.
- **Fix required:** Real browser framework on top of WASM target (future)

### 22. DevX Tools Not Tracked
- **Problem:** The debugger, profiler, coverage, REPL, test runner, doc generator are all real and working but NONE are tracked in `EXECUTION_STATE.md`.
- **Fix required:**
  - [ ] Add Phase 9 (DevX) entries to EXECUTION_STATE.md
  - [ ] Document `nova debug`, `nova cov`, `nova bench`, `nova test`, `nova repl` in user-facing docs

### 24. Closure-valued struct field cannot be CALLED directly — ✅ FIXED 2026-08-07 (compiler)
- **Symptom:** `obj.fn_field(args)` emits `call i64 @nova_rt_<fieldname>(...)` — a runtime builtin that does
  not exist — so the program fails to LINK, not to compile.
- **Root cause (located exactly):** `fn ir_lower_expr` in `nova_compiler.nova` (branch `tag == "method" or
  tag == "method_call"`, ~12358). Its resolution chain is: typed method → dynamic dispatch → user method →
  **free function (`list_contains(b.ir_fnames, value)`, ~12476)** → **else `resolve_method_fn(value)` (~12478)**.
  There is NO check anywhere in that chain for "is `value` a declared FIELD of the receiver's struct type".
  `resolve_method_fn` fails OPEN — its terminal case is literally `"nova_rt_" + name`, so any unknown name
  becomes a fabricated symbol. (Its sibling `resolve_runtime_fn` fails CLOSED, returning `name` — that
  asymmetry is the mechanical cause.)

- **⚠️ THE DANGEROUS HALF — a SILENT MISCOMPILE, verified by execution.** The link error above comes from
  the `:12478` fallback. But the `:12476` free-function branch fires FIRST, so when a closure field's name
  also matches a global function, the call **silently binds to the global function** with the receiver
  injected as arg 0 — wrong answer, no error, no gate catches it:
  ```nova
  type Box
      zzfld: any
  fn zzfld(x) -> int
      999
  let b = Box(fn() 42)
  print(b.zzfld())      // prints 999  <-- WRONG, should be 42
  let f = b.zzfld
  print(f())            // prints 42   <-- correct
  ```
  Verified by running `test_programs/_closure_field_shadow_probe.nova`. **63 declared field names in this
  repo already shadow a global function name**, so this is not hypothetical. A link error is loud; this is
  silent data corruption.
- **Minimal repro** (`test_programs/_closure_field_probe.nova`):
  ```nova
  type Calc
      op: any
  let c = Calc(fn(a, b) a + b)
  print(c.op(5, 7))     // -> error: use of undefined value '@nova_rt_op'
  ```
  The emitted call has the receiver prepended (`@nova_rt_op(i64 %r3, i64 %r4, i64 %r5)`), confirming the
  UFCS desugar is the path taken.
- **Workaround (works today, verified):** bind to a local first —
  `let f = c.op` then `f(5, 7)`. Compiles to a correct indirect call and runs.
- **Real-world impact:** this silently broke **22 forge tests** (all WS/SSE/HTTP-client tests). The Aug 6
  CI log shows all 22 as `PASS`; they broke when `recv_fn`/`send_fn` closure fields were added to `WsConn`
  in `02a23b5b` (the wss:// work). Fixed forge-side 2026-08-07 by applying the workaround at the 2 call
  sites; all 22 verified building AND running green again.
- **FIX LANDED:** a new branch in `ir_lower_expr` sets `mc_field_stype` when the receiver's struct type
  declares a field of that name and no explicit `Type__name` method claimed it, then lowers to
  `field_get` + `dyn_call` — exactly the IR the bind-to-local workaround produced. Placed **between the
  `ir_methods` branch and the free-function branch**, so real methods still win but a field of the
  receiver's own type now beats an unrelated global of the same name.
- **Verified:**
  - `_closure_field_shadow_probe` now prints **42, 42** (was **999**, 42) — silent miscompile gone.
  - `_closure_field_probe` now prints **7, 12** (was a link error) — fabricated symbol gone.
  - `_closure_field_param_probe` (typed fn param, forge's real shape) prints **42, 40**.
  - forge's `ws.recv_fn()` / `ws.send_fn(frame)` restored to the DIRECT form (workaround reverted);
    `forge_ws_echo_test` passes end-to-end over a real socket.
  - Reconverge **gen5.ll == gen6.ll byte-identical** (9D792E7E…).
- **Precedence-safety audit (3 areas, each adversarially verified) — 0 breaking sites:**
  - `forge/` — the only 2 changed sites are the intended targets. The 4 field/fn name collisions
    (`code`, `content_type`, `pattern`, `table`) have ZERO call sites.
  - `std/` — 0 changed sites. Two latent traps exist (`Gen.fib: int` vs global `fn fib`, `Gen.box: list`
    vs global `fn box`, both `std/util/coro.nova:21`) but both fields are only ever READ
    (`fiber_resume(g.fib)`, `g.box[0]`), never called. If anyone ever writes `g.fib(n)` expecting UFCS it
    would now break — noted as a trip-wire, not a live problem.
  - `nova_compiler.nova` — 0 sites; 197 field names × 523 global fn names is an EMPTY intersection and the
    file contains no `recv.FIELD(` form at all. This predicted byte-identical reconverge, which held.
- **KNOWN REMAINING GAP (documented, not fixed):** the legacy `cg` backend's `codegen_method_call`
  (~6272) still calls `resolve_method_fn` unguarded, so the two backends now disagree on `recv.field(...)`.
  That path is reachable ONLY via an explicit `--old` flag (default is `use_ir = 1`), and NO gate exercises
  it (`grep -c '\-\-old'` over `nova_ci.ps1` / `_run_final_regression.ps1` = 0). Fixing it properly needs
  receiver-struct-type plumbing that the `CodeGen` struct does not carry, so a half-fix would add risk
  without benefit. Tracked rather than rushed.
- **Files:** `nova-compiler/compiler/nova_compiler.nova` (`ir_lower_expr` ~12358-12480, `resolve_method_fn`
  ~9220/9329, legacy `codegen_method_call` ~6274). Repros committed as
  `test_programs/_closure_field_probe.nova`, `_closure_field_shadow_probe.nova`, `_closure_field_workaround.nova`
- **Why it matters:** storing a callback in a struct is table-stakes for any framework. Silently emitting a
  reference to a nonexistent builtin is the worst failure mode — no compile error, a link error that points
  at the wrong thing, and it only shows up if that code path is actually linked.

### 23. Profiler Auto-Injection
- **Problem:** `nova_runtime.c:25495` comments claim "the compiler injects prof_enter/exit when --profile is passed" but no `--profile` flag exists in the CLI. Profiling is manual-instrumentation only.
- **Fix required:**
  - [ ] Either add `--profile` flag that auto-injects prof_enter/exit per function OR
  - [x] ✅ Corrected the stale comment in `nova_runtime.c` (2026-08-07). Verified first that no `--profile`
        flag exists in the CLI and nothing auto-injects `nova_rt_prof_enter` — the only hits are the
        builtin-name mapping and the two `declare` lines. Profiling is manual instrumentation only.

---

## Execution Order (Dependencies)

```
#5 LICENSE ──────────────────────────────────── can do immediately
#3 Clean Repo ──────────────────────────────── can do immediately
#4 README ──────────────────────────────────── can do immediately
#11 CONTRIBUTING + COC ─────────────────────── can do immediately
#6 WASM print(int) ─────────────────────────── can do immediately (small)
#22 Track DevX in docs ─────────────────────── can do immediately
#16 Remove fake target_list entries ────────── can do immediately
#15 Remove deploy stubs ───────────────────── can do immediately
#1 Linux self-hosting ──────────────────────── MOST IMPORTANT, do first
  └─► #9 CI on real compiler (depends on #1)
#2 Package registry ────────────────────────── do after #1
#7 Multi-core default ─────────────────────── can do immediately
#8 Forge prod blockers ─────────────────────── independent, can parallelize
#10 Tutorial + demos ──────────────────────── do after #1 (test on Linux)
#12 Compiler dogfooding ───────────────────── ongoing, incremental
#13 Duplicate modules ─────────────────────── can parallelize
#14 Test untested modules ─────────────────── can parallelize
#17 ARM fibers ─────────────────────────────── do when ready
#18 HTTP client pooling ───────────────────── medium effort
#23 Profiler auto-inject ──────────────────── small
```

---

## Success Criteria

**Ready for soft launch (r/ProgrammingLanguages):**
- [x] #1 Linux self-hosting works (native_target_triple + bootstrap IR + bootstrap_linux.sh)
- [x] #2 Package registry tooling works (5 packages, offline, transitive — hosting needs credentials)
- [ ] #3 Clean repo
- [x] #4 README (committed `0566f47e`, being refined in another session)
- [x] #5 LICENSE (Apache 2.0 + NOTICE committed `0566f47e`)
- [x] #10 At least 1 demo program that runs on Linux (3 demos in `examples/`)
- [ ] #11 CONTRIBUTING + COC

**Ready for public launch (Hacker News):**
- All soft launch items PLUS:
- [x] #6 WASM print(int) fixed (`b97adc9d`)
- [x] #7 Multi-core default — NOT A BUG, auto-detects CPU count
- [x] #8 Forge prod blockers — all 8/8 CLOSED
- [ ] #9 CI green on GitHub runners (local CI: 2852 PASS / 0 FAIL — needs push)
- [x] #10 Full tutorial + 3 demos (rest_api, pipeline, cli_wordcount)
- [x] #16 Fake target_list entries removed
- [x] #24 Closure-field dispatch fixed (compiler + reconverged)
