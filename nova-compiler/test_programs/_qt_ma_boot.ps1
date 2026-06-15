$ErrorActionPreference = "Continue"
$dir = $PSScriptRoot
$env:NOVA_NO_CACHE = "1"
$linkFlags = @("-lws2_32","-ladvapi32","-D_CRT_SECURE_NO_WARNINGS","-w")
$rtSrc = "$dir\output\nova_runtime.c"

Write-Host "=== Step 1: gen3 -> gen4_test ==="
Remove-Item "$dir\nova_compiler.ll" -Force -ErrorAction SilentlyContinue
$p1 = Start-Process -FilePath "$dir\gen3_test.exe" -ArgumentList "nova_compiler.nova" `
    -NoNewWindow -PassThru -WorkingDirectory $dir `
    -RedirectStandardError "$dir\_mab_e1.txt" -RedirectStandardOutput "$dir\_mab_o1.txt"
$ok1 = $p1.WaitForExit(450000)
if (-not $ok1) { $p1.Kill(); Write-Host "TIMEOUT gen3"; exit 1 }
Get-Content "$dir\_mab_o1.txt" -Raw
if (-not (Test-Path "$dir\nova_compiler.ll")) {
    Write-Host "ERROR: no .ll from gen3"
    Get-Content "$dir\_mab_e1.txt" | Select-Object -First 10
    exit 1
}
Write-Host "=== Linking gen4_test ==="
& clang "$dir\nova_compiler.ll" $rtSrc -o "$dir\gen4_test.exe" -O2 @linkFlags 2>"$dir\_mab_le1.txt"
if ($LASTEXITCODE -ne 0) { Write-Host "LINK FAILED"; Get-Content "$dir\_mab_le1.txt" | Select-Object -First 10; exit 1 }
Write-Host "gen4_test.exe built"

Write-Host "=== Step 2: compile test with gen4_test ==="
Remove-Item "$dir\_feature_survey.ll" -Force -ErrorAction SilentlyContinue
Remove-Item "$dir\_feature_survey.exe" -Force -ErrorAction SilentlyContinue
$p2 = Start-Process -FilePath "$dir\gen4_test.exe" -ArgumentList "_feature_survey.nova" `
    -NoNewWindow -PassThru -WorkingDirectory $dir `
    -RedirectStandardError "$dir\_mab_e2.txt" -RedirectStandardOutput "$dir\_mab_o2.txt"
$ok2 = $p2.WaitForExit(60000)
if (-not $ok2) { $p2.Kill(); Write-Host "TIMEOUT compile test"; exit 1 }
Get-Content "$dir\_mab_o2.txt" -Raw
if (-not (Test-Path "$dir\_feature_survey.ll")) {
    Write-Host "ERROR: no .ll from test compile"
    Get-Content "$dir\_mab_e2.txt" | Select-Object -First 15
    exit 1
}
Write-Host "=== Linking test ==="
& clang "$dir\_feature_survey.ll" $rtSrc -o "$dir\_feature_survey.exe" -O2 @linkFlags 2>"$dir\_mab_le2.txt"
if ($LASTEXITCODE -ne 0) { Write-Host "LINK FAILED"; Get-Content "$dir\_mab_le2.txt" | Select-Object -First 10; exit 1 }
Write-Host "=== Running test ==="
$r = Start-Process -FilePath "$dir\_feature_survey.exe" -NoNewWindow -PassThru -WorkingDirectory $dir `
    -RedirectStandardError "$dir\_mab_re.txt" -RedirectStandardOutput "$dir\_mab_ro.txt"
$ok3 = $r.WaitForExit(10000)
if (-not $ok3) { $r.Kill(); Write-Host "RUN TIMEOUT"; exit 1 }
Get-Content "$dir\_mab_ro.txt" -Raw
Write-Host "=== DONE ==="
