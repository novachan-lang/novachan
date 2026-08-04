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

; ESCAPE _tm_is_hspace: allocs=0 escape=0 local=0
define i64 @_tm_is_hspace(i64 %p0) nounwind uwtable !dbg !200 {
entry:
  %slot.o = alloca i64, align 8, !dbg !201
  store i64 %p0, ptr %slot.o, align 8, !dbg !201
  %slot.result = alloca i64, align 8, !dbg !201
  store i64 0, ptr %slot.result, align 8, !dbg !201
  %r0 = add i64 0, 0, !dbg !202
  store i64 %r0, ptr %slot.result, align 8, !dbg !202
  %r1 = load i64, ptr %slot.o, align 8, !dbg !203
  %r2 = add i64 32, 0, !dbg !203
  %r3.cmp = icmp eq i64 %r1, %r2, !dbg !203
  %r3 = zext i1 %r3.cmp to i64, !dbg !203
  %br_then00 = icmp ne i64 %r3, 0, !dbg !203
  br i1 %br_then00, label %then0, label %else1, !dbg !203
then0:
  %r4 = add i64 1, 0, !dbg !204
  store i64 %r4, ptr %slot.result, align 8, !dbg !204
  br label %endif2, !dbg !204
else1:
  %r5 = load i64, ptr %slot.o, align 8, !dbg !205
  %r6 = add i64 9, 0, !dbg !205
  %r7.cmp = icmp eq i64 %r5, %r6, !dbg !205
  %r7 = zext i1 %r7.cmp to i64, !dbg !205
  %br_then31 = icmp ne i64 %r7, 0, !dbg !205
  br i1 %br_then31, label %then3, label %else4, !dbg !205
then3:
  %r8 = add i64 1, 0, !dbg !206
  store i64 %r8, ptr %slot.result, align 8, !dbg !206
  br label %endif5, !dbg !206
else4:
  br label %endif5, !dbg !206
endif5:
  br label %endif2, !dbg !206
endif2:
  %r9 = load i64, ptr %slot.result, align 8, !dbg !207
  ret i64 %r9, !dbg !207
}

; ESCAPE _tm_is_nl: allocs=0 escape=0 local=0
define i64 @_tm_is_nl(i64 %p0) nounwind uwtable !dbg !208 {
entry:
  %slot.o = alloca i64, align 8, !dbg !209
  store i64 %p0, ptr %slot.o, align 8, !dbg !209
  %slot.result = alloca i64, align 8, !dbg !209
  store i64 0, ptr %slot.result, align 8, !dbg !209
  %r0 = add i64 0, 0, !dbg !210
  store i64 %r0, ptr %slot.result, align 8, !dbg !210
  %r1 = load i64, ptr %slot.o, align 8, !dbg !211
  %r2 = add i64 10, 0, !dbg !211
  %r3.cmp = icmp eq i64 %r1, %r2, !dbg !211
  %r3 = zext i1 %r3.cmp to i64, !dbg !211
  %br_then60 = icmp ne i64 %r3, 0, !dbg !211
  br i1 %br_then60, label %then6, label %else7, !dbg !211
then6:
  %r4 = add i64 1, 0, !dbg !212
  store i64 %r4, ptr %slot.result, align 8, !dbg !212
  br label %endif8, !dbg !212
else7:
  %r5 = load i64, ptr %slot.o, align 8, !dbg !213
  %r6 = add i64 13, 0, !dbg !213
  %r7.cmp = icmp eq i64 %r5, %r6, !dbg !213
  %r7 = zext i1 %r7.cmp to i64, !dbg !213
  %br_then91 = icmp ne i64 %r7, 0, !dbg !213
  br i1 %br_then91, label %then9, label %else10, !dbg !213
then9:
  %r8 = add i64 1, 0, !dbg !214
  store i64 %r8, ptr %slot.result, align 8, !dbg !214
  br label %endif11, !dbg !214
else10:
  br label %endif11, !dbg !214
endif11:
  br label %endif8, !dbg !214
endif8:
  %r9 = load i64, ptr %slot.result, align 8, !dbg !215
  ret i64 %r9, !dbg !215
}

; ESCAPE _tm_is_digit: allocs=0 escape=0 local=0
define i64 @_tm_is_digit(i64 %p0) nounwind uwtable !dbg !216 {
entry:
  %slot.o = alloca i64, align 8, !dbg !217
  store i64 %p0, ptr %slot.o, align 8, !dbg !217
  %slot.result = alloca i64, align 8, !dbg !217
  store i64 0, ptr %slot.result, align 8, !dbg !217
  %r0 = add i64 0, 0, !dbg !218
  store i64 %r0, ptr %slot.result, align 8, !dbg !218
  %r1 = load i64, ptr %slot.o, align 8, !dbg !219
  %r2 = add i64 48, 0, !dbg !219
  %r3.cmp = icmp sge i64 %r1, %r2, !dbg !219
  %r3 = zext i1 %r3.cmp to i64, !dbg !219
  %br_then120 = icmp ne i64 %r3, 0, !dbg !219
  br i1 %br_then120, label %then12, label %else13, !dbg !219
then12:
  %r4 = load i64, ptr %slot.o, align 8, !dbg !220
  %r5 = add i64 57, 0, !dbg !220
  %r6.cmp = icmp sle i64 %r4, %r5, !dbg !220
  %r6 = zext i1 %r6.cmp to i64, !dbg !220
  %br_then151 = icmp ne i64 %r6, 0, !dbg !220
  br i1 %br_then151, label %then15, label %else16, !dbg !220
then15:
  %r7 = add i64 1, 0, !dbg !221
  store i64 %r7, ptr %slot.result, align 8, !dbg !221
  br label %endif17, !dbg !221
else16:
  br label %endif17, !dbg !221
endif17:
  br label %endif14, !dbg !221
else13:
  br label %endif14, !dbg !221
endif14:
  %r8 = load i64, ptr %slot.result, align 8, !dbg !222
  ret i64 %r8, !dbg !222
}

; ESCAPE _tm_is_bare_key_char: allocs=0 escape=0 local=0
define i64 @_tm_is_bare_key_char(i64 %p0) nounwind uwtable !dbg !223 {
entry:
  %slot.o = alloca i64, align 8, !dbg !224
  store i64 %p0, ptr %slot.o, align 8, !dbg !224
  %slot.result = alloca i64, align 8, !dbg !224
  store i64 0, ptr %slot.result, align 8, !dbg !224
  %r0 = add i64 0, 0, !dbg !225
  store i64 %r0, ptr %slot.result, align 8, !dbg !225
  %r1 = load i64, ptr %slot.o, align 8, !dbg !226
  %r2 = add i64 65, 0, !dbg !226
  %r3.cmp = icmp sge i64 %r1, %r2, !dbg !226
  %r3 = zext i1 %r3.cmp to i64, !dbg !226
  %br_then180 = icmp ne i64 %r3, 0, !dbg !226
  br i1 %br_then180, label %then18, label %else19, !dbg !226
then18:
  %r4 = load i64, ptr %slot.o, align 8, !dbg !227
  %r5 = add i64 90, 0, !dbg !227
  %r6.cmp = icmp sle i64 %r4, %r5, !dbg !227
  %r6 = zext i1 %r6.cmp to i64, !dbg !227
  %br_then211 = icmp ne i64 %r6, 0, !dbg !227
  br i1 %br_then211, label %then21, label %else22, !dbg !227
then21:
  %r7 = add i64 1, 0, !dbg !228
  store i64 %r7, ptr %slot.result, align 8, !dbg !228
  br label %endif23, !dbg !228
else22:
  br label %endif23, !dbg !228
endif23:
  br label %endif20, !dbg !228
else19:
  br label %endif20, !dbg !228
endif20:
  %r8 = load i64, ptr %slot.result, align 8, !dbg !229
  %r9 = add i64 0, 0, !dbg !229
  %r10.cmp = icmp eq i64 %r8, %r9, !dbg !229
  %r10 = zext i1 %r10.cmp to i64, !dbg !229
  %br_then242 = icmp ne i64 %r10, 0, !dbg !229
  br i1 %br_then242, label %then24, label %else25, !dbg !229
then24:
  %r11 = load i64, ptr %slot.o, align 8, !dbg !230
  %r12 = add i64 97, 0, !dbg !230
  %r13.cmp = icmp sge i64 %r11, %r12, !dbg !230
  %r13 = zext i1 %r13.cmp to i64, !dbg !230
  %br_then273 = icmp ne i64 %r13, 0, !dbg !230
  br i1 %br_then273, label %then27, label %else28, !dbg !230
then27:
  %r14 = load i64, ptr %slot.o, align 8, !dbg !231
  %r15 = add i64 122, 0, !dbg !231
  %r16.cmp = icmp sle i64 %r14, %r15, !dbg !231
  %r16 = zext i1 %r16.cmp to i64, !dbg !231
  %br_then304 = icmp ne i64 %r16, 0, !dbg !231
  br i1 %br_then304, label %then30, label %else31, !dbg !231
then30:
  %r17 = add i64 1, 0, !dbg !232
  store i64 %r17, ptr %slot.result, align 8, !dbg !232
  br label %endif32, !dbg !232
else31:
  br label %endif32, !dbg !232
endif32:
  br label %endif29, !dbg !232
else28:
  br label %endif29, !dbg !232
endif29:
  br label %endif26, !dbg !232
else25:
  br label %endif26, !dbg !232
endif26:
  %r18 = load i64, ptr %slot.result, align 8, !dbg !233
  %r19 = add i64 0, 0, !dbg !233
  %r20.cmp = icmp eq i64 %r18, %r19, !dbg !233
  %r20 = zext i1 %r20.cmp to i64, !dbg !233
  %br_then335 = icmp ne i64 %r20, 0, !dbg !233
  br i1 %br_then335, label %then33, label %else34, !dbg !233
then33:
  %r21 = load i64, ptr %slot.o, align 8, !dbg !234
  %r22 = call i64 @_tm_is_digit(i64 %r21), !dbg !234
  %r23 = add i64 1, 0, !dbg !234
  %r24.cmp = icmp eq i64 %r22, %r23, !dbg !234
  %r24 = zext i1 %r24.cmp to i64, !dbg !234
  %br_then366 = icmp ne i64 %r24, 0, !dbg !234
  br i1 %br_then366, label %then36, label %else37, !dbg !234
then36:
  %r25 = add i64 1, 0, !dbg !235
  store i64 %r25, ptr %slot.result, align 8, !dbg !235
  br label %endif38, !dbg !235
else37:
  br label %endif38, !dbg !235
endif38:
  br label %endif35, !dbg !235
else34:
  br label %endif35, !dbg !235
endif35:
  %r26 = load i64, ptr %slot.result, align 8, !dbg !236
  %r27 = add i64 0, 0, !dbg !236
  %r28.cmp = icmp eq i64 %r26, %r27, !dbg !236
  %r28 = zext i1 %r28.cmp to i64, !dbg !236
  %br_then397 = icmp ne i64 %r28, 0, !dbg !236
  br i1 %br_then397, label %then39, label %else40, !dbg !236
then39:
  %r29 = load i64, ptr %slot.o, align 8, !dbg !237
  %r30 = add i64 95, 0, !dbg !237
  %r31.cmp = icmp eq i64 %r29, %r30, !dbg !237
  %r31 = zext i1 %r31.cmp to i64, !dbg !237
  %br_then428 = icmp ne i64 %r31, 0, !dbg !237
  br i1 %br_then428, label %then42, label %else43, !dbg !237
then42:
  %r32 = add i64 1, 0, !dbg !238
  store i64 %r32, ptr %slot.result, align 8, !dbg !238
  br label %endif44, !dbg !238
else43:
  br label %endif44, !dbg !238
endif44:
  br label %endif41, !dbg !238
else40:
  br label %endif41, !dbg !238
endif41:
  %r33 = load i64, ptr %slot.result, align 8, !dbg !239
  %r34 = add i64 0, 0, !dbg !239
  %r35.cmp = icmp eq i64 %r33, %r34, !dbg !239
  %r35 = zext i1 %r35.cmp to i64, !dbg !239
  %br_then459 = icmp ne i64 %r35, 0, !dbg !239
  br i1 %br_then459, label %then45, label %else46, !dbg !239
then45:
  %r36 = load i64, ptr %slot.o, align 8, !dbg !240
  %r37 = add i64 45, 0, !dbg !240
  %r38.cmp = icmp eq i64 %r36, %r37, !dbg !240
  %r38 = zext i1 %r38.cmp to i64, !dbg !240
  %br_then4810 = icmp ne i64 %r38, 0, !dbg !240
  br i1 %br_then4810, label %then48, label %else49, !dbg !240
then48:
  %r39 = add i64 1, 0, !dbg !241
  store i64 %r39, ptr %slot.result, align 8, !dbg !241
  br label %endif50, !dbg !241
else49:
  br label %endif50, !dbg !241
endif50:
  br label %endif47, !dbg !241
else46:
  br label %endif47, !dbg !241
endif47:
  %r40 = load i64, ptr %slot.result, align 8, !dbg !242
  ret i64 %r40, !dbg !242
}

; ESCAPE _tm_skip_h: allocs=0 escape=0 local=0
define i64 @_tm_skip_h(i64 %p0, i64 %p1, i64 %p2) nounwind uwtable !dbg !243 {
entry:
  %slot.bs = alloca i64, align 8, !dbg !244
  store i64 %p0, ptr %slot.bs, align 8, !dbg !244
  %slot.n = alloca i64, align 8, !dbg !244
  store i64 %p1, ptr %slot.n, align 8, !dbg !244
  %slot.st = alloca i64, align 8, !dbg !244
  store i64 %p2, ptr %slot.st, align 8, !dbg !244
  %slot.go = alloca i64, align 8, !dbg !244
  store i64 0, ptr %slot.go, align 8, !dbg !244
  %slot.p = alloca i64, align 8, !dbg !244
  store i64 0, ptr %slot.p, align 8, !dbg !244
  %r0 = add i64 1, 0, !dbg !245
  store i64 %r0, ptr %slot.go, align 8, !dbg !245
  br label %while_hdr51, !dbg !246
while_hdr51:
  %r1 = load i64, ptr %slot.go, align 8, !dbg !246
  %r2 = add i64 1, 0, !dbg !246
  %r3.cmp = icmp eq i64 %r1, %r2, !dbg !246
  %r3 = zext i1 %r3.cmp to i64, !dbg !246
  %br_while_body520 = icmp ne i64 %r3, 0, !dbg !246
  br i1 %br_while_body520, label %while_body52, label %while_exit53, !prof !90, !dbg !246
while_body52:
  %r4 = load i64, ptr %slot.st, align 8, !dbg !247
  %r5.p = getelementptr inbounds [4 x i8], ptr @.str.0, i64 0, i64 0, !dbg !247
  %r5 = ptrtoint ptr %r5.p to i64, !dbg !247
  %r6 = call i64 @nova_rt_dict_get(i64 %r4, i64 %r5), !dbg !247
  store i64 %r6, ptr %slot.p, align 8, !dbg !247
  %r7 = add i64 %r6, 0, !dbg !248
  %r8 = load i64, ptr %slot.n, align 8, !dbg !248
  %r9 = call i64 @nova_rt_ge(i64 %r7, i64 %r8), !dbg !248
  %br_then541 = icmp ne i64 %r9, 0, !dbg !248
  br i1 %br_then541, label %then54, label %else55, !dbg !248
then54:
  %r10 = add i64 0, 0, !dbg !249
  store i64 %r10, ptr %slot.go, align 8, !dbg !249
  br label %endif56, !dbg !249
else55:
  %r11 = load i64, ptr %slot.bs, align 8, !dbg !250
  %r12 = load i64, ptr %slot.p, align 8, !dbg !250
  %r13 = call i64 @nova_rt_bytes_get(i64 %r11, i64 %r12), !dbg !250
  %r14 = call i64 @_tm_is_hspace(i64 %r13), !dbg !250
  %r15 = add i64 1, 0, !dbg !250
  %r16.cmp = icmp eq i64 %r14, %r15, !dbg !250
  %r16 = zext i1 %r16.cmp to i64, !dbg !250
  %br_then572 = icmp ne i64 %r16, 0, !dbg !250
  br i1 %br_then572, label %then57, label %else58, !dbg !250
then57:
  %r17 = load i64, ptr %slot.p, align 8, !dbg !251
  %r18 = add i64 1, 0, !dbg !251
  %r19 = call i64 @nova_rt_add(i64 %r17, i64 %r18), !dbg !251
  %r20 = load i64, ptr %slot.st, align 8, !dbg !251
  %r21.p = getelementptr inbounds [4 x i8], ptr @.str.0, i64 0, i64 0, !dbg !251
  %r21 = ptrtoint ptr %r21.p to i64, !dbg !251
  %_is.dv3 = call i64 @nova_rt_dict_set(i64 %r20, i64 %r21, i64 %r19), !dbg !251
  br label %endif59, !dbg !251
else58:
  %r22 = add i64 0, 0, !dbg !252
  store i64 %r22, ptr %slot.go, align 8, !dbg !252
  br label %endif59, !dbg !252
endif59:
  br label %endif56, !dbg !252
endif56:
  br label %while_hdr51, !dbg !252
while_exit53:
  ret i64 0, !dbg !252
}

; ESCAPE _tm_skip_to_eol: allocs=0 escape=0 local=0
define i64 @_tm_skip_to_eol(i64 %p0, i64 %p1, i64 %p2) nounwind uwtable !dbg !253 {
entry:
  %slot.bs = alloca i64, align 8, !dbg !254
  store i64 %p0, ptr %slot.bs, align 8, !dbg !254
  %slot.n = alloca i64, align 8, !dbg !254
  store i64 %p1, ptr %slot.n, align 8, !dbg !254
  %slot.st = alloca i64, align 8, !dbg !254
  store i64 %p2, ptr %slot.st, align 8, !dbg !254
  %slot.go = alloca i64, align 8, !dbg !254
  store i64 0, ptr %slot.go, align 8, !dbg !254
  %slot.p = alloca i64, align 8, !dbg !254
  store i64 0, ptr %slot.p, align 8, !dbg !254
  %r0 = add i64 1, 0, !dbg !255
  store i64 %r0, ptr %slot.go, align 8, !dbg !255
  br label %while_hdr60, !dbg !256
while_hdr60:
  %r1 = load i64, ptr %slot.go, align 8, !dbg !256
  %r2 = add i64 1, 0, !dbg !256
  %r3.cmp = icmp eq i64 %r1, %r2, !dbg !256
  %r3 = zext i1 %r3.cmp to i64, !dbg !256
  %br_while_body610 = icmp ne i64 %r3, 0, !dbg !256
  br i1 %br_while_body610, label %while_body61, label %while_exit62, !prof !90, !dbg !256
while_body61:
  %r4 = load i64, ptr %slot.st, align 8, !dbg !257
  %r5.p = getelementptr inbounds [4 x i8], ptr @.str.0, i64 0, i64 0, !dbg !257
  %r5 = ptrtoint ptr %r5.p to i64, !dbg !257
  %r6 = call i64 @nova_rt_index_get(i64 %r4, i64 %r5), !dbg !257
  store i64 %r6, ptr %slot.p, align 8, !dbg !257
  %r7 = add i64 %r6, 0, !dbg !258
  %r8 = load i64, ptr %slot.n, align 8, !dbg !258
  %r9 = call i64 @nova_rt_ge(i64 %r7, i64 %r8), !dbg !258
  %br_then631 = icmp ne i64 %r9, 0, !dbg !258
  br i1 %br_then631, label %then63, label %else64, !dbg !258
then63:
  %r10 = add i64 0, 0, !dbg !259
  store i64 %r10, ptr %slot.go, align 8, !dbg !259
  br label %endif65, !dbg !259
else64:
  %r11 = load i64, ptr %slot.bs, align 8, !dbg !260
  %r12 = load i64, ptr %slot.p, align 8, !dbg !260
  %r13 = call i64 @nova_rt_bytes_get(i64 %r11, i64 %r12), !dbg !260
  %r14 = add i64 10, 0, !dbg !260
  %r15.cmp = icmp eq i64 %r13, %r14, !dbg !260
  %r15 = zext i1 %r15.cmp to i64, !dbg !260
  %br_then662 = icmp ne i64 %r15, 0, !dbg !260
  br i1 %br_then662, label %then66, label %else67, !dbg !260
then66:
  %r16 = add i64 0, 0, !dbg !261
  store i64 %r16, ptr %slot.go, align 8, !dbg !261
  br label %endif68, !dbg !261
else67:
  %r17 = load i64, ptr %slot.p, align 8, !dbg !262
  %r18 = add i64 1, 0, !dbg !262
  %r19 = call i64 @nova_rt_add(i64 %r17, i64 %r18), !dbg !262
  %r20 = load i64, ptr %slot.st, align 8, !dbg !262
  %r21.p = getelementptr inbounds [4 x i8], ptr @.str.0, i64 0, i64 0, !dbg !262
  %r21 = ptrtoint ptr %r21.p to i64, !dbg !262
  %_is.gv3 = call i64 @nova_rt_index_set(i64 %r20, i64 %r21, i64 %r19), !dbg !262
  br label %endif68, !dbg !262
endif68:
  br label %endif65, !dbg !262
endif65:
  br label %while_hdr60, !dbg !262
while_exit62:
  ret i64 0, !dbg !262
}

; ESCAPE _tm_skip_ws_nl_comments: allocs=0 escape=0 local=0
define i64 @_tm_skip_ws_nl_comments(i64 %p0, i64 %p1, i64 %p2) nounwind uwtable !dbg !263 {
entry:
  %slot.bs = alloca i64, align 8, !dbg !264
  store i64 %p0, ptr %slot.bs, align 8, !dbg !264
  %slot.n = alloca i64, align 8, !dbg !264
  store i64 %p1, ptr %slot.n, align 8, !dbg !264
  %slot.st = alloca i64, align 8, !dbg !264
  store i64 %p2, ptr %slot.st, align 8, !dbg !264
  %slot.go = alloca i64, align 8, !dbg !264
  store i64 0, ptr %slot.go, align 8, !dbg !264
  %slot.p = alloca i64, align 8, !dbg !264
  store i64 0, ptr %slot.p, align 8, !dbg !264
  %slot.o = alloca i64, align 8, !dbg !264
  store i64 0, ptr %slot.o, align 8, !dbg !264
  %r0 = add i64 1, 0, !dbg !265
  store i64 %r0, ptr %slot.go, align 8, !dbg !265
  br label %while_hdr69, !dbg !266
while_hdr69:
  %r1 = load i64, ptr %slot.go, align 8, !dbg !266
  %r2 = add i64 1, 0, !dbg !266
  %r3.cmp = icmp eq i64 %r1, %r2, !dbg !266
  %r3 = zext i1 %r3.cmp to i64, !dbg !266
  %br_while_body700 = icmp ne i64 %r3, 0, !dbg !266
  br i1 %br_while_body700, label %while_body70, label %while_exit71, !prof !90, !dbg !266
while_body70:
  %r4 = load i64, ptr %slot.st, align 8, !dbg !267
  %r5.p = getelementptr inbounds [4 x i8], ptr @.str.0, i64 0, i64 0, !dbg !267
  %r5 = ptrtoint ptr %r5.p to i64, !dbg !267
  %r6 = call i64 @nova_rt_dict_get(i64 %r4, i64 %r5), !dbg !267
  store i64 %r6, ptr %slot.p, align 8, !dbg !267
  %r7 = add i64 %r6, 0, !dbg !268
  %r8 = load i64, ptr %slot.n, align 8, !dbg !268
  %r9 = call i64 @nova_rt_ge(i64 %r7, i64 %r8), !dbg !268
  %br_then721 = icmp ne i64 %r9, 0, !dbg !268
  br i1 %br_then721, label %then72, label %else73, !dbg !268
then72:
  %r10 = add i64 0, 0, !dbg !269
  store i64 %r10, ptr %slot.go, align 8, !dbg !269
  br label %endif74, !dbg !269
else73:
  %r11 = load i64, ptr %slot.bs, align 8, !dbg !270
  %r12 = load i64, ptr %slot.p, align 8, !dbg !270
  %r13 = call i64 @nova_rt_bytes_get(i64 %r11, i64 %r12), !dbg !270
  store i64 %r13, ptr %slot.o, align 8, !dbg !270
  %r14 = add i64 %r13, 0, !dbg !271
  %r15 = call i64 @_tm_is_hspace(i64 %r14), !dbg !271
  %r16 = add i64 1, 0, !dbg !271
  %r17.cmp = icmp eq i64 %r15, %r16, !dbg !271
  %r17 = zext i1 %r17.cmp to i64, !dbg !271
  %br_then752 = icmp ne i64 %r17, 0, !dbg !271
  br i1 %br_then752, label %then75, label %else76, !dbg !271
then75:
  %r18 = load i64, ptr %slot.p, align 8, !dbg !272
  %r19 = add i64 1, 0, !dbg !272
  %r20 = call i64 @nova_rt_add(i64 %r18, i64 %r19), !dbg !272
  %r21 = load i64, ptr %slot.st, align 8, !dbg !272
  %r22.p = getelementptr inbounds [4 x i8], ptr @.str.0, i64 0, i64 0, !dbg !272
  %r22 = ptrtoint ptr %r22.p to i64, !dbg !272
  %_is.dv3 = call i64 @nova_rt_dict_set(i64 %r21, i64 %r22, i64 %r20), !dbg !272
  br label %endif77, !dbg !272
else76:
  %r23 = load i64, ptr %slot.o, align 8, !dbg !273
  %r24 = call i64 @_tm_is_nl(i64 %r23), !dbg !273
  %r25 = add i64 1, 0, !dbg !273
  %r26.cmp = icmp eq i64 %r24, %r25, !dbg !273
  %r26 = zext i1 %r26.cmp to i64, !dbg !273
  %br_then784 = icmp ne i64 %r26, 0, !dbg !273
  br i1 %br_then784, label %then78, label %else79, !dbg !273
then78:
  %r27 = load i64, ptr %slot.p, align 8, !dbg !274
  %r28 = add i64 1, 0, !dbg !274
  %r29 = call i64 @nova_rt_add(i64 %r27, i64 %r28), !dbg !274
  %r30 = load i64, ptr %slot.st, align 8, !dbg !274
  %r31.p = getelementptr inbounds [4 x i8], ptr @.str.0, i64 0, i64 0, !dbg !274
  %r31 = ptrtoint ptr %r31.p to i64, !dbg !274
  %_is.dv5 = call i64 @nova_rt_dict_set(i64 %r30, i64 %r31, i64 %r29), !dbg !274
  br label %endif80, !dbg !274
else79:
  %r32 = load i64, ptr %slot.o, align 8, !dbg !275
  %r33 = add i64 35, 0, !dbg !275
  %r34.cmp = icmp eq i64 %r32, %r33, !dbg !275
  %r34 = zext i1 %r34.cmp to i64, !dbg !275
  %br_then816 = icmp ne i64 %r34, 0, !dbg !275
  br i1 %br_then816, label %then81, label %else82, !dbg !275
then81:
  %r35 = load i64, ptr %slot.bs, align 8, !dbg !276
  %r36 = load i64, ptr %slot.n, align 8, !dbg !276
  %r37 = load i64, ptr %slot.st, align 8, !dbg !276
  %r38 = call i64 @_tm_skip_to_eol(i64 %r35, i64 %r36, i64 %r37), !dbg !276
  br label %endif83, !dbg !276
else82:
  %r39 = add i64 0, 0, !dbg !277
  store i64 %r39, ptr %slot.go, align 8, !dbg !277
  br label %endif83, !dbg !277
endif83:
  br label %endif80, !dbg !277
endif80:
  br label %endif77, !dbg !277
endif77:
  br label %endif74, !dbg !277
endif74:
  br label %while_hdr69, !dbg !277
while_exit71:
  ret i64 0, !dbg !277
}

