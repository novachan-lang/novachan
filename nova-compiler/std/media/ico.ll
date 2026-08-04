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

; ESCAPE _ico_put_u16le: allocs=0 escape=0 local=0
define i64 @_ico_put_u16le(i64 %p0, i64 %p1) nounwind uwtable !dbg !200 {
entry:
  %slot.b = alloca i64, align 8, !dbg !201
  store i64 %p0, ptr %slot.b, align 8, !dbg !201
  %slot.v = alloca i64, align 8, !dbg !201
  store i64 %p1, ptr %slot.v, align 8, !dbg !201
  %slot.out = alloca i64, align 8, !dbg !201
  store i64 0, ptr %slot.out, align 8, !dbg !201
  %r0 = load i64, ptr %slot.b, align 8, !dbg !202
  store i64 %r0, ptr %slot.out, align 8, !dbg !202
  %r1 = add i64 %r0, 0, !dbg !203
  %r2 = load i64, ptr %slot.v, align 8, !dbg !203
  %r3 = add i64 255, 0, !dbg !203
  %r4 = and i64 %r2, %r3, !dbg !203
  %r5 = call i64 @nova_rt_bytes_append(i64 %r1, i64 %r4), !dbg !203
  store i64 %r5, ptr %slot.out, align 8, !dbg !203
  %r6 = add i64 %r5, 0, !dbg !204
  %r7 = load i64, ptr %slot.v, align 8, !dbg !204
  %r8 = add i64 8, 0, !dbg !204
  %r9.sramt = and i64 %r8, 63, !dbg !204
  %r9.srbig = icmp uge i64 %r8, 64, !dbg !204
  %r9.srval = ashr i64 %r7, %r9.sramt, !dbg !204
  %r9.srext = ashr i64 %r7, 63, !dbg !204
  %r9 = select i1 %r9.srbig, i64 %r9.srext, i64 %r9.srval, !dbg !204
  %r10 = add i64 255, 0, !dbg !204
  %r11 = and i64 %r9, %r10, !dbg !204
  %r12 = call i64 @nova_rt_bytes_append(i64 %r6, i64 %r11), !dbg !204
  store i64 %r12, ptr %slot.out, align 8, !dbg !204
  %r13 = add i64 %r12, 0, !dbg !205
  ret i64 %r13, !dbg !205
}

; ESCAPE _ico_put_u32le: allocs=0 escape=0 local=0
define i64 @_ico_put_u32le(i64 %p0, i64 %p1) nounwind uwtable !dbg !206 {
entry:
  %slot.b = alloca i64, align 8, !dbg !207
  store i64 %p0, ptr %slot.b, align 8, !dbg !207
  %slot.v = alloca i64, align 8, !dbg !207
  store i64 %p1, ptr %slot.v, align 8, !dbg !207
  %slot.out = alloca i64, align 8, !dbg !207
  store i64 0, ptr %slot.out, align 8, !dbg !207
  %r0 = load i64, ptr %slot.b, align 8, !dbg !208
  store i64 %r0, ptr %slot.out, align 8, !dbg !208
  %r1 = add i64 %r0, 0, !dbg !209
  %r2 = load i64, ptr %slot.v, align 8, !dbg !209
  %r3 = add i64 255, 0, !dbg !209
  %r4 = and i64 %r2, %r3, !dbg !209
  %r5 = call i64 @nova_rt_bytes_append(i64 %r1, i64 %r4), !dbg !209
  store i64 %r5, ptr %slot.out, align 8, !dbg !209
  %r6 = add i64 %r5, 0, !dbg !210
  %r7 = load i64, ptr %slot.v, align 8, !dbg !210
  %r8 = add i64 8, 0, !dbg !210
  %r9.sramt = and i64 %r8, 63, !dbg !210
  %r9.srbig = icmp uge i64 %r8, 64, !dbg !210
  %r9.srval = ashr i64 %r7, %r9.sramt, !dbg !210
  %r9.srext = ashr i64 %r7, 63, !dbg !210
  %r9 = select i1 %r9.srbig, i64 %r9.srext, i64 %r9.srval, !dbg !210
  %r10 = add i64 255, 0, !dbg !210
  %r11 = and i64 %r9, %r10, !dbg !210
  %r12 = call i64 @nova_rt_bytes_append(i64 %r6, i64 %r11), !dbg !210
  store i64 %r12, ptr %slot.out, align 8, !dbg !210
  %r13 = add i64 %r12, 0, !dbg !211
  %r14 = load i64, ptr %slot.v, align 8, !dbg !211
  %r15 = add i64 16, 0, !dbg !211
  %r16.sramt = and i64 %r15, 63, !dbg !211
  %r16.srbig = icmp uge i64 %r15, 64, !dbg !211
  %r16.srval = ashr i64 %r14, %r16.sramt, !dbg !211
  %r16.srext = ashr i64 %r14, 63, !dbg !211
  %r16 = select i1 %r16.srbig, i64 %r16.srext, i64 %r16.srval, !dbg !211
  %r17 = add i64 255, 0, !dbg !211
  %r18 = and i64 %r16, %r17, !dbg !211
  %r19 = call i64 @nova_rt_bytes_append(i64 %r13, i64 %r18), !dbg !211
  store i64 %r19, ptr %slot.out, align 8, !dbg !211
  %r20 = add i64 %r19, 0, !dbg !212
  %r21 = load i64, ptr %slot.v, align 8, !dbg !212
  %r22 = add i64 24, 0, !dbg !212
  %r23.sramt = and i64 %r22, 63, !dbg !212
  %r23.srbig = icmp uge i64 %r22, 64, !dbg !212
  %r23.srval = ashr i64 %r21, %r23.sramt, !dbg !212
  %r23.srext = ashr i64 %r21, 63, !dbg !212
  %r23 = select i1 %r23.srbig, i64 %r23.srext, i64 %r23.srval, !dbg !212
  %r24 = add i64 255, 0, !dbg !212
  %r25 = and i64 %r23, %r24, !dbg !212
  %r26 = call i64 @nova_rt_bytes_append(i64 %r20, i64 %r25), !dbg !212
  store i64 %r26, ptr %slot.out, align 8, !dbg !212
  %r27 = add i64 %r26, 0, !dbg !213
  ret i64 %r27, !dbg !213
}

