# Default-memory / RC — VERIFIED current state (2026-06-28, by experiment)

Dug into the audit's #1 gap (default-on memory reclamation). This corrects the record with EXPERIMENTAL ground
truth (the prior "NOVA_T8_FULLRC drops leak_baseline 2000->1" claim in memory/RC_COMPLETENESS is STALE).

## What was verified (experiments, not docs)
- **NOVA_T8_FULLRC does NOT currently reduce the headline loop-rebind leak.** Compiling leak_baseline_test.nova
  with `NOVA_T8_FULLRC=1` (set for gen3 at compile time, where the pre-pass reads it, nova_compiler.nova:16655):
  the emitted .ll contains **zero `nova_rt_rc_drop_reassign` CALLS** (only the `declare`), and the leak prints
  `list=2000 dict=2000 chan=2000` — IDENTICAL to flag-off. So the per-iteration reassignment-drop fires for
  nothing in this program. (The flag IS wired + read; it just marks no slots.)
- **The mechanism is sound-by-construction and correctly keyed.** Pre-pass at nova_compiler.nova:16644-16700
  computes `ire_fullrc_drop` = slots that are always-OWNED (store is make_list/dict/struct/closure, 16665) AND
  never-escaped (loaded value only arg0 of list_len/index_get/field_get, 16684-16689). Emission at 15870-15873
  loads old + calls nova_rt_rc_drop_reassign(old,new) (runtime: `if(old!=new) rc_dec(old)`, pointer-validated).
  Off-path is byte-identical (set resets to {} at 16585; the env guard makes 15870 always-false when off).
- **List/dict literals ARE make_list/make_dict IR ops** (nova_compiler.nova:8202/8206), so the OWNED check should
  match. In leak_baseline's dict loop the slot `d` is stored from a make_dict result and is NEVER slot_loaded
  (len runs on `%r29 = %r26+0`, a copy of the make_dict reg, not a slot_load of d). By the written analysis `d`
  (and `x`) SHOULD be owned + never-escaped => droppable. Yet zero slots are marked. **So there is a real bug in
  the pre-pass: a slot that statically qualifies is not being added to ire_fullrc_drop.**

## Other mechanisms (also verified)
- **W5b return-drop = DEFAULT-ON** (nova_compiler.nova:~16925 `do_w5b=true`; opt-out via NOVA_NO_TRACK8/
  NOVA_T8_NO_DROP). Frees proven-local non-returned list/dict slots before `return` (function-local reclaim).
  Does NOT touch per-iteration loop leaks. (A stale comment near 16918 still says "DEFAULT OFF" — code is ON.)
- **Per-request ARENA = DONE + proven** (per-task arena, serve_n_arena, flat concurrent server live_delta 16359->0)
  — covers the framework/server HOT PATH (~99% of server code) with NO RC. This is why the leak is not a
  practical blocker for Forge today; it bites general non-arena/CLI/long-lived code.
- **NOVA_T8_SCOPE (scope-exit RC for long-lived/escaping values) = NOT IMPLEMENTED.** Design-complete +
  adversary-vetted (SCOPE_EXIT_RC_DESIGN.md). The general case is GENUINELY ALL-OR-NOTHING (dropping a container
  whose element was borrowed out is sound only if the producer rc_inc'd it; split RC=1 vs make_list RC=2 differ
  per-producer; needs Stage-A rc_inc-on-every-alias + Stage-B dec shipped together, ~30 edits + 7 must-fixes).

## The precise next step (a focused, ASAN-gated effort — the riskiest subsystem)
1. **INSTRUMENT the pre-pass** (nova_compiler.nova, after 16700, gated on a new NOVA_T8_DEBUG env so off-path is
   untouched): print `keys(ire_fullrc_drop)`, `_frc_owned`, `_frc_bad`, `_frc_stored` to stderr. Recompile gen3
   from the instrumented compiler (bootstrap), run on leak_baseline with NOVA_T8_FULLRC=1 + NOVA_T8_DEBUG=1.
   PIN exactly why `d`/`x` land in `_frc_bad` (or are absent from `_frc_stored`). Hypotheses to test: (a) the
   slot_store IrInst's `_fcv`/`_fca` shape differs from what 16677 expects; (b) a whole-function later use of the
   slot (or slot-name reuse) flags it; (c) `make_dict`+`dict_set` two-step makes the owned reg differ from the
   stored reg.
