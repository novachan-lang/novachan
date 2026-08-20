# NOVA one-command CI gate (#3). This repo's authoritative pre-commit gate.
# (PROBED 2026-08-02: WSL2 Ubuntu IS installed and runs (`wsl -d Ubuntu -e uname -m` -> x86_64), so the
#  LINUX track is testable on this machine TODAY -- it had been treated as out of reach. Outbound network
#  is also UP (https GET -> 200), so anything parked on "sandbox network down" should be re-attempted.
#  The repo lives on Bitbucket and the bootstrap trust-root is a Windows binary, so there is still no cloud
#  runner today; cloud + multi-platform CI is item #23 on the Linux track. Until then THIS is "CI": run it
#  before every commit that touches the compiler or runtime.)
#
# Stages (fails fast, non-zero exit on any failure):
#   1. Bootstrap reconverge  -> gen5.ll == gen6.ll (compiler self-consistency) + installs gen5
#   2. Perf-regression gate  -> scalar/float/struct stay C-level native (no re-boxing)
#   3. Full regression       -> NORMAL mode + NOVA_T8_FULLRC mode (all tests, both RC paths)
#
# Usage:  powershell -ExecutionPolicy Bypass -File ./nova_ci.ps1   [-SkipReconverge]  [-Quick]  [-SkipPerfTrack]
param([switch]$SkipReconverge, [switch]$Quick, [switch]$SkipPerfTrack)
Set-Location $PSScriptRoot
$ErrorActionPreference = "Continue"

# Clean slate: kill any orphaned build process from a prior/aborted run before the gate
# starts — an orphan racing the bootstrap's nova_compiler.ll build would stall it at 0 bytes.
. "$PSScriptRoot\_proc_util.ps1"
Stop-StrayCompilers

if (-not $SkipReconverge) {
    Write-Host "`n[CI 1/3] Bootstrap reconverge (gen5.ll == gen6.ll)..."
    & .\_bootstrap_reconverge_slow.ps1
    if ($LASTEXITCODE -ne 0) { Write-Host "`n=== CI FAILED at stage 1 (reconverge/divergence) ==="; exit 1 }
} else {
    # CORE_GAP 7.4 — do NOT let the self-hosting check be skipped SILENTLY. Reconverge (gen5.ll==gen6.ll)
    # is the ONLY proof the compiler still compiles itself byte-identically; skipping it on a commit that
    # touches the compiler/runtime can merge a compiler that no longer converges. -SkipReconverge is for
    # fast inner-loop iteration on test/doc-only changes ONLY. Make the bypass loud + auditable.
    Write-Host ""
    Write-Host "  ############################################################################"
    Write-Host "  ##  WARNING: BOOTSTRAP RECONVERGE SKIPPED (-SkipReconverge)                ##"
    Write-Host "  ##  The self-hosting byte-identical fixpoint was NOT checked.              ##"
    Write-Host "  ##  This is SAFE ONLY for test/doc-only changes. NEVER use -SkipReconverge ##"
    Write-Host "  ##  to gate a commit that touches nova_compiler.nova or the runtime.       ##"
    Write-Host "  ############################################################################"
    Write-Host ""
}

Write-Host "`n[CI 2/3] Perf-regression gate..."
& .\_perf_gate.ps1
if ($LASTEXITCODE -ne 0) { Write-Host "`n=== CI FAILED at stage 2 (perf regression) ==="; exit 1 }

# CORE_GAP 2.5: continuous perf TRACKING. Run the timed bench harness and append one record per
# (bench,mode) to bench/history.jsonl, then compare vs the previous commit. NON-FATAL: absolute times
# on this host are tiny (0-42 ms) and memory-pressure-noisy, so a timing wobble must NOT red the CI.
# The FATAL codegen-regression guard is _perf_gate.ps1 above (native-op check). This stage makes every
# perf change *measured* over time (the 2.5 gap) without introducing flaky failures. -SkipPerfTrack to skip.
if (-not $SkipPerfTrack) {
    Write-Host "`n[CI 2/3b] Perf TRACKING (bench history append, non-fatal)..."
    & (Join-Path $PSScriptRoot "..\..\bench\run_bench.ps1") 2>&1 | Write-Host
    & (Join-Path $PSScriptRoot "..\..\bench\regression_check.ps1") -Threshold 40 2>&1 | Write-Host
    Write-Host "  (perf tracking is informational; see bench/history.jsonl)"
}

Write-Host "`n[CI 2c/3] #25 C-ABI @export gate (NOVA lib called from a pure-C host)..."
& .\_s25_export_check.ps1
if ($LASTEXITCODE -ne 0) { Write-Host "`n=== CI FAILED at stage 2c (@export C-ABI) ==="; exit 1 }

