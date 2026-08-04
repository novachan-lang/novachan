param([switch]$ForgeOnly, [switch]$NoServer)
Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"

$env:NOVA_NO_CACHE = "1"
$compilerName = if ($env:NOVA_REGRESSION_COMPILER) { $env:NOVA_REGRESSION_COMPILER } else { "gen3_test.exe" }
$compiler = (Resolve-Path "$PSScriptRoot\$compilerName").Path
$runtimeSrc = "$PSScriptRoot\..\compiler\nova_runtime.c"
$runtimeObj = "$PSScriptRoot\nova_runtime_test.o"
$sqliteSrc  = "$PSScriptRoot\..\compiler\sqlite3.c"

# Core language regression tests
$core_tests = @(
    'float_test','while_test','list_test','string_test','for_test',
    'closure_test','combined_test','nested_fn_test',
    'struct_test','struct_advanced_test','struct_mutate_test',
    'match_test','match_advanced_test','higher_order_test',
    'enum_test','range_test','string_methods_test','dict_test',
    'math_test','string_stdlib_test','list_methods_test',
    'type_conv_test','spawn_test','close_test','_n1_heapbounds_test','_n1_box_test','_n1_park_test','_n1_reclaim_test','_n1_monitor_race_test','_n1_stale_pid_test','_n1_cap_closure_test','_memo_smoke','_n1_listener_close_test',
    'rc_phase2_test','dict_iter_test','slice_test',
    'defaults_test','in_operator_test','struct_methods_test',
    'generics_test','match_guard_test','trait_test',
    'destructure_test','assert_test','string_index_test',
    'oob_write_test','float_egress_test','float_egress_raw_test','float_int_mix_test','float_param_test','float_array_escape_test','_null_return_canary','_hof_intfloat_canary',
    'string_iter_test','string_ops_test',
    'list_struct_test','list_struct_loop_test',
    'string_accum_test','string_accum_fn_test',
    'codegen_pattern_test','match_expr_test','match_any_module_test','orm_typed_rewrite_test','typedlist_field_slot_test',
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
    '_bytes_identity_test','bytes_socket_test','_bytes_arena_test','forge_binary_serve_test','_bytes_anyops_test','forge_binary_file_test','_bytes_builders_test','forge_multipart_test','_ws_codec_test','forge_ws_echo_test','_ws_soak_test','forge_ws_routing_test','forge_hub_test','forge_ws_chat_test','_spawn_arena_test','forge_sse_test','_timed_park_test','forge_ws_keepalive_test','forge_ws_presence_test','forge_ws_lifecycle_test','forge_chunked_test','forge_range_test','forge_html_test','forge_negotiate_test','forge_conditional_test','forge_flash_test','forge_cache_test','forge_compose_test','forge_hardening_test','forge_security_fixes_test','_move_arena_uaf_test','_panic_arena_test',
    'strx_lib_test','setops_lib_test','getin_lib_test','prng_lib_test','bitset_lib_test','graphemex_lib_test','pvecx_lib_test','coro_lib_test','dframe_lib_test','linalg_lib_test','autograd_lib_test','autograd_train_test','qb_lib_test','optimizers_lib_test','schema_lib_test','ndarray_lib_test','unitext_lib_test','forge_limits_lib_test','forge_connguard_test','otp_lib_test','telemetry_lib_test',
    'audio_synth_test','render_test','gpu_vadd_test','unsafe_test',
    'ffi_strlen_test','ffi_libc_test','ffi_dedupe_test','ffi_link_test','ffi_linksrc_test','ffi_byval_abi_test','ffi_opaque_test','ffi_out_test','ffi_repr_c_test',
    'prof_test','demo_sqlite_test','demo_sqlite_bind_test','sqlitex_test','forge_db_test','forge_typed_db_test','forge_hero_test','demo_forge_crud_test','showcase_taskflow_test','forge_typed_query_test','forge_orm_test','_orm_null_test','_mysql_test','demo_http_server_test','demo_forge_test','demo_forge_v2_test',
    'demo_forge_todo_test','demo_cortex_serve_test','demo_pulse_test','demo_mesh_test','demo_sentinel_test',
    'demo_ops_test','demo_reactor_test','demo_prism_test','demo_edge_test','demo_full_stack_test','demo_frameworks_v2_test',
    't8_w5_test','t8_w5b_test','t8_w5b_auto','t8_w6_test','t8_w7_test','t8_soundness_test','t8_channel_test','t8_w8_test',
    '_truthmodel_test','_hetreturn_test'
)

