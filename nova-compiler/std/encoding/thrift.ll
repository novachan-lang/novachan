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

; ESCAPE _p8: allocs=0 escape=0 local=0
define i64 @_p8() nounwind uwtable {
entry:
  %r0 = add i64 256, 0
  ret i64 %r0
}

; ESCAPE _p16: allocs=0 escape=0 local=0
define i64 @_p16() nounwind uwtable {
entry:
  %r0 = add i64 65536, 0
  ret i64 %r0
}

; ESCAPE _p32: allocs=0 escape=0 local=0
define i64 @_p32() nounwind uwtable {
entry:
  %r0 = add i64 4294967296, 0
  ret i64 %r0
}

; ESCAPE pack_u8: allocs=0 escape=0 local=0
define i64 @pack_u8(i64 %p0) nounwind uwtable {
entry:
  %slot.v = alloca i64, align 8
  store i64 %p0, ptr %slot.v, align 8
  %slot.b = alloca i64, align 8
  store i64 0, ptr %slot.b, align 8
  %r0 = add i64 1, 0
  %r1 = call i64 @nova_rt_bytes_create(i64 %r0)
  store i64 %r1, ptr %slot.b, align 8
  %r2 = load i64, ptr %slot.b, align 8
  %r3 = add i64 0, 0
  %r4 = load i64, ptr %slot.v, align 8
  %r5 = add i64 255, 0
  %r6 = and i64 %r4, %r5
  %r7 = call i64 @nova_rt_bytes_set(i64 %r2, i64 %r3, i64 %r6)
  %r8 = load i64, ptr %slot.b, align 8
  ret i64 %r8
}

; ESCAPE pack_u16_be: allocs=0 escape=0 local=0
define i64 @pack_u16_be(i64 %p0) nounwind uwtable {
entry:
  %slot.v = alloca i64, align 8
  store i64 %p0, ptr %slot.v, align 8
  %slot.b = alloca i64, align 8
  store i64 0, ptr %slot.b, align 8
  %r0 = add i64 2, 0
  %r1 = call i64 @nova_rt_bytes_create(i64 %r0)
  store i64 %r1, ptr %slot.b, align 8
  %r2 = load i64, ptr %slot.b, align 8
  %r3 = add i64 0, 0
  %r4 = load i64, ptr %slot.v, align 8
  %r5 = add i64 8, 0
  %r6.sramt = and i64 %r5, 63
  %r6.srbig = icmp uge i64 %r5, 64
  %r6.srval = ashr i64 %r4, %r6.sramt
  %r6.srext = ashr i64 %r4, 63
  %r6 = select i1 %r6.srbig, i64 %r6.srext, i64 %r6.srval
  %r7 = add i64 255, 0
  %r8 = and i64 %r6, %r7
  %r9 = call i64 @nova_rt_bytes_set(i64 %r2, i64 %r3, i64 %r8)
  %r10 = load i64, ptr %slot.b, align 8
  %r11 = add i64 1, 0
  %r12 = load i64, ptr %slot.v, align 8
  %r13 = add i64 255, 0
  %r14 = and i64 %r12, %r13
  %r15 = call i64 @nova_rt_bytes_set(i64 %r10, i64 %r11, i64 %r14)
  %r16 = load i64, ptr %slot.b, align 8
  ret i64 %r16
}

; ESCAPE pack_u16_le: allocs=0 escape=0 local=0
define i64 @pack_u16_le(i64 %p0) nounwind uwtable {
entry:
  %slot.v = alloca i64, align 8
  store i64 %p0, ptr %slot.v, align 8
  %slot.b = alloca i64, align 8
  store i64 0, ptr %slot.b, align 8
  %r0 = add i64 2, 0
  %r1 = call i64 @nova_rt_bytes_create(i64 %r0)
  store i64 %r1, ptr %slot.b, align 8
  %r2 = load i64, ptr %slot.b, align 8
  %r3 = add i64 0, 0
  %r4 = load i64, ptr %slot.v, align 8
  %r5 = add i64 255, 0
  %r6 = and i64 %r4, %r5
  %r7 = call i64 @nova_rt_bytes_set(i64 %r2, i64 %r3, i64 %r6)
  %r8 = load i64, ptr %slot.b, align 8
  %r9 = add i64 1, 0
  %r10 = load i64, ptr %slot.v, align 8
  %r11 = add i64 8, 0
  %r12.sramt = and i64 %r11, 63
  %r12.srbig = icmp uge i64 %r11, 64
  %r12.srval = ashr i64 %r10, %r12.sramt
  %r12.srext = ashr i64 %r10, 63
  %r12 = select i1 %r12.srbig, i64 %r12.srext, i64 %r12.srval
  %r13 = add i64 255, 0
  %r14 = and i64 %r12, %r13
  %r15 = call i64 @nova_rt_bytes_set(i64 %r8, i64 %r9, i64 %r14)
  %r16 = load i64, ptr %slot.b, align 8
  ret i64 %r16
}

; ESCAPE pack_u32_be: allocs=0 escape=0 local=0
define i64 @pack_u32_be(i64 %p0) nounwind uwtable {
entry:
  %slot.v = alloca i64, align 8
  store i64 %p0, ptr %slot.v, align 8
  %slot.b = alloca i64, align 8
  store i64 0, ptr %slot.b, align 8
  %r0 = add i64 4, 0
  %r1 = call i64 @nova_rt_bytes_create(i64 %r0)
  store i64 %r1, ptr %slot.b, align 8
  %r2 = load i64, ptr %slot.b, align 8
  %r3 = add i64 0, 0
  %r4 = load i64, ptr %slot.v, align 8
  %r5 = add i64 24, 0
  %r6.sramt = and i64 %r5, 63
  %r6.srbig = icmp uge i64 %r5, 64
  %r6.srval = ashr i64 %r4, %r6.sramt
  %r6.srext = ashr i64 %r4, 63
  %r6 = select i1 %r6.srbig, i64 %r6.srext, i64 %r6.srval
  %r7 = add i64 255, 0
  %r8 = and i64 %r6, %r7
  %r9 = call i64 @nova_rt_bytes_set(i64 %r2, i64 %r3, i64 %r8)
  %r10 = load i64, ptr %slot.b, align 8
  %r11 = add i64 1, 0
  %r12 = load i64, ptr %slot.v, align 8
  %r13 = add i64 16, 0
  %r14.sramt = and i64 %r13, 63
  %r14.srbig = icmp uge i64 %r13, 64
  %r14.srval = ashr i64 %r12, %r14.sramt
  %r14.srext = ashr i64 %r12, 63
  %r14 = select i1 %r14.srbig, i64 %r14.srext, i64 %r14.srval
  %r15 = add i64 255, 0
  %r16 = and i64 %r14, %r15
  %r17 = call i64 @nova_rt_bytes_set(i64 %r10, i64 %r11, i64 %r16)
  %r18 = load i64, ptr %slot.b, align 8
  %r19 = add i64 2, 0
  %r20 = load i64, ptr %slot.v, align 8
  %r21 = add i64 8, 0
  %r22.sramt = and i64 %r21, 63
  %r22.srbig = icmp uge i64 %r21, 64
  %r22.srval = ashr i64 %r20, %r22.sramt
  %r22.srext = ashr i64 %r20, 63
  %r22 = select i1 %r22.srbig, i64 %r22.srext, i64 %r22.srval
  %r23 = add i64 255, 0
  %r24 = and i64 %r22, %r23
  %r25 = call i64 @nova_rt_bytes_set(i64 %r18, i64 %r19, i64 %r24)
  %r26 = load i64, ptr %slot.b, align 8
  %r27 = add i64 3, 0
  %r28 = load i64, ptr %slot.v, align 8
  %r29 = add i64 255, 0
  %r30 = and i64 %r28, %r29
  %r31 = call i64 @nova_rt_bytes_set(i64 %r26, i64 %r27, i64 %r30)
  %r32 = load i64, ptr %slot.b, align 8
  ret i64 %r32
}

; ESCAPE pack_u32_le: allocs=0 escape=0 local=0
define i64 @pack_u32_le(i64 %p0) nounwind uwtable {
entry:
  %slot.v = alloca i64, align 8
  store i64 %p0, ptr %slot.v, align 8
  %slot.b = alloca i64, align 8
  store i64 0, ptr %slot.b, align 8
  %r0 = add i64 4, 0
  %r1 = call i64 @nova_rt_bytes_create(i64 %r0)
  store i64 %r1, ptr %slot.b, align 8
  %r2 = load i64, ptr %slot.b, align 8
  %r3 = add i64 0, 0
  %r4 = load i64, ptr %slot.v, align 8
  %r5 = add i64 255, 0
  %r6 = and i64 %r4, %r5
  %r7 = call i64 @nova_rt_bytes_set(i64 %r2, i64 %r3, i64 %r6)
  %r8 = load i64, ptr %slot.b, align 8
  %r9 = add i64 1, 0
  %r10 = load i64, ptr %slot.v, align 8
  %r11 = add i64 8, 0
  %r12.sramt = and i64 %r11, 63
  %r12.srbig = icmp uge i64 %r11, 64
  %r12.srval = ashr i64 %r10, %r12.sramt
  %r12.srext = ashr i64 %r10, 63
  %r12 = select i1 %r12.srbig, i64 %r12.srext, i64 %r12.srval
  %r13 = add i64 255, 0
  %r14 = and i64 %r12, %r13
  %r15 = call i64 @nova_rt_bytes_set(i64 %r8, i64 %r9, i64 %r14)
  %r16 = load i64, ptr %slot.b, align 8
  %r17 = add i64 2, 0
  %r18 = load i64, ptr %slot.v, align 8
  %r19 = add i64 16, 0
  %r20.sramt = and i64 %r19, 63
  %r20.srbig = icmp uge i64 %r19, 64
  %r20.srval = ashr i64 %r18, %r20.sramt
  %r20.srext = ashr i64 %r18, 63
  %r20 = select i1 %r20.srbig, i64 %r20.srext, i64 %r20.srval
  %r21 = add i64 255, 0
  %r22 = and i64 %r20, %r21
  %r23 = call i64 @nova_rt_bytes_set(i64 %r16, i64 %r17, i64 %r22)
  %r24 = load i64, ptr %slot.b, align 8
  %r25 = add i64 3, 0
  %r26 = load i64, ptr %slot.v, align 8
  %r27 = add i64 24, 0
  %r28.sramt = and i64 %r27, 63
  %r28.srbig = icmp uge i64 %r27, 64
  %r28.srval = ashr i64 %r26, %r28.sramt
  %r28.srext = ashr i64 %r26, 63
  %r28 = select i1 %r28.srbig, i64 %r28.srext, i64 %r28.srval
  %r29 = add i64 255, 0
  %r30 = and i64 %r28, %r29
  %r31 = call i64 @nova_rt_bytes_set(i64 %r24, i64 %r25, i64 %r30)
  %r32 = load i64, ptr %slot.b, align 8
  ret i64 %r32
}

; ESCAPE pack_u64_be: allocs=0 escape=0 local=0
define i64 @pack_u64_be(i64 %p0) nounwind uwtable {
entry:
  %slot.v = alloca i64, align 8
  store i64 %p0, ptr %slot.v, align 8
  %slot.b = alloca i64, align 8
  store i64 0, ptr %slot.b, align 8
  %r0 = add i64 8, 0
  %r1 = call i64 @nova_rt_bytes_create(i64 %r0)
  store i64 %r1, ptr %slot.b, align 8
  %r2 = load i64, ptr %slot.b, align 8
  %r3 = add i64 0, 0
  %r4 = load i64, ptr %slot.v, align 8
  %r5 = add i64 56, 0
  %r6.sramt = and i64 %r5, 63
  %r6.srbig = icmp uge i64 %r5, 64
  %r6.srval = ashr i64 %r4, %r6.sramt
  %r6.srext = ashr i64 %r4, 63
  %r6 = select i1 %r6.srbig, i64 %r6.srext, i64 %r6.srval
  %r7 = add i64 255, 0
  %r8 = and i64 %r6, %r7
  %r9 = call i64 @nova_rt_bytes_set(i64 %r2, i64 %r3, i64 %r8)
  %r10 = load i64, ptr %slot.b, align 8
  %r11 = add i64 1, 0
  %r12 = load i64, ptr %slot.v, align 8
  %r13 = add i64 48, 0
  %r14.sramt = and i64 %r13, 63
  %r14.srbig = icmp uge i64 %r13, 64
  %r14.srval = ashr i64 %r12, %r14.sramt
  %r14.srext = ashr i64 %r12, 63
  %r14 = select i1 %r14.srbig, i64 %r14.srext, i64 %r14.srval
  %r15 = add i64 255, 0
  %r16 = and i64 %r14, %r15
  %r17 = call i64 @nova_rt_bytes_set(i64 %r10, i64 %r11, i64 %r16)
  %r18 = load i64, ptr %slot.b, align 8
  %r19 = add i64 2, 0
  %r20 = load i64, ptr %slot.v, align 8
  %r21 = add i64 40, 0
  %r22.sramt = and i64 %r21, 63
  %r22.srbig = icmp uge i64 %r21, 64
  %r22.srval = ashr i64 %r20, %r22.sramt
  %r22.srext = ashr i64 %r20, 63
  %r22 = select i1 %r22.srbig, i64 %r22.srext, i64 %r22.srval
  %r23 = add i64 255, 0
  %r24 = and i64 %r22, %r23
  %r25 = call i64 @nova_rt_bytes_set(i64 %r18, i64 %r19, i64 %r24)
  %r26 = load i64, ptr %slot.b, align 8
  %r27 = add i64 3, 0
  %r28 = load i64, ptr %slot.v, align 8
  %r29 = add i64 32, 0
  %r30.sramt = and i64 %r29, 63
  %r30.srbig = icmp uge i64 %r29, 64
  %r30.srval = ashr i64 %r28, %r30.sramt
  %r30.srext = ashr i64 %r28, 63
  %r30 = select i1 %r30.srbig, i64 %r30.srext, i64 %r30.srval
  %r31 = add i64 255, 0
  %r32 = and i64 %r30, %r31
  %r33 = call i64 @nova_rt_bytes_set(i64 %r26, i64 %r27, i64 %r32)
  %r34 = load i64, ptr %slot.b, align 8
  %r35 = add i64 4, 0
  %r36 = load i64, ptr %slot.v, align 8
  %r37 = add i64 24, 0
  %r38.sramt = and i64 %r37, 63
  %r38.srbig = icmp uge i64 %r37, 64
  %r38.srval = ashr i64 %r36, %r38.sramt
  %r38.srext = ashr i64 %r36, 63
  %r38 = select i1 %r38.srbig, i64 %r38.srext, i64 %r38.srval
  %r39 = add i64 255, 0
  %r40 = and i64 %r38, %r39
  %r41 = call i64 @nova_rt_bytes_set(i64 %r34, i64 %r35, i64 %r40)
  %r42 = load i64, ptr %slot.b, align 8
  %r43 = add i64 5, 0
  %r44 = load i64, ptr %slot.v, align 8
  %r45 = add i64 16, 0
  %r46.sramt = and i64 %r45, 63
  %r46.srbig = icmp uge i64 %r45, 64
  %r46.srval = ashr i64 %r44, %r46.sramt
  %r46.srext = ashr i64 %r44, 63
  %r46 = select i1 %r46.srbig, i64 %r46.srext, i64 %r46.srval
  %r47 = add i64 255, 0
  %r48 = and i64 %r46, %r47
  %r49 = call i64 @nova_rt_bytes_set(i64 %r42, i64 %r43, i64 %r48)
  %r50 = load i64, ptr %slot.b, align 8
  %r51 = add i64 6, 0
  %r52 = load i64, ptr %slot.v, align 8
  %r53 = add i64 8, 0
  %r54.sramt = and i64 %r53, 63
  %r54.srbig = icmp uge i64 %r53, 64
  %r54.srval = ashr i64 %r52, %r54.sramt
  %r54.srext = ashr i64 %r52, 63
  %r54 = select i1 %r54.srbig, i64 %r54.srext, i64 %r54.srval
  %r55 = add i64 255, 0
  %r56 = and i64 %r54, %r55
  %r57 = call i64 @nova_rt_bytes_set(i64 %r50, i64 %r51, i64 %r56)
  %r58 = load i64, ptr %slot.b, align 8
  %r59 = add i64 7, 0
  %r60 = load i64, ptr %slot.v, align 8
  %r61 = add i64 255, 0
  %r62 = and i64 %r60, %r61
  %r63 = call i64 @nova_rt_bytes_set(i64 %r58, i64 %r59, i64 %r62)
  %r64 = load i64, ptr %slot.b, align 8
  ret i64 %r64
}

; ESCAPE pack_u64_le: allocs=0 escape=0 local=0
define i64 @pack_u64_le(i64 %p0) nounwind uwtable {
entry:
  %slot.v = alloca i64, align 8
  store i64 %p0, ptr %slot.v, align 8
  %slot.b = alloca i64, align 8
  store i64 0, ptr %slot.b, align 8
  %r0 = add i64 8, 0
  %r1 = call i64 @nova_rt_bytes_create(i64 %r0)
  store i64 %r1, ptr %slot.b, align 8
  %r2 = load i64, ptr %slot.b, align 8
  %r3 = add i64 0, 0
  %r4 = load i64, ptr %slot.v, align 8
  %r5 = add i64 255, 0
  %r6 = and i64 %r4, %r5
  %r7 = call i64 @nova_rt_bytes_set(i64 %r2, i64 %r3, i64 %r6)
  %r8 = load i64, ptr %slot.b, align 8
  %r9 = add i64 1, 0
  %r10 = load i64, ptr %slot.v, align 8
  %r11 = add i64 8, 0
  %r12.sramt = and i64 %r11, 63
  %r12.srbig = icmp uge i64 %r11, 64
  %r12.srval = ashr i64 %r10, %r12.sramt
  %r12.srext = ashr i64 %r10, 63
  %r12 = select i1 %r12.srbig, i64 %r12.srext, i64 %r12.srval
  %r13 = add i64 255, 0
  %r14 = and i64 %r12, %r13
  %r15 = call i64 @nova_rt_bytes_set(i64 %r8, i64 %r9, i64 %r14)
  %r16 = load i64, ptr %slot.b, align 8
  %r17 = add i64 2, 0
  %r18 = load i64, ptr %slot.v, align 8
  %r19 = add i64 16, 0
  %r20.sramt = and i64 %r19, 63
  %r20.srbig = icmp uge i64 %r19, 64
  %r20.srval = ashr i64 %r18, %r20.sramt
  %r20.srext = ashr i64 %r18, 63
  %r20 = select i1 %r20.srbig, i64 %r20.srext, i64 %r20.srval
  %r21 = add i64 255, 0
  %r22 = and i64 %r20, %r21
  %r23 = call i64 @nova_rt_bytes_set(i64 %r16, i64 %r17, i64 %r22)
  %r24 = load i64, ptr %slot.b, align 8
  %r25 = add i64 3, 0
  %r26 = load i64, ptr %slot.v, align 8
  %r27 = add i64 24, 0
  %r28.sramt = and i64 %r27, 63
  %r28.srbig = icmp uge i64 %r27, 64
  %r28.srval = ashr i64 %r26, %r28.sramt
  %r28.srext = ashr i64 %r26, 63
  %r28 = select i1 %r28.srbig, i64 %r28.srext, i64 %r28.srval
  %r29 = add i64 255, 0
  %r30 = and i64 %r28, %r29
  %r31 = call i64 @nova_rt_bytes_set(i64 %r24, i64 %r25, i64 %r30)
  %r32 = load i64, ptr %slot.b, align 8
  %r33 = add i64 4, 0
  %r34 = load i64, ptr %slot.v, align 8
  %r35 = add i64 32, 0
  %r36.sramt = and i64 %r35, 63
  %r36.srbig = icmp uge i64 %r35, 64
  %r36.srval = ashr i64 %r34, %r36.sramt
  %r36.srext = ashr i64 %r34, 63
  %r36 = select i1 %r36.srbig, i64 %r36.srext, i64 %r36.srval
  %r37 = add i64 255, 0
  %r38 = and i64 %r36, %r37
  %r39 = call i64 @nova_rt_bytes_set(i64 %r32, i64 %r33, i64 %r38)
  %r40 = load i64, ptr %slot.b, align 8
  %r41 = add i64 5, 0
  %r42 = load i64, ptr %slot.v, align 8
  %r43 = add i64 40, 0
  %r44.sramt = and i64 %r43, 63
  %r44.srbig = icmp uge i64 %r43, 64
  %r44.srval = ashr i64 %r42, %r44.sramt
  %r44.srext = ashr i64 %r42, 63
  %r44 = select i1 %r44.srbig, i64 %r44.srext, i64 %r44.srval
  %r45 = add i64 255, 0
  %r46 = and i64 %r44, %r45
  %r47 = call i64 @nova_rt_bytes_set(i64 %r40, i64 %r41, i64 %r46)
  %r48 = load i64, ptr %slot.b, align 8
  %r49 = add i64 6, 0
  %r50 = load i64, ptr %slot.v, align 8
  %r51 = add i64 48, 0
  %r52.sramt = and i64 %r51, 63
  %r52.srbig = icmp uge i64 %r51, 64
  %r52.srval = ashr i64 %r50, %r52.sramt
  %r52.srext = ashr i64 %r50, 63
  %r52 = select i1 %r52.srbig, i64 %r52.srext, i64 %r52.srval
  %r53 = add i64 255, 0
  %r54 = and i64 %r52, %r53
  %r55 = call i64 @nova_rt_bytes_set(i64 %r48, i64 %r49, i64 %r54)
  %r56 = load i64, ptr %slot.b, align 8
  %r57 = add i64 7, 0
  %r58 = load i64, ptr %slot.v, align 8
  %r59 = add i64 56, 0
  %r60.sramt = and i64 %r59, 63
  %r60.srbig = icmp uge i64 %r59, 64
  %r60.srval = ashr i64 %r58, %r60.sramt
  %r60.srext = ashr i64 %r58, 63
  %r60 = select i1 %r60.srbig, i64 %r60.srext, i64 %r60.srval
  %r61 = add i64 255, 0
  %r62 = and i64 %r60, %r61
  %r63 = call i64 @nova_rt_bytes_set(i64 %r56, i64 %r57, i64 %r62)
  %r64 = load i64, ptr %slot.b, align 8
  ret i64 %r64
}

; ESCAPE pack_i8: allocs=0 escape=0 local=0
define i64 @pack_i8(i64 %p0) nounwind uwtable {
entry:
  %slot.v = alloca i64, align 8
  store i64 %p0, ptr %slot.v, align 8
  %slot.u = alloca i64, align 8
  store i64 0, ptr %slot.u, align 8
  %r0 = load i64, ptr %slot.v, align 8
  store i64 %r0, ptr %slot.u, align 8
  %r1 = load i64, ptr %slot.v, align 8
  %r2 = add i64 0, 0
  %r3 = call i64 @nova_rt_lt(i64 %r1, i64 %r2)
  %br_then00 = icmp ne i64 %r3, 0
  br i1 %br_then00, label %then0, label %else1
then0:
  %r4 = load i64, ptr %slot.v, align 8
  %r5 = call i64 @_p8()
  %r6 = call i64 @nova_rt_add(i64 %r4, i64 %r5)
  store i64 %r6, ptr %slot.u, align 8
  br label %endif2
else1:
  br label %endif2
endif2:
  %r7 = load i64, ptr %slot.u, align 8
  %r8 = call i64 @pack_u8(i64 %r7)
  ret i64 %r8
}

; ESCAPE pack_i16_be: allocs=0 escape=0 local=0
define i64 @pack_i16_be(i64 %p0) nounwind uwtable {
entry:
  %slot.v = alloca i64, align 8
  store i64 %p0, ptr %slot.v, align 8
  %slot.u = alloca i64, align 8
  store i64 0, ptr %slot.u, align 8
  %r0 = load i64, ptr %slot.v, align 8
  store i64 %r0, ptr %slot.u, align 8
  %r1 = load i64, ptr %slot.v, align 8
  %r2 = add i64 0, 0
  %r3 = call i64 @nova_rt_lt(i64 %r1, i64 %r2)
  %br_then30 = icmp ne i64 %r3, 0
  br i1 %br_then30, label %then3, label %else4
then3:
  %r4 = load i64, ptr %slot.v, align 8
  %r5 = call i64 @_p16()
  %r6 = call i64 @nova_rt_add(i64 %r4, i64 %r5)
  store i64 %r6, ptr %slot.u, align 8
  br label %endif5
else4:
  br label %endif5
endif5:
  %r7 = load i64, ptr %slot.u, align 8
  %r8 = call i64 @pack_u16_be(i64 %r7)
  ret i64 %r8
}

; ESCAPE pack_i16_le: allocs=0 escape=0 local=0
define i64 @pack_i16_le(i64 %p0) nounwind uwtable {
entry:
  %slot.v = alloca i64, align 8
  store i64 %p0, ptr %slot.v, align 8
  %slot.u = alloca i64, align 8
  store i64 0, ptr %slot.u, align 8
  %r0 = load i64, ptr %slot.v, align 8
  store i64 %r0, ptr %slot.u, align 8
  %r1 = load i64, ptr %slot.v, align 8
  %r2 = add i64 0, 0
  %r3 = call i64 @nova_rt_lt(i64 %r1, i64 %r2)
  %br_then60 = icmp ne i64 %r3, 0
  br i1 %br_then60, label %then6, label %else7
then6:
  %r4 = load i64, ptr %slot.v, align 8
  %r5 = call i64 @_p16()
  %r6 = call i64 @nova_rt_add(i64 %r4, i64 %r5)
  store i64 %r6, ptr %slot.u, align 8
  br label %endif8
else7:
  br label %endif8
endif8:
  %r7 = load i64, ptr %slot.u, align 8
  %r8 = call i64 @pack_u16_le(i64 %r7)
  ret i64 %r8
}

; ESCAPE pack_i32_be: allocs=0 escape=0 local=0
define i64 @pack_i32_be(i64 %p0) nounwind uwtable {
entry:
  %slot.v = alloca i64, align 8
  store i64 %p0, ptr %slot.v, align 8
  %slot.u = alloca i64, align 8
  store i64 0, ptr %slot.u, align 8
  %r0 = load i64, ptr %slot.v, align 8
  store i64 %r0, ptr %slot.u, align 8
  %r1 = load i64, ptr %slot.v, align 8
  %r2 = add i64 0, 0
  %r3.cmp = icmp slt i64 %r1, %r2
  %r3 = zext i1 %r3.cmp to i64
  %br_then90 = icmp ne i64 %r3, 0
  br i1 %br_then90, label %then9, label %else10
then9:
  %r4 = load i64, ptr %slot.v, align 8
  %r5 = call i64 @_p32()
  %r6 = add i64 %r4, %r5
  store i64 %r6, ptr %slot.u, align 8
  br label %endif11
else10:
  br label %endif11
endif11:
  %r7 = load i64, ptr %slot.u, align 8
  %r8 = call i64 @pack_u32_be(i64 %r7)
  ret i64 %r8
}

; ESCAPE pack_i32_le: allocs=0 escape=0 local=0
define i64 @pack_i32_le(i64 %p0) nounwind uwtable {
entry:
  %slot.v = alloca i64, align 8
  store i64 %p0, ptr %slot.v, align 8
  %slot.u = alloca i64, align 8
  store i64 0, ptr %slot.u, align 8
  %r0 = load i64, ptr %slot.v, align 8
  store i64 %r0, ptr %slot.u, align 8
  %r1 = load i64, ptr %slot.v, align 8
  %r2 = add i64 0, 0
  %r3 = call i64 @nova_rt_lt(i64 %r1, i64 %r2)
  %br_then120 = icmp ne i64 %r3, 0
  br i1 %br_then120, label %then12, label %else13
then12:
  %r4 = load i64, ptr %slot.v, align 8
  %r5 = call i64 @_p32()
  %r6 = call i64 @nova_rt_add(i64 %r4, i64 %r5)
  store i64 %r6, ptr %slot.u, align 8
  br label %endif14
else13:
  br label %endif14
endif14:
  %r7 = load i64, ptr %slot.u, align 8
  %r8 = call i64 @pack_u32_le(i64 %r7)
  ret i64 %r8
}

; ESCAPE pack_i64_be: allocs=0 escape=0 local=0
define i64 @pack_i64_be(i64 %p0) nounwind uwtable {
entry:
  %slot.v = alloca i64, align 8
  store i64 %p0, ptr %slot.v, align 8
  %r0 = load i64, ptr %slot.v, align 8
  %r1 = call i64 @pack_u64_be(i64 %r0)
  ret i64 %r1
}

; ESCAPE pack_i64_le: allocs=0 escape=0 local=0
define i64 @pack_i64_le(i64 %p0) nounwind uwtable {
entry:
  %slot.v = alloca i64, align 8
  store i64 %p0, ptr %slot.v, align 8
  %r0 = load i64, ptr %slot.v, align 8
  %r1 = call i64 @pack_u64_le(i64 %r0)
  ret i64 %r1
}

; ESCAPE unpack_u8: allocs=0 escape=0 local=0
define i64 @unpack_u8(i64 %p0, i64 %p1) nounwind uwtable {
entry:
  %slot.b = alloca i64, align 8
  store i64 %p0, ptr %slot.b, align 8
  %slot.off = alloca i64, align 8
  store i64 %p1, ptr %slot.off, align 8
  %r0 = load i64, ptr %slot.b, align 8
  %r1 = load i64, ptr %slot.off, align 8
  %r2 = call i64 @nova_rt_bytes_get(i64 %r0, i64 %r1)
  %r3 = add i64 255, 0
  %r4 = and i64 %r2, %r3
  ret i64 %r4
}

; ESCAPE unpack_u16_be: allocs=0 escape=0 local=0
define i64 @unpack_u16_be(i64 %p0, i64 %p1) nounwind uwtable {
entry:
  %slot.b = alloca i64, align 8
  store i64 %p0, ptr %slot.b, align 8
  %slot.off = alloca i64, align 8
  store i64 %p1, ptr %slot.off, align 8
  %slot.hi = alloca i64, align 8
  store i64 0, ptr %slot.hi, align 8
  %slot.lo = alloca i64, align 8
  store i64 0, ptr %slot.lo, align 8
  %r0 = load i64, ptr %slot.b, align 8
  %r1 = load i64, ptr %slot.off, align 8
  %r2 = call i64 @nova_rt_bytes_get(i64 %r0, i64 %r1)
  %r3 = add i64 255, 0
  %r4 = and i64 %r2, %r3
  store i64 %r4, ptr %slot.hi, align 8
  %r5 = load i64, ptr %slot.b, align 8
  %r6 = load i64, ptr %slot.off, align 8
  %r7 = add i64 1, 0
  %r8 = call i64 @nova_rt_add(i64 %r6, i64 %r7)
  %r9 = call i64 @nova_rt_bytes_get(i64 %r5, i64 %r8)
  %r10 = add i64 255, 0
  %r11 = and i64 %r9, %r10
  store i64 %r11, ptr %slot.lo, align 8
  %r12 = load i64, ptr %slot.hi, align 8
  %r13 = add i64 8, 0
  %r14.shamt = and i64 %r13, 63
  %r14.shbig = icmp uge i64 %r13, 64
  %r14.shval = shl i64 %r12, %r14.shamt
  %r14 = select i1 %r14.shbig, i64 0, i64 %r14.shval
  %r15 = load i64, ptr %slot.lo, align 8
  %r16 = or i64 %r14, %r15
  ret i64 %r16
}

; ESCAPE unpack_u16_le: allocs=0 escape=0 local=0
define i64 @unpack_u16_le(i64 %p0, i64 %p1) nounwind uwtable {
entry:
  %slot.b = alloca i64, align 8
  store i64 %p0, ptr %slot.b, align 8
  %slot.off = alloca i64, align 8
  store i64 %p1, ptr %slot.off, align 8
  %slot.lo = alloca i64, align 8
  store i64 0, ptr %slot.lo, align 8
  %slot.hi = alloca i64, align 8
  store i64 0, ptr %slot.hi, align 8
  %r0 = load i64, ptr %slot.b, align 8
  %r1 = load i64, ptr %slot.off, align 8
  %r2 = call i64 @nova_rt_bytes_get(i64 %r0, i64 %r1)
  %r3 = add i64 255, 0
  %r4 = and i64 %r2, %r3
  store i64 %r4, ptr %slot.lo, align 8
  %r5 = load i64, ptr %slot.b, align 8
  %r6 = load i64, ptr %slot.off, align 8
  %r7 = add i64 1, 0
  %r8 = call i64 @nova_rt_add(i64 %r6, i64 %r7)
  %r9 = call i64 @nova_rt_bytes_get(i64 %r5, i64 %r8)
  %r10 = add i64 255, 0
  %r11 = and i64 %r9, %r10
  store i64 %r11, ptr %slot.hi, align 8
  %r12 = load i64, ptr %slot.hi, align 8
  %r13 = add i64 8, 0
  %r14.shamt = and i64 %r13, 63
  %r14.shbig = icmp uge i64 %r13, 64
  %r14.shval = shl i64 %r12, %r14.shamt
  %r14 = select i1 %r14.shbig, i64 0, i64 %r14.shval
  %r15 = load i64, ptr %slot.lo, align 8
  %r16 = or i64 %r14, %r15
  ret i64 %r16
}

; ESCAPE unpack_u32_be: allocs=0 escape=0 local=0
define i64 @unpack_u32_be(i64 %p0, i64 %p1) nounwind uwtable {
entry:
  %slot.b = alloca i64, align 8
  store i64 %p0, ptr %slot.b, align 8
  %slot.off = alloca i64, align 8
  store i64 %p1, ptr %slot.off, align 8
  %slot.b0 = alloca i64, align 8
  store i64 0, ptr %slot.b0, align 8
  %slot.b1 = alloca i64, align 8
  store i64 0, ptr %slot.b1, align 8
  %slot.b2 = alloca i64, align 8
  store i64 0, ptr %slot.b2, align 8
  %slot.b3 = alloca i64, align 8
  store i64 0, ptr %slot.b3, align 8
  %r0 = load i64, ptr %slot.b, align 8
  %r1 = load i64, ptr %slot.off, align 8
  %r2 = call i64 @nova_rt_bytes_get(i64 %r0, i64 %r1)
  %r3 = add i64 255, 0
  %r4 = and i64 %r2, %r3
  store i64 %r4, ptr %slot.b0, align 8
  %r5 = load i64, ptr %slot.b, align 8
  %r6 = load i64, ptr %slot.off, align 8
  %r7 = add i64 1, 0
  %r8 = add i64 %r6, %r7
  %r9 = call i64 @nova_rt_bytes_get(i64 %r5, i64 %r8)
  %r10 = add i64 255, 0
  %r11 = and i64 %r9, %r10
  store i64 %r11, ptr %slot.b1, align 8
  %r12 = load i64, ptr %slot.b, align 8
  %r13 = load i64, ptr %slot.off, align 8
  %r14 = add i64 2, 0
  %r15 = add i64 %r13, %r14
  %r16 = call i64 @nova_rt_bytes_get(i64 %r12, i64 %r15)
  %r17 = add i64 255, 0
  %r18 = and i64 %r16, %r17
  store i64 %r18, ptr %slot.b2, align 8
  %r19 = load i64, ptr %slot.b, align 8
  %r20 = load i64, ptr %slot.off, align 8
  %r21 = add i64 3, 0
  %r22 = add i64 %r20, %r21
  %r23 = call i64 @nova_rt_bytes_get(i64 %r19, i64 %r22)
  %r24 = add i64 255, 0
  %r25 = and i64 %r23, %r24
  store i64 %r25, ptr %slot.b3, align 8
  %r26 = load i64, ptr %slot.b0, align 8
  %r27 = add i64 24, 0
  %r28.shamt = and i64 %r27, 63
  %r28.shbig = icmp uge i64 %r27, 64
  %r28.shval = shl i64 %r26, %r28.shamt
  %r28 = select i1 %r28.shbig, i64 0, i64 %r28.shval
  %r29 = load i64, ptr %slot.b1, align 8
  %r30 = add i64 16, 0
  %r31.shamt = and i64 %r30, 63
  %r31.shbig = icmp uge i64 %r30, 64
  %r31.shval = shl i64 %r29, %r31.shamt
  %r31 = select i1 %r31.shbig, i64 0, i64 %r31.shval
  %r32 = or i64 %r28, %r31
  %r33 = load i64, ptr %slot.b2, align 8
  %r34 = add i64 8, 0
  %r35.shamt = and i64 %r34, 63
  %r35.shbig = icmp uge i64 %r34, 64
  %r35.shval = shl i64 %r33, %r35.shamt
  %r35 = select i1 %r35.shbig, i64 0, i64 %r35.shval
  %r36 = or i64 %r32, %r35
  %r37 = load i64, ptr %slot.b3, align 8
  %r38 = or i64 %r36, %r37
  ret i64 %r38
}

; ESCAPE unpack_u32_le: allocs=0 escape=0 local=0
define i64 @unpack_u32_le(i64 %p0, i64 %p1) nounwind uwtable {
entry:
  %slot.b = alloca i64, align 8
  store i64 %p0, ptr %slot.b, align 8
  %slot.off = alloca i64, align 8
  store i64 %p1, ptr %slot.off, align 8
  %slot.b0 = alloca i64, align 8
  store i64 0, ptr %slot.b0, align 8
  %slot.b1 = alloca i64, align 8
  store i64 0, ptr %slot.b1, align 8
  %slot.b2 = alloca i64, align 8
  store i64 0, ptr %slot.b2, align 8
  %slot.b3 = alloca i64, align 8
  store i64 0, ptr %slot.b3, align 8
  %r0 = load i64, ptr %slot.b, align 8
  %r1 = load i64, ptr %slot.off, align 8
  %r2 = call i64 @nova_rt_bytes_get(i64 %r0, i64 %r1)
  %r3 = add i64 255, 0
  %r4 = and i64 %r2, %r3
  store i64 %r4, ptr %slot.b0, align 8
  %r5 = load i64, ptr %slot.b, align 8
  %r6 = load i64, ptr %slot.off, align 8
  %r7 = add i64 1, 0
  %r8 = call i64 @nova_rt_add(i64 %r6, i64 %r7)
  %r9 = call i64 @nova_rt_bytes_get(i64 %r5, i64 %r8)
  %r10 = add i64 255, 0
  %r11 = and i64 %r9, %r10
  store i64 %r11, ptr %slot.b1, align 8
  %r12 = load i64, ptr %slot.b, align 8
  %r13 = load i64, ptr %slot.off, align 8
  %r14 = add i64 2, 0
  %r15 = call i64 @nova_rt_add(i64 %r13, i64 %r14)
  %r16 = call i64 @nova_rt_bytes_get(i64 %r12, i64 %r15)
  %r17 = add i64 255, 0
  %r18 = and i64 %r16, %r17
  store i64 %r18, ptr %slot.b2, align 8
  %r19 = load i64, ptr %slot.b, align 8
  %r20 = load i64, ptr %slot.off, align 8
  %r21 = add i64 3, 0
  %r22 = call i64 @nova_rt_add(i64 %r20, i64 %r21)
  %r23 = call i64 @nova_rt_bytes_get(i64 %r19, i64 %r22)
  %r24 = add i64 255, 0
  %r25 = and i64 %r23, %r24
  store i64 %r25, ptr %slot.b3, align 8
  %r26 = load i64, ptr %slot.b3, align 8
  %r27 = add i64 24, 0
  %r28.shamt = and i64 %r27, 63
  %r28.shbig = icmp uge i64 %r27, 64
  %r28.shval = shl i64 %r26, %r28.shamt
  %r28 = select i1 %r28.shbig, i64 0, i64 %r28.shval
  %r29 = load i64, ptr %slot.b2, align 8
  %r30 = add i64 16, 0
  %r31.shamt = and i64 %r30, 63
  %r31.shbig = icmp uge i64 %r30, 64
  %r31.shval = shl i64 %r29, %r31.shamt
  %r31 = select i1 %r31.shbig, i64 0, i64 %r31.shval
  %r32 = or i64 %r28, %r31
  %r33 = load i64, ptr %slot.b1, align 8
  %r34 = add i64 8, 0
  %r35.shamt = and i64 %r34, 63
  %r35.shbig = icmp uge i64 %r34, 64
  %r35.shval = shl i64 %r33, %r35.shamt
  %r35 = select i1 %r35.shbig, i64 0, i64 %r35.shval
  %r36 = or i64 %r32, %r35
  %r37 = load i64, ptr %slot.b0, align 8
  %r38 = or i64 %r36, %r37
  ret i64 %r38
}

