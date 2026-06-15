# NOVA Memory Reclamation — Full Total RC + Per-Request Arena (Canonical Design)

Status: **CANONICAL** (supersedes the workflow draft `FULL_TOTAL_RC_DESIGN_DRAFT.md`).
Date: 2026-06-15 (iter-89). Author: Chief Language Architect, grounded in the real
`nova_runtime.c` + `nova_compiler.nova` via a 7-agent design workflow (5 readers →
compiler-architect design → devils-advocate break). The draft was **adversarially
invalidated**; this doc is the corrected plan. Raw artifacts:
`FULL_TOTAL_RC_DESIGN_DRAFT.md`, `FULL_TOTAL_RC_ADVERSARY.json`.

---

## 0. The problem (framework-readiness)

A long-running NOVA server must hold **flat memory** — a Spring-Boot/Django-beating
framework cannot leak per request. Today a request handler leaks ~16k objects per request
(`_forge_readiness.nova`), and `leak_baseline_test.nova` shows ~2000 leaked
list/dict/channel objects over 2000 loop iterations. This is THE blocking core prerequisite
for Forge (deferred until this is solved).

### What we already have (iter-87, sound, default-OFF behind `NOVA_T8_FULLRC`)
- **Stage-3 reassignment drop:** when a heap loop-local is *reassigned*, the old value is
  `rc_drop_reassign`'d. Drops `leak_baseline` **list/dict 2000→1**. SOUND (432/0 both modes).
- It does **NOT** fix: per-iteration *scope-exit* leaks (function-local temporaries that
  are never reassigned), values that escape into calls, nested containers, or **channels**.

### What FAILED (iter-88, REVERTED)
A conservative "drop owned-AND-never-escaped local slots at scope-exit" pass. Two killers:
1. **Ceilinged out:** `_forge_readiness` barely moved (16359→15960). Handler temporaries
   escape into calls (`items → json_obj`) or nest (split substrings) — conservative
   analysis *must* treat anything flowing into a call as escaped, so it can't reclaim them.
2. **Unsound:** flag-on regression went 432/0 → **399/33 with 0xC0000005 use-after-free**.

> **THE LESSON (inviolable):** You cannot safely *drop* a value without *counting* its
> aliases. A static "no-alias" proof has too many holes (33 of them). The only sound
> reclamation of aliased/escaping/shared values is to **count every reference**.

---

## 1. Two complementary mechanisms (the decision)

Neither full RC nor arenas alone is sufficient. **NOVA uses both, by lifetime class:**

| Allocation lifetime | Mechanism | Why |
|---|---|---|
| **Request-scoped (hot path, ~99%)** | **Per-request process + arena** | Flat memory, cycle-immune, zero per-object RC cost. The request's entire heap is freed in one `free()` at request end. |
| **Long-lived / cross-request** | **Full total (atomic) reference counting** | A shared cache process accumulates entries across requests; each must be reclaimed on eviction. Cannot be arena'd (no single free point). Shared across processes → must count refs. |

This is not a compromise — it is the correct decomposition. nginx/Apache (per-request
pools) + Erlang (per-process heaps) prove the arena model for request handling; CPython /
Swift prove RC for long-lived object graphs. NOVA already has the substrate for both:
`nova_arena_mode` (RC becomes a no-op), process isolation, and deep-copy-on-channel-send.

---

## 2. Per-request arena (the framework hot path) — PREFERRED, build FIRST

### Mechanism
1. A request handler runs as an isolated green process `P` with a private **arena** `A`
   (a bump allocator; `nova_heap_alloc` redirects into `A` while `P` is active).
2. Every allocation during the request lands in `A`. No RC traffic (`nova_arena_mode=1`
   → `rc_inc`/`rc_dec`/`rc_free` are no-ops — **already implemented**).
3. At request end, `A` is freed **wholesale** (one operation). Cycles within `A` die with it.

### Why it is SOUND (the escape argument)
Freeing `A` wholesale is safe iff **no live reference into `A` survives the request.** Every
NOVA escape path already copies out of `A`:
- **Response → socket:** serialized to bytes (copied to the socket write buffer) before free. ✓
- **Value → shared cache/other process:** `channel_send` **deep-copies** (`nova_rt_deep_copy`)
  → the copy lives in the *receiver's* heap, not `A`. ✓ (verified: `nova_rt_channel_send`
  L3784).
