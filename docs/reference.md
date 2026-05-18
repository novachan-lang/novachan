# NOVA Language Reference

## Overview

NOVA is a universal computing language built on three primitives: **Values**, **Processes**, and **Channels**. It compiles to native code via LLVM, achieving C-level performance while being simpler to write than Python.

## Basics

### Variables

```nova
let x = 42
let name = "hello"
let items = [1, 2, 3]
let config = {"host": "localhost", "port": 8080}
```

Variables are declared with `let`. Types are inferred — no annotations needed.

### Functions

```nova
fn greet(name: string) -> string
    "Hello, " + name + "!"

fn add(a: int, b: int) -> int
    a + b

fn main()
    print(greet("world"))
    print(add(10, 20))
```

Functions use indentation-based blocks. The last expression in a block is the return value.

### Type Annotations

Type annotations are optional in most cases. The compiler infers types from usage:

```nova
fn process(x)        // x type inferred from callers
    x + 1

let result = process(5)  // result: int
```

Available type annotations: `int`, `string`, `float`, `bool`, `list`, `dict`, `any`, `void`.

## Control Flow

### If/Else

```nova
if x > 0
    print("positive")
else if x == 0
    print("zero")
else
    print("negative")
```

If can also be used as an expression:

```nova
let label = if x > 0
    "positive"
else
    "non-positive"
```

### While

```nova
let i = 0
while i < 10
    print(i)
    i = i + 1
```

### For

```nova
for item in [1, 2, 3]
    print(item)

for ch in "hello"
    print(ch)

for i in range(0, 10)
    print(i)
```

### Match

```nova
match value
    0 => print("zero")
    1 => print("one")
    x if x > 10 => print("big")
    _ => print("other")
```

Pattern matching on structs:

```nova
type Point(x: int, y: int)

match p
    Point(x, y) => print(f"({x}, {y})")
```

## Data Types

### Strings

```nova
let s = "hello"
let ch = s[0]           // "h"
let sub = slice(s, 1, 3) // "el"
let n = len(s)           // 5
let parts = split(s, "l") // ["he", "", "o"]
let up = upper(s)       // "HELLO"
```

F-string interpolation:

```nova
let name = "NOVA"
let version = 1
print(f"Welcome to {name} v{version}!")
```

### Lists

```nova
let items = [1, 2, 3]
push(items, 4)
let first = items[0]
let length = len(items)

for item in items
    print(item)
```

### Dictionaries

```nova
let config = {"host": "localhost", "port": 8080}
config["timeout"] = 30
let host = config["host"]
let has_port = contains(config, "port")

for key in keys(config)
    print(f"{key} = {config[key]}")
```

### Structs

```nova
type Point(x: int, y: int)
type Person(name: string, age: int)

let p = Point(10, 20)
print(p.x)  // 10

let bob = Person("Bob", 30)
print(f"{bob.name} is {bob.age}")
```

### Enums

```nova
enum Color
    Red
    Green
    Blue

enum Shape
    Circle(radius: int)
    Rect(w: int, h: int)

match shape
    Circle(r) => print(f"circle r={r}")
    Rect(w, h) => print(f"rect {w}x{h}")
```

## Error Handling

```nova
// Catch errors
let result = read_file("config.txt") catch e => "default"

// Try propagates errors to caller
fn load_config() -> string
    let content = try read_file("config.txt")
    content

// Assert
assert(x > 0, "x must be positive")
```

## Concurrency

```nova
// Spawn a process
let p = spawn worker()

// Channels for communication
let ch = channel()
send(ch, "hello")
let msg = receive(ch)

// Select from multiple channels
let result = select(ch1, ch2)
```

## Modules

```nova
// mylib.nova
fn greet(name: string) -> string
    "Hello, " + name + "!"

// main.nova
import mylib

fn main()
    print(mylib.greet("world"))
```

Module resolution searches:
1. Current directory
2. `nova_packages/<name>/<name>.nova`

## Closures

```nova
let double = x => x * 2
let add = (a, b) => a + b

print(double(5))   // 10
print(add(3, 4))   // 7

// Closures capture variables
let factor = 3
let scale = x => x * factor
print(scale(10))   // 30
```

## Builtin Functions

