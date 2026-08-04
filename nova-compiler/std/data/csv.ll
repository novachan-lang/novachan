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
declare i64 @nova_rt_list_append_fraw(i64, i64) nounwind
declare i64 @nova_rt_list_get_f(i64, i64) nounwind
declare i64 @nova_rt_list_append_bbox(i64, i64) nounwind
declare i64 @nova_rt_list_pop(i64) nounwind
declare i64 @nova_rt_list_insert(i64, i64, i64) nounwind
declare i64 @nova_rt_list_remove(i64, i64) nounwind
declare i64 @nova_rt_dict_get_default(i64, i64, i64) nounwind
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
declare i64 @nova_rt_is_space(i64) nounwind readonly
declare i64 @nova_rt_is_upper(i64) nounwind readonly
declare i64 @nova_rt_is_lower(i64) nounwind readonly
declare i64 @nova_rt_is_digit(i64) nounwind readonly
declare i64 @nova_rt_is_alpha(i64) nounwind readonly
declare i64 @nova_rt_is_alnum(i64) nounwind readonly
declare i64 @nova_rt_ushr(i64, i64) nounwind readnone
declare i64 @nova_rt_udiv(i64, i64) nounwind readnone
declare i64 @nova_rt_urem(i64, i64) nounwind readnone
declare i64 @nova_rt_ult(i64, i64) nounwind readnone
declare i64 @nova_rt_ugt(i64, i64) nounwind readnone
declare i64 @nova_rt_ule(i64, i64) nounwind readnone
declare i64 @nova_rt_uge(i64, i64) nounwind readnone
declare i64 @nova_rt_contains(i64, i64) nounwind readonly
declare i64 @nova_rt_index_get(i64, i64) nounwind readonly
declare i64 @nova_rt_index_set(i64, i64, i64) nounwind
declare i64 @nova_rt_add(i64, i64) nounwind
declare i64 @nova_rt_sub(i64, i64) nounwind
declare i64 @nova_rt_mul(i64, i64) nounwind
declare i64 @nova_rt_div(i64, i64) nounwind
declare i64 @nova_rt_mod(i64, i64) nounwind
declare i64 @nova_rt_neg(i64) nounwind
declare i64 @nova_rt_truthy(i64) nounwind readonly
declare i64 @nova_rt_eq(i64, i64) nounwind readonly
declare i64 @nova_rt_neq(i64, i64) nounwind readonly
declare i64 @nova_rt_any_to_str(i64) nounwind
declare void @nova_rt_assert(i64, i64) nounwind
declare i64 @nova_rt_read_file(i64) nounwind
declare i64 @nova_rt_write_file(i64, i64) nounwind
declare i64 @nova_rt_remove_file(i64) nounwind
declare i64 @nova_rt_remove_dir(i64) nounwind
declare i64 @nova_rt_rename_path(i64, i64) nounwind
declare i64 @nova_rt_chmod(i64, i64) nounwind
declare i64 @nova_rt_umask(i64) nounwind
declare i64 @nova_rt_symlink(i64, i64) nounwind
declare i64 @nova_rt_readlink(i64) nounwind
declare i64 @nova_rt_copy_file(i64, i64) nounwind
declare i64 @nova_rt_file_size(i64) nounwind
declare i64 @nova_rt_file_mtime(i64) nounwind
declare i64 @nova_rt_rc_drop_reassign(i64, i64) nounwind
declare i64 @nova_rt_is_dir(i64) nounwind
declare i64 @nova_rt_make_dir(i64) nounwind
declare i64 @nova_rt_file_chmod(i64, i64) nounwind
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
declare i64 @nova_rt_splitlines(i64) nounwind
declare i64 @nova_rt_partition(i64, i64) nounwind
declare i64 @nova_rt_rpartition(i64, i64) nounwind
declare i64 @nova_rt_rsplit(i64, i64) nounwind
declare i64 @nova_rt_upper(i64) nounwind
declare i64 @nova_rt_lower(i64) nounwind
declare i64 @nova_rt_normalize_nfc(i64) nounwind
declare i64 @nova_rt_normalize_nfd(i64) nounwind
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
declare i64 @nova_rt_float_from_bits(i64) nounwind
declare i64 @nova_rt_float_to_bits(i64) nounwind
declare i64 @nova_rt_f32_from_bits(i64) nounwind
declare i64 @nova_rt_float_to_str(i64) nounwind
declare ptr @nova_rt_struct_alloc(i64) nounwind
declare ptr @nova_rt_hashed_struct_alloc(i64) nounwind
declare void @nova_rc_inc(i64) nounwind
declare i64 @nova_rt_field_set(i64, i64, i64, i64) nounwind
declare void @nova_rt_register_struct_bitmap(i64, i64) nounwind
declare double @llvm.sqrt.f64(double)
declare double @llvm.sin.f64(double)
declare double @llvm.cos.f64(double)
declare double @llvm.exp.f64(double)
declare double @llvm.log.f64(double)
declare double @llvm.log2.f64(double)
declare double @llvm.log10.f64(double)
declare double @llvm.fabs.f64(double)
declare double @llvm.floor.f64(double)
declare double @llvm.ceil.f64(double)
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
declare i64 @nova_rt_type_pred(i64, i64) nounwind
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
declare i64 @nova_rt_memo_lock() nounwind
declare i64 @nova_rt_memo_unlock() nounwind
declare i64 @nova_rt_dict_del(i64, i64) nounwind
declare i64 @nova_rt_system(i64) nounwind
declare i64 @nova_rt_exec(i64) nounwind
declare i64 @nova_rt_proc_open(i64) nounwind
declare i64 @nova_rt_proc_write_stdin(i64, i64) nounwind
declare i64 @nova_rt_proc_read_stdout(i64) nounwind
declare i64 @nova_rt_proc_close_stdin(i64) nounwind
declare i64 @nova_rt_proc_wait(i64) nounwind
declare i64 @nova_rt_shell(i64) nounwind
declare void @nova_rt_register_struct_name(i64, i64) nounwind
declare void @nova_rt_register_struct_meta(i64, i64, i64) nounwind
declare void @nova_rt_register_struct_field(i64, i64, i64, i64) nounwind
declare i64 @nova_rt_field_names(i64) nounwind
declare i64 @nova_rt_field_types(i64) nounwind
declare i64 @nova_rt_field_get(i64, i64) nounwind
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
declare i64 @nova_rt_select_timeout(i64, i64) nounwind
declare i64 @nova_rt_channel_recv_timeout(i64, i64) nounwind
declare i64 @nova_rt_try_recv(i64) nounwind
declare i64 @nova_rt_try_send(i64, i64) nounwind
declare i64 @nova_rt_self() nounwind
declare i64 @nova_rt_mailbox_of(i64) nounwind
declare i64 @nova_rt_pid_send(i64, i64) nounwind
declare i64 @nova_rt_receive() nounwind
declare i64 @nova_rt_mailbox_len(i64) nounwind
declare i64 @nova_rt_try_receive() nounwind
declare i64 @nova_rt_recv_begin() nounwind
declare i64 @nova_rt_recv_next() nounwind
declare i64 @nova_rt_recv_commit() nounwind
declare i64 @nova_rt_recv_defer() nounwind
declare i64 @nova_rt_recv_begin_timed(i64) nounwind
declare i64 @nova_rt_recv_next_timed() nounwind
declare i64 @nova_rt_recv_timed_out() nounwind
declare i64 @nova_rt_list_remove_at(i64, i64) nounwind
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
declare i64 @nova_rt_file_read_bytes(i64, i64) nounwind
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
declare i64 @nova_rt_isnan(i64) nounwind readnone
declare i64 @nova_rt_isinf(i64) nounwind readnone
declare i64 @nova_rt_clamp(i64, i64, i64) nounwind readnone
declare i64 @nova_rt_copysign(i64, i64) nounwind readnone
declare i64 @nova_rt_fma(i64, i64, i64) nounwind readnone
declare i64 @nova_rt_nextafter(i64, i64) nounwind readnone
declare i64 @nova_rt_lgamma(i64) nounwind readnone
declare i64 @nova_rt_erf(i64) nounwind readnone
declare i64 @nova_rt_rng_new(i64) nounwind
declare i64 @nova_rt_rng_next(i64) nounwind
declare i64 @nova_rt_rng_int(i64, i64) nounwind
declare i64 @nova_rt_rng_float(i64) nounwind
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
declare i64 @nova_rt_to_u8(i64) nounwind readnone
declare i64 @nova_rt_to_u16(i64) nounwind readnone
declare i64 @nova_rt_to_u32(i64) nounwind readnone
declare i64 @nova_rt_to_u64(i64) nounwind readnone
declare i64 @nova_rt_to_i8(i64) nounwind readnone
declare i64 @nova_rt_to_i16(i64) nounwind readnone
declare i64 @nova_rt_to_i32(i64) nounwind readnone
declare i64 @nova_rt_to_i64(i64) nounwind readnone
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
declare i64 @nova_rt_regex_captures(i64, i64) nounwind
declare i64 @nova_rt_regex_named_captures(i64, i64) nounwind
declare i64 @nova_rt_regex_replace_all(i64, i64, i64) nounwind
declare i64 @nova_rt_path_ext(i64) nounwind
declare i64 @nova_rt_tcp_connect(i64, i64) nounwind
declare i64 @nova_rt_tcp_listen(i64) nounwind
declare i64 @nova_rt_tcp_accept(i64) nounwind
declare i64 @nova_rt_tcp_send(i64, i64) nounwind
declare i64 @nova_rt_tcp_send_bytes(i64, i64) nounwind
declare i64 @nova_rt_tcp_recv(i64) nounwind
declare i64 @nova_rt_tcp_recv_bytes(i64) nounwind
declare i64 @nova_rt_tcp_wait_readable(i64, i64) nounwind
declare i64 @nova_rt_udp_bind(i64) nounwind
declare i64 @nova_rt_udp_send(i64, i64, i64, i64) nounwind
declare i64 @nova_rt_udp_recv(i64) nounwind
declare i64 @nova_rt_udp_recv_from(i64) nounwind
declare i64 @nova_rt_socket_option(i64, i64, i64) nounwind
declare void @nova_rt_tcp_close(i64) nounwind
declare i64 @nova_rt_remote_connect(i64, i64) nounwind
declare i64 @nova_rt_remote_listen(i64) nounwind
declare i64 @nova_rt_remote_bind(i64) nounwind
declare i64 @nova_rt_remote_accept(i64) nounwind
declare i64 @nova_rt_remote_send(i64, i64) nounwind
declare i64 @nova_rt_remote_recv(i64) nounwind
declare i64 @nova_rt_remote_close(i64) nounwind
declare i64 @nova_rt_remote_spawn(i64, i64, i64) nounwind
declare i64 @nova_rt_call_by_name(i64, i64) nounwind
declare void @nova_rt_register_fn(i64, i64, i64) nounwind
declare i64 @nova_rt_const_set(i64, i64) nounwind
declare i64 @nova_rt_const_get(i64) nounwind readonly
declare i64 @nova_rt_bytes_create(i64) nounwind
declare i64 @nova_rt_bytes_get(i64, i64) nounwind
declare void @nova_rt_bytes_set(i64, i64, i64) nounwind
declare i64 @nova_rt_bytes_len(i64) nounwind
declare i64 @nova_rt_bytes_slice(i64, i64, i64) nounwind
declare i64 @nova_rt_bytes_concat(i64, i64) nounwind
declare i64 @nova_rt_bytes_append(i64, i64) nounwind
declare i64 @nova_rt_bytes_append_str(i64, i64) nounwind
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
declare i64 @nova_rt_set_from_list(i64) nounwind
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
declare i64 @nova_rt_self_exe_path() nounwind
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
declare i64 @nova_rt_sha256_of_bytes(i64) nounwind
declare i64 @nova_rt_sha256_bytes(i64, i64) nounwind
declare i64 @nova_rt_hmac_sha256(i64, i64) nounwind
declare i64 @nova_rt_hex_encode(i64) nounwind
declare i64 @nova_rt_hex_decode(i64) nounwind
declare i64 @nova_rt_base64_encode(i64) nounwind
declare i64 @nova_rt_base64_decode(i64) nounwind
declare i64 @nova_rt_uuid4() nounwind
declare i64 @nova_rt_random_bytes(i64) nounwind
declare i64 @nova_rt_secure_bytes(i64) nounwind
declare i64 @nova_rt_secure_zero(i64) nounwind
declare i64 @nova_rt_ct_eq(i64, i64) nounwind
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
declare i64 @nova_rt_sched_spawn_on(i64, i64) nounwind
declare i64 @nova_rt_sched_carrier_count() nounwind
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
declare i64 @nova_rt_list_is_kind2(i64) nounwind readonly
declare i64 @nova_rt_floatlist_view(i64) nounwind readnone
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
declare i64 @nova_rt_tensor_exp(i64) nounwind
declare i64 @nova_rt_tensor_softmax(i64) nounwind
declare i64 @nova_rt_tensor_transpose(i64) nounwind
declare i64 @nova_rt_tensor_reshape(i64, i64) nounwind
declare i64 @nova_rt_tensor_sigmoid(i64) nounwind
declare i64 @nova_rt_tensor_tanh(i64) nounwind
declare i64 @nova_rt_tensor_log(i64) nounwind
declare i64 @nova_rt_tensor_argmax(i64) nounwind
declare i64 @nova_rt_tensor_sub(i64, i64) nounwind
declare i64 @nova_rt_tensor_div(i64, i64) nounwind
declare i64 @nova_rt_tensor_add_bias(i64, i64) nounwind
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
declare i64 @nova_rt_arena_scope_enter() nounwind
declare i64 @nova_rt_arena_scope_exit(i64) nounwind
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
declare i64 @nova_rt_ptr_read_u8(i64) nounwind readonly
declare i64 @nova_rt_ptr_read_i8(i64) nounwind readonly
declare i64 @nova_rt_ptr_read_u16(i64) nounwind readonly
declare i64 @nova_rt_ptr_read_i16(i64) nounwind readonly
declare i64 @nova_rt_ptr_read_u32(i64) nounwind readonly
declare i64 @nova_rt_ptr_read_i32(i64) nounwind readonly
declare i64 @nova_rt_ptr_read_u64(i64) nounwind readonly
declare i64 @nova_rt_ptr_read_f32(i64) nounwind readonly
declare i64 @nova_rt_ptr_read_f64(i64) nounwind readonly
declare i64 @nova_rt_ptr_write_u8(i64, i64) nounwind
declare i64 @nova_rt_ptr_write_u16(i64, i64) nounwind
declare i64 @nova_rt_ptr_write_u32(i64, i64) nounwind
declare i64 @nova_rt_ptr_write_u64(i64, i64) nounwind
declare i64 @nova_rt_ptr_write_f32(i64, i64) nounwind
declare i64 @nova_rt_ptr_write_f64(i64, i64) nounwind
declare i64 @nova_rt_offheap_get_f64(i64, i64) nounwind readonly
declare i64 @nova_rt_offheap_set_f64(i64, i64, i64) nounwind
declare i64 @nova_rt_ptr_add(i64, i64) nounwind
declare i64 @nova_rt_ptr_diff(i64, i64) nounwind
declare i64 @nova_rt_memcpy_unsafe(i64, i64, i64) nounwind
declare i64 @nova_rt_memset_unsafe(i64, i64, i64) nounwind
declare i64 @nova_rt_sizeof_ptr() nounwind
declare i64 @nova_rt_shutdown_requested() nounwind
declare i64 @nova_rt_reload_requested() nounwind
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
declare i64 @nova_rt_tls_connect_insecure(i64, i64) nounwind
declare i64 @nova_rt_tls_connect_alpn(i64, i64, i64) nounwind
declare i64 @nova_rt_tls_alpn(i64) nounwind
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

