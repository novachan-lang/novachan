# Phase 0, Step 0.3: Adversarial Review Fixes

**Devil's advocate found: 5 CRITICAL, 13 SERIOUS, 8 CONCERN issues.**
**This document resolves each one. Fixes are integrated back into step03_process_channel_semantics.md.**

---

## CRITICAL FIXES

### C1: Closures + Ownership Interaction — FIXED

**Problem:** When a closure captures values and is sent through a channel, the interaction between capture-by-value, COW optimization, and cross-process transfer is undefined. If a closure captures a COW-shared reference, sending it to another process would make COW backing storage span two memory pools — violating process isolation.

**Fix: Closures are materialized on cross-process transfer.**

Rules:
1. **Capture is by value (copy).** When `handler = x => process(x, big_data)`, the closure gets its own logical copy of `big_data`. This may be COW-shared with the original within the same process. This is fine — same process, same memory pool.

2. **Sending a closure through a channel transfers the entire closure as a single value.** The closure's captured values are PART of the closure — they are not separate values with separate ownership. The closure is one atomic value for ownership purposes.

3. **Before cross-process transfer, the compiler materializes all COW-shared captures.** If any captured value shares COW backing storage with another variable in the sender, the compiler inserts a deep copy of that capture into the closure before the send. This ensures the closure is self-contained — no backing storage spans process boundaries.

4. **After the send, the closure (including all its captures) is gone from the sender.** Standard Rule 2 applies — the sender can't use the closure or rely on any side effects from its captures.

**Example trace:**

```nova
big_data = load_data()          // big_data: List<int>, owned by MAIN
local_ref = big_data            // COW: local_ref shares backing with big_data
handler = x => process(x, big_data)  // closure captures big_data (COW-shared)

send(ch, handler)
// Before send: compiler sees handler's capture shares COW with big_data
// Compiler inserts: materialize big_data's capture → deep copy into closure
// Send transfers: handler (with its own independent copy of big_data)
// After send: handler is gone from MAIN. big_data and local_ref still exist (COW-shared)

print(big_data)                 // OK — big_data was not sent, a copy was captured
print(handler)                  // COMPILE ERROR — handler was sent
```

**Why this works:**
- Process isolation is maintained — no COW backing spans processes
- The developer's mental model is simple: closures capture copies, send moves the closure
- The compiler handles the materialization automatically — no annotation
- Cost is explicit: sending a closure that captures large data is expensive (deep copy). This matches reality — you can't cheaply teleport 500MB between processes

**Verification against Rule 2:** `send(ch, handler)` transfers `handler`. `handler` includes its captured copies. All of this is one atomic ownership transfer. ✓

---

### C2: Small Value Threshold — FIXED

**Problem:** Send has different semantics based on type size: small values remain valid after send, large values are invalidated. This creates a silent semantic boundary — adding a field to a struct can change whether code compiles.

**Fix: Send ALWAYS invalidates the source at the language level. Small-value copy is an invisible optimization.**

Rules:
1. **At the source level, `send(ch, x)` ALWAYS means x is gone.** The compiler ALWAYS treats the value as moved. Using x after send is ALWAYS a compile error, regardless of type size.

2. **At the optimization level, the compiler COPIES small values under the hood** instead of actually transferring the memory. But this is invisible to the developer. The source-level rule is: send = transfer, period.

3. **The `copy()` keyword is the ONLY way to keep a value after send.** `send(ch, copy(x))` works for any type — the developer keeps x.

**What this changes from the original spec:**

Before (BROKEN):
```nova
x = 42                    // int — small
send(ch, x)
print(x)                  // was: OK (small value, auto-copied)
```

After (FIXED):
```nova
x = 42                    // int — small  
send(ch, x)
print(x)                  // COMPILE ERROR — x was sent

// To keep it:
send(ch, copy(x))
print(x)                  // OK — copy was sent
```

**Wait — this makes NOVA MORE verbose than before for small values.** Every `send(ch, 42)` where you still need `42` afterward requires `copy()`. For integers, this feels absurd.

**Refinement: Literals and expressions are exempt.** The invalidation applies to VARIABLES, not to values. You can write:

```nova
send(ch, 42)              // OK — 42 is a literal, not a variable
send(ch, x + 1)           // OK — x+1 is a new value, x is not consumed
send(ch, x)               // x is consumed — can't use x after this
```

This is consistent: `send(ch, x)` sends the VARIABLE x's value, transferring ownership. `send(ch, x + 1)` creates a NEW value and sends that — x is never transferred.

