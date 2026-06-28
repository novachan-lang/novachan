# NOVA WASM Frontend Guide (proven patterns, 2026-06-28)

How to build a **full-stack NOVA app whose frontend runs in the browser as WebAssembly** — using only the
patterns proven + gated this session. NOVA compiles to wasm32, the heap value-model (strings/lists/dicts/
structs + control flow) runs there, the DOM is driven via host imports, and a Forge (NOVA) backend serves it.

> Status: value-model + DOM render + string-in + event/state + Forge-serve all RUN and are gated (8 gates).
> Caveats up front: state lives in a runtime cell (NOVA has no mutable module globals, and green-task `spawn`
> does not execute in wasm — no OS threads / no fiber switching); browser runs are validated via a node oracle
> plus a real openable HTML page (no headless-browser CI here).

---
## 1. The runtime carve — `output/nova_runtime_wasm.c`
The native runtime (`output/nova_runtime.c`) can't compile to wasm as-is (no wasi-sysroot offline; it includes
stdio/sockets/pthread). The carve keeps native UNTOUCHED and adds a wasm-only translation unit:

```c
#define NOVA_FREESTANDING 1
#include <stdint.h>
#include <stddef.h>
/* tiny freestanding libc: memcpy/memmove/memset/memcmp/strlen/strcmp/strncmp/strchr/strstr/strcpy,
   bump malloc/calloc/realloc/free, snprintf/vsnprintf, atoi/atof/strtod/strtol/qsort/rand, isnan...,
   + the POSIX types/macros the gated headers provided (FILE, pthread_*, fd_set, struct sockaddr/...),
   + dead-stub I/O (stdio/sockets/threads/signals/process/dlopen/mmap/epoll) */
#include "nova_runtime.c"
/* AFTER the include (so nova_heap_alloc / NOVA_MEM_RAW are in scope): runtime-backed primitives */
void*   wasm_alloc(int n) { return nova_heap_alloc((size_t)(n<0?0:n)+1, NOVA_MEM_RAW); }   /* JS string-IN */
int64_t nova_state_get(void){ return g_nova_state; }                                       /* state cell */
int64_t nova_state_set(int64_t v){ g_nova_state=v; return 0; }
```

`nova_runtime.c` is touched in only **5 spots**, ALL `#ifndef/#elif NOVA_FREESTANDING` so native is byte-for-byte
unaffected: 4 system-include gates (setjmp.h, signal.h, sys/stat.h, sys/epoll.h — these are *hosted* headers,
unlike the compiler-provided freestanding stdint/stddef) + 1 `find_tag` literal-detection branch (wasm has no
PE module range / no `pipe()` probe → detect data-segment string literals as `addr < &__heap_base`; wasm linear
memory is bounds-checked so a misclassified ptr traps rather than wild-reads).

NATIVE-SAFETY PROOF for any `nova_runtime.c` edit (byte-identical `.o` is impossible — COFF timestamps it):
```
clang -E output/nova_runtime.c | grep -vE '^# ' | grep -v '^[[:space:]]*$'   # IDENTICAL vs git HEAD
_fdb_one.ps1 forge_query_test                                                # GREEN
```

---
## 2. Build + link
```
gen3_test.exe app.nova                       # NOVA -> app.ll  (the native compiler; wasm target via clang on the .ll)
clang --target=wasm32 -ffreestanding -nostdlib -fno-builtin -O2 -c output/nova_runtime_wasm.c -o output/nova_runtime_wasm.o
clang --target=wasm32 -O2 -fno-builtin -nostdlib -c app.ll -o app.o
wasm-ld --no-entry --export-all --allow-undefined --gc-sections app.o output/nova_runtime_wasm.o -o app.wasm
```
`-fno-builtin` is MANDATORY (else -O2 loop-idiom re-emits a libc strlen/memcpy IMPORT → "Cannot convert BigInt"
crash in V8). `--gc-sections` strips the unused runtime: the 28MB object → a **~459 KB** `.wasm` for a real app
(wasm-opt -Oz would shrink further; not installed here). Pitfall: Git-Bash `/tmp` ≠ node `C:\tmp` on Windows →
write the `.wasm` to a LOCAL path.

---
## 3. The JS ↔ NOVA ABI (the host is a PEER PROCESS; the wasm import table is the CHANNEL)
- **i64 ↔ BigInt.** A NOVA fn returning `int` returns an i64 → JS sees a `BigInt` (`x.f() === 3n`). Pass ints in
  as `BigInt(n)`.
- **`extern fn` = a wasm import** (module `env`). It ALWAYS returns i64 by the NOVA ABI → a JS host impl MUST
  return a BigInt (e.g. `() => 0n`); a `void` JS/C impl trips a wasm-ld signature-mismatch trap ("unreachable").
- **An `extern` whose symbol is DEFINED in the linked runtime resolves to that definition — NOT a host import.**
  That's how `wasm_alloc`/`nova_state_get`/`nova_state_set` become runtime-backed primitives a NOVA program calls.
