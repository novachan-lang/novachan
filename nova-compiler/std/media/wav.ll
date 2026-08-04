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

; ESCAPE _wav_u32le: allocs=0 escape=0 local=0
define i64 @_wav_u32le(i64 %p0, i64 %p1) nounwind uwtable !dbg !200 {
entry:
  %slot.b = alloca i64, align 8, !dbg !201
  store i64 %p0, ptr %slot.b, align 8, !dbg !201
  %slot.v = alloca i64, align 8, !dbg !201
  store i64 %p1, ptr %slot.v, align 8, !dbg !201
  %slot.out = alloca i64, align 8, !dbg !201
  store i64 0, ptr %slot.out, align 8, !dbg !201
  %r0 = load i64, ptr %slot.b, align 8, !dbg !202
  %r1 = load i64, ptr %slot.v, align 8, !dbg !202
  %r2 = add i64 255, 0, !dbg !202
  %r3 = and i64 %r1, %r2, !dbg !202
  %r4 = call i64 @nova_rt_bytes_append(i64 %r0, i64 %r3), !dbg !202
  store i64 %r4, ptr %slot.out, align 8, !dbg !202
  %r5 = add i64 %r4, 0, !dbg !203
  %r6 = load i64, ptr %slot.v, align 8, !dbg !203
  %r7 = add i64 8, 0, !dbg !203
  %r8.sramt = and i64 %r7, 63, !dbg !203
  %r8.srbig = icmp uge i64 %r7, 64, !dbg !203
  %r8.srval = ashr i64 %r6, %r8.sramt, !dbg !203
  %r8.srext = ashr i64 %r6, 63, !dbg !203
  %r8 = select i1 %r8.srbig, i64 %r8.srext, i64 %r8.srval, !dbg !203
  %r9 = add i64 255, 0, !dbg !203
  %r10 = and i64 %r8, %r9, !dbg !203
  %r11 = call i64 @nova_rt_bytes_append(i64 %r5, i64 %r10), !dbg !203
  store i64 %r11, ptr %slot.out, align 8, !dbg !203
  %r12 = add i64 %r11, 0, !dbg !204
  %r13 = load i64, ptr %slot.v, align 8, !dbg !204
  %r14 = add i64 16, 0, !dbg !204
  %r15.sramt = and i64 %r14, 63, !dbg !204
  %r15.srbig = icmp uge i64 %r14, 64, !dbg !204
  %r15.srval = ashr i64 %r13, %r15.sramt, !dbg !204
  %r15.srext = ashr i64 %r13, 63, !dbg !204
  %r15 = select i1 %r15.srbig, i64 %r15.srext, i64 %r15.srval, !dbg !204
  %r16 = add i64 255, 0, !dbg !204
  %r17 = and i64 %r15, %r16, !dbg !204
  %r18 = call i64 @nova_rt_bytes_append(i64 %r12, i64 %r17), !dbg !204
  store i64 %r18, ptr %slot.out, align 8, !dbg !204
  %r19 = add i64 %r18, 0, !dbg !205
  %r20 = load i64, ptr %slot.v, align 8, !dbg !205
  %r21 = add i64 24, 0, !dbg !205
  %r22.sramt = and i64 %r21, 63, !dbg !205
  %r22.srbig = icmp uge i64 %r21, 64, !dbg !205
  %r22.srval = ashr i64 %r20, %r22.sramt, !dbg !205
  %r22.srext = ashr i64 %r20, 63, !dbg !205
  %r22 = select i1 %r22.srbig, i64 %r22.srext, i64 %r22.srval, !dbg !205
  %r23 = add i64 255, 0, !dbg !205
  %r24 = and i64 %r22, %r23, !dbg !205
  %r25 = call i64 @nova_rt_bytes_append(i64 %r19, i64 %r24), !dbg !205
  store i64 %r25, ptr %slot.out, align 8, !dbg !205
  %r26 = add i64 %r25, 0, !dbg !206
  ret i64 %r26, !dbg !206
}

; ESCAPE _wav_u16le: allocs=0 escape=0 local=0
define i64 @_wav_u16le(i64 %p0, i64 %p1) nounwind uwtable !dbg !207 {
entry:
  %slot.b = alloca i64, align 8, !dbg !208
  store i64 %p0, ptr %slot.b, align 8, !dbg !208
  %slot.v = alloca i64, align 8, !dbg !208
  store i64 %p1, ptr %slot.v, align 8, !dbg !208
  %slot.out = alloca i64, align 8, !dbg !208
  store i64 0, ptr %slot.out, align 8, !dbg !208
  %r0 = load i64, ptr %slot.b, align 8, !dbg !209
  %r1 = load i64, ptr %slot.v, align 8, !dbg !209
  %r2 = add i64 255, 0, !dbg !209
  %r3 = and i64 %r1, %r2, !dbg !209
  %r4 = call i64 @nova_rt_bytes_append(i64 %r0, i64 %r3), !dbg !209
  store i64 %r4, ptr %slot.out, align 8, !dbg !209
  %r5 = add i64 %r4, 0, !dbg !210
  %r6 = load i64, ptr %slot.v, align 8, !dbg !210
  %r7 = add i64 8, 0, !dbg !210
  %r8.sramt = and i64 %r7, 63, !dbg !210
  %r8.srbig = icmp uge i64 %r7, 64, !dbg !210
  %r8.srval = ashr i64 %r6, %r8.sramt, !dbg !210
  %r8.srext = ashr i64 %r6, 63, !dbg !210
  %r8 = select i1 %r8.srbig, i64 %r8.srext, i64 %r8.srval, !dbg !210
  %r9 = add i64 255, 0, !dbg !210
  %r10 = and i64 %r8, %r9, !dbg !210
  %r11 = call i64 @nova_rt_bytes_append(i64 %r5, i64 %r10), !dbg !210
  store i64 %r11, ptr %slot.out, align 8, !dbg !210
  %r12 = add i64 %r11, 0, !dbg !211
  ret i64 %r12, !dbg !211
}

; ESCAPE _wav_rd_u32le: allocs=0 escape=0 local=0
define i64 @_wav_rd_u32le(i64 %p0, i64 %p1) nounwind uwtable !dbg !212 {
entry:
  %slot.b = alloca i64, align 8, !dbg !213
  store i64 %p0, ptr %slot.b, align 8, !dbg !213
  %slot.pos = alloca i64, align 8, !dbg !213
  store i64 %p1, ptr %slot.pos, align 8, !dbg !213
  %slot.b0 = alloca i64, align 8, !dbg !213
  store i64 0, ptr %slot.b0, align 8, !dbg !213
  %slot.b1 = alloca i64, align 8, !dbg !213
  store i64 0, ptr %slot.b1, align 8, !dbg !213
  %slot.b2 = alloca i64, align 8, !dbg !213
  store i64 0, ptr %slot.b2, align 8, !dbg !213
  %slot.b3 = alloca i64, align 8, !dbg !213
  store i64 0, ptr %slot.b3, align 8, !dbg !213
  %r0 = load i64, ptr %slot.b, align 8, !dbg !214
  %r1 = load i64, ptr %slot.pos, align 8, !dbg !214
  %r2 = call i64 @nova_rt_bytes_get(i64 %r0, i64 %r1), !dbg !214
  store i64 %r2, ptr %slot.b0, align 8, !dbg !214
  %r3 = load i64, ptr %slot.b, align 8, !dbg !215
  %r4 = load i64, ptr %slot.pos, align 8, !dbg !215
  %r5 = add i64 1, 0, !dbg !215
  %r6 = add i64 %r4, %r5, !dbg !215
  %r7 = call i64 @nova_rt_bytes_get(i64 %r3, i64 %r6), !dbg !215
  store i64 %r7, ptr %slot.b1, align 8, !dbg !215
  %r8 = load i64, ptr %slot.b, align 8, !dbg !216
  %r9 = load i64, ptr %slot.pos, align 8, !dbg !216
  %r10 = add i64 2, 0, !dbg !216
  %r11 = add i64 %r9, %r10, !dbg !216
  %r12 = call i64 @nova_rt_bytes_get(i64 %r8, i64 %r11), !dbg !216
  store i64 %r12, ptr %slot.b2, align 8, !dbg !216
  %r13 = load i64, ptr %slot.b, align 8, !dbg !217
  %r14 = load i64, ptr %slot.pos, align 8, !dbg !217
  %r15 = add i64 3, 0, !dbg !217
  %r16 = add i64 %r14, %r15, !dbg !217
  %r17 = call i64 @nova_rt_bytes_get(i64 %r13, i64 %r16), !dbg !217
  store i64 %r17, ptr %slot.b3, align 8, !dbg !217
  %r18 = add i64 %r2, 0, !dbg !218
  %r19 = add i64 %r7, 0, !dbg !218
  %r20 = add i64 256, 0, !dbg !218
  %r21 = mul i64 %r19, %r20, !dbg !218
  %r22 = or i64 %r18, %r21, !dbg !218
  %r23 = add i64 %r12, 0, !dbg !218
  %r24 = add i64 65536, 0, !dbg !218
  %r25 = mul i64 %r23, %r24, !dbg !218
  %r26 = or i64 %r22, %r25, !dbg !218
  %r27 = add i64 %r17, 0, !dbg !218
  %r28 = add i64 16777216, 0, !dbg !218
  %r29 = mul i64 %r27, %r28, !dbg !218
  %r30 = or i64 %r26, %r29, !dbg !218
  ret i64 %r30, !dbg !218
}

