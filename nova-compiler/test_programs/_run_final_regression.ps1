Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"

$compiler = (Resolve-Path "$PSScriptRoot\gen3_test.exe").Path
$runtimeSrc = "$PSScriptRoot\output\nova_runtime.c"

# Core language regression tests
$core_tests = @(
    'float_test','while_test','list_test','string_test','for_test',
    'closure_test','combined_test','nested_fn_test',
    'struct_test','struct_advanced_test','struct_mutate_test',
    'match_test','match_advanced_test','higher_order_test',
    'enum_test','range_test','string_methods_test','dict_test',
    'math_test','string_stdlib_test','list_methods_test',
    'type_conv_test','spawn_test','close_test',
    'rc_phase2_test','dict_iter_test','slice_test',
    'defaults_test','in_operator_test','struct_methods_test',
    'generics_test','match_guard_test','trait_test',
    'destructure_test','assert_test','string_index_test',
    'string_iter_test','string_ops_test',
    'list_struct_test','list_struct_loop_test',
    'string_accum_test','string_accum_fn_test',
    'codegen_pattern_test','match_expr_test',
    'map_filter_test','bitwise_test',
    'yield_test','closure_ir_test',
    'error_test','tiny_test','match_str_test',
    'default_params_test','tuple_test','method_test',
    'math_quick_test','else_sibling_test',
    'mini_struct_test','mini2_test',
    'stdlib_test','mixed_arith_test'
)

# Phase 12-14 new tests
$new_tests = @(
    'phase12_wasm_gpu_test',
    'phase13_web_test',
    'phase13_ai_test',
    'phase13_game_test',
    'phase14_stabilize_test'
)

$all_tests = $core_tests + $new_tests
$pass = 0; $fail = 0; $skip = 0; $failures = @()

Write-Host "=== NOVA Full Regression Suite (gen3_test = gen11_phase13) ==="
Write-Host "Compiler: $compiler ($((Get-Item $compiler).Length) bytes)"
Write-Host "Tests: $($all_tests.Count) total"
Write-Host ""

foreach ($t in $all_tests) {
    $nova = "$PSScriptRoot\$t.nova"
    $ll   = "$PSScriptRoot\$t.ll"
    $exe  = "$PSScriptRoot\$t.exe"

    if (!(Test-Path $nova)) { $skip++; continue }

    # Compile
    $cr = Invoke-Timed -FilePath $compiler -Arguments "$t.nova" -TimeoutMs 60000 -WorkingDirectory $PSScriptRoot
    if ($cr.TimedOut -or $cr.ExitCode -ne 0) {
        Write-Host "FAIL compile: $t  (exit=$($cr.ExitCode))"
        $failures += "$t (COMPILE)"
        $fail++; continue
    }
    if (!(Test-Path $ll)) {
        Write-Host "FAIL compile: $t  (no .ll produced)"
        $failures += "$t (NO .ll)"
        $fail++; continue
    }

    # Link
    $linkArgs = "-O2 -o `"$exe`" `"$ll`" `"$runtimeSrc`" $NovaLinkFlags -D_CRT_SECURE_NO_WARNINGS -w"
    $lr = Invoke-Timed -FilePath $ClangPath -Arguments $linkArgs -TimeoutMs 60000 -WorkingDirectory $PSScriptRoot
    if (!(Test-Path $exe)) {
        Write-Host "FAIL link: $t"
        $failures += "$t (LINK)"
        $fail++
        Remove-Item $ll -Force -ErrorAction SilentlyContinue
        continue
    }

    # Run
    $rr = Invoke-Timed -FilePath $exe -Arguments '' -TimeoutMs 15000 -WorkingDirectory $PSScriptRoot
    Remove-Item $exe,$ll -Force -ErrorAction SilentlyContinue

    if ($rr.TimedOut) {
        Write-Host "FAIL timeout: $t"
        $failures += "$t (TIMEOUT)"
        $fail++
    } elseif ($rr.ExitCode -ne 0) {
        Write-Host "FAIL run: $t  (exit=$($rr.ExitCode))"
        $failures += "$t (RUN exit=$($rr.ExitCode))"
        $fail++
    } elseif ($rr.StdErr -match 'FAIL assert') {
        $preview = $rr.StdErr.Trim().Substring(0, [Math]::Min(120, $rr.StdErr.Trim().Length))
        Write-Host "FAIL assert: $t  -- $preview"
        $failures += "$t (ASSERT FAIL)"
        $fail++
    } else {
        Write-Host "PASS $t"
        $pass++
    }
}

Write-Host ""
Write-Host "=== RESULTS: $pass PASS, $fail FAIL, $skip SKIP (of $($all_tests.Count) total) ==="
if ($failures.Count -gt 0) {
    Write-Host ""
    Write-Host "Failures:"
    foreach ($f in $failures) { Write-Host "  $f" }
}
if ($fail -gt 0) { exit 1 }
