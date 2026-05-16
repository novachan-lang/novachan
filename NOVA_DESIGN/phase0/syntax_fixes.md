# Syntax Fixes — Resolving Adversarial Review Issues

**Every fix is checked against: type system, ownership model, process/channel semantics, all 10 programs, all 13 languages we beat, and the "simpler than Python" bar.**

---

## CRITICAL FIXES

### C1 FIX: `->` Ambiguity — Use Different Symbols for Different Purposes

**Problem:** `->` is used for return types, lambdas, AND match arms. Creates real grammar ambiguity.

**Fix:** Separate the three uses with different syntax:

| Purpose | Old Syntax | New Syntax | Rationale |
|---|---|---|---|
| Function return type | `fn add(a, b) -> int` | `fn add(a, b) -> int` | Keep `->` for return types ONLY. This is its most natural meaning and most widely understood (Rust, Swift, Kotlin). |
| Lambda | `x -> x * 2` | `x => x * 2` | Use `=>` for lambdas. Familiar from JavaScript/C#/Scala. Visually distinct from `->`. |
| Match arm | `pattern -> body` | `pattern => body` | Match arms ARE lambdas conceptually (pattern in, value out). Using `=>` is consistent with lambdas and familiar from Scala/Kotlin `when`. |

**Result:** `->` means ONLY "returns type." `=>` means ONLY "maps to / evaluates to" (lambdas and match arms). No ambiguity.

**Verification:**
```nova
// Clear and unambiguous:
fn transform(x: int) -> int          // -> is return type
    match x
        0 => "zero"                   // => is match arm
        n => n.to_string()            // => is match arm

doubled = list.map(x => x * 2)       // => is lambda
```

No collision possible. Parser sees `->` → return type. Parser sees `=>` → lambda or match arm (both parse the same way).

**Impact on programs:** All 10 programs need `->` changed to `=>` in match arms and lambdas. Return types stay `->`. Straightforward find-replace.

**Impact on keyword/operator list:** Add `=>` to operator table. Remove `->` from lambda and match usage.

---

### C2 FIX: `or` Triple Duty — Separate Error Handling from Boolean

**Problem:** `or` is used for boolean OR, error default, AND type union. Compiler can't distinguish `compute(x) or true` — is it boolean OR or error default?

**Fix:** `or` keeps two duties (boolean OR and type union — these never appear in the same context). Error handling gets a different mechanism:

| Purpose | Old Syntax | New Syntax | Rationale |
|---|---|---|---|
| Boolean OR | `a or b` | `a or b` | Keep — it's clean English |
| Type union | `int or Error` | `int or Error` | Keep — only appears in type expressions, never ambiguous with boolean |
| Error default | `try_thing() or default` | `try_thing() else default` | Use `else` as the error-default operator when after an expression |

Wait — `else` is already used with `if`. Let me think more carefully.

Actually, the REAL issue is: how does the compiler know whether `compute(x) or true` is boolean OR vs error default?

The answer is **type-based**: if `compute(x)` returns `Result<bool, Error>` (a sum type), then `or` unwraps the result. If it returns `bool`, then `or` is boolean OR. The type inference engine determines this BEFORE the expression is evaluated.

But the devil's advocate pointed out a real edge case: what if `compute(x)` returns `bool or Error`? Then `compute(x) or true`:
- If boolean OR: `compute(x)` must be `bool`, `true` is `bool`, result is `bool`
- If error default: `compute(x)` is `bool or Error`, `true` is the fallback, result is `bool`

Both are type-valid. The compiler cannot pick one.

**REAL Fix:** Make error handling use a DIFFERENT keyword. Not `or`.

| Purpose | Syntax | Meaning |
|---|---|---|
| Boolean | `a or b` | Boolean OR |
| Type union | `int or Error` | Sum type (in type expressions only) |
| Error default | `try_thing() else default` | If left side is an error, use right side |

But `else` after an expression is unusual... Let me think about alternatives.

Actually, the cleanest solution: use `?` for error propagation and `else` for defaults.

NO — we decided against `?` and `??` earlier because they're symbolic and less readable.

Let me look at what other languages do:
- Swift: `try thing ?? default` (`??` is nil-coalescing)
- Kotlin: `thing ?: default` (Elvis operator)
- Rust: `thing.unwrap_or(default)` (method call)

