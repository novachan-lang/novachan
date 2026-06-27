# WASM Frontend (NOVA in the browser) — Design

**Goal:** NOVA → WebAssembly → browser, so ONE language builds front AND back, sharing types + logic with
the Forge/LiveView backend. This is the NOVA identity ("ONE dev, ONE language, builds ANYTHING"). The
completeness audit flags WASM codegen as a **no-op stub** today ("NO frontend") — this is the real path.

## Design

1. **Backend target — reuse LLVM.** NOVA already lowers to LLVM IR for the native backend. Emit to the
   **wasm32 LLVM target** (`--target wasm32`) instead of x86-64 → reuse the entire frontend + IR +
   optimizer; only the codegen target + the runtime/ABI change. Direct wasm emission is the alternative but
   throws away the LLVM pipeline — **recommend LLVM wasm32** (smallest delta, proven optimizer).

2. **Runtime in linear memory.** Compile `nova_runtime.c` for wasm32 (clang `--target=wasm32`): the
   allocator (arena + RC) lives in wasm **linear memory**; values lay out exactly as native (i64 ABI). No
   OS, no threads in the MVP → the green scheduler degrades to single-threaded cooperative (N=1); a
   post-MVP path uses Web Workers + SharedArrayBuffer for parallelism. No sockets → networking is via
   `fetch`/WebSocket host imports (which the LiveView client already needs).

3. **Host / DOM bindings.** wasm **imports** for host ops the browser provides: DOM (`createElement`,
   `setAttribute`, `addEventListener`, `setText`), `fetch`, `console.log`, WebSocket. A NOVA
   `forge_dom.nova` exposes these as `extern` fns mapped to wasm imports (the same `extern fn` machinery the
   SQLite FFI uses, retargeted to wasm imports). Event callbacks: JS calls back into exported wasm fns.

4. **JS glue / loader.** A small generated JS loader instantiates the `.wasm`, supplies the import object
   (DOM/fetch/console/WebSocket implementations + a string/bytes marshalling layer for linear memory <-> JS),
   and wires DOM events to exported wasm callbacks. `nova build --target wasm` emits `app.wasm` + `app.js`;
   serve them via Forge static files.

5. **LiveView synergy (the killer app).** The SAME `view_fn` (statics/dynamics, `forge_live.nova`) runs
   server-side (LiveView push) AND can run client-side in wasm — shared rendering, one language. The wasm
   client applies LiveView patches natively (a wasm port of `live_client_js`), and forms/handlers are NOVA,
   not JS. Types are shared front+back (no DTO duplication) — the thing no JS/TS+backend stack achieves.

## Blockers (why this is a focused, multi-session effort)
- The **wasm32 codegen target** wiring in the compiler (the core change; today a no-op stub).
- The **runtime-in-wasm**: allocator in linear memory, no-threads scheduler degrade, string/bytes
  marshalling across the wasm/JS boundary.
- The **DOM binding layer** (`forge_dom.nova` + the import table) and the JS loader/marshalling.
- A **wasm test target** (headless browser or `node --experimental-wasm`) to gate against — the harness
  has none today.

## First sub-step
Make the wasm32 LLVM target emit a REAL module for a trivial NOVA program (`fn add(a,b) a+b`, exported),
compile `nova_runtime.c` to wasm32, and load + call it from `node` (no DOM yet). That proves the
target+runtime path end to end; DOM bindings + the LiveView client port build on it.

## Gate
`node`/headless-browser loads `app.wasm`, calls an exported fn, asserts the result; then a DOM smoke
(create an element via the import). Needs a wasm toolchain + a JS host in the test harness.
