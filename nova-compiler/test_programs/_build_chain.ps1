Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
$env:NOVA_NO_CACHE = "1"

Write-Host "=== Step 1: gen3 -> gen4 (compile nova_compiler.nova) ==="
Remove-Item nova_compiler.ll -Force -ErrorAction SilentlyContinue
Remove-Item gen4_chain.exe -Force -ErrorAction SilentlyContinue
$r = Invoke-Timed -FilePath (Resolve-Path '.\gen3_test.exe').Path -Arguments 'nova_compiler.nova' -TimeoutMs 450000 -WorkingDirectory $PSScriptRoot
Write-Host "gen3 EXIT: $($r.ExitCode)"
if ($r.StdErr) { Write-Host "STDERR: $($r.StdErr)" }
if ($r.ExitCode -ne 0) { Write-Host "gen3 compile FAILED"; exit 1 }

Write-Host "=== Step 2: link gen4 ==="
$lr = Invoke-Timed -FilePath 'clang' -Arguments 'nova_compiler.ll output/nova_runtime.o -o gen4_chain.exe -O2 -lws2_32 -ladvapi32 -D_CRT_SECURE_NO_WARNINGS -w' -TimeoutMs 120000 -WorkingDirectory $PSScriptRoot
Write-Host "link EXIT: $($lr.ExitCode)"
if ($lr.StdErr) { Write-Host "STDERR: $($lr.StdErr)" }
if ($lr.ExitCode -ne 0) { Write-Host "link FAILED"; exit 1 }

Write-Host "=== Step 3: gen4 compiles chain probe ==="
Remove-Item _chain_probe.ll -Force -ErrorAction SilentlyContinue
Remove-Item _chain_probe.exe -Force -ErrorAction SilentlyContinue
$cr = Invoke-Timed -FilePath (Resolve-Path '.\gen4_chain.exe').Path -Arguments '_chain_probe.nova' -TimeoutMs 60000 -WorkingDirectory $PSScriptRoot
Write-Host "gen4 compile EXIT: $($cr.ExitCode)"
if ($cr.StdOut) { Write-Host $cr.StdOut }
if ($cr.StdErr) { Write-Host "STDERR: $($cr.StdErr)" }
if ($cr.ExitCode -ne 0) { Write-Host "chain probe compile FAILED"; exit 1 }

Write-Host "=== Step 4: link chain probe ==="
$plr = Invoke-Timed -FilePath 'clang' -Arguments '_chain_probe.ll output/nova_runtime.o -o _chain_probe.exe -O2 -lws2_32 -ladvapi32 -D_CRT_SECURE_NO_WARNINGS -w' -TimeoutMs 60000 -WorkingDirectory $PSScriptRoot
Write-Host "probe link EXIT: $($plr.ExitCode)"
if ($plr.StdErr) { Write-Host "STDERR: $($plr.StdErr)" }
if ($plr.ExitCode -ne 0) { Write-Host "probe link FAILED"; exit 1 }

Write-Host "=== Step 5: run chain probe ==="
$rr = Invoke-Timed -FilePath (Resolve-Path '.\_chain_probe.exe').Path -Arguments '' -TimeoutMs 5000 -WorkingDirectory $PSScriptRoot
Write-Host "RUN EXIT: $($rr.ExitCode)"
if ($rr.StdOut) { Write-Host $rr.StdOut }
if ($rr.StdErr) { Write-Host "STDERR: $($rr.StdErr)" }
