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

; ESCAPE _qb_join: allocs=0 escape=0 local=0
define i64 @_qb_join(i64 %p0, i64 %p1) nounwind uwtable !dbg !200 {
entry:
  %slot.items = alloca i64, align 8, !dbg !201
  store i64 %p0, ptr %slot.items, align 8, !dbg !201
  %slot.sep = alloca i64, align 8, !dbg !201
  store i64 %p1, ptr %slot.sep, align 8, !dbg !201
  %slot.n = alloca i64, align 8, !dbg !201
  store i64 0, ptr %slot.n, align 8, !dbg !201
  %slot.out = alloca i64, align 8, !dbg !201
  store i64 0, ptr %slot.out, align 8, !dbg !201
  %slot.i = alloca i64, align 8, !dbg !201
  store i64 0, ptr %slot.i, align 8, !dbg !201
  %slot.items__s4f54 = alloca i64, align 8, !dbg !201
  store i64 0, ptr %slot.items__s4f54, align 8, !dbg !201
  %r0 = load i64, ptr %slot.items, align 8, !dbg !202
  %r1 = call i64 @nova_rt_len_any(i64 %r0), !dbg !202
  store i64 %r1, ptr %slot.n, align 8, !dbg !202
  %r2.p = getelementptr inbounds [1 x i8], ptr @.str.0, i64 0, i64 0, !dbg !203
  %r2 = ptrtoint ptr %r2.p to i64, !dbg !203
  store i64 %r2, ptr %slot.out, align 8, !dbg !203
  %r3 = add i64 0, 0, !dbg !204
  store i64 %r3, ptr %slot.i, align 8, !dbg !204
  %r4 = load i64, ptr %slot.items, align 8, !dbg !205
  %r5 = call i64 @nova_rt_list_is_kind2(i64 %r4), !dbg !205
  %br_then00 = icmp ne i64 %r5, 0, !dbg !205
  br i1 %br_then00, label %then0, label %else1, !dbg !205
then0:
  %r6 = load i64, ptr %slot.items, align 8, !dbg !205
  %r7 = call i64 @nova_rt_floatlist_view(i64 %r6), !dbg !205
  store i64 %r7, ptr %slot.items__s4f54, align 8, !dbg !205
  br label %while_hdr3, !dbg !205
while_hdr3:
  %r8 = load i64, ptr %slot.i, align 8, !dbg !205
  %r9 = load i64, ptr %slot.n, align 8, !dbg !205
  %r10.cmp = icmp slt i64 %r8, %r9, !dbg !205
  %r10 = zext i1 %r10.cmp to i64, !dbg !205
  %br_while_body41 = icmp ne i64 %r10, 0, !dbg !205
  br i1 %br_while_body41, label %while_body4, label %while_exit5, !prof !90, !dbg !205
while_body4:
  %r11 = load i64, ptr %slot.i, align 8, !dbg !206
  %r12 = add i64 0, 0, !dbg !206
  %r13.cmp = icmp sgt i64 %r11, %r12, !dbg !206
  %r13 = zext i1 %r13.cmp to i64, !dbg !206
  %br_then62 = icmp ne i64 %r13, 0, !dbg !206
  br i1 %br_then62, label %then6, label %else7, !dbg !206
then6:
  %r14 = load i64, ptr %slot.out, align 8, !dbg !207
  %r15 = load i64, ptr %slot.sep, align 8, !dbg !207
  %r16 = call i64 @nova_rt_str_concat(i64 %r14, i64 %r15), !dbg !207
  store i64 %r16, ptr %slot.out, align 8, !dbg !207
  br label %endif8, !dbg !207
else7:
  br label %endif8, !dbg !207
endif8:
  %r17 = load i64, ptr %slot.out, align 8, !dbg !208
  %r18 = load i64, ptr %slot.items__s4f54, align 8, !dbg !208
  %r19 = load i64, ptr %slot.i, align 8, !dbg !208
  %r20 = call i64 @nova_rt_list_get_f(i64 %r18, i64 %r19), !dbg !208
  %r21 = call i64 @nova_rt_str_concat(i64 %r17, i64 %r20), !dbg !208
  store i64 %r21, ptr %slot.out, align 8, !dbg !208
  %r22 = load i64, ptr %slot.i, align 8, !dbg !209
  %r23 = add i64 1, 0, !dbg !209
  %r24 = add i64 %r22, %r23, !dbg !209
  store i64 %r24, ptr %slot.i, align 8, !dbg !209
  br label %while_hdr3, !dbg !209
while_exit5:
  br label %endif2, !dbg !209
else1:
  br label %while_hdr9, !dbg !205
while_hdr9:
  %r25 = load i64, ptr %slot.i, align 8, !dbg !205
  %r26 = load i64, ptr %slot.n, align 8, !dbg !205
  %r27.cmp = icmp slt i64 %r25, %r26, !dbg !205
  %r27 = zext i1 %r27.cmp to i64, !dbg !205
  %br_while_body103 = icmp ne i64 %r27, 0, !dbg !205
  br i1 %br_while_body103, label %while_body10, label %while_exit11, !prof !90, !dbg !205
while_body10:
  %r28 = load i64, ptr %slot.i, align 8, !dbg !206
  %r29 = add i64 0, 0, !dbg !206
  %r30.cmp = icmp sgt i64 %r28, %r29, !dbg !206
  %r30 = zext i1 %r30.cmp to i64, !dbg !206
  %br_then124 = icmp ne i64 %r30, 0, !dbg !206
  br i1 %br_then124, label %then12, label %else13, !dbg !206
then12:
  %r31 = load i64, ptr %slot.out, align 8, !dbg !207
  %r32 = load i64, ptr %slot.sep, align 8, !dbg !207
  %r33 = call i64 @nova_rt_str_concat(i64 %r31, i64 %r32), !dbg !207
  store i64 %r33, ptr %slot.out, align 8, !dbg !207
  br label %endif14, !dbg !207
else13:
  br label %endif14, !dbg !207
endif14:
  %r34 = load i64, ptr %slot.out, align 8, !dbg !208
  %r35 = load i64, ptr %slot.items, align 8, !dbg !208
  %r36 = load i64, ptr %slot.i, align 8, !dbg !208
  %r37 = call i64 @nova_rt_index_get(i64 %r35, i64 %r36), !dbg !208
  %r38 = call i64 @nova_rt_str_concat(i64 %r34, i64 %r37), !dbg !208
  store i64 %r38, ptr %slot.out, align 8, !dbg !208
  %r39 = load i64, ptr %slot.i, align 8, !dbg !209
  %r40 = add i64 1, 0, !dbg !209
  %r41 = add i64 %r39, %r40, !dbg !209
  store i64 %r41, ptr %slot.i, align 8, !dbg !209
  br label %while_hdr9, !dbg !209
while_exit11:
  br label %endif2, !dbg !209
endif2:
  %r42 = load i64, ptr %slot.out, align 8, !dbg !210
  ret i64 %r42, !dbg !210
}

; ESCAPE qb_select: allocs=2 escape=2 local=0
define i64 @qb_select(i64 %p0, i64 %p1) nounwind uwtable !dbg !211 {
entry:
  %slot.table = alloca i64, align 8, !dbg !212
  store i64 %p0, ptr %slot.table, align 8, !dbg !212
  %slot.columns = alloca i64, align 8, !dbg !212
  store i64 %p1, ptr %slot.columns, align 8, !dbg !212
  %slot.q = alloca i64, align 8, !dbg !212
  store i64 0, ptr %slot.q, align 8, !dbg !212
  %r0 = call i64 @nova_rt_dict_create(), !dbg !213
  store i64 %r0, ptr %slot.q, align 8, !dbg !213
  %r1.p = getelementptr inbounds [7 x i8], ptr @.str.1, i64 0, i64 0, !dbg !214
  %r1 = ptrtoint ptr %r1.p to i64, !dbg !214
  %r2 = add i64 %r0, 0, !dbg !214
  %r3.p = getelementptr inbounds [5 x i8], ptr @.str.2, i64 0, i64 0, !dbg !214
  %r3 = ptrtoint ptr %r3.p to i64, !dbg !214
  %_is.dv0 = call i64 @nova_rt_dict_set(i64 %r2, i64 %r3, i64 %r1), !dbg !214
  %r4 = load i64, ptr %slot.table, align 8, !dbg !215
  %r5 = add i64 %r0, 0, !dbg !215
  %r6.p = getelementptr inbounds [6 x i8], ptr @.str.3, i64 0, i64 0, !dbg !215
  %r6 = ptrtoint ptr %r6.p to i64, !dbg !215
  %_is.dv1 = call i64 @nova_rt_dict_set(i64 %r5, i64 %r6, i64 %r4), !dbg !215
  %r7 = load i64, ptr %slot.columns, align 8, !dbg !216
  %r8 = add i64 %r0, 0, !dbg !216
  %r9.p = getelementptr inbounds [8 x i8], ptr @.str.4, i64 0, i64 0, !dbg !216
  %r9 = ptrtoint ptr %r9.p to i64, !dbg !216
  %_is.dv2 = call i64 @nova_rt_dict_set(i64 %r8, i64 %r9, i64 %r7), !dbg !216
  %r10 = call i64 @nova_rt_list_create(), !dbg !217
  %r11 = add i64 %r0, 0, !dbg !217
  %r12.p = getelementptr inbounds [6 x i8], ptr @.str.5, i64 0, i64 0, !dbg !217
  %r12 = ptrtoint ptr %r12.p to i64, !dbg !217
  %_is.dv3 = call i64 @nova_rt_dict_set(i64 %r11, i64 %r12, i64 %r10), !dbg !217
  %r13.p = getelementptr inbounds [1 x i8], ptr @.str.0, i64 0, i64 0, !dbg !218
  %r13 = ptrtoint ptr %r13.p to i64, !dbg !218
  %r14 = add i64 %r0, 0, !dbg !218
  %r15.p = getelementptr inbounds [10 x i8], ptr @.str.6, i64 0, i64 0, !dbg !218
  %r15 = ptrtoint ptr %r15.p to i64, !dbg !218
  %_is.dv4 = call i64 @nova_rt_dict_set(i64 %r14, i64 %r15, i64 %r13), !dbg !218
  %r16.p = getelementptr inbounds [1 x i8], ptr @.str.0, i64 0, i64 0, !dbg !219
  %r16 = ptrtoint ptr %r16.p to i64, !dbg !219
  %r17 = add i64 %r0, 0, !dbg !219
  %r18.p = getelementptr inbounds [10 x i8], ptr @.str.7, i64 0, i64 0, !dbg !219
  %r18 = ptrtoint ptr %r18.p to i64, !dbg !219
  %_is.dv5 = call i64 @nova_rt_dict_set(i64 %r17, i64 %r18, i64 %r16), !dbg !219
  %r20 = add i64 -1, 0, !dbg !220
  %r21 = add i64 %r0, 0, !dbg !220
  %r22.p = getelementptr inbounds [6 x i8], ptr @.str.8, i64 0, i64 0, !dbg !220
  %r22 = ptrtoint ptr %r22.p to i64, !dbg !220
  %_is.dv6 = call i64 @nova_rt_dict_set(i64 %r21, i64 %r22, i64 %r20), !dbg !220
  %r23 = add i64 %r0, 0, !dbg !221
  ret i64 %r23, !dbg !221
}

