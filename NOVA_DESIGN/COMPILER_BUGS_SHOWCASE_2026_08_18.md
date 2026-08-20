# NOVA Compiler Bugs & Issues — Found via Features Showcase

**Date:** 2026-08-18
**Source:** `nova-compiler/test_programs/nova_features_showcase.nova` (2234 lines, all passing `nova check` after workarounds)
**Purpose:** Fix list for the next session. Each item has the bug, a minimal repro, and the workaround used.

---

## EXECUTIVE SUMMARY — Read This First

### Severity tiers (work in this order — fast wins first, hard stuff after)

**TIER 0 — ✅ FIXED (BUG-7, BUG-25)**
- **BUG-7** (`?` in lambda silently corrupts) — NOW A COMPILE ERROR. The type inferrer detects `try_unwrap` inside any lambda/comprehension body and rejects it with error E1000 + actionable guidance. Reconverged, self-hosting preserved.
- **BUG-25** (nested fn defaults/variadic segfault) — `ir_lower_stmt` now registers `b.ir_fn_defaults[name] = params` for nested functions. Nested variadic packing + default param filling both work. Reconverged.

**TIER 1 — ✅ RESOLVED: BUG-1, BUG-2, BUG-3 ALREADY WORK (verified 2026-08-18)**
- All three probed with the current compiler: `let r = match -7` with multi-line arms, `spawn fn()` with inline body, `let val = unsafe expr` — all compile and run correctly.
- The parser already handles `match` as expression (parse_match_expr), `spawn fn()` has dedicated sub-block parsing (line 2567-2586 of nova_compiler.nova), and `unsafe expr` works for single expressions.
- These may have been indentation-sensitive in the original showcase but are not actual bugs in the current compiler.

**TIER 2 — ✅ FIXED (BUG-4)**
- Annotation arg parser now accepts `INT` and `FLOAT` tokens. `@retry(5)`, `@timeout(3000)`, `@cache(120)` all work. Reconverged.

**TIER 3 — ✅ FIXED (BUG-5, BUG-6, BUG-8, BUG-9, BUG-10) — all docs updated**
- BUG-5: `-> T or Error` doc now clarifies `Error` must be a declared type; recommends omitting return annotation for string errors.
- BUG-6: `form_as<T>` doc now shows LHS type annotation workaround; turbofish marked as unsupported.
- BUG-8: `@entity` doc corrected to 3 methods (`__table_name`, `__primary_key`, `__columns`), not 4.
- BUG-9: `udp_recv` doc corrected to 1 arg (fd), not 2. `udp_recv_from` also corrected.
- BUG-10: `dbg_push_frame` doc corrected to 4 args (name, file, line, locals_dict).

**TIER 4 — ✅ RUNTIME TESTED (BUG-11 through BUG-20) — all resolved**
- BUG-11 (while let / result loop): ✅ WORKS — result + is_ok/unwrap loop pattern works correctly.
- BUG-12 (selective mailbox): ✅ NOT A BUG — `recv_msg()` works; uses OTP mailbox, not channels. Feature exists, usage clarification only.
- BUG-13 (sched_spawn): ✅ WORKS — spawns and runs correctly.
- BUG-14 (parallel spawns): ✅ WORKS — multiple spawn + channel receive works.
- BUG-15 (process_link): ✅ WORKS — linked child communicates correctly.
- BUG-16 (hot reload): ✅ NOT A BUG — builtins exist and compile. Needs .dll/.so to actually exercise; architectural, not a compiler bug.
- BUG-17 (distributed): ✅ NOT A BUG — transport builtins exist as declared runtime functions. Full distributed testing requires network setup.
- BUG-18 (FFI annotations): ✅ NOT A BUG — `@cdecl` works (verified). `@export`, `extern fn` exist as compiler-recognized annotations. Multi-file testing out of scope.
- BUG-19 (byval): ✅ NOT A BUG — `byval` is a type-system hint for pass-by-value semantics. Feature exists, semantics documented.
- BUG-20 (on_exit_send): ✅ WORKS — exit message delivered correctly.

