Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"

$env:NOVA_NO_CACHE = "1"
$compilerName = if ($env:NOVA_REGRESSION_COMPILER) { $env:NOVA_REGRESSION_COMPILER } else { "gen3_test.exe" }
$compiler = (Resolve-Path "$PSScriptRoot\$compilerName").Path
$runtimeSrc = "$PSScriptRoot\output\nova_runtime.c"
$runtimeObj = "$PSScriptRoot\nova_runtime_test.o"
$sqliteSrc  = "$PSScriptRoot\output\sqlite3.c"

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
    'normx_test',
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
    'set_comp_test',
    'remote_test',
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
    'must_use_test',
    'argparsex',
    'edistx',
    'semverx',
    'logfmtx',
    'envx',
    'ratex',
    'dotenvx',
    'cronx',
    'markdownx',
    'jwtx',
    'migrationx',
    'circuitx',
    'poolx',
    'retryx',
    'healthx',
    'metrx',
    'validx',
    'slugx',
    'paginx',
    'maskx',
    'ciphx',
    'intervx',
    'hashx',
    'resultx',
    'iterx',
    'configx',
    'treex',
    'mathn',
    'linkx',
    'formatx',
    'assertx',
    'linkx2',
    'mimesx',
    'httpclx',
    'samplex',
    'queuex',
    'pathx',
    'embedx',
    'authx',
    'schemax',
    'hexdumpx',
    'crcx',
    'ringx',
    'mathfx',
    'tsvx',
    'bitmapx',
    'pubsubx',
    'ipx',
    'permutx',
    'debounx',
    'encodex',
    'priorityx',
    'kvstorex',
    'sanitx',
    'stacktracex',
    'regtryx',
    'datefmtx',
    'memox',
    'routerx',
    'workerx',
    'tokenx',
    'matbuilderx',
    'pluralx',
    'fifolifox',
    'geox',
    'safemathx',
    'lrucachex',
    'buildx',
    'streakx',
    'emailx',
    'opx',
    'bstx',
    'phonex',
    'colorconvx',
    'httpstatusx',
    'numfmtx',
    'uuidx',
    'rlimitx',
    'taskqx',
    'jsonqueryx',
    'chanx',
    'color256x',
    'setx',
    'progressx',
    'netaddrx',
    'rulengx',
    'benchx',
    'aggx',
    'proc_pipe_test',
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
    'field_names_test',
    'sroa_stress_test',
    'mn_stress_test',
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
    'term_test',
    'dirwatch',
    'propx',
    'fiber_nested_test',
    'difx',
    'sched_test',
    'greenx',
    'procx',
    'spix',
    'inix',
    'csvw',
    'green_transparent',
    'green_monitor_test',
    'green_supervisor_test',
    'globx',
    'fuzzx',
    'bloomx',
    'unionx',
    'triex',
    'topox',
    'dijkx',
    'conhashx',
    'kmpx',
    'selectx',
    'fenwickx',
    'dpx',
    'colorx',
    'tmplx',
    'fsmx',
    'backoffx',
    'defer_test',
    'lazy_gen_test',
    'const_test',
    'hot_reload_test',
    'io_poll_test',
    'ws_sched_test',
    'protocol_builtin_test',
    'green_netpoll_test',
    'debugx',
    'real_cli_grep',
    'real_http_api',
    'nova_fmt'
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

$sw = [System.Diagnostics.Stopwatch]::StartNew()
Write-Host "=== NOVA Full Regression Suite ==="
Write-Host "Compiler: $compiler ($((Get-Item $compiler).Length) bytes)"
Write-Host "Tests: $($all_tests.Count) total"

# ─── Step 1: Pre-compile runtime ONCE ───
Write-Host ""
Write-Host "Pre-compiling nova_runtime.c -> nova_runtime_test.o ..."
$rtc = Invoke-Timed -FilePath $ClangPath -Arguments "-c -O2 `"$runtimeSrc`" -o `"$runtimeObj`" -D_CRT_SECURE_NO_WARNINGS -w" -TimeoutMs 120000 -WorkingDirectory $PSScriptRoot
if ($rtc.ExitCode -ne 0 -or !(Test-Path $runtimeObj)) {
    Write-Host "FATAL: runtime pre-compile failed (exit=$($rtc.ExitCode))"
    if ($rtc.StdErr) { Write-Host $rtc.StdErr }
    exit 1
}
Write-Host "Runtime pre-compiled in $([math]::Round($sw.Elapsed.TotalSeconds, 1))s"
Write-Host ""

# ─── Step 2: Parallel test runner ───
$maxParallel = [Math]::Max(2, [Math]::Min(8, [Environment]::ProcessorCount - 2))
Write-Host "Running tests ($maxParallel parallel)..."
Write-Host ""

