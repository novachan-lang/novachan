Set-Location $PSScriptRoot
Write-Host "===== REVERT VERIFY: reconverge from iter-87 source ====="
& powershell -NoProfile -ExecutionPolicy Bypass -File "$PSScriptRoot\_bootstrap_reconverge_slow.ps1"
if (!(Test-Path "$PSScriptRoot\gen3_test.exe")) { Write-Host "ABORT: no gen3_test.exe"; exit 1 }
Write-Host ""
Write-Host "===== flag-OFF regression (expect 432/0) ====="
& powershell -NoProfile -ExecutionPolicy Bypass -File "$PSScriptRoot\_run_final_regression.ps1" 2>&1 | Select-String -Pattern "RESULTS:|^FAIL "
Write-Host ""
Write-Host "===== flag-ON regression (NOVA_T8_FULLRC=1, expect 432/0 -- proves revert restored soundness) ====="
$env:NOVA_T8_FULLRC = "1"
& powershell -NoProfile -ExecutionPolicy Bypass -File "$PSScriptRoot\_run_final_regression.ps1" 2>&1 | Select-String -Pattern "RESULTS:|^FAIL "
Remove-Item Env:\NOVA_T8_FULLRC -ErrorAction SilentlyContinue
Write-Host "===== REVERT VERIFY DONE ====="
