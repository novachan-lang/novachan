# Task-struct leak reclaim + the N>1 monitor race (design wye2x31y6, adversary-vetted)

> The #1 production blocker: every completed spawned task leaks its NovaSchedTask struct (~0.5KB) — plus
> its `monitors` array AND its `exit_reason` string (THREE leaks, not one). Finish (nova_runtime.c:6717)
> reclaims the fiber STACK but never the struct; the struct is freed ONLY on the spawn-FAILURE path
> (6333/7109). A long-running Forge server (task-per-request) OOMs in hours. **STATUS: build-ready,
> adversary-vetted, but DELIBERATE work — the adversary's verdict is "NOT safe to implement incrementally
> at N>1"; sound only at N=1.**

## ★ STATUS UPDATE (2026-06-26) — prerequisite DONE + the two hardest risks RESOLVED
- **(1) MONITOR LOCK = DONE + committed (ed3b668).** g_green_monitor_lock (gated g_carrier_count>1)
  closes CRITICAL-1 (the monitor()-vs-finish realloc-vs-read race) + CRITICAL-3 (lost-DOWN). Verified:
  gate green (594/595 both modes), _n1_monitor_race_test PASS at N=4 + ASAN, green_scale N=4 10/10. So
  the N>1-reclaim prerequisite is in place — and CRITICAL-2 (the deref-then-use TOCTOU) is now closable
  the SAME way: do the finish-side generation-bump + freelist-push UNDER g_green_monitor_lock, and the
  deref(pid) in monitor/exit_reason UNDER it too → monitor's {deref+use} is serialized with finish's
  {bump+recycle} → no TOCTOU. So the reclaim can be N>1-COMPLETE, not N=1-only.
- **(2) find_tag CONCERN-2 (CVE-class) = RESOLVED by ODD-encoding.** find_tag (nova_runtime.c:722)
  rejects any non-8-aligned value (`if (addr & 0x7) return -1`) BEFORE any structural test. So encode
  the PID with **bit0=1 (always ODD)** → a packed (slot,gen) handle can NEVER be misclassified as a
  heap object (the alignment check rejects it regardless of whether its magnitude lands in
  [heap_base,heap_top)). No find_tag change needed. Layout: bit0=1, bits[1..24]=slot, bits[25..62]=gen,
  bit63=0. NOVA code treats the PID as an opaque int64 (only the runtime decodes it).
- **(3) DEREF-SITE SCOPE = CONFIRMED BOUNDED: only 4 sites** cast a spawn handle to NovaSchedTask*
  (`grep '(NovaSchedTask*)(uintptr_t)'`): mailbox_of (6388, COMPILER-EMITTED), root-task-assign (6892,
  must decode + NEVER recycle the root slot), monitor (7782), exit_reason (7850). All 4 → nova_task_deref.
- **REMAINING to implement (straight execution, next focused session):** struct +generation/+slot_index;
  a grow-only slot-table (slot→stable struct ptr) + freelist (guarded by g_green_monitor_lock at N>1);
  spawn = pop/grow a slot, gen++, free the slot's PRIOR monitors+exit_reason (free-at-reuse), return
  the odd encode; the 4 deref sites → nova_task_deref (gen-mismatch → graceful NULL/NOPROC); finish =
  under g_green_monitor_lock, gen++ + freelist-push (gated NOVA_SCHED_RECLAIM_TASK, default-OFF first);
  also rc_dec each monitor channel on free (MINOR-1). GATE: reconverge + 595 + green_scale N=4 + ASAN +
  the stability soak (_forge_stability_soak.ps1) RSS must now PLATEAU + a stale-PID test (monitor a
  recycled PID → graceful NOPROC, not UAF/wrong-task).

