# NOVA Scope-Exit Reference Reclamation -- Sound Design

**Status:** DESIGN -- not yet implemented. ADVERSARY-REVIEWED; **must-fix issues found in this design (resolve BEFORE coding).**
**Author:** Compiler Architect Agent + devils-advocate review (2026-06-15, iter-96)
**Date:** 2026-06-15
**Prerequisites:** S1-S3 total-RC (NOVA_T8_FULLRC), W5b return-drop, W8 liveness

> ## ⚠ ADVERSARY VERDICT (see NOVA_DESIGN/SCOPE_EXIT_RC_ADVERSARY.json for all 12)
> The CORE INSIGHT IS SOUND — iter-88 failed because it dec'd aliased values with no
> matching inc; pairing every alias with an `rc_inc` then dec'ing at scope exit fixes
> that. BUT this design has **1 FATAL + 6 HIGH issues that MUST be resolved before
> implementation** (and A+B must ship TOGETHER — Stage A's incs alone would worsen
> leaks and trip the leak_baseline guard):
> 1. **FATAL (double-free):** S3 reassignment-drop + S4 scope-exit-drop double-dec the
>    LAST loop iteration's value. S3 and S4 are NOT cleanly disjoint — the slot's final
>    value can be dropped by both. Fix: a per-CFG-path "already dropped" set; a value
>    dropped by S3 on the last store must not be re-dropped by S4 (and vice versa).
> 2. **HIGH (leak):** `rc_inc` on every slot_store of a non-owned value inflates RC
>    without bound when the SAME value is re-stored in a tight loop (e.g. S3 reassign
>    loops) — never reaches 0. Fix: do not inc on a re-store of the same register /
>    exclude S3-reassignment stores from the inc.
> 3. **HIGH (leak):** `ire_dropped` is per-function/flat, not per-CFG-path: a drop on
>    one branch leaks on another. Fix: per-path drop tracking.
> 4. **HIGH (UAF):** a closure capturing a local that is then scope-exit-dropped — the
>    capture-inc vs return-dec must keep the captured value alive for the closure's
>    lifetime (the closure escapes). Fix: a captured local is ESCAPED -> not S4-droppable.
> 5. **HIGH (UAF):** `for_iter_init` list iterator aliases the source list; borrow-
>    marking is unsound when the source type is unknown. Fix: treat iterator source as
>    borrowed/escaped conservatively.
> 6. **HIGH (perf):** `nova_rc_inc` -> `nova_rc_is_managed` -> `nova_mem_find_tag` on
>    every slot_store is ~25ns/store — catastrophic in hot loops. Fix: typed fast-path
>    inc/dec when the slot type is statically heap (skip find_tag validation).
> 7. **HIGH (soundness):** W8 uses list_free_local/dict_free_local (no element RC) but
>    S4 uses nova_rc_dec (with element RC); mixing on different paths => RC mismatch.
>    Fix: W8 and S4 must use the SAME drop primitive, or be mutually exclusive per slot.
> **CORRECTED owned-producer whitelist (the iter-88 root cause):** ONLY fresh-element
> producers are scope-exit-droppable — split / splitlines / chars / regex_split /
> regex_find_all / string ops / make_list|dict|struct with owned contents. EXCLUDE the
> element-ALIASING producers: list_filter, list_map, dict_keys, dict_values, dict_items
> (their results share element pointers with the source — dropping them frees live data).
> **Implementation plan:** ship A+B together behind a NEW flag NOVA_T8_SCOPE (separate
> from FULLRC), full-432 ASAN from the first commit, flag-off byte-identical, flag-on
> 432/0 + leak_baseline trending DOWN. Arena objects auto-inert (NOVA_RC_ARENA_BIT).
> NOTE: the per-request ARENA already covers the framework-critical case, so this is
> for general/long-lived non-arena code -- valuable but NOT blocking Forge; land it only
> when provably sound, else keep default-OFF.

---

## 0. The Problem

NOVA's dual-path memory model has two halves:

1. **Arena path (DONE):** per-request scopes free their entire heap wholesale. Objects carry `NOVA_RC_ARENA_BIT`; rc_inc/rc_dec are no-ops on them. No per-object tracking needed.

2. **Non-arena path (THIS DESIGN):** long-running compute loops, stateful functions, servers. Temporaries allocated inside a function scope must be reclaimed deterministically when the scope exits, without leaking.

The existing S1-S3 reassignment-drop (NOVA_T8_FULLRC) handles the **loop-rebind** leak: when a slot is overwritten with a new allocation, the old value is `nova_rc_dec`'d. This reduced `leak_baseline` list/dict from ~2000 to ~1.

**The missing piece:** a function-local temporary that is allocated once and never reassigned is never freed. Example:

```
fn process(data)
    let keys = dict_keys(data)    // new list, RC=1
    let result = map(keys, transform)  // new list, RC=1
    return result
    // `keys` is never freed -- leak
```

The S3 reassignment-drop never fires because `keys` is stored once and never overwritten. W5b only fires `list_free_local`/`dict_free_local` which skip element RC. The general scope-exit RC-drop is needed.

### Why iter-88 Failed (33 UAFs)

Iter-88 attempted to add scope-exit drops by extending the `ire_owned` / `_rc_owned_producer` whitelist. It inserted `nova_rc_dec` at function exit for slots whose values came from "owned producer" functions (list_map, list_filter, dict_keys, dict_values, dict_items, split, chars, etc.).

**Root cause of all 33 UAFs:** The escape analysis conflated "the CONTAINER is freshly allocated" with "all ELEMENTS in the container are uniquely owned." This distinction is fatal:

| Function | Container fresh? | Elements fresh? | Safe to scope-drop? |
|---|---|---|---|
| `nova_rt_split(s,d)` | YES (new list) | YES (new substrings via `nova_heap_alloc`) | YES |
| `nova_rt_chars(s)` | YES (new list) | YES (new codepoint strings) | YES |
| `nova_rt_regex_split(s,p)` | YES (new list) | YES (new substrings) | YES |
| `nova_rt_list_filter(l,f)` | YES (new list) | **NO** (shared with input via `list_append` -> `rc_inc`) | **ONLY with correct RC** |
| `nova_rt_list_map(l,f)` | YES (new list) | **NO** (closure results may alias external state) | **ONLY with correct RC** |
| `nova_rt_dict_keys(d)` | YES (new list) | **NO** (shared with dict via `list_append` -> `rc_inc`) | **ONLY with correct RC** |
| `nova_rt_dict_values(d)` | YES (new list) | **NO** (shared with dict) | **ONLY with correct RC** |
| `nova_rt_list_concat(a,b)` | YES (new list) | **NO** (shared with both inputs via `rc_inc`) | **ONLY with correct RC** |

Iter-88 called `nova_rt_rc_drop_reassign(slot_value, 0)` at scope exit, which called `nova_rc_dec`. If RC was 1 (only the local slot holds it), `nova_rc_free` fires, which **recursively** dec's all elements. But the elements had RC=2 (one from the source container, one from the `list_append` rc_inc into the result container). So the recursive dec drops each element from 2 to 1 -- the source container still holds them. This is correct! The elements survive.