; ESCAPE unpack_u64_be: allocs=0 escape=0 local=0
define i64 @unpack_u64_be(i64 %p0, i64 %p1) nounwind uwtable {
entry:
  %slot.b = alloca i64, align 8
  store i64 %p0, ptr %slot.b, align 8
  %slot.off = alloca i64, align 8
  store i64 %p1, ptr %slot.off, align 8
  %slot.b0 = alloca i64, align 8
  store i64 0, ptr %slot.b0, align 8
  %slot.b1 = alloca i64, align 8
  store i64 0, ptr %slot.b1, align 8
  %slot.b2 = alloca i64, align 8
  store i64 0, ptr %slot.b2, align 8
  %slot.b3 = alloca i64, align 8
  store i64 0, ptr %slot.b3, align 8
  %slot.b4 = alloca i64, align 8
  store i64 0, ptr %slot.b4, align 8
  %slot.b5 = alloca i64, align 8
  store i64 0, ptr %slot.b5, align 8
  %slot.b6 = alloca i64, align 8
  store i64 0, ptr %slot.b6, align 8
  %slot.b7 = alloca i64, align 8
  store i64 0, ptr %slot.b7, align 8
  %r0 = load i64, ptr %slot.b, align 8
  %r1 = load i64, ptr %slot.off, align 8
  %r2 = call i64 @nova_rt_bytes_get(i64 %r0, i64 %r1)
  %r3 = add i64 255, 0
  %r4 = and i64 %r2, %r3
  store i64 %r4, ptr %slot.b0, align 8
  %r5 = load i64, ptr %slot.b, align 8
  %r6 = load i64, ptr %slot.off, align 8
  %r7 = add i64 1, 0
  %r8 = call i64 @nova_rt_add(i64 %r6, i64 %r7)
  %r9 = call i64 @nova_rt_bytes_get(i64 %r5, i64 %r8)
  %r10 = add i64 255, 0
  %r11 = and i64 %r9, %r10
  store i64 %r11, ptr %slot.b1, align 8
  %r12 = load i64, ptr %slot.b, align 8
  %r13 = load i64, ptr %slot.off, align 8
  %r14 = add i64 2, 0
  %r15 = call i64 @nova_rt_add(i64 %r13, i64 %r14)
  %r16 = call i64 @nova_rt_bytes_get(i64 %r12, i64 %r15)
  %r17 = add i64 255, 0
  %r18 = and i64 %r16, %r17
  store i64 %r18, ptr %slot.b2, align 8
  %r19 = load i64, ptr %slot.b, align 8
  %r20 = load i64, ptr %slot.off, align 8
  %r21 = add i64 3, 0
  %r22 = call i64 @nova_rt_add(i64 %r20, i64 %r21)
  %r23 = call i64 @nova_rt_bytes_get(i64 %r19, i64 %r22)
  %r24 = add i64 255, 0
  %r25 = and i64 %r23, %r24
  store i64 %r25, ptr %slot.b3, align 8
  %r26 = load i64, ptr %slot.b, align 8
  %r27 = load i64, ptr %slot.off, align 8
  %r28 = add i64 4, 0
  %r29 = call i64 @nova_rt_add(i64 %r27, i64 %r28)
  %r30 = call i64 @nova_rt_bytes_get(i64 %r26, i64 %r29)
  %r31 = add i64 255, 0
  %r32 = and i64 %r30, %r31
  store i64 %r32, ptr %slot.b4, align 8
  %r33 = load i64, ptr %slot.b, align 8
  %r34 = load i64, ptr %slot.off, align 8
  %r35 = add i64 5, 0
  %r36 = call i64 @nova_rt_add(i64 %r34, i64 %r35)
  %r37 = call i64 @nova_rt_bytes_get(i64 %r33, i64 %r36)
  %r38 = add i64 255, 0
  %r39 = and i64 %r37, %r38
  store i64 %r39, ptr %slot.b5, align 8
  %r40 = load i64, ptr %slot.b, align 8
  %r41 = load i64, ptr %slot.off, align 8
  %r42 = add i64 6, 0
  %r43 = call i64 @nova_rt_add(i64 %r41, i64 %r42)
  %r44 = call i64 @nova_rt_bytes_get(i64 %r40, i64 %r43)
  %r45 = add i64 255, 0
  %r46 = and i64 %r44, %r45
  store i64 %r46, ptr %slot.b6, align 8
  %r47 = load i64, ptr %slot.b, align 8
  %r48 = load i64, ptr %slot.off, align 8
  %r49 = add i64 7, 0
  %r50 = call i64 @nova_rt_add(i64 %r48, i64 %r49)
  %r51 = call i64 @nova_rt_bytes_get(i64 %r47, i64 %r50)
  %r52 = add i64 255, 0
  %r53 = and i64 %r51, %r52
  store i64 %r53, ptr %slot.b7, align 8
  %r54 = load i64, ptr %slot.b0, align 8
  %r55 = add i64 56, 0
  %r56.shamt = and i64 %r55, 63
  %r56.shbig = icmp uge i64 %r55, 64
  %r56.shval = shl i64 %r54, %r56.shamt
  %r56 = select i1 %r56.shbig, i64 0, i64 %r56.shval
  %r57 = load i64, ptr %slot.b1, align 8
  %r58 = add i64 48, 0
  %r59.shamt = and i64 %r58, 63
  %r59.shbig = icmp uge i64 %r58, 64
  %r59.shval = shl i64 %r57, %r59.shamt
  %r59 = select i1 %r59.shbig, i64 0, i64 %r59.shval
  %r60 = or i64 %r56, %r59
  %r61 = load i64, ptr %slot.b2, align 8
  %r62 = add i64 40, 0
  %r63.shamt = and i64 %r62, 63
  %r63.shbig = icmp uge i64 %r62, 64
  %r63.shval = shl i64 %r61, %r63.shamt
  %r63 = select i1 %r63.shbig, i64 0, i64 %r63.shval
  %r64 = or i64 %r60, %r63
  %r65 = load i64, ptr %slot.b3, align 8
  %r66 = add i64 32, 0
  %r67.shamt = and i64 %r66, 63
  %r67.shbig = icmp uge i64 %r66, 64
  %r67.shval = shl i64 %r65, %r67.shamt
  %r67 = select i1 %r67.shbig, i64 0, i64 %r67.shval
  %r68 = or i64 %r64, %r67
  %r69 = load i64, ptr %slot.b4, align 8
  %r70 = add i64 24, 0
  %r71.shamt = and i64 %r70, 63
  %r71.shbig = icmp uge i64 %r70, 64
  %r71.shval = shl i64 %r69, %r71.shamt
  %r71 = select i1 %r71.shbig, i64 0, i64 %r71.shval
  %r72 = or i64 %r68, %r71
  %r73 = load i64, ptr %slot.b5, align 8
  %r74 = add i64 16, 0
  %r75.shamt = and i64 %r74, 63
  %r75.shbig = icmp uge i64 %r74, 64
  %r75.shval = shl i64 %r73, %r75.shamt
  %r75 = select i1 %r75.shbig, i64 0, i64 %r75.shval
  %r76 = or i64 %r72, %r75
  %r77 = load i64, ptr %slot.b6, align 8
  %r78 = add i64 8, 0
  %r79.shamt = and i64 %r78, 63
  %r79.shbig = icmp uge i64 %r78, 64
  %r79.shval = shl i64 %r77, %r79.shamt
  %r79 = select i1 %r79.shbig, i64 0, i64 %r79.shval
  %r80 = or i64 %r76, %r79
  %r81 = load i64, ptr %slot.b7, align 8
  %r82 = or i64 %r80, %r81
  ret i64 %r82
}

; ESCAPE unpack_u64_le: allocs=0 escape=0 local=0
define i64 @unpack_u64_le(i64 %p0, i64 %p1) nounwind uwtable {
entry:
  %slot.b = alloca i64, align 8
  store i64 %p0, ptr %slot.b, align 8
  %slot.off = alloca i64, align 8
  store i64 %p1, ptr %slot.off, align 8
  %slot.b0 = alloca i64, align 8
  store i64 0, ptr %slot.b0, align 8
  %slot.b1 = alloca i64, align 8
  store i64 0, ptr %slot.b1, align 8
  %slot.b2 = alloca i64, align 8
  store i64 0, ptr %slot.b2, align 8
  %slot.b3 = alloca i64, align 8
  store i64 0, ptr %slot.b3, align 8
  %slot.b4 = alloca i64, align 8
  store i64 0, ptr %slot.b4, align 8
  %slot.b5 = alloca i64, align 8
  store i64 0, ptr %slot.b5, align 8
  %slot.b6 = alloca i64, align 8
  store i64 0, ptr %slot.b6, align 8
  %slot.b7 = alloca i64, align 8
  store i64 0, ptr %slot.b7, align 8
  %r0 = load i64, ptr %slot.b, align 8
  %r1 = load i64, ptr %slot.off, align 8
  %r2 = call i64 @nova_rt_bytes_get(i64 %r0, i64 %r1)
  %r3 = add i64 255, 0
  %r4 = and i64 %r2, %r3
  store i64 %r4, ptr %slot.b0, align 8
  %r5 = load i64, ptr %slot.b, align 8
  %r6 = load i64, ptr %slot.off, align 8
  %r7 = add i64 1, 0
  %r8 = call i64 @nova_rt_add(i64 %r6, i64 %r7)
  %r9 = call i64 @nova_rt_bytes_get(i64 %r5, i64 %r8)
  %r10 = add i64 255, 0
  %r11 = and i64 %r9, %r10
  store i64 %r11, ptr %slot.b1, align 8
  %r12 = load i64, ptr %slot.b, align 8
  %r13 = load i64, ptr %slot.off, align 8
  %r14 = add i64 2, 0
  %r15 = call i64 @nova_rt_add(i64 %r13, i64 %r14)
  %r16 = call i64 @nova_rt_bytes_get(i64 %r12, i64 %r15)
  %r17 = add i64 255, 0
  %r18 = and i64 %r16, %r17
  store i64 %r18, ptr %slot.b2, align 8
  %r19 = load i64, ptr %slot.b, align 8
  %r20 = load i64, ptr %slot.off, align 8
  %r21 = add i64 3, 0
  %r22 = call i64 @nova_rt_add(i64 %r20, i64 %r21)
  %r23 = call i64 @nova_rt_bytes_get(i64 %r19, i64 %r22)
  %r24 = add i64 255, 0
  %r25 = and i64 %r23, %r24
  store i64 %r25, ptr %slot.b3, align 8
  %r26 = load i64, ptr %slot.b, align 8
  %r27 = load i64, ptr %slot.off, align 8
  %r28 = add i64 4, 0
  %r29 = call i64 @nova_rt_add(i64 %r27, i64 %r28)
  %r30 = call i64 @nova_rt_bytes_get(i64 %r26, i64 %r29)
  %r31 = add i64 255, 0
  %r32 = and i64 %r30, %r31
  store i64 %r32, ptr %slot.b4, align 8
  %r33 = load i64, ptr %slot.b, align 8
  %r34 = load i64, ptr %slot.off, align 8
  %r35 = add i64 5, 0
  %r36 = call i64 @nova_rt_add(i64 %r34, i64 %r35)
  %r37 = call i64 @nova_rt_bytes_get(i64 %r33, i64 %r36)
  %r38 = add i64 255, 0
  %r39 = and i64 %r37, %r38
  store i64 %r39, ptr %slot.b5, align 8
  %r40 = load i64, ptr %slot.b, align 8
  %r41 = load i64, ptr %slot.off, align 8
  %r42 = add i64 6, 0
  %r43 = call i64 @nova_rt_add(i64 %r41, i64 %r42)
  %r44 = call i64 @nova_rt_bytes_get(i64 %r40, i64 %r43)
  %r45 = add i64 255, 0
  %r46 = and i64 %r44, %r45
  store i64 %r46, ptr %slot.b6, align 8
  %r47 = load i64, ptr %slot.b, align 8
  %r48 = load i64, ptr %slot.off, align 8
  %r49 = add i64 7, 0
  %r50 = call i64 @nova_rt_add(i64 %r48, i64 %r49)
  %r51 = call i64 @nova_rt_bytes_get(i64 %r47, i64 %r50)
  %r52 = add i64 255, 0
  %r53 = and i64 %r51, %r52
  store i64 %r53, ptr %slot.b7, align 8
  %r54 = load i64, ptr %slot.b7, align 8
  %r55 = add i64 56, 0
  %r56.shamt = and i64 %r55, 63
  %r56.shbig = icmp uge i64 %r55, 64
  %r56.shval = shl i64 %r54, %r56.shamt
  %r56 = select i1 %r56.shbig, i64 0, i64 %r56.shval
  %r57 = load i64, ptr %slot.b6, align 8
  %r58 = add i64 48, 0
  %r59.shamt = and i64 %r58, 63
  %r59.shbig = icmp uge i64 %r58, 64
  %r59.shval = shl i64 %r57, %r59.shamt
  %r59 = select i1 %r59.shbig, i64 0, i64 %r59.shval
  %r60 = or i64 %r56, %r59
  %r61 = load i64, ptr %slot.b5, align 8
  %r62 = add i64 40, 0
  %r63.shamt = and i64 %r62, 63
  %r63.shbig = icmp uge i64 %r62, 64
  %r63.shval = shl i64 %r61, %r63.shamt
  %r63 = select i1 %r63.shbig, i64 0, i64 %r63.shval
  %r64 = or i64 %r60, %r63
  %r65 = load i64, ptr %slot.b4, align 8
  %r66 = add i64 32, 0
  %r67.shamt = and i64 %r66, 63
  %r67.shbig = icmp uge i64 %r66, 64
  %r67.shval = shl i64 %r65, %r67.shamt
  %r67 = select i1 %r67.shbig, i64 0, i64 %r67.shval
  %r68 = or i64 %r64, %r67
  %r69 = load i64, ptr %slot.b3, align 8
  %r70 = add i64 24, 0
  %r71.shamt = and i64 %r70, 63
  %r71.shbig = icmp uge i64 %r70, 64
  %r71.shval = shl i64 %r69, %r71.shamt
  %r71 = select i1 %r71.shbig, i64 0, i64 %r71.shval
  %r72 = or i64 %r68, %r71
  %r73 = load i64, ptr %slot.b2, align 8
  %r74 = add i64 16, 0
  %r75.shamt = and i64 %r74, 63
  %r75.shbig = icmp uge i64 %r74, 64
  %r75.shval = shl i64 %r73, %r75.shamt
  %r75 = select i1 %r75.shbig, i64 0, i64 %r75.shval
  %r76 = or i64 %r72, %r75
  %r77 = load i64, ptr %slot.b1, align 8
  %r78 = add i64 8, 0
  %r79.shamt = and i64 %r78, 63
  %r79.shbig = icmp uge i64 %r78, 64
  %r79.shval = shl i64 %r77, %r79.shamt
  %r79 = select i1 %r79.shbig, i64 0, i64 %r79.shval
  %r80 = or i64 %r76, %r79
  %r81 = load i64, ptr %slot.b0, align 8
  %r82 = or i64 %r80, %r81
  ret i64 %r82
}

; ESCAPE unpack_i8: allocs=0 escape=0 local=0
define i64 @unpack_i8(i64 %p0, i64 %p1) nounwind uwtable {
entry:
  %slot.b = alloca i64, align 8
  store i64 %p0, ptr %slot.b, align 8
  %slot.off = alloca i64, align 8
  store i64 %p1, ptr %slot.off, align 8
  %slot.u = alloca i64, align 8
  store i64 0, ptr %slot.u, align 8
  %r0 = load i64, ptr %slot.b, align 8
  %r1 = load i64, ptr %slot.off, align 8
  %r2 = call i64 @unpack_u8(i64 %r0, i64 %r1)
  store i64 %r2, ptr %slot.u, align 8
  %r3 = load i64, ptr %slot.u, align 8
  %r4 = add i64 128, 0
  %r5 = call i64 @nova_rt_ge(i64 %r3, i64 %r4)
  %br_then150 = icmp ne i64 %r5, 0
  br i1 %br_then150, label %then15, label %else16
then15:
  %r6 = load i64, ptr %slot.u, align 8
  %r7 = call i64 @_p8()
  %r8 = call i64 @nova_rt_sub(i64 %r6, i64 %r7)
  ret i64 %r8
else16:
  br label %endif17
endif17:
  %r9 = load i64, ptr %slot.u, align 8
  ret i64 %r9
}

; ESCAPE unpack_i16_be: allocs=0 escape=0 local=0
define i64 @unpack_i16_be(i64 %p0, i64 %p1) nounwind uwtable {
entry:
  %slot.b = alloca i64, align 8
  store i64 %p0, ptr %slot.b, align 8
  %slot.off = alloca i64, align 8
  store i64 %p1, ptr %slot.off, align 8
  %slot.u = alloca i64, align 8
  store i64 0, ptr %slot.u, align 8
  %r0 = load i64, ptr %slot.b, align 8
  %r1 = load i64, ptr %slot.off, align 8
  %r2 = call i64 @unpack_u16_be(i64 %r0, i64 %r1)
  store i64 %r2, ptr %slot.u, align 8
  %r3 = load i64, ptr %slot.u, align 8
  %r4 = add i64 32768, 0
  %r5 = call i64 @nova_rt_ge(i64 %r3, i64 %r4)
  %br_then180 = icmp ne i64 %r5, 0
  br i1 %br_then180, label %then18, label %else19
then18:
  %r6 = load i64, ptr %slot.u, align 8
  %r7 = call i64 @_p16()
  %r8 = call i64 @nova_rt_sub(i64 %r6, i64 %r7)
  ret i64 %r8
else19:
  br label %endif20
endif20:
  %r9 = load i64, ptr %slot.u, align 8
  ret i64 %r9
}

; ESCAPE unpack_i16_le: allocs=0 escape=0 local=0
define i64 @unpack_i16_le(i64 %p0, i64 %p1) nounwind uwtable {
entry:
  %slot.b = alloca i64, align 8
  store i64 %p0, ptr %slot.b, align 8
  %slot.off = alloca i64, align 8
  store i64 %p1, ptr %slot.off, align 8
  %slot.u = alloca i64, align 8
  store i64 0, ptr %slot.u, align 8
  %r0 = load i64, ptr %slot.b, align 8
  %r1 = load i64, ptr %slot.off, align 8
  %r2 = call i64 @unpack_u16_le(i64 %r0, i64 %r1)
  store i64 %r2, ptr %slot.u, align 8
  %r3 = load i64, ptr %slot.u, align 8
  %r4 = add i64 32768, 0
  %r5 = call i64 @nova_rt_ge(i64 %r3, i64 %r4)
  %br_then210 = icmp ne i64 %r5, 0
  br i1 %br_then210, label %then21, label %else22
then21:
  %r6 = load i64, ptr %slot.u, align 8
  %r7 = call i64 @_p16()
  %r8 = call i64 @nova_rt_sub(i64 %r6, i64 %r7)
  ret i64 %r8
else22:
  br label %endif23
endif23:
  %r9 = load i64, ptr %slot.u, align 8
  ret i64 %r9
}

; ESCAPE unpack_i32_be: allocs=0 escape=0 local=0
define i64 @unpack_i32_be(i64 %p0, i64 %p1) nounwind uwtable {
entry:
  %slot.b = alloca i64, align 8
  store i64 %p0, ptr %slot.b, align 8
  %slot.off = alloca i64, align 8
  store i64 %p1, ptr %slot.off, align 8
  %slot.u = alloca i64, align 8
  store i64 0, ptr %slot.u, align 8
  %r0 = load i64, ptr %slot.b, align 8
  %r1 = load i64, ptr %slot.off, align 8
  %r2 = call i64 @unpack_u32_be(i64 %r0, i64 %r1)
  store i64 %r2, ptr %slot.u, align 8
  %r3 = load i64, ptr %slot.u, align 8
  %r4 = add i64 2147483648, 0
  %r5 = call i64 @nova_rt_ge(i64 %r3, i64 %r4)
  %br_then240 = icmp ne i64 %r5, 0
  br i1 %br_then240, label %then24, label %else25
then24:
  %r6 = load i64, ptr %slot.u, align 8
  %r7 = call i64 @_p32()
  %r8 = call i64 @nova_rt_sub(i64 %r6, i64 %r7)
  ret i64 %r8
else25:
  br label %endif26
endif26:
  %r9 = load i64, ptr %slot.u, align 8
  ret i64 %r9
}

; ESCAPE unpack_i32_le: allocs=0 escape=0 local=0
define i64 @unpack_i32_le(i64 %p0, i64 %p1) nounwind uwtable {
entry:
  %slot.b = alloca i64, align 8
  store i64 %p0, ptr %slot.b, align 8
  %slot.off = alloca i64, align 8
  store i64 %p1, ptr %slot.off, align 8
  %slot.u = alloca i64, align 8
  store i64 0, ptr %slot.u, align 8
  %r0 = load i64, ptr %slot.b, align 8
  %r1 = load i64, ptr %slot.off, align 8
  %r2 = call i64 @unpack_u32_le(i64 %r0, i64 %r1)
  store i64 %r2, ptr %slot.u, align 8
  %r3 = load i64, ptr %slot.u, align 8
  %r4 = add i64 2147483648, 0
  %r5 = call i64 @nova_rt_ge(i64 %r3, i64 %r4)
  %br_then270 = icmp ne i64 %r5, 0
  br i1 %br_then270, label %then27, label %else28
then27:
  %r6 = load i64, ptr %slot.u, align 8
  %r7 = call i64 @_p32()
  %r8 = call i64 @nova_rt_sub(i64 %r6, i64 %r7)
  ret i64 %r8
else28:
  br label %endif29
endif29:
  %r9 = load i64, ptr %slot.u, align 8
  ret i64 %r9
}

; ESCAPE unpack_i64_be: allocs=0 escape=0 local=0
define i64 @unpack_i64_be(i64 %p0, i64 %p1) nounwind uwtable {
entry:
  %slot.b = alloca i64, align 8
  store i64 %p0, ptr %slot.b, align 8
  %slot.off = alloca i64, align 8
  store i64 %p1, ptr %slot.off, align 8
  %r0 = load i64, ptr %slot.b, align 8
  %r1 = load i64, ptr %slot.off, align 8
  %r2 = call i64 @unpack_u64_be(i64 %r0, i64 %r1)
  ret i64 %r2
}

; ESCAPE unpack_i64_le: allocs=0 escape=0 local=0
define i64 @unpack_i64_le(i64 %p0, i64 %p1) nounwind uwtable {
entry:
  %slot.b = alloca i64, align 8
  store i64 %p0, ptr %slot.b, align 8
  %slot.off = alloca i64, align 8
  store i64 %p1, ptr %slot.off, align 8
  %r0 = load i64, ptr %slot.b, align 8
  %r1 = load i64, ptr %slot.off, align 8
  %r2 = call i64 @unpack_u64_le(i64 %r0, i64 %r1)
  ret i64 %r2
}

; ESCAPE _fmt_width: allocs=0 escape=0 local=0
define i64 @_fmt_width(i64 %p0) nounwind uwtable {
entry:
  %slot.c = alloca i64, align 8
  store i64 %p0, ptr %slot.c, align 8
  %slot.__sc_30 = alloca i64, align 8
  store i64 0, ptr %slot.__sc_30, align 8
  %slot.__sc_36 = alloca i64, align 8
  store i64 0, ptr %slot.__sc_36, align 8
  %slot.__sc_42 = alloca i64, align 8
  store i64 0, ptr %slot.__sc_42, align 8
  %slot.__sc_48 = alloca i64, align 8
  store i64 0, ptr %slot.__sc_48, align 8
  %r0 = load i64, ptr %slot.c, align 8
  %r1.p = getelementptr inbounds [2 x i8], ptr @.str.0, i64 0, i64 0
  %r1 = ptrtoint ptr %r1.p to i64
  %r2 = call i64 @nova_rt_eq(i64 %r0, i64 %r1)
  store i64 %r2, ptr %slot.__sc_30, align 8
  %br_or_merge320 = icmp ne i64 %r2, 0
  br i1 %br_or_merge320, label %or_merge32, label %or_rhs31
or_rhs31:
  %r3 = load i64, ptr %slot.c, align 8
  %r4.p = getelementptr inbounds [2 x i8], ptr @.str.1, i64 0, i64 0
  %r4 = ptrtoint ptr %r4.p to i64
  %r5 = call i64 @nova_rt_eq(i64 %r3, i64 %r4)
  store i64 %r5, ptr %slot.__sc_30, align 8
  br label %or_merge32
or_merge32:
  %r6 = load i64, ptr %slot.__sc_30, align 8
  %br_then331 = icmp ne i64 %r6, 0
  br i1 %br_then331, label %then33, label %else34
then33:
  %r7 = add i64 1, 0
  ret i64 %r7
else34:
  br label %endif35
endif35:
  %r8 = load i64, ptr %slot.c, align 8
  %r9.p = getelementptr inbounds [2 x i8], ptr @.str.2, i64 0, i64 0
  %r9 = ptrtoint ptr %r9.p to i64
  %r10 = call i64 @nova_rt_eq(i64 %r8, i64 %r9)
  store i64 %r10, ptr %slot.__sc_36, align 8
  %br_or_merge382 = icmp ne i64 %r10, 0
  br i1 %br_or_merge382, label %or_merge38, label %or_rhs37
or_rhs37:
  %r11 = load i64, ptr %slot.c, align 8
  %r12.p = getelementptr inbounds [2 x i8], ptr @.str.3, i64 0, i64 0
  %r12 = ptrtoint ptr %r12.p to i64
  %r13 = call i64 @nova_rt_eq(i64 %r11, i64 %r12)
  store i64 %r13, ptr %slot.__sc_36, align 8
  br label %or_merge38
or_merge38:
  %r14 = load i64, ptr %slot.__sc_36, align 8
  %br_then393 = icmp ne i64 %r14, 0
  br i1 %br_then393, label %then39, label %else40
then39:
  %r15 = add i64 2, 0
  ret i64 %r15
else40:
  br label %endif41
endif41:
  %r16 = load i64, ptr %slot.c, align 8
  %r17.p = getelementptr inbounds [2 x i8], ptr @.str.4, i64 0, i64 0
  %r17 = ptrtoint ptr %r17.p to i64
  %r18 = call i64 @nova_rt_eq(i64 %r16, i64 %r17)
  store i64 %r18, ptr %slot.__sc_42, align 8
  %br_or_merge444 = icmp ne i64 %r18, 0
  br i1 %br_or_merge444, label %or_merge44, label %or_rhs43
or_rhs43:
  %r19 = load i64, ptr %slot.c, align 8
  %r20.p = getelementptr inbounds [2 x i8], ptr @.str.5, i64 0, i64 0
  %r20 = ptrtoint ptr %r20.p to i64
  %r21 = call i64 @nova_rt_eq(i64 %r19, i64 %r20)
  store i64 %r21, ptr %slot.__sc_42, align 8
  br label %or_merge44
or_merge44:
  %r22 = load i64, ptr %slot.__sc_42, align 8
  %br_then455 = icmp ne i64 %r22, 0
  br i1 %br_then455, label %then45, label %else46
then45:
  %r23 = add i64 4, 0
  ret i64 %r23
else46:
  br label %endif47
endif47:
  %r24 = load i64, ptr %slot.c, align 8
  %r25.p = getelementptr inbounds [2 x i8], ptr @.str.6, i64 0, i64 0
  %r25 = ptrtoint ptr %r25.p to i64
  %r26 = call i64 @nova_rt_eq(i64 %r24, i64 %r25)
  store i64 %r26, ptr %slot.__sc_48, align 8
  %br_or_merge506 = icmp ne i64 %r26, 0
  br i1 %br_or_merge506, label %or_merge50, label %or_rhs49
or_rhs49:
  %r27 = load i64, ptr %slot.c, align 8
  %r28.p = getelementptr inbounds [2 x i8], ptr @.str.7, i64 0, i64 0
  %r28 = ptrtoint ptr %r28.p to i64
  %r29 = call i64 @nova_rt_eq(i64 %r27, i64 %r28)
  store i64 %r29, ptr %slot.__sc_48, align 8
  br label %or_merge50
or_merge50:
  %r30 = load i64, ptr %slot.__sc_48, align 8
  %br_then517 = icmp ne i64 %r30, 0
  br i1 %br_then517, label %then51, label %else52
then51:
  %r31 = add i64 8, 0
  ret i64 %r31
else52:
  br label %endif53
endif53:
  %r32 = add i64 0, 0
  ret i64 %r32
}

; ESCAPE _is_fmt_char: allocs=0 escape=0 local=0
define i64 @_is_fmt_char(i64 %p0) nounwind uwtable {
entry:
  %slot.c = alloca i64, align 8
  store i64 %p0, ptr %slot.c, align 8
  %slot.__sc_54 = alloca i64, align 8
  store i64 0, ptr %slot.__sc_54, align 8
  %slot.__sc_57 = alloca i64, align 8
  store i64 0, ptr %slot.__sc_57, align 8
  %slot.__sc_60 = alloca i64, align 8
  store i64 0, ptr %slot.__sc_60, align 8
  %slot.__sc_63 = alloca i64, align 8
  store i64 0, ptr %slot.__sc_63, align 8
  %slot.__sc_66 = alloca i64, align 8
  store i64 0, ptr %slot.__sc_66, align 8
  %slot.__sc_69 = alloca i64, align 8
  store i64 0, ptr %slot.__sc_69, align 8
  %slot.__sc_72 = alloca i64, align 8
  store i64 0, ptr %slot.__sc_72, align 8
  %r0 = load i64, ptr %slot.c, align 8
  %r1.p = getelementptr inbounds [2 x i8], ptr @.str.0, i64 0, i64 0
  %r1 = ptrtoint ptr %r1.p to i64
  %r2 = call i64 @nova_rt_eq(i64 %r0, i64 %r1)
  store i64 %r2, ptr %slot.__sc_54, align 8
  %br_or_merge560 = icmp ne i64 %r2, 0
  br i1 %br_or_merge560, label %or_merge56, label %or_rhs55
or_rhs55:
  %r3 = load i64, ptr %slot.c, align 8
  %r4.p = getelementptr inbounds [2 x i8], ptr @.str.1, i64 0, i64 0
  %r4 = ptrtoint ptr %r4.p to i64
  %r5 = call i64 @nova_rt_eq(i64 %r3, i64 %r4)
  store i64 %r5, ptr %slot.__sc_54, align 8
  br label %or_merge56
or_merge56:
  %r6 = load i64, ptr %slot.__sc_54, align 8
  store i64 %r6, ptr %slot.__sc_57, align 8
  %br_or_merge591 = icmp ne i64 %r6, 0
  br i1 %br_or_merge591, label %or_merge59, label %or_rhs58
or_rhs58:
  %r7 = load i64, ptr %slot.c, align 8
  %r8.p = getelementptr inbounds [2 x i8], ptr @.str.2, i64 0, i64 0
  %r8 = ptrtoint ptr %r8.p to i64
  %r9 = call i64 @nova_rt_eq(i64 %r7, i64 %r8)
  store i64 %r9, ptr %slot.__sc_57, align 8
  br label %or_merge59
or_merge59:
  %r10 = load i64, ptr %slot.__sc_57, align 8
  store i64 %r10, ptr %slot.__sc_60, align 8
  %br_or_merge622 = icmp ne i64 %r10, 0
  br i1 %br_or_merge622, label %or_merge62, label %or_rhs61
or_rhs61:
  %r11 = load i64, ptr %slot.c, align 8
  %r12.p = getelementptr inbounds [2 x i8], ptr @.str.3, i64 0, i64 0
  %r12 = ptrtoint ptr %r12.p to i64
  %r13 = call i64 @nova_rt_eq(i64 %r11, i64 %r12)
  store i64 %r13, ptr %slot.__sc_60, align 8
  br label %or_merge62
or_merge62:
  %r14 = load i64, ptr %slot.__sc_60, align 8
  store i64 %r14, ptr %slot.__sc_63, align 8
  %br_or_merge653 = icmp ne i64 %r14, 0
  br i1 %br_or_merge653, label %or_merge65, label %or_rhs64
or_rhs64:
  %r15 = load i64, ptr %slot.c, align 8
  %r16.p = getelementptr inbounds [2 x i8], ptr @.str.4, i64 0, i64 0
  %r16 = ptrtoint ptr %r16.p to i64
  %r17 = call i64 @nova_rt_eq(i64 %r15, i64 %r16)
  store i64 %r17, ptr %slot.__sc_63, align 8
  br label %or_merge65
or_merge65:
  %r18 = load i64, ptr %slot.__sc_63, align 8
  store i64 %r18, ptr %slot.__sc_66, align 8
  %br_or_merge684 = icmp ne i64 %r18, 0
  br i1 %br_or_merge684, label %or_merge68, label %or_rhs67
or_rhs67:
  %r19 = load i64, ptr %slot.c, align 8
  %r20.p = getelementptr inbounds [2 x i8], ptr @.str.5, i64 0, i64 0
  %r20 = ptrtoint ptr %r20.p to i64
  %r21 = call i64 @nova_rt_eq(i64 %r19, i64 %r20)
  store i64 %r21, ptr %slot.__sc_66, align 8
  br label %or_merge68
or_merge68:
  %r22 = load i64, ptr %slot.__sc_66, align 8
  store i64 %r22, ptr %slot.__sc_69, align 8
  %br_or_merge715 = icmp ne i64 %r22, 0
  br i1 %br_or_merge715, label %or_merge71, label %or_rhs70
or_rhs70:
  %r23 = load i64, ptr %slot.c, align 8
  %r24.p = getelementptr inbounds [2 x i8], ptr @.str.6, i64 0, i64 0
  %r24 = ptrtoint ptr %r24.p to i64
  %r25 = call i64 @nova_rt_eq(i64 %r23, i64 %r24)
  store i64 %r25, ptr %slot.__sc_69, align 8
  br label %or_merge71
or_merge71:
  %r26 = load i64, ptr %slot.__sc_69, align 8
  store i64 %r26, ptr %slot.__sc_72, align 8
  %br_or_merge746 = icmp ne i64 %r26, 0
  br i1 %br_or_merge746, label %or_merge74, label %or_rhs73
or_rhs73:
  %r27 = load i64, ptr %slot.c, align 8
  %r28.p = getelementptr inbounds [2 x i8], ptr @.str.7, i64 0, i64 0
  %r28 = ptrtoint ptr %r28.p to i64
  %r29 = call i64 @nova_rt_eq(i64 %r27, i64 %r28)
  store i64 %r29, ptr %slot.__sc_72, align 8
  br label %or_merge74
or_merge74:
  %r30 = load i64, ptr %slot.__sc_72, align 8
  ret i64 %r30
}

