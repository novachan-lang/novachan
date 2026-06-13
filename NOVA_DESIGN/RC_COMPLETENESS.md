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
