# ─────────────────────────────────────────────────────────────────────────────
# PARALLEL SCALING MEASUREMENT (WEAPON_PARITY_PLAN 4.1)
#
# Runs ONE binary under NOVA_CARRIERS = 1,2,4,8 and reports wall time + speedup
# vs the 1-carrier baseline. Strong scaling: total work is constant, so speedup is
# the only thing that changes.
#
# This is MEASUREMENT, not a gate — it prints numbers and always exits 0 unless a
# run actually fails. Absolute times on this host are memory-pressure noisy (the
# CI's own perf TRACKING stage is non-fatal for the same reason), so turning a
# speedup ratio into a hard pass/fail would be flaky. Read the numbers, then
# decide. Use -AsGate to make it enforce -MinSpeedup once the numbers are stable.
#
# Each carrier count is run -Repeat times and the BEST (minimum) time is taken:
# the minimum is the least noise-contaminated estimate of the machine's capability,
# whereas a mean on a noisy shared host mostly measures the noise.
# ─────────────────────────────────────────────────────────────────────────────
param(
    [int]$Repeat = 3,
    [int]$TimeoutSec = 180,
    [switch]$AsGate,
    # The ASPIRATIONAL bar in .claude/rules/compiler-architecture.md is 1.8x at 4 workers, and
    # the measured value on this host (4 physical / 8 logical cores) is 1.95x — only ~8%
    # headroom, which would flake on a memory-pressured shared machine. So the GATE threshold
    # is deliberately lower: it exists to catch a real REGRESSION (the historical claim was
    # 0.76-0.82x, i.e. slower with more cores), not to police the last few percent. The actual
    # speedup is always printed, so erosion is visible long before the gate trips.
    [double]$MinSpeedup = 1.30
)
Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
Stop-StrayCompilers

$compiler = ".\gen3_test.exe"
if (-not (Test-Path $compiler)) { Write-Host "SKIP: gen3_test.exe not found"; exit 0 }

$src = "_par_scale_bench.nova"
$ll  = "_par_scale_bench.ll"
$exe = "_par_scale_bench.exe"
Remove-Item $ll,$exe -Force -ErrorAction SilentlyContinue

Write-Host "=== Parallel scaling measurement (strong scaling, constant total work) ==="

$c = Invoke-Timed -FilePath (Resolve-Path $compiler).Path -Arguments "$src $ll" -TimeoutMs 120000
if ($c.TimedOut -or $c.ExitCode -ne 0) {
    Write-Host "FAIL: compile ($($c.ExitCode))"; if ($c.StdOut) { Write-Host $c.StdOut }; exit 1
}
$l = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o $exe $ll ..\compiler\nova_runtime.c $NovaLinkFlags -D_CRT_SECURE_NO_WARNINGS -w" -TimeoutMs 240000
if (-not (Test-Path $exe)) { Write-Host "FAIL: link"; if ($l.StdErr) { Write-Host $l.StdErr }; exit 1 }

$carriers = @(1, 2, 4, 8)
$best = @{}
$checksum = $null

foreach ($n in $carriers) {
    $env:NOVA_CARRIERS = "$n"
    $bestMs = [double]::PositiveInfinity
    for ($r = 0; $r -lt $Repeat; $r++) {
        $sw = [System.Diagnostics.Stopwatch]::StartNew()
        $run = Invoke-Timed -FilePath (Resolve-Path ".\$exe").Path -Arguments "" -TimeoutMs ($TimeoutSec * 1000)
        $sw.Stop()
        if ($run.TimedOut -or $run.ExitCode -ne 0) {
            Write-Host "FAIL: run at NOVA_CARRIERS=$n (exit=$($run.ExitCode) timedout=$($run.TimedOut))"
            Remove-Item Env:NOVA_CARRIERS -ErrorAction SilentlyContinue
            exit 1
        }
        if ($run.StdOut -notmatch "PAR_SCALE_OK") {
            Write-Host "FAIL: incomplete run at NOVA_CARRIERS=$n"; Write-Host $run.StdOut
            Remove-Item Env:NOVA_CARRIERS -ErrorAction SilentlyContinue
            exit 1
        }
        # The checksum is carrier-count independent by construction; a change means
        # work was dropped or double-counted, which would invalidate the timings.
        $m = [regex]::Match($run.StdOut, "checksum=(-?\d+)")
        if ($m.Success) {
            if ($null -eq $checksum) { $checksum = $m.Groups[1].Value }
            elseif ($checksum -ne $m.Groups[1].Value) {
                Write-Host "FAIL: checksum changed at NOVA_CARRIERS=$n ($checksum -> $($m.Groups[1].Value)) -- work was lost or duplicated, timings are meaningless"
                Remove-Item Env:NOVA_CARRIERS -ErrorAction SilentlyContinue
                exit 1
            }
        }
        if ($sw.Elapsed.TotalMilliseconds -lt $bestMs) { $bestMs = $sw.Elapsed.TotalMilliseconds }
    }
    $best[$n] = $bestMs
    Write-Host ("  NOVA_CARRIERS={0,-2} best of {1}: {2,8:N1} ms" -f $n, $Repeat, $bestMs)
}
Remove-Item Env:NOVA_CARRIERS -ErrorAction SilentlyContinue

$baseline = $best[1]
Write-Host ""
Write-Host "  checksum (carrier-independent): $checksum"
Write-Host "  --- speedup vs NOVA_CARRIERS=1 ---"
foreach ($n in $carriers) {
    $sp = $baseline / $best[$n]
    $verdict = ""
    if ($n -gt 1) {
        if ($sp -lt 1.0) { $verdict = "  <-- SLOWER than single-carrier (REGRESSION)" }
        elseif ($n -eq 4 -and $sp -lt $MinSpeedup) { $verdict = "  <-- below the ${MinSpeedup}x gate for 4 workers" }
        elseif ($n -eq 4 -and $sp -lt 1.8) { $verdict = "  (above gate; below the 1.8x aspirational bar)" }
    }
    Write-Host ("  N={0,-2} {1,6:N2}x{2}" -f $n, $sp, $verdict)
}

Remove-Item $exe -Force -ErrorAction SilentlyContinue

if ($AsGate) {
    $sp4 = $baseline / $best[4]
    if ($sp4 -lt $MinSpeedup) {
        Write-Host "`n=== PARALLEL SCALING GATE FAILED: 4-carrier speedup ${sp4} < ${MinSpeedup}x ==="
        exit 1
    }
    Write-Host "`n=== PARALLEL SCALING GATE PASSED ==="
}
exit 0
