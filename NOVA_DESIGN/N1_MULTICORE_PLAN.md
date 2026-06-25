# N>1 Multi-Core for Forge — build-ready plan (design wzr6brjer, adversary-vetted)

> Make NOVA's M:N scheduler production-grade at N>1 so **Forge runs on every core** and out-throughputs
> Spring (thread-per-request) / BEAM (scheduler-per-core). SCOPE = multithreading + Forge ONLY (no
> Reactor/game-engine). SOUNDNESS is #1: a scheduler/channel race = hard revert. `goNoGo: revise` =
> build the revised stages below (the adversarial race-hunt's must-fixes are folded in).

## The N=1 invariant needs TWO oracles (verified, non-negotiable every stage)
The compiler **links** `nova_runtime.c` as a separate unit — runtime edits do NOT change `gen5.ll`. So:
1. **`.ll` reconverge `gen5.ll==gen6.ll`** proves only the *compiler* is unchanged.
2. **588 regression at N=1, NORMAL + NOVA_T8_FULLRC** proves the *runtime behavior* is unchanged.
Both required. Plus N>1 stress (below). All new N>1 code gated `g_carrier_count>1`; N=1 path byte-for-byte.

## Stress oracle (ALL must pass at N>1 every stage; + N=1 identity control)
- **(A) green_scale** N=4×70 + N=8×50 (the proven 71a651d config) — scheduler-wide deadlock floor.
- **(B) nova_channel_contention_soak** — 4 producers + 4 consumers, 1 shared channel, 100k msgs, N=4 ×50:
  every msg received EXACTLY once (no lost-wakeup / no double-enqueue), no hang (30s kill-on-timeout),
  ASAN clean. + bounded cap=1 variant (send-park) + channel_close_broadcast (50 parked receivers wake
  once, no re-park double-run).
- **(C) fiber_reclaim_mn** (50k task churn, RSS plateaus ≤~2× N=1, NOVA_SCHED_WATCHDOG=1 to stress the
  fiber-read-vs-free UAF) + **green_netpoll_mn** (8 concurrent socket round-trips < 5s).
- **Sanitizers:** ASAN clean every stage (UAF/OOB). For the concurrency-heavy stages (2 channel, 3
  netpoller, 4 fiber-reclaim), ALSO run **TSAN (ThreadSanitizer) on the Linux path** — the gold-standard
  *data-race* detector that catches lost-wakeup / memory-ordering bugs ASAN cannot. (Windows is primary
  for dev; the race stages get a dedicated Linux TSAN pass.)
- **Test-FIRST:** for each race fix, write the failing-interleaving test that FAILS on the pre-fix code
  first, then the fix makes it pass (same discipline as the inference canaries). Kill-on-timeout is
  MANDATORY on every N>1 test (a hung concurrency test must be force-killed — WaitForExit does NOT kill).

## Staged plan (safest-first; each stage gated by the two oracles + the relevant stress harness)

**Stage 0 — Atomic shared-state hardening (PREREQUISITE; value-model safety). Risk: LOW.**
Runtime-internal races that corrupt the value model itself. 0A `nova_track_heap_bounds` → monotonic CAS
(base=min, top=max; relaxed ok — stale-WIDE only adds a safe RC-header check; stale-NARROW is forbidden
by monotonicity; a torn bound makes `find_tag` misclassify heap-obj↔int = the CVE-class bug 87b987f
closed for arenas, now reachable at N>1). 0B intern-table lock — **MUST take the lock BEFORE the
NULL-check lazy-init** (else two carriers both calloc). 0C `g_box_lo/hi` monotonic CAS. 0D alloc/mem
counters → per-carrier TLS (NOT atomics on the hot path). 0E memo-registry lock/gate. **Grep EVERY
writer of heap_base/top and route through the atomic helper (a missed writer reintroduces the tear).**

**Stage 1 — Forge app immutability (B11) + rate-limiter owner-actor (B8). Risk: LOW-MED.**
1A: `sched_spawn` shares the app dict by-reference (no deep-copy). Add a `frozen` bit to NovaDict;
`dict_freeze(a)` at end of `serve_app[_n]` setup; `dict_set/del/grow` PANIC if frozen. Enforces "app =
immutable config." **Audit forge.nova for any post-setup app mutation (dynamic routes) first — it would
now panic.** 1B: rewrite rate_new/allow + conn_acquire/release as an owner-actor (state in one green
task; handlers send (cost, reply_ch)) — no shared mutable limiter state.

**Stage 2 — Channel deferred-wake + atomic park_committed/yield_runnable. Risk: MED-HIGH (hardest).**
The `park_committed` spin currently runs WHILE HOLDING `ch->lock` → serializes ALL channel traffic
behind one spinner (convoy). Split `wake_one` → `wake_one_deferred` (pop+status=0 under lock) +
`complete_wake` (spin+enqueue OUTSIDE lock). Same for wake_send/wake_all and the identical convoys in
`wake_sleepers` + `check_offload`. Upgrade park_committed/yield_runnable volatile→RELEASE-store/
ACQUIRE-load (volatile gives no ordering on AArch64). **MUST-FIX (fatal): wake_all/close must stamp each
popped task with a generation and have complete_wake SKIP a task that re-parked (in_rq alone misses
woken→ran→re-parked→spurious-enqueue).** **MUST-FIX (fatal): in check_offload, copy `j->task` to a local
and detach the job BEFORE enqueue — the job struct lives on the resumed task's fiber stack (UAF).**

**Stage 3 — Netpoller M:N coordination. Risk: MED.**
L1 (correctness): move `t->status=2` INSIDE `g_sched_lock` (before waiter insert) in park_io,
park_io_timeout, park_sleep, **AND `nova_offload_run` (line 6173 — MUST-FIX: same status-overwrite race,
omitted from the first design; produces a PERMANENT HANG)**. L2: designate carrier 0 sole poller + a
break-fd (POSIX pipe / Windows loopback socket-pair) to wake it on new I/O waiter; bounded non-blocking
poll_io(0) probe gated on `nova_io_waiters!=NULL` (don't tax the hot path). **MUST-FIX: Windows break-fd
consumes one FD_SETSIZE slot (4096 now) — account for it; document the connection ceiling; fallback to
every-idle-carrier-polls if break-fd creation fails (hostile firewall).** L3: POSIX `f->active` CAS
double-resume guard (parity with Windows).

**Stage 4 — Epoch-based deferred fiber reclaim at N>1. Risk: MED.**
Replace the `N<=1`-only reclaim guard (line 6632): tombstone {fiber,task,epoch} onto a per-carrier TLS
limbo list, RELEASE-store `t->fiber=0`, drain once all ACTIVE carriers advanced ≥2 epochs. **MUST-FIX
(fatal): handle EXITED carriers — a carrier that breaks freezes its epoch and stalls min_epoch forever
(all reclaim stops); set `g_carrier_epoch[i]=INT64_MAX` on exit / iterate only active.** **MUST-FIX
(fatal): `g_carrier_epoch[]` writes RELEASE, drain reads ACQUIRE (ARM can observe the epoch write before
the loop body → free a fiber the watchdog is mid-deref = UAF).** `t->fiber=0` RELEASE / watchdog ACQUIRE
(line 6715) is the primary data guard.

**Stage 5 — Flip N>1 default (Forge on all cores) — LAST. Risk: HIGH blast radius, LOW mechanism.**
Only after 0-4 are each gated-green + soaked. Default `g_carrier_count = auto` (CPU count, [1,64]);
`NOVA_CARRIERS=1` stays as opt-out. **Ship N>1 opt-in-but-production-ready for one release, gather real
Forge soak data, THEN flip the default.** One-line revert. Final gate adds a multi-hour Forge
wrk/bombardier soak at N=auto + the head-to-head vs Spring Boot / BEAM (the actual goal).

## Safe FIRST step (await owner go)
**Stage 0A** — `nova_track_heap_bounds` monotonic CAS, gated `g_carrier_count>1`. Smallest, most
isolated, highest-severity. Prereq: grep all heap_base/top writers → route through the atomic helper.
Test: `nova_heap_bounds_race_test` (4 carriers × 100k allocs over a wide range + a 5th classifying every
pointer via find_tag → ZERO misclassifications, ASAN clean). Gate: both N=1 oracles + the race test.

## Open risks to watch (from the race-hunt)
- Stage 2 complete_wake spins OUTSIDE ch->lock → a preempted parking carrier silently loses a task (no
  lock-timeout diagnostic). Mitigate via the watchdog spin-breadcrumbs; consider a bounded-spin→yield.
- Stage 3 single-poller couples I/O latency to carrier 0 not being compute-starved — benchmark; Go's
  dedicated-poller-thread is the fallback if it underperforms.
- Stage 4 reclaim correctness DEPENDS on pinning being fully sound (no residual migration). Re-confirm
  before Stage 4.
- Stage 0 intern-table lock under a new-unique-string-per-request load → measure; frozen-literal-table
  (probe-only) is the fallback.
