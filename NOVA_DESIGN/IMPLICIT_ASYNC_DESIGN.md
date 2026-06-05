# NOVA Flagship: Implicit Async / No-Function-Coloring Scalable I/O — Design Blueprint

**Status:** DESIGN COMPLETE (2026-06-05). Validated by an 11-agent design workflow (6 runtime
studies + 3 NOVA-runtime maps + runtime-designer synthesis + devils-advocate stress pass).
Implementation is a multi-session effort (~6–12 months solo, honest estimate). This doc is the
durable foundation — read it before any implementation stage.

**IMPLEMENTATION PROGRESS:**
✅ **Stage 0 COMPLETE (2026-06-05, commits 3cdf3f4 + 21fd822).** Both fatal TLS issues fixed —
error state (0a) and fault boundary (0b) now per-task in NovaTaskState via nova_cur(). GO/NO-GO
passed (byte-identical, 255/255, perf-neutral).

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