2. **FIX** the identified pre-pass gap (still flag-gated). VALIDATE (mandatory, the iter-88 lesson = a 6-program
   de-risk MISSED 33 UAFs): flag-OFF .ll byte-identical (0-byte diff on the full suite); flag-ON full regression
   432/0 with **ASAN on ALL programs from commit 1**; bootstrap reconverges (gen5==gen6) under the flag; green_scale
   N>1 clean; leak_baseline/_leak9 delta drops while ASAN-clean. Only after ALL pass: consider flipping default.

## Bottom line
The #1 gap is real and the current FULLRC "fix" is non-functional (verified). It is NOT a quick win: the headline
fix needs compiler-internal debugging then careful validation in the riskiest subsystem, and the general case is
all-or-nothing. The ARENA already covers the case that matters most (server). Recommend tackling the pre-pass bug
(step 1-2) as a focused, ASAN-gated session — precise entry point above. Supersedes the stale "2000->1" claim.

## ★ REFINEMENT (same session) — FULLRC WORKS for straight-line reassignment; the gap is LOOP-LOCALS
Minimal probe `let x=[1,2,3]; len(x); x=[4,5,6]; len(x)` under NOVA_T8_FULLRC=1 emits **2 nova_rt_rc_drop_reassign
CALLS** -> the reassignment-drop mechanism is FUNCTIONAL, not broken. leak_baseline's `while: let x=[...]` emits
**0** CALLS. So the headline leak is NOT a broken mechanism -- it is a MISSING CASE: a loop-body `let x` (stored
into the same slot.x each iteration per the .ll) is not marked droppable by the pre-pass, while straight-line
reassignment IS. The loop structure (back-edge / per-iteration `let` re-declaration) is the differentiator.

This REPLACES the "all-or-nothing" framing for THE HEADLINE LEAK: the straight-line drop machinery already works
+ is sound (432/0), so the tractable next step is to make the pre-pass ALSO mark loop-body reassigned slots
droppable (a loop-local `let` whose every store is owned + never-escaped is the same safety class as straight-line
reassignment -- the value rebound each iteration is uniquely owned and the previous one is dead). PRECISE TARGET:
the pre-pass at nova_compiler.nova:16644-16700 (likely the loop back-edge makes the slot appear loaded/escaped, or
each loop-iteration `let` is treated as a distinct binding that the slot_store scan doesn't unify). VALIDATE as
before (flag-OFF byte-identical; flag-ON ASAN-on-ALL + 432/0 + reconverge gen5==gen6 + green_scale + leak delta
drop). The general escaping/borrowed case stays all-or-nothing, but the HEADLINE loop-rebind leak is a focused,
bounded extension of an already-working sound mechanism.

## ★★ DIFFERENTIAL NARROWING (same session) — it's a WHOLE-FUNCTION bug on COMPLEX functions
Drop-call counts under NOVA_T8_FULLRC=1 (grep `call i64 @nova_rt_rc_drop_reassign`):
- straight-line `x=[..]; x=[..]`           -> 2   (works)
- reassign INSIDE a loop (x declared above) -> 2   (works)
- single loop-local `let x=[i]`             -> 1   (works)
- loop-local `let x=[i,i+1,i+2]` (3-elem)   -> 1   (works)
- 3-elem + live_count delta                 -> 1   (works)
- list + dict (2 heap loops)                -> 2   (works)
- list x + a channel loop                   -> 1   (works)
- **leak_baseline (list+dict+chan + 3 deltas) -> 0** (BROKEN)
Every simpler pattern drops; only the full multi-loop+delta function emits ZERO. So the bug is NOT in the
straight-line/loop-local logic (all sound) — it is a WHOLE-FUNCTION pre-pass issue that, on a sufficiently complex
function (3 heap loops + the b0/b1/b2 + *_delta slots + send/receive), wrongly flags ALL candidate slots as bad
(cross-contamination), so leak_baseline gets nothing. NEXT (decisive): instrument the pre-pass (NOVA_T8_DEBUG,
flag-gated) to dump _frc_owned/_frc_bad/_frc_stored/ire_fullrc_drop for leak_baseline and see WHICH unrelated use
poisons x/d (candidates: a delta/live_count load, the channel send/receive args, or a slot-key collision across
the 12+ slots). The fix is then a targeted pre-pass correction — still a bounded extension of a sound mechanism,
NOT the all-or-nothing scope-exit problem. Validation unchanged (flag-OFF byte-identical + flag-ON ASAN-all + 432/0
+ reconverge). The fact that the machinery works for ~all real single-purpose loops means this is HIGH-VALUE + LOW-
SCOPE relative to its headline impact.
