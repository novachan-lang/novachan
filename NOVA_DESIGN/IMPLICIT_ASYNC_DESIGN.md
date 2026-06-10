# NOVA Flagship: Implicit Async / No-Function-Coloring Scalable I/O — Design Blueprint

**Status:** DESIGN COMPLETE (2026-06-05). Validated by an 11-agent design workflow (6 runtime
studies + 3 NOVA-runtime maps + runtime-designer synthesis + devils-advocate stress pass).
Implementation is a multi-session effort (~6–12 months solo, honest estimate). This doc is the
durable foundation — read it before any implementation stage.

**IMPLEMENTATION PROGRESS:**
✅✅ **VERIFIED STATE 2026-06-10 (against real code + full test run, not memory).** Stages 0, 1, 1.5,
2a, 2b(work-stealing), 3(netpoller), 4(socket I/O parking) are ALL implemented and PASS:
- 23/23 concurrency tests pass (fiber, sched, ws_sched, spawn×6, bounded_chan, select×2, monitor×3,
  green_monitor, green_supervisor, supervisor, supcrash, atomicx, parallel, async, t8_channel).
- green_netpoll_test passes (green echo server + concurrent accepts) — socket I/O parks on the poller.
- **green_scale_test (committed db6a859): 10,000 green tasks incl. 10,000 simultaneously PARKED, ~382ms**
  via the TRANSPARENT path (no async keyword, no sched_run; main auto-wrapped). The headline gate met.
- All of the above STILL pass after the value-model overhaul (commits 8da4b0c/0bf015f).
**The ONE genuine v1 gap: cooperative/involuntary PREEMPTION for CPU-bound green tasks** (no `preempt`
flag exists; no user-facing scheduler-yield). This pits two NOVA non-negotiables against each other —
"zero-ceremony/compiler-is-genius" (→ automatic preemption) vs "beat C" (→ no per-loop/per-call hot-path
tax). The doc's fn-entry plan (Stage 6 below) is INSUFFICIENT (C8: doesn't fire in builtin-only tight
loops) AND taxes every call. Real options: loop-back-edge auto-preempt (taxes GATE 4/5 hot loops — must
measure) vs signal-based async preempt (correctly post-v1). Decision pending. Remaining post-v1
(unchanged, intentional): growable stacks, async/signal preemption, DNS/file→offload, tcp_connect park.

✅ **Stage 0 COMPLETE (2026-06-05, commits 3cdf3f4 + 21fd822).** Both fatal TLS issues fixed —
error state (0a) and fault boundary (0b) now per-task in NovaTaskState via nova_cur(). GO/NO-GO
passed (byte-identical, 255/255, perf-neutral).

✅ **Stage 2a CORE WORKING (2026-06-05).** The M:N green-task scheduler runs: `sched_spawn(closure)`
creates a green task (a Stage-1 fiber), `sched_run()` is the single-carrier loop that drives them
cooperatively, and channel `recv` PARKS a green task (yields to the carrier) instead of blocking the OS
thread — `send`/`close` unpark it. Single-carrier + cooperative ⇒ no lost-wakeup race (F1's hard case is
2b-only). Validated by sched_test.nova: producer/consumer with parking, two-channel ping-pong, and
**1000 green tasks coordinating on ONE OS thread** (the no-thread-per-task win). NovaChannel gained a
`green_waiters` list; channel_recv/send/close got green branches; the scheduler is ~90 LOC over the
fiber primitive. Non-green code is unaffected (the green branch is gated on `nova_sched_in_task()`).
**This is the explicit-API core; the remaining Stage 2 work is: reroute `spawn`→green + wrap `main` as a
green task (transparency), send-side bounded-channel parking (F3), monitor/wait_all integration, then
2b work-stealing across N carriers.**

✅ **Stage 1 COMPLETE (2026-06-05).** Green-task context-switch primitive validated:
- **Windows:** Fibers API (CreateFiber/SwitchToFiber) — OS manages stacks + register save.
- **POSIX x86_64:** hand-written asm (push/pop RBX/RBP/R12-15, save/restore RSP, retq) + mmap
  stacks with mprotect guard pages.
