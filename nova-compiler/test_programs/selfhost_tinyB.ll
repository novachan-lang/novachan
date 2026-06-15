; NOVA IR-Pipeline Compiler Output
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

declare void @nova_rt_raise_error() nounwind
declare i64 @nova_rt_wrap_error_context(i64, i64, i64) nounwind
declare void @nova_rt_set_error_flag(i64) nounwind
declare i64 @nova_rt_take_error_flag() nounwind
declare i64 @nova_rt_take_error_msg() nounwind

; Runtime declarations
declare i32 @puts(ptr) nounwind
declare i32 @printf(ptr, ...) nounwind
declare i32 @strcmp(ptr, ptr) nounwind readonly
declare i64 @nova_rt_list_create() nounwind
declare i64 @nova_rt_deep_copy(i64) nounwind
declare i64 @nova_rt_list_create_filled(i64, i64) nounwind
declare i64 @nova_rt_list_append(i64, i64) nounwind
declare i64 @nova_rt_list_append_no_rc(i64, i64) nounwind
declare i64 @nova_rt_dict_set_no_rc(i64, i64, i64) nounwind
declare i64 @nova_rt_list_append_fbox(i64, i64) nounwind
declare i64 @nova_rt_list_append_bbox(i64, i64) nounwind
declare i64 @nova_rt_box_bool(i64) nounwind
declare i64 @nova_rt_unbox(i64) nounwind
declare i64 @nova_rt_unbox_elem(i64) nounwind
declare i64 @nova_rt_lt(i64, i64) nounwind
declare i64 @nova_rt_le(i64, i64) nounwind
declare i64 @nova_rt_gt(i64, i64) nounwind
declare i64 @nova_rt_ge(i64, i64) nounwind
declare i64 @nova_rt_list_get(i64, i64) nounwind readonly
declare i64 @nova_rt_list_len(i64) nounwind readonly
declare i64 @nova_rt_dict_create() nounwind
declare i64 @nova_rt_dict_set(i64, i64, i64) nounwind
declare i64 @nova_rt_dict_set_fbox(i64, i64, i64) nounwind
declare i64 @nova_rt_dict_set_bbox(i64, i64, i64) nounwind
declare i64 @nova_rt_box_float(i64) nounwind
declare i64 @nova_rt_dict_get(i64, i64) nounwind readonly
declare i64 @nova_rt_str_concat(i64, i64) nounwind
declare i64 @nova_rt_int_to_str(i64) nounwind
declare i64 @nova_rt_bool_to_str(i64) nounwind
declare i64 @nova_rt_parse_int(i64) nounwind readonly
declare i64 @nova_rt_len(i64) nounwind readonly
declare i64 @nova_rt_len_any(i64) nounwind readonly
declare i64 @nova_rt_ord(i64) nounwind readonly
declare i64 @nova_rt_chr(i64) nounwind
declare i64 @nova_rt_contains(i64, i64) nounwind readonly
declare i64 @nova_rt_index_get(i64, i64) nounwind readonly
declare i64 @nova_rt_index_set(i64, i64, i64) nounwind
declare i64 @nova_rt_add(i64, i64) nounwind
declare i64 @nova_rt_sub(i64, i64) nounwind
declare i64 @nova_rt_mul(i64, i64) nounwind
declare i64 @nova_rt_div(i64, i64) nounwind
declare i64 @nova_rt_eq(i64, i64) nounwind readonly
declare i64 @nova_rt_neq(i64, i64) nounwind readonly
declare i64 @nova_rt_any_to_str(i64) nounwind
declare void @nova_rt_assert(i64, i64) nounwind
declare i64 @nova_rt_read_file(i64) nounwind
declare i64 @nova_rt_write_file(i64, i64) nounwind
declare i64 @nova_rt_remove_file(i64) nounwind
declare i64 @nova_rt_remove_dir(i64) nounwind
declare i64 @nova_rt_rename_path(i64, i64) nounwind
declare i64 @nova_rt_copy_file(i64, i64) nounwind
declare i64 @nova_rt_file_size(i64) nounwind
declare i64 @nova_rt_file_mtime(i64) nounwind
declare i64 @nova_rt_is_dir(i64) nounwind
declare i64 @nova_rt_is_file(i64) nounwind
declare i64 @nova_rt_write_bytes(i64, i64) nounwind
declare i64 @nova_rt_read_lines(i64) nounwind
declare i64 @nova_rt_file_open(i64, i64) nounwind
declare i64 @nova_rt_file_read_line(i64) nounwind
declare i64 @nova_rt_file_write(i64, i64) nounwind
declare i64 @nova_rt_file_eof(i64) nounwind
declare i64 @nova_rt_file_seek(i64, i64) nounwind
declare i64 @nova_rt_file_tell(i64) nounwind
declare i64 @nova_rt_file_flush(i64) nounwind
declare i64 @nova_rt_file_close(i64) nounwind
declare i64 @nova_rt_temp_dir() nounwind
declare i64 @nova_rt_args() nounwind
declare void @nova_rt_exit(i64) nounwind
declare i64 @nova_rt_split(i64, i64) nounwind
declare i64 @nova_rt_join(i64, i64) nounwind
declare i64 @nova_rt_upper(i64) nounwind
declare i64 @nova_rt_lower(i64) nounwind
declare i64 @nova_rt_trim(i64) nounwind
declare i64 @nova_rt_replace(i64, i64, i64) nounwind
declare i64 @nova_rt_starts_with(i64, i64) nounwind readonly
declare i64 @nova_rt_ends_with(i64, i64) nounwind readonly
declare i64 @nova_rt_print_intlist(i64) nounwind
declare i64 @nova_rt_intlist_to_str(i64) nounwind
declare i64 @nova_rt_print_any(i64) nounwind
declare i64 @nova_rt_print_bool(i64) nounwind
declare i64 @nova_rt_print_float(i64) nounwind
declare i64 @nova_rt_print_int(i64) nounwind
declare i64 @nova_rt_print_str(i64) nounwind
declare i64 @nova_rt_float_bits(i64) nounwind
declare i64 @nova_rt_float_to_str(i64) nounwind
declare ptr @nova_rt_struct_alloc(i64) nounwind
declare ptr @nova_rt_aligned_struct_alloc(i64, i64) nounwind
declare i64 @nova_rt_slice(i64, i64, i64) nounwind
declare i64 @nova_rt_slice_any(i64, i64, i64) nounwind
declare i64 @nova_rt_repeat(i64, i64) nounwind
declare i64 @nova_rt_list_repeat(i64, i64) nounwind
declare i64 @nova_rt_chars(i64) nounwind
declare i64 @nova_rt_time_ms() nounwind
declare i64 @nova_rt_sleep_ms(i64) nounwind
declare i64 @nova_rt_clock_ns() nounwind
declare i64 @nova_rt_type_of(i64) nounwind
declare i64 @nova_rt_type_hash(i64) nounwind
declare i64 @nova_rt_range(i64) nounwind
declare i64 @nova_rt_range_from_to(i64, i64) nounwind
declare i64 @nova_rt_dict_keys(i64) nounwind readonly
declare i64 @nova_rt_dict_values(i64) nounwind readonly
declare i64 @nova_rt_dict_items(i64) nounwind readonly
declare i64 @nova_rt_for_iter_init(i64) nounwind
declare i64 @nova_rt_for_destr_init(i64) nounwind
declare i64 @nova_rt_for_kv_init(i64) nounwind
declare i64 @nova_rt_dict_has(i64, i64) nounwind readonly
declare i64 @nova_rt_memo_cache(i64) nounwind
declare i64 @nova_rt_dict_del(i64, i64) nounwind
declare i64 @nova_rt_system(i64) nounwind
declare i64 @nova_rt_exec(i64) nounwind
declare i64 @nova_rt_proc_open(i64) nounwind
declare i64 @nova_rt_proc_write_stdin(i64, i64) nounwind
declare i64 @nova_rt_proc_read_stdout(i64) nounwind
declare i64 @nova_rt_proc_close_stdin(i64) nounwind
declare i64 @nova_rt_proc_wait(i64) nounwind
declare i64 @nova_rt_shell(i64) nounwind
declare i64 @nova_rt_create_string(ptr) nounwind
declare void @nova_rt_init_args(i64, i64) nounwind
declare void @nova_rt_wait_all() nounwind
declare void @nova_rt_main_dispatch(i64) nounwind
declare void @nova_rt_cleanup() nounwind
declare i64 @nova_rt_channel_create() nounwind
declare i64 @nova_rt_channel_bounded(i64) nounwind
declare i64 @nova_rt_channel_send(i64, i64) nounwind
declare i64 @nova_rt_channel_send_move(i64, i64) nounwind
declare i64 @nova_rt_channel_recv(i64) nounwind
declare i64 @nova_rt_channel_close(i64) nounwind
declare i64 @nova_rt_channel_select(i64, i64) nounwind
declare i64 @nova_rt_select(i64) nounwind
declare i64 @nova_rt_channel_recv_timeout(i64, i64) nounwind
declare i64 @nova_rt_spawn(i64, i64) nounwind
declare i64 @nova_rt_monitor(i64) nounwind
declare i64 @nova_rt_exit_reason(i64) nounwind
declare i64 @nova_rt_parse_float(i64) nounwind
declare i64 @nova_rt_read_line() nounwind
declare i64 @nova_rt_append_file(i64, i64) nounwind
declare i64 @nova_rt_file_exists(i64) nounwind
declare i64 @nova_rt_find(i64, i64) nounwind readonly
declare i64 @nova_rt_list_concat(i64, i64) nounwind
declare i64 @nova_rt_list_reverse(i64) nounwind
declare i64 @nova_rt_list_sort(i64) nounwind
declare i64 @nova_rt_list_slice(i64, i64, i64) nounwind
declare i64 @nova_rt_list_map(i64, i64) nounwind
declare i64 @nova_rt_list_map_fbox(i64, i64) nounwind
declare i64 @nova_rt_list_filter(i64, i64) nounwind
declare i64 @nova_rt_http_get(i64) nounwind
declare i64 @nova_rt_http_post(i64, i64, i64) nounwind
declare i64 @nova_rt_mkdir(i64) nounwind
declare i64 @nova_rt_mkdir_p(i64) nounwind
declare i64 @nova_rt_path_join(i64, i64) nounwind
declare i64 @nova_rt_path_exists(i64) nounwind readonly
declare i64 @nova_rt_path_parent(i64) nounwind readonly
declare i64 @nova_rt_path_name(i64) nounwind readonly
declare i64 @nova_rt_read_bytes(i64) nounwind
declare i64 @nova_rt_gpu_available() nounwind
declare i64 @nova_rt_gpu_vadd_floats(i64, i64) nounwind
declare i64 @nova_rt_prof_enter(i64) nounwind
declare i64 @nova_rt_prof_exit(i64) nounwind
declare void @nova_rt_prof_dump() nounwind
declare i64 @nova_rt_cov_hit(i64, i64) nounwind
declare i64 @nova_rt_cov_register(i64, i64) nounwind
declare void @nova_rt_cov_dump() nounwind
declare i64 @nova_rt_write_raw(i64) nounwind
declare i64 @nova_rt_abs(i64) nounwind readnone
declare i64 @nova_rt_max(i64, i64) nounwind readnone
declare i64 @nova_rt_min(i64, i64) nounwind readnone
declare i64 @nova_rt_sqrt(i64) nounwind readnone
declare i64 @nova_rt_sinh(i64) nounwind
declare i64 @nova_rt_cosh(i64) nounwind
declare i64 @nova_rt_tanh(i64) nounwind
declare i64 @nova_rt_cbrt(i64) nounwind
declare i64 @nova_rt_hypot(i64, i64) nounwind
declare i64 @nova_rt_gcd(i64, i64) nounwind
declare i64 @nova_rt_lcm(i64, i64) nounwind
declare i64 @nova_rt_popcount(i64) nounwind
declare i64 @nova_rt_clz(i64) nounwind
declare i64 @nova_rt_ctz(i64) nounwind
declare i64 @nova_rt_rotl(i64, i64) nounwind
declare i64 @nova_rt_rotr(i64, i64) nounwind
declare i64 @nova_rt_htons(i64) nounwind
declare i64 @nova_rt_ntohs(i64) nounwind
declare i64 @nova_rt_htonl(i64) nounwind
declare i64 @nova_rt_ntohl(i64) nounwind
declare i64 @nova_rt_pi() nounwind
declare i64 @nova_rt_e() nounwind
declare i64 @nova_rt_char_count(i64) nounwind
declare i64 @nova_rt_char_at(i64, i64) nounwind
declare i64 @nova_rt_code_points(i64) nounwind
declare i64 @nova_rt_from_codepoint(i64) nounwind
declare i64 @nova_rt_is_valid_utf8(i64) nounwind
declare i64 @nova_rt_floor(i64) nounwind readnone
declare i64 @nova_rt_ceil(i64) nounwind readnone
declare i64 @nova_rt_pow(i64, i64) nounwind readnone
declare i64 @nova_rt_round(i64) nounwind readnone
declare i64 @nova_rt_sin(i64) nounwind readnone
declare i64 @nova_rt_cos(i64) nounwind readnone
declare i64 @nova_rt_tan(i64) nounwind readnone
declare i64 @nova_rt_log(i64) nounwind readnone
declare i64 @nova_rt_log2(i64) nounwind readnone
declare i64 @nova_rt_log10(i64) nounwind readnone
declare i64 @nova_rt_exp(i64) nounwind readnone
declare i64 @nova_rt_fabs(i64) nounwind readnone
declare i64 @nova_rt_fmax(i64, i64) nounwind readnone
declare i64 @nova_rt_fmin(i64, i64) nounwind readnone
declare i64 @nova_rt_fmod(i64, i64) nounwind readnone
declare i64 @nova_rt_float_to_int(i64) nounwind readnone
declare i64 @nova_rt_int_to_float(i64) nounwind readnone
declare i64 @nova_rt_to_int(i64) nounwind readnone
declare i64 @nova_rt_to_float(i64) nounwind readnone
declare i64 @nova_rt_env(i64) nounwind
declare i64 @nova_rt_set_env(i64, i64) nounwind
declare i64 @nova_rt_cstr_to_string(i64) nounwind
declare void @nova_rt_rc_stats_dump() nounwind
declare i64 @nova_rt_list_free_local(i64) nounwind
declare i64 @nova_rt_dict_free_local(i64) nounwind
declare i64 @nova_rt_random_int(i64, i64) nounwind
declare i64 @nova_rt_random_float() nounwind
declare i64 @nova_rt_json_parse(i64) nounwind
declare i64 @nova_rt_json_stringify(i64) nounwind
declare i64 @nova_rt_regex_match(i64, i64) nounwind
declare i64 @nova_rt_regex_find(i64, i64) nounwind
declare i64 @nova_rt_regex_replace(i64, i64, i64) nounwind
declare i64 @nova_rt_regex_split(i64, i64) nounwind
declare i64 @nova_rt_regex_find_all(i64, i64) nounwind
declare i64 @nova_rt_regex_replace_all(i64, i64, i64) nounwind
declare i64 @nova_rt_path_ext(i64) nounwind
declare i64 @nova_rt_tcp_connect(i64, i64) nounwind
declare i64 @nova_rt_tcp_listen(i64) nounwind
declare i64 @nova_rt_tcp_accept(i64) nounwind
declare i64 @nova_rt_tcp_send(i64, i64) nounwind
declare i64 @nova_rt_tcp_recv(i64) nounwind
declare i64 @nova_rt_udp_bind(i64) nounwind
declare i64 @nova_rt_udp_send(i64, i64, i64, i64) nounwind
declare i64 @nova_rt_udp_recv(i64) nounwind
declare void @nova_rt_tcp_close(i64) nounwind
declare i64 @nova_rt_bytes_create(i64) nounwind
declare i64 @nova_rt_bytes_get(i64, i64) nounwind
declare void @nova_rt_bytes_set(i64, i64, i64) nounwind
declare i64 @nova_rt_bytes_len(i64) nounwind
declare i64 @nova_rt_bytes_slice(i64, i64, i64) nounwind
declare i64 @nova_rt_bytes_to_str(i64) nounwind
declare i64 @nova_rt_str_to_bytes(i64) nounwind
declare i64 @nova_rt_decode_utf8(i64) nounwind
declare i64 @nova_rt_decode_utf8_lossy(i64) nounwind
declare i64 @nova_rt_asin(i64) nounwind readnone
declare i64 @nova_rt_acos(i64) nounwind readnone
declare i64 @nova_rt_atan(i64) nounwind readnone
declare i64 @nova_rt_atan2(i64, i64) nounwind readnone
declare i64 @nova_rt_int_pow(i64, i64) nounwind readnone
declare i64 @nova_rt_alloc_count() nounwind
declare i64 @nova_rt_live_count() nounwind
declare i64 @nova_rt_enumerate(i64) nounwind
declare i64 @nova_rt_zip(i64, i64) nounwind
declare i64 @nova_rt_reduce(i64, i64, i64) nounwind
declare i64 @nova_rt_any_match(i64, i64) nounwind
declare i64 @nova_rt_all_match(i64, i64) nounwind
declare i64 @nova_rt_any_truthy(i64) nounwind readonly
declare i64 @nova_rt_all_truthy(i64) nounwind readonly
declare i64 @nova_rt_list_min(i64) nounwind readonly
declare i64 @nova_rt_list_max(i64) nounwind readonly
declare i64 @nova_rt_sum_f(i64) nounwind readonly
declare i64 @nova_rt_list_min_f(i64) nounwind readonly
declare i64 @nova_rt_list_max_f(i64) nounwind readonly
declare i64 @nova_rt_set_create() nounwind
declare i64 @nova_rt_set_add(i64, i64) nounwind
declare i64 @nova_rt_set_has(i64, i64) nounwind readonly
declare i64 @nova_rt_set_remove(i64, i64) nounwind
declare i64 @nova_rt_set_len(i64) nounwind readonly
declare i64 @nova_rt_set_to_list(i64) nounwind
declare i64 @nova_rt_sum(i64) nounwind readonly
declare i64 @nova_rt_index_of(i64, i64) nounwind readonly
declare i64 @nova_rt_sort_by(i64, i64) nounwind
declare i64 @nova_rt_dict_merge(i64, i64) nounwind
declare i64 @nova_rt_str_count(i64, i64) nounwind readonly
declare i64 @nova_rt_lstrip(i64) nounwind
declare i64 @nova_rt_rstrip(i64) nounwind
declare i64 @nova_rt_pad_left(i64, i64, i64) nounwind
declare i64 @nova_rt_pad_right(i64, i64, i64) nounwind
declare i64 @nova_rt_cwd() nounwind
declare i64 @nova_rt_chdir(i64) nounwind
declare i64 @nova_rt_getpid() nounwind
declare i64 @nova_rt_which(i64) nounwind
declare i64 @nova_rt_dns_resolve(i64) nounwind
declare i64 @nova_rt_dns_resolve_all(i64) nounwind
declare i64 @nova_rt_reverse_dns(i64) nounwind
declare i64 @nova_rt_hostname() nounwind
declare i64 @nova_rt_list_dir(i64) nounwind
declare i64 @nova_rt_hash(i64) nounwind readonly
declare i64 @nova_rt_sha256(i64) nounwind
declare i64 @nova_rt_sha256_bytes(i64, i64) nounwind
declare i64 @nova_rt_hmac_sha256(i64, i64) nounwind
declare i64 @nova_rt_hex_encode(i64) nounwind
declare i64 @nova_rt_hex_decode(i64) nounwind
declare i64 @nova_rt_base64_encode(i64) nounwind
declare i64 @nova_rt_base64_decode(i64) nounwind
declare i64 @nova_rt_uuid4() nounwind
declare i64 @nova_rt_random_bytes(i64) nounwind
declare i64 @nova_rt_secure_bytes(i64) nounwind
declare i64 @nova_rt_mmap_open(i64) nounwind
declare i64 @nova_rt_mmap_len(i64) nounwind
declare i64 @nova_rt_mmap_byte(i64, i64) nounwind
declare i64 @nova_rt_mmap_close(i64) nounwind
declare i64 @nova_rt_offheap_create(i64) nounwind
declare i64 @nova_rt_offheap_len(i64) nounwind
declare i64 @nova_rt_offheap_get(i64, i64) nounwind
declare i64 @nova_rt_offheap_set(i64, i64, i64) nounwind
declare i64 @nova_rt_offheap_free(i64) nounwind
declare i64 @nova_rt_atomic_new(i64) nounwind
declare i64 @nova_rt_atomic_get(i64) nounwind
declare i64 @nova_rt_atomic_set(i64, i64) nounwind
declare i64 @nova_rt_atomic_add(i64, i64) nounwind
declare i64 @nova_rt_atomic_cas(i64, i64, i64) nounwind
declare i64 @nova_rt_os_name() nounwind
declare i64 @nova_rt_arch_name() nounwind
declare i64 @nova_rt_type_name(i64) nounwind
declare i64 @nova_rt_panic(i64) nounwind
declare i64 @nova_rt_fiber_create(i64) nounwind
declare i64 @nova_rt_fiber_resume(i64) nounwind
declare i64 @nova_rt_fiber_yield() nounwind
declare i64 @nova_rt_reschedule() nounwind
declare i64 @nova_rt_fiber_is_done(i64) nounwind
declare i64 @nova_rt_gen_yield(i64) nounwind
declare i64 @nova_rt_gen_next(i64) nounwind
declare i64 @nova_rt_gen_value(i64) nounwind
declare i64 @nova_rt_gen_collect(i64) nounwind
declare i64 @nova_rt_term_encode(i64) nounwind
declare i64 @nova_rt_term_decode(i64) nounwind
declare i64 @nova_rt_sched_spawn(i64) nounwind
declare i64 @nova_rt_sched_run() nounwind
declare i64 @nova_rt_dbg_set_bp(i64, i64) nounwind
declare i64 @nova_rt_dbg_remove_bp(i64) nounwind
declare i64 @nova_rt_dbg_list_bps() nounwind
declare i64 @nova_rt_dbg_push_frame(i64, i64, i64, i64) nounwind
declare i64 @nova_rt_dbg_pop_frame() nounwind
declare i64 @nova_rt_dbg_backtrace() nounwind
declare i64 @nova_rt_dbg_hook(i64, i64, i64) nounwind
declare i64 @nova_rt_dbg_enable() nounwind
declare i64 @nova_rt_dbg_disable() nounwind
declare i64 @nova_rt_at_exit(i64) nounwind
declare i64 @nova_rt_dir_walk(i64) nounwind
declare i64 @nova_rt_flatten(i64) nounwind
declare i64 @nova_rt_dict_from_pairs(i64) nounwind
declare i64 @nova_rt_pmap(i64, i64) nounwind
declare i64 @nova_rt_pfilter(i64, i64) nounwind
declare i64 @nova_rt_pfor(i64, i64, i64) nounwind
declare i64 @nova_rt_cpu_count() nounwind
declare i64 @nova_rt_http_listen(i64) nounwind
declare i64 @nova_rt_http_accept_raw(i64) nounwind
declare i64 @nova_rt_http_read_request(i64) nounwind
declare void @nova_rt_http_send_raw(i64, i64) nounwind
declare i64 @nova_rt_stdin_read_n(i64) nounwind
declare void @nova_rt_stdout_write(i64) nounwind
declare i64 @nova_rt_tensor_zeros(i64) nounwind
declare i64 @nova_rt_tensor_from_list(i64, i64) nounwind
declare i64 @nova_rt_tensor_shape(i64) nounwind
declare i64 @nova_rt_tensor_size(i64) nounwind
declare i64 @nova_rt_tensor_rank(i64) nounwind
declare i64 @nova_rt_tensor_get(i64, i64) nounwind
declare void @nova_rt_tensor_set(i64, i64, i64) nounwind
declare i64 @nova_rt_tensor_add(i64, i64) nounwind
declare i64 @nova_rt_tensor_mul(i64, i64) nounwind
declare i64 @nova_rt_tensor_scale(i64, i64) nounwind
declare i64 @nova_rt_tensor_matmul(i64, i64) nounwind
declare i64 @nova_rt_tensor_sum(i64) nounwind
declare i64 @nova_rt_tensor_relu(i64) nounwind
declare i64 @nova_rt_tensor_to_list(i64) nounwind
declare i64 @nova_rt_ok(i64) nounwind
declare i64 @nova_rt_parse_int_safe(i64) nounwind
declare i64 @nova_rt_parse_float_safe(i64) nounwind
declare i64 @nova_rt_err(i64) nounwind
declare i64 @nova_rt_some(i64) nounwind
declare i64 @nova_rt_none() nounwind
declare i64 @nova_rt_is_ok(i64) nounwind readonly
declare i64 @nova_rt_is_err(i64) nounwind readonly
declare i64 @nova_rt_is_some(i64) nounwind readonly
declare i64 @nova_rt_is_none(i64) nounwind readonly
declare i64 @nova_rt_unwrap(i64) nounwind
declare i64 @nova_rt_unwrap_err(i64) nounwind
declare i64 @nova_rt_unwrap_or(i64, i64) nounwind
declare i64 @nova_rt_result_tag(i64) nounwind
declare void @nova_rt_clear_is_result() nounwind
declare i64 @nova_rt_try_unwrap_value(i64) nounwind
declare i64 @nova_rt_result_map(i64, i64) nounwind
declare i64 @nova_rt_result_map_err(i64, i64) nounwind
declare i64 @nova_rt_result_and_then(i64, i64) nounwind
declare i64 @nova_rt_result_or_else(i64, i64) nounwind
declare i64 @nova_rt_format(i64, i64) nounwind
declare i64 @nova_rt_format_one(i64, i64) nounwind
declare i64 @nova_rt_center(i64, i64, i64) nounwind
declare i64 @nova_rt_hex(i64) nounwind
declare i64 @nova_rt_oct(i64) nounwind
declare i64 @nova_rt_bin(i64) nounwind
declare i64 @nova_rt_iter(i64) nounwind
declare i64 @nova_rt_iter_range(i64, i64) nounwind
declare i64 @nova_rt_iter_range_step(i64, i64, i64) nounwind
declare i64 @nova_rt_iter_map(i64, i64) nounwind
declare i64 @nova_rt_iter_filter(i64, i64) nounwind
declare i64 @nova_rt_iter_take(i64, i64) nounwind
declare i64 @nova_rt_iter_skip(i64, i64) nounwind
declare i64 @nova_rt_iter_zip(i64, i64) nounwind
declare i64 @nova_rt_iter_chain(i64, i64) nounwind
declare i64 @nova_rt_iter_enumerate(i64) nounwind
declare i64 @nova_rt_iter_flat_map(i64, i64) nounwind
declare i64 @nova_rt_iter_next(i64) nounwind
declare i64 @nova_rt_iter_collect(i64) nounwind
declare i64 @nova_rt_iter_reduce(i64, i64, i64) nounwind
declare i64 @nova_rt_iter_for_each(i64, i64) nounwind
declare i64 @nova_rt_iter_count(i64) nounwind
declare i64 @nova_rt_iter_sum(i64) nounwind
declare i64 @nova_rt_iter_any(i64, i64) nounwind
declare i64 @nova_rt_iter_all(i64, i64) nounwind
declare i64 @nova_rt_iter_find(i64, i64) nounwind
declare i64 @nova_rt_async(i64) nounwind
declare i64 @nova_rt_await(i64) nounwind
declare i64 @nova_rt_await_all(i64) nounwind
declare i64 @nova_rt_buffer_create() nounwind
declare i64 @nova_rt_buffer_create_cap(i64) nounwind
declare void @nova_rt_buffer_append(i64, i64) nounwind
declare void @nova_rt_buffer_append_char(i64, i64) nounwind
declare void @nova_rt_buffer_append_int(i64, i64) nounwind
declare void @nova_rt_buffer_append_float(i64, i64) nounwind
declare i64 @nova_rt_buffer_to_str(i64) nounwind
declare i64 @nova_rt_buffer_len(i64) nounwind readonly
declare void @nova_rt_buffer_clear(i64) nounwind
declare i64 @nova_rt_buffer_str(i64) nounwind
declare void @nova_rt_set_arena_mode(i64) nounwind
declare i64 @nova_rt_is_arena_mode() nounwind
declare i64 @nova_rt_semver_parse(i64) nounwind
declare i64 @nova_rt_semver_compare(i64, i64) nounwind readonly
declare i64 @nova_rt_semver_satisfies(i64, i64) nounwind readonly
declare i64 @nova_rt_semver_format(i64) nounwind
declare i64 @nova_rt_lockfile_read(i64) nounwind
declare i64 @nova_rt_lockfile_write(i64, i64) nounwind
declare i64 @nova_rt_pkg_resolve(i64, i64) nounwind
declare i64 @nova_rt_await_any(i64) nounwind
declare i64 @nova_rt_assert_eq(i64, i64) nounwind
declare i64 @nova_rt_assert_ne(i64, i64) nounwind
declare i64 @nova_rt_assert_true(i64) nounwind
declare i64 @nova_rt_assert_false(i64) nounwind
declare i64 @nova_rt_assert_near(i64, i64, i64) nounwind
declare i64 @nova_rt_test_run(i64, i64) nounwind
declare i64 @nova_rt_test_summary() nounwind
declare i64 @nova_rt_test_reset() nounwind
declare i64 @nova_rt_datetime_now() nounwind
declare i64 @nova_rt_datetime_timestamp() nounwind
declare i64 @nova_rt_datetime_year(i64) nounwind
declare i64 @nova_rt_datetime_month(i64) nounwind
declare i64 @nova_rt_datetime_day(i64) nounwind
declare i64 @nova_rt_datetime_hour(i64) nounwind
declare i64 @nova_rt_datetime_minute(i64) nounwind
declare i64 @nova_rt_datetime_second(i64) nounwind
declare i64 @nova_rt_datetime_weekday(i64) nounwind
declare i64 @nova_rt_datetime_format(i64, i64) nounwind
declare i64 @nova_rt_datetime_parse(i64, i64) nounwind
declare i64 @nova_rt_datetime_diff(i64, i64) nounwind
declare i64 @nova_rt_datetime_add_days(i64, i64) nounwind
declare i64 @nova_rt_datetime_add_hours(i64, i64) nounwind
declare i64 @nova_rt_pq_create() nounwind
declare void @nova_rt_pq_push(i64, i64, i64) nounwind
declare i64 @nova_rt_pq_pop(i64) nounwind
declare i64 @nova_rt_pq_peek(i64) nounwind
declare i64 @nova_rt_pq_peek_priority(i64) nounwind
declare i64 @nova_rt_pq_len(i64) nounwind
declare i64 @nova_rt_pq_is_empty(i64) nounwind
declare i64 @nova_rt_deque_create() nounwind
declare void @nova_rt_deque_push_back(i64, i64) nounwind
declare void @nova_rt_deque_push_front(i64, i64) nounwind
declare i64 @nova_rt_deque_pop_front(i64) nounwind
declare i64 @nova_rt_deque_pop_back(i64) nounwind
declare i64 @nova_rt_deque_front(i64) nounwind
declare i64 @nova_rt_deque_back(i64) nounwind
declare i64 @nova_rt_deque_get(i64, i64) nounwind
declare i64 @nova_rt_deque_len(i64) nounwind
declare i64 @nova_rt_deque_is_empty(i64) nounwind
declare i64 @nova_rt_deque_to_list(i64) nounwind
declare i64 @nova_rt_smap_create() nounwind
declare void @nova_rt_smap_set(i64, i64, i64) nounwind
declare i64 @nova_rt_smap_get(i64, i64) nounwind
declare i64 @nova_rt_smap_has(i64, i64) nounwind
declare void @nova_rt_smap_del(i64, i64) nounwind
declare i64 @nova_rt_smap_len(i64) nounwind
declare i64 @nova_rt_smap_keys(i64) nounwind
declare i64 @nova_rt_smap_values(i64) nounwind
declare i64 @nova_rt_smap_range(i64, i64, i64) nounwind
declare i64 @nova_rt_lru_create(i64) nounwind
declare i64 @nova_rt_lru_get(i64, i64) nounwind
declare i64 @nova_rt_lru_has(i64, i64) nounwind
declare void @nova_rt_lru_put(i64, i64, i64) nounwind
declare i64 @nova_rt_lru_len(i64) nounwind
declare i64 @nova_rt_lru_hits(i64) nounwind
declare i64 @nova_rt_lru_misses(i64) nounwind
declare i64 @nova_rt_lru_cap(i64) nounwind
declare i64 @nova_rt_counter_create() nounwind
declare void @nova_rt_counter_inc(i64, i64) nounwind
declare void @nova_rt_counter_add(i64, i64, i64) nounwind
declare i64 @nova_rt_counter_get(i64, i64) nounwind
declare i64 @nova_rt_counter_total(i64) nounwind
declare i64 @nova_rt_counter_most_common(i64, i64) nounwind
declare i64 @nova_rt_ringbuf_create(i64) nounwind
declare void @nova_rt_ringbuf_push(i64, i64) nounwind
declare i64 @nova_rt_ringbuf_pop(i64) nounwind
declare i64 @nova_rt_ringbuf_len(i64) nounwind
declare i64 @nova_rt_ringbuf_cap(i64) nounwind
declare i64 @nova_rt_ringbuf_is_full(i64) nounwind
declare void @nova_rt_log_trace(i64, i64) nounwind
declare void @nova_rt_log_debug(i64, i64) nounwind
declare void @nova_rt_log_info(i64, i64) nounwind
declare void @nova_rt_log_warn(i64, i64) nounwind
declare void @nova_rt_log_error(i64, i64) nounwind
declare void @nova_rt_log_fatal(i64, i64) nounwind
declare void @nova_rt_log_set_level(i64) nounwind
declare i64 @nova_rt_log_get_level() nounwind
declare void @nova_rt_log_set_json(i64) nounwind
declare i64 @nova_rt_assert_contains(i64, i64) nounwind
declare i64 @nova_rt_assert_approx(i64, i64, i64) nounwind
declare i64 @nova_rt_assert_throws(i64, i64) nounwind
declare i64 @nova_rt_test_run_tap(i64, i64, i64) nounwind
declare i64 @nova_rt_crc32(i64) nounwind
declare i64 @nova_rt_fnv1a(i64) nounwind
declare i64 @nova_rt_murmur3(i64, i64) nounwind
declare i64 @nova_rt_arena_create() nounwind
declare i64 @nova_rt_arena_alloc(i64, i64) nounwind
declare void @nova_rt_arena_reset(i64) nounwind
declare void @nova_rt_arena_free(i64) nounwind
declare i64 @nova_rt_arena_used(i64) nounwind
declare i64 @nova_rt_checked_add(i64, i64) nounwind
declare i64 @nova_rt_checked_sub(i64, i64) nounwind
declare i64 @nova_rt_checked_mul(i64, i64) nounwind
declare void @nova_rt_overflow_panic() nounwind
declare i64 @nova_rt_weak_create(i64) nounwind
declare i64 @nova_rt_weak_upgrade(i64) nounwind
declare i64 @nova_rt_weak_alive(i64) nounwind
declare void @nova_rt_weak_invalidate(i64) nounwind
declare void @nova_rt_process_link(i64, i64) nounwind
declare i64 @nova_rt_process_monitor(i64, i64) nounwind
declare void @nova_rt_process_demonitor(i64) nounwind
declare void @nova_rt_process_exit_notify(i64, i64) nounwind
declare void @nova_rt_stack_enter() nounwind
declare void @nova_rt_stack_exit() nounwind
declare void @nova_rt_stack_set_max(i64) nounwind
declare void @nova_rt_deprecated_warn(i64, i64) nounwind
declare i64 @nova_rt_cstr_of(i64) nounwind
declare i64 @nova_rt_null_ptr() nounwind
declare i64 @nova_rt_is_null(i64) nounwind
declare i64 @nova_rt_ptr_read(i64) nounwind
declare void @nova_rt_ptr_write(i64, i64) nounwind
declare i64 @nova_rt_ptr_add(i64, i64) nounwind
declare i64 @nova_rt_ptr_diff(i64, i64) nounwind
declare i64 @nova_rt_memcpy_unsafe(i64, i64, i64) nounwind
declare i64 @nova_rt_memset_unsafe(i64, i64, i64) nounwind
declare i64 @nova_rt_sizeof_ptr() nounwind
declare i64 @nova_rt_alloc_raw(i64) nounwind
declare void @nova_rt_free_raw(i64) nounwind
declare i64 @nova_rt_str_from_cstr(i64) nounwind
declare i64 @nova_rt_build_toml_parse(i64) nounwind
declare i64 @nova_rt_build_toml_format(i64) nounwind
declare i64 @nova_rt_build_get_sources(i64) nounwind
declare i64 @nova_rt_build_file_mtime(i64) nounwind
declare i64 @nova_rt_build_needs_rebuild(i64, i64) nounwind
declare i64 @nova_rt_build_changed_sources(i64, i64) nounwind
declare i64 @nova_rt_fmt_format(i64) nounwind
declare i64 @nova_rt_fmt_check(i64) nounwind
declare i64 @nova_rt_target_current() nounwind
declare i64 @nova_rt_target_list() nounwind
declare i64 @nova_rt_target_is_wasm(i64) nounwind
declare i64 @nova_rt_target_arch(i64) nounwind
declare i64 @nova_rt_bench_run(i64, i64, i64) nounwind
declare i64 @nova_rt_bench_report() nounwind
declare i64 @nova_rt_bench_reset() nounwind
declare i64 @nova_rt_cov_mark(i64, i64) nounwind
declare i64 @nova_rt_cov_get(i64, i64) nounwind
declare i64 @nova_rt_cov_report() nounwind
declare i64 @nova_rt_cov_reset() nounwind
declare i64 @nova_rt_cov_export_lcov(i64) nounwind
declare i64 @nova_rt_prof_start(i64) nounwind
declare i64 @nova_rt_prof_stop(i64) nounwind
declare i64 @nova_rt_prof_report() nounwind
declare i64 @nova_rt_prof_get_ns(i64) nounwind
declare i64 @nova_rt_prof_reset() nounwind
declare i64 @nova_rt_prof_export_flame(i64) nounwind
declare i64 @nova_rt_abi_version() nounwind
declare i64 @nova_rt_dap_log(i64, i64) nounwind
declare i64 @nova_rt_dap_breakpoint(i64, i64) nounwind
declare i64 @nova_rt_dap_send(i64) nounwind
declare i64 @nova_rt_doc_extract(i64) nounwind
declare i64 @nova_rt_doc_to_markdown(i64, i64) nounwind
declare i64 @nova_rt_doc_to_html(i64, i64) nounwind
declare i64 @nova_rt_doc_entry_count(i64) nounwind
declare i64 @nova_rt_tls_connect(i64, i64) nounwind
declare i64 @nova_rt_tls_listen(i64, i64, i64) nounwind
declare i64 @nova_rt_tls_accept(i64) nounwind
declare i64 @nova_rt_tls_send(i64, i64) nounwind
declare i64 @nova_rt_tls_recv(i64, i64) nounwind
declare i64 @nova_rt_tls_close(i64) nounwind
declare i64 @nova_rt_ws_upgrade(i64) nounwind
declare i64 @nova_rt_ws_send(i64, i64) nounwind
declare i64 @nova_rt_ws_recv(i64, i64) nounwind
declare i64 @nova_rt_ws_close(i64) nounwind
declare i64 @nova_rt_node_connect(i64, i64) nounwind
declare i64 @nova_rt_node_send(i64, i64) nounwind
declare i64 @nova_rt_node_recv(i64, i64) nounwind
declare i64 @nova_rt_node_close(i64) nounwind
declare i64 @nova_rt_node_listen(i64) nounwind
declare i64 @nova_rt_node_accept(i64) nounwind
declare i64 @nova_rt_hot_reload_watch(i64) nounwind
declare i64 @nova_rt_hot_reload_check() nounwind
declare i64 @nova_rt_hot_reload_path(i64) nounwind
declare i64 @nova_rt_hot_load(i64) nounwind
declare i64 @nova_rt_hot_unload(i64) nounwind
declare i64 @nova_rt_hot_reload(i64) nounwind
declare i64 @nova_rt_hot_sym(i64, i64) nounwind
declare i64 @nova_rt_hot_call0(i64) nounwind
declare i64 @nova_rt_hot_call1(i64, i64) nounwind
declare i64 @nova_rt_hot_call2(i64, i64, i64) nounwind
declare i64 @nova_rt_hot_call3(i64, i64, i64, i64) nounwind
declare i64 @nova_rt_ws_init(i64) nounwind
declare i64 @nova_rt_ws_spawn(i64) nounwind
declare i64 @nova_rt_ws_task_count() nounwind
declare i64 @nova_rt_ws_shutdown() nounwind
declare i64 @nova_rt_io_poll_create() nounwind
declare i64 @nova_rt_io_poll_add(i64, i64, i64) nounwind
declare i64 @nova_rt_io_poll_wait(i64, i64) nounwind
declare i64 @nova_rt_io_poll_remove(i64, i64) nounwind
declare i64 @nova_rt_io_poll_close(i64) nounwind
declare i64 @nova_rt_io_set_nonblocking(i64) nounwind
declare i64 @nova_rt_wasm_compile(i64) nounwind
declare i64 @nova_rt_wasm_run(i64) nounwind
declare i64 @nova_rt_wasm_free(i64) nounwind
declare i64 @nova_rt_gpu_alloc(i64) nounwind
declare i64 @nova_rt_gpu_free(i64) nounwind
declare i64 @nova_rt_gpu_write(i64, i64, i64) nounwind
declare i64 @nova_rt_gpu_read(i64, i64) nounwind
declare i64 @nova_rt_gpu_kernel_run(i64, i64, i64, i64) nounwind
declare i64 @nova_rt_gpu_sync() nounwind
declare i64 @nova_rt_json_encode(i64) nounwind
declare i64 @nova_rt_json_encode_float(i64) nounwind
declare i64 @nova_rt_json_encode_bool(i64) nounwind
declare i64 @nova_rt_json_decode(i64) nounwind
declare i64 @nova_rt_http_close(i64) nounwind
declare i64 @nova_rt_route_match(i64, i64) nounwind
declare i64 @nova_rt_arr_create(i64) nounwind
declare i64 @nova_rt_arr_free(i64) nounwind
declare i64 @nova_rt_arr_set(i64, i64, i64) nounwind
declare i64 @nova_rt_arr_get(i64, i64) nounwind
declare i64 @nova_rt_arr_fill(i64, i64) nounwind
declare i64 @nova_rt_arr_size(i64) nounwind
declare i64 @nova_rt_arr_add(i64, i64) nounwind
declare i64 @nova_rt_arr_dot(i64, i64) nounwind
declare i64 @nova_rt_ecs_world() nounwind
declare i64 @nova_rt_ecs_entity(i64) nounwind
declare i64 @nova_rt_ecs_set(i64, i64, i64, i64) nounwind
declare i64 @nova_rt_ecs_get(i64, i64, i64) nounwind
declare i64 @nova_rt_ecs_has(i64, i64, i64) nounwind
declare i64 @nova_rt_ecs_query(i64, i64) nounwind
declare i64 @nova_rt_ecs_destroy(i64, i64) nounwind
declare i64 @nova_rt_deploy_config(i64, i64) nounwind
declare i64 @nova_rt_deploy_validate(i64) nounwind
declare i64 @nova_rt_semver_compatible(i64, i64) nounwind