The most READABLE option for NOVA:

```nova
config = read_file("config.txt") else "{}"
port = parse_int(env("PORT")) else 8080
```

`else` after an expression means "if the expression fails/returns error, use this instead." This reads like English: "read the file, else use this default."

**Does `else` conflict with `if/else`?** No. `if/else` uses `else` at the START of a line (after an `if` block). Error-default `else` appears INLINE after an expression. The parser can distinguish because:
- `if ... else ...` — `else` follows an `if` block (indentation-based)
- `expr else default` — `else` follows an expression on the same line

These are syntactically distinct.

**Verification:**
```nova
// Boolean OR — clear
flag = a or b

// Type union — clear (only in type expressions)
fn read(path) -> string or Error

// Error default — clear
config = read_file("config.txt") else "{}"
port = parse_int(env("PORT")) else 8080

// No ambiguity!
result = compute(x) or y      // always boolean OR
result = compute(x) else y    // always error default
```

**Impact on programs:** Replace `or` with `else` in error-default contexts (Programs 4, 5, 9, 10). Keep `or` for boolean and type unions.

**Impact on keyword list:** No new keyword needed — `else` already exists. But its usage expands.

---

### C3 FIX: Indentation + Single-Line Forms + Lambdas — Restrict Single-Line Rules

**Problem:** `list.map(x => if x > 0 x else -x)` is ambiguous for an indentation-based parser.

**Fix:** Single-line forms are restricted:

**Rule 1:** Single-line `if` ONLY works as an expression (returns a value), and ONLY when it has BOTH `if` and `else`:
```nova
result = if x > 0 x else -x          // OK — complete if/else expression
if x > 0 print("yes")               // NOT ALLOWED — use indented block
```

**Rule 2:** Lambdas inside function call arguments are always delimited by the outer parentheses:
```nova
list.map(x => x * 2)                 // OK — lambda ends at )
list.map(x => if x > 0 x else -x)   // OK — lambda ends at ), if/else is complete
list.filter(x => x > 0)              // OK
```

**Rule 3:** Multi-expression lambdas use indented blocks:
```nova
list.map(x =>
    validated = validate(x)
    transform(validated)
)
```

**Rule 4:** Single-line function bodies are restricted to single expressions:
```nova
fn double(x) x * 2                   // OK — single expression
fn max(a, b) if a > b a else b       // OK — if/else expression
fn complex(x)                        // Multi-line — use block
    step1 = prepare(x)
    process(step1)
```

**Verification against parser:** The parser always knows where a lambda body ends: either at `)` (inline in function call), or at DEDENT (block lambda). `if/else` expressions are complete when both branches are present. No ambiguity.

**Impact:** Programs 3 and 4 need minor restructuring where single-line `if` statements (not expressions) are used.

---

### C4 FIX: `serve` Block — Defined as Library Function, Not DSL Magic

**Problem:** `serve(8080)` with `get`, `post` routes looks like domain-specific magic with undefined semantics.

**Fix:** `serve` is a standard library function that takes a handler function. Routes are defined with stdlib functions, not magic DSL:

```nova
import http

serve(8080, routes =>
    routes.get("/", req => "Hello, World!")
    routes.get("/users/{id}", req => find_user(req.param("id")))
    routes.post("/users", req => create_user(req.body))
)
```

**How this works semantically:**
- `serve(port, handler_fn)` is a function in `nova.http`
- It spawns a process that listens on the port
- `routes` is a route builder value passed to the handler function
- `routes.get(pattern, handler)` registers a GET route
- `req` is the request value — explicitly received, not magic
- The handler lambda returns the response value

**No special syntax.** Just functions, lambdas, and values. The Three Primitives model handles everything:
- The server is a **Process** (spawned by `serve`)
- Each request is a **Value** flowing through a **Channel** (HTTP connection)
- Route handlers are **Values** (functions) that transform request values into response values

**Verification:**
- No DSL magic ✓
- `request` is explicitly named as `req` parameter ✓
- Routes are function calls, not keywords ✓
- Still concise: 6 lines vs Python/Flask's 14 ✓
- Works with NOVA's type inference: `req` type inferred from `routes.get` signature ✓
- Everything is expressible with existing syntax rules ✓

