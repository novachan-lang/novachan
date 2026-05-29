# NOVA — As-Built Architecture (implemented reality, 2026-05-29)

The original design docs describe the *plan*. This document records what is **actually built and
verified**, and the key architectural decisions made during implementation. For per-feature status
(REAL / PARTIAL / STUB) see [IMPLEMENTATION_AUDIT.md](IMPLEMENTATION_AUDIT.md) — the single source of truth.

## Where we actually are
Not "Phase 0." NOVA has a **self-hosting compiler written in NOVA** (`nova-compiler/test_programs/
nova_compiler.nova`, ~11.4K lines), compiled by `gen3_test.exe` (currently gen25), emitting LLVM IR,
linked with a C runtime (`output/nova_runtime.c`). It self-compiles to a **byte-identical fixpoint**
(deterministic) at **~0.98× C** performance. Phases 0–14 are substantially implemented; Phases 7–14 were
made genuinely real and oracle-verified in the 2026-05-28/29 work (71/71 regression green).

## Compilation pipeline (as-built)
`source.nova → [gen25] Lexer → Parser (error-recovering) → TypeInferer → AstToIr → ir_tco →
ir_const_fold → ir_die (DCE) → ir_dbe → ir_infer_types → IrEmitter → LLVM IR → clang -O2 + nova_runtime.c
→ native exe`. Two codegen paths exist; the **gen2 IR path** (`use_ir=1`) is the default. The IR carries a
per-register type map (`rt`) used for type-directed lowering (e.g. `int_to_str`→`float_to_str`).

## THE VALUE MODEL (as-built) — important, future work depends on this
All NOVA values are a single `int64`. Heap objects (list, dict, fat-string, struct, channel, iter) are
pointers to cells with an 8-byte RC+tag header (magic `0x4E56`, low 3 bits = kind); `nova_mem_find_tag`
recovers the kind. **Primitives (int/float/bool) are bare i64 with no tag.**

This created a soundness gap: a primitive widened to an `Any` slot couldn't be told apart from a pointer
or another primitive (int 0 ≡ false ≡ null bits). The resolution (FINDING #1):

- **Boxing for Any-typed float/bool only** (int stays raw, so the compiler's own `List<Any>` of
  ints/structs is untouched → bootstrap-safe). A box is a `NOVA_MEM_BOX` (kind 7) cell `{kind, payload}`.
- **Box-ADDRESS-RANGE tagging** is the key trick: the runtime tracks the min/max address of allocated
  boxes (`g_box_lo`/`g_box_hi`). The box check is a cheap range compare — values outside the window are
  rejected in one compare with **no dereference**. Programs that never box pay nothing, so hot container
  reads keep 0.98× C. This avoids the `IsBadReadPtr`-per-read perf cliff and avoids tag-bit/large-int
  collisions (it never tags raw integers).
- **The compiler boxes at statically-typed insertion points** (it knows the type there): `list.push(float)`
  → `list_append_fbox`; `d[k]=bool` → `index_set "bbox"` marker → `dict_set_bbox`. Accessors
  (`list_get`, inlined index-get, `dict_get`) **transparently unbox** on read; the JSON walker and
  `any_to_str` render boxes (float `%g`, bool `true`/`false`).
- **Bool literals carry `ir_type_bool`** (still a `const_int` op, so optimizer passes are unaffected);
  inference reads the type. So `print(true)` is `"true"`, and bool round-trips through JSON.
- **Known edge:** a genuinely-dynamic `Any` value of unknown runtime type widened into a container is not
  boxed (rare). All statically-typed primitive cases are correct (scalar/list/dict).

Other runtime decisions: fat strings (hash+len header; the pointer IS a valid `char*`), embedded RC in
allocation headers, slab allocator for small list/dict, arena mode.

## Compiler-correctness invariants (as-built)
- **User-defined functions shadow built-ins** of the same name (FINDING #2). Call lowering uses the user
  function's own name when one exists; only non-user names resolve to runtime built-ins.
- Error operations (`set_error`/`is_error`/`try_unwrap_value`/…) are side-effectful (`ir_emit_side`), never
  DCE'd. `?`/`catch` unify the global-error-flag and `Result` systems.
- **Never add `!llvm.loop.unroll/vectorize.enable` hints** — caused 280× code bloat / 2× slowdown.

## Domains (as-built, see audit for exact status)
- **Networking:** real TCP/UDP, HTTP server + routing framework, WebSocket (RFC 6455), TLS *client*
  (Windows schannel), length-framed distributed transport. TLS server + distributed fault-tolerance: TODO.
- **Compute:** WASM bytecode interpreter (i32 arithmetic subset), CPU-backed GPU compute kernels. Real GPU
  device + WASM control-flow/memory: TODO.
- **AI:** real n-D tensor library (matmul/add/relu), softmax/sigmoid, file model-load → matmul → argmax
  classification pipeline. Standard model formats (ONNX/GGUF) + conv: TODO.
- **Tooling:** build (TOML/mtime/formatter/targets), profiler/coverage/bench, DAP protocol, LSP server,
  doc generator, FFI to real C. Interactive debugger + incremental/cross-compile: PARTIAL/TODO.

## Verification discipline (how we keep this honest)
Every REAL claim is backed by an **oracle test** whose expected values come from an independent authority
(RFC/NIST vectors, a reference implementation, a real external client, or hand-computed). Every compiler
change is validated by a **deterministic bootstrap fixpoint** (gen_N self-compile == gen_{N+1}). Status
lives only in IMPLEMENTATION_AUDIT.md; the word "complete" is banned in favor of REAL/PARTIAL/STUB.
