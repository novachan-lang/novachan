# Per-Carrier I/O — breaking the g_sched_lock ceiling so N>1 scales I/O throughput

> **Why:** the deep keep-alive soak (server SATURATED) proved NOVA's I/O throughput REGRESSES at N>1:
> keep-alive /ping N=1 = 29,941 rps, N=4 = 0.82×, N=8 = 0.76× (bad=0). Compute scales (/cpu 6.1×@8). The
> bottleneck is the GLOBAL `g_sched_lock`: every io park (`nova_sched_park_io_ex` links the global
> `nova_io_waiters` under the lock), every io wake (the single poller's drain unlinks+enqueues under the
> lock), and every handler spawn (`nova_rq_push` under the lock) serialize. At 30k+ rps the cross-thread
> coordination costs more than the parallelism buys for cheap requests, so N=1 (no lock, no poller thread)
> wins. **The accept/poller (S-a+S-b+S-c, committed) is correct and a cleaner architecture, but it does NOT
> break this ceiling** — S-a's single poller is itself a single-thread funnel + still uses `g_sched_lock`.
>
> **Goal:** make the I/O path PER-CARRIER (the Go per-P netpoller / nginx-worker model) so N carriers handle
> N disjoint connection-sets in parallel with NO global lock on the hot io path. Target: keep-alive /ping
> scales toward Ncore (N=8 ≥ ~4-6×, not 0.76×).
>
> **STATUS: DESIGN ONLY — not implemented. The most dangerous code in the runtime; implement as a focused,
> staged, gated campaign (PC-1 → PC-2 → PC-3), each stage proven on the keep-alive soak + green_scale + ASAN
> before the next. Soundness #1: a subtle lost-wakeup here freezes a 24/7 server.**

## The model
A connection lives ENTIRELY on ONE carrier — accept → handler → recv/send → wake — so its io never crosses a
thread boundary and never touches a global lock. Concretely:

1. **Per-carrier io-waiter lists.** Replace the single global `nova_io_waiters` with `g_carrier_io[NCAR]`
   (one list head per carrier). `nova_sched_park_io_ex` links onto the CURRENT carrier's list. Because a task
   is PINNED (home_carrier, fixed at first run — 71a651d), it always runs on, parks on, and is woken on the
   SAME carrier → that carrier is the SOLE accessor of its own io list → **no lock needed on the io list**
   (owner-only), or at most a per-carrier LEAF lock (never the global).

2. **Per-carrier polling.** Each carrier, when idle, `select()`s over its OWN io list's fds and wakes its OWN
   ready tasks (re-enqueue to its OWN per-carrier deque — leaf lock, no global). This REVERTS S-a's single
   poller for the io path, but the old thundering herd does NOT return: the lists are DISJOINT (each carrier
   polls only its own fds), so there is no contention and no global-lock fight — the exact thing S-a was
   trying to avoid is gone for free once the lists are sharded.

3. **Connection pinning.** The acceptor (one per carrier, S-c) that accepts a connection spawns the handler
   PINNED to ITS OWN carrier (`sched_spawn_on(self_carrier, ...)` instead of unbound `sched_spawn`). So every
   recv/send of that connection parks on the acceptor's carrier's io list → that carrier polls + wakes it.
   Connections distribute across carriers by which acceptor accepted them.

## The Windows obstacle (the one real wrinkle) + its answer
Linux has `SO_REUSEPORT` (N listeners bound to one port, kernel load-balances) → each carrier accepts on its
OWN listener fd → zero accept contention. **Windows has no SO_REUSEPORT**, so the listener is a SINGLE shared
fd. With per-carrier polling, the shared listener fd ends up in every carrier's io list → all carriers poll it
→ a connection wakes all N → accept herd. BUT: for KEEP-ALIVE traffic (the throughput case — the bottleneck is
recv/send, accept is ~1 per connection then reused for M requests), the accept herd is RARE and cheap; the io
(recv/send, per-carrier) is the bulk and scales. So:
- **Windows:** keep S-c's shared-listener + wake-one for accept (a single authoritative accept point or the
  exclusive wake-one), but pin the accepted handler to a carrier (round-robin or accepting-carrier) so its io
  is per-carrier. Accept stays mildly serialized (fine for keep-alive); recv/send scale.