---

## SERIOUS FIXES

### S1 FIX: Add `continue` Keyword

**Problem:** No way to skip to next loop iteration without nesting.

**Fix:** Add `continue` keyword.

```nova
for item in list
    if should_skip(item)
        continue
    process(item)
```

**Impact on keyword count:** 22 tokens (was 21). Still below Go (25), Python (35), Rust (39).

**Updated keyword list:**
```
fn    return   if    else    for    match   break   continue
type  enum     spawn send    receive channel
or    and      not   copy    import  supervise
true  false
```

---

### S2 FIX: Named Arguments — Use `=` Not `:`

**Problem:** `:` is used for both type annotations and named arguments, creating ambiguity.

**Fix:** Named arguments at call sites use `=`, type annotations use `:`.

```nova
// Type annotation (definition) — uses :
fn serve(port: int, host: string)

// Named argument (call site) — uses =
serve(port = 3000, host = "0.0.0.0")
```

**Why this works:** `=` at a call site can ONLY mean named argument. It can't be assignment (you can't assign inside a function call). `:` at a definition can ONLY mean type annotation. No ambiguity.

**Precedent:** Python uses `=` for keyword arguments: `func(key=value)`. Familiar.

---

### S3 FIX: `for condition` — Replace with `while` or Define Formally

**Problem:** `for x > 0` replacing `while` is undocumented and ambiguous.

**Fix:** Actually add `while` back. The cost of one keyword is less than the confusion of overloading `for`.

```nova
// Iteration — for
for item in list
    process(item)

// Condition loop — while
while connection.is_alive()
    msg = receive(connection)
    handle(msg)
```

`for` = iterate over collection. `while` = loop on condition. One purpose each. No ambiguity. Every developer in the world knows this distinction.

**Impact on keyword count:** 23 tokens (was 22 after adding `continue`). Still below Go (25).

**Updated keyword list:**
```
fn    return   if    else    for    while   match   break   continue
type  enum     spawn send    receive channel
or    and      not   copy    import  supervise
true  false
```

---

### S4 FIX: Assignment vs Send — Clarify the Model

**Problem:** Assignment is "always copy" but `send` is "move." Seems contradictory.

**Fix:** This is actually not contradictory. Let me write the precise rules:

**Rule: `=` creates a logical copy. `send` transfers ownership.**

```nova
x = [1, 2, 3]
y = x              // y is an independent copy of x (compiler may optimize to COW)
                    // BOTH x and y are usable

send(ch, x)         // x is transferred to the channel
                    // x is NO LONGER usable (compile error if used after this line)
                    // y is STILL usable (it's independent)

send(ch, copy(x))   // a copy of x is sent; x is STILL usable
```

**The clear rule:**
- `=` — copy (both sides live independently)
- `send` without `copy` — move (sender loses the value)
- `send` with `copy` — copy-and-send (sender keeps a copy)

These are NOT contradictory. `=` is always copy. `send` is always move (unless wrapped in `copy`). They're different operations with different semantics. The compiler optimizes `=` copies to COW/move when the original isn't used, but the SEMANTICS are always "copy."

This is now explicitly documented. No contradiction.

---

### S5 FIX: Match Arms Already Fixed by C1

Match arms now use `=>` instead of `->`. No conflict with return type `->`.

```nova
fn process(input) -> Result
    match input
        valid => transform(valid)     // => is match arm
        Error(e) => handle(e)         // no confusion with ->
```

Fixed by C1.

---

### S6 FIX: Closure Capture Semantics — Capture by Value

**Problem:** Closures capturing mutable state could violate process isolation if sent through channels.

**Fix:** Closures capture by VALUE (copy). If the closure is sent to another process, it carries its own copy of captured values.

```nova
counter = 0
increment = () => counter + 1    // captures a COPY of counter (which is 0)
counter = 5                       // doesn't affect increment's captured copy
print(increment())                // prints 1, not 6

// Sending closure to another process:
send(ch, increment)               // safe — closure carries its own copy of counter
```

**If you need mutable shared state:** Use a process + channel (the NOVA way):

