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

---
## S1 DONE + S2 error cascade (2026-06-28, commit pending)
S1 landed: (a) `output/nova_runtime_wasm.c` scaffold = `#define NOVA_FREESTANDING` + freestanding mem/str prims
(memcpy/memmove/memset/memcmp/strlen/strcmp/strncmp/strchr) + `#include "nova_runtime.c"`; (b) system includes
gated in nova_runtime.c (L1-10 + Win32 + POSIX blocks behind `#ifndef NOVA_FREESTANDING`); setjmp.h ALSO gated
(it is a HOSTED header, not a freestanding one like stdint/stddef — those two resolve under wasm32, setjmp does not).

### ★ INVARIANT CORRECTION: native "byte-identical .o" is UNACHIEVABLE -> use token-identical preprocessed
The COFF `.o` embeds a TimeDateStamp: the UNEDITED committed nova_runtime.c compiled twice gives two different
sha256. So `.o` hash equality was never the right check. CORRECT native-safety proof (used for every carve step):
`clang -E nova_runtime.c | grep -vE '^# ' | grep -v '^\s*$'` (preprocessed, line-markers + blank lines stripped)
must be byte-identical between the committed and edited file, AND a forge test must pass. S1 PASSED both: the
native preprocessed token stream is identical (only blank lines added by the directives) + forge_query_test GREEN.

### S2 driver: wasm compile cascade (513 errs) -> distinct symbols, two buckets
STUB-ABLE libc (value-model uses; ADD freestanding impls to nova_runtime_wasm.c): malloc/calloc/realloc/free
(-> nova_heap_alloc; free=no-op; realloc=alloc+copy), snprintf (minimal int/float/%s/%c formatter), strstr,
strcpy, atoi/atoll/atof/strtod (minimal parsers), qsort (minimal), getenv (-> NULL: no env in wasm), abort
(-> __builtin_trap()). NOTE several (atoi/atof/strtod/qsort) appear in gated I/O regions -> after gating, recompile
and stub only what REMAINS undeclared (genuinely value-model).
GATE-OUT (wrap in `#ifndef NOVA_FREESTANDING`; symbol : first line):
- Panic/fault/backtrace: backtrace 188, fprintf 190, fflush 191, backtrace_symbols_fd 192, longjmp 209, exit 212,
  setjmp 7735, jmp_buf type. (fault boundary + fatal-panic stack traces)
- Threads/sched: pthread_mutex_init 315 ... pthread_cond_* 4562-4837, sched_yield 4917, usleep 4923,
  pthread_create 6409, pthread_join 7317, pthread_mutexattr_* 7257-7260, pthread_*_destroy 7837-7838,
  types pthread_mutex_t/cond_t/t/mutexattr_t, PTHREAD_*_INITIALIZER, sysconf 7778/_SC_NPROCESSORS_ONLN.
- Time: gettimeofday 4997, clock_gettime 5986, CLOCK_MONOTONIC/REALTIME.
- File/std IO: printf 1632, puts 1746, fopen 3315/fread 3276/fwrite 3299/fclose 3333/fseeko 3328/ftello 3329/
  fgets 3004, write 983/close 984/pipe 982/dup2 3120, FILE/stdin/stdout/stderr, SEEK_SET/END, strerror 3318.
- Process: system 2978, popen 2988, pclose 2999, execl 3122, _exit 3123, waitpid 3159, WIFEXITED/WEXITSTATUS 3162,
  mkdir 3177, stat 3239, EEXIST, pid_t, ssize_t.
- Socket/netpoller: FD_ZERO 6211/FD_SET 6242/FD_ISSET 6276/fd_set, select 6261, getaddrinfo 6484, munmap 6534.
- aligned alloc: posix_memalign 693 (-> NOVA_FREESTANDING path: plain nova_rt_struct_alloc, ignore alignment).
First breaks at L119/122 (free/malloc): an early helper -> stubs cover these. nova_task_arena_cleanup 7763 is a
fwd-decl-after-use artifact -> resolves once its section compiles.
### S2 plan: gate the above sections behind `#ifndef NOVA_FREESTANDING` (iterate compile->gate until only STUB-ABLE
symbols remain), add the stub-able libc to the scaffold, re-confirm native token-identical each step. Then S3.