; ESCAPE _ico_get_u16le: allocs=0 escape=0 local=0
define i64 @_ico_get_u16le(i64 %p0, i64 %p1) nounwind uwtable !dbg !214 {
entry:
  %slot.b = alloca i64, align 8, !dbg !215
  store i64 %p0, ptr %slot.b, align 8, !dbg !215
  %slot.i = alloca i64, align 8, !dbg !215
  store i64 %p1, ptr %slot.i, align 8, !dbg !215
  %slot.blen = alloca i64, align 8, !dbg !215
  store i64 0, ptr %slot.blen, align 8, !dbg !215
  %slot.result = alloca i64, align 8, !dbg !215
  store i64 0, ptr %slot.result, align 8, !dbg !215
  %slot.lo = alloca i64, align 8, !dbg !215
  store i64 0, ptr %slot.lo, align 8, !dbg !215
  %slot.hi = alloca i64, align 8, !dbg !215
  store i64 0, ptr %slot.hi, align 8, !dbg !215
  %r0 = load i64, ptr %slot.b, align 8, !dbg !216
  %r1 = call i64 @nova_rt_bytes_len(i64 %r0), !dbg !216
  store i64 %r1, ptr %slot.blen, align 8, !dbg !216
  %r2 = add i64 0, 0, !dbg !217
  store i64 %r2, ptr %slot.result, align 8, !dbg !217
  %r3 = load i64, ptr %slot.i, align 8, !dbg !218
  %r4 = add i64 1, 0, !dbg !218
  %r5 = add i64 %r3, %r4, !dbg !218
  %r6 = add i64 %r1, 0, !dbg !218
  %r7.cmp = icmp slt i64 %r5, %r6, !dbg !218
  %r7 = zext i1 %r7.cmp to i64, !dbg !218
  %br_then00 = icmp ne i64 %r7, 0, !dbg !218
  br i1 %br_then00, label %then0, label %else1, !dbg !218
then0:
  %r8 = load i64, ptr %slot.b, align 8, !dbg !219
  %r9 = load i64, ptr %slot.i, align 8, !dbg !219
  %r10 = call i64 @nova_rt_bytes_get(i64 %r8, i64 %r9), !dbg !219
  store i64 %r10, ptr %slot.lo, align 8, !dbg !219
  %r11 = load i64, ptr %slot.b, align 8, !dbg !220
  %r12 = load i64, ptr %slot.i, align 8, !dbg !220
  %r13 = add i64 1, 0, !dbg !220
  %r14 = add i64 %r12, %r13, !dbg !220
  %r15 = call i64 @nova_rt_bytes_get(i64 %r11, i64 %r14), !dbg !220
  store i64 %r15, ptr %slot.hi, align 8, !dbg !220
  %r16 = add i64 %r10, 0, !dbg !221
  %r17 = add i64 %r15, 0, !dbg !221
  %r18 = add i64 256, 0, !dbg !221
  %r19 = mul i64 %r17, %r18, !dbg !221
  %r20 = or i64 %r16, %r19, !dbg !221
  store i64 %r20, ptr %slot.result, align 8, !dbg !221
  br label %endif2, !dbg !221
else1:
  br label %endif2, !dbg !221
endif2:
  %r21 = load i64, ptr %slot.result, align 8, !dbg !222
  ret i64 %r21, !dbg !222
}

; ESCAPE _ico_get_u32le: allocs=0 escape=0 local=0
define i64 @_ico_get_u32le(i64 %p0, i64 %p1) nounwind uwtable !dbg !223 {
entry:
  %slot.b = alloca i64, align 8, !dbg !224
  store i64 %p0, ptr %slot.b, align 8, !dbg !224
  %slot.i = alloca i64, align 8, !dbg !224
  store i64 %p1, ptr %slot.i, align 8, !dbg !224
  %slot.blen = alloca i64, align 8, !dbg !224
  store i64 0, ptr %slot.blen, align 8, !dbg !224
  %slot.result = alloca i64, align 8, !dbg !224
  store i64 0, ptr %slot.result, align 8, !dbg !224
  %slot.b0 = alloca i64, align 8, !dbg !224
  store i64 0, ptr %slot.b0, align 8, !dbg !224
  %slot.b1 = alloca i64, align 8, !dbg !224
  store i64 0, ptr %slot.b1, align 8, !dbg !224
  %slot.b2 = alloca i64, align 8, !dbg !224
  store i64 0, ptr %slot.b2, align 8, !dbg !224
  %slot.b3 = alloca i64, align 8, !dbg !224
  store i64 0, ptr %slot.b3, align 8, !dbg !224
  %r0 = load i64, ptr %slot.b, align 8, !dbg !225
  %r1 = call i64 @nova_rt_bytes_len(i64 %r0), !dbg !225
  store i64 %r1, ptr %slot.blen, align 8, !dbg !225
  %r2 = add i64 0, 0, !dbg !226
  store i64 %r2, ptr %slot.result, align 8, !dbg !226
  %r3 = load i64, ptr %slot.i, align 8, !dbg !227
  %r4 = add i64 3, 0, !dbg !227
  %r5 = add i64 %r3, %r4, !dbg !227
  %r6 = add i64 %r1, 0, !dbg !227
  %r7.cmp = icmp slt i64 %r5, %r6, !dbg !227
  %r7 = zext i1 %r7.cmp to i64, !dbg !227
  %br_then30 = icmp ne i64 %r7, 0, !dbg !227
  br i1 %br_then30, label %then3, label %else4, !dbg !227
then3:
  %r8 = load i64, ptr %slot.b, align 8, !dbg !228
  %r9 = load i64, ptr %slot.i, align 8, !dbg !228
  %r10 = call i64 @nova_rt_bytes_get(i64 %r8, i64 %r9), !dbg !228
  store i64 %r10, ptr %slot.b0, align 8, !dbg !228
  %r11 = load i64, ptr %slot.b, align 8, !dbg !229
  %r12 = load i64, ptr %slot.i, align 8, !dbg !229
  %r13 = add i64 1, 0, !dbg !229
  %r14 = add i64 %r12, %r13, !dbg !229
  %r15 = call i64 @nova_rt_bytes_get(i64 %r11, i64 %r14), !dbg !229
  store i64 %r15, ptr %slot.b1, align 8, !dbg !229
  %r16 = load i64, ptr %slot.b, align 8, !dbg !230
  %r17 = load i64, ptr %slot.i, align 8, !dbg !230
  %r18 = add i64 2, 0, !dbg !230
  %r19 = add i64 %r17, %r18, !dbg !230
  %r20 = call i64 @nova_rt_bytes_get(i64 %r16, i64 %r19), !dbg !230
  store i64 %r20, ptr %slot.b2, align 8, !dbg !230
  %r21 = load i64, ptr %slot.b, align 8, !dbg !231
  %r22 = load i64, ptr %slot.i, align 8, !dbg !231
  %r23 = add i64 3, 0, !dbg !231
  %r24 = add i64 %r22, %r23, !dbg !231
  %r25 = call i64 @nova_rt_bytes_get(i64 %r21, i64 %r24), !dbg !231
  store i64 %r25, ptr %slot.b3, align 8, !dbg !231
  %r26 = add i64 %r10, 0, !dbg !232
  %r27 = add i64 %r15, 0, !dbg !232
  %r28 = add i64 256, 0, !dbg !232
  %r29 = mul i64 %r27, %r28, !dbg !232
  %r30 = or i64 %r26, %r29, !dbg !232
  %r31 = add i64 %r20, 0, !dbg !232
  %r32 = add i64 65536, 0, !dbg !232
  %r33 = mul i64 %r31, %r32, !dbg !232
  %r34 = or i64 %r30, %r33, !dbg !232
  %r35 = add i64 %r25, 0, !dbg !232
  %r36 = add i64 16777216, 0, !dbg !232
  %r37 = mul i64 %r35, %r36, !dbg !232
  %r38 = or i64 %r34, %r37, !dbg !232
  store i64 %r38, ptr %slot.result, align 8, !dbg !232
  br label %endif5, !dbg !232
else4:
  br label %endif5, !dbg !232
endif5:
  %r39 = load i64, ptr %slot.result, align 8, !dbg !233
  ret i64 %r39, !dbg !233
}