; ESCAPE _pack_one: allocs=0 escape=0 local=0
define i64 @_pack_one(i64 %p0, i64 %p1, i64 %p2) nounwind uwtable {
entry:
  %slot.c = alloca i64, align 8
  store i64 %p0, ptr %slot.c, align 8
  %slot.v = alloca i64, align 8
  store i64 %p1, ptr %slot.v, align 8
  %slot.big = alloca i64, align 8
  store i64 %p2, ptr %slot.big, align 8
  %r0 = load i64, ptr %slot.c, align 8
  %r1.p = getelementptr inbounds [2 x i8], ptr @.str.0, i64 0, i64 0
  %r1 = ptrtoint ptr %r1.p to i64
  %r2 = call i64 @nova_rt_eq(i64 %r0, i64 %r1)
  %br_then750 = icmp ne i64 %r2, 0
  br i1 %br_then750, label %then75, label %else76
then75:
  %r3 = load i64, ptr %slot.v, align 8
  %r4 = call i64 @pack_u8(i64 %r3)
  ret i64 %r4
else76:
  br label %endif77
endif77:
  %r5 = load i64, ptr %slot.c, align 8
  %r6.p = getelementptr inbounds [2 x i8], ptr @.str.1, i64 0, i64 0
  %r6 = ptrtoint ptr %r6.p to i64
  %r7 = call i64 @nova_rt_eq(i64 %r5, i64 %r6)
  %br_then781 = icmp ne i64 %r7, 0
  br i1 %br_then781, label %then78, label %else79
then78:
  %r8 = load i64, ptr %slot.v, align 8
  %r9 = call i64 @pack_i8(i64 %r8)
  ret i64 %r9
else79:
  br label %endif80
endif80:
  %r10 = load i64, ptr %slot.c, align 8
  %r11.p = getelementptr inbounds [2 x i8], ptr @.str.2, i64 0, i64 0
  %r11 = ptrtoint ptr %r11.p to i64
  %r12 = call i64 @nova_rt_eq(i64 %r10, i64 %r11)
  %br_then812 = icmp ne i64 %r12, 0
  br i1 %br_then812, label %then81, label %else82
then81:
  %r13 = load i64, ptr %slot.big, align 8
  %br_then843 = icmp ne i64 %r13, 0
  br i1 %br_then843, label %then84, label %else85
then84:
  %r14 = load i64, ptr %slot.v, align 8
  %r15 = call i64 @pack_u16_be(i64 %r14)
  ret i64 %r15
else85:
  br label %endif86
endif86:
  %r16 = load i64, ptr %slot.v, align 8
  %r17 = call i64 @pack_u16_le(i64 %r16)
  ret i64 %r17
else82:
  br label %endif83
endif83:
  %r18 = load i64, ptr %slot.c, align 8
  %r19.p = getelementptr inbounds [2 x i8], ptr @.str.3, i64 0, i64 0
  %r19 = ptrtoint ptr %r19.p to i64
  %r20 = call i64 @nova_rt_eq(i64 %r18, i64 %r19)
  %br_then874 = icmp ne i64 %r20, 0
  br i1 %br_then874, label %then87, label %else88
then87:
  %r21 = load i64, ptr %slot.big, align 8
  %br_then905 = icmp ne i64 %r21, 0
  br i1 %br_then905, label %then90, label %else91
then90:
  %r22 = load i64, ptr %slot.v, align 8
  %r23 = call i64 @pack_i16_be(i64 %r22)
  ret i64 %r23
else91:
  br label %endif92
endif92:
  %r24 = load i64, ptr %slot.v, align 8
  %r25 = call i64 @pack_i16_le(i64 %r24)
  ret i64 %r25
else88:
  br label %endif89
endif89:
  %r26 = load i64, ptr %slot.c, align 8
  %r27.p = getelementptr inbounds [2 x i8], ptr @.str.4, i64 0, i64 0
  %r27 = ptrtoint ptr %r27.p to i64
  %r28 = call i64 @nova_rt_eq(i64 %r26, i64 %r27)
  %br_then936 = icmp ne i64 %r28, 0
  br i1 %br_then936, label %then93, label %else94
then93:
  %r29 = load i64, ptr %slot.big, align 8
  %br_then967 = icmp ne i64 %r29, 0
  br i1 %br_then967, label %then96, label %else97
then96:
  %r30 = load i64, ptr %slot.v, align 8
  %r31 = call i64 @pack_u32_be(i64 %r30)
  ret i64 %r31
else97:
  br label %endif98
endif98:
  %r32 = load i64, ptr %slot.v, align 8
  %r33 = call i64 @pack_u32_le(i64 %r32)
  ret i64 %r33
else94:
  br label %endif95
endif95:
  %r34 = load i64, ptr %slot.c, align 8
  %r35.p = getelementptr inbounds [2 x i8], ptr @.str.5, i64 0, i64 0
  %r35 = ptrtoint ptr %r35.p to i64
  %r36 = call i64 @nova_rt_eq(i64 %r34, i64 %r35)
  %br_then998 = icmp ne i64 %r36, 0
  br i1 %br_then998, label %then99, label %else100
then99:
  %r37 = load i64, ptr %slot.big, align 8
  %br_then1029 = icmp ne i64 %r37, 0
  br i1 %br_then1029, label %then102, label %else103
then102:
  %r38 = load i64, ptr %slot.v, align 8
  %r39 = call i64 @pack_i32_be(i64 %r38)
  ret i64 %r39
else103:
  br label %endif104
endif104:
  %r40 = load i64, ptr %slot.v, align 8
  %r41 = call i64 @pack_i32_le(i64 %r40)
  ret i64 %r41
else100:
  br label %endif101
endif101:
  %r42 = load i64, ptr %slot.c, align 8
  %r43.p = getelementptr inbounds [2 x i8], ptr @.str.6, i64 0, i64 0
  %r43 = ptrtoint ptr %r43.p to i64
  %r44 = call i64 @nova_rt_eq(i64 %r42, i64 %r43)
  %br_then10510 = icmp ne i64 %r44, 0
  br i1 %br_then10510, label %then105, label %else106
then105:
  %r45 = load i64, ptr %slot.big, align 8
  %br_then10811 = icmp ne i64 %r45, 0
  br i1 %br_then10811, label %then108, label %else109
then108:
  %r46 = load i64, ptr %slot.v, align 8
  %r47 = call i64 @pack_u64_be(i64 %r46)
  ret i64 %r47
else109:
  br label %endif110
endif110:
  %r48 = load i64, ptr %slot.v, align 8
  %r49 = call i64 @pack_u64_le(i64 %r48)
  ret i64 %r49
else106:
  br label %endif107
endif107:
  %r50 = load i64, ptr %slot.c, align 8
  %r51.p = getelementptr inbounds [2 x i8], ptr @.str.7, i64 0, i64 0
  %r51 = ptrtoint ptr %r51.p to i64
  %r52 = call i64 @nova_rt_eq(i64 %r50, i64 %r51)
  %br_then11112 = icmp ne i64 %r52, 0
  br i1 %br_then11112, label %then111, label %else112
then111:
  %r53 = load i64, ptr %slot.big, align 8
  %br_then11413 = icmp ne i64 %r53, 0
  br i1 %br_then11413, label %then114, label %else115
then114:
  %r54 = load i64, ptr %slot.v, align 8
  %r55 = call i64 @pack_i64_be(i64 %r54)
  ret i64 %r55
else115:
  br label %endif116
endif116:
  %r56 = load i64, ptr %slot.v, align 8
  %r57 = call i64 @pack_i64_le(i64 %r56)
  ret i64 %r57
else112:
  br label %endif113
endif113:
  %r58 = add i64 0, 0
  %r59 = call i64 @nova_rt_bytes_create(i64 %r58)
  ret i64 %r59
}

; ESCAPE _unpack_one: allocs=0 escape=0 local=0
define i64 @_unpack_one(i64 %p0, i64 %p1, i64 %p2, i64 %p3) nounwind uwtable {
entry:
  %slot.c = alloca i64, align 8
  store i64 %p0, ptr %slot.c, align 8
  %slot.b = alloca i64, align 8
  store i64 %p1, ptr %slot.b, align 8
  %slot.off = alloca i64, align 8
  store i64 %p2, ptr %slot.off, align 8
  %slot.big = alloca i64, align 8
  store i64 %p3, ptr %slot.big, align 8
  %r0 = load i64, ptr %slot.c, align 8
  %r1.p = getelementptr inbounds [2 x i8], ptr @.str.0, i64 0, i64 0
  %r1 = ptrtoint ptr %r1.p to i64
  %r2 = call i64 @nova_rt_eq(i64 %r0, i64 %r1)
  %br_then1170 = icmp ne i64 %r2, 0
  br i1 %br_then1170, label %then117, label %else118
then117:
  %r3 = load i64, ptr %slot.b, align 8
  %r4 = load i64, ptr %slot.off, align 8
  %r5 = call i64 @unpack_u8(i64 %r3, i64 %r4)
  ret i64 %r5
else118:
  br label %endif119
endif119:
  %r6 = load i64, ptr %slot.c, align 8
  %r7.p = getelementptr inbounds [2 x i8], ptr @.str.1, i64 0, i64 0
  %r7 = ptrtoint ptr %r7.p to i64
  %r8 = call i64 @nova_rt_eq(i64 %r6, i64 %r7)
  %br_then1201 = icmp ne i64 %r8, 0
  br i1 %br_then1201, label %then120, label %else121
then120:
  %r9 = load i64, ptr %slot.b, align 8
  %r10 = load i64, ptr %slot.off, align 8
  %r11 = call i64 @unpack_i8(i64 %r9, i64 %r10)
  ret i64 %r11
else121:
  br label %endif122
endif122:
  %r12 = load i64, ptr %slot.c, align 8
  %r13.p = getelementptr inbounds [2 x i8], ptr @.str.2, i64 0, i64 0
  %r13 = ptrtoint ptr %r13.p to i64
  %r14 = call i64 @nova_rt_eq(i64 %r12, i64 %r13)
  %br_then1232 = icmp ne i64 %r14, 0
  br i1 %br_then1232, label %then123, label %else124
then123:
  %r15 = load i64, ptr %slot.big, align 8
  %br_then1263 = icmp ne i64 %r15, 0
  br i1 %br_then1263, label %then126, label %else127
then126:
  %r16 = load i64, ptr %slot.b, align 8
  %r17 = load i64, ptr %slot.off, align 8
  %r18 = call i64 @unpack_u16_be(i64 %r16, i64 %r17)
  ret i64 %r18
else127:
  br label %endif128
endif128:
  %r19 = load i64, ptr %slot.b, align 8
  %r20 = load i64, ptr %slot.off, align 8
  %r21 = call i64 @unpack_u16_le(i64 %r19, i64 %r20)
  ret i64 %r21
else124:
  br label %endif125
endif125:
  %r22 = load i64, ptr %slot.c, align 8
  %r23.p = getelementptr inbounds [2 x i8], ptr @.str.3, i64 0, i64 0
  %r23 = ptrtoint ptr %r23.p to i64
  %r24 = call i64 @nova_rt_eq(i64 %r22, i64 %r23)
  %br_then1294 = icmp ne i64 %r24, 0
  br i1 %br_then1294, label %then129, label %else130
then129:
  %r25 = load i64, ptr %slot.big, align 8
  %br_then1325 = icmp ne i64 %r25, 0
  br i1 %br_then1325, label %then132, label %else133
then132:
  %r26 = load i64, ptr %slot.b, align 8
  %r27 = load i64, ptr %slot.off, align 8
  %r28 = call i64 @unpack_i16_be(i64 %r26, i64 %r27)
  ret i64 %r28
else133:
  br label %endif134
endif134:
  %r29 = load i64, ptr %slot.b, align 8
  %r30 = load i64, ptr %slot.off, align 8
  %r31 = call i64 @unpack_i16_le(i64 %r29, i64 %r30)
  ret i64 %r31
else130:
  br label %endif131
endif131:
  %r32 = load i64, ptr %slot.c, align 8
  %r33.p = getelementptr inbounds [2 x i8], ptr @.str.4, i64 0, i64 0
  %r33 = ptrtoint ptr %r33.p to i64
  %r34 = call i64 @nova_rt_eq(i64 %r32, i64 %r33)
  %br_then1356 = icmp ne i64 %r34, 0
  br i1 %br_then1356, label %then135, label %else136
then135:
  %r35 = load i64, ptr %slot.big, align 8
  %br_then1387 = icmp ne i64 %r35, 0
  br i1 %br_then1387, label %then138, label %else139
then138:
  %r36 = load i64, ptr %slot.b, align 8
  %r37 = load i64, ptr %slot.off, align 8
  %r38 = call i64 @unpack_u32_be(i64 %r36, i64 %r37)
  ret i64 %r38
else139:
  br label %endif140
endif140:
  %r39 = load i64, ptr %slot.b, align 8
  %r40 = load i64, ptr %slot.off, align 8
  %r41 = call i64 @unpack_u32_le(i64 %r39, i64 %r40)
  ret i64 %r41
else136:
  br label %endif137
endif137:
  %r42 = load i64, ptr %slot.c, align 8
  %r43.p = getelementptr inbounds [2 x i8], ptr @.str.5, i64 0, i64 0
  %r43 = ptrtoint ptr %r43.p to i64
  %r44 = call i64 @nova_rt_eq(i64 %r42, i64 %r43)
  %br_then1418 = icmp ne i64 %r44, 0
  br i1 %br_then1418, label %then141, label %else142
then141:
  %r45 = load i64, ptr %slot.big, align 8
  %br_then1449 = icmp ne i64 %r45, 0
  br i1 %br_then1449, label %then144, label %else145
then144:
  %r46 = load i64, ptr %slot.b, align 8
  %r47 = load i64, ptr %slot.off, align 8
  %r48 = call i64 @unpack_i32_be(i64 %r46, i64 %r47)
  ret i64 %r48
else145:
  br label %endif146
endif146:
  %r49 = load i64, ptr %slot.b, align 8
  %r50 = load i64, ptr %slot.off, align 8
  %r51 = call i64 @unpack_i32_le(i64 %r49, i64 %r50)
  ret i64 %r51
else142:
  br label %endif143
endif143:
  %r52 = load i64, ptr %slot.c, align 8
  %r53.p = getelementptr inbounds [2 x i8], ptr @.str.6, i64 0, i64 0
  %r53 = ptrtoint ptr %r53.p to i64
  %r54 = call i64 @nova_rt_eq(i64 %r52, i64 %r53)
  %br_then14710 = icmp ne i64 %r54, 0
  br i1 %br_then14710, label %then147, label %else148
then147:
  %r55 = load i64, ptr %slot.big, align 8
  %br_then15011 = icmp ne i64 %r55, 0
  br i1 %br_then15011, label %then150, label %else151
then150:
  %r56 = load i64, ptr %slot.b, align 8
  %r57 = load i64, ptr %slot.off, align 8
  %r58 = call i64 @unpack_u64_be(i64 %r56, i64 %r57)
  ret i64 %r58
else151:
  br label %endif152
endif152:
  %r59 = load i64, ptr %slot.b, align 8
  %r60 = load i64, ptr %slot.off, align 8
  %r61 = call i64 @unpack_u64_le(i64 %r59, i64 %r60)
  ret i64 %r61
else148:
  br label %endif149
endif149:
  %r62 = load i64, ptr %slot.c, align 8
  %r63.p = getelementptr inbounds [2 x i8], ptr @.str.7, i64 0, i64 0
  %r63 = ptrtoint ptr %r63.p to i64
  %r64 = call i64 @nova_rt_eq(i64 %r62, i64 %r63)
  %br_then15312 = icmp ne i64 %r64, 0
  br i1 %br_then15312, label %then153, label %else154
then153:
  %r65 = load i64, ptr %slot.big, align 8
  %br_then15613 = icmp ne i64 %r65, 0
  br i1 %br_then15613, label %then156, label %else157
then156:
  %r66 = load i64, ptr %slot.b, align 8
  %r67 = load i64, ptr %slot.off, align 8
  %r68 = call i64 @unpack_i64_be(i64 %r66, i64 %r67)
  ret i64 %r68
else157:
  br label %endif158
endif158:
  %r69 = load i64, ptr %slot.b, align 8
  %r70 = load i64, ptr %slot.off, align 8
  %r71 = call i64 @unpack_i64_le(i64 %r69, i64 %r70)
  ret i64 %r71
else154:
  br label %endif155
endif155:
  %r72 = add i64 0, 0
  ret i64 %r72
}

; ESCAPE pack_fmt: allocs=0 escape=0 local=0
define i64 @pack_fmt(i64 %p0, i64 %p1) nounwind uwtable {
entry:
  %slot.fmt = alloca i64, align 8
  store i64 %p0, ptr %slot.fmt, align 8
  %slot.vals = alloca i64, align 8
  store i64 %p1, ptr %slot.vals, align 8
  %slot.big = alloca i64, align 8
  store i64 0, ptr %slot.big, align 8
  %slot.out = alloca i64, align 8
  store i64 0, ptr %slot.out, align 8
  %slot.vi = alloca i64, align 8
  store i64 0, ptr %slot.vi, align 8
  %slot.i = alloca i64, align 8
  store i64 0, ptr %slot.i, align 8
  %slot.n = alloca i64, align 8
  store i64 0, ptr %slot.n, align 8
  %slot.fmt__s4f362 = alloca i64, align 8
  store i64 0, ptr %slot.fmt__s4f362, align 8
  %slot.c__s4f362 = alloca i64, align 8
  store i64 0, ptr %slot.c__s4f362, align 8
  %slot.piece__s4f362 = alloca i64, align 8
  store i64 0, ptr %slot.piece__s4f362, align 8
  %slot.c = alloca i64, align 8
  store i64 0, ptr %slot.c, align 8
  %slot.piece = alloca i64, align 8
  store i64 0, ptr %slot.piece, align 8
  %r0 = add i64 1, 0
  store i64 %r0, ptr %slot.big, align 8
  %r1 = add i64 0, 0
  %r2 = call i64 @nova_rt_bytes_create(i64 %r1)
  store i64 %r2, ptr %slot.out, align 8
  %r3 = add i64 0, 0
  store i64 %r3, ptr %slot.vi, align 8
  %r4 = add i64 0, 0
  store i64 %r4, ptr %slot.i, align 8
  %r5 = load i64, ptr %slot.fmt, align 8
  %r6 = call i64 @nova_rt_len_any(i64 %r5)
  store i64 %r6, ptr %slot.n, align 8
  %r7 = load i64, ptr %slot.fmt, align 8
  %r8 = call i64 @nova_rt_list_is_kind2(i64 %r7)
  %br_then1590 = icmp ne i64 %r8, 0
  br i1 %br_then1590, label %then159, label %else160
then159:
  %r9 = load i64, ptr %slot.fmt, align 8
  %r10 = call i64 @nova_rt_floatlist_view(i64 %r9)
  store i64 %r10, ptr %slot.fmt__s4f362, align 8
  br label %while_hdr162
while_hdr162:
  %r11 = load i64, ptr %slot.i, align 8
  %r12 = load i64, ptr %slot.n, align 8
  %r13.cmp = icmp slt i64 %r11, %r12
  %r13 = zext i1 %r13.cmp to i64
  %br_while_body1631 = icmp ne i64 %r13, 0
  br i1 %br_while_body1631, label %while_body163, label %while_exit164, !prof !90
while_body163:
  %r14 = load i64, ptr %slot.fmt__s4f362, align 8
  %r15 = load i64, ptr %slot.i, align 8
  %r16 = call i64 @nova_rt_index_get(i64 %r14, i64 %r15)
  store i64 %r16, ptr %slot.c__s4f362, align 8
  %r17 = load i64, ptr %slot.c__s4f362, align 8
  %r18.p = getelementptr inbounds [2 x i8], ptr @.str.8, i64 0, i64 0
  %r18 = ptrtoint ptr %r18.p to i64
  %r19 = call i64 @nova_rt_eq(i64 %r17, i64 %r18)
  %br_then1652 = icmp ne i64 %r19, 0
  br i1 %br_then1652, label %then165, label %else166
then165:
  %r20 = add i64 1, 0
  store i64 %r20, ptr %slot.big, align 8
  br label %endif167
else166:
  %r21 = load i64, ptr %slot.c__s4f362, align 8
  %r22.p = getelementptr inbounds [2 x i8], ptr @.str.9, i64 0, i64 0
  %r22 = ptrtoint ptr %r22.p to i64
  %r23 = call i64 @nova_rt_eq(i64 %r21, i64 %r22)
  %br_then1683 = icmp ne i64 %r23, 0
  br i1 %br_then1683, label %then168, label %else169
then168:
  %r24 = add i64 0, 0
  store i64 %r24, ptr %slot.big, align 8
  br label %endif170
else169:
  %r25 = load i64, ptr %slot.c__s4f362, align 8
  %r26 = call i64 @_is_fmt_char(i64 %r25)
  %r27.cmp = icmp eq i64 %r26, 0
  %r27 = zext i1 %r27.cmp to i64
  %br_then1714 = icmp ne i64 %r27, 0
  br i1 %br_then1714, label %then171, label %else172
then171:
  %r28.p = getelementptr inbounds [32 x i8], ptr @.str.10, i64 0, i64 0
  %r28 = ptrtoint ptr %r28.p to i64
  %r29 = load i64, ptr %slot.c__s4f362, align 8
  %r30 = call i64 @nova_rt_str_concat(i64 %r28, i64 %r29)
  %r31.p = getelementptr inbounds [7 x i8], ptr @.str.11, i64 0, i64 0
  %r31 = ptrtoint ptr %r31.p to i64
  %r32 = call i64 @nova_rt_str_concat(i64 %r30, i64 %r31)
  %r33 = load i64, ptr %slot.fmt__s4f362, align 8
  %r34 = call i64 @nova_rt_str_concat(i64 %r32, i64 %r33)
  %r35.p = getelementptr inbounds [2 x i8], ptr @.str.12, i64 0, i64 0
  %r35 = ptrtoint ptr %r35.p to i64
  %r36 = call i64 @nova_rt_str_concat(i64 %r34, i64 %r35)
  %r37 = call i64 @nova_rt_print_str(i64 %r36)
  %r38 = add i64 1, 0
  %r39 = call i64 @nova_rt_exit(i64 %r38)
  br label %endif173
else172:
  br label %endif173
endif173:
  %r40 = load i64, ptr %slot.c__s4f362, align 8
  %r41 = load i64, ptr %slot.vals, align 8
  %r42 = load i64, ptr %slot.vi, align 8
  %r43 = call i64 @nova_rt_index_get(i64 %r41, i64 %r42)
  %r44 = load i64, ptr %slot.big, align 8
  %r45 = call i64 @_pack_one(i64 %r40, i64 %r43, i64 %r44)
  store i64 %r45, ptr %slot.piece__s4f362, align 8
  %r46 = load i64, ptr %slot.out, align 8
  %r47 = load i64, ptr %slot.piece__s4f362, align 8
  %r48 = call i64 @nova_rt_bytes_concat(i64 %r46, i64 %r47)
  store i64 %r48, ptr %slot.out, align 8
  %r49 = load i64, ptr %slot.vi, align 8
  %r50 = add i64 1, 0
  %r51 = add i64 %r49, %r50
  store i64 %r51, ptr %slot.vi, align 8
  br label %endif170
endif170:
  br label %endif167
endif167:
  %r52 = load i64, ptr %slot.i, align 8
  %r53 = add i64 1, 0
  %r54 = add i64 %r52, %r53
  store i64 %r54, ptr %slot.i, align 8
  br label %while_hdr162
while_exit164:
  br label %endif161
else160:
  br label %while_hdr174
while_hdr174:
  %r55 = load i64, ptr %slot.i, align 8
  %r56 = load i64, ptr %slot.n, align 8
  %r57.cmp = icmp slt i64 %r55, %r56
  %r57 = zext i1 %r57.cmp to i64
  %br_while_body1755 = icmp ne i64 %r57, 0
  br i1 %br_while_body1755, label %while_body175, label %while_exit176, !prof !90
while_body175:
  %r58 = load i64, ptr %slot.fmt, align 8
  %r59 = load i64, ptr %slot.i, align 8
  %r60 = call i64 @nova_rt_index_get(i64 %r58, i64 %r59)
  store i64 %r60, ptr %slot.c, align 8
  %r61 = load i64, ptr %slot.c, align 8
  %r62.p = getelementptr inbounds [2 x i8], ptr @.str.8, i64 0, i64 0
  %r62 = ptrtoint ptr %r62.p to i64
  %r63 = call i64 @nova_rt_eq(i64 %r61, i64 %r62)
  %br_then1776 = icmp ne i64 %r63, 0
  br i1 %br_then1776, label %then177, label %else178
then177:
  %r64 = add i64 1, 0
  store i64 %r64, ptr %slot.big, align 8
  br label %endif179
else178:
  %r65 = load i64, ptr %slot.c, align 8
  %r66.p = getelementptr inbounds [2 x i8], ptr @.str.9, i64 0, i64 0
  %r66 = ptrtoint ptr %r66.p to i64
  %r67 = call i64 @nova_rt_eq(i64 %r65, i64 %r66)
  %br_then1807 = icmp ne i64 %r67, 0
  br i1 %br_then1807, label %then180, label %else181
then180:
  %r68 = add i64 0, 0
  store i64 %r68, ptr %slot.big, align 8
  br label %endif182
else181:
  %r69 = load i64, ptr %slot.c, align 8
  %r70 = call i64 @_is_fmt_char(i64 %r69)
  %r71.cmp = icmp eq i64 %r70, 0
  %r71 = zext i1 %r71.cmp to i64
  %br_then1838 = icmp ne i64 %r71, 0
  br i1 %br_then1838, label %then183, label %else184
then183:
  %r72.p = getelementptr inbounds [32 x i8], ptr @.str.10, i64 0, i64 0
  %r72 = ptrtoint ptr %r72.p to i64
  %r73 = load i64, ptr %slot.c, align 8
  %r74 = call i64 @nova_rt_str_concat(i64 %r72, i64 %r73)
  %r75.p = getelementptr inbounds [7 x i8], ptr @.str.11, i64 0, i64 0
  %r75 = ptrtoint ptr %r75.p to i64
  %r76 = call i64 @nova_rt_str_concat(i64 %r74, i64 %r75)
  %r77 = load i64, ptr %slot.fmt, align 8
  %r78 = call i64 @nova_rt_str_concat(i64 %r76, i64 %r77)
  %r79.p = getelementptr inbounds [2 x i8], ptr @.str.12, i64 0, i64 0
  %r79 = ptrtoint ptr %r79.p to i64
  %r80 = call i64 @nova_rt_str_concat(i64 %r78, i64 %r79)
  %r81 = call i64 @nova_rt_print_str(i64 %r80)
  %r82 = add i64 1, 0
  %r83 = call i64 @nova_rt_exit(i64 %r82)
  br label %endif185
else184:
  br label %endif185
endif185:
  %r84 = load i64, ptr %slot.c, align 8
  %r85 = load i64, ptr %slot.vals, align 8
  %r86 = load i64, ptr %slot.vi, align 8
  %r87 = call i64 @nova_rt_index_get(i64 %r85, i64 %r86)
  %r88 = load i64, ptr %slot.big, align 8
  %r89 = call i64 @_pack_one(i64 %r84, i64 %r87, i64 %r88)
  store i64 %r89, ptr %slot.piece, align 8
  %r90 = load i64, ptr %slot.out, align 8
  %r91 = load i64, ptr %slot.piece, align 8
  %r92 = call i64 @nova_rt_bytes_concat(i64 %r90, i64 %r91)
  store i64 %r92, ptr %slot.out, align 8
  %r93 = load i64, ptr %slot.vi, align 8
  %r94 = add i64 1, 0
  %r95 = add i64 %r93, %r94
  store i64 %r95, ptr %slot.vi, align 8
  br label %endif182
endif182:
  br label %endif179
endif179:
  %r96 = load i64, ptr %slot.i, align 8
  %r97 = add i64 1, 0
  %r98 = add i64 %r96, %r97
  store i64 %r98, ptr %slot.i, align 8
  br label %while_hdr174
while_exit176:
  br label %endif161
endif161:
  %r99 = load i64, ptr %slot.out, align 8
  ret i64 %r99
}

; ESCAPE unpack_fmt: allocs=1 escape=1 local=0
define i64 @unpack_fmt(i64 %p0, i64 %p1) nounwind uwtable {
entry:
  %slot.fmt = alloca i64, align 8
  store i64 %p0, ptr %slot.fmt, align 8
  %slot.b = alloca i64, align 8
  store i64 %p1, ptr %slot.b, align 8
  %slot.big = alloca i64, align 8
  store i64 0, ptr %slot.big, align 8
  %slot.out = alloca i64, align 8
  store i64 0, ptr %slot.out, align 8
  %slot.off = alloca i64, align 8
  store i64 0, ptr %slot.off, align 8
  %slot.i = alloca i64, align 8
  store i64 0, ptr %slot.i, align 8
  %slot.n = alloca i64, align 8
  store i64 0, ptr %slot.n, align 8
  %slot.fmt__s4f386 = alloca i64, align 8
  store i64 0, ptr %slot.fmt__s4f386, align 8
  %slot.c__s4f386 = alloca i64, align 8
  store i64 0, ptr %slot.c__s4f386, align 8
  %slot.v__s4f386 = alloca i64, align 8
  store i64 0, ptr %slot.v__s4f386, align 8
  %slot.c = alloca i64, align 8
  store i64 0, ptr %slot.c, align 8
  %slot.v = alloca i64, align 8
  store i64 0, ptr %slot.v, align 8
  %r0 = add i64 1, 0
  store i64 %r0, ptr %slot.big, align 8
  %r1 = call i64 @nova_rt_list_create()
  store i64 %r1, ptr %slot.out, align 8
  %r2 = add i64 0, 0
  store i64 %r2, ptr %slot.off, align 8
  %r3 = add i64 0, 0
  store i64 %r3, ptr %slot.i, align 8
  %r4 = load i64, ptr %slot.fmt, align 8
  %r5 = call i64 @nova_rt_len_any(i64 %r4)
  store i64 %r5, ptr %slot.n, align 8
  %r6 = load i64, ptr %slot.fmt, align 8
  %r7 = call i64 @nova_rt_list_is_kind2(i64 %r6)
  %br_then1860 = icmp ne i64 %r7, 0
  br i1 %br_then1860, label %then186, label %else187
then186:
  %r8 = load i64, ptr %slot.fmt, align 8
  %r9 = call i64 @nova_rt_floatlist_view(i64 %r8)
  store i64 %r9, ptr %slot.fmt__s4f386, align 8
  br label %while_hdr189
while_hdr189:
  %r10 = load i64, ptr %slot.i, align 8
  %r11 = load i64, ptr %slot.n, align 8
  %r12.cmp = icmp slt i64 %r10, %r11
  %r12 = zext i1 %r12.cmp to i64
  %br_while_body1901 = icmp ne i64 %r12, 0
  br i1 %br_while_body1901, label %while_body190, label %while_exit191, !prof !90
while_body190:
  %r13 = load i64, ptr %slot.fmt__s4f386, align 8
  %r14 = load i64, ptr %slot.i, align 8
  %r15 = call i64 @nova_rt_index_get(i64 %r13, i64 %r14)
  store i64 %r15, ptr %slot.c__s4f386, align 8
  %r16 = load i64, ptr %slot.c__s4f386, align 8
  %r17.p = getelementptr inbounds [2 x i8], ptr @.str.8, i64 0, i64 0
  %r17 = ptrtoint ptr %r17.p to i64
  %r18 = call i64 @nova_rt_eq(i64 %r16, i64 %r17)
  %br_then1922 = icmp ne i64 %r18, 0
  br i1 %br_then1922, label %then192, label %else193
then192:
  %r19 = add i64 1, 0
  store i64 %r19, ptr %slot.big, align 8
  br label %endif194
else193:
  %r20 = load i64, ptr %slot.c__s4f386, align 8
  %r21.p = getelementptr inbounds [2 x i8], ptr @.str.9, i64 0, i64 0
  %r21 = ptrtoint ptr %r21.p to i64
  %r22 = call i64 @nova_rt_eq(i64 %r20, i64 %r21)
  %br_then1953 = icmp ne i64 %r22, 0
  br i1 %br_then1953, label %then195, label %else196
then195:
  %r23 = add i64 0, 0
  store i64 %r23, ptr %slot.big, align 8
  br label %endif197
else196:
  %r24 = load i64, ptr %slot.c__s4f386, align 8
  %r25 = call i64 @_is_fmt_char(i64 %r24)
  %r26.cmp = icmp eq i64 %r25, 0
  %r26 = zext i1 %r26.cmp to i64
  %br_then1984 = icmp ne i64 %r26, 0
  br i1 %br_then1984, label %then198, label %else199
then198:
  %r27.p = getelementptr inbounds [34 x i8], ptr @.str.13, i64 0, i64 0
  %r27 = ptrtoint ptr %r27.p to i64
  %r28 = load i64, ptr %slot.c__s4f386, align 8
  %r29 = call i64 @nova_rt_str_concat(i64 %r27, i64 %r28)
  %r30.p = getelementptr inbounds [7 x i8], ptr @.str.11, i64 0, i64 0
  %r30 = ptrtoint ptr %r30.p to i64
  %r31 = call i64 @nova_rt_str_concat(i64 %r29, i64 %r30)
  %r32 = load i64, ptr %slot.fmt__s4f386, align 8
  %r33 = call i64 @nova_rt_str_concat(i64 %r31, i64 %r32)
  %r34.p = getelementptr inbounds [2 x i8], ptr @.str.12, i64 0, i64 0
  %r34 = ptrtoint ptr %r34.p to i64
  %r35 = call i64 @nova_rt_str_concat(i64 %r33, i64 %r34)
  %r36 = call i64 @nova_rt_print_str(i64 %r35)
  %r37 = add i64 1, 0
  %r38 = call i64 @nova_rt_exit(i64 %r37)
  br label %endif200
else199:
  br label %endif200
endif200:
  %r39 = load i64, ptr %slot.off, align 8
  %r40 = load i64, ptr %slot.c__s4f386, align 8
  %r41 = call i64 @_fmt_width(i64 %r40)
  %r42 = add i64 %r39, %r41
  %r43 = load i64, ptr %slot.b, align 8
  %r44 = call i64 @nova_rt_bytes_len(i64 %r43)
  %r45.cmp = icmp sgt i64 %r42, %r44
  %r45 = zext i1 %r45.cmp to i64
  %br_then2015 = icmp ne i64 %r45, 0
  br i1 %br_then2015, label %then201, label %else202
then201:
  %r46.p = getelementptr inbounds [42 x i8], ptr @.str.14, i64 0, i64 0
  %r46 = ptrtoint ptr %r46.p to i64
  %r47 = load i64, ptr %slot.fmt__s4f386, align 8
  %r48 = call i64 @nova_rt_str_concat(i64 %r46, i64 %r47)
  %r49.p = getelementptr inbounds [9 x i8], ptr @.str.15, i64 0, i64 0
  %r49 = ptrtoint ptr %r49.p to i64
  %r50 = call i64 @nova_rt_str_concat(i64 %r48, i64 %r49)
  %r51 = load i64, ptr %slot.off, align 8
  %r52 = load i64, ptr %slot.c__s4f386, align 8
  %r53 = call i64 @_fmt_width(i64 %r52)
  %r54 = add i64 %r51, %r53
  %r55 = call i64 @nova_rt_int_to_str(i64 %r54)
  %r56 = call i64 @nova_rt_str_concat(i64 %r50, i64 %r55)
  %r57.p = getelementptr inbounds [14 x i8], ptr @.str.16, i64 0, i64 0
  %r57 = ptrtoint ptr %r57.p to i64
  %r58 = call i64 @nova_rt_str_concat(i64 %r56, i64 %r57)
  %r59 = load i64, ptr %slot.b, align 8
  %r60 = call i64 @nova_rt_bytes_len(i64 %r59)
  %r61 = call i64 @nova_rt_int_to_str(i64 %r60)
  %r62 = call i64 @nova_rt_str_concat(i64 %r58, i64 %r61)
  %r63.p = getelementptr inbounds [2 x i8], ptr @.str.17, i64 0, i64 0
  %r63 = ptrtoint ptr %r63.p to i64
  %r64 = call i64 @nova_rt_str_concat(i64 %r62, i64 %r63)
  %r65 = call i64 @nova_rt_print_str(i64 %r64)
  %r66 = add i64 1, 0
  %r67 = call i64 @nova_rt_exit(i64 %r66)
  br label %endif203
else202:
  br label %endif203
endif203:
  %r68 = load i64, ptr %slot.c__s4f386, align 8
  %r69 = load i64, ptr %slot.b, align 8
  %r70 = load i64, ptr %slot.off, align 8
  %r71 = load i64, ptr %slot.big, align 8
  %r72 = call i64 @_unpack_one(i64 %r68, i64 %r69, i64 %r70, i64 %r71)
  store i64 %r72, ptr %slot.v__s4f386, align 8
  %r73 = load i64, ptr %slot.out, align 8
  %r74 = load i64, ptr %slot.v__s4f386, align 8
  %r75 = call i64 @nova_rt_list_append(i64 %r73, i64 %r74)
  %r76 = load i64, ptr %slot.off, align 8
  %r77 = load i64, ptr %slot.c__s4f386, align 8
  %r78 = call i64 @_fmt_width(i64 %r77)
  %r79 = add i64 %r76, %r78
  store i64 %r79, ptr %slot.off, align 8
  br label %endif197
endif197:
  br label %endif194
endif194:
  %r80 = load i64, ptr %slot.i, align 8
  %r81 = add i64 1, 0
  %r82 = add i64 %r80, %r81
  store i64 %r82, ptr %slot.i, align 8
  br label %while_hdr189
while_exit191:
  br label %endif188
else187:
  br label %while_hdr204
while_hdr204:
  %r83 = load i64, ptr %slot.i, align 8
  %r84 = load i64, ptr %slot.n, align 8
  %r85.cmp = icmp slt i64 %r83, %r84
  %r85 = zext i1 %r85.cmp to i64
  %br_while_body2056 = icmp ne i64 %r85, 0
  br i1 %br_while_body2056, label %while_body205, label %while_exit206, !prof !90
while_body205:
  %r86 = load i64, ptr %slot.fmt, align 8
  %r87 = load i64, ptr %slot.i, align 8
  %r88 = call i64 @nova_rt_index_get(i64 %r86, i64 %r87)
  store i64 %r88, ptr %slot.c, align 8
  %r89 = load i64, ptr %slot.c, align 8
  %r90.p = getelementptr inbounds [2 x i8], ptr @.str.8, i64 0, i64 0
  %r90 = ptrtoint ptr %r90.p to i64
  %r91 = call i64 @nova_rt_eq(i64 %r89, i64 %r90)
  %br_then2077 = icmp ne i64 %r91, 0
  br i1 %br_then2077, label %then207, label %else208
then207:
  %r92 = add i64 1, 0
  store i64 %r92, ptr %slot.big, align 8
  br label %endif209
else208:
  %r93 = load i64, ptr %slot.c, align 8
  %r94.p = getelementptr inbounds [2 x i8], ptr @.str.9, i64 0, i64 0
  %r94 = ptrtoint ptr %r94.p to i64
  %r95 = call i64 @nova_rt_eq(i64 %r93, i64 %r94)
  %br_then2108 = icmp ne i64 %r95, 0
  br i1 %br_then2108, label %then210, label %else211
then210:
  %r96 = add i64 0, 0
  store i64 %r96, ptr %slot.big, align 8
  br label %endif212
else211:
  %r97 = load i64, ptr %slot.c, align 8
  %r98 = call i64 @_is_fmt_char(i64 %r97)
  %r99.cmp = icmp eq i64 %r98, 0
  %r99 = zext i1 %r99.cmp to i64
  %br_then2139 = icmp ne i64 %r99, 0
  br i1 %br_then2139, label %then213, label %else214
then213:
  %r100.p = getelementptr inbounds [34 x i8], ptr @.str.13, i64 0, i64 0
  %r100 = ptrtoint ptr %r100.p to i64
  %r101 = load i64, ptr %slot.c, align 8
  %r102 = call i64 @nova_rt_str_concat(i64 %r100, i64 %r101)
  %r103.p = getelementptr inbounds [7 x i8], ptr @.str.11, i64 0, i64 0
  %r103 = ptrtoint ptr %r103.p to i64
  %r104 = call i64 @nova_rt_str_concat(i64 %r102, i64 %r103)
  %r105 = load i64, ptr %slot.fmt, align 8
  %r106 = call i64 @nova_rt_str_concat(i64 %r104, i64 %r105)
  %r107.p = getelementptr inbounds [2 x i8], ptr @.str.12, i64 0, i64 0
  %r107 = ptrtoint ptr %r107.p to i64
  %r108 = call i64 @nova_rt_str_concat(i64 %r106, i64 %r107)
  %r109 = call i64 @nova_rt_print_str(i64 %r108)
  %r110 = add i64 1, 0
  %r111 = call i64 @nova_rt_exit(i64 %r110)
  br label %endif215
else214:
  br label %endif215
endif215:
  %r112 = load i64, ptr %slot.off, align 8
  %r113 = load i64, ptr %slot.c, align 8
  %r114 = call i64 @_fmt_width(i64 %r113)
  %r115 = add i64 %r112, %r114
  %r116 = load i64, ptr %slot.b, align 8
  %r117 = call i64 @nova_rt_bytes_len(i64 %r116)
  %r118.cmp = icmp sgt i64 %r115, %r117
  %r118 = zext i1 %r118.cmp to i64
  %br_then21610 = icmp ne i64 %r118, 0
  br i1 %br_then21610, label %then216, label %else217
then216:
  %r119.p = getelementptr inbounds [42 x i8], ptr @.str.14, i64 0, i64 0
  %r119 = ptrtoint ptr %r119.p to i64
  %r120 = load i64, ptr %slot.fmt, align 8
  %r121 = call i64 @nova_rt_str_concat(i64 %r119, i64 %r120)
  %r122.p = getelementptr inbounds [9 x i8], ptr @.str.15, i64 0, i64 0
  %r122 = ptrtoint ptr %r122.p to i64
  %r123 = call i64 @nova_rt_str_concat(i64 %r121, i64 %r122)
  %r124 = load i64, ptr %slot.off, align 8
  %r125 = load i64, ptr %slot.c, align 8
  %r126 = call i64 @_fmt_width(i64 %r125)
  %r127 = add i64 %r124, %r126
  %r128 = call i64 @nova_rt_int_to_str(i64 %r127)
  %r129 = call i64 @nova_rt_str_concat(i64 %r123, i64 %r128)
  %r130.p = getelementptr inbounds [14 x i8], ptr @.str.16, i64 0, i64 0
  %r130 = ptrtoint ptr %r130.p to i64
  %r131 = call i64 @nova_rt_str_concat(i64 %r129, i64 %r130)
  %r132 = load i64, ptr %slot.b, align 8
  %r133 = call i64 @nova_rt_bytes_len(i64 %r132)
  %r134 = call i64 @nova_rt_int_to_str(i64 %r133)
  %r135 = call i64 @nova_rt_str_concat(i64 %r131, i64 %r134)
  %r136.p = getelementptr inbounds [2 x i8], ptr @.str.17, i64 0, i64 0
  %r136 = ptrtoint ptr %r136.p to i64
  %r137 = call i64 @nova_rt_str_concat(i64 %r135, i64 %r136)
  %r138 = call i64 @nova_rt_print_str(i64 %r137)
  %r139 = add i64 1, 0
  %r140 = call i64 @nova_rt_exit(i64 %r139)
  br label %endif218
else217:
  br label %endif218
endif218:
  %r141 = load i64, ptr %slot.c, align 8
  %r142 = load i64, ptr %slot.b, align 8
  %r143 = load i64, ptr %slot.off, align 8
  %r144 = load i64, ptr %slot.big, align 8
  %r145 = call i64 @_unpack_one(i64 %r141, i64 %r142, i64 %r143, i64 %r144)
  store i64 %r145, ptr %slot.v, align 8
  %r146 = load i64, ptr %slot.out, align 8
  %r147 = load i64, ptr %slot.v, align 8
  %r148 = call i64 @nova_rt_list_append(i64 %r146, i64 %r147)
  %r149 = load i64, ptr %slot.off, align 8
  %r150 = load i64, ptr %slot.c, align 8
  %r151 = call i64 @_fmt_width(i64 %r150)
  %r152 = add i64 %r149, %r151
  store i64 %r152, ptr %slot.off, align 8
  br label %endif212
endif212:
  br label %endif209
endif209:
  %r153 = load i64, ptr %slot.i, align 8
  %r154 = add i64 1, 0
  %r155 = add i64 %r153, %r154
  store i64 %r155, ptr %slot.i, align 8
  br label %while_hdr204
while_exit206:
  br label %endif188
endif188:
  %r156 = load i64, ptr %slot.out, align 8
  ret i64 %r156
}

