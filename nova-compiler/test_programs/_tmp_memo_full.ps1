Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
$env:NOVA_NO_CACHE = "1"
Remove-Item memo_test.ll -Force -ErrorAction SilentlyContinue
Remove-Item memo_test.exe -Force -ErrorAction SilentlyContinue
Write-Host "Compiling memo_test.nova with gen4_test.exe..."
$r = Invoke-Timed -FilePath (Resolve-Path '.\gen4_test.exe').Path -Arguments 'memo_test.nova' -TimeoutMs 60000 -WorkingDirectory $PSScriptRoot
Write-Host "COMPILE EXIT: $($r.ExitCode)"
if ($r.StdOut) { Write-Host $r.StdOut }
if ($r.StdErr) { Write-Host $r.StdErr }
if ($r.ExitCode -ne 0) { exit 1 }
Write-Host ""
Write-Host "=== Key IR patterns ==="
Select-String 'memo_cache|nova_rt_memo|fib__memo' memo_test.ll | ForEach-Object { Write-Host $_.Line.Trim() }
Write-Host ""
Write-Host "Linking..."
$lr = Invoke-Timed -FilePath 'clang' -Arguments 'memo_test.ll output/nova_runtime.o -o memo_test.exe -O2 -lws2_32 -ladvapi32 -D_CRT_SECURE_NO_WARNINGS -w' -TimeoutMs 60000 -WorkingDirectory $PSScriptRoot
Write-Host "LINK EXIT: $($lr.ExitCode)"
if ($lr.StdErr) { Write-Host $lr.StdErr }
if ($lr.ExitCode -ne 0) { exit 1 }
Write-Host "Running..."
$rr = Invoke-Timed -FilePath (Resolve-Path '.\memo_test.exe').Path -Arguments '' -TimeoutMs 10000 -WorkingDirectory $PSScriptRoot
Write-Host "RUN EXIT: $($rr.ExitCode)"
if ($rr.StdOut) { Write-Host $rr.StdOut }
if ($rr.StdErr) { Write-Host "STDERR: $($rr.StdErr)" }