; ESCAPE ico_build: allocs=0 escape=0 local=0
define i64 @ico_build(i64 %p0) nounwind uwtable !dbg !234 {
entry:
  %slot.entries = alloca i64, align 8, !dbg !235
  store i64 %p0, ptr %slot.entries, align 8, !dbg !235
  %slot.out = alloca i64, align 8, !dbg !235
  store i64 0, ptr %slot.out, align 8, !dbg !235
  %slot.count = alloca i64, align 8, !dbg !235
  store i64 0, ptr %slot.count, align 8, !dbg !235
  %slot.blob_base = alloca i64, align 8, !dbg !235
  store i64 0, ptr %slot.blob_base, align 8, !dbg !235
  %slot.ei = alloca i64, align 8, !dbg !235
  store i64 0, ptr %slot.ei, align 8, !dbg !235
  %slot.cur_offset = alloca i64, align 8, !dbg !235
  store i64 0, ptr %slot.cur_offset, align 8, !dbg !235
  %slot.entry = alloca i64, align 8, !dbg !235
  store i64 0, ptr %slot.entry, align 8, !dbg !235
  %slot.ew = alloca i64, align 8, !dbg !235
  store i64 0, ptr %slot.ew, align 8, !dbg !235
  %slot.eh = alloca i64, align 8, !dbg !235
  store i64 0, ptr %slot.eh, align 8, !dbg !235
  %slot.ebc = alloca i64, align 8, !dbg !235
  store i64 0, ptr %slot.ebc, align 8, !dbg !235
  %slot.edata = alloca i64, align 8, !dbg !235
  store i64 0, ptr %slot.edata, align 8, !dbg !235
  %slot.esize = alloca i64, align 8, !dbg !235
  store i64 0, ptr %slot.esize, align 8, !dbg !235
  %slot.bi = alloca i64, align 8, !dbg !235
  store i64 0, ptr %slot.bi, align 8, !dbg !235
  %slot.bentry = alloca i64, align 8, !dbg !235
  store i64 0, ptr %slot.bentry, align 8, !dbg !235
  %slot.bdata = alloca i64, align 8, !dbg !235
  store i64 0, ptr %slot.bdata, align 8, !dbg !235
  %r0 = add i64 0, 0, !dbg !236
  %r1 = call i64 @nova_rt_bytes_create(i64 %r0), !dbg !236
  store i64 %r1, ptr %slot.out, align 8, !dbg !236
  %r2 = load i64, ptr %slot.entries, align 8, !dbg !237
  %r3 = call i64 @nova_rt_len_any(i64 %r2), !dbg !237
  store i64 %r3, ptr %slot.count, align 8, !dbg !237
  %r4 = add i64 %r3, 0, !dbg !238
  %r5 = add i64 0, 0, !dbg !238
  %r6.cmp = icmp sgt i64 %r4, %r5, !dbg !238
  %r6 = zext i1 %r6.cmp to i64, !dbg !238
  %br_then60 = icmp ne i64 %r6, 0, !dbg !238
  br i1 %br_then60, label %then6, label %else7, !dbg !238
then6:
  %r7 = add i64 6, 0, !dbg !239
  %r8 = add i64 16, 0, !dbg !239
  %r9 = load i64, ptr %slot.count, align 8, !dbg !239
  %r10 = mul i64 %r8, %r9, !dbg !239
  %r11 = add i64 %r7, %r10, !dbg !239
  store i64 %r11, ptr %slot.blob_base, align 8, !dbg !239
  %r12 = load i64, ptr %slot.out, align 8, !dbg !240
  %r13 = add i64 0, 0, !dbg !240
  %r14 = call i64 @_ico_put_u16le(i64 %r12, i64 %r13), !dbg !240
  store i64 %r14, ptr %slot.out, align 8, !dbg !240
  %r15 = add i64 %r14, 0, !dbg !241
  %r16 = add i64 1, 0, !dbg !241
  %r17 = call i64 @_ico_put_u16le(i64 %r15, i64 %r16), !dbg !241
  store i64 %r17, ptr %slot.out, align 8, !dbg !241
  %r18 = add i64 %r17, 0, !dbg !242
  %r19 = load i64, ptr %slot.count, align 8, !dbg !242
  %r20 = call i64 @_ico_put_u16le(i64 %r18, i64 %r19), !dbg !242
  store i64 %r20, ptr %slot.out, align 8, !dbg !242
  %r21 = add i64 0, 0, !dbg !243
  store i64 %r21, ptr %slot.ei, align 8, !dbg !243
  %r22 = add i64 %r11, 0, !dbg !244
  store i64 %r22, ptr %slot.cur_offset, align 8, !dbg !244
  br label %while_hdr9, !dbg !245
while_hdr9:
  %r23 = load i64, ptr %slot.ei, align 8, !dbg !245
  %r24 = load i64, ptr %slot.count, align 8, !dbg !245
  %r25.cmp = icmp slt i64 %r23, %r24, !dbg !245
  %r25 = zext i1 %r25.cmp to i64, !dbg !245
  %br_while_body101 = icmp ne i64 %r25, 0, !dbg !245
  br i1 %br_while_body101, label %while_body10, label %while_exit11, !prof !90, !dbg !245
while_body10:
  %r26 = load i64, ptr %slot.entries, align 8, !dbg !246
  %r27 = load i64, ptr %slot.ei, align 8, !dbg !246
  %r28 = call i64 @nova_rt_index_get(i64 %r26, i64 %r27), !dbg !246
  store i64 %r28, ptr %slot.entry, align 8, !dbg !246
  %r29 = add i64 %r28, 0, !dbg !247
  %r30.p = getelementptr inbounds [2 x i8], ptr @.str.0, i64 0, i64 0, !dbg !247
  %r30 = ptrtoint ptr %r30.p to i64, !dbg !247
  %r31 = call i64 @nova_rt_index_get(i64 %r29, i64 %r30), !dbg !247
  store i64 %r31, ptr %slot.ew, align 8, !dbg !247
  %r32 = add i64 %r28, 0, !dbg !248
  %r33.p = getelementptr inbounds [2 x i8], ptr @.str.1, i64 0, i64 0, !dbg !248
  %r33 = ptrtoint ptr %r33.p to i64, !dbg !248
  %r34 = call i64 @nova_rt_index_get(i64 %r32, i64 %r33), !dbg !248
  store i64 %r34, ptr %slot.eh, align 8, !dbg !248
  %r35 = add i64 %r28, 0, !dbg !249
  %r36.p = getelementptr inbounds [9 x i8], ptr @.str.2, i64 0, i64 0, !dbg !249
  %r36 = ptrtoint ptr %r36.p to i64, !dbg !249
  %r37 = call i64 @nova_rt_index_get(i64 %r35, i64 %r36), !dbg !249
  store i64 %r37, ptr %slot.ebc, align 8, !dbg !249
  %r38 = add i64 %r28, 0, !dbg !250
  %r39.p = getelementptr inbounds [5 x i8], ptr @.str.3, i64 0, i64 0, !dbg !250
  %r39 = ptrtoint ptr %r39.p to i64, !dbg !250
  %r40 = call i64 @nova_rt_index_get(i64 %r38, i64 %r39), !dbg !250
  store i64 %r40, ptr %slot.edata, align 8, !dbg !250
  %r41 = add i64 %r40, 0, !dbg !251
  %r42 = call i64 @nova_rt_bytes_len(i64 %r41), !dbg !251
  store i64 %r42, ptr %slot.esize, align 8, !dbg !251
  %r43 = load i64, ptr %slot.out, align 8, !dbg !252
  %r44 = add i64 %r31, 0, !dbg !252
  %r45 = add i64 255, 0, !dbg !252
  %r46 = and i64 %r44, %r45, !dbg !252
  %r47 = call i64 @nova_rt_bytes_append(i64 %r43, i64 %r46), !dbg !252
  store i64 %r47, ptr %slot.out, align 8, !dbg !252
  %r48 = add i64 %r47, 0, !dbg !253
  %r49 = add i64 %r34, 0, !dbg !253
  %r50 = add i64 255, 0, !dbg !253
  %r51 = and i64 %r49, %r50, !dbg !253
  %r52 = call i64 @nova_rt_bytes_append(i64 %r48, i64 %r51), !dbg !253
  store i64 %r52, ptr %slot.out, align 8, !dbg !253
  %r53 = add i64 %r52, 0, !dbg !254
  %r54 = add i64 0, 0, !dbg !254
  %r55 = call i64 @nova_rt_bytes_append(i64 %r53, i64 %r54), !dbg !254
  store i64 %r55, ptr %slot.out, align 8, !dbg !254
  %r56 = add i64 %r55, 0, !dbg !255
  %r57 = add i64 0, 0, !dbg !255
  %r58 = call i64 @nova_rt_bytes_append(i64 %r56, i64 %r57), !dbg !255
  store i64 %r58, ptr %slot.out, align 8, !dbg !255
  %r59 = add i64 %r58, 0, !dbg !256
  %r60 = add i64 1, 0, !dbg !256
  %r61 = call i64 @_ico_put_u16le(i64 %r59, i64 %r60), !dbg !256
  store i64 %r61, ptr %slot.out, align 8, !dbg !256
  %r62 = add i64 %r61, 0, !dbg !257
  %r63 = add i64 %r37, 0, !dbg !257
  %r64 = call i64 @_ico_put_u16le(i64 %r62, i64 %r63), !dbg !257
  store i64 %r64, ptr %slot.out, align 8, !dbg !257
  %r65 = add i64 %r64, 0, !dbg !258
  %r66 = add i64 %r42, 0, !dbg !258
  %r67 = call i64 @_ico_put_u32le(i64 %r65, i64 %r66), !dbg !258
  store i64 %r67, ptr %slot.out, align 8, !dbg !258
  %r68 = add i64 %r67, 0, !dbg !259
  %r69 = load i64, ptr %slot.cur_offset, align 8, !dbg !259
  %r70 = call i64 @_ico_put_u32le(i64 %r68, i64 %r69), !dbg !259
  store i64 %r70, ptr %slot.out, align 8, !dbg !259
  %r71 = load i64, ptr %slot.cur_offset, align 8, !dbg !260
  %r72 = add i64 %r42, 0, !dbg !260
  %r73 = add i64 %r71, %r72, !dbg !260
  store i64 %r73, ptr %slot.cur_offset, align 8, !dbg !260
  %r74 = load i64, ptr %slot.ei, align 8, !dbg !261
  %r75 = add i64 1, 0, !dbg !261
  %r76 = add i64 %r74, %r75, !dbg !261
  store i64 %r76, ptr %slot.ei, align 8, !dbg !261
  br label %while_hdr9, !dbg !261
while_exit11:
  %r77 = add i64 0, 0, !dbg !262
  store i64 %r77, ptr %slot.bi, align 8, !dbg !262
  br label %while_hdr12, !dbg !263
while_hdr12:
  %r78 = load i64, ptr %slot.bi, align 8, !dbg !263
  %r79 = load i64, ptr %slot.count, align 8, !dbg !263
  %r80.cmp = icmp slt i64 %r78, %r79, !dbg !263
  %r80 = zext i1 %r80.cmp to i64, !dbg !263
  %br_while_body132 = icmp ne i64 %r80, 0, !dbg !263
  br i1 %br_while_body132, label %while_body13, label %while_exit14, !prof !90, !dbg !263
while_body13:
  %r81 = load i64, ptr %slot.entries, align 8, !dbg !264
  %r82 = load i64, ptr %slot.bi, align 8, !dbg !264
  %r83 = call i64 @nova_rt_index_get(i64 %r81, i64 %r82), !dbg !264
  store i64 %r83, ptr %slot.bentry, align 8, !dbg !264
  %r84 = add i64 %r83, 0, !dbg !265
  %r85.p = getelementptr inbounds [5 x i8], ptr @.str.3, i64 0, i64 0, !dbg !265
  %r85 = ptrtoint ptr %r85.p to i64, !dbg !265
  %r86 = call i64 @nova_rt_index_get(i64 %r84, i64 %r85), !dbg !265
  store i64 %r86, ptr %slot.bdata, align 8, !dbg !265
  %r87 = load i64, ptr %slot.out, align 8, !dbg !266
  %r88 = add i64 %r86, 0, !dbg !266
  %r89 = call i64 @nova_rt_bytes_concat(i64 %r87, i64 %r88), !dbg !266
  store i64 %r89, ptr %slot.out, align 8, !dbg !266
  %r90 = load i64, ptr %slot.bi, align 8, !dbg !267
  %r91 = add i64 1, 0, !dbg !267
  %r92 = add i64 %r90, %r91, !dbg !267
  store i64 %r92, ptr %slot.bi, align 8, !dbg !267
  br label %while_hdr12, !dbg !267
while_exit14:
  br label %endif8, !dbg !267
else7:
  br label %endif8, !dbg !267
endif8:
  %r93 = load i64, ptr %slot.out, align 8, !dbg !268
  ret i64 %r93, !dbg !268
}