# Track 7 stdlib breadth tests
$track7_tests = @(
    'track7_stdlib_full_test',
    'track7_encoding_test',
    'track7_logging_test',
    'track7_random_test',
    'track7_datetime_test',
    'track7_path_test',
    'track7_collections_lib_test',
    '_s4_adv_test',
    '_s4_adv_chan_test',
    '_s4_adv_int_test',
    '_s4_escbug_test',
    '_s4_adv_int2_test',
    '_s4_floatarr_test'
)

# Phase 12-14 new tests
$new_tests = @(
    'phase12_wasm_gpu_test',
    'phase13_web_test',
    'phase13_ai_test',
    'phase13_game_test',
    'phase14_stabilize_test',
    '_s5_hof_mono',
    '_s5_byval_test',
    '_s5_escape_canary',
    '_kwfield_test',
    '_fair_sleep_io',
    '_kat_interp_float',
    '_kat_generic_annot',
    '_kat_result_float',
    '_kat_catch',
    '_kat_closure_float',
    '_kat_opt_sugar',
    '_kat_l7_sized',
    '_kat_l7_wrap',
    '_kat_l7_loop',
    '_kat_l7_var'
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
    'otp',
    'telemetry',
    'cluster',
    'dframe',
    'linalg',
    'autograd',
    'optimizers',
    'ndarray',
    'qb',
    'schema',
    'unitext',
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
    'from_json_safety_test',
    'from_json_safe_test',
    'from_json_safe_forge_test',
    'match_result_struct_test',
    'nested_struct_float_test',
    'collection_struct_float_test',
    'form_as_test',
    'auto_eq_test',
    'idx_set_soundness_test',
    'byteorder_test',
    'dns_test',
    'algx',
    'comprehension_test',
    'type_alias_test',
    'decode_utf8_test',
    'normx_test',
    'casefoldx_test',
    'collatex_test',
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
    'rtti_json_test',
    'rtti_any_test',
    'rtti_show_test',
    'forge_keystone_test',
    'cross_import_extern_test',
    'forge_typed_core_test',
    'cross_module_struct_test',
    'tka_xmod_test',
    'forge_typed_dispatch_test',
    'forge_coerce_test',
    'forge_typed_mw_test',
    'forge_static_test',
    'forge_static_symlink_test',
    'forge_http_client_test',
    'forge_resilient_client_test',
    'forge_sse_client_test',
    'forge_ws_client_test',
    'forge_idempotency_test',
    'forge_exporters_test',
    'forge_hpack_test',
    'forge_h2_test',
    'forge_h2_server_test',
    'forge_h2c_test',
    'forge_header_security_test',
    'forge_recv_security_test',
    'forge_routing_correctness_test',
    'forge_keepalive_test',
    'forge_cookie_test',
    'forge_session_test',
    'forge_csrf_test',
    'forge_jwt_test',
    'forge_oauth2_test',
    'forge_ws_join_auth_test',
    'forge_auth_sweep_test',
    '_pbkdf2_native_test',
    'forge_otp_sweep_test',
    'forge_realtime_sweep_test',
    'forge_validate_test',
    'forge_validate_typed_test',
    'forge_gzip_test',
    'forge_openapi_test',
    'forge_resp_model_test',
    'forge_model_route_test',
    'forge_redirect_query_test',
    'forge_pctdecode_test',
    'forge_form_test',
    'forge_etag_test',
    'forge_cors_test',
    'forge_secheaders_test',
    'forge_routing2_test',
    'forge_ops_test',
    'forge_reqid_test',
    'forge_file_test',
    'forge_testsurface_test',
    'forge_ratelimit_test',
    'forge_errors_test',
    'forge_protobuf_test','forge_retry_test','forge_grpc_test','forge_jsonrpc_test','forge_graphql_test',
    'forge_graphql_http_test','forge_jsonrpc_http_test','forge_circuit_test','forge_outbox_test',
    'forge_bulkhead_test','forge_flags_test','forge_discovery_test','forge_saga_test','forge_storage_test',
    'forge_cache_actor_test','forge_query_test','forge_helpers_test','forge_helpers2_test','forge_page_test',
    'forge_mq_dlq_test','forge_ratelimit_actor_test','forge_admin_model_test','forge_orm_hero_test',
    'forge_live_oninfo_test','forge_hpack_huffman_test','forge_hpack_c41_test','forge_grpc_h2_test',
    'forge_accesslog_test',
    'forge_spawn_test',
    'forge_recover_test',
    'forge_group_test',
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
    'remote_multi_test',
    'call_by_name_test',
    'remote_spawn_test',
    'const_bake_test',
    'tensor_matmul_test',
    'tensor_activations_test',
    'tensor_ops_test',
    'mlp_inference_test',
    'wasm_grow_test',
    'int_ptr_soundness_repro',
    'str_identity_test',
    'struct_rc_test',
    'sup_strategies_test',
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
    'deflatex_test',
    'zipx',
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
    '_mailbox_test',
    '_recv_select_test',
    '_recv_heap_probe',
    '_recv_uaf_probe',
    '_recv_nested_test',
    '_recv_timeout_test',
    '_gen_server_demo',
    '_supervised_genserver_demo',
    '_reclaim_churn_test',
    '_mn_stress_test',
    'select_test',
    'select_multi_test',
    'select_timeout_test',
    'try_chan_test',
    'char_class_test',
    'uint_ops_test',
    'ptr_width_test',
    'strx_ops_test',
    'json_oracle_test',
    'yield_test',
    'parallel_test',
    'bounded_chan_test',
    'overflow_recovery_test',
    'deep_copy_depth_test',
    'sort_string_test',
    'leak_baseline_test',
    '_struct_field_leak_test',
    '_closure_capture_leak_test',
    '_struct_arena_masked_test',
    '_struct_alias_field_test',
    '_struct_float_field_test',
    '_struct_enum_payload_test',
    '_struct_field_reassign_test',
    '_struct_field_read_stress_test',
    '_eq_mixed_test',
    '_ord_mixed_test',
    '_listconcat_mixed_test',
    '_alias_swap_leak_test',
    '_floatret_uninit_test',
    'showcase_report_test',
    'showcase_stats_test',
    'showcase_sudoku_test',
    'showcase_parallel_test',
    'showcase_calc_test',
    'showcase_life_test',
    'showcase_graph_test',
    'showcase_hex_test',
    'showcase_bst_test',
    'showcase_rpn_test',
    'showcase_hof_test',
    'showcase_kvstore_test',
    'showcase_date_test',
    'showcase_sieve_test',
    'showcase_vm_test',
    'showcase_mandelbrot_test',
    'auto_reflect_test',
    'json_list_test',
    'list_dict_ops_test',
    'http_offload_test'
)

