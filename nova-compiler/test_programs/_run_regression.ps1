Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
Copy-Item "output\nova_runtime.c" "nova_runtime.c" -Force
$compiler = ".\gen2_move.exe"
$pass = 0
$fail = 0
$skip = 0

$tests = @(
    "float_test", "while_test", "list_test", "string_test", "for_test",
    "closure_test", "combined_test", "nested_fn_test",
    "struct_test", "struct_advanced_test", "struct_mutate_test",
    "match_test", "match_advanced_test", "higher_order_test",
    "enum_test", "range_test", "string_methods_test", "dict_test",
    "math_test", "string_stdlib_test", "list_methods_test",
    "type_conv_test", "spawn_test", "close_test",
    "rc_phase2_test", "dict_iter_test", "slice_test",
    "defaults_test", "in_operator_test", "struct_methods_test",
    "generics_test", "match_guard_test", "trait_test",
    "destructure_test", "assert_test", "string_index_test",
    "string_iter_test", "string_ops_test",
    "list_struct_test", "list_struct_loop_test",
    "string_accum_test", "string_accum_fn_test",
    "codegen_pattern_test", "match_expr_test",
    "map_filter_test", "bitwise_test",
    "yield_test", "closure_ir_test",
    "error_test", "tiny_test", "match_str_test",
    "default_params_test", "tuple_test", "method_test",
    "math_quick_test", "else_sibling_test",
    "mini_struct_test", "mini2_test",
    "stdlib_test", "mixed_arith_test"
)

foreach ($test in $tests) {
    if (!(Test-Path "$test.nova")) { $skip++; continue }
    $cr = Invoke-Timed -FilePath (Resolve-Path $compiler).Path -Arguments "$test.nova" -TimeoutMs 30000
    if ($cr.ExitCode -ne 0 -or !(Test-Path "$test.ll")) {
        Write-Host "FAIL compile: $test (exit=$($cr.ExitCode))"
        $fail++
        continue
    }
    $lr = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o $test.exe $test.ll nova_runtime.c $NovaLinkFlags" -TimeoutMs 60000
    if (!(Test-Path "$test.exe")) {
        Write-Host "FAIL link: $test"
        $fail++
        Remove-Item "$test.ll" -Force -ErrorAction SilentlyContinue
        continue
    }
    $rr = Invoke-Timed -FilePath (Resolve-Path ".\$test.exe").Path -Arguments "" -TimeoutMs 10000
    if ($rr.ExitCode -ne 0) {
        Write-Host "FAIL run: $test (exit=$($rr.ExitCode))"
        $fail++
    } else {
        $pass++
    }
    Remove-Item "$test.ll","$test.exe" -Force -ErrorAction SilentlyContinue
}
Remove-Item "nova_runtime.c" -Force -ErrorAction SilentlyContinue
Write-Host ""
Write-Host "Results: $pass PASS, $fail FAIL, $skip SKIP"
