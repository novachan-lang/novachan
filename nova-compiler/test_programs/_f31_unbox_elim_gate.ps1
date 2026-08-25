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

# --- LINKAGE: internal for ordinary fns, EXTERNAL for @export ----------------------------
# The two halves of the perf win are unbox removal and internal linkage, and neither does
# anything without the other -- so both need asserting or a future change could quietly undo
# half of it and leave the ratio at 1.7x with every test still green.
if (@($ll | Where-Object { $_ -match "^define internal i64 @axpy\(" }).Count -eq 1) {
    Write-Host "  ok   @axpy has INTERNAL linkage (LLVM may inline it)"
} else {
    Write-Host "  FAIL @axpy is not internal -- LLVM will not inline it, costing the whole win"; $fail++
}
# @export is the C ABI, and it needs its OWN probe: one @export puts the unit into C-library mode,
# which renames the entry away from `main`, so it cannot be a runnable program. IR only.
# Internalising an @export still compiles and still links as a library -- a C host simply cannot
# resolve the symbol, and nothing in this repo would notice. Hence the structural assertion.
Remove-Item -Force _f31_export_linkage_probe.ll -ErrorAction SilentlyContinue
$xc = Invoke-Timed -FilePath $exe.Path -Arguments "_f31_export_linkage_probe.nova _f31_export_linkage_probe.ll" -TimeoutMs 240000
if ($xc.ExitCode -ne 0 -or -not (Test-Path _f31_export_linkage_probe.ll)) {
    Write-Host "  FAIL export probe: emit (exit=$($xc.ExitCode))"; $fail++
} else {
    $xll = Get-Content _f31_export_linkage_probe.ll
    $bad = @($xll | Where-Object { $_ -match "^define internal i64 @nova_exported_" })
    $good = @($xll | Where-Object { $_ -match "^define i64 @nova_exported_" })
    if ($bad.Count -gt 0) {
        Write-Host "  FAIL $($bad.Count) @export fn(s) internalised -- the C ABI symbol is gone"; $fail++
    } elseif ($good.Count -eq 2) {
        Write-Host "  ok   both @export fns keep EXTERNAL linkage (C ABI intact)"
    } else {
        Write-Host "  FAIL expected 2 external @export fns, found $($good.Count)"; $fail++
    }
    if (@($xll | Where-Object { $_ -match "^define internal i64 @helper_add\(" }).Count -eq 1) {
        Write-Host "  ok   a non-exported fn is still internal in library mode"
    } else {
        Write-Host "  FAIL helper_add should be internal even in @export library mode"; $fail++
    }
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
Write-Host "UNBOX-ELIM-GATE OK (9/9 assertions)"
exit 0
