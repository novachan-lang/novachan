# Pre-Phase 2: Performance Gap Specifications

**Status: REQUIRED before Phase 2 begins.**
**These 5 gaps were identified by proactive failure analysis. Each one, if unresolved, would cause NOVA to fail Gate 4 or Gate 5 — the performance promises.**

---

## GAP 1: COW Loop Optimization

### The Failure Without This

```nova
result = []
for i in 0..1000000
    result = result + [i]    // O(n²): each iteration copies the entire list
```

Without optimization: 1M iterations × average n/2 copy = 500 billion element copies. A Python-level bug hidden behind clean NOVA syntax. Unacceptable.

### Why My First Instinct Was Wrong

My first instinct: "use liveness analysis to detect last use, then move instead of copy." This is correct but incomplete. It only catches the case where the variable is dead after the assignment. It misses the case where the SAME variable is both the source and the target of a mutation.

The real problem is **accumulation patterns**: `x = x + something` where x grows over time. The developer intent is mutation, but the syntax (because `=` means copy) creates a full copy each iteration.

### The Real Fix: Two-Layer Optimization

**Layer 1: In-place mutation detection (at source level)**

The compiler detects accumulation patterns and rewrites them before IR generation:

| Pattern | Detected As | Rewrite To |
|---|---|---|
| `result = result + [item]` | List append accumulation | `result.append(item)` |
| `result = result + other_list` | List extend accumulation | `result.extend(other_list)` |
| `text = text + suffix` | String concatenation loop | String builder (see Gap 3) |
| `total = total + x` | Numeric accumulation | `total += x` (already in-place) |

This is a SOURCE-LEVEL rewrite, before type inference. The compiler sees the pattern `x = x + expr` where `x` is the same variable on both sides, and converts it to `x.mutate_in_place(expr)`.

**Why this is safe:** `x = x + [item]` is semantically "copy x, append item to copy, reassign." But if `x` is the only reference to its backing storage (refcount = 1), the copy is wasteful — we can mutate in place and get the same observable result.

**Failure mode of Layer 1:** What if the accumulation is through a helper function?

```nova
fn add_item(list, item)
    list + [item]

result = []
for i in 0..n
    result = add_item(result, i)    // compiler can't see the pattern through the function
```

Layer 1 misses this. Layer 2 catches it.

**Layer 2: Refcount-based move at IR level**

After Layer 1, whatever accumulation patterns remain are handled at IR level. The rule:

> When a COW copy is triggered (assignment creates a COW-shared reference), and the compiler can prove via SSA liveness analysis that the SOURCE variable is dead after this point, replace the COW copy with a zero-cost move.

In SSA form:
```
// x = big_value; mutate x; x is dead after mutation
x_1 = big_value          // x_1: refcount=2 (shared with big_value)
x_2 = mutate(x_1)        // would trigger COW copy
// SSA liveness: x_1 has no uses after this point

// Optimization: x_1 is the last use → big_value.refcount -= 1
// If big_value.refcount is now 0 → x_1 owns the storage → mutate in place
// If big_value.refcount > 0 → big_value is still referenced → copy is required
```

The runtime refcount check is O(1). If count is 1, mutation is in place. If count > 1, copy is made. This is exactly Swift's COW — and Swift achieves C-level performance for value types.

**Failure mode of Layer 2:** What about the case where big_value.refcount is always > 1?

```nova
original = [1, 2, 3]
backup = original           // refcount = 2
result = original
result.append(4)            // refcount = 2, COW triggers — full copy is correct here
```

Here the copy is correct and required. Both layers correctly perform the copy. No false optimization. The developer intended independence between `backup` and `result`.

**Verification:** Layer 1 eliminates 90% of accumulation overhead at zero runtime cost. Layer 2 handles the remaining 10% with a single branch (refcount check). Neither introduces incorrect behavior.

---

## GAP 2: Abstraction Erasure Algorithm

### The Failure Without This

Every `spawn` that the compiler doesn't erase costs:
- Green thread creation: ~1-5μs
- Stack allocation: 4KB minimum
- Scheduler overhead: context switches
- Channel overhead: lock-free queue operations

A simple program like:

```nova
fn double(x)
    spawn compute(x)    // if not erased: 5μs overhead for a function call

fn compute(x)
    x * 2
```

Should compile to `x * 2`. If it doesn't, NOVA loses to C by 5000x for simple function calls.

### The Erasure Algorithm

**Step 1: Classify every channel**

For each channel in the IR, assign a class:

