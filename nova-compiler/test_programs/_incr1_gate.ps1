# Incr-1 Tier-3 gate: reconverge (compiler changed: typed-let honors declared struct type)
# then full regression x2 + ASAN + green_scale. Chains on success.
Set-Location $PSScriptRoot
Write-Host "=== INCR-1 GATE: reconverge -> regression x2 + ASAN + green_scale ==="

Write-Host ""
Write-Host "--- reconverge (gen5.ll == gen6.ll) ---"
& powershell.exe -NoProfile -ExecutionPolicy Bypass -File "$PSScriptRoot\_bootstrap_reconverge_slow.ps1"
if ($LASTEXITCODE -ne 0) { Write-Host "*** INCR-1 GATE FAIL: reconverge ***"; exit 1 }

# ASAN compiles via gen4_test.exe -> point it at the freshly-installed gen5
Copy-Item -Force gen3_test.exe gen4_test.exe

Write-Host ""
Write-Host "--- regression x2 + ASAN + green_scale ---"
& powershell.exe -NoProfile -ExecutionPolicy Bypass -File "$PSScriptRoot\_s2_gate.ps1"
if ($LASTEXITCODE -ne 0) { Write-Host "*** INCR-1 GATE FAIL: regression/asan/green_scale ***"; exit 1 }

Write-Host ""
Write-Host "=== INCR-1 GATE COMPLETE (reconverged + all green) ==="
