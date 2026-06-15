# S1 (hash-keyed struct RTTI) gate: full 432 regression in BOTH flag modes.
# Uses the freshly-installed gen3_test.exe (gen5). Stops on first mode failure.
Set-Location $PSScriptRoot
Write-Host "=== S1 RTTI GATE: regression x2 ==="

Write-Host ""
Write-Host "--- MODE 1: NORMAL (NOVA_T8_FULLRC off) ---"
Remove-Item Env:\NOVA_T8_FULLRC -ErrorAction SilentlyContinue
& powershell.exe -NoProfile -ExecutionPolicy Bypass -File "$PSScriptRoot\_run_final_regression.ps1"
$norm = $LASTEXITCODE
Write-Host "NORMAL_EXIT=$norm"
if ($norm -ne 0) { Write-Host "*** S1 GATE FAIL: normal regression ***"; exit 1 }

Write-Host ""
Write-Host "--- MODE 2: NOVA_T8_FULLRC=1 ---"
$env:NOVA_T8_FULLRC = "1"
& powershell.exe -NoProfile -ExecutionPolicy Bypass -File "$PSScriptRoot\_run_final_regression.ps1"
$frc = $LASTEXITCODE
Remove-Item Env:\NOVA_T8_FULLRC -ErrorAction SilentlyContinue
Write-Host "FULLRC_EXIT=$frc"
if ($frc -ne 0) { Write-Host "*** S1 GATE FAIL: fullrc regression ***"; exit 1 }

Write-Host ""
Write-Host "=== S1 GATE: BOTH MODES PASS ==="
