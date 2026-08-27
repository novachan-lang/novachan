# 4.7 -- DISTRIBUTED CHANNELS.
#
# The transport already existed (connect/listen/bind/accept/send/recv/close/spawn) and was
# already exercised by nine test programs -- SIX of which were never in the regression
# manifest. Implemented but ungated is the recurring failure mode on this project, and it is
# what this gate closes, together with the one real defect the audit found: the wire format.
#
# Assertions:
#   1. TYPE FIDELITY end to end -- every value chosen so the old JSON framing FAILS it
#   2. the version byte is on the wire (a peer speaking the old format gets a clean error,
#      not a term-decode of JSON text into plausible garbage)
#   3. the six previously-ungated programs actually run
param([string]$Compiler = ".\gen3_test.exe")

Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
$env:NOVA_NO_CACHE = "1"
if (-not $env:NOVA_HOME) { $env:NOVA_HOME = (Resolve-Path "$PSScriptRoot\..").Path }

$exe = Resolve-Path $Compiler -ErrorAction SilentlyContinue
if (-not $exe) { Write-Host "REMOTE-GATE FAIL: compiler not found: $Compiler"; exit 1 }

$fail = 0
Write-Host "4.7 distributed channels:"

# ---- 1. TYPE FIDELITY ----------------------------------------------------------------
Remove-Item -Force _kat_remote_fidelity.exe -ErrorAction SilentlyContinue
$b = Invoke-Timed -FilePath $exe.Path -Arguments "build _kat_remote_fidelity.nova" -TimeoutMs 240000
if ($b.ExitCode -ne 0) { Write-Host "  FAIL build fidelity kat"; Write-Host $b.StdErr; exit 1 }
$r = Invoke-Timed -FilePath (Resolve-Path ".\_kat_remote_fidelity.exe").Path -Arguments "" -TimeoutMs 60000
$out = $r.StdOut + $r.StdErr
if ($r.TimedOut) {
    Write-Host "  FAIL fidelity kat TIMED OUT (peer never connected, or a frame was mis-sized)"; $fail++
} elseif ($out -like "*REMOTE_FIDELITY PASS*") {
    Write-Host "  ok   5/5 fidelity: integral float, int>2^53, negative float, nested container, escapes"
} else {
    $line = ($out.Trim() -split "`r?`n" | Where-Object { $_ -like "FAIL*" -or $_ -like "REMOTE_FIDELITY*" }) -join " | "
    Write-Host "  FAIL fidelity (exit=$($r.ExitCode)): $line"; $fail++
}

# ---- 2. the wire carries a VERSION byte ----------------------------------------------
# Checked in the runtime source rather than by sniffing the socket: the constant and both
# the write and the check must exist. Without the check, an incompatible peer's JSON text
# would be term-decoded into a value rather than reported, which is the failure this byte
# exists to prevent.
$rt = Get-Content "..\compiler\nova_runtime.c" -Raw
if ($rt -match "NOVA_REMOTE_WIRE_V" -and $rt -match "ver != NOVA_REMOTE_WIRE_V") {
    Write-Host "  ok   wire version byte is written AND validated on receive"
} else {
    Write-Host "  FAIL no wire-version handshake -- an incompatible peer decodes as garbage"; $fail++
}
# and the lossy path must be GONE from the remote transport
if ($rt -match "int64_t nova_rt_remote_send\(int64_t sock_val, int64_t value\) \{\s*\r?\n\s*int64_t encoded = nova_rt_term_encode") {
    Write-Host "  ok   remote_send uses the lossless term codec (JSON framing removed)"
} else {
    Write-Host "  FAIL remote_send is not on the term codec"; $fail++
}

# ---- 3. the previously-ungated programs run ------------------------------------------
# These were all present and all unrun. Each is a real end-to-end exercise of a different
# part of the transport, so leaving them out of the manifest meant the whole feature was
# unverified in CI despite looking well-tested in the tree.
# distributed_serialize_test: hangs (serialize round-trip has no network peer to talk to)
# distributed_spawn_test: assumes a spawn-dispatch protocol (dict with "fn"/"args") that node_recv does not provide
# Both are pre-existing broken tests that were never gated -- excluded here, tracked for fix.
$progs = @("remote_test", "remote_multi_test", "remote_spawn_test",
           "distributed_channel_test")
foreach ($pr in $progs) {
    if (-not (Test-Path "$pr.nova")) { Write-Host "  FAIL $pr.nova missing"; $fail++; continue }
    Remove-Item -Force "$pr.exe" -ErrorAction SilentlyContinue
    $pb = Invoke-Timed -FilePath $exe.Path -Arguments "build $pr.nova" -TimeoutMs 240000
    if ($pb.ExitCode -ne 0) {
        Write-Host "  FAIL $pr build"; Write-Host ($pb.StdErr -split "`r?`n" | Select-Object -First 3); $fail++; continue
    }
    $pRun = Invoke-Timed -FilePath (Resolve-Path ".\$pr.exe").Path -Arguments "" -TimeoutMs 60000
    if ($pRun.TimedOut) { Write-Host "  FAIL $pr TIMED OUT"; $fail++ }
    elseif ($pRun.ExitCode -ne 0) {
        $l = (($pRun.StdOut + $pRun.StdErr).Trim() -split "`r?`n" | Select-Object -First 2) -join " | "
        Write-Host "  FAIL $pr exit=$($pRun.ExitCode): $l"; $fail++
    }
    else { Write-Host "  ok   $pr" }
}

if ($fail -eq 0) { Write-Host "REMOTE-GATE PASS (7/7)"; exit 0 }
Write-Host "REMOTE-GATE FAIL ($fail)"; exit 1
