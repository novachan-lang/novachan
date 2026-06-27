# FORGE LOOP — Live Resume State (read this FIRST on any new session)

> The 24/7 build loop's "where are we / where do we resume" doc. Git-tracked, updated at every task
> boundary. If a connection drops: read THIS, then `FORGE_STATUS.md` (what/why) + `FORGE_BUILD_PLAN.md`
> (how/when), then `git log --oneline -20`, then continue the CURRENT TASK below.

## The mission
Build **Forge** — the framework where one developer, one language builds the whole system. **Forge is the
future: the goal is that everyone reaches for Forge for their projects.** It must **beat Spring Boot,
Django, Erlang/Elixir, Phoenix** — each at its own strength. Forge wins by *promoting* NOVA's already-
Erlang-shaped runtime primitives into clean APIs (see FORGE_STATUS §1, §6). Core NOVA (the language)
beats C/Rust/Go/Python at the language level; Forge beats the web frameworks on top of it.

**★ THIS IS ONE CONTINUOUS LOOP — NOT SEPARATE TASKS.** The Forge plan is COMPLETE (FORGE_STATUS +
FORGE_BUILD_PLAN); this is EXECUTION, not more planning. Core-NOVA work (N>1 multi-core, inference)
and Forge features are ALL threads of the SAME loop toward the SAME vision — deeply connected (N>1
powers Forge's multi-core throughput; inference cleans ALL NOVA code; one runtime under everything).
**Scope = multithreading + Forge. NOT the Reactor/game-engine plan.** The "phases" below are the FLOW/ORDER within the one loop, never
walls between projects. DESIGN only the genuinely-hard, soundness-critical core pieces (lightly, in the
loop); BUILD everything else against the existing plan. No re-planning, no stop-start — flow.

## How we work (the loop protocol)
- **Model strategy:** Opus 4.8 = every architectural decision + every NOVA compiler/runtime change + new
  language feature + hard/complex task. Sonnet 4.6 = ongoing/mechanical implementation, ALWAYS under an
  Opus-written spec + Opus review + the full gate before commit. Soundness is never delegated.
- **Divert rule:** the loop is Forge, but when a Forge feature needs a core-NOVA change, DIVERT to NOVA
  (Opus designs it, gated), then RETURN to the Forge loop.
- **Per-task cycle:** design (Opus; workflow + adversarial review for anything hard/soundness-critical)
  → build (Sonnet under spec, or Opus for NOVA-core) → GATE → commit → update THIS doc.
- **The gate (mandatory):** compiler/runtime change → `nova_ci.ps1` (reconverge gen5.ll==gen6.ll, NEVER
  exe SHA; perf gate; 588 regression in NORMAL + NOVA_T8_FULLRC). Stdlib/Forge-only → regression
  (-SkipReconverge ok). Kill-on-timeout MANDATORY. New code is zero-annotation + minimal (the 95/5 law).
- **PERMISSION GATE (owner rule):** design/analysis (workflows, code reads) runs freely — but NEVER
  start a BUILD (any NOVA runtime/compiler change OR Forge code) without the owner's explicit "go."
  **Propose → approve → build.** Nothing irreversible without the owner's word.

## The sequencing plan (beat Spring/Django/Erlang/Elixir)
- **Phase A — FOUNDATION (core-NOVA divert): N>1 multi-core production-grade.** NOVA is concurrent
  (green tasks/netpoller, 10k proven) but runs N=1 (single core) by default. N>1 exists but has OPEN
  RACES (channel lost-wakeup, netpoller M:N coordination, fiber-reclaim memory, B8 limiter-owner, B11
  app-object race — FORGE_STATUS §11 F7). **A single-core server can't out-throughput Spring (thread-
  per-request multicore) or BEAM (scheduler-per-core). Closing N>1 is THE foundation for the beat
  claim.** Must stay N=1-byte-identical + gated. **FOR FORGE — multithreading + Forge ONLY (NOT the
  Reactor/game-engine plan).** Make N>1 race-free so Forge handles requests across every core and
  out-throughputs Spring (thread-per-request) / BEAM (scheduler-per-core). Correctness (races) first;
  then ensure requests load-balance across cores so no core sits idle under load.
