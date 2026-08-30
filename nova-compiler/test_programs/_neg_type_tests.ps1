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

# PARSER ERROR RECOVERY. Rejection alone is NOT the property under test here -- the broken version
# also "rejected". What regressed was the error COUNT: one malformed match arm used to desynchronise
# the token stream and get the remainder of the file parsed as that arm's body, so a single mistake
# on line 3 produced a cascade of errors pointing at innocent code (~85% of a 700-line file). This
# asserts the exact count, because "it errors" would pass even with the cascade fully restored.
function Test-ErrorCount {
    param([string]$file, [string]$expected_err_frag, [int]$want_errors)
    $r = Invoke-Timed -FilePath (Resolve-Path $compiler).Path -Arguments $file -TimeoutMs 30000
    if ($r.TimedOut) { Write-Host "  TIMEOUT $file  => BUG"; $script:fail++; return }
    $all = "$($r.Stdout)$($r.Stderr)"
    $n = ([regex]::Matches($all, 'error\[')).Count
    if ($r.ExitCode -eq 0) { Write-Host "  FAIL $file  accepted when it should have been rejected"; $script:fail++; return }
    if ($all -notmatch [regex]::Escape($expected_err_frag)) {
        Write-Host "  FAIL $file  rejected but expected '$expected_err_frag' not in output"; $script:fail++; return
    }
    if ($n -ne $want_errors) {
        Write-Host "  FAIL $file  emitted $n error(s), want exactly $want_errors -- the parse-state CASCADE is back"
        $script:fail++; return
    }
    Write-Host "  PASS $file  exactly $n error, no cascade"
    $script:pass++
}

# The positive half. It must LINK AND RUN, not merely compile.
#
# ⛔ A COMPILE-ONLY CHECK WOULD NOT HAVE CAUGHT THE REGRESSION THIS GUARDS. An earlier version of
# the missing-`=>` diagnostic errored on the legal block-body arm form, resynced to the next
# top-level statement and silently truncated the enclosing function. The compiler still exited 0
# and still wrote a .ll -- the damage only appeared when clang rejected the IR with
# `use of undefined value '%while_body3281'`. Worse, reconverge stayed byte-identical, because the
# compiler still compiled ITSELF correctly; it only miscompiled OTHER programs. Exit code and
# fixpoint were both green while codegen was broken, so the only assertion with teeth is to build
# the program the whole way and run it.
function Test-ShouldAccept {
    param([string]$file)
    $stem = [System.IO.Path]::GetFileNameWithoutExtension($file)
    Remove-Item "$stem.ll", "_pos_$stem.exe" -Force -ErrorAction SilentlyContinue
    $r = Invoke-Timed -FilePath (Resolve-Path $compiler).Path -Arguments $file -TimeoutMs 60000
    if ($r.TimedOut) { Write-Host "  TIMEOUT $file"; $script:fail++; return }
    if ($r.ExitCode -ne 0) {
        Write-Host "  FAIL $file  REJECTED a valid program (exit=$($r.ExitCode))"
        Write-Host "    $((($r.Stdout + $r.Stderr) -split "`n" | Where-Object { $_ -match '^error' } | Select-Object -First 2) -join ' | ')"
        $script:fail++; return
    }
    if (-not (Test-Path "$stem.ll")) { Write-Host "  FAIL $file  compiled but produced no IR"; $script:fail++; return }
    $lk = & clang -O1 -o "_pos_$stem.exe" "$stem.ll" "..\compiler\nova_runtime.c" -lws2_32 -ladvapi32 -w 2>&1
    if (-not (Test-Path "_pos_$stem.exe")) {
        $le = ($lk | Where-Object { $_ -match 'error:' } | Select-Object -First 1)
        Write-Host "  FAIL $file  compiled (exit 0) but emitted INVALID IR -- $le"
        $script:fail++
        Remove-Item "$stem.ll" -Force -ErrorAction SilentlyContinue
        return
    }
    $run = Invoke-Timed -FilePath (Resolve-Path "_pos_$stem.exe").Path -Arguments "" -TimeoutMs 30000
    Remove-Item "$stem.ll", "_pos_$stem.exe" -Force -ErrorAction SilentlyContinue
    if ($run.TimedOut -or $run.ExitCode -ne 0) {
        Write-Host "  FAIL $file  built but did not run clean (exit=$($run.ExitCode) timedout=$($run.TimedOut))"
        $script:fail++; return
    }
    Write-Host "  PASS $file  compiles, links and runs"
    $script:pass++
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

# 2.9: NESTED-pattern exhaustiveness. 2.1 made nested ctor patterns work at runtime, but the
# exhaustiveness check remained OUTER-level only -- Wrap(IntVal(n)) + Empty() names both Outer
# variants so it passed, while a Wrap(StrVal(...)) value matched no arm and fell through to "".
# Adding a feature had added a soundness hole; this is the check that closes it.
Test-ShouldReject "_negty_nested_exhaustive.nova"  "non-exhaustive nested match"

# PARSE-STATE CASCADE (WEAPON_PARITY 5.6 follow-up). `match true` with comparison arms is NOT valid
# NOVA -- a comparison is not a pattern -- and rejecting it is correct. The DEFECT was that the
# statement form checked `if tk == FAT_ARROW` with NO else, so a missing `=>` fell through silently
# and the rest of the file became the arm's body. parse_match_expr was always right (it used
# expect()); only parse_match_stmt and parse_receive_stmt were missing it.
Write-Host ""
Write-Host "=== Parser error recovery (no parse-state cascade) ==="
Test-ErrorCount "_mtrue_repro.nova" "a comparison is not a pattern in a match arm" 1
# Both legal forms the diagnostic must NOT touch: the documented guard, and the block-body arm
# whose pattern line carries no `=>` at all. The second one is the form the first attempt broke.
Test-ShouldAccept "_mt_guard_probe.nova"
Test-ShouldAccept "_mt_block_probe.nova"

# 3.1 POLYFIELD (WEAPON_PARITY 3.1) — was a KNOWN GAP that printed a wrong number for five
# attempts. An address-taken function reached through a __fnref_ trampoline was specialized to the
# ONE argument type its visible direct call passed, so the other caller's field was read through
# the wrong type label. Asserts BOTH call paths, because every partial fix so far got exactly one
# of them right: parts 1+2 alone made the closure call correct and the DIRECT call print
# 4609434218613702656 (the bits of 1.5 as an integer). One assertion would have looked like success.
Write-Host ""
Write-Host "=== 3.1 polyfield (address-taken fn + raw float field) ==="
Test-ShouldAccept "_f31_polyfield_known_gap.nova"

Write-Host ""
Write-Host "Result: $pass passed, $fail failed"
if ($fail -gt 0) { exit 1 } else { exit 0 }
