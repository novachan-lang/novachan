# Green-Task Reclamation ("Tombstone Split") — Design & Safe Plan

**Status:** DESIGNED (2026-06-21), read-only analysis + safe measurement complete; implementation pending careful gated build.
**Origin:** the "millions of processes / growable stacks" goal. A read-only multi-agent analysis + adversarial review
(workflow wf_81331e2c) REFRAMED the problem; a safe, memory-capped measurement campaign confirmed the verdict.

## The reframing (what the analysis found)
The naive premise "green stacks are a fixed 32KB → need growable stacks" is **largely a misdiagnosis**:
- Fiber stacks are ALREADY lazy-commit. **Windows**: `CreateFiberEx(commit=4096, reserve=PE-default ~1MB)` — the 1MB
  is *virtual address space*, NOT RAM; only touched pages commit. Overflow is caught by the `__try/__except` in
  `nova_fiber_entry` (clean crash, NOT an OS crash). **POSIX**: `mmap(32KB + guard page)` demand-zero. `NOVA_FIBER_STACK_SIZE`
  is now only the opt-in depth guard.
- So **alive-at-once is RAM-bound at a few KB/task, not 1MB/task** — millions-alive is already feasible by commit.
- The **REAL gap is over-time / churn**: green tasks are **NEVER freed** (verified: the finish path nova_runtime.c
  L6288–6314 frees nothing — no DeleteFiber, no munmap, no free(NovaFiber), mailbox kept). A long-running server
  (Forge) that spawns a task per request grows **unbounded**. This is the #1 production blocker.

## Safe measurement (memory-capped, kill-on-timeout, single-carrier, compute-only — zero OS-crash risk)
Tool: `_safe_scale_run.ps1` (Private-Bytes watcher; `taskkill /F /T` if >2GB cap or >60s; the only kill proven to
work on this machine). Test: `green_scale_test.nova` (phase 1 = n fan-in, phase 2 = n parked-then-woken), n knob only.
| n | tasks spawned (2 phases) | peak Private Bytes | wall |
|---|---|---|---|
| 10000 | 20000 | 321 MB | 296 ms |
| 20000 | 40000 | 734.6 MB | 564 ms |
| 35000 | 70000 | 1407.6 MB | 709 ms |
- **Linear** scaling: marginal ~41–45 KB per "n-unit" (= 2 tasks + 1 channel), no super-linear blowup. Sub-linear time.
- **70,000 green tasks across 2 phases run clean** — alive-at-once scale is real; hundreds of thousands feasible by RAM.
- **~half the peak is phase-1's finished-but-never-freed tasks** — the never-freed problem is empirically visible.
- Safety: peak 1.4GB stayed far under the 2GB cap and the 16GB machine; the watcher was validated on the known-good
  n=10000 first. n=50000 was NOT run (extrapolated ~1.93GB, too near the 2GB cap) — stopped at the safe ceiling.

## The fix — "Tombstone Split" (BEAM's cheap-process-table / expensive-stack model)
At task finish, free the EXPENSIVE per-task resources but keep the TINY, PID-bearing `NovaSchedTask` as a stable,
UAF-safe tombstone (so `monitor()`, `exit_reason()`, late `pid_send` all stay valid).

**v1 (conservative, high-value, lower-risk) — free the fiber only:**
At BOTH finish paths (`sched_run` ~L6288-6314 AND `ws_worker_loop` finish ~L6560), AFTER exit_status/exit_reason are
copied into `t`, monitors notified, mailbox drain-closed:
- Windows: `DeleteFiber(fib->handle)`; POSIX: `munmap(fib->stack_mem, fib->stack_alloc)`.
- `free(fib)` (the NovaFiber), then `t->fiber = 0`.
- KEEP `t` (NovaSchedTask, ~144B — the PID) and the mailbox channel (~256B) alive.
This reclaims the dominant cost (the committed touched stack, ~8-20KB/task) → ~50x less retained per finished task.
The mailbox late-send hazard is AVOIDED by keeping the (drain-closed) mailbox — a later `pid_send` still hits
`channel_send`→closed→rc_dec→-1 (graceful), exactly as today.

## Hazards to VERIFY before/while implementing (UAF-sensitive — this is why it's a careful standalone change)
1. **DeleteFiber must run from the CARRIER, on a NON-running fiber.** At L6288 `nova_rt_fiber_resume` has returned and
   the fiber switched back (nova_sched_current=NULL) — so `fib` is dead and DeleteFiber from the carrier is legal.
   NEVER DeleteFiber from within the fiber. (CONFIRMED safe at this point.)
