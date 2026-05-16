# Phase 0, Step 0.2: Type System Rules

**Status: IN PROGRESS**
**Goal: Define NOVA's type system. Hand-trace inference on all 10 programs. Prove 95%+ needs zero annotations.**

---

## 0.2.1 — Primitive Types

Every primitive type has an exact size, a default value, and defined behavior for every operation.

| Type | Size | Default | What It Is | Operations |
|---|---|---|---|---|
| `int` | 64-bit signed | 0 | Whole numbers | `+ - * / % ** == != < > <= >=` |
| `float` | 64-bit IEEE 754 | 0.0 | Decimal numbers | `+ - * / % ** == != < > <= >=` |
| `bool` | 8-bit | false | True/false | `and or not == !=` |
| `byte` | 8-bit unsigned | 0 | Raw byte value | `== != < > <= >=`, bitwise functions |
| `string` | variable (UTF-8) | "" | Text | `+ == != < > <= >=`, `.length`, `.split()`, `.contains()`, interpolation |

**Why 64-bit int by default:** Most modern platforms are 64-bit. Choosing a smaller default (32-bit) causes silent overflow in common scenarios (file sizes, timestamps, large counts). 64-bit eliminates overflow for all practical purposes. If a developer needs smaller integers for performance: `int32`, `int16`, `int8` are available but never the default.

**Why 64-bit float by default:** Same reasoning. `float32` available for GPU/memory-constrained work.

**Sized variants (available, never required):**

| Type | Variants |
|---|---|
| `int` | `int8`, `int16`, `int32`, `int64` (default) |
| `float` | `float32`, `float64` (default) |

**Type promotion rules:**
- `int + float` → `float` (int is promoted to float). This is the ONLY implicit promotion.
- `int + string` → compile error ("Can't add int to string. Use string interpolation: `\"{x} text\"`")
- `float + string` → compile error (same)
- `int + bool` → compile error ("Can't add int to bool. bool is not a number.")
- NO other implicit conversions. Everything else requires explicit conversion: `float(x)`, `int(x)`, `string(x)`.

**Why minimal promotion:** JavaScript's `"1" + 1 = "11"` and Python's `True + 1 = 2` are constant sources of bugs. NOVA allows only one promotion (int→float in arithmetic) because it's mathematically sound and universally expected. Everything else is explicit.