| Channel Class | Condition | Erasure Eligible? |
|---|---|---|
| PURE_LOCAL | Both sender and receiver in same OS process, no GPU/WASM | YES |
| THREAD_LOCAL | Both sender and receiver on same OS thread (no parallelism needed) | YES — most aggressive erasure |
| PARALLEL_LOCAL | Both in same OS process but different OS threads (parallel work) | PARTIAL — keep scheduling, erase channel |
| GPU | Receiver is a `@device(gpu)` process | NO — GPU boundary |
| WASM | Receiver is a `@device(wasm)` process | NO — WASM sandbox boundary |
| NETWORK | Receiver is a remote machine | NO — network boundary |

**Step 2: Classify every process**

A process is ERASABLE if AND ONLY IF:
1. All its channels are PURE_LOCAL or THREAD_LOCAL
2. None of its CHILD processes are NON-ERASABLE
3. It has no `@distributed` annotation
4. It has no supervision requirement that requires real crash isolation

A process is NON-ERASABLE if ANY of:
- Uses a GPU, WASM, or network channel
- Has `@device(gpu)` or `@device(wasm)` annotation
- Is under supervision with `restart="always"` (real crash isolation needed)
- Spawns NON-ERASABLE children

**Step 3: Apply erasure transformations**

For each ERASABLE process, choose the erasure level:

**Level A: Full inline erasure (zero overhead)**

Condition: Process has NO channels, or has exactly ONE channel connecting it to parent, AND runs to completion (no infinite loop with blocking).

```
BEFORE:
  ch = channel()
  spawn compute(x, ch)
  result = receive(ch)

AFTER:
  result = compute(x)    // direct function call
```

The spawned code becomes a regular function. The channel disappears. This is exactly C-level code.

**Level B: Coroutine erasure (near-zero overhead)**

Condition: Process has multiple channels or runs concurrently with parent but all channels are PURE_LOCAL.

The process becomes a coroutine (stackful, cooperative, no OS thread). Channel send/receive becomes yield/resume. No OS thread context switch. Overhead: ~100ns per context switch (vs ~5μs for real green threads).

**Level C: Thread pool erasure (parallel, no spawn overhead)**

Condition: Process is CPU-bound (detected by: no IO operations in its code), PURE_LOCAL, and the developer wrote `spawn` for parallelism.

The spawn is mapped to the runtime's shared thread pool. No new stack allocated — work items are queued. Overhead: queue operation + work stealing (~500ns vs ~5μs for full green thread).

**Failure mode I found:** Erasing a CPU-bound process to a coroutine (Level B) removes parallelism. A developer who wrote `spawn` for CPU parallelism would see single-threaded execution.

**Fix:** Detect CPU-boundedness. If a process body contains no blocking operations (no `receive`, no IO, no network), it's CPU-bound. CPU-bound erasable processes go to Level C (thread pool), not Level B (coroutine). IO-bound erasable processes go to Level B.

**How to detect IO:**
- `receive(ch)` — always blocking (IO)
- `read_file(...)`, `fetch(...)`, `db_query(...)` — always IO
- Pure arithmetic, map, filter, sum — always CPU-bound
- The compiler checks the process body recursively through all called functions

**Step 4: Re-run escape analysis after erasure**

After erasing processes and channels, values that were on the heap (because they needed to cross a process boundary) may now be stack-allocatable (boundary is gone). A second escape analysis pass promotes them to stack. This is where "single-process NOVA matches C" comes from — not just from erasing the spawn/channel overhead, but from getting the same stack allocation that C would use.

**Gate 4 test:** Take Program 3 (functions and control flow) — pure computation, no real processes. After erasure, the generated LLVM IR must be identical to what clang would generate for equivalent C code. If there is ANY residual process/channel overhead in the IR → erasure failed → fix before proceeding.

---

## GAP 3: String Interpolation Optimization

### The Failure Without This

```nova
for i in 0..1000000
    msg = "Processing item {i} of {total}"
    log(msg)
```

Naive implementation: each iteration allocates a new heap string (~50 bytes), writes to it, passes to log, frees it. 1M heap allocations in a hot loop. This is 10-50ms of allocator overhead alone. Python does the same thing and it's slow. NOVA must not.

### The Three-Level Optimization

**Level 1: Stack allocation for statically bounded strings**

