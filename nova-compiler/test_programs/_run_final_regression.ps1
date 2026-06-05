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
    'stdlib_test','mixed_arith_test','for_continue_test',
    'shadow_test','json_float_test','nested_float_test','dict_float_test','bool_json_test','nested_bool_test',
    'tensor_churn_test','tensor_boxed_float_test','ai_classify_test','json_decode_float_test',
    'read_bytes_test','float_list_ops_test','udp_test','supervisor_test',
    'audio_synth_test','render_test','gpu_vadd_test','unsafe_test',
    'ffi_strlen_test','ffi_libc_test','ffi_dedupe_test','ffi_link_test','ffi_opaque_test','ffi_out_test','ffi_repr_c_test',
    'prof_test','demo_sqlite_test','demo_http_server_test','demo_forge_test','demo_forge_v2_test',
    'demo_forge_todo_test','demo_cortex_serve_test','demo_pulse_test','demo_mesh_test','demo_sentinel_test',
    'demo_ops_test','demo_reactor_test','demo_prism_test','demo_edge_test','demo_full_stack_test','demo_frameworks_v2_test',
    't8_w5_test','t8_w5b_test','t8_w5b_auto','t8_w6_test','t8_w7_test','t8_soundness_test','t8_channel_test','t8_w8_test'
)

# Track 7 stdlib breadth tests
$track7_tests = @(
    'track7_stdlib_full_test',
    'track7_encoding_test',
    'track7_logging_test',
    'track7_random_test',
    'track7_datetime_test',
    'track7_path_test',
    'track7_collections_lib_test'
)

# Phase 12-14 new tests
$new_tests = @(
    'phase12_wasm_gpu_test',
    'phase13_web_test',
    'phase13_ai_test',
    'phase13_game_test',
    'phase14_stabilize_test'
)

# Phase 9 + domain stdlib modules (sorted_map, regex, crc32, math3d, ecs, etc.)
$domain_tests = @(
    'sorted_map_test',
    'regex_full_test',
    'crc32_test',
    'math3d',
    'ecs',
    'crypto_util',
    'netutil',
    'compress_rle',
    'nn',
    'physics2d',
    'stats',
    'router',
    'validate',
    'coverage_prof_test',
    'linter_test',
    'file_io_test',
    'unicode_math_test',
    'os_test',
    'net_test',
    'bit_ops_test',
    'corex',
    'urlx',
    'csvx',
    'regex_alt_test',
    'collx',
    'bignum',
    'complexnum',
    'rational',
    'setops',
    'strx',
    'basex',
    'matrixx',
    'proptest',
    'getin',
    'prng',
    'uuid',
    'bitset',
    'typed_result_test',
    'result_test',
    'parse_safe_test',
    'q_propagate_test',
    'auto_show_test',
    'auto_json_test',
    'auto_eq_test',
    'idx_set_soundness_test',
    'byteorder_test',
    'dns_test',
    'algx',
    'comprehension_test',
    'type_alias_test',
    'decode_utf8_test',
    'match_result_test',
    'generics_edge_test',
    'intlist_test',
    'with_else_test',
    'atom_test',
    'newtype_test',
    'decimalx',
    'stralgo',
    'combinx',
    'datex',
    'file_handle_test',
    'typed_let_test',
    'graphx',
    'httpx',
    'boxeq_test',
    'tablex',
    'floatmath_test',
    'litbox_test',
    'jsonfloat_rt_test',
    'structser_test',
    'resulteq_test',
    'jsonunicode_test',
    'copyboxsafety_test',
    'strslicechars_test',
    'jsonprec_test',
    'multiclause_test',
    'variadics_test',
    'scanx',
    'parsex',
    'intfloat_mixed_test',
    'searchx',
    'actorx',
    'supx',
    'optional_test',
    'lockx',
    'cmapx',
    'mailx',
    'logx',
    'cryptorand',
    'durx',
    'clockx',
    'textblock_test',
    'multigen_test',
    'dictcomp_test',
    'ptestx',
    'fnval_test',
    'mmap_test',
    'offheap_test',
    'atomicx_test',
    'futurex',
    'nurseryx',
    'webx',
    'seqx',
    'rchanx',
    'osname_test',
    'crash_isolation_test',
    'spawn_assign_body_test',
    'unitsx',
    'supcrash_test',
    'rex',
    'deflatex',
    'bitsx',
    'spanx',
    'pvecx',
    'bfieldx',
    'bindgen',
    'doctestx',
    'atexit_test',
    'typename_test',
    'static_assert_test',
    'vmcast_test',
    'from_json_test',
    'requires_test',
    'floatcast_test',
    'exit_reason_test',
    'mapfbox_test',
    'fiber_test',
    'coro',
    'pipe',
    'graphemex',
    'utctime',
    'term_test'
)

# Concurrency tests — real thread-pool spawn, channels, select, async, parallel map, generators
$concurrency_tests = @(
    'async_test',
    'select_test',
    'select_multi_test',
    'yield_test',
    'parallel_test',
    'bounded_chan_test'
)

$all_tests = $core_tests + $track7_tests + $new_tests + $domain_tests + $concurrency_tests
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

    # Pick up @link("libname") -> '; LINK_LIB: name' comments emitted by the
    # compiler and propagate them to clang as -l<name> flags. On Windows,
    # libm is part of MSVCRT (no m.lib), so skip 'm' there to avoid linker
    # errors — the annotation remains correct documentation + works on Linux.
    $extraLibs = ""
    $isWin = $IsWindows -or ($env:OS -eq 'Windows_NT')
    $skipLibs = @()
    if ($isWin) { $skipLibs = @('m','pthread','dl','rt') }
    Get-Content $ll | Where-Object { $_ -match '^; LINK_LIB: (\S+)' } | ForEach-Object {
        $libName = $matches[1]
        if ($skipLibs -notcontains $libName) { $extraLibs += " -l$libName" }
    }

    # Domain-demo: if the .ll references sqlite3_*, link the amalgamation
    # so the test doesn't depend on a system-wide libsqlite3 install.
    $extraSrc = ""
    if (Select-String -Path $ll -Pattern '@sqlite3_' -Quiet) {
        $sqliteSrc = "$PSScriptRoot\output\sqlite3.c"
        if (Test-Path $sqliteSrc) {
            $extraSrc = " `"$sqliteSrc`" -DSQLITE_THREADSAFE=0"
        }
    }

    # Link
    $linkArgs = "-O2 -o `"$exe`" `"$ll`" `"$runtimeSrc`"$extraSrc $NovaLinkFlags$extraLibs -D_CRT_SECURE_NO_WARNINGS -w"
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