- **Globals:** process-isolated. A request process cannot write another process's globals;
  its own globals die with it. ✓

The danger is any future escape path that does NOT copy out (e.g. a raw shared-memory
pointer). **Design rule:** every value crossing a process/arena boundary MUST be copied.
This is already NOVA's channel semantics; keep it inviolable.

### Why it sidesteps every RC failure mode
- **Cycles:** freed with the arena. No cycle collector needed for request-scoped data.
- **Perf:** zero per-object RC; bump-allocate + one bulk free. Beats RC *and* GC on the hot path.
- **The 33-UAF class:** impossible — there is no per-object free within a request, so no
  premature free is expressible.

### Testable oracle (no Forge needed)
A probe that: enters arena mode → allocates many objects *including a deliberate cycle* →
exits arena mode (wholesale free) → asserts `live_count()` returns flat. This validates the
mechanism in isolation, before Forge consumes it.

### Implementation status
- **iter-90 (DONE, runtime foundation):** transparent arena via a thread-local
  `nova_active_arena`; `nova_heap_alloc` bump-allocates into it and tags objects
  with `NOVA_RC_ARENA_BIT` (bit 30 of the rc field) so `rc_inc`/`rc_dec` no-op on
  them (never individually freed); `nova_rt_arena_scope_enter/exit` push/pop +
  free wholesale (nesting via a returned prev-handle). Arena objects are excluded
  from `nova_mem_live` (the leak metric). VALIDATED by `_arena_harness.c`: 100k+
  structs + TWO reference cycles freed wholesale, `live_count` flat, ASAN clean
  (no UAF/double-free). Completely INERT when no scope is active (heap path
  unchanged) → zero risk to the 432 suite.
- **Gotcha 1 (iter-91):** list/dict/string **backing arrays** are separate
  `malloc`s (`list->data`, dict keys/vals/hashes/idx, string builders). Under a
  scope only the *header* enters the arena; the backing array would leak on
  wholesale free. Fix: an object's allocation kind is FIXED AT CREATION (its
  `ARENA_BIT`); its backing storage follows its own kind; arena "realloc" =
  bump a new array + copy (old wasted, reclaimed wholesale — no realloc/free in a
  bump arena). Finite site list: list create/append/insert, dict create/grow/set,
  string builders. STRUCTs need no change (self-contained) — hence the iter-90
  struct-only validation.
- **Gotcha 2 (before request use):** `nova_active_arena` is per-OS-thread. Green
  tasks interleave on one carrier, so a task that PARKS mid-scope must save/restore
  this pointer as part of its context (scheduler integration). Today only whole,
  non-yielding scopes are sound.
- **Gotcha 3:** `ARENA_BIT` at bit 30 means a real object's rc must stay < 2^30
  (~1B refs) — far below the existing int32 rc overflow limit (2^31), so no new
  practical constraint; documented.

### Open work
- list/dict/string backing-array interception (Gotcha 1) — iter-91.
- Green-task save/restore of `nova_active_arena` (Gotcha 2) + lifecycle tied to the
  green-process scheduler (enter on dispatch, free on completion).
- The escape-copy audit: enumerate every boundary and prove it copies out before
  free (channel-send ✓, response-serialize ✓, globals = process-isolated ✓).
- NOVA-level surface: `arena_enter()`/`arena_exit()` builtins (compiler change +
  reconverge) so NOVA programs (and Forge) can use scopes — iter-91+.

---

## 3. Full total (atomic) reference counting (long-lived heaps) — build SECOND

For data that outlives a single request (caches, connection pools, module globals). This is
the corrected version of the draft. **The draft's staged rollout was FATALLY flawed** and is
discarded; below is the sound plan.

### 3.1 The invariant
> `RC(obj)` == the number of live **owning** references to `obj` at all times.

Every operation that **creates** an owning reference emits `nova_rc_inc`; every operation
that **destroys** one emits `nova_rc_dec`. They are two halves of ONE invariant.

### 3.2 FATAL #1 — inc and dec MUST ship atomically (never staged apart)
The draft proposed Stage A+B (add `dec`s) then Stage C (add `inc`s), calling A+B
"conservative — only adds decs, a missing dec is a benign leak." **This is backwards and
exactly the iter-88 mistake:** adding `dec` without the matching `inc` *under-counts* →
premature free → **UAF**. (Over-counting — incs without decs — would *leak*, which is benign;
under-counting *crashes*.) Therefore: **all inc/dec insertion points for a given construct
ship in a single atomic change**, gated together. There is no "decs-only" intermediate state.
`NOVA_T8_FULLRC` has no sub-stage granularity, so any committed intermediate IS what the flag
runs — it must be whole.