; ESCAPE make_tok: allocs=1 escape=1 local=0
define i64 @make_tok(i64 %p0, i64 %p1, i64 %p2, i64 %p3) nounwind !dbg !200 {
entry:
  %slot.kind = alloca i64, align 8, !dbg !201
  store i64 %p0, ptr %slot.kind, align 8, !dbg !201
  %slot.val = alloca i64, align 8, !dbg !201
  store i64 %p1, ptr %slot.val, align 8, !dbg !201
  %slot.line = alloca i64, align 8, !dbg !201
  store i64 %p2, ptr %slot.line, align 8, !dbg !201
  %slot.col = alloca i64, align 8, !dbg !201
  store i64 %p3, ptr %slot.col, align 8, !dbg !201
  %r0 = load i64, ptr %slot.kind, align 8, !dbg !202
  %r1 = load i64, ptr %slot.val, align 8, !dbg !202
  %r2 = load i64, ptr %slot.line, align 8, !dbg !202
  %r3 = load i64, ptr %slot.col, align 8, !dbg !202
  %r4.ptr = call ptr @nova_rt_struct_alloc(i64 40), !dbg !202
  %r4.thash = getelementptr i64, ptr %r4.ptr, i64 0, !dbg !202
  store i64 193472243, ptr %r4.thash, align 8, !dbg !202
  %r4.f0 = getelementptr i64, ptr %r4.ptr, i64 1, !dbg !202
  store i64 %r0, ptr %r4.f0, align 8, !dbg !202
  %r4.f1 = getelementptr i64, ptr %r4.ptr, i64 2, !dbg !202
  store i64 %r1, ptr %r4.f1, align 8, !dbg !202
  %r4.f2 = getelementptr i64, ptr %r4.ptr, i64 3, !dbg !202
  store i64 %r2, ptr %r4.f2, align 8, !dbg !202
  %r4.f3 = getelementptr i64, ptr %r4.ptr, i64 4, !dbg !202
  store i64 %r3, ptr %r4.f3, align 8, !dbg !202
  %r4 = ptrtoint ptr %r4.ptr to i64, !dbg !202
  ret i64 %r4, !dbg !202
}

