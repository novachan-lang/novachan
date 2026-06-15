$ErrorActionPreference = "Continue"
$dir = $PSScriptRoot
$env:NOVA_NO_CACHE = "1"
$linkFlags = @("-lws2_32","-ladvapi32","-D_CRT_SECURE_NO_WARNINGS","-w")
$rtSrc = "$dir\output\nova_runtime.c"

Remove-Item "$dir\_feature_probe2.ll" -Force -ErrorAction SilentlyContinue
Remove-Item "$dir\_feature_probe2.exe" -Force -ErrorAction SilentlyContinue
Write-Host "=== Compiling ==="
$p = Start-Process -FilePath "$dir\gen4.exe" -ArgumentList "_feature_probe2.nova" `
    -NoNewWindow -PassThru -WorkingDirectory $dir `
    -RedirectStandardError "$dir\_qtp2_err.txt" -RedirectStandardOutput "$dir\_qtp2_out.txt"
$finished = $p.WaitForExit(60000)
if (-not $finished) { $p.Kill(); Write-Host "TIMEOUT"; exit 1 }
Get-Content "$dir\_qtp2_out.txt" -Raw
if (-not (Test-Path "$dir\_feature_probe2.ll")) {
    Write-Host "ERROR: no .ll"
    Get-Content "$dir\_qtp2_err.txt" | Select-Object -First 15
    exit 1
}
Write-Host "=== Linking ==="
& clang "$dir\_feature_probe2.ll" $rtSrc -o "$dir\_feature_probe2.exe" -O2 @linkFlags 2>"$dir\_qtp2_lerr.txt"
if ($LASTEXITCODE -ne 0) { Write-Host "LINK FAILED"; Get-Content "$dir\_qtp2_lerr.txt" | Select-Object -First 10; exit 1 }
Write-Host "=== Running ==="
$r = Start-Process -FilePath "$dir\_feature_probe2.exe" -NoNewWindow -PassThru -WorkingDirectory $dir `
    -RedirectStandardError "$dir\_qtp2_rerr.txt" -RedirectStandardOutput "$dir\_qtp2_rout.txt"
$fin2 = $r.WaitForExit(10000)
if (-not $fin2) { $r.Kill(); Write-Host "RUN TIMEOUT"; exit 1 }
Get-Content "$dir\_qtp2_rout.txt" -Raw
Write-Host "=== DONE ==="