; ESCAPE _tm_parse_basic_string: allocs=0 escape=0 local=0
define i64 @_tm_parse_basic_string(i64 %p0, i64 %p1, i64 %p2) nounwind uwtable !dbg !278 {
entry:
  %slot.bs = alloca i64, align 8, !dbg !279
  store i64 %p0, ptr %slot.bs, align 8, !dbg !279
  %slot.n = alloca i64, align 8, !dbg !279
  store i64 %p1, ptr %slot.n, align 8, !dbg !279
  %slot.st = alloca i64, align 8, !dbg !279
  store i64 %p2, ptr %slot.st, align 8, !dbg !279
  %slot.buf = alloca i64, align 8, !dbg !279
  store i64 0, ptr %slot.buf, align 8, !dbg !279
  %slot.go = alloca i64, align 8, !dbg !279
  store i64 0, ptr %slot.go, align 8, !dbg !279
  %slot.p = alloca i64, align 8, !dbg !279
  store i64 0, ptr %slot.p, align 8, !dbg !279
  %slot.o = alloca i64, align 8, !dbg !279
  store i64 0, ptr %slot.o, align 8, !dbg !279
  %slot.q = alloca i64, align 8, !dbg !279
  store i64 0, ptr %slot.q, align 8, !dbg !279
  %slot.eo = alloca i64, align 8, !dbg !279
  store i64 0, ptr %slot.eo, align 8, !dbg !279
  %r0 = call i64 @nova_rt_buffer_create(), !dbg !280
  store i64 %r0, ptr %slot.buf, align 8, !dbg !280
  %r1 = add i64 1, 0, !dbg !281
  store i64 %r1, ptr %slot.go, align 8, !dbg !281
  br label %while_hdr84, !dbg !282
while_hdr84:
  %r2 = load i64, ptr %slot.go, align 8, !dbg !282
  %r3 = add i64 1, 0, !dbg !282
  %r4.cmp = icmp eq i64 %r2, %r3, !dbg !282
  %r4 = zext i1 %r4.cmp to i64, !dbg !282
  %br_while_body850 = icmp ne i64 %r4, 0, !dbg !282
  br i1 %br_while_body850, label %while_body85, label %while_exit86, !prof !90, !dbg !282
while_body85:
  %r5 = load i64, ptr %slot.st, align 8, !dbg !283
  %r6.p = getelementptr inbounds [4 x i8], ptr @.str.0, i64 0, i64 0, !dbg !283
  %r6 = ptrtoint ptr %r6.p to i64, !dbg !283
  %r7 = call i64 @nova_rt_index_get(i64 %r5, i64 %r6), !dbg !283
  store i64 %r7, ptr %slot.p, align 8, !dbg !283
  %r8 = add i64 %r7, 0, !dbg !284
  %r9 = load i64, ptr %slot.n, align 8, !dbg !284
  %r10 = call i64 @nova_rt_ge(i64 %r8, i64 %r9), !dbg !284
  %br_then871 = icmp ne i64 %r10, 0, !dbg !284
  br i1 %br_then871, label %then87, label %else88, !dbg !284
then87:
  %r11 = add i64 0, 0, !dbg !285
  store i64 %r11, ptr %slot.go, align 8, !dbg !285
  br label %endif89, !dbg !285
else88:
  %r12 = load i64, ptr %slot.bs, align 8, !dbg !286
  %r13 = load i64, ptr %slot.p, align 8, !dbg !286
  %r14 = call i64 @nova_rt_bytes_get(i64 %r12, i64 %r13), !dbg !286
  store i64 %r14, ptr %slot.o, align 8, !dbg !286
  %r15 = add i64 %r14, 0, !dbg !287
  %r16 = add i64 34, 0, !dbg !287
  %r17.cmp = icmp eq i64 %r15, %r16, !dbg !287
  %r17 = zext i1 %r17.cmp to i64, !dbg !287
  %br_then902 = icmp ne i64 %r17, 0, !dbg !287
  br i1 %br_then902, label %then90, label %else91, !dbg !287
then90:
  %r18 = load i64, ptr %slot.p, align 8, !dbg !288
  %r19 = add i64 1, 0, !dbg !288
  %r20 = call i64 @nova_rt_add(i64 %r18, i64 %r19), !dbg !288
  %r21 = load i64, ptr %slot.st, align 8, !dbg !288
  %r22.p = getelementptr inbounds [4 x i8], ptr @.str.0, i64 0, i64 0, !dbg !288
  %r22 = ptrtoint ptr %r22.p to i64, !dbg !288
  %_is.gv3 = call i64 @nova_rt_index_set(i64 %r21, i64 %r22, i64 %r20), !dbg !288
  %r23 = add i64 0, 0, !dbg !289
  store i64 %r23, ptr %slot.go, align 8, !dbg !289
  br label %endif92, !dbg !289
else91:
  %r24 = load i64, ptr %slot.o, align 8, !dbg !290
  %r25 = add i64 92, 0, !dbg !290
  %r26.cmp = icmp eq i64 %r24, %r25, !dbg !290
  %r26 = zext i1 %r26.cmp to i64, !dbg !290
  %br_then934 = icmp ne i64 %r26, 0, !dbg !290
  br i1 %br_then934, label %then93, label %else94, !dbg !290
then93:
  %r27 = load i64, ptr %slot.p, align 8, !dbg !291
  %r28 = add i64 1, 0, !dbg !291
  %r29 = call i64 @nova_rt_add(i64 %r27, i64 %r28), !dbg !291
  %r30 = load i64, ptr %slot.st, align 8, !dbg !291
  %r31.p = getelementptr inbounds [4 x i8], ptr @.str.0, i64 0, i64 0, !dbg !291
  %r31 = ptrtoint ptr %r31.p to i64, !dbg !291
  %_is.gv5 = call i64 @nova_rt_index_set(i64 %r30, i64 %r31, i64 %r29), !dbg !291
  %r32 = load i64, ptr %slot.st, align 8, !dbg !292
  %r33.p = getelementptr inbounds [4 x i8], ptr @.str.0, i64 0, i64 0, !dbg !292
  %r33 = ptrtoint ptr %r33.p to i64, !dbg !292
  %r34 = call i64 @nova_rt_index_get(i64 %r32, i64 %r33), !dbg !292
  store i64 %r34, ptr %slot.q, align 8, !dbg !292
  %r35 = add i64 %r34, 0, !dbg !293
  %r36 = load i64, ptr %slot.n, align 8, !dbg !293
  %r37 = call i64 @nova_rt_lt(i64 %r35, i64 %r36), !dbg !293
  %br_then966 = icmp ne i64 %r37, 0, !dbg !293
  br i1 %br_then966, label %then96, label %else97, !dbg !293
then96:
  %r38 = load i64, ptr %slot.bs, align 8, !dbg !294
  %r39 = load i64, ptr %slot.q, align 8, !dbg !294
  %r40 = call i64 @nova_rt_bytes_get(i64 %r38, i64 %r39), !dbg !294
  store i64 %r40, ptr %slot.eo, align 8, !dbg !294
  %r41 = load i64, ptr %slot.q, align 8, !dbg !295
  %r42 = add i64 1, 0, !dbg !295
  %r43 = call i64 @nova_rt_add(i64 %r41, i64 %r42), !dbg !295
  %r44 = load i64, ptr %slot.st, align 8, !dbg !295
  %r45.p = getelementptr inbounds [4 x i8], ptr @.str.0, i64 0, i64 0, !dbg !295
  %r45 = ptrtoint ptr %r45.p to i64, !dbg !295
  %_is.gv7 = call i64 @nova_rt_index_set(i64 %r44, i64 %r45, i64 %r43), !dbg !295
  %r46 = add i64 %r40, 0, !dbg !296
  %r47 = add i64 110, 0, !dbg !296
  %r48.cmp = icmp eq i64 %r46, %r47, !dbg !296
  %r48 = zext i1 %r48.cmp to i64, !dbg !296
  %br_then998 = icmp ne i64 %r48, 0, !dbg !296
  br i1 %br_then998, label %then99, label %else100, !dbg !296
then99:
  %r49 = load i64, ptr %slot.buf, align 8, !dbg !297
  %r50 = add i64 10, 0, !dbg !297
  %r51 = call i64 @nova_rt_buffer_append_char(i64 %r49, i64 %r50), !dbg !297
  br label %endif101, !dbg !297
else100:
  %r52 = load i64, ptr %slot.eo, align 8, !dbg !298
  %r53 = add i64 116, 0, !dbg !298
  %r54.cmp = icmp eq i64 %r52, %r53, !dbg !298
  %r54 = zext i1 %r54.cmp to i64, !dbg !298
  %br_then1029 = icmp ne i64 %r54, 0, !dbg !298
  br i1 %br_then1029, label %then102, label %else103, !dbg !298
then102:
  %r55 = load i64, ptr %slot.buf, align 8, !dbg !299
  %r56 = add i64 9, 0, !dbg !299
  %r57 = call i64 @nova_rt_buffer_append_char(i64 %r55, i64 %r56), !dbg !299
  br label %endif104, !dbg !299
else103:
  %r58 = load i64, ptr %slot.eo, align 8, !dbg !300
  %r59 = add i64 34, 0, !dbg !300
  %r60.cmp = icmp eq i64 %r58, %r59, !dbg !300
  %r60 = zext i1 %r60.cmp to i64, !dbg !300
  %br_then10510 = icmp ne i64 %r60, 0, !dbg !300
  br i1 %br_then10510, label %then105, label %else106, !dbg !300
then105:
  %r61 = load i64, ptr %slot.buf, align 8, !dbg !301
  %r62 = add i64 34, 0, !dbg !301
  %r63 = call i64 @nova_rt_buffer_append_char(i64 %r61, i64 %r62), !dbg !301
  br label %endif107, !dbg !301
else106:
  %r64 = load i64, ptr %slot.eo, align 8, !dbg !302
  %r65 = add i64 92, 0, !dbg !302
  %r66.cmp = icmp eq i64 %r64, %r65, !dbg !302
  %r66 = zext i1 %r66.cmp to i64, !dbg !302
  %br_then10811 = icmp ne i64 %r66, 0, !dbg !302
  br i1 %br_then10811, label %then108, label %else109, !dbg !302
then108:
  %r67 = load i64, ptr %slot.buf, align 8, !dbg !303
  %r68 = add i64 92, 0, !dbg !303
  %r69 = call i64 @nova_rt_buffer_append_char(i64 %r67, i64 %r68), !dbg !303
  br label %endif110, !dbg !303
else109:
  %r70 = load i64, ptr %slot.eo, align 8, !dbg !304
  %r71 = add i64 114, 0, !dbg !304
  %r72.cmp = icmp eq i64 %r70, %r71, !dbg !304
  %r72 = zext i1 %r72.cmp to i64, !dbg !304
  %br_then11112 = icmp ne i64 %r72, 0, !dbg !304
  br i1 %br_then11112, label %then111, label %else112, !dbg !304
then111:
  %r73 = load i64, ptr %slot.buf, align 8, !dbg !305
  %r74 = add i64 13, 0, !dbg !305
  %r75 = call i64 @nova_rt_buffer_append_char(i64 %r73, i64 %r74), !dbg !305
  br label %endif113, !dbg !305
else112:
  %r76 = load i64, ptr %slot.buf, align 8, !dbg !306
  %r77 = load i64, ptr %slot.eo, align 8, !dbg !306
  %r78 = call i64 @nova_rt_buffer_append_char(i64 %r76, i64 %r77), !dbg !306
  br label %endif113, !dbg !306
endif113:
  br label %endif110, !dbg !306
endif110:
  br label %endif107, !dbg !306
endif107:
  br label %endif104, !dbg !306
endif104:
  br label %endif101, !dbg !306
endif101:
  br label %endif98, !dbg !306
else97:
  br label %endif98, !dbg !306
endif98:
  br label %endif95, !dbg !306
else94:
  %r79 = load i64, ptr %slot.buf, align 8, !dbg !307
  %r80 = load i64, ptr %slot.o, align 8, !dbg !307
  %r81 = call i64 @nova_rt_buffer_append_char(i64 %r79, i64 %r80), !dbg !307
  %r82 = load i64, ptr %slot.p, align 8, !dbg !308
  %r83 = add i64 1, 0, !dbg !308
  %r84 = call i64 @nova_rt_add(i64 %r82, i64 %r83), !dbg !308
  %r85 = load i64, ptr %slot.st, align 8, !dbg !308
  %r86.p = getelementptr inbounds [4 x i8], ptr @.str.0, i64 0, i64 0, !dbg !308
  %r86 = ptrtoint ptr %r86.p to i64, !dbg !308
  %_is.gv13 = call i64 @nova_rt_index_set(i64 %r85, i64 %r86, i64 %r84), !dbg !308
  br label %endif95, !dbg !308
endif95:
  br label %endif92, !dbg !308
endif92:
  br label %endif89, !dbg !308
endif89:
  br label %while_hdr84, !dbg !308
while_exit86:
  %r87 = load i64, ptr %slot.buf, align 8, !dbg !309
  %r88 = call i64 @nova_rt_buffer_to_str(i64 %r87), !dbg !309
  ret i64 %r88, !dbg !309
}

; ESCAPE _tm_parse_literal_string: allocs=0 escape=0 local=0
define i64 @_tm_parse_literal_string(i64 %p0, i64 %p1, i64 %p2, i64 %p3) nounwind uwtable !dbg !310 {
entry:
  %slot.s = alloca i64, align 8, !dbg !311
  store i64 %p0, ptr %slot.s, align 8, !dbg !311
  %slot.bs = alloca i64, align 8, !dbg !311
  store i64 %p1, ptr %slot.bs, align 8, !dbg !311
  %slot.n = alloca i64, align 8, !dbg !311
  store i64 %p2, ptr %slot.n, align 8, !dbg !311
  %slot.st = alloca i64, align 8, !dbg !311
  store i64 %p3, ptr %slot.st, align 8, !dbg !311
  %slot.start = alloca i64, align 8, !dbg !311
  store i64 0, ptr %slot.start, align 8, !dbg !311
  %slot.stop_pos = alloca i64, align 8, !dbg !311
  store i64 0, ptr %slot.stop_pos, align 8, !dbg !311
  %slot.go = alloca i64, align 8, !dbg !311
  store i64 0, ptr %slot.go, align 8, !dbg !311
  %slot.p = alloca i64, align 8, !dbg !311
  store i64 0, ptr %slot.p, align 8, !dbg !311
  %r0 = load i64, ptr %slot.st, align 8, !dbg !312
  %r1.p = getelementptr inbounds [4 x i8], ptr @.str.0, i64 0, i64 0, !dbg !312
  %r1 = ptrtoint ptr %r1.p to i64, !dbg !312
  %r2 = call i64 @nova_rt_index_get(i64 %r0, i64 %r1), !dbg !312
  store i64 %r2, ptr %slot.start, align 8, !dbg !312
  %r3 = add i64 %r2, 0, !dbg !313
  store i64 %r3, ptr %slot.stop_pos, align 8, !dbg !313
  %r4 = add i64 1, 0, !dbg !314
  store i64 %r4, ptr %slot.go, align 8, !dbg !314
  br label %while_hdr114, !dbg !315
while_hdr114:
  %r5 = load i64, ptr %slot.go, align 8, !dbg !315
  %r6 = add i64 1, 0, !dbg !315
  %r7.cmp = icmp eq i64 %r5, %r6, !dbg !315
  %r7 = zext i1 %r7.cmp to i64, !dbg !315
  %br_while_body1150 = icmp ne i64 %r7, 0, !dbg !315
  br i1 %br_while_body1150, label %while_body115, label %while_exit116, !prof !90, !dbg !315
while_body115:
  %r8 = load i64, ptr %slot.st, align 8, !dbg !316
  %r9.p = getelementptr inbounds [4 x i8], ptr @.str.0, i64 0, i64 0, !dbg !316
  %r9 = ptrtoint ptr %r9.p to i64, !dbg !316
  %r10 = call i64 @nova_rt_index_get(i64 %r8, i64 %r9), !dbg !316
  store i64 %r10, ptr %slot.p, align 8, !dbg !316
  %r11 = add i64 %r10, 0, !dbg !317
  %r12 = load i64, ptr %slot.n, align 8, !dbg !317
  %r13 = call i64 @nova_rt_ge(i64 %r11, i64 %r12), !dbg !317
  %br_then1171 = icmp ne i64 %r13, 0, !dbg !317
  br i1 %br_then1171, label %then117, label %else118, !dbg !317
then117:
  %r14 = load i64, ptr %slot.p, align 8, !dbg !318
  store i64 %r14, ptr %slot.stop_pos, align 8, !dbg !318
  %r15 = add i64 0, 0, !dbg !319
  store i64 %r15, ptr %slot.go, align 8, !dbg !319
  br label %endif119, !dbg !319
else118:
  %r16 = load i64, ptr %slot.bs, align 8, !dbg !320
  %r17 = load i64, ptr %slot.p, align 8, !dbg !320
  %r18 = call i64 @nova_rt_bytes_get(i64 %r16, i64 %r17), !dbg !320
  %r19 = add i64 39, 0, !dbg !320
  %r20.cmp = icmp eq i64 %r18, %r19, !dbg !320
  %r20 = zext i1 %r20.cmp to i64, !dbg !320
  %br_then1202 = icmp ne i64 %r20, 0, !dbg !320
  br i1 %br_then1202, label %then120, label %else121, !dbg !320
then120:
  %r21 = load i64, ptr %slot.p, align 8, !dbg !321
  store i64 %r21, ptr %slot.stop_pos, align 8, !dbg !321
  %r22 = load i64, ptr %slot.p, align 8, !dbg !322
  %r23 = add i64 1, 0, !dbg !322
  %r24 = call i64 @nova_rt_add(i64 %r22, i64 %r23), !dbg !322
  %r25 = load i64, ptr %slot.st, align 8, !dbg !322
  %r26.p = getelementptr inbounds [4 x i8], ptr @.str.0, i64 0, i64 0, !dbg !322
  %r26 = ptrtoint ptr %r26.p to i64, !dbg !322
  %_is.gv3 = call i64 @nova_rt_index_set(i64 %r25, i64 %r26, i64 %r24), !dbg !322
  %r27 = add i64 0, 0, !dbg !323
  store i64 %r27, ptr %slot.go, align 8, !dbg !323
  br label %endif122, !dbg !323
else121:
  %r28 = load i64, ptr %slot.p, align 8, !dbg !324
  %r29 = add i64 1, 0, !dbg !324
  %r30 = call i64 @nova_rt_add(i64 %r28, i64 %r29), !dbg !324
  %r31 = load i64, ptr %slot.st, align 8, !dbg !324
  %r32.p = getelementptr inbounds [4 x i8], ptr @.str.0, i64 0, i64 0, !dbg !324
  %r32 = ptrtoint ptr %r32.p to i64, !dbg !324
  %_is.gv4 = call i64 @nova_rt_index_set(i64 %r31, i64 %r32, i64 %r30), !dbg !324
  br label %endif122, !dbg !324
endif122:
  br label %endif119, !dbg !324
endif119:
  br label %while_hdr114, !dbg !324
while_exit116:
  %r33 = load i64, ptr %slot.s, align 8, !dbg !325
  %r34 = load i64, ptr %slot.start, align 8, !dbg !325
  %r35 = load i64, ptr %slot.stop_pos, align 8, !dbg !325
  %r36 = call i64 @nova_rt_slice(i64 %r33, i64 %r34, i64 %r35), !dbg !325
  ret i64 %r36, !dbg !325
}

; ESCAPE _tm_read_bare_key: allocs=0 escape=0 local=0
define i64 @_tm_read_bare_key(i64 %p0, i64 %p1, i64 %p2, i64 %p3) nounwind uwtable !dbg !326 {
entry:
  %slot.s = alloca i64, align 8, !dbg !327
  store i64 %p0, ptr %slot.s, align 8, !dbg !327
  %slot.bs = alloca i64, align 8, !dbg !327
  store i64 %p1, ptr %slot.bs, align 8, !dbg !327
  %slot.n = alloca i64, align 8, !dbg !327
  store i64 %p2, ptr %slot.n, align 8, !dbg !327
  %slot.st = alloca i64, align 8, !dbg !327
  store i64 %p3, ptr %slot.st, align 8, !dbg !327
  %slot.start = alloca i64, align 8, !dbg !327
  store i64 0, ptr %slot.start, align 8, !dbg !327
  %slot.go = alloca i64, align 8, !dbg !327
  store i64 0, ptr %slot.go, align 8, !dbg !327
  %slot.p = alloca i64, align 8, !dbg !327
  store i64 0, ptr %slot.p, align 8, !dbg !327
  %slot.o = alloca i64, align 8, !dbg !327
  store i64 0, ptr %slot.o, align 8, !dbg !327
  %r0 = load i64, ptr %slot.st, align 8, !dbg !328
  %r1.p = getelementptr inbounds [4 x i8], ptr @.str.0, i64 0, i64 0, !dbg !328
  %r1 = ptrtoint ptr %r1.p to i64, !dbg !328
  %r2 = call i64 @nova_rt_index_get(i64 %r0, i64 %r1), !dbg !328
  store i64 %r2, ptr %slot.start, align 8, !dbg !328
  %r3 = add i64 1, 0, !dbg !329
  store i64 %r3, ptr %slot.go, align 8, !dbg !329
  br label %while_hdr123, !dbg !330
while_hdr123:
  %r4 = load i64, ptr %slot.go, align 8, !dbg !330
  %r5 = add i64 1, 0, !dbg !330
  %r6.cmp = icmp eq i64 %r4, %r5, !dbg !330
  %r6 = zext i1 %r6.cmp to i64, !dbg !330
  %br_while_body1240 = icmp ne i64 %r6, 0, !dbg !330
  br i1 %br_while_body1240, label %while_body124, label %while_exit125, !prof !90, !dbg !330
while_body124:
  %r7 = load i64, ptr %slot.st, align 8, !dbg !331
  %r8.p = getelementptr inbounds [4 x i8], ptr @.str.0, i64 0, i64 0, !dbg !331
  %r8 = ptrtoint ptr %r8.p to i64, !dbg !331
  %r9 = call i64 @nova_rt_index_get(i64 %r7, i64 %r8), !dbg !331
  store i64 %r9, ptr %slot.p, align 8, !dbg !331
  %r10 = add i64 %r9, 0, !dbg !332
  %r11 = load i64, ptr %slot.n, align 8, !dbg !332
  %r12 = call i64 @nova_rt_ge(i64 %r10, i64 %r11), !dbg !332
  %br_then1261 = icmp ne i64 %r12, 0, !dbg !332
  br i1 %br_then1261, label %then126, label %else127, !dbg !332
then126:
  %r13 = add i64 0, 0, !dbg !333
  store i64 %r13, ptr %slot.go, align 8, !dbg !333
  br label %endif128, !dbg !333
else127:
  %r14 = load i64, ptr %slot.bs, align 8, !dbg !334
  %r15 = load i64, ptr %slot.p, align 8, !dbg !334
  %r16 = call i64 @nova_rt_bytes_get(i64 %r14, i64 %r15), !dbg !334
  store i64 %r16, ptr %slot.o, align 8, !dbg !334
  %r17 = add i64 %r16, 0, !dbg !335
  %r18 = call i64 @_tm_is_bare_key_char(i64 %r17), !dbg !335
  %r19 = add i64 1, 0, !dbg !335
  %r20.cmp = icmp eq i64 %r18, %r19, !dbg !335
  %r20 = zext i1 %r20.cmp to i64, !dbg !335
  %br_then1292 = icmp ne i64 %r20, 0, !dbg !335
  br i1 %br_then1292, label %then129, label %else130, !dbg !335
then129:
  %r21 = load i64, ptr %slot.p, align 8, !dbg !336
  %r22 = add i64 1, 0, !dbg !336
  %r23 = call i64 @nova_rt_add(i64 %r21, i64 %r22), !dbg !336
  %r24 = load i64, ptr %slot.st, align 8, !dbg !336
  %r25.p = getelementptr inbounds [4 x i8], ptr @.str.0, i64 0, i64 0, !dbg !336
  %r25 = ptrtoint ptr %r25.p to i64, !dbg !336
  %_is.gv3 = call i64 @nova_rt_index_set(i64 %r24, i64 %r25, i64 %r23), !dbg !336
  br label %endif131, !dbg !336
else130:
  %r26 = add i64 0, 0, !dbg !337
  store i64 %r26, ptr %slot.go, align 8, !dbg !337
  br label %endif131, !dbg !337
endif131:
  br label %endif128, !dbg !337
endif128:
  br label %while_hdr123, !dbg !337
while_exit125:
  %r27 = load i64, ptr %slot.s, align 8, !dbg !338
  %r28 = load i64, ptr %slot.start, align 8, !dbg !338
  %r29 = load i64, ptr %slot.st, align 8, !dbg !338
  %r30.p = getelementptr inbounds [4 x i8], ptr @.str.0, i64 0, i64 0, !dbg !338
  %r30 = ptrtoint ptr %r30.p to i64, !dbg !338
  %r31 = call i64 @nova_rt_index_get(i64 %r29, i64 %r30), !dbg !338
  %r32 = call i64 @nova_rt_slice(i64 %r27, i64 %r28, i64 %r31), !dbg !338
  ret i64 %r32, !dbg !338
}

