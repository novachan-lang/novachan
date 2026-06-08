. ./_proc_util.ps1

$tests = @(
  'float_test','while_test','list_test','string_test','for_test','closure_test',
  'combined_test','struct_test','match_test','enum_test','range_test',
  'dict_test','math_test','type_conv_test','slice_test','defaults_test',
  'in_operator_test','struct_methods_test','match_guard_test','trait_test',
  'destructure_test','assert_test','string_index_test','match_expr_test',
  'map_filter_test','bitwise_test','regex_test','bytes_test','closure_ir_test',
  'import_multi_test','error_test','tco_test','enum_full_test',
  'for_else_test','spread_test','for_destructure_test','for_guard_test',
  'unless_until_test','operator_repeat_test','items_test','dict_iter_test'
)

$pass = 0; $fail = 0; $failNames = @()
foreach ($t in $tests) {
    $nova = "$t.nova"
    $ll = "$t.ll"
    $exe = "$t.exe"
    Remove-Item $ll -ErrorAction SilentlyContinue
    $cr = Invoke-Timed -FilePath './gen3_test.exe' -Arguments $nova -TimeoutMs 120000 -WorkingDirectory '.'
    if ($cr.ExitCode -ne 0) { $fail++; $failNames += "$t(compile)"; continue }
    $lr = Invoke-Timed -FilePath 'clang' -Arguments "$ll output/nova_runtime.o -o $exe -O2 -lws2_32 -ladvapi32" -TimeoutMs 60000 -WorkingDirectory '.'
    if ($lr.ExitCode -ne 0) { $fail++; $failNames += "$t(link)"; continue }
    $rr = Invoke-Timed -FilePath "./$exe" -Arguments '' -TimeoutMs 15000 -WorkingDirectory '.'
    if ($rr.TimedOut) { $fail++; $failNames += "$t(timeout)" }
    elseif ($rr.ExitCode -ne 0) { $fail++; $failNames += "$t(exit=$($rr.ExitCode))" }
    elseif ($rr.StdErr -match 'FAIL') { $fail++; $failNames += "$t(stderr-FAIL)" }
    else { $pass++ }
}

Write-Host "PASS: $pass / $($pass+$fail)"
if ($fail -gt 0) { Write-Host "FAILED: $($failNames -join ', ')" }