### 3.3 inc insertion points (create an owning reference)
Keyed to the real IR ops (`ire_emit_*` in `nova_compiler.nova`):
- **slot_store of a non-owned (aliased) value** (`let b = a`, copy op `add x,0`): `rc_inc(new)`.
- **parameter bind** under the chosen convention (see 3.5).
- **return of an owned value:** `rc_inc` before the cleanup epilogue dec's its source slot.
- **store into a retained container** (`list_append`, `index_set`, `field_set`, dict set):
  `rc_inc(elem)` — **already done in the runtime** (e.g. `nova_rt_list_append` L1017).
- **closure capture:** `rc_inc` each captured value (self-hosted closures use
  `nova_rt_struct_alloc` → real RC header; see 3.7).

### 3.4 dec insertion points (destroy an owning reference)
- **slot overwrite/reassignment:** `rc_drop_reassign(old, new)` — **already done (iter-87)**.
- **scope exit for every live owned slot** — on ALL exit edges (early `return`, `break`,
  function epilogue). The returned value's source slot is **excluded** (its `inc` in 3.3
  balances the caller's new ownership).
- **container element removal** (`list_set` old elem, `list_pop` — see FATAL findings).

### 3.5 Calling convention: caller-owns-args (CPython model)
The **callee borrows** its parameters; the **caller** owns the argument values and dec's them
at its own scope exit. Rationale: minimizes RC traffic (no inc/dec per call for borrowed
args), matches the existing runtime (builtins borrow args), and makes "param slot excluded
from callee cleanup" trivially correct. The alternative (callee-owns, Swift +1/-1) doubles
RC traffic at every call boundary — rejected for NOVA's perf bar.

### 3.6 Borrow elision (perf) + the borrow-across-mutation UAF
A value loaded purely transiently (e.g. `arg0` of a reader, never stored) is **borrowed** —
no inc/dec. **BUT (adversary, fatal):** a borrow that is stored into a slot and then *used
after a mutating call on its source container* is a use-after-free:
```
let val = lst[0]        // borrowed (no inc)
lst[0] = "new"          // list_set dec's old elem → if RC==1, val is freed
print(val)              // UAF
```
**Rule:** a borrow may be elided ONLY if its live range does not cross any operation that can
mutate/free its source. If the index_get/field_get result is stored into a slot that lives
past such a point, it must be `inc`'d (promoted to owned). The self-hosted compiler already
records `ire_borrow_src[dest]` (currently inert) — full RC must READ it: a slot_store whose
source is a borrow AND whose live range crosses a mutating call emits `rc_inc`.

### 3.7 Known runtime/codegen gaps the draft missed (all must be closed atomically)
1. **FATAL #2 — channel destructor leaks buffered items.** `nova_rc_free` for
   `NOVA_MEM_CHANNEL` (L7774) does `free(ch->buf)` but never dec's the live ring items
   `[head, head+count)`. Each was deep-copied on send (RC=1, buffer-owned); recv transfers
   ownership (no dec). **FIXED THIS ITER** (see §5) — sound and needed by both paths.
2. **Channels are SHARED → RC must count both ends.** A channel captured by a spawned task is
   referenced by two processes. Dropping it in the parent without counting the child's
   capture = UAF. The spawn/closure capture MUST `rc_inc` the channel (3.3 closure-capture).
   This is why `leak_baseline`'s `chan` cannot be fixed by the conservative reassignment drop.
3. **Global slots excluded from RC** (Kotlin bootstrap L627 gates on `!isGlobal`; self-hosted
   never addresses globals). Module-level mutable heap reassigned → leaks the old value.
   Globals need overwrite-dec + alias-inc but NO scope-exit cleanup (they outlive the fn).
4. **`list_pop` + unbox** abandons a bool/float box's RC reference (low severity leak).
5. **Kotlin bootstrap closures via raw `malloc`** (no RC header) → all RC ops are no-ops.
   Only matters if the Kotlin path runs FULLRC programs; the self-hosted compiler uses
   `nova_rt_struct_alloc` (real header), and the oracle gates run the self-hosted binary, so
   this is low priority — but migrate Kotlin closures to `nova_rt_struct_alloc` before any
   claim of "FULLRC works on the Kotlin path."

