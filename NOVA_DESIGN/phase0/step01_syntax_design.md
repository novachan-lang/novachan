# Phase 0, Step 0.1: NOVA Syntax Design

> **SUPERSEDED — DO NOT USE FOR IMPLEMENTATION**
> This document contains early syntax proposals that were revised during development.
> The authoritative syntax is in **[programs_final.md](programs_final.md)**.
> The `=>` arrow (not `->`) and all other final decisions are in programs_final.md.
> This file is kept for historical reference only.

**Status: SUPERSEDED**
**Goal: Define NOVA's complete syntax. Write 10 programs. Validate each is simpler than Python.**

---

## 0.1.1 — Final Keyword Set

### Design Criteria
1. Every keyword must be NECESSARY — if you can express it without a keyword, don't add one
2. No two keywords should overlap in function
3. Keywords should be English words that non-programmers can roughly understand
4. Total count must stay BELOW Python (35) and Go (25) — target: under 20

### The Keywords

**Data & Assignment (2):**

| Keyword | Purpose | Why Necessary | Alternative Considered |
|---|---|---|---|
| `type` | Define a named type (struct, enum) | Can't define user types without it. `struct` is too systems-y. `class` implies OOP. `type` is neutral and familiar (Go, TypeScript, Rust). | `struct` — rejected: not all types are structs (enums, aliases). `data` — rejected: less familiar. |
| `enum` | Define sum type variants | Needed inside `type` to distinguish struct vs enum. `or` works in type expressions (`int or string`) but you need `enum` for defining new variants with data. | Put everything under `type` — rejected: ambiguous whether it's struct or enum without a marker. |

**Functions (2):**

| Keyword | Purpose | Why Necessary | Alternative Considered |
|---|---|---|---|
| `fn` | Define a function | Every language needs function definition syntax. `fn` is shortest (Rust, Zig). `function` is verbose. `def` is Python but we already diverge from Python. `fn` is 2 chars — minimal ceremony. | `def` — rejected: NOVA isn't Python, shouldn't pretend to be. `func` — rejected: 4 chars vs 2, Go uses this but it's verbose. |
| `return` | Early return from function | Needed for early exit. Last expression is implicit return, but sometimes you need to exit early from a branch. Could be optional for simple functions. | No keyword (only implicit return) — rejected: forces awkward restructuring when you need early exit. |

**Control Flow (4):**

| Keyword | Purpose | Why Necessary | Alternative Considered |
|---|---|---|---|
| `if` / `else` | Conditional branching | Universal. Every language has this. Developers expect it. No alternative is simpler. | `when` — rejected: less familiar. `match` covers some cases but `if` is simpler for boolean conditions. |
| `for` | Iteration | `for x in collection` is the most readable loop syntax (Python, Kotlin, Swift, Rust). NOVA does NOT have `while` — `for` with conditions covers all cases: `for condition ...` replaces `while`. | `while` + `for` — rejected: two keywords for iteration is unnecessary. `for` handles both: `for item in list` and `for x > 0`. `loop` — rejected: needs `break` to be useful, adds keywords. |
| `match` | Pattern matching on values | Essential for sum types, error handling, destructuring. More powerful than if/else chains. Every modern language (Rust, Kotlin, Swift) has this. | `switch` — rejected: carries C/Java baggage (fallthrough, breaks). `when` — rejected: Kotlin uses this but `match` is clearer about what it does (matching patterns, not conditions). |
| `break` | Exit a loop early | Necessary for `for` loops when you find what you need. Without it, developers write awkward boolean flags. | No break (functional style only) — rejected: too academic. Real code needs early exit from loops. |

**Processes & Channels (4):**

| Keyword | Purpose | Why Necessary | Alternative Considered |
|---|---|---|---|
| `spawn` | Create a new process | THE core process creation keyword. `spawn worker()` reads like English: "spawn a worker." Familiar from Erlang, Elixir. | `go` — rejected: Go's keyword but confusing outside Go context. `async` — rejected: implies async/await which NOVA doesn't have. `process` — rejected: 7 chars, verbose for something used often. |
| `send` | Send a value through a channel | THE core channel send operation. `send(ch, data)` is a function call syntax — clear, explicit, no symbolic operators needed. | `ch <- data` (Go style) — rejected: symbolic operator is less readable for beginners. `ch.send(data)` — rejected: implies channels are objects with methods, which isn't the model. |
| `receive` | Receive a value from a channel | THE core channel receive operation. `msg = receive(ch)` — clear, explicit. | `<-ch` (Go style) — rejected: same as above, symbolic. `ch.receive()` — rejected: same as above. |
| `channel` | Create a channel | `ch = channel()` creates a new channel. Type inferred from usage. | `chan` — rejected: abbreviation is less readable. `pipe` — rejected: Unix connotation, narrower meaning. |

**Error Handling & Safety (2):**

