# N>1 Forge socket-serving regression gate (#12b). The M:N scheduler core is gated by _n_carriers_ci.ps1
# (green_scale + _mn_stress); THIS gate proves multi-core FORGE SERVING: a real Forge server (serve_req_n)
# plus concurrent socket clients, run under NOVA_CARRIERS=4 AND 8 with kill-on-timeout. The server's accept
# loop, per-connection handlers, and the clients are all green tasks distributed across carriers running in
# PARALLEL -- so this catches an N>1 socket race / lost-wakeup / response corruption that the N=1 suite can't.
# Forge tests are built via _fdb_one so the forge lib + sqlite3.o + winsock link correctly. Script-only.
# Usage: powershell -ExecutionPolicy Bypass -File ./_forge_mn_ci.ps1 [-TimeoutSec 40]
param([int]$TimeoutSec = 40)
Set-Location $PSScriptRoot

$tests = @(
    @{ name = "forge_recv_security_test"; ok = "forge_recv_security_test passed" },
    @{ name = "forge_mn_load_test";       ok = "FORGE N>1 LOAD OK" }   # 12 concurrent clients, no cross-talk (serving scales)
)

$fail = 0
foreach ($t in $tests) {
    $nova = "$($t.name).nova"
    if (-not (Test-Path $nova)) { Write-Host "  SKIP $($t.name) (no source)"; continue }
    # build (+ N=1 baseline run) via _fdb_one -> leaves $name.exe with the full forge link
    & powershell -NoProfile -ExecutionPolicy Bypass -File ".\_fdb_one.ps1" $($t.name) *> $null
    $exe = "$($t.name).exe"
    if (-not (Test-Path $exe)) { Write-Host "  FAIL $($t.name): did not build"; $fail++; continue }
    # cover both N>1 carrier counts AND both task-slot-reclaim states (reclaim=1 exercises the slot
    # reuse-vs-deref path under the monitor lock -- the part that must stay race-free at N>1).
    foreach ($ncar in 4, 8) {
        foreach ($rc in 0, 1) {
            $env:NOVA_CARRIERS = "$ncar"
            $env:NOVA_SCHED_RECLAIM_TASK = "$rc"
            & "$PSScriptRoot\_safe_scale_run.ps1" -Exe ".\$exe" -TimeoutSec $TimeoutSec *> $null
            $out = Get-Content "$exe.scaleout.txt" -Raw -ErrorAction SilentlyContinue
            if ($out -match [regex]::Escape($t.ok)) {
                Write-Host "  OK $($t.name) @ NOVA_CARRIERS=$ncar reclaim=$rc"
            } else {
                Write-Host "  FAIL $($t.name) @ N=$ncar reclaim=$rc (hang / abort / wrong output)"
                $fail++
            }
        }
    }
    Remove-Item Env:NOVA_CARRIERS -ErrorAction SilentlyContinue
    Remove-Item Env:NOVA_SCHED_RECLAIM_TASK -ErrorAction SilentlyContinue
}

if ($fail -gt 0) { Write-Host "=== FORGE N>1 GATE FAILED: $fail problem(s) ==="; exit 1 }
Write-Host "=== FORGE N>1 GATE PASSED: multi-core Forge socket-serving clean at NOVA_CARRIERS=4 and 8 ==="
exit 0
