# NOVA Language Feature Reference

This is the authoritative catalog of NOVA's high-level features. Write NOVA from THIS toolkit by default — reach for the highest-level construct that fits, not hand-rolled if/else + index loops + any+type_of. Every example here was verified against the live parser/stdlib.

Sourced from a multi-agent feature audit (242+ raw entries) deduplicated into the sections below. When two constructs overlap, the entry lives in its most natural home and is cross-referenced rather than repeated.

**PART I — Coding Features (sections 1–19):** everything you use when writing `.nova` code.
- **Sections 1–5:** Core language (syntax, collections, types, concurrency, annotations) — original audit (2026-07-25), verified correct.
- **Section 6:** Features added since the original audit, each verified by EXECUTING a probe program; where sections 1–5 disagree, section 6 wins.
- **Section 7:** TRAPS — read before writing NOVA; every item cost real debugging time.
- **Sections 8–18:** Extended features (data structures, iterators, systems, crypto, networking, process, logging, testing, tensors, hot reload, annotations) — added 2026-08-07.
- **Section 19:** Compiler intelligence — what's optional (13 items), what the compiler does automatically (24 items), syntactic sugar (14 items), what doesn't exist (13 items), and complete best practices summary.

**PART II — Toolchain & CLI (sections 20–21):** compiler commands and dev tools, NOT language syntax.

> **MAINTENANCE RULE: a new language feature goes into this file in the SAME COMMIT that lands
> it.** A feature nobody wrote down is a feature nobody reaches for, so it stays untested and
> rots. Generics sat effectively unused for a year behind a syntax nobody could guess.

---

## Quick Reference — the constructs you reach for constantly

| Feature | Syntax | One-line example |
|---|---|---|
| String interpolation | `"...{expr}..."` | `print("Hello, {name}!")` |
| Format spec | `"{expr:spec}"` | `"{n:04d}"  // "0007"` |
| List comprehension | `[E for x in xs if C]` | `[x * 2 for x in items]` |
| Dict comprehension | `{K: V for x in xs}` | `{str(n): n * n for n in nums}` |
| map / filter / reduce | `xs.map(f)` / `xs.filter(p)` / `xs.reduce(f, init)` | `xs.map(fn(n) n * 2)` |
| Pipe | `v \|> f \|> g` | `[1,2,3,4,5] \|> filter(fn(x) x > 2) \|> map(fn(x) x * 10)` |
| Lambdas / closures | `fn(x) E` · `\|x\| E` · `x => E` | `map(items, \|x\| x * 2)` |
| match | `match e` then `PAT => body` arms | `match shape` → `Circle(r) => 3.14159 * r * r` |
| Ternary | `A if C else B` | `"big" if x > 3 else "small"` |
| Result + try (`?`) | `expr?` | `let v = safe_divide(a, b)?` |
| Option + coalesce (`??`) | `opt ?? default` | `find_user(1)?.age ?? -1` |
| with / else | `with p <- e ...` + `else err ...` | `with a <- f(s1), b <- f(s2)` |
| Spread | `[...a, ...b]` · `{...base, k: v}` | `let c = [...a, ...b]` |
| for-in destructuring | `for a, b in xs` | `for i, val in items` |
| Range (exclusive) | `LOW..HIGH` | `for i in 0..5` |
| enumerate / zip | `xs.enumerate()` / `xs.zip(ys)` | `let en = ys.enumerate()` |
| Named args + defaults | `f(name: v)` · `p = default` | `greet(greeting: "Yo", name: "Eve")` |
| UFCS chaining | `x.fn(args)` | `xs.filter(...).map(...)` |
| Struct + auto show/json | `type T` then `print(t)` | `print(Point(3,4))  // Point { x: 3, y: 4 }` |
| enum ADT + destructure | `enum T` + `match` | `Circle(2.0)` matched by `Circle(r) => ...` |
| Generics | `fn <T> name(x: T) -> T` | `fn <T> identity(x: T) -> T` |
| spawn | `spawn fn() ...` | `let f1 = spawn fn(z) basic_entry()` |
| channel / send / receive | `channel()` · `send(ch,v)` · `receive(ch)` | `send(ch, 42)` |
| sort_by | `xs.sort_by(keyfn)` | `let asc = xs.sort_by(fn(x) x)` |
| any_match / all_match | `xs.any_match(pred)` | `xs.any_match(fn(x) x > 8)` |
| sum / min / max | `xs.sum()` · `min(xs)` · `max(xs)` | `nums.sum() == 15` |
| contains / in | `x in coll` · `coll.contains(x)` | `if s.contains("fox")` |
| where clause | `E where a = e1, b = e2` | `let r = x * y where x = 6, y = 7` |
| group_by | `fg_group_by(keyfn, xs)` | `fg_group_by(fn(x) x % 3, [1,2,3,4,5,6])` |
| memo | `fn f(n) -> int memo` | `fn fib(n: int) -> int memo` |
| else fallback | `expr else default` | `let port = parse_int_safe(env("PORT")) else 8080` |
| `-> T or E` | `fn f() -> T or Error` | `fn push(rb, v) -> bool or Error` |
| Lazy iterators | `iter_range \|> iter_filter \|> iter_collect` | `iter_range(0,1000000) \|> iter_take(5) \|> iter_collect()` |
| Priority queue | `pq_create()` / `pq_push` / `pq_pop` | `pq_push(pq, 1, "critical"); pq_pop(pq)` |
| LRU cache | `lru_create(cap)` / `lru_put` / `lru_get` | `lru_put(cache, "k", v); lru_get(cache, "k")` |
| Buffer (string builder) | `buffer()` / `buf_append` / `buf_to_str` | `buf_append(b, name); buf_to_str(b)` |
| Atomic ops | `atomic_new` / `atomic_add` / `atomic_cas` | `atomic_add(counter, 1)` |
| SHA-256 | `sha256(str)` | `let digest = sha256("hello world")` |
| TCP networking | `tcp_listen` / `tcp_accept` / `tcp_recv` | `let client = tcp_accept(listener)` |
| TLS | `tls_connect` / `tls_send` / `tls_recv` | `let fd = tls_connect("api.example.com", 443)` |
| Structured logging | `log_info(tag, msg)` | `log_info("http", "listening on :8080")` |
| Profiling | `prof_start` / `prof_stop` / `prof_report` | `let h = prof_start("parse"); ... prof_stop(h)` |
| Assertions | `assert_eq` / `assert_approx` / `assert_throws` | `assert_eq(fib(10), 55)` |
| Tensors | `tensor_zeros` / `tensor_matmul` / `tensor_softmax` | `let c = tensor_matmul(a, b)` |
| Hot reload | `hot_load` / `hot_sym` / `hot_reload` | `hot_reload(lib); hot_call1(step_fn, world)` |
| `@test` | `@test` on `fn -> bool` | `@test fn t_add() -> bool` |
| `@entity("table")` | ORM annotation | `@entity("users") type User` |
| `nova run` / `nova build` | CLI build commands | `nova run app.nova` / `nova build app.nova` |
| `nova setup` | Pre-compile cache (38x speedup) | Run once after install |

---

## 1. Syntax & control flow

### String interpolation
Syntax: `"text {expr} text"` — any double-quoted string auto-interpolates; the `f"..."` prefix is a pure historical alias, not required.
```nova
let name = "NOVA"
print("Hello, {name}!")
```
Gotcha: escape a literal brace with `\{` / `\}`. Triple-quoted `"""..."""` strings do NOT interpolate.

### Format spec in interpolation
Syntax: `{expr:[[fill]align][0][width][.precision][d|f|s|x|o|b]}` — Python/Rust-style mini-language (`<` `>` `^` align, `0` zero-pad, `.N` precision).
```nova
let n = 7
let r = "{n:04d}"                       // "0007"
let r2 = "Value={n:04d}, Name={name:>8s}"
```
Note: works on index exprs too, e.g. `{items[1]:05d}`.

### List comprehension
Syntax: `[EXPR for VAR in ITER (if COND)?]` — multiple `for` clauses chain (flat-map); `VAR` may destructure as `for (a, b) in pairs`.
```nova
let doubled = [x * 2 for x in items]
let big = [x for x in items if x > 3]
```

### Dict comprehension
Syntax: `{KEY_EXPR: VAL_EXPR for VAR in ITER (if COND)?}`
```nova
let sq = {str(n): n * n for n in nums}
let big = {k: v for (k, v) in d if v > 15}
```

### Set literal & set comprehension
Syntax: `{e1, e2, ...}` (dedups) or `{EXPR for VAR in ITER (if COND)?}`
```nova
let s = {1, 2, 3, 2, 1}          // set_len(s) == 3
let sq = {x * x for x in [1,2,3,4]}
```
Gotcha: empty `{}` parses as an empty DICT, not a set. A literal becomes a set only when the first element has no `:`.

### Ternary if-expression
Syntax: `VALUE_IF_TRUE if COND else VALUE_IF_FALSE` — Python value-first order; chains right-associatively for else-if ladders.
```nova
let label = "big" if x > 3 else "small"
let nested = "A" if x > 10 else "B" if x > 3 else "C"
```

### if / else + else-if chain
Syntax: `if COND` / `else if COND2` / `else` — indentation-delimited (column-based, no braces or `end`).
```nova
if x > 0
    print("pos")
else if x < 0
    print("neg")
else
    print("zero")
```

### One-line if-then(-else)
Syntax: `if COND then STMT (else STMT)?` — all on one source line.
```nova
if x > 0 then return "pos"
if y > 5 then msg = "big" else msg = "small"
```

### if-let
Syntax: `if let PATTERN = expr` (optional `else`) — desugars to a `match`.
```nova
if let Ok(val) = safe_divide(10, 2)
    print(val)
```

### while-let
Syntax: `while let PATTERN = expr` — loops while the pattern matches.
```nova
while let Ok(v) = items[idx]
    process(v)
    idx = idx + 1
```

### unless
Syntax: `unless COND` (optional `else`) — sugar for `if not (COND)`.
```nova
unless x > 10
    result = "small"
else
    result = "big"
```

### until
Syntax: `until COND` — sugar for `while not (COND)`; supports `break`/`continue`.
```nova
until count >= 5
    count = count + 1
```

### loop (infinite loop)
Syntax: `loop` — equivalent to `while true`; exit via `break`/`return`.
```nova
loop
    count += 1
    if count >= 5
        break
```

### for-in loop
Syntax: `for VAR in ITER` — works over lists, ranges, and dicts; column-indented body.
```nova
for i in 0..5
    total = total + i
```

### for-in with index / pair destructuring
Syntax: `for A, B in ITER` — auto-dispatches: over a list gives `index, value`; over a dict gives `key, value`. `for (a, b) in pairs` destructures each element as a tuple.
```nova
for i, val in items          // list: index, value
for k, v in dict_expr        // dict: key, value  (auto-detected)
```

### for-in with inline guard
Syntax: `for VAR in ITER if COND` — filters the body without a nested `if` (this is a statement, not a comprehension).
```nova
for x in items if x > 0
    push(positives, x)
```

### for / else
Syntax: `for VAR in ITER` + `else` — the `else` runs iff the loop completed WITHOUT hitting `break` (including zero iterations).
```nova
for item in items
    if item == target
        return "found"
else
    return "not found"
```

### while / else
Syntax: `while COND` + `else` — the `else` runs iff the loop exits by the condition going false (not via `break`).
```nova
while x > 0
    x = x - 1
    if x == 5
        break
else
    return "completed"
```

### break / continue
Syntax: `break` | `continue` — standard loop control inside `while`/`for`/`loop`/`until`.
```nova
until false
    n = n + 1
    if n == 3
        break
```

### match (statement / expression, or-patterns, guards)
Syntax: `match EXPR` then arms `PAT (| PAT)* (if GUARD)? => body`. Works as both a statement and a value-producing expression. Pattern kinds: `_` wildcard, literals (int/str/`:atom`), a bare var binds, `LOW..HIGH` inclusive range, `Ctor(f1, f2)` constructor destructure, `None`, or-patterns `p1 | p2`.
```nova
let r = match -7
    -10..-1 => "negative"
    0 => "zero"
    _ => "positive"

match shape
    Circle(r) => 3.14159 * r * r
    Rect(w, h) => w * h
    Triangle(a, b, c) => tri_area(a, b, c)
```
Gotcha: constructor patterns bind FLAT identifiers only — no nested destructuring (`Ok(Some(x))` is not one pattern). A bare nullary-variant name in a pattern binds a variable; write `Variant()` / `Variant(_)` to match a zero-payload variant.

### Range expression (exclusive)
Syntax: `LOW..HIGH` — eager list of ints, EXCLUSIVE of the high bound (Python `range()` semantics). There is no `..=` operator.
```nova
for i in 0..5
    total = total + i   // iterates 0,1,2,3,4
```
Gotcha: the range EXPRESSION `0..5` is exclusive, but a match range PATTERN `0..59` is INCLUSIVE — opposite inclusivity, do not conflate. Fully materializes an int64 buffer (not lazy) — for huge ranges use a `while` counter or a `yield` generator.

### Chained comparison
Syntax: `a OP1 b OP2 c ...` (`==` `!=` `<` `>` `<=` `>=`) — desugars to `a<b and b<c and ...`; each middle term evaluated once.
```nova
assert_true(1 < 2 < 3 < 4)
assert_true(not (1 < 2 < 2))
```

### Compound assignment
Syntax: `x += e` `-=` `*=` `/=` `%=` `**=` — desugars to `x = x OP e`.
```nova
count += 1
total += items[idx]
```

### Multi-target destructuring assignment / swap
Syntax: `a, b = expr1, expr2` — RHS evaluated into temporaries first, so `a, b = b, a` is a correct simultaneous swap (no temp needed).
```nova
a, b = b, a   // swap
```

### let-tuple destructuring
Syntax: `let (a, b, ...) = tuple_expr` — use `_` to discard a slot; nesting and mixed types work.
```nova
let (x, y, z) = (100, 200, 300)
let (_, second) = (999, 42)
```

### let comma-list destructuring
Syntax: `let a, b, c = expr` — RHS is treated as a list, positions map 1:1.
```nova
let a, b = [10, 20]
```

### Pipe operator
Syntax: `value |> fn` or `value |> fn(extra_args)` — chainable left-to-right; the piped value becomes the FIRST argument of the RHS call.
```nova
let v = 5 |> double |> square
let v4 = [1,2,3,4,5] |> filter(fn(x) x > 2) |> map(fn(x) x * 10)
let v7 = 3 |> add(4) |> double |> add(1)   // 15
```

### Spread — list / dict / struct-update
Syntax: `[...expr, ...]` (list concat) · `{...expr, "k": v}` (dict merge, later keys win) · `TypeName { ...expr, field: newval }` (immutable record update).
```nova
let c = [...a, ...b]
let overrides = {...base, "color": "blue"}
let p2 = Point { ...p, x: 10 }        // p2.y still equals p.y
```

### 'in' / 'not in' membership
Syntax: `VALUE in COLLECTION` | `VALUE not in COLLECTION` — works on list (membership), dict (keys), string (substring).
```nova
assert(3 in xs, "3 in xs")
assert(6 not in xs, "6 not in xs")
assert("hello" in "hello world", "substr in")
```

### matches operator (regex, boolean)
Syntax: `STRING_EXPR matches "regex_pattern"` — a full infix operator (unrelated to `match` statements).
```nova
assert(response matches "200 OK", "status 200")
```

### Lambdas & closures
Syntax: three interchangeable spellings — `fn(p1, p2) expr` · `|p1, p2| expr` · `ident => expr` / `(a, b) => expr`. Single-expression body; captures outer variables by reference; first-class (can be returned and stored).
```nova
filter(items, fn(x) x > 2)
let doubled = map(items, |x| x * 2)
let inc = x => x + 1
let total = my_reduce(nums, 0, (acc, x) => acc + x)
```
Note: for a multi-statement body, use a named `fn` declaration. Prefer `fn(x) expr` or `|x| expr` in authored code (the bare `ident =>` form is less battle-tested).

### where clause (trailing let-binding sugar)
Syntax: `STMT where name = expr, ...` (single line) or multi-line indented — Haskell-style; bindings are computed first and scoped to the preceding statement only.
```nova
let result = x * y where x = 6, y = 7
let area = width * height where
    width = 10
    height = 20
```

### Triple-quote multi-line string (dedented)
Syntax: `"""..."""` — common leading indentation is stripped.
```nova
let html = """
    <html>
      <body><h1>Hello</h1></body>
    </html>
    """
```
Gotcha: triple-quoted strings do NOT interpolate `{...}`. A triple-BACKTICK block additionally skips all escape processing (useful for embedded SQL/regex/JSON).

### Multi-line collection literals
Syntax: newlines inside `[...]` / `{...}` are transparent, and a trailing comma before the closing bracket is allowed.
```nova
let xs = [
    1,
    2,
    3,
]
```

### import statement
Syntax: `import module/path (as alias)?` — `/`-separated path resolves a stdlib file; default alias is the last path segment.
```nova
import std/numeric/bignum
import forge
import std/encoding/pack as pk
```

---

## 2. Collections, HOF & streams

The builtin higher-order functions below all support BOTH method form `xs.f(...)` (UFCS) and free-function form `f(xs, ...)`, and chain freely.

### map
Syntax: `xs.map(f)` | `map(xs, f)`
```nova
let ys = xs.map(fn(n) n * 2)
```
Note: auto-selects a float-boxing variant when `f` returns float — zero annotation.

### filter
Syntax: `xs.filter(pred)` | `filter(xs, pred)` — keeps elements where `pred(x)` is truthy.
```nova
let evens = [1,2,3,4,5,6].filter(fn(x) x % 2 == 0)
```

### reduce
Syntax: `xs.reduce(f, init)` | `reduce(xs, f, init)` — `f(acc, elem) -> acc`.
```nova
let total = xs.reduce(fn(acc, x) acc + x, 0)
```

### sort / sort_by
Syntax: `xs.sort()` mutates in place (comparator auto-selected by element kind); `xs.sort_by(keyfn)` returns a NEW list (stable merge-sort, key computed once). `sorted(xs)` / `reversed(xs)` are parse-time aliases.
```nova
nums.sort()                      // in place, also returns the same handle
let asc = xs.sort_by(fn(x) x)    // new sorted list
```

