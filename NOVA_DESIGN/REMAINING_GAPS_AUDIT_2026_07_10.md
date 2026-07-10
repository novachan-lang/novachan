# NOVA + Forge — Consolidated Remaining-Gaps Audit (2026-07-10)

> **What this is.** The single authoritative, code-verified list of what NOVA (the self-hosted
> compiler + C runtime + type system) and Forge (the framework on top) *still lack*, as of
> **2026-07-10**. It consolidates 9 independent domain audits (type-system, runtime/RC, performance,
> concurrency, platform, toolchain, Forge-core, Forge-lib, roadmap-crosscut), de-dupes overlapping
> claims, and drops every finding that turned out to be a stale doc claim. It is framed against the
> canonical tier model in [`CORE_GAPS_2026_07_03.md`](CORE_GAPS_2026_07_03.md).
>
> **Method.** Static verification only (grep + read at file:line depth) against
> `nova-compiler/test_programs/nova_compiler.nova` (~22k lines), `output/nova_runtime.c` (~20.9k lines),
> the `forge/*.nova` library (~560 files), CI, and design docs. No compile/run (a heavy build was in
> progress during the audit). **Every gap below is a VERIFIED real or partial gap with file:line
> evidence** — nothing here is a stale ledger claim (those are corrected in the appendix).

---

## 1. Executive summary — overall completeness

NOVA's **foundation is trustworthy and rare**: it self-hosts to a byte-identical fixpoint, the runtime
UB/UAF class (CORE_GAPS Tier 0, incl. **0.8 struct-field-leak CLOSED 2026-07-10**) is genuinely closed
and hard-asserted, the type checker is **sound by default** (Tier 1), and expressiveness (Tier 3 —
generics, traits with bounds/default-methods/dynamic-dispatch/conformance, exhaustive-match ADTs) is
**mostly already built** — the audit's original "unbuilt" tone on those was badly stale. Perf is
at/near C on the common cases (tight int loops, struct SROA default-on, built-in float reductions), and
the #1 float-array cliff (S4.2 escape-survival) is **shipped and default-on** (160×C → ~1.2-2.2×C).
Forge's HTTP/routing/middleware/OTP-supervision core is done and tested; it has 3 live DB drivers,
pure-NOVA TLS 1.3 + full crypto, a universal ORM, and ~570 KAT-gated algorithm/DS modules.

**What remains is real but bounded, and clusters in five places:** (1) a small set of **memory-SAFE RC
leaks** (closure captures, managed-field reassignment, push-of-fresh-temp, RC cycles) — none are UAF,
all are correctly tracked; (2) the **float-return-uninit codegen Heisenbug (0.11)** — the one remaining
silent-wrong-answer soundness bug; (3) **performance frontier** work gated OFF by default (native
by-value struct ABI, HOF monomorphization) plus the narrow S4.2 qualification window; (4) **platform
reach** — no ARM fibers (concurrency silently no-ops on ARM), WASM/GPU are proof-level not
productized, macOS never run against the real runtime; (5) **Forge productization** — HTTP/2+gRPC are
cleartext-only/unary-only (ALPN missing, Windows TLS-server stubbed), the type-driven `service` marquee
isn't built, distribution is a p2p protocol primitive not a mesh, and the S14-S19 productivity wave +
several DB-fidelity items (affected-row counts, binary/NUL-safety, typed decode) are unfinished.
Net honest position: **the core is production-trustworthy for Windows/Linux x86_64 single-node Forge
apps; the gaps are the frontier (ARM/browser/GPU/distribution/multi-core-throughput) and the last-mile
fidelity/leak items — not architecture flaws.**

---

## 2. Top gaps (prioritized, ~15 highest-impact REAL gaps across all domains)

Ordered by impact = severity × blast-radius, dependency-aware.