; ESCAPE _tm_read_bare_token: allocs=0 escape=0 local=0
define i64 @_tm_read_bare_token(i64 %p0, i64 %p1, i64 %p2, i64 %p3) nounwind uwtable !dbg !339 {
entry:
  %slot.s = alloca i64, align 8, !dbg !340
  store i64 %p0, ptr %slot.s, align 8, !dbg !340
  %slot.bs = alloca i64, align 8, !dbg !340
  store i64 %p1, ptr %slot.bs, align 8, !dbg !340
  %slot.n = alloca i64, align 8, !dbg !340
  store i64 %p2, ptr %slot.n, align 8, !dbg !340
  %slot.st = alloca i64, align 8, !dbg !340
  store i64 %p3, ptr %slot.st, align 8, !dbg !340
  %slot.start = alloca i64, align 8, !dbg !340
  store i64 0, ptr %slot.start, align 8, !dbg !340
  %slot.go = alloca i64, align 8, !dbg !340
  store i64 0, ptr %slot.go, align 8, !dbg !340
  %slot.p = alloca i64, align 8, !dbg !340
  store i64 0, ptr %slot.p, align 8, !dbg !340
  %slot.o = alloca i64, align 8, !dbg !340
  store i64 0, ptr %slot.o, align 8, !dbg !340
  %slot.stop = alloca i64, align 8, !dbg !340
  store i64 0, ptr %slot.stop, align 8, !dbg !340
  %r0 = load i64, ptr %slot.st, align 8, !dbg !341
  %r1.p = getelementptr inbounds [4 x i8], ptr @.str.0, i64 0, i64 0, !dbg !341
  %r1 = ptrtoint ptr %r1.p to i64, !dbg !341
  %r2 = call i64 @nova_rt_index_get(i64 %r0, i64 %r1), !dbg !341
  store i64 %r2, ptr %slot.start, align 8, !dbg !341
  %r3 = add i64 1, 0, !dbg !342
  store i64 %r3, ptr %slot.go, align 8, !dbg !342
  br label %while_hdr132, !dbg !343
while_hdr132:
  %r4 = load i64, ptr %slot.go, align 8, !dbg !343
  %r5 = add i64 1, 0, !dbg !343
  %r6.cmp = icmp eq i64 %r4, %r5, !dbg !343
  %r6 = zext i1 %r6.cmp to i64, !dbg !343
  %br_while_body1330 = icmp ne i64 %r6, 0, !dbg !343
  br i1 %br_while_body1330, label %while_body133, label %while_exit134, !prof !90, !dbg !343
while_body133:
  %r7 = load i64, ptr %slot.st, align 8, !dbg !344
  %r8.p = getelementptr inbounds [4 x i8], ptr @.str.0, i64 0, i64 0, !dbg !344
  %r8 = ptrtoint ptr %r8.p to i64, !dbg !344
  %r9 = call i64 @nova_rt_index_get(i64 %r7, i64 %r8), !dbg !344
  store i64 %r9, ptr %slot.p, align 8, !dbg !344
  %r10 = add i64 %r9, 0, !dbg !345
  %r11 = load i64, ptr %slot.n, align 8, !dbg !345
  %r12 = call i64 @nova_rt_ge(i64 %r10, i64 %r11), !dbg !345
  %br_then1351 = icmp ne i64 %r12, 0, !dbg !345
  br i1 %br_then1351, label %then135, label %else136, !dbg !345
then135:
  %r13 = add i64 0, 0, !dbg !346
  store i64 %r13, ptr %slot.go, align 8, !dbg !346
  br label %endif137, !dbg !346
else136:
  %r14 = load i64, ptr %slot.bs, align 8, !dbg !347
  %r15 = load i64, ptr %slot.p, align 8, !dbg !347
  %r16 = call i64 @nova_rt_bytes_get(i64 %r14, i64 %r15), !dbg !347
  store i64 %r16, ptr %slot.o, align 8, !dbg !347
  %r17 = add i64 0, 0, !dbg !348
  store i64 %r17, ptr %slot.stop, align 8, !dbg !348
  %r18 = add i64 %r16, 0, !dbg !349
  %r19 = call i64 @_tm_is_hspace(i64 %r18), !dbg !349
  %r20 = add i64 1, 0, !dbg !349
  %r21.cmp = icmp eq i64 %r19, %r20, !dbg !349
  %r21 = zext i1 %r21.cmp to i64, !dbg !349
  %br_then1382 = icmp ne i64 %r21, 0, !dbg !349
  br i1 %br_then1382, label %then138, label %else139, !dbg !349
then138:
  %r22 = add i64 1, 0, !dbg !350
  store i64 %r22, ptr %slot.stop, align 8, !dbg !350
  br label %endif140, !dbg !350
else139:
  %r23 = load i64, ptr %slot.o, align 8, !dbg !351
  %r24 = call i64 @_tm_is_nl(i64 %r23), !dbg !351
  %r25 = add i64 1, 0, !dbg !351
  %r26.cmp = icmp eq i64 %r24, %r25, !dbg !351
  %r26 = zext i1 %r26.cmp to i64, !dbg !351
  %br_then1413 = icmp ne i64 %r26, 0, !dbg !351
  br i1 %br_then1413, label %then141, label %else142, !dbg !351
then141:
  %r27 = add i64 1, 0, !dbg !352
  store i64 %r27, ptr %slot.stop, align 8, !dbg !352
  br label %endif143, !dbg !352
else142:
  %r28 = load i64, ptr %slot.o, align 8, !dbg !353
  %r29 = add i64 44, 0, !dbg !353
  %r30.cmp = icmp eq i64 %r28, %r29, !dbg !353
  %r30 = zext i1 %r30.cmp to i64, !dbg !353
  %br_then1444 = icmp ne i64 %r30, 0, !dbg !353
  br i1 %br_then1444, label %then144, label %else145, !dbg !353
then144:
  %r31 = add i64 1, 0, !dbg !354
  store i64 %r31, ptr %slot.stop, align 8, !dbg !354
  br label %endif146, !dbg !354
else145:
  %r32 = load i64, ptr %slot.o, align 8, !dbg !355
  %r33 = add i64 93, 0, !dbg !355
  %r34.cmp = icmp eq i64 %r32, %r33, !dbg !355
  %r34 = zext i1 %r34.cmp to i64, !dbg !355
  %br_then1475 = icmp ne i64 %r34, 0, !dbg !355
  br i1 %br_then1475, label %then147, label %else148, !dbg !355
then147:
  %r35 = add i64 1, 0, !dbg !356
  store i64 %r35, ptr %slot.stop, align 8, !dbg !356
  br label %endif149, !dbg !356
else148:
  %r36 = load i64, ptr %slot.o, align 8, !dbg !357
  %r37 = add i64 125, 0, !dbg !357
  %r38.cmp = icmp eq i64 %r36, %r37, !dbg !357
  %r38 = zext i1 %r38.cmp to i64, !dbg !357
  %br_then1506 = icmp ne i64 %r38, 0, !dbg !357
  br i1 %br_then1506, label %then150, label %else151, !dbg !357
then150:
  %r39 = add i64 1, 0, !dbg !358
  store i64 %r39, ptr %slot.stop, align 8, !dbg !358
  br label %endif152, !dbg !358
else151:
  %r40 = load i64, ptr %slot.o, align 8, !dbg !359
  %r41 = add i64 35, 0, !dbg !359
  %r42.cmp = icmp eq i64 %r40, %r41, !dbg !359
  %r42 = zext i1 %r42.cmp to i64, !dbg !359
  %br_then1537 = icmp ne i64 %r42, 0, !dbg !359
  br i1 %br_then1537, label %then153, label %else154, !dbg !359
then153:
  %r43 = add i64 1, 0, !dbg !360
  store i64 %r43, ptr %slot.stop, align 8, !dbg !360
  br label %endif155, !dbg !360
else154:
  br label %endif155, !dbg !360
endif155:
  br label %endif152, !dbg !360
endif152:
  br label %endif149, !dbg !360
endif149:
  br label %endif146, !dbg !360
endif146:
  br label %endif143, !dbg !360
endif143:
  br label %endif140, !dbg !360
endif140:
  %r44 = load i64, ptr %slot.stop, align 8, !dbg !361
  %r45 = add i64 1, 0, !dbg !361
  %r46.cmp = icmp eq i64 %r44, %r45, !dbg !361
  %r46 = zext i1 %r46.cmp to i64, !dbg !361
  %br_then1568 = icmp ne i64 %r46, 0, !dbg !361
  br i1 %br_then1568, label %then156, label %else157, !dbg !361
then156:
  %r47 = add i64 0, 0, !dbg !362
  store i64 %r47, ptr %slot.go, align 8, !dbg !362
  br label %endif158, !dbg !362
else157:
  %r48 = load i64, ptr %slot.p, align 8, !dbg !363
  %r49 = add i64 1, 0, !dbg !363
  %r50 = call i64 @nova_rt_add(i64 %r48, i64 %r49), !dbg !363
  %r51 = load i64, ptr %slot.st, align 8, !dbg !363
  %r52.p = getelementptr inbounds [4 x i8], ptr @.str.0, i64 0, i64 0, !dbg !363
  %r52 = ptrtoint ptr %r52.p to i64, !dbg !363
  %_is.gv9 = call i64 @nova_rt_index_set(i64 %r51, i64 %r52, i64 %r50), !dbg !363
  br label %endif158, !dbg !363
endif158:
  br label %endif137, !dbg !363
endif137:
  br label %while_hdr132, !dbg !363
while_exit134:
  %r53 = load i64, ptr %slot.s, align 8, !dbg !364
  %r54 = load i64, ptr %slot.start, align 8, !dbg !364
  %r55 = load i64, ptr %slot.st, align 8, !dbg !364
  %r56.p = getelementptr inbounds [4 x i8], ptr @.str.0, i64 0, i64 0, !dbg !364
  %r56 = ptrtoint ptr %r56.p to i64, !dbg !364
  %r57 = call i64 @nova_rt_index_get(i64 %r55, i64 %r56), !dbg !364
  %r58 = call i64 @nova_rt_slice(i64 %r53, i64 %r54, i64 %r57), !dbg !364
  ret i64 %r58, !dbg !364
}

; ESCAPE _tm_strip_underscores: allocs=0 escape=0 local=0
define i64 @_tm_strip_underscores(i64 %p0) nounwind uwtable !dbg !365 {
entry:
  %slot.tok = alloca i64, align 8, !dbg !366
  store i64 %p0, ptr %slot.tok, align 8, !dbg !366
  %slot.tbs = alloca i64, align 8, !dbg !366
  store i64 0, ptr %slot.tbs, align 8, !dbg !366
  %slot.tn = alloca i64, align 8, !dbg !366
  store i64 0, ptr %slot.tn, align 8, !dbg !366
  %slot.out = alloca i64, align 8, !dbg !366
  store i64 0, ptr %slot.out, align 8, !dbg !366
  %slot.i = alloca i64, align 8, !dbg !366
  store i64 0, ptr %slot.i, align 8, !dbg !366
  %slot.b = alloca i64, align 8, !dbg !366
  store i64 0, ptr %slot.b, align 8, !dbg !366
  %r0 = load i64, ptr %slot.tok, align 8, !dbg !367
  %r1 = call i64 @nova_rt_str_to_bytes(i64 %r0), !dbg !367
  store i64 %r1, ptr %slot.tbs, align 8, !dbg !367
  %r2 = add i64 %r1, 0, !dbg !368
  %r3 = call i64 @nova_rt_bytes_len(i64 %r2), !dbg !368
  store i64 %r3, ptr %slot.tn, align 8, !dbg !368
  %r4 = call i64 @nova_rt_buffer_create(), !dbg !369
  store i64 %r4, ptr %slot.out, align 8, !dbg !369
  %r5 = add i64 0, 0, !dbg !370
  store i64 %r5, ptr %slot.i, align 8, !dbg !370
  br label %while_hdr159, !dbg !371
while_hdr159:
  %r6 = load i64, ptr %slot.i, align 8, !dbg !371
  %r7 = load i64, ptr %slot.tn, align 8, !dbg !371
  %r8.cmp = icmp slt i64 %r6, %r7, !dbg !371
  %r8 = zext i1 %r8.cmp to i64, !dbg !371
  %br_while_body1600 = icmp ne i64 %r8, 0, !dbg !371
  br i1 %br_while_body1600, label %while_body160, label %while_exit161, !prof !90, !dbg !371
while_body160:
  %r9 = load i64, ptr %slot.tbs, align 8, !dbg !372
  %r10 = load i64, ptr %slot.i, align 8, !dbg !372
  %r11 = call i64 @nova_rt_bytes_get(i64 %r9, i64 %r10), !dbg !372
  store i64 %r11, ptr %slot.b, align 8, !dbg !372
  %r12 = add i64 %r11, 0, !dbg !373
  %r13 = add i64 95, 0, !dbg !373
  %r14.cmp = icmp ne i64 %r12, %r13, !dbg !373
  %r14 = zext i1 %r14.cmp to i64, !dbg !373
  %br_then1621 = icmp ne i64 %r14, 0, !dbg !373
  br i1 %br_then1621, label %then162, label %else163, !dbg !373
then162:
  %r15 = load i64, ptr %slot.out, align 8, !dbg !374
  %r16 = load i64, ptr %slot.b, align 8, !dbg !374
  %r17 = call i64 @nova_rt_buffer_append_char(i64 %r15, i64 %r16), !dbg !374
  br label %endif164, !dbg !374
else163:
  br label %endif164, !dbg !374
endif164:
  %r18 = load i64, ptr %slot.i, align 8, !dbg !375
  %r19 = add i64 1, 0, !dbg !375
  %r20 = add i64 %r18, %r19, !dbg !375
  store i64 %r20, ptr %slot.i, align 8, !dbg !375
  br label %while_hdr159, !dbg !375
while_exit161:
  %r21 = load i64, ptr %slot.out, align 8, !dbg !376
  %r22 = call i64 @nova_rt_buffer_to_str(i64 %r21), !dbg !376
  ret i64 %r22, !dbg !376
}

; ESCAPE _tm_is_numeric: allocs=0 escape=0 local=0
define i64 @_tm_is_numeric(i64 %p0) nounwind uwtable !dbg !377 {
entry:
  %slot.tok = alloca i64, align 8, !dbg !378
  store i64 %p0, ptr %slot.tok, align 8, !dbg !378
  %slot.tbs = alloca i64, align 8, !dbg !378
  store i64 0, ptr %slot.tbs, align 8, !dbg !378
  %slot.tn = alloca i64, align 8, !dbg !378
  store i64 0, ptr %slot.tn, align 8, !dbg !378
  %slot.result = alloca i64, align 8, !dbg !378
  store i64 0, ptr %slot.result, align 8, !dbg !378
  %slot.i = alloca i64, align 8, !dbg !378
  store i64 0, ptr %slot.i, align 8, !dbg !378
  %slot.b0 = alloca i64, align 8, !dbg !378
  store i64 0, ptr %slot.b0, align 8, !dbg !378
  %slot.digits_seen = alloca i64, align 8, !dbg !378
  store i64 0, ptr %slot.digits_seen, align 8, !dbg !378
  %slot.dot_seen = alloca i64, align 8, !dbg !378
  store i64 0, ptr %slot.dot_seen, align 8, !dbg !378
  %slot.exp_seen = alloca i64, align 8, !dbg !378
  store i64 0, ptr %slot.exp_seen, align 8, !dbg !378
  %slot.ok = alloca i64, align 8, !dbg !378
  store i64 0, ptr %slot.ok, align 8, !dbg !378
  %slot.b = alloca i64, align 8, !dbg !378
  store i64 0, ptr %slot.b, align 8, !dbg !378
  %slot.__sc_183 = alloca i64, align 8, !dbg !378
  store i64 0, ptr %slot.__sc_183, align 8, !dbg !378
  %slot.__sc_186 = alloca i64, align 8, !dbg !378
  store i64 0, ptr %slot.__sc_186, align 8, !dbg !378
  %slot.__sc_192 = alloca i64, align 8, !dbg !378
  store i64 0, ptr %slot.__sc_192, align 8, !dbg !378
  %slot.__sc_195 = alloca i64, align 8, !dbg !378
  store i64 0, ptr %slot.__sc_195, align 8, !dbg !378
  %slot.__sc_198 = alloca i64, align 8, !dbg !378
  store i64 0, ptr %slot.__sc_198, align 8, !dbg !378
  %slot.bn = alloca i64, align 8, !dbg !378
  store i64 0, ptr %slot.bn, align 8, !dbg !378
  %slot.__sc_207 = alloca i64, align 8, !dbg !378
  store i64 0, ptr %slot.__sc_207, align 8, !dbg !378
  %slot.__sc_213 = alloca i64, align 8, !dbg !378
  store i64 0, ptr %slot.__sc_213, align 8, !dbg !378
  %r0 = load i64, ptr %slot.tok, align 8, !dbg !379
  %r1 = call i64 @nova_rt_str_to_bytes(i64 %r0), !dbg !379
  store i64 %r1, ptr %slot.tbs, align 8, !dbg !379
  %r2 = add i64 %r1, 0, !dbg !380
  %r3 = call i64 @nova_rt_bytes_len(i64 %r2), !dbg !380
  store i64 %r3, ptr %slot.tn, align 8, !dbg !380
  %r4 = add i64 0, 0, !dbg !381
  store i64 %r4, ptr %slot.result, align 8, !dbg !381
  %r5 = add i64 %r3, 0, !dbg !382
  %r6 = add i64 0, 0, !dbg !382
  %r7.cmp = icmp sgt i64 %r5, %r6, !dbg !382
  %r7 = zext i1 %r7.cmp to i64, !dbg !382
  %br_then1650 = icmp ne i64 %r7, 0, !dbg !382
  br i1 %br_then1650, label %then165, label %else166, !dbg !382
then165:
  %r8 = add i64 0, 0, !dbg !383
  store i64 %r8, ptr %slot.i, align 8, !dbg !383
  %r9 = load i64, ptr %slot.tbs, align 8, !dbg !384
  %r10 = add i64 0, 0, !dbg !384
  %r11 = call i64 @nova_rt_bytes_get(i64 %r9, i64 %r10), !dbg !384
  store i64 %r11, ptr %slot.b0, align 8, !dbg !384
  %r12 = add i64 %r11, 0, !dbg !385
  %r13 = add i64 45, 0, !dbg !385
  %r14.cmp = icmp eq i64 %r12, %r13, !dbg !385
  %r14 = zext i1 %r14.cmp to i64, !dbg !385
  %br_then1681 = icmp ne i64 %r14, 0, !dbg !385
  br i1 %br_then1681, label %then168, label %else169, !dbg !385
then168:
  %r15 = add i64 1, 0, !dbg !386
  store i64 %r15, ptr %slot.i, align 8, !dbg !386
  br label %endif170, !dbg !386
else169:
  %r16 = load i64, ptr %slot.b0, align 8, !dbg !387
  %r17 = add i64 43, 0, !dbg !387
  %r18.cmp = icmp eq i64 %r16, %r17, !dbg !387
  %r18 = zext i1 %r18.cmp to i64, !dbg !387
  %br_then1712 = icmp ne i64 %r18, 0, !dbg !387
  br i1 %br_then1712, label %then171, label %else172, !dbg !387
then171:
  %r19 = add i64 1, 0, !dbg !388
  store i64 %r19, ptr %slot.i, align 8, !dbg !388
  br label %endif173, !dbg !388
else172:
  br label %endif173, !dbg !388
endif173:
  br label %endif170, !dbg !388
endif170:
  %r20 = load i64, ptr %slot.i, align 8, !dbg !389
  %r21 = load i64, ptr %slot.tn, align 8, !dbg !389
  %r22.cmp = icmp slt i64 %r20, %r21, !dbg !389
  %r22 = zext i1 %r22.cmp to i64, !dbg !389
  %br_then1743 = icmp ne i64 %r22, 0, !dbg !389
  br i1 %br_then1743, label %then174, label %else175, !dbg !389
then174:
  %r23 = add i64 0, 0, !dbg !390
  store i64 %r23, ptr %slot.digits_seen, align 8, !dbg !390
  %r24 = add i64 0, 0, !dbg !391
  store i64 %r24, ptr %slot.dot_seen, align 8, !dbg !391
  %r25 = add i64 0, 0, !dbg !392
  store i64 %r25, ptr %slot.exp_seen, align 8, !dbg !392
  %r26 = add i64 1, 0, !dbg !393
  store i64 %r26, ptr %slot.ok, align 8, !dbg !393
  br label %while_hdr177, !dbg !394
while_hdr177:
  %r27 = load i64, ptr %slot.i, align 8, !dbg !394
  %r28 = load i64, ptr %slot.tn, align 8, !dbg !394
  %r29.cmp = icmp slt i64 %r27, %r28, !dbg !394
  %r29 = zext i1 %r29.cmp to i64, !dbg !394
  %br_while_body1784 = icmp ne i64 %r29, 0, !dbg !394
  br i1 %br_while_body1784, label %while_body178, label %while_exit179, !prof !90, !dbg !394
while_body178:
  %r30 = load i64, ptr %slot.tbs, align 8, !dbg !395
  %r31 = load i64, ptr %slot.i, align 8, !dbg !395
  %r32 = call i64 @nova_rt_bytes_get(i64 %r30, i64 %r31), !dbg !395
  store i64 %r32, ptr %slot.b, align 8, !dbg !395
  %r33 = add i64 %r32, 0, !dbg !396
  %r34 = call i64 @_tm_is_digit(i64 %r33), !dbg !396
  %r35 = add i64 1, 0, !dbg !396
  %r36.cmp = icmp eq i64 %r34, %r35, !dbg !396
  %r36 = zext i1 %r36.cmp to i64, !dbg !396
  %br_then1805 = icmp ne i64 %r36, 0, !dbg !396
  br i1 %br_then1805, label %then180, label %else181, !dbg !396
then180:
  %r37 = add i64 1, 0, !dbg !397
  store i64 %r37, ptr %slot.digits_seen, align 8, !dbg !397
  %r38 = load i64, ptr %slot.i, align 8, !dbg !398
  %r39 = add i64 1, 0, !dbg !398
  %r40 = add i64 %r38, %r39, !dbg !398
  store i64 %r40, ptr %slot.i, align 8, !dbg !398
  br label %endif182, !dbg !398
else181:
  %r41 = load i64, ptr %slot.b, align 8, !dbg !399
  %r42 = add i64 46, 0, !dbg !399
  %r43.cmp = icmp eq i64 %r41, %r42, !dbg !399
  %r43 = zext i1 %r43.cmp to i64, !dbg !399
  store i64 %r43, ptr %slot.__sc_183, align 8, !dbg !399
  %br_and_rhs1846 = icmp ne i64 %r43, 0, !dbg !399
  br i1 %br_and_rhs1846, label %and_rhs184, label %and_merge185, !dbg !399
and_rhs184:
  %r44 = load i64, ptr %slot.dot_seen, align 8, !dbg !399
  %r45 = add i64 0, 0, !dbg !399
  %r46.cmp = icmp eq i64 %r44, %r45, !dbg !399
  %r46 = zext i1 %r46.cmp to i64, !dbg !399
  store i64 %r46, ptr %slot.__sc_183, align 8, !dbg !399
  br label %and_merge185, !dbg !399
and_merge185:
  %r47 = load i64, ptr %slot.__sc_183, align 8, !dbg !399
  store i64 %r47, ptr %slot.__sc_186, align 8, !dbg !399
  %br_and_rhs1877 = icmp ne i64 %r47, 0, !dbg !399
  br i1 %br_and_rhs1877, label %and_rhs187, label %and_merge188, !dbg !399
and_rhs187:
  %r48 = load i64, ptr %slot.exp_seen, align 8, !dbg !399
  %r49 = add i64 0, 0, !dbg !399
  %r50.cmp = icmp eq i64 %r48, %r49, !dbg !399
  %r50 = zext i1 %r50.cmp to i64, !dbg !399
  store i64 %r50, ptr %slot.__sc_186, align 8, !dbg !399
  br label %and_merge188, !dbg !399
and_merge188:
  %r51 = load i64, ptr %slot.__sc_186, align 8, !dbg !399
  %br_then1898 = icmp ne i64 %r51, 0, !dbg !399
  br i1 %br_then1898, label %then189, label %else190, !dbg !399
then189:
  %r52 = add i64 1, 0, !dbg !400
  store i64 %r52, ptr %slot.dot_seen, align 8, !dbg !400
  %r53 = load i64, ptr %slot.i, align 8, !dbg !401
  %r54 = add i64 1, 0, !dbg !401
  %r55 = add i64 %r53, %r54, !dbg !401
  store i64 %r55, ptr %slot.i, align 8, !dbg !401
  br label %endif191, !dbg !401
else190:
  %r56 = load i64, ptr %slot.b, align 8, !dbg !402
  %r57 = add i64 101, 0, !dbg !402
  %r58.cmp = icmp eq i64 %r56, %r57, !dbg !402
  %r58 = zext i1 %r58.cmp to i64, !dbg !402
  store i64 %r58, ptr %slot.__sc_192, align 8, !dbg !402
  %br_or_merge1949 = icmp ne i64 %r58, 0, !dbg !402
  br i1 %br_or_merge1949, label %or_merge194, label %or_rhs193, !dbg !402
or_rhs193:
  %r59 = load i64, ptr %slot.b, align 8, !dbg !402
  %r60 = add i64 69, 0, !dbg !402
  %r61.cmp = icmp eq i64 %r59, %r60, !dbg !402
  %r61 = zext i1 %r61.cmp to i64, !dbg !402
  store i64 %r61, ptr %slot.__sc_192, align 8, !dbg !402
  br label %or_merge194, !dbg !402
or_merge194:
  %r62 = load i64, ptr %slot.__sc_192, align 8, !dbg !402
  store i64 %r62, ptr %slot.__sc_195, align 8, !dbg !402
  %br_and_rhs19610 = icmp ne i64 %r62, 0, !dbg !402
  br i1 %br_and_rhs19610, label %and_rhs196, label %and_merge197, !dbg !402
and_rhs196:
  %r63 = load i64, ptr %slot.exp_seen, align 8, !dbg !402
  %r64 = add i64 0, 0, !dbg !402
  %r65.cmp = icmp eq i64 %r63, %r64, !dbg !402
  %r65 = zext i1 %r65.cmp to i64, !dbg !402
  store i64 %r65, ptr %slot.__sc_195, align 8, !dbg !402
  br label %and_merge197, !dbg !402
and_merge197:
  %r66 = load i64, ptr %slot.__sc_195, align 8, !dbg !402
  store i64 %r66, ptr %slot.__sc_198, align 8, !dbg !402
  %br_and_rhs19911 = icmp ne i64 %r66, 0, !dbg !402
  br i1 %br_and_rhs19911, label %and_rhs199, label %and_merge200, !dbg !402
and_rhs199:
  %r67 = load i64, ptr %slot.digits_seen, align 8, !dbg !402
  %r68 = add i64 1, 0, !dbg !402
  %r69.cmp = icmp eq i64 %r67, %r68, !dbg !402
  %r69 = zext i1 %r69.cmp to i64, !dbg !402
  store i64 %r69, ptr %slot.__sc_198, align 8, !dbg !402
  br label %and_merge200, !dbg !402
and_merge200:
  %r70 = load i64, ptr %slot.__sc_198, align 8, !dbg !402
  %br_then20112 = icmp ne i64 %r70, 0, !dbg !402
  br i1 %br_then20112, label %then201, label %else202, !dbg !402
then201:
  %r71 = add i64 1, 0, !dbg !403
  store i64 %r71, ptr %slot.exp_seen, align 8, !dbg !403
  %r72 = load i64, ptr %slot.i, align 8, !dbg !404
  %r73 = add i64 1, 0, !dbg !404
  %r74 = add i64 %r72, %r73, !dbg !404
  store i64 %r74, ptr %slot.i, align 8, !dbg !404
  %r75 = add i64 %r74, 0, !dbg !405
  %r76 = load i64, ptr %slot.tn, align 8, !dbg !405
  %r77.cmp = icmp slt i64 %r75, %r76, !dbg !405
  %r77 = zext i1 %r77.cmp to i64, !dbg !405
  %br_then20413 = icmp ne i64 %r77, 0, !dbg !405
  br i1 %br_then20413, label %then204, label %else205, !dbg !405
then204:
  %r78 = load i64, ptr %slot.tbs, align 8, !dbg !406
  %r79 = load i64, ptr %slot.i, align 8, !dbg !406
  %r80 = call i64 @nova_rt_bytes_get(i64 %r78, i64 %r79), !dbg !406
  store i64 %r80, ptr %slot.bn, align 8, !dbg !406
  %r81 = add i64 %r80, 0, !dbg !407
  %r82 = add i64 43, 0, !dbg !407
  %r83.cmp = icmp eq i64 %r81, %r82, !dbg !407
  %r83 = zext i1 %r83.cmp to i64, !dbg !407
  store i64 %r83, ptr %slot.__sc_207, align 8, !dbg !407
  %br_or_merge20914 = icmp ne i64 %r83, 0, !dbg !407
  br i1 %br_or_merge20914, label %or_merge209, label %or_rhs208, !dbg !407
or_rhs208:
  %r84 = load i64, ptr %slot.bn, align 8, !dbg !407
  %r85 = add i64 45, 0, !dbg !407
  %r86.cmp = icmp eq i64 %r84, %r85, !dbg !407
  %r86 = zext i1 %r86.cmp to i64, !dbg !407
  store i64 %r86, ptr %slot.__sc_207, align 8, !dbg !407
  br label %or_merge209, !dbg !407
or_merge209:
  %r87 = load i64, ptr %slot.__sc_207, align 8, !dbg !407
  %br_then21015 = icmp ne i64 %r87, 0, !dbg !407
  br i1 %br_then21015, label %then210, label %else211, !dbg !407
then210:
  %r88 = load i64, ptr %slot.i, align 8, !dbg !408
  %r89 = add i64 1, 0, !dbg !408
  %r90 = add i64 %r88, %r89, !dbg !408
  store i64 %r90, ptr %slot.i, align 8, !dbg !408
  br label %endif212, !dbg !408
else211:
  br label %endif212, !dbg !408
endif212:
  br label %endif206, !dbg !408
else205:
  br label %endif206, !dbg !408
endif206:
  br label %endif203, !dbg !408
else202:
  %r91 = add i64 0, 0, !dbg !409
  store i64 %r91, ptr %slot.ok, align 8, !dbg !409
  %r92 = load i64, ptr %slot.tn, align 8, !dbg !410
  store i64 %r92, ptr %slot.i, align 8, !dbg !410
  br label %endif203, !dbg !410
endif203:
  br label %endif191, !dbg !410
endif191:
  br label %endif182, !dbg !410
endif182:
  br label %while_hdr177, !dbg !410
while_exit179:
  %r93 = load i64, ptr %slot.ok, align 8, !dbg !411
  %r94 = add i64 1, 0, !dbg !411
  %r95.cmp = icmp eq i64 %r93, %r94, !dbg !411
  %r95 = zext i1 %r95.cmp to i64, !dbg !411
  store i64 %r95, ptr %slot.__sc_213, align 8, !dbg !411
  %br_and_rhs21416 = icmp ne i64 %r95, 0, !dbg !411
  br i1 %br_and_rhs21416, label %and_rhs214, label %and_merge215, !dbg !411
and_rhs214:
  %r96 = load i64, ptr %slot.digits_seen, align 8, !dbg !411
  %r97 = add i64 1, 0, !dbg !411
  %r98.cmp = icmp eq i64 %r96, %r97, !dbg !411
  %r98 = zext i1 %r98.cmp to i64, !dbg !411
  store i64 %r98, ptr %slot.__sc_213, align 8, !dbg !411
  br label %and_merge215, !dbg !411
and_merge215:
  %r99 = load i64, ptr %slot.__sc_213, align 8, !dbg !411
  %br_then21617 = icmp ne i64 %r99, 0, !dbg !411
  br i1 %br_then21617, label %then216, label %else217, !dbg !411
then216:
  %r100 = add i64 1, 0, !dbg !412
  store i64 %r100, ptr %slot.result, align 8, !dbg !412
  br label %endif218, !dbg !412
else217:
  br label %endif218, !dbg !412
endif218:
  br label %endif176, !dbg !412
else175:
  br label %endif176, !dbg !412
endif176:
  br label %endif167, !dbg !412
else166:
  br label %endif167, !dbg !412
endif167:
  %r101 = load i64, ptr %slot.result, align 8, !dbg !413
  ret i64 %r101, !dbg !413
}

