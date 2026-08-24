# 3.1 remaining half -- the callee-entry unbox on declared-`float` params must be GONE, except where
# it is load-bearing.
#
# !! NOT WIRED INTO nova_ci YET. This gate FAILS before the fix lands (axpy emits three unbox calls),
# which is the point: it is the falsifiable spec for the change, and a gate that has never been
# observed to fail is not evidence. Wire it into nova_ci at stage 2k9 in the same commit that makes
# it pass.
#
# The two structural assertions pull in OPPOSITE directions, and that is deliberate:
#   @axpy   -- every call site visible  -> ZERO unbox. This is the 1.69x-vs-C win.
#   @scale2 -- ADDRESS-TAKEN            -> unbox RETAINED. Its callers are not all visible, so
#              assuming raw would read a heap pointer as a double.
# A gate asserting only the first would pass a change that silently corrupts every callback.
param([string]$Compiler = ".\gen3_test.exe")

Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
$env:NOVA_NO_CACHE = "1"

$exe = Resolve-Path $Compiler -ErrorAction SilentlyContinue
if (-not $exe) { Write-Host "UNBOX-ELIM-GATE FAIL: compiler not found: $Compiler"; exit 1 }

$fail = 0
Write-Host "3.1 declared-float callee unbox elimination:"

Remove-Item -Force _f31_unbox_elim_probe.ll, _f31_unbox_elim_probe.exe -ErrorAction SilentlyContinue
$c = Invoke-Timed -FilePath $exe.Path -Arguments "_f31_unbox_elim_probe.nova _f31_unbox_elim_probe.ll" -TimeoutMs 240000
if ($c.ExitCode -ne 0 -or -not (Test-Path _f31_unbox_elim_probe.ll)) {
    Write-Host "UNBOX-ELIM-GATE FAIL: emit (exit=$($c.ExitCode))"; Write-Host $c.StdErr; exit 1
}
$ll = Get-Content _f31_unbox_elim_probe.ll

function Get-FnBody($lines, $name) {
    $body = @(); $inFn = $false
    foreach ($line in $lines) {
        if ($line -match "^define .*@$name\(") { $inFn = $true; continue }
        if ($inFn) { if ($line -match "^\}") { break }; $body += $line }
    }
    return $body
}

# --- axpy: all call sites visible -> no entry unbox ---------------------------------------
$axpy = Get-FnBody $ll "axpy"
$au = @($axpy | Where-Object { $_ -match "call i64 @nova_rt_unbox" })
if ($axpy.Count -eq 0) {
    Write-Host "  FAIL @axpy not found in IR"; $fail++
} elseif ($au.Count -eq 0) {
    Write-Host "  ok   @axpy has NO entry unbox (3 declared-float params, all call sites visible)"
} else {
    Write-Host "  FAIL @axpy still unboxes $($au.Count)x on entry (want 0)"; $fail++
}

# --- scale2: address-taken -> unbox MUST remain -------------------------------------------
$sc = Get-FnBody $ll "scale2"
$su = @($sc | Where-Object { $_ -match "call i64 @nova_rt_unbox" })
if ($sc.Count -eq 0) {
    Write-Host "  FAIL @scale2 not found in IR"; $fail++
} elseif ($su.Count -ge 1) {
    Write-Host "  ok   @scale2 KEEPS its unbox (address-taken: callers not all visible)"
} else {
    Write-Host "  FAIL @scale2 lost its unbox -- a closure call would read a pointer as a double"; $fail++
}

# --- values: raw path, boxed path, and both address-taken paths ---------------------------
$b = Invoke-Timed -FilePath $exe.Path -Arguments "build _f31_unbox_elim_probe.nova" -TimeoutMs 240000
if ($b.ExitCode -ne 0) { Write-Host "UNBOX-ELIM-GATE FAIL: build"; Write-Host $b.StdErr; exit 1 }
$r = Invoke-Timed -FilePath (Resolve-Path ".\_f31_unbox_elim_probe.exe").Path -Arguments "" -TimeoutMs 120000
if ($r.ExitCode -ne 0) { Write-Host "UNBOX-ELIM-GATE FAIL: run exit=$($r.ExitCode)"; exit 1 }
$out = $r.StdOut.Trim()

$want = @{
    "axpy"            = "axpy 10.0";
    "axpy_boxed"      = "axpy_boxed 4.0";
    "scale2"          = "scale2 5.0";
    "scale2_indirect" = "scale2_indirect 5.0"
}
foreach ($k in @("axpy","axpy_boxed","scale2","scale2_indirect")) {
    $w = $want[$k]
    $got = ($out -split "`r?`n" | Where-Object { $_ -like "$k *" }) -join ""
    if ($got -eq $w) { Write-Host "  ok   $w" }
    else { Write-Host "  FAIL value: '$got' (want '$w')"; $fail++ }
}

if ($fail -gt 0) { Write-Host "UNBOX-ELIM-GATE FAIL ($fail)"; exit 1 }
Write-Host "UNBOX-ELIM-GATE OK (6/6 assertions)"
exit 0