; ESCAPE _wav_rd_u16le: allocs=0 escape=0 local=0
define i64 @_wav_rd_u16le(i64 %p0, i64 %p1) nounwind uwtable !dbg !219 {
entry:
  %slot.b = alloca i64, align 8, !dbg !220
  store i64 %p0, ptr %slot.b, align 8, !dbg !220
  %slot.pos = alloca i64, align 8, !dbg !220
  store i64 %p1, ptr %slot.pos, align 8, !dbg !220
  %slot.b0 = alloca i64, align 8, !dbg !220
  store i64 0, ptr %slot.b0, align 8, !dbg !220
  %slot.b1 = alloca i64, align 8, !dbg !220
  store i64 0, ptr %slot.b1, align 8, !dbg !220
  %r0 = load i64, ptr %slot.b, align 8, !dbg !221
  %r1 = load i64, ptr %slot.pos, align 8, !dbg !221
  %r2 = call i64 @nova_rt_bytes_get(i64 %r0, i64 %r1), !dbg !221
  store i64 %r2, ptr %slot.b0, align 8, !dbg !221
  %r3 = load i64, ptr %slot.b, align 8, !dbg !222
  %r4 = load i64, ptr %slot.pos, align 8, !dbg !222
  %r5 = add i64 1, 0, !dbg !222
  %r6 = add i64 %r4, %r5, !dbg !222
  %r7 = call i64 @nova_rt_bytes_get(i64 %r3, i64 %r6), !dbg !222
  store i64 %r7, ptr %slot.b1, align 8, !dbg !222
  %r8 = add i64 %r2, 0, !dbg !223
  %r9 = add i64 %r7, 0, !dbg !223
  %r10 = add i64 256, 0, !dbg !223
  %r11 = mul i64 %r9, %r10, !dbg !223
  %r12 = or i64 %r8, %r11, !dbg !223
  ret i64 %r12, !dbg !223
}

