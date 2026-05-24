Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"

$compiler = (Resolve-Path ".\gen2_move.exe").Path
Copy-Item "output\nova_runtime.c" "nova_runtime.c" -Force

$tests = Get-ChildItem -Filter "*_test.nova" | ForEach-Object { $_.BaseName }
$pass = 0; $fail = 0; $skip = 0; $failures = @()

foreach ($t in $tests) {
    # Skip known network/IO tests that need external resources
    if ($t -match "tcp_test|http_test|distributed_") { $skip++; continue }

    $tc = Invoke-Timed -FilePath $compiler -Arguments "$t.nova" -TimeoutMs 30000
    if ($tc.ExitCode -ne 0) { $failures += "$t (COMPILE)"; $fail++; continue }

    if (!(Test-Path "$t.ll")) { $failures += "$t (NO .ll)"; $fail++; continue }

    $tl = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o $t.exe $t.ll nova_runtime.c $NovaLinkFlags" -TimeoutMs 30000
    if (!(Test-Path "$t.exe")) { $failures += "$t (LINK)"; $fail++; continue }

    $tr = Invoke-Timed -FilePath (Resolve-Path ".\$t.exe").Path -Arguments "" -TimeoutMs 15000
    if ($tr.ExitCode -ne 0) {
        $failures += "$t (exit=$($tr.ExitCode))"
        $fail++
    } else {
        $pass++
    }
    Remove-Item "$t.exe","$t.ll" -Force -ErrorAction SilentlyContinue
}

Write-Host "`nFull suite: $pass PASS, $fail FAIL, $skip SKIP (of $($tests.Count) total)"
if ($failures.Count -gt 0) {
    Write-Host "`nFailures:"
    foreach ($f in $failures) { Write-Host "  $f" }
}
Remove-Item "nova_runtime.c" -Force -ErrorAction SilentlyContinue
if ($fail -gt 0) { exit 1 }
