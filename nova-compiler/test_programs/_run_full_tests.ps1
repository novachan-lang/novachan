Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"

$compiler = (Resolve-Path ".\gen3_test.exe").Path
Copy-Item "output\nova_runtime.c" "nova_runtime.c" -Force

# Tests that SHOULD exit non-zero (testing error paths)
$expect_fail = @("assert_fail_test")

# Tests that need additional C files linked
$extra_c = @{
    "ffi_test"      = "ffi_helper.c"
    "ffi_full_test" = "ffi_helper.c"
}

# Tests that need external resources (network, multi-file import, etc.)
$skip_patterns = "tcp_test|http_test|distributed_|import_multi_test"

$tests = Get-ChildItem -Filter "*_test.nova" | ForEach-Object { $_.BaseName }
$pass = 0; $fail = 0; $skip = 0; $failures = @()

foreach ($t in $tests) {
    if ($t -match $skip_patterns) { $skip++; continue }

    $tc = Invoke-Timed -FilePath $compiler -Arguments "$t.nova" -TimeoutMs 30000
    if ($tc.ExitCode -ne 0) { $failures += "$t (COMPILE)"; $fail++; continue }

    if (!(Test-Path "$t.ll")) { $failures += "$t (NO .ll)"; $fail++; continue }

    # Build link command — add extra C files if needed
    $link_args = "-O2 -o $t.exe $t.ll nova_runtime.c"
    if ($extra_c.ContainsKey($t) -and (Test-Path $extra_c[$t])) {
        $link_args = "$link_args $($extra_c[$t])"
    }
    $link_args = "$link_args $NovaLinkFlags"

    $tl = Invoke-Timed -FilePath $ClangPath -Arguments $link_args -TimeoutMs 30000
    if (!(Test-Path "$t.exe")) { $failures += "$t (LINK)"; $fail++; continue }

    $tr = Invoke-Timed -FilePath (Resolve-Path ".\$t.exe").Path -Arguments "" -TimeoutMs 15000

    if ($expect_fail -contains $t) {
        # These tests SHOULD exit non-zero
        if ($tr.ExitCode -ne 0) { $pass++ }
        else { $failures += "$t (expected failure, got success)"; $fail++ }
    } else {
        if ($tr.ExitCode -ne 0) {
            $failures += "$t (exit=$($tr.ExitCode))"
            $fail++
        } else {
            $pass++
        }
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