- **Phase B — the cheap moats:** L4 OTP declarative API (forge.supervisor + child specs; GenServer
  call/cast/**on_info**/timeout/terminate) = beat Erlang's ergonomics on its own substrate; L8
  observability (/metrics, /healthz, JSON logs + trace-id) + L3 auth pipeline = beat Spring; L5 channel
  join-authorization + presence (⟸ GenServer on_info).
- **Phase C — the big infra:** interfaces #8 (FATAL holes first) → HTTP/2 (⟸ TLS+ALPN) → gRPC; L5
  LiveView (only the render-differ is new); L2 Postgres + query DSL + migrations; L9 distribution;
  L10 auto-admin + WASM frontend.

## WHERE WE ARE (update every task)
- **★ LATEST 2026-06-27 (d) — /loop AUTONOMOUS BUILD (continuous; ~10 increments this run):** each
  pure-stdlib + socketless-tested + gated + committed: S3 obs_routes (`0a7f8bf`) · S0 rate-limiter ACTOR
  (`c6125d6`, N>1-safe) · S2 on_terminate (`ad2dd78`) · S3 traceparent parse+mint (`2c32ed2`,`820fe94`) ·
  S4 RBAC (`04a148a`) · S2 cron-matcher (`1cf9266`) · S2 windowed restart-intensity (`ce721a0`) · S5
  presence tracker (`c2f40f1`) · S4 authn→authz chain (`a9501b9`: RBAC reads JWT claims via
  req.state["user"]). **The substantial pure-stdlib MOATS are DONE — S2 OTP, S3 observability, S4 auth
  chain, S5 presence.** Clean pure-stdlib left (THIN): T8.11 problem+json · S5 channel join-auth ·
  presence_count/diff · more validation rules. **After those the plan is OWNER-LEVEL / the DEFERRED BATCH:**
  LiveView (render-differ + design) · the runtime+compiler session (T1.1 timed-recv, dict-rehash-on-deep-copy
  fix, T2.7 with-tx, mw_metrics route-label, T1.5 drain, S2 strategies [no preemptive kill → design],
  mw_rate_limit req-IP, T1.7 realpath) · PC-1 io-scaling (dedicated) · big infra (S6 interfaces→S7 HTTP/2→S8
  gRPC). NOTE: `jwt_verify` REQUIRES an `exp` claim. **Also shipped: S3 problem+json (`aaa3ca8`) + S5 channel-join/presence_count. ⇒ AUTONOMOUS PURE-STDLIB PHASE COMPLETE (~12 gated increments this run); the clean pure-stdlib seam is EXHAUSTED ⇒ OWNER DIRECTIVE 2026-06-27: "start and complete ALL" (NO asking). Grinding the big pieces in order, gate+commit each: (1) LiveView — auto-metrics mw + route-label (`929d031`) capped S3; LiveView diff core DONE (`forge_live.nova`: statics/dynamics + live_diff/live_apply/live_html, pure-stdlib); NEXT = per-connection live process (spawn holds state, re-render on event, push patch over forge WS) → template helper → client JS. (2) runtime+compiler batch (dict-rehash-on-deep-copy fix, with-tx, timed-recv — HEAVY reconverge gate). (3) PC-1 io-scaling (F7 throughput, dedicated). (4) S6 interfaces → S7 HTTP/2 → S8 gRPC. (5) S9 PG → S13 WASM. Authoritative latest = `git log --oneline -32`.**
- **★ LATEST 2026-06-26 (c) — S2 OTP CORE SHIPPED (continuous autonomous build):** new module
  `forge/forge_otp.nova` — Supervisor one_for_one (`f9e98ef`), GenServer match-dispatch actor
  (`86c2d60`), Agent (`20dca35`), Task/async + Nursery (`ea05c74`), Registry (`dc77526`) — ALL
  pure-stdlib, socketless-tested, PASS. Plus S0 conn-cap semaphore (`a25ddba`). 3 NOVA runtime
  constraints found → memory [[nova-otp-spawn-constraints]]: (1) from a spawned proc use
  `spawn named_fn(args)` not closures; (2) `type_of(struct)`="struct" → dispatch via `match`;
  (3) new key on a spawn-deep-copied dict breaks contains/index → dynamic-key dicts born in the loop.
  **NEXT in S2:** T4.15 application root → T4.10 on_info (LiveView/Presence prereq) → jobs/cron/pool →
  strategies/intensity. **Batch as ONE runtime/compiler session:** T1.1 timed-recv (`tcp_recv_bytes_to`
  via `nova_sched_park_io_timeout`) + the dict-rehash-on-deep-copy fix + T2.7 `with tx`. **PC-1
  io-scaling still its own dedicated session.** Full task-by-task state = `FORGE_BUILD_PLAN.md` ledger.