```nova
fn make_counter()
    ch = channel()
    spawn
        count = 0
        while true
            receive(ch)
            count += 1
            send(ch, count)
    ch

counter_ch = make_counter()
send(counter_ch, "increment")
value = receive(counter_ch)       // 1
```

This is the process model — shared mutable state is managed through message passing, not shared references.

**Verification:**
- Process isolation maintained ✓ — closures carry copies, not references
- Matches copy semantics ✓ — capture is like assignment, which is copy
- Simple mental model ✓ — what you captured is what you have
- Beats Python ✓ — Python's late-binding closures are a known footgun; NOVA captures immediately by value
- No annotations needed ✓

---

### S7 FIX: @low_level Closures Escaping — Rewrite the Pattern

**Problem:** Program 9's ring buffer returns closures that capture raw pointers from @low_level, violating the "raw pointers can't escape" rule.

**Fix:** Rewrite Program 9 to use a safe wrapper properly:

```nova
type RingBuffer
    _handle: int    // opaque handle, not a raw pointer

fn ring_buffer(capacity) -> RingBuffer
    @low_level
        buffer = alloc(capacity)
        handle = register_buffer(buffer, capacity)   // runtime tracks the raw pointer
    RingBuffer { _handle: handle }

fn push(rb: RingBuffer, byte)
    @low_level
        buffer_push(rb._handle, byte)    // runtime looks up the raw pointer by handle

fn pop(rb: RingBuffer) -> byte else Error
    @low_level
        buffer_pop(rb._handle) else Error("empty")

fn free_buffer(rb: RingBuffer)
    @low_level
        buffer_free(rb._handle)

// Usage — clean API, no raw pointers escape
rb = ring_buffer(1024)
push(rb, byte(0x42))
value = pop(rb) else byte(0)
free_buffer(rb)
```

**The pattern:** Raw pointers are converted to opaque handles inside `@low_level`. Handles are safe values (integers) that CAN leave `@low_level`. Runtime maintains a table: handle → raw pointer. Low-level functions look up the pointer by handle.

This is how operating systems work (file descriptors are handles to kernel resources). It's proven and safe.

