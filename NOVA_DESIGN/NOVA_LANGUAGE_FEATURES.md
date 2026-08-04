# NOVA Language Feature Reference

This is the authoritative catalog of NOVA's high-level features. Write NOVA from THIS toolkit by default — reach for the highest-level construct that fits, not hand-rolled if/else + index loops + any+type_of. Every example here was verified against the live parser/stdlib.

Sourced from a 5-agent feature audit (242 raw entries) deduplicated into the sections below. When two constructs overlap, the entry lives in its most natural home and is cross-referenced rather than repeated.

**Sections 1–5** are that audit (2026-07-25). **Section 6** lists everything added since, each
entry verified by EXECUTING a probe program; where the two disagree, section 6 wins. **Section 7**
is the trap list — read it before writing NOVA, it is short and every item cost real time.

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

---

## 6. Added since the original audit (2026-07-25 → 2026-08-04)

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

9. **Enum variant constructors return the VARIANT type, not the enum type** — a function that
   `match`es over an enum usually leaves its parameter unannotated (`fn area(s)`).

---

**MAINTENANCE RULE: when a language feature lands, add it to this file IN THE SAME COMMIT.**
A feature that is not written down is not reached for, so it stays untested and rots — which is
exactly how generics sat unused behind a syntax nobody could guess.