| Keyword | Purpose | Why Necessary | Alternative Considered |
|---|---|---|---|
| `or` | Default value on failure / sum type | THE one-word error handling. `value = try_thing() or default`. Also used in type expressions: `int or Error`. Also boolean: `a or b`. Triple duty, one keyword. | `??` (Swift) — rejected: symbolic, less readable. `else` — rejected: already used with `if`, overloading creates ambiguity. `orelse` — rejected: unusual, verbose. |
| `copy` | Explicit copy of a value | When you need to send data through a channel but keep the original: `send(ch, copy(data))`. Also useful for explicit copies: `backup = copy(data)`. Without this, no way to say "I want a copy, not a move." | Make copy automatic always — rejected: expensive for large values, hides cost. No keyword (always move on send) — rejected: too restrictive, sometimes you genuinely need to keep the original. |

**Module System (1):**

| Keyword | Purpose | Why Necessary | Alternative Considered |
|---|---|---|---|
| `import` | Import a module | Every language needs imports. `import http` is the simplest form (Python-like). | `use` (Rust) — rejected: less familiar to Python/Java/JS developers. `require` (Node) — rejected: function-like, less clean. `from X import Y` — supported as variant: `import http.server` or `import { get, post } from http`. |

**Supervision (1):**

| Keyword | Purpose | Why Necessary | Alternative Considered |
|---|---|---|---|
| `supervise` | Declare supervision for a process | `supervise worker restart: always`. This is a statement that sets up the parent-child supervision relationship. Critical for fault tolerance. | Make supervision automatic — rejected: not all processes need supervision. Some are fire-and-forget. Annotations (`@supervise`) — considered but supervision is too important to hide in an annotation. It's a core language concept (Process model), not an optimization hint. |

**Boolean Values & Operators (3):**

| Keyword | Purpose | Why Necessary | Alternative Considered |
|---|---|---|---|
| `true` / `false` | Boolean literals | Universal. Every language has these. | `yes`/`no` — rejected: unusual, confusing. |
| `and` | Boolean AND | `if a and b` reads like English. Better than `&&` for readability. | `&&` — rejected: symbolic, less readable. We use `and` because NOVA should read like English. |
| `not` | Boolean NOT | `if not done` reads like English. Better than `!` for readability. | `!` — rejected: same reasoning as `and`. English words > symbols for readability. |

Note: `or` already covers boolean OR (listed above under error handling — it does triple duty).

### Final Count: 19 Keywords

```
fn    return    if    else    for    match    break
type  enum      spawn send   receive channel
or    and       not   copy   import  supervise
true  false
```

That's 21 tokens (counting true/false). Compare:
- **Go: 25 keywords**
- **Python: 35 keywords**  
- **Rust: 39 keywords**
- **Java: 50 keywords**
- **C++: 90+ keywords**

NOVA is below ALL of them.

### What's Deliberately MISSING (and why):

| NOT a keyword | Why Not |
|---|---|
| `class` | NOVA has no classes. Values + processes + channels replace OOP. |
| `interface` / `trait` | Capabilities are auto-derived by the compiler. No declaration needed. |
| `async` / `await` | Processes ARE concurrency. No separate async model. |
| `let` / `var` / `const` / `mut` | Assignment is `x = value`. Values are mutable within their process. No ceremony. |
| `new` | Values are created by assignment. `point = Point { x: 1, y: 2 }`. No `new`. |
| `null` / `nil` / `None` | No null. Absence is a sum type: `value or Nothing`. |
| `try` / `catch` / `throw` / `except` | No exceptions. `or` + `match` + supervision handles all error cases. |
| `public` / `private` / `protected` | Module-level visibility only. Top-level declarations are public. No access modifiers. |
| `while` / `do` / `loop` | `for` handles all iteration: `for item in list` and `for condition`. |
| `this` / `self` | No classes. No `this`. Functions operate on explicit parameters. |
| `static` | No classes, no static. Module-level functions are the equivalent. |
| `volatile` / `synchronized` | Process isolation eliminates the need. No shared mutable state. |
| `switch` | `match` replaces switch with better semantics (exhaustive, no fallthrough). |
| `yield` | Channels handle producer/consumer patterns. No generators needed as separate concept. |
| `defer` | Process cleanup happens on process exit. `supervise` handles cleanup for failures. |

### Verification Against the System

**Type system:** `type` and `enum` provide user-defined types. All other types are inferred — no keyword needed. ✓
**Process model:** `spawn`, `send`, `receive`, `channel`, `supervise` — complete process/channel lifecycle. ✓
**Error handling:** `or` for defaults, `match` for detailed handling, `supervise` for crash recovery. Three levels, all covered. ✓
**Memory model:** `copy` for explicit copies. Everything else is automatic (assignment = copy with COW). ✓
**Control flow:** `if`/`else`, `for`, `match`, `break` — covers conditional, iteration, pattern matching, early exit. ✓
**Modules:** `import` — simple, familiar. ✓
**Missing what we need?** Let me check against the 10 programs we'll write...

