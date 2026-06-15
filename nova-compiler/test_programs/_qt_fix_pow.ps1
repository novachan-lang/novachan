$ErrorActionPreference = "Continue"
$dir = $PSScriptRoot
$env:NOVA_NO_CACHE = "1"
$linkFlags = @("-lws2_32","-ladvapi32","-D_CRT_SECURE_NO_WARNINGS","-w")
$rtSrc = "$dir\output\nova_runtime.c"

Write-Host "=== gen3 -> gen4_test ==="
Remove-Item "$dir\nova_compiler.ll" -Force -ErrorAction SilentlyContinue
$p1 = Start-Process -FilePath "$dir\gen3_test.exe" -ArgumentList "nova_compiler.nova" `
    -NoNewWindow -PassThru -WorkingDirectory $dir `
    -RedirectStandardError "$dir\_qfp_e1.txt" -RedirectStandardOutput "$dir\_qfp_o1.txt"
$ok1 = $p1.WaitForExit(450000)
if (-not $ok1) { $p1.Kill(); Write-Host "TIMEOUT gen3"; exit 1 }
Get-Content "$dir\_qfp_o1.txt" -Raw
if (-not (Test-Path "$dir\nova_compiler.ll")) {
    Write-Host "ERROR: no .ll from gen3"
    exit 1
}
& clang "$dir\nova_compiler.ll" $rtSrc -o "$dir\gen4_test.exe" -O2 @linkFlags 2>"$dir\_qfp_le1.txt"
if ($LASTEXITCODE -ne 0) { Write-Host "LINK FAILED"; exit 1 }
Write-Host "gen4_test built"

Write-Host "=== Compiling compound test ==="
Remove-Item "$dir\_compound_assign_test.ll" -Force -ErrorAction SilentlyContinue
$p2 = Start-Process -FilePath "$dir\gen4_test.exe" -ArgumentList "_compound_assign_test.nova" `
    -NoNewWindow -PassThru -WorkingDirectory $dir `
    -RedirectStandardError "$dir\_qfp_e2.txt" -RedirectStandardOutput "$dir\_qfp_o2.txt"
$ok2 = $p2.WaitForExit(60000)
if (-not $ok2) { $p2.Kill(); Write-Host "TIMEOUT compile"; exit 1 }
Get-Content "$dir\_qfp_o2.txt" -Raw
if (-not (Test-Path "$dir\_compound_assign_test.ll")) {
    Write-Host "ERROR: no .ll"
    Get-Content "$dir\_qfp_e2.txt" | Select-Object -First 10
    exit 1
}
& clang "$dir\_compound_assign_test.ll" $rtSrc -o "$dir\_compound_assign_test.exe" -O2 @linkFlags 2>"$dir\_qfp_le2.txt"
if ($LASTEXITCODE -ne 0) { Write-Host "LINK FAILED"; Get-Content "$dir\_qfp_le2.txt" | Select-Object -First 10; exit 1 }

Write-Host "=== Running ==="
$r = Start-Process -FilePath "$dir\_compound_assign_test.exe" -NoNewWindow -PassThru -WorkingDirectory $dir `
    -RedirectStandardError "$dir\_qfp_re.txt" -RedirectStandardOutput "$dir\_qfp_ro.txt"
$ok3 = $r.WaitForExit(10000)
if (-not $ok3) { $r.Kill(); Write-Host "TIMEOUT run"; exit 1 }
Get-Content "$dir\_qfp_ro.txt" -Raw
Get-Content "$dir\_qfp_re.txt" -Raw

Write-Host "=== Also test multi-assign ==="
Remove-Item "$dir\_feature_survey.ll" -Force -ErrorAction SilentlyContinue
$p3 = Start-Process -FilePath "$dir\gen4_test.exe" -ArgumentList "_feature_survey.nova" `
    -NoNewWindow -PassThru -WorkingDirectory $dir `
    -RedirectStandardError "$dir\_qfp_e3.txt" -RedirectStandardOutput "$dir\_qfp_o3.txt"
$ok3b = $p3.WaitForExit(60000)
if (-not $ok3b) { $p3.Kill(); Write-Host "TIMEOUT compile ma"; exit 1 }
Get-Content "$dir\_qfp_o3.txt" -Raw
if (-not (Test-Path "$dir\_feature_survey.ll")) {
    Write-Host "ERROR: no .ll for survey"
    Get-Content "$dir\_qfp_e3.txt" | Select-Object -First 10
    exit 1
}
& clang "$dir\_feature_survey.ll" $rtSrc -o "$dir\_feature_survey.exe" -O2 @linkFlags 2>"$dir\_qfp_le3.txt"
$r2 = Start-Process -FilePath "$dir\_feature_survey.exe" -NoNewWindow -PassThru -WorkingDirectory $dir `
    -RedirectStandardError "$dir\_qfp_re2.txt" -RedirectStandardOutput "$dir\_qfp_ro2.txt"
$ok4 = $r2.WaitForExit(10000)
if (-not $ok4) { $r2.Kill(); Write-Host "TIMEOUT run ma"; exit 1 }
Get-Content "$dir\_qfp_ro2.txt" -Raw
Write-Host "=== DONE ==="