Write-Host "`n[CI 2c2/3] #2 package-manager gate (offline install + import + transitive + cycle)..."
& .\_pkg_install_gate.ps1
if ($LASTEXITCODE -ne 0) { Write-Host "`n=== CI FAILED at stage 2c2 (package manager) ==="; exit 1 }

Write-Host "`n[CI 2d/3] #27 no_std freestanding-allocator gate (static buffer, no libc malloc)..."
& .\_s27_freestanding_check.ps1
if ($LASTEXITCODE -ne 0) { Write-Host "`n=== CI FAILED at stage 2d (freestanding allocator) ==="; exit 1 }

Write-Host "`n[CI 2e/3] #30 interpreter gate (nova eval tree-walks expressions, no compile)..."
& .\_s30_eval_check.ps1
if ($LASTEXITCODE -ne 0) { Write-Host "`n=== CI FAILED at stage 2e (nova eval interpreter) ==="; exit 1 }

Write-Host "`n[CI 2e2/3] #30 REPL gate (interactive shell compiles+links+runs a line end-to-end)..."
& .\_test_repl.ps1
if ($LASTEXITCODE -ne 0) { Write-Host "`n=== CI FAILED at stage 2e2 (REPL end-to-end) ==="; exit 1 }

Write-Host "`n[CI 2e3/3] #9 Windows TLS server gate (SChannel server: PFX cert + inbound handshake + encrypted round-trip via a .NET TLS client)..."
& .\_test_tls_server.ps1
if ($LASTEXITCODE -ne 0) { Write-Host "`n=== CI FAILED at stage 2e3 (TLS server round-trip) ==="; exit 1 }

Write-Host "`n[CI 2f/3] #31 heap-profiler gate (NOVA_HEAP_PROFILE per-tag breakdown)..."
& .\_s31_heap_check.ps1
if ($LASTEXITCODE -ne 0) { Write-Host "`n=== CI FAILED at stage 2f (heap profiler) ==="; exit 1 }

Write-Host "`n[CI 2g/3] #32 semantic-LSP gate (hover returns the real function signature)..."
& .\_s32_hover_check.ps1
if ($LASTEXITCODE -ne 0) { Write-Host "`n=== CI FAILED at stage 2g (LSP hover signature) ==="; exit 1 }

Write-Host "`n[CI 2g2/3] #32b semantic-LSP diagnostics gate (CORE_GAP 6.4: real errors flagged, modern features clean)..."
& .\_s32b_lsp_diag_check.ps1
if ($LASTEXITCODE -ne 0) { Write-Host "`n=== CI FAILED at stage 2g2 (LSP diagnostics / false positives) ==="; exit 1 }

Write-Host "`n[CI 2h/3] #35 const-fn-eval gate (compile-time fold of const fn calls; fold==runtime)..."
& .\_s35_constfn_check.ps1
if ($LASTEXITCODE -ne 0) { Write-Host "`n=== CI FAILED at stage 2h (const-fn-eval) ==="; exit 1 }

Write-Host "`n[CI 2i/3] #34 AST-reprint formatter gate (canonical+faithful+idempotent+comments; safe fallback)..."
& .\_s34_fmt_check.ps1
if ($LASTEXITCODE -ne 0) { Write-Host "`n=== CI FAILED at stage 2i (AST-reprint formatter) ==="; exit 1 }

Write-Host "`n[CI 2j/3] #33 DWARF-variable gate (NOVA_DWARF_VARS emits DILocalVariable; flag-off byte-identical)..."
& .\_s33_dwarf_check.ps1
if ($LASTEXITCODE -ne 0) { Write-Host "`n=== CI FAILED at stage 2j (DWARF variable emission) ==="; exit 1 }

Write-Host "`n[CI 2b/3] N>1 multi-core gate (concurrency flagships at NOVA_CARRIERS=4/8)..."
& .\_n_carriers_ci.ps1
if ($LASTEXITCODE -ne 0) { Write-Host "`n=== CI FAILED at stage 2b (N>1 concurrency regression) ==="; exit 1 }

Write-Host "`n[CI 2k/3] Negative type-error gate (Tier 1.5 - wrong programs MUST be rejected)..."
& .\_neg_type_tests.ps1
# FIXED 2026-08-15: this check was DISPLACED below the 2l wasm probe, so `& .\_wasm_stackguard_probe.ps1`
# overwrote $LASTEXITCODE before it was read. The Tier-1.5 negative type-error gate therefore could
# NEVER fail the CI — a soundness gate whose exit code was silently discarded. Each stage's exit-code
# check must immediately follow its own invocation; nothing may run in between.
if ($LASTEXITCODE -ne 0) { Write-Host "`n=== CI FAILED at stage 2k (negative type-error soundness) ==="; exit 1 }

