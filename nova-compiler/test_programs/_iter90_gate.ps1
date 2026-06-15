Set-Location $PSScriptRoot
Write-Host "===== iter-90 GATE: transparent arena foundation (runtime-only, inert for existing tests) ====="
Write-Host "===== STEP 1: reconverge (runtime-only -> expect 12152E9D) ====="
& powershell -NoProfile -ExecutionPolicy Bypass -File "$PSScriptRoot\_bootstrap_reconverge_slow.ps1"
if (!(Test-Path "$PSScriptRoot\gen3_test.exe")) { Write-Host "GATE ABORT"; exit 1 }
Write-Host ""
Write-Host "===== STEP 2: NORMAL regression (flag OFF) -- 432/0 (arena is inert) ====="
& powershell -NoProfile -ExecutionPolicy Bypass -File "$PSScriptRoot\_run_final_regression.ps1" 2>&1 | Select-String -Pattern "RESULTS:|^FAIL "
Write-Host ""
Write-Host "===== STEP 3: FLAG-ON regression (NOVA_T8_FULLRC=1) -- 432/0 ====="
$env:NOVA_T8_FULLRC = "1"
& powershell -NoProfile -ExecutionPolicy Bypass -File "$PSScriptRoot\_run_final_regression.ps1" 2>&1 | Select-String -Pattern "RESULTS:|^FAIL "
Remove-Item Env:\NOVA_T8_FULLRC -ErrorAction SilentlyContinue
Write-Host ""
Write-Host "===== STEP 4: arena harness (struct + cycle, non-ASAN + ASAN) ====="
& powershell -NoProfile -ExecutionPolicy Bypass -File "$PSScriptRoot\_arena_harness_run.ps1" 2>&1 | Select-String -Pattern "ARENA"
Write-Host ""
Write-Host "===== STEP 5: green_scale (M:N flagship) flag-off + on ====="
& powershell -NoProfile -ExecutionPolicy Bypass -File "$PSScriptRoot\_green_scale_run.ps1" 2>&1 | Select-String -Pattern "GREEN SCALE|exit="
$env:NOVA_T8_FULLRC = "1"
& powershell -NoProfile -ExecutionPolicy Bypass -File "$PSScriptRoot\_green_scale_run.ps1" 2>&1 | Select-String -Pattern "GREEN SCALE|exit="
Remove-Item Env:\NOVA_T8_FULLRC -ErrorAction SilentlyContinue
Write-Host "===== iter-90 GATE DONE ====="
