Good. `nova_rt_str_concat` allocates via `nova_heap_alloc` with RC=1, returns the pointer. The caller gets an owned string. But there is NO `nova_rc_inc` on inputs `a` or `b` -- they are borrowed for the duration of the call and the result is a fresh allocation. This is important.

Now I have everything I need. Let me write the complete design document.

# NOVA Full Total Reference Counting Design

## NOVA_DESIGN/FULL_TOTAL_RC.md

Here is the complete implementable design document:

---

## 0. Problem Statement

A NOVA web server handling 100k requests leaks ~16,000 heap objects per request handler invocation (measured: forge handler live_count delta 16,359 at baseline). After 1M requests the process consumes gigabytes of unreachable memory. This is a framework-readiness blocker: a production server (Forge, meant to beat Spring Boot / Django) MUST hold flat memory.

The root cause is that NOVA's generated LLVM IR performs `store i64 <new>, ptr %slot.X` without ever calling `nova_rc_dec` on the old value that `%slot.X` held. Every reassignment of a heap-typed local variable is a leak. This affects ALL heap types: list, dict, struct, closure, channel, and string.

Two prior attempts failed:
- **Conservative drop (Stage 3, NOVA_T8_FULLRC)**: Only drops slots proven always-OWNED and never-ESCAPED. Ceiling: ~97% of temporaries escape into calls (e.g., `items` flows to `json_obj(items)`) so conservative analysis cannot touch them. Result: leak moved from 16,359 to 15,960 -- a 2.4% improvement, not the 99%+ needed.
- **Aggressive drop without counting**: Attempted to drop values at scope exit without maintaining reference counts. Result: 33 use-after-free crashes across the test suite. Root cause: without counting aliases, you cannot know when a drop is safe.

**The correct mechanism is full reference counting**: every alias increments RC, every alias-end decrements RC. Then RC=0 implies exactly zero live references, and `nova_rc_free` is safe BY CONSTRUCTION. This is how CPython, Swift ARC, and Objective-C ARC work.

---

## 1. The Invariant

**RC INVARIANT**: For every managed heap object `obj` at any program point, `NOVA_RC_COUNT(obj) == N` where `N` is the exact number of live owning references to `obj`. When `N` drops to 0, the object is freed immediately by `nova_rc_free`.

Every insertion point below is justified by showing it preserves this invariant: every operation that CREATES a new reference emits `nova_rc_inc`, every operation that DESTROYS a reference emits `nova_rc_dec`. Balanced inc/dec implies:
- **No double-free**: An object is freed when RC transitions from 1 to 0 (via `nova_rc_free`). After free, the RC header is deallocated. Any subsequent `nova_rc_dec` on a dangling pointer returns early from `nova_mem_find_tag` (fails range/magic/rc-sanity check). The only path to `nova_rc_free` is `RC_COUNT <= 0` which requires a prior successful decrement.
- **No use-after-free**: A reference is only valid while the owning slot/register holds it. The compiler emits `nova_rc_dec` only when the slot is being OVERWRITTEN or the scope is being EXITED. At that point, no further reads from that slot are possible in the current scope. If another alias exists (another slot or a container element), that alias's `nova_rc_inc` keeps RC >= 1.
- **No leak** (except cycles): If an object is unreachable, then all references that once held it have been overwritten or their slots have been cleaned up at scope exit. Each such event decremented RC. Since RC started at 1 (from `nova_heap_alloc`) and each subsequent alias incremented RC by 1, the total decrements equal the total aliases created, bringing RC to 0. The object is freed.

---

## 2. Calling Convention: Callee-Borrows

**Convention**: The CALLER owns arguments. The CALLEE borrows them for the duration of the call. The callee does NOT increment RC on its parameters and does NOT decrement them on return.

