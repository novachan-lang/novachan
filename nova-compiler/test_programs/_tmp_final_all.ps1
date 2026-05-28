Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
Remove-Item "gen2_new.exe","gen3.exe","gen3.ll","gen4.ll","nova_runtime.c" -Force -ErrorAction SilentlyContinue

# Bootstrap
$cr0 = Invoke-Timed -FilePath (Resolve-Path ".\gen2_move.exe").Path -Arguments "nova_compiler.nova" -TimeoutMs 60000
if ($cr0.ExitCode -ne 0) { Write-Host "STEP1 FAIL"; exit 1 }
Copy-Item "output\nova_runtime.c" "nova_runtime.c" -Force
$lr1 = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o gen2_new.exe nova_compiler.ll nova_runtime.c $NovaLinkFlags" -TimeoutMs 60000
if (!(Test-Path "gen2_new.exe")) { Write-Host "LINK1 FAIL"; exit 1 }

$cr1 = Invoke-Timed -FilePath (Resolve-Path ".\gen2_new.exe").Path -Arguments "nova_compiler.nova" -TimeoutMs 120000
if ($cr1.ExitCode -ne 0) { Write-Host "GEN3 FAIL"; exit 1 }
Move-Item "nova_compiler.ll" "gen3.ll" -Force
$lr2 = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o gen3.exe gen3.ll nova_runtime.c $NovaLinkFlags" -TimeoutMs 60000
if (!(Test-Path "gen3.exe")) { Write-Host "GEN3 LINK FAIL"; exit 1 }

$cr2 = Invoke-Timed -FilePath (Resolve-Path ".\gen3.exe").Path -Arguments "nova_compiler.nova" -TimeoutMs 120000
if ($cr2.ExitCode -ne 0) { Write-Host "GEN4 FAIL"; exit 1 }
Move-Item "nova_compiler.ll" "gen4.ll" -Force

$g3h = (Get-FileHash "gen3.ll" -Algorithm SHA256).Hash
$g4h = (Get-FileHash "gen4.ll" -Algorithm SHA256).Hash
if ($g3h -eq $g4h) {
    Write-Host "BOOTSTRAP CONVERGED"
    Copy-Item "gen3.exe" "gen2_move.exe" -Force
    Write-Host "gen2_move.exe promoted: $((Get-Item gen2_move.exe).Length) bytes"
} else {
    Write-Host "DIVERGED - aborting"
    Remove-Item "gen2_new.exe","gen3.exe","gen3.ll","gen4.ll","nova_runtime.c" -Force -ErrorAction SilentlyContinue
    exit 1
}
Remove-Item "gen2_new.exe","gen3.exe","gen3.ll","gen4.ll" -Force -ErrorAction SilentlyContinue

# Full regression with promoted compiler
$compiler = (Resolve-Path ".\gen2_move.exe").Path
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
$pass = 0; $fail = 0; $skip = 0; $failures = @()
foreach ($t in $regTests) {
    if (!(Test-Path "$t.nova")) { $skip++; continue }
    $cr3 = Invoke-Timed -FilePath $compiler -Arguments "$t.nova" -TimeoutMs 30000
    if ($cr3.ExitCode -ne 0) { $failures += "$t (COMPILE)"; $fail++; continue }
    $lr3 = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o $t.exe $t.ll nova_runtime.c $NovaLinkFlags" -TimeoutMs 30000
    if (!(Test-Path "$t.exe")) { $failures += "$t (LINK)"; $fail++; continue }
    $rr = Invoke-Timed -FilePath (Resolve-Path ".\$t.exe").Path -Arguments "" -TimeoutMs 15000
    if ($rr.ExitCode -ne 0) { $failures += "$t (exit=$($rr.ExitCode))"; $fail++ }
    else { $pass++ }
    Remove-Item "$t.exe","$t.ll" -Force -ErrorAction SilentlyContinue
}
Write-Host "`nRegression: $pass PASS, $fail FAIL, $skip SKIP"
if ($failures.Count -gt 0) {
    Write-Host "Failures:"
    foreach ($f in $failures) { Write-Host "  $f" }
}
Remove-Item "nova_runtime.c" -Force -ErrorAction SilentlyContinue
