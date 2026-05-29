# NOVA Deep Code-Level Audit — 2026-05-29

**Auditor:** Chief Language Architect (Claude). **Build:** compiler `gen3_test.exe` (gen25, 934,912 bytes),
runtime `output/nova_runtime.c` (10,218 lines), self-hosting source `nova_compiler.nova` (11,469 lines).
**Regression at audit time:** 75/75 PASS, 0 FAIL.

**What this document is.** The canonical [IMPLEMENTATION_AUDIT.md](IMPLEMENTATION_AUDIT.md) is a *feature/phase* ledger
(REAL/PARTIAL/STUB per capability). This document is its *code-level* companion: a line-by-line verification of the
compiler pipeline, the value model, and the compiler↔runtime contract, with the express goal of **finding defects a
feature table cannot see** — cross-reference breaks, silent miscompiles, dead code, and reader/writer mismatches.
Where the two disagree, corrections to the canonical ledger are listed in §10.

**Method.** (1) Read `nova_compiler.nova` stage-by-stage and built a verified structural map. (2) Verified the value
model (boxing) at both write and read sites. (3) Verified unifier soundness. (4) Cross-referenced every NOVA-callable
runtime symbol: *mapped in `resolve_runtime_fn`* ↔ *declared in codegen* ↔ *defined in the runtime* ↔ *tested*.
(5) Swept the runtime for box-unaware numeric readers (the bug class fixed in tensors this session). (6) Confirmed
each existing STUB/FAKE claim against current code. Every finding below was verified directly, not inferred.

---

## 1. Compiler architecture — VERIFIED REAL

`nova_compiler.nova` is a genuine, complete compiler written in NOVA. Verified stage map (line refs):

