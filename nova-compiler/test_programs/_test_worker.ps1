# Shared per-test worker: compile -> link -> run ONE test program, with kill-on-timeout.
#
# Extracted from _run_final_regression.ps1 so the full regression and the targeted
# _impact_gate.ps1 run tests through the SAME code. A second copy would drift, and the two
# would then disagree about what "PASS" means -- which is the one thing a gate cannot afford.
#
# Dot-source this file, then dispatch $testScript into a runspace with the 7 arguments its
# param() block declares.

$testScript = {
    param($testName, $compilerPath, $rtObjPath, $workDir, $clangExe, $lFlags, $sqPath)

    $r = @{ Name = $testName; Status = "PASS"; Detail = ""; Out = ""; OutFail = $false }

    if (-not (Test-Path "$workDir\$testName.nova")) {
        $r.Status = "SKIP"; return $r
    }

    function _RunProc($fp, $ar, $to, $wd) {
        $pi = New-Object System.Diagnostics.ProcessStartInfo
        $pi.FileName = $fp; $pi.Arguments = $ar; $pi.WorkingDirectory = $wd
        $pi.UseShellExecute = $false
        $pi.RedirectStandardOutput = $true; $pi.RedirectStandardError = $true
        $pi.CreateNoWindow = $true
        $p = [System.Diagnostics.Process]::Start($pi)
        $ot = $p.StandardOutput.ReadToEndAsync()
        $et = $p.StandardError.ReadToEndAsync()
        $ok = $p.WaitForExit($to)
        if (-not $ok) {
            try { $p.Kill() } catch {}
            try { $p.WaitForExit(5000) } catch {}
            return @{ T = $true; X = -1; O = ""; E = "" }
        }
        return @{ T = $false; X = $p.ExitCode; O = $ot.Result; E = $et.Result }
    }

    $ll  = "$workDir\$testName.ll"
    $exe = "$workDir\$testName.exe"

    # 150s (was 60s): the self-hosted compiler is a heavy binary; with up to 8 compiles running
    # concurrently (maxParallel) on a contended machine a single compile can exceed 60s wall-time and
    # spuriously "COMPILE exit=-1" (a timeout), failing the CI on a ROTATING set of innocent tests that
    # all pass individually. 150s absorbs the contention while still catching a genuinely hung compile.
    $cr = _RunProc $compilerPath "$testName.nova" 150000 $workDir
    if ($cr.T -or $cr.X -ne 0) {
        $r.Status = "FAIL"; $r.Detail = "COMPILE exit=$($cr.X)"; return $r
    }
    if (-not (Test-Path $ll)) {
        $r.Status = "FAIL"; $r.Detail = "NO .ll"; return $r
    }

    $xlib = ""
    $skipL = @('m','pthread','dl','rt')
    Get-Content $ll | Where-Object { $_ -match '^; LINK_LIB: (\S+)' } | ForEach-Object {
        if ($skipL -notcontains $matches[1]) { $xlib += " -l$($matches[1])" }
    }
    $xsrc = ""
    if ((Select-String -Path $ll -Pattern '@sqlite3_' -Quiet) -and (Test-Path $sqPath)) {
        $xsrc = " `"$sqPath`""   # $sqPath is the pre-compiled sqlite3_test.o (fast, reliable link)
    }
    # General FFI @link_source/@link_object: the regression links manually (it does not
    # shell to the compiler's nova_link), so it must honor the same markers nova_link does.
    # Compile each C source to <src>.o on demand; add prebuilt objects directly. Only the
    # one test that declares foo.c hits this, so no cross-test race on the object.
    Get-Content $ll | Where-Object { $_ -match '^; LINK_SOURCE: (.+?)\s*$' } | ForEach-Object {
        $sp = $matches[1]
        $obj = "$workDir\$sp.o"
        if (Test-Path "$workDir\$sp") {
            # Rebuild when the SOURCE is newer than the object, not merely when the object is
            # absent. The existence-only check silently linked a STALE object after any edit to
            # a @link_source C file -- the failure surfaces as an unrelated "undefined symbol"
            # link error, which is about as misleading as a build system gets. (The comment
            # above always claimed nova_link's "rebuilt only when foo.c is newer" semantics;
            # this makes the harness actually implement them.)
            $needBuild = -not (Test-Path $obj)
            if (-not $needBuild) {
                $needBuild = (Get-Item "$workDir\$sp").LastWriteTimeUtc -gt (Get-Item $obj).LastWriteTimeUtc
            }
            if ($needBuild) {
                _RunProc $clangExe "-c -O2 `"$workDir\$sp`" -o `"$obj`" -D_CRT_SECURE_NO_WARNINGS -w" 60000 $workDir | Out-Null
            }
            $xsrc += " `"$obj`""
        }
    }
    Get-Content $ll | Where-Object { $_ -match '^; LINK_OBJECT: (.+?)\s*$' } | ForEach-Object {
        $op = $matches[1]
        if (Test-Path "$workDir\$op") { $xsrc += " `"$workDir\$op`"" }
    }

    $la = "-O2 -o `"$exe`" `"$ll`" `"$rtObjPath`"$xsrc $lFlags$xlib -D_CRT_SECURE_NO_WARNINGS -w"
    $lr = _RunProc $clangExe $la 300000 $workDir
    if (-not (Test-Path $exe)) {
        $r.Status = "FAIL"; $r.Detail = "LINK"
        Remove-Item $ll -Force -ErrorAction SilentlyContinue
        return $r
    }

    $rr = _RunProc $exe "" 60000 $workDir
    Remove-Item $exe,$ll -Force -ErrorAction SilentlyContinue

    if ($rr.T) { $r.Status = "FAIL"; $r.Detail = "TIMEOUT" }
    elseif ($rr.X -ne 0) {
        # CARRY A STDERR EXCERPT. The exit code alone is often not enough to act on: the CI-only
        # 0xC0000005 in overflow_recovery_test/_stackovf_test is either a guard page that was never
        # restored (the runtime now prints guard_restored=0) or an overflow that skipped the guard
        # entirely -- and those need OPPOSITE fixes. $rr.E already held the answer and was being
        # thrown away, so every occurrence cost a full round-trip and still did not distinguish them.
        $tail = ""
        if ($rr.E) { $tail = (($rr.E -split "`r?`n" | Where-Object { $_ -ne "" } | Select-Object -Last 2) -join " ; ") }
        if ($tail.Length -gt 180) { $tail = $tail.Substring(0, 180) }
        $r.Status = "FAIL"; $r.Detail = "RUN exit=$($rr.X)" + $(if ($tail) { " | $tail" } else { "" })
    }
    elseif ($rr.E -match 'FAIL assert') { $r.Status = "FAIL"; $r.Detail = "ASSERT FAIL" }

    # STDOUT failure reports: a test that prints its own "FAIL ..." and returns 0 currently PASSES,
    # because the checks above look only at the exit code and at stderr. That is a real hole -- the
    # hand-rolled checker idiom is everywhere in this suite, and one that forgets its exit(1) reports
    # nothing. Found 2026-08-25: _kat_ascii85 prints "Man=FAIL (9`P.n)" and _kat_bech32 prints
    # "abcdef=FAIL (...)", both exit 0. Real encoder bugs that would have been invisible if gated.
    #
    # Recorded as a SUSPECT rather than a failure, deliberately. The pattern is broad enough to hit
    # legitimate output ("0 failed", a test that prints the word FAIL as data), and the false-positive
    # rate over ~2994 gated tests has not been measured yet. Warn first, measure, then decide whether
    # to make it fatal -- flipping it straight to fatal would red the CI on unknown grounds, which is
    # how a gate gets disabled instead of fixed.
    # -cmatch, not -match: PowerShell's -match is CASE-INSENSITIVE by default, so the first cut
    # also fired on benign lowercase summaries like 'ok=9 fail=0'. Case matters here -- the
    # convention in this suite is an uppercase FAIL for a real failure report.
    # Zero-count summaries ('PASS=17 FAIL=0') are excluded for the same reason: they report
    # SUCCESS. Measured on the 2026-08-25 arc: 35 raw hits, of which only a minority were real.
    $_of = $false
    if ($rr.O -cmatch '(^|[^A-Za-z])FAIL([^A-Za-z]|$)') { $_of = $true }
    if ($rr.O -cmatch 'Assertion failed') { $_of = $true }
    if ($_of -and ($rr.O -cmatch 'FAIL\s*[=:]\s*0(\D|$)') -and -not ($rr.O -cmatch '(^|
)\s*FAIL[ :]')) { $_of = $false }
    # A test OF the test framework prints FAIL as its subject matter -- _atest_test and
    # _atest_fixes_test exercise a deliberately-failing case ('FAIL t_fails_on_purpose'), so the
    # word appearing in their output is correct behaviour, not a defect. Narrow, explicit
    # allowlist rather than a looser pattern: loosening the pattern would hide real failures
    # everywhere else, which is the opposite of what this check is for.
    if ($testName -eq '_atest_test' -or $testName -eq '_atest_fixes_test') { $_of = $false }
    if ($_of) { $r.OutFail = $true }
    if ($rr.O) { $r.Out = ([string]$rr.O).Trim() }

    return $r
}
