$ErrorActionPreference = "Continue"
$env:NOVA_NO_CACHE = "1"
$sw = [System.Diagnostics.Stopwatch]::StartNew()
$dir = $PSScriptRoot
$rtSrc = "$dir\output\nova_runtime.c"
$linkFlags = @("-lws2_32","-ladvapi32","-D_CRT_SECURE_NO_WARNINGS","-w")

Write-Host "=== gen3 -> gen4 ==="
Remove-Item "$dir\nova_compiler.ll" -Force -ErrorAction SilentlyContinue
$p = Start-Process -FilePath "$dir\gen3_test.exe" -ArgumentList "nova_compiler.nova" `
    -NoNewWindow -PassThru -WorkingDirectory $dir `
    -RedirectStandardError "$dir\_g3_err.txt" -RedirectStandardOutput "$dir\_g3_out.txt"
$finished = $p.WaitForExit(450000)
if (-not $finished) { $p.Kill(); Write-Host "TIMEOUT after $($sw.ElapsedMilliseconds)ms"; exit 1 }
Get-Content "$dir\_g3_out.txt" -Raw
if (-not (Test-Path "$dir\nova_compiler.ll")) {
    Write-Host "ERROR: no .ll"
    Get-Content "$dir\_g3_err.txt" | Select-Object -First 10
    exit 1
}
Write-Host "gen3 done ($($sw.ElapsedMilliseconds)ms). Linking gen4_test..."
& clang "$dir\nova_compiler.ll" $rtSrc -o "$dir\gen4_test.exe" -O2 @linkFlags 2>"$dir\_g3_lerr.txt"
if ($LASTEXITCODE -ne 0) { Write-Host "LINK FAILED"; Get-Content "$dir\_g3_lerr.txt" | Select-Object -First 10; exit 1 }
Write-Host "gen4_test.exe built ($($sw.ElapsedMilliseconds)ms)"
