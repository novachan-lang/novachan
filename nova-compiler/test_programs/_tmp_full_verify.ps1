Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
Copy-Item "output\nova_runtime.c" "nova_runtime.c" -Force
$compiler = (Resolve-Path ".\gen2_move.exe").Path

# Regression suite
$regTests = @(
    "assert_test","bytes_test","closure_test","closure_ir_test","codegen_pattern_test",
    "combined_test","datetime_test","default_params_test","defaults_test",
    "destructure_test","dict_test","dict_iter_test",
    "error_test","float_test","for_test","in_operator_test",
    "io_test","ir_debug_test","ir_diag_test","ir_ifexpr_test","ir_interproc_test",
    "ir_simple_test","ir_stress_test",
    "list_test","list_struct_test","list_struct_loop_test",
    "math_test","map_filter_test","nested_fn_test",
    "range_test","rc_phase2_test","rc_stress_test",
    "regex_test","recursive_data_test",
    "set_test","stdlib_collections_test",
    "string_test","string_ops_test","string_methods_test","string_iter_test",
    "string_index_test","string_accum_test","string_accum_fn_test","string_stdlib_test",
    "struct_test","struct_advanced_test","struct_mutate_test",
    "type_conv_test","while_test"
)
$pass = 0; $fail = 0; $skip = 0
foreach ($t in $regTests) {
    if (!(Test-Path "$t.nova")) { $skip++; continue }
    $cr = Invoke-Timed -FilePath $compiler -Arguments "$t.nova" -TimeoutMs 30000
    if ($cr.ExitCode -ne 0) { Write-Host "FAIL $t : COMPILE"; $fail++; continue }
    $lr = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o $t.exe $t.ll nova_runtime.c $NovaLinkFlags" -TimeoutMs 30000
    if (!(Test-Path "$t.exe")) { Write-Host "FAIL $t : LINK"; $fail++; continue }
    $rr = Invoke-Timed -FilePath (Resolve-Path ".\$t.exe").Path -Arguments "" -TimeoutMs 15000
    if ($rr.ExitCode -ne 0) { Write-Host "FAIL $t : exit=$($rr.ExitCode)"; $fail++ }
    else { $pass++ }
    Remove-Item "$t.exe","$t.ll" -Force -ErrorAction SilentlyContinue
}
Write-Host "`nRegression: $pass PASS, $fail FAIL, $skip SKIP"

# Extended soundness tests
Write-Host "`n=== Extended Soundness ==="
$stests = @{
    "polymorphic_call" = @"
fn first(items) -> string
    return str(items[0])
fn main()
    let r1 = first([42, 99])
    let r2 = first(["hello", "world"])
    assert(r1 == "42", "got: " + r1)
    assert(r2 == "hello", "got: " + r2)
    print("OK: " + r1 + " " + r2)
"@
    "intlist_str_push" = @"
fn main()
    let data = [1, 2, 3]
    push(data, "four")
    let last = data[3]
    assert(last == "four", "got: " + str(last))
    print("OK: " + str(last))
"@
    "generic_identity" = @"
fn identity(x)
    return x
fn main()
    let a = identity(42)
    let b = identity("hello")
    assert(str(a) == "42", "a: " + str(a))
    assert(str(b) == "hello", "b: " + str(b))
    print("OK: " + str(a) + " " + str(b))
"@
    "for_mixed_list" = @"
fn main()
    let items = [10, "hello", 30]
    let out = ""
    for x in items
        out = out + str(x) + "|"
    assert(out == "10|hello|30|", "got: " + out)
    print("OK: " + out)
"@
    "dict_val_str" = @"
fn main()
    let d = {"name": "nova", "version": "1"}
    let v = d["name"]
    assert(str(v) == "nova", "got: " + str(v))
    print("OK: " + str(v))
"@
    "nested_container" = @"
fn get_item(items, idx) -> string
    return str(items[idx])
fn main()
    let mixed = [42, "hello", 99, "world"]
    let r0 = get_item(mixed, 0)
    let r1 = get_item(mixed, 1)
    assert(r0 == "42", "r0: " + r0)
    assert(r1 == "hello", "r1: " + r1)
    print("OK: " + r0 + " " + r1)
"@
    "generic_fn_chain" = @"
fn wrap(x)
    return x
fn process(x) -> string
    return str(wrap(x))
fn main()
    let a = process(42)
    let b = process("hello")
    assert(a == "42", "a: " + a)
    assert(b == "hello", "b: " + b)
    print("OK: " + a + " " + b)
"@
    "list_of_lists" = @"
fn main()
    let matrix = [[1, 2], [3, 4]]
    let row = matrix[0]
    let val = row[1]
    assert(val == 2, "got: " + str(val))
    print("OK: " + str(val))
"@
}
$sp = 0; $sf = 0
foreach ($name in $stests.Keys) {
    Set-Content "$name.nova" $stests[$name]
    $cr = Invoke-Timed -FilePath $compiler -Arguments "$name.nova" -TimeoutMs 30000
    if ($cr.ExitCode -ne 0) { Write-Host "FAIL $name : compile"; $sf++; Remove-Item "$name.nova" -Force -ErrorAction SilentlyContinue; continue }
    $lr = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o $name.exe $name.ll nova_runtime.c $NovaLinkFlags" -TimeoutMs 30000
    if (!(Test-Path "$name.exe")) { Write-Host "FAIL $name : link"; $sf++; Remove-Item "$name.nova","$name.ll" -Force -ErrorAction SilentlyContinue; continue }
    $rr = Invoke-Timed -FilePath (Resolve-Path ".\$name.exe").Path -Arguments "" -TimeoutMs 10000
    if ($rr.ExitCode -ne 0) {
        Write-Host "FAIL $name : exit=$($rr.ExitCode) out=$($rr.StdOut)"
        $sf++
    } else {
        Write-Host "PASS $name : $($rr.StdOut.Trim())"
        $sp++
    }
    Remove-Item "$name.nova","$name.ll","$name.exe" -Force -ErrorAction SilentlyContinue
}
Write-Host "`nSoundness: $sp PASS, $sf FAIL"
Remove-Item "nova_runtime.c" -Force -ErrorAction SilentlyContinue