**Verification:**
- No raw pointers escape `@low_level` ✓
- Opaque handles are safe values (Sendable? NO — they're local handles. Compiler derives NOT Sendable because they reference process-local resources) ✓
- The handle pattern is familiar (file descriptors, window handles, GPU buffer handles) ✓

---

### S8 FIX: Keyword Count — Honest Count

Updated keyword list after all fixes: 23 keywords

```
fn      return    if      else     for      while
match   break     continue type    enum     spawn
send    receive   channel  or      and      not
copy    import    supervise true   false
```

**23 keywords.** Go has 25. Python has 35. Rust has 39. Java has 50. C++ has 90+.

Honest count. No exclusions.

---

## CONCERN FIXES

### N1 FIX: String Escaping and Raw Strings

```nova
// Regular strings with interpolation
greeting = "Hello {name}"

// Escape braces with backslash
literal_braces = "JSON: \{\"key\": \"value\"\}"

// Raw strings (no interpolation, no escaping) — backtick
regex = `\d+\.\d+`
sql = `SELECT * FROM users WHERE name = 'Alice'`

// Multiline strings — triple quotes
doc = """
    This is a multiline string.
    Indentation relative to closing quotes is preserved.
    Interpolation works: {name}
    """

// Multiline raw string
template = ```
    No {interpolation} here.
    All literal text.
    ```
```

**Escape sequences:** `\n` (newline), `\t` (tab), `\\` (backslash), `\"` (double quote), `\{` (literal brace), `\0` (null byte).

---

### N2 FIX: Comment Syntax

```nova
// Single-line comment

/* 
   Multi-line comment
   Can span multiple lines
*/

/// Documentation comment (attached to next declaration)
/// Supports markdown formatting
fn important_function()
    // ...
```

Three forms. `//` for inline, `/* */` for blocks, `///` for documentation. Standard across C-family languages.

---

### N3 FIX: Import Syntax — Reduce to Two Forms

**Old:** Four import forms (violates "one way").

**New:** Two forms only:

```nova
import http                        // import module — access as http.get, http.post
import http { get, post }          // import specific items — access as get, post
```

- No `from` keyword (removed — saves a keyword slot)
- No `as` aliasing (use a variable: `m = math` if you need an alias)
- Two forms is acceptable: "import everything" vs "import specific things" are genuinely different needs

**Destructuring uses `{}` but only in import context.** No ambiguity with structs because imports are only at file top-level.

---

### N4 FIX: `supervise` — Specify as Function, Not Magic Keyword

**Problem:** `supervise` is the only keyword with named-argument-style parameters. It's a special case.

**Fix:** Make `supervise` a function, not a keyword. Remove from keyword list.

```nova
supervise(http_pool, restart = "always", max_restarts = 5, within = 60)
```

This is a stdlib function in `nova.process`. Uses regular named arguments (with `=`). No special syntax.

**Impact:** Keyword count drops to 22.

**Updated keyword list:**
```
fn      return    if      else     for      while
match   break     continue type    enum     spawn
send    receive   channel  or      and      not
copy    import    true     false
```

**22 keywords.** Still below Go (25).

---

### N5 FIX: Generic Function Call Syntax — Use Turbofish

When inference can't determine the type, use `::<T>` (Rust-style turbofish):

```nova
empty_list = List::<int>()
parsed = parse::<json>(text)
```

The `::` before `<>` removes ambiguity with comparison operators:
- `f(a < b, c > d)` — two boolean arguments ✓
- `f::<int>(x)` — generic function call ✓

No collision. Turbofish is ugly but unambiguous, and it's rarely needed (inference handles most cases).

---

### N6, N7, N8, N9, N10: Minor program adjustments needed when rewriting.

---

## ADDITIONAL FIXES

### Missing `**` Operator

Add power/exponent operator `**` to the operator table (used in Program 3):
- Precedence: between unary and multiplication (level 2.5)
- Right-associative: `2 ** 3 ** 2` = `2 ** 9` = `512`

### Missing Tuple Specification

Tuples are comma-separated values in parentheses:
```nova
point = (1.0, 2.0)              // type: (float, float)
triple = (1, "hello", true)     // type: (int, string, bool)
single = (42,)                  // trailing comma for 1-tuple (otherwise it's just parenthesized expression)
```

Destructuring:
```nova
(x, y) = point
(a, _, c) = triple              // _ ignores the second element
```

### `if/else` as Expression

`if/else` IS an expression that returns a value:
```nova
result = if x > 0 x else -x          // expression form (single line)
max_val = if a > b a else b
```

`if` WITHOUT `else` returns the type's zero value... NO. That's implicit and dangerous.

**Rule:** `if` as expression REQUIRES `else`. `if` as statement (no assignment, no return) does NOT require `else`.
```nova
// Statement — else optional
if error
    log("something went wrong")

// Expression — else required (compile error without it)
result = if x > 0 x else -x
```

### `for` and `match` as Expressions

`for` as expression returns a List (collects results):
```nova
doubled = for x in list
    x * 2
// doubled is [2, 4, 6, ...]
```

`match` as expression returns the matched arm's value:
```nova
label = match status
    200 => "OK"
    404 => "Not Found"
    _ => "Unknown"
```

Both return values when used in assignment. When used as statements (no assignment), return value is ignored.

---

## UPDATED SUMMARY

| What Changed | Old | New |
|---|---|---|
| Lambda/match arm operator | `->` | `=>` |
| Return type operator | `->` | `->` (unchanged, now unambiguous) |
| Error default | `or` | `else` (after expression) |
| Boolean OR | `or` | `or` (unchanged) |
| Type union | `or` | `or` (unchanged) |
| Named arguments at call | `key: value` | `key = value` |
| While loop | `for condition` | `while condition` |
| `continue` keyword | missing | added |
| `supervise` | keyword | stdlib function |
| Serve/routes | DSL magic | stdlib function with lambdas |
| Closures | unspecified | capture by value (copy) |
| @low_level escape | closures with raw ptrs | opaque handles |
| Comments | unspecified | `//`, `/* */`, `///` |
| Strings | only `"..."` | `"..."`, backtick raw, `"""..."""` multiline |
| Generics call | unspecified | turbofish `::<T>` |
| Import | 4 forms | 2 forms |
| Keyword count | 21 (mislabeled 19) | 22 |
