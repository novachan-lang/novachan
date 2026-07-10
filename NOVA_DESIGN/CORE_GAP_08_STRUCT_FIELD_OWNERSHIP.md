# CORE_GAP 0.8 — Type-Directed Struct/Closure Field Ownership

**Status:** Stage 1 (structs) ✅ CLOSED 2026-07-10 — reconverged byte-identical (gen5.ll==gen6.ll SHA
`712A475A…`), ASAN-clean, 6 probes pass. Canonical ledger row = `CORE_GAPS_2026_07_03.md` Tier 0 / 0.8.
Supersedes the "XL deferred" note in `project_struct_field_leak` memory. **The reconverge caught a real
field_set dec-old UAF (save/restore borrow) — fixed to inc-new-only; see part 5 below.** Closures =
Stage 2 (deferred). Two adjacent leaks found (container-insert + field-reassignment) tracked as follow-on.

## OUTCOME (2026-07-10) — Stage 1 closes the headline struct-field leak
`_struct_field_leak_test` listbox_delta **4000 → 2** (only the last iteration's struct + list survive).
6 adversarial probes PASS with gen4: leak (listbox=2), alias `Pair(x,x)`/reuse (n=12000, no double-free),
float+int+list mixed field (no crash — scalar slots never dec'd), enum-variant payload (delta=2, slot
mapping correct), field-reassign (delta=0 — `nova_rt_field_set` dec-old fires), field-read UAF stress
(acc exact, delta=2 — no UAF from the borrow-escape relaxation). Decisive isolation experiment: a struct
rebind WITHOUT a field read already gave delta=2 (rc_free frees struct + field); the residual 4000 was
purely FULLRC pinning the struct because `len(y.v)` on an any-typed field lowers to `nova_rt_len_any(
borrow)` — fixed by the field-read-drop below.

Two implemented parts:
1. **Ownership** (rc_free bitmap dec + `nova_rt_field_set` inc/dec + make_struct MOVE/SHARE) — releases a
   struct's managed fields when it is dropped.
2. **FULLRC field-read-drop** — a field/element BORROW consumed only by read-only ops/calls no longer
   pins the owning struct as non-droppable (precise escape blacklist: escapes only via make_*/field_set/
   index_set/user-call/call_by_name/dyn_call/nova_rt_-value-arg(ai>0)/spawn).

### ADJACENT PRE-EXISTING GAP found (NOT 0.8, track separately)
`push(container, freshHeapValue)` LEAKS the element's creation ref: `list_append` unconditionally inc's
(rc 1→2) but the fresh temp's original rc=1 is never dropped, so after a container-drop dec (rc→1) it is
stuck. General to any heap element (a list of fresh lists leaks 2001 on BOTH gen4 AND gen3 — pre-existing,
independent of 0.8). It is the DUAL of the make_struct MOVE fix: `list_append`/`dict_set` should MOVE a
fresh-owned temp (no inc) or the compiler should drop the consumed temp. A struct pushed into a container
therefore still leaks (struct + field = 2/elem) until this is fixed. Candidate new Tier-0 row.

## The bug (verified against current code, 7-agent map + direct reads)
A struct's/closure's **managed heap fields (list/dict/string/bytes/nested-struct/any) are never
released on death outside arenas** → leak. Two consistent halves:
1. `make_struct` (nova_compiler.nova ~16777) stores fields **raw, no `rc_inc`** → NON-OWNING.
2. `nova_rc_free`'s `case NOVA_MEM_STRUCT` (nova_runtime.c 9899) is **dead for nslots>0**: the switch
   keys on the RAW packed tag `(nslots<<3)|5` which never equals `5`, so real structs hit `default:`
   (header freed, fields not dec'd).
Balanced today (no inc ↔ no dec) = leak-but-safe. Arena-masked in Forge (per-request arena → rc no-op
→ wholesale free), so it bites only **non-arena struct churn** (compute/CLI/game, the compiler itself).

## Why the naive "enable the dec loop" is a landmine
`make_struct` is non-owning → dec'ing at free over-releases **aliased** fields (double-free) and feeds
**raw float** field bits to `rc_dec` (the kind=2 float-list hazard: double bit patterns collide with the
heap-pointer range and pass `find_tag`).

## The fix — mirror the PROVEN list ownership model
Lists already solve exactly this: `list_append` **rc_inc's** the element (owning), `rc_free`'s
`NOVA_MEM_LIST` case dec's elements but **skips kind=2 (float)**, and the element's source slot is kept
alive (escaped) / dropped by FULLRC exactly as needed. We make structs behave **identically**.

**Managed predicate** (canonical, already used by `_allscalar` at 19026): a field is MANAGED iff its
`type_ann ∉ {int, float, bool}`. Covers string/list/dict/bytes/user-struct/user-enum/`any`/`val`/`""`.
Excluding `float` is the load-bearing safety property (raw double bits must never reach `rc_dec`).
`any`/`""` are conservatively MANAGED — inc/dec are symmetric no-ops on a raw int, correct on a pointer,
and `any` never holds raw float bits (floats box at any-widen).

### MOVE vs SHARE — the load-bearing refinement (verified via leak_baseline + FULLRC pre-pass)
The leak-free mechanism is **FULLRC dropping the OLD slot value on reassign** (`rc_drop_reassign`, a
dec). A struct field's source is released ONLY if it is a droppable slot — but a value escaping into
`make_struct` is marked **bad → non-droppable** by the FULLRC pre-pass (17345), and a fresh temp is not a
slot at all. So an **unconditional** inc would leave the source ref unreleased → still leaks. Resolution,
keyed on `ire_load_origin` (fresh-temp vs slot):
- **Fresh temp** (arg ∉ `ire_load_origin`, e.g. `Box([1,2])`): **MOVE** — NO inc; the struct takes the
  temp's rc=1; `rc_free` dec → 0. Closes the leak (this is exactly what `_struct_field_leak_test` uses).
  Aliasing is impossible (a fresh result is single-use).
- **Slot value** (arg ∈ `ire_load_origin`, e.g. `let a=[..]; Box(a)`): **SHARE** — inc + keep escaped;
  `rc_free` dec releases the struct's +1; the source slot keeps its own ref (safe; leaks 1 — identical to
  how a list element sourced from a slot behaves). Aliasing-safe: `Pair(x,x)` = 2 inc ↔ 2 dec.
`rc_free` **always** dec's managed slots (bitmap) — releasing the moved-or-shared ref uniformly.
In NORMAL mode structs still leak as today (slot reassign doesn't dec → struct never freed → not-worse,
guarded); the leak closes in FULLRC (default). `field_set` mirrors this via a `do_inc` flag.

### Compiler (nova_compiler.nova)
1. **make_struct (~16777):** for each managed field (per `e.ire_s5_sdefs[value]` positional type, non
   repr_c): if the field arg ∈ `ire_load_origin` (slot-sourced) → emit `call void @nova_rc_inc(i64
   <fieldreg>)` (SHARE) + KEEP escaped-marking; else (fresh temp) → NO inc (MOVE). Scalar fields
   unchanged.
2. **field_set (AstToIr ~9889):** thread the field type into the IrInst `typ` (currently `void`) via
   `b.ir_field_types[mstype+"."+value]` (`""` if receiver type unknown).
3. **field_set (emitter ~16862):** if field type ∈ {int,float,bool} → inline store (unchanged, keeps
   SROA struct-math fast — all-scalar SROA structs stay 100% inline). Else (managed OR unknown receiver)
   → `call i64 @nova_rt_field_set(ptr, slot, val, do_inc)` where `do_inc = (val ∈ ire_load_origin ? 1 :
   0)` (self-classifying managed via bitmap; MOVE fresh / SHARE slot). Keep escaped-marking when slot-src.
4. **@main registration (~19340):** in the existing `keys(e.ire_struct_types)` loop (already excludes
   repr_c), compute `mask` by walking `b.ir_sdefs[st_name]` Params — set bit `(fi+1)` iff managed, clamp
   to 63 — and if `mask != 0` emit `call void @nova_rt_register_struct_bitmap(i64 hash, i64 mask)`.
5. **ire preamble (~18057):** declare `nova_rc_inc`, `nova_rt_field_set`, `nova_rt_register_struct_bitmap`.

### Runtime (nova_runtime.c)
6. **Registry** (near name registry ~15814): `g_struct_bitmap_hashes[]` + `g_struct_bitmaps[]` (uint64) +
   `g_struct_bitmap_count`; `nova_rt_register_struct_bitmap(hash,mask)` (idempotent linear scan);
   `nova_struct_bitmap_for_hash(hash)` → mask or **0 if absent** (0 = dec nothing = safe default).
7. **rc_free (9812):** before the switch — `if ((tag & 0x7) == NOVA_MEM_STRUCT) { nova_rc_free_struct(ptr);
   return; }`. Helper: `mask = bitmap_for_hash(slots[0]); for i in 1..min(nslots,64): if (mask>>i)&1
   nova_rc_dec_internal(slots[i]); free header;`. (Closures: slot0=fn_ptr → not found → mask 0 → dec
   nothing → status-quo leak until Stage 2.)
8. **nova_rt_field_set(struct_val, slot, newv, do_inc):** `mask=bitmap_for_hash(slots[0]); if slot<64 &&
   (mask>>slot)&1 { old=slots[slot]; if(do_inc) nova_rc_inc(newv); slots[slot]=newv; nova_rc_dec(old); }
   else slots[slot]=newv;`. **inc-before-dec** when sharing (aliasing-safe, mirrors `list_set`); MOVE when
   `do_inc==0` (fresh temp, new value already uniquely owned).

## Why it's sound (balance, both modes)
Every managed field: **+1 at construct (inc), −1 at free (bitmap dec)**; the source's own ref is dropped
once by FULLRC (default) — or kept-alive in NORMAL exactly as list elements are. `field_set` is
inc-new/dec-old. Consistency guarantee: construction-inc slots, `rc_free` dec slots, and
`nova_rt_field_set` managed slots are **all derived from the identical predicate over the identical
`ir_sdefs`** (compile-time) / the identical bitmap (runtime) → they cannot disagree.
- Aliasing `Pair(x,x)`: 2 inc + (1 source-drop) + 2 dec = balanced, no double-free.
- Reuse `Box(x); Box(x)`: 2 inc + 1 source-drop + 2 dec = balanced.
- Reassign `s.f = y`: inc y, dec old — balanced.
- `(tag&0x7)==5` uniquely identifies structs/closures: enum kinds are {0..8}; only STRUCT has low-3==5
  (BYTES=8→low3=0). No collision.

## Adversarial-review resolutions (devils-advocate pass, 2026-07-10)
- **CRITICAL-1/3 (closure fn_ptr / repr_c first-field collide with a registered hash → wrong bitmap):**
  ELIMINATED structurally via a **HASHED tag bit** (bit 15 of the tag word, freed by clamping struct
  nslots 0x1FFF→0xFFF; `NOVA_STRUCT_NSLOTS` masks it). Only `nova_rt_hashed_struct_alloc` (used by
  make_struct for non-repr_c, non-aligned structs) sets it. `rc_free` does the bitmap lookup ONLY when
  `(tag & HASHED)` — so closures (fn_ptr slot0) and repr_c/aligned structs (no hash) NEVER do a lookup on
  a non-hash value. Memory safety no longer depends on hash non-collision for these. `deep_copy` preserves
  the HASHED bit onto the copy. make_struct's inc/move is gated on the SAME hashed condition (non-hashed
  structs stay non-owning = status-quo leak, safe).
