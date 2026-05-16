# Phase 0, Step 0.3: Process/Channel Semantics

**Status: COMPLETE — GATE 3 PASSED**
**Goal: Define formal ownership rules. Trace 5 scenarios. Prove ownership is always unambiguous. GATE 3.**
**Adversarial review: 5 critical + 13 serious issues found and fixed. See semantics_fixes.md.**

---

## 0.3.1 — Process Lifecycle

### State Machine

Every process in NOVA is in exactly one of these states at any moment:

```
                   ┌──────────────────┐
                   │                  │
    spawn ───►  RUNNING  ───► COMPLETED(value)
                   │
                   └──────────────► CRASHED(error)
                                       │
                                       ▼
                              [supervisor decides]
                                    │       │
                                    ▼       ▼
                               RESTARTING  DEAD
                                    │
                                    ▼
                                 RUNNING (new instance)
```

### State Definitions

**RUNNING:**
- Process is executing code
- It owns a set of values (its local variables, heap allocations, channel handles)
- It can send values, receive values, spawn children, create channels
- Invariant: every value the process references is owned by this process

**COMPLETED(value):**
- Process finished normally
- Return value is available to the parent (through an implicit result channel)
- All other local values are freed
- All channel handles held by this process are released (refcount decremented)
- Process memory pool is freed in bulk

**CRASHED(error):**
- Process hit an unrecoverable error (unhandled error variant, assertion failure, @low_level segfault)
- Error descriptor is available to the supervisor
- ALL values owned by the process are freed — no partial cleanup, no "half-alive" state
- All channel handles are released
- Buffered values IN channels that this process wrote are NOT affected — they belong to the channel now, not the process
- Process memory pool is freed in bulk

**RESTARTING:**
- Transient state: old instance is CRASHED, supervisor decided to restart
- New instance starts with a clean state — no values from the old instance carry over
- Same function, same arguments (or supervisor can modify arguments)
- Gets fresh channel handles (supervisor passes them)

**DEAD:**
- Supervisor decided not to restart, or max restart count exceeded
- Process is fully cleaned up, its ID can be reused
- Any processes that were sending TO this process's channels will get a `ChannelClosed` error on next send

### What Triggers Each Transition

| From | To | Trigger |
|---|---|---|
| (none) | RUNNING | `spawn expr` — parent creates child process |
| RUNNING | COMPLETED(v) | Process reaches end of its code, or executes `return v` |
| RUNNING | CRASHED(e) | Unhandled error, assertion failure, @low_level fault |
| CRASHED | RESTARTING | Supervisor strategy says restart AND restart budget not exhausted |
| CRASHED | DEAD | Supervisor strategy says don't restart, OR restart budget exhausted |
| RESTARTING | RUNNING | New instance spawned successfully |

### Process Creation Rules

1. **Every process has a parent.** The top-level program is the root process. `spawn` creates a child of the current process.

2. **Spawn returns a process handle.** The handle is a value owned by the parent. It can be used for supervision, or ignored (fire-and-forget).

```nova
worker = spawn do_work(data)    // worker: Process — owned by parent
spawn do_work(data)              // fire-and-forget — handle discarded
```

3. **Arguments to spawn are copied or moved.** When a process is spawned with arguments:
   - Small values (primitives, small structs): copied into the child's memory
   - Large values: move semantics — parent loses ownership, child gains it
   - Explicit copy: `spawn do_work(copy(data))` — parent keeps its copy

This is the SAME rule as sending through a channel, because that's what spawn IS: it creates a process and implicitly sends the arguments through a one-shot channel.

4. **Process memory is isolated.** A child process CANNOT access the parent's variables. A parent CANNOT access the child's variables. Communication happens ONLY through channels. This is the fundamental safety guarantee.

### Process Tree

Every NOVA program forms a tree of processes:

```
ROOT (main)
├── Worker 1
│   ├── Sub-worker A
│   └── Sub-worker B
├── Worker 2
└── HTTP Server
    ├── Handler 1
    ├── Handler 2
    └── Handler 3
```

When a process crashes:
- Its children are NOT automatically killed (they might be doing useful work)
- But if a child tries to send to the crashed parent's channels, it gets `ChannelClosed`
- The supervisor (parent of the crashed process) decides what to do

When a process completes normally:
- Its children continue running if they have other channel connections
- If children only communicated with the parent, their channels close, and they should handle that gracefully (receive returns error, they finish or crash)

---

## 0.3.2 — Channel Lifecycle

### State Machine

```
channel() ───► OPEN ───► DRAINING ───► CLOSED
                 │                        ▲
                 └────────────────────────┘
                    (all handles dropped)
```

### State Definitions

**OPEN:**
- Channel accepts sends and receives
- Has a bounded buffer (default size: 0 = synchronous rendezvous)
- Tracks reference count: how many process hold a handle to this channel
- Send blocks if buffer is full (backpressure)
- Receive blocks if buffer is empty

**DRAINING:**
- No more senders (all sending handles dropped or processes crashed)
- Receivers can still read buffered values
- New sends are rejected with `ChannelClosed` error
- Transitions to CLOSED when buffer is empty and all receiver handles are released

**CLOSED:**
- Channel is done. No sends, no receives.
- Any remaining references are stale handles — using them produces `ChannelClosed` error
- Channel memory is freed

### Channel Creation

```nova
ch = channel()              // synchronous (buffer = 0): send blocks until receive
ch = channel(buffer=64)     // buffered: up to 64 values before backpressure
```

**Channel handle ownership:** A channel handle is a value. Like all values, it's owned by the process that holds it. But handles are special: multiple handles can reference the SAME channel. This is the ONE exception to "values are not shared between processes."

Why this exception is safe: a channel handle is an opaque reference (internally an ID or pointer). You can't read or modify another process's data through it. You can only send values INTO the channel or receive values FROM it. The channel itself is managed by the runtime, not by any process.

**How channel handles propagate:**

```nova
ch = channel()              // parent creates channel, gets a handle
spawn worker(ch)            // handle is COPIED to child process
                            // both parent and child have handles to the same channel
```

Channel handles are always copied (never moved) when passed to spawn or sent through other channels. This is because both sides need the handle to communicate. Moving a channel handle would make it useless — if you moved it to the child, the parent couldn't send/receive anymore.

**Reference counting for channels:**

Each channel tracks how many handles exist. When a handle goes out of scope (process completes, crashes, or variable is reassigned), the refcount decrements. When refcount reaches zero on the sender side, the channel enters DRAINING. When total refcount reaches zero, the channel is CLOSED and freed.