### sum
Syntax: `xs.sum()` | `sum(xs)` — float-aware; empty list -> 0.
```nova
nums.sum() == 15
```

### list_min / list_max  (and 1-arg min/max)
Syntax: `list_min(xs)` / `list_max(xs)`; `min(xs)` / `max(xs)` rewrite to these. Two-arg `min(a, b)` / `max(a, b)` is a separate scalar overload.
```nova
if list_min(xs) != 1 or list_max(xs) != 9 : ...
```

### contains  (and `in`)
Syntax: `container.contains(x)` | `contains(container, x)` | `x in container` — generic over list (membership), dict (key), string (substring).
```nova
if s.contains("fox") ...
```

### any_match / all_match
Syntax: `xs.any_match(pred)` / `xs.all_match(pred)` (or free-function forms) — predicate-based existential/universal quantifiers.
```nova
if not xs.any_match(fn(x) x > 8) : ...
```

### any / all (bare, truthy)
Syntax: `any(xs)` / `all(xs)` — free function ONLY.
```nova
let a = any(xs)
```
Gotcha: `xs.any()` / `xs.all()` as METHOD calls FAIL TO LINK (the runtime symbols are `nova_rt_any_truthy` / `_all_truthy`). Always use the free-function form.

### zip
Syntax: `xs.zip(ys)` | `zip(xs, ys)` -> list of `[a, b]` pairs, length = min of the two.
```nova
let z = xs.zip(ys)   // z[0] == [3, 10]
```

### enumerate
Syntax: `xs.enumerate()` | `enumerate(xs)` -> list of `[index, value]` pairs.
```nova
let en = ys.enumerate()   // en[1] == [1, 20]
```

### index_of
Syntax: `xs.index_of(item)` | `index_of(xs, item)` -> int (-1 if absent).
```nova
xs.index_of(4)   // 2
```

### reverse
Syntax: `xs.reverse()` | `reverse(xs)` | `reversed(xs)` — returns a new list.
```nova
rev = xs.reverse()
```

### flatten
Syntax: `xss.flatten()` | `flatten(xss)` — one level only; non-list elements pass through.
```nova
[[1,2],[3],[4,5,6]].flatten()   // 6-element flat list
```

### push / pop / insert / remove
Syntax: `xs.push(v)` · `xs.pop()` · `xs.insert(i, v)` · `xs.remove(v)`. push/insert are void mutators; pop removes+returns last; remove deletes first `== v`, returns 1/0.
```nova
xs.push(3.5)
```

### dict: get / keys / values / items / del
Syntax: `d.get(k, default)` · `d.keys()` · `d.values()` · `d.items()` · `d.del(k)`. `items()` returns list of `[k, v]` pairs.
```nova
for k in freq.keys() : ...
d.del("banana")
```
Gotcha: a missing dict key otherwise reads back as 0 — always use `get(d, k, default)` (or `dict_get_or`) to close that footgun.

### dict_merge (builtin)
Syntax: `a.dict_merge(b)` | `dict_merge(a, b)` — non-mutating; b's keys win.
```nova
let dm = da.dict_merge(db)
```

### hash
Syntax: `hash(value)` — generic structural hash over any value.
```nova
let h = hash(some_value)
```

### Set type (runtime)
Syntax: `set_create()` · `set_add(s, x)` · `set_has(s, x)` · `set_remove(s, x)` · `set_len(s)` · `set_to_list(s)` · `set_from_list(xs)`. This is the opaque hash-set handle that `{...}` set literals/comprehensions build.
```nova
let s = set_create()
set_add(s, 1)
if set_has(s, 1) : ...
```

### range()
Syntax: `range(n)` -> list of ints `[0, n)` — equivalent to `0..n`; eagerly allocated.
```nova
let big = range(1000)
```

### Generators via yield (real lazy streams)
Syntax: any `fn` containing `yield EXPR` is a coroutine. Consume lazily with `for x in f(args)`, eagerly with `gen_collect(f(args))`, or manually with `gen_next(g)` / `gen_value(g)`.
```nova
fn counter() -> int
    let i = 0
    while i < 5
        yield i * i
        i = i + 1
    return 0

for v in counter() : push(collected, v)   // 5 values, last == 16
let g2 = gen_collect(counter())           // g2[2] == 4
```
Note: this is NOVA's true single-pass stream primitive (suspend/resume via real fibers) — unlike map/filter/comprehensions/`..`, which are all eager and fully materialize.

### std/core/seq — sequence pipeline (`import std/core/seq`)
Syntax: `seq_fold(xs, init, f)` · `seq_reduce(xs, f) -> Result` (seeds from xs[0]) · `seq_find(xs, pred) -> Result` · `seq_any/seq_all(xs, pred)` · `seq_count(xs, pred)` · `seq_take/seq_drop(xs, k)` (bounds-clamped) · `seq_zip(a, b)` · `seq_map/seq_filter/seq_reverse` · `seq_flat_map(xs, f)`.
```nova
let total = seq_fold(scores, 0, fn(a, x) a + x)
match seq_find(xs, fn(x) x > 3)
    Ok(v) => v
    Err(e) => -1
```
Note: `seq_flat_map` is the only flat_map in the language (no builtin exists).

### std/core/list — generic list ops (`import std/core/list`)
Syntax: `list_contains(xs, target)` · `list_index_of(xs, target)` · `list_unique(xs)` (first-seen order) · `list_concat(a, b)` · `list_flatten(xss)` · `list_sum(xs)` · `list_chunk(xs, n)`.
```nova
let uniq = list_unique(scores)
let out = list_concat([1,2], [3,4])   // [1,2,3,4]
```

### std/core/dict — dict combinators (`import std/core/dict`)
Syntax: `dict_get_or(d, k, default)` · `dict_keys_where(d, pred)` · `dict_map_values(d, f)` (non-mutating) · `dict_count(d, pred)` · `dict_any_value(d, pred)`.
```nova
dist[g] = dict_get_or(dist, g, 0) + 1
let big_keys = dict_keys_where(scoresByName, fn(v) v >= 90)
```

### std/core/sort — stable non-mutating sorts (`import std/core/sort`)
Syntax: `sort_ints(xs)` · `sort_ints_desc(xs)` · `sort_strings(xs)` · `sort_by(xs, less)` where `less(a, b) -> bool`.
```nova
let sorted = sort_ints(scores)
let asc = sort_by(people, fn(a, b) a.age < b.age)
```
Gotcha: this module's `sort_by` takes a comparator `less(a, b)`, unlike the builtin `sort_by` which takes a keyfn — importing shadows the builtin name in that file. Pick one signature per file.

### std/functional/* — the functional toolkit
Compose pipelines from these instead of hand-writing loops. Note the `(f, xs)` argument order (reversed vs the builtins).

| Module (`import std/functional/...`) | Functions |
|---|---|
| `fmap` | `fm_map(f, xs)` · `fm_map_indexed(f, xs)` · `fm_flat_map(f, xs)` |
| `ffilter` | `ff_filter(pred, xs)` · `ff_reject(pred, xs)` · `ff_partition(pred, xs) -> [kept, rejected]` |
| `freduce` | `fr_foldl(f, init, xs)` · `fr_foldr(f, init, xs)` · `fr_scanl(f, init, xs)` (running accumulator, len+1) |
| `fchain` | `fch_pipe2/3(x, f, g[, h])` · `fch_compose2(x, f, g)` · `fch_apply_all(x, f, g, h)` |
| `faccumulate` | `fa_sum_by(f, xs)` · `fa_product_by(f, xs)` · `fa_max_by_value(f, xs)` · `fa_count_where(pred, xs)` |
| `fgroupby` | `fg_group_by(keyfn, xs)` (global groups) · `fg_partition_by(pred, xs)` (consecutive runs) · `fg_count_by(keyfn, xs)` |
| `fpredicate` | `fpr_all/any/none/count(pred, xs)` · `fpr_find_index(pred, xs) -> int` |
| `fiterate` | `fi_apply_n(f, n, x)` · `fi_iterate(f, x, n) -> [x, f(x), ...]` |
| `fsortby` | `fs_sort_by(keyfn, xs)` · `fs_min_by/fs_max_by(keyfn, xs)` |
| `fzipwith` | `fz_zip_with(f, a, b)` · `fz_zip_with3(f, a, b, c)` · `fz_zip_with_index(f, xs)` |
| `ftakewhile` | `ftw_take_while(pred, xs)` · `ftw_drop_while(pred, xs)` · `ftw_span(pred, xs) -> [taken, dropped]` |
| `func` | `f_identity` · `f_compose(f, g)` · `f_pipe2(f, g)` · `f_const(k)` · `f_apply_n` · `f_memoize1(f)` (return closures) |
| `fcombinator` | `fc_flip(f, a, b)` · `fc_on(f, g, a, b)` · `fc_apply/fc_apply2` · `fc_twice(f, x)` |

```nova
let grouped = fg_group_by(fn(x) x % 3, [1,2,3,4,5,6])
let prefix = ftw_take_while(fn(x) x < 5, [1,3,7,2])   // [1,3]
let sums = fz_zip_with(fn(a, b) a + b, [1,2,3], [10,20,30])   // [11,22,33]
```

### std/itertools/* — the itertools toolkit
| Module (`import std/itertools/...`) | Functions |
|---|---|
| `it_chunk` | `itc_chunk(xs, size)` · `itc_chunk_pad(xs, size, pad)` · `itc_chunk_count` · `itc_evenly(xs, n)` |
| `it_flatten` | `itf_flatten(xss)` · `itf_concat(a, b)` · `itf_concat_all(lists)` · `itf_repeat_concat(xs, n)` |
| `it_group` | `itg_group_consecutive(xs)` · `itg_rle(xs)` · `itg_rle_decode(pairs)` · `itg_run_lengths(xs)` |
| `it_interleave` | `iti_interleave(a, b)` · `iti_intersperse(xs, sep)` · `iti_roundrobin(lists)` · `iti_weave(a, b)` |
| `it_partition` | `itp_split_at(xs, i)` · `itp_partition_parity(xs)` · `itp_halve(xs)` · `itp_split_runs(xs, n)` |
| `it_product` | `itpr_cartesian(a, b)` · `itpr_cartesian3` · `itpr_count` · `itpr_pairs_upper(xs)` (all i<j pairs) |
| `it_rotate` | `itr_rotate_left/right(xs, k)` · `itr_cycle_take(xs, n)` · `itr_reverse(xs)` |
| `it_take_drop` | `itt_take/drop(xs, n)` · `itt_take_last/drop_last` · `itt_slice(xs, start, stop)` · `itt_step(xs, step)` |
| `it_unique` | `itu_unique(xs)` · `itu_count_distinct` · `itu_duplicates(xs)` · `itu_is_unique(xs)` |
| `it_window` | `itw_window(xs, k)` · `itw_pairwise(xs)` · `itw_windows_count` · `itw_triples(xs)` |
| `it_zip` | `itz_zip/zip3` · `itz_unzip(pairs)` · `itz_zip_longest(a, b, fill)` · `itz_enumerate(xs)` |
| `it_accumulate` | `ita_sums(xs)` (prefix sums) · `ita_products` · `ita_maxima/minima` · `ita_diffs(xs)` |
| `itertools` | `it_range` · `it_chain` · `it_zip` · `it_take/drop` · `it_windowed` · `it_chunked` · `it_enumerate` · `it_flatten` · `it_repeat` (self-contained aggregator surface) |

```nova
let rows = itc_chunk([1,2,3,4,5], 2)       // [[1,2],[3,4],[5]]
let pairs = itw_pairwise([1,2,3,4])        // [[1,2],[2,3],[3,4]]
let padded = itz_zip_longest([1,2,3], [10,20], 0)   // [[1,10],[2,20],[3,0]]
let running = ita_sums([1,2,3,4])          // [1,3,6,10]
```
Gotcha: many concepts have multiple implementations (`flatten` exists as a builtin, `list_flatten`, `itf_flatten`, and `it_flatten`). Pick ONE per file to avoid drift.

### std/collections/setops — set algebra over plain lists (`import std/collections/setops`)
Syntax: `set_union(a, b)` · `set_intersection(a, b)` · `set_difference(a, b)` · `set_symdiff(a, b)` · `is_subset(a, b)` · `set_equal(a, b)`. Dedup by `==`, first-seen order preserved; use when you want set semantics but still need list indexing/iteration.
```nova
assert_eq(set_union([1,2,3], [3,4,5]), [1,2,3,4,5])
```

---

## 3. Types, generics & ADTs

### Struct definition
Syntax: `type Name` with indented `field: Type` lines. There is NO `struct` keyword.
```nova
type Point
    x: int
    y: int
```

### Struct construction
Syntax: `Name(v1, v2)` (positional, declaration order) or `Name { field: v, ... }` (order-independent). Functional record update via `Name { ...other, field: newval }`.
```nova
let p = Point(3, 4)
let p2 = Point { x: 3, y: 4 }
let p3 = Point { ...p, x: 10 }   // p3.y == p.y
```

### Field access
Syntax: `obj.field` — erases to a typed struct-slot load when the type is known.
```nova
print(p.x)
```

### Automatic structural show / print / str()
Syntax: zero annotation — every struct prints as `TypeName { f: v, ... }`, recursing into nested fields.
```nova
type Point
    x: int
    y: int
print(Point(3, 4))   // "Point { x: 3, y: 4 }"
```
Gotcha: there is NO `@derive` — using it is a hard compile error. show/serialize/equality/clone are automatic.

### Automatic to_json / from_json / from_json_safe
Syntax: `to_json(x)` / `x.to_json()` · `from_json(dict)` · `from_json_safe(jsonString) -> Result<T, string>` (validates; also auto-gets `from_dict` / `from_dict_list` for DB rows).
```nova
type User
    name: string
    age: int
let j = User("Ann", 30).to_json()
let r: Result<User> = from_json_safe(body)
match r
    Ok(u) => print(u.name)
    Err(e) => print("bad json: " + e)
```
Note: `from_json` defaults missing keys to type-correct zero values instead of crashing.

### Universal structural equality / hash / clone
Syntax: `a == b` (deep field-by-field compare) · `copy(a)` (clone) · `hash(a)` — universal runtime operations, not per-type generated.
```nova
type Point
    x: int
    y: int
assert(Point(1,2) == Point(1,2))
assert(Point(1,2) != Point(1,3))
```

### Struct reflection API
Syntax: `fields(x)` / `field_names(x)` / `field_types(x)` / `field_get(x, "name")` / `type_name(x)` — every struct auto-generates these.
```nova
type Person
    name: string
    age: int
let p = Person("Bob", 30)
for f in fields(p)
    print(f + "=" + str(field_get(p, f)))
```
Note: `type_name(x)` gives the concrete struct name (e.g. "Point"); `type_of(x)` only says "struct".

### any type + runtime type predicates
Syntax: `type_of(x) -> string` · `type_name(x) -> string` · `is_int/is_float/is_string/is_list/is_dict/is_bool/is_struct/is_numeric(x)`. `any` needs no declaration; the compiler widens/narrows automatically.
```nova
let v: any = 5
if type_of(v) == "struct"
    print(type_name(v))   // concrete name, e.g. "Point"
```
Gotcha: `type_of` returns a coarse kind and gives "struct" for ANY struct — dispatch on struct kind with `match`, not `type_of`.

### enum / algebraic sum type (ADT)
Syntax: `enum Name` with `Variant(field: Type, ...)` lines; nullary variants use empty parens or a bare name.
```nova
enum Shape
    Circle(r: float)
    Rect(w: float, h: float)
    Triangle(a: float, b: float, c: float)
```

### enum variant construction
Syntax: `Variant(v1, v2)` or `Variant { field: v }` or `Variant()` for nullary.
```nova
let s = Circle(2.0)
let col = Green()          // nullary variant, MUST include ()
let c2 = Circle { radius: 3.0 }
```
Gotcha: always write `Variant()` to construct a zero-payload variant, and `Variant()` / `Variant(_)` in match arms — a bare name binds a variable instead of matching the tag.

### Exhaustiveness checking on match
Syntax: a `match` over an enum (or Result/Option) that misses a variant and has no `_` arm is a compile error.
```nova
enum Status
    Ok()
    Failed()
fn show(s) -> string
    match s
        Ok(_) => "ok"
        // missing Failed() arm -> compile error: "non-exhaustive match ... missing Failed"
```
Note: this specifically closes the unhandled-`Err(...)` / missing-`None` footgun.

### Result<T, E>
Syntax: `ok(v)` / `err(e)` construct; `is_ok(r)` · `is_err(r)` · `unwrap(r)` · `unwrap_err(r)` · `unwrap_or(r, default)` inspect; match with `Ok(v)` / `Err(e)`. A compiler-native polymorphic sum, not a user enum.
```nova
fn make_triangle(a: float, b: float, c: float)
    if a + b <= c
        return err("degenerate")
    return ok(Triangle(a, b, c))

match make_triangle(1, 1, 5)
    Ok(v) => print("ok")
    Err(e) => print("err: " + e)
```
Note: `unwrap` on an Err panics — observable by `monitor()` / `exit_reason()` if inside a spawned task.

### Option<T> + `T?` sugar
Syntax: `some(v)` / `none()` construct; match with `Some(v)` / `None`. In any type annotation, `T?` means `Option<T>` — the idiomatic spelling.
```nova
fn first_even(xs: list<int>) -> int?
    for x in xs
        if x % 2 == 0
            return some(x)
    return none()

fn describe(v: int?) -> string
    match v
        Some(n) => "got " + str(n)
        None => "nothing"
```

### Result / Option combinator stdlib
Syntax: `import std/core/result` / `std/core/opt` — `result_is_ok/is_err/unwrap_or/unwrap_or_else/map/map_err/and_then(r, f)` · `opt_is_some/is_none/unwrap_or/map/filter(o, f)`. Fluent chaining without hand-writing `match`.
```nova
let r2 = result_and_then(parse_result, fn(v) validate(v))
let doubled_opt = opt_map(some(21), fn(v) v * 2)
```
Gotcha: call these by NAME — `o.map(f)` does NOT work on an Option (`.map` dispatches to the list-map builtin). Use `opt_map(o, f)` / `result_map(r, f)`.