; ESCAPE _tm_classify_scalar: allocs=0 escape=0 local=0
define i64 @_tm_classify_scalar(i64 %p0) nounwind uwtable !dbg !414 {
entry:
  %slot.tok = alloca i64, align 8, !dbg !415
  store i64 %p0, ptr %slot.tok, align 8, !dbg !415
  %slot.result = alloca i64, align 8, !dbg !415
  store i64 0, ptr %slot.result, align 8, !dbg !415
  %slot.cleaned = alloca i64, align 8, !dbg !415
  store i64 0, ptr %slot.cleaned, align 8, !dbg !415
  %slot.__sc_228 = alloca i64, align 8, !dbg !415
  store i64 0, ptr %slot.__sc_228, align 8, !dbg !415
  %slot.__sc_231 = alloca i64, align 8, !dbg !415
  store i64 0, ptr %slot.__sc_231, align 8, !dbg !415
  %r0 = add i64 0, 0, !dbg !416
  store i64 %r0, ptr %slot.result, align 8, !dbg !416
  %r1 = load i64, ptr %slot.tok, align 8, !dbg !417
  %r2.p = getelementptr inbounds [5 x i8], ptr @.str.1, i64 0, i64 0, !dbg !417
  %r2 = ptrtoint ptr %r2.p to i64, !dbg !417
  %r3.p0 = inttoptr i64 %r1 to ptr, !dbg !417
  %r3.p1 = inttoptr i64 %r2 to ptr, !dbg !417
  %r3.sc = call i32 @strcmp(ptr %r3.p0, ptr %r3.p1), !dbg !417
  %r3.cmp = icmp eq i32 %r3.sc, 0, !dbg !417
  %r3 = zext i1 %r3.cmp to i64, !dbg !417
  %br_then2190 = icmp ne i64 %r3, 0, !dbg !417
  br i1 %br_then2190, label %then219, label %else220, !dbg !417
then219:
  %r4 = add i64 1, 0, !dbg !418
  store i64 %r4, ptr %slot.result, align 8, !dbg !418
  br label %endif221, !dbg !418
else220:
  %r5 = load i64, ptr %slot.tok, align 8, !dbg !419
  %r6.p = getelementptr inbounds [6 x i8], ptr @.str.2, i64 0, i64 0, !dbg !419
  %r6 = ptrtoint ptr %r6.p to i64, !dbg !419
  %r7.p0 = inttoptr i64 %r5 to ptr, !dbg !419
  %r7.p1 = inttoptr i64 %r6 to ptr, !dbg !419
  %r7.sc = call i32 @strcmp(ptr %r7.p0, ptr %r7.p1), !dbg !419
  %r7.cmp = icmp eq i32 %r7.sc, 0, !dbg !419
  %r7 = zext i1 %r7.cmp to i64, !dbg !419
  %br_then2221 = icmp ne i64 %r7, 0, !dbg !419
  br i1 %br_then2221, label %then222, label %else223, !dbg !419
then222:
  %r8 = add i64 0, 0, !dbg !420
  store i64 %r8, ptr %slot.result, align 8, !dbg !420
  br label %endif224, !dbg !420
else223:
  %r9 = load i64, ptr %slot.tok, align 8, !dbg !421
  %r10 = call i64 @_tm_strip_underscores(i64 %r9), !dbg !421
  store i64 %r10, ptr %slot.cleaned, align 8, !dbg !421
  %r11 = add i64 %r10, 0, !dbg !422
  %r12 = call i64 @_tm_is_numeric(i64 %r11), !dbg !422
  %r13 = add i64 1, 0, !dbg !422
  %r14.cmp = icmp eq i64 %r12, %r13, !dbg !422
  %r14 = zext i1 %r14.cmp to i64, !dbg !422
  %br_then2252 = icmp ne i64 %r14, 0, !dbg !422
  br i1 %br_then2252, label %then225, label %else226, !dbg !422
then225:
  %r15 = load i64, ptr %slot.cleaned, align 8, !dbg !423
  %r16.p = getelementptr inbounds [2 x i8], ptr @.str.3, i64 0, i64 0, !dbg !423
  %r16 = ptrtoint ptr %r16.p to i64, !dbg !423
  %r17 = call i64 @nova_rt_find(i64 %r15, i64 %r16), !dbg !423
  %r18 = add i64 0, 0, !dbg !423
  %r19.cmp = icmp sge i64 %r17, %r18, !dbg !423
  %r19 = zext i1 %r19.cmp to i64, !dbg !423
  store i64 %r19, ptr %slot.__sc_228, align 8, !dbg !423
  %br_or_merge2303 = icmp ne i64 %r19, 0, !dbg !423
  br i1 %br_or_merge2303, label %or_merge230, label %or_rhs229, !dbg !423
or_rhs229:
  %r20 = load i64, ptr %slot.cleaned, align 8, !dbg !423
  %r21.p = getelementptr inbounds [2 x i8], ptr @.str.4, i64 0, i64 0, !dbg !423
  %r21 = ptrtoint ptr %r21.p to i64, !dbg !423
  %r22 = call i64 @nova_rt_find(i64 %r20, i64 %r21), !dbg !423
  %r23 = add i64 0, 0, !dbg !423
  %r24.cmp = icmp sge i64 %r22, %r23, !dbg !423
  %r24 = zext i1 %r24.cmp to i64, !dbg !423
  store i64 %r24, ptr %slot.__sc_228, align 8, !dbg !423
  br label %or_merge230, !dbg !423
or_merge230:
  %r25 = load i64, ptr %slot.__sc_228, align 8, !dbg !423
  store i64 %r25, ptr %slot.__sc_231, align 8, !dbg !423
  %br_or_merge2334 = icmp ne i64 %r25, 0, !dbg !423
  br i1 %br_or_merge2334, label %or_merge233, label %or_rhs232, !dbg !423
or_rhs232:
  %r26 = load i64, ptr %slot.cleaned, align 8, !dbg !423
  %r27.p = getelementptr inbounds [2 x i8], ptr @.str.5, i64 0, i64 0, !dbg !423
  %r27 = ptrtoint ptr %r27.p to i64, !dbg !423
  %r28 = call i64 @nova_rt_find(i64 %r26, i64 %r27), !dbg !423
  %r29 = add i64 0, 0, !dbg !423
  %r30.cmp = icmp sge i64 %r28, %r29, !dbg !423
  %r30 = zext i1 %r30.cmp to i64, !dbg !423
  store i64 %r30, ptr %slot.__sc_231, align 8, !dbg !423
  br label %or_merge233, !dbg !423
or_merge233:
  %r31 = load i64, ptr %slot.__sc_231, align 8, !dbg !423
  %br_then2345 = icmp ne i64 %r31, 0, !dbg !423
  br i1 %br_then2345, label %then234, label %else235, !dbg !423
then234:
  %r32 = load i64, ptr %slot.cleaned, align 8, !dbg !424
  %r33 = call i64 @nova_rt_parse_float(i64 %r32), !dbg !424
  %wbox0 = call i64 @nova_rt_box_float(i64 %r33), !dbg !424
  store i64 %wbox0, ptr %slot.result, align 8, !dbg !424
  br label %endif236, !dbg !424
else235:
  %r34 = load i64, ptr %slot.cleaned, align 8, !dbg !425
  %r35 = call i64 @nova_rt_parse_int(i64 %r34), !dbg !425
  store i64 %r35, ptr %slot.result, align 8, !dbg !425
  br label %endif236, !dbg !425
endif236:
  br label %endif227, !dbg !425
else226:
  %r36 = load i64, ptr %slot.tok, align 8, !dbg !426
  store i64 %r36, ptr %slot.result, align 8, !dbg !426
  br label %endif227, !dbg !426
endif227:
  br label %endif224, !dbg !426
endif224:
  br label %endif221, !dbg !426
endif221:
  %r37 = load i64, ptr %slot.result, align 8, !dbg !427
  ret i64 %r37, !dbg !427
}

; ESCAPE _tm_skip_balanced: allocs=0 escape=0 local=0
define i64 @_tm_skip_balanced(i64 %p0, i64 %p1, i64 %p2, i64 %p3) nounwind uwtable !dbg !428 {
entry:
  %slot.s = alloca i64, align 8, !dbg !429
  store i64 %p0, ptr %slot.s, align 8, !dbg !429
  %slot.bs = alloca i64, align 8, !dbg !429
  store i64 %p1, ptr %slot.bs, align 8, !dbg !429
  %slot.n = alloca i64, align 8, !dbg !429
  store i64 %p2, ptr %slot.n, align 8, !dbg !429
  %slot.st = alloca i64, align 8, !dbg !429
  store i64 %p3, ptr %slot.st, align 8, !dbg !429
  %slot.level = alloca i64, align 8, !dbg !429
  store i64 0, ptr %slot.level, align 8, !dbg !429
  %slot.go = alloca i64, align 8, !dbg !429
  store i64 0, ptr %slot.go, align 8, !dbg !429
  %slot.p = alloca i64, align 8, !dbg !429
  store i64 0, ptr %slot.p, align 8, !dbg !429
  %slot.o = alloca i64, align 8, !dbg !429
  store i64 0, ptr %slot.o, align 8, !dbg !429
  %r0 = add i64 1, 0, !dbg !430
  store i64 %r0, ptr %slot.level, align 8, !dbg !430
  %r1 = add i64 1, 0, !dbg !431
  store i64 %r1, ptr %slot.go, align 8, !dbg !431
  br label %while_hdr237, !dbg !432
while_hdr237:
  %r2 = load i64, ptr %slot.go, align 8, !dbg !432
  %r3 = add i64 1, 0, !dbg !432
  %r4.cmp = icmp eq i64 %r2, %r3, !dbg !432
  %r4 = zext i1 %r4.cmp to i64, !dbg !432
  %br_while_body2380 = icmp ne i64 %r4, 0, !dbg !432
  br i1 %br_while_body2380, label %while_body238, label %while_exit239, !prof !90, !dbg !432
while_body238:
  %r5 = load i64, ptr %slot.st, align 8, !dbg !433
  %r6.p = getelementptr inbounds [4 x i8], ptr @.str.0, i64 0, i64 0, !dbg !433
  %r6 = ptrtoint ptr %r6.p to i64, !dbg !433
  %r7 = call i64 @nova_rt_index_get(i64 %r5, i64 %r6), !dbg !433
  store i64 %r7, ptr %slot.p, align 8, !dbg !433
  %r8 = add i64 %r7, 0, !dbg !434
  %r9 = load i64, ptr %slot.n, align 8, !dbg !434
  %r10 = call i64 @nova_rt_ge(i64 %r8, i64 %r9), !dbg !434
  %br_then2401 = icmp ne i64 %r10, 0, !dbg !434
  br i1 %br_then2401, label %then240, label %else241, !dbg !434
then240:
  %r11 = add i64 0, 0, !dbg !435
  store i64 %r11, ptr %slot.go, align 8, !dbg !435
  br label %endif242, !dbg !435
else241:
  %r12 = load i64, ptr %slot.bs, align 8, !dbg !436
  %r13 = load i64, ptr %slot.p, align 8, !dbg !436
  %r14 = call i64 @nova_rt_bytes_get(i64 %r12, i64 %r13), !dbg !436
  store i64 %r14, ptr %slot.o, align 8, !dbg !436
  %r15 = add i64 %r14, 0, !dbg !437
  %r16 = add i64 34, 0, !dbg !437
  %r17.cmp = icmp eq i64 %r15, %r16, !dbg !437
  %r17 = zext i1 %r17.cmp to i64, !dbg !437
  %br_then2432 = icmp ne i64 %r17, 0, !dbg !437
  br i1 %br_then2432, label %then243, label %else244, !dbg !437
then243:
  %r18 = load i64, ptr %slot.p, align 8, !dbg !438
  %r19 = add i64 1, 0, !dbg !438
  %r20 = call i64 @nova_rt_add(i64 %r18, i64 %r19), !dbg !438
  %r21 = load i64, ptr %slot.st, align 8, !dbg !438
  %r22.p = getelementptr inbounds [4 x i8], ptr @.str.0, i64 0, i64 0, !dbg !438
  %r22 = ptrtoint ptr %r22.p to i64, !dbg !438
  %_is.gv3 = call i64 @nova_rt_index_set(i64 %r21, i64 %r22, i64 %r20), !dbg !438
  %r23 = load i64, ptr %slot.bs, align 8, !dbg !439
  %r24 = load i64, ptr %slot.n, align 8, !dbg !439
  %r25 = load i64, ptr %slot.st, align 8, !dbg !439
  %r26 = call i64 @_tm_parse_basic_string(i64 %r23, i64 %r24, i64 %r25), !dbg !439
  br label %endif245, !dbg !439
else244:
  %r27 = load i64, ptr %slot.o, align 8, !dbg !440
  %r28 = add i64 39, 0, !dbg !440
  %r29.cmp = icmp eq i64 %r27, %r28, !dbg !440
  %r29 = zext i1 %r29.cmp to i64, !dbg !440
  %br_then2464 = icmp ne i64 %r29, 0, !dbg !440
  br i1 %br_then2464, label %then246, label %else247, !dbg !440
then246:
  %r30 = load i64, ptr %slot.p, align 8, !dbg !441
  %r31 = add i64 1, 0, !dbg !441
  %r32 = call i64 @nova_rt_add(i64 %r30, i64 %r31), !dbg !441
  %r33 = load i64, ptr %slot.st, align 8, !dbg !441
  %r34.p = getelementptr inbounds [4 x i8], ptr @.str.0, i64 0, i64 0, !dbg !441
  %r34 = ptrtoint ptr %r34.p to i64, !dbg !441
  %_is.gv5 = call i64 @nova_rt_index_set(i64 %r33, i64 %r34, i64 %r32), !dbg !441
  %r35 = load i64, ptr %slot.s, align 8, !dbg !442
  %r36 = load i64, ptr %slot.bs, align 8, !dbg !442
  %r37 = load i64, ptr %slot.n, align 8, !dbg !442
  %r38 = load i64, ptr %slot.st, align 8, !dbg !442
  %r39 = call i64 @_tm_parse_literal_string(i64 %r35, i64 %r36, i64 %r37, i64 %r38), !dbg !442
  br label %endif248, !dbg !442
else247:
  %r40 = load i64, ptr %slot.o, align 8, !dbg !443
  %r41 = add i64 91, 0, !dbg !443
  %r42.cmp = icmp eq i64 %r40, %r41, !dbg !443
  %r42 = zext i1 %r42.cmp to i64, !dbg !443
  %br_then2496 = icmp ne i64 %r42, 0, !dbg !443
  br i1 %br_then2496, label %then249, label %else250, !dbg !443
then249:
  %r43 = load i64, ptr %slot.level, align 8, !dbg !444
  %r44 = add i64 1, 0, !dbg !444
  %r45 = add i64 %r43, %r44, !dbg !444
  store i64 %r45, ptr %slot.level, align 8, !dbg !444
  %r46 = load i64, ptr %slot.p, align 8, !dbg !445
  %r47 = add i64 1, 0, !dbg !445
  %r48 = call i64 @nova_rt_add(i64 %r46, i64 %r47), !dbg !445
  %r49 = load i64, ptr %slot.st, align 8, !dbg !445
  %r50.p = getelementptr inbounds [4 x i8], ptr @.str.0, i64 0, i64 0, !dbg !445
  %r50 = ptrtoint ptr %r50.p to i64, !dbg !445
  %_is.gv7 = call i64 @nova_rt_index_set(i64 %r49, i64 %r50, i64 %r48), !dbg !445
  br label %endif251, !dbg !445
else250:
  %r51 = load i64, ptr %slot.o, align 8, !dbg !446
  %r52 = add i64 93, 0, !dbg !446
  %r53.cmp = icmp eq i64 %r51, %r52, !dbg !446
  %r53 = zext i1 %r53.cmp to i64, !dbg !446
  %br_then2528 = icmp ne i64 %r53, 0, !dbg !446
  br i1 %br_then2528, label %then252, label %else253, !dbg !446
then252:
  %r54 = load i64, ptr %slot.level, align 8, !dbg !447
  %r55 = add i64 1, 0, !dbg !447
  %r56 = sub i64 %r54, %r55, !dbg !447
  store i64 %r56, ptr %slot.level, align 8, !dbg !447
  %r57 = load i64, ptr %slot.p, align 8, !dbg !448
  %r58 = add i64 1, 0, !dbg !448
  %r59 = call i64 @nova_rt_add(i64 %r57, i64 %r58), !dbg !448
  %r60 = load i64, ptr %slot.st, align 8, !dbg !448
  %r61.p = getelementptr inbounds [4 x i8], ptr @.str.0, i64 0, i64 0, !dbg !448
  %r61 = ptrtoint ptr %r61.p to i64, !dbg !448
  %_is.gv9 = call i64 @nova_rt_index_set(i64 %r60, i64 %r61, i64 %r59), !dbg !448
  %r62 = add i64 %r56, 0, !dbg !449
  %r63 = add i64 0, 0, !dbg !449
  %r64.cmp = icmp sle i64 %r62, %r63, !dbg !449
  %r64 = zext i1 %r64.cmp to i64, !dbg !449
  %br_then25510 = icmp ne i64 %r64, 0, !dbg !449
  br i1 %br_then25510, label %then255, label %else256, !dbg !449
then255:
  %r65 = add i64 0, 0, !dbg !450
  store i64 %r65, ptr %slot.go, align 8, !dbg !450
  br label %endif257, !dbg !450
else256:
  br label %endif257, !dbg !450
endif257:
  br label %endif254, !dbg !450
else253:
  %r66 = load i64, ptr %slot.o, align 8, !dbg !451
  %r67 = add i64 35, 0, !dbg !451
  %r68.cmp = icmp eq i64 %r66, %r67, !dbg !451
  %r68 = zext i1 %r68.cmp to i64, !dbg !451
  %br_then25811 = icmp ne i64 %r68, 0, !dbg !451
  br i1 %br_then25811, label %then258, label %else259, !dbg !451
then258:
  %r69 = load i64, ptr %slot.bs, align 8, !dbg !452
  %r70 = load i64, ptr %slot.n, align 8, !dbg !452
  %r71 = load i64, ptr %slot.st, align 8, !dbg !452
  %r72 = call i64 @_tm_skip_to_eol(i64 %r69, i64 %r70, i64 %r71), !dbg !452
  br label %endif260, !dbg !452
else259:
  %r73 = load i64, ptr %slot.p, align 8, !dbg !453
  %r74 = add i64 1, 0, !dbg !453
  %r75 = call i64 @nova_rt_add(i64 %r73, i64 %r74), !dbg !453
  %r76 = load i64, ptr %slot.st, align 8, !dbg !453
  %r77.p = getelementptr inbounds [4 x i8], ptr @.str.0, i64 0, i64 0, !dbg !453
  %r77 = ptrtoint ptr %r77.p to i64, !dbg !453
  %_is.gv12 = call i64 @nova_rt_index_set(i64 %r76, i64 %r77, i64 %r75), !dbg !453
  br label %endif260, !dbg !453
endif260:
  br label %endif254, !dbg !453
endif254:
  br label %endif251, !dbg !453
endif251:
  br label %endif248, !dbg !453
endif248:
  br label %endif245, !dbg !453
endif245:
  br label %endif242, !dbg !453
endif242:
  br label %while_hdr237, !dbg !453
while_exit239:
  ret i64 0, !dbg !453
}

; ESCAPE _tm_parse_array: allocs=1 escape=1 local=0
define i64 @_tm_parse_array(i64 %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4) nounwind uwtable !dbg !454 {
entry:
  %slot.s = alloca i64, align 8, !dbg !455
  store i64 %p0, ptr %slot.s, align 8, !dbg !455
  %slot.bs = alloca i64, align 8, !dbg !455
  store i64 %p1, ptr %slot.bs, align 8, !dbg !455
  %slot.n = alloca i64, align 8, !dbg !455
  store i64 %p2, ptr %slot.n, align 8, !dbg !455
  %slot.st = alloca i64, align 8, !dbg !455
  store i64 %p3, ptr %slot.st, align 8, !dbg !455
  %slot.depth = alloca i64, align 8, !dbg !455
  store i64 %p4, ptr %slot.depth, align 8, !dbg !455
  %slot.result = alloca i64, align 8, !dbg !455
  store i64 0, ptr %slot.result, align 8, !dbg !455
  %slot.go = alloca i64, align 8, !dbg !455
  store i64 0, ptr %slot.go, align 8, !dbg !455
  %slot.p = alloca i64, align 8, !dbg !455
  store i64 0, ptr %slot.p, align 8, !dbg !455
  %slot.o = alloca i64, align 8, !dbg !455
  store i64 0, ptr %slot.o, align 8, !dbg !455
  %slot.v = alloca i64, align 8, !dbg !455
  store i64 0, ptr %slot.v, align 8, !dbg !455
  %r0 = call i64 @nova_rt_list_create(), !dbg !456
  store i64 %r0, ptr %slot.result, align 8, !dbg !456
  %r1 = add i64 1, 0, !dbg !457
  store i64 %r1, ptr %slot.go, align 8, !dbg !457
  br label %while_hdr261, !dbg !458
while_hdr261:
  %r2 = load i64, ptr %slot.go, align 8, !dbg !458
  %r3 = add i64 1, 0, !dbg !458
  %r4.cmp = icmp eq i64 %r2, %r3, !dbg !458
  %r4 = zext i1 %r4.cmp to i64, !dbg !458
  %br_while_body2620 = icmp ne i64 %r4, 0, !dbg !458
  br i1 %br_while_body2620, label %while_body262, label %while_exit263, !prof !90, !dbg !458
while_body262:
  %r5 = load i64, ptr %slot.bs, align 8, !dbg !459
  %r6 = load i64, ptr %slot.n, align 8, !dbg !459
  %r7 = load i64, ptr %slot.st, align 8, !dbg !459
  %r8 = call i64 @_tm_skip_ws_nl_comments(i64 %r5, i64 %r6, i64 %r7), !dbg !459
  %r9 = load i64, ptr %slot.st, align 8, !dbg !460
  %r10.p = getelementptr inbounds [4 x i8], ptr @.str.0, i64 0, i64 0, !dbg !460
  %r10 = ptrtoint ptr %r10.p to i64, !dbg !460
  %r11 = call i64 @nova_rt_index_get(i64 %r9, i64 %r10), !dbg !460
  store i64 %r11, ptr %slot.p, align 8, !dbg !460
  %r12 = add i64 %r11, 0, !dbg !461
  %r13 = load i64, ptr %slot.n, align 8, !dbg !461
  %r14 = call i64 @nova_rt_ge(i64 %r12, i64 %r13), !dbg !461
  %br_then2641 = icmp ne i64 %r14, 0, !dbg !461
  br i1 %br_then2641, label %then264, label %else265, !dbg !461
then264:
  %r15 = add i64 0, 0, !dbg !462
  store i64 %r15, ptr %slot.go, align 8, !dbg !462
  br label %endif266, !dbg !462
else265:
  %r16 = load i64, ptr %slot.bs, align 8, !dbg !463
  %r17 = load i64, ptr %slot.p, align 8, !dbg !463
  %r18 = call i64 @nova_rt_bytes_get(i64 %r16, i64 %r17), !dbg !463
  store i64 %r18, ptr %slot.o, align 8, !dbg !463
  %r19 = add i64 %r18, 0, !dbg !464
  %r20 = add i64 93, 0, !dbg !464
  %r21.cmp = icmp eq i64 %r19, %r20, !dbg !464
  %r21 = zext i1 %r21.cmp to i64, !dbg !464
  %br_then2672 = icmp ne i64 %r21, 0, !dbg !464
  br i1 %br_then2672, label %then267, label %else268, !dbg !464
then267:
  %r22 = load i64, ptr %slot.p, align 8, !dbg !465
  %r23 = add i64 1, 0, !dbg !465
  %r24 = call i64 @nova_rt_add(i64 %r22, i64 %r23), !dbg !465
  %r25 = load i64, ptr %slot.st, align 8, !dbg !465
  %r26.p = getelementptr inbounds [4 x i8], ptr @.str.0, i64 0, i64 0, !dbg !465
  %r26 = ptrtoint ptr %r26.p to i64, !dbg !465
  %_is.gv3 = call i64 @nova_rt_index_set(i64 %r25, i64 %r26, i64 %r24), !dbg !465
  %r27 = add i64 0, 0, !dbg !466
  store i64 %r27, ptr %slot.go, align 8, !dbg !466
  br label %endif269, !dbg !466
else268:
  %r28 = load i64, ptr %slot.o, align 8, !dbg !467
  %r29 = add i64 44, 0, !dbg !467
  %r30.cmp = icmp eq i64 %r28, %r29, !dbg !467
  %r30 = zext i1 %r30.cmp to i64, !dbg !467
  %br_then2704 = icmp ne i64 %r30, 0, !dbg !467
  br i1 %br_then2704, label %then270, label %else271, !dbg !467
then270:
  %r31 = load i64, ptr %slot.p, align 8, !dbg !468
  %r32 = add i64 1, 0, !dbg !468
  %r33 = call i64 @nova_rt_add(i64 %r31, i64 %r32), !dbg !468
  %r34 = load i64, ptr %slot.st, align 8, !dbg !468
  %r35.p = getelementptr inbounds [4 x i8], ptr @.str.0, i64 0, i64 0, !dbg !468
  %r35 = ptrtoint ptr %r35.p to i64, !dbg !468
  %_is.gv5 = call i64 @nova_rt_index_set(i64 %r34, i64 %r35, i64 %r33), !dbg !468
  br label %endif272, !dbg !468
else271:
  %r36 = load i64, ptr %slot.s, align 8, !dbg !469
  %r37 = load i64, ptr %slot.bs, align 8, !dbg !469
  %r38 = load i64, ptr %slot.n, align 8, !dbg !469
  %r39 = load i64, ptr %slot.st, align 8, !dbg !469
  %r40 = load i64, ptr %slot.depth, align 8, !dbg !469
  %r41 = call i64 @_tm_parse_value(i64 %r36, i64 %r37, i64 %r38, i64 %r39, i64 %r40), !dbg !469
  store i64 %r41, ptr %slot.v, align 8, !dbg !469
  %r42 = load i64, ptr %slot.result, align 8, !dbg !470
  %r43 = add i64 %r41, 0, !dbg !470
  %r44 = call i64 @nova_rt_list_append(i64 %r42, i64 %r43), !dbg !470
  %r45 = load i64, ptr %slot.st, align 8, !dbg !471
  %r46.p = getelementptr inbounds [4 x i8], ptr @.str.0, i64 0, i64 0, !dbg !471
  %r46 = ptrtoint ptr %r46.p to i64, !dbg !471
  %r47 = call i64 @nova_rt_index_get(i64 %r45, i64 %r46), !dbg !471
  %r48 = load i64, ptr %slot.p, align 8, !dbg !471
  %r49 = call i64 @nova_rt_le(i64 %r47, i64 %r48), !dbg !471
  %br_then2736 = icmp ne i64 %r49, 0, !dbg !471
  br i1 %br_then2736, label %then273, label %else274, !dbg !471
then273:
  %r50 = load i64, ptr %slot.p, align 8, !dbg !472
  %r51 = add i64 1, 0, !dbg !472
  %r52 = call i64 @nova_rt_add(i64 %r50, i64 %r51), !dbg !472
  %r53 = load i64, ptr %slot.st, align 8, !dbg !472
  %r54.p = getelementptr inbounds [4 x i8], ptr @.str.0, i64 0, i64 0, !dbg !472
  %r54 = ptrtoint ptr %r54.p to i64, !dbg !472
  %_is.gv7 = call i64 @nova_rt_index_set(i64 %r53, i64 %r54, i64 %r52), !dbg !472
  br label %endif275, !dbg !472
else274:
  br label %endif275, !dbg !472
endif275:
  br label %endif272, !dbg !472
endif272:
  br label %endif269, !dbg !472
endif269:
  br label %endif266, !dbg !472
endif266:
  br label %while_hdr261, !dbg !472
while_exit263:
  %r55 = load i64, ptr %slot.result, align 8, !dbg !473
  ret i64 %r55, !dbg !473
}

