# RAPID_DEV_LOG — branch `rapid-dev`

**Mode (owner-set 2026-07-26):** complete `NOVA_MASTER_PLAN_2026_07_10.md` + `NEXT_50_EXECUTION_2026_07_22.md`
as fast as possible on this branch. The 4-agent model continues (Sonnet dev + Opus verify, always-parallel,
higher-level `NOVA_LANGUAGE_FEATURES.md` toolkit, tick both plan files). **Heavy gates are BATCHED to the end:**
NO reconverge / NO full both-mode regression per change during rapid dev. Per change: library = write + one
compile (syntax) + adversary-verify + log here; compiler change = write + one gen4 build-check (toolchain must
stay alive) + log here. **Every change gets a row below.** master @ tag `before-rapid-dev` (`a0569ef8`) is the
clean, fully-gated baseline.

**END-TEST PASS (run before merging rapid-dev → master):**
1. Reconverge (gen5.ll == gen6.ll byte-identical).
2. Full both-mode regression (`nova_ci.ps1`, NORMAL + NOVA_T8_FULLRC = 0 FAIL, ASAN-clean).
3. Run every KAT in the "Test at end" column below.
4. Fix the batch; re-gate; then merge.

**Carried-over compiler findings to fix + verify at end (from `project_higherlevel_fleet_findings`):**
sort_by string/float-key silent-wrong · cross-module direct-type-param generics break on import · cross-module
any-float returns raw bits · imported builtin-name-collision method resolution · dict<int,int> type checker.

---

## Change log (every rapid-dev change; status starts UNTESTED)

| # | Change | Plan task | Files | Type | Test at end (KAT) | Status |
|---|--------|-----------|-------|------|-------------------|--------|
| — | *(master baseline `a0569ef8` — everything up to here already gated/tested)* | — | — | — | — | ✅ GATED |
| 1 | std/core/validate — Result validators (v_check/required/min_len/max_len/in_range/matches/all/errors/field) | higher-level stdlib (cap-gap) | std/core/validate.nova (+compiler copy) | lib | `_kat_validate` | UNTESTED (adversary CONFIRMED) |
| 2 | std/core/tree — generic n-ary tree (t_map/fold/values/leaves/depth/count/find→Option) | higher-level stdlib | std/core/tree.nova (+copy) | lib | `_kat_tree` | UNTESTED (KAT green) |
| 3 | std/text/template — dynamic {key} templating (tpl_render→Result/render_default/keys/fill) | higher-level stdlib | std/text/template.nova (+copy) | lib | `_kat_template` | UNTESTED — ⚠ adversary-verify ERRORED, self-KAT-verified only; SCRUTINIZE at end-test |
| 4 | **COMPILER** finding-#2 fix: imported `Type__method` now registers in ti_type_methods → fluent imported library APIs work (was "container element types must match" on first call) | #32 L11-adjacent / cap-gap | nova_compiler.nova (~14404) `311b3acc` | **compiler** | `_kat_query_import` (+ _kat_query/_kat_result_ext no-regress) | UNTESTED — ⚠ **NEEDS RECONVERGE at end-test** (compiler change, build-check only so far) |
| 6 | **RUNTIME** finding-#1 fix (SEVERE soundness): `sort_by` now sorts STRING keys lexicographically + FLOAT keys numerically (was raw-i64 compare = string keys by pointer, float keys by boxed-pointer/bits = silent-wrong data corruption; int-only was correct). Reuses `nova_rt_list_sort`'s proven kind detection (`nova_elem_is_str`/`nova_elem_is_float`/`nova_elem_to_double`). 3 edits in nova_rt_sort_by region: kind-aware `nova_sortby_key_cmp`, `kind` threaded through `nova_stable_msort_kv`, key-kind scan + kind-aware OOM fallback. | higher-level libs / soundness | nova-compiler/compiler/nova_runtime.c (~12637, ~12690) + KAT `_kat_sort_by_keys.nova` | **runtime** | `_kat_sort_by_keys` (string/float/negfloat/int/negint/struct-string-field/struct-int-field all correct) + `_kat_sort`/`_kat_query`/`_cat_collections_hof_probe` no-regress | UNTESTED — ⚠ **NEEDS RECONVERGE + FULLRC/ASAN at end-test** (C runtime change; ZERO reconverge sensitivity — compiler doesn't sort_by so gen5==gen6 unaffected; gen4-linked KATs green). BOUNDARY: struct FLOAT-field key (`fn(r) r.price`) still wrong via the separate DEFERRED HOF-float-trampoline bug (key corrupted pre-sort), not this code. |
| 5 | **COMPILER** finding-#4 fix: imported GENERIC fns now register a POLYMORPHIC scheme (bare-`T` param no longer pinned to the first call's type) — mirrors same-file mechanism. 3 edits: import loop fresh-var gmap (~14383) + `ti_generalize` poly register (~14401, was `ti_mono`) + `mod.func` path `ti_instantiate(ti_generalize(...))` (~13207, prevents new pollution). Unblocks generic IMPORTED library APIs (#1 higher-level-library blocker). | cap-gap / higher-level libs | nova_compiler.nova (~13207, ~14383-14411) + fixtures `_fresh_generic_mod.nova` `_kat_fresh_generic.nova` | **compiler** | `_kat_fresh_generic` (bare-T at 2 types) + `_kat_query`/`_kat_query_import`/`_kat_result_ext`/`_kat_collect` no-regress (all PASS on gen4) | UNTESTED — ⚠ **NEEDS RECONVERGE at end-test** (type-system change; gen4 build-check + 5 KATs green; compiler self-compile doesn't use imported generics so gen5==gen6 expected). At end-test also add a `mod.func`-style generic call at 2 types + re-check findings #6/#7 (same var-freshening seam — may now be fixed). |