So why the UAF? Because **iter-88's escape analysis was wrong about WHICH slots were safe to drop.** It used `_rc_owned_producer` + `_rc_pure_arg` whitelists that missed several alias-creating patterns:

1. A slot loaded via `index_get` then stored to another slot (alias not tracked).
2. A `field_get` result stored to a local then used as a call argument (the field's parent struct still holds it, but the call might retain it).
3. A value loaded from one slot, passed to `list_append` on another slot's list (the append RC-incs, but the source slot's drop would dec without knowing about the append).

**THE ACTUAL FIX** is not to make the escape analysis smarter. It is to ensure the **RC invariant holds at every point**: `RC(v) == number of live owning references to v`. If the invariant holds, then `nova_rc_dec` at scope exit is ALWAYS safe -- it decrements the slot's reference; if other references exist (RC > 1), the value survives; if this was the last reference (RC == 1 -> 0), `nova_rc_free` fires and recursively handles children.

The problem is that NOVA's current codegen does NOT maintain the RC invariant. Specifically, many alias-creating operations (slot_store, make_list element insertion, make_struct field packing, call argument passing, closure capture) do NOT emit `nova_rc_inc`. The runtime functions (list_append, dict_set, list_concat, dict_keys, etc.) DO maintain RC internally. But compiler-generated IR does not.

---

## 1. The Calling Convention: CALLEE-OWNS-RESULT

**Decision:** Every function call returns a value that the CALLER owns (RC already accounts for the caller's reference). The callee allocated it (or rc_inc'd it before returning), so RC >= 1 upon return.

**Rationale:** This is already the de facto convention in NOVA's runtime. Every `nova_rt_*` function that returns a heap object either:
- Allocates it fresh (`nova_rt_list_create`, `nova_rt_dict_create`, `nova_rt_split`, etc.) -- RC=1, caller owns.
- Extracts elements with `list_append` which `rc_inc`'s them (`dict_keys`, `dict_values`, `list_filter`, `list_concat`) -- the returned container has RC=1, its elements have RC >= 2 (one from source, one from append).
- Returns an existing object (`nova_rt_list_get`, `nova_rt_dict_get`, `nova_rt_index_get`) -- these are BORROWS, RC is NOT bumped. Caller does NOT own.

The two categories are:
1. **Owned returns** (caller must eventually `rc_dec`): Any function that allocates a new container or object.
2. **Borrowed returns** (caller must NOT `rc_dec`): `index_get`, `field_get`, `dict_get` -- these return references still owned by the source container.

This matches Rust's convention (owned vs borrowed), Swift's convention (owned +1 vs unowned +0), and CPython's convention (new reference vs borrowed reference).

### Borrowed-to-Owned Promotion

A borrowed value becomes owned when it is stored into a slot that outlives the source. At that point, `rc_inc` must fire. The compiler detects this at slot_store time: if the stored register has `ire_borrow_src` set, and the slot is not immediately consumed, the store must be preceded by `rc_inc`.

**Critical case:** a `field_get` or `index_get` result stored to a local slot, then used after the source container is mutated or freed. Without `rc_inc`, the slot holds a dangling reference.

---

## 2. The RC Invariant

**INVARIANT (INV-RC):** At every program point, for every heap-managed value `v`:

```
RC(v) == (number of containers holding v as an element/field/capture)
       + (number of live local slots holding v where the slot OWNS v)
       + (1 if v is a function return value in transit)
```

If INV-RC holds, then `nova_rc_dec(v)` at scope-exit for slot `s` that owns `v` is ALWAYS sound:
- If `s` is the only owner: RC was 1, dec to 0, `nova_rc_free` fires (correct).
- If other owners exist: RC was > 1, dec to >= 1, value survives (correct).
- If `v` is arena-owned: `NOVA_RC_ARENA_BIT` set, `rc_dec` is a no-op (correct).
- If `v` is an immediate (int < 0x10000): `rc_dec` early-returns (correct).
- If `v` is a string pool interned string: `nova_strpool_rc_dec` handles it (correct).

**Why iter-88 violated INV-RC:** Slots holding values obtained from `index_get` or `field_get` had RC=N (where N accounts for the container's ownership but NOT the slot's ownership, because no `rc_inc` was emitted when storing to the slot). When the scope-exit drop fired `rc_dec`, it decremented from N to N-1, but N was already the exact count for the container's references alone. So the dec made RC too low by 1, and a later operation on the container's element found RC=0 prematurely.

---

## 3. rc_inc Insertion Points (Establishing INV-RC)

Every alias-creating event in the IR must emit `rc_inc` on the aliased value. Here is the COMPLETE list, keyed to the real IR ops in `nova_compiler.nova`:

### 3.1 slot_store (line ~14828)

When a value is stored to a slot, the slot takes ownership. The value's RC must reflect this.

**Rule:** At every `slot_store(value_reg, slot_name)`, emit `nova_rc_inc(value_reg)` BEFORE the store, UNLESS the value is provably a fresh allocation that the slot is its FIRST owner.

**Exemptions (no rc_inc needed):**
- `value_reg` is in `ire_owned` (make_list/make_dict/make_struct/make_closure result) -- the allocation was just created with RC=1, and this slot is its first and only owner.
- `value_reg` is the result of a CALL to a function known to return an owned value (all `nova_rt_*` functions that allocate) -- RC=1 upon return, slot is first owner.

**Requires rc_inc:**
- `value_reg` is in `ire_borrow_src` (index_get/field_get result) -- the value is borrowed from a container; storing it to a slot creates a second reference.
- `value_reg` was loaded from another slot (`ire_load_origin` is set) -- this is `let b = a`; both slots now reference the same value.
- `value_reg` is a function parameter -- the caller may still hold a reference (or may have passed it to multiple callees).

**Implementation:**

```
// In ire_emit_inst, op == "slot_store":
let need_inc = true
if contains(e.ire_owned, args[0])
    need_inc = false
if contains(e.ire_call_result_owned, args[0])
    need_inc = false
if need_inc
    ire_indent(e, "call void @nova_rc_inc(i64 " + args[0] + ")")
ire_indent(e, "store i64 " + args[0] + ", ptr %slot." + value + ", align 8")
```

**Why this is sound:** If the value is borrowed (from a container), rc_inc bumps RC from N to N+1. The slot now owns one reference. When the slot is dropped (scope-exit or reassignment), rc_dec brings RC back to N. If the container still lives, its reference (counted in N) keeps the value alive. If the value is already owned (fresh alloc), RC=1 and the slot is the sole owner; no inc needed, and a drop brings it to 0 (freed).

### 3.2 make_list Element Insertion (line ~15108)

When building a list literal `[a, b, c]`, the codegen calls `nova_rt_list_append(list, elem)` for each element. `list_append` already calls `nova_rc_inc(elem)` (line 1100 of nova_runtime.c). **No additional inc is needed at the IR level.** The runtime handles it.