; ESCAPE _tm_parse_value: allocs=1 escape=1 local=0
define i64 @_tm_parse_value(i64 %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4) nounwind uwtable !dbg !474 {
entry:
  %slot.s = alloca i64, align 8, !dbg !475
  store i64 %p0, ptr %slot.s, align 8, !dbg !475
  %slot.bs = alloca i64, align 8, !dbg !475
  store i64 %p1, ptr %slot.bs, align 8, !dbg !475
  %slot.n = alloca i64, align 8, !dbg !475
  store i64 %p2, ptr %slot.n, align 8, !dbg !475
  %slot.st = alloca i64, align 8, !dbg !475
  store i64 %p3, ptr %slot.st, align 8, !dbg !475
  %slot.depth = alloca i64, align 8, !dbg !475
  store i64 %p4, ptr %slot.depth, align 8, !dbg !475
  %slot.result = alloca i64, align 8, !dbg !475
  store i64 0, ptr %slot.result, align 8, !dbg !475
  %slot.p = alloca i64, align 8, !dbg !475
  store i64 0, ptr %slot.p, align 8, !dbg !475
  %slot.o = alloca i64, align 8, !dbg !475
  store i64 0, ptr %slot.o, align 8, !dbg !475
  %slot.tok = alloca i64, align 8, !dbg !475
  store i64 0, ptr %slot.tok, align 8, !dbg !475
  %r0 = load i64, ptr %slot.bs, align 8, !dbg !476
  %r1 = load i64, ptr %slot.n, align 8, !dbg !476
  %r2 = load i64, ptr %slot.st, align 8, !dbg !476
  %r3 = call i64 @_tm_skip_h(i64 %r0, i64 %r1, i64 %r2), !dbg !476
  %r4 = add i64 0, 0, !dbg !477
  store i64 %r4, ptr %slot.result, align 8, !dbg !477
  %r5 = load i64, ptr %slot.st, align 8, !dbg !478
  %r6.p = getelementptr inbounds [4 x i8], ptr @.str.0, i64 0, i64 0, !dbg !478
  %r6 = ptrtoint ptr %r6.p to i64, !dbg !478
  %r7 = call i64 @nova_rt_dict_get(i64 %r5, i64 %r6), !dbg !478
  store i64 %r7, ptr %slot.p, align 8, !dbg !478
  %r8 = add i64 %r7, 0, !dbg !479
  %r9 = load i64, ptr %slot.n, align 8, !dbg !479
  %r10 = call i64 @nova_rt_lt(i64 %r8, i64 %r9), !dbg !479
  %br_then2760 = icmp ne i64 %r10, 0, !dbg !479
  br i1 %br_then2760, label %then276, label %else277, !dbg !479
then276:
  %r11 = load i64, ptr %slot.bs, align 8, !dbg !480
  %r12 = load i64, ptr %slot.p, align 8, !dbg !480
  %r13 = call i64 @nova_rt_bytes_get(i64 %r11, i64 %r12), !dbg !480
  store i64 %r13, ptr %slot.o, align 8, !dbg !480
  %r14 = add i64 %r13, 0, !dbg !481
  %r15 = add i64 34, 0, !dbg !481
  %r16.cmp = icmp eq i64 %r14, %r15, !dbg !481
  %r16 = zext i1 %r16.cmp to i64, !dbg !481
  %br_then2791 = icmp ne i64 %r16, 0, !dbg !481
  br i1 %br_then2791, label %then279, label %else280, !dbg !481
then279:
  %r17 = load i64, ptr %slot.p, align 8, !dbg !482
  %r18 = add i64 1, 0, !dbg !482
  %r19 = call i64 @nova_rt_add(i64 %r17, i64 %r18), !dbg !482
  %r20 = load i64, ptr %slot.st, align 8, !dbg !482
  %r21.p = getelementptr inbounds [4 x i8], ptr @.str.0, i64 0, i64 0, !dbg !482
  %r21 = ptrtoint ptr %r21.p to i64, !dbg !482
  %_is.dv2 = call i64 @nova_rt_dict_set(i64 %r20, i64 %r21, i64 %r19), !dbg !482
  %r22 = load i64, ptr %slot.bs, align 8, !dbg !483
  %r23 = load i64, ptr %slot.n, align 8, !dbg !483
  %r24 = load i64, ptr %slot.st, align 8, !dbg !483
  %r25 = call i64 @_tm_parse_basic_string(i64 %r22, i64 %r23, i64 %r24), !dbg !483
  store i64 %r25, ptr %slot.result, align 8, !dbg !483
  br label %endif281, !dbg !483
else280:
  %r26 = load i64, ptr %slot.o, align 8, !dbg !484
  %r27 = add i64 39, 0, !dbg !484
  %r28.cmp = icmp eq i64 %r26, %r27, !dbg !484
  %r28 = zext i1 %r28.cmp to i64, !dbg !484
  %br_then2823 = icmp ne i64 %r28, 0, !dbg !484
  br i1 %br_then2823, label %then282, label %else283, !dbg !484
then282:
  %r29 = load i64, ptr %slot.p, align 8, !dbg !485
  %r30 = add i64 1, 0, !dbg !485
  %r31 = call i64 @nova_rt_add(i64 %r29, i64 %r30), !dbg !485
  %r32 = load i64, ptr %slot.st, align 8, !dbg !485
  %r33.p = getelementptr inbounds [4 x i8], ptr @.str.0, i64 0, i64 0, !dbg !485
  %r33 = ptrtoint ptr %r33.p to i64, !dbg !485
  %_is.dv4 = call i64 @nova_rt_dict_set(i64 %r32, i64 %r33, i64 %r31), !dbg !485
  %r34 = load i64, ptr %slot.s, align 8, !dbg !486
  %r35 = load i64, ptr %slot.bs, align 8, !dbg !486
  %r36 = load i64, ptr %slot.n, align 8, !dbg !486
  %r37 = load i64, ptr %slot.st, align 8, !dbg !486
  %r38 = call i64 @_tm_parse_literal_string(i64 %r34, i64 %r35, i64 %r36, i64 %r37), !dbg !486
  store i64 %r38, ptr %slot.result, align 8, !dbg !486
  br label %endif284, !dbg !486
else283:
  %r39 = load i64, ptr %slot.o, align 8, !dbg !487
  %r40 = add i64 91, 0, !dbg !487
  %r41.cmp = icmp eq i64 %r39, %r40, !dbg !487
  %r41 = zext i1 %r41.cmp to i64, !dbg !487
  %br_then2855 = icmp ne i64 %r41, 0, !dbg !487
  br i1 %br_then2855, label %then285, label %else286, !dbg !487
then285:
  %r42 = load i64, ptr %slot.p, align 8, !dbg !488
  %r43 = add i64 1, 0, !dbg !488
  %r44 = call i64 @nova_rt_add(i64 %r42, i64 %r43), !dbg !488
  %r45 = load i64, ptr %slot.st, align 8, !dbg !488
  %r46.p = getelementptr inbounds [4 x i8], ptr @.str.0, i64 0, i64 0, !dbg !488
  %r46 = ptrtoint ptr %r46.p to i64, !dbg !488
  %_is.dv6 = call i64 @nova_rt_dict_set(i64 %r45, i64 %r46, i64 %r44), !dbg !488
  %r47 = load i64, ptr %slot.depth, align 8, !dbg !489
  %r48 = add i64 1000, 0, !dbg !490
  %r49.cmp = icmp sge i64 %r47, %r48, !dbg !490
  %r49 = zext i1 %r49.cmp to i64, !dbg !490
  %br_then2887 = icmp ne i64 %r49, 0, !dbg !490
  br i1 %br_then2887, label %then288, label %else289, !dbg !490
then288:
  %r50 = load i64, ptr %slot.s, align 8, !dbg !491
  %r51 = load i64, ptr %slot.bs, align 8, !dbg !491
  %r52 = load i64, ptr %slot.n, align 8, !dbg !491
  %r53 = load i64, ptr %slot.st, align 8, !dbg !491
  %r54 = call i64 @_tm_skip_balanced(i64 %r50, i64 %r51, i64 %r52, i64 %r53), !dbg !491
  %r55 = call i64 @nova_rt_list_create(), !dbg !492
  store i64 %r55, ptr %slot.result, align 8, !dbg !492
  br label %endif290, !dbg !492
else289:
  %r56 = load i64, ptr %slot.s, align 8, !dbg !493
  %r57 = load i64, ptr %slot.bs, align 8, !dbg !493
  %r58 = load i64, ptr %slot.n, align 8, !dbg !493
  %r59 = load i64, ptr %slot.st, align 8, !dbg !493
  %r60 = load i64, ptr %slot.depth, align 8, !dbg !493
  %r61 = add i64 1, 0, !dbg !493
  %r62 = add i64 %r60, %r61, !dbg !493
  %r63 = call i64 @_tm_parse_array(i64 %r56, i64 %r57, i64 %r58, i64 %r59, i64 %r62), !dbg !493
  store i64 %r63, ptr %slot.result, align 8, !dbg !493
  br label %endif290, !dbg !493
endif290:
  br label %endif287, !dbg !493
else286:
  %r64 = load i64, ptr %slot.s, align 8, !dbg !494
  %r65 = load i64, ptr %slot.bs, align 8, !dbg !494
  %r66 = load i64, ptr %slot.n, align 8, !dbg !494
  %r67 = load i64, ptr %slot.st, align 8, !dbg !494
  %r68 = call i64 @_tm_read_bare_token(i64 %r64, i64 %r65, i64 %r66, i64 %r67), !dbg !494
  store i64 %r68, ptr %slot.tok, align 8, !dbg !494
  %r69 = add i64 %r68, 0, !dbg !495
  %r70 = call i64 @_tm_classify_scalar(i64 %r69), !dbg !495
  store i64 %r70, ptr %slot.result, align 8, !dbg !495
  br label %endif287, !dbg !495
endif287:
  br label %endif284, !dbg !495
endif284:
  br label %endif281, !dbg !495
endif281:
  br label %endif278, !dbg !495
else277:
  br label %endif278, !dbg !495
endif278:
  %r71 = load i64, ptr %slot.result, align 8, !dbg !496
  ret i64 %r71, !dbg !496
}

; ESCAPE _tm_read_key_path: allocs=1 escape=1 local=0
define i64 @_tm_read_key_path(i64 %p0, i64 %p1, i64 %p2, i64 %p3) nounwind uwtable !dbg !497 {
entry:
  %slot.s = alloca i64, align 8, !dbg !498
  store i64 %p0, ptr %slot.s, align 8, !dbg !498
  %slot.bs = alloca i64, align 8, !dbg !498
  store i64 %p1, ptr %slot.bs, align 8, !dbg !498
  %slot.n = alloca i64, align 8, !dbg !498
  store i64 %p2, ptr %slot.n, align 8, !dbg !498
  %slot.st = alloca i64, align 8, !dbg !498
  store i64 %p3, ptr %slot.st, align 8, !dbg !498
  %slot.segs = alloca i64, align 8, !dbg !498
  store i64 0, ptr %slot.segs, align 8, !dbg !498
  %slot.go = alloca i64, align 8, !dbg !498
  store i64 0, ptr %slot.go, align 8, !dbg !498
  %slot.p = alloca i64, align 8, !dbg !498
  store i64 0, ptr %slot.p, align 8, !dbg !498
  %slot.seg = alloca i64, align 8, !dbg !498
  store i64 0, ptr %slot.seg, align 8, !dbg !498
  %slot.o = alloca i64, align 8, !dbg !498
  store i64 0, ptr %slot.o, align 8, !dbg !498
  %slot.q = alloca i64, align 8, !dbg !498
  store i64 0, ptr %slot.q, align 8, !dbg !498
  %slot.__sc_303 = alloca i64, align 8, !dbg !498
  store i64 0, ptr %slot.__sc_303, align 8, !dbg !498
  %r0 = call i64 @nova_rt_list_create(), !dbg !499
  store i64 %r0, ptr %slot.segs, align 8, !dbg !499
  %r1 = add i64 1, 0, !dbg !500
  store i64 %r1, ptr %slot.go, align 8, !dbg !500
  br label %while_hdr291, !dbg !501
while_hdr291:
  %r2 = load i64, ptr %slot.go, align 8, !dbg !501
  %r3 = add i64 1, 0, !dbg !501
  %r4.cmp = icmp eq i64 %r2, %r3, !dbg !501
  %r4 = zext i1 %r4.cmp to i64, !dbg !501
  %br_while_body2920 = icmp ne i64 %r4, 0, !dbg !501
  br i1 %br_while_body2920, label %while_body292, label %while_exit293, !prof !90, !dbg !501
while_body292:
  %r5 = load i64, ptr %slot.bs, align 8, !dbg !502
  %r6 = load i64, ptr %slot.n, align 8, !dbg !502
  %r7 = load i64, ptr %slot.st, align 8, !dbg !502
  %r8 = call i64 @_tm_skip_h(i64 %r5, i64 %r6, i64 %r7), !dbg !502
  %r9 = load i64, ptr %slot.st, align 8, !dbg !503
  %r10.p = getelementptr inbounds [4 x i8], ptr @.str.0, i64 0, i64 0, !dbg !503
  %r10 = ptrtoint ptr %r10.p to i64, !dbg !503
  %r11 = call i64 @nova_rt_dict_get(i64 %r9, i64 %r10), !dbg !503
  store i64 %r11, ptr %slot.p, align 8, !dbg !503
  %r12.p = getelementptr inbounds [1 x i8], ptr @.str.6, i64 0, i64 0, !dbg !504
  %r12 = ptrtoint ptr %r12.p to i64, !dbg !504
  store i64 %r12, ptr %slot.seg, align 8, !dbg !504
  %r13 = add i64 %r11, 0, !dbg !505
  %r14 = load i64, ptr %slot.n, align 8, !dbg !505
  %r15 = call i64 @nova_rt_lt(i64 %r13, i64 %r14), !dbg !505
  %br_then2941 = icmp ne i64 %r15, 0, !dbg !505
  br i1 %br_then2941, label %then294, label %else295, !dbg !505
then294:
  %r16 = load i64, ptr %slot.bs, align 8, !dbg !506
  %r17 = load i64, ptr %slot.p, align 8, !dbg !506
  %r18 = call i64 @nova_rt_bytes_get(i64 %r16, i64 %r17), !dbg !506
  store i64 %r18, ptr %slot.o, align 8, !dbg !506
  %r19 = add i64 %r18, 0, !dbg !507
  %r20 = add i64 34, 0, !dbg !507
  %r21.cmp = icmp eq i64 %r19, %r20, !dbg !507
  %r21 = zext i1 %r21.cmp to i64, !dbg !507
  %br_then2972 = icmp ne i64 %r21, 0, !dbg !507
  br i1 %br_then2972, label %then297, label %else298, !dbg !507
then297:
  %r22 = load i64, ptr %slot.p, align 8, !dbg !508
  %r23 = add i64 1, 0, !dbg !508
  %r24 = call i64 @nova_rt_add(i64 %r22, i64 %r23), !dbg !508
  %r25 = load i64, ptr %slot.st, align 8, !dbg !508
  %r26.p = getelementptr inbounds [4 x i8], ptr @.str.0, i64 0, i64 0, !dbg !508
  %r26 = ptrtoint ptr %r26.p to i64, !dbg !508
  %_is.dv3 = call i64 @nova_rt_dict_set(i64 %r25, i64 %r26, i64 %r24), !dbg !508
  %r27 = load i64, ptr %slot.bs, align 8, !dbg !509
  %r28 = load i64, ptr %slot.n, align 8, !dbg !509
  %r29 = load i64, ptr %slot.st, align 8, !dbg !509
  %r30 = call i64 @_tm_parse_basic_string(i64 %r27, i64 %r28, i64 %r29), !dbg !509
  store i64 %r30, ptr %slot.seg, align 8, !dbg !509
  br label %endif299, !dbg !509
else298:
  %r31 = load i64, ptr %slot.o, align 8, !dbg !510
  %r32 = add i64 39, 0, !dbg !510
  %r33.cmp = icmp eq i64 %r31, %r32, !dbg !510
  %r33 = zext i1 %r33.cmp to i64, !dbg !510
  %br_then3004 = icmp ne i64 %r33, 0, !dbg !510
  br i1 %br_then3004, label %then300, label %else301, !dbg !510
then300:
  %r34 = load i64, ptr %slot.p, align 8, !dbg !511
  %r35 = add i64 1, 0, !dbg !511
  %r36 = call i64 @nova_rt_add(i64 %r34, i64 %r35), !dbg !511
  %r37 = load i64, ptr %slot.st, align 8, !dbg !511
  %r38.p = getelementptr inbounds [4 x i8], ptr @.str.0, i64 0, i64 0, !dbg !511
  %r38 = ptrtoint ptr %r38.p to i64, !dbg !511
  %_is.dv5 = call i64 @nova_rt_dict_set(i64 %r37, i64 %r38, i64 %r36), !dbg !511
  %r39 = load i64, ptr %slot.s, align 8, !dbg !512
  %r40 = load i64, ptr %slot.bs, align 8, !dbg !512
  %r41 = load i64, ptr %slot.n, align 8, !dbg !512
  %r42 = load i64, ptr %slot.st, align 8, !dbg !512
  %r43 = call i64 @_tm_parse_literal_string(i64 %r39, i64 %r40, i64 %r41, i64 %r42), !dbg !512
  store i64 %r43, ptr %slot.seg, align 8, !dbg !512
  br label %endif302, !dbg !512
else301:
  %r44 = load i64, ptr %slot.s, align 8, !dbg !513
  %r45 = load i64, ptr %slot.bs, align 8, !dbg !513
  %r46 = load i64, ptr %slot.n, align 8, !dbg !513
  %r47 = load i64, ptr %slot.st, align 8, !dbg !513
  %r48 = call i64 @_tm_read_bare_key(i64 %r44, i64 %r45, i64 %r46, i64 %r47), !dbg !513
  store i64 %r48, ptr %slot.seg, align 8, !dbg !513
  br label %endif302, !dbg !513
endif302:
  br label %endif299, !dbg !513
endif299:
  br label %endif296, !dbg !513
else295:
  br label %endif296, !dbg !513
endif296:
  %r49 = load i64, ptr %slot.segs, align 8, !dbg !514
  %r50 = load i64, ptr %slot.seg, align 8, !dbg !514
  %r51 = call i64 @nova_rt_list_append(i64 %r49, i64 %r50), !dbg !514
  %r52 = load i64, ptr %slot.bs, align 8, !dbg !515
  %r53 = load i64, ptr %slot.n, align 8, !dbg !515
  %r54 = load i64, ptr %slot.st, align 8, !dbg !515
  %r55 = call i64 @_tm_skip_h(i64 %r52, i64 %r53, i64 %r54), !dbg !515
  %r56 = load i64, ptr %slot.st, align 8, !dbg !516
  %r57.p = getelementptr inbounds [4 x i8], ptr @.str.0, i64 0, i64 0, !dbg !516
  %r57 = ptrtoint ptr %r57.p to i64, !dbg !516
  %r58 = call i64 @nova_rt_dict_get(i64 %r56, i64 %r57), !dbg !516
  store i64 %r58, ptr %slot.q, align 8, !dbg !516
  %r59 = add i64 %r58, 0, !dbg !517
  %r60 = load i64, ptr %slot.n, align 8, !dbg !517
  %r61 = call i64 @nova_rt_lt(i64 %r59, i64 %r60), !dbg !517
  store i64 %r61, ptr %slot.__sc_303, align 8, !dbg !517
  %br_and_rhs3046 = icmp ne i64 %r61, 0, !dbg !517
  br i1 %br_and_rhs3046, label %and_rhs304, label %and_merge305, !dbg !517
and_rhs304:
  %r62 = load i64, ptr %slot.bs, align 8, !dbg !517
  %r63 = load i64, ptr %slot.q, align 8, !dbg !517
  %r64 = call i64 @nova_rt_bytes_get(i64 %r62, i64 %r63), !dbg !517
  %r65 = add i64 46, 0, !dbg !517
  %r66.cmp = icmp eq i64 %r64, %r65, !dbg !517
  %r66 = zext i1 %r66.cmp to i64, !dbg !517
  store i64 %r66, ptr %slot.__sc_303, align 8, !dbg !517
  br label %and_merge305, !dbg !517
and_merge305:
  %r67 = load i64, ptr %slot.__sc_303, align 8, !dbg !517
  %br_then3067 = icmp ne i64 %r67, 0, !dbg !517
  br i1 %br_then3067, label %then306, label %else307, !dbg !517
then306:
  %r68 = load i64, ptr %slot.q, align 8, !dbg !518
  %r69 = add i64 1, 0, !dbg !518
  %r70 = call i64 @nova_rt_add(i64 %r68, i64 %r69), !dbg !518
  %r71 = load i64, ptr %slot.st, align 8, !dbg !518
  %r72.p = getelementptr inbounds [4 x i8], ptr @.str.0, i64 0, i64 0, !dbg !518
  %r72 = ptrtoint ptr %r72.p to i64, !dbg !518
  %_is.dv8 = call i64 @nova_rt_dict_set(i64 %r71, i64 %r72, i64 %r70), !dbg !518
  br label %endif308, !dbg !518
else307:
  %r73 = add i64 0, 0, !dbg !519
  store i64 %r73, ptr %slot.go, align 8, !dbg !519
  br label %endif308, !dbg !519
endif308:
  br label %while_hdr291, !dbg !519
while_exit293:
  %r74 = load i64, ptr %slot.segs, align 8, !dbg !520
  ret i64 %r74, !dbg !520
}

; ESCAPE _tm_nav: allocs=4 escape=4 local=0
define i64 @_tm_nav(i64 %p0, i64 %p1) nounwind uwtable !dbg !521 {
entry:
  %slot.node = alloca i64, align 8, !dbg !522
  store i64 %p0, ptr %slot.node, align 8, !dbg !522
  %slot.key = alloca i64, align 8, !dbg !522
  store i64 %p1, ptr %slot.key, align 8, !dbg !522
  %slot.result = alloca i64, align 8, !dbg !522
  store i64 0, ptr %slot.result, align 8, !dbg !522
  %slot.v = alloca i64, align 8, !dbg !522
  store i64 0, ptr %slot.v, align 8, !dbg !522
  %slot.ln = alloca i64, align 8, !dbg !522
  store i64 0, ptr %slot.ln, align 8, !dbg !522
  %slot.d = alloca i64, align 8, !dbg !522
  store i64 0, ptr %slot.d, align 8, !dbg !522
  %r0 = call i64 @nova_rt_dict_create(), !dbg !523
  store i64 %r0, ptr %slot.result, align 8, !dbg !523
  %r1 = load i64, ptr %slot.node, align 8, !dbg !524
  %r2 = load i64, ptr %slot.key, align 8, !dbg !524
  %r3 = call i64 @nova_rt_contains(i64 %r1, i64 %r2), !dbg !524
  %br_then3090 = icmp ne i64 %r3, 0, !dbg !524
  br i1 %br_then3090, label %then309, label %else310, !dbg !524
then309:
  %r4 = load i64, ptr %slot.node, align 8, !dbg !525
  %r5 = load i64, ptr %slot.key, align 8, !dbg !525
  %r6 = call i64 @nova_rt_index_get(i64 %r4, i64 %r5), !dbg !525
  store i64 %r6, ptr %slot.v, align 8, !dbg !525
  %r7 = add i64 %r6, 0, !dbg !526
  %r8 = call i64 @nova_rt_type_of(i64 %r7), !dbg !526
  %r9.p = getelementptr inbounds [5 x i8], ptr @.str.7, i64 0, i64 0, !dbg !526
  %r9 = ptrtoint ptr %r9.p to i64, !dbg !526
  %r10.p0 = inttoptr i64 %r8 to ptr, !dbg !526
  %r10.p1 = inttoptr i64 %r9 to ptr, !dbg !526
  %r10.sc = call i32 @strcmp(ptr %r10.p0, ptr %r10.p1), !dbg !526
  %r10.cmp = icmp eq i32 %r10.sc, 0, !dbg !526
  %r10 = zext i1 %r10.cmp to i64, !dbg !526
  %br_then3121 = icmp ne i64 %r10, 0, !dbg !526
  br i1 %br_then3121, label %then312, label %else313, !dbg !526
then312:
  %r11 = load i64, ptr %slot.v, align 8, !dbg !527
  store i64 %r11, ptr %slot.result, align 8, !dbg !527
  br label %endif314, !dbg !527
else313:
  %r12 = load i64, ptr %slot.v, align 8, !dbg !528
  %r13 = call i64 @nova_rt_type_of(i64 %r12), !dbg !528
  %r14.p = getelementptr inbounds [5 x i8], ptr @.str.8, i64 0, i64 0, !dbg !528
  %r14 = ptrtoint ptr %r14.p to i64, !dbg !528
  %r15.p0 = inttoptr i64 %r13 to ptr, !dbg !528
  %r15.p1 = inttoptr i64 %r14 to ptr, !dbg !528
  %r15.sc = call i32 @strcmp(ptr %r15.p0, ptr %r15.p1), !dbg !528
  %r15.cmp = icmp eq i32 %r15.sc, 0, !dbg !528
  %r15 = zext i1 %r15.cmp to i64, !dbg !528
  %br_then3152 = icmp ne i64 %r15, 0, !dbg !528
  br i1 %br_then3152, label %then315, label %else316, !dbg !528
then315:
  %r16 = load i64, ptr %slot.v, align 8, !dbg !529
  %r17 = call i64 @nova_rt_len_any(i64 %r16), !dbg !529
  store i64 %r17, ptr %slot.ln, align 8, !dbg !529
  %r18 = add i64 %r17, 0, !dbg !530
  %r19 = add i64 0, 0, !dbg !530
  %r20.cmp = icmp sgt i64 %r18, %r19, !dbg !530
  %r20 = zext i1 %r20.cmp to i64, !dbg !530
  %br_then3183 = icmp ne i64 %r20, 0, !dbg !530
  br i1 %br_then3183, label %then318, label %else319, !dbg !530
then318:
  %r21 = load i64, ptr %slot.v, align 8, !dbg !531
  %r22 = load i64, ptr %slot.ln, align 8, !dbg !531
  %r23 = add i64 1, 0, !dbg !531
  %r24 = sub i64 %r22, %r23, !dbg !531
  %r25 = call i64 @nova_rt_index_get(i64 %r21, i64 %r24), !dbg !531
  store i64 %r25, ptr %slot.result, align 8, !dbg !531
  br label %endif320, !dbg !531
else319:
  %r26 = call i64 @nova_rt_dict_create(), !dbg !532
  store i64 %r26, ptr %slot.d, align 8, !dbg !532
  %r27 = load i64, ptr %slot.v, align 8, !dbg !533
  %r28 = add i64 %r26, 0, !dbg !533
  %r29 = call i64 @nova_rt_list_append(i64 %r27, i64 %r28), !dbg !533
  %r30 = add i64 %r26, 0, !dbg !534
  store i64 %r30, ptr %slot.result, align 8, !dbg !534
  br label %endif320, !dbg !534
endif320:
  br label %endif317, !dbg !534
else316:
  %r31 = call i64 @nova_rt_dict_create(), !dbg !535
  store i64 %r31, ptr %slot.d, align 8, !dbg !535
  %r32 = add i64 %r31, 0, !dbg !536
  %r33 = load i64, ptr %slot.node, align 8, !dbg !536
  %r34 = load i64, ptr %slot.key, align 8, !dbg !536
  %_is.gv4 = call i64 @nova_rt_index_set(i64 %r33, i64 %r34, i64 %r32), !dbg !536
  %r35 = add i64 %r31, 0, !dbg !537
  store i64 %r35, ptr %slot.result, align 8, !dbg !537
  br label %endif317, !dbg !537
endif317:
  br label %endif314, !dbg !537
endif314:
  br label %endif311, !dbg !537
else310:
  %r36 = call i64 @nova_rt_dict_create(), !dbg !538
  store i64 %r36, ptr %slot.d, align 8, !dbg !538
  %r37 = add i64 %r36, 0, !dbg !539
  %r38 = load i64, ptr %slot.node, align 8, !dbg !539
  %r39 = load i64, ptr %slot.key, align 8, !dbg !539
  %_is.gv5 = call i64 @nova_rt_index_set(i64 %r38, i64 %r39, i64 %r37), !dbg !539
  %r40 = add i64 %r36, 0, !dbg !540
  store i64 %r40, ptr %slot.result, align 8, !dbg !540
  br label %endif311, !dbg !540
endif311:
  %r41 = load i64, ptr %slot.result, align 8, !dbg !541
  ret i64 %r41, !dbg !541
}

