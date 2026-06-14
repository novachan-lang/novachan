# DIAGNOSTIC ONLY: run the full regression with NOVA_T8_DROP=1 so every test's OUTPUT
# carries W5b return-drops -- tests whether W5b-dropped USER programs are sound across the
# whole suite. Uses the normal installed gen3 (NOT installed gen4_w5b). No flip committed.
Set-Location $PSScriptRoot
$env:NOVA_T8_DROP = "1"
& powershell -NoProfile -ExecutionPolicy Bypass -File "$PSScriptRoot\_run_final_regression.ps1"
Remove-Item Env:\NOVA_T8_DROP -ErrorAction SilentlyContinue
