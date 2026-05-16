# NOVA Type System: Unified Through the Three Primitives

## Status: ARCHITECTURE DEFINED — Details need engineering

## The Core Insight

NOVA's type system is not a separate design problem. It flows directly from the Three Primitives model:

- **Value types** describe what data exists
- **Channel types** describe what data flows where
- **Process types** describe what a process accepts and produces

The type system is the STATIC DESCRIPTION of the Three Primitives. The compiler uses types to verify that values, processes, and channels are used correctly — all at compile time, all without developer annotations.

## How It Works

### Values Have Types (Inferred, Not Annotated)

```nova
name = "Alice"                    // compiler infers: string
age = 30                          // compiler infers: int
items = [1, 2, 3]                 // compiler infers: List<int>
point = { x: 1.0, y: 2.0 }       // compiler infers: { x: float, y: float }
image = tensor([3, 224, 224])     // compiler infers: Tensor<float, [3, 224, 224]>
```

The developer writes values. The compiler infers types. For 95% of code, zero annotations.

When annotations help clarity or are needed for function signatures:

```nova
fn distance(a: Point, b: Point) -> float
    sqrt((a.x - b.x)^2 + (a.y - b.y)^2)
```

Function parameters often benefit from type annotations for documentation. Return types are inferred. The developer annotates WHEN IT HELPS, not because the compiler demands it.

### Channels Have Types (Inferred From Usage)

```nova
ch = channel()                // type inferred from first send
send(ch, "hello")             // compiler now knows: channel<string>
send(ch, 42)                  // COMPILE ERROR: channel carries string, not int
```

Or declared explicitly when needed:

```nova
requests = channel<HttpRequest>()
responses = channel<HttpResponse>()
```

Channel types guarantee that both ends — sender and receiver — agree on what data flows through. This catches errors at compile time that Python/Erlang catch at runtime (or never catch).

### Processes Have Types (Inferred From Channels)

A process's type is determined by what channels it reads from and writes to:

```nova
worker = spawn {
    request = receive(input_channel)     // input: HttpRequest
    result = process(request)
    send(output_channel, result)         // output: ProcessedResult
}
// compiler infers worker type: Process<in: HttpRequest, out: ProcessedResult>
```

This means the compiler can verify that processes are connected correctly — the output channel type of one process matches the input channel type of the next.

### Unified Type Properties — Every Type Naturally Has These

The compiler automatically derives properties for every type based on its structure:

| Property | Meaning | Derived From |
|---|---|---|
| Copyable | Can be duplicated | All fields are copyable (primitives, value types) |
| Sendable | Can cross network boundaries | All fields are serializable (no file handles, no pointers) |
| GpuSafe | Can exist on GPU | No pointers, no dynamic allocation, fixed size, aligned |
| WasmSafe | Can exist in WASM | No platform-specific types, serializable |
| Equatable | Can be compared | All fields support equality |
| Printable | Can be converted to string | All fields have string representations |

The developer NEVER declares these. A `Point { x: float, y: float }` automatically has ALL of these properties. A `Connection { handle: file_descriptor }` automatically has NONE of the cross-boundary properties (but IS equatable and printable).

When the developer tries something the type doesn't support, the compiler explains WHY:

> "Can't send Connection through network channel. Connection contains file_descriptor which is a local OS resource. To send connection info over the network, send the host and port instead: ConnectionInfo { host: string, port: int }"

### Tensor Types — Shapes as Types

AI values need shape information:

```nova
image = tensor([3, 224, 224])        // Tensor<float, [3, 224, 224]>
weights = tensor([1000, 512])        // Tensor<float, [1000, 512]>

result = weights @ image.flatten()   // compiler checks: [1000, 512] × [150528] — shape mismatch!
result = weights @ image.reshape([512]) // compiler checks: [1000, 512] × [512] = [1000] ✓
```

The compiler tracks tensor shapes through operations and catches dimension mismatches at compile time. This finds bugs that Python/PyTorch only catch at runtime (and often with cryptic error messages).

Shape inference uses simple arithmetic rules — not full dependent types (which are too complex). The compiler can verify: matrix multiplication dimension compatibility, reshape validity, broadcasting rules. When shapes can't be determined statically (loaded from file), the compiler inserts runtime checks.

### Sum Types — Clean Error Handling

```nova
// Result type for operations that can fail
fn read_file(path) -> string or Error
    // ... 

// Using it
content = read_file("config.txt") or "default config"

// Or pattern matching
match read_file("config.txt")
    value -> process(value)
    Error(e) -> log("Failed: {e}")
```

`or` types (sum types) let NOVA express: "this value is EITHER a success OR an error." The compiler ensures you handle both cases. But the `or` keyword makes the 70% case (provide a default) into ONE WORD.

## How This Type System Beats Existing Ones

| Language Type System | Weakness | How NOVA Avoids It |
|---|---|---|
| Rust | Lifetime annotations, complex generic bounds (`Box<dyn Trait + Send + Sync + 'static>`) | No lifetimes in types. Process boundaries handle ownership. Generic bounds inferred from usage. |
| Python | No types at all. Runtime errors from type mismatches. | Full static types, but ALL inferred. Same developer experience, no runtime errors. |
| Java | Verbose generics with type erasure. `List<? extends Comparable<? super T>>` | Generics inferred from usage. No erasure — compiler monomorphizes (like Rust) for performance. |
| Go | No generics until recently. Interface satisfaction is implicit (can be confusing). | Full generics from day one. Structural typing where it helps, nominal where it matters. |
| Haskell | Extremely powerful but intimidating. Higher-kinded types, monads, type families. | NOVA's types are practical, not academic. No monads, no HKT. Power through simplicity, not abstraction. |
| TypeScript | Structural typing is useful but unsound. Types don't guarantee runtime behavior. | NOVA types are sound — if it compiles, the types are correct at runtime. |

## Engineering Work Remaining

1. **Inference algorithm:** Hindley-Milner extended with constraints for channels, processes, and tensor shapes. How far can inference go before it needs annotations? Where does it produce confusing error messages?

2. **Generics implementation:** Monomorphization (Rust-style, fast but big binaries) vs dictionary passing (Haskell-style, small binaries but overhead). For multi-target compilation, monomorphization may generate too much code for WASM. Needs analysis.

3. **Structural vs nominal typing boundary:** Where exactly does NOVA use structural typing (shape matching) vs nominal typing (name matching)? Proposal: anonymous types (`{ x: float, y: float }`) are structural, named types (`Point`) are nominal.

4. **Tensor shape inference limits:** What operations can the compiler track shapes through? Matrix multiplication, reshape, transpose — yes. Arbitrary index expressions — probably not. Where is the line?

5. **Error message quality for inferred types:** When the compiler infers a complex type and something goes wrong 10 function calls deep, how does the error message stay simple? This is a UX problem as much as a compiler problem.
