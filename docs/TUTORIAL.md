# The NOVA Tutorial

A guided walk from zero to a deployed full-stack application in NOVA. Every snippet below compiles with the current `nova` binary. If a snippet doesn't work for you, that's a bug — file it.

## Contents

1. [Install](#1-install)
2. [Hello, world](#2-hello-world)
3. [Values and types](#3-values-and-types)
4. [Control flow](#4-control-flow)
5. [Functions](#5-functions)
6. [Lists, dicts, strings](#6-lists-dicts-strings)
7. [Structs and enums](#7-structs-and-enums)
8. [Pattern matching](#8-pattern-matching)
9. [Closures and higher-order functions](#9-closures-and-higher-order-functions)
10. [Error handling](#10-error-handling)
11. [Processes and channels](#11-processes-and-channels)
12. [Modules](#12-modules)
13. [FFI: calling C](#13-ffi-calling-c)
14. [Building a web service](#14-building-a-web-service)
15. [Adding AI inference](#15-adding-ai-inference)
16. [Deploying](#16-deploying)
17. [Where to go next](#17-where-to-go-next)

---

## 1. Install

NOVA compiles through LLVM. You need:

- **clang** — install via the LLVM project or your package manager
- **The `nova` binary** — currently shipped as `gen3_test.exe` in `nova-compiler/test_programs/`

For day-to-day use, alias it:

```bash
# Linux/macOS
alias nova='/path/to/gen3_test.exe'

# Windows PowerShell
Set-Alias nova C:\path\to\gen3_test.exe
```

Verify:

```bash
nova --version   # or: nova self-test
```

## 2. Hello, world

Create `hello.nova`:

```nova
fn main()
    print("Hello, world!")
```

Compile and run:

```bash
nova run hello.nova
```

What just happened:

1. `nova` parsed `hello.nova` and emitted LLVM IR (`hello.ll`)
2. It invoked `clang` to link the IR with the NOVA C runtime
3. The resulting native executable ran and printed the message

`nova run` is the all-in-one shortcut. `nova build hello.nova` stops at the executable; `nova compile hello.nova` stops at the `.ll`.

## 3. Values and types

NOVA has six primitive value families and infers their types — you almost never write annotations:

```nova
fn main()
    let n = 42                          // int
    let pi = 3.14                       // float
    let name = "NOVA"                   // string
    let active = true                   // bool
    let items = [1, 2, 3]               // list
    let config = {"host": "localhost"}  // dict

    print(n)
    print(pi)
    print(name)
    print(active)
    print(items)
    print(config)
```

String interpolation uses `{...}` inside double-quoted strings:

```nova
fn main()
    let name = "NOVA"
    let version = 1
    print("Welcome to {name} v{version}!")
```

You **can** annotate when you want to — useful at function boundaries:

```nova
fn rectangle_area(w: int, h: int) -> int
    w * h
```

The compiler accepts these without complaint and uses them to give better errors.

## 4. Control flow

NOVA uses **indentation** for blocks. No braces.

### If

```nova
fn classify(n: int) -> string
    if n > 0
        "positive"
    else if n == 0
        "zero"
    else
        "negative"
```

`if` is an expression: the last expression in each branch is the value.

### While

```nova
fn sum_to(n: int) -> int
    let total = 0
    let i = 1
    while i <= n
        total = total + i
        i = i + 1
    total
```

### For

```nova
fn main()
    for x in [1, 2, 3, 4, 5]
        print(x)

    for ch in "hello"
        print(ch)

    for i in range(0, 10)
        print(i)
```

`range(a, b)` is `[a, a+1, ..., b-1]`. `range(a, b, step)` adds a stride.

### Break / continue

```nova
fn first_even(xs: list) -> int
    for x in xs
        if x % 2 == 0
            return x
    -1
```

## 5. Functions

```nova
fn add(a: int, b: int) -> int
    a + b

fn greet(name)
    print("Hello, {name}!")

fn factorial(n)
    if n <= 1
        return 1
    n * factorial(n - 1)
```

Three things to notice:

- The **last expression** of a block is its value (no `return` needed)
- You can also use `return` explicitly when it reads better
- Parameter types are optional; the compiler infers them from call sites

### Default arguments

```nova
fn greet(name, prefix = "Hello")
    print("{prefix}, {name}!")

fn main()
    greet("world")            // → Hello, world!
    greet("world", "Hi")      // → Hi, world!
```

## 6. Lists, dicts, strings

### Lists

```nova
fn main()
    let xs = [1, 2, 3]
    xs.push(4)
    print(len(xs))            // 4
    print(xs[0])              // 1
    print(xs[-1])             // 4   (negative index = from end)

    // Iterating
    for x in xs
        print(x * 2)

    // Map / filter as methods
    let doubled = xs.map(x => x * 2)
    let evens = xs.filter(x => x % 2 == 0)
```

### Dicts

```nova
fn main()
    let user = {"name": "alice", "age": 30}
    user["email"] = "alice@example.com"
    print(user["name"])

    if "age" in user
        print("age is {user[\"age\"]}")

    for key in keys(user)
        print("{key} = {user[key]}")
```

### Strings

```nova
fn main()
    let s = "hello world"

    print(len(s))              // 11
    print(s[0])                // "h"
    print(upper(s))            // "HELLO WORLD"
    print(slice(s, 0, 5))      // "hello"
    print(split(s, " "))       // ["hello", "world"]
    print(replace(s, "world", "NOVA"))

    let parts = []
    parts.push("a")
    parts.push("b")
    parts.push("c")
    print(join(parts, "-"))    // "a-b-c"
```

## 7. Structs and enums

### Structs

```nova
type Point
    x: int
    y: int

fn distance(p: Point) -> float
    let sq = p.x * p.x + p.y * p.y
    sqrt(float(sq))

fn main()
    let p = Point { x: 3, y: 4 }
    print(distance(p))         // 5.0
```

You can also use positional construction: `Point(3, 4)`.

### Methods on structs

```nova
type Counter
    value: int

fn Counter.bump(self) -> int
    self.value = self.value + 1
    self.value

fn main()
    let c = Counter { value: 0 }
    print(c.bump())            // 1
    print(c.bump())            // 2
```

### Enums (sum types)

```nova
enum Shape
    Circle(radius: float)
    Rect(width: float, height: float)
    Triangle(a: float, b: float, c: float)

fn area(s: Shape) -> float
    match s
        Circle(r) => 3.14159 * r * r
        Rect(w, h) => w * h
        Triangle(a, b, c) =>
            let s = (a + b + c) / 2.0
            sqrt(s * (s - a) * (s - b) * (s - c))

fn main()
    print(area(Circle(5.0)))
    print(area(Rect(3.0, 4.0)))
```

## 8. Pattern matching

`match` handles ints, strings, bools, structs, enums, tuples, and wildcards:

```nova
fn classify(x: int) -> string
    match x
        0 => "zero"
        1 => "one"
        n if n < 0 => "negative"
        n if n > 100 => "big"
        _ => "small positive"

fn describe(s: string) -> string
    match s
        "" => "empty"
        "hello" => "greeting"
        _ => "other"
```

Match is exhaustive: the compiler complains if you forget a case for a closed enum.

## 9. Closures and higher-order functions

```nova
fn main()
    // Anonymous function with arrow syntax
    let double = x => x * 2

    // Multi-arg
    let add = (a, b) => a + b

    print(double(21))          // 42
    print(add(10, 20))         // 30

    // Closures capture
    let scale = 3
    let triple = x => x * scale
    print(triple(7))           // 21
```

Functions are first-class values:

```nova
fn apply_twice(f, x)
    f(f(x))

fn main()
    print(apply_twice(x => x + 1, 5))   // 7
```

Built-in higher-order helpers on lists:

```nova
fn main()
    let xs = [1, 2, 3, 4, 5]
    print(xs.map(x => x * x))           // [1, 4, 9, 16, 25]
    print(xs.filter(x => x % 2 == 0))   // [2, 4]

    let total = 0
    for x in xs
        total = total + x
    print(total)                         // 15
```

## 10. Error handling

NOVA has two error mechanisms that interoperate.

### Global error flag with `error` / `catch`

```nova
fn parse_age(s: string) -> int
    if not is_digit_string(s)
        error("bad age: {s}")
    parse_int(s)

fn main()
    let age = parse_age("25") catch e =>
        print("error: {e}")
        0
    print(age)
```

`error("msg")` sets a thread-local error flag. `catch` clears it and evaluates the fallback.

### `Result` with `ok` / `err` and the `?` operator

```nova
fn safe_divide(a: int, b: int) -> Result
    if b == 0
        return err("div by zero")
    ok(a / b)

fn compute(x: int, y: int) -> Result
    let q = safe_divide(x, y)?    // propagates err to caller
    ok(q * 2)

fn main()
    match compute(10, 2)
        ok(v) => print("got {v}")
        err(m) => print("failed: {m}")
```

`?` unwraps `ok` and propagates `err` — the same shorthand as Rust's `?`.

### Assertions

```nova
assert(x > 0, "x must be positive")
assert_eq(actual, expected)
assert_near(measured, expected, 0.001)
```

## 11. Processes and channels

NOVA's concurrency primitives: **spawn** a process, communicate over **channels**.

```nova
fn worker(ch)
    let i = 0
    while i < 5
        send(ch, i)
        i = i + 1

fn main()
    let ch = channel()
    spawn worker(ch)

    let total = 0
    let i = 0
    while i < 5
        total = total + receive(ch)
        i = i + 1
    print(total)                         // 0 + 1 + 2 + 3 + 4 = 10
```

Processes are isolated — they don't share memory. A value crossing a channel is **moved** to the receiver. Under `NOVA_TRACK8=1`, the compiler checks this statically and errors if you reference a sent variable afterward.

### Select

```nova
fn main()
    let a = channel()
    let b = channel()
    spawn fn() send(a, 1)
    spawn fn() send(b, 2)
    let v = select(a, b)                 // takes whichever arrives first
    print(v)
```

### Implicit async (green threads)

NOVA uses an M:N green thread scheduler by default. Every `spawn` creates a lightweight fiber (32KB stack), scheduled across OS threads by a work-stealing scheduler. I/O calls like `sleep_ms`, `tcp_accept`, and `tcp_recv` automatically yield to the scheduler instead of blocking the OS thread — no `async`/`await` keywords needed.

```nova
fn fetch_data(url, result_ch)
    let data = http_get(url)             // blocks this fiber, not the OS thread
    send(result_ch, data)

fn main()
    let ch = channel()
    let c = ch
    spawn(fn(x) fetch_data("http://example.com/a", c))
    spawn(fn(x) fetch_data("http://example.com/b", c))
    let r1 = recv(ch)
    let r2 = recv(ch)
    print("got both responses")
```

To disable green threads (use raw OS threads): set `NOVA_GREEN=0`.

### Bounded channels

Channels can be bounded to create back-pressure:

```nova
fn main()
    let ch = channel_bounded(2)          // max 2 items buffered
    send(ch, "a")                        // goes through
    send(ch, "b")                        // goes through
    // send(ch, "c") would block until someone recv's
    print(recv(ch))                      // "a"
```

### Fan-out / fan-in pattern

```nova
fn worker(id, task_ch, result_ch)
    let running = 1
    while running == 1
        let task = recv(task_ch)
        if task == -1
            running = 0
        else
            send(result_ch, task * task)

fn main()
    let tasks = channel()
    let results = channel()
    let tc = tasks
    let rc = results
    // spawn 4 workers
    let i = 0
    while i < 4
        let wid = i
        spawn(fn(x) worker(wid, tc, rc))
        i = i + 1
    // send 20 tasks
    let j = 0
    while j < 20
        send(tasks, j)
        j = j + 1
    // send stop signals
    let k = 0
    while k < 4
        send(tasks, -1)
        k = k + 1
    // collect results
    let total = 0
    let r = 0
    while r < 20
        total = total + recv(results)
        r = r + 1
    print("sum of squares: " + str(total))
```

### UFCS (Uniform Function Call Syntax)

Any function `f(x, args...)` can be called as `x.f(args...)`:

```nova
fn double(x)
    x * 2

fn main()
    let r = 5.double()                   // same as double(5)
    print(r)                             // 10
    let nums = [1, 2, 3]
    let doubled = nums.map(fn(x) x * 2) // method-style call
    print(doubled)                       // [2, 4, 6]
```

### Debugging

Compile with `NOVA_DBG=1` to enable the interactive debugger:

```bash
$env:NOVA_DBG = "1"
nova compile myprogram.nova
clang -o myprogram.exe myprogram.ll output/nova_runtime.o -lws2_32 -ladvapi32
./myprogram.exe                          # enters debug REPL at first line
```

The debugger auto-instruments every source line with hooks. At the REPL you can set breakpoints, step through code, and inspect variables.

## 12. Modules

A `.nova` file IS a module. The file name is the module name.

```nova
// mathx.nova
fn double(x: int) -> int
    x * 2

fn square(x: int) -> int
    x * x

fn _private_helper(x)        // _-prefixed = file-private
    x + 1
```

```nova
// main.nova
import mathx

fn main()
    print(mathx.double(21))             // 42
    print(mathx.square(9))              // 81
```

Selective import:

```nova
import mathx { double, square }
```

Aliased import:

```nova
import mathx as m
print(m.double(21))
```

## 13. FFI: calling C

NOVA can call any C function via `extern fn` with `@link`:

```nova
@link("c")
extern fn strlen(s: string) -> int

fn main()
    print(strlen("hello world"))         // 11
```

### Linking a specific library

```nova
@link("sqlite3")
extern fn sqlite3_open(path: string, db_out: out<int>) -> int

@link("sqlite3")
extern fn sqlite3_close(db: int) -> int

fn main()
    let db = 0
    sqlite3_open("data.db", &db)
    sqlite3_close(db)
```

### Opaque pointers

If C's "value" is just a handle you'll pass back unchanged, declare it `@opaque`:

```nova
@opaque
type SqliteHandle

@link("sqlite3")
extern fn sqlite3_open_v2(path: string, db: out<SqliteHandle>, flags: int) -> int
```

### `@repr(C)` structs

When a struct must match a C layout exactly (no NOVA type-hash slot at index 0):

```nova
@repr(C)
type Vec3
    x: float
    y: float
    z: float

@link("mymath")
extern fn vec3_length(v: Vec3) -> float
```

See `docs/FFI_GUIDE.md` for the full set of FFI annotations and recipes.

## 14. Building a web service

NOVA's `forge` framework is a tiny HTTP server module. Here's a complete TODO API in ~30 lines:

```nova
import forge

let _todos = []

fn route(method: string, path: string, body: string) -> string
    if method == "GET" and path == "/todos"
        return forge.json(200, "[\{join(_todos, ",")}]")

    if method == "POST" and path == "/todos"
        _todos.push("\"" + body + "\"")
        return forge.text(201, "created")

    if method == "DELETE" and path == "/todos"
        _todos = []
        return forge.text(200, "cleared")

    forge.text(404, "not found")

fn main()
    print("Listening on http://localhost:8080")
    forge.serve(8080, route)
```

Run it:

```bash
nova run todo_server.nova
# In another terminal:
curl http://localhost:8080/todos
curl -X POST -d "milk" http://localhost:8080/todos
curl http://localhost:8080/todos
```

### Static files

```nova
import forge

fn route(method: string, path: string, body: string) -> string
    if method == "GET" and path == "/"
        return forge.serve_file("index.html", "text/html")
    forge.text(404, "?")

fn main()
    forge.serve(8080, route)
```

## 15. Adding AI inference

The `cortex` framework provides classification using NOVA's built-in tensor ops:

```nova
import cortex
import forge

fn route(method: string, path: string, body: string) -> string
    if method == "POST" and path == "/classify"
        let w = tensor_from_list([1.0, 2.0, 0.0,    0.0, 1.0, 1.0], [2, 3])
        let x = tensor_from_list([1.0, 2.0, 3.0], [1, 3])

        let result = cortex.classify(w, x)
        return forge.json(200, "\{\"class\": \{result[0]}\}")

    forge.text(404, "?")

fn main()
    forge.serve(8080, route)
```

That's a real inference pipeline: a tensor weight matrix, an input vector, an argmax classification — all in one process with no IPC, no Python, no Docker. The whole binary is ~1 MB.

## 16. Deploying

### Single static binary

`nova build app.nova` produces a native executable. Ship it as-is:

```bash
nova build app.nova
scp app user@server:/opt/app/
ssh user@server '/opt/app/app &'
```

### Railway / Render / Fly.io

For containerized hosts, the recipe is:

```dockerfile
FROM debian:bookworm-slim
COPY app /usr/local/bin/app
EXPOSE 8080
CMD ["/usr/local/bin/app"]
```

A NOVA AI inference service has been verified live on Railway over HTTPS — see `NOVA_DESIGN/decisions/` for the deploy notes.

### Process supervision

NOVA's `ops` framework adds a health-check loop:

```nova
import ops

fn main()
    let url = "http://localhost:8080/health"
    let healthy = ops.healthcheck(url, "OK", 5, 100)
    if not healthy
        exit(1)
```

## 17. Where to go next

- **`docs/reference.md`** — concise reference for the syntax above
- **`docs/STDLIB_API.md`** — every stdlib function listed
- **`docs/FFI_GUIDE.md`** — deeper FFI patterns
- **`docs/FRAMEWORKS.md`** — Forge, Cortex, Pulse, Mesh, Sentinel, Ops, Reactor, Prism, Edge
- **`docs/examples.md`** — runnable examples
- **`nova-compiler/test_programs/`** — every test program is a real working sample

If a snippet here doesn't compile, that's a bug. File it.