; ESCAPE qb_where: allocs=0 escape=0 local=0
define i64 @qb_where(i64 %p0, i64 %p1) nounwind uwtable !dbg !222 {
entry:
  %slot.query = alloca i64, align 8, !dbg !223
  store i64 %p0, ptr %slot.query, align 8, !dbg !223
  %slot.condition = alloca i64, align 8, !dbg !223
  store i64 %p1, ptr %slot.condition, align 8, !dbg !223
  %slot.w = alloca i64, align 8, !dbg !223
  store i64 0, ptr %slot.w, align 8, !dbg !223
  %r0 = load i64, ptr %slot.query, align 8, !dbg !224
  %r1.p = getelementptr inbounds [5 x i8], ptr @.str.2, i64 0, i64 0, !dbg !224
  %r1 = ptrtoint ptr %r1.p to i64, !dbg !224
  %r2 = call i64 @nova_rt_index_get(i64 %r0, i64 %r1), !dbg !224
  %r3.p = getelementptr inbounds [7 x i8], ptr @.str.1, i64 0, i64 0, !dbg !224
  %r3 = ptrtoint ptr %r3.p to i64, !dbg !224
  %r4 = call i64 @nova_rt_eq(i64 %r2, i64 %r3), !dbg !224
  %br_then150 = icmp ne i64 %r4, 0, !dbg !224
  br i1 %br_then150, label %then15, label %else16, !dbg !224
then15:
  %r5 = load i64, ptr %slot.query, align 8, !dbg !225
  %r6.p = getelementptr inbounds [6 x i8], ptr @.str.5, i64 0, i64 0, !dbg !225
  %r6 = ptrtoint ptr %r6.p to i64, !dbg !225
  %r7 = call i64 @nova_rt_index_get(i64 %r5, i64 %r6), !dbg !225
  store i64 %r7, ptr %slot.w, align 8, !dbg !225
  %r8 = add i64 %r7, 0, !dbg !226
  %r9 = load i64, ptr %slot.condition, align 8, !dbg !226
  %r10 = call i64 @nova_rt_list_append(i64 %r8, i64 %r9), !dbg !226
  br label %endif17, !dbg !226
else16:
  br label %endif17, !dbg !226
endif17:
  %r11 = load i64, ptr %slot.query, align 8, !dbg !227
  ret i64 %r11, !dbg !227
}

; ESCAPE qb_order_by: allocs=0 escape=0 local=0
define i64 @qb_order_by(i64 %p0, i64 %p1, i64 %p2) nounwind uwtable !dbg !228 {
entry:
  %slot.query = alloca i64, align 8, !dbg !229
  store i64 %p0, ptr %slot.query, align 8, !dbg !229
  %slot.column = alloca i64, align 8, !dbg !229
  store i64 %p1, ptr %slot.column, align 8, !dbg !229
  %slot.direction = alloca i64, align 8, !dbg !229
  store i64 %p2, ptr %slot.direction, align 8, !dbg !229
  %r0 = load i64, ptr %slot.query, align 8, !dbg !230
  %r1.p = getelementptr inbounds [5 x i8], ptr @.str.2, i64 0, i64 0, !dbg !230
  %r1 = ptrtoint ptr %r1.p to i64, !dbg !230
  %r2 = call i64 @nova_rt_index_get(i64 %r0, i64 %r1), !dbg !230
  %r3.p = getelementptr inbounds [7 x i8], ptr @.str.1, i64 0, i64 0, !dbg !230
  %r3 = ptrtoint ptr %r3.p to i64, !dbg !230
  %r4 = call i64 @nova_rt_eq(i64 %r2, i64 %r3), !dbg !230
  %br_then180 = icmp ne i64 %r4, 0, !dbg !230
  br i1 %br_then180, label %then18, label %else19, !dbg !230
then18:
  %r5 = load i64, ptr %slot.column, align 8, !dbg !231
  %r6 = load i64, ptr %slot.query, align 8, !dbg !231
  %r7.p = getelementptr inbounds [10 x i8], ptr @.str.6, i64 0, i64 0, !dbg !231
  %r7 = ptrtoint ptr %r7.p to i64, !dbg !231
  %_is.gv1 = call i64 @nova_rt_index_set(i64 %r6, i64 %r7, i64 %r5), !dbg !231
  %r8 = load i64, ptr %slot.direction, align 8, !dbg !232
  %r9 = load i64, ptr %slot.query, align 8, !dbg !232
  %r10.p = getelementptr inbounds [10 x i8], ptr @.str.7, i64 0, i64 0, !dbg !232
  %r10 = ptrtoint ptr %r10.p to i64, !dbg !232
  %_is.gv2 = call i64 @nova_rt_index_set(i64 %r9, i64 %r10, i64 %r8), !dbg !232
  br label %endif20, !dbg !232
else19:
  br label %endif20, !dbg !232
endif20:
  %r11 = load i64, ptr %slot.query, align 8, !dbg !233
  ret i64 %r11, !dbg !233
}

; ESCAPE qb_limit: allocs=0 escape=0 local=0
define i64 @qb_limit(i64 %p0, i64 %p1) nounwind uwtable !dbg !234 {
entry:
  %slot.query = alloca i64, align 8, !dbg !235
  store i64 %p0, ptr %slot.query, align 8, !dbg !235
  %slot.n = alloca i64, align 8, !dbg !235
  store i64 %p1, ptr %slot.n, align 8, !dbg !235
  %r0 = load i64, ptr %slot.query, align 8, !dbg !236
  %r1.p = getelementptr inbounds [5 x i8], ptr @.str.2, i64 0, i64 0, !dbg !236
  %r1 = ptrtoint ptr %r1.p to i64, !dbg !236
  %r2 = call i64 @nova_rt_index_get(i64 %r0, i64 %r1), !dbg !236
  %r3.p = getelementptr inbounds [7 x i8], ptr @.str.1, i64 0, i64 0, !dbg !236
  %r3 = ptrtoint ptr %r3.p to i64, !dbg !236
  %r4 = call i64 @nova_rt_eq(i64 %r2, i64 %r3), !dbg !236
  %br_then210 = icmp ne i64 %r4, 0, !dbg !236
  br i1 %br_then210, label %then21, label %else22, !dbg !236
then21:
  %r5 = load i64, ptr %slot.n, align 8, !dbg !237
  %r6 = load i64, ptr %slot.query, align 8, !dbg !237
  %r7.p = getelementptr inbounds [6 x i8], ptr @.str.8, i64 0, i64 0, !dbg !237
  %r7 = ptrtoint ptr %r7.p to i64, !dbg !237
  %_is.gv1 = call i64 @nova_rt_index_set(i64 %r6, i64 %r7, i64 %r5), !dbg !237
  br label %endif23, !dbg !237
else22:
  br label %endif23, !dbg !237
endif23:
  %r8 = load i64, ptr %slot.query, align 8, !dbg !238
  ret i64 %r8, !dbg !238
}