; ESCAPE Tok__show: allocs=0 escape=0 local=0
define i64 @Tok__show(i64 %p0) nounwind !dbg !203 {
entry:
  %slot.self = alloca i64, align 8, !dbg !204
  store i64 %p0, ptr %slot.self, align 8, !dbg !204
  %r0.p = getelementptr inbounds [6 x i8], ptr @.str.0, i64 0, i64 0, !dbg !205
  %r0 = ptrtoint ptr %r0.p to i64, !dbg !205
  %r1.p = getelementptr inbounds [5 x i8], ptr @.str.1, i64 0, i64 0, !dbg !205
  %r1 = ptrtoint ptr %r1.p to i64, !dbg !205
  %r2 = call i64 @nova_rt_str_concat(i64 %r0, i64 %r1), !dbg !205
  %r3 = load i64, ptr %slot.self, align 8, !dbg !205
  %r4.ptr = inttoptr i64 %r3 to ptr, !dbg !205
  %r4.gep = getelementptr i64, ptr %r4.ptr, i64 1, !dbg !205
  %r4 = load i64, ptr %r4.gep, align 8, !dbg !205
  %r5 = add i64 %r4, 0, !dbg !205
  %r6 = call i64 @nova_rt_str_concat(i64 %r2, i64 %r5), !dbg !205
  %r7.p = getelementptr inbounds [6 x i8], ptr @.str.2, i64 0, i64 0, !dbg !205
  %r7 = ptrtoint ptr %r7.p to i64, !dbg !205
  %r8 = call i64 @nova_rt_str_concat(i64 %r6, i64 %r7), !dbg !205
  %r9 = load i64, ptr %slot.self, align 8, !dbg !205
  %r10.ptr = inttoptr i64 %r9 to ptr, !dbg !205
  %r10.gep = getelementptr i64, ptr %r10.ptr, i64 2, !dbg !205
  %r10 = load i64, ptr %r10.gep, align 8, !dbg !205
  %r11 = add i64 %r10, 0, !dbg !205
  %r12 = call i64 @nova_rt_str_concat(i64 %r8, i64 %r11), !dbg !205
  %r13.p = getelementptr inbounds [7 x i8], ptr @.str.3, i64 0, i64 0, !dbg !205
  %r13 = ptrtoint ptr %r13.p to i64, !dbg !205
  %r14 = call i64 @nova_rt_str_concat(i64 %r12, i64 %r13), !dbg !205
  %r15 = load i64, ptr %slot.self, align 8, !dbg !205
  %r16.ptr = inttoptr i64 %r15 to ptr, !dbg !205
  %r16.gep = getelementptr i64, ptr %r16.ptr, i64 3, !dbg !205
  %r16 = load i64, ptr %r16.gep, align 8, !dbg !205
  %r17 = call i64 @nova_rt_int_to_str(i64 %r16), !dbg !205
  %r18 = call i64 @nova_rt_str_concat(i64 %r14, i64 %r17), !dbg !205
  %r19.p = getelementptr inbounds [7 x i8], ptr @.str.4, i64 0, i64 0, !dbg !205
  %r19 = ptrtoint ptr %r19.p to i64, !dbg !205
  %r20 = call i64 @nova_rt_str_concat(i64 %r18, i64 %r19), !dbg !205
  %r21 = load i64, ptr %slot.self, align 8, !dbg !205
  %r22.ptr = inttoptr i64 %r21 to ptr, !dbg !205
  %r22.gep = getelementptr i64, ptr %r22.ptr, i64 4, !dbg !205
  %r22 = load i64, ptr %r22.gep, align 8, !dbg !205
  %r23 = call i64 @nova_rt_int_to_str(i64 %r22), !dbg !205
  %r24 = call i64 @nova_rt_str_concat(i64 %r20, i64 %r23), !dbg !205
  %r25.p = getelementptr inbounds [3 x i8], ptr @.str.5, i64 0, i64 0, !dbg !205
  %r25 = ptrtoint ptr %r25.p to i64, !dbg !205
  %r26 = call i64 @nova_rt_str_concat(i64 %r24, i64 %r25), !dbg !205
  ret i64 %r26, !dbg !205
}