More precisely: the runtime tracks **sender handles** and **receiver handles** separately. A handle's role (sender vs receiver) is inferred from usage:
- If a process calls `send(ch, ...)` → ch is a sender handle in that process
- If a process calls `receive(ch)` → ch is a receiver handle in that process
- If a process does both → ch is both (bidirectional)

When all sender handles are gone → DRAINING (receivers can still read buffered values).
When all receiver handles are gone → channel drops unread values, senders get `ChannelClosed` on next send.

### Buffering and Backpressure

**Synchronous channel (buffer=0):**
- `send(ch, val)` blocks until another process calls `receive(ch)`
- `receive(ch)` blocks until another process calls `send(ch, val)`
- Rendezvous: both processes synchronize at the channel
- Guarantees: producer never outpaces consumer

**Buffered channel (buffer=N):**
- `send(ch, val)` succeeds immediately if buffer has space; blocks if buffer is full
- `receive(ch)` succeeds immediately if buffer has data; blocks if buffer is empty
- Guarantees: up to N values can be "in flight" between producer and consumer

**Why no unbounded channels:** Unbounded channels (Erlang mailboxes) can lead to OOM. A producer that's faster than the consumer fills memory indefinitely. Bounded channels with backpressure force the system to self-regulate. The developer can choose a large buffer if they know the producer is bursty, but they must choose — the default is safe.

**Blocking semantics:** When a process blocks on send or receive, the runtime scheduler suspends it (not an OS thread block — a green thread yield). The scheduler is free to run other processes. When the blocking condition resolves (receiver takes a value, sender puts a value), the process is rescheduled.

This means "blocking" in NOVA is cheap. It's a cooperative yield, not a kernel context switch. Millions of processes can block simultaneously without degrading performance.

### Select (Multiplexing)

A process can wait on multiple channels simultaneously:

```nova
match select(ch1, ch2, ch3)
    (1, msg) => handle_from_ch1(msg)
    (2, msg) => handle_from_ch2(msg)
    (3, msg) => handle_from_ch3(msg)
```

`select` blocks until ANY of the channels has a value available, then returns which channel and the value. This enables patterns like:
- Merging multiple input streams
- Timeout channels (a channel that sends after N milliseconds)
- Quit signals

Implementation: the runtime registers the process as a waiter on all specified channels. Whichever channel gets a value first wakes the process.

---

## 0.3.3 — Ownership Transfer Rules (The 5 Rules)

These 5 rules are the COMPLETE memory model. There are no additional rules. If something isn't covered by these 5 rules, it's a bug in the specification.

### Rule 1: Values Are Born Owned

Every value is created inside a process. The creating process owns it.

```nova
fn work()
    x = 42                    // x is owned by this process
    name = "Alice"            // name is owned by this process
    items = [1, 2, 3]         // items is owned by this process
```

**Formal statement:** For any value `v` created at time `t` in process `P`, `owner(v, t) = P`.

**What "owned" means concretely:**
- The process has a valid reference to the value
- The process can read the value
- The process can mutate the value (if mutable)
- No other process has a reference to this value (except through channels)
- When the process ends, the value is freed

### Rule 2: Send Transfers Ownership

Sending a value through a channel transfers ownership from the sender to the channel, then to the receiver.

```nova
data = [1, 2, 3]
send(ch, data)          // ownership of data transfers: this process → channel → receiver
print(data)             // COMPILE ERROR: data was sent on the line above
```

**Formal statement:** After `send(ch, v)` executes in process `P`:
- `owner(v) ≠ P` — P no longer owns v
- v is in channel ch's buffer (owned by the channel infrastructure)
- When process Q calls `receive(ch)` and gets v: `owner(v) = Q`

**What the compiler enforces:**
- Any use of `v` after `send(ch, v)` in the same process is a compile error
- This is a simple liveness analysis: after the send, `v` is "dead" in the sender's scope

**What happens physically:**
- For local channels (same machine): the value's memory is detached from the sender's process pool and attached to the receiver's process pool. If the value is on the heap, this is a pointer transfer — zero copy.
- For network channels: the value is serialized, sent over the wire, deserialized in the receiver's memory. The sender's copy is freed after serialization.
- For GPU channels: the value is DMA-transferred to GPU memory. CPU-side memory is freed.

### Rule 3: Copy Preserves Ownership

Using `copy(value)` creates a new, independent copy. The original owner keeps the original.

```nova
data = [1, 2, 3]
send(ch, copy(data))    // a COPY of data is sent; this process keeps data
print(data)             // OK — data is still owned by this process
```

**Formal statement:** `copy(v)` in process `P` creates a new value `v'` where:
- `owner(v) = P` — unchanged
- `owner(v') = P` — P also owns the copy (until it sends the copy)
- `v` and `v'` are independent — mutating one does not affect the other

**When to use copy:** The developer writes `copy()` when they want to send a value AND keep using it. This is explicit — the developer understands the cost (memory allocation + data copying). The compiler NEVER silently copies large values across process boundaries.

**Consistency:** `send(ch, x)` ALWAYS invalidates `x` at the source level, regardless of type size. The compiler may optimize small values to copies under the hood, but the developer's view is always: send = transfer, x is gone.

```nova
x = 42
send(ch, x)
print(x)              // COMPILE ERROR — x was sent, even though int is small

send(ch, copy(x))     // use copy() to keep x
print(x)              // OK

send(ch, 42)          // OK — literal, not a variable binding
send(ch, x + 1)       // OK — expression creates new value, x not consumed
```

This avoids a dangerous semantic cliff: if small values stayed valid after send but large values didn't, adding a field to a struct could silently change whether code compiles. NOVA makes it consistent: send a variable = variable is gone. Always.

### Rule 4: Assignment Copies (Within a Process)

Within a single process, `=` creates a logical copy.

```nova
a = [1, 2, 3]
b = a               // b is a logical copy of a
b.append(4)          // mutating b does NOT affect a
print(a)             // [1, 2, 3] — unchanged
```

**Formal statement:** `b = a` in process `P` creates a new value `b` where:
- `owner(a) = P` — unchanged
- `owner(b) = P`
- `a` and `b` are logically independent

**Implementation — Copy-on-Write (COW):**
The compiler does NOT actually copy large values on assignment. Instead:
1. `b = a` → both `a` and `b` point to the same backing storage, refcount = 2
2. When `b.append(4)` is called → COW triggers: `b` gets its own copy of the storage, refcount decrements for the shared storage
3. If neither is ever mutated → no copy ever happens (pure sharing)

**Why this matters:** In Python, `b = a` makes `b` an alias — mutating `b` mutates `a`. This is a constant source of bugs. In NOVA, `b = a` means `b` is an independent copy. The developer's mental model is simple: assignment copies. The compiler optimizes away the copy when possible.