- Hello world: `print("hello")` — `print` is stdlib function, not keyword. ✓
- HTTP server: `serve`, `get`, `post` are stdlib functions. ✓
- AI inference: `predict`, `load_model` are stdlib functions. ✓
- Low-level systems: `@low_level` is an annotation, not keyword. ✓

**No gaps found.** 19 keywords + 2 boolean literals covers everything.

---

## 0.1.2 — Operator Set and Precedence

### Operators

**Arithmetic (5):**
`+` (add), `-` (subtract/negate), `*` (multiply), `/` (divide), `%` (modulo)

**Comparison (6):**
`==` (equal), `!=` (not equal), `<` (less), `>` (greater), `<=` (less or equal), `>=` (greater or equal)

**Assignment (1):**
`=` (assign — always copy semantics, compiler optimizes)

**Compound Assignment (5):**
`+=`, `-=`, `*=`, `/=`, `%=`

**Boolean (3 — keywords, not symbols):**
`and`, `or`, `not`

**String (1):**
`+` (concatenation — same as add, works on strings)

**Access (2):**
`.` (field/method access: `point.x`, `list.length`), `[]` (index: `list[0]`, `map["key"]`)

**Pipeline (1):**
`|>` (pipe result of left into first argument of right: `data |> transform |> send(ch, _)`)

**Range (1):**
`..` (range: `0..10`, used in `for i in 0..10`)

**Type (1):**
`:` (type annotation when needed: `fn add(a: int, b: int) -> int`)

**Return Type (1):**
`->` (function return type: `fn add(a, b) -> int`)

**What's Deliberately MISSING:**

| NOT an operator | Why Not |
|---|---|
| `&&` / `||` / `!` | Use `and` / `or` / `not` — English words are more readable |
| `++` / `--` | Use `x += 1`. Increment/decrement operators cause confusion (pre vs post). Go removed them too. |
| `?` / `??` | Use `or` keyword — more readable: `value = try() or default` |
| `&` / `*` (pointer ops) | No pointers in safe NOVA. Available only inside `@low_level` blocks. |
| `<<` / `>>` (bitwise) | Available as functions: `bit_shift_left(x, 3)`. Too rare to deserve operators. |
| `&` / `|` / `^` (bitwise) | Available as functions: `bit_and(x, y)`. Too rare and confusing with boolean ops. |
| `<-` (channel send) | Use `send(ch, data)` — function syntax is clearer than symbolic operators |
| `::` | No namespacing operator. Use `.` for everything (module access, field access). |
| `=>` | Not needed. `match` uses indentation for branches. `->` is only for return types. |
| `?:` (ternary) | Use `if`/`else` expression: `result = if x > 0 x else -x` |

### Precedence Table (highest to lowest)

| Level | Operators | Associativity |
|---|---|---|
| 1 (highest) | `.` `[]` (access) | Left |
| 2 | `-` (unary negate), `not` | Right |
| 3 | `*` `/` `%` | Left |
| 4 | `+` `-` | Left |
| 5 | `..` (range) | None |
| 6 | `==` `!=` `<` `>` `<=` `>=` | None (no chaining: `a < b < c` is error, use `a < b and b < c`) |
| 7 | `and` | Left |
| 8 | `or` | Left |
| 9 | `|>` (pipeline) | Left |
| 10 (lowest) | `=` `+=` `-=` `*=` `/=` `%=` | Right |

**Design decision: No comparison chaining.** Python allows `a < b < c`. This is convenient but surprising to developers from C/Java/Rust. NOVA requires explicit `and`: `a < b and b < c`. One way to do things. Clear.

**Design decision: `or` is below `and`.** This matches mathematical convention and every language. `a and b or c` means `(a and b) or c`.

**Design decision: `|>` is very low precedence.** Pipeline chains should be written clearly:
```nova
data |> transform |> filter |> collect
```
Low precedence means you don't need parentheses around complex expressions being piped.

### Verification Against the System

- **Arithmetic for tensor operations:** `+`, `-`, `*` work on tensors (operator overloading for numeric types only). `@` for matrix multiplication? Let me think... NO. Use a function: `matmul(a, b)` or `a.matmul(b)`. Adding `@` is a special-case operator for one domain. Violates "no domain-specific features." ✓
- **No pointer operators in safe code:** Correct. `&` and `*` only exist inside `@low_level`. ✓
- **Readability:** All boolean logic is English words. All arithmetic is standard symbols. Pipeline is the only "new" operator and it's widely known (F#, Elixir, Elm). ✓

---

## 0.1.3 — Block Structure Rules

### Indentation-Based Blocks

NOVA uses indentation to define blocks, like Python. Rationale: reduces visual noise, enforces readable formatting, matches "simpler than Python" goal.

