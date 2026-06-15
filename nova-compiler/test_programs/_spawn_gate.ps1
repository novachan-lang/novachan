# Spawn-per-connection gate: regression x2 + ASAN(struct set) + green_scale (via _s2_gate),
# then a dedicated single ASAN run of forge_spawn_test (concurrent green tasks + per-task
# arenas -- the keystone soundness check; single run avoids port-reuse flake from 5x).
Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
Write-Host "=== SPAWN-PER-CONN GATE ==="

Write-Host ""
Write-Host "--- regression x2 + ASAN(struct/channel set) + green_scale ---"
& powershell.exe -NoProfile -ExecutionPolicy Bypass -File "$PSScriptRoot\_s2_gate.ps1"
if ($LASTEXITCODE -ne 0) { Write-Host "*** SPAWN GATE FAIL: _s2_gate ***"; exit 1 }

Write-Host ""
Write-Host "--- ASAN forge_spawn_test (single run; concurrent per-task arena soundness) ---"
Remove-Item forge_spawn_test.ll, forge_spawn_test_asan.exe -Force -ErrorAction SilentlyContinue
$c = Invoke-Timed -FilePath ".\gen3_test.exe" -Arguments "forge_spawn_test.nova" -TimeoutMs 120000 -WorkingDirectory $PSScriptRoot
if ($c.ExitCode -ne 0) { Write-Host "ASAN compile FAIL"; if ($c.StdOut) { Write-Host $c.StdOut }; exit 1 }
$la = "-fsanitize=address -g -O1 -o forge_spawn_test_asan.exe forge_spawn_test.ll output\nova_runtime.c -lws2_32 -ladvapi32 -D_CRT_SECURE_NO_WARNINGS -w"
Invoke-Timed -FilePath $ClangPath -Arguments $la -TimeoutMs 240000 -WorkingDirectory $PSScriptRoot | Out-Null
if (!(Test-Path forge_spawn_test_asan.exe)) { Write-Host "ASAN link FAIL"; exit 1 }
$env:ASAN_OPTIONS = "abort_on_error=0"
$r = Invoke-Timed -FilePath ".\forge_spawn_test_asan.exe" -Arguments "" -TimeoutMs 30000 -WorkingDirectory $PSScriptRoot
Write-Host "ASAN OUT: $($r.StdOut)"
Write-Host "ASAN exit=$($r.ExitCode) timedout=$($r.TimedOut)"
if ($r.StdErr) { Write-Host "ASAN ERR:"; Write-Host $r.StdErr }
Remove-Item forge_spawn_test_asan.exe -Force -ErrorAction SilentlyContinue
if ($r.TimedOut -or $r.ExitCode -ne 0) { Write-Host "*** SPAWN GATE FAIL: ASAN forge_spawn_test ***"; exit 1 }

Write-Host ""
Write-Host "=== SPAWN GATE COMPLETE (all green; ASAN concurrent arena clean) ==="
