# NOVA Language Tutorial

**NOVA (Natively Optimized Versatile Architecture)** is a programming language built on one idea: **one developer, one language, builds anything, runs anywhere.** Systems code, web backends, AI pipelines, real-time servers, distributed systems — all in the same language, without switching between Python for scripting, C for performance, Go for concurrency, and JavaScript for the frontend.

This tutorial teaches the whole language from the ground up. Each section explains not just **what** the syntax is but **why** the design is the way it is, what goes wrong when you misuse a feature, and how everything connects. By the end you will have written a production-grade HTTP (HyperText Transfer Protocol) API (Application Programming Interface), a WebSocket chat server, a SQLite-backed CRUD (Create, Read, Update, Delete) app, worked with tensors, tested your code, and have enough understanding to build anything else.

**How to read this tutorial:**
- Every code example shows the expected output in comments
- **DO** boxes show the correct pattern
- **DON'T** boxes show the mistake and explain why it breaks
- When a feature differs from Python, Go, Rust, or JavaScript, the comparison is explicit

---

## Table of Contents

**Core Language**
1. [Install](#1-install)
2. [Hello, world](#2-hello-world)
3. [Values and types](#3-values-and-types)
4. [Control flow](#4-control-flow)
5. [Functions](#5-functions)
6. [Structs](#6-structs)
7. [Enums](#7-enums)
8. [Pattern matching](#8-pattern-matching)
9. [Error handling](#9-error-handling)
10. [Collections](#10-collections)

**Data Processing**
11. [Iterators and generators](#11-iterators-and-generators)
12. [File I/O and paths](#12-file-io-and-paths)
13. [Regular expressions](#13-regular-expressions)
14. [JSON (JavaScript Object Notation) processing](#14-json-processing)
15. [Date and time](#15-date-and-time)
16. [Testing and benchmarking](#16-testing-and-benchmarking)

**Concurrency and Networking**
17. [Processes and channels](#17-processes-and-channels)
18. [Advanced concurrency](#18-advanced-concurrency)
19. [Modules](#19-modules)
20. [Networking: TCP (Transmission Control Protocol) and UDP (User Datagram Protocol)](#20-networking-tcp-and-udp)
21. [HTTP (HyperText Transfer Protocol) client](#21-http-client)

**Security and System**
22. [Cryptography and encoding](#22-cryptography-and-encoding)
23. [System and environment](#23-system-and-environment)
24. [Logging](#24-logging)

**Forge Web Framework**
25. [Forge: building a REST (Representational State Transfer) API](#25-forge-building-a-rest-api)
26. [Forge: SQLite data layer](#26-forge-sqlite-data-layer)
27. [Forge: WebSocket and SSE (Server-Sent Events)](#27-forge-websocket-and-sse)
28. [Forge: authentication](#28-forge-authentication)
29. [Forge: HTML (HyperText Markup Language) builder](#29-forge-html-builder)
30. [Forge: advanced features](#30-forge-advanced-features)

**Low-Level and Advanced**
31. [FFI (Foreign Function Interface): calling C](#31-ffi-calling-c)
32. [Unsafe and low-level](#32-unsafe-and-low-level)
33. [Bytes and binary data](#33-bytes-and-binary-data)
34. [AI (Artificial Intelligence) and tensors](#34-ai-and-tensors)
35. [Distributed computing](#35-distributed-computing)
36. [Performance guide](#36-performance-guide)

**Appendices**
- [Appendix A: Quick reference](#appendix-a-quick-reference)
- [Appendix B: Common patterns](#appendix-b-common-patterns)
- [Appendix C: Troubleshooting](#appendix-c-troubleshooting)
- [Appendix D: Standard library modules](#appendix-d-standard-library-modules)

---

## 1. Install

NOVA ships as a single self-contained binary: the compiler, runtime, and standard library all in one. There is no package manager to install first, no runtime VM (Virtual Machine) to configure, no header files to locate.

### Getting the binary

The compiler binary is called `gen3_test.exe` on Windows and `gen3_test` on Linux/macOS. It lives in `nova-compiler/` inside the NOVA repository after you clone and build. The build instructions are in `nova-compiler/README.md` — the compiler is self-hosted in NOVA and compiles itself.

Once you have the binary, alias it so you can type `nova` instead of the full path:

**Windows (PowerShell profile):**

```powershell
function nova { & "C:\path\to\nova-compiler\gen3_test.exe" @args }
```

Add that line to `$PROFILE` so it persists across shells.

**Linux/macOS (shell profile):**

```bash
alias nova='/path/to/nova-compiler/gen3_test'
```

Add that to `~/.bashrc` or `~/.zshrc`.

### What happens when you run `nova`

The NOVA compiler is not an interpreter — it is a full ahead-of-time compiler. When you type:

```
nova run hello.nova
```

Here is what happens behind the scenes:

1. **Lexing** — the compiler reads your `.nova` file and breaks it into tokens (keywords, identifiers, operators, literals)
2. **Parsing** — tokens become an Abstract Syntax Tree (AST) representing the structure of your program
3. **Type inference** — the compiler walks the AST, infers every type without you writing annotations, checks for type errors, and resolves function calls
4. **IR (Intermediate Representation) generation** — the typed AST is lowered to NOVA's IR, a simplified version of your program that is easier to optimize
5. **LLVM (Low-Level Virtual Machine) codegen** — the IR is translated to LLVM IR (the same backend used by C, C++, Rust, and Swift)
6. **Compilation** — LLVM compiles the IR to native machine code (`.exe` on Windows, ELF (Executable and Linkable Format) on Linux)
7. **Execution** — the compiled binary runs directly on your CPU (Central Processing Unit) with no interpreter, no JIT (Just-In-Time) warmup, no VM

This is why NOVA achieves C-level performance: it produces the same kind of machine code that `clang -O2` produces for C programs.

### Setting NOVA_HOME

NOVA resolves standard library modules — including Forge — by looking in `$NOVA_HOME/lib/`. You must set this environment variable to the directory that contains the `lib/` folder.

**Windows:**

```powershell
$env:NOVA_HOME = "C:\path\to\nova-compiler"
```

To make it permanent, add it to your system environment variables or to `$PROFILE`.

**Linux/macOS:**

```bash
export NOVA_HOME=/path/to/nova-compiler
```

Verify the setup by checking that `$NOVA_HOME/lib/forge.nova` exists. If that file is there, all standard library imports will work.

### Verify the install

```
nova run hello.nova
```

If you see output, it works. If you see "cannot find module" errors, check `NOVA_HOME`.

> **DO:** Set `NOVA_HOME` to the directory that contains the `lib/` folder (e.g., `nova-compiler/`), not to `lib/` itself.
> **DON'T:** Leave `NOVA_HOME` unset and wonder why `import forge` fails — the error message will tell you the path it looked in, which makes the fix obvious.

### Editor setup: nova-vscode

NOVA has a VS Code (and Antigravity) extension in the `nova-vscode/` directory of the repository. The extension provides:

- **Syntax highlighting** — keywords, types, strings with `{interpolation}`, operators, function calls, builtins
- **Goto definition (Ctrl+Click)** — jumps to where a symbol is defined, including:
  - Top-level functions: `fn name(...)` — click any call site to jump to the definition
  - Method receivers: `fn Type.name(...)` — click a method call like `point.dist()` to jump to the method
  - Struct types: `type Name` — click a constructor like `Point{...}` to jump to the struct
  - Enum and trait declarations: `enum Shape`, `trait Drawable` — click the name to jump
  - Struct fields: `    x: float` inside a `type` block — click a field access like `p.x` to jump
  - **Cross-module navigation**: if a symbol is defined in an imported module, Ctrl+Click opens that file and jumps to the definition

To install: copy the `nova-vscode` folder into your VS Code extensions directory (`~/.vscode/extensions/` or `~/.antigravity/extensions/`), then reload the editor. Files ending in `.nova` will automatically get syntax highlighting and LSP (Language Server Protocol) features.

---

## 2. Hello, world

```nova
print("Hello, world!")
```

Save this as `hello.nova` and run:

```
nova run hello.nova
```

Output:
```
Hello, world!
```

That is the entire program. No `import`, no `class`, no `public static void main`, no semicolons, no braces. One line does one thing.

### What actually happens when you run this

`print` is a built-in function. It takes any value, converts it to a string if it isn't already, writes it to standard output, and adds a newline. It is the equivalent of:
- Python: `print("Hello, world!")`
- Go: `fmt.Println("Hello, world!")`
- Rust: `println!("Hello, world!");`
- C: `printf("Hello, world!\n");`

But unlike C, you do not need to include a header. Unlike Go, you do not need an import. Unlike Rust, there is no macro syntax. Unlike Java, there is no class or method wrapper. NOVA's `print` is always available everywhere with no ceremony.

### String interpolation

NOVA strings use `{ }` for interpolation — any expression inside braces is evaluated and inserted into the string:

```nova
name = "Alice"
age = 30
print("Hello, {name}! You are {age} years old.")
// Output: Hello, Alice! You are 30 years old.
```

You can put any expression inside the braces, not just variable names:

```nova
x = 7
print("x squared is {x * x}")
// Output: x squared is 49

items = ["a", "b", "c"]
print("There are {len(items)} items")
// Output: There are 3 items
```

**Comparison to other languages:**
- Python uses `f"Hello, {name}"` — NOVA does not need the `f` prefix, all strings support interpolation
- JavaScript uses `` `Hello, ${name}` `` — NOVA uses regular quotes, not backticks, and no `$`
- Go has `fmt.Sprintf("Hello, %s", name)` — NOVA's approach is simpler and type-safe
- Rust uses `format!("Hello, {name}")` — NOVA is the same syntax but without the macro

### Escaping braces

If you need a literal `{` or `}` in your string, escape them with a backslash:

```nova
print("JSON looks like: \{\"key\": \"value\"\}")
// Output: JSON looks like: {"key": "value"}
```

> **DO:** Use `\{` and `\}` when you need literal braces in strings.
> **DON'T:** Forget that `{variable}` inside a string will try to interpolate — if you want literal braces for JSON templates, always escape them.

### Your first function

```nova
fn greet(name)
    print("Hello, {name}!")

greet("Bob")
greet("Carol")
```

Output:
```
Hello, Bob!
Hello, Carol!
```

**Line-by-line breakdown:**

- `fn greet(name)` — This declares a function named `greet` that takes one parameter called `name`. The keyword `fn` means "function." There is **no type annotation** on `name` — the compiler figures out that `name` is a string because you use it inside a string interpolation below. In Java you would write `void greet(String name)`. In Python you would write `def greet(name):`. In NOVA you write `fn greet(name)`. Shorter, cleaner, and the compiler knows the type anyway.
- `    print("Hello, {name}!")` — This line is indented by 4 spaces (or 1 tab). The indentation tells NOVA that this line is **inside** the function body. `{name}` inside the string is replaced by the value of the `name` variable. There is no `return` statement because this function does not return a value — it just prints to the screen.
- `greet("Bob")` — This calls the `greet` function with the string `"Bob"`. The compiler now knows `name` is a string because you passed a string here. The function prints `Hello, Bob!`.
- `greet("Carol")` — Same function, different input. Prints `Hello, Carol!`.

**Key things to notice:**
- **No type annotations needed** — the compiler infers `name` is a string from how it is used. You did not write `name: string` anywhere.
- **No return type declaration** — the function does not return a value, so none is needed. If it did return something, the last expression would be the return value automatically.
- **Indentation defines blocks** — NOVA uses indentation for blocks, like Python. There are no braces `{ }` and no `end` keyword. Everything indented under `fn greet(name)` is inside the function.
- **No semicolons** — lines end naturally. No `;` needed anywhere.

### main() — when you need it

For simple scripts, top-level code runs directly. For larger programs with multiple functions that call each other, use `fn main()`:

```nova
fn add(a, b)
    a + b

fn main()
    result = add(3, 4)
    print("3 + 4 = {result}")
```

Output:
```
3 + 4 = 7
```

**Line-by-line breakdown:**

- `fn add(a, b)` — Declares a function called `add` that takes two parameters. Again, no type annotations. The compiler will figure out that `a` and `b` are integers because you call `add(3, 4)` below.
- `    a + b` — This is the **entire body** of the function. There is no `return` keyword. In NOVA, the last expression in a function is automatically its return value. `a + b` evaluates to `7`, and that value is returned to the caller. This is like Ruby or Rust, where the last expression is the implicit return.
- `fn main()` — The `main` function is the entry point of your program. When `fn main()` exists, NOVA starts executing there. When it does not exist, NOVA runs top-level statements from top to bottom instead.
- `    result = add(3, 4)` — Calls the `add` function with arguments `3` and `4`, and stores the return value (`7`) in a variable called `result`. Variables can be declared with or without `let` — both `let result = add(3, 4)` and `result = add(3, 4)` are valid. `let` is optional. There is no `var` or `const`.
- `    print("3 + 4 = {result}")` — Prints the string with `{result}` replaced by the value of the `result` variable (which is `7`).

**When to use `main()` vs. top-level code:**
- **One-file scripts** — Do not need `main()`. Top-level statements run in order. Great for quick experiments.
- **Multi-file projects** — Use `main()` as the entry point so the compiler knows where execution begins.
- **Programs with tests** — Use `main()` so that test functions (`test_run`/`test_summary`) do not conflict with normal execution.

### Comments

```nova
// This is a line comment
x = 42  // This is an inline comment

// NOVA does not have multi-line /* */ comments
// Use multiple // lines instead
```

---

## 3. Values and types

NOVA has five basic value types. The compiler infers all of them — you never have to write type annotations for local variables.

### Integers

Integers are 64-bit signed values. They can hold any value from -9,223,372,036,854,775,808 to 9,223,372,036,854,775,807.

```nova
x = 42
y = -17
big = 1_000_000_000    // underscores for readability, ignored by compiler
hex = 0xFF              // hexadecimal: 255
bin = 0b1010            // binary: 10
oct = 0o77              // octal: 63
print(x)        // 42
print(big)      // 1000000000
print(hex)      // 255
```

**Integer overflow behavior:** NOVA integers wrap on overflow. This means if you add 1 to the maximum 64-bit integer, it wraps to the minimum value. This is the same behavior as C's unsigned arithmetic, and it means integer math is always defined (never undefined behavior), but the result may not be what you expect:

```nova
max_int = 9223372036854775807
print(max_int + 1)
// Output: -9223372036854775808 (wrapped around)
```

If you need overflow detection, use `checked_add`, `checked_sub`, or `checked_mul`:

```nova
a = 9223372036854775807
result = checked_add(a, 1)
// result is Err("overflow") — you can handle it instead of getting a silent wrap
```

**Integer division:** Division of two integers uses integer division (rounds toward zero), just like C and Go:

```nova
print(7 / 2)      // 3 (not 3.5)
print(-7 / 2)     // -3 (rounds toward zero)
print(7 % 2)      // 1 (remainder)
```

> **DO:** Use underscores in large numbers for readability: `1_000_000` instead of `1000000`.
> **DON'T:** Expect `7 / 2` to return `3.5` — use `7.0 / 2.0` or `float(7) / float(2)` if you need a float result.

### Floats

Floats are 64-bit IEEE (Institute of Electrical and Electronics Engineers) 754 double-precision values, the same as `double` in C or `float` in Python.

```nova
pi = 3.14159
temp = -40.0
sci = 1.5e10        // scientific notation: 15000000000.0
tiny = 2.5e-4       // 0.00025
print(pi)           // 3.14159
print(sci)          // 15000000000
```

**The float comparison trap:** Floating-point arithmetic is approximate. Never compare floats with `==`:

```nova
// THIS IS A BUG — do not do this:
x = 0.1 + 0.2
if x == 0.3
    print("equal")    // This will NOT print!

// 0.1 + 0.2 is actually 0.30000000000000004 in IEEE 754
print(0.1 + 0.2)     // 0.30000000000000004

// CORRECT: compare with a tolerance
fn approx_eq(a, b)
    abs(a - b) < 0.0001

if approx_eq(0.1 + 0.2, 0.3)
    print("approximately equal")    // This prints
```

This is not a NOVA bug — it happens in every language that uses IEEE 754 floats (C, Python, Java, JavaScript, Rust, Go — all of them). NOVA exposes the real behavior instead of hiding it.

**Math functions available for floats:**

```nova
print(sqrt(16.0))      // 4.0
print(abs(-5.3))       // 5.3
print(floor(3.7))      // 3.0
print(ceil(3.2))       // 4.0
print(round(3.5))      // 4.0
print(pow(2.0, 10.0))  // 1024.0
print(sin(3.14159))    // ~0.0 (radians)
print(cos(0.0))        // 1.0
print(log(2.718))      // ~1.0 (natural log)
print(log2(1024.0))    // 10.0
print(log10(1000.0))   // 3.0
print(exp(1.0))        // 2.718281828...
print(min(3.0, 7.0))   // 3.0
print(max(3.0, 7.0))   // 7.0
print(atan2(1.0, 1.0)) // 0.7853... (pi/4)
print(hypot(3.0, 4.0)) // 5.0
```

> **DO:** Use `assert_approx(actual, expected, tolerance)` in tests when comparing float results.
> **DON'T:** Write `if result == 3.14` — floats are approximate. Use a tolerance.

### Strings

Strings are UTF-8 (Unicode Transformation Format, 8-bit) encoded sequences of bytes. They are immutable — every operation that "changes" a string actually creates a new one.

```nova
greeting = "Hello, world!"
empty = ""
multiline = "line one\nline two\nline three"
```

**String operations:**

```nova
s = "Hello, NOVA!"

// Length (byte count)
print(len(s))              // 12

// Case conversion
print(upper(s))            // HELLO, NOVA!
print(lower(s))            // hello, nova!

// Trimming whitespace
print(trim("  hello  "))   // hello
print(ltrim("  hello"))    // hello
print(rstrip("hello  "))   // hello

// Searching
print(find(s, "NOVA"))     // 7 (index of first match)
print(find(s, "xyz"))      // -1 (not found)
print(starts_with(s, "Hello"))  // true
print(ends_with(s, "!"))        // true

// Replacing
print(replace(s, "NOVA", "World"))  // Hello, World!

// Splitting and joining
words = split("one two three", " ")
print(words)               // [one, two, three]
print(join(words, ", "))   // one, two, three

// Slicing (substring)
print(slice(s, 7, 11))    // NOVA

// Character access
print(char_at(s, 0))      // H
print(char_at(s, -1))     // ! (negative indexes count from end)

// Iteration
for c in "abc"
    print(c)
// Output: a, b, c (one per line)

// Repetition
print(repeat("ha", 3))    // hahaha

// Padding
print(pad_left("42", 5, "0"))   // 00042
print(pad_right("hi", 10, ".")) // hi........
```

**The string building trap:** Strings are immutable, so `result = result + piece` inside a loop creates a new string every iteration. For N iterations, this is O(n²) total work because each concatenation copies the entire accumulated string:

```nova
// SLOW: O(n²) — each + copies the whole string
result = ""
for i in 0..1000
    result = result + str(i) + ","
// After 1000 iterations, this has copied ~500,000 characters total

// FAST: O(n) — collect parts in a list, join once at the end
parts = []
for i in 0..1000
    parts.push(str(i))
result = join(parts, ",")
// Only one allocation at the end
```

**Even faster: use a Buffer** (see [Section 10: Collections](#10-collections)):

```nova
buf = buffer_create()
for i in 0..1000
    buf_append(buf, str(i))
    buf_append(buf, ",")
result = buf_to_str(buf)
// Buffer grows in place — no copying at all
```

**Type conversion to/from strings:**

```nova
print(str(42))        // "42"
print(str(3.14))      // "3.14"
print(str(true))      // "true"
print(int("42"))      // 42
print(float("3.14"))  // 3.14
print(int(3.9))       // 3 (truncates toward zero, does NOT round)
```

> **DO:** Use `join(parts, sep)` to build strings from many pieces, or `buffer_create()` for the highest performance.
> **DON'T:** Write `result = result + piece` inside a loop — it is O(n²) and will be noticeably slow for more than ~100 iterations.

### Booleans

```nova
a = true
b = false
print(a)        // true
print(not a)    // false
print(a and b)  // false
print(a or b)   // true
```

Logical operators `and` and `or` short-circuit, just like Python:

```nova
// If the left side of `and` is false, the right side is never evaluated
x = 0
if x != 0 and 10 / x > 2
    print("safe")
// Without short-circuit, 10 / 0 would crash. With short-circuit, it never executes.
```

**Truthiness:** In boolean contexts (like `if`), `0`, `""` (empty string), `false`, and `null` are falsy. Everything else is truthy:

```nova
if 42
    print("truthy")    // prints — 42 is truthy
if ""
    print("truthy")    // does NOT print — empty string is falsy
if "hello"
    print("truthy")    // prints — non-empty string is truthy
```

> **DO:** Use `and`/`or`/`not` for boolean logic (not `&&`/`||`/`!`).
> **DON'T:** Write `if x == true` — just write `if x`. Similarly, `if x == false` should be `if not x`.

### Lists

Lists are ordered, mutable sequences. They can hold any values.

```nova
nums = [1, 2, 3, 4, 5]
names = ["alice", "bob", "carol"]
mixed = [1, "hello", 3.14, true]    // lists can hold mixed types
empty = []

print(nums[0])      // 1 (first element)
print(nums[-1])     // 5 (last element)
print(nums[-2])     // 4 (second to last)
print(len(nums))    // 5
```

**Bounds checking:** NOVA checks array bounds at runtime. If you access an out-of-range index, the program panics with a clear error instead of corrupting memory:

```nova
items = [10, 20, 30]
print(items[5])
// Runtime error: index 5 out of bounds (list length 3)
```

This is a safety feature. In C, `items[5]` would read garbage memory or crash. In NOVA, you get an immediate, informative error.

**Modifying lists:**

```nova
nums = [1, 2, 3]

// Append to end
push(nums, 4)
print(nums)           // [1, 2, 3, 4]

// Remove and return last element
last = pop(nums)
print(last)           // 4
print(nums)           // [1, 2, 3]

// Insert at position
insert(nums, 1, 99)
print(nums)           // [1, 99, 2, 3]

// Remove by value
remove(nums, 99)
print(nums)           // [1, 2, 3]

// Remove by index
remove_at(nums, 0)
print(nums)           // [2, 3]

// Concatenate two lists
a = [1, 2]
b = [3, 4]
c = a + b
print(c)              // [1, 2, 3, 4]

// Membership test
print(2 in nums)      // true
print(99 in nums)     // false

// Sort in place
data = [3, 1, 4, 1, 5]
sort(data)
print(data)           // [1, 1, 3, 4, 5]

// Reverse in place
reverse(data)
print(data)           // [5, 4, 3, 1, 1]

// Slice (does not modify original)
sub = data[1:3]
print(sub)            // [4, 3]
```

### Dicts

Dicts are unordered key-value maps. Keys are typically strings but can be any hashable type.

```nova
person = {"name": "Alice", "age": 30, "city": "NYC"}

// Access
print(person["name"])     // Alice

// Check key existence BEFORE accessing
if contains(person, "email")
    print(person["email"])
else
    print("no email")     // prints this

// Set / update
person["email"] = "alice@example.com"
print(person["email"])    // alice@example.com

// Delete
delete(person, "city")
print(contains(person, "city"))  // false

// Length
print(len(person))        // 3

// Get all keys and values
ks = keys(person)
vs = values(person)

// Iterate
for k in keys(person)
    print("{k}: {person[k]}")
```

> **DO:** Always check `contains(d, key)` before accessing `d[key]` when the key might not exist.
> **DON'T:** Access `d[key]` on a key that does not exist — this will return a default value (0 for ints, "" for strings) which can silently introduce bugs.

### null

`null` represents the absence of a value. It is falsy in boolean contexts.

```nova
x = null
if x
    print("has value")
else
    print("is null")    // prints this

print(x == null)        // true
```

Use `null` for optional fields or to indicate "no result." Prefer the `Result` type (see [Error handling](#9-error-handling)) for operations that can fail — `null` gives no information about WHY something failed.

### Type inference: how the compiler knows what type everything is

NOVA's compiler uses Hindley-Milner type inference (the same algorithm used by ML, Haskell, and Rust). This means:

1. You write no type annotations on local variables
2. The compiler figures out every type from how you use the value
3. If two types conflict, you get a compile error

```nova
x = 42           // compiler infers: x is int (because 42 is an int literal)
y = 3.14          // compiler infers: y is float
name = "Alice"    // compiler infers: name is string
items = [1, 2, 3] // compiler infers: items is list of int
```

The inference works across function boundaries too:

```nova
fn double(x)
    x * 2

print(double(5))       // compiler infers x is int here → returns int
print(double(3.14))    // compiler infers x is float here → returns float
```

The compiler tracks types through every expression. When types conflict, it reports a clear error:

```nova
x = 42
x = "hello"   // compile error: cannot assign string to int variable
```

### When to write a type annotation

For 95% of code, you write zero type annotations. The compiler figures everything out. But there are cases where annotations help:

**1. Struct field types — CRITICAL for performance:**

```nova
type Point
    x: float    // lowercase float = native CPU math = FAST
    y: float
```

This is the single most important rule in NOVA. See [Structs](#6-structs) for the full explanation.

**2. Function parameters that need to accept specific types:**

```nova
fn distance(a: Point, b: Point) -> float
    sqrt((a.x - b.x) * (a.x - b.x) + (a.y - b.y) * (a.y - b.y))
```

**3. Empty collections where the compiler cannot infer the element type:**

```nova
let nums: list = []    // tells compiler this will hold values
```

> **DO:** Let the compiler infer types. Write annotations only on struct fields and function signatures where clarity or performance requires it.
> **DON'T:** Write type annotations on every variable like Java — that defeats NOVA's simplicity promise.

---

## 4. Control flow

### if / else

`if/else` in NOVA is an expression — it evaluates to a value, like the ternary operator in other languages.

**As a statement (indented block):**

```nova
x = 10
if x > 5
    print("big")
else
    print("small")
// Output: big
```

**As an expression (single-line with `then`):**

```nova
x = 10
label = if x > 5 then "big" else "small"
print(label)   // big
```

**Chained conditions:**

```nova
score = 85

grade = if score >= 90
    "A"
else if score >= 80
    "B"
else if score >= 70
    "C"
else
    "F"

print("Grade: {grade}")   // Grade: B
```

Blocks are indentation-delimited. There are no braces. The body must be indented at least one level deeper than the `if`.

> **DO:** Use `if/else` as an expression to eliminate single-use variables: `let label = if x > 0 then "positive" else "non-positive"`
> **DON'T:** Write `if condition then doSomething()` on one line expecting it to work for multi-statement bodies — `then` is only for the single-expression form. If the body has multiple statements, use the indented block form.

### while loops

```nova
n = 1
while n <= 10
    print(n)
    n = n + 1
// Output: 1 2 3 4 5 6 7 8 9 10 (each on its own line)
```

`break` exits the loop immediately. `continue` jumps to the next iteration.

```nova
i = 0
while i < 100
    i = i + 1
    if i % 2 == 0
        continue    // skip even numbers
    if i > 10
        break       // stop after 10
    print(i)
// Output: 1 3 5 7 9
```

### for-in loops

```nova
names = ["alice", "bob", "carol"]
for name in names
    print("Hello, {name}!")
// Output:
// Hello, alice!
// Hello, bob!
// Hello, carol!
```

For loops work over any iterable: lists, dicts (iterates keys), strings (iterates characters), and ranges.

### Ranges

`a..b` creates a half-open range **from `a` up to but not including `b`** (exclusive right end). Use it in for loops:

```nova
for i in 0..4
    print(i)
// Output: 0 1 2 3  (four values — 4 is NOT included)
```

The range `0..n` is how you loop `n` times:

```nova
for i in 0..10
    print(i)     // 0 through 9, ten values total
```

> **DON'T:** Assume `0..4` gives 5 values. It gives 4 (0, 1, 2, 3) — the right end is excluded, exactly like Python's `range(0, 4)`. If you want to include 4, write `0..5`.

### loop — infinite loop with break

The `loop` keyword creates an infinite loop. You exit it with `break` or `return`:

```nova
count = 0
loop
    count += 1
    if count >= 5
        break
print(count)    // 5
```

This is useful when the exit condition is in the middle of the loop body, not at the top:

```nova
fn find_first_even(nums: list) -> int
    idx = 0
    loop
        if idx >= len(nums)
            return -1           // not found
        if nums[idx] % 2 == 0
            return nums[idx]    // found it
        idx += 1

print(find_first_even([1, 3, 5, 4, 7]))   // 4
print(find_first_even([1, 3, 5]))          // -1
```

`loop` is cleaner than `while true` because it explicitly communicates "this loop runs until I break out of it."

### Iterating with index

When you need both the index and the value:

```nova
fruits = ["apple", "banana", "cherry"]
i = 0
while i < len(fruits)
    print("{i}: {fruits[i]}")
    i = i + 1
// Output:
// 0: apple
// 1: banana
// 2: cherry
```

Or use `enumerate` from the iterator library:

```nova
fruits = ["apple", "banana", "cherry"]
for pair in enumerate(fruits)
    print("{pair[0]}: {pair[1]}")
```

### Iterating dicts

```nova
scores = {"alice": 95, "bob": 88, "carol": 91}
for name in keys(scores)
    print("{name}: {scores[name]}")
```

The `keys()` built-in returns a list of all keys. Iteration order over dicts is not guaranteed to be insertion order.

### Compound assignment operators

```nova
x = 10
x += 3     // x is now 13 (same as x = x + 3)
x -= 1     // x is now 12
x *= 2     // x is now 24
x /= 4     // x is now 6
x %= 5     // x is now 1
```

### match as a conditional

For multiple conditions on the same value, `match` is cleaner than a chain of `if/else if`. See the [Pattern matching](#8-pattern-matching) section for the full story.

---

## 5. Functions

### Basic function syntax

```nova
fn add(a, b)
    a + b

print(add(3, 4))    // 7
```

The last expression in a function body is the return value — no `return` keyword needed. This is the same as Rust, Ruby, and Kotlin.

### Explicit return

Use `return` for early exit from a function:

```nova
fn divide(a, b)
    if b == 0
        return err("division by zero")
    ok(a / b)

print(divide(10, 3))   // Ok(3)
print(divide(10, 0))   // Err(division by zero)
```

### Default parameters

```nova
fn greet(name, greeting = "Hello")
    print("{greeting}, {name}!")

greet("Alice")              // Hello, Alice!
greet("Bob", "Good morning") // Good morning, Bob!
```

Default parameters must come after required parameters.

### Multiple return values via structs

NOVA does not have tuples. When you need to return multiple values, use a struct (for named fields) or a list (for quick-and-dirty):

```nova
// Using a struct (preferred — self-documenting)
type DivResult
    quotient: int
    remainder: int

fn divmod(a, b)
    DivResult { quotient: a / b, remainder: a % b }

r = divmod(17, 5)
print("17 / 5 = {r.quotient} remainder {r.remainder}")
// Output: 17 / 5 = 3 remainder 2
```

```nova
// Using a list (quick-and-dirty — works but fields are unnamed)
fn minmax(items)
    lo = items[0]
    hi = items[0]
    for x in items
        if x < lo
            lo = x
        if x > hi
            hi = x
    [lo, hi]

result = minmax([3, 1, 4, 1, 5, 9])
print("min={result[0]}, max={result[1]}")
// Output: min=1, max=9
```

> **DO:** Use structs for return values that have more than 2 fields or will be passed to other functions.
> **DON'T:** Return a list of 5 unnamed values — nobody will remember which index is which.

### Closures

Closures (also called anonymous functions or lambdas) are functions without a name. They are useful when you need a short function that you will only use once — for example, passing to `map()` or `filter()`. Closures can also "capture" variables from the surrounding code, meaning they remember the values that existed where they were created.

NOVA has three forms of closures:

```nova
// Form 1: Arrow closure (single expression, one parameter)
double = x => x * 2
print(double(5))    // 10

// Form 2: Arrow closure (single expression, multiple parameters)
add = (a, b) => a + b
print(add(3, 4))    // 7

// Form 3: Block-body closure (multiple statements)
process = fn(x)
    y = x * 2
    y + 1
print(process(5))   // 11
```

**Line-by-line breakdown:**

- `double = x => x * 2` — Creates a closure that takes one parameter `x` and returns `x * 2`. The `=>` arrow separates the parameter from the body. This is similar to JavaScript's `x => x * 2` or Python's `lambda x: x * 2`. The closure is stored in a variable called `double`, so you can call it later like a regular function.
- `print(double(5))` — Calls the closure stored in `double` with argument `5`. The closure computes `5 * 2 = 10` and `print` outputs `10`.
- `add = (a, b) => a + b` — When a closure takes more than one parameter, wrap them in parentheses: `(a, b)`. The body `a + b` is still a single expression.
- `process = fn(x)` — This is the block-body form, used when the closure needs multiple statements. It starts with `fn(parameters)` and the body is indented below, just like a regular function.
- `    y = x * 2` — First statement inside the closure: compute `x * 2` and store it in `y`.
- `    y + 1` — Last expression in the closure body. Since it is the last line, its value (`11` when `x` is `5`) is the return value of the closure. No `return` keyword needed.

**Closures capture by value, not by reference:**

```nova
x = 10
f = fn() print(x)
x = 20
f()    // prints 10, not 20 — the closure captured x's value at creation time
```

**Line-by-line breakdown:**

- `x = 10` — Sets `x` to `10`.
- `f = fn() print(x)` — Creates a closure that prints `x`. At this moment, `x` is `10`, so the closure **captures a copy** of `10`. The closure now permanently remembers `x = 10`.
- `x = 20` — Changes `x` to `20`. But the closure `f` already captured the old value — it does not see this change.
- `f()` — Calls the closure. It prints `10`, not `20`.

**Why this matters:** In Python and JavaScript, closures capture by reference — they see the *current* value of the variable, not the value at capture time. This causes real bugs:

```python
# Python — this is a common bug
funcs = []
for i in range(5):
    funcs.append(lambda: print(i))
for f in funcs:
    f()   # prints 4, 4, 4, 4, 4 — NOT 0, 1, 2, 3, 4!
```

NOVA's capture-by-value makes this bug impossible. Each closure gets its own copy of the value at the moment it is created.

> **DO:** Use `x => expr` for short one-liner closures. Use `fn(x) ... body ...` for multi-statement closures.
> **DON'T:** Expect a closure to see changes made to captured variables after the closure was created — it captured a copy at creation time, not a reference.

### Higher-order functions

A higher-order function is a function that takes another function as a parameter, or returns a function. This is one of the most powerful concepts in programming — it lets you write general-purpose code that can be customized by the caller.

NOVA has three built-in higher-order functions that you will use constantly: `map`, `filter`, and `reduce`.

**map — transform every element in a list:**

```nova
nums = [1, 2, 3, 4, 5]

squares = map(nums, x => x * x)
print(squares)   // [1, 4, 9, 16, 25]
```

**Line-by-line breakdown:**

- `nums = [1, 2, 3, 4, 5]` — Creates a list of five integers.
- `squares = map(nums, x => x * x)` — `map` takes two arguments: a list and a function. It applies the function to every element of the list and returns a new list with the results. Here, `x => x * x` is a closure that squares its input. So `map` computes: `1*1=1`, `2*2=4`, `3*3=9`, `4*4=16`, `5*5=25` and returns `[1, 4, 9, 16, 25]`. The original list `nums` is not modified.

Think of `map` as a conveyor belt: each item goes in, the function transforms it, and the transformed item comes out the other end.

**filter — keep only elements that pass a test:**

```nova
nums = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

evens = filter(nums, x => x % 2 == 0)
print(evens)     // [2, 4, 6, 8, 10]
```

**Line-by-line breakdown:**

- `evens = filter(nums, x => x % 2 == 0)` — `filter` takes a list and a function that returns `true` or `false` (called a "predicate"). It returns a new list containing only the elements for which the function returned `true`. Here, `x => x % 2 == 0` tests whether `x` is even (divides evenly by 2). So `filter` keeps `2, 4, 6, 8, 10` and drops `1, 3, 5, 7, 9`.

**reduce — combine all elements into a single value:**

```nova
nums = [1, 2, 3, 4, 5]

total = reduce(nums, 0, (acc, x) => acc + x)
print(total)     // 15
```

**Line-by-line breakdown:**

- `total = reduce(nums, 0, (acc, x) => acc + x)` — `reduce` takes three arguments: a list, an initial value (called the "accumulator"), and a function that combines the accumulator with each element. It works step by step:
  - Start: `acc = 0` (the initial value)
  - Step 1: `acc = 0 + 1 = 1`
  - Step 2: `acc = 1 + 2 = 3`
  - Step 3: `acc = 3 + 3 = 6`
  - Step 4: `acc = 6 + 4 = 10`
  - Step 5: `acc = 10 + 5 = 15`
  - Return: `15`

You can use `reduce` to compute sums, products, maximums, string concatenation, and many other "fold all elements into one result" operations.

**Chaining map, filter, and reduce:**

```nova
nums = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

// Step 1: square every number → [1, 4, 9, 16, 25, 36, 49, 64, 81, 100]
// Step 2: keep only squares > 20 → [25, 36, 49, 64, 81, 100]
// Step 3: sum them → 355

big_squares_sum = reduce(
    filter(map(nums, x => x * x), x => x > 20),
    0,
    (acc, x) => acc + x
)
print(big_squares_sum)    // 355
```

**Line-by-line breakdown:**

- `map(nums, x => x * x)` — (innermost) Squares every number: `[1, 4, 9, 16, 25, 36, 49, 64, 81, 100]`.
- `filter(..., x => x > 20)` — Keeps only squares greater than 20: `[25, 36, 49, 64, 81, 100]`.
- `reduce(..., 0, (acc, x) => acc + x)` — Sums them: `25 + 36 + 49 + 64 + 81 + 100 = 355`.

This reads "inside out" which can be hard to read. For a lazier, more composable approach to chaining, see [Iterators](#11-iterators-and-generators).

> **DO:** Use `map` to transform lists, `filter` to select elements, and `reduce` to combine elements into a single value.
> **DON'T:** Write a `for` loop to do what `map` or `filter` already does — the built-in functions are clearer and the compiler can optimize them better.

### Writing your own higher-order function

You can write functions that take other functions as parameters, just like `map` and `filter`:

```nova
fn apply_twice(f, x)
    f(f(x))

print(apply_twice(x => x + 1, 5))    // 7
print(apply_twice(x => x * 2, 3))    // 12
```

**Line-by-line breakdown:**

- `fn apply_twice(f, x)` — Takes two parameters: `f` (a function) and `x` (a value). The compiler knows `f` is a function because you call it with `f(...)` inside the body.
- `    f(f(x))` — Calls `f` on `x`, then calls `f` again on the result. For `apply_twice(x => x + 1, 5)`: first call is `f(5) = 6`, second call is `f(6) = 7`.
- `apply_twice(x => x * 2, 3)` — First call: `f(3) = 6`. Second call: `f(6) = 12`. Result: `12`.

### Recursion

```nova
fn factorial(n)
    if n <= 1
        return 1
    n * factorial(n - 1)

print(factorial(10))    // 3628800
```

```nova
fn fibonacci(n)
    if n <= 1
        return n
    fibonacci(n - 1) + fibonacci(n - 2)

print(fibonacci(10))    // 55
```

> **DON'T:** Use deep recursion (>1000 levels) in NOVA — there is no tail-call optimization currently, so deep recursion will overflow the stack. Use a loop for iterative algorithms.

### Named functions vs closures — when to use which

Use named functions (`fn name(...)`) for:
- Reusable logic called from multiple places
- Functions that are part of your module's API
- Methods on structs

Use closures (`x => expr` or `fn(x) ...`) for:
- Short callbacks passed to `map`, `filter`, `reduce`
- One-time-use functions in local scope
- Functions stored in data structures

---

## 6. Structs

Structs are how you create custom data types with named fields. They are NOVA's equivalent of classes (but without inheritance), Go's structs, Rust's structs, or Python's dataclasses.

### Declaring a struct

```nova
type Point
    x: float
    y: float

type User
    name: string
    age: int
    email: string
```

Each field has a name and a type annotation. The type annotation on struct fields is required — this is one of the few places where NOVA asks you to write types explicitly.

### THE most important rule in NOVA: lowercase field types

This is the single rule that has the biggest impact on your program's performance.

```nova
// FAST: lowercase type names → native CPU math → C-level performance
type FastPoint
    x: float        // lowercase float
    y: float

// SLOW: capital type names → dynamic dispatch → 150x slower
type SlowPoint
    x: Float        // capital Float — DO NOT DO THIS
    y: Float
```

**Why this matters:** When you write `x: float` (lowercase), the compiler stores the value as a raw 64-bit IEEE 754 number and generates native CPU instructions (`fmul`, `fadd`) for arithmetic. When you write `x: Float` (capital), the compiler treats the field as a boxed, type-erased value and generates calls to `nova_rt_mul()` which must check the type at runtime before doing the operation.

**Real performance numbers:**

```nova
fn dot_fast(a: FastPoint, b: FastPoint) -> float
    a.x * b.x + a.y * b.y
// Compiles to: 2x fmul + 1x fadd → 3 CPU instructions
// Time for 1M calls: ~2ms

fn dot_slow(a: SlowPoint, b: SlowPoint) -> float
    a.x * b.x + a.y * b.y
// Compiles to: 2x call nova_rt_mul + 1x call nova_rt_add → 3 function calls with type checks
// Time for 1M calls: ~300ms

// That is a 150x difference for the SAME algorithm
```

If you are writing a physics simulation at 60fps with 10,000 particles, `FastPoint` gives you 16ms per frame (smooth). `SlowPoint` gives you 2,400ms per frame (0.4 fps — a slideshow).

**The complete list of lowercase type names:**
- `int` — 64-bit integer
- `float` — 64-bit float
- `string` — UTF-8 string
- `bool` — boolean
- `list` — list/array

> **DO:** Always use lowercase type names in struct fields: `x: float`, `name: string`, `count: int`.
> **DON'T:** Ever use capital type names in struct fields: `x: Float`, `name: String`, `count: Int`. This is the #1 performance mistake in NOVA.

### Constructing a struct

To create a value of a struct type, write the type name followed by `{ }` with all field values:

```nova
p = Point { x: 3.0, y: 4.0 }
u = User { name: "Alice", age: 30, email: "alice@example.com" }
```

**Line-by-line breakdown:**

- `p = Point { x: 3.0, y: 4.0 }` — Creates a new `Point` value with `x` set to `3.0` and `y` set to `4.0`. The field names (`x:`, `y:`) must match the ones you declared in `type Point`. The value is stored in the variable `p`.
- `u = User { name: "Alice", age: 30, email: "alice@example.com" }` — Creates a `User` with all three fields. Every field must be provided — you cannot leave any out. This prevents the bug where you create a User with no email and then crash later when you try to use `u.email`.

**What NOT to do:**

```nova
// ERROR: missing field — every field must be provided
p = Point { x: 3.0 }
// Compiler error: missing field 'y' in Point construction

// ERROR: extra field that does not exist in the type
p = Point { x: 3.0, y: 4.0, z: 5.0 }
// Compiler error: unknown field 'z' in Point

// ERROR: wrong field type
p = Point { x: "hello", y: 4.0 }
// Compiler error: expected float for field 'x', got string
```

### Accessing fields

Use dot notation to read any field of a struct:

```nova
p = Point { x: 3.0, y: 4.0 }
print(p.x)      // 3.0
print(p.y)      // 4.0
```

- `p.x` — Reads the `x` field of the struct stored in `p`. Returns `3.0`.
- `p.y` — Reads the `y` field. Returns `4.0`.

### Mutating fields

Structs are mutable — you can change field values after construction:

```nova
p = Point { x: 3.0, y: 4.0 }
p.x = 5.0
print(p.x)      // 5.0
```

### Methods

Methods are functions that belong to a struct type. They let you call functions using dot notation on a struct value, like `circle.area()`. In many languages you define methods inside the class body. In NOVA, you define them as standalone functions with the `Type.` prefix before the method name:

```nova
type Circle
    radius: float

fn Circle.area() -> float
    3.14159 * self.radius * self.radius

fn Circle.circumference() -> float
    2.0 * 3.14159 * self.radius

fn Circle.scale(factor: float) -> Circle
    Circle { radius: self.radius * factor }

c = Circle { radius: 5.0 }
print(c.area())            // 78.53975
print(c.circumference())   // 31.4159
big = c.scale(2.0)
print(big.area())          // 314.159
```

**Line-by-line breakdown:**

- `type Circle` / `    radius: float` — Declares a struct type `Circle` with one field `radius` of type `float` (lowercase — important for performance, as explained above).
- `fn Circle.area() -> float` — Declares a method called `area` on the `Circle` type. The `Circle.` prefix tells NOVA that this method belongs to `Circle`. The `-> float` specifies the return type. Inside this method, the special variable `self` automatically refers to the `Circle` instance the method was called on.
- `    3.14159 * self.radius * self.radius` — Computes the area using pi * r². `self.radius` reads the `radius` field of whichever `Circle` instance this method was called on. The result is the return value (last expression = implicit return).
- `fn Circle.circumference() -> float` — Another method on `Circle`. Uses `self.radius` to access the instance's data.
- `fn Circle.scale(factor: float) -> Circle` — A method that takes an additional parameter `factor`. Methods can have parameters beyond `self`. This method returns a NEW `Circle` with the radius scaled by the factor — it does NOT modify the original.
- `c = Circle { radius: 5.0 }` — Creates a `Circle` instance.
- `c.area()` — Calls the `area` method on `c`. Inside the method, `self` is `c`, so `self.radius` is `5.0`.
- `big = c.scale(2.0)` — Calls `scale` with `factor = 2.0`. Returns a new `Circle` with `radius: 10.0`. The original `c` is unchanged (its `radius` is still `5.0`).

**The key concept: `self`**

Inside any method, `self` refers to the instance the method was called on. You do NOT declare `self` as a parameter — NOVA adds it automatically. This is different from Python (where you must write `def area(self):`), but similar to Rust and Go.

**Comparison to other languages:**

| Language | How methods work |
|----------|-----------------|
| NOVA | `fn Circle.area() -> float` — prefix with type name, `self` is implicit |
| Python | `def area(self): return ...` — inside `class Circle:`, `self` is an explicit parameter |
| Rust | `impl Circle { fn area(&self) -> f64 { ... } }` — inside an `impl` block |
| Go | `func (c Circle) area() float64 { ... }` — receiver before function name |
| Java | `double area() { return ...; }` — inside `class Circle { }` |

> **DO:** Define methods as `fn Type.method_name()` — outside the struct body.
> **DON'T:** Try to put methods inside the `type` block — that is only for field declarations.

### Structs as values

When you assign a struct to another variable or pass it to a function, NOVA makes a copy by default for simple structs:

```nova
a = Point { x: 1.0, y: 2.0 }
b = a              // b is a copy of a
b.x = 99.0
print(a.x)         // 1.0 — a is unchanged
print(b.x)         // 99.0
```

### Structs containing structs

Structs can contain other structs as fields:

```nova
type Line
    start: Point
    end_pt: Point

fn Line.length() -> float
    dx = self.end_pt.x - self.start.x
    dy = self.end_pt.y - self.start.y
    sqrt(dx * dx + dy * dy)

line = Line {
    start: Point { x: 0.0, y: 0.0 },
    end_pt: Point { x: 3.0, y: 4.0 }
}
print(line.length())    // 5.0
```

### Automatic string conversion

When you pass a struct to `print()` or `str()`, NOVA automatically renders it structurally — no `toString()` method needed:

```nova
p = Point { x: 3.0, y: 4.0 }
print(p)    // Point{x: 3.0, y: 4.0}
```

This works for any struct, no matter how deeply nested. You never need to write a custom display method for debugging purposes.

### Traits

A trait declares a set of methods that a type must implement. Any type that provides all the methods satisfies the trait **without explicit declaration** (structural typing):

```nova
trait Shape
    fn area(self) -> float
    fn name(self) -> string

type Circle
    radius: float

type Rectangle
    width: float
    height: float

fn Circle.area() -> float
    3.14159 * self.radius * self.radius

fn Circle.name() -> string
    "circle"

fn Rectangle.area() -> float
    self.width * self.height

fn Rectangle.name() -> string
    "rectangle"

// A function that accepts any Shape
fn describe(s: Shape) -> string
    "{s.name()} with area {s.area()}"

c = Circle { radius: 5.0 }
r = Rectangle { width: 4.0, height: 6.0 }
print(describe(c))   // circle with area 78.53975
print(describe(r))   // rectangle with area 24.0
```

**How traits differ from interfaces in other languages:**
- **Go interfaces:** Similar — structural typing, no `implements` keyword. But Go interfaces can only have methods, NOVA traits can also specify associated types (future feature).
- **Rust traits:** Rust requires `impl Shape for Circle` — NOVA does not. If the methods exist, the type satisfies the trait automatically.
- **Java interfaces:** Java requires `class Circle implements Shape` — explicit declaration. NOVA's approach means you can make a type satisfy a trait that was defined in a completely different module, without modifying the type's source code.

> **DO:** Use traits to define shared behavior across multiple types. The function `fn describe(s: Shape)` works with ANY type that has `area()` and `name()` methods.
> **DON'T:** Create a "base struct" and try to inherit from it — NOVA does not have inheritance. Use traits for polymorphism.

---

## 7. Enums

### What is an enum?

An enum (short for "enumeration") is a type that can be one of several **variants**. Unlike a struct where every value has the same fields, an enum value is one of several different "shapes." Think of it like a form that has checkboxes — you check exactly ONE box, and depending on which box you check, different fields are relevant.

**Real-world example:** A payment method could be:
- A credit card (with a card number and expiration date)
- A bank transfer (with an account number)
- Cash (no extra data needed)

Each of these is a different "variant" with different data. In Python or JavaScript, you would use a dictionary with a "type" key and conditional checks. In NOVA, you use an enum, and the compiler ensures you handle every variant correctly.

NOVA's enums are equivalent to Rust's enums, Haskell's algebraic data types (ADTs), or Swift's enums with associated values. They are NOT like Java/C/C++ enums (which are just named integers with no data).

### Declaring an enum

```nova
enum Color
    Red()
    Green()
    Blue()

enum Shape
    Circle(radius: float)
    Rectangle(width: float, height: float)
    Triangle(base: float, height: float)
```

**Line-by-line breakdown:**

- `enum Color` — Declares a new enum type called `Color`. A `Color` value can be one of the variants listed below.
- `    Red()` — A variant called `Red` with no data (the empty parentheses mean "no fields"). This is called a "unit variant."
- `    Green()` — Another unit variant. A `Color` value is either `Red()`, `Green()`, or `Blue()` — nothing else.
- `enum Shape` — Declares another enum type called `Shape`.
- `    Circle(radius: float)` — A variant called `Circle` that carries one piece of data: a `radius` field of type `float`. When you create a `Circle`, you must provide the radius.
- `    Rectangle(width: float, height: float)` — A variant that carries TWO pieces of data: `width` and `height`. Different variants can carry different amounts and types of data.
- `    Triangle(base: float, height: float)` — Another variant with its own data.

The key insight: `Shape` is ONE type, but a `Shape` value can be any of three different "shapes" — a circle (with a radius), a rectangle (with width and height), or a triangle (with base and height). The compiler tracks which variant each value is and ensures you handle all possibilities.

Unit variants (no data) use empty parentheses: `Red()`. Variants with data list their fields inside parentheses with names and types.

### Constructing enum values

To create an enum value, use the variant name like a function call:

```nova
c = Red()
s1 = Circle(5.0)
s2 = Rectangle(4.0, 6.0)
```

**Line-by-line breakdown:**

- `c = Red()` — Creates a `Color` value of the `Red` variant. The `()` is needed even though `Red` has no data — it distinguishes creating a value from just naming a type.
- `s1 = Circle(5.0)` — Creates a `Shape` value of the `Circle` variant with `radius = 5.0`. You pass the fields positionally (in the order they were declared).
- `s2 = Rectangle(4.0, 6.0)` — Creates a `Rectangle` variant with `width = 4.0` and `height = 6.0`.

You can also use named-field construction for clarity:

```nova
s3 = Circle { radius: 3.0 }
```

Both forms create exactly the same value. Named-field construction is more readable when variants have many fields.

### Pattern matching on enums

Since an enum value can be one of several variants, you need a way to figure out WHICH variant it is and extract its data. This is what `match` does. Match looks at the value, checks which variant it is, extracts the data, and runs the corresponding code:

```nova
fn area(shape)
    match shape
        Circle(r) => 3.14159 * r * r
        Rectangle(w, h) => w * h
        Triangle(b, h) => 0.5 * b * h
        _ => 0.0

print(area(Circle(5.0)))         // 78.53975
print(area(Rectangle(4.0, 6.0))) // 24.0
print(area(Triangle(3.0, 8.0)))  // 12.0
```

**Line-by-line breakdown:**

- `fn area(shape)` — A function that takes a `shape` parameter. The compiler knows it is a `Shape` enum because of how it is used in the `match` below.
- `match shape` — Examines the value in `shape` and checks it against each pattern below. Only one pattern will match, and its code runs.
- `Circle(r) => 3.14159 * r * r` — If `shape` is the `Circle` variant, extract its `radius` field into a local variable called `r`, then compute pi * r². The variable name `r` is chosen by you — you could call it `radius` or anything else.
- `Rectangle(w, h) => w * h` — If `shape` is a `Rectangle`, extract the width into `w` and height into `h`, then compute the area.
- `Triangle(b, h) => 0.5 * b * h` — If `shape` is a `Triangle`, extract base and height, compute the area.
- `_ => 0.0` — The wildcard `_` matches anything not already matched. It is the "default" or "catch-all" case. This handles any variant you did not explicitly list.
- `print(area(Circle(5.0)))` — Creates a `Circle` with radius `5.0`, passes it to `area`, which matches the `Circle(r)` arm with `r = 5.0`, computes `3.14159 * 25.0 = 78.53975`.

**What NOT to do:**

```nova
// DON'T try to access enum fields with dot notation — it will not work
s = Circle(5.0)
print(s.radius)     // ERROR — use match instead

// DO use match to extract the data
match s
    Circle(r) => print(r)    // 5.0
```

Enums are not structs. You cannot access their fields with `.` notation. You MUST use `match` to extract the data. This is by design — since an enum can be any variant, the compiler needs you to explicitly handle the possibility that the value might not be the variant you expect.

### When to use enums vs structs

**Use enums when** a value can be one of several distinct "shapes" with different data:
- A network response is either `Success(data)` or `Failure(code, message)`
- A UI event is either `Click(x, y)` or `KeyPress(key)` or `Scroll(direction, amount)`
- A configuration option is either `Text(s)` or `Number(n)` or `Flag(b)`

**Use structs when** every value has the same set of fields:
- A point always has `x` and `y`
- A user always has `name`, `age`, and `email`

### Real-world example: parsing result

```nova
enum ParseResult
    Success(value: int)
    Failure(message: string)

fn parse_int_strict(s: string) -> ParseResult
    if len(s) == 0
        return Failure("empty string")
    n = int(s)
    if n == 0 and s != "0"
        return Failure("not a number: {s}")
    Success(n)

r = parse_int_strict("42")
match r
    Success(n) => print("parsed: {n}")
    Failure(msg) => print("error: {msg}")
// Output: parsed: 42

r2 = parse_int_strict("abc")
match r2
    Success(n) => print("parsed: {n}")
    Failure(msg) => print("error: {msg}")
// Output: error: not a number: abc
```

> **DO:** Use enums when a value can be one of several different "shapes" with different data. Enum + match is the correct pattern for representing states, results, and variants.
> **DON'T:** Use a dict with a "type" key and conditional field checking to simulate sum types — that is the Python/JavaScript workaround that NOVA's enum system makes unnecessary.

---

## 8. Pattern matching

### What is pattern matching?

Pattern matching is a way to check what "shape" a value has and extract data from it at the same time. Think of it as a super-powered `if/else if` chain that can also pull apart data structures. It is one of the most useful features in NOVA and comes from functional programming languages like Haskell and ML (Meta Language).

`match` tests a value against a series of **patterns** and runs the code for the first pattern that matches. Each pattern can be a literal value, a variable name (which captures the value), an enum variant (which extracts its fields), or a wildcard `_` (which matches anything).

### Basic match

```nova
x = 3
match x
    1 => print("one")
    2 => print("two")
    3 => print("three")
    _ => print("other")
// Output: three
```

**Line-by-line breakdown:**

- `match x` — Start matching on the value of `x` (which is `3`).
- `1 => print("one")` — A **match arm**. The left side (`1`) is the pattern. The `=>` arrow separates the pattern from the code to run. The right side (`print("one")`) is the body. This arm asks: "is `x` equal to `1`?" Since `x` is `3`, this arm does NOT match, so NOVA moves to the next arm.
- `2 => print("two")` — "Is `x` equal to `2`?" No. Move to the next arm.
- `3 => print("three")` — "Is `x` equal to `3`?" YES. Run the body: print `"three"`. Once an arm matches, NOVA stops checking the remaining arms.
- `_ => print("other")` — The **wildcard pattern** `_` matches any value. It is the "default" or "else" case. Since `3` already matched above, this arm is never reached. But if `x` were `99`, none of the number arms would match, and this wildcard arm would run.

**What NOT to do:**

```nova
// DON'T forget the wildcard — if no arm matches and there is no _,
// the match silently returns null, which may cause confusing bugs later
match x
    1 => "one"
    2 => "two"
// If x is 5, this returns null — no arm matched

// DO always include a _ wildcard or ensure all cases are covered
match x
    1 => "one"
    2 => "two"
    _ => "other"
// Now x = 5 returns "other" instead of null
```

### match is an expression

`match` is not just a statement — it is an **expression** that evaluates to a value. This means you can use it on the right side of `=` to assign a value:

```nova
day = "Monday"
mood = match day
    "Monday" => "terrible"
    "Friday" => "great"
    "Saturday" => "amazing"
    _ => "okay"
print(mood)    // terrible
```

**Line-by-line breakdown:**

- `mood = match day` — The entire `match` evaluates to a value, which is stored in `mood`. Whichever arm matches, its right-hand side becomes the value of the whole `match` expression.
- `"Monday" => "terrible"` — `day` is `"Monday"`, so this arm matches. The match expression evaluates to `"terrible"`, which gets assigned to `mood`.

This is much cleaner than an `if/else if/else` chain with repeated `mood = ...` assignments.

### Guards — adding conditions to patterns

Sometimes a pattern alone is not enough. Guards let you add an `if` condition to a match arm. The arm only matches if BOTH the pattern matches AND the guard condition is true:

```nova
fn classify(n)
    match n
        x if x < 0 => "negative"
        0 => "zero"
        x if x <= 10 => "small positive"
        x if x <= 100 => "medium"
        _ => "large"

print(classify(-5))     // negative
print(classify(0))      // zero
print(classify(7))      // small positive
print(classify(50))     // medium
print(classify(999))    // large
```

**Line-by-line breakdown:**

- `x if x < 0 => "negative"` — The pattern `x` matches any value and binds it to the variable `x`. Then the guard `if x < 0` checks whether `x` is negative. If BOTH the pattern matches (always does, since `x` matches anything) AND the guard is true (the value is less than 0), this arm runs.
- `0 => "zero"` — A literal pattern with no guard. Only matches if `n` is exactly `0`.
- `x if x <= 10 => "small positive"` — Matches any value between 1 and 10 (values below 0 and 0 itself were caught by earlier arms, and arms are checked top-to-bottom, so by the time we reach this arm, we know `n >= 1`).
- `_ => "large"` — Wildcard catches everything above 100.

**Important: match arms are checked top to bottom.** The first matching arm wins. If you put `_ => "large"` first, it would match everything and none of the other arms would ever run.

### FizzBuzz with match and guards

```nova
for i in 1..20
    result = match i
        n if n % 15 == 0 => "FizzBuzz"
        n if n % 3 == 0 => "Fizz"
        n if n % 5 == 0 => "Buzz"
        n => str(n)
    print(result)
```

### Matching enums with destructuring

```nova
enum Expr
    Num(value: float)
    Add(left: Expr, right: Expr)
    Mul(left: Expr, right: Expr)

fn eval(e)
    match e
        Num(v) => v
        Add(l, r) => eval(l) + eval(r)
        Mul(l, r) => eval(l) * eval(r)

// (2 + 3) * 4
expr = Mul(Add(Num(2.0), Num(3.0)), Num(4.0))
print(eval(expr))    // 20.0
```

### Matching Result

The built-in `Result` type uses `Ok(value)` and `Err(message)`:

```nova
fn safe_divide(a, b)
    if b == 0
        return err("division by zero")
    ok(a / b)

match safe_divide(10, 3)
    Ok(v) => print("result: {v}")
    Err(e) => print("error: {e}")
// Output: result: 3
```

### String matching

```nova
fn greet(lang)
    match lang
        "en" => "Hello!"
        "es" => "¡Hola!"
        "fr" => "Bonjour!"
        "de" => "Hallo!"
        "ja" => "こんにちは!"
        _ => "Hi! (unknown language: {lang})"

print(greet("fr"))    // Bonjour!
print(greet("ko"))    // Hi! (unknown language: ko)
```

---

## 9. Error handling

### What is error handling?

When your program encounters a problem — a file does not exist, a network connection fails, a user types "abc" where a number is expected — it needs to handle that problem gracefully instead of crashing. Different languages handle errors differently:

- **Python/Java/JavaScript** use **exceptions** — when something goes wrong, the function "throws" an error that flies up the call stack until something catches it. The problem: you cannot tell which functions might throw just by reading the code. A function that looks simple might throw from any of the 10 functions it calls internally.
- **C** returns error codes (like `-1` or `NULL`) — the problem: it is easy to forget to check the error code, and the successful value and error value share the same return slot, making it ambiguous what `-1` means.
- **Go** returns `(value, error)` pairs — better than C, but verbose: every function call needs three lines of `if err != nil { return err }`.
- **Rust** uses a `Result` type with the `?` operator — the gold standard, and NOVA takes the same approach.

NOVA uses the **Result type**: every function that can fail returns either `Ok(value)` for success or `Err(message)` for failure. This makes errors visible, explicit, and impossible to ignore by accident.

### The Result type

```nova
fn parse_port(s: string) -> Result
    n = int(s)
    if n <= 0 or n > 65535
        return err("port must be 1-65535, got {n}")
    ok(n)

r = parse_port("8080")
print(is_ok(r))        // true
print(unwrap(r))       // 8080

r2 = parse_port("99999")
print(is_err(r2))      // true
print(unwrap_err(r2))  // port must be 1-65535, got 99999
```

**Line-by-line breakdown:**

- `fn parse_port(s: string) -> Result` — Declares a function that takes a string and returns a `Result`. The `-> Result` return type tells the caller: "this function might fail — you need to handle both the success and failure cases."
- `n = int(s)` — Converts the string to an integer. If `s` is `"8080"`, then `n` is `8080`.
- `if n <= 0 or n > 65535` — Checks whether the number is a valid port (ports range from 1 to 65535). If not valid, we return an error.
- `return err("port must be 1-65535, got {n}")` — Creates an `Err` result with a descriptive message and returns it immediately. The function exits here — the `ok(n)` line below is not reached.
- `ok(n)` — If we get here (the port is valid), create an `Ok` result wrapping the valid port number. This is the last expression in the function, so it is the return value.
- `r = parse_port("8080")` — Calls the function with a valid port. `r` is now `Ok(8080)`.
- `is_ok(r)` — Returns `true` because `r` is an `Ok` result.
- `unwrap(r)` — Extracts the value from an `Ok` result. Returns `8080`. **Warning:** if `r` were an `Err`, `unwrap` would crash your program! Only use `unwrap` when you have already checked `is_ok`.
- `r2 = parse_port("99999")` — Calls the function with an invalid port. `r2` is now `Err("port must be 1-65535, got 99999")`.
- `is_err(r2)` — Returns `true` because `r2` is an `Err` result.
- `unwrap_err(r2)` — Extracts the error message from an `Err` result. Returns `"port must be 1-65535, got 99999"`.

### Complete list of Result functions

| Function | What it does | Example |
|----------|-------------|---------|
| `ok(value)` | Create a success result | `ok(42)` → `Ok(42)` |
| `err(message)` | Create an error result | `err("failed")` → `Err(failed)` |
| `is_ok(result)` | Check if result is success | `is_ok(ok(42))` → `true` |
| `is_err(result)` | Check if result is error | `is_err(err("x"))` → `true` |
| `unwrap(result)` | Get value from Ok (crashes on Err!) | `unwrap(ok(42))` → `42` |
| `unwrap_err(result)` | Get message from Err | `unwrap_err(err("x"))` → `"x"` |
| `unwrap_or(result, default)` | Get value from Ok, or use default | `unwrap_or(err("x"), 0)` → `0` |

**Why not exceptions?** Exceptions have two problems:
1. **Invisible control flow** — you cannot see which functions throw just by reading the code. In Java, a method that calls 5 other methods could throw from any of them, and the only way to know is to read the documentation (which is often wrong or missing).
2. **Performance** — exception handling requires stack unwinding, which is slow. A `try/catch` in a hot loop can be 100x slower than a return-value check.

NOVA's `Result` makes errors visible at every call site. You see exactly where errors can occur and you handle them explicitly. There are no hidden surprises.

### try: propagating errors

When you are writing a function that calls several other functions that might fail, you do not want to `match` on every single one. The `try` keyword does the tedious part for you — it unwraps an `Ok` value automatically, or immediately returns the `Err` from your function if something fails:

```nova
fn load_config(path: string) -> Result
    content = try read_file(path)           // if read_file fails, return its error
    lines = split(content, "\n")
    if len(lines) == 0
        return err("empty config file")
    ok(lines)
```

**Line-by-line breakdown:**

- `fn load_config(path: string) -> Result` — This function returns a `Result` because it can fail (the file might not exist, or the file might be empty).
- `content = try read_file(path)` — This is the key line. `read_file(path)` returns a `Result`. The `try` keyword does two things:
  - If `read_file` returns `Ok("file contents...")`, `try` unwraps the `Ok` and assigns `"file contents..."` to `content`. Execution continues to the next line.
  - If `read_file` returns `Err("file not found")`, `try` immediately returns that `Err` from `load_config`. The lines below are never executed. The error "bubbles up" to whoever called `load_config`.
- `lines = split(content, "\n")` — This line only runs if `read_file` succeeded. It splits the file content into lines.
- `if len(lines) == 0` / `return err("empty config file")` — We add our own error: even though the file existed, if it is empty, that is also an error.
- `ok(lines)` — If we get here, everything succeeded. Return the lines wrapped in `Ok`.

**Without `try`, the same function would look like this:**

```nova
fn load_config_verbose(path: string) -> Result
    file_result = read_file(path)
    if is_err(file_result)
        return file_result                  // manually propagate the error
    content = unwrap(file_result)
    lines = split(content, "\n")
    if len(lines) == 0
        return err("empty config file")
    ok(lines)
```

`try` saves you from writing those 3 lines of boilerplate for every function call that might fail. This is NOVA's equivalent of Rust's `?` operator, and it is much shorter than Go's `if err != nil { return err }` pattern.

### Never panic on user input

```nova
// BAD: this will crash if the string is not a valid number
n = int(user_input)

// GOOD: handle the error
result = parse_int_safe(user_input)
match result
    Ok(n) => process(n)
    Err(e) => print("Invalid input: {e}")
```

**Why this matters:** `int("hello")` will panic (crash your program). When the input comes from a user, a file, or a network, you CANNOT trust it. Always use `parse_int_safe()` and `parse_float_safe()` for untrusted input. Use `int()` and `float()` only when you know for certain the string is valid (e.g., you constructed it yourself).

### Building a chain of fallible operations

```nova
fn connect_and_query(host, port, query) -> Result
    conn = try tcp_connect(host, port)
    try tcp_send(conn, query)
    response = try tcp_recv(conn)
    tcp_close(conn)
    ok(response)
```

**Line-by-line breakdown:**

- `conn = try tcp_connect(host, port)` — Try to connect. If the connection fails (host unreachable, port closed), immediately return the error.
- `try tcp_send(conn, query)` — Try to send the query. If sending fails (connection dropped), immediately return the error. Notice we use `try` without assigning to a variable — we just want to ensure the send succeeded.
- `response = try tcp_recv(conn)` — Try to receive the response. If receiving fails, immediately return the error.
- `tcp_close(conn)` — Close the connection. This does not use `try` because we do not care if closing fails.
- `ok(response)` — If all three `try` operations succeeded, wrap the response in `Ok` and return it.

This reads top-to-bottom like the happy path. If any step fails, the function returns the error immediately. No nested `if/else` chains, no indentation explosion, no hidden control flow.

### Providing fallback values

```nova
// unwrap_or: provide a default if the result is an error
port = unwrap_or(parse_port(input), 8080)

// match: different behavior for success vs failure
match read_file("config.toml")
    Ok(content) => parse_config(content)
    Err(e) =>
        print("Using defaults: {e}")
        default_config()
```

> **DO:** Use `try` to propagate errors up the call stack. Use `match` when you need different behavior for success vs failure. Use `unwrap_or` when you have a sensible default.
> **DON'T:** Call `unwrap()` on a Result without checking `is_ok()` first — if the Result is an Err, `unwrap()` will panic.

---

## 10. Collections

NOVA has several built-in collection types beyond lists and dicts.

### Lists (recap with complete API)

```nova
nums = [3, 1, 4, 1, 5, 9, 2, 6]

// Access
print(nums[0])        // 3 (first)
print(nums[-1])       // 6 (last)
print(nums[-2])       // 2 (second to last)
print(len(nums))      // 8

// Modify
push(nums, 7)         // append to end → [3, 1, 4, 1, 5, 9, 2, 6, 7]
last = pop(nums)      // remove and return last → 7
insert(nums, 0, 99)   // insert 99 at index 0 → [99, 3, 1, 4, 1, 5, 9, 2, 6]
remove(nums, 99)      // remove first occurrence of 99
remove_at(nums, 0)    // remove element at index 0

// Search
print(5 in nums)          // true
print(contains(nums, 5))  // true (same as `in`)
print(find("hello world", "world"))  // 6 (index of first match)

// Sort and reverse
sort(nums)            // sort in place → [1, 1, 2, 3, 4, 5, 6, 9]
reverse(nums)         // reverse in place → [9, 6, 5, 4, 3, 2, 1, 1]

// Slice (creates a new list, does not modify original)
sub = nums[1:4]       // elements at index 1, 2, 3 → [6, 5, 4]

// Concatenate
a = [1, 2, 3]
b = [4, 5, 6]
c = a + b             // [1, 2, 3, 4, 5, 6]

// Join into string
words = ["hello", "world"]
print(join(words, " "))     // hello world
print(join(words, ", "))    // hello, world
```

### Functional list operations

```nova
nums = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

// map: apply a function to each element, return new list
squares = map(nums, x => x * x)
print(squares)   // [1, 4, 9, 16, 25, 36, 49, 64, 81, 100]

// filter: keep elements where the function returns true
evens = filter(nums, x => x % 2 == 0)
print(evens)     // [2, 4, 6, 8, 10]

// reduce: fold all elements into a single value
total = reduce(nums, 0, (acc, x) => acc + x)
print(total)     // 55

// sum / sum_f: shortcut for numeric reduce
print(sum(nums))       // 55 (integer sum)

// all / any: test a condition across all elements
print(all_match(nums, x => x > 0))     // true (all positive)
print(any_match(nums, x => x > 5))     // true (at least one > 5)
print(all_match(nums, x => x % 2 == 0)) // false (not all even)

// flatten: flatten a list of lists
nested = [[1, 2], [3, 4], [5, 6]]
flat = flatten(nested)
print(flat)      // [1, 2, 3, 4, 5, 6]

// sort_by: sort with a custom comparison
words = ["banana", "apple", "cherry"]
sorted_words = sort_by(words, (a, b) => cmp(len(a), len(b)))
print(sorted_words)   // [apple, banana, cherry] (sorted by length)
```

### Dict operations (complete API)

```nova
d = {"a": 1, "b": 2, "c": 3}

// Access
print(d["a"])              // 1

// Check presence before access
print("a" in d)            // true
print(contains(d, "z"))    // false

// Set / update
d["d"] = 4

// Delete
delete(d, "a")

// Length
print(len(d))              // 3

// Keys and values
ks = keys(d)               // list of all keys
vs = values(d)             // list of all values

// Iterate
for k in keys(d)
    print("{k} -> {d[k]}")

// Merge two dicts (second overwrites first on conflicts)
d1 = {"x": 1, "y": 2}
d2 = {"y": 3, "z": 4}
merged = merge(d1, d2)
print(merged)              // {"x": 1, "y": 3, "z": 4}
```

### String operations (complete API)

```nova
s = "  Hello, World!  "

// Case
print(upper(s))          // "  HELLO, WORLD!  "
print(lower(s))          // "  hello, world!  "

// Trim
print(trim(s))           // "Hello, World!"
print(ltrim(s))          // "Hello, World!  "
print(rstrip(s))         // "  Hello, World!"

// Search
print(find(s, "World"))      // 9
print(find(s, "xyz"))        // -1
print(starts_with(s, "  H")) // true
print(ends_with(s, "!  "))   // true

// Replace
print(replace(s, "World", "NOVA"))  // "  Hello, NOVA!  "

// Split and join
print(split("a,b,c", ","))   // ["a", "b", "c"]
print(join(["x", "y"], "-")) // "x-y"

// Slice (substring)
print(slice("hello world", 6, 11))  // "world"

// Character access
print(char_at("NOVA", 0))     // N
print(char_at("NOVA", -1))    // A

// Character codes
print(ord("A"))     // 65
print(chr(65))      // A

// Repetition and padding
print(repeat("ab", 3))              // ababab
print(pad_left("42", 5, "0"))       // 00042
print(pad_right("hi", 8, "."))      // hi......
print(center("NOVA", 10, "-"))      // ---NOVA---

// Count occurrences
print(str_count("abcabc", "abc"))    // 2

// Type conversions
print(str(42))       // "42"
print(str(3.14))     // "3.14"
print(int("42"))     // 42
print(float("3.14")) // 3.14
```

### Buffer — efficient string building

A `Buffer` is a mutable, growable byte buffer. It is the correct way to build strings in a loop:

```nova
buf = buffer_create()
buf_append(buf, "Hello")
buf_append(buf, " ")
buf_append(buf, "World")
result = buf_to_str(buf)
print(result)           // Hello World
print(buf_len(buf))     // 11

// Clear and reuse
buf_clear(buf)
print(buf_len(buf))     // 0
buf_append(buf, "new content")
print(buf_to_str(buf))  // new content
```

**Why use Buffer instead of string concatenation?**

```nova
// SLOW: O(n²) — each += copies the entire accumulated string
result = ""
i = 0
while i < 1000
    result = result + "x"
    i = i + 1
// Total bytes copied: 1 + 2 + 3 + ... + 1000 = 500,500 bytes

// FAST: O(n) — buffer grows in place, no copying
buf = buffer_create()
i = 0
while i < 1000
    buf_append(buf, "x")
    i = i + 1
result = buf_to_str(buf)
// Total bytes copied: 1000 bytes (just the appends)
```

For 1000 iterations, the buffer is ~500x faster. For 10,000 iterations, it is ~5,000x faster. Always use a buffer when building strings in loops.

> **DO:** Use `buffer_create()` + `buf_append()` + `buf_to_str()` when building strings in loops or from many pieces.
> **DON'T:** Use `result = result + piece` in a loop — it is O(n²) and becomes a visible performance problem above ~100 iterations.

### Sets

Sets are unordered collections of unique elements:

```nova
// Create from a list
s = set_from_list([1, 2, 3, 2, 1])
print(set_len(s))        // 3 (duplicates removed)

// Add elements
set_add(s, 4)
set_add(s, 2)            // already exists — no effect
print(set_len(s))        // 4

// Check membership
print(set_has(s, 3))     // true
print(set_has(s, 99))    // false

// Remove
set_remove(s, 1)
print(set_has(s, 1))     // false

// Convert back to list
items = set_to_list(s)
print(items)             // [2, 3, 4] (order may vary)
```

### Bytes — raw binary data

See [Section 33: Bytes and binary data](#33-bytes-and-binary-data) for the full treatment. Quick preview:

```nova
buf = bytes(10)          // 10 zero bytes
bytes_set(buf, 0, 72)   // H
bytes_set(buf, 1, 101)  // e
bytes_set(buf, 2, 108)  // l
bytes_set(buf, 3, 108)  // l
bytes_set(buf, 4, 111)  // o

text = bytes_to_str(bytes_slice(buf, 0, 5))
print(text)              // Hello

// String to bytes
data = str_to_bytes("NOVA")
print(bytes_get(data, 0))   // 78 (ASCII (American Standard Code for Information Interchange) 'N')
```

---

## 11. Iterators and generators

Iterators are lazy sequences. Unlike lists, which compute and store all elements immediately, iterators produce elements one at a time on demand. This makes them memory-efficient for large or infinite sequences.

### Creating iterators

```nova
// From a list
nums = [10, 20, 30, 40, 50]
it = iter(nums)
result = iter_collect(it)   // collect all into a list
print(result)               // [10, 20, 30, 40, 50]

// From a range
it = iter_range(1, 6)       // 1, 2, 3, 4, 5
result = iter_collect(it)
print(result)               // [1, 2, 3, 4, 5]

// With step
it = iter_range_step(0, 20, 5)   // 0, 5, 10, 15
result = iter_collect(it)
print(result)                    // [0, 5, 10, 15]
```

### Transforming iterators

These operations are lazy — they do not compute anything until you collect:

```nova
// iter_map: transform each element
it = iter_map(iter_range(1, 6), fn(x) x * x)
print(iter_collect(it))    // [1, 4, 9, 16, 25]

// iter_filter: keep matching elements
it = iter_filter(iter_range(1, 11), fn(x) x % 2 == 0)
print(iter_collect(it))    // [2, 4, 6, 8, 10]

// iter_take: take first N elements (great for infinite/huge sequences)
it = iter_take(iter_range(0, 1000000), 5)
print(iter_collect(it))    // [0, 1, 2, 3, 4]  — only computed 5, not a million

// iter_skip: skip first N elements
it = iter_skip(iter_range(0, 10), 7)
print(iter_collect(it))    // [7, 8, 9]

// iter_zip: pair elements from two iterators
a = iter(["a", "b", "c"])
b = iter_range(1, 4)
pairs = iter_collect(iter_zip(a, b))
print(pairs)               // [["a", 1], ["b", 2], ["c", 3]]
```

### Chaining operations — the real power of iterators

The real power of iterators is chaining multiple operations together without creating intermediate lists:

```nova
it = iter_range(1, 21)
it = iter_filter(it, fn(x) x % 3 == 0)   // keep multiples of 3
it = iter_map(it, fn(x) x * 10)           // multiply each by 10
result = iter_collect(it)
print(result)    // [30, 60, 90, 120, 150, 180]
```

**Line-by-line breakdown:**

- `iter_range(1, 21)` — Produces numbers 1 through 20 lazily.
- `iter_filter(it, fn(x) x % 3 == 0)` — Wraps the range iterator with a filter. When an element is requested, the filter pulls from the range, checks `x % 3 == 0`, and passes through only multiples of 3 (3, 6, 9, 12, 15, 18). Other numbers are silently skipped.
- `iter_map(it, fn(x) x * 10)` — Wraps the filter iterator with a map. When an element is requested, it pulls from the filter and multiplies by 10.
- `iter_collect(it)` — Pulls all elements through the entire pipeline and collects them into a list.

**Why this is better than lists:** Without iterators, you would need to create 3 separate lists: one for the range (20 elements), one for the filter result (6 elements), one for the map result (6 elements). With iterators, each element flows through the entire pipeline one at a time — zero intermediate lists, zero wasted memory.

### Reducing iterators — computing a single result

```nova
total = iter_sum(iter_range(1, 101))
print(total)     // 5050

n = iter_count(iter_filter(iter_range(1, 101), fn(x) x % 7 == 0))
print(n)         // 14 (numbers 1-100 divisible by 7)

has_big = iter_any(iter(nums), fn(x) x > 100)
all_pos = iter_all(iter(nums), fn(x) x > 0)
```

**Line-by-line breakdown:**

- `iter_sum(iter_range(1, 101))` — Sums all numbers from 1 to 100. Result: 5050 (the famous Gauss sum). The iterator never creates a 100-element list in memory.
- `iter_count(iter_filter(...))` — Counts how many numbers from 1 to 100 are divisible by 7. The filter passes only multiples of 7, and `iter_count` counts them: 7, 14, 21, 28, 35, 42, 49, 56, 63, 70, 77, 84, 91, 98 = 14 numbers.
- `iter_any(iter(nums), fn(x) x > 100)` — Returns `true` if ANY element is greater than 100. **Short-circuits:** stops as soon as it finds one match.
- `iter_all(iter(nums), fn(x) x > 0)` — Returns `true` only if ALL elements are greater than 0. **Short-circuits:** stops as soon as it finds one that is NOT greater than 0.

### Fibers — cooperative coroutines

Fibers are lightweight coroutines that can suspend and resume execution. They are lower-level than green tasks (see [Concurrency](#17-processes-and-channels)) and useful for implementing generators and state machines:

```nova
fn counter()
    i = 0
    while i < 5
        fiber_yield()   // suspend here, return control to caller
        i = i + 1

f = fiber_create(fn(z) counter())

// Resume the fiber repeatedly
while fiber_is_done(f) == 0
    fiber_resume(f)
print("done")
```

**fiber_resume returns:**
- `0` if the fiber yielded (can be resumed later)
- `1` if the fiber finished (calling resume again is a no-op)

**Fiber vs spawn:**
- `spawn` creates a concurrent task that runs independently on the scheduler
- `fiber_create` creates a cooperative coroutine that only runs when you call `fiber_resume`
- Use `spawn` for concurrent work. Use fibers when you need manual control over execution (state machines, generators, cooperative scheduling).

**Performance:** Context switching between fibers is extremely fast — measured at under 5 microseconds per switch. You can create thousands of fibers.

---

## 12. File I/O (Input/Output) and paths

### What is File I/O?

File I/O (Input/Output) is how programs read data from files on disk and write data back. Every program that saves settings, reads configuration, processes data files, or writes logs needs File I/O.

NOVA provides simple, high-level functions for all file operations. No file handles to manage for basic operations — just `read_file` and `write_file`.

### Reading and writing files

```nova
write_file("hello.txt", "Hello, NOVA!\nSecond line.\n")

content = read_file("hello.txt")
print(content)
// Output:
// Hello, NOVA!
// Second line.

append_file("log.txt", "Event happened at {time_ms()}\n")

if file_exists("hello.txt")
    print("file exists")
```

**Line-by-line breakdown:**

- `write_file("hello.txt", "Hello, NOVA!\nSecond line.\n")` — Creates a file called `hello.txt` and writes the given string to it. If the file already exists, it is **overwritten** (previous contents are lost). The `\n` is a newline character — it creates a line break in the file.
- `read_file("hello.txt")` — Reads the entire file and returns its contents as a single string. If the file does not exist, this returns an error.
- `append_file("log.txt", "Event happened at {time_ms()}\n")` — Adds text to the END of the file without erasing existing contents. If the file does not exist, it creates it. This is perfect for log files where you want to keep adding entries.
- `file_exists("hello.txt")` — Returns `true` if the file exists, `false` otherwise. Always check before reading if the file might not exist.

### File information

```nova
print(file_size("hello.txt"))     // size in bytes (e.g., 27)
print(file_mtime("hello.txt"))    // last modification time (Unix timestamp)
print(is_file("hello.txt"))       // true
print(is_dir("hello.txt"))        // false
```

**Line-by-line breakdown:**

- `file_size("hello.txt")` — Returns the file size in bytes. A file containing "Hello" is 5 bytes.
- `file_mtime("hello.txt")` — Returns the last modification time as a Unix timestamp (seconds since January 1, 1970). Use `datetime_format` to convert it to a human-readable date.
- `is_file("hello.txt")` — Returns `true` if the path points to a regular file (not a directory).
- `is_dir("hello.txt")` — Returns `true` if the path points to a directory.

### Reading line by line — for large files

For large files (megabytes or gigabytes), reading the entire file at once with `read_file` would use too much memory. Instead, read one line at a time:

```nova
f = file_open("large.txt")
loop
    line = file_read_line(f)
    if file_eof(f)
        break
    print(trim(line))
file_close(f)
```

**Line-by-line breakdown:**

- `file_open("large.txt")` — Opens the file and returns a file handle. Unlike `read_file`, this does NOT read the entire file into memory — it just opens a connection to the file.
- `file_read_line(f)` — Reads the next line from the file. Each call advances the file position to the next line.
- `file_eof(f)` — Returns `true` when there are no more lines to read (EOF = End Of File).
- `trim(line)` — Removes the trailing newline character from the line (lines include the `\n` at the end).
- `file_close(f)` — Closes the file handle. Always close files when done — open files consume OS resources.

Or read all lines at once:

```nova
lines = split(read_file("data.txt"), "\n")
for line in lines
    if len(trim(line)) > 0
        process(line)
```

### Binary file operations

```nova
// Write raw bytes
data = str_to_bytes("binary data")
write_bytes("output.bin", data)

// Read raw bytes
raw = read_bytes("output.bin")
print(bytes_len(raw))
```

### Directory operations

```nova
// Create directory
mkdir("mydir")

// Create nested directories (like mkdir -p)
mkdir_p("path/to/nested/dir")

// List directory contents
files = list_dir(".")
for f in files
    print(f)

// Walk directory recursively
fn process_all_nova_files(dir)
    for entry in dir_walk(dir)
        if ends_with(entry, ".nova")
            print("Found: {entry}")

process_all_nova_files(".")

// Check type
print(is_dir("mydir"))    // true
print(is_file("hello.txt")) // true

// Remove
remove_file("hello.txt")
remove_dir("mydir")       // must be empty
```

### Path operations

```nova
// Join path components (uses the correct separator for the OS)
p = path_join("src", "main", "app.nova")
print(p)                  // src/main/app.nova (or src\main\app.nova on Windows)

// Extract parts
print(path_name("src/main/app.nova"))    // app.nova
print(path_parent("src/main/app.nova"))  // src/main
print(path_ext("src/main/app.nova"))     // .nova

// Current directory
print(cwd())

// Find executable in PATH
print(which("git"))       // /usr/bin/git (or wherever it is)
```

### Copy and rename

```nova
copy_file("source.txt", "dest.txt")
rename_path("old_name.txt", "new_name.txt")
```

### Memory-mapped files

For very large files, memory-mapping gives you random access without loading the entire file into memory. The operating system pages data in and out on demand:

```nova
// Create a test file
write_file("data.txt", "hello")

// Memory-map the file
m = mmap_open("data.txt")
print(mmap_len(m))        // 5

// Read individual bytes (bounds-checked)
print(mmap_byte(m, 0))   // 104 (ASCII 'h')
print(mmap_byte(m, 1))   // 101 (ASCII 'e')

// Out-of-bounds reads are safe — they return -1 instead of crashing
print(mmap_byte(m, 999)) // -1

// Always close when done
mmap_close(m)
```

> **DO:** Use `read_file`/`write_file` for small files. Use `file_open`/`file_read_line` for large files. Use `mmap_open` for random access to very large files.
> **DON'T:** Read a 2GB file with `read_file()` — it will try to load the entire file into memory at once. Use line-by-line reading or mmap instead.

---

## 13. Regular expressions (regex)

### What are regular expressions?

A regular expression (regex) is a pattern that describes a set of strings. Instead of looking for an exact string like `"hello"`, you can look for a PATTERN like "any word followed by a number" or "a valid email address."

Regular expressions are used everywhere in programming:
- **Validation** — Is this a valid email? A valid phone number? A valid credit card?
- **Search** — Find all dates in a document. Find all URLs in a web page.
- **Replace** — Replace all phone numbers with `[REDACTED]`. Fix formatting.
- **Parsing** — Extract data from log files, CSV data, or unstructured text.

NOVA has built-in regex support via the `matches` keyword and `regex_*` functions.

### The `matches` keyword — testing patterns

The `matches` keyword tests if a string matches a regex pattern:

```nova
// Basic matching
print("hello123" matches "\\d+")     // true (contains digits)
print("hello" matches "\\d+")        // false (no digits)
print("hello world" matches "world") // true (literal match)

// Anchored matching (^ = start, $ = end)
print("2024" matches "^\\d+$")       // true (entire string is digits)
print("hi2024" matches "^\\d+$")     // false (doesn't start with digit)
```

### Pattern syntax

NOVA uses standard regex syntax:

| Pattern | Meaning | Example |
|---------|---------|---------|
| `.` | Any character | `"a.c"` matches `"abc"`, `"aXc"` |
| `\d` | Digit (0-9) | `"\\d+"` matches `"42"` |
| `\w` | Word character (letter, digit, _) | `"\\w+"` matches `"hello_42"` |
| `\s` | Whitespace | `"\\s+"` matches `"  "` |
| `*` | Zero or more | `"ab*c"` matches `"ac"`, `"abc"`, `"abbc"` |
| `+` | One or more | `"ab+c"` matches `"abc"` but not `"ac"` |
| `?` | Zero or one | `"ab?c"` matches `"ac"` and `"abc"` |
| `[abc]` | Character class | `"[abc]at"` matches `"cat"`, `"bat"` |
| `^` | Start of string | `"^hello"` matches `"hello world"` |
| `$` | End of string | `"world$"` matches `"hello world"` |

**Important:** Backslashes in regex patterns must be doubled because `\` is also a string escape character. Write `"\\d+"` not `"\d+"`.

### regex_find — extract first match

```nova
// Find the first match of a pattern
result = regex_find("price is 42 dollars", "\\d+")
print(result)     // 42

// Returns empty string if no match
empty = regex_find("no numbers here", "\\d+")
print(empty)      // (empty string)
```

### regex_replace — replace matches

```nova
// Replace first match
print(regex_replace("hello world", "world", "NOVA"))
// Output: hello NOVA

// Replace pattern
print(regex_replace("foo123bar", "\\d+", "NUM"))
// Output: fooNUMbar
```

### regex_split — split by pattern

```nova
// Split by literal
parts = regex_split("one:two:three", ":")
print(parts)      // ["one", "two", "three"]

// Split by pattern
parts = regex_split("a1b2c3d", "\\d")
print(parts)      // ["a", "b", "c", "d"]
```

### Real-world examples

```nova
// Validate email (basic)
fn is_email(s)
    s matches "^[\\w.+-]+@[\\w-]+\\.[\\w.]+$"

print(is_email("user@example.com"))   // true
print(is_email("not-an-email"))       // false

// Extract all numbers from text
fn extract_numbers(text)
    // Split on non-digit runs, filter empty strings
    parts = regex_split(text, "[^\\d]+")
    filter(parts, s => len(s) > 0)

nums = extract_numbers("There are 3 cats and 12 dogs in 2 houses")
print(nums)   // ["3", "12", "2"]

// Sanitize input — remove non-alphanumeric
fn sanitize(s)
    regex_replace(s, "[^a-zA-Z0-9 ]", "")

print(sanitize("Hello! @#$ World <script>"))  // Hello  World script
```

> **DO:** Remember to double-escape backslashes: `"\\d+"` not `"\d+"`.
> **DON'T:** Use regex for simple operations like `find()`, `starts_with()`, `replace()` — the string builtins are faster for literal matching.

---

## 14. JSON (JavaScript Object Notation) processing

### What is JSON?

JSON (JavaScript Object Notation) is the most common data format for exchanging information between programs, APIs (Application Programming Interfaces), and services on the internet. It looks like this: `{"name": "Alice", "age": 30}`. Almost every web API (Application Programming Interface) sends and receives JSON.

NOVA has built-in JSON encoding (converting NOVA values to JSON text) and decoding (converting JSON text to NOVA values). No imports are needed — these functions are always available.

### Encoding to JSON

"Encoding" means converting a NOVA value (a number, string, list, dict, etc.) into a JSON-formatted string:

```nova
print(json_encode(42))            // 42
print(json_encode("hello"))       // "hello"
print(json_encode(true))          // true
print(json_encode([1, 2, 3]))     // [1,2,3]
print(json_encode({"a": 1}))      // {"a":1}
```

**Line-by-line breakdown:**

- `json_encode(42)` — Converts the integer `42` to the JSON string `"42"`. In JSON, numbers look the same as in NOVA.
- `json_encode("hello")` — Converts the string `"hello"` to `"\"hello\""` — a JSON string is wrapped in double quotes.
- `json_encode(true)` — Booleans become `true` or `false` in JSON (lowercase, same as NOVA).
- `json_encode([1, 2, 3])` — Lists become JSON arrays: `[1,2,3]`.
- `json_encode({"a": 1})` — Dicts become JSON objects: `{"a":1}`.

### Decoding from JSON

"Decoding" means converting a JSON-formatted string back into a NOVA value you can work with:

```nova
data = json_decode("{\"name\": \"Alice\", \"age\": 30}")
print(data["name"])    // Alice
print(data["age"])     // 30

list_data = json_decode("[1, 2, 3]")
print(list_data[1])    // 2
```

**Line-by-line breakdown:**

- `json_decode("{\"name\": \"Alice\", \"age\": 30}")` — Parses the JSON string into a NOVA dict. The `\"` inside the string are escaped double quotes (because the string itself is wrapped in `"`). The result is a dict with two keys: `"name"` (value `"Alice"`) and `"age"` (value `30`).
- `data["name"]` — Accesses the value for key `"name"` in the dict. Returns `"Alice"`.
- `data["age"]` — Returns `30`. Note that `json_decode` automatically converts JSON numbers to NOVA integers or floats.
- `json_decode("[1, 2, 3]")` — Parses a JSON array into a NOVA list.
- `list_data[1]` — Accesses index 1 (the second element). Returns `2`.

**What NOT to do:**

```nova
// DON'T try to decode invalid JSON — it will return an error
result = json_decode("not valid json")
// result will be an Err — always check with is_ok() for untrusted input

// DON'T build JSON by string concatenation — this breaks on special characters
name = "Alice \"Bob\" Carol"
bad_json = "{\"name\": \"" + name + "\"}"
// BROKEN — the quotes inside name corrupt the JSON

// DO use json_encode to build JSON safely
good_json = json_encode({"name": name})
// CORRECT — json_encode escapes special characters automatically
```

### Struct to/from JSON

NOVA structs automatically convert to JSON using `to_json()`. The compiler uses RTTI (Runtime Type Information) to enumerate every field and its value, so you never need to write serialization code:

```nova
import forge

type User
    name: string
    age: int
    email: string

u = User { name: "Alice", age: 30, email: "alice@example.com" }
print(to_json(u))
// Output: {"name":"Alice","age":30,"email":"alice@example.com"}
```

**Line-by-line breakdown:**

- `import forge` — The `to_json()` function is part of the Forge module. Import it to use struct-to-JSON conversion.
- `type User` — Declares a struct with three fields.
- `u = User { name: "Alice", age: 30, email: "alice@example.com" }` — Creates a User value.
- `to_json(u)` — Automatically converts the struct to a JSON string. Each field becomes a key-value pair. Strings become JSON strings, integers become JSON numbers. This works for ANY struct — nested structs, structs containing lists, structs containing other structs — all handled automatically.

**Why this is special:** In most languages, you need to write custom serialization code (Java's `@JsonProperty`, Python's `json.dumps(obj.__dict__)`, Go's `json.Marshal`). In NOVA, the compiler knows the struct's fields and types, so `to_json()` just works.

### Reading a JSON file

A common task — reading a configuration file:

```nova
config = json_decode(read_file("config.json"))
host = config["host"]
port = int(config["port"])
print("Connecting to {host}:{port}")
```

**Line-by-line breakdown:**

- `read_file("config.json")` — Reads the entire file as a string.
- `json_decode(...)` — Parses the JSON string into a NOVA dict.
- `config["host"]` — Reads the `"host"` key from the parsed dict.
- `int(config["port"])` — JSON numbers may be parsed as strings depending on context; `int()` ensures it is an integer.

### Writing a JSON file

```nova
data = {
    "version": "1.0",
    "debug": false,
    "limits": {"max_conn": 100, "timeout": 30}
}
write_file("config.json", json_encode(data))
```

**Line-by-line breakdown:**

- `data = { ... }` — Creates a nested dict. Dicts can contain other dicts as values — this represents a JSON object with a nested `"limits"` object.
- `json_encode(data)` — Converts the nested dict to a JSON string: `{"version":"1.0","debug":false,"limits":{"max_conn":100,"timeout":30}}`.
- `write_file("config.json", ...)` — Writes the JSON string to a file.

> **DO:** Use `json_encode`/`json_decode` for all JSON work. Use `to_json()` for struct serialization.
> **DON'T:** Build JSON strings manually with string concatenation — you will get burned by special characters, missing quotes, or nested escaping.

---

## 15. Date and time

### What is date/time in programming?

Computers represent time as a single number: the number of seconds (or milliseconds) since **January 1, 1970, 00:00:00 UTC (Coordinated Universal Time)**. This moment is called the "Unix epoch." For example, the number `1719561600` means "June 28, 2024 at 12:00:00 UTC."

This number is called a **timestamp**. All date/time functions work with timestamps, converting between the raw number and human-readable components (year, month, day, hour, etc.).

### Current time

```nova
// Milliseconds since epoch
ms = time_ms()
print(ms)              // 1719561600000 (example)

// Current datetime as formatted string
now = datetime_now()
print(now)             // 2026-06-28 12:00:00 (example)

// Unix timestamp (seconds since epoch)
ts = datetime_timestamp()
print(ts)              // 1719561600 (example)
```

### Extracting components

```nova
ts = datetime_timestamp()
print(datetime_year(ts))      // 2026
print(datetime_month(ts))     // 6
print(datetime_day(ts))       // 28
print(datetime_hour(ts))      // 12
print(datetime_minute(ts))    // 0
print(datetime_second(ts))    // 0
print(datetime_weekday(ts))   // 6 (0=Sunday, 6=Saturday)
```

### Formatting dates

```nova
ts = datetime_timestamp()
print(datetime_format(ts, "%Y/%m/%d"))       // 2026/06/28
print(datetime_format(ts, "%Y-%m-%d %H:%M")) // 2026-06-28 12:00
```

Format specifiers follow the `strftime` convention:
- `%Y` — 4-digit year
- `%m` — 2-digit month (01-12)
- `%d` — 2-digit day (01-31)
- `%H` — 24-hour hour (00-23)
- `%M` — minute (00-59)
- `%S` — second (00-59)

### Parsing dates

```nova
ts = datetime_parse("2025-06-15 12:30:00", "")
print(datetime_year(ts))    // 2025
print(datetime_month(ts))   // 6
print(datetime_day(ts))     // 15
print(datetime_hour(ts))    // 12
print(datetime_minute(ts))  // 30

// ISO (International Organization for Standardization) 8601 format also works
ts2 = datetime_parse("2024-12-25T08:00:00", "")
print(datetime_year(ts2))   // 2024
```

### Date arithmetic

```nova
ts = datetime_parse("2025-06-15 12:00:00", "")

// Add days
next_week = datetime_add_days(ts, 7)
print(datetime_day(next_week))     // 22

// Add hours
later = datetime_add_hours(ts, 3)
print(datetime_hour(later))        // 15

// Difference between two timestamps (in seconds)
ts1 = datetime_parse("2025-06-15 12:00:00", "")
ts2 = datetime_parse("2025-06-16 14:30:00", "")
diff = datetime_diff(ts2, ts1)
print(diff)                        // 95400 (26.5 hours in seconds)
```

### Measuring elapsed time

For benchmarking, use `time_ms()` or `clock_ns()` for nanosecond precision:

```nova
start = time_ms()
// ... do some work ...
elapsed = time_ms() - start
print("Took {elapsed}ms")

// For micro-benchmarks, use nanosecond precision
start = clock_ns()
// ... tight loop ...
elapsed_ns = clock_ns() - start
print("Took {elapsed_ns}ns")
```

---

## 16. Testing and benchmarking

### What is testing?

Testing means writing small programs that verify your code works correctly. Instead of running your program and manually checking the output, you write automated checks that the computer runs for you. If something breaks, the test tells you immediately what went wrong and where.

NOVA has a built-in testing framework — no external library or setup needed. You write tests using `test_run()` and assertions like `assert_eq()`, then call `test_summary()` at the end to see the results.

### Writing tests

```nova
fn main()
    test_run("addition works", fn()
        assert_eq(2 + 3, 5)
    )

    test_run("string length", fn()
        assert_eq(len("hello"), 5)
    )

    test_run("list operations", fn()
        items = [1, 2, 3]
        push(items, 4)
        assert_eq(len(items), 4)
        assert_eq(items[3], 4)
    )

    test_summary()
```

Output:
```
PASS: addition works
PASS: string length
PASS: list operations
3 passed, 0 failed
```

**Line-by-line breakdown:**

- `fn main()` — Tests go inside `main()` so they run when you execute the file.
- `test_run("addition works", fn() ...)` — `test_run` takes two arguments: a **name** for the test (a string that describes what is being tested) and a **closure** (an anonymous function) that contains the test code. If the closure runs without any assertion failures, the test passes. If any assertion fails, the test fails and NOVA prints what went wrong.
- `assert_eq(2 + 3, 5)` — An **assertion**: checks that the first argument equals the second argument. If `2 + 3` equals `5` (which it does), the assertion passes silently. If they were not equal, the test would fail with a message like `FAIL: addition works — expected 5, got 6`.
- `test_run("list operations", fn() ...)` — Another test. This one creates a list, modifies it with `push`, then asserts that the list has the expected length and content. You can have multiple assertions in one test.
- `test_summary()` — **Must be called at the end.** This prints the final report: how many tests passed and how many failed. Without this call, you would not see the summary.

### Assertion functions

Assertions are the building blocks of tests. Each one checks a condition and fails the test if the condition is not met:

```nova
// Equality — the most common assertion
assert_eq(actual, expected)         // fails if actual != expected
// Example: assert_eq(len("hello"), 5)

// Inequality — ensure two values are different
assert_ne(actual, unexpected)       // fails if actual == unexpected
// Example: assert_ne(result, 0) — make sure result is not zero

// Boolean — check if something is true or false
assert_true(condition)              // fails if condition is falsy
// Example: assert_true(is_ok(result))
assert_false(condition)             // fails if condition is truthy
// Example: assert_false(is_empty(list))

// Float comparison — because 0.1 + 0.2 != 0.3 in floating point!
assert_near(actual, expected, tolerance)
// Example: assert_near(0.1 + 0.2, 0.3, 0.0001) — passes (within tolerance)

// Membership — check if a collection contains an element
assert_contains(collection, element)
// Example: assert_contains([1, 2, 3], 2)

// General assertion with a custom error message
assert(condition, "description of what went wrong")
// Example: assert(age >= 0, "age cannot be negative")
```

**When to use which assertion:**

| Situation | Use | Example |
|-----------|-----|---------|
| Comparing two values | `assert_eq` | `assert_eq(result, 42)` |
| Making sure values differ | `assert_ne` | `assert_ne(password, "")` |
| Checking a boolean condition | `assert_true` | `assert_true(is_ok(r))` |
| Comparing floating-point numbers | `assert_near` | `assert_near(pi, 3.14, 0.01)` |
| Checking if item exists in list | `assert_contains` | `assert_contains(names, "Alice")` |

> **DO:** Give each test a descriptive name: `"user login with wrong password returns error"` not `"test 1"`.
> **DON'T:** Forget to call `test_summary()` at the end — without it, you will not see the pass/fail report.

### Testing Results

```nova
fn main()
    test_run("ok result", fn()
        r = ok(42)
        assert_true(is_ok(r))
        assert_eq(unwrap(r), 42)
    )

    test_run("err result", fn()
        r = err("something broke")
        assert_true(is_err(r))
        assert_eq(unwrap_err(r), "something broke")
    )

    test_summary()
```

### Benchmarking

```nova
// Simple timing
N = 100_000
start = time_ms()
i = 0
while i < N
    result = expensive_function(i)
    i = i + 1
elapsed = time_ms() - start
print("{N} iterations in {elapsed}ms = {elapsed * 1000 / N}us each")

// Using bench_run (reports iterations/sec)
bench_run("fibonacci", 1000, fn()
    fibonacci(20)
)
```

### A complete test file

```nova
fn factorial(n)
    if n <= 1
        return 1
    n * factorial(n - 1)

fn fibonacci(n)
    if n <= 1
        return n
    fibonacci(n - 1) + fibonacci(n - 2)

fn main()
    // Unit tests
    test_run("factorial of 0", fn() assert_eq(factorial(0), 1))
    test_run("factorial of 1", fn() assert_eq(factorial(1), 1))
    test_run("factorial of 5", fn() assert_eq(factorial(5), 120))
    test_run("factorial of 10", fn() assert_eq(factorial(10), 3628800))

    test_run("fibonacci of 0", fn() assert_eq(fibonacci(0), 0))
    test_run("fibonacci of 1", fn() assert_eq(fibonacci(1), 1))
    test_run("fibonacci of 10", fn() assert_eq(fibonacci(10), 55))

    // Edge case tests
    test_run("empty string length", fn() assert_eq(len(""), 0))
    test_run("negative numbers", fn() assert_true(-5 < 0))

    test_summary()
```

> **DO:** Write `test_run()` for each test case with descriptive names, and call `test_summary()` at the end.
> **DON'T:** Use bare `assert()` scattered throughout your code for testing — `test_run` captures failures without crashing the whole program.

---

## 17. Processes and channels

NOVA's concurrency model is based on three concepts: **processes** (lightweight tasks), **channels** (communication pipes), and **ownership transfer** (safety guarantee). This is the same model used by Erlang, which powers phone networks that must never go down.

### Why NOVA's concurrency is different

Most languages have one of these problems:
- **Python/JavaScript:** Single-threaded. `async/await` is not real parallelism — it is just cooperative scheduling on one core.
- **Java/C#:** Shared memory with locks. Mutexes, synchronized blocks, data races, deadlocks. Hard to get right.
- **Go:** Goroutines are great, but they share memory. A goroutine can modify a slice that another goroutine is reading, causing a data race.
- **Rust:** Ownership prevents data races at compile time, but the learning curve is steep (`Send`, `Sync`, lifetimes, `Arc<Mutex<T>>`).

NOVA's approach: **processes never share memory.** When you send data over a channel, the data is deep-copied. The sender and receiver each have their own independent copy. Data races are structurally impossible.

### spawn — creating a task

`spawn` creates a new lightweight task that runs concurrently with your main program:

```nova
spawn fn()
    print("Hello from a new task!")

print("Hello from main!")
```

Output (order may vary):
```
Hello from main!
Hello from a new task!
```

**Line-by-line breakdown:**

- `spawn fn()` — The `spawn` keyword takes a closure (anonymous function) and runs it as a new, independent task. The task executes concurrently — it runs alongside your main code, not after it. The closure `fn() print("Hello from a new task!")` is the code that the new task will run.
- `print("Hello from main!")` — This runs in the main task. It might print before or after the spawned task prints — the order depends on how the NOVA scheduler decides to run the tasks. Both tasks are running concurrently.

**What is a "green task"?** NOVA's tasks are "green tasks" (also called "green threads" or "fibers"). Unlike OS (Operating System) threads (which are heavyweight — each one uses ~1MB of stack memory and takes ~100µs to create), green tasks are lightweight: they use ~32KB of stack and take ~1µs to create. NOVA multiplexes thousands of green tasks across a small number of OS threads. This is the same approach used by Go (goroutines) and Erlang (processes).

**Performance comparison:**
- NOVA spawn: ~1µs, ~32KB memory each
- Go goroutine: ~1µs, ~8KB memory each
- Python threading.Thread: ~50µs, ~1MB memory each
- Java Thread: ~100µs, ~1MB memory each

This means you can spawn 100,000 NOVA tasks and they will use about 3GB of memory. 100,000 Java threads would need 100GB and your program would crash.

### channel — talking between tasks

A channel is a communication pipe between tasks. One task sends values into the channel, and another task receives them. Think of it like a mailbox: one person puts letters in, another person takes them out.

```nova
ch = channel()

spawn fn()
    send(ch, 42)

result = receive(ch)
print(result)    // 42
```

**Line-by-line breakdown:**

- `ch = channel()` — Creates a new channel. A channel is like an empty pipe — it has no values in it yet. Any task that has access to `ch` can send values into it or receive values from it.
- `spawn fn()` — Creates a new task. This task will execute the code inside the closure.
- `    send(ch, 42)` — The spawned task sends the integer `42` into the channel. If another task is already waiting to receive on this channel, it wakes up immediately and gets the value. If nobody is waiting, the value sits in the channel until someone calls `receive`.
- `result = receive(ch)` — The main task waits for a value on the channel. This call **blocks** — the main task stops executing and waits until some other task sends a value on `ch`. When the spawned task sends `42`, `receive` returns `42` and the main task continues. The blocking does NOT waste CPU — NOVA parks the task on the scheduler and wakes it when data arrives.
- `print(result)` — Prints `42`.

**The key insight:** `send` and `receive` are how tasks communicate. Tasks do NOT share variables. Instead, they send copies of data through channels. This is called the "Communicating Sequential Processes" (CSP) model, and it is the safest way to do concurrency.

### Ownership transfer — why data races are impossible

When you `send` a value over a channel, NOVA **deep-copies** it. The sender keeps their original, and the receiver gets a completely independent copy. Neither can affect the other:

```nova
data = [1, 2, 3]
ch = channel()

spawn fn()
    received = receive(ch)
    push(received, 4)                 // modifying the COPY
    print("task sees: {received}")    // [1, 2, 3, 4]

send(ch, data)
print("main sees: {data}")           // [1, 2, 3] — unchanged!
```

**Line-by-line breakdown:**

- `data = [1, 2, 3]` — Creates a list in the main task.
- `ch = channel()` — Creates a channel for communication.
- `spawn fn()` — Creates a new task that will receive data from the channel.
- `    received = receive(ch)` — The spawned task waits for data. When `send(ch, data)` is called (below), `receive` returns a **deep copy** of `data`: a completely new list `[1, 2, 3]` that is independent of the original.
- `    push(received, 4)` — The spawned task modifies its copy. This adds `4` to the spawned task's copy, making it `[1, 2, 3, 4]`.
- `send(ch, data)` — Sends the data through the channel. NOVA deep-copies `data` before putting it in the channel. The original `data` is untouched.
- `print("main sees: {data}")` — Prints `[1, 2, 3]`. The main task's list is unchanged because the spawned task only modified its own copy.

**Why this matters:** This design makes data races **structurally impossible**. A data race is when two threads read and write the same memory at the same time, leading to corrupted data. In NOVA, no two tasks ever see the same memory, so data races cannot happen — not just "difficult" or "unlikely," but literally impossible by the language's design.

### How data races happen in other languages (and why they can't in NOVA)

Here is a real data race in Python:

```python
# Python — this code has a data race
import threading
counter = 0
def increment():
    global counter
    for _ in range(100000):
        counter += 1  # NOT atomic — reads, increments, writes

t1 = threading.Thread(target=increment)
t2 = threading.Thread(target=increment)
t1.start(); t2.start()
t1.join(); t2.join()
print(counter)  # Should be 200000, actually something like 143287
```

The equivalent NOVA code cannot have this bug:

```nova
fn main()
    ch = channel()

    // Each task has its own independent counter
    spawn fn()
        count = 0
        i = 0
        while i < 100000
            count = count + 1
            i = i + 1
        send(ch, count)

    spawn fn()
        count = 0
        i = 0
        while i < 100000
            count = count + 1
            i = i + 1
        send(ch, count)

    a = receive(ch)
    b = receive(ch)
    print(a + b)    // Always exactly 200000
```

Each task has its own `count` variable. There is no shared state. The final addition happens in main after both tasks have finished. The result is always correct.

### Fan-out pattern — distributing work across multiple tasks

"Fan-out" means splitting one job into multiple smaller jobs that run in parallel. This is useful when you have a list of items to process and each item can be processed independently:

```nova
fn main()
    result_ch = channel()

    // Spawn 5 workers
    for i in 0..5
        spawn fn()
            answer = i * i
            send(result_ch, answer)

    // Collect all results
    total = 0
    for i in 0..5
        total = total + receive(result_ch)
    print("sum of squares: {total}")    // 0 + 1 + 4 + 9 + 16 = 30
```

**Line-by-line breakdown:**

- `result_ch = channel()` — Creates a single channel that all workers will send their results to.
- `for i in 0..5` — Loops 5 times (0, 1, 2, 3, 4). Each iteration spawns a new worker task.
- `spawn fn()` — Creates a new task for each iteration. All 5 tasks run concurrently — they are all computing at the same time, potentially on different CPU cores.
- `    answer = i * i` — Each worker computes the square of its number. Task 0 computes 0, task 1 computes 1, task 2 computes 4, etc.
- `    send(result_ch, answer)` — Each worker sends its result to the shared result channel.
- `for i in 0..5` — The main task loops 5 times, calling `receive` on each iteration to collect one result from the channel.
- `total = total + receive(result_ch)` — Each `receive` blocks until a worker sends a result. The order in which results arrive is non-deterministic (whichever worker finishes first sends first), but the sum is always the same: 0 + 1 + 4 + 9 + 16 = 30.

**When to use fan-out:** When you have N independent tasks (processing images, making HTTP requests, computing on different data) and want them to run in parallel.

### Fan-in pattern — multiple producers, one consumer

"Fan-in" is the reverse of fan-out: multiple tasks produce data, and one task consumes it through a single channel:

```nova
ch = channel()

spawn fn()
    send(ch, 100)

spawn fn()
    send(ch, 200)

spawn fn()
    send(ch, 300)

a = receive(ch)
b = receive(ch)
c = receive(ch)
// Order is non-deterministic, but sum is always 600
print(a + b + c)    // 600
```

**Line-by-line breakdown:**

- Three separate tasks send values (100, 200, 300) to the same channel `ch`.
- The main task calls `receive` three times. Each call gets one value from the channel. The order depends on which task runs first — `a` might be 200 and `b` might be 100, or any other permutation. But the total is always 600.
- This is safe because channels are designed for multiple producers. No locking, no synchronization code needed — the channel handles everything internally.

**When to use fan-in:** When you have multiple data sources (sensor readings, log streams, user events) and want to process them in one place.

### select — waiting on multiple channels

`select` waits on multiple channels simultaneously and returns data from whichever channel has data first. This is essential when your program needs to respond to events from different sources — like a server handling both user requests and admin commands:

```nova
ch1 = channel()
ch2 = channel()

spawn fn()
    sleep(100)
    send(ch1, "from ch1")

spawn fn()
    sleep(50)
    send(ch2, "from ch2")

result = select(ch1, ch2)
idx = result[0]       // which channel (0 or 1)
val = result[1]       // the value
print("got '{val}' from channel {idx}")
// Output: got 'from ch2' from channel 1 (ch2 sends first because it sleeps less)
```

**Line-by-line breakdown:**

- `ch1 = channel()` / `ch2 = channel()` — Creates two channels. We want to receive from whichever one gets data first.
- `spawn fn()` / `sleep(100)` / `send(ch1, "from ch1")` — First task waits 100 milliseconds, then sends data to ch1.
- `spawn fn()` / `sleep(50)` / `send(ch2, "from ch2")` — Second task waits only 50 milliseconds, then sends data to ch2. This task will send first because it sleeps less.
- `result = select(ch1, ch2)` — Waits on BOTH channels at the same time. As soon as either channel has data, `select` returns. It returns a list with two elements: the channel index (which channel had data) and the value.
- `idx = result[0]` — The index of the channel that had data first. `0` means ch1, `1` means ch2. In this case, ch2 sends first (it sleeps only 50ms vs 100ms), so `idx` is `1`.
- `val = result[1]` — The actual value received from the channel.

**Why `select` matters:** Without `select`, you would have to check channels one at a time, potentially missing data or blocking on the wrong channel. `select` is how you build event-driven systems that respond to multiple inputs.

### Bidirectional communication — request/response pattern

When a task needs to send a request and get a response back, use two channels — one for each direction:

```nova
request_ch = channel()
response_ch = channel()

// Server task — runs in a loop, processing requests
spawn fn()
    loop
        msg = receive(request_ch)
        if msg == "quit"
            break
        send(response_ch, upper(msg))

// Client: send requests, receive responses
send(request_ch, "hello")
print(receive(response_ch))    // HELLO

send(request_ch, "world")
print(receive(response_ch))    // WORLD

send(request_ch, "quit")
```

**Line-by-line breakdown:**

- `request_ch = channel()` — Channel for sending requests TO the server task.
- `response_ch = channel()` — Channel for receiving responses FROM the server task.
- The spawned task runs in a `loop`, receiving requests and sending back responses. `upper(msg)` converts the string to uppercase. When it receives `"quit"`, it breaks out of the loop and the task ends.
- The main task sends `"hello"` on the request channel, then waits for a response on the response channel. The server task receives `"hello"`, converts it to `"HELLO"`, and sends it back. The main task receives `"HELLO"` and prints it.
- This is the standard **client-server** pattern within a single program. You can extend it to any request-response protocol.

### Bounded channels

Bounded channels have a maximum capacity. `send` blocks when the channel is full, providing natural backpressure:

```nova
ch = channel_bounded(3)    // can hold at most 3 values

send(ch, 1)    // succeeds immediately
send(ch, 2)    // succeeds immediately
send(ch, 3)    // succeeds immediately
// send(ch, 4) would BLOCK until someone receives
```

### reschedule()

In CPU-bound tasks that loop without I/O, call `reschedule()` periodically to yield to the scheduler. Without it, a CPU-bound task monopolizes its OS thread:

```nova
spawn fn()
    i = 0
    while i < 10_000_000
        i = i + 1
        if i % 100_000 == 0
            reschedule()   // let other tasks run
```

Green tasks that do I/O (channel receive, tcp_recv, sleep) yield automatically. `reschedule()` is only needed for tight compute loops.

### Parallel map — pmap

For embarrassingly parallel work, `pmap` maps a function over a list using multiple green tasks:

```nova
fn heavy_compute(x)
    // simulate expensive work
    result = 0
    i = 0
    while i < 100000
        result = result + i * x
        i = i + 1
    result

nums = [1, 2, 3, 4, 5, 6, 7, 8]
results = pmap(nums, fn(x) heavy_compute(x))
print(results)    // computed in parallel across all available cores
```

---

## 18. Advanced concurrency

### What is advanced concurrency?

Section 17 covered the basics: spawning tasks, sending/receiving on channels, and select. This section covers advanced patterns for building robust, fault-tolerant concurrent systems:

- **Monitors** — detect when a task finishes or crashes
- **Supervision** — automatically restart failed tasks (inspired by Erlang's OTP)
- **Timeouts** — avoid blocking forever when waiting for data
- **Select with timeout** — wait on multiple channels with a time limit

These patterns are essential for production systems that must stay running 24/7. A web server that crashes and never restarts is useless. A request handler that waits forever on a dead service blocks the entire server.

### Monitors — watching for task completion

A monitor lets you detect when a spawned task finishes:

```nova
ch = channel()

pid = spawn fn()
    send(ch, 42)

mon = monitor(pid)
result = receive(ch)       // get the task's output
status = receive(mon)      // get notified when it exits
print(result)              // 42
print(status)              // exit status
```

### Process linking and supervision

For fault-tolerant systems, use process monitors to detect and restart failed tasks:

```nova
fn worker(id, result_ch)
    // do some work
    send(result_ch, "worker {id} done")

fn supervisor()
    result_ch = channel()
    for i in 0..4
        pid = spawn fn()
            worker(i, result_ch)
        monitor(pid)

    // Collect results
    for i in 0..4
        print(receive(result_ch))
```

### Timeouts

Use `channel_recv_timeout` to avoid blocking forever:

```nova
ch = channel()

// Nobody will send on this channel
result = channel_recv_timeout(ch, 1000)   // wait up to 1000ms
if result == null
    print("timed out after 1 second")
```

### select with timeout

```nova
ch1 = channel()
ch2 = channel()

result = select_timeout(ch1, ch2, 500)   // wait up to 500ms
if result == null
    print("no data on either channel within 500ms")
```

---

## 19. Modules

### What are modules?

As your program grows, you will want to split your code into multiple files for organization. Modules are NOVA's way of organizing code across files. Each `.nova` file is a module, and you can use functions from other modules by importing them.

Think of modules like rooms in a house: each room (file) has its own furniture (functions), and you can go to any room to use its furniture by importing it.

### Importing modules

```nova
import forge
import csvx
import bignum
```

**Line-by-line breakdown:**

- `import forge` — Tells the compiler: "I want to use functions from the `forge` module." The compiler finds the file `forge.nova`, compiles it, and makes all its top-level functions available in your current file. After this line, you can call any function defined in `forge.nova` (like `forge.app()`, `forge.get()`, etc.).
- `import csvx` — Same for the CSV (Comma-Separated Values) parsing module. After this, you can call `csv_parse()`, `csv_write()`, etc.
- `import bignum` — Same for the arbitrary-precision integer module.

An `import` statement loads a module file and makes its functions available. Module names map directly to file names: `import forge` looks for a file called `forge.nova`.

### Module resolution — where NOVA looks for modules

When you write `import mymodule`, NOVA looks for the file in this order:

1. **Same directory** as the current file — `import utils` looks for `utils.nova` in the same folder as your program
2. **$NOVA_HOME/lib/** — `import forge` looks for `$NOVA_HOME/lib/forge.nova` (the standard library directory)

This means:
- To create a **project-local** module, just put a `.nova` file next to your main file
- To use a **standard library** module, just `import` it — the compiler knows where to find it

### Module files are just NOVA files

A module is simply a `.nova` file with functions in it. There is no special module declaration, no `export` keyword, no `module` statement. Any function defined at the top level of the file is automatically available to anyone who imports it.

**Step 1: Create a module file** — `math_utils.nova`:

```nova
// math_utils.nova — this is a module file
fn square(x)
    x * x

fn cube(x)
    x * x * x
```

**Step 2: Import and use it** — `main.nova` (in the same directory):

```nova
// main.nova
import math_utils

print(square(5))    // 25
print(cube(3))      // 27
```

**Line-by-line breakdown:**

- `import math_utils` — Finds `math_utils.nova` in the same directory. All its functions (`square`, `cube`) become available in this file.
- `print(square(5))` — Calls the `square` function defined in `math_utils.nova`. You do NOT need to write `math_utils.square(5)` — the functions are imported directly into your namespace.

> **DO:** Split large programs into modules. Put related functions together (all database functions in `db.nova`, all authentication in `auth.nova`).
> **DON'T:** Create circular imports (file A imports file B which imports file A) — this will cause a compilation error.

### NOVA_HOME and the standard library

NOVA ships with a standard library in `$NOVA_HOME/lib/`. These modules are available with a simple `import`:

```nova
import forge           // web framework
import forge_crypto    // cryptographic functions
import csvx            // CSV (Comma-Separated Values) parsing
import bignum          // arbitrary-precision integers
import complexnum      // complex numbers
import rational        // rational numbers
import matrixx         // matrix operations
import prng            // pseudo-random number generators
import uuid            // UUID generation
import basex           // base encoding (base32, base58, etc.)
import bitset          // bit set operations
import strx            // extended string operations
import urlx            // URL parsing and encoding
import collx           // collection utilities
import corex           // core utilities
import getin           // nested data access
import setops          // set operations
import graphemex       // Unicode grapheme operations
import deflatex        // DEFLATE compression
import pvecx           // persistent vectors
```

See [Appendix D](#appendix-d-standard-library-modules) for the complete module list.

---

## 20. Networking: TCP (Transmission Control Protocol) and UDP (User Datagram Protocol)

### What is TCP?

TCP (Transmission Control Protocol) is the foundation of internet communication. When you visit a website, send an email, or use an API, your computer uses TCP under the hood. TCP ensures that data arrives reliably, in the correct order, and without corruption. It is the "reliable delivery" protocol of the internet.

UDP (User Datagram Protocol) is TCP's faster but less reliable sibling. UDP does not guarantee delivery or order — packets can arrive out of order or not at all. But it is faster because it skips the reliability overhead. UDP is used for real-time applications like video streaming, online games, and DNS (Domain Name System) queries where speed matters more than perfect delivery.

NOVA has built-in support for both TCP and UDP — no external libraries or imports needed.

### TCP client/server

Here is a complete echo server and client in NOVA. The server listens for connections, receives a message, echoes it back with a prefix, and closes. The client connects, sends a message, receives the response, and closes:

```nova
fn run_server(port)
    server = tcp_listen(port)
    print("Server listening on port {port}")
    client = tcp_accept(server)        // blocks until a client connects
    data = tcp_recv(client)            // read data from client
    tcp_send(client, "ECHO:" + data)   // send response
    tcp_close(client)
    tcp_close(server)

port = 19876

// Spawn server in a separate task
spawn fn()
    run_server(port)

// Give server time to start
sleep(100)

// Client connects
sock = tcp_connect("127.0.0.1", port)
tcp_send(sock, "hello")
reply = tcp_recv(sock)
tcp_close(sock)

print(reply)    // ECHO:hello
```

**Line-by-line breakdown:**

**Server side:**
- `server = tcp_listen(port)` — Creates a TCP listener that waits for incoming connections on the specified port. This is like opening a shop and putting up an "open" sign — the server is now waiting for customers (clients) to connect.
- `client = tcp_accept(server)` — Blocks (waits) until a client connects. When a client connects, `tcp_accept` returns a connection object representing the client.
- `data = tcp_recv(client)` — Reads data sent by the client. Blocks until data is available. Returns the data as a string.
- `tcp_send(client, "ECHO:" + data)` — Sends the response back to the client. Prepends `"ECHO:"` to whatever the client sent.
- `tcp_close(client)` / `tcp_close(server)` — Closes the connection and the listener. Always close connections when done — otherwise you leak file descriptors.

**Client side:**
- `sock = tcp_connect("127.0.0.1", port)` — Connects to the server at IP address `127.0.0.1` (localhost — the same machine) on the specified port. Returns a connection object.
- `tcp_send(sock, "hello")` — Sends the string `"hello"` to the server.
- `reply = tcp_recv(sock)` — Waits for the server's response. Returns `"ECHO:hello"`.
- `tcp_close(sock)` — Closes the client's connection.

**Why spawn + sleep?** The server runs in a spawned task so that the client code can run concurrently. The `sleep(100)` gives the server task time to call `tcp_listen` and `tcp_accept` before the client tries to connect.

### TCP API (Application Programming Interface) reference

| Function | What it does | Returns |
|----------|-------------|---------|
| `tcp_listen(port)` | Start listening for connections on a port | A listener object |
| `tcp_accept(listener)` | Wait for a client to connect | A connection object |
| `tcp_connect(host, port)` | Connect to a remote server | A connection object |
| `tcp_send(conn, data)` | Send a string over the connection | nothing |
| `tcp_recv(conn)` | Receive a string (blocks until data arrives) | The received string |
| `tcp_send_bytes(conn, bytes)` | Send raw bytes | nothing |
| `tcp_recv_bytes(conn)` | Receive raw bytes | The received bytes |
| `tcp_close(conn)` | Close the connection | nothing |

### UDP

```nova
// Server
sock = udp_bind(9999)
data = udp_recv(sock)
print("received: {data}")

// Client
udp_send("127.0.0.1", 9999, "hello via UDP")
```

### Green-aware networking

TCP operations (`tcp_accept`, `tcp_recv`, `tcp_connect`) are green-task-aware. When a green task calls `tcp_recv`, it parks on the scheduler's netpoller (using `epoll` on Linux, `WSAPoll` on Windows) and does not block the OS thread. Other green tasks continue running. When data arrives, the parked task is woken up automatically.

This means you can handle thousands of concurrent connections with a few OS threads:

```nova
fn handle_client(conn)
    loop
        data = tcp_recv(conn)
        if len(data) == 0
            break
        tcp_send(conn, "ECHO:" + data)
    tcp_close(conn)

fn main()
    server = tcp_listen(8080)
    loop
        conn = tcp_accept(server)
        spawn fn()
            handle_client(conn)
```

Each client gets its own green task. No thread pool configuration needed.

---

## 21. HTTP (HyperText Transfer Protocol) client

### What is an HTTP client?

HTTP is the protocol that powers the web. When your browser visits a website, it sends an HTTP request to a server and receives an HTTP response. An HTTP client is a program that makes these requests programmatically — calling APIs, downloading data, interacting with web services.

NOVA has built-in HTTP client functions, so you can make web requests without any external libraries.

### Making HTTP requests

```nova
// GET request — fetch data
response = http_get("http://example.com/api/users")
print(response)

// POST request — send data
body = json_encode({"name": "Alice", "age": 30})
response = http_post("http://example.com/api/users", body)
print(response)
```

**Line-by-line breakdown:**

- `http_get("http://example.com/api/users")` — Sends an HTTP GET request to the URL. GET requests retrieve data — they ask the server "give me the list of users." The function blocks until the response arrives, then returns the response body as a string.
- `json_encode({"name": "Alice", "age": 30})` — Converts the NOVA dict into a JSON string: `{"name":"Alice","age":30}`. This will be the request body.
- `http_post("http://example.com/api/users", body)` — Sends an HTTP POST request with the JSON body. POST requests send data TO the server — they say "create a new user with this data."

### Self-contained example (loopback test)

This example starts a tiny HTTP server and then makes a request to it — all in one program:

```nova
fn main()
    spawn fn()
        sock = http_listen(18080)
        conn = http_accept_raw(sock)
        if len(conn) > 0
            client = conn[0]
            http_send_raw(client, "HTTP/1.1 200 OK\r\nContent-Type: text/plain\r\nContent-Length: 11\r\nConnection: close\r\n\r\nhello-nova!")

    sleep(800)

    resp = http_get("http://127.0.0.1:18080/")
    print(resp)   // hello-nova!
```

**Line-by-line breakdown:**

- `spawn fn()` — Starts a green task that runs a tiny HTTP server in the background.
- `http_listen(18080)` — Listens for connections on port 18080.
- `http_accept_raw(sock)` — Waits for a client to connect. Returns the connection.
- `http_send_raw(client, "HTTP/1.1 200 OK\r\n...")` — Sends a raw HTTP response. The `\r\n` sequences are required by the HTTP protocol (carriage return + newline). The response includes headers (Content-Type, Content-Length) and a body ("hello-nova!").
- `sleep(800)` — Waits 800 milliseconds for the server task to start listening.
- `http_get("http://127.0.0.1:18080/")` — Makes a request to our own server at localhost port 18080.

For building real HTTP servers with routing, middleware, and all production features, use [Forge](#25-forge-building-a-rest-api) instead of raw HTTP functions.

---

## 22. Cryptography and encoding

### What is cryptography and why do you need it?

Cryptography is the science of keeping data secure. When you build any application that handles passwords, authentication, API keys, or sensitive data, you need cryptography. NOVA provides both cryptographic functions (for security) and encoding functions (for data format conversion).

**Key concepts:**
- **Hashing** — Converting data into a fixed-size "fingerprint." You cannot reverse a hash back to the original data. Used for: password storage, data integrity verification, deduplication.
- **HMAC** — Hash-based Message Authentication Code. Combines a hash with a secret key to prove both integrity (data was not modified) AND authenticity (data came from someone who knows the key). Used for: API authentication, JWT signatures, webhook verification.
- **Encoding** — Converting data between formats (Base64, hex, URL encoding). This is NOT encryption — encoded data can be decoded by anyone. Used for: embedding binary data in text, URL-safe strings, email attachments.

### Cryptographic hashing with SHA-256

SHA-256 (Secure Hash Algorithm, 256-bit) produces a unique 64-character hex string for any input. Even a tiny change in the input produces a completely different hash:

```nova
import forge_crypto

hash = sha256_hex("hello")
print(hash)   // 2cf24dba5fb0a30e26e83b2ac5b9e29e1b161e5c1fa7425e73043362938b9824
```

**Line-by-line breakdown:**

- `import forge_crypto` — Loads the cryptography module. This provides `sha256_hex`, `hmac_sha256`, and other crypto functions.
- `hash = sha256_hex("hello")` — Computes the SHA-256 hash of the string `"hello"`. The result is always exactly 64 hexadecimal characters, regardless of input length. If you hash `"hello"` a million times, you get the exact same output every time. But if you hash `"hello!"` (with an exclamation mark), you get a completely different hash.

**Hashing bytes:**

```nova
data = str_to_bytes("hello")
hash = sha256_of_bytes(data)
```

Use `sha256_of_bytes` when working with binary data (files, network payloads) instead of strings.

**What NOT to do:**

```nova
// DON'T store passwords as plain text!
password = "my-secret-password"
// BAD: store_in_database(password)

// DO hash passwords before storing
hashed = sha256_hex(password)
// store_in_database(hashed)
// When the user logs in, hash their input and compare the hashes
```

### HMAC (Hash-based Message Authentication Code)

HMAC combines a hash with a secret key. This lets you verify that a message was sent by someone who knows the key AND that the message was not modified in transit:

```nova
import forge_crypto

mac = hmac_sha256("secret-key", "message to authenticate")
```

**Line-by-line breakdown:**

- `hmac_sha256("secret-key", "message to authenticate")` — Computes an HMAC using SHA-256. The first argument is the secret key (known only to the sender and receiver). The second argument is the message. The result is a hash that proves the message is authentic.

**When to use HMAC:** API authentication (signing requests), verifying webhooks (GitHub/Stripe send an HMAC so you can verify the payload came from them), and JWT (JSON Web Token) signatures.

### Non-cryptographic hashing (built-in, no import needed)

These hash functions are fast but NOT suitable for security. Use them for hash tables, data deduplication, and checksums:

```nova
print(hash("hello"))          // integer hash value (general-purpose)
print(fnv1a("hello"))         // FNV-1a (Fowler-Noll-Vo) hash — fast, good distribution
print(murmur3("hello"))       // MurmurHash3 — fast, excellent for hash tables
print(crc32("hello"))         // CRC-32 (Cyclic Redundancy Check) — used for error detection
```

**When to use which hash:**

| Function | Speed | Use case |
|----------|-------|----------|
| `sha256_hex` | Slow (secure) | Passwords, signatures, integrity verification |
| `hmac_sha256` | Slow (secure) | API authentication, JWT, webhook verification |
| `hash` / `fnv1a` | Very fast | Hash table keys, deduplication |
| `murmur3` | Very fast | Hash table keys, bloom filters |
| `crc32` | Fast | File integrity checks, network packet verification |

> **DO:** Use `sha256_hex` or `hmac_sha256` for anything security-related.
> **DON'T:** Use `hash()`, `fnv1a()`, or `crc32()` for security — they are not cryptographically secure and can be reversed or forged.

### Base64 encoding/decoding

Base64 converts binary data into a string of printable characters (A-Z, a-z, 0-9, +, /). This is useful for embedding binary data in JSON, HTML, emails, or URLs:

```nova
encoded = base64_encode("Hello, NOVA!")
print(encoded)                // SGVsbG8sIE5PVkEh

decoded = base64_decode(encoded)
print(decoded)                // Hello, NOVA!
```

**Line-by-line breakdown:**

- `base64_encode("Hello, NOVA!")` — Converts the string to Base64 encoding. Every 3 bytes of input become 4 characters of output. The result (`SGVsbG8sIE5PVkEh`) contains only safe, printable characters.
- `base64_decode(encoded)` — Converts the Base64 string back to the original data. This is lossless — you always get the exact original back.

**Common uses:** Embedding images in HTML (`<img src="data:image/png;base64,...">`), sending binary data in JSON APIs, encoding email attachments, storing binary data in text-based configuration files.

### Hex encoding/decoding

Hex encoding represents each byte as two hexadecimal characters (0-9, a-f):

```nova
encoded = hex_encode("Hello")
print(encoded)                // 48656c6c6f

decoded = hex_decode(encoded)
print(decoded)                // Hello
```

**When to use hex vs Base64:** Hex is more readable (you can look at `48656c6c6f` and know each byte), but it is less space-efficient (2 chars per byte vs Base64's 1.33 chars per byte). Use hex for debugging and logging; use Base64 for data transfer.

### URL (Uniform Resource Locator) encoding/decoding

URL encoding converts special characters into `%XX` format so they can be safely included in URLs:

```nova
encoded = url_encode("hello world&foo=bar")
print(encoded)                // hello+world%26foo%3Dbar

decoded = url_decode(encoded)
print(decoded)                // hello world&foo=bar
```

**Why this matters:** URLs cannot contain spaces, `&`, `=`, or many other characters. If you include them directly, the URL is malformed. `url_encode` replaces `&` with `%26`, spaces with `+`, etc. Always URL-encode user input before putting it in a URL.

### Random values

```nova
// Random integer in a range (inclusive)
n = random_int(1, 100)
print(n)                      // random number between 1 and 100

// Random float between 0.0 and 1.0
f = random_float()
print(f)                      // 0.7234... (example)

// Cryptographically secure random bytes (for tokens, keys, etc.)
data = secure_bytes(32)       // 32 random bytes
```

**Line-by-line breakdown:**

- `random_int(1, 100)` — Returns a random integer between 1 and 100 (inclusive). Good for games, simulations, and testing. NOT suitable for security (the output is predictable if you know the seed).
- `random_float()` — Returns a random float between 0.0 and 1.0. Useful for probability calculations, Monte Carlo simulations, and random selection.
- `secure_bytes(32)` — Returns 32 cryptographically secure random bytes. These are generated by the OS's cryptographic random number generator and are suitable for generating session tokens, encryption keys, and passwords. **Always use `secure_bytes` for security-sensitive randomness** — never `random_int`.

### UUID (Universally Unique Identifier) generation

A UUID is a 128-bit identifier that is virtually guaranteed to be unique across all computers and all time. UUIDs are used for database primary keys, session IDs, and any place where you need a unique identifier without a central authority:

```nova
id = uuid4()
print(id)    // e.g., "550e8400-e29b-41d4-a716-446655440000"
```

The `uuid4()` function generates a version 4 UUID (random). The format is `xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx`, where each `x` is a random hex digit. The probability of generating two identical UUIDs is astronomically small (about 1 in 2^122, or 1 in 5.3 × 10^36).

---

## 23. System and environment

### What is this section about?

Programs need to interact with the operating system: read command-line arguments, access environment variables, query system information, run external commands, and manage subprocesses. This section covers all of NOVA's system interaction functions.

### Command-line arguments

When you run a NOVA program from the terminal, you can pass arguments:

```nova
// Run: nova run script.nova arg1 arg2 arg3
arguments = args()
print(arguments)       // ["arg1", "arg2", "arg3"]
print(arguments[0])    // arg1
```

**Line-by-line breakdown:**

- `args()` — Returns a list of strings containing all command-line arguments passed to the program. If you run `nova run script.nova hello world`, `args()` returns `["hello", "world"]`.
- `arguments[0]` — The first argument (index 0). Arguments are strings; use `int(arguments[0])` if you need a number.

### Environment variables

Environment variables are key-value pairs set by the operating system or the user. They are commonly used for configuration:

```nova
// Read an environment variable
home = env("HOME")
print(home)            // /home/user (or C:\Users\user on Windows)

// Set an environment variable (for current process only)
set_env("MY_VAR", "hello")
print(env("MY_VAR"))   // hello
```

**Line-by-line breakdown:**

- `env("HOME")` — Reads the value of the `HOME` environment variable. Returns an empty string if the variable is not set. Common variables: `HOME` (user's home directory), `PATH` (where the OS looks for programs), `NOVA_HOME` (where NOVA's standard library is).
- `set_env("MY_VAR", "hello")` — Sets an environment variable for the current process. Child processes will inherit it. This does NOT change the variable for other programs or after your program exits.

### System information

```nova
print(os_name())       // "windows" or "linux" or "darwin" (macOS)
print(arch_name())     // "x86_64" or "aarch64" (ARM)
print(hostname())      // your computer's hostname
print(getpid())        // current process ID (a number like 12345)
print(cpu_count())     // number of CPU cores (e.g., 8)
print(temp_dir())      // temp directory path (e.g., "/tmp" or "C:\Users\...\Temp")
print(self_exe_path()) // path to the currently running executable
```

**Line-by-line breakdown:**

- `os_name()` — Returns the operating system name. Use this for platform-specific behavior: `if os_name() == "windows" then ... else ...`
- `cpu_count()` — Returns the number of CPU cores. Useful for deciding how many workers to spawn in a worker pool.
- `getpid()` — Returns the process ID. Useful for logging and debugging ("which process is this?").

### Running external commands

You can run other programs from NOVA:

```nova
// Run a command and get its output as a string
output = shell("echo hello")
print(output)          // hello

// Run with exit code checking
result = system("git status")
print(result)          // exit code: 0 = success, non-zero = failure
```

**Line-by-line breakdown:**

- `shell("echo hello")` — Runs the command `echo hello` in the system shell and returns its standard output as a string. Use this when you need the command's output.
- `system("git status")` — Runs the command and returns its exit code as an integer. `0` means success. Non-zero means failure. Use this when you only care about whether the command succeeded.

### Process management — running subprocesses

For more control over external programs, use the `proc_*` functions:

```nova
proc = proc_open("python", ["-c", "print('hello from python')"])
output = proc_read_stdout(proc)
exit_code = proc_wait(proc)
print(output)           // hello from python
print(exit_code)        // 0
```

**Line-by-line breakdown:**

- `proc_open("python", ["-c", "print('hello from python')"])` — Starts a subprocess running `python` with arguments `["-c", "print('hello from python')"]`. Returns a process handle. The subprocess runs in parallel with your NOVA program.
- `proc_read_stdout(proc)` — Reads the subprocess's standard output. Blocks until the subprocess finishes writing.
- `proc_wait(proc)` — Waits for the subprocess to exit and returns its exit code.

### Exit — terminating the program

```nova
if critical_error
    print("Fatal error!")
    exit(1)    // exit with non-zero status code
```

**Line-by-line breakdown:**

- `exit(1)` — Immediately terminates the program with exit code `1`. By convention, exit code `0` means success, and any non-zero code means failure. Shell scripts and CI (Continuous Integration) systems check the exit code to determine if a program succeeded.

---

## 24. Logging

### What is logging and why does it matter?

Logging is how your program tells you what it is doing. When something goes wrong in production at 3am, logs are your primary tool for figuring out what happened. Good logging means you can diagnose problems without attaching a debugger.

NOVA has a built-in structured logging system — no external library needed. It supports severity levels (so you can control how much detail you see), timestamps (so you know when things happened), and JSON output (so log aggregation tools like Elasticsearch or Datadog can parse them).

### Log levels

Logs have severity levels from most detailed to most critical:

```nova
log_trace("detailed trace info")        // extremely detailed, for deep debugging
log_debug("debugging information")      // useful during development
log_info("normal operation info")       // routine events: "server started", "request handled"
log_warn("something unusual happened")  // not an error yet, but worth investigating
log_error("something went wrong")       // a real problem, but the program can continue
log_fatal("critical failure")           // the program cannot continue
```

**Line-by-line breakdown:**

- `log_trace(...)` — The most detailed level. Use for tracing exact program flow: "entering function X," "variable Y is now 42." Normally turned off in production because it generates enormous amounts of output.
- `log_debug(...)` — Useful during development. "Loaded 42 users from database," "cache hit for key 'abc'."
- `log_info(...)` — Normal operations worth noting. "Server started on port 8080," "Processing batch of 100 items." This is the default level in production.
- `log_warn(...)` — Something unexpected happened but the program can handle it. "Retrying failed request," "Configuration file not found, using defaults."
- `log_error(...)` — Something went wrong. "Failed to connect to database," "Invalid input from user." The program continues but the issue should be investigated.
- `log_fatal(...)` — A critical failure. "Cannot allocate memory," "Required configuration missing." Usually followed by program exit.

### Setting the log level — controlling how much you see

```nova
log_set_level("info")    // only show info and above (hides trace and debug)
```

When you set the level to `"info"`, only messages at `info` severity or higher are shown. `trace` and `debug` messages are suppressed. This lets you run with full debug logging during development and minimal logging in production.

You can also set the level via environment variable without changing code:
```
NOVA_LOG=debug nova run app.nova
```

**Level hierarchy** (from least to most severe): `trace` < `debug` < `info` < `warn` < `error` < `fatal`. Setting the level to `"warn"` means only `warn`, `error`, and `fatal` are shown.

### Structured logging — machine-readable JSON output

For production systems where logs are collected and searched by tools like Elasticsearch, Datadog, or Grafana Loki, use JSON-formatted logs:

```nova
log_set_json(true)   // output logs as JSON
log_info("request handled")
// Output: {"level":"info","msg":"request handled","ts":"2026-06-28T12:00:00Z"}
```

---

## 25. Forge: building a REST (Representational State Transfer) API

Forge is NOVA's built-in web framework. It is not an external library — it ships with NOVA's standard library. It compiles to native code and runs at C-level performance, handling HTTP requests with a per-request arena allocator that eliminates GC (Garbage Collection) pauses.

### What makes Forge different from other web frameworks

| Feature | Flask (Python) | Express (Node) | Gin (Go) | Forge (NOVA) |
|---------|----------------|-----------------|----------|---------------|
| Language | Interpreted | JIT | Compiled | Compiled (LLVM) |
| Speed | ~1ms/req | ~0.5ms/req | ~0.1ms/req | ~0.05ms/req |
| Concurrency | GIL (Global Interpreter Lock, 1 core) | Event loop | Goroutines | Green tasks |
| Memory | GC pauses | GC pauses | GC pauses | Arena (zero GC) |
| Type safety | None | None | Compile-time | Compile-time |
| Deploy | Python + pip | Node + npm | Go binary | Single binary |

### The minimal server — your first Forge app

Here is the smallest possible web server in NOVA — three lines of real code:

```nova
import forge

fn main()
    app = forge.app()
    forge.get(app, "/", fn(req) "Hello, World!")
    forge.serve(app, 8080)
```

**Line-by-line breakdown:**

- `import forge` — Loads the Forge web framework module. This gives you access to all the `forge.*` functions.
- `app = forge.app()` — Creates a new web application. Think of `app` as an empty container that you will fill with routes (URL patterns and their handler functions).
- `forge.get(app, "/", fn(req) "Hello, World!")` — Registers a **route**. This tells Forge: "When someone makes an HTTP (HyperText Transfer Protocol) GET request to the URL path `/` (the root), run this function and send its return value as the response." The function `fn(req)` takes one parameter (`req`, the request object) and returns `"Hello, World!"` which Forge sends back to the client.
- `forge.serve(app, 8080)` — Starts the HTTP server on port 8080. This function does NOT return — it runs forever, accepting connections and handling requests. To stop the server, press Ctrl+C.

**To run and test it:**

Step 1 — Run the server:
```
nova run server.nova
```

Step 2 — In another terminal, test with curl:
```
curl http://localhost:8080/
```

Output:
```
Hello, World!
```

**What happens inside `forge.serve()` — step by step:**
1. Forge calls `tcp_listen(8080)` to start listening on port 8080
2. It enters an accept loop, waiting for clients to connect
3. When a client connects, Forge spawns a new green task to handle that client
4. The green task reads the HTTP request, parses the method and path, finds the matching route, calls your handler function, and sends the HTTP response
5. All memory allocated during request handling uses a **per-request arena** — when the request is done, the entire arena is freed in one step (no garbage collection pause, no memory leak)
6. The task ends, and Forge accepts the next client

This is why Forge is fast: per-request arenas mean zero GC pauses, green tasks mean thousands of concurrent connections, and compiled native code means low latency.

### Routes — mapping URLs to handler functions

A **route** connects a URL path to a function that handles requests for that path. You register routes using `forge.get`, `forge.post`, `forge.put`, `forge.patch`, or `forge.delete` — one for each HTTP method:

```nova
import forge

fn main()
    app = forge.app()

    forge.get(app, "/", fn(req) "Home page")
    forge.get(app, "/about", fn(req) "About us")
    forge.post(app, "/submit", fn(req)
        body = forge.body_of(req)
        "Received: {body}"
    )

    forge.serve(app, 8080)
```

**Line-by-line breakdown:**

- `forge.get(app, "/", fn(req) "Home page")` — When a browser visits `http://localhost:8080/`, Forge matches the path `/` and calls this handler. The handler returns the string `"Home page"`, which Forge sends as the HTTP response body.
- `forge.get(app, "/about", fn(req) "About us")` — Same pattern for the `/about` path.
- `forge.post(app, "/submit", fn(req) ...)` — Registers a handler for HTTP POST requests to `/submit`. POST is used when a client is sending data (like a form submission or an API call with a JSON body).
- `body = forge.body_of(req)` — Reads the body of the POST request — the data the client sent.
- `"Received: {body}"` — Returns a response that echoes back what the client sent.

**Available HTTP methods:** `forge.get`, `forge.post`, `forge.put`, `forge.patch`, `forge.delete`. Each one maps to the corresponding HTTP method:
- **GET** — Retrieve data (viewing a page, fetching from an API)
- **POST** — Create new data (submitting a form, creating a record)
- **PUT** — Replace existing data (full update)
- **PATCH** — Partially update existing data (change one field)
- **DELETE** — Remove data

> **DO:** Use `forge.get` for reading data and `forge.post` for creating data — follow HTTP conventions.
> **DON'T:** Use `forge.get` for operations that change data (like deleting a user) — that breaks HTTP semantics and can cause bugs with browser caching and prefetching.

### Path parameters — capturing parts of the URL

```nova
forge.get(app, "/users/:id", fn(req)
    id = forge.query_get(req, "id")
    "User profile for ID: {id}"
)

// curl http://localhost:8080/users/42
// Output: User profile for ID: 42
```

The `:id` segment captures that part of the URL and makes it available via `query_get`.

### Query parameters — reading ?key=value from the URL

```nova
forge.get(app, "/search", fn(req)
    q = forge.query_get(req, "q")
    page = forge.query_get(req, "page")
    "Searching for '{q}' on page {page}"
)

// curl "http://localhost:8080/search?q=nova&page=2"
// Output: Searching for 'nova' on page 2
```

### Request body — reading what the client sent

```nova
forge.post(app, "/echo", fn(req)
    body = forge.body_of(req)
    "You sent: {body}"
)

// curl -X POST -d "hello world" http://localhost:8080/echo
// Output: You sent: hello world
```

### Returning JSON

Forge automatically serializes structs to JSON when you return them:

```nova
import forge

type User
    name: string
    age: int

fn main()
    app = forge.app()

    forge.get(app, "/user", fn(req)
        u = User { name: "Alice", age: 30 }
        forge.json(to_json(u))
    )

    forge.serve(app, 8080)
```

```
curl http://localhost:8080/user
```

Output:
```json
{"name":"Alice","age":30}
```

The response automatically gets `Content-Type: application/json`.

### Typed request body — parsing JSON into structs

When a client sends JSON data in a POST request, you can parse it directly into a NOVA struct using `body_as()`. This is called "typed extraction" — the JSON is automatically converted into a struct with named, typed fields:

```nova
import forge

type CreateUser
    name: string
    age: int

fn main()
    app = forge.app()

    forge.post(app, "/users", fn(req)
        user = body_as(req, CreateUser)
        forge.json(to_json(user))
    )

    forge.serve(app, 8080)
```

**Line-by-line breakdown:**

- `type CreateUser` — Declares a struct type that matches the shape of the JSON the client will send. The field names (`name`, `age`) must match the JSON keys.
- `forge.post(app, "/users", fn(req) ...)` — Registers a POST handler for `/users`.
- `user = body_as(req, CreateUser)` — This is the key line. `body_as` reads the request body as JSON, and converts it into a `CreateUser` struct. If the JSON has `{"name":"Bob","age":25}`, then `user.name` is `"Bob"` and `user.age` is `25`. If the JSON is malformed or missing required fields, `body_as` returns an error.
- `forge.json(to_json(user))` — Converts the struct back to JSON and sends it as the response. This echoes back what the client sent — useful for confirming the server received the data correctly.

**Testing with curl:**

```
curl -X POST -H "Content-Type: application/json" \
     -d '{"name":"Bob","age":25}' \
     http://localhost:8080/users
```

Output:
```json
{"name":"Bob","age":25}
```

> **DO:** Use `body_as(req, Type)` to parse JSON request bodies. The struct definition serves as documentation AND validation of the expected shape.
> **DON'T:** Manually parse JSON with `json_decode` and then access keys by string — that is error-prone and you lose type safety.

### A complete CRUD (Create, Read, Update, Delete) REST API

This is a complete, production-style REST API (Application Programming Interface) for managing a to-do list. It supports all four CRUD operations: creating todos, listing them, updating them, and deleting them. This is ~30 lines of code that does what would take 100+ lines in Flask or Express:

```nova
import forge

type Todo
    id: int
    title: string
    done: bool

fn main()
    app = forge.app()
    todos = []
    next_id = 1

    // List all todos
    forge.get(app, "/todos", fn(req)
        forge.json(to_json(todos))
    )

    // Create a todo
    forge.post(app, "/todos", fn(req)
        body = forge.body_json(req)
        todo = Todo {
            id: next_id,
            title: body["title"],
            done: false
        }
        push(todos, todo)
        next_id = next_id + 1
        forge.json(to_json(todo))
    )

    // Get a single todo
    forge.get(app, "/todos/:id", fn(req)
        id = int(forge.query_get(req, "id"))
        for t in todos
            if t.id == id
                return forge.json(to_json(t))
        forge.not_found("todo not found")
    )

    // Update a todo
    forge.put(app, "/todos/:id", fn(req)
        id = int(forge.query_get(req, "id"))
        body = forge.body_json(req)
        for t in todos
            if t.id == id
                t.title = body["title"]
                t.done = body["done"]
                return forge.json(to_json(t))
        forge.not_found("todo not found")
    )

    // Delete a todo
    forge.delete(app, "/todos/:id", fn(req)
        id = int(forge.query_get(req, "id"))
        todos = filter(todos, t => t.id != id)
        forge.json("{\"deleted\": true}")
    )

    print("Todo API running on http://localhost:8080")
    forge.serve(app, 8080)
```

**Line-by-line breakdown of each handler:**

**Setup:**
- `type Todo` — Defines the data structure for a to-do item with three fields: a unique integer `id`, a `title` string, and a `done` boolean.
- `todos = []` — An in-memory list to store all todos. In a real app, you would use a database (see the [SQLite section](#26-forge-database-with-sqlite)).
- `next_id = 1` — A counter to generate unique IDs for new todos.

**CREATE (POST /todos) — Add a new todo:**
- `body = forge.body_json(req)` — Parses the request body as JSON and returns a dict. If the client sends `{"title":"Learn NOVA"}`, then `body` is a dict where `body["title"]` is `"Learn NOVA"`.
- `todo = Todo { id: next_id, title: body["title"], done: false }` — Creates a new `Todo` struct with the next available ID, the title from the request, and `done` set to `false`.
- `push(todos, todo)` — Adds the new todo to the in-memory list.
- `next_id = next_id + 1` — Increments the ID counter for the next todo.
- `forge.json(to_json(todo))` — Converts the todo struct to JSON and sends it as the response.

**READ (GET /todos/:id) — Get one todo by ID:**
- `id = int(forge.query_get(req, "id"))` — Extracts the `:id` path parameter and converts it to an integer. If the URL is `/todos/3`, then `id` is `3`.
- `for t in todos` / `if t.id == id` — Loops through all todos looking for one with a matching ID.
- `return forge.json(to_json(t))` — If found, sends it as JSON and returns immediately (the `return` exits the handler function).
- `forge.not_found("todo not found")` — If the loop finishes without finding a match, sends a 404 response.

**UPDATE (PUT /todos/:id) — Modify an existing todo:**
- Extracts the ID and the new data from the request body, finds the matching todo, updates its fields in place, and returns the updated todo.

**DELETE (DELETE /todos/:id) — Remove a todo:**
- `todos = filter(todos, t => t.id != id)` — Replaces the `todos` list with a new list that excludes the todo with the matching ID. `filter` keeps only elements where the predicate returns `true` — in this case, todos whose ID does NOT match the one being deleted.

**Test it with curl:**

Test it:
```bash
# Create a todo
curl -X POST -H "Content-Type: application/json" \
     -d '{"title":"Learn NOVA"}' http://localhost:8080/todos

# List all todos
curl http://localhost:8080/todos

# Update a todo
curl -X PUT -H "Content-Type: application/json" \
     -d '{"title":"Learn NOVA","done":true}' http://localhost:8080/todos/1

# Delete a todo
curl -X DELETE http://localhost:8080/todos/1
```

### Middleware — code that runs on every request

Middleware is code that wraps ALL requests. It runs before and/or after your route handler, letting you add behavior like logging, authentication checks, CORS (Cross-Origin Resource Sharing) headers, or timing — without repeating that code in every handler.

Think of middleware like security guards at a building entrance: every visitor passes through them before reaching any office.

```nova
import forge

fn main()
    app = forge.app()

    // Built-in middleware — each one wraps all routes
    forge.use(app, forge.mw_cors())            // CORS (Cross-Origin Resource Sharing) headers
    forge.use(app, forge.mw_logger())          // request logging
    forge.use(app, forge.mw_security_headers()) // security headers
    forge.use(app, forge.mw_request_id())      // X-Request-ID header

    forge.get(app, "/", fn(req) "Hello!")
    forge.serve(app, 8080)
```

**Line-by-line breakdown:**

- `forge.use(app, forge.mw_cors())` — Adds CORS middleware. CORS headers tell browsers "it is okay for websites on other domains to call this API." Without CORS, a JavaScript frontend on `myapp.com` would be blocked from calling an API on `api.myapp.com`.
- `forge.use(app, forge.mw_logger())` — Adds logging middleware. Every request is logged with the method, path, status code, and time taken. Example log line: `GET /users 200 2ms`.
- `forge.use(app, forge.mw_security_headers())` — Adds security headers like `X-Content-Type-Options: nosniff`, `X-Frame-Options: DENY`, etc. These headers protect against common web attacks.
- `forge.use(app, forge.mw_request_id())` — Adds a unique `X-Request-ID` header to every response. This is useful for debugging — if a user reports a bug, you can find the exact request in your logs by its ID.

Middleware runs in the order you register it. The first `forge.use` runs first (outermost), and the last one runs last (closest to the route handler).

### Custom middleware — writing your own

You can write your own middleware. A middleware function takes two parameters: the request (`req`) and a `next` function. You call `next(req)` to pass the request to the next middleware or the route handler, and then you can modify the response before returning it:

```nova
fn mw_timing(req, next)
    start = time_ms()
    response = next(req)
    elapsed = time_ms() - start
    print("Request took {elapsed}ms")
    response

fn main()
    app = forge.app()
    forge.use(app, fn(req, next) mw_timing(req, next))
    forge.get(app, "/", fn(req) "Hello!")
    forge.serve(app, 8080)
```

**Line-by-line breakdown:**

- `fn mw_timing(req, next)` — A custom middleware function. `req` is the incoming request, `next` is a function that calls the next middleware or route handler.
- `start = time_ms()` — Records the time before the request is processed.
- `response = next(req)` — Passes the request to the next middleware/handler and gets the response back. Everything between `start` and this line is "before the handler runs"; everything after is "after the handler runs."
- `elapsed = time_ms() - start` — Computes how long the handler took.
- `print("Request took {elapsed}ms")` — Logs the timing.
- `response` — Returns the response unchanged. If you wanted to modify the response (add headers, change the body), you could do so here.

### Error responses

When something goes wrong, send the appropriate HTTP error status code:

```nova
forge.get(app, "/users/:id", fn(req)
    id = int(forge.query_get(req, "id"))
    user = find_user(id)
    if user == null
        return forge.not_found("User {id} not found")
    if not authorized(req)
        return forge.resp_error(403, "Forbidden")
    forge.json(to_json(user))
)
```

**Line-by-line breakdown:**

- `user = find_user(id)` — Looks up the user. If not found, returns `null`.
- `forge.not_found("User {id} not found")` — Sends a 404 (Not Found) response with the message. The `return` exits the handler early — the `forge.json` line below is NOT reached.
- `forge.resp_error(403, "Forbidden")` — Sends a 403 (Forbidden) response. Use this when the user exists but is not allowed to access the resource.
- `forge.json(to_json(user))` — Only reached if the user was found AND authorized.

**Available error helpers:**

| Function | HTTP Status | When to use |
|----------|-------------|-------------|
| `forge.bad_request(msg)` | 400 | Client sent invalid data (malformed JSON, missing field) |
| `forge.not_found(msg)` | 404 | The requested resource does not exist |
| `forge.internal_error(msg)` | 500 | Something went wrong on the server |
| `forge.resp_error(code, msg)` | Any code | Custom status code (401 Unauthorized, 403 Forbidden, 429 Too Many Requests, etc.) |

---

## 26. Forge: SQLite data layer

### What is SQLite?

SQLite is a lightweight database engine that stores all data in a single file (like `app.db`). Unlike MySQL or PostgreSQL (which require installing and running a separate server), SQLite needs nothing — it is embedded directly into your application. This makes it perfect for prototyping, small-to-medium applications, and any program that needs persistent data without the complexity of a database server.

NOVA includes SQLite support through the `forge_db` module. You can create tables, insert data, query data, and handle transactions — all with a simple, safe API that prevents SQL (Structured Query Language) injection attacks.

### Opening a database connection

```nova
import forge
import forge_db

fn main()
    db = pool_open("app.db")
```

**Line-by-line breakdown:**

- `import forge_db` — Loads the database module, which gives you access to `pool_open`, `pool_exec`, `pool_query_dicts`, etc.
- `db = pool_open("app.db")` — Opens (or creates) a SQLite database file called `app.db` in the current directory. If the file does not exist, SQLite creates it automatically. The returned `db` value is a connection pool that you pass to all subsequent database functions.

### Creating tables

```nova
pool_exec(db, "CREATE TABLE IF NOT EXISTS users (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, email TEXT UNIQUE NOT NULL)")
```

**Line-by-line breakdown:**

- `pool_exec(db, ...)` — Executes a SQL statement that does not return data (CREATE, INSERT, UPDATE, DELETE). The first argument is the database connection from `pool_open`.
- `CREATE TABLE IF NOT EXISTS users (...)` — Standard SQL that creates a table called `users` if it does not already exist. The columns are: `id` (auto-incrementing integer, the unique identifier), `name` (text, required), and `email` (text, required and must be unique).

### Parameterized queries — preventing SQL injection

**Always use parameterized queries.** Never concatenate user input into SQL strings.

```nova
// CORRECT: parameterized (safe from SQL injection)
pool_exec(db, "INSERT INTO users (name, email) VALUES (?, ?)", [name, email])

// WRONG: string concatenation (SQL INJECTION VULNERABILITY)
// pool_exec(db, "INSERT INTO users (name, email) VALUES ('" + name + "', '" + email + "')")
// If name = "'; DROP TABLE users;--" your database is gone
```

### Querying rows

`pool_query_dicts` runs a SELECT query and returns the results as a list of dicts (one dict per row, where keys are column names):

```nova
// Get all rows as list of dicts
users = pool_query_dicts(db, "SELECT * FROM users")
for user in users
    print("{user[\"name\"]}: {user[\"email\"]}")

// Query with parameters (safe from SQL injection)
results = pool_query_dicts(db, "SELECT * FROM users WHERE name = ?", ["Alice"])
```

**Line-by-line breakdown:**

- `users = pool_query_dicts(db, "SELECT * FROM users")` — Runs the SQL query and returns all rows as a list. Each row is a dict like `{"id": 1, "name": "Alice", "email": "alice@example.com"}`. If the table is empty, returns an empty list `[]`.
- `for user in users` — Loops through each row (each dict).
- `user[\"name\"]` — Accesses the `name` column of the current row. The `\"` is needed because the key is a string inside a string.
- `pool_query_dicts(db, "... WHERE name = ?", ["Alice"])` — Parameterized query. The `?` is replaced with `"Alice"` safely. Always use `?` placeholders — never concatenate user input into SQL.

### Transactions — all-or-nothing database operations

A transaction groups multiple database operations so they either ALL succeed or ALL fail. If the third insert fails, the first two are automatically undone (rolled back). This prevents your database from ending up in an inconsistent state:

```nova
with_tx(db, fn(tx)
    tx("INSERT INTO users (name, email) VALUES (?, ?)", ["Alice", "alice@example.com"])
    tx("INSERT INTO users (name, email) VALUES (?, ?)", ["Bob", "bob@example.com"])
    // if either insert fails, BOTH are rolled back — the database is unchanged
)
```

**Line-by-line breakdown:**

- `with_tx(db, fn(tx) ...)` — Starts a transaction. The closure receives a `tx` function that you use instead of `pool_exec`. When the closure returns, the transaction is committed (all changes are saved). If the closure throws an error, the transaction is rolled back (all changes are undone).
- `tx("INSERT ...", ["Alice", ...])` — Executes an INSERT inside the transaction. This is tentative — it is not saved to disk until the transaction commits.
- If the second `tx(...)` call fails (e.g., because Bob's email already exists and violates the UNIQUE constraint), the first INSERT is also rolled back. Alice is NOT added to the database. This is the "all-or-nothing" guarantee.

### A complete Forge API with SQLite

```nova
import forge
import forge_db

type User
    id: int
    name: string
    email: string

fn main()
    db = pool_open("app.db")
    pool_exec(db, "CREATE TABLE IF NOT EXISTS users (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, email TEXT UNIQUE NOT NULL)")

    app = forge.app()

    forge.get(app, "/users", fn(req)
        users = pool_query_dicts(db, "SELECT * FROM users")
        forge.json(to_json(users))
    )

    forge.post(app, "/users", fn(req)
        body = forge.body_json(req)
        pool_exec(db, "INSERT INTO users (name, email) VALUES (?, ?)",
            [body["name"], body["email"]])
        forge.json("{\"created\": true}")
    )

    forge.get(app, "/users/:id", fn(req)
        id = forge.query_get(req, "id")
        rows = pool_query_dicts(db, "SELECT * FROM users WHERE id = ?", [id])
        if len(rows) == 0
            return forge.not_found("user not found")
        forge.json(to_json(rows[0]))
    )

    forge.delete(app, "/users/:id", fn(req)
        id = forge.query_get(req, "id")
        pool_exec(db, "DELETE FROM users WHERE id = ?", [id])
        forge.json("{\"deleted\": true}")
    )

    forge.serve(app, 8080)
```

---

## 27. Forge: WebSocket and SSE (Server-Sent Events)

### What is WebSocket?

WebSocket is a protocol that enables two-way, real-time communication between a browser and a server. Unlike regular HTTP (where the client sends a request and the server sends one response), WebSocket keeps a persistent connection open — both sides can send messages to each other at any time. This is essential for:

- **Chat applications** — messages appear instantly without the user refreshing the page
- **Live dashboards** — stock prices, server metrics, notifications update in real time
- **Multiplayer games** — game state is synchronized between players instantly
- **Collaborative editing** — multiple users editing the same document simultaneously

### WebSocket echo server

The simplest WebSocket server receives a message and sends it back:

```nova
import forge

fn main()
    app = forge.app()

    forge.ws(app, "/ws", fn(ws, msg)
        ws_emit(ws, "ECHO: {msg}")
    )

    forge.serve(app, 8080)
```

**Line-by-line breakdown:**

- `forge.ws(app, "/ws", fn(ws, msg) ...)` — Registers a WebSocket handler at the path `/ws`. Unlike `forge.get` (which handles one request and returns a response), `forge.ws` sets up a persistent connection. The handler function `fn(ws, msg)` is called every time the connected client sends a message. `ws` is the WebSocket connection object, and `msg` is the message text the client sent.
- `ws_emit(ws, "ECHO: {msg}")` — Sends a message back to the client through the WebSocket connection. The client receives `"ECHO: hello"` if they sent `"hello"`.

**Testing from a browser console:**
```javascript
// Open the browser developer tools (F12), go to Console, and type:
const ws = new WebSocket("ws://localhost:8080/ws");
ws.onmessage = (e) => console.log(e.data);
ws.send("hello");   // Console logs: "ECHO: hello"
```

### Broadcasting with a hub — multi-client chat

A **hub** lets you broadcast messages to ALL connected clients at once. This is how chat rooms work — when one person types a message, everyone in the room sees it:

```nova
import forge

fn main()
    app = forge.app()
    hub = forge.hub()

    forge.ws_room(app, "/chat", hub, fn(ws, msg, hub)
        room_say(hub, "Someone said: {msg}")
    )

    forge.serve(app, 8080)
```

**Line-by-line breakdown:**

- `hub = forge.hub()` — Creates a broadcast hub. Think of it as a public address system — any message sent to the hub is delivered to everyone connected.
- `forge.ws_room(app, "/chat", hub, fn(ws, msg, hub) ...)` — Registers a WebSocket handler that is connected to the hub. Every client that connects to `/chat` automatically joins the hub.
- `room_say(hub, "Someone said: {msg}")` — Broadcasts the message to ALL clients connected to this hub. If 50 users are in the chat room, all 50 see the message.

Every message sent by any client is broadcast to all connected clients — that is the power of the hub pattern.

### Server-Sent Events (SSE)

SSE (Server-Sent Events) is a simpler alternative to WebSocket for **one-way** streaming — the server pushes updates to the client, but the client cannot send messages back. This is perfect for live feeds, notifications, log streaming, and progress updates:

```nova
import forge

fn main()
    app = forge.app()

    forge.sse(app, "/events", fn(req, send)
        i = 0
        while i < 10
            sse_send(send, "tick {i}")
            sleep(1000)
            i = i + 1
    )

    forge.serve(app, 8080)
```

```bash
curl http://localhost:8080/events
# Output (streamed):
# data: tick 0
# (1 second pause)
# data: tick 1
# ...
```

---

## 28. Forge: authentication

### JWT (JSON Web Token) authentication

```nova
import forge

fn main()
    app = forge.app()
    secret = env("JWT_SECRET")

    // Login — issue a token
    forge.post(app, "/login", fn(req)
        body = forge.body_json(req)
        // (in production, verify credentials against database)
        if body["username"] == "admin" and body["password"] == "secret"
            token = forge.jwt_encode({"sub": "admin", "role": "admin"}, secret)
            forge.json("{\"token\": \"{token}\"}")
        else
            forge.resp_error(401, "invalid credentials")
    )

    // Protected route
    forge.get(app, "/admin", fn(req)
        token = forge.bearer_token(req)
        claims = forge.jwt_verify(token, secret)
        if claims == null
            return forge.resp_error(401, "invalid token")
        forge.json("{\"message\": \"Welcome, {claims[\"sub\"]}!\"}")
    )

    forge.serve(app, 8080)
```

**Line-by-line breakdown:**

- `secret = env("JWT_SECRET")` — Reads the JWT secret key from an environment variable. In production, NEVER hardcode secrets in source code. Set the environment variable before running: `JWT_SECRET=my-secret-key-here nova run app.nova`.
- **Login handler:**
  - `body = forge.body_json(req)` — Parses the login request (username + password).
  - `if body["username"] == "admin" and body["password"] == "secret"` — Checks credentials. In a real app, you would look up the user in a database and compare a hashed password.
  - `token = forge.jwt_encode({"sub": "admin", "role": "admin"}, secret)` — Creates a JWT token. The first argument is the "claims" — the data embedded in the token. `"sub"` (subject) is the user's identity, `"role"` is their role. The `secret` is used to sign the token so it cannot be forged.
  - `forge.json("{\"token\": \"{token}\"}")` — Sends the token back to the client.
  - `forge.resp_error(401, "invalid credentials")` — If the credentials are wrong, sends a 401 (Unauthorized) response.
- **Protected route:**
  - `token = forge.bearer_token(req)` — Extracts the JWT token from the `Authorization: Bearer <token>` header sent by the client.
  - `claims = forge.jwt_verify(token, secret)` — Verifies the token's signature using the secret key. If the token is valid and not expired, returns the claims (the data embedded in the token). If invalid, returns `null`.
  - `if claims == null` / `return forge.resp_error(401, ...)` — If the token is invalid, reject the request.
  - `claims["sub"]` — Reads the `"sub"` (subject) claim from the verified token to identify the user.

**Testing with curl:**

```bash
# Step 1: Login to get a token
TOKEN=$(curl -s -X POST -H "Content-Type: application/json" \
  -d '{"username":"admin","password":"secret"}' \
  http://localhost:8080/login | jq -r .token)

# Step 2: Access the protected route with the token
curl -H "Authorization: Bearer $TOKEN" http://localhost:8080/admin
# Output: {"message": "Welcome, admin!"}

# Step 3: Try without a token — should fail
curl http://localhost:8080/admin
# Output: 401 invalid token
```

### Protected routes with middleware

Instead of checking the JWT token in every handler, use middleware to protect all routes at once:

```nova
forge.use(app, forge.mw_require_auth(secret))
// Now ALL routes require a valid JWT token in the Authorization header
// Requests without a valid token are rejected with 401 before reaching any handler
```

### CSRF (Cross-Site Request Forgery) protection

#### What is CSRF?

CSRF is an attack where a malicious website tricks your browser into making requests to YOUR application using YOUR cookies. For example, if you are logged into your bank, a malicious website could submit a form to your bank's "transfer money" endpoint using your session. The bank sees your valid session cookie and processes the transfer.

CSRF protection works by generating a unique token for each form. When the form is submitted, the server verifies the token matches. A malicious website cannot know the token, so its forged requests are rejected.

```nova
import forge

fn main()
    app = forge.app()
    forge.use(app, forge.mw_csrf())

    forge.get(app, "/form", fn(req)
        token = forge.csrf_token(req)
        forge.html("<form method='POST' action='/submit'>" +
            "<input type='hidden' name='_csrf' value='{token}'>" +
            "<input type='text' name='data'>" +
            "<button>Submit</button>" +
            "</form>")
    )

    forge.post(app, "/submit", fn(req)
        // CSRF token is automatically verified by mw_csrf
        data = forge.body_form(req)
        forge.text("Received: {data[\"data\"]}")
    )

    forge.serve(app, 8080)
```

**Line-by-line breakdown:**

- `forge.use(app, forge.mw_csrf())` — Enables CSRF protection on all POST/PUT/DELETE routes. Every form submission must include a valid CSRF token.
- `token = forge.csrf_token(req)` — Generates a unique token for this request. The token is tied to the user's session.
- `<input type='hidden' name='_csrf' value='{token}'>` — Embeds the token as a hidden field in the HTML form. When the user submits the form, the token is sent along with the form data.
- The `mw_csrf` middleware automatically checks the `_csrf` field on POST requests. If the token is missing or invalid, the request is rejected with a 403 (Forbidden) response.

---

## 29. Forge: HTML (HyperText Markup Language) builder

### What is an HTML builder?

Instead of writing raw HTML strings (which are error-prone — you might forget to close a tag, or accidentally introduce an XSS (Cross-Site Scripting) vulnerability), Forge provides functions that generate correct HTML programmatically. Each function corresponds to an HTML tag: `h` for any heading, `p` for paragraphs, `div` for containers, `ul`/`li` for lists, etc.

This is similar to React's JSX (JavaScript XML) or Elm's HTML modules, but without a separate template language — it is just NOVA functions that return strings.

### Building a page

```nova
import forge
import forge_html

fn main()
    app = forge.app()

    forge.get(app, "/page", fn(req)
        page = html([
            h("h1", "Welcome to NOVA"),
            p("This is a paragraph."),
            div([
                h("h2", "Features"),
                ul([
                    li("Fast — C-level performance"),
                    li("Safe — no data races"),
                    li("Simple — simpler than Python")
                ])
            ]),
            a("https://nova-lang.org", "Learn more")
        ])
        forge.html(page)
    )

    forge.serve(app, 8080)
```

**Line-by-line breakdown:**

- `import forge_html` — Loads the HTML builder functions.
- `page = html([...])` — Creates a complete HTML document. The argument is a list of HTML elements. Each element is created by calling one of the builder functions.
- `h("h1", "Welcome to NOVA")` — Creates an `<h1>Welcome to NOVA</h1>` heading. The first argument is the tag name, the second is the content.
- `p("This is a paragraph.")` — Creates a `<p>This is a paragraph.</p>` element.
- `div([...])` — Creates a `<div>` container with child elements. The argument is a list of children.
- `ul([li("Fast"), li("Safe"), li("Simple")])` — Creates an unordered list (`<ul>`) with three list items (`<li>`).
- `a("https://nova-lang.org", "Learn more")` — Creates a link: `<a href="https://nova-lang.org">Learn more</a>`.
- `forge.html(page)` — Sends the generated HTML string as the HTTP response with `Content-Type: text/html`.

### Available HTML functions

| Function | HTML output | Example |
|----------|------------|---------|
| `h("h1", text)` | `<h1>text</h1>` | Any heading (h1-h6) |
| `p(text)` | `<p>text</p>` | Paragraph |
| `div(children)` | `<div>...</div>` | Container |
| `span(text)` | `<span>text</span>` | Inline container |
| `ul(items)` / `ol(items)` | `<ul>...</ul>` | Unordered/ordered list |
| `li(text)` | `<li>text</li>` | List item |
| `a(url, text)` | `<a href="url">text</a>` | Link |
| `img(src)` | `<img src="src">` | Image |
| `table(rows)` | `<table>...</table>` | Table |
| `tr(cells)` / `td(text)` / `th(text)` | Table rows and cells | |
| `form(children)` | `<form>...</form>` | Form |
| `input_tag(type, name)` | `<input type="..." name="...">` | Input field |
| `button(text)` | `<button>text</button>` | Button |
| `code(text)` / `pre(text)` | `<code>` / `<pre>` | Code formatting |
| `em(text)` / `strong(text)` | `<em>` / `<strong>` | Emphasis / bold |
| `br()` / `hr()` | `<br>` / `<hr>` | Line break / horizontal rule |
| `raw(html_string)` | verbatim | Insert raw HTML (use carefully!) |

> **DO:** Use the HTML builder functions for generating HTML in your handlers — they produce correct, well-formed HTML.
> **DON'T:** Use `raw()` with user input — that allows XSS attacks. Only use `raw()` for trusted, pre-built HTML strings.

---

## 30. Forge: advanced features

### Input validation — checking user data

When users submit data (registration forms, API requests), you must validate it before processing. Never trust user input. Forge provides a declarative validation system:

```nova
import forge

fn main()
    app = forge.app()

    forge.post(app, "/register", fn(req)
        body = forge.body_json(req)
        errors = forge.validate(body, {
            "email": [forge.required(), forge.email()],
            "password": [forge.required(), forge.min_len(8)],
            "role": [forge.one_of(["user", "admin"])]
        })
        if len(errors) > 0
            return forge.errors_response(errors)
        // ... create user ...
        forge.json("{\"created\": true}")
    )
```

**Line-by-line breakdown:**

- `body = forge.body_json(req)` — Parses the JSON request body into a dict.
- `errors = forge.validate(body, {...})` — Validates the body against a set of rules. The second argument is a dict where each key is a field name and the value is a list of validation rules.
- `"email": [forge.required(), forge.email()]` — The `email` field must be present (`required()`) and must be a valid email address format (`email()`).
- `"password": [forge.required(), forge.min_len(8)]` — The `password` field must be present and at least 8 characters long.
- `"role": [forge.one_of(["user", "admin"])]` — The `role` field, if present, must be either `"user"` or `"admin"`.
- `if len(errors) > 0` — If any validation rule failed, `errors` is a non-empty list of error messages.
- `forge.errors_response(errors)` — Returns a 400 (Bad Request) response with the validation errors as JSON.

**Available validation rules:** `forge.required()`, `forge.min_len(n)`, `forge.max_len(n)`, `forge.email()`, `forge.one_of(options)`, `forge.min_val(n)`, `forge.max_val(n)`, `forge.matches(regex)`.

### Rate limiting — preventing abuse

Rate limiting restricts how many requests a single client can make in a time window. This prevents denial-of-service attacks and API abuse:

```nova
forge.use(app, forge.mw_rate_limit(100, 60))  // 100 requests per 60 seconds per client
```

If a client exceeds 100 requests in 60 seconds, subsequent requests receive a 429 (Too Many Requests) response until the window resets.

### CORS (Cross-Origin Resource Sharing)

CORS headers tell browsers which websites are allowed to call your API. Without CORS headers, a JavaScript frontend on `mysite.com` cannot call an API on `api.mysite.com`:

```nova
forge.use(app, forge.mw_cors())                      // allow ALL origins (development)
forge.use(app, forge.mw_cors_origin("example.com"))   // allow only example.com (production)
```

> **DO:** Use `forge.mw_cors_origin("yourdomain.com")` in production to restrict which websites can call your API.
> **DON'T:** Use `forge.mw_cors()` (allow all origins) in production — it lets any website make requests to your API, which may be a security risk.

### Static files — serving CSS (Cascading Style Sheets), JavaScript, images

```nova
forge.get(app, "/static/:file", fn(req)
    filename = forge.query_get(req, "file")
    forge.serve_file("public/" + filename)
)
```

**Line-by-line breakdown:**

- `/static/:file` — The `:file` part is a path parameter. A request to `/static/style.css` sets `file` to `"style.css"`.
- `forge.serve_file("public/" + filename)` — Reads the file from the `public/` directory and sends it as the response with the correct Content-Type header.

### Response headers and cookies

You can set custom HTTP headers and cookies on responses:

```nova
forge.get(app, "/", fn(req)
    resp = forge.resp_text("Hello")
    forge.resp_set_header(resp, "X-Custom", "value")
    forge.resp_set_cookie(resp, "session", "abc123")
    resp
)
```

**Line-by-line breakdown:**

- `resp = forge.resp_text("Hello")` — Creates a response object with body `"Hello"`. Instead of returning a string directly, you create a response object so you can modify headers and cookies.
- `forge.resp_set_header(resp, "X-Custom", "value")` — Adds a custom HTTP header to the response.
- `forge.resp_set_cookie(resp, "session", "abc123")` — Sets a cookie named `"session"` with value `"abc123"`. The browser will send this cookie back with every subsequent request.
- `resp` — Returns the modified response object.

### OpenAPI (Open Application Programming Interface) documentation

OpenAPI is a standard for describing REST APIs. Forge can auto-generate an OpenAPI 3.0 specification and serve a Swagger UI (a web-based API documentation viewer):

```nova
import forge

fn main()
    app = forge.app()
    forge.enable_docs(app)    // enables /openapi.json and /docs (Swagger UI)

    forge.get_doc(app, "/users", "List all users", fn(req)
        forge.json("[]")
    )

    forge.post_doc(app, "/users", "Create a user", fn(req)
        forge.json("{\"id\": 1}")
    )

    forge.serve(app, 8080)
```

**Line-by-line breakdown:**

- `forge.enable_docs(app)` — Enables two routes automatically: `/openapi.json` (the machine-readable API spec) and `/docs` (a human-readable Swagger UI page).
- `forge.get_doc(app, "/users", "List all users", fn(req) ...)` — Like `forge.get`, but also registers the route in the OpenAPI spec with the description `"List all users"`. The description appears in the Swagger UI.
- Visit `http://localhost:8080/docs` in your browser to see a beautiful, interactive API documentation page where you can test your endpoints.

### Health checks — for load balancers and container orchestration

Kubernetes, Docker Swarm, and load balancers need endpoints to check if your application is running and ready to serve traffic:

```nova
forge.health_route(app, "/health")    // returns {"status": "ok"} — is the app alive?
forge.readyz_route(app, "/readyz")    // returns {"status": "ready"} — is the app ready for traffic?
```

### Compression

Automatically compress responses with gzip to reduce bandwidth:

```nova
forge.use(app, forge.mw_compress())   // gzip responses automatically
```

The middleware checks the `Accept-Encoding` header from the client. If the client supports gzip, the response is compressed. This typically reduces response sizes by 60-80%.

### Request metrics — monitoring in production

Expose Prometheus-compatible metrics for monitoring tools:

```nova
forge.use(app, forge.mw_metrics())
forge.get(app, "/metrics", fn(req)
    forge.text(forge.metrics_prometheus())
)
```

The `/metrics` endpoint returns data like request counts, latencies, and error rates in Prometheus format, which can be scraped by monitoring tools like Grafana.

---

## 31. FFI (Foreign Function Interface): calling C

### What is FFI?

FFI (Foreign Function Interface) lets NOVA call functions written in other languages — primarily C. This is essential because decades of C libraries exist for everything from database engines to image processing to hardware drivers. Instead of rewriting all of that, NOVA can call it directly.

Think of FFI as a bridge: NOVA code on one side, C code on the other, and `extern fn` is the bridge between them.

### Basic FFI — declaring a C function

```nova
extern fn puts(s: string) -> int

puts("Hello from C!")
```

**Line-by-line breakdown:**

- `extern fn puts(s: string) -> int` — This declares that a C function called `puts` exists. `extern fn` tells the compiler: "I am not defining this function — it is defined somewhere else (in a C library), and here is its type signature." The compiler generates code to call this C function at the call site. NOVA links against the C standard library by default, and `puts` is part of it.
- `puts("Hello from C!")` — Calls the C function `puts` with a NOVA string. NOVA automatically converts the string to a C-compatible `char*` pointer.

### Calling C math functions

```nova
extern fn pow(base: float, exp: float) -> float
extern fn sin(x: float) -> float
extern fn cos(x: float) -> float

print(pow(2.0, 10.0))    // 1024.0
print(sin(3.14159))      // ~0.0
```

**Line-by-line breakdown:**

- `extern fn pow(base: float, exp: float) -> float` — Declares the C `pow` function from `<math.h>`. Takes two `double` arguments (NOVA `float` = C `double`) and returns a `double`.
- `pow(2.0, 10.0)` — Calls the C function. 2.0^10.0 = 1024.0. NOVA's `float` maps directly to C's `double` (both are 64-bit IEEE 754), so no conversion is needed.

### Linking external libraries

To call functions from a library that is not part of the C standard library, use `@link`:

```nova
extern fn sqlite3_open(path: string, db: ptr) -> int
extern fn sqlite3_exec(db: ptr, sql: string, cb: ptr, arg: ptr, err: ptr) -> int
extern fn sqlite3_close(db: ptr) -> int

@link("sqlite3")
```

**Line-by-line breakdown:**

- `extern fn sqlite3_open(path: string, db: ptr) -> int` — Declares the `sqlite3_open` function from the SQLite library. The `ptr` type represents a raw C pointer — NOVA does not know or care what it points to.
- `@link("sqlite3")` — Tells the linker: "When building the final executable, link against the SQLite library (`libsqlite3.so` on Linux, `sqlite3.lib` on Windows)." Without this, the linker would fail with "undefined reference to sqlite3_open."

### unsafe blocks — when C can break NOVA's guarantees

NOVA is memory-safe by default — you cannot corrupt memory, read uninitialized values, or cause undefined behavior. But C functions can do all of those things. When you need raw memory operations, wrap them in an `unsafe` block:

```nova
unsafe
    ptr = alloc_raw(1024)       // allocate 1024 bytes of raw memory
    ptr_write(ptr, 0, 42)      // write the value 42 at offset 0
    val = ptr_read(ptr, 0)     // read the value at offset 0
    free_raw(ptr)               // free the memory
```

**Line-by-line breakdown:**

- `unsafe` — Starts an unsafe block. Code inside `unsafe` can perform operations that might corrupt memory if used incorrectly. The `unsafe` keyword is a signal to you and anyone reading your code: "This section needs extra care."
- `alloc_raw(1024)` — Allocates 1024 bytes of raw, uninitialized memory. Returns a raw pointer. This is like C's `malloc(1024)`.
- `ptr_write(ptr, 0, 42)` — Writes the integer `42` at byte offset `0` in the allocated memory. If you write beyond the allocated size, you get undefined behavior (buffer overflow).
- `ptr_read(ptr, 0)` — Reads back the value at offset `0`. Returns `42`.
- `free_raw(ptr)` — Frees the memory. After this, using `ptr` is a use-after-free bug — exactly the kind of bug NOVA's safe code prevents.

**Why `unsafe` exists:** Some operations (hardware access, custom allocators, FFI interop with C structures) require raw pointer manipulation. Rather than making the entire language unsafe (like C) or forbidding these operations entirely, NOVA lets you opt into unsafety in clearly marked blocks. You can grep for `unsafe` in any NOVA codebase to find every place where safety guarantees are suspended.

> **DO:** Use `unsafe` sparingly, only for FFI interop and low-level operations. Keep unsafe blocks as small as possible.
> **DON'T:** Put entire functions inside `unsafe` — isolate just the pointer operations that need it.

### Type mapping

| C type | NOVA type |
|--------|-----------|
| `int` | `int` |
| `long long` | `int` |
| `double` | `float` |
| `char*` | `string` |
| `void*` | `ptr` |
| `FILE*` | `ptr` |

### Linking multiple libraries

```nova
@link("m")         // libm (math)
@link("sqlite3")   // libsqlite3
@link("ssl")       // libssl (OpenSSL)
```

---

## 32. Unsafe and low-level operations

### What does "unsafe" mean?

In NOVA, all code is memory-safe by default — you cannot accidentally read uninitialized memory, write past array bounds, or use a pointer after freeing it. The compiler and runtime prevent these bugs automatically.

But sometimes you NEED to do things that the compiler cannot verify as safe — interfacing with C libraries, writing custom allocators, or accessing hardware directly. The `unsafe` keyword lets you opt out of safety checks for a specific block of code.

**Key principle:** `unsafe` does NOT mean "this code is dangerous." It means "I, the programmer, am taking responsibility for correctness here. I have verified this is correct, and the compiler should trust me."

### When to use unsafe

Use `unsafe` when you need to:
- Call C functions that manipulate raw pointers
- Do direct memory manipulation (memcpy, pointer arithmetic)
- Interface with hardware or OS-level APIs
- Build custom data structures that require raw memory control

```nova
unsafe
    buf = alloc_raw(100)

    ptr_write_u8(buf, 0, 72)    // H
    ptr_write_u8(buf, 1, 105)   // i

    print(ptr_read_u8(buf, 0))  // 72

    free_raw(buf)
```

**Line-by-line breakdown:**

- `buf = alloc_raw(100)` — Allocates 100 bytes of raw memory. The contents are uninitialized (could be anything).
- `ptr_write_u8(buf, 0, 72)` — Writes the byte value `72` (ASCII code for 'H') at offset `0`. The `_u8` suffix means "unsigned 8-bit" — one byte, range 0-255.
- `ptr_write_u8(buf, 1, 105)` — Writes `105` (ASCII 'i') at offset `1`.
- `ptr_read_u8(buf, 0)` — Reads the byte at offset `0`. Returns `72`.
- `free_raw(buf)` — Releases the memory back to the system. After this line, `buf` is a dangling pointer — using it would be a use-after-free bug.

### Pointer arithmetic — working with structured raw memory

Pointer arithmetic means accessing memory at calculated offsets. This is how C arrays work internally:

```nova
unsafe
    base = alloc_raw(40)    // 40 bytes = 5 x 8-byte values

    i = 0
    while i < 5
        ptr_write(base, i * 8, i * 100)
        i = i + 1

    i = 0
    while i < 5
        val = ptr_read(base, i * 8)
        print("slot {i} = {val}")
        i = i + 1

    free_raw(base)
```

**Line-by-line breakdown:**

- `alloc_raw(40)` — Allocates 40 bytes. Since each `int` is 8 bytes (64 bits) on NOVA, this fits exactly 5 integers.
- `ptr_write(base, i * 8, i * 100)` — Writes an 8-byte integer at offset `i * 8`. When `i = 0`, writes `0` at offset `0`. When `i = 1`, writes `100` at offset `8`. When `i = 4`, writes `400` at offset `32`. The multiplication by 8 is manual — unlike NOVA lists, raw memory has no element-size awareness.
- `ptr_read(base, i * 8)` — Reads the 8-byte integer at the calculated offset.
- Output: `slot 0 = 0`, `slot 1 = 100`, `slot 2 = 200`, `slot 3 = 300`, `slot 4 = 400`.

> **What NOT to do:**
> ```nova
> // WRONG — accessing beyond allocated memory
> unsafe
>     buf = alloc_raw(10)
>     ptr_write(buf, 100, 42)   // Buffer overflow! Only 10 bytes allocated
> ```

### Atomic operations — thread-safe counters without locks

What are atomics? An atomic operation is guaranteed to complete without being interrupted by another thread. Normal variables can be corrupted when two threads read/write them simultaneously. Atomic operations prevent this:

```nova
counter = atomic_new(0)
print(atomic_get(counter))         // 0
atomic_add(counter, 5)
print(atomic_get(counter))         // 5

// CAS (Compare-And-Swap) — the foundation of lock-free programming
old = atomic_cas(counter, 5, 10)   // if counter == 5, set to 10
print(old)                         // 5 (previous value)
print(atomic_get(counter))         // 10
```

**Line-by-line breakdown:**

- `atomic_new(0)` — Creates a new atomic integer initialized to `0`. Unlike regular variables, this value can be safely read and written from multiple processes simultaneously.
- `atomic_get(counter)` — Reads the current value atomically. No other thread can see a partially-written value.
- `atomic_add(counter, 5)` — Adds `5` to the counter atomically. Even if two threads call `atomic_add` at the same time, both additions will be applied correctly (no lost updates).
- `atomic_cas(counter, 5, 10)` — CAS (Compare-And-Swap): "If the counter's current value is `5`, change it to `10`. Return the value that was there." This is the building block for all lock-free algorithms. If another thread changed the value between your read and your CAS, the CAS fails (returns the unexpected value) and you can retry.

> **DO:** Use atomics for simple shared counters and flags between processes.
> **DON'T:** Try to build complex data structures with atomics — use channels instead (they are safer and usually fast enough).

---

## 33. Bytes and binary data

### What are bytes?

Everything inside a computer is ultimately bytes — numbers from 0 to 255. Text, images, network packets, database files — all bytes. A string in NOVA is a human-readable text abstraction. The `bytes` type gives you direct access to the raw binary data underneath.

You need `bytes` when working with:
- **Binary file formats** — PNG (Portable Network Graphics) images, ZIP archives, PDF (Portable Document Format) files
- **Network protocols** — TCP (Transmission Control Protocol) packets, WebSocket frames, binary APIs
- **Cryptography** — Hashes, encryption keys, signatures are all byte sequences
- **Hardware communication** — Serial ports, USB (Universal Serial Bus) devices, sensors

### Creating bytes

```nova
buf = bytes(10)
print(bytes_len(buf))     // 10
print(bytes_get(buf, 0))  // 0
```

**Line-by-line breakdown:**

- `buf = bytes(10)` — Creates a byte buffer with 10 bytes, all initialized to `0`. Think of it as an array of 10 slots, each holding a number from 0 to 255.
- `bytes_len(buf)` — Returns the length (number of bytes) in the buffer. Returns `10`.
- `bytes_get(buf, 0)` — Reads the byte at index `0`. Returns `0` because all bytes start at zero.

### Setting and getting individual bytes

```nova
buf = bytes(10)
bytes_set(buf, 0, 72)     // H
bytes_set(buf, 1, 101)    // e
bytes_set(buf, 2, 108)    // l
bytes_set(buf, 3, 108)    // l
bytes_set(buf, 4, 111)    // o

print(bytes_get(buf, 0))  // 72
print(bytes_get(buf, 4))  // 111
```

**Line-by-line breakdown:**

- `bytes_set(buf, 0, 72)` — Sets byte at index `0` to `72`. In ASCII encoding, `72` is the character 'H'. Each character has a numeric code (A=65, B=66, ... H=72, etc.).
- `bytes_set(buf, 1, 101)` — Sets index `1` to `101` (ASCII 'e').
- `bytes_get(buf, 0)` — Reads back the byte at index `0`. Returns `72`.
- `bytes_get(buf, 4)` — Reads byte at index `4`. Returns `111` (ASCII 'o').

### Converting between strings and bytes

Strings are text. Bytes are raw numbers. You can convert between them:

```nova
// String to bytes
data = str_to_bytes("NOVA")
print(bytes_len(data))         // 4
print(bytes_get(data, 0))     // 78 (ASCII 'N')
print(bytes_get(data, 1))     // 79 (ASCII 'O')

// Bytes to string
text = bytes_to_str(bytes_slice(buf, 0, 5))
print(text)                    // Hello
```

**Line-by-line breakdown:**

- `str_to_bytes("NOVA")` — Converts the string `"NOVA"` into its raw byte representation. Each character becomes one byte: N=78, O=79, V=86, A=65.
- `bytes_get(data, 0)` — The first byte is `78`, which is the ASCII code for 'N'.
- `bytes_to_str(bytes_slice(buf, 0, 5))` — Converts bytes back to a string. `bytes_slice(buf, 0, 5)` takes bytes at indices 0 through 4 (the "Hello" we wrote earlier), and `bytes_to_str` interprets them as ASCII text.

### Slicing bytes — extracting a portion

```nova
data = str_to_bytes("NOVA")
sub = bytes_slice(data, 1, 3)
print(bytes_len(sub))          // 2
print(bytes_to_str(sub))       // OV
```

**Line-by-line breakdown:**

- `bytes_slice(data, 1, 3)` — Extracts bytes from index `1` up to (but not including) index `3`. This gives bytes at positions 1 and 2, which are 'O' and 'V'.
- `bytes_len(sub)` — The slice has 2 bytes.
- `bytes_to_str(sub)` — Converts the 2-byte slice back to the string `"OV"`.

### Overflow wrapping — bytes always stay in range 0-255

Byte values automatically wrap at 256. This is modular arithmetic, not an error:

```nova
buf = bytes(1)
bytes_set(buf, 0, 256)
print(bytes_get(buf, 0))   // 0 (256 wraps to 0)

bytes_set(buf, 0, 300)
print(bytes_get(buf, 0))   // 44 (300 % 256 = 44)
```

**Line-by-line breakdown:**

- `bytes_set(buf, 0, 256)` — Tries to set the byte to `256`. But bytes can only hold 0-255, so `256 % 256 = 0`.
- `bytes_set(buf, 0, 300)` — `300 % 256 = 44`. The value wraps around.

### Binary protocol example — building a length-prefixed message

Many network protocols use "length-prefixed" messages: first send the message length (as bytes), then send the message itself. This lets the receiver know how many bytes to read:

```nova
fn encode_message(msg)
    data = str_to_bytes(msg)
    length = bytes_len(data)
    header = bytes(4)
    bytes_set(header, 0, length % 256)
    bytes_set(header, 1, (length / 256) % 256)
    bytes_set(header, 2, (length / 65536) % 256)
    bytes_set(header, 3, (length / 16777216) % 256)
    bytes_concat(header, data)
```

**Line-by-line breakdown:**

- `data = str_to_bytes(msg)` — Converts the message string to raw bytes.
- `length = bytes_len(data)` — Gets the number of bytes in the message.
- `header = bytes(4)` — Creates a 4-byte header. 4 bytes can represent lengths up to ~4 billion (2^32).
- `bytes_set(header, 0, length % 256)` — Stores the least significant byte of the length. This is "little-endian" encoding — the smallest part of the number goes first.
- `bytes_set(header, 1, (length / 256) % 256)` — Stores the next byte of the length.
- `bytes_concat(header, data)` — Joins the 4-byte header and the message payload into a single byte buffer. The result is `[len_byte0, len_byte1, len_byte2, len_byte3, payload...]`.

> **DO:** Use `bytes` for binary data (files, network, crypto). Use strings for human-readable text.
> **DON'T:** Use strings to hold binary data — strings are for text. Binary data may contain byte value `0`, which is the string terminator in C and will truncate your data.

---

## 34. AI (Artificial Intelligence) and tensors

### What are tensors?

A tensor is a multi-dimensional array of numbers. If you know what arrays and matrices are, you already understand tensors:

| Dimensions | Name | Example | Shape |
|-----------|------|---------|-------|
| 0 | Scalar | `42.0` | `[]` |
| 1 | Vector | `[1.0, 2.0, 3.0]` | `[3]` |
| 2 | Matrix | A 2x3 grid of numbers | `[2, 3]` |
| 3 | 3D Tensor | A cube of numbers (e.g., a color image: height x width x RGB channels) | `[224, 224, 3]` |

Tensors are the fundamental data structure in AI and machine learning. Every neural network — from image classifiers to language models — is built by multiplying, adding, and transforming tensors.

NOVA has built-in tensor operations, so you can build and run neural networks without importing external libraries like PyTorch or TensorFlow.

### Creating tensors

```nova
t = tensor_from_list([1.0, 2.0, 3.0, 4.0, 5.0, 6.0], [2, 3])

print(tensor_shape(t))    // [2, 3]
print(tensor_rank(t))     // 2
print(tensor_size(t))     // 6

z = tensor_zeros([3, 3])

print(tensor_get(t, [0, 0]))    // 1.0
print(tensor_get(t, [1, 2]))    // 6.0
```

**Line-by-line breakdown:**

- `tensor_from_list([1.0, 2.0, 3.0, 4.0, 5.0, 6.0], [2, 3])` — Creates a tensor from a flat list of numbers. The first argument is the data (6 numbers). The second argument is the shape `[2, 3]`, meaning 2 rows and 3 columns. The data fills row by row: row 0 = `[1, 2, 3]`, row 1 = `[4, 5, 6]`.
- `tensor_shape(t)` — Returns the shape as a list. `[2, 3]` means 2 rows, 3 columns.
- `tensor_rank(t)` — Returns the number of dimensions. A matrix has rank 2. A vector has rank 1. A 3D tensor has rank 3.
- `tensor_size(t)` — Returns the total number of elements. 2 x 3 = 6.
- `tensor_zeros([3, 3])` — Creates a 3x3 matrix with all values set to `0.0`.
- `tensor_get(t, [0, 0])` — Gets the element at row 0, column 0. Returns `1.0`.
- `tensor_get(t, [1, 2])` — Gets the element at row 1, column 2. Returns `6.0`.

### Tensor arithmetic — element-wise operations

```nova
a = tensor_from_list([1.0, 2.0, 3.0, 4.0], [2, 2])
b = tensor_from_list([5.0, 6.0, 7.0, 8.0], [2, 2])

c = tensor_add(a, b)     // [[6, 8], [10, 12]]
d = tensor_sub(a, b)     // [[-4, -4], [-4, -4]]
e = tensor_mul(a, b)     // [[5, 12], [21, 32]]
f = tensor_div(a, b)     // element-wise divide

g = tensor_scale(a, 2.0)  // [[2, 4], [6, 8]]
```

**Line-by-line breakdown:**

- `tensor_add(a, b)` — Adds each element of `a` to the corresponding element of `b`. Position [0,0]: 1+5=6. Position [0,1]: 2+6=8. And so on.
- `tensor_sub(a, b)` — Subtracts element-wise. 1-5=-4, 2-6=-4, etc.
- `tensor_mul(a, b)` — Multiplies element-wise (NOT matrix multiplication). 1*5=5, 2*6=12, 3*7=21, 4*8=32.
- `tensor_div(a, b)` — Divides element-wise. 1/5=0.2, 2/6=0.33, etc.
- `tensor_scale(a, 2.0)` — Multiplies every element by the scalar `2.0`. 1*2=2, 2*2=4, 3*2=6, 4*2=8.

### Matrix multiplication — the core AI operation

Matrix multiplication is the most important operation in AI. It is how neural networks transform inputs into outputs:

```nova
a = tensor_from_list([1.0, 2.0, 3.0, 4.0, 5.0, 6.0], [2, 3])
b = tensor_from_list([7.0, 8.0, 9.0, 10.0, 11.0, 12.0], [3, 2])

c = tensor_matmul(a, b)
print(tensor_shape(c))    // [2, 2]
// Result: [[58, 64], [139, 154]]
```

**Line-by-line breakdown:**

- `tensor_matmul(a, b)` — Matrix multiplication. `a` is 2x3 and `b` is 3x2, so the result `c` is 2x2. The inner dimensions must match (both 3). Result[0,0] = (1*7 + 2*9 + 3*11) = 7+18+33 = 58. Result[0,1] = (1*8 + 2*10 + 3*12) = 8+20+36 = 64. Each output element is a "dot product" — multiply corresponding elements and sum them.

> **What NOT to do:**
> ```nova
> // WRONG — inner dimensions must match
> a = tensor_from_list([1.0, 2.0], [1, 2])
> b = tensor_from_list([3.0, 4.0, 5.0], [1, 3])
> c = tensor_matmul(a, b)   // ERROR: shapes [1,2] and [1,3] — inner dims 2 != 1
> ```

### Neural network operations — activation functions

Activation functions introduce non-linearity into neural networks. Without them, any number of matrix multiplications would just be one big linear transformation:

```nova
x = tensor_from_list([-1.0, 0.0, 1.0, 2.0], [4])
print(tensor_relu(x))       // [0, 0, 1, 2] — max(0, x)
print(tensor_sigmoid(x))    // [0.269, 0.5, 0.731, 0.881]
print(tensor_tanh(x))       // [-0.762, 0, 0.762, 0.964]
print(tensor_softmax(x))    // probability distribution summing to 1.0

print(tensor_sum(x))        // 2.0
print(tensor_argmax(x))     // 3 (index of max value)

t = tensor_from_list([1.0, 2.0, 3.0, 4.0, 5.0, 6.0], [2, 3])
t2 = tensor_reshape(t, [3, 2])
t3 = tensor_transpose(t)
```

**Line-by-line breakdown:**

- `tensor_relu(x)` — ReLU (Rectified Linear Unit): replaces all negative values with 0, keeps positive values unchanged. This is the most commonly used activation function in modern neural networks.
- `tensor_sigmoid(x)` — Sigmoid: squashes every value into the range (0, 1). Used for binary classification ("is this a cat or not?").
- `tensor_tanh(x)` — Tanh (hyperbolic tangent): squashes values into the range (-1, 1). Similar to sigmoid but centered at zero.
- `tensor_softmax(x)` — Softmax: converts raw scores into probabilities that sum to 1.0. Used for multi-class classification ("is this a cat, dog, or bird?").
- `tensor_sum(x)` — Adds all elements: -1 + 0 + 1 + 2 = 2.0.
- `tensor_argmax(x)` — Returns the INDEX of the largest element. `2.0` is at index 3, so returns `3`.
- `tensor_reshape(t, [3, 2])` — Changes the shape without changing the data. The 2x3 matrix becomes a 3x2 matrix.
- `tensor_transpose(t)` — Flips rows and columns. The 2x3 matrix becomes a 3x2 matrix where column `i` of the original becomes row `i`.

### Simple neural network forward pass

A neural network is layers of matrix multiplications followed by activation functions. Here is a minimal 2-layer network:

```nova
fn forward(input, weights1, bias1, weights2, bias2)
    // Layer 1: linear transformation + ReLU activation
    h = tensor_matmul(input, weights1)
    h = tensor_add(h, bias1)
    h = tensor_relu(h)

    // Layer 2: linear transformation + softmax (output probabilities)
    out = tensor_matmul(h, weights2)
    out = tensor_add(out, bias2)
    tensor_softmax(out)

input = tensor_from_list([1.0, 0.5, -0.3], [1, 3])
w1 = tensor_from_list([0.1, 0.2, 0.3, 0.4, -0.1, 0.1, 0.2, -0.2, 0.3, -0.3, 0.1, 0.2], [3, 4])
b1 = tensor_zeros([1, 4])
w2 = tensor_from_list([0.1, 0.2, -0.1, 0.3, 0.2, -0.2, 0.1, 0.4], [4, 2])
b2 = tensor_zeros([1, 2])

probs = forward(input, w1, b1, w2, b2)
print(tensor_get(probs, [0, 0]))    // probability of class 0
print(tensor_get(probs, [0, 1]))    // probability of class 1
predicted = tensor_argmax(probs)
print("Predicted class: {predicted}")
```

**Line-by-line breakdown:**

- `fn forward(input, weights1, bias1, weights2, bias2)` — Defines the "forward pass" of the network. In AI, the forward pass is where you feed data through the network and get a prediction.
- `h = tensor_matmul(input, weights1)` — Multiplies the input (1x3) by the first weight matrix (3x4). Result: a 1x4 vector (4 hidden neurons).
- `h = tensor_add(h, bias1)` — Adds the bias term. Biases let the network learn offsets, not just scales.
- `h = tensor_relu(h)` — Applies ReLU activation. Negative values become 0, introducing non-linearity.
- `out = tensor_matmul(h, weights2)` — Multiplies the hidden layer (1x4) by the second weight matrix (4x2). Result: a 1x2 vector (2 output classes).
- `tensor_softmax(out)` — Converts raw scores into probabilities. If the network outputs `[2.1, 0.5]`, softmax converts it to something like `[0.83, 0.17]`, meaning 83% confidence for class 0.
- `input = tensor_from_list([1.0, 0.5, -0.3], [1, 3])` — One input sample with 3 features. The `[1, 3]` shape means 1 sample, 3 features.
- `tensor_argmax(probs)` — Returns the index of the highest probability. If class 0 has probability 0.83, returns `0`.

> **Comparison with Python/PyTorch:**
> ```python
> # Python + PyTorch (same network)
> import torch
> h = torch.relu(input @ w1 + b1)    # @ is matmul
> out = torch.softmax(h @ w2 + b2, dim=1)
> ```
> NOVA uses explicit function names (`tensor_matmul`, `tensor_relu`) instead of operator overloading (`@`, `+`). This is more verbose but clearer for beginners — every operation is spelled out.

---

## 35. Distributed computing

### What is distributed computing?

Distributed computing means running your program across multiple machines connected by a network. Instead of everything happening on one computer, different parts of your system run on different servers and communicate over the network.

Common examples:
- A web application with separate database servers, API servers, and cache servers
- A data processing pipeline that splits work across a cluster of machines
- A chat system where messages must be routed between servers in different data centers

### Why NOVA's approach is special

In most languages, local code (function calls within one process) and distributed code (sending messages over the network) look completely different. You write `result = compute(data)` locally but `response = http.post(url, serialize(data))` for remote calls.

In NOVA, channels work across the network with the same API. The mental model is: "send a value, the receiver gets an independent copy" — whether the tasks are in the same process, on different cores, or on different machines across the internet.

### Remote channels — the server side

```nova
fn run_server()
    listener = remote_listen("0.0.0.0", 9000)
    conn = remote_accept(listener)
    msg = remote_recv(conn)
    print("Server received: {msg}")
    remote_send(conn, {"reply": "got it"})
    remote_close(conn)
```

**Line-by-line breakdown:**

- `remote_listen("0.0.0.0", 9000)` — Starts listening for incoming network connections on all network interfaces (`0.0.0.0` means "accept connections from anywhere") on port `9000`. This is similar to how a web server listens for incoming HTTP requests. Returns a listener handle.
- `remote_accept(listener)` — Waits for a client to connect. This blocks (pauses execution) until a connection arrives. Returns a connection handle representing the communication channel to that specific client.
- `remote_recv(conn)` — Receives a value from the remote client. Blocks until the client sends something. The received value is deserialized from JSON automatically — you get a NOVA dict, list, string, or number, not raw bytes.
- `remote_send(conn, {"reply": "got it"})` — Sends a value back to the client. The dict `{"reply": "got it"}` is automatically serialized to JSON, sent over the TCP connection, and deserialized on the other end.
- `remote_close(conn)` — Closes the connection and frees resources.

### Remote channels — the client side

```nova
fn run_client()
    conn = remote_connect("127.0.0.1", 9000)
    remote_send(conn, {"op": "hello", "data": "world"})
    reply = remote_recv(conn)
    print("Client got: {reply}")
    remote_close(conn)
```

**Line-by-line breakdown:**

- `remote_connect("127.0.0.1", 9000)` — Connects to a server at IP address `127.0.0.1` (localhost — the same machine) on port `9000`. In production, this would be a real IP like `"192.168.1.100"` or a hostname like `"api.example.com"`. Returns a connection handle.
- `remote_send(conn, {"op": "hello", "data": "world"})` — Sends a dict to the server. The data is serialized to JSON and sent over TCP.
- `remote_recv(conn)` — Waits for the server's response. Returns the deserialized value.
- `remote_close(conn)` — Closes the connection.

### How remote channels work under the hood

Remote channels use TCP (Transmission Control Protocol) with length-prefixed JSON serialization:

1. When you call `remote_send(conn, value)`, NOVA serializes `value` to a JSON string
2. It prefixes the JSON with its byte length (4 bytes, little-endian)
3. It sends both over the TCP connection
4. On the receiving end, `remote_recv` reads the 4-byte length, then reads exactly that many bytes, then deserializes the JSON back into a NOVA value

This is the same deep-copy semantics as local channels — the receiver always gets an independent copy of the data, never a shared reference. This makes distributed programming safe: no data races, no shared mutable state, no surprises.

> **DO:** Use remote channels for building distributed systems — they give you the same safety guarantees as local channels.
> **DON'T:** Send extremely large values (100MB+) over remote channels — the entire value is serialized to JSON in memory. For large data transfers, consider breaking the data into smaller chunks.

---

## 36. Performance guide

### Why does performance matter?

NOVA's promise is C-level performance — within 1-5% of hand-written C code compiled with `clang -O2` (Clang Compiler with optimization level 2). This means NOVA runs 50-100x faster than Python, while being simpler to write.

But getting C-level performance requires understanding a few key rules. If you follow these rules, your code will be fast by default. If you break them, you might accidentally write code that is 150x slower than it should be.

### How NOVA compiles your code

NOVA uses a compilation pipeline:

1. **Your NOVA code** → the NOVA compiler parses and type-checks it
2. **LLVM IR (Low-Level Virtual Machine Intermediate Representation)** → the NOVA compiler generates this low-level code
3. **Clang with `-O2`** → LLVM's optimizer turns the IR into highly optimized machine code
4. **Native executable** → runs directly on your CPU at full speed

Any code pattern that compiles to the same LLVM IR as equivalent C code will achieve the same performance. The NOVA compiler's job is to generate IR that matches what a C compiler would produce.

**Measured performance against `clang -O2` (lower is better, 1.0x = identical to C):**

- Integer arithmetic: **~1.0x C** (identical)
- Struct field math (lowercase types): **~1.0-1.04x C** (within 4%)
- Float array operations: **~1.05x C** (within 5%)
- String operations: **~1.1-1.2x C** (within 10-20%)

### What makes code fast

**1. Scalar arithmetic is native**

```nova
fn sum_squares(n: int) -> int
    total = 0
    for i in 1..n
        total = total + i * i
    total
```

**Why this is fast:** The compiler sees that `total` and `i` are integers, so it generates native CPU `add` and `mul` instructions. There is no boxing (wrapping values in objects), no dynamic dispatch (looking up types at runtime), no overhead of any kind. The generated machine code is identical to what `clang -O2` produces for the equivalent C:

```c
// What a C compiler produces — NOVA generates the same thing
int sum_squares(int n) {
    int total = 0;
    for (int i = 1; i <= n; i++) total += i * i;
    return total;
}
```

**2. Struct math with lowercase field types is native**

```nova
// FAST: lowercase → native LLVM fmul/fadd
type Vec3
    x: float
    y: float
    z: float

fn dot(a: Vec3, b: Vec3) -> float
    a.x * b.x + a.y * b.y + a.z * b.z
```

**Why this is fast:** Lowercase `float` tells the compiler that `x`, `y`, and `z` are always 64-bit floating point numbers. The compiler generates three `fmul` (floating-point multiply) instructions and two `fadd` (floating-point add) instructions — exactly what C produces.

```nova
// SLOW: capital → dynamic dispatch (150x slower!)
type Vec3Slow
    x: Float
    y: Float
    z: Float
```

**Why this is slow:** Capital `Float` makes the field a dynamic "any" type. Every operation must first check "is this a float? is this an int? is this a string?" at runtime. This lookup-and-branch happens on EVERY arithmetic operation, turning three fast `fmul` instructions into hundreds of instructions. The result: **150x slower than lowercase**.

> **This is the #1 performance rule in NOVA: ALWAYS use lowercase type names in struct fields.** `x: float` not `x: Float`. `n: int` not `n: Int`.

**3. Type-inferred parameters are specialized**

```nova
fn scale(v: Vec3, factor: float) -> Vec3
    Vec3 { x: v.x * factor, y: v.y * factor, z: v.z * factor }
```

**Why this is fast:** The compiler knows `v` is `Vec3` and `factor` is `float` from the type annotations. It generates specialized native code for exactly this combination. No generic dispatch.

**4. The arena allocator eliminates GC (Garbage Collection) pauses**

Forge uses a per-request arena allocator. All memory allocated during a request is freed in one operation when the request ends. This means:
- **No GC pauses** — unlike Java, Go, or Python, NOVA never pauses your server to scan for garbage
- **No reference counting on the hot path** — unlike Swift or Objective-C
- **Zero memory growth** — the arena resets every request, so long-running servers hold flat memory

**5. Green tasks are extremely cheap**

Spawning a green task costs approximately **1 microsecond** and uses **~32KB of memory**. For comparison, an OS thread costs ~10 microseconds to create and uses ~1MB. You can spawn 10,000 green tasks without breaking a sweat.

### What makes code slow — and how to fix it

**1. Capital type names in struct fields** (150x penalty)

Already covered above. Use lowercase `float`, never capital `Float`.

**2. String building with `+` in a loop** (O(n²) complexity)

Every `+` creates a new string and copies all previous characters. If you do this in a loop, the total work grows quadratically:

```nova
// SLOW: O(n²) — copies the entire string on every iteration
result = ""
for item in large_list
    result = result + item + ", "
```

**Why this is slow:** On the first iteration, `result` is 0 characters, so you copy 0 + the new item. On the 100th iteration, `result` is ~500 characters, so you copy all 500 + the new item. On the 1000th iteration, you copy ~5000 characters. Total copies: 0 + 5 + 10 + ... + 5000 = O(n²).

```nova
// FAST: O(n) — build a list, then join once
parts = []
for item in large_list
    push(parts, item)
result = join(parts, ", ")
```

**Why this is fast:** `push` appends to a list in O(1) amortized time. `join` traverses the list once to calculate the total length, allocates one string of exactly the right size, and copies each part once. Total work: O(n).

```nova
// ALSO FAST: buffer approach
buf = buffer_create()
for item in large_list
    buf_append(buf, item)
    buf_append(buf, ", ")
result = buf_to_str(buf)
```

**Why this is fast:** A buffer pre-allocates space and grows geometrically (doubling), so appends are amortized O(1).

**3. Large values over channels in tight loops**

Channel sends perform a deep copy. Sending a dict with 10,000 entries copies all 10,000 entries:

```nova
// SLOW: copying large_data every iteration
for i in 0..9999
    send(ch, large_data)

// FAST: compute locally, send only the result
for i in 0..9999
    result = compute(large_data, i)
    send(ch, result)
```

**Why the fast version works:** Instead of sending the entire data set 10,000 times, you send only the small result of each computation. The data stays local, the results (small values) travel through the channel.

### Measuring performance — how to time your code

```nova
start = time_ms()
result = expensive_computation()
elapsed = time_ms() - start
print("took {elapsed}ms")
```

**Line-by-line breakdown:**

- `time_ms()` — Returns the current time in milliseconds since the Unix epoch (January 1, 1970). Calling it twice and subtracting gives you elapsed wall-clock time.
- `elapsed = time_ms() - start` — The difference is the number of milliseconds the computation took.

For micro-benchmarks (measuring very fast operations), run many iterations:

```nova
N = 100_000
start = time_ms()
for i in 0..N-1
    result = my_function(i)
elapsed = time_ms() - start
print("{N} iterations in {elapsed}ms = {elapsed * 1000 / N}us each")
```

**Line-by-line breakdown:**

- `N = 100_000` — Run the function 100,000 times to get a reliable measurement. Single-call timings are noisy.
- `elapsed * 1000 / N` — Converts total milliseconds to microseconds per iteration. If 100,000 calls took 500ms, each call took 5µs (microseconds).

### Performance comparison matrix

This table shows NOVA's measured performance relative to C and Python. "1x" means identical speed. "50x slower" means Python takes 50 times as long.

| Operation | NOVA | C (`clang -O2`) | Python 3 | Notes |
|---|---|---|---|---|
| Integer loop | ~1x | 1x (baseline) | ~50x slower | NOVA matches C |
| Struct field math (lowercase) | ~1x | 1x | ~150x slower | NOVA matches C |
| Struct field math (Capital) | ~150x | 1x | ~150x slower | Both equally slow — avoid Capital! |
| Float array | ~1.05x | 1x | ~100x slower | NOVA nearly matches C |
| String concat (`+`) | 1.2-2x | 1x | varies | Use `join()` for loops |
| Dict lookup | 1.5-3x | N/A | ~5-10x slower | Open-addressing hash table |
| Spawn (green task) | ~1µs | N/A | ~10µs (OS thread) | NOVA 10x cheaper |
| HTTP round-trip (Forge) | <100µs | N/A | ~1ms (Flask) | NOVA ~10x faster |

### The compiler is the genius — you write simple code

Write simple, clear code. The compiler handles optimization. You do NOT need to:
- Annotate types on local variables (the compiler infers them)
- Manually inline functions (the LLVM optimizer does this)
- Write SIMD (Single Instruction, Multiple Data) intrinsics for most workloads
- Manage memory allocation (arenas and RC handle it)
- Write lock-free algorithms for basic concurrency (use channels)

You DO need to:
- Use **lowercase** type names in struct fields (`float`, not `Float`)
- Use `join()` or `buffer_create()` for string building in loops
- Design channels to carry small coordination values, not large data

> **DO:** Profile before optimizing. NOVA's default performance is within 2-5x of hand-written C for most code. The first version of your code is probably fast enough.
> **DON'T:** Rewrite clean NOVA code in a "more C-like" style — the compiler sees through abstractions. Ugly code is not faster code.

---

## Appendix A: Quick reference

This appendix lists every keyword, built-in function, operator, and syntax form in NOVA. Use it as a cheat sheet when writing code.

### Keywords

| Keyword | Purpose |
|---|---|
| `fn` | Define a function or method |
| `type` | Define a struct type |
| `enum` | Define a sum type |
| `trait` | Define a set of required methods |
| `let` | Bind a name (alternative to bare assignment) |
| `return` | Explicit early return from a function |
| `if / else` | Conditional expression or statement |
| `while` | Loop while a condition is true |
| `for / in` | Iterate over a list, dict, string, or range |
| `loop` | Infinite loop (exit with `break` or `return`) |
| `match` | Pattern match an expression |
| `break` | Exit the nearest enclosing loop |
| `continue` | Jump to the next iteration of the nearest loop |
| `spawn` | Start a new green task |
| `send` | Put a value on a channel |
| `receive` | Block until a value arrives on a channel |
| `select` | Block until any one of several channels has a value |
| `channel` | Create a new channel |
| `import` | Import a module |
| `extern fn` | Declare a C function for FFI |
| `unsafe` | Block where safety checks are relaxed |
| `try` | Unwrap Ok or propagate Err |
| `true / false` | Boolean literals |
| `null` | Absence of a value |
| `and / or / not` | Logical operators |
| `in / not in` | Membership test |
| `as` | Type cast |
| `matches` | Regex pattern test |

### Built-in functions (core)

| Function | Description |
|---|---|
| `print(v)` | Print value followed by newline |
| `str(v)` | Convert any value to string |
| `int(v)` | Convert string/float to int (truncates) |
| `float(v)` | Convert string/int to float |
| `bool(v)` | Convert to bool |
| `len(v)` | Length of string, list, dict, or bytes |
| `type_of(v)` | Get type name as string |

### Built-in functions (collections)

| Function | Description |
|---|---|
| `push(list, v)` | Append to list |
| `pop(list)` | Remove and return last element |
| `insert(list, i, v)` | Insert at index |
| `remove(list, v)` | Remove first occurrence |
| `remove_at(list, i)` | Remove at index |
| `sort(list)` | Sort in place |
| `reverse(list)` | Reverse in place |
| `sort_by(list, cmp)` | Sort with custom comparator |
| `keys(dict)` | List of dict keys |
| `values(dict)` | List of dict values |
| `delete(dict, key)` | Remove key from dict |
| `contains(v, x)` | Test element/key presence |
| `merge(d1, d2)` | Merge two dicts |
| `map(list, f)` | Apply f to each element |
| `filter(list, f)` | Keep matching elements |
| `reduce(list, init, f)` | Fold to single value |
| `flatten(lists)` | Flatten list of lists |
| `sum(list)` | Sum integer list |
| `join(list, sep)` | Join string list |
| `enumerate(list)` | List of [index, value] pairs |

### Built-in functions (strings)

| Function | Description |
|---|---|
| `split(s, sep)` | Split by separator |
| `find(s, sub)` | Index of first occurrence (-1 if not found) |
| `slice(s, a, b)` | Substring from a to b (exclusive) |
| `upper(s) / lower(s)` | Case conversion |
| `trim(s)` | Remove leading/trailing whitespace |
| `ltrim(s) / rstrip(s)` | Left/right trim |
| `replace(s, from, to)` | Replace all occurrences |
| `starts_with(s, p)` | Test prefix |
| `ends_with(s, p)` | Test suffix |
| `char_at(s, i)` | Character at index |
| `ord(c) / chr(n)` | Character code conversion |
| `repeat(s, n)` | Repeat string n times |
| `pad_left(s, w, c)` | Left-pad to width |
| `pad_right(s, w, c)` | Right-pad to width |
| `center(s, w, c)` | Center-pad to width |

### Built-in functions (math)

| Function | Description |
|---|---|
| `abs(x)` | Absolute value |
| `min(a, b) / max(a, b)` | Minimum/maximum |
| `sqrt(x)` | Square root |
| `pow(base, exp)` | Power |
| `floor(x) / ceil(x)` | Floor/ceiling |
| `round(x)` | Round to nearest integer |
| `sin(x) / cos(x) / tan(x)` | Trigonometric (radians) |
| `asin(x) / acos(x) / atan(x)` | Inverse trig |
| `atan2(y, x)` | Two-argument arctangent |
| `exp(x) / log(x)` | Exponential/natural log |
| `log2(x) / log10(x)` | Base-2/10 log |
| `hypot(a, b)` | Hypotenuse (sqrt(a²+b²)) |

### Built-in functions (I/O)

| Function | Description |
|---|---|
| `read_file(path)` | Read entire file as string |
| `write_file(path, s)` | Write string to file |
| `append_file(path, s)` | Append to file |
| `file_exists(path)` | Check if file exists |
| `file_size(path)` | File size in bytes |
| `mkdir(path)` | Create directory |
| `mkdir_p(path)` | Create nested directories |
| `list_dir(path)` | List directory contents |
| `cwd()` | Current working directory |
| `path_join(a, b)` | Join path components |
| `path_ext(path)` | File extension |

### Built-in functions (concurrency)

| Function | Description |
|---|---|
| `channel()` | Create unbounded channel |
| `channel_bounded(n)` | Create bounded channel |
| `send(ch, v)` | Send value on channel |
| `receive(ch)` | Receive value from channel (blocks) |
| `select(ch1, ch2)` | Wait on multiple channels |
| `monitor(pid)` | Watch for task completion |
| `reschedule()` | Yield current green task |
| `pmap(list, f)` | Parallel map |

### Operators

| Operator | Meaning |
|---|---|
| `+ - * / %` | Arithmetic |
| `==  !=  <  <=  >  >=` | Comparison |
| `and  or  not` | Logical (short-circuits) |
| `&  \|  ^  <<  >>` | Bitwise |
| `in  not in` | Membership test |
| `x => body` | Single-parameter closure |
| `(a, b) => body` | Multi-parameter closure |
| `a..b` | Inclusive integer range |
| `+=  -=  *=  /=  %=` | Compound assignment |
| `matches` | Regex test |

### String interpolation

```nova
name = "world"
print("Hello, {name}!")          // Hello, world!
print("1 + 1 = {1 + 1}")        // 1 + 1 = 2
print("len={len(name)}")         // len=5
print("escaped: \{not code\}")   // escaped: {not code}
```

---

## Appendix B: Common patterns

These are real-world patterns you will use repeatedly in NOVA programs. Each includes a full line-by-line explanation.

### Parse a config file

Config files use a simple `key = value` format with `#` for comments. This function parses such files:

```nova
fn parse_config(path: string) -> Result
    content = try read_file(path)
    result = {}
    for line in split(content, "\n")
        line = trim(line)
        if len(line) == 0 or starts_with(line, "#")
            continue
        eq = find(line, "=")
        if eq < 0
            continue
        key = trim(slice(line, 0, eq))
        val = trim(slice(line, eq + 1, len(line)))
        result[key] = val
    ok(result)

match parse_config("app.conf")
    Ok(cfg) =>
        host = if contains(cfg, "host") then cfg["host"] else "localhost"
        port = if contains(cfg, "port") then int(cfg["port"]) else 8080
        print("connecting to {host}:{port}")
    Err(e) =>
        print("config error: {e}")
```

**Line-by-line breakdown:**

- `content = try read_file(path)` — Reads the file. If the file does not exist, `try` propagates the error and the function returns `Err("file not found")`.
- `result = {}` — Creates an empty dict to hold the parsed key-value pairs.
- `for line in split(content, "\n")` — Splits the file content by newlines and loops over each line.
- `line = trim(line)` — Removes leading and trailing whitespace from the line.
- `if len(line) == 0 or starts_with(line, "#")` — Skips empty lines and comment lines (lines starting with `#`).
- `continue` — Jumps to the next iteration of the `for` loop.
- `eq = find(line, "=")` — Finds the position of the `=` sign. Returns `-1` if there is no `=`.
- `if eq < 0` → `continue` — Skips lines without an `=` (malformed lines).
- `key = trim(slice(line, 0, eq))` — Extracts everything before `=` and trims whitespace. For `"host = localhost"`, this gives `"host"`.
- `val = trim(slice(line, eq + 1, len(line)))` — Extracts everything after `=` and trims. Gives `"localhost"`.
- `result[key] = val` — Stores the key-value pair in the dict.
- `ok(result)` — Returns the parsed dict wrapped in `Ok`.
- `Ok(cfg) =>` — If parsing succeeded, `cfg` is the dict of config values.
- `if contains(cfg, "host") then cfg["host"] else "localhost"` — Gets the value for key `"host"`, defaulting to `"localhost"` if the key is missing.

### Retry with exponential backoff

When a network operation might fail (database connection, API call), retry it with increasing delays between attempts:

```nova
fn with_retry(max_attempts: int, f)
    attempt = 0
    last_err = "unknown error"
    while attempt < max_attempts
        r = f()
        match r
            Ok(v) => return ok(v)
            Err(e) =>
                last_err = e
                attempt = attempt + 1
                if attempt < max_attempts
                    sleep(100 * attempt)
    err("failed after {max_attempts} attempts: {last_err}")

result = with_retry(3, fn() connect_to_database("mydb.db"))
match result
    Ok(db) => print("connected")
    Err(e) => print("gave up: {e}")
```

**Line-by-line breakdown:**

- `fn with_retry(max_attempts: int, f)` — Takes the maximum number of attempts and a function `f` to call. `f` should return a `Result`.
- `r = f()` — Calls the function. On each iteration, we try again.
- `Ok(v) => return ok(v)` — If the function succeeded, return the result immediately. No more retries.
- `Err(e) =>` — If it failed, record the error and increment the attempt counter.
- `sleep(100 * attempt)` — Wait before retrying. The delay increases: 100ms on attempt 1, 200ms on attempt 2, 300ms on attempt 3. This is "linear backoff." (For true exponential backoff, use `sleep(100 * pow(2, attempt))`.)
- `err("failed after {max_attempts} attempts: {last_err}")` — If all attempts failed, return an error with the last error message.
- `fn() connect_to_database("mydb.db")` — A closure that wraps the function call. This is passed as `f` to `with_retry`.

### Pipeline pattern — chaining transformations

A pipeline passes data through a series of transformation functions, one after another:

```nova
fn pipeline(data, steps)
    result = data
    for step in steps
        result = step(result)
    result

processed = pipeline(raw_items, [
    items => filter(items, item => item.active),
    items => map(items, item => normalize(item)),
    items => sort(items),
    items => items[0:100]
])
```

**Line-by-line breakdown:**

- `fn pipeline(data, steps)` — Takes initial data and a list of transformation functions.
- `result = step(result)` — Each step receives the output of the previous step. Step 1 filters, step 2 maps, step 3 sorts, step 4 takes the first 100.
- `items => filter(items, item => item.active)` — First step: keep only items where `item.active` is true.
- `items => map(items, item => normalize(item))` — Second step: transform each remaining item with `normalize`.
- `items => sort(items)` — Third step: sort the results.
- `items => items[0:100]` — Fourth step: take only the first 100 items.

### Worker pool — distributing work across multiple tasks

A worker pool spawns N green tasks that all pull work from a shared channel. This is the standard pattern for CPU-bound parallelism:

```nova
fn worker_pool(num_workers: int, jobs: list, handler) -> list
    work_ch = channel()
    result_ch = channel()

    for i in 0..num_workers
        spawn fn()
            loop
                job = receive(work_ch)
                if job == -1
                    break
                result = handler(job)
                send(result_ch, result)

    for job in jobs
        send(work_ch, job)

    for i in 0..num_workers
        send(work_ch, -1)

    results = []
    for i in 0..len(jobs)
        results.push(receive(result_ch))
    results

results = worker_pool(4, [1, 2, 3, 4, 5, 6, 7, 8], x => x * x)
print(results)
```

**Line-by-line breakdown:**

- `work_ch = channel()` — Creates a channel for distributing jobs to workers.
- `result_ch = channel()` — Creates a channel for workers to send results back.
- `for i in 0..num_workers` → `spawn fn()` — Spawns `num_workers` green tasks. Each runs an infinite loop that pulls jobs from `work_ch`.
- `job = receive(work_ch)` — A worker blocks until a job is available. Multiple workers compete for the same channel — whichever worker is free first gets the next job.
- `if job == -1` → `break` — We use `-1` as a "poison pill" — a sentinel value that tells the worker to shut down.
- `send(result_ch, result)` — After processing a job, the worker sends the result back.
- Second `for` loop: sends all jobs to the work channel.
- Third `for` loop (`0..num_workers`): sends one `-1` per worker, so each worker receives its shutdown signal.
- Final `for` loop (`0..len(jobs)`): collects `len(jobs)` results (one per job).

### HTTP (HyperText Transfer Protocol) API (Application Programming Interface) client

A reusable helper for making API calls:

```nova
fn api_get(base_url, path)
    resp = http_get(base_url + path)
    json_decode(resp)

fn api_post(base_url, path, data)
    resp = http_post(base_url + path, json_encode(data))
    json_decode(resp)

users = api_get("http://localhost:8080", "/api/users")
new_user = api_post("http://localhost:8080", "/api/users", {"name": "Alice"})
```

**Line-by-line breakdown:**

- `http_get(base_url + path)` — Sends an HTTP GET request to the given URL. Returns the response body as a string.
- `json_decode(resp)` — Parses the JSON response string into a NOVA dict or list. This is the return value of `api_get`.
- `http_post(base_url + path, json_encode(data))` — Sends an HTTP POST request. `json_encode(data)` converts the NOVA dict `{"name": "Alice"}` to the JSON string `"{\"name\": \"Alice\"}"` and sends it as the request body.

### Concurrent data fetcher — parallel HTTP requests

Fetch multiple URLs at the same time instead of one-by-one:

```nova
fn fetch_all(urls)
    ch = channel()
    for url in urls
        spawn fn()
            result = http_get(url)
            send(ch, {"url": url, "data": result})

    results = []
    for i in 0..len(urls) - 1
        results.push(receive(ch))
    results

data = fetch_all([
    "http://api1.example.com/data",
    "http://api2.example.com/data",
    "http://api3.example.com/data"
])
```

**Line-by-line breakdown:**

- `for url in urls` → `spawn fn()` — Spawns one green task per URL. All tasks run concurrently.
- `result = http_get(url)` — Each task makes its HTTP request independently. If URL 1 takes 500ms and URL 2 takes 200ms, URL 2 finishes first.
- `send(ch, {"url": url, "data": result})` — Each task sends its result (as a dict with the URL and data) to the shared channel.
- `for i in 0..len(urls) - 1` → `results.push(receive(ch))` — Collects one result per URL. Results arrive in whatever order the requests complete (not necessarily the order they were started).

**Performance:** If each request takes 200ms, fetching 3 URLs sequentially takes 600ms. Fetching them concurrently takes ~200ms (the time of the slowest request). This is 3x faster.

### State machine — modeling complex workflows

A state machine is a pattern where your program can be in one of several states, and transitions between them based on events:

```nova
enum State
    Idle()
    Running(progress: int)
    Done(result: string)
    Failed(error: string)

fn tick(state)
    match state
        Idle() => Running(0)
        Running(p) =>
            if p >= 100
                Done("completed")
            else
                Running(p + 10)
        Done(r) => Done(r)
        Failed(e) => Failed(e)

state = Idle()
while true
    match state
        Done(r) =>
            print("Finished: {r}")
            break
        Failed(e) =>
            print("Error: {e}")
            break
        _ =>
            state = tick(state)
```

**Line-by-line breakdown:**

- `enum State` — Defines all possible states. Each variant carries different data: `Running` has a progress percentage, `Done` has a result string.
- `fn tick(state)` — Takes the current state and returns the next state. This is a "pure function" — it has no side effects.
- `Idle() => Running(0)` — From idle, start running at 0% progress.
- `Running(p) =>` — If running, check progress. If >= 100, transition to `Done`. Otherwise, increment by 10.
- `Done(r) => Done(r)` — If already done, stay done. Once finished, the state machine doesn't change.
- The `while true` loop calls `tick` repeatedly until the state is `Done` or `Failed`, then breaks out.

---

## Appendix C: Troubleshooting

This section covers the most common errors and their solutions. If you encounter an error, search for the error message here first.

### "cannot find module 'forge'"

**What it means:** The compiler cannot locate the `forge.nova` file in the standard library.

**How to fix:** Check that the `NOVA_HOME` environment variable is set and points to the directory containing `lib/`:

```
ls $NOVA_HOME/lib/forge.nova
```

If that file does not exist, `NOVA_HOME` points to the wrong directory. Set it to the root of your NOVA installation:

```
# On Linux/macOS:
export NOVA_HOME=/path/to/nova

# On Windows (PowerShell):
$env:NOVA_HOME = "C:\path\to\nova"
```

### "type mismatch: expected float, got Int"

**What it means:** You used a capital type name (`Int`, `Float`) somewhere in a struct field declaration. Capital types are dynamic "any" types, not concrete numeric types.

**How to fix:** Change capital type names to lowercase in your `type` declarations:

```nova
// WRONG — capital Float is a dynamic type
type Vec2
    x: Float
    y: Float

// CORRECT — lowercase float is a concrete 64-bit float
type Vec2
    x: float
    y: float
```

This error most commonly appears when doing arithmetic on struct fields, because the compiler expects concrete `float` but finds the dynamic `Float` type.

### Green task hangs or starves other tasks

**What it means:** A CPU-bound green task runs in a tight loop without ever yielding control to other tasks. Since green tasks are cooperatively scheduled (they share OS threads), a task that never yields prevents other tasks on the same thread from running.

**How to fix:** Add `reschedule()` calls inside any long-running loop in a spawned task:

```nova
spawn fn()
    i = 0
    while i < 10_000_000
        i = i + 1
        if i % 100_000 == 0
            reschedule()    // let other tasks run
```

`reschedule()` costs almost nothing (~1 microsecond) and lets the scheduler run other waiting tasks. Call it periodically in CPU-heavy loops — every 100,000 iterations is a good default.

### "arena object not found in heap"

**What it means:** A value was created inside a Forge request handler's arena (the temporary memory region that is freed when the request ends), but something is trying to use it after the arena was freed.

**How to fix:** Store long-lived values (caches, counters, session data) at module scope, not inside handler functions:

```nova
// WRONG — cache is created inside the handler (per-request arena)
forge.get(app, "/data", fn(req)
    cache = {}                    // created in arena, freed after response!
    cache["key"] = "value"
    forge.json(cache)
)

// CORRECT — cache is created at module scope (lives forever)
cache = {}

forge.get(app, "/data", fn(req)
    cache["key"] = "value"        // module-scope dict, survives request
    forge.json(cache)
)
```

### Struct arithmetic is unexpectedly slow (150x penalty)

**What it means:** Your struct uses capital type names in field declarations, causing every arithmetic operation to go through dynamic dispatch.

**How to fix:** Search all your `type` blocks and change every `Float`, `Int`, `String`, `Bool` to lowercase `float`, `int`, `string`, `bool`.

```nova
// SLOW (150x slower than C):  type Point { x: Float, y: Float }
// FAST (1x C speed):          type Point { x: float, y: float }
```

### "index N out of bounds"

**What it means:** You tried to access element `N` of a list or string, but the list/string has fewer than `N+1` elements. Remember: indices start at 0, so a list of 5 elements has indices 0-4.

**How to fix:** Check `len()` before accessing:

```nova
if i < len(items)
    print(items[i])
else
    print("index {i} out of range, list has {len(items)} items")
```

### Function returns unexpected 0 or empty string

**What it means:** You forgot to return a value from your function. In NOVA, the last expression in a function is the return value. If the last statement is `print()` (which returns null) or an assignment, the function returns null (which prints as `0` or `""`).

```nova
// BUG: last line is print(), which returns null
fn add(a, b)
    print(a + b)

// FIX: make the expression the last line
fn add(a, b)
    a + b
```

**Key rule:** The last line of a function should be the value you want to return, NOT a `print()` or variable assignment.

### Channel receive blocks forever

**What it means:** Your code called `receive(ch)` but no task will ever send a value on that channel.

**Common causes:**
1. The spawned task crashed before it could send (check for errors in the task's code)
2. You created two channels and are receiving on the wrong one (variable naming mistake)
3. The sender finished or exited without sending

**How to fix:** Use `channel_recv_timeout` to avoid hanging indefinitely:

```nova
result = channel_recv_timeout(ch, 5000)   // wait up to 5000 milliseconds (5 seconds)
if result == null
    print("timed out — no value received after 5 seconds")
```

### "variable 'x' is not defined"

**What it means:** You are using a variable name that was never assigned. Common causes:
- Typo in the variable name (`usre` instead of `user`)
- The variable is defined inside an `if` block and you are trying to use it outside
- The variable is defined in a different function

**How to fix:** Check spelling carefully. If a variable needs to be used outside a conditional, define it before the `if`:

```nova
// WRONG — result only defined inside if
if condition
    result = compute()
print(result)               // Error: result not defined if condition was false

// CORRECT — define before, set inside
result = null
if condition
    result = compute()
print(result)               // Works: result is null or the computed value
```

### Program compiles but produces wrong output

**Debugging steps:**

1. Add `print()` statements to trace the values at each step
2. Check that ranges are correct: `0..4` gives 4 elements (0, 1, 2, 3) — the right end is excluded. Use `0..5` to get 5 elements (0, 1, 2, 3, 4).
3. Check that boolean operators are words: `and`, `or`, `not` — NOT `&&`, `||`, `!`
4. Check string interpolation: `{expr}` inside strings evaluates the expression. Literal braces need escaping: `\{not code\}`

---

## Appendix D: Standard library modules

NOVA ships with 40+ standard library modules in `$NOVA_HOME/lib/`. Import them with `import module_name`. This appendix describes what each module provides and when to use it.

### Web Framework — building web applications

| Module | What it does | When to use |
|--------|-------------|-------------|
| `forge` | Full HTTP server with routing (`get`, `post`, `put`, `delete`), middleware (`use`), WebSocket (real-time bidirectional), SSE (Server-Sent Events for push), JSON response helpers, query/body parsing, cookies, static files | Any web application or REST API — this is the main Forge module |
| `forge_db` | Database connection pooling (`pool_open`), query helpers (`query`, `exec`), transaction support | When your web app needs to talk to SQLite or PostgreSQL databases |
| `forge_auth` | JWT (JSON Web Token) creation and verification (`jwt_sign`, `jwt_verify`), CSRF (Cross-Site Request Forgery) protection, session management | When you need user authentication and authorization in your web app |
| `forge_admin` | Automatic admin interface generator for your database models | When you want a quick admin panel for managing data (like Django Admin) |
| `forge_html` | HTML builder functions (`h`, `p`, `div`, `ul`, `li`, `a`, `form`, `table`, etc.) — generate HTML without template strings | When you want to build HTML pages programmatically instead of using raw strings |
| `forge_live` | LiveView — server-rendered reactive UI. The server pushes DOM diffs to the browser over WebSocket | When you want interactive UI without writing JavaScript (like Phoenix LiveView) |
| `forge_obs` | Observability: request metrics, latency tracking, Prometheus endpoint | When you need to monitor your web application in production |
| `forge_otp` | OTP (Open Telecom Platform)-style supervisors (`supervisor_start`), agents (stateful processes), job queues | When you need fault-tolerant process supervision (restart crashed processes automatically) |
| `forge_dist` | Distributed Forge — run your application across multiple servers | When a single server is not enough and you need horizontal scaling |
| `forge_mq` | Message queue — asynchronous task processing | When you need background job processing (like sending emails, processing uploads) |
| `forge_compress` | Response compression middleware (gzip) | When you want to reduce response sizes by 60-80% |
| `forge_pg` | PostgreSQL database adapter | When you need PostgreSQL instead of SQLite |

### Cryptography & Security — encryption, hashing, certificates

All cryptography modules are written in pure NOVA (no C library dependencies). They pass standard KAT (Known Answer Test) vectors.

| Module | What it does | When to use |
|--------|-------------|-------------|
| `forge_crypto` | Hash functions (SHA-256, SHA-512, SHA-384, MD5), HMAC (keyed hashing), PBKDF2 (Password-Based Key Derivation Function 2) for password hashing, HKDF (HMAC-based Key Derivation Function) for key derivation, AES (Advanced Encryption Standard) encryption in CTR and GCM modes, ChaCha20-Poly1305 encryption, X25519 key exchange, Ed25519 digital signatures | Any time you need to hash, encrypt, sign, or derive keys |
| `forge_x509` | X.509 certificate parsing and field extraction | When you need to read SSL/TLS certificates |
| `forge_p256` | ECDSA (Elliptic Curve Digital Signature Algorithm) P-256 signature verification | When you need to verify signatures using the P-256 curve (common in web PKI) |
| `forge_rsa` | RSA (Rivest-Shamir-Adleman) PKCS#1 v1.5 and PSS signature verification | When you need to verify RSA signatures (common in JWT tokens and certificates) |
| `forge_tls` | TLS (Transport Layer Security) 1.3 key schedule, record layer, handshake messages, transcript hashing, Finished verification | Building blocks for TLS 1.3 connections |
| `forge_tls_client` | TLS 1.3 client — connect to HTTPS servers | When you need to make secure HTTPS connections |
| `forge_tls_server` | TLS 1.3 server — serve HTTPS | When you need to serve your Forge app over HTTPS |
| `forge_chain` | X.509 certificate chain validation (PKI — Public Key Infrastructure) | When you need to verify that a certificate is signed by a trusted CA (Certificate Authority) |

### Data & Math — numbers and data structures

| Module | What it does | When to use |
|--------|-------------|-------------|
| `bignum` | Arbitrary-precision integers — numbers with hundreds or thousands of digits | When you need integers larger than 2^63 (cryptography, financial calculations, combinatorics) |
| `complexnum` | Complex number arithmetic (`add`, `mul`, `div`, `abs`, `conjugate`) | Signal processing, physics simulations, fractal rendering |
| `rational` | Rational number arithmetic (exact fractions, no floating-point rounding) | When you need exact arithmetic (financial calculations, symbolic math) |
| `matrixx` | Matrix operations (multiply, transpose, determinant, inverse) | Linear algebra, transformations, physics |
| `prng` | Pseudo-random number generators (seedable, reproducible) | When you need random numbers for simulations, games, or testing |
| `bitset` | Bit set operations (set/clear/test individual bits, union, intersection) | Compact boolean arrays, permission flags, Bloom filters |
| `pvecx` | Persistent (immutable) vectors — functional data structure that shares structure | When you need immutable collections with efficient "updates" (returns a new version, original unchanged) |

### Text & Encoding — strings, formats, compression

| Module | What it does | When to use |
|--------|-------------|-------------|
| `strx` | Extended string operations beyond the built-ins (word wrap, title case, levenshtein distance, etc.) | When built-in string functions are not enough |
| `basex` | Base32, Base58, Base64 encoding and decoding | When you need to encode binary data as text (email attachments, URLs, cryptocurrency addresses) |
| `graphemex` | Unicode grapheme cluster operations — properly handle multi-codepoint characters (emojis, accented letters, etc.) | When you need correct Unicode text handling beyond ASCII |
| `csvx` | CSV (Comma-Separated Values) parsing and generation | When you need to read or write spreadsheet-compatible data files |
| `urlx` | URL (Uniform Resource Locator) parsing, query string encoding/decoding, path manipulation | When you need to construct or decompose URLs |
| `deflatex` | DEFLATE compression and decompression | When you need to compress/decompress data (gzip, ZIP files use DEFLATE internally) |

### Utilities — general-purpose helpers

| Module | What it does | When to use |
|--------|-------------|-------------|
| `corex` | Core utility functions (deep equality, deep clone, type checks) | General-purpose programming |
| `collx` | Collection utilities (group_by, chunk, zip, interleave, frequencies) | When you need list/dict transformations beyond map/filter/reduce |
| `setops` | Set operations (union, intersection, difference, symmetric difference) on lists | When you need mathematical set operations |
| `getin` | Nested data access (`get_in`, `assoc_in`, `update_in`) for deeply nested dicts/lists | When you work with complex JSON structures and need to access `data["users"][0]["address"]["city"]` safely |
| `uuid` | UUID (Universally Unique Identifier) v4 generation | When you need unique IDs for database records, session tokens, etc. |
| `coro` | Coroutine/generator support | When you need lazy sequences that produce values on demand |

---

*NOVA (Natively Optimized Versatile Architecture) language version: gen3 (self-hosted compiler). This tutorial reflects the language as implemented and tested. For formal grammar and semantic rules, see `LANGUAGE_SPEC.md`. For the complete framework API reference, see the Forge source in `lib/forge.nova`.*