### I/O
| Function | Signature | Description |
|----------|-----------|-------------|
| `print(x)` | `any -> void` | Print value to stdout |
| `read_line()` | `-> string` | Read line from stdin |
| `read_file(path)` | `string -> string` | Read file contents |
| `write_file(path, content)` | `string, string -> void` | Write to file |
| `append_file(path, content)` | `string, string -> void` | Append to file |
| `file_exists(path)` | `string -> bool` | Check if file exists |

### Strings
| Function | Signature | Description |
|----------|-----------|-------------|
| `len(s)` | `string -> int` | String length |
| `split(s, sep)` | `string, string -> list` | Split string |
| `join(list, sep)` | `list, string -> string` | Join with separator |
| `trim(s)` | `string -> string` | Remove whitespace |
| `upper(s)` | `string -> string` | Uppercase |
| `lower(s)` | `string -> string` | Lowercase |
| `replace(s, old, new)` | `string, string, string -> string` | Replace substring |
| `starts_with(s, prefix)` | `string, string -> bool` | Check prefix |
| `ends_with(s, suffix)` | `string, string -> bool` | Check suffix |
| `slice(s, start, end)` | `string, int, int -> string` | Substring |
| `find(s, sub)` | `string, string -> int` | Find index (-1 if not found) |
| `contains(s, sub)` | `string, string -> bool` | Check contains |
| `repeat(s, n)` | `string, int -> string` | Repeat string |
| `chars(s)` | `string -> list` | Split into characters |
| `ord(ch)` | `string -> int` | Character to ASCII code |
| `chr(n)` | `int -> string` | ASCII code to character |

### Collections
| Function | Signature | Description |
|----------|-----------|-------------|
| `len(x)` | `list/dict -> int` | Collection length |
| `push(list, val)` | `list, any -> void` | Append to list |
| `keys(dict)` | `dict -> list` | Dictionary keys |
| `values(dict)` | `dict -> list` | Dictionary values |
| `sort(list)` | `list -> list` | Sort list |
| `range(start, end)` | `int, int -> list` | Integer range |
| `contains(coll, val)` | `any, any -> bool` | Membership test |

### Conversion
| Function | Signature | Description |
|----------|-----------|-------------|
| `str(x)` | `any -> string` | Convert to string |
| `int(s)` | `string -> int` | Parse integer |
| `parse_int(s)` | `string -> int` | Parse integer |
| `parse_float(s)` | `string -> float` | Parse float |
| `type_of(x)` | `any -> string` | Get type name |

### System
| Function | Signature | Description |
|----------|-----------|-------------|
| `system(cmd)` | `string -> int` | Run shell command |
| `exec(cmd)` | `string -> string` | Run command, capture output |
| `exit(code)` | `int -> void` | Exit process |
| `args()` | `-> list` | Command line arguments |
| `time_ms()` | `-> int` | Current time in milliseconds |
| `clock_ns()` | `-> int` | High-resolution clock |
| `sleep(ms)` | `int -> void` | Sleep for milliseconds |

### HTTP
| Function | Signature | Description |
|----------|-----------|-------------|
| `http_get(url)` | `string -> string` | HTTP GET request |
| `http_post(url, body, type)` | `string, string, string -> string` | HTTP POST request |

### Filesystem
| Function | Signature | Description |
|----------|-----------|-------------|
| `mkdir(path)` | `string -> int` | Create directory |
| `mkdir_p(path)` | `string -> int` | Create directory (recursive) |
| `path_join(a, b)` | `string, string -> string` | Join path components |
| `path_exists(path)` | `string -> int` | Check path exists |
| `path_parent(path)` | `string -> string` | Get parent directory |
| `path_name(path)` | `string -> string` | Get filename |

## CLI

```
nova run <file.nova>       Compile and run
nova build <file.nova>     Compile to executable
nova compile <file.nova>   Compile to LLVM IR
nova version               Show version
nova self-test             Run compiler self-test
nova init                  Create nova.toml
nova get <package>         Add dependency
nova install               Download all dependencies
```

Options: `--old` (legacy pipeline), `-O0` (no optimization), `-o <output>`.

## Package Manager

### nova.toml

```toml
[package]
name = "my-project"
version = "0.1.0"

[dependencies]
json = "1.0.0"
```

### Workflow

```bash
nova init                  # Create nova.toml
nova get json@1.0.0        # Add dependency
nova install               # Download all dependencies
```

Packages are stored in `nova_packages/<name>/<name>.nova` and imported with `import <name>`.