### Generic function
Syntax: `fn <T, U> name(params) -> RetType` — type params go BEFORE the function name (`fn <T> identity(x)`, not after). Implicit polymorphism also works with zero annotation (an unannotated `fn id(x)` is already generic).
```nova
fn <T> identity(x: T) -> T
    return x

fn <T, U> my_map(xs: List<T>, f) -> List<U>
    let result = []
    for x in xs
        push(result, f(x))
    return result
```
Gotcha: the `<T>` list is placed BEFORE the fn name (unlike Rust/TS/Java). Generics are thin/edge-tested across std — the syntax is confirmed, but verify before depending on it deeply.

### Generic function with trait bound
Syntax: `fn <T: TraitName> name(item: T) -> RetType` — ONE bound per type param (no `T: A + B`). Calling with a non-conforming type is a compile error.
```nova
fn <T: Printable> display(item: T) -> string
    return item.show()
```

### Generic struct
Syntax: `type Name<T, U>` with fields referencing the params. No struct-level trait bounds (bare names only).
```nova
type Box<T>
    value: T
```
Note: generic methods over the struct are usually written as free `fn <T> ...` functions. Sparse real usage — verify before depending on it.

### Trait definition (with default method bodies)
Syntax: `trait Name` with `fn sig(...) -> T` lines; a method WITH an indented body is a default (inherited unless overridden), a signature-only method is abstract (required). Traits are not generic.
```nova
trait Describable
    fn name() -> string
    fn describe() -> string
        "I am " + self.name()
```

### Trait conformance
Syntax: `type Name : Trait1, Trait2` on the type line — nominal (explicit), no separate `impl` block. The compiler verifies every required method is implemented.
```nova
type Dog : Describable
    breed: string

fn Dog.name() -> string
    "Dog(" + self.breed + ")"
```
Note: there is no dynamic trait-object type — polymorphism over a trait comes only via `fn <T: Trait>` generics.

