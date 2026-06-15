# Arena correctness bug: split() corrupts inside an arena scope (found AND FIXED iter-99/100)

**Status:** ✅ FIXED 2026-06-15 (iter-100, same session). Root-caused via runtime printf.
**Severity:** WAS HIGH (silent wrong output). NARROW + specific.
**Date:** found iter-99 (building the Forge router), fixed iter-100.

## ✅ ROOT CAUSE + FIX (the decisive finding)
Runtime instrumentation showed the parts were CORRECT at `split` return
(`data[1]=...2CC0 [users]`) but read back as GARBAGE in the caller (`p[1]=[,]` =
0x2C = a BYTE OF THE POINTER `...782CC0`). So an `any`-typed list element was being
read as an INTEGER/pointer, not a string. WHY: `nova_arena_bump` / `nova_arena_new_chunk`
never called `nova_track_heap_bounds`, so arena objects fell OUTSIDE `[heap_base,
heap_top]`. `nova_mem_find_tag` range-REJECTS out-of-range addresses -> for an `any`-typed
value, runtime type dispatch saw the arena RAW string as "not a managed object" -> treated
it as a bare int -> read the pointer's bytes as content. (`slice` worked because its result
is STATICALLY typed `string` -> no `find_tag` dispatch; the bug only bit `any`-typed arena
objects, e.g. a list element from split.)

**FIX (one line, nova_arena_new_chunk):** `nova_track_heap_bounds(c->data, c->data + cap)`
when a chunk is created -> find_tag RANGE-ACCEPTS arena objects and classifies them by
magic/tag. The `NOVA_RC_ARENA_BIT` in the rc field still makes `rc_inc`/`rc_dec` no-op
(a SEPARATE check), so arena objects are still never individually freed -- the arena frees
them wholesale. VERIFIED: arena `split("/users/42","/")` -> `["", "users", "42"]` correct;
forge router on `serve_n_arena` (which splits paths) PASSES + ASAN clean; arena demo flat
(delta=0). `serve_app_n` re-pointed to `serve_n_arena` (flat + now correct).

## LESSON
The arena is now correctness-validated, not just leak-validated: a CONTENT-asserting test
(the forge router over a real socket through serve_n_arena) is the guard. The original
iter-95 leak-only "proof" is now backed by content correctness.

---
## (Original investigation, kept for the record)

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
