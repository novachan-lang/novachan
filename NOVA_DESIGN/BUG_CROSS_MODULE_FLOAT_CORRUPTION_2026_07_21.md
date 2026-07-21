# BUG: cross-module float corruption (discovered + FIXED 2026-07-21, task-100 quantum build)

## Status: FIXED — root cause was `ire_proven_float` not being reset per function.

### ROOT CAUSE
The `ire_line` backend inlines float-math builtins to native LLVM intrinsics
(`sqrt`→`llvm.sqrt.f64` etc.) instead of the boxed runtime call `nova_rt_sqrt`, gated on
`contains(e.ire_proven_float, args[0])` — a set of SSA register names PROVEN to hold raw double
bits. That set is keyed by register name (`%r0`,`%r1`,…), which **resets to `%r0` at the start of
every function**. But `ire_emit_function` (nova_compiler.nova ~line 17679) reset ten other
per-function maps (`ire_reg_types`, `ire_load_origin`, …) and **forgot `ire_proven_float`**. So a
`%rN` proven-float in an earlier function stayed marked, and a LATER function's `%rN` (a boxed-float
value, e.g. a float returned across a call like `n2 = norm2(state)`) was wrongly treated as native
raw-double and `bitcast i64→double` — reading a box handle as an IEEE double → silent NaN. It
surfaced across module boundaries because importing another module adds earlier functions whose
register numbering lands a proven-float on the same `%rN` the victim's `sqrt` arg uses.

### FIX
Added `e.ire_proven_float = {}` to the per-function reset block in `ire_emit_function`
(nova_compiler.nova). One line; completes the intended per-function scoping of the raw-double proof.
Verified: minimal 2-module repro + the quantum foundation cross-module repro both go from
INT64_MIN → correct under the rebuilt compiler. Gated by reconverge (gen5.ll==gen6.ll) + both-mode
nova_ci. Durable regression = std/quantum's multi-import KATs.

### (original OPEN writeup below, kept for the record)

## One-line
Calling *any* float function in one imported module can silently corrupt the float
results of a subsequently-called float function in a *different* imported module — the
second function's floats come back NaN/garbage (`float_to_int` → INT64_MIN = -9223372036854775808).

## Minimal repro (kept in tree)
- Modules: `std/quantum/quantum_qubit.nova` (prefix `qbt_`) + `std/quantum/quantum_state.nova` (prefix `qst_`). Both LEAF, both pure-NOVA, both individually correct.
- Driver: `nova-compiler/test_programs/_qrepro2.nova`:
  ```
  import std/quantum/quantum_qubit
  import std/quantum/quantum_state
  fn main()
      let q = qbt_make(3.0, 0.0, 4.0, 0.0)
      print(str(qbt_prob0_x1000(q)))          // 9000 — CORRECT (|3|^2 unnormalized)
      let u = qst_zero(1)
      qst_set_amp(u, 0, qst_c(3.0, 0.0))
      qst_set_amp(u, 1, qst_c(4.0, 0.0))
      let un = qst_normalize(u)
      print(str(qst_prob_x1000(un, 0)))        // -9223372036854775808  — CORRUPT (want 360)
      print("done")
  ```
- Run: `NOVA_NO_CACHE=1 powershell -File _run1.ps1 _qrepro2`  (cache disabled + fresh names — NOT a cache artifact).

## What we PROVED (ruled out)
1. **Not a cache artifact.** Reproduces with `NOVA_NO_CACHE=1` and unique probe names.
2. **Not `qst_normalize` in isolation.** A driver importing ONLY `quantum_state` and doing the exact
   same `qst_zero`→`set_amp`→`norm2`→`normalize`→`prob` chain PASSES (returns 360). The corruption
   appears ONLY after a cross-module call into `quantum_qubit`.
3. **Not boxed-vs-native sqrt.** The compiler lowers `sqrt(literal)` as the boxed path
   `nova_rt_box_float`→`nova_rt_sqrt(i64)` and `sqrt(float_var)` as native `llvm.sqrt.f64(double)`.
   Both are individually self-consistent and correct (`nova_rt_sqrt = f2i(sqrt(nova_float_arg(x)))`).
   The failing call chain here uses NATIVE sqrt on both sides.
4. **Not sqrt at all.** `_qrepro2` triggers corruption with a qbt call that uses NEITHER sqrt NOR
   normalize — just `qbt_make` (list alloc) + `qbt_prob0_x1000` (a `float_to_int`). Merely calling
   into `quantum_qubit` first is enough.
5. **Not a symbol collision.** Linked `.ll` for `_qrepro2` has 49 `define`s, all unique names; no
   duplicate global/constant either.
6. **Order-dependent (agent's original finding).** The Wave-1 agent independently hit this on
   `qbt_normalize` and mitigated it by REORDERING functions within `quantum_qubit.nova` (see the
   NOTE comment at the top of that file). Reordering is a fragile band-aid, not a fix.

## Working hypothesis
Cross-module codegen/runtime state corruption — most likely arena/allocation or a per-function
codegen-state leak — where executing `quantum_qubit`'s (float+list-allocating) functions leaves the
allocator / a shared scratch slot in a state that makes a later `quantum_state` float computation read
garbage. Both modules are compiled into ONE `.ll` when imported together, so this is in the
compiler's multi-module lowering or the runtime allocator, NOT in the source modules.

## Why it matters
This is a latent CORRECTNESS hole for any float-heavy program that spans ≥2 imported modules. It has
gone unnoticed because most existing float stdlib modules aren't exercised in the specific
cross-module call sequences that trip it. It is exactly the class of bug the reconverge/self-host
gate cannot catch (pure-NOVA stdlib doesn't feed back into the compiler).

## Next steps to FIX (deliberate, reconverge-gated — do NOT rush)
1. lldb (`/c/Program Files/LLVM/bin/lldb`) on the `_qrepro2` exe: break at `qst_normalize`, inspect
   `slot.n2`/`slot.nrm`/the `out` list allocation; watch whether the corruption is in the value read,
   the sqrt result, or the list memory returned by the allocator.
2. Reduce to a NON-quantum minimal 2-module repro (two ~20-line modules) to isolate the construct.
3. Suspect areas in `nova-compiler/compiler/nova_compiler.nova`: the float specialization pass
   (`.ai`/`.rf` native-float lowering), the boxed-float ABI (`nova_rt_box_float`/`nova_float_arg`),
   and per-function codegen state that might not reset across module/function boundaries. In
   `nova_runtime.c`: the arena allocator + `nova_rt_box_float`.
4. Full both-mode nova_ci + reconverge (gen5==gen6) after any compiler/runtime change.

## Task-100 impact
std/quantum is BLOCKED on this fix (cannot ship a float-heavy 12-module library soundly while this is
open). The two foundation modules are retained ONLY as the repro vehicle — they are NOT to be
committed as shipped stdlib until this bug is closed and they pass clean multi-import KATs.
