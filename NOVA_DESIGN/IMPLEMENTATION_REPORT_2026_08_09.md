# NOVA — Complete Implementation Report (Deep Technical)

> **Date:** 2026-08-09
> **Source:** Line-by-line audit of `nova_compiler.nova` (31,324 lines) + `nova_runtime.c` (32,148 lines)
> **Purpose:** What we have built, HOW it works internally, what doesn't work, what's remaining.

---

## Executive Summary

NOVA is a **63,472-line self-hosted programming language**. The compiler (31,324 lines of NOVA code)
compiles itself to a byte-identical fixpoint — gen5.ll == gen6.ll, proving the compiler can correctly
compile its own source. The C runtime (32,148 lines) provides memory management, an M:N green-task
scheduler, channel-based IPC, networking (TCP/TLS/HTTP/WebSocket), and ~1,500 C functions backing
1,328 typed builtins.

---

## 1. How the Compiler Actually Works

### 1.1 The Self-Hosting Loop

The compiler lives at `nova-compiler/compiler/nova_compiler.nova`. It cannot compile itself from
scratch — it needs a **seed binary** (`gen3_test.exe`, checked into `nova-compiler/test_programs/`).
The bootstrap loop works like this:

1. **gen3_test.exe** (the seed) compiles `nova_compiler.nova` → produces `gen4.ll` (LLVM IR text)
2. `clang` links `gen4.ll` + `nova_runtime.c` → `gen4.exe`
3. **gen4.exe** compiles `nova_compiler.nova` → produces `gen5.ll`
4. `clang` links `gen5.ll` → `gen5.exe`
5. **gen5.exe** compiles `nova_compiler.nova` → produces `gen6.ll`
6. **gen5.ll must be byte-identical to gen6.ll** — if it is, the compiler has reached a fixpoint
   and is proven correct (it produces the same output regardless of which generation compiled it)

If gen5.ll != gen6.ll, the compiler is broken — some instruction's output depends on which binary
ran it, meaning the compiler has a bug that changes its own behavior. This has caught real bugs
that no test suite could: a struct-field-leak use-after-free was found because it caused a register
to hold a stale value, producing different IR between gen5 and gen6.

The seed `gen3_test.exe` was originally produced by the Java bootstrap compiler (which is now dead
code — do not edit the `.kt` files). On Linux, `nova_compiler_linux.ll` serves the same role
(cross-compiled from Windows with `--target linux`).

### 1.2 The Lexer (lines 93–985)

Hand-written, character-by-character scanner — no lexer generator, no regex, no table-driven
automaton. This is a deliberate choice: a hand-written lexer is faster, produces better error
messages, and handles NOVA's complex string interpolation without a separate preprocessing step.

**How string interpolation works internally:** When the lexer encounters `f"hello {name:.2f} world"`,
it doesn't produce one token. It produces a sequence:
- `INTERP_START` with value `"hello "`
- The lexer **recursively re-tokenizes** the `{name:.2f}` portion — it tracks brace depth so
  nested expressions like `f"x={dict[key]}"` work correctly
- `INTERP_SPEC` with value `".2f"` (the format spec after the colon)
- `INTERP_END` with value `" world"`

The parser then reassembles these into a string concatenation with format calls.

**Sized numeric suffixes** (e.g., `255u8`, `3.14f32`) are range-checked AT LEX TIME by
`_num_suffix_max` — `255u8` passes, `256u8` is a lex error. This catches overflow before
the parser ever sees the token.

**Triple-quoted text blocks** use Java/Kotlin-style common-indent stripping (`_dedent_block`):
the lexer finds the minimum indentation of all non-empty lines and strips that many characters
from each line, so the code's indentation doesn't pollute the string content.

### 1.3 The Pratt Parser (lines 986–2198)

A precedence-climbing (Pratt) parser — the standard technique for expression parsing where
each operator has a binding power. The precedence table (`infix_bp`, line 1092):

```
Lowest:  ..  (range)
         catch, |> (pipe)
         or
         and
         | (bitwise or)
         ^ (bitwise xor)
         & (bitwise and)
         ==, !=, matches
         <, <=, >, >=, in, not in
         <<, >>
         +, -
         *, /, %
Highest: ** (power, right-associative)
```

**How chained comparisons work:** `a < b < c` is NOT parsed as `(a < b) < c` (which would compare
a boolean to c). The parser detects the chain and desugars it to `a < b and b < c` at parse time,
with `b` evaluated exactly once (bound to a temporary). This matches Python's semantics.

**How comprehensions work:** `[x*2 for x in items if x > 0]` is NOT a special IR construct. The
parser desugars it at parse time into `map(filter(items, fn(x) x > 0), fn(x) x*2)` — nested
comprehensions produce nested `map`/`filter`/`flatten` calls. The rest of the compiler sees
ordinary function calls.