- **★ LATEST 2026-06-26 (b) — FORGE FEATURE LOOP kicked off (owner: "go ahead, don't stop"):** shipped
  **T2.6** (`pool_acquire_to(ms) -> Result<int>` — `select_timeout` park+deadline; saturated pool errs, never
  hangs; `4d0c562`) + **T1.4** (route `:param`/catch-all percent-decode, closes B2; `78ac7cf`) — both gated
  (pure-stdlib → compiler/runtime untouched → reconverge trivial; targeted regression green). VERIFIED
  already-done (ledger was stale): T2.5 db_insert/delete + the M1 hero + T2.10 `resp_model` nested fail-closed
  (all re-ran PASS this session). **S1 is essentially COMPLETE** — only **T2.7** (`with tx` = a NEW-SYNTAX
  compiler feature + panic-rollback + ~50min reconverge gate; NON-blocking, `tx(pool,[[sql,params]])` already
  works) and **T2.8** (Postgres, env-gated, ⟸ T2.7) remain. Opened **Sprint S0** (production hardening floor).
  ⚠ COMPILER FOOTGUN found: bare `-> Result` (no `<T>`) + unannotated `let` + `match` = silent both-arm
  fall-through (no error, exit 0); fix = `Result<int>` + annotated `let` (a "match hits no arm → error"
  hardening item). **NEXT — all FOCUSED units in fresh context (the low-risk socketless seam is now
  exhausted):** (a) **S0 live-server hardening** (T1.3 conn-cap → T1.1/T1.2 read/idle timeout → T1.5 drain →
  T1.6 wire forge_limits) — SAFETY-CRITICAL: bounded serve loops + kill-on-timeout, the class that crashed
  Windows twice; (b) **T2.7 `with tx`** (compiler feature); (c) **PC-1 per-carrier-io** (io-scaling foundation,
  still its own dedicated session). New: `_fdb_one.ps1` (parameterized forge_db smoke), `forge_pool_park_test`,
  `forge_param_decode_test`.
- **Done & committed:** Forge M1 hero runs (typed CRUD over the router, `forge_hero_test`, 3dda37b).
  Typed-DB stdlib (db.all/find/insert/delete, 85c8bda). Inference S0+S1 (nominal struct-return,
  flag NOVA_STRUCT_RET default-OFF, gate ALL GREEN, 0f0b86c). Designs saved: quasi-quote (deferred),
  ZERO_ANNOTATION_AUDIT.md, SOUND_INFERENCE_PLAN.md.
- **Deferred (opportunistic, non-blocking):** inference S2 lambda-pinning (drops the hero's one
  `req: Request`); quasi-quote v1; flag-ON enablement of NOVA_STRUCT_RET.