; ESCAPE tt_stop: allocs=0 escape=0 local=0
define i64 @tt_stop() nounwind uwtable !dbg !200 {
entry:
  %r0 = add i64 0, 0, !dbg !202
  ret i64 %r0, !dbg !202
}

; ESCAPE tt_bool: allocs=0 escape=0 local=0
define i64 @tt_bool() nounwind uwtable !dbg !203 {
entry:
  %r0 = add i64 2, 0, !dbg !205
  ret i64 %r0, !dbg !205
}

; ESCAPE tt_byte: allocs=0 escape=0 local=0
define i64 @tt_byte() nounwind uwtable !dbg !206 {
entry:
  %r0 = add i64 3, 0, !dbg !208
  ret i64 %r0, !dbg !208
}

; ESCAPE tt_double: allocs=0 escape=0 local=0
define i64 @tt_double() nounwind uwtable !dbg !209 {
entry:
  %r0 = add i64 4, 0, !dbg !211
  ret i64 %r0, !dbg !211
}

; ESCAPE tt_i16: allocs=0 escape=0 local=0
define i64 @tt_i16() nounwind uwtable !dbg !212 {
entry:
  %r0 = add i64 6, 0, !dbg !214
  ret i64 %r0, !dbg !214
}

; ESCAPE tt_i32: allocs=0 escape=0 local=0
define i64 @tt_i32() nounwind uwtable !dbg !215 {
entry:
  %r0 = add i64 8, 0, !dbg !217
  ret i64 %r0, !dbg !217
}

; ESCAPE tt_i64: allocs=0 escape=0 local=0
define i64 @tt_i64() nounwind uwtable !dbg !218 {
entry:
  %r0 = add i64 10, 0, !dbg !220
  ret i64 %r0, !dbg !220
}

; ESCAPE tt_string: allocs=0 escape=0 local=0
define i64 @tt_string() nounwind uwtable !dbg !221 {
entry:
  %r0 = add i64 11, 0, !dbg !223
  ret i64 %r0, !dbg !223
}

; ESCAPE tt_struct: allocs=0 escape=0 local=0
define i64 @tt_struct() nounwind uwtable !dbg !224 {
entry:
  %r0 = add i64 12, 0, !dbg !226
  ret i64 %r0, !dbg !226
}

; ESCAPE tt_map: allocs=0 escape=0 local=0
define i64 @tt_map() nounwind uwtable !dbg !227 {
entry:
  %r0 = add i64 13, 0, !dbg !229
  ret i64 %r0, !dbg !229
}

; ESCAPE tt_set: allocs=0 escape=0 local=0
define i64 @tt_set() nounwind uwtable !dbg !230 {
entry:
  %r0 = add i64 14, 0, !dbg !232
  ret i64 %r0, !dbg !232
}

; ESCAPE tt_list: allocs=0 escape=0 local=0
define i64 @tt_list() nounwind uwtable !dbg !233 {
entry:
  %r0 = add i64 15, 0, !dbg !235
  ret i64 %r0, !dbg !235
}

; ESCAPE tmt_call: allocs=0 escape=0 local=0
define i64 @tmt_call() nounwind uwtable !dbg !236 {
entry:
  %r0 = add i64 1, 0, !dbg !238
  ret i64 %r0, !dbg !238
}

; ESCAPE tmt_reply: allocs=0 escape=0 local=0
define i64 @tmt_reply() nounwind uwtable !dbg !239 {
entry:
  %r0 = add i64 2, 0, !dbg !241
  ret i64 %r0, !dbg !241
}

; ESCAPE tmt_exception: allocs=0 escape=0 local=0
define i64 @tmt_exception() nounwind uwtable !dbg !242 {
entry:
  %r0 = add i64 3, 0, !dbg !244
  ret i64 %r0, !dbg !244
}

; ESCAPE tmt_oneway: allocs=0 escape=0 local=0
define i64 @tmt_oneway() nounwind uwtable !dbg !245 {
entry:
  %r0 = add i64 4, 0, !dbg !247
  ret i64 %r0, !dbg !247
}

; ESCAPE _th_version1: allocs=0 escape=0 local=0
define i64 @_th_version1() nounwind uwtable !dbg !248 {
entry:
  %r0 = add i64 2147549184, 0, !dbg !250
  ret i64 %r0, !dbg !250
}

; ESCAPE thrift_str: allocs=0 escape=0 local=0
define i64 @thrift_str(i64 %p0) nounwind uwtable !dbg !251 {
entry:
  %slot.v = alloca i64, align 8, !dbg !252
  store i64 %p0, ptr %slot.v, align 8, !dbg !252
  %r0 = load i64, ptr %slot.v, align 8, !dbg !253
  %r1 = call i64 @nova_rt_type_of(i64 %r0), !dbg !253
  %r2.p = getelementptr inbounds [6 x i8], ptr @.str.18, i64 0, i64 0, !dbg !253
  %r2 = ptrtoint ptr %r2.p to i64, !dbg !253
  %r3.p0 = inttoptr i64 %r1 to ptr, !dbg !253
  %r3.p1 = inttoptr i64 %r2 to ptr, !dbg !253
  %r3.sc = call i32 @strcmp(ptr %r3.p0, ptr %r3.p1), !dbg !253
  %r3.cmp = icmp eq i32 %r3.sc, 0, !dbg !253
  %r3 = zext i1 %r3.cmp to i64, !dbg !253
  %br_then2190 = icmp ne i64 %r3, 0, !dbg !253
  br i1 %br_then2190, label %then219, label %else220, !dbg !253
then219:
  %r4 = load i64, ptr %slot.v, align 8, !dbg !254
  %r5 = call i64 @nova_rt_bytes_to_str(i64 %r4), !dbg !254
  ret i64 %r5, !dbg !254
else220:
  br label %endif221, !dbg !254
endif221:
  %r6 = load i64, ptr %slot.v, align 8, !dbg !255
  %r7 = call i64 @nova_rt_type_of(i64 %r6), !dbg !255
  %r8.p = getelementptr inbounds [7 x i8], ptr @.str.19, i64 0, i64 0, !dbg !255
  %r8 = ptrtoint ptr %r8.p to i64, !dbg !255
  %r9.p0 = inttoptr i64 %r7 to ptr, !dbg !255
  %r9.p1 = inttoptr i64 %r8 to ptr, !dbg !255
  %r9.sc = call i32 @strcmp(ptr %r9.p0, ptr %r9.p1), !dbg !255
  %r9.cmp = icmp eq i32 %r9.sc, 0, !dbg !255
  %r9 = zext i1 %r9.cmp to i64, !dbg !255
  %br_then2221 = icmp ne i64 %r9, 0, !dbg !255
  br i1 %br_then2221, label %then222, label %else223, !dbg !255
then222:
  %r10 = load i64, ptr %slot.v, align 8, !dbg !256
  ret i64 %r10, !dbg !256
else223:
  br label %endif224, !dbg !256
endif224:
  %r11 = load i64, ptr %slot.v, align 8, !dbg !257
  %r12 = call i64 @nova_rt_any_to_str(i64 %r11), !dbg !257
  ret i64 %r12, !dbg !257
}

; ESCAPE _th_enc_string_or_bytes: allocs=0 escape=0 local=0
define i64 @_th_enc_string_or_bytes(i64 %p0) nounwind uwtable !dbg !258 {
entry:
  %slot.v = alloca i64, align 8, !dbg !259
  store i64 %p0, ptr %slot.v, align 8, !dbg !259
  %slot.payload = alloca i64, align 8, !dbg !259
  store i64 0, ptr %slot.payload, align 8, !dbg !259
  %slot.out = alloca i64, align 8, !dbg !259
  store i64 0, ptr %slot.out, align 8, !dbg !259
  %r0 = add i64 0, 0, !dbg !260
  %r1 = call i64 @nova_rt_bytes_create(i64 %r0), !dbg !260
  store i64 %r1, ptr %slot.payload, align 8, !dbg !260
  %r2 = load i64, ptr %slot.v, align 8, !dbg !261
  %r3 = call i64 @nova_rt_type_of(i64 %r2), !dbg !261
  %r4.p = getelementptr inbounds [6 x i8], ptr @.str.18, i64 0, i64 0, !dbg !261
  %r4 = ptrtoint ptr %r4.p to i64, !dbg !261
  %r5.p0 = inttoptr i64 %r3 to ptr, !dbg !261
  %r5.p1 = inttoptr i64 %r4 to ptr, !dbg !261
  %r5.sc = call i32 @strcmp(ptr %r5.p0, ptr %r5.p1), !dbg !261
  %r5.cmp = icmp eq i32 %r5.sc, 0, !dbg !261
  %r5 = zext i1 %r5.cmp to i64, !dbg !261
  %br_then2250 = icmp ne i64 %r5, 0, !dbg !261
  br i1 %br_then2250, label %then225, label %else226, !dbg !261
then225:
  %r6 = load i64, ptr %slot.v, align 8, !dbg !262
  store i64 %r6, ptr %slot.payload, align 8, !dbg !262
  br label %endif227, !dbg !262
else226:
  %r7 = load i64, ptr %slot.v, align 8, !dbg !263
  %r8 = call i64 @nova_rt_str_to_bytes(i64 %r7), !dbg !263
  store i64 %r8, ptr %slot.payload, align 8, !dbg !263
  br label %endif227, !dbg !263
endif227:
  %r9 = load i64, ptr %slot.payload, align 8, !dbg !264
  %r10 = call i64 @nova_rt_bytes_len(i64 %r9), !dbg !264
  %r11 = call i64 @pack_i32_be(i64 %r10), !dbg !264
  store i64 %r11, ptr %slot.out, align 8, !dbg !264
  %r12 = add i64 %r11, 0, !dbg !265
  %r13 = load i64, ptr %slot.payload, align 8, !dbg !265
  %r14 = call i64 @nova_rt_bytes_concat(i64 %r12, i64 %r13), !dbg !265
  ret i64 %r14, !dbg !265
}

; ESCAPE _th_enc_container_items: allocs=0 escape=0 local=0
define i64 @_th_enc_container_items(i64 %p0, i64 %p1) nounwind uwtable !dbg !266 {
entry:
  %slot.etype = alloca i64, align 8, !dbg !267
  store i64 %p0, ptr %slot.etype, align 8, !dbg !267
  %slot.items = alloca i64, align 8, !dbg !267
  store i64 %p1, ptr %slot.items, align 8, !dbg !267
  %slot.out = alloca i64, align 8, !dbg !267
  store i64 0, ptr %slot.out, align 8, !dbg !267
  %slot.n = alloca i64, align 8, !dbg !267
  store i64 0, ptr %slot.n, align 8, !dbg !267
  %slot.i = alloca i64, align 8, !dbg !267
  store i64 0, ptr %slot.i, align 8, !dbg !267
  %slot.items__s4f234 = alloca i64, align 8, !dbg !267
  store i64 0, ptr %slot.items__s4f234, align 8, !dbg !267
  %r0 = add i64 0, 0, !dbg !268
  %r1 = call i64 @nova_rt_bytes_create(i64 %r0), !dbg !268
  store i64 %r1, ptr %slot.out, align 8, !dbg !268
  %r2 = load i64, ptr %slot.items, align 8, !dbg !269
  %r3 = call i64 @nova_rt_len_any(i64 %r2), !dbg !269
  store i64 %r3, ptr %slot.n, align 8, !dbg !269
  %r4 = add i64 0, 0, !dbg !270
  store i64 %r4, ptr %slot.i, align 8, !dbg !270
  %r5 = load i64, ptr %slot.items, align 8, !dbg !271
  %r6 = call i64 @nova_rt_list_is_kind2(i64 %r5), !dbg !271
  %br_then2280 = icmp ne i64 %r6, 0, !dbg !271
  br i1 %br_then2280, label %then228, label %else229, !dbg !271
then228:
  %r7 = load i64, ptr %slot.items, align 8, !dbg !271
  %r8 = call i64 @nova_rt_floatlist_view(i64 %r7), !dbg !271
  store i64 %r8, ptr %slot.items__s4f234, align 8, !dbg !271
  br label %while_hdr231, !dbg !271
while_hdr231:
  %r9 = load i64, ptr %slot.i, align 8, !dbg !271
  %r10 = load i64, ptr %slot.n, align 8, !dbg !271
  %r11.cmp = icmp slt i64 %r9, %r10, !dbg !271
  %r11 = zext i1 %r11.cmp to i64, !dbg !271
  %br_while_body2321 = icmp ne i64 %r11, 0, !dbg !271
  br i1 %br_while_body2321, label %while_body232, label %while_exit233, !prof !90, !dbg !271
while_body232:
  %r12 = load i64, ptr %slot.out, align 8, !dbg !272
  %r13 = load i64, ptr %slot.etype, align 8, !dbg !272
  %r14 = load i64, ptr %slot.items__s4f234, align 8, !dbg !272
  %r15 = load i64, ptr %slot.i, align 8, !dbg !272
  %r16 = call i64 @nova_rt_list_get_f(i64 %r14, i64 %r15), !dbg !272
  %wbox0 = call i64 @nova_rt_box_float(i64 %r16), !dbg !272
  %r17 = call i64 @_th_encode_value(i64 %r13, i64 %wbox0), !dbg !272
  %r18 = call i64 @nova_rt_bytes_concat(i64 %r12, i64 %r17), !dbg !272
  store i64 %r18, ptr %slot.out, align 8, !dbg !272
  %r19 = load i64, ptr %slot.i, align 8, !dbg !273
  %r20 = add i64 1, 0, !dbg !273
  %r21 = add i64 %r19, %r20, !dbg !273
  store i64 %r21, ptr %slot.i, align 8, !dbg !273
  br label %while_hdr231, !dbg !273
while_exit233:
  br label %endif230, !dbg !273
else229:
  br label %while_hdr234, !dbg !271
while_hdr234:
  %r22 = load i64, ptr %slot.i, align 8, !dbg !271
  %r23 = load i64, ptr %slot.n, align 8, !dbg !271
  %r24.cmp = icmp slt i64 %r22, %r23, !dbg !271
  %r24 = zext i1 %r24.cmp to i64, !dbg !271
  %br_while_body2352 = icmp ne i64 %r24, 0, !dbg !271
  br i1 %br_while_body2352, label %while_body235, label %while_exit236, !prof !90, !dbg !271
while_body235:
  %r25 = load i64, ptr %slot.out, align 8, !dbg !272
  %r26 = load i64, ptr %slot.etype, align 8, !dbg !272
  %r27 = load i64, ptr %slot.items, align 8, !dbg !272
  %r28 = load i64, ptr %slot.i, align 8, !dbg !272
  %r29 = call i64 @nova_rt_index_get(i64 %r27, i64 %r28), !dbg !272
  %r30 = call i64 @_th_encode_value(i64 %r26, i64 %r29), !dbg !272
  %r31 = call i64 @nova_rt_bytes_concat(i64 %r25, i64 %r30), !dbg !272
  store i64 %r31, ptr %slot.out, align 8, !dbg !272
  %r32 = load i64, ptr %slot.i, align 8, !dbg !273
  %r33 = add i64 1, 0, !dbg !273
  %r34 = add i64 %r32, %r33, !dbg !273
  store i64 %r34, ptr %slot.i, align 8, !dbg !273
  br label %while_hdr234, !dbg !273
while_exit236:
  br label %endif230, !dbg !273
endif230:
  %r35 = load i64, ptr %slot.out, align 8, !dbg !274
  ret i64 %r35, !dbg !274
}

; ESCAPE _th_encode_value: allocs=0 escape=0 local=0
define i64 @_th_encode_value(i64 %p0, i64 %p1) nounwind uwtable !dbg !275 {
entry:
  %slot.ttype = alloca i64, align 8, !dbg !276
  store i64 %p0, ptr %slot.ttype, align 8, !dbg !276
  %slot.value = alloca i64, align 8, !dbg !276
  store i64 %p1, ptr %slot.value, align 8, !dbg !276
  %slot.bv = alloca i64, align 8, !dbg !276
  store i64 0, ptr %slot.bv, align 8, !dbg !276
  %slot.__sc_264 = alloca i64, align 8, !dbg !276
  store i64 0, ptr %slot.__sc_264, align 8, !dbg !276
  %slot.etype = alloca i64, align 8, !dbg !276
  store i64 0, ptr %slot.etype, align 8, !dbg !276
  %slot.items = alloca i64, align 8, !dbg !276
  store i64 0, ptr %slot.items, align 8, !dbg !276
  %slot.out = alloca i64, align 8, !dbg !276
  store i64 0, ptr %slot.out, align 8, !dbg !276
  %slot.ktype = alloca i64, align 8, !dbg !276
  store i64 0, ptr %slot.ktype, align 8, !dbg !276
  %slot.vtype = alloca i64, align 8, !dbg !276
  store i64 0, ptr %slot.vtype, align 8, !dbg !276
  %slot.pairs = alloca i64, align 8, !dbg !276
  store i64 0, ptr %slot.pairs, align 8, !dbg !276
  %slot.n = alloca i64, align 8, !dbg !276
  store i64 0, ptr %slot.n, align 8, !dbg !276
  %slot.i = alloca i64, align 8, !dbg !276
  store i64 0, ptr %slot.i, align 8, !dbg !276
  %slot.kv = alloca i64, align 8, !dbg !276
  store i64 0, ptr %slot.kv, align 8, !dbg !276
  %r0 = load i64, ptr %slot.ttype, align 8, !dbg !277
  %r1 = call i64 @tt_bool(), !dbg !277
  %r2.cmp = icmp eq i64 %r0, %r1, !dbg !277
  %r2 = zext i1 %r2.cmp to i64, !dbg !277
  %br_then2370 = icmp ne i64 %r2, 0, !dbg !277
  br i1 %br_then2370, label %then237, label %else238, !dbg !277
then237:
  %r3 = add i64 0, 0, !dbg !278
  store i64 %r3, ptr %slot.bv, align 8, !dbg !278
  %r4 = load i64, ptr %slot.value, align 8, !dbg !279
  %r5 = add i64 0, 0, !dbg !279
  %r6 = call i64 @nova_rt_neq(i64 %r4, i64 %r5), !dbg !279
  %br_then2401 = icmp ne i64 %r6, 0, !dbg !279
  br i1 %br_then2401, label %then240, label %else241, !dbg !279
then240:
  %r7 = add i64 1, 0, !dbg !280
  store i64 %r7, ptr %slot.bv, align 8, !dbg !280
  br label %endif242, !dbg !280
else241:
  br label %endif242, !dbg !280
endif242:
  %r8 = load i64, ptr %slot.bv, align 8, !dbg !281
  %r9 = call i64 @pack_u8(i64 %r8), !dbg !281
  ret i64 %r9, !dbg !281
else238:
  br label %endif239, !dbg !281
endif239:
  %r10 = load i64, ptr %slot.ttype, align 8, !dbg !282
  %r11 = call i64 @tt_byte(), !dbg !282
  %r12.cmp = icmp eq i64 %r10, %r11, !dbg !282
  %r12 = zext i1 %r12.cmp to i64, !dbg !282
  %br_then2432 = icmp ne i64 %r12, 0, !dbg !282
  br i1 %br_then2432, label %then243, label %else244, !dbg !282
then243:
  %r13 = load i64, ptr %slot.value, align 8, !dbg !283
  %r14 = call i64 @pack_i8(i64 %r13), !dbg !283
  ret i64 %r14, !dbg !283
else244:
  br label %endif245, !dbg !283
endif245:
  %r15 = load i64, ptr %slot.ttype, align 8, !dbg !284
  %r16 = call i64 @tt_i16(), !dbg !284
  %r17.cmp = icmp eq i64 %r15, %r16, !dbg !284
  %r17 = zext i1 %r17.cmp to i64, !dbg !284
  %br_then2463 = icmp ne i64 %r17, 0, !dbg !284
  br i1 %br_then2463, label %then246, label %else247, !dbg !284
then246:
  %r18 = load i64, ptr %slot.value, align 8, !dbg !285
  %r19 = call i64 @pack_i16_be(i64 %r18), !dbg !285
  ret i64 %r19, !dbg !285
else247:
  br label %endif248, !dbg !285
endif248:
  %r20 = load i64, ptr %slot.ttype, align 8, !dbg !286
  %r21 = call i64 @tt_i32(), !dbg !286
  %r22.cmp = icmp eq i64 %r20, %r21, !dbg !286
  %r22 = zext i1 %r22.cmp to i64, !dbg !286
  %br_then2494 = icmp ne i64 %r22, 0, !dbg !286
  br i1 %br_then2494, label %then249, label %else250, !dbg !286
then249:
  %r23 = load i64, ptr %slot.value, align 8, !dbg !287
  %r24 = call i64 @pack_i32_be(i64 %r23), !dbg !287
  ret i64 %r24, !dbg !287
else250:
  br label %endif251, !dbg !287
endif251:
  %r25 = load i64, ptr %slot.ttype, align 8, !dbg !288
  %r26 = call i64 @tt_i64(), !dbg !288
  %r27.cmp = icmp eq i64 %r25, %r26, !dbg !288
  %r27 = zext i1 %r27.cmp to i64, !dbg !288
  %br_then2525 = icmp ne i64 %r27, 0, !dbg !288
  br i1 %br_then2525, label %then252, label %else253, !dbg !288
then252:
  %r28 = load i64, ptr %slot.value, align 8, !dbg !289
  %r29 = call i64 @pack_i64_be(i64 %r28), !dbg !289
  ret i64 %r29, !dbg !289
else253:
  br label %endif254, !dbg !289
endif254:
  %r30 = load i64, ptr %slot.ttype, align 8, !dbg !290
  %r31 = call i64 @tt_double(), !dbg !290
  %r32.cmp = icmp eq i64 %r30, %r31, !dbg !290
  %r32 = zext i1 %r32.cmp to i64, !dbg !290
  %br_then2556 = icmp ne i64 %r32, 0, !dbg !290
  br i1 %br_then2556, label %then255, label %else256, !dbg !290
then255:
  %r33 = load i64, ptr %slot.value, align 8, !dbg !291
  %r34 = call i64 @nova_rt_float_to_bits(i64 %r33), !dbg !291
  %r35 = call i64 @pack_i64_be(i64 %r34), !dbg !291
  ret i64 %r35, !dbg !291
else256:
  br label %endif257, !dbg !291
endif257:
  %r36 = load i64, ptr %slot.ttype, align 8, !dbg !292
  %r37 = call i64 @tt_string(), !dbg !292
  %r38.cmp = icmp eq i64 %r36, %r37, !dbg !292
  %r38 = zext i1 %r38.cmp to i64, !dbg !292
  %br_then2587 = icmp ne i64 %r38, 0, !dbg !292
  br i1 %br_then2587, label %then258, label %else259, !dbg !292
then258:
  %r39 = load i64, ptr %slot.value, align 8, !dbg !293
  %r40 = call i64 @_th_enc_string_or_bytes(i64 %r39), !dbg !293
  ret i64 %r40, !dbg !293
else259:
  br label %endif260, !dbg !293
endif260:
  %r41 = load i64, ptr %slot.ttype, align 8, !dbg !294
  %r42 = call i64 @tt_struct(), !dbg !294
  %r43.cmp = icmp eq i64 %r41, %r42, !dbg !294
  %r43 = zext i1 %r43.cmp to i64, !dbg !294
  %br_then2618 = icmp ne i64 %r43, 0, !dbg !294
  br i1 %br_then2618, label %then261, label %else262, !dbg !294
then261:
  %r44 = load i64, ptr %slot.value, align 8, !dbg !295
  %r45 = call i64 @thrift_encode_struct(i64 %r44), !dbg !295
  ret i64 %r45, !dbg !295
else262:
  br label %endif263, !dbg !295
endif263:
  %r46 = load i64, ptr %slot.ttype, align 8, !dbg !296
  %r47 = call i64 @tt_list(), !dbg !296
  %r48.cmp = icmp eq i64 %r46, %r47, !dbg !296
  %r48 = zext i1 %r48.cmp to i64, !dbg !296
  store i64 %r48, ptr %slot.__sc_264, align 8, !dbg !296
  %br_or_merge2669 = icmp ne i64 %r48, 0, !dbg !296
  br i1 %br_or_merge2669, label %or_merge266, label %or_rhs265, !dbg !296
or_rhs265:
  %r49 = load i64, ptr %slot.ttype, align 8, !dbg !296
  %r50 = call i64 @tt_set(), !dbg !296
  %r51.cmp = icmp eq i64 %r49, %r50, !dbg !296
  %r51 = zext i1 %r51.cmp to i64, !dbg !296
  store i64 %r51, ptr %slot.__sc_264, align 8, !dbg !296
  br label %or_merge266, !dbg !296
or_merge266:
  %r52 = load i64, ptr %slot.__sc_264, align 8, !dbg !296
  %br_then26710 = icmp ne i64 %r52, 0, !dbg !296
  br i1 %br_then26710, label %then267, label %else268, !dbg !296
then267:
  %r53 = load i64, ptr %slot.value, align 8, !dbg !297
  %r54.p = getelementptr inbounds [6 x i8], ptr @.str.20, i64 0, i64 0, !dbg !297
  %r54 = ptrtoint ptr %r54.p to i64, !dbg !297
  %r55 = call i64 @nova_rt_index_get(i64 %r53, i64 %r54), !dbg !297
  store i64 %r55, ptr %slot.etype, align 8, !dbg !297
  %r56 = load i64, ptr %slot.value, align 8, !dbg !298
  %r57.p = getelementptr inbounds [6 x i8], ptr @.str.21, i64 0, i64 0, !dbg !298
  %r57 = ptrtoint ptr %r57.p to i64, !dbg !298
  %r58 = call i64 @nova_rt_index_get(i64 %r56, i64 %r57), !dbg !298
  store i64 %r58, ptr %slot.items, align 8, !dbg !298
  %r59 = add i64 %r55, 0, !dbg !299
  %r60 = call i64 @pack_u8(i64 %r59), !dbg !299
  store i64 %r60, ptr %slot.out, align 8, !dbg !299
  %r61 = add i64 %r60, 0, !dbg !300
  %r62 = add i64 %r58, 0, !dbg !300
  %r63 = call i64 @nova_rt_len_any(i64 %r62), !dbg !300
  %r64 = call i64 @pack_i32_be(i64 %r63), !dbg !300
  %r65 = call i64 @nova_rt_bytes_concat(i64 %r61, i64 %r64), !dbg !300
  store i64 %r65, ptr %slot.out, align 8, !dbg !300
  %r66 = add i64 %r65, 0, !dbg !301
  %r67 = add i64 %r55, 0, !dbg !301
  %r68 = add i64 %r58, 0, !dbg !301
  %r69 = call i64 @_th_enc_container_items(i64 %r67, i64 %r68), !dbg !301
  %r70 = call i64 @nova_rt_bytes_concat(i64 %r66, i64 %r69), !dbg !301
  ret i64 %r70, !dbg !301
else268:
  br label %endif269, !dbg !301
endif269:
  %r71 = load i64, ptr %slot.ttype, align 8, !dbg !302
  %r72 = call i64 @tt_map(), !dbg !302
  %r73.cmp = icmp eq i64 %r71, %r72, !dbg !302
  %r73 = zext i1 %r73.cmp to i64, !dbg !302
  %br_then27011 = icmp ne i64 %r73, 0, !dbg !302
  br i1 %br_then27011, label %then270, label %else271, !dbg !302
then270:
  %r74 = load i64, ptr %slot.value, align 8, !dbg !303
  %r75.p = getelementptr inbounds [6 x i8], ptr @.str.22, i64 0, i64 0, !dbg !303
  %r75 = ptrtoint ptr %r75.p to i64, !dbg !303
  %r76 = call i64 @nova_rt_index_get(i64 %r74, i64 %r75), !dbg !303
  store i64 %r76, ptr %slot.ktype, align 8, !dbg !303
  %r77 = load i64, ptr %slot.value, align 8, !dbg !304
  %r78.p = getelementptr inbounds [6 x i8], ptr @.str.23, i64 0, i64 0, !dbg !304
  %r78 = ptrtoint ptr %r78.p to i64, !dbg !304
  %r79 = call i64 @nova_rt_index_get(i64 %r77, i64 %r78), !dbg !304
  store i64 %r79, ptr %slot.vtype, align 8, !dbg !304
  %r80 = load i64, ptr %slot.value, align 8, !dbg !305
  %r81.p = getelementptr inbounds [6 x i8], ptr @.str.24, i64 0, i64 0, !dbg !305
  %r81 = ptrtoint ptr %r81.p to i64, !dbg !305
  %r82 = call i64 @nova_rt_index_get(i64 %r80, i64 %r81), !dbg !305
  store i64 %r82, ptr %slot.pairs, align 8, !dbg !305
  %r83 = add i64 %r76, 0, !dbg !306
  %r84 = call i64 @pack_u8(i64 %r83), !dbg !306
  store i64 %r84, ptr %slot.out, align 8, !dbg !306
  %r85 = add i64 %r84, 0, !dbg !307
  %r86 = add i64 %r79, 0, !dbg !307
  %r87 = call i64 @pack_u8(i64 %r86), !dbg !307
  %r88 = call i64 @nova_rt_bytes_concat(i64 %r85, i64 %r87), !dbg !307
  store i64 %r88, ptr %slot.out, align 8, !dbg !307
  %r89 = add i64 %r88, 0, !dbg !308
  %r90 = add i64 %r82, 0, !dbg !308
  %r91 = call i64 @nova_rt_len_any(i64 %r90), !dbg !308
  %r92 = call i64 @pack_i32_be(i64 %r91), !dbg !308
  %r93 = call i64 @nova_rt_bytes_concat(i64 %r89, i64 %r92), !dbg !308
  store i64 %r93, ptr %slot.out, align 8, !dbg !308
  %r94 = add i64 %r82, 0, !dbg !309
  %r95 = call i64 @nova_rt_len_any(i64 %r94), !dbg !309
  store i64 %r95, ptr %slot.n, align 8, !dbg !309
  %r96 = add i64 0, 0, !dbg !310
  store i64 %r96, ptr %slot.i, align 8, !dbg !310
  br label %while_hdr273, !dbg !311
while_hdr273:
  %r97 = load i64, ptr %slot.i, align 8, !dbg !311
  %r98 = load i64, ptr %slot.n, align 8, !dbg !311
  %r99.cmp = icmp slt i64 %r97, %r98, !dbg !311
  %r99 = zext i1 %r99.cmp to i64, !dbg !311
  %br_while_body27412 = icmp ne i64 %r99, 0, !dbg !311
  br i1 %br_while_body27412, label %while_body274, label %while_exit275, !prof !90, !dbg !311
while_body274:
  %r100 = load i64, ptr %slot.pairs, align 8, !dbg !312
  %r101 = load i64, ptr %slot.i, align 8, !dbg !312
  %r102 = call i64 @nova_rt_index_get(i64 %r100, i64 %r101), !dbg !312
  store i64 %r102, ptr %slot.kv, align 8, !dbg !312
  %r103 = load i64, ptr %slot.out, align 8, !dbg !313
  %r104 = load i64, ptr %slot.ktype, align 8, !dbg !313
  %r105 = add i64 %r102, 0, !dbg !313
  %r106 = add i64 0, 0, !dbg !313
  %r107 = call i64 @nova_rt_index_get(i64 %r105, i64 %r106), !dbg !313
  %r108 = call i64 @_th_encode_value(i64 %r104, i64 %r107), !dbg !313
  %r109 = call i64 @nova_rt_bytes_concat(i64 %r103, i64 %r108), !dbg !313
  store i64 %r109, ptr %slot.out, align 8, !dbg !313
  %r110 = add i64 %r109, 0, !dbg !314
  %r111 = load i64, ptr %slot.vtype, align 8, !dbg !314
  %r112 = add i64 %r102, 0, !dbg !314
  %r113 = add i64 1, 0, !dbg !314
  %r114 = call i64 @nova_rt_index_get(i64 %r112, i64 %r113), !dbg !314
  %r115 = call i64 @_th_encode_value(i64 %r111, i64 %r114), !dbg !314
  %r116 = call i64 @nova_rt_bytes_concat(i64 %r110, i64 %r115), !dbg !314
  store i64 %r116, ptr %slot.out, align 8, !dbg !314
  %r117 = load i64, ptr %slot.i, align 8, !dbg !315
  %r118 = add i64 1, 0, !dbg !315
  %r119 = add i64 %r117, %r118, !dbg !315
  store i64 %r119, ptr %slot.i, align 8, !dbg !315
  br label %while_hdr273, !dbg !315
while_exit275:
  %r120 = load i64, ptr %slot.out, align 8, !dbg !316
  ret i64 %r120, !dbg !316
else271:
  br label %endif272, !dbg !316
endif272:
  %r121 = add i64 0, 0, !dbg !317
  %r122 = call i64 @nova_rt_bytes_create(i64 %r121), !dbg !317
  ret i64 %r122, !dbg !317
}

; ESCAPE _th_encode_field: allocs=0 escape=0 local=0
define i64 @_th_encode_field(i64 %p0) nounwind uwtable !dbg !318 {
entry:
  %slot.f = alloca i64, align 8, !dbg !319
  store i64 %p0, ptr %slot.f, align 8, !dbg !319
  %slot.out = alloca i64, align 8, !dbg !319
  store i64 0, ptr %slot.out, align 8, !dbg !319
  %r0 = load i64, ptr %slot.f, align 8, !dbg !320
  %r1.p = getelementptr inbounds [6 x i8], ptr @.str.25, i64 0, i64 0, !dbg !320
  %r1 = ptrtoint ptr %r1.p to i64, !dbg !320
  %r2 = call i64 @nova_rt_index_get(i64 %r0, i64 %r1), !dbg !320
  %r3 = call i64 @pack_u8(i64 %r2), !dbg !320
  store i64 %r3, ptr %slot.out, align 8, !dbg !320
  %r4 = add i64 %r3, 0, !dbg !321
  %r5 = load i64, ptr %slot.f, align 8, !dbg !321
  %r6.p = getelementptr inbounds [3 x i8], ptr @.str.26, i64 0, i64 0, !dbg !321
  %r6 = ptrtoint ptr %r6.p to i64, !dbg !321
  %r7 = call i64 @nova_rt_index_get(i64 %r5, i64 %r6), !dbg !321
  %r8 = call i64 @pack_i16_be(i64 %r7), !dbg !321
  %r9 = call i64 @nova_rt_bytes_concat(i64 %r4, i64 %r8), !dbg !321
  store i64 %r9, ptr %slot.out, align 8, !dbg !321
  %r10 = add i64 %r9, 0, !dbg !322
  %r11 = load i64, ptr %slot.f, align 8, !dbg !322
  %r12.p = getelementptr inbounds [6 x i8], ptr @.str.25, i64 0, i64 0, !dbg !322
  %r12 = ptrtoint ptr %r12.p to i64, !dbg !322
  %r13 = call i64 @nova_rt_index_get(i64 %r11, i64 %r12), !dbg !322
  %r14 = load i64, ptr %slot.f, align 8, !dbg !322
  %r15.p = getelementptr inbounds [6 x i8], ptr @.str.27, i64 0, i64 0, !dbg !322
  %r15 = ptrtoint ptr %r15.p to i64, !dbg !322
  %r16 = call i64 @nova_rt_index_get(i64 %r14, i64 %r15), !dbg !322
  %r17 = call i64 @_th_encode_value(i64 %r13, i64 %r16), !dbg !322
  %r18 = call i64 @nova_rt_bytes_concat(i64 %r10, i64 %r17), !dbg !322
  ret i64 %r18, !dbg !322
}

