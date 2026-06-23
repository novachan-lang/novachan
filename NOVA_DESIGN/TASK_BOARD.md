# NOVA Core-Completion TASK BOARD — the shared brain (single source of truth)

Canonical PRIORITY-ORDERED execution sequence (1→40, no jumping) for CORE_COMPLETION_BACKLOG.md, run under
AGENT_LOOP_STRATEGY.md. Every agent reads this FIRST and updates its row. Opus reconciles each cycle.
LOCK rule: at most ONE in-flight change touching nova_compiler.nova, and one touching nova_runtime.c, at a time.
Tier: 🔴 minimum-bar (before frameworks) · 🟡 full-parity (co-develop w/ first framework). (orig = A–J id from the backlog)

Status legend: TODO · DESIGNING · CODING · GATING · BLOCKED · DONE · REVERTED

## PHASE 0 — sharpen the gate first (compounding speedup; do before grinding the rest)
| # | Item | Tier | Size | Touches | Status | Owner |
|---|------|------|------|---------|--------|-------|
| 1 | Cached runtime `.o` + `-O0` dev link (builds 5.8s→0.3s) | 🔴 | S | build scripts | **DONE** (nova.ps1: SHA+mtime-keyed `.nova_cache`, dev -O0 / `--release` -O2; measured 12s→2.5s, 4.7×; true 0.3s = the interpreter #30) | opus |
| 2 | Parallel test runner + ThreadSanitizer on the C runtime | 🔴 | M | test harness, runtime | **PARTIAL**: parallel runner ALREADY EXISTS (regression RunspacePool, min(8,cores-2); ~17min/mode — the "55min sequential" was a miscount). TSan is UNSUPPORTED on clang `x86_64-pc-windows-msvc` → must run on the WSL/Linux track (where the runtime already cross-compiles). TSan-on-Linux teed up; not a Windows item. | opus |
| 3 | CI (none exists) + perf-regression gate (nova_rt_* call-count=0 on hot paths) | 🔴 | M | CI, bench | TODO | — |

## PHASE 1 — cheap minimum-bar floor (safety + ops; S/M each, low risk)
| # | Item | Tier | Size | Touches | Status | Owner |
|---|------|------|------|---------|--------|-------|
| 4 | Gate the `unsafe` surface (reject ptr_write/alloc_raw/free_raw/extern in safe code) | 🔴 | S | compiler | TODO | — |
| 5 | Symbolic stack traces on panic/assert (file+line+fn; DWARF exists) | 🔴 | M | runtime | TODO | — |
| 6 | Signal handling (SIGTERM/SIGINT/ctrl-C) + lifecycle hooks | 🔴 | M | runtime | TODO | — |
| 7 | Structured logging (levels, sinks, JSON, request context) | 🔴 | M | stdlib | TODO | — |

## PHASE 2 — the two big rocks (XL; adversarial design FIRST, gate every step)
| # | Item | Tier | Size | Touches | Status | Owner |
|---|------|------|------|---------|--------|-------|
| 8 | Constrained generics / structural interfaces (pluggable framework APIs) | 🔴 | XL | compiler | TODO | — |
| 9 | Default-on memory reclamation (scope-exit RC + cycle backstop) — RISKIEST, failed once | 🔴 | XL | compiler+runtime | TODO | — |

## PHASE 3 — ecosystem minimum-bar
| # | Item | Tier | Size | Touches | Status | Owner |
|---|------|------|------|---------|--------|-------|
| 10 | Real package manager (transitive resolver + lockfile + signed/repro + network registry) | 🔴 | L | tooling | TODO | — |
| 11 | Sound crypto (AES-GCM/ChaCha20, Ed25519/RSA, Argon2/PBKDF2); delete legacy broken jwtx | 🔴 | L | stdlib+runtime | TODO | — |
| 12 | N>1 multi-core as a tested default (fix fiber-stack leak + N>1 CI matrix, flip on) | 🔴 | L | runtime | TODO | — |

## PHASE 4 — full-parity: performance
| # | Item | Tier | Size | Touches | Status | Owner |
|---|------|------|------|---------|--------|-------|
| 13 | Float-array C-parity (raw double[], Stage 4) — kills ~120× C gap | 🟡 | L | compiler+runtime | TODO | — |
| 14 | HOF/closure monomorphization (Stage 5) — XL, HIGH RISK (PhD-grade) | 🟡 | XL | compiler | TODO | — |
| 15 | Struct SROA + typed-field unbox + native NOVA→NOVA ABI (Stage 2/3) | 🟡 | XL | compiler | TODO | — |

## PHASE 5 — full-parity: type-system correctness
| # | Item | Tier | Size | Touches | Status | Owner |
|---|------|------|------|---------|--------|-------|
| 16 | Type-system hardening (reset unification budget, type enum payloads, spec, negative tests) | 🟡 | M | compiler | TODO | — |
| 17 | Multi-error compilation (checker silently returns on budget exhaustion today) | 🟡 | M | compiler | TODO | — |

## PHASE 6 — full-parity: concurrency / OTP / Erlang endgame
| # | Item | Tier | Size | Touches | Status | Owner |
|---|------|------|------|---------|--------|-------|
| 18 | First-class OTP layer (Supervisor + restart strategies + GenServer + registry + telemetry) | 🟡 | L | runtime+stdlib | TODO | — |
| 19 | Concurrency fairness (timer-wheel parking, unify async, preemption, file-I/O offload) | 🟡 | L | runtime | TODO | — |
| 20 | Growable/segmented green stacks (millions of processes) — maybe blocked by i64 ABI | 🟡 | XL | runtime | TODO | — |
| 21 | Transparent distribution (node discovery, global PID/registry, term-faithful wire) | 🟡 | XL | runtime+stdlib | TODO | — |
| 22 | Hot code reload (versioned dispatch table + state migration) | 🟡 | XL | compiler+runtime | TODO | — |

## PHASE 7 — full-parity: targets / "runs anywhere"
| # | Item | Tier | Size | Touches | Status | Owner |
|---|------|------|------|---------|--------|-------|
| 23 | ARM/aarch64 fiber switch (silently no-ops today) + macOS runtime + multi-platform CI | 🟡 | L | runtime | TODO | — |
| 24 | Dead-runtime stripping / runtime tiers + static-musl release (tiny binaries) | 🟡 | L | runtime+build | TODO | — |
| 25 | C ABI both directions (@export, struct-by-value FFI, callback thunks) | 🟡 | L | compiler+runtime | TODO | — |
| 26 | Real WASM codegen backend + wasi-sdk (today a no-op stub) | 🟡 | XL | compiler+runtime | TODO | — |
| 27 | no_std/freestanding profile (bare-metal / 64KB-RAM embedded) | 🟡 | XL | runtime | TODO | — |

## PHASE 8 — full-parity: ownership tier
| # | Item | Tier | Size | Touches | Status | Owner |
|---|------|------|------|---------|--------|-------|
| 28 | Owned/move tier + move-checker on-by-default + must-use Result + Drop/RAII | 🟡 | XL | compiler | TODO | — |

## PHASE 9 — full-parity: tooling & DX
| # | Item | Tier | Size | Touches | Status | Owner |
|---|------|------|------|---------|--------|-------|
| 29 | One-command signed installer (msi/brew/apt/curl) bundling runtime+clang | 🟡 | M | packaging | TODO | — |
| 30 | Real interpreter / REPL + notebooks (instant feedback) | 🟡 | L | new backend | TODO | — |
| 31 | Sampling CPU profiler + flamegraph + heap profiler | 🟡 | L | runtime+tooling | TODO | — |
| 32 | Semantic LSP (wire real HM types into completion/hover) | 🟡 | M | compiler+lsp | TODO | — |
| 33 | Working `nova debug` (DWARF + channel/process-aware pretty-printers) | 🟡 | M | tooling | TODO | — |
| 34 | AST-reprinting `nova fmt` (whitespace-only today) | 🟡 | M | compiler | TODO | — |

## PHASE 10 — full-parity: stdlib & advanced
| # | Item | Tier | Size | Touches | Status | Owner |
|---|------|------|------|---------|--------|-------|
| 35 | Compile-time eval (const-fn/comptime) + binary/bitstring pattern matching | 🟡 | L | compiler | TODO | — |
| 36 | Reflection upgrade (invoke-by-name + dynamic construction) + Forge ORM | 🟡 | L | compiler+stdlib | TODO | — |
| 37 | Numeric/AI spine (ndarray + DataFrame + linalg → autograd/optimizers + ONNX/GGUF + GPU/SPIR-V) | 🟡 | XL | runtime+stdlib | TODO | — |

## PHASE 11 — full-parity: stability & correctness contracts
| # | Item | Tier | Size | Touches | Status | Owner |
|---|------|------|------|---------|--------|-------|
| 38 | ABI versioning contract (runtime struct-layout change must not silently corrupt packages) | 🟡 | M | runtime+pkg | TODO | — |
| 39 | Unicode NFC/NFD-aware string equality (functions exist; == ignores them) | 🟡 | S/M | runtime | TODO | — |
| 40 | Forge production hardening (graceful shutdown, HTTP/2, request timeouts, WS backpressure) | 🟡 | M | framework | TODO | — |

---
## Activity log (newest first)
- 2026-06-23: Board created. Priority order locked. Phase 0 next. (HEAD has: N>1 scheduler fix 71a651d, OOB-write fix 8b5ea22, audit 151ef64, backlog eee7c8b, loop strategy 3b369e9.)
