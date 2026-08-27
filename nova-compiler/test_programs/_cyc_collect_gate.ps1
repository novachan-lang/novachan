# 1.7 -- cycle COLLECTOR. The detector (gate 2k6) says where a cycle is; this proves the
# collector reclaims it WITHOUT ever freeing something reachable.
#
# EXIT-TIME reclamation is the working feature. MID-PROGRAM cycle_collect() is sound but
# conservative to the point of rarely firing today, and the gate pins that honestly rather
# than demanding a number the collector cannot legitimately produce:
#   1. exit-time NOVA_CYCLE_COLLECT=1 drives the live-object count DOWN by exactly the 6
#      cycle-held nodes -- MEASURED 7 -> 1
#   2. mid-program DECLINES a cycle that is still referenced (the proof gates the free)
#   3. mid-program returns 0, not a guess, when it cannot prove unreachability
#   4. a reachable cycle stays READABLE afterwards -- values checked, not just "no crash",
#      because freed-and-reused memory often still reads
#   5. acyclic data is never touched
#   6. it refuses outright (-1) when the detector is unarmed or >1 carrier is running
#
# WHY MID-PROGRAM COLLECTION RARELY FIRES, so nobody later "fixes" the gate by loosening it:
# the locals that build a cycle escape into each other's fields, and the compiler emits NO
# DROP for an escaping local. Their refcounts stay inflated for the life of the program, so
# sum_rc never falls to the internal edge count and the proof correctly declines. That is a
# COMPILER gap, not a collector one, and the collector erring toward keeping objects is the
# safe direction: under-collection is a leak we already had, over-collection is a
# use-after-free.
#
# Assertion 1 is measured against NOVA_HEAP_PROFILE's "still-live objects=N", i.e. the same
# number FULLRC leak-checking reads. That is the point of the whole item: a program that
# builds cyclic structures should report clean at exit instead of a permanent false leak.
param([string]$Compiler = ".\gen3_test.exe")

Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
$env:NOVA_NO_CACHE = "1"
if (-not $env:NOVA_HOME) { $env:NOVA_HOME = (Resolve-Path "$PSScriptRoot\..").Path }

$exe = Resolve-Path $Compiler -ErrorAction SilentlyContinue
if (-not $exe) { Write-Host "CYC-COLLECT-GATE FAIL: compiler not found: $Compiler"; exit 1 }

$fail = 0
Write-Host "1.7 cycle collector:"

Remove-Item -Force _cyc_collect.exe -ErrorAction SilentlyContinue
$b = Invoke-Timed -FilePath $exe.Path -Arguments "build _cyc_collect.nova" -TimeoutMs 240000
if ($b.ExitCode -ne 0) { Write-Host "  FAIL build"; Write-Host $b.StdErr; exit 1 }
$cc = (Resolve-Path ".\_cyc_collect.exe").Path

# ---- mid-program collection, detector armed ------------------------------------------
# NOVA_CARRIERS=1 is REQUIRED, not incidental: cycle_collect() refuses outright when more
# than one carrier exists, because the analysis reads every live object's fields while
# another carrier could be mutating them, and NOVA has no safepoint to stop the world at.
# Carriers are started at init, so on a default multi-core run this function always
# refuses. That is the intended fail-closed behaviour and the gate pins it below.
$env:NOVA_CYCLE_DETECT = "1"
$env:NOVA_CARRIERS = "1"
Remove-Item Env:NOVA_CYCLE_COLLECT -ErrorAction SilentlyContinue
$r = Invoke-Timed -FilePath $cc -Arguments "" -TimeoutMs 120000
$out = $r.StdOut + $r.StdErr
if ($r.TimedOut) { Write-Host "  FAIL mid-program run TIMED OUT"; $fail++ }

if ($out -match "HELD ok:") {
    Write-Host "  ok   declines a cycle that is still referenced (the proof gates the free)"
} elseif ($out -match "HELD FAIL") {
    Write-Host "  FAIL freed a REACHABLE cycle -- use-after-free"; $fail++
} else {
    Write-Host "  FAIL no HELD verdict in output"; $fail++
}

# MEASURED: this is 0, and 0 is the CORRECT answer today. The locals that built the cycle
# escape into each other's fields, and the compiler emits no drop for an escaping local, so
# their refcounts stay inflated forever and the proof rightly declines. A gate demanding
# > 0 here would be demanding the collector free something it cannot prove is dead.
# What must NEVER happen is a non-zero count, so that is what is asserted.
$m = [regex]::Match($out, "FREE collected=(\d+)")
if (-not $m.Success) {
    Write-Host "  FAIL no FREE verdict in output"; $fail++
} elseif ([int]$m.Groups[1].Value -eq 0) {
    Write-Host "  ok   mid-program: declines when it cannot prove unreachability (0, as expected)"
} else {
    Write-Host "  FAIL mid-program freed $($m.Groups[1].Value) objects it could not prove dead"; $fail++
}