**Rationale** (CPython uses this same convention; Swift's +1/+1 convention is the opposite):
- **Fewer RC operations**: A function call `f(x)` requires ZERO RC traffic on `x` at the call boundary. The caller's slot still holds `x` (keeping RC >= 1) for the entire call duration. This eliminates 2 RC operations per argument per call.
- **Compatible with NOVA's existing codegen**: The Kotlin bootstrap (LlvmCodegen.kt line 472-473) already treats parameters as aliases (borrowed). The self-hosted compiler (nova_compiler.nova line 15702-15703) stores params via `store i64 %pN, ptr %slot.pname` without any `nova_rc_inc`. This convention matches what both compilers already emit.
- **Return values are OWNED by the caller**: A function that returns a heap value transfers ownership to the caller. If the returned value was freshly allocated within the callee, its RC is already 1. If the returned value was loaded from a callee-local slot, the callee must `nova_rc_inc` it before returning (to prevent the return-cleanup from freeing it). This is what the Kotlin bootstrap already does (LlvmCodegen.kt line 1922-1924: `call void @nova_rc_inc(i64 ${v(returnValue)})` for non-scalar returns).

**Implication for callees that RETAIN an argument** (e.g., `nova_rt_list_append(list, elem)` stores `elem` into the list): The runtime function itself calls `nova_rc_inc(elem)` (nova_runtime.c line 1017). This is correct: the list now holds a new owning reference, so RC must increase. This is already implemented in all relevant runtime functions (`nova_rt_list_append`, `nova_rt_dict_set`, `nova_rt_list_set`, `nova_rt_list_insert`).

---

## 3. Owned vs. Borrowed

### Definitions

- **OWNED reference**: A slot or register that holds a heap pointer for which it is responsible for eventually calling `nova_rc_dec`. Fresh allocations (`nova_heap_alloc` returns RC=1, the allocating register OWNS it), values received from function returns (caller OWNS the returned value), and values that have had `nova_rc_inc` called for them (the incrementing slot OWNS one count).

- **BORROWED reference**: A register that holds a heap pointer but is NOT responsible for calling `nova_rc_dec`. This occurs in exactly two situations:
  1. **Function parameters**: The caller's slot maintains ownership. The callee's parameter binding borrows for the call duration.
  2. **Field/element reads** (`field_get`, `index_get`): The container still owns the element. The loaded register borrows it. This borrow is only valid as long as the container is alive and unmodified.

### When a borrow must be PROMOTED to owned

If a borrowed value is stored into a new slot (`slot_store`), the slot takes ownership and must `nova_rc_inc`. Specifically:
- If a `field_get` result is stored into a local variable (via `slot_store`), the `slot_store` emits `nova_rc_inc` on the stored value.
- If a function parameter is stored into a different local variable, the store emits `nova_rc_inc`.
- If a borrowed value is returned from a function, the return emits `nova_rc_inc` (it becomes owned by the caller).

### The elision rule for borrows

A borrowed value that is ONLY used transiently -- read from a container, passed to a function call, never stored into a slot or returned -- requires ZERO RC operations. No `nova_rc_inc` on the read, no `nova_rc_dec` after the call. This is safe because:
- The container holding the value keeps RC >= 1 for the entire expression.
- The callee borrows the argument (per convention) and does not dec it.

**Implementation**: The existing `ire_borrow_src` dict (nova_compiler.nova line 14332) tracks borrowed registers. A register in `ire_borrow_src` that is used ONLY as:
- An argument to a `call` (borrowed by callee)
- An operand of a `Binary`/`Unary` operation (pure computation, no ownership transfer)
- An argument to `ToString` (read-only)

...is ELIDED: no `nova_rc_inc` at the read site, no `nova_rc_dec` after use. If the register is stored into a slot, returned, captured by a closure, or stored into a container, the borrow is promoted to owned (inc emitted).

---

## 4. Exact `nova_rc_inc` Insertion Points

Every point where a NEW owning reference is created. Each is keyed to the real IR op string.

### 4.1. `slot_store` of a value into an RC-managed slot (op `"slot_store"`, nova_compiler.nova ~14820)

**When**: The stored value `args[0]` is an aliasRef (it already has an owner elsewhere). AliasRefs include:
- Values loaded from another slot (`slot_load` results, tracked by `ire_load_origin`)
- Function parameters (have external owner)
- `field_get` / `index_get` results (owned by container)
- Values that are stored into multiple slots

**What to emit**: `call void @nova_rc_inc(i64 <value>)` BEFORE the `store i64 <value>, ptr %slot.<name>`.

**Why**: The slot is taking ownership of the value. The original owner (the source slot, the container, the caller) still holds its reference. Two owners means RC must be 2. The `nova_rc_inc` makes this so.

**Elision**: If the value is a fresh allocation (`make_list`, `make_dict`, `make_struct`, `make_closure` result, tracked by `ire_owned`) being stored into its FIRST and ONLY slot, no `nova_rc_inc` is needed -- the allocation's RC=1 IS the slot's ownership. This is the common case (`let x = [1,2,3]`).

### 4.2. `make_struct` field stores (op `"make_struct"`, nova_compiler.nova ~15058)

**When**: A struct field value `args[fi]` is a borrowed or aliased value (not a fresh allocation or a scalar).

**What to emit**: `call void @nova_rc_inc(i64 <field_value>)` after the `store i64 <field_value>, ptr <gep>`.

**Why**: The struct now holds a reference to the field value. The original owner (the source slot) still holds its reference. Two owners means RC must increase. The Kotlin bootstrap already does this (LlvmCodegen.kt line 1714-1716: `if (fieldRef in aliasRefs) appendLine("  call void @nova_rc_inc(i64 ${v(fieldRef)})")`).

**Elision**: If the field value is a fresh allocation being consumed (it will not be used again after the struct construction), the inc is unnecessary -- the allocation's RC=1 transfers to the struct. Detect via: the register is in `ire_owned` AND has no `ire_load_origin` AND is not used by any subsequent instruction.

### 4.3. `make_closure` capture stores (op `"make_closure"`, nova_compiler.nova ~15275)

**When**: A captured value `args[ci]` is a borrowed or aliased value.

**What to emit**: `call void @nova_rc_inc(i64 <capture_value>)` after the `store i64 <capture_value>, ptr <cap_gep>`.

**Why**: The closure record now holds a reference. The captured variable's original slot still holds its reference. Same rationale as struct fields. The closure may outlive the creating function.

### 4.4. `make_list` element appends (op `"make_list"`, nova_compiler.nova ~15100)

**Status**: ALREADY HANDLED. `nova_rt_list_append` (nova_runtime.c line 1017) calls `nova_rc_inc(elem)` internally. When the list is non-escaping and uses `nova_rt_list_append_no_rc`, the element's RC is not incremented -- but the list and its elements are freed together at scope exit, so this is sound.

No additional compiler-side `nova_rc_inc` needed for `make_list`.

### 4.5. `return` of a slot-loaded value (op `"return"`, nova_compiler.nova ~15379)

**When**: The returned value was loaded from a local slot (`ire_load_origin` has an entry for it). The slot will be cleaned up (RC decremented) at function exit. The caller will ALSO own the returned value. Two owners.

**What to emit**: `call void @nova_rc_inc(i64 <return_value>)` BEFORE the slot cleanups and BEFORE the `ret i64`.

**Why**: The return transfers ownership to the caller. The slot cleanup will `nova_rc_dec` the slot's reference. Without the inc, the dec would free the object before the caller could use it. The Kotlin bootstrap already does this (LlvmCodegen.kt line 1922-1924).

**Elision**: If the returned value is a fresh allocation (in `ire_owned`, no `ire_load_origin`), it was never stored in a cleanable slot (or was stored but will be skipped during cleanup), so no inc is needed.

### 4.6. `copy` op creating a second reference (op `"copy"`, nova_compiler.nova ~15267)

**Status**: The `copy` op emits `add i64 <src>, 0` (identity). It does NOT create a new owning reference by itself -- it creates an SSA alias. The ownership transfer happens when the copy result is stored into a slot (handled by 4.1) or returned (handled by 4.5).

No standalone `nova_rc_inc` for `copy`.

### 4.7. Container mutation runtime functions

**Status**: ALREADY HANDLED by the runtime.
- `nova_rt_list_append` (line 1017): `nova_rc_inc(elem)`
- `nova_rt_dict_set` (line 1888, 1902-1903): `nova_rc_inc(val)` and `nova_rc_inc(key)` on insert; `nova_rc_dec(old_val)` and `nova_rc_inc(new_val)` on update
- `nova_rt_list_set` (searched): `nova_rc_dec(old)`, `nova_rc_inc(new)` on overwrite
- `nova_rt_list_insert`: `nova_rc_inc(elem)`

No additional compiler-side insertion needed for these.

---

## 5. Exact `nova_rc_dec` Insertion Points

Every point where an owning reference is destroyed.

### 5.1. `slot_store` overwrite (op `"slot_store"`, nova_compiler.nova ~14820)

**When**: A heap-typed slot `%slot.X` is being overwritten with a new value.

**What to emit** (BEFORE the store):
```
%old.X = load i64, ptr %slot.X, align 8
call void @nova_rc_dec(i64 %old.X)
```

**Why**: The slot is dropping its reference to the old value and taking a reference to the new value. The old value loses one owner.

**Guard**: Skip if the slot is known-scalar (I64, F64, Bool, Unit via `isKnownScalar` / the float-slot pre-pass). Skip the FIRST store to a slot in the entry block (the slot was zero-initialized, and `nova_rc_dec(0)` is a no-op but wastes cycles). The Kotlin bootstrap already does this (LlvmCodegen.kt line 627-630).

**Self-store guard**: If `old == new`, the dec+inc would be a no-op (dec frees if RC was 1, but then inc on a freed object is UB). Use the existing `nova_rt_rc_drop_reassign` which checks `oldv != newv` (nova_runtime.c line 7900-7903), OR emit an `icmp eq` + conditional branch to skip the dec. The `nova_rt_rc_drop_reassign` approach is simpler and already battle-tested.

### 5.2. Function exit cleanup -- every `return` terminator (op `"return"`, nova_compiler.nova ~15379)

**When**: At every `return` instruction, before `ret i64 <value>`.

**What to emit**: For EACH local slot (params + locals) that is heap-typed and not the returned value's source slot:
```
%cleanup.X = load i64, ptr %slot.X, align 8
call void @nova_rc_dec(i64 %cleanup.X)
```

**Why**: The function is ending. Every local slot's reference is being destroyed. The slot's value loses one owner. If this was the last owner (RC drops to 0), `nova_rc_free` deallocates.

**Return value slot**: The returned value's source slot is EXCLUDED from cleanup dec, because the return-inc (section 4.5) and the cleanup-dec would cancel out. Instead, simply skip both: the slot's ownership transfers directly to the caller. This is an optimization the Kotlin bootstrap already implements (LlvmCodegen.kt line 1925-1931 iterates `rcSlots`; the self-hosted W5b code at line 15806-15809 skips `returned_slot`).

**Parameter slots**: Parameters are BORROWED (callee does not own them). The callee's parameter slot cleanup should NOT emit `nova_rc_dec` for parameter slots, because the callee never incremented RC for them. Exception: if a parameter slot was REASSIGNED within the function body (e.g., `fn f(x) { x = [1]; ... }`), then the slot now holds a different value (the fresh list) that IS owned, and the cleanup must `nova_rc_dec` the current value. Track this: if a parameter slot has ANY `slot_store` instruction targeting it (beyond the initial entry-block store), treat it as a regular local slot for cleanup purposes.

### 5.3. Early return / break / continue -- all exit edges

**Implementation**: Section 5.2 handles ALL `return` terminators (the self-hosted compiler emits cleanup before each `ret`). For `break` and `continue` (which are `goto` terminators to the loop exit/header), the values in local slots remain live -- they are not destroyed by `break`/`continue` because the enclosing function scope is still active.

However, for BLOCK-SCOPED variables (e.g., variables defined inside an `if` branch that go out of scope at the branch exit), NOVA currently does NOT emit cleanup at the branch merge point. This is because NOVA's IR uses FUNCTION-scoped slots (all allocas are hoisted to the entry block), not block-scoped slots. A variable defined inside an `if` branch shares the same `%slot.X` as the rest of the function.

**Consequence**: Block-scoped temporaries will be cleaned up at the function's return, not at the block exit. This is slightly leaky within the function body (a temporary created in iteration 1 of a loop is not freed until the next iteration overwrites the slot, or at function exit). The slot-store overwrite (5.1) handles the loop case. For non-loop blocks, the function exit handles it. This is acceptable for Stage 1 and matches CPython's behavior (local variables live until function exit or reassignment).

### 5.4. Container element removal (runtime-side)

**Status**: ALREADY HANDLED by the runtime:
- `nova_rc_free` for LIST (nova_runtime.c line 7753-7754): iterates all elements, calls `nova_rc_dec_internal` on each
- `nova_rc_free` for DICT (line 7762-7764): iterates all keys and values, calls `nova_rc_dec_internal` on each
- `nova_rc_free` for STRUCT (line 7798-7799): iterates slots 1..N-1, calls `nova_rc_dec_internal` on each
- `nova_rt_dict_set` update case (line 1886): `nova_rc_dec(old_val)` before overwriting
- `nova_rt_list_set` (implicit): dec old element before store

No additional compiler-side insertion needed.

---

## 6. Escape Analysis Elision (Performance)

The existing escape analysis (`ir_escape_analysis` at nova_compiler.nova ~12541, `IrEscapeAnalysis.kt` at line 34) identifies non-escaping allocations. These allocations are confined to the current function and cannot be aliased by external code.

### Non-escaping lists/dicts: zero RC traffic

For allocations in `ire_local_lists` (the `local_set` from escape analysis):
- `nova_rt_list_append_no_rc` is used instead of `nova_rt_list_append` (already implemented, nova_compiler.nova ~14993-15017)
- `nova_rt_dict_set_no_rc` is used instead of `nova_rt_dict_set` (already implemented)
- At function exit, these are freed via `nova_rt_list_free_local` / `nova_rt_dict_free_local` which free the container and its backing storage directly (no RC dec on elements)
- No `nova_rc_inc` / `nova_rc_dec` is ever emitted for these containers or their element stores

### Non-escaping structs: stack allocation (SROA)

For allocations in `ire_stackable` (escape analysis Stage 4):
- Structs are stack-allocated via entry-block alloca (already implemented, nova_compiler.nova ~15070-15074)
- No RC header, no `nova_rc_inc` / `nova_rc_dec`
- Freed automatically when the stack frame is popped

### RC traffic estimate for a typical request handler

Consider a handler that:
1. Parses a JSON body (1 dict + ~5 string keys + ~5 values = 11 allocations)
2. Queries a database (1 result list + ~10 row structs + ~50 field values = 61 allocations)
3. Builds a response (1 dict + ~8 key/value pairs = 17 allocations)
4. Total: ~89 heap allocations

Without escape analysis, full RC would add:
- Per `slot_store` overwrite: 1 load + 1 `nova_rc_dec` call (the load is the old value)
- Per `slot_store` of alias: 1 `nova_rc_inc` call
- Per function exit: ~N loads + ~N `nova_rc_dec` calls for N live slots
- Estimate: ~100-200 RC operations per handler (at ~5ns each via the `nova_mem_find_tag` fast-path = ~0.5-1.0 microsecond total)

With escape analysis elision (typical: 40-60% of allocations are non-escaping):
- ~50-120 RC operations per handler = ~0.25-0.6 microseconds

For context: a Go HTTP handler with GC does ~2-5 microseconds of GC-related work per request. A Spring Boot handler does ~10-50 microseconds of GC work. NOVA's full RC at 0.5-1.0 us is competitive with Go and 10-50x better than JVM GC pause amortization.

---

## 7. Cycles

### Can NOVA form reference cycles?

**Yes**, in exactly these patterns:

1. **Dict-to-struct cycle**: `let d = {}; let s = MyStruct(ref=d); d["back"] = s`. The dict holds the struct (via `nova_rt_dict_set` which `nova_rc_inc`s `s`), and the struct field holds the dict. If both have RC=2 (one from the local slot, one from the other container), dropping the local slots decrements each to RC=1. Neither reaches 0. **LEAK**.

2. **Closure-list cycle**: `let lst = []; let f = fn() { push(lst, 1) }; push(lst, f)`. The closure captures `lst` (stored in the closure record, `nova_rc_inc`d at 4.3). The list contains `f` (`nova_rc_inc`d by `nova_rt_list_append`). Same RC=2 situation. **LEAK**.

3. **Struct self-reference via dict**: A struct field pointing to a dict that points back to the struct.

### What CANNOT form cycles

- **Immutable structs without dict fields**: NOVA structs are assigned at construction time only. A struct cannot be made to point to itself post-construction because `field_set` requires the struct to already exist. HOWEVER, if a struct field holds a DICT, and that dict is mutated after construction to point back to the struct, a cycle forms.
- **Lists of scalars**: No heap references, no cycles.
- **Strings**: Immutable, no internal references.
- **Channels**: Deep-copied on send (nova_runtime.c ~3780), so cross-process cycles are impossible. Within a single process, a channel object itself does not reference other NOVA objects (its buffer contains deep-copied values).

### The plan: accept-and-bound for v1, backup-collect for v2

**v1 (this design)**: Accept that cycles are possible but BOUNDED in practice.

**Argument for bound**: Most NOVA programs (web handlers, CLI tools, compute pipelines, AI inference) create tree-shaped data: request objects, response objects, result lists. Cycles require deliberate construction (`d["self"] = d` or closure-over-container-containing-closure). In the web handler hot path, data flows request-to-response linearly.

**Mitigation for v1**:
- The existing `weak()` / `weak_deref()` runtime functions (nova_rt_weak_* in nova_runtime.c) are available for users who knowingly create cyclic structures.
- Arena mode (`NOVA_AUTO_ARENA=1`) provides a complete bypass for short-lived programs.
- Per-request arenas (future): A handler can wrap its request processing in an arena scope, deallocating all request-local memory in one shot at handler exit. This eliminates per-request leaks entirely (cycles included) without a cycle collector.

**v2 (future, post-framework-launch)**: Trial deletion cycle collector.
- A backup collector based on CPython's gc module design: objects that participate in potential cycles (dicts, closures, structs with dict/closure fields) are placed in a "potentially cyclic" generation list.
- Periodically (every N allocations or on explicit `gc_collect()`), run trial deletion: tentatively decrement all objects in the generation, see which reach 0 (those are in cycles), free them.
- This is a well-understood algorithm (CPython has used it since 2.0, ~25 years of production hardening).
- NOT needed for v1 framework readiness because per-request arenas eliminate the leak.

---

## 8. Interaction with Existing Systems -- What is Replaced, What is Reused

### REPLACED: W5b return-time auto-drop (NOVA_T8_DROP)

The W5b code at nova_compiler.nova lines 15779-15833 emits `nova_rt_list_free_local` / `nova_rt_dict_free_local` for specific local slots at return time. This is SUBSUMED by full RC's function-exit cleanup (section 5.2), which emits `nova_rc_dec` for ALL heap-typed slots.

**Delete**: The entire `do_w5b` conditional block (lines 15794-15833). The `NOVA_T8_DROP` environment variable becomes a no-op.

**Delete in Kotlin bootstrap**: The `emitRcCleanup` method body at LlvmCodegen.kt lines 1918-1941 is replaced by the new full-RC cleanup.

### REPLACED: Stage 3 conservative reassignment drops (NOVA_T8_FULLRC conservative pass)

The pre-pass at nova_compiler.nova lines 15585-15641 that identifies always-OWNED-never-ESCAPED slots and gates `nova_rt_rc_drop_reassign` at line 14827-14830. This is SUBSUMED by full RC's slot-store overwrite (section 5.1), which emits `nova_rc_dec` on EVERY heap-typed slot overwrite, regardless of escape status.

**Delete**: The pre-pass (lines 15585-15641), the `ire_fullrc_drop` dict (line 14334), and the conditional drop at slot_store (lines 14827-14830). The `NOVA_T8_FULLRC` environment variable is REPURPOSED to gate the new full-RC system.

### REUSED: Escape analysis (ir_escape_analysis, IrEscapeAnalysis.kt)

The escape analysis continues to identify non-escaping allocations for RC ELISION (section 6). No changes needed.

### REUSED: ire_owned, ire_borrow_src metadata

`ire_owned` (line 14333) continues to track fresh allocations. Used to determine if a `slot_store` needs `nova_rc_inc` (section 4.1: fresh allocation into first slot = no inc needed).

`ire_borrow_src` (line 14332) continues to track borrowed values. Used to determine if a transient read needs RC operations (section 3: transient borrows are elided).

### REUSED: ire_load_origin, ire_slot_escaped

`ire_load_origin` continues to track which slot a value was loaded from. Used to determine the returned-slot skip (section 5.2) and to track alias chains.

`ire_slot_escaped` is NO LONGER NEEDED for its original purpose (gating which slots W5b can drop). However, it can be reused as optimization metadata: an escaped slot's value might have RC > 1 (other references exist), so the dec at function exit will decrement but not free. This is not an unsoundness issue, just a performance consideration.

### REUSED: _no_rc variants for non-escaping containers

`nova_rt_list_append_no_rc` and `nova_rt_dict_set_no_rc` continue to be used for non-escaping containers (gated by `ire_local_lists`). No changes.

### REUSED: SROA stack allocation for non-escaping structs

Stack-allocated structs (`ire_stackable`) bypass RC entirely. No changes.

### REUSED: W8 liveness-based mid-function drops

The W8 pass (nova_compiler.nova lines 15754-15778) computes liveness and drops dead local-list/dict slots mid-function. Under full RC, W8 becomes an OPTIMIZATION: instead of waiting until function exit to dec a dead slot, W8 decs it as soon as it becomes dead. This reduces peak memory within a function.

**Modification**: W8 should emit `nova_rc_dec` instead of `nova_rt_list_free_local` / `nova_rt_dict_free_local`. The `nova_rc_dec` is always safe (handles all types, pointer-validated). The type-specific free functions bypass RC and are only valid for non-escaping containers; under full RC, all containers should go through `nova_rc_dec`.

### Interaction with M:N scheduler

No interaction. RC operations are per-value, per-thread (or per-carrier-thread with green tasks). The existing `nova_is_multithreaded` flag gates atomic vs. non-atomic RC operations. Green tasks on the same carrier thread share a single OS thread, so their RC operations are non-contending.

Values transferred between green tasks via `channel_send` are deep-copied (nova_runtime.c ~3780), so no cross-task RC sharing occurs. This is unchanged.

### Interaction with channel deep-copy isolation

No interaction. Deep-copy creates fresh allocations with RC=1 for the receiver. The sender's original values retain their RC. Completely orthogonal.

### Interaction with typed-IR specialization (S1)

Scalar-typed slots (proven-int, proven-float via `ire_reg_types["slot.X"] == "float"`) are EXCLUDED from RC operations because they hold raw values, not heap pointers. This already works via `isKnownScalar` checks (Kotlin bootstrap, LlvmCodegen.kt line 626-627) and the float-slot pre-pass (nova_compiler.nova ~15556-15584).

Full RC does not change this: scalar slots get zero RC traffic. The specialization pass's identification of float/int slots directly reduces RC overhead.

---

## 9. Staged Rollout

### Flag: `NOVA_T8_FULLRC=1`

All stages are gated behind this environment variable. When the flag is OFF (default), the compiler emits ZERO additional RC operations beyond what is currently emitted. The generated LLVM IR is BYTE-IDENTICAL to the flag-off baseline. This is verified by the bootstrap convergence check (gen5.ll == gen6.ll comparison).

### Oracles (run at EVERY stage, EVERY commit)

| Oracle | Command | Pass criterion |
|--------|---------|---------------|
| **Flag-off byte-identical** | Compile nova_compiler.nova with flag OFF, compare .ll to baseline | .ll files are byte-identical |
| **Flag-on 432/0** | Full regression suite (ALL 432+ tests) with flag ON | 432/432 pass, 0 fail |
| **ASAN gate** | Compile regression suite with `-fsanitize=address` (clang) under flag ON, run all 432 tests | 0 ASAN errors (heap-use-after-free, double-free, leak-check disabled) |
| **leak_baseline oracle** | Run `leak_baseline_test.nova` with flag ON | `list_delta < 10`, `dict_delta < 10`, `chan_delta < 10` (down from ~2000 baseline) |
| **_forge_readiness** | Run a simulated request loop (100 iterations of handler), measure `live_count()` delta per request | `per_request_delta < 5` (down from ~16,000 baseline) |
| **Bootstrap reconvergence** | Compile nova_compiler.nova with flag ON, bootstrap gen5→gen6, compare gen5.ll vs gen6.ll | gen5.ll == gen6.ll (the self-hosted compiler under full RC produces identical output) |

**Critical**: The ASAN gate runs over the FULL test suite, not a subset. The previous Stage 3 de-risked on 6 programs and missed 33 UAFs in the broader suite. This must never happen again.

### Stage A: slot_store overwrite dec (self-hosted compiler)

**What**: At every `slot_store` to a heap-typed, non-scalar, non-first-store slot, emit:
```
%old.X = load i64, ptr %slot.X, align 8
call i64 @nova_rt_rc_drop_reassign(i64 %old.X, i64 <new_value>)
```

**Where** (nova_compiler.nova ~14820-14831): Replace the existing Stage 3 conditional block:
```
// OLD (delete):
if contains(e.ire_fullrc_drop, value)
    let _frc_old = ire_fresh_tmp(e, "frcold." + value)
    ...

// NEW:
if is_fullrc_on
    if not is_first_store_in_entry(value)
        let _frc_old = ire_fresh_tmp(e, "frcold." + value)
        ire_indent(e, _frc_old + " = load i64, ptr %slot." + value + ", align 8")
        ire_indent(e, "call i64 @nova_rt_rc_drop_reassign(i64 " + _frc_old + ", i64 " + args[0] + ")")
```

**Where** (LlvmCodegen.kt ~622-634): The Kotlin bootstrap already emits this for rcSlots. Modify: when `NOVA_T8_FULLRC=1`, ALL heap-typed slots are rcSlots (not just those identified by the conservative `rcSlots` set -- which already includes most heap-typed slots, LlvmCodegen.kt line 454-462). This should be a near-no-op change since `rcSlots` already captures most heap slots.

**How to determine "first store in entry"**: Track a per-slot `first_store_seen` dict. The first `slot_store` to a slot within the `entry` block is the initialization store (the slot was zero-initialized by `store i64 0, ptr %slot.X`). Skip the dec on this store. All subsequent stores emit the dec.

For parameter slots (initialized by `store i64 %pN, ptr %slot.pname` in entry), also skip the dec on the initial store. Track: `entry_stores[slot_name] = true` after the first store in the entry block.

**Expected result**: The `leak_baseline_test` should drop from ~2000 to ~0 for list/dict. Channel may still leak because channel creation inside a loop creates a new channel each iteration, and channels have internal state (mutex, buffer) that is more complex. But the container leak is the primary target.

**Oracles**: All 6 oracles pass.

### Stage B: function-exit cleanup dec (self-hosted compiler)

**What**: Before every `return` terminator, emit `nova_rc_dec` for every local heap-typed slot (excluding the returned value's source slot and parameter slots that were never reassigned).

**Where** (nova_compiler.nova ~15779-15833): Replace the W5b block with:
```
if is_fullrc_on
    match terminator
        IrInst(top, _, _, targs, _, _, _, _) =>
            if top == "return"
                let ret_arg = ""
                if len(targs) > 0
                    ret_arg = targs[0]
                let returned_slot = ""
                if contains(e.ire_load_origin, ret_arg)
                    returned_slot = e.ire_load_origin[ret_arg]
                // Inc the return value if it came from a slot (ownership transfer to caller)
                if returned_slot != "" and not is_known_scalar(ret_arg)
                    let ret_inc = ire_fresh_tmp(e, "retinc")
                    ire_indent(e, ret_inc + " = load i64, ptr %slot." + returned_slot + ", align 8")
                    ire_indent(e, "call void @nova_rc_inc(i64 " + ret_inc + ")")
                // Dec all local slots except returned slot and unmodified param slots
                for slot_n in all_local_slots  // params + locals
                    if slot_n != returned_slot
                        if not (is_param(slot_n) and not was_reassigned(slot_n))
                            let cleanup_reg = ire_fresh_tmp(e, "cleanup." + slot_n)
                            ire_indent(e, cleanup_reg + " = load i64, ptr %slot." + slot_n + ", align 8")
                            ire_indent(e, "call void @nova_rc_dec(i64 " + cleanup_reg + ")")
```

**Where** (LlvmCodegen.kt ~1918-1941): Extend `emitRcCleanup` to cover ALL heap-typed slots (not just `rcSlots`), add return-value inc, add parameter-slot exclusion logic.

**Auxiliary tracking**: Add a per-function `reassigned_params` set. A parameter is "reassigned" if there is any `slot_store` to `%slot.<param_name>` beyond the initial entry-block store.

**Expected result**: Functions that create temporaries and return early will now clean up all their locals. The `_forge_readiness` oracle should show near-zero per-request live-delta.

**Oracles**: All 6 oracles pass.

### Stage C: alias-inc on slot_store of borrowed/aliased values (self-hosted compiler)

**What**: When storing a value into a heap-typed slot, and the value is NOT a fresh allocation (not in `ire_owned`), emit `nova_rc_inc` on the stored value.

**Where** (nova_compiler.nova ~14820, after the dec emission from Stage A):
```
// After the dec of old value and before the store:
if is_fullrc_on
    if not contains(e.ire_owned, args[0])
        ire_indent(e, "call void @nova_rc_inc(i64 " + args[0] + ")")
```

**Where** (LlvmCodegen.kt ~622-634): The Kotlin bootstrap already does this via the `aliasRefs` check (line 631-633). Ensure the `aliasRefs` set is comprehensive: it should include ALL values not in a "fresh allocation" set (the inverse of `ire_owned`).

**Why this is Stage C, not Stage A**: Stages A and B are CONSERVATIVE (they only add dec operations, never inc). A missing dec is a leak (benign), not a UAF. Stage C adds inc operations, which if WRONG (incrementing a non-heap value) could cause a later dec to corrupt memory. However, `nova_rc_inc` is already pointer-validated (it no-ops on non-heap values), so the risk is low. The reason for staging is that Stage A+B alone may achieve the leak target, and Stage C is the "correctness completion" that makes the invariant fully hold.

**Expected result**: All RC invariants hold. The leak_baseline should already be near-zero from Stage A. Stage C closes the soundness gap (ensures RC is never UNDER-counted, which would cause premature free).

**Oracles**: All 6 oracles pass.

### Stage D: struct/closure field inc (self-hosted compiler)

**What**: When constructing a struct or closure, emit `nova_rc_inc` for each field/capture that is an aliased value (not a fresh allocation).

**Where** (nova_compiler.nova ~15089-15097, after `store i64 <field>, ptr <gep>`):
```
if is_fullrc_on
    if not contains(e.ire_owned, args[fi]) and not is_known_scalar_reg(args[fi])
        ire_indent(e, "call void @nova_rc_inc(i64 " + args[fi] + ")")
```

Similarly for make_closure captures (lines ~15287-15296).

**Where** (LlvmCodegen.kt ~1714-1716): Already implemented for `MakeRecord` fields. Ensure it covers all non-scalar, non-fresh-allocation fields.

**Expected result**: Structs that hold references to shared values correctly increment RC, preventing premature free of shared values.

**Oracles**: All 6 oracles pass.

### Stage E: Return-value inc (self-hosted compiler)

**What**: When returning a value loaded from a slot, emit `nova_rc_inc` on the return value before the function-exit cleanup.

**This is part of Stage B** (the return-value inc is emitted in the same block as the exit cleanup). Listed separately for implementation clarity.

### Stage F: W8 upgrade to nova_rc_dec (self-hosted compiler)

**What**: The W8 liveness pass (lines 15754-15778) currently emits `nova_rt_list_free_local` / `nova_rt_dict_free_local` for dead slots. Replace with `nova_rc_dec` for ALL heap-typed dead slots (not just list/dict).

**Where** (nova_compiler.nova ~15770-15778):
```
// OLD:
if w8_kind == "list"
    w8_fn = "nova_rt_list_free_local"
else if w8_kind == "dict"
    w8_fn = "nova_rt_dict_free_local"

// NEW:
if is_fullrc_on
    // All heap-typed dead slots get nova_rc_dec
    let w8_reg = ire_fresh_tmp(e, "dl." + w8_slot)
    ire_indent(e, w8_reg + " = load i64, ptr %slot." + w8_slot + ", align 8")
    ire_indent(e, "call void @nova_rc_dec(i64 " + w8_reg + ")")
    e.ire_dropped[w8_slot] = 1
```

**Expected result**: Dead slots are cleaned up mid-function, reducing peak memory. This is a pure optimization; correctness is guaranteed by the function-exit cleanup.

### Stage G: Default ON

Once all oracles pass consistently across 3 consecutive CI runs and the bootstrap compiler self-hosts under full RC:

1. Flip `NOVA_T8_FULLRC` default to ON
2. Remove the environment variable check; full RC is always active
3. Delete dead code: the old W5b block, the old Stage 3 pre-pass, the `ire_fullrc_drop` dict
4. Gate 4/5 benchmarks must pass (see section 10)

---

## 10. Performance Plan for GATE 4/5 Compliance

**GATE 4**: Single-process code matches C performance (erasure).
**GATE 5**: Compiled programs match C/Rust benchmarks.

### RC overhead per benchmark

| Benchmark | Hot loop heap allocations | RC ops added | Overhead estimate |
|-----------|--------------------------|--------------|-------------------|
| fib(40) | 0 (all scalar) | 0 | 0% |
| sum_to(1B) | 0 (all scalar) | 0 | 0% |
| sieve(10M) | 1 list + append calls | Already RC'd by list_append | ~0% additional |
| matmul(300) | 0 (all scalar in hot loop) | 0 | 0% |
| primes(1M) | 0 (all scalar in hot loop) | 0 | 0% |

**Why RC overhead is near-zero for Gate 4/5 benchmarks**: All five benchmarks operate on scalars (integers, floats) in their hot loops. Heap allocations occur at setup (creating the list/array) but not per-iteration. The `isKnownScalar` check (LlvmCodegen.kt line 626, nova_compiler.nova float-slot pre-pass) ensures that scalar-typed slots get ZERO RC operations.

### Broader performance considerations

For heap-intensive programs (JSON parsing, string processing, web handlers), the added RC operations are:
- **load + call per slot overwrite**: ~5-10ns (the `nova_rt_rc_drop_reassign` call validates the pointer, decrements, and possibly frees). This is ~10x the cost of a bare store (0.5ns). However, it replaces an INFINITE leak, so the alternative is not "no cost" but "eventual OOM."
- **call per function exit per heap slot**: ~5-10ns per slot. A typical function has 3-8 heap-typed locals, so ~15-80ns per function exit. Compared to function call overhead (~5-10ns for the call/ret pair), this is 3-16x the function overhead.

### Mitigation strategies (ordered by impact)

1. **Scalar-slot elision** (already implemented): Slots holding I64, F64, Bool, Unit get zero RC. This covers 60-80% of all slots in typical programs.

2. **Non-escaping container elision** (already implemented): Containers that don't escape get `_no_rc` variants and direct-free. This covers 30-60% of heap containers.

3. **SROA stack allocation** (already implemented): Non-escaping all-scalar structs are stack-allocated. Zero RC.

4. **First-store skip** (Stage A): The first store to a slot in the entry block skips the dec (the slot held 0, `nova_rc_dec(0)` is a no-op but still costs the call overhead). This eliminates one useless call per slot per function.

5. **Owned-value inc skip** (Stage C): Fresh allocations stored into their first slot skip the inc (RC is already 1). This eliminates one call per allocation.

6. **Batch cleanup** (future optimization): Instead of individual `nova_rc_dec` calls per slot at function exit, emit a single call to a batch cleanup function: `nova_rc_batch_dec(ptr slots_array, i64 count)` that decrements all slots in a loop. This reduces call overhead from N calls to 1 call + N decrements. The loop is branch-prediction-friendly (predictable iteration count) and cache-friendly (sequential memory access).

7. **Deferred decrement** (future optimization): Instead of decrementing immediately on overwrite, push the old value onto a per-thread "deferred dec" stack. Periodically (at function boundaries or every N allocations), flush the stack. This batches the `nova_mem_find_tag` validation cost. Measured in CPython: deferred RC reduces RC overhead by 30-40%.

### GATE 4/5 compliance argument

All five gate benchmarks operate on scalars in their hot loops. Full RC adds zero overhead to them (scalar-slot elision). For heap-intensive programs, the overhead is bounded by the number of heap-typed slot operations (overwrites + function exits), which is proportional to the number of heap allocations. Since each heap allocation already costs ~50-100ns (malloc + header init), the additional ~5-10ns per RC operation is a 5-20% overhead on heap-heavy code. This is within the Gate 5 10% tolerance for most benchmarks and can be brought within tolerance via the batch/deferred optimizations above.

---

## 11. Implementation Checklist (for the implementor)

### Prerequisites (verify before starting)

- [ ] Read `nova_runtime.c` lines 7832-7903 (RC operations)
- [ ] Read `LlvmCodegen.kt` lines 440-510, 615-640, 1918-1941 (Kotlin bootstrap RC)
- [ ] Read `nova_compiler.nova` lines 14820-14900, 15058-15100, 15275-15298, 15370-15412, 15585-15641, 15779-15837 (self-hosted compiler RC)
- [ ] Verify `leak_baseline_test.nova` baseline: `list_delta ~2000, dict_delta ~2000, chan_delta ~2000`
- [ ] Verify current test count: `432/432` (or current count)

### Stage A implementation steps

1. Add `is_fullrc_on` flag check at the top of `ire_emit_function` (nova_compiler.nova ~15596):
   ```
   let is_fullrc_on = false
   let _fullrc_flag = env("NOVA_T8_FULLRC")
   if len(_fullrc_flag) > 0 and _fullrc_flag[0] == "1"
       is_fullrc_on = true
   ```
   Pass `is_fullrc_on` to the slot_store handler (store in `e` struct or pass as local).

2. Add `entry_stores` tracking: a dict mapping slot names to whether they've been stored in the entry block.

3. In `slot_store` handler (line ~14820), replace the Stage 3 conditional:
   ```
   if is_fullrc_on and not contains(entry_stores, value)
       // Not first store in entry block -> dec old value
       let _frc_old = ire_fresh_tmp(e, "frcold." + value)
       ire_indent(e, _frc_old + " = load i64, ptr %slot." + value + ", align 8")
       ire_indent(e, "call i64 @nova_rt_rc_drop_reassign(i64 " + _frc_old + ", i64 " + args[0] + ")")
   if label == "entry"
       entry_stores[value] = 1
   ```

4. In `LlvmCodegen.kt` `SlotStore` handler (line ~622), add the same logic gated by the `NOVA_T8_FULLRC` environment variable.

5. Run all 6 oracles.

### Stage B implementation steps

1. Compute `reassigned_params`: scan all `slot_store` instructions for parameter slot names that appear outside the entry block.

2. Before EACH return terminator (in the block loop, line ~15779), emit:
   ```
   // Return-value inc (if from a slot)
   if returned_slot != ""
       emit nova_rc_inc(load from returned_slot)
   
   // Cleanup all heap-typed slots
   for each slot in (params + locals):
       if slot != returned_slot:
           if slot is param AND not in reassigned_params:
               skip  // borrowed, not our reference
           else:
               emit nova_rc_dec(load from slot)
   ```

3. Delete the old W5b block (lines 15794-15833).

4. In `LlvmCodegen.kt`, replace `emitRcCleanup` with the equivalent logic.

5. Run all 6 oracles.

### Stage C implementation steps

1. In `slot_store` handler, after the dec and before the store:
   ```
   if is_fullrc_on and not contains(e.ire_owned, args[0])
       // Storing an aliased/borrowed value -> inc to claim ownership
       ire_indent(e, "call void @nova_rc_inc(i64 " + args[0] + ")")
   ```

2. In `LlvmCodegen.kt`, the `aliasRefs` check (line 631-633) already handles this. Verify it is comprehensive.

3. Run all 6 oracles.

### Stage D implementation steps

1. In `make_struct` handler (line ~15089), after each field store:
   ```
   if is_fullrc_on and not contains(e.ire_owned, args[fi])
       ire_indent(e, "call void @nova_rc_inc(i64 " + args[fi] + ")")
   ```

2. In `make_closure` handler (line ~15287), after each capture store:
   ```
   if is_fullrc_on and not contains(e.ire_owned, args[ci])
       ire_indent(e, "call void @nova_rc_inc(i64 " + args[ci] + ")")
   ```

3. In `LlvmCodegen.kt`, `emitMakeRecord` (line 1714-1716) already does this. Verify `emitMakeClosure` also does it (it may need addition -- the current code at line 1290-1293 stores captures without inc).

4. Run all 6 oracles.

---

## 12. File Locations Summary

| File | Lines | What changes |
|------|-------|-------------|
| `nova-compiler/test_programs/nova_compiler.nova` | ~14820-14890 | `slot_store`: add overwrite-dec + alias-inc |
| `nova-compiler/test_programs/nova_compiler.nova` | ~15058-15098 | `make_struct`: add field-inc |
| `nova-compiler/test_programs/nova_compiler.nova` | ~15275-15298 | `make_closure`: add capture-inc |
| `nova-compiler/test_programs/nova_compiler.nova` | ~15379-15411 | `return`: delete W5b, add exit-cleanup |
| `nova-compiler/test_programs/nova_compiler.nova` | ~15585-15641 | Delete Stage 3 pre-pass |
| `nova-compiler/test_programs/nova_compiler.nova` | ~15754-15778 | W8: upgrade to `nova_rc_dec` |
| `nova-compiler/test_programs/nova_compiler.nova` | ~15779-15833 | Delete W5b block |
| `nova-compiler/src/main/kotlin/nova/ir/LlvmCodegen.kt` | ~454-490 | `rcSlots`/`aliasRefs`: expand to all heap slots |
| `nova-compiler/src/main/kotlin/nova/ir/LlvmCodegen.kt` | ~622-640 | `SlotStore`: add fullrc-gated overwrite-dec |
| `nova-compiler/src/main/kotlin/nova/ir/LlvmCodegen.kt` | ~1266-1296 | `MakeClosure`: add capture-inc |
| `nova-compiler/src/main/kotlin/nova/ir/LlvmCodegen.kt` | ~1687-1720 | `MakeRecord`: verify field-inc |
| `nova-compiler/src/main/kotlin/nova/ir/LlvmCodegen.kt` | ~1918-1941 | `emitRcCleanup`: rewrite for full RC |
| `nova-compiler/test_programs/output/nova_runtime.c` | ~7900-7903 | `nova_rt_rc_drop_reassign`: no change (reused) |
| `nova-compiler/test_programs/leak_baseline_test.nova` | 1-37 | Tighten bounds after full RC lands |

---

## 13. Correctness Argument (Formal)

### Statement

Let `R(obj, t)` = the reference count of object `obj` at program point `t`. Let `L(obj, t)` = the number of live owning references to `obj` at program point `t`.

**Claim**: For all managed heap objects `obj` and all reachable program points `t`: `R(obj, t) = L(obj, t)`.

### Base case

At allocation time `t0`: `R(obj, t0) = 1` (set by `nova_heap_alloc`). `L(obj, t0) = 1` (the allocating register/slot owns it). `R = L`.

### Inductive cases

For each program operation that changes `L` or `R`:

| Operation | L change | R change | R = L preserved? |
|-----------|----------|----------|-------------------|
| `slot_store(slot, val)` where val is fresh (owned) | +1 (slot gains ref) | 0 (RC already 1 from alloc) | Yes: L was 1 (alloc register), becomes 1 (slot). The alloc register is dead after the store. |
| `slot_store(slot, val)` where val is alias | +1 (slot gains ref) | +1 (nova_rc_inc) | Yes |
| `slot_store` overwrite (old value) | -1 (slot drops old ref) | -1 (nova_rc_dec on old) | Yes |
| Function exit cleanup (slot dec) | -1 (slot dies) | -1 (nova_rc_dec) | Yes |
| `make_struct` field store (alias val) | +1 (struct gains ref) | +1 (nova_rc_inc) | Yes |
| `make_struct` field store (fresh val) | +1 (struct gains ref), -1 (alloc register dies) | 0 (no inc; alloc RC=1 transfers to struct) | Yes: net L change = 0. |
| `make_closure` capture (alias val) | +1 (closure gains ref) | +1 (nova_rc_inc) | Yes |
| `list_append(list, elem)` | +1 (list gains ref to elem) | +1 (runtime nova_rc_inc in list_append) | Yes |
| `dict_set(dict, key, val)` | +1 per key/val | +1 per key/val (runtime nova_rc_inc) | Yes |
| `return(val)` from slot | +1 (caller gains ref) | +1 (nova_rc_inc before cleanup) | Yes |
| `return(val)` fresh alloc | +1 (caller gains ref), -1 (callee's implicit register ref dies) | 0 (RC=1 from alloc transfers to caller) | Yes: net L=0 change. |
| `field_get` / `index_get` (transient borrow) | 0 (no new owner; container still owns) | 0 (no inc/dec) | Yes |
| `field_get` result stored into slot | +1 (slot gains ref) | +1 (nova_rc_inc at slot_store of alias) | Yes |
| `channel_send(val)` | 0 (deep copy creates new obj, sender keeps original) | 0 (deep copy sets RC=1 on copy) | Yes (for original: unchanged; for copy: new object with R=L=1) |

### Termination

When `R(obj, t)` reaches 0, all owning references have been destroyed. `nova_rc_free` is called, which recursively decrements child references (the "deep free" at nova_runtime.c lines 7750-7806). Each child's `R` decreases by 1, and if it reaches 0, it too is freed. This is a depth-first traversal of the ownership tree, which terminates for acyclic structures.

For cyclic structures: `R` never reaches 0 (see section 7). This is the known limitation of reference counting, accepted with the mitigation plan described there.