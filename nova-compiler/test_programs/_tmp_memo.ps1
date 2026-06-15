Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
$r = Invoke-Timed -FilePath (Resolve-Path '.\gen4_test.exe').Path -Arguments 'memo_test.nova' -TimeoutMs 120000 -WorkingDirectory $PSScriptRoot
Write-Host "COMPILE EXIT: $($r.ExitCode)"
if ($r.StdOut) { Write-Host "STDOUT: $($r.StdOut)" }
if ($r.StdErr) { Write-Host "STDERR: $($r.StdErr)" }
if ($r.ExitCode -ne 0) { exit 1 }
$lr = Invoke-Timed -FilePath 'clang' -Arguments 'memo_test.ll output/nova_runtime.o -o memo_test.exe -O2 -lws2_32 -ladvapi32 -D_CRT_SECURE_NO_WARNINGS -w' -TimeoutMs 60000 -WorkingDirectory $PSScriptRoot
Write-Host "LINK EXIT: $($lr.ExitCode)"
if ($lr.StdErr) { Write-Host "LINK STDERR: $($lr.StdErr)" }
if ($lr.ExitCode -ne 0) { exit 1 }
$rr = Invoke-Timed -FilePath (Resolve-Path '.\memo_test.exe').Path -Arguments '' -TimeoutMs 15000 -WorkingDirectory $PSScriptRoot
Write-Host "RUN EXIT: $($rr.ExitCode)"
if ($rr.StdOut) { Write-Host $rr.StdOut }
if ($rr.StdErr) { Write-Host "STDERR: $($rr.StdErr)" }
