# FLEET CODE RULES — paste into EVERY fleet-agent prompt

These rules exist because fleet-built modules were manually unrolling loops and
copy-pasting blocks (owner flag 2026-07-20; see memory `feedback-no-loop-unrolling`).
The mqtt varint-decode unroll hid a real bug. Root cause was cargo-cult caution —
a probe proved triple-nested `while` + `push` works correctly. Loops work everywhere.

## NO LOOP-UNROLLING — the #1 rule
- If you would write the SAME body more than once — a fixed-count sequence of
  near-identical `if done == 0` / `if running == 1` / `if i == N` blocks that each
  do one "iteration" — that is a BUG. Write ONE `while` loop instead.
- A body repeated ≥2× with only an index/constant changing → loop over a list, or a
  helper function. Never copy-paste it.
- `while` loops, nested `while` loops, and `push()` inside nested loops ALL work
  correctly in NOVA. Do NOT unroll "to avoid scoping issues" — there is no such issue.
- NEVER leave a comment justifying an unroll ("unrolled to avoid X"). If you feel the
  need to write that comment, write the loop instead.

## NO COPY-PASTE DUPLICATION
- Same multi-line block (3+ lines) appearing 2+ times in a function/file → extract a
  private `_`-prefixed helper and call it. This includes: error-sentinel construction
  (`[-1, pos]`), byte-append loops, nibble/char decision ladders, packet-framing tails,
  membership tests (`if o==32 or o==9 or ...` not four chained `if r==0` blocks).
- Two symmetric branches that differ only by swapped variables → factor the shared part.

## NO DEAD CODE
- Don't leave a computed value that is never read. Don't leave two functions where only
  one is called. Don't leave "scratch" comments recomputing something the code already did.

## CORRECTNESS BAR (unchanged)
- Bounds-check every indexed read. Validate loop-termination guards actually fire
  (a guard that can never be true is dead — a real bug, as in the mqtt case).
- Every module KAT-gated: compile + run + PASS via `_run1.ps1` before you report done.
- Write each module to BOTH `std/<cat>/<m>.nova` and `nova-compiler/std/<cat>/<m>.nova`,
  byte-identical (diff them).