; ESCAPE _tm_assign: allocs=0 escape=0 local=0
define i64 @_tm_assign(i64 %p0, i64 %p1, i64 %p2) nounwind uwtable !dbg !542 {
entry:
  %slot.root = alloca i64, align 8, !dbg !543
  store i64 %p0, ptr %slot.root, align 8, !dbg !543
  %slot.segs = alloca i64, align 8, !dbg !543
  store i64 %p1, ptr %slot.segs, align 8, !dbg !543
  %slot.value = alloca i64, align 8, !dbg !543
  store i64 %p2, ptr %slot.value, align 8, !dbg !543
  %slot.parent = alloca i64, align 8, !dbg !543
  store i64 0, ptr %slot.parent, align 8, !dbg !543
  %slot.n = alloca i64, align 8, !dbg !543
  store i64 0, ptr %slot.n, align 8, !dbg !543
  %slot.i = alloca i64, align 8, !dbg !543
  store i64 0, ptr %slot.i, align 8, !dbg !543
  %slot.segs__s4f636 = alloca i64, align 8, !dbg !543
  store i64 0, ptr %slot.segs__s4f636, align 8, !dbg !543
  %r0 = load i64, ptr %slot.root, align 8, !dbg !544
  store i64 %r0, ptr %slot.parent, align 8, !dbg !544
  %r1 = load i64, ptr %slot.segs, align 8, !dbg !545
  %r2.lp = inttoptr i64 %r1 to ptr, !dbg !545
  %r2.szp = getelementptr i64, ptr %r2.lp, i64 1, !dbg !545
  %r2 = load i64, ptr %r2.szp, align 8, !tbaa !6, !dbg !545
  store i64 %r2, ptr %slot.n, align 8, !dbg !545
  %r3 = add i64 0, 0, !dbg !546
  store i64 %r3, ptr %slot.i, align 8, !dbg !546
  %r4 = load i64, ptr %slot.segs, align 8, !dbg !547
  %r5 = call i64 @nova_rt_list_is_kind2(i64 %r4), !dbg !547
  %br_then3210 = icmp ne i64 %r5, 0, !dbg !547
  br i1 %br_then3210, label %then321, label %else322, !dbg !547
then321:
  %r6 = load i64, ptr %slot.segs, align 8, !dbg !547
  %r7 = call i64 @nova_rt_floatlist_view(i64 %r6), !dbg !547
  store i64 %r7, ptr %slot.segs__s4f636, align 8, !dbg !547
  br label %while_hdr324, !dbg !547
while_hdr324:
  %r8 = load i64, ptr %slot.i, align 8, !dbg !547
  %r9 = load i64, ptr %slot.n, align 8, !dbg !547
  %r10 = add i64 1, 0, !dbg !547
  %r11 = sub i64 %r9, %r10, !dbg !547
  %r12.cmp = icmp slt i64 %r8, %r11, !dbg !547
  %r12 = zext i1 %r12.cmp to i64, !dbg !547
  %br_while_body3251 = icmp ne i64 %r12, 0, !dbg !547
  br i1 %br_while_body3251, label %while_body325, label %while_exit326, !prof !90, !dbg !547
while_body325:
  %r13 = load i64, ptr %slot.parent, align 8, !dbg !548
  %r14 = load i64, ptr %slot.segs__s4f636, align 8, !dbg !548
  %r15 = load i64, ptr %slot.i, align 8, !dbg !548
  %r16 = call i64 @nova_rt_list_get_f(i64 %r14, i64 %r15), !dbg !548
  %wbox0 = call i64 @nova_rt_box_float(i64 %r16), !dbg !548
  %r17 = call i64 @_tm_nav(i64 %r13, i64 %wbox0), !dbg !548
  store i64 %r17, ptr %slot.parent, align 8, !dbg !548
  %r18 = load i64, ptr %slot.i, align 8, !dbg !549
  %r19 = add i64 1, 0, !dbg !549
  %r20 = add i64 %r18, %r19, !dbg !549
  store i64 %r20, ptr %slot.i, align 8, !dbg !549
  br label %while_hdr324, !dbg !549
while_exit326:
  br label %endif323, !dbg !549
else322:
  br label %while_hdr327, !dbg !547
while_hdr327:
  %r21 = load i64, ptr %slot.i, align 8, !dbg !547
  %r22 = load i64, ptr %slot.n, align 8, !dbg !547
  %r23 = add i64 1, 0, !dbg !547
  %r24 = sub i64 %r22, %r23, !dbg !547
  %r25.cmp = icmp slt i64 %r21, %r24, !dbg !547
  %r25 = zext i1 %r25.cmp to i64, !dbg !547
  %br_while_body3282 = icmp ne i64 %r25, 0, !dbg !547
  br i1 %br_while_body3282, label %while_body328, label %while_exit329, !prof !90, !dbg !547
while_body328:
  %r26 = load i64, ptr %slot.parent, align 8, !dbg !548
  %r27 = load i64, ptr %slot.segs, align 8, !dbg !548
  %r28 = load i64, ptr %slot.i, align 8, !dbg !548
  %r29 = call i64 @nova_rt_list_get(i64 %r27, i64 %r28), !dbg !548
  %r30 = call i64 @_tm_nav(i64 %r26, i64 %r29), !dbg !548
  store i64 %r30, ptr %slot.parent, align 8, !dbg !548
  %r31 = load i64, ptr %slot.i, align 8, !dbg !549
  %r32 = add i64 1, 0, !dbg !549
  %r33 = add i64 %r31, %r32, !dbg !549
  store i64 %r33, ptr %slot.i, align 8, !dbg !549
  br label %while_hdr327, !dbg !549
while_exit329:
  br label %endif323, !dbg !549
endif323:
  %r34 = load i64, ptr %slot.value, align 8, !dbg !550
  %r35 = load i64, ptr %slot.parent, align 8, !dbg !550
  %r36 = load i64, ptr %slot.segs, align 8, !dbg !550
  %r37 = load i64, ptr %slot.n, align 8, !dbg !550
  %r38 = add i64 1, 0, !dbg !550
  %r39 = sub i64 %r37, %r38, !dbg !550
  %r40 = call i64 @nova_rt_list_get(i64 %r36, i64 %r39), !dbg !550
  %_is.gv3 = call i64 @nova_rt_index_set(i64 %r35, i64 %r40, i64 %r34), !dbg !550
  ret i64 0, !dbg !550
}

; ESCAPE _tm_open_table: allocs=3 escape=3 local=0
define i64 @_tm_open_table(i64 %p0, i64 %p1, i64 %p2) nounwind uwtable !dbg !551 {
entry:
  %slot.root = alloca i64, align 8, !dbg !552
  store i64 %p0, ptr %slot.root, align 8, !dbg !552
  %slot.segs = alloca i64, align 8, !dbg !552
  store i64 %p1, ptr %slot.segs, align 8, !dbg !552
  %slot.is_array = alloca i64, align 8, !dbg !552
  store i64 %p2, ptr %slot.is_array, align 8, !dbg !552
  %slot.parent = alloca i64, align 8, !dbg !552
  store i64 0, ptr %slot.parent, align 8, !dbg !552
  %slot.n = alloca i64, align 8, !dbg !552
  store i64 0, ptr %slot.n, align 8, !dbg !552
  %slot.i = alloca i64, align 8, !dbg !552
  store i64 0, ptr %slot.i, align 8, !dbg !552
  %slot.segs__s4f648 = alloca i64, align 8, !dbg !552
  store i64 0, ptr %slot.segs__s4f648, align 8, !dbg !552
  %slot.last = alloca i64, align 8, !dbg !552
  store i64 0, ptr %slot.last, align 8, !dbg !552
  %slot.current = alloca i64, align 8, !dbg !552
  store i64 0, ptr %slot.current, align 8, !dbg !552
  %slot.arr = alloca i64, align 8, !dbg !552
  store i64 0, ptr %slot.arr, align 8, !dbg !552
  %slot.__sc_342 = alloca i64, align 8, !dbg !552
  store i64 0, ptr %slot.__sc_342, align 8, !dbg !552
  %slot.newd = alloca i64, align 8, !dbg !552
  store i64 0, ptr %slot.newd, align 8, !dbg !552
  %r0 = load i64, ptr %slot.root, align 8, !dbg !553
  store i64 %r0, ptr %slot.parent, align 8, !dbg !553
  %r1 = load i64, ptr %slot.segs, align 8, !dbg !554
  %r2.lp = inttoptr i64 %r1 to ptr, !dbg !554
  %r2.szp = getelementptr i64, ptr %r2.lp, i64 1, !dbg !554
  %r2 = load i64, ptr %r2.szp, align 8, !tbaa !6, !dbg !554
  store i64 %r2, ptr %slot.n, align 8, !dbg !554
  %r3 = add i64 0, 0, !dbg !555
  store i64 %r3, ptr %slot.i, align 8, !dbg !555
  %r4 = load i64, ptr %slot.segs, align 8, !dbg !556
  %r5 = call i64 @nova_rt_list_is_kind2(i64 %r4), !dbg !556
  %br_then3300 = icmp ne i64 %r5, 0, !dbg !556
  br i1 %br_then3300, label %then330, label %else331, !dbg !556
then330:
  %r6 = load i64, ptr %slot.segs, align 8, !dbg !556
  %r7 = call i64 @nova_rt_floatlist_view(i64 %r6), !dbg !556
  store i64 %r7, ptr %slot.segs__s4f648, align 8, !dbg !556
  br label %while_hdr333, !dbg !556
while_hdr333:
  %r8 = load i64, ptr %slot.i, align 8, !dbg !556
  %r9 = load i64, ptr %slot.n, align 8, !dbg !556
  %r10 = add i64 1, 0, !dbg !556
  %r11 = sub i64 %r9, %r10, !dbg !556
  %r12.cmp = icmp slt i64 %r8, %r11, !dbg !556
  %r12 = zext i1 %r12.cmp to i64, !dbg !556
  %br_while_body3341 = icmp ne i64 %r12, 0, !dbg !556
  br i1 %br_while_body3341, label %while_body334, label %while_exit335, !prof !90, !dbg !556
while_body334:
  %r13 = load i64, ptr %slot.parent, align 8, !dbg !557
  %r14 = load i64, ptr %slot.segs__s4f648, align 8, !dbg !557
  %r15 = load i64, ptr %slot.i, align 8, !dbg !557
  %r16 = call i64 @nova_rt_list_get_f(i64 %r14, i64 %r15), !dbg !557
  %wbox0 = call i64 @nova_rt_box_float(i64 %r16), !dbg !557
  %r17 = call i64 @_tm_nav(i64 %r13, i64 %wbox0), !dbg !557
  store i64 %r17, ptr %slot.parent, align 8, !dbg !557
  %r18 = load i64, ptr %slot.i, align 8, !dbg !558
  %r19 = add i64 1, 0, !dbg !558
  %r20 = add i64 %r18, %r19, !dbg !558
  store i64 %r20, ptr %slot.i, align 8, !dbg !558
  br label %while_hdr333, !dbg !558
while_exit335:
  br label %endif332, !dbg !558
else331:
  br label %while_hdr336, !dbg !556
while_hdr336:
  %r21 = load i64, ptr %slot.i, align 8, !dbg !556
  %r22 = load i64, ptr %slot.n, align 8, !dbg !556
  %r23 = add i64 1, 0, !dbg !556
  %r24 = sub i64 %r22, %r23, !dbg !556
  %r25.cmp = icmp slt i64 %r21, %r24, !dbg !556
  %r25 = zext i1 %r25.cmp to i64, !dbg !556
  %br_while_body3372 = icmp ne i64 %r25, 0, !dbg !556
  br i1 %br_while_body3372, label %while_body337, label %while_exit338, !prof !90, !dbg !556
while_body337:
  %r26 = load i64, ptr %slot.parent, align 8, !dbg !557
  %r27 = load i64, ptr %slot.segs, align 8, !dbg !557
  %r28 = load i64, ptr %slot.i, align 8, !dbg !557
  %r29 = call i64 @nova_rt_list_get(i64 %r27, i64 %r28), !dbg !557
  %r30 = call i64 @_tm_nav(i64 %r26, i64 %r29), !dbg !557
  store i64 %r30, ptr %slot.parent, align 8, !dbg !557
  %r31 = load i64, ptr %slot.i, align 8, !dbg !558
  %r32 = add i64 1, 0, !dbg !558
  %r33 = add i64 %r31, %r32, !dbg !558
  store i64 %r33, ptr %slot.i, align 8, !dbg !558
  br label %while_hdr336, !dbg !558
while_exit338:
  br label %endif332, !dbg !558
endif332:
  %r34 = load i64, ptr %slot.segs, align 8, !dbg !559
  %r35 = load i64, ptr %slot.n, align 8, !dbg !559
  %r36 = add i64 1, 0, !dbg !559
  %r37 = sub i64 %r35, %r36, !dbg !559
  %r38 = call i64 @nova_rt_list_get(i64 %r34, i64 %r37), !dbg !559
  store i64 %r38, ptr %slot.last, align 8, !dbg !559
  %r39 = call i64 @nova_rt_dict_create(), !dbg !560
  store i64 %r39, ptr %slot.current, align 8, !dbg !560
  %r40 = load i64, ptr %slot.is_array, align 8, !dbg !561
  %r41 = add i64 1, 0, !dbg !561
  %r42.cmp = icmp eq i64 %r40, %r41, !dbg !561
  %r42 = zext i1 %r42.cmp to i64, !dbg !561
  %br_then3393 = icmp ne i64 %r42, 0, !dbg !561
  br i1 %br_then3393, label %then339, label %else340, !dbg !561
then339:
  %r43 = call i64 @nova_rt_list_create(), !dbg !562
  store i64 %r43, ptr %slot.arr, align 8, !dbg !562
  %r44 = load i64, ptr %slot.parent, align 8, !dbg !563
  %r45 = load i64, ptr %slot.last, align 8, !dbg !563
  %r46 = call i64 @nova_rt_contains(i64 %r44, i64 %r45), !dbg !563
  store i64 %r46, ptr %slot.__sc_342, align 8, !dbg !563
  %br_and_rhs3434 = icmp ne i64 %r46, 0, !dbg !563
  br i1 %br_and_rhs3434, label %and_rhs343, label %and_merge344, !dbg !563
and_rhs343:
  %r47 = load i64, ptr %slot.parent, align 8, !dbg !563
  %r48 = load i64, ptr %slot.last, align 8, !dbg !563
  %r49 = call i64 @nova_rt_index_get(i64 %r47, i64 %r48), !dbg !563
  %r50 = call i64 @nova_rt_type_of(i64 %r49), !dbg !563
  %r51.p = getelementptr inbounds [5 x i8], ptr @.str.8, i64 0, i64 0, !dbg !563
  %r51 = ptrtoint ptr %r51.p to i64, !dbg !563
  %r52.p0 = inttoptr i64 %r50 to ptr, !dbg !563
  %r52.p1 = inttoptr i64 %r51 to ptr, !dbg !563
  %r52.sc = call i32 @strcmp(ptr %r52.p0, ptr %r52.p1), !dbg !563
  %r52.cmp = icmp eq i32 %r52.sc, 0, !dbg !563
  %r52 = zext i1 %r52.cmp to i64, !dbg !563
  store i64 %r52, ptr %slot.__sc_342, align 8, !dbg !563
  br label %and_merge344, !dbg !563
and_merge344:
  %r53 = load i64, ptr %slot.__sc_342, align 8, !dbg !563
  %wbox1 = call i64 @nova_rt_truthy(i64 %r53), !dbg !563
  %br_then3455 = icmp ne i64 %wbox1, 0, !dbg !563
  br i1 %br_then3455, label %then345, label %else346, !dbg !563
then345:
  %r54 = load i64, ptr %slot.parent, align 8, !dbg !564
  %r55 = load i64, ptr %slot.last, align 8, !dbg !564
  %r56 = call i64 @nova_rt_index_get(i64 %r54, i64 %r55), !dbg !564
  store i64 %r56, ptr %slot.arr, align 8, !dbg !564
  br label %endif347, !dbg !564
else346:
  %r57 = load i64, ptr %slot.arr, align 8, !dbg !565
  %r58 = load i64, ptr %slot.parent, align 8, !dbg !565
  %r59 = load i64, ptr %slot.last, align 8, !dbg !565
  %_is.gv6 = call i64 @nova_rt_index_set(i64 %r58, i64 %r59, i64 %r57), !dbg !565
  br label %endif347, !dbg !565
endif347:
  %r60 = call i64 @nova_rt_dict_create(), !dbg !566
  store i64 %r60, ptr %slot.newd, align 8, !dbg !566
  %r61 = load i64, ptr %slot.arr, align 8, !dbg !567
  %r62 = add i64 %r60, 0, !dbg !567
  %r63 = call i64 @nova_rt_list_append(i64 %r61, i64 %r62), !dbg !567
  %r64 = add i64 %r60, 0, !dbg !568
  store i64 %r64, ptr %slot.current, align 8, !dbg !568
  br label %endif341, !dbg !568
else340:
  %r65 = load i64, ptr %slot.parent, align 8, !dbg !569
  %r66 = load i64, ptr %slot.last, align 8, !dbg !569
  %r67 = call i64 @_tm_nav(i64 %r65, i64 %r66), !dbg !569
  store i64 %r67, ptr %slot.current, align 8, !dbg !569
  br label %endif341, !dbg !569
endif341:
  %r68 = load i64, ptr %slot.current, align 8, !dbg !570
  ret i64 %r68, !dbg !570
}

