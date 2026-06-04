Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"

$compiler = (Resolve-Path "$PSScriptRoot\gen3_test.exe").Path
$runtimeSrc = "$PSScriptRoot\output\nova_runtime.c"

$env:NOVA_T8_DROP = "1"

$tests = @(
    'float_test','while_test','list_test','string_test','for_test',
    'closure_test','combined_test','nested_fn_test',
    'struct_test','struct_advanced_test','struct_mutate_test',
    'match_test','match_advanced_test','higher_order_test',
    'enum_test','range_test','string_methods_test','dict_test',
    'math_test','string_stdlib_test','list_methods_test',
    'type_conv_test','slice_test',
    'defaults_test','in_operator_test','struct_methods_test',
    'generics_test','match_guard_test','trait_test',
    'destructure_test','assert_test','string_index_test',
    'string_iter_test','string_ops_test',
    'list_struct_test','list_struct_loop_test',
    'string_accum_test','string_accum_fn_test',
    'codegen_pattern_test','match_expr_test',
    'map_filter_test','bitwise_test',
    'closure_ir_test','error_test','tiny_test','match_str_test',
    'default_params_test','tuple_test','method_test',
    'math_quick_test','else_sibling_test',
    'mini_struct_test','mini2_test',
    'stdlib_test','mixed_arith_test',
    'shadow_test','json_float_test','nested_float_test','dict_float_test','bool_json_test','nested_bool_test',
    'tensor_churn_test','tensor_boxed_float_test','ai_classify_test','json_decode_float_test',
    'float_list_ops_test',
    'audio_synth_test','render_test','unsafe_test',
    'ffi_strlen_test','ffi_libc_test','ffi_dedupe_test','ffi_link_test','ffi_opaque_test','ffi_out_test','ffi_repr_c_test',
    'prof_test',
    't8_w5_test','t8_w5b_test','t8_w5b_auto','t8_w6_test','t8_w7_test','t8_soundness_test','t8_channel_test','t8_w8_test',
    'track7_stdlib_full_test'
)

$pass = 0; $fail = 0; $skip = 0; $failures = @()

Write-Host "=== W5b DEFAULT-ON REGRESSION (NOVA_T8_DROP=1) ==="
Write-Host "Tests: $($tests.Count)"
Write-Host ""

foreach ($t in $tests) {
    $nova = "$PSScriptRoot\$t.nova"
    $ll   = "$PSScriptRoot\$t.ll"
    $exe  = "$PSScriptRoot\$t.exe"

    if (!(Test-Path $nova)) { $skip++; continue }

    $cr = Invoke-Timed -FilePath $compiler -Arguments "$t.nova" -TimeoutMs 60000 -WorkingDirectory $PSScriptRoot
    if ($cr.TimedOut -or $cr.ExitCode -ne 0) {
        Write-Host "FAIL compile: $t"
        $failures += "$t (COMPILE)"
        $fail++; continue
    }
    if (!(Test-Path $ll)) { Write-Host "FAIL: $t (no .ll)"; $failures += "$t (NO .ll)"; $fail++; continue }

    $extraLibs = ""
    $isWin = $IsWindows -or ($env:OS -eq 'Windows_NT')
    $skipLibs = @()
    if ($isWin) { $skipLibs = @('m','pthread','dl','rt') }
    Get-Content $ll | Where-Object { $_ -match '^; LINK_LIB: (\S+)' } | ForEach-Object {
        $libName = $matches[1]
        if ($skipLibs -notcontains $libName) { $extraLibs += " -l$libName" }
    }

    $extraSrc = ""
    if (Select-String -Path $ll -Pattern '@sqlite3_' -Quiet) {
        $sqliteSrc = "$PSScriptRoot\output\sqlite3.c"
        if (Test-Path $sqliteSrc) { $extraSrc = " `"$sqliteSrc`" -DSQLITE_THREADSAFE=0" }
    }

    $linkArgs = "-O2 -o `"$exe`" `"$ll`" `"$runtimeSrc`"$extraSrc $NovaLinkFlags$extraLibs -D_CRT_SECURE_NO_WARNINGS -w"
    $lr = Invoke-Timed -FilePath $ClangPath -Arguments $linkArgs -TimeoutMs 60000 -WorkingDirectory $PSScriptRoot
    if (!(Test-Path $exe)) {
        Write-Host "FAIL link: $t"
        $failures += "$t (LINK)"
        $fail++
        Remove-Item $ll -Force -ErrorAction SilentlyContinue
        continue
    }

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
    } else {
        Write-Host "PASS $t"
        $pass++
    }
}

$env:NOVA_T8_DROP = ""
Write-Host ""
Write-Host "=== W5b RESULTS: $pass PASS, $fail FAIL, $skip SKIP ==="
if ($failures.Count -gt 0) {
    Write-Host "Failures:"
    foreach ($f in $failures) { Write-Host "  $f" }
}
