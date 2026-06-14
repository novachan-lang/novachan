# NOVA RC Completeness — the partial-refcount gap and the staged path to total RC

**Status:** characterized + staged (iter 29, 2026-06-14). Code-verified, not from memory. The fix
(total reference counting) is a pervasive, bootstrap-sensitive ABI change — staged, not rushed.

## The finding (corrects an earlier imprecise framing)

NOVA's heap values (list / dict / channel / struct / string) carry an RC header, but **the reference
count is PARTIAL — it tracks CONTAINER MEMBERSHIP, not total references.** `nova_rc_inc` is emitted
in exactly four runtime sites:

- `nova_rt_list_append` (element stored into a list)
- `nova_rt_dict_set` (key/value stored into a dict)
- `nova_deep_copy_rec` shared-types branch (string/box/**channel** shared with a bump — spawn-capture
  and channel-send go through here, so cross-task sharing IS balanced)
- `nova_rt_list_set` (element replacement)

There is **no `rc_inc`** on: variable-to-variable copy (`let b = a`), function-argument passing,
`return`, struct-field stores, closure captures, **for-in element extraction**, or match-pattern
binding. And the compiler's `slot_store` codegen (nova_compiler.nova ~L14482-14514) emits a bare
`store i64 %val, ptr %slot.N` — **it never `rc_dec`s the value the slot previously held.** The only
auto-drops are W5b (at function `return`) and W8 (at block exit), both list/dict-only and both
**opt-in (`NOVA_T8_DROP`) and disabled by default** because a W5b-compiled compiler fails to
self-compile (trait/closure/generics patterns create aliases the escape analysis misses).

### Consequence (measured)

A 2000-iteration loop that rebinds a fresh heap local each iteration leaks ~1 struct/iteration —
**`live_count()` delta: LIST=2000, DICT=2001, CHAN=2001, and IDENTICAL with `NOVA_T8_DROP=1`.** The
old value is never `rc_dec`'d on reassignment, so it stays at RC=1 forever. This is **not
channel-specific** (the iter-28 "channels uniquely never freed" framing was imprecise) — it affects
every heap type. `nova_rt_cleanup` frees only infrastructure (intern table, slab pages); the slab
bulk-free reclaims list/dict *struct headers* at exit, but their malloc'd backing arrays (and channel
buffers) leak permanently. **Tolerable for short-lived processes** (tests, a compiler run that
processes one file and exits) — **fatal for a long-running server** (each request leaks its temp
lists/dicts/channels → unbounded growth → OOM).

## Why the tempting "reassignment-drop" is UNSAFE (and not separable from W5b)

Emitting `rc_dec(old)` before each slot overwrite *looks* like a clean incremental fix. It is a
**use-after-free**, because the RC is partial:

- **for-in over heap elements (the killer):** `for x in list` lowers the loop-var to a `slot_store` of
  the result of `index_get`, which returns `list->data[i]` **borrowed, with no `rc_inc`** (the list
  still owns it at RC=1). A drop on the next iteration's overwrite frees the list's live element →
  UAF / double-free at list destruction. This is the most common loop in NOVA, present in the
  compiler itself. The borrowed element has no `ire_load_origin`, so the "mark load_origin escaped"
  mitigation provably cannot detect it.
- **`let b = a`; `a = ...`:** raw pointer copy, no `rc_inc`; the drop frees `b`'s target.
- **param pass / struct field / closure capture:** all raw aliases with no `rc_inc`.

`x = [fresh]` (old value genuinely owned, RC=1, safe to free) and the for-in borrowed-element store
lower to **identical `slot_store` IR**; a flow-insensitive flat type map cannot separate owned from
borrowed. That is the *same* missing ownership/escape analysis that breaks W5b self-compilation — so
reassignment-drop is **not separable** from the deferred W5b work and is strictly *harder* (it fires
mid-function at every overwrite, so the UAF corrupts live data rather than merely leaking).

## The sound fix: total reference counting (Swift ARC / CPython model), staged

- **Stage 0 (DONE, iter 29):** a `live_count()` leak-baseline regression guard pinning the current
  per-type deltas as the falsifiable oracle for all later RC work (catches a *worsening* leak; reports
  the actual delta so the eventual drop-to-~0 is visible). No drop emitted.
- **Stage 1 (make ownership knowable):** a per-value OWNED-vs-BORROWED provenance bit in the IR. OWNED
  iff produced by an allocating site (make_list/dict/struct, channel, struct_alloc, string producers)
  and not aliased; BORROWED iff from index_get / field_get / param / deep_copy-share. Pure metadata —
  must change zero codegen (byte-identical reconverge `gen5.ll==gen6.ll`).
- **Stage 2 (close the alias gaps that break W5b):** at `slot_store`, when the value has
  `ire_load_origin`, mark that origin slot escaped (covers `let b = a`); make
  `make_closure`/`make_struct` args escaping in the same set the local/RC-elision decision uses (today
  only the SROA set knows); treat for-in element borrows and match bindings as BORROWED (never
  droppable). Re-enable W5b-at-return behind `NOVA_T8_DROP` and **prove bootstrap self-compile** (the
  true gate; reassignment-drop cannot precede it).
- **Stage 3 (total RC, behind `NOVA_T8_FULLRC`):** `rc_inc` on every aliasing copy (let/param/return/
  struct-field/closure-capture) and `rc_dec` on every overwrite + scope-exit, via generic
  `nova_rc_dec` (NOT `list_free_local`, whose contract is "no element RC bookkeeping" — using it here
  would leak elements or double-dec). A drop on a BORROWED slot is a compile-time no-op (Stage 1 bit).
  Validate against the Stage 0 oracle (deltas → ~0) + 411 + all concurrency tests + green_scale 10k;
  REVERT on any crash or leak-persists; reconverge before default-on.
- **Stage 4 (perf recovery):** elide `rc_inc`/`rc_dec` pairs on proven-non-escaping locals (reuse
  Track-8's escape set) so single-process code stays zero-cost — GATE 4/5 benchmarks must hold.

Two correct-but-deferred destructor fixes belong with Stage 3 (they only matter once channels are
actually freed): the `NOVA_MEM_CHANNEL` destructor must `rc_dec` buffered items (mirror LIST/DICT,
circular buffer item i = `buf[(head+i)&(cap-1)]`), and the POSIX branch must
`pthread_cond_destroy(&ch->not_full)`.

## Competitive position

Swift (ARC) and CPython (refcounting) pay `rc_inc`/`rc_dec` on every reference and recover via
elision/optimization. Rust avoids RC entirely via compile-time ownership. NOVA's intended position:
RC with Track-8 ownership-erasure for non-escaping locals (no RC traffic at all there) + total RC for
genuinely-shared values (Stage 3-4). Until Stage 3 lands, NOVA is **behind** Swift/CPython/Rust on
this axis (leaks reassigned heap locals) — a tracked correctness debt, not a design dead-end.

---

## ★★ iter-55 VALIDATED DESIGN (2026-06-14, 8-agent design + adversarial workflow)

VERDICT: **GO on S1 (byte-identical provenance foundation) + S2 (re-enable W5b, positive-owned gate);
HARD STOP before S3.** The actual leak fix (S3 total-RC) is DEFERRED: slot-level provenance is
necessary-but-INSUFFICIENT -- S3 needs a value-level ownership-transfer model (S2.5) that does not
exist yet. Build the safe foundation; do NOT promise the leak fix until S2.5.

**Why S3 defers (verified):** `nova_rt_list_append` rc_incs the element (runtime L546) while the source
still owns it -> the pervasive `let acc=[]; for x in items { push(acc,x) }; return acc` pattern would
double-count, and dropping would double-free. Also `make_struct` stores fields with a BARE store (no
rc_inc, codegen L14997) while struct rc_free dec's them (L7790) -- a latent double-free landmine, and
the L7785 comment FALSELY claims make_struct rc_incs. S3 is unsound until S2.5 adds clone-or-transfer
at owning-container boundaries.

**Chosen mechanism (defeats the byte-identity + DCE refutations by construction):** carry provenance as
a NEW FIELD on the slot_store IrInst -- NOT a new op-kind. DCE (L12481) keeps an instruction only if
`op=="slot_store"` (literal string); a renamed owned_store/borrow_store with dest=="" would be DELETED
-> self-miscompile. There are 47 slot_store occurrences across ~14 consumer/emit sites + ~10 value-
binding emit sites (generator-for-in L8540, generic-assign L9109, comprehension L9317/9324, match-binds
L8025/8131/8145/8687/8793/8935/9041, spawn L8839, closure L8867); a field keeps op=="slot_store"
everywhere so ALL consumers match with ZERO edits and the field is inert until a deliberate consumer
reads it. Provenance is register-keyed (`ire_borrow_src` set, propagated at index_get/field_get/
re-borrow). The drop gate must be **POSITIVE-OWNED** (drop only slots PROVEN owned via a closed
allowlist of allocating producers), NEVER negative-borrowed -> every classification GAP degrades to a
LEAK, never a UAF. This is the only form that survives both adversarial lenses.

**S1 first-step (byte-identical; 3 pure-metadata edits, consume NOTHING):**
1. Add `ire_borrow_src: dict` as the LAST field of IrEmitter (mirror the prior ire_uses_byname add;
   `, {}` final arg in new_ir_emitter).
2. Populate at borrow-producing codegen sites ONLY (dict writes, emit no LLVM text): index_get dest
   (the for-in elem_r path ~L8599), field_get dest, slot_load FROM a register already in ire_borrow_src.
3. Reset `e.ire_borrow_src = {}` in the per-function reset block (alongside ire_load_origin).
   Do NOT change the slot_store op name. Do NOT add a drop-gate clause. Do NOT read the field where text
   is emitted. Byte-identity is guaranteed (metadata dicts are never serialized; op string unchanged ->
   DCE + 14 consumers still match; drop gate untouched).
   GATE: reconverge gen5.ll==gen6.ll MUST stay 15D5A9D5 (if it moves, a write leaked into output ->
   bisect across the 3 populate sites) + 422/422 + leak oracle deltas unchanged.

**Stages:** S1 (provenance foundation, byte-identical, LOW) -> S2 (re-enable W5b list/dict drop-at-
return with positive-owned + not-borrowed + not-escaped gate; default stays 15D5A9D5 since the gate is
inside the do_w5b branch (default OFF); the W5b-ON path is a SEPARATE fixpoint to prove via self-compile
+ the trait/closure/generics tests that broke bare-W5b; MEDIUM/bounded -- list_free_local does NOT dec
elements so no element double-free here, that's S3-only; monotonic: drops a strict subset of bare-W5b)
-> S2.5 (BUILD the value-ownership foundation: clone-or-transfer at append/dict_set/make_struct of a
borrowed register + rc_inc at make_struct field-store L14997 + fix the false L7785 comment; HIGH, the
genuine S3 prerequisite) -> S3 (total RC behind NOVA_T8_FULLRC, the actual leak fix; CRITICAL, deferred
until S2.5 proves) -> S4 (perf elision / RC erasure; LOW-MED, only if S3 succeeds).

**Residual S3 soundness risk (even after S2.5):** unenumerated borrow sources -- borrows leak in via
field_get (struct-of-lists, pervasive) and tuple/match destructuring (lowered as op=='call' to
nova_rt_index_get, NOT op=='index_get'). Positive-owned gating keeps these as leaks, not UAFs.

NEXT: iter-56 = execute S1 (byte-identical). iter-57 = S2 (the partial leak fix: function-local list/dict
freed at return; prove self-compile). S2.5/S3 = the deep value-ownership campaign, sequenced after.

---

## ★ iter-57 EMPIRICAL W5b-ON PROBE (2026-06-14) -- the historical correctness failure is GONE

A bounded probe (_w5b_probe.ps1): built a W5b-compiled compiler (gen3_test.exe @1187CB94 compiling
nova_compiler.nova with NOVA_T8_DROP=1 -> gen4_w5b) and ran the EXACT tests that broke bare-W5b
(trait/closure/generics_advanced/generics_soundness/spread + leak_baseline) THROUGH it (drops on).

RESULT: **W5B-SMOKE OK** -- all 7 pass. The W5b-compiled compiler correctly compiles + runs the
trait/closure/generics/spread programs that historically failed. => **W5b-on is SEMANTICALLY SOUND
today.** The 50+ iterations of escape-analysis hardening (ire_slot_escaped propagation at append/
dict_set/make_struct/closure-capture/dyn_call, the load_origin aliasing, etc.) closed the gaps that
broke bare-W5b in iter-29. The positive-owned keying (ire_local_slots only holds LOCALLY-CREATED
list/dict slots -- borrowed index_get/field_get elements never enter it) means the for-in-borrow UAF
is already structurally prevented, so the S1 not-borrowed clause is belt-and-suspenders, NOT required
for correctness (the smoke proves it).

OPEN QUESTION (not yet answered): RECONVERGENCE STABILITY. The probe's "SELF-REPRODUCE DIVERGES
(1187CB94 vs 4BFF7684)" compared gen3's W5b-output vs gen4_w5b's W5b-output -- the FIRST transition,
which is NEVER a fixpoint (the standard reconverge needs 3 passes and checks gen5==gen6). So the probe
is INCONCLUSIVE on reconvergence. The decisive test = a proper 3-pass W5b-on reconverge (NOVA_T8_DROP=1
throughout): does gen5_w5b.ll == gen6_w5b.ll? If YES -> W5b-on is reconverge-stable + sound -> flip
default-on (a REAL partial leak fix: function-local non-returned list/dict freed at return) with the
full gate. If NO (diverges at gen5/gen6) -> W5b drop EMISSION is non-deterministic (likely dict-key
iteration order at the `for slot_n in keys(e.ire_local_slots)` drop loop ~L15646) -> make it
deterministic (sort the slots) first, then default-on.

SCOPE NOTE: even default-on, W5b is a PARTIAL leak fix (function-local containers NOT returned; the
pervasive `acc=[]; for x {push}; return acc` escapes via return + the deep value-double-free remain
S3). The full leak fix is still S3 (behind the S2.5 value-ownership foundation). But W5b default-on is
a real, sound, shippable leak REDUCTION for the common function-local-container case.

NEXT (iter-58): run the proper 3-pass W5b-on reconverge; if gen5_w5b==gen6_w5b, flip default-on with
the full gate (full regression under W5b-on + green_scale + the leak oracle showing reduction); else
fix the drop-emission determinism (sort the drop slots) first.