; ESCAPE csv_parse: allocs=3 escape=1 local=2
define i64 @csv_parse(i64 %p0) nounwind uwtable !dbg !200 {
entry:
  %slot.text = alloca i64, align 8, !dbg !201
  store i64 %p0, ptr %slot.text, align 8, !dbg !201
  %slot.quote = alloca i64, align 8, !dbg !201
  store i64 0, ptr %slot.quote, align 8, !dbg !201
  %slot.comma_ch = alloca i64, align 8, !dbg !201
  store i64 0, ptr %slot.comma_ch, align 8, !dbg !201
  %slot.lf = alloca i64, align 8, !dbg !201
  store i64 0, ptr %slot.lf, align 8, !dbg !201
  %slot.cr = alloca i64, align 8, !dbg !201
  store i64 0, ptr %slot.cr, align 8, !dbg !201
  %slot.bts = alloca i64, align 8, !dbg !201
  store i64 0, ptr %slot.bts, align 8, !dbg !201
  %slot.buf = alloca i64, align 8, !dbg !201
  store i64 0, ptr %slot.buf, align 8, !dbg !201
  %slot.row = alloca i64, align 8, !dbg !201
  store i64 0, ptr %slot.row, align 8, !dbg !201
  %slot.rows = alloca i64, align 8, !dbg !201
  store i64 0, ptr %slot.rows, align 8, !dbg !201
  %slot.in_quotes = alloca i64, align 8, !dbg !201
  store i64 0, ptr %slot.in_quotes, align 8, !dbg !201
  %slot.saw_char = alloca i64, align 8, !dbg !201
  store i64 0, ptr %slot.saw_char, align 8, !dbg !201
  %slot.i = alloca i64, align 8, !dbg !201
  store i64 0, ptr %slot.i, align 8, !dbg !201
  %slot.n = alloca i64, align 8, !dbg !201
  store i64 0, ptr %slot.n, align 8, !dbg !201
  %slot.c = alloca i64, align 8, !dbg !201
  store i64 0, ptr %slot.c, align 8, !dbg !201
  %slot.__sc_9 = alloca i64, align 8, !dbg !201
  store i64 0, ptr %slot.__sc_9, align 8, !dbg !201
  %slot.__sc_15 = alloca i64, align 8, !dbg !201
  store i64 0, ptr %slot.__sc_15, align 8, !dbg !201
  %slot.__sc_30 = alloca i64, align 8, !dbg !201
  store i64 0, ptr %slot.__sc_30, align 8, !dbg !201
  %slot.__sc_33 = alloca i64, align 8, !dbg !201
  store i64 0, ptr %slot.__sc_33, align 8, !dbg !201
  %r0 = add i64 34, 0, !dbg !202
  store i64 %r0, ptr %slot.quote, align 8, !dbg !202
  %r1 = add i64 44, 0, !dbg !203
  store i64 %r1, ptr %slot.comma_ch, align 8, !dbg !203
  %r2 = add i64 10, 0, !dbg !204
  store i64 %r2, ptr %slot.lf, align 8, !dbg !204
  %r3 = add i64 13, 0, !dbg !205
  store i64 %r3, ptr %slot.cr, align 8, !dbg !205
  %r4 = load i64, ptr %slot.text, align 8, !dbg !206
  %r5 = call i64 @nova_rt_str_to_bytes(i64 %r4), !dbg !206
  store i64 %r5, ptr %slot.bts, align 8, !dbg !206
  %r6 = call i64 @nova_rt_buffer_create(), !dbg !207
  store i64 %r6, ptr %slot.buf, align 8, !dbg !207
  %r7 = call i64 @nova_rt_list_create(), !dbg !208
  store i64 %r7, ptr %slot.row, align 8, !dbg !208
  %r8 = call i64 @nova_rt_list_create(), !dbg !209
  store i64 %r8, ptr %slot.rows, align 8, !dbg !209
  %r9 = add i64 0, 0, !dbg !210
  store i64 %r9, ptr %slot.in_quotes, align 8, !dbg !210
  %r10 = add i64 0, 0, !dbg !211
  store i64 %r10, ptr %slot.saw_char, align 8, !dbg !211
  %r11 = add i64 0, 0, !dbg !212
  store i64 %r11, ptr %slot.i, align 8, !dbg !212
  %r12 = add i64 %r5, 0, !dbg !213
  %r13 = call i64 @nova_rt_bytes_len(i64 %r12), !dbg !213
  store i64 %r13, ptr %slot.n, align 8, !dbg !213
  br label %while_hdr0, !dbg !214
while_hdr0:
  %r14 = load i64, ptr %slot.i, align 8, !dbg !214
  %r15 = load i64, ptr %slot.n, align 8, !dbg !214
  %r16.cmp = icmp slt i64 %r14, %r15, !dbg !214
  %r16 = zext i1 %r16.cmp to i64, !dbg !214
  %br_while_body10 = icmp ne i64 %r16, 0, !dbg !214
  br i1 %br_while_body10, label %while_body1, label %while_exit2, !prof !90, !dbg !214
while_body1:
  %r17 = load i64, ptr %slot.bts, align 8, !dbg !215
  %r18 = load i64, ptr %slot.i, align 8, !dbg !215
  %r19 = call i64 @nova_rt_bytes_get(i64 %r17, i64 %r18), !dbg !215
  store i64 %r19, ptr %slot.c, align 8, !dbg !215
  %r20 = add i64 1, 0, !dbg !216
  store i64 %r20, ptr %slot.saw_char, align 8, !dbg !216
  %r21 = load i64, ptr %slot.in_quotes, align 8, !dbg !217
  %br_then31 = icmp ne i64 %r21, 0, !dbg !217
  br i1 %br_then31, label %then3, label %else4, !dbg !217
then3:
  %r22 = load i64, ptr %slot.c, align 8, !dbg !218
  %r23 = load i64, ptr %slot.quote, align 8, !dbg !218
  %r24.cmp = icmp eq i64 %r22, %r23, !dbg !218
  %r24 = zext i1 %r24.cmp to i64, !dbg !218
  %br_then62 = icmp ne i64 %r24, 0, !dbg !218
  br i1 %br_then62, label %then6, label %else7, !dbg !218
then6:
  %r25 = load i64, ptr %slot.i, align 8, !dbg !219
  %r26 = add i64 1, 0, !dbg !219
  %r27 = add i64 %r25, %r26, !dbg !219
  %r28 = load i64, ptr %slot.n, align 8, !dbg !219
  %r29.cmp = icmp slt i64 %r27, %r28, !dbg !219
  %r29 = zext i1 %r29.cmp to i64, !dbg !219
  store i64 %r29, ptr %slot.__sc_9, align 8, !dbg !219
  %br_and_rhs103 = icmp ne i64 %r29, 0, !dbg !219
  br i1 %br_and_rhs103, label %and_rhs10, label %and_merge11, !dbg !219
and_rhs10:
  %r30 = load i64, ptr %slot.bts, align 8, !dbg !219
  %r31 = load i64, ptr %slot.i, align 8, !dbg !219
  %r32 = add i64 1, 0, !dbg !219
  %r33 = add i64 %r31, %r32, !dbg !219
  %r34 = call i64 @nova_rt_bytes_get(i64 %r30, i64 %r33), !dbg !219
  %r35 = load i64, ptr %slot.quote, align 8, !dbg !219
  %r36.cmp = icmp eq i64 %r34, %r35, !dbg !219
  %r36 = zext i1 %r36.cmp to i64, !dbg !219
  store i64 %r36, ptr %slot.__sc_9, align 8, !dbg !219
  br label %and_merge11, !dbg !219
and_merge11:
  %r37 = load i64, ptr %slot.__sc_9, align 8, !dbg !219
  %br_then124 = icmp ne i64 %r37, 0, !dbg !219
  br i1 %br_then124, label %then12, label %else13, !dbg !219
then12:
  %r38 = load i64, ptr %slot.buf, align 8, !dbg !220
  %r39 = load i64, ptr %slot.quote, align 8, !dbg !220
  %r40 = call i64 @nova_rt_buffer_append_char(i64 %r38, i64 %r39), !dbg !220
  %r41 = load i64, ptr %slot.i, align 8, !dbg !221
  %r42 = add i64 2, 0, !dbg !221
  %r43 = add i64 %r41, %r42, !dbg !221
  store i64 %r43, ptr %slot.i, align 8, !dbg !221
  br label %endif14, !dbg !221
else13:
  %r44 = add i64 0, 0, !dbg !222
  store i64 %r44, ptr %slot.in_quotes, align 8, !dbg !222
  %r45 = load i64, ptr %slot.i, align 8, !dbg !223
  %r46 = add i64 1, 0, !dbg !223
  %r47 = add i64 %r45, %r46, !dbg !223
  store i64 %r47, ptr %slot.i, align 8, !dbg !223
  br label %endif14, !dbg !223
endif14:
  br label %endif8, !dbg !223
else7:
  %r48 = load i64, ptr %slot.buf, align 8, !dbg !224
  %r49 = load i64, ptr %slot.c, align 8, !dbg !224
  %r50 = call i64 @nova_rt_buffer_append_char(i64 %r48, i64 %r49), !dbg !224
  %r51 = load i64, ptr %slot.i, align 8, !dbg !225
  %r52 = add i64 1, 0, !dbg !225
  %r53 = add i64 %r51, %r52, !dbg !225
  store i64 %r53, ptr %slot.i, align 8, !dbg !225
  br label %endif8, !dbg !225
endif8:
  br label %endif5, !dbg !225
else4:
  %r54 = load i64, ptr %slot.c, align 8, !dbg !226
  %r55 = load i64, ptr %slot.quote, align 8, !dbg !226
  %r56.cmp = icmp eq i64 %r54, %r55, !dbg !226
  %r56 = zext i1 %r56.cmp to i64, !dbg !226
  store i64 %r56, ptr %slot.__sc_15, align 8, !dbg !226
  %br_and_rhs165 = icmp ne i64 %r56, 0, !dbg !226
  br i1 %br_and_rhs165, label %and_rhs16, label %and_merge17, !dbg !226
and_rhs16:
  %r57 = load i64, ptr %slot.buf, align 8, !dbg !226
  %r58 = call i64 @nova_rt_buffer_len(i64 %r57), !dbg !226
  %r59 = add i64 0, 0, !dbg !226
  %r60.cmp = icmp eq i64 %r58, %r59, !dbg !226
  %r60 = zext i1 %r60.cmp to i64, !dbg !226
  store i64 %r60, ptr %slot.__sc_15, align 8, !dbg !226
  br label %and_merge17, !dbg !226
and_merge17:
  %r61 = load i64, ptr %slot.__sc_15, align 8, !dbg !226
  %br_then186 = icmp ne i64 %r61, 0, !dbg !226
  br i1 %br_then186, label %then18, label %else19, !dbg !226
then18:
  %r62 = add i64 1, 0, !dbg !227
  store i64 %r62, ptr %slot.in_quotes, align 8, !dbg !227
  %r63 = load i64, ptr %slot.i, align 8, !dbg !228
  %r64 = add i64 1, 0, !dbg !228
  %r65 = add i64 %r63, %r64, !dbg !228
  store i64 %r65, ptr %slot.i, align 8, !dbg !228
  br label %endif20, !dbg !228
else19:
  %r66 = load i64, ptr %slot.c, align 8, !dbg !229
  %r67 = load i64, ptr %slot.comma_ch, align 8, !dbg !229
  %r68.cmp = icmp eq i64 %r66, %r67, !dbg !229
  %r68 = zext i1 %r68.cmp to i64, !dbg !229
  %br_then217 = icmp ne i64 %r68, 0, !dbg !229
  br i1 %br_then217, label %then21, label %else22, !dbg !229
then21:
  %r69 = load i64, ptr %slot.row, align 8, !dbg !230
  %r70 = load i64, ptr %slot.buf, align 8, !dbg !230
  %r71 = call i64 @nova_rt_buffer_to_str(i64 %r70), !dbg !230
  %r72 = call i64 @nova_rt_list_append_no_rc(i64 %r69, i64 %r71), !dbg !230
  %r73 = call i64 @nova_rt_buffer_create(), !dbg !231
  store i64 %r73, ptr %slot.buf, align 8, !dbg !231
  %r74 = load i64, ptr %slot.i, align 8, !dbg !232
  %r75 = add i64 1, 0, !dbg !232
  %r76 = add i64 %r74, %r75, !dbg !232
  store i64 %r76, ptr %slot.i, align 8, !dbg !232
  br label %endif23, !dbg !232
else22:
  %r77 = load i64, ptr %slot.c, align 8, !dbg !233
  %r78 = load i64, ptr %slot.cr, align 8, !dbg !233
  %r79.cmp = icmp eq i64 %r77, %r78, !dbg !233
  %r79 = zext i1 %r79.cmp to i64, !dbg !233
  %br_then248 = icmp ne i64 %r79, 0, !dbg !233
  br i1 %br_then248, label %then24, label %else25, !dbg !233
then24:
  %r80 = load i64, ptr %slot.i, align 8, !dbg !234
  %r81 = add i64 1, 0, !dbg !234
  %r82 = add i64 %r80, %r81, !dbg !234
  store i64 %r82, ptr %slot.i, align 8, !dbg !234
  br label %endif26, !dbg !234
else25:
  %r83 = load i64, ptr %slot.c, align 8, !dbg !235
  %r84 = load i64, ptr %slot.lf, align 8, !dbg !235
  %r85.cmp = icmp eq i64 %r83, %r84, !dbg !235
  %r85 = zext i1 %r85.cmp to i64, !dbg !235
  %br_then279 = icmp ne i64 %r85, 0, !dbg !235
  br i1 %br_then279, label %then27, label %else28, !dbg !235
then27:
  %r86 = load i64, ptr %slot.row, align 8, !dbg !236
  %r87 = load i64, ptr %slot.buf, align 8, !dbg !236
  %r88 = call i64 @nova_rt_buffer_to_str(i64 %r87), !dbg !236
  %r89 = call i64 @nova_rt_list_append_no_rc(i64 %r86, i64 %r88), !dbg !236
  %r90 = call i64 @nova_rt_buffer_create(), !dbg !237
  store i64 %r90, ptr %slot.buf, align 8, !dbg !237
  %r91 = load i64, ptr %slot.rows, align 8, !dbg !238
  %r92 = load i64, ptr %slot.row, align 8, !dbg !238
  %r93 = call i64 @nova_rt_list_append(i64 %r91, i64 %r92), !dbg !238
  %r94 = call i64 @nova_rt_list_create(), !dbg !239
  store i64 %r94, ptr %slot.row, align 8, !dbg !239
  %r95 = add i64 0, 0, !dbg !240
  store i64 %r95, ptr %slot.saw_char, align 8, !dbg !240
  %r96 = load i64, ptr %slot.i, align 8, !dbg !241
  %r97 = add i64 1, 0, !dbg !241
  %r98 = add i64 %r96, %r97, !dbg !241
  store i64 %r98, ptr %slot.i, align 8, !dbg !241
  br label %endif29, !dbg !241
else28:
  %r99 = load i64, ptr %slot.buf, align 8, !dbg !242
  %r100 = load i64, ptr %slot.c, align 8, !dbg !242
  %r101 = call i64 @nova_rt_buffer_append_char(i64 %r99, i64 %r100), !dbg !242
  %r102 = load i64, ptr %slot.i, align 8, !dbg !243
  %r103 = add i64 1, 0, !dbg !243
  %r104 = add i64 %r102, %r103, !dbg !243
  store i64 %r104, ptr %slot.i, align 8, !dbg !243
  br label %endif29, !dbg !243
endif29:
  br label %endif26, !dbg !243
endif26:
  br label %endif23, !dbg !243
endif23:
  br label %endif20, !dbg !243
endif20:
  br label %endif5, !dbg !243
endif5:
  br label %while_hdr0, !dbg !243
while_exit2:
  %r105 = load i64, ptr %slot.buf, align 8, !dbg !244
  %r106 = call i64 @nova_rt_buffer_len(i64 %r105), !dbg !244
  %r107 = add i64 0, 0, !dbg !244
  %r108.cmp = icmp sgt i64 %r106, %r107, !dbg !244
  %r108 = zext i1 %r108.cmp to i64, !dbg !244
  store i64 %r108, ptr %slot.__sc_30, align 8, !dbg !244
  %br_or_merge3210 = icmp ne i64 %r108, 0, !dbg !244
  br i1 %br_or_merge3210, label %or_merge32, label %or_rhs31, !dbg !244
or_rhs31:
  %r109 = load i64, ptr %slot.row, align 8, !dbg !244
  %r110.lp = inttoptr i64 %r109 to ptr, !dbg !244
  %r110.szp = getelementptr i64, ptr %r110.lp, i64 1, !dbg !244
  %r110 = load i64, ptr %r110.szp, align 8, !tbaa !6, !dbg !244
  %r111 = add i64 0, 0, !dbg !244
  %r112.cmp = icmp sgt i64 %r110, %r111, !dbg !244
  %r112 = zext i1 %r112.cmp to i64, !dbg !244
  store i64 %r112, ptr %slot.__sc_30, align 8, !dbg !244
  br label %or_merge32, !dbg !244
or_merge32:
  %r113 = load i64, ptr %slot.__sc_30, align 8, !dbg !244
  store i64 %r113, ptr %slot.__sc_33, align 8, !dbg !244
  %br_or_merge3511 = icmp ne i64 %r113, 0, !dbg !244
  br i1 %br_or_merge3511, label %or_merge35, label %or_rhs34, !dbg !244
or_rhs34:
  %r114 = load i64, ptr %slot.saw_char, align 8, !dbg !244
  store i64 %r114, ptr %slot.__sc_33, align 8, !dbg !244
  br label %or_merge35, !dbg !244
or_merge35:
  %r115 = load i64, ptr %slot.__sc_33, align 8, !dbg !244
  %wbox0 = call i64 @nova_rt_truthy(i64 %r115), !dbg !244
  %br_then3612 = icmp ne i64 %wbox0, 0, !dbg !244
  br i1 %br_then3612, label %then36, label %else37, !dbg !244
then36:
  %r116 = load i64, ptr %slot.row, align 8, !dbg !245
  %r117 = load i64, ptr %slot.buf, align 8, !dbg !245
  %r118 = call i64 @nova_rt_buffer_to_str(i64 %r117), !dbg !245
  %r119 = call i64 @nova_rt_list_append_no_rc(i64 %r116, i64 %r118), !dbg !245
  %r120 = load i64, ptr %slot.rows, align 8, !dbg !246
  %r121 = load i64, ptr %slot.row, align 8, !dbg !246
  %r122 = call i64 @nova_rt_list_append(i64 %r120, i64 %r121), !dbg !246
  br label %endif38, !dbg !246
else37:
  br label %endif38, !dbg !246
endif38:
  %r123 = load i64, ptr %slot.rows, align 8, !dbg !247
  ret i64 %r123, !dbg !247
}