---
## S2 progress (2026-06-28): SHIM approach -> 513 -> 213 errors; key POSIX-branch finding
PIVOTED from "gate every I/O section in nova_runtime.c" to a SHIM in nova_runtime_wasm.c (keeps native almost
entirely untouched -- only 2 nova_runtime.c include-gates: setjmp.h already in S1, + signal.h this step; both
`#ifndef NOVA_FREESTANDING`, native token-identical VERIFIED + forge_query_test GREEN). The shim supplies:
- VALUE-MODEL libc (REAL impls): bump malloc/calloc/realloc/free, snprintf/vsnprintf (own formatter), strstr/
  strcpy/strncpy, atoi/atoll/atof/strtod, qsort, rand/srand (LCG), isnan/isinf/isfinite. memcpy/memset/strlen
  /strcmp/strncmp/strchr from S1.
- DEAD-in-wasm decls/stubs: stdio (printf/fopen/fread/...), pthreads, signals, process (fork/exec/waitpid),
  setjmp/longjmp, backtrace, getenv->NULL, time->0, math transcendentals (declarations). + the types/macros the
  gated headers gave (FILE, jmp_buf, pthread_*, fd_set, struct sockaddr/addrinfo/stat/dirent/timeval, FD_*/
  SIG*/SEEK_*/CLOCK_*/_SC_*/RAND_MAX...).
★ FINDING: with the platform headers gated, wasm (non-_WIN32) takes the POSIX `#else` branches everywhere. Those
branches reference the FULL POSIX API (sockets AF_INET/socket/bind/recv/send/htons/inet_pton, dirent opendir/
readdir, sys/stat S_ISREG, mmap, time_t/localtime/strftime, EAGAIN/EWOULDBLOCK) AND a WIN32-only static
(nova_task_arena_cleanup, defined only inside `#ifdef _WIN32` @L5285+ -> absent on the POSIX path -> this is the
"partial Linux" gap surfacing). Remaining 213 errors are almost entirely this POSIX I/O surface.
DECISION for next step: these are all NON-value-model (sockets/files/dirs/time/scheduler). Two options: (A) keep
shimming the ~60 POSIX symbols; (B) GATE the socket/netpoller/file/dirent/scheduler SECTIONS behind
`#ifndef NOVA_FREESTANDING` (removes the half-maintained POSIX branches entirely -> fewer shims, and resolves
nova_task_arena_cleanup since its POSIX call site goes away). LEAN B for the I/O-heavy sections (cleaner, and the
value-model never needs them); keep the shim for the value-model libc + math. The shim libc/math is reusable either way.