### Method definition + UFCS + extension methods
Syntax: `fn Type.method(params) -> Ret` (auto-injects `self: Type`) — sugar for `fn Type__method(self: Type, ...)`. Call as `obj.method(args)`. UFCS also lets `value.free_fn(rest)` call ANY top-level `free_fn(value, rest)`. Naming a fn `<Type>__<method>` adds a method to ANY type including builtins (`int`, `string`, `list`, ...).
```nova
fn User.greet(self) -> string
    "Hello, " + self.name

fn int__double(x: int) -> int
    return x * 2

let r6 = 3.double().double()     // UFCS on a plain free fn, chains
assert(x.double() == 20)         // extension method on int
```
Gotcha: `value.builtin(...)` only links if `nova_rt_<builtin>` is the real symbol (or there's an explicit override). The compiler gives no type error for a bad method-fallback — treat a new builtin-as-method call as unverified until it compiles+links once.

### Multi-clause function with `when` guards
Syntax: repeated same-name/arity `fn name(params) when GUARD` heads, fused post-parse into one guard if/else chain; a final unguarded head is the catch-all.
```nova
fn classify(n) when n < 0
    return "negative"
fn classify(n) when n == 0
    return "zero"
fn classify(n)
    return "positive"
```

### Named function arguments
Syntax: `call(name: value, ...)` — resolve by name, mixable with positional, any order.
```nova
fn greet(name, greeting = "Hello")
    greeting + ", " + name + "!"
greet(greeting: "Yo", name: "Eve")   // "Yo, Eve!"
```

### Default parameter values
Syntax: `fn name(p1, p2 = default_expr)` — default applies when the arg is omitted.
```nova
fn make_point(x, y, z = 0)
    [x, y, z]
```

### Optional parameter sugar (`T?`)
Syntax: `fn name(p: T?)` — equivalent to `p: Option<T>`.
```nova
fn greet(name: string?)
    name ?? "stranger"
```

### Variadic rest parameter (`T...`)
Syntax: `fn name(p: T...)` (trailing param only) — collects trailing args into a `list<T>`, element type unified across all args.
```nova
fn sum_all(xs: int...) -> int
    let total = 0
    for x in xs
        total = total + x
    return total
sum_all(1, 2, 3, 4)   // 10
```

### Type alias (transparent)
Syntax: `type Name = TargetType` — zero-cost synonym, fully interchangeable; alias chains and forward references resolve.
```nova
type Json = dict<string, any>
type Headers = dict<string, string>
```

### Distinct newtype
Syntax: `type Name = distinct TargetType` — a genuinely distinct type (won't unify with the base). Desugars to a single-field struct; `.value` extracts, with automatic construction, `==`, and print.
```nova
type UserId = distinct int
let u = UserId(42)
assert_eq(u.value, 42)
assert_eq(u == UserId(7), false)
```

---

## 4. Concurrency, channels & effects

Process isolation IS memory safety: `spawn` deep-copies captured state into the child, but channel handles inside the copy stay shared so parent/child still communicate. If a program contains no `spawn` anywhere, the compiler erases ALL refcounting overhead (single-process code runs at C speed).

### spawn
Syntax: `spawn EXPR` · `spawn fn(params) <body>` · `let pid = spawn fn() <body>`. Under the default green scheduler each spawn is a cheap cooperative fiber, not an OS thread. Returns an `any` process handle for `monitor()`.
```nova
ch = channel()
spawn fn()
    send(ch, 42)
result = receive(ch)
```

### channel / channel_bounded
Syntax: `channel()` (unbounded, auto-growing MPMC — send NEVER blocks) · `channel_bounded(capacity)` (send back-pressures when full).
```nova
ch = channel()
bc = channel_bounded(2)   // send() parks once 2 items are queued
```
Gotcha: a plain `channel()` never blocks the sender (contrary to some stale docs). Only `channel_bounded(n)` applies back-pressure.

### send
Syntax: `send(ch, value)` — deep-copies value into the RC heap (ownership transfer); auto-optimized to a move when escape analysis proves the sender never reuses it.
```nova
send(ch, 42)
```

### receive / recv
Syntax: `receive(ch)` | `recv(ch)` — blocking receive on an explicit channel handle; green-scheduler-aware (parks the task, no OS thread blocked).
```nova
result = receive(ch)
```

### receive (selective mailbox receive)
Syntax: `receive` + pattern arms `PAT (if GUARD)? => body`, optional trailing `after MS => body`. Operates on the calling task's OWN mailbox; a non-matching message is deferred and retried (true selective receive). `after 0` is a non-blocking drain.
```nova
receive
    {"type": "ping"} => reply("pong")
after 1000 => print("timeout")
```
Note: this is the primitive OTP's gen_server is built from — actors compose from `receive` + `after` + `spawn` + mailbox, no framework.

### recv_timeout
Syntax: `recv_timeout(ch, timeout_ms) -> T` — bounded blocking receive on an explicit channel.
```nova
let v = recv_timeout(ch, 500)
```

### try_recv / try_send
Syntax: `try_recv(ch) -> [got, value]` (got is 1/0) · `try_send(ch, value) -> int` (1 if enqueued, 0 if full/closed). Non-blocking.
```nova
let got_a = try_recv(ch_a)
if got_a[0] == 1
    print(got_a[1])
```

### close
Syntax: `close(ch)` — further sends fail (return -1, set error flag); receives after drain return a signal value.
```nova
spawn fn()
    send(ch, 1)
    close(ch)
```

### select
Syntax: `select(ch1, ch2, ...) -> [index, value]` — variadic; races the channels, returns the index of whichever produced first.
```nova
let result = select(ch1, ch2)
let idx = result[0]
let v = result[1]
```

### select_timeout
Syntax: `select_timeout(ch1, ..., chN, timeout_ms) -> [index, value]` — last arg is a timeout; returns `[-1, 0]` on timeout.
```nova
let r = select_timeout(ch1, ch2, 1000)   // [-1, 0] on timeout
```

### monitor
Syntax: `monitor(pid) -> channel` — returns a channel that receives exactly one message (0 = normal exit, 1 = crashed) when the process finishes.
```nova
pid = spawn fn()
    send(ch, 42)
mon = monitor(pid)
status = receive(mon)   // 0 = normal, 1 = crashed
```

### exit_reason
Syntax: `exit_reason(pid) -> string` — call after `monitor()` signals; "normal" for a clean return, or the panic/unwrap message.
```nova
assert_eq(exit_reason(p1), "boom")     // crashed via panic("boom")
assert_eq(exit_reason(p3), "normal")
```

### panic
Syntax: `panic(message)` — crashes the current task with a message, observable by a monitor's channel and `exit_reason()`. `unwrap()` on Err/None also panics.
```nova
fn crasher()
    panic("boom")
```

### Erlang mailbox API (self_pid / send_msg / recv_msg / ...)
Syntax: `self_pid() -> pid` · `send_msg(pid, msg)` · `recv_msg() -> any` · `mailbox_of(task) -> pid` · `mailbox_len(pid)` · `try_recv_msg() -> [got, value]`. A lower-ceremony messaging surface than explicit channels; a PID is safe to embed inside a message.
```nova
let me = self_pid()
let p = spawn pong()
send_msg(mailbox_of(p), [me, 41])
let reply = recv_msg()
```

### process_link / monitor / demonitor / exit_notify
Syntax: `process_link(a, b)` (bidirectional link — a crash cascades) · `process_monitor(watcher, target)` · `process_demonitor(ref)` · `process_exit_notify(pid, reason)`. Lower-level OTP linking under `monitor()`/`exit_reason()`.
```nova
process_link(pa, pb)
```

### sched_spawn / sched_spawn_on
Syntax: `sched_spawn(fn)` (direct green-task scheduling — what `spawn` delegates to) · `sched_spawn_on(carrier_id, fn)` (pin to a carrier). This is what Forge's HTTP server uses per connection.
```nova
sched_spawn(fn(z) handle_request(conn))
```

### reschedule
Syntax: `reschedule()` — cooperative voluntary yield for a green task. Zero cost to code that never calls it; a CPU-bound task with no I/O should call it periodically to avoid starving siblings.
```nova
while true
    do_cpu_bound_chunk()
    reschedule()
```

### fiber primitives
Syntax: `fiber_create(closure)` · `fiber_yield()` · `fiber_resume(handle)` · `fiber_is_done(handle)` — the raw stackful-coroutine primitive under both `spawn` (tasks) and `yield` (generators). Not normally called directly.

### ws_init / ws_shutdown
Syntax: `ws_init(n_carriers)` / `ws_shutdown()` — bring up / tear down the N-carrier (multi-core, work-stealing) scheduler.
```nova
ws_init(4)
// spawn / sched_spawn now distribute across 4 carriers
ws_shutdown()
```

### async / await
Syntax: `async(fn) -> future` · `await(future) -> T` — a SEPARATE model from spawn: submits to a real OS thread pool and blocks on completion.
```nova
let f = async(fn() 42)
let r = await(f)
```

### await_all / await_any
Syntax: `await_all(list<future>) -> list<T>` (results in input order) · `await_any(list<future>) -> [index, value]` (first to finish).
```nova
let futures = []
push(futures, async(fn() 100))
push(futures, async(fn() 200))
let results = await_all(futures)
```

### pmap / pfilter / pfor
Syntax: `pmap(xs, f) -> list` · `pfilter(xs, pred) -> list` · `pfor(start, end, fn(i))` — data-parallel over the OS thread pool (thread-per-chunk, joined). Order-preserving.
```nova
let doubled = pmap(nums, fn(x) x * 2 + 1)
let evens = pfilter(nums, fn(x) x % 3 == 0)
pfor(0, n, fn(i) process(data[i]))
```

### Distributed transport (remote_*)
Syntax: `remote_connect(host, port) -> conn` · `remote_bind(port) -> listener` · `remote_accept(listener) -> conn` · `remote_send(conn, value)` · `remote_recv(conn) -> T` · `remote_close(conn)`. Real distributed processes over raw TCP; mirrors the local channel vocabulary.
```nova
let listener = remote_bind(port)
while true
    let conn = remote_accept(listener)
    spawn fn(z) handle_peer(conn)
```
Gotcha: use `remote_bind(port)` (single int port). The 2-arg `remote_listen("0.0.0.0", 9000)` form in some tutorials does NOT match the live compiler.

### Distributed RPC (remote_spawn / call_by_name)
Syntax: `remote_spawn(conn, fn_name, args)` runs a NAMED top-level function on a live peer; `call_by_name(fn_name, args)` is the receiving side's dynamic dispatch by string name.
```nova
remote_send(conn, {"type": "spawn", "fn": fn_name, "args": fn_args})
// peer resolves fn_name via call_by_name and replies with the result
```

### Result propagation (`?`)
Syntax: `expr?` — on Ok, unwraps the payload and continues; on Err, immediately returns the error from the enclosing function. Automatically threads context (function name + line) onto the error at every hop.
```nova
fn middle(flag)
    let v = might_fail(flag)?
    return ok(v + 1)
fn outer(flag)
    let n = middle(flag)?
    return ok("got " + str(n))
```
Note: type inference refines the slot to the concrete Ok payload type after `?`, so downstream arithmetic/field access type-checks. Free stack-trace-like context, unlike Rust's bare `?` or Go's `if err != nil`.

### Optional chaining (`?.`)
Syntax: `OPTION_EXPR?.field` | `OPTION_EXPR?.method(args)` — always produces an Option; short-circuits to `none()` if the receiver is none. Chains with `??`.
```nova
let name = u?.name              // Option<User> -> Option<string>
let age = find_user(1)?.age ?? -1
```

### Null-coalescing (`??`)
Syntax: `OPTION_EXPR ?? default` — unwraps `Some(x)` or returns the lazily-evaluated default.
```nova
let s2 = get_score(-1) ?? 42    // none() -> 42
```

### with / else (happy-path Result chaining)
Syntax: `with p1 <- expr1, p2 <- expr2, ...` + mandatory `else errname` — stops at the FIRST Err and runs the else block with the failing error bound. Desugars to nested `match` over Result.
```nova
fn sum2(s1: string, s2: string) -> int
    with a <- parse_int_safe(s1), b <- parse_int_safe(s2)
        return a + b
    else err
        return -1
```
Gotcha: the `else` block is mandatory — omitting it is a compile error.

### try (prefix keyword)
Syntax: `try EXPR` — checks the AMBIENT per-task error flag (set by builtins like `read_file`/`split`/`pop`-on-empty, or by `error()`); re-raises immediately on error, else yields EXPR's value.
```nova
fn load_config() -> string
    let content = try read_file("config.txt")
    content
```
Gotcha: `try`/`catch`/`error` operate on the ambient error flag — a DIFFERENT track from `Result<T,E>` + `?` + `match Err(...)`. (A `?`-propagated error does bridge into the ambient flag, so it's also catchable by an outer `catch`.)

### catch (ambient error handler)
Syntax: `EXPR catch ERRVAR => handler` (single line) or `EXPR catch ERRVAR` + indented block. Intercepts an ambient error raised by the LHS, binding the message string; if the LHS doesn't raise, the value passes through.
```nova
let result = read_file("config.txt") catch e => "default"
let msg = bad() catch e
    e
```

### error (raise)
Syntax: `error(message) -> any` — NOVA's raise/throw; sets the ambient error flag that `try`/`catch` handle. Distinct from `err(e)` (which builds a Result Err value).
```nova
if x < 0
    error("x must be non-negative")
```

### defer
Syntax: `defer EXPR` — schedules EXPR to run at FUNCTION exit (function-scoped, LIFO across every return path).
```nova
fn process_file(path)
    let f = open(path)
    defer close(f)
    let a = read_line(f)
    if a == ""
        return err("empty")   // close(f) still runs
    return ok(a)
```

### unsafe (expr / block)
Syntax: `unsafe EXPR` | `unsafe` + indented block — a lexically-scoped effect permission: raw-memory primitives and `extern` calls (rejected everywhere else) type-check only inside it.
```nova
unsafe
    let p = raw_alloc(64)
    raw_free(p)
```

---

## 5. Declarative, annotations & meta

Annotations wire behavior at compile time (`@name` or `@name("arg")`), emitting ordinary AST — zero runtime reflection.

### @derive is rejected — derivation is automatic
Writing `@derive` is a HARD compile error. Every struct already gets `show` / `to_json` / `from_json` / `from_json_safe` / `from_dict` / `fields` / `field_names` / `field_types` / `field_get` / `type_name` synthesized (unless you define a same-named fn), and `==` / `hash()` / `copy()` are universal structural operations. There is nothing to derive.
```nova
type Person
    name: string
    age: int
    score: float
let p = Person("Alice", 30, 9.5)
field_names(p)   // ["name","age","score"]
print(p)         // "Person { name: Alice, age: 30, score: 9.5 }"
```

### @test — compile-time test discovery
Syntax: `@test` on a `fn -> bool` (zero params). The compiler generates `__nova_run_tests()` that calls every `@test` fn.
```nova
@test
fn t_add() -> bool
    1 + 1 == 2

fn main()
    let passed = __nova_run_tests()
```

### @get / @post / @put / @delete / @patch — declarative HTTP routing
Syntax: `@get("/path")` on a handler `fn(req) -> string`; the compiler injects `__nova_register_routes` wiring into Forge's route API. A quoted path is required.
```nova
import forge

@get("/hello")
fn h_hello(req) -> string
    "HELLO-BODY"

fn main()
    let a = app()
    a = __nova_register_routes(a)
    serve_app(a, 8080)
```

### @memo / bare `memo` — automatic memoization
Syntax: `@memo` above the fn, or a trailing contextual `memo` after the signature. Caches results in a per-fn dict keyed by the args; recursion-safe (deadlock-free).
```nova
@memo
fn fib(n: int) -> int
    if n < 2
        n
    else
        fib(n - 1) + fib(n - 2)

fn fib2(n: int) -> int memo   // equivalent bare form
    if n < 2
        return n
    return fib2(n - 1) + fib2(n - 2)
```

### requires / ensures — design by contract
Syntax: `fn ... requires <bool-expr>` (entry precondition, params in scope) and `fn ... ensures <bool-expr using result>` (checked on EVERY return path; `result` binds the return value). Both are repeatable and order-independent.
```nova
fn safe_div(a: int, b: int) -> int requires b != 0
    a / b

fn abs_val(x: int) -> int ensures result >= 0
    if x < 0
        return 0 - x
    x
```

### static_assert — compile-time assertion
Syntax: `static_assert(<const-bool-expr>[, "msg"])` — evaluated at build time, zero runtime code; a false or non-constant argument fails the BUILD.
```nova
fn main()
    static_assert(1 + 1 == 2)
    static_assert((4 < 8) and (9 >= 9))
    static_assert(1 == 1, "one equals one")
```

### const NAME = expr — compile-time constant with const-fn evaluation
Syntax: `const NAME = <literal | pure-fn-call>` — every use is substituted with the value. Call-rooted initializers run a real comptime tree interpreter (Zig-comptime territory), folding to an int literal; non-int results fall back to a runtime call. A const list literal is baked once and shared by reference.
```nova
fn fib(n: int) -> int
    if n < 2
        return n
    return fib(n - 1) + fib(n - 2)

const FIB20 = fib(20)     // folded to 8040 at compile time
const GLOBAL_K = 7
fn uses_global(n: int) -> int
    return n + GLOBAL_K   // substituted inline
```

### module-level `let CONST = literal` — constant propagation
Syntax: a top-level `let` with a scalar-literal RHS is automatically inlined into every fn that reads it (unless locally shadowed) — no annotation needed.
```nova
let MAX_RETRIES = 3
fn should_retry(n: int) -> bool
    n < MAX_RETRIES   // inlined as 3
```

### module-level `let x = [...] / {...} / channel()` — module singleton state
Syntax: a top-level `let` whose initializer is built purely from literals (or a bare `channel()`) is baked ONCE in the prologue; every fn/lambda shares the ONE handle — a zero-annotation shared config dict / lookup list / channel.
```nova
let registry = {}
fn register(k, v)
    registry[k] = v
```

### @export — C-ABI library export
Syntax: `@export` on a fn — if any fn carries it, the unit becomes a C-callable library (entry renamed to `__nova_export_init`, each `@export` fn emitted as a plain external symbol with NOVA's uniform i64 ABI).
```nova
@export
fn novalib_add(a: int, b: int) -> int
    a + b
```

### extern fn — C FFI declaration
Syntax: `extern fn name(params) -> RetType` — declares a foreign C function; supports `out<T>` out-pointer params. Every extern CALL must be inside `unsafe`.
```nova
extern fn strlen(s: string) -> i64
```

### @opaque — FFI opaque handle type
Syntax: `@opaque` on a field-less `type` — held as `int` in NOVA, marshaled as `ptr` at the boundary.
```nova
@opaque
type FileHandle

extern fn fopen(path: string, mode: string) -> FileHandle
let fp = unsafe fopen("f.txt", "r")
```

### @repr(C) / @repr(packed) / @repr(align(N)) — C-layout struct
Syntax: `@repr(C)` above a `type` — the struct's data pointer is passed to C; C's writes are visible because fields load fresh. `packed` forces packed layout, `align(N)` sets alignment.
```nova
@repr(C)
type Triple
    a: int
    b: int
    c: int

extern fn c_test_fill_triple(t: Triple) -> int
let t = Triple(0, 0, 0)
unsafe c_test_fill_triple(t)
assert_eq(t.a, 1)
```

### @link / @link_source / @link_object — FFI linking
Syntax: `@link("libname")` / `@link_source("file.c")` / `@link_object("file.o")` on an `extern` decl — emitted as link directives the build script passes to clang.
```nova
@link("m")
extern fn sqrt(x: float) -> float

fn main()
    let s = unsafe sqrt(4.0)   // 2.0, links -lm
```

---

## 6. Added since the original audit (2026-07-25 → 2026-08-07)

Every entry below was **verified by executing a probe program**, not inferred from the source.
Sections 1–5 above predate these; this section is authoritative where they disagree.

### 6.1 `EXPR else FALLBACK` — one-word error handling
CLAUDE.md promised this from day one and nothing implemented it; only the `unwrap_or`/`or_else`
*functions* existed. Two forms:
```nova
config = read_file_safe("config.txt") else "\{\}"        // value fallback
port   = parse_int_safe(env("PORT"))  else 8080          // ditto
user   = parse_json(json) else return err("Invalid JSON") // escape form
buffer_push(rb, v) else Error("buffer full")             // as a bare expression statement
```
* Evaluates the subject **exactly once** (unlike `??`, whose shape mentions it twice).
* ⚠️ **Statement level only** — on an assignment RHS or as an expression statement.
  `str(f() else 0)` does **not** parse.

### 6.2 `-> T or E` fallible return type
```nova
fn push(rb: RingBuffer, val: byte) -> bool or Error
```
Desugars to `Result<T, E>`; keeps the failure type visible without generic-bracket ceremony.

### 6.3 Inline if-expression as a function body
```nova
fn max(a: int, b: int) -> int
    if a > b a else b
```
Already worked after `=` and after `return`; now also works when a statement *starts* with `if`.

### 6.4 Tuple patterns in `match` arms
```nova
match (a, b)
    (0, 0) => "origin"
    (x, 0) => "on x-axis"
    (x, y) => "general"
```

### 6.5 Multi-line lambda in argument position
```nova
http.serve(8080, routes =>
    routes.get("/health", req => ok_json(...))
    routes.get("/data", req =>
        let data = fetch(req) else return not_found()
        ok_json(data)
    )
)
```
Lifted into a nested named function, so it **captures** the enclosing scope. Nesting works.

### 6.6 Named arguments accept `=` as well as `:`
```nova
supervise(w, restart = "always", max_restarts = 5)   // both spellings work
supervise(w, restart: "always", max_restarts: 5)
```

### 6.7 Sized numerics — now actually usable
```nova
let a = 255u8 + 1        // 0    wraps at width
let b: u8  = 300         // 44   the ANNOTATION narrows (const and runtime alike)
let c = u8(x)            // explicit conversion; the RESULT carries the width
```
Mixing two explicit widths (`u8` vs `i32`) is a **type error** — convert explicitly.

### 6.8 Real `f32`
```nova
16777217.0f32            // 16777216.0  — the nearest binary32 value
0.1f32 + 0.2f32          // 0.300000011920929   (f64 gives 0.3)
1.0f32 / 3.0f32          // 0.333333343267441   (f64 gives 0.333333333333333)
let x: f32 = 16777217.0  // narrows
f32(v) / f64(v)          // explicit conversion
```
Rounds after **every** operation — genuine IEEE binary32, not f64 wearing a label. `f32` vs
`f64` is a type error; both float widths are explicit.

### 6.9 Packed typed arrays — `std/collections/typedarray`
```nova
import std/collections/typedarray
let a = unwrap(ta_new(ta_u8(), 1000))     // 1000 BYTES, not 8000
let b = unwrap(ta_of_list(ta_i32(), [1,2,3]))
unwrap(ta_map(b, x => x * 2))             // closures, staying packed
unwrap(ta_filter(b, x => x % 2 == 0))
ta_fold(b, 0, (acc, v) => acc + v)
unwrap(ta_at(b, 99))                      // Result — err() on out of range
json_stringify(b)                         // [1,2,3] — a real JSON array
b[1:3]                                    // a NEW same-kind packed array
```
Kinds: `ta_i8 ta_u8 ta_i16 ta_u16 ta_i32 ta_u32 ta_i64 ta_u64 ta_f32 ta_f64`.
Float elements use the float-typed accessors: `ta_atf` / `ta_putf` / `ta_pushf` / `ta_sumf`.

**`T[]` annotation sugar** — the natural way to build one:
```nova
let xs: u8[]  = [1, 2, 3, 300]   // 4 BYTES; 300 narrows to 44
let ws: i16[] = [1000, -1000]    // 4 bytes
let ds: i32[] = [10, 20, 30]     // 12 bytes; ds[1] == 20; json_stringify -> [10,20,30]
let fs: f64[] = [1.5, 2.25]      // 16 bytes; ta_sumf -> 3.75
```
Element types: `i8 u8 i16 u16 i32 u32 i64 u64 f32 f64`. The annotation says what the binding IS,
so the initialiser is converted to it — the same shape as `let x: u8 = 300` narrowing to 44. A
plain `list` annotation is unaffected.

### 6.10 Crash-safe cleanup — `on_exit_send` / `cancel_on_exit_val`
```nova
let db = recv(pool)
on_exit_send(pool, db)        // released even if this task dies by a contained crash
...
send(pool, db)
cancel_on_exit_val(pool, db)  // normal path releases eagerly and cancels
```
Needed because **`defer` is compile-time**: it inlines at the function's exit points, so a panic
longjmps straight past it. This registry is drained on *every* exit path.

### 6.11 Struct-by-value FFI — `byval<T>`
```nova
extern fn vec2_sum(v: byval<Vec2>) -> float        // parameter by value
extern fn make_v2(k: float) -> byval<Vec2>         // RETURN by value
```
Lowered per target (Win64 / SysV / AAPCS64) to exactly the signature clang emits. A plain
`@repr("C")` parameter keeps its original meaning — pass the heap **pointer**, so C can write
through it and NOVA reads the result back. Two different C signatures, two different spellings.

### 6.12 `unsafe` block yields its value
```nova
fn f(n: int) -> int
    unsafe
        let a = n * 2
        a + 1              // the block's value is the function's value
```

---

## 7. TRAPS — verified, each cost real debugging time

### Trap 0 — A LOCAL NAMED AFTER A BUILTIN, USED IN A COMPREHENSION  (FIXED 2026-08-05)

```nova
let items = ["a", "b", "c"]
print([items[i] for i in 0..3])     // was: [0, 0, 0]   -- NOT ["a","b","c"]
```

A comprehension DESUGARS TO A LAMBDA. Lambda capture used to drop any free variable whose name
matched one of NOVA's ~1328 registered builtins — and those include ordinary nouns you would
naturally pick for a variable: `items`, `args`, `chars`, `buffer`, `fields`, `line`, `value`,
`key`, `data`, `text`, `count`, `input`, `output`, `index`, `total`. The closure body then
resolved the name to the BUILTIN, and the comprehension silently produced zeros. No error, no
crash, wrong data. It shipped into `std/textlayout/textcolumns.nova` and blanked every column.

FIXED in `filter_captures` (nova_compiler.nova): a LOCAL now shadows a global, as it always
should have. If you are on an older compiler, rename the local.

To list the reserved-in-practice names:
```
grep -oE 'reg\["[a-z_0-9]+"\]' nova-compiler/compiler/nova_compiler.nova | sed 's/reg\["//;s/"\]//' | sort -u
```

WHY IT MATTERS BEYOND THIS BUG: `_hlcheck.sh` compiled the broken file clean, because the
affected function's parameters were untyped (`any`) so the checker never saw a mismatch. Only a
BEHAVIOUR DIFF caught it. **Compiling is not passing.**


1. **`fn name<T>(...)` does not parse.** Type parameters come **first**: `fn <T> name(...)`.
   Inside a MODULE the wrong form fails **silently and truncates that module's exports** — every
   function defined after it becomes invisible to importers, with no error naming the cause.
   This is very likely why generics went years effectively unused.

2. **⚠️ OPEN BUG — `@comptime` folds to 0 when the body ends in a BARE EXPRESSION.**
   ```nova
   @comptime
   fn size() -> int
       return 16 * 4      // 64  ✅
   @comptime
   fn size() -> int
       16 * 4             // 0   ❌ silently wrong
   ```
   Always write an explicit `return` in a `@comptime` function until this is fixed.

3. **`else` fallback is statement-level only** — not usable inside an argument expression.

4. **`defer` does not survive a panic** (compile-time construct) — use `on_exit_send` (6.10).

5. **Strings interpolate a bare `{`** — escape as `\{` in literals containing braces
   (JSON/YAML/format templates).

6. **`@derive` is rejected on purpose** — show / json / `==` / hash / `copy()` are automatic.

7. **Reserved words silently mis-codegen** when used as identifiers.

8. **`reduce(list, fn, init)`** — the function is the **second** argument.

9. **`for i, v in xs` IS the index/value form — do NOT wrap it in `enumerate()`.**
   ```nova
   for i, v in xs                  // i = 0, v = "a"          ✅
   for i, v in enumerate(xs)       // i = 0, v = [0, "a"]     ❌ double-wrapped
   ```
   `enumerate` is for when you want the pair list as a VALUE. Wrapping the loop form binds `v`
   to the pair, which silently stores a list pointer where a scalar was expected.

10. **Enum variant constructors return the VARIANT type, not the enum type** — a function that
   `match`es over an enum usually leaves its parameter unannotated (`fn area(s)`).

11. ★ **CONSTRUCTORS ARE FILE-LOCAL — enums AND plain structs alike** (verified 2026-08-15 with
   two-file probes, while building `prism/core/prism_node.nova`). A type's constructor resolves
   ONLY inside the file that declares the type:

   | From an importing file | Result |
   |---|---|
   | `mod.wrapper_fn()` — an ordinary fn that returns the value | ✅ `ok` |
   | `Ctor(...)` — bare | ❌ `error[E1002]: unknown identifier` |
   | `mod.Ctor(...)` — qualified | ❌ `error[E1000]: module has no exported function` |

   One root cause, not two: **constructor-call-position identifier lookup does not cross the module
   boundary**, and both enum variants and struct names resolve by that path. *Pattern-matching* a
   value you already hold DOES work cross-module (unqualified variant patterns resolve by
   type-directed lookup — a different path), so you can **consume** an ADT anywhere; you just cannot
   **construct** one outside its declaring file.

   **This blocks any design where module A declares a type and module B builds values of it** —
   typed errors, message/event enums, state machines, protocol tags, config records, DTOs. Ship one
   wrapper fn per constructor in the declaring file, `prefix_`-named (flat LLVM symbol space):

   ```nova
   fn prism_kind_stack() -> PrismNodeKind          // enum variant
       Stack()
   fn prism_pick_option(v: string, l: string) -> PrismPickOption   // struct
       PrismPickOption(v, l)
   ```

12. ★ **DEFAULT PARAMETER VALUES DIE AT THE MODULE BOUNDARY** (verified 2026-08-15, same probe).
   A default is **not part of the exported signature** — cross-module the function is simply
   full-arity:

   ```nova
   // mod.nova
   fn f(a: int, b: int = 5) -> int
       a + b
   fn same_file() -> int
       f(10)              // ✅ ok — 15, resolved inside the declaring file
   ```
   ```nova
   // caller.nova
   mod.f(10, 5)   // ✅ ok
   mod.f(10)      // ❌ error[E1003]: function expects 2 arguments, but got 1
   ```

   The trap: **the API's shape silently differs depending on which file calls it.** You test it
   same-file, it works, and it breaks for every real consumer. Compile-time caught, never a runtime
   surprise — but it makes defaults a *same-file convenience only*.

   **And NOVA has no arity overloading** — `fn f()` + `fn f(x)` in one file is
   `E1012 duplicate function definition`. So "two call shapes" cannot be spelled that way either.
   For any function another module will call — every public API in `std/`, `forge/`, `prism/` —
   write the full arity, or take `T?` and match on it (also the more honest typing: "may or may not
   have a value" IS `Option<T>`, not a sentinel):

   ```nova
   fn prism_gap(size: int?) -> Result<PrismNode>
       match size
           None    => ...flexible...
           Some(n) => ...fixed n...
   ```

13. ★★ **`obj.field(args)` ON AN UN-INFERRED RECEIVER EMITS AN UNDEFINED `@nova_rt_<field>`**
   (verified 2026-08-15 with an A/B probe; this is the root cause of the long-standing
   `@nova_rt_sql` ORM link failures). Calling a closure held in a struct **field** with direct
   dot-call syntax resolves through **method dispatch** — struct method → module function →
   builtin → *guess the runtime symbol name* — rather than "read the field, then invoke it".
   Whether it works depends on whether the compiler statically knows the receiver's type:

   ```nova
   type Col
       name: string
       extract: any
   fn find_col(cols: list, k: string) -> Result<Col>
       ...
   let direct = cols[0]
   direct.extract(41)                      // ✅ receiver type known -> field access, links
   let viaresult = unwrap(find_col(cols, "a"))
   viaresult.extract(41)                    // ❌ type NOT known -> emits @nova_rt_extract
   ```

   **The failure is a LINK error, not a compile error** — `error: use of undefined value
   '@nova_rt_extract'` — so it surfaces late, and only if something actually links that path.
   It is silent at type-check time.

   **Workaround: bind the field to a local first, then call the local.**
   ```nova
   let f = obj.field
   f(args)                                  // ✅ always a plain closure call
   ```

   This bites any callback-in-a-struct design — table column extractors, form validators, event
   handlers, strategy objects — and it is exactly why `OrmQuery.sql()` fails to link. Prefer the
   local-binding form unconditionally; it costs one line and does not depend on inference.

14. ★ **A LITERAL `{` CANNOT APPEAR IN A DOUBLE-QUOTED STRING — and the error lies about why**
   (verified 2026-08-16). `{...}` is interpolation syntax, so an unmatched brace makes the lexer
   scan for an interpolation expression to end-of-file:

   ```nova
   print("a { b")     // error[E0010]: unterminated string literal    <-- MISLEADING
   print("a {} b")    // error[E0001]: unexpected INTERP_END ' b' in expression
   print("a {x} b")   // ok -- this is interpolation, not a literal brace
   ```

   The first message is actively wrong: the string **is** terminated. The lexer consumed the rest of
   the file looking for the interpolation's `}`, so the reported location is meaningless (often
   `1:1`). Anyone hitting it will hunt for a missing quote that does not exist.

   **Workaround: build the brace at runtime** — `chr(123)` for `{`, `chr(125)` for `}`. Needed by
   any code that emits or parses brace-delimited text: message templates, JSON, code generators,
   format strings. `prism/intl/prism_intl.nova` does exactly this and documents it in-file.

---

## 8. Builtin Data Structures

NOVA ships these as zero-import runtime builtins — no `import` needed, always available. Each is a handle (opaque `int`) created by a constructor and passed to every operation. All are single-process-owned values; do NOT share across `spawn` boundaries without explicit `copy()`.

### Priority Queue (min-heap)
Syntax: `pq_create()` -> handle · `pq_push(pq, priority, value)` · `pq_pop(pq)` -> value with lowest priority · `pq_peek(pq)` -> value · `pq_peek_priority(pq)` -> priority · `pq_len(pq)` · `pq_is_empty(pq)`
```nova
let pq = pq_create()
pq_push(pq, 3, "low")
pq_push(pq, 1, "critical")
pq_push(pq, 2, "medium")
let next = pq_pop(pq)       // "critical" (priority 1 = lowest = first out)
```
Use case: task scheduling, Dijkstra's algorithm, event-driven simulation, any "process the most urgent item next" pattern.

### Deque (double-ended queue)
Syntax: `deque_create()` -> handle · `deque_push_back(d, v)` · `deque_push_front(d, v)` · `deque_pop_front(d)` · `deque_pop_back(d)` · `deque_front(d)` · `deque_back(d)` · `deque_get(d, i)` · `deque_len(d)` · `deque_is_empty(d)` · `deque_to_list(d)`
```nova
let d = deque_create()
deque_push_back(d, 1)
deque_push_back(d, 2)
deque_push_front(d, 0)
let first = deque_pop_front(d)   // 0
let last  = deque_pop_back(d)    // 2
let mid   = deque_get(d, 0)      // 1
let xs    = deque_to_list(d)     // [1]
```
Use case: BFS queues, sliding window algorithms, work-stealing deques, undo/redo stacks.

### Sorted Map (string-keyed, ordered)
Syntax: `smap_create()` -> handle · `smap_set(m, key, val)` · `smap_get(m, key)` · `smap_has(m, key)` · `smap_del(m, key)` · `smap_len(m)` · `smap_keys(m)` -> sorted list · `smap_values(m)` -> list in key order · `smap_range(m, lo, hi)` -> list of values whose keys fall in [lo, hi]
```nova
let m = smap_create()
smap_set(m, "banana", 2)
smap_set(m, "apple", 5)
smap_set(m, "cherry", 1)
let ks = smap_keys(m)             // ["apple", "banana", "cherry"]
let mid = smap_range(m, "b", "d") // [2, 1]  (banana, cherry)
```
Use case: ordered key-value storage, range queries, leaderboards, prefix-based lookups.

Gotcha: keys are **string-only** (the type signature enforces `string`). For integer-keyed ordering, convert with `str()` or use a list of pairs with `sort_by`.

### LRU Cache (bounded, evicts least-recently-used)
Syntax: `lru_create(capacity)` -> handle · `lru_put(c, key, value)` · `lru_get(c, key)` · `lru_has(c, key)` · `lru_len(c)` · `lru_cap(c)` · `lru_hits(c)` · `lru_misses(c)`
```nova
let cache = lru_create(100)
lru_put(cache, "user:42", user_data)
let v = lru_get(cache, "user:42")   // returns cached value, marks as recently used
let ratio = lru_hits(cache) * 100 / (lru_hits(cache) + lru_misses(cache))
```
Use case: bounded caching with automatic eviction, database query caches, API response caches, memoization with memory limits.

Gotcha: there is no explicit `lru_delete` — items are only evicted by the capacity limit when new entries are inserted.

### Counter (frequency map)
Syntax: `counter_create()` -> handle · `counter_inc(c, key)` (by 1) · `counter_add(c, key, n)` (by n) · `counter_get(c, key)` · `counter_total(c)` · `counter_most_common(c, n)` -> list of [key, count] pairs
```nova
let c = counter_create()
for word in split(text, " ")
    counter_inc(c, word)
let top5 = counter_most_common(c, 5)   // [["the", 42], ["a", 31], ...]
let total = counter_total(c)
```
Use case: word frequency, histogram building, vote tallying, event counting.

### Ring Buffer (fixed-size circular)
Syntax: `ringbuf_create(capacity)` -> handle · `ringbuf_push(rb, value)` · `ringbuf_pop(rb)` · `ringbuf_len(rb)` · `ringbuf_cap(rb)` · `ringbuf_is_full(rb)`
```nova
let rb = ringbuf_create(3)
ringbuf_push(rb, "a")
ringbuf_push(rb, "b")
ringbuf_push(rb, "c")
ringbuf_push(rb, "d")             // overwrites "a" (oldest)
let v = ringbuf_pop(rb)           // "b"
```
Use case: fixed-size log retention, streaming data windows, bounded producer-consumer buffers.

### Buffer (string builder)
Syntax: `buffer()` | `buffer_create()` | `buffer_cap(n)` -> handle · `buf_append(b, str)` · `buf_append_char(b, charcode)` · `buf_append_int(b, n)` · `buf_append_float(b, f)` · `buf_to_str(b)` | `buf_str(b)` · `buf_len(b)` · `buf_clear(b)`
```nova
let b = buffer()
buf_append(b, "Hello, ")
buf_append(b, name)
buf_append_char(b, 33)            // '!'
let greeting = buf_to_str(b)      // "Hello, Alice!"
```
Use case: efficient string building (O(1) amortized append vs O(n) concatenation), template rendering, serialization output, CSV/JSON generation.

Note: `buffer_cap(n)` pre-allocates `n` bytes — use when the final size is known. `buf_clear(b)` resets the length to 0 without freeing the backing memory, so the buffer can be reused across iterations.

### Arena Allocator

NOVA provides TWO arena mechanisms for different scoping patterns.

**Thread-local bump arena** — bracket a region of code; all allocations inside are freed in bulk.
Syntax: `arena_enter()` -> cookie · `arena_exit(cookie)` · `set_arena_mode(flag)` · `is_arena_mode()`
```nova
let mark = arena_enter()
// all allocations here use the bump allocator
let items = [process(x) for x in batch]
let result = summarize(items)
arena_exit(mark)                  // everything allocated since arena_enter() is freed
```
Use case: per-request memory in servers (Forge uses this for every HTTP request), parser scratch space, batch processing where intermediate results are discarded.

**Explicit arena handle** — a named arena for manual control.
Syntax: `arena_create()` -> handle · `arena_alloc(a, size)` · `arena_reset(a)` · `arena_free(a)` · `arena_used(a)`
```nova
let a = arena_create()
let block = arena_alloc(a, 1024)
let used = arena_used(a)          // bytes consumed so far
arena_reset(a)                    // rewind to zero, reuse all memory
arena_free(a)                     // release the arena entirely
```

Gotcha: `arena_enter`/`arena_exit` pairs MUST be balanced — a missing `arena_exit` leaks every allocation made since the corresponding `arena_enter`. Nesting is safe as long as exits match enters in reverse order (stack discipline).

---

## 9. Lazy Iterator Protocol

The `iter_*` family provides **lazy, pull-based** iteration. Nothing materializes until a consumer is called — transforms build up a pipeline description, and elements flow through one at a time.

### Creating iterators
Syntax: `iter(list)` -> lazy iterator over the list's elements · `iter_range(lo, hi)` -> lazy integer range [lo, hi) · `iter_range_step(lo, hi, step)` -> lazy stepped range
```nova
let it = iter([10, 20, 30])           // lazy wrapper — no copy
let r = iter_range(0, 1000000)        // no list allocated
let odds = iter_range_step(1, 100, 2) // 1, 3, 5, ..., 99
```
Note: `iter_range` is distinct from `0..n` — the range literal eagerly creates a list, while `iter_range` produces elements on demand. For large ranges, `iter_range` uses constant memory.

### Iterator transforms (lazy — nothing runs until consumed)
Syntax: `iter_map(it, f)` · `iter_filter(it, pred)` · `iter_take(it, n)` · `iter_skip(it, n)` · `iter_zip(a, b)` · `iter_chain(a, b)` · `iter_enumerate(it)` · `iter_flat_map(it, f)`
```nova
let pipeline = iter_range(0, 1000000)
    |> iter_filter(fn(x) x % 2 == 0)
    |> iter_map(fn(x) x * x)
    |> iter_take(10)
// nothing has executed yet — pipeline is a description
```

### Iterator consumers (trigger evaluation)
Syntax: `iter_next(it)` -> pull one value · `iter_collect(it)` -> materialize to list · `iter_reduce(it, init, f)` · `iter_for_each(it, f)` · `iter_count(it)` · `iter_sum(it)` · `iter_any(it, pred)` · `iter_all(it, pred)` · `iter_find(it, pred)`
```nova
let first_val = iter_next(pipeline)   // pulls just the first element: 0
let results = iter_collect(pipeline)  // materializes remaining: [4, 16, 36, 64, 100, 144, 196, 256, 324]
```

### Comprehensive example — lazy vs eager
```nova
// EAGER: allocates 3 intermediate lists, processes all 1M elements
let result = filter(map(filter(range(0, 1000000),
    fn(x) x % 3 == 0), fn(x) x * x), fn(x) x < 10000)

// LAZY: zero intermediate lists, stops as soon as 5 results are found
let result = iter_range(0, 1000000)
    |> iter_filter(fn(x) x % 3 == 0)
    |> iter_map(fn(x) x * x)
    |> iter_filter(fn(x) x < 10000)
    |> iter_take(5)
    |> iter_collect()
// result: [0, 9, 36, 81, 144]
```
The lazy version processes only the elements needed to fill 5 results; the eager version processes all one million and allocates three full-length intermediate lists.

Gotcha: the `iter_*` family is **distinct** from the eager builtins (`map`, `filter`, `reduce`). The eager builtins take and return lists; the `iter_*` builtins take and return iterator handles. Do not mix them — `map(iter, f)` treats the iterator handle as a one-element list, it does not iterate. For small collections where all elements are needed, the eager builtins are simpler and faster (no per-element closure dispatch overhead).

Gotcha: `iter_skip` is the name, not `iter_drop`. The naming follows "skip N elements, then yield the rest."

---

## 10. Systems & Low-level Programming

### Atomic operations
Syntax: `atomic_new(val)`, `atomic_get(a)`, `atomic_set(a, val)`, `atomic_add(a, val)`, `atomic_cas(a, expected, desired)` — lock-free atomic integer operations; `atomic_cas` returns the previous value (compare-and-swap succeeds when previous == expected).
```nova
let counter = atomic_new(0)
atomic_add(counter, 1)
let prev = atomic_cas(counter, 1, 5)   // prev == 1, counter now 5
let val = atomic_get(counter)           // 5
```
Use case: lock-free counters, concurrent statistics, CAS-based algorithms without channel overhead.

### Checked arithmetic
Syntax: `checked_add(a, b)`, `checked_sub(a, b)`, `checked_mul(a, b)` — integer arithmetic that panics on overflow instead of wrapping silently; `overflow_panic()` triggers a crash directly.
```nova
let total = checked_add(balance, deposit)   // panics if balance + deposit overflows i64
let scaled = checked_mul(price, quantity)
```
Use case: financial calculations, safety-critical code, input validation where silent wrapping would corrupt data.
Gotcha: these PANIC on overflow, they do not return a Result. For recoverable overflow detection, test bounds manually before the operation.

### Weak references
Syntax: `weak_create(obj)` -> weak handle, `weak_upgrade(w)` -> the object or null, `weak_alive(w)` -> bool, `weak_invalidate(w)` — non-preventing references that do not keep an object alive for RC collection.
```nova
let obj = {"name": "cache_entry", "data": big_payload}
let w = weak_create(obj)
// ... later, obj may have been collected ...
if weak_alive(w)
    let recovered = weak_upgrade(w)
    print(recovered)
```
Use case: caches that do not prevent collection, observer patterns, breaking reference cycles in graph structures.
Gotcha: `weak_upgrade` returns null if the referent has been collected — always check `weak_alive` or null-check the result.

### Offheap memory
Syntax: `offheap_create(size)` -> handle, `offheap_len(h)` -> int, `offheap_get(h, offset)` / `offheap_set(h, offset, value)` — unmanaged byte buffer outside the GC; `offheap_get_f64(h, offset)` / `offheap_set_f64(h, offset, value)` for typed float access; `offheap_free(h)` releases it.
```nova
let buf = offheap_create(1024)
offheap_set(buf, 0, 42)
let v = offheap_get(buf, 0)         // 42
offheap_set_f64(buf, 8, 3.14)
let f = offheap_get_f64(buf, 8)     // 3.14
offheap_free(buf)
```
Use case: large numeric arrays, memory-mapped data structures, bypassing GC for hot data paths.
Gotcha: offheap memory is NOT reference-counted. You must call `offheap_free` manually or it leaks. Offsets are in bytes and bounds-checked at runtime.

### Memory-mapped files
Syntax: `mmap_open(path)` -> handle, `mmap_len(m)` -> int (file size in bytes), `mmap_byte(m, i)` -> int (single byte), `mmap_close(m)` — maps a file into the address space for zero-copy random reads.
```nova
let m = mmap_open("data/log.bin")
let size = mmap_len(m)
let first = mmap_byte(m, 0)
let last = mmap_byte(m, size - 1)
mmap_close(m)
```
Use case: reading large files without loading into heap memory, database engines, log analysis, binary file parsing.
Gotcha: `mmap_byte` is bounds-checked; reading past `mmap_len` sets an error. Always `mmap_close` when done.

### SIMD primitives
Syntax: `simd_add(a, b)`, `simd_sub(a, b)`, `simd_mul(a, b)` — element-wise vector ops; `simd_scale(a, scalar)` — scalar multiply; `simd_dot(a, b)` -> float — dot product; `simd_sum(a)` -> float — horizontal sum; `simd_ready(a)` -> bool — checks alignment/packing.
```nova
let a = [1.0, 2.0, 3.0, 4.0]
let b = [5.0, 6.0, 7.0, 8.0]
let c = simd_add(a, b)              // [6.0, 8.0, 10.0, 12.0]
let d = simd_dot(a, b)              // 70.0
let s = simd_scale(a, 10.0)         // [10.0, 20.0, 30.0, 40.0]
```
Use case: vector math, signal processing, physics engines, high-performance numeric code.
Gotcha: operates on float arrays (typed). Check `simd_ready(a)` to confirm the array is packed and aligned before hot loops. Regular heterogeneous lists will not vectorize.

### Raw pointer operations (unsafe)
Syntax: `ptr_read(p)` / `ptr_write(p, v)` — read/write a NOVA value at a raw address; typed variants `ptr_read_u8` / `ptr_read_i8` / `ptr_read_u16` / ... / `ptr_read_f64` and `ptr_write_u8` / ... / `ptr_write_f64` for sized access; `ptr_add(p, offset)` / `ptr_diff(a, b)` — pointer arithmetic; `memcpy_unsafe(dst, src, n)` / `memset_unsafe(dst, val, n)` — bulk memory ops; `alloc_raw(n)` / `free_raw(p)` — raw heap; `null_ptr()` / `is_null(p)` — null sentinel; `cstr_of(s)` / `str_from_cstr(p)` — C string conversion.
```nova
unsafe
    let p = alloc_raw(64)
    ptr_write_u8(p, 0xFF)
    let v = ptr_read_u8(p)       // 255
    let q = ptr_add(p, 8)
    ptr_write_f64(q, 3.14)
    free_raw(p)
```
Use case: FFI interop, custom allocators, memory-mapped hardware, embedded systems.
Gotcha: ALL pointer operations require an enclosing `unsafe` block — the compiler rejects them in safe code. No bounds checking, no type safety, no RC tracking. A wrong offset is a CVE.

---

## 11. Hashing, Crypto & Serialization

### Cryptographic hashing (SHA-256)
Syntax: `sha256(str)` -> hex string, `sha256_of_bytes(bytes_handle)` -> hex string, `sha256_bytes(bytes_handle, n)` -> hex string (first n bytes only) — SHA-256 digest.
```nova
let digest = sha256("hello world")
print(digest)                        // "b94d27b9934d3e..."
```
Use case: integrity checks, content addressing, password storage (with salt), file deduplication.

### HMAC
Syntax: `hmac_sha256(key, msg)` -> hex string — keyed-hash message authentication code using SHA-256.
```nova
let sig = hmac_sha256(secret_key, request_body)
if sig != expected_sig
    return err("invalid signature")
```
Use case: API authentication (JWT, webhooks), message integrity verification, signed cookies.

### Fast hashing (non-cryptographic)
Syntax: `crc32(str)` -> int, `fnv1a(str)` -> int, `murmur3(str, seed)` -> int — fast, non-cryptographic hash functions.
```nova
let checksum = crc32("payload data")
let bucket = murmur3(key, 0) % num_buckets
let fingerprint = fnv1a(token)
```
Use case: hash tables, checksums, data partitioning, bloom filters, consistent hashing.
Gotcha: these are NOT cryptographically secure. Do not use for signatures, passwords, or anything adversarial — use `sha256` / `hmac_sha256` instead.

### Generic hash
Syntax: `hash(value)` -> int — structural hash over any NOVA value (recursive over lists, dicts, structs).
```nova
let h = hash([1, 2, 3])
let h2 = hash({"name": "Alice"})
```
Use case: custom hash maps, deduplication, cache keys. Cross-ref: also in section 2 (collections).

### Binary serialization (term encoding)
Syntax: `term_encode(value)` -> bytes, `term_decode(data)` -> value — Erlang-style external term format for cross-node message serialization.
```nova
let wire = term_encode({"cmd": "ping", "ts": now()})
send_bytes(socket, wire)
// on the other side:
let msg = term_decode(recv_bytes(socket))
```
Use case: distributed channel messages, cross-process term storage, language-agnostic wire format.

---

## 12. Networking & I/O

All networking builtins are zero-import (no `import` needed). Connections are represented as integer file descriptors. Errors are signaled by return values (fd <= 0 for connection failures, empty string for recv failures) — wrap in `Result` at the application layer if desired.

### Low-level TCP
Syntax: `tcp_connect(host, port)` -> fd · `tcp_listen(port)` -> listener fd · `tcp_accept(listener)` -> client fd · `tcp_send(fd, data)` · `tcp_send_bytes(fd, bytes)` · `tcp_recv(fd)` -> string · `tcp_recv_bytes(fd, n)` -> bytes · `tcp_close(fd)` · `tcp_peer_addr(fd)` -> ip string · `tcp_peer_port(fd)` -> int · `tcp_wait_readable(fd, timeout_ms)` -> bool
```nova
let listener = tcp_listen(8080)
let client = tcp_accept(listener)
let data = tcp_recv(client)
tcp_send(client, "HTTP/1.1 200 OK\r\n\r\nHello")
let addr = tcp_peer_addr(client)
tcp_close(client)
tcp_close(listener)
```
Use case: custom protocol servers, raw network programming, building higher-level abstractions on top.

Gotcha: `tcp_recv` may return partial data — production code must loop and accumulate until a delimiter or expected byte count is reached. `tcp_connect` returns fd <= 0 on failure; always check before sending.

### Low-level UDP
Syntax: `udp_bind(port)` -> fd · `udp_send(fd, host, port, data)` · `udp_recv(fd, bufsize)` -> data · `udp_recv_from(fd, bufsize)` -> [data, addr, port]
```nova
let sock = udp_bind(9000)
udp_send(sock, "127.0.0.1", 9001, "ping")
let reply = udp_recv_from(sock, 1024)  // ["pong", "127.0.0.1", "9001"]
let data = reply[0]
let sender = reply[1]
```
Use case: DNS clients, game networking, real-time streaming, discovery protocols, any latency-sensitive fire-and-forget messaging.

Gotcha: `udp_recv_from` returns a **list** of `[data, addr, port]`, not a struct. Access fields by index.

### Socket options
Syntax: `socket_option(fd, name, value)` -> bool · `io_set_nonblocking(fd)`
```nova
socket_option(fd, "TCP_NODELAY", 1)     // disable Nagle's algorithm
socket_option(fd, "SO_REUSEADDR", 1)    // allow port reuse after restart
io_set_nonblocking(fd)                  // switch to non-blocking I/O
```
Use case: tuning TCP behavior (latency vs throughput), enabling non-blocking I/O for event loops, setting buffer sizes.

### I/O polling (epoll/kqueue/IOCP abstraction)
Syntax: `io_poll_create()` -> poll handle · `io_poll_add(poll, fd, events)` · `io_poll_wait(poll, timeout_ms)` -> list of ready fds · `io_poll_remove(poll, fd)` · `io_poll_close(poll)`
```nova
let poll = io_poll_create()
io_poll_add(poll, listener, "read")
io_poll_add(poll, client1, "read")
let ready = io_poll_wait(poll, 1000)    // block up to 1s
for fd in ready
    let data = tcp_recv(fd)
    // handle data
io_poll_close(poll)
```
Use case: event-driven servers multiplexing many connections, building reactors, high-connection-count services without one-thread-per-connection.

Note: the runtime maps to `epoll` on Linux, `kqueue` on macOS, and `IOCP` on Windows — same API everywhere.

### TLS (encrypted networking)
Syntax: `tls_connect(host, port)` -> fd · `tls_connect_insecure(host, port)` -> fd · `tls_connect_alpn(host, port, protocols)` -> fd · `tls_listen(port, cert_path, key_path)` -> listener fd · `tls_listen_alpn(port, cert_path, key_path, protocols)` -> listener fd · `tls_accept(listener)` -> client fd · `tls_send(fd, data)` · `tls_send_bytes(fd, bytes)` · `tls_recv(fd)` -> string · `tls_recv_bytes(fd, n)` -> bytes · `tls_close(fd)` · `tls_alpn(fd)` -> negotiated protocol · `tls_upgrade(fd)` -> tls fd
```nova
// HTTPS client
let fd = tls_connect("api.example.com", 443)
tls_send(fd, "GET / HTTP/1.1\r\nHost: api.example.com\r\n\r\n")
let response = tls_recv(fd)
tls_close(fd)

// HTTPS server
let listener = tls_listen(443, "cert.pem", "key.pem")
let client = tls_accept(listener)
let request = tls_recv(client)
tls_send(client, "HTTP/1.1 200 OK\r\n\r\nSecure Hello")
tls_close(client)
```
Use case: HTTPS clients and servers, secure API calls, mTLS, any encrypted network communication.

Gotcha: `tls_connect_insecure` **skips certificate verification** — use only for development and testing, never in production. `tls_upgrade(fd)` converts an existing plain TCP connection to TLS in-place (STARTTLS pattern).

### WebSocket
Syntax: `ws_upgrade(fd)` -> ws handle · `ws_send(ws, message)` · `ws_recv(ws, timeout_ms)` -> message · `ws_close(ws)` · `ws_accept_key(key)` -> accept header value
```nova
// Server-side: upgrade an accepted HTTP connection
let ws = ws_upgrade(client_fd)
let msg = ws_recv(ws, 5000)           // wait up to 5 seconds
ws_send(ws, "echo: {msg}")
ws_close(ws)
```
Use case: real-time applications, chat, live dashboards, streaming APIs, push notifications.

Note: `ws_accept_key` computes the `Sec-WebSocket-Accept` header value from a client key — used when implementing the upgrade handshake manually. For Forge applications, `@websocket` routes handle the upgrade automatically.

### DNS
Syntax: `dns_resolve(hostname)` -> ip string · `dns_resolve_all(hostname)` -> list of ip strings · `reverse_dns(ip)` -> hostname
```nova
let ip = dns_resolve("example.com")          // "93.184.216.34"
let all_ips = dns_resolve_all("google.com")  // ["142.250.80.46", ...]
let host = reverse_dns("8.8.8.8")           // "dns.google"
```
Use case: custom DNS clients, service discovery, network diagnostics, load balancer target resolution.

---

## 13. Process & System Utilities

### Subprocess management
Syntax: `proc_open(cmd)` -> handle, `proc_write_stdin(h, data)`, `proc_read_stdout(h)` -> string, `proc_close_stdin(h)`, `proc_wait(h)` -> exit_code — spawn and interact with an external process via pipes.
```nova
let h = proc_open("sort")
proc_write_stdin(h, "banana\napple\ncherry\n")
proc_close_stdin(h)
let sorted = proc_read_stdout(h)
let code = proc_wait(h)
```
Use case: running external tools, piping data to/from subprocesses, build scripts, shell pipelines.
Gotcha: `proc_open` takes a single shell command string (parsed by the OS shell). Always `proc_close_stdin` before reading stdout to avoid deadlock on pipes.

### Shell execution
Syntax: `shell(cmd)` -> output string — run a command through the OS shell and capture its combined output.
```nova
let branch = shell("git rev-parse --abbrev-ref HEAD")
print("On branch: {branch}")
```
Use case: quick system commands, dev tooling, scripts where you just need the output.

### Process info
Syntax: `getpid()` -> int, `hostname()` -> string, `cpu_count()` -> int, `os_name()` -> string, `arch_name()` -> string, `self_exe_path()` -> string — runtime environment introspection.
```nova
print("PID {getpid()} on {hostname()}, {os_name()}/{arch_name()}, {cpu_count()} cores")
print("Running from: {self_exe_path()}")
```
Use case: runtime diagnostics, platform-specific behavior, structured logging context, multi-process coordination.

### File system traversal
Syntax: `dir_walk(path)` -> list of all file paths recursively, `list_dir(path)` -> list of direct entries, `cwd()` -> string, `chdir(path)` — file system navigation.
```nova
let all_nova = [f for f in dir_walk(".") if f.ends_with(".nova")]
let entries = list_dir("/tmp")
print("Working in: {cwd()}")
```
Use case: file discovery, project scanning, build systems, test harnesses.

### Program lookup
Syntax: `which(cmd)` -> string — resolve an executable name to its absolute path; returns empty string if not found.
```nova
let cc = which("clang")
if cc == ""
    print("clang not found, falling back to gcc")
    cc = which("gcc")
```
Use case: checking tool availability before invoking subprocesses, portable build scripts.

### Standard I/O
Syntax: `stdin_read_n(n)` -> string — read up to n bytes from stdin; `stdout_write(s)` — write to stdout without a trailing newline.
```nova
stdout_write("Enter name: ")
let name = stdin_read_n(256)
print("Hello, {name}")
```
Use case: interactive programs, piped data processing, REPLs, progress indicators.

### Graceful shutdown
Syntax: `shutdown_requested()` -> int (1 once a SIGINT/SIGTERM has arrived), `reload_requested()` -> int (1 once since last poll a SIGHUP arrived; consumes the flag), `at_exit(fn)` — register a cleanup callback.
```nova
at_exit(fn() print("shutting down..."))

while not shutdown_requested()
    let conn = accept(server)
    handle(conn)
// falls through here after Ctrl+C
```
Use case: long-running servers, cleanup on Ctrl+C, graceful drain of connections, config reload on SIGHUP.
Note: a second SIGINT/SIGTERM force-exits the process immediately, so it always remains killable. `reload_requested` consumes the flag on read so each SIGHUP is handled exactly once.

---

## 14. Logging, Profiling & Diagnostics

### Structured logging
Syntax: `log_trace(tag, msg)` · `log_debug(tag, msg)` · `log_info(tag, msg)` · `log_warn(tag, msg)` · `log_error(tag, msg)` · `log_fatal(tag, msg)` — emit a log line at the given severity. `log_set_level(level)` sets the minimum severity (0=trace, 1=debug, 2=info, 3=warn, 4=error, 5=fatal). `log_get_level()` returns the current level. `log_set_json(flag)` switches output to JSON when flag is 1.
```nova
log_set_level(2)                         // only info and above
log_info("http", "listening on :8080")   // printed
log_debug("http", "header dump")         // filtered out

log_set_json(1)                          // {"level":"INFO","tag":"http","msg":"..."}
log_error("db", "connection refused")
```
Use case: production logging with severity filtering, observability pipelines (ELK, Loki, Datadog). Tag-based filtering lets different subsystems log at different granularity.

Gotcha: `log_fatal` logs the message but does NOT terminate the process — use `panic()` after it if you want a crash.

### Profiling
Syntax: `prof_start(name)` -> handle · `prof_stop(handle)` — bracket a named timing region. `prof_get_ns(name)` -> nanoseconds elapsed. `prof_report()` -> formatted string of all regions. `prof_reset()` clears all data. `prof_export_flame(path)` writes flamegraph-compatible data. `prof_enter(name)` · `prof_exit(name)` are the string-keyed variant (no handle).
```nova
let h = prof_start("parse")
let ast = parse(source)
prof_stop(h)

prof_enter("codegen")
let ir = codegen(ast)
prof_exit("codegen")

print(prof_report())                     // tabulated name / elapsed_ns / calls
prof_export_flame("profile.folded")      // for flamegraph.pl or speedscope
```
Use case: performance optimization, CI regression detection (assert `prof_get_ns("parse") < 50000000`), production hot-path analysis.

Gotcha: `prof_enter`/`prof_exit` are matched by name string, not by handle — mismatched names silently create orphan regions.

### Coverage
Syntax: `cov_mark(file, line)` — record a hit at the given source location. `cov_get(file, line)` -> hit count. `cov_report()` -> formatted coverage summary. `cov_reset()` clears all data. `cov_export_lcov(path)` writes LCOV-format data for external tools.
```nova
cov_mark("parser.nova", 42)
cov_mark("parser.nova", 42)              // second hit
assert_eq(cov_get("parser.nova", 42), 2)

cov_export_lcov("coverage.lcov")         // import into genhtml / codecov / coveralls
print(cov_report())
```
Use case: test coverage tracking, CI quality gates ("fail if coverage < 80%"), finding dead code paths.

Note: coverage is manual instrumentation — the compiler does not auto-insert `cov_mark` calls. Use it in test harnesses or inject via `@test` hooks.

### Debug Adapter Protocol (DAP)
Syntax: `dap_log(category, msg)` · `dap_breakpoint(file, line)` · `dap_send(msg)` — DAP wire protocol helpers. `dbg_set_bp(file, line)` -> id · `dbg_remove_bp(id)` · `dbg_list_bps()` — programmatic breakpoint management. `dbg_push_frame(name, file, line)` · `dbg_pop_frame()` · `dbg_backtrace()` — call stack tracking. `dbg_hook(fn)` · `dbg_enable()` · `dbg_disable()` — step-through debugging control.
```nova
dbg_enable()
dbg_set_bp("main.nova", 10)

dbg_push_frame("process_request", "server.nova", 42)
// ... function body ...
dbg_pop_frame()

let bt = dbg_backtrace()                 // list of frame info
dap_log("console", "hit breakpoint")
dbg_disable()                            // resume full-speed execution
```
Use case: IDE debugging integration (VS Code DAP), programmatic breakpoints in test harnesses, custom debugger tools, post-mortem analysis.

Note: `dbg_push_frame` / `dbg_pop_frame` must be balanced on every code path, including error returns. An unbalanced stack corrupts the backtrace.

---

## 15. Testing & Assertions

### Basic assertions
Syntax: `assert(cond, msg)` — panics with `msg` if `cond` is false. `assert_eq(a, b)` · `assert_ne(a, b)` — equality/inequality with automatic diff in the panic message. `assert_true(cond)` · `assert_false(cond)` — boolean checks.
```nova
assert(len(items) > 0, "items must not be empty")
assert_eq(fib(10), 55)
assert_ne(hash(a), hash(b))
assert_true(is_valid(token))
assert_false(is_expired(session))
```
Use case: KAT tests, unit tests, invariant checking. The `_eq`/`_ne` variants print both values on failure, which `assert(a == b, "...")` does not.

### Extended assertions
Syntax: `assert_contains(collection, item)` — panics if `item` is not in `collection`. `assert_approx(actual, expected, tolerance)` — panics if `abs(actual - expected) > tolerance`. `assert_throws(fn, expected_msg)` — calls `fn()` and panics if it does NOT raise an error containing `expected_msg`.
```nova
assert_contains([10, 20, 30], 20)
assert_approx(sin(3.14159), 0.0, 0.001)   // within epsilon
assert_throws(fn() parse_int_safe("abc"), "invalid")
```
Use case: collection membership tests, floating-point math verification (never use `assert_eq` on floats), error-path testing without manual try/catch.

Gotcha: `assert_throws` takes a zero-argument function, not a bare expression. Wrap the call in `fn() ...`.

### TAP test runner
Syntax: `test_run_tap(name, fn, id)` — runs `fn()`, catches panics, and prints TAP-formatted output (`ok <id> - <name>` or `not ok <id> - <name>`).
```nova
test_run_tap("addition", fn() assert_eq(1 + 1, 2), 1)
test_run_tap("division by zero", fn() assert_throws(fn() 1 / 0, "divide"), 2)
// Output:
// ok 1 - addition
// not ok 2 - division by zero
```
Use case: CI integration (TAP is understood by Jenkins, GitHub Actions, prove, tap-spec), standardized test output, building test frameworks.

Note: print `1..<N>` before the first test to produce a valid TAP plan header.

### Semver utilities
Syntax: `semver_parse(str)` -> list of ints `[major, minor, patch]`. `semver_compare(a, b)` -> -1/0/1. `semver_satisfies(version, constraint)` -> bool. `semver_format(parsed)` -> string. `semver_compatible(a, b)` -> int (1 if compatible under semver rules).
```nova
let v = semver_parse("2.3.1")            // [2, 3, 1]
assert_eq(semver_compare("1.0.0", "2.0.0"), -1)
assert_true(semver_satisfies("1.5.3", ">=1.0.0"))
assert_eq(semver_format("1.2.3"), "1.2.3")
```
Use case: dependency resolution, version constraint checking, package management, upgrade compatibility gates.

---

## 16. Tensor & GPU Compute

### Tensor creation
Syntax: `tensor_zeros(shape)` — create a zero-filled tensor; shape is a list of ints (e.g. `[2, 3]` for a 2x3 matrix). `tensor_from_list(data, shape)` — create from flat data + shape.
```nova
let m = tensor_zeros([3, 3])             // 3x3 zero matrix
let v = tensor_from_list([1.0, 2.0, 3.0, 4.0], [2, 2])  // 2x2 matrix
```

### Tensor inspection
Syntax: `tensor_shape(t)` -> list of ints · `tensor_size(t)` -> total element count · `tensor_rank(t)` -> number of dimensions · `tensor_get(t, indices)` -> float · `tensor_set(t, indices, value)` — mutate in place.
```nova
let t = tensor_zeros([2, 3])
assert_eq(tensor_shape(t), [2, 3])
assert_eq(tensor_rank(t), 2)
assert_eq(tensor_size(t), 6)
tensor_set(t, [0, 1], 5.0)
assert_approx(tensor_get(t, [0, 1]), 5.0, 0.001)
```

### Tensor math
Syntax: `tensor_add(a, b)` · `tensor_sub(a, b)` · `tensor_mul(a, b)` · `tensor_div(a, b)` — element-wise arithmetic, shapes must match. `tensor_scale(t, scalar)` — multiply every element. `tensor_matmul(a, b)` — matrix multiplication (inner dimensions must agree). `tensor_sum(t)` -> scalar sum of all elements.
```nova
let a = tensor_from_list([1.0, 2.0, 3.0, 4.0], [2, 2])
let b = tensor_from_list([5.0, 6.0, 7.0, 8.0], [2, 2])
let c = tensor_add(a, b)                 // element-wise: [6, 8, 10, 12]
let d = tensor_matmul(a, b)              // matrix product: [19, 22, 43, 50]
let s = tensor_scale(a, 2.0)             // [2, 4, 6, 8]
```

### Tensor ML operations
Syntax: `tensor_relu(t)` · `tensor_sigmoid(t)` · `tensor_tanh(t)` · `tensor_softmax(t)` · `tensor_exp(t)` · `tensor_log(t)` — element-wise activation / math functions. `tensor_argmax(t)` -> int index of the largest element. `tensor_add_bias(t, bias)` — add a bias vector to each row.
```nova
let logits = tensor_from_list([2.0, 1.0, 0.1], [1, 3])
let probs = tensor_softmax(logits)       // [0.659, 0.242, 0.099]
let pred = tensor_argmax(probs)          // 0
let activated = tensor_relu(tensor_from_list([-1.0, 0.0, 3.0], [1, 3]))  // [0, 0, 3]
```

### Tensor manipulation
Syntax: `tensor_transpose(t)` — swap rows and columns (2D). `tensor_reshape(t, new_shape)` — reinterpret with a new shape (total size must match). `tensor_to_list(t)` -> flat list of values.
```nova
let m = tensor_from_list([1.0, 2.0, 3.0, 4.0, 5.0, 6.0], [2, 3])
let mt = tensor_transpose(m)             // shape [3, 2]
let flat = tensor_reshape(m, [6])        // shape [6]
let vals = tensor_to_list(m)             // [1.0, 2.0, 3.0, 4.0, 5.0, 6.0]
```

### Neural network forward pass (example)
A complete 2-layer neural network inference in NOVA:
```nova
let x = tensor_from_list([0.5, 0.8, 0.2], [1, 3])

let w1 = tensor_from_list([0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0, 1.1, 1.2], [3, 4])
let b1 = tensor_from_list([0.01, 0.01, 0.01, 0.01], [1, 4])
let h = tensor_relu(tensor_add_bias(tensor_matmul(x, w1), b1))

let w2 = tensor_from_list([0.2, 0.3, 0.5, 0.1, 0.4, 0.2, 0.6, 0.1, 0.3, 0.3, 0.7, 0.1], [4, 3])
let b2 = tensor_from_list([0.0, 0.0, 0.0], [1, 3])
let logits = tensor_add_bias(tensor_matmul(h, w2), b2)
let probs = tensor_softmax(logits)

let predicted_class = tensor_argmax(probs)
print("prediction: class {predicted_class}")
```
Use case: machine learning inference, neural network forward passes, scientific computing, linear algebra. All tensor operations are runtime builtins — no external library or FFI needed.

Gotcha: tensors are opaque handles, not NOVA lists. Use `tensor_to_list` to extract values for normal NOVA operations. `tensor_mul` is element-wise; use `tensor_matmul` for matrix multiplication.

---

## 17. Hot Reload, ECS & Advanced

### Hot-code reload
Syntax: `hot_load(path)` -> handle — load a shared library (.dll/.so). `hot_unload(handle)` — unload it. `hot_reload(handle)` — reload the library at the same path. `hot_sym(handle, name)` -> function pointer — look up a symbol by name. `hot_call0(sym)` · `hot_call1(sym, arg)` · `hot_call2(sym, a, b)` · `hot_call3(sym, a, b, c)` — call the looked-up function with 0-3 arguments.
```nova
let lib = hot_load("plugins/physics.dll")
let step_fn = hot_sym(lib, "physics_step")
hot_call1(step_fn, world)                // call physics_step(world)

// after editing physics.dll:
hot_reload(lib)                          // pick up changes
let step_fn = hot_sym(lib, "physics_step")
hot_call1(step_fn, world)                // runs new version
```
Use case: live-reloading game logic during development, plugin systems, dev servers that update without restart.

### Hot-reload file watcher
Syntax: `hot_reload_watch(path)` -> handle — watch a file or directory for changes. `hot_reload_check()` -> bool — returns true if any watched path changed since last check. `hot_reload_path(id)` -> string — get the path of a watched entry.
```nova
let w = hot_reload_watch("src/")
while true
    if hot_reload_check()
        print("source changed, reloading...")
        reload_modules()
    sleep(500)
```
Use case: development tooling, auto-rebuild on save, live preview servers.

### ECS (Entity Component System)
Syntax: `ecs_world()` -> world handle. `ecs_entity(world)` -> entity id. `ecs_set(world, entity, component_name, value)` · `ecs_get(world, entity, component_name)` · `ecs_has(world, entity, component_name)` — per-entity component access by string key. `ecs_query(world, component_name)` -> list of entities that have the component. `ecs_destroy(world, entity)` — remove an entity and all its components.
```nova
let world = ecs_world()
let player = ecs_entity(world)
ecs_set(world, player, "pos_x", 100)
ecs_set(world, player, "pos_y", 200)
ecs_set(world, player, "health", 100)

let enemy = ecs_entity(world)
ecs_set(world, enemy, "pos_x", 300)
ecs_set(world, enemy, "health", 50)

let alive = ecs_query(world, "health")   // [player, enemy]
for e in alive
    let hp = ecs_get(world, e, "health")
    print("entity {e}: hp={hp}")
```
Use case: game development, simulation, data-oriented design where entities are bags of components rather than class hierarchies.

Note: components are keyed by string name and store a single value. For compound data (e.g. a position), use separate components (`"pos_x"`, `"pos_y"`) or store a dict.

### ABI version
Syntax: `abi_version()` -> int — returns the runtime ABI version number.
```nova
print("runtime ABI: {abi_version()}")
```
Use case: runtime version checking, compatibility verification between separately compiled modules or plugins loaded via `hot_load`.

### Stepped range
Syntax: `range_step(start, stop, step)` -> list of ints — eagerly creates the full list from `start` to `stop` (exclusive) with the given step.
```nova
let evens = range_step(0, 10, 2)         // [0, 2, 4, 6, 8]
let countdown = range_step(10, 0, -1)    // [10, 9, 8, ..., 1]
```
Use case: iterating with custom step sizes, generating numeric sequences.

Note: unlike `iter_range_step(start, stop, step)` which is lazy (returns an iterator), `range_step` allocates the entire list up front. Use `iter_range_step` in `for` loops over large ranges.

### Safe parse builtins
Syntax: `parse_int_safe(s)` -> Result<int, string> · `parse_float_safe(s)` -> Result<float, string> — parse a string to a number, returning `ok(value)` on success or `err(reason)` on failure.
```nova
match parse_int_safe(user_input)
    Ok(n) => print("got number: {n}")
    Err(e) => print("bad input: {e}")

match parse_float_safe("3.14")
    Ok(f) => print("pi ~ {f}")
    Err(e) => print("not a float: {e}")
```
Use case: user input parsing, config file loading, CSV processing — anywhere failure is expected and should be handled, not crashed on.

Gotcha: these return `Result`, not a raw value. Use `match` or `unwrap_or` to extract. The `err` payload is a string describing why parsing failed.

### Structural type cast
Syntax: `form_as<T>(value)` -> Result<T, string> — attempt a runtime structural cast of `value` (typically a dict) into struct `T`, matching by field name.
```nova
type User
    name: string
    age: int

let raw = {"name": "Alice", "age": "30"}
match form_as<User>(raw)
    Ok(u) => print("welcome, {u.name}")
    Err(e) => print("bad form: {e}")
```
Use case: JSON-to-struct conversion, HTTP form body parsing, database row mapping.

Gotcha: `form_as` expects a dict with string keys. Integer fields are parsed from their string representation internally.

---

## 18. Additional Annotations

Annotations are processed at compile time via `@name` or `@name("arg")` syntax. There are two tiers:
- **Tier 1** — deeply integrated, modifying codegen, AST, or runtime behavior
- **Tier 2** — metadata-only, generating `__annotationname` companion query functions that can be called at runtime

### Tier 1 annotations (modify behavior)

**`@cdecl`** — C calling convention. Emits the function with `ccc` (C calling convention) in LLVM IR instead of NOVA's default ABI. Required for FFI callbacks (e.g., passing a NOVA function to C's `qsort`).
```nova
@cdecl
fn compare(a: int, b: int) -> int
    a - b
```
Use case: FFI callbacks, C-callable function pointers.

**`@comptime`** — Compile-time evaluation. The function body is evaluated at compile time; calls are replaced with computed constants. Requires an explicit `return` statement (bare expression bodies fold to 0 — see Trap 2).
```nova
@comptime
fn table_size() -> int
    return 16 * 4    // folded to 64 at compile time
```
Use case: compile-time constants that depend on computation, lookup table sizes, configuration.

**`@deprecated` / `@deprecated("msg")`** — Deprecation warning. Injects a `deprecated_warn(name, msg)` call at function entry, emitting a runtime warning on first use.
```nova
@deprecated("use new_api() instead")
fn old_api() -> int
    42
```
Use case: API migration, soft removal of functions, guiding users to replacements.

**`@log`** — Entry logging. Injects a `log_fn_entry(name)` call at function entry, recording every invocation.
```nova
@log
fn process_payment(amount: int) -> bool
    // log_fn_entry("process_payment") is auto-injected here
    charge(amount)
```
Use case: audit trails, debugging call sequences, performance tracing.

**`@redact`** — Field-level security (LOCK-7). Applied to struct fields; masks the field value in `show`, serialization, and `to_json` output. The actual value is stored normally but never reaches log lines or wire output.
```nova
type Credentials
    username: string
    @redact
    password: string

print(Credentials("admin", "s3cret"))    // Credentials { username: admin, password: [REDACTED] }
```
Use case: PII protection, credential masking, GDPR compliance, security audit requirements.

**`@builder`** — Builder pattern generation. Generates `<T>__builder()` (returns a dict), `<T>__set_<field>(b, val)` (chainable setters), and `<T>__build(b)` (constructs the struct from accumulated values).
```nova
@builder
type Config
    host: string
    port: int
    debug: bool

let c = Config__builder()
let c = Config__set_host(c, "localhost")
let c = Config__set_port(c, 8080)
let cfg = Config__build(c)
```
Use case: complex struct construction with optional fields, configuration objects, fluent APIs.

### Tier 2 annotations (metadata query only)

These annotations generate companion `__name` functions that return metadata at runtime. They do NOT modify the annotated function/type's behavior.

**`@entity` / `@entity("table_name")`** — ORM entity metadata. Generates `__table_name`, `__primary_key`, `__insert_sql`, `__create_table_sql`.
```nova
@entity("users")
type User
    id: int
    name: string
    email: string

let sql = User__create_table_sql()       // CREATE TABLE users (id INTEGER, name TEXT, ...)
let insert = User__insert_sql()          // INSERT INTO users (id, name, email) VALUES (?, ?, ?)
```
Use case: database ORM, schema generation, query building.

**`@service` / `@service("name")`** — Service registry. Generates `__service_name`, `__is_service`, `__dependencies`.
Use case: microservice architecture, dependency injection, service discovery.

**`@inject`** — Dependency injection. Generates `__is_injectable`, `__inject_deps`, `__inject_name`.
Use case: IoC containers, test mocking, service composition.

**`@middleware` / `@middleware("name")`** — Middleware registration. Generates `__middleware_name`, `__is_middleware`.
Use case: HTTP middleware chains, request/response pipelines, plugin systems.

**`@validate`** — Validation metadata. Generates `__has_validation`, `__validate_fields`, `__field_count`.
Use case: form validation, API input checking, schema enforcement.

**`@retry` / `@retry(N)`** — Retry policy. Generates `__max_retries` (default 3), `__is_retryable`.
Use case: network request retries, transient failure handling, resilience patterns.

**`@timeout` / `@timeout(ms)`** — Timeout policy. Generates `__timeout_ms` (default 5000), `__has_timeout`.
Use case: HTTP request timeouts, operation deadlines, circuit breakers.

**`@singleton`** — Singleton marker. Generates `__is_singleton`, `__singleton_name`.
Use case: single-instance services, global state management, resource pools.

**`@observable`** — Observable marker. Generates `__is_observable`, `__observable_fields`.
Use case: reactive programming, change detection, data binding.

**`@async`** — Async marker. Generates `__is_async`.
Use case: async function identification, middleware that handles async differently.

**`@cache` / `@cache(ttl)`** — Cache policy. Generates `__is_cached`, `__cache_ttl` (default 60 seconds).
Use case: response caching, memoization with TTL, CDN cache control.

**`@event` / `@event("name")`** — Event handler. Generates `__event_name`, `__is_event_handler`.
Use case: event-driven architecture, pub/sub systems, webhook handlers.

---

## 19. Compiler Intelligence & Best Practices

NOVA's compiler (Hindley-Milner type inference, ownership analysis, escape analysis, constant folding) does enormous amounts of work so you don't have to. This section documents three things:
- **19.A** — What you can OMIT (keywords, annotations, syntax the compiler handles if missing)
- **19.B** — What the compiler DOES FOR YOU automatically (invisible behaviors)
- **19.C** — Syntactic sugar & shorthands not covered in sections 1–18
- **19.D** — What does NOT exist in NOVA (for developers coming from other languages)
- **19.E** — Complete best practices summary table

The rule of thumb: **the compiler is the genius, the developer writes clear code.** Omit ceremony that adds no information; annotate where it helps a reader or catches a mistake.

---

### 19.A — What You Can Omit

Everything in this table is OPTIONAL — the compiler handles it if you leave it out.

#### 19.A.1 `let` keyword

`let` is **not required**. Both `x = 42` and `let x = 42` compile to identical code.

```nova
x = 42              // works — compiler creates x as int
let x = 42          // also works — identical output
let x: int = 42     // explicit type — redundant but valid
```
**Best practice:** Write `let` — it signals "new variable" vs. "reassignment of existing one." Omit the type annotation on locals — the RHS documents the type. Exception: `let user: User = from_json(data)` triggers typed deserialization.

#### 19.A.2 `return` keyword (implicit return)

The **last expression** in a function body is automatically returned. No `return` needed.

```nova
fn double(x: int) -> int
    x * 2                    // auto-returned — no 'return' keyword

fn greet(name: string) -> string
    "Hello, {name}!"         // auto-returned
```
This works in regular functions, match arms, if/else tails, and lambdas. The compiler recurses into blocks and nested control flow to find the tail expression.

**Best practice:** Omit `return` for single-expression bodies and when the value is the natural last expression. Write `return` for early exits and multi-path functions where clarity helps.

#### 19.A.3 Type annotations on local variables

The compiler infers the type from the RHS expression.

```nova
let x = 42              // inferred: int
let name = "Alice"       // inferred: string
let users = []           // inferred: list
let point = Point(3, 4)  // inferred: Point
```
**Best practice:** Skip type annotations on locals. Write them only when the RHS is ambiguous or when using typed deserialization (`let p: Point = from_json(data)`).

#### 19.A.4 Type annotations on function parameters

Untyped parameters become type variables resolved at each call site.

```nova
fn double(x)        // x's type inferred from usage — works
fn double(x: int)   // explicit — catches misuse at compile time
```
**Best practice:** Always annotate parameter types on **public/exported functions** — untyped params silently accept `any`, deferring type errors to runtime. For private helpers and lambdas, omitting types is fine.

#### 19.A.5 Return type annotations

The compiler analyzes all return paths and infers the return type. If paths disagree, it widens to `any`.

```nova
fn add(a: int, b: int)          // return type inferred as int
fn add(a: int, b: int) -> int   // explicit — documents the contract
```
**Best practice:** Annotate return types on public functions (`-> T or Error`). Skip on private helpers.

#### 19.A.6 `f"..."` string prefix (all strings auto-interpolate)

The `f` prefix is purely cosmetic. ALL double-quoted strings in NOVA support `{expr}` interpolation. Both `"hello {name}"` and `f"hello {name}"` produce identical code.

```nova
"Hello, {name}!"        // interpolated — no f prefix needed
f"Hello, {name}!"       // identical — f is a historical alias
"Pi = {pi:.4f}"         // format specs work in both forms
```
**Best practice:** Omit `f` — all strings interpolate by default. Use `\{` to escape a literal brace.

#### 19.A.7 `self` parameter in struct methods

When you declare `fn Type.method(...)`, the compiler auto-injects `self` as the first parameter if you don't write it.

```nova
fn Point.magnitude() -> float                   // self auto-injected
    sqrt(self.x * self.x + self.y * self.y)

fn Point.magnitude(self: Point) -> float        // explicit self — same result
    sqrt(self.x * self.x + self.y * self.y)
```
**Best practice:** Omit `self` — the compiler injects it. Write it explicitly only if you need to annotate its type.

#### 19.A.8 `=` sign in `const` declarations

Both `const PI = 3.14` and `const PI 3.14` are valid — the `=` is optional.

**Best practice:** Write `=` for clarity: `const MAX_SIZE = 1024`.

#### 19.A.9 `else` branch in `if` statements

`else` is optional on `if`. Omit when there's no alternative action.

#### 19.A.10 Wildcard `_` in `match`

For non-enum types, a wildcard arm is optional. For enum/ADT types, the compiler checks exhaustiveness and warns if variants are uncovered. Add `_ =>` as a catch-all if you don't want to handle every variant explicitly.

#### 19.A.11 Trailing commas

Trailing commas are allowed in lists, dicts, function calls, function parameters, and struct initializers.

```nova
let items = [1, 2, 3,]        // trailing comma — valid
f(a, b, c,)                   // trailing comma — valid
```

#### 19.A.12 Generic constraints

Generic type parameters can be unconstrained or constrained with `: Trait`.

```nova
fn <T> identity(x: T) -> T            // unconstrained — any type
fn <T: Comparable> sort(xs: list<T>)   // constrained — T must be Comparable
```
**Best practice:** Omit constraints unless the function body uses trait-specific methods.

#### 19.A.13 `ok()` wrapper — NOT optional

Unlike the items above, `ok(value)` is **required** in Result-returning functions. There is no auto-wrapping. You must write `ok(value)` and `err(reason)` explicitly.

```nova
fn safe_divide(a: int, b: int) -> int or Error
    if b == 0
        return err("division by zero")
    ok(a / b)                    // ok() is REQUIRED — no auto-wrap
```

---

### 19.B — What the Compiler Does For You Automatically

These are invisible behaviors — the compiler generates code, inserts checks, or optimizes without you writing anything.

#### 19.B.1 1,335 builtins — no import needed

NOVA has 1,335 builtin functions available globally without any `import`. This includes: `print`, `len`, `push`, `pop`, `map`, `filter`, `sort`, `split`, `join`, `contains`, `keys`, `values`, `read_file`, `write_file`, `parse_int`, `range`, `str`, `int`, `float`, `copy`, `assert`, `type_of`, `exit`, `sleep`, `args`, `sha256`, `json_parse`, `json_stringify`, and hundreds more.

Only `std/` library modules and user modules need `import`. Builtins are free.

```nova
fn main()
    print("hello")          // no import needed
    let data = read_file("config.json")   // no import needed
    let parsed = json_parse(data)         // no import needed
```

#### 19.B.2 Automatic struct derivation (11 methods, zero annotation)

For EVERY struct, the compiler auto-generates:

| Auto-generated | What it does | How you use it |
|---|---|---|
| `show` | Pretty-prints `TypeName { field: value, ... }` | `print(p)` or `str(p)` |
| `to_json` | Serializes to JSON (nested structs recurse) | `json_stringify(p)` |
| `from_json` | Deserializes from JSON dict | `from_json(data)` as `Point` |
| `from_json_safe` | Safe deserialization → `Result<T, string>` | `from_json_safe(data)` as `Point` |
| `from_dict` | Construct from dict (DB rows, form bodies) | `from_dict(row)` as `User` |
| `from_dict_list` | Map list of dicts → `list<T>` | `from_dict_list(rows)` as `User` |
| `fields` | List of all field values | `p.fields()` → `[3, 4]` |
| `field_names` | List of field name strings | `Point.field_names()` → `["x", "y"]` |
| `field_types` | List of field type strings | `Point.field_types()` → `["int", "int"]` |
| `field_get` | Dynamic field access by name | `p.field_get("x")` → `3` |
| `type_name` | Returns struct's name as string | `p.type_name()` → `"Point"` |

Additionally, `==` (structural equality), `hash` (structural hash), and `copy()` (deep clone) work on ALL values universally. If you write `@derive`, the compiler gives a helpful error explaining that derivation is automatic. Use `@redact` to hide fields from `show`/`to_json`.

#### 19.B.3 Automatic reference counting

The compiler inserts `rc_inc`/`rc_dec` at assignment and scope exit. You never call `alloc`/`free`. Per-struct managed-slot bitmaps ensure only heap-pointer fields are decremented. In FULLRC mode, the compiler's pre-pass identifies always-owned never-escaped slots and inserts `rc_dec` on overwrite automatically.

#### 19.B.4 Automatic boxing/unboxing

When a typed value (float, bool) enters an `any`-typed slot, the compiler auto-inserts boxing:
- Function call args to `any`-typed params → `nova_rt_box_float`
- Channel send with float payload → auto-boxed
- `ok()`/`err()`/`some()` with float args → auto-boxed
- String interpolation → auto-boxed
- Lambda capture of float locals → auto-boxed
- `push(list, float)` → uses `list_append_fbox`

You just write `push(mylist, 3.14)` or `send(ch, temperature)` — boxing is invisible.

#### 19.B.5 Automatic string conversion

`print(anything)` works on any type — the runtime dispatches on the type tag. String interpolation `"value is {x}"` auto-converts each `{expr}` via `any_to_str` then concatenates. No `.toString()` or `__str__` needed.

#### 19.B.6 Automatic deep copy on channel send

`send(ch, value)` deep-copies the value. The runtime recursively copies lists, dicts, structs, and bytes. If the sent value is the last use (referenced exactly once), the compiler optimizes it to `send_move` (zero-copy transfer).

#### 19.B.7 Ownership and memory inference

No lifetime annotations, no borrow annotations, no manual allocation. Process isolation IS memory safety. Escape analysis for typed arrays. Auto-arena mode when no `spawn`. See section 19.A for what you omit; the compiler does all the rest.

#### 19.B.8 Process erasure

The compiler scans for `spawn`. If none found, ALL concurrency overhead is erased. Sequential code compiles to C-equivalent with zero overhead.

#### 19.B.9 Constant folding and `@comptime`

Three levels: (1) Module-level `let` with literals auto-inlined everywhere. (2) IR-level arithmetic on constants folded. (3) `@comptime` functions evaluated by a mini-interpreter. Also: `type_of(x)` folds to a constant string when the static type is known.

#### 19.B.10 UFCS (Uniform Function Call Syntax)

Any `fn f(x, ...)` can be called as `x.f(...)`. Resolution: struct method → module function → stdlib builtin → runtime function. Enables natural chaining: `data.filter(...).map(...).sort_by(...)`.

#### 19.B.11 Error context threading with `?`

`?` auto-captures the function name + source line, wraps the error with context, and propagates. You get stack-trace-like messages with zero manual wrapping.

#### 19.B.12 Pattern match exhaustiveness checking

For enum/ADT types, the compiler warns on uncovered variants.

#### 19.B.13 Lambda lifting and closure capture

The compiler identifies captured variables, packs them into a closure struct, lifts the lambda to a top-level function. Captured values use copy semantics (value at capture time).

#### 19.B.14 Unused Result warning

If a `Result`-returning function's return value is ignored, the compiler emits a warning with fix suggestions.

#### 19.B.15 Float specialization

The compiler tracks provably-float registers. When proven, `sqrt`, `abs`, `sin`, `cos`, `floor`, `ceil`, `round` are inlined to native LLVM intrinsics — zero call overhead.

#### 19.B.16 Struct operator dispatch

Define `index(self, i)` and `x[i]` works. Define `iter(self)` and `for item in x` works. Define `call(self, args...)` and `x(args)` works. Also: `+`, `-`, `*`, `==`, `<` dispatch to `Type__add`, `Type__sub`, etc. if defined.

#### 19.B.17 Automatic zero initialization

All local variables start as 0 (every `alloca i64` is followed by `store i64 0`). All heap allocations are zeroed. `null` compiles to literal `0`.

#### 19.B.18 Automatic bounds checking

All `list[i]` and `str[i]` access goes through runtime bounds checking. OOB reads return 0; OOB writes are silently dropped.

#### 19.B.19 Automatic string interning

String literals are deduplicated within a compilation unit. The runtime has a full intern table with FNV-1a hashing and thread-safe locking.

#### 19.B.20 Automatic module initialization and main detection

All top-level statements execute at program start. `fn main()` is auto-detected, renamed internally to `nova_user_main`, and called after module init. If no `main` exists but `@test` functions do, the compiler synthesizes a test runner automatically.

#### 19.B.21 Automatic test runner synthesis

When `@test` functions exist and no `main` is defined, the compiler generates a full test runner: calls each test, tallies passes/failures, prints results. Zero boilerplate.

#### 19.B.22 Automatic width wrapping for sized numerics

Operations on `u8`, `i16`, `u32`, etc. are automatically followed by mask/sign-extend to keep values in range. Unsigned wraps with `(1<<bits)-1`; signed uses `shl`/`ashr`.

#### 19.B.23 Automatic annotation-driven code generation

20 annotations processed at compile time in a fixed pipeline order via AST injection: `@ensures` → `@memo` → `@test` → routes → `@comptime` → `@deprecated` → `@inject` → `@middleware` → `@service` → `@entity` → `@singleton` → `@timeout` → `@retry` → `@log` → `@validate` → `@builder` → `@event` → `@cache` → `@async` → `@observable`. Each wraps/transforms the annotated function automatically.

#### 19.B.24 Automatic field coercion in `from_dict`

When constructing a struct from a dict (DB rows, form bodies), string values are auto-converted to the target field type (int, float, bool). No manual parsing needed.

---

### 19.C — Syntactic Sugar & Shorthands

These shorthands are not covered (or only briefly mentioned) in sections 1–18.

#### 19.C.1 Chained comparisons

`a < b < c` desugars to `(a < b) and (b < c)`. Works with all comparison ops.

```nova
if 0 <= x <= 100       // desugars to: 0 <= x and x <= 100
if a < b < c < d       // chains: a < b and b < c and c < d
```

#### 19.C.2 `matches` operator

`x matches Pattern` — boolean pattern-match test. Same precedence as comparisons.

```nova
if value matches Ok(v)
    print("success: {v}")
```

#### 19.C.3 `if let` pattern matching

`if let Pattern = expr` desugars to a `match` with two arms (pattern arm + wildcard else arm).

```nova
if let Ok(user) = find_user(id)
    print(user.name)
else
    print("not found")
```

#### 19.C.4 Multi-assign and swap

`a, b = b, a` uses temporaries for safe swap. Works with any number of variables.

```nova
a, b = b, a              // safe swap — no temp variable needed
x, y, z = 1, 2, 3        // parallel assignment
```

#### 19.C.5 `until` loop

`until cond` desugars to `while not cond`.

```nova
until done
    process_next()
```

#### 19.C.6 `for...else` and `while...else`

An `else` block on a loop runs if the loop completes WITHOUT hitting `break`.

```nova
for item in items
    if item == target
        print("found!")
        break
else
    print("not found")    // only runs if no break
```

#### 19.C.7 For-loop inline filter

`for x in iter if cond` filters the iteration inline.

```nova
for x in items if x > 0
    print(x)              // only items > 0
```

#### 19.C.8 `-> T or E` return type sugar

`fn f() -> int or Error` desugars to `fn f() -> Result<int, Error>`.

#### 19.C.9 Four lambda forms

All produce identical compiled code:
```nova
fn(x) x * 2              // fn-lambda
|x| x * 2                // bar-lambda
x => x * 2               // arrow-lambda
x =>                      // block-lambda (multi-line)
    let result = x * 2
    result
```

#### 19.C.10 `const` keyword

`const` declares compile-time constants. The `=` sign is optional.

```nova
const MAX_SIZE = 1024     // with =
const MAX_SIZE 1024       // without = — same result
```

#### 19.C.11 `let mut` for mutable bindings

Plain `let` is immutable. `let mut` marks a binding as mutable.

```nova
let x = 5                // immutable
let mut counter = 0       // mutable — can be reassigned
counter = counter + 1
```

#### 19.C.12 `T?` optional type sugar

`int?` desugars to `Option<int>`. Works on params, fields, let-types, and return types.

#### 19.C.13 `T...` variadic params

`fn log(args: string...)` collects trailing args into a list.

#### 19.C.14 Named arguments — two spellings

Both `name: value` and `name = value` accepted in function calls. Can mix with positional args.

```nova
greet(name: "Alice", greeting: "Hi")   // colon form
greet(name = "Alice", greeting = "Hi") // equals form — same result
```

---

### 19.D — What Does NOT Exist in NOVA

For developers coming from other languages — these features are absent by design:

| From | Feature | NOVA equivalent |
|---|---|---|
| C/C++/Java | Semicolons `;` | Newlines are statement separators. `;` is a lex error with a message. |
| C++/Java | `new` keyword | `Point(3, 4)` or `Point{x: 3, y: 4}` — constructors are calls. |
| Java/C# | `public`/`private`/`protected` | `_prefix` = private, no prefix = public. No other access levels. |
| Java/Go | `package`/`module` declaration | File = module, automatically. Module name = filename without `.nova`. |
| C/Java/Rust | Braces `{ }` for blocks | Indentation-based blocks (Python-style). Braces only for struct init, dict/set literals. |
| Python | `"a" * 3` string repeat | Use `str_mul("a", 3)` or `"a".str_mul(3)` via UFCS. |
| Rust/Haskell | `@derive(Show, Eq, ...)` | Automatic — `print`, `==`, `hash`, `json`, `copy` all just work. Writing `@derive` gives a helpful error. |
| Rust | Lifetime annotations `'a` | Never needed — process-based ownership. |
| C/C++ | `malloc`/`free` | Never needed — automatic reference counting. |
| Rust/C++ | Tail call optimization | Not implemented. All calls use regular stack frames. |
| Rust | `0..=5` inclusive range | Use `range_inclusive(0, 5)` builtin. |
| Most languages | Arity-based overloading | Not supported. Use guard clauses: `fn f(x) when x > 0` for dispatch. |
| Python/Ruby | `fn name` without parens | Parens required: `fn main()`. |
| Kotlin/Scala | Single-expression named fns | Named functions require indented body. Lambdas can be single-expression. |

---

### 19.E — Complete Best Practices Summary

| Feature | Required? | Best practice |
|---|---|---|
| `let` keyword | No — `x = 5` works | **Write `let`** — signals new variable |
| `return` keyword | No — last expr auto-returned | **Omit** for single-expression; **write** for early exits |
| Type on local `let` | No — compiler infers | **Skip** — RHS documents the type |
| Type on public fn params | No — inferred as `any` | **Write** — catches misuse at compile time |
| Return type on public fns | No — compiler infers | **Write** (`-> T or Error`) — documents the API |
| Return type on private fns | No — compiler infers | **Skip** — less noise |
| `f"..."` prefix | No — all strings interpolate | **Skip** — just use `"..."` |
| `self` in struct methods | No — auto-injected | **Skip** — compiler adds it |
| `=` in `const` | No — `const X 5` works | **Write `=`** for clarity |
| `ok()` wrapper | Yes — no auto-wrap | **Required** — always write `ok(value)` |
| `()` on fn declarations | Yes — always required | **Required** — `fn main()` not `fn main` |
| Semicolons | N/A — don't exist | **Never** — causes lex error |
| Generic `<T>` declarations | Yes for generic fns | **Write** — `fn <T> f(x: T)`, not untyped `fn f(x)` |
| Type args at call sites | Not supported | N/A — compiler always infers |
| `@derive(...)` | Not needed | **Never** — show/json/eq/hash/copy are automatic |
| Lifetime annotations | Not needed | **Never** — process ownership handles this |
| Memory management | Not needed | **Never** — RC is automatic |
| Error context in `?` | Automatic | **Never** wrap manually — compiler threads fn+line |
| `@redact` on sensitive fields | Optional | **Write** — hides passwords/tokens from show/json |
| `return` in `@comptime` | Required | **Write** — bare expression folds to 0 (Trap 2) |
| `let mut` for mutation | Yes if you reassign | **Write** — `let mut counter = 0` |
| Import for builtins | Not needed | **Never** — 1335 builtins are global |
| Import for std/ modules | Yes | **Write** — `import std/data/json` |

---

## Highest-leverage features to adopt first

These are the constructs most likely being hand-rolled today (as if/else + index loops + `any`+`type_of`) that this toolkit replaces:

1. **List / dict / set comprehensions** — `[x*2 for x in xs if x>3]` instead of a `for` + `push` loop.
2. **map / filter / reduce (+ UFCS chaining)** — `xs.filter(...).map(...)` instead of manual index loops.
3. **Pipe `|>`** — `xs |> filter(...) |> map(...)` instead of nested calls or throwaway temporaries.
4. **match + ADT destructuring + exhaustiveness** — `match shape { Circle(r) => ... }` instead of `if type_of(x) == ...` ladders; the compiler forces you to handle every case.
5. **Result + `?` + `with/else`** — one-word error propagation with automatic context threading, instead of manual error-check branching.
6. **String interpolation + format spec** — `"{n:04d} {name}"` instead of `"..." + str(...) + "..."` concatenation.
7. **for-in destructuring, enumerate, zip** — `for i, v in xs` and `xs.zip(ys)` instead of `for i in 0..len(xs)` index arithmetic.
8. **Automatic struct derivation** — `print(p)`, `p.to_json()`, `a == b`, `copy(a)` for free on every struct; never hand-write a serializer or equality method (and never reach for `@derive`).
9. **std/functional + std/itertools** — `fg_group_by`, `ftw_take_while`, `itw_pairwise`, `itc_chunk`, `ita_sums` instead of bespoke grouping/windowing/chunking loops.
10. **spawn + channels + selective receive** — cheap green-task concurrency (`spawn fn() ...`, `receive ... after`) instead of hand-rolled OS threads and shared mutable state.
11. **Lazy iterators** — `iter_range(0, 1000000) |> iter_filter(...) |> iter_take(5) |> iter_collect()` instead of allocating huge intermediate lists.
12. **Builtin data structures** — `pq_create()`, `lru_create(100)`, `deque_create()` instead of hand-rolling priority queues, caches, and deques.
13. **Tensor operations** — `tensor_matmul(a, b)`, `tensor_softmax(logits)` instead of manual matrix loops.

---

# PART II: TOOLCHAIN & CLI (sections 20–21)

These are NOT language features used in `.nova` source code. They are the **compiler commands and development tools** used to build, run, test, and manage NOVA projects.

---

## 20. CLI Commands

### Project management
| Command | Description |
|---|---|
| `nova new <name>` | Create project skeleton (options: `--api`, `--microservice`, `--frontend`, `--fullstack`, `--lib`; default: `--api`) |
| `nova init` | Create `nova.toml` in current directory |
| `nova setup` | Pre-compile runtime cache — run once after install, makes every build 38x faster (170ms vs 6500ms) |
| `nova clean` | Remove `.ll`, `.exe` build artifacts |

### Build & run
| Command | Description |
|---|---|
| `nova run [file]` | Build and run (default `-O0` for fast iteration) |
| `nova build [file]` | Build to executable (default `-O2` for production) |
| `nova compile <file>` | Compile to LLVM IR only (`.ll` output) |
| `nova emit <file>` | Print generated LLVM IR to stdout (`--asm` for native assembly, `--target <t>` for cross-compile) |
| `nova wasm <file>` | Compile to runnable WASM bundle (`.wasm` + `.run.cjs` + `_wasm_runtime.cjs`; options: `-o output`, `-O0`/`-O1`) |
| `nova eval "<expr>"` | Tree-walk interpret a single expression (no LLVM compile) |

### Build options (for `run` / `build` / `compile`)
| Option | Description |
|---|---|
| `-O0` | No optimization (default for `nova run`) |
| `-O2` | Full optimization (default for `nova build`) |
| `-o <path>` | Output file path |
| `--target <target>` | Cross-compilation target (see section 21) |
| `--old` | Use legacy non-IR compiler backend |

### Testing & quality
| Command | Description |
|---|---|
| `nova test` | Run all `*_test.nova` files in `tests/` and `./` |
| `nova bench <file>` | Build `-O2` then time N runs (min/mean/max; default 10 iterations, set with `-n`) |
| `nova cov <file>` | Build with coverage, run, report per-line coverage on exit (alias: `nova coverage`) |
| `nova check <file>` | Parse + type-check only (no codegen) — fast syntax/type verification |
| `nova lint <file>` | Static checks (tabs, line length, TODOs) |
| `nova fmt <file>` | Format source (whitespace normalization; alias: `nova format`) |

### Interactive & debugging
| Command | Description |
|---|---|
| `nova repl` | Start interactive shell (read-eval-print loop) |
| `nova debug <file>` | Build with debug info and launch `lldb` |
| `nova lsp` | Start LSP server for IDE integration (also `nova --lsp`) |

### Package management
| Command | Description |
|---|---|
| `nova get <package>[@ver]` | Add dependency to `nova.toml` |
| `nova install` | Download all dependencies from `nova.toml` |

### Utility
| Command | Description |
|---|---|
| `nova version` | Show version (also `nova --version`; current: v0.1.0) |
| `nova self-test` | Run compiler self-test |

---

## 21. Cross-Compilation Targets

Use `--target <value>` with `nova build` / `nova emit` / `nova compile`:

| `--target` value | LLVM triple | Platform |
|---|---|---|
| `native` / `windows` / `win` | `x86_64-pc-windows-msvc` | Windows x64 (default on Windows) |
| `linux` / `linux-x64` | `x86_64-unknown-linux-gnu` | Linux x64 |
| `linux-arm64` / `linux-aarch64` | `aarch64-unknown-linux-gnu` | Linux ARM64 |
| `macos` / `darwin` / `macos-x64` | `x86_64-apple-darwin` | macOS Intel |
| `macos-arm64` / `darwin-arm64` | `aarch64-apple-darwin` | macOS Apple Silicon |
| `wasm` / `wasm32` | `wasm32-unknown-unknown` | WebAssembly |

Any unrecognized value is passed through verbatim as a LLVM triple.

```bash
nova build myapp.nova --target linux          # cross-compile for Linux
nova build myapp.nova --target wasm           # compile to WebAssembly
nova emit myapp.nova --target macos-arm64     # inspect ARM64 IR
```

---

**MAINTENANCE RULE: when a language feature lands, add it to this file IN THE SAME COMMIT.**
A feature that is not written down is not reached for, so it stays untested and rots — which is
exactly how generics sat unused behind a syntax nobody could guess.
