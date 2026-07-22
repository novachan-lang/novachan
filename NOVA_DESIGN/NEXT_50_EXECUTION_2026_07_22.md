# NEXT 50 TASKS — sequenced execution plan (2026-07-22)

Source of truth = `NOVA_MASTER_PLAN_2026_07_10.md` §5 (Waves A/B/C) + §6 (Phase 0–6) + §4.A (language
ceilings L1–L13). The stdlib 100-task campaign delivered PHASE-1 breadth; this list is what the plan
sequences **next**. The governing rule holds: *soundness → correctness-edge → ecosystem → declarative
multiplier → presentation.* **Nothing in a later block starts while its blocking gap is open.**

Center of gravity has shifted to the **compiler + runtime** (Blocks A, B, E = 26 of 50). Each task:
verify current status first (this doc is a snapshot; some may have moved), then edit → gate
(reconverge gen5==gen6 + both-mode nova_ci for any compiler/runtime change) → commit.

Legend: **[rt]** runtime · **[cc]** compiler · **[fg]** Forge/lib · **[std]** stdlib · **[tool]** toolchain · **[lang]** language/compiler feature. Effort S/M/L/XL.

## BLOCK A — Wave B: RC completeness (memory-SAFE leaks; production bar) — do FIRST with Wave C
| # | Task | Area | Effort | Notes / blocking |
|---|---|---|---|---|
| 1 | Wave-B #6 push-of-fresh-temp leak — MOVE-on-insert via borrow-provenance bit (skip insert-inc for proven fresh temps) | [rt/cc] | M | the shared root; unblocks #2,#3. Memory `waveb6`. |
| 2 | Wave-B #7 closure-capture leak — `make_closure` via hashed-alloc + capture managed-slot bitmap; relax escape-mark | [rt/cc] | M | after #1 analysis |
| 3 | Wave-B #8 managed-field-reassignment leak — owning field reads (`field_get`-inc/borrow) so dec-old is sound | [rt/cc] | M | shares root with #1 |
| 4 | Wave-B #9 RC cycle collector — opt-in CPython trial-deletion (`gc_refs`, per-type child enum, free unreachable) | [rt] | XL (supervised) | enables L10 weak/Drop |