- **CURRENT TASK (★ LATEST 2026-06-26 — read this first):** N>1 multi-core foundation SHIPPED through the
  accept/poller (all committed + gated). This session: monitor lock + task-struct reclaim (~20× leak cut) +
  Batch A safety (C2 nova_mem_live atomic / 0D rc-counts / 0E @memo lock, 9541db7) + N1-exit (listener
  keep-alive + tcp_close purge — closed a graceful-shutdown HANG the adversarial review caught, d4453b4) +
  accept/poller **S-a** single poller / kills the herd (9ae2c57) + **S-b/S-c** wake-one FIFO + parallel accept
  (14c1c7c). Reconverged **579F03A8**, 598/0 both RC modes, green_scale N=4×70+N=8×50 + ASAN all clean.
  **NOVA is multi-core for COMPUTE (/cpu 6.1×@8) and io-CORRECT.** ★★ **DEEP I/O FINDING** (keep-alive
  server-saturating soak, _ka_run.ps1 + _ka_load_client.nova, f814b65): **I/O throughput REGRESSES at N>1**
  (keep-alive /ping N=1=29,941 rps, N=4=0.82×, N=8=0.76×, bad=0) — the GLOBAL `g_sched_lock` serializes every
  io park/wake/spawn; at 30k+ rps the cross-thread coordination beats the parallelism for cheap requests. This
  is THE blocker for Forge out-throughputing Spring/Phoenix on web traffic (io-bound). ★★ **THE FIX (owner-
  chosen) = PER-CARRIER I/O** (Go per-P netpoller): `NOVA_DESIGN/PER_CARRIER_IO_DESIGN.md` (5841b5b) — fully
  DESIGNED + ADVERSARIALLY REVIEWED (wf w31dn6cg7 → SOUND + staging right) + the RC-1 precondition VALIDATED
  (pin-at-park is a near-no-op; owner-only invariant CONFIRMED — no unbound io-parks at N>1; green_scale 15 +
  green_netpoll 5 + forge_spawn 3 clean, then reverted/folded into the PC-1 cut). **★ NEXT (a DEDICATED focused
  session, BEFORE Forge): implement PC-1** — the atomic shard: `g_carrier_io[]` per-carrier io lists + per-
  carrier poll + RC-1 pin-at-park + RC-2 shutdown re-derive (each carrier drains its own list; no single-poller
  join) + RC-3a hybrid listener (listener stays central wake-one; shard only per-connection recv/send/connect)
  + timed-io shard. Gate each: reconverge + green_scale + ASAN + keep-alive soak (the WIN gate: N>1 > N=1) +
  DNS-offload-N>1 stress + shutdown-drain. Then **PC-2** (pin handler via sched_spawn_on(self) in forge
  `_acceptor` — the builtins sched_spawn_on/sched_carrier_count already shipped in 14c1c7c) → **PC-3**
  (per-carrier listener / Linux SO_REUSEPORT). It partially RESTRUCTURES S-a's connection-io poller+cv → the
  most dangerous code → not to be rushed at the tail of a long session. **Then** flag-enablement (forge servers
  default N>1 ONLY once io scales; N=1-for-io until then) → **STOP for Forge permission.** The owner's "8
  foundation tasks" are DONE except this io-scaling refactor (the real Forge-throughput win — banked + ready).
  --- earlier state (pre-2026-06-26) below ---
