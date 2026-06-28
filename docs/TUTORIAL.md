# NOVA Language Tutorial

NOVA is a programming language built on one idea: one developer, one language, builds anything, runs anywhere. Systems code, web backends, AI pipelines, real-time servers — all in the same language, without switching between Python for scripting and C for performance and Go for concurrency and JavaScript for the frontend.

This tutorial teaches the whole language from the ground up. Each section explains not just what the syntax is but why the design is the way it is, and how it interacts with every other part of the language. By the end you will have written a production-grade HTTP API, a WebSocket chat server, a SQLite-backed CRUD app, and enough understanding to build anything else without coming back here.

---

## Table of Contents

1. [Install](#1-install)
2. [Hello, world](#2-hello-world)
3. [Values and types](#3-values-and-types)
4. [Control flow](#4-control-flow)
5. [Functions](#5-functions)
6. [Structs](#6-structs)
7. [Enums](#7-enums)
8. [Pattern matching](#8-pattern-matching)
9. [Error handling](#9-error-handling)
10. [Lists, dicts, strings](#10-lists-dicts-strings)
11. [Processes and channels](#11-processes-and-channels)
12. [Modules](#12-modules)
13. [Forge: building a REST API](#13-forge-building-a-rest-api)
14. [Forge: SQLite data layer](#14-forge-sqlite-data-layer)
15. [Forge: WebSocket](#15-forge-websocket)
16. [Forge: auth (JWT + CSRF)](#16-forge-auth-jwt--csrf)
17. [FFI: calling C](#17-ffi-calling-c)
18. [Performance guide](#18-performance-guide)

---

## 1. Install

NOVA ships as a single self-contained binary: the compiler, runtime, and standard library all in one. There is no package manager to install first, no runtime VM to configure, no header files to locate.

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
- **Diagnostics** — the extension runs the compiler on save and highlights type errors and syntax errors inline
- **Completions** — basic word-based completions for names defined in the current file

**Installing the extension:**

In VS Code, open the Command Palette (`Ctrl+Shift+P`) and run "Extensions: Install from VSIX". Select `nova-vscode/nova-language-features-0.0.1.vsix` from the repository.

If you are building from source, the extension binary (`nova-vscode/bin/nova-compiler.exe`) must match the compiler version. After any compiler rebuild, copy the updated binary there.

**The extension binary IS the compiler** — the same `gen3_test.exe` (renamed `nova-compiler.exe`) handles both compilation and LSP requests. When VS Code opens a `.nova` file, it launches `nova-compiler.exe lsp` as a language server that speaks the Language Server Protocol.

> **DO:** Make sure `nova-vscode/bin/nova-compiler.exe` is up to date with your compiler. If Ctrl+Click stops working after a language change, rebuild the compiler and copy the new binary.
> **DON'T:** Expect Ctrl+Click to navigate inside strings, comments, or type annotation positions — it reads the word at the cursor position and looks for definitions of that identifier.

---

## 2. Hello, world

Create a file called `hello.nova` and put this in it:

```nova
print("Hello, world!")
```

Now run it from your terminal:

```
nova run hello.nova
```

Output:

```
Hello, world!
```

That's the entire program. One line. No `main()` function, no `import` statement, no class wrapper, no semicolons. If you're coming from Java or C#, you're used to writing 5-10 lines of boilerplate before you can print anything. In NOVA, top-level statements execute in order, exactly like a Python script.

### What actually happens when you run this

When you type `nova run hello.nova`, four things happen behind the scenes in a fraction of a second:

1. **Parse** — NOVA reads your source file and builds a tree of the code's structure. There are no braces `{}` for blocks — NOVA uses indentation, like Python. If you indent a line under an `if` or `fn`, it's inside that block.

2. **Type inference** — The compiler runs a Hindley-Milner type inference pass over the entire program. It sees `"Hello, world!"` and knows that's a `string` without you saying so. You almost never need to write type annotations — the compiler figures them out from how you use things.

3. **Compile to machine code** — The typed program is lowered to LLVM IR (the same intermediate format that C and Rust use), then compiled to native machine code for your CPU. This is why NOVA runs at C speed — it uses the exact same compiler backend.

4. **Link and run** — The machine code is linked with the NOVA runtime (a small C library that provides `print`, channels, memory management, etc.) and executed immediately.

If you want a standalone binary instead of running immediately:

```
nova build hello.nova
```

This produces `hello.exe` (Windows) or `hello` (Linux) — a native executable you can copy to any machine with the same OS and run directly. No runtime needed. No Docker. No interpreter.

### Your first function

```nova
fn greet(name)
    print("Hello, {name}!")

greet("NOVA")
greet("world")
```

Output:

```
Hello, NOVA!
Hello, world!
```

Let's break down what's new here:

**`fn greet(name)`** — This defines a function called `greet` that takes one parameter called `name`. Notice there is **no type annotation** on `name`. You didn't write `name: string` — the compiler sees you call `greet("NOVA")` with a string argument, and infers that `name` must be a string. This works automatically for 95% of code.

**`"Hello, {name}!"`** — The `{name}` inside the string is **string interpolation**. NOVA evaluates the expression inside `{}` and inserts its value into the string. You can put any expression inside the braces:

```nova
x = 10
print("x is {x}")              // x is 10
print("double is {x * 2}")     // double is 20
print("sum is {x + 3}")        // sum is 13
```

**This is different from Python.** In Python, you must write `f"Hello, {name}!"` with an `f` prefix for interpolation. Forget the `f` and you get the literal text `Hello, {name}!` with no substitution. In NOVA, every double-quoted string supports `{expr}` interpolation by default. There is no `f` prefix and writing `f"..."` is a syntax error.

> **DO:** Use `{expr}` directly inside strings: `"count = {n + 1}"`, `"name is {user.name}"`
> **DON'T:** Write `f"..."` like Python — NOVA strings always interpolate, and `f"..."` is not valid syntax.

### Escaping braces

What if you want a literal `{` in your string without interpolation? Use `\{`:

```nova
print("JSON looks like \{\"key\": \"value\"\}")
// Output: JSON looks like {"key": "value"}
```

The escape sequences NOVA supports: `\n` (newline), `\t` (tab), `\r` (carriage return), `\\` (literal backslash), `\"` (literal quote), `\{` (literal open brace), `\}` (literal close brace), `\0` (null byte).

### main() — when you need it

For simple scripts, top-level statements work fine. But for real programs, define a `fn main()`:

```nova
fn helper()
    print("I'm a helper")

fn main()
    helper()
    print("Program finished")
```

When `main()` exists, NOVA calls it as the entry point instead of running top-level statements. Use `main()` for any program with multiple functions or that you intend to compile into a binary.

---

## 3. Values and types

NOVA has six built-in types. You almost never need to write a type annotation — the compiler infers the type from how you use the value. This section explains each type, what you can do with it, and what happens when you get it wrong.

### Integers

```nova
x = 42
y = -7
big = 1_000_000        // underscores for readability — ignored by compiler
hex = 0xFF             // hex literal = 255
print(x + y)           // 35
print(big * 2)         // 2000000
```

Integers are 64-bit signed (range: roughly -9.2 quintillion to +9.2 quintillion). That's the same as Java's `long` or C's `int64_t`.

**Overflow behavior:** Unlike C (where signed overflow is undefined behavior — the compiler can do literally anything), NOVA integers **wrap** on overflow. This is defined, predictable two's-complement behavior. You will never get a security vulnerability from integer overflow in NOVA — the number just wraps around.

```nova
// Division and modulo
print(7 / 2)           // 3 — integer division truncates toward zero
print(-7 / 2)          // -3 — truncates toward zero (not toward negative infinity)
print(7 % 3)           // 1
print(-7 % 3)          // -1 — modulo follows the sign of the dividend
```

**Why this matters:** If you're doing `index % array_length` with a potentially negative index, the result can be negative. Python's `%` always returns a non-negative result; NOVA's matches C and Java behavior.

### Floats

```nova
pi = 3.14159
e = 2.71828
tiny = 1e-10           // scientific notation
huge = 6.022e23
print(pi * 2.0)        // 6.28318
```

Floats are 64-bit IEEE 754 doubles — the same as Java's `double`, Python's `float`, and JavaScript's `number`. They follow standard IEEE semantics: `1.0 / 0.0` produces `Inf`, `0.0 / 0.0` produces `NaN`.

**Automatic promotion:** When you mix `int` and `float` in an expression, NOVA promotes the integer to float:

```nova
result = 7 + 0.5       // int 7 becomes float 7.0, then adds 0.5 → 7.5
print(result)           // 7.5
print(type_of(result))  // float
```

**Don't compare floats with ==.** Floating-point arithmetic produces rounding errors:

```nova
print(0.1 + 0.2 == 0.3)   // false — this is true in ALL languages, not a NOVA bug
print(0.1 + 0.2)           // 0.30000000000000004
```

If you need to compare floats, check if the difference is small: `abs(a - b) < 0.0001`.

### Strings

```nova
name = "NOVA"
greeting = "Hello, {name}!"     // interpolation — name is substituted
combined = "Year: " + str(2026) // concatenation with + (str() converts int to string)
print(greeting)                 // Hello, NOVA!
print(len(name))                // 4
```

Strings are immutable UTF-8 byte sequences. Once created, a string cannot be changed — operations like `upper()` return a new string:

```nova
s = "hello world"
upper_s = upper(s)       // "HELLO WORLD" — new string; s is unchanged
words = split(s, " ")    // ["hello", "world"] — returns a list of strings
print(words[0])          // hello
print(s)                 // hello world — s was never modified
```

**Important string operations:**

```nova
s = "Hello, NOVA!"
print(len(s))                      // 12 — byte length
print(starts_with(s, "Hello"))     // true
print(ends_with(s, "!"))           // true
print(contains(s, "NOVA"))         // true
print(replace(s, "NOVA", "World")) // Hello, World!
print(trim("  spaces  "))         // spaces
print(slice(s, 0, 5))             // Hello — substring from index 0 to 5
```

**String building in loops:** Don't concatenate with `+` in a loop — each `+` copies the entire string, giving O(n²) performance for n iterations. For building large strings, collect pieces in a list and `join()` at the end:

```nova
// BAD: O(n²) — copies the whole string each iteration
result = ""
for i in range(0, 1000)
    result = result + str(i) + ","

// GOOD: O(n) — join builds the string once at the end
parts = []
for i in range(0, 1000)
    push(parts, str(i))
result = join(parts, ",")
```

### Booleans

```nova
alive = true
done = false
print(alive and not done)  // true
print(alive or done)       // true
print(not alive)           // false
```

NOVA uses English words `and`, `or`, `not` instead of `&&`, `||`, `!`. This is a deliberate design choice — the code reads like a sentence: "if alive and not done."

Comparison operators return `bool`:

```nova
x = 10
print(x > 5)    // true
print(x == 10)  // true
print(x != 3)   // true
print(x >= 10)  // true
print(x <= 9)   // false
```

### Lists

Lists are ordered, zero-indexed collections that can hold any type of value:

```nova
nums = [1, 2, 3, 4, 5]
names = ["alice", "bob", "carol"]
mixed = [1, "two", 3.0, true]   // lists can hold any type

// Accessing elements
print(nums[0])      // 1 — first element
print(nums[2])      // 3 — third element
print(nums[-1])     // 5 — last element (negative counts from end)
print(nums[-2])     // 4 — second-to-last
print(len(nums))    // 5

// Modifying
push(nums, 6)       // adds 6 to the end → [1, 2, 3, 4, 5, 6]
last = pop(nums)    // removes and returns last → 6, list is back to [1,2,3,4,5]
```

**What happens if you access an out-of-bounds index?** NOVA checks bounds at runtime and reports an error with the index and list length. This is safer than C (which silently reads garbage memory) but means you should always check `len()` if you're not sure:

```nova
nums = [1, 2, 3]
// print(nums[5])    // Runtime error: index 5 out of bounds (length 3)
// print(nums[-4])   // Runtime error: index -4 out of bounds (length 3)

// Safe pattern: check first
if len(nums) > 5
    print(nums[5])
```

**Useful list operations:**

```nova
nums = [3, 1, 4, 1, 5, 9, 2, 6]
sorted_nums = sort(nums)           // [1, 1, 2, 3, 4, 5, 6, 9]
print(contains(nums, 4))           // true
print(len(nums))                   // 8
reversed_nums = reverse(nums)      // [6, 2, 9, 5, 1, 4, 1, 3]

// Higher-order operations
evens = filter(nums, x => x % 2 == 0)    // [4, 2, 6]
doubled = map(nums, x => x * 2)          // [6, 2, 8, 2, 10, 18, 4, 12]
total = reduce(nums, 0, fn(acc, x) acc + x)  // 31
```

### Dicts

Dicts (dictionaries) are hash maps — they store key-value pairs:

```nova
person = {"name": "Alice", "age": 30, "active": true}
print(person["name"])     // Alice
print(person["age"])      // 30

// Add a new key
person["email"] = "alice@example.com"

// Check if a key exists (always do this before accessing)
print(contains(person, "email"))  // true
print(contains(person, "phone"))  // false

// Get all keys
for k in keys(person)
    print("{k}: {person[k]}")
```

**Accessing a missing key returns a default value** (0 for int, "" for string, etc.) rather than crashing. But you should still use `contains()` to check — relying on defaults is fragile code:

```nova
person = {"name": "Alice"}
print(person["age"])       // 0 — key missing, returns default
print(contains(person, "age"))  // false — age was never set
```

### Type inference: how the compiler knows what type everything is

You might have noticed that none of the code above has type annotations. You wrote `x = 42`, not `x: int = 42`. The compiler figures out the types automatically:

```nova
x = 42           // compiler sees 42 → infers x: int
y = 3.14         // compiler sees 3.14 → infers y: float
name = "NOVA"    // compiler sees "..." → infers name: string
items = [1,2,3]  // compiler sees [...] → infers items: list
ok = true        // compiler sees true → infers ok: bool
```

This isn't just for literals. The compiler tracks types through function calls, field accesses, and operations:

```nova
fn double(n)
    n * 2          // compiler sees * 2, infers n is numeric

print(double(5))   // compiler sees double(5): int argument → n is int → returns int
```

**The 95% rule:** For loops, local variables, helper functions, closures, and most function parameters, you write zero annotations and the compiler gets it right. The 5% where you DO write annotations are covered in the [Structs](#6-structs) and [Performance guide](#18-performance-guide) sections.

### When to write a type annotation

There are three cases where annotations help:

**1. Function parameters when you need to force the fast path for struct math:**

```nova
fn dot(a: Point, b: Point) -> float
    a.x * b.x + a.y * b.y
```

Without annotations here, the compiler must infer the type from call sites. With annotations, the function is always compiled as a native float operation. See the [Performance guide](#18-performance-guide) for the full story.

**2. Typed extraction from a database query or JSON body:**

```nova
let items: list = db_all(pool, "SELECT id, title FROM todos")
```

**3. Trait boundaries when a function accepts any type satisfying an interface:**

```nova
fn describe(shape: Shape) -> string
    "{shape.name()} area={shape.area()}"
```

The 95%+ rule: for loops, local variables, helper functions, closures, and most function parameters, you write zero annotations and the compiler gets it right.

> **DO:** Let the compiler infer types from context. Write `x = 42` not `x: int = 42`.
> **DON'T:** Annotate every variable "just to be safe." Redundant annotations add noise without adding safety — the type inferrer will catch type mismatches whether or not you annotate.

---

## 4. Control flow

### if / else as an expression

`if/else` in NOVA is an expression, not just a statement. It evaluates to a value.

```nova
x = 10
label = if x > 5 then "big" else "small"
print(label)   // big
```

When used as a statement (ignoring the return value), the `then` keyword is optional and the body must be on the next indented line:

```nova
if x > 5
    print("big")
else
    print("small")
```

Blocks are indentation-delimited. There are no braces. The body must be indented at least one level deeper than the `if`.

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

print("Grade: {grade}")
```

### while loops

```nova
n = 1
while n <= 10
    print(n)
    n = n + 1
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
// prints: 1 3 5 7 9
```

### for-in loops

```nova
names = ["alice", "bob", "carol"]
for name in names
    print("Hello, {name}!")
```

For loops work over any iterable: lists, dicts (iterates keys), strings (iterates characters), and ranges.

### Ranges

`a..b` creates a range from `a` to `b` inclusive. Use it in for loops:

```nova
for i in 0..4
    print(i)      // 0 1 2 3 4
```

The range `0..n-1` is how you loop `n` times (since the range is inclusive on both ends):

```nova
for i in 0..9
    print(i)     // 0 through 9, ten values total
```

### Iterating with index

When you need both the index and the value:

```nova
fruits = ["apple", "banana", "cherry"]
i = 0
while i < len(fruits)
    print("{i}: {fruits[i]}")
    i = i + 1
```

### Iterating dicts

```nova
scores = {"alice": 95, "bob": 88, "carol": 91}
for name in keys(scores)
    print("{name}: {scores[name]}")
```

The `keys()` built-in returns a list of all keys. Iteration order over dicts is not guaranteed to be insertion order.

### match as a conditional

For multiple conditions on the same value, `match` is cleaner than a chain of `if/else if`. See the [Pattern matching](#8-pattern-matching) section for the full story.

> **DO:** Use `if/else` as an expression to eliminate single-use variables: `let label = if x > 0 then "positive" else "non-positive"`
> **DON'T:** Write `if condition then doSomething()` on one line expecting it to work — `then` is only for the single-expression form. If the body has multiple statements, use the indented block form.

---

## 5. Functions

### Basic function syntax

```nova
fn add(a, b)
    a + b

print(add(3, 4))    // 7
```

The last expression in a function body is the return value. No `return` keyword needed in the common case. The function's return type is inferred.

### Explicit return

Use `return` when you want to exit early:

```nova
fn first_positive(nums)
    for n in nums
        if n > 0
            return n
    return -1    // nothing found

print(first_positive([-3, -1, 5, 8]))   // 5
print(first_positive([-3, -1, -2]))      // -1
```

### Default parameters

Parameters can have default values. Callers can omit them:

```nova
fn greet(name, greeting = "Hello")
    print("{greeting}, {name}!")

greet("Alice")              // Hello, Alice!
greet("Bob", "Welcome")     // Welcome, Bob!
```

Default parameters must come after all required parameters.

### Multiple return values via lists or structs

NOVA functions can return lists or structs to bundle multiple values:

```nova
fn min_max(nums)
    lo = nums[0]
    hi = nums[0]
    for n in nums
        if n < lo
            lo = n
        if n > hi
            hi = n
    [lo, hi]   // return a list of two values

result = min_max([3, 1, 4, 1, 5, 9, 2, 6])
print("min={result[0]} max={result[1]}")
```

Or define a struct (preferred when the result has semantic meaning):

```nova
type MinMax
    lo: int
    hi: int

fn min_max_typed(nums)
    lo = nums[0]
    hi = nums[0]
    for n in nums
        if n < lo
            lo = n
        if n > hi
            hi = n
    MinMax { lo: lo, hi: hi }

r = min_max_typed([3, 1, 4, 1, 5, 9, 2, 6])
print("min={r.lo} max={r.hi}")
```

### Closures

A closure is a function that captures variables from its surrounding scope. Arrow syntax `params => body` creates a closure:

```nova
fn make_adder(n)
    x => x + n        // captures n from the outer scope

add5 = make_adder(5)
add10 = make_adder(10)
print(add5(3))         // 8
print(add10(3))        // 13
print(add5(add10(1)))  // 16
```

Multi-parameter closures use parentheses:

```nova
multiply = (a, b) => a * b
print(multiply(3, 4))   // 12
```

### Higher-order functions

Functions that take functions as arguments. This is how `map`, `filter`, and `reduce` work:

```nova
nums = [1, 2, 3, 4, 5]

doubled = map(nums, x => x * 2)
print(doubled)     // [2, 4, 6, 8, 10]

evens = filter(nums, x => x % 2 == 0)
print(evens)       // [2, 4]

total = reduce(nums, 0, (acc, x) => acc + x)
print(total)       // 15
```

`map` returns a new list with the function applied to every element. `filter` returns a new list with only the elements where the predicate returns `true`. `reduce` folds the list into a single value starting from the initial accumulator.

### Writing your own higher-order function

```nova
fn apply_twice(f, x)
    f(f(x))

double = x => x * 2
print(apply_twice(double, 3))   // 12 (3 -> 6 -> 12)
```

### Recursion

```nova
fn factorial(n)
    if n <= 1
        return 1
    n * factorial(n - 1)

print(factorial(10))    // 3628800
```

```nova
fn fib(n)
    if n <= 1
        return n
    fib(n - 1) + fib(n - 2)

print(fib(10))    // 55
```

NOVA does not eliminate tail calls automatically in this version. For deeply recursive algorithms over large inputs, use iteration to avoid stack overflow.

### Named functions vs closures

Named functions (defined with `fn`) are the right choice for top-level logic, methods on types, and anything that needs to be called from multiple places. Closures (defined with `=>`) are right for short inline transformations passed to higher-order functions.

> **DO:** Use closures for short inline transforms: `filter(items, x => x.active)`
> **DON'T:** Put complex multi-line logic inside a closure — extract it to a named function and pass the name.

---

## 6. Structs

Structs are how you define your own data types in NOVA. A struct groups related fields together under a name. If you're coming from Python, think of it like a `dataclass` with zero boilerplate. From Java, think of a `record`.

### Declaring a struct

```nova
type Point
    x: float
    y: float

type Person
    name: string
    age: int
    active: bool
```

The `type` keyword introduces a struct. Each field goes on its own indented line with a name and a type. That's it — no constructors to write, no `__init__`, no getters/setters.

### THE most important rule in NOVA: lowercase field types

This is the single most common performance mistake new NOVA users make, so read this carefully.

Field types MUST be **lowercase**: `float`, `int`, `string`, `bool`. If you accidentally write a capital letter — `Float`, `Int`, `String` — the compiler treats that field as **dynamically typed**. Every arithmetic operation on a dynamic field goes through a slow dispatch path that checks the type at runtime. The result:

```nova
// CORRECT — compiles to native CPU fmul instructions. Same speed as C.
type FastPoint
    x: float       // lowercase f = native 64-bit double
    y: float

// WRONG — compiles to dynamic dispatch. 150x SLOWER for math.
type SlowPoint
    x: Float       // capital F = dynamic type. DO NOT DO THIS.
    y: Float
```

How much slower? On a benchmark that does `a.x * b.x + a.y * b.y` in a loop:
- `float` (lowercase): **~1.0x C speed** — the compiler emits raw `fmul` + `fadd` instructions
- `Float` (capital): **~150x slower** — every `*` and `+` goes through `nova_rt_mul` which checks the type tag, boxes/unboxes, and dispatches

This is not a theoretical concern. It's the difference between a physics simulation running at 60fps and running at 0.4fps. **Always use lowercase types in struct fields.**

> **DO:** Always write `x: float`, `count: int`, `label: string` in struct field declarations.
> **DON'T:** Write `x: Float` or `count: Int` — capital type names cause dynamic dispatch that is 100-150x slower for math-heavy operations.

### Constructing a struct

```nova
p = Point { x: 3.0, y: 4.0 }
person = Person { name: "Alice", age: 30, active: true }
```

Or positionally (order matches the field declaration order):

```nova
p2 = Point(1.5, 2.5)
```

Both forms are equivalent. Named construction is clearer when there are many fields.

### Accessing fields

```nova
p = Point { x: 3.0, y: 4.0 }
print(p.x)    // 3.0
print(p.y)    // 4.0

person = Person { name: "Alice", age: 30, active: true }
print(person.name)      // Alice
print("{person.name} is {person.age} years old")
```

### Mutating fields

Fields are mutable by assignment:

```nova
p = Point { x: 0.0, y: 0.0 }
p.x = 3.0
p.y = 4.0
print("{p.x}, {p.y}")   // 3.0, 4.0
```

### Methods

Methods are functions that receive the struct as the first argument via `self`. Define them with `fn TypeName.method_name()`:

```nova
type Point
    x: float
    y: float

fn Point.magnitude() -> float
    sqrt(self.x * self.x + self.y * self.y)

fn Point.translate(dx: float, dy: float) -> Point
    Point { x: self.x + dx, y: self.y + dy }

fn Point.scale(factor: float) -> Point
    Point { x: self.x * factor, y: self.y * factor }

fn Point.to_string() -> string
    "({self.x}, {self.y})"

p = Point { x: 3.0, y: 4.0 }
print(p.magnitude())                        // 5.0
print(p.translate(1.0, 2.0).to_string())   // (4.0, 6.0)
print(p.scale(2.0).to_string())            // (6.0, 8.0)
```

Methods that return the same struct type can be chained. Methods are defined outside the `type` block, after it. There is no `impl` keyword or block — each method declaration is independent.

### Structs as values

Structs behave as value types. When passed to functions, a copy is made. A function that modifies a copy does not affect the original.

```nova
fn zeroed(p: Point) -> Point
    Point { x: 0.0, y: 0.0 }

p = Point { x: 3.0, y: 4.0 }
q = zeroed(p)
print(p.x)   // 3.0 — unchanged
print(q.x)   // 0.0
```

When you send a struct over a channel (see [Processes and channels](#11-processes-and-channels)), it is deep-copied so the sender and receiver have independent copies.

### Structs containing structs

```nova
type Circle
    center: Point
    radius: float

fn Circle.area() -> float
    3.14159 * self.radius * self.radius

fn Circle.contains(p: Point) -> bool
    dx = p.x - self.center.x
    dy = p.y - self.center.y
    dx * dx + dy * dy <= self.radius * self.radius

c = Circle { center: Point { x: 0.0, y: 0.0 }, radius: 5.0 }
print(c.area())
print(c.contains(Point { x: 3.0, y: 4.0 }))   // true (on the edge)
print(c.contains(Point { x: 6.0, y: 0.0 }))   // false
```

### Traits

A trait declares a set of methods that a type must implement. Any type that provides all the methods satisfies the trait without explicit declaration:

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

Traits are structural: any type that provides the declared methods automatically satisfies the trait. There is no `implements Shape` declaration needed anywhere.

---

## 7. Enums

Enums are sum types — a value of an enum type is one of several possible variants. Each variant can carry different data.

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

Unit variants (no data) use empty parentheses: `Red()`. Variants with data list their fields inside parentheses with names and types.

### Constructing enum values

```nova
c = Red()
s1 = Circle(5.0)
s2 = Rectangle(4.0, 6.0)
```

Or named-field construction:

```nova
s3 = Circle { radius: 3.0 }
```

### Pattern matching on enums

The typical way to work with an enum is a `match` expression:

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

The variant names in `match` arms bind their fields to local variables: `Circle(r)` binds the radius to `r`.

### Real-world example: a result-like enum

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

r2 = parse_int_strict("abc")
match r2
    Success(n) => print("parsed: {n}")
    Failure(msg) => print("error: {msg}")
```

> **DO:** Use enums when a value can be one of several different "shapes" with different data. Enum + match is the correct pattern for representing states, results, and variants.
> **DON'T:** Use a dict with a "type" key and conditional field checking to simulate sum types — that is the Python workaround that NOVA's enum system makes unnecessary.

---

## 8. Pattern matching

`match` is NOVA's most powerful control flow expression. It tests a value against a series of patterns and runs the first matching arm.

### Basic match

```nova
x = 3

label = match x
    1 => "one"
    2 => "two"
    3 => "three"
    _ => "other"

print(label)    // three
```

The `_` wildcard matches anything. In NOVA, `match` arms do not fall through — only the first matching arm runs.

### match is an expression

```nova
fn classify(n)
    match n
        0 => "zero"
        1 => "one"
        _ => "many"

print(classify(0))    // zero
print(classify(1))    // one
print(classify(7))    // many
```

### Guards

Guards add a condition to a pattern arm with `if`:

```nova
fn describe_number(n)
    match n
        x if x < 0    => "negative"
        x if x == 0   => "zero"
        x if x < 10   => "small positive"
        x if x < 100  => "medium positive"
        _              => "large positive"

print(describe_number(-5))   // negative
print(describe_number(0))    // zero
print(describe_number(7))    // small positive
print(describe_number(50))   // medium positive
print(describe_number(200))  // large positive
```

The pattern variable (`x`) is bound first, then the guard is evaluated. If the guard fails, the arm is skipped and the next arm is tried.

### FizzBuzz with match and guards

```nova
fn fizzbuzz(n)
    match n
        x if x % 15 == 0 => "FizzBuzz"
        x if x % 3 == 0  => "Fizz"
        x if x % 5 == 0  => "Buzz"
        x                => str(x)

for i in 1..20
    print(fizzbuzz(i))
```

### Matching enums with destructuring

```nova
enum Message
    Quit()
    Move(x: int, y: int)
    Write(text: string)

fn process(msg)
    match msg
        Quit() =>
            print("quitting")
        Move(x, y) =>
            print("move to ({x}, {y})")
        Write(text) =>
            print("write: {text}")

process(Move(10, 20))    // move to (10, 20)
process(Write("hello"))  // write: hello
process(Quit())          // quitting
```

When an arm body spans multiple statements, indent them under the `=>`:

```nova
fn handle_verbose(msg)
    match msg
        Move(x, y) =>
            print("moving")
            print("destination: ({x}, {y})")
        _ =>
            print("other message")
```

### Matching structs with destructuring

```nova
type Point
    x: int
    y: int

fn describe_point(p: Point) -> string
    match p
        Point(x, y) => "({x}, {y})"

p = Point { x: 3, y: 4 }
print(describe_point(p))    // (3, 4)
```

### Matching Result

`Result<T>` is NOVA's built-in type for representing success or failure. It has two variants: `Ok(value)` and `Err(message)`. The canonical way to handle it is `match`:

```nova
r = some_function_that_can_fail()
match r
    Ok(value) =>
        print("success: {value}")
    Err(msg) =>
        print("error: {msg}")
```

See [Error handling](#9-error-handling) for the full story.

### String matching

Match also works on strings:

```nova
fn http_method_label(method)
    match method
        "GET"    => "read"
        "POST"   => "create"
        "PUT"    => "update"
        "DELETE" => "delete"
        _        => "unknown"

print(http_method_label("GET"))     // read
print(http_method_label("PATCH"))   // unknown
```

> **DO:** Always include a `_` catch-all in match expressions unless you have proven that all possible values are covered by the explicit arms.
> **DON'T:** Write a match with no wildcard arm on an open-ended type like `string` or `int` — if no arm matches at runtime, the program reports an error.

---

## 9. Error handling

NOVA has no exceptions. Errors are values. The type `Result<T>` represents either a successful value of type `T` or an error string. Every function that can fail returns a `Result`.

### The Result type

`Result` is a built-in enum equivalent to:

```
enum Result<T>
    Ok(value: T)
    Err(message: string)
```

Using it:

```nova
fn divide(a: float, b: float) -> Result
    if b == 0.0
        return Err("division by zero")
    Ok(a / b)

r = divide(10.0, 3.0)
match r
    Ok(v) => print("result: {v}")
    Err(e) => print("error: {e}")

r2 = divide(5.0, 0.0)
match r2
    Ok(v) => print("result: {v}")
    Err(e) => print("error: {e}")    // error: division by zero
```

### try: propagating errors

When a function calls another fallible function and wants to propagate the error upward without boilerplate, use `try`:

```nova
fn parse_and_divide(s1: string, s2: string) -> Result
    a = try float(s1)    // returns Err immediately if float() fails
    b = try float(s2)
    divide(a, b)         // returns Ok(result) or Err("division by zero")

r = parse_and_divide("10", "4")
match r
    Ok(v) => print("answer: {v}")
    Err(e) => print("failed: {e}")
```

`try expr` unwraps the `Ok(v)` and evaluates to `v`. If the result is `Err(msg)`, it returns `Err(msg)` immediately from the current function. This is NOVA's equivalent of Rust's `?` operator and Go's `if err != nil { return err }`, expressed in a single word.

### Never panic on user input

The golden rule: functions that receive external input must never assume it is valid. Always validate and return `Err` rather than panicking or crashing.

```nova
fn parse_user_id(s: string) -> Result
    if len(s) == 0
        return Err("empty user ID")
    n = int(s)
    if n <= 0
        return Err("user ID must be positive, got: {s}")
    Ok(n)

fn lookup_user(id_str: string) -> Result
    id = try parse_user_id(id_str)
    // ... look up in DB ...
    Ok("user_{id}")

match lookup_user("42")
    Ok(user) => print("found: {user}")
    Err(e)   => print("error: {e}")

match lookup_user("")
    Ok(user) => print("found: {user}")
    Err(e)   => print("error: {e}")   // error: empty user ID
```

### Building a chain of fallible operations

The power of `try` is that it makes a chain of fallible operations look like a straight-line sequence of steps:

```nova
fn process_config(path: string) -> Result
    contents = try read_file(path)         // fail if file missing
    parsed   = try parse_json(contents)    // fail if not valid JSON
    host     = try get_field(parsed, "host")
    port_str = try get_field(parsed, "port")
    port     = try int(port_str)
    Ok({"host": host, "port": port})

match process_config("config.json")
    Ok(cfg)  => print("connecting to {cfg["host"]}:{cfg["port"]}")
    Err(msg) => print("config error: {msg}")
```

Each `try` line short-circuits the function if that step fails, carrying the original error message all the way up to the caller.

### Providing fallback values

Use `match` to handle the error case by substituting a default:

```nova
fn get_port(cfg) -> int
    match cfg["port"]
        Ok(v) => int(v)
        Err(_) => 8080   // default port
```

Or check with `contains` before accessing:

```nova
fn get_or_default(d, key, default_val)
    if contains(d, key)
        d[key]
    else
        default_val

port = get_or_default(cfg, "port", 8080)
```

> **DO:** Return `Err("description of what went wrong")` from any function that receives external input and can detect a problem.
> **DON'T:** Return a sentinel value like `-1` or `""` to signal failure — that forces the caller to know about the sentinel and check for it. `Result` makes the failure path explicit in the type.

---

## 10. Lists, dicts, strings

### List operations

```nova
nums = [3, 1, 4, 1, 5, 9, 2, 6]

// Length
print(len(nums))      // 8

// Index access
print(nums[0])        // 3 (first)
print(nums[-1])       // 6 (last)
print(nums[-2])       // 2 (second to last)

// Slice: nums[a:b] gives elements from index a up to (not including) b
first_three = nums[0:3]   // [3, 1, 4]

// Append
nums.push(7)
print(nums[-1])       // 7

// Remove last
last = nums.pop()
print(last)           // 7

// Sort in place
sort(nums)
print(nums)           // [1, 1, 2, 3, 4, 5, 6, 9]

// Membership test
print(5 in nums)      // true
print(7 in nums)      // false

// Concatenate two lists
a = [1, 2, 3]
b = [4, 5, 6]
c = a + b
print(c)              // [1, 2, 3, 4, 5, 6]

// Join into a string
words = ["hello", "world"]
print(join(words, " "))   // hello world
print(join(words, ", "))  // hello, world
```

### Functional list operations

```nova
nums = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

// map: transform each element
squares = map(nums, x => x * x)
print(squares)   // [1, 4, 9, 16, 25, 36, 49, 64, 81, 100]

// filter: keep elements matching a predicate
evens = filter(nums, x => x % 2 == 0)
print(evens)     // [2, 4, 6, 8, 10]

// reduce: fold into a single value
total = reduce(nums, 0, (acc, x) => acc + x)
print(total)     // 55

// Chaining (outer to inner)
big_squares_sum = reduce(
    filter(map(nums, x => x * x), x => x > 20),
    0,
    (acc, x) => acc + x
)
print(big_squares_sum)    // 25 + 36 + 49 + 64 + 81 + 100 = 355
```

### Dict operations

```nova
d = {"a": 1, "b": 2, "c": 3}

// Access
print(d["a"])          // 1

// Check presence
print("a" in d)        // true
print("z" in d)        // false
print(contains(d, "b")) // true

// Set (mutates in place)
d["d"] = 4
print(len(d))          // 4

// All keys
ks = keys(d)

// All values
vs = values(d)

// Delete a key
delete(d, "a")
print(contains(d, "a"))  // false
print(len(d))             // 3

// Iterate key-value pairs
for k in keys(d)
    print("{k} -> {d[k]}")
```

### String operations

```nova
s = "  Hello, World!  "

// Case
print(upper(s))    // "  HELLO, WORLD!  "
print(lower(s))    // "  hello, world!  "

// Trim whitespace
print(trim(s))     // "Hello, World!"

// Length (byte count)
print(len(s))      // 18

// Split
words = split("one two three", " ")
print(words)       // ["one", "two", "three"]

csv_line = split("a,b,c,d", ",")
print(csv_line[2])  // c

// Join
print(join(["a", "b", "c"], "-"))   // a-b-c

// Replace
print(replace("hello world", "world", "NOVA"))  // hello NOVA

// Substring search
print(find("hello world", "world"))   // 6 (index of first match)
print(find("hello world", "xyz"))     // -1 (not found)

// Slice (returns substring)
print(slice("hello world", 6, 11))   // world

// Starts/ends with
print(starts_with("hello", "hel"))   // true
print(ends_with("world", "ld"))      // true

// Character access
s2 = "NOVA"
print(char_at(s2, 0))    // N
print(char_at(s2, -1))   // A (negative indexes work)

// Iterate characters
for c in "abc"
    print(c)      // a, b, c (one per line)

// Convert between types
print(str(42))        // "42"
print(str(3.14))      // "3.14"
print(int("42"))      // 42
print(float("3.14"))  // 3.14
print(int(3.9))       // 3 (truncates)
```

### String building

Building strings by concatenation in a loop is O(n²) — each `+` creates a new allocation. For building long strings, collect parts in a list and join at the end:

```nova
fn build_report(items)
    parts = []
    parts.push("Report:\n")
    for item in items
        parts.push("  - {item}\n")
    parts.push("Total: {len(items)} items\n")
    join(parts, "")

print(build_report(["alpha", "beta", "gamma"]))
```

> **DO:** Use `join(parts_list, "")` to assemble a string from many pieces in a loop.
> **DON'T:** Write `result = result + piece` inside a loop with many iterations — each concatenation copies the entire accumulated string, giving O(n^2) total cost.

---

## 11. Processes and channels

This is where NOVA becomes fundamentally different from most languages. In Python, you use threads with locks (and hope you don't forget a lock). In JavaScript, you use `async/await` (and every async function forces its callers to be async too). In Go, you use goroutines and channels (closer to NOVA, but with shared memory). In Rust, the borrow checker prevents data races (but forces you to fight with lifetimes).

NOVA's approach: **processes never share memory**. Period. When you send data from one task to another, it's deep-copied. This makes data races impossible — not by discipline ("remember to use a lock"), not by a type system rule ("annotate with Send + Sync"), but by construction. There is no API for sharing memory between tasks.

### spawn — creating a task

`spawn` creates a new green task. A green task is like Go's goroutine: it's extremely lightweight (~2KB stack), scheduled cooperatively by the NOVA runtime across a thread pool, and costs almost nothing to create.

```nova
spawn fn()
    print("I run in a separate green task")

print("I run in the main task")
// Both lines print. Order between tasks is NOT guaranteed.
```

You can spawn thousands of tasks trivially:

```nova
fn main()
    for i in range(0, 10000)
        spawn fn()
            // Each task does its own work independently
            let result = i * i
    print("Spawned 10,000 tasks")
    // Total time: ~100ms on typical hardware
```

**No `async` keyword. No colored functions.** In JavaScript, if a function uses `await`, it must be declared `async`, and every function that calls it must also be `async`. This "function coloring" spreads through your entire codebase. In NOVA, `spawn` and `recv` are regular expressions. Any function can use them without changing its signature or its callers.

### channel — talking between tasks

A channel is a queue. One task puts values in with `send()`. Another task takes values out with `recv()`. If the queue is empty, `recv()` blocks the current task (NOT the OS thread — just this green task) until something arrives:

```nova
ch = channel()

spawn fn()
    // This task sends a value into the channel
    send(ch, 42)

// The main task waits here until the spawned task sends
result = recv(ch)
print(result)    // 42
```

Think of a channel like a pipe between two people. Person A drops a message into the pipe. Person B picks it up on the other end. They don't need to be in the same room. They don't need to agree on a time. They just use the pipe.

### Ownership transfer — why data races are impossible

This is the key design insight. When you `send(ch, data)`, NOVA **deep-copies** the data into the channel. Both the sender and receiver have their own independent copies. They can modify their copies without affecting each other:

```nova
items = [1, 2, 3]
ch = channel()

spawn fn()
    received = recv(ch)
    push(received, 99)     // modifies the RECEIVED copy
    print(received)        // [1, 2, 3, 99]

send(ch, items)            // sends a deep copy
push(items, 4)             // modifies the ORIGINAL — safe!
print(items)               // [1, 2, 3, 4]
```

**Why deep-copy instead of shared memory?** Because shared memory is the root cause of almost every concurrency bug:

- **Data races**: Two threads modify the same list simultaneously → corrupted data
- **Deadlocks**: Two threads each wait for a lock the other holds → program freezes
- **Use-after-free**: One thread frees memory while another is reading it → crash or security vulnerability

NOVA eliminates all of these. Two tasks cannot touch the same memory. If you need to communicate, you copy the data through a channel. This is slightly more memory usage than shared memory, but it's correct by default — you don't need to think about thread safety.

### How data races actually happen (in other languages) and why they can't in NOVA

In Python:

```python
# DANGEROUS: shared mutable state
counter = [0]

def increment():
    for _ in range(1000000):
        counter[0] += 1    # Not atomic! Two threads can read-modify-write simultaneously

# With two threads, counter might be 1,500,000 instead of 2,000,000
```

In NOVA, this pattern is structurally impossible. Each task gets its own copy of any data it receives, and there's no way to reference the "same" list from two tasks.

```nova
items = [1, 2, 3]
ch = channel()

spawn fn()
    data = receive(ch)
    data.push(99)            // modifies the received copy
    send(ch, len(data))

send(ch, items)              // sends a deep copy of items
items.push(4)                // safe — modifies original, not the copy that was sent

count = receive(ch)
print(count)          // 4 (the copy had 3 items + 1 pushed = 4)
print(len(items))     // 4 (original also has 4 after our push)
```

Deep copy on send is the mechanism that makes NOVA concurrency safe without a shared-memory model or locks.

### Fan-out pattern

One producer sends work to multiple workers:

```nova
work_ch = channel()
result_ch = channel()

// Start 4 workers
for i in 0..3
    spawn fn()
        while true
            job = receive(work_ch)
            if job < 0
                break
            result = job * job    // simulate work
            send(result_ch, result)

// Send 8 jobs
for i in 1..8
    send(work_ch, i)

// Send 4 poison pills to shut down workers
for i in 0..3
    send(work_ch, -1)

// Collect 8 results
for i in 0..7
    r = receive(result_ch)
    print(r)
```

### Fan-in pattern

Multiple producers, one consumer collects:

```nova
ch = channel()

for i in 1..5
    let n = i
    spawn fn()
        send(ch, n * 10)

total = 0
for i in 0..4
    total = total + receive(ch)
print("total = {total}")    // total = 150 (10+20+30+40+50)
```

### select

`select` receives from whichever of several channels has data first:

```nova
ch1 = channel()
ch2 = channel()

spawn fn()
    send(ch1, "hello from ch1")

spawn fn()
    send(ch2, "hello from ch2")

// Receive whichever arrives first
result = select(ch1, ch2)
idx = result[0]      // which channel index won (0 or 1)
val = result[1]      // the value
print("channel {idx} arrived first: {val}")
```

`select` returns a two-element list: `[channel_index, value]`.

### Bidirectional communication

```nova
req_ch = channel()
rsp_ch = channel()

// Server task
spawn fn()
    while true
        req = receive(req_ch)
        if req == "quit"
            send(rsp_ch, "goodbye")
            break
        send(rsp_ch, "echo: {req}")

// Client side
send(req_ch, "hello")
print(receive(rsp_ch))    // echo: hello

send(req_ch, "world")
print(receive(rsp_ch))    // echo: world

send(req_ch, "quit")
print(receive(rsp_ch))    // goodbye
```

### reschedule()

`reschedule()` yields the current green task to the scheduler, giving other tasks a chance to run. Use this in tight loops that do not block on I/O:

```nova
fn count_to_million()
    n = 0
    while n < 1_000_000
        n = n + 1
        if n % 10000 == 0
            reschedule()   // yield every 10k iterations so other tasks can run
    n

spawn fn()
    result = count_to_million()
    print("done: {result}")

// Other tasks can still run because count_to_million() yields periodically
spawn fn()
    print("I can run even while counting happens")
```

> **DO:** Use `reschedule()` in any long-running CPU-bound loop inside a spawned task to prevent it from starving other green tasks.
> **DON'T:** Call `sleep(0)` to yield — it puts the task to sleep for an OS timer tick (often 15ms on Windows), which is far slower. `reschedule()` is immediate.

---

## 12. Modules

### Importing modules

```nova
import forge
import forge_db
import corex
```

`import modname` makes all exported names from the module available, qualified with the module name:

```nova
import forge

app = forge.app()
forge.get(app, "/", fn(req) "Hello!")
forge.serve(app, 8080)
```

### Module resolution

When NOVA sees `import forge`, it searches in order:

1. The directory of the current file (relative imports)
2. `$NOVA_HOME/lib/` (standard library)

So `import forge` resolves to `$NOVA_HOME/lib/forge.nova`. This is why `NOVA_HOME` must be set correctly.

For your own modules, put them in the same directory as your main file:

**math_utils.nova:**

```nova
fn square(x: float) -> float
    x * x

fn cube(x: float) -> float
    x * x * x
```

**main.nova (same directory):**

```nova
import math_utils

print(math_utils.square(4.0))  // 16.0
print(math_utils.cube(3.0))    // 27.0
```

### Selective import

To bring specific names into scope without the module prefix:

```nova
import forge { app, get, post, serve }

a = app()
get(a, "/", fn(req) "Hello!")
serve(a, 8080)
```

### Module files are just NOVA files

A module file is a regular NOVA file. Any top-level function or type defined in it is exported. Functions prefixed with `_` are private to the file and not accessible from outside.

```nova
// in mylib.nova

fn public_fn(x)        // exported — callers can use mylib.public_fn
    _helper(x)

fn _helper(x)          // private — underscore prefix means file-private
    x * 2
```

### NOVA_HOME and the standard library

The standard library lives in `$NOVA_HOME/lib/`. The modules available include:

| Module | Purpose |
|---|---|
| `forge` | HTTP server, routing, middleware, WebSocket, SSE |
| `forge_db` | SQLite connection pool, parameterized queries, transactions |
| `forge_crypto` | SHA-256/512, HMAC, AES, ChaCha20, X25519, Ed25519 |
| `forge_tls` | TLS 1.3 handshake crypto |
| `forge_auth` | RBAC authorization helpers |
| `corex` | Utilities: enumerate, zip, flatten, chunk |
| `urlx` | URL encoding/decoding |
| `csvx` | CSV parsing |
| `strx` | Extended string operations |
| `bignum` | Arbitrary precision integers |
| `uuid` | UUID generation |
| `prng` | Pseudo-random number generator |

> **DO:** Set `NOVA_HOME` before running any program that uses `import`. Verify with `ls $NOVA_HOME/lib/forge.nova`.
> **DON'T:** Put module files outside the search paths — the error message shows the path it tried, which tells you exactly where to put the file.

---

## 13. Forge: building a REST API

Forge is NOVA's built-in web framework. When you write `import forge`, you get a full HTTP server — routing, JSON serialization, query parsing, WebSocket support, SQLite integration, JWT authentication, and CSRF protection — all in one import. No package manager, no dependency tree, no virtual environment.

**What makes Forge different from Flask/Express/Gin:**

- **It's compiled.** `nova build server.nova` produces a single ~1.6MB executable. Copy it to a server and run it. No Python runtime, no Node.js, no JVM.
- **It's fast.** Forge serves requests at C speed. Each request runs in its own green task with arena-scoped memory, so there are no GC pauses.
- **Structs are JSON.** Return a struct from a handler and Forge automatically serializes it to JSON. Receive JSON in a POST body and Forge automatically deserializes it into a typed struct with validation. No `json.dumps()`, no `JSON.parse()`, no DTO mapping layer.

### The minimal server

Let's build a working HTTP server in 8 lines:

```nova
import forge

fn main()
    let app = forge.app()

    // When someone visits http://localhost:8080/, respond with plain text
    forge.get(app, "/", fn(req)
        forge.text(200, "Hello from NOVA!"))

    // Start listening on port 8080. This blocks forever.
    forge.serve(app, 8080)
```

Save this as `server.nova` and run it:

```
nova run server.nova
```

In another terminal, test it:

```
curl http://localhost:8080/
```

Output: `Hello from NOVA!`

**What happened:** `forge.app()` creates an application. `forge.get(app, "/", handler)` registers a handler for GET requests to `/`. `forge.serve(app, 8080)` starts a TCP listener, spawns a green task for each incoming connection, parses the HTTP request, matches it against registered routes, calls your handler, and sends the response. All of that is inside `forge.serve` — you just write the handler.

### Routes — mapping URLs to handlers

Forge supports all standard HTTP methods. Each route is a URL pattern and a handler function:

```nova
forge.get(app, "/users", list_users)         // GET  /users
forge.post(app, "/users", create_user)       // POST /users
forge.put(app, "/users/:id", update_user)    // PUT  /users/42
forge.delete(app, "/users/:id", delete_user) // DELETE /users/42
forge.patch(app, "/users/:id", patch_user)   // PATCH  /users/42
```

Each handler receives a request object and returns a response. The simplest response is `forge.text(status_code, body)`.

**What if someone requests a route you didn't register?** Forge returns HTTP 404 automatically. If they use the wrong HTTP method (e.g., POST to a GET-only route), Forge returns HTTP 405. You don't write these — they're built in.

### Path parameters — capturing parts of the URL

Put `:name` in a route pattern to capture a dynamic URL segment:

```nova
forge.get(app, "/users/:id", fn(req)
    // If someone visits /users/42, id will be "42"
    let id = forge.param(req, "id")
    forge.text(200, "User ID: {id}")
)

forge.get(app, "/posts/:year/:slug", fn(req)
    let year = forge.param(req, "year")
    let slug = forge.param(req, "slug")
    forge.text(200, "Post: {year}/{slug}")
)
// GET /posts/2026/hello-world → "Post: 2026/hello-world"
```

`forge.param(req, "name")` returns the captured segment as a string. If you need it as an integer, use `parse_int(forge.param(req, "id"))`.

### Query parameters — reading ?key=value from the URL

```nova
forge.get(app, "/search", fn(req)
    let q = forge.query_get(req, "q")              // the search term
    let limit_str = forge.query_get(req, "limit")   // might be empty
    let limit = if len(limit_str) > 0 then parse_int(limit_str) else 10

    forge.text(200, "Searching for '{q}' with limit {limit}")
)
// GET /search?q=nova&limit=5 → "Searching for 'nova' with limit 5"
// GET /search?q=nova          → "Searching for 'nova' with limit 10" (default)
```

`forge.query_get(req, "key")` returns the value as a string, or `""` if the parameter is missing. Always check `len()` before parsing — an empty string passed to `parse_int` will return an error.

### Request body — reading what the client sent

For POST/PUT/PATCH requests, the client sends data in the body:

```nova
forge.post(app, "/echo", fn(req)
    let body = forge.body(req)
    forge.text(200, "You sent: {body}")
)
// curl -X POST -d "hello" http://localhost:8080/echo
// → "You sent: hello"
```

`forge.body(req)` returns the raw request body as a string. For JSON bodies, you'll usually want `body_as` instead (next section).

### Returning JSON

Two ways to return JSON:

**1. Return a struct (auto-serialized, idiomatic):**

```nova
type StatusResponse
    status: string
    uptime: int

forge.get(app, "/status", fn(req)
    StatusResponse { status: "ok", uptime: 42 }
)
```

When a handler returns a struct, Forge automatically serializes it to JSON and sends a `200 application/json` response. This is the idiomatic NOVA way — define your response types as structs and return them directly.

**2. Use `forge.json` with a JSON string:**

```nova
forge.get(app, "/raw", fn(req)
    forge.json(200, "\{\"status\": \"ok\"\}")
)
```

### Typed request body

Use `forge.body_as(req)` to parse the JSON request body into a struct:

```nova
type CreateUserRequest
    name: string
    email: string
    age: int

forge.post(app, "/users", fn(req)
    parsed = forge.body_as(req)
    match parsed
        Ok(user) =>
            // user is now a CreateUserRequest struct
            print("Creating user: {user.name}")
            user   // echo back as JSON
        Err(e) =>
            forge.text(422, "invalid request: {e}")
)
```

If the request body is not valid JSON or is missing required fields, `body_as` returns `Err` with a description of what went wrong. Always match the result — never assume the body is valid.

### A complete CRUD REST API

Here is a complete, working Todo CRUD API with in-memory storage:

```nova
import forge

type Todo
    id: int
    title: string
    done: int   // 0 or 1

type CreateTodo
    title: string

// In-memory store
let todos = []
let next_id = 1

fn list_todos(req: Request)
    todos

fn get_todo(req: Request)
    id = int(forge.param(req, "id"))
    for todo in todos
        if todo.id == id
            return todo
    forge.text(404, "not found")

fn create_todo(req: Request)
    parsed = forge.body_as(req)
    match parsed
        Ok(body) =>
            todo = Todo { id: next_id, title: body.title, done: 0 }
            next_id = next_id + 1
            todos.push(todo)
            forge.resp_json(201, todo)
        Err(e) =>
            forge.text(422, "invalid request: {e}")

fn update_todo(req: Request)
    id = int(forge.param(req, "id"))
    parsed = forge.body_as(req)
    match parsed
        Ok(body) =>
            i = 0
            while i < len(todos)
                if todos[i].id == id
                    todos[i].title = body.title
                    todos[i].done = body.done
                    return todos[i]
                i = i + 1
            forge.text(404, "not found")
        Err(e) =>
            forge.text(422, "invalid request: {e}")

fn delete_todo(req: Request)
    id = int(forge.param(req, "id"))
    i = 0
    while i < len(todos)
        if todos[i].id == id
            todos.pop(i)
            return forge.text(204, "")
        i = i + 1
    forge.text(404, "not found")

fn main()
    app = forge.app()

    // Middleware (registered before routes)
    forge.use(app, forge.mw_cors_origin("*"))
    forge.use(app, forge.mw_logger())

    // Health check
    forge.get(app, "/health", fn(req)
        {"status": "ok", "count": len(todos)}
    )

    // CRUD routes
    forge.get(app, "/todos",        fn(req) list_todos(req))
    forge.get(app, "/todos/:id",    fn(req) get_todo(req))
    forge.post(app, "/todos",       fn(req) create_todo(req))
    forge.put(app, "/todos/:id",    fn(req) update_todo(req))
    forge.delete(app, "/todos/:id", fn(req) delete_todo(req))

    print("Listening on :8080")
    forge.serve(app, 8080)
```

Test it:

```bash
# Health check
curl http://localhost:8080/health

# Create
curl -X POST http://localhost:8080/todos \
     -H "Content-Type: application/json" \
     -d '{"title":"buy milk"}'

# List all
curl http://localhost:8080/todos

# Get one
curl http://localhost:8080/todos/1

# Update
curl -X PUT http://localhost:8080/todos/1 \
     -H "Content-Type: application/json" \
     -d '{"title":"buy oat milk","done":1}'

# Delete
curl -X DELETE http://localhost:8080/todos/1
```

### Middleware

Middleware wraps every request. Register it with `forge.use`:

```nova
// CORS headers on every response
forge.use(app, forge.mw_cors_origin("*"))

// Request logging to stdout
forge.use(app, forge.mw_logger())

// Require a valid JWT bearer token
forge.use(app, forge.mw_require_auth("my-jwt-secret"))
```

Middleware is applied in registration order, outermost first. CORS and logging should be registered before route-specific middleware so they wrap every request.

### Custom middleware

A middleware is a function that takes `(req, next)` and calls `next(req)`:

```nova
fn mw_timing(req, next)
    start = time_ms()
    response = next(req)
    elapsed = time_ms() - start
    print("request took {elapsed}ms")
    response

forge.use(app, mw_timing)
```

### Error responses

Forge provides response builders for common status codes:

```nova
forge.text(400, "bad request: {reason}")
forge.text(401, "unauthorized")
forge.text(403, "forbidden")
forge.text(404, "not found")
forge.text(422, "invalid input: {detail}")
forge.text(500, "internal server error")
```

For JSON error responses, define an error struct:

```nova
type ErrorResponse
    error: string

fn bad_request(msg: string)
    forge.resp_json(400, ErrorResponse { error: msg })
```

> **DO:** Use `forge.body_as(req)` and match the Result to handle both the valid and invalid body cases. This protects your API against malformed input without crashing.
> **DON'T:** Call `forge.body(req)` and manually parse JSON when you need a typed struct — `body_as` handles parsing, type checking, and error reporting in one step.

---

## 14. Forge: SQLite data layer

For persistence, NOVA provides `forge_db`: a SQLite driver with connection pooling, parameterized queries, and transaction support. All queries are injection-safe by construction — values are always bound as parameters, never concatenated into SQL strings.

### Opening a connection pool

```nova
import forge
import forge_db

fn main()
    // File database with 4 connections
    pool = forge_db.pool_open("myapp.db", 4)

    // In-memory database (for tests)
    test_pool = forge_db.pool_open(":memory:", 1)
```

The second argument is the pool size — how many concurrent SQLite connections to maintain. For a web server with concurrent requests, use 2-8 connections.

### DDL: creating tables

```nova
forge_db.pool_exec(pool, "CREATE TABLE IF NOT EXISTS users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL,
    created_at INTEGER NOT NULL
)")
```

`pool_exec` runs a statement that returns no rows (DDL, INSERT without RETURNING, UPDATE, DELETE).

### Parameterized queries

Always use `?` placeholders instead of string concatenation:

```nova
// CORRECT: parameterized, injection-safe
forge_db.pool_query(pool,
    "INSERT INTO users (name, email, created_at) VALUES (?, ?, ?)",
    ["Alice", "alice@example.com", time_ms()])

// NEVER DO THIS: string concatenation in SQL
// forge_db.pool_exec(pool, "INSERT INTO users VALUES ('" + user_input + "')")
```

### Querying rows

`pool_query` returns rows as a list of lists:

```nova
rows = forge_db.pool_query(pool,
    "SELECT id, name, email FROM users ORDER BY id", [])

for row in rows
    id    = row[0]
    name  = row[1]
    email = row[2]
    print("{id}: {name} <{email}>")
```

### Typed row extraction

Use `pool_query_dicts` to get rows as dicts with column names as keys:

```nova
rows = forge_db.pool_query_dicts(pool,
    "SELECT id, name, email FROM users WHERE id = ?",
    [user_id],
    ["id", "name", "email"])

if len(rows) == 0
    return forge.text(404, "user not found")

user = rows[0]
print("{user["name"]} <{user["email"]}>")
```

### Auto-increment IDs

`pool_insert` returns the auto-generated row ID:

```nova
id = forge_db.pool_insert(pool,
    "INSERT INTO todos (title, done) VALUES (?, ?)",
    ["buy milk", 0])

print("created todo with id {id}")
```

### Transactions

Wrap multiple statements in a transaction that commits atomically or rolls back on error:

```nova
forge_db.tx(pool, [
    ["INSERT INTO accounts (id, balance) VALUES (?, ?)", [1, 1000]],
    ["INSERT INTO accounts (id, balance) VALUES (?, ?)", [2, 500]],
    ["UPDATE accounts SET balance = balance - 100 WHERE id = ?", [1]],
    ["UPDATE accounts SET balance = balance + 100 WHERE id = ?", [2]]
])
```

If any statement fails, the entire transaction rolls back.

### A complete Forge API with SQLite

```nova
import forge
import forge_db

type Todo
    id: int
    title: string
    done: int

type CreateTodo
    title: string

fn setup_db(pool)
    forge_db.pool_exec(pool, "CREATE TABLE IF NOT EXISTS todos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        done INTEGER NOT NULL DEFAULT 0
    )")

fn list_todos(req: Request, pool)
    rows = forge_db.pool_query_dicts(pool,
        "SELECT id, title, done FROM todos ORDER BY id", [],
        ["id", "title", "done"])
    map(rows, r => Todo {
        id: int(r["id"]),
        title: r["title"],
        done: int(r["done"])
    })

fn get_todo(req: Request, pool)
    id = int(forge.param(req, "id"))
    rows = forge_db.pool_query_dicts(pool,
        "SELECT id, title, done FROM todos WHERE id = ?", [id],
        ["id", "title", "done"])
    if len(rows) == 0
        return forge.text(404, "todo not found")
    r = rows[0]
    Todo { id: int(r["id"]), title: r["title"], done: int(r["done"]) }

fn create_todo(req: Request, pool)
    parsed = forge.body_as(req)
    match parsed
        Ok(body) =>
            id = forge_db.pool_insert(pool,
                "INSERT INTO todos (title, done) VALUES (?, ?)",
                [body.title, 0])
            forge.resp_json(201, Todo { id: id, title: body.title, done: 0 })
        Err(e) =>
            forge.text(422, "invalid request: {e}")

fn delete_todo(req: Request, pool)
    id = int(forge.param(req, "id"))
    forge_db.pool_exec(pool, "DELETE FROM todos WHERE id = ?")
    forge.text(204, "")

fn main()
    pool = forge_db.pool_open("todos.db", 4)
    setup_db(pool)

    app = forge.app()
    forge.use(app, forge.mw_cors_origin("*"))
    forge.use(app, forge.mw_logger())

    let p = pool
    forge.get(app, "/todos",     fn(req) list_todos(req, p))
    forge.get(app, "/todos/:id", fn(req) get_todo(req, p))
    forge.post(app, "/todos",    fn(req) create_todo(req, p))
    forge.delete(app, "/todos/:id", fn(req) delete_todo(req, p))
    forge.get(app, "/health", fn(req) {"status": "ok"})

    print("Todo API listening on :8080")
    forge.serve(app, 8080)
```

> **DO:** Always use parameterized queries with `?` placeholders and pass values in the list argument.
> **DON'T:** Build SQL by string concatenation — `"WHERE name = '" + user_input + "'"` is a classic SQL injection vulnerability. The pool APIs enforce the parameterized pattern — there is no API for building SQL from user input.

---

## 15. Forge: WebSocket

Forge supports WebSocket with real-time bidirectional messaging and hub-based broadcasting for multi-client rooms.

### Echo server

The simplest WebSocket: echo messages back to the sender:

```nova
import forge

fn main()
    app = forge.app()

    forge.ws(app, "/ws", fn(ws, msg)
        text = forge.bytes_to_str(msg)
        forge.ws_emit(ws, "echo: {text}")
    )

    forge.serve(app, 8080)
```

`forge.ws` registers a WebSocket handler at a path. When a client sends a message, the handler receives the connection handle (`ws`) and the message payload (`msg` as bytes). `forge.ws_emit(ws, text)` sends a text frame back.

### Broadcasting with a hub

A hub is a NOVA channel that delivers messages to all connected clients in a room:

```nova
import forge

fn handle_message(ws, msg, hub)
    text = forge.bytes_to_str(msg)
    forge.room_say(hub, text)   // broadcast to ALL clients in the room

fn main()
    app = forge.app()
    hub = forge.hub()

    forge.ws_room(app, "/chat", hub, fn(ws, msg, hub)
        handle_message(ws, msg, hub)
    )

    forge.serve(app, 8080)
```

When any client sends a message, `forge.room_say(hub, text)` delivers it to every connected client, including the sender. This is how you build a chat server.

`forge.ws_room` is the right API when you need broadcast. `forge.ws` is the right API when each connection is isolated (echo, private messaging).

### Full chat example with HTML UI

```nova
import forge

fn main()
    app = forge.app()
    hub = forge.hub()

    // Chat WebSocket endpoint
    forge.ws_room(app, "/chat", hub, fn(ws, msg, hub)
        text = forge.bytes_to_str(msg)
        if len(text) > 0
            forge.room_say(hub, text)
    )

    // Serve the chat UI
    forge.get(app, "/", fn(req)
        forge.html(200, "<!DOCTYPE html>
<html>
<head><title>NOVA Chat</title></head>
<body>
<div id='log' style='height:400px;overflow-y:auto;border:1px solid #ccc;padding:8px'></div>
<input id='msg' style='width:80%' placeholder='Message...'>
<button onclick='send()'>Send</button>
<script>
const ws = new WebSocket('ws://localhost:8080/chat');
ws.onmessage = e => {
    const log = document.getElementById('log');
    log.innerHTML += '<p>' + e.data + '</p>';
    log.scrollTop = log.scrollHeight;
};
function send() {
    const inp = document.getElementById('msg');
    if (inp.value) {
        ws.send(inp.value);
        inp.value = '';
    }
}
document.getElementById('msg').onkeydown = e => {
    if (e.key === 'Enter') send();
};
</script>
</body>
</html>")
    )

    print("Chat server on :8080 — open http://localhost:8080 in two browser tabs")
    forge.serve(app, 8080)
```

### Server-Sent Events (SSE)

SSE is a simpler alternative to WebSocket for one-way server-to-client streaming (live dashboards, progress updates, log tailing):

```nova
import forge

fn counter_stream(req: Request)
    forge.sse(req, fn(emit)
        i = 0
        while i < 10
            emit("count: {i}")
            sleep(1000)    // one event per second
            i = i + 1
    )

fn main()
    app = forge.app()
    forge.get(app, "/stream", fn(req) counter_stream(req))
    forge.serve(app, 8080)
```

The browser receives events with:

```javascript
const es = new EventSource('/stream');
es.onmessage = e => console.log(e.data);
```

> **DO:** Use `forge.ws_room` + `forge.hub()` for multi-client broadcasting. The hub handles all fan-out logic internally — you just call `room_say`.
> **DON'T:** Try to maintain a global list of WebSocket connections and loop over them to broadcast. That requires shared mutable state between green tasks, which violates NOVA's ownership model and will cause data races.

---

## 16. Forge: auth (JWT + CSRF)

### JWT authentication

JSON Web Tokens are the standard for stateless bearer authentication in REST APIs:

```nova
import forge

let secret = "my-secret-key-keep-it-safe-use-env-var-in-production"

fn login_handler(req: Request)
    parsed = forge.body_as(req)
    match parsed
        Ok(creds) =>
            // In production: check creds against database
            if creds.username == "admin" and creds.password == "secret"
                claims = {}
                claims["sub"]  = creds.username
                claims["role"] = "admin"
                claims["exp"]  = time_ms() / 1000 + 3600  // expires in 1 hour (Unix seconds)
                tok = forge.jwt_encode(claims, secret)
                {"token": tok}
            else
                forge.text(401, "invalid credentials")
        Err(e) =>
            forge.text(422, "invalid request: {e}")
```

`jwt_encode(claims_dict, secret)` creates a signed HS256 JWT. `jwt_verify(token, secret)` verifies the signature and checks expiry:

```nova
match forge.jwt_verify(tok, secret)
    Ok(claims) =>
        print("valid: user={claims["sub"]}")
    Err("token expired") =>
        print("please log in again")
    Err("missing exp") =>
        print("token has no expiry — rejected for security")
    Err(other) =>
        print("invalid token: {other}")
```

### Protected routes with mw_require_auth

The `mw_require_auth` middleware automatically verifies the `Authorization: Bearer <token>` header. On success, the decoded claims are available at `req.state["user"]`:

```nova
fn main()
    app = forge.app()
    secret = "my-secret-key"

    // Public routes
    forge.post(app, "/login", fn(req) login_handler(req))

    // All routes registered after this require a valid JWT
    forge.use(app, forge.mw_require_auth(secret))

    // Protected routes
    forge.get(app, "/me", fn(req)
        user = req.state["user"]
        {"sub": user["sub"], "role": user["role"]}
    )

    forge.get(app, "/admin", fn(req)
        user = req.state["user"]
        if user["role"] != "admin"
            return forge.text(403, "admin only")
        {"message": "welcome, admin"}
    )

    forge.serve(app, 8080)
```

If the `Authorization` header is missing or the token is invalid/expired, `mw_require_auth` returns `401 Unauthorized` before the route handler runs.

### Token validation rules

`jwt_verify` checks three things:

1. **Signature** — the HMAC-SHA256 signature must match the secret. A tampered payload immediately fails.
2. **Expiry** — the `exp` claim must be a Unix timestamp in the future. Missing `exp` is rejected by default (non-expiring credentials are a security risk).
3. **Structure** — the token must be exactly three base64url-encoded segments separated by `.`.

### CSRF protection

Cross-Site Request Forgery protection prevents malicious websites from making authenticated requests on behalf of your users:

```nova
import forge

fn main()
    app = forge.app()
    secret = "csrf-signing-secret"

    // Apply CSRF middleware to the whole app
    forge.use(app, forge.mw_csrf(secret, ""))

    // GET requests are safe — the middleware issues the CSRF token
    forge.get(app, "/form", fn(req)
        token = forge.csrf_token(req)
        forge.html(200, "
            <form method='POST' action='/submit'>
                <input type='hidden' name='_csrf' value='{token}'>
                <input name='data' placeholder='enter something'>
                <button>Submit</button>
            </form>
        ")
    )

    // POST requests require a valid CSRF token — enforced by the middleware
    forge.post(app, "/submit", fn(req)
        // If we reach here, mw_csrf already validated the token
        forge.text(200, "submitted successfully")
    )

    forge.serve(app, 8080)
```

How the double-submit cookie pattern works:

1. On `GET /form`, `mw_csrf` sets a signed cookie containing a random nonce. `csrf_token(req)` returns the nonce for embedding in the form.
2. On `POST /submit`, `mw_csrf` verifies that the `_csrf` form field (or `X-CSRF-Token` header) matches the signed cookie. Mismatch or missing token → `403 Forbidden`.
3. An attacker's website cannot read the cookie (SameSite + HttpOnly) and cannot forge the signature without the secret.

### Using environment variables for secrets

Never hardcode secrets in source code. In production:

```nova
fn main()
    jwt_secret = getenv("JWT_SECRET")
    if len(jwt_secret) == 0
        print("ERROR: JWT_SECRET environment variable must be set")
        exit(1)

    csrf_secret = getenv("CSRF_SECRET")
    if len(csrf_secret) == 0
        print("ERROR: CSRF_SECRET environment variable must be set")
        exit(1)

    app = forge.app()
    forge.use(app, forge.mw_csrf(csrf_secret, ""))
    forge.use(app, forge.mw_require_auth(jwt_secret))
    // ... routes ...
    forge.serve(app, 8080)
```

> **DO:** Store the JWT secret in an environment variable. Use `getenv("JWT_SECRET")` and fail fast at startup if it is missing.
> **DON'T:** Use `exp` values in the past, or omit `exp` entirely. Tokens without expiry are permanent credentials that cannot be invalidated without rotating the secret (which invalidates every token at once).

---

## 17. FFI: calling C

NOVA's foreign function interface lets you call any C function with zero overhead. There is no marshalling layer, no JNI, no ctypes. The call is compiled to a direct native function call in the LLVM IR.

### Basic FFI

Declare a C function with `extern fn` and a `@link` annotation:

```nova
@link("c")
extern fn strlen(s: string) -> int

print(strlen("hello"))    // 5
```

`@link("c")` tells the linker to link against the C standard library. On Linux this is `-lc` (usually implicit); on Windows it is MSVCRT.

### Calling math functions

```nova
@link("m")
extern fn sin(x: float) -> float

@link("m")
extern fn cos(x: float) -> float

@link("m")
extern fn sqrt(x: float) -> float

print(sin(0.0))           // 0.0
print(cos(0.0))           // 1.0
print(sqrt(2.0))          // 1.4142135623730951
```

On Linux, `@link("m")` adds `-lm`. On Windows these are in MSVCRT, so `@link("m")` is a no-op there — but writing it is harmless and makes the code portable.

### Calling SQLite directly

```nova
@link("sqlite3")
extern fn sqlite3_open(path: string, db: out<int>) -> int

@link("sqlite3")
extern fn sqlite3_exec(db: int, sql: string, cb: int, arg: int, err: out<string>) -> int

@link("sqlite3")
extern fn sqlite3_close(db: int) -> int

fn open_db(path: string) -> Result
    db = 0
    rc = sqlite3_open(path, out(db))
    if rc != 0
        return Err("sqlite3_open failed with code {rc}")
    Ok(db)

r = open_db(":memory:")
match r
    Ok(db) =>
        print("opened DB handle: {db}")
        sqlite3_close(db)
    Err(e) =>
        print("error: {e}")
```

`out<T>` is an output parameter — the C function writes to it via a pointer, and NOVA reads the written value after the call returns.

### unsafe blocks

Some FFI calls involve operations NOVA cannot statically verify — raw pointer arithmetic, casting integers to pointers, writing to arbitrary memory addresses. Wrap these in `unsafe`:

```nova
unsafe
    raw_ptr = ptr_from_int(some_address)
    result = dangerous_c_function(raw_ptr)
```

Everything inside `unsafe` still compiles to native code — it just disables some of NOVA's safety checks for that block. Keep `unsafe` blocks as small as possible and document why each one is necessary.

### Opaque handles

C APIs often return opaque handles (pointers to internal C structs that NOVA should not inspect). Declare them with `@opaque`:

```nova
@link("ssl")
@opaque
type SSL_CTX

@link("ssl")
extern fn SSL_CTX_new(method: ptr) -> SSL_CTX

@link("ssl")
extern fn SSL_CTX_free(ctx: SSL_CTX)
```

Opaque types can be passed through NOVA code into C functions, but NOVA will not try to read their fields.

### Type mapping

| NOVA FFI type | C type |
|---|---|
| `int` | `int64_t` |
| `float` | `double` |
| `string` | `const char*` (UTF-8, null-terminated) |
| `bool` | `int` (0 or 1) |
| `ptr` | `void*` |
| `i32` | `int32_t` |
| `i16` | `int16_t` |
| `i8` | `int8_t` |
| `u64` | `uint64_t` |
| `usize` | `size_t` |
| `out<T>` | `T*` (output parameter) |

### Calling getenv

```nova
@link("c")
extern fn getenv(name: string) -> string

nova_home = getenv("NOVA_HOME")
if len(nova_home) == 0
    print("NOVA_HOME is not set")
else
    print("NOVA_HOME = {nova_home}")
```

### Linking multiple libraries

Each `@link` annotation names one library. The compiler deduplicates — if two functions both use `@link("ssl")`, it only passes `-lssl` once:

```nova
@link("ssl")
extern fn SSL_library_init() -> int

@link("crypto")
extern fn RAND_bytes(buf: ptr, num: int) -> int
```

The system libraries that NOVA already links automatically (no `@link` needed):

- **Windows:** `ws2_32`, `advapi32`
- **Linux/macOS:** `pthread`, `m`, `dl`

> **DO:** Write `@link` with the library name without `lib` prefix and without `.so`/`.dll`/`.dylib` extension. Use `"ssl"` not `"libssl.so.1.1"`.
> **DON'T:** Put complex multi-line logic inside `unsafe` blocks. The goal is to encapsulate a narrow unsafe operation behind a safe NOVA interface. Large `unsafe` blocks multiply the surface area where bugs can hide.

---

## 18. Performance guide

NOVA's goal is C-level performance. Understanding how the compiler achieves this — and what defeats it — lets you write code that is both simple and fast.

### The fundamental model

NOVA compiles to LLVM IR, which is then compiled by clang with `-O2`. Any code pattern that compiles to the same LLVM IR as equivalent C achieves the same performance. The NOVA compiler works hard to reach that IR.

Measured performance against `clang -O2`:

- Integer arithmetic: within 1-2% of C
- Struct field math with lowercase type annotations: within 2-4% of C
- Float array operations with native float arrays: within 5% of C
- String operations: within 10-20% of C for typical patterns

### What makes code fast

**1. Scalar arithmetic is native**

Integer and float arithmetic on local variables compiles directly to native CPU instructions:

```nova
fn sum_squares(n: int) -> int
    total = 0
    for i in 1..n
        total = total + i * i
    total

// Compiles to a tight loop with native mul+add
// Performance: identical to hand-written C
```

**2. Struct math with lowercase field types is native**

This is the most important rule:

```nova
// FAST: lowercase type names -> native LLVM arithmetic
type Vec3
    x: float
    y: float
    z: float

fn dot(a: Vec3, b: Vec3) -> float
    a.x * b.x + a.y * b.y + a.z * b.z
// Compiles to: three fmul + two fadd
// Performance: identical to C struct math
```

```nova
// SLOW: capital type names -> dynamic dispatch on every operation
type Vec3Slow
    x: Float    // capital F — do not do this
    y: Float
    z: Float

fn dot_slow(a: Vec3Slow, b: Vec3Slow) -> float
    a.x * b.x + a.y * b.y + a.z * b.z
// Compiles to: six calls to nova_rt_mul() (runtime dynamic dispatch)
// Performance: 100-150x SLOWER than the fast version
```

Never use capital type names (`Int`, `Float`, `String`, `Bool`) in struct fields.

**3. Type-inferred parameters are specialized to native code**

When a function's parameters can be inferred as concrete types from all call sites, the compiler generates native code without annotations:

```nova
fn scale(v: Vec3, factor: float) -> Vec3
    Vec3 { x: v.x * factor, y: v.y * factor, z: v.z * factor }

// Compiler infers: v is Vec3, factor is float
// Emits native fmul for each field
```

**4. The arena allocator eliminates GC pauses**

Forge uses a per-request arena allocator. All allocations for a single HTTP request come from a contiguous slab of memory that is freed in one step when the request is done. There are no GC pauses, no reference counting overhead on the hot path.

You do not need to do anything special to use the arena — Forge manages it automatically per request.

**5. Green tasks are cheap**

Spawning a green task costs about 1 microsecond. You can spawn thousands per second. The NOVA scheduler is work-stealing across OS threads, so green tasks automatically use all available CPU cores.

### What makes code slow

**1. Capital type names in struct fields** (150x penalty)

Already covered. Search every `type` block for `Float`, `Int`, `String`, `Bool` fields and change them to lowercase.

**2. String building with `+` in a loop**

```nova
// SLOW: O(n^2) allocations
result = ""
for item in large_list
    result = result + item + ", "

// FAST: O(n) allocations
parts = []
for item in large_list
    parts.push(item)
result = join(parts, ", ")
```

**3. Sending large values over channels in tight loops**

Channel sends deep-copy their values. Design channels to carry small coordination values or computed results, not large raw data blobs:

```nova
// SLOW: copying large_data on every iteration
for i in 0..9999
    send(ch, large_data)

// FAST: compute what you need, send only the result
for i in 0..9999
    result = compute(large_data, i)
    send(ch, result)
```

### Measuring performance

```nova
start = time_ms()
result = expensive_computation()
elapsed = time_ms() - start
print("took {elapsed}ms")
```

For micro-benchmarks, amortize over many iterations:

```nova
N = 100_000
start = time_ms()
for i in 0..N-1
    result = my_function(i)
elapsed = time_ms() - start
print("{N} iterations in {elapsed}ms = {elapsed * 1000 / N}us each")
```

### Performance comparison matrix

| Operation | NOVA | C (`clang -O2`) | Python 3 | Notes |
|---|---|---|---|---|
| Integer loop | ~1x | 1x | ~50x slower | NOVA = C |
| Struct field math (lowercase) | ~1x | 1x | ~150x slower | NOVA = C |
| Struct field math (Capital) | ~150x | 1x | ~150x slower | Both slow |
| Float array | ~1.05x | 1x | ~100x slower | NOVA ~= C |
| String concat (+) | 1.2-2x | 1x | varies | Use join() for loops |
| Dict lookup | 1.5-3x | N/A | ~5-10x slower | Open-addressing hash |
| spawn (green task) | ~1µs | N/A | ~10µs (thread) | NOVA much cheaper |
| HTTP round-trip (Forge) | <100µs | N/A | ~1ms (Flask) | NOVA ~10x faster |

### The compiler is the genius

The right mental model: write simple, clear code. The compiler optimizes. You do not need to:

- Annotate types on local variables
- Manually inline functions
- Write SIMD intrinsics for most workloads
- Manage memory allocation
- Write lock-free algorithms for basic concurrency

You do need to:

- Use lowercase type names in struct fields
- Use `join()` instead of `+` for string-building in loops
- Design channels to carry small coordination values, not large data blobs

The NOVA compiler's type specializer detects concrete types from call sites and generates monomorphic native code. Type inference is not just a convenience feature — it is what enables the compiler to generate the same code as a C programmer who wrote the types explicitly.

> **DO:** Profile before optimizing. NOVA's default performance is already within 2-5x of hand-written C for most code. Measure first, then identify the bottleneck (usually a capital-F field type or string-building-in-a-loop pattern).
> **DON'T:** Rewrite clean NOVA code in a "more C-like" style thinking it will be faster. The compiler sees through abstractions. A recursive function, a higher-order map call, and a manual for loop all compile to essentially the same machine code when the types are concrete.

---

## Appendix A: Quick reference

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
| `unsafe` | Block where NOVA's safety checks are relaxed for FFI |
| `try` | Unwrap Ok or propagate Err from the current function |
| `true / false` | Boolean literals |

### Built-in functions

| Function | Description |
|---|---|
| `print(v)` | Print value followed by newline |
| `str(v)` | Convert any value to string |
| `int(v)` | Convert string or float to int (truncates) |
| `float(v)` | Convert string or int to float |
| `bool(v)` | Convert to bool |
| `len(v)` | Length of string, list, or dict |
| `keys(d)` | List of dict keys |
| `values(d)` | List of dict values |
| `contains(v, x)` | Test element/key presence |
| `push(list, v)` | Append to list (mutates in place) |
| `pop(list)` | Remove and return last element |
| `sort(list)` | Sort list in place |
| `map(list, f)` | Apply f to each element, return new list |
| `filter(list, f)` | Keep elements where f(x) returns true |
| `reduce(list, init, f)` | Fold list to single value |
| `join(list, sep)` | Concatenate list of strings with separator |
| `split(s, sep)` | Split string by separator, return list |
| `find(s, sub)` | Index of first occurrence, -1 if not found |
| `slice(s, a, b)` | Substring from index a to b (exclusive) |
| `upper(s)` | Uppercase string |
| `lower(s)` | Lowercase string |
| `trim(s)` | Remove leading and trailing whitespace |
| `replace(s, from, to)` | Replace all occurrences of from with to |
| `starts_with(s, prefix)` | Test string prefix |
| `ends_with(s, suffix)` | Test string suffix |
| `char_at(s, i)` | Character at index i (supports negative) |
| `ord(c)` | Character code point as int |
| `chr(n)` | Character from code point |
| `sqrt(x)` | Square root |
| `abs(x)` | Absolute value |
| `min(a, b)` | Minimum of two values |
| `max(a, b)` | Maximum of two values |
| `time_ms()` | Current time in milliseconds since epoch |
| `sleep(ms)` | Sleep for ms milliseconds |
| `exit(code)` | Exit the process with a status code |
| `assert(cond, msg)` | Abort with message if cond is false |
| `getenv(name)` | Get environment variable value |
| `reschedule()` | Yield the current green task to the scheduler |

### Operators

| Operator | Meaning |
|---|---|
| `+ - * / %` | Arithmetic (int and float; `+` also concatenates strings and lists) |
| `==  !=  <  <=  >  >=` | Comparison |
| `and  or  not` | Logical (short-circuits) |
| `&  \|  ^  <<  >>` | Bitwise |
| `in  not in` | Membership test (string, list, dict) |
| `x => body` | Single-parameter closure |
| `(a, b) => body` | Multi-parameter closure |
| `a..b` | Inclusive integer range |
| `+=  -=  *=  /=  %=` | Compound assignment |

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

### Parse a config file

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
    Ok(result)

match parse_config("app.conf")
    Ok(cfg) =>
        host = if contains(cfg, "host") then cfg["host"] else "localhost"
        port = if contains(cfg, "port") then int(cfg["port"]) else 8080
        print("connecting to {host}:{port}")
    Err(e) =>
        print("config error: {e}")
```

### Retry with exponential backoff

```nova
fn with_retry(max_attempts: int, f)
    attempt = 0
    last_err = "unknown error"
    while attempt < max_attempts
        r = f()
        match r
            Ok(v) => return Ok(v)
            Err(e) =>
                last_err = e
                attempt = attempt + 1
                if attempt < max_attempts
                    sleep(100 * attempt)   // 100ms, 200ms, 300ms, ...
    Err("failed after {max_attempts} attempts: {last_err}")

result = with_retry(3, fn() connect_to_database("mydb.db"))
match result
    Ok(db) => print("connected")
    Err(e) => print("gave up: {e}")
```

### Pipeline pattern

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
    items => items[0:100]   // take first 100
])
```

### Worker pool

```nova
fn worker_pool(num_workers: int, jobs: list, handler) -> list
    work_ch = channel()
    result_ch = channel()

    for i in 0..num_workers - 1
        spawn fn()
            while true
                job = receive(work_ch)
                if job == -1
                    break
                result = handler(job)
                send(result_ch, result)

    for job in jobs
        send(work_ch, job)

    for i in 0..num_workers - 1
        send(work_ch, -1)   // poison pill to shut down each worker

    results = []
    for i in 0..len(jobs) - 1
        results.push(receive(result_ch))
    results

results = worker_pool(4, [1, 2, 3, 4, 5, 6, 7, 8], x => x * x)
print(results)
```

---

## Appendix C: Troubleshooting

### "cannot find module 'forge'"

Check that `NOVA_HOME` is set and points to the directory containing `lib/`:

```
ls $NOVA_HOME/lib/forge.nova
```

If that file does not exist, `NOVA_HOME` points to the wrong directory.

### "type mismatch: expected float, got Int"

You used a capital type name (`Int`, `Float`) somewhere in a struct field declaration. Change it to lowercase. This error most commonly appears in struct arithmetic.

### Green task hangs or starves other tasks

Add `reschedule()` calls inside any long-running loop in a spawned task. Without yielding, a CPU-bound task will monopolize its OS thread and prevent other green tasks from running:

```nova
spawn fn()
    i = 0
    while i < 10_000_000
        i = i + 1
        if i % 100_000 == 0
            reschedule()   // yield periodically
```

### "arena object not found in heap"

A value created inside a Forge request handler arena is being used outside its request scope. Values in request handlers are valid only for the duration of that request. Store long-lived values (caches, counters, session data) in a dict or struct defined outside the handler function, at module scope.

### Struct arithmetic is unexpectedly slow

Search your `type` blocks for capital type names in field declarations. Every `Float`, `Int`, `String`, `Bool` field forces dynamic dispatch on every arithmetic operation. Change them all to lowercase.

---

*NOVA language version: gen3 (self-hosted compiler). This tutorial reflects the language as implemented. For formal grammar and semantic rules, see `LANGUAGE_SPEC.md`. For the complete framework API reference, see `FRAMEWORKS.md` and `STDLIB_API.md`.*
