Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
$env:NOVA_NO_CACHE = "1"

Write-Host "=== STEP 1: Rebuild compiler (gen4) from nova_compiler.nova ==="
Remove-Item nova_compiler.ll -Force -ErrorAction SilentlyContinue
Remove-Item gen4.exe -Force -ErrorAction SilentlyContinue
$r = Invoke-Timed -FilePath (Resolve-Path '.\gen3_test.exe').Path -Arguments 'nova_compiler.nova' -TimeoutMs 450000 -WorkingDirectory $PSScriptRoot
Write-Host "GEN3->GEN4 COMPILE: $($r.ExitCode)"
if ($r.StdOut) { Write-Host $r.StdOut }
if ($r.StdErr) { Write-Host $r.StdErr }
if ($r.ExitCode -ne 0) { Write-Host "FAIL: gen3 could not compile nova_compiler.nova"; exit 1 }
$lr = Invoke-Timed -FilePath 'clang' -Arguments 'nova_compiler.ll output/nova_runtime.o -o gen4.exe -O2 -lws2_32 -ladvapi32 -D_CRT_SECURE_NO_WARNINGS -w' -TimeoutMs 120000 -WorkingDirectory $PSScriptRoot
if ($lr.ExitCode -ne 0) { Write-Host "LINK FAIL"; if ($lr.StdErr) { Write-Host $lr.StdErr }; exit 1 }
Write-Host "gen4.exe built OK"

Write-Host ""
Write-Host "=== STEP 2: Use gen4 to compile trail_fn_probe ==="
Remove-Item _trail_fn_probe.ll -Force -ErrorAction SilentlyContinue
Remove-Item _trail_fn_probe.exe -Force -ErrorAction SilentlyContinue
$r2 = Invoke-Timed -FilePath (Resolve-Path '.\gen4.exe').Path -Arguments '_trail_fn_probe.nova' -TimeoutMs 60000 -WorkingDirectory $PSScriptRoot
Write-Host "GEN4 COMPILE: $($r2.ExitCode)"
if ($r2.StdOut) { Write-Host $r2.StdOut }
if ($r2.StdErr) { Write-Host $r2.StdErr }
if ($r2.ExitCode -ne 0) { Write-Host "FAIL: gen4 could not compile _trail_fn_probe.nova"; exit 1 }
$lr2 = Invoke-Timed -FilePath 'clang' -Arguments '_trail_fn_probe.ll output/nova_runtime.o -o _trail_fn_probe.exe -O2 -lws2_32 -ladvapi32 -D_CRT_SECURE_NO_WARNINGS -w' -TimeoutMs 60000 -WorkingDirectory $PSScriptRoot
if ($lr2.ExitCode -ne 0) { Write-Host "LINK FAIL"; if ($lr2.StdErr) { Write-Host $lr2.StdErr }; exit 1 }

Write-Host ""
Write-Host "=== STEP 3: Run the probe ==="
$rr = Invoke-Timed -FilePath (Resolve-Path '.\_trail_fn_probe.exe').Path -Arguments '' -TimeoutMs 5000 -WorkingDirectory $PSScriptRoot
Write-Host "EXIT: $($rr.ExitCode)"
if ($rr.StdOut) { Write-Host $rr.StdOut }
if ($rr.StdErr) { Write-Host "STDERR: $($rr.StdErr)" }