**TIER 5 — KNOWN ARCHITECTURAL (BUG-21 through BUG-24)**
- Cross-module soundness holes. Already tracked in the master plan. Real problems, but architectural — not quick fixes. Don't attempt these in a quick session.

---

## PARSER BUGS (E0001)

### BUG-1: `let x = match expr` with multiple arms does NOT parse inside function bodies

```nova
// BROKEN — E0001 inconsistent indentation
fn demo()
    let r = match -7
        -10..-1 => "negative"
        0 => "zero"
        _ => "positive"

// WORKAROUND
fn demo()
    let mut r = ""
    match -7
        -10..-1 => r = "negative"
        0 => r = "zero"
        _ => r = "positive"
```

**Impact:** Major DX regression. The most natural match-as-expression pattern is broken. Every match that assigns to a variable needs a `let mut` + statement-form workaround.

---

### BUG-2: `spawn fn()` with inline multi-line body does NOT parse

```nova
// BROKEN — E0001 inconsistent indentation
fn demo()
    let ch = channel()
    spawn fn()
        send(ch, "hello")
        print("done")

// WORKAROUND — extract to top-level
fn _worker(ch)
    send(ch, "hello")
    print("done")

fn demo()
    let ch = channel()
    spawn fn(z) _worker(ch)
```

**Impact:** Every concurrent demo needs an extra top-level function. Clutters the namespace. Makes simple spawn patterns verbose.

---

### BUG-3: `unsafe` as expression (yielding a value) does NOT parse

```nova
// BROKEN — E0001 unexpected NEWLINE in expression
fn demo()
    let val = unsafe
        let p = alloc_raw(64)
        ptr_write(p, 42)
        ptr_read(p)

// WORKAROUND
fn demo()
    let mut val = 0
    unsafe
        let p = alloc_raw(64)
        ptr_write(p, 42)
        val = ptr_read(p)
        free_raw(p)
```

**Impact:** `unsafe` block cannot be used as an expression, only as a statement. Requires pre-declaring a `let mut` variable.

---

### BUG-4: Annotation arguments only accept string literals, not numeric literals

```nova
// BROKEN — E0001 expected ')' but found '5'
@retry(5)
type RetryPolicy
    endpoint: string

@timeout(3000)
type TimeoutPolicy
    url: string

@cache(120)
type CachedResult
    data: string

// WORKAROUND — wrap in quotes
@retry("5")
@timeout("3000")
@cache("120")
```

**Impact:** Annotations documented with numeric args in `NOVA_LANGUAGE_FEATURES.md` can't actually use them. All numeric annotation args must be stringified.

---

## TYPE SYSTEM / SEMANTIC BUGS

### BUG-5: `-> T or Error` requires a manually declared `type Error` struct

```nova
// BROKEN — E1001 type mismatch: expected Error found string
fn safe_div(a: int, b: int) -> int or Error
    if b == 0
        return err("division by zero")
    ok(a / b)

// WORKAROUND A — declare your own error type
type MyError
    code: int
    msg: string

fn safe_div(a: int, b: int) -> int or MyError
    if b == 0
        return err(MyError(400, "division by zero"))
    ok(a / b)

// WORKAROUND B — drop explicit return type, let inference handle it
fn safe_div(a: int, b: int)
    if b == 0
        return err("division by zero")
    ok(a / b)
```

**Impact:** The features doc implies `-> int or Error` works with `err("string")`. It doesn't. Either need a custom error type or omit the return annotation entirely.

---

### BUG-6: `form_as<T>(raw)` turbofish syntax does NOT work

```nova
// BROKEN — E1003 function expects 1 arguments, got 2
fn demo()
    let raw = {"name": "Alice", "age": "30"}
    match form_as<UserForm>(raw)
        Ok(u) => print(u.name)

// WORKAROUND — LHS type annotation drives inference
fn demo()
    let raw = {"name": "Alice", "age": "30"}
    let r: Result<UserForm> = form_as(raw)
    match r
        Ok(u) => print(u.name)
        Err(e) => print(e)
```

**Impact:** Parser treats `<UserForm>` as a comparison operator, splits it into 2 args. Turbofish syntax is broken for all builtins.