- **Linux (later, the cross-platform track):** SO_REUSEPORT → N listeners → accept also fully parallel.

## Staging (smallest-risk-first; each gated; N=1 byte-identical; reverts independently)
- **PC-1 — shard the io list + per-carrier poll.** `g_carrier_io[NCAR]`; `park_io_ex` → current carrier's
  list; each carrier polls its OWN list in its idle branch (replacing S-a's single-poller path for io, gated
  `g_single_poller_mode`). Sleep/offload waiters: keep global for now (low rate) OR shard too. **Gate target:
  no regression + no herd (disjoint lists). green_scale + ASAN must stay clean; keep-alive /ping must not get
  WORSE than S-a.** This is the structural change; prove it neutral before chasing the win.
- **PC-2 — pin the handler to its carrier.** `_acceptor` spawns the handler with `sched_spawn_on(self, ...)`
  so the connection's recv/send live on the accepting carrier → its io is on that carrier's list. **Gate
  target: keep-alive /ping SCALES (N=8 ≥ ~3-5×). THE win.** If it doesn't scale, the remaining ceiling is the
  shared-listener accept or the sleep/offload global — diagnose before PC-3.
- **PC-3 — accept de-contention (only if PC-2's soak shows accept is the residual ceiling).** Windows: a
  single authoritative accept loop that round-robin-assigns + pins; or batched accept. Linux: SO_REUSEPORT.

## Hazards (for the adversarial review to attack)
1. **Migration breaks the owner-only invariant.** The whole no-lock claim rests on PINNING: a task parks on
   the carrier it runs on and is woken there. If a task can run on a DIFFERENT carrier than where its io
   waiter lives, the io list gets cross-carrier access → UAF/lost-wakeup. The no-migration pinning (71a651d)
   must hold for EVERY task that does io. Verify: can a pinned task's io waiter ever be touched by another
   carrier? (e.g., a waker on a different carrier, a shutdown sweep.)
2. **The shared listener in N lists.** N acceptors park on one listener fd across N io lists → N carriers
   FD_SET it → on a connection, N wake → accept herd. Bounded for keep-alive, but quantify; and ensure
   wake-one still applies per-carrier (or accept the herd).
3. **Sleep/offload waiters.** If they stay GLOBAL (under g_sched_lock) while io goes per-carrier, do they
   reintroduce the lock on the hot path? (Sleep/offload are low-rate, so probably fine — but a server with
   timed-recv/keepalive-deadline reads parks on a TIMED io waiter — is that per-carrier too?)
4. **Cross-carrier wake paths.** Channel sends, monitor/DOWN, the offload-completion reaper — these wake a
   task on its home carrier (already pinned). With per-carrier io, does any waker need the target carrier's io
   list? (It should only need the deque, which is already per-carrier + leaf-locked.)
5. **Shutdown.** Each carrier owns its io list → on root-exit each carrier must drain/abandon its own io
   waiters; no single poller to join. Ordering vs the carriers exiting.
6. **N=1 byte-identical.** At N=1 there is one carrier → one io list == the old global list, one poller ==
   inline poll. Must compile to the same path (gated). The N=1 keep-alive number (29,941 rps) must NOT drop.
7. **find_tag / value model:** io waiters are internal C structs (not NOVA heap objects) → unaffected. The
   per-carrier arrays are static C → no value-model interaction. Confirm.

## Oracles (every stage, repeated, NOVA_SCHED_WATCHDOG on)
green_scale N=4×70 + N=8×50 + ASAN; keep-alive soak (_ka_run.ps1) /ping rps at N=1/4/8 (PC-2 must show
N>1 > N=1); /cpu still ≥ today; green_netpoll; N=1 reconverge gen5.ll==gen6.ll + regression both modes; bad=0.

## Key sites
runtime: `nova_io_waiters` (global, → shard); `nova_sched_park_io_ex`; `nova_sched_poll_io` /
`nova_poller_thread` (single poller, → per-carrier); the carrier idle branch in `nova_rt_sched_run`;
`g_carriers[64]` (add the io-list head); `nova_carrier_enqueue` (the wake target). forge: `_acceptor`
(sched_spawn → sched_spawn_on(self)).

## ADVERSARIAL REVIEW RESULTS (2026-06-26, wf w31dn6cg7 — 4 lenses + synthesis) — VERDICT: SOUND, staging RIGHT, DEDICATED SESSION REQUIRED
The design's CORE is validated: **pinning→owner-only is SOUND** (a pinned task parks/runs/wakes on the same
carrier, so its io list has a single accessor), and **leaving sleep/offload GLOBAL does NOT re-introduce the
ceiling** (low rate). The staging order PC-1 → PC-2 → PC-3 is correct. But four items are **PC-1 PREREQUISITES**
(must be in the first cut, not deferred), and the implementation is a **dedicated, focused, gated session of its
own — "not something to fold into another task"** (it has real UAF + deadlock vectors that are N>1-ONLY and
INVISIBLE to the default regression + the N=1 baseline — the same shape as the migration-wedge that ate a session,
fixed only by pinning, 71a651d).

