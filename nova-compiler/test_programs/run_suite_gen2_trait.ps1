Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"

Copy-Item "output\nova_runtime.c" "nova_runtime.c" -Force

$compiler = ".\gen2_trait.exe"
$compilerPath = (Resolve-Path $compiler).Path
Write-Host "Using compiler: $compiler ($((Get-Item $compiler).Length) bytes)"

$tests = @(
    "float_test", "while_test", "list_test", "string_test", "for_test",
    "closure_test", "escaping_closure_test", "combined_test", "nested_fn_test",
    "struct_test", "struct_advanced_test", "struct_mutate_test", "interp_test",
    "match_test", "match_advanced_test", "higher_order_test", "enum_test",
    "range_test", "string_methods_test", "dict_test", "math_test",
    "string_stdlib_test", "type_conv_test",
    "spawn_test", "spawn_multi_test", "spawn_fanin_test", "spawn_capture_test",
    "spawn_bidir_test", "spawn_compute_test",
    "close_test", "monitor_test", "select_test", "select_multi_test", "monitor_multi_test",
    "rc_phase2_test", "rc_stress_test", "dict_iter_test",
    "slice_test", "defaults_test", "in_operator_test",
    "match_guard_test", "assert_test", "string_index_test", "string_iter_test",
    "string_ops_test", "recursive_data_test", "list_struct_test", "list_struct_loop_test",
    "string_accum_test", "string_accum_fn_test", "codegen_pattern_test",
    "match_expr_test", "mini_parser_test", "map_filter_test",
    "closure_ir_test", "interp_in_test", "error_test",
    "match_str_test", "default_params_test", "tuple_test", "method_test", "math_quick_test",
    "bitwise_test", "list_methods_test", "map_filter_test",
    "yield_test", "struct_methods_test", "trait_test", "enum_full_test", "generic_test",
    "ownership_test"
)
$pass = 0; $fail = 0; $timeout = 0
foreach ($t in $tests) {
    if (Test-Path "$t.ll")  { Remove-Item "$t.ll"  -Force -ErrorAction SilentlyContinue }
    if (Test-Path "$t.exe") { Remove-Item "$t.exe" -Force -ErrorAction SilentlyContinue }

    # Compile — kills the compiler if it hangs (this was the 2026-05-22 failure).
    $cr = Invoke-Timed -FilePath $compilerPath -Arguments "$t.nova" -TimeoutMs 30000
    if ($cr.TimedOut) { Write-Host "TIMEOUT(compile) $t"; $timeout++; continue }
    if (!(Test-Path "$t.ll")) { Write-Host "FAIL(compile) $t"; $fail++; continue }

    # Link
    $lr = Invoke-Timed -FilePath $ClangPath `
                       -Arguments "-O2 -o $t.exe $t.ll nova_runtime.c -lws2_32" -TimeoutMs 60000
    if ($lr.TimedOut) { Write-Host "TIMEOUT(link) $t"; $timeout++; continue }
    if (!(Test-Path "$t.exe")) { Write-Host "FAIL(link) $t"; $fail++; continue }

    # Run
    $rr = Invoke-Timed -FilePath (Resolve-Path ".\$t.exe").Path -Arguments "" -TimeoutMs 10000
    if ($rr.TimedOut) { Write-Host "TIMEOUT(run) $t"; $timeout++; continue }
    if ($rr.ExitCode -ne 0) { Write-Host "FAIL(exit=$($rr.ExitCode)) $t"; $fail++; continue }
    Write-Host "PASS $t"; $pass++

    Remove-Item "$t.ll"  -Force -ErrorAction SilentlyContinue
    Remove-Item "$t.exe" -Force -ErrorAction SilentlyContinue
}
Write-Host "---"
Write-Host "PASS: $pass / $($tests.Count)  FAIL: $fail  TIMEOUT: $timeout"
Remove-Item "nova_runtime.c" -Force -ErrorAction SilentlyContinue
