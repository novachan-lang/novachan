# NOVA one-command CI gate (#3). This repo's authoritative pre-commit gate.
# (The repo lives on Bitbucket and the bootstrap trust-root is a Windows binary, so there is no cloud
#  runner today; cloud + multi-platform CI is item #23 on the Linux track. Until then THIS is "CI": run it
#  before every commit that touches the compiler or runtime.)
#
# Stages (fails fast, non-zero exit on any failure):
#   1. Bootstrap reconverge  -> gen5.ll == gen6.ll (compiler self-consistency) + installs gen5
#   2. Perf-regression gate  -> scalar/float/struct stay C-level native (no re-boxing)
#   3. Full regression       -> NORMAL mode + NOVA_T8_FULLRC mode (all tests, both RC paths)
#
# Usage:  powershell -ExecutionPolicy Bypass -File ./nova_ci.ps1   [-SkipReconverge]  [-Quick]
param([switch]$SkipReconverge, [switch]$Quick)
Set-Location $PSScriptRoot
$ErrorActionPreference = "Continue"

if (-not $SkipReconverge) {
    Write-Host "`n[CI 1/3] Bootstrap reconverge (gen5.ll == gen6.ll)..."
    & .\_bootstrap_reconverge_slow.ps1
    if ($LASTEXITCODE -ne 0) { Write-Host "`n=== CI FAILED at stage 1 (reconverge/divergence) ==="; exit 1 }
} else {
    Write-Host "`n[CI 1/3] Reconverge SKIPPED (-SkipReconverge)"
}

Write-Host "`n[CI 2/3] Perf-regression gate..."
& .\_perf_gate.ps1
if ($LASTEXITCODE -ne 0) { Write-Host "`n=== CI FAILED at stage 2 (perf regression) ==="; exit 1 }

Write-Host "`n[CI 2b/3] N>1 multi-core gate (concurrency flagships at NOVA_CARRIERS=4/8)..."
& .\_n_carriers_ci.ps1
if ($LASTEXITCODE -ne 0) { Write-Host "`n=== CI FAILED at stage 2b (N>1 concurrency regression) ==="; exit 1 }

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
