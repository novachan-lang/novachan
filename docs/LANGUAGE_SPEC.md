# The NOVA Language Specification

This is the normative reference for the NOVA language as implemented by `gen3_test.exe` (the self-hosted compiler in `nova-compiler/test_programs/`). It describes syntax, semantics, and the runtime model.

For a guided introduction, read `TUTORIAL.md` first. This document assumes you already know what NOVA looks like.

## Contents

1. [Lexical structure](#1-lexical-structure)
2. [Types](#2-types)
3. [Values, processes, channels](#3-values-processes-channels)
4. [Expressions](#4-expressions)
5. [Statements](#5-statements)
6. [Functions](#6-functions)
7. [Type system](#7-type-system)
8. [Modules](#8-modules)
9. [Memory model](#9-memory-model)
10. [FFI](#10-ffi)
11. [Compilation pipeline](#11-compilation-pipeline)

---

## 1. Lexical structure

### Encoding

Source files are UTF-8 encoded. Line endings may be `\n` or `\r\n`.

### Whitespace and indentation

NOVA is **indentation-sensitive**. Blocks are introduced by indenting one level deeper than the line that opens them. The first non-whitespace line of a file sets the base indent (typically column 0).

Tabs and spaces are not interchangeable within the same file. Mixing them within a single block is a parse error.

### Comments

```nova
// Single-line comment, runs to end of line.
```

There is no block-comment syntax.

### Identifiers

```
identifier  := letter (letter | digit | '_')*
letter      := 'A'..'Z' | 'a'..'z' | '_'
digit       := '0'..'9'
```

Identifiers starting with `_` have file-private visibility when used as top-level definitions (functions, types).

### Reserved keywords

```
fn type enum trait impl let return
if else while for in match break continue
true false
spawn send receive select channel
import export as
extern
ok err try catch
```

### Literals

| Form | Example | Type |
|------|---------|------|
| integer | `0`, `42`, `-7`, `1_000_000` | `int` (64-bit) |
| hex integer | `0xFF`, `0xCAFE_F00D` | `int` |
| float | `3.14`, `-0.001`, `1e10` | `float` (64-bit) |
| string | `"hello"`, `"line\nbreak"` | `string` |
| bool | `true`, `false` | `bool` |
| list | `[1, 2, 3]` | `list<T>` |
| dict | `{"a": 1, "b": 2}` | `dict<K, V>` |
| tuple | `(1, "two", 3.0)` | `tuple` |

### String escapes

`\n`, `\t`, `\r`, `\\`, `\"`, `\0`, `\xNN`. Inside double-quoted strings, `{expr}` interpolates the expression; literal braces are `\{` and `\}`.

## 2. Types

### Primitive types

- `int` — 64-bit signed integer. Two's-complement, **wraps** on overflow (no UB).
- `float` — 64-bit IEEE 754 double.
- `bool` — `true` or `false`.
- `string` — immutable UTF-8 byte sequence.
- `unit` — the type of a no-value expression (written `()`).

### Container types

- `list<T>` — dynamic array of `T`. Heap-allocated, reference-counted.
- `dict<K, V>` — open-addressing hash map. Heap-allocated, reference-counted.
- `tuple` — fixed-arity heterogeneous record.

### User-defined types

```
type Name
    field1: T1
    field2: T2
```

Each `type` definition introduces a nominal struct type with named fields.

### Enums (sum types)

```
enum Name
    Variant1
    Variant2(field: T)
    Variant3(a: T, b: U)
```

A unit-style variant takes no fields. A constructor variant takes one or more named fields.

### Generic types

```
fn map<T, U>(xs: list<T>, f: T -> U) -> list<U>
```

Generics are erased at compile time. There is no monomorphization cost at runtime; representations are uniform i64 slots.

### Channel, process

- `channel<T>` — a multi-producer multi-consumer queue carrying values of type `T`.
- `process<R>` — a handle to a spawned process whose `main` returns `R`.

### Type aliases via FFI

For C interop, `i32`, `i16`, `i8`, `u64`, `usize`, `ptr` are recognized in `extern fn` signatures. See FFI section.

## 3. Values, processes, channels

The whole language is three primitives:

- **Values** — every datum. Integers, structs, lists, dicts, tensors, byte buffers, channels, processes. All values have a single owner at any time.
- **Processes** — every unit of execution. A `spawn` creates one. Processes do not share heap; cross-process communication must go through channels.
- **Channels** — every cross-process communication. A `send` may **move** the value to the channel; the sender can no longer use it (with `NOVA_TRACK8=1` this is checked statically).

Single-process programs compile away `spawn` machinery to zero overhead.

## 4. Expressions

In order of decreasing precedence:

| Precedence | Operators | Associativity |
|-----------:|-----------|---------------|
| 17 | `f(args)`, `x.field`, `x[i]`, `x.method(args)` | left |
| 16 | unary `-`, `not` | right |
| 15 | `*`, `/`, `%` | left |
| 14 | `+`, `-` | left |
| 13 | `<<`, `>>` | left |
| 12 | `&` | left |
| 11 | `^` | left |
| 10 | `|` | left |
|  9 | `<`, `<=`, `>`, `>=` | left |
|  8 | `==`, `!=` | left |
|  7 | `in`, `not in` | left |
|  6 | `and` | left |
|  5 | `or` | left |
|  4 | `=>` (lambda) | right |
|  3 | `if/else` ternary expr | right |
|  2 | `catch` | left |
|  1 | `=`, `+=`, `-=`, `*=`, `/=`, `%=` | right |

### Numeric operators

`+ - * /` work on `int` and `float`. Mixed-type arithmetic between `int` and `float` widens both sides to `float`. `%` is the modulo operator.

`+` is overloaded for `string` concatenation when **both** operands are strings.

### Comparison

`==` and `!=` work on every type. They compare by value for ints, floats, bools, and strings; by handle identity for lists, dicts, and structs (unless a type has overridden equality via `impl`).

`<`, `<=`, `>`, `>=` work on ordered scalar types.

### Logical

`and` and `or` short-circuit. `not` negates a bool.

### Membership

`x in coll` tests substring presence (string), element presence (list), or key presence (dict). `not in` is the negation.

### Index and slice

```nova
xs[i]              // direct index; negative i counts from end
xs[a:b]            // slice (inclusive..exclusive)
d["key"]           // dict lookup
```

Out-of-range indices set the global error flag (catchable).

### Method calls

```nova
xs.push(42)        // mutating method
s.upper()          // pure method
```

Methods are functions whose first argument is a value of the receiver type. They can be defined as `fn TypeName.method(self, ...)` or imported from the runtime.

### If as expression

```nova
let label = if x > 0 "positive" else "non-positive"
```

When written as a single line, `if/else` returns the chosen branch.

### Lambda

```nova
let double = x => x * 2
let add = (a, b) => a + b
```

The body is a single expression. For multi-line lambdas, use a named local function:

```nova
fn local(x)
    let y = x + 1
    y * 2
```

## 5. Statements

### `let`

```nova
let name = expr
let name: type = expr
```

Declares a new binding. The compiler infers the type when omitted. The name shadows any outer binding of the same name within the same block.

### Assignment

```nova
name = expr
container[key] = expr
struct.field = expr
```

Mutates an existing binding or container slot. Compound assignment (`+=`, `-=`, etc.) is shorthand for `name = name op expr`.

### `if`, `while`, `for`, `match`

Covered in [Tutorial §4](TUTORIAL.md#4-control-flow). When used as a statement, the block's value is discarded.

### `return`

Returns from the enclosing function. May appear in any block. The last expression of a block is an implicit return; explicit `return` is for early-exit.

### `break`, `continue`

Loop control. `break` exits the nearest enclosing loop. `continue` jumps to the next iteration.

### `import`

Top-level only. Resolves to a `.nova` file in the same directory or `nova_packages/<name>/`.

### `spawn`, `send`, `receive`

Process and channel primitives. See §3 and Tutorial §11.

## 6. Functions

```
fn name(params) -> return_type
    body
```

- Parameters may carry type annotations or not.
- The return type is optional; omitted means inferred.
- The body is a block.

### Function types

`(T1, T2) -> R` is the type of a two-argument function returning `R`. Functions are first-class values and may be stored, passed, and returned.

### Closures

Lambda expressions capture variables from their enclosing scope by handle. Capture is automatic — no explicit capture list.

### Methods

```
fn TypeName.method_name(self, args) -> R
    body
```

Methods are dispatched statically based on the receiver's compile-time type.

### Traits

```
trait Show
    fn show(self) -> string

impl Show for int
    fn show(self) -> string
        str(self)
```

Trait conformance is checked at the call site. Trait bounds can constrain generic parameters:

```
fn print_all<T: Show>(xs: list<T>)
    for x in xs
        print(x.show())
```

## 7. Type system

NOVA's type system is a Hindley-Milner core extended with subtyping at structural seams.

### Inference

The compiler infers types for every variable, every function return, and every expression. You should need annotations in only two places in practice:

1. Public function signatures (acts as documentation and error-message bait)
2. Disambiguating overloads (rare)

### Soundness

Type inference is **sound but not complete**. The compiler will reject some programs that are dynamically safe; it will never accept one that is unsafe. The tradeoff is intentional.

### Generics

Type parameters are erased at compile time. Generic dispatch uses uniform i64-slot representation. There is no monomorphization step.

### Subtyping

NOVA has limited width subtyping for record types. A function expecting `Point` accepts any value whose static type contains at least `x: int` and `y: int` fields.

## 8. Modules

### Module identity

Every `.nova` file is a module. The module name is the file's basename without `.nova`. `import math` looks for `math.nova` in:

1. The directory of the importing file
2. `./nova_packages/math/math.nova`
3. The standard library search path

### Visibility

Top-level names are public unless they start with `_`. `_helper(x)` is callable only from the same file.

### Re-exports

There is no explicit re-export syntax. To expose a function from a submodule, write a wrapper.

### Import forms

```nova
import math                          // bind math.* in this scope
import math as m                     // bind m.*
import math { sin, cos }             // bring sin, cos into scope unqualified
```

## 9. Memory model

NOVA uses **process-isolated, refcounted, escape-analyzed** memory.

### Heap discipline

- Lists, dicts, strings (non-constant), structs, tuples, closures, channels, and processes are heap-allocated.
- Integers, floats, bools, and constant strings are not.
- Heap allocations carry a reference count in their header.

### Reference counting

`nova_rc_inc` and `nova_rc_dec` track ownership. `rc_dec` to zero frees the allocation.

### Track 8 escape analysis

The compiler runs a forward escape analysis to determine which allocations are **process-local** — never sent on a channel, never returned, never stored in an escaping container. Process-local containers compile to `_no_rc` variants of `push` and `set` that skip the `rc_inc` on element insertion. This eliminates ~20% of the RC traffic on container-heavy workloads.

### Arena mode

For programs that never spawn, `set_arena_mode(1)` (or `NOVA_AUTO_ARENA=1` for automatic detection) turns the entire RC machinery into a no-op. Allocations are freed at process exit by the OS.

### Auto-drop (W5b, W8) — opt-in

- `NOVA_T8_DROP=1` enables W5b: `list_free_local` / `dict_free_local` calls inserted at function return for local containers.
- `NOVA_T8_W8=1` (requires `NOVA_T8_DROP=1`) enables W8: drops at the last live block for slots that die mid-function, rather than waiting for return.

Both are gated behind opt-in env vars because the escape analysis doesn't yet cover all aliasing patterns soundly.

### Move semantics on channels

`send(ch, x)` may **move** x out of the sender's heap. Under `NOVA_TRACK8=1`, any use of `x` after the send is a compile error (E1003).

## 10. FFI

### `extern fn`

```nova
@link("c")
extern fn strlen(s: string) -> int
```

Declares a function symbol resolved at link time from the named library.

### Argument types

| NOVA annotation | C type |
|-----------------|--------|
| `int` | `int64_t` |
| `i32` | `int32_t` |
| `i16` | `int16_t` |
| `i8` | `int8_t` |
| `u64` | `uint64_t` |
| `usize` | `size_t` |
| `float` | `double` |
| `string` | `const char *` (UTF-8, NUL-terminated) |
| `ptr` | `void *` |
| `bool` | `int` (zero/non-zero) |

### `@opaque`

A type the NOVA program never inspects, just hands back:

```nova
@opaque
type FILE_t

@link("c")
extern fn fopen(path: string, mode: string) -> FILE_t

@link("c")
extern fn fclose(f: FILE_t) -> int
```

### `out<T>`

A pointer-out parameter — the C function writes into the NOVA variable's storage:

```nova
@link("sqlite3")
extern fn sqlite3_open(path: string, db_out: out<int>) -> int

fn main()
    let db = 0
    sqlite3_open("data.db", &db)
```

### `@repr(C)`

For structs that must match a C layout exactly. Removes the leading type-hash slot:

```nova
@repr(C)
type Vec3
    x: float
    y: float
    z: float
```

### Calling convention

All NOVA-visible FFI declarations marshal i64 in NOVA's calling convention to the declared C types. Narrowing conversions (`i32`, `i16`) are emitted as LLVM truncations.

### `unsafe`

Operations not provable safe by the type system must be inside an `unsafe` block:

```nova
unsafe
    let p = ptr_cast(handle)
    write_byte(p, 42)
```

The `unsafe` keyword is currently advisory at the source level; future work will track unsafe regions for audit.

## 11. Compilation pipeline

```
.nova → lexer → parser → type inferrer → IR builder → optimizer → LLVM emitter → clang → .exe
```

Stages:

1. **Lexer** — tokenizes UTF-8 source into a stream.
2. **Parser** — Pratt-style precedence parser builds an AST.
3. **Type inferrer** — Hindley-Milner with constraint solving, plus trait conformance.
4. **IR builder** — lowers AST to a basic-block IR with named registers.
5. **Optimizer** — tail-call optimization, dead-block elimination, dead-instruction elimination, constant folding, escape analysis.
6. **LLVM emitter** — writes textual LLVM IR with TBAA metadata and DWARF debug info.
7. **clang** — links the `.ll` with `nova_runtime.c` to produce a native executable.

### Determinism

The same source compiles to the same `.ll` byte-for-byte, regardless of host filesystem ordering. Dict iteration over compiler-internal tables uses canonical ordering.

### Self-hosting

`nova_compiler.nova` is the compiler source, ~12k lines of NOVA. It compiles to `nova_compiler.ll`, which links to the same runtime. The committed binary is byte-stable up to clang's link-time decisions.

---

For runtime function reference, see `STDLIB_API.md`. For framework usage, see `FRAMEWORKS.md`.
