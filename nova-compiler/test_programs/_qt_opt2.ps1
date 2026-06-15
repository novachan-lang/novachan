$ErrorActionPreference = "Continue"
$dir = $PSScriptRoot
$env:NOVA_NO_CACHE = "1"
$linkFlags = @("-lws2_32","-ladvapi32","-D_CRT_SECURE_NO_WARNINGS","-w")
$rtSrc = "$dir\output\nova_runtime.c"

Write-Host "=== Compiling _opt_chain_test.nova with gen4_test ==="
Remove-Item "$dir\nova_compiler.ll" -Force -ErrorAction SilentlyContinue
$p = Start-Process -FilePath "$dir\gen4_test.exe" -ArgumentList "_opt_chain_test.nova" `
    -NoNewWindow -PassThru -WorkingDirectory $dir `
    -RedirectStandardError "$dir\_qt2_err.txt" -RedirectStandardOutput "$dir\_qt2_out.txt"
$finished = $p.WaitForExit(60000)
if (-not $finished) { $p.Kill(); Write-Host "TIMEOUT"; exit 1 }
Get-Content "$dir\_qt2_out.txt" -Raw
Remove-Item "$dir\_opt_chain_test.ll" -Force -ErrorAction SilentlyContinue
if (-not (Test-Path "$dir\_opt_chain_test.ll")) {
    Write-Host "ERROR: no .ll output"
    Get-Content "$dir\_qt2_err.txt" | Select-Object -First 20
    exit 1
}
Write-Host "=== Linking ==="
& clang "$dir\_opt_chain_test.ll" $rtSrc -o "$dir\_opt_chain_test.exe" -O2 @linkFlags 2>"$dir\_qt2_lerr.txt"
if ($LASTEXITCODE -ne 0) { Write-Host "LINK FAILED"; Get-Content "$dir\_qt2_lerr.txt" | Select-Object -First 10; exit 1 }
Write-Host "=== Running ==="
$r = Start-Process -FilePath "$dir\_opt_chain_test.exe" -NoNewWindow -PassThru -WorkingDirectory $dir `
    -RedirectStandardError "$dir\_qt2_rerr.txt" -RedirectStandardOutput "$dir\_qt2_rout.txt"
$finished2 = $r.WaitForExit(10000)
if (-not $finished2) { $r.Kill(); Write-Host "RUN TIMEOUT"; exit 1 }
Get-Content "$dir\_qt2_rout.txt" -Raw
$ec = $r.ExitCode
if ($ec -ne 0) {
    Write-Host "RUN FAILED exit=$ec"
    Get-Content "$dir\_qt2_rerr.txt" | Select-Object -First 10
    exit 1
}
Write-Host "=== PASS ==="