$testScript = {
    param($testName, $compilerPath, $rtObjPath, $workDir, $clangExe, $lFlags, $sqPath)

    $r = @{ Name = $testName; Status = "PASS"; Detail = "" }

    if (-not (Test-Path "$workDir\$testName.nova")) {
        $r.Status = "SKIP"; return $r
    }

    function _RunProc($fp, $ar, $to, $wd) {
        $pi = New-Object System.Diagnostics.ProcessStartInfo
        $pi.FileName = $fp; $pi.Arguments = $ar; $pi.WorkingDirectory = $wd
        $pi.UseShellExecute = $false
        $pi.RedirectStandardOutput = $true; $pi.RedirectStandardError = $true
        $pi.CreateNoWindow = $true
        $p = [System.Diagnostics.Process]::Start($pi)
        $ot = $p.StandardOutput.ReadToEndAsync()
        $et = $p.StandardError.ReadToEndAsync()
        $ok = $p.WaitForExit($to)
        if (-not $ok) {
            try { $p.Kill() } catch {}
            try { $p.WaitForExit(5000) } catch {}
            return @{ T = $true; X = -1; O = ""; E = "" }
        }
        return @{ T = $false; X = $p.ExitCode; O = $ot.Result; E = $et.Result }
    }

    $ll  = "$workDir\$testName.ll"
    $exe = "$workDir\$testName.exe"

    $cr = _RunProc $compilerPath "$testName.nova" 60000 $workDir
    if ($cr.T -or $cr.X -ne 0) {
        $r.Status = "FAIL"; $r.Detail = "COMPILE exit=$($cr.X)"; return $r
    }
    if (-not (Test-Path $ll)) {
        $r.Status = "FAIL"; $r.Detail = "NO .ll"; return $r
    }

    $xlib = ""
    $skipL = @('m','pthread','dl','rt')
    Get-Content $ll | Where-Object { $_ -match '^; LINK_LIB: (\S+)' } | ForEach-Object {
        if ($skipL -notcontains $matches[1]) { $xlib += " -l$($matches[1])" }
    }
    $xsrc = ""
    if ((Select-String -Path $ll -Pattern '@sqlite3_' -Quiet) -and (Test-Path $sqPath)) {
        $xsrc = " `"$sqPath`" -DSQLITE_THREADSAFE=0"
    }

    $la = "-O2 -o `"$exe`" `"$ll`" `"$rtObjPath`"$xsrc $lFlags$xlib -D_CRT_SECURE_NO_WARNINGS -w"
    $lr = _RunProc $clangExe $la 60000 $workDir
    if (-not (Test-Path $exe)) {
        $r.Status = "FAIL"; $r.Detail = "LINK"
        Remove-Item $ll -Force -ErrorAction SilentlyContinue
        return $r
    }

    $rr = _RunProc $exe "" 15000 $workDir
    Remove-Item $exe,$ll -Force -ErrorAction SilentlyContinue

    if ($rr.T) { $r.Status = "FAIL"; $r.Detail = "TIMEOUT" }
    elseif ($rr.X -ne 0) { $r.Status = "FAIL"; $r.Detail = "RUN exit=$($rr.X)" }
    elseif ($rr.E -match 'FAIL assert') { $r.Status = "FAIL"; $r.Detail = "ASSERT FAIL" }

    return $r
}

$pool = [System.Management.Automation.Runspaces.RunspaceFactory]::CreateRunspacePool(1, $maxParallel)
$pool.Open()

$jobs = New-Object System.Collections.ArrayList
foreach ($t in $all_tests) {
    $ps = [PowerShell]::Create()
    $ps.RunspacePool = $pool
    [void]$ps.AddScript($testScript)
    [void]$ps.AddArgument($t)
    [void]$ps.AddArgument($compiler)
    [void]$ps.AddArgument($runtimeObj)
    [void]$ps.AddArgument($PSScriptRoot)
    [void]$ps.AddArgument($ClangPath)
    [void]$ps.AddArgument($NovaLinkFlags)
    [void]$ps.AddArgument($sqliteSrc)
    $handle = $ps.BeginInvoke()
    [void]$jobs.Add(@{ PS = $ps; Handle = $handle; Name = $t })
}

$pass = 0; $fail = 0; $skip = 0; $failures = @()
foreach ($job in $jobs) {
    try {
        $res = $job.PS.EndInvoke($job.Handle)
        if ($res -and $res.Count -gt 0) { $r = $res[$res.Count - 1] }
        else { $r = @{ Name = $job.Name; Status = "FAIL"; Detail = "NO RESULT" } }
    } catch {
        $r = @{ Name = $job.Name; Status = "FAIL"; Detail = "RUNSPACE ERROR" }
    }

    switch ($r.Status) {
        "PASS" { $pass++; Write-Host "PASS $($r.Name)" }
        "SKIP" { $skip++ }
        default {
            $fail++
            $failures += "$($r.Name) ($($r.Detail))"
            Write-Host "FAIL $($r.Name)  ($($r.Detail))"
        }
    }
    $job.PS.Dispose()
}

$pool.Close()
$pool.Dispose()
Remove-Item $runtimeObj -Force -ErrorAction SilentlyContinue

$sw.Stop()
Write-Host ""
Write-Host "=== RESULTS: $pass PASS, $fail FAIL, $skip SKIP (of $($all_tests.Count) total) ==="
Write-Host "Wall time: $([math]::Round($sw.Elapsed.TotalSeconds, 1))s"
if ($failures.Count -gt 0) {
    Write-Host ""
    Write-Host "Failures:"
    foreach ($f in $failures) { Write-Host "  $f" }
}
if ($fail -gt 0) { exit 1 }
