# NOVA FFI Guide — Calling C from NOVA

NOVA's foreign-function interface lets you call any C function with no glue code beyond a single `extern fn` declaration. This guide covers every annotation, recipe, and gotcha.

## Contents

1. [The basics](#1-the-basics)
2. [Linking libraries](#2-linking-libraries)
3. [Argument types](#3-argument-types)
4. [Return types](#4-return-types)
5. [Out-parameters with `out<T>`](#5-out-parameters-with-outt)
6. [Opaque handles with `@opaque`](#6-opaque-handles-with-opaque)
7. [C-layout structs with `@repr(C)`](#7-c-layout-structs-with-reprc)
8. [Function pointers and callbacks](#8-function-pointers-and-callbacks)
9. [String handling](#9-string-handling)
10. [Pointer-style data](#10-pointer-style-data)
11. [Memory ownership](#11-memory-ownership)
12. [`unsafe`](#12-unsafe)
13. [Cookbook: real-world bindings](#13-cookbook-real-world-bindings)
14. [Troubleshooting](#14-troubleshooting)

---

## 1. The basics

Declare any C function inside a NOVA file with `extern fn`:

```nova
@link("c")
extern fn strlen(s: string) -> int

fn main()
    print(strlen("hello"))    // 5
```

What happens at compile time:

1. The compiler emits an LLVM `declare` for `strlen` with the matching signature
2. `clang` resolves the symbol against the C runtime library (`libc` on Linux/macOS, MSVCRT on Windows)
3. The call is direct — no marshalling layer, no FFI overhead

## 2. Linking libraries

`@link("name")` propagates as `-lname` to the linker. The compiler emits a hint comment in the `.ll`:

```nova
@link("sqlite3")
extern fn sqlite3_open(path: string, db: out<int>) -> int
```

```
; LINK_LIB: sqlite3
declare i32 @sqlite3_open(ptr, ptr) nounwind
```

On Windows, **the linker won't accept `-lm` or `-lpthread`** — they're built into MSVCRT. The build helper scripts (`_run_final_regression.ps1`) filter those automatically. Cross-platform code can still write `@link("m")` — it's a no-op on Windows and resolves correctly on Linux/macOS.

### Multiple libraries

```nova
@link("ssl")
extern fn SSL_new(ctx: ptr) -> ptr

@link("crypto")
extern fn EVP_sha256() -> ptr
```

Each declaration is independent. The same library mentioned twice is added once.

### System libraries pulled in automatically

The NOVA runtime already links against:

- `ws2_32` and `advapi32` on Windows
- `pthread`, `m`, `dl` on Linux/macOS

You don't need to add these for stdlib socket / random / math support.

## 3. Argument types

| NOVA annotation | C type | LLVM IR |
|---|---|---|
| `int` | `int64_t` | `i64` |
| `i32` | `int32_t` | `i32` |
| `i16` | `int16_t` | `i16` |
| `i8` | `int8_t` | `i8` |
| `u64` | `uint64_t` | `i64` |
| `usize` | `size_t` | `i64` |
| `float` | `double` | `double` |
| `bool` | `int` (zero / nonzero) | `i64` |
| `string` | `const char *` | `ptr` |
| `ptr` | `void *` | `ptr` |
| `@opaque` type | matching pointer type | `ptr` or `i64` |
| `@repr(C)` struct | matching struct type | `ptr` (passed by reference) |
| `out<T>` | `T *` | `ptr` |

### Narrowing conversions

When you declare an argument as `i32`, the compiler emits a `trunc i64 to i32` at the call site:

```nova
@link("c")
extern fn close(fd: i32) -> i32

fn main()
    let fd: int = 5
    close(fd)        // %x = trunc i64 5 to i32, then call
```

### Sign extension

`i32` return values are sign-extended back to NOVA's `i64`:

```nova
@link("c")
extern fn getpid() -> i32
```

The `.ll` does `%r = call i32 @getpid()` then `%ri = sext i32 %r to i64`.

## 4. Return types

The same type table applies. `unit` (no return) maps to C's `void`:

```nova
@link("c")
extern fn srand(seed: u64) -> unit
```

becomes:

```
declare void @srand(i64)
```

## 5. Out-parameters with `out<T>`

C frequently uses output pointers — `f(in_arg, &result)`. NOVA models this with `out<T>`:

```nova
@link("sqlite3")
extern fn sqlite3_open(path: string, db: out<int>) -> int

fn main()
    let db = 0
    sqlite3_open("data.db", &db)
    print(db)        // a non-zero handle
```

The `&db` syntactic shortcut produces an LLVM `ptr` to the NOVA variable's alloca slot. After the call, NOVA reads the slot through a `load`.

### Multiple `out` params

```nova
@link("mygeo")
extern fn project(lat: float, lon: float,
                  x: out<float>, y: out<float>) -> int

fn main()
    let x = 0.0
    let y = 0.0
    project(40.7, -74.0, &x, &y)
    print("[{x}, {y}]")
```

### Nested `out<T>` on structs

You can use `out<@repr(C) MyStruct>` to fill a C struct from a NOVA-allocated stack slot:

```nova
@repr(C)
type GpuInfo
    vendor: i32
    device: i32
    vram_mb: i32

@link("nova_gpu")
extern fn gpu_info(info: out<GpuInfo>) -> i32

fn main()
    let info = GpuInfo { vendor: 0, device: 0, vram_mb: 0 }
    gpu_info(&info)
    print("VRAM: {info.vram_mb} MB")
```

## 6. Opaque handles with `@opaque`

When a C library exposes a type that's just a pointer you hand back unchanged, declare it `@opaque`. The NOVA program treats it as an int handle; the FFI layer marshals it as the matching pointer type:

```nova
@opaque
type Sqlite3

@link("sqlite3")
extern fn sqlite3_open_v2(path: string,
                          db: out<Sqlite3>,
                          flags: int) -> int

@link("sqlite3")
extern fn sqlite3_close(db: Sqlite3) -> int

@link("sqlite3")
extern fn sqlite3_exec(db: Sqlite3, sql: string,
                       cb: ptr, ctx: ptr,
                       errmsg: out<ptr>) -> int
```

Opaque types have:

- Zero NOVA-side methods (the compiler doesn't synthesise anything)
- No type-hash slot (it's a raw pointer)
- No reference counting (you're responsible for the matching close call)

## 7. C-layout structs with `@repr(C)`

By default, NOVA structs reserve slot 0 for a 64-bit type hash used at runtime for dynamic dispatch. C code doesn't know about that slot, so when you pass a struct to C you must drop it:

```nova
@repr(C)
type Vec3
    x: float
    y: float
    z: float

@link("mymath")
extern fn vec3_length(v: Vec3) -> float
```

The emitted struct layout matches `struct { double x; double y; double z; }` exactly. Address-of works through `&`:

```nova
fn main()
    let v = Vec3 { x: 3.0, y: 4.0, z: 0.0 }
    print(vec3_length(v))     // 5.0
```

### Limitations

- All fields must be primitive (`int`, `float`, `i32`, etc.) or `@opaque`
- Nested struct fields must also be `@repr(C)`
- No tagged unions yet — sum types aren't C-compatible

## 8. Function pointers and callbacks

For C APIs that take a callback (`qsort`, `sqlite3_exec`, GLFW input handlers):

```nova
@link("c")
extern fn qsort(base: ptr, n: usize, sz: usize, cmp: ptr) -> unit
```

NOVA function pointers are stored as `i64` (effectively `intptr_t`), so you pass them as `ptr`. For now, the compiler doesn't synthesise C-callable wrappers for arbitrary NOVA functions — you can pass:

1. The result of `&some_extern_fn` (calls a C symbol)
2. A pointer obtained from another FFI call

Future work will let you pass a NOVA function with `@cdecl` annotation.

## 9. String handling

`string` in an `extern` arg passes a `const char *` to a UTF-8 NUL-terminated buffer. NOVA strings are already NUL-terminated (the runtime maintains a trailing null), so no copy is needed.

When a C function returns a `char *`, declare the return as `ptr` and convert:

```nova
@link("c")
extern fn getenv(name: string) -> ptr

fn main()
    let p = getenv("HOME")
    if p == 0
        print("not set")
    else
        print(cstr_to_string(p))
```

`cstr_to_string(ptr)` copies the C string into a NOVA-managed `string`.

### Mutating strings

NOVA strings are immutable. To pass a mutable buffer to C:

```nova
@link("c")
extern fn read(fd: i32, buf: ptr, n: usize) -> int

fn read_some(fd: int, n: int) -> string
    let buf = bytes(n)
    let count = read(fd, buf, n)
    bytes_to_str(bytes_slice(buf, 0, count))
```

## 10. Pointer-style data

`ptr` is the catchall for raw pointers. You'll see it for:

- Opaque library state where you didn't bother to declare `@opaque`
- Buffers being passed to or from C

Operations on raw `ptr`:

```nova
unsafe
    // Read i64 at offset
    let v = ptr_read_i64(p, 8)

    // Write byte
    ptr_write_byte(p, offset, 42)

    // Pointer arithmetic
    let p2 = ptr_offset(p, 16)
```

(These primitives are exposed via the `unsafe` module — see §12.)

## 11. Memory ownership

C and NOVA have different memory models. The general rules:

| Source of memory | Who frees it? |
|---|---|
| NOVA allocation passed to C (`string`, `bytes`, `@repr(C)` struct) | NOVA frees when refcount hits zero |
| C-malloc'd buffer returned to NOVA | **You must** call the matching free function |
| C-static memory (e.g. `getenv` result) | Nobody frees it; don't try |
| NOVA closure passed to C | Lives as long as NOVA holds it; don't store across NOVA scope boundaries without a strong ref |

The single biggest FFI pitfall: a C function stores a NOVA-allocated pointer somewhere C-only, and NOVA later frees the value. With Track 8's W5b auto-drop default OFF, this is rare but possible. When in doubt:

```nova
import unsafe

fn main()
    let buf = bytes(1024)
    unsafe
        keep_alive(buf)     // pin until matching release
    c_function_that_stashes(buf)
    // ... later ...
    unsafe
        release(buf)
```

## 12. `unsafe`

NOVA's `unsafe` keyword marks code that the type system can't prove memory-safe. Today it's advisory — the compiler permits raw pointer ops only inside an `unsafe` block. Future versions will track unsafe regions in audit reports.

```nova
unsafe
    let p = ptr_cast(some_int)
    ptr_write_byte(p, 0, 1)
```

Use `unsafe` for:

- Hand-rolled FFI bindings that need pointer arithmetic
- Casts between integer-like and pointer-like types
- Calls to genuinely unsafe C functions (mmap, mprotect, dlsym)

## 13. Cookbook: real-world bindings

### libc

```nova
@link("c")
extern fn getpid() -> i32

@link("c")
extern fn time(t: ptr) -> u64

@link("c")
extern fn malloc(size: usize) -> ptr

@link("c")
extern fn free(p: ptr) -> unit

@link("c")
extern fn memcpy(dst: ptr, src: ptr, n: usize) -> ptr
```

### SQLite

```nova
@opaque
type Sqlite3

@link("sqlite3")
extern fn sqlite3_open(path: string, db: out<Sqlite3>) -> int

@link("sqlite3")
extern fn sqlite3_close(db: Sqlite3) -> int

@link("sqlite3")
extern fn sqlite3_exec(db: Sqlite3, sql: string,
                       cb: ptr, ctx: ptr,
                       errmsg: out<ptr>) -> int

@link("sqlite3")
extern fn sqlite3_last_insert_rowid(db: Sqlite3) -> i64

fn main()
    let db = 0
    sqlite3_open("data.db", &db)
    let errmsg = 0
    sqlite3_exec(db, "CREATE TABLE t (id INTEGER, name TEXT)",
                 0, 0, &errmsg)
    sqlite3_exec(db, "INSERT INTO t VALUES (1, 'hello')",
                 0, 0, &errmsg)
    print(sqlite3_last_insert_rowid(db))
    sqlite3_close(db)
```

A complete working SQLite-backed TODO API ships as `demo_forge_todo_test.nova`.

### OpenSSL

```nova
@opaque
type SSL_CTX
@opaque
type SSL

@link("ssl")
extern fn TLS_client_method() -> ptr

@link("ssl")
extern fn SSL_CTX_new(method: ptr) -> SSL_CTX

@link("ssl")
extern fn SSL_CTX_free(ctx: SSL_CTX) -> unit

@link("ssl")
extern fn SSL_new(ctx: SSL_CTX) -> SSL

@link("ssl")
extern fn SSL_free(ssl: SSL) -> unit
```

### POSIX threads

```nova
@link("pthread")
extern fn pthread_create(thread: out<int>,
                         attr: ptr,
                         start_routine: ptr,
                         arg: ptr) -> i32

@link("pthread")
extern fn pthread_join(thread: int, retval: out<ptr>) -> i32
```

You generally prefer NOVA's `spawn` over raw pthreads, but FFI is available.

## 14. Troubleshooting

### "Undefined reference to `<name>`"

The library isn't on the linker path. Check:

- Is `@link("name")` declared on the same function as the `extern fn`?
- Is the library installed in a place clang can find it?
- On Windows, is the name correct (e.g. `Ws2_32` not `ws2`)?

### Crash inside an FFI call

99% of the time this is a type mismatch. Verify:

- Every NOVA `int` argument matches a C `int64_t` (not `int32_t`)
- Pointer-style returns are declared as `ptr`, not `int`
- `@repr(C)` is used on every struct touched by C

Compile with `-O0` (via `nova compile <file>` then manual clang invocation) to make the stack trace readable.

### Returning a struct by value

C returns structs by value; NOVA can receive them via `out<T>`. If a C library returns a struct directly (no out-param), wrap it on the C side and expose an out-param version. Direct struct-return ABI matching is on the roadmap but not yet supported.

### Re-entry from C into NOVA

Currently not supported in the released compiler. C code must not call back into NOVA functions through function pointers it received. The `@cdecl` annotation will enable this in a future release.

---

For the full set of `extern fn` recipes used by NOVA's own framework code, browse `nova-compiler/test_programs/ffi_*.nova` — every one is a working sample.