### 3.8 Cycles (the RC killer) — for long-lived heaps only
Request-scoped cycles die with the arena (§2). For long-lived heaps, full RC still cannot
collect cycles (closure-captures-its-own-container, ORM parent/child). Plan, in order of
preference:
1. **Structural avoidance:** prefer tree-shaped long-lived data; provide `weak(x)` for the
   rare deliberate back-reference (exists today). Document the pattern.
2. **Trial-deletion cycle collector** (CPython `gc` model) over the *long-lived* heap only,
   run on a low-frequency tick or memory-pressure trigger. Scoped to candidate roots
   (containers/structs/closures mutated since last collection). This is a real future
   sub-project; the arena removes the urgency (the hot path never needs it).

### 3.9 Perf plan (to reach default-on)
- **Typed fast-path dec:** when the compiler KNOWS a slot is heap-typed (list/dict/str/struct),
  emit a direct header decrement that SKIPS `nova_mem_find_tag` validation (validation is only
  needed for `any`-typed values where an int can masquerade as a pointer). The adversary
  measured `find_tag` at ~30-50ns on real heap pointers (IsBadReadPtr ~100ns on Windows) vs
  the draft's ~5ns fantasy — the typed fast-path is mandatory, not optional.
- **Biased / non-atomic RC for thread-local objects:** `nova_is_multithreaded` is set
  permanently after the first `spawn`, forcing atomic RMW on ALL values even though deep-copy
  isolation means they're never shared. Use per-object "owner thread" biased RC (Swift/Python
  3.12 model) or arena-mode on the hot path (which moots it entirely).

---

## 4. Sequencing (the loop)

1. **iter-89 (THIS):** Write this doc. Ship the **channel destructor fix** (FATAL #2) — sound,
   pure-runtime, required by both mechanisms. (Observably inert until channels get freed, which
   the campaign enables — committed honestly as foundational correctness.)
2. **iter-90+:** Build the **per-request arena** (§2) — higher leverage AND lower risk than
   retrofitting atomic RC (no per-object free → the 33-UAF class is impossible). Validate with
   the arena+cycle probe oracle. This is the genuine framework-readiness unlock.
3. **iter-N:** Full atomic RC for long-lived heaps (§3), shipped atomically (inc+dec together),
   with oracles run on the FULL 432 set from the start (the narrow de-risk is what missed the
   33 UAFs in iter-88).
4. **iter-N+:** Cycle collector for long-lived heaps (§3.8) if/when measured to matter.

## 5. iter-89 deliverable: the channel destructor fix
`nova_rc_free` `NOVA_MEM_CHANNEL` case: before `free(ch->buf)`, dec each live ring item
`[head, head+count)` via `nova_rc_dec_internal(ch->buf[(ch->head + i) & (ch->cap - 1)])`.
SOUND because: (a) each live item was deep-copied on send → fresh RC=1, sole-owned by the
buffer; (b) received items already left the ring (`head` advanced, `count--`) so are never
visited → no double-free; (c) immediates (ints) → `rc_dec_internal` is a validated no-op;
(d) `cap` is always a power of two → mask `cap-1` is correct. Gated by the full 432 regression
(both flag modes — the change is flag-independent) + ASAN on channel-heavy tests.

## 6. Competitive scorecard (memory reclamation)
| Lang | Model | NOVA position |
|---|---|---|
| C | manual | NOVA: arena hot-path = manual-pool speed, zero leaks by construction; **win on safety, tie on speed**. |
| Rust | ownership/borrow, compile-time | NOVA: no lifetime annotations; arena + RC inferred. **win on simplicity, tie on safety (hot path)**. |
| Go/Java | tracing GC | NOVA: no GC pauses on hot path (arena bulk-free); RC + optional cycle GC for long-lived. **win on tail latency**. |
| Swift/CPython | RC (+gc) | NOVA: same RC for long-lived, PLUS arena hot-path they lack. **win on hot path**. |
| Erlang | per-process heap, copy on send | NOVA: same model (per-request process+arena), PLUS native code + RC for shared. **tie + win on speed**. |

The arena+RC pairing is how NOVA beats every memory model at its own strength: arena = C-pool
speed with no UAF; RC = Swift reclamation; copy-on-boundary = Erlang isolation; no GC pause.
