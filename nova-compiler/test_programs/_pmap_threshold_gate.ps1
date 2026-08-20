# pmap threshold gate: the SAME program must produce identical results with the
# default element threshold (serial path for a 100-element list) and with
# NOVA_PMAP_THRESHOLD=1 (threaded chunking path). Correctness only -- timings on this
# host are noisy, and a timing gate would flake; the measured speedup (2.6-2.7x for
# small expensive lists) is recorded in WEAPON_PARITY_PLAN.md instead.
Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
Stop-StrayCompilers
$compiler = ".\gen3_test.exe"
if (-not (Test-Path $compiler)) { Write-Host "SKIP: gen3_test.exe not found"; exit 0 }
$t = "_pmap_threshold_test"
Remove-Item "$t.ll","$t.gate.exe" -Force -ErrorAction SilentlyContinue
Write-Host "=== pmap threshold gate (serial path == threaded path) ==="
$c = Invoke-Timed -FilePath (Resolve-Path $compiler).Path -Arguments "$t.nova $t.ll" -TimeoutMs 120000
if ($c.TimedOut -or $c.ExitCode -ne 0) { Write-Host "  FAIL: compile"; Write-Host $c.StdOut; exit 1 }
$l = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o $t.gate.exe $t.ll ..\compiler\nova_runtime.c $NovaLinkFlags -D_CRT_SECURE_NO_WARNINGS -w" -TimeoutMs 240000
if (-not (Test-Path "$t.gate.exe")) { Write-Host "  FAIL: link"; Write-Host $l.StdErr; exit 1 }
$bad = 0
foreach ($cfg in @(@{n='default (serial path)'; v=$null}, @{n='NOVA_PMAP_THRESHOLD=1 (threaded)'; v='1'})) {
    if ($cfg.v) { $env:NOVA_PMAP_THRESHOLD = $cfg.v } else { Remove-Item Env:NOVA_PMAP_THRESHOLD -ErrorAction SilentlyContinue }
    $r = Invoke-Timed -FilePath (Resolve-Path ".\$t.gate.exe").Path -Arguments "" -TimeoutMs 60000
    if ($r.TimedOut -or $r.ExitCode -ne 0 -or ($r.StdOut -notmatch 'PMAP_THRESHOLD_OK')) {
        Write-Host "  FAIL $($cfg.n): exit=$($r.ExitCode) timedout=$($r.TimedOut)"
        if ($r.StdOut) { Write-Host "    $($r.StdOut.Trim())" }
        $bad = 1
    } else { Write-Host "  PASS $($cfg.n)" }
}
Remove-Item Env:NOVA_PMAP_THRESHOLD -ErrorAction SilentlyContinue
Remove-Item "$t.gate.exe" -Force -ErrorAction SilentlyContinue
if ($bad -ne 0) { Write-Host "`n=== PMAP THRESHOLD GATE FAILED ==="; exit 1 }
Write-Host "  PASS: pmap/pfilter agree with map/filter on both paths (order-exact)"
exit 0
