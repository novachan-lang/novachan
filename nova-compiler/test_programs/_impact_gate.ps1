# TARGETED gate -- the fast inner loop for compiler work.
#
# nova_ci.ps1 is all-2862-tests-or-nothing and takes ~35 minutes, which makes it useless as an
# iteration loop: you change three lines, wait half an hour, and by then you have lost the thread.
# This runs a NAMED subset through the SAME worker the full regression uses (_test_worker.ps1),
# in parallel, with the same kill-on-timeout. Seconds to a couple of minutes.
#
# WHAT THIS IS NOT. It is not a substitute for nova_ci before a commit that touches
# nova_compiler.nova or nova_runtime.c. Param-type inference and return-type inference are
# WHOLE-PROGRAM analyses -- every function's codegen depends on every other function's call
# sites -- so a change there has no local blast radius to reason about. Measured, not theorized:
# a three-line change to the unknown-argument rule in ir_collect_param_types silently broke
# struct_perf_test, _pack_float_kat and _antimeridian_test, none of which touch the feature being
# changed; the connection was `fn norm_sq(a) = dot(a, a)` in a file nobody had opened. Use this to
# iterate; use nova_ci (both modes) + reconverge to commit.
#
# Usage:
#   ./_impact_gate.ps1 -Tests struct_perf_test,_pack_float_kat
#   ./_impact_gate.ps1 -Tests statsd_kat -Gates _f31_param_repr_gate.ps1
#   ./_impact_gate.ps1 -Match "float|struct"          # regex over every *.nova in this folder
#   ./_impact_gate.ps1 -Tests dot_test -Compiler _gen4.exe
param(
    [string[]]$Tests = @(),
    [string]$Match = "",
    [string[]]$Gates = @(),
    [string]$Compiler = "gen3_test.exe",
    [switch]$Strict
)
Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
. "$PSScriptRoot\_test_worker.ps1"

$env:NOVA_NO_CACHE = "1"
if (-not $env:NOVA_HOME) { $env:NOVA_HOME = (Resolve-Path "$PSScriptRoot\..").Path }

$compilerPath = Resolve-Path $Compiler -ErrorAction SilentlyContinue
if (-not $compilerPath) { Write-Host "IMPACT-GATE FAIL: compiler not found: $Compiler"; exit 1 }

# -Match is a convenience for "everything that smells like X"; it resolves against the test
# programs actually present, so a stale name in a hand-written list cannot silently test nothing.
if ($Match) {
    $Tests += @(Get-ChildItem -Path $PSScriptRoot -Filter "*.nova" |
                Where-Object { $_.BaseName -match $Match } |
                ForEach-Object { $_.BaseName })
}
$Tests = @($Tests | Select-Object -Unique)
if ($Tests.Count -eq 0 -and $Gates.Count -eq 0) {
    Write-Host "IMPACT-GATE FAIL: nothing selected. Pass -Tests, -Match, or -Gates."
    exit 1
}

# A name that matches no .nova is an ERROR, not a skip. A typo'd test name silently passing is
# how a gate quietly stops gating.
$missing = @($Tests | Where-Object { -not (Test-Path "$PSScriptRoot\$_.nova") })
if ($missing.Count -gt 0) {
    Write-Host "IMPACT-GATE FAIL: no such test program(s): $($missing -join ', ')"
    exit 1
}

Write-Host "=== NOVA Impact Gate ==="
Write-Host "Compiler: $($compilerPath.Path)"
Write-Host "Tests:    $($Tests.Count)   Gates: $($Gates.Count)"
$sw = [Diagnostics.Stopwatch]::StartNew()

$fail = 0
$ungated = 0
$failures = @()

# The regression runner's static lists, read WITHOUT executing its build steps: everything up to the
# $all_tests assembly, minus the lines with side effects.
$script:gatedTests = @()
try {
    $rsrc = Get-Content "$PSScriptRoot\_run_final_regression.ps1"
    $upto = ($rsrc | Select-String -Pattern '^\$all_tests\s*=' | Select-Object -First 1).LineNumber
    $head = ($rsrc[0..($upto - 1)] | Where-Object { $_ -notmatch '^\s*(param|Set-Location|\.\s+"|Invoke-Timed|exit |\$compiler\s*=|\$rtc)' }) -join "`n"
    $sb = [scriptblock]::Create($head + "`n`$all_tests")
    $script:gatedTests = @(& $sb)
} catch { }
if ($script:gatedTests.Count -eq 0) {
    Write-Host "IMPACT-GATE NOTE: could not read the regression test list; every selected test will be treated as gated."
}

