$ErrorActionPreference = "Continue"
$dir = $PSScriptRoot
$env:NOVA_NO_CACHE = "1"
$linkFlags = @("-lws2_32","-ladvapi32","-D_CRT_SECURE_NO_WARNINGS","-w")
$rtSrc = "$dir\output\nova_runtime.c"

Remove-Item "$dir\_compound_assign_test.ll" -Force -ErrorAction SilentlyContinue
Remove-Item "$dir\_compound_assign_test.exe" -Force -ErrorAction SilentlyContinue
Write-Host "=== Compiling _compound_assign_test.nova ==="
$p = Start-Process -FilePath "$dir\gen4.exe" -ArgumentList "_compound_assign_test.nova" `
    -NoNewWindow -PassThru -WorkingDirectory $dir `
    -RedirectStandardError "$dir\_qtc_err.txt" -RedirectStandardOutput "$dir\_qtc_out.txt"
$finished = $p.WaitForExit(60000)
if (-not $finished) { $p.Kill(); Write-Host "TIMEOUT"; exit 1 }
Get-Content "$dir\_qtc_out.txt" -Raw
if (-not (Test-Path "$dir\_compound_assign_test.ll")) {
    Write-Host "ERROR: no .ll"
    Get-Content "$dir\_qtc_err.txt" | Select-Object -First 10
    exit 1
}
Write-Host "=== Linking ==="
& clang "$dir\_compound_assign_test.ll" $rtSrc -o "$dir\_compound_assign_test.exe" -O2 @linkFlags 2>"$dir\_qtc_lerr.txt"
if ($LASTEXITCODE -ne 0) { Write-Host "LINK FAILED"; Get-Content "$dir\_qtc_lerr.txt" | Select-Object -First 10; exit 1 }
Write-Host "=== Running ==="
$r = Start-Process -FilePath "$dir\_compound_assign_test.exe" -NoNewWindow -PassThru -WorkingDirectory $dir `
    -RedirectStandardError "$dir\_qtc_rerr.txt" -RedirectStandardOutput "$dir\_qtc_rout.txt"
$fin2 = $r.WaitForExit(10000)
if (-not $fin2) { $r.Kill(); Write-Host "RUN TIMEOUT"; exit 1 }
Get-Content "$dir\_qtc_rout.txt" -Raw
Write-Host "=== DONE ==="