- **SERIOUS-2 (64-field bitmap overflow → UB shift + leak):** mask sets bit `(fi+1)` ONLY for `fi < 63`;
  make_struct inc/move ONLY for `fi < 63`. Fields ≥63 stay non-owning (safe leak, logged-rare). No C
  shift ≥64 (guarded in the NOVA mask computation, where `1<<64` is also broken).
- **SERIOUS-3 (transient-register field leak):** RESOLVED by MOVE — a fresh temp field (∉ ire_load_origin)
  is moved (no inc), so `MyStruct([1,2,3])` is balanced (struct takes rc=1, rc_free dec→0). The adversary
  reviewed the older unconditional-inc design.
- **CONCERN-1 (linear-scan `bitmap_for_hash` per free):** only HASHED managed-field structs reach it;
  gated on `mask != 0`; all-scalar structs are SROA-stackable (never freed). Measured via GATE 4/5; a hash
  table is the fallback if it regresses.
- **CONCERN-4 (enum variant layout):** verified — variants use slot0 = type-hash (the discriminant IS the
  hash; `match` reads `__type_hash` at slot 0), fields at slot 1+, extra_slots=1, so `(fi+1)` mapping is
  correct. Pinned by a managed-payload enum probe.

## Collision profile (CRITICAL-2 only, accepted, = existing reflection registry)
Bitmap keyed by slot0 = DJB2 type hash (arbitrary int64). Two type hashes colliding, or a repr_c first
field / closure fn_ptr colliding with a registered hash → wrong mask. Probability ~2⁻⁶⁴ per pair; the
**existing** `nova_rt_register_struct_name` registry already carries this exact exposure. Fail direction
is usually a leak (unregistered→0). A collision that dec's a float slot is the same residual risk
`deep_copy` already carries. Below the noise floor.

## Stage 2 (separate validated commit): closures
Closures share the struct free path but slot0=fn_ptr (no type hash) and captures are lowered untyped
(`any`, boxed → never raw floats). Register `tramp_ptr → all-managed mask (bits 1..N)` at @main, inc all
captures at make_closure. Because captures are boxed, a uniform dec of capture slots is safe (int→no-op,
pointer→correct) — no per-capture type needed. Deferred until Stage 1 is proven rock-solid.

## Validation gate
- `_struct_field_leak_test`: listbox_delta ~4000 → ~O(1) (tighten to hard assert). intbox still ~0.
- NEW `_struct_alias_field_test`: `Pair(x,x)` + reuse-x-in-two-structs → correct values, no double-free
  (ASAN), no leak.
- NEW `_struct_float_field_test`: churn a struct with a `float` field → no crash (float slot never dec'd).
- `struct_rc_test` (nested/list-of-struct churn) becomes a **live** double-free probe — must stay stable.
- `_struct_arena_masked_test`: still ~0 (arena masking intact).
- 1146/0 NORMAL + 1146/0 FULLRC. Reconverge gen5.ll == gen6.ll. ASAN clean. GATE 4/5 within tolerance.
