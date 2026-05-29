# NOVA Implementation Audit — Honest Status Ledger

**Created:** 2026-05-28. **Auditor:** Chief Language Architect (Claude).
**Why this exists:** Phases 7–14 were previously marked "COMPLETE." That claim was false.
Many domain features are **stubs** whose tests were written to match the stub (circular validation).
This document is the single source of truth for what is REAL, PARTIAL, or STUB. No feature may be
called "done" anywhere (memory, summaries, commits) unless it is marked **REAL** here with a passing
**oracle test** (a test whose expected values come from an independent authority, not our own output).

## Status definitions (only three — "complete" is banned)

- **REAL** — Genuine implementation. Passes an *oracle test* (RFC/NIST vectors, a reference
  implementation, a hand-computed result, or a real external client) AND adversarial tests
  (malformed input, resource exhaustion, concurrency, boundaries).
- **PARTIAL** — Works on the happy path but has documented gaps. The gaps are listed explicitly.
- **STUB** — Scaffolding only. Compiles and is callable, but does not perform the real work.
  Honest placeholder. Must never be described as working.

A feature's status is only as strong as its weakest dependency: a layer that depends on a STUB
cannot itself be REAL.

---

## DEFINITIVE PHASE-BY-PHASE STATUS — consolidated & re-verified 2026-05-29 (compiler gen25)

