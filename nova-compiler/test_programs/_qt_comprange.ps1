$ErrorActionPreference = "Continue"
$dir = $PSScriptRoot
$env:NOVA_NO_CACHE = "1"
$linkFlags = @("-lws2_32","-ladvapi32","-D_CRT_SECURE_NO_WARNINGS","-w")
$rtSrc = "$dir\output\nova_runtime.c"

Write-Host "=== Compile _comp_range_test.nova with gen4 ==="
Remove-Item "$dir\_comp_range_test.ll" -Force -ErrorAction SilentlyContinue
$p = Start-Process -FilePath "$dir\gen4_test.exe" -ArgumentList "_comp_range_test.nova" `
    -NoNewWindow -PassThru -WorkingDirectory $dir `
    -RedirectStandardError "$dir\_cr_err.txt" -RedirectStandardOutput "$dir\_cr_out.txt"
$ok = $p.WaitForExit(60000)
if (-not $ok) { $p.Kill(); Write-Host "TIMEOUT"; exit 1 }
if (Test-Path "$dir\_cr_err.txt") { Get-Content "$dir\_cr_err.txt" }
if (-not (Test-Path "$dir\_comp_range_test.ll")) { Write-Host "COMPILE FAILED"; exit 1 }
Write-Host "Compile OK"

Write-Host "=== Link ==="
& clang "$dir\_comp_range_test.ll" $rtSrc -o "$dir\_comp_range_test.exe" -O2 @linkFlags 2>"$dir\_cr_lerr.txt"
if ($LASTEXITCODE -ne 0) { Write-Host "LINK FAILED"; Get-Content "$dir\_cr_lerr.txt"; exit 1 }
Write-Host "Link OK"

Write-Host "=== Run ==="
$r = Start-Process -FilePath "$dir\_comp_range_test.exe" -NoNewWindow -PassThru -WorkingDirectory $dir `
    -RedirectStandardError "$dir\_cr_rerr.txt" -RedirectStandardOutput "$dir\_cr_rout.txt"
$rok = $r.WaitForExit(15000)
if (-not $rok) { $r.Kill(); Write-Host "TIMEOUT-RUN"; exit 1 }
Write-Host "OUTPUT:"
if (Test-Path "$dir\_cr_rout.txt") { Get-Content "$dir\_cr_rout.txt" }
Write-Host "STDERR:"
if (Test-Path "$dir\_cr_rerr.txt") { Get-Content "$dir\_cr_rerr.txt" }