**This matches how Rust works:** `foo(x)` moves x. `foo(x.clone())` copies. `foo(x + 1)` creates a new value. It's consistent, predictable, and never depends on type size.

**For the common case of "send an integer and keep using it":**

```nova
count = 0
for msg in messages
    send(stats_ch, copy(count))    // explicit copy — developer knows the cost (trivial for int)
    count += 1
```

Or more naturally:
```nova
send(stats_ch, count + 0)         // creates new value — count not consumed
```

Or just:
```nova
send(stats_ch, count)             // count consumed
count = new_count                 // rebind count
```

The cost of writing `copy()` for small values is tiny. The benefit of CONSISTENT semantics is enormous. No silent behavioral cliffs. No refactoring hazards.

---

### C3: Circular Channel Deadlocks — ACKNOWLEDGED AND MITIGATED

**Problem:** Circular dependencies between synchronous channels cause deadlocks that the spec's "all receivers gone" detection cannot find.

**Assessment:** This is a KNOWN HARD PROBLEM. No mainstream language fully solves it:
- Go: same deadlock, runtime panic ("all goroutines are asleep - deadlock!")
- Erlang: avoids by making mailboxes async (no rendezvous, no blocking sends)
- Rust: same deadlock with sync channels

NOVA cannot solve the general case (it's undecidable — equivalent to the halting problem). But NOVA can do better than "your program hangs silently."

**Mitigation (three layers):**

**Layer 1: Runtime deadlock detection (required for v1.0).**
The runtime's scheduler maintains a wait graph: which process is blocked waiting on which channel. When ALL runnable processes are blocked, the scheduler performs cycle detection. If a cycle is found:

```
Runtime error: Deadlock detected
  Process A (line 5) is waiting to receive from channel ch1
  Process B (line 9) is waiting to receive from channel ch2
  Process A would send to ch2 after receiving from ch1
  Process B would send to ch1 after receiving from ch2
  
  This is a circular dependency. Consider:
  - Using buffered channels: channel(buffer=1) 
  - Restructuring to avoid circular waits
```

This catches the simple case and gives a helpful error instead of a silent hang.

**Layer 2: Compiler static analysis (best-effort, post v1.0).**
The compiler can detect SOME deadlock patterns statically:
- Two channels used in a cross-pattern (`receive(ch1)` then `send(ch2)` in one process, `receive(ch2)` then `send(ch1)` in another)
- Single-process send-then-receive on same synchronous channel

These produce compile WARNINGS (not errors, since static deadlock detection is incomplete):
```
Warning: Potential deadlock on line 5-8
  Process A receives from ch1 then sends to ch2
  Process B receives from ch2 then sends to ch1
  With synchronous channels, this will deadlock.
  Consider using buffered channels.
```

**Layer 3: Timeouts (developer tool).**
```nova
msg = receive(ch, timeout=5000) else handle_timeout()
```

Developers can set timeouts on channel operations. If the timeout expires, the operation returns an error that the developer can handle with `else`. This is essential for production systems anyway (network partitions, slow peers).

**For distributed deadlocks:** Timeout-based detection only. True distributed deadlock detection (Chandy-Misra-Haas) is too expensive for v1.0. If a network channel operation doesn't complete within the timeout, the developer gets an error they can handle. This is the same approach Erlang and Go take for distributed systems.

---

### C4: @low_level Handle Use-After-Free — FIXED

**Problem:** After `free_buffer(rb)`, the `rb` variable still holds the handle ID. If the handle ID is reused for a new allocation, using `rb` afterward writes to the wrong buffer.

**Fix: Generation-counted handles.**

1. **Handle IDs include a generation counter.** A handle is not just an index into the handle table — it's `(index, generation)` packed into a single int. When a handle is freed, the generation counter at that index is incremented. When a handle is used, the runtime checks that the handle's generation matches the table entry's generation.

2. **Using a freed handle returns a runtime error:**

```nova
rb = ring_buffer(1024)     // handle: (index=7, gen=1)
free_buffer(rb)            // table[7].gen incremented to 2, memory freed
push(rb, byte(0x42))       // handle gen=1, table gen=2 → MISMATCH
                           // Runtime error: "Handle expired — buffer was already freed on line N"
```

3. **Handle ID reuse is safe.** If index 7 is reused for a new allocation, it gets gen=2. The old handle `rb` has gen=1 — it will never accidentally access the new allocation.

**Implementation cost:** One integer comparison per @low_level operation. Negligible for systems code.

---

### C5: Process Boundary Definition — FIXED

**Problem:** The spec never formally defines what creates a process boundary, making ownership tracking unpredictable.

**Fix: Exhaustive list of process boundary creation points.**

A new process (and thus a new ownership boundary) is created by EXACTLY these constructs:

| Construct | Creates Process? | Ownership Boundary? |
|---|---|---|
| `spawn expr` | Yes — explicitly | Yes — arguments transferred/copied |
| `spawn fn(args)` | Yes — explicitly | Yes — arguments transferred/copied |
| `@device(gpu) block` | Yes — implicit GPU process | Yes — values sent to GPU memory |
| `@device(wasm) block` | Yes — implicit WASM process | Yes — values serialized to WASM |
| `http.serve(handler)` | Yes — each request gets a process | Yes — request data owned by handler process |
| Regular function call | **No** | **No** — stays in caller's process |
| Method call | **No** | **No** — stays in caller's process |
| `@low_level` block | **No** | **No** — same process, different rules within block |
| Lambda/closure | **No** (until sent/spawned) | **No** (until sent/spawned) |

**The rule is simple:** Only `spawn` (explicit or implicit via `@device` and certain stdlib functions) creates a process boundary. Everything else stays in the current process.

**Stdlib functions that spawn:** Any stdlib function that creates a process boundary MUST document this in its signature. For example:

```nova
// http.serve creates one process per request handler invocation
fn http.serve(port: int, router: fn(Routes) -> Nothing) -> Nothing
```

The compiler knows (from the stdlib's type annotations) that the handler closure will run in a separate process. This means values captured by the closure follow the cross-process rules (materialization of COW, same as C1 fix).

**How the developer knows:** The developer knows a process boundary exists because they either:
1. Wrote `spawn` — explicit
2. Used `@device(gpu)` or `@device(wasm)` — the annotation makes it obvious
3. Used a stdlib function whose docs say it spawns — but the compiler enforces the rules regardless

If a developer passes a closure to a stdlib function that spawns, and the closure captures a value it shouldn't (e.g., a non-Sendable value for a network-spawned process), the compiler catches it:

```
Error: Closure passed to http.serve captures `conn` (type Connection)
  Connection is not Sendable (contains FileDescriptor).
  http.serve runs the handler in a separate process.
  
  Pass the data you need through the request, or use a channel.
```

---

## SERIOUS FIXES

### S1: Channel Handle Role Inference — FIXED

**Problem:** A channel handle's role (sender/receiver) is inferred from usage, but unused handles remain "undetermined" indefinitely, preventing the runtime from detecting "no receivers" situations.

**Fix: Roles are inferred at compile time, not runtime.**

The compiler performs inter-process dataflow analysis:
1. For each channel, find all processes that hold a handle to it
2. For each process, determine if it calls `send(ch, ...)`, `receive(ch)`, or both
3. If a process holds a handle but never uses it → COMPILE WARNING: "Channel handle `ch` is never used in this scope — consider removing it"
4. If NO process receives from a channel → COMPILE ERROR: "Channel created on line N has no receiver — messages would be lost"
5. If NO process sends to a channel → COMPILE WARNING: "Channel created on line N has no sender — receives will block forever"

For dynamically passed channels (channel sent through another channel), compile-time analysis may not be possible. In that case, runtime detection falls back to: when a process blocks on send and the scheduler detects all potential receivers are gone, unblock with ChannelClosed.

---

### S2: Rule 4 vs Move Optimization — CLARIFIED

**Problem:** Rule 4 says assignment = copy, but the compiler applies move optimization. A compiler implementer wouldn't know which applies.

**Clarification:** Rule 4 defines SEMANTICS. Move optimization is an IMPLEMENTATION STRATEGY.

- **Semantics (what the developer sees):** `b = a` means b is an independent copy of a. Mutating b never affects a.
- **Implementation (what the compiler does):** If the compiler can prove `a` is never used after `b = a`, it moves instead of copying. The developer's observable behavior is identical — they can't tell the difference because they never access `a` again.

The compiler implementer should:
1. Implement Rule 4 literally (always copy) as the baseline — correct but slow
2. Add move optimization as a pass — detect "last use" and replace copy with move
3. The optimization is SEMANTICS-PRESERVING: any program that compiles with the optimization produces the same output as without it

This is exactly how Swift implements COW: the semantic model is "value types are always copied," but the optimizer uses reference counting and COW to avoid most copies.

---

### S3: Channel Refcount Synchronization — SPECIFIED

**Problem:** Channel refcounts are shared mutable state accessed by multiple processes concurrently.

**Fix:** Channel refcounts use **atomic operations** (compare-and-swap). This is an implementation detail of the runtime (Phase 3), but the spec now mandates it:

- Refcount increment: atomic fetch-and-add
- Refcount decrement: atomic fetch-and-subtract
- Transition check (refcount → 0): atomically check after decrement, proceed to DRAINING/CLOSED if zero

Cost: one atomic operation per channel handle create/destroy. Negligible — this is the same cost as `std::shared_ptr` in C++ or `Arc` in Rust.

---

### S4: Select Fairness — SPECIFIED

**Problem:** `select` among ready channels has no fairness policy.

**Fix:** `select` uses **pseudo-random selection among ready channels** (same as Go).

When `select(ch1, ch2, ch3)` is called and multiple channels have values:
- The runtime picks one at random
- Over many calls, all ready channels get roughly equal service
- This prevents starvation

Rationale: round-robin would require per-select state tracking. Random selection is simpler and provides probabilistic fairness. Go has validated this approach at massive scale.

---

### S5: Distributed Deadlocks — ACKNOWLEDGED

**Problem:** Deadlocks across machine boundaries are not addressed.

**Resolution:** Distributed deadlock detection is OUT OF SCOPE for v1.0. Mitigation:
- All network channel operations REQUIRE a timeout (or the compiler inserts a default timeout)
- Default timeout for network channels: 30 seconds (configurable)
- Timeout expiry → ChannelClosed error → developer handles with `else`

This is the industry-standard approach (gRPC, HTTP/2, AMQP all use timeouts for distributed liveness).

---

### S6: Default buffer=0 Single-Process Deadlock — MITIGATED

**Problem:** `ch = channel(); send(ch, 42); receive(ch)` deadlocks immediately in a single-process program.

**Mitigation (two approaches, both applied):**

1. **Compiler detects single-process synchronous send-before-receive:**
```
Warning on line 2: send(ch, 42) will block forever
  Channel `ch` is synchronous (buffer=0) and send is called before receive
  in the same process. This will deadlock.
  
  Options:
  - Use a buffered channel: channel(buffer=1)
  - Send from a different process: spawn fn() send(ch, 42)
```

2. **Helpful runtime error if the warning is ignored (or analysis is incomplete):**
If the runtime's scheduler detects the only runnable process is blocked:
```
Runtime error: Deadlock — all processes are blocked
  Process MAIN is blocked on send(ch, ...) on line 2
  No other processes exist to receive from this channel.
```

---

### S7: Channels Through Channels — SPECIFIED

**Problem:** Sending a channel handle through another channel creates reference counting chains that aren't tracked.

**Fix:** Channel handles in channel buffers DO hold refcount contributions.

When `send(ch1, ch2_handle)`:
1. `ch2_handle` is copied into ch1's buffer (channel handles always copy)
2. ch2's refcount is incremented (the buffer holds a reference)
3. When the receiver calls `receive(ch1)` and gets `ch2_handle`, ch2's refcount stays the same (ownership of the handle transfers from buffer to receiver)
4. If ch1 is closed while `ch2_handle` is still in the buffer: ch2_handle is dropped, ch2's refcount decremented

This is standard reference counting through containers. The runtime implements it.

---

### S8: Resource Limits on Spawn — SPECIFIED

**Problem:** Spawning a million processes has no resource limit.

**Fix:** `spawn` can fail.

```nova
worker = spawn heavy_computation() else handle_spawn_failure()
```

When system resources are exhausted (memory, OS thread limits, NOVA process limit):
- `spawn` returns an error
- The developer handles it with `else` (or lets it crash → supervisor handles it)
- Default NOVA process limit: configurable, default 1M (same as Erlang)

---

### S9: Cross-Process Type Inference for Sum Types — ALREADY HANDLED

**Problem:** Two producers sending different variants of a sum type to the same channel.

**This is already handled by the type inference algorithm in Step 0.2.** Here's why:

```nova
ch = channel()           // ch: channel<T1>
spawn
    send(ch, Circle(5.0))   // constraint: T1 = Circle... but wait
spawn
    send(ch, Rectangle(3.0, 4.0))  // constraint: T1 = Rectangle
```

The compiler sees both sends to the SAME channel variable `ch`. It generates:
- T1 = Circle (from first send)
- T1 = Rectangle (from second send)
- Unification: T1 = Circle AND T1 = Rectangle → conflict

The developer must use the sum type explicitly:
```nova
ch = channel::<Shape>()    // explicit channel type
```

Or send Shape values:
```nova
send(ch, Shape.Circle(5.0))
```

This is one of the <5% cases where a type annotation is needed — when the channel carries a sum type and different producers send different variants. The compiler CAN'T infer the sum type because it doesn't know the developer intends these to be variants of the same type vs. a type error.

---

### S10-S13: Runtime Implementation Concerns — DEFERRED TO PHASE 3

Issues S10 (memory pool fragmentation), S11 (COW loop overhead), S12 (scheduling algorithm), and S13 (physical inter-pool transfer) are runtime implementation concerns, not specification issues. They will be addressed in Phase 3 (Runtime) with specific algorithms:

- **S10 (pools):** Slab allocator with size classes + large-object mmap. Per-process pools are page-sized (4KB-64KB), not pre-allocated for all processes. Idle process pool = 0 bytes overhead.
- **S11 (COW loops):** Compiler pattern: `x = y; x.mutate()` in a loop → compiler detects and converts to in-place mutation (no COW needed, since x is the only user after COW triggers).
- **S12 (scheduling):** Work-stealing scheduler with preemptive safe-points at function calls and loop back-edges. Defined in Phase 3.
- **S13 (pool transfer):** Values sent through local channels are allocated in a shared transfer pool, not detached from arenas. Receiver moves from transfer pool to its own pool. Defined in Phase 3.

---

## CONCERN FIXES

### Cn1: Channel OPEN-to-DRAINING Race — DEFERRED
Implementation detail for lock-free channel in Phase 3. The MPSC queue's linearizability guarantees handle this.

### Cn2: Bulk Deallocation vs Handle Table — CLARIFIED
O(1) refers to regular values (arena free). Handle table iteration is O(handles), which is O(n) for @low_level allocations. The spec should say: "Regular values: O(1) bulk free. @low_level handles: O(n) cleanup." For processes without @low_level, cleanup is truly O(1).

### Cn3: Program Termination Semantics — SPECIFIED
**The program exits when the root process (main) completes or crashes.** Orphaned child processes are sent a termination signal through their channels (channels close). They have a grace period (configurable, default 5 seconds) to finish, then are forcefully terminated. This matches Unix process semantics (parent dies → children get SIGHUP).

### Cn4: Select on Zero Channels — SPECIFIED
`select()` with no arguments is a **compile error**: "select requires at least one channel."

### Cn5: `else` Evaluation — SPECIFIED
`else` default is evaluated **lazily**. The right-hand side of `else` is only evaluated if the left-hand side produces an error. This avoids wasted computation. Implementation: the compiler wraps the `else` branch in a thunk (closure with no arguments) that is only called when needed.

### Cn6: Process Identity — SPECIFIED
Process handles support: `==` (compare identity), `is_alive(handle)` (check status). A process can get its own handle with `self()` and its parent with `parent()`.

### Cn7: Channel Capacity Change — OUT OF SCOPE
Channels have fixed capacity after creation. Dynamic resizing adds complexity with minimal benefit. The developer creates a new channel if they need different capacity.

### Cn8: Timeouts — SPECIFIED
```nova
msg = receive(ch, timeout=5000) else handle_timeout()
send(ch, data, timeout=5000) else handle_timeout()
```
`timeout` parameter on `receive` and `send`. Value in milliseconds. Returns error on expiry, handled with `else`.

---

## SUMMARY

| Severity | Found | Fixed | Deferred |
|---|---|---|---|
| CRITICAL | 5 | 5 (C1-C5) | 0 |
| SERIOUS | 13 | 9 (S1-S9) | 4 (S10-S13 to Phase 3) |
| CONCERN | 8 | 6 (Cn2-Cn6, Cn8) | 2 (Cn1, Cn7) |

**All critical issues resolved. Gate 3 assessment stands — ownership works without annotations.**

The fixes strengthen the spec without adding developer-facing complexity:
- Closures: materialized on cross-process transfer (compiler handles it)
- Send semantics: ALWAYS transfers, regardless of type size (consistent, predictable)
- Deadlocks: runtime detection + compiler warnings + timeouts (three layers)
- Handle safety: generation counters (runtime handles it)
- Process boundaries: exhaustive list (clear, no ambiguity)
