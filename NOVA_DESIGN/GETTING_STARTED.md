# Getting Started with NOVA

## What is NOVA?

NOVA is a universal computing language. One language for systems, web, AI, distributed, and embedded — with C-level performance and Python-level simplicity.

## Installation

```bash
# Download the NOVA compiler
# (Self-hosted: the compiler is written in NOVA itself)
nova --version
```

## Your First Program

```nova
fn main()
    print("Hello, NOVA!")
```

Compile and run:
```bash
nova hello.nova        # produces hello.ll
clang -O2 -o hello hello.ll nova_runtime.c
./hello                # Hello, NOVA!
```

## Core Concepts

### Variables and Types

NOVA infers all types. You never write type annotations for normal code:

```nova
let name = "Alice"       // string
let age = 30             // int
let pi = 3.14159         // float
let active = true        // bool
let items = [1, 2, 3]    // list
let config = {"port": 8080, "host": "localhost"}  // dict
```

### Functions

```nova
fn greet(name)
    "Hello, " + name + "!"

fn fibonacci(n)
    if n <= 1
        return n
    fibonacci(n - 1) + fibonacci(n - 2)

fn main()
    print(greet("World"))
    print(fibonacci(10))  // 55
```

Key points:
- Indentation-based blocks (like Python)
- Last expression is the return value
- No type annotations needed — the compiler infers everything
- Default parameters: `fn connect(host, port = 8080)`

### Pattern Matching

```nova
fn describe(x)
    match x
        0 => "zero"
        n if n > 0 => "positive"
        _ => "negative"

// Match on Result types
fn safe_divide(a, b)
    if b == 0
        return Err("division by zero")
    Ok(a / b)

fn main()
    match safe_divide(10, 3)
        Ok(n) => print("Result: " + str(n))
        Err(e) => print("Error: " + e)
```

### Structs and Methods

```nova
type Point(x, y)

fn Point.distance(other)
    let dx = self.x - other.x
    let dy = self.y - other.y
    sqrt(float(dx * dx + dy * dy))

fn Point.translate(dx, dy)
    Point(self.x + dx, self.y + dy)

fn main()
    let p1 = Point(0, 0)
    let p2 = Point(3, 4)
    print(p1.distance(p2))  // 5.0
```

### Collections

```nova
// Lists
let nums = [1, 2, 3, 4, 5]
let doubled = map(nums, fn(x) x * 2)
let evens = filter(nums, fn(x) x % 2 == 0)
let total = sum(nums)

// Dicts
let scores = {"alice": 95, "bob": 87}
scores["charlie"] = 92
for name in keys(scores)
    print(name + ": " + str(scores[name]))

// String methods
let s = "Hello, World!"
print(upper(s))           // HELLO, WORLD!
print(split(s, ", "))     // ["Hello", "World!"]
print(replace(s, "World", "NOVA"))
```

### Error Handling

NOVA uses Result types with the `?` operator for clean error propagation:

```nova
fn read_config(path)
    let content = read_file(path)?
    let port = parse_int(find_field(content, "port"))?
    Ok(port)

fn main()
    match read_config("app.toml")
        Ok(port) => print("Port: " + str(port))
        Err(e) => print("Config error: " + str(e))
```

### Concurrency

```nova
fn fetch_data(url, result_ch)
    let data = http_get(url)
    send(result_ch, data)

fn main()
    let ch = channel()
    spawn(fn(z) fetch_data("http://api.example.com/data", ch))
    spawn(fn(z) fetch_data("http://api.example.com/users", ch))
    
    let r1 = recv(ch)
    let r2 = recv(ch)
    print("Got: " + str(len(r1)) + " + " + str(len(r2)) + " bytes")
```

### HTTP Server

```nova
fn handle(client, raw)
    let method = slice(raw, 0, find(raw, " "))
    let path = // ... parse path
    if method == "GET" and path == "/api/hello"
        let body = "\{\"message\":\"Hello from NOVA!\"\}"
        let hdr = "HTTP/1.1 200 OK\r\nContent-Length: " + str(len(body)) + "\r\n\r\n"
        tcp_send(client, hdr + body)
    tcp_close(client)

fn main()
    let srv = tcp_listen(8080)
    print("Listening on :8080")
    while true
        let client = tcp_accept(srv)
        let raw = tcp_recv(client)
        handle(client, raw)
```

### File I/O

```nova
fn main()
    // Write
    write_file("output.txt", "Hello from NOVA!")
    
    // Read
    let content = read_file("output.txt")
    print(content)
    
    // Read lines
    let lines = split(read_file("data.csv"), "\n")
    for line in lines
        let cols = split(line, ",")
        print(cols[0] + " -> " + cols[1])
```

## What Makes NOVA Different

| Feature | Python | Go | Rust | NOVA |
|---------|--------|-----|------|------|
| Type annotations | Optional | Required | Required | Never needed (95%+) |
| Memory safety | GC | GC | Ownership | Process isolation |
| Performance | 50-100x slow | ~C speed | C speed | C speed |
| Concurrency | GIL-limited | Goroutines | async/Send+Sync | Processes + channels |
| Error handling | Exceptions | if err != nil | Result + ? | Result + ? (simpler) |
| Build system | pip/setup.py | go mod | cargo | nova build |

## Three Primitives

Everything in NOVA is one of three things:

1. **Values** — All data. Ints, strings, structs, tensors, JSON. The compiler infers types and allocation strategy.

2. **Processes** — All execution. Threads, actors, GPU kernels, distributed nodes. Light processes that don't distribute compile to zero overhead.

3. **Channels** — All communication. Function calls, network streams, events. Typed — the compiler verifies both ends agree.

## Next Steps

- Read the [Language Specification](NOVA_SPEC.md) for full syntax reference
- Browse [example programs](../nova-compiler/test_programs/) — over 330 test programs covering every feature
- Build something! The best way to learn NOVA is to write real programs in it
