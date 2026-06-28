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

---
## EXECUTION CHECKLIST (verified 2026-06-28 against nova_runtime.c @ 20462 lines)

### Approach decision: IN-PLACE `#ifndef NOVA_FREESTANDING` gating (not a separate line-range unit)
The doc above floated "a new nova_runtime_wasm.c that #includes ONLY the value-model section." VERIFIED that
won't work cleanly: the value-model fns are SCATTERED (L253-938 tags/boxing, L1135-2835 str/list/dict/arena,
L9591-9781 RC, L17031-17139 arena) and interleaved with I/O. And the I/O fns can't merely be dead-stripped --
they FAIL TO COMPILE under wasm (no stdio/socket/pthread headers). So they must be gated regardless. Therefore:
- Gate the SYSTEM includes + every I/O/OS/socket/thread/scheduler section IN PLACE behind `#ifndef NOVA_FREESTANDING`.
- `output/nova_runtime_wasm.c` = `#define NOVA_FREESTANDING` + tiny libc stubs + `#include "nova_runtime.c"`.
- Compile that ONE unit: `clang --target=wasm32 -ffreestanding -nostdlib -fno-builtin -O2 -c`.
- NATIVE stays byte-identical: every gate is `#ifndef NOVA_FREESTANDING` (native, flag absent, includes all as
  before). VERIFY each step by recompiling nova_runtime.o native + byte-diffing the .o (or rerunning a forge
  test). This is the hard invariant.

### Verified facts
- 20462 lines. System includes L1-10 (stdio,stdlib,string,time,stdint,stddef,math,ctype,errno,setjmp); keep
  stdint/stddef/setjmp bare (no OS). Win32 block L12-27, POSIX block L31-51 (pthread/socket/dlfcn/execinfo/openssl).
- Existing scaffolding (minimal): L618-631 `nova_heap_alloc` freestanding bump branch (returns early, tags ARENA
  -> rc_dec no-op, static 8MB buffer, -DNOVA_FS_HEAP_SIZE override) + L9807 cleanup-profiler gate. That's ALL.

### Gate list (wrap each in `#ifndef NOVA_FREESTANDING`; line #s approximate -- CONFIRM at edit time)
1. Includes L1-10 (keep stdint/stddef/setjmp bare), Win32 L12-27, POSIX L31-51.
2. find_tag (L713-791): drop the Windows `IsBadReadPtr` (~L733) + POSIX page-probe (`nova_probe_cstr` ~L977-988,
   `nova_is_readable_str` POSIX path) -> wasm uses range+alignment+magic only (linear memory, no guard pages).
3. nova_rt_aligned_struct_alloc (L672-693): add NOVA_FREESTANDING path -> plain nova_rt_struct_alloc (ignore align).
4. RC: nova_rc_inc/dec (L9721-9781) -> non-atomic N=1 path under freestanding; rc_free channel-cleanup case
   (~L9638-9663, DeleteCriticalSection/pthread_mutex_destroy) gate out (channels excluded).
5. EXCLUDE entirely (gate): exit/system/exec L2958-3007; process L3024-3098; stdin/out/err L3262-3300; file ops
   L3305-3375 + L13316-13438; print family L4299-4305,L4477-4500 + nova_rt_list_print L1620-1629; channels
   L4508-4675; scheduler/fiber/netpoller/offload (~L5000-8260, incl nova_rt_spawn L8089-8243); HTTP/TCP/DNS/TLS;
   os_random (CryptGenRandom/urandom); hot-reload (dlfcn); backtrace (execinfo).
6. KEEP (must compile under wasm): tags/boxing/oddballs L253-938, str create/concat L1135-1194, list L1233-1731
   (minus print), dict L1199-2835, arena L17031-17139, RC L9591-9781, find_tag (adapted), len_any/iter dispatch.

### Tiny libc stubs (in nova_runtime_wasm.c, before the #include)
memcpy/memmove/memset/strlen/strcmp/strncmp (portable loops) + snprintf (minimal int/float/%s formatter for
int_to_str/float_to_str/list_to_str). `#define malloc -> nova_heap_alloc(sz,NOVA_MEM_RAW)`, `free -> no-op`,
`calloc -> alloc+memset`. NOTE: clang lowers struct copies to memcpy -> memcpy MUST exist. Compile `-fno-builtin`
(else -O2 loop-idiom re-emits a strlen import -> BigInt crash in V8). os_random -> host import (crypto.getRandomValues).

### Incremental execution order (each step: build wasm unit further + RECOMPILE NATIVE .o + verify byte-identical/forge-green + commit)
S1. Gate includes (L1-10/12-27/31-51) + add stubs file scaffold. Verify native byte-identical. (no wasm milestone yet)
S2. Gate the big I/O/scheduler/socket sections (#5 list). Native byte-identical. Try wasm compile -> collect the
    NEXT undefined-symbol/header errors (iterate the gate list until the value-model TU compiles to a wasm .o).
S3. Adapt find_tag (#2) + aligned_struct (#3) + RC non-atomic + rc_free channel gate (#4). wasm .o links.
S4. MILESTONE: a NOVA fn that BUILDS a string ("a"+"b"+"c") + measures it runs in node wasm (str_concat + FAT_STR
    find_tag + freestanding heap). Then lists, then dicts, then structs. Gate via a _wasm_vm_*.sh runner.

### Risks
- A gate that wraps native-needed code -> native breaks (CAUGHT by the per-step native .o diff / forge test).
- snprintf float formatting fidelity in wasm (float_to_str) -- may need a careful dtoa; defer (strings/lists/ints
  first, floats later).
- find_tag without guard pages: a genuinely-wild ptr in `any` dispatch can't be probed -> wasm relies on
  range+magic only. Acceptable (wasm linear memory is bounds-checked by the engine; OOB traps deterministically).