## ★ The reframe (what the adversary changed) — and a NEW pre-existing bug
- **CRITICAL-1 (pre-existing N>1 bug, INDEPENDENT of the leak): `nova_rt_monitor()` green path (7760-7774)
  holds NO lock.** Its comment says "single-carrier cooperative: no lock needed" — but N>1 ships
  (71a651d). monitor(p) on carrier A racing the monitored task's finish loop on carrier B = concurrent
  `realloc`+write (7772-7774) vs read (6700-6701) of `t->monitors`/`monitor_count` → heap corruption /
  UAF. LATENT (the regression doesn't reliably hit the interleaving; ASAN at N=4 may miss it), but real
  for `serve_safe_req` (crash-isolation) at N>1. **This is the load-bearing fact: N>1 reclaim is BLOCKED
  on a per-task monitor lock the runtime needs ANYWAY for CRITICAL-1.**
- **Therefore: implement reclaim GATED TO N=1** (cooperative single-threaded → CRITICAL-2 TOCTOU +
  CRITICAL-3 lost-DOWN cannot occur; N=1 is the DEFAULT + where servers run, and the throughput soak
  showed N>1 doesn't help I/O-bound so servers stay N=1). **Defer N>1 reclaim until the monitor lock
  lands (prerequisite, not follow-on).**

## Chosen mechanism: generational slot-map for the spawn handle (gated N=1, flag-default-OFF)
- **PID encoding** (keeps the bare-int64 handle; no type-system change): bit63=0 (never aliases a heap
  ptr — STRICTLY SAFER than today's raw-ptr handle, the latent hazard find_tag:6371 warns of);
  bits[0..23]=slot (16M concurrent); bits[24..62]=generation (39b, ~17000yr to wrap).
- **Recycle ONLY the spawn-handle/task-struct + its monitors array + exit_reason.** The MESSAGING PID
  (mailbox channel from self()) is a SEPARATE RC'd find_tag-safe object (drain-closed at 6702) — the
  GROUND/prior-art conflated the two. 3 leaks fixed: struct + monitors + exit_reason.
- **Grow-only freelist** (bound to max-ever-concurrent; NOT a fixed 1<<20 = 400MB table — that violates
  "runs anywhere"). Structs never moved (freelist of stable ptrs) so next/run-queue links stay valid.
- **Rejected B (refcount): structurally impossible** — the PID is a bare int64 the instant it returns to
  NOVA; RC operates only on find_tag-tagged heap objects; the compiler can't emit rc_inc on PID copy.
- **Rejected C (detached-free): unsafe approximation** — serve_safe_req monitors its spawn → still leaks;
  "detached" is unenforceable on a bare int64 → trades benign leak for unbounded UAF. Under A a detached
  task recycles for free + a stale monitor(p) returns graceful-DOWN.

## Exact sites (all nova_runtime.c; ZERO compiler/IR change → gen5.ll==gen6.ll automatic)
- struct 5567-5607: + `int64_t generation; int32_t slot_index;`.
- ~6305: g_task_slots / freelist / counts (grow-only, doubling).
- spawn 6329-6358: freelist-pop or grow; `generation++`; **free the slot's PRIOR exit_reason+monitors
  (free-AT-REUSE, not at finish)**; return `encode(idx,gen)` not `(int64_t)(uintptr_t)t`.
- spawn-fail 6333: push slot to freelist (not free(t)).
- new `nova_task_deref(pid)`: bounds-check + `generation!=gen → NULL` (stale → graceful).
- **PID-deref sites (MUST convert ALL — a missed one segfaults; adversary SERIOUS-3):** mailbox_of 6382
  (**COMPILER-EMITTED**, casts handle→ptr), monitor 7764 (stale→NOPROC channel), exit_reason 7814-7824
  (stale→"noproc", already copies via create_string so safe), **watchdog 6799-6802 (MISSED by the design
  — reads g_carrier_spin[i] as NovaSchedTask*; diagnostic-only, guard or accept stale)**.
- finish 6700-6717: AFTER monitor-notify(6700)+mailbox-drain(6702)+save_queue-dec(6703): `generation++;
  freelist_push(slot)`. Ordering load-bearing (bump+push AFTER the reads).
- **root task: NEVER push its slot** (adversary CONCERN-4: nova_sched_root_task->status==3 at 6644 is the
  scheduler-termination signal; a recycled root slot → premature exit/hang).

## MUST-FIX (adversary, folded)
1. **CRITICAL-2 TOCTOU** (deref-then-use not atomic; slot recycled between check + field-read → monitor
   attaches to the WRONG task) — UNFIXABLE by gating at N>1; **N=1-only avoids it** (single-threaded).
2. **CRITICAL-3 lost-DOWN** (monitor added between notify-loop end + finished=1 → never notified, waiter
   hangs) — same: N>1 needs the monitor lock; N=1 immune.
3. **CRITICAL-1** (pre-existing monitor-vs-finish race) — the per-task monitor lock (prerequisite for N>1).
4. **SERIOUS-2 freelist locking**: at N>1 spawn-pop + finish-push need g_sched_lock → double-acquire per
   spawn = the contention 71a651d's per-carrier queues reduced + a lock on the currently-lock-free finish
   path. N=1 needs NO lock (cooperative) → another reason N=1-only is clean.
5. **MINOR-1 (real, separate leak the design only half-fixes):** the channel handles INSIDE the monitors
   array are never rc_dec'd (notify_channel sends but doesn't dec); freeing the array leaks K channels
   per monitored task. Fix: rc_dec each monitor channel when freeing the array.
6. **CONCERN-2 find_tag:** must verify a packed PID (bit63=0, small-positive) is NEVER misclassified as a
   heap object by find_tag (3× prior CVE source). The bit63=0 + range keeps it a small positive int.
7. **CONCERN-3 semantics:** monitor(stale_pid) → synthetic "noproc" vs today's real-old-status; the bare-
   int64 monitor channel can't distinguish noproc from normal-exit (Erlang does). Minor behavior change.

## GATE / oracle
ASAN-clean + reconverge gen5.ll==gen6.ll + full 593 regression (N=1, both RC modes — catches missed
deref sites as deterministic segfaults) + green_scale + **the leak repro: a bounded serve_req_n soak
whose RSS must PLATEAU** (the _forge_stability_soak harness, committed bdc0b07, is the oracle). Flag
NOVA_SCHED_RECLAIM_TASK default-OFF first (flag-OFF = bump gen but never freelist-push → struct kept →
byte-identical leak; ON = bounded), flip default-ON only after the soak plateaus.

## RISK VERDICT + sequencing
**Adversary: "NOT safe to implement incrementally as proposed" at N>1; SAFE at N=1.** Deliberate work.
Sequence: **(1) the per-task monitor lock** (fixes the pre-existing CRITICAL-1 race AND unblocks N>1
reclaim — do this FIRST, it's a real N>1 soundness fix on its own). **(2) N=1-gated generational reclaim**
(fixes the leak for the default/server case; wide-reaching encoding change → find ALL deref sites, gate
hard). **(3) N>1 reclaim** (once the monitor lock exists). Each gated; flag-default-OFF; the stability
soak is the per-stage oracle. The N=1 reclaim alone solves the production leak that matters today
(servers run N=1 by default).
