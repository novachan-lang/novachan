# N>1 WebSocket / SSE serving gate. The HTTP-serving sibling is _forge_mn_ci.ps1; the scheduler sibling is
# _n_carriers_ci.ps1. This validates the streaming/broadcast paths are multi-core-safe: the SSE hub (a daemon
# green task fanning out to subscribers), the WS handshake + frame codec, and WS room BROADCAST (one client's
# message reaching every member via the single-writer Ws.outbound) -- all under NOVA_CARRIERS=4 AND 8 with
# kill-on-timeout (these involve parked green tasks across carriers + the netpoller, the parts most prone to
# an N>1 lost-wakeup / cross-talk). Built via _fdb_one (forge+sqlite+winsock link). Script-only.
# Usage: powershell -ExecutionPolicy Bypass -File ./_ws_mn_ci.ps1 [-TimeoutSec 45]
param([int]$TimeoutSec = 45)
Set-Location $PSScriptRoot

$tests = @(
    @{ name = "forge_sse_test";      ok = "forge_sse_test passed" },          # SSE hub: publish -> subscriber + keepalive
    @{ name = "forge_ws_echo_test";  ok = "WS handshake" },                   # WS upgrade (101 + accept key) over a real socket
    @{ name = "forge_ws_chat_test";  ok = "broadcast to BOTH" }               # WS room: one client's msg fans out to both members
)

$fail = 0
foreach ($t in $tests) {
    $nova = "$($t.name).nova"
    if (-not (Test-Path $nova)) { Write-Host "  SKIP $($t.name) (no source)"; continue }
    & powershell -NoProfile -ExecutionPolicy Bypass -File ".\_fdb_one.ps1" $($t.name) *> $null
    $exe = "$($t.name).exe"
    if (-not (Test-Path $exe)) { Write-Host "  FAIL $($t.name): did not build"; $fail++; continue }
    foreach ($ncar in 4, 8) {
        $env:NOVA_CARRIERS = "$ncar"
        & "$PSScriptRoot\_safe_scale_run.ps1" -Exe ".\$exe" -TimeoutSec $TimeoutSec *> $null
        $out = Get-Content "$exe.scaleout.txt" -Raw -ErrorAction SilentlyContinue
        if ($out -match [regex]::Escape($t.ok)) {
            Write-Host "  OK $($t.name) @ NOVA_CARRIERS=$ncar"
        } else {
            Write-Host "  FAIL $($t.name) @ N=$ncar (hang / abort / wrong output)"
            $fail++
        }
    }
    Remove-Item Env:NOVA_CARRIERS -ErrorAction SilentlyContinue
}

if ($fail -gt 0) { Write-Host "=== WS/SSE N>1 GATE FAILED: $fail problem(s) ==="; exit 1 }
Write-Host "=== WS/SSE N>1 GATE PASSED: SSE hub + WS handshake + WS broadcast clean at NOVA_CARRIERS=4 and 8 ==="
exit 0