- **35ns per context switch** (measured, 20000 switches; target was <200ns).
- **1000 round-trips** verified (1001 resumes for 1000 yields + finish).
- **Fault boundary on green stack** works: panic in a fiber longjmps to the per-fiber setjmp in
  the trampoline; the fiber is marked finished; the carrier resumes. Validated by panic test.
- **Interleaved fibers** correct: two fibers yield and resume in alternation (a1, b1, a2, b2).
- **Per-fiber NovaTaskState** + reduced stack-depth limit in trampoline.
- VEH installed for hardware stack overflow (EXCEPTION_STACK_OVERFLOW → _resetstkoflw + longjmp).
  Known v1 limitation: deep recursion that exhausts the 32KB stack before the software check
  fires can hang the VEH's longjmp on the exhausted stack; practical for v1 since normal code
  stays well within the ~128-frame software limit.
- New builtins: fiber_create(closure), fiber_resume(handle), fiber_yield(), fiber_is_done(handle).
- Test: fiber_test.nova (7 cases: basic, yield, multi-yield, 1000-trips, perf, panic, interleaved).
NEXT: Stage 2 (M:N scheduler).

## The goal
A NOVA Process that does blocking-LOOKING I/O (`tcp_recv`, `channel_recv`, `accept`, …) must
**yield cooperatively** so one OS thread can drive thousands of Processes — scaling to **100k+
concurrent I/O tasks** — with **NO `async`/`await` keyword and NO function-signature change**
(no function coloring). This is the killer differentiator vs Rust/JS/Python/C#, all of which
suffer coloring because they chose stackless coroutines.