; ESCAPE _qb_build_select: allocs=0 escape=0 local=0
define i64 @_qb_build_select(i64 %p0) nounwind uwtable !dbg !239 {
entry:
  %slot.query = alloca i64, align 8, !dbg !240
  store i64 %p0, ptr %slot.query, align 8, !dbg !240
  %slot.columns = alloca i64, align 8, !dbg !240
  store i64 0, ptr %slot.columns, align 8, !dbg !240
  %slot.col_sql = alloca i64, align 8, !dbg !240
  store i64 0, ptr %slot.col_sql, align 8, !dbg !240
  %slot.sql = alloca i64, align 8, !dbg !240
  store i64 0, ptr %slot.sql, align 8, !dbg !240
  %slot.w = alloca i64, align 8, !dbg !240
  store i64 0, ptr %slot.w, align 8, !dbg !240
  %r0 = load i64, ptr %slot.query, align 8, !dbg !241
  %r1.p = getelementptr inbounds [8 x i8], ptr @.str.4, i64 0, i64 0, !dbg !241
  %r1 = ptrtoint ptr %r1.p to i64, !dbg !241
  %r2 = call i64 @nova_rt_index_get(i64 %r0, i64 %r1), !dbg !241
  store i64 %r2, ptr %slot.columns, align 8, !dbg !241
  %r3.p = getelementptr inbounds [2 x i8], ptr @.str.9, i64 0, i64 0, !dbg !242
  %r3 = ptrtoint ptr %r3.p to i64, !dbg !242
  store i64 %r3, ptr %slot.col_sql, align 8, !dbg !242
  %r4 = add i64 %r2, 0, !dbg !243
  %r5 = call i64 @nova_rt_len_any(i64 %r4), !dbg !243
  %r6 = add i64 0, 0, !dbg !243
  %r7.cmp = icmp sgt i64 %r5, %r6, !dbg !243
  %r7 = zext i1 %r7.cmp to i64, !dbg !243
  %br_then240 = icmp ne i64 %r7, 0, !dbg !243
  br i1 %br_then240, label %then24, label %else25, !dbg !243
then24:
  %r8 = load i64, ptr %slot.columns, align 8, !dbg !244
  %r9.p = getelementptr inbounds [3 x i8], ptr @.str.10, i64 0, i64 0, !dbg !244
  %r9 = ptrtoint ptr %r9.p to i64, !dbg !244
  %r10 = call i64 @_qb_join(i64 %r8, i64 %r9), !dbg !244
  store i64 %r10, ptr %slot.col_sql, align 8, !dbg !244
  br label %endif26, !dbg !244
else25:
  br label %endif26, !dbg !244
endif26:
  %r11.p = getelementptr inbounds [8 x i8], ptr @.str.11, i64 0, i64 0, !dbg !245
  %r11 = ptrtoint ptr %r11.p to i64, !dbg !245
  %r12 = load i64, ptr %slot.col_sql, align 8, !dbg !245
  %r13 = call i64 @nova_rt_str_concat(i64 %r11, i64 %r12), !dbg !245
  %r14.p = getelementptr inbounds [7 x i8], ptr @.str.12, i64 0, i64 0, !dbg !245
  %r14 = ptrtoint ptr %r14.p to i64, !dbg !245
  %r15 = call i64 @nova_rt_str_concat(i64 %r13, i64 %r14), !dbg !245
  %r16 = load i64, ptr %slot.query, align 8, !dbg !245
  %r17.p = getelementptr inbounds [6 x i8], ptr @.str.3, i64 0, i64 0, !dbg !245
  %r17 = ptrtoint ptr %r17.p to i64, !dbg !245
  %r18 = call i64 @nova_rt_index_get(i64 %r16, i64 %r17), !dbg !245
  %r19 = call i64 @nova_rt_str_concat(i64 %r15, i64 %r18), !dbg !245
  store i64 %r19, ptr %slot.sql, align 8, !dbg !245
  %r20 = load i64, ptr %slot.query, align 8, !dbg !246
  %r21.p = getelementptr inbounds [6 x i8], ptr @.str.5, i64 0, i64 0, !dbg !246
  %r21 = ptrtoint ptr %r21.p to i64, !dbg !246
  %r22 = call i64 @nova_rt_index_get(i64 %r20, i64 %r21), !dbg !246
  store i64 %r22, ptr %slot.w, align 8, !dbg !246
  %r23 = add i64 %r22, 0, !dbg !247
  %r24 = call i64 @nova_rt_len_any(i64 %r23), !dbg !247
  %r25 = add i64 0, 0, !dbg !247
  %r26.cmp = icmp sgt i64 %r24, %r25, !dbg !247
  %r26 = zext i1 %r26.cmp to i64, !dbg !247
  %br_then271 = icmp ne i64 %r26, 0, !dbg !247
  br i1 %br_then271, label %then27, label %else28, !dbg !247
then27:
  %r27 = load i64, ptr %slot.sql, align 8, !dbg !248
  %r28.p = getelementptr inbounds [8 x i8], ptr @.str.13, i64 0, i64 0, !dbg !248
  %r28 = ptrtoint ptr %r28.p to i64, !dbg !248
  %r29 = call i64 @nova_rt_str_concat(i64 %r27, i64 %r28), !dbg !248
  %r30 = load i64, ptr %slot.w, align 8, !dbg !248
  %r31.p = getelementptr inbounds [6 x i8], ptr @.str.14, i64 0, i64 0, !dbg !248
  %r31 = ptrtoint ptr %r31.p to i64, !dbg !248
  %r32 = call i64 @_qb_join(i64 %r30, i64 %r31), !dbg !248
  %r33 = call i64 @nova_rt_str_concat(i64 %r29, i64 %r32), !dbg !248
  store i64 %r33, ptr %slot.sql, align 8, !dbg !248
  br label %endif29, !dbg !248
else28:
  br label %endif29, !dbg !248
endif29:
  %r34 = load i64, ptr %slot.query, align 8, !dbg !249
  %r35.p = getelementptr inbounds [10 x i8], ptr @.str.6, i64 0, i64 0, !dbg !249
  %r35 = ptrtoint ptr %r35.p to i64, !dbg !249
  %r36 = call i64 @nova_rt_index_get(i64 %r34, i64 %r35), !dbg !249
  %r37 = call i64 @nova_rt_len_any(i64 %r36), !dbg !249
  %r38 = add i64 0, 0, !dbg !249
  %r39.cmp = icmp sgt i64 %r37, %r38, !dbg !249
  %r39 = zext i1 %r39.cmp to i64, !dbg !249
  %br_then302 = icmp ne i64 %r39, 0, !dbg !249
  br i1 %br_then302, label %then30, label %else31, !dbg !249
then30:
  %r40 = load i64, ptr %slot.sql, align 8, !dbg !250
  %r41.p = getelementptr inbounds [11 x i8], ptr @.str.15, i64 0, i64 0, !dbg !250
  %r41 = ptrtoint ptr %r41.p to i64, !dbg !250
  %r42 = call i64 @nova_rt_str_concat(i64 %r40, i64 %r41), !dbg !250
  %r43 = load i64, ptr %slot.query, align 8, !dbg !250
  %r44.p = getelementptr inbounds [10 x i8], ptr @.str.6, i64 0, i64 0, !dbg !250
  %r44 = ptrtoint ptr %r44.p to i64, !dbg !250
  %r45 = call i64 @nova_rt_index_get(i64 %r43, i64 %r44), !dbg !250
  %r46 = call i64 @nova_rt_str_concat(i64 %r42, i64 %r45), !dbg !250
  store i64 %r46, ptr %slot.sql, align 8, !dbg !250
  %r47 = load i64, ptr %slot.query, align 8, !dbg !251
  %r48.p = getelementptr inbounds [10 x i8], ptr @.str.7, i64 0, i64 0, !dbg !251
  %r48 = ptrtoint ptr %r48.p to i64, !dbg !251
  %r49 = call i64 @nova_rt_index_get(i64 %r47, i64 %r48), !dbg !251
  %r50 = call i64 @nova_rt_len_any(i64 %r49), !dbg !251
  %r51 = add i64 0, 0, !dbg !251
  %r52.cmp = icmp sgt i64 %r50, %r51, !dbg !251
  %r52 = zext i1 %r52.cmp to i64, !dbg !251
  %br_then333 = icmp ne i64 %r52, 0, !dbg !251
  br i1 %br_then333, label %then33, label %else34, !dbg !251
then33:
  %r53 = load i64, ptr %slot.sql, align 8, !dbg !252
  %r54.p = getelementptr inbounds [2 x i8], ptr @.str.16, i64 0, i64 0, !dbg !252
  %r54 = ptrtoint ptr %r54.p to i64, !dbg !252
  %r55 = call i64 @nova_rt_str_concat(i64 %r53, i64 %r54), !dbg !252
  %r56 = load i64, ptr %slot.query, align 8, !dbg !252
  %r57.p = getelementptr inbounds [10 x i8], ptr @.str.7, i64 0, i64 0, !dbg !252
  %r57 = ptrtoint ptr %r57.p to i64, !dbg !252
  %r58 = call i64 @nova_rt_index_get(i64 %r56, i64 %r57), !dbg !252
  %r59 = call i64 @nova_rt_str_concat(i64 %r55, i64 %r58), !dbg !252
  store i64 %r59, ptr %slot.sql, align 8, !dbg !252
  br label %endif35, !dbg !252
else34:
  br label %endif35, !dbg !252
endif35:
  br label %endif32, !dbg !252
else31:
  br label %endif32, !dbg !252
endif32:
  %r60 = load i64, ptr %slot.query, align 8, !dbg !253
  %r61.p = getelementptr inbounds [6 x i8], ptr @.str.8, i64 0, i64 0, !dbg !253
  %r61 = ptrtoint ptr %r61.p to i64, !dbg !253
  %r62 = call i64 @nova_rt_index_get(i64 %r60, i64 %r61), !dbg !253
  %r63 = add i64 0, 0, !dbg !253
  %r64 = call i64 @nova_rt_ge(i64 %r62, i64 %r63), !dbg !253
  %br_then364 = icmp ne i64 %r64, 0, !dbg !253
  br i1 %br_then364, label %then36, label %else37, !dbg !253
then36:
  %r65 = load i64, ptr %slot.sql, align 8, !dbg !254
  %r66.p = getelementptr inbounds [8 x i8], ptr @.str.17, i64 0, i64 0, !dbg !254
  %r66 = ptrtoint ptr %r66.p to i64, !dbg !254
  %r67 = call i64 @nova_rt_str_concat(i64 %r65, i64 %r66), !dbg !254
  %r68 = load i64, ptr %slot.query, align 8, !dbg !254
  %r69.p = getelementptr inbounds [6 x i8], ptr @.str.8, i64 0, i64 0, !dbg !254
  %r69 = ptrtoint ptr %r69.p to i64, !dbg !254
  %r70 = call i64 @nova_rt_index_get(i64 %r68, i64 %r69), !dbg !254
  %r71 = call i64 @nova_rt_any_to_str(i64 %r70), !dbg !254
  %r72 = call i64 @nova_rt_str_concat(i64 %r67, i64 %r71), !dbg !254
  store i64 %r72, ptr %slot.sql, align 8, !dbg !254
  br label %endif38, !dbg !254
else37:
  br label %endif38, !dbg !254
endif38:
  %r73 = load i64, ptr %slot.sql, align 8, !dbg !255
  ret i64 %r73, !dbg !255
}

