# std/core — NOVA's high-level standard library core

These modules are written in **NOVA's high-level style** — generic functions
(`fn <T> ...`), closures passed as first-class arguments, and `Result`/`Option`
with `match` — not `any` + `type_of` + manual loops. They are the reference for
how new NOVA code should be written, and they compose: see
`nova-compiler/test_programs/_kat_stdcore_demo.nova` for a pipeline using seven of
them together.

> This became possible after the 2026-07 inference fixes: a bare `Result`/`Option`
> annotation is now a polymorphic sum, so a reusable helper that returns or takes a
> `Result`/`Option` composes across call sites. Before that, factoring high-level
> logic into a library helper broke — which is why the older stdlib is low-level.

## Modules

| Module | Import | Highlights |
|--------|--------|-----------|
| **seq**    | `import std/core/seq`    | `seq_map` `seq_filter` `seq_fold` `seq_reduce`(→Result) `seq_find`(→Result) `seq_any` `seq_all` `seq_count` `seq_take` `seq_drop` `seq_zip` `seq_reverse` `seq_flat_map` |
| **list**   | `import std/core/list`   | `list_contains` `list_index_of` `list_unique` `list_concat` `list_flatten` `list_sum` `list_chunk` |
| **dict**   | `import std/core/dict`   | `dict_get_or` (typed default — closes the missing-key→0 footgun) `dict_keys_where` `dict_map_values` `dict_merge` `dict_count` `dict_any_value` |
| **num**    | `import std/core/num`    | `int_abs` `int_sign` `int_clamp` `int_min` `int_max` `int_gcd` `int_lcm` `int_pow` `int_is_even` `int_is_odd` |
| **str**    | `import std/core/str`    | `str_reverse` `str_repeat` `str_pad_left` `str_pad_right` `str_count` `str_char_at` |
| **sort**   | `import std/core/sort`   | `sort_ints` `sort_ints_desc` `sort_strings` `sort_by`(less-closure) |
| **result** | `import std/core/result` | `result_is_ok` `result_is_err` `result_unwrap_or` `result_unwrap_or_else` `result_map` `result_map_err` `result_and_then` |
| **opt**    | `import std/core/opt`    | `opt_is_some` `opt_is_none` `opt_unwrap_or` `opt_map` `opt_filter` |

## Coding standard (what these demonstrate)

- **Closures as arguments**: `seq_filter(xs, fn(x) x >= 70)`, `sort_by(xs, fn(a, b) a > b)`.
- **`Result` / `match` for fallible ops** instead of `{"ok": 0}` dicts:
  `match seq_reduce(xs, fn(a, x) int_max(a, x)) { Ok(v) => .. Err(e) => .. }`.
- **Generics** for reusable, type-directed helpers: `fn <T> seq_count(xs: list<T>, pred) -> int`.
- **`any` only where the value is genuinely dynamic** — e.g. `dict_get_or` returns
  `any` because a dict value is dynamically typed; a fold accumulator is `any`
  because it flows through the caller's untyped closure. Not as a default.

## Known limitation

Put shared state and its readers **inside functions**, not at module top level:
a top-level non-scalar `let` (list/dict/struct) does not yet propagate into a
function's reads at runtime (a scalar top-level `let` does, via const-folding).
This is a tracked module-scope-storage gap.
