# NOVA Launch Blockers — Fix List

> **Created:** 2026-08-07
> **Purpose:** Every issue that must be fixed before NOVA can go public. Work through top-to-bottom.
> **Status:** IN PROGRESS — see per-item status. Verified against live code 2026-08-07.

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
  - [ ] Check in a Linux bootstrap IR or cross-compile one from Windows
  - [x] `.github/workflows/cross-platform.yml` — `linux-selfhosted` job added (`ce4bd6a9`) that builds the
        real compiler from checked-in IR and runs a reconverge check
  - [ ] Verify full reconverge (gen5.ll == gen6.ll) natively ON Linux (the CI job does this; needs a green run)
- **Files:** `nova-compiler/compiler/nova_compiler.nova` (`native_target_triple`/`resolve_target` ~21889),
  `.github/workflows/cross-platform.yml`
- **Why critical:** 70%+ of developers use Linux/macOS. No Linux = no adoption.

### 2. Package Registry
- **Problem:** `nova_registry_url()` at `nova_compiler.nova:28833` points to `bitbucket.org/manemangesh/packages` — returns HTTP 404, workspace does not exist.
- **Problem:** No transitive dependency resolution in the live `nova install` path (only fetches direct deps).
- **Problem:** A more complete solver prototype exists in `test_programs/nova_pkg.nova` with real semver + transitive resolution, but is NOT wired into the main CLI.
- **Fix required:**
  - [ ] Create the Bitbucket (or GitHub) registry repo and push the 5 existing packages (greet, dotenv, uuid, args, semver) from `packages/`
  - [ ] Wire the transitive solver from `nova_pkg.nova` into the main `nova_pkg_install()` path
  - [ ] Test `nova install` end-to-end: fresh project → add dependency to nova.toml → `nova install` → import works
  - [ ] Add 10-20 useful packages to the registry (http-router helpers, date/time, logging, env config, etc.)
- **Files:** `nova-compiler/compiler/nova_compiler.nova` (nova_registry_url at 28833, nova_pkg_install at 28886), `test_programs/nova_pkg.nova`, `packages/`
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
- **Fix required:**
  - [x] `linux-selfhosted` job added (`ce4bd6a9`): installs clang/lld, builds the native Linux compiler from
        the checked-in `nova_compiler.ll`, then runs a gen5==gen6 reconverge check. This tests the REAL
        self-hosted compiler, not the Kotlin bootstrap.
  - [ ] Job needs a green run to confirm (depends on #1's `native_target_triple` fix to link natively)
  - [ ] Add macOS runner (GitHub Actions has macOS runners)
  - [ ] Add WASM compile+run tests to CI — the harness now exists (`_wasm_print_probe.run.cjs`), just needs wiring
- **Files:** `.github/workflows/cross-platform.yml`
- **Depends on:** #1 (Linux self-hosting)

### 10. Getting Started Tutorial
- **Fix required:**
  - [ ] Write a 5-minute tutorial: install → hello world → web API → database → deploy
  - [ ] Create 3 demo programs that compile and run out of the box:
    - Demo 1: Full-stack REST API with database (under 100 lines)
    - Demo 2: Concurrent data pipeline with spawn/channels (under 50 lines)
    - Demo 3: CLI tool (under 40 lines)
  - [ ] Test on a fresh machine (not the dev machine)
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

### 13. Duplicate Modules (166 forge/std overlaps)
- **Problem:** 166 modules exist in both `forge/` and `std/` (independently authored during different campaigns). See `NOVA_DESIGN/DUPLICATE_MODULES_TRACKER.md`.
- **Fix required:**
  - [ ] For each pair, decide: keep forge version (delete std), keep std version (forge imports std), or merge
  - [ ] Update all imports across the codebase
  - [ ] Delete the duplicates
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
  - [ ] Drop riscv64/armv7 from `target_list()` (they are not supported) and align the macOS triples with
        what `resolve_target` actually produces. Runtime change → needs a full reconverge arc.
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

### 24. Closure-valued struct field cannot be CALLED directly — 🔴 REAL COMPILER BUG (found 2026-08-07)
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
- **Fix required (the proper one, still open) — RED blast radius, needs a full arc:**
  - [ ] Insert a "does the receiver's struct type declare a field named `value`?" check in `ir_lower_expr`,
        placed **BEFORE the free-function branch at ~12476** — not merely before the `nova_rt_` fallback at
        ~12478. Placing it only before the fallback fixes the loud link error and leaves the silent
        miscompile intact. Lower the hit to `field_get` + `dyn_call` (both IR ops already exist; this is
        exactly the IR the bind-to-local workaround already produces).
  - [ ] The data needed is already on the builder: `b.ir_field_types[<StructName> + "." + <field>]`
        (populated ~24477) and `ir_expr_struct_type` (~12986) to resolve the receiver.
  - [ ] `ir_lower_expr` is the SHARED IR builder, so one fix covers BOTH LLVM backends. The legacy `cg`
        path (`codegen_method_call`, ~6274) calls `resolve_method_fn` unguarded and needs its own touch.
  - [ ] Make `resolve_method_fn` fail CLOSED, or have the fallback raise a real compile-time error
        ("unknown method or field 'op' on type 'Calc'") instead of fabricating a symbol that only explodes
        at link time pointing at `@nova_rt_op`.
  - [ ] **Risk to control:** this changes method-dispatch PRECEDENCE. A field that is not callable but whose
        name matches a global fn (e.g. `count: int` with a global `count(x)`) currently resolves to the
        global via UFCS; after the fix it would resolve to the field and fail. Each of the 63 shadowing
        names must be checked before landing this.
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
  - [ ] Correct the stale comment in nova_runtime.c

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
- [ ] #1 Linux self-hosting works
- [ ] #2 Package registry live with 5+ packages
- [ ] #3 Clean repo
- [ ] #4 README
- [ ] #5 LICENSE
- [ ] #10 At least 1 demo program that runs on Linux
- [ ] #11 CONTRIBUTING + COC

**Ready for public launch (Hacker News):**
- All soft launch items PLUS:
- [ ] #6 WASM print(int) fixed
- [ ] #7 Multi-core default or documented
- [ ] #8 At least shutdown + pool-leak fixed in Forge
- [ ] #9 CI green on Linux
- [ ] #10 Full tutorial + 3 demos
- [ ] #16 Fake target_list entries removed
