# M:N Per-Carrier Work-Stealing Deque Scheduler — Design & Staged Plan

**Status:** DESIGNED + adversarially vetted (2026-06-22, read-only 5-agent workflow wf_14c090f9: 3 runtime-designers
+ devil's-advocate + synthesis, all grounded against the real nova_runtime.c). Feasibility verdict: **tractable-
incremental**. This is the implementation blueprint. GOAL: replace the single GLOBAL run-queue (one g_sched_lock)
with PER-CARRIER work-stealing deques, to (a) kill the N>1 lock-convoy throughput ceiling and (b) establish a
SINGLE-OWNER-PER-TASK invariant that makes N>1 fiber reclamation + the double-enqueue/lost-wakeup races safe.

## Why (the problem)
At N>1, ALL green tasks live in one global FIFO run-queue (nova_rq_head/tail) behind ONE lock (g_sched_lock). Every
spawn/wake/pop/yield contends on it -> a lock convoy (the pure-yield reschedule storm was throughput-bound). It's
also where the double-enqueue/lost-wakeup races live. N=1 (the ONLY production mode today) is unaffected (the lock is
a no-op at g_carrier_count<=1). Reference designs: Go GMP (P-local runq + global runq + steal), Tokio (per-worker
queue + LIFO slot + global injector + steal), .NET/Java ForkJoinPool (Chase-Lev deque).

## Current state (verified)
- Global run-queue: nova_rq_push/pop (L5512-5529), nova_sched_lock = EnterCriticalSection(g_sched_lock) gated
  g_carrier_count>1 (no-op at N=1). 7 push sites: spawn (L6026), the 5 wake paths (wake_one L5594, wake_send_one
  L5607, wake_sleepers L5685, poll_io L5779, check_offload L5929), and yield_runnable re-enqueue (carrier loop L6376).
- Carriers: nova_carrier_thread (L6385) -> nova_rt_sched_run (loop L6264-6382). park-commit spine: park_committed +
  yield_runnable (the shipped park-then-commit fix). in_rq DOUBLE-PUSH detector at L5514 (watchdog-only TODAY).
- The EXISTING ws_worker_loop / ws_deque (L6570-6727) is a DEAD, INCOMPATIBLE parallel scheduler: no park-commit, no
  nova_ensure_carrier (can't run is_task fibers), no netpoller/sleep/offload integration (parked tasks abandoned),
  mutex-guards even owner ops, global non-atomic RNG (race), no overflow check. REUSE the deque CONCEPT only; the
  ws_* SCHEDULER builtins (ws_init/ws_spawn/ws_task_count/ws_shutdown) are dead -> remove (NOT the same-prefixed
  WebSocket builtins; and delete/rewrite ws_sched_test.nova in the same commit so the regression count holds).
- N=1 byte-identical via systematic `if (g_carrier_count > 1)` gating (L5486+). MUST preserve.

## Target architecture
- NovaCarrierDeque g_carriers[64]: a per-carrier bounded ring (cap 4096) + a per-deque mutex (carriers are few, <=64;
  a mutex-per-carrier is fine — owner pop is uncontended in the common case; lock-free Chase-Lev is an optional later
  refinement, NOT required for the win). Owner push/pop at the bottom; thief steal from the top.
- The GLOBAL list (nova_rq_head/tail) becomes the INJECTOR (overflow + wakes that have no natural home carrier),
  still under the single RECURSIVE g_sched_lock.
- SINGLE-OWNER-PER-TASK invariant: a task is in EXACTLY ONE of {a carrier deque, the injector, running on a carrier,
  parked on a waiter list}. in_rq (promoted to a hard guard) enforces "in a queue at most once." Steal removes from
  the victim's top atomically (under the victim's deque lock) before the thief owns it.
- spawn + yield_runnable -> the CURRENT carrier's local deque (locality); overflow spills to the injector.
- wakes (channel/sleep/io/offload) -> the injector (simplest correct choice; preserves park_committed safety; a later
  refinement can target home_carrier). The recursive lock lets wake paths hold g_sched_lock then call rq_push.
- steal: when local + injector empty, pick a random victim (PER-CARRIER RNG seeded carrier_id^clock — NOT the global
  L6670 RNG), steal ONE task (NOVA tasks are heavy/few -> steal-one, not steal-half). Time-based idle/drain (NOT Go's
  61-iteration counter — NOVA is cooperative, so a fixed iteration count is unbounded wall-time; use now_ms()).

## ★ N=1 stays GENUINELY zero-NEW-overhead
DO NOT put a per-carrier deque on the N=1 path. Keep the EXISTING nova_rq_head/tail linked list as the queue when
g_carrier_count<=1; gate ALL deque/injector/steal logic behind the already-proven `if (g_carrier_count > 1)` branch
(same load+predicted-not-taken branch nova_sched_lock/live_inc already use). At N=1: nova_rq_pop stays L5524-5528
verbatim, spawn/yield/wake stay nova_rq_push verbatim, the g_carriers[64] arrays are never touched (cold pages). Zero
new instructions execute at N=1. "Byte-identical" is verified by reconverge (gen5.ll==gen6.ll — compiler determinism)
+ the full behavioral suite both modes (NOT exe SHA — clang -O2 link is non-deterministic on Windows).

## ★★ THREE non-negotiable corrections (the adversary caught these — bake in BEFORE stealing)
1. KEEP a SINGLE RECURSIVE g_sched_lock for {injector + waiter lists}. Do NOT split into inject_lock/poller_lock: the
   recursion is LOAD-BEARING (wake_sleepers L5675->rq_push L5513, poll_io L5764->L5513, check_offload L5921->L5513 all
   re-acquire; POSIX recursive set L6506). A naive split self-deadlocks. Per-carrier deque locks are LEAF (never
   nested under a deque lock). Lock order: ch->lock OUTER, g_sched_lock INNER, deque locks LEAF.
2. In yield_runnable set park_committed=1 BEFORE the deque push (invert L6376/L6377) -> a task is published-parked
   before it is stealable, else stealing introduces a NEW double-enqueue -> abort.
3. Fix the watchdog reclaim TOCTOU (L6450 reads st->fiber, L6453 derefs fb; reclaim L5991/5997 frees it) BEFORE
   removing the N>1 reclaim gate -- the watchdog is the tool you debug N>1 with. (Snapshot st->fiber once + null-check
   before deref, OR skip when st->status==3.)
DROP from the proposals: the LIFO/runnext slot (unmeasured, worst race -> Stage E, defer); Go's 61-iteration injector
drain (use time-based).

## Staged plan (each stage = 1 commit, independently revertible, its own gate)
- **STAGE 0 — ✅ DONE (2026-06-22):** Promoted in_rq from watchdog-only to a HARD guard at N>1 (abort on double-push)
  + the lock-order law comment. N=1 inert (guard gated off). ★ FINDING: ran green_scale N=4 + reschedule-storm N=4,
  BOTH under NOVA_SCHED_WATCHDOG=1 + ASAN -> the guard NEVER fired -> **there is NO latent double-enqueue in the
  current N>1 scheduler** (green_scale passes clean; the reschedule storm only lock-convoys/times-out, never
  double-enqueues). This REFINES the reclaim-defer worry: the N>1 reclaim UAF was NOT a simple double-enqueue in these
  paths (the reclaim analysis was medium-confidence on that). The guard is now permanent enforcement that will LOUDLY
  catch any double-enqueue introduced by the stealing stages (B+). Gate: N=1 reconverge + 551/551 both modes (inert).
- **STAGE A — ✅ DONE (2026-06-22):** Added NovaCarrierDeque g_carriers[64] (bounded ring cap 4096 + per-deque
  CRITICAL_SECTION, nova_deque_init_all in main_dispatch when ncar>1) + nova_deque_pop_local (owner pop from bottom,
  clears in_rq) + wired nova_rq_pop to consult the local deque first at N>1 (empty -> falls through to the global
  injector). Nothing pushes yet -> N=1 AND N>1 behavior unchanged (pure infra). ★ GOTCHA: the first cut locked the
  deque mutex on EVERY pop (even when empty). Non-ASAN was fine (304ms N=4), but under ASAN the per-pop
  EnterCriticalSection in the carrier pop loop was CATASTROPHIC (green_scale N=4 ASAN 1.2s -> TIMEOUT 70-150s). FIX =
  the standard owner fast-path: an UNLOCKED emptiness check (bottom<=top -> NULL, no lock) before locking. Race-safe:
  the owner is the sole writer of bottom (accurate); a stale (smaller) top only makes "empty" MORE true -> never a
  false-empty. After: N=4 ASAN+watchdog 728ms clean, N=1 312ms unchanged. LESSON for Stage C: the owner pop/steal
  hot path MUST stay lock-free in the common case (a per-op lock is a perf cliff, ASAN-amplified). GATE: reconverge +
  551/551 both modes (N=1 inert) + N>1 green_scale ASAN+watchdog clean.
- **STAGE B (~30 LOC):** spawn (L6026) + yield_runnable (L6376) push to the current carrier's deque at N>1; overflow
  spills to the injector (ADD the cap check ws_deque L6618 lacks); park_committed=1 BEFORE the push (correction #2).
  GATE: child tasks start on the spawning carrier; reschedule-storm ASAN + zero L5157 aborts; N=1 reconverge.
- **STAGE C (~45 LOC):** work-stealing in the nova_rq_pop fallthrough (steal-one, per-carrier RNG, time-based drain).
  GATE: green_scale N=2/4/8 ASAN+wd, reschedule-storm completes (no lock-convoy!), no hang/abort; MEASURE throughput
  vs the global queue (the payoff).
- **STAGE D (~15 LOC):** enable N>1 fiber reclamation (remove the L6367 gate) AFTER the watchdog TOCTOU fix
  (correction #3). The single-owner invariant now makes it safe. GATE: 10k spawn+finish churn at N>2 under ASAN +
  NOVA_SCHED_WATCHDOG=1, zero UAF, zero abort. (This closes the deferred N>1-reclamation item.)
- STAGE E (defer): LIFO/runnext slot (only if Stage C profiling shows channel-handoff cache misses dominate).
- STAGE F (defer): per-carrier netpoller (only if poll_io becomes the next ceiling).
Estimated 6 core commits; budget 8-10 (1-2 debug iterations on Stage C stealing + Stage D TOCTOU verify).

## Open questions to resolve during implementation
- PRE-EXISTING (today, N>1) non-atomic status race: park_io/sleep/offload poller writes w->task->status=0 (L5777)
  while the parking task's fiber may still execute. Independent of deque topology. ASAN/TSan it; may need atomic status.
- Steal granularity steal-one vs thrash at N=8 bursty spawn (confirm a victim isn't drained-then-re-stolen).
- Bounded 4096 deque overflow under a real Forge accept-loop (spill RATE under C10k bursts unmeasured).
- Confirm generators (is_task=0) and scheduler tasks (is_task=1, L6005) are disjoint fiber sets (so a generator
  resume can't race a carrier steal -> the L5157 CAS would abort).

## Honest scope
This is a multi-session, fully-gated effort. N=1 (production) is untouched throughout. It properly fixes the N>1
lock-convoy liveness AND (Stage D) the deferred N>1 reclamation, via the single-owner invariant. Start: Stage 0 + A.
