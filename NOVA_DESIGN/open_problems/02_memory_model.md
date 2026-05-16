# The Memory Model — Resolved Through Process Ownership

## Status: RESOLVED IN PRINCIPLE — The process model IS the memory model

## Original Question

What memory management model does NOVA use? Ownership? ARC? GC? How do different strategies coexist?

## Answer: The Process Model Solves This

The previous analysis treated memory as a SEPARATE problem from the core model. That was wrong. The Three Primitives model inherently defines memory semantics:

**Every value is owned by exactly one process.**

That single rule resolves the entire memory model:

### Rule 1: Values Live Inside Processes
When you create a value, it belongs to the current process. No other process can see it, touch it, or corrupt it. This is automatic — no annotation needed.

```nova
name = "Alice"     // owned by this process, stack or heap — compiler decides
data = [1, 2, 3]   // owned by this process
```

### Rule 2: Sending Transfers Ownership
When you send a value through a channel, you give it away. You can't use it anymore. The receiving process now owns it.

```nova
send(channel, data)
// data is gone from this process — compiler error if you try to use it
```

This is Rust's move semantics, but the developer never thinks about it that way. They think: "I sent the data somewhere." The fact that this also provides memory safety is invisible.

### Rule 3: Copy When You Need To Keep It
If you want to send data but also keep it, you copy explicitly.

```nova
send(channel, copy(data))
// data is still here — you sent a copy
```

### Rule 4: The Compiler Chooses the Allocation Strategy
The developer NEVER specifies stack vs heap, owned vs reference-counted, arena vs pool. The compiler analyzes the code and picks the best strategy:

- Value never escapes the function → stack allocated (zero cost)
- Value is sent to another local process → move (zero cost)
- Value is sent to a remote process → serialize + send (necessary cost)
- Value is shared by multiple parts of the same process → compiler uses ARC internally (but the developer never sees it)
- Values in hot compute loops → compiler uses arena allocation (bulk allocate, bulk free)

The developer writes `x = SomeStruct { ... }` and the compiler handles everything.

### Rule 5: Expert Override Exists But Is Never Required

For systems programmers who need explicit control:

```nova
@stack x = buffer(4096)              // force stack allocation
@arena(compute_pool) data = load()   // force arena allocation
@pinned gpu_data = tensor([...])     // force pinned memory for GPU transfer
```

These annotations are for the 5% of code that needs explicit control. The 95% default path is fully automatic.

## Why This Beats Every Existing Approach

| Approach | Problem | How NOVA Avoids It |
|---|---|---|
| Rust ownership | Lifetime annotations, borrow checker fights | Process boundaries are ownership boundaries. No annotations needed. |
| Swift ARC | Retain cycles, overhead on every copy | ARC is only used internally by the compiler when needed, never exposed to developer. |
| Go/Java GC | Pauses, unpredictable latency | No GC. Values are owned by processes and freed when the process ends or sends them away. |
| C manual | Use-after-free, double-free, dangling pointers | Compiler enforces ownership at channel boundaries. Can't use a value after sending it. |
| "Hybrid" approach | Complex boundary semantics between models | No boundaries. ONE model everywhere. Compiler picks strategy, developer writes simple code. |

## The Previous "Unsolved" Questions — Now Answered

**Q: What is the DEFAULT?** Values are owned by the creating process. No annotation needed. Compiler picks allocation strategy.

**Q: How do developers opt into different models?** They don't need to. The compiler infers the best strategy. For the 5% expert case, annotations like `@stack`, `@arena`, `@pinned` exist.

**Q: What happens at boundaries?** Sending through a channel = ownership transfer. Receiving through a channel = you now own it. Cross-machine = automatic serialization. Cross-device (CPU→GPU) = automatic memory transfer. The boundary semantics are INHERENT in the channel model.

## Connection to the Whole System

- **Simplicity (beats Python):** Developer writes `x = value`. No types, no allocation, no ownership keywords. Simpler than Python because Python has mutable shared state bugs — NOVA doesn't.
- **Performance (beats C):** Compiler-chosen allocation means optimal strategy for each case. Stack when possible, arena for bulk, move for transfers. No universal GC overhead.
- **Safety (beats Rust accessibility):** Same compile-time guarantees as Rust but without the annotation burden. The process model gives clear ownership boundaries without explicit lifetime tracking.
- **Robustness (beats Erlang):** Process crash = all its values are freed. No leaked memory, no corrupted shared state. Memory safety and fault tolerance are the SAME MECHANISM.

## Engineering Work Remaining

1. **Escape analysis quality:** How good must the compiler's escape analysis be to correctly choose stack vs heap? This is well-studied (JVM, Go) but NOVA's multi-target compilation adds complexity.

2. **Arena lifecycle:** When processes use arena allocation internally, when exactly does the arena get freed? End of function? End of request? Developer-specified scope?

3. **Large value transfer optimization:** When a 500MB tensor is sent through a local channel, can the compiler prove it's safe to transfer the pointer instead of copying? This is critical for AI workloads.

4. **Cross-device memory:** GPU VRAM, CPU RAM, and distributed memory are physically different. The automatic transfer must be efficient. Can the compiler batch transfers? Pre-allocate buffers?