However, the codegen ALSO marks the element's source slot as escaped (`ire_slot_escaped[ire_load_origin[args[i]]] = 1` at line 15127-15128). This is correct and must be RETAINED: the element is now shared between the source slot and the new list.

### 3.3 make_struct Field Packing (line ~15097)

When building a struct `Foo{x: a, y: b}`, the codegen stores field values via GEP+store. Currently, NO `rc_inc` is emitted on the field values.

**This is a latent bug.** If `a` is a heap value borrowed from another container, storing it into the struct creates a second reference without incrementing RC.

**Rule:** For each field value `args[fi]` stored into a struct, emit `nova_rc_inc(args[fi])` UNLESS `args[fi]` is in `ire_owned` (a fresh allocation being packed directly).

**Implementation (in make_struct emission, after the GEP+store):**

```
// After: ire_indent(e, "store i64 " + args[fi] + ", ptr " + gep + ", align " + str(field_align))
if not contains(e.ire_owned, args[fi])
    ire_indent(e, "call void @nova_rc_inc(i64 " + args[fi] + ")")
```

**Why:** `nova_rc_free` for structs (line 7925-7928) dec's all slots 1..N-1. So the struct's destructor will fire `rc_dec` on each field. For that dec to be balanced, the struct's construction must have fired `rc_inc` on each field it didn't freshly allocate.

**Note:** The existing escape-marking code at line 15103-15104 (`ire_slot_escaped[ire_load_origin[args[fi]]] = 1`) is correct and must be RETAINED.

### 3.4 make_closure Capture (line ~15297)

When building a closure record, captured variables are stored as fields. Currently, the codegen marks captured slots as escaped (line 15302-15303) but does NOT `rc_inc` the captured values.

**Rule:** For each captured value `args[ci]`, emit `nova_rc_inc(args[ci])` UNLESS it is in `ire_owned`.

**Why:** The closure may outlive the capturing scope. When the closure is freed (`nova_rc_free` with NOVA_MEM_STRUCT, line 7918-7930), its captures are dec'd. The inc at capture time balances this dec.

### 3.5 Call Argument Passing

Function arguments are NOT alias-creating in NOVA's current calling convention. The callee receives the value by-handle (an i64 pointer). The callee does NOT own the argument -- it borrows it for the duration of the call. If the callee needs to retain it (store into a container, return it, etc.), the CALLEE is responsible for `rc_inc`.

**This is already the case in the runtime.** `nova_rt_list_append` calls `rc_inc(elem)`. `nova_rt_dict_set` calls `rc_inc(key)` and `rc_inc(val)`. No change needed at call sites.

**Exception:** If the callee is a USER-DEFINED function that stores a parameter into a returned struct/list, the struct/list construction should rc_inc the parameter (per 3.3/3.2 above).

### 3.6 Return Value