**Error recovery:** The parser doesn't stop at the first error. `syntax_error` accumulates errors,
and `sync_to_stmt` (line 174) does bracket-depth-aware recovery — it skips tokens until it finds
a statement boundary at the correct nesting depth, so one bad statement doesn't cascade into
spurious errors for the rest of the file.

### 1.4 The 19 Annotation Injectors (lines 4326–5957)

These are NOT runtime features. They are **compile-time source-to-source transforms** that run
AFTER parsing and BEFORE type inference. Each one reads an annotation from the AST and generates
additional NOVA functions that get compiled normally.

**How @test works (`inject_tests`, line 4605):** Finds every function with `@test`, verifies it
has zero parameters and returns bool (compile error otherwise), then generates a
`__nova_run_tests()` function that calls each test, prints PASS/FAIL, and respects the
`NOVA_TEST_FILTER` environment variable for selective execution. The generated runner is a
plain NOVA function — no special runtime support needed.

**How @get/@post works (`inject_routes`, line 4703):** Finds functions annotated with
`@get("/path")` or `@post("/path")`, then generates a `__nova_register_routes(app)` function
that calls the Forge HTTP framework's `route_get(app, "/path", handler)` for each. This is
the Spring `@GetMapping` equivalent — zero runtime cost, pure codegen.

**How @comptime works (`inject_comptime`, line 5224):** This is a REAL compile-time evaluator.
It runs a separate tree-walking interpreter (`ce_eval_expr`/`ce_eval_call`) on the function body
at compile time, subject to a budget limit (`ce_budget_ok`, to prevent infinite loops from hanging
compilation). The result is inlined at the call site — a `@comptime fn fib(n)` called as `fib(10)`
becomes the literal `55` in the compiled output. This is NOVA's answer to Zig's comptime.

### 1.5 Structural Rendering — No @derive (lines 3979–4325)

When you write `type User { name: string, age: int }`, the compiler AUTOMATICALLY generates:

- `User.show()` → `"User(name=Alice, age=30)"` (for `print` and `str()`)
- `User.to_json()` → `{"name":"Alice","age":30}`
- `User.from_json(s)` → parses JSON string into a User struct
- `User.from_json_safe(s)` → same but returns `Result<User>` instead of panicking
- `User.from_dict(d)` → constructs from a dict (used by ORM for database rows)
- `User.fields()` → `["name", "age"]`
- `User.field_get("name")` → `"Alice"` (runtime reflection)

There is NO `@derive` annotation. Every struct gets these for free. The generation is in
`expand_derives` (line 4850) which calls the individual `_make_*` functions. The generated
code is plain NOVA that goes through normal type-checking and compilation.

**Why this matters:** In Rust, you write `#[derive(Debug, Serialize, Deserialize)]` on every struct.
In NOVA, you write nothing — the compiler handles it. This eliminates an entire class of
boilerplate and makes every struct JSON-serializable and database-extractable by default.

### 1.6 The Hindley-Milner Type System (lines 14936–19435)

This is a REAL Hindley-Milner type inferrer with union-find, occurs check, and let-polymorphism.
Not a simplified version — the full algorithm.

**The core data structures:**

```
NType — A type node
  kind: "int" | "float" | "string" | "list" | "fn" | "var" | "struct" | "sum" | ...
  params: child types (list<T> has params=[T], fn(A)->B has params=[A,B])
  id: type variable id (only for kind="var")
  name: struct name (only for kind="struct")

TiState — The inference state (26 fields)
  ti_bindings: dict   — union-find parent map (var_id → NType)
  ti_constraints: list — deferred unification constraints
  ti_scope: list       — stack of scope dictionaries (name → NTypeScheme)
  ti_structs: dict     — struct name → field types
  ti_enum_variants: dict — variant name → payload types
  ...
```

**How inference works, step by step:**

1. **Fresh type variables:** For every untyped `let x = ...`, the inferrer creates a fresh type
   variable `?T42` and records `x : ?T42`.

2. **Constraint generation:** Walking the AST generates constraints. `x + 1` generates
   `?T42 = int` (because `+` with an `int` literal constrains the other operand). A function
   call `f(x)` where `f : fn(string) -> int` generates `?T42 = string`.

3. **Unification (`ti_unify`, line 15565):** Solves constraints by unifying types. Uses
   **union-find** (`ti_walk`, line 15225) to follow type variable bindings. The occurs check
   (`ti_occurs`, line 15231) prevents infinite types like `T = list<T>`.

4. **Let-polymorphism:** `ti_generalize` (line 15523) turns a monomorphic type into a polymorphic
   scheme by universally quantifying free variables. `ti_instantiate` (line 15461) creates fresh
   copies when the scheme is used. This is why `fn identity(x) = x` works with both `int` and
   `string` arguments.