## BLOCK B — Wave C: platform + transport reach (parallel with Block A)
| # | Task | Area | Effort | Notes |
|---|---|---|---|---|
| 5 | ARM/aarch64 fiber context switch — add `nova_asm_switch` aarch64 branch (concurrency no-ops on ARM today) | [rt] | L | Apple Silicon/mobile/macOS CI |
| 6 | N>1 per-carrier I/O sharding + work-stealing — split global `nova_io_waiters`, kill `g_sched_lock` hot path | [rt] | L | more cores currently = slower I/O |
| 7 | Safepoint preemption + `kill` — compiler-inserted yield-checks at loop back-edges; timer + doomed flag | [cc/rt] | XL (supervised) | #1 concurrency item; gates soft-realtime + Erlang-parity supervision |
| 8 | ALPN on TLS accept path — enables h2/gRPC over TLS + browser HTTP/2 | [fg] | L | `grep -i alpn` = 0 today |
| 9 | Windows TLS *server* — SChannel server handshake (`nova_rt_tls_listen/accept` are stubs) | [rt/fg] | L | HTTPS on the dev's own OS |
| 10 | Linux FD_SETSIZE ≥1024 → `poll`/`epoll` netpoller (CVE-class stack corruption at high concurrency) | [rt] | M | |
| 11 | DB fidelity — 🔄 NUL-safety MOSTLY DONE: **base32/TOTP ✅** (`7c6f6c99`: `base32_decode_bytes`; fixed ~7.5%-wrong-OTP). **Redis ✅** (`9266fa52`: forge_redis rewritten bytes-based end-to-end — `tcp_send_bytes`/`tcp_recv_bytes` + bulk-as-`bytes` via `bytes_slice` + text/`_bytes` API split; KAT `_redis_binsafe_test` NORMAL+FULLRC green). **PG-DataRow N/A** (forge_pg uses all-TEXT result format — PG never emits raw 0x00 in text values; changing to bytes would regress). **orm_exec affected-rows ✅ DONE `c44508a1`** (Wave-C #7: PG `pg_cmd_affected`+`pg_exec_params`, MySQL `mysql_ok_affected`; all 3 backends return driver count; offline KATs both modes). TRACKED: `std/net/resp2._r2_parse_bulk` has same bulk-str `chr()` truncation (framing safe, value corrupt) — API-changing (`d["str"]`→bytes), no binary consumer today. | [fg/rt] | M | #11+#7 DB-fidelity cluster CLOSED (live-DB e2e pending server) |

## BLOCK C — Phase 1: stdlib correctness-edge (self-contained; daily value)
| # | Task | Area | Effort | Notes |
|---|---|---|---|---|
| 12 | S1 signal handling (SIGINT/SIGTERM/SIGHUP graceful shutdown) — **MISSING** (only `std/os/signalname` = names, not handlers; needs runtime C) — deploy/container blocker | [rt] | M | attended (runtime) |
| 13 | D4 signed bignum — **✅ EXISTS+GATED** (`std/numeric/bignum` tracked; verify signed-completeness) | [fg] | M | finance/crypto base |
| 14 | D2 BigDecimal — **✅ EXISTS+GATED** (`std/numeric/decimal` tracked + `_decimal_test` in manifest; verify completeness) | [fg] | L | after #13 |
| 15 | Argon2id password hashing — **✅ DONE** (`std/crypto/argon2id` tracked + `_argon2id_test` gated) | [fg] | M | best-practice storage |
| 16 | S2 HTTP-client redirects/cookies/proxy — **EXISTS-UNGATED** (`forge/forge_http_client` tracked, no gated test; needs a live/mock-server KAT) | [fg] | M | attended (network test) |
| 17 | S3 sync primitives — **✅ DONE** (`std/sync/mutex`+`semaphore` tracked; `_sync_test` gated single-threaded; added `_syncmutex_test` verifying mutual exclusion under N=1 AND N=4 contention) | [rt] | M | |
| 18 | S5 file perms/symlinks (chmod/umask/symlink/readlink) — **MISSING** (needs runtime C) | [rt] | M | attended (runtime) |
| 19 | S6 unix domain sockets — genuinely MISSING (runtime; Win AF_UNIX+netpoller caveat) | [rt] | M | |
| 20 | D9 binary pack/unpack — **✅ DONE** (`std/encoding/pack` tracked + `_pack_test` gated) | [std] | M | |
| 21 | D6 casefold + graphemes (Unicode) — partial (`std/text/casefold`, `graphemex` now gated) | [fg] | L | also gives `str_eq_canon` |
| 22 | D5 XML parser — **✅ DONE** (`std/text/xml` tracked + `_xmlparse_test` gated; added complementary `_xml_test` for node-shape/whitespace/null-safety) | [fg] | L | |
| 23 | D1 IANA timezones — **MISSING** (no tz module; XL tz-database import) | [fg] | XL | attended (XL data) |

## BLOCK D — Phase 2: ecosystem connective tissue (each reuses the compiler's TiState)
*Reconciliation signals (2026-07-22, need per-feature verification before ticking):* LSP shell + 14
features EXIST (memory `project_lsp_improvements` v0.4.0) — BUT §3.2 gap #9 flags hover/completion as a
regex text-scan not inferer-backed, so T-LSP the *quality* item may still be open (VERIFY which is current).
`nova_pkg.nova` (transitive resolver) EXISTS but CLI-wiring unverified (plan: "unwired"). `nova` CLI has
bench/check/cov/debug/eval/fmt/lint/lsp/repl/test/wasm subcommands; **no `doc` subcommand** → T-Doc likely
open. **No `abi_check`/`abi_hash`** found → T-ABI likely open. T-Profile/T-Install/T-REPL: unverified.
| # | Task | Area | Effort | Notes |
|---|---|---|---|---|
| 24 | T-ABI enforcement — do first; resolver/registry need it | [tool] | S | |
| 25 | T-LSP inferer-backed hover/completion/refs/rename (replace regex text-scan) | [tool] | L | highest-leverage DevX win |
| 26 | T-Pkg wire the (existing) transitive resolver + `nova.lock` into the CLI | [tool] | L | resolver exists, unwired |
| 27 | T-Doc `nova doc` generator (559 modules discoverable) — shares LSP TiState | [tool] | L | |
| 28 | T-Test property-based + mocks + DB-rollback + per-fn ergonomics | [tool] | M | registry quality gate |
| 29 | T-Profile sampling profiler | [tool] | L | |
| 30 | T-REPL productization | [tool] | S | |
| 31 | T-Install signed installer | [tool] | M | |

## BLOCK E — Phase 3: language ceilings (the declarative multiplier) — PURE COMPILER WORK
| # | Task | Area | Effort | Notes / blocking |
|---|---|---|---|---|
| 32 | L11 module-symbol namespacing (`@mod__fn` mangling) — DO FIRST; hard link-error wall; prereq for L1 + registry | [lang] | M | |
| 33 | ✅ **DONE 2026-07-22** — L12 multi-line collection literals (`[...]`/`{...}` newline-as-whitespace, list + dict) | [lang] | S | reconverged + both-mode arc 2694/0/33 |
| 34 | ✅ **DONE 2026-07-22** — L13 keyword-as-variable diagnostic (rejects hard keywords {match,loop,type,unsafe}; contextual like `matches` stay usable) | [lang] | S | reconverged + negative-reject gate + arc 2695/0/33 |
| 35 | L6 enforced immutability (`let` vs `let mut`, shallow; warn-then-error migration) | [lang] | M | correctness + alias analysis |
| 36 | L7 sized/unsigned numerics + f32 — 🔄 **inc1+inc2 DONE 2026-07-22** (suffix literals + range-check; conversion builtins u8()..i64() wrapping/sign-extend); inc3 OPEN (HM width-propagation + wrapping arithmetic + flat arrays) | [lang] | M | unblocks L5/embedded/wire/GPU |
| 37 | L8 custom index/iterator/call operators (structural `index`/`iter`+`next`/`call`) | [lang] | M | unblocks Cortex/Pulse |
| 38 | L3 variance (inferred, surfaced only in errors) | [lang] | L | after trait-conformance (done); prereq L4 |
| 39 | L1a annotations + built-in codegen hooks (Phase-1, 80% — `@route`/`@service`/`@Entity`/`@test`) | [lang] | L | after L11; **THE #1 lever** |
| 40 | L2a comptime-fn-returning-values (Phase-1) — the substrate under L1 | [lang] | M | |
| 41 | L1b user-extensible annotations (Phase-2, typed quasi-quotation, hygienic, fuel-bounded) | [lang] | XL | after L2b |
| 42 | L2b hygienic macros / general comptime (Phase-2) — erases the compiler's own ~700 AST sites | [lang] | XL | widest blast radius (BET 1) |
| 43 | L5 const generics (`const N: int` inferred; dict-dispatch, monomorphize on proven benefit) | [lang] | L | after L7 + L2 |
| 44 | L9 auto numeric tower (overflow→bignum at identified sites; `19.99m` decimal literal) | [lang] | L | after L7 |
| 45 | L10 weak references + user-defined `drop(self)` (structural) | [lang] | M | after Wave-B (Block A) |
| 46 | L4 associated types (`trait Iterator { type Item }`, inferred) | [lang] | XL | after L3 + L1 |

## BLOCK F — Phase 4: presentation layer (BET 2 — the frontend half of the identity)
| # | Task | Area | Effort | Notes |
|---|---|---|---|---|
| 47 | WASM productization (harden the wasm value-model target; FFI callbacks) — prereq for F1 | [cc/rt] | L | Wave-C-adjacent |
| 48 | F5 image codecs + 2D canvas (PNG/JPEG decode + draw) — self-contained on `deflatex` + `bytes` | [fg] | L | unblocks charts/avatars |
| 49 | F1 browser DOM/reactive UI — Prism-web (hybrid LiveView/WASM, same `view_fn` both sides) | [fg] | XL | THE adoption magnet; after #47 |
| 50 | F2 native GUI — Prism-desktop (window + widgets via FFI callbacks + wgpu) | [fg] | XL | after FFI maturity + L7 |

---

**Beyond 50** (Phase 5–6, gated on the above): F6 broker clients (Kafka/NATS/MQTT), F8 cloud SDKs,
F10 OpenTelemetry, F9 PDF/XLSX, F4 Pulse dataframe, Sentinel/Mesh/Ops frameworks; then the numeric
frontier — F7 GPU lowering (SPIR-V/PTX), F3 Cortex autodiff, Reactor game engine, Edge/MCU.

**Recommended immediate start:** Block A (#1 push-of-fresh-temp leak — the shared RC root) + Block E
#32 (L11 namespacing — the prerequisite wall for the whole declarative multiplier). Both are compiler/
runtime and both unblock the widest downstream set.
