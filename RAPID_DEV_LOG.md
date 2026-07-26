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
