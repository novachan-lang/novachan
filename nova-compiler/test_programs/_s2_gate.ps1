# S2 (RTTI json consumer) gate: full regression x2 + ASAN + green_scale.
# Runtime-only stage (compiler unchanged -> .ll fixpoint preserved by construction; no
# 3-pass reconverge needed). Tests link a freshly-compiled runtime, exercising the S2
# struct case. Stops on regression/green_scale failure; ASAN ok/crash reported for review.
Set-Location $PSScriptRoot
Write-Host "=== S2 RTTI GATE ==="

Write-Host ""
Write-Host "--- MODE 1: NORMAL ---"
Remove-Item Env:\NOVA_T8_FULLRC -ErrorAction SilentlyContinue
& powershell.exe -NoProfile -ExecutionPolicy Bypass -File "$PSScriptRoot\_run_final_regression.ps1"
if ($LASTEXITCODE -ne 0) { Write-Host "*** S2 GATE FAIL: normal regression ***"; exit 1 }

Write-Host ""
Write-Host "--- MODE 2: NOVA_T8_FULLRC=1 ---"
$env:NOVA_T8_FULLRC = "1"
& powershell.exe -NoProfile -ExecutionPolicy Bypass -File "$PSScriptRoot\_run_final_regression.ps1"
$frc = $LASTEXITCODE
Remove-Item Env:\NOVA_T8_FULLRC -ErrorAction SilentlyContinue
if ($frc -ne 0) { Write-Host "*** S2 GATE FAIL: fullrc regression ***"; exit 1 }

Write-Host ""
Write-Host "--- ASAN (rtti + struct/serialization/channel) ---"
foreach ($t in @('rtti_json_test','rtti_show_test','struct_test','auto_json_test','structser_test','t8_channel_test','crash_isolation_test')) {
    & powershell.exe -NoProfile -ExecutionPolicy Bypass -File "$PSScriptRoot\_asan_batch.ps1" -t $t
}

Write-Host ""
Write-Host "--- green_scale ---"
& powershell.exe -NoProfile -ExecutionPolicy Bypass -File "$PSScriptRoot\_green_scale_run.ps1"
if ($LASTEXITCODE -ne 0) { Write-Host "*** S2 GATE FAIL: green_scale ***"; exit 1 }

Write-Host ""
Write-Host "=== S2 GATE: regression x2 + green_scale PASS (verify ASAN crash=0 above) ==="
