# NOVA Language Specification (v0.1)

## Lexical Structure

### Comments
```nova
// Single-line comment
/// Documentation comment (attached to next declaration)
```

### Literals
```
42              integer (i64)
3.14            float (f64)
"hello"         string (UTF-8, immutable)
true / false    boolean
[1, 2, 3]      list literal
{"k": v}        dict literal
```

### String Escapes
```
\n   newline       \t   tab          \r   carriage return
\\   backslash     \"   double quote  \0   null
\{   literal {     \}   literal }
```

String interpolation: `"x is {x}"` expands to `"x is " + str(x)`.

### Identifiers
```
snake_case       functions, variables, modules
_prefixed        module-private (not exported)
PascalCase       types (structs, enums)
UPPER_CASE       constants (convention)
```

## Declarations

### Variables
```nova
let x = 42                  // immutable binding
let mut counter = 0         // mutable binding (future)
```

### Functions
```nova
fn name(param1, param2)
    body

fn name(param1, param2) -> ReturnType
    body

fn name(x, y = 0, z = "")  // default parameters
    body
```

### Structs
```nova
type Point(x, y)
type Person(name, age, email = "")

// Construction
let p = Point(3, 4)
let person = Person("Alice", 30)

// Field access
print(p.x)    // 3
print(p.y)    // 4
```

### Methods
```nova
fn Point.distance(other)
    let dx = self.x - other.x
    let dy = self.y - other.y
    sqrt(float(dx * dx + dy * dy))

// Protocol methods on builtins
fn int.double()
    self * 2

fn string.shout()
    upper(self) + "!"
```

### Enums / Sum Types
```nova
type Color = Red | Green | Blue
type Option = Some(value) | None
type Result = Ok(value) | Err(error)
```

### Type Aliases
```nova
type Url = string
type Matrix = list
```

## Expressions

### Arithmetic
```
+  -  *  /  %              standard arithmetic
**                          power (future)
```

### Comparison
```
==  !=  <  >  <=  >=       comparison (work on all types)
```

### Logical
```
and  or  not               logical operators
```

### Bitwise
```
bit_and(a, b)    bit_or(a, b)    bit_xor(a, b)
bit_not(a)       bit_shl(a, n)   bit_shr(a, n)
```

### String Operations
```nova
"hello" + " world"        // concatenation
len("hello")               // 5
"hello"[0]                 // "h"
slice("hello", 1, 3)      // "el"
```

### If Expression
```nova
let x = if condition
    value_a
else
    value_b
```

### Match Expression
```nova
let result = match x
    0 => "zero"
    1 => "one"
    n if n > 0 => "positive"
    _ => "other"
```

## Statements

### If/Else
```nova
if condition
    body
else if other_condition
    body
else
    body
```

### While Loop
```nova
while condition
    body
```

### For Loop
```nova
for item in collection
    body

for i in range(0, 10)
    body
```

### Match Statement
```nova
match value
    Pattern1 => action1
    Pattern2 => action2
    _ => default_action
```

### Return
```nova
fn early_return(x)
    if x < 0
        return -1
    x * 2
```

## Type System

### Inference
NOVA uses Hindley-Milner type inference extended with:
- Structural subtyping for structs
- Automatic widening for numeric types
- Row polymorphism for dict-like access

95%+ of code requires zero type annotations.

### Built-in Types
```
int       64-bit signed integer
float     64-bit IEEE 754
string    UTF-8 immutable string
bool      true/false
list      dynamic array (homogeneous via inference)
dict      hash map (string keys)
unit      void/nothing
```

### Result Type
```nova
Ok(value)      success variant
Err(message)   error variant

// ? operator for propagation
let x = risky_op()?   // returns Err early if error
```

## Modules

### File = Module
Each `.nova` file is a module. `_prefix` = private.

### Import
```nova
import "math"                    // import module
import "utils" as u              // aliased import
from "collections" import Stack  // selective import
```

## Concurrency

### Spawn
```nova
spawn(fn(z) worker(arg1, arg2))
```

### Channels
```nova
let ch = channel()
send(ch, value)
let result = recv(ch)
```

### Select
```nova
select
    recv(ch1) as msg => handle(msg)
    recv(ch2) as data => process(data)
```

### Green Threads (Scheduler)
```nova
sched_spawn(fn(z) green_task(args))
sched_run()    // run all green tasks to completion
```

## Standard Library (Selection)

### I/O
```
print(value)                    output to stdout
read_file(path) -> string      read file contents
write_file(path, content)      write to file
file_exists(path) -> bool      check file existence
```

### String Functions
```
len(s)  upper(s)  lower(s)  trim(s)  split(s, sep)  join(list, sep)
replace(s, old, new)  starts_with(s, prefix)  ends_with(s, suffix)
contains(s, sub)  find(s, sub)  slice(s, start, end)  repeat(s, n)
```

### List Functions
```
len(l)  push(l, item)  pop(l)  map(l, fn)  filter(l, fn)
sort(l)  reverse(l)  flatten(l)  sum(l)  zip(l1, l2)
```

### Math
```
abs(x)  sqrt(x)  pow(x, n)  min(a, b)  max(a, b)
sin(x)  cos(x)  floor(x)  ceil(x)  round(x)
```

### Networking
```
tcp_listen(port)  tcp_accept(srv)  tcp_connect(host, port)
tcp_send(sock, data)  tcp_recv(sock)  tcp_close(sock)
http_get(url)  http_post(url, body, content_type)
```

### JSON
```
to_json(value) -> string       serialize to JSON
from_json(text) -> value       parse JSON string
```

### Time
```
time_ms() -> int               current time in milliseconds
sleep(ms)                      sleep for ms milliseconds
```

## Compilation

### Pipeline
```
Source (.nova) → Lexer → Parser → Type Inference → IR → LLVM IR → Native Binary
```

### Build
```bash
nova build                     # build project (reads nova.toml)
nova run app.nova              # compile and run
nova check app.nova            # type-check only (no codegen)
nova test                      # run all *_test.nova files
nova fmt                       # format source code
```

## Design Principles

1. **The compiler is the genius** — developers write simple code, the compiler optimizes
2. **Process isolation IS memory safety** — no garbage collector, no borrow checker
3. **Zero-cost abstractions** — unused features compile away completely
4. **Progressive disclosure** — simple code for simple tasks, full control when needed
5. **One language for everything** — systems, web, AI, distributed, embedded