| # | Gap | Area | Severity | Effort | One-line status |
|---|-----|------|----------|--------|-----------------|
| 1 | Float-returning helper reads an UNINITIALIZED float slot → silent garbage (CORE_GAP 0.11) | Runtime/Perf/Type (S1 float ABI) | **High** | XL | REAL, open. Layout-dependent Heisenbug; `sqrt(variance)`→3e-156. The one remaining silent-wrong-answer bug. Same class as geo_bearing/atan2. |
| 2 | No ARM/aarch64 fiber context switch — green tasks/generators compiled OUT on ARM | Platform | **High** | L | REAL. `nova_asm_switch` is `#ifdef _WIN32 … #elif __x86_64__` with NO aarch64 branch and NO `#else`. `spawn`/generators silently no-op on ARM. |
| 3 | N>1 I/O throughput regresses (0.76-0.82× single-core); per-carrier I/O unbuilt | Concurrency | **High** | L | REAL. Single GLOBAL `nova_io_waiters` under `g_sched_lock`; `g_carrier_io` sharding confirmed absent. More cores = slower I/O. |
| 4 | HTTP/2 & gRPC over TLS impossible — ALPN missing from runtime | Forge-core | **High** | L | REAL. `grep -i alpn nova_runtime.c` = 0 matches. h2/gRPC exist ONLY as cleartext h2c. No browser HTTP/2, no h2-over-TLS. |
| 5 | Windows TLS *server* is a hard stub (no HTTPS on the dev's own OS) | Forge-core | **High** | L | REAL. `nova_rt_tls_listen`/`accept` return 0. TLS server exists only on Linux/macOS (OpenSSL). Dev is on Windows 10. |
| 6 | gRPC-from-types (`service`/`impl` block) NOT built — the "no .proto" marquee is absent | Forge-core | **High** | XL | REAL. `grep '"service"'` = 0, no `parse_service`. gRPC today = manual string-path `grpc_register`. Depends on interfaces + `chan T` returns. |
| 7 | `orm_exec` never returns real affected-row count for PG/MySQL | Forge-lib | **High** | M | REAL. PG/MySQL branches `return ok(0)`; no PG CommandComplete parse, no MySQL OK-packet affected_rows read. Only SQLite is correct. |
| 8 | base32/TOTP secrets (and PG DataRow, Redis RESP) NUL-truncate on a 0x00 byte | Forge-lib + Runtime | **High** | M | REAL. String-based binary paths truncate at first NUL → ~7.5% of random secrets give a wrong OTP; BYTEA/binary DB values corrupt. |
| 9 | LSP hover/completion is a regex text-scan, not the inferer | Toolchain | **High** | L | REAL. Shipped `lsp_infer_type_hint` returns literal "variable"/"number" by first RHS char; never calls `ti_infer_program_named`. Hover shows `x : variable`, not `x : int`. |
| 10 | Package manager: no transitive solver / semver / lockfile in the CLI path | Toolchain | **High** | L | REAL (partial). CLI fetches direct deps only, ignores versions, writes no `nova.lock`. A full resolver EXISTS but UNUSED in standalone `nova_pkg.nova`. Registry infra is external. |
| 11 | No preemption (cooperative-only); CPU-bound task starves its carrier; OTP restart can't kill | Concurrency | **High** | XL | REAL. `nova_rt_reschedule` yields only at park points. Blocks Reactor frame budget, true Erlang-parity supervision (zombies survive restart). |
| 12 | Closure captures leak on closure death (Stage 2 of the 0.8 fix) | Runtime/RC | Medium | M | REAL, memory-SAFE. `make_closure` stores captures raw (no rc_inc) + marks source ESCAPED; unhashed record → rc_free frees header only. |
| 13 | Trait conformance checks method name+arity only, NOT param/return TYPES | Type-system | Medium (soundness) | M | PARTIAL. `ti_check_trait_conformance` never compares signatures. A `Shape{area()->float}` is satisfied by `area()->string` → mistyped through dynamic dispatch. |
| 14 | User-enum variant match-arm payload degrades to `any` (float field reads raw IEEE bits) | Type-system | Medium (soundness) | M | REAL. `pat_ctor` binds payload to a fresh unconstrained var; `ir_match_ok_payload_stype` returns "" for non-Ok/Some. The Result/Option fix, still open for user enums. |
| 15 | RC cycles leak forever (no cycle collector, 4.7) | Runtime/RC + Concurrency | Medium | XL | REAL, memory-SAFE. No `gc_refs`/trial-deletion code; no live-object registry. `Node{nxt=self}` never reclaimed. Slow RAM leak, not a crash. |

Runner-up high-impact items that just miss the top 15: **String `==` ignores the shipped NFC/NFD
normalizers** (auth-bypass-adjacent, cross-cutting #2), **native by-value struct ABI gated OFF**
(perf #2), **remote_spawn is p2p-only, no mesh/auth/TLS** (concurrency 4.6 / Forge-core #5), and
**Linux FD_SETSIZE unguarded at fd≥1024** (concurrency 4.2, CVE-class on high-concurrency Linux).

---

## 3. Gaps by area

Within each area, ordered by severity. **PARTIAL** is marked explicitly; everything else is a REAL
(fully-open) gap. Cross-domain duplicates are merged and noted.

### 3.1 NOVA — Type system

| Gap | Verdict | Sev | Effort | Evidence (code-verified) | Next step |
|-----|---------|-----|--------|--------------------------|-----------|
| Trait conformance ignores method param/return TYPES (name+arity only) | PARTIAL | high (soundness) | M | `ti_check_trait_conformance` (nova_compiler.nova:13680-13734) checks only name (`list_contains`) + arity (`_tr_ar[rm] != _ty_ar[rm]`). No `ti_trait_method_param_types`/`ret_types` exist anywhere. `Shape{area()->float}` accepts an impl `area()->string`. | Record per-method param+return types at trait decl + impl; unify impl sig against trait sig in conformance; emit E1006-family on mismatch + negative test. |
| User-enum variant match-arm payload → fresh var → degrades to `any` (float field reads raw bits) | REAL | high (soundness) | M | ti_ side: `ti_infer_pattern` `pat_ctor` else-branch (:13139-13143) binds each payload child via `ti_define(... ti_fresh)` — NOT the recorded `nt_fn(vfield_types,...)` (:12837). IR side: `ir_match_ok_payload_stype` (:7479-7486) returns "" for any ctor ≠ Ok/Some. Same class closed for Result/Option, still open for user enums. `to_json` masks it; arithmetic/`str()` returns garbage. | ti_: in `pat_ctor` else-branch look up the variant's recorded field types and unify each binder. IR: extend the payload-stype resolver to recover user-enum struct-typed payloads. Guard with a float-payload enum test. |
| `from_json_safe<T>` validates object-ness only, not field types | PARTIAL | medium | M | `_make_from_json_safe_method` (:3511-3520) guards non-dict → err, else delegates to the silent `<T>__from_json`. Own comment (:3508) admits `{bad`→ok(defaults). `{"age":"x"}` for `User(age:int)` → `ok(User(age=0))` with no error. (`form_as<T>` DOES per-field-validate; gap is JSON-path-specific.) | Generate a validating `<T>__from_json_safe` mirroring `<T>__from_dict`'s per-field parse-and-error (parse_int_safe/parse_float_safe; missing key → err) instead of delegating. |
| Float-return uninit codegen Heisenbug (0.11) | REAL | high | XL | *(shared — see Runtime/RC #4 and Performance #4; owned there. Type-system view: it lives in the S1 float return-slot ABI.)* | See Runtime/RC #4. |
| Trait-bound check skips `any`/`var` (unresolved generic) | PARTIAL | low | S | `ti_check_bounds` (:13668-13669) `if rk=="any" or rk=="var": continue`. HM-standard (can't check an unresolved var); low risk. | Acceptable as-is. Optionally re-drive bound checks after `ti_solve` so late-resolved vars are validated. |
| Exhaustiveness silently skipped for depth>50 types + mixed/guarded patterns | PARTIAL | low | S | `ti_unify` strict path (:11015-11016) returns silently at depth>50 (documented incompleteness). `ti_check_exhaustive` fires only for pure enum/Result/Option ctors; a match mixing `pat_lit`/`pat_str`/`pat_range` sets `ex_is_enum=false` (:13182) and does no check; guards not modeled. | Low priority. Document the depth-50 bound; non-enum exhaustiveness is intentionally unchecked. |
| No Zig-style comptime / compile-time execution (3.4) | REAL | low | L | grep `comptime` → only const-fn-eval (:17934, :21863) + `ti_const_eval`/`static_assert`. No general engine. Ledger marks 3.4 explicitly OPTIONAL. | Optional; defer. If pursued, a bounded AST interpreter gated by `ce_budget_ok`. Not on the critical path. |

### 3.2 NOVA — Runtime & reference counting

The Tier-0 UB/UAF class is genuinely closed and hard-asserted (see appendix). What remains is a tight
cluster of memory-SAFE leaks + the one float codegen wrong-answer bug + the known scalar limits.

| Gap | Verdict | Sev | Effort | Evidence (code-verified) | Next step |
|-----|---------|-----|--------|--------------------------|-----------|
| **Float-return reads an UNINITIALIZED float slot → garbage (CORE_GAP 0.11)** | REAL | high | XL | `_floatret_uninit_test.nova` preserves the repro CI-safely (always exit 0): `stddev(xs)=sqrt(variance(xs))`→~3.08e-156 not sqrt(2), cascading Pearson r→inf. Two tells it is an uninitialized READ: `variance(xs)` prints 2.0 the line before; a `print` inside the helper fixes it (layout shift). The documented let-binding workaround does NOT fix this instance. Same class as geo_bearing/atan2 (`reference_nova_float_codegen_geo_bearing`). **Cross-domain: also owned by Performance #4 and Type-system.** | Dedicated codegen session: LLVM-IR diff working-vs-garbage layouts; zero-init or correctly wire the float return slot (S1 float ABI). Needs a reliable minimal repro (extraction masks it). |
| Closure captures leak on closure death (Stage 2 of 0.8) | REAL | medium | M | `make_closure` (nova_compiler.nova:17005-17028) allocates via `nova_rt_struct_alloc` (NOT hashed), stores each capture with a bare `store i64` (**no `nova_rt_inc`**, :17020), and marks each source slot ESCAPED (:17025) so W5b never drops it. Unhashed → `nova_rc_free` pre-switch struct block (nova_runtime.c:9867) frees header only. `_closure_capture_leak_test.nova` (sibling=2001, frame=4000). Memory-SAFE. | Route make_closure through hashed-alloc + a capture managed-slot bitmap (or trampoline→bitmap map) so rc_free dec's boxed captures; then relax the escape-mark. |
| push(container, freshHeapValue) leaks the element's creation ref | REAL | medium | M | `nova_rt_list_append` (nova_runtime.c:1442-1459) + `nova_rt_dict_set` (:2529) ALWAYS `nova_rc_inc(elem)` on insert (:1457). A fresh element at rc=1 pushed → rc=2, creation ref never dropped (no MOVE-on-insert). `push(list,[k,k])` in a loop leaks the inner list (pre-existing; gen3 too). `_no_rc` fast paths were DISABLED as part of the 0.10 fix (:1509-1526, :2576). | MOVE-on-insert: borrow-provenance bit → skip the insert-inc when the arg is a proven fresh temp (same analysis Stage 1/2 of RC completeness needs). |
| Managed struct-field REASSIGNMENT leaks the old value | REAL | low | M | `nova_rt_field_set` (nova_runtime.c:15888-15912) is inc-NEW only — deliberately does NOT dec-old (comment :15896-15905): NOVA field reads are borrow-based, so `saved=obj.f; obj.f=new; obj.f=saved` holds a live borrow; dec-old freed it under the borrow (a self-compile UAF the reconverge caught). Pinned by `_struct_field_reassign_test.nova` (UAF-safe + delta ~2000, not 0). | field_get-inc / borrow tracking (owning field reads with dec-on-drop) so dec-old becomes sound. Shares the root with push #3. |
| RC cycles leak forever (4.7) | REAL | medium | XL (supervised) | *(shared — see Concurrency 4.7; owned there.)* No `gc_refs`/cycle-collector code exists in `nova_runtime.c`; `_cycle_leak.nova` = 1000× `Node{nxt=self}` → struct count 1000 / 32000 bytes still-live at exit. No live-object registry to drive trial-deletion. Slow RAM leak, not a crash. | See Concurrency 4.7 (opt-in CPython-style trial-deletion collector). |
| Mixed int/float comparison promotion incomplete | PARTIAL | low | M | Compare codegen DOES emit `sitofp` promotion, but only when the register-type pass tags an operand "L"/"R" (nova_compiler.nova:16311-16316). Where the pass fails to mark float-var-vs-int-literal, no promotion. `max`/`min` explicitly lack it (comment :15051; `nova_rt_fmax/fmin` selected only when BOTH operands are static float, :15053). `reference_nova_float_int_compare_unsound`: float VAR vs INT value can read as always-true (found in forge_aabb). Workaround: `intExpr*1.0`. | Make the register-type pass insert an unconditional promotion whenever exactly one operand is float across ALL numeric ops (compare + max/min/abs). |
| Scalar `1<<64` / shift ≥ 64 is UB | REAL | low | S | Shift codegen (nova_compiler.nova:16463) emits bare `shl i64` with no guard for amount ≥ 64. LLVM `shl` by ≥ bitwidth is poison/UB. `reference_nova_shift64_broken`: `1<<64`→0xFFFFFFFF, not 0. | Clamp/guard in codegen (`amt>=64 ? 0 : shl`) or a runtime `nova_rt_shl`. |
| String NUL-truncation for binary data | REAL | low | M | Runtime string ops use C-string `strlen` (nova_runtime.c:140,148 + `nova_str_slice` paths), so an embedded `chr(0)` truncates at the first NUL. `"A"+chr(0)+"B"` has len 2. `reference_nova_string_nul_truncation`; latent in forge_totp/base32/redis (**see Forge-lib #2/#3/#9**). | By-design for fat-strings (strlen-based C interop is pervasive). Document; steer binary to `bytes`. |

### 3.3 NOVA — Performance

Perf is at/near C on the common cases and the #1 float-array cliff is closed default-on. The residuals
are bounded feature-frontier work, mostly gated OFF by default.

| Gap | Verdict | Sev | Effort | Evidence (code-verified) | Next step |
|-----|---------|-----|--------|--------------------------|-----------|
| S4.2 escape-versioner has a narrow qualification window — code outside it hits the boxed ~160×C path | PARTIAL | high | L | `s4_versioning` (nova_compiler.nova:10361) qualifies only when `xs` is not mutated in the loop (`s4_s_mutates==0`), not passed to a fn INSIDE the loop (`s4_s_escapes==0`, :10382), and DID escape before the loop (:10385). So `for x in xs: acc = acc + process(xs, x)` (array re-passed inside the read loop — very common) does NOT qualify → boxed `nova_rt_index_get`. Even when it fires, per-element `list_get_f` doesn't vectorize → ~1.2-2.2×C (S4_TYPED_ARRAYS_DESIGN.md:342), not full parity. | Broaden qualification to N accumulators + loops passing `xs` to a provably-non-mutating callee (`ir_escape_summaries` exists); and/or a sound `floatlist ⟹ kind==2` invariant so a typed read is an unguarded raw `load double` (removes the per-read call + enables vectorization). |
| Cross-function struct math capped ~1.0-1.2×C — native by-value struct ABI gated OFF | PARTIAL | medium | L | Uniform i64 ABI → a struct across a fn boundary is a heap `i64*` (no register-split/SROA across the call). The fix (`NOVA_S5_ABI`, `@f(double,double)`) is designed (SROA_NATIVE_ABI_S15_DESIGN.md) + partly implemented (`ire_s5_byval`/`ire_s5_struct_ptr` :15971, call-site scalarization :16691-16731) but **default-OFF**: nova_compiler.nova:19121-19122 `do_s5abi = env("NOVA_S5_ABI")=="1"`. OFF → byte-identical i64. Non-escaping single-fn struct math IS at parity (SROA default-on). | Finish the design's 5-edit sound version (use-set eligibility + global address-taken guard — the naive 4-edit version is unsound); reconverge + both-mode regression; flip default-on. |
| HOF/closure arithmetic stays fully dynamic — monomorphization gated OFF | PARTIAL | medium | XL | `map`/`filter`/`reduce`/`pmap` callback bodies use runtime dispatch (~50-100ns/op). The S5 HOF-monomorph path exists (nova_compiler.nova:15749-15791, harvest table `_s5_tramp_map` :19046) but **default-OFF**: :19047-19048 `NOVA_S5_HOF=="1"`. So `map(nums, fn(x) x*x)` still lowers to `nova_rt_mul`. ~2× on trivial bodies; vanishes for heavy bodies. The `ti_fn_param_types→fpt` shortcut was reverted as unsound (corrupted float callers). | Validate the gated path against float-caller soundness (the class that broke the shortcut), extend to non-inline closures via whole-program use-set, flip default-on. Low priority vs the two above. |
| Float-return uninit Heisenbug (0.11) | REAL | high | XL | *(shared — owned in Runtime/RC #4; a perf-domain-adjacent S1 float-ABI bug.)* | See Runtime/RC. |

### 3.4 NOVA — Concurrency

The N=1 green-task runtime is solid and is the production default; N>1 is **correctness-gated** (CI green
at N=4/8, N=1 byte-identical). The open Tier-4 gaps are throughput, preemption, cycles, distribution.

| Gap | Verdict | Sev | Effort | Evidence (code-verified) | Next step |
|-----|---------|-----|--------|--------------------------|-----------|
| N>1 I/O throughput regresses (0.76-0.82× single-core); per-carrier I/O unbuilt (4.1) | REAL | high | L | `nova_sched_park_io_ex` (nova_runtime.c:6321) links every waiter onto the single GLOBAL `nova_io_waiters` under `nova_sched_lock()` (:6331,:6347); `nova_sched_poll_io` (:6440) drains it under the same lock. grep `g_carrier_io`/`nova_carrier_io` = **0 matches** → sharding absent (PER_CARRIER_IO_DESIGN.md = DESIGN ONLY). Single-poller mode is still a single-thread funnel on `g_sched_lock`. | Implement PC-1 (shard `nova_io_waiters` into `g_carrier_io[NCAR]`, per-carrier poll incl. timed-io) + PC-2 (pin handler to accepting carrier), with RC-1/RC-2 prereqs; gated session; re-measure keep-alive /ping at N=1/4/8. |
| No preemption (cooperative-only); CPU-bound task starves its carrier; OTP restart can't kill (4.4) | REAL | high | XL | `nova_runtime.c:6275` "signal-based preemption is post-v1"; `nova_rt_reschedule` (:6276) yields only if `in_task` — a tight loop hitting no park point never yields (by design, for the C-speed promise). `forge_otp.nova:113`: "NOVA has no preemptive kill — 'restart' = spawn a fresh instance; a healthy sibling is NOT stopped." Blocks Reactor frame budget + Erlang-parity supervision (zombies). | Design signal (SIGURG/timer) or safepoint preemption + a runtime linked-exit/kill primitive; XL, supervised (safepoint insertion interacts with the value model + fiber stacks). Interim: document `reschedule()` discipline. |
| remote_spawn is client-side RPC-by-name only; full distribution + auth/TLS unbuilt (4.6) | PARTIAL | high | L-XL | `nova_rt_remote_spawn` (nova_runtime.c:11649) is NOT a null stub — sends `[name,args]` via `remote_send`, returns the channel; caller hand-writes the peer dispatch loop. But DISTRIBUTION_DESIGN.md model is unbuilt (grep `node_connect|node_registry|remote_pid|router|heartbeat` → only an unrelated `node_id`); `forge_dist.nova` = protocol layer only ("LIVE 2-node link deferred"). **Security:** `remote_send`/`recv` (:11608/:11623) are length-prefixed JSON over raw TCP, **unauthenticated + non-TLS**; + `call_by_name` (:16034) = unauthenticated remote-code-by-registered-name; `remote_recv` mallocs attacker-controlled `len+1` (64MB cap, repeatable). **Merged with Forge-core #5.** | Build fn-id registry + node link manager + router (pid demux) + cross-node DOWN + heartbeats; ADD a link auth handshake + optional TLS before any "production distributed" claim; gate on the 2-process kill-and-DOWN test. |
| RC cycles leak forever (4.7) | REAL | medium | XL (supervised) | grep `gc_refs|cycle_collect|trial.delet|tp_clear|collect_cycles|mark.*sweep` = **0 matches**. RC only; `_cycle_leak.nova` (1000× `Node{nxt=self}`) → 32000 bytes still-live at exit. No live-object registry (heap profiler tracks COUNTS only). **Merged with Runtime/RC #5.** | Opt-in CPython-style trial-deletion collector (per-object gc_refs, subtract internal refs via the existing per-type child enumeration in `nova_rc_free`, free the unreachable set); gated + adversarial-validated before any reconverge. |
| Linux FD_SETSIZE / fd≥1024 `select()` corruption (Windows raised to 4096; Linux unguarded) (4.2) | PARTIAL | medium | M | `nova_runtime.c:27` `#define FD_SETSIZE 4096` is inside `#ifdef _WIN32` (:22) — works on Windows (array-shaped fd_set). On Linux/glibc `fd_set` is a fixed 1024-bit bitmap; `#define` does NOT resize it; `nova_sched_poll_io` (:6493) `select(maxfd+1,...)` + `FD_SET(w->fd,&rfds)` (:6474) with no `fd < FD_SETSIZE` check → ≥1024 connections write past the bitmap = stack corruption (CVE-class). Windows N=1 default not hit today; high-concurrency Linux unsafe. | Move the Linux netpoller to `poll`/`epoll` (no FD_SETSIZE limit), OR add a hard `if (fd >= FD_SETSIZE) reject/fallback` on every POSIX `FD_SET`. Folds into Tier 5 Linux reach + macOS kqueue. |
| Cross-carrier wake spins on `park_committed` while holding `ch->lock` (latent; benign under pinning) (4.3) | PARTIAL | medium | M | `nova_sched_wake_one` (:6281) + `nova_sched_wake_send_one` (:6301) do `while(!t->park_committed){ spin }` at N>1 (:6296,:6309), called from `nova_rt_channel_send` while `ch->lock` is held (:4862,:4897,:4911). Under current no-migration pinning it's a guaranteed near-instant no-op (home carrier set the flag first), so no deadlock today — but a busy-spin under a channel lock and a live hazard if work-stealing/migration is re-introduced. | Track as latent hazard tied to the work-stealing plan; if migration/stealing is ever re-enabled, land the deferred-wake fix (pop-under-lock, spin+enqueue after `ch->lock` release) FIRST. No action while pinned + steal-free. |
| N>1 fiber load-imbalance (no work-stealing) — bounded residual | PARTIAL | low | L | Task-slot reclaim is ON by default at N>1 (nova_runtime.c:7511), bounding the slot pool. But NO work-stealing (per-carrier deque Stage A exists; Stage B/C push-to-local + steal reverted for lost-wakeup at N=4) → a task pinned to a busy carrier can't migrate to an idle one; skewed load leaves cores idle. | Only if N>1 becomes a production target: complete MN_PER_CARRIER_DEQUE Stages B-D on top of pinning, each gated on green_scale N=4/8 + ASAN + clean watchdog exit. N=1 is production today. |

### 3.5 NOVA — Platform reach ("runs anywhere")

Verified reach = **Windows x86_64 (first-class) + Linux x86_64 (real: cross-compile pipeline + 40/40
sweep + 10k-task scheduler)**. The Tier-5 ledger is ACCURATE here (not over-pessimistic like Tiers 0/1/3).

| Gap | Verdict | Sev | Effort | Evidence (code-verified) | Next step |
|-----|---------|-----|--------|--------------------------|-----------|
| No ARM/aarch64 fiber context switch — green tasks/generators compiled OUT on ARM (5.1) | REAL | high | L | Fiber block: `nova_runtime.c:5517` `#ifdef _WIN32` (CreateFiber), `:5707` `#elif defined(__x86_64__)` (POSIX naked-asm `nova_asm_switch`). **NO `#elif __aarch64__` and NO `#else` before `#endif`** → on aarch64 `nova_asm_switch`, `nova_rt_fiber_create/resume/yield`, trampoline are ABSENT. `nova_rt_arch_name` (:15821) reports "arm64" but nothing implements the switch. `spawn`/generators silently no-op on ARM. | Add an aarch64 `nova_asm_switch` (save x19-x30 + sp + fp, swap sp) mirroring x86_64 + an aarch64 fiber-create stack layout. Needs an ARM host (Apple Silicon / Linux aarch64). |
| `nova build --target wasm` does NOT link the C value-model runtime (5.3) | PARTIAL | high | XL | nova_compiler.nova:22441-22444 wasm link line: `clang --target=wasm32 … -nostdlib -Wl,--no-entry --export=nova_user_main --allow-undefined <prog.wasm.ll>` — links NO runtime object, `--allow-undefined`, ships JS loader `_wasm_runtime.cjs`. The full C value-model wasm runtime (`nova_runtime_wasm.c`) is compiled+linked ONLY by the standalone `_wasm_vm_one.sh`, never by the built-in command → strings/lists/dicts stub to `()=>0n` unless run through the ad-hoc script. | Wire `nova build --target wasm` to compile+link `nova_runtime_wasm.o` (as `_wasm_vm_one.sh` does) → self-contained wasm. Then a real DOM/reactive stdlib + headless-browser CI. |
| GPU is one hardcoded OpenCL `vadd` + 4 CPU-loop named kernels — no kernel-lowering path (5.4) | REAL | medium | XL | `nova_runtime.c:20622` `g_gpu_vadd_src` = one hardcoded `__kernel void vadd`; :20694 the only `clCreateKernel`. `nova_rt_gpu_kernel_run` (:20227) dispatches by string name to CPU `for` loops (scale2/square/add1/negate, :20237-20240) — "Real device dispatch is future." Compiler only types `gpu_kernel_run` as opaque (nova_compiler.nova:5951,:11864); no `@gpu`, no SPIR-V/PTX. | Design NOVA→GPU kernel lowering (annotate fn as kernel → emit SPIR-V/PTX via LLVM nvptx/spir; generate clCreateProgramWithSource/Kernel glue). Needs GPU hardware. |
| macOS never run against the self-hosted runtime; cross-platform CI stale (builds dead Kotlin compiler) (5.2/5.6) | PARTIAL | medium | M | `.github/workflows/cross-platform.yml` linux-test (:44) + macos-test (:175) run `./gradlew fatJar` + `java -jar …all.jar` = the historical Kotlin bootstrap CLAUDE.md says is NOT the live compiler. So Linux/macOS CI exercises the dead interpreter, never `nova_compiler.nova` or its runtime's platform paths. `macos-latest` is Apple-Silicon (ARM) — and P1 means real fibers are absent on ARM anyway. No epoll→kqueue: poller (nova_runtime.c:19606) is Linux-`epoll` only. | Rewrite Linux/macOS CI to build+run the self-hosted compiler (ship a prebuilt bootstrap or clang-build), run the real regression; add a macOS `kqueue` poller branch. |
| Embedded / no_std / true freestanding = only the wasm value-model carve (5.5-leaf) | REAL | low | XL | The only freestanding path is `NOVA_FREESTANDING` in `nova_runtime_wasm.c` (bump allocator, no libc), targeting wasm32 in a JS host — not a real MCU (no interrupt model, MMIO, static-memory budget, `thumbv7`/`riscv32` in `resolve_target`; nova_compiler.nova:15904 emits only x86_64/wasm32/aarch64 triples). ~285 other `malloc`s + sockets/threads/printf are unconditionally linked. **Merged with Cross-cutting #5.** | Post-MVP: reuse `NOVA_FREESTANDING` as the seed for a `thumbv7m`/`riscv32` bare-metal target (static arena, no scheduler, MMIO via ptr_read/write); capability-gate non-freestanding builtins at type-check under `--freestanding`. Needs hardware/QEMU. |

### 3.6 NOVA — Toolchain & developer experience

The build side (`nova build` incremental + cross-compile + LTO, `nova fmt` AST-reprint, check/lint/cov/
bench/eval/wasm) is genuinely strong. The interactive/DevX side is weaker than memory claims.

| Gap | Verdict | Sev | Effort | Evidence (code-verified) | Next step |
|-----|---------|-----|--------|--------------------------|-----------|
| Shipped LSP hover/completion is a regex text-scan, not the inferer | REAL | high | L | `lsp_infer_type_hint` (nova_compiler.nova:21537) does a lexical line scan returning literal "number"/"variable"/"list"/"dict"/"bool" by first RHS char — never calls `ti_infer_program_named`. `lsp_get_completions` (:21647) scans `fn `/`type ` prefixes, no types, not context-aware. The extension launches THIS (`extension.ts:22 args:['lsp']`); the Kotlin `LspAnalyzer.kt` (which memory's v0.2.0 upgrades targeted) is dead code. Hover a local → `x : variable`, not `x : int`. | Route hover/completion through the same `ti_infer_program_named` result the diagnostics path already builds; look up inferred type at cursor from the node-type map. |
| Package manager: no transitive solver / semver / lockfile in the CLI path | REAL | high | L | CLI install/get → `nova_pkg_install`/`nova_pkg_get` (nova_compiler.nova:21357/:21376). `nova_pkg_install` iterates ONLY `nova.toml` direct deps; a package's own `[dependencies]` are never recursed; `nova_pkg_download` (:21319) takes `pkg_version` but NEVER uses it; no `nova.lock` written; registry targets an unpopulated repo. A FULL transitive+semver+lockfile+integrity resolver EXISTS but UNUSED in standalone `nova_pkg.nova` (`resolve` ~:261, `write_lockfile` :360, `semver_satisfies` :78). **= CORE_GAPS 6.1.** | Wire CLI install/get to `nova_pkg.nova`'s resolver (transitive recursion + visited-set + semver intersection + `nova.lock`). The registry itself is external infra → supervised. |
| LSP missing signatureHelp / inlayHint / references / rename / semanticTokens | REAL | medium | L | `initialize` reply (nova_compiler.nova:21691) advertises ONLY hover/definition/completion/diagnostic/textDocumentSync. grep `signatureHelp|inlayHint|references|rename|semanticTokens` → NO LSP handlers in the shipped server. Memory marks signature-help + inlay-hints "DONE" — true only of the DEAD Kotlin server. | Add the providers to initialize caps + the `textDocument/*` branches in `lsp_server_main`, backed by the inferer + an AST ident-walk for refs/rename. |
| `nova repl` is dev-tree-only and recompiles the whole session per line | PARTIAL | high | M | `repl.nova:146` hard-codes `exec(".\\gen3_test.exe repl_session.nova")` + :154 clang-links against `output\nova_runtime.c` → only works from `test_programs/` with `gen3_test.exe` present. Every line rewrites the full session + relinks via clang (O(session)/line); no readline/history. A tree-walking `eval_expr` interpreter EXISTS (:21788, backs `nova eval`) but the REPL doesn't use it. | Resolve the compiler via `arguments[0]`/`NOVA_HOME` (not `.\gen3_test.exe`); back interactive eval with `eval_expr` (instant, no per-line clang), full-compile fallback only when the interpreter can't handle it. |
| `nova debug` (CLI) has no interactive stepping despite its banner | PARTIAL | medium | M | nova_compiler.nova:22329-22354: compiles `NOVA_DBG=1` at -O0 + DWARF, prints "NOVA interactive debugger" with s/n/o/c/bt/p/bp/q, then the final stmt is `exit(system(<exe>))` — runs to completion. NO command REPL, no ptrace/lldb driver, no breakpoint loop. Real debugging exists ONLY in VS Code via DAP handoff to external `lldb-dap` (extension.ts:65-95; DWARF vars `ire_dwarf_local` :15996). | Drive `lldb`/`lldb-dap` from the CLI to honor the banner, OR replace the banner with an accurate "compiled with debug info; open in VS Code or run under lldb". |
| Onboarding: no real quickstart / ONBOARDING.md; GETTING_STARTED has a stale build line | PARTIAL | low | S | `GETTING_STARTED.md:9-13` shows `nova --version` with no acquisition/build steps; the compile example (`nova hello.nova` then manual `clang -O2 … nova_runtime.c`) predates `nova build`/`nova run`. CORE_GAPS 6.5 flags the broader onboarding polish as still not done. | Rewrite the quickstart around `nova build`/`nova run`; add ONBOARDING.md covering install + first full-stack app; drop the manual-clang path from the beginner flow. |

### 3.7 Forge — Framework core

HTTP/routing/middleware/OTP-supervision core is done and tested. The REAL gaps cluster in HTTP/2+gRPC
transport, the type-driven `service` marquee, distribution, and the untested S14-S19 productivity wave.

| Gap | Verdict | Sev | Effort | Evidence (code-verified) | Next step |
|-----|---------|-----|--------|--------------------------|-----------|
| HTTP/2 & gRPC over TLS impossible — ALPN missing from runtime | REAL | high | L | `grep -i alpn nova_runtime.c` → **0 matches**. HTTP2_PLAN.md D2.1 (the one runtime dep) unbuilt. h2/gRPC exist ONLY as cleartext h2c (`serve_h2c`, `serve_grpc_h2c`). | Add ALPN offer/select to the TLS accept path (OpenSSL `SSL_CTX_set_alpn_select_cb`; SChannel equivalent); expose `nova_rt_tls_alpn_selected`; gate under full nova_ci. |
| Windows TLS server is a hard stub (no HTTPS on the dev's own OS) | REAL | high | L | `nova_runtime.c:18848-18853`: `nova_rt_tls_listen` returns 0 ("TLS server not implemented — needs cert provisioning"), `nova_rt_tls_accept` = `{ return 0; }`. Real TLS server exists only on Linux/macOS via OpenSSL (:19087+). Dev is on Windows 10. | Implement SChannel server-side handshake (`AcceptSecurityContext` loop) mirroring the OpenSSL path + cert loading. |
| gRPC is unary-only — no server/client/bidi streaming | PARTIAL | high | L | `forge_grpc.nova:197` "Streaming RPCs are future work; this layer is unary-only." `grpc_dispatch` = one framed msg → one reply. No stream shapes anywhere. | Build stream dispatch over the h2 DATA-frame loop (`_grpc_h2c_conn`); map channel directionality to the 3 stream shapes; needs per-stream flow-control. |
| gRPC-from-types (`service`/`impl` block) NOT built — the "no .proto" beat is absent | REAL | high | XL | `grep '"service"' nova_compiler.nova` → **0 matches**; no `parse_service`. FORGE_STATUS §7 marquee (`service Orders {...}`) requires interfaces #8 + `chan T` returns. gRPC today = manual `grpc_register(m,"/pkg.Svc/Method",h)`. | Design `service`/`impl` top-level syntax on the existing trait/impl parser (`parse_trait_decl` :2791); lower to a codegen'd service map + protobuf codec from struct RTTI. |
| remote_spawn = p2p protocol only; no production distribution | PARTIAL | high | XL | *(merged with Concurrency 4.6.)* `forge_dist.nova` = registry + JSON encode/decode only ("LIVE 2-node link deferred"). Runtime `nova_rt_remote_spawn` (:11649) is real but needs a pre-existing `conn` channel. No mesh/gossip/global-registry/remote-monitor; unauthenticated + non-TLS. | See Concurrency 4.6: live node link + cross-node DOWN + mesh membership + global registry + auth/TLS. |
| Plain HTTP/2 server serves ONE stream per connection (no real multiplex) | PARTIAL | medium | M | `forge_h2_server.nova:187` `_h2c_serve_conn`: `if served >= 1: alive = false` — closes after the first HEADERS/DATA exchange ("multi-stream is a follow-up"). | Replace the single-stream loop with a per-stream state map keyed by stream_id; interleave concurrent streams on the netpoller. |
| S14-S19 productivity wave (config/DI, declarative tx/cache/retry/schedule, template, event bus, i18n, test harness, method-security) — code exists, ZERO functionally tested | PARTIAL | medium | L | Modules present (`forge_config`/`forge_aspects`/`forge_repo`/`forge_template`/`forge_forms`/`forge_events`/`forge_i18n`/`forge_test`) but `grep _run_final_regression.ps1` for any of their `_test` names → **0 matches** (only grpc/h2c tests). "gen3 syntax-checked, functional tests deferred." | Write functional `*_test.nova` for each; register in `_run_final_regression.ps1`; run both RC modes; flip DEV_TRACK rows to tested. |
| Spring/Django "batteries" depth (declarative `@Transactional` propagation, method-level security, derived queries, entity auditing, soft-deletes, test factories/DB-rollback) | PARTIAL | medium | XL | FORGE_FEATURE_AUDIT §B/D/E/F/G/H/K mark these 🟡/❌; `with tx{}` blocked (`with` taken by another construct). Template engine now a 61-line unproven module. | Sequence per FEATURE_AUDIT: P0 config+profiles+DI + declarative tx w/ propagation + method cache; P1 template + event bus + i18n + test harness. Each needs a functional test to count as shipped. |
| GraphQL/gRPC-over-WebSocket subscriptions = codec only, not wired to a live subscribe→push loop | PARTIAL | low | M | `forge_graphql_ws.nova:20` "This module is the CODEC only." Needs pairing with ws server + `gql_execute_limited_vars` + hub — not a shipped/tested end-to-end path. | Wire the graphql-ws codec to `ws_room` + a hub topic; on publish, run resolver and push `next`; add an end-to-end test. |
| Trait/interface dispatch uses djb2 name-hash — latent hash-collision mis-dispatch | PARTIAL | low | M | `type_name_hash` (nova_compiler.nova:7374) = djb2; match ctor arms compare `type_name_hash(pv)` vs `field_get __type_hash` (:9387,:9669). Two distinct struct names colliding → wrong arm. Traits/impl parse + dispatch DO exist; collision-handling soundness unverified. **Related to Type-system trait-conformance gap.** | Verify/repro collision behavior; if real, switch to a monotonic per-type interned id, or add a secondary name compare on hash match. |

### 3.8 Forge — Libraries (DB / crypto / serialization / HTTP)

Broad and battle-tested (3 live DB drivers, pure-NOVA TLS 1.3 + crypto, universal ORM). Most memory
"gap" claims are STALE (see appendix). REAL gaps cluster in DB write-result fidelity, binary/NUL-safety,
and typed-decode/full-auth completeness.

| Gap | Verdict | Sev | Effort | Evidence (code-verified) | Next step |
|-----|---------|-----|--------|--------------------------|-----------|
| `orm_exec` never returns real affected-row count for PG/MySQL | REAL | high | M | `forge/forge_orm.nova:264` PG branch `return ok(0)`; :270/:274 MySQL `return ok(0)`. Only SQLite (:258) returns `db_affected(c)`. PG never parses CommandComplete ('C', no `_pg_parse_complete`); MySQL never reads the OK-packet `affected_rows` lenenc. | Parse PG CommandComplete tag suffix ("UPDATE 3"→3, "INSERT 0 5"→5) in `pg_query_params`; read MySQL OK-packet affected_rows; thread up through `orm_exec`. |
| base32 / TOTP secrets NUL-truncate on a 0x00 byte | REAL | high | M | `forge/forge_base32.nova:38-62` `base32_decode` builds `out = out + chr(...)` (string); no bytes variant. `forge/forge_totp.nova:11` `_totp_key` calls `base32_decode` then `char_at`; :76-83 `totp_secret` builds `s = s + chr(bytes_get(b,i))`. Per `reference_nova_string_nul_truncation` a `chr(0)` truncates → wrong HMAC key. ~7.5% of random 20-byte secrets contain a 0x00 → wrong OTP. **Same class as Runtime NUL-truncation.** | Add `base32_decode_bytes`/`base32_encode_bytes` over a byte list; make `_totp_key`/`totp_secret` byte-based end-to-end (never round-trip a binary secret through a NOVA string). |
| PG DataRow NUL-truncates binary values + can't distinguish NULL from "" | PARTIAL | high | M | `forge/forge_pg.nova:84-103` `pg_parse_data_row` builds `s = s + chr(bytes_get(b, p+j))` → BYTEA/text-with-0x00 truncates. :82 comment: `"" for SQL NULL` — SQL NULL and empty-string both return `""`, indistinguishable. | Return column values as byte lists (or a bytes-carrying dict) to preserve binary; carry a distinct NULL sentinel (not `""`). |
| MySQL 8.x caching_sha2 cold-cache full auth (0x04) unimplemented — blocked on missing RSA-OAEP | REAL | medium | L | `forge/forge_mysql.nova:248` returns `err("caching_sha2 full authentication required — needs TLS or RSA")`; only the 0x03 fast-path works. `forge/forge_rsa.nova` has only verify (`rsa_pkcs1_sha256_verify` :68, `rsa_pss_sha256_verify` :144) — NO OAEP/encrypt. Cold-cache 8.x connect requires priming or a native_password account. | Implement RSA-OAEP encrypt in forge_rsa (encrypt the scrambled password to the server pubkey), OR route full-auth over the existing `nova_rt_tls_upgrade` TLS transport. |
| No statement/connection timeout in any DB driver (primitive exists, unused) | PARTIAL | medium | M | `nova_runtime.c:11475 nova_rt_tcp_wait_readable(fd, timeout_ms)` exists, but grep `timeout|deadline|reconnect|health` in forge_pg.nova/forge_mysql.nova → **0 matches**. Both loop on blocking `tcp_recv_bytes` with no deadline → a stalled server hangs the green task indefinitely; no health-check/reconnect. | Add a per-call timeout that calls `tcp_wait_readable(fd, ms)` before each `tcp_recv_bytes`; `err("timeout")` on expiry; pool health-check/reconnect on a dead conn. |
| MySQL FLOAT/DOUBLE/DATE binary decode returns "" (undecoded) | REAL | medium | S | `forge/forge_mysql.nova:334-346` `_my_bin_val`: `t==4` (FLOAT)→`["", off+4]`, `t==5` (DOUBLE)→`["", off+8]`; DATE/TIME fall through to lenenc-string (wrong). Only reached via prepared/parameterized (binary protocol). | Decode IEEE-754 LE 4/8-byte floats to a decimal string; decode the MySQL binary DATE/DATETIME/TIME layout to ISO. |
| Raw PG driver cannot bind a NULL param (ORM works around via literal-NULL text rewrite) | PARTIAL | medium | S | `forge/forge_pg.nova:429-441` `_pg_bind_msg` always emits `pg_be32(bytes_len(pb))` — never the `-1` NULL length (comment :456-457). ORM papers over it: `orm_null()` (:79) + `_orm_apply_nulls` (:85) rewrite each `?`-bound `orm_null()` into a literal SQL `NULL`. Functional but text-substitution, not a real bind. | Make `_pg_bind_msg` accept a NULL sentinel per-param and emit int32 `-1` (no bytes); then `orm_null()` flows as a true bound NULL. |
| No PG type-OID decoding — all values are text, typing is struct-field-driven only | PARTIAL | low | M | `forge/forge_pg.nova:420-425` sends `pg_be16(0)` param OIDs (server infers) + Bind requests "all text"; RowDescription type-OID parsed for names only. No native decode of arrays/json/jsonb/timestamp/numeric/uuid/bytea; ORM coerces text by struct field type. | If richer typing is wanted, request binary result format for known OIDs and decode; otherwise document text-only as the intended boundary (struct-driven coercion is arguably sufficient). |
| Redis RESP bulk strings NUL-truncate on binary values | PARTIAL | low | S | `forge/forge_redis.nova:11/25/38` parse RESP with `char_at`/`chr(13)` string ops; bulk-string values assembled as NOVA strings → a value with 0x00 truncates. **Same class as base32/PG-DataRow.** Fine for text, broken for binary. | Assemble RESP bulk strings as byte lists; keep a string convenience wrapper for text. |

### 3.9 Cross-cutting

Items no single domain owns — roadmap/serialization/RTTI/normalization/ABI. The roadmap/feature docs
here are overwhelmingly stale (RTTI, from_json, reflection, serialization all shipped — see appendix).

| Gap | Verdict | Sev | Effort | Evidence (code-verified) | Next step |
|-----|---------|-----|--------|--------------------------|-----------|
| String `==` is byte-wise, ignoring the shipped NFC/NFD normalizers | REAL | medium | S/M | Full canonical normalization EXISTS (`nova_rt_normalize_nfc`/`nfd` nova_runtime.c:9744-9745, real NFD table + composition `nova_unorm_run` :9721). But `nova_str_eq` (:1201) is `strcmp==0` and `nova_rt_eq`'s string branch compares "by bytes" (:2519). `"é"` (U+00E9) `==` `"e"+U+0301` is FALSE despite canonical equality → a web app comparing usernames/paths/tokens across normal forms silently mismatches (correctness + auth-bypass-adjacent). | Keep `==` byte-fast; add a `str_eq_canon`/normalize-then-compare helper + document; if canonical `==` is wanted, gate it and normalize both operands in the string branch of `nova_rt_eq`. |
| ABI version stamp is emitted but never CHECKED | REAL | medium | M | `NOVA_ABI_VERSION_*` + `nova_rt_abi_version()` exist (nova_runtime.c:21057-21066), `__nova_abi_version = "nova-abi-1.0.0"`, but grep `version.*mismatch`/`abi.*check` → no verification; pkg resolver does sha256 integrity but no ABI gate. The struct value model (slot-0 DJB2 hash, packed NSLOTS tag) is exactly what a compiler change shifts → a pre-compiled package built against an old layout loads with no guard → silent corruption, not a clean "rebuild needed". | Stamp the ABI version into emitted objects/package artifacts; add a load-time check (`nova_rt_abi_version()` vs recorded stamp) that fails loud on major mismatch. |
| `serialize`/`deserialize`/`serialize_hex` are dead type-registry stubs — calling them fails at link | REAL | low | S (delete) / M (implement) | `reg["serialize"]`/`reg["deserialize"]` (nova_compiler.nova:11321-11322) exist ONLY in the type registry. NO name→fn map entry (`resolve_runtime_fn("serialize")` returns unchanged), NO `nova_rt_serialize`/`deserialize` in the runtime, no LLVM declare → `serialize(x)` type-checks but emits `call @serialize` with no declaration → link failure. The typed `json_stringify`/`from_json` already cover the real need. | Delete the two registry entries (make the surface honest) OR wire a real binary codec (name-map + 2 runtime fns + 2 declares). Deletion is the clean minimal fix. |
| No dynamic struct construction / field-set-by-name (fully-dynamic ORM/deserializer path blocked) | PARTIAL | low | L | READ side complete (field_names/types/get through-any nova_runtime.c:4358-4399; `call_by_name` :16034; per-struct `from_json`). WRITE side partial: `nova_rt_field_set` mutates by SLOT INDEX (:15888); NO field-set-BY-NAME, NO construct-struct-of-type-X-from-a-dict-at-runtime (grep `construct_by_name`/`struct_from_fields`/`new_by_name` → 0). RTTI already has fnames/ftypes to power it. | Add `nova_rt_construct_by_name(type_name, dict)` (walk `g_struct_meta`, alloc, populate slots by fname) + a field-set-by-name wrapper; wire as builtins for the ORM deserialize path. |
| No native freestanding / no_std profile (only WASM uses `-nostdlib`) | REAL | low | XL | *(merged with Platform embedded-leaf.)* grep `freestanding|no_std|nostdlib|bare_metal|NOVA_FREESTANDING` in the compiler → only the WASM link line. The runtime has a `NOVA_FREESTANDING` bump-allocator #ifdef, but no compiler mode refuses heap/IO builtins for bare-metal or emits a native no-libc binary; ~285 mallocs + sockets/threads/printf unconditionally linked. | (Long-horizon) capability-gate non-freestanding builtins at type-check under `--freestanding` + #ifdef the remaining runtime allocs. Needs a real embedded target. |

---

## 4. Appendix — Recently CLOSED / stale doc claims corrected (don't chase ghosts)

These were once real but are now verified DONE (or were never real). Do NOT re-open them.

**Runtime / RC**
- **CORE_GAP 0.8 struct heap-field leak — CLOSED 2026-07-10.** Type-directed ownership: `NOVA_STRUCT_HASHED_BIT 0x10000` tag bit + `nova_rt_hashed_struct_alloc` + per-type managed-slot bitmap (`nova_rt_register_struct_bitmap`/`nova_struct_bitmap_for_hash`) + rc_free pre-switch managed-slot dec (nova_runtime.c:9867-9881) + make_struct MOVE/SHARE + field_set inc-new + FULLRC field-read-drop. `_struct_field_leak_test.nova` now hard-asserts `listbox <= 100` (was ~4000). Reconverged byte-identical (gen5==gen6 SHA 712A475A), ASAN-clean, 6 probes. The old "dead case NOVA_MEM_STRUCT" framing is stale.
- **CORE_GAP 0.10 (aliased dict-key/list-element swap UAF) — CLOSED 2026-07-09** (`_no_rc` insert delegated to counted siblings; `_alias_swap_leak_test.nova:45` is a hard assert).
- **CORE_GAP 0.9 (`any==string`/ordering `any<string` segfault) — CLOSED** (str OR→str AND lowering routes to box-aware eq/neq/cmp).
- **CORE_GAP 0.12 (`list + any` wild-deref) — CLOSED** (tag-guard → defined panic; runtime-only, no reconverge).
- **Tier 0 UB/UAF class (0.1-0.7) — CLOSED** with C-unit repros; the magnitude float heuristic is gone (box-tag is sole authority); box-aware truthy/neg/div/mod.
- **FULLRC reassignment loop-leak — CLOSED (default-ON)**; `leak_baseline_test.nova` asserts list/dict/chan deltas ≤ 10. The RC_COMPLETENESS "2000/2001" numbers predate the default-on flip and are stale.

**Type system**
- **Generics EXIST and bounds are ENFORCED** (`ti_extract_bounds`, `ti_check_bounds` real "does not implement trait" rejection; `fn<T,U>`, `List<T>`, generic structs via `tgmap`, HM let-poly). The "no generics" claim was stale.
- **Traits/interfaces EXIST** with conformance ("does not fully implement trait"), default methods, dynamic dispatch. (Only the *type-level* signature check is missing — §3.1 gap #1.)
- **Exhaustive-match ADTs EXIST** (`ti_check_exhaustive` → E1009 for user-enum/Result/Option). Was audited "unbuilt" — false.
- **Type checker is SOUND BY DEFAULT** (strict default unless `NOVA_TI_STRICT=0`; per-drain budget; fail-closed at exhaustion). The "fails open / GATE 2 is a lie" hole is gone (1.0-1.3, 1.5).
- **Enum variant managed-payload OWNERSHIP (0.8-adjacent) is CLOSED** (HASHED-tag + bitmap; `_struct_enum_payload_test.nova`). The *memory* side is closed; the *typing* side is §3.1 gap #2.

**Performance**
- **"Float arrays 281×C on escape" — STALE as the default.** S4.2 escape-versioning is SHIPPED + DEFAULT-ON (nova_compiler.nova:10468; runtime `nova_rt_list_is_kind2` :1584, `nova_rt_floatlist_view` :1590) → ~1.2-2.2×C for qualifying loops.
- **"Struct field access 2-3×C" — STALE.** SROA is DEFAULT-ON (nova_compiler.nova:19236-19237); ~1.05×C on 10M struct dot-products.
- **"Float array sum 120×C" — STALE.** Built-in reductions at C-parity via `nova_rt_sum_f`; ~2× homogeneous non-escape.
- **"Tight int loop + modulo 8×C" — STALE.** IR is native `mul/srem/icmp i64`; at parity.
- **"String concat in a loop 30×C" — STALE.** O(n) tools exist (`join`, `bytes`, `bytes_append_str`).

**Concurrency**
- **`remote_spawn` is a bare stub — STALE.** It's a real client-side primitive; what's missing is the distribution FRAMEWORK (captured as §3.4 4.6 PARTIAL).
- **FD_SETSIZE overflow at fd≥1024 on Windows — FIXED** (`#define FD_SETSIZE 4096`). Only the Linux/glibc path remains unguarded (§3.4 4.2).
- **Supervision/link/exit are log-only stubs — STALE.** `forge_otp.nova` has a real supervisor (sup_new/child_add/sup_start, per-child restart policies, windowed intensity, one_for_all/rest_for_one). The residual is preemptive-kill (§3.4 4.4).
- **N>1 grows memory unbounded — STALE** (task-slot reclaim defaults ON). **N>1 unvalidated for correctness — STALE** (scheduler/HTTP/WS-SSE gated at N=4/8). Throughput still regresses (the real 4.1).

**Platform**
- **"WASM is a no-op stub / no frontend" — STALE** for the value-model layer (wasm32 codegen real; heap value-model RUNS in node wasm via `nova_runtime_wasm.c` + `_wasm_vm_one.sh`). Residual = productization (§3.5).
- **"Linux = WSL-once, unverified" — UNDERSTATED.** Real cross-compile pipeline + 40/40 sweep + 10k-task scheduler + first-class `--target=x86_64-unknown-linux-gnu`. Reach = Windows + Linux x86_64.
- **DOM/event/interactivity "deferred" — DONE at proof level** (WASM_FRONTEND_PLAN Stages 0-5 ran against a node oracle). The gap is a real browser CI + framework.

**Toolchain**
- **6.2 REPL exists**, **6.4 LSP exists and diagnostics use the real inferer** (`lsp_collect_diagnostics` → tokenize→parse→`ti_infer_program_named`). The "LSP runs a stale Kotlin inferer" claim is stale. (Hover/completion are still text-scans — §3.6.)
- **`nova build` incremental + cross-compile + LTO** and **`nova fmt` AST-reprint** are real, not stubs. `check`/`lint`/`cov`/`bench`/`eval`/`wasm` all dispatch. A full package resolver + `eval_expr` interpreter EXIST (just unwired into CLI install / REPL).

**Forge core**
- **B1 read/idle timeout (Slowloris) — DONE** (`recv_request_bin`+`_read_timeout_ms`, forge.nova:467-506,4833). **B4 accept backpressure/conn cap — DONE** (`_conn_sem`/`_acceptor`, :4925-5035). Docs still list both open — stale.
- **OTP declarative API (supervisor trees + GenServer + child specs) — DONE**, not "API ⬜". GenServer `on_info`/LiveView prerequisite done via `monitor_into`.
- **Route-param percent-decode (B2), JWT external interop (B6), static symlink containment (B7), `nova new` scaffolder (B9), Struct→JSON keystone — all FIXED.** gRPC + HTTP/2 h2c framing/HPACK/cleartext-serving DONE + TESTED (the gap is TLS/ALPN + streaming + type-driven service).

**Forge libraries**
- **PG/MySQL `match Ok/Err` on any-typed value bug — FIXED** (compiler `84c70d55`; `is_ok`/`unwrap` workaround still correct but the "tracked compiler bug" note is stale).
- **ORM NULL params — DONE at the ORM layer** (`orm_null()`+`_orm_apply_nulls`). Raw-driver NULL bind is still open (§3.8).
- **MySQL caching_sha2 fast-path (8.x) — DONE**, proven live on 8.4.10 (only 0x04 cold-cache remains).
- **ORM CRUD / fluent builder / repository / relations / migrations / one-code-across-3-DBs — DONE.** **PG params/pool/txn/TLS verify-full — DONE.** **JSON true/null round-trip fidelity — DONE** (Stages 0-2). **`json_stringify(list-of-structs)` — FIXED.**

**Cross-cutting / roadmap**
- **Struct RTTI (hash-keyed field metadata) — FULLY BUILT** (`nova_rt_register_struct_meta`/`_field` emitted; json/show/field-reflection consume it). STRUCT_RTTI_DESIGN's "staged/future" is stale.
- **`json_stringify(list-of-structs)` silent-raw-pointer + struct-through-any — FIXED** (compile-time list-elem-struct dispatch + runtime RTTI case).
- **`from_json`/derive-able deserialization "ABSENT" — DONE** (`_make_from_json`(_safe)_method per struct, incl. nested + list<Struct>). **Reflection / dynamic invoke / automatic Show/Eq/Hash/Serialize (no @derive) — DONE.**
- **ABI stamp + NFC/NFD normalizers — the FUNCTIONS are DONE**; only their *enforcement* (package check / `==`) is open (§3.9).
- **F001-F110 catalog + TASK_TRACKER.md — massively stale historical snapshots** (FFI/crypto/db/TLS/self-hosting all shipped; catalog still lists them NOT_STARTED). Do NOT mine these for gaps.

---

## 5. Recommended sequencing (dependency-aware)

The tier build order still holds: **don't do frontier work on a cracked foundation.** But the foundation
(Tiers 0/1/3) is now largely closed, so the next moves are narrower and can partly parallelize.

**Wave A — foundation last-mile (do these first; small, high-trust, unblock everything).**
1. **Float-return uninit (0.11)** — the single remaining silent-wrong-answer soundness bug and it's cross-domain (blocks any float-heavy code / Cortex / Pulse / stats). XL only because it needs a reliable repro; get the repro, LLVM-IR-diff the float return slot, fix the S1 float ABI. **This is the #1 correctness item.**
2. **Trait conformance type check (§3.1 #1) + user-enum payload typing (§3.1 #2)** — two M-effort soundness holes in the *upstream* (type system) of the Tier-0 CVE class ("degrade to any → raw-bit reinterpretation"). Closing them prevents the next 0.11-class bug. They also de-risk the Forge `service`/interfaces marquee (#6), which leans on trait dispatch.
3. **String `==` NFC/NFD (cross-cutting #1)** — S/M, auth-bypass-adjacent, trivially fixable (add `str_eq_canon` + document `==` as byte-fast). Cheap security win.

**Wave B — the RC-completeness cluster (one campaign, shared root).**
4. Closure-capture leak (§3.2 #2), push-of-fresh-temp leak (§3.2 #3), and managed-field-reassign leak (§3.2 #4) **share ONE root: no owned-vs-borrowed provenance at insert/store, and no field_get-inc borrow tracking.** Do them together (MOVE-on-insert + field-borrow tracking + capture managed-slot bitmap = Stage 2 of the 0.8 fix). Then the **RC cycle collector (4.7)** as a supervised XL follow-on — but only after provenance exists, because the collector's safe-free phase reuses the same child-enumeration machinery. All memory-SAFE today, so this is important-not-urgent.

**Wave C — Forge production transport (unblocks real HTTPS/gRPC deployment).**
5. **ALPN in the runtime (Forge #1)** + **Windows SChannel TLS server (Forge #2)** — both L, both gate every HTTPS/h2/gRPC-over-TLS claim on the dev's own OS. Do ALPN first (it's the one dependency for h2-over-TLS), then Windows TLS server, then **gRPC streaming (#3)** and **h2 multi-stream (#6)** on top. The **type-driven `service` block (#6, XL)** comes after Wave A #2 (needs sound trait dispatch).
6. **DB fidelity + binary-safety (Forge-lib)** in parallel — affected-row counts (#1), the base32/TOTP/PG-DataRow/Redis NUL-truncation family (#2/#3/#9 — one `bytes`-based fix pattern), DB timeouts (#6). These are M/S and directly affect correctness of live apps.
7. **Wire the package-manager resolver (Toolchain #10 / CORE_GAPS 6.1)** — the resolver already EXISTS in `nova_pkg.nova`; wiring it into the CLI is L and unblocks any ecosystem story. Registry infra is external → supervised.

**Wave D — DevX polish (adoption, not correctness).**
8. **LSP inferer-backed hover/completion (#9)** + the missing providers (§3.6 #3) — route through the diagnostics path's existing `ti_infer_program_named` result. **REPL via `eval_expr` (#T3)** and an honest `nova debug` banner (#T4). Onboarding quickstart. All L/M/S, all high-leverage for a first-time developer (NOVA's stated identity).

**Wave E — platform reach (each gated on hardware / a specific framework need).**
9. **ARM aarch64 fibers (#2)** — L, needs an ARM host; the highest-value platform item (concurrency silently no-ops on ARM today; blocks Apple Silicon / Edge / mobile). **N>1 per-carrier I/O (4.1)** — L, only when multi-core throughput becomes a production target (N=1 is production today). **Linux epoll/kqueue + FD_SETSIZE guard (4.2/5.2)** folds into real Linux/macOS CI (5.6). **WASM productization (5.3), GPU lowering (5.4), preemption (4.4), distribution/mesh (4.6)** are XL and each waits on its dependent framework (Prism / Cortex / Reactor / Mesh) — do not start them until that framework is the active target.

**The rule that still governs everything:** do not start a framework whose blocking core gap is still
open, and do not pour frontier code onto an unclosed soundness hole. Wave A closes the last soundness
cracks; after that, Forge production transport (Wave C) is the highest-leverage build because its
blockers (TLS/ALPN, sound dispatch) are the same ones every other framework will also need.