**Rules:**

1. **One indentation level = 4 spaces.** Not tabs. Not 2 spaces. 4 spaces. One canonical style (like Go's `gofmt`). No debate.

2. **A colon or keyword starts a new block:**
```nova
fn greet(name)
    print("Hello {name}")

if x > 0
    print("positive")
else
    print("non-positive")

for item in list
    process(item)

match result
    value -> use(value)
    Error(e) -> log(e)
```

3. **Single-line form exists for simple cases:**
```nova
fn double(x) x * 2
if x > 0 print("yes")
for item in list print(item)
```
When the body is a single expression, it can go on the same line. This is important for keeping simple code simple.

4. **Multi-line expressions use continuation:**
```nova
result = very_long_function_name(
    argument1,
    argument2,
    argument3
)

long_list = [
    item1, item2, item3,
    item4, item5, item6
]
```
Open brackets `(`, `[`, `{` allow continuation to the next line without any special syntax. The expression continues until the matching close bracket.

5. **No semicolons.** One statement per line. Period.

6. **Empty blocks use `pass`? NO.** NOVA doesn't need `pass`. If a function has no body yet, it's a compile error. No placeholder syntax needed — NOVA isn't an interpreted scripting language where you prototype with empty blocks.

Wait — what about interface-like forward declarations? We don't have interfaces. What about stub functions during development? The developer can write: `fn todo_function() panic("not implemented")`. No special keyword needed.

### Verification Against the System

- **Parser:** Lexer generates INDENT/DEDENT tokens (like Python's tokenizer). Parser uses these as block delimiters. Well-understood technique. ✓
- **Consistency:** All blocks use indentation. No exceptions (no braces anywhere). One way. ✓
- **Against C++ lesson:** C++ has both `{}` blocks and can omit them for single statements (`if (x) y;`). This causes bugs. NOVA has one style: either indented block or single-line. ✓
- **Against Python:** Same model, so Python developers feel at home. ✓

---

## 0.1.4 — Function Syntax Rules

### Function Definitions

**Simple function (one expression body):**
```nova
fn add(a, b) a + b
fn greet(name) print("Hello {name}")
fn square(x) x * x
```
No return type needed — inferred from body.

**Multi-line function:**
```nova
fn fibonacci(n)
    if n <= 1
        return n
    fibonacci(n - 1) + fibonacci(n - 2)
```
Last expression is the return value. `return` for early exit.

**Function with type annotations (optional, for public APIs):**
```nova
fn distance(a: Point, b: Point) -> float
    sqrt((a.x - b.x) ** 2 + (a.y - b.y) ** 2)
```
Parameters can have types. Return type after `->`. All optional — compiler infers if not given.

**Lambdas / Anonymous functions:**
```nova
doubled = list.map(x -> x * 2)
filtered = list.filter(x -> x > 0)
transform = (x, y) -> x + y
```
Arrow syntax for lambdas. Single parameter: `x -> body`. Multiple: `(x, y) -> body`.

**Multi-line lambda:**
```nova
processor = x ->
    validated = validate(x)
    transform(validated)
```

**Functions with default arguments:**
```nova
fn serve(port = 8080, host = "localhost")
    start_server(host, port)
```

**Named arguments at call site:**
```nova
serve(port: 3000, host: "0.0.0.0")
```

### Verification Against the System

- **Type inference:** Function parameter types inferred from call sites. Return type inferred from body. Only public API boundaries may need annotations. ✓
- **Simplicity vs Python:** Python uses `def`, 3 chars. NOVA uses `fn`, 2 chars. Lambda syntax `x -> x * 2` is cleaner than Python's `lambda x: x * 2`. ✓
- **Readability:** `fn add(a, b) a + b` reads naturally. No ceremony. ✓
- **Consistency:** Same indentation rules as all other blocks. ✓

---

## 0.1.5 — Type Declaration Syntax

### Struct Types
```nova
type Point
    x: float
    y: float

type User
    name: string
    age: int
    email: string
```
Fields with types. Types required in declarations (this is the 5% where types are written — type DEFINITIONS, not usage).

**Inline/anonymous struct:**
```nova
point = { x: 1.0, y: 2.0 }
```
Type inferred as `{ x: float, y: float }`. Anonymous — no `type` declaration needed.

### Enum / Sum Types
```nova
type Color
    enum Red, Green, Blue

type Shape
    enum
        Circle(radius: float)
        Rectangle(width: float, height: float)
        Triangle(a: float, b: float, c: float)

type Result
    enum
        Ok(value)
        Error(message: string)
```

**Inline sum type (with `or`):**
```nova
fn read_file(path) -> string or Error
    // ...
```
No type declaration needed for simple alternatives.

### Type Aliases
```nova
type Name = string
type Matrix = List<List<float>>
type Handler = fn(Request) -> Response
```

### Generic Types
```nova
type Pair<A, B>
    first: A
    second: B

type Tree<T>
    enum
        Leaf(value: T)
        Node(left: Tree<T>, right: Tree<T>)
```

### Verification Against the System

- **Simplicity:** Struct is just `type Name` + indented fields. Simpler than Go (`type X struct {}`), Rust (`struct X {}`), Java (`class X { private int x; public int getX()... }`). ✓
- **Sum types:** `enum` keyword inside `type` distinguishes struct from enum. `or` in type expressions for inline alternatives. Two ways to express the same thing, but for different use cases: `enum` for named types with variants, `or` for quick inline alternatives. ✓
- **Generics:** Angle bracket syntax `<T>` is familiar (Java, TypeScript, Rust, Go). Type parameters inferred from usage in most cases. ✓
- **Copy semantics:** All types are value types. `y = x` copies. Compiler optimizes with COW. No reference types. ✓
- **Capability derivation:** Compiler analyzes struct fields to auto-derive Copyable, Sendable, etc. No annotation needed. ✓

---

## 0.1.6 — Annotation Syntax

### Rules
- Annotations start with `@`
- They are NEVER required — they are hints/overrides for the compiler
- They precede the thing they annotate (line before or same line)

### Complete Annotation List

**Execution control:**
```nova
@device(gpu)           // force GPU execution
@device(cpu)           // force CPU execution  
@distributed           // force distributed execution
```

**Memory control:**
```nova
@stack                 // force stack allocation
@heap                  // force heap allocation
@arena(name)           // use arena allocation
@pinned                // pinned memory (for GPU DMA)
```

**Optimization control:**
```nova
@inline                // force function inlining
@no_inline             // prevent function inlining
```

**Safety control:**
```nova
@low_level             // unlock raw memory operations (scoped block)
@unchecked             // disable bounds checking (inside @low_level only)
@extern("lib", "fn")   // FFI declaration
```

**Testing:**
```nova
@test                  // mark function as a test
@benchmark             // mark function as a benchmark
```

### Usage Examples
```nova
@device(gpu)
fn train_model(data, weights)
    // compiler generates GPU kernel

@inline
fn hot_path(x) x * x + x

@test
fn test_addition()
    assert(add(1, 2) == 3)

@low_level
    ptr = alloc(4096)
    @unchecked
        write(ptr, 0, byte(0xFF))
    free(ptr)
```

### Verification Against the System

- **Progressive disclosure:** Beginners never see annotations. Experts use them for control. ✓
- **Process model:** `@device` and `@distributed` influence where processes run. Don't break the model. ✓
- **Safety:** `@low_level` is scoped. `@unchecked` only works inside `@low_level`. Raw pointers can't escape. ✓
- **Simplicity:** Annotations are a small, closed set. Can't define custom annotations (prevents annotation explosion). ✓

---

## 0.1.7 — Import/Module Syntax

### Module Structure
Every `.nova` file is a module. Directory is a package.

```
myapp/
    main.nova          // entry point
    server.nova        // server module
    handlers/
        user.nova      // handlers.user module
        auth.nova      // handlers.auth module
```

### Import Syntax
```nova
import http                          // import entire module
import http.server                   // import submodule
import { get, post } from http       // import specific items
import math as m                     // alias
```

### Visibility
- All top-level declarations (functions, types) are PUBLIC by default
- Prefix with `_` to make PRIVATE: `_helper_function()` is module-private
- Simple convention, no keywords needed

### Verification
- **Simpler than Python:** No `__init__.py`, no relative imports (`.module`), no `__all__`. Just `import`. ✓
- **Simpler than Java:** No `package` declaration. File location IS the package. No `public`/`private`/`protected`. ✓
- **Simpler than Rust:** No `mod`, no `pub`, no `use`, no `crate::`. Just `import`. ✓
- **Compilation:** Module boundaries are type inference boundaries. Each module can be compiled independently with interface files. ✓

---

## NOW: The 10 Programs

Everything above defines the syntax rules. Now I write the 10 programs using these rules, and validate each is simpler than Python.

---

## Program 1: Hello World

### NOVA:
```nova
print("Hello, World!")
```

### Python:
```python
print("Hello, World!")
```

### Go:
```go
package main
import "fmt"
func main() {
    fmt.Println("Hello, World!")
}
```

### Rust:
```rust
fn main() {
    println!("Hello, World!");
}
```

**Comparison:** NOVA = Python (1 line, identical). Beats Go (5 lines of boilerplate). Beats Rust (3 lines + macro syntax).

---

## Program 2: Variables, Math, Strings

### NOVA:
```nova
name = "Alice"
age = 30
height = 1.75
is_student = false

area = 3.14159 * radius * radius
greeting = "Hello, {name}! You are {age} years old."
print(greeting)

items = [1, 2, 3, 4, 5]
total = items.sum()
doubled = items.map(x -> x * 2)
print("Sum: {total}, Doubled: {doubled}")
```

### Python:
```python
name = "Alice"
age = 30
height = 1.75
is_student = False

area = 3.14159 * radius * radius
greeting = f"Hello, {name}! You are {age} years old."
print(greeting)

items = [1, 2, 3, 4, 5]
total = sum(items)
doubled = list(map(lambda x: x * 2, items))
print(f"Sum: {total}, Doubled: {doubled}")
```

**Comparison:** Nearly identical readability. NOVA wins on:
- String interpolation: `"Hello {name}"` vs `f"Hello {name}"` — no `f` prefix needed
- Lambda: `x -> x * 2` vs `lambda x: x * 2` — shorter
- List operations: `items.map(...)` vs `list(map(lambda..., items))` — cleaner
- Boolean: `false` vs `False` — lowercase (consistent with most languages)
- Zero type annotations in NOVA — same as Python but NOVA catches type errors at compile time

---

## Program 3: Functions and Control Flow

### NOVA:
```nova
fn greet(name)
    print("Hello, {name}!")

fn max(a, b)
    if a > b a else b

fn fizzbuzz(n)
    for i in 1..n+1
        match (i % 3, i % 5)
            (0, 0) -> print("FizzBuzz")
            (0, _) -> print("Fizz")
            (_, 0) -> print("Buzz")
            _      -> print(i)

fn factorial(n)
    if n <= 1
        return 1
    n * factorial(n - 1)

greet("World")
print(max(10, 20))
fizzbuzz(30)
print(factorial(10))
```

### Python:
```python
def greet(name):
    print(f"Hello, {name}!")

def max_val(a, b):
    return a if a > b else b

def fizzbuzz(n):
    for i in range(1, n+1):
        if i % 3 == 0 and i % 5 == 0:
            print("FizzBuzz")
        elif i % 3 == 0:
            print("Fizz")
        elif i % 5 == 0:
            print("Buzz")
        else:
            print(i)

def factorial(n):
    if n <= 1:
        return 1
    return n * factorial(n - 1)

greet("World")
print(max_val(10, 20))
fizzbuzz(30)
print(factorial(10))
```

**Comparison:** NOVA wins on:
- `fn` (2 chars) vs `def` (3 chars) — minor but consistent
- Pattern matching: `match (i%3, i%5)` with `(0, 0) ->` is more readable than chained `if/elif`
- Single-expression functions: `fn max(a, b) if a > b a else b` — no `return` needed
- `1..n+1` vs `range(1, n+1)` — range syntax is cleaner
- No colons after function/if/for declarations — less punctuation noise

---

## Program 4: Error Handling

### NOVA:
```nova
// Simple default — one word
config = read_file("config.txt") or "{}"
port = parse_int(env("PORT")) or 8080

// Pattern matching for detailed handling
match read_file("data.csv")
    content -> process_csv(content)
    FileNotFound -> print("File missing, creating default...")
    PermissionDenied(path) -> print("Can't read {path}, check permissions")

// Chaining operations that might fail
fn load_user(id)
    json = fetch("https://api.example.com/users/{id}") or return Error("API unreachable")
    user = parse_json(json) or return Error("Invalid JSON")
    user

// Using result
match load_user(42)
    user -> print("Found: {user.name}")
    Error(msg) -> print("Failed: {msg}")
```

### Python:
```python
# Simple default
try:
    config = open("config.txt").read()
except FileNotFoundError:
    config = "{}"
port = int(os.environ.get("PORT", 8080))

# Detailed handling
try:
    content = open("data.csv").read()
    process_csv(content)
except FileNotFoundError:
    print("File missing, creating default...")
except PermissionError as e:
    print(f"Can't read {e.filename}, check permissions")

# Chaining
def load_user(id):
    try:
        response = requests.get(f"https://api.example.com/users/{id}")
        return response.json()
    except requests.RequestException:
        return None
    except json.JSONDecodeError:
        return None

# Using result  
user = load_user(42)
if user:
    print(f"Found: {user['name']}")
else:
    print("Failed")
```

**Comparison:** NOVA dramatically wins:
- `or` replaces 4-line try/except blocks with ONE WORD
- Pattern matching on errors vs nested try/except — cleaner, exhaustive
- `or return Error(...)` for early exit — readable, no nesting
- No `None` checking — sum types force handling at compile time
- Python's `try/except` is 4-6 lines for what NOVA does in 1. That's not marginally simpler — it's categorically simpler.

---

## Program 5: HTTP Server

### NOVA:
```nova
import http

serve(8080)
    get "/" -> "Hello, World!"
    get "/users/{id}" -> find_user(id)
    post "/users" -> create_user(request.body)
```

### Python (Flask):
```python
from flask import Flask, request
app = Flask(__name__)

@app.route("/")
def hello():
    return "Hello, World!"

@app.route("/users/<id>")
def get_user(id):
    return find_user(id)

@app.route("/users", methods=["POST"])
def create():
    return create_user(request.json)

app.run(port=8080)
```

**Comparison:** NOVA: 5 lines. Python/Flask: 14 lines. NOVA is nearly 3x more concise. The `serve` block with route patterns is a natural expression of the process/channel model — the server IS a process, HTTP requests flow through channels. No decorators, no app object, no method arrays.

---

## Program 6: Concurrent Processes and Channels

### NOVA:
```nova
fn word_count(files)
    results = channel()

    for file in files
        spawn
            content = read_file(file)
            words = content.split(" ").length
            send(results, {file: file, count: words})

    total = 0
    for _ in files
        result = receive(results)
        print("{result.file}: {result.count} words")
        total += result.count

    print("Total: {total} words")

word_count(["a.txt", "b.txt", "c.txt"])
```

### Python:
```python
import concurrent.futures
import threading

def word_count(files):
    results = []
    lock = threading.Lock()
    
    def count_file(file):
        with open(file) as f:
            content = f.read()
        words = len(content.split())
        with lock:
            results.append({"file": file, "count": words})
    
    with concurrent.futures.ThreadPoolExecutor() as executor:
        executor.map(count_file, files)
    
    total = 0
    for result in results:
        print(f"{result['file']}: {result['count']} words")
        total += result["count"]
    print(f"Total: {total} words")

word_count(["a.txt", "b.txt", "c.txt"])
```

**Comparison:** NOVA wins significantly:
- No imports needed (spawn/channel are built-in)
- No locks (channels handle synchronization)
- No thread pool boilerplate (spawn IS the concurrency)
- No shared mutable state (results go through channel, not shared list)
- `send`/`receive` is explicit and clear — no hidden concurrency bugs
- Python's version has a race condition risk with `results.append()` — NOVA's version is race-free BY DESIGN

---

## Program 7: AI Inference

### NOVA:
```nova
import ai

model = ai.load("resnet50.onnx")
image = read_file("photo.jpg")
predictions = model.predict(image)

for prediction in predictions.top(5)
    print("{prediction.label}: {prediction.confidence}%")
```

### Python (PyTorch):
```python
import torch
import torchvision.models as models
from torchvision import transforms
from PIL import Image

model = models.resnet50(pretrained=True)
model.eval()

transform = transforms.Compose([
    transforms.Resize(256),
    transforms.CenterCrop(224),
    transforms.ToTensor(),
    transforms.Normalize(mean=[0.485, 0.456, 0.406], std=[0.229, 0.224, 0.225]),
])

image = Image.open("photo.jpg")
input_tensor = transform(image).unsqueeze(0)

with torch.no_grad():
    output = model(input_tensor)
    probabilities = torch.nn.functional.softmax(output[0], dim=0)

top5 = torch.topk(probabilities, 5)
for i in range(5):
    print(f"{labels[top5.indices[i]]}: {top5.values[i].item()*100:.1f}%")
```

**Comparison:** NOVA: 6 lines. Python/PyTorch: 20+ lines. The complexity in Python comes from image preprocessing, tensor transforms, model mode setting, gradient context manager, and softmax. NOVA's stdlib handles all of this inside `model.predict()` — the compiler knows the input is an image, knows the model expects specific dimensions, and handles the transforms. The developer writes INTENT, the compiler handles MECHANICS.

---

## Program 8: Full-Stack App Skeleton

### NOVA:
```nova
import http
import web
import ai

// Backend API
api = spawn serve(8080)
    get "/api/analyze" ->
        image = request.file("image")
        result = predict(model, image)
        json(result)

// AI model (compiler decides CPU vs GPU)
model = ai.load("classifier.onnx")

fn predict(model, image)
    predictions = model.predict(image)
    { label: predictions.top(1).label, confidence: predictions.top(1).confidence }

// Frontend (compiles to WASM)
@device(wasm)
app = spawn web.app()
    web.page("/")
        title = web.text("Image Classifier")
        upload = web.file_input("Upload image")
        result = web.text("")

        upload.on_change ->
            response = fetch("/api/analyze", file: upload.file)
            result.set("Result: {response.label} ({response.confidence}%)")
```

### Python equivalent: Would require Flask + React/Vue (separate language) + TensorFlow/PyTorch. Minimum 3 files in 2 languages, 50+ lines total.

**Comparison:** The entire full-stack app — server, AI, browser UI — is ONE file in ONE language. This is NOVA's identity use case. No language can do this today. Python needs JavaScript for the frontend. Go needs JavaScript for the frontend. Rust needs JavaScript for the frontend. NOVA doesn't.

---

## Program 9: Systems-Level Memory Operation

### NOVA:
```nova
fn custom_allocator(size)
    @low_level
        block = alloc(size + 8)
        write(block, 0, int64(size))
        return block + 8

fn custom_free(ptr)
    @low_level
        header = ptr - 8
        size = read_int64(header, 0)
        free(header)

fn ring_buffer(capacity)
    @low_level
        buffer = alloc(capacity)
        head = 0
        tail = 0

        fn push(byte)
            next = (head + 1) % capacity
            if next == tail
                return Error("buffer full")
            write(buffer, head, byte)
            head = next

        fn pop()
            if head == tail
                return Error("buffer empty")
            val = read(buffer, tail)
            tail = (tail + 1) % capacity
            val

        return { push: push, pop: pop, free: () -> free(buffer) }

// Usage — safe API, unsafe interior
rb = ring_buffer(1024)
rb.push(byte(0x42))
value = rb.pop() or byte(0)
rb.free()
```

### C equivalent:
```c
#include <stdlib.h>
#include <stdint.h>

void* custom_alloc(size_t size) {
    void* block = malloc(size + 8);
    *(int64_t*)block = (int64_t)size;
    return (char*)block + 8;
}

void custom_free(void* ptr) {
    void* header = (char*)ptr - 8;
    free(header);
}

typedef struct {
    uint8_t* buffer;
    int capacity, head, tail;
} RingBuffer;

RingBuffer* ring_buffer_new(int capacity) {
    RingBuffer* rb = malloc(sizeof(RingBuffer));
    rb->buffer = malloc(capacity);
    rb->capacity = capacity;
    rb->head = 0;
    rb->tail = 0;
    return rb;
}

int ring_buffer_push(RingBuffer* rb, uint8_t byte) {
    int next = (rb->head + 1) % rb->capacity;
    if (next == rb->tail) return -1;
    rb->buffer[rb->head] = byte;
    rb->head = next;
    return 0;
}
// ... 20+ more lines for pop and free
```

**Comparison:** NOVA's `@low_level` gives C-equivalent power with:
- Safe wrapping (raw pointers can't escape the `@low_level` block)
- Error handling (`or` still works)
- Clean syntax (no pointer cast gymnastics)
- The consumer of `ring_buffer()` uses a safe API — never touches raw memory

---

## Program 10: Distributed Service with Supervision

### NOVA:
```nova
import http
import log

fn main()
    // Supervisor manages all workers
    supervisor = spawn
        supervise http_pool restart: always, max: 5, within: 60

    // Pool of HTTP workers
    http_pool = spawn
        workers = for _ in 1..cpu_count()
            spawn http_worker()

    fn http_worker()
        serve(8080)
            get "/health" -> { status: "ok" }
            get "/data/{id}" ->
                data = fetch_from_db(id) or return { error: "not found" }
                json(data)

    fn fetch_from_db(id)
        db = channel()
        spawn
            result = db_query("SELECT * FROM items WHERE id = {id}")
            send(db, result)
        receive(db) or Error("db timeout")

    log.info("Service started on :8080 with {cpu_count()} workers")
```

### Erlang/Elixir equivalent: Would require OTP supervisor module, GenServer behavior, routing library (Plug/Phoenix), 50+ lines across multiple files with significant boilerplate.

### Go equivalent: Would require `net/http`, goroutine management (no built-in supervision), manual restart logic, 40+ lines.

**Comparison:** NOVA combines:
- Erlang-style supervision (`supervise ... restart: always`) — but readable
- Go-style concurrency (`spawn`) — but with fault tolerance
- Express-style routing (`get "/path" -> handler`) — but type-safe
- All in one file, one language, 25 lines

---

## Summary of All 10 Programs

| # | Program | NOVA Lines | Python Lines | Simpler? |
|---|---|---|---|---|
| 1 | Hello World | 1 | 1 | Equal |
| 2 | Variables, Math, Strings | 11 | 13 | YES — cleaner interpolation, lambdas |
| 3 | Functions, Control Flow | 18 | 22 | YES — pattern matching, range syntax |
| 4 | Error Handling | 13 | 22 | YES — `or` replaces try/except |
| 5 | HTTP Server | 5 | 14 | YES — 3x more concise |
| 6 | Concurrent Processes | 14 | 20 | YES — no locks, no boilerplate |
| 7 | AI Inference | 6 | 20+ | YES — stdlib handles mechanics |
| 8 | Full-Stack App | 20 | 50+ (2 langs) | YES — one language, one file |
| 9 | Systems Memory | 28 | 40+ (C) | YES — safe wrapping, clean syntax |
| 10 | Distributed Service | 25 | 50+ (Erlang) | YES — supervision + routing together |

**Gate 1 Assessment: PASS.** Every program is equal to or simpler than the Python equivalent. For programs 4-10, NOVA is SIGNIFICANTLY simpler because those domains (error handling, concurrency, AI, full-stack, systems, distributed) expose Python's hidden complexity while NOVA handles them through one unified model.