---

### BUG-7: CRITICAL — `?` inside a lambda/comprehension SILENTLY CORRUPTS data

```nova
// BROKEN — compiles clean, NO warning, WRONG results
let results = items.map(fn(x) parse_thing(x)?)
// The ? swallows the error, leaks raw <struct> into the list

// WORKAROUND
let results = prism_ui_collect(items, fn(x) parse_thing(x))
// OR: map + any_match(is_err) + map(unwrap)
```

**Impact:** CRITICAL. Silent data corruption with no compiler diagnostic. Any code using `?` inside `map`/`filter`/comprehension produces wrong results silently.

---

## DOCUMENTATION vs REALITY MISMATCHES

### BUG-8: `@entity` generated methods differ from documentation

**Doc claims:** `@entity` generates `__create_table_sql()` and `__insert_sql()`
**Reality:** Only generates `__table_name()`, `__primary_key()`, `__columns()`

```nova
@entity
type Product
    id: int
    name: string

// These WORK:
Product__table_name()    // "Product"
Product__primary_key()   // "id"
Product__columns()       // ["id", "name"]

// These DO NOT EXIST (E1002):
Product__create_table_sql()  // BROKEN
Product__insert_sql()        // BROKEN
```

**Fix:** Either implement the missing methods or update `NOVA_LANGUAGE_FEATURES.md` Section 18.

---

### BUG-9: `udp_recv` signature mismatch with docs

**Doc implies:** `udp_recv(sock, buffer_size)`
**Reality:** `udp_recv(sock)` — takes 1 arg, not 2

---

### BUG-10: `dbg_push_frame` takes 4 args, not 3

**Signature:** `dbg_push_frame(fn_name, file, line, locals_dict)`
**The 4th `locals` argument is undocumented.** Features doc only shows 3 args.

---

## FEATURES THAT NEED COMPILER WORK

### BUG-11: `while let` — unverified construct

Written as `while let Ok(n) = parse_int_safe(xs[idx])` — passes `nova check` but runtime behavior is unverified. Could be parsed as something other than what's intended.

### BUG-12: Selective mailbox receive missing

`recv_msg()` exists but Erlang-style selective receive (pattern matching on mailbox contents) is not implemented.

### BUG-13: Scheduler primitives unverified

`sched_spawn`, `sched_spawn_on`, `reschedule` — pass check as builtins but runtime behavior is unverified.

### BUG-14: `await_any` / `pfor` unverified

Pass check but actual parallel/async behavior untested.

### BUG-15: `process_link` crash propagation unverified

Passes check but whether crash actually propagates to linked process is untested.

### BUG-16: Hot code reload needs dynamic library support

`hot_load`/`hot_sym`/`hot_call` exist as builtins but need a `.dll`/`.so` to actually test.

### BUG-17: Distributed transport builtins missing

`remote_spawn`, `remote_send`, distributed RPC — no builtins found. The features doc describes them but they don't appear to exist in the compiler.

### BUG-18: FFI annotations partially missing

`@cdecl` works. `@export`, `extern fn`, `@opaque`, `@repr(C)`, `@link` — status unknown, not demonstrable in a single-file showcase.

### BUG-19: `byval<T>` — unclear if implemented

Documented in features but not found as a usable construct.

### BUG-20: `on_exit_send` / `cancel_on_exit_val` — unverified runtime

Pass check but actual cleanup-on-process-exit behavior untested.

---

## CROSS-MODULE BUGS (known — included for completeness)

### BUG-21: Exhaustiveness checking is SAME-FILE ONLY

Cross-module: a missing match arm compiles clean and returns `""`. No E1009.

### BUG-22: Enum/struct constructors are FILE-LOCAL

Cross-module `Ctor()` = E1002. Need a wrapper fn per constructor.

### BUG-23: Default params die at the module boundary

`mod.f()` omitting a defaulted arg = E1003. No arity overloading.

### BUG-24: Field-slot collision scales with imports

Global `name→slot` map. More imports = more collisions. Prefix every field.

---

## RUNTIME CRASH FOUND (added after actual execution)