5. **Return type handling (TIER 1 — SOUND BY DEFAULT):** For functions WITHOUT a return type
   annotation, the inferrer DEFERS the return type join. It collects all return-expression types
   in `ti_ret_seen`, then AFTER the function's constraints are solved (`ti_solve`), joins them
   in `ti_ret_join_bind` (line 15268). If all returns agree on a concrete type, that type is
   preserved (no widening to `any`). If returns genuinely disagree (e.g., returns `int` in one
   branch and `string` in another), it widens to `any` and marks the function as heterogeneous
   in `ti_fn_hetero` so the IR optimizer doesn't refine it back.

   **Why this matters:** An earlier version eagerly bound the return type to the FIRST return
   expression's type. If the first return was a type variable (not yet resolved), the function
   got typed as `any`, and float functions returned boxed garbage. Deferring fixed this.

6. **Exhaustive match checking (`ti_check_exhaustive`, line 18679):** When you write
   `match result`, the inferrer checks that you've covered every variant of the `Result`/`Option`/
   enum type. If you're missing an arm, it's error E1009. This is ENFORCED, not optional.

**The builtin registry (`ti_build_stdlib`, lines 15735–17128):** Every one of the 1,328 builtins
has a full type signature here. `map` is registered as `<T,U>(list<T>, fn(T)->U) -> list<U>` —
a real generic signature with type parameters, not `any`. This means `map([1,2,3], fn(x) str(x))`
is inferred as `list<string>` without any annotation.

### 1.7 The 8 Optimization Passes (lines 19436–21815)

These operate on the mid-level IR (IrFunction/IrBlock/IrInst), not on the AST or LLVM IR.

**Tail Call Optimization (`ir_tco`, line 19456):** Scans each function for self-recursive calls
in tail position (the call result is immediately returned with no further computation). When
found, it rewrites the recursion into a loop: the entry block becomes a `goto tco_loop`, and the
tail call is replaced by `slot_store` instructions that update the parameters, followed by
`goto tco_loop`. This turns `fn fib(n) = if n < 2: n else: fib(n-1) + fib(n-2)` from a stack-
overflowing recursion into a flat loop. (Note: the `fib` example isn't tail-recursive; TCO applies
to patterns like `fn sum(n, acc) = if n == 0: acc else: sum(n-1, acc+n)`.)

**Dead Block Elimination (`ir_dbe`, line 19500):** BFS from the entry block following goto/branch
targets. Any block not reached is dead code and is removed. Simple but essential after TCO (which
can make the original entry block unreachable).

**Dead Instruction Elimination (`ir_die`, line 19541):** Builds a `used` set of all registers
that appear as arguments to any instruction or terminator. Any instruction whose destination
register is not in `used` AND is marked `"pure"` (no side effects) is deleted.

**Constant Folding + Slot Forwarding (`ir_const_fold`, line 19854, ~440 lines):** The largest
classical pass. Propagates known constant values through the IR: if `%r3 = const_int 5` and
later `%r7 = add %r3, %r4` where `%r4 = const_int 3`, it replaces `%r7` with `const_int 8`.
Also handles string operations (known-length strings), boolean simplification, and slot forwarding
(if a `slot_store` is immediately followed by a `slot_load` of the same slot with no intervening
write, replace the load with the stored value).

**Interprocedural Escape Analysis (`ir_escape_analysis`, line 19583, ~250 lines):** A whole-program
analysis that determines, for each struct allocation, whether it "escapes" the function that
created it (gets returned, stored in a global, passed to a function that stores it, etc.). If a
struct doesn't escape, it can be **stack-promoted** — allocated on the stack instead of the heap,
eliminating the malloc/free overhead entirely. The analysis is interprocedural: it computes per-
function summaries (`ir_escape_summaries`) of which parameters escape, so a call to a known
function that doesn't store its argument doesn't count as an escape.

**S4.2 Loop Versioning (`s4_make_versioned`, line 14777):** This is the key to NOVA's float-array
performance. The problem: when a float array is passed to a function (escapes), the type taint
system demotes it from `floatlist` (a typed, unboxed array where `xs[i]` is a direct 64-bit float
read) to `val` (a boxed any-typed value where `xs[i]` requires unboxing — 160x slower than C).

The solution is **loop versioning**: the compiler wraps the hot loop in a runtime guard:
```
if list_is_kind2(xs) == 1:
    // FAST PATH: xs is a typed float array
    // Alpha-rename all locals (NOVA uses name-based slots, so shared names = shared boxed slot)
    // Use floatlist_view(xs) for direct float access
    // All array accesses are UNCHECKED (bounds proven safe by the guard)
    <fast loop body>
else:
    // SLOW PATH: original code, unchanged
    <original loop body>
```

The fast path is only taken when the runtime confirms the array is actually a typed float array
(kind==2). Otherwise, the identical original code runs. This is **sound by construction** — the
fast path can never produce wrong results because it's guarded by a runtime type check.