; ESCAPE Tok__to_json: allocs=0 escape=0 local=0
define i64 @Tok__to_json(i64 %p0) nounwind !dbg !206 {
entry:
  %slot.self = alloca i64, align 8, !dbg !207
  store i64 %p0, ptr %slot.self, align 8, !dbg !207
  %r0.p = getelementptr inbounds [2 x i8], ptr @.str.6, i64 0, i64 0, !dbg !208
  %r0 = ptrtoint ptr %r0.p to i64, !dbg !208
  %r1.p = getelementptr inbounds [5 x i8], ptr @.str.7, i64 0, i64 0, !dbg !208
  %r1 = ptrtoint ptr %r1.p to i64, !dbg !208
  %r2 = call i64 @nova_rt_str_concat(i64 %r0, i64 %r1), !dbg !208
  %r3 = load i64, ptr %slot.self, align 8, !dbg !208
  %r4.ptr = inttoptr i64 %r3 to ptr, !dbg !208
  %r4.gep = getelementptr i64, ptr %r4.ptr, i64 1, !dbg !208
  %r4 = load i64, ptr %r4.gep, align 8, !dbg !208
  %r5 = call i64 @nova_rt_json_stringify(i64 %r4), !dbg !208
  %r6 = call i64 @nova_rt_str_concat(i64 %r2, i64 %r5), !dbg !208
  %r7.p = getelementptr inbounds [6 x i8], ptr @.str.8, i64 0, i64 0, !dbg !208
  %r7 = ptrtoint ptr %r7.p to i64, !dbg !208
  %r8 = call i64 @nova_rt_str_concat(i64 %r6, i64 %r7), !dbg !208
  %r9 = load i64, ptr %slot.self, align 8, !dbg !208
  %r10.ptr = inttoptr i64 %r9 to ptr, !dbg !208
  %r10.gep = getelementptr i64, ptr %r10.ptr, i64 2, !dbg !208
  %r10 = load i64, ptr %r10.gep, align 8, !dbg !208
  %r11 = call i64 @nova_rt_json_stringify(i64 %r10), !dbg !208
  %r12 = call i64 @nova_rt_str_concat(i64 %r8, i64 %r11), !dbg !208
  %r13.p = getelementptr inbounds [7 x i8], ptr @.str.9, i64 0, i64 0, !dbg !208
  %r13 = ptrtoint ptr %r13.p to i64, !dbg !208
  %r14 = call i64 @nova_rt_str_concat(i64 %r12, i64 %r13), !dbg !208
  %r15 = load i64, ptr %slot.self, align 8, !dbg !208
  %r16.ptr = inttoptr i64 %r15 to ptr, !dbg !208
  %r16.gep = getelementptr i64, ptr %r16.ptr, i64 3, !dbg !208
  %r16 = load i64, ptr %r16.gep, align 8, !dbg !208
  %r17 = call i64 @nova_rt_json_stringify(i64 %r16), !dbg !208
  %r18 = call i64 @nova_rt_str_concat(i64 %r14, i64 %r17), !dbg !208
  %r19.p = getelementptr inbounds [7 x i8], ptr @.str.10, i64 0, i64 0, !dbg !208
  %r19 = ptrtoint ptr %r19.p to i64, !dbg !208
  %r20 = call i64 @nova_rt_str_concat(i64 %r18, i64 %r19), !dbg !208
  %r21 = load i64, ptr %slot.self, align 8, !dbg !208
  %r22.ptr = inttoptr i64 %r21 to ptr, !dbg !208
  %r22.gep = getelementptr i64, ptr %r22.ptr, i64 4, !dbg !208
  %r22 = load i64, ptr %r22.gep, align 8, !dbg !208
  %r23 = call i64 @nova_rt_json_stringify(i64 %r22), !dbg !208
  %r24 = call i64 @nova_rt_str_concat(i64 %r20, i64 %r23), !dbg !208
  %r25.p = getelementptr inbounds [2 x i8], ptr @.str.11, i64 0, i64 0, !dbg !208
  %r25 = ptrtoint ptr %r25.p to i64, !dbg !208
  %r26 = call i64 @nova_rt_str_concat(i64 %r24, i64 %r25), !dbg !208
  ret i64 %r26, !dbg !208
}