### RC-1 — BIGGEST RISK (silent UAF / lost wakeup, N>1-only). MUST fix in PC-1.
An UNBOUND task (home_carrier=-1) that parks io before its carrier is fixed — the **DNS-offload `tcp_connect`
path** is the concrete vector — can have its io waiter on carrier A's list while the task is later re-enqueued to
carrier B → B touches A's list → UAF / lost wakeup. The no-lock claim assumes home is fixed BEFORE any io park.
**Fix: pin-at-spawn for any io-capable task (set home_carrier at spawn, not just on first global-pop), AND a hard
assert in `nova_sched_park_io_ex`: `if (g_carrier_count>1) assert(t->home_carrier>=0)` so any violation fails LOUD
at N>1 instead of corrupting silently.** (My pre-review reasoning was that the global-pop claims home before a
task runs+parks; the review's offload-connect counterexample makes the assert mandatory regardless — defense that
turns a silent corruption into a deterministic crash.)

### RC-2 — shutdown deadlock vector. MUST fix in PC-1.
PC-1 removes/repurposes the single poller, but the current shutdown sets `g_poller_stop` + JOINS the poller
(~7233/7247). With no single poller that hangs. Re-derive: set `g_sched_shutdown` → wake all carriers → each
carrier DRAINS ITS OWN per-carrier io list on exit → join carriers. No poller join. Add a per-carrier
shutdown-drain test.

### RC-3a — hybrid listener (PC-1, deliberate). Full per-carrier listener → PC-3.
Windows has no SO_REUSEPORT, so keep the LISTENER centrally polled (the existing global wake-one path) and shard
ONLY the per-connection io (recv/send/connect/**timed-read**). This captures essentially all the keep-alive win
(hot path is recv/send) and is honest about the platform. Document it as a *deliberate centralized special case*.
PC-3 promotes to a true per-carrier listener via SO_REUSEPORT on the Linux track.

### Two binding staging amendments
1. **PC-1 MUST shard timed-io too** (`nova_sched_park_io_timeout`, deadline>0 — keepalive/timeout reads), else
   PC-2's soak measures a ceiling PC-1 was supposed to remove.
2. **PC-1 MUST ship RC-3a (hybrid listener)** so accept is bounded BEFORE PC-2 measures throughput.
PC-2 = "prove it scales / no herd" (the win gate); PC-3 = per-carrier listener (Linux) + accept de-contention.

### Dedicated-session checklist (run with kill-on-timeout on EVERY binary):
the 4 RC fixes designed up front; owner-only + lock-order invariants written as ASSERTS; a per-carrier
shutdown-drain test; a DNS-offload-at-N>1 stress test; the keepalive-timeout-not-global check; `gen5.ll==gen6.ll`
+ the 29,941-rps N=1 baseline re-measured BEFORE PC-2; green_scale N=4×70/N=8×50 + ASAN each stage.

### Load-bearing sites (confirmed present; `g_carrier_io` confirmed ABSENT = design unbuilt):
`nova_io_waiters` decl (~5689), `park_io_ex` (~6042), `park_io_timeout` (~6090), `poll_io` deadline scan +
`excl_woken[16]` (~6152-6275), `sched_run` idle poll branch (~6873-6884), `poller_thread` (~7080-7104), shutdown
poller-join (~7233/7247), `tcp_close` waiter purge (~11149-11179).
