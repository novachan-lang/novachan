# NOVA — EXECUTION STATE (live dashboard)

> **Goal:** complete CORE NOVA per `NOVA_MASTER_PLAN_2026_07_10.md` — every language feature + a full
> standard library, competitive with C/C++/Java/Python/Go/Erlang/Elixir/Rust (parity or ~1× beat), to
> JDK-scale (~200k+ lines) — BEFORE any framework work. Update this file in EVERY commit. Resume from here.
>
> **The gate (every change):** edit → precheck → build → **reconverge gen5==gen6 (compiler changes)** →
> regression BOTH modes → ASAN on risk surface → commit. Kill-on-timeout always. No cracked foundations.

## Two streams
- **Stream 1 — Opus (compiler/runtime foundation)** — `nova_compiler.nova` + `nova_runtime.c`. Sequential,
  reconverge-gated. Soundness FIRST, then language ceilings, runtime builtins, backend/FFI.
- **Stream 2 — Sonnet fleet (stdlib breadth)** — pure-NOVA modules in `std/`. Parallel, KAT-gated, one
  commit/module, NO reconverge. Independent libs start now; feature-dependent libs wait for Stream 1.

## Current focus
- Stream 1: **CORE_GAP 0.11 float-return-uninit** (Phase-0 Wave A #1 — the last silent-wrong-answer bug).
- Stream 2: standing up `std/` + first wave of foundation-independent stdlib modules.

## Stream 1 — compiler/runtime (Opus) — status
| Item | Phase | Tier | Status | Commit |
|---|---|---|---|---|
| 0.8 struct-field-leak | 0-A | A | ✅ DONE | fb1167cf |
| 0.11 float-return-uninit | 0-A | A | ✅ GUARDED | (batch 1) |
| trait-conformance sig type-check (LOCK-3) | 0-A | A | ⬜ NEXT | |
| user-enum payload typing | 0-A | A | ⬜ | |
| `==` NFC/NFD helper | 0-A | C | ❌ DROPPED — not a gap (byte-equality is correct; matches Python/Rust/Go — NFC-by-default would be *wrong*) | |
| `1<<64` shift guard | 0-A | C | ✅ DONE (gen4-verified; reconverge at batch arc) | (batch 1) |
| lexer: numeric separators | 0-A | C | ✅ ALREADY DONE (decimal/hex/binary all strip `_`; audit stale) | |
| lexer: `\u{}` escapes / labeled break | 0-A | C | ⏸ DEFERRED (low-value: `from_codepoint` covers `\u`; labeled-break is involved, not a quick win) | |
| RC: push/closure/reassign leaks (MOVE-on-insert) | 0-B | A | ⬜ | |
| RC cycle collector | 0-B | A(XL) | ⬜ | |
| ARM aarch64 fibers | 0-C | B | ⬜ | |
| N>1 per-carrier I/O | 0-C | B | ⬜ | |
| ALPN + Windows TLS server | 0-C | B | ⬜ | |
| FD_SETSIZE Linux guard | 0-C | B | ⬜ | |
| safepoint preemption + kill (LOCK-5) | 0-C | A(XL) | ⬜ | |
| constant-time `@ct` + `Secret<T>` (LOCK-7) | 0-C | A | ⬜ | |
| module namespacing `@mod__fn` (LOCK-1) | ceil | A | ⬜ | |
| sized/unsigned numerics + f32 (LOCK-4) | ceil | A(XL) | ⬜ | |
| annotations→codegen (LOCK-2) | ceil | A(XL) | ⬜ | |
| macros/comptime | ceil | A(XL) | ⬜ | |
| const generics · variance · assoc types | ceil | A | ⬜ | |
| custom index/iter/call operators | ceil | A | ⬜ | |
| enforced immutability `let mut` | ceil | A | ⬜ | |
| `@cdecl` FFI callbacks (LOCK-6) + struct-by-value | ceil | A | ⬜ | |
| monotonic type-id vtables | ceil | A | ⬜ | |
| explicit SIMD path | ceil | A | ⬜ | |
| runtime builtins: signals/sockets/glob/sync/PRNG/pack/math | rt | B/C | ⬜ | |
| regex capture-group engine | rt | B | ⬜ | |
| GPU lowering (SPIR-V/PTX) · MCU triples | backend | A(XL) | ⬜ | |

## Stream 2 — std/ stdlib (Sonnet fleet) — status
| Module | Category | Needs (Stream 1) | Status | Commit |
|---|---|---|---|---|
| (bootstrapping std/ structure) | — | — | 🔵 | |

*(rows added as modules are assigned/landed)*

## Batch log (what we did per task; full-arc runs after ~10 tasks)
### Batch 1 (Phase-0 foundation) — full-arc pending
1. **0.11 float-return-uninit → GUARDED.** Investigated: does NOT reproduce on the current post-0.8 compiler
   (correct at -O0 and -O2). Root: the garbage-uninit path is closed — every local slot (incl. all float
   locals) gets `store i64 0` zero-init at fn entry, and complex float returns (`sqrt(variance(xs))`) lower
   to pure SSA (no uninit temp). Action: tightened `_floatret_uninit_test.nova` from CI-safe (always exit 0)
   to a HARD ASSERT on stddev≈√2 + pearson≈0.7746, so any future layout shift that re-triggers it fails LOUD
   with a live repro. Test-only change (no compiler edit → no reconverge). *Next arc validates.*
2. **`1<<64` shift-UB guard -> DONE.** LLVM `shl`/`ashr` by >= bit-width is POISON (the `1<<64 -> garbage`
   bug). Fixed the ire emitter (nova_compiler.nova ~16462): mask the amount `& 63` for a valid shift +
   `select` the defined big-shift result (NOVA wraps: `shl`>=64 = 0; `ashr`>=64 = sign-ext). LLVM -O2
   constant-folds the guard away for constant amounts (zero cost); variable amounts keep it. gen4 built
   (compiler self-compiles with the new codegen) + `_shift64_guard_test` PASS (13/13). Compiler-only. Reconverge at arc.
3. **lexer scan (no code change):** numeric separators ALREADY done; `==`NFC/NFD is NOT a gap (byte-eq
   matches Python/Rust/Go); `\u{}` + labeled-break deferred (low-value; `from_codepoint` covers `\u`).