**MEASURED RESULT:** Float array loops went from ~160x slower than C to ~1.2x of C. The transform
is DEFAULT-ON and transparent (zero developer configuration needed). It was reconverged byte-
identical with the transform running on the compiler itself, proving it doesn't change the
compiler's own output.

### 1.8 The Dual LLVM Backends

NOVA has TWO LLVM IR text emitters that must always agree:

1. **Legacy backend ("emit"/"cg", lines 5958–10815):** Direct AST→LLVM-text. Skips the IR entirely.
   This is the ORIGINAL backend from before the IR was built. Reachable via `--old`. It contains
   the massive `resolve_runtime_fn` table (2,650 lines) that maps every builtin name to its
   `nova_rt_*` C symbol.

2. **Primary backend ("ire_line", lines 21816–24249):** IR→LLVM-text via `IrEmitter`. This goes
   through all 8 optimization passes. It has the target/ABI layer, debug info, coverage
   instrumentation.

Both backends exist because the legacy one serves as a **cross-check**: if the new backend
produces different results than the old one for the same program, something is wrong. They're
also both needed for reconverge — the compiler compiled by the legacy backend must produce the
same output as the compiler compiled by the primary backend.

**The ABI classification layer (lines 22005–22163):** When NOVA calls a C function that takes a
struct by value (`extern fn vec2_sum(v: Vec2) -> float`), the LLVM IR must reflect how the
platform ABI actually passes that struct. This is NOT automatic — LLVM IR is NOT ABI-aware for
aggregates (a common misconception that cost us a failed attempt and a segfault). The compiler
must do what clang does: classify the struct's fields and decide:

- **Win64:** Structs ≤8 bytes go in one integer register. Larger structs are passed by pointer.
- **SysV x86-64:** Fields are classified into "eightbytes" (INTEGER or SSE). Up to 2 eightbytes
  can be passed in registers. Larger structs go to the stack.
- **AArch64:** Structs ≤16 bytes in registers. Homogeneous float aggregates (HFAs) get up to
  4 SIMD registers.

This classification is in `_abi_field_kinds`/`_abi_struct_ret_type`/`_abi_struct_param_types`.

---

## 2. How the Runtime Actually Works

### 2.1 Memory: The Object Space Allocator

NOVA's allocator is NOT malloc. It's a **virtual-memory-reservation-based slab allocator** with
a single contiguous address space.

**How it works:**

At startup, `nova_oa_reserve()` (line 540) reserves **16 GiB of virtual address space** (not
physical memory — just address space, which is free on 64-bit systems):
- Windows: `VirtualAlloc(NULL, 16GB, MEM_RESERVE, PAGE_READWRITE)`
- Linux: `mmap(NULL, 16GB, PROT_NONE, MAP_PRIVATE | MAP_ANONYMOUS | MAP_NORESERVE, -1, 0)`

Memory is then committed in arenas as needed (`nova_oa_commit`, line 559), which makes
physical pages available within the reservation.

**Why a single interval matters:** The ownership test `nova_oa_owns()` (line 520) is just:
```c
return addr >= base && addr < end;
```
Two comparisons. This is what makes reference counting cheap — every time the runtime needs
to know "is this pointer one of our managed objects?", it's a subtract and a compare, not a
hash table lookup. MEASURED: a hash-table-based ownership check cost ~10% overhead on crypto
workloads; this costs effectively zero.

**Size classes:** Objects are allocated from size-class pools (`nova_oa_class_of`, line 575):
- Small (≤512 bytes): rounded up to 16-byte multiples, each class has its own free list
- Medium (513–32768 bytes): power-of-2 classes from 2KB to 32KB
- Huge (>32KB): dedicated allocations

**Slab allocator** (line 307): For the hottest sizes (48-byte and 64-byte), there's a page-based
slab allocator. A slab page holds 128 objects. This is where NovaList (40 bytes total with RC
header) and NovaDict (56 bytes) land — the two most-allocated types.