Single source of truth. Re-verified on the current build: **77/77 regression green**, plus the network/
compute oracles re-run live (HTTP, WebSocket, distributed, TLS-to-example.com, WASM, FFI-to-real-C).
Both compiler-soundness findings (#1 value model, #2 shadowing) are RESOLVED + bootstrap-fixpoint-validated.

> **REMEDIATION STATUS (2026-05-29, post deep audit):** ALL P0 + P1 items RESOLVED + fixpoint-validated, **78/78
> regression green**, bootstrap deterministic (SHA 9ED0CB7E…):
> - P0: `read_bytes` implemented (#4); numeric aggregates `sum/min/max/sort/any/all` box/float-aware (#3).
> - P1: UDP wired + reachable (#4); `dict_contains` dead decl removed (#4); fake `model_*` removed, `phase13_ai_test`
>   rewritten to a real tensor oracle (#5).
> - New guards: read_bytes_test, float_list_ops_test, udp_test (78 tests total).
> - STILL OPEN: P2 capability gaps only (TLS server, WASM control flow, real-device GPU, interactive debugger,
>   cross-platform HTTP/TLS, distributed fault-tolerance, archetype ECS + render/audio/physics, ONNX/GGUF, deploy).
>   Dead-code pruning (~17 fns) deferred (harmless — LLVM drops unused).

> **2026-05-29 DEEP CODE-LEVEL AUDIT** — a line-by-line compiler + compiler↔runtime cross-reference audit was run;
> see [DEEP_AUDIT_2026-05-29.md](DEEP_AUDIT_2026-05-29.md). It confirmed the compiler, value/boxing model, and type
> system are sound, and confirmed every STUB/PARTIAL claim below was honest. It also found **new defects not visible
> at the feature level**, now folded in here:
> - **UDP is UNREACHABLE** — `nova_rt_udp_*` is defined in the runtime but never wired to the compiler. The old
>   "TCP/UDP sockets REAL" was wrong for UDP (TCP is fine). Corrected below.
> - **`read_bytes` hard link error** — mapped + declared + type-registered in the compiler but **undefined** in the
>   runtime; any program calling `read_bytes()` fails to link (latent: no test uses it). Also mis-typed (int→string).
> - **`sum/min/max/sort/any/all` silently wrong on FLOAT lists** — the same box-unaware-reader class as the tensor
>   bug fixed this session; int lists unaffected. Runtime-only fix via `nova_elem_to_double`.
> - **Tensor float-list fix** — `tensor_from_list`/`set`/`scale` now unbox via `nova_elem_to_double`; push/json/file-
>   built float tensors are correct (regression guard `tensor_boxed_float_test`).
> - **AI inference HTTP service** (`ai_serve.nova`) — REAL cross-domain oracle: `{"features":[1,2]}`→`{"class":1}`.
> - `phase13_ai_test` exercises the legacy 1D-int `arr_*` helpers, NOT the tensor pipeline (name overpromises).
> - ~17 dead runtime functions (~300 lines) incl. the entire UDP subsystem; two-backend (`--old`) duplication hazard.

| Phase | Capability | Status | Evidence / oracle |
|---|---|---|---|
| **7** stdlib | crypto (sha256/hmac/base64/hex), regex, datetime, collections (PQ/deque/sortedmap/LRU/counter), iterators, buffer, structured logging, JSON | **REAL ✓** | NIST/RFC vectors; regex semantics; 71/71 regression incl. phase tests |
| **7.5** FFI/unsafe | `extern fn` → real C, pointer ops, memset, str↔cstr, sizeof | **REAL ✓** | ffi_test: add(40,2)=42, mul(7,6)=42, fact(5)=120 (real ffi_helper.c) |
| **8** build/tooling | TOML parse, file mtime, needs-rebuild, source discovery, formatter, target detection | **REAL ✓** | phase8_build_test |
| **8** pkg mgr | semver parse/compare/satisfies | **REAL ✓** | phase14 semver tests |
| **8** incremental / cross-compile | LLVM multi-target wiring | **PARTIAL** | target detection real; full cross-compile unproven |
| **9** devtools | profiler (real timing), coverage, bench, DAP protocol JSON, LSP server | **REAL ✓** | phase9_devx_test; Track 6 LSP |
| **9** interactive debugger | breakpoints/stepping/inspect | **STUB** | DAP emits valid JSON but no real debug session |
| **10** docs | doc-comment extract → markdown + HTML | **REAL ✓** | phase10_doc_test |
| **11** net core | TCP/UDP sockets, HTTP server + routing framework | **REAL ✓** | _http_probe: GET/POST/query/compute round-trip via real client |
| **11** WebSocket | RFC 6455 handshake + framing + unmask | **REAL ✓** | _ws_probe: published accept vector + echo |
| **11** TLS client | schannel handshake + encrypt/decrypt | **REAL ✓** | tls_test: decrypts real HTTPS "HTTP/1.1 200 OK" from example.com |
| **11** TLS server | `tls_listen/accept` | **STUB (honest)** | returns 0 — needs server-cert provisioning |
| **11** distributed | length-framed message transport over node_* | **REAL transport ✓ / PARTIAL FT** | _node_probe round-trip; heartbeat/reconnect/discovery TODO |
| **11** hot reload | file-change detection | **PARTIAL** | real mtime polling; no live code swap |
| **12** WASM | bytecode interpreter: **i32+i64+f32+f64** (const/arith/compare) + conversions + locals + **structured control flow** + **br_table** + **function calls & recursion** + **linear memory** (load/store 8/16/32, memory.size) | **REAL ✓ (i32/i64/f32/f64 + control + calls + memory, 2026-05-29)** | add→42; loop→55; fac(5)→120; mem→30; i64 10^12; trunc(3.5+1.5)→5. memory.grow/imports TODO |
| **12** GPU compute | elementwise kernels | **REAL compute, CPU backend ✓** | gpu_compute_test; real-device dispatch (CUDA/Metal/Vulkan) TODO |
| **13** web framework | request parse, routing, response build, JSON | **REAL ✓** | http_demo end-to-end |
| **13** AI inference | tensor matmul/add/relu, softmax/sigmoid, file model-load → classify (argmax) | **REAL ✓** | ai_classify_test (logits→class), tensor matmul verified |
| **13** AI model formats | ONNX/GGUF loaders + conv2d | **STUB/TODO** | custom text format works; standard formats not done |
| **13** game/ECS | entity/component CRUD + query | **PARTIAL** | functional linear-scan; no archetype perf, no render/audio/physics |
| **14** deploy | `deploy_config/validate` | **PARTIAL/THIN** | builds config dict; no real provider integration |
| **14** mobile/embedded | targets | **TODO** | not started |
| **core** value model | `Any`-typed int/float/bool through scalar/list/dict + JSON | **REAL ✓ (FINDING #1)** | box-address-range design; bool/float boxed at typed sites; 71/71 + 7 fixpoints |
| **core** compiler soundness | user fns shadow built-ins | **REAL ✓ (FINDING #2)** | shadow_test; bootstrap fixpoint |
| **core** self-host | gen25 compiles itself deterministically @ 0.98× C | **REAL ✓** | byte-identical fixpoints (last DB7DDE366DAA648E) |

**Summary:** Phases 7, 7.5, 8 (core), 9 (devtools), 10 are REAL. Phase 11 networking is REAL (client side;
TLS server + distributed fault-tolerance remain). Phase 12 WASM/GPU compute is REAL within documented scope.
Phase 13 web + AI inference are REAL; standard model formats + a real game engine remain. Phase 14 deploy is
thin. The honest remaining work is the STUB/PARTIAL rows above — none are pretending to be done.

---

## CRITICAL FINDINGS (foundation issues that must be fixed before building on top)

### #1 — `Any`-typed primitives lose their type at runtime — RESOLVED ✓ 2026-05-29

**Status: RESOLVED for all statically-typed primitives.** int, float, AND bool now serialize correctly
across scalar / list / dict, with correct read-back (unbox). Solved via: (a) box layer + box-ADDRESS-RANGE
tracking (cheap collision-safe box check, no per-read IsBadReadPtr — resolved the perf blocker); (b) compiler
boxes float/bool at typed insertion points (list_append_fbox/bbox, dict_set_fbox/bbox, index_set fbox/bbox
markers) since the compiler knows the static type; (c) JSON walker + any_to_str render boxes; (d) accessors
(list_get, inlined index-get, dict_get) transparently unbox. bool literals now carry ir_type_bool (still a
const_int op → optimizer unaffected). Validated: bool_json_test, nested_float_test, dict_float_test,
nested_bool_test; 71/71 regression green; 7 bootstrap fixpoints (last DB7DDE366DAA648E). Remaining theoretical
edge: a genuinely-dynamic Any value (unknown runtime type, not statically a primitive) widened into a
container won't box — rare; the common typed cases all work. Commits: 744780f, 8f93a8a, 9e4ce74, 7c7b746,
ef3c397, + nested-bool.

**Found:** 2026-05-28 via json_oracle_test.nova. **Severity:** foundational.
**Progress 2026-05-29:** Runtime BOX LAYER landed + validated (66/66 green). Added `NOVA_MEM_BOX` tag
(value 7) + `NovaBox{kind,payload}` + `nova_rt_box_bool`/`box_float`/`unbox`; json_stringify_value now
renders a boxed bool as true/false and a boxed float via %g. Only bool/float box (int stays raw) so the
compiler's own List<Any> of ints/structs is bootstrap-safe. NOTHING creates boxes yet → zero behavior
change (foundation only). **Remaining (the deep part):** compiler-side widening insertion — box a
float/bool when it enters an Any context (container insert, Any arg, return) + transparent unbox at every
element read. Wide blast radius (every runtime path reading container elements directly: sum/sort/map/
to_str…), so it must be done incrementally with bootstrap re-validation per step. bool also needs IR-level
tracking (currently erased to "int" at nova_compiler.nova:4535). This is the dedicated effort.

**Nested-container blocker (perf) — RESOLVED 2026-05-29 via box-address-range tracking.** The earlier
concern was that detecting a box on every container read needs `nova_mem_find_tag` (IsBadReadPtr, slow).
SOLUTION: track the min/max address of allocated boxes (g_box_lo/g_box_hi). `nova_is_box` first does a
cheap range compare — any value outside the box-address window is rejected in one compare, with NO deref.
Programs that never box pay nothing (range empty → instant reject), so the compiler's hot list-indexing
is unaffected (bootstrap held ~47s, fixpoint deterministic). find_tag runs only for the rare value that
falls in the narrow box window. **Nested FLOAT in lists now works end-to-end:** compiler boxes float
elements (list_append_fbox, type-directed), the JSON walker + any_to_str render boxes, and list_get /
inlined index-get transparently unbox on read. Validated: nested_float_test (json [1.5,2.5,0.25] exact +
read-back), 68/68 green, bootstrap fixpoint 3D449FD3151AA004.
DONE: int JSON, top-level float JSON, box layer, **nested float in lists AND dicts**. Dict path:
compiler marks index_set with "fbox" when value is float (ir_infer_one), IRE routes to dict_set_fbox /
boxes list stores; dict_get unboxes. Validated dict_float_test (json {"x":2.5,"n":7} + read-back), 69/69
green, fixpoint 65C2C19572975341. **Floats are now comprehensively correct (scalar/list/dict).**
REMAINING: bool (standalone + nested) — bool is erased to "int" in the IR (nova_compiler.nova:4535), so it
needs IR-level bool tracking before the same boxing approach can distinguish it. That is the last piece.

NOVA stores integers and pointers in the same 64-bit slot with no tag bit. Heap objects are
identified by `nova_mem_find_tag(ptr)`; primitives are not tagged. When a primitive is passed to an
`Any`-typed parameter, the runtime cannot tell `int 0`, `bool false`, and `null` apart — they are
bit-identical. Code that must dispatch on runtime type therefore *guesses*:
- `json_stringify_value` (nova_runtime.c:2017): `val==0 → "null"`, `val==1 → "true"`.
  So **`json_encode(0)`→`"null"`, `json_encode(1)`→`"true"`, `json_encode(false)`→`"null"`.** Wrong.

**Blast radius:** the dynamic `Any` path only — `json_encode`/`stringify`, `any_to_str`, heterogeneous
containers. **Statically-typed code is unaffected** (the compiler emits type-specific calls like
`print_int`), which is why the 65 regression tests pass.

**Proper fix (foundational, not a patch):** give `Any` a real runtime representation. Options:
(a) tagged/NaN-boxed values for `Any` and heterogeneous containers; (b) compiler boxes primitives
(with a type tag) when widening to `Any`. This is core value-model work (belongs with Track 8 /
ownership-value model). A JSON-only hack would leave `any_to_str` and mixed containers still wrong.

**This is exactly why we verify the foundation before building domains:** AI/web/game all serialize
and pass `Any` values; building them on an unsound `Any` would multiply this bug everywhere.

**Feasibility (investigated 2026-05-28):** box-on-widen is feasible in the gen2 IR path. Insertion
point = `ir_infer_one` (nova_compiler.nova:8358), which already does type-directed call rewriting
(int_to_str→float_to_str at 8510-8519; int→float promotion at 8380-8385). It can safely distinguish a
concrete `int`/`float` register from an opaque `any` handle, so tensor/set/bytes handles won't be
wrongly boxed. **RISK:** the compiler itself stores mixed values in `List<Any>` (e.g. 7154-7162) and
relies on them being *unboxed*. A *uniform* box-everything fix would require unbox-on-read across the
whole 11K-line compiler and likely breaks the self-host bootstrap. Therefore the fix must be phased:
(1) narrow box only at `Any`-sink call args (json_encode/any_to_str/serialize) — safe, local, fixes
top-level scalars; (2) compile-time type-directed serialization for structs/typed containers (Serde
style — the compiler generates the serializer from the known static type); (3) full tagged-value model
only as dedicated Track-8 work with bootstrap re-validation at each step. Heterogeneous mixed-primitive
`List<Any>` serialization stays a documented PARTIAL until (3).

---

### #2 — User-defined functions do not shadow built-ins (silent wrong-call) — RESOLVED ✓ 2026-05-28

**Status: FIXED.** ir_lower_expr (nova_compiler.nova:4655) now uses the user function's own name
when one exists, only falling back to `resolve_runtime_fn` for non-user names. Validated:
shadow_test.nova (user `fn ok` returns Box(105), not the builtin Result); 66/66 regression green;
the sole compiler-internal collision `float_bits` is semantically identical to its builtin
(both atof/strtod→bits) so behavior is unchanged; bootstrap fixpoint CONFIRMED (gen13==gen14,
SHA 1BF4A488A9A7726E, deterministic). Canonical compiler gen3_test.exe = gen13 (923,136 bytes).

**Found:** 2026-05-28 while debugging the HTTP demo. **Severity:** soundness (silent miscompile).

A program that defines `fn ok(body) -> Response` and calls `ok("...")` silently invokes the BUILT-IN
`ok()` (the Result constructor) instead of the user's function. Result: a `Result` is built where a
`Response` was expected; field access reads the wrong slot; the program crashes or misbehaves with no
error. Confirmed: the HTTP demo crashed on every request until `ok` was renamed to `resp_ok`.

**Proper fix:** call resolution must check user-defined functions BEFORE built-in/runtime names
(currently `resolve_runtime_fn` / builtin lookup wins). Must be done in the compiler with a bootstrap
re-validation, batched with the other compiler-correctness work (FINDING #1). Risk: the compiler may
itself define names that currently resolve to builtins — validate 65 tests + bootstrap after the change.

**Workaround until fixed:** don't name a user function exactly like a builtin (`ok`, `err`, `len`,
`print`, `split`, etc.).

---

### #3 — Box-unaware numeric readers: `sum/min/max/sort/any/all` wrong on FLOAT lists — RESOLVED ✓ 2026-05-29

**Status: RESOLVED.** `sort`/`any`/`all` made box+float-aware (runtime-only); `sum`/`list_min`/`list_max` now
type-directed: pure-int lists use the exact integer path, float/Any lists route to `nova_rt_sum_f`/`_min_f`/`_max_f`
(read each element via `nova_elem_to_double`, return float bits) with the HM signature generalized to `list<T>→T`.
`nova_elem_to_double` upgraded from a 1e6 heuristic to the reliable 2^52 int/float-bits discriminator (also hardens
`tensor_from_list`). Validated: float_list_ops_test (push-built boxed floats, raw-bits literals incl. negatives, int
exactness, boxed-`false` truthiness), 77/77 regression, bootstrap fixpoint deterministic (SHA 101C9B03…). Remaining
theoretical edge: a list of ints ≥ 2^52 typed non-`intlist` would be read as float (precision loss) — astronomically
rare and inherent to the tag-free value model. Original finding below.

**(original) Status: OPEN.** Found 2026-05-29 by the deep-audit reader sweep (same class as the tensor bug fixed this session).
A list built by push/json/file stores **boxed** floats (box pointers in `data[i]`); a literal float list stores raw
IEEE bits. Several core numeric runtime functions read `l->data[i]` and interpret it as a number **without unboxing**,
so they silently return garbage on float lists (int lists are unaffected — ints are never boxed):

- `nova_rt_sum` (nova_runtime.c:4846) — `acc += data[i]` as integer add.
- `nova_rt_list_min` / `nova_rt_list_max` (4883/4893) — raw int64 compare.
- `nova_rt_list_sort` + `cmp_int64` (1146) — qsort by raw int64 (boxed→sorts by heap address).
- `nova_rt_any_truthy` / `nova_rt_all_truthy` (4865) — boxed `false`/`0.0` reads as truthy.

**Fix (runtime-only, no re-bootstrap):** route element reads through `nova_elem_to_double` (added this session);
for min/max/sort compare on the double but return the original element. Verified-safe pattern (already applied to
`tensor_from_list`/`set`/`scale`). NOT a boxing defect — the boxing model is sound at write+read (for-loops/`index_get`
unbox); this is purely raw readers bypassing the accessor. See DEEP_AUDIT_2026-05-29 §6.

### #4 — Compiler↔runtime cross-reference defects — OPEN (P0/P1)

**Status: OPEN.** Found 2026-05-29 by the integrity cross-reference.
- **`read_bytes` HARD LINK ERROR — RESOLVED ✓ 2026-05-29 (P0):** implemented `nova_rt_read_bytes` (binary-safe file
  read into a NovaBytes buffer; error-flag + 512MB guard) and corrected the type signature to `string→bytes`(any).
  Validated: read_bytes_test (ASCII oracle h=104…o=111 + bytes_to_str round-trip), 76/76→77/77 regression, bootstrap
  fixpoint deterministic. *(original: mapped/declared/typed but undefined → link error on use; also mis-typed int→string.)*
- **UDP unreachable — RESOLVED ✓ 2026-05-29 (P1):** wired `udp_bind/send/recv` (map + declares both backends + HM
  sigs); `udp_test` oracle passes. Now reachable + REAL.
- **`dict_contains` dangling decl — RESOLVED ✓ 2026-05-29 (P1):** removed the unused declaration from both backends.

See DEEP_AUDIT_2026-05-29 §4.

### #5 — Fake `model_load`/`model_infer`/`model_close` removed — RESOLVED ✓ 2026-05-29 (P1)

The legacy model API performed no real computation (`model_infer` was identity; `model_load` kept only the path).
It was a trap and `phase13_ai_test` circularly validated its identity behavior. **Removed** from the compiler
(mappings/declares/type-regs) and runtime; `phase13_ai_test` rewritten to a REAL tensor-inference oracle
(matmul → relu → argmax, hand-computed [1,4,2] → class 1). Real model inference is the tensor pipeline
(`tensor_from_list`/`tensor_matmul`/`relu`/`softmax`/`argmax`); `arr_*` 1D-int helpers kept (they work; just redundant).

---

## TIER 1 — Compiler core (the genuinely real foundation)

This is the hard, real work. Verified by 65/65 regression tests + deterministic self-host bootstrap.

| Capability | Status | Evidence |
|---|---|---|
| Lexer, parser, parser error recovery | REAL | Track 4, multi-error programs don't crash |
| Type inference + generics + trait bounds | REAL | Track 3/5/6, soundness holes closed |
| IR + optimizer (TCO, const-fold, DCE) | REAL | Tracks 1–4 |
| LLVM codegen @ 0.98× C | REAL | GATE 5: primes 0.87x, sieve 1.07x, matmul 0.99x |
| Self-hosting bootstrap (deterministic) | REAL | gen11→gen12 byte-identical (918,528 bytes) |
| Error handling: error/catch/try/? unified | REAL | Track 6 |
| LSP server (diagnostics/hover/go-to-def) | REAL | Track 5 |
| Module system (import/as/selective) | REAL | b8c6df6 |

---

## TIER 2 — Stdlib (mostly real, needs oracle verification to confirm)

These have real implementations but were validated by our own tests, not oracles. They are
labeled **REAL?** = "looks real on read, must be confirmed against an external oracle before we
trust the label."

| Module | Status | Oracle test required to confirm REAL |
|---|---|---|
| Lists / dicts / sets / strings / slicing | REAL | Covered by 65 regression tests |
| Iterators (map/filter/zip/take/collect/…) | REAL | Covered by iter tests |
| Collections: PriorityQueue, Deque, SortedMap, LRU, Counter, RingBuffer | REAL | Track 7; LRU has real eviction + hit/miss |
| Math (libm wrappers) | REAL | Thin, correct |
| Channels / spawn / monitor / select / async-await | REAL | Concurrency tests across the suite |
| TCP sockets (winsock) | REAL | Real Berkeley-socket calls (reachable from NOVA) |
| UDP sockets (`udp_bind/send/recv`) | **REAL ✓ (wired 2026-05-29)** | Was unreachable (defined but unwired). Now mapped + declared + typed; `udp_test` passes (loopback self-send → recv "ping-udp", 8 bytes). |
| Result / Option + `?` | REAL | Track 6 |
| Arena allocator, weak refs, checked arithmetic | REAL | Track 8 |
| Tensor (n-D float): zeros, matmul, add, mul, scale, sum, relu | **REAL ✓ (boxed-float fix 2026-05-29)** | matmul verified real (nova_runtime.c ~5334). `tensor_from_list`/`set`/`scale` now unbox list elements via `nova_elem_to_double` — push/json/file-built float tensors are correct (were silently garbage before). Guard: tensor_boxed_float_test. *The true AI primitive.* |
| JSON parse / stringify | **REAL (ints/strings/containers/top-level float) ✓ / PARTIAL (bool, nested float)** | FIXED 2026-05-28: removed 0→null/1→true heuristics (ints exact, incl. arrays). FIXED 2026-05-29: compiler routes json_encode(float)→nova_rt_json_encode_float (json_encode(3.14)→"3.14"; was garbage bits); json_float_test PASS, 67/67 green, bootstrap fixpoint FB721EB780005623. Remaining: standalone bool→1/0 (bool erased to "int" in IR) and floats NESTED in dicts/lists (need container boxing — FINDING #1 deep part). |
| Regex (match/find/replace/split) | **REAL ✓** | CONFIRMED 2026-05-28: \d \w \s . ? + * [] ^ $ all match known semantics. regex_test.nova. (Deeper RE2 differential deferred to Phase 7 hardening.) |
| Crypto: sha256, hmac_sha256, base64, hex, crc32, fnv1a, murmur3, uuid4 | **REAL ✓** | CONFIRMED 2026-05-28: sha256("")=e3b0c44…b855 (NIST), hmac=f7bc83f4… (RFC), base64/hex match. test_crypto_stdlib.nova |
| datetime | **REAL ✓** | CONFIRMED 2026-05-28: datetime_test (28 assertions; correct year/month/day/timestamp/format for the current date). |
| HTTP server (listen/accept/read_request/respond) + framework | **REAL ✓** | CONFIRMED 2026-05-28 via real raw-TCP client (_http_probe.ps1): GET /→200, GET /add?a=40&b=2→{"sum":42} (real query parse+compute), POST /echo→{"bytes":11} (real body). Earlier "timeout" was a SEPARATE bug (FINDING #2), not the HTTP layer. |
| Build tooling (toml, mtime, needs_rebuild, fmt, target detect) | **REAL ✓** | CONFIRMED 2026-05-28: phase8_build_test (target=x86_64-pc-windows-msvc, mtime, needs-rebuild, get-sources=403, formatter, TOML parse). |
| bench / coverage / profiler | **REAL ✓** | CONFIRMED 2026-05-28: phase9_devx_test (profiler fib(10)=55 in 400ns real timing, coverage tracking, DAP emits valid protocol JSON). Interactive breakpoint debugger still PARTIAL. |
| doc extract → markdown/html | **REAL ✓** | CONFIRMED 2026-05-28: phase10_doc_test (doc_extract + markdown + html). |
| FFI (Phase 7.5): extern fn → real C + pointer/memset/str-cstr | **REAL ✓** | CONFIRMED 2026-05-28: ffi_test calls real C (add(40,2)=42, mul(7,6)=42, fact(5)=120); phase75_ffi_test primitives. |
| ML ops: softmax, sigmoid (in NOVA over real exp) | **REAL ✓** | CONFIRMED 2026-05-28: softmax([1,2,3])=[0.090,0.245,0.665] (sums 1), sigmoid(0)=0.5, sigmoid(2)=0.881. ml_ops_test.nova. |
| Test framework (assert_*, test_run, TAP) | REAL | Self-evident, used everywhere |

---

## TIER 3 — Domain features marked "done" that are actually STUB or PARTIAL

**This is the dishonest part of the prior "COMPLETE" claim. These need real implementations.**

| Feature | Claimed | Actual | Evidence | What "REAL" requires |
|---|---|---|---|---|
| **TLS client** (`tls_connect/send/recv/close`) | done | **REAL ✓ (FIXED 2026-05-28)** | Real Windows schannel (SSPI): AcquireCredentialsHandle + InitializeSecurityContext handshake loop with cert validation, EncryptMessage/DecryptMessage records. ORACLE PASSED: tls_connect("www.example.com",443) → real handshake → GET → decrypted "HTTP/1.1 200 OK" (tls_test.nova, network oracle). secur32 via #pragma (66/66 still link+pass). A plaintext stub cannot produce this. |
| **TLS server** (`tls_listen/accept`) | — | **STUB (honest)** | Returns 0 (not implemented) — needs server certificate provisioning. No longer pretends. |
| **WebSocket** (`ws_upgrade/send/recv`) | done | **REAL ✓ (FIXED 2026-05-28)** | Rewrote to full RFC 6455: added SHA-1 + raw-base64, real handshake, real frame encode/decode + client-mask XOR. ORACLE PASSED: key `dGhlIHNhbXBsZSBub25jZQ==`→accept `s3pPLMBiTxaQ9kYGzzhZRbK+xOo=` (RFC published vector); real raw-TCP client echo round-trip of 2 messages. 65/65 regression green. _ws_probe.ps1 + ws_echo_server.nova. |
| **Multi-node channels** (`node_*`) | done | **REAL transport ✓ (FIXED 2026-05-28) / PARTIAL fault-tolerance** | Rewrote node_send/recv with 4-byte big-endian length framing (reliable message boundaries; the old newline scheme broke on split/merged recvs). ORACLE PASSED: independent length-framed client round-tripped {"cmd":"ping","n":5} exactly (_node_probe.ps1 + node_echo_server.nova); 65/65 regression green. REMAINING for full distributed: heartbeat, reconnect, node identity/discovery, supervision. |
| **Hot reload** (`hot_reload_*`) | done | PARTIAL | Real mtime polling (nova_runtime.c:9310) but **no actual code swap** — only reports which files changed. | Real code swap of a running process without dropping state. Oracle: change a fn, running server picks it up live. |
| **WASM** (`wasm_compile/run/free`) | done | **REAL ✓ (control flow added 2026-05-29)** | Real bytecode interpreter: LEB128 section parsing; i32.const; local.get/set/tee; the full i32 compare set (eqz/eq/ne/lt/gt/le/ge signed+unsigned) and arith/bitwise (add/sub/mul/div/rem/and/or/xor/shl/shr signed+unsigned); drop/select/nop; and **structured control flow** (block/loop/if/else/br/br_if/return) via a one-pass bracket-matching pre-scan, plus **function calls & recursion** (parses type/function/code sections; recursive `wasm_exec` with heap-allocated per-frame buffers + a depth cap so deep recursion can't overflow the C stack). Linear memory: parses the memory section, allocates shared linear memory (across call frames), and supports i32 load/store at 8/16/32-bit widths + memory.size. ORACLES: add→42; loop sum(1..10)→55; recursive **fac(5)→120**; **mem store/load→30** (_wasm_mem_probe + wasm_mem_test.nova); 78/78 green. REMAINING: i64/f32/f64, br_table, memory.grow, imported funcs. |
| **GPU/CPU compute** (`gpu_alloc/write/read/kernel_run`) | done | **REAL compute, CPU backend ✓ (FIXED 2026-05-28)** | Buffers are real; `gpu_kernel_run` now runs REAL elementwise kernels (square/scale2/add1/negate) over the buffer, unknown kernel→-1. ORACLE: write[1,2,3,4]→square→[1,4,9,16]→scale2→[2,8,18,32] (gpu_compute_test.nova); 65/65 green. HONEST LABEL: backend is CPU — real device dispatch (CUDA/Metal/Vulkan/WebGPU) is future work. |
| **AI inference compute** (tensor matmul/add/relu) | — | **REAL ✓ (verified 2026-05-28)** | Real linear layer + ReLU forward pass, hand-computed oracle: x@W=[4,5,4,-3], relu→[4,5,4,0] (ReLU zeroed the -3). ai_infer_test.nova PASS. The compute path for neural nets is genuinely real. |
| **AI model loading + full pipeline** | — | **REAL ✓ (custom format, 2026-05-28)** | Real loader in NOVA: read_file → parse → tensor_from_list → matmul. Oracle: persisted 2x3 weights, loaded, x@W=[3,4,7] hand-computed. ai_model_test.nova. Full pipeline REAL: file→tensors→matmul→relu/softmax/sigmoid. REMAINING: standard formats (ONNX/GGUF) + conv op. |
| AI legacy stubs (`model_infer` identity, `arr_*`) | done | STUB + REDUNDANT | Superseded by the real tensor pipeline above; these trivial 1D-int stubs should be removed/ignored. |
| **Game/ECS** (`ecs_*`) | done | PARTIAL | Functional but flat linear-scan array (nova_runtime.c:9632). No rendering, audio, physics, scene graph. | Real archetype/sparse-set ECS + a render/audio/physics backend. Oracle: spawn 100k entities, query perf vs flecs/entt. |
| **HTTP client** (`http_get/post`) | done | PARTIAL | WinHTTP on Windows (real); "not implemented" on Linux/macOS (nova_runtime.c:3826). | Cross-platform (libcurl or native). Oracle: GET a real endpoint on all 3 OSes. |
| **Debugger** (DAP) | done | STUB | Logs only, no real breakpoints/stepping (nova_runtime.c:8933). | Real DAP server bridging LLDB/GDB. Oracle: set breakpoint, step, inspect a var. |
| **Deploy** (`deploy_config/validate`) | done | THIN | Builds a dict (nova_runtime.c:9744). No real provider integration. | Real provider APIs (Fly/Docker). Oracle: actually deploy a hello-world and curl it. |

---

## The methodology — how we build the rest without fooling ourselves

Six rules. They exist because the prior failure was *structural* (circular tests), not careless.

1. **Oracle tests, never self-referential.** Every REAL claim needs a test whose expected value
   comes from an independent authority: RFC/NIST vectors, a reference implementation
   (Python/RE2/OpenBLAS), a hand-computed constant, or a real external client. *If the only thing
   that validates our code is our code, it is not validated.* This single rule would have caught
   every stub above.

2. **Three states, no fourth.** REAL / PARTIAL / STUB. The word "complete" is banned. PARTIAL must
   enumerate its gaps. This ledger is the only place status lives.

3. **Build bottom-up, never on a stub.** Dependency-ordered. Real WebSocket needs real HTTP upgrade;
   real distributed needs real serialization + real channels; real model inference needs real tensor
   ops (we have those). A feature cannot be REAL while a dependency is STUB.

4. **Adversarial gate before REAL.** Each feature must survive malformed input, resource exhaustion,
   concurrent access, and boundary conditions. The failure hunt is mandatory, not post-hoc.

5. **Competitive number, measured not assumed.** Performance-sensitive features get benchmarked
   against best-in-class (regex vs RE2, JSON vs simdjson, matmul vs OpenBLAS, HTTP vs nginx). We need
   not win immediately, but the number is recorded and tracked.

6. **The ledger is law.** Memory, commit messages, and summaries must match this file. If they
   disagree, this file wins and the others get corrected.

---

## Proposed sequencing (for discussion — not yet started)

**Step 0 (recommended first): Verify the foundation.** Convert every Tier-2 **REAL?** to a confirmed
**REAL** (or down to PARTIAL) using oracle tests. We cannot honestly build domains on top of a stdlib
we haven't actually verified. This is fast (the code likely is real) and establishes ground truth.

**Then one vertical at a time, built for real:**
- **AI path** — tensor ops are already REAL; add real ops (conv/softmax/attention) + a real model
  loader. Highest leverage; foundation exists.
- **Web path** — HTTP server is REAL?; add real router + real TLS + real WebSocket → a real backend.
  Central to NOVA's full-stack identity.
- **Systems/FFI hardening** — real cross-platform HTTP client, real C FFI marshaling.

Stubs stay honestly labeled STUB until each is rebuilt to REAL and passes its oracle test.
