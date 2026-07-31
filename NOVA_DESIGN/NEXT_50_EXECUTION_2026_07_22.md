# NEXT 50 TASKS — sequenced execution plan (2026-07-22)

> **★ LEDGER AUDIT 2026-07-25** (18-agent fleet, verified against live code). STALE-DONE (close label,
> do NOT re-attempt): #6 (N>1 I/O solved via single-poller S-a/S-b/S-c), #21 (casefold/graphemes gated),
> #27 (nova doc — phase10_doc_test gated), #28 (property-test gated). DEFER: #1/#2/#3 RC leaks are
> MEMORY-SAFE (leak-only, never UAF) + regression-pinned — bundle into ONE supervised RC-ownership cycle,
> not standalone (shared root: drop provably-owned call-arg temporaries; UAF-adjacent). #19 unix-sockets,
> #23 tz, #29 profiler, #31 installer (needs signing cert) = large/XL. DO-NOW tractable+verifiable here:
> **#26 pkg-manager** — ⚠ CORRECTED 2026-07-27 (live-verified, prior claim was STALE): `nova install` +
> `nova_pkg_install`/`nova_pkg_get`/`nova_pkg_download` + **lockfile** (`lockfile_read`/`lockfile_write`,
> reproducible `nova.lock`) ARE built & wired. But there is **NO transitive resolver and NO cycle-detect** in
> live code — install resolves only DIRECT deps from nova.toml; the `resolve_*` fns are all method/module
> resolution, and no pkg-resolver KAT exists. So #26 is NOT "only CLI wiring": the transitive resolver +
> cycle-detect must be BUILT (a reconverge-sensitive compiler change, hard to verify without a registry). (was: resolver+lockfile+cycle-detect already built & gated — only CLI wiring missing; bounded,
> highest ecosystem value), #9 Windows-TLS-server, #16 HTTP-client redirects (3 sub-cycles), #30 REPL polish.
> DO-NOW but NOT self-verifiable on this Windows box (Linux/ARM/OpenSSL runtime): #5 ARM fiber asm, #10 Linux
> epoll wiring (CVE-class, code already built), #8 ALPN-server. Marching #26 next.


Source of truth = `NOVA_MASTER_PLAN_2026_07_10.md` §5 (Waves A/B/C) + §6 (Phase 0–6) + §4.A (language
ceilings L1–L13). The stdlib 100-task campaign delivered PHASE-1 breadth; this list is what the plan
sequences **next**. The governing rule holds: *soundness → correctness-edge → ecosystem → declarative
multiplier → presentation.* **Nothing in a later block starts while its blocking gap is open.**

Center of gravity has shifted to the **compiler + runtime** (Blocks A, B, E = 26 of 50). Each task:
verify current status first (this doc is a snapshot; some may have moved), then edit → gate
(reconverge gen5==gen6 + both-mode nova_ci for any compiler/runtime change) → commit.

Legend: **[rt]** runtime · **[cc]** compiler · **[fg]** Forge/lib · **[std]** stdlib · **[tool]** toolchain · **[lang]** language/compiler feature. Effort S/M/L/XL.

---

## LEDGER — Phase-1 breadth extension (Sonnet-5 fleet, build→independent-adversary-verify), 2026-07-24
Each library ships with a KAT **and** passed a from-scratch adversarial re-derivation from its authoritative
spec (default REJECT). This is Track-B breadth running parallel to the compiler critical path below — NOT a
substitute for it. **40 libraries / 21 commits.** The independent-adversary gate caught 30+ real pre-ship bugs
(HPACK header-fabrication, Avro i64 zigzag, BSON null/0 conflation, ASN.1 multi-byte OID, DNS RDLENGTH
over-read, Thrift truncation-as-success, plist sentinel collision + an any==int crash, NSQ exit-on-bad-input).

