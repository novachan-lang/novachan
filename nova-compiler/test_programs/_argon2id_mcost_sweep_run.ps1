# Driver for _argon2id_mcost_sweep.nova -- see that file's header for the full experiment design.
# Compiles ONE exe, then re-runs it N times per m_cost level (env-var-selected), classifying every
# run by exit code: 0=match, 1=wrong-value(detected in-band), 2=config-error, else=crash, TimedOut=hang.
#
# MANDATORY negative control: the "NEGCTL" level must ALWAYS report wrong=N, ok=0 -- if it doesn't, the
# comparator itself is broken and every other rate in this report is worthless. MANDATORY attempted
# count: every level must show attempted == N, or the run loop silently skipped iterations (the exact
# CRLF-work-list failure mode this project has hit before) -- an absent/short result must never read as
# a clean one.
Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
$env:NOVA_NO_CACHE = "1"

$t = "_argon2id_mcost_sweep"
$exeName = "${t}_sweep.exe"
Remove-Item "$t.ll", $exeName -Force -ErrorAction SilentlyContinue

Write-Host "=== Compiling $t.nova with gen3_test.exe ==="
$c = Invoke-Timed -FilePath (Resolve-Path ".\gen3_test.exe").Path -Arguments "$t.nova $t.ll" -TimeoutMs 240000
Write-Host "compile exit=$($c.ExitCode) timedout=$($c.TimedOut)"
if ($c.TimedOut -or $c.ExitCode -ne 0) {
    Write-Host "COMPILE FAILED"
    if ($c.StdOut) { Write-Host $c.StdOut }
    if ($c.StdErr) { Write-Host $c.StdErr }
    exit 1
}
if (!(Test-Path "$t.ll")) { Write-Host "COMPILE reported success but NO .ll FILE exists -- instrument failure"; exit 1 }

Write-Host "=== Linking $exeName ==="
$l = Invoke-Timed -FilePath "clang" -Arguments "-O1 -o $exeName $t.ll ..\compiler\nova_runtime.c $NovaLinkFlags -w" -TimeoutMs 300000
Write-Host "link exit=$($l.ExitCode) timedout=$($l.TimedOut)"
if ($l.TimedOut -or $l.ExitCode -ne 0) {
    Write-Host "LINK FAILED"
    if ($l.StdErr) { Write-Host $l.StdErr }
    exit 1
}
if (!(Test-Path $exeName)) { Write-Host "LINK reported success but NO EXE exists -- instrument failure"; exit 1 }
$exe = (Resolve-Path ".\$exeName").Path

$N = 20
$levels = @("8", "32", "128", "512", "2048", "NEGCTL")
$results = @{}
$instrumentOk = $true

foreach ($lvl in $levels) {
    $env:NOVA_ARGON_MCOST = $lvl
    $attempted = 0; $ok = 0; $wrong = 0; $crash = 0; $hang = 0; $configerr = 0
    foreach ($i in 1..$N) {
        $attempted++
        $r = Invoke-Timed -FilePath $exe -Arguments "" -TimeoutMs 30000
        if ($r.TimedOut) { $hang++ }
        elseif ($r.ExitCode -eq 0) { $ok++ }
        elseif ($r.ExitCode -eq 1) { $wrong++ }
        elseif ($r.ExitCode -eq 2) { $configerr++ }
        else { $crash++ }
    }
    $results[$lvl] = [pscustomobject]@{
        attempted = $attempted; ok = $ok; wrong = $wrong; crash = $crash; hang = $hang; configerr = $configerr
    }
    Write-Host ("level={0,-6} attempted={1,3} ok={2,3} wrong={3,3} crash={4,3} hang={5,3} configerr={6,3}  (of {7}, 30s cap per run on a ms-scale workload)" -f `
        $lvl, $attempted, $ok, $wrong, $crash, $hang, $configerr, $N)

    # Attempted must equal N at EVERY level -- guards against a work-list/loop bug silently skipping
    # iterations (e.g. the CRLF-mangled-worklist class of failure) and reading as a false "0 failures".
    if ($attempted -ne $N) {
        Write-Host "INSTRUMENT BROKEN: level=$lvl attempted=$attempted, expected $N -- the run loop skipped iterations"
        $instrumentOk = $false
    }
}

Write-Host ""
Write-Host "=== self-check ==="

# Negative control: NEGCTL must mismatch every single time (wrong=N, ok=0). This is what proves the
# in-band comparison can actually detect a wrong value at all -- without it, "0 failures" at the real
# m_cost levels would be indistinguishable from a comparator that always reports match.
$neg = $results["NEGCTL"]
if ($neg.wrong -ne $N -or $neg.ok -ne 0) {
    Write-Host "NEGATIVE CONTROL FAILED: NEGCTL should be wrong=$N ok=0, got wrong=$($neg.wrong) ok=$($neg.ok)"
    Write-Host "  -> the comparator itself may be broken; DO NOT TRUST the pass/fail rates reported above"
    $instrumentOk = $false
}
else {
    Write-Host "negative control OK: NEGCTL correctly mismatched $($neg.wrong)/$N (ok=0, as required)"
}
if ($neg.crash -ne 0 -or $neg.hang -ne 0 -or $neg.configerr -ne 0) {
    Write-Host "NEGATIVE CONTROL ANOMALY: NEGCTL saw crash=$($neg.crash) hang=$($neg.hang) configerr=$($neg.configerr) (expected all zero)"
    $instrumentOk = $false
}

# Every level set a recognized NOVA_ARGON_MCOST value, so configerr must be exactly 0 everywhere.
foreach ($lvl in $levels) {
    if ($results[$lvl].configerr -ne 0) {
        Write-Host "INSTRUMENT BROKEN: level=$lvl saw $($results[$lvl].configerr) CONFIG ERROR run(s) despite a recognized NOVA_ARGON_MCOST value"
        $instrumentOk = $false
    }
}

Remove-Item $exeName -Force -ErrorAction SilentlyContinue

if (-not $instrumentOk) {
    Write-Host ""
    Write-Host "SWEEP INSTRUMENT FAILED SELF-CHECK -- do not interpret the rates above as bug evidence."
    exit 1
}
Write-Host ""
Write-Host "sweep instrument self-check PASSED (attempted==N at every level, negative control fired as required)."
exit 0
