# 1.6 -- NULL IS ABSENCE.
#
# Asserts the whole value model in one run, under NOVA_FIRSTCLASS_NULL=1:
#   * a real integer 0 is NOT null, and a missing key IS       (the two "irreconcilable" halves)
#   * a STORED 0 is distinguishable from an absent key         (impossible under raw-0 absence)
#   * absence is FALSY                                          (the 11 tree/list TIMEOUTs)
#   * absence coerces to 0 under + - * and orders as 0          (the 4 NEW failures of 2026-08-22)
#   * null equals only null; str(null) == "null"
#
# THE TIMEOUT IS THE FAILURE MODE, not a hang to be waited out. If truthiness regresses,
# chain_len() never returns -- so the run is given a hard 60 s budget through Invoke-Timed and a
# timeout is reported as a FAIL with that diagnosis attached, rather than as an infrastructure
# hiccup. A gate that hung here would train everyone to re-run it.
#
# The flag is set BY THIS GATE rather than assumed, and the default-off behaviour is checked
# separately below: with absence as raw 0 the KAT must FAIL (a missing key is then == 0, not
# == null). That negative half is what proves the gate has teeth -- without it, a build that
# quietly ignored the flag would pass.
param([string]$Compiler = ".\gen3_test.exe")

Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
$env:NOVA_NO_CACHE = "1"
if (-not $env:NOVA_HOME) { $env:NOVA_HOME = (Resolve-Path "$PSScriptRoot\..").Path }

$exe = Resolve-Path $Compiler -ErrorAction SilentlyContinue
if (-not $exe) { Write-Host "NULL-ABSENCE-GATE FAIL: compiler not found: $Compiler"; exit 1 }

$fail = 0
Write-Host "1.6 null is absence:"

# ---- structural: the read sites must route to the _abs readers under the flag ------------
$env:NOVA_FIRSTCLASS_NULL = "1"
Remove-Item -Force _kat_null_absence.ll -ErrorAction SilentlyContinue
$c = Invoke-Timed -FilePath $exe.Path -Arguments "_kat_null_absence.nova _kat_null_absence.ll" -TimeoutMs 240000
if ($c.ExitCode -ne 0 -or -not (Test-Path _kat_null_absence.ll)) {
    Write-Host "  FAIL emit (exit=$($c.ExitCode))"; Write-Host $c.StdOut; Write-Host $c.StdErr; exit 1
}
$ll = Get-Content _kat_null_absence.ll -Raw
if ($ll -match "call i64 @nova_rt_(dict|index)_get_abs\(") {
    Write-Host "  ok   dict/index reads route to the absent-as-null readers"
} else {
    Write-Host "  FAIL the flag did not change the emitted reader -- absence is still raw 0"; $fail++
}
# ...and the null LITERAL must be the singleton, not const 0. Both halves are needed: the
# literal alone gives z == null correctly while leaving absence unrepresentable, and the
# readers alone give absence an identity that null itself does not share.
if ($ll -match "call i64 @nova_rt_null\(") {
    Write-Host "  ok   the null literal lowers to the singleton"
} else {
    Write-Host "  FAIL the null literal is still const 0"; $fail++
}

# ---- behavioural: every assertion, with the hang treated as a failure -------------------
Remove-Item -Force _kat_null_absence.exe -ErrorAction SilentlyContinue
$b = Invoke-Timed -FilePath $exe.Path -Arguments "build _kat_null_absence.nova" -TimeoutMs 240000
if ($b.ExitCode -ne 0) { Write-Host "  FAIL build kat"; Write-Host $b.StdErr; exit 1 }
$r = Invoke-Timed -FilePath (Resolve-Path ".\_kat_null_absence.exe").Path -Arguments "" -TimeoutMs 60000
$out = $r.StdOut + $r.StdErr
if ($r.TimedOut) {
    Write-Host "  FAIL TIMEOUT -- absence is truthy again, so a while-loop over it never terminates."
    Write-Host "       This is the exact regression that hid for four days as 11 unexplained"
    Write-Host "       tree/list timeouts. See nova_rt_truthy's NOVA_BOX_NULL arm."
    $fail++
} elseif ($out -like "*NULL_ABSENCE PASS*") {
    Write-Host "  ok   11/11 -- zero-vs-absence, falsy, arithmetic-zero, ordering, equality, str"
} else {
    $line = ($out.Trim() -split "`r?`n" | Where-Object { $_ -like "FAIL*" -or $_ -like "NULL_ABSENCE*" }) -join " | "
    Write-Host "  FAIL kat (exit=$($r.ExitCode)): $line"; $fail++
}

# ---- TEETH: with the flag OFF the same KAT must NOT pass --------------------------------
# Absence is raw 0 by default, so h["never_set"] == null is false and section 2 fails. If
# this half ever reports PASS, the flag is being ignored and the positive half above proves
# nothing.
Remove-Item Env:NOVA_FIRSTCLASS_NULL -ErrorAction SilentlyContinue
Remove-Item -Force _kat_null_absence.exe -ErrorAction SilentlyContinue
$b2 = Invoke-Timed -FilePath $exe.Path -Arguments "build _kat_null_absence.nova" -TimeoutMs 240000
if ($b2.ExitCode -ne 0) {
    Write-Host "  FAIL build kat with the flag off"; Write-Host $b2.StdErr; $fail++
} else {
    $r2 = Invoke-Timed -FilePath (Resolve-Path ".\_kat_null_absence.exe").Path -Arguments "" -TimeoutMs 60000
    $out2 = $r2.StdOut + $r2.StdErr
    if ($r2.TimedOut) {
        Write-Host "  FAIL flag-off run TIMED OUT -- raw-0 absence must still terminate"; $fail++
    } elseif ($out2 -like "*NULL_ABSENCE PASS*") {
        Write-Host "  FAIL the KAT passes with the flag OFF -- the flag is being ignored"; $fail++
    } else {
        Write-Host "  ok   flag off: absence stays raw 0 (the KAT correctly does not pass)"
    }
}

if ($fail -eq 0) { Write-Host "NULL-ABSENCE-GATE PASS (5/5)"; exit 0 }
Write-Host "NULL-ABSENCE-GATE FAIL ($fail)"; exit 1
