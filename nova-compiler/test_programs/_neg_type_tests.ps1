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
Test-ShouldReject "_negty_keyword.nova"    "reserved keyword"
Test-ShouldReject "_negty_width.nova"      "width mismatch"
Test-ShouldReject "_negty_f32width.nova"   "width mismatch"
Test-ShouldReject "_negty_f32mix.nova"     "width mismatch"
Test-ShouldReject "_l11_dup_neg.nova"      "exported by two modules"
# ORM compile-time column verification (E1013): the struct IS the schema, so a mistyped column in a
# typed ORM read is caught at COMPILE time with no database. Two typo classes are covered because plain
# edit distance scores a TRANSPOSITION as 2, so an edit-distance-1 test alone would miss the commonest one.
Test-ShouldReject "_negty_ormcol.nova"     "does not exist on struct"
Test-ShouldReject "_negty_ormcol2.nova"    "does not exist on struct"
Test-ShouldReject "_negty_sizedrange.nova" "out of range"
Test-ShouldReject "_negty_traitconf.nova"  "does not fully implement"

# Previously-orphaned negative tests reclaimed from the *_test.nova sweep (CORE_GAP 7.3): real programs
# the compiler MUST reject. These broaden soundness coverage beyond the _negty_* minimal repros.
Test-ShouldReject "trait_bounds_fail_test.nova"   "does not implement trait"
Test-ShouldReject "trait_unknown_test.nova"       "unknown trait"
Test-ShouldReject "ffi_unsafe_required_test.nova" "requires an enclosing 'unsafe'"
Test-ShouldReject "multi_error_test.nova"         "expected"

# L1 declarative-multiplier contract diagnostics (audit fixes): @test must be `() -> bool`; a routing
# annotation must carry a string path. Wrong programs MUST be rejected, not silently mis-run.
Test-ShouldReject "_atest_voidneg2.nova"    "must return bool"
Test-ShouldReject "_atest_paramneg.nova"    "must take no parameters"
Test-ShouldReject "_aroute_nopath_neg.nova" "requires a string path"

# Batch-1 Wave-A soundness negatives (LOCK-3 trait signature conformance + enum payload typing).
Test-ShouldReject "_trait_sig_bad_ret_test.nova"   "incompatible method signature"
Test-ShouldReject "_trait_sig_bad_param_test.nova" "incompatible method signature"
Test-ShouldReject "_enum_payload_bad_test.nova"    "type mismatch"

# CROSS-MODULE exhaustiveness (Phase 1.1). `_negty_exhaustive.nova` above only ever proved the
# SAME-FILE case: the TI import scan processed `mtag=="fn"` and nothing else, so an IMPORTED enum
# never populated ti_enum_variants/ti_variant_enum and E1009 could not fire across the module
# boundary. A missing arm then compiled clean and the match silently yielded "". This is the
# variant of the check that actually guards the module boundary -- keep BOTH.
Test-ShouldReject "_xm_exhaustive_neg.nova"        "non-exhaustive"

# `?` inside a lambda (Phase 1.5). The diagnostic existed but NOTHING gated it -- a refactor of the
# lambda inference path could have dropped it silently and restored the original silent corruption
# (the error struct ends up as a list ELEMENT because `?` returns from the lambda, not the caller).
Test-ShouldReject "_negty_qmark_lambda.nova"        "silently swallows"

# 1.8: defaults must be TRAILING. `f(a, b = 5, c)` used to be accepted, and then `f(1, 2)` bound 2
# to `b` positionally while `c` got a fresh type var no default could fill. Python rejects this at
# def time, C++ at declaration; NOVA now rejects it at fn registration.
Test-ShouldReject "_negty_default_order.nova"       "must come last"

Write-Host ""
Write-Host "Result: $pass passed, $fail failed"
if ($fail -gt 0) { exit 1 } else { exit 0 }