; ESCAPE Tok__from_json: allocs=1 escape=1 local=0
define i64 @Tok__from_json(i64 %p0) nounwind !dbg !209 {
entry:
  %slot.d = alloca i64, align 8, !dbg !210
  store i64 %p0, ptr %slot.d, align 8, !dbg !210
  %r0 = load i64, ptr %slot.d, align 8, !dbg !211
  %r1.p = getelementptr inbounds [2 x i8], ptr @.str.12, i64 0, i64 0, !dbg !211
  %r1 = ptrtoint ptr %r1.p to i64, !dbg !211
  %r2 = call i64 @nova_rt_dict_get(i64 %r0, i64 %r1), !dbg !211
  %r3 = load i64, ptr %slot.d, align 8, !dbg !211
  %r4.p = getelementptr inbounds [2 x i8], ptr @.str.13, i64 0, i64 0, !dbg !211
  %r4 = ptrtoint ptr %r4.p to i64, !dbg !211
  %r5 = call i64 @nova_rt_dict_get(i64 %r3, i64 %r4), !dbg !211
  %r6 = load i64, ptr %slot.d, align 8, !dbg !211
  %r7.p = getelementptr inbounds [3 x i8], ptr @.str.14, i64 0, i64 0, !dbg !211
  %r7 = ptrtoint ptr %r7.p to i64, !dbg !211
  %r8 = call i64 @nova_rt_dict_get(i64 %r6, i64 %r7), !dbg !211
  %r9 = load i64, ptr %slot.d, align 8, !dbg !211
  %r10.p = getelementptr inbounds [3 x i8], ptr @.str.15, i64 0, i64 0, !dbg !211
  %r10 = ptrtoint ptr %r10.p to i64, !dbg !211
  %r11 = call i64 @nova_rt_dict_get(i64 %r9, i64 %r10), !dbg !211
  %r12.ptr = call ptr @nova_rt_struct_alloc(i64 40), !dbg !211
  %r12.thash = getelementptr i64, ptr %r12.ptr, i64 0, !dbg !211
  store i64 193472243, ptr %r12.thash, align 8, !dbg !211
  %r12.f0 = getelementptr i64, ptr %r12.ptr, i64 1, !dbg !211
  store i64 %r2, ptr %r12.f0, align 8, !dbg !211
  %r12.f1 = getelementptr i64, ptr %r12.ptr, i64 2, !dbg !211
  store i64 %r5, ptr %r12.f1, align 8, !dbg !211
  %r12.f2 = getelementptr i64, ptr %r12.ptr, i64 3, !dbg !211
  store i64 %r8, ptr %r12.f2, align 8, !dbg !211
  %r12.f3 = getelementptr i64, ptr %r12.ptr, i64 4, !dbg !211
  store i64 %r11, ptr %r12.f3, align 8, !dbg !211
  %r12 = ptrtoint ptr %r12.ptr to i64, !dbg !211
  ret i64 %r12, !dbg !211
}