# CORE_GAP 7.3 — orphan-coverage: previously-unwired *_test.nova feature tests, confirmed clean in BOTH
# NORMAL and FULLRC modes, loaded from a manifest FILE ("one manifest; every test in the gate"). This
# closes the "features regress silently" hole for ~190 core-language features. Data, not code — append
# newly-classified CLEAN orphans to _orphan_coverage_manifest.txt (see _classify_orphans.ps1).
$orphan_manifest = "$PSScriptRoot\_orphan_coverage_manifest.txt"
$orphan_coverage_tests = @()
if (Test-Path $orphan_manifest) {
    $orphan_coverage_tests = @(Get-Content $orphan_manifest | ForEach-Object { $_.Trim() } | Where-Object { $_ -ne "" -and -not $_.StartsWith("#") })
}

$all_tests = @($core_tests + $track7_tests + $new_tests + $domain_tests + $concurrency_tests + $orphan_coverage_tests | Select-Object -Unique)

# Server-binding tests run their OWN in-process green TCP server + client (real I/O). Running
# many concurrently starves the green server's scheduling under CPU load -> intermittent
# failures (they each pass reliably given the box to themselves). So run these SERIALLY,
# after the parallel batch.
$server_tests = @('demo_http_server_test','demo_forge_test','demo_forge_v2_test','demo_forge_todo_test','demo_cortex_serve_test','demo_ops_test','demo_full_stack_test','real_http_api','http_offload_test','forge_spawn_test','forge_recover_test','forge_recv_security_test','forge_keepalive_test','forge_model_route_test','bytes_socket_test','forge_binary_serve_test','forge_binary_file_test','forge_multipart_test','forge_ws_echo_test','_ws_soak_test','forge_ws_routing_test','forge_ws_chat_test','forge_sse_test','_timed_park_test','forge_ws_keepalive_test','forge_ws_presence_test','forge_ws_lifecycle_test','forge_chunked_test','forge_range_test','forge_conditional_test','forge_flash_test','forge_cache_test','forge_compose_test','forge_hardening_test','forge_http_client_test','forge_resilient_client_test','forge_sse_client_test','forge_h2c_test','forge_grpc_h2c_serve_test','cluster_test')
$parallel_tests = @($all_tests | Where-Object { $server_tests -notcontains $_ })