; ESCAPE ico_parse: allocs=3 escape=2 local=1
define i64 @ico_parse(i64 %p0) nounwind uwtable !dbg !269 {
entry:
  %slot.b = alloca i64, align 8, !dbg !270
  store i64 %p0, ptr %slot.b, align 8, !dbg !270
  %slot.empty = alloca i64, align 8, !dbg !270
  store i64 0, ptr %slot.empty, align 8, !dbg !270
  %slot.result = alloca i64, align 8, !dbg !270
  store i64 0, ptr %slot.result, align 8, !dbg !270
  %slot.blen = alloca i64, align 8, !dbg !270
  store i64 0, ptr %slot.blen, align 8, !dbg !270
  %slot.ok = alloca i64, align 8, !dbg !270
  store i64 0, ptr %slot.ok, align 8, !dbg !270
  %slot.reserved = alloca i64, align 8, !dbg !270
  store i64 0, ptr %slot.reserved, align 8, !dbg !270
  %slot.itype = alloca i64, align 8, !dbg !270
  store i64 0, ptr %slot.itype, align 8, !dbg !270
  %slot.count = alloca i64, align 8, !dbg !270
  store i64 0, ptr %slot.count, align 8, !dbg !270
  %slot.dir_end = alloca i64, align 8, !dbg !270
  store i64 0, ptr %slot.dir_end, align 8, !dbg !270
  %slot.entries = alloca i64, align 8, !dbg !270
  store i64 0, ptr %slot.entries, align 8, !dbg !270
  %slot.ei = alloca i64, align 8, !dbg !270
  store i64 0, ptr %slot.ei, align 8, !dbg !270
  %slot.entry_off = alloca i64, align 8, !dbg !270
  store i64 0, ptr %slot.entry_off, align 8, !dbg !270
  %slot.ew = alloca i64, align 8, !dbg !270
  store i64 0, ptr %slot.ew, align 8, !dbg !270
  %slot.eh = alloca i64, align 8, !dbg !270
  store i64 0, ptr %slot.eh, align 8, !dbg !270
  %slot.esize = alloca i64, align 8, !dbg !270
  store i64 0, ptr %slot.esize, align 8, !dbg !270
  %slot.eoffset = alloca i64, align 8, !dbg !270
  store i64 0, ptr %slot.eoffset, align 8, !dbg !270
  %slot.edict = alloca i64, align 8, !dbg !270
  store i64 0, ptr %slot.edict, align 8, !dbg !270
  %r0 = call i64 @nova_rt_list_create(), !dbg !271
  store i64 %r0, ptr %slot.empty, align 8, !dbg !271
  %r1 = add i64 %r0, 0, !dbg !272
  store i64 %r1, ptr %slot.result, align 8, !dbg !272
  %r2 = load i64, ptr %slot.b, align 8, !dbg !273
  %r3 = call i64 @nova_rt_bytes_len(i64 %r2), !dbg !273
  store i64 %r3, ptr %slot.blen, align 8, !dbg !273
  %r4 = add i64 1, 0, !dbg !274
  store i64 %r4, ptr %slot.ok, align 8, !dbg !274
  %r5 = add i64 %r3, 0, !dbg !275
  %r6 = add i64 6, 0, !dbg !275
  %r7.cmp = icmp slt i64 %r5, %r6, !dbg !275
  %r7 = zext i1 %r7.cmp to i64, !dbg !275
  %br_then150 = icmp ne i64 %r7, 0, !dbg !275
  br i1 %br_then150, label %then15, label %else16, !dbg !275
then15:
  %r8 = add i64 0, 0, !dbg !276
  store i64 %r8, ptr %slot.ok, align 8, !dbg !276
  br label %endif17, !dbg !276
else16:
  br label %endif17, !dbg !276
endif17:
  %r9 = load i64, ptr %slot.ok, align 8, !dbg !277
  %r10 = add i64 1, 0, !dbg !277
  %r11.cmp = icmp eq i64 %r9, %r10, !dbg !277
  %r11 = zext i1 %r11.cmp to i64, !dbg !277
  %br_then181 = icmp ne i64 %r11, 0, !dbg !277
  br i1 %br_then181, label %then18, label %else19, !dbg !277
then18:
  %r12 = load i64, ptr %slot.b, align 8, !dbg !278
  %r13 = add i64 0, 0, !dbg !278
  %r14 = call i64 @_ico_get_u16le(i64 %r12, i64 %r13), !dbg !278
  store i64 %r14, ptr %slot.reserved, align 8, !dbg !278
  %r15 = add i64 %r14, 0, !dbg !279
  %r16 = add i64 0, 0, !dbg !279
  %r17.cmp = icmp ne i64 %r15, %r16, !dbg !279
  %r17 = zext i1 %r17.cmp to i64, !dbg !279
  %br_then212 = icmp ne i64 %r17, 0, !dbg !279
  br i1 %br_then212, label %then21, label %else22, !dbg !279
then21:
  %r18 = add i64 0, 0, !dbg !280
  store i64 %r18, ptr %slot.ok, align 8, !dbg !280
  br label %endif23, !dbg !280
else22:
  br label %endif23, !dbg !280
endif23:
  br label %endif20, !dbg !280
else19:
  br label %endif20, !dbg !280
endif20:
  %r19 = load i64, ptr %slot.ok, align 8, !dbg !281
  %r20 = add i64 1, 0, !dbg !281
  %r21.cmp = icmp eq i64 %r19, %r20, !dbg !281
  %r21 = zext i1 %r21.cmp to i64, !dbg !281
  %br_then243 = icmp ne i64 %r21, 0, !dbg !281
  br i1 %br_then243, label %then24, label %else25, !dbg !281
then24:
  %r22 = load i64, ptr %slot.b, align 8, !dbg !282
  %r23 = add i64 2, 0, !dbg !282
  %r24 = call i64 @_ico_get_u16le(i64 %r22, i64 %r23), !dbg !282
  store i64 %r24, ptr %slot.itype, align 8, !dbg !282
  %r25 = add i64 %r24, 0, !dbg !283
  %r26 = add i64 1, 0, !dbg !283
  %r27.cmp = icmp ne i64 %r25, %r26, !dbg !283
  %r27 = zext i1 %r27.cmp to i64, !dbg !283
  %br_then274 = icmp ne i64 %r27, 0, !dbg !283
  br i1 %br_then274, label %then27, label %else28, !dbg !283
then27:
  %r28 = load i64, ptr %slot.itype, align 8, !dbg !284
  %r29 = add i64 2, 0, !dbg !284
  %r30.cmp = icmp ne i64 %r28, %r29, !dbg !284
  %r30 = zext i1 %r30.cmp to i64, !dbg !284
  %br_then305 = icmp ne i64 %r30, 0, !dbg !284
  br i1 %br_then305, label %then30, label %else31, !dbg !284
then30:
  %r31 = add i64 0, 0, !dbg !285
  store i64 %r31, ptr %slot.ok, align 8, !dbg !285
  br label %endif32, !dbg !285
else31:
  br label %endif32, !dbg !285
endif32:
  br label %endif29, !dbg !285
else28:
  br label %endif29, !dbg !285
endif29:
  br label %endif26, !dbg !285
else25:
  br label %endif26, !dbg !285
endif26:
  %r32 = load i64, ptr %slot.ok, align 8, !dbg !286
  %r33 = add i64 1, 0, !dbg !286
  %r34.cmp = icmp eq i64 %r32, %r33, !dbg !286
  %r34 = zext i1 %r34.cmp to i64, !dbg !286
  %br_then336 = icmp ne i64 %r34, 0, !dbg !286
  br i1 %br_then336, label %then33, label %else34, !dbg !286
then33:
  %r35 = load i64, ptr %slot.b, align 8, !dbg !287
  %r36 = add i64 4, 0, !dbg !287
  %r37 = call i64 @_ico_get_u16le(i64 %r35, i64 %r36), !dbg !287
  store i64 %r37, ptr %slot.count, align 8, !dbg !287
  %r38 = add i64 6, 0, !dbg !288
  %r39 = add i64 %r37, 0, !dbg !288
  %r40 = add i64 16, 0, !dbg !288
  %r41 = mul i64 %r39, %r40, !dbg !288
  %r42 = add i64 %r38, %r41, !dbg !288
  store i64 %r42, ptr %slot.dir_end, align 8, !dbg !288
  %r43 = load i64, ptr %slot.blen, align 8, !dbg !289
  %r44 = add i64 %r42, 0, !dbg !289
  %r45.cmp = icmp slt i64 %r43, %r44, !dbg !289
  %r45 = zext i1 %r45.cmp to i64, !dbg !289
  %br_then367 = icmp ne i64 %r45, 0, !dbg !289
  br i1 %br_then367, label %then36, label %else37, !dbg !289
then36:
  %r46 = add i64 0, 0, !dbg !290
  store i64 %r46, ptr %slot.ok, align 8, !dbg !290
  br label %endif38, !dbg !290
else37:
  br label %endif38, !dbg !290
endif38:
  %r47 = load i64, ptr %slot.ok, align 8, !dbg !291
  %r48 = add i64 1, 0, !dbg !291
  %r49.cmp = icmp eq i64 %r47, %r48, !dbg !291
  %r49 = zext i1 %r49.cmp to i64, !dbg !291
  %br_then398 = icmp ne i64 %r49, 0, !dbg !291
  br i1 %br_then398, label %then39, label %else40, !dbg !291
then39:
  %r50 = call i64 @nova_rt_list_create(), !dbg !292
  store i64 %r50, ptr %slot.entries, align 8, !dbg !292
  %r51 = add i64 0, 0, !dbg !293
  store i64 %r51, ptr %slot.ei, align 8, !dbg !293
  br label %while_hdr42, !dbg !294
while_hdr42:
  %r52 = load i64, ptr %slot.ei, align 8, !dbg !294
  %r53 = load i64, ptr %slot.count, align 8, !dbg !294
  %r54.cmp = icmp slt i64 %r52, %r53, !dbg !294
  %r54 = zext i1 %r54.cmp to i64, !dbg !294
  %br_while_body439 = icmp ne i64 %r54, 0, !dbg !294
  br i1 %br_while_body439, label %while_body43, label %while_exit44, !prof !90, !dbg !294
while_body43:
  %r55 = add i64 6, 0, !dbg !295
  %r56 = load i64, ptr %slot.ei, align 8, !dbg !295
  %r57 = add i64 16, 0, !dbg !295
  %r58 = mul i64 %r56, %r57, !dbg !295
  %r59 = add i64 %r55, %r58, !dbg !295
  store i64 %r59, ptr %slot.entry_off, align 8, !dbg !295
  %r60 = add i64 %r59, 0, !dbg !296
  %r61 = add i64 15, 0, !dbg !296
  %r62 = add i64 %r60, %r61, !dbg !296
  %r63 = load i64, ptr %slot.blen, align 8, !dbg !296
  %r64.cmp = icmp slt i64 %r62, %r63, !dbg !296
  %r64 = zext i1 %r64.cmp to i64, !dbg !296
  %br_then4510 = icmp ne i64 %r64, 0, !dbg !296
  br i1 %br_then4510, label %then45, label %else46, !dbg !296
then45:
  %r65 = load i64, ptr %slot.b, align 8, !dbg !297
  %r66 = load i64, ptr %slot.entry_off, align 8, !dbg !297
  %r67 = call i64 @nova_rt_bytes_get(i64 %r65, i64 %r66), !dbg !297
  store i64 %r67, ptr %slot.ew, align 8, !dbg !297
  %r68 = load i64, ptr %slot.b, align 8, !dbg !298
  %r69 = load i64, ptr %slot.entry_off, align 8, !dbg !298
  %r70 = add i64 1, 0, !dbg !298
  %r71 = add i64 %r69, %r70, !dbg !298
  %r72 = call i64 @nova_rt_bytes_get(i64 %r68, i64 %r71), !dbg !298
  store i64 %r72, ptr %slot.eh, align 8, !dbg !298
  %r73 = load i64, ptr %slot.b, align 8, !dbg !299
  %r74 = load i64, ptr %slot.entry_off, align 8, !dbg !299
  %r75 = add i64 8, 0, !dbg !299
  %r76 = add i64 %r74, %r75, !dbg !299
  %r77 = call i64 @_ico_get_u32le(i64 %r73, i64 %r76), !dbg !299
  store i64 %r77, ptr %slot.esize, align 8, !dbg !299
  %r78 = load i64, ptr %slot.b, align 8, !dbg !300
  %r79 = load i64, ptr %slot.entry_off, align 8, !dbg !300
  %r80 = add i64 12, 0, !dbg !300
  %r81 = add i64 %r79, %r80, !dbg !300
  %r82 = call i64 @_ico_get_u32le(i64 %r78, i64 %r81), !dbg !300
  store i64 %r82, ptr %slot.eoffset, align 8, !dbg !300
  %r83 = call i64 @nova_rt_dict_create(), !dbg !301
  %r84.p = getelementptr inbounds [2 x i8], ptr @.str.0, i64 0, i64 0, !dbg !301
  %r84 = ptrtoint ptr %r84.p to i64, !dbg !301
  %r85 = add i64 %r67, 0, !dbg !301
  call i64 @nova_rt_dict_set_no_rc(i64 %r83, i64 %r84, i64 %r85), !dbg !301
  %r86.p = getelementptr inbounds [2 x i8], ptr @.str.1, i64 0, i64 0, !dbg !301
  %r86 = ptrtoint ptr %r86.p to i64, !dbg !301
  %r87 = add i64 %r72, 0, !dbg !301
  call i64 @nova_rt_dict_set_no_rc(i64 %r83, i64 %r86, i64 %r87), !dbg !301
  %r88.p = getelementptr inbounds [5 x i8], ptr @.str.4, i64 0, i64 0, !dbg !301
  %r88 = ptrtoint ptr %r88.p to i64, !dbg !301
  %r89 = add i64 %r77, 0, !dbg !301
  call i64 @nova_rt_dict_set_no_rc(i64 %r83, i64 %r88, i64 %r89), !dbg !301
  %r90.p = getelementptr inbounds [7 x i8], ptr @.str.5, i64 0, i64 0, !dbg !301
  %r90 = ptrtoint ptr %r90.p to i64, !dbg !301
  %r91 = add i64 %r82, 0, !dbg !301
  call i64 @nova_rt_dict_set_no_rc(i64 %r83, i64 %r90, i64 %r91), !dbg !301
  store i64 %r83, ptr %slot.edict, align 8, !dbg !301
  %r92 = load i64, ptr %slot.entries, align 8, !dbg !302
  %r93 = add i64 %r83, 0, !dbg !302
  %r94 = call i64 @nova_rt_list_append(i64 %r92, i64 %r93), !dbg !302
  br label %endif47, !dbg !302
else46:
  br label %endif47, !dbg !302
endif47:
  %r95 = load i64, ptr %slot.ei, align 8, !dbg !303
  %r96 = add i64 1, 0, !dbg !303
  %r97 = add i64 %r95, %r96, !dbg !303
  store i64 %r97, ptr %slot.ei, align 8, !dbg !303
  br label %while_hdr42, !dbg !303
while_exit44:
  %r98 = load i64, ptr %slot.entries, align 8, !dbg !304
  store i64 %r98, ptr %slot.result, align 8, !dbg !304
  br label %endif41, !dbg !304
else40:
  br label %endif41, !dbg !304
endif41:
  br label %endif35, !dbg !304
else34:
  br label %endif35, !dbg !304
endif35:
  %r99 = load i64, ptr %slot.result, align 8, !dbg !305
  ret i64 %r99, !dbg !305
}

