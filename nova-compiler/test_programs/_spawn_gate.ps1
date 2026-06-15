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

$env:ASAN_OPTIONS = "abort_on_error=0"
foreach ($t in @("forge_spawn_test", "forge_recover_test")) {
    Write-Host ""
    Write-Host "--- ASAN $t (single run; concurrent arena + crash-path soundness) ---"
    Remove-Item "$t.ll", "${t}_asan.exe" -Force -ErrorAction SilentlyContinue
    $c = Invoke-Timed -FilePath ".\gen3_test.exe" -Arguments "$t.nova" -TimeoutMs 120000 -WorkingDirectory $PSScriptRoot
    if ($c.ExitCode -ne 0) { Write-Host "$t ASAN compile FAIL"; if ($c.StdOut) { Write-Host $c.StdOut }; exit 1 }
    $la = "-fsanitize=address -g -O1 -o ${t}_asan.exe $t.ll output\nova_runtime.c -lws2_32 -ladvapi32 -D_CRT_SECURE_NO_WARNINGS -w"
    Invoke-Timed -FilePath $ClangPath -Arguments $la -TimeoutMs 240000 -WorkingDirectory $PSScriptRoot | Out-Null
    if (!(Test-Path "${t}_asan.exe")) { Write-Host "$t ASAN link FAIL"; exit 1 }
    $r = Invoke-Timed -FilePath ".\${t}_asan.exe" -Arguments "" -TimeoutMs 30000 -WorkingDirectory $PSScriptRoot
    Write-Host "$t ASAN OUT: $($r.StdOut)"
    Write-Host "$t ASAN exit=$($r.ExitCode) timedout=$($r.TimedOut)"
    # Real ASAN error => "AddressSanitizer" on stderr (a contained NOVA panic prints "nova: panic" and exits 0 -- benign).
    $asanErr = ($r.StdErr -and ($r.StdErr -match "AddressSanitizer"))
    if ($asanErr) { Write-Host "$t ASAN ERR:"; Write-Host $r.StdErr }
    Remove-Item "${t}_asan.exe" -Force -ErrorAction SilentlyContinue
    if ($r.TimedOut -or $r.ExitCode -ne 0 -or $asanErr) { Write-Host "*** GATE FAIL: ASAN $t ***"; exit 1 }
}

Write-Host ""
Write-Host "=== SPAWN GATE COMPLETE (all green; ASAN concurrent arena clean) ==="