# -ForgeOnly: run only tests whose SOURCE imports a forge module. A forge-LIB change (compiler + runtime
# unchanged) can ONLY affect forge-importing tests -- the 600 core/language/domain tests don't import forge,
# so running them adds zero safety. This is the fast per-batch gate for lib work (full 607 stays for
# compiler/runtime changes). Robust + zero-maintenance: derived from the actual `import forge*` lines.
if ($ForgeOnly) {
    $isForge = {
        param($n)
        $f = "$PSScriptRoot\$n.nova"
        (Test-Path $f) -and ((Get-Content $f -Raw) -match '(?m)^\s*import\s+forge')
    }
    $parallel_tests = @($parallel_tests | Where-Object { & $isForge $_ })
    $server_tests   = @($server_tests   | Where-Object { & $isForge $_ })
    Write-Host "[ForgeOnly] $($parallel_tests.Count) parallel + $($server_tests.Count) server forge-importing tests"
}
# -NoServer: skip the SERIAL real-TCP server-integration tests (each ~40s of real I/O; they dominate wall
# time). Fast dev gate for lib batches -- the server tests run at the milestone full gate. Non-server unit
# tests still cover the lib's logic.
if ($NoServer) {
    Write-Host "[NoServer] skipping $($server_tests.Count) serial server-integration tests (run them via full nova_ci)"
    $server_tests = @()
    $all_tests = @($all_tests | Where-Object { $parallel_tests -contains $_ })
}

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

# Pre-compile sqlite3.c -> sqlite3_test.o ONCE. The 9MB amalgamation was being
# recompiled at -O2 for EVERY sqlite FFI test inside the parallel link step, which
# under parallel CPU contention exceeded the 60s link timeout -> "undefined
# sqlite3_*" link failures (demo_sqlite_test / demo_forge_todo_test). Compiling it
# once here and linking the object makes those tests fast + reliable.
$sqliteObj = "$PSScriptRoot\output\sqlite3_test.o"
if (Test-Path $sqliteSrc) {
    Write-Host "Pre-compiling sqlite3.c -> sqlite3_test.o ..."
    $sqc = Invoke-Timed -FilePath $ClangPath -Arguments "-c -O2 -DSQLITE_THREADSAFE=0 `"$sqliteSrc`" -o `"$sqliteObj`" -D_CRT_SECURE_NO_WARNINGS -w" -TimeoutMs 240000 -WorkingDirectory $PSScriptRoot
    if (!(Test-Path $sqliteObj)) { Write-Host "WARN: sqlite pre-compile failed (exit=$($sqc.ExitCode)); sqlite FFI tests may fail to link" }
}
Write-Host ""

# ─── Step 2: Parallel test runner ───
$maxParallel = [Math]::Max(2, [Math]::Min(8, [Environment]::ProcessorCount - 2))
Write-Host "Running tests ($maxParallel parallel)..."
Write-Host ""

