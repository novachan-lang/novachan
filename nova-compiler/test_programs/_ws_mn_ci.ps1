# N>1 WebSocket / SSE serving gate. The HTTP-serving sibling is _forge_mn_ci.ps1; the scheduler sibling is
# _n_carriers_ci.ps1. This validates the streaming/broadcast paths are multi-core-safe: the SSE hub (a daemon
# green task fanning out to subscribers), the WS handshake + frame codec, WS room BROADCAST (one client's
# message reaching every member via the single-writer Ws.outbound), plus WS routing, presence, lifecycle,
# keepalive, and a sustained-frame soak -- all under NOVA_CARRIERS=4 AND 8, with task-slot reclaim BOTH OFF
# and ON, with kill-on-timeout. These involve parked green tasks across carriers + the netpoller read+write
# waiters, the parts most prone to an N>1 lost-wakeup / writer race / cross-talk; the reclaim=1 pass also
# exercises slot reuse-vs-deref under the monitor lock for long-lived connections. Each test is SELF-CONTAINED
# (server + client(s) are in-process green tasks). Built via _fdb_one (forge+sqlite+winsock link). Script-only.
# Usage: powershell -ExecutionPolicy Bypass -File ./_ws_mn_ci.ps1 [-TimeoutSec 45]
param([int]$TimeoutSec = 45)
Set-Location $PSScriptRoot

$tests = @(
    @{ name = "forge_sse_test";           ok = "forge_sse_test passed" },           # SSE hub: publish -> subscriber + keepalive
    @{ name = "forge_ws_echo_test";       ok = "forge_ws_echo_test passed" },       # WS upgrade (101 + accept key) + masked echo + close
    @{ name = "forge_ws_chat_test";       ok = "forge_ws_chat_test passed" },       # WS room: one client's msg fans out to both members
    @{ name = "forge_ws_routing_test";    ok = "forge_ws_routing_test passed" },    # multiple ws_room patterns dispatched correctly
    @{ name = "forge_ws_presence_test";   ok = "forge_ws_presence_test passed" },   # join/leave presence tracked across the room
    @{ name = "forge_ws_lifecycle_test";  ok = "forge_ws_lifecycle_test passed" },  # open/close lifecycle callbacks fire in order
    @{ name = "forge_ws_keepalive_test";  ok = "forge_ws_keepalive_test passed" },  # ping/pong keepalive frames
    @{ name = "_ws_soak_test";            ok = "_ws_soak_test passed" },            # sustained frames over ONE conn -> flat per-message memory
    @{ name = "_ws_conn_soak_test";       ok = "_ws_conn_soak_test passed" }        # CONNECTION churn (400 connect/echo/close) -> all byte-correct, memory not worsening
)

$fail = 0
foreach ($t in $tests) {
    $nova = "$($t.name).nova"
    if (-not (Test-Path $nova)) { Write-Host "  SKIP $($t.name) (no source)"; continue }
    & powershell -NoProfile -ExecutionPolicy Bypass -File ".\_fdb_one.ps1" $($t.name) *> $null
    $exe = "$($t.name).exe"
    if (-not (Test-Path $exe)) { Write-Host "  FAIL $($t.name): did not build"; $fail++; continue }
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

if ($fail -gt 0) { Write-Host "=== WS/SSE N>1 GATE FAILED: $fail problem(s) ==="; exit 1 }
Write-Host "=== WS/SSE N>1 GATE PASSED: SSE hub + WS handshake/echo/broadcast/routing/presence/lifecycle/keepalive/soak clean at NOVA_CARRIERS=4 and 8 (reclaim 0/1) ==="
exit 0
