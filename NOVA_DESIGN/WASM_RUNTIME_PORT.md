# WASM Runtime Port — assessment + plan (2026-06-27)

## Status (REAL, gated)
- **Compute subset** (`_wasm_one.sh`, commit ceac8a6): NOVA fns the type-specializer lowers to native
  i64/f64 ops (no `nova_rt_*` calls) compile straight to wasm32 via `clang --target=wasm32` on the `.ll`
  and run in node V8. `add/mul/poly` = 5/20/43. No runtime needed.
- **String-literal subset** (`_wasm_str_one.sh`, this commit): a NOVA fn that takes the LENGTH of a string
  **literal** runs in wasm via a MINIMAL runtime (`_wrt_min.c` = `nova_rt_len_any` = strlen). A literal is a
  bare `char*` in the wasm data segment (the compiler emits `getelementptr @.str.0` then `len_any`, NOT
  `create_string`), so `len`/`len_any` just measures it. `hello_len`=5, `combined`=14.

## The gap (what does NOT work yet)
Heap-allocated values: BUILDING strings (`create_string`, `str_concat`, `upper`, ...), lists, dicts,
structs. These need the value-model runtime (heap + `find_tag` + RC + the FAT_STR/list/dict layout) running
in wasm.

## Blockers found
1. **No libc for wasm offline.** `clang --target=wasm32 -nostdlib` and `--target=wasm32-wasi` both fail at
   `'stdio.h' file not found` — there is no wasi-sysroot installed and we are offline (can't download
   wasi-libc). So `nova_runtime.c` (which `#include`s stdio/stdlib/string + winsock/pthread/windows) cannot
   be compiled to wasm as-is.
2. **clang -O2 loop-idiom** rewrites a hand-written `while(s[n])n++` into a call to libc `strlen` (an
   undefined import) -> at runtime node throws "Cannot convert a BigInt value to a number" (the dummy i64
   import vs strlen's i32 return). FIX: compile the wasm runtime with **`-fno-builtin`**.
3. **`find_tag` literal detection is Windows-coupled** (PE `SizeOfImage` module range, `nova_addr_in_module`)
   — wasm has no module range. Only matters for bare literals; materialized (headered) strings detect by
   their header.

## The path (the runtime ALREADY has the hook)
`nova_heap_alloc` has a `#ifdef NOVA_FREESTANDING` branch: a static bump allocator (`nova_fs_heap`), NO
libc malloc. So the value allocator is already wasm-ready. To get heap strings/lists in wasm:

1. **Provide libc primitives WITHOUT system headers.** Build the value-model subset with `-ffreestanding
   -nostdlib -fno-builtin` and supply tiny `strlen/memcpy/memmove/memset/strcmp` (clang lowers struct
   copies to `memcpy`, so memcpy must exist). No stdio/stdlib needed once `NOVA_FREESTANDING` is on.
2. **Carve the value-model subset into a wasm-compilable unit** (preferred over #ifdef-ing the whole 948KB
   file): a new `output/nova_runtime_wasm.c` that `#define NOVA_FREESTANDING` + `#include` ONLY the value-
   model section (the RC header, `nova_mem_find_tag`, `nova_heap_alloc`, FAT_STR/list/dict structs +
   `create_string`/`str_concat`/`list_*`/`dict_*`/`len_any`/`index_get` + the soundness guards). Exclude
   sockets/threads/fibers/netpoller/offload/file-IO/`os_random`(CryptGenRandom)/the scheduler. (Many already
   sit behind `#ifdef _WIN32`; the POSIX `#else` sockets/pthread includes are the ones to gate behind a new
   `#ifndef NOVA_FREESTANDING`.)
3. **Adapt `find_tag` for wasm**: drop the module-range literal branch under `NOVA_FREESTANDING` (a wasm
   program either materializes literals via `create_string`, or we add a data-segment range check analogous
   to `nova_track_heap_bounds`). Headered heap strings/lists/dicts detect by their RC/FAT header — unchanged.
4. **Entropy**: `os_random` (CryptGenRandom) is unavailable in wasm -> import a JS `crypto.getRandomValues`
   from node/the browser as the wasm `nova_rt_os_random` (a clean host import; matches the fail-closed
   contract — abort if the host doesn't provide it).
5. **Link** the value-model wasm `.o` with a NOVA program's `.ll` via `wasm-ld` (`--no-entry --export-all
   --allow-undefined` for the excluded I/O fns, which a pure-compute/data program never calls).

## Recommended NEXT real value-model step
Get `create_string` + `str_concat` + the FAT_STR `find_tag` branch + `NOVA_FREESTANDING` `nova_heap_alloc`
compiling to wasm (no system headers, tiny memcpy/strlen) so a NOVA fn that BUILDS a string
(`"a" + "b" + "c"`) and measures it runs in wasm. That proves the heap value-model in wasm and is the
gateway to lists/dicts. Then structs, then the AI-tensor/compute kernels that are the real browser story.

## Tools present
clang wasm32 backend ✓, wasm-ld ✓, node v20 (V8 WASM, i64<->BigInt) ✓. wasi-libc ✗ (offline). Always
`-fno-builtin`. i64 args/returns are BigInt at the JS boundary.