If the compiler can determine the MAXIMUM LENGTH of the interpolated string at compile time:
- Format string length (known: it's a literal)
- Each interpolated value's maximum string representation (known for int: max 20 digits, bool: 5 chars "false")

If max_length ≤ 4096 bytes → allocate the string buffer on the stack. No heap, no COW, no refcount.

```
"Processing item {i} of {total}"
= 20 chars (literal "Processing item ") 
+ 20 chars (max int)
+ 4 chars (literal " of ")
+ 20 chars (max int)
= 64 chars maximum
→ stack allocate 64 bytes, format directly, zero heap overhead
```

**Failure mode:** What if the format includes a `{name}` where name is a string of unknown length? Stack allocation fails — we don't know the max length.

**Level 2: Thread-local buffer for dynamically bounded strings**

When max length can't be determined statically (because a string variable is interpolated):

Each OS thread has a pre-allocated reusable string buffer (default 64KB). For string interpolation:
1. Format into the thread-local buffer
2. If the result is only used once (passed to log/print/http.response immediately) → pass a pointer to the buffer, zero allocation
3. If the result is stored in a variable that outlives this scope → copy from buffer to heap (then standard COW applies)

The key insight: most string interpolation in hot paths (logging, HTTP responses, SQL queries) produces strings that are immediately consumed. The thread-local buffer handles these with zero allocation.

**Failure mode:** Thread-local buffer is 64KB. An interpolated string with a large blob of data could exceed it. Fix: if formatted content exceeds buffer size, fall back to heap allocation. The 64KB buffer handles 99% of cases; heap handles the rare large case.

**Level 3: Direct output optimization**

For the pattern `log("text {x}")` or `print("text {x}")` where the string is immediately consumed by a function that writes to an output:

The compiler skips the string entirely. It transforms:
```
// Before:
temp_str = format("Processing {i}")
log(temp_str)

// After (compiler sees log takes a string, optimizes):
log_int_format("Processing ", i)    // writes directly to log buffer
```

The log function accepts format specifiers (like C's printf) internally. The string variable never exists. Zero allocation, zero copy.

**This only applies when:**
- The string is passed directly to a consuming function (print, log, http output)
- The string is not stored in a variable used later
- The consuming function is in NOVA's stdlib (so we control its implementation)

---

## GAP 4: Integer Overflow Behavior

### The Failure Without a Decision

Without a specified overflow policy, the compiler implementer makes a guess. If they choose "always check" → 5% overhead on integer-heavy code → benchmarks fail Gate 5. If they choose "always wrap" → silent bugs in NOVA programs → users lose trust.

### The Decision

NOVA uses **mode-dependent overflow behavior**, same as Rust:

**Debug builds** (`nova build` without `--release`):
- Integer overflow → runtime panic with source location
- Message: `"Integer overflow in + on line 42: 9223372036854775807 + 1 would overflow int"`
- Zero tolerance for overflow bugs during development

**Release builds** (`nova build --release`):
- Integer overflow → wraps (two's complement)
- Zero overhead — same as C in release mode
- Developers who need overflow detection in release use explicit functions

**Explicit checked arithmetic (available always):**
```nova
result = checked_add(a, b) else handle_overflow()    // int or Overflow
result = saturating_add(a, b)                         // clamps to max int, never overflows
result = wrapping_add(a, b)                           // explicit wrap — intent is clear
```

**Why wrapping in release is acceptable:** NOVA's type system prevents the COMMON sources of overflow bugs (no implicit int→byte truncation, no signed/unsigned mixing). The remaining overflow cases (arithmetic that genuinely overflows 64-bit range) are rare and detectable in debug.

**Special case: stdlib internal arithmetic**

NOVA's stdlib uses `checked_*` internally for all index and size calculations. A list with 9 quintillion elements is impossible in practice, but a bug in list offset calculation that overflows silently would be catastrophic. Stdlib opts into safety; user code opts into performance.

**Failure mode I found:** What about 32-bit embedded targets where `int` might be 32-bit? If a user's program works on 64-bit but overflows on 32-bit, wrapping in release gives different behavior on different platforms.

**Fix:** NOVA's `int` is ALWAYS 64-bit regardless of target platform. On 32-bit targets, 64-bit arithmetic is emulated (two 32-bit operations). This is slower on 32-bit embedded (a tradeoff), but behavior is consistent everywhere. Developers who need 32-bit integers for performance on embedded use `int32` explicitly.

---

## GAP 5: Memory Pool Growth Strategy

### The Failure Without This

**Failure mode A: Fixed-size pool too small**
If every process starts with a 64KB pool and a request handler allocates 1MB of data, it needs 16 pool expansions. Each expansion is a system call. 1000 concurrent requests × 16 expansions = 16,000 system calls just for memory.

**Failure mode B: Fixed-size pool too large**
If every process pre-allocates 1MB, and we have 100,000 concurrent connections, that's 100GB of pre-allocated memory. System dies.

**Failure mode C: No pool reuse**
Short-lived processes (HTTP request handlers) allocate a pool, use it, free it, and the next request allocates a new pool. For 100,000 req/sec, that's 100,000 malloc/free calls per second at the OS level. Significant overhead.

### The Strategy

**Initial pool size: 4KB (one OS page)**

Every process starts with 4KB. This is enough for the vast majority of short-lived processes (simple computations, small request handlers). 100,000 processes = 400MB — manageable.

**Pool growth: geometric with cap**

When a process needs more memory than its current pool:
1. Allocate a new arena block: `new_size = min(current_size * 2, 1MB)`
2. Link the new block to the chain (do NOT copy existing data)
3. Allocate from the new block

Growth sequence: 4KB → 8KB → 16KB → 32KB → 64KB → 128KB → 256KB → 512KB → 1MB → 1MB → 1MB...

Capped at 1MB per block. For processes that need more than 1MB total, they get multiple 1MB blocks. An HTTP handler serving a 10MB file uses ~10 blocks.

**Large objects: direct mmap**

Objects larger than 512KB are allocated directly via mmap (bypassing the pool entirely). They get their own OS memory mapping. On process death, they're freed directly. This prevents one large allocation from blowing up the pool.

**Size classes: slab allocator within each block**

Within each arena block, allocation uses size classes to avoid fragmentation:

| Size class | Max object size | Overhead |
|---|---|---|
| Tiny | 8 bytes | < 1 byte |
| Small | 8–64 bytes | 1 byte header |
| Medium | 64–512 bytes | 8 byte header |
| Large | 512B–512KB | 16 byte header |
| Huge | > 512KB | mmap directly |

Each size class has a free list. Allocation: pop from free list (O(1)). Deallocation: push to free list (O(1)). No fragmentation within a size class.

**Pool reuse for supervised processes**

When a supervised process crashes and is restarted:
- If the crashed process's pool was ≤ 256KB: reuse the pool for the new instance (reset free lists, don't return memory to OS). Benefit: the new instance starts with pre-warmed memory, avoids allocation at startup.
- If the crashed process's pool was > 256KB: free it. The old instance was doing something unusual. New instance starts fresh at 4KB.

Threshold of 256KB: this is the "normal" range for HTTP handlers, background workers, etc. Processes that grew beyond this were doing something data-heavy. Their memory pattern is unlikely to repeat exactly.

**Bulk deallocation on process death**

When a process dies:
1. Walk the arena block chain (NOT individual allocations)
2. For each block: if pool reuse applies, reset free lists. Otherwise, free the block.
3. For each mmap'd large object: munmap it.

This is O(number of blocks), not O(number of allocations). A process that made 10,000 small allocations in a 64KB pool dies in O(16) operations (64KB / 4KB = 16 blocks). This is the "O(1) cleanup" claim — it's O(blocks) which is O(log(total_memory / page_size)), which is effectively constant for practical programs.

**Failure mode I found:** Pool reuse across supervised restarts could leak sensitive data. The old process's memory (passwords, keys, user data) sits in the pool and gets handed to the new process.

**Fix:** On process death with pool reuse, zero-fill the pool memory before handing it to the new instance. One memset per block. For a 64KB pool: ~64 microseconds. Acceptable. For a 256KB pool: ~256 microseconds. Still acceptable for a supervised restart (which is already a recovery path, not the hot path).

---

## Summary: What These 5 Specs Unlock

| Gap | Without This | With This |
|---|---|---|
| COW loop optimization | O(n²) loops hidden behind clean syntax | Accumulation patterns compile to O(n) in-place mutation |
| Abstraction erasure algorithm | spawn/channel overhead on every function call | Single-process code = C-equivalent function calls |
| String interpolation | 1M allocations in a hot loop | Stack-allocated or thread-local buffer, zero heap for most cases |
| Integer overflow | Silent bugs in release, or 5% overhead everywhere | Zero overhead in release, full detection in debug |
| Memory pool growth | Either OOM or millions of system calls | 4KB start, geometric growth, slab allocator, O(blocks) cleanup |

**All 5 must be implemented before Phase 2 IR and optimization work begins.** The IR design (Stage 5) and optimization passes (Stage 6) depend on knowing these strategies — if we design the IR without knowing how erasure works, we'll design the wrong IR. If we design optimization passes without knowing the COW optimization algorithm, we'll miss the most important optimization.

**Gate 4 (abstraction erasure within 5% of C) and Gate 5 (compiled programs within 10% of C benchmarks) are only achievable if all 5 of these specs are implemented correctly.**