; ESCAPE thrift_field_bool: allocs=1 escape=1 local=0
define i64 @thrift_field_bool(i64 %p0, i64 %p1) nounwind uwtable !dbg !323 {
entry:
  %slot.id = alloca i64, align 8, !dbg !324
  store i64 %p0, ptr %slot.id, align 8, !dbg !324
  %slot.v = alloca i64, align 8, !dbg !324
  store i64 %p1, ptr %slot.v, align 8, !dbg !324
  %slot.bv = alloca i64, align 8, !dbg !324
  store i64 0, ptr %slot.bv, align 8, !dbg !324
  %slot.d = alloca i64, align 8, !dbg !324
  store i64 0, ptr %slot.d, align 8, !dbg !324
  %r0 = add i64 0, 0, !dbg !325
  store i64 %r0, ptr %slot.bv, align 8, !dbg !325
  %r1 = load i64, ptr %slot.v, align 8, !dbg !326
  %r2 = add i64 0, 0, !dbg !326
  %r3 = call i64 @nova_rt_neq(i64 %r1, i64 %r2), !dbg !326
  %br_then2760 = icmp ne i64 %r3, 0, !dbg !326
  br i1 %br_then2760, label %then276, label %else277, !dbg !326
then276:
  %r4 = add i64 1, 0, !dbg !327
  store i64 %r4, ptr %slot.bv, align 8, !dbg !327
  br label %endif278, !dbg !327
else277:
  br label %endif278, !dbg !327
endif278:
  %r5 = call i64 @nova_rt_dict_create(), !dbg !328
  store i64 %r5, ptr %slot.d, align 8, !dbg !328
  %r6 = load i64, ptr %slot.id, align 8, !dbg !329
  %r7 = add i64 %r5, 0, !dbg !329
  %r8.p = getelementptr inbounds [3 x i8], ptr @.str.26, i64 0, i64 0, !dbg !329
  %r8 = ptrtoint ptr %r8.p to i64, !dbg !329
  %_is.dv1 = call i64 @nova_rt_dict_set(i64 %r7, i64 %r8, i64 %r6), !dbg !329
  %r9 = call i64 @tt_bool(), !dbg !330
  %r10 = add i64 %r5, 0, !dbg !330
  %r11.p = getelementptr inbounds [6 x i8], ptr @.str.25, i64 0, i64 0, !dbg !330
  %r11 = ptrtoint ptr %r11.p to i64, !dbg !330
  %_is.dv2 = call i64 @nova_rt_dict_set(i64 %r10, i64 %r11, i64 %r9), !dbg !330
  %r12 = load i64, ptr %slot.bv, align 8, !dbg !331
  %r13 = add i64 %r5, 0, !dbg !331
  %r14.p = getelementptr inbounds [6 x i8], ptr @.str.27, i64 0, i64 0, !dbg !331
  %r14 = ptrtoint ptr %r14.p to i64, !dbg !331
  %_is.dv3 = call i64 @nova_rt_dict_set(i64 %r13, i64 %r14, i64 %r12), !dbg !331
  %r15 = add i64 %r5, 0, !dbg !332
  ret i64 %r15, !dbg !332
}

; ESCAPE thrift_field_byte: allocs=1 escape=1 local=0
define i64 @thrift_field_byte(i64 %p0, i64 %p1) nounwind uwtable !dbg !333 {
entry:
  %slot.id = alloca i64, align 8, !dbg !334
  store i64 %p0, ptr %slot.id, align 8, !dbg !334
  %slot.v = alloca i64, align 8, !dbg !334
  store i64 %p1, ptr %slot.v, align 8, !dbg !334
  %slot.d = alloca i64, align 8, !dbg !334
  store i64 0, ptr %slot.d, align 8, !dbg !334
  %r0 = call i64 @nova_rt_dict_create(), !dbg !335
  store i64 %r0, ptr %slot.d, align 8, !dbg !335
  %r1 = load i64, ptr %slot.id, align 8, !dbg !336
  %r2 = add i64 %r0, 0, !dbg !336
  %r3.p = getelementptr inbounds [3 x i8], ptr @.str.26, i64 0, i64 0, !dbg !336
  %r3 = ptrtoint ptr %r3.p to i64, !dbg !336
  %_is.dv0 = call i64 @nova_rt_dict_set(i64 %r2, i64 %r3, i64 %r1), !dbg !336
  %r4 = call i64 @tt_byte(), !dbg !337
  %r5 = add i64 %r0, 0, !dbg !337
  %r6.p = getelementptr inbounds [6 x i8], ptr @.str.25, i64 0, i64 0, !dbg !337
  %r6 = ptrtoint ptr %r6.p to i64, !dbg !337
  %_is.dv1 = call i64 @nova_rt_dict_set(i64 %r5, i64 %r6, i64 %r4), !dbg !337
  %r7 = load i64, ptr %slot.v, align 8, !dbg !338
  %r8 = add i64 %r0, 0, !dbg !338
  %r9.p = getelementptr inbounds [6 x i8], ptr @.str.27, i64 0, i64 0, !dbg !338
  %r9 = ptrtoint ptr %r9.p to i64, !dbg !338
  %_is.dv2 = call i64 @nova_rt_dict_set(i64 %r8, i64 %r9, i64 %r7), !dbg !338
  %r10 = add i64 %r0, 0, !dbg !339
  ret i64 %r10, !dbg !339
}

; ESCAPE thrift_field_i16: allocs=1 escape=1 local=0
define i64 @thrift_field_i16(i64 %p0, i64 %p1) nounwind uwtable !dbg !340 {
entry:
  %slot.id = alloca i64, align 8, !dbg !341
  store i64 %p0, ptr %slot.id, align 8, !dbg !341
  %slot.v = alloca i64, align 8, !dbg !341
  store i64 %p1, ptr %slot.v, align 8, !dbg !341
  %slot.d = alloca i64, align 8, !dbg !341
  store i64 0, ptr %slot.d, align 8, !dbg !341
  %r0 = call i64 @nova_rt_dict_create(), !dbg !342
  store i64 %r0, ptr %slot.d, align 8, !dbg !342
  %r1 = load i64, ptr %slot.id, align 8, !dbg !343
  %r2 = add i64 %r0, 0, !dbg !343
  %r3.p = getelementptr inbounds [3 x i8], ptr @.str.26, i64 0, i64 0, !dbg !343
  %r3 = ptrtoint ptr %r3.p to i64, !dbg !343
  %_is.dv0 = call i64 @nova_rt_dict_set(i64 %r2, i64 %r3, i64 %r1), !dbg !343
  %r4 = call i64 @tt_i16(), !dbg !344
  %r5 = add i64 %r0, 0, !dbg !344
  %r6.p = getelementptr inbounds [6 x i8], ptr @.str.25, i64 0, i64 0, !dbg !344
  %r6 = ptrtoint ptr %r6.p to i64, !dbg !344
  %_is.dv1 = call i64 @nova_rt_dict_set(i64 %r5, i64 %r6, i64 %r4), !dbg !344
  %r7 = load i64, ptr %slot.v, align 8, !dbg !345
  %r8 = add i64 %r0, 0, !dbg !345
  %r9.p = getelementptr inbounds [6 x i8], ptr @.str.27, i64 0, i64 0, !dbg !345
  %r9 = ptrtoint ptr %r9.p to i64, !dbg !345
  %_is.dv2 = call i64 @nova_rt_dict_set(i64 %r8, i64 %r9, i64 %r7), !dbg !345
  %r10 = add i64 %r0, 0, !dbg !346
  ret i64 %r10, !dbg !346
}

; ESCAPE thrift_field_i32: allocs=1 escape=1 local=0
define i64 @thrift_field_i32(i64 %p0, i64 %p1) nounwind uwtable !dbg !347 {
entry:
  %slot.id = alloca i64, align 8, !dbg !348
  store i64 %p0, ptr %slot.id, align 8, !dbg !348
  %slot.v = alloca i64, align 8, !dbg !348
  store i64 %p1, ptr %slot.v, align 8, !dbg !348
  %slot.d = alloca i64, align 8, !dbg !348
  store i64 0, ptr %slot.d, align 8, !dbg !348
  %r0 = call i64 @nova_rt_dict_create(), !dbg !349
  store i64 %r0, ptr %slot.d, align 8, !dbg !349
  %r1 = load i64, ptr %slot.id, align 8, !dbg !350
  %r2 = add i64 %r0, 0, !dbg !350
  %r3.p = getelementptr inbounds [3 x i8], ptr @.str.26, i64 0, i64 0, !dbg !350
  %r3 = ptrtoint ptr %r3.p to i64, !dbg !350
  %_is.dv0 = call i64 @nova_rt_dict_set(i64 %r2, i64 %r3, i64 %r1), !dbg !350
  %r4 = call i64 @tt_i32(), !dbg !351
  %r5 = add i64 %r0, 0, !dbg !351
  %r6.p = getelementptr inbounds [6 x i8], ptr @.str.25, i64 0, i64 0, !dbg !351
  %r6 = ptrtoint ptr %r6.p to i64, !dbg !351
  %_is.dv1 = call i64 @nova_rt_dict_set(i64 %r5, i64 %r6, i64 %r4), !dbg !351
  %r7 = load i64, ptr %slot.v, align 8, !dbg !352
  %r8 = add i64 %r0, 0, !dbg !352
  %r9.p = getelementptr inbounds [6 x i8], ptr @.str.27, i64 0, i64 0, !dbg !352
  %r9 = ptrtoint ptr %r9.p to i64, !dbg !352
  %_is.dv2 = call i64 @nova_rt_dict_set(i64 %r8, i64 %r9, i64 %r7), !dbg !352
  %r10 = add i64 %r0, 0, !dbg !353
  ret i64 %r10, !dbg !353
}

; ESCAPE thrift_field_i64: allocs=1 escape=1 local=0
define i64 @thrift_field_i64(i64 %p0, i64 %p1) nounwind uwtable !dbg !354 {
entry:
  %slot.id = alloca i64, align 8, !dbg !355
  store i64 %p0, ptr %slot.id, align 8, !dbg !355
  %slot.v = alloca i64, align 8, !dbg !355
  store i64 %p1, ptr %slot.v, align 8, !dbg !355
  %slot.d = alloca i64, align 8, !dbg !355
  store i64 0, ptr %slot.d, align 8, !dbg !355
  %r0 = call i64 @nova_rt_dict_create(), !dbg !356
  store i64 %r0, ptr %slot.d, align 8, !dbg !356
  %r1 = load i64, ptr %slot.id, align 8, !dbg !357
  %r2 = add i64 %r0, 0, !dbg !357
  %r3.p = getelementptr inbounds [3 x i8], ptr @.str.26, i64 0, i64 0, !dbg !357
  %r3 = ptrtoint ptr %r3.p to i64, !dbg !357
  %_is.dv0 = call i64 @nova_rt_dict_set(i64 %r2, i64 %r3, i64 %r1), !dbg !357
  %r4 = call i64 @tt_i64(), !dbg !358
  %r5 = add i64 %r0, 0, !dbg !358
  %r6.p = getelementptr inbounds [6 x i8], ptr @.str.25, i64 0, i64 0, !dbg !358
  %r6 = ptrtoint ptr %r6.p to i64, !dbg !358
  %_is.dv1 = call i64 @nova_rt_dict_set(i64 %r5, i64 %r6, i64 %r4), !dbg !358
  %r7 = load i64, ptr %slot.v, align 8, !dbg !359
  %r8 = add i64 %r0, 0, !dbg !359
  %r9.p = getelementptr inbounds [6 x i8], ptr @.str.27, i64 0, i64 0, !dbg !359
  %r9 = ptrtoint ptr %r9.p to i64, !dbg !359
  %_is.dv2 = call i64 @nova_rt_dict_set(i64 %r8, i64 %r9, i64 %r7), !dbg !359
  %r10 = add i64 %r0, 0, !dbg !360
  ret i64 %r10, !dbg !360
}

; ESCAPE thrift_field_double: allocs=1 escape=1 local=0
define i64 @thrift_field_double(i64 %p0, i64 %p1) nounwind uwtable !dbg !361 {
entry:
  %slot.id = alloca i64, align 8, !dbg !362
  store i64 %p0, ptr %slot.id, align 8, !dbg !362
  %slot.v = alloca i64, align 8, !dbg !362
  store i64 %p1, ptr %slot.v, align 8, !dbg !362
  %slot.d = alloca i64, align 8, !dbg !362
  store i64 0, ptr %slot.d, align 8, !dbg !362
  %r0 = call i64 @nova_rt_dict_create(), !dbg !363
  store i64 %r0, ptr %slot.d, align 8, !dbg !363
  %r1 = load i64, ptr %slot.id, align 8, !dbg !364
  %r2 = add i64 %r0, 0, !dbg !364
  %r3.p = getelementptr inbounds [3 x i8], ptr @.str.26, i64 0, i64 0, !dbg !364
  %r3 = ptrtoint ptr %r3.p to i64, !dbg !364
  %_is.dv0 = call i64 @nova_rt_dict_set(i64 %r2, i64 %r3, i64 %r1), !dbg !364
  %r4 = call i64 @tt_double(), !dbg !365
  %r5 = add i64 %r0, 0, !dbg !365
  %r6.p = getelementptr inbounds [6 x i8], ptr @.str.25, i64 0, i64 0, !dbg !365
  %r6 = ptrtoint ptr %r6.p to i64, !dbg !365
  %_is.dv1 = call i64 @nova_rt_dict_set(i64 %r5, i64 %r6, i64 %r4), !dbg !365
  %r7 = load i64, ptr %slot.v, align 8, !dbg !366
  %r8 = add i64 %r0, 0, !dbg !366
  %r9.p = getelementptr inbounds [6 x i8], ptr @.str.27, i64 0, i64 0, !dbg !366
  %r9 = ptrtoint ptr %r9.p to i64, !dbg !366
  %_is.dv2 = call i64 @nova_rt_dict_set(i64 %r8, i64 %r9, i64 %r7), !dbg !366
  %r10 = add i64 %r0, 0, !dbg !367
  ret i64 %r10, !dbg !367
}

; ESCAPE thrift_field_string: allocs=1 escape=1 local=0
define i64 @thrift_field_string(i64 %p0, i64 %p1) nounwind uwtable !dbg !368 {
entry:
  %slot.id = alloca i64, align 8, !dbg !369
  store i64 %p0, ptr %slot.id, align 8, !dbg !369
  %slot.v = alloca i64, align 8, !dbg !369
  store i64 %p1, ptr %slot.v, align 8, !dbg !369
  %slot.d = alloca i64, align 8, !dbg !369
  store i64 0, ptr %slot.d, align 8, !dbg !369
  %r0 = call i64 @nova_rt_dict_create(), !dbg !370
  store i64 %r0, ptr %slot.d, align 8, !dbg !370
  %r1 = load i64, ptr %slot.id, align 8, !dbg !371
  %r2 = add i64 %r0, 0, !dbg !371
  %r3.p = getelementptr inbounds [3 x i8], ptr @.str.26, i64 0, i64 0, !dbg !371
  %r3 = ptrtoint ptr %r3.p to i64, !dbg !371
  %_is.dv0 = call i64 @nova_rt_dict_set(i64 %r2, i64 %r3, i64 %r1), !dbg !371
  %r4 = call i64 @tt_string(), !dbg !372
  %r5 = add i64 %r0, 0, !dbg !372
  %r6.p = getelementptr inbounds [6 x i8], ptr @.str.25, i64 0, i64 0, !dbg !372
  %r6 = ptrtoint ptr %r6.p to i64, !dbg !372
  %_is.dv1 = call i64 @nova_rt_dict_set(i64 %r5, i64 %r6, i64 %r4), !dbg !372
  %r7 = load i64, ptr %slot.v, align 8, !dbg !373
  %r8 = add i64 %r0, 0, !dbg !373
  %r9.p = getelementptr inbounds [6 x i8], ptr @.str.27, i64 0, i64 0, !dbg !373
  %r9 = ptrtoint ptr %r9.p to i64, !dbg !373
  %_is.dv2 = call i64 @nova_rt_dict_set(i64 %r8, i64 %r9, i64 %r7), !dbg !373
  %r10 = add i64 %r0, 0, !dbg !374
  ret i64 %r10, !dbg !374
}

; ESCAPE thrift_field_struct: allocs=1 escape=1 local=0
define i64 @thrift_field_struct(i64 %p0, i64 %p1) nounwind uwtable !dbg !375 {
entry:
  %slot.id = alloca i64, align 8, !dbg !376
  store i64 %p0, ptr %slot.id, align 8, !dbg !376
  %slot.fields = alloca i64, align 8, !dbg !376
  store i64 %p1, ptr %slot.fields, align 8, !dbg !376
  %slot.d = alloca i64, align 8, !dbg !376
  store i64 0, ptr %slot.d, align 8, !dbg !376
  %r0 = call i64 @nova_rt_dict_create(), !dbg !377
  store i64 %r0, ptr %slot.d, align 8, !dbg !377
  %r1 = load i64, ptr %slot.id, align 8, !dbg !378
  %r2 = add i64 %r0, 0, !dbg !378
  %r3.p = getelementptr inbounds [3 x i8], ptr @.str.26, i64 0, i64 0, !dbg !378
  %r3 = ptrtoint ptr %r3.p to i64, !dbg !378
  %_is.dv0 = call i64 @nova_rt_dict_set(i64 %r2, i64 %r3, i64 %r1), !dbg !378
  %r4 = call i64 @tt_struct(), !dbg !379
  %r5 = add i64 %r0, 0, !dbg !379
  %r6.p = getelementptr inbounds [6 x i8], ptr @.str.25, i64 0, i64 0, !dbg !379
  %r6 = ptrtoint ptr %r6.p to i64, !dbg !379
  %_is.dv1 = call i64 @nova_rt_dict_set(i64 %r5, i64 %r6, i64 %r4), !dbg !379
  %r7 = load i64, ptr %slot.fields, align 8, !dbg !380
  %r8 = add i64 %r0, 0, !dbg !380
  %r9.p = getelementptr inbounds [6 x i8], ptr @.str.27, i64 0, i64 0, !dbg !380
  %r9 = ptrtoint ptr %r9.p to i64, !dbg !380
  %_is.dv2 = call i64 @nova_rt_dict_set(i64 %r8, i64 %r9, i64 %r7), !dbg !380
  %r10 = add i64 %r0, 0, !dbg !381
  ret i64 %r10, !dbg !381
}

; ESCAPE thrift_field_list: allocs=2 escape=2 local=0
define i64 @thrift_field_list(i64 %p0, i64 %p1, i64 %p2) nounwind uwtable !dbg !382 {
entry:
  %slot.id = alloca i64, align 8, !dbg !383
  store i64 %p0, ptr %slot.id, align 8, !dbg !383
  %slot.etype = alloca i64, align 8, !dbg !383
  store i64 %p1, ptr %slot.etype, align 8, !dbg !383
  %slot.items = alloca i64, align 8, !dbg !383
  store i64 %p2, ptr %slot.items, align 8, !dbg !383
  %slot.c = alloca i64, align 8, !dbg !383
  store i64 0, ptr %slot.c, align 8, !dbg !383
  %slot.d = alloca i64, align 8, !dbg !383
  store i64 0, ptr %slot.d, align 8, !dbg !383
  %r0 = call i64 @nova_rt_dict_create(), !dbg !384
  store i64 %r0, ptr %slot.c, align 8, !dbg !384
  %r1 = load i64, ptr %slot.etype, align 8, !dbg !385
  %r2 = add i64 %r0, 0, !dbg !385
  %r3.p = getelementptr inbounds [6 x i8], ptr @.str.20, i64 0, i64 0, !dbg !385
  %r3 = ptrtoint ptr %r3.p to i64, !dbg !385
  %_is.dv0 = call i64 @nova_rt_dict_set(i64 %r2, i64 %r3, i64 %r1), !dbg !385
  %r4 = load i64, ptr %slot.items, align 8, !dbg !386
  %r5 = add i64 %r0, 0, !dbg !386
  %r6.p = getelementptr inbounds [6 x i8], ptr @.str.21, i64 0, i64 0, !dbg !386
  %r6 = ptrtoint ptr %r6.p to i64, !dbg !386
  %_is.dv1 = call i64 @nova_rt_dict_set(i64 %r5, i64 %r6, i64 %r4), !dbg !386
  %r7 = call i64 @nova_rt_dict_create(), !dbg !387
  store i64 %r7, ptr %slot.d, align 8, !dbg !387
  %r8 = load i64, ptr %slot.id, align 8, !dbg !388
  %r9 = add i64 %r7, 0, !dbg !388
  %r10.p = getelementptr inbounds [3 x i8], ptr @.str.26, i64 0, i64 0, !dbg !388
  %r10 = ptrtoint ptr %r10.p to i64, !dbg !388
  %_is.dv2 = call i64 @nova_rt_dict_set(i64 %r9, i64 %r10, i64 %r8), !dbg !388
  %r11 = call i64 @tt_list(), !dbg !389
  %r12 = add i64 %r7, 0, !dbg !389
  %r13.p = getelementptr inbounds [6 x i8], ptr @.str.25, i64 0, i64 0, !dbg !389
  %r13 = ptrtoint ptr %r13.p to i64, !dbg !389
  %_is.dv3 = call i64 @nova_rt_dict_set(i64 %r12, i64 %r13, i64 %r11), !dbg !389
  %r14 = add i64 %r0, 0, !dbg !390
  %r15 = add i64 %r7, 0, !dbg !390
  %r16.p = getelementptr inbounds [6 x i8], ptr @.str.27, i64 0, i64 0, !dbg !390
  %r16 = ptrtoint ptr %r16.p to i64, !dbg !390
  %_is.dv4 = call i64 @nova_rt_dict_set(i64 %r15, i64 %r16, i64 %r14), !dbg !390
  %r17 = add i64 %r7, 0, !dbg !391
  ret i64 %r17, !dbg !391
}

; ESCAPE thrift_field_set: allocs=2 escape=2 local=0
define i64 @thrift_field_set(i64 %p0, i64 %p1, i64 %p2) nounwind uwtable !dbg !392 {
entry:
  %slot.id = alloca i64, align 8, !dbg !393
  store i64 %p0, ptr %slot.id, align 8, !dbg !393
  %slot.etype = alloca i64, align 8, !dbg !393
  store i64 %p1, ptr %slot.etype, align 8, !dbg !393
  %slot.items = alloca i64, align 8, !dbg !393
  store i64 %p2, ptr %slot.items, align 8, !dbg !393
  %slot.c = alloca i64, align 8, !dbg !393
  store i64 0, ptr %slot.c, align 8, !dbg !393
  %slot.d = alloca i64, align 8, !dbg !393
  store i64 0, ptr %slot.d, align 8, !dbg !393
  %r0 = call i64 @nova_rt_dict_create(), !dbg !394
  store i64 %r0, ptr %slot.c, align 8, !dbg !394
  %r1 = load i64, ptr %slot.etype, align 8, !dbg !395
  %r2 = add i64 %r0, 0, !dbg !395
  %r3.p = getelementptr inbounds [6 x i8], ptr @.str.20, i64 0, i64 0, !dbg !395
  %r3 = ptrtoint ptr %r3.p to i64, !dbg !395
  %_is.dv0 = call i64 @nova_rt_dict_set(i64 %r2, i64 %r3, i64 %r1), !dbg !395
  %r4 = load i64, ptr %slot.items, align 8, !dbg !396
  %r5 = add i64 %r0, 0, !dbg !396
  %r6.p = getelementptr inbounds [6 x i8], ptr @.str.21, i64 0, i64 0, !dbg !396
  %r6 = ptrtoint ptr %r6.p to i64, !dbg !396
  %_is.dv1 = call i64 @nova_rt_dict_set(i64 %r5, i64 %r6, i64 %r4), !dbg !396
  %r7 = call i64 @nova_rt_dict_create(), !dbg !397
  store i64 %r7, ptr %slot.d, align 8, !dbg !397
  %r8 = load i64, ptr %slot.id, align 8, !dbg !398
  %r9 = add i64 %r7, 0, !dbg !398
  %r10.p = getelementptr inbounds [3 x i8], ptr @.str.26, i64 0, i64 0, !dbg !398
  %r10 = ptrtoint ptr %r10.p to i64, !dbg !398
  %_is.dv2 = call i64 @nova_rt_dict_set(i64 %r9, i64 %r10, i64 %r8), !dbg !398
  %r11 = call i64 @tt_set(), !dbg !399
  %r12 = add i64 %r7, 0, !dbg !399
  %r13.p = getelementptr inbounds [6 x i8], ptr @.str.25, i64 0, i64 0, !dbg !399
  %r13 = ptrtoint ptr %r13.p to i64, !dbg !399
  %_is.dv3 = call i64 @nova_rt_dict_set(i64 %r12, i64 %r13, i64 %r11), !dbg !399
  %r14 = add i64 %r0, 0, !dbg !400
  %r15 = add i64 %r7, 0, !dbg !400
  %r16.p = getelementptr inbounds [6 x i8], ptr @.str.27, i64 0, i64 0, !dbg !400
  %r16 = ptrtoint ptr %r16.p to i64, !dbg !400
  %_is.dv4 = call i64 @nova_rt_dict_set(i64 %r15, i64 %r16, i64 %r14), !dbg !400
  %r17 = add i64 %r7, 0, !dbg !401
  ret i64 %r17, !dbg !401
}

; ESCAPE thrift_field_map: allocs=2 escape=2 local=0
define i64 @thrift_field_map(i64 %p0, i64 %p1, i64 %p2, i64 %p3) nounwind uwtable !dbg !402 {
entry:
  %slot.id = alloca i64, align 8, !dbg !403
  store i64 %p0, ptr %slot.id, align 8, !dbg !403
  %slot.ktype = alloca i64, align 8, !dbg !403
  store i64 %p1, ptr %slot.ktype, align 8, !dbg !403
  %slot.vtype = alloca i64, align 8, !dbg !403
  store i64 %p2, ptr %slot.vtype, align 8, !dbg !403
  %slot.pairs = alloca i64, align 8, !dbg !403
  store i64 %p3, ptr %slot.pairs, align 8, !dbg !403
  %slot.c = alloca i64, align 8, !dbg !403
  store i64 0, ptr %slot.c, align 8, !dbg !403
  %slot.d = alloca i64, align 8, !dbg !403
  store i64 0, ptr %slot.d, align 8, !dbg !403
  %r0 = call i64 @nova_rt_dict_create(), !dbg !404
  store i64 %r0, ptr %slot.c, align 8, !dbg !404
  %r1 = load i64, ptr %slot.ktype, align 8, !dbg !405
  %r2 = add i64 %r0, 0, !dbg !405
  %r3.p = getelementptr inbounds [6 x i8], ptr @.str.22, i64 0, i64 0, !dbg !405
  %r3 = ptrtoint ptr %r3.p to i64, !dbg !405
  %_is.dv0 = call i64 @nova_rt_dict_set(i64 %r2, i64 %r3, i64 %r1), !dbg !405
  %r4 = load i64, ptr %slot.vtype, align 8, !dbg !406
  %r5 = add i64 %r0, 0, !dbg !406
  %r6.p = getelementptr inbounds [6 x i8], ptr @.str.23, i64 0, i64 0, !dbg !406
  %r6 = ptrtoint ptr %r6.p to i64, !dbg !406
  %_is.dv1 = call i64 @nova_rt_dict_set(i64 %r5, i64 %r6, i64 %r4), !dbg !406
  %r7 = load i64, ptr %slot.pairs, align 8, !dbg !407
  %r8 = add i64 %r0, 0, !dbg !407
  %r9.p = getelementptr inbounds [6 x i8], ptr @.str.24, i64 0, i64 0, !dbg !407
  %r9 = ptrtoint ptr %r9.p to i64, !dbg !407
  %_is.dv2 = call i64 @nova_rt_dict_set(i64 %r8, i64 %r9, i64 %r7), !dbg !407
  %r10 = call i64 @nova_rt_dict_create(), !dbg !408
  store i64 %r10, ptr %slot.d, align 8, !dbg !408
  %r11 = load i64, ptr %slot.id, align 8, !dbg !409
  %r12 = add i64 %r10, 0, !dbg !409
  %r13.p = getelementptr inbounds [3 x i8], ptr @.str.26, i64 0, i64 0, !dbg !409
  %r13 = ptrtoint ptr %r13.p to i64, !dbg !409
  %_is.dv3 = call i64 @nova_rt_dict_set(i64 %r12, i64 %r13, i64 %r11), !dbg !409
  %r14 = call i64 @tt_map(), !dbg !410
  %r15 = add i64 %r10, 0, !dbg !410
  %r16.p = getelementptr inbounds [6 x i8], ptr @.str.25, i64 0, i64 0, !dbg !410
  %r16 = ptrtoint ptr %r16.p to i64, !dbg !410
  %_is.dv4 = call i64 @nova_rt_dict_set(i64 %r15, i64 %r16, i64 %r14), !dbg !410
  %r17 = add i64 %r0, 0, !dbg !411
  %r18 = add i64 %r10, 0, !dbg !411
  %r19.p = getelementptr inbounds [6 x i8], ptr @.str.27, i64 0, i64 0, !dbg !411
  %r19 = ptrtoint ptr %r19.p to i64, !dbg !411
  %_is.dv5 = call i64 @nova_rt_dict_set(i64 %r18, i64 %r19, i64 %r17), !dbg !411
  %r20 = add i64 %r10, 0, !dbg !412
  ret i64 %r20, !dbg !412
}

; ESCAPE thrift_encode_struct: allocs=0 escape=0 local=0
define i64 @thrift_encode_struct(i64 %p0) nounwind uwtable !dbg !413 {
entry:
  %slot.fields = alloca i64, align 8, !dbg !414
  store i64 %p0, ptr %slot.fields, align 8, !dbg !414
  %slot.out = alloca i64, align 8, !dbg !414
  store i64 0, ptr %slot.out, align 8, !dbg !414
  %slot.n = alloca i64, align 8, !dbg !414
  store i64 0, ptr %slot.n, align 8, !dbg !414
  %slot.i = alloca i64, align 8, !dbg !414
  store i64 0, ptr %slot.i, align 8, !dbg !414
  %slot.fields__s4f391 = alloca i64, align 8, !dbg !414
  store i64 0, ptr %slot.fields__s4f391, align 8, !dbg !414
  %r0 = add i64 0, 0, !dbg !415
  %r1 = call i64 @nova_rt_bytes_create(i64 %r0), !dbg !415
  store i64 %r1, ptr %slot.out, align 8, !dbg !415
  %r2 = load i64, ptr %slot.fields, align 8, !dbg !416
  %r3 = call i64 @nova_rt_len_any(i64 %r2), !dbg !416
  store i64 %r3, ptr %slot.n, align 8, !dbg !416
  %r4 = add i64 0, 0, !dbg !417
  store i64 %r4, ptr %slot.i, align 8, !dbg !417
  %r5 = load i64, ptr %slot.fields, align 8, !dbg !418
  %r6 = call i64 @nova_rt_list_is_kind2(i64 %r5), !dbg !418
  %br_then2790 = icmp ne i64 %r6, 0, !dbg !418
  br i1 %br_then2790, label %then279, label %else280, !dbg !418
then279:
  %r7 = load i64, ptr %slot.fields, align 8, !dbg !418
  %r8 = call i64 @nova_rt_floatlist_view(i64 %r7), !dbg !418
  store i64 %r8, ptr %slot.fields__s4f391, align 8, !dbg !418
  br label %while_hdr282, !dbg !418
while_hdr282:
  %r9 = load i64, ptr %slot.i, align 8, !dbg !418
  %r10 = load i64, ptr %slot.n, align 8, !dbg !418
  %r11.cmp = icmp slt i64 %r9, %r10, !dbg !418
  %r11 = zext i1 %r11.cmp to i64, !dbg !418
  %br_while_body2831 = icmp ne i64 %r11, 0, !dbg !418
  br i1 %br_while_body2831, label %while_body283, label %while_exit284, !prof !90, !dbg !418
while_body283:
  %r12 = load i64, ptr %slot.out, align 8, !dbg !419
  %r13 = load i64, ptr %slot.fields__s4f391, align 8, !dbg !419
  %r14 = load i64, ptr %slot.i, align 8, !dbg !419
  %r15 = call i64 @nova_rt_list_get_f(i64 %r13, i64 %r14), !dbg !419
  %wbox0 = call i64 @nova_rt_box_float(i64 %r15), !dbg !419
  %r16 = call i64 @_th_encode_field(i64 %wbox0), !dbg !419
  %r17 = call i64 @nova_rt_bytes_concat(i64 %r12, i64 %r16), !dbg !419
  store i64 %r17, ptr %slot.out, align 8, !dbg !419
  %r18 = load i64, ptr %slot.i, align 8, !dbg !420
  %r19 = add i64 1, 0, !dbg !420
  %r20 = add i64 %r18, %r19, !dbg !420
  store i64 %r20, ptr %slot.i, align 8, !dbg !420
  br label %while_hdr282, !dbg !420
while_exit284:
  br label %endif281, !dbg !420
else280:
  br label %while_hdr285, !dbg !418
while_hdr285:
  %r21 = load i64, ptr %slot.i, align 8, !dbg !418
  %r22 = load i64, ptr %slot.n, align 8, !dbg !418
  %r23.cmp = icmp slt i64 %r21, %r22, !dbg !418
  %r23 = zext i1 %r23.cmp to i64, !dbg !418
  %br_while_body2862 = icmp ne i64 %r23, 0, !dbg !418
  br i1 %br_while_body2862, label %while_body286, label %while_exit287, !prof !90, !dbg !418
while_body286:
  %r24 = load i64, ptr %slot.out, align 8, !dbg !419
  %r25 = load i64, ptr %slot.fields, align 8, !dbg !419
  %r26 = load i64, ptr %slot.i, align 8, !dbg !419
  %r27 = call i64 @nova_rt_index_get(i64 %r25, i64 %r26), !dbg !419
  %r28 = call i64 @_th_encode_field(i64 %r27), !dbg !419
  %r29 = call i64 @nova_rt_bytes_concat(i64 %r24, i64 %r28), !dbg !419
  store i64 %r29, ptr %slot.out, align 8, !dbg !419
  %r30 = load i64, ptr %slot.i, align 8, !dbg !420
  %r31 = add i64 1, 0, !dbg !420
  %r32 = add i64 %r30, %r31, !dbg !420
  store i64 %r32, ptr %slot.i, align 8, !dbg !420
  br label %while_hdr285, !dbg !420
while_exit287:
  br label %endif281, !dbg !420
endif281:
  %r33 = load i64, ptr %slot.out, align 8, !dbg !421
  %r34 = call i64 @tt_stop(), !dbg !421
  %r35 = call i64 @nova_rt_bytes_append(i64 %r33, i64 %r34), !dbg !421
  ret i64 %r35, !dbg !421
}

; ESCAPE _th_dec_len_bytes: allocs=1 escape=1 local=0
define i64 @_th_dec_len_bytes(i64 %p0, i64 %p1) nounwind uwtable !dbg !422 {
entry:
  %slot.b = alloca i64, align 8, !dbg !423
  store i64 %p0, ptr %slot.b, align 8, !dbg !423
  %slot.pos = alloca i64, align 8, !dbg !423
  store i64 %p1, ptr %slot.pos, align 8, !dbg !423
  %slot.blen = alloca i64, align 8, !dbg !423
  store i64 0, ptr %slot.blen, align 8, !dbg !423
  %slot.declared = alloca i64, align 8, !dbg !423
  store i64 0, ptr %slot.declared, align 8, !dbg !423
  %slot.data_start = alloca i64, align 8, !dbg !423
  store i64 0, ptr %slot.data_start, align 8, !dbg !423
  %slot.avail = alloca i64, align 8, !dbg !423
  store i64 0, ptr %slot.avail, align 8, !dbg !423
  %slot.take = alloca i64, align 8, !dbg !423
  store i64 0, ptr %slot.take, align 8, !dbg !423
  %slot.payload = alloca i64, align 8, !dbg !423
  store i64 0, ptr %slot.payload, align 8, !dbg !423
  %slot.result = alloca i64, align 8, !dbg !423
  store i64 0, ptr %slot.result, align 8, !dbg !423
  %r0 = load i64, ptr %slot.b, align 8, !dbg !424
  %r1 = call i64 @nova_rt_bytes_len(i64 %r0), !dbg !424
  store i64 %r1, ptr %slot.blen, align 8, !dbg !424
  %r2 = load i64, ptr %slot.b, align 8, !dbg !425
  %r3 = load i64, ptr %slot.pos, align 8, !dbg !425
  %r4 = call i64 @unpack_i32_be(i64 %r2, i64 %r3), !dbg !425
  store i64 %r4, ptr %slot.declared, align 8, !dbg !425
  %r5 = load i64, ptr %slot.pos, align 8, !dbg !426
  %r6 = add i64 4, 0, !dbg !426
  %r7 = add i64 %r5, %r6, !dbg !426
  store i64 %r7, ptr %slot.data_start, align 8, !dbg !426
  %r8 = add i64 %r1, 0, !dbg !427
  %r9 = add i64 %r7, 0, !dbg !427
  %r10 = sub i64 %r8, %r9, !dbg !427
  store i64 %r10, ptr %slot.avail, align 8, !dbg !427
  %r11 = add i64 %r10, 0, !dbg !428
  %r12 = add i64 0, 0, !dbg !428
  %r13.cmp = icmp slt i64 %r11, %r12, !dbg !428
  %r13 = zext i1 %r13.cmp to i64, !dbg !428
  %br_then2880 = icmp ne i64 %r13, 0, !dbg !428
  br i1 %br_then2880, label %then288, label %else289, !dbg !428
then288:
  %r14 = add i64 0, 0, !dbg !429
  store i64 %r14, ptr %slot.avail, align 8, !dbg !429
  br label %endif290, !dbg !429
else289:
  br label %endif290, !dbg !429
endif290:
  %r15 = load i64, ptr %slot.declared, align 8, !dbg !430
  store i64 %r15, ptr %slot.take, align 8, !dbg !430
  %r16 = add i64 %r15, 0, !dbg !431
  %r17 = add i64 0, 0, !dbg !431
  %r18 = call i64 @nova_rt_lt(i64 %r16, i64 %r17), !dbg !431
  %br_then2911 = icmp ne i64 %r18, 0, !dbg !431
  br i1 %br_then2911, label %then291, label %else292, !dbg !431
then291:
  %r19 = add i64 0, 0, !dbg !432
  store i64 %r19, ptr %slot.take, align 8, !dbg !432
  br label %endif293, !dbg !432
else292:
  br label %endif293, !dbg !432
endif293:
  %r20 = load i64, ptr %slot.take, align 8, !dbg !433
  %r21 = load i64, ptr %slot.avail, align 8, !dbg !433
  %r22 = call i64 @nova_rt_gt(i64 %r20, i64 %r21), !dbg !433
  %br_then2942 = icmp ne i64 %r22, 0, !dbg !433
  br i1 %br_then2942, label %then294, label %else295, !dbg !433
then294:
  %r23 = load i64, ptr %slot.avail, align 8, !dbg !434
  store i64 %r23, ptr %slot.take, align 8, !dbg !434
  br label %endif296, !dbg !434
else295:
  br label %endif296, !dbg !434
endif296:
  %r24 = load i64, ptr %slot.b, align 8, !dbg !435
  %r25 = load i64, ptr %slot.data_start, align 8, !dbg !435
  %r26 = load i64, ptr %slot.data_start, align 8, !dbg !435
  %r27 = load i64, ptr %slot.take, align 8, !dbg !435
  %r28 = call i64 @nova_rt_add(i64 %r26, i64 %r27), !dbg !435
  %r29 = call i64 @nova_rt_bytes_slice(i64 %r24, i64 %r25, i64 %r28), !dbg !435
  store i64 %r29, ptr %slot.payload, align 8, !dbg !435
  %r31 = add i64 %r29, 0, !dbg !436
  %r32 = load i64, ptr %slot.data_start, align 8, !dbg !436
  %r33 = load i64, ptr %slot.take, align 8, !dbg !436
  %r34 = call i64 @nova_rt_add(i64 %r32, i64 %r33), !dbg !436
  %r30 = call i64 @nova_rt_list_create(), !dbg !436
  call i64 @nova_rt_list_append(i64 %r30, i64 %r31), !dbg !436
  call i64 @nova_rt_list_append(i64 %r30, i64 %r34), !dbg !436
  store i64 %r30, ptr %slot.result, align 8, !dbg !436
  %r35 = add i64 %r30, 0, !dbg !437
  ret i64 %r35, !dbg !437
}

