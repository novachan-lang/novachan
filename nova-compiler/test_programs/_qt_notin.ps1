$ErrorActionPreference = "Continue"
$dir = $PSScriptRoot
$env:NOVA_NO_CACHE = "1"
$linkFlags = @("-lws2_32","-ladvapi32","-D_CRT_SECURE_NO_WARNINGS","-w")
$rtSrc = "$dir\output\nova_runtime.c"

Write-Host "=== Compiling _not_in_test.nova ==="
Remove-Item "$dir\_not_in_test.ll" -Force -ErrorAction SilentlyContinue
$p = Start-Process -FilePath "$dir\gen4.exe" -ArgumentList "_not_in_test.nova" `
    -NoNewWindow -PassThru -WorkingDirectory $dir `
    -RedirectStandardError "$dir\_qtn_err.txt" -RedirectStandardOutput "$dir\_qtn_out.txt"
$finished = $p.WaitForExit(60000)
if (-not $finished) { $p.Kill(); Write-Host "TIMEOUT"; exit 1 }
Get-Content "$dir\_qtn_out.txt" -Raw
if (-not (Test-Path "$dir\_not_in_test.ll")) {
    Write-Host "ERROR: no .ll"
    Get-Content "$dir\_qtn_err.txt" | Select-Object -First 10
    exit 1
}
Write-Host "=== Linking ==="
& clang "$dir\_not_in_test.ll" $rtSrc -o "$dir\_not_in_test.exe" -O2 @linkFlags 2>"$dir\_qtn_lerr.txt"
if ($LASTEXITCODE -ne 0) { Write-Host "LINK FAILED"; Get-Content "$dir\_qtn_lerr.txt" | Select-Object -First 10; exit 1 }
Write-Host "=== Running ==="
$r = Start-Process -FilePath "$dir\_not_in_test.exe" -NoNewWindow -PassThru -WorkingDirectory $dir `
    -RedirectStandardError "$dir\_qtn_rerr.txt" -RedirectStandardOutput "$dir\_qtn_rout.txt"
$fin2 = $r.WaitForExit(10000)
if (-not $fin2) { $r.Kill(); Write-Host "RUN TIMEOUT"; exit 1 }
Get-Content "$dir\_qtn_rout.txt" -Raw
Write-Host "=== DONE ==="
