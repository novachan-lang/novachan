. "$PSScriptRoot\_proc_util.ps1"

$pass = 0
$fail = 0

# Test 1: existing trait_test.nova (no conformance syntax) — should compile clean
Write-Host "Test 1: trait_test.nova (backward compat)"
$r = Invoke-Timed -FilePath "$PSScriptRoot\gen3_test.exe" -Arguments "trait_test.nova" -TimeoutMs 15000
if ($r.ExitCode -eq 0) { Write-Host "  [PASS]"; $pass++ } else { Write-Host "  [FAIL] $($r.StdOut) $($r.StdErr)"; $fail++ }

# Test 2: all methods implemented — should compile clean
Write-Host "Test 2: trait_pass_test.nova (full conformance)"
$r = Invoke-Timed -FilePath "$PSScriptRoot\gen3_test.exe" -Arguments "trait_pass_test.nova" -TimeoutMs 15000
if ($r.ExitCode -eq 0) { Write-Host "  [PASS]"; $pass++ } else { Write-Host "  [FAIL] $($r.StdOut) $($r.StdErr)"; $fail++ }

# Test 3: missing method — should error with missing name()
Write-Host "Test 3: trait_conformance_test.nova (missing method)"
$r = Invoke-Timed -FilePath "$PSScriptRoot\gen3_test.exe" -Arguments "trait_conformance_test.nova" -TimeoutMs 15000
if ($r.ExitCode -ne 0 -and $r.StdOut -match "missing name") {
    Write-Host "  [PASS] correctly caught: $($r.StdOut.Trim().Split("`n")[0])"
    $pass++
} else { Write-Host "  [FAIL] expected missing name() error, got: $($r.StdOut) $($r.StdErr)"; $fail++ }

# Test 4: unknown trait — should error
Write-Host "Test 4: trait_unknown_test.nova (unknown trait)"
$r = Invoke-Timed -FilePath "$PSScriptRoot\gen3_test.exe" -Arguments "trait_unknown_test.nova" -TimeoutMs 15000
if ($r.ExitCode -ne 0 -and $r.StdOut -match "unknown trait") {
    Write-Host "  [PASS] correctly caught: $($r.StdOut.Trim().Split("`n")[0])"
    $pass++
} else { Write-Host "  [FAIL] expected unknown trait error, got: $($r.StdOut) $($r.StdErr)"; $fail++ }

# Test 5: trait_minimal.nova (trait with body, no conformance) — should compile
Write-Host "Test 5: trait_minimal.nova (trait with body)"
$r = Invoke-Timed -FilePath "$PSScriptRoot\gen3_test.exe" -Arguments "trait_minimal.nova" -TimeoutMs 15000
if ($r.ExitCode -eq 0) { Write-Host "  [PASS]"; $pass++ } else { Write-Host "  [FAIL] $($r.StdOut) $($r.StdErr)"; $fail++ }

Write-Host ""
Write-Host "=== Results: $pass PASS, $fail FAIL ==="