**Within-process vs cross-process:** This copy rule applies ONLY within a single process. Cross-process transfer is governed by Rule 2 (send) and Rule 3 (copy). The key difference: within a process, the compiler can use COW because it controls both references. Across processes, true transfer or true copy is required because processes have separate memory spaces.

### Rule 5: Process Death Frees Everything

When a process ends (completes or crashes), ALL values it owns are freed.

**Formal statement:** When process `P` transitions to COMPLETED or CRASHED:
- For every value `v` where `owner(v) = P`: `v` is freed
- For every channel handle `h` held by `P`: refcount of the channel is decremented
- If `P` is a supervised process and the supervisor restarts it: the new instance has NO values from the old instance

**Why bulk deallocation works:** Each process has its own memory pool (arena). When the process dies, the entire pool is freed in one operation — no individual `free()` calls, no GC traversal. This is O(1) regardless of how many values the process held. This is how Erlang achieves soft real-time with millions of processes.

**What is NOT freed:**
- Values that were `send()`-ed before the crash → those are now in channels or in other processes. They are NOT freed. This is correct: ownership was transferred before the crash.
- Channel infrastructure → channels are reference-counted, not process-owned. The process's handle is released, but the channel persists until all handles are gone.
- Child processes → children are independent. They keep running until they complete, crash, or their channels close.

### The Complete Picture

```
RULE 1: Value created → owned by creating process
RULE 2: send(ch, value) → ownership transfers to receiver
RULE 3: send(ch, copy(value)) → copy sent, original kept
RULE 4: b = a (within process) → logical copy (COW optimized)
RULE 5: Process dies → all owned values freed in bulk
```

**Claim: these 5 rules make the following impossible:**
- **Data races:** Two processes cannot access the same value. Values transfer, never share.
- **Use-after-free:** The compiler tracks ownership statically. Using a value after sending it is a compile error.
- **Dangling pointers:** Values are freed when their owning process dies. No pointer can outlive its value because pointers don't cross process boundaries.
- **Memory leaks:** Process death frees everything. Channels are reference-counted. No value can be forgotten.
- **Double free:** Each value has exactly one owner. Freed exactly once when the owner dies.

We will verify this claim in the 5 scenarios below.

---

## 0.3.4 — Supervision Rules

### Supervision Relationship

A process supervises another by calling `supervise()`:

```nova
worker = spawn http_handler()
supervise(worker, restart="always", max_restarts=5, within=60)
```

**What this establishes:**
- The calling process (supervisor) monitors the worker process
- If the worker crashes, the supervisor is notified through an internal supervision channel
- The supervisor automatically executes the restart strategy

### Restart Strategies

| Strategy | Behavior | Use Case |
|---|---|---|
| `restart="always"` | Restart on any crash, up to budget | Stateless workers (HTTP handlers, queue consumers) |
| `restart="never"` | Don't restart, report crash to parent | One-shot tasks, best-effort operations |
| `restart="transient"` | Restart only on crash, not on normal exit | Tasks that should complete but might fail |

### Restart Budget

`max_restarts` and `within` define the restart budget:
- `max_restarts=5, within=60` → if the process crashes more than 5 times in 60 seconds, stop restarting
- When the budget is exhausted, the supervisor itself crashes (escalates to ITS supervisor)
- This prevents crash loops: a process with a persistent bug won't restart indefinitely

### Supervision and Ownership

When a supervised process crashes and is restarted:

1. **Old instance's values are freed** (Rule 5 — process death frees everything)
2. **New instance starts clean** — no values from the old instance
3. **Supervisor passes fresh arguments** — typically the same channel handles so the new instance connects to the same communication topology
4. **Channel state persists** — values buffered in channels from the old instance are still there; the new instance can receive them

```nova
fn main()
    work_ch = channel(buffer=100)
    result_ch = channel(buffer=100)
    
    worker = spawn process_work(work_ch, result_ch)
    supervise(worker, restart="always", max_restarts=5, within=60)
    
    // If worker crashes:
    // 1. Old worker's local variables are freed
    // 2. work_ch and result_ch remain open (main still holds handles)
    // 3. New worker is spawned with same work_ch, result_ch
    // 4. New worker can receive pending work from work_ch
    // 5. Clients never know the worker crashed
```

### Supervision Trees

Supervisors can supervise other supervisors, forming a tree:

```
ROOT SUPERVISOR
├── DB Connection Pool Supervisor
│   ├── DB Connection 1
│   ├── DB Connection 2
│   └── DB Connection 3
├── HTTP Worker Supervisor
│   ├── HTTP Worker 1
│   ├── HTTP Worker 2
│   └── HTTP Worker 3
└── Background Job Supervisor
    ├── Email Sender
    └── Report Generator
```

**Crash propagation:**
1. HTTP Worker 2 crashes → HTTP Worker Supervisor restarts it
2. HTTP Worker Supervisor's restart budget exhausted → HTTP Worker Supervisor crashes
3. Root Supervisor sees HTTP Worker Supervisor crashed → Root restarts the entire HTTP Worker Supervisor (which spawns fresh workers)
4. Root Supervisor's budget exhausted → Program exits with error

**Why this works for fault tolerance:**
- Individual crashes are handled locally (fast restart, no disruption)
- Persistent failures escalate up the tree (worsening problems get wider response)
- Each level has its own budget (cascading failures eventually halt the program rather than burning CPU in crash loops)
- The developer writes the happy path; the supervision tree handles failures

---

## 0.3.5 — Copy Semantics Rules

### The Mental Model

The developer thinks: "assignment copies." This is the ONLY thing they need to understand.

```nova
a = [1, 2, 3]
b = a               // b is a copy of a
b.append(4)          // b is now [1, 2, 3, 4]
print(a)             // [1, 2, 3] — unchanged
```

### What The Compiler Actually Does

The compiler uses four strategies, chosen per-value based on static analysis:

| Strategy | When Used | What Happens |
|---|---|---|
| **Bit copy** | Primitives (int, float, bool, byte) | Literal memcpy of the bytes. Cheapest possible. |
| **COW (Copy-on-Write)** | Large compounds (List, Map, string) assigned within a process | Share backing storage, copy only when mutated. |
| **Move** | Value sent through channel, or value consumed by last use | Pointer transfer, no copy. Source becomes invalid. |
| **Deep copy** | Explicit `copy()`, or send to network/GPU channel | Full recursive copy of the value and all sub-values. |

### COW Implementation Details

For a value with COW:

```
a = [1, 2, 3]
// Memory: a → [header: refcount=1, data: [1, 2, 3]]

b = a
// Memory: a → [header: refcount=2, data: [1, 2, 3]]
//         b ↗

b.append(4)
// refcount > 1, so COW triggers:
// Memory: a → [header: refcount=1, data: [1, 2, 3]]
//         b → [header: refcount=1, data: [1, 2, 3, 4]]   ← new allocation
```

**Thread safety of COW within a process:** Since COW only applies WITHIN a single process, and a process executes sequentially (no internal parallelism), the refcount doesn't need atomic operations. This is cheaper than Rust's `Arc` or Swift's COW (which need atomics for thread safety).

**COW across processes is NEVER used.** Cross-process communication always uses move (Rule 2) or explicit deep copy (Rule 3). COW's shared backing storage cannot span process boundaries because processes have separate memory pools.

### When Move Optimization Applies

The compiler performs move optimization when it can prove the source value is never used again:

```nova
fn transform(data)
    result = process(data)
    return result              // result is moved out, not copied
```

The compiler sees that `result` is the last use of the value in this function. Instead of copying it to the caller, it moves it — the caller takes ownership of the same memory.

This is analogous to Rust's move semantics, but the developer never thinks about it. The compiler applies it automatically based on liveness analysis.

### Immutable Sharing Optimization

If the compiler can prove a value is never mutated after assignment:

```nova
config = load_config()       // config is never mutated anywhere
// ... 100 lines of code reading config but never modifying it
```

Then `b = config` doesn't even need COW — both variables can share the same memory with no refcount, no COW check on access. This is the cheapest possible strategy for read-only data.

The compiler detects immutability through escape analysis:
1. Is the value ever passed to a function that could mutate it? (Check: does the function mutate its argument?)
2. Is any mutating method called on it? (`.append()`, `.set()`, etc.)
3. Is it ever reassigned? (No — `config = something_else` would be a new binding, not mutation of the old value)

If all three are "no" → value is immutable → pure sharing is safe.

---

## 0.3.6 — @low_level Scoping Rules

### What @low_level Unlocks

Inside a `@low_level` block, the developer can:
- Allocate raw memory (`alloc`, `free`)
- Read/write arbitrary memory addresses (`read_ptr`, `write_ptr`)
- Call C functions through FFI (`@extern`)
- Use pointer arithmetic
- Bypass type checking for the raw operations

### What @low_level Does NOT Bypass

Even inside `@low_level`:
- **Process isolation holds.** You cannot access another process's memory.
- **Channel rules hold.** You cannot send a raw pointer through a channel.
- **Values created inside @low_level must be wrapped** before they leave the block.

### The Opaque Handle Pattern

Raw pointers MUST be wrapped in opaque handles before they cross the @low_level boundary:

```nova
type RingBuffer
    _handle: int              // opaque — runtime knows it's a pointer ID, user sees int

fn ring_buffer(capacity) -> RingBuffer
    @low_level
        ptr = alloc(capacity)                    // raw pointer — only exists here
        id = register_handle(ptr, capacity)      // register with runtime → get int ID
    RingBuffer { _handle: id }                   // safe value crosses the boundary
```

**Why opaque handles:**
- A raw pointer is an address in THIS process's memory space. Sending it to another process is meaningless (different address space) or dangerous (shared memory violation).
- An integer ID is safe: the runtime maintains a handle table that maps IDs to pointers. The handle is only valid in the process that created it. Using it in another process returns an error, not a crash.
- The handle table is per-process. When the process dies, all handles are invalidated and their backing memory is freed (Rule 5).

### Compiler Enforcement

The compiler enforces these rules statically:

1. **Raw pointer type cannot exist outside @low_level.** If you try to return a pointer from a @low_level block, compile error:
```
Error: Raw pointer cannot escape @low_level block.
  Pointer `ptr` allocated on line 5 is used outside @low_level on line 8.
  
  Wrap it in an opaque handle: register_handle(ptr) → int
```

2. **@low_level block cannot capture mutable outer variables.** This prevents the escape of raw pointers through closures:
```nova
fn bad()
    outer_ptr = nothing
    @low_level
        ptr = alloc(64)
        outer_ptr = ptr        // COMPILE ERROR: can't assign to outer variable from @low_level
```

3. **Struct fields cannot have pointer type.** A `type Foo { ptr: Pointer }` is a compile error. Only opaque wrappers (int handles) are allowed in struct fields.

### @low_level and Process Death

When a process with @low_level allocations crashes or completes:
1. The handle table for that process is iterated
2. Every registered handle's backing memory is freed
3. The handle table itself is freed

This means @low_level memory is STILL covered by Rule 5 — process death frees everything, including raw allocations tracked by the handle table. The developer doesn't need to call `free()` if the process is going to die anyway (though they should for long-running processes to avoid holding memory).

---

## 0.3.7 — Scenario 1: Process A Sends Value to Process B

### The Code

```nova
fn main()
    ch = channel()
    data = [1, 2, 3, 4, 5]
    
    spawn receiver(ch)
    send(ch, data)
    // data is gone here
    
fn receiver(ch)
    values = receive(ch)
    total = values.sum()
    print("Sum: {total}")
```

### Step-by-Step Ownership Trace

```
TIME 0: main() starts
  Process: MAIN
  Owns: (nothing yet)

TIME 1: ch = channel()
  Process: MAIN
  Owns: ch (handle to channel C1)
  Channel C1: OPEN, buffer=0, sender_handles=1, receiver_handles=0

TIME 2: data = [1, 2, 3, 4, 5]
  Process: MAIN
  Owns: ch, data
  Memory: data → heap allocation in MAIN's memory pool, ~40 bytes (5 × 8 byte ints)

TIME 3: spawn receiver(ch)
  New process: RECEIVER
  ch handle is COPIED to RECEIVER (channel handles always copy)
  Process: MAIN owns: ch, data
  Process: RECEIVER owns: ch (its own handle copy)
  Channel C1: OPEN, sender_handles=1, receiver_handles=1
  
  (sender/receiver roles not yet determined — determined by first use)

TIME 4: send(ch, data)  [in MAIN]
  MAIN calls send. Channel C1 is synchronous (buffer=0).
  RECEIVER must be ready to receive. Assume RECEIVER has called receive(ch).
  
  Ownership transfer:
  - data's backing memory is DETACHED from MAIN's memory pool
  - data's backing memory is ATTACHED to RECEIVER's memory pool
  - No bytes are copied — only the pool membership changes
  - MAIN's reference to data is INVALIDATED
  
  Process: MAIN owns: ch
  Process: RECEIVER owns: ch, data (as "values" after receive)
  
  If MAIN tries to use data after this → COMPILE ERROR:
    "Value `data` was sent through channel `ch` on line 6.
     After sending, `data` is no longer owned by this process.
     To keep a copy: use `send(ch, copy(data))`"

TIME 5: values = receive(ch)  [in RECEIVER]
  RECEIVER gets the value. values points to the same memory that data pointed to.
  Process: RECEIVER owns: ch, values
  
TIME 6: total = values.sum()  [in RECEIVER]
  Computes sum. total = 15 (int, copied by value — small type).
  Process: RECEIVER owns: ch, values, total

TIME 7: print("Sum: {total}")  [in RECEIVER]
  Output: "Sum: 15"

TIME 8: RECEIVER completes
  Process RECEIVER transitions to COMPLETED
  All RECEIVER's values freed: values (the list), total (the int), ch (handle released)
  Channel C1: receiver_handles decremented → 0 → DRAINING → no buffered values → CLOSED
  
TIME 9: MAIN completes
  ch handle released. Channel C1 already CLOSED.
  MAIN's memory pool freed.
```