; ESCAPE _qb_build_insert: allocs=0 escape=0 local=0
define i64 @_qb_build_insert(i64 %p0) nounwind uwtable !dbg !256 {
entry:
  %slot.query = alloca i64, align 8, !dbg !257
  store i64 %p0, ptr %slot.query, align 8, !dbg !257
  %slot.columns = alloca i64, align 8, !dbg !257
  store i64 0, ptr %slot.columns, align 8, !dbg !257
  %slot.values = alloca i64, align 8, !dbg !257
  store i64 0, ptr %slot.values, align 8, !dbg !257
  %slot.sql = alloca i64, align 8, !dbg !257
  store i64 0, ptr %slot.sql, align 8, !dbg !257
  %r0 = load i64, ptr %slot.query, align 8, !dbg !258
  %r1.p = getelementptr inbounds [8 x i8], ptr @.str.4, i64 0, i64 0, !dbg !258
  %r1 = ptrtoint ptr %r1.p to i64, !dbg !258
  %r2 = call i64 @nova_rt_index_get(i64 %r0, i64 %r1), !dbg !258
  store i64 %r2, ptr %slot.columns, align 8, !dbg !258
  %r3 = load i64, ptr %slot.query, align 8, !dbg !259
  %r4.p = getelementptr inbounds [7 x i8], ptr @.str.18, i64 0, i64 0, !dbg !259
  %r4 = ptrtoint ptr %r4.p to i64, !dbg !259
  %r5 = call i64 @nova_rt_index_get(i64 %r3, i64 %r4), !dbg !259
  store i64 %r5, ptr %slot.values, align 8, !dbg !259
  %r6.p = getelementptr inbounds [13 x i8], ptr @.str.19, i64 0, i64 0, !dbg !260
  %r6 = ptrtoint ptr %r6.p to i64, !dbg !260
  %r7 = load i64, ptr %slot.query, align 8, !dbg !260
  %r8.p = getelementptr inbounds [6 x i8], ptr @.str.3, i64 0, i64 0, !dbg !260
  %r8 = ptrtoint ptr %r8.p to i64, !dbg !260
  %r9 = call i64 @nova_rt_index_get(i64 %r7, i64 %r8), !dbg !260
  %r10 = call i64 @nova_rt_str_concat(i64 %r6, i64 %r9), !dbg !260
  store i64 %r10, ptr %slot.sql, align 8, !dbg !260
  %r11 = add i64 %r10, 0, !dbg !261
  %r12.p = getelementptr inbounds [3 x i8], ptr @.str.20, i64 0, i64 0, !dbg !261
  %r12 = ptrtoint ptr %r12.p to i64, !dbg !261
  %r13 = call i64 @nova_rt_str_concat(i64 %r11, i64 %r12), !dbg !261
  %r14 = add i64 %r2, 0, !dbg !261
  %r15.p = getelementptr inbounds [3 x i8], ptr @.str.10, i64 0, i64 0, !dbg !261
  %r15 = ptrtoint ptr %r15.p to i64, !dbg !261
  %r16 = call i64 @_qb_join(i64 %r14, i64 %r15), !dbg !261
  %r17 = call i64 @nova_rt_str_concat(i64 %r13, i64 %r16), !dbg !261
  %r18.p = getelementptr inbounds [2 x i8], ptr @.str.21, i64 0, i64 0, !dbg !261
  %r18 = ptrtoint ptr %r18.p to i64, !dbg !261
  %r19 = call i64 @nova_rt_str_concat(i64 %r17, i64 %r18), !dbg !261
  store i64 %r19, ptr %slot.sql, align 8, !dbg !261
  %r20 = add i64 %r19, 0, !dbg !262
  %r21.p = getelementptr inbounds [10 x i8], ptr @.str.22, i64 0, i64 0, !dbg !262
  %r21 = ptrtoint ptr %r21.p to i64, !dbg !262
  %r22 = call i64 @nova_rt_str_concat(i64 %r20, i64 %r21), !dbg !262
  %r23 = add i64 %r5, 0, !dbg !262
  %r24.p = getelementptr inbounds [3 x i8], ptr @.str.10, i64 0, i64 0, !dbg !262
  %r24 = ptrtoint ptr %r24.p to i64, !dbg !262
  %r25 = call i64 @_qb_join(i64 %r23, i64 %r24), !dbg !262
  %r26 = call i64 @nova_rt_str_concat(i64 %r22, i64 %r25), !dbg !262
  %r27.p = getelementptr inbounds [2 x i8], ptr @.str.21, i64 0, i64 0, !dbg !262
  %r27 = ptrtoint ptr %r27.p to i64, !dbg !262
  %r28 = call i64 @nova_rt_str_concat(i64 %r26, i64 %r27), !dbg !262
  store i64 %r28, ptr %slot.sql, align 8, !dbg !262
  %r29 = add i64 %r28, 0, !dbg !263
  ret i64 %r29, !dbg !263
}