2. **exit info lives in `t`, not `fib`** — CONFIRMED: L6293/6303 store exit_status/exit_reason into `t` (NovaSchedTask).
   But L6291-6298 READ `fib->task.crashed`/`error_msg` first — so free `fib` only AFTER those reads (after L6311). The
   error_msg string: if it lives on the fiber's heap/arena, copy it into `t` BEFORE freeing fib (verify ownership).
3. **PID == `t`?** VERIFY `nova_rt_sched_spawn` returns the NovaSchedTask ptr (not the fiber), and `monitor()`
   (L7320, casts proc_handle→NovaSchedTask in green mode) + `exit_reason()` read `t`. If any consumer holds `t->fiber`,
   it must guard on `t->finished` (which is set, and t is kept).
4. **No `t->fiber` deref after finish** — grep ALL `->fiber` / `t->fiber` uses; any post-finish deref must check
   `t->finished`/`t->fiber != 0` first. Set `t->fiber = 0` after free so a stale deref is a NULL (catchable), not a UAF.
5. **Generators vs scheduler tasks** — `is_task==0` fibers (lazy generators) have a DIFFERENT lifecycle (resumed by
   their task, not the carrier). The reclamation must apply ONLY to `is_task==1` scheduler-task finishes at this path;
   do not free generator fibers here.
6. **Both finish paths** — sched_run AND ws_worker_loop must get the identical reclamation, or one path leaks.
7. **M:N (N>1)** — default N=1 is the validated path; the reclamation runs on the carrier after switch-back, same as
   the existing finish work. Keep N=1 for the gate; the yield_runnable double-resume race is a separate pre-existing item.

## Validation (the oracle) — SAFE, bounded, no machine risk
- Full gate: reconverge gen5.ll==gen6.ll + regression 549 BOTH modes + ASAN (catches any finish-path UAF).
- A NEW bounded reclamation test (safe BECAUSE reclamation bounds memory): spawn+finish N tasks in a loop (e.g. 50k
  total over time, but only a few alive at once), run under `_safe_scale_run.ps1` (2GB cap), assert peak stays FLAT /
  bounded (not growing with total-spawned). On the CURRENT runtime this test would grow unbounded (so it doubles as the
  before/after proof). Keep it under the cap + kill-on-timeout.
- DO NOT churn-test the current (pre-fix) runtime unbounded — that is an intentional OOM.

## Explicit DO-NOT (from the adversary)
- Do NOT shrink the Windows fiber reserve (the deeply-recursive self-hosted compiler runs on a fiber — L5128-5129 — a
  small explicit reserve overflows it and breaks the bootstrap). The PE-default reserve is by design.
- Do NOT free the mailbox in v1 (late pid_send → UAF). Keep it (cheap, drain-closed). Lazy-mailbox / mailbox-reclaim is a
  separate future refinement.
- Do NOT enable NOVA_CARRIERS>1 during this work. Do NOT run unbounded churn on the pre-fix runtime.
- POSIX uncontained stack-overflow (no SIGSEGV/sigaltstack handler — verified) is a SEPARATE correctness item for
  non-Windows; do not fix it under this change.

## ★ N>1 RECLAMATION — ATTEMPTED + REVERTED (2026-06-21): a real reclaim-vs-completion race
After the M:N park-commit race fix (485ed40) made N>1 corruption-free, I tried enabling reclamation at N>1
(removed the g_carrier_count<=1 gate + added a watchdog-TOCTOU guard). It PASSED N=1 + N=4-normal + N=4-green_scale,
but **ASAN at N=4 caught a heap-use-after-free** (nova_task_arena_cleanup, nova_runtime.c:5064) and I REVERTED.
- The race (from the ASAN backtrace): carrier T4 freed fiber F via nova_sched_reclaim_fiber (finish path,
  done==1) WHILE carrier T2 was still executing F's OWN completion code -- nova_fiber_entry -> nova_task_arena_cleanup
  -> read F->task.active_arena. So a fiber's teardown (arena cleanup at L5104, which runs BEFORE f->status=3 at
  L5106, on the fiber's own stack) is NOT atomic w.r.t. another carrier observing done==1 and reclaiming F.