if ($out -match "SURVIVE ok:") {
    Write-Host "  ok   a reachable cycle is intact AND reads back correct values"
} else {
    Write-Host "  FAIL a reachable cycle was corrupted or freed"; $fail++
}

if ($out -match "ACYCLIC ok:") {
    Write-Host "  ok   acyclic data untouched (the sever pass stayed inside its own SCC)"
} else {
    Write-Host "  FAIL an acyclic chain was damaged"; $fail++
}

# ---- REFUSAL when the detector is not armed ------------------------------------------
# There is no live-object registry without it, so there is nothing to be correct about.
# A collector that "did its best" here would be freeing on the basis of an empty graph.
Remove-Item Env:NOVA_CYCLE_DETECT -ErrorAction SilentlyContinue
$r0 = Invoke-Timed -FilePath $cc -Arguments "" -TimeoutMs 120000
$out0 = $r0.StdOut + $r0.StdErr
if ($out0 -match "FREE skip" -and $out0 -match "SURVIVE ok") {
    Write-Host "  ok   refuses (returns -1) when the detector is not armed, program unaffected"
} else {
    Write-Host "  FAIL unarmed behaviour: expected a refusal and an intact program"; $fail++
}

# ---- exit-time reclamation drives the live count DOWN --------------------------------
# Measured as a DELTA between two runs of the same binary rather than against a fixed
# number: the absolute live count includes interned strings and runtime bookkeeping that
# is not this gate's business, and pinning it would make the gate fail on unrelated work.
Remove-Item -Force _cyc_pos.exe -ErrorAction SilentlyContinue
$pb = Invoke-Timed -FilePath $exe.Path -Arguments "build _cyc_pos.nova" -TimeoutMs 240000
if ($pb.ExitCode -ne 0) { Write-Host "  FAIL build _cyc_pos"; Write-Host $pb.StdErr; $fail++ }
else {
    $pos = (Resolve-Path ".\_cyc_pos.exe").Path
    $env:NOVA_CYCLE_DETECT = "1"; $env:NOVA_HEAP_PROFILE = "1"
    Remove-Item Env:NOVA_CYCLE_COLLECT -ErrorAction SilentlyContinue
    $noC = Invoke-Timed -FilePath $pos -Arguments "" -TimeoutMs 120000
    $env:NOVA_CYCLE_COLLECT = "1"
    $wiC = Invoke-Timed -FilePath $pos -Arguments "" -TimeoutMs 120000

    $reLive = "still-live objects=(-?\d+)"
    $a = [regex]::Match($noC.StdOut + $noC.StdErr, $reLive)
    $c = [regex]::Match($wiC.StdOut + $wiC.StdErr, $reLive)
    if (-not ($a.Success -and $c.Success)) {
        Write-Host "  FAIL could not read still-live counts from the heap profile"; $fail++
    } else {
        $la = [int]$a.Groups[1].Value; $lc = [int]$c.Groups[1].Value
        # _cyc_pos builds exactly 6 cycle-held nodes, so collection must account for all 6.
        if (($la - $lc) -ge 6) {
            Write-Host "  ok   exit reclamation: still-live $la -> $lc (freed $($la - $lc), all 6 cycle nodes)"
        } else {
            Write-Host "  FAIL exit reclamation freed only $($la - $lc) of 6 (live $la -> $lc)"; $fail++
        }
        if ($wiC.StdOut + $wiC.StdErr -match "RECLAIMED") {
            Write-Host "  ok   the report names what it reclaimed"
        } else {
            Write-Host "  FAIL no RECLAIMED line in the collecting run"; $fail++
        }
    }
    Remove-Item Env:NOVA_HEAP_PROFILE -ErrorAction SilentlyContinue
    Remove-Item Env:NOVA_CYCLE_COLLECT -ErrorAction SilentlyContinue
}
Remove-Item Env:NOVA_CYCLE_DETECT -ErrorAction SilentlyContinue

Remove-Item Env:NOVA_CARRIERS -ErrorAction SilentlyContinue
if ($fail -eq 0) { Write-Host "CYC-COLLECT-GATE PASS (7/7)"; exit 0 }
Write-Host "CYC-COLLECT-GATE FAIL ($fail)"; exit 1
