# Type Safety Across Domains — Resolved Through Typed Channels

## Status: RESOLVED IN PRINCIPLE — The channel model IS the type safety boundary

## Original Question

When NOVA code crosses domain boundaries — local→remote, CPU→GPU, server→browser, native→WASM — how does the type system maintain safety?

## Answer: Channels Are Typed Boundaries

The previous analysis treated cross-domain type safety as a SEPARATE problem. But in the Three Primitives model, EVERY cross-domain interaction is a value flowing through a channel. And channels are TYPED. So cross-domain type safety is just: the compiler verifies both ends of a channel agree on the value type.

### How It Works

```nova
// The channel type declares what values flow through it
ch = channel<ImageResult>()

// Process A (runs on server) sends a value
send(ch, ImageResult { data: processed, confidence: 0.95 })

// Process B (runs in browser) receives the value
result = receive(ch)    // compiler knows this is ImageResult
```

The compiler sees:
1. `ch` carries `ImageResult` values
2. Process A sends an `ImageResult` — type matches ✓
3. Process B receives — compiler infers the type is `ImageResult` ✓
4. If Process A tried to send a `string` through `ch`, compile error

This works WHETHER the channel is:
- Local (both processes on same machine) → direct memory transfer, zero serialization
- Network (processes on different machines) → compiler generates serialization/deserialization
- Cross-device (CPU→GPU) → compiler generates memory transfer code
- Cross-target (server→browser) → compiler generates WASM-compatible encoding

The SAME channel type declaration handles ALL of these. The compiler chooses the transfer mechanism. The developer writes the same code regardless of where processes run.

### Capability Inference (Not Annotation)

The compiler automatically knows which types can cross which boundaries:

```nova
// This type can go anywhere — it's pure data
Point { x: float, y: float }
// Compiler infers: Sendable, GpuSafe, WasmSafe, Copyable, Persistent

// This type can't leave the local machine — it holds a system resource
Connection { handle: file_descriptor }
// Compiler infers: NOT Sendable, NOT GpuSafe, NOT WasmSafe

// This type can go to GPU but not over network (too large, not serializable efficiently)
LargeModel { weights: tensor[1000000000] }
// Compiler infers: GpuSafe (direct VRAM transfer), NOT Sendable (too large for network)
```

The developer NEVER annotates these capabilities. The compiler derives them from the type's structure. If you try to send a `Connection` through a network channel, the compiler says:

> "Connection contains a file_descriptor which can't be sent over the network. File descriptors are local to the operating system. Consider sending the file's contents instead."

Not a cryptic type error. A helpful explanation of WHY it can't work and WHAT to do instead.

### The Developer Experience

For 95% of code, the developer never thinks about cross-domain types:

```nova
// Server process
server = spawn {
    data = load_from_database(id)    // value: user data
    result = spawn predict(data)      // send to AI process, get result back
    send(browser_channel, result)     // send to browser
}
```

The compiler handles:
- `data` is a pure data value → can be sent anywhere
- `predict` might run on GPU → compiler generates GPU transfer if needed
- `result` goes to browser → compiler generates WASM-compatible serialization

The developer wrote NO type annotations, NO serialization code, NO GPU transfer code, NO WASM bridge code. The compiler did all of it because the Three Primitives model gives it enough information.

### Schema Evolution (Distributed Versioning)

When a server sends values to a client, and the server updates its types:

```nova
// Server v1
UserData { name: string, age: int }

// Server v2 adds a field
UserData { name: string, age: int, email: string }
```

The compiler generates versioned serialization. When v2 server sends to v1 client:
- The `email` field is present in the wire format but v1 client ignores it (forward compatibility)
- When v1 server sends to v2 client, `email` is missing — the compiler requires a default value at v2 definition time (backward compatibility)

This is similar to protobuf's field evolution but built into the language, not a separate schema definition.

## Connection to the Whole System

- **Simplicity:** Developer writes `send(channel, value)`. Compiler handles serialization, GPU transfer, WASM encoding. Simpler than Python because Python has no type safety at all across process boundaries.
- **Safety:** Compiler catches type mismatches at channel boundaries at compile time. No runtime serialization errors. No "wrong type received" crashes.
- **Performance:** Local channels use zero-copy. Remote channels use efficient binary serialization. GPU channels use DMA transfer. The compiler picks the fastest path.
- **Platform independence:** The same channel code works whether both processes are local, remote, cross-device, or cross-target. The channel abstraction hides the boundary mechanics.

## Engineering Work Remaining

1. **Serialization format:** NOVA needs a canonical binary format for values crossing network boundaries. Should it be a custom format (optimized for NOVA types) or a standard format (protobuf, flatbuffers)?

2. **Zero-copy verification:** The compiler must PROVE that a local channel transfer is safe to do via pointer passing rather than copying. What analysis is needed? This is related to escape analysis.

3. **GPU memory layout:** Types used on GPU need specific alignment and layout. The compiler must generate appropriate padding/alignment when a value is sent to a GPU process. How transparent can this be?

4. **Versioned type evolution rules:** Exactly which type changes are backward/forward compatible? Adding fields yes. Removing fields? Changing field types? These rules need formal definition.
