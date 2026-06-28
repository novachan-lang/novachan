# Default-memory / RC — VERIFIED state (2026-06-28 + 2026-06-29)

## ★★★ CORRECTION (2026-06-29): FULLRC IS FUNCTIONAL AND SOUND

The prior finding (sections below marked STALE) claimed FULLRC emitted "zero drops" for leak_baseline and
diagnosed a "whole-function cross-contamination bug." **THIS WAS WRONG.** The 0-drop observation was a
stale `.ll` artifact — the test re-read a cached `.ll` from a no-flag build instead of the freshly compiled
FULLRC output. When the `.ll` is properly deleted before compilation:

```
rm -f leak_baseline_test.ll
export NOVA_T8_FULLRC=1
./gen3_test.exe leak_baseline_test.nova   # → 2 rc_drop_reassign CALLS (x + d)
```

**Measured results under NOVA_T8_FULLRC=1:**
| Test | Without FULLRC | With FULLRC | Reduction |
|------|---------------|------------|-----------|
| leak_baseline list | 2000 | **1** | 99.95% |
| leak_baseline dict | 2000 | **1** | 99.95% |
| leak_baseline chan | 2000 | 2000 | 0% (expected: channel_create not in make_* set) |
| _leak_list delta | 2000 | **1** | 99.95% |
| _leak_struct delta | 4000 | **2** | 99.95% |

**Validation:**
- Flag-OFF: `.ll` byte-identical (verified sha256 match) ✓
- Flag-ON ASAN: leak_baseline CLEAN ✓
- Flag-ON ASAN: 28-program spot-check, 0 new failures vs. no-flag baseline ✓
- CI (nova_ci.ps1): runs FULL regression in BOTH modes — 591 PASS, 0 FAIL ✓
- The pre-pass is sound-by-construction: only marks slots droppable if (a) every store is a make_* result
  (uniquely owned, RC=1), AND (b) the loaded value is never used outside safe read ops ✓

**What FULLRC doesn't fix (remaining):**
- channel() loop leaks: `channel_create` is a runtime call, not a `make_*` IR op, so not in `_frc_owned`.
  Could be extended (add channel_create to the owned set) but needs careful analysis (channels may be
  shared across processes).
- _leak9.nova (15M allocs): appears to be a different leak pattern (not loop-rebind reassignment).
- General escaping/borrowed values (NOVA_T8_SCOPE): still genuinely all-or-nothing, design-only.

## How the stale-`.ll` bug happened

In Git Bash on Windows, the gen3_test.exe compiler outputs `leak_baseline_test.ll` in the CWD. If the `.ll`
already exists from a prior compilation (without the flag), and a subsequent `NOVA_T8_FULLRC=1 ./gen3_test.exe`
run produces a new `.ll`, the `grep` that counts drop calls may read the old file if there's a caching/timing
issue. The fix: ALWAYS `rm -f *.ll` before compiling with a different flag setting. This is a testing-harness
bug, not a compiler bug.

---

## STALE sections (from 2026-06-28, retained for record — findings below are WRONG)

<details><summary>Original (incorrect) findings — click to expand</summary>

### What was verified (experiments, not docs) — STALE, SEE CORRECTION ABOVE
- **[WRONG] NOVA_T8_FULLRC does NOT currently reduce the headline loop-rebind leak.** This was caused by
  reading a stale `.ll` file. When properly compiled, FULLRC emits 2 drop calls and reduces list/dict
  leaks from 2000 to 1.
- The mechanism description is correct: pre-pass at 16644-16700, ire_fullrc_drop, emission at 15870-15873.
- The flag wiring is correct (env("NOVA_T8_FULLRC") at 16655).

### Differential narrowing — STALE
All the differential results were correct EXCEPT the leak_baseline "0 drops" result, which was caused by
a stale `.ll` file. When properly tested (rm .ll before each compilation), ALL patterns produce drops,
INCLUDING leak_baseline (2 drops for x and d).

</details>

## Current state (accurate as of 2026-06-29, updated after c4da4aa)
- **★★★ FULLRC = DEFAULT-ON (c4da4aa).** Opt-out via `NOVA_NO_FULLRC=1`. All programs get reassignment drops.
- **Escape analysis fix (cfcd085):** Three soundness improvements to the FULLRC pre-pass:
  1. **reg2slot tracking**: owned (make_*) registers mapped to their slots via slot_store, so escapes
     through the original register (not just slot_load) are caught
  2. **Copy propagation**: IR "copy" instructions transitively propagate loadof and reg2slot tracking
  3. **Runtime heuristic**: `starts_with(_fcv, "nova_rt_")` distinguishes safe runtime builtins from
     user functions that might persist references
  Prior to this fix, compiling the compiler with FULLRC produced 159 drops (many unsound → 45 type errors
  in the next generation). After: 5 sound drops, gen5 == gen6 byte-identical.
- **W5b return-drop = DEFAULT-ON** (do_w5b=true at ~16925).
- **Per-request ARENA = DONE + proven** (server hot path, 99% of Forge).
- **NOVA_T8_SCOPE (general escaping/borrowed) = NOT IMPLEMENTED** (design-complete only).
- **Default flip DONE (c4da4aa):** gen5==gen6==gen7 CONVERGED (15462309 bytes, 5 drops). 526/526
  regression pass. Opt-out (`NOVA_NO_FULLRC=1`) produces 0 drops (byte-identical to old behavior).
- **Channel drops DONE (ddf2160):** leak_baseline now list=1, dict=1, chan=1. ALL loop-local leaks closed.
  The channel destructor already existed; FULLRC just needed to recognize channel_create as "owned."
- **Remaining:** scope-exit RC (dropping at scope exit, not just on reassignment) + cycle collector.
  These are deferred to a focused session. Neither blocks Forge or typical programs.
