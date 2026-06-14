# WASM + DOM Frontend — Staged Plan (2026-06-14)

Chosen as the next deep-frontier item by a grounded scoping workflow (wf_d6f10dc4-b8f). The browser
is the ONE major target NOVA cannot reach today (native / cross-compile / distributed / Node-wasm-
compute all exist) — and "full-stack frontend in NOVA" is the literal first-download promise. The
scoping VERIFIED it is far more tractable than feared.

## What ALREADY works (verified, not assumed)
- Real **wasm32 codegen** (nova_compiler.nova: resolve_target ~L14232-14233, datalayout ~L14241).
- **clang --target=wasm32** link exporting `nova_user_main`, with `-Wl,--allow-undefined --gc-sections`
  (~L18515-18517). 6 committed `.wasm` artifacts. Node v20 + clang wasm32 present locally.
- A 523-line JS linear-memory runtime `_wasm_runtime.cjs` (readCStr at L76).
- ★ **The host-import surface ALREADY EXISTS via `extern_fn`** (parser ~L2401, codegen ~L15803,
  ir_externs ~L16716-16766): an `extern fn` emits a bare `declare i64 @name(...)` with ptr-arg
  marshaling via `inttoptr i64 to ptr` (~L16800). In a wasm32 module an undefined `declare` lowers to
  exactly `import "env" "name"` — which is precisely why the link line already passes `--allow-undefined`.
  So a NOVA program can ALREADY declare a host import and call it; the only new artifact for a proof is
  a browser importObject + HTML harness.

## Reconverge safety (the governing constraint)
Everything wasm is gated on `target==wasm`, which the **native bootstrap never selects** → `gen5.ll==
gen6.ll` is untouched by construction. Stages 0-3 are wasm-only / new-files. Stage 4 (m7) is the ONLY
stage that touches the shared value representation and must be staged behind the wasm target +
validated against native output (the int/pointer CVE class).

## Staged plan
- **Stage 0 — VERIFY the host-import path** (≈0.5 iter, NO code): compile a `_wasm_dom_demo.nova`
  declaring `extern fn dom_set_text(id: ptr, txt: ptr)` to wasm32; inspect the `.wasm` import section
  (wasm-objdump / `WebAssembly.Module.imports` in Node) to confirm it lowers to `import "env"
  "dom_set_text"` with the expected ptr/i32 ABI. De-risks the whole plan; if it works, Stage 1 needs
  zero compiler change. Any ABI tweak is gated behind `target==wasm` only.
- **Stage 1 — "Hello DOM" proof** (the first milestone): `nova_user_main` calls `dom_set_text` on two
  string literals; a browser ES-module runtime (fork `_wasm_runtime.cjs`, strip fs/Buffer/process, keep
  readCStr, add `dom_set_text(idPtr,txtPtr)=>document.getElementById(readCStr(idPtr)).textContent=
  readCStr(txtPtr)` into env); a minimal HTML harness instantiating the `.wasm`. **Oracle:** headless
  browser OR Node+jsdom asserting `getElementById('app').textContent === 'Hello from NOVA'`. SOUND value
  subset only (strings + structs + small ints) — sidesteps the tag-less JS-runtime large-int/pointer
  ambiguity. Reconverge byte-identical; native 400+ regression + the 6 wasm bundles unchanged.
- **Stage 2 — host ergonomics, the NOVA-way framing** (needs a /deep-think first): a clean documented
  way to declare host imports framed as **the JS host is a PEER PROCESS and the wasm import table is a
  CHANNEL to it** (structurally the same problem NOVA already solves with remote_* channels over TCP —
  do NOT copy wasm-bindgen/emscripten glue). A small DOM-binding surface (set_text, sanitized set_html,
  create/append node, get/set attribute) + a value-marshalling ABI (add the wasm→JS handle-return
  direction).
- **Stage 3 — events / callbacks (JS→wasm)**: export NOVA closures as wasm table entries the host can
  call (a button click invoking a NOVA fn). Bigger design; still wasm-only.
- **Stage 4 — m7 SOUND runtime-to-wasm** (deep, risky, the soundness cutover): compile the REAL tagged
  `nova_runtime.c` to wasm32 so the wasm target carries NOVA's actual value model (RC/tag identity),
  eliminating BOTH the double-maintained JS runtime AND the large-int/pointer divergence. Stage behind
  the wasm target, validate against NATIVE output as the oracle; /stress-test the int/pointer CVE before
  any code touches shared representation. (`nova_runtime_wasm.c` is a dead stub gesture; m7 is the real thing.)
- **Stage 5 — frontend story**: a DOM/reactive stdlib + `nova build --target web` (emit .wasm + html +
  glue as one artifact). Months; gated on 2-4.

## Rejected / deferred deep candidates (scoping verdicts)
- **Sized integer types** — REJECT as a major item: justifying use-cases already solved (bit-exact
  crypto via `& 0xFFFFFFFF` + the shipped unsigned ops; C-struct width via typed-width ptr_read/write_uN
  at the memory boundary, the correct place for width); conflicts with NOVA's one-int/zero-annotation
  model; high bootstrap/CVE risk for no leverage. If ever wanted: a local `wrap_to(x,bits)` intrinsic.
- **Mailbox + PIDs** — DEFER: Erlang-prime already delivered (supervisors + monitor + a gen_server the
  NOVA way in actorx.nova over spawn+channel+receive; a channel handle IS a PID). Only non-redundant gap
  = **selective receive** (`recv ch { Pat => }` scanning the ring buffer, ~1wk, additive) — a fallback
  paper-cut, not a frontier item. Wholesale mailbox is the ANTI-GOAL (a 2nd untyped comm path competing
  with channels; reopens the untyped-heterogeneous-store CVE class).
- **REPL via OrcJIT** — DEFER the OrcJIT build (over-scoped, introduces a permanent 2nd backend + an
  in-process mutable heap that fights process isolation). The interim `repl.nova` repair (it shells to an
  ABSENT gen2_move.exe at L112; repoint to nova_compile_file/nova_link) is a cheap paper-cut fix only.