if ($Tests.Count -gt 0) {
    # Same one-shot runtime/sqlite pre-compile the full regression does: recompiling the 9 MB
    # sqlite amalgamation per test blew the link timeout under parallel load.
    $runtimeObj = "$PSScriptRoot\nova_runtime_test.o"
    $rtc = Invoke-Timed -FilePath $ClangPath -Arguments "-c -O2 `"$PSScriptRoot\..\compiler\nova_runtime.c`" -o `"$runtimeObj`" -D_CRT_SECURE_NO_WARNINGS -w" -TimeoutMs 180000 -WorkingDirectory $PSScriptRoot
    if ($rtc.ExitCode -ne 0 -or !(Test-Path $runtimeObj)) {
        Write-Host "IMPACT-GATE FAIL: runtime pre-compile (exit=$($rtc.ExitCode))"
        if ($rtc.StdErr) { Write-Host $rtc.StdErr }
        exit 1
    }
    $sqliteObj = "$PSScriptRoot\output\sqlite3_test.o"
    $sqliteSrc = "$PSScriptRoot\..\compiler\sqlite3.c"
    if ((Test-Path $sqliteSrc) -and -not (Test-Path $sqliteObj)) {
        Invoke-Timed -FilePath $ClangPath -Arguments "-c -O2 -DSQLITE_THREADSAFE=0 `"$sqliteSrc`" -o `"$sqliteObj`" -D_CRT_SECURE_NO_WARNINGS -w" -TimeoutMs 240000 -WorkingDirectory $PSScriptRoot | Out-Null
    }

    # Half the cores, matching the arc's reservation: the whole point is that this stays usable
    # WHILE a full arc runs in the background, and 6 here + 4 there would oversubscribe an
    # 8-core box and push test compiles into their timeouts -- spurious failures on both sides.
    $maxParallel = [Math]::Max(2, [Math]::Min(8, [int]([Environment]::ProcessorCount / 2)))
    if ($env:NOVA_CI_PARALLEL) { $maxParallel = [Math]::Max(1, [int]$env:NOVA_CI_PARALLEL) }
    $pool = [System.Management.Automation.Runspaces.RunspaceFactory]::CreateRunspacePool(1, $maxParallel)
    $pool.Open()
    $jobs = New-Object System.Collections.ArrayList
    foreach ($t in $Tests) {
        $ps = [PowerShell]::Create()
        $ps.RunspacePool = $pool
        [void]$ps.AddScript($testScript)
        [void]$ps.AddArgument($t)
        [void]$ps.AddArgument($compilerPath.Path)
        [void]$ps.AddArgument($runtimeObj)
        [void]$ps.AddArgument($PSScriptRoot)
        [void]$ps.AddArgument($ClangPath)
        [void]$ps.AddArgument($NovaLinkFlags)
        [void]$ps.AddArgument($sqliteObj)
        [void]$jobs.Add(@{ PS = $ps; Handle = $ps.BeginInvoke(); Name = $t })
    }
    foreach ($job in $jobs) {
        try {
            $res = $job.PS.EndInvoke($job.Handle)
            if ($res -and $res.Count -gt 0) { $r = $res[$res.Count - 1] }
            else { $r = @{ Name = $job.Name; Status = "FAIL"; Detail = "NO RESULT" } }
        } catch {
            $r = @{ Name = $job.Name; Status = "FAIL"; Detail = "EXCEPTION: $($_.Exception.Message)" }
        } finally { $job.PS.Dispose() }
        # EXPECTED-FAIL convention: a program named *_neg.nova asserts that something is REJECTED,
        # so a non-zero exit is the pass condition. Without this a -Match sweep reports every
        # negative test as broken, which trains you to ignore the gate's output -- the worst thing
        # a gate can do. The inverse is checked too: a _neg test that SUCCEEDS is a real failure,
        # because the thing it was supposed to reject got through.
        # UNGATED tests are REPORTED, not failed. The regression runner's own lists are the
        # definition of "runnable as a plain executable"; anything outside them is run by a
        # dedicated gate that supplies what it needs -- a C host for @cdecl, external libraries for
        # the full FFI tests, an expected REJECTION for a _negty_ program, or IR-only inspection for
        # an @export library (one @export renames the entry away from main, so there is nothing to
        # run). Verified: all 12 such programs in the float/FFI sweep fail IDENTICALLY on the
        # previously committed compiler, so treating them as regressions is pure noise -- and a noisy
        # gate is one you learn to ignore, which is worse than no gate. -Strict fails on them.
        $isNeg = $r.Name -like "*_neg"
        $isUngated = -not ($script:gatedTests -contains $r.Name)
        switch ($r.Status) {
            "PASS" {
                if ($isNeg) { $fail++; $failures += "$($r.Name) (expected-fail test SUCCEEDED)"; Write-Host "FAIL $($r.Name)  (expected-fail test SUCCEEDED)" }
                else        { Write-Host "PASS $($r.Name)" }
            }
            "SKIP" { Write-Host "SKIP $($r.Name)" }
            default {
                if ($isNeg) { Write-Host "PASS $($r.Name)  (rejected as expected: $($r.Detail))" }
                elseif ($isUngated -and -not $Strict) { $ungated++; Write-Host "ungated $($r.Name)  ($($r.Detail)) -- not in the regression list; run by its own gate" }
                else        { $fail++; $failures += "$($r.Name) ($($r.Detail))"; Write-Host "FAIL $($r.Name)  ($($r.Detail))" }
            }
        }
    }
    $pool.Close()
    Remove-Item $runtimeObj -Force -ErrorAction SilentlyContinue
}

# Gate scripts run SERIALLY and after the tests: each one emits its own IR and binaries into this
# same folder, so running two at once would let them overwrite each other's artifacts.
foreach ($g in $Gates) {
    if (-not (Test-Path "$PSScriptRoot\$g")) {
        Write-Host "FAIL gate $g (no such script)"; $fail++; $failures += "$g (missing)"; continue
    }
    Write-Host ""
    & "$PSScriptRoot\$g" -Compiler $compilerPath.Path
    if ($LASTEXITCODE -ne 0) { $fail++; $failures += "$g (exit=$LASTEXITCODE)" }
}

$sw.Stop()
Write-Host ""
$okCount = $Tests.Count - $fail - $ungated
$ungTxt = ""
if ($ungated -gt 0) { $ungTxt = ", $ungated ungated" }
Write-Host "=== IMPACT GATE: $okCount ok, $fail FAIL$ungTxt  ($([int]$sw.Elapsed.TotalSeconds)s) ==="
if ($fail -gt 0) {
    foreach ($f in $failures) { Write-Host "  $f" }
    exit 1
}
exit 0