## The decision: stackful virtual processes (M:N) + a netpoller
Every runtime that achieves no-coloring at 100k scale — **Go** (goroutines+netpoller), **Java
Loom** (virtual threads+continuations), **Erlang BEAM** (schedulers+dirty-threads) — uses
**stackful tasks multiplexed M:N onto OS carrier threads, with I/O suspension INSIDE the runtime
primitive**. Every runtime that chose **stackless** (Rust/tokio, asyncio, C#, old Zig) was forced
into coloring: stackless = the compiler rewrites the function into a state machine, which changes
the return type, which infects callers transitively. NOVA's law ("simpler than Python, no
ceremony") forbids coloring → **stackful is the only option**.

NOVA is in a *favorable* position vs Go/Loom:
- **Deep-copy process isolation** eliminates the monitor-pinning bug class that cost Loom 3 JDK
  releases (no shared mutable state → no monitor-ownership problem).
- **Bounded channels** already give the back-pressure primitive Go lacks (Go's unbounded
  goroutine fan-out is its #1 OOM vector).
- **LLVM-native** → the context switch is a direct register/SP swap (tens of ns), not a JVM
  continuation copy.

## The no-coloring mechanism (how it actually works)
`tcp_recv(sock)` keeps signature `(int64 sock) -> int64`. Inside `nova_rt_tcp_recv`: socket is
`O_NONBLOCK`; `recv()` returns `EAGAIN`; the runtime calls `nova_task_park(current_task,
PARK_IO_READ, fd)` which **saves the task's register context (SP/PC/callee-saved) into its NovaTask
struct** and returns control to the carrier's scheduler loop, which restores the next runnable
task. The netpoller (epoll/kqueue/IOCP) later sees the fd ready and `nova_task_unpark`s it; the
carrier restores its context, execution **resumes inside `nova_rt_tcp_recv` right after the park**,
retries `recv()`, returns data. Because the task is **stackful**, the park can happen at ANY call
depth (`tcp_recv` ← `http_get` ← `fetch` ← `main`) — the whole stack parks as a unit, and **no
function in the chain needs a marker**. Channel ops park identically (`PARK_CHANNEL_RECV`, woken
by the sender). `select` registers the task on all channels, parks once, O(1) wakeup.

## ⚠ TWO FATAL ISSUES the naive "pure runtime migration" framing missed (caught by adversary)
This is **compiler + runtime co-design**, NOT runtime-only. NOVA has **7 thread-local variables**:
`__nova_error_flag`, `__nova_error_msg`, `__nova_is_result`, `nova_fault_buf`, `nova_fault_active`,
`nova_proc_crashed`, `g_stack_depth`. With green tasks multiplexed M:N onto a carrier, multiple
tasks share one OS thread's TLS slots:
1. **TLS error-state leak (FATAL):** task A sets `__nova_error_flag` inside a try, parks on I/O;
   task B resumes on the same carrier and inherits A's flag → silent error-handling corruption.
   The compiler EMITS direct TLS loads/stores (`store i64 1, ptr @__nova_error_flag`, nova_compiler.nova
   ~11822-11840) — so fixing this requires CODEGEN changes, not just runtime.
2. **setjmp/longjmp fault boundary corruption (FATAL):** `nova_fault_buf` is `__thread`. If task A
   sets it, parks, and task B (different green stack) panics → `longjmp` jumps to A's jmp_buf which
   holds a stack pointer into a different/freed stack → process crash, defeating fault isolation.

**Both are solved by the same move:** put all 7 vars in the NovaTask struct, accessed via a
`current_task` pointer; the carrier sets `current_task` before resuming a task. `setjmp` must run
ON the green task's stack (in the trampoline). `nova_panic` reads the jmp_buf via `current_task`.

## Corrected staged plan (each stage gated: precheck → gen4 → reconverge → regression → GATE 4/5)

**Stage 0 — TLS → task-local migration (the SMALLEST, FIRST, de-risking stage).**
This is the real first stage (NOT the netpoller — that proves nothing about green tasks). Define
`NovaTaskState { error_flag, error_msg, is_result, fault_buf, fault_active, crashed, stack_depth }`
+ a thread-local `current_task` pointer to it. Change the ~10 compiler-emitted TLS accesses AND the
~20 runtime accesses to go through `current_task->X`. In the EXISTING thread-pool worker (and main),
set `current_task` before running. **No green tasks yet — behavior is identical** (one task per
OS thread at a time), so ALL tests must pass unchanged AND **GATE 4/5 must stay within tolerance**.
GATE 4/5 are int/float compute (primes/sieve/matmul) that don't touch error flags, so the
indirection shouldn't regress them — but this is the **go/no-go gate for the whole project**: if it
regresses >5%, re-evaluate. Scope: ~200 LOC C + the codegen sites. **This proves task-local state +
the fault boundary + zero perf cost on a proven (existing) runtime before any scheduler risk.**

**Stage 1 — green-task context-switch primitive (per-platform, no scheduler yet).** Hand-written
asm save/restore (x86_64 SysV: RBX/RBP/R12-15/RSP/RIP; Windows x64 also XMM6-15; aarch64 x19-30/SP/LR
+ NEON d8-d15). Guard page per stack (mprotect/VirtualProtect) → stack-overflow as a structured
fault. **On Windows, start with the Fibers API (CreateFiber/SwitchToFiber)** — simpler + proven —
then optimize to raw asm if measurable. Validate: 1000 contexts round-trip; guard-page overflow
caught; switch <200ns; setjmp/longjmp within a green-stack context works.

**Stage 2 — M:N scheduler (split into 2a/2b per the adversary).** 2a: green-task creation +
context-switch + fault boundary, **one green task per carrier** (no work-stealing) — isolates
fault-boundary correctness. 2b: per-carrier chase-lev work-stealing deque + global overflow queue +
the carrier loop (run local → steal → poll netpoller → park on condvar). `spawn` allocates a
NovaTask (+stack) instead of an OS-thread task; API byte-identical. **Keep the old pool as a
blocking-offload pool** (≤256 threads) for file I/O + FFI that can't yield. Gate: ALL existing
spawn/channel/select/monitor/supervisor tests pass unchanged + a 10k-task test under 1s.

**Stage 3 — netpoller** (epoll/kqueue/IOCP, edge-triggered; eventfd/self-pipe/PostQueuedCompletionStatus
wakeup). Standalone, easy, well-trodden — so it comes AFTER the hard correctness stages, not before.
Windows: start with zero-byte-WSARecv readiness emulation (mio/wepoll trick), optimize to native
completion model later.

**Stage 4 — wire netpoller into I/O builtins** (O_NONBLOCK sockets; tcp_recv/accept/connect/send
park on the poller; http composes; **DNS + file I/O → blocking-offload pool**; TLS via
WANT_READ/WANT_WRITE park or offload). Gate: 1000-conn echo server; 100k idle conns <1GB.

**Stage 5 — channel/select integration** (park instead of condvar; select = register-on-all +
park-once + CAS-to-claim against lost-wakeup). Eliminates the current select 1ms spin-sleep floor.

**Stage 6 — fairness/preemption.** **Cooperative preemption at FUNCTION ENTRY from Stage 2 onward**
(`if (current_task->preempt) yield()` prologue, ~2-5ns/call) — NOT deferred, because the 128-I/O-op
budget does nothing for CPU-bound code (which makes zero I/O ops). Signal-based async preemption
(SIGURG/QueueUserAPC/Mach + safe-point maps) is **deferred to post-v1** (Go spent 2014-2020 on it).
Plus cgroup/Job-Object-aware carrier count.

## v1 scope (realistic, ship-worthy)
- **32KB fixed stacks** (≈3.2GB at 100k tasks — fine for servers). **DEFER growable stacks** — the
  copy-and-pointer-adjust is the single hardest piece (Go spent years; needs LLVM stack maps NOVA
  doesn't emit). The "4KB→450MB at 100k" endgame is a 1-2yr compiler effort, post-v1.
- **Cooperative preemption** (fn-entry + I/O yield). Async preemption post-v1.
- Still **far beyond today's 16-OS-thread ceiling**.

## Hardest parts (in order)
1. Growable stacks (copy + pointer-adjust; needs stack maps) — **DEFERRED to post-v1** (use 32KB fixed).
2. Async preemption across platforms — **DEFERRED to post-v1** (use cooperative).
3. Windows IOCP completion-vs-readiness impedance.
4. setjmp/longjmp fault boundary on green stacks (solved by per-task jmp_buf via current_task — Stage 0).
5. FFI/extern-C calls can't yield → pin to carrier or switch to an OS stack (Go's `systemstack`);
   **this is coloring-by-another-name for FFI-heavy code** (a C DB driver caps at ~256 concurrent).
   Document: "100k = NOVA-native I/O, not FFI I/O." Inherent to all green-thread runtimes (Go cgo).

## Known caveats to document
- **Deep-copy at spawn** scales poorly for LARGE closures (100k × 100KB = 10GB; NovaCopyMap is O(n²)).
  Guide users toward lightweight closures (channel handles + scalars). Quantify max practical size.
- **Atomics** are intentionally shared (NOVA_MEM_RAW via rc_inc) — the "no shared mutable state"
  claim is false where atomics are used (opt-in; standard hazards apply).
- **malloc contention** in deep_copy's NovaCopyMap could serialize carriers on the CRT heap lock
  (Go avoids via per-P caches). Consider routing NovaCopyMap allocs through the slab.

## Falsification (what proves this design WRONG)
- Stage 0 regresses GATE 4/5 >5% from the task-local indirection → the whole approach is too costly.
- setjmp/longjmp across green stacks proves unreliable on any platform → need SEH/signal fault model.
- Context-switch + 100k 32KB stacks can't fit/perform on a target server → reconsider.

## Achievability verdict (devils-advocate, honest)
Conditionally achievable. NOT a "pure runtime migration" — it is compiler+runtime co-design. With
32KB fixed stacks + cooperative preemption, the 100k-connection target IS reachable and vastly
better than 16 OS threads. The 4KB-growable / signal-preemption endgame needs 1-2 yrs more compiler
work. **Start with Stage 0 and treat its GATE 4/5 result as the project's go/no-go.**

---

# Stage 2 — M:N scheduler: detailed design (drafted 2026-06-05, grounded in real code)

Stages 0 + 1 are DONE. This is the concrete, code-grounded plan for Stage 2, written after
re-reading the actual concurrency runtime (output/nova_runtime.c). It supersedes the one-paragraph
Stage 2 sketch above where they differ.

## ⚠ THE KEY FINDING: Stage 2 ⊃ channel parking (Stage 5 is NOT separable from Stage 2)
The original staging puts the scheduler (Stage 2) before channel parking (Stage 5). **That ordering
is unbuildable.** Evidence from the real runtime:
- `nova_rt_channel_recv` (nova_runtime.c ~2931) blocks the calling OS thread on a condvar
  (`pthread_cond_wait`/`SleepConditionVariableCS` on `not_empty`) when the channel is empty.
- Existing tests that MUST pass unchanged are channel-driven and block: actorx (a GenServer's
  receive-loop task blocks on recv waiting for requests), supx/supcrash (supervisor blocks on a
  monitor channel), lockx/cmapx/mailx (a server task blocks on its request channel), bounded_chan,
  select_test, async/futurex.
- If `spawn` creates a green task on one of N carrier threads, and that green task calls
  `channel_recv` on an empty channel, the condvar path **blocks the carrier (an OS thread)**, not
  the green task. With N carriers and >N green tasks each blocked on a channel (the GenServer/
  supervisor pattern — there can be thousands), every carrier is stuck on a condvar and the
  remaining runnable green tasks never run → **deadlock**. The 10k-task gate (10k cheap tasks, many
  of them parked on channels) cannot pass on a blocking-carrier model.

**Therefore Stage 2's minimal correct unit = scheduler + channel/wait_all/monitor parking.** A green
task that would block on a channel must *park* (fiber_yield to the carrier's scheduler) so the carrier
runs another task; the counterpart op (send/close) must *unpark* it. Only **socket I/O** parking
(the netpoller, Stages 3-4) stays separable — sockets are a different wait source, and DNS/file I/O
go to the blocking-offload pool. So: **Stage 2 = green scheduler + in-process (channel) parking.**

## Data structures (reusing Stage 0 NovaTaskState + Stage 1 NovaFiber)
```c
typedef enum { TASK_RUNNABLE, TASK_RUNNING, TASK_PARKED, TASK_DONE } NovaTaskStatus;

typedef struct NovaTask {
    NovaFiber        fiber;        // Stage 1: 32KB green stack + saved context + NovaTaskState
    int64_t          entry_fn;     // the spawned closure (already in fiber.entry_fn)
    NovaTaskStatus   status;
    NovaProcessInfo* proc;         // REUSE: monitors[], exit_status, exit_reason, finished
    struct NovaTask* qnext;        // intrusive link for run-queue AND channel wait-list
    int64_t          park_chan;    // channel handle it's parked on (0 if not channel-parked)
    int              park_kind;    // PARK_RECV | PARK_SEND
} NovaTask;

typedef struct {                   // one per carrier OS thread (N = cpu_count)
    NovaFiber  sched_ctx;          // the carrier's own context; tasks fiber_yield back to it
    NovaTask*  current;
    // 2a: shared global run-queue under a mutex. 2b: per-carrier chase-lev deque + steal.
} NovaCarrier;
```
The channel struct (`NovaChannel`) gains a **green wait-list**: `NovaTask* recv_waiters; NovaTask*
send_waiters;` (intrusive, protected by the existing `ch->lock`).

## The carrier loop
```
for (;;) {
  task = run_queue_pop();              // 2a: global mutex queue; 2b: local→steal→global
  if (!task) { if (shutdown && live==0) break; wait_on_work_condvar(); continue; }
  carrier->current = task;
  nova_current_task  = &task->fiber.task;   // Stage 0: repoint per-task error/fault state
  nova_current_fiber = &task->fiber;
  task->status = TASK_RUNNING;
  fiber_resume(&task->fiber);           // switch into the green stack (Stage 1)
  // back here when the task PARKED (fiber_yield) or finished (trampoline set status=DONE)
  if (task->status == TASK_DONE) finalize_task(task);   // exit_status, notify monitors, free
  // if PARKED: it already linked itself onto a channel wait-list; just loop to the next task
}
```
`finalize_task` is exactly today's pool-worker epilogue (nova_runtime.c ~3277-3283 / ~3333-3339):
set `proc->exit_status = crashed?1:0`, `proc->exit_reason`, send to monitors, `finished=1`.

## spawn reroute (API byte-identical)
`nova_rt_spawn(fn, ctx)`: UNCHANGED deep_copy of ctx (isolation preserved). Instead of enqueueing a
`NovaPoolTask` on the OS pool, allocate a `NovaTask` (with a 32KB fiber whose entry runs
`proc->fn(ctx)` inside the per-task setjmp fault boundary — the Stage 1 trampoline already does
exactly this), register `proc` in the process table (unchanged), push the task on the run-queue, wake
a carrier. Return `(int64_t)proc` (unchanged handle).

## Channel park/unpark (the coupled new machinery)
`channel_recv` becomes:
```
lock(ch);
while (ch->count == 0) {
  if (ch->closed) { unlock; return -1; }
  if (on_a_carrier()) {                 // nova_current_fiber != carrier sched_ctx
    cur = carrier->current;
    cur->park_kind = PARK_RECV; cur->status = TASK_PARKED;
    list_push(ch->recv_waiters, cur);
    unlock(ch);
    fiber_yield();                       // -> carrier loop; carrier runs another task
    lock(ch);                            // resumed by a sender's unpark; re-check the loop
  } else {
    cond_wait(ch->not_empty, ch->lock);  // MAIN thread (not a green task): keep blocking
  }
}
val = dequeue(ch); signal/unpark a send_waiter; unlock(ch); return val;
```
`channel_send` after enqueue: if `ch->recv_waiters` non-empty, pop one, set RUNNABLE, push to a
carrier run-queue + wake a carrier (the unpark). It must ALSO `cond_signal(not_empty)` for a possibly
main-thread/pool blocked receiver — **channels have dual waiters (green park-list + condvar), and
every producer must service both.** `channel_close` wakes/unparks all waiters of both kinds.

`select` (today a 1ms busy-poll, nova_runtime.c ~2793): a green task registers on every channel's
recv_waiters, parks once, and the first matching send unparks it (CAS a `claimed` flag to defeat the
lost-wakeup/double-fire race). Eliminates the spin floor. (This is the nominal Stage 5 select work,
pulled in because select must not busy-block a carrier.)

## wait_all (main-thread integration)
Two viable shapes:
- **(b) main blocks on an all_done condvar** while N carriers drain the run-queue; carriers signal
  when the live-task count reaches 0. Closest to today (nova_runtime.c ~4031). If user code parks all
  tasks on channels that never receive (a user bug), wait_all hangs — same failure as today.
- (a) main becomes an extra carrier (convert to fiber, run the scheduler loop until empty). More
  parallelism, more entanglement.
Pick (b) for Stage 2 — minimal change, main stays a plain blocked thread.

## Fault boundary — UNCHANGED from Stage 1, now per-task
The fiber trampoline already does `setjmp(task->fiber.task.fault_buf)` ON the green stack, and
`nova_panic` reads `nova_cur()->fault_buf` (Stage 0b). A panic in a green task longjmps to THAT
task's buf on THAT task's stack; the trampoline marks `crashed`, returns to the carrier, which
finalizes exit_status=1 + monitors. This is the entire reason Stages 0+1 came first; Stage 2 inherits
it for free. ✓

## The 2a / 2b split
- **2a — ONE carrier, global run-queue, channel parking, fault boundary.** No parallelism, no
  stealing. Proves the green-task model + park/unpark + fault isolation + dual-waiter channels in
  isolation. All concurrency tests pass (they run *concurrently but not in parallel* — correctness,
  not speedup). 10k-task test: 10k fibers on 1 carrier, parked/woken via channels, completes <1s.
- **2b — N carriers + chase-lev work-stealing deque + global overflow.** Restores real parallelism;
  pmap/parallel_test regain speedup.

## ⚠ Caveats / risks this design must clear (hand to the adversary)
1. **CPU-bound starvation.** A green task that never parks (pure compute) hogs its carrier until done.
   On 2a (1 carrier) a long compute task blocks ALL others until it finishes — if any test spawns a
   non-terminating-until-signalled compute loop expecting *concurrent* progress with another task,
   2a deadlocks. **Mitigation:** cooperative preemption at fn-entry (`if (task->preempt) fiber_yield`)
   from 2a — the design doc already says "from Stage 2 onward." A periodic timer sets `preempt`.
   MUST audit: does any existing test rely on two compute tasks making progress without yielding?
   (e.g. atomicx_test: 4 tasks × 1000 atomic increments on a shared counter — if those never park,
   on 1 carrier they serialize; correctness holds, the final count is still 4000, so 2a is fine; but
   verify none *spin-wait* on each other.)
2. **Dual-waiter channel races.** Producer must wake condvar AND unpark green waiters atomically
   w.r.t. ch->lock; a wakeup that races a park can be lost. Needs a careful happens-before argument.
3. **pmap/async coexistence.** pmap/pfor/pfilter/async use the OS pool directly (nova_runtime.c
   ~3592, ~8119). Stage 2 reroutes only `spawn`. A green task and a pool task sharing a channel is the
   dual-waiter case — already handled. Keep pmap/async on the OS pool for Stage 2 (don't migrate).
4. **Main thread calling channel_recv directly** (not in a spawn) must keep the condvar path — it is
   not a green task. `on_a_carrier()` gates this.
5. **Deep-copy malloc contention** across N carriers (noted above) — defer; 2a has 1 carrier anyway.

## Falsification for Stage 2
- A channel-blocked GenServer/supervisor test deadlocks under the green scheduler → parking is wrong.
- atomicx/parallel_test produce wrong results → isolation or memory model broke.
- 2b shows no speedup over 2a on parallel_test → work-stealing is broken.
- Any existing concurrency test changes observable behavior → the "byte-identical API" promise failed.

## Honest scope estimate
Stage 2 is the single largest, riskiest stage (it reroutes the spawn path every concurrency test
depends on, and pulls in channel parking). ~400-600 LOC C, no compiler change (spawn/channel builtins
keep their signatures). It deserves a dedicated fresh-context session. Do 2a first, gate hard
(all concurrency tests + 10k-task), then 2b.

## ⚠⚠ Stage 2 ADVERSARIAL REVIEW (devils-advocate, 2026-06-05) — 2 FATAL + 5 SERIOUS
A devils-advocate pass against the draft above (grounded in nova_runtime.c) found issues that the
naive design would have shipped as bugs. **These are now REQUIREMENTS for the Stage 2 implementation.**

**F1 (FATAL) — park/unpark lost-wakeup + double-run race.** The draft's channel_recv does
`list_push(recv_waiters); unlock(ch); fiber_yield();` — the task is VISIBLE on the wait-list BEFORE it
has actually yielded. A sender (another carrier in 2b, or the same carrier after a preemption point in
2a) can pop it, mark RUNNABLE, and a second carrier can `fiber_resume` it WHILE the first carrier is
still executing its stack between unlock and yield → two carriers run one fiber stack = corruption.
`pthread_cond_wait` has no such window (atomic unlock+block). **REQUIREMENT: a `park(unlock_fn)`
primitive à la Go's `gopark` — the task sets park state, switches to the carrier WITH ch->lock still
held, and the CARRIER releases ch->lock only AFTER the context switch completes** (the switch is the
serialization point; the task is not resumable until it has fully yielded and the lock is dropped by
the scheduler, not by the parking task). Unpark never directly resumes — it only enqueues.

**F2 (FATAL) — ✅ RESOLVED 2026-06-05 (commit 9c059e9, "Stage 1.5").** `g_stack_depth` + `g_stack_max`
moved from process-globals into NovaTaskState (stack_depth + stack_max via nova_cur()); also fixed the
pre-existing 16-pool-thread race on the global and the yielded-fiber-leaves-max-lowered leak; removed
nova_fiber_restore_stack. Confirmed stack_enter is NOT auto-emitted per fn-entry (zero hot-path cost).
Gate green (reconverge byte-identical, 258/258, primes neutral). Original finding below for the record:
`g_stack_depth` was a process-global (nova_runtime.c ~10822, `static volatile int`; Stage 0 deferred it). On 2b, N carriers do non-atomic `++/--` on it = data race (UB). Even on 2a,
park/resume across tasks leaves a stale depth (task A parks at depth 50; task B resumes and sees 50),
causing false stack-overflow panics, and `nova_reset_call_depth()` in nova_panic zeroes it globally.
**REQUIREMENT: move `g_stack_depth` (and `g_stack_max` is fine global/read-only) INTO NovaTaskState;
`nova_rt_stack_enter/exit` go through `nova_cur()->stack_depth`.** This is the Stage-0-deferred work;
Stage 2 is where it lands. (Costs a `nova_cur()` per fn-entry — measure vs the compute hot path; if it
regresses, cache the current task-state pointer in a register/TLS the carrier updates on switch.)

**F3 (SERIOUS) — bounded-channel SEND-side parking unspecified.** The draft only parks recv. A green
task sending to a FULL bounded channel (ch->bound>0 && count>=bound, nova_runtime.c ~2903/2915) would
block the carrier on `not_full`. **REQUIREMENT: symmetric send-side park on `send_waiters`**, unparked
by a receiver's dequeue (which already signals not_full). Mirror the recv park primitive.

**F4 (SERIOUS) — finalize_task sends monitor notifications while holding proc->lock** (today's pool
worker does this, nova_runtime.c ~3546/3602: holds proc->lock, calls nova_rt_channel_send per monitor;
send does deep_copy(malloc) then takes ch->lock). Nested `proc->lock → [CRT heap] → ch->lock` with
unspecified global ordering. **REQUIREMENT: define a strict lock order (proc->lock < ch->lock; never
the reverse) and/or snapshot the monitor list + exit_status under proc->lock, release it, THEN send.**

**F5 (SERIOUS) — select can't register on N channels with one intrusive `qnext`.** A single link can
be on ONE list. select needs the task on N channels' recv_waiters at once. **REQUIREMENT: non-intrusive
waiter NODES (one heap node per (task,channel) registration), plus an atomic `claimed` flag on the
TASK so the first firing send CAS-claims it and the others no-op; the woken task must then UNLINK its
stale nodes from the other N-1 channels before running.** (This is the nominal Stage-5 select work; it
comes WITH Stage 2 because select must not busy-block a carrier.)

**F6 (SERIOUS) — wait_all "live-task count" undefined + cleanup race.** Is a PARKED task "live"? Must
be YES (else a pipeline A→B→C with all parked would make wait_all return early while work remains) —
so wait_all returns only when every task is DONE. And today's wait_all FREES every NovaProcessInfo
(nova_runtime.c ~4052); if a carrier's finalize_task hasn't sent monitor notifications yet, that's a
use-after-free. **REQUIREMENT: live-count = count of tasks not yet DONE (parked counts as live);
finalize_task (incl. monitor sends) must COMPLETE before the task is counted DONE and before wait_all
proceeds to free procs.**

**F7 (SERIOUS) — ✅ RESOLVED 2026-06-05.** fiber_resume now restores the RESUMER's own task state on
return — `nova_current_task = &me->task` (both the Windows-Fiber and POSIX-asm paths), instead of NULL.
This fixes it for BOTH the future carrier loop AND nested fibers (a generator resuming an upstream
generator). Validated by fiber_nested_test.nova: a parent fiber that resumes a child then PANICS is now
CONTAINED to its own fiber — without the fix the parent resumed with NULL→thread-default state
(fault_active=0) and the panic terminated the whole program. Original finding for the record: Stage 1
code set nova_current_task NULL after the switch (fine for a top-level fiber whose resumer is a real
thread, wrong for nested fibers / the carrier loop).

**C8/C9/C10 (CONCERNS):** (8) cooperative preemption at fn-ENTRY does NOT fire in tight loops that call
only builtins (atomic_add, integer ops) — so a CPU-bound `while k<N: atomic_add(...)` never yields; on
2a it serializes (correctness holds for atomicx_test → final count still 4000, but no interleaving) —
acceptable for v1, document it. (9) `on_a_carrier()` must correctly classify main-thread + old-pool
workers as NOT-on-a-carrier so they keep the condvar path — needs a per-thread "I am a carrier" flag,
not just a fiber-pointer compare. (10) cross-carrier fiber resume in 2b: Windows Fibers CAN be
SwitchToFiber'd from any thread that has ConvertThreadToFiber'd (OK); POSIX asm switch is TLS-safe as
long as the carrier sets nova_current_task before resuming (OK) — confirm both in 2b.

**Net:** the corrected Stage 2 = green scheduler + a Go-style `park(unlock_fn)` primitive + symmetric
recv/send channel parking + g_stack_depth→NovaTaskState + non-intrusive select waiter-nodes + a
DONE-gated live-count for wait_all + carrier-owned NovaTaskState. Still ~no compiler change. The park
primitive (F1) and g_stack_depth migration (F2) are the two must-get-right cores; everything else is
mechanical once those are sound. Build 2a, gate on every concurrency test UNCHANGED + a 10k-parked-task
test, then 2b.
