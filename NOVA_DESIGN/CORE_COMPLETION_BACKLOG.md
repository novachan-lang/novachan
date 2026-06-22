# NOVA Core-Completion Backlog — "beat C/C++/Java/Python/Rust/Go/Elixir/Erlang/JS"

> From an 11-agent workflow (2026-06-23): 9 per-competitor specialists + synthesis + adversarial critic.
> Grounded in COMPLETENESS_AUDIT_2026_06_22.md. Frontend is tracked separately and EXCLUDED here.
> **Strategic verdict (synthesis + critic agree): "beat them all THEN frameworks" is the WRONG sequence.**
> Ship the minimum bar, then CO-DEVELOP the rest WITH the first framework. Don't gate framework work on full parity.

## NOVA already WINS or TIES (real credit — the everyday core is competitive)
Scalar/int/struct-float ≈1.0× clang -O2 with ZERO annotations (beats V8/HotSpot at peak — no JIT warmup);
wrapping arithmetic (more predictable than C's signed-overflow-UB); zero-ceremony generics (beats C++ DX);
uncolored transparent spawn+channels+netpoller (10k tasks/382ms, no async-color tax); Erlang-shape fault
tolerance at N=1 (mailboxes/selective-receive/monitors/supervisor); data-race freedom STRUCTURALLY via
channel deep-copy (no Send/Sync); typed Result+?+use-after-move-as-compile-error; best-in-class error
messages; structural reflection → automatic struct↔JSON (beats Java annotations); pattern matching + pipe
(rivals Elixir); per-request ARENA (BEATS Go/Erlang/Java GC on the request hot path); dynamic flexibility
without losing static safety on the typed 95%.

## MINIMUM BAR — ~12 items that make framework authoring sane (do these first)
Counts: synthesis said 7; critic credibly raises to ~10-12 (adds interfaces, logging, signals, stack traces, CI).

1. **Default-on memory reclamation** — scope-exit RC (atomic inc-before-dec) for the non-arena path + cycle backstop. **XXL, HIGHEST RISK** (already failed once: iter-88 → 33 UAFs, reverted; own design review has 1 FATAL + 6 HIGH). The single most-cited blocker: default code leaks ~2000 objs/iter; a Forge handler leaks ~16k objs/request. Soundness oracle = full regression + ASAN. A quarter on its own; consider splitting (scope-exit RC | cycle collector). [addresses ALL 9]
2. **Cached runtime `.o` + default `-O0` dev link** (reserve -O2/LTO for `--release`). **S — HIGHEST LEVERAGE.** Measured: 5.8s → 0.32s builds. The .o already sits unused in-tree. [Go, Python, JS]
3. **Constrained generics / structural interfaces** — bounded generics, interface-typed params, default methods, static+dynamic dispatch, bounds INFERRED via NTypeScheme. **XL.** Critic: MUST be minimum-bar (re-tiered from full-parity) — framework APIs (handler/middleware/driver/serialization contracts) need it; building on untyped `any` = JS/Python tech debt. [Rust traits, Go interfaces, Elixir behaviours]
4. **Real package manager** — transitive PubGrub/SAT resolver, lockfile + content-integrity + **reproducible + signed** builds, network registry client + hostable registry, `nova add`/`publish`. **L.** [Rust, Java, Python, Go, Elixir, JS]
5. **Sound crypto stdlib** — AES-GCM/ChaCha20-Poly1305, SHA-2/3, KDF (Argon2id/PBKDF2), Ed25519/RSA. **L.** Critic nuance: Forge's OWN jwt already uses proper HMAC+constant-time; the broken `sha256(msg+key)` is the LEGACY `jwtx.nova` → just delete/deprecate it (not a live CVE in Forge). [Java, Python, Rust, JS]
6. **Gate the `unsafe` surface** — require `unsafe`/capability block around ptr_read/ptr_write_f64/alloc_raw/free_raw/memcpy_unsafe/extern; reject in safe code. **S.** Pairs with the shipped OOB-write fix (8b5ea22). [C, C++, Rust]
7. **N>1 multi-core as a regression-covered default** — fix fiber-stack leak; N>1 CI matrix (channels/select/supervisors/10k under NOVA_CARRIERS=2/4/8 + ASAN + lost-wakeup test); flip default once green. **L.** [Java, Go, Elixir, Erlang]
8. **CI (none exists) + perf regression gate** — Windows+Linux matrix; compile canonical benchmarks NOVA vs clang -O2, assert nova_rt_* call-count=0 on hot paths + ratio tolerance, fail on regression. **M (CI) + S (gate).** Critic: the gate is useless without CI, which is currently absent. [all]
9. **Structured logging** — levels, sinks (stdout/file/JSON), request-scoped context. **M.** Today only print() + unstructured mw_logger. [all]
10. **Signal handling** (SIGTERM/SIGINT/ctrl-C) + lifecycle hooks. **M.** CORE, not Forge-specific: without it every containerized NOVA process is unkillable / leaks on interrupt. [all]
11. **Symbolic stack traces** on panic/assert (file+line+function). **M.** DWARF exists; the panic path calls no unwinder (libunwind/CaptureStackBackTrace). Highest-impact DX item after error messages. [all]
12. **ThreadSanitizer on the concurrent C runtime** + **parallel test runner** (suite is ~55 min sequential). **M.** The "structural data-race freedom" claim only holds if the runtime itself is race-free — it's plain C with manual locking, never TSan'd. [—]

## FULL COMBINED-PARITY — ~20 more (co-develop WITH frameworks; the framework tells you order)
**Performance endgame:** Stage-4 raw `double[]` float arrays + guarded native load (kills ~120× C gap); Stage-5 HOF/closure whole-program monomorphization (**XL, HIGH RISK — PhD-grade; the unsound ti_fn_param_types shortcut already broke math3d/complexnum**); Stage-3 struct SROA + Stage-2 typed-field unbox + native NOVA→NOVA ABI (struct-passing 1.21-1.32× C today).
**Reach:** ARM/aarch64 fiber switch (currently SILENTLY no-ops) + macOS runtime (kqueue, never run) + multi-platform CI; real WASM codegen backend + wasi-sdk; no_std/freestanding (64KB-RAM embedded); dead-runtime stripping / tiers + static-musl release.
**Ownership tier:** OWNED/move tier + move-checker on-by-default + must-use Result + per-value Drop/finalizer (RAII for files/sockets/locks). **XL.**
**Erlang/Elixir endgame:** first-class Supervisor + child specs + restart strategies + GenServer behaviour + links/trap_exit + named registry + telemetry/observability; growable/segmented green stacks (**XL — may be BLOCKED by the uniform i64 ABI: stack-copy can't update pointers indistinguishable from ints**); preemption + netpoller/timer-wheel parking (replace busy-poll select/after) + file-I/O offload; transparent distribution (epmd analog, global PID, term-faithful wire) + hot code reload (versioned dispatch table + state migration).
**Java/Python ecosystem:** tree-walking interpreter/REPL + notebooks (**L-XL, NOT plumbing**); sampling CPU profiler + flamegraph + heap profiler (current "profiler" is a wall-clock timer); one-command signed installer (msi/brew/apt/curl) bundling runtime+clang; method-invoke-by-name + dynamic struct construction (ORM/Spring foundation) + a Forge ORM (typed schema↔table, query builder, migrations, Postgres); numeric/AI spine (ndarray + DataFrame + linalg → autograd/optimizers + ONNX/GGUF + real GPU/SPIR-V backend, currently one hardcoded OpenCL vadd); compile-time eval (const-fn/comptime) + binary/bitstring pattern matching.
**Stability contracts:** ABI versioning (RTTI slot / struct-layout change silently corrupts installed pre-compiled packages — STRUCT_RTTI adversary flagged); Unicode NFC/NFD-aware string equality (functions exist, equality doesn't use them); multi-error compilation (type checker silently RETURNS on budget exhaustion → ~1 error/compile); Forge production hardening (graceful drain, HTTP/2 or keep-alive correctness + conn limits, request timeouts, WS dead-client backpressure).

## Sizing/risk callouts (critic)
- #1 memory = XXL, already failed once, riskiest in the backlog. #3 interfaces = mis-tiered up to minimum-bar.
- Stage-5 monomorphization + growable stacks = XL + may be blocked by the i64 ABI value model.
- "fast dev loop" splits into S (cached .o) + L-XL (interpreter). "Toolchain DX" is 5 tools (LSP M, debug M, profiler L, fmt M, test M) — profiler deserves its own line.
- The crypto "CVE today" overstates shipped risk (Forge jwt is fine; jwtx is legacy).

## Recommended first moves
Cheap high-leverage first (days each): cached runtime .o (#2), unsafe gate (#6), CI+perf gate (#8), signals (#10), stack traces (#11), structured logging (#9). Then the two big rocks: default-on memory (#1) and interfaces (#3). THEN build Forge for real and let it pull the full-parity tier forward.