---
## ★ S2b DONE (2026-06-28): the WASM value-model TU COMPILES (0 errors)
output/nova_runtime_wasm.c now compiles clean to a wasm32 object: `clang --target=wasm32 -ffreestanding
-nostdlib -fno-builtin -O2 -c` -> 0 errors. The ENTIRE NOVA runtime value-model is wasm-compilable. llvm-nm
confirms the needed symbols present: nova_heap_alloc (+ its freestanding bump buffer nova_fs_heap),
nova_mem_find_tag, nova_rt_create_string, nova_rt_str_concat, nova_rt_len_any, list/dict/arena.
Total nova_runtime.c carve edits = 4 include-gates, ALL `#ifndef NOVA_FREESTANDING`, ALL native token-identical
(clang -E) + forge_query_test GREEN: setjmp.h (S1), signal.h (S2a), sys/stat.h x2 (S2b), sys/epoll.h (S2b).
Everything else lives in the SHIM (nova_runtime_wasm.c): value-model libc (REAL: bump malloc/calloc/realloc/
free, snprintf/vsnprintf, strstr/strcpy/strncpy/strrchr, atoi/atoll/atol/atof/strtod/strtol/strtoll, qsort,
rand/srand LCG, isnan/isinf/isfinite, isspace) + dead-but-declared I/O (stdio, sockets, dirent, epoll, pthreads,
signals, process, dlopen, mmap, fcntl, time) + the POSIX types/macros/structs (FILE, jmp_buf, pthread_*, fd_set,
struct sockaddr/addrinfo/stat/tm/timespec/dirent/epoll_event, AF_*/SOCK_*/SO_*/S_IS*/O_*/EPOLL*/RTLD_*/...) +
a freestanding no-op nova_task_arena_cleanup (its real def is _WIN32-only).
NEXT: S3 = runtime-adapt find_tag for wasm (the Windows IsBadReadPtr branch is _WIN32-gated already; confirm the
no-guard-page path is taken; RC is already single-threaded under the shim's no-op pthreads). S4 = compile a
string-building NOVA .ll to wasm, wasm-ld link (--no-entry --export-all --allow-undefined --gc-sections) with
nova_runtime_wasm.o, run in node -> the heap-value-model-in-wasm MILESTONE. The 28MB pre-strip .o shrinks at link.

---
## ★★★ S4 MILESTONE DONE (2026-06-28): the NOVA HEAP VALUE-MODEL RUNS IN WASM
_wasm_strbuild.nova builds heap values that EXECUTE correctly in node WebAssembly via the FULL runtime:
strbuild() (string concat "a"+"b"+"c")=3, listlen() ([10,20,30,40])=4, dictlen() ({3 keys})=3. ALL CORRECT.
Beyond the prior scalar + string-LITERAL subsets -- this is real heap allocation, string CONCAT, list + dict
build+measure, via nova_heap_alloc's freestanding bump heap + find_tag + create_string/str_concat/list/dict.
Flow: gen3 .nova->.ll; `clang --target=wasm32 -O2 -fno-builtin -nostdlib -c .ll -> prog.o`; `wasm-ld --no-entry
--export-all --allow-undefined --gc-sections prog.o output/nova_runtime_wasm.o -> _strbuild.wasm` (456KB --
gc-sections strips the 28MB runtime to just what the 3 fns reach); node instantiates (imports stubbed ()=>0n) +
calls the exported fns (i64 -> BigInt). Gate: _wasm_vm_one.sh (asserts 3/4/3). NOTE: bash /tmp != node C:\tmp on
Windows -> use LOCAL paths for the .wasm.
★ S3 fix folded in (string literals returned len 0): under wasm (non-_WIN32) nova_is_readable_str took the POSIX
nova_probe_cstr path, which probes readability via pipe()/write() -- both STUBBED in wasm -> always fail -> the
literal is rejected -> nova_str_safe returns "" -> concat length 0. Lists/dicts were fine (headered, found by
find_tag). FIX: a `#elif defined(NOVA_FREESTANDING)` branch where nova_addr_in_module detects data-segment
literals as `a >= 0x10000 && a < (uintptr_t)&__heap_base` (the linker symbol; wasm linear memory is
bounds-checked so even a misclassified ptr traps, never wild-reads; heap objects are header-detected first).
Native token-identical (inert for _WIN32) + forge_query_test GREEN. Total nova_runtime.c carve edits now 5
(4 include-gates + this literal branch), ALL #ifndef/#elif NOVA_FREESTANDING, ALL native token-identical.
NEXT: structs in wasm (auto-JSON / Show), bigger programs, then wire to the browser frontend (WASM_FRONTEND_*).

---
## S5 DONE (2026-06-28): STRUCTS + control-flow run in wasm (no runtime fix needed)
Extended _wasm_strbuild.nova + the gate: all SIX correct in node wasm -- strbuild=3, listlen=4, dictlen=3,
structfield=42 (Point(7,35).x+.y), loopsum=55 (while-loop sum of i*i), listindex=15 (list literal + while +
xs[i] index). Structs "just worked" via the freestanding struct alloc (nova_rt_struct_alloc / posix_memalign
shim -> bump) + header-based find_tag (same as list/dict). No nova_runtime.c change this step (native untouched).
=> the FULL value-model (string/list/dict/struct) + control flow + index access execute in WebAssembly.
NEXT: a JS<->NOVA boundary for the browser frontend (return a built STRING to JS as the 'render' -- needs
reading the i64 string-handle's bytes out of wasm linear memory in the harness), per WASM_FRONTEND_*.

---
## S5b DONE (2026-06-28): VALUE-MODEL-BACKED RENDER PATH (NOVA builds a string -> JS host)
_wasm_render.nova: `extern fn host_emit(s: string)` + a fn that BUILDS "Hello from "+"NOVA"+"!" in the wasm
value-model and calls `unsafe host_emit(msg)`. Linked with nova_runtime_wasm.o; the JS host reads the built
bytes out of wasm linear memory (memory IS exported; readCStr of the i32 ptr arg) -> captured "Hello from
NOVA!" EXACTLY. This is the browser RENDER path: compute text/markup in NOVA, hand it to the DOM host via the
extern-fn -> wasm-import CHANNEL (Frontend doc's framing: JS host = peer process, import table = channel).
Combines value-model-in-wasm (S4/S5) with the pre-existing extern-fn host-import surface (WASM_FRONTEND Stage
0-2). The frontend doc's deferred "string from wasm value-model -> JS" is now PROVEN. ABI note: extern fn
returns i64 by the NOVA ABI (JS impl must return a BigInt e.g. 0n even for void); string ARG arrives as an i32
linear-memory ptr. Gate: _wasm_render_one.sh. No nova_runtime.c change (native untouched).
NEXT: wire to the real DOM surface (dom_set_text on a NOVA-built string via _wasm_runtime_browser.mjs), then
JS->wasm string IN (needs the exported allocator), then event callbacks.

---
## S5c DONE (2026-06-28): NOVA-COMPUTED render drives a real DOM TREE
_wasm_domrender.nova declares the dom_* host-import surface (dom_get_by_id/dom_create/dom_set_text/dom_append)
and uses the VALUE-MODEL (while-loop + str(i) + concat) to COMPUTE text, building <ul><li>item 1..3</li></ul>
under #app. Node oracle (handle side-table + fake document, linked with nova_runtime_wasm.o) confirms the exact
tree. So a NOVA *render* (computed, not a literal) drives the DOM via the extern-fn -> wasm-import CHANNEL.
Gate _wasm_domrender_one.sh. No nova_runtime.c change (native untouched). The browser frontend OUT-direction
(NOVA computes + renders to DOM) is proven end-to-end. NEXT: JS->wasm string IN (exported allocator) + event callbacks.

---
## S5d DONE (2026-06-28): JS->wasm string IN (round-trip) -- both frontend directions proven
Added an exported `wasm_alloc(n)->ptr` to nova_runtime_wasm.c (after the #include: returns a RAW-tagged
nova_heap_alloc buffer that find_tag/len_any read as a string). _wasm_strin.nova: JS writes "hello" into wasm
memory at wasm_alloc's ptr (+NUL), then echo_len(s)=5 and echo_upper(s) sends upper(s)="HELLO" back via host_emit
-> round-trip JS->NOVA(value-model)->JS confirmed. This is the event/form-INPUT direction (the frontend doc's
other deferred item). Gate _wasm_strin_one.sh. nova_runtime.c UNCHANGED (wasm_alloc lives in the shim) -> native
untouched. => BOTH browser directions proven: OUT (NOVA computes+renders to DOM, S5c) + IN (JS string -> NOVA, S5d).
NEXT: event callbacks (JS calls an exported wasm fn on a DOM event), then assemble a tiny end-to-end counter/todo
demo, then wire to the real _wasm_runtime_browser.mjs + an HTML harness.

---
## S5e DONE (2026-06-28): EVENT + STATE + RENDER -- a stateful NOVA counter runs in wasm
_wasm_counter.nova: JS invokes bump() on a "click"; NOVA reads a persistent state cell (extern nova_state_get),
increments it, and re-renders "count: N" via dom_set_text -> count 0->1->2->3 across calls. Event + state-logic +
render all in NOVA. Gate _wasm_counter_one.sh. nova_runtime.c UNCHANGED (the cell is in the shim; native safe).
★ FINDING: NOVA module-level mutable globals do NOT persist across separate exported wasm calls (a top-level
`let count = 0` reassigned in a fn doesn't retain -- each call sees it reset; the soundness guards then make
state ops 0-no-ops). So durable state needs a cell: here the runtime provides `nova_state_get/set` (non-static
defs in nova_runtime_wasm.c -> the NOVA `extern` declares RESOLVE to them at wasm-ld, NOT host imports). NOVA owns
the logic; the runtime owns the cell. (A real fix = persistent NOVA globals in wasm codegen -- future compiler work.)
★ GOTCHA: every NOVA `extern fn` returns i64 by ABI -> a matching C def MUST return int64_t (a `void` def trips a
wasm-ld signature mismatch -> runtime trap "unreachable"). NEXT: real-browser HTML harness + _wasm_runtime_browser.mjs.

---
## S5f DONE (2026-06-28): real-browser counter ARTIFACT (html + browser runtime)
_wasm_counter.html = a self-contained page (div#count + <button>+1) whose inline module script
instantiateStreaming's _counter.wasm, supplies the DOM host-imports via a Proxy env (dom_get_by_id ->
document.getElementById + a node<->handle table; dom_set_text -> node.textContent=readCStr; every other import
-> ()=>0n), calls init() on load, and wires the button click to x.bump(). RUN: serve the dir over http://
(instantiateStreaming needs application/wasm) and open it. The browser-runtime WIRING is CI-gated by
_wasm_counter_browser_one.sh (a node sim with a fake document -> count 0->1->2->3), since jsdom is absent. So a
human can open a real page and click a real button to drive the NOVA-compiled stateful counter. NEXT: Forge-serve
_wasm_counter.html + _counter.wasm (one language front+back).
