# FAST forge-lib dev gate: runs ONLY the non-server tests that import a forge module, in BOTH RC modes,
# with NO reconverge and NO serial server-integration tests. ~2 min. Use to gate forge/*.nova edits during
# a batch -- the compiler + runtime are unchanged, so the ~600 core tests can't be affected, and the slow
# serial TCP server tests (~40s each) run at the milestone.
#
# TIERS:
#   forge lib feature (edit forge/*.nova) .......... this script (_forge_ci.ps1) -- ~2 min
#   before committing a batch / touches serve path .. nova_ci.ps1 -SkipReconverge (full 607, incl server) -- ~15 min
#   compiler or runtime change (nova_compiler/runtime) nova_ci.ps1 (reconverge + full 607 x both modes) -- ~25 min
Set-Location $PSScriptRoot
$ErrorActionPreference = "Continue"
. "$PSScriptRoot\_proc_util.ps1"
Stop-StrayCompilers

Write-Host "`n[forge_ci 1/2] forge-lib unit gate (NORMAL)..."
Remove-Item Env:NOVA_T8_FULLRC -ErrorAction SilentlyContinue
& .\_run_final_regression.ps1 -ForgeOnly -NoServer
if ($LASTEXITCODE -ne 0) { Write-Host "`n=== FORGE_CI FAILED (NORMAL) ==="; exit 1 }

Write-Host "`n[forge_ci 2/2] forge-lib unit gate (NOVA_T8_FULLRC)..."
$env:NOVA_T8_FULLRC = "1"
& .\_run_final_regression.ps1 -ForgeOnly -NoServer
$rc = $LASTEXITCODE
Remove-Item Env:NOVA_T8_FULLRC -ErrorAction SilentlyContinue
if ($rc -ne 0) { Write-Host "`n=== FORGE_CI FAILED (FULLRC) ==="; exit 1 }

Write-Host "`n=== FORGE CI: ALL GREEN (forge unit subset, both RC modes, no reconverge/no-server) ==="
Write-Host "    (serial server-integration tests run at the milestone: nova_ci.ps1 -SkipReconverge)"
exit 0
