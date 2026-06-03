# NOVA — Master Execution Worklist (single ordered list)

**Mandate (user, 2026-06-03):** work task-by-task, top to bottom, no stopping, no asking, every item
production-grade + verified through the gate (precheck → gen4 smoke → bootstrap reconverge gen5==gen6 →
full regression → commit; kill-on-timeout mandatory). NOVA is the universal *future* computing language —
ship high-end, futuristic capabilities, not just parity. Mark items DONE here as they land.

Legend: `[ ]` todo · `[~]` partial/in-progress · `[x]` done. Source detail: NOVA_DESIGN/REMAINING_FEATURES.md.

---

## PHASE A — Foundational correctness (DO FIRST)
- [ ] **A1. int/float mixed-collection fix** (the #1 soundness gap). Staged:
  - [ ] A1.1 `list_create_filled` boxes a float fill value (compiler knows the type).
  - [ ] A1.2 `map_fbox` — route `map`→boxing variant when the closure's `ir_fn_returns` type is float
        (the type channel found at nova_compiler.nova L5067); ensure lambda return types are recorded.
  - [ ] A1.3 THE FLIP — collection element reads (list_to_str / sum_f·min_f·max_f / nova_elem_to_double)
        treat raw=int, box=float/bool (heuristic-free); SCALAR any_to_str + nova_is_likely_float keep the
        heuristic. After A1.1-2 every collection float is boxed → sound. Probes: big-int-in-mixed-list,
        map-returns-float-list, sum of mapped int list. GATE-5 perf recheck.
  - [ ] A1.4 (optional) scalar-any boxing (ret/call-arg emitter) → delete the scalar heuristic for full closure.

## PHASE B — Signature CORE that makes NOVA special (high leverage, achievable)
- [ ] B1. Lazy / infinite generators — `yield` becomes a Process onto a bounded Channel (back-pressured, O(1) mem).
- [ ] B2. Multi-clause function heads with guards (fuse same-name heads → match decision tree).
- [ ] B3. Type-safe variadics (`f(xs: int...)` → trailing rest packed into a typed list).
- [ ] B4. Must-use enforcement on Result/resource returns (automatic, zero-annotation).
- [ ] B5. `static_assert` + design-by-contract (requires/ensures) via const-fold/comptime.
- [ ] B6. `T?` optionality sugar + non-null flow narrowing.
- [ ] B7. Immutability-by-default with inferred mutability (no `mut` keyword).
- [ ] B8. Typed JSON decode (`<Type>__from_json`) — completes Serde round-trip.

## PHASE C — Erlang-class fault tolerance (NOVA's killer differentiator)
- [ ] C1. Real crash isolation — fault boundary per spawned Process (setjmp/SEH/signal), real exit_status.
- [ ] C2. Process linking/monitoring → typed {pid,reason} message to watcher Channel, auto-fired on exit; link cascade.
- [ ] C3. GenServer — typed Sum request protocol → compiler-generated receive loop + exhaustiveness-checked dispatch.
- [ ] C4. Supervision trees + restart strategies — compiler proves every Process is supervised.
- [ ] C5. Selective receive (per-variant sub-channel demux, O(1)).
- [ ] C6. Hot code reload / live upgrade (dlopen per-module + versioned ABI + state migration).

## PHASE D — Run ANYWHERE (universal deployment)
- [ ] D1. WASM target hardening (browser + edge).
- [ ] D2. GPU compute path (kernels from process bodies).
- [ ] D3. Freestanding / no-runtime (bare-metal/embedded) mode — capability-gated builtin subset.
- [ ] D4. C-ABI shared library output (.dll/.so/.dylib) + auto export-set from `_`-privacy.
- [ ] D5. Async reactor (epoll/kqueue/IOCP) — non-blocking I/O with NO function coloring; green-thread park/resume.

## PHASE E — Fast + memory (beat C/Rust)
- [ ] E1. Persistent immutable collections (HAMT/RRB structural sharing) auto-selected when shared.
- [ ] E2. SIMD auto-vectorization of element-wise kernels (target-feature gated).
- [ ] E3. Off-heap / mmap regions + typed bounds-checked arena views.
- [ ] E4. Alignment / packing / cache-line control (align(N), packed, auto align-64 for shared).

## PHASE F — Data, codecs, serialization
- [ ] F1. gzip / DEFLATE / zlib + zip container (RFC 1951/1952, reuse crc32).
- [ ] F2. Compact binary term codec (MessagePack/term_to_binary-class) for channel wire + storage.
- [ ] F3. Binaries / bitstrings with bit-level pattern matching (`<<ver:4, ihl:4, rest..>>`).

## PHASE G — Networking / web depth / distributed
- [ ] G1. HTTP depth — sessions, multipart/form-data, chunked streaming, middleware chain.
- [ ] G2. Transparent distributed channels — a Channel whose far end is a remote node just marshals automatically.
- [ ] G3. URI parse/build (RFC 3986) in urlx; subprocess spawn + stdio redirect + signals + at_exit.

## PHASE H — Genius-compiler metaprogramming
- [ ] H1. Turing-complete comptime (interpret pure fns at compile time when inputs are known).
- [ ] H2. Hygienic AST macros (quote/unquote) built on expand_derives + comptime.
- [ ] H3. Compile-time type introspection (is_integral/field_names) + type-driven specialization.
- [ ] H4. Conditional compilation by target/config (typed `if target==..`, dead-branch DCE, all branches type-checked).
- [ ] H5. General user-directed mixins/`use` (promote expand_derives to a capability registry).

## PHASE I — Strings / Unicode / regex / parsing
- [ ] I1. Linear-time regex engine (Thompson NFA / Pike VM) + named captures + lookaround + Unicode classes (kills ReDoS).
- [ ] I2. Unicode normalization (NFC/NFD) + grapheme clusters (UAX-29) + casefold + collation.
- [ ] I3. Reusable Tokenizer/scanner + parser-combinator/PEG stdlib modules.

## PHASE J — Time / numerics
- [ ] J1. Timezone DB (embedded IANA) + UTC accessors + cross-tz arithmetic.
- [ ] J2. Instant(monotonic) / DateTime(wall) / Duration as distinct zero-cost newtypes (no cross-clock mixing).
- [ ] J3. Compile-time dimensional analysis (units: meters+seconds = type error), erased to f64.

## PHASE K — Tooling / DevX / distribution
- [ ] K1. NOVA-native debugger (DAP: breakpoints/step/inspect over the value model + Process/Channel state).
- [ ] K2. Doctests (executable `///` examples, type-checked + run in the isolated test runner).
- [ ] K3. `curl|sh` / `iwr|iex` installer + remove dead Java launcher; transitive dep resolution + reproducible builds.

## PHASE L — Concurrency escape-hatches + reflection
- [ ] L1. `Atomic<int>` + documented happens-before (lock-free counters), seq_cst.
- [ ] L2. Concurrent collections (actor-fronted dict/list, auto lock-free when reads dominate).
- [ ] L3. OS threads + `process_local` TLS; mutex/condvar with compiler-checked lock-ordering (deadlock-free).
- [ ] L4. Runtime introspection (fields/methods, dynamic invoke) + dynamic proxy synthesis + `eval`.

## PHASE M — ★ FUTURISTIC NOVA-DEFINING (the moat — visionary, no language has all of these)
- [ ] M1. **Auto-parallelization** — the genius compiler auto-spawns data-parallel loops across cores when proven safe.
- [ ] M2. **Auto-distribution** — compiler places Processes across nodes from a topology hint; channels go transparently remote.
- [ ] M3. **AI-native core** — reverse-mode autodiff on Values, tensor-op fusion, model load+serve+quantize as first-class.
- [ ] M4. **Effect & capability system** — effects (IO/alloc/net) inferred; capability-scoped security proven at compile time.
- [ ] M5. **Verified concurrency** — deadlock-freedom + data-race-freedom by construction (the Process/Channel model, enforced).
- [ ] M6. **Reactive/dataflow primitives** — first-class signals/streams that recompute incrementally.
- [ ] M7. **Self-optimizing AOT** — profile-guided + auto-target-selection (CPU/GPU/WASM) chosen by code analysis.
- [ ] M8. **Universal one-binary full-stack** — backend+frontend(WASM)+AI+deploy from one program, one command.

---
*Execution rule:* finish A fully (correctness foundation), then drive B→M. Each item: design the NOVA way
(automatic, unified, zero-ceremony — never borrowed annotations), implement production-grade, gate, commit,
tick the box. Large items decompose into sub-batches; each sub-batch is its own gated commit.
