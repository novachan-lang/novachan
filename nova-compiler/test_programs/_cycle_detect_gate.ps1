# 1.7 — cycle detector gate.
#
# Asserts BOTH halves, because only one of them is interesting on its own:
#   POSITIVE  _cyc_pos : 6 objects in 3 cycles (2-node, self-loop, 3-node ring)
#   NEGATIVE  _cyc_neg : 0 cycles across lists/dicts/strings/an acyclic chain
# A detector that flags healthy programs is worse than no detector, so the negative
# assertion is the load-bearing one.
#
# Also asserts the detector is SILENT when the env flag is unset -- it is opt-in, and a
# diagnostic that prints unasked would corrupt every other test's expected output.
param([string]$Compiler = ".\gen3_test.exe")

Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
$env:NOVA_NO_CACHE = "1"

$exe = Resolve-Path $Compiler -ErrorAction SilentlyContinue
if (-not $exe) { Write-Host "CYCLE-GATE FAIL: compiler not found: $Compiler"; exit 1 }

function Build-And-Run($name, $detect) {
    Remove-Item -Force "$name.ll", "$name.exe" -ErrorAction SilentlyContinue
    $c = Invoke-Timed -FilePath $exe.Path -Arguments "build $name.nova" -TimeoutMs 240000
    if ($c.ExitCode -ne 0) {
        Write-Host "CYCLE-GATE FAIL: compile $name (exit=$($c.ExitCode))"
        Write-Host $c.StdOut; Write-Host $c.StdErr
        return $null
    }
    if ($detect) { $env:NOVA_CYCLE_DETECT = "1" }
    $r = Invoke-Timed -FilePath (Resolve-Path ".\$name.exe").Path -Arguments "" -TimeoutMs 120000
    if ($detect) { Remove-Item Env:NOVA_CYCLE_DETECT -ErrorAction SilentlyContinue }
    if ($r.TimedOut) { Write-Host "CYCLE-GATE FAIL: $name timed out"; return $null }
    if ($r.ExitCode -ne 0) { Write-Host "CYCLE-GATE FAIL: $name exit=$($r.ExitCode)"; return $null }
    return ($r.StdOut + "`n" + $r.StdErr)
}

$fail = 0
function Assert-Has($hay, $needle, $label) {
    if ($hay -like "*$needle*") { Write-Host "  ok   $label" }
    else { Write-Host "  FAIL $label -- expected to find: $needle"; $script:fail++ }
}
function Assert-Not($hay, $needle, $label) {
    if ($hay -notlike "*$needle*") { Write-Host "  ok   $label" }
    else { Write-Host "  FAIL $label -- did NOT expect: $needle"; $script:fail++ }
}

Write-Host "1.7 cycle detector:"

# POSITIVE — three cycle shapes must all be found.
$pos = Build-And-Run "_cyc_pos" $true
if ($null -eq $pos) { exit 1 }
Assert-Has $pos "objects in cycles    : 6"      "positive: 6 objects in cycles"
Assert-Has $pos "in 3 distinct cycles"          "positive: 3 distinct cycles (pair+self+ring)"
Assert-Has $pos "CycNode"                       "positive: attributed to the CycNode type"

# NEGATIVE — a healthy program must be reported clean.
$neg = Build-And-Run "_cyc_neg" $true
if ($null -eq $neg) { exit 1 }
Assert-Has $neg "objects in cycles    : 0"      "negative: no false positives"

# OPT-IN — silent unless asked.
$off = Build-And-Run "_cyc_pos" $false
if ($null -eq $off) { exit 1 }
Assert-Not $off "NOVA cycle detector"           "opt-in: silent with the flag unset"

if ($fail -gt 0) { Write-Host "CYCLE-GATE FAIL ($fail)"; exit 1 }
Write-Host "CYCLE-GATE OK (5/5 assertions)"
exit 0