### Ownership at Every Step

| Time | MAIN owns | RECEIVER owns | Channel C1 state | data location |
|---|---|---|---|---|
| 0 | (empty) | (doesn't exist) | (doesn't exist) | (doesn't exist) |
| 1 | ch | (doesn't exist) | OPEN, refs=1 | (doesn't exist) |
| 2 | ch, data | (doesn't exist) | OPEN, refs=1 | MAIN's pool |
| 3 | ch, data | ch | OPEN, refs=2 | MAIN's pool |
| 4 | ch | ch, values(=data) | OPEN, refs=2 | RECEIVER's pool |
| 5-7 | ch | ch, values, total | OPEN, refs=2 | RECEIVER's pool |
| 8 | ch | (dead) | CLOSED | freed |
| 9 | (dead) | (dead) | freed | freed |

**Verification:** At every time step, every value has exactly ONE owner (except channel handles, which are shared references to runtime-managed infrastructure). No value is ever accessible by two processes simultaneously. No dangling references. No leaks.

---

## 0.3.8 — Scenario 2: Process B Crashes While Holding a Value

### The Code

```nova
fn main()
    ch = channel(buffer=10)
    
    for i in 0..5
        send(ch, i * 100)
    
    worker = spawn process_data(ch)
    supervise(worker, restart="always", max_restarts=3, within=60)
    
fn process_data(ch)
    values = []
    for _ in 0..5
        v = receive(ch)
        values.append(v)
        if v == 300
            x = 1 / 0         // CRASH: division by zero
    print("Done: {values}")
```

### Step-by-Step Trace

```
TIME 0: main() starts
  MAIN owns: (nothing)

TIME 1: ch = channel(buffer=10)
  MAIN owns: ch
  Channel C1: OPEN, buffer capacity=10, buffered=0

TIME 2-6: send(ch, 0), send(ch, 100), send(ch, 200), send(ch, 300), send(ch, 400)
  Channel is buffered, so sends don't block.
  MAIN owns: ch
  Channel C1: buffer contains [0, 100, 200, 300, 400], buffered=5
  
  These int values are small (8 bytes each), so they were COPIED into the channel buffer.
  MAIN doesn't lose ownership of the loop variable — it's a copy.

TIME 7: worker = spawn process_data(ch)
  New process: WORKER
  ch handle copied to WORKER
  MAIN owns: ch, worker (process handle)
  WORKER owns: ch
  Channel C1: refs=2

TIME 8: supervise(worker, ...)
  MAIN registers supervision. No ownership change.

TIME 9: WORKER starts process_data
  WORKER creates: values = [] (empty list, owned by WORKER)
  WORKER owns: ch, values

TIME 10: v = receive(ch) → v = 0
  Value 0 is taken from channel buffer. WORKER owns it.
  WORKER owns: ch, values, v(=0)
  Channel C1: buffer = [100, 200, 300, 400], buffered=4

TIME 11: values.append(v)
  values = [0]
  v == 0, not 300, continue loop.

TIME 12-15: receive and append 100, 200
  WORKER owns: ch, values(=[0, 100, 200])
  Channel C1: buffer = [300, 400], buffered=2

TIME 16: v = receive(ch) → v = 300
  WORKER owns: ch, values(=[0, 100, 200]), v(=300)
  Channel C1: buffer = [400], buffered=1

TIME 17: values.append(300), then v == 300 → x = 1 / 0 → CRASH
  
  WORKER transitions to CRASHED(DivisionByZero)
  
  Crash cleanup:
  1. ALL of WORKER's values are freed:
     - ch handle: refcount decremented (C1 refs: 2 → 1, MAIN still holds)
     - values: [0, 100, 200, 300] — freed from WORKER's memory pool
     - v: 300 — freed
  2. WORKER's entire memory pool is freed in one operation
  
  Channel C1: still OPEN (MAIN holds a handle). Buffer still has [400].
  
  The value 400 in the channel buffer is NOT freed — it belongs to the channel, 
  not to any process. It's available for the next receiver.

TIME 18: Supervisor (MAIN) is notified of WORKER crash
  Restart strategy: "always", restarts_used = 1, budget = 3. OK to restart.
  
  New process: WORKER_v2 = spawn process_data(ch)
  ch handle copied to WORKER_v2
  
  WORKER_v2 starts fresh — no values from WORKER_v1
  WORKER_v2 owns: ch, values(=[] — fresh empty list)
  Channel C1: buffer = [400], refs=2

TIME 19: WORKER_v2 calls receive(ch) → v = 400
  Gets the leftover value from the buffer!
  WORKER_v2 owns: ch, values, v(=400)
  Channel C1: buffer = [], buffered=0

  400 ≠ 300, no crash. WORKER_v2 continues.
  
TIME 20: Loop ends (only 1 value was available). 
  WORKER_v2 blocks on receive (channel empty, MAIN isn't sending more).
  Eventually MAIN completes → ch handle released → C1 enters DRAINING → 
  WORKER_v2's receive gets ChannelClosed error.
```

### Key Observations

1. **Values held by the crashed process (values, v) were freed.** No leak. ✓
2. **Values in the channel buffer (400) survived the crash.** Correct — they belong to the channel, not the process. ✓
3. **The restarted process started clean.** No corrupted state from the crash. ✓
4. **The restarted process got the remaining buffered value.** Useful work wasn't lost. ✓
5. **At no point did two processes access the same value.** ✓
6. **At no point was a freed value accessible.** ✓

---

## 0.3.9 — Scenario 3: Send to Channel Nobody Reads (Backpressure)

### The Code

```nova
fn main()
    ch = channel(buffer=3)
    spawn fast_producer(ch)
    // oops — nobody is receiving from ch!

fn fast_producer(ch)
    for i in 0..1000000
        send(ch, i)           // what happens?
```

### Step-by-Step Trace

```
TIME 0-1: MAIN creates ch (buffer=3), spawns PRODUCER with ch handle.
  Channel C1: OPEN, capacity=3, buffered=0, refs=2

TIME 2: PRODUCER sends 0. Buffer has space.
  Channel C1: buffer=[0], buffered=1

TIME 3: PRODUCER sends 1. Buffer has space.
  Channel C1: buffer=[0, 1], buffered=2

TIME 4: PRODUCER sends 2. Buffer has space.
  Channel C1: buffer=[0, 1, 2], buffered=3 (FULL)

TIME 5: PRODUCER sends 3. Buffer is FULL.
  PRODUCER BLOCKS. The runtime suspends PRODUCER's green thread.
  PRODUCER remains in RUNNING state but is not scheduled for execution.
  Other processes can run.

  PRODUCER stays blocked until:
  (a) A receiver calls receive(ch) → frees buffer space → PRODUCER is rescheduled
  (b) All receiver handles are dropped → channel enters DRAINING on receiver side →
      actually, no: receiver handles are 0 because nobody ever received.
      
  Wait — who has receiver handles? MAIN and PRODUCER both have ch handles.
  The roles (sender/receiver) are determined by usage:
  - PRODUCER called send(ch, ...) → PRODUCER's handle is a sender handle
  - MAIN never called send or receive → MAIN's handle is undetermined
  
  Since MAIN holds a handle but never uses it, the channel can't know
  there will never be a receiver.
```

**This reveals a design question:** What happens when a sender is blocked and there will never be a receiver?

**Resolution:** When MAIN completes (it has nothing else to do after spawning), MAIN's ch handle is released. Now:
- Sender handles: 1 (PRODUCER, but it's blocked on send)
- Receiver handles: 0 (MAIN was the only potential receiver, and it released its handle)
- No receiver will ever appear → channel detects "all receivers gone"

```
TIME 6: MAIN completes. ch handle released.
  Channel C1: no receiver handles exist.
  Runtime detects: sender is blocked, no receivers exist → DEADLOCK for this channel.
  
  PRODUCER's blocked send returns ChannelClosed error.
  PRODUCER has no error handler for send → unhandled error → PRODUCER CRASHES.
  
  PRODUCER transitions to CRASHED(ChannelClosed).
  PRODUCER's values freed. PRODUCER's ch handle released.
  Channel C1: refs=0 → CLOSED → channel freed.
  Buffered values [0, 1, 2] freed.
```

### With Proper Handling

```nova
fn fast_producer(ch)
    for i in 0..1000000
        send(ch, i) else break    // if channel closes, stop sending
    print("Producer done")
```

Now when the channel closes, the producer breaks out of the loop gracefully instead of crashing.

### Key Observations

1. **Backpressure works:** Producer blocks when buffer is full. No memory explosion. ✓
2. **Deadlock detection works:** When all receivers are gone, blocked senders are unblocked with an error. ✓
3. **No values are leaked:** Buffered values are freed when the channel is closed. ✓
4. **The developer can handle the error gracefully** with `else`. ✓

### Synchronous Channel (buffer=0) Variant

With `ch = channel()` (buffer=0):
- PRODUCER blocks on the FIRST send (time 2) because no receiver is ready
- Same deadlock detection applies when MAIN completes and releases its handle
- Same resolution: PRODUCER's send returns ChannelClosed error

---

## 0.3.10 — Scenario 4: Two Processes Send to Same Channel Simultaneously

### The Code

```nova
fn main()
    ch = channel(buffer=10)
    
    spawn producer_a(ch)
    spawn producer_b(ch)
    
    for _ in 0..6
        msg = receive(ch)
        print(msg)

fn producer_a(ch)
    for i in [1, 2, 3]
        send(ch, "A:{i}")

fn producer_b(ch)
    for i in [4, 5, 6]
        send(ch, "B:{i}")
```

### Step-by-Step Trace

```
TIME 0: MAIN creates ch (buffer=10)
  Channel C1: OPEN, capacity=10, refs=1

TIME 1: spawn producer_a(ch)
  PRODUCER_A owns: ch (handle copy)
  Channel C1: refs=2

TIME 2: spawn producer_b(ch)
  PRODUCER_B owns: ch (handle copy)
  Channel C1: refs=3

Now three processes are RUNNING. The scheduler decides execution order.
All three are green threads — the scheduler can interleave them.

POSSIBLE EXECUTION 1: A runs first, then B, then MAIN receives
  A sends "A:1", "A:2", "A:3" → buffer = ["A:1", "A:2", "A:3"]
  B sends "B:4", "B:5", "B:6" → buffer = ["A:1", "A:2", "A:3", "B:4", "B:5", "B:6"]
  MAIN receives: "A:1", "A:2", "A:3", "B:4", "B:5", "B:6"

POSSIBLE EXECUTION 2: Interleaved
  A sends "A:1" → buffer = ["A:1"]
  B sends "B:4" → buffer = ["A:1", "B:4"]
  A sends "A:2" → buffer = ["A:1", "B:4", "A:2"]
  MAIN receives "A:1" → buffer = ["B:4", "A:2"]
  B sends "B:5" → buffer = ["B:4", "A:2", "B:5"]
  ...etc.
```

### Ownership Safety Analysis

The critical question: can two simultaneous sends corrupt the channel buffer?

**Answer: NO.** The channel's buffer is managed by the runtime, not by any process. The runtime's channel implementation uses a lock-free data structure (MPSC queue — multiple producer, single consumer) that is designed for concurrent access.

**What each send does:**
1. The value (e.g., "A:1") is a string owned by PRODUCER_A
2. `send(ch, "A:1")` → the string is moved from PRODUCER_A's memory to the channel buffer
3. The channel buffer is a lock-free queue — concurrent enqueue is safe
4. PRODUCER_A no longer owns the string

**Ordering guarantee:** Within a single producer, messages arrive in order (A sends 1 before 2 before 3 → receiver gets A:1 before A:2 before A:3, relative to each other). Between producers, no ordering guarantee — A:1 and B:4 can arrive in any order.

**This is FIFO per sender, arbitrary across senders.** Same as Go channels, Erlang mailboxes, and most message-passing systems.

### Key Observations

1. **No data race on the channel buffer.** Lock-free MPSC queue handles concurrent sends. ✓
2. **Each value has exactly one owner at all times.** String "A:1" goes from PRODUCER_A → channel buffer → MAIN. Never shared. ✓
3. **Order within a producer is preserved.** ✓
4. **No global ordering between producers** (intentional — ordering would require synchronization, which reduces performance). ✓

---

## 0.3.11 — Scenario 5: Value Sent to Remote Machine

### The Code

```nova
fn main()
    remote = connect("worker-node-2.cluster:9000")
    ch = channel(remote)           // channel to remote machine
    
    data = { users: fetch_users(), timestamp: now() }
    send(ch, data)                 // data goes to remote machine
    
    result = receive(ch)           // result comes from remote machine
    print("Remote result: {result}")
```

### Step-by-Step Trace

```
TIME 0: MAIN creates a remote channel
  channel(remote) establishes a network connection to worker-node-2
  Channel C1: OPEN, type=NETWORK, endpoint=worker-node-2:9000
  MAIN owns: remote, ch

TIME 1: data = { users: fetch_users(), timestamp: now() }
  data is an anonymous struct: { users: List<User>, timestamp: int }
  MAIN owns: remote, ch, data
  
  Capability check: is data Sendable?
  - users: List<User> — is User Sendable? Check User's fields:
    - name: string ✓ (Sendable)
    - age: int ✓ (Sendable)
    - User is Sendable ✓ → List<User> is Sendable ✓
  - timestamp: int ✓ (Sendable)
  - data is Sendable ✓
  
  If data contained a FileDescriptor or raw pointer → COMPILE ERROR:
    "Can't send { users: ..., handle: FileDescriptor } through network channel.
     FileDescriptor is an OS-local resource that can't cross machine boundaries."

TIME 2: send(ch, data)
  Channel is NETWORK type. Send involves:
  
  Step 2a: SERIALIZE data
    The compiler generated a serialization function for { users: List<User>, timestamp: int }
    at compile time (based on the type). No reflection, no runtime type discovery.
    
    Serialized bytes: [binary encoding of the struct, ~200 bytes]
    
  Step 2b: TRANSMIT bytes over the network connection
    The runtime writes the serialized bytes to the TCP socket.
    
  Step 2c: FREE the local copy
    data's memory is freed from MAIN's pool.
    MAIN no longer owns data.
    
    Why free instead of move? Because the remote machine has its own address space.
    The "move" is conceptual — physically, it's serialize + transmit + free.
  
  MAIN owns: remote, ch (data is gone)
  
  On worker-node-2:
    Bytes arrive → deserialized into a new value in the remote process's memory pool
    Remote process now owns a value equivalent to data

TIME 3: result = receive(ch)
  MAIN blocks waiting for the remote machine to send back a result.
  
  When worker-node-2 sends a result:
  Step 3a: Remote serializes its result
  Step 3b: Bytes transmitted to MAIN's machine
  Step 3c: MAIN's runtime deserializes bytes into a value in MAIN's memory pool
  
  result is now owned by MAIN.
  MAIN owns: remote, ch, result

TIME 4: print("Remote result: {result}")
  Output printed.

TIME 5: MAIN completes.
  remote connection closed.
  ch released → channel CLOSED → network connection torn down.
  result freed.
```

### Ownership Across Machines

```
MACHINE 1 (local)              NETWORK              MACHINE 2 (remote)
─────────────────              ───────              ─────────────────
MAIN owns data                                      
  │                                                 
  send(ch, data)                                    
  │                                                 
  serialize(data) ───bytes──►  ───bytes──►  deserialize → remote owns data'
  │                                                          │
  data freed                                                 │
  │                                                    process(data')
  │                                                          │
  │                              ◄──bytes───  ◄──bytes─── serialize(result)
  │                                                          │
  deserialize → MAIN owns result                       result freed
```

**At every moment, the value exists in exactly ONE place:**
- Before send: MAIN's memory (Machine 1)
- During transit: serialized bytes in the network buffer (not accessible by any process)
- After receive on Machine 2: remote process's memory (Machine 2)

There is NEVER a moment where both machines have a usable reference to the same value. Ownership is transferred, not shared.

### Key Observations

1. **Sendable capability is checked at compile time.** Unsendable values (OS handles, raw pointers) can't enter network channels. ✓
2. **Serialization code is generated at compile time.** No runtime reflection, no overhead. ✓
3. **Ownership transfers cleanly across machines.** Value exists in exactly one place at any time. ✓
4. **The developer writes the same code as for local channels.** `send(ch, data)` works identically whether `ch` is local or remote. The compiler generates different code (pointer transfer vs serialize+transmit), but the semantics are the same. ✓
5. **No distributed shared memory.** NOVA never pretends two machines share memory. Values are explicitly sent, not transparently replicated. This avoids the consistency nightmares of distributed shared memory systems. ✓

---

## 0.3.12 — Verification: Ownership Is Clear at Every Step

Going through each scenario:

### Scenario 1 (Simple Send): ✓
- data owned by MAIN → transferred to RECEIVER via channel → freed when RECEIVER completes
- At every step, exactly one entity owns data
- Compiler prevents MAIN from using data after send

### Scenario 2 (Crash): ✓
- Crashed process's values freed immediately (Rule 5)
- Channel buffered values survive crash (channel owns them, not the process)
- Restarted process starts clean — no stale references
- At every step, ownership is unambiguous

### Scenario 3 (Backpressure): ✓
- Buffer prevents unlimited memory growth
- Blocked sender is unblocked with error when receivers are gone
- Buffered values freed when channel closes
- No leak, no infinite blocking

### Scenario 4 (Concurrent Send): ✓
- Each value moves from its producer to the channel buffer to the receiver
- Lock-free MPSC queue handles concurrent access
- No value is ever owned by two processes
- No data race on the channel or on any value

### Scenario 5 (Remote): ✓
- Sendable check at compile time prevents OS-local resources from crossing machine boundaries
- Serialize → transmit → free → deserialize: value exists in one place at a time
- Same API as local channels — developer doesn't special-case distributed code

### Summary Table

| Property | Scenario 1 | Scenario 2 | Scenario 3 | Scenario 4 | Scenario 5 |
|---|---|---|---|---|---|
| Every value has exactly one owner | ✓ | ✓ | ✓ | ✓ | ✓ |
| No use-after-free | ✓ | ✓ | ✓ | ✓ | ✓ |
| No data races | ✓ | ✓ | ✓ | ✓ | ✓ |
| No memory leaks | ✓ | ✓ | ✓ | ✓ | ✓ |
| No dangling references | ✓ | ✓ | ✓ | ✓ | ✓ |
| Compiler catches violations statically | ✓ | ✓ | ✓ | ✓ | ✓ |

---

## 0.3.13 — Verification: No Memory Corruption, Data Races, or UB

### Can Two Processes Access the Same Memory?

**No.** Process isolation is the foundational invariant. Values are owned by exactly one process. The only way a value crosses process boundaries is through `send(ch, value)`, which transfers ownership. The sender loses access (enforced at compile time). The receiver gains access. There is no moment of shared access.

**Exception: Channel handles.** Multiple processes hold handles to the same channel. But channel handles are opaque IDs — they don't expose the channel's internal memory. The channel's buffer is managed by the runtime with lock-free data structures. User code never touches channel internals.

### Can a Dangling Pointer Exist?

**No.** There are no user-visible pointers in safe NOVA code. Values are accessed by name, not by address. The compiler manages memory addresses internally. When a value is sent, the compiler invalidates the name in the sender's scope. When a process dies, all values in its memory pool are freed together — no individual value can outlive its pool.

**In @low_level:** Raw pointers exist but are confined to the @low_level block. They're wrapped in opaque handles before escaping. The handle table is per-process and freed on process death. A handle used in the wrong process returns a runtime error, not a crash.

### Can a Use-After-Free Occur?

**No.** The compiler tracks the "liveness" of every value:
- After `send(ch, value)`: value is dead in the sender. Using it → compile error.
- After process death: all values freed in bulk. No references exist outside the dead process (because values can't be shared across processes).
- COW within a process: refcounted, but single-threaded within a process, so no race on refcount.

### Can a Data Race Occur?

**No.** A data race requires two threads accessing the same memory, with at least one writing. In NOVA:
- Different processes have different memory. Can't access each other's values.
- Within a process, execution is sequential (single-threaded). No concurrent access to the same value.
- Channel buffers are lock-free queues designed for concurrent access. The runtime guarantees correctness.

### Can Undefined Behavior Occur?

**In safe code: No.** Every operation has defined behavior:
- Integer overflow: wraps (defined) or errors (if checked mode enabled)
- Division by zero: CRASH with clear error
- Out-of-bounds access: CRASH with clear error  
- Null/Nothing: forced handling at compile time (sum types)
- Uninitialized memory: impossible (all variables initialized at declaration)

**In @low_level: Yes, intentionally.** Raw memory operations can cause UB (writing past an allocation, using freed memory). This is the tradeoff: @low_level gives C-level power at C-level risk. But @low_level code is isolated inside a process — even if it corrupts its own memory, it cannot corrupt another process's memory. The blast radius of @low_level UB is a single process crash, not program corruption.

---

## 0.3.14 — Simplicity Check: The Rules on One Page

### NOVA's Complete Ownership Model

**5 Rules:**

1. **Creation → Ownership.** Every value is owned by the process that creates it.
2. **Send → Transfer.** `send(ch, value)` moves the value to the receiver. Sender can't use it.
3. **Copy → Preserve.** `send(ch, copy(value))` sends a copy. Sender keeps the original.
4. **Assignment → Copy.** `b = a` within a process makes a logical copy (COW-optimized).
5. **Death → Cleanup.** Process dies → all its values are freed in bulk.

**3 Lifecycles:**

- **Process:** spawn → running → completed/crashed → (restarted or dead)
- **Channel:** create → open → draining → closed
- **Value:** create → (use, copy, send) → freed (by owner death or explicit free)

**2 Safety Guarantees:**

- **Compile-time:** use-after-send detected, channel type mismatches detected, non-exhaustive matches detected, capability violations detected
- **Runtime:** division by zero, out-of-bounds, channel closed, @low_level faults → process crash (contained by supervision)

**1 Exception:**

- `@low_level` bypasses type safety within its block. Raw pointers can't escape. Contained to one process.

**Total: 5 + 3 + 2 + 1 = 11 concepts.** Compare to Rust (ownership + borrowing + lifetimes + Send + Sync + Pin + futures + async/await + unsafe = many more concepts). Compare to Go (goroutines + channels + mutex + WaitGroup + context + select = similar count but less safe). NOVA's model is smaller AND safer.

---

## 0.3.15 — GATE 3 VALIDATION

### Question: Does ownership work without annotations?

Let me check every program from the 10 validation programs for ownership annotations:

| Program | Ownership Annotations Needed | Why |
|---|---|---|
| 1. Hello World | 0 | No processes, no channels |
| 2. Variables, Math | 0 | Single process, all local |
| 3. Functions, Control Flow | 0 | Single process, all local |
| 4. Error Handling | 0 | `else` and `match` are value operations, not ownership |
| 5. HTTP Server | 0 | Processes implicit (http.serve manages them), channels implicit |
| 6. Concurrent Processes | 0 | `spawn` and `send`/`receive` are enough — compiler tracks ownership |
| 7. AI Inference | 0 | Single process, stdlib handles internals |
| 8. Full-Stack App | 0 | `spawn` for server and web app — compiler infers ownership transfer |
| 9. Systems Memory | 0 ownership annotations | `@low_level` uses opaque handles — ownership is explicit through `send`/`receive`, no annotations |
| 10. Distributed Service | 0 | `spawn`, `channel`, `send`, `receive`, `supervise` — all keyword-driven |

**Total ownership annotations: 0.**

The developer NEVER writes:
- Lifetime annotations (Rust: `<'a>`)
- Borrow annotations (Rust: `&`, `&mut`)
- Send/Sync trait bounds (Rust: `T: Send + Sync`)
- Ownership transfer markers (beyond the keyword `send` itself)
- Memory management directives (beyond optional `@stack`/`@heap`)

The compiler infers all ownership from:
1. Where values are created (Rule 1)
2. Where `send()` is called (Rule 2)
3. Where `copy()` is called (Rule 3)
4. Process boundaries from `spawn` (implicit ownership boundary)

### Assessment

| Criterion | Result |
|---|---|
| Ownership is unambiguous in Scenario 1 (simple send) | ✅ |
| Ownership is unambiguous in Scenario 2 (crash) | ✅ |
| Ownership is unambiguous in Scenario 3 (backpressure) | ✅ |
| Ownership is unambiguous in Scenario 4 (concurrent send) | ✅ |
| Ownership is unambiguous in Scenario 5 (remote) | ✅ |
| No memory corruption possible in safe code | ✅ |
| No data races possible | ✅ |
| No undefined behavior in safe code | ✅ |
| Zero ownership annotations needed | ✅ |
| Rules fit on one page (11 concepts) | ✅ |

**GATE 3: PASSED.** Process-based ownership works without annotations. The 5 rules are complete, consistent, and simple. Safety is a structural consequence of the model, not an annotation burden on the developer.