The return value is transferred to the caller. No rc_inc is needed at the return site because the function is TRANSFERRING its ownership to the caller. The value was either:
- Freshly allocated in this function (RC=1, transferred).
- Loaded from a local slot (the slot's reference is transferred; the slot will NOT be dropped for the returned value -- see Section 4).

**No rc_inc at return.** The caller receives ownership.

### 3.7 for-in Loop Iterator Materialization

`nova_rt_for_iter_init(obj)` (line 2378) calls `nova_rt_dict_keys(obj)` for dicts (creates a new keys list, RC=1, owned by the iterator slot). For lists, it returns the list itself (NO new allocation, NO rc_inc).

**Latent issue:** When iterating a list, `for_iter_init` returns the list handle itself. The loop's iterator slot now aliases the source list. If the source list is mutated during iteration, the iterator sees the mutation (shared reference). More critically for RC: the iterator slot does NOT own the list (no rc_inc), so scope-exit must NOT drop it.

**Rule:** The iterator slot for `for-in` over a list must be marked as BORROWED (not owned). Only the dict case (where `dict_keys` allocates a fresh list) is owned.

**Implementation:** When emitting `for_iter_init`, check if the source is a known list. If so, mark the result register in `ire_borrow_src`. If dict or unknown, mark as `ire_owned` (because `dict_keys` allocates fresh).

### 3.8 Summary Table of rc_inc Points

| IR Op / Site | rc_inc emitted? | By whom? | Condition |
|---|---|---|---|
| `slot_store` of borrowed value | YES (new) | Compiler | `ire_borrow_src` or `ire_load_origin` set on stored reg |
| `slot_store` of owned/fresh value | NO | -- | `ire_owned` or `ire_call_result_owned` set |
| `make_list` element | Already done | Runtime (`list_append` -> `rc_inc`) | Always |
| `make_dict` k/v pair | Already done | Runtime (`dict_set` -> `rc_inc`) | Always |
| `make_struct` field | YES (new) | Compiler | Field reg NOT in `ire_owned` |
| `make_closure` capture | YES (new) | Compiler | Capture reg NOT in `ire_owned` |
| `call` arguments | NO | -- | Callee borrows; callee rc_incs if retaining |
| `return` value | NO | -- | Ownership transferred to caller |
| `index_set` value | Already done | Runtime (`list_set`/`dict_set` -> `rc_inc`) | Always |
| `field_set` value | YES (new) | Compiler | Must rc_inc the new value, rc_dec the old |
| `list_append` elem | Already done | Runtime | Always |
| `channel_send` value | Already done | Runtime (`deep_copy` -> fresh) | Always (deep-copied) |

---

## 4. rc_dec Scope-Exit Insertion Points

With INV-RC established (Section 3), scope-exit drops are straightforward. At every scope exit, for every slot that OWNS a value, emit `nova_rc_dec(slot_value)`.

### 4.1 Which Slots Are Owned at Scope Exit?

A slot OWNS its value if:
1. It was stored to with a value for which `rc_inc` was emitted (Section 3.1 -- borrowed/loaded values), OR
2. It was stored to with a fresh allocation (`ire_owned`) that has RC=1 and this slot is the sole owner.

In both cases, the slot owns exactly one reference. At scope exit, that reference must be released.

**Excluded from scope-exit drop:**
- Slots in `ire_slot_escaped`: The value was stored into a container (list_append, dict_set, struct field, closure capture) that outlives this scope. The container holds its own rc_inc'd reference. HOWEVER -- the slot ALSO holds a reference (the one established by the store in Section 3.1). Both references must be released independently.

**WAIT -- this is the key insight that differs from iter-88.** In iter-88, escaped slots were EXCLUDED from scope-exit drops. But with INV-RC, escaped slots CAN be dropped at scope exit because:
- The slot holds one reference (its own rc_inc or fresh alloc).
- The container holds another reference (its rc_inc from list_append/dict_set/etc.).
- Dropping the slot decrements RC by 1. The container's reference keeps the value alive (RC >= 1).

**The ONLY slot excluded from scope-exit drop is the one whose value is the return value.** The return value's reference is being transferred to the caller, so we must not dec it.

### 4.2 Scope-Exit Sites

Scope-exit drops must fire at ALL function exit edges:

1. **`return` terminator:** Drop all owned slots EXCEPT the returned value's source slot. The returned slot's reference is transferred to the caller.

2. **Function epilogue (implicit return):** Drop all owned slots. (In NOVA, functions that don't explicitly return produce 0/null, so no slot exclusion needed.)

3. **`break`/`continue` out of a loop:** These are NOT function exits. Loop-local temporaries should be dropped at loop-exit, but this is a FUTURE extension (Phase 2). For now, scope-exit means function-exit only.

4. **Exception/panic unwind:** NOVA uses `longjmp`-based panic. Stack frames are not unwound with destructors. This is a known limitation. Arena mode handles most panic-path cleanup. Non-arena panic paths leak -- acceptable for now, tracked as future work.

### 4.3 The Owned-Slot Set Computation (S4 Pre-Pass)

The S4 pre-pass determines which slots are "scope-droppable" at function exit. It runs alongside (or after) the existing S3 pre-pass.

**Algorithm:**

```
// S4 scope-exit pre-pass (runs after S3, within NOVA_T8_FULLRC gate):
let _s4_owned_slots = {}

for block in blocks:
    for inst in block.insts:
        match inst:
            // Any slot_store means this slot holds a value
            slot_store(value_reg, slot_name):
                // A slot that is stored ONLY with owned values
                // (and never with an unclassified value) is OWNED.
                if contains(ire_owned, value_reg) or contains(ire_call_result_owned, value_reg):
                    if not contains(_s4_bad, slot_name):
                        _s4_owned_slots[slot_name] = 1
                else:
                    // Stored with a borrowed/loaded/unknown value.
                    // The slot still OWNS a reference (because we emit rc_inc
                    // at store time per Section 3.1), so it is STILL droppable.
                    // BUT: only if we actually emit the rc_inc. This is gated
                    // on the rc_inc insertion being active.
                    if not contains(_s4_bad, slot_name):
                        _s4_owned_slots[slot_name] = 1

    // Disqualify slots that are used in the return terminator
    match block.terminator:
        return(args):
            if len(args) > 0:
                let ret_reg = args[0]
                // Find which slot this return value came from
                if contains(ire_load_origin, ret_reg):
                    let returned_slot = ire_load_origin[ret_reg]
                    _s4_return_exclude[returned_slot] = 1

// Final set: all stored slots minus the returned slot
e.ire_scope_drop = {}
for slot in keys(_s4_owned_slots):
    if not contains(_s4_return_exclude, slot):
        e.ire_scope_drop[slot] = 1
```

**Critical difference from S3:** S4 does NOT use the escape whitelist (list_len/index_get/field_get). S4 drops ALL owned slots at scope exit, regardless of whether the value escaped into a container. This is sound BECAUSE we now emit `rc_inc` at every alias-creation point (Section 3), so the RC count is correct.

**Critical difference from iter-88:** Iter-88 tried to drop slots WITHOUT emitting the matching `rc_inc`'s. That created a dec-without-inc: RC undercount -> premature free -> UAF. Our design inserts the `rc_inc` FIRST (Section 3), then the matching `rc_dec` at scope exit (Section 4). The inc+dec pair is atomically paired per slot.

### 4.4 Scope-Exit Drop Emission

At each `return` terminator, before emitting the actual `ret` instruction, emit drops for all slots in `ire_scope_drop`:

```
// In ire_emit_block, after emitting all instructions, before terminator:
match terminator:
    IrInst("return", _, _, targs, _, _, _, _):
        let ret_reg = ""
        if len(targs) > 0:
            ret_reg = targs[0]
        let returned_slot = ""
        if contains(e.ire_load_origin, ret_reg):
            returned_slot = e.ire_load_origin[ret_reg]
        for slot_name in keys(e.ire_scope_drop):
            if slot_name != returned_slot:
                let drop_reg = ire_fresh_tmp(e, "sdrop." + slot_name)
                ire_indent(e, drop_reg + " = load i64, ptr %slot." + slot_name + ", align 8")
                ire_indent(e, "call void @nova_rc_dec(i64 " + drop_reg + ")")
```

**Why `nova_rc_dec` and not `nova_rt_rc_drop_reassign`?** The reassign function checks `old != new` to guard self-assignment. At scope exit, there is no "new" value. A plain `nova_rc_dec` is correct. The `rc_dec` function already handles all validation (arena bit, immediates, strpool, alignment, etc.).

**Why not `nova_rt_list_free_local`/`nova_rt_dict_free_local`?** Those are UNSOUND for the general case -- they skip element RC (`free(list->data)` without dec'ing elements). The general `nova_rc_dec` -> `nova_rc_free` path recursively dec's all children. This is what makes the scope-exit drop CORRECT for containers with shared elements: the recursive dec brings shared elements' RC from 2 to 1 (source container still alive) or from 1 to 0 (freed).

---

## 5. The OWNED vs BORROWED Distinction

### 5.1 Definitions

- **OWNED reference:** The holder has a stake in the value's RC. When the holder releases the reference, it MUST `rc_dec`. Sources: fresh allocation (RC=1), explicit `rc_inc` on store.
- **BORROWED reference:** The holder does NOT have a stake in the value's RC. The holder MUST NOT `rc_dec`. Sources: `index_get` result (element still owned by container), `field_get` result (field still owned by struct), function parameters (owned by caller).

### 5.2 Transient Borrows Are Elided

When a borrowed value is used transiently (read and discarded within one expression), no `rc_inc` is needed:

```
fn example(data)
    let n = len(data[0])    // index_get(data, 0) -> borrowed; len() reads it; no alias created
    return n
```

The `index_get` result is borrowed. It flows directly into `len()` which reads it and returns an integer. No slot stores the borrowed value. No `rc_inc` needed.

### 5.3 Borrow Promotion (Borrowed -> Owned)

When a borrowed value is stored to a slot (creating a second reference), it is PROMOTED to owned via `rc_inc`:

```
fn example(data)
    let first = data[0]     // index_get -> borrowed; slot_store -> rc_inc -> owned
    mutate(data)             // data[0] might change or be freed
    return first             // safe: first has its own RC reference
```

Without promotion, `first` holds a bare pointer into `data`. If `data` is mutated (element replaced), the old element is `rc_dec`'d by `list_set`. If that was the only reference, the element is freed -- and `first` is a dangling pointer.

With promotion: `rc_inc` at store bumps RC from 1 to 2. `data` mutation dec's from 2 to 1. `first` still holds a live reference. Sound.

**Detection at compile time:** If `args[0]` of `slot_store` has `ire_borrow_src` set (populated by `index_get`/`field_get` at line 15137/15173), or has `ire_load_origin` set (loaded from another slot), emit `rc_inc`.

### 5.4 Function Parameters

Function parameters are BORROWED from the caller. The caller retains ownership. If the callee stores a parameter into a local slot (common pattern: `let x = param`), the slot_store must `rc_inc`.

BUT: the very first store of a parameter into its own slot (the implicit `let param = %p0` at function entry) is special. The caller owns the value and the callee borrows it for the function's duration. Since we want scope-exit to drop local slots, we have two choices:

**Option A (Conservative, Recommended for Phase 1):** Do NOT scope-exit-drop parameter slots. Parameters are owned by the caller; the callee must not dec them. Only drop slots that were assigned within the function body (non-parameter locals).

**Option B (Full ownership transfer):** rc_inc every parameter at function entry, then scope-exit-drop at function exit. This makes every parameter slot owned, at the cost of one rc_inc + one rc_dec per parameter per call.

**Recommendation:** Option A for Phase 1. Parameters are excluded from `ire_scope_drop`. This avoids the cost of inc+dec on every call and is simpler. Option B can be added in Phase 2 if needed for correctness in edge cases (parameter stored into a returned container where the caller's reference is released).

**Tracking:** The compiler already knows which slots are function parameters (they're the first N slot_store instructions, one per param). Mark them in a set `ire_param_slots` and exclude from `ire_scope_drop`.

---

## 6. Soundness Proof: Why This Works Where Iter-88 Failed

### 6.1 The iter-88 UAFs, Replayed Under This Design

**UAF #1: list_filter result dropped, elements alias input list.**

```
fn process(data)
    let filtered = filter(data, pred)   // RC(filtered_list)=1, elements RC=2 (input + filtered)
    return len(filtered)
    // SCOPE EXIT: rc_dec(filtered_list)
    // RC(filtered_list) 1->0 -> nova_rc_free fires
    // nova_rc_free recurses: rc_dec_internal on each element
    // element RC 2->1 (input list still holds them) -> NOT freed -> SAFE
```

Under iter-88: No rc_inc was emitted for elements (they were already rc_inc'd by list_append inside nova_rt_list_filter). The container's RC was 1. The drop fired nova_rc_free, which recursively dec'd elements from 2 to 1. Elements survived because the input list held them. **This was actually correct!**

So why did iter-88 have UAFs? Because the ESCAPE ANALYSIS was wrong about WHICH slots to drop, not about the RC arithmetic. Iter-88 dropped slots that held values obtained from `index_get` (borrowed, RC not incremented for the slot), and the dec brought RC below the true count.

Under this design: `index_get` results stored to slots get `rc_inc` at store time (Section 3.1). So even if the slot is dropped, the dec is balanced by the inc. SAFE.

**UAF #2: dict_keys result dropped, keys alias dict.**

```
fn process(d)
    let ks = dict_keys(d)    // RC(ks)=1, each key has RC=2 (dict + ks)
    let first = ks[0]        // index_get -> borrowed -> rc_inc at slot_store -> RC(key[0])=3
    // SCOPE EXIT: rc_dec(first) -> RC(key[0]) 3->2 (dict + ks still hold it) -> SAFE
    //             rc_dec(ks) -> RC(ks) 1->0 -> nova_rc_free
    //             -> rc_dec_internal each key: RC 2->1 (dict holds them) -> SAFE
    // d is a parameter, not dropped (Option A)
```

Sound. Every dec is balanced by an inc.

**UAF #3: index_get result used after source freed (the borrow-across-mutation case).**

```
fn process(data)
    let elem = data[0]       // index_get -> borrowed -> rc_inc at slot_store -> RC(elem)=2
    data[0] = new_value      // nova_rt_list_set: rc_dec(old_elem) -> RC 2->1; rc_inc(new_value)
    print(elem)              // elem still alive, RC=1 -> SAFE
    // SCOPE EXIT: rc_dec(elem) -> RC 1->0 -> freed -> correct, no more references
```

Under iter-88: No rc_inc at slot_store for the borrowed `data[0]`. So RC(elem) stayed at 1. The `data[0] = new_value` dec'd it to 0 -> freed -> `print(elem)` is UAF.

Under this design: rc_inc at slot_store bumps RC to 2. The mutation dec's to 1. Elem survives until scope-exit drop. SAFE.

### 6.2 The Invariant Preserved

For every alias-creating event, we emit `rc_inc`. For every ownership release (scope exit, reassignment, container free), we emit `rc_dec`. The two are always paired:

| Event | inc | dec |
|---|---|---|
| Fresh alloc stored to slot | implicit (RC=1) | scope-exit or reassignment |
| Borrowed value stored to slot | rc_inc at store | scope-exit or reassignment |
| Value copied between slots | rc_inc at store | scope-exit or reassignment of target |
| Element appended to list | rc_inc by list_append | nova_rc_free recurse on list death |
| Field packed into struct | rc_inc at make_struct | nova_rc_free recurse on struct death |
| Capture packed into closure | rc_inc at make_closure | nova_rc_free recurse on closure death |
| Value stored into dict | rc_inc by dict_set | nova_rc_free recurse on dict death |

**No dec-without-inc exists.** Every dec at scope-exit is balanced by either a fresh allocation (implicit RC=1) or an explicit rc_inc.

---

## 7. Atomicity: inc+dec Ship Together

**RULE:** No stage may ship `rc_dec` (scope-exit drops) without the corresponding `rc_inc` insertions (Section 3) being active in the same build.

The staged rollout (Section 9) ensures this:
- Stage A ships `rc_inc` insertions ONLY (no new drops). This can ONLY add RC overhead (more incs), never cause UAF.
- Stage B ships scope-exit `rc_dec` drops that are ONLY sound because Stage A's incs are active.
- Both stages are behind the same `NOVA_T8_SCOPE` flag. They cannot be independently toggled.

**Within a single function:** The compiler emits all `rc_inc`'s during instruction emission (Section 3), then emits `rc_dec`'s at the return terminator (Section 4). The LLVM IR is sequential; the inc's textually and dynamically precede the dec's. There is no intermediate state where a dec fires without its matching inc having already executed.

**Across function boundaries:** A callee's scope-exit drops fire before the caller receives the return value. The returned slot is excluded from drops (Section 4.2). The caller then owns the return value and is responsible for its eventual drop. No gap.

---

## 8. Interaction with Existing Infrastructure

### 8.1 S1-S3 Reassignment Drop (NOVA_T8_FULLRC)

**Relationship:** S1-S3 handles REASSIGNMENT drops (loop rebind). S4 (this design) handles SCOPE-EXIT drops. They are complementary and BOTH needed.

**Interaction:** A slot in `ire_fullrc_drop` (S3's reassignment-drop set) is ALSO in `ire_scope_drop` (S4's scope-exit-drop set). This is correct:
- During the loop, each iteration's reassignment fires `nova_rt_rc_drop_reassign(old, new)` -- dec's the old value.
- At function exit, the LAST iteration's value is still in the slot. The scope-exit drop fires `nova_rc_dec(last_value)` -- dec's it.

Both are needed. Without S3, loop iterations leak. Without S4, the last iteration leaks.

**No double-free risk:** S3 fires at slot_store time (DURING the function). S4 fires at return time (END of the function). They never fire on the same value at the same point.

**Implementation:** S4 is a separate pre-pass that computes `ire_scope_drop`. It does NOT modify `ire_fullrc_drop`. Both sets are consulted independently during emission.

### 8.2 W5b Return-Drop

**W5b** (line 15787-15839) drops local list/dict slots at return time using `nova_rt_list_free_local` / `nova_rt_dict_free_local`. These are UNSOUND for the general case (skip element RC).

**Relationship:** S4 scope-exit drops SUPERSEDE W5b. When S4 is active, W5b should be disabled (or the S4 drop should take priority).

**Implementation:** When `NOVA_T8_SCOPE` is active, skip the W5b drop path for any slot already in `ire_scope_drop`. This avoids double-freeing: S4's `nova_rc_dec` will invoke `nova_rc_free` which properly handles element RC, unlike W5b's `list_free_local`.

**Migration path:**
1. Phase 1: S4 active, W5b still fires for slots NOT in `ire_scope_drop` (fallback for edge cases S4 misses).
2. Phase 2: S4 covers all slots that W5b covered. W5b disabled entirely.

### 8.3 W8 Liveness-Based Drops

**W8** (line 15762-15786) drops slots that become dead at basic-block boundaries (mid-function). It uses the `ire_liveness` fixpoint to find slots not live-out of a block.

**Relationship:** W8 drops mid-function; S4 drops at function-exit. They are complementary. W8 can drop a slot earlier (at the block where it dies), reducing peak memory. S4 catches any slot W8 misses (e.g., a slot live until the return).

**Interaction concern:** If W8 drops a slot at block B, and S4 also drops it at the return, that's a DOUBLE DEC. 

**Fix:** W8 already tracks dropped slots in `ire_dropped` (line 15786). S4's scope-exit emission must check `ire_dropped` and skip any slot already dropped by W8:

```
for slot_name in keys(e.ire_scope_drop):
    if slot_name != returned_slot and not contains(e.ire_dropped, slot_name):
        // emit rc_dec
```

**Note:** W8 currently uses `list_free_local` / `dict_free_local` (unsound for shared elements). When S4 is active, W8 should also switch to `nova_rc_dec` for correctness. This is a Phase 2 concern.

### 8.4 Arena Mode

Arena-allocated objects have `NOVA_RC_ARENA_BIT` set in their RC field. `nova_rc_inc` and `nova_rc_dec` both early-return when this bit is set (line 7973, 7997). `nova_rc_dec_internal` also checks (line 7997).

**Consequence:** S4's scope-exit drops (which call `nova_rc_dec`) are AUTOMATICALLY INERT for arena objects. No special handling needed at the compiler level. The runtime's bit-check makes them no-ops.

**Proof:** 
1. S4 emits `nova_rc_dec(slot_value)`.
2. If `slot_value` is arena-owned, `nova_rc_dec` -> `nova_rc_dec_internal` -> checks `NOVA_RC_ARENA_BIT` -> returns immediately. No state change.
3. If `slot_value` is non-arena, normal RC dec happens. Correct.

No compiler-level arena-awareness needed for S4. The existing runtime guards handle it.

### 8.5 Interaction with S1 Specialization (Type-Driven)

The S1 type-driven specialization (PERFORMANCE_SPECIALIZATION.md) threads inferred types through to codegen. When a slot is known to hold a non-heap type (int, float, bool), the scope-exit drop can be ELIDED because immediates are not RC-managed (`nova_rc_dec` early-returns for values < 0x10000).

**Optimization (Phase 2):** If `ire_reg_types["slot." + slot_name]` is "int" or "float" or "bool", skip the scope-exit drop for that slot. Saves the call overhead.

**Phase 1:** Emit the drop unconditionally. The runtime's `nova_rc_dec` handles immediates gracefully (early return). The overhead is one function call + one comparison per immediate slot per function exit -- negligible.

---

## 9. Staged, Gated Rollout

All stages are behind `NOVA_T8_SCOPE=1` (a NEW flag, separate from `NOVA_T8_FULLRC` which controls S1-S3 reassignment-drop).

### Stage A: rc_inc Insertion (NO new drops)

**What ships:** The `rc_inc` insertions from Section 3:
- `rc_inc` at `slot_store` for borrowed/loaded values (3.1).
- `rc_inc` at `make_struct` for non-owned field values (3.3).
- `rc_inc` at `make_closure` for non-owned captures (3.4).

**What does NOT ship:** No new `rc_dec` drops. Existing S3 reassignment-drop and W5b/W8 continue unchanged.

**Effect:** RC counts are now HIGHER (more incs, same decs). Values that were previously at RC=1 may now be at RC=2 or higher. This can ONLY cause MORE leaks (values freed later or not at all), never UAF. It is MONOTONICALLY SAFE.

**Validation gate:**
- [ ] Flag-off (`NOVA_T8_SCOPE` unset): codegen is BYTE-IDENTICAL to pre-Stage-A.
- [ ] Flag-on: FULL 432-test regression PASSES under ASAN.
- [ ] Flag-on: `leak_baseline_test` still passes (leaks may be WORSE due to higher RC; that's expected).
- [ ] Flag-on: bootstrap reconverges (gen5.ll == gen6.ll).
- [ ] Flag-on: green_scale_test passes (10k tasks).

**Why gate on ALL 432 tests from day one:** Iter-88's 6-program derisking missed the 33 UAFs that only surfaced in complex programs. The FULL suite with ASAN is the ONLY valid gate.

### Stage B: Scope-Exit rc_dec Drops

**What ships:** The scope-exit `rc_dec` drops from Section 4:
- `rc_dec` at every `return` terminator for all slots in `ire_scope_drop`.
- Parameter slots excluded.
- Returned-value slot excluded.
- W8-dropped slots excluded.

**Prerequisite:** Stage A is ACTIVE (the rc_incs are in place). Stage B MUST NOT ship without Stage A.

**Effect:** Function-local temporaries are now freed at scope exit. `leak_baseline_test` should show list/dict dropping from ~1 to ~0 (the S3 reassignment-drop already handles the loop case; S4 handles the final iteration and non-loop temporaries).

**Validation gate:**
- [ ] Flag-off: codegen BYTE-IDENTICAL to Stage-A-only.
- [ ] Flag-on: FULL 432-test regression PASSES under ASAN.
- [ ] Flag-on: `leak_baseline_test` list/dict delta <= 5 (down from ~1 with S3).
- [ ] Flag-on: NEW scope-exit leak probe: a function that allocates N temporaries in sequence (not a loop) and returns one. The N-1 non-returned ones must be freed. Probe measures `live_count()` before/after call.
- [ ] Flag-on: bootstrap reconverges.
- [ ] Flag-on: green_scale_test passes.
- [ ] Flag-on: `_w5b_asan_repro` and `_w5b_selfcompile` pass (verifies no interaction bug with W5b).

### Stage C: Extend to Loop Scopes (FUTURE)

Drop loop-local temporaries at loop-exit (not just function-exit). Requires per-loop scope tracking and CFG-aware liveness. Deferred.

### Stage D: Extend to W8 Liveness Drops with Correct RC (FUTURE)

Replace W8's `list_free_local`/`dict_free_local` with `nova_rc_dec`. Requires the rc_inc infrastructure from Stage A. Deferred.

---

## 10. Performance Analysis

### 10.1 Cost of rc_inc Insertions (Stage A)

Each `slot_store` of a borrowed/loaded value adds one `call void @nova_rc_inc(i64 %val)`. The `nova_rc_inc` function:
1. Checks `nova_arena_mode` (branch, predicted not-taken for non-arena code).
2. Checks `val < 0x10000` (comparison, filters immediates).
3. Checks oddball singletons (3 comparisons, rare hit).
4. Calls `nova_rc_is_managed` -> `nova_mem_find_tag` (the expensive part: alignment check, header read, magic validation).
5. Checks `NOVA_RC_ARENA_BIT`.
6. Increments the RC field (single memory write, or atomic if multithreaded).

**Estimated cost:** ~15-25ns per inc (dominated by the `find_tag` pointer validation). For a typical function with 5 local slots, that's ~75-125ns per function call. Negligible for most code.

### 10.2 Cost of rc_dec Scope-Exit Drops (Stage B)

Each scope-exit drop adds one `load` + one `call void @nova_rc_dec(i64 %val)`. The `nova_rc_dec` function has the same validation cost as `rc_inc`, plus the potential recursive `nova_rc_free` on RC reaching 0.

**Estimated cost:** Same ~15-25ns per dec for values that survive (RC > 1 after dec). For values freed (RC -> 0), the cost is dominated by `nova_rc_free`'s recursive child dec + `free()` -- but this work is NECESSARY (the value must be freed eventually).

### 10.3 Typed Fast-Path Optimization (Phase 2)

When the compiler knows a slot's type statically:
- **Int/float/bool slots:** Skip both rc_inc and rc_dec entirely. These are immediates; RC ops early-return anyway, but the function-call overhead is wasted.
- **Known-list/dict/struct slots:** Skip the `nova_rc_is_managed` / `find_tag` validation. The pointer is known to be a managed heap object. Emit a direct header-field increment/decrement instead of calling the full validation path.

**Implementation sketch:**

```c
// New runtime function: fast rc_inc for known-heap objects (no find_tag)
static inline void nova_rc_inc_fast(int64_t val) {
    void* ptr = (void*)(uintptr_t)val;
    if (NOVA_RC_COUNT(ptr) & NOVA_RC_ARENA_BIT) return;
    if (nova_is_multithreaded) {
        InterlockedIncrement((volatile LONG*)&NOVA_RC_COUNT(ptr));
    } else {
        NOVA_RC_COUNT(ptr)++;
    }
}
```

The compiler emits `nova_rc_inc_fast` when `ire_reg_types[args[0]]` is "list"/"dict"/"struct". This skips the 4-5 validation checks in `nova_rc_inc` and goes straight to the header increment. Estimated 3-5ns per op.

### 10.4 Net Effect on GATE 4/5 Benchmarks

**Worst case (Phase 1, no typed fast-path):** ~5-10% throughput regression on functions with many local slots (e.g., the compiler itself). Acceptable because:
1. The regression only occurs with `NOVA_T8_SCOPE=1`.
2. Arena mode code (most request-handling code) is unaffected (rc ops are no-ops).
3. The typed fast-path (Phase 2) recovers most of the cost.

**Best case (Phase 2 with typed fast-path):** ~1-3% regression. Most slots hold immediates (ints/floats) and are skipped entirely. Remaining heap slots use the fast path.

---

## 11. New Runtime Functions Needed

### 11.1 LLVM Preamble Declarations (REQUIRED -- not yet present)

**CRITICAL:** `nova_rc_inc` and `nova_rc_dec` are NOT currently declared in the compiler's LLVM IR preamble. Only `nova_rt_rc_drop_reassign` is (line 16218). The C runtime declares both as `void`:

```c
void nova_rc_inc(int64_t val);   // nova_runtime.c line 540
void nova_rc_dec(int64_t val);   // nova_runtime.c line 8013
```

**Action:** Add to `ire_emit_preamble` (around line 16218, near the existing `rc_drop_reassign` declaration):

```nova
ire_line(e, "declare void @nova_rc_inc(i64) nounwind")
ire_line(e, "declare void @nova_rc_dec(i64) nounwind")
```

**Call syntax:** Unlike most `nova_rt_*` functions (declared as `i64`-returning), these are `void`. The compiler must emit:
```llvm
call void @nova_rc_inc(i64 %val)
call void @nova_rc_dec(i64 %val)
```
NOT `%tmp = call i64 @nova_rc_inc(...)`. The LLVM verifier will reject a type mismatch.

**Gate:** These declarations are ALWAYS emitted (even when `NOVA_T8_SCOPE` is off). Unused declarations are harmless in LLVM IR and ensure the linker can resolve the symbols if needed. This avoids a flag-dependent preamble change.

### 11.2 No New Runtime Functions for Stage A/B

All needed runtime functions already exist in `nova_runtime.c`:
- `nova_rc_inc(i64)` (line 7961) -- for rc_inc insertion.
- `nova_rc_dec(i64)` (line 8013) -- for scope-exit drops.
- `nova_rt_rc_drop_reassign(i64, i64)` (line 8031) -- for S3 reassignment drops (unchanged).

The Phase 2 `nova_rc_inc_fast` / `nova_rc_dec_fast` are future additions.

---

## 12. Concrete Implementation Checklist

### Files Modified

1. **`nova_compiler.nova`** (the self-hosting compiler):
   - `ire_emit_inst`, `op == "slot_store"` (~line 14828): Add rc_inc emission for non-owned values.
   - `ire_emit_inst`, `op == "make_struct"` (~line 15097): Add rc_inc for non-owned field values.
   - `ire_emit_inst`, `op == "make_closure"` (~line 15297): Add rc_inc for non-owned captures.
   - S4 pre-pass (~line 15593, after S3): Compute `ire_scope_drop` set.
   - Block emission (~line 15760, at return terminator): Emit `nova_rc_dec` for scope-drop slots.
   - Add `ire_param_slots` tracking to exclude parameters.
   - Add `ire_call_result_owned` tracking to mark call results as owned.

2. **`nova_runtime.c`**: No changes for Stage A/B. All needed functions exist.

3. **Test programs**: 
   - New `scope_exit_rc_test.nova`: allocates temporaries in a non-loop function, verifies they are freed.
   - Modified `leak_baseline_test.nova`: tighten bounds when S4 is active.

### New Compiler State (per-function, reset in `ire_emit_function`)

```
e.ire_scope_drop = {}           // S4: slots to rc_dec at function exit
e.ire_param_slots = {}          // S4: parameter slots (excluded from drops)
e.ire_call_result_owned = {}    // S4: registers holding call results (owned by caller)
```

### LLVM IR Preamble

Ensure `declare void @nova_rc_inc(i64)` is in the module declarations. Currently `nova_rc_inc` is declared somewhere -- verify the return type matches `void`.

### Flag Gating

```nova
let _scope_flag = env("NOVA_T8_SCOPE")
let do_scope = len(_scope_flag) > 0 and _scope_flag[0] == "1"
```

All rc_inc insertions (Section 3) and scope-exit drops (Section 4) are gated on `do_scope`. When off, zero code changes -- byte-identical.

---

## 13. The Scope-Exit Leak Probe (Validation Test)

```nova
// scope_exit_rc_test.nova -- validates that function-local temporaries
// are freed at scope exit when NOVA_T8_SCOPE=1.

fn make_temps(n)
    // Allocate n list temporaries. Return only the last one.
    // The first n-1 should be freed at scope exit.
    let result = []
    let i = 0
    while i < n
        let temp = [i, i+1, i+2]   // fresh list, RC=1
        if i == n - 1
            result = temp
        i = i + 1
    return result

fn dict_temps()
    // Allocate dict temporaries that are never returned.
    let d1 = {"a": 1, "b": 2}
    let d2 = {"c": 3, "d": 4}
    let ks = dict_keys(d1)         // new list, shares keys with d1
    let vs = dict_values(d2)       // new list, shares values with d2
    return len(ks) + len(vs)
    // SCOPE EXIT: d1, d2, ks, vs all dropped
    // ks elements (shared with d1) survive d1's drop via RC
    // But d1 is also dropped, so keys are freed (RC 2->1->0)

fn borrow_promote()
    // Index-get result stored to slot, source mutated, slot still valid
    let data = [10, 20, 30]
    let elem = data[0]             // borrow -> promoted to owned via rc_inc
    data[0] = 99                   // old elem rc_dec'd (2->1), new elem rc_inc'd
    let check = elem               // should be 10, not freed
    return check

fn main()
    let b0 = live_count()
    let r1 = make_temps(100)
    let after_temps = live_count()
    // 99 temporaries should have been freed; only r1's list + its 3 elements survive
    // plus r1 itself. Rough: delta should be small (< 10), not ~100.
    let temp_delta = after_temps - b0
    
    let b1 = live_count()
    let r2 = dict_temps()
    let dict_delta = live_count() - b1
    // d1, d2, ks, vs all freed. Delta should be ~0.
    
    let b2 = live_count()
    let r3 = borrow_promote()
    let borrow_delta = live_count() - b2
    
    print("scope_exit_rc: temps=" + str(temp_delta) + " dict=" + str(dict_delta) + " borrow=" + str(borrow_delta))
    
    // With NOVA_T8_SCOPE=1: temp_delta < 10, dict_delta < 5, borrow_delta < 5
    // Without: temp_delta ~ 100, dict_delta ~ 10+
    if temp_delta > 15
        print("FAIL: make_temps leaked " + str(temp_delta) + " objects (expected < 15)")
        exit(1)
    if dict_delta > 10
        print("FAIL: dict_temps leaked " + str(dict_delta) + " objects (expected < 10)")
        exit(1)
    
    assert(r3 == 10, "borrow_promote: elem should be 10, got " + str(r3))
    
    print("scope_exit_rc_test passed")
```

---

## 14. Risk Analysis

| Risk | Severity | Mitigation |
|---|---|---|
| rc_inc on immediates wastes cycles | Low | Runtime early-returns for < 0x10000. Phase 2 typed fast-path eliminates call. |
| rc_inc on arena objects wastes cycles | Low | Runtime checks NOVA_RC_ARENA_BIT, returns. Single branch per op. |
| Double-drop from W8 + S4 interaction | High | S4 checks `ire_dropped` set populated by W8. Skips already-dropped slots. |
| Double-drop from S3 + S4 interaction | None | S3 fires at slot_store (mid-function), S4 fires at return (end). Different values, different times. Last value in slot is dropped once by S4. |
| Parameter over-inc (Option B future) | Medium | Phase 1 uses Option A (exclude params). No extra inc/dec. |
| for_iter_init returning borrowed list | High | Mark for-in iterator slot as borrowed when source is a known list. Exclude from scope-exit drop. Must track in `ire_borrow_src` or a dedicated `ire_iter_borrow` set. |
| Closures capturing locals that are scope-dropped | High | Closure captures are rc_inc'd at make_closure (Section 3.4). The captured value's RC reflects both the slot and the closure. If the closure outlives the function (returned/escaped), the slot's drop dec's RC from N to N-1, but the closure's reference (N-1 >= 1) keeps it alive. Sound. |
| Self-hosting compiler performance regression | Medium | The compiler is single-threaded, non-arena. Every slot_store adds an rc_inc call. Estimate ~5-10% compile-time regression. Acceptable; Phase 2 fast-path recovers it. |
| Bootstrap divergence from new codegen | Low | Flag-off is byte-identical. Flag-on bootstrap reconvergence is a gate. |

---

## 15. Open Questions (to Resolve During Implementation)

1. **`nova_rc_inc` declaration in LLVM IR:** Verify the current LLVM declaration of `nova_rc_inc` matches `void` return type. If it's declared as `i64` (like most nova_rt_* functions), either change it or use `call i64 @nova_rc_inc(i64 %val)` and ignore the result.

2. **`for_iter_init` result is a REGISTER, not a SLOT:** The for-in loop's `for_iter_init` result (`iter_reg`) is used as an SSA register directly (passed to `index_get`), never stored to a named slot. S4 only drops SLOTS, so the iterator is never dropped. For dict iteration, `for_iter_init` calls `dict_keys` internally, allocating a fresh list that is never freed -- a pre-existing leak. **Fix (pre-requisite or Phase 1 addition):** Emit a `slot_store` of `iter_reg` into a compiler-generated slot (e.g., `__for_iter_N`) so the slot machinery picks it up. For list iteration, `for_iter_init` returns the same handle (borrowed), so the slot must be marked `ire_borrow_src` to avoid an erroneous scope-exit drop. For dict or unknown iteration, the slot is owned (fresh allocation from `dict_keys`). Detection: check `ire_reg_types[args[0]]` of the `for_iter_init` call -- if "list", mark result as borrow; if "dict" or unknown, mark as owned.

3. **Exception paths:** `nova_panic` uses `longjmp`. Stack-allocated slots' rc_dec's are skipped. Arena mode handles this. For non-arena code, panics leak. Acceptable for now; a future Phase could add unwind tables.

4. **Recursive functions:** A recursive function allocates locals on each frame. Each frame's scope-exit drops fire independently on return. No interaction concern -- each frame owns its own slots.

5. **Tail-call optimization:** If NOVA adds TCO in the future, the callee's frame replaces the caller's. The caller's scope-exit drops must fire BEFORE the tail call, not after. This requires special handling at TCO sites. Deferred.