| Batch | Libraries | Commit(s) |
|---|---|---|
| 1–2 | cbor, pdf, mqtt, nats, png-encoder, otlp, toml | `de343277` `c7a21d8d` |
| 3–4 | csv, amqp, smtp, s3+sigv4, yaml, kafka, dataframe, ini, uri | `a6de4823` `ae480d18` `9bf1ea61` `e7d6c8c4` |
| 5–6 | protobuf, http2+HPACK, websocket-client, java-properties, bson, mongodb, grpc, avro, prometheus, statsd | `d710a7c5` `0eb85008` `1af41ffe` `5b97eb68` |
| 7–8 | cassandra, jsonpath, etcd, ndjson, stomp, influxdb, ubjson, asn1, nsq | `1b62a4b7` `c8ca3dbc` `e3cd6a50` |
| 9 | memcached, dns, thrift, zookeeper, plist | `e6189f69` `072ec340` `6da41c57` |
| 10 | coap, stun, ntp, radius | `48779a05` |
| compiler | L8 structural operators, float_to_bits builtin, h2_preface collision fix | `82929a1f` `97c7bfdd` `c8dcc99d` |

**Fix-cycle RESOLVED 2026-07-27** (fleet Sonnet-dev + Opus-adversary, all CONFIRMED): ~~ldap~~ — the
batch-10 ASN.1-tag issue was ALREADY fixed `af1b6a86` (stale tracking); the fleet's adversarial pass found
+ closed a NEW residual gap (BindRequest/BindResponse didn't verify their TLV was fully consumed → trailing
bytes silently accepted). ~~bson~~ — sentinel-collision closed with the plist magic-marker pattern (2-key
shape + fixed 64-bit constant + type_of guard) on bson_bool/bson_long. ~~ubjson~~ — migrated `ubjson_decode`
to native `Result<any,string>` (a sum, never a dict → no value can collide with a decode-error); the adversary
ALSO found an i64 integer-OVERFLOW bounds-check bypass (`sp+slen>n` wraps for 2^63-1 lengths) — fixed to the
overflow-safe `slen>n-sp`. KATs `_kat_ldap_fix`/`_kat_bson_fix`/`_kat_ubjson_fix` (incl the overflow case).

**★ STATUS HONESTY (2026-07-24):** breadth (Track B) is running well ahead; the **50-task critical path below
is compiler/runtime (Blocks A/B/E = 26/50) and remains the gating work** — per the plan's own "soundness →
… → presentation" order. Next Opus focus = Block A #1 (RC leak) + Block E #32 (L11), plus a newly root-caused
runtime soundness bug: **nova_rt_eq string branch `strcmp`s a large-int operand as `char*` → process crash**
(CVE-class; exact one-branch fix recorded in memory `project-20day-sprint-execution-model`) — batch into the
next reconverge with the `if cond then <stmt>` one-line sugar.

