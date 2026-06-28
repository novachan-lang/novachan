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
