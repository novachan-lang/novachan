Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
Copy-Item "output\nova_runtime.c" "nova_runtime.c" -Force

$compiler = ".\nova.exe"
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
    "reflect_test", "retroactive_test", "trans_dep_test"
)

foreach ($test in $tests) {
    if (!(Test-Path "$test.nova")) { $skip++; continue }
    $cr = Invoke-Timed -FilePath (Resolve-Path $compiler).Path -Arguments "$test.nova" -TimeoutMs 30000
    if ($cr.ExitCode -ne 0 -or !(Test-Path "$test.ll")) {
        Write-Host "FAIL compile: $test (exit=$($cr.ExitCode))"
        $fail++
        continue
    }
    & clang -o "$test.exe" "$test.ll" output\nova_runtime.o -lws2_32 -ladvapi32 -O2 2>&1 | Out-Null
    if ($LASTEXITCODE -ne 0) {
        Write-Host "FAIL link: $test"
        $fail++
        continue
    }
    $rr = Invoke-Timed -FilePath (Resolve-Path "$test.exe").Path -TimeoutMs 10000
    if ($rr.ExitCode -ne 0) {
        Write-Host "FAIL run: $test (exit=$($rr.ExitCode))"
        $fail++
    } else {
        $pass++
    }
}
Write-Host "`nRESULT: $pass pass, $fail fail, $skip skip / $($tests.Count) total"