; ESCAPE _csv_escape_field: allocs=0 escape=0 local=0
define i64 @_csv_escape_field(i64 %p0) nounwind uwtable !dbg !248 {
entry:
  %slot.val = alloca i64, align 8, !dbg !249
  store i64 %p0, ptr %slot.val, align 8, !dbg !249
  %slot.bts = alloca i64, align 8, !dbg !249
  store i64 0, ptr %slot.bts, align 8, !dbg !249
  %slot.n = alloca i64, align 8, !dbg !249
  store i64 0, ptr %slot.n, align 8, !dbg !249
  %slot.needs_quote = alloca i64, align 8, !dbg !249
  store i64 0, ptr %slot.needs_quote, align 8, !dbg !249
  %slot.i = alloca i64, align 8, !dbg !249
  store i64 0, ptr %slot.i, align 8, !dbg !249
  %slot.code = alloca i64, align 8, !dbg !249
  store i64 0, ptr %slot.code, align 8, !dbg !249
  %slot.__sc_42 = alloca i64, align 8, !dbg !249
  store i64 0, ptr %slot.__sc_42, align 8, !dbg !249
  %slot.__sc_45 = alloca i64, align 8, !dbg !249
  store i64 0, ptr %slot.__sc_45, align 8, !dbg !249
  %slot.__sc_48 = alloca i64, align 8, !dbg !249
  store i64 0, ptr %slot.__sc_48, align 8, !dbg !249
  %slot.result = alloca i64, align 8, !dbg !249
  store i64 0, ptr %slot.result, align 8, !dbg !249
  %slot.buf = alloca i64, align 8, !dbg !249
  store i64 0, ptr %slot.buf, align 8, !dbg !249
  %slot.j = alloca i64, align 8, !dbg !249
  store i64 0, ptr %slot.j, align 8, !dbg !249
  %slot.code2 = alloca i64, align 8, !dbg !249
  store i64 0, ptr %slot.code2, align 8, !dbg !249
  %r0 = load i64, ptr %slot.val, align 8, !dbg !250
  %r1 = call i64 @nova_rt_str_to_bytes(i64 %r0), !dbg !250
  store i64 %r1, ptr %slot.bts, align 8, !dbg !250
  %r2 = add i64 %r1, 0, !dbg !251
  %r3 = call i64 @nova_rt_bytes_len(i64 %r2), !dbg !251
  store i64 %r3, ptr %slot.n, align 8, !dbg !251
  %r4 = add i64 0, 0, !dbg !252
  store i64 %r4, ptr %slot.needs_quote, align 8, !dbg !252
  %r5 = add i64 0, 0, !dbg !253
  store i64 %r5, ptr %slot.i, align 8, !dbg !253
  br label %while_hdr39, !dbg !254
while_hdr39:
  %r6 = load i64, ptr %slot.i, align 8, !dbg !254
  %r7 = load i64, ptr %slot.n, align 8, !dbg !254
  %r8.cmp = icmp slt i64 %r6, %r7, !dbg !254
  %r8 = zext i1 %r8.cmp to i64, !dbg !254
  %br_while_body400 = icmp ne i64 %r8, 0, !dbg !254
  br i1 %br_while_body400, label %while_body40, label %while_exit41, !prof !90, !dbg !254
while_body40:
  %r9 = load i64, ptr %slot.bts, align 8, !dbg !255
  %r10 = load i64, ptr %slot.i, align 8, !dbg !255
  %r11 = call i64 @nova_rt_bytes_get(i64 %r9, i64 %r10), !dbg !255
  store i64 %r11, ptr %slot.code, align 8, !dbg !255
  %r12 = add i64 %r11, 0, !dbg !256
  %r13 = add i64 44, 0, !dbg !256
  %r14.cmp = icmp eq i64 %r12, %r13, !dbg !256
  %r14 = zext i1 %r14.cmp to i64, !dbg !256
  store i64 %r14, ptr %slot.__sc_42, align 8, !dbg !256
  %br_or_merge441 = icmp ne i64 %r14, 0, !dbg !256
  br i1 %br_or_merge441, label %or_merge44, label %or_rhs43, !dbg !256
or_rhs43:
  %r15 = load i64, ptr %slot.code, align 8, !dbg !256
  %r16 = add i64 34, 0, !dbg !256
  %r17.cmp = icmp eq i64 %r15, %r16, !dbg !256
  %r17 = zext i1 %r17.cmp to i64, !dbg !256
  store i64 %r17, ptr %slot.__sc_42, align 8, !dbg !256
  br label %or_merge44, !dbg !256
or_merge44:
  %r18 = load i64, ptr %slot.__sc_42, align 8, !dbg !256
  store i64 %r18, ptr %slot.__sc_45, align 8, !dbg !256
  %br_or_merge472 = icmp ne i64 %r18, 0, !dbg !256
  br i1 %br_or_merge472, label %or_merge47, label %or_rhs46, !dbg !256
or_rhs46:
  %r19 = load i64, ptr %slot.code, align 8, !dbg !256
  %r20 = add i64 13, 0, !dbg !256
  %r21.cmp = icmp eq i64 %r19, %r20, !dbg !256
  %r21 = zext i1 %r21.cmp to i64, !dbg !256
  store i64 %r21, ptr %slot.__sc_45, align 8, !dbg !256
  br label %or_merge47, !dbg !256
or_merge47:
  %r22 = load i64, ptr %slot.__sc_45, align 8, !dbg !256
  store i64 %r22, ptr %slot.__sc_48, align 8, !dbg !256
  %br_or_merge503 = icmp ne i64 %r22, 0, !dbg !256
  br i1 %br_or_merge503, label %or_merge50, label %or_rhs49, !dbg !256
or_rhs49:
  %r23 = load i64, ptr %slot.code, align 8, !dbg !256
  %r24 = add i64 10, 0, !dbg !256
  %r25.cmp = icmp eq i64 %r23, %r24, !dbg !256
  %r25 = zext i1 %r25.cmp to i64, !dbg !256
  store i64 %r25, ptr %slot.__sc_48, align 8, !dbg !256
  br label %or_merge50, !dbg !256
or_merge50:
  %r26 = load i64, ptr %slot.__sc_48, align 8, !dbg !256
  %br_then514 = icmp ne i64 %r26, 0, !dbg !256
  br i1 %br_then514, label %then51, label %else52, !dbg !256
then51:
  %r27 = add i64 1, 0, !dbg !257
  store i64 %r27, ptr %slot.needs_quote, align 8, !dbg !257
  br label %endif53, !dbg !257
else52:
  br label %endif53, !dbg !257
endif53:
  %r28 = load i64, ptr %slot.i, align 8, !dbg !258
  %r29 = add i64 1, 0, !dbg !258
  %r30 = add i64 %r28, %r29, !dbg !258
  store i64 %r30, ptr %slot.i, align 8, !dbg !258
  br label %while_hdr39, !dbg !258
while_exit41:
  %r31 = load i64, ptr %slot.val, align 8, !dbg !259
  store i64 %r31, ptr %slot.result, align 8, !dbg !259
  %r32 = load i64, ptr %slot.needs_quote, align 8, !dbg !260
  %br_then545 = icmp ne i64 %r32, 0, !dbg !260
  br i1 %br_then545, label %then54, label %else55, !dbg !260
then54:
  %r33 = call i64 @nova_rt_buffer_create(), !dbg !261
  store i64 %r33, ptr %slot.buf, align 8, !dbg !261
  %r34 = add i64 %r33, 0, !dbg !262
  %r35 = add i64 34, 0, !dbg !262
  %r36 = call i64 @nova_rt_buffer_append_char(i64 %r34, i64 %r35), !dbg !262
  %r37 = add i64 0, 0, !dbg !263
  store i64 %r37, ptr %slot.j, align 8, !dbg !263
  br label %while_hdr57, !dbg !264
while_hdr57:
  %r38 = load i64, ptr %slot.j, align 8, !dbg !264
  %r39 = load i64, ptr %slot.n, align 8, !dbg !264
  %r40.cmp = icmp slt i64 %r38, %r39, !dbg !264
  %r40 = zext i1 %r40.cmp to i64, !dbg !264
  %br_while_body586 = icmp ne i64 %r40, 0, !dbg !264
  br i1 %br_while_body586, label %while_body58, label %while_exit59, !prof !90, !dbg !264
while_body58:
  %r41 = load i64, ptr %slot.bts, align 8, !dbg !265
  %r42 = load i64, ptr %slot.j, align 8, !dbg !265
  %r43 = call i64 @nova_rt_bytes_get(i64 %r41, i64 %r42), !dbg !265
  store i64 %r43, ptr %slot.code2, align 8, !dbg !265
  %r44 = add i64 %r43, 0, !dbg !266
  %r45 = add i64 34, 0, !dbg !266
  %r46.cmp = icmp eq i64 %r44, %r45, !dbg !266
  %r46 = zext i1 %r46.cmp to i64, !dbg !266
  %br_then607 = icmp ne i64 %r46, 0, !dbg !266
  br i1 %br_then607, label %then60, label %else61, !dbg !266
then60:
  %r47 = load i64, ptr %slot.buf, align 8, !dbg !267
  %r48 = add i64 34, 0, !dbg !267
  %r49 = call i64 @nova_rt_buffer_append_char(i64 %r47, i64 %r48), !dbg !267
  %r50 = load i64, ptr %slot.buf, align 8, !dbg !268
  %r51 = add i64 34, 0, !dbg !268
  %r52 = call i64 @nova_rt_buffer_append_char(i64 %r50, i64 %r51), !dbg !268
  br label %endif62, !dbg !268
else61:
  %r53 = load i64, ptr %slot.buf, align 8, !dbg !269
  %r54 = load i64, ptr %slot.code2, align 8, !dbg !269
  %r55 = call i64 @nova_rt_buffer_append_char(i64 %r53, i64 %r54), !dbg !269
  br label %endif62, !dbg !269
endif62:
  %r56 = load i64, ptr %slot.j, align 8, !dbg !270
  %r57 = add i64 1, 0, !dbg !270
  %r58 = add i64 %r56, %r57, !dbg !270
  store i64 %r58, ptr %slot.j, align 8, !dbg !270
  br label %while_hdr57, !dbg !270
while_exit59:
  %r59 = load i64, ptr %slot.buf, align 8, !dbg !271
  %r60 = add i64 34, 0, !dbg !271
  %r61 = call i64 @nova_rt_buffer_append_char(i64 %r59, i64 %r60), !dbg !271
  %r62 = load i64, ptr %slot.buf, align 8, !dbg !272
  %r63 = call i64 @nova_rt_buffer_to_str(i64 %r62), !dbg !272
  store i64 %r63, ptr %slot.result, align 8, !dbg !272
  br label %endif56, !dbg !272
else55:
  br label %endif56, !dbg !272
endif56:
  %r64 = load i64, ptr %slot.result, align 8, !dbg !273
  ret i64 %r64, !dbg !273
}