; ESCAPE _qb_build_update: allocs=1 escape=0 local=1
define i64 @_qb_build_update(i64 %p0) nounwind uwtable !dbg !264 {
entry:
  %slot.query = alloca i64, align 8, !dbg !265
  store i64 %p0, ptr %slot.query, align 8, !dbg !265
  %slot.sets = alloca i64, align 8, !dbg !265
  store i64 0, ptr %slot.sets, align 8, !dbg !265
  %slot.ks = alloca i64, align 8, !dbg !265
  store i64 0, ptr %slot.ks, align 8, !dbg !265
  %slot.n = alloca i64, align 8, !dbg !265
  store i64 0, ptr %slot.n, align 8, !dbg !265
  %slot.assigns = alloca i64, align 8, !dbg !265
  store i64 0, ptr %slot.assigns, align 8, !dbg !265
  %slot.i = alloca i64, align 8, !dbg !265
  store i64 0, ptr %slot.i, align 8, !dbg !265
  %slot.ks__s4f130 = alloca i64, align 8, !dbg !265
  store i64 0, ptr %slot.ks__s4f130, align 8, !dbg !265
  %slot.k__s4f130 = alloca i64, align 8, !dbg !265
  store i64 0, ptr %slot.k__s4f130, align 8, !dbg !265
  %slot.k = alloca i64, align 8, !dbg !265
  store i64 0, ptr %slot.k, align 8, !dbg !265
  %slot.sql = alloca i64, align 8, !dbg !265
  store i64 0, ptr %slot.sql, align 8, !dbg !265
  %slot.w = alloca i64, align 8, !dbg !265
  store i64 0, ptr %slot.w, align 8, !dbg !265
  %r0 = load i64, ptr %slot.query, align 8, !dbg !266
  %r1.p = getelementptr inbounds [5 x i8], ptr @.str.23, i64 0, i64 0, !dbg !266
  %r1 = ptrtoint ptr %r1.p to i64, !dbg !266
  %r2 = call i64 @nova_rt_index_get(i64 %r0, i64 %r1), !dbg !266
  store i64 %r2, ptr %slot.sets, align 8, !dbg !266
  %r3 = add i64 %r2, 0, !dbg !267
  %r4 = call i64 @nova_rt_dict_keys(i64 %r3), !dbg !267
  store i64 %r4, ptr %slot.ks, align 8, !dbg !267
  %r5 = add i64 %r4, 0, !dbg !268
  %r6.lp = inttoptr i64 %r5 to ptr, !dbg !268
  %r6.szp = getelementptr i64, ptr %r6.lp, i64 1, !dbg !268
  %r6 = load i64, ptr %r6.szp, align 8, !tbaa !6, !dbg !268
  store i64 %r6, ptr %slot.n, align 8, !dbg !268
  %r7 = call i64 @nova_rt_list_create(), !dbg !269
  store i64 %r7, ptr %slot.assigns, align 8, !dbg !269
  %r8 = add i64 0, 0, !dbg !270
  store i64 %r8, ptr %slot.i, align 8, !dbg !270
  %r9 = add i64 %r4, 0, !dbg !271
  %r10 = call i64 @nova_rt_list_is_kind2(i64 %r9), !dbg !271
  %br_then390 = icmp ne i64 %r10, 0, !dbg !271
  br i1 %br_then390, label %then39, label %else40, !dbg !271
then39:
  %r11 = load i64, ptr %slot.ks, align 8, !dbg !271
  %r12 = call i64 @nova_rt_floatlist_view(i64 %r11), !dbg !271
  store i64 %r12, ptr %slot.ks__s4f130, align 8, !dbg !271
  br label %while_hdr42, !dbg !271
while_hdr42:
  %r13 = load i64, ptr %slot.i, align 8, !dbg !271
  %r14 = load i64, ptr %slot.n, align 8, !dbg !271
  %r15.cmp = icmp slt i64 %r13, %r14, !dbg !271
  %r15 = zext i1 %r15.cmp to i64, !dbg !271
  %br_while_body431 = icmp ne i64 %r15, 0, !dbg !271
  br i1 %br_while_body431, label %while_body43, label %while_exit44, !prof !90, !dbg !271
while_body43:
  %r16 = load i64, ptr %slot.ks__s4f130, align 8, !dbg !272
  %r17 = load i64, ptr %slot.i, align 8, !dbg !272
  %r18 = call i64 @nova_rt_list_get_f(i64 %r16, i64 %r17), !dbg !272
  store i64 %r18, ptr %slot.k__s4f130, align 8, !dbg !272
  %r19 = load i64, ptr %slot.assigns, align 8, !dbg !273
  %r20 = add i64 %r18, 0, !dbg !273
  %r21.p = getelementptr inbounds [4 x i8], ptr @.str.24, i64 0, i64 0, !dbg !273
  %r21 = ptrtoint ptr %r21.p to i64, !dbg !273
  %r22 = call i64 @nova_rt_str_concat(i64 %r20, i64 %r21), !dbg !273
  %r23 = load i64, ptr %slot.sets, align 8, !dbg !273
  %r24 = add i64 %r18, 0, !dbg !273
  %r25 = call i64 @nova_rt_index_get(i64 %r23, i64 %r24), !dbg !273
  %r26 = call i64 @nova_rt_str_concat(i64 %r22, i64 %r25), !dbg !273
  %r27 = call i64 @nova_rt_list_append_no_rc(i64 %r19, i64 %r26), !dbg !273
  %r28 = load i64, ptr %slot.i, align 8, !dbg !274
  %r29 = add i64 1, 0, !dbg !274
  %r30 = add i64 %r28, %r29, !dbg !274
  store i64 %r30, ptr %slot.i, align 8, !dbg !274
  br label %while_hdr42, !dbg !274
while_exit44:
  br label %endif41, !dbg !274
else40:
  br label %while_hdr45, !dbg !271
while_hdr45:
  %r31 = load i64, ptr %slot.i, align 8, !dbg !271
  %r32 = load i64, ptr %slot.n, align 8, !dbg !271
  %r33.cmp = icmp slt i64 %r31, %r32, !dbg !271
  %r33 = zext i1 %r33.cmp to i64, !dbg !271
  %br_while_body462 = icmp ne i64 %r33, 0, !dbg !271
  br i1 %br_while_body462, label %while_body46, label %while_exit47, !prof !90, !dbg !271
while_body46:
  %r34 = load i64, ptr %slot.ks, align 8, !dbg !272
  %r35 = load i64, ptr %slot.i, align 8, !dbg !272
  %r36 = call i64 @nova_rt_index_get(i64 %r34, i64 %r35), !dbg !272
  store i64 %r36, ptr %slot.k, align 8, !dbg !272
  %r37 = load i64, ptr %slot.assigns, align 8, !dbg !273
  %r38 = add i64 %r36, 0, !dbg !273
  %r39.p = getelementptr inbounds [4 x i8], ptr @.str.24, i64 0, i64 0, !dbg !273
  %r39 = ptrtoint ptr %r39.p to i64, !dbg !273
  %r40 = call i64 @nova_rt_str_concat(i64 %r38, i64 %r39), !dbg !273
  %r41 = load i64, ptr %slot.sets, align 8, !dbg !273
  %r42 = add i64 %r36, 0, !dbg !273
  %r43 = call i64 @nova_rt_index_get(i64 %r41, i64 %r42), !dbg !273
  %r44 = call i64 @nova_rt_str_concat(i64 %r40, i64 %r43), !dbg !273
  %r45 = call i64 @nova_rt_list_append_no_rc(i64 %r37, i64 %r44), !dbg !273
  %r46 = load i64, ptr %slot.i, align 8, !dbg !274
  %r47 = add i64 1, 0, !dbg !274
  %r48 = add i64 %r46, %r47, !dbg !274
  store i64 %r48, ptr %slot.i, align 8, !dbg !274
  br label %while_hdr45, !dbg !274
while_exit47:
  br label %endif41, !dbg !274
endif41:
  %r49.p = getelementptr inbounds [8 x i8], ptr @.str.25, i64 0, i64 0, !dbg !275
  %r49 = ptrtoint ptr %r49.p to i64, !dbg !275
  %r50 = load i64, ptr %slot.query, align 8, !dbg !275
  %r51.p = getelementptr inbounds [6 x i8], ptr @.str.3, i64 0, i64 0, !dbg !275
  %r51 = ptrtoint ptr %r51.p to i64, !dbg !275
  %r52 = call i64 @nova_rt_index_get(i64 %r50, i64 %r51), !dbg !275
  %r53 = call i64 @nova_rt_str_concat(i64 %r49, i64 %r52), !dbg !275
  %r54.p = getelementptr inbounds [6 x i8], ptr @.str.26, i64 0, i64 0, !dbg !275
  %r54 = ptrtoint ptr %r54.p to i64, !dbg !275
  %r55 = call i64 @nova_rt_str_concat(i64 %r53, i64 %r54), !dbg !275
  %r56 = load i64, ptr %slot.assigns, align 8, !dbg !275
  %r57.p = getelementptr inbounds [3 x i8], ptr @.str.10, i64 0, i64 0, !dbg !275
  %r57 = ptrtoint ptr %r57.p to i64, !dbg !275
  %r58 = call i64 @_qb_join(i64 %r56, i64 %r57), !dbg !275
  %r59 = call i64 @nova_rt_str_concat(i64 %r55, i64 %r58), !dbg !275
  store i64 %r59, ptr %slot.sql, align 8, !dbg !275
  %r60 = load i64, ptr %slot.query, align 8, !dbg !276
  %r61.p = getelementptr inbounds [6 x i8], ptr @.str.5, i64 0, i64 0, !dbg !276
  %r61 = ptrtoint ptr %r61.p to i64, !dbg !276
  %r62 = call i64 @nova_rt_index_get(i64 %r60, i64 %r61), !dbg !276
  store i64 %r62, ptr %slot.w, align 8, !dbg !276
  %r63 = add i64 %r62, 0, !dbg !277
  %r64 = call i64 @nova_rt_len_any(i64 %r63), !dbg !277
  %r65 = add i64 0, 0, !dbg !277
  %r66.cmp = icmp sgt i64 %r64, %r65, !dbg !277
  %r66 = zext i1 %r66.cmp to i64, !dbg !277
  %br_then483 = icmp ne i64 %r66, 0, !dbg !277
  br i1 %br_then483, label %then48, label %else49, !dbg !277
then48:
  %r67 = load i64, ptr %slot.sql, align 8, !dbg !278
  %r68.p = getelementptr inbounds [8 x i8], ptr @.str.13, i64 0, i64 0, !dbg !278
  %r68 = ptrtoint ptr %r68.p to i64, !dbg !278
  %r69 = call i64 @nova_rt_str_concat(i64 %r67, i64 %r68), !dbg !278
  %r70 = load i64, ptr %slot.w, align 8, !dbg !278
  %r71 = call i64 @nova_rt_str_concat(i64 %r69, i64 %r70), !dbg !278
  store i64 %r71, ptr %slot.sql, align 8, !dbg !278
  br label %endif50, !dbg !278
else49:
  br label %endif50, !dbg !278
endif50:
  %r72 = load i64, ptr %slot.sql, align 8, !dbg !279
  ret i64 %r72, !dbg !279
}

; ESCAPE _qb_build_delete: allocs=0 escape=0 local=0
define i64 @_qb_build_delete(i64 %p0) nounwind uwtable !dbg !280 {
entry:
  %slot.query = alloca i64, align 8, !dbg !281
  store i64 %p0, ptr %slot.query, align 8, !dbg !281
  %slot.sql = alloca i64, align 8, !dbg !281
  store i64 0, ptr %slot.sql, align 8, !dbg !281
  %slot.w = alloca i64, align 8, !dbg !281
  store i64 0, ptr %slot.w, align 8, !dbg !281
  %r0.p = getelementptr inbounds [13 x i8], ptr @.str.27, i64 0, i64 0, !dbg !282
  %r0 = ptrtoint ptr %r0.p to i64, !dbg !282
  %r1 = load i64, ptr %slot.query, align 8, !dbg !282
  %r2.p = getelementptr inbounds [6 x i8], ptr @.str.3, i64 0, i64 0, !dbg !282
  %r2 = ptrtoint ptr %r2.p to i64, !dbg !282
  %r3 = call i64 @nova_rt_index_get(i64 %r1, i64 %r2), !dbg !282
  %r4 = call i64 @nova_rt_str_concat(i64 %r0, i64 %r3), !dbg !282
  store i64 %r4, ptr %slot.sql, align 8, !dbg !282
  %r5 = load i64, ptr %slot.query, align 8, !dbg !283
  %r6.p = getelementptr inbounds [6 x i8], ptr @.str.5, i64 0, i64 0, !dbg !283
  %r6 = ptrtoint ptr %r6.p to i64, !dbg !283
  %r7 = call i64 @nova_rt_index_get(i64 %r5, i64 %r6), !dbg !283
  store i64 %r7, ptr %slot.w, align 8, !dbg !283
  %r8 = add i64 %r7, 0, !dbg !284
  %r9 = call i64 @nova_rt_len_any(i64 %r8), !dbg !284
  %r10 = add i64 0, 0, !dbg !284
  %r11.cmp = icmp sgt i64 %r9, %r10, !dbg !284
  %r11 = zext i1 %r11.cmp to i64, !dbg !284
  %br_then510 = icmp ne i64 %r11, 0, !dbg !284
  br i1 %br_then510, label %then51, label %else52, !dbg !284
then51:
  %r12 = load i64, ptr %slot.sql, align 8, !dbg !285
  %r13.p = getelementptr inbounds [8 x i8], ptr @.str.13, i64 0, i64 0, !dbg !285
  %r13 = ptrtoint ptr %r13.p to i64, !dbg !285
  %r14 = call i64 @nova_rt_str_concat(i64 %r12, i64 %r13), !dbg !285
  %r15 = load i64, ptr %slot.w, align 8, !dbg !285
  %r16 = call i64 @nova_rt_str_concat(i64 %r14, i64 %r15), !dbg !285
  store i64 %r16, ptr %slot.sql, align 8, !dbg !285
  br label %endif53, !dbg !285
else52:
  br label %endif53, !dbg !285
endif53:
  %r17 = load i64, ptr %slot.sql, align 8, !dbg !286
  ret i64 %r17, !dbg !286
}