- WHY the park-commit fix + the f->active double-resume guard did NOT catch it: this is NOT a resume race (no
  SwitchToFiber onto F by two carriers). It is a TEARDOWN race -- F's bottom frame (nova_fiber_entry) is still
  running its completion sequence (cleanup; status=3; SwitchToFiber-back) when a reclaim observes F finished.
  The NovaTaskState is EMBEDDED in the NovaFiber, so free(fib) frees the task state the completion code is reading.
- THE FIX a future careful session must do (NOT a quick gate removal): reclaim a fiber ONLY after it has FULLY
  exited its completion path and switched back -- i.e. the reclaim must be sequenced strictly AFTER the fiber's
  final SwitchToFiber-to-carrier has returned control to the reclaiming carrier, with a happens-before that no
  OTHER carrier can free it in between. Options: (a) move arena_cleanup + status=3 BEFORE the body so the
  bottom frame touches nothing after status=3; (b) a per-fiber "exited" flag set as the LAST act before the
  switch-back, with reclaim gated on it; (c) only the carrier whose fiber_resume(F) returned done==1 may reclaim F
  (verify no second carrier ever holds F at that point). Must be ASAN-validated at N=4 + NOVA_SCHED_WATCHDOG=1.
- STATUS: N>1 reclamation is DEFERRED. N>1 keeps the old never-free behavior (a memory leak under churn at N>1,
  but N>1 also has the lock-convoy liveness limit, so it is not production-ready regardless). N=1 reclamation
  (the default, the high-value case) is shipped + sound (179126e). This is the right scope: do NOT ship a UAF for
  an opt-in mode.

## ★★ N>1 RECLAMATION — DEEPER ANALYSIS (2026-06-22): DEFER (rigorous 5-agent verdict)
A read-only multi-agent analysis + adversary nailed the root cause AND why a quick fix is the WRONG move:
- ROOT CAUSE of the UAF: the f->active double-resume guard is BYPASSED by the early-return `if (f->status==3)
  return 1` (nova_runtime.c L5137) -- it returns done==1 WITHOUT the CAS. And the fiber sets f->status=3 (L5106)
  BEFORE its final SwitchToFiber-back (L5112), so during that window a 2nd carrier sees done==1 and reclaims while
  the fiber is still running its own completion (arena_cleanup). PLUS a 2nd UAF surface: the finish path reads
  fib->task.crashed/error_msg (L6341/6346) from a possibly-freed fib.
- THE DISEASE (not the symptom): for a 2nd carrier to get the task at all, the task must be DOUBLE-ENQUEUED. The
  analysis could NOT pin the double-enqueue statically (run-queue is single-locked + park_committed discipline on
  every wake path + a double-push detector) -> it is likely the documented N>1 lost-wakeup at high oversubscription
  ([[project-mn-scheduler-step1]]). ★ KEY INSIGHT: fixing ONLY the UAF (a body_exited flag) MASKS the double-enqueue
  -> the task is still processed twice -> double nova_live_dec (live-count goes negative -> premature termination),
  double monitor-notify, double mailbox handling -- SILENT corruption instead of a loud ASAN catch. STRICTLY WORSE.
- A SOUND fix is a scheduler-protocol change, not a one-liner: (a) carrier-side status publish, (b) atomic
  single-owner reclaim (InterlockedExchange64, not a racy CAS comparand), (c) move fib->task crash-capture INTO the
  fiber, (d) the same on the unguarded POSIX ucontext path, (e) watchdog TOCTOU, (f) an EXPLICIT memory barrier
  (bare `volatile` gives NO inter-thread ordering -- latent weak-memory bug on NOVA's future ARM/RISC-V targets).
- VERDICT = DEFER. Re-enable N>1 reclamation as part of the M:N production-promotion: per-carrier work-stealing
  deques (replaces the global g_sched_lock convoy) give a NATURAL single-owner-per-task invariant -> reclamation
  becomes trivially safe and the body_exited dance is unnecessary. Hunt the double-enqueue root cause FIRST; add a
  per-task once-finished assert to the validation. Cost of deferral is bounded: ~368B + stack per finished task at
  N>1 ONLY, freed at process exit. N=1 (the only production mode -- Forge, all tests/benchmarks) reclaims correctly
  + race-free already (179126e). DO NOT fix piecemeal.

## Honest payoff
v1 turns "unbounded growth per spawned task, forever" into "~400B tombstone per finished task + reclaimed stacks" —
unblocking long-running servers (Forge/WebSocket) from ~100k toward ~10M+ tasks OVER TIME. Full reclamation (mailbox +
the tombstone itself, via a generation/epoch scheme) is the follow-on.
