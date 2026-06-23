# #9 Default-on Memory Reclamation — RESOLVED design (adversarially vetted 2026-06-23)

Source: 10-agent design-resolution workflow (wz1o7yxqc) over SCOPE_EXIT_RC_DESIGN.md.
The FATAL resolver agent died on an API error, but the **adversary + synthesis addressed
the FATAL directly** and produced a sound subset. This file is the implementation spec.

## Verdict

- **Full design (with borrow-promotion + cycle handling): `NEEDS_MORE_DESIGN` / partly UNSAFE.**
  The adversary PROVED that "inc-on-store borrow-promotion" (the design doc's §3.1/§3.3) is
  corruption-prone *no matter how patched* — the self-alias guard misfires (index_get/field_get
  set `ire_borrow_src`, not `ire_load_origin`; copy-forward can propagate load-origin the wrong
  way) → an emitted dec with no matching inc → **dec-without-inc → UAF**. This is the FATAL.
  **Borrow-promotion must be DELETED as a concept, not patched.**

- **Sound subset (Stages 0–2): `SAFE_TO_IMPLEMENT_STAGED`.** Delivers the real #9 win —
  fresh per-call allocations reclaimed at function exit — with ZERO double-free risk.

## INV-OWN — the soundness invariant (why the subset cannot double-free)

> Only a slot holding a **freshly-owned** value (RC=1 from its own allocation producer:
> make_list/dict/struct/closure) that does **not escape** (not stored into a container/field/
> closure, not sent, not returned) is ever dropped, and it is dropped **exactly once** — either
> by the existing S3 `rc_drop_reassign` on overwrite, or by a path-sensitive scope-exit
> `nova_rc_dec`, never both, never neither.

Borrowers (values from index_get/field_get/slot_load/params) are **never dropped** → there is
no inc to omit and no dec to mispair. Skipping a drop is the *conservative* direction: it can
only **leak**, never free early (the monotone-safety property already documented at
nova_compiler.nova ~L15623-15624). Escaped/returned slots are excluded (ownership transferred
to caller/container) — a deliberate, bounded leak, not corruption.

## Staged plan — each stage independently gated, least-risk first

**Gate for EVERY stage (revert-on-any-red):** edit → precheck → gen4 smoke → bootstrap
reconverge (gen5.ll == gen6.ll via `.ll` SHA, never exe SHA) → full **574×2** regression
(flag-OFF byte-identical AND flag-ON) → **ASAN as the soundness oracle** (new tests + full
suite + green_scale N>1 + leak_baseline) → kill-on-timeout. Any red → revert the whole stage.
All stages gated behind **`NOVA_T8_SCOPE` (default OFF)**; flag-off must be byte-identical.
Arena objects inert throughout (`NOVA_RC_ARENA_BIT` early-return) → Forge hot path untouched.

### Stage 0 — Path-sensitive drop set (HIGH-2), NO new drops
Replace flat `ire_dropped` with per-block intersection dataflow + KILL-on-store, wired into the
EXISTING W8/W5b drop sites only. No new dec emitted — only changes *which* already-emitted drop
fires on which CFG path. Factor selection into a shared `ire_block_drops` helper (GEN for the
pre-pass, consulted by the emitter). Lowest risk; prerequisite for Stages 1-2 (they are unsound
on a flat drop set). Verify in-stage: `copy(dropped_in[label])` deep-copies; succ-extraction
covers every terminator kind.
- **Oracle `scope_path_drop_test.nova`:** diamond where one branch drops a slot, the other
  returns it. Flat set leaks linearly (~250+/500 iters) or double-frees the returned one;
  path-sensitive ≈ 0. ASAN turns the mirror double-free into a hard abort.

### Stage 1 — Uniform drop primitive (HIGH-6), fresh-owned only
Collapse `nova_rt_list_free_local`/`dict_free_local` → `nova_rc_dec(handle)` in the runtime;
route all compiler-emitted W8/W5b owner-slot drops through `nova_rc_dec`. Add
`declare void @nova_rc_dec(i64)` / `@nova_rc_inc(i64)` preamble decls.
- **Oracle `scope_w8_s4_alias_test.nova`:** shared-element dict-keys case; without → over-count
  leak or ASAN UAF; with → ASAN-clean, delta ≈ 0. Extend leak_baseline: W8-on delta ≤ W8-off.
- Hard constraint: this stage must NOT enable any borrow-promotion (no inc-on-store emission).

### Stage 2 — Scope-exit dec for fresh-owned, non-escaped, non-returned slots (THE #9 win)
S4 pre-pass builds `ire_scope_drop = _frc_owned − _frc_bad − returned-slot − ire_slot_escaped`,
reusing S3's EXACT classification (NOT the design doc's permissive "every stored slot is
owned"). Emit one path-sensitive `nova_rc_dec` per surviving owner slot at each return
terminator, consulting Stage-0's per-block dropped fact + `ire_dropped`.
- **Oracle:** fresh-owned-locals leak test (loop allocating throwaway lists, returning none) —
  delta must be FLAT across 100k vs 1M iterations (cross-iteration-count comparison is the
  load-bearing oracle; a fixed threshold can be met by a constant leak). Plus dict-iterator-
  frees (HIGH-4 owned path) and `for_iter_borrow_test` (loop var is a borrower → excluded →
  source list intact, len unchanged).
- Delivers value: fresh per-call allocations reclaimed at function exit.

### Stage 3 (DEFERRED, design-gated) — borrow-promotion + closure-capture
HIGH-1 + HIGH-3. **Do NOT code until borrow-promotion is REMOVED from the design (not patched).**
If ever revisited, gate as its own flag layer ABOVE NOVA_T8_SCOPE so Stages 0-2 can't regress.

### Stage 4 (DEFERRED) — typed fast-path (HIGH-5)
Only after 0-3 ASAN-clean across many sessions, and only with a `NOVA_RC_FAST_VERIFY` debug
assertion (find_tag(ptr) ∈ {LIST,DICT,STRUCT}) + the `< 0x10000` null/immediate guard.

## Accepted bounds (write these down; NOT corruption)

1. **Borrowed/escaped locals leak** (conservative; arena carries the hot path).
2. **Closure-captured locals leak** — sent closures are deep-copied (independent RC); do NOT
   attempt inc/dec balancing across the closure boundary (corruption-prone). Treat as escaped.
3. **RC cycles leak** (`push(a,a)`, parent/child graphs) — scope-exit RC is explicitly
   cycle-leaking; do NOT claim "flat memory" for cyclic data. A cycle collector / arena-scoping
   is the only remedy — out of scope for #9.

## Bottom line
Code **Stages 0 → 1 → 2** now (fresh-owned, path-sensitive, uniform-primitive subset — sound
under INV-OWN, no dec-without-inc, default-OFF). FREEZE Stages 3-4. This is the achievable,
sound form of #9: default-on reclamation for fresh per-call allocations, with documented
bounded leaks for the hard cases (which the arena already covers on the hot path).
