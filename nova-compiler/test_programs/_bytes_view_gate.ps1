# 3.4 — zero-copy read-only buffer view gate.
#
# Two halves, and both are needed:
#   POSITIVE (_bytes_view_kat)     -- a view aliases its parent, bytes_slice still copies, bounds
#                                     clamp, nesting works, a view outlives its parent's scope, and
#                                     every bytes reader accepts a view.
#   NEGATIVE (_bytes_view_ro_neg)  -- a write THROUGH a view aborts loudly. This one must FAIL, and
#                                     a gate that only checked the happy path would pass just as
#                                     well with the guard deleted -- at which point a write would
#                                     silently corrupt a buffer the writer does not own.
#
# Zero-copy is asserted by OBSERVABLE ALIASING inside the KAT (write the parent, read it back
# through the view), not by timing and not by reading IR. Aliasing can only hold if no copy was
# made, and unlike a benchmark it cannot pass by luck on a fast machine.
param([string]$Compiler = ".\gen3_test.exe")

Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
$env:NOVA_NO_CACHE = "1"
if (-not $env:NOVA_HOME) { $env:NOVA_HOME = (Resolve-Path "$PSScriptRoot\..").Path }

$exe = Resolve-Path $Compiler -ErrorAction SilentlyContinue
if (-not $exe) { Write-Host "BYTES-VIEW-GATE FAIL: compiler not found: $Compiler"; exit 1 }

$fail = 0
Write-Host "3.4 zero-copy read-only buffer views:"

# --- the builtin must actually route to nova_rt_bytes_view, not fall back to slice ---------
Remove-Item -Force _bytes_view_kat.ll -ErrorAction SilentlyContinue
$c = Invoke-Timed -FilePath $exe.Path -Arguments "_bytes_view_kat.nova _bytes_view_kat.ll" -TimeoutMs 240000
if ($c.ExitCode -ne 0 -or -not (Test-Path _bytes_view_kat.ll)) {
    Write-Host "  FAIL emit (exit=$($c.ExitCode))"; Write-Host $c.StdOut; Write-Host $c.StdErr; exit 1
}
$ll = Get-Content _bytes_view_kat.ll
if (@($ll | Where-Object { $_ -match "call i64 @nova_rt_bytes_view\(" }).Count -ge 1) {
    Write-Host "  ok   bytes_view lowers to nova_rt_bytes_view"
} else {
    Write-Host "  FAIL bytes_view did not lower to the view builtin"; $fail++
}

# --- POSITIVE ------------------------------------------------------------------------------
Remove-Item -Force _bytes_view_kat.exe -ErrorAction SilentlyContinue
$b = Invoke-Timed -FilePath $exe.Path -Arguments "build _bytes_view_kat.nova" -TimeoutMs 240000
if ($b.ExitCode -ne 0) { Write-Host "  FAIL build kat"; Write-Host $b.StdErr; exit 1 }
$r = Invoke-Timed -FilePath (Resolve-Path ".\_bytes_view_kat.exe").Path -Arguments "" -TimeoutMs 120000
if ($r.ExitCode -eq 0 -and $r.StdOut -like "*bytes_view kat passed*") {
    Write-Host "  ok   aliasing, slice-still-copies, bounds, nesting, escape, reader integration"
} else {
    $line = (($r.StdOut + $r.StdErr).Trim() -split "`r?`n" | Select-Object -First 2) -join " | "
    Write-Host "  FAIL kat (exit=$($r.ExitCode)): $line"; $fail++
}

# --- NEGATIVE: a write through a read-only view MUST abort --------------------------------
Remove-Item -Force _bytes_view_ro_neg.exe -ErrorAction SilentlyContinue
$nb = Invoke-Timed -FilePath $exe.Path -Arguments "build _bytes_view_ro_neg.nova" -TimeoutMs 240000
if ($nb.ExitCode -ne 0) { Write-Host "  FAIL build neg"; Write-Host $nb.StdErr; exit 1 }
$nr = Invoke-Timed -FilePath (Resolve-Path ".\_bytes_view_ro_neg.exe").Path -Arguments "" -TimeoutMs 120000
$nout = $nr.StdOut + $nr.StdErr
if ($nr.ExitCode -eq 0) {
    Write-Host "  FAIL read-only guard: a write through a view was ALLOWED (exit=0)"; $fail++
} elseif ($nout -like "*read-only bytes_view*") {
    Write-Host "  ok   read-only guard: write through a view aborts with a named diagnostic"
} else {
    Write-Host "  FAIL read-only guard: aborted, but not with the view diagnostic"; $fail++
}
if ($nout -like "*UNREACHABLE*") {
    Write-Host "  FAIL read-only guard: execution continued past the rejected write"; $fail++
}

if ($fail -gt 0) { Write-Host "BYTES-VIEW-GATE FAIL ($fail)"; exit 1 }
Write-Host "BYTES-VIEW-GATE OK (4/4 assertions)"
exit 0