; ESCAPE _th_dec_container_items: allocs=2 escape=1 local=1
define i64 @_th_dec_container_items(i64 %p0, i64 %p1, i64 %p2, i64 %p3) nounwind uwtable !dbg !438 {
entry:
  %slot.etype = alloca i64, align 8, !dbg !439
  store i64 %p0, ptr %slot.etype, align 8, !dbg !439
  %slot.count = alloca i64, align 8, !dbg !439
  store i64 %p1, ptr %slot.count, align 8, !dbg !439
  %slot.b = alloca i64, align 8, !dbg !439
  store i64 %p2, ptr %slot.b, align 8, !dbg !439
  %slot.pos = alloca i64, align 8, !dbg !439
  store i64 %p3, ptr %slot.pos, align 8, !dbg !439
  %slot.items = alloca i64, align 8, !dbg !439
  store i64 0, ptr %slot.items, align 8, !dbg !439
  %slot.cur = alloca i64, align 8, !dbg !439
  store i64 0, ptr %slot.cur, align 8, !dbg !439
  %slot.i = alloca i64, align 8, !dbg !439
  store i64 0, ptr %slot.i, align 8, !dbg !439
  %slot.before = alloca i64, align 8, !dbg !439
  store i64 0, ptr %slot.before, align 8, !dbg !439
  %slot.r = alloca i64, align 8, !dbg !439
  store i64 0, ptr %slot.r, align 8, !dbg !439
  %slot.result = alloca i64, align 8, !dbg !439
  store i64 0, ptr %slot.result, align 8, !dbg !439
  %r0 = call i64 @nova_rt_list_create(), !dbg !440
  store i64 %r0, ptr %slot.items, align 8, !dbg !440
  %r1 = load i64, ptr %slot.pos, align 8, !dbg !441
  store i64 %r1, ptr %slot.cur, align 8, !dbg !441
  %r2 = add i64 0, 0, !dbg !442
  store i64 %r2, ptr %slot.i, align 8, !dbg !442
  br label %while_hdr297, !dbg !443
while_hdr297:
  %r3 = load i64, ptr %slot.i, align 8, !dbg !443
  %r4 = load i64, ptr %slot.count, align 8, !dbg !443
  %r5.cmp = icmp slt i64 %r3, %r4, !dbg !443
  %r5 = zext i1 %r5.cmp to i64, !dbg !443
  %br_while_body2980 = icmp ne i64 %r5, 0, !dbg !443
  br i1 %br_while_body2980, label %while_body298, label %while_exit299, !prof !90, !dbg !443
while_body298:
  %r6 = load i64, ptr %slot.cur, align 8, !dbg !444
  store i64 %r6, ptr %slot.before, align 8, !dbg !444
  %r7 = load i64, ptr %slot.etype, align 8, !dbg !445
  %r8 = load i64, ptr %slot.b, align 8, !dbg !445
  %r9 = load i64, ptr %slot.cur, align 8, !dbg !445
  %r10 = call i64 @_th_decode_value(i64 %r7, i64 %r8, i64 %r9), !dbg !445
  store i64 %r10, ptr %slot.r, align 8, !dbg !445
  %r11 = load i64, ptr %slot.items, align 8, !dbg !446
  %r12 = add i64 %r10, 0, !dbg !446
  %r13 = add i64 0, 0, !dbg !446
  %r14 = call i64 @nova_rt_index_get(i64 %r12, i64 %r13), !dbg !446
  %r15 = call i64 @nova_rt_list_append_no_rc(i64 %r11, i64 %r14), !dbg !446
  %r16 = add i64 %r10, 0, !dbg !447
  %r17 = add i64 1, 0, !dbg !447
  %r18 = call i64 @nova_rt_index_get(i64 %r16, i64 %r17), !dbg !447
  store i64 %r18, ptr %slot.cur, align 8, !dbg !447
  %r19 = add i64 %r18, 0, !dbg !448
  %r20 = add i64 %r6, 0, !dbg !448
  %r21 = call i64 @nova_rt_le(i64 %r19, i64 %r20), !dbg !448
  %br_then3001 = icmp ne i64 %r21, 0, !dbg !448
  br i1 %br_then3001, label %then300, label %else301, !dbg !448
then300:
  br label %while_exit299, !dbg !449
else301:
  br label %endif302, !dbg !449
endif302:
  %r22 = load i64, ptr %slot.i, align 8, !dbg !450
  %r23 = add i64 1, 0, !dbg !450
  %r24 = add i64 %r22, %r23, !dbg !450
  store i64 %r24, ptr %slot.i, align 8, !dbg !450
  br label %while_hdr297, !dbg !450
while_exit299:
  %r26 = load i64, ptr %slot.items, align 8, !dbg !451
  %r27 = load i64, ptr %slot.cur, align 8, !dbg !451
  %r25 = call i64 @nova_rt_list_create(), !dbg !451
  call i64 @nova_rt_list_append(i64 %r25, i64 %r26), !dbg !451
  call i64 @nova_rt_list_append(i64 %r25, i64 %r27), !dbg !451
  store i64 %r25, ptr %slot.result, align 8, !dbg !451
  %r28 = add i64 %r25, 0, !dbg !452
  ret i64 %r28, !dbg !452
}

; ESCAPE _th_decode_value: allocs=13 escape=10 local=3
define i64 @_th_decode_value(i64 %p0, i64 %p1, i64 %p2) nounwind uwtable !dbg !453 {
entry:
  %slot.ttype = alloca i64, align 8, !dbg !454
  store i64 %p0, ptr %slot.ttype, align 8, !dbg !454
  %slot.b = alloca i64, align 8, !dbg !454
  store i64 %p1, ptr %slot.b, align 8, !dbg !454
  %slot.pos = alloca i64, align 8, !dbg !454
  store i64 %p2, ptr %slot.pos, align 8, !dbg !454
  %slot.blen = alloca i64, align 8, !dbg !454
  store i64 0, ptr %slot.blen, align 8, !dbg !454
  %slot.v = alloca i64, align 8, !dbg !454
  store i64 0, ptr %slot.v, align 8, !dbg !454
  %slot.bv = alloca i64, align 8, !dbg !454
  store i64 0, ptr %slot.bv, align 8, !dbg !454
  %slot.__sc_330 = alloca i64, align 8, !dbg !454
  store i64 0, ptr %slot.__sc_330, align 8, !dbg !454
  %slot.etype = alloca i64, align 8, !dbg !454
  store i64 0, ptr %slot.etype, align 8, !dbg !454
  %slot.declared = alloca i64, align 8, !dbg !454
  store i64 0, ptr %slot.declared, align 8, !dbg !454
  %slot.cur = alloca i64, align 8, !dbg !454
  store i64 0, ptr %slot.cur, align 8, !dbg !454
  %slot.avail = alloca i64, align 8, !dbg !454
  store i64 0, ptr %slot.avail, align 8, !dbg !454
  %slot.n = alloca i64, align 8, !dbg !454
  store i64 0, ptr %slot.n, align 8, !dbg !454
  %slot.r = alloca i64, align 8, !dbg !454
  store i64 0, ptr %slot.r, align 8, !dbg !454
  %slot.d = alloca i64, align 8, !dbg !454
  store i64 0, ptr %slot.d, align 8, !dbg !454
  %slot.ktype = alloca i64, align 8, !dbg !454
  store i64 0, ptr %slot.ktype, align 8, !dbg !454
  %slot.vtype = alloca i64, align 8, !dbg !454
  store i64 0, ptr %slot.vtype, align 8, !dbg !454
  %slot.pairs = alloca i64, align 8, !dbg !454
  store i64 0, ptr %slot.pairs, align 8, !dbg !454
  %slot.i = alloca i64, align 8, !dbg !454
  store i64 0, ptr %slot.i, align 8, !dbg !454
  %slot.before = alloca i64, align 8, !dbg !454
  store i64 0, ptr %slot.before, align 8, !dbg !454
  %slot.kr = alloca i64, align 8, !dbg !454
  store i64 0, ptr %slot.kr, align 8, !dbg !454
  %slot.vr = alloca i64, align 8, !dbg !454
  store i64 0, ptr %slot.vr, align 8, !dbg !454
  %slot.result = alloca i64, align 8, !dbg !454
  store i64 0, ptr %slot.result, align 8, !dbg !454
  %r0 = load i64, ptr %slot.b, align 8, !dbg !455
  %r1 = call i64 @nova_rt_bytes_len(i64 %r0), !dbg !455
  store i64 %r1, ptr %slot.blen, align 8, !dbg !455
  %r2 = load i64, ptr %slot.ttype, align 8, !dbg !456
  %r3 = call i64 @tt_bool(), !dbg !456
  %r4.cmp = icmp eq i64 %r2, %r3, !dbg !456
  %r4 = zext i1 %r4.cmp to i64, !dbg !456
  %br_then3030 = icmp ne i64 %r4, 0, !dbg !456
  br i1 %br_then3030, label %then303, label %else304, !dbg !456
then303:
  %r5 = load i64, ptr %slot.b, align 8, !dbg !457
  %r6 = load i64, ptr %slot.pos, align 8, !dbg !457
  %r7 = call i64 @unpack_u8(i64 %r5, i64 %r6), !dbg !457
  store i64 %r7, ptr %slot.v, align 8, !dbg !457
  %r8 = add i64 0, 0, !dbg !458
  store i64 %r8, ptr %slot.bv, align 8, !dbg !458
  %r9 = add i64 %r7, 0, !dbg !459
  %r10 = add i64 0, 0, !dbg !459
  %r11 = call i64 @nova_rt_neq(i64 %r9, i64 %r10), !dbg !459
  %br_then3061 = icmp ne i64 %r11, 0, !dbg !459
  br i1 %br_then3061, label %then306, label %else307, !dbg !459
then306:
  %r12 = add i64 1, 0, !dbg !460
  store i64 %r12, ptr %slot.bv, align 8, !dbg !460
  br label %endif308, !dbg !460
else307:
  br label %endif308, !dbg !460
endif308:
  %r14 = load i64, ptr %slot.bv, align 8, !dbg !461
  %r15 = load i64, ptr %slot.pos, align 8, !dbg !461
  %r16 = add i64 1, 0, !dbg !461
  %r17 = add i64 %r15, %r16, !dbg !461
  %r13 = call i64 @nova_rt_list_create(), !dbg !461
  call i64 @nova_rt_list_append(i64 %r13, i64 %r14), !dbg !461
  call i64 @nova_rt_list_append(i64 %r13, i64 %r17), !dbg !461
  ret i64 %r13, !dbg !461
else304:
  br label %endif305, !dbg !461
endif305:
  %r18 = load i64, ptr %slot.ttype, align 8, !dbg !462
  %r19 = call i64 @tt_byte(), !dbg !462
  %r20.cmp = icmp eq i64 %r18, %r19, !dbg !462
  %r20 = zext i1 %r20.cmp to i64, !dbg !462
  %br_then3092 = icmp ne i64 %r20, 0, !dbg !462
  br i1 %br_then3092, label %then309, label %else310, !dbg !462
then309:
  %r22 = load i64, ptr %slot.b, align 8, !dbg !463
  %r23 = load i64, ptr %slot.pos, align 8, !dbg !463
  %r24 = call i64 @unpack_i8(i64 %r22, i64 %r23), !dbg !463
  %r25 = load i64, ptr %slot.pos, align 8, !dbg !463
  %r26 = add i64 1, 0, !dbg !463
  %r27 = add i64 %r25, %r26, !dbg !463
  %r21 = call i64 @nova_rt_list_create(), !dbg !463
  call i64 @nova_rt_list_append(i64 %r21, i64 %r24), !dbg !463
  call i64 @nova_rt_list_append(i64 %r21, i64 %r27), !dbg !463
  ret i64 %r21, !dbg !463
else310:
  br label %endif311, !dbg !463
endif311:
  %r28 = load i64, ptr %slot.ttype, align 8, !dbg !464
  %r29 = call i64 @tt_i16(), !dbg !464
  %r30.cmp = icmp eq i64 %r28, %r29, !dbg !464
  %r30 = zext i1 %r30.cmp to i64, !dbg !464
  %br_then3123 = icmp ne i64 %r30, 0, !dbg !464
  br i1 %br_then3123, label %then312, label %else313, !dbg !464
then312:
  %r32 = load i64, ptr %slot.b, align 8, !dbg !465
  %r33 = load i64, ptr %slot.pos, align 8, !dbg !465
  %r34 = call i64 @unpack_i16_be(i64 %r32, i64 %r33), !dbg !465
  %r35 = load i64, ptr %slot.pos, align 8, !dbg !465
  %r36 = add i64 2, 0, !dbg !465
  %r37 = add i64 %r35, %r36, !dbg !465
  %r31 = call i64 @nova_rt_list_create(), !dbg !465
  call i64 @nova_rt_list_append(i64 %r31, i64 %r34), !dbg !465
  call i64 @nova_rt_list_append(i64 %r31, i64 %r37), !dbg !465
  ret i64 %r31, !dbg !465
else313:
  br label %endif314, !dbg !465
endif314:
  %r38 = load i64, ptr %slot.ttype, align 8, !dbg !466
  %r39 = call i64 @tt_i32(), !dbg !466
  %r40.cmp = icmp eq i64 %r38, %r39, !dbg !466
  %r40 = zext i1 %r40.cmp to i64, !dbg !466
  %br_then3154 = icmp ne i64 %r40, 0, !dbg !466
  br i1 %br_then3154, label %then315, label %else316, !dbg !466
then315:
  %r42 = load i64, ptr %slot.b, align 8, !dbg !467
  %r43 = load i64, ptr %slot.pos, align 8, !dbg !467
  %r44 = call i64 @unpack_i32_be(i64 %r42, i64 %r43), !dbg !467
  %r45 = load i64, ptr %slot.pos, align 8, !dbg !467
  %r46 = add i64 4, 0, !dbg !467
  %r47 = add i64 %r45, %r46, !dbg !467
  %r41 = call i64 @nova_rt_list_create(), !dbg !467
  call i64 @nova_rt_list_append(i64 %r41, i64 %r44), !dbg !467
  call i64 @nova_rt_list_append(i64 %r41, i64 %r47), !dbg !467
  ret i64 %r41, !dbg !467
else316:
  br label %endif317, !dbg !467
endif317:
  %r48 = load i64, ptr %slot.ttype, align 8, !dbg !468
  %r49 = call i64 @tt_i64(), !dbg !468
  %r50.cmp = icmp eq i64 %r48, %r49, !dbg !468
  %r50 = zext i1 %r50.cmp to i64, !dbg !468
  %br_then3185 = icmp ne i64 %r50, 0, !dbg !468
  br i1 %br_then3185, label %then318, label %else319, !dbg !468
then318:
  %r52 = load i64, ptr %slot.b, align 8, !dbg !469
  %r53 = load i64, ptr %slot.pos, align 8, !dbg !469
  %r54 = call i64 @unpack_i64_be(i64 %r52, i64 %r53), !dbg !469
  %r55 = load i64, ptr %slot.pos, align 8, !dbg !469
  %r56 = add i64 8, 0, !dbg !469
  %r57 = add i64 %r55, %r56, !dbg !469
  %r51 = call i64 @nova_rt_list_create(), !dbg !469
  call i64 @nova_rt_list_append(i64 %r51, i64 %r54), !dbg !469
  call i64 @nova_rt_list_append(i64 %r51, i64 %r57), !dbg !469
  ret i64 %r51, !dbg !469
else319:
  br label %endif320, !dbg !469
endif320:
  %r58 = load i64, ptr %slot.ttype, align 8, !dbg !470
  %r59 = call i64 @tt_double(), !dbg !470
  %r60.cmp = icmp eq i64 %r58, %r59, !dbg !470
  %r60 = zext i1 %r60.cmp to i64, !dbg !470
  %br_then3216 = icmp ne i64 %r60, 0, !dbg !470
  br i1 %br_then3216, label %then321, label %else322, !dbg !470
then321:
  %r62 = load i64, ptr %slot.b, align 8, !dbg !471
  %r63 = load i64, ptr %slot.pos, align 8, !dbg !471
  %r64 = call i64 @unpack_i64_be(i64 %r62, i64 %r63), !dbg !471
  %r65 = call i64 @nova_rt_float_from_bits(i64 %r64), !dbg !471
  %r66 = load i64, ptr %slot.pos, align 8, !dbg !471
  %r67 = add i64 8, 0, !dbg !471
  %r68 = add i64 %r66, %r67, !dbg !471
  %r61 = call i64 @nova_rt_list_create(), !dbg !471
  %r61.fb0 = call i64 @nova_rt_box_float(i64 %r65), !dbg !471
  call i64 @nova_rt_list_append(i64 %r61, i64 %r61.fb0), !dbg !471
  call i64 @nova_rt_list_append(i64 %r61, i64 %r68), !dbg !471
  ret i64 %r61, !dbg !471
else322:
  br label %endif323, !dbg !471
endif323:
  %r69 = load i64, ptr %slot.ttype, align 8, !dbg !472
  %r70 = call i64 @tt_string(), !dbg !472
  %r71.cmp = icmp eq i64 %r69, %r70, !dbg !472
  %r71 = zext i1 %r71.cmp to i64, !dbg !472
  %br_then3247 = icmp ne i64 %r71, 0, !dbg !472
  br i1 %br_then3247, label %then324, label %else325, !dbg !472
then324:
  %r72 = load i64, ptr %slot.b, align 8, !dbg !473
  %r73 = load i64, ptr %slot.pos, align 8, !dbg !473
  %r74 = call i64 @_th_dec_len_bytes(i64 %r72, i64 %r73), !dbg !473
  ret i64 %r74, !dbg !473
else325:
  br label %endif326, !dbg !473
endif326:
  %r75 = load i64, ptr %slot.ttype, align 8, !dbg !474
  %r76 = call i64 @tt_struct(), !dbg !474
  %r77.cmp = icmp eq i64 %r75, %r76, !dbg !474
  %r77 = zext i1 %r77.cmp to i64, !dbg !474
  %br_then3278 = icmp ne i64 %r77, 0, !dbg !474
  br i1 %br_then3278, label %then327, label %else328, !dbg !474
then327:
  %r78 = load i64, ptr %slot.b, align 8, !dbg !475
  %r79 = load i64, ptr %slot.pos, align 8, !dbg !475
  %r80 = call i64 @thrift_decode_struct(i64 %r78, i64 %r79), !dbg !475
  ret i64 %r80, !dbg !475
else328:
  br label %endif329, !dbg !475
endif329:
  %r81 = load i64, ptr %slot.ttype, align 8, !dbg !476
  %r82 = call i64 @tt_list(), !dbg !476
  %r83.cmp = icmp eq i64 %r81, %r82, !dbg !476
  %r83 = zext i1 %r83.cmp to i64, !dbg !476
  store i64 %r83, ptr %slot.__sc_330, align 8, !dbg !476
  %br_or_merge3329 = icmp ne i64 %r83, 0, !dbg !476
  br i1 %br_or_merge3329, label %or_merge332, label %or_rhs331, !dbg !476
or_rhs331:
  %r84 = load i64, ptr %slot.ttype, align 8, !dbg !476
  %r85 = call i64 @tt_set(), !dbg !476
  %r86.cmp = icmp eq i64 %r84, %r85, !dbg !476
  %r86 = zext i1 %r86.cmp to i64, !dbg !476
  store i64 %r86, ptr %slot.__sc_330, align 8, !dbg !476
  br label %or_merge332, !dbg !476
or_merge332:
  %r87 = load i64, ptr %slot.__sc_330, align 8, !dbg !476
  %br_then33310 = icmp ne i64 %r87, 0, !dbg !476
  br i1 %br_then33310, label %then333, label %else334, !dbg !476
then333:
  %r88 = load i64, ptr %slot.b, align 8, !dbg !477
  %r89 = load i64, ptr %slot.pos, align 8, !dbg !477
  %r90 = call i64 @unpack_u8(i64 %r88, i64 %r89), !dbg !477
  store i64 %r90, ptr %slot.etype, align 8, !dbg !477
  %r91 = load i64, ptr %slot.b, align 8, !dbg !478
  %r92 = load i64, ptr %slot.pos, align 8, !dbg !478
  %r93 = add i64 1, 0, !dbg !478
  %r94 = add i64 %r92, %r93, !dbg !478
  %r95 = call i64 @unpack_i32_be(i64 %r91, i64 %r94), !dbg !478
  store i64 %r95, ptr %slot.declared, align 8, !dbg !478
  %r96 = load i64, ptr %slot.pos, align 8, !dbg !479
  %r97 = add i64 5, 0, !dbg !479
  %r98 = add i64 %r96, %r97, !dbg !479
  store i64 %r98, ptr %slot.cur, align 8, !dbg !479
  %r99 = load i64, ptr %slot.blen, align 8, !dbg !480
  %r100 = add i64 %r98, 0, !dbg !480
  %r101 = sub i64 %r99, %r100, !dbg !480
  store i64 %r101, ptr %slot.avail, align 8, !dbg !480
  %r102 = add i64 %r101, 0, !dbg !481
  %r103 = add i64 0, 0, !dbg !481
  %r104.cmp = icmp slt i64 %r102, %r103, !dbg !481
  %r104 = zext i1 %r104.cmp to i64, !dbg !481
  %br_then33611 = icmp ne i64 %r104, 0, !dbg !481
  br i1 %br_then33611, label %then336, label %else337, !dbg !481
then336:
  %r105 = add i64 0, 0, !dbg !482
  store i64 %r105, ptr %slot.avail, align 8, !dbg !482
  br label %endif338, !dbg !482
else337:
  br label %endif338, !dbg !482
endif338:
  %r106 = load i64, ptr %slot.declared, align 8, !dbg !483
  store i64 %r106, ptr %slot.n, align 8, !dbg !483
  %r107 = add i64 %r106, 0, !dbg !484
  %r108 = add i64 0, 0, !dbg !484
  %r109 = call i64 @nova_rt_lt(i64 %r107, i64 %r108), !dbg !484
  %br_then33912 = icmp ne i64 %r109, 0, !dbg !484
  br i1 %br_then33912, label %then339, label %else340, !dbg !484
then339:
  %r110 = add i64 0, 0, !dbg !485
  store i64 %r110, ptr %slot.n, align 8, !dbg !485
  br label %endif341, !dbg !485
else340:
  br label %endif341, !dbg !485
endif341:
  %r111 = load i64, ptr %slot.n, align 8, !dbg !486
  %r112 = load i64, ptr %slot.avail, align 8, !dbg !486
  %r113 = call i64 @nova_rt_gt(i64 %r111, i64 %r112), !dbg !486
  %br_then34213 = icmp ne i64 %r113, 0, !dbg !486
  br i1 %br_then34213, label %then342, label %else343, !dbg !486
then342:
  %r114 = load i64, ptr %slot.avail, align 8, !dbg !487
  store i64 %r114, ptr %slot.n, align 8, !dbg !487
  br label %endif344, !dbg !487
else343:
  br label %endif344, !dbg !487
endif344:
  %r115 = load i64, ptr %slot.etype, align 8, !dbg !488
  %r116 = load i64, ptr %slot.n, align 8, !dbg !488
  %r117 = load i64, ptr %slot.b, align 8, !dbg !488
  %r118 = load i64, ptr %slot.cur, align 8, !dbg !488
  %r119 = call i64 @_th_dec_container_items(i64 %r115, i64 %r116, i64 %r117, i64 %r118), !dbg !488
  store i64 %r119, ptr %slot.r, align 8, !dbg !488
  %r120 = call i64 @nova_rt_dict_create(), !dbg !489
  store i64 %r120, ptr %slot.d, align 8, !dbg !489
  %r121 = load i64, ptr %slot.etype, align 8, !dbg !490
  %r122 = add i64 %r120, 0, !dbg !490
  %r123.p = getelementptr inbounds [6 x i8], ptr @.str.20, i64 0, i64 0, !dbg !490
  %r123 = ptrtoint ptr %r123.p to i64, !dbg !490
  %_is.dv14 = call i64 @nova_rt_dict_set(i64 %r122, i64 %r123, i64 %r121), !dbg !490
  %r124 = add i64 %r119, 0, !dbg !491
  %r125 = add i64 0, 0, !dbg !491
  %r126 = call i64 @nova_rt_index_get(i64 %r124, i64 %r125), !dbg !491
  %r127 = add i64 %r120, 0, !dbg !491
  %r128.p = getelementptr inbounds [6 x i8], ptr @.str.21, i64 0, i64 0, !dbg !491
  %r128 = ptrtoint ptr %r128.p to i64, !dbg !491
  %_is.dv15 = call i64 @nova_rt_dict_set(i64 %r127, i64 %r128, i64 %r126), !dbg !491
  %r130 = add i64 %r120, 0, !dbg !492
  %r131 = add i64 %r119, 0, !dbg !492
  %r132 = add i64 1, 0, !dbg !492
  %r133 = call i64 @nova_rt_index_get(i64 %r131, i64 %r132), !dbg !492
  %r129 = call i64 @nova_rt_list_create(), !dbg !492
  call i64 @nova_rt_list_append(i64 %r129, i64 %r130), !dbg !492
  call i64 @nova_rt_list_append(i64 %r129, i64 %r133), !dbg !492
  ret i64 %r129, !dbg !492
else334:
  br label %endif335, !dbg !492
endif335:
  %r134 = load i64, ptr %slot.ttype, align 8, !dbg !493
  %r135 = call i64 @tt_map(), !dbg !493
  %r136.cmp = icmp eq i64 %r134, %r135, !dbg !493
  %r136 = zext i1 %r136.cmp to i64, !dbg !493
  %br_then34516 = icmp ne i64 %r136, 0, !dbg !493
  br i1 %br_then34516, label %then345, label %else346, !dbg !493
then345:
  %r137 = load i64, ptr %slot.b, align 8, !dbg !494
  %r138 = load i64, ptr %slot.pos, align 8, !dbg !494
  %r139 = call i64 @unpack_u8(i64 %r137, i64 %r138), !dbg !494
  store i64 %r139, ptr %slot.ktype, align 8, !dbg !494
  %r140 = load i64, ptr %slot.b, align 8, !dbg !495
  %r141 = load i64, ptr %slot.pos, align 8, !dbg !495
  %r142 = add i64 1, 0, !dbg !495
  %r143 = add i64 %r141, %r142, !dbg !495
  %r144 = call i64 @unpack_u8(i64 %r140, i64 %r143), !dbg !495
  store i64 %r144, ptr %slot.vtype, align 8, !dbg !495
  %r145 = load i64, ptr %slot.b, align 8, !dbg !496
  %r146 = load i64, ptr %slot.pos, align 8, !dbg !496
  %r147 = add i64 2, 0, !dbg !496
  %r148 = add i64 %r146, %r147, !dbg !496
  %r149 = call i64 @unpack_i32_be(i64 %r145, i64 %r148), !dbg !496
  store i64 %r149, ptr %slot.declared, align 8, !dbg !496
  %r150 = load i64, ptr %slot.pos, align 8, !dbg !497
  %r151 = add i64 6, 0, !dbg !497
  %r152 = add i64 %r150, %r151, !dbg !497
  store i64 %r152, ptr %slot.cur, align 8, !dbg !497
  %r153 = load i64, ptr %slot.blen, align 8, !dbg !498
  %r154 = add i64 %r152, 0, !dbg !498
  %r155 = sub i64 %r153, %r154, !dbg !498
  store i64 %r155, ptr %slot.avail, align 8, !dbg !498
  %r156 = add i64 %r155, 0, !dbg !499
  %r157 = add i64 0, 0, !dbg !499
  %r158.cmp = icmp slt i64 %r156, %r157, !dbg !499
  %r158 = zext i1 %r158.cmp to i64, !dbg !499
  %br_then34817 = icmp ne i64 %r158, 0, !dbg !499
  br i1 %br_then34817, label %then348, label %else349, !dbg !499
then348:
  %r159 = add i64 0, 0, !dbg !500
  store i64 %r159, ptr %slot.avail, align 8, !dbg !500
  br label %endif350, !dbg !500
else349:
  br label %endif350, !dbg !500
endif350:
  %r160 = load i64, ptr %slot.declared, align 8, !dbg !501
  store i64 %r160, ptr %slot.n, align 8, !dbg !501
  %r161 = add i64 %r160, 0, !dbg !502
  %r162 = add i64 0, 0, !dbg !502
  %r163 = call i64 @nova_rt_lt(i64 %r161, i64 %r162), !dbg !502
  %br_then35118 = icmp ne i64 %r163, 0, !dbg !502
  br i1 %br_then35118, label %then351, label %else352, !dbg !502
then351:
  %r164 = add i64 0, 0, !dbg !503
  store i64 %r164, ptr %slot.n, align 8, !dbg !503
  br label %endif353, !dbg !503
else352:
  br label %endif353, !dbg !503
endif353:
  %r165 = load i64, ptr %slot.n, align 8, !dbg !504
  %r166 = load i64, ptr %slot.avail, align 8, !dbg !504
  %r167 = call i64 @nova_rt_gt(i64 %r165, i64 %r166), !dbg !504
  %br_then35419 = icmp ne i64 %r167, 0, !dbg !504
  br i1 %br_then35419, label %then354, label %else355, !dbg !504
then354:
  %r168 = load i64, ptr %slot.avail, align 8, !dbg !505
  store i64 %r168, ptr %slot.n, align 8, !dbg !505
  br label %endif356, !dbg !505
else355:
  br label %endif356, !dbg !505
endif356:
  %r169 = call i64 @nova_rt_list_create(), !dbg !506
  store i64 %r169, ptr %slot.pairs, align 8, !dbg !506
  %r170 = add i64 0, 0, !dbg !507
  store i64 %r170, ptr %slot.i, align 8, !dbg !507
  br label %while_hdr357, !dbg !508
while_hdr357:
  %r171 = load i64, ptr %slot.i, align 8, !dbg !508
  %r172 = load i64, ptr %slot.n, align 8, !dbg !508
  %r173 = call i64 @nova_rt_lt(i64 %r171, i64 %r172), !dbg !508
  %br_while_body35820 = icmp ne i64 %r173, 0, !dbg !508
  br i1 %br_while_body35820, label %while_body358, label %while_exit359, !prof !90, !dbg !508
while_body358:
  %r174 = load i64, ptr %slot.cur, align 8, !dbg !509
  store i64 %r174, ptr %slot.before, align 8, !dbg !509
  %r175 = load i64, ptr %slot.ktype, align 8, !dbg !510
  %r176 = load i64, ptr %slot.b, align 8, !dbg !510
  %r177 = load i64, ptr %slot.cur, align 8, !dbg !510
  %r178 = call i64 @_th_decode_value(i64 %r175, i64 %r176, i64 %r177), !dbg !510
  store i64 %r178, ptr %slot.kr, align 8, !dbg !510
  %r179 = add i64 %r178, 0, !dbg !511
  %r180 = add i64 1, 0, !dbg !511
  %r181 = call i64 @nova_rt_index_get(i64 %r179, i64 %r180), !dbg !511
  store i64 %r181, ptr %slot.cur, align 8, !dbg !511
  %r182 = load i64, ptr %slot.vtype, align 8, !dbg !512
  %r183 = load i64, ptr %slot.b, align 8, !dbg !512
  %r184 = add i64 %r181, 0, !dbg !512
  %r185 = call i64 @_th_decode_value(i64 %r182, i64 %r183, i64 %r184), !dbg !512
  store i64 %r185, ptr %slot.vr, align 8, !dbg !512
  %r186 = add i64 %r185, 0, !dbg !513
  %r187 = add i64 1, 0, !dbg !513
  %r188 = call i64 @nova_rt_index_get(i64 %r186, i64 %r187), !dbg !513
  store i64 %r188, ptr %slot.cur, align 8, !dbg !513
  %r189 = load i64, ptr %slot.pairs, align 8, !dbg !514
  %r191 = add i64 %r178, 0, !dbg !514
  %r192 = add i64 0, 0, !dbg !514
  %r193 = call i64 @nova_rt_index_get(i64 %r191, i64 %r192), !dbg !514
  %r194 = add i64 %r185, 0, !dbg !514
  %r195 = add i64 0, 0, !dbg !514
  %r196 = call i64 @nova_rt_index_get(i64 %r194, i64 %r195), !dbg !514
  %r190 = call i64 @nova_rt_list_create(), !dbg !514
  call i64 @nova_rt_list_append(i64 %r190, i64 %r193), !dbg !514
  call i64 @nova_rt_list_append(i64 %r190, i64 %r196), !dbg !514
  %r197 = call i64 @nova_rt_list_append(i64 %r189, i64 %r190), !dbg !514
  %r198 = add i64 %r188, 0, !dbg !515
  %r199 = add i64 %r174, 0, !dbg !515
  %r200 = call i64 @nova_rt_le(i64 %r198, i64 %r199), !dbg !515
  %br_then36021 = icmp ne i64 %r200, 0, !dbg !515
  br i1 %br_then36021, label %then360, label %else361, !dbg !515
then360:
  br label %while_exit359, !dbg !516
else361:
  br label %endif362, !dbg !516
endif362:
  %r201 = load i64, ptr %slot.i, align 8, !dbg !517
  %r202 = add i64 1, 0, !dbg !517
  %r203 = add i64 %r201, %r202, !dbg !517
  store i64 %r203, ptr %slot.i, align 8, !dbg !517
  br label %while_hdr357, !dbg !517
while_exit359:
  %r204 = call i64 @nova_rt_dict_create(), !dbg !518
  store i64 %r204, ptr %slot.d, align 8, !dbg !518
  %r205 = load i64, ptr %slot.ktype, align 8, !dbg !519
  %r206 = add i64 %r204, 0, !dbg !519
  %r207.p = getelementptr inbounds [6 x i8], ptr @.str.22, i64 0, i64 0, !dbg !519
  %r207 = ptrtoint ptr %r207.p to i64, !dbg !519
  %_is.dv22 = call i64 @nova_rt_dict_set(i64 %r206, i64 %r207, i64 %r205), !dbg !519
  %r208 = load i64, ptr %slot.vtype, align 8, !dbg !520
  %r209 = add i64 %r204, 0, !dbg !520
  %r210.p = getelementptr inbounds [6 x i8], ptr @.str.23, i64 0, i64 0, !dbg !520
  %r210 = ptrtoint ptr %r210.p to i64, !dbg !520
  %_is.dv23 = call i64 @nova_rt_dict_set(i64 %r209, i64 %r210, i64 %r208), !dbg !520
  %r211 = load i64, ptr %slot.pairs, align 8, !dbg !521
  %r212 = add i64 %r204, 0, !dbg !521
  %r213.p = getelementptr inbounds [6 x i8], ptr @.str.24, i64 0, i64 0, !dbg !521
  %r213 = ptrtoint ptr %r213.p to i64, !dbg !521
  %_is.dv24 = call i64 @nova_rt_dict_set(i64 %r212, i64 %r213, i64 %r211), !dbg !521
  %r215 = add i64 %r204, 0, !dbg !522
  %r216 = load i64, ptr %slot.cur, align 8, !dbg !522
  %r214 = call i64 @nova_rt_list_create(), !dbg !522
  call i64 @nova_rt_list_append(i64 %r214, i64 %r215), !dbg !522
  call i64 @nova_rt_list_append(i64 %r214, i64 %r216), !dbg !522
  ret i64 %r214, !dbg !522
else346:
  br label %endif347, !dbg !522
endif347:
  %r218 = add i64 0, 0, !dbg !523
  %r219 = load i64, ptr %slot.pos, align 8, !dbg !523
  %r217 = call i64 @nova_rt_list_create(), !dbg !523
  call i64 @nova_rt_list_append(i64 %r217, i64 %r218), !dbg !523
  call i64 @nova_rt_list_append(i64 %r217, i64 %r219), !dbg !523
  store i64 %r217, ptr %slot.result, align 8, !dbg !523
  %r220 = add i64 %r217, 0, !dbg !524
  ret i64 %r220, !dbg !524
}

