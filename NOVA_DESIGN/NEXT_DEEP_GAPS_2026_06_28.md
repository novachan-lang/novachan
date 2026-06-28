# Next deep gaps — recommendation for owner steer (2026-06-28)

This session closed two of the completeness-audit's named blockers (N>1 multi-core; the WASM frontend), both
gated, plus a real wasm correctness fix (`__multi3`). The REMAINING work is the deep frontier — each is a
multi-session, **reconverge-risky** effort that touches the native compiler/runtime, so it needs the owner to
pick the order and be present for the risky ones. I will NOT start one autonomously.

## Ranked recommendation
1. **Default-on memory reclamation** (scope-exit RC + cycle collector) — ★ RECOMMENDED NEXT (highest leverage).
   WHY: it's the #1 vision blocker. "Simpler than Python" requires zero-config memory; today leak-freedom needs
   manual `arena_enter/exit` ceremony, and default non-arena code leaks (~2000 objs/iter). DESIGN EXISTS +
   adversary-vetted: `NOVA_DESIGN/SCOPE_EXIT_RC_DESIGN.md` + `FULL_TOTAL_RC_DESIGN.md` (the dual-path: per-request
   arena hot-path DONE; long-lived ATOMIC-RC half designed, `NOVA_T8_FULLRC`/`NOVA_T8_DROP` flags exist, default-OFF).
   RISK: HIGH — core RC, reconverge-critical, "irreducibly all-or-nothing" (the adversary FATAL: inc+dec must ship
   atomically or UAF; cycles need a collector). Needs a focused session with the owner present + the full-432 ASAN
   gate from the start. PAYOFF: removes the single biggest "not simpler than Python" gap.

2. **General float-array / HOF perf** (S4/S5) — high value for AI/data/functional idioms (float arrays ~120×C
   today; HOF/closure arithmetic fully dynamic). DESIGN EXISTS: `PERFORMANCE_SPECIALIZATION.md` (S4 = runtime-
   authoritative elem_kind + DEOPT + guarded native load; S5 = whole-program monomorphization). RISK: MEDIUM-HIGH —
   codegen + soundness (an earlier unsound float-array promotion was correctly REVERTED; the runtime-authoritative
   design is the safe path). Reconverge-gated.

3. **WASM cooperative scheduler (Asyncify)** — completes the wasm story: `spawn`/actors don't execute in wasm
   today (no OS threads / no fiber switching), so the runtime cell is the only state mechanism. A continuation /
   state-machine green scheduler on the single wasm stack (or `-sASYNCIFY`) would enable actors + parking in the
   browser. RISK: MEDIUM, and mostly WASM-ONLY (native-safe-ish). Lower vision-priority than 1/2.

4. **ARM/aarch64 + macOS runtime** — multi-target reach (fibers silently no-op on ARM; macOS never run; epoll-only
   netpoller). RISK: LOW-MEDIUM (a port, not a core change) BUT needs the actual hardware to validate — can't be
   done/tested from this Windows host. Best when the owner has an ARM/mac box + CI.

5. **GPU/SPIR-V backend + AI training** (autograd/optimizers/tensors/ONNX) — the AI-vision frontier; highest
   ceiling, biggest effort (a whole new backend + numerics). A multi-session program of its own.

## My pick
**(1) Default-memory** if the owner can supervise a reconverge-risky session — it's the highest-leverage vision
gap and the design is ready. If a lower-risk slice is preferred first: **(3) the wasm scheduler** (safe, completes
the frontend story) or **(4) ARM/macOS** (if hardware is available). Avoid starting (1)/(2) without sign-off —
they reconverge the self-hosting compiler.

## Noted edge-case — ★ RESOLVED (verified graceful, gated)
WASM heap OOM: the freestanding bump heap (`NOVA_FS_HEAP_SIZE`, 8MB default) returns NULL on exhaustion. The
concern was that address 0 is a VALID wasm linear-memory address (unlike a native segfault), so a NULL deref on
OOM could corrupt rather than trap. VERIFIED NOT AN ISSUE (gate `_wasm_heap_one.sh`): a string doubled 25x (32MB)
exhausts the heap, but the value-model's NULL-handle guards (`nova_str_safe`/`find_tag` reject `addr < 0x10000`)
turn the NULL handle into "" (len 0) BEFORE any deref -> `bigalloc()` returns 0 GRACEFULLY, no corruption/crash/
hang. Size the heap via `-DNOVA_FS_HEAP_SIZE` for larger working sets. Not a blocker, not a soundness hole.
