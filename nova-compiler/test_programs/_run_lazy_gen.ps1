Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
$env:NOVA_NO_CACHE = "1"
Remove-Item _lazy_gen_probe.ll -Force -ErrorAction SilentlyContinue
Remove-Item _lazy_gen_probe.exe -Force -ErrorAction SilentlyContinue

Write-Host "Compiling _lazy_gen_probe.nova with gen3_test.exe..."
$r = Invoke-Timed -FilePath (Resolve-Path '.\gen3_test.exe').Path -Arguments '_lazy_gen_probe.nova' -TimeoutMs 60000 -WorkingDirectory $PSScriptRoot
Write-Host "COMPILE EXIT: $($r.ExitCode)"
if ($r.StdOut) { Write-Host $r.StdOut }
if ($r.StdErr) { Write-Host $r.StdErr }
if ($r.ExitCode -ne 0) { exit 1 }

Write-Host "Linking..."
$lr = Invoke-Timed -FilePath 'clang' -Arguments '_lazy_gen_probe.ll output/nova_runtime.o -o _lazy_gen_probe.exe -O2 -lws2_32 -ladvapi32 -D_CRT_SECURE_NO_WARNINGS -w' -TimeoutMs 60000 -WorkingDirectory $PSScriptRoot
Write-Host "LINK EXIT: $($lr.ExitCode)"
if ($lr.StdErr) { Write-Host $lr.StdErr }
if ($lr.ExitCode -ne 0) { exit 1 }

Write-Host "Running..."
$rr = Invoke-Timed -FilePath (Resolve-Path '.\_lazy_gen_probe.exe').Path -Arguments '' -TimeoutMs 10000 -WorkingDirectory $PSScriptRoot
Write-Host "RUN EXIT: $($rr.ExitCode)"
if ($rr.StdOut) { Write-Host $rr.StdOut }
if ($rr.StdErr) { Write-Host "STDERR: $($rr.StdErr)" }