**Verification against the system:**
- Ownership: primitives are always Copyable (they're small, fit in registers). Sending an `int` through a channel copies it, never moves. ✓
- Capabilities: all primitives are Copyable, Sendable, GpuSafe, WasmSafe, Equatable, Printable. ✓
- Performance: primitives compile to machine registers. No overhead. ✓

---

## 0.2.2 — Compound Types

### List<T>

```nova
items = [1, 2, 3]          // List<int> — inferred from elements
names = ["Alice", "Bob"]    // List<string> — inferred from elements
empty = []                  // List<???> — type unknown until first use
```

**Inference rule:** Element type inferred from literal elements. If empty, inferred from first operation:
```nova
empty = []
empty.append(42)            // NOW compiler knows: List<int>
empty.append("text")        // COMPILE ERROR: List<int> can't hold string
```

**Implementation:** Array-backed with amortized O(1) append (like Java ArrayList / Python list). Copy-on-write semantics for assignment.

**Key operations:** `.length`, `.append(x)`, `.map(fn)`, `.filter(fn)`, `.reduce(fn, init)`, `.sum()`, `.sort()`, `.contains(x)`, `list[index]`

### Map<K, V>

```nova
ages = {"Alice": 30, "Bob": 25}    // Map<string, int>
config = {}                         // Map<???, ???> — inferred from first use
```

**Inference rule:** Key and value types inferred from literal entries or first insertion.

**Key constraint:** Keys must be Equatable (compiler auto-derives this). Most types are Equatable. Types with mutable internal state or raw pointers are NOT.

**Key operations:** `.get(key)` returns `V else Nothing`, `.set(key, value)`, `.keys()`, `.values()`, `.contains(key)`, `.length`, `map[key]`

### Set<T>

```nova
unique = {1, 2, 3}               // Set<int>
```

**Ambiguity with Map:** `{}` is empty Map. `{1, 2, 3}` could be Set OR a Map with int keys and... no. Sets use `{value, value}`, Maps use `{key: value, key: value}`. The presence of `:` disambiguates.

Wait — this IS ambiguous for single-element cases. `{42}` — Set with one int, or broken Map?

**Fix:** Sets use explicit construction: `Set(1, 2, 3)` or `Set([1, 2, 3])`. `{...}` is ALWAYS a Map (with `:` for key-value pairs) or anonymous struct (with field names).

```nova
unique = Set(1, 2, 3)             // Set<int>
ages = {"Alice": 30, "Bob": 25}   // Map<string, int>
point = { x: 1.0, y: 2.0 }       // anonymous struct { x: float, y: float }
```

No ambiguity. `{}` with `:` → Map or struct. `Set(...)` → Set.

### Tuple

```nova
pair = (1, "hello")              // (int, string)
triple = (true, 3.14, "yes")    // (bool, float, string)
```

**Inference rule:** Each position has its own type. Tuples are fixed-size, heterogeneous.

**Destructuring:**
```nova
(x, y) = pair                    // x: int, y: string
(_, _, answer) = triple          // answer: string
```

**Difference from struct:** Tuples are anonymous and positional. Structs have named fields. Use structs when fields have meaning. Use tuples for quick groupings (returning multiple values, match patterns).

### Struct (named type)

```nova
type Point
    x: float
    y: float
```

**Field types are REQUIRED in type definitions.** This is one of the <5% cases where the developer writes types. Why: type definitions are the INTERFACE — other code depends on these types. Requiring field types here serves as documentation and catches errors early.

**Construction and access:**
```nova
p = Point { x: 1.0, y: 2.0 }    // type is Point — inferred from constructor
print(p.x)                        // 1.0
```

**Anonymous struct (inline, no type declaration):**
```nova
point = { x: 1.0, y: 2.0 }      // type: { x: float, y: float }
```

Anonymous structs use STRUCTURAL typing (shape matters, not name). Named structs use NOMINAL typing (name matters).

```nova
type Point { x: float, y: float }
type Vector { x: float, y: float }

p = Point { x: 1.0, y: 2.0 }
v = Vector { x: 1.0, y: 2.0 }

// p and v are DIFFERENT types (nominal — different names)
// Can't assign p = v without explicit conversion

anon = { x: 1.0, y: 2.0 }
// anon is structurally compatible with both Point and Vector
// Can pass anon where Point or Vector is expected
```

**Why this dual approach:** Named types give you strong guarantees (a `UserId` is not a `ProductId` even if both are `int`). Anonymous types give you flexibility for quick scripting. Progressive disclosure — beginners use anonymous structs, experts use named types for safety.

### Enum (Sum Type)

```nova
type Color
    enum Red, Green, Blue

type Shape
    enum
        Circle(radius: float)
        Rectangle(width: float, height: float)
```

**Variant types:**
- Simple variants (no data): `Red`, `Green`, `Blue` — like C enums
- Data variants: `Circle(radius: float)` — each variant carries typed data

**Pattern matching with enums:**
```nova
match shape
    Circle(r) => 3.14159 * r ** 2
    Rectangle(w, h) => w * h
```

The compiler verifies ALL variants are handled. Missing a variant = compile error. This is exhaustive matching — prevents bugs at compile time.

**Inline sum type with `or`:**
```nova
fn read_file(path) -> string or Error
```

`string or Error` is a sum type: the value is EITHER a `string` OR an `Error`. No type declaration needed for simple alternatives.

### Tensor<T, Shape>

```nova
image = tensor([3, 224, 224])           // Tensor<float, [3, 224, 224]>
weights = tensor([1000, 512])           // Tensor<float, [1000, 512]>
```

**Shape is part of the type.** The compiler tracks tensor dimensions through operations:

```nova
a = tensor([3, 4])          // Tensor<float, [3, 4]>
b = tensor([4, 5])          // Tensor<float, [4, 5]>
c = matmul(a, b)            // Tensor<float, [3, 5]> — compiler checks [3,4]×[4,5] → [3,5] ✓
d = matmul(a, a)            // COMPILE ERROR: [3,4]×[3,4] — inner dimensions don't match (4≠3)
```

**Shape inference rules:**
- `matmul(A[m,n], B[n,p])` → result shape `[m,p]`. Requires inner dimensions equal.
- `reshape(A[...], [new_shape])` → requires product of dimensions equals product of old dimensions.
- `transpose(A[m,n])` → `[n,m]`
- Element-wise ops (`+`, `-`, `*`): shapes must match or be broadcastable (NumPy broadcasting rules).

**When shape is unknown at compile time (loaded from file):**
```nova
model_weights = load_tensor("weights.bin")    // Tensor<float, ?> — shape unknown
```
Compiler inserts runtime shape checks for operations involving unknown shapes. This is the only case where type checking defers to runtime for tensors.

---

## 0.2.3 — Channel Type Rules

**Core rule:** A channel carries exactly one type of value. The type is inferred from the first `send` or `receive`.

```nova
ch = channel()                // channel<???> — type unknown
send(ch, 42)                  // NOW: channel<int>
send(ch, "hello")             // COMPILE ERROR: channel<int> can't carry string
```

**Explicit channel type (when needed):**
```nova
ch = channel::<HttpRequest>()  // channel<HttpRequest> — explicit
```

**Inference algorithm for channels:**

Step 1: When `channel()` is called, create a type variable: `ch: channel<T1>` where T1 is unknown.

Step 2: When `send(ch, value)` is encountered, generate constraint: `T1 = typeof(value)`.

Step 3: When `receive(ch)` is encountered, the result type is `T1`.

Step 4: Unification resolves T1 to the concrete type.

**Example trace:**
```nova
ch = channel()          // ch: channel<T1>, T1 = ???
send(ch, "hello")       // constraint: T1 = string → T1 resolved to string
msg = receive(ch)       // msg: T1 = string ✓
```

**Channel passed to another function:**
```nova
fn producer(ch)
    send(ch, 42)

fn consumer(ch)
    msg = receive(ch)
    print(msg)

ch = channel()
spawn producer(ch)
spawn consumer(ch)
```

Inference trace:
1. `ch = channel()` → `ch: channel<T1>`
2. `producer(ch)` → parameter `ch` in producer has type `channel<T1>`
3. Inside producer: `send(ch, 42)` → constraint `T1 = int`
4. Inside consumer: `receive(ch)` → `msg: T1 = int`
5. Unification: T1 = int. All consistent. ✓

**What if sender and receiver disagree?**
```nova
fn producer(ch)
    send(ch, 42)

fn consumer(ch)
    msg = receive(ch)
    msg.length             // treating msg as string — .length is a string operation

ch = channel()
spawn producer(ch)
spawn consumer(ch)
```

Inference:
1. producer sends `int` → T1 = int
2. consumer calls `.length` on msg → T1 must be `string` (or `List`, which also has .length)
3. Unification: T1 = int AND T1 = string → **CONFLICT**
4. **COMPILE ERROR:** "Channel `ch` carries `int` (sent on line X), but receiver treats it as `string` (line Y). These types are incompatible."

This catches bugs that Python/Erlang only catch at runtime (or never catch).

---

## 0.2.4 — Process Type Rules

A process's type is inferred from what channels it reads and writes.

```nova
worker = spawn
    req = receive(input_ch)      // reads HttpRequest from input_ch
    result = process(req)
    send(output_ch, result)      // writes ProcessedResult to output_ch
```

Compiler infers: `worker` is a process that reads `channel<HttpRequest>` and writes `channel<ProcessedResult>`.

**Why this matters:** The compiler can verify that processes are WIRED CORRECTLY — the output type of one process matches the input type of the next.

```nova
ch1 = channel()           // channel<RawData>
ch2 = channel()           // channel<ProcessedData>

spawn parser(ch1, ch2)    // reads RawData from ch1, writes ProcessedData to ch2
spawn analyzer(ch2)       // reads ProcessedData from ch2

// If parser writes int to ch2 but analyzer expects string → COMPILE ERROR
```

**Process type inference is a CONSEQUENCE of channel type inference.** We don't need a separate mechanism. The channels a process uses define its type. The compiler simply checks that connected channels have compatible types.

---

## 0.2.5 — Capability Derivation Rules

The compiler automatically derives capabilities for every type based on its STRUCTURE. No annotations ever needed.

**Algorithm:** For each type, check each field. The type has a capability only if ALL fields have it.

| Capability | Rule | What It Means |
|---|---|---|
| `Copyable` | All fields are copyable (primitives, other copyable types) | Can be duplicated in memory |
| `Sendable` | All fields are serializable (no file handles, no raw pointers, no process-local resources) | Can cross network boundaries |
| `GpuSafe` | All fields are fixed-size, properly aligned, no pointers | Can exist in GPU VRAM |
| `WasmSafe` | All fields are platform-independent, serializable | Can exist in WASM linear memory |
| `Equatable` | All fields support `==` | Can be compared for equality |
| `Printable` | All fields have string representation | Can be converted to string |

**Example derivation:**

```nova
type Point
    x: float
    y: float
```

- `x: float` → Copyable ✓, Sendable ✓, GpuSafe ✓, WasmSafe ✓, Equatable ✓, Printable ✓
- `y: float` → same
- ALL fields have ALL capabilities → Point has ALL capabilities

```nova
type Connection
    handle: FileDescriptor
```

- `handle: FileDescriptor` → Copyable ✓ (it's an int internally), BUT Sendable ✗ (OS-local resource), GpuSafe ✗, WasmSafe ✗
- Connection: Copyable ✓, Sendable ✗, GpuSafe ✗, WasmSafe ✗, Equatable ✓, Printable ✓

**What happens when you violate capabilities:**

```nova
conn = Connection { handle: open("file.txt") }
send(network_ch, conn)    // COMPILE ERROR:
// "Can't send Connection through network channel.
//  Connection contains FileDescriptor which is an OS-local resource.
//  FileDescriptor can't cross machine boundaries.
//  Consider sending the file contents instead: read_file(conn)"
```

The error message explains WHY and suggests WHAT TO DO. Not a cryptic type error.

---

## 0.2.6 — Sum Type / `or` Type Rules

### Definition

`A or B` creates a sum type: the value is EITHER an A OR a B, never both, never neither.

```nova
fn read_file(path) -> string or Error       // returns string on success, Error on failure
fn find_user(id) -> User or NotFound        // returns User if found, NotFound if not
```

### Using `else` to Handle Sum Types

```nova
content = read_file("config.txt") else "{}"
```

**How this works internally:**
1. `read_file` returns `string or Error`
2. `else "{}"` means: if the result is `Error`, use `"{}"` instead
3. Compiler unwraps: `content` has type `string` (not `string or Error`)
4. The `else` clause's type must match the success type: `"{}"` is `string`, matches `string` ✓

**Inference rule for `else`:**
```
If expr has type `A or B` and default has type `A`:
    (expr else default) has type A
```

### Using `match` for Detailed Handling

```nova
match read_file("data.csv")
    content => process(content)       // content: string
    FileNotFound => create_default()  // matched specific error variant
    Error(msg) => log(msg)            // matched general Error with data
```

**Exhaustiveness:** Compiler verifies ALL variants are handled. If you miss one:
```
COMPILE ERROR: match on `string or Error` is not exhaustive.
Missing case: Error. Add a `_ => ...` wildcard or handle Error explicitly.
```

### Nested Sum Types

```nova
fn parse_config(path) -> Config or FileError or ParseError
```

This is `Config or FileError or ParseError` — a three-way sum type. All three must be handled.

### The `Nothing` Type

For optional values (equivalent to null/None in other languages):

```nova
fn find(list, predicate) -> T or Nothing
```

`Nothing` is a built-in type with exactly one value: `nothing`. It replaces null/nil/None.

```nova
result = find(users, u => u.name == "Alice") else default_user
// OR
match find(users, u => u.name == "Alice")
    user => print(user.name)
    nothing => print("Not found")
```

**Why `Nothing` instead of `null`:** null is a billion-dollar mistake (Tony Hoare's words). It infects every type — any value MIGHT be null. In NOVA, `Nothing` is explicit in the type: `User or Nothing`. If a function returns `User` (no `or Nothing`), it ALWAYS returns a User. The compiler guarantees it.

---

## 0.2.7 — Generic Type Rules

### Generic Functions

```nova
fn first(list)
    list[0]
```

**Inference:** The compiler sees `list[0]` — list must be indexable. The return type is the element type of list. Generically: `fn first<T>(list: List<T>) -> T`. But the developer writes NONE of this. The compiler infers it from usage.

**How inference works for generics:**

1. `first` is called: `first([1, 2, 3])`
2. Argument type: `List<int>`
3. Inside `first`: `list[0]` — indexing a `List<int>` returns `int`
4. Return type: `int`
5. No generic annotation needed.

If `first` is called with different types:
```nova
first([1, 2, 3])          // T = int, returns int
first(["a", "b"])          // T = string, returns string
```

The compiler MONOMORPHIZES: generates separate versions of `first` for each T. Same as Rust. Zero runtime overhead.

### Generic Type Definitions

```nova
type Pair<A, B>
    first: A
    second: B
```

Type parameters `<A, B>` in definitions are the ONE place where generic syntax is written. But at USAGE, types are inferred:

```nova
p = Pair { first: 1, second: "hello" }    // Pair<int, string> — inferred
```

### Generic Constraints (Rare — the <5% Case)

When a generic function needs a specific capability:

```nova
fn sort(list: List<T>) -> List<T>
    // ... needs T to support < comparison
```

**How the compiler handles this:** It sees `<` used on T values inside `sort`. It generates a constraint: T must be Comparable (support `<`). When `sort` is called, the compiler checks: does the actual type support `<`?

```nova
sort([3, 1, 2])           // int supports < ✓
sort([Point{...}, ...])   // COMPILE ERROR: Point doesn't support <
                           // "Can't sort List<Point>: Point has no ordering.
                           //  To make Point sortable, define: fn compare(a: Point, b: Point) -> int"
```

**The developer NEVER writes the constraint.** The compiler infers it from the operations used inside the function. This is how Rust trait bounds work, but without writing `<T: Ord>`. The compiler does it automatically.

**When does this fail?** When a function is used with many different types and the compiler can't determine constraints from the body alone (because the body delegates to another generic function). In that case, the public API boundary may need a type annotation. This is rare and is part of the <5%.

### Monomorphization

Every generic function is compiled into specialized versions for each concrete type used:

```nova
fn identity(x) x

identity(42)        // compiler generates: fn identity_int(x: int) -> int { x }
identity("hello")   // compiler generates: fn identity_string(x: string) -> string { x }
```

**Advantage:** Zero runtime overhead. No boxing, no vtables, no dictionary passing. Same performance as if you wrote specialized functions by hand.

**Disadvantage:** Binary size grows if a generic function is used with many types. For v1.0 this is acceptable. Optimization (selective dictionary-passing for cold paths) can be added later.

---

## 0.2.8 — Tensor Shape Type Rules

Tensor shapes are tracked as part of the type. The compiler uses arithmetic on dimensions to verify operations.

### Shape Rules for Common Operations

| Operation | Input Shapes | Output Shape | Check |
|---|---|---|---|
| `matmul(A, B)` | A: [m, n], B: [n, p] | [m, p] | inner dimensions must match (n == n) |
| `transpose(A)` | [m, n] | [n, m] | always valid |
| `reshape(A, shape)` | A: [d1, d2, ...] | shape | product of dims must match |
| `a + b` (element-wise) | A: [d...], B: [d...] | [d...] | shapes must match or broadcast |
| `concat(A, B, axis)` | A: [..., da, ...], B: [..., db, ...] | [..., da+db, ...] | all dims except axis must match |

### Broadcasting Rules (Follow NumPy)

When shapes don't exactly match, broadcasting expands dimensions:
1. Align shapes right-to-left
2. Each dimension must either match or be 1
3. Dimension of 1 is broadcast to match the other

```nova
a = tensor([3, 4])       // [3, 4]
b = tensor([4])           // [4] → broadcasts to [3, 4]
c = a + b                 // valid: [3, 4] — b broadcast along first axis
```

### Static vs Dynamic Shapes

**Static shape (known at compile time):**
```nova
img = tensor([3, 224, 224])    // shape [3, 224, 224] is known
```

**Dynamic shape (loaded at runtime):**
```nova
data = load_tensor("input.bin")   // shape unknown — Tensor<float, ?>
```

For dynamic shapes, the compiler inserts runtime checks:
```nova
result = matmul(known_weights, data)
// Compiler knows known_weights is [512, 1024]
// data shape is unknown — compiler inserts:
//   runtime_check(data.shape[0] == 1024, "matmul dimension mismatch")
```

The developer never writes these checks. The compiler generates them when it can't verify statically.

---

## 0.2.9 — The Inference Algorithm

### Overview

NOVA uses **Constraint-Based Type Inference** built on the Hindley-Milner algorithm (Algorithm W), extended with:
- Channel type constraints
- Capability constraints
- Tensor shape constraints

### The Algorithm in 4 Steps

**Step 1: Assign type variables**
Walk the AST. Every expression that doesn't have an explicit type gets a fresh type variable.

```nova
x = 42                    // x: T1
name = "Alice"            // name: T2
items = [1, 2, 3]         // items: T3
ch = channel()            // ch: T4
```

**Step 2: Generate constraints**
For each expression, generate equations based on the operation:

| Expression | Constraint Generated |
|---|---|
| `x = 42` | T1 = int (literal 42 is int) |
| `name = "Alice"` | T2 = string (literal "Alice" is string) |
| `items = [1, 2, 3]` | T3 = List<int> (list of int literals) |
| `ch = channel()` | T4 = channel<T5> (new unknown T5) |
| `send(ch, x)` | T5 = T1 (channel carries type of sent value) |
| `msg = receive(ch)` | T6 = T5 (received value has channel's type) |
| `a + b` | typeof(a) = typeof(b), and result = typeof(a) (or int→float promotion) |
| `fn f(x) x + 1` | f: T7 → T8, where T7 = int (because + 1), T8 = int (result of +) |
| `list.map(fn)` | fn: element_type(list) → T9, result = List<T9> |
| `if c a else b` | c = bool, typeof(a) = typeof(b), result = typeof(a) |

**Step 3: Solve constraints (Unification)**

Process constraints one by one. For each constraint `A = B`:
- If A is a type variable, substitute A → B everywhere
- If B is a type variable, substitute B → A everywhere
- If both are concrete and the same, constraint satisfied
- If both are concrete and different → TYPE ERROR

Example:
```
Constraints: T1 = int, T5 = T1, T6 = T5
Solve T1 = int → substitute T1 with int everywhere → T5 = int
Solve T5 = int → substitute T5 with int everywhere → T6 = int
Solve T6 = int → done

Result: x: int, ch: channel<int>, msg: int ✓
```

**Step 4: Apply substitution**

Replace all type variables in the AST with their solved concrete types. Every expression now has a known type. The typed AST is ready for ownership analysis.

### Error Reporting

When unification fails, the compiler reports:
1. WHAT types conflict
2. WHERE each type was determined (source locations)
3. HOW to fix it

```
Type error on line 8:
  Channel `ch` carries `int` (determined by send on line 5)
  but `receive(ch)` result is used as `string` (method .length on line 8)
  
  These types are incompatible.
  
  Did you mean to convert? Use `string(receive(ch))` to convert int to string.
```

---

## 0.2.10-12 — Hand-Tracing Inference on All 10 Programs

### Program 1: Hello World

```nova
print("Hello, World!")
```

Inference trace:
```
"Hello, World!" → string (string literal)
print(string) → print is a built-in: fn(Printable) -> Nothing
string is Printable ✓
```
**Annotations needed: 0. Total tokens: ~3. Annotation rate: 0%** ✓

---

### Program 2: Variables, Math, Strings

```nova
name = "Alice"                              // T1 = string (literal)
age = 30                                    // T2 = int (literal)
height = 1.75                               // T3 = float (literal)
is_student = false                          // T4 = bool (literal)

radius = 5.0                                // T5 = float (literal)
area = 3.14159 * radius ** 2                // 3.14159: float, radius: float, 2: int→float
                                            // float ** float → float, float * float → float
                                            // T6 = float ✓

greeting = "Hello, {name}! You are {age}."  // string interpolation
                                            // name: string → embeds directly
                                            // age: int → auto-convert to string for interpolation
                                            // T7 = string ✓

items = [1, 2, 3, 4, 5]                    // T8 = List<int>
total = items.sum()                          // List<int>.sum() → int. T9 = int ✓
doubled = items.map(x => x * 2)             // x: element type of List<int> → int
                                            // x * 2: int * int → int
                                            // map result: List<int>. T10 = List<int> ✓
```

**Annotations needed: 0 out of ~30 type-bearing tokens. Rate: 0%** ✓

Every type is inferred from literals and operations. No ambiguity anywhere.

---

### Program 3: Functions and Control Flow

```nova
fn greet(name)                   // name: T1 (unknown until called)
    print("Hello, {name}!")      // interpolation needs name: Printable. T1 must be Printable.

fn max(a, b)                     // a: T2, b: T3
    if a > b a else b            // > requires T2 = T3 and Comparable. result = T2.

fn fizzbuzz(n)                   // n: T4
    for i in 1..n+1              // 1..n+1: range. n+1 requires n: int. T4 = int.
                                 // i: int (iterating over int range)
        match (i % 3, i % 5)    // (int % int, int % int) → (int, int)
            (0, 0) => print("FizzBuzz")    // pattern: (int, int), matched against (0,0)
            (0, _) => print("Fizz")
            (_, 0) => print("Buzz")
            _      => print(i)             // i: int, Printable ✓

fn factorial(n)                  // n: T5
    if n <= 1                    // n <= 1: int comparison. T5 = int.
        return 1                 // return type = int
    n * factorial(n - 1)         // int * int → int. Consistent. ✓

greet("World")                   // T1 = string (from argument). string is Printable ✓.
print(max(10, 20))               // T2 = int, T3 = int (from arguments). > on int ✓. result: int.
fizzbuzz(30)                     // T4 = int ✓
print(factorial(10))             // T5 = int ✓
```

**Annotations needed: 0. All types inferred from literals and operations.** ✓

**Key insight:** `greet(name)` — the parameter `name` has no type annotation. Its type is inferred from the call site: `greet("World")` → name is string. If `greet` were called with `greet(42)`, name would be int, and `print("Hello, {name}!")` would still work because int is Printable. The function is NATURALLY generic without generic syntax.

---

### Program 4: Error Handling

```nova
config = read_file("config.txt") else "{}"
```

Inference:
```
read_file("config.txt") → string or Error (read_file's return type)
else "{}" → "{}" is string
Rule: (A or B) else A → result type is A
config: string ✓
```

```nova
port = parse_int(env("PORT")) else 8080
```

```
env("PORT") → string or Error
parse_int(string) → int or Error  
parse_int(env("PORT")) — wait, env returns string or Error. 
  If env fails, parse_int never runs.
  Need: env("PORT") else "8080" first? Or does else chain?
```

**IMPORTANT DESIGN DECISION:** How does `else` chain through nested calls?

Option A: `parse_int(env("PORT")) else 8080` — if EITHER env OR parse_int fails, use 8080.
Option B: Must handle each separately: `parse_int(env("PORT") else "8080") else 8080`

**Decision: Option A.** `else` catches ANY error in the expression to its left, regardless of depth. This is simpler (one else handles all failures) and matches the user intent ("give me the port, or 8080 if anything goes wrong").

**How this works in the type system:**
```
env("PORT") → string or Error
parse_int(string or Error) → ??? 

Wait — parse_int expects string, not string or Error. 
If env returns Error, parse_int can't run.
```

**Actual mechanism:** `else` is a short-circuit operator. If the left side is an error, the right side is returned immediately WITHOUT evaluating the rest. The expression evaluates LEFT TO RIGHT, and the first error triggers the else.

```
parse_int(env("PORT")) else 8080

Evaluation:
1. env("PORT") → either string or Error
2. If Error → skip parse_int, return 8080
3. If string → parse_int(string) → either int or Error  
4. If Error → return 8080
5. If int → return int

Result type: int ✓
```

The compiler sees `else 8080` (int), knows the whole expression must produce int. parse_int returns `int or Error`. `else` unwraps it to `int`. Consistent. ✓

```nova
fn load_user(id)
    json = fetch("https://api.example.com/users/{id}") else return Error("API unreachable")
    user = parse_json(json) else return Error("Invalid JSON")
    user
```

```
fetch returns string or Error
else return Error(...) → if fetch fails, function returns early with Error
json: string (unwrapped by else) ✓

parse_json(json) → User or Error (json is string, parse_json returns parsed type or Error)
else return Error(...) → if parse fails, function returns early
user: User ✓

Return type of load_user: User or Error 
(because the function can return User from last line, or Error from else-return)
```

**Annotations needed: 0.** ✓

---

### Program 5: HTTP Server

```nova
import http

http.serve(8080, routes =>
    routes.get("/", req => "Hello, World!")
    routes.get("/users/{id}", req => find_user(req.param("id")))
    routes.post("/users", req => create_user(req.body))
)
```

Inference:
```
http.serve: fn(int, fn(Routes) -> Nothing) -> Nothing
8080: int ✓
routes: Routes (inferred from http.serve's parameter type)

routes.get: fn(string, fn(Request) -> Response) -> Nothing
"/": string ✓
req: Request (inferred from routes.get's handler parameter type)
"Hello, World!": string — is string compatible with Response? 
  Response is a sum type / trait that string satisfies (the stdlib defines this).

req.param("id"): string (Request has .param method returning string)
find_user(string): returns User or Error — compatible with Response ✓

req.body: RequestBody
create_user(RequestBody): returns User or Error — compatible with Response ✓
```

**Annotations needed: 0.** Types flow from stdlib definitions through lambda parameters. The developer writes NO types.

**Key insight:** The types of `routes` and `req` are inferred from `http.serve` and `routes.get` — the stdlib function signatures tell the compiler what types the lambda parameters must be. This is how TypeScript and Kotlin work too — callback parameter types are inferred from the function being called.

---

### Program 6: Concurrent Processes

```nova
fn word_count(files)                        // files: T1
    results = channel()                      // results: channel<T2>
    
    for file in files                        // file: element_type(T1)
        spawn
            content = read_file(file)        // read_file(string) → string or Error
                                             // file must be string → element_type(T1) = string → T1 = List<string>
            words = content.split(" ").length // string.split → List<string>, .length → int
            send(results, (file, words))     // T2 = (string, int) — tuple

    total = 0                                // int
    for _ in 0..files.length                 // int range
        (name, count) = receive(results)     // receive: T2 = (string, int)
                                             // destructure: name: string, count: int ✓
        print("{name}: {count} words")       // interpolation: string, int → both Printable ✓
        total += count                       // int += int ✓

    print("Total: {total} words")
```

**Annotations needed: 0.** The type of `files` is inferred from `read_file(file)` requiring file to be string → files is List<string>. Channel type inferred from `send(results, (file, words))`. Everything chains.

---

### Program 7: AI Inference

```nova
import ai

model = ai.load("resnet50.onnx")            // model: AiModel (from stdlib)
image = read_file("photo.jpg")               // image: string or Error (file contents)
predictions = model.predict(image)           // predictions: Predictions (from AiModel.predict)

for p in predictions.top(5)                  // p: Prediction
    print("{p.label}: {p.confidence}%")      // Prediction.label: string, .confidence: float ✓
```

**Annotations needed: 0.** All types come from stdlib.

---

### Program 8: Full-Stack App

This program has the most moving parts. Let me trace carefully.

```nova
import http
import web
import ai

model = ai.load("classifier.onnx")          // model: AiModel

spawn http.serve(8080, routes =>             // routes: Routes
    routes.get("/api/analyze", req =>        // req: Request
        image = req.file("image")            // image: FileUpload
        result = model.predict(image)        // result: Predictions
        http.json({ label: result.top(1).label, confidence: result.top(1).confidence })
                                             // http.json takes any Sendable value
                                             // anon struct { label: string, confidence: float }
                                             // Sendable ✓
    )
)

@device(wasm)
spawn web.app(ui =>                          // ui: UiBuilder
    ui.page("/", page =>                     // page: PageBuilder
        title = page.text("Image Classifier")   // title: TextElement
        upload = page.file_input("Upload image") // upload: FileInputElement
        result = page.text("")                   // result: TextElement

        upload.on_change(file =>             // file: File
            response = http.fetch("/api/analyze", file = file)
                                             // response: HttpResponse
            result.set("Result: {response.label} ({response.confidence}%)")
                                             // .set takes string ✓
        )
    )
)
```

**Annotations needed: 0.** Every type flows from stdlib signatures (http.serve, web.app, ai.load). Lambda parameters are inferred from the calling function's signature.

**This is the power of the type system:** The developer writes zero types in a full-stack app with a server, AI model, and browser UI. The compiler knows every type because the stdlib functions have defined signatures, and those signatures propagate through lambda parameters.

---

### Program 9: Systems-Level Memory

```nova
type RingBuffer                              // ANNOTATION: field types required in type def
    _handle: int                             // int ✓

fn ring_buffer(capacity) -> RingBuffer       // ANNOTATION: return type
    @low_level                               // capacity: inferred as int from alloc(capacity)
        buffer = alloc(capacity)             // buffer: Pointer (low-level type)
        handle = register_buffer(buffer, capacity)  // handle: int
    RingBuffer { _handle: handle }           // constructs RingBuffer ✓

fn push(rb: RingBuffer, val: byte) -> bool or Error   // ANNOTATIONS: parameter types + return
    @low_level
        buffer_push(rb._handle, val) else Error("buffer full")

fn pop(rb: RingBuffer) -> byte or Error      // ANNOTATIONS: parameter type + return
    @low_level
        buffer_pop(rb._handle) else Error("buffer empty")

fn free_buffer(rb: RingBuffer)               // ANNOTATION: parameter type
    @low_level
        buffer_free(rb._handle)

// Usage — zero annotations
rb = ring_buffer(1024)                       // rb: RingBuffer ✓
push(rb, byte(0x42))                         // ✓
value = pop(rb) else byte(0)                 // value: byte ✓
free_buffer(rb)                              // ✓
print("Got: {value}")                        // byte is Printable ✓
```

**Annotations in this program:**
- `_handle: int` — type definition field (required by rule)
- `-> RingBuffer` — return type annotation
- `rb: RingBuffer` — parameter types (3 times)
- `val: byte` — parameter type
- `-> bool or Error`, `-> byte or Error` — return types

**Count:** ~8 annotations out of ~60 type-bearing tokens. That's ~13%.

**BUT:** This is a systems-level program with `@low_level`. It's the 5% expert code. For the PUBLIC API of this module (the functions `push`, `pop`, `ring_buffer`, `free_buffer`), type annotations on parameters and return types are GOOD — they serve as documentation.

**The USAGE code (last 5 lines) has ZERO annotations.** The consumer of this library writes no types.

---

### Program 10: Distributed Service

```nova
import http
import log

fn main()
    workers = for _ in 0..cpu_count()        // cpu_count() → int, range, workers: List<Process>
        spawn http_worker()                   // spawn returns Process handle

    for w in workers                          // w: Process
        supervise(w, restart = "always", max_restarts = 5, within = 60)
                                             // supervise: fn(Process, ...) → Nothing

    log.info("Service started on :8080 with {cpu_count()} workers")

fn http_worker()
    http.serve(8080, routes =>               // routes: Routes
        routes.get("/health", req => { status: "ok" })
                                             // anon struct { status: string }
        routes.get("/data/{id}", req =>      // req: Request
            data = fetch_from_db(req.param("id")) else return http.json({ error: "not found" })
            http.json(data)
        )
    )

fn fetch_from_db(id)                         // id: T1
    result_ch = channel()                    // channel<T2>
    spawn
        result = db_query("SELECT * FROM items WHERE id = {id}")
                                             // id used in string interpolation → id: Printable
                                             // db_query returns DbRow or Error
        send(result_ch, result)              // T2 = DbRow or Error
    receive(result_ch) else Error("db timeout")
                                             // receive: T2 = DbRow or Error
                                             // else Error → returns DbRow or Error
```

**Annotations needed: 0.** All types inferred from stdlib + usage.

---

## 0.2.13 — Annotation Count Across All Programs

| Program | Total Type-Bearing Tokens (approx) | Annotations Written | Rate |
|---|---|---|---|
| 1. Hello World | 3 | 0 | 0% |
| 2. Variables, Math, Strings | 30 | 0 | 0% |
| 3. Functions, Control Flow | 40 | 0 | 0% |
| 4. Error Handling | 25 | 0 | 0% |
| 5. HTTP Server | 15 | 0 | 0% |
| 6. Concurrent Processes | 30 | 0 | 0% |
| 7. AI Inference | 10 | 0 | 0% |
| 8. Full-Stack App | 35 | 0 | 0% |
| 9. Systems Memory | 60 | 8 | 13% |
| 10. Distributed Service | 30 | 0 | 0% |
| **TOTAL** | **~278** | **8** | **2.9%** |

**The 8 annotations are ALL in Program 9 (systems-level code with @low_level).** They are:
- Type definition fields (required by design — definitions ARE documentation)
- Public function signatures (parameter + return types for @low_level functions)

**Every other program — from hello world to full-stack app to distributed service — requires ZERO type annotations.**

**Gate 2 result: 2.9% annotation rate. Target was <5%. PASSED.** ✓

Even if we count ONLY Program 9: 13% for systems code is still less than Go (~20-30%), far less than Rust (~40-60%), and far less than Java (~80-90%).

---

## 0.2.14 — Five WRONG Programs and Error Messages

### Wrong Program 1: Type Mismatch

```nova
x = 42
y = "hello"
z = x + y              // ERROR
```

**Compiler error:**
```
Error on line 3: Type mismatch in `+` operation
  Left side: int (from variable `x`, assigned on line 1)
  Right side: string (from variable `y`, assigned on line 2)
  
  `+` can add int+int, float+float, or string+string, but not int+string.
  
  To convert: use `string(x) + y` for concatenation, or `x + int(y)` for arithmetic.
```

### Wrong Program 2: Channel Type Conflict

```nova
ch = channel()
send(ch, 42)
send(ch, "hello")      // ERROR
```

**Compiler error:**
```
Error on line 3: Channel type conflict
  Channel `ch` carries `int` (determined by send on line 2)
  but you're sending `string` on line 3.
  
  A channel can only carry one type of value.
  
  If you need to send different types, use a sum type:
    ch = channel::<int or string>()
```

### Wrong Program 3: Use After Send

```nova
data = [1, 2, 3]
ch = channel()
send(ch, data)
print(data)             // ERROR
```

**Compiler error:**
```
Error on line 4: Value used after send
  `data` was sent through channel `ch` on line 3.
  After sending, `data` is no longer owned by this process.
  
  You can't use `data` on line 4 because it was transferred.
  
  To keep a copy: use `send(ch, copy(data))` on line 3.
```

### Wrong Program 4: Non-Exhaustive Match

```nova
type Shape
    enum Circle(r: float), Rectangle(w: float, h: float)

fn area(s: Shape) -> float
    match s
        Circle(r) => 3.14159 * r ** 2
        // missing Rectangle!
```

**Compiler error:**
```
Error on line 5: Non-exhaustive match
  Match on `Shape` does not cover all variants.
  
  Missing: Rectangle(w, h)
  
  Add the missing case, or use `_ => ...` as a wildcard:
    match s
        Circle(r) => 3.14159 * r ** 2
        Rectangle(w, h) => w * h        // ← add this
```

### Wrong Program 5: Incompatible Channel Connection

```nova
fn producer(ch)
    send(ch, 42)

fn consumer(ch)
    msg = receive(ch)
    msg.upper()                // .upper() is a string method

ch = channel()
spawn producer(ch)
spawn consumer(ch)
```

**Compiler error:**
```
Error: Channel type conflict between producer and consumer
  `producer` sends `int` through channel (line 2)
  `consumer` uses received value as `string` (method .upper() on line 6)
  
  Channel `ch` can't carry both `int` and `string`.
  
  Either change producer to send a string, or change consumer to handle an int.
```

---

## 0.2.15 — Gate 2 Assessment

| Criterion | Result |
|---|---|
| Inference works for 95%+ of code without annotations | ✅ 97.1% (8 annotations out of ~278 tokens) |
| The 8 annotations are in type definitions and @low_level public APIs | ✅ Appropriate locations |
| Channel types infer correctly from usage | ✅ Traced in Programs 6, 10 |
| Process types infer correctly from channels | ✅ Traced in Programs 6, 8, 10 |
| Capabilities derive correctly from structure | ✅ Defined rules, traced examples |
| Error messages explain WHAT, WHERE, HOW TO FIX | ✅ 5 wrong programs demonstrate |
| Tensor shape checking catches dimension mismatches | ✅ Rules defined with broadcasting |

**GATE 2: PASSED.** The type system supports 97%+ inference rate with zero annotations for application code and minimal annotations for systems/library code.