; ESCAPE toml_parse: allocs=2 escape=1 local=1
define i64 @toml_parse(i64 %p0) nounwind uwtable !dbg !571 {
entry:
  %slot.text = alloca i64, align 8, !dbg !572
  store i64 %p0, ptr %slot.text, align 8, !dbg !572
  %slot.result = alloca i64, align 8, !dbg !572
  store i64 0, ptr %slot.result, align 8, !dbg !572
  %slot.current = alloca i64, align 8, !dbg !572
  store i64 0, ptr %slot.current, align 8, !dbg !572
  %slot.bs = alloca i64, align 8, !dbg !572
  store i64 0, ptr %slot.bs, align 8, !dbg !572
  %slot.n = alloca i64, align 8, !dbg !572
  store i64 0, ptr %slot.n, align 8, !dbg !572
  %slot.st = alloca i64, align 8, !dbg !572
  store i64 0, ptr %slot.st, align 8, !dbg !572
  %slot.go = alloca i64, align 8, !dbg !572
  store i64 0, ptr %slot.go, align 8, !dbg !572
  %slot.p = alloca i64, align 8, !dbg !572
  store i64 0, ptr %slot.p, align 8, !dbg !572
  %slot.o = alloca i64, align 8, !dbg !572
  store i64 0, ptr %slot.o, align 8, !dbg !572
  %slot.is_array = alloca i64, align 8, !dbg !572
  store i64 0, ptr %slot.is_array, align 8, !dbg !572
  %slot.__sc_357 = alloca i64, align 8, !dbg !572
  store i64 0, ptr %slot.__sc_357, align 8, !dbg !572
  %slot.segs = alloca i64, align 8, !dbg !572
  store i64 0, ptr %slot.segs, align 8, !dbg !572
  %slot.__sc_363 = alloca i64, align 8, !dbg !572
  store i64 0, ptr %slot.__sc_363, align 8, !dbg !572
  %slot.__sc_372 = alloca i64, align 8, !dbg !572
  store i64 0, ptr %slot.__sc_372, align 8, !dbg !572
  %slot.segs2 = alloca i64, align 8, !dbg !572
  store i64 0, ptr %slot.segs2, align 8, !dbg !572
  %slot.__sc_378 = alloca i64, align 8, !dbg !572
  store i64 0, ptr %slot.__sc_378, align 8, !dbg !572
  %slot.val = alloca i64, align 8, !dbg !572
  store i64 0, ptr %slot.val, align 8, !dbg !572
  %r0 = call i64 @nova_rt_dict_create(), !dbg !573
  store i64 %r0, ptr %slot.result, align 8, !dbg !573
  %r1 = add i64 %r0, 0, !dbg !574
  store i64 %r1, ptr %slot.current, align 8, !dbg !574
  %r2 = load i64, ptr %slot.text, align 8, !dbg !575
  %r3 = call i64 @nova_rt_str_to_bytes(i64 %r2), !dbg !575
  store i64 %r3, ptr %slot.bs, align 8, !dbg !575
  %r4 = add i64 %r3, 0, !dbg !576
  %r5 = call i64 @nova_rt_bytes_len(i64 %r4), !dbg !576
  store i64 %r5, ptr %slot.n, align 8, !dbg !576
  %r6 = call i64 @nova_rt_dict_create(), !dbg !577
  store i64 %r6, ptr %slot.st, align 8, !dbg !577
  %r7 = add i64 0, 0, !dbg !578
  %r8 = add i64 %r6, 0, !dbg !578
  %r9.p = getelementptr inbounds [4 x i8], ptr @.str.0, i64 0, i64 0, !dbg !578
  %r9 = ptrtoint ptr %r9.p to i64, !dbg !578
  %_is.dv0 = call i64 @nova_rt_dict_set(i64 %r8, i64 %r9, i64 %r7), !dbg !578
  %r10 = add i64 1, 0, !dbg !579
  store i64 %r10, ptr %slot.go, align 8, !dbg !579
  br label %while_hdr348, !dbg !580
while_hdr348:
  %r11 = load i64, ptr %slot.go, align 8, !dbg !580
  %r12 = add i64 1, 0, !dbg !580
  %r13.cmp = icmp eq i64 %r11, %r12, !dbg !580
  %r13 = zext i1 %r13.cmp to i64, !dbg !580
  %br_while_body3491 = icmp ne i64 %r13, 0, !dbg !580
  br i1 %br_while_body3491, label %while_body349, label %while_exit350, !prof !90, !dbg !580
while_body349:
  %r14 = load i64, ptr %slot.bs, align 8, !dbg !581
  %r15 = load i64, ptr %slot.n, align 8, !dbg !581
  %r16 = load i64, ptr %slot.st, align 8, !dbg !581
  %r17 = call i64 @_tm_skip_ws_nl_comments(i64 %r14, i64 %r15, i64 %r16), !dbg !581
  %r18 = load i64, ptr %slot.st, align 8, !dbg !582
  %r19.p = getelementptr inbounds [4 x i8], ptr @.str.0, i64 0, i64 0, !dbg !582
  %r19 = ptrtoint ptr %r19.p to i64, !dbg !582
  %r20 = call i64 @nova_rt_dict_get(i64 %r18, i64 %r19), !dbg !582
  store i64 %r20, ptr %slot.p, align 8, !dbg !582
  %r21 = add i64 %r20, 0, !dbg !583
  %r22 = load i64, ptr %slot.n, align 8, !dbg !583
  %r23 = call i64 @nova_rt_ge(i64 %r21, i64 %r22), !dbg !583
  %br_then3512 = icmp ne i64 %r23, 0, !dbg !583
  br i1 %br_then3512, label %then351, label %else352, !dbg !583
then351:
  %r24 = add i64 0, 0, !dbg !584
  store i64 %r24, ptr %slot.go, align 8, !dbg !584
  br label %endif353, !dbg !584
else352:
  %r25 = load i64, ptr %slot.bs, align 8, !dbg !585
  %r26 = load i64, ptr %slot.p, align 8, !dbg !585
  %r27 = call i64 @nova_rt_bytes_get(i64 %r25, i64 %r26), !dbg !585
  store i64 %r27, ptr %slot.o, align 8, !dbg !585
  %r28 = add i64 %r27, 0, !dbg !586
  %r29 = add i64 91, 0, !dbg !586
  %r30.cmp = icmp eq i64 %r28, %r29, !dbg !586
  %r30 = zext i1 %r30.cmp to i64, !dbg !586
  %br_then3543 = icmp ne i64 %r30, 0, !dbg !586
  br i1 %br_then3543, label %then354, label %else355, !dbg !586
then354:
  %r31 = load i64, ptr %slot.p, align 8, !dbg !587
  %r32 = add i64 1, 0, !dbg !587
  %r33 = call i64 @nova_rt_add(i64 %r31, i64 %r32), !dbg !587
  %r34 = load i64, ptr %slot.st, align 8, !dbg !587
  %r35.p = getelementptr inbounds [4 x i8], ptr @.str.0, i64 0, i64 0, !dbg !587
  %r35 = ptrtoint ptr %r35.p to i64, !dbg !587
  %_is.dv4 = call i64 @nova_rt_dict_set_no_rc(i64 %r34, i64 %r35, i64 %r33), !dbg !587
  %r36 = add i64 0, 0, !dbg !588
  store i64 %r36, ptr %slot.is_array, align 8, !dbg !588
  %r37 = load i64, ptr %slot.st, align 8, !dbg !589
  %r38.p = getelementptr inbounds [4 x i8], ptr @.str.0, i64 0, i64 0, !dbg !589
  %r38 = ptrtoint ptr %r38.p to i64, !dbg !589
  %r39 = call i64 @nova_rt_dict_get(i64 %r37, i64 %r38), !dbg !589
  %r40 = load i64, ptr %slot.n, align 8, !dbg !589
  %r41 = call i64 @nova_rt_lt(i64 %r39, i64 %r40), !dbg !589
  store i64 %r41, ptr %slot.__sc_357, align 8, !dbg !589
  %br_and_rhs3585 = icmp ne i64 %r41, 0, !dbg !589
  br i1 %br_and_rhs3585, label %and_rhs358, label %and_merge359, !dbg !589
and_rhs358:
  %r42 = load i64, ptr %slot.bs, align 8, !dbg !589
  %r43 = load i64, ptr %slot.st, align 8, !dbg !589
  %r44.p = getelementptr inbounds [4 x i8], ptr @.str.0, i64 0, i64 0, !dbg !589
  %r44 = ptrtoint ptr %r44.p to i64, !dbg !589
  %r45 = call i64 @nova_rt_dict_get(i64 %r43, i64 %r44), !dbg !589
  %r46 = call i64 @nova_rt_bytes_get(i64 %r42, i64 %r45), !dbg !589
  %r47 = add i64 91, 0, !dbg !589
  %r48.cmp = icmp eq i64 %r46, %r47, !dbg !589
  %r48 = zext i1 %r48.cmp to i64, !dbg !589
  store i64 %r48, ptr %slot.__sc_357, align 8, !dbg !589
  br label %and_merge359, !dbg !589
and_merge359:
  %r49 = load i64, ptr %slot.__sc_357, align 8, !dbg !589
  %br_then3606 = icmp ne i64 %r49, 0, !dbg !589
  br i1 %br_then3606, label %then360, label %else361, !dbg !589
then360:
  %r50 = add i64 1, 0, !dbg !590
  store i64 %r50, ptr %slot.is_array, align 8, !dbg !590
  %r51 = load i64, ptr %slot.st, align 8, !dbg !591
  %r52.p = getelementptr inbounds [4 x i8], ptr @.str.0, i64 0, i64 0, !dbg !591
  %r52 = ptrtoint ptr %r52.p to i64, !dbg !591
  %r53 = call i64 @nova_rt_dict_get(i64 %r51, i64 %r52), !dbg !591
  %r54 = add i64 1, 0, !dbg !591
  %r55 = call i64 @nova_rt_add(i64 %r53, i64 %r54), !dbg !591
  %r56 = load i64, ptr %slot.st, align 8, !dbg !591
  %r57.p = getelementptr inbounds [4 x i8], ptr @.str.0, i64 0, i64 0, !dbg !591
  %r57 = ptrtoint ptr %r57.p to i64, !dbg !591
  %_is.dv7 = call i64 @nova_rt_dict_set_no_rc(i64 %r56, i64 %r57, i64 %r55), !dbg !591
  br label %endif362, !dbg !591
else361:
  br label %endif362, !dbg !591
endif362:
  %r58 = load i64, ptr %slot.text, align 8, !dbg !592
  %r59 = load i64, ptr %slot.bs, align 8, !dbg !592
  %r60 = load i64, ptr %slot.n, align 8, !dbg !592
  %r61 = load i64, ptr %slot.st, align 8, !dbg !592
  %r62 = call i64 @_tm_read_key_path(i64 %r58, i64 %r59, i64 %r60, i64 %r61), !dbg !592
  store i64 %r62, ptr %slot.segs, align 8, !dbg !592
  %r63 = load i64, ptr %slot.bs, align 8, !dbg !593
  %r64 = load i64, ptr %slot.n, align 8, !dbg !593
  %r65 = load i64, ptr %slot.st, align 8, !dbg !593
  %r66 = call i64 @_tm_skip_h(i64 %r63, i64 %r64, i64 %r65), !dbg !593
  %r67 = load i64, ptr %slot.st, align 8, !dbg !594
  %r68.p = getelementptr inbounds [4 x i8], ptr @.str.0, i64 0, i64 0, !dbg !594
  %r68 = ptrtoint ptr %r68.p to i64, !dbg !594
  %r69 = call i64 @nova_rt_dict_get(i64 %r67, i64 %r68), !dbg !594
  %r70 = load i64, ptr %slot.n, align 8, !dbg !594
  %r71 = call i64 @nova_rt_lt(i64 %r69, i64 %r70), !dbg !594
  store i64 %r71, ptr %slot.__sc_363, align 8, !dbg !594
  %br_and_rhs3648 = icmp ne i64 %r71, 0, !dbg !594
  br i1 %br_and_rhs3648, label %and_rhs364, label %and_merge365, !dbg !594
and_rhs364:
  %r72 = load i64, ptr %slot.bs, align 8, !dbg !594
  %r73 = load i64, ptr %slot.st, align 8, !dbg !594
  %r74.p = getelementptr inbounds [4 x i8], ptr @.str.0, i64 0, i64 0, !dbg !594
  %r74 = ptrtoint ptr %r74.p to i64, !dbg !594
  %r75 = call i64 @nova_rt_dict_get(i64 %r73, i64 %r74), !dbg !594
  %r76 = call i64 @nova_rt_bytes_get(i64 %r72, i64 %r75), !dbg !594
  %r77 = add i64 93, 0, !dbg !594
  %r78.cmp = icmp eq i64 %r76, %r77, !dbg !594
  %r78 = zext i1 %r78.cmp to i64, !dbg !594
  store i64 %r78, ptr %slot.__sc_363, align 8, !dbg !594
  br label %and_merge365, !dbg !594
and_merge365:
  %r79 = load i64, ptr %slot.__sc_363, align 8, !dbg !594
  %br_then3669 = icmp ne i64 %r79, 0, !dbg !594
  br i1 %br_then3669, label %then366, label %else367, !dbg !594
then366:
  %r80 = load i64, ptr %slot.st, align 8, !dbg !595
  %r81.p = getelementptr inbounds [4 x i8], ptr @.str.0, i64 0, i64 0, !dbg !595
  %r81 = ptrtoint ptr %r81.p to i64, !dbg !595
  %r82 = call i64 @nova_rt_dict_get(i64 %r80, i64 %r81), !dbg !595
  %r83 = add i64 1, 0, !dbg !595
  %r84 = call i64 @nova_rt_add(i64 %r82, i64 %r83), !dbg !595
  %r85 = load i64, ptr %slot.st, align 8, !dbg !595
  %r86.p = getelementptr inbounds [4 x i8], ptr @.str.0, i64 0, i64 0, !dbg !595
  %r86 = ptrtoint ptr %r86.p to i64, !dbg !595
  %_is.dv10 = call i64 @nova_rt_dict_set_no_rc(i64 %r85, i64 %r86, i64 %r84), !dbg !595
  br label %endif368, !dbg !595
else367:
  br label %endif368, !dbg !595
endif368:
  %r87 = load i64, ptr %slot.is_array, align 8, !dbg !596
  %r88 = add i64 1, 0, !dbg !596
  %r89.cmp = icmp eq i64 %r87, %r88, !dbg !596
  %r89 = zext i1 %r89.cmp to i64, !dbg !596
  %br_then36911 = icmp ne i64 %r89, 0, !dbg !596
  br i1 %br_then36911, label %then369, label %else370, !dbg !596
then369:
  %r90 = load i64, ptr %slot.st, align 8, !dbg !597
  %r91.p = getelementptr inbounds [4 x i8], ptr @.str.0, i64 0, i64 0, !dbg !597
  %r91 = ptrtoint ptr %r91.p to i64, !dbg !597
  %r92 = call i64 @nova_rt_dict_get(i64 %r90, i64 %r91), !dbg !597
  %r93 = load i64, ptr %slot.n, align 8, !dbg !597
  %r94 = call i64 @nova_rt_lt(i64 %r92, i64 %r93), !dbg !597
  store i64 %r94, ptr %slot.__sc_372, align 8, !dbg !597
  %br_and_rhs37312 = icmp ne i64 %r94, 0, !dbg !597
  br i1 %br_and_rhs37312, label %and_rhs373, label %and_merge374, !dbg !597
and_rhs373:
  %r95 = load i64, ptr %slot.bs, align 8, !dbg !597
  %r96 = load i64, ptr %slot.st, align 8, !dbg !597
  %r97.p = getelementptr inbounds [4 x i8], ptr @.str.0, i64 0, i64 0, !dbg !597
  %r97 = ptrtoint ptr %r97.p to i64, !dbg !597
  %r98 = call i64 @nova_rt_dict_get(i64 %r96, i64 %r97), !dbg !597
  %r99 = call i64 @nova_rt_bytes_get(i64 %r95, i64 %r98), !dbg !597
  %r100 = add i64 93, 0, !dbg !597
  %r101.cmp = icmp eq i64 %r99, %r100, !dbg !597
  %r101 = zext i1 %r101.cmp to i64, !dbg !597
  store i64 %r101, ptr %slot.__sc_372, align 8, !dbg !597
  br label %and_merge374, !dbg !597
and_merge374:
  %r102 = load i64, ptr %slot.__sc_372, align 8, !dbg !597
  %br_then37513 = icmp ne i64 %r102, 0, !dbg !597
  br i1 %br_then37513, label %then375, label %else376, !dbg !597
then375:
  %r103 = load i64, ptr %slot.st, align 8, !dbg !598
  %r104.p = getelementptr inbounds [4 x i8], ptr @.str.0, i64 0, i64 0, !dbg !598
  %r104 = ptrtoint ptr %r104.p to i64, !dbg !598
  %r105 = call i64 @nova_rt_dict_get(i64 %r103, i64 %r104), !dbg !598
  %r106 = add i64 1, 0, !dbg !598
  %r107 = call i64 @nova_rt_add(i64 %r105, i64 %r106), !dbg !598
  %r108 = load i64, ptr %slot.st, align 8, !dbg !598
  %r109.p = getelementptr inbounds [4 x i8], ptr @.str.0, i64 0, i64 0, !dbg !598
  %r109 = ptrtoint ptr %r109.p to i64, !dbg !598
  %_is.dv14 = call i64 @nova_rt_dict_set_no_rc(i64 %r108, i64 %r109, i64 %r107), !dbg !598
  br label %endif377, !dbg !598
else376:
  br label %endif377, !dbg !598
endif377:
  br label %endif371, !dbg !598
else370:
  br label %endif371, !dbg !598
endif371:
  %r110 = load i64, ptr %slot.result, align 8, !dbg !599
  %r111 = load i64, ptr %slot.segs, align 8, !dbg !599
  %r112 = load i64, ptr %slot.is_array, align 8, !dbg !599
  %r113 = call i64 @_tm_open_table(i64 %r110, i64 %r111, i64 %r112), !dbg !599
  store i64 %r113, ptr %slot.current, align 8, !dbg !599
  br label %endif356, !dbg !599
else355:
  %r114 = load i64, ptr %slot.text, align 8, !dbg !600
  %r115 = load i64, ptr %slot.bs, align 8, !dbg !600
  %r116 = load i64, ptr %slot.n, align 8, !dbg !600
  %r117 = load i64, ptr %slot.st, align 8, !dbg !600
  %r118 = call i64 @_tm_read_key_path(i64 %r114, i64 %r115, i64 %r116, i64 %r117), !dbg !600
  store i64 %r118, ptr %slot.segs2, align 8, !dbg !600
  %r119 = load i64, ptr %slot.bs, align 8, !dbg !601
  %r120 = load i64, ptr %slot.n, align 8, !dbg !601
  %r121 = load i64, ptr %slot.st, align 8, !dbg !601
  %r122 = call i64 @_tm_skip_h(i64 %r119, i64 %r120, i64 %r121), !dbg !601
  %r123 = load i64, ptr %slot.st, align 8, !dbg !602
  %r124.p = getelementptr inbounds [4 x i8], ptr @.str.0, i64 0, i64 0, !dbg !602
  %r124 = ptrtoint ptr %r124.p to i64, !dbg !602
  %r125 = call i64 @nova_rt_dict_get(i64 %r123, i64 %r124), !dbg !602
  %r126 = load i64, ptr %slot.n, align 8, !dbg !602
  %r127 = call i64 @nova_rt_lt(i64 %r125, i64 %r126), !dbg !602
  store i64 %r127, ptr %slot.__sc_378, align 8, !dbg !602
  %br_and_rhs37915 = icmp ne i64 %r127, 0, !dbg !602
  br i1 %br_and_rhs37915, label %and_rhs379, label %and_merge380, !dbg !602
and_rhs379:
  %r128 = load i64, ptr %slot.bs, align 8, !dbg !602
  %r129 = load i64, ptr %slot.st, align 8, !dbg !602
  %r130.p = getelementptr inbounds [4 x i8], ptr @.str.0, i64 0, i64 0, !dbg !602
  %r130 = ptrtoint ptr %r130.p to i64, !dbg !602
  %r131 = call i64 @nova_rt_dict_get(i64 %r129, i64 %r130), !dbg !602
  %r132 = call i64 @nova_rt_bytes_get(i64 %r128, i64 %r131), !dbg !602
  %r133 = add i64 61, 0, !dbg !602
  %r134.cmp = icmp eq i64 %r132, %r133, !dbg !602
  %r134 = zext i1 %r134.cmp to i64, !dbg !602
  store i64 %r134, ptr %slot.__sc_378, align 8, !dbg !602
  br label %and_merge380, !dbg !602
and_merge380:
  %r135 = load i64, ptr %slot.__sc_378, align 8, !dbg !602
  %br_then38116 = icmp ne i64 %r135, 0, !dbg !602
  br i1 %br_then38116, label %then381, label %else382, !dbg !602
then381:
  %r136 = load i64, ptr %slot.st, align 8, !dbg !603
  %r137.p = getelementptr inbounds [4 x i8], ptr @.str.0, i64 0, i64 0, !dbg !603
  %r137 = ptrtoint ptr %r137.p to i64, !dbg !603
  %r138 = call i64 @nova_rt_dict_get(i64 %r136, i64 %r137), !dbg !603
  %r139 = add i64 1, 0, !dbg !603
  %r140 = call i64 @nova_rt_add(i64 %r138, i64 %r139), !dbg !603
  %r141 = load i64, ptr %slot.st, align 8, !dbg !603
  %r142.p = getelementptr inbounds [4 x i8], ptr @.str.0, i64 0, i64 0, !dbg !603
  %r142 = ptrtoint ptr %r142.p to i64, !dbg !603
  %_is.dv17 = call i64 @nova_rt_dict_set_no_rc(i64 %r141, i64 %r142, i64 %r140), !dbg !603
  br label %endif383, !dbg !603
else382:
  br label %endif383, !dbg !603
endif383:
  %r143 = load i64, ptr %slot.bs, align 8, !dbg !604
  %r144 = load i64, ptr %slot.n, align 8, !dbg !604
  %r145 = load i64, ptr %slot.st, align 8, !dbg !604
  %r146 = call i64 @_tm_skip_h(i64 %r143, i64 %r144, i64 %r145), !dbg !604
  %r147 = load i64, ptr %slot.text, align 8, !dbg !605
  %r148 = load i64, ptr %slot.bs, align 8, !dbg !605
  %r149 = load i64, ptr %slot.n, align 8, !dbg !605
  %r150 = load i64, ptr %slot.st, align 8, !dbg !605
  %r151 = add i64 0, 0, !dbg !605
  %r152 = call i64 @_tm_parse_value(i64 %r147, i64 %r148, i64 %r149, i64 %r150, i64 %r151), !dbg !605
  store i64 %r152, ptr %slot.val, align 8, !dbg !605
  %r153 = load i64, ptr %slot.current, align 8, !dbg !606
  %r154 = load i64, ptr %slot.segs2, align 8, !dbg !606
  %r155 = add i64 %r152, 0, !dbg !606
  %r156 = call i64 @_tm_assign(i64 %r153, i64 %r154, i64 %r155), !dbg !606
  br label %endif356, !dbg !606
endif356:
  %r157 = load i64, ptr %slot.st, align 8, !dbg !607
  %r158.p = getelementptr inbounds [4 x i8], ptr @.str.0, i64 0, i64 0, !dbg !607
  %r158 = ptrtoint ptr %r158.p to i64, !dbg !607
  %r159 = call i64 @nova_rt_dict_get(i64 %r157, i64 %r158), !dbg !607
  %r160 = load i64, ptr %slot.p, align 8, !dbg !607
  %r161 = call i64 @nova_rt_le(i64 %r159, i64 %r160), !dbg !607
  %br_then38418 = icmp ne i64 %r161, 0, !dbg !607
  br i1 %br_then38418, label %then384, label %else385, !dbg !607
then384:
  %r162 = load i64, ptr %slot.p, align 8, !dbg !608
  %r163 = add i64 1, 0, !dbg !608
  %r164 = call i64 @nova_rt_add(i64 %r162, i64 %r163), !dbg !608
  %r165 = load i64, ptr %slot.st, align 8, !dbg !608
  %r166.p = getelementptr inbounds [4 x i8], ptr @.str.0, i64 0, i64 0, !dbg !608
  %r166 = ptrtoint ptr %r166.p to i64, !dbg !608
  %_is.dv19 = call i64 @nova_rt_dict_set_no_rc(i64 %r165, i64 %r166, i64 %r164), !dbg !608
  br label %endif386, !dbg !608
else385:
  br label %endif386, !dbg !608
endif386:
  br label %endif353, !dbg !608
endif353:
  br label %while_hdr348, !dbg !608
while_exit350:
  %r167 = load i64, ptr %slot.result, align 8, !dbg !609
  ret i64 %r167, !dbg !609
}

; ESCAPE toml_get: allocs=0 escape=0 local=0
define i64 @toml_get(i64 %p0, i64 %p1) nounwind uwtable !dbg !610 {
entry:
  %slot.config = alloca i64, align 8, !dbg !611
  store i64 %p0, ptr %slot.config, align 8, !dbg !611
  %slot.path = alloca i64, align 8, !dbg !611
  store i64 %p1, ptr %slot.path, align 8, !dbg !611
  %slot.segs = alloca i64, align 8, !dbg !611
  store i64 0, ptr %slot.segs, align 8, !dbg !611
  %slot.node = alloca i64, align 8, !dbg !611
  store i64 0, ptr %slot.node, align 8, !dbg !611
  %slot.result = alloca i64, align 8, !dbg !611
  store i64 0, ptr %slot.result, align 8, !dbg !611
  %slot.ok = alloca i64, align 8, !dbg !611
  store i64 0, ptr %slot.ok, align 8, !dbg !611
  %slot.__for_idx_387 = alloca i64, align 8, !dbg !611
  store i64 0, ptr %slot.__for_idx_387, align 8, !dbg !611
  %slot.seg = alloca i64, align 8, !dbg !611
  store i64 0, ptr %slot.seg, align 8, !dbg !611
  %slot.__sc_394 = alloca i64, align 8, !dbg !611
  store i64 0, ptr %slot.__sc_394, align 8, !dbg !611
  %r0 = load i64, ptr %slot.path, align 8, !dbg !612
  %r1.p = getelementptr inbounds [2 x i8], ptr @.str.3, i64 0, i64 0, !dbg !612
  %r1 = ptrtoint ptr %r1.p to i64, !dbg !612
  %r2 = call i64 @nova_rt_split(i64 %r0, i64 %r1), !dbg !612
  store i64 %r2, ptr %slot.segs, align 8, !dbg !612
  %r3 = load i64, ptr %slot.config, align 8, !dbg !613
  store i64 %r3, ptr %slot.node, align 8, !dbg !613
  %r4.p = getelementptr inbounds [1 x i8], ptr @.str.6, i64 0, i64 0, !dbg !614
  %r4 = ptrtoint ptr %r4.p to i64, !dbg !614
  store i64 %r4, ptr %slot.result, align 8, !dbg !614
  %r5 = add i64 1, 0, !dbg !615
  store i64 %r5, ptr %slot.ok, align 8, !dbg !615
  %r6 = add i64 %r2, 0, !dbg !616
  %r7 = add i64 %r6, 0, !dbg !616
  %r8.lp = inttoptr i64 %r7 to ptr, !dbg !616
  %r8.szp = getelementptr i64, ptr %r8.lp, i64 1, !dbg !616
  %r8 = load i64, ptr %r8.szp, align 8, !tbaa !6, !dbg !616
  %r9 = add i64 0, 0, !dbg !616
  store i64 %r9, ptr %slot.__for_idx_387, align 8, !dbg !616
  br label %for_hdr387, !dbg !616
for_hdr387:
  %r10 = load i64, ptr %slot.__for_idx_387, align 8, !dbg !616
  %r11.cmp = icmp slt i64 %r10, %r8, !dbg !616
  %r11 = zext i1 %r11.cmp to i64, !dbg !616
  %br_for_body3880 = icmp ne i64 %r11, 0, !dbg !616
  br i1 %br_for_body3880, label %for_body388, label %for_exit390, !prof !90, !dbg !616
for_body388:
  %r12 = call i64 @nova_rt_index_get(i64 %r7, i64 %r10), !dbg !616
  store i64 %r12, ptr %slot.seg, align 8, !dbg !616
  %r13 = load i64, ptr %slot.ok, align 8, !dbg !617
  %r14 = add i64 1, 0, !dbg !617
  %r15.cmp = icmp eq i64 %r13, %r14, !dbg !617
  %r15 = zext i1 %r15.cmp to i64, !dbg !617
  %br_then3911 = icmp ne i64 %r15, 0, !dbg !617
  br i1 %br_then3911, label %then391, label %else392, !dbg !617
then391:
  %r16.p = getelementptr inbounds [5 x i8], ptr @.str.7, i64 0, i64 0, !dbg !618
  %r16 = ptrtoint ptr %r16.p to i64, !dbg !618
  %r17.p = getelementptr inbounds [5 x i8], ptr @.str.7, i64 0, i64 0, !dbg !618
  %r17 = ptrtoint ptr %r17.p to i64, !dbg !618
  %r18.p0 = inttoptr i64 %r16 to ptr, !dbg !618
  %r18.p1 = inttoptr i64 %r17 to ptr, !dbg !618
  %r18.sc = call i32 @strcmp(ptr %r18.p0, ptr %r18.p1), !dbg !618
  %r18.cmp = icmp eq i32 %r18.sc, 0, !dbg !618
  %r18 = zext i1 %r18.cmp to i64, !dbg !618
  store i64 %r18, ptr %slot.__sc_394, align 8, !dbg !618
  %br_and_rhs3952 = icmp ne i64 %r18, 0, !dbg !618
  br i1 %br_and_rhs3952, label %and_rhs395, label %and_merge396, !dbg !618
and_rhs395:
  %r19 = load i64, ptr %slot.node, align 8, !dbg !618
  %r20 = load i64, ptr %slot.seg, align 8, !dbg !618
  %r21 = call i64 @nova_rt_contains(i64 %r19, i64 %r20), !dbg !618
  store i64 %r21, ptr %slot.__sc_394, align 8, !dbg !618
  br label %and_merge396, !dbg !618
and_merge396:
  %r22 = load i64, ptr %slot.__sc_394, align 8, !dbg !618
  %wbox0 = call i64 @nova_rt_truthy(i64 %r22), !dbg !618
  %br_then3973 = icmp ne i64 %wbox0, 0, !dbg !618
  br i1 %br_then3973, label %then397, label %else398, !dbg !618
then397:
  %r23 = load i64, ptr %slot.node, align 8, !dbg !619
  %r24 = load i64, ptr %slot.seg, align 8, !dbg !619
  %r25 = call i64 @nova_rt_dict_get(i64 %r23, i64 %r24), !dbg !619
  store i64 %r25, ptr %slot.node, align 8, !dbg !619
  br label %endif399, !dbg !619
else398:
  %r26 = add i64 0, 0, !dbg !620
  store i64 %r26, ptr %slot.ok, align 8, !dbg !620
  br label %endif399, !dbg !620
endif399:
  br label %endif393, !dbg !620
else392:
  br label %endif393, !dbg !620
endif393:
  br label %for_inc389, !dbg !620
for_inc389:
  %r27 = load i64, ptr %slot.__for_idx_387, align 8, !dbg !620
  %r28 = add i64 1, 0, !dbg !620
  %r29 = add i64 %r27, %r28, !dbg !620
  store i64 %r29, ptr %slot.__for_idx_387, align 8, !dbg !620
  br label %for_hdr387, !dbg !620
for_exit390:
  %r30 = load i64, ptr %slot.ok, align 8, !dbg !621
  %r31 = add i64 1, 0, !dbg !621
  %r32.cmp = icmp eq i64 %r30, %r31, !dbg !621
  %r32 = zext i1 %r32.cmp to i64, !dbg !621
  %br_then4004 = icmp ne i64 %r32, 0, !dbg !621
  br i1 %br_then4004, label %then400, label %else401, !dbg !621
then400:
  %r33 = load i64, ptr %slot.node, align 8, !dbg !622
  store i64 %r33, ptr %slot.result, align 8, !dbg !622
  br label %endif402, !dbg !622
else401:
  br label %endif402, !dbg !622
endif402:
  %r34 = load i64, ptr %slot.result, align 8, !dbg !623
  ret i64 %r34, !dbg !623
}

; ESCAPE nova_main: allocs=0 escape=0 local=0
define i64 @nova_main() nounwind uwtable {
entry:
  %slot._TM_MAX_DEPTH = alloca i64, align 8
  store i64 0, ptr %slot._TM_MAX_DEPTH, align 8
  %r0 = add i64 1000, 0
  store i64 %r0, ptr %slot._TM_MAX_DEPTH, align 8
  ret i64 0
}

; ESCAPE SUMMARY: allocs=12 escape=11 local=1 (8% local, RC-elidable)
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

; String constants
@.str.0 = private unnamed_addr constant [4 x i8] c"pos\00"
@.str.1 = private unnamed_addr constant [5 x i8] c"true\00"
@.str.2 = private unnamed_addr constant [6 x i8] c"false\00"
@.str.3 = private unnamed_addr constant [2 x i8] c".\00"
@.str.4 = private unnamed_addr constant [2 x i8] c"e\00"
@.str.5 = private unnamed_addr constant [2 x i8] c"E\00"
@.str.6 = private unnamed_addr constant [1 x i8] c"\00"
@.str.7 = private unnamed_addr constant [5 x i8] c"dict\00"
@.str.8 = private unnamed_addr constant [5 x i8] c"list\00"

; Debug metadata
!llvm.dbg.cu = !{!100}
!llvm.module.flags = !{!102, !103}