; ESCAPE qb_build: allocs=0 escape=0 local=0
define i64 @qb_build(i64 %p0) nounwind uwtable !dbg !287 {
entry:
  %slot.query = alloca i64, align 8, !dbg !288
  store i64 %p0, ptr %slot.query, align 8, !dbg !288
  %slot.kind = alloca i64, align 8, !dbg !288
  store i64 0, ptr %slot.kind, align 8, !dbg !288
  %r0 = load i64, ptr %slot.query, align 8, !dbg !289
  %r1.p = getelementptr inbounds [5 x i8], ptr @.str.2, i64 0, i64 0, !dbg !289
  %r1 = ptrtoint ptr %r1.p to i64, !dbg !289
  %r2 = call i64 @nova_rt_index_get(i64 %r0, i64 %r1), !dbg !289
  store i64 %r2, ptr %slot.kind, align 8, !dbg !289
  %r3 = add i64 %r2, 0, !dbg !290
  %r4.p = getelementptr inbounds [7 x i8], ptr @.str.1, i64 0, i64 0, !dbg !290
  %r4 = ptrtoint ptr %r4.p to i64, !dbg !290
  %r5 = call i64 @nova_rt_eq(i64 %r3, i64 %r4), !dbg !290
  %br_then540 = icmp ne i64 %r5, 0, !dbg !290
  br i1 %br_then540, label %then54, label %else55, !dbg !290
then54:
  %r6 = load i64, ptr %slot.query, align 8, !dbg !291
  %r7 = call i64 @_qb_build_select(i64 %r6), !dbg !291
  ret i64 %r7, !dbg !291
else55:
  br label %endif56, !dbg !291
endif56:
  %r8 = load i64, ptr %slot.kind, align 8, !dbg !292
  %r9.p = getelementptr inbounds [7 x i8], ptr @.str.28, i64 0, i64 0, !dbg !292
  %r9 = ptrtoint ptr %r9.p to i64, !dbg !292
  %r10 = call i64 @nova_rt_eq(i64 %r8, i64 %r9), !dbg !292
  %br_then571 = icmp ne i64 %r10, 0, !dbg !292
  br i1 %br_then571, label %then57, label %else58, !dbg !292
then57:
  %r11 = load i64, ptr %slot.query, align 8, !dbg !293
  %r12 = call i64 @_qb_build_insert(i64 %r11), !dbg !293
  ret i64 %r12, !dbg !293
else58:
  br label %endif59, !dbg !293
endif59:
  %r13 = load i64, ptr %slot.kind, align 8, !dbg !294
  %r14.p = getelementptr inbounds [7 x i8], ptr @.str.29, i64 0, i64 0, !dbg !294
  %r14 = ptrtoint ptr %r14.p to i64, !dbg !294
  %r15 = call i64 @nova_rt_eq(i64 %r13, i64 %r14), !dbg !294
  %br_then602 = icmp ne i64 %r15, 0, !dbg !294
  br i1 %br_then602, label %then60, label %else61, !dbg !294
then60:
  %r16 = load i64, ptr %slot.query, align 8, !dbg !295
  %r17 = call i64 @_qb_build_update(i64 %r16), !dbg !295
  ret i64 %r17, !dbg !295
else61:
  br label %endif62, !dbg !295
endif62:
  %r18 = load i64, ptr %slot.kind, align 8, !dbg !296
  %r19.p = getelementptr inbounds [7 x i8], ptr @.str.30, i64 0, i64 0, !dbg !296
  %r19 = ptrtoint ptr %r19.p to i64, !dbg !296
  %r20 = call i64 @nova_rt_eq(i64 %r18, i64 %r19), !dbg !296
  %br_then633 = icmp ne i64 %r20, 0, !dbg !296
  br i1 %br_then633, label %then63, label %else64, !dbg !296
then63:
  %r21 = load i64, ptr %slot.query, align 8, !dbg !297
  %r22 = call i64 @_qb_build_delete(i64 %r21), !dbg !297
  ret i64 %r22, !dbg !297
else64:
  br label %endif65, !dbg !297
endif65:
  %r23.p = getelementptr inbounds [1 x i8], ptr @.str.0, i64 0, i64 0, !dbg !298
  %r23 = ptrtoint ptr %r23.p to i64, !dbg !298
  ret i64 %r23, !dbg !298
}

; ESCAPE qb_insert: allocs=1 escape=1 local=0
define i64 @qb_insert(i64 %p0, i64 %p1, i64 %p2) nounwind uwtable !dbg !299 {
entry:
  %slot.table = alloca i64, align 8, !dbg !300
  store i64 %p0, ptr %slot.table, align 8, !dbg !300
  %slot.columns = alloca i64, align 8, !dbg !300
  store i64 %p1, ptr %slot.columns, align 8, !dbg !300
  %slot.values = alloca i64, align 8, !dbg !300
  store i64 %p2, ptr %slot.values, align 8, !dbg !300
  %slot.q = alloca i64, align 8, !dbg !300
  store i64 0, ptr %slot.q, align 8, !dbg !300
  %r0 = call i64 @nova_rt_dict_create(), !dbg !301
  store i64 %r0, ptr %slot.q, align 8, !dbg !301
  %r1.p = getelementptr inbounds [7 x i8], ptr @.str.28, i64 0, i64 0, !dbg !302
  %r1 = ptrtoint ptr %r1.p to i64, !dbg !302
  %r2 = add i64 %r0, 0, !dbg !302
  %r3.p = getelementptr inbounds [5 x i8], ptr @.str.2, i64 0, i64 0, !dbg !302
  %r3 = ptrtoint ptr %r3.p to i64, !dbg !302
  %_is.dv0 = call i64 @nova_rt_dict_set(i64 %r2, i64 %r3, i64 %r1), !dbg !302
  %r4 = load i64, ptr %slot.table, align 8, !dbg !303
  %r5 = add i64 %r0, 0, !dbg !303
  %r6.p = getelementptr inbounds [6 x i8], ptr @.str.3, i64 0, i64 0, !dbg !303
  %r6 = ptrtoint ptr %r6.p to i64, !dbg !303
  %_is.dv1 = call i64 @nova_rt_dict_set(i64 %r5, i64 %r6, i64 %r4), !dbg !303
  %r7 = load i64, ptr %slot.columns, align 8, !dbg !304
  %r8 = add i64 %r0, 0, !dbg !304
  %r9.p = getelementptr inbounds [8 x i8], ptr @.str.4, i64 0, i64 0, !dbg !304
  %r9 = ptrtoint ptr %r9.p to i64, !dbg !304
  %_is.dv2 = call i64 @nova_rt_dict_set(i64 %r8, i64 %r9, i64 %r7), !dbg !304
  %r10 = load i64, ptr %slot.values, align 8, !dbg !305
  %r11 = add i64 %r0, 0, !dbg !305
  %r12.p = getelementptr inbounds [7 x i8], ptr @.str.18, i64 0, i64 0, !dbg !305
  %r12 = ptrtoint ptr %r12.p to i64, !dbg !305
  %_is.dv3 = call i64 @nova_rt_dict_set(i64 %r11, i64 %r12, i64 %r10), !dbg !305
  %r13 = add i64 %r0, 0, !dbg !306
  ret i64 %r13, !dbg !306
}

