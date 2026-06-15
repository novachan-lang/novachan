Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
$env:NOVA_NO_CACHE = "1"
Remove-Item _ergo_probe2.ll -Force -ErrorAction SilentlyContinue
Remove-Item _ergo_probe2.exe -Force -ErrorAction SilentlyContinue
$r = Invoke-Timed -FilePath (Resolve-Path '.\gen3_test.exe').Path -Arguments '_ergo_probe2.nova' -TimeoutMs 60000 -WorkingDirectory $PSScriptRoot
Write-Host "COMPILE: $($r.ExitCode)"
if ($r.StdErr) { Write-Host $r.StdErr }
if ($r.ExitCode -ne 0) { exit 1 }
$lr = Invoke-Timed -FilePath 'clang' -Arguments '_ergo_probe2.ll output/nova_runtime.o -o _ergo_probe2.exe -O2 -lws2_32 -ladvapi32 -D_CRT_SECURE_NO_WARNINGS -w' -TimeoutMs 60000 -WorkingDirectory $PSScriptRoot
if ($lr.ExitCode -ne 0) { Write-Host "LINK FAIL"; if ($lr.StdErr) { Write-Host $lr.StdErr }; exit 1 }
$rr = Invoke-Timed -FilePath (Resolve-Path '.\_ergo_probe2.exe').Path -Arguments '' -TimeoutMs 5000 -WorkingDirectory $PSScriptRoot
Write-Host "EXIT: $($rr.ExitCode)"
if ($rr.StdOut) { Write-Host $rr.StdOut }
if ($rr.StdErr) { Write-Host "STDERR: $($rr.StdErr)" }