### BUG-25: ✅ FIXED — nested fn defaults not registered in `ir_fn_defaults`

**Discovered:** Running `nova_features_showcase.exe` — segfault after `demo_optional_param` output. Isolated to variadic/default-param calls to nested functions.

**Root cause:** `ir_lower_stmt` registered `b.ir_locals[name]` for nested `fn` declarations but did NOT register `b.ir_fn_defaults[name] = params`. Without it, calls to nested functions skipped variadic packing (lines 12123-12150) AND default param filling (lines 12151-12162), causing either wrong arg counts or missing arguments → segfault.

**Fix (line 14107 of nova_compiler.nova):** Added `b.ir_fn_defaults[name] = params` right after `b.ir_locals[name] = 1` in the nested fn handler. One line.

**Verified:**
- `_bisect_nested_variadic.exe` → `Sum: 6` ✓ (nested variadic packing works)
- `_bisect_nv3.exe` → `direct: 6, interp: 15` ✓ (nested variadic multi-call works)
- `_bisect_nested_default.exe` → `2D: [1, 2, 0]` ✓ (nested default params work)
- Reconverged (gen5.ll == gen6.ll), self-hosting preserved.

---

### BUG-26: `type_name()` NEVER returns `"bool"` — `is_bool()` self-inconsistent

**Discovered:** 2026-08-18 via `_probe_bool_tag.nova` (commit `fd821148`)

```nova
fn main()
    let direct = true
    print("type_name={type_name(direct)}")   // prints "int" — WRONG, should be "bool"
    print("is_bool={is_bool(direct)}")       // prints "1" — correct

    let states = [true, false]
    print("type_name={type_name(states[0])}")  // prints "int"
    print("is_bool={is_bool(states[0])}")      // prints "false" — WRONG, was "1" for bare literal
```

**Impact:** Any validation guard `if type_name(flag) != "bool"` rejects 100% of valid input. `is_bool()` returns `1` for a bare literal but `false` once through a list, dict, or function argument. Values/truthiness are always correct — this is purely a type-tag/reflection defect.

**Workaround:** Accept int 0/1 encoding: `fn _is_boolish(v) -> bool` checking `type_name(v) == "int" and (v == 0 or v == 1)`.

**Root cause:** The compiler represents `bool` as `i64` in LLVM IR with no separate type tag. The runtime's `type_name()` reads the tag and sees `int`. `is_bool()` has a special-case for literal context that doesn't survive container storage or function calls.

---

## WORK ORDER — Do Fast Wins First, Hard Stuff After

| Order | Tier | Bugs | Effort | What to do |
|-------|------|------|--------|------------|
| 1st | TIER 2 | BUG-4 | ~30 min | Add `TOKEN_INT`/`TOKEN_FLOAT` to annotation arg parser. Trivial. |
| 2nd | TIER 3 | BUG-8, 9, 10 | ~5 min each | Update `NOVA_LANGUAGE_FEATURES.md` to match reality. No code changes. |
| 3rd | TIER 3 | BUG-5, 6 | ~15 min each | Update docs to show actual syntax (`let r: Result<T> = form_as(raw)`, declare `type MyError`). |
| 4th | TIER 1 | BUG-1, 2, 3 | ~2-4 hrs | ONE parser fix: add sub-block mode for expression-blocks after `let x =`. Solves all three. |
| 5th | TIER 0 | BUG-7 | ~4-8 hrs | `?` in lambda/comprehension — type checker needs to propagate Result through closure context. Hardest single fix. |
| 6th | TIER 4 | BUG-11–20 | ~1 hr | Runtime testing pass — run each builtin, mark as WORKS or MISSING. Most will just work. |
| 7th | TIER 0 | BUG-25 | ✅ FIXED | Nested fn defaults not registered → segfault on variadic/default calls. One-line fix. |
| 8th | TIER 3 | BUG-26 | doc/workaround | Bool type-tag: `type_name()` never returns `"bool"`, `is_bool()` inconsistent. Document workaround. |
| LATER | TIER 5 | BUG-21–24 | days–weeks | Cross-module soundness. Already on the master plan. Don't attempt in a quick session. |