; ESCAPE nova_main: allocs=0 escape=0 local=0
define i64 @nova_main() nounwind uwtable {
entry:
  ret i64 0
}

; ESCAPE SUMMARY: allocs=3 escape=2 local=1 (33% local, RC-elidable)
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
@.str.0 = private unnamed_addr constant [2 x i8] c"w\00"
@.str.1 = private unnamed_addr constant [2 x i8] c"h\00"
@.str.2 = private unnamed_addr constant [9 x i8] c"bitcount\00"
@.str.3 = private unnamed_addr constant [5 x i8] c"data\00"
@.str.4 = private unnamed_addr constant [5 x i8] c"size\00"
@.str.5 = private unnamed_addr constant [7 x i8] c"offset\00"

; Debug metadata
!llvm.dbg.cu = !{!100}
!llvm.module.flags = !{!102, !103}

!100 = distinct !DICompileUnit(language: DW_LANG_C99, file: !101, producer: "NOVA Compiler", isOptimized: false, emissionKind: LineTablesOnly)
!101 = !DIFile(filename: "std/media/ico.nova", directory: ".")
!102 = !{i32 2, !"CodeView", i32 1}
!103 = !{i32 2, !"Debug Info Version", i32 3}
!104 = !DISubroutineType(types: !105)
!105 = !{null}
!200 = distinct !DISubprogram(name: "_ico_put_u16le", scope: !101, file: !101, line: 71, type: !104, scopeLine: 71, spFlags: DISPFlagDefinition, unit: !100)
!201 = !DILocation(line: 71, column: 0, scope: !200)
!206 = distinct !DISubprogram(name: "_ico_put_u32le", scope: !101, file: !101, line: 78, type: !104, scopeLine: 78, spFlags: DISPFlagDefinition, unit: !100)
!207 = !DILocation(line: 78, column: 0, scope: !206)
!214 = distinct !DISubprogram(name: "_ico_get_u16le", scope: !101, file: !101, line: 88, type: !104, scopeLine: 88, spFlags: DISPFlagDefinition, unit: !100)
!215 = !DILocation(line: 88, column: 0, scope: !214)
!223 = distinct !DISubprogram(name: "_ico_get_u32le", scope: !101, file: !101, line: 99, type: !104, scopeLine: 99, spFlags: DISPFlagDefinition, unit: !100)
!224 = !DILocation(line: 99, column: 0, scope: !223)
!234 = distinct !DISubprogram(name: "ico_build", scope: !101, file: !101, line: 114, type: !104, scopeLine: 114, spFlags: DISPFlagDefinition, unit: !100)
!235 = !DILocation(line: 114, column: 0, scope: !234)
!269 = distinct !DISubprogram(name: "ico_parse", scope: !101, file: !101, line: 169, type: !104, scopeLine: 169, spFlags: DISPFlagDefinition, unit: !100)
!270 = !DILocation(line: 169, column: 0, scope: !269)
!202 = !DILocation(line: 72, column: 0, scope: !200)
!203 = !DILocation(line: 73, column: 0, scope: !200)
!204 = !DILocation(line: 74, column: 0, scope: !200)
!205 = !DILocation(line: 75, column: 0, scope: !200)
!208 = !DILocation(line: 79, column: 0, scope: !206)
!209 = !DILocation(line: 80, column: 0, scope: !206)
!210 = !DILocation(line: 81, column: 0, scope: !206)
!211 = !DILocation(line: 82, column: 0, scope: !206)
!212 = !DILocation(line: 83, column: 0, scope: !206)
!213 = !DILocation(line: 84, column: 0, scope: !206)
!216 = !DILocation(line: 89, column: 0, scope: !214)
!217 = !DILocation(line: 90, column: 0, scope: !214)
!218 = !DILocation(line: 91, column: 0, scope: !214)
!219 = !DILocation(line: 92, column: 0, scope: !214)
!220 = !DILocation(line: 93, column: 0, scope: !214)
!221 = !DILocation(line: 94, column: 0, scope: !214)
!222 = !DILocation(line: 95, column: 0, scope: !214)
!225 = !DILocation(line: 100, column: 0, scope: !223)
!226 = !DILocation(line: 101, column: 0, scope: !223)
!227 = !DILocation(line: 102, column: 0, scope: !223)
!228 = !DILocation(line: 103, column: 0, scope: !223)
!229 = !DILocation(line: 104, column: 0, scope: !223)
!230 = !DILocation(line: 105, column: 0, scope: !223)
!231 = !DILocation(line: 106, column: 0, scope: !223)
!232 = !DILocation(line: 107, column: 0, scope: !223)
!233 = !DILocation(line: 108, column: 0, scope: !223)
!236 = !DILocation(line: 115, column: 0, scope: !234)
!237 = !DILocation(line: 116, column: 0, scope: !234)
!238 = !DILocation(line: 117, column: 0, scope: !234)
!239 = !DILocation(line: 119, column: 0, scope: !234)
!240 = !DILocation(line: 122, column: 0, scope: !234)
!241 = !DILocation(line: 124, column: 0, scope: !234)
!242 = !DILocation(line: 126, column: 0, scope: !234)
!243 = !DILocation(line: 129, column: 0, scope: !234)
!244 = !DILocation(line: 130, column: 0, scope: !234)
!245 = !DILocation(line: 131, column: 0, scope: !234)
!246 = !DILocation(line: 132, column: 0, scope: !234)
!247 = !DILocation(line: 133, column: 0, scope: !234)
!248 = !DILocation(line: 134, column: 0, scope: !234)
!249 = !DILocation(line: 135, column: 0, scope: !234)
!250 = !DILocation(line: 136, column: 0, scope: !234)
!251 = !DILocation(line: 137, column: 0, scope: !234)
!252 = !DILocation(line: 139, column: 0, scope: !234)
!253 = !DILocation(line: 141, column: 0, scope: !234)
!254 = !DILocation(line: 143, column: 0, scope: !234)
!255 = !DILocation(line: 145, column: 0, scope: !234)
!256 = !DILocation(line: 147, column: 0, scope: !234)
!257 = !DILocation(line: 149, column: 0, scope: !234)
!258 = !DILocation(line: 151, column: 0, scope: !234)
!259 = !DILocation(line: 153, column: 0, scope: !234)
!260 = !DILocation(line: 154, column: 0, scope: !234)
!261 = !DILocation(line: 155, column: 0, scope: !234)
!262 = !DILocation(line: 157, column: 0, scope: !234)
!263 = !DILocation(line: 158, column: 0, scope: !234)
!264 = !DILocation(line: 159, column: 0, scope: !234)
!265 = !DILocation(line: 160, column: 0, scope: !234)
!266 = !DILocation(line: 161, column: 0, scope: !234)
!267 = !DILocation(line: 162, column: 0, scope: !234)
!268 = !DILocation(line: 163, column: 0, scope: !234)
!271 = !DILocation(line: 170, column: 0, scope: !269)
!272 = !DILocation(line: 171, column: 0, scope: !269)
!273 = !DILocation(line: 172, column: 0, scope: !269)
!274 = !DILocation(line: 173, column: 0, scope: !269)
!275 = !DILocation(line: 175, column: 0, scope: !269)
!276 = !DILocation(line: 176, column: 0, scope: !269)
!277 = !DILocation(line: 177, column: 0, scope: !269)
!278 = !DILocation(line: 179, column: 0, scope: !269)
!279 = !DILocation(line: 180, column: 0, scope: !269)
!280 = !DILocation(line: 181, column: 0, scope: !269)
!281 = !DILocation(line: 182, column: 0, scope: !269)
!282 = !DILocation(line: 184, column: 0, scope: !269)
!283 = !DILocation(line: 185, column: 0, scope: !269)
!284 = !DILocation(line: 186, column: 0, scope: !269)
!285 = !DILocation(line: 187, column: 0, scope: !269)
!286 = !DILocation(line: 188, column: 0, scope: !269)
!287 = !DILocation(line: 189, column: 0, scope: !269)
!288 = !DILocation(line: 191, column: 0, scope: !269)
!289 = !DILocation(line: 192, column: 0, scope: !269)
!290 = !DILocation(line: 193, column: 0, scope: !269)
!291 = !DILocation(line: 194, column: 0, scope: !269)
!292 = !DILocation(line: 195, column: 0, scope: !269)
!293 = !DILocation(line: 196, column: 0, scope: !269)
!294 = !DILocation(line: 197, column: 0, scope: !269)
!295 = !DILocation(line: 198, column: 0, scope: !269)
!296 = !DILocation(line: 200, column: 0, scope: !269)
!297 = !DILocation(line: 201, column: 0, scope: !269)
!298 = !DILocation(line: 202, column: 0, scope: !269)
!299 = !DILocation(line: 203, column: 0, scope: !269)
!300 = !DILocation(line: 204, column: 0, scope: !269)
!301 = !DILocation(line: 205, column: 0, scope: !269)
!302 = !DILocation(line: 206, column: 0, scope: !269)
!303 = !DILocation(line: 207, column: 0, scope: !269)
!304 = !DILocation(line: 208, column: 0, scope: !269)
!305 = !DILocation(line: 209, column: 0, scope: !269)

; TBAA metadata
!0 = !{!"NOVA TBAA"}
!1 = !{!"list_data_ptr", !0}
!2 = !{!1, !1, i64 0}
!3 = !{!"list_elem", !0}
!4 = !{!3, !3, i64 0}
!5 = !{!"list_size", !0}
!6 = !{!5, !5, i64 0}
!90 = !{!"branch_weights", i32 2000, i32 1}