; ESCAPE thrift_decode_struct: allocs=3 escape=1 local=2
define i64 @thrift_decode_struct(i64 %p0, i64 %p1) nounwind uwtable !dbg !525 {
entry:
  %slot.b = alloca i64, align 8, !dbg !526
  store i64 %p0, ptr %slot.b, align 8, !dbg !526
  %slot.pos = alloca i64, align 8, !dbg !526
  store i64 %p1, ptr %slot.pos, align 8, !dbg !526
  %slot.blen = alloca i64, align 8, !dbg !526
  store i64 0, ptr %slot.blen, align 8, !dbg !526
  %slot.fields = alloca i64, align 8, !dbg !526
  store i64 0, ptr %slot.fields, align 8, !dbg !526
  %slot.cur = alloca i64, align 8, !dbg !526
  store i64 0, ptr %slot.cur, align 8, !dbg !526
  %slot.ttype = alloca i64, align 8, !dbg !526
  store i64 0, ptr %slot.ttype, align 8, !dbg !526
  %slot.__sc_369 = alloca i64, align 8, !dbg !526
  store i64 0, ptr %slot.__sc_369, align 8, !dbg !526
  %slot.__sc_372 = alloca i64, align 8, !dbg !526
  store i64 0, ptr %slot.__sc_372, align 8, !dbg !526
  %slot.__sc_375 = alloca i64, align 8, !dbg !526
  store i64 0, ptr %slot.__sc_375, align 8, !dbg !526
  %slot.__sc_378 = alloca i64, align 8, !dbg !526
  store i64 0, ptr %slot.__sc_378, align 8, !dbg !526
  %slot.__sc_381 = alloca i64, align 8, !dbg !526
  store i64 0, ptr %slot.__sc_381, align 8, !dbg !526
  %slot.__sc_384 = alloca i64, align 8, !dbg !526
  store i64 0, ptr %slot.__sc_384, align 8, !dbg !526
  %slot.__sc_387 = alloca i64, align 8, !dbg !526
  store i64 0, ptr %slot.__sc_387, align 8, !dbg !526
  %slot.__sc_390 = alloca i64, align 8, !dbg !526
  store i64 0, ptr %slot.__sc_390, align 8, !dbg !526
  %slot.__sc_393 = alloca i64, align 8, !dbg !526
  store i64 0, ptr %slot.__sc_393, align 8, !dbg !526
  %slot.__sc_396 = alloca i64, align 8, !dbg !526
  store i64 0, ptr %slot.__sc_396, align 8, !dbg !526
  %slot.known = alloca i64, align 8, !dbg !526
  store i64 0, ptr %slot.known, align 8, !dbg !526
  %slot.fid = alloca i64, align 8, !dbg !526
  store i64 0, ptr %slot.fid, align 8, !dbg !526
  %slot.before = alloca i64, align 8, !dbg !526
  store i64 0, ptr %slot.before, align 8, !dbg !526
  %slot.r = alloca i64, align 8, !dbg !526
  store i64 0, ptr %slot.r, align 8, !dbg !526
  %slot.fld = alloca i64, align 8, !dbg !526
  store i64 0, ptr %slot.fld, align 8, !dbg !526
  %slot.result = alloca i64, align 8, !dbg !526
  store i64 0, ptr %slot.result, align 8, !dbg !526
  %r0 = load i64, ptr %slot.b, align 8, !dbg !527
  %r1 = call i64 @nova_rt_bytes_len(i64 %r0), !dbg !527
  store i64 %r1, ptr %slot.blen, align 8, !dbg !527
  %r2 = call i64 @nova_rt_list_create(), !dbg !528
  store i64 %r2, ptr %slot.fields, align 8, !dbg !528
  %r3 = load i64, ptr %slot.pos, align 8, !dbg !529
  store i64 %r3, ptr %slot.cur, align 8, !dbg !529
  br label %while_hdr363, !dbg !530
while_hdr363:
  %r4 = load i64, ptr %slot.cur, align 8, !dbg !530
  %r5 = load i64, ptr %slot.blen, align 8, !dbg !530
  %r6 = call i64 @nova_rt_lt(i64 %r4, i64 %r5), !dbg !530
  %br_while_body3640 = icmp ne i64 %r6, 0, !dbg !530
  br i1 %br_while_body3640, label %while_body364, label %while_exit365, !prof !90, !dbg !530
while_body364:
  %r7 = load i64, ptr %slot.b, align 8, !dbg !531
  %r8 = load i64, ptr %slot.cur, align 8, !dbg !531
  %r9 = call i64 @unpack_u8(i64 %r7, i64 %r8), !dbg !531
  store i64 %r9, ptr %slot.ttype, align 8, !dbg !531
  %r10 = add i64 %r9, 0, !dbg !532
  %r11 = call i64 @tt_stop(), !dbg !532
  %r12 = call i64 @nova_rt_eq(i64 %r10, i64 %r11), !dbg !532
  %br_then3661 = icmp ne i64 %r12, 0, !dbg !532
  br i1 %br_then3661, label %then366, label %else367, !dbg !532
then366:
  %r13 = load i64, ptr %slot.cur, align 8, !dbg !533
  %r14 = add i64 1, 0, !dbg !533
  %r15 = call i64 @nova_rt_add(i64 %r13, i64 %r14), !dbg !533
  store i64 %r15, ptr %slot.cur, align 8, !dbg !533
  br label %while_exit365, !dbg !534
else367:
  br label %endif368, !dbg !534
endif368:
  %r16 = load i64, ptr %slot.ttype, align 8, !dbg !535
  %r17 = call i64 @tt_bool(), !dbg !535
  %r18 = call i64 @nova_rt_eq(i64 %r16, i64 %r17), !dbg !535
  store i64 %r18, ptr %slot.__sc_369, align 8, !dbg !535
  %br_or_merge3712 = icmp ne i64 %r18, 0, !dbg !535
  br i1 %br_or_merge3712, label %or_merge371, label %or_rhs370, !dbg !535
or_rhs370:
  %r19 = load i64, ptr %slot.ttype, align 8, !dbg !535
  %r20 = call i64 @tt_byte(), !dbg !535
  %r21 = call i64 @nova_rt_eq(i64 %r19, i64 %r20), !dbg !535
  store i64 %r21, ptr %slot.__sc_369, align 8, !dbg !535
  br label %or_merge371, !dbg !535
or_merge371:
  %r22 = load i64, ptr %slot.__sc_369, align 8, !dbg !535
  store i64 %r22, ptr %slot.__sc_372, align 8, !dbg !535
  %br_or_merge3743 = icmp ne i64 %r22, 0, !dbg !535
  br i1 %br_or_merge3743, label %or_merge374, label %or_rhs373, !dbg !535
or_rhs373:
  %r23 = load i64, ptr %slot.ttype, align 8, !dbg !535
  %r24 = call i64 @tt_double(), !dbg !535
  %r25 = call i64 @nova_rt_eq(i64 %r23, i64 %r24), !dbg !535
  store i64 %r25, ptr %slot.__sc_372, align 8, !dbg !535
  br label %or_merge374, !dbg !535
or_merge374:
  %r26 = load i64, ptr %slot.__sc_372, align 8, !dbg !535
  store i64 %r26, ptr %slot.__sc_375, align 8, !dbg !535
  %br_or_merge3774 = icmp ne i64 %r26, 0, !dbg !535
  br i1 %br_or_merge3774, label %or_merge377, label %or_rhs376, !dbg !535
or_rhs376:
  %r27 = load i64, ptr %slot.ttype, align 8, !dbg !535
  %r28 = call i64 @tt_i16(), !dbg !535
  %r29 = call i64 @nova_rt_eq(i64 %r27, i64 %r28), !dbg !535
  store i64 %r29, ptr %slot.__sc_375, align 8, !dbg !535
  br label %or_merge377, !dbg !535
or_merge377:
  %r30 = load i64, ptr %slot.__sc_375, align 8, !dbg !535
  store i64 %r30, ptr %slot.__sc_378, align 8, !dbg !535
  %br_or_merge3805 = icmp ne i64 %r30, 0, !dbg !535
  br i1 %br_or_merge3805, label %or_merge380, label %or_rhs379, !dbg !535
or_rhs379:
  %r31 = load i64, ptr %slot.ttype, align 8, !dbg !535
  %r32 = call i64 @tt_i32(), !dbg !535
  %r33 = call i64 @nova_rt_eq(i64 %r31, i64 %r32), !dbg !535
  store i64 %r33, ptr %slot.__sc_378, align 8, !dbg !535
  br label %or_merge380, !dbg !535
or_merge380:
  %r34 = load i64, ptr %slot.__sc_378, align 8, !dbg !535
  store i64 %r34, ptr %slot.__sc_381, align 8, !dbg !535
  %br_or_merge3836 = icmp ne i64 %r34, 0, !dbg !535
  br i1 %br_or_merge3836, label %or_merge383, label %or_rhs382, !dbg !535
or_rhs382:
  %r35 = load i64, ptr %slot.ttype, align 8, !dbg !535
  %r36 = call i64 @tt_i64(), !dbg !535
  %r37 = call i64 @nova_rt_eq(i64 %r35, i64 %r36), !dbg !535
  store i64 %r37, ptr %slot.__sc_381, align 8, !dbg !535
  br label %or_merge383, !dbg !535
or_merge383:
  %r38 = load i64, ptr %slot.__sc_381, align 8, !dbg !535
  store i64 %r38, ptr %slot.__sc_384, align 8, !dbg !535
  %br_or_merge3867 = icmp ne i64 %r38, 0, !dbg !535
  br i1 %br_or_merge3867, label %or_merge386, label %or_rhs385, !dbg !535
or_rhs385:
  %r39 = load i64, ptr %slot.ttype, align 8, !dbg !535
  %r40 = call i64 @tt_string(), !dbg !535
  %r41 = call i64 @nova_rt_eq(i64 %r39, i64 %r40), !dbg !535
  store i64 %r41, ptr %slot.__sc_384, align 8, !dbg !535
  br label %or_merge386, !dbg !535
or_merge386:
  %r42 = load i64, ptr %slot.__sc_384, align 8, !dbg !535
  store i64 %r42, ptr %slot.__sc_387, align 8, !dbg !535
  %br_or_merge3898 = icmp ne i64 %r42, 0, !dbg !535
  br i1 %br_or_merge3898, label %or_merge389, label %or_rhs388, !dbg !535
or_rhs388:
  %r43 = load i64, ptr %slot.ttype, align 8, !dbg !535
  %r44 = call i64 @tt_struct(), !dbg !535
  %r45 = call i64 @nova_rt_eq(i64 %r43, i64 %r44), !dbg !535
  store i64 %r45, ptr %slot.__sc_387, align 8, !dbg !535
  br label %or_merge389, !dbg !535
or_merge389:
  %r46 = load i64, ptr %slot.__sc_387, align 8, !dbg !535
  store i64 %r46, ptr %slot.__sc_390, align 8, !dbg !535
  %br_or_merge3929 = icmp ne i64 %r46, 0, !dbg !535
  br i1 %br_or_merge3929, label %or_merge392, label %or_rhs391, !dbg !535
or_rhs391:
  %r47 = load i64, ptr %slot.ttype, align 8, !dbg !535
  %r48 = call i64 @tt_map(), !dbg !535
  %r49 = call i64 @nova_rt_eq(i64 %r47, i64 %r48), !dbg !535
  store i64 %r49, ptr %slot.__sc_390, align 8, !dbg !535
  br label %or_merge392, !dbg !535
or_merge392:
  %r50 = load i64, ptr %slot.__sc_390, align 8, !dbg !535
  store i64 %r50, ptr %slot.__sc_393, align 8, !dbg !535
  %br_or_merge39510 = icmp ne i64 %r50, 0, !dbg !535
  br i1 %br_or_merge39510, label %or_merge395, label %or_rhs394, !dbg !535
or_rhs394:
  %r51 = load i64, ptr %slot.ttype, align 8, !dbg !535
  %r52 = call i64 @tt_set(), !dbg !535
  %r53 = call i64 @nova_rt_eq(i64 %r51, i64 %r52), !dbg !535
  store i64 %r53, ptr %slot.__sc_393, align 8, !dbg !535
  br label %or_merge395, !dbg !535
or_merge395:
  %r54 = load i64, ptr %slot.__sc_393, align 8, !dbg !535
  store i64 %r54, ptr %slot.__sc_396, align 8, !dbg !535
  %br_or_merge39811 = icmp ne i64 %r54, 0, !dbg !535
  br i1 %br_or_merge39811, label %or_merge398, label %or_rhs397, !dbg !535
or_rhs397:
  %r55 = load i64, ptr %slot.ttype, align 8, !dbg !535
  %r56 = call i64 @tt_list(), !dbg !535
  %r57 = call i64 @nova_rt_eq(i64 %r55, i64 %r56), !dbg !535
  store i64 %r57, ptr %slot.__sc_396, align 8, !dbg !535
  br label %or_merge398, !dbg !535
or_merge398:
  %r58 = load i64, ptr %slot.__sc_396, align 8, !dbg !535
  store i64 %r58, ptr %slot.known, align 8, !dbg !535
  %r59 = add i64 %r58, 0, !dbg !536
  %r60.cmp = icmp eq i64 %r59, 0, !dbg !536
  %r60 = zext i1 %r60.cmp to i64, !dbg !536
  %br_then39912 = icmp ne i64 %r60, 0, !dbg !536
  br i1 %br_then39912, label %then399, label %else400, !dbg !536
then399:
  br label %while_exit365, !dbg !537
else400:
  br label %endif401, !dbg !537
endif401:
  %r61 = load i64, ptr %slot.cur, align 8, !dbg !538
  %r62 = add i64 3, 0, !dbg !538
  %r63 = call i64 @nova_rt_add(i64 %r61, i64 %r62), !dbg !538
  %r64 = load i64, ptr %slot.blen, align 8, !dbg !538
  %r65 = call i64 @nova_rt_gt(i64 %r63, i64 %r64), !dbg !538
  %br_then40213 = icmp ne i64 %r65, 0, !dbg !538
  br i1 %br_then40213, label %then402, label %else403, !dbg !538
then402:
  br label %while_exit365, !dbg !539
else403:
  br label %endif404, !dbg !539
endif404:
  %r66 = load i64, ptr %slot.b, align 8, !dbg !540
  %r67 = load i64, ptr %slot.cur, align 8, !dbg !540
  %r68 = add i64 1, 0, !dbg !540
  %r69 = call i64 @nova_rt_add(i64 %r67, i64 %r68), !dbg !540
  %r70 = call i64 @unpack_i16_be(i64 %r66, i64 %r69), !dbg !540
  store i64 %r70, ptr %slot.fid, align 8, !dbg !540
  %r71 = load i64, ptr %slot.cur, align 8, !dbg !541
  store i64 %r71, ptr %slot.before, align 8, !dbg !541
  %r72 = load i64, ptr %slot.ttype, align 8, !dbg !542
  %r73 = load i64, ptr %slot.b, align 8, !dbg !542
  %r74 = load i64, ptr %slot.cur, align 8, !dbg !542
  %r75 = add i64 3, 0, !dbg !542
  %r76 = call i64 @nova_rt_add(i64 %r74, i64 %r75), !dbg !542
  %r77 = call i64 @_th_decode_value(i64 %r72, i64 %r73, i64 %r76), !dbg !542
  store i64 %r77, ptr %slot.r, align 8, !dbg !542
  %r78 = call i64 @nova_rt_dict_create(), !dbg !543
  store i64 %r78, ptr %slot.fld, align 8, !dbg !543
  %r79 = add i64 %r70, 0, !dbg !544
  %r80 = add i64 %r78, 0, !dbg !544
  %r81.p = getelementptr inbounds [3 x i8], ptr @.str.26, i64 0, i64 0, !dbg !544
  %r81 = ptrtoint ptr %r81.p to i64, !dbg !544
  %_is.dv14 = call i64 @nova_rt_dict_set(i64 %r80, i64 %r81, i64 %r79), !dbg !544
  %r82 = load i64, ptr %slot.ttype, align 8, !dbg !545
  %r83 = add i64 %r78, 0, !dbg !545
  %r84.p = getelementptr inbounds [6 x i8], ptr @.str.25, i64 0, i64 0, !dbg !545
  %r84 = ptrtoint ptr %r84.p to i64, !dbg !545
  %_is.dv15 = call i64 @nova_rt_dict_set(i64 %r83, i64 %r84, i64 %r82), !dbg !545
  %r85 = add i64 %r77, 0, !dbg !546
  %r86 = add i64 0, 0, !dbg !546
  %r87 = call i64 @nova_rt_index_get(i64 %r85, i64 %r86), !dbg !546
  %r88 = add i64 %r78, 0, !dbg !546
  %r89.p = getelementptr inbounds [6 x i8], ptr @.str.27, i64 0, i64 0, !dbg !546
  %r89 = ptrtoint ptr %r89.p to i64, !dbg !546
  %_is.dv16 = call i64 @nova_rt_dict_set(i64 %r88, i64 %r89, i64 %r87), !dbg !546
  %r90 = load i64, ptr %slot.fields, align 8, !dbg !547
  %r91 = add i64 %r78, 0, !dbg !547
  %r92 = call i64 @nova_rt_list_append_no_rc(i64 %r90, i64 %r91), !dbg !547
  %r93 = add i64 %r77, 0, !dbg !548
  %r94 = add i64 1, 0, !dbg !548
  %r95 = call i64 @nova_rt_index_get(i64 %r93, i64 %r94), !dbg !548
  store i64 %r95, ptr %slot.cur, align 8, !dbg !548
  %r96 = add i64 %r95, 0, !dbg !549
  %r97 = add i64 %r71, 0, !dbg !549
  %r98 = call i64 @nova_rt_le(i64 %r96, i64 %r97), !dbg !549
  %br_then40517 = icmp ne i64 %r98, 0, !dbg !549
  br i1 %br_then40517, label %then405, label %else406, !dbg !549
then405:
  br label %while_exit365, !dbg !550
else406:
  br label %endif407, !dbg !550
endif407:
  br label %while_hdr363, !dbg !550
while_exit365:
  %r100 = load i64, ptr %slot.fields, align 8, !dbg !551
  %r101 = load i64, ptr %slot.cur, align 8, !dbg !551
  %r99 = call i64 @nova_rt_list_create(), !dbg !551
  call i64 @nova_rt_list_append(i64 %r99, i64 %r100), !dbg !551
  call i64 @nova_rt_list_append(i64 %r99, i64 %r101), !dbg !551
  store i64 %r99, ptr %slot.result, align 8, !dbg !551
  %r102 = add i64 %r99, 0, !dbg !552
  ret i64 %r102, !dbg !552
}

; ESCAPE thrift_struct_get: allocs=0 escape=0 local=0
define i64 @thrift_struct_get(i64 %p0, i64 %p1) nounwind uwtable !dbg !553 {
entry:
  %slot.fields = alloca i64, align 8, !dbg !554
  store i64 %p0, ptr %slot.fields, align 8, !dbg !554
  %slot.id = alloca i64, align 8, !dbg !554
  store i64 %p1, ptr %slot.id, align 8, !dbg !554
  %slot.n = alloca i64, align 8, !dbg !554
  store i64 0, ptr %slot.n, align 8, !dbg !554
  %slot.i = alloca i64, align 8, !dbg !554
  store i64 0, ptr %slot.i, align 8, !dbg !554
  %slot.result = alloca i64, align 8, !dbg !554
  store i64 0, ptr %slot.result, align 8, !dbg !554
  %slot.fields__s4f559 = alloca i64, align 8, !dbg !554
  store i64 0, ptr %slot.fields__s4f559, align 8, !dbg !554
  %r0 = load i64, ptr %slot.fields, align 8, !dbg !555
  %r1 = call i64 @nova_rt_len_any(i64 %r0), !dbg !555
  store i64 %r1, ptr %slot.n, align 8, !dbg !555
  %r2 = add i64 0, 0, !dbg !556
  store i64 %r2, ptr %slot.i, align 8, !dbg !556
  %r3 = add i64 0, 0, !dbg !557
  store i64 %r3, ptr %slot.result, align 8, !dbg !557
  %r4 = load i64, ptr %slot.fields, align 8, !dbg !558
  %r5 = call i64 @nova_rt_list_is_kind2(i64 %r4), !dbg !558
  %br_then4080 = icmp ne i64 %r5, 0, !dbg !558
  br i1 %br_then4080, label %then408, label %else409, !dbg !558
then408:
  %r6 = load i64, ptr %slot.fields, align 8, !dbg !558
  %r7 = call i64 @nova_rt_floatlist_view(i64 %r6), !dbg !558
  store i64 %r7, ptr %slot.fields__s4f559, align 8, !dbg !558
  br label %while_hdr411, !dbg !558
while_hdr411:
  %r8 = load i64, ptr %slot.i, align 8, !dbg !558
  %r9 = load i64, ptr %slot.n, align 8, !dbg !558
  %r10.cmp = icmp slt i64 %r8, %r9, !dbg !558
  %r10 = zext i1 %r10.cmp to i64, !dbg !558
  %br_while_body4121 = icmp ne i64 %r10, 0, !dbg !558
  br i1 %br_while_body4121, label %while_body412, label %while_exit413, !prof !90, !dbg !558
while_body412:
  %r11 = load i64, ptr %slot.fields__s4f559, align 8, !dbg !559
  %r12 = load i64, ptr %slot.i, align 8, !dbg !559
  %r13 = call i64 @nova_rt_list_get_f(i64 %r11, i64 %r12), !dbg !559
  %r14.p = getelementptr inbounds [3 x i8], ptr @.str.26, i64 0, i64 0, !dbg !559
  %r14 = ptrtoint ptr %r14.p to i64, !dbg !559
  %r15 = call i64 @nova_rt_index_get(i64 %r13, i64 %r14), !dbg !559
  %r16 = load i64, ptr %slot.id, align 8, !dbg !559
  %r17 = call i64 @nova_rt_eq(i64 %r15, i64 %r16), !dbg !559
  %br_then4142 = icmp ne i64 %r17, 0, !dbg !559
  br i1 %br_then4142, label %then414, label %else415, !dbg !559
then414:
  %r18 = load i64, ptr %slot.fields__s4f559, align 8, !dbg !560
  %r19 = load i64, ptr %slot.i, align 8, !dbg !560
  %r20 = call i64 @nova_rt_list_get_f(i64 %r18, i64 %r19), !dbg !560
  %wbox0 = call i64 @nova_rt_box_float(i64 %r20), !dbg !560
  store i64 %wbox0, ptr %slot.result, align 8, !dbg !560
  br label %endif416, !dbg !560
else415:
  br label %endif416, !dbg !560
endif416:
  %r21 = load i64, ptr %slot.i, align 8, !dbg !561
  %r22 = add i64 1, 0, !dbg !561
  %r23 = add i64 %r21, %r22, !dbg !561
  store i64 %r23, ptr %slot.i, align 8, !dbg !561
  br label %while_hdr411, !dbg !561
while_exit413:
  br label %endif410, !dbg !561
else409:
  br label %while_hdr417, !dbg !558
while_hdr417:
  %r24 = load i64, ptr %slot.i, align 8, !dbg !558
  %r25 = load i64, ptr %slot.n, align 8, !dbg !558
  %r26.cmp = icmp slt i64 %r24, %r25, !dbg !558
  %r26 = zext i1 %r26.cmp to i64, !dbg !558
  %br_while_body4183 = icmp ne i64 %r26, 0, !dbg !558
  br i1 %br_while_body4183, label %while_body418, label %while_exit419, !prof !90, !dbg !558
while_body418:
  %r27 = load i64, ptr %slot.fields, align 8, !dbg !559
  %r28 = load i64, ptr %slot.i, align 8, !dbg !559
  %r29 = call i64 @nova_rt_index_get(i64 %r27, i64 %r28), !dbg !559
  %r30.p = getelementptr inbounds [3 x i8], ptr @.str.26, i64 0, i64 0, !dbg !559
  %r30 = ptrtoint ptr %r30.p to i64, !dbg !559
  %r31 = call i64 @nova_rt_index_get(i64 %r29, i64 %r30), !dbg !559
  %r32 = load i64, ptr %slot.id, align 8, !dbg !559
  %r33 = call i64 @nova_rt_eq(i64 %r31, i64 %r32), !dbg !559
  %br_then4204 = icmp ne i64 %r33, 0, !dbg !559
  br i1 %br_then4204, label %then420, label %else421, !dbg !559
then420:
  %r34 = load i64, ptr %slot.fields, align 8, !dbg !560
  %r35 = load i64, ptr %slot.i, align 8, !dbg !560
  %r36 = call i64 @nova_rt_index_get(i64 %r34, i64 %r35), !dbg !560
  store i64 %r36, ptr %slot.result, align 8, !dbg !560
  br label %endif422, !dbg !560
else421:
  br label %endif422, !dbg !560
endif422:
  %r37 = load i64, ptr %slot.i, align 8, !dbg !561
  %r38 = add i64 1, 0, !dbg !561
  %r39 = add i64 %r37, %r38, !dbg !561
  store i64 %r39, ptr %slot.i, align 8, !dbg !561
  br label %while_hdr417, !dbg !561
while_exit419:
  br label %endif410, !dbg !561
endif410:
  %r40 = load i64, ptr %slot.result, align 8, !dbg !562
  ret i64 %r40, !dbg !562
}

; ESCAPE thrift_encode_message: allocs=0 escape=0 local=0
define i64 @thrift_encode_message(i64 %p0, i64 %p1, i64 %p2, i64 %p3) nounwind uwtable !dbg !563 {
entry:
  %slot.name = alloca i64, align 8, !dbg !564
  store i64 %p0, ptr %slot.name, align 8, !dbg !564
  %slot.mtype = alloca i64, align 8, !dbg !564
  store i64 %p1, ptr %slot.mtype, align 8, !dbg !564
  %slot.seqid = alloca i64, align 8, !dbg !564
  store i64 %p2, ptr %slot.seqid, align 8, !dbg !564
  %slot.fields = alloca i64, align 8, !dbg !564
  store i64 %p3, ptr %slot.fields, align 8, !dbg !564
  %slot.header = alloca i64, align 8, !dbg !564
  store i64 0, ptr %slot.header, align 8, !dbg !564
  %slot.out = alloca i64, align 8, !dbg !564
  store i64 0, ptr %slot.out, align 8, !dbg !564
  %slot.nb = alloca i64, align 8, !dbg !564
  store i64 0, ptr %slot.nb, align 8, !dbg !564
  %r0 = call i64 @_th_version1(), !dbg !565
  %r1 = load i64, ptr %slot.mtype, align 8, !dbg !565
  %r2 = add i64 255, 0, !dbg !565
  %r3 = and i64 %r1, %r2, !dbg !565
  %r4 = or i64 %r0, %r3, !dbg !565
  store i64 %r4, ptr %slot.header, align 8, !dbg !565
  %r5 = add i64 %r4, 0, !dbg !566
  %r6 = call i64 @pack_u32_be(i64 %r5), !dbg !566
  store i64 %r6, ptr %slot.out, align 8, !dbg !566
  %r7 = load i64, ptr %slot.name, align 8, !dbg !567
  %r8 = call i64 @nova_rt_str_to_bytes(i64 %r7), !dbg !567
  store i64 %r8, ptr %slot.nb, align 8, !dbg !567
  %r9 = add i64 %r6, 0, !dbg !568
  %r10 = add i64 %r8, 0, !dbg !568
  %r11 = call i64 @nova_rt_bytes_len(i64 %r10), !dbg !568
  %r12 = call i64 @pack_i32_be(i64 %r11), !dbg !568
  %r13 = call i64 @nova_rt_bytes_concat(i64 %r9, i64 %r12), !dbg !568
  store i64 %r13, ptr %slot.out, align 8, !dbg !568
  %r14 = add i64 %r13, 0, !dbg !569
  %r15 = add i64 %r8, 0, !dbg !569
  %r16 = call i64 @nova_rt_bytes_concat(i64 %r14, i64 %r15), !dbg !569
  store i64 %r16, ptr %slot.out, align 8, !dbg !569
  %r17 = add i64 %r16, 0, !dbg !570
  %r18 = load i64, ptr %slot.seqid, align 8, !dbg !570
  %r19 = call i64 @pack_i32_be(i64 %r18), !dbg !570
  %r20 = call i64 @nova_rt_bytes_concat(i64 %r17, i64 %r19), !dbg !570
  store i64 %r20, ptr %slot.out, align 8, !dbg !570
  %r21 = add i64 %r20, 0, !dbg !571
  %r22 = load i64, ptr %slot.fields, align 8, !dbg !571
  %r23 = call i64 @thrift_encode_struct(i64 %r22), !dbg !571
  %r24 = call i64 @nova_rt_bytes_concat(i64 %r21, i64 %r23), !dbg !571
  ret i64 %r24, !dbg !571
}

; ESCAPE thrift_decode_message: allocs=2 escape=2 local=0
define i64 @thrift_decode_message(i64 %p0) nounwind uwtable !dbg !572 {
entry:
  %slot.b = alloca i64, align 8, !dbg !573
  store i64 %p0, ptr %slot.b, align 8, !dbg !573
  %slot.blen = alloca i64, align 8, !dbg !573
  store i64 0, ptr %slot.blen, align 8, !dbg !573
  %slot.result = alloca i64, align 8, !dbg !573
  store i64 0, ptr %slot.result, align 8, !dbg !573
  %slot.header = alloca i64, align 8, !dbg !573
  store i64 0, ptr %slot.header, align 8, !dbg !573
  %slot.vtag = alloca i64, align 8, !dbg !573
  store i64 0, ptr %slot.vtag, align 8, !dbg !573
  %slot.mtype = alloca i64, align 8, !dbg !573
  store i64 0, ptr %slot.mtype, align 8, !dbg !573
  %slot.name_len = alloca i64, align 8, !dbg !573
  store i64 0, ptr %slot.name_len, align 8, !dbg !573
  %slot.name_start = alloca i64, align 8, !dbg !573
  store i64 0, ptr %slot.name_start, align 8, !dbg !573
  %slot.name_end = alloca i64, align 8, !dbg !573
  store i64 0, ptr %slot.name_end, align 8, !dbg !573
  %slot.name = alloca i64, align 8, !dbg !573
  store i64 0, ptr %slot.name, align 8, !dbg !573
  %slot.cur = alloca i64, align 8, !dbg !573
  store i64 0, ptr %slot.cur, align 8, !dbg !573
  %slot.seqid = alloca i64, align 8, !dbg !573
  store i64 0, ptr %slot.seqid, align 8, !dbg !573
  %slot.sr = alloca i64, align 8, !dbg !573
  store i64 0, ptr %slot.sr, align 8, !dbg !573
  %r0 = load i64, ptr %slot.b, align 8, !dbg !574
  %r1 = call i64 @nova_rt_bytes_len(i64 %r0), !dbg !574
  store i64 %r1, ptr %slot.blen, align 8, !dbg !574
  %r2 = call i64 @nova_rt_dict_create(), !dbg !575
  store i64 %r2, ptr %slot.result, align 8, !dbg !575
  %r3 = add i64 0, 0, !dbg !576
  %r4 = add i64 %r2, 0, !dbg !576
  %r5.p = getelementptr inbounds [3 x i8], ptr @.str.28, i64 0, i64 0, !dbg !576
  %r5 = ptrtoint ptr %r5.p to i64, !dbg !576
  %_is.dv0 = call i64 @nova_rt_dict_set(i64 %r4, i64 %r5, i64 %r3), !dbg !576
  %r6 = add i64 0, 0, !dbg !577
  %r7 = add i64 %r2, 0, !dbg !577
  %r8.p = getelementptr inbounds [6 x i8], ptr @.str.29, i64 0, i64 0, !dbg !577
  %r8 = ptrtoint ptr %r8.p to i64, !dbg !577
  %_is.dv1 = call i64 @nova_rt_dict_set(i64 %r7, i64 %r8, i64 %r6), !dbg !577
  %r9.p = getelementptr inbounds [1 x i8], ptr @.str.30, i64 0, i64 0, !dbg !578
  %r9 = ptrtoint ptr %r9.p to i64, !dbg !578
  %r10 = add i64 %r2, 0, !dbg !578
  %r11.p = getelementptr inbounds [5 x i8], ptr @.str.31, i64 0, i64 0, !dbg !578
  %r11 = ptrtoint ptr %r11.p to i64, !dbg !578
  %_is.dv2 = call i64 @nova_rt_dict_set(i64 %r10, i64 %r11, i64 %r9), !dbg !578
  %r12 = add i64 0, 0, !dbg !579
  %r13 = add i64 %r2, 0, !dbg !579
  %r14.p = getelementptr inbounds [6 x i8], ptr @.str.32, i64 0, i64 0, !dbg !579
  %r14 = ptrtoint ptr %r14.p to i64, !dbg !579
  %_is.dv3 = call i64 @nova_rt_dict_set(i64 %r13, i64 %r14, i64 %r12), !dbg !579
  %r15 = call i64 @nova_rt_list_create(), !dbg !580
  %r16 = add i64 %r2, 0, !dbg !580
  %r17.p = getelementptr inbounds [7 x i8], ptr @.str.33, i64 0, i64 0, !dbg !580
  %r17 = ptrtoint ptr %r17.p to i64, !dbg !580
  %_is.dv4 = call i64 @nova_rt_dict_set(i64 %r16, i64 %r17, i64 %r15), !dbg !580
  %r18 = add i64 0, 0, !dbg !581
  %r19 = add i64 %r2, 0, !dbg !581
  %r20.p = getelementptr inbounds [9 x i8], ptr @.str.34, i64 0, i64 0, !dbg !581
  %r20 = ptrtoint ptr %r20.p to i64, !dbg !581
  %_is.dv5 = call i64 @nova_rt_dict_set(i64 %r19, i64 %r20, i64 %r18), !dbg !581
  %r21 = add i64 %r1, 0, !dbg !582
  %r22 = add i64 4, 0, !dbg !582
  %r23.cmp = icmp slt i64 %r21, %r22, !dbg !582
  %r23 = zext i1 %r23.cmp to i64, !dbg !582
  %br_then4236 = icmp ne i64 %r23, 0, !dbg !582
  br i1 %br_then4236, label %then423, label %else424, !dbg !582
then423:
  %r24 = load i64, ptr %slot.result, align 8, !dbg !583
  ret i64 %r24, !dbg !583
else424:
  br label %endif425, !dbg !583
endif425:
  %r25 = load i64, ptr %slot.b, align 8, !dbg !584
  %r26 = add i64 0, 0, !dbg !584
  %r27 = call i64 @unpack_u32_be(i64 %r25, i64 %r26), !dbg !584
  store i64 %r27, ptr %slot.header, align 8, !dbg !584
  %r28 = add i64 %r27, 0, !dbg !585
  %r29 = add i64 16, 0, !dbg !585
  %r30.sramt = and i64 %r29, 63, !dbg !585
  %r30.srbig = icmp uge i64 %r29, 64, !dbg !585
  %r30.srval = ashr i64 %r28, %r30.sramt, !dbg !585
  %r30.srext = ashr i64 %r28, 63, !dbg !585
  %r30 = select i1 %r30.srbig, i64 %r30.srext, i64 %r30.srval, !dbg !585
  %r31 = add i64 65535, 0, !dbg !585
  %r32 = and i64 %r30, %r31, !dbg !585
  store i64 %r32, ptr %slot.vtag, align 8, !dbg !585
  %r33 = add i64 %r32, 0, !dbg !586
  %r34 = add i64 32769, 0, !dbg !586
  %r35 = call i64 @nova_rt_neq(i64 %r33, i64 %r34), !dbg !586
  %br_then4267 = icmp ne i64 %r35, 0, !dbg !586
  br i1 %br_then4267, label %then426, label %else427, !dbg !586
then426:
  %r36 = load i64, ptr %slot.result, align 8, !dbg !587
  ret i64 %r36, !dbg !587
else427:
  br label %endif428, !dbg !587
endif428:
  %r37 = load i64, ptr %slot.header, align 8, !dbg !588
  %r38 = add i64 255, 0, !dbg !588
  %r39 = and i64 %r37, %r38, !dbg !588
  store i64 %r39, ptr %slot.mtype, align 8, !dbg !588
  %r40 = load i64, ptr %slot.blen, align 8, !dbg !589
  %r41 = add i64 8, 0, !dbg !589
  %r42.cmp = icmp slt i64 %r40, %r41, !dbg !589
  %r42 = zext i1 %r42.cmp to i64, !dbg !589
  %br_then4298 = icmp ne i64 %r42, 0, !dbg !589
  br i1 %br_then4298, label %then429, label %else430, !dbg !589
then429:
  %r43 = load i64, ptr %slot.result, align 8, !dbg !590
  ret i64 %r43, !dbg !590
else430:
  br label %endif431, !dbg !590
endif431:
  %r44 = load i64, ptr %slot.b, align 8, !dbg !591
  %r45 = add i64 4, 0, !dbg !591
  %r46 = call i64 @unpack_i32_be(i64 %r44, i64 %r45), !dbg !591
  store i64 %r46, ptr %slot.name_len, align 8, !dbg !591
  %r47 = add i64 %r46, 0, !dbg !592
  %r48 = add i64 0, 0, !dbg !592
  %r49 = call i64 @nova_rt_lt(i64 %r47, i64 %r48), !dbg !592
  %br_then4329 = icmp ne i64 %r49, 0, !dbg !592
  br i1 %br_then4329, label %then432, label %else433, !dbg !592
then432:
  %r50 = load i64, ptr %slot.result, align 8, !dbg !593
  ret i64 %r50, !dbg !593
else433:
  br label %endif434, !dbg !593
endif434:
  %r51 = add i64 8, 0, !dbg !594
  store i64 %r51, ptr %slot.name_start, align 8, !dbg !594
  %r52 = add i64 %r51, 0, !dbg !595
  %r53 = load i64, ptr %slot.name_len, align 8, !dbg !595
  %r54 = call i64 @nova_rt_add(i64 %r52, i64 %r53), !dbg !595
  store i64 %r54, ptr %slot.name_end, align 8, !dbg !595
  %r55 = load i64, ptr %slot.blen, align 8, !dbg !596
  %r56 = add i64 %r54, 0, !dbg !596
  %r57 = add i64 4, 0, !dbg !596
  %r58 = call i64 @nova_rt_add(i64 %r56, i64 %r57), !dbg !596
  %r59 = call i64 @nova_rt_lt(i64 %r55, i64 %r58), !dbg !596
  %br_then43510 = icmp ne i64 %r59, 0, !dbg !596
  br i1 %br_then43510, label %then435, label %else436, !dbg !596
then435:
  %r60 = load i64, ptr %slot.result, align 8, !dbg !597
  ret i64 %r60, !dbg !597
else436:
  br label %endif437, !dbg !597
endif437:
  %r61 = load i64, ptr %slot.b, align 8, !dbg !598
  %r62 = load i64, ptr %slot.name_start, align 8, !dbg !598
  %r63 = load i64, ptr %slot.name_end, align 8, !dbg !598
  %r64 = call i64 @nova_rt_bytes_slice(i64 %r61, i64 %r62, i64 %r63), !dbg !598
  %r65 = call i64 @nova_rt_bytes_to_str(i64 %r64), !dbg !598
  store i64 %r65, ptr %slot.name, align 8, !dbg !598
  %r66 = load i64, ptr %slot.name_end, align 8, !dbg !599
  store i64 %r66, ptr %slot.cur, align 8, !dbg !599
  %r67 = load i64, ptr %slot.b, align 8, !dbg !600
  %r68 = add i64 %r66, 0, !dbg !600
  %r69 = call i64 @unpack_i32_be(i64 %r67, i64 %r68), !dbg !600
  store i64 %r69, ptr %slot.seqid, align 8, !dbg !600
  %r70 = add i64 %r66, 0, !dbg !601
  %r71 = add i64 4, 0, !dbg !601
  %r72 = call i64 @nova_rt_add(i64 %r70, i64 %r71), !dbg !601
  store i64 %r72, ptr %slot.cur, align 8, !dbg !601
  %r73 = load i64, ptr %slot.b, align 8, !dbg !602
  %r74 = add i64 %r72, 0, !dbg !602
  %r75 = call i64 @thrift_decode_struct(i64 %r73, i64 %r74), !dbg !602
  store i64 %r75, ptr %slot.sr, align 8, !dbg !602
  %r76 = add i64 1, 0, !dbg !603
  %r77 = load i64, ptr %slot.result, align 8, !dbg !603
  %r78.p = getelementptr inbounds [3 x i8], ptr @.str.28, i64 0, i64 0, !dbg !603
  %r78 = ptrtoint ptr %r78.p to i64, !dbg !603
  %_is.dv11 = call i64 @nova_rt_dict_set(i64 %r77, i64 %r78, i64 %r76), !dbg !603
  %r79 = load i64, ptr %slot.mtype, align 8, !dbg !604
  %r80 = load i64, ptr %slot.result, align 8, !dbg !604
  %r81.p = getelementptr inbounds [6 x i8], ptr @.str.29, i64 0, i64 0, !dbg !604
  %r81 = ptrtoint ptr %r81.p to i64, !dbg !604
  %_is.dv12 = call i64 @nova_rt_dict_set(i64 %r80, i64 %r81, i64 %r79), !dbg !604
  %r82 = add i64 %r65, 0, !dbg !605
  %r83 = load i64, ptr %slot.result, align 8, !dbg !605
  %r84.p = getelementptr inbounds [5 x i8], ptr @.str.31, i64 0, i64 0, !dbg !605
  %r84 = ptrtoint ptr %r84.p to i64, !dbg !605
  %_is.dv13 = call i64 @nova_rt_dict_set(i64 %r83, i64 %r84, i64 %r82), !dbg !605
  %r85 = add i64 %r69, 0, !dbg !606
  %r86 = load i64, ptr %slot.result, align 8, !dbg !606
  %r87.p = getelementptr inbounds [6 x i8], ptr @.str.32, i64 0, i64 0, !dbg !606
  %r87 = ptrtoint ptr %r87.p to i64, !dbg !606
  %_is.dv14 = call i64 @nova_rt_dict_set(i64 %r86, i64 %r87, i64 %r85), !dbg !606
  %r88 = add i64 %r75, 0, !dbg !607
  %r89 = add i64 0, 0, !dbg !607
  %r90 = call i64 @nova_rt_index_get(i64 %r88, i64 %r89), !dbg !607
  %r91 = load i64, ptr %slot.result, align 8, !dbg !607
  %r92.p = getelementptr inbounds [7 x i8], ptr @.str.33, i64 0, i64 0, !dbg !607
  %r92 = ptrtoint ptr %r92.p to i64, !dbg !607
  %_is.dv15 = call i64 @nova_rt_dict_set(i64 %r91, i64 %r92, i64 %r90), !dbg !607
  %r93 = add i64 %r75, 0, !dbg !608
  %r94 = add i64 1, 0, !dbg !608
  %r95 = call i64 @nova_rt_index_get(i64 %r93, i64 %r94), !dbg !608
  %r96 = load i64, ptr %slot.result, align 8, !dbg !608
  %r97.p = getelementptr inbounds [9 x i8], ptr @.str.34, i64 0, i64 0, !dbg !608
  %r97 = ptrtoint ptr %r97.p to i64, !dbg !608
  %_is.dv16 = call i64 @nova_rt_dict_set(i64 %r96, i64 %r97, i64 %r95), !dbg !608
  %r98 = load i64, ptr %slot.result, align 8, !dbg !609
  ret i64 %r98, !dbg !609
}