- **CURRENT TASK:** Phase A foundation — **N>1 multi-core design COMPLETE** (NOVA_DESIGN/
  N1_MULTICORE_PLAN.md; design wzr6brjer, adversary-vetted — the race-hunt caught 7 FATAL/MAJOR holes,
  ALL folded in; goNoGo=revise = build the revised stages). It IS the complete multithreading-for-Forge
  design: **Stages 0-5, ending at Stage 5 = flip N>1 default → Forge on all cores** (that IS the
  parallelism; work-stealing folded to optional-later, NOT needed for v1 — the global-injector-claim
  model already balances new connections across idle cores). **LOOP RUNNING (owner GO, full autonomy to the Forge end).**
  **STAGE 0 COMPLETE (value-model N>1-safety, all gated + ALL-GREEN):** 0A heap-bounds CAS (commit
  b7b4063), 0B intern-table lock + 0C box-bounds CAS (commit bd33455). Each: reconverge gen5.ll==gen6.ll
  + 590-591/N PASS both RC modes + N>1 stress (_n1_heapbounds_test, _n1_box_test) 25/25 + ASAN at N=4.
  DEFERRED (tracked, CLOSE BEFORE STAGE 5 FLIP): 0D mem counters (diagnostic, racy-but-benign at N>1,
  TSAN-follow-on); 0E @memo cache (nova_rt_memo_cache returns a per-fn cache dict the GENERATED @memo
  code races on — needs @memo codegen locking, not just a registry lock; @memo is N=1-correct today).
  **REORDER (soundness order, not feature order):** Stage 1 (B11 app-freeze + B8 limiter) is DEFENSIVE
  (handlers only READ the app dict in correct use; limiter not on the hot path) — do it BEFORE the
  Stage-5 flip. Tackle the ACTIVE N>1 bugs first: **PROGRESS (verified by reading the runtime): N>1 CORRECTNESS is essentially COMPLETE.**
  Stage 0 ✅ value-model; CHANNELS ✅ correct (park+wake under ch->lock, NO lost-wakeup — so the planned
  Stage 2 deferred-wake is PERF, not correctness); STAGE 3a ✅ status-overwrite HANG fixed (status=2
  moved INSIDE the publish lock in park_io/park_io_timeout/park_sleep/offload_run — was after the unlock
  so a poll/check_offload could set status=0 then get clobbered -> enqueued-but-parked HANG); NETPOLLER
  ✅ correct (poll mutates nova_io_waiters under g_sched_lock + F1 park_committed spin -> no double-wake;
  Stage 3b single-poller is PERF). Stage 3a IMPLEMENTED (5 reorder edits, byte-identical N=1); N>1
  sleep-park stress 30/30 + 8/8 ASAN at N=4; guard _n1_park_test added; N=1 gate running.
  **STAGE 4 ✅ DONE (gating): fiber-reclaim leak fixed as a ONE-LINE guard removal, NOT an RCU mechanism.**
  Careful reading showed the RCU/epoch design was solving a non-problem: pinning (commit 71a651d) means a
  CLAIMED task only ever runs on its home carrier (no migration), and the watchdog derefs st->fiber ONLY
  for g_carrier_spin tasks (parked-being-woken, never finishing) — so a FINISHED fiber is touched only by
  its home carrier; immediate free is race-free. Changed `if (g_carrier_count<=1) reclaim` -> always
  reclaim (N=1 unchanged — it already reclaimed). ASAN 6/6 + 10/10 churn at N=4. (The old `N<=1 only`
  guard was stale PRE-pinning conservatism.)
  **STAGE 1 (defensive) LARGELY DISSOLVES (verified by audit):** every `a[...] =` write in forge.nova is
  in a SETUP/registration fn; the serve/dispatch path only READS `a` and handlers get `req` not `a` -> the
  app dict is ALREADY read-only post-setup -> concurrent reads at N>1 are safe -> **B11 freeze unnecessary**
  (would add hot-path cost to defend an already-safe invariant). B8 limiter is NOT wired into serve -> not
  raced -> its owner-actor is a future-when-wired concern.
  **VALIDATED FORGE AT N>1 (commit e4a03b9..): the full 594-suite at NOVA_CARRIERS=4 = 588 PASS / 5 FAIL.**
  The 5 fails were ALL socket-server streaming tests (forge_sse / ws_chat / ws_presence / ws_lifecycle /
  model_route) and ALL **TIMEOUTs, not functional fails** — the watchdog showed every assertion PASSED
  ("SSE stream opened... event streamed... keepalive...") then the program HUNG with live=1, all carriers
  idle. **Root cause (real N>1 bug): a leftover background task** — the SSE/WS keepalive ticker
  (`_sse_ticker`: sleep+try_send) and/or the stream parked on its hub channel after the client closed —
  kept `live=1`. The **N=1 idle path already exits Go-style once the ROOT (main) task finishes** even with
  a lingering daemon (nova_runtime.c ~6651-6653), but the **N>1 idle path did NOT** — it waited for
  `live<=0` forever -> hang (and a task-LEAK per closed streaming conn on a real N>1 server). **FIX (made,
  gating via nova_ci bp5cbwzpp): bring N>1 to parity** — in the N>1 idle branch (~6638), break when
  `nova_sched_root_task->status==3`. N>1-branch-ONLY => N=1 byte-identical. **DONE + COMMITTED (5456066):**
  nova_ci ALL GREEN (gen5.ll==gen6.ll B4CAC97E, perf native, 593/594 both modes N=1) + **full N=4
  regression = 593 PASS / 0 FAIL** (the 5 streaming tests fixed; the ENTIRE suite now passes at BOTH
  N=1 AND N=4 => multi-core CORRECTNESS broadly validated, the Stage-5 correctness bar met).
  NOTE for re-running forge tests standalone: `_install_forge.ps1` first (installs current forge.nova ->
  nova-compiler/lib), then NOVA_HOME=<repo>/nova-compiler; the _nh_home copy is stale.
  **THROUGHPUT SOAK DONE (2026-06-26, NOVA_DESIGN/FORGE_N1_SOAK_PLAN.md + harness forge_load_server/
  client.nova + _forge_load_soak.ps1):** measured N=1/2/4/8 on a handler spectrum, separate-process
  client, nonce-echo correctness. **bad=0 across ~30k requests (multi-core CORRECTNESS holds under
  load).** /cpu (compute) scales **3.84× at N=8** (1.53/2.47/3.84 @ 2/4/8) — the beat-on-compute number.
  But /ping + /user (I/O- + string-bound) get **NO benefit (0.84–0.93×, even regress)**. ROOT CAUSE
  (measured): the SINGLE accept-loop task pinned to one carrier + netpoller thundering herd (all carriers
  select() the same nova_io_waiters) + atomic-RC/lock overhead serialize the CONNECTION path. **#1
  FINDING: the accept/poller serialization is THE bottleneck for typical (I/O-bound) web throughput** —
  fixing it (per-carrier accept + single-poller) is what makes multi-core Forge BROADLY win, not just
  compute apps. Decisively confirms flip = **Option B′** (Forge tooling sets NOVA_CARRIERS; NEVER the
  global default 6841 — it would regress the 95% non-compute case). Benchmark harness committed = the
  oracle to measure the accept/poller fix against.
  Soak findings (tracked, not yet built): **N1-server-exit** — a standalone NOVA server exits ~10ms at
  N=1 because tcp_accept is an UNTIMED io_waiter and the N=1 idle-exit (6661, has_timed_io only counts
  deadline>0) treats it as pure-io-idle and breaks (worked around in the bench with a keepalive sleep
  daemon). **ATTEMPTED the broad fix (6661: has_timed_io→nova_io_waiters, let ANY io_waiter keep N=1
  alive) — gate FAILED: linalg_lib_test TIMEOUT. REVERTED (discipline: revert-not-patch).** linalg is
  PURE COMPUTE (no io/spawn/file) so the broad keep-alive should not touch it → cause is a STALE/leaked
  io_waiter that pure-io-break used to mask, OR a parallel-load flake (linalg is compute-heavy, regression
  runs concurrently). PROPER FIX = TARGETED: keep N=1 alive only for a LISTENER-accept io_waiter (not all
  io), AND/OR first find why a no-io program has a lingering nova_io_waiters entry. Deliberate retry must
  re-run + bisect (linalg standalone WITH the fix → hang=real, pass=flake). The bench keepalive daemon
  stays as the workaround. **C2** nova_mem_live non-atomic (per-carrier TLS; gates only the leak probe).
  **C1** arena-mode = VERIFIED SAFE.
  **ACCEPT/POLLER SCALING DESIGNED (FORGE_ACCEPT_POLLER_PLAN.md, design wc8trswnr adversary-vetted):**
  single-poller THREAD (kills the herd) + wake-one + parallel-accept, STAGED S-a→S-b→S-c, each gated.
  **VERDICT: build-ready but DELIBERATE focused work, NOT an overnight rush** — S-a alone is a new poller
  thread + break-fd + per-carrier events + idle-wait restructure on the MOST concurrency-critical code
  (~8 subtle adversary hazards) and its payoff is only BREAK-EVEN (~1.0×; the real gain is S-c). A subtle
  lost-wakeup could pass a green_scale gate and fail in the field → soundness #1 says implement with full
  attention, gate each stage against the committed soak harness. DEFERRED-by-design: the F1-spin-under-
  lock restructure (open ONLY if S-a's soak shows it's the ceiling).
  **THEN REMAINING:** (1) **implement accept/poller S-a→S-b→S-c** (deliberate session; THE I/O-throughput
  lever). (2) C2 mem_live TLS + leak/stability soak. (3) flip = B′ once I/O scales. (4) N1-server-exit
  proper fix (untimed io_waiters keep N=1 alive — small, gated; removes the bench keepalive daemon). (5)
  **Forge Phase B moats** (OTP declarative API / observability / auth — the mission's BREADTH; lower-risk
  Forge-level code). 0E memo DORMANT. 0D counters = TSAN-follow-on.
  **★★ STABILITY SOAK FOUND A PRODUCTION-BLOCKER LEAK (2026-06-26, _forge_stability_soak.ps1):** a
  long-lived server under sustained load LEAKS ~0.5KB/request, MONOTONIC, **N-INDEPENDENT** (N=1 +301%,
  N=4 +273% RSS over 192k requests; bad=0, no hang, throughput steady). CONFIRMED SOURCE: the
  **NovaSchedTask struct leaks on every task finish** — nova_sched_reclaim_fiber (called at the finish
  path nova_runtime.c:6717) frees the FIBER STACK but never `free(t)`; the struct is freed ONLY on the
  spawn-FAILURE path (6333/7109). So every spawned task (every Forge request handler via serve_req's
  fire-and-forget sched_spawn) leaks its PID struct. PRE-EXISTING; the old "flat-memory" proof MISSED it
  (it measured per-request ARENA delta, not RSS over many requests). A server OOMs in hours → **NOT
  production-ready until fixed.** FIX DESIGNED + adversary-vetted (FORGE_TASK_RECLAIM_PLAN.md): there are
  actually THREE leaks (struct + monitors array + exit_reason). Mechanism = generational slot-map PID
  (bit63=0 so it never aliases a heap ptr; recycle ONLY the task-struct, NOT the RC'd messaging PID),
  grow-only freelist. **VERDICT (adversary): "NOT safe to implement incrementally at N>1" — sound ONLY at
  N=1** (cooperative single-threaded → no TOCTOU/lost-DOWN). **★ NEW PRE-EXISTING BUG SURFACED —
  CRITICAL-1: nova_rt_monitor() green path (7760) holds NO lock** while N>1 ships → monitor(p) on one
  carrier races the monitored task's finish loop (realloc vs read of t->monitors) on another = heap
  corruption/UAF; LATENT (regression doesn't reliably hit it), real for serve_safe_req at N>1. So N>1
  reclaim is BLOCKED on a per-task monitor lock the runtime needs ANYWAY for CRITICAL-1.
  **★ DELIBERATE work — prioritized (FOUNDATION correctness+compute-throughput DONE+banked):**
  **(1) per-task MONITOR LOCK — ✅ DONE + committed (ed3b668).** g_green_monitor_lock (gated >1) closes
  CRITICAL-1 (monitor-vs-finish realloc-vs-read race) + CRITICAL-3 (lost-DOWN). Gate green (594/595 both
  modes), _n1_monitor_race_test PASS at N=4 + ASAN, green_scale N=4 10/10. N=1 byte-identical.
  **(2) TASK-STRUCT RECLAIM (the production leak) — ✅ DONE + committed (abef642 struct + b54e761
  closure).** Generational slot-map: spawn HANDLE = ODD-encoded (slot,gen) (bit0=1 → find_tag's
  alignment reject [722] never misclassifies it; NO find_tag change). 4 deref sites + reclaim under
  g_green_monitor_lock (closes CRITICAL-2 TOCTOU). Finish gen-bump+freelist-push gated
  NOVA_SCHED_RECLAIM_TASK (default-OFF). On reuse: free monitors+exit_reason + rc_dec mailbox; closure
  (entry_fn) rc_dec'd at finish. Root never recycled. VERIFIED: reconverge gen5.ll==gen6.ll, 596/597
  both modes; _n1_monitor_race + _n1_stale_pid + _n1_cap_closure PASS at N=4 + ASAN (no UAF/wrong-task/
  double-free). **SPAWN-PATH LEAK FIXED: struct + closure + mailbox-on-(interleaved-)reuse → ~20x leak
  reduction (OOM hours→weeks).**
  **(2b) RESIDUAL (tracked, smaller, SEPARATE): ~25 B/req in the forge REQUEST-handling path** (NOT the
  spawn path — that's flat under interleaved reuse). A per-request alloc/arena-escape in serve/dispatch/
  response. Pinpoint via LSan (Linux) or a bounded serve_req_n + live_count() at N=1 (NOT the
  all-then-wait _leak_count pattern, which mis-measured — slots never reused). The reclaim flag stays
  default-OFF until this is closed + the soak fully PLATEAUS, then flip default-ON.
  **(3) accept/poller S-a→S-c** (I/O throughput, FORGE_ACCEPT_POLLER_PLAN.md). **(4) Forge Phase B**
  breadth (OTP/observability/auth). Each = gated impl → re-run the soak/stability harness as the oracle. N=1 invariant = TWO oracles (reconverge for the
  compiler + 588 at N=1 both modes for the runtime) + N>1 stress (green_scale + channel-soak +
  fiber-reclaim/netpoll). Build order 0→1→2→3→4→5, each gated; a stage failing any oracle is REVERTED,
  not patched forward.

## Resume checklist
1. Read this doc + FORGE_STATUS.md §11 F7/B8/B11 (the N>1 races) + the N>1 design output when it lands.
2. `git log --oneline -15` — confirm last commit.
3. Continue the CURRENT TASK. If mid-build: check the gate state; never commit ungated compiler changes.