; ESCAPE Tok__fields: allocs=1 escape=1 local=0
define i64 @Tok__fields(i64 %p0) nounwind !dbg !212 {
entry:
  %slot.self = alloca i64, align 8, !dbg !213
  store i64 %p0, ptr %slot.self, align 8, !dbg !213
  %r1.p = getelementptr inbounds [2 x i8], ptr @.str.12, i64 0, i64 0, !dbg !214
  %r1 = ptrtoint ptr %r1.p to i64, !dbg !214
  %r2.p = getelementptr inbounds [2 x i8], ptr @.str.13, i64 0, i64 0, !dbg !214
  %r2 = ptrtoint ptr %r2.p to i64, !dbg !214
  %r3.p = getelementptr inbounds [3 x i8], ptr @.str.14, i64 0, i64 0, !dbg !214
  %r3 = ptrtoint ptr %r3.p to i64, !dbg !214
  %r4.p = getelementptr inbounds [3 x i8], ptr @.str.15, i64 0, i64 0, !dbg !214
  %r4 = ptrtoint ptr %r4.p to i64, !dbg !214
  %r0 = call i64 @nova_rt_list_create(), !dbg !214
  call i64 @nova_rt_list_append(i64 %r0, i64 %r1), !dbg !214
  call i64 @nova_rt_list_append(i64 %r0, i64 %r2), !dbg !214
  call i64 @nova_rt_list_append(i64 %r0, i64 %r3), !dbg !214
  call i64 @nova_rt_list_append(i64 %r0, i64 %r4), !dbg !214
  ret i64 %r0, !dbg !214
}

; ESCAPE Tok__type_name: allocs=0 escape=0 local=0
define i64 @Tok__type_name(i64 %p0) nounwind !dbg !215 {
entry:
  %slot.self = alloca i64, align 8, !dbg !216
  store i64 %p0, ptr %slot.self, align 8, !dbg !216
  %r0.p = getelementptr inbounds [4 x i8], ptr @.str.16, i64 0, i64 0, !dbg !217
  %r0 = ptrtoint ptr %r0.p to i64, !dbg !217
  ret i64 %r0, !dbg !217
}

; ESCAPE Tok__field_types: allocs=1 escape=1 local=0
define i64 @Tok__field_types(i64 %p0) nounwind !dbg !218 {
entry:
  %slot.self = alloca i64, align 8, !dbg !219
  store i64 %p0, ptr %slot.self, align 8, !dbg !219
  %r1.p = getelementptr inbounds [7 x i8], ptr @.str.17, i64 0, i64 0, !dbg !220
  %r1 = ptrtoint ptr %r1.p to i64, !dbg !220
  %r2.p = getelementptr inbounds [7 x i8], ptr @.str.17, i64 0, i64 0, !dbg !220
  %r2 = ptrtoint ptr %r2.p to i64, !dbg !220
  %r3.p = getelementptr inbounds [4 x i8], ptr @.str.18, i64 0, i64 0, !dbg !220
  %r3 = ptrtoint ptr %r3.p to i64, !dbg !220
  %r4.p = getelementptr inbounds [4 x i8], ptr @.str.18, i64 0, i64 0, !dbg !220
  %r4 = ptrtoint ptr %r4.p to i64, !dbg !220
  %r0 = call i64 @nova_rt_list_create(), !dbg !220
  call i64 @nova_rt_list_append(i64 %r0, i64 %r1), !dbg !220
  call i64 @nova_rt_list_append(i64 %r0, i64 %r2), !dbg !220
  call i64 @nova_rt_list_append(i64 %r0, i64 %r3), !dbg !220
  call i64 @nova_rt_list_append(i64 %r0, i64 %r4), !dbg !220
  ret i64 %r0, !dbg !220
}