; ESCAPE nova_main: allocs=0 escape=0 local=0
define i64 @nova_main() nounwind uwtable {
entry:
  ret i64 0
}

; ESCAPE SUMMARY: allocs=36 escape=30 local=6 (16% local, RC-elidable)
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
@.str.0 = private unnamed_addr constant [2 x i8] c"B\00"
@.str.1 = private unnamed_addr constant [2 x i8] c"b\00"
@.str.2 = private unnamed_addr constant [2 x i8] c"H\00"
@.str.3 = private unnamed_addr constant [2 x i8] c"h\00"
@.str.4 = private unnamed_addr constant [2 x i8] c"I\00"
@.str.5 = private unnamed_addr constant [2 x i8] c"i\00"
@.str.6 = private unnamed_addr constant [2 x i8] c"Q\00"
@.str.7 = private unnamed_addr constant [2 x i8] c"q\00"
@.str.8 = private unnamed_addr constant [2 x i8] c">\00"
@.str.9 = private unnamed_addr constant [2 x i8] c"<\00"
@.str.10 = private unnamed_addr constant [32 x i8] c"pack_fmt: unknown format char '\00"
@.str.11 = private unnamed_addr constant [7 x i8] c"' in '\00"
@.str.12 = private unnamed_addr constant [2 x i8] c"'\00"
@.str.13 = private unnamed_addr constant [34 x i8] c"unpack_fmt: unknown format char '\00"
@.str.14 = private unnamed_addr constant [42 x i8] c"unpack_fmt: buffer too short for format '\00"
@.str.15 = private unnamed_addr constant [9 x i8] c"' (need \00"
@.str.16 = private unnamed_addr constant [14 x i8] c" bytes, have \00"
@.str.17 = private unnamed_addr constant [2 x i8] c")\00"
@.str.18 = private unnamed_addr constant [6 x i8] c"bytes\00"
@.str.19 = private unnamed_addr constant [7 x i8] c"string\00"
@.str.20 = private unnamed_addr constant [6 x i8] c"etype\00"
@.str.21 = private unnamed_addr constant [6 x i8] c"items\00"
@.str.22 = private unnamed_addr constant [6 x i8] c"ktype\00"
@.str.23 = private unnamed_addr constant [6 x i8] c"vtype\00"
@.str.24 = private unnamed_addr constant [6 x i8] c"pairs\00"
@.str.25 = private unnamed_addr constant [6 x i8] c"ttype\00"
@.str.26 = private unnamed_addr constant [3 x i8] c"id\00"
@.str.27 = private unnamed_addr constant [6 x i8] c"value\00"
@.str.28 = private unnamed_addr constant [3 x i8] c"ok\00"
@.str.29 = private unnamed_addr constant [6 x i8] c"mtype\00"
@.str.30 = private unnamed_addr constant [1 x i8] c"\00"
@.str.31 = private unnamed_addr constant [5 x i8] c"name\00"
@.str.32 = private unnamed_addr constant [6 x i8] c"seqid\00"
@.str.33 = private unnamed_addr constant [7 x i8] c"fields\00"
@.str.34 = private unnamed_addr constant [9 x i8] c"next_pos\00"

; Debug metadata
!llvm.dbg.cu = !{!100}
!llvm.module.flags = !{!102, !103}

!100 = distinct !DICompileUnit(language: DW_LANG_C99, file: !101, producer: "NOVA Compiler", isOptimized: false, emissionKind: LineTablesOnly)
!101 = !DIFile(filename: "std/encoding/thrift.nova", directory: ".")
!102 = !{i32 2, !"CodeView", i32 1}
!103 = !{i32 2, !"Debug Info Version", i32 3}
!104 = !DISubroutineType(types: !105)
!105 = !{null}
!200 = distinct !DISubprogram(name: "tt_stop", scope: !101, file: !101, line: 150, type: !104, scopeLine: 150, spFlags: DISPFlagDefinition, unit: !100)
!201 = !DILocation(line: 150, column: 0, scope: !200)
!203 = distinct !DISubprogram(name: "tt_bool", scope: !101, file: !101, line: 153, type: !104, scopeLine: 153, spFlags: DISPFlagDefinition, unit: !100)
!204 = !DILocation(line: 153, column: 0, scope: !203)
!206 = distinct !DISubprogram(name: "tt_byte", scope: !101, file: !101, line: 156, type: !104, scopeLine: 156, spFlags: DISPFlagDefinition, unit: !100)
!207 = !DILocation(line: 156, column: 0, scope: !206)
!209 = distinct !DISubprogram(name: "tt_double", scope: !101, file: !101, line: 159, type: !104, scopeLine: 159, spFlags: DISPFlagDefinition, unit: !100)
!210 = !DILocation(line: 159, column: 0, scope: !209)
!212 = distinct !DISubprogram(name: "tt_i16", scope: !101, file: !101, line: 162, type: !104, scopeLine: 162, spFlags: DISPFlagDefinition, unit: !100)
!213 = !DILocation(line: 162, column: 0, scope: !212)
!215 = distinct !DISubprogram(name: "tt_i32", scope: !101, file: !101, line: 165, type: !104, scopeLine: 165, spFlags: DISPFlagDefinition, unit: !100)
!216 = !DILocation(line: 165, column: 0, scope: !215)
!218 = distinct !DISubprogram(name: "tt_i64", scope: !101, file: !101, line: 168, type: !104, scopeLine: 168, spFlags: DISPFlagDefinition, unit: !100)
!219 = !DILocation(line: 168, column: 0, scope: !218)
!221 = distinct !DISubprogram(name: "tt_string", scope: !101, file: !101, line: 171, type: !104, scopeLine: 171, spFlags: DISPFlagDefinition, unit: !100)
!222 = !DILocation(line: 171, column: 0, scope: !221)
!224 = distinct !DISubprogram(name: "tt_struct", scope: !101, file: !101, line: 174, type: !104, scopeLine: 174, spFlags: DISPFlagDefinition, unit: !100)
!225 = !DILocation(line: 174, column: 0, scope: !224)
!227 = distinct !DISubprogram(name: "tt_map", scope: !101, file: !101, line: 177, type: !104, scopeLine: 177, spFlags: DISPFlagDefinition, unit: !100)
!228 = !DILocation(line: 177, column: 0, scope: !227)
!230 = distinct !DISubprogram(name: "tt_set", scope: !101, file: !101, line: 180, type: !104, scopeLine: 180, spFlags: DISPFlagDefinition, unit: !100)
!231 = !DILocation(line: 180, column: 0, scope: !230)
!233 = distinct !DISubprogram(name: "tt_list", scope: !101, file: !101, line: 183, type: !104, scopeLine: 183, spFlags: DISPFlagDefinition, unit: !100)
!234 = !DILocation(line: 183, column: 0, scope: !233)
!236 = distinct !DISubprogram(name: "tmt_call", scope: !101, file: !101, line: 188, type: !104, scopeLine: 188, spFlags: DISPFlagDefinition, unit: !100)
!237 = !DILocation(line: 188, column: 0, scope: !236)
!239 = distinct !DISubprogram(name: "tmt_reply", scope: !101, file: !101, line: 191, type: !104, scopeLine: 191, spFlags: DISPFlagDefinition, unit: !100)
!240 = !DILocation(line: 191, column: 0, scope: !239)
!242 = distinct !DISubprogram(name: "tmt_exception", scope: !101, file: !101, line: 194, type: !104, scopeLine: 194, spFlags: DISPFlagDefinition, unit: !100)
!243 = !DILocation(line: 194, column: 0, scope: !242)
!245 = distinct !DISubprogram(name: "tmt_oneway", scope: !101, file: !101, line: 197, type: !104, scopeLine: 197, spFlags: DISPFlagDefinition, unit: !100)
!246 = !DILocation(line: 197, column: 0, scope: !245)
!248 = distinct !DISubprogram(name: "_th_version1", scope: !101, file: !101, line: 202, type: !104, scopeLine: 202, spFlags: DISPFlagDefinition, unit: !100)
!249 = !DILocation(line: 202, column: 0, scope: !248)
!251 = distinct !DISubprogram(name: "thrift_str", scope: !101, file: !101, line: 207, type: !104, scopeLine: 207, spFlags: DISPFlagDefinition, unit: !100)
!252 = !DILocation(line: 207, column: 0, scope: !251)
!258 = distinct !DISubprogram(name: "_th_enc_string_or_bytes", scope: !101, file: !101, line: 220, type: !104, scopeLine: 220, spFlags: DISPFlagDefinition, unit: !100)
!259 = !DILocation(line: 220, column: 0, scope: !258)
!266 = distinct !DISubprogram(name: "_th_enc_container_items", scope: !101, file: !101, line: 230, type: !104, scopeLine: 230, spFlags: DISPFlagDefinition, unit: !100)
!267 = !DILocation(line: 230, column: 0, scope: !266)
!275 = distinct !DISubprogram(name: "_th_encode_value", scope: !101, file: !101, line: 243, type: !104, scopeLine: 243, spFlags: DISPFlagDefinition, unit: !100)
!276 = !DILocation(line: 243, column: 0, scope: !275)
!318 = distinct !DISubprogram(name: "_th_encode_field", scope: !101, file: !101, line: 287, type: !104, scopeLine: 287, spFlags: DISPFlagDefinition, unit: !100)
!319 = !DILocation(line: 287, column: 0, scope: !318)
!323 = distinct !DISubprogram(name: "thrift_field_bool", scope: !101, file: !101, line: 294, type: !104, scopeLine: 294, spFlags: DISPFlagDefinition, unit: !100)
!324 = !DILocation(line: 294, column: 0, scope: !323)
!333 = distinct !DISubprogram(name: "thrift_field_byte", scope: !101, file: !101, line: 304, type: !104, scopeLine: 304, spFlags: DISPFlagDefinition, unit: !100)
!334 = !DILocation(line: 304, column: 0, scope: !333)
!340 = distinct !DISubprogram(name: "thrift_field_i16", scope: !101, file: !101, line: 311, type: !104, scopeLine: 311, spFlags: DISPFlagDefinition, unit: !100)
!341 = !DILocation(line: 311, column: 0, scope: !340)
!347 = distinct !DISubprogram(name: "thrift_field_i32", scope: !101, file: !101, line: 318, type: !104, scopeLine: 318, spFlags: DISPFlagDefinition, unit: !100)
!348 = !DILocation(line: 318, column: 0, scope: !347)
!354 = distinct !DISubprogram(name: "thrift_field_i64", scope: !101, file: !101, line: 325, type: !104, scopeLine: 325, spFlags: DISPFlagDefinition, unit: !100)
!355 = !DILocation(line: 325, column: 0, scope: !354)
!361 = distinct !DISubprogram(name: "thrift_field_double", scope: !101, file: !101, line: 332, type: !104, scopeLine: 332, spFlags: DISPFlagDefinition, unit: !100)
!362 = !DILocation(line: 332, column: 0, scope: !361)
!368 = distinct !DISubprogram(name: "thrift_field_string", scope: !101, file: !101, line: 339, type: !104, scopeLine: 339, spFlags: DISPFlagDefinition, unit: !100)
!369 = !DILocation(line: 339, column: 0, scope: !368)
!375 = distinct !DISubprogram(name: "thrift_field_struct", scope: !101, file: !101, line: 346, type: !104, scopeLine: 346, spFlags: DISPFlagDefinition, unit: !100)
!376 = !DILocation(line: 346, column: 0, scope: !375)
!382 = distinct !DISubprogram(name: "thrift_field_list", scope: !101, file: !101, line: 353, type: !104, scopeLine: 353, spFlags: DISPFlagDefinition, unit: !100)
!383 = !DILocation(line: 353, column: 0, scope: !382)
!392 = distinct !DISubprogram(name: "thrift_field_set", scope: !101, file: !101, line: 363, type: !104, scopeLine: 363, spFlags: DISPFlagDefinition, unit: !100)
!393 = !DILocation(line: 363, column: 0, scope: !392)
!402 = distinct !DISubprogram(name: "thrift_field_map", scope: !101, file: !101, line: 373, type: !104, scopeLine: 373, spFlags: DISPFlagDefinition, unit: !100)
!403 = !DILocation(line: 373, column: 0, scope: !402)
!413 = distinct !DISubprogram(name: "thrift_encode_struct", scope: !101, file: !101, line: 387, type: !104, scopeLine: 387, spFlags: DISPFlagDefinition, unit: !100)
!414 = !DILocation(line: 387, column: 0, scope: !413)
!422 = distinct !DISubprogram(name: "_th_dec_len_bytes", scope: !101, file: !101, line: 403, type: !104, scopeLine: 403, spFlags: DISPFlagDefinition, unit: !100)
!423 = !DILocation(line: 403, column: 0, scope: !422)
!438 = distinct !DISubprogram(name: "_th_dec_container_items", scope: !101, file: !101, line: 423, type: !104, scopeLine: 423, spFlags: DISPFlagDefinition, unit: !100)
!439 = !DILocation(line: 423, column: 0, scope: !438)
!453 = distinct !DISubprogram(name: "_th_decode_value", scope: !101, file: !101, line: 442, type: !104, scopeLine: 442, spFlags: DISPFlagDefinition, unit: !100)
!454 = !DILocation(line: 442, column: 0, scope: !453)
!525 = distinct !DISubprogram(name: "thrift_decode_struct", scope: !101, file: !101, line: 522, type: !104, scopeLine: 522, spFlags: DISPFlagDefinition, unit: !100)
!526 = !DILocation(line: 522, column: 0, scope: !525)
!553 = distinct !DISubprogram(name: "thrift_struct_get", scope: !101, file: !101, line: 555, type: !104, scopeLine: 555, spFlags: DISPFlagDefinition, unit: !100)
!554 = !DILocation(line: 555, column: 0, scope: !553)
!563 = distinct !DISubprogram(name: "thrift_encode_message", scope: !101, file: !101, line: 569, type: !104, scopeLine: 569, spFlags: DISPFlagDefinition, unit: !100)
!564 = !DILocation(line: 569, column: 0, scope: !563)
!572 = distinct !DISubprogram(name: "thrift_decode_message", scope: !101, file: !101, line: 584, type: !104, scopeLine: 584, spFlags: DISPFlagDefinition, unit: !100)
!573 = !DILocation(line: 584, column: 0, scope: !572)
!202 = !DILocation(line: 151, column: 0, scope: !200)
!205 = !DILocation(line: 154, column: 0, scope: !203)
!208 = !DILocation(line: 157, column: 0, scope: !206)
!211 = !DILocation(line: 160, column: 0, scope: !209)
!214 = !DILocation(line: 163, column: 0, scope: !212)
!217 = !DILocation(line: 166, column: 0, scope: !215)
!220 = !DILocation(line: 169, column: 0, scope: !218)
!223 = !DILocation(line: 172, column: 0, scope: !221)
!226 = !DILocation(line: 175, column: 0, scope: !224)
!229 = !DILocation(line: 178, column: 0, scope: !227)
!232 = !DILocation(line: 181, column: 0, scope: !230)
!235 = !DILocation(line: 184, column: 0, scope: !233)
!238 = !DILocation(line: 189, column: 0, scope: !236)
!241 = !DILocation(line: 192, column: 0, scope: !239)
!244 = !DILocation(line: 195, column: 0, scope: !242)
!247 = !DILocation(line: 198, column: 0, scope: !245)
!250 = !DILocation(line: 203, column: 0, scope: !248)
!253 = !DILocation(line: 208, column: 0, scope: !251)
!254 = !DILocation(line: 209, column: 0, scope: !251)
!255 = !DILocation(line: 210, column: 0, scope: !251)
!256 = !DILocation(line: 211, column: 0, scope: !251)
!257 = !DILocation(line: 212, column: 0, scope: !251)
!260 = !DILocation(line: 221, column: 0, scope: !258)
!261 = !DILocation(line: 222, column: 0, scope: !258)
!262 = !DILocation(line: 223, column: 0, scope: !258)
!263 = !DILocation(line: 225, column: 0, scope: !258)
!264 = !DILocation(line: 226, column: 0, scope: !258)
!265 = !DILocation(line: 227, column: 0, scope: !258)
!268 = !DILocation(line: 231, column: 0, scope: !266)
!269 = !DILocation(line: 232, column: 0, scope: !266)
!270 = !DILocation(line: 233, column: 0, scope: !266)
!271 = !DILocation(line: 234, column: 0, scope: !266)
!272 = !DILocation(line: 235, column: 0, scope: !266)
!273 = !DILocation(line: 236, column: 0, scope: !266)
!274 = !DILocation(line: 237, column: 0, scope: !266)
!277 = !DILocation(line: 244, column: 0, scope: !275)
!278 = !DILocation(line: 245, column: 0, scope: !275)
!279 = !DILocation(line: 246, column: 0, scope: !275)
!280 = !DILocation(line: 247, column: 0, scope: !275)
!281 = !DILocation(line: 248, column: 0, scope: !275)
!282 = !DILocation(line: 249, column: 0, scope: !275)
!283 = !DILocation(line: 250, column: 0, scope: !275)
!284 = !DILocation(line: 251, column: 0, scope: !275)
!285 = !DILocation(line: 252, column: 0, scope: !275)
!286 = !DILocation(line: 253, column: 0, scope: !275)
!287 = !DILocation(line: 254, column: 0, scope: !275)
!288 = !DILocation(line: 255, column: 0, scope: !275)
!289 = !DILocation(line: 256, column: 0, scope: !275)
!290 = !DILocation(line: 257, column: 0, scope: !275)
!291 = !DILocation(line: 258, column: 0, scope: !275)
!292 = !DILocation(line: 259, column: 0, scope: !275)
!293 = !DILocation(line: 260, column: 0, scope: !275)
!294 = !DILocation(line: 261, column: 0, scope: !275)
!295 = !DILocation(line: 262, column: 0, scope: !275)
!296 = !DILocation(line: 263, column: 0, scope: !275)
!297 = !DILocation(line: 264, column: 0, scope: !275)
!298 = !DILocation(line: 265, column: 0, scope: !275)
!299 = !DILocation(line: 266, column: 0, scope: !275)
!300 = !DILocation(line: 267, column: 0, scope: !275)
!301 = !DILocation(line: 268, column: 0, scope: !275)
!302 = !DILocation(line: 269, column: 0, scope: !275)
!303 = !DILocation(line: 270, column: 0, scope: !275)
!304 = !DILocation(line: 271, column: 0, scope: !275)
!305 = !DILocation(line: 272, column: 0, scope: !275)
!306 = !DILocation(line: 273, column: 0, scope: !275)
!307 = !DILocation(line: 274, column: 0, scope: !275)
!308 = !DILocation(line: 275, column: 0, scope: !275)
!309 = !DILocation(line: 276, column: 0, scope: !275)
!310 = !DILocation(line: 277, column: 0, scope: !275)
!311 = !DILocation(line: 278, column: 0, scope: !275)
!312 = !DILocation(line: 279, column: 0, scope: !275)
!313 = !DILocation(line: 280, column: 0, scope: !275)
!314 = !DILocation(line: 281, column: 0, scope: !275)
!315 = !DILocation(line: 282, column: 0, scope: !275)
!316 = !DILocation(line: 283, column: 0, scope: !275)
!317 = !DILocation(line: 284, column: 0, scope: !275)
!320 = !DILocation(line: 288, column: 0, scope: !318)
!321 = !DILocation(line: 289, column: 0, scope: !318)
!322 = !DILocation(line: 290, column: 0, scope: !318)
!325 = !DILocation(line: 295, column: 0, scope: !323)
!326 = !DILocation(line: 296, column: 0, scope: !323)
!327 = !DILocation(line: 297, column: 0, scope: !323)
!328 = !DILocation(line: 298, column: 0, scope: !323)
!329 = !DILocation(line: 299, column: 0, scope: !323)
!330 = !DILocation(line: 300, column: 0, scope: !323)
!331 = !DILocation(line: 301, column: 0, scope: !323)
!332 = !DILocation(line: 302, column: 0, scope: !323)
!335 = !DILocation(line: 305, column: 0, scope: !333)
!336 = !DILocation(line: 306, column: 0, scope: !333)
!337 = !DILocation(line: 307, column: 0, scope: !333)
!338 = !DILocation(line: 308, column: 0, scope: !333)
!339 = !DILocation(line: 309, column: 0, scope: !333)
!342 = !DILocation(line: 312, column: 0, scope: !340)
!343 = !DILocation(line: 313, column: 0, scope: !340)
!344 = !DILocation(line: 314, column: 0, scope: !340)
!345 = !DILocation(line: 315, column: 0, scope: !340)
!346 = !DILocation(line: 316, column: 0, scope: !340)
!349 = !DILocation(line: 319, column: 0, scope: !347)
!350 = !DILocation(line: 320, column: 0, scope: !347)
!351 = !DILocation(line: 321, column: 0, scope: !347)
!352 = !DILocation(line: 322, column: 0, scope: !347)
!353 = !DILocation(line: 323, column: 0, scope: !347)
!356 = !DILocation(line: 326, column: 0, scope: !354)
!357 = !DILocation(line: 327, column: 0, scope: !354)
!358 = !DILocation(line: 328, column: 0, scope: !354)
!359 = !DILocation(line: 329, column: 0, scope: !354)
!360 = !DILocation(line: 330, column: 0, scope: !354)
!363 = !DILocation(line: 333, column: 0, scope: !361)
!364 = !DILocation(line: 334, column: 0, scope: !361)
!365 = !DILocation(line: 335, column: 0, scope: !361)
!366 = !DILocation(line: 336, column: 0, scope: !361)
!367 = !DILocation(line: 337, column: 0, scope: !361)
!370 = !DILocation(line: 340, column: 0, scope: !368)
!371 = !DILocation(line: 341, column: 0, scope: !368)
!372 = !DILocation(line: 342, column: 0, scope: !368)
!373 = !DILocation(line: 343, column: 0, scope: !368)
!374 = !DILocation(line: 344, column: 0, scope: !368)
!377 = !DILocation(line: 347, column: 0, scope: !375)
!378 = !DILocation(line: 348, column: 0, scope: !375)
!379 = !DILocation(line: 349, column: 0, scope: !375)
!380 = !DILocation(line: 350, column: 0, scope: !375)
!381 = !DILocation(line: 351, column: 0, scope: !375)
!384 = !DILocation(line: 354, column: 0, scope: !382)
!385 = !DILocation(line: 355, column: 0, scope: !382)
!386 = !DILocation(line: 356, column: 0, scope: !382)
!387 = !DILocation(line: 357, column: 0, scope: !382)
!388 = !DILocation(line: 358, column: 0, scope: !382)
!389 = !DILocation(line: 359, column: 0, scope: !382)
!390 = !DILocation(line: 360, column: 0, scope: !382)
!391 = !DILocation(line: 361, column: 0, scope: !382)
!394 = !DILocation(line: 364, column: 0, scope: !392)
!395 = !DILocation(line: 365, column: 0, scope: !392)
!396 = !DILocation(line: 366, column: 0, scope: !392)
!397 = !DILocation(line: 367, column: 0, scope: !392)
!398 = !DILocation(line: 368, column: 0, scope: !392)
!399 = !DILocation(line: 369, column: 0, scope: !392)
!400 = !DILocation(line: 370, column: 0, scope: !392)
!401 = !DILocation(line: 371, column: 0, scope: !392)
!404 = !DILocation(line: 374, column: 0, scope: !402)
!405 = !DILocation(line: 375, column: 0, scope: !402)
!406 = !DILocation(line: 376, column: 0, scope: !402)
!407 = !DILocation(line: 377, column: 0, scope: !402)
!408 = !DILocation(line: 378, column: 0, scope: !402)
!409 = !DILocation(line: 379, column: 0, scope: !402)
!410 = !DILocation(line: 380, column: 0, scope: !402)
!411 = !DILocation(line: 381, column: 0, scope: !402)
!412 = !DILocation(line: 382, column: 0, scope: !402)
!415 = !DILocation(line: 388, column: 0, scope: !413)
!416 = !DILocation(line: 389, column: 0, scope: !413)
!417 = !DILocation(line: 390, column: 0, scope: !413)
!418 = !DILocation(line: 391, column: 0, scope: !413)
!419 = !DILocation(line: 392, column: 0, scope: !413)
!420 = !DILocation(line: 393, column: 0, scope: !413)
!421 = !DILocation(line: 394, column: 0, scope: !413)
!424 = !DILocation(line: 404, column: 0, scope: !422)
!425 = !DILocation(line: 405, column: 0, scope: !422)
!426 = !DILocation(line: 406, column: 0, scope: !422)
!427 = !DILocation(line: 407, column: 0, scope: !422)
!428 = !DILocation(line: 408, column: 0, scope: !422)
!429 = !DILocation(line: 409, column: 0, scope: !422)
!430 = !DILocation(line: 410, column: 0, scope: !422)
!431 = !DILocation(line: 411, column: 0, scope: !422)
!432 = !DILocation(line: 412, column: 0, scope: !422)
!433 = !DILocation(line: 413, column: 0, scope: !422)
!434 = !DILocation(line: 414, column: 0, scope: !422)
!435 = !DILocation(line: 415, column: 0, scope: !422)
!436 = !DILocation(line: 416, column: 0, scope: !422)
!437 = !DILocation(line: 417, column: 0, scope: !422)
!440 = !DILocation(line: 424, column: 0, scope: !438)
!441 = !DILocation(line: 425, column: 0, scope: !438)
!442 = !DILocation(line: 426, column: 0, scope: !438)
!443 = !DILocation(line: 427, column: 0, scope: !438)
!444 = !DILocation(line: 428, column: 0, scope: !438)
!445 = !DILocation(line: 429, column: 0, scope: !438)
!446 = !DILocation(line: 430, column: 0, scope: !438)
!447 = !DILocation(line: 431, column: 0, scope: !438)
!448 = !DILocation(line: 432, column: 0, scope: !438)
!449 = !DILocation(line: 433, column: 0, scope: !438)
!450 = !DILocation(line: 434, column: 0, scope: !438)
!451 = !DILocation(line: 435, column: 0, scope: !438)
!452 = !DILocation(line: 436, column: 0, scope: !438)
!455 = !DILocation(line: 443, column: 0, scope: !453)
!456 = !DILocation(line: 444, column: 0, scope: !453)
!457 = !DILocation(line: 445, column: 0, scope: !453)
!458 = !DILocation(line: 446, column: 0, scope: !453)
!459 = !DILocation(line: 447, column: 0, scope: !453)
!460 = !DILocation(line: 448, column: 0, scope: !453)
!461 = !DILocation(line: 449, column: 0, scope: !453)
!462 = !DILocation(line: 450, column: 0, scope: !453)
!463 = !DILocation(line: 451, column: 0, scope: !453)
!464 = !DILocation(line: 452, column: 0, scope: !453)
!465 = !DILocation(line: 453, column: 0, scope: !453)
!466 = !DILocation(line: 454, column: 0, scope: !453)
!467 = !DILocation(line: 455, column: 0, scope: !453)
!468 = !DILocation(line: 456, column: 0, scope: !453)
!469 = !DILocation(line: 457, column: 0, scope: !453)
!470 = !DILocation(line: 458, column: 0, scope: !453)
!471 = !DILocation(line: 459, column: 0, scope: !453)
!472 = !DILocation(line: 460, column: 0, scope: !453)
!473 = !DILocation(line: 461, column: 0, scope: !453)
!474 = !DILocation(line: 462, column: 0, scope: !453)
!475 = !DILocation(line: 463, column: 0, scope: !453)
!476 = !DILocation(line: 464, column: 0, scope: !453)
!477 = !DILocation(line: 465, column: 0, scope: !453)
!478 = !DILocation(line: 466, column: 0, scope: !453)
!479 = !DILocation(line: 467, column: 0, scope: !453)
!480 = !DILocation(line: 468, column: 0, scope: !453)
!481 = !DILocation(line: 469, column: 0, scope: !453)
!482 = !DILocation(line: 470, column: 0, scope: !453)
!483 = !DILocation(line: 471, column: 0, scope: !453)
!484 = !DILocation(line: 472, column: 0, scope: !453)
!485 = !DILocation(line: 473, column: 0, scope: !453)
!486 = !DILocation(line: 474, column: 0, scope: !453)
!487 = !DILocation(line: 475, column: 0, scope: !453)
!488 = !DILocation(line: 476, column: 0, scope: !453)
!489 = !DILocation(line: 477, column: 0, scope: !453)
!490 = !DILocation(line: 478, column: 0, scope: !453)
!491 = !DILocation(line: 479, column: 0, scope: !453)
!492 = !DILocation(line: 480, column: 0, scope: !453)
!493 = !DILocation(line: 481, column: 0, scope: !453)
!494 = !DILocation(line: 482, column: 0, scope: !453)
!495 = !DILocation(line: 483, column: 0, scope: !453)
!496 = !DILocation(line: 484, column: 0, scope: !453)
!497 = !DILocation(line: 485, column: 0, scope: !453)
!498 = !DILocation(line: 486, column: 0, scope: !453)
!499 = !DILocation(line: 487, column: 0, scope: !453)
!500 = !DILocation(line: 488, column: 0, scope: !453)
!501 = !DILocation(line: 489, column: 0, scope: !453)
!502 = !DILocation(line: 490, column: 0, scope: !453)
!503 = !DILocation(line: 491, column: 0, scope: !453)
!504 = !DILocation(line: 492, column: 0, scope: !453)
!505 = !DILocation(line: 493, column: 0, scope: !453)
!506 = !DILocation(line: 494, column: 0, scope: !453)
!507 = !DILocation(line: 495, column: 0, scope: !453)
!508 = !DILocation(line: 496, column: 0, scope: !453)
!509 = !DILocation(line: 497, column: 0, scope: !453)
!510 = !DILocation(line: 498, column: 0, scope: !453)
!511 = !DILocation(line: 499, column: 0, scope: !453)
!512 = !DILocation(line: 500, column: 0, scope: !453)
!513 = !DILocation(line: 501, column: 0, scope: !453)
!514 = !DILocation(line: 502, column: 0, scope: !453)
!515 = !DILocation(line: 503, column: 0, scope: !453)
!516 = !DILocation(line: 504, column: 0, scope: !453)
!517 = !DILocation(line: 505, column: 0, scope: !453)
!518 = !DILocation(line: 506, column: 0, scope: !453)
!519 = !DILocation(line: 507, column: 0, scope: !453)
!520 = !DILocation(line: 508, column: 0, scope: !453)
!521 = !DILocation(line: 509, column: 0, scope: !453)
!522 = !DILocation(line: 510, column: 0, scope: !453)
!523 = !DILocation(line: 511, column: 0, scope: !453)
!524 = !DILocation(line: 512, column: 0, scope: !453)
!527 = !DILocation(line: 523, column: 0, scope: !525)
!528 = !DILocation(line: 524, column: 0, scope: !525)
!529 = !DILocation(line: 525, column: 0, scope: !525)
!530 = !DILocation(line: 526, column: 0, scope: !525)
!531 = !DILocation(line: 527, column: 0, scope: !525)
!532 = !DILocation(line: 528, column: 0, scope: !525)
!533 = !DILocation(line: 529, column: 0, scope: !525)
!534 = !DILocation(line: 530, column: 0, scope: !525)
!535 = !DILocation(line: 531, column: 0, scope: !525)
!536 = !DILocation(line: 532, column: 0, scope: !525)
!537 = !DILocation(line: 533, column: 0, scope: !525)
!538 = !DILocation(line: 534, column: 0, scope: !525)
!539 = !DILocation(line: 535, column: 0, scope: !525)
!540 = !DILocation(line: 536, column: 0, scope: !525)
!541 = !DILocation(line: 537, column: 0, scope: !525)
!542 = !DILocation(line: 538, column: 0, scope: !525)
!543 = !DILocation(line: 539, column: 0, scope: !525)
!544 = !DILocation(line: 540, column: 0, scope: !525)
!545 = !DILocation(line: 541, column: 0, scope: !525)
!546 = !DILocation(line: 542, column: 0, scope: !525)
!547 = !DILocation(line: 543, column: 0, scope: !525)
!548 = !DILocation(line: 544, column: 0, scope: !525)
!549 = !DILocation(line: 545, column: 0, scope: !525)
!550 = !DILocation(line: 546, column: 0, scope: !525)
!551 = !DILocation(line: 547, column: 0, scope: !525)
!552 = !DILocation(line: 548, column: 0, scope: !525)
!555 = !DILocation(line: 556, column: 0, scope: !553)
!556 = !DILocation(line: 557, column: 0, scope: !553)
!557 = !DILocation(line: 558, column: 0, scope: !553)
!558 = !DILocation(line: 559, column: 0, scope: !553)
!559 = !DILocation(line: 560, column: 0, scope: !553)
!560 = !DILocation(line: 561, column: 0, scope: !553)
!561 = !DILocation(line: 562, column: 0, scope: !553)
!562 = !DILocation(line: 563, column: 0, scope: !553)
!565 = !DILocation(line: 570, column: 0, scope: !563)
!566 = !DILocation(line: 571, column: 0, scope: !563)
!567 = !DILocation(line: 572, column: 0, scope: !563)
!568 = !DILocation(line: 573, column: 0, scope: !563)
!569 = !DILocation(line: 574, column: 0, scope: !563)
!570 = !DILocation(line: 575, column: 0, scope: !563)
!571 = !DILocation(line: 576, column: 0, scope: !563)
!574 = !DILocation(line: 585, column: 0, scope: !572)
!575 = !DILocation(line: 586, column: 0, scope: !572)
!576 = !DILocation(line: 587, column: 0, scope: !572)
!577 = !DILocation(line: 588, column: 0, scope: !572)
!578 = !DILocation(line: 589, column: 0, scope: !572)
!579 = !DILocation(line: 590, column: 0, scope: !572)
!580 = !DILocation(line: 591, column: 0, scope: !572)
!581 = !DILocation(line: 592, column: 0, scope: !572)
!582 = !DILocation(line: 593, column: 0, scope: !572)
!583 = !DILocation(line: 594, column: 0, scope: !572)
!584 = !DILocation(line: 595, column: 0, scope: !572)
!585 = !DILocation(line: 596, column: 0, scope: !572)
!586 = !DILocation(line: 597, column: 0, scope: !572)
!587 = !DILocation(line: 598, column: 0, scope: !572)
!588 = !DILocation(line: 599, column: 0, scope: !572)
!589 = !DILocation(line: 603, column: 0, scope: !572)
!590 = !DILocation(line: 604, column: 0, scope: !572)
!591 = !DILocation(line: 605, column: 0, scope: !572)
!592 = !DILocation(line: 606, column: 0, scope: !572)
!593 = !DILocation(line: 607, column: 0, scope: !572)
!594 = !DILocation(line: 608, column: 0, scope: !572)
!595 = !DILocation(line: 609, column: 0, scope: !572)
!596 = !DILocation(line: 613, column: 0, scope: !572)
!597 = !DILocation(line: 614, column: 0, scope: !572)
!598 = !DILocation(line: 615, column: 0, scope: !572)
!599 = !DILocation(line: 616, column: 0, scope: !572)
!600 = !DILocation(line: 617, column: 0, scope: !572)
!601 = !DILocation(line: 618, column: 0, scope: !572)
!602 = !DILocation(line: 619, column: 0, scope: !572)
!603 = !DILocation(line: 620, column: 0, scope: !572)
!604 = !DILocation(line: 621, column: 0, scope: !572)
!605 = !DILocation(line: 622, column: 0, scope: !572)
!606 = !DILocation(line: 623, column: 0, scope: !572)
!607 = !DILocation(line: 624, column: 0, scope: !572)
!608 = !DILocation(line: 625, column: 0, scope: !572)
!609 = !DILocation(line: 626, column: 0, scope: !572)

; TBAA metadata
!0 = !{!"NOVA TBAA"}
!1 = !{!"list_data_ptr", !0}
!2 = !{!1, !1, i64 0}
!3 = !{!"list_elem", !0}
!4 = !{!3, !3, i64 0}
!5 = !{!"list_size", !0}
!6 = !{!5, !5, i64 0}
!90 = !{!"branch_weights", i32 2000, i32 1}