$testScript = {
    param($testName, $compilerPath, $rtObjPath, $workDir, $clangExe, $lFlags, $sqPath)

    $r = @{ Name = $testName; Status = "PASS"; Detail = ""; Out = "" }

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

    # 150s (was 60s): the self-hosted compiler is a heavy binary; with up to 8 compiles running
    # concurrently (maxParallel) on a contended machine a single compile can exceed 60s wall-time and
    # spuriously "COMPILE exit=-1" (a timeout), failing the CI on a ROTATING set of innocent tests that
    # all pass individually. 150s absorbs the contention while still catching a genuinely hung compile.
    $cr = _RunProc $compilerPath "$testName.nova" 150000 $workDir
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
        $xsrc = " `"$sqPath`""   # $sqPath is the pre-compiled sqlite3_test.o (fast, reliable link)
    }
    # General FFI @link_source/@link_object: the regression links manually (it does not
    # shell to the compiler's nova_link), so it must honor the same markers nova_link does.
    # Compile each C source to <src>.o on demand; add prebuilt objects directly. Only the
    # one test that declares foo.c hits this, so no cross-test race on the object.
    Get-Content $ll | Where-Object { $_ -match '^; LINK_SOURCE: (.+?)\s*$' } | ForEach-Object {
        $sp = $matches[1]
        $obj = "$workDir\$sp.o"
        if (Test-Path "$workDir\$sp") {
            # Rebuild when the SOURCE is newer than the object, not merely when the object is
            # absent. The existence-only check silently linked a STALE object after any edit to
            # a @link_source C file -- the failure surfaces as an unrelated "undefined symbol"
            # link error, which is about as misleading as a build system gets. (The comment
            # above always claimed nova_link's "rebuilt only when foo.c is newer" semantics;
            # this makes the harness actually implement them.)
            $needBuild = -not (Test-Path $obj)
            if (-not $needBuild) {
                $needBuild = (Get-Item "$workDir\$sp").LastWriteTimeUtc -gt (Get-Item $obj).LastWriteTimeUtc
            }
            if ($needBuild) {
                _RunProc $clangExe "-c -O2 `"$workDir\$sp`" -o `"$obj`" -D_CRT_SECURE_NO_WARNINGS -w" 60000 $workDir | Out-Null
            }
            $xsrc += " `"$obj`""
        }
    }
    Get-Content $ll | Where-Object { $_ -match '^; LINK_OBJECT: (.+?)\s*$' } | ForEach-Object {
        $op = $matches[1]
        if (Test-Path "$workDir\$op") { $xsrc += " `"$workDir\$op`"" }
    }

    $la = "-O2 -o `"$exe`" `"$ll`" `"$rtObjPath`"$xsrc $lFlags$xlib -D_CRT_SECURE_NO_WARNINGS -w"
    # 150s (was 60s): heavy networking links (-lws2_32/-ladvapi32 + large test .ll at -O2) exceed 60s
    # under ~8-16x parallel CPU contention and spuriously "LINK"-fail a ROTATING set of forge/ws/tls
    # tests that all link fine standalone. Matches the compile-timeout bump above.
    $lr = _RunProc $clangExe $la 150000 $workDir
    if (-not (Test-Path $exe)) {
        $r.Status = "FAIL"; $r.Detail = "LINK"
        Remove-Item $ll -Force -ErrorAction SilentlyContinue
        return $r
    }

    $rr = _RunProc $exe "" 30000 $workDir   # 30s (was 15s): heavy numeric tests (linalg/dframe/ndarray) get CPU-starved under ~16x parallel + IDE background load and spuriously timed out at 15s though they finish in <120ms standalone
    Remove-Item $exe,$ll -Force -ErrorAction SilentlyContinue

    if ($rr.T) { $r.Status = "FAIL"; $r.Detail = "TIMEOUT" }
    elseif ($rr.X -ne 0) { $r.Status = "FAIL"; $r.Detail = "RUN exit=$($rr.X)" }
    elseif ($rr.E -match 'FAIL assert') { $r.Status = "FAIL"; $r.Detail = "ASSERT FAIL" }
    if ($rr.O) { $r.Out = ([string]$rr.O).Trim() }

    return $r
}

$pool = [System.Management.Automation.Runspaces.RunspaceFactory]::CreateRunspacePool(1, $maxParallel)
$pool.Open()