; ESCAPE wav_encode: allocs=0 escape=0 local=0
define i64 @wav_encode(i64 %p0, i64 %p1, i64 %p2) nounwind uwtable !dbg !224 {
entry:
  %slot.samplerate = alloca i64, align 8, !dbg !225
  store i64 %p0, ptr %slot.samplerate, align 8, !dbg !225
  %slot.channels = alloca i64, align 8, !dbg !225
  store i64 %p1, ptr %slot.channels, align 8, !dbg !225
  %slot.samples = alloca i64, align 8, !dbg !225
  store i64 %p2, ptr %slot.samples, align 8, !dbg !225
  %slot.result = alloca i64, align 8, !dbg !225
  store i64 0, ptr %slot.result, align 8, !dbg !225
  %slot.numsamples = alloca i64, align 8, !dbg !225
  store i64 0, ptr %slot.numsamples, align 8, !dbg !225
  %slot.datasize = alloca i64, align 8, !dbg !225
  store i64 0, ptr %slot.datasize, align 8, !dbg !225
  %slot.chunksize = alloca i64, align 8, !dbg !225
  store i64 0, ptr %slot.chunksize, align 8, !dbg !225
  %slot.byterate = alloca i64, align 8, !dbg !225
  store i64 0, ptr %slot.byterate, align 8, !dbg !225
  %slot.blockalign = alloca i64, align 8, !dbg !225
  store i64 0, ptr %slot.blockalign, align 8, !dbg !225
  %slot.hdr = alloca i64, align 8, !dbg !225
  store i64 0, ptr %slot.hdr, align 8, !dbg !225
  %slot.i = alloca i64, align 8, !dbg !225
  store i64 0, ptr %slot.i, align 8, !dbg !225
  %slot.v = alloca i64, align 8, !dbg !225
  store i64 0, ptr %slot.v, align 8, !dbg !225
  %slot.m = alloca i64, align 8, !dbg !225
  store i64 0, ptr %slot.m, align 8, !dbg !225
  %r0 = add i64 0, 0, !dbg !226
  %r1 = call i64 @nova_rt_bytes_create(i64 %r0), !dbg !226
  store i64 %r1, ptr %slot.result, align 8, !dbg !226
  %r2 = load i64, ptr %slot.samplerate, align 8, !dbg !227
  %r3 = add i64 0, 0, !dbg !227
  %r4 = call i64 @nova_rt_le(i64 %r2, i64 %r3), !dbg !227
  %br_retthen00 = icmp ne i64 %r4, 0, !dbg !227
  br i1 %br_retthen00, label %retthen0, label %retelse1, !dbg !227
retthen0:
  %r5 = load i64, ptr %slot.result, align 8, !dbg !228
  ret i64 %r5, !dbg !228
retelse1:
  %r6 = load i64, ptr %slot.channels, align 8, !dbg !229
  %r7 = add i64 0, 0, !dbg !229
  %r8 = call i64 @nova_rt_le(i64 %r6, i64 %r7), !dbg !229
  %br_retthen21 = icmp ne i64 %r8, 0, !dbg !229
  br i1 %br_retthen21, label %retthen2, label %retelse3, !dbg !229
retthen2:
  %r9 = load i64, ptr %slot.result, align 8, !dbg !230
  ret i64 %r9, !dbg !230
retelse3:
  %r10 = load i64, ptr %slot.samples, align 8, !dbg !231
  %r11 = call i64 @nova_rt_len_any(i64 %r10), !dbg !231
  store i64 %r11, ptr %slot.numsamples, align 8, !dbg !231
  %r12 = add i64 %r11, 0, !dbg !232
  %r13 = add i64 2, 0, !dbg !232
  %r14 = mul i64 %r12, %r13, !dbg !232
  store i64 %r14, ptr %slot.datasize, align 8, !dbg !232
  %r15 = add i64 36, 0, !dbg !233
  %r16 = add i64 %r14, 0, !dbg !233
  %r17 = add i64 %r15, %r16, !dbg !233
  store i64 %r17, ptr %slot.chunksize, align 8, !dbg !233
  %r18 = load i64, ptr %slot.samplerate, align 8, !dbg !234
  %r19 = load i64, ptr %slot.channels, align 8, !dbg !234
  %r20 = call i64 @nova_rt_mul(i64 %r18, i64 %r19), !dbg !234
  %r21 = add i64 2, 0, !dbg !234
  %r22 = call i64 @nova_rt_mul(i64 %r20, i64 %r21), !dbg !234
  store i64 %r22, ptr %slot.byterate, align 8, !dbg !234
  %r23 = load i64, ptr %slot.channels, align 8, !dbg !235
  %r24 = add i64 2, 0, !dbg !235
  %r25 = call i64 @nova_rt_mul(i64 %r23, i64 %r24), !dbg !235
  store i64 %r25, ptr %slot.blockalign, align 8, !dbg !235
  %r26 = add i64 0, 0, !dbg !236
  %r27 = call i64 @nova_rt_bytes_create(i64 %r26), !dbg !236
  store i64 %r27, ptr %slot.hdr, align 8, !dbg !236
  %r28 = add i64 %r27, 0, !dbg !237
  %r29.p = getelementptr inbounds [5 x i8], ptr @.str.0, i64 0, i64 0, !dbg !237
  %r29 = ptrtoint ptr %r29.p to i64, !dbg !237
  %r30 = call i64 @nova_rt_bytes_append_str(i64 %r28, i64 %r29), !dbg !237
  store i64 %r30, ptr %slot.hdr, align 8, !dbg !237
  %r31 = add i64 %r30, 0, !dbg !238
  %r32 = add i64 %r17, 0, !dbg !238
  %r33 = call i64 @_wav_u32le(i64 %r31, i64 %r32), !dbg !238
  store i64 %r33, ptr %slot.hdr, align 8, !dbg !238
  %r34 = add i64 %r33, 0, !dbg !239
  %r35.p = getelementptr inbounds [5 x i8], ptr @.str.1, i64 0, i64 0, !dbg !239
  %r35 = ptrtoint ptr %r35.p to i64, !dbg !239
  %r36 = call i64 @nova_rt_bytes_append_str(i64 %r34, i64 %r35), !dbg !239
  store i64 %r36, ptr %slot.hdr, align 8, !dbg !239
  %r37 = add i64 %r36, 0, !dbg !240
  %r38.p = getelementptr inbounds [5 x i8], ptr @.str.2, i64 0, i64 0, !dbg !240
  %r38 = ptrtoint ptr %r38.p to i64, !dbg !240
  %r39 = call i64 @nova_rt_bytes_append_str(i64 %r37, i64 %r38), !dbg !240
  store i64 %r39, ptr %slot.hdr, align 8, !dbg !240
  %r40 = add i64 %r39, 0, !dbg !241
  %r41 = add i64 16, 0, !dbg !241
  %r42 = call i64 @_wav_u32le(i64 %r40, i64 %r41), !dbg !241
  store i64 %r42, ptr %slot.hdr, align 8, !dbg !241
  %r43 = add i64 %r42, 0, !dbg !242
  %r44 = add i64 1, 0, !dbg !242
  %r45 = call i64 @_wav_u16le(i64 %r43, i64 %r44), !dbg !242
  store i64 %r45, ptr %slot.hdr, align 8, !dbg !242
  %r46 = add i64 %r45, 0, !dbg !243
  %r47 = load i64, ptr %slot.channels, align 8, !dbg !243
  %r48 = call i64 @_wav_u16le(i64 %r46, i64 %r47), !dbg !243
  store i64 %r48, ptr %slot.hdr, align 8, !dbg !243
  %r49 = add i64 %r48, 0, !dbg !244
  %r50 = load i64, ptr %slot.samplerate, align 8, !dbg !244
  %r51 = call i64 @_wav_u32le(i64 %r49, i64 %r50), !dbg !244
  store i64 %r51, ptr %slot.hdr, align 8, !dbg !244
  %r52 = add i64 %r51, 0, !dbg !245
  %r53 = add i64 %r22, 0, !dbg !245
  %r54 = call i64 @_wav_u32le(i64 %r52, i64 %r53), !dbg !245
  store i64 %r54, ptr %slot.hdr, align 8, !dbg !245
  %r55 = add i64 %r54, 0, !dbg !246
  %r56 = add i64 %r25, 0, !dbg !246
  %r57 = call i64 @_wav_u16le(i64 %r55, i64 %r56), !dbg !246
  store i64 %r57, ptr %slot.hdr, align 8, !dbg !246
  %r58 = add i64 %r57, 0, !dbg !247
  %r59 = add i64 16, 0, !dbg !247
  %r60 = call i64 @_wav_u16le(i64 %r58, i64 %r59), !dbg !247
  store i64 %r60, ptr %slot.hdr, align 8, !dbg !247
  %r61 = add i64 %r60, 0, !dbg !248
  %r62.p = getelementptr inbounds [5 x i8], ptr @.str.3, i64 0, i64 0, !dbg !248
  %r62 = ptrtoint ptr %r62.p to i64, !dbg !248
  %r63 = call i64 @nova_rt_bytes_append_str(i64 %r61, i64 %r62), !dbg !248
  store i64 %r63, ptr %slot.hdr, align 8, !dbg !248
  %r64 = add i64 %r63, 0, !dbg !249
  %r65 = add i64 %r14, 0, !dbg !249
  %r66 = call i64 @_wav_u32le(i64 %r64, i64 %r65), !dbg !249
  store i64 %r66, ptr %slot.hdr, align 8, !dbg !249
  %r67 = add i64 0, 0, !dbg !250
  store i64 %r67, ptr %slot.i, align 8, !dbg !250
  br label %while_hdr4, !dbg !251
while_hdr4:
  %r68 = load i64, ptr %slot.i, align 8, !dbg !251
  %r69 = load i64, ptr %slot.numsamples, align 8, !dbg !251
  %r70.cmp = icmp slt i64 %r68, %r69, !dbg !251
  %r70 = zext i1 %r70.cmp to i64, !dbg !251
  %br_while_body52 = icmp ne i64 %r70, 0, !dbg !251
  br i1 %br_while_body52, label %while_body5, label %while_exit6, !prof !90, !dbg !251
while_body5:
  %r71 = load i64, ptr %slot.samples, align 8, !dbg !252
  %r72 = load i64, ptr %slot.i, align 8, !dbg !252
  %r73 = call i64 @nova_rt_index_get(i64 %r71, i64 %r72), !dbg !252
  store i64 %r73, ptr %slot.v, align 8, !dbg !252
  %r74 = add i64 %r73, 0, !dbg !253
  %r75 = add i64 65535, 0, !dbg !253
  %r76 = and i64 %r74, %r75, !dbg !253
  store i64 %r76, ptr %slot.m, align 8, !dbg !253
  %r77 = load i64, ptr %slot.hdr, align 8, !dbg !254
  %r78 = add i64 %r76, 0, !dbg !254
  %r79 = add i64 255, 0, !dbg !254
  %r80 = and i64 %r78, %r79, !dbg !254
  %r81 = call i64 @nova_rt_bytes_append(i64 %r77, i64 %r80), !dbg !254
  store i64 %r81, ptr %slot.hdr, align 8, !dbg !254
  %r82 = add i64 %r81, 0, !dbg !255
  %r83 = add i64 %r76, 0, !dbg !255
  %r84 = add i64 8, 0, !dbg !255
  %r85.sramt = and i64 %r84, 63, !dbg !255
  %r85.srbig = icmp uge i64 %r84, 64, !dbg !255
  %r85.srval = ashr i64 %r83, %r85.sramt, !dbg !255
  %r85.srext = ashr i64 %r83, 63, !dbg !255
  %r85 = select i1 %r85.srbig, i64 %r85.srext, i64 %r85.srval, !dbg !255
  %r86 = add i64 255, 0, !dbg !255
  %r87 = and i64 %r85, %r86, !dbg !255
  %r88 = call i64 @nova_rt_bytes_append(i64 %r82, i64 %r87), !dbg !255
  store i64 %r88, ptr %slot.hdr, align 8, !dbg !255
  %r89 = load i64, ptr %slot.i, align 8, !dbg !256
  %r90 = add i64 1, 0, !dbg !256
  %r91 = add i64 %r89, %r90, !dbg !256
  store i64 %r91, ptr %slot.i, align 8, !dbg !256
  br label %while_hdr4, !dbg !256
while_exit6:
  %r92 = load i64, ptr %slot.hdr, align 8, !dbg !257
  ret i64 %r92, !dbg !257
}

