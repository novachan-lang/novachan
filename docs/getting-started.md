# Getting Started with NOVA

## Installation

NOVA compiles to native code via LLVM. You need:
- **clang** (LLVM C compiler) — install via LLVM or your platform's package manager
- **nova.exe** — the NOVA compiler binary

## Hello World

Create `hello.nova`:

```nova
fn main()
    print("Hello, World!")
```

Compile and run:

```bash
nova run hello.nova
```

Output:
```
Hello, World!
```

## Variables and Types

NOVA infers types automatically — you rarely need to write them:

```nova
fn main()
    let name = "NOVA"          // string
    let version = 1            // int
    let pi = 3.14              // float
    let active = true          // bool
    let items = [1, 2, 3]     // list
    let config = {"key": "val"} // dict

    print(f"{name} v{version}")
    print(f"pi = {pi}")
    print(f"items: {len(items)}")
```

## Functions

Functions are defined with `fn`. The last expression is the return value:

```nova
fn square(x: int) -> int
    x * x

fn greet(name: string) -> string
    "Hello, " + name + "!"

fn main()
    print(square(5))       // 25
    print(greet("world"))  // Hello, world!
```

## Control Flow

```nova
fn fizzbuzz(n: int)
    let i = 1
    while i <= n
        if i % 15 == 0
            print("FizzBuzz")
        else if i % 3 == 0
            print("Fizz")
        else if i % 5 == 0
            print("Buzz")
        else
            print(i)
        i = i + 1

fn main()
    fizzbuzz(20)
```

## Working with Collections

```nova
fn main()
    // Lists
    let fruits = ["apple", "banana", "cherry"]
    push(fruits, "date")

    for fruit in fruits
        print(f"I like {fruit}")

    // Dictionaries
    let scores = {"alice": 95, "bob": 87, "charlie": 92}
    for name in keys(scores)
        print(f"{name}: {scores[name]}")

    // Sorting
    let nums = [3, 1, 4, 1, 5, 9]
    let sorted_nums = sort(nums)
    print(sorted_nums)
```

## Structs

```nova
type Point(x: int, y: int)
type Circle(center: Point, radius: int)

fn distance(a: Point, b: Point) -> float
    let dx = a.x - b.x
    let dy = a.y - b.y
    // (simplified — no sqrt yet)
    dx * dx + dy * dy

fn main()
    let p1 = Point(0, 0)
    let p2 = Point(3, 4)
    print(f"distance squared: {distance(p1, p2)}")

    let c = Circle(Point(5, 5), 10)
    print(f"circle at ({c.center.x}, {c.center.y}) r={c.radius}")
```

## Error Handling

```nova
fn main()
    // Catch errors with default value
    let content = read_file("config.txt") catch e => "default config"
    print(content)

    // Assert for preconditions
    let x = 42
    assert(x > 0, "x must be positive")
```

## File I/O

```nova
fn main()
    // Write
    write_file("output.txt", "Hello from NOVA!\n")

    // Read
    let content = read_file("output.txt")
    print(content)

    // Check existence
    if file_exists("output.txt")
        print("File exists!")
```

## HTTP

```nova
fn main()
    let response = http_get("https://httpbin.org/get")
    print(response)
```

## Closures

```nova
fn main()
    let double = x => x * 2
    let add = (a, b) => a + b

    print(double(21))    // 42
    print(add(10, 20))   // 30

    // Higher-order functions
    let items = [1, 2, 3, 4, 5]
    let doubled = map(items, x => x * 2)
    let evens = filter(items, x => x % 2 == 0)
```

## Concurrency

```nova
fn worker(ch)
    let i = 0
    while i < 5
        send(ch, f"message {i}")
        i = i + 1

fn main()
    let ch = channel()
    spawn worker(ch)

    let i = 0
    while i < 5
        let msg = receive(ch)
        print(msg)
        i = i + 1
```

## Modules

Create `mathlib.nova`:

```nova
fn gcd(a: int, b: int) -> int
    while b != 0
        let t = b
        b = a % b
        a = t
    a

fn factorial(n: int) -> int
    if n <= 1
        return 1
    n * factorial(n - 1)
```

Use it in `main.nova`:

```nova
import mathlib

fn main()
    print(mathlib.gcd(48, 18))     // 6
    print(mathlib.factorial(10))    // 3628800
```

## Package Manager

```bash
nova init                  # Create nova.toml
nova get json@1.0.0        # Add dependency
nova install               # Download dependencies
```

Then import in your code:

```nova
import json

fn main()
    let data = json.parse("{\"name\": \"NOVA\"}")
    print(data)
```

## Building Executables

```bash
nova build myapp.nova              # Creates myapp.exe
nova build myapp.nova -o app.exe   # Custom output name
nova compile myapp.nova            # LLVM IR only (no linking)
```

## Next Steps

- Read the [Language Reference](reference.md) for complete syntax and API
- Browse the [Examples](examples.md) for real-world patterns
- Install the VS Code extension for syntax highlighting and diagnostics
