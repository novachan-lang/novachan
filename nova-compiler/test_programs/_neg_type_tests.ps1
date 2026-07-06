### Negative type-error test runner
### Every file listed here MUST fail to compile (compiler exit != 0).
### Run with: powershell -File _neg_type_tests.ps1
### Returns exit 1 if any test passes when it should fail.
###
### Tier 1.5 requirement: these tests must exist and run before soundness
### improvements (1.1/1.2/1.3) can be trusted — they prove regressions are visible.

Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"

$compiler = ".\gen3_test.exe"
if (-not (Test-Path $compiler)) { Write-Host "SKIP: gen3_test.exe not found"; exit 0 }

$pass = 0
$fail = 0

function Test-ShouldReject {
    param([string]$file, [string]$expected_err_frag)
    $r = Invoke-Timed -FilePath (Resolve-Path $compiler).Path -Arguments $file -TimeoutMs 30000
    if ($r.TimedOut) {
        Write-Host "  TIMEOUT $file  => BUG (should reject quickly)"
        $script:fail++
        return
    }
    if ($r.ExitCode -ne 0) {
        # Compiler rejected — check output contains the expected fragment (if provided)
        if ($expected_err_frag -ne "" -and -not ($r.Stdout -match $expected_err_frag) -and -not ($r.Stderr -match $expected_err_frag)) {
            Write-Host "  WEAK-FAIL $file  rejected (good) but expected '$expected_err_frag' not in output"
            $script:fail++
        } else {
            Write-Host "  PASS $file  correctly rejected (exit=$($r.ExitCode))"
            $script:pass++
        }
    } else {
        Write-Host "  FAIL $file  accepted when it should have been rejected"
        $script:fail++
    }
}

Write-Host "=== Negative type-error tests ==="

Test-ShouldReject "_negty_arity.nova"      "expects 2 arguments"
Test-ShouldReject "_negty_rettype.nova"    "type mismatch"
Test-ShouldReject "_negty_argtype.nova"    "type mismatch"
Test-ShouldReject "_negty_undeclared.nova" "unknown identifier"
Test-ShouldReject "_negty_recursive.nova"  "recursive type"
Test-ShouldReject "_negty_notfn.nova"      "type mismatch"
Test-ShouldReject "_negty_nofield.nova"    "has no field"
Test-ShouldReject "_negty_fieldtype.nova"  "type mismatch"
Test-ShouldReject "_negty_exhaustive.nova" "non-exhaustive"
Test-ShouldReject "_negty_traitconf.nova"  "does not fully implement"

# Previously-orphaned negative tests reclaimed from the *_test.nova sweep (CORE_GAP 7.3): real programs
# the compiler MUST reject. These broaden soundness coverage beyond the _negty_* minimal repros.
Test-ShouldReject "trait_bounds_fail_test.nova"   "does not implement trait"
Test-ShouldReject "trait_unknown_test.nova"       "unknown trait"
Test-ShouldReject "ffi_unsafe_required_test.nova" "requires an enclosing 'unsafe'"
Test-ShouldReject "multi_error_test.nova"         "expected"

Write-Host ""
Write-Host "Result: $pass passed, $fail failed"
if ($fail -gt 0) { exit 1 } else { exit 0 }