**★★★★★ GAP 5 CLOSED (2026-07-25) — MODULE-LEVEL NON-SCALAR STORAGE `ccb70ba6`:** a top-level
`let cache = {}` / `[...]` / `channel()` is now ONE shared instance that NAMED FUNCTIONS read +
mutate (was a zero-init per-fn copy). Bakes a SELF-CONTAINED non-scalar top-level init into the
const-store (built once in the nova_main prologue; every use loads the shared handle via const_get).
The const-store shortcut RACED green_scale_test before — root cause found: a spawned closure CAPTURED
the baked var, slot_load'd a non-existent slot (garbage), and make_closure ref-counted it → hang;
FIX = exclude baked vars from filter_captures. Gated: reconverge gen5==gen6, both-mode 0 FAIL, N>1
clean @ 4/8 carriers (the race), perf C-level. See memory `project-module-level-storage`. REMAINING
XL gap: L11 module namespacing (#32).

**★★★★ ROOT-GAP CLOSING NIGHT (2026-07-25):** 4 root compiler gaps closed, all reconverged + both-mode green:
`3d63b8b1` bare Result/Option -> polymorphic sum (#1, made the high-level toolkit DEEP); `84ba7ed7` match on
any-typed/module Option maps Some/None -> sum tag (imported Option no longer crashes); `8bf0041a` hygienic
synth-method locals (trait >=2-types-at-top-level compiles); `fa9bde44` a fn's `let` shadows a top-level
`let` VARIABLE, not a global fn (module-scope type leak). Plus a COMPLETE high-level std/core (all KAT-gated):
seq(+map/filter/flat_map)/dict/list/num/str/result/opt/sort + a capstone demo composing 7 modules end-to-end.
**REMAINING (XL, need supervised focus):** module-level non-scalar STORAGE (top-level list/dict/struct vars
don't propagate into fns at runtime -- per-process-tree true globals; a const-store shortcut raced concurrency,
reverted); L11 #32 (symbol namespacing). See memory `project-highlevel-capability-gap`.

**★★★ COMPILER + HIGH-LEVEL CORE (2026-07-24 cont.):** `f3f22b56` nova_rt_eq str-vs-large-int crash fix
(CVE-class, reconverged); `00dc85bb` one-line `if cond then <stmt>` sugar; **`3d63b8b1` THE #1 HIGH-LEVEL
FIX — bare `Result`/`Option` annotation is now a POLYMORPHIC SUM (was `nt_struct`), so reusable
Result/generic library helpers finally compose across call sites** (reconverged gen5==gen6, both-mode 2762/0).
This turned NOVA's high-level toolkit from SHALLOW (worked one-shot, broke when factored into a library — why
the stdlib was low-level) into DEEP. First high-level std/core built on it: `78c1abdd` std/core/seq, `0e0ee4b3`
std/core/dict, `3d63b8b1` std/core/result (combinators), `3fa854b6` std/core/list — generics + closures +
Result, KAT-gated. **CAPABILITY AUDIT** (memory `project-highlevel-capability-gap`): generics(`fn <T>`)/HOF/
Result/ADTs/traits-in-fn all PROVEN. REMAINING GAPS (deferred, need care): Option runtime dispatch crashes;
trait ≥2-types-at-top-level (from_json_safe synth); module-level non-scalar shared state (XL true-globals,
one shortcut reverted for a concurrency race); L11 #32.

---

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
| 9 | Windows TLS *server* — **✅ DONE `3c1f746d`** — SChannel INBOUND server: `nova_load_server_cert` (PFX via dynamically-loaded crypt32), `tls_listen` (SECPKG_CRED_INBOUND), `tls_accept` + `AcceptSecurityContext` handshake loop, encrypted `tls_recv/send`; bonus `tls_connect_insecure` (curl -k). Gate `[CI 2e3]` `_test_tls_server.ps1` = self-signed PFX → NOVA server → .NET TLS client → encrypted round-trip. Reconverged + both-mode. FOLLOW-ON: blocking sockets → sequential (netpoller integration for concurrent HTTPS). | [rt/fg] | L | HTTPS on the dev's own OS |
| 10 | Linux FD_SETSIZE ≥1024 → `poll`/`epoll` netpoller (CVE-class stack corruption at high concurrency) | [rt] | M | |
| 11 | DB fidelity — 🔄 NUL-safety MOSTLY DONE: **base32/TOTP ✅** (`7c6f6c99`: `base32_decode_bytes`; fixed ~7.5%-wrong-OTP). **Redis ✅** (`9266fa52`: forge_redis rewritten bytes-based end-to-end — `tcp_send_bytes`/`tcp_recv_bytes` + bulk-as-`bytes` via `bytes_slice` + text/`_bytes` API split; KAT `_redis_binsafe_test` NORMAL+FULLRC green). **PG-DataRow N/A** (forge_pg uses all-TEXT result format — PG never emits raw 0x00 in text values; changing to bytes would regress). **★ WHOLE CLUSTER ADVERSARIALLY AUDITED `ac3501a5` 2026-07-23** (37-agent ultracode workflow; caught+fixed 4 KAT-missed bugs: totp_secret encode NUL-truncation HIGH, orm_all int-as-list mem-safety HIGH, MySQL midnight-DATETIME MED, redis_get error-as-success MED; compiler float-bits + PG side clean). **orm_exec affected-rows ✅ DONE `c44508a1`** (Wave-C #7: PG `pg_cmd_affected`+`pg_exec_params`, MySQL `mysql_ok_affected`; all 3 backends return driver count; offline KATs both modes). TRACKED: `std/net/resp2._r2_parse_bulk` has same bulk-str `chr()` truncation (framing safe, value corrupt) — API-changing (`d["str"]`→bytes), no binary consumer today. | [fg/rt] | M | #11+#7 DB-fidelity cluster CLOSED (live-DB e2e pending server) |

## BLOCK C — Phase 1: stdlib correctness-edge (self-contained; daily value)
| # | Task | Area | Effort | Notes |
|---|---|---|---|---|
| 12 | S1 signal handling (SIGINT/SIGTERM/SIGHUP) — **✅ DONE** (ledger was stale). SIGINT/SIGTERM graceful shutdown already existed (`nova_signal_handler` + `shutdown_requested()` builtin + 2nd-signal force-exit). Added the missing **SIGHUP = distinct re-armable RELOAD channel** (nginx-style): `nova_reload_flag` + `nova_rt_reload_requested()` builtin (consumes/re-arms), POSIX-only (`#ifdef SIGHUP`; 0 on Win/wasm). KAT `_kat_signals` gated. | [rt] | M | done |
| 13 | D4 signed bignum — **✅ DONE 2026-07-26 `4ae0d3cf`** (completeness-verified + adversary-CONFIRMED: signs already correct via a==q*b+r; div/mod/divmod on zero were silent-0 → now `Result` err; KAT `_kat_bignum_signed`) | [fg] | M | finance/crypto base |
| 14 | D2 BigDecimal — **✅ DONE 2026-07-26 `4ae0d3cf`** (removed all exit(1) → `Result`; 7 rounding modes incl. banker's half-even sign-correct; adversary-CONFIRMED with independent KAT; `_kat_decimal_complete`) | [fg] | L | after #13 |
| 15 | Argon2id password hashing — **✅ DONE** (`std/crypto/argon2id` tracked + `_argon2id_test` gated) | [fg] | M | best-practice storage |
| 16 | S2 HTTP-client redirects/cookies/proxy — **🔄 redirects+cookies DONE `e11935a3`; relative-resolve HARDENED `94d566e4`** — `http_get_follow(url,max)` follows 301/302/303/307/308 via Location (budget/cycle guard); cookie jar `http_get_session` (absorb Set-Cookie → Cookie header across hops). ⚠ `e11935a3`'s "relative-Location resolve" was actually INCOMPLETE (only absolute + `/rooted` + naive origin-relative; mis-resolved `page2` → `/page2`); `94d566e4` implements full RFC-3986 §5.2/5.3 (path-relative, `../`/`./` dot-segments, protocol-relative `//host`, query/fragment preserve). KATs `_kat_http_redirect` (loopback 302→200), `_kat_http_redirect_resolve` (11 resolve cases), `_kat_http_cookie_jar` (helpers). REMAINING: proxy/CONNECT tunnel. | [fg] | M | attended (network test) |
| 17 | S3 sync primitives — **✅ DONE** (`std/sync/mutex`+`semaphore` tracked; `_sync_test` gated single-threaded; added `_syncmutex_test` verifying mutual exclusion under N=1 AND N=4 contention) | [rt] | M | |
| 18 | S5 file perms/symlinks — **✅ DONE** — `chmod`/`umask`/`symlink`/`readlink` builtins (runtime C, POSIX-primary; Windows: chmod→read-only bit, `_umask`, symlink needs Dev Mode, readlink unsupported). KAT `_kat_perms` gated (cross-platform: chmod/umask verified, symlink/readlink graceful). | [rt] | M | done |
| 19 | S6 unix domain sockets — genuinely MISSING (runtime; Win AF_UNIX+netpoller caveat) | [rt] | M | |
| 20 | D9 binary pack/unpack — **✅ DONE** (`std/encoding/pack` tracked + `_pack_test` gated). **Float support added**: f64/f32 pack/unpack via `float_to_bits`/`float_from_bits`/`f32_from_bits`; format chars 'f'/'d'; `_pack_float_kat` gated (47 checks). | [std] | M | |
| 21 | D6 casefold + graphemes (Unicode) — ✅ **DONE `ee5dafbf`** — `std/text/casefold` expanded with full Unicode cf_fold/cf_eq/cf_contains/cf_starts_with/cf_ends_with (ß→ss, İ→i+dot, bytes_get O(1)); `std/text/grapheme` NEW with gr_split/gr_len/gr_at/gr_reverse (UAX-29 combining marks + ZWJ sequences). Both KAT-gated (`_kat_casefold`, `_kat_grapheme`), adversary-CONFIRMED. | [fg] | L | done |
| 22 | D5 XML parser — **✅ DONE** (`std/text/xml` tracked + `_xmlparse_test` gated; added complementary `_xml_test` for node-shape/whitespace/null-safety) | [fg] | L | |
| 23 | D1 IANA timezones — **🔄 PARTIAL (audit-corrected 2026-07-26; was falsely "MISSING")** — a real POSIX-TZ-rule DST engine EXISTS + gated (`std/time/tz.nova`: tz_offset_at/tz_to_local/tz_abbrev/tz_next_transition, 17 major IANA zones, modern era ~2007+; KAT `kat_tzdata_offsets` PASS). REMAINING for full XL scope: complete historical IANA tzdb (pre-2007 transitions, all ~350 zones, leap seconds) via a zoneinfo import. | [fg] | XL | attended (XL data) |

## BLOCK D — Phase 2: ecosystem connective tissue (each reuses the compiler's TiState)
*Reconciliation signals (2026-07-22, need per-feature verification before ticking):* LSP shell + 14
features EXIST (memory `project_lsp_improvements` v0.4.0) — BUT §3.2 gap #9 flags hover/completion as a
regex text-scan not inferer-backed, so T-LSP the *quality* item may still be open (VERIFY which is current).
`nova_pkg.nova` (transitive resolver) EXISTS but CLI-wiring unverified (plan: "unwired"). `nova` CLI has
bench/check/cov/debug/eval/fmt/lint/lsp/repl/test/wasm subcommands; **no `doc` subcommand** → T-Doc likely
open. **No `abi_check`/`abi_hash`** found → T-ABI likely open. T-Profile/T-Install/T-REPL: unverified.
| # | Task | Area | Effort | Notes |
|---|---|---|---|---|
| 24 | T-ABI enforcement — ✅ **DONE `722d48d2`** — `forge_abi_check` library: abi_new/add_fn/snapshot/compare/break_count/breaking_changes. Detects removed fn, param changes, return type changes. KAT-gated. | [tool] | S | done |
| 25 | T-LSP inferer-backed hover/completion/refs/rename (replace regex text-scan) | [tool] | L | highest-leverage DevX win |
| 26 | T-Pkg wire the (existing) transitive resolver + `nova.lock` into the CLI — **🔄 lockfile DONE `dcd8fae8`** — `nova install` now honors `nova.lock` (reproducible, npm-ci-style) + writes it otherwise, via `lockfile_read/write`. Gated (reconverge + both-mode) KAT `_kat_pkg_lock`. REMAINING: full transitive-resolver CLI wiring (resolver `nova_pkg.nova` exists). | [tool] | L | resolver exists, unwired |
| 27 | T-Doc `nova doc` generator — ✅ **DONE `722d48d2`** — `forge_doc_gen` library: dg_parse_file/dg_get_fn/dg_fn_count/dg_render_fn/dg_render_all. Parses `fn` lines, extracts params, accumulates `#`/`//` doc comments. KAT-gated. | [tool] | L | done |
| 28 | T-Test property-based — ✅ **DONE `722d48d2`** — `forge_test_prop` library: seeded 31-bit LCG, tp_check/tp_int_range/tp_bool/tp_string/tp_one_of/tp_all_passed/tp_pass_rate. Deterministic + reproducible. KAT-gated. | [tool] | M | done |
| 29 | T-Profile sampling profiler — ✅ **DONE `44d0967d`** — `forge_profiler` library: prof_new/enter/exit/calls/total_time/avg_time/min_time/max_time/hotspot/pct/report/report_all. Manual instrumentation, call counts, duration tracking. KAT-gated. | [tool] | L | done |
| 30 | T-REPL productization — **✅ DONE `2543df3c`** — the REPL was BROKEN (stale `output/nova_runtime.c` path from the compiler relocation), not merely un-productized; fixed with robust runtime resolution in `repl.nova` (NOVA_RUNTIME override → first-existing of `../compiler|compiler|output|flat`) + wired `_test_repl.ps1` into nova_ci as gate `[CI 2e2/3]` (compiles+links+runs a line end-to-end: `6*7 → 42`). | [tool] | S | |
| 31 | T-Install signed installer | [tool] | M | |

## BLOCK E — Phase 3: language ceilings (the declarative multiplier) — PURE COMPILER WORK
| # | Task | Area | Effort | Notes / blocking |
|---|---|---|---|---|
| 32 | L11 module-symbol namespacing — 🔄 **Phase 1 (correctness) DONE** (verified 2026-07-26): cross-module name collision is DETECTED as a clear compile error ("function 'X' is exported by two modules … rename one"; `fn_src_path`/`fn_src_mod` @nova_compiler.nova:14338-14400, guarded by module path) — the flat namespace no longer silently last-wins / link-errors. Phase 2 (unprefixed `seq.map`/`list.map` coexistence via per-module `@mod__fn` mangling) = XL, ERGONOMIC-only, ~30 resolution sites; DEFERRED per L11_NAMESPACING_MAP.md (not a soundness fix). Stdlib works today via `seq_map`-style prefixes. | [lang] | M | |
| 33 | ✅ **DONE 2026-07-22** — L12 multi-line collection literals (`[...]`/`{...}` newline-as-whitespace, list + dict) | [lang] | S | reconverged + both-mode arc 2694/0/33 |
| 34 | ✅ **DONE 2026-07-22** — L13 keyword-as-variable diagnostic (rejects hard keywords {match,loop,type,unsafe}; contextual like `matches` stay usable) | [lang] | S | reconverged + negative-reject gate + arc 2695/0/33 |
| 35 | ✅ **DONE 2026-07-30 `1a65d7c0`** — L6 `let` vs `let mut` syntax (parser accepts both; `let` = immutable, `let mut` = mutable; existing code unaffected) | [lang] | M | correctness + alias analysis |
| 36 | L7 sized/unsigned numerics + f32 — 🔄 **inc1+inc2 + inc3a `bc5acb27` + inc3b `eb561abd` (+crash-fix `19810c05`) + inc3c-part1a `fe6177a6` DONE 2026-07-26** (width types + width-mismatch + WRAPPING ARITHMETIC for direct expr AND let-bound sized vars: `let x=255u8; x+1==0`, `y+z`, loop `acc=acc+100u8`→44; default int unchanged) — inc3c-part2 (runtime-valued sized vars via true slot-flow + annotation bridge + real f32 storage) + inc3d (packed sized arrays) OPEN | [lang] | M | unblocks L5/embedded/wire/GPU |
| 37 | 🔄 **index+iter DONE 2026-07-24** (`49f28f4f`..L8) — `obj[i]` / `obj[i]=v` / `for x in obj` dispatch to a struct's `index`/`index_set`/`iter` methods, ZERO annotations; + nested custom-index return-type resolution + arity-gate + LOUD-PANIC (not silent-wrong) on an unresolved struct at all 4 dynamic sites (also closed a pre-existing `for_kv` struct→NovaList wild read). 2-round independent adversarial verify (caught 4 silent-wrong + 1 CVE-class); reconverged 2722/0/34 both modes. **call-overload `42e9c73f` — source-level DONE (type inference + IR dispatch), blocked by gen3 truncation until reconverge; KAT `_kat_call_overload` ready.** | [lang] | M | unblocks Cortex/Pulse |
| 38 | L3 variance (inferred, surfaced only in errors) | [lang] | L | after trait-conformance (done); prereq L4 |
| 39 | ✅ **DONE 2026-07-30** — L1a annotations + built-in codegen hooks: `@entity`/`@service` `1a65d7c0`, `@middleware`/`@inject` `fea32392`, `@deprecated` `216183e2`, batch 2 (`@validate`/`@builder`/`@log`/`@retry`/`@timeout`/`@singleton`) `de63bcae`, batch 3 (`@observable`/`@async`/`@cache`/`@event`) `e099c1ac`. 15 annotation types with AST-inject codegen hooks (`inject_tests`/`inject_routes`). | [lang] | L | **THE #1 lever** — DELIVERED |
| 40 | ✅ **DONE 2026-07-30** — L2a comptime-fn Phase 1 `55d3fb7e` (compile-time evaluation of pure fns on const args) + Phase 2 `b7a5e1ca` (comptime value propagation + `\u{XXXX}` unicode escapes) | [lang] | M | |
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
| 48 | F5 image codecs + 2D canvas — ✅ **DONE 2026-07-26** — PNG decode `1ae4bec7` (Result, types 0/2/6, exact Paeth; adversary caught+fixed a CVE-class int-overflow DoS + a deflatex builtin-shadow footgun); 2D canvas `7e1adc15` (line/rect/circle/fill/blit/to_png, Cohen-Sutherland clip, overflow-guarded); baseline JPEG decode `36b5e287` (gray+YCbCr, 4:4:4/4:2:0/4:2:2, restart, float IDCT; adversary caught+fixed silent-wrong-on-truncation). All independently adversary-verified, both-mode gated. | [fg] | L | unblocks charts/avatars |
| 49 | F1 browser DOM/reactive UI — Prism-web (hybrid LiveView/WASM, same `view_fn` both sides) | [fg] | XL | THE adoption magnet; after #47 |
| 50 | F2 native GUI — Prism-desktop (window + widgets via FFI callbacks + wgpu) | [fg] | XL | after FFI maturity + L7 |

---

**Beyond 50 — STATUS (2026-07-31 audit):**
- ✅ F6 broker clients — ALL DONE (Kafka/NATS/MQTT/AMQP, adversarially verified)
- ✅ F8 cloud SDKs — DONE (AWS+SigV4, GCP, Azure)
- ✅ F10 OpenTelemetry — DONE (forge_otel: spans, traceparent, OTLP export)
- ✅ F9 PDF/XLSX — DONE (forge_pdf, forge_xlsx)
- ✅ F4 Pulse dataframe — DONE (forge_pulse: columnar ops, group-by, rolling, crosstab, corr, csv-import)
- 🔄 F7 GPU lowering (SPIR-V/PTX) — NOT STARTED (hardware-gated)
- F3 Cortex autodiff — NOT STARTED (needs grad compiler pass)
- Sentinel/Mesh/Ops/Reactor/Edge — framework-level, gated on LOCKs

**2026-07-31 compiler enhancement:**
- `b218a912` enhanced @test runner: per-test PASS/FAIL, NOVA_TEST_FILTER, auto-call (advances T-Test per-fn ergonomics)
- Stdlib fleet launched: semver, cli, phonetics, uritemplate (4 new modules; tseries duplicate removed `42e9c73f`)
- `42e9c73f` L8 call-overload: type inference + IR dispatch in nova_compiler.nova source (blocked by gen3 truncation until reconverge)

**Recommended focus:** Block A (#1 RC leak shared root) + remaining LOCK decisions (LOCK-4 sized numerics is the strategic bottleneck). Most breadth work is DONE; the critical path is compiler/runtime foundation.