| Stage | Lines | What it does (verified) |
|---|---|---|
| Lexer | 92–663 | `tokenize_file`; char classes; f-strings/interp; hex/bin/float literals; BOM; **error recovery** (`sync_to_stmt`) so multi-error programs don't crash |
| Parser | 664–1886 | Pratt expression parser (`prefix_bp`/`infix_bp`); decls: `fn`/`type`/`trait`/`enum`/`extern`(FFI)/`import`; statements; patterns/match |
| Legacy direct codegen | 1886–3966 | `codegen_*` + `resolve_runtime_fn` (name→symbol, 2417–3345) + `emit_runtime_declarations` (3392) |
| IR lowering | 4040–5937 | closure conversion (`ir_lift_lambda`/`ir_lift_nested_fn`, free-var capture), `ir_lower_expr/stmt/function` |
| Type system (HM) | 5937–8034 | unification w/ occurs-check, generics, trait bounds, `ti_build_stdlib`, inference, exhaustiveness, unused/break-continue lints |
| IR optimizer | 8034–8358 | TCO (`ir_tco`), dead-block/instruction elim, constant folding |
| IR type inference | 8358–8874 | `ir_infer_one` — type-directed rewriting; **where boxing is inserted** (FINDING #1) |
| IR→LLVM emitter | 8920–9735 | `ire_emit_inst` lowers IR to LLVM text; multi-target datalayout/triple |
| Driver / modules / toolchain | 9735–11469 | `compile_ir_core_named` pipeline; module resolution; package manager; LSP server; CLI |

**Canonical pipeline** (`compile_ir_core_named`, 9787): `tokenize_file → parse_program → ti_infer_program_named
(HM) → new_ir_builder/emitter → resolve_and_compile_imports → lower fns to IR → optimize → ir_infer_types →
ire_emit_function → LLVM text`. Errors at parse and type stages abort with messages + source snippets.

**Finding A1 — two divergent backends (maintenance hazard, not a bug).** The IR backend is canonical: `run`/`build`/
`compile` default to `use_ir = 1` (11334). The legacy direct-codegen path (`compile()` 9735, `codegen_*`,
`resolve_runtime_fn`, `emit_runtime_declarations`) is reachable **only** behind `--old` (11342). Consequence: the
runtime name→symbol map and the `declare` list exist **twice** — once for legacy (`resolve_runtime_fn` + `emit_*`)
and once for IR (inline resolution + the `ire_line "declare …"` block ~9899–10110). A runtime function added to one
path but not the other silently diverges. This is the structural root of findings A2/A3 below. *Recommendation:* treat
the legacy path as deprecated; either delete it or generate both declaration lists from one source.

---

## 2. Value model & boxing — VERIFIED SOUND (write and read)

All NOVA values occupy one 64-bit slot. Heap objects carry an 8-byte RC+tag header; primitives are bare. To let
`Any`-typed containers carry float/bool without losing type, the compiler **boxes** float/bool at *typed write sites*:

- **Write (verified, `ir_infer_one`):** `list_append` of a `float`→`nova_rt_list_append_fbox`, `bool`→`_bbox`
  (8577–8585); `index_set`/dict-set marks `fbox`/`bbox` (8670–8673). Ints are **never** boxed (stay raw → the
  compiler's own `List<Any>`-of-ints bootstrap stays valid). A list starting as `intlist` promotes to `list` when a
  non-int is appended (8572).
- **Read (verified, emitter):** `index_get` on a list does `load` then `call nova_rt_unbox` (9446–9447); dict reads
  go through `nova_rt_dict_get`; `list_get`/`dict_get` unbox. **For-loops are safe**: `for x in xs` lowers to
  `index_get` (5284), i.e. it unboxes.

**This means the boxing model itself is correct.** The tensor corruption fixed earlier this session was *not* a
boxing defect — it was a **reader** that bypassed the unbox accessor. That defines the one real risk class (§6).

---

## 3. Type system — VERIFIED SOUND

`ti_unify_d` (6274): walks both sides, **occurs-check before every bind** (6310/6315, no infinite types), handles all
`NType` kinds (primitives, `var`, `struct` by name, and arity-checked recursion for `list/dict/tuple/channel/fn/sum/
process`), and ends in a **real catch-all error** (6332) — no silent acceptance of mismatches. A depth/count guard
(6276) bounds work on pathological input (pragmatic; could stop early but is a self-host safety valve).

**Deliberate design choice (not a hole):** `int`/`float`/`bool` are **mutually unifiable** (6323–6328) — Python-like
numeric coercion + C truthiness. Consequence: the *type* checker will not flag int-where-float; concrete numeric type
is tracked separately at the IR layer (`ir_reg_type`) for boxing/codegen. Accepted tradeoff (simplicity over strictness).

---

## 4. Cross-reference integrity — DEFECTS FOUND

Totals: 450 symbols in `resolve_runtime_fn`; 494 unique declared symbols; 514 runtime definitions.

| # | Symbol | Mapped | Declared | Defined | Severity | Verified finding |
|---|---|---|---|---|---|---|
| **B1** | `nova_rt_read_bytes` | ✅ 2538 | ✅ 3484/10009 | ❌ **none** | **HARD LINK ERROR** | `read_bytes(path)` is fully wired (incl. type reg 6505) but **has no C definition**. Any program that *calls* it fails to link. Latent only because no test uses it (so 75/75 passes). Also **mis-typed**: `nt_fn([nt_int()], nt_string())` (int→string) — wrong for a path reader. |
| **B2** | `nova_rt_dict_contains` | ❌ unmapped | ✅ 3411/9918 | ❌ none | LATENT | Declared in both backends, never emitted as a call, no definition. Harmless today (unused decl); a future call would link-error. Almost certainly meant to be `nova_rt_dict_has`. |
| **B3** | UDP: `nova_rt_udp_bind/send/recv` | ❌ **unmapped** | ❌ | ✅ 4535+ | **REACHABILITY** | Defined in the runtime but **zero references in the compiler** (no map, no declare, no test). **NOVA code cannot call UDP at all.** The canonical ledger's "TCP/UDP sockets REAL" is **false for UDP** — it is unreachable dead code. TCP is genuinely reachable; UDP is not. |

---

## 5. Stub/fake confirmation — canonical ledger was HONEST

Every TIER-3 STUB/PARTIAL claim re-verified against current code; all hold:

| Function (runtime line) | Verdict | Note |
|---|---|---|
| `tls_listen` (9336), `tls_accept` (9340) | **STUB** | `return 0` everywhere, honest comment. TLS *server* unimplemented. |
| `tls_connect/send/recv/close` non-Windows (9423+) | **PLATFORM STUB** | `return 0`/empty on Linux/macOS. TLS *client* is Windows-Schannel-only (REAL there). |
| `model_load` (10046), `model_infer` (10066) | **FAKE** | `model_load` opens+closes file, keeps only the path; `model_infer` returns input unchanged (identity). **Zero computation.** Superseded by the REAL tensor pipeline (`tensor_from_list`/`matmul`/…), but the fake API is still callable — a trap. *Recommend deleting these legacy stubs.* |
| `gpu_*` (9819–9883) | **PARTIAL / CPU-only** | `alloc/free/write/read` = plain `calloc`/`memcpy`; `kernel_run` runs 4 hardcoded CPU loops; `threads` ignored; `gpu_sync` no-op. Real elementwise math, not a GPU. |
| `dap_log/breakpoint/send` (9029–9046) | **PARTIAL / log-only** | Emits valid DAP JSON but never pauses/inspects. No real debug session. |
| `deploy_config` (10189), `deploy_validate` (10203) | **FAKE** | Builds a dict; validate returns success for any input. No provider integration. |
| `wasm_run` (9751) | **PARTIAL** | Real LEB128 parse + i32 stack interp for 7 opcodes (`const`,`add`,`sub`,`mul`,`and`,`or`,`xor`,`end`). **No control flow / memory / calls / locals / i64/f32/f64** → cannot run real modules. |

---

## 6. Box-unaware numeric readers — NEW correctness defects

The bug class fixed in tensors this session (a C function reads list backing storage `data[i]` and treats it as a
number without unboxing). A push/json/file-built float list stores **box pointers**; a literal float list stores raw
IEEE bits. Both break a raw integer-style reader. Sweep results (verified live = mapped + declared in both backends):

| # | NOVA API | Function (line) | Broken for | Live? |
|---|---|---|---|---|
| **C1** | `sum(xs)` | `nova_rt_sum` (4846) | boxed-float (adds pointers) **and** raw-float (adds IEEE bits as int) | ✅ mapped 2693 |
| **C2** | `min(xs)` | `nova_rt_list_min` (4883) | both (compares pointers / signed-bit) | ✅ mapped 2689 |
| **C3** | `max(xs)` | `nova_rt_list_max` (4893) | both | ✅ mapped 2691 |
| **C4** | `sort(xs)` | `nova_rt_list_sort`+`cmp_int64` (1146) | boxed-float (sorts by heap address!); raw-float unreliable (IEEE-bits-as-signed-int order) | ✅ mapped 2485/2519 |
| **C5** | `any(xs)`/`all(xs)` | `nova_rt_any_truthy`/`all_truthy` (4865) | boxed `false`/`0.0` read as truthy (non-null pointer) | ✅ mapped 2673/2675 |

All silently return wrong answers on float lists — no crash, no error. **Same root cause as the tensor bug; same fix:**
route element reads through `nova_elem_to_double` (already added this session) and, for min/max/sort, compare on the
double while returning the original element. Int-only lists are unaffected (ints are never boxed). *These are the
highest-priority correctness fixes; all are runtime-only (no compiler change, no re-bootstrap needed).*

---

## 7. Dead code — ~17 functions (~300 lines)

Defined in the runtime but neither mapped nor called (cross-validated independently for the iterator set):
`iter_has_next`/`iter_get`/`list_iter_has_next`/`list_iter_get` (758–790, superseded by unboxing `index_get`),
`list_print` (779, superseded by type-aware `any_to_str`), `udp_bind/send/recv` (4535+, never wired — see B3),
`http_accept`/`http_respond` (4601/4755, superseded by `*_raw`), `ws_accept_key` (9500), `bool_to_str` (891),
`dict_len` (1509), `str_len` (900), `dict_get_concat2`/`dict_set_concat2` (1344/1368), `track_raw` (464).
Not harmful (LLVM drops unused), but they inflate the runtime and (for UDP) misrepresent capability. *Recommend pruning.*

---

## 8. Test/oracle reality

75/75 regression PASS. Oracle discipline is genuinely followed (NIST/RFC vectors for crypto, RFC 6455 WebSocket accept
vector, hand-computed tensor/matmul, real external TCP/TLS clients). **One name-vs-substance gap:** `phase13_ai_test`
asserts real values but exercises the *legacy 1D-int `arr_*` helpers*, **not** the tensor/inference pipeline — its name
overpromises. Genuine AI coverage: `ai_classify_test`, `ai_infer_test`, `ai_model_test`, `tensor_boxed_float_test`, and
the `ai_serve` HTTP oracle (`{"features":[1,2]}`→`{"class":1}`). New this session: `tensor_boxed_float_test`,
`tensor_churn_test`, `json_decode_float_test`, `ai_classify_test` added to regression.

---

## 9. Honest verdict — what is REAL vs NOT

**REAL and sound:** the compiler (lexer→parser→HM types w/ generics+traits→IR→optimizer→LLVM), self-hosting at
0.98× C, the value/boxing model (write **and** read), error recovery, modules, package manager, LSP. Stdlib:
lists/dicts/sets/strings/iterators/collections/math/channels/Result-Option/arena, crypto (NIST/RFC), regex, datetime,
JSON (int/float/bool/containers), tensors (after this session's fix), HTTP server+framework, WebSocket (RFC 6455),
TLS client (Windows), distributed transport (length-framed), FFI to real C, WASM (straight-line i32), GPU (CPU
elementwise), and the cross-domain AI HTTP service.

**NOT real / partial (honest):** TLS *server* (stub), UDP (unreachable — B3), `read_bytes` (link error — B1),
`sum/min/max/sort/any/all` on **float** lists (silently wrong — C1–C5), ONNX/GGUF model load+infer (fake), real-device
GPU, WASM control flow/memory, interactive debugger, cross-platform HTTP client + TLS, distributed fault-tolerance,
archetype ECS / render / audio / physics, real deploy. mobile/embedded not started.

---

## 10. Corrections to the canonical ledger (IMPLEMENTATION_AUDIT.md)

1. "TCP / **UDP** sockets (winsock) REAL" → **UDP is unreachable (B3)**; only TCP is reachable. Downgrade UDP to STUB/unwired.
2. Add **B1** `read_bytes` hard link error (+ wrong type signature).
3. Add **C1–C5**: `sum/min/max/sort/any/all` silently wrong on float lists (the box-unaware-reader class).
4. Update "71/71" → **75/75**; add `tensor_boxed_float_test`/`tensor_churn_test`/`json_decode_float_test`/`ai_classify_test`.
5. Tensor row: note the boxed-float fix (`nova_elem_to_double`) — push/json/file-built float tensors now correct.
6. Add the **AI inference HTTP service** (`ai_serve.nova`) as a REAL cross-domain oracle.
7. Note `phase13_ai_test` tests legacy `arr_*`, not the real AI pipeline (§8).
8. Note line-ref drift (e.g. matmul now ~5334, not 5218) and the two-backend duplication hazard (A1).

---

## 11. Prioritized remediation plan

**P0 — correctness, runtime-only, no re-bootstrap:**
- Fix **C1–C5** (`sum/min/max/sort/any/all`) via `nova_elem_to_double` (compare-on-double, return original element).
- Fix **B1** `read_bytes`: either implement the C definition with a correct `string→bytes/string` contract, or remove the dangling mapping/declaration/type-reg (YAGNI; nothing uses it).
- Remove **B2** `dict_contains` dangling declaration (or alias to `dict_has`).

**P1 — honesty/cleanup:**
- Delete fake `model_load`/`model_infer` (superseded; currently a trap).
- Either wire **UDP** to the compiler (map+declare+test) or delete it; fix the ledger either way.
- Prune the ~17 dead functions (§7).

**P2 — capability (tracked, larger):** TLS server, WASM control-flow/memory, real-device GPU, interactive debugger,
cross-platform HTTP/TLS, distributed fault-tolerance, archetype ECS + render/audio/physics, ONNX/GGUF, real deploy.

**P3 — architecture:** retire or single-source the legacy `--old` backend to remove the duplication hazard (A1).