; ESCAPE Tok__field_get: allocs=1 escape=0 local=1
define i64 @Tok__field_get(i64 %p0, i64 %p1) nounwind !dbg !221 {
entry:
  %slot.self = alloca i64, align 8, !dbg !222
  store i64 %p0, ptr %slot.self, align 8, !dbg !222
  %slot.name = alloca i64, align 8, !dbg !222
  store i64 %p1, ptr %slot.name, align 8, !dbg !222
  %slot._fg_box = alloca i64, align 8, !dbg !222
  store i64 0, ptr %slot._fg_box, align 8, !dbg !222
  %r0 = call i64 @nova_rt_list_create(), !dbg !223
  store i64 %r0, ptr %slot._fg_box, align 8, !dbg !223
  %r1 = load i64, ptr %slot.name, align 8, !dbg !223
  %r2.p = getelementptr inbounds [2 x i8], ptr @.str.12, i64 0, i64 0, !dbg !223
  %r2 = ptrtoint ptr %r2.p to i64, !dbg !223
  %r3.p0 = inttoptr i64 %r1 to ptr, !dbg !223
  %r3.p1 = inttoptr i64 %r2 to ptr, !dbg !223
  %r3.sc = call i32 @strcmp(ptr %r3.p0, ptr %r3.p1), !dbg !223
  %r3.cmp = icmp eq i32 %r3.sc, 0, !dbg !223
  %r3 = zext i1 %r3.cmp to i64, !dbg !223
  %br_then00 = icmp ne i64 %r3, 0, !dbg !223
  br i1 %br_then00, label %then0, label %else1, !dbg !223
then0:
  %r4 = load i64, ptr %slot._fg_box, align 8, !dbg !223
  %r5 = load i64, ptr %slot.self, align 8, !dbg !223
  %r6.ptr = inttoptr i64 %r5 to ptr, !dbg !223
  %r6.gep = getelementptr i64, ptr %r6.ptr, i64 1, !dbg !223
  %r6 = load i64, ptr %r6.gep, align 8, !dbg !223
  %r7 = call i64 @nova_rt_list_append_no_rc(i64 %r4, i64 %r6), !dbg !223
  %r8 = load i64, ptr %slot._fg_box, align 8, !dbg !223
  %r9 = add i64 0, 0, !dbg !223
  %r10.lp = inttoptr i64 %r8 to ptr, !dbg !223
  %r10.dp = load ptr, ptr %r10.lp, align 8, !tbaa !2, !dbg !223
  %r10.ep = getelementptr i64, ptr %r10.dp, i64 %r9, !dbg !223
  %r10.lv = load i64, ptr %r10.ep, align 8, !tbaa !4, !dbg !223
  %r10 = call i64 @nova_rt_unbox_elem(i64 %r10.lv), !dbg !223
  ret i64 %r10, !dbg !223
else1:
  br label %endif2, !dbg !223
endif2:
  %r11 = load i64, ptr %slot.name, align 8, !dbg !223
  %r12.p = getelementptr inbounds [2 x i8], ptr @.str.13, i64 0, i64 0, !dbg !223
  %r12 = ptrtoint ptr %r12.p to i64, !dbg !223
  %r13.p0 = inttoptr i64 %r11 to ptr, !dbg !223
  %r13.p1 = inttoptr i64 %r12 to ptr, !dbg !223
  %r13.sc = call i32 @strcmp(ptr %r13.p0, ptr %r13.p1), !dbg !223
  %r13.cmp = icmp eq i32 %r13.sc, 0, !dbg !223
  %r13 = zext i1 %r13.cmp to i64, !dbg !223
  %br_then31 = icmp ne i64 %r13, 0, !dbg !223
  br i1 %br_then31, label %then3, label %else4, !dbg !223
then3:
  %r14 = load i64, ptr %slot._fg_box, align 8, !dbg !223
  %r15 = load i64, ptr %slot.self, align 8, !dbg !223
  %r16.ptr = inttoptr i64 %r15 to ptr, !dbg !223
  %r16.gep = getelementptr i64, ptr %r16.ptr, i64 2, !dbg !223
  %r16 = load i64, ptr %r16.gep, align 8, !dbg !223
  %r17 = call i64 @nova_rt_list_append_no_rc(i64 %r14, i64 %r16), !dbg !223
  %r18 = load i64, ptr %slot._fg_box, align 8, !dbg !223
  %r19 = add i64 0, 0, !dbg !223
  %r20.lp = inttoptr i64 %r18 to ptr, !dbg !223
  %r20.dp = load ptr, ptr %r20.lp, align 8, !tbaa !2, !dbg !223
  %r20.ep = getelementptr i64, ptr %r20.dp, i64 %r19, !dbg !223
  %r20.lv = load i64, ptr %r20.ep, align 8, !tbaa !4, !dbg !223
  %r20 = call i64 @nova_rt_unbox_elem(i64 %r20.lv), !dbg !223
  ret i64 %r20, !dbg !223
else4:
  br label %endif5, !dbg !223
endif5:
  %r21 = load i64, ptr %slot.name, align 8, !dbg !223
  %r22.p = getelementptr inbounds [3 x i8], ptr @.str.14, i64 0, i64 0, !dbg !223
  %r22 = ptrtoint ptr %r22.p to i64, !dbg !223
  %r23.p0 = inttoptr i64 %r21 to ptr, !dbg !223
  %r23.p1 = inttoptr i64 %r22 to ptr, !dbg !223
  %r23.sc = call i32 @strcmp(ptr %r23.p0, ptr %r23.p1), !dbg !223
  %r23.cmp = icmp eq i32 %r23.sc, 0, !dbg !223
  %r23 = zext i1 %r23.cmp to i64, !dbg !223
  %br_then62 = icmp ne i64 %r23, 0, !dbg !223
  br i1 %br_then62, label %then6, label %else7, !dbg !223
then6:
  %r24 = load i64, ptr %slot._fg_box, align 8, !dbg !223
  %r25 = load i64, ptr %slot.self, align 8, !dbg !223
  %r26.ptr = inttoptr i64 %r25 to ptr, !dbg !223
  %r26.gep = getelementptr i64, ptr %r26.ptr, i64 3, !dbg !223
  %r26 = load i64, ptr %r26.gep, align 8, !dbg !223
  %r27 = call i64 @nova_rt_list_append_no_rc(i64 %r24, i64 %r26), !dbg !223
  %r28 = load i64, ptr %slot._fg_box, align 8, !dbg !223
  %r29 = add i64 0, 0, !dbg !223
  %r30.lp = inttoptr i64 %r28 to ptr, !dbg !223
  %r30.dp = load ptr, ptr %r30.lp, align 8, !tbaa !2, !dbg !223
  %r30.ep = getelementptr i64, ptr %r30.dp, i64 %r29, !dbg !223
  %r30.lv = load i64, ptr %r30.ep, align 8, !tbaa !4, !dbg !223
  %r30 = call i64 @nova_rt_unbox_elem(i64 %r30.lv), !dbg !223
  ret i64 %r30, !dbg !223
else7:
  br label %endif8, !dbg !223
endif8:
  %r31 = load i64, ptr %slot.name, align 8, !dbg !223
  %r32.p = getelementptr inbounds [3 x i8], ptr @.str.15, i64 0, i64 0, !dbg !223
  %r32 = ptrtoint ptr %r32.p to i64, !dbg !223
  %r33.p0 = inttoptr i64 %r31 to ptr, !dbg !223
  %r33.p1 = inttoptr i64 %r32 to ptr, !dbg !223
  %r33.sc = call i32 @strcmp(ptr %r33.p0, ptr %r33.p1), !dbg !223
  %r33.cmp = icmp eq i32 %r33.sc, 0, !dbg !223
  %r33 = zext i1 %r33.cmp to i64, !dbg !223
  %br_then93 = icmp ne i64 %r33, 0, !dbg !223
  br i1 %br_then93, label %then9, label %else10, !dbg !223
then9:
  %r34 = load i64, ptr %slot._fg_box, align 8, !dbg !223
  %r35 = load i64, ptr %slot.self, align 8, !dbg !223
  %r36.ptr = inttoptr i64 %r35 to ptr, !dbg !223
  %r36.gep = getelementptr i64, ptr %r36.ptr, i64 4, !dbg !223
  %r36 = load i64, ptr %r36.gep, align 8, !dbg !223
  %r37 = call i64 @nova_rt_list_append_no_rc(i64 %r34, i64 %r36), !dbg !223
  %r38 = load i64, ptr %slot._fg_box, align 8, !dbg !223
  %r39 = add i64 0, 0, !dbg !223
  %r40.lp = inttoptr i64 %r38 to ptr, !dbg !223
  %r40.dp = load ptr, ptr %r40.lp, align 8, !tbaa !2, !dbg !223
  %r40.ep = getelementptr i64, ptr %r40.dp, i64 %r39, !dbg !223
  %r40.lv = load i64, ptr %r40.ep, align 8, !tbaa !4, !dbg !223
  %r40 = call i64 @nova_rt_unbox_elem(i64 %r40.lv), !dbg !223
  ret i64 %r40, !dbg !223
else10:
  br label %endif11, !dbg !223
endif11:
  %r41 = add i64 0, 0, !dbg !223
  ret i64 %r41, !dbg !223
}