; ESCAPE qb_update: allocs=1 escape=1 local=0
define i64 @qb_update(i64 %p0, i64 %p1, i64 %p2) nounwind uwtable !dbg !307 {
entry:
  %slot.table = alloca i64, align 8, !dbg !308
  store i64 %p0, ptr %slot.table, align 8, !dbg !308
  %slot.sets = alloca i64, align 8, !dbg !308
  store i64 %p1, ptr %slot.sets, align 8, !dbg !308
  %slot.where_clause = alloca i64, align 8, !dbg !308
  store i64 %p2, ptr %slot.where_clause, align 8, !dbg !308
  %slot.q = alloca i64, align 8, !dbg !308
  store i64 0, ptr %slot.q, align 8, !dbg !308
  %r0 = call i64 @nova_rt_dict_create(), !dbg !309
  store i64 %r0, ptr %slot.q, align 8, !dbg !309
  %r1.p = getelementptr inbounds [7 x i8], ptr @.str.29, i64 0, i64 0, !dbg !310
  %r1 = ptrtoint ptr %r1.p to i64, !dbg !310
  %r2 = add i64 %r0, 0, !dbg !310
  %r3.p = getelementptr inbounds [5 x i8], ptr @.str.2, i64 0, i64 0, !dbg !310
  %r3 = ptrtoint ptr %r3.p to i64, !dbg !310
  %_is.dv0 = call i64 @nova_rt_dict_set(i64 %r2, i64 %r3, i64 %r1), !dbg !310
  %r4 = load i64, ptr %slot.table, align 8, !dbg !311
  %r5 = add i64 %r0, 0, !dbg !311
  %r6.p = getelementptr inbounds [6 x i8], ptr @.str.3, i64 0, i64 0, !dbg !311
  %r6 = ptrtoint ptr %r6.p to i64, !dbg !311
  %_is.dv1 = call i64 @nova_rt_dict_set(i64 %r5, i64 %r6, i64 %r4), !dbg !311
  %r7 = load i64, ptr %slot.sets, align 8, !dbg !312
  %r8 = add i64 %r0, 0, !dbg !312
  %r9.p = getelementptr inbounds [5 x i8], ptr @.str.23, i64 0, i64 0, !dbg !312
  %r9 = ptrtoint ptr %r9.p to i64, !dbg !312
  %_is.dv2 = call i64 @nova_rt_dict_set(i64 %r8, i64 %r9, i64 %r7), !dbg !312
  %r10 = load i64, ptr %slot.where_clause, align 8, !dbg !313
  %r11 = add i64 %r0, 0, !dbg !313
  %r12.p = getelementptr inbounds [6 x i8], ptr @.str.5, i64 0, i64 0, !dbg !313
  %r12 = ptrtoint ptr %r12.p to i64, !dbg !313
  %_is.dv3 = call i64 @nova_rt_dict_set(i64 %r11, i64 %r12, i64 %r10), !dbg !313
  %r13 = add i64 %r0, 0, !dbg !314
  ret i64 %r13, !dbg !314
}

; ESCAPE qb_delete: allocs=1 escape=1 local=0
define i64 @qb_delete(i64 %p0, i64 %p1) nounwind uwtable !dbg !315 {
entry:
  %slot.table = alloca i64, align 8, !dbg !316
  store i64 %p0, ptr %slot.table, align 8, !dbg !316
  %slot.where_clause = alloca i64, align 8, !dbg !316
  store i64 %p1, ptr %slot.where_clause, align 8, !dbg !316
  %slot.q = alloca i64, align 8, !dbg !316
  store i64 0, ptr %slot.q, align 8, !dbg !316
  %r0 = call i64 @nova_rt_dict_create(), !dbg !317
  store i64 %r0, ptr %slot.q, align 8, !dbg !317
  %r1.p = getelementptr inbounds [7 x i8], ptr @.str.30, i64 0, i64 0, !dbg !318
  %r1 = ptrtoint ptr %r1.p to i64, !dbg !318
  %r2 = add i64 %r0, 0, !dbg !318
  %r3.p = getelementptr inbounds [5 x i8], ptr @.str.2, i64 0, i64 0, !dbg !318
  %r3 = ptrtoint ptr %r3.p to i64, !dbg !318
  %_is.dv0 = call i64 @nova_rt_dict_set(i64 %r2, i64 %r3, i64 %r1), !dbg !318
  %r4 = load i64, ptr %slot.table, align 8, !dbg !319
  %r5 = add i64 %r0, 0, !dbg !319
  %r6.p = getelementptr inbounds [6 x i8], ptr @.str.3, i64 0, i64 0, !dbg !319
  %r6 = ptrtoint ptr %r6.p to i64, !dbg !319
  %_is.dv1 = call i64 @nova_rt_dict_set(i64 %r5, i64 %r6, i64 %r4), !dbg !319
  %r7 = load i64, ptr %slot.where_clause, align 8, !dbg !320
  %r8 = add i64 %r0, 0, !dbg !320
  %r9.p = getelementptr inbounds [6 x i8], ptr @.str.5, i64 0, i64 0, !dbg !320
  %r9 = ptrtoint ptr %r9.p to i64, !dbg !320
  %_is.dv2 = call i64 @nova_rt_dict_set(i64 %r8, i64 %r9, i64 %r7), !dbg !320
  %r10 = add i64 %r0, 0, !dbg !321
  ret i64 %r10, !dbg !321
}

; ESCAPE nova_user_main: allocs=0 escape=0 local=0
define i64 @nova_user_main() nounwind uwtable !dbg !322 {
entry:
  %r0.p = getelementptr inbounds [37 x i8], ptr @.str.31, i64 0, i64 0, !dbg !324
  %r0 = ptrtoint ptr %r0.p to i64, !dbg !324
  %r1 = call i64 @nova_rt_print_str(i64 %r0), !dbg !324
  ret i64 %r1, !dbg !324
}

; ESCAPE nova_main: allocs=0 escape=0 local=0
define i64 @nova_main() nounwind uwtable {
entry:
  %r0 = call i64 @nova_user_main()
  ret i64 0
}

; ESCAPE SUMMARY: allocs=6 escape=5 local=1 (16% local, RC-elidable)
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
@.str.0 = private unnamed_addr constant [1 x i8] c"\00"
@.str.1 = private unnamed_addr constant [7 x i8] c"select\00"
@.str.2 = private unnamed_addr constant [5 x i8] c"kind\00"
@.str.3 = private unnamed_addr constant [6 x i8] c"table\00"
@.str.4 = private unnamed_addr constant [8 x i8] c"columns\00"
@.str.5 = private unnamed_addr constant [6 x i8] c"where\00"
@.str.6 = private unnamed_addr constant [10 x i8] c"order_col\00"
@.str.7 = private unnamed_addr constant [10 x i8] c"order_dir\00"
@.str.8 = private unnamed_addr constant [6 x i8] c"limit\00"
@.str.9 = private unnamed_addr constant [2 x i8] c"*\00"
@.str.10 = private unnamed_addr constant [3 x i8] c", \00"
@.str.11 = private unnamed_addr constant [8 x i8] c"SELECT \00"
@.str.12 = private unnamed_addr constant [7 x i8] c" FROM \00"
@.str.13 = private unnamed_addr constant [8 x i8] c" WHERE \00"
@.str.14 = private unnamed_addr constant [6 x i8] c" AND \00"
@.str.15 = private unnamed_addr constant [11 x i8] c" ORDER BY \00"
@.str.16 = private unnamed_addr constant [2 x i8] c" \00"
@.str.17 = private unnamed_addr constant [8 x i8] c" LIMIT \00"
@.str.18 = private unnamed_addr constant [7 x i8] c"values\00"
@.str.19 = private unnamed_addr constant [13 x i8] c"INSERT INTO \00"
@.str.20 = private unnamed_addr constant [3 x i8] c" (\00"
@.str.21 = private unnamed_addr constant [2 x i8] c")\00"
@.str.22 = private unnamed_addr constant [10 x i8] c" VALUES (\00"
@.str.23 = private unnamed_addr constant [5 x i8] c"sets\00"
@.str.24 = private unnamed_addr constant [4 x i8] c" = \00"
@.str.25 = private unnamed_addr constant [8 x i8] c"UPDATE \00"
@.str.26 = private unnamed_addr constant [6 x i8] c" SET \00"
@.str.27 = private unnamed_addr constant [13 x i8] c"DELETE FROM \00"
@.str.28 = private unnamed_addr constant [7 x i8] c"insert\00"
@.str.29 = private unnamed_addr constant [7 x i8] c"update\00"
@.str.30 = private unnamed_addr constant [7 x i8] c"delete\00"
@.str.31 = private unnamed_addr constant [37 x i8] c"database query_builder module loaded\00"

; Debug metadata
!llvm.dbg.cu = !{!100}
!llvm.module.flags = !{!102, !103}

