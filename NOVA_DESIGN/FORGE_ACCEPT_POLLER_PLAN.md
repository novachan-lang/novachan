# Multi-Core I/O Throughput — single-poller + parallel-accept (design wc8trswnr, adversary-vetted)

> Make I/O-bound Forge throughput scale with cores. MEASURED problem (FORGE_N1_SOAK_PLAN.md): at N>1,
> compute-bound scales 3.84×@8 but I/O/string-bound handlers get NO benefit (0.84–0.93×) — the SINGLE
> accept-loop (pinned to one carrier) + the netpoller THUNDERING HERD (all idle carriers select() the
> same global nova_io_waiters, fight g_sched_lock, N-1 drain nothing) serialize the connection path.
> **STATUS: build-ready, gated, staged — but NOT yet implemented. This is a MAJOR netpoller rework on
> the most concurrency-critical code; it must be DELIBERATE focused work, not an overnight rush
> (soundness #1). The risk verdict + must-fix list below are the implementation contract.**

## The two changes + how they combine
- **Single-poller (herd kill):** ONE entity owns select(). A DEDICATED poller THREAD (NOT carrier 0 — a
  CPU handler on carrier 0 = global I/O blackout) blocks in select() over nova_io_waiters, drains ready
  waiters, re-enqueues each to its HOME carrier via the EXISTING nova_sched_enqueue_task→carrier_enqueue
  path (wake-to-home already exists; we only relocate WHO calls select()). Carriers stop polling; they
  block on a per-carrier wake event.
- **Parallel-accept (accept scale):** spawn N acceptors, one pinned per carrier (new sched_spawn_on),
  all parked on the SAME shared listener fd (no SO_REUSEPORT — absent on Windows). Handlers stay
  unclaimed (sched_spawn, home=−1) → work-steal across cores.
- **Combine:** the listener fd is just another io waiter the single poller owns → when readable, wake
  EXACTLY ONE parked acceptor (EPOLLEXCLUSIVE/nginx-accept_mutex semantics — implementable ONLY because
  one authoritative poller now exists). Level-triggered select() re-reports until the accept queue
  drains → a backlog of K fans out across acceptors over rounds, no connection stranded.

## Staging (smallest-risk-first; each gated g_carrier_count>1, N=1 byte-identical, reverts independently)
- **S-a — single-poller thread (the herd kill). Target ~1.0× (BREAK-EVEN, removes the N>1 penalty, NOT
  a gain).** Refactor nova_sched_poll_io (6028–6113) → nova_poller_select_once, logic VERBATIM (keep the
  F1-spin AND the sleep-deadline fold 6055–6059 — the poller OWNS sleep timing, so no ownership split).
  New nova_poller_thread (created in nova_rt_main_dispatch ~6880, ncar>1 block). New break-fd (POSIX
  socketpair; Windows loopback-pair + **TCP_NODELAY mandatory**; CAS-coalesced kick; poller drains+clears
  each round). Carrier idle branch (6610–6628) gated: wake_sleepers + check_offload + rq_pop, then
  nova_carrier_idle_wait (bounded park, NOT poll_io). Per-carrier wake event (extend NovaCarrierDeque
  ~5695); nova_sched_enqueue_task signals it; **idle_wait MUST re-check the deque under lock before
  blocking** (POSIX cond-lost-when-no-waiter). Shutdown: set g_poller_stop + kick + JOIN POLLER FIRST,
  signal every carrier event on root-exit (else exit latency). Fallback: break-fd init fail →
  g_single_poller_mode=0 → today's every-carrier-polls (degrade to correct, never a new hang).
- **S-b — wake-one infra (inert with one acceptor; proves the mechanism).** Add NovaIOWaiter.exclusive;
  park_io_ex(...,exclusive); accept uses _ex(1) only at N>1. Wake-one in the poller drain: per ready
  listener, wake the first exclusive READ-waiter, skip the rest this round. **★ FAIR SCAN ORDER (adversary
  BLOCKING #1): nova_io_waiters is HEAD-insert + head-first-scan → the just-reparked acceptor is always
  at head and always wins → ONE acceptor monopolizes, N-1 starve → ZERO parallelism (strictly worse than
  single-acceptor). FIX = TAIL-insert exclusive waiters (FIFO) so the oldest acceptor wins.** Non-exclusive
  waiters untouched (wake-all). Deadline-expiry of an exclusive waiter never suppressed.
- **S-c — parallel accept (the scale-out). Target ~3–5×@4, 4–7×@8 (NOT clean N× — the kernel accept-queue
  lock still serializes the syscall; the win is spawn+dispatch parallelizing).** New builtins
  sched_carrier_count() + sched_spawn_on(cid,closure) (presets home_carrier before enqueue; all pinning
  invariants hold). serve_req (forge.nova:3744) fans out to N pinned acceptors on the same listener;
  handlers stay sched_spawn. **Shutdown (adversary #4): _accept_loop must break on accept-fail-after-close
  (g_listener_closing sentinel) else N fibers leak.** Document residual HOL-blocking (a slow handler on
  carrier i stalls carrier i's pinned acceptor; wake-one wakes whichever IS parked → degrades to
  fewer-core, never incorrect).

## MUST-FIX (adversary, folded in)
1. **Wake-one starvation** (SERIOUS, blocking S-c) → S-b TAIL-insert/FIFO fairness + a fairness unit test.
2. **Single-poller F1-spin under g_sched_lock serializes ALL wakeups** through one thread (OS-preempted
   home carrier = ~15ms global stall) — **DEFERRED #5**: S-a keeps it verbatim; if S-a's soak shows the
   serial drain is the ceiling (/ping still <1.0×), THAT is the signal to open the F1-restructure (a NEW
   unlink/enqueue atomicity race → separate deliberate gated work, do NOT smuggle into S-a).
3. **Sleep-waiter ownership** (SERIOUS) → S-a resolves by NOT splitting (poller keeps the sleep-fold).
4. break-fd self-pipe ordering (self-heals in 1 round-trip; 50ms cap = kernel-failure backstop only);
   TCP_NODELAY on the Windows loopback write end; FD_SETSIZE−1=4095 ceiling (N acceptors on one fd =
   one bit, don't inflate the set) — document in FORGE_STATUS.
5. Shutdown lifecycle (poller join before carriers; acceptor close sentinel); POSIX cond re-check;
   exit-latency (signal carrier events on root-exit).

## RISK VERDICT (from the design) + my call
- **Design verdict: implementable incrementally-gated S-a→S-b→S-c, with 2 preconditions:** (1) S-a must
  independently prove ≥1.0× before S-c starts (else the deferred F1 fix is the real ceiling — escalate,
  don't ship); (2) S-b's fairness fix is non-negotiable before S-c (else S-c is negative value).
- **My call (soundness #1): DELIBERATE work, NOT an overnight autonomous rush.** S-a alone is a new
  poller thread + break-fd + per-carrier events + idle-wait restructure + shutdown ordering on the most
  critical code, with ~8 subtle adversary hazards; its payoff is only break-even. A subtle intermittent
  lost-wakeup can pass a green_scale gate and fail in the field. Implement S-a in a focused session with
  full attention; gate each stage (reconverge + 593 + green_scale N=4×70/N=8×50 + ASAN + RE-RUN
  forge_load_soak to MEASURE /ping moving 0.9×→1.0×→Ncore×). The soak harness (committed f6bf11a) is the
  oracle for every stage.

## Key sites
runtime nova_runtime.c: nova_sched_poll_io 6028–6113; carrier idle 6610–6628; nova_sched_park_io
5924–5942; nova_sched_enqueue_task 5834–5837; NovaIOWaiter ~5644; NovaCarrierDeque ~5695;
nova_rt_main_dispatch/ncar>1 ~6880; nova_rt_tcp_accept 10536–10554. Forge: serve_req forge.nova:3744–3752.
(NOTE: these line numbers predate the N1-exit edits; grep by function name. park_committed is SET at the
carrier loop's parked branch — nova_runtime.c ~6921 — and the F1 spins are at ~5941/5954/6041/6148/6319.)

## S-a ADVERSARIAL REVIEW RESULTS (2026-06-26, wf wkppsoghl — 5 lenses, 2 CRASHED) — VERDICT: FRESH SESSION
A pre-implementation adversarial review of the S-a design (full code read) returned **GO-WITH-CHANGES but
DO-IT-IN-A-FRESH-FOCUSED-SESSION**, with strong, concrete reasons (not caution-as-default). The review is
INCOMPLETE: the `lost-wakeup` and `ownership-move` lenses CRASHED mid-run (API errors) — **re-run them first
next session.** Full output: tasks/wkppsoghl.output.

### The one finding I DISPROVED (do not act on it)
- **"F1 spin under g_sched_lock deadlocks when the poller is a separate thread"** — FALSE ALARM. A PARKED task
  (yield_runnable=0) sets `park_committed=1` LOCK-FREE at nova_runtime.c ~6921 (the `if (yield_runnable)` enqueue
  is SKIPPED for parked tasks). The poller only ever spins on parked io/sleep/offload waiters → their commit is
  lock-free → the spin completes no matter who holds g_sched_lock. NO deadlock. (The F1-spin-under-lock is still
  the plan's deferred #5 SERIALIZATION ceiling — measure it in the soak; restructure ONLY if /ping < 1.0×.)

### The REAL, fixable blockers (R1–R9) — implement IN THIS ORDER, gate after the lock work:
- **R3 (spec):** the poller is a SEPARATE OS thread (like the watchdog at main_dispatch ~7062); the MAIN thread
  still runs carrier 0's `nova_rt_sched_run`. State this explicitly before coding.
- **R4/R5 (CV correctness — the real lost-wakeup):** `nova_carrier_idle_wait` MUST do `LOCK d; while(d->count==0
  && !shutdown) SleepConditionVariableCS(cv,&d->lock,ms); UNLOCK` — the re-check + atomic-unlock-on-sleep is the
  mechanism; the 10ms cap is only a backstop. The signal in `nova_carrier_enqueue` MUST be raised while/just-after
  holding the deque lock (a signal raised between the carrier's count-check and its wait is LOST).
- **N=1 init/gating:** gate `idle_wait`/cv on `g_carrier_count>1 && single_poller_mode`; the cv field is
  BSS-zero at N=1 (nova_deque_init_all only runs under ncar>1) — confirm zero-init CONDITION_VARIABLE/pthread_cond_t
  is NEVER touched at N=1. Verify N=1 reconverge gen5.ll==gen6.ll (struct-layout change to NovaCarrierDeque).
- **R6 (shutdown — orphaned tasks + stranded sleeper):** set `g_poller_stop` (or a `g_no_new_waits`) BEFORE
  carriers check root-exit, else the poller enqueues to an already-exited carrier (task never runs). Poller does a
  FINAL DRAIN (wake_sleepers/check_offload) after its loop, else a parked `sleep(100)` with an early root-exit
  never wakes (violates sleep(ms)>=ms). Do NOT signal CVs after carriers return — use a `g_sched_shutdown` flag
  carriers test in the idle branch (signalling a dead-thread CV is UB).
- **R7 (break-fd):** UNCONDITIONALLY add g_break_rd to rfds + check FD_ISSET; TCP_NODELAY on the Win32 loopback
  write end; micro-test "kicked poller wakes <1ms".
- **R8/R9 (fallback):** break-fd init fail → single_poller_mode=0 → carriers poll as today (no NEW hang); no
  half-initialized state.

### Why a fresh session (the review's words, endorsed): it edits the single most dangerous runtime region
(g_sched_lock/F1/park-commit — multiple prior failed attempts, stabilized only by 71a651d); the oracles are LONG
and must be REPEATED (a probabilistic deadlock/lost-wakeup needs many clean green_scale N=4×70/N=8×50 + ASAN runs,
not one lucky pass); N=1 byte-identity is a hard reconverge gate; and the failure mode is a FROZEN 24/7 server —
the worst outcome for the Forge mission. Tail-of-session time pressure directly conflicts with "run it many times."

### Oracles (ALL must pass, REPEATEDLY, with NOVA_SCHED_WATCHDOG on):
green_scale N=4×70 + N=8×50; ASAN on green_scale N=4; forge_load_soak /ping ≥ 1.0×; green_netpoll;
N=1 reconverge gen5.ll==gen6.ll + full regression both modes; micro-tests (kick<1ms, sleep-honored-across-root-exit).