!100 = distinct !DICompileUnit(language: DW_LANG_C99, file: !101, producer: "NOVA Compiler", isOptimized: false, emissionKind: LineTablesOnly)
!101 = !DIFile(filename: "../std/data/toml.nova", directory: ".")
!102 = !{i32 2, !"CodeView", i32 1}
!103 = !{i32 2, !"Debug Info Version", i32 3}
!104 = !DISubroutineType(types: !105)
!105 = !{null}
!200 = distinct !DISubprogram(name: "_tm_is_hspace", scope: !101, file: !101, line: 134, type: !104, scopeLine: 134, spFlags: DISPFlagDefinition, unit: !100)
!201 = !DILocation(line: 134, column: 0, scope: !200)
!208 = distinct !DISubprogram(name: "_tm_is_nl", scope: !101, file: !101, line: 144, type: !104, scopeLine: 144, spFlags: DISPFlagDefinition, unit: !100)
!209 = !DILocation(line: 144, column: 0, scope: !208)
!216 = distinct !DISubprogram(name: "_tm_is_digit", scope: !101, file: !101, line: 154, type: !104, scopeLine: 154, spFlags: DISPFlagDefinition, unit: !100)
!217 = !DILocation(line: 154, column: 0, scope: !216)
!223 = distinct !DISubprogram(name: "_tm_is_bare_key_char", scope: !101, file: !101, line: 162, type: !104, scopeLine: 162, spFlags: DISPFlagDefinition, unit: !100)
!224 = !DILocation(line: 162, column: 0, scope: !223)
!243 = distinct !DISubprogram(name: "_tm_skip_h", scope: !101, file: !101, line: 190, type: !104, scopeLine: 190, spFlags: DISPFlagDefinition, unit: !100)
!244 = !DILocation(line: 190, column: 0, scope: !243)
!253 = distinct !DISubprogram(name: "_tm_skip_to_eol", scope: !101, file: !101, line: 204, type: !104, scopeLine: 204, spFlags: DISPFlagDefinition, unit: !100)
!254 = !DILocation(line: 204, column: 0, scope: !253)
!263 = distinct !DISubprogram(name: "_tm_skip_ws_nl_comments", scope: !101, file: !101, line: 219, type: !104, scopeLine: 219, spFlags: DISPFlagDefinition, unit: !100)
!264 = !DILocation(line: 219, column: 0, scope: !263)
!278 = distinct !DISubprogram(name: "_tm_parse_basic_string", scope: !101, file: !101, line: 250, type: !104, scopeLine: 250, spFlags: DISPFlagDefinition, unit: !100)
!279 = !DILocation(line: 250, column: 0, scope: !278)
!310 = distinct !DISubprogram(name: "_tm_parse_literal_string", scope: !101, file: !101, line: 297, type: !104, scopeLine: 297, spFlags: DISPFlagDefinition, unit: !100)
!311 = !DILocation(line: 297, column: 0, scope: !310)
!326 = distinct !DISubprogram(name: "_tm_read_bare_key", scope: !101, file: !101, line: 320, type: !104, scopeLine: 320, spFlags: DISPFlagDefinition, unit: !100)
!327 = !DILocation(line: 320, column: 0, scope: !326)
!339 = distinct !DISubprogram(name: "_tm_read_bare_token", scope: !101, file: !101, line: 339, type: !104, scopeLine: 339, spFlags: DISPFlagDefinition, unit: !100)
!340 = !DILocation(line: 339, column: 0, scope: !339)
!365 = distinct !DISubprogram(name: "_tm_strip_underscores", scope: !101, file: !101, line: 378, type: !104, scopeLine: 378, spFlags: DISPFlagDefinition, unit: !100)
!366 = !DILocation(line: 378, column: 0, scope: !365)
!377 = distinct !DISubprogram(name: "_tm_is_numeric", scope: !101, file: !101, line: 394, type: !104, scopeLine: 394, spFlags: DISPFlagDefinition, unit: !100)
!378 = !DILocation(line: 394, column: 0, scope: !377)
!414 = distinct !DISubprogram(name: "_tm_classify_scalar", scope: !101, file: !101, line: 438, type: !104, scopeLine: 438, spFlags: DISPFlagDefinition, unit: !100)
!415 = !DILocation(line: 438, column: 0, scope: !414)
!428 = distinct !DISubprogram(name: "_tm_skip_balanced", scope: !101, file: !101, line: 467, type: !104, scopeLine: 467, spFlags: DISPFlagDefinition, unit: !100)
!429 = !DILocation(line: 467, column: 0, scope: !428)
!454 = distinct !DISubprogram(name: "_tm_parse_array", scope: !101, file: !101, line: 504, type: !104, scopeLine: 504, spFlags: DISPFlagDefinition, unit: !100)
!455 = !DILocation(line: 504, column: 0, scope: !454)
!474 = distinct !DISubprogram(name: "_tm_parse_value", scope: !101, file: !101, line: 538, type: !104, scopeLine: 538, spFlags: DISPFlagDefinition, unit: !100)
!475 = !DILocation(line: 538, column: 0, scope: !474)
!497 = distinct !DISubprogram(name: "_tm_read_key_path", scope: !101, file: !101, line: 569, type: !104, scopeLine: 569, spFlags: DISPFlagDefinition, unit: !100)
!498 = !DILocation(line: 569, column: 0, scope: !497)
!521 = distinct !DISubprogram(name: "_tm_nav", scope: !101, file: !101, line: 603, type: !104, scopeLine: 603, spFlags: DISPFlagDefinition, unit: !100)
!522 = !DILocation(line: 603, column: 0, scope: !521)
!542 = distinct !DISubprogram(name: "_tm_assign", scope: !101, file: !101, line: 632, type: !104, scopeLine: 632, spFlags: DISPFlagDefinition, unit: !100)
!543 = !DILocation(line: 632, column: 0, scope: !542)
!551 = distinct !DISubprogram(name: "_tm_open_table", scope: !101, file: !101, line: 644, type: !104, scopeLine: 644, spFlags: DISPFlagDefinition, unit: !100)
!552 = !DILocation(line: 644, column: 0, scope: !551)
!571 = distinct !DISubprogram(name: "toml_parse", scope: !101, file: !101, line: 675, type: !104, scopeLine: 675, spFlags: DISPFlagDefinition, unit: !100)
!572 = !DILocation(line: 675, column: 0, scope: !571)
!610 = distinct !DISubprogram(name: "toml_get", scope: !101, file: !101, line: 727, type: !104, scopeLine: 727, spFlags: DISPFlagDefinition, unit: !100)
!611 = !DILocation(line: 727, column: 0, scope: !610)
!202 = !DILocation(line: 135, column: 0, scope: !200)
!203 = !DILocation(line: 136, column: 0, scope: !200)
!204 = !DILocation(line: 137, column: 0, scope: !200)
!205 = !DILocation(line: 139, column: 0, scope: !200)
!206 = !DILocation(line: 140, column: 0, scope: !200)
!207 = !DILocation(line: 141, column: 0, scope: !200)
!210 = !DILocation(line: 145, column: 0, scope: !208)
!211 = !DILocation(line: 146, column: 0, scope: !208)
!212 = !DILocation(line: 147, column: 0, scope: !208)
!213 = !DILocation(line: 149, column: 0, scope: !208)
!214 = !DILocation(line: 150, column: 0, scope: !208)
!215 = !DILocation(line: 151, column: 0, scope: !208)
!218 = !DILocation(line: 155, column: 0, scope: !216)
!219 = !DILocation(line: 156, column: 0, scope: !216)
!220 = !DILocation(line: 157, column: 0, scope: !216)
!221 = !DILocation(line: 158, column: 0, scope: !216)
!222 = !DILocation(line: 159, column: 0, scope: !216)
!225 = !DILocation(line: 163, column: 0, scope: !223)
!226 = !DILocation(line: 164, column: 0, scope: !223)
!227 = !DILocation(line: 165, column: 0, scope: !223)
!228 = !DILocation(line: 166, column: 0, scope: !223)
!229 = !DILocation(line: 167, column: 0, scope: !223)
!230 = !DILocation(line: 168, column: 0, scope: !223)
!231 = !DILocation(line: 169, column: 0, scope: !223)
!232 = !DILocation(line: 170, column: 0, scope: !223)
!233 = !DILocation(line: 171, column: 0, scope: !223)
!234 = !DILocation(line: 172, column: 0, scope: !223)
!235 = !DILocation(line: 173, column: 0, scope: !223)
!236 = !DILocation(line: 174, column: 0, scope: !223)
!237 = !DILocation(line: 175, column: 0, scope: !223)
!238 = !DILocation(line: 176, column: 0, scope: !223)
!239 = !DILocation(line: 177, column: 0, scope: !223)
!240 = !DILocation(line: 178, column: 0, scope: !223)
!241 = !DILocation(line: 179, column: 0, scope: !223)
!242 = !DILocation(line: 180, column: 0, scope: !223)
!245 = !DILocation(line: 191, column: 0, scope: !243)
!246 = !DILocation(line: 192, column: 0, scope: !243)
!247 = !DILocation(line: 193, column: 0, scope: !243)
!248 = !DILocation(line: 194, column: 0, scope: !243)
!249 = !DILocation(line: 195, column: 0, scope: !243)
!250 = !DILocation(line: 197, column: 0, scope: !243)
!251 = !DILocation(line: 198, column: 0, scope: !243)
!252 = !DILocation(line: 200, column: 0, scope: !243)
!255 = !DILocation(line: 205, column: 0, scope: !253)
!256 = !DILocation(line: 206, column: 0, scope: !253)
!257 = !DILocation(line: 207, column: 0, scope: !253)
!258 = !DILocation(line: 208, column: 0, scope: !253)
!259 = !DILocation(line: 209, column: 0, scope: !253)
!260 = !DILocation(line: 211, column: 0, scope: !253)
!261 = !DILocation(line: 212, column: 0, scope: !253)
!262 = !DILocation(line: 214, column: 0, scope: !253)
!265 = !DILocation(line: 220, column: 0, scope: !263)
!266 = !DILocation(line: 221, column: 0, scope: !263)
!267 = !DILocation(line: 222, column: 0, scope: !263)
!268 = !DILocation(line: 223, column: 0, scope: !263)
!269 = !DILocation(line: 224, column: 0, scope: !263)
!270 = !DILocation(line: 226, column: 0, scope: !263)
!271 = !DILocation(line: 227, column: 0, scope: !263)
!272 = !DILocation(line: 228, column: 0, scope: !263)
!273 = !DILocation(line: 230, column: 0, scope: !263)
!274 = !DILocation(line: 231, column: 0, scope: !263)
!275 = !DILocation(line: 233, column: 0, scope: !263)
!276 = !DILocation(line: 234, column: 0, scope: !263)
!277 = !DILocation(line: 236, column: 0, scope: !263)
!280 = !DILocation(line: 251, column: 0, scope: !278)
!281 = !DILocation(line: 252, column: 0, scope: !278)
!282 = !DILocation(line: 253, column: 0, scope: !278)
!283 = !DILocation(line: 254, column: 0, scope: !278)
!284 = !DILocation(line: 255, column: 0, scope: !278)
!285 = !DILocation(line: 256, column: 0, scope: !278)
!286 = !DILocation(line: 258, column: 0, scope: !278)
!287 = !DILocation(line: 259, column: 0, scope: !278)
!288 = !DILocation(line: 260, column: 0, scope: !278)
!289 = !DILocation(line: 261, column: 0, scope: !278)
!290 = !DILocation(line: 263, column: 0, scope: !278)
!291 = !DILocation(line: 264, column: 0, scope: !278)
!292 = !DILocation(line: 265, column: 0, scope: !278)
!293 = !DILocation(line: 266, column: 0, scope: !278)
!294 = !DILocation(line: 267, column: 0, scope: !278)
!295 = !DILocation(line: 268, column: 0, scope: !278)
!296 = !DILocation(line: 269, column: 0, scope: !278)
!297 = !DILocation(line: 270, column: 0, scope: !278)
!298 = !DILocation(line: 272, column: 0, scope: !278)
!299 = !DILocation(line: 273, column: 0, scope: !278)
!300 = !DILocation(line: 275, column: 0, scope: !278)
!301 = !DILocation(line: 276, column: 0, scope: !278)
!302 = !DILocation(line: 278, column: 0, scope: !278)
!303 = !DILocation(line: 279, column: 0, scope: !278)
!304 = !DILocation(line: 281, column: 0, scope: !278)
!305 = !DILocation(line: 282, column: 0, scope: !278)
!306 = !DILocation(line: 284, column: 0, scope: !278)
!307 = !DILocation(line: 286, column: 0, scope: !278)
!308 = !DILocation(line: 287, column: 0, scope: !278)
!309 = !DILocation(line: 288, column: 0, scope: !278)
!312 = !DILocation(line: 298, column: 0, scope: !310)
!313 = !DILocation(line: 299, column: 0, scope: !310)
!314 = !DILocation(line: 300, column: 0, scope: !310)
!315 = !DILocation(line: 301, column: 0, scope: !310)
!316 = !DILocation(line: 302, column: 0, scope: !310)
!317 = !DILocation(line: 303, column: 0, scope: !310)
!318 = !DILocation(line: 304, column: 0, scope: !310)
!319 = !DILocation(line: 305, column: 0, scope: !310)
!320 = !DILocation(line: 307, column: 0, scope: !310)
!321 = !DILocation(line: 308, column: 0, scope: !310)
!322 = !DILocation(line: 309, column: 0, scope: !310)
!323 = !DILocation(line: 310, column: 0, scope: !310)
!324 = !DILocation(line: 312, column: 0, scope: !310)
!325 = !DILocation(line: 313, column: 0, scope: !310)
!328 = !DILocation(line: 321, column: 0, scope: !326)
!329 = !DILocation(line: 322, column: 0, scope: !326)
!330 = !DILocation(line: 323, column: 0, scope: !326)
!331 = !DILocation(line: 324, column: 0, scope: !326)
!332 = !DILocation(line: 325, column: 0, scope: !326)
!333 = !DILocation(line: 326, column: 0, scope: !326)
!334 = !DILocation(line: 328, column: 0, scope: !326)
!335 = !DILocation(line: 329, column: 0, scope: !326)
!336 = !DILocation(line: 330, column: 0, scope: !326)
!337 = !DILocation(line: 332, column: 0, scope: !326)
!338 = !DILocation(line: 333, column: 0, scope: !326)
!341 = !DILocation(line: 340, column: 0, scope: !339)
!342 = !DILocation(line: 341, column: 0, scope: !339)
!343 = !DILocation(line: 342, column: 0, scope: !339)
!344 = !DILocation(line: 343, column: 0, scope: !339)
!345 = !DILocation(line: 344, column: 0, scope: !339)
!346 = !DILocation(line: 345, column: 0, scope: !339)
!347 = !DILocation(line: 347, column: 0, scope: !339)
!348 = !DILocation(line: 348, column: 0, scope: !339)
!349 = !DILocation(line: 349, column: 0, scope: !339)
!350 = !DILocation(line: 350, column: 0, scope: !339)
!351 = !DILocation(line: 352, column: 0, scope: !339)
!352 = !DILocation(line: 353, column: 0, scope: !339)
!353 = !DILocation(line: 355, column: 0, scope: !339)
!354 = !DILocation(line: 356, column: 0, scope: !339)
!355 = !DILocation(line: 358, column: 0, scope: !339)
!356 = !DILocation(line: 359, column: 0, scope: !339)
!357 = !DILocation(line: 361, column: 0, scope: !339)
!358 = !DILocation(line: 362, column: 0, scope: !339)
!359 = !DILocation(line: 364, column: 0, scope: !339)
!360 = !DILocation(line: 365, column: 0, scope: !339)
!361 = !DILocation(line: 366, column: 0, scope: !339)
!362 = !DILocation(line: 367, column: 0, scope: !339)
!363 = !DILocation(line: 369, column: 0, scope: !339)
!364 = !DILocation(line: 370, column: 0, scope: !339)
!367 = !DILocation(line: 379, column: 0, scope: !365)
!368 = !DILocation(line: 380, column: 0, scope: !365)
!369 = !DILocation(line: 381, column: 0, scope: !365)
!370 = !DILocation(line: 382, column: 0, scope: !365)
!371 = !DILocation(line: 383, column: 0, scope: !365)
!372 = !DILocation(line: 384, column: 0, scope: !365)
!373 = !DILocation(line: 385, column: 0, scope: !365)
!374 = !DILocation(line: 386, column: 0, scope: !365)
!375 = !DILocation(line: 387, column: 0, scope: !365)
!376 = !DILocation(line: 388, column: 0, scope: !365)
!379 = !DILocation(line: 395, column: 0, scope: !377)
!380 = !DILocation(line: 396, column: 0, scope: !377)
!381 = !DILocation(line: 397, column: 0, scope: !377)
!382 = !DILocation(line: 398, column: 0, scope: !377)
!383 = !DILocation(line: 399, column: 0, scope: !377)
!384 = !DILocation(line: 400, column: 0, scope: !377)
!385 = !DILocation(line: 401, column: 0, scope: !377)
!386 = !DILocation(line: 402, column: 0, scope: !377)
!387 = !DILocation(line: 404, column: 0, scope: !377)
!388 = !DILocation(line: 405, column: 0, scope: !377)
!389 = !DILocation(line: 406, column: 0, scope: !377)
!390 = !DILocation(line: 407, column: 0, scope: !377)
!391 = !DILocation(line: 408, column: 0, scope: !377)
!392 = !DILocation(line: 409, column: 0, scope: !377)
!393 = !DILocation(line: 410, column: 0, scope: !377)
!394 = !DILocation(line: 411, column: 0, scope: !377)
!395 = !DILocation(line: 412, column: 0, scope: !377)
!396 = !DILocation(line: 413, column: 0, scope: !377)
!397 = !DILocation(line: 414, column: 0, scope: !377)
!398 = !DILocation(line: 415, column: 0, scope: !377)
!399 = !DILocation(line: 417, column: 0, scope: !377)
!400 = !DILocation(line: 418, column: 0, scope: !377)
!401 = !DILocation(line: 419, column: 0, scope: !377)
!402 = !DILocation(line: 421, column: 0, scope: !377)
!403 = !DILocation(line: 422, column: 0, scope: !377)
!404 = !DILocation(line: 423, column: 0, scope: !377)
!405 = !DILocation(line: 424, column: 0, scope: !377)
!406 = !DILocation(line: 425, column: 0, scope: !377)
!407 = !DILocation(line: 426, column: 0, scope: !377)
!408 = !DILocation(line: 427, column: 0, scope: !377)
!409 = !DILocation(line: 429, column: 0, scope: !377)
!410 = !DILocation(line: 430, column: 0, scope: !377)
!411 = !DILocation(line: 431, column: 0, scope: !377)
!412 = !DILocation(line: 432, column: 0, scope: !377)
!413 = !DILocation(line: 433, column: 0, scope: !377)
!416 = !DILocation(line: 439, column: 0, scope: !414)
!417 = !DILocation(line: 440, column: 0, scope: !414)
!418 = !DILocation(line: 441, column: 0, scope: !414)
!419 = !DILocation(line: 443, column: 0, scope: !414)
!420 = !DILocation(line: 444, column: 0, scope: !414)
!421 = !DILocation(line: 446, column: 0, scope: !414)
!422 = !DILocation(line: 447, column: 0, scope: !414)
!423 = !DILocation(line: 448, column: 0, scope: !414)
!424 = !DILocation(line: 449, column: 0, scope: !414)
!425 = !DILocation(line: 451, column: 0, scope: !414)
!426 = !DILocation(line: 453, column: 0, scope: !414)
!427 = !DILocation(line: 454, column: 0, scope: !414)
!430 = !DILocation(line: 468, column: 0, scope: !428)
!431 = !DILocation(line: 469, column: 0, scope: !428)
!432 = !DILocation(line: 470, column: 0, scope: !428)
!433 = !DILocation(line: 471, column: 0, scope: !428)
!434 = !DILocation(line: 472, column: 0, scope: !428)
!435 = !DILocation(line: 473, column: 0, scope: !428)
!436 = !DILocation(line: 475, column: 0, scope: !428)
!437 = !DILocation(line: 476, column: 0, scope: !428)
!438 = !DILocation(line: 477, column: 0, scope: !428)
!439 = !DILocation(line: 478, column: 0, scope: !428)
!440 = !DILocation(line: 480, column: 0, scope: !428)
!441 = !DILocation(line: 481, column: 0, scope: !428)
!442 = !DILocation(line: 482, column: 0, scope: !428)
!443 = !DILocation(line: 484, column: 0, scope: !428)
!444 = !DILocation(line: 485, column: 0, scope: !428)
!445 = !DILocation(line: 486, column: 0, scope: !428)
!446 = !DILocation(line: 488, column: 0, scope: !428)
!447 = !DILocation(line: 489, column: 0, scope: !428)
!448 = !DILocation(line: 490, column: 0, scope: !428)
!449 = !DILocation(line: 491, column: 0, scope: !428)
!450 = !DILocation(line: 492, column: 0, scope: !428)
!451 = !DILocation(line: 494, column: 0, scope: !428)
!452 = !DILocation(line: 495, column: 0, scope: !428)
!453 = !DILocation(line: 497, column: 0, scope: !428)
!456 = !DILocation(line: 505, column: 0, scope: !454)
!457 = !DILocation(line: 506, column: 0, scope: !454)
!458 = !DILocation(line: 507, column: 0, scope: !454)
!459 = !DILocation(line: 508, column: 0, scope: !454)
!460 = !DILocation(line: 509, column: 0, scope: !454)
!461 = !DILocation(line: 510, column: 0, scope: !454)
!462 = !DILocation(line: 511, column: 0, scope: !454)
!463 = !DILocation(line: 513, column: 0, scope: !454)
!464 = !DILocation(line: 514, column: 0, scope: !454)
!465 = !DILocation(line: 515, column: 0, scope: !454)
!466 = !DILocation(line: 516, column: 0, scope: !454)
!467 = !DILocation(line: 518, column: 0, scope: !454)
!468 = !DILocation(line: 519, column: 0, scope: !454)
!469 = !DILocation(line: 521, column: 0, scope: !454)
!470 = !DILocation(line: 522, column: 0, scope: !454)
!471 = !DILocation(line: 531, column: 0, scope: !454)
!472 = !DILocation(line: 532, column: 0, scope: !454)
!473 = !DILocation(line: 533, column: 0, scope: !454)
!476 = !DILocation(line: 539, column: 0, scope: !474)
!477 = !DILocation(line: 540, column: 0, scope: !474)
!478 = !DILocation(line: 541, column: 0, scope: !474)
!479 = !DILocation(line: 542, column: 0, scope: !474)
!480 = !DILocation(line: 543, column: 0, scope: !474)
!481 = !DILocation(line: 544, column: 0, scope: !474)
!482 = !DILocation(line: 545, column: 0, scope: !474)
!483 = !DILocation(line: 546, column: 0, scope: !474)
!484 = !DILocation(line: 548, column: 0, scope: !474)
!485 = !DILocation(line: 549, column: 0, scope: !474)
!486 = !DILocation(line: 550, column: 0, scope: !474)
!487 = !DILocation(line: 552, column: 0, scope: !474)
!488 = !DILocation(line: 553, column: 0, scope: !474)
!489 = !DILocation(line: 554, column: 0, scope: !474)
!490 = !DILocation(line: 129, column: 0, scope: !474)
!491 = !DILocation(line: 555, column: 0, scope: !474)
!492 = !DILocation(line: 556, column: 0, scope: !474)
!493 = !DILocation(line: 558, column: 0, scope: !474)
!494 = !DILocation(line: 560, column: 0, scope: !474)
!495 = !DILocation(line: 561, column: 0, scope: !474)
!496 = !DILocation(line: 562, column: 0, scope: !474)
!499 = !DILocation(line: 570, column: 0, scope: !497)
!500 = !DILocation(line: 571, column: 0, scope: !497)
!501 = !DILocation(line: 572, column: 0, scope: !497)
!502 = !DILocation(line: 573, column: 0, scope: !497)
!503 = !DILocation(line: 574, column: 0, scope: !497)
!504 = !DILocation(line: 575, column: 0, scope: !497)
!505 = !DILocation(line: 576, column: 0, scope: !497)
!506 = !DILocation(line: 577, column: 0, scope: !497)
!507 = !DILocation(line: 578, column: 0, scope: !497)
!508 = !DILocation(line: 579, column: 0, scope: !497)
!509 = !DILocation(line: 580, column: 0, scope: !497)
!510 = !DILocation(line: 582, column: 0, scope: !497)
!511 = !DILocation(line: 583, column: 0, scope: !497)
!512 = !DILocation(line: 584, column: 0, scope: !497)
!513 = !DILocation(line: 586, column: 0, scope: !497)
!514 = !DILocation(line: 587, column: 0, scope: !497)
!515 = !DILocation(line: 588, column: 0, scope: !497)
!516 = !DILocation(line: 589, column: 0, scope: !497)
!517 = !DILocation(line: 590, column: 0, scope: !497)
!518 = !DILocation(line: 591, column: 0, scope: !497)
!519 = !DILocation(line: 593, column: 0, scope: !497)
!520 = !DILocation(line: 594, column: 0, scope: !497)
!523 = !DILocation(line: 604, column: 0, scope: !521)
!524 = !DILocation(line: 605, column: 0, scope: !521)
!525 = !DILocation(line: 606, column: 0, scope: !521)
!526 = !DILocation(line: 607, column: 0, scope: !521)
!527 = !DILocation(line: 608, column: 0, scope: !521)
!528 = !DILocation(line: 610, column: 0, scope: !521)
!529 = !DILocation(line: 611, column: 0, scope: !521)
!530 = !DILocation(line: 612, column: 0, scope: !521)
!531 = !DILocation(line: 613, column: 0, scope: !521)
!532 = !DILocation(line: 615, column: 0, scope: !521)
!533 = !DILocation(line: 616, column: 0, scope: !521)
!534 = !DILocation(line: 617, column: 0, scope: !521)
!535 = !DILocation(line: 621, column: 0, scope: !521)
!536 = !DILocation(line: 622, column: 0, scope: !521)
!537 = !DILocation(line: 623, column: 0, scope: !521)
!538 = !DILocation(line: 625, column: 0, scope: !521)
!539 = !DILocation(line: 626, column: 0, scope: !521)
!540 = !DILocation(line: 627, column: 0, scope: !521)
!541 = !DILocation(line: 628, column: 0, scope: !521)
!544 = !DILocation(line: 633, column: 0, scope: !542)
!545 = !DILocation(line: 634, column: 0, scope: !542)
!546 = !DILocation(line: 635, column: 0, scope: !542)
!547 = !DILocation(line: 636, column: 0, scope: !542)
!548 = !DILocation(line: 637, column: 0, scope: !542)
!549 = !DILocation(line: 638, column: 0, scope: !542)
!550 = !DILocation(line: 639, column: 0, scope: !542)
!553 = !DILocation(line: 645, column: 0, scope: !551)
!554 = !DILocation(line: 646, column: 0, scope: !551)
!555 = !DILocation(line: 647, column: 0, scope: !551)
!556 = !DILocation(line: 648, column: 0, scope: !551)
!557 = !DILocation(line: 649, column: 0, scope: !551)
!558 = !DILocation(line: 650, column: 0, scope: !551)
!559 = !DILocation(line: 651, column: 0, scope: !551)
!560 = !DILocation(line: 652, column: 0, scope: !551)
!561 = !DILocation(line: 653, column: 0, scope: !551)
!562 = !DILocation(line: 654, column: 0, scope: !551)
!563 = !DILocation(line: 655, column: 0, scope: !551)
!564 = !DILocation(line: 656, column: 0, scope: !551)
!565 = !DILocation(line: 658, column: 0, scope: !551)
!566 = !DILocation(line: 659, column: 0, scope: !551)
!567 = !DILocation(line: 660, column: 0, scope: !551)
!568 = !DILocation(line: 661, column: 0, scope: !551)
!569 = !DILocation(line: 663, column: 0, scope: !551)
!570 = !DILocation(line: 664, column: 0, scope: !551)
!573 = !DILocation(line: 676, column: 0, scope: !571)
!574 = !DILocation(line: 677, column: 0, scope: !571)
!575 = !DILocation(line: 678, column: 0, scope: !571)
!576 = !DILocation(line: 679, column: 0, scope: !571)
!577 = !DILocation(line: 680, column: 0, scope: !571)
!578 = !DILocation(line: 681, column: 0, scope: !571)
!579 = !DILocation(line: 682, column: 0, scope: !571)
!580 = !DILocation(line: 683, column: 0, scope: !571)
!581 = !DILocation(line: 684, column: 0, scope: !571)
!582 = !DILocation(line: 685, column: 0, scope: !571)
!583 = !DILocation(line: 686, column: 0, scope: !571)
!584 = !DILocation(line: 687, column: 0, scope: !571)
!585 = !DILocation(line: 689, column: 0, scope: !571)
!586 = !DILocation(line: 690, column: 0, scope: !571)
!587 = !DILocation(line: 691, column: 0, scope: !571)
!588 = !DILocation(line: 692, column: 0, scope: !571)
!589 = !DILocation(line: 693, column: 0, scope: !571)
!590 = !DILocation(line: 694, column: 0, scope: !571)
!591 = !DILocation(line: 695, column: 0, scope: !571)
!592 = !DILocation(line: 696, column: 0, scope: !571)
!593 = !DILocation(line: 697, column: 0, scope: !571)
!594 = !DILocation(line: 698, column: 0, scope: !571)
!595 = !DILocation(line: 699, column: 0, scope: !571)
!596 = !DILocation(line: 700, column: 0, scope: !571)
!597 = !DILocation(line: 701, column: 0, scope: !571)
!598 = !DILocation(line: 702, column: 0, scope: !571)
!599 = !DILocation(line: 703, column: 0, scope: !571)
!600 = !DILocation(line: 705, column: 0, scope: !571)
!601 = !DILocation(line: 706, column: 0, scope: !571)
!602 = !DILocation(line: 707, column: 0, scope: !571)
!603 = !DILocation(line: 708, column: 0, scope: !571)
!604 = !DILocation(line: 709, column: 0, scope: !571)
!605 = !DILocation(line: 710, column: 0, scope: !571)
!606 = !DILocation(line: 711, column: 0, scope: !571)
!607 = !DILocation(line: 721, column: 0, scope: !571)
!608 = !DILocation(line: 722, column: 0, scope: !571)
!609 = !DILocation(line: 723, column: 0, scope: !571)
!612 = !DILocation(line: 728, column: 0, scope: !610)
!613 = !DILocation(line: 729, column: 0, scope: !610)
!614 = !DILocation(line: 730, column: 0, scope: !610)
!615 = !DILocation(line: 731, column: 0, scope: !610)
!616 = !DILocation(line: 732, column: 0, scope: !610)
!617 = !DILocation(line: 733, column: 0, scope: !610)
!618 = !DILocation(line: 734, column: 0, scope: !610)
!619 = !DILocation(line: 735, column: 0, scope: !610)
!620 = !DILocation(line: 737, column: 0, scope: !610)
!621 = !DILocation(line: 738, column: 0, scope: !610)
!622 = !DILocation(line: 739, column: 0, scope: !610)
!623 = !DILocation(line: 740, column: 0, scope: !610)

; TBAA metadata
!0 = !{!"NOVA TBAA"}
!1 = !{!"list_data_ptr", !0}
!2 = !{!1, !1, i64 0}
!3 = !{!"list_elem", !0}
!4 = !{!3, !3, i64 0}
!5 = !{!"list_size", !0}
!6 = !{!5, !5, i64 0}
!90 = !{!"branch_weights", i32 2000, i32 1}
