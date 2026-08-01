# L11 module namespacing — implementation map (deferred; resume-ready)

Status: DEFERRED behind higher-value work (Tier 2 float-array perf). The full design analysis
below is complete so the eventual implementation is a matter of execution, not re-discovery.
Owner intent (2026-07-25): "complete it fully" — do it after the perf mountain.

## Why deferred
The current FLAT, PREFIXED model works: modules use `seq_map` / `list_map`, so modules are
already collision-free — just verbose. Full namespacing (`seq.map` / `list.map` coexisting
unprefixed) is an ERGONOMIC win, not a correctness/soundness fix. It is XL: ~30 resolution
sites, 5 miscompile seams, and it BREAKS the bare-call convention (`seq_map(...)` after
`import seq`) unless module-scoped resolution is threaded through lowering comprehensively.

## Two phases
- **Phase 1 (safe, low value):** cross-module collision DETECTION. Today two modules exporting
  the same name → silent last-wins in inference (ti_define @14245, no seen_fns check for module
  fns) + an LLVM dup-symbol at link (no guard; main-file-only dup check is at 14250). Turn that
  into a clear compile error. Place the check at the module-fn registration (~14245) using a
  `fn_src` map (name → source label); guard re-imports by module path so the same module twice
  is not a false collision. Must NOT fire on the prefixed stdlib (only EXPORTED, non-`_` module
  fns are registered, and those are prefixed).
- **Phase 2 (XL, the real feature):** per-module mangling `M__func` + module-scoped call
  resolution so unprefixed same-named fns coexist. Requires threading module context through
  lowering (absent today: "No module context is threaded through lowering").

## Site inventory (from a full compiler sweep — all in nova_compiler.nova)
EMIT function LLVM name:
- 11080 `ir_lower_function`: `emit_name = name` (main→nova_user_main) — THE origin.
- 18344 `ire_emit_function`: `define i64 @<name>`; 18166 extern `declare`.
- 20258 trampoline `define @<tname>` / 20274 body `call @<target>`.
- 20413 `nova_rt_register_fn(..., @<rfn>)` — call-by-name string registry (mangle emit AND string).
- Legacy cg backend (use_ir==0, no imports): 7388 emit_function, 7419 emit_nova_main.

RESOLVE call target by name:
- Plain `call` Expr entry 8337 `fn_name = value`; main resolver 8583-8607 (`ir_fnames` bare, else
  resolve_runtime_fn); derived-method dispatch 8480-8543; UFCS `ir_methods` 8546; `ir_sdefs`
  ctor 8581.
- module-qualified `mod.func` 8656-8668 (`ir_modules[rval]` + `mod_fns` → emits BARE `value` —
  the collision core; Phase 2 emits `alias__value`).
- typed method 8673-8681; runtime type-hash dispatch 8682-8737; operator overloads 8055/8071/8088.
- closures/trampolines: 7682 ir_lift_lambda `__lambda_N`, 7728 ir_lift_nested_fn `__nfn_<orig>_N`,
  8203 `__fnref_<value>`, 11045 `<name>_gen`.
- resolve_runtime_fn (4966), resolve_method_fn — stdlib name→nova_rt_* maps.

Registries keyed by fn name (need mangled keys in Phase 2):
- ir_fnames, ir_fn_arity, ir_fn_returns, ir_fn_defaults, ir_fn_ret_list_elem, ir_gen_fns,
  ir_modules, ir_methods, ir_method_dispatch, ir_ffi_wrapped, ir_extern_out_idx.
- HM inferencer (TiState): ti_fn_types (13424, copied to frt @19957 — the bare→emit seam vs the
  emit-keyed fixpoint @19997), ti_modules (14248, read 13032-13046 for mod.func inference —
  inference resolves via ti_modules[alias][value] on the BARE name, so mangling emit-names alone
  does NOT break inference IF the ti_fn_types→frt seed and the emit-name fixpoint keys are
  reconciled), ti_min_arity, ti_variadic, ti_fn_bounds, ti_extern_fns, ti_type_methods.

Module import mechanism:
- compile_module_ir (~20561): parses module, recursively compiles its imports (transitive), for
  each `fn name != main` pushes to mod_fns + ir_fnames (BARE, 20596), lowers via ir_lower_function
  (20696) into the flat ir_fns, records ir_modules[mod_name]=exported (20701). Module-internal
  A→B call resolves BARE via ir_fnames (8583) — no module context threaded.
- resolve_and_compile_imports (~20706): all_ir_fns accumulates every module's fns flat; `visited`
  dedups module COMPILATION by path.

Existing collision handling: main-file only (seen_fns @14224/14250). Module fns: none. No dedup on
ir_fnames/all_ir_fns → two same-named fns each emit `define @name` = LLVM dup symbol at link.

Silent-miscompile watch-list for Phase 2 mangling (each independently picks/emits a callee name and
must agree on the mangled form): 8656-8668 (mod.func), 8583 (module-internal + cross-module bare),
8203 (__fnref), 20413 (call-by-name registry), the ti_fn_types(bare)→frt(emit) seam @19957 vs 19997.

## VERIFIED 2026-08-01 — Phase 1 works; Phase 2 refined

**Phase 1 collision detection VERIFIED live (both halves):**
- Two different modules exporting the same name -> clear compile error naming BOTH modules
  (`function 'shared_name' is exported by two modules ('modx' and 'mody')`).
- The same module reached TWICE (direct import + transitively via another module) is NOT a false
  collision — module identity is the file path. Pinned by `_kat_l11_reimport`.

**So LOCK-1's SOUNDNESS risk is already covered.** The silent last-wins and the opaque LLVM
duplicate-symbol at link are both gone. What remains in Phase 2 is ERGONOMICS (unprefixed
`seq.map` / `list.map` coexisting) plus FUTURE ABI safety across separately-compiled packages.

**REFINED PHASE 2 — split it, because the two halves have very different risk:**

*(2a) SYMBOL-ONLY MANGLING (the ABI half — safe, self-contained).* Mangle only the EMITTED LLVM
name to `M__func`; keep source-level resolution flat. This addresses exactly the risk the master
plan cites for doing LOCK-1 first ("bare `@name` symbols collide across packages -> ABI break if
changed later") and does NOT break the bare-call convention, so none of the 1830+ stdlib modules
need migrating. The map already establishes this is viable: inference resolves via
`ti_modules[alias][value]` on the BARE name, so mangling emit-names alone does not break inference
PROVIDED the `ti_fn_types`(bare) -> `frt`(emit) seed @19957 and the emit-keyed fixpoint @19997 are
reconciled. Scope: the ~6 emit sites + the call sites + that one seam.
NOTE its benefit is only realised once a package manager exists (6.1, still open) — until then it
is pure future-proofing, which is the argument for doing it early rather than urgently.

*(2b) MODULE-SCOPED RESOLUTION (the ergonomics half — genuinely XL).* Unprefixed same-named fns
coexisting requires threading module context through lowering (absent today) across ~30 resolution
sites and 11 name-keyed registries, and it BREAKS `seq_map(...)`-style bare calls. This is the part
to schedule deliberately, not incrementally.

**Do NOT attempt either half piecemeal.** The watch-list below lists 5 places that each
independently pick/emit a callee name; any disagreement between them is a SILENT WRONG-CALLEE —
the worst failure class, and one no existing test would catch.
