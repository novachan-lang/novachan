# INCREMENTAL-BUILD STALENESS GATE
#
# nova_compile_file skips the compile when the output .ll is newer than the input.
# It used to compare ONLY the ENTRY file's mtime -- so editing an IMPORTED module
# while the entry file stayed untouched left the cache "valid" and silently served a
# STALE build. Every multi-file project hits this: edit a library module, run your
# app, get the old behaviour with no warning.
#
# Fixed by comparing against the newest mtime across the entry file AND its
# transitive imports (nova_newest_source_mtime, lexical scan, fails safe to rebuild).
#
# This gate asserts BOTH directions, because either alone is passable by a broken
# build: (1) an import edit MUST change the output, and (2) with no edit the cache
# MUST still hit -- a "fix" that just disabled caching would pass (1) and destroy the
# 170ms build time that makes `nova watch` worth having.
Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
Stop-StrayCompilers
$compiler = ".\gen3_test.exe"
if (-not (Test-Path $compiler)) { Write-Host "SKIP: gen3_test.exe not found"; exit 0 }

$d = "_incrdemo"
Remove-Item $d -Recurse -Force -ErrorAction SilentlyContinue
New-Item -ItemType Directory -Force -Path $d | Out-Null
Set-Content -Path "$d\ihelper.nova" -Value @("fn icompute() -> int", "    41")
Set-Content -Path "$d\iapp.nova"    -Value @("import ihelper", "fn main()", "    print(""value = "" + str(ihelper.icompute()))")

Write-Host "=== incremental-build staleness gate (import edits must invalidate) ==="
$bad = 0
function Run-App {
    $r = Invoke-Timed -FilePath (Resolve-Path ".\gen3_test.exe").Path -Arguments "run $d\iapp.nova" -TimeoutMs 180000
    if ($r.TimedOut -or $r.ExitCode -ne 0) { Write-Host "  FAIL: run failed (exit=$($r.ExitCode))"; Write-Host $r.StdOut; $script:bad = 1; return "" }
    return $r.StdOut.Trim()
}

$a = Run-App
if ($a -notmatch 'value = 41') { Write-Host "  FAIL: initial build, expected 'value = 41', got '$a'"; $bad = 1 }
else { Write-Host "  PASS initial build -> 41" }

# Edit ONLY the imported module. Sleep first so the new mtime is strictly greater than
# the .ll's -- an equal timestamp is legitimately treated as fresh (same as make).
Start-Sleep -Seconds 2
Set-Content -Path "$d\ihelper.nova" -Value @("fn icompute() -> int", "    99")
$b = Run-App
if ($b -notmatch 'value = 99') { Write-Host "  FAIL: STALE BUILD -- edited import not picked up; expected 'value = 99', got '$b'"; $bad = 1 }
else { Write-Host "  PASS import edit invalidates cache -> 99" }

# And the cache must STILL work when nothing changed.
$sw = [System.Diagnostics.Stopwatch]::StartNew()
$c = Run-App
$sw.Stop()
if ($c -notmatch 'value = 99') { Write-Host "  FAIL: unchanged rerun, expected 'value = 99', got '$c'"; $bad = 1 }
else { Write-Host ("  PASS unchanged rerun still cached ({0} ms)" -f [int]$sw.Elapsed.TotalMilliseconds) }

Remove-Item $d -Recurse -Force -ErrorAction SilentlyContinue
if ($bad -ne 0) { Write-Host "`n=== INCREMENTAL STALENESS GATE FAILED ==="; exit 1 }
Write-Host "  PASS: import edits invalidate, unchanged rebuilds stay cached"
exit 0
