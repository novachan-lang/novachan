Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
$r = Invoke-Timed -FilePath (Resolve-Path '.\gen4_test.exe').Path -Arguments '_memo_probe3.nova' -TimeoutMs 30000 -WorkingDirectory $PSScriptRoot
Write-Host "COMPILE EXIT: $($r.ExitCode)"
if ($r.StdOut) { Write-Host $r.StdOut }
if ($r.ExitCode -ne 0) { exit 1 }
Write-Host "=== Dispatch check ==="
Select-String 'memo_cache|nova_rt_memo' _memo_probe3.ll | ForEach-Object { Write-Host $_.Line.Trim() }
Write-Host ""
$lr = Invoke-Timed -FilePath 'clang' -Arguments '_memo_probe3.ll output/nova_runtime.o -o _memo_probe3.exe -O2 -lws2_32 -ladvapi32 -D_CRT_SECURE_NO_WARNINGS -w' -TimeoutMs 60000 -WorkingDirectory $PSScriptRoot
Write-Host "LINK EXIT: $($lr.ExitCode)"
if ($lr.ExitCode -ne 0) { if ($lr.StdErr) { Write-Host $lr.StdErr }; exit 1 }
$rr = Invoke-Timed -FilePath (Resolve-Path '.\_memo_probe3.exe').Path -Arguments '' -TimeoutMs 5000 -WorkingDirectory $PSScriptRoot
Write-Host "RUN EXIT: $($rr.ExitCode)"
if ($rr.StdOut) { Write-Host $rr.StdOut }
if ($rr.StdErr) { Write-Host "STDERR: $($rr.StdErr)" }