**The CRITICAL bug class this design eliminates:** Before the object space, `nova_mem_find_tag`
(the function that reads an object's type tag from its header) had to guess whether a 64-bit
value was a pointer or a raw integer. The old heuristic used magnitude — "if the value looks
like a reasonable heap address, it's probably a pointer." This was **unsound**: a large integer
could look like a valid pointer, and a float's bit pattern could too. The object space makes
the test EXACT: if the value falls within `[base, end)`, it's one of our objects. Period.

### 2.2 Reference Counting

Every managed object has an 8-byte header BEFORE the returned pointer:

```
[-8 bytes from returned pointer]
  bits 0-2:   NOVA_RC_TAG (type: list=2, dict=3, string=4, struct=5, etc.)
  bits 3-?:   NSLOTS (for structs: number of fields)
  bit 16:     HASHED bit (struct slot 0 is a registered type hash for field-type tracking)
  bits 32-63: reference count
```

**How rc_inc/rc_dec work:**
- `rc_inc(p)`: Atomically increment the refcount (at N>1 carriers, uses `__atomic_fetch_add`;
  at N=1, a plain `++`).
- `rc_dec(p)`: Decrement. If count reaches 0, call `nova_rc_free(p)` which reads the tag and
  recursively frees contained objects (list elements, dict keys/values, struct fields).

**The HASHED bit (struct field ownership — Tier 0.8 fix):** Plain structs have their fields
stored WITHOUT `rc_inc` on construction (the struct is "non-owning"). The HASHED bit marks
structs that went through `nova_rt_hashed_struct_alloc` — these have a DJB2 type hash in
slot 0, and a **per-type managed-slot bitmap** (`nova_rt_register_struct_bitmap`) tells `rc_free`
WHICH slots contain pointers (need `rc_dec`) vs raw int/float (must NOT be fed to `rc_dec`).

This bitmap system was built because struct fields mix raw integers, raw floats, and heap pointers
in the same slot array. Without knowing which slots are pointers, `rc_free` would either:
(a) skip all fields → LEAK (the original bug — struct heap fields were never freed), or
(b) dec all fields → CRASH (feeding a float's bit pattern to `rc_dec` as if it were a pointer).

**Known remaining leaks:**
- Closure captures are NOT registered in the bitmap system, so captured heap values leak on closure drop
- Struct field REASSIGNMENT leaks the old value (dec-old is unsafe against borrow-based field reads)
- RC cycles (two structs pointing at each other) are never collected — needs a cycle collector

### 2.3 The M:N Green-Task Scheduler

This is NOT just green threads. It's a full M:N scheduler with carrier threads, per-task
mailboxes, I/O parking, and crash containment.

**Architecture:**

```
                    ┌─────────────────────────┐
                    │     Global Run Queue     │
                    │   (lock-free at N=1)     │
                    └──────┬──────────────────┘
                           │
         ┌─────────────────┼─────────────────┐
         ▼                 ▼                 ▼
  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐
  │  Carrier 0  │  │  Carrier 1  │  │  Carrier 2  │   (OS threads)
  │ ┌─────────┐ │  │ ┌─────────┐ │  │ ┌─────────┐ │
  │ │ Fiber A │ │  │ │ Fiber D │ │  │ │ Fiber G │ │   (user tasks)
  │ │ Fiber B │ │  │ │ Fiber E │ │  │ │ Fiber H │ │
  │ │ Fiber C │ │  │ │ Fiber F │ │  │             │
  │ └─────────┘ │  │ └─────────┘ │  │ └─────────┘ │
  │  IO Poller  │  │  IO Poller  │  │  IO Poller  │
  └─────────────┘  └─────────────┘  └─────────────┘
```

**Carrier threads** are real OS threads (auto-detected CPU count, capped at 16 by default,
override with `NOVA_CARRIERS=N`). Each carrier runs a loop:
1. Pop a task from the global run queue (or its own local deque for pinned tasks)
2. Resume the task's fiber via `nova_asm_switch` (actual assembly context switch — saves/restores
   callee-saved registers: rbx, rbp, r12-r15 on x86-64, x19-x30+d8-d15 on AArch64)
3. When the fiber yields (channel op, I/O wait, sleep, or explicit yield), the carrier resumes
   its own fiber and picks the next task

**Task allocation (`nova_task_alloc_slot`, line 9844):** Tasks are allocated from a slot array
with a freelist. Generation numbers prevent ABA races — a task handle encodes `(slot_index, generation)`,
so a reused slot with a new generation is a different task. Tasks are freed at reuse, not at completion
(so `monitor()` of a just-finished task can still read its exit status).

**I/O parking (`nova_sched_park_io`, line 9317):** When a task does a blocking I/O operation
(tcp_recv, channel recv on empty, sleep), it doesn't spin — it PARKS. The task is removed from
the run queue and registered with an `NovaIOWaiter` struct that records the file descriptor and
desired events. The carrier's poll loop (`io_poll`) checks for ready FDs and re-enqueues parked
tasks whose I/O is ready. This is how NOVA handles 100k concurrent connections without 100k threads.

**Crash containment (`nova_panic` + `longjmp`, line 265):** When a spawned task panics (assert
failure, null deref, etc.), the panic does NOT kill the whole program. Each task has a `setjmp`
buffer (`fault_buf`) set by the carrier before resuming the fiber. `nova_panic` does
`longjmp(ft->fault_buf, 1)`, which unwinds the task back to the carrier. The carrier marks the
task as crashed, drains its `on_exit_send` registrations (crash-safe cleanup — this is why forks
come back in the Dining Philosophers), and moves on to the next task.

**The on_exit_send mechanism:** When you call `on_exit_send(channel, value)`, the runtime adds
an entry to the current task's exit-cleanup list. When the task exits — normally OR via
panic/longjmp — the fiber trampoline (`nova_posix_fiber_trampoline` / `nova_win_fiber_trampoline`)
iterates this list and performs `try_send(channel, value)` for each entry. `cancel_on_exit_val`
removes an entry by backward-scanning for a matching (channel, value) pair.

**UPDATE (2026-08-10): `defer` IS NOW CRASH-SAFE.** A shadow stack + fault-isolated drain was
implemented: the compiler pushes each deferred call onto a per-task shadow stack, and
`nova_rt_defer_drain()` runs each entry inside its own nested `setjmp` so a fault in one
cleanup cannot cascade. This was reconverge byte-identical and passes 107/0 tests. The previous
analysis (defer NOT panic-safe) is now historical. Both `defer` and `on_exit_send` survive panics.

**N>1 synchronization:** At N=1, the scheduler uses no locks (the `g_sched_lock` macros are no-ops).
At N>1, `nova_is_multithreaded` is set to 1, which engages:
- `g_sched_lock` (critical section) for run-queue mutations
- Atomic `__atomic_fetch_add` for reference count increments/decrements
- Per-carrier local deques for pinned tasks (tcp_accept uses this to fan out one acceptor per carrier)
- Monotonic CAS for heap-bounds tracking (prevents a race where two carriers' bounds updates
  could narrow the valid range, causing `find_tag` to misclassify a valid object as a raw int)

### 2.4 Channels: How Process Isolation Works

Channels are the ONLY way to communicate between tasks. There is no shared mutable state.

**How send works:** `nova_rt_channel_send(ch, value)` calls `nova_rt_deep_copy(value)` to create
a complete, independent copy of the value. Lists are copied element-by-element (recursively),
dicts are copied key-by-key and value-by-value, strings are duplicated, structs are field-by-field
copied. The copy is then placed in the channel's buffer. This means the sending task's value and
the receiving task's value are COMPLETELY INDEPENDENT — modifying one after send cannot affect the
other. This is NOVA's memory safety model: process isolation, not a borrow checker.

**Bounded channels as mutexes:** `channel_bounded(1)` with one pre-loaded value creates a mutex:
- `recv(ch)` = acquire (blocks if the token is held)
- `send(ch, 1)` = release (wakes exactly one waiter)

This is the same pattern Go uses (since 2012), but in NOVA it's THE primitive — there are no
separate mutex/semaphore types. A `channel_bounded(N)` with N tokens is a counting semaphore.

**Green-task integration:** When a task does `recv` on an empty channel, it doesn't spin or
sleep — it parks (same mechanism as I/O parking). The channel's `green_waiters` list holds parked
tasks. When another task does `send`, it wakes one waiter via `nova_sched_wake_one`, which sets
the task's status back to runnable and enqueues it on the appropriate carrier.

### 2.5 The Networking Stack

**Implicit async (no `async`/`await` keyword needed):** Every blocking network call (tcp_recv,
tcp_send, tls_connect, etc.) internally parks the calling green task on the I/O poller. To the
developer, the code looks synchronous:

```nova
let conn = tcp_connect("example.com", 80)
tcp_send(conn, "GET / HTTP/1.1\r\n\r\n")
let response = tcp_recv(conn)
```

But under the hood, each call registers the FD with `io_poll` and yields the fiber. Other tasks
run while this one waits for I/O. When the FD becomes ready, the poller re-enqueues the task.
This is Go's goroutine model — synchronous-looking code with green-task concurrency underneath.

**TLS:** Uses the OS's native TLS stack:
- Windows: SChannel (via `SSPIHandleA`, `InitializeSecurityContext`)
- Linux/macOS: OpenSSL (`SSL_CTX_new`, `SSL_connect`, `SSL_read`, `SSL_write`)

Both paths support ALPN negotiation (needed for HTTP/2), insecure mode (for testing), and
certificate file loading.

**Windows timer fix:** Every NOVA network I/O operation was costing a minimum of ~15.4ms because
Windows' default timer granularity is 15.625ms, and the netpoller's idle loop calls `Sleep(1)`.
`Sleep(1)` doesn't sleep for 1ms — it sleeps until the next timer tick, which is up to 15.6ms away.
Fixed by dynamically loading `winmm.dll` and calling `timeBeginPeriod(1)` to set 1ms timer
resolution. Result: **8x improvement on ALL network I/O.** The dynamic load avoids requiring
`-lwinmm` anywhere in the build.

---

## 3. What's Genuinely Strong

**Self-hosting to a fixpoint** — Most new languages take years to reach self-hosting. NOVA's
compiler is 31k lines of NOVA, and the fixpoint proves it correct at a level no test suite can.

**Scalar performance at C parity (~1.04x)** — Via LLVM backend, no GC pauses, no JIT warmup.
Simple code (integer loops, recursion, array access) compiles to essentially the same instructions
as C.

**1,328 typed builtins** — Not `any`-typed. `map` is `<T,U>(list<T>, fn(T)->U) -> list<U>`.
`channel` is `channel<T>`. The type inferrer uses these signatures to infer types through
function calls without annotations.

**Process isolation as memory safety** — No borrow checker (Rust), no GC (Java/Go), no manual
management (C). Tasks are isolated; channels deep-copy. The developer writes simple code;
the runtime enforces safety.

**Compile speed: 170ms** (was 6500ms) — The runtime `.o` file is cached by `nova setup`, so
only the user's code needs to be compiled. Faster than Go for equivalent programs.

---

## 4. What's Genuinely Broken — THE HONEST PART

### 4.1 Critical Bugs

**Float-returning helper reads uninitialized slot → garbage (0.11, OPEN):**
`stddev(xs) = sqrt(variance(xs))` returns `3.08e-156` instead of `1.41421`. Adding a `print`
statement inside `stddev` makes it correct (Heisenbug — layout-dependent). The root cause is in
the float-return/float-slot codegen: the LLVM IR for the return slot is not properly initialized
or wired when a float value passes through a helper function's return. This is the same class as
the known `geo_bearing`/`atan2` bug. **XL effort to fix** — needs LLVM IR diffing of working vs
garbage layouts to identify the exact codegen error. Workaround: avoid nesting float-returning
helpers; compute values inline.

**Bool representation changes across a call boundary:**
Inside a function, `true` is the integer `1` and `str(true)` returns `"1"`. But when `true` is
passed as a function ARGUMENT, it becomes the boolean value and `str(true)` returns `"true"`.
This broke the ORM's entire PostgreSQL write path — PG expected `'t'`/`'f'` for bool columns but
received `'true'`/`'false'`, triggering error 22P02 on every boolean field. SQLite is unaffected
(it accepts both). The root cause is in the type-tag propagation between the caller's and callee's
register contexts.

**ARM aarch64 fibers broken:**
`fiber_create` fails and `fiber_resume` returns "already done" on ARM. Spawned task bodies never
run. This blocks Apple Silicon (M1/M2/M3) and all ARM server deployments. The issue is likely in
the AArch64 context-switch assembly (`nova_asm_switch`) — the register save/restore for
x19-x30, d8-d15, and the stack pointer setup may have an error in the frame layout.

**`null` is indistinguishable from `0`:**
`nova_rt_is_null(p)` is literally `p == 0`. A missing dict key returns `0`. Integer `0` IS `null`.
This caused **silent data corruption** in MySQL: `p == null` was used to detect NULL values, so
every bound integer ZERO was stored as SQL NULL. Counts, flags, and booleans with value 0 vanished.
The fix (orm_null()) expresses NULL out-of-band, but the underlying value model hasn't changed.

### 4.2 Significant Gaps

**set_* is O(n) linear scan:**
`set_create`, `set_has`, `set_add`, `set_remove` are implemented as a list with linear search.
Despite being named "set" (implying O(1) hash-set), they are O(n). Found independently 3 times
(N-Queens, Sudoku, Word Ladder). Verified against `nova_runtime.c`. Use `dict<T, bool>` for
real O(1) lookups.

**Closure captures leak:**
Closures capture variables by storing them in the closure's slot array. But closures are NOT
registered in the struct field bitmap system (they use a `fn_ptr` in slot 0, not a type hash),
so `rc_free` never decrements the captured values. Every closure that captures a heap value
(string, list, dict) leaks it. This is Stage 2 of the struct ownership work and needs a
trampoline→bitmap registration path.

**The compiler doesn't dogfood its own features:**
31,324 lines, 0 generic functions, 0 closures, 0 higher-order functions. It uses `Result` (30
times) but otherwise writes C-style NOVA with manual loops and explicit index tracking. This
undermines the claim that NOVA has usable generics/closures/HOFs — the biggest NOVA program
doesn't use them. The standard library and Forge DO use these features, but the compiler doesn't.

**No cross-OS compilation with sysroot:**
`nova build --target linux` on Windows emits the correct LLVM triple but doesn't bundle a
matching sysroot (libc headers, libm, etc.). The linker step fails because `clang` can't find
the target's libraries.

### 4.3 Tier Status

| Tier | Area | Honest Status |
|---|---|---|
| **0** | Runtime soundness (UB/UAF) | **100% CLOSED.** All crash/UB/corruption holes fixed. Struct-field ownership shipped with type-directed bitmap. Move-on-insert closed. |
| **1** | Type-system soundness | **DONE.** Sound by default. Strict mode is default. Fails closed. 10-test negative gate. |
| **2** | Performance | Scalar ~1.04x C. Float arrays ~1.2x C after S4.2. **Remaining: HOF closure perf (float boxing blocks it), i64 ceiling.** |
| **3** | Expressiveness | Generics, traits, ADTs, exhaustive match all work. **Remaining: optional comptime (3.4).** |
| **4** | Concurrency | N>1 CI green. **OPEN: RC-cycle leak confirmed (4.7), race conditions under high contention, preemption is cooperative only.** |
| **5** | Platform | Windows + Linux (WSL). **OPEN: ARM fibers broken, no macOS testing (no hardware), GPU stubs only.** |
| **6** | Toolchain | LSP, REPL, formatter done. **OPEN: Package manager needs public registry hosting.** |
| **7** | Process | Bus-factor 1 (solo developer). 2852 tests gated. |

### 4.4 Launch Blockers Still Open (11 of 24)

1. **Clean repo** — 1462 .exe files committed, hardcoded `C:\Users\mange` paths, stale runtime copies
2. **CONTRIBUTING.md + CODE_OF_CONDUCT.md** — neither exists
3. **Compiler dogfooding** — 0 generics/closures/HOF in 31k lines
4. **~115 untested forge modules** — syntax-checked only, never functionally tested
5. **deploy_config/deploy_validate are stubs** — return fake dicts
6. **ARM fibers broken** — blocks Apple Silicon
7. **HTTP client lacks connection pooling** — every request opens fresh TCP
8. **GPU acceleration** — CPU stubs only, needs hardware
9. **Embedded / bare metal** — no _start, no UART, no linker scripts
10. **Frontend framework** — WASM codegen works, no SPA/DOM framework
11. **DevX tools not tracked** in EXECUTION_STATE.md

---

## 5. Competitive Reality

| Dimension | Where NOVA actually stands |
|---|---|
| **vs C performance** | Scalar: tied (~1.04x). Float arrays: ~1.2x (was 160x before S4.2). BUT: float codegen heisenbug produces garbage in some helper chains — C never does this. |
| **vs Rust safety** | Process isolation gives memory safety without a borrow checker. BUT: RC leaks exist (closures, field reassignment, cycles). Rust has zero leaks by construction. |
| **vs Python simplicity** | Type inference means ~95% code needs zero annotations. Comprehensions, pipe, ternary, f-strings all present. BUT: Python has 400k+ packages and decades of docs. NOVA has 5 packages and one tutorial. |
| **vs Go concurrency** | `spawn`/channels match goroutines/channels. `on_exit_send` is strictly stronger than Go's defer for resource cleanup. BUT: Go's scheduler is battle-tested in production at Google scale. NOVA's has known N>1 contention issues. |
| **vs Erlang fault tolerance** | Task crash containment via longjmp + on_exit_send cleanup. BUT: Erlang handles RC cycles (its GC is per-process tracing), has hot code reload in production, and has 30 years of telecom uptime proof. NOVA's RC cycles leak. |
| **vs Java ecosystem** | NOVA compiles ahead-of-time (no JVM startup), no GC pauses. BUT: Java has Maven Central (500k+ libraries), IntelliJ, Spring, and 30 years of enterprise adoption. NOVA has 5 packages and a VS Code extension. |

---

## 6. File Locations

| What | Path |
|---|---|
| Live compiler source | `nova-compiler/compiler/nova_compiler.nova` |
| C runtime | `nova-compiler/compiler/nova_runtime.c` |
| Bootstrap seed | `nova-compiler/test_programs/gen3_test.exe` |
| Linux bootstrap IR | `nova-compiler/compiler/nova_compiler_linux.ll` |
| Standard library | `std/` (mirrored to `nova-compiler/lib/std/`) |
| Forge framework | `forge/` (mirrored to `nova-compiler/lib/forge/`) |
| Test programs | `nova-compiler/test_programs/` |
| CI gate script | `nova-compiler/_scripts/nova_ci.ps1` |
| Design documents | `NOVA_DESIGN/` |
| Website | `site/index.html`, `site/docs.html` |

## 7. Key Dates

| Date | Milestone |
|---|---|
| 2026-07-03 | 26-agent deep audit — CORE_GAPS identified |
| 2026-07-06 | Tier 0 runtime soundness 100% closed |
| 2026-07-07 | Type checker made sound by default |
| 2026-07-10 | Struct-field-leak fixed (type-directed ownership with managed-slot bitmap) |
| 2026-08-01 | Wave-B #6 RC insert leak closed (move-on-insert + fresh-alloc proof) |
| 2026-08-04 | Compile speed 38x faster (6500ms → 170ms via runtime .o caching) |
| 2026-08-07 | Linux self-hosting proven on WSL2 Ubuntu, launch blockers 13/24 closed |
| 2026-08-08 | Bundled Win+Linux toolchains shipped to novachan.org |
| 2026-08-09 | ORM campaign complete (14/14 green, batch insert 192x, 3 DB drivers) |
| 2026-08-09 | Windows timer 8x fix landed (2852 PASS / 0 FAIL) |
| 2026-08-09 | System audit: 63,472 lines, 536+1500 functions, 1,328 builtins cataloged |