# Phase 1.1-1.3 cross-module soundness. The negative half (E1009 across the module boundary) lives
# in stage 2k above; this is the POSITIVE half and it asserts every output VALUE, not just the exit
# code -- the first cut of the default-param fix compiled and ran clean while printing ", World" and
# 1 instead of "Hello, World" and 111. Check sits immediately below its own invocation (stage-2k note).
Write-Host "`n[CI 2k2/3] Cross-module soundness gate (imported enum ctor + default params, value-asserted)..."
& .\_xm_soundness_gate.ps1
if ($LASTEXITCODE -ne 0) { Write-Host "`n=== CI FAILED at stage 2k2 (cross-module soundness) ==="; exit 1 }

# Phase 1.4 field-slot collision. Reconverge is structurally BLIND to this class of bug (the compiler
# destructures via `match Stmt(...)`, positionally, so it never consults ir_fmap), which is exactly
# why an explicit value-asserting probe is required. Check sits immediately below its own invocation.
Write-Host "`n[CI 2k3/3] Field-slot collision gate (ambiguous field name + untyped receiver, read+write)..."
& .\_xm_slot_gate.ps1
if ($LASTEXITCODE -ne 0) { Write-Host "`n=== CI FAILED at stage 2k3 (field-slot collision) ==="; exit 1 }

Write-Host "`n[CI 2l/3] WASM stack-guard gate (wasm has no signals/SEH; native must stay guard-free)..."
& .\_wasm_stackguard_probe.ps1
if ($LASTEXITCODE -ne 0) { Write-Host "`n=== CI FAILED at stage 2l (wasm stack guard) ==="; exit 1 }

# Prism (framework #5) KAT gate -- PRISM_ROADMAP.md milestone MA.8. The sub-script DISCOVERS every
# prism/kat/_kat_*.nova rather than taking a hard-coded list, so adding a KAT is sufficient to have
# it gated; a hard-coded list would fail silently-green the day someone forgets to extend it.
# Verified to actually fail (deliberate-sabotage self-test): a broken KAT gives exit 1 and is named.
# The $LASTEXITCODE check sits IMMEDIATELY below its own invocation -- see the stage-2k comment
# above for what happens when that check drifts away from the command it is supposed to be reading.
Write-Host "`n[CI 2m/3] Prism KAT gate (node tree, 22 widgets, style, HTML + ANSI backends, catalog)..."
& .\_prism_kat_gate.ps1
if ($LASTEXITCODE -ne 0) { Write-Host "`n=== CI FAILED at stage 2m (Prism KATs) ==="; exit 1 }

# WASM EXECUTION gate -- Prism roadmap M0.1. Stage 2l above is a stack-guard probe: it asserts a
# failure MODE, not arithmetic, so nothing here had ever RUN a wasm module and compared its answer
# to native. The first such comparison found the wasm target silently computing wrong answers
# (`i % 2` == 0, because nova_rt_mod was an unresolved import that a host stub filled with zero).
# The gate checks the module's IMPORT LIST as well as its value: a value comparison only catches
# functions a test happens to exercise, an import assertion catches every missing one.
# Both failure paths verified by deliberate sabotage. Check sits immediately below its invocation.
Write-Host "`n[CI 2n/3] WASM execution gate (native vs wasm32 agree; no unresolved runtime imports)..."
& .\_wasm_exec_gate.ps1
if ($LASTEXITCODE -ne 0) { Write-Host "`n=== CI FAILED at stage 2n (wasm execution) ==="; exit 1 }

Write-Host "`n[CI 3/3] Full regression (NORMAL)..."
Remove-Item Env:NOVA_T8_FULLRC -ErrorAction SilentlyContinue
& .\_run_final_regression.ps1
if ($LASTEXITCODE -ne 0) { Write-Host "`n=== CI FAILED at stage 3 (regression NORMAL) ==="; exit 1 }

if (-not $Quick) {
    Write-Host "`n[CI 3/3] Full regression (NOVA_T8_FULLRC)..."
    $env:NOVA_T8_FULLRC = "1"
    & .\_run_final_regression.ps1
    $rc = $LASTEXITCODE
    Remove-Item Env:NOVA_T8_FULLRC -ErrorAction SilentlyContinue
    if ($rc -ne 0) { Write-Host "`n=== CI FAILED at stage 3 (regression FULLRC) ==="; exit 1 }
} else {
    Write-Host "`n[CI 3/3] FULLRC mode SKIPPED (-Quick)"
}

Write-Host "`n=== NOVA CI: ALL GREEN (reconverged + perf-native + regression both modes) ==="
exit 0