!100 = distinct !DICompileUnit(language: DW_LANG_C99, file: !101, producer: "NOVA Compiler", isOptimized: false, emissionKind: LineTablesOnly)
!101 = !DIFile(filename: "std/database/query_builder.nova", directory: ".")
!102 = !{i32 2, !"CodeView", i32 1}
!103 = !{i32 2, !"Debug Info Version", i32 3}
!104 = !DISubroutineType(types: !105)
!105 = !{null}
!200 = distinct !DISubprogram(name: "_qb_join", scope: !101, file: !101, line: 50, type: !104, scopeLine: 50, spFlags: DISPFlagDefinition, unit: !100)
!201 = !DILocation(line: 50, column: 0, scope: !200)
!211 = distinct !DISubprogram(name: "qb_select", scope: !101, file: !101, line: 62, type: !104, scopeLine: 62, spFlags: DISPFlagDefinition, unit: !100)
!212 = !DILocation(line: 62, column: 0, scope: !211)
!222 = distinct !DISubprogram(name: "qb_where", scope: !101, file: !101, line: 76, type: !104, scopeLine: 76, spFlags: DISPFlagDefinition, unit: !100)
!223 = !DILocation(line: 76, column: 0, scope: !222)
!228 = distinct !DISubprogram(name: "qb_order_by", scope: !101, file: !101, line: 84, type: !104, scopeLine: 84, spFlags: DISPFlagDefinition, unit: !100)
!229 = !DILocation(line: 84, column: 0, scope: !228)
!234 = distinct !DISubprogram(name: "qb_limit", scope: !101, file: !101, line: 91, type: !104, scopeLine: 91, spFlags: DISPFlagDefinition, unit: !100)
!235 = !DILocation(line: 91, column: 0, scope: !234)
!239 = distinct !DISubprogram(name: "_qb_build_select", scope: !101, file: !101, line: 97, type: !104, scopeLine: 97, spFlags: DISPFlagDefinition, unit: !100)
!240 = !DILocation(line: 97, column: 0, scope: !239)
!256 = distinct !DISubprogram(name: "_qb_build_insert", scope: !101, file: !101, line: 115, type: !104, scopeLine: 115, spFlags: DISPFlagDefinition, unit: !100)
!257 = !DILocation(line: 115, column: 0, scope: !256)
!264 = distinct !DISubprogram(name: "_qb_build_update", scope: !101, file: !101, line: 124, type: !104, scopeLine: 124, spFlags: DISPFlagDefinition, unit: !100)
!265 = !DILocation(line: 124, column: 0, scope: !264)
!280 = distinct !DISubprogram(name: "_qb_build_delete", scope: !101, file: !101, line: 141, type: !104, scopeLine: 141, spFlags: DISPFlagDefinition, unit: !100)
!281 = !DILocation(line: 141, column: 0, scope: !280)
!287 = distinct !DISubprogram(name: "qb_build", scope: !101, file: !101, line: 151, type: !104, scopeLine: 151, spFlags: DISPFlagDefinition, unit: !100)
!288 = !DILocation(line: 151, column: 0, scope: !287)
!299 = distinct !DISubprogram(name: "qb_insert", scope: !101, file: !101, line: 166, type: !104, scopeLine: 166, spFlags: DISPFlagDefinition, unit: !100)
!300 = !DILocation(line: 166, column: 0, scope: !299)
!307 = distinct !DISubprogram(name: "qb_update", scope: !101, file: !101, line: 177, type: !104, scopeLine: 177, spFlags: DISPFlagDefinition, unit: !100)
!308 = !DILocation(line: 177, column: 0, scope: !307)
!315 = distinct !DISubprogram(name: "qb_delete", scope: !101, file: !101, line: 187, type: !104, scopeLine: 187, spFlags: DISPFlagDefinition, unit: !100)
!316 = !DILocation(line: 187, column: 0, scope: !315)
!322 = distinct !DISubprogram(name: "nova_user_main", scope: !101, file: !101, line: 194, type: !104, scopeLine: 194, spFlags: DISPFlagDefinition, unit: !100)
!323 = !DILocation(line: 194, column: 0, scope: !322)
!202 = !DILocation(line: 51, column: 0, scope: !200)
!203 = !DILocation(line: 52, column: 0, scope: !200)
!204 = !DILocation(line: 53, column: 0, scope: !200)
!205 = !DILocation(line: 54, column: 0, scope: !200)
!206 = !DILocation(line: 55, column: 0, scope: !200)
!207 = !DILocation(line: 56, column: 0, scope: !200)
!208 = !DILocation(line: 57, column: 0, scope: !200)
!209 = !DILocation(line: 58, column: 0, scope: !200)
!210 = !DILocation(line: 59, column: 0, scope: !200)
!213 = !DILocation(line: 63, column: 0, scope: !211)
!214 = !DILocation(line: 64, column: 0, scope: !211)
!215 = !DILocation(line: 65, column: 0, scope: !211)
!216 = !DILocation(line: 66, column: 0, scope: !211)
!217 = !DILocation(line: 67, column: 0, scope: !211)
!218 = !DILocation(line: 68, column: 0, scope: !211)
!219 = !DILocation(line: 69, column: 0, scope: !211)
!220 = !DILocation(line: 70, column: 0, scope: !211)
!221 = !DILocation(line: 71, column: 0, scope: !211)
!224 = !DILocation(line: 77, column: 0, scope: !222)
!225 = !DILocation(line: 78, column: 0, scope: !222)
!226 = !DILocation(line: 79, column: 0, scope: !222)
!227 = !DILocation(line: 80, column: 0, scope: !222)
!230 = !DILocation(line: 85, column: 0, scope: !228)
!231 = !DILocation(line: 86, column: 0, scope: !228)
!232 = !DILocation(line: 87, column: 0, scope: !228)
!233 = !DILocation(line: 88, column: 0, scope: !228)
!236 = !DILocation(line: 92, column: 0, scope: !234)
!237 = !DILocation(line: 93, column: 0, scope: !234)
!238 = !DILocation(line: 94, column: 0, scope: !234)
!241 = !DILocation(line: 98, column: 0, scope: !239)
!242 = !DILocation(line: 99, column: 0, scope: !239)
!243 = !DILocation(line: 100, column: 0, scope: !239)
!244 = !DILocation(line: 101, column: 0, scope: !239)
!245 = !DILocation(line: 102, column: 0, scope: !239)
!246 = !DILocation(line: 103, column: 0, scope: !239)
!247 = !DILocation(line: 104, column: 0, scope: !239)
!248 = !DILocation(line: 105, column: 0, scope: !239)
!249 = !DILocation(line: 106, column: 0, scope: !239)
!250 = !DILocation(line: 107, column: 0, scope: !239)
!251 = !DILocation(line: 108, column: 0, scope: !239)
!252 = !DILocation(line: 109, column: 0, scope: !239)
!253 = !DILocation(line: 110, column: 0, scope: !239)
!254 = !DILocation(line: 111, column: 0, scope: !239)
!255 = !DILocation(line: 112, column: 0, scope: !239)
!258 = !DILocation(line: 116, column: 0, scope: !256)
!259 = !DILocation(line: 117, column: 0, scope: !256)
!260 = !DILocation(line: 118, column: 0, scope: !256)
!261 = !DILocation(line: 119, column: 0, scope: !256)
!262 = !DILocation(line: 120, column: 0, scope: !256)
!263 = !DILocation(line: 121, column: 0, scope: !256)
!266 = !DILocation(line: 125, column: 0, scope: !264)
!267 = !DILocation(line: 126, column: 0, scope: !264)
!268 = !DILocation(line: 127, column: 0, scope: !264)
!269 = !DILocation(line: 128, column: 0, scope: !264)
!270 = !DILocation(line: 129, column: 0, scope: !264)
!271 = !DILocation(line: 130, column: 0, scope: !264)
!272 = !DILocation(line: 131, column: 0, scope: !264)
!273 = !DILocation(line: 132, column: 0, scope: !264)
!274 = !DILocation(line: 133, column: 0, scope: !264)
!275 = !DILocation(line: 134, column: 0, scope: !264)
!276 = !DILocation(line: 135, column: 0, scope: !264)
!277 = !DILocation(line: 136, column: 0, scope: !264)
!278 = !DILocation(line: 137, column: 0, scope: !264)
!279 = !DILocation(line: 138, column: 0, scope: !264)
!282 = !DILocation(line: 142, column: 0, scope: !280)
!283 = !DILocation(line: 143, column: 0, scope: !280)
!284 = !DILocation(line: 144, column: 0, scope: !280)
!285 = !DILocation(line: 145, column: 0, scope: !280)
!286 = !DILocation(line: 146, column: 0, scope: !280)
!289 = !DILocation(line: 152, column: 0, scope: !287)
!290 = !DILocation(line: 153, column: 0, scope: !287)
!291 = !DILocation(line: 154, column: 0, scope: !287)
!292 = !DILocation(line: 155, column: 0, scope: !287)
!293 = !DILocation(line: 156, column: 0, scope: !287)
!294 = !DILocation(line: 157, column: 0, scope: !287)
!295 = !DILocation(line: 158, column: 0, scope: !287)
!296 = !DILocation(line: 159, column: 0, scope: !287)
!297 = !DILocation(line: 160, column: 0, scope: !287)
!298 = !DILocation(line: 161, column: 0, scope: !287)
!301 = !DILocation(line: 167, column: 0, scope: !299)
!302 = !DILocation(line: 168, column: 0, scope: !299)
!303 = !DILocation(line: 169, column: 0, scope: !299)
!304 = !DILocation(line: 170, column: 0, scope: !299)
!305 = !DILocation(line: 171, column: 0, scope: !299)
!306 = !DILocation(line: 172, column: 0, scope: !299)
!309 = !DILocation(line: 178, column: 0, scope: !307)
!310 = !DILocation(line: 179, column: 0, scope: !307)
!311 = !DILocation(line: 180, column: 0, scope: !307)
!312 = !DILocation(line: 181, column: 0, scope: !307)
!313 = !DILocation(line: 182, column: 0, scope: !307)
!314 = !DILocation(line: 183, column: 0, scope: !307)
!317 = !DILocation(line: 188, column: 0, scope: !315)
!318 = !DILocation(line: 189, column: 0, scope: !315)
!319 = !DILocation(line: 190, column: 0, scope: !315)
!320 = !DILocation(line: 191, column: 0, scope: !315)
!321 = !DILocation(line: 192, column: 0, scope: !315)
!324 = !DILocation(line: 195, column: 0, scope: !322)

; TBAA metadata
!0 = !{!"NOVA TBAA"}
!1 = !{!"list_data_ptr", !0}
!2 = !{!1, !1, i64 0}
!3 = !{!"list_elem", !0}
!4 = !{!3, !3, i64 0}
!5 = !{!"list_size", !0}
!6 = !{!5, !5, i64 0}
!90 = !{!"branch_weights", i32 2000, i32 1}
