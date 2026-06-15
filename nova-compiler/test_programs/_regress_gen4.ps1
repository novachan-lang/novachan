Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"

$compiler = (Resolve-Path ".\gen4_test.exe").Path

$skip_patterns = "tcp_test|http_test|distributed_|import_multi_test|workerx|ai_serve"

$tests = Get-ChildItem -Filter "*_test.nova" | ForEach-Object { $_.BaseName }
$pass = 0; $fail = 0; $skip = 0; $failures = @()

foreach ($t in $tests) {
    if ($t -match $skip_patterns) { $skip++; continue }

    $tc = Invoke-Timed -FilePath $compiler -Arguments "$t.nova" -TimeoutMs 30000
    if ($tc.ExitCode -ne 0) { $failures += "$t (COMPILE: $($tc.StdErr))"; $fail++; continue }

    if (!(Test-Path "$t.ll")) { $failures += "$t (NO .ll)"; $fail++; continue }

    $link_args = "-o $t.exe $t.ll output/nova_runtime.o $NovaLinkFlags"
    $tl = Invoke-Timed -FilePath $ClangPath -Arguments $link_args -TimeoutMs 30000
    if ($tl.ExitCode -ne 0) { $failures += "$t (LINK: $($tl.StdErr))"; $fail++; continue }

    $tr = Invoke-Timed -FilePath (Resolve-Path ".\$t.exe").Path -Arguments "" -TimeoutMs 15000

    if ($t -eq "assert_fail_test") {
        if ($tr.ExitCode -ne 0) { $pass++ } else { $failures += "$t (expected fail)"; $fail++ }
    } elseif ($tr.TimedOut) {
        $failures += "$t (TIMEOUT)"; $fail++
    } elseif ($tr.ExitCode -ne 0) {
        $failures += "$t (exit=$($tr.ExitCode))"; $fail++
    } else {
        $pass++
    }
    Remove-Item "$t.exe","$t.ll" -Force -ErrorAction SilentlyContinue
}

Write-Host "`nRegression: $pass PASS, $fail FAIL, $skip SKIP (of $($tests.Count))"
if ($failures.Count -gt 0) {
    Write-Host "`nFailures:"
    foreach ($f in $failures) { Write-Host "  $f" }
}