- **String args** to an `extern fn` arrive as an **i32 linear-memory pointer** (the compiler `inttoptr`s the
  handle); read them with `readCStr(ptr)` over the EXPORTED `memory` (re-fetch the `Uint8Array` after any alloc):
  ```js
  function readCStr(p){ const u=new Uint8Array(mem.buffer); let o=Number(BigInt.asUintN(32,BigInt(p))),e=o; while(u[e])e++; return new TextDecoder().decode(u.subarray(o,e)); }
  ```
- **Stub the rest:** `const env=new Proxy(realImpls,{get:(t,k)=> k in t?t[k]:()=>0n})` covers the dead I/O imports.

---
## 4. The four patterns
**(a) Render OUT — NOVA builds markup, the host paints it.** Declare the DOM surface as `extern fn`s; the host
implements them with a `node ↔ int handle` side-table. NOVA uses the value-model (loops, `str()`, concat) to
COMPUTE, then calls `dom_create/dom_set_text/dom_append`. See `_wasm_render.nova` (string → host) and
`_wasm_domrender.nova` (a `<ul>` of computed `<li>`).

**(b) String IN — host hands NOVA a string.** `const ptr=Number(x.wasm_alloc(s.length+1)); writeUtf8(mem,ptr,s);
x.handler(BigInt(ptr))` — the RAW-tagged buffer is read by the value-model as a string (`find_tag`→RAW). See
`_wasm_strin.nova` (echo_len/echo_upper round-trip) and `_wasm_todo.nova` (typed item → `split` → re-render).

**(c) STATE — a runtime cell.** NOVA has NO mutable module-level global (a top-level `let` reassigned in a fn
binds a function-local shadow — true NATIVELY too) and `spawn`/actors do NOT execute in wasm (no scheduler:
no OS threads, no fiber switching). So durable state lives in a runtime cell reached via `extern fn
nova_state_get()/nova_state_set(v)`. The handler reads it, mutates it, re-renders. See `_wasm_counter.nova`
(event → increment → render, count 0→1→2→3). For lists, store the list handle in the cell, or keep state in JS
and pass it in per event (pattern (b)).

**(d) EVENTS.** A DOM event calls an exported NOVA fn: `btn.addEventListener("click", ()=> x.bump())`. Each
event = one synchronous NOVA call that reads/updates the cell and re-renders.

---
## 5. Full-stack — Forge (NOVA) serves the wasm frontend
```nova
import forge
fn home_h(req: Request) -> Response       // NOTE: `html`/`get`/`json`/`text` are forge fn names -> don't shadow them
    forge.file("app.html")
fn wasm_h(req: Request) -> Response
    forge.file("app.wasm")                // binary-safe: forge.file reads non-text via read_bytes + resp_bytes
```
`forge.file` and the `static()` mount serve binary assets NUL-safely (a wasm starts with a NUL byte; `read_file`
would 404 it — fixed this session). `serve_file` stays text-only (it returns a string). See `_forge_wasm_demo.nova`.
A browser then `instantiateStreaming(fetch("app.wasm"))` — served with `Content-Type: application/wasm`. The
real-browser artifact is `_wasm_counter.html` (serve the dir over http:// and click the button).

---
## 6. Gotchas (quick list)
- `-fno-builtin` always. Local paths for the `.wasm` (bash/node `/tmp` mismatch on Windows).
- `extern fn` returns i64 → C/JS impls return int64/BigInt. String arg = i32 ptr; int arg = i64.
- `memory` is exported → readCStr from it; re-fetch the `Uint8Array` after any `wasm_alloc`.
- No mutable module globals; no in-wasm `spawn` → use the runtime cell for state.
- `read_file`/`tcp_recv` are C-string (NUL-truncate) → `read_bytes`/`tcp_recv_bytes`/`forge.file` for binary.
- forge short fn names (`html/get/json/text/page`) shadow locals — don't reuse them as variable names.
- **Math imports:** if your NOVA code uses `sqrt/sin/pow/...`, the wasm imports them — the host MUST supply them
  (`env.sqrt = Math.sqrt`, etc.); a harness that stubs every import to `()=>0n` makes math-using code compute
  wrong. (The runtime provides the i128 builtin `__multi3` itself — needed for `-O2`-optimized big-integer
  arithmetic; an undefined LLVM compiler-rt builtin would silently compute wrong, so watch the import list.)

---
## 7. Examples + gates (all under nova-compiler/test_programs/)
| Capability | Example | Gate |
|---|---|---|
| value-model (str/list/dict/struct/loop/index) | `_wasm_strbuild.nova` | `_wasm_vm_one.sh` |
| render OUT (string → host) | `_wasm_render.nova` | `_wasm_render_one.sh` |
| computed DOM tree | `_wasm_domrender.nova` | `_wasm_domrender_one.sh` |
| string IN (round-trip) | `_wasm_strin.nova` | `_wasm_strin_one.sh` |
| event+state+render counter | `_wasm_counter.nova` | `_wasm_counter_one.sh` |
| real-browser artifact | `_wasm_counter.html` | `_wasm_counter_browser_one.sh` |
| todo list (string-in + split + render) | `_wasm_todo.nova` | `_wasm_todo_one.sh` |
| Forge serves the wasm | `_forge_wasm_demo.nova` | `_forge_wasm_demo_one.sh` |

Full carve history + findings: `NOVA_DESIGN/WASM_RUNTIME_PORT.md`. Toolchain: clang wasm32 + wasm-ld + node v20.