$jobs = New-Object System.Collections.ArrayList
foreach ($t in $parallel_tests) {
    $ps = [PowerShell]::Create()
    $ps.RunspacePool = $pool
    [void]$ps.AddScript($testScript)
    [void]$ps.AddArgument($t)
    [void]$ps.AddArgument($compiler)
    [void]$ps.AddArgument($runtimeObj)
    [void]$ps.AddArgument($PSScriptRoot)
    [void]$ps.AddArgument($ClangPath)
    [void]$ps.AddArgument($NovaLinkFlags)
    [void]$ps.AddArgument($sqliteObj)
    $handle = $ps.BeginInvoke()
    [void]$jobs.Add(@{ PS = $ps; Handle = $handle; Name = $t })
}

$pass = 0; $fail = 0; $skip = 0; $failures = @(); $suspects = @()
foreach ($job in $jobs) {
    try {
        $res = $job.PS.EndInvoke($job.Handle)
        if ($res -and $res.Count -gt 0) { $r = $res[$res.Count - 1] }
        else { $r = @{ Name = $job.Name; Status = "FAIL"; Detail = "NO RESULT" } }
    } catch {
        $r = @{ Name = $job.Name; Status = "FAIL"; Detail = "RUNSPACE ERROR" }
    }

    switch ($r.Status) {
        "PASS" { $pass++; Write-Host "PASS $($r.Name)"; if ([string]::IsNullOrWhiteSpace($r.Out)) { $suspects += $r.Name } }
        "SKIP" { $skip++ }
        default {
            $fail++
            $failures += "$($r.Name) ($($r.Detail))"
            Write-Host "FAIL $($r.Name)  ($($r.Detail))"
        }
    }
    $job.PS.Dispose()
}

# ─── Serial phase: server-binding tests, one at a time (CPU to themselves) ───
foreach ($t in $server_tests) {
    $ps = [PowerShell]::Create()
    $ps.RunspacePool = $pool
    [void]$ps.AddScript($testScript)
    [void]$ps.AddArgument($t)
    [void]$ps.AddArgument($compiler)
    [void]$ps.AddArgument($runtimeObj)
    [void]$ps.AddArgument($PSScriptRoot)
    [void]$ps.AddArgument($ClangPath)
    [void]$ps.AddArgument($NovaLinkFlags)
    [void]$ps.AddArgument($sqliteObj)
    try {
        $res = $ps.Invoke()   # synchronous -> serial
        if ($res -and $res.Count -gt 0) { $r = $res[$res.Count - 1] }
        else { $r = @{ Name = $t; Status = "FAIL"; Detail = "NO RESULT" } }
    } catch {
        $r = @{ Name = $t; Status = "FAIL"; Detail = "RUNSPACE ERROR" }
    }
    switch ($r.Status) {
        "PASS" { $pass++; Write-Host "PASS $($r.Name) [serial]"; if ([string]::IsNullOrWhiteSpace($r.Out)) { $suspects += $r.Name } }
        "SKIP" { $skip++ }
        default { $fail++; $failures += "$($r.Name) ($($r.Detail))"; Write-Host "FAIL $($r.Name)  ($($r.Detail)) [serial]" }
    }
    $ps.Dispose()
}

$pool.Close()
$pool.Dispose()
Remove-Item $runtimeObj -Force -ErrorAction SilentlyContinue
Remove-Item $sqliteObj -Force -ErrorAction SilentlyContinue

$sw.Stop()
Write-Host ""
Write-Host "=== RESULTS: $pass PASS, $fail FAIL, $skip SKIP (of $($all_tests.Count) total) ==="
Write-Host "Wall time: $([math]::Round($sw.Elapsed.TotalSeconds, 1))s"
if ($failures.Count -gt 0) {
    Write-Host ""
    Write-Host "Failures:"
    foreach ($f in $failures) { Write-Host "  $f" }
}
if ($suspects.Count -gt 0) {
    Write-Host ""
    Write-Host "SUSPECT (exit 0 but NO stdout - possible false-pass, audit these):"
    foreach ($s in $suspects) { Write-Host "  $s" }
}
if ($fail -gt 0) { exit 1 }
exit 0

