# Arena correctness bug: split() corrupts inside an arena scope (found iter-99)

**Status:** OPEN — tracked, needs a focused runtime-level investigation. NOT fixed.
**Severity:** HIGH (silent wrong output, not a crash). NARROW + specific (see below).
**Date:** 2026-06-15 (iter-99, while building the Forge router on the arena).

## Symptom
Inside an arena scope (`arena_enter()` .. `arena_exit()`), `split()` returns the right
element COUNT but CORRUPTED element strings:

```
noarena: split("/users/42","/") -> len=3 ["", "users", "42"]          (correct)
arena:   split("/users/42","/") -> len=3 ["\xNN", "=", "v"]           (GARBAGE elements)
```

This broke the Forge router: `_fr_match` splits the path, so dispatch inside
`serve_n_arena` never matched any route ("no route: GET /") even though the routes
were present (`routes=2` confirmed at dispatch time).

## Isolation (what is and isn't affected)
- ✅ A SINGLE arena RAW string (`slice("hello world",0,5)` inside a scope) -> "hello" CORRECT.
- ✅ An arena LIST of HEAP strings (`push(L, "a"+"X")` — concat makes a heap fat string) -> CORRECT.
- ✅ An arena DICT of HEAP strings -> CORRECT.
- ❌ `split` — an arena list built while INTERLEAVING multiple arena RAW-string allocations
  (`nova_rt_split` uses `nova_heap_alloc(n+1, NOVA_MEM_RAW)` per part + `list_append`) -> CORRUPT.

So it is NOT "all arena string ops" and NOT the container backing (iter-91/92, validated).
It is the SPECIFIC interleaving of arena list-data + multiple arena RAW strings + appends.
Likely also affects: `splitlines`, `regex_split`, `regex_find_all`, JSON decode of arrays —
any builtin that builds a list of MULTIPLE `nova_heap_alloc(RAW)` parts inside a scope.

## Why prior arena tests missed it
- `_arena_demo.nova` (iter-93) used `"item-"+str(i)` (concat -> HEAP fat string) + make_list/
  dict literals — never `split`/multiple-arena-RAW-in-a-list -> it was both flat AND correct.
- `_forge_arena_readiness.nova` (iter-95) measured ONLY `live_count` (flat, 16359->0) and never
  asserted RESPONSE CONTENT; its handler used `slice` (single RAW, fine) + `concat` (heap, fine),
  not `split`. So the "flat-memory server PROVEN" claim is correct on MEMORY but was never a
  CONTENT-correctness proof. HONEST CORRECTION: the arena's flat-memory mechanism is real, but
  it is NOT correctness-sound for handlers that `split` (or similar) until this bug is fixed.

## Root-cause hypothesis (unconfirmed — needs runtime debugging, not reasoning)
The bump interleaving of the list's arena data array (`nova_back_alloc`) and the per-part arena
RAW strings (`nova_heap_alloc` arena branch), with `list_append` storing the part pointers,
produces corrupted element content. Single-RAW and heap-element cases work, so it is the
combination. Reasoning could not localize it; it needs a debug build that prints the actual
base/user pointers + the stored `data[i]` values across the split loop (lldb @
/c/Program Files/LLVM/bin/lldb, or printf in nova_rt_split / nova_arena_bump / nova_heap_alloc).

## Mitigation in place (iter-99)
`forge.serve_app_n` / `serve_app` use the CORRECT non-arena `serve_n` / `serve` (a router
handler does path-`split` work, so it must not run arena-scoped until the bug is fixed). This is
correct but leaks per request (the pre-arena ~41 obj/req). The arena flat-memory path
(`serve_n_arena`) stays available for NON-split handlers but must NOT be the routed default
until fixed. Repro probes are in the iter-99 transcript (split-in-arena vs slice/heap-list).

## Next
A focused arena-correctness investigation (runtime debugging) to root-cause + fix, then re-point
`serve_app_n` at `serve_n_arena` and add a CONTENT-asserting arena server test (not leak-only).
This is the prerequisite to the arena delivering correct+flat per-request memory for real
(string-heavy) handlers.
