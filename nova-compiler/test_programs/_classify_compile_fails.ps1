$dir = $PSScriptRoot
$tests = @(
    "alloc_bench", "datetime", "diag_fstring4",
    "distributed_channel_test", "distributed_serialize_test", "distributed_spawn_test",
    "doc_sample", "err_catch", "err_garbage", "err_generic", "err_listarg",
    "err_match", "err_return", "err_syntax", "err_type", "err_undef",
    "ffi_unsafe_required_test", "forward_type_err_test", "http_test",
    "ir_debug_tokenizer", "multi_error_test", "nova_ir_test2",
    "test_dict_only", "test_minimal_ti", "test_pkg_get", "test_pkg_get3",
    "test_return_context", "test_spawn_call", "test_spawn_multi", "test_typo",
    "tiny3", "tiny6", "tiny7",
    "trait_bounds_fail_test", "trait_conformance_test", "trait_unknown_test"
)

foreach ($t in $tests) {
    $f = "$dir\$t.nova"
    if (-not (Test-Path $f)) { Write-Host "MISSING: $t"; continue }
    $line1 = (Get-Content $f -TotalCount 3) -join " "
    $hasError = $line1 -match 'error|Error|invalid|intentional|should fail|negative|bad|broken|syntax error'
    $hasImport = $line1 -match 'import'
    Write-Host "$t | first: $($line1.Substring(0, [Math]::Min(80, $line1.Length))) | error_hint=$hasError import=$hasImport"
}