; ESCAPE csv_write: allocs=0 escape=0 local=0
define i64 @csv_write(i64 %p0) nounwind uwtable !dbg !274 {
entry:
  %slot.rows = alloca i64, align 8, !dbg !275
  store i64 %p0, ptr %slot.rows, align 8, !dbg !275
  %slot.buf = alloca i64, align 8, !dbg !275
  store i64 0, ptr %slot.buf, align 8, !dbg !275
  %slot.nr = alloca i64, align 8, !dbg !275
  store i64 0, ptr %slot.nr, align 8, !dbg !275
  %slot.r = alloca i64, align 8, !dbg !275
  store i64 0, ptr %slot.r, align 8, !dbg !275
  %slot.rows__s4f175 = alloca i64, align 8, !dbg !275
  store i64 0, ptr %slot.rows__s4f175, align 8, !dbg !275
  %slot.row__s4f175 = alloca i64, align 8, !dbg !275
  store i64 0, ptr %slot.row__s4f175, align 8, !dbg !275
  %slot.nf__s4f175 = alloca i64, align 8, !dbg !275
  store i64 0, ptr %slot.nf__s4f175, align 8, !dbg !275
  %slot.j__s4f175 = alloca i64, align 8, !dbg !275
  store i64 0, ptr %slot.j__s4f175, align 8, !dbg !275
  %slot.row = alloca i64, align 8, !dbg !275
  store i64 0, ptr %slot.row, align 8, !dbg !275
  %slot.nf = alloca i64, align 8, !dbg !275
  store i64 0, ptr %slot.nf, align 8, !dbg !275
  %slot.j = alloca i64, align 8, !dbg !275
  store i64 0, ptr %slot.j, align 8, !dbg !275
  %r0 = call i64 @nova_rt_buffer_create(), !dbg !276
  store i64 %r0, ptr %slot.buf, align 8, !dbg !276
  %r1 = load i64, ptr %slot.rows, align 8, !dbg !277
  %r2.lp = inttoptr i64 %r1 to ptr, !dbg !277
  %r2.szp = getelementptr i64, ptr %r2.lp, i64 1, !dbg !277
  %r2 = load i64, ptr %r2.szp, align 8, !tbaa !6, !dbg !277
  store i64 %r2, ptr %slot.nr, align 8, !dbg !277
  %r3 = add i64 0, 0, !dbg !278
  store i64 %r3, ptr %slot.r, align 8, !dbg !278
  %r4 = load i64, ptr %slot.rows, align 8, !dbg !279
  %r5 = call i64 @nova_rt_list_is_kind2(i64 %r4), !dbg !279
  %br_then630 = icmp ne i64 %r5, 0, !dbg !279
  br i1 %br_then630, label %then63, label %else64, !dbg !279
then63:
  %r6 = load i64, ptr %slot.rows, align 8, !dbg !279
  %r7 = call i64 @nova_rt_floatlist_view(i64 %r6), !dbg !279
  store i64 %r7, ptr %slot.rows__s4f175, align 8, !dbg !279
  br label %while_hdr66, !dbg !279
while_hdr66:
  %r8 = load i64, ptr %slot.r, align 8, !dbg !279
  %r9 = load i64, ptr %slot.nr, align 8, !dbg !279
  %r10.cmp = icmp slt i64 %r8, %r9, !dbg !279
  %r10 = zext i1 %r10.cmp to i64, !dbg !279
  %br_while_body671 = icmp ne i64 %r10, 0, !dbg !279
  br i1 %br_while_body671, label %while_body67, label %while_exit68, !prof !90, !dbg !279
while_body67:
  %r11 = load i64, ptr %slot.r, align 8, !dbg !280
  %r12 = add i64 0, 0, !dbg !280
  %r13.cmp = icmp sgt i64 %r11, %r12, !dbg !280
  %r13 = zext i1 %r13.cmp to i64, !dbg !280
  %br_then692 = icmp ne i64 %r13, 0, !dbg !280
  br i1 %br_then692, label %then69, label %else70, !dbg !280
then69:
  %r14 = load i64, ptr %slot.buf, align 8, !dbg !281
  %r15 = add i64 10, 0, !dbg !281
  %r16 = call i64 @nova_rt_buffer_append_char(i64 %r14, i64 %r15), !dbg !281
  br label %endif71, !dbg !281
else70:
  br label %endif71, !dbg !281
endif71:
  %r17 = load i64, ptr %slot.rows__s4f175, align 8, !dbg !282
  %r18 = load i64, ptr %slot.r, align 8, !dbg !282
  %r19 = call i64 @nova_rt_list_get_f(i64 %r17, i64 %r18), !dbg !282
  store i64 %r19, ptr %slot.row__s4f175, align 8, !dbg !282
  %r20 = add i64 %r19, 0, !dbg !283
  %wbox0 = call i64 @nova_rt_box_float(i64 %r20), !dbg !283
  %r21 = call i64 @nova_rt_len_any(i64 %wbox0), !dbg !283
  store i64 %r21, ptr %slot.nf__s4f175, align 8, !dbg !283
  %r22 = add i64 0, 0, !dbg !284
  store i64 %r22, ptr %slot.j__s4f175, align 8, !dbg !284
  br label %while_hdr72, !dbg !285
while_hdr72:
  %r23 = load i64, ptr %slot.j__s4f175, align 8, !dbg !285
  %r24 = load i64, ptr %slot.nf__s4f175, align 8, !dbg !285
  %r25.cmp = icmp slt i64 %r23, %r24, !dbg !285
  %r25 = zext i1 %r25.cmp to i64, !dbg !285
  %br_while_body733 = icmp ne i64 %r25, 0, !dbg !285
  br i1 %br_while_body733, label %while_body73, label %while_exit74, !prof !90, !dbg !285
while_body73:
  %r26 = load i64, ptr %slot.j__s4f175, align 8, !dbg !286
  %r27 = add i64 0, 0, !dbg !286
  %r28.cmp = icmp sgt i64 %r26, %r27, !dbg !286
  %r28 = zext i1 %r28.cmp to i64, !dbg !286
  %br_then754 = icmp ne i64 %r28, 0, !dbg !286
  br i1 %br_then754, label %then75, label %else76, !dbg !286
then75:
  %r29 = load i64, ptr %slot.buf, align 8, !dbg !287
  %r30 = add i64 44, 0, !dbg !287
  %r31 = call i64 @nova_rt_buffer_append_char(i64 %r29, i64 %r30), !dbg !287
  br label %endif77, !dbg !287
else76:
  br label %endif77, !dbg !287
endif77:
  %r32 = load i64, ptr %slot.buf, align 8, !dbg !288
  %r33 = load i64, ptr %slot.row__s4f175, align 8, !dbg !288
  %r34 = load i64, ptr %slot.j__s4f175, align 8, !dbg !288
  %r35 = call i64 @nova_rt_index_get(i64 %r33, i64 %r34), !dbg !288
  %r36 = call i64 @_csv_escape_field(i64 %r35), !dbg !288
  %r37 = call i64 @nova_rt_buffer_append(i64 %r32, i64 %r36), !dbg !288
  %r38 = load i64, ptr %slot.j__s4f175, align 8, !dbg !289
  %r39 = add i64 1, 0, !dbg !289
  %r40 = add i64 %r38, %r39, !dbg !289
  store i64 %r40, ptr %slot.j__s4f175, align 8, !dbg !289
  br label %while_hdr72, !dbg !289
while_exit74:
  %r41 = load i64, ptr %slot.r, align 8, !dbg !290
  %r42 = add i64 1, 0, !dbg !290
  %r43 = add i64 %r41, %r42, !dbg !290
  store i64 %r43, ptr %slot.r, align 8, !dbg !290
  br label %while_hdr66, !dbg !290
while_exit68:
  br label %endif65, !dbg !290
else64:
  br label %while_hdr78, !dbg !279
while_hdr78:
  %r44 = load i64, ptr %slot.r, align 8, !dbg !279
  %r45 = load i64, ptr %slot.nr, align 8, !dbg !279
  %r46.cmp = icmp slt i64 %r44, %r45, !dbg !279
  %r46 = zext i1 %r46.cmp to i64, !dbg !279
  %br_while_body795 = icmp ne i64 %r46, 0, !dbg !279
  br i1 %br_while_body795, label %while_body79, label %while_exit80, !prof !90, !dbg !279
while_body79:
  %r47 = load i64, ptr %slot.r, align 8, !dbg !280
  %r48 = add i64 0, 0, !dbg !280
  %r49.cmp = icmp sgt i64 %r47, %r48, !dbg !280
  %r49 = zext i1 %r49.cmp to i64, !dbg !280
  %br_then816 = icmp ne i64 %r49, 0, !dbg !280
  br i1 %br_then816, label %then81, label %else82, !dbg !280
then81:
  %r50 = load i64, ptr %slot.buf, align 8, !dbg !281
  %r51 = add i64 10, 0, !dbg !281
  %r52 = call i64 @nova_rt_buffer_append_char(i64 %r50, i64 %r51), !dbg !281
  br label %endif83, !dbg !281
else82:
  br label %endif83, !dbg !281
endif83:
  %r53 = load i64, ptr %slot.rows, align 8, !dbg !282
  %r54 = load i64, ptr %slot.r, align 8, !dbg !282
  %r55 = call i64 @nova_rt_list_get(i64 %r53, i64 %r54), !dbg !282
  store i64 %r55, ptr %slot.row, align 8, !dbg !282
  %r56 = add i64 %r55, 0, !dbg !283
  %r57 = call i64 @nova_rt_len_any(i64 %r56), !dbg !283
  store i64 %r57, ptr %slot.nf, align 8, !dbg !283
  %r58 = add i64 0, 0, !dbg !284
  store i64 %r58, ptr %slot.j, align 8, !dbg !284
  br label %while_hdr84, !dbg !285
while_hdr84:
  %r59 = load i64, ptr %slot.j, align 8, !dbg !285
  %r60 = load i64, ptr %slot.nf, align 8, !dbg !285
  %r61.cmp = icmp slt i64 %r59, %r60, !dbg !285
  %r61 = zext i1 %r61.cmp to i64, !dbg !285
  %br_while_body857 = icmp ne i64 %r61, 0, !dbg !285
  br i1 %br_while_body857, label %while_body85, label %while_exit86, !prof !90, !dbg !285
while_body85:
  %r62 = load i64, ptr %slot.j, align 8, !dbg !286
  %r63 = add i64 0, 0, !dbg !286
  %r64.cmp = icmp sgt i64 %r62, %r63, !dbg !286
  %r64 = zext i1 %r64.cmp to i64, !dbg !286
  %br_then878 = icmp ne i64 %r64, 0, !dbg !286
  br i1 %br_then878, label %then87, label %else88, !dbg !286
then87:
  %r65 = load i64, ptr %slot.buf, align 8, !dbg !287
  %r66 = add i64 44, 0, !dbg !287
  %r67 = call i64 @nova_rt_buffer_append_char(i64 %r65, i64 %r66), !dbg !287
  br label %endif89, !dbg !287
else88:
  br label %endif89, !dbg !287
endif89:
  %r68 = load i64, ptr %slot.buf, align 8, !dbg !288
  %r69 = load i64, ptr %slot.row, align 8, !dbg !288
  %r70 = load i64, ptr %slot.j, align 8, !dbg !288
  %r71 = call i64 @nova_rt_index_get(i64 %r69, i64 %r70), !dbg !288
  %r72 = call i64 @_csv_escape_field(i64 %r71), !dbg !288
  %r73 = call i64 @nova_rt_buffer_append(i64 %r68, i64 %r72), !dbg !288
  %r74 = load i64, ptr %slot.j, align 8, !dbg !289
  %r75 = add i64 1, 0, !dbg !289
  %r76 = add i64 %r74, %r75, !dbg !289
  store i64 %r76, ptr %slot.j, align 8, !dbg !289
  br label %while_hdr84, !dbg !289
while_exit86:
  %r77 = load i64, ptr %slot.r, align 8, !dbg !290
  %r78 = add i64 1, 0, !dbg !290
  %r79 = add i64 %r77, %r78, !dbg !290
  store i64 %r79, ptr %slot.r, align 8, !dbg !290
  br label %while_hdr78, !dbg !290
while_exit80:
  br label %endif65, !dbg !290
endif65:
  %r80 = load i64, ptr %slot.buf, align 8, !dbg !291
  %r81 = call i64 @nova_rt_buffer_to_str(i64 %r80), !dbg !291
  ret i64 %r81, !dbg !291
}