; ESCAPE wav_decode: allocs=3 escape=2 local=1
define i64 @wav_decode(i64 %p0) nounwind uwtable !dbg !258 {
entry:
  %slot.b = alloca i64, align 8, !dbg !259
  store i64 %p0, ptr %slot.b, align 8, !dbg !259
  %slot.empty = alloca i64, align 8, !dbg !259
  store i64 0, ptr %slot.empty, align 8, !dbg !259
  %slot.blen = alloca i64, align 8, !dbg !259
  store i64 0, ptr %slot.blen, align 8, !dbg !259
  %slot.r0 = alloca i64, align 8, !dbg !259
  store i64 0, ptr %slot.r0, align 8, !dbg !259
  %slot.r1 = alloca i64, align 8, !dbg !259
  store i64 0, ptr %slot.r1, align 8, !dbg !259
  %slot.r2 = alloca i64, align 8, !dbg !259
  store i64 0, ptr %slot.r2, align 8, !dbg !259
  %slot.r3 = alloca i64, align 8, !dbg !259
  store i64 0, ptr %slot.r3, align 8, !dbg !259
  %slot.w0 = alloca i64, align 8, !dbg !259
  store i64 0, ptr %slot.w0, align 8, !dbg !259
  %slot.w1 = alloca i64, align 8, !dbg !259
  store i64 0, ptr %slot.w1, align 8, !dbg !259
  %slot.w2 = alloca i64, align 8, !dbg !259
  store i64 0, ptr %slot.w2, align 8, !dbg !259
  %slot.w3 = alloca i64, align 8, !dbg !259
  store i64 0, ptr %slot.w3, align 8, !dbg !259
  %slot.f0 = alloca i64, align 8, !dbg !259
  store i64 0, ptr %slot.f0, align 8, !dbg !259
  %slot.f1 = alloca i64, align 8, !dbg !259
  store i64 0, ptr %slot.f1, align 8, !dbg !259
  %slot.f2 = alloca i64, align 8, !dbg !259
  store i64 0, ptr %slot.f2, align 8, !dbg !259
  %slot.f3 = alloca i64, align 8, !dbg !259
  store i64 0, ptr %slot.f3, align 8, !dbg !259
  %slot.audiofmt = alloca i64, align 8, !dbg !259
  store i64 0, ptr %slot.audiofmt, align 8, !dbg !259
  %slot.channels = alloca i64, align 8, !dbg !259
  store i64 0, ptr %slot.channels, align 8, !dbg !259
  %slot.samplerate = alloca i64, align 8, !dbg !259
  store i64 0, ptr %slot.samplerate, align 8, !dbg !259
  %slot.bits = alloca i64, align 8, !dbg !259
  store i64 0, ptr %slot.bits, align 8, !dbg !259
  %slot.d0 = alloca i64, align 8, !dbg !259
  store i64 0, ptr %slot.d0, align 8, !dbg !259
  %slot.d1 = alloca i64, align 8, !dbg !259
  store i64 0, ptr %slot.d1, align 8, !dbg !259
  %slot.d2 = alloca i64, align 8, !dbg !259
  store i64 0, ptr %slot.d2, align 8, !dbg !259
  %slot.d3 = alloca i64, align 8, !dbg !259
  store i64 0, ptr %slot.d3, align 8, !dbg !259
  %slot.datasize = alloca i64, align 8, !dbg !259
  store i64 0, ptr %slot.datasize, align 8, !dbg !259
  %slot.numsamples = alloca i64, align 8, !dbg !259
  store i64 0, ptr %slot.numsamples, align 8, !dbg !259
  %slot.sampstart = alloca i64, align 8, !dbg !259
  store i64 0, ptr %slot.sampstart, align 8, !dbg !259
  %slot.sampend = alloca i64, align 8, !dbg !259
  store i64 0, ptr %slot.sampend, align 8, !dbg !259
  %slot.smplist = alloca i64, align 8, !dbg !259
  store i64 0, ptr %slot.smplist, align 8, !dbg !259
  %slot.si = alloca i64, align 8, !dbg !259
  store i64 0, ptr %slot.si, align 8, !dbg !259
  %slot.sc = alloca i64, align 8, !dbg !259
  store i64 0, ptr %slot.sc, align 8, !dbg !259
  %slot.lo = alloca i64, align 8, !dbg !259
  store i64 0, ptr %slot.lo, align 8, !dbg !259
  %slot.hi = alloca i64, align 8, !dbg !259
  store i64 0, ptr %slot.hi, align 8, !dbg !259
  %slot.u = alloca i64, align 8, !dbg !259
  store i64 0, ptr %slot.u, align 8, !dbg !259
  %slot.sv = alloca i64, align 8, !dbg !259
  store i64 0, ptr %slot.sv, align 8, !dbg !259
  %slot.res = alloca i64, align 8, !dbg !259
  store i64 0, ptr %slot.res, align 8, !dbg !259
  %r0 = call i64 @nova_rt_dict_create(), !dbg !260
  store i64 %r0, ptr %slot.empty, align 8, !dbg !260
  %r1 = load i64, ptr %slot.b, align 8, !dbg !261
  %r2 = call i64 @nova_rt_bytes_len(i64 %r1), !dbg !261
  store i64 %r2, ptr %slot.blen, align 8, !dbg !261
  %r3 = add i64 %r2, 0, !dbg !262
  %r4 = add i64 44, 0, !dbg !262
  %r5.cmp = icmp slt i64 %r3, %r4, !dbg !262
  %r5 = zext i1 %r5.cmp to i64, !dbg !262
  %br_retthen70 = icmp ne i64 %r5, 0, !dbg !262
  br i1 %br_retthen70, label %retthen7, label %retelse8, !dbg !262
retthen7:
  %r6 = load i64, ptr %slot.empty, align 8, !dbg !263
  ret i64 %r6, !dbg !263
retelse8:
  %r7 = load i64, ptr %slot.b, align 8, !dbg !264
  %r8 = add i64 0, 0, !dbg !264
  %r9 = call i64 @nova_rt_bytes_get(i64 %r7, i64 %r8), !dbg !264
  store i64 %r9, ptr %slot.r0, align 8, !dbg !264
  %r10 = load i64, ptr %slot.b, align 8, !dbg !265
  %r11 = add i64 1, 0, !dbg !265
  %r12 = call i64 @nova_rt_bytes_get(i64 %r10, i64 %r11), !dbg !265
  store i64 %r12, ptr %slot.r1, align 8, !dbg !265
  %r13 = load i64, ptr %slot.b, align 8, !dbg !266
  %r14 = add i64 2, 0, !dbg !266
  %r15 = call i64 @nova_rt_bytes_get(i64 %r13, i64 %r14), !dbg !266
  store i64 %r15, ptr %slot.r2, align 8, !dbg !266
  %r16 = load i64, ptr %slot.b, align 8, !dbg !267
  %r17 = add i64 3, 0, !dbg !267
  %r18 = call i64 @nova_rt_bytes_get(i64 %r16, i64 %r17), !dbg !267
  store i64 %r18, ptr %slot.r3, align 8, !dbg !267
  %r19 = add i64 %r9, 0, !dbg !268
  %r20 = add i64 82, 0, !dbg !268
  %r21.cmp = icmp ne i64 %r19, %r20, !dbg !268
  %r21 = zext i1 %r21.cmp to i64, !dbg !268
  %br_retthen91 = icmp ne i64 %r21, 0, !dbg !268
  br i1 %br_retthen91, label %retthen9, label %retelse10, !dbg !268
retthen9:
  %r22 = load i64, ptr %slot.empty, align 8, !dbg !269
  ret i64 %r22, !dbg !269
retelse10:
  %r23 = load i64, ptr %slot.r1, align 8, !dbg !270
  %r24 = add i64 73, 0, !dbg !270
  %r25.cmp = icmp ne i64 %r23, %r24, !dbg !270
  %r25 = zext i1 %r25.cmp to i64, !dbg !270
  %br_retthen112 = icmp ne i64 %r25, 0, !dbg !270
  br i1 %br_retthen112, label %retthen11, label %retelse12, !dbg !270
retthen11:
  %r26 = load i64, ptr %slot.empty, align 8, !dbg !271
  ret i64 %r26, !dbg !271
retelse12:
  %r27 = load i64, ptr %slot.r2, align 8, !dbg !272
  %r28 = add i64 70, 0, !dbg !272
  %r29.cmp = icmp ne i64 %r27, %r28, !dbg !272
  %r29 = zext i1 %r29.cmp to i64, !dbg !272
  %br_retthen133 = icmp ne i64 %r29, 0, !dbg !272
  br i1 %br_retthen133, label %retthen13, label %retelse14, !dbg !272
retthen13:
  %r30 = load i64, ptr %slot.empty, align 8, !dbg !273
  ret i64 %r30, !dbg !273
retelse14:
  %r31 = load i64, ptr %slot.r3, align 8, !dbg !274
  %r32 = add i64 70, 0, !dbg !274
  %r33.cmp = icmp ne i64 %r31, %r32, !dbg !274
  %r33 = zext i1 %r33.cmp to i64, !dbg !274
  %br_retthen154 = icmp ne i64 %r33, 0, !dbg !274
  br i1 %br_retthen154, label %retthen15, label %retelse16, !dbg !274
retthen15:
  %r34 = load i64, ptr %slot.empty, align 8, !dbg !275
  ret i64 %r34, !dbg !275
retelse16:
  %r35 = load i64, ptr %slot.b, align 8, !dbg !276
  %r36 = add i64 8, 0, !dbg !276
  %r37 = call i64 @nova_rt_bytes_get(i64 %r35, i64 %r36), !dbg !276
  store i64 %r37, ptr %slot.w0, align 8, !dbg !276
  %r38 = load i64, ptr %slot.b, align 8, !dbg !277
  %r39 = add i64 9, 0, !dbg !277
  %r40 = call i64 @nova_rt_bytes_get(i64 %r38, i64 %r39), !dbg !277
  store i64 %r40, ptr %slot.w1, align 8, !dbg !277
  %r41 = load i64, ptr %slot.b, align 8, !dbg !278
  %r42 = add i64 10, 0, !dbg !278
  %r43 = call i64 @nova_rt_bytes_get(i64 %r41, i64 %r42), !dbg !278
  store i64 %r43, ptr %slot.w2, align 8, !dbg !278
  %r44 = load i64, ptr %slot.b, align 8, !dbg !279
  %r45 = add i64 11, 0, !dbg !279
  %r46 = call i64 @nova_rt_bytes_get(i64 %r44, i64 %r45), !dbg !279
  store i64 %r46, ptr %slot.w3, align 8, !dbg !279
  %r47 = add i64 %r37, 0, !dbg !280
  %r48 = add i64 87, 0, !dbg !280
  %r49.cmp = icmp ne i64 %r47, %r48, !dbg !280
  %r49 = zext i1 %r49.cmp to i64, !dbg !280
  %br_retthen175 = icmp ne i64 %r49, 0, !dbg !280
  br i1 %br_retthen175, label %retthen17, label %retelse18, !dbg !280
retthen17:
  %r50 = load i64, ptr %slot.empty, align 8, !dbg !281
  ret i64 %r50, !dbg !281
retelse18:
  %r51 = load i64, ptr %slot.w1, align 8, !dbg !282
  %r52 = add i64 65, 0, !dbg !282
  %r53.cmp = icmp ne i64 %r51, %r52, !dbg !282
  %r53 = zext i1 %r53.cmp to i64, !dbg !282
  %br_retthen196 = icmp ne i64 %r53, 0, !dbg !282
  br i1 %br_retthen196, label %retthen19, label %retelse20, !dbg !282
retthen19:
  %r54 = load i64, ptr %slot.empty, align 8, !dbg !283
  ret i64 %r54, !dbg !283
retelse20:
  %r55 = load i64, ptr %slot.w2, align 8, !dbg !284
  %r56 = add i64 86, 0, !dbg !284
  %r57.cmp = icmp ne i64 %r55, %r56, !dbg !284
  %r57 = zext i1 %r57.cmp to i64, !dbg !284
  %br_retthen217 = icmp ne i64 %r57, 0, !dbg !284
  br i1 %br_retthen217, label %retthen21, label %retelse22, !dbg !284
retthen21:
  %r58 = load i64, ptr %slot.empty, align 8, !dbg !285
  ret i64 %r58, !dbg !285
retelse22:
  %r59 = load i64, ptr %slot.w3, align 8, !dbg !286
  %r60 = add i64 69, 0, !dbg !286
  %r61.cmp = icmp ne i64 %r59, %r60, !dbg !286
  %r61 = zext i1 %r61.cmp to i64, !dbg !286
  %br_retthen238 = icmp ne i64 %r61, 0, !dbg !286
  br i1 %br_retthen238, label %retthen23, label %retelse24, !dbg !286
retthen23:
  %r62 = load i64, ptr %slot.empty, align 8, !dbg !287
  ret i64 %r62, !dbg !287
retelse24:
  %r63 = load i64, ptr %slot.b, align 8, !dbg !288
  %r64 = add i64 12, 0, !dbg !288
  %r65 = call i64 @nova_rt_bytes_get(i64 %r63, i64 %r64), !dbg !288
  store i64 %r65, ptr %slot.f0, align 8, !dbg !288
  %r66 = load i64, ptr %slot.b, align 8, !dbg !289
  %r67 = add i64 13, 0, !dbg !289
  %r68 = call i64 @nova_rt_bytes_get(i64 %r66, i64 %r67), !dbg !289
  store i64 %r68, ptr %slot.f1, align 8, !dbg !289
  %r69 = load i64, ptr %slot.b, align 8, !dbg !290
  %r70 = add i64 14, 0, !dbg !290
  %r71 = call i64 @nova_rt_bytes_get(i64 %r69, i64 %r70), !dbg !290
  store i64 %r71, ptr %slot.f2, align 8, !dbg !290
  %r72 = load i64, ptr %slot.b, align 8, !dbg !291
  %r73 = add i64 15, 0, !dbg !291
  %r74 = call i64 @nova_rt_bytes_get(i64 %r72, i64 %r73), !dbg !291
  store i64 %r74, ptr %slot.f3, align 8, !dbg !291
  %r75 = add i64 %r65, 0, !dbg !292
  %r76 = add i64 102, 0, !dbg !292
  %r77.cmp = icmp ne i64 %r75, %r76, !dbg !292
  %r77 = zext i1 %r77.cmp to i64, !dbg !292
  %br_retthen259 = icmp ne i64 %r77, 0, !dbg !292
  br i1 %br_retthen259, label %retthen25, label %retelse26, !dbg !292
retthen25:
  %r78 = load i64, ptr %slot.empty, align 8, !dbg !293
  ret i64 %r78, !dbg !293
retelse26:
  %r79 = load i64, ptr %slot.f1, align 8, !dbg !294
  %r80 = add i64 109, 0, !dbg !294
  %r81.cmp = icmp ne i64 %r79, %r80, !dbg !294
  %r81 = zext i1 %r81.cmp to i64, !dbg !294
  %br_retthen2710 = icmp ne i64 %r81, 0, !dbg !294
  br i1 %br_retthen2710, label %retthen27, label %retelse28, !dbg !294
retthen27:
  %r82 = load i64, ptr %slot.empty, align 8, !dbg !295
  ret i64 %r82, !dbg !295
retelse28:
  %r83 = load i64, ptr %slot.f2, align 8, !dbg !296
  %r84 = add i64 116, 0, !dbg !296
  %r85.cmp = icmp ne i64 %r83, %r84, !dbg !296
  %r85 = zext i1 %r85.cmp to i64, !dbg !296
  %br_retthen2911 = icmp ne i64 %r85, 0, !dbg !296
  br i1 %br_retthen2911, label %retthen29, label %retelse30, !dbg !296
retthen29:
  %r86 = load i64, ptr %slot.empty, align 8, !dbg !297
  ret i64 %r86, !dbg !297
retelse30:
  %r87 = load i64, ptr %slot.f3, align 8, !dbg !298
  %r88 = add i64 32, 0, !dbg !298
  %r89.cmp = icmp ne i64 %r87, %r88, !dbg !298
  %r89 = zext i1 %r89.cmp to i64, !dbg !298
  %br_retthen3112 = icmp ne i64 %r89, 0, !dbg !298
  br i1 %br_retthen3112, label %retthen31, label %retelse32, !dbg !298
retthen31:
  %r90 = load i64, ptr %slot.empty, align 8, !dbg !299
  ret i64 %r90, !dbg !299
retelse32:
  %r91 = load i64, ptr %slot.b, align 8, !dbg !300
  %r92 = add i64 20, 0, !dbg !300
  %r93 = call i64 @_wav_rd_u16le(i64 %r91, i64 %r92), !dbg !300
  store i64 %r93, ptr %slot.audiofmt, align 8, !dbg !300
  %r94 = load i64, ptr %slot.b, align 8, !dbg !301
  %r95 = add i64 22, 0, !dbg !301
  %r96 = call i64 @_wav_rd_u16le(i64 %r94, i64 %r95), !dbg !301
  store i64 %r96, ptr %slot.channels, align 8, !dbg !301
  %r97 = load i64, ptr %slot.b, align 8, !dbg !302
  %r98 = add i64 24, 0, !dbg !302
  %r99 = call i64 @_wav_rd_u32le(i64 %r97, i64 %r98), !dbg !302
  store i64 %r99, ptr %slot.samplerate, align 8, !dbg !302
  %r100 = load i64, ptr %slot.b, align 8, !dbg !303
  %r101 = add i64 34, 0, !dbg !303
  %r102 = call i64 @_wav_rd_u16le(i64 %r100, i64 %r101), !dbg !303
  store i64 %r102, ptr %slot.bits, align 8, !dbg !303
  %r103 = add i64 %r93, 0, !dbg !304
  %r104 = add i64 1, 0, !dbg !304
  %r105.cmp = icmp ne i64 %r103, %r104, !dbg !304
  %r105 = zext i1 %r105.cmp to i64, !dbg !304
  %br_retthen3313 = icmp ne i64 %r105, 0, !dbg !304
  br i1 %br_retthen3313, label %retthen33, label %retelse34, !dbg !304
retthen33:
  %r106 = load i64, ptr %slot.empty, align 8, !dbg !305
  ret i64 %r106, !dbg !305
retelse34:
  %r107 = load i64, ptr %slot.bits, align 8, !dbg !306
  %r108 = add i64 16, 0, !dbg !306
  %r109.cmp = icmp ne i64 %r107, %r108, !dbg !306
  %r109 = zext i1 %r109.cmp to i64, !dbg !306
  %br_retthen3514 = icmp ne i64 %r109, 0, !dbg !306
  br i1 %br_retthen3514, label %retthen35, label %retelse36, !dbg !306
retthen35:
  %r110 = load i64, ptr %slot.empty, align 8, !dbg !307
  ret i64 %r110, !dbg !307
retelse36:
  %r111 = load i64, ptr %slot.b, align 8, !dbg !308
  %r112 = add i64 36, 0, !dbg !308
  %r113 = call i64 @nova_rt_bytes_get(i64 %r111, i64 %r112), !dbg !308
  store i64 %r113, ptr %slot.d0, align 8, !dbg !308
  %r114 = load i64, ptr %slot.b, align 8, !dbg !309
  %r115 = add i64 37, 0, !dbg !309
  %r116 = call i64 @nova_rt_bytes_get(i64 %r114, i64 %r115), !dbg !309
  store i64 %r116, ptr %slot.d1, align 8, !dbg !309
  %r117 = load i64, ptr %slot.b, align 8, !dbg !310
  %r118 = add i64 38, 0, !dbg !310
  %r119 = call i64 @nova_rt_bytes_get(i64 %r117, i64 %r118), !dbg !310
  store i64 %r119, ptr %slot.d2, align 8, !dbg !310
  %r120 = load i64, ptr %slot.b, align 8, !dbg !311
  %r121 = add i64 39, 0, !dbg !311
  %r122 = call i64 @nova_rt_bytes_get(i64 %r120, i64 %r121), !dbg !311
  store i64 %r122, ptr %slot.d3, align 8, !dbg !311
  %r123 = add i64 %r113, 0, !dbg !312
  %r124 = add i64 100, 0, !dbg !312
  %r125.cmp = icmp ne i64 %r123, %r124, !dbg !312
  %r125 = zext i1 %r125.cmp to i64, !dbg !312
  %br_retthen3715 = icmp ne i64 %r125, 0, !dbg !312
  br i1 %br_retthen3715, label %retthen37, label %retelse38, !dbg !312
retthen37:
  %r126 = load i64, ptr %slot.empty, align 8, !dbg !313
  ret i64 %r126, !dbg !313
retelse38:
  %r127 = load i64, ptr %slot.d1, align 8, !dbg !314
  %r128 = add i64 97, 0, !dbg !314
  %r129.cmp = icmp ne i64 %r127, %r128, !dbg !314
  %r129 = zext i1 %r129.cmp to i64, !dbg !314
  %br_retthen3916 = icmp ne i64 %r129, 0, !dbg !314
  br i1 %br_retthen3916, label %retthen39, label %retelse40, !dbg !314
retthen39:
  %r130 = load i64, ptr %slot.empty, align 8, !dbg !315
  ret i64 %r130, !dbg !315
retelse40:
  %r131 = load i64, ptr %slot.d2, align 8, !dbg !316
  %r132 = add i64 116, 0, !dbg !316
  %r133.cmp = icmp ne i64 %r131, %r132, !dbg !316
  %r133 = zext i1 %r133.cmp to i64, !dbg !316
  %br_retthen4117 = icmp ne i64 %r133, 0, !dbg !316
  br i1 %br_retthen4117, label %retthen41, label %retelse42, !dbg !316
retthen41:
  %r134 = load i64, ptr %slot.empty, align 8, !dbg !317
  ret i64 %r134, !dbg !317
retelse42:
  %r135 = load i64, ptr %slot.d3, align 8, !dbg !318
  %r136 = add i64 97, 0, !dbg !318
  %r137.cmp = icmp ne i64 %r135, %r136, !dbg !318
  %r137 = zext i1 %r137.cmp to i64, !dbg !318
  %br_retthen4318 = icmp ne i64 %r137, 0, !dbg !318
  br i1 %br_retthen4318, label %retthen43, label %retelse44, !dbg !318
retthen43:
  %r138 = load i64, ptr %slot.empty, align 8, !dbg !319
  ret i64 %r138, !dbg !319
retelse44:
  %r139 = load i64, ptr %slot.b, align 8, !dbg !320
  %r140 = add i64 40, 0, !dbg !320
  %r141 = call i64 @_wav_rd_u32le(i64 %r139, i64 %r140), !dbg !320
  store i64 %r141, ptr %slot.datasize, align 8, !dbg !320
  %r142 = add i64 %r141, 0, !dbg !321
  %r143 = add i64 2, 0, !dbg !321
  %r144 = call i64 @nova_rt_div(i64 %r142, i64 %r143), !dbg !321
  store i64 %r144, ptr %slot.numsamples, align 8, !dbg !321
  %r145 = add i64 44, 0, !dbg !322
  store i64 %r145, ptr %slot.sampstart, align 8, !dbg !322
  %r146 = add i64 %r145, 0, !dbg !323
  %r147 = add i64 %r141, 0, !dbg !323
  %r148 = add i64 %r146, %r147, !dbg !323
  store i64 %r148, ptr %slot.sampend, align 8, !dbg !323
  %r149 = add i64 %r148, 0, !dbg !324
  %r150 = load i64, ptr %slot.blen, align 8, !dbg !324
  %r151.cmp = icmp sgt i64 %r149, %r150, !dbg !324
  %r151 = zext i1 %r151.cmp to i64, !dbg !324
  %br_retthen4519 = icmp ne i64 %r151, 0, !dbg !324
  br i1 %br_retthen4519, label %retthen45, label %retelse46, !dbg !324
retthen45:
  %r152 = load i64, ptr %slot.empty, align 8, !dbg !325
  ret i64 %r152, !dbg !325
retelse46:
  %r153 = call i64 @nova_rt_list_create(), !dbg !326
  store i64 %r153, ptr %slot.smplist, align 8, !dbg !326
  %r154 = load i64, ptr %slot.sampstart, align 8, !dbg !327
  store i64 %r154, ptr %slot.si, align 8, !dbg !327
  %r155 = add i64 0, 0, !dbg !328
  store i64 %r155, ptr %slot.sc, align 8, !dbg !328
  br label %while_hdr47, !dbg !329
while_hdr47:
  %r156 = load i64, ptr %slot.sc, align 8, !dbg !329
  %r157 = load i64, ptr %slot.numsamples, align 8, !dbg !329
  %r158.cmp = icmp slt i64 %r156, %r157, !dbg !329
  %r158 = zext i1 %r158.cmp to i64, !dbg !329
  %br_while_body4820 = icmp ne i64 %r158, 0, !dbg !329
  br i1 %br_while_body4820, label %while_body48, label %while_exit49, !prof !90, !dbg !329
while_body48:
  %r159 = load i64, ptr %slot.b, align 8, !dbg !330
  %r160 = load i64, ptr %slot.si, align 8, !dbg !330
  %r161 = call i64 @nova_rt_bytes_get(i64 %r159, i64 %r160), !dbg !330
  store i64 %r161, ptr %slot.lo, align 8, !dbg !330
  %r162 = load i64, ptr %slot.b, align 8, !dbg !331
  %r163 = load i64, ptr %slot.si, align 8, !dbg !331
  %r164 = add i64 1, 0, !dbg !331
  %r165 = add i64 %r163, %r164, !dbg !331
  %r166 = call i64 @nova_rt_bytes_get(i64 %r162, i64 %r165), !dbg !331
  store i64 %r166, ptr %slot.hi, align 8, !dbg !331
  %r167 = add i64 %r161, 0, !dbg !332
  %r168 = add i64 %r166, 0, !dbg !332
  %r169 = add i64 256, 0, !dbg !332
  %r170 = mul i64 %r168, %r169, !dbg !332
  %r171 = or i64 %r167, %r170, !dbg !332
  store i64 %r171, ptr %slot.u, align 8, !dbg !332
  %r172 = add i64 %r171, 0, !dbg !333
  store i64 %r172, ptr %slot.sv, align 8, !dbg !333
  %r173 = add i64 %r171, 0, !dbg !334
  %r174 = add i64 32768, 0, !dbg !334
  %r175 = call i64 @nova_rt_ge(i64 %r173, i64 %r174), !dbg !334
  %br_then5021 = icmp ne i64 %r175, 0, !dbg !334
  br i1 %br_then5021, label %then50, label %else51, !dbg !334
then50:
  %r176 = load i64, ptr %slot.u, align 8, !dbg !335
  %r177 = add i64 65536, 0, !dbg !335
  %r178 = call i64 @nova_rt_sub(i64 %r176, i64 %r177), !dbg !335
  store i64 %r178, ptr %slot.sv, align 8, !dbg !335
  br label %endif52, !dbg !335
else51:
  br label %endif52, !dbg !335
endif52:
  %r179 = load i64, ptr %slot.smplist, align 8, !dbg !336
  %r180 = load i64, ptr %slot.sv, align 8, !dbg !336
  %r181 = call i64 @nova_rt_list_append_no_rc(i64 %r179, i64 %r180), !dbg !336
  %r182 = load i64, ptr %slot.si, align 8, !dbg !337
  %r183 = add i64 2, 0, !dbg !337
  %r184 = add i64 %r182, %r183, !dbg !337
  store i64 %r184, ptr %slot.si, align 8, !dbg !337
  %r185 = load i64, ptr %slot.sc, align 8, !dbg !338
  %r186 = add i64 1, 0, !dbg !338
  %r187 = add i64 %r185, %r186, !dbg !338
  store i64 %r187, ptr %slot.sc, align 8, !dbg !338
  br label %while_hdr47, !dbg !338
while_exit49:
  %r188 = call i64 @nova_rt_dict_create(), !dbg !339
  %r189.p = getelementptr inbounds [11 x i8], ptr @.str.4, i64 0, i64 0, !dbg !339
  %r189 = ptrtoint ptr %r189.p to i64, !dbg !339
  %r190 = load i64, ptr %slot.samplerate, align 8, !dbg !339
  call i64 @nova_rt_dict_set(i64 %r188, i64 %r189, i64 %r190), !dbg !339
  %r191.p = getelementptr inbounds [9 x i8], ptr @.str.5, i64 0, i64 0, !dbg !339
  %r191 = ptrtoint ptr %r191.p to i64, !dbg !339
  %r192 = load i64, ptr %slot.channels, align 8, !dbg !339
  call i64 @nova_rt_dict_set(i64 %r188, i64 %r191, i64 %r192), !dbg !339
  %r193.p = getelementptr inbounds [5 x i8], ptr @.str.6, i64 0, i64 0, !dbg !339
  %r193 = ptrtoint ptr %r193.p to i64, !dbg !339
  %r194 = load i64, ptr %slot.bits, align 8, !dbg !339
  call i64 @nova_rt_dict_set(i64 %r188, i64 %r193, i64 %r194), !dbg !339
  %r195.p = getelementptr inbounds [8 x i8], ptr @.str.7, i64 0, i64 0, !dbg !339
  %r195 = ptrtoint ptr %r195.p to i64, !dbg !339
  %r196 = load i64, ptr %slot.smplist, align 8, !dbg !339
  call i64 @nova_rt_dict_set(i64 %r188, i64 %r195, i64 %r196), !dbg !339
  store i64 %r188, ptr %slot.res, align 8, !dbg !339
  %r197 = add i64 %r188, 0, !dbg !340
  ret i64 %r197, !dbg !340
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
@.str.0 = private unnamed_addr constant [5 x i8] c"RIFF\00"
@.str.1 = private unnamed_addr constant [5 x i8] c"WAVE\00"
@.str.2 = private unnamed_addr constant [5 x i8] c"fmt \00"
@.str.3 = private unnamed_addr constant [5 x i8] c"data\00"
@.str.4 = private unnamed_addr constant [11 x i8] c"samplerate\00"
@.str.5 = private unnamed_addr constant [9 x i8] c"channels\00"
@.str.6 = private unnamed_addr constant [5 x i8] c"bits\00"
@.str.7 = private unnamed_addr constant [8 x i8] c"samples\00"

; Debug metadata
!llvm.dbg.cu = !{!100}
!llvm.module.flags = !{!102, !103}

!100 = distinct !DICompileUnit(language: DW_LANG_C99, file: !101, producer: "NOVA Compiler", isOptimized: false, emissionKind: LineTablesOnly)
!101 = !DIFile(filename: "std/media/wav.nova", directory: ".")
!102 = !{i32 2, !"CodeView", i32 1}
!103 = !{i32 2, !"Debug Info Version", i32 3}
!104 = !DISubroutineType(types: !105)
!105 = !{null}
!200 = distinct !DISubprogram(name: "_wav_u32le", scope: !101, file: !101, line: 47, type: !104, scopeLine: 47, spFlags: DISPFlagDefinition, unit: !100)
!201 = !DILocation(line: 47, column: 0, scope: !200)
!207 = distinct !DISubprogram(name: "_wav_u16le", scope: !101, file: !101, line: 55, type: !104, scopeLine: 55, spFlags: DISPFlagDefinition, unit: !100)
!208 = !DILocation(line: 55, column: 0, scope: !207)
!212 = distinct !DISubprogram(name: "_wav_rd_u32le", scope: !101, file: !101, line: 61, type: !104, scopeLine: 61, spFlags: DISPFlagDefinition, unit: !100)
!213 = !DILocation(line: 61, column: 0, scope: !212)
!219 = distinct !DISubprogram(name: "_wav_rd_u16le", scope: !101, file: !101, line: 69, type: !104, scopeLine: 69, spFlags: DISPFlagDefinition, unit: !100)
!220 = !DILocation(line: 69, column: 0, scope: !219)
!224 = distinct !DISubprogram(name: "wav_encode", scope: !101, file: !101, line: 80, type: !104, scopeLine: 80, spFlags: DISPFlagDefinition, unit: !100)
!225 = !DILocation(line: 80, column: 0, scope: !224)
!258 = distinct !DISubprogram(name: "wav_decode", scope: !101, file: !101, line: 128, type: !104, scopeLine: 128, spFlags: DISPFlagDefinition, unit: !100)
!259 = !DILocation(line: 128, column: 0, scope: !258)
!202 = !DILocation(line: 48, column: 0, scope: !200)
!203 = !DILocation(line: 49, column: 0, scope: !200)
!204 = !DILocation(line: 50, column: 0, scope: !200)
!205 = !DILocation(line: 51, column: 0, scope: !200)
!206 = !DILocation(line: 52, column: 0, scope: !200)
!209 = !DILocation(line: 56, column: 0, scope: !207)
!210 = !DILocation(line: 57, column: 0, scope: !207)
!211 = !DILocation(line: 58, column: 0, scope: !207)
!214 = !DILocation(line: 62, column: 0, scope: !212)
!215 = !DILocation(line: 63, column: 0, scope: !212)
!216 = !DILocation(line: 64, column: 0, scope: !212)
!217 = !DILocation(line: 65, column: 0, scope: !212)
!218 = !DILocation(line: 66, column: 0, scope: !212)
!221 = !DILocation(line: 70, column: 0, scope: !219)
!222 = !DILocation(line: 71, column: 0, scope: !219)
!223 = !DILocation(line: 72, column: 0, scope: !219)
!226 = !DILocation(line: 81, column: 0, scope: !224)
!227 = !DILocation(line: 82, column: 0, scope: !224)
!228 = !DILocation(line: 83, column: 0, scope: !224)
!229 = !DILocation(line: 84, column: 0, scope: !224)
!230 = !DILocation(line: 85, column: 0, scope: !224)
!231 = !DILocation(line: 87, column: 0, scope: !224)
!232 = !DILocation(line: 88, column: 0, scope: !224)
!233 = !DILocation(line: 89, column: 0, scope: !224)
!234 = !DILocation(line: 90, column: 0, scope: !224)
!235 = !DILocation(line: 91, column: 0, scope: !224)
!236 = !DILocation(line: 94, column: 0, scope: !224)
!237 = !DILocation(line: 95, column: 0, scope: !224)
!238 = !DILocation(line: 96, column: 0, scope: !224)
!239 = !DILocation(line: 97, column: 0, scope: !224)
!240 = !DILocation(line: 100, column: 0, scope: !224)
!241 = !DILocation(line: 101, column: 0, scope: !224)
!242 = !DILocation(line: 102, column: 0, scope: !224)
!243 = !DILocation(line: 103, column: 0, scope: !224)
!244 = !DILocation(line: 104, column: 0, scope: !224)
!245 = !DILocation(line: 105, column: 0, scope: !224)
!246 = !DILocation(line: 106, column: 0, scope: !224)
!247 = !DILocation(line: 107, column: 0, scope: !224)
!248 = !DILocation(line: 110, column: 0, scope: !224)
!249 = !DILocation(line: 111, column: 0, scope: !224)
!250 = !DILocation(line: 114, column: 0, scope: !224)
!251 = !DILocation(line: 115, column: 0, scope: !224)
!252 = !DILocation(line: 116, column: 0, scope: !224)
!253 = !DILocation(line: 117, column: 0, scope: !224)
!254 = !DILocation(line: 118, column: 0, scope: !224)
!255 = !DILocation(line: 119, column: 0, scope: !224)
!256 = !DILocation(line: 120, column: 0, scope: !224)
!257 = !DILocation(line: 122, column: 0, scope: !224)
!260 = !DILocation(line: 129, column: 0, scope: !258)
!261 = !DILocation(line: 130, column: 0, scope: !258)
!262 = !DILocation(line: 133, column: 0, scope: !258)
!263 = !DILocation(line: 134, column: 0, scope: !258)
!264 = !DILocation(line: 137, column: 0, scope: !258)
!265 = !DILocation(line: 138, column: 0, scope: !258)
!266 = !DILocation(line: 139, column: 0, scope: !258)
!267 = !DILocation(line: 140, column: 0, scope: !258)
!268 = !DILocation(line: 141, column: 0, scope: !258)
!269 = !DILocation(line: 142, column: 0, scope: !258)
!270 = !DILocation(line: 143, column: 0, scope: !258)
!271 = !DILocation(line: 144, column: 0, scope: !258)
!272 = !DILocation(line: 145, column: 0, scope: !258)
!273 = !DILocation(line: 146, column: 0, scope: !258)
!274 = !DILocation(line: 147, column: 0, scope: !258)
!275 = !DILocation(line: 148, column: 0, scope: !258)
!276 = !DILocation(line: 151, column: 0, scope: !258)
!277 = !DILocation(line: 152, column: 0, scope: !258)
!278 = !DILocation(line: 153, column: 0, scope: !258)
!279 = !DILocation(line: 154, column: 0, scope: !258)
!280 = !DILocation(line: 155, column: 0, scope: !258)
!281 = !DILocation(line: 156, column: 0, scope: !258)
!282 = !DILocation(line: 157, column: 0, scope: !258)
!283 = !DILocation(line: 158, column: 0, scope: !258)
!284 = !DILocation(line: 159, column: 0, scope: !258)
!285 = !DILocation(line: 160, column: 0, scope: !258)
!286 = !DILocation(line: 161, column: 0, scope: !258)
!287 = !DILocation(line: 162, column: 0, scope: !258)
!288 = !DILocation(line: 165, column: 0, scope: !258)
!289 = !DILocation(line: 166, column: 0, scope: !258)
!290 = !DILocation(line: 167, column: 0, scope: !258)
!291 = !DILocation(line: 168, column: 0, scope: !258)
!292 = !DILocation(line: 169, column: 0, scope: !258)
!293 = !DILocation(line: 170, column: 0, scope: !258)
!294 = !DILocation(line: 171, column: 0, scope: !258)
!295 = !DILocation(line: 172, column: 0, scope: !258)
!296 = !DILocation(line: 173, column: 0, scope: !258)
!297 = !DILocation(line: 174, column: 0, scope: !258)
!298 = !DILocation(line: 175, column: 0, scope: !258)
!299 = !DILocation(line: 176, column: 0, scope: !258)
!300 = !DILocation(line: 179, column: 0, scope: !258)
!301 = !DILocation(line: 180, column: 0, scope: !258)
!302 = !DILocation(line: 181, column: 0, scope: !258)
!303 = !DILocation(line: 182, column: 0, scope: !258)
!304 = !DILocation(line: 185, column: 0, scope: !258)
!305 = !DILocation(line: 186, column: 0, scope: !258)
!306 = !DILocation(line: 187, column: 0, scope: !258)
!307 = !DILocation(line: 188, column: 0, scope: !258)
!308 = !DILocation(line: 191, column: 0, scope: !258)
!309 = !DILocation(line: 192, column: 0, scope: !258)
!310 = !DILocation(line: 193, column: 0, scope: !258)
!311 = !DILocation(line: 194, column: 0, scope: !258)
!312 = !DILocation(line: 195, column: 0, scope: !258)
!313 = !DILocation(line: 196, column: 0, scope: !258)
!314 = !DILocation(line: 197, column: 0, scope: !258)
!315 = !DILocation(line: 198, column: 0, scope: !258)
!316 = !DILocation(line: 199, column: 0, scope: !258)
!317 = !DILocation(line: 200, column: 0, scope: !258)
!318 = !DILocation(line: 201, column: 0, scope: !258)
!319 = !DILocation(line: 202, column: 0, scope: !258)
!320 = !DILocation(line: 204, column: 0, scope: !258)
!321 = !DILocation(line: 205, column: 0, scope: !258)
!322 = !DILocation(line: 206, column: 0, scope: !258)
!323 = !DILocation(line: 207, column: 0, scope: !258)
!324 = !DILocation(line: 210, column: 0, scope: !258)
!325 = !DILocation(line: 211, column: 0, scope: !258)
!326 = !DILocation(line: 213, column: 0, scope: !258)
!327 = !DILocation(line: 214, column: 0, scope: !258)
!328 = !DILocation(line: 215, column: 0, scope: !258)
!329 = !DILocation(line: 216, column: 0, scope: !258)
!330 = !DILocation(line: 217, column: 0, scope: !258)
!331 = !DILocation(line: 218, column: 0, scope: !258)
!332 = !DILocation(line: 219, column: 0, scope: !258)
!333 = !DILocation(line: 220, column: 0, scope: !258)
!334 = !DILocation(line: 221, column: 0, scope: !258)
!335 = !DILocation(line: 222, column: 0, scope: !258)
!336 = !DILocation(line: 223, column: 0, scope: !258)
!337 = !DILocation(line: 224, column: 0, scope: !258)
!338 = !DILocation(line: 225, column: 0, scope: !258)
!339 = !DILocation(line: 227, column: 0, scope: !258)
!340 = !DILocation(line: 228, column: 0, scope: !258)

; TBAA metadata
!0 = !{!"NOVA TBAA"}
!1 = !{!"list_data_ptr", !0}
!2 = !{!1, !1, i64 0}
!3 = !{!"list_elem", !0}
!4 = !{!3, !3, i64 0}
!5 = !{!"list_size", !0}
!6 = !{!5, !5, i64 0}
!90 = !{!"branch_weights", i32 2000, i32 1}
