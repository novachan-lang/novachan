# 3.1 POLYFIELD check.
#
# ⛔ DELETES EVERY OUTPUT BEFORE BUILDING, and passes NOVA_NO_CACHE=1. This is not hygiene, it is
# the whole reason an earlier attempt at this bug was abandoned as "unfixable":
# nova_compile_file skips the compile entirely when the output .ll exists and is newer than the
# (unchanged) .nova source -- it RETURNS BEFORE compile_ir_core_named is ever called. So every
# re-test after the first was relinking a stale .ll produced by the PREVIOUS compiler, a debug
# print inserted into the compiler never fired, and the fix was judged ineffective and reverted
# on evidence that described a build that never happened.
#
# A stale artifact impersonating a result has now happened three times in this codebase (a stale
# /tmp/t binary made three different tests all print PASS; the VSCode LSP binary drifts stale and
# produces phantom syntax errors). Delete first, always.
Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"

$env:NOVA_NO_CACHE = "1"
Remove-Item _pf.ll, _pf.exe, _pfk.ll, _pfk.exe -Force -ErrorAction SilentlyContinue

Write-Host "[1/3] build gen4 from the current nova_compiler.nova"
$r = Invoke-Timed -FilePath (Resolve-Path ".\gen3_test.exe").Path `
     -Arguments "..\compiler\nova_compiler.nova _pf.ll" -TimeoutMs 900000
if ($r.ExitCode -ne 0) {
    Write-Host "  gen4 COMPILE FAILED (exit=$($r.ExitCode) timedout=$($r.TimedOut))"
    (($r.StdOut + $r.StdErr) -split "`n") | Where-Object { $_ -match 'error' } | Select-Object -First 6 | ForEach-Object { Write-Host "    $_" }
    exit 1
}
$l = Invoke-Timed -FilePath "clang" `
     -Arguments "-O2 -o _pf.exe _pf.ll ..\compiler\nova_runtime.c -lws2_32 -ladvapi32 -D_CRT_SECURE_NO_WARNINGS -w" -TimeoutMs 300000
if (-not (Test-Path _pf.exe)) { Write-Host "  gen4 LINK FAILED"; exit 1 }
Write-Host "  gen4 built ($((Get-Item _pf.exe).Length) bytes, $((Get-Item _pf.exe).LastWriteTime.ToString('HH:mm:ss')))"

Write-Host "[2/3] compile the repro with THAT compiler (cache disabled, outputs already deleted)"
$c = Invoke-Timed -FilePath (Resolve-Path ".\_pf.exe").Path `
     -Arguments "_f31_polyfield_known_gap.nova _pfk.ll" -TimeoutMs 120000
if ($c.ExitCode -ne 0) {
    Write-Host "  repro COMPILE FAILED"
    (($c.StdOut + $c.StdErr) -split "`n") | Where-Object { $_ -match 'error' } | Select-Object -First 5 | ForEach-Object { Write-Host "    $_" }
    exit 1
}
if (-not (Test-Path _pfk.ll)) { Write-Host "  no IR produced"; exit 1 }
$l2 = Invoke-Timed -FilePath "clang" -Arguments "-O1 -o _pfk.exe _pfk.ll ..\compiler\nova_runtime.c -lws2_32 -ladvapi32 -w" -TimeoutMs 300000
if (-not (Test-Path _pfk.exe)) { Write-Host "  repro LINK FAILED"; exit 1 }

Write-Host "[3/3] run"
$run = Invoke-Timed -FilePath (Resolve-Path ".\_pfk.exe").Path -Arguments "" -TimeoutMs 30000
$got = $run.StdOut.Trim()
Write-Host "  want: poly 1.5 7"
Write-Host "  got : $got"
if ($got -eq "poly 1.5 7") { Write-Host "  RESULT: FIXED"; exit 0 }
Write-Host "  RESULT: still wrong"
exit 1