; ESCAPE nova_main: allocs=0 escape=0 local=0
define i64 @nova_main() nounwind {
entry:
  %slot.t1 = alloca i64, align 8
  store i64 0, ptr %slot.t1, align 8
  %slot.k = alloca i64, align 8
  store i64 0, ptr %slot.k, align 8
  %slot.v = alloca i64, align 8
  store i64 0, ptr %slot.v, align 8
  %slot.ln = alloca i64, align 8
  store i64 0, ptr %slot.ln, align 8
  %slot.co = alloca i64, align 8
  store i64 0, ptr %slot.co, align 8
  %r0.p = getelementptr inbounds [3 x i8], ptr @.str.19, i64 0, i64 0
  %r0 = ptrtoint ptr %r0.p to i64
  %r1.p = getelementptr inbounds [4 x i8], ptr @.str.20, i64 0, i64 0
  %r1 = ptrtoint ptr %r1.p to i64
  %r2 = add i64 3, 0
  %r3 = add i64 1, 0
  %r4 = call i64 @make_tok(i64 %r0, i64 %r1, i64 %r2, i64 %r3)
  store i64 %r4, ptr %slot.t1, align 8
  %r5 = load i64, ptr %slot.t1, align 8
  %r6.ptr = inttoptr i64 %r5 to ptr
  %r6.gep = getelementptr i64, ptr %r6.ptr, i64 0
  %r6 = load i64, ptr %r6.gep, align 8
  %r7 = add i64 193472243, 0
  %r8.cmp = icmp eq i64 %r6, %r7
  %r8 = zext i1 %r8.cmp to i64
  %br_marm_0130 = icmp ne i64 %r8, 0
  br i1 %br_marm_0130, label %marm_013, label %match_fall14
marm_013:
  %r9.ptr = inttoptr i64 %r5 to ptr
  %r9.gep = getelementptr i64, ptr %r9.ptr, i64 1
  %r9 = load i64, ptr %r9.gep, align 8
  store i64 %r9, ptr %slot.k, align 8
  %r10.ptr = inttoptr i64 %r5 to ptr
  %r10.gep = getelementptr i64, ptr %r10.ptr, i64 2
  %r10 = load i64, ptr %r10.gep, align 8
  store i64 %r10, ptr %slot.v, align 8
  %r11.ptr = inttoptr i64 %r5 to ptr
  %r11.gep = getelementptr i64, ptr %r11.ptr, i64 3
  %r11 = load i64, ptr %r11.gep, align 8
  store i64 %r11, ptr %slot.ln, align 8
  %r12.ptr = inttoptr i64 %r5 to ptr
  %r12.gep = getelementptr i64, ptr %r12.ptr, i64 4
  %r12 = load i64, ptr %r12.gep, align 8
  store i64 %r12, ptr %slot.co, align 8
  %r13 = load i64, ptr %slot.k, align 8
  %r14 = call i64 @nova_rt_print_str(i64 %r13)
  %r15 = load i64, ptr %slot.v, align 8
  %r16 = call i64 @nova_rt_print_str(i64 %r15)
  %r17 = load i64, ptr %slot.co, align 8
  %r18 = call i64 @nova_rt_print_int(i64 %r17)
  %r19 = load i64, ptr %slot.co, align 8
  %r20 = add i64 1, 0
  %r21.cmp = icmp sle i64 %r19, %r20
  %r21 = zext i1 %r21.cmp to i64
  %br_then151 = icmp ne i64 %r21, 0
  br i1 %br_then151, label %then15, label %else16
then15:
  %r22.p = getelementptr inbounds [12 x i8], ptr @.str.21, i64 0, i64 0
  %r22 = ptrtoint ptr %r22.p to i64
  %r23 = call i64 @nova_rt_print_str(i64 %r22)
  br label %endif17
else16:
  %r24.p = getelementptr inbounds [13 x i8], ptr @.str.22, i64 0, i64 0
  %r24 = ptrtoint ptr %r24.p to i64
  %r25 = call i64 @nova_rt_print_str(i64 %r24)
  br label %endif17
endif17:
  br label %match_exit12
match_fall14:
  br label %match_exit12
match_exit12:
  ret i64 0
}

; ESCAPE SUMMARY: allocs=5 escape=4 local=1 (20% local, RC-elidable)
define i32 @main(i32 %argc, ptr %argv) nounwind {
entry:
  %argc64 = sext i32 %argc to i64
  %argv64 = ptrtoint ptr %argv to i64
  call void @nova_rt_init_args(i64 %argc64, i64 %argv64)
  call void @nova_rt_main_dispatch(i64 ptrtoint (ptr @nova_main to i64))
  call void @nova_rt_wait_all()
  call void @nova_rt_cleanup()
  ret i32 0
}

; String constants
@.str.0 = private unnamed_addr constant [6 x i8] c"Tok {\00"
@.str.1 = private unnamed_addr constant [5 x i8] c" k: \00"
@.str.2 = private unnamed_addr constant [6 x i8] c", v: \00"
@.str.3 = private unnamed_addr constant [7 x i8] c", ln: \00"
@.str.4 = private unnamed_addr constant [7 x i8] c", co: \00"
@.str.5 = private unnamed_addr constant [3 x i8] c" }\00"
@.str.6 = private unnamed_addr constant [2 x i8] c"{\00"
@.str.7 = private unnamed_addr constant [5 x i8] c"\22k\22:\00"
@.str.8 = private unnamed_addr constant [6 x i8] c",\22v\22:\00"
@.str.9 = private unnamed_addr constant [7 x i8] c",\22ln\22:\00"
@.str.10 = private unnamed_addr constant [7 x i8] c",\22co\22:\00"
@.str.11 = private unnamed_addr constant [2 x i8] c"}\00"
@.str.12 = private unnamed_addr constant [2 x i8] c"k\00"
@.str.13 = private unnamed_addr constant [2 x i8] c"v\00"
@.str.14 = private unnamed_addr constant [3 x i8] c"ln\00"
@.str.15 = private unnamed_addr constant [3 x i8] c"co\00"
@.str.16 = private unnamed_addr constant [4 x i8] c"Tok\00"
@.str.17 = private unnamed_addr constant [7 x i8] c"string\00"
@.str.18 = private unnamed_addr constant [4 x i8] c"int\00"
@.str.19 = private unnamed_addr constant [3 x i8] c"KW\00"
@.str.20 = private unnamed_addr constant [4 x i8] c"let\00"
@.str.21 = private unnamed_addr constant [12 x i8] c"col<=1 TRUE\00"
@.str.22 = private unnamed_addr constant [13 x i8] c"col<=1 FALSE\00"

; Debug metadata
!llvm.dbg.cu = !{!100}
!llvm.module.flags = !{!102, !103}

!100 = distinct !DICompileUnit(language: DW_LANG_C99, file: !101, producer: "NOVA Compiler", isOptimized: false, emissionKind: LineTablesOnly)
!101 = !DIFile(filename: "selfhost_tinyB.nova", directory: ".")
!102 = !{i32 2, !"CodeView", i32 1}
!103 = !{i32 2, !"Debug Info Version", i32 3}
!104 = !DISubroutineType(types: !105)
!105 = !{null}
!200 = distinct !DISubprogram(name: "make_tok", scope: !101, file: !101, line: 7, type: !104, scopeLine: 7, spFlags: DISPFlagDefinition, unit: !100)
!201 = !DILocation(line: 7, column: 0, scope: !200)
!203 = distinct !DISubprogram(name: "Tok__show", scope: !101, file: !101, line: 1, type: !104, scopeLine: 1, spFlags: DISPFlagDefinition, unit: !100)
!204 = !DILocation(line: 1, column: 0, scope: !203)
!206 = distinct !DISubprogram(name: "Tok__to_json", scope: !101, file: !101, line: 1, type: !104, scopeLine: 1, spFlags: DISPFlagDefinition, unit: !100)
!207 = !DILocation(line: 1, column: 0, scope: !206)
!209 = distinct !DISubprogram(name: "Tok__from_json", scope: !101, file: !101, line: 1, type: !104, scopeLine: 1, spFlags: DISPFlagDefinition, unit: !100)
!210 = !DILocation(line: 1, column: 0, scope: !209)
!212 = distinct !DISubprogram(name: "Tok__fields", scope: !101, file: !101, line: 1, type: !104, scopeLine: 1, spFlags: DISPFlagDefinition, unit: !100)
!213 = !DILocation(line: 1, column: 0, scope: !212)
!215 = distinct !DISubprogram(name: "Tok__type_name", scope: !101, file: !101, line: 1, type: !104, scopeLine: 1, spFlags: DISPFlagDefinition, unit: !100)
!216 = !DILocation(line: 1, column: 0, scope: !215)
!218 = distinct !DISubprogram(name: "Tok__field_types", scope: !101, file: !101, line: 1, type: !104, scopeLine: 1, spFlags: DISPFlagDefinition, unit: !100)
!219 = !DILocation(line: 1, column: 0, scope: !218)
!221 = distinct !DISubprogram(name: "Tok__field_get", scope: !101, file: !101, line: 1, type: !104, scopeLine: 1, spFlags: DISPFlagDefinition, unit: !100)
!222 = !DILocation(line: 1, column: 0, scope: !221)
!202 = !DILocation(line: 8, column: 0, scope: !200)
!205 = !DILocation(line: 1, column: 0, scope: !203)
!208 = !DILocation(line: 1, column: 0, scope: !206)
!211 = !DILocation(line: 1, column: 0, scope: !209)
!214 = !DILocation(line: 1, column: 0, scope: !212)
!217 = !DILocation(line: 1, column: 0, scope: !215)
!220 = !DILocation(line: 1, column: 0, scope: !218)
!223 = !DILocation(line: 1, column: 0, scope: !221)

; TBAA metadata
!0 = !{!"NOVA TBAA"}
!1 = !{!"list_data_ptr", !0}
!2 = !{!1, !1, i64 0}
!3 = !{!"list_elem", !0}
!4 = !{!3, !3, i64 0}
!5 = !{!"list_size", !0}
!6 = !{!5, !5, i64 0}
!90 = !{!"branch_weights", i32 2000, i32 1}
