$ErrorActionPreference = "Continue"
$dir = $PSScriptRoot
$env:NOVA_NO_CACHE = "1"
$linkFlags = @("-lws2_32","-ladvapi32","-D_CRT_SECURE_NO_WARNINGS","-w")
$rtSrc = "$dir\output\nova_runtime.c"

Write-Host "=== Compiling _opt_chain_test.nova ==="
$p = Start-Process -FilePath "$dir\gen4.exe" -ArgumentList "_opt_chain_test.nova" `
    -NoNewWindow -PassThru -WorkingDirectory $dir `
    -RedirectStandardError "$dir\_qt_opt_err.txt" -RedirectStandardOutput "$dir\_qt_opt_out.txt"
$finished = $p.WaitForExit(60000)
if (-not $finished) { $p.Kill(); Write-Host "TIMEOUT"; exit 1 }
Get-Content "$dir\_qt_opt_out.txt" -Raw
if (-not (Test-Path "$dir\nova_compiler.ll")) {
    Write-Host "ERROR: no .ll output"
    Get-Content "$dir\_qt_opt_err.txt" | Select-Object -First 10
    exit 1
}
Copy-Item "$dir\nova_compiler.ll" "$dir\_opt_chain_test.ll" -Force
Write-Host "=== Linking ==="
& clang "$dir\_opt_chain_test.ll" $rtSrc -o "$dir\_opt_chain_test.exe" -O2 @linkFlags 2>"$dir\_qt_opt_lerr.txt"
if ($LASTEXITCODE -ne 0) { Write-Host "LINK FAILED"; Get-Content "$dir\_qt_opt_lerr.txt" | Select-Object -First 10; exit 1 }
Write-Host "=== Running ==="
$r = Start-Process -FilePath "$dir\_opt_chain_test.exe" -NoNewWindow -PassThru -WorkingDirectory $dir `
    -RedirectStandardError "$dir\_qt_opt_rerr.txt" -RedirectStandardOutput "$dir\_qt_opt_rout.txt"
$finished2 = $r.WaitForExit(10000)
if (-not $finished2) { $r.Kill(); Write-Host "RUN TIMEOUT"; exit 1 }
Get-Content "$dir\_qt_opt_rout.txt" -Raw
if ($r.ExitCode -ne 0) {
    Write-Host "RUN FAILED exit=$($r.ExitCode)"
    Get-Content "$dir\_qt_opt_rerr.txt" | Select-Object -First 10
    exit 1
}
Write-Host "=== PASS ==="