; ESCAPE nova_main: allocs=0 escape=0 local=0
define i64 @nova_main() nounwind uwtable {
entry:
  ret i64 0
}

; ESCAPE SUMMARY: allocs=3 escape=1 local=2 (66% local, RC-elidable)
define i32 @main(i32 %argc, ptr %argv) nounwind uwtable {
entry:
  %argc64 = sext i32 %argc to i64
  %argv64 = ptrtoint ptr %argv to i64
  call void @nova_rt_init_args(i64 %argc64, i64 %argv64)
  call void @nova_rt_main_dispatch(i64 ptrtoint (ptr @nova_main to i64))
  call void @nova_rt_wait_all()
  call void @nova_rt_cleanup()
  ret i32 0
}

; Debug metadata
!llvm.dbg.cu = !{!100}
!llvm.module.flags = !{!102, !103}

!100 = distinct !DICompileUnit(language: DW_LANG_C99, file: !101, producer: "NOVA Compiler", isOptimized: false, emissionKind: LineTablesOnly)
!101 = !DIFile(filename: "../std/data/csv.nova", directory: ".")
!102 = !{i32 2, !"CodeView", i32 1}
!103 = !{i32 2, !"Debug Info Version", i32 3}
!104 = !DISubroutineType(types: !105)
!105 = !{null}
!200 = distinct !DISubprogram(name: "csv_parse", scope: !101, file: !101, line: 62, type: !104, scopeLine: 62, spFlags: DISPFlagDefinition, unit: !100)
!201 = !DILocation(line: 62, column: 0, scope: !200)
!248 = distinct !DISubprogram(name: "_csv_escape_field", scope: !101, file: !101, line: 138, type: !104, scopeLine: 138, spFlags: DISPFlagDefinition, unit: !100)
!249 = !DILocation(line: 138, column: 0, scope: !248)
!274 = distinct !DISubprogram(name: "csv_write", scope: !101, file: !101, line: 171, type: !104, scopeLine: 171, spFlags: DISPFlagDefinition, unit: !100)
!275 = !DILocation(line: 171, column: 0, scope: !274)
!202 = !DILocation(line: 63, column: 0, scope: !200)
!203 = !DILocation(line: 64, column: 0, scope: !200)
!204 = !DILocation(line: 65, column: 0, scope: !200)
!205 = !DILocation(line: 66, column: 0, scope: !200)
!206 = !DILocation(line: 67, column: 0, scope: !200)
!207 = !DILocation(line: 68, column: 0, scope: !200)
!208 = !DILocation(line: 69, column: 0, scope: !200)
!209 = !DILocation(line: 70, column: 0, scope: !200)
!210 = !DILocation(line: 71, column: 0, scope: !200)
!211 = !DILocation(line: 78, column: 0, scope: !200)
!212 = !DILocation(line: 79, column: 0, scope: !200)
!213 = !DILocation(line: 80, column: 0, scope: !200)
!214 = !DILocation(line: 81, column: 0, scope: !200)
!215 = !DILocation(line: 82, column: 0, scope: !200)
!216 = !DILocation(line: 83, column: 0, scope: !200)
!217 = !DILocation(line: 84, column: 0, scope: !200)
!218 = !DILocation(line: 85, column: 0, scope: !200)
!219 = !DILocation(line: 86, column: 0, scope: !200)
!220 = !DILocation(line: 88, column: 0, scope: !200)
!221 = !DILocation(line: 89, column: 0, scope: !200)
!222 = !DILocation(line: 92, column: 0, scope: !200)
!223 = !DILocation(line: 93, column: 0, scope: !200)
!224 = !DILocation(line: 96, column: 0, scope: !200)
!225 = !DILocation(line: 97, column: 0, scope: !200)
!226 = !DILocation(line: 99, column: 0, scope: !200)
!227 = !DILocation(line: 101, column: 0, scope: !200)
!228 = !DILocation(line: 102, column: 0, scope: !200)
!229 = !DILocation(line: 104, column: 0, scope: !200)
!230 = !DILocation(line: 105, column: 0, scope: !200)
!231 = !DILocation(line: 106, column: 0, scope: !200)
!232 = !DILocation(line: 107, column: 0, scope: !200)
!233 = !DILocation(line: 109, column: 0, scope: !200)
!234 = !DILocation(line: 111, column: 0, scope: !200)
!235 = !DILocation(line: 113, column: 0, scope: !200)
!236 = !DILocation(line: 114, column: 0, scope: !200)
!237 = !DILocation(line: 115, column: 0, scope: !200)
!238 = !DILocation(line: 116, column: 0, scope: !200)
!239 = !DILocation(line: 117, column: 0, scope: !200)
!240 = !DILocation(line: 118, column: 0, scope: !200)
!241 = !DILocation(line: 119, column: 0, scope: !200)
!242 = !DILocation(line: 121, column: 0, scope: !200)
!243 = !DILocation(line: 122, column: 0, scope: !200)
!244 = !DILocation(line: 124, column: 0, scope: !200)
!245 = !DILocation(line: 125, column: 0, scope: !200)
!246 = !DILocation(line: 126, column: 0, scope: !200)
!247 = !DILocation(line: 127, column: 0, scope: !200)
!250 = !DILocation(line: 139, column: 0, scope: !248)
!251 = !DILocation(line: 140, column: 0, scope: !248)
!252 = !DILocation(line: 141, column: 0, scope: !248)
!253 = !DILocation(line: 142, column: 0, scope: !248)
!254 = !DILocation(line: 143, column: 0, scope: !248)
!255 = !DILocation(line: 144, column: 0, scope: !248)
!256 = !DILocation(line: 145, column: 0, scope: !248)
!257 = !DILocation(line: 146, column: 0, scope: !248)
!258 = !DILocation(line: 147, column: 0, scope: !248)
!259 = !DILocation(line: 148, column: 0, scope: !248)
!260 = !DILocation(line: 149, column: 0, scope: !248)
!261 = !DILocation(line: 150, column: 0, scope: !248)
!262 = !DILocation(line: 151, column: 0, scope: !248)
!263 = !DILocation(line: 152, column: 0, scope: !248)
!264 = !DILocation(line: 153, column: 0, scope: !248)
!265 = !DILocation(line: 154, column: 0, scope: !248)
!266 = !DILocation(line: 155, column: 0, scope: !248)
!267 = !DILocation(line: 156, column: 0, scope: !248)
!268 = !DILocation(line: 157, column: 0, scope: !248)
!269 = !DILocation(line: 159, column: 0, scope: !248)
!270 = !DILocation(line: 160, column: 0, scope: !248)
!271 = !DILocation(line: 161, column: 0, scope: !248)
!272 = !DILocation(line: 162, column: 0, scope: !248)
!273 = !DILocation(line: 163, column: 0, scope: !248)
!276 = !DILocation(line: 172, column: 0, scope: !274)
!277 = !DILocation(line: 173, column: 0, scope: !274)
!278 = !DILocation(line: 174, column: 0, scope: !274)
!279 = !DILocation(line: 175, column: 0, scope: !274)
!280 = !DILocation(line: 176, column: 0, scope: !274)
!281 = !DILocation(line: 177, column: 0, scope: !274)
!282 = !DILocation(line: 178, column: 0, scope: !274)
!283 = !DILocation(line: 179, column: 0, scope: !274)
!284 = !DILocation(line: 180, column: 0, scope: !274)
!285 = !DILocation(line: 181, column: 0, scope: !274)
!286 = !DILocation(line: 182, column: 0, scope: !274)
!287 = !DILocation(line: 183, column: 0, scope: !274)
!288 = !DILocation(line: 184, column: 0, scope: !274)
!289 = !DILocation(line: 185, column: 0, scope: !274)
!290 = !DILocation(line: 186, column: 0, scope: !274)
!291 = !DILocation(line: 187, column: 0, scope: !274)

; TBAA metadata
!0 = !{!"NOVA TBAA"}
!1 = !{!"list_data_ptr", !0}
!2 = !{!1, !1, i64 0}
!3 = !{!"list_elem", !0}
!4 = !{!3, !3, i64 0}
!5 = !{!"list_size", !0}
!6 = !{!5, !5, i64 0}
!90 = !{!"branch_weights", i32 2000, i32 1}
