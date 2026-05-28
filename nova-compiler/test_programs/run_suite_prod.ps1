Set-Location $PSScriptRoot
Copy-Item "output\nova_runtime.c" "nova_runtime.c" -Force

$compiler = ".\gen1_final_ipt.exe"
Write-Host "Using production compiler: $compiler ($((Get-Item $compiler).Length) bytes)"

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
    "yield_test", "struct_methods_test"
)
$pass = 0; $fail = 0; $timeout = 0
foreach ($t in $tests) {
    if (Test-Path "$t.ll") { Remove-Item "$t.ll" -Force }
    $p = Start-Process -FilePath $compiler -ArgumentList "$t.nova" -WorkingDirectory $PSScriptRoot -RedirectStandardOutput "${t}_cout.txt" -RedirectStandardError "${t}_cerr.txt" -PassThru -NoNewWindow
    $p.WaitForExit(30000) | Out-Null
    if (!(Test-Path "$t.ll")) { Write-Host "FAIL(compile) $t"; $fail++; continue }
    $p2 = Start-Process -FilePath "clang" -ArgumentList "-O2 -o $t.exe $t.ll nova_runtime.c -lws2_32" -WorkingDirectory $PSScriptRoot -RedirectStandardOutput "nul" -RedirectStandardError "${t}_link_err.txt" -PassThru -NoNewWindow
    $p2.WaitForExit(30000) | Out-Null
    if (!(Test-Path "$t.exe")) { Write-Host "FAIL(link) $t"; $fail++; continue }
    $psi = New-Object System.Diagnostics.ProcessStartInfo
    $psi.FileName = (Resolve-Path ".\$t.exe").Path
    $psi.UseShellExecute = $false
    $psi.RedirectStandardOutput = $true
    $psi.RedirectStandardError = $true
    $psi.CreateNoWindow = $true
    $proc = [System.Diagnostics.Process]::Start($psi)
    $stdout = $proc.StandardOutput.ReadToEndAsync()
    $stderr = $proc.StandardError.ReadToEndAsync()
    $done = $proc.WaitForExit(5000)
    if (!$done) { try { $proc.Kill() } catch {}; Write-Host "TIMEOUT $t"; $timeout++; continue }
    if ($proc.ExitCode -ne 0) { Write-Host "FAIL(exit=$($proc.ExitCode)) $t"; $fail++; continue }
    Write-Host "PASS $t"; $pass++
}
Write-Host "---"
Write-Host "PASS: $pass / $($tests.Count)  FAIL: $fail  TIMEOUT: $timeout"
Remove-Item "nova_runtime.c" -Force -ErrorAction SilentlyContinue
