# 3.1: guard the `readonly` attribute on the unbox declares.
#
# nova_rt_unbox / nova_rt_unbox_elem are pure reads (check a mem tag, deref a payload,
# write nothing). Marking their LLVM declares `readonly` lets LLVM CSE and DCE the
# redundant calls that float-typed code emits. Measured, same source and same -O2:
#     nounwind            -> 8 unbox calls survive
#     nounwind readonly   -> 2          (75% eliminated)
#
# A VALUE test cannot see whether the attribute is still there -- correctness is
# identical either way, only speed changes -- so a silent revert would go unnoticed.
# This gate asserts the attribute is emitted by BOTH backends, and that -O2 actually
# eliminates calls (a loose bound, not an exact count, so an LLVM version change that
# optimises slightly differently does not flake).
Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
Stop-StrayCompilers
$compiler = ".\gen3_test.exe"
if (-not (Test-Path $compiler)) { Write-Host "SKIP: gen3_test.exe not found"; exit 0 }

$t = "_unbox_readonly_test"
Remove-Item "$t.ll","$t.opt.ll","$t.gate.exe" -Force -ErrorAction SilentlyContinue
Write-Host "=== unbox readonly gate (3.1 float-path optimisation) ==="
$bad = 0

$c = Invoke-Timed -FilePath (Resolve-Path $compiler).Path -Arguments "$t.nova $t.ll" -TimeoutMs 120000
if ($c.TimedOut -or $c.ExitCode -ne 0) { Write-Host "  FAIL: compile"; Write-Host $c.StdOut; exit 1 }

foreach ($fn in @('nova_rt_unbox','nova_rt_unbox_elem')) {
    $d = Select-String -Path "$t.ll" -Pattern "declare i64 @$fn\(i64\)"
    if (-not $d) { Write-Host "  FAIL: no declare emitted for $fn"; $bad = 1; continue }
    if ($d.Line -notmatch 'readonly') {
        Write-Host "  FAIL: $fn declare lost 'readonly' -> LLVM can no longer eliminate redundant unboxes"
        Write-Host "        got: $($d.Line.Trim())"
        $bad = 1
    } else { Write-Host "  PASS $fn declared readonly" }
}

# -O2 must actually remove some calls. Loose bound: fewer after than before.
$before = (Select-String -Path "$t.ll" -Pattern 'call i64 @nova_rt_unbox\(').Count
$o = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -S -emit-llvm -o $t.opt.ll $t.ll" -TimeoutMs 120000
if (Test-Path "$t.opt.ll") {
    $after = (Select-String -Path "$t.opt.ll" -Pattern 'call i64 @nova_rt_unbox\(').Count
    if ($after -ge $before -and $before -gt 0) {
        Write-Host "  FAIL: -O2 eliminated nothing ($before -> $after) -- readonly is not taking effect"
        $bad = 1
    } else { Write-Host ("  PASS -O2 eliminates redundant unboxes ({0} -> {1})" -f $before, $after) }
} else { Write-Host "  FAIL: could not produce optimised IR"; $bad = 1 }

# And the arithmetic must still be right -- readonly is a PROMISE, and a wrong promise
# shows up as a silently wrong answer, not a crash.
$l = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o $t.gate.exe $t.ll ..\compiler\nova_runtime.c $NovaLinkFlags -D_CRT_SECURE_NO_WARNINGS -w" -TimeoutMs 240000
if (-not (Test-Path "$t.gate.exe")) { Write-Host "  FAIL: link"; $bad = 1 }
else {
    $r = Invoke-Timed -FilePath (Resolve-Path ".\$t.gate.exe").Path -Arguments "" -TimeoutMs 30000
    if ($r.TimedOut -or $r.ExitCode -ne 0 -or ($r.StdOut -notmatch 'UNBOX_READONLY_OK')) {
        Write-Host "  FAIL: float arithmetic wrong under readonly (exit=$($r.ExitCode))"
        if ($r.StdOut) { Write-Host "    $($r.StdOut.Trim())" }
        $bad = 1
    } else { Write-Host "  PASS float values correct under the optimisation" }
}

Remove-Item "$t.opt.ll","$t.gate.exe","$t.ll" -Force -ErrorAction SilentlyContinue
if ($bad -ne 0) { Write-Host "`n=== UNBOX READONLY GATE FAILED ==="; exit 1 }
Write-Host "  PASS: unbox declares readonly, -O2 eliminates, values correct"
exit 0
