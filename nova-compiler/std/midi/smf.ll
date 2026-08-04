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

; ESCAPE _smf_push_u16: allocs=0 escape=0 local=0
define i64 @_smf_push_u16(i64 %p0, i64 %p1) nounwind uwtable !dbg !200 {
entry:
  %slot.lst = alloca i64, align 8, !dbg !201
  store i64 %p0, ptr %slot.lst, align 8, !dbg !201
  %slot.v = alloca i64, align 8, !dbg !201
  store i64 %p1, ptr %slot.v, align 8, !dbg !201
  %slot.hi = alloca i64, align 8, !dbg !201
  store i64 0, ptr %slot.hi, align 8, !dbg !201
  %slot.lo = alloca i64, align 8, !dbg !201
  store i64 0, ptr %slot.lo, align 8, !dbg !201
  %r0 = load i64, ptr %slot.v, align 8, !dbg !202
  %r1 = add i64 8, 0, !dbg !202
  %r2.sramt = and i64 %r1, 63, !dbg !202
  %r2.srbig = icmp uge i64 %r1, 64, !dbg !202
  %r2.srval = ashr i64 %r0, %r2.sramt, !dbg !202
  %r2.srext = ashr i64 %r0, 63, !dbg !202
  %r2 = select i1 %r2.srbig, i64 %r2.srext, i64 %r2.srval, !dbg !202
  %r3 = add i64 255, 0, !dbg !202
  %r4 = and i64 %r2, %r3, !dbg !202
  store i64 %r4, ptr %slot.hi, align 8, !dbg !202
  %r5 = load i64, ptr %slot.v, align 8, !dbg !203
  %r6 = add i64 255, 0, !dbg !203
  %r7 = and i64 %r5, %r6, !dbg !203
  store i64 %r7, ptr %slot.lo, align 8, !dbg !203
  %r8 = load i64, ptr %slot.lst, align 8, !dbg !204
  %r9 = add i64 %r4, 0, !dbg !204
  %r10 = call i64 @nova_rt_list_append(i64 %r8, i64 %r9), !dbg !204
  %r11 = load i64, ptr %slot.lst, align 8, !dbg !205
  %r12 = add i64 %r7, 0, !dbg !205
  %r13 = call i64 @nova_rt_list_append(i64 %r11, i64 %r12), !dbg !205
  %r14 = add i64 0, 0, !dbg !206
  ret i64 %r14, !dbg !206
}

; ESCAPE _smf_push_u32: allocs=0 escape=0 local=0
define i64 @_smf_push_u32(i64 %p0, i64 %p1) nounwind uwtable !dbg !207 {
entry:
  %slot.lst = alloca i64, align 8, !dbg !208
  store i64 %p0, ptr %slot.lst, align 8, !dbg !208
  %slot.v = alloca i64, align 8, !dbg !208
  store i64 %p1, ptr %slot.v, align 8, !dbg !208
  %slot.b3 = alloca i64, align 8, !dbg !208
  store i64 0, ptr %slot.b3, align 8, !dbg !208
  %slot.b2 = alloca i64, align 8, !dbg !208
  store i64 0, ptr %slot.b2, align 8, !dbg !208
  %slot.b1 = alloca i64, align 8, !dbg !208
  store i64 0, ptr %slot.b1, align 8, !dbg !208
  %slot.b0 = alloca i64, align 8, !dbg !208
  store i64 0, ptr %slot.b0, align 8, !dbg !208
  %r0 = load i64, ptr %slot.v, align 8, !dbg !209
  %r1 = add i64 24, 0, !dbg !209
  %r2.sramt = and i64 %r1, 63, !dbg !209
  %r2.srbig = icmp uge i64 %r1, 64, !dbg !209
  %r2.srval = ashr i64 %r0, %r2.sramt, !dbg !209
  %r2.srext = ashr i64 %r0, 63, !dbg !209
  %r2 = select i1 %r2.srbig, i64 %r2.srext, i64 %r2.srval, !dbg !209
  %r3 = add i64 255, 0, !dbg !209
  %r4 = and i64 %r2, %r3, !dbg !209
  store i64 %r4, ptr %slot.b3, align 8, !dbg !209
  %r5 = load i64, ptr %slot.v, align 8, !dbg !210
  %r6 = add i64 16, 0, !dbg !210
  %r7.sramt = and i64 %r6, 63, !dbg !210
  %r7.srbig = icmp uge i64 %r6, 64, !dbg !210
  %r7.srval = ashr i64 %r5, %r7.sramt, !dbg !210
  %r7.srext = ashr i64 %r5, 63, !dbg !210
  %r7 = select i1 %r7.srbig, i64 %r7.srext, i64 %r7.srval, !dbg !210
  %r8 = add i64 255, 0, !dbg !210
  %r9 = and i64 %r7, %r8, !dbg !210
  store i64 %r9, ptr %slot.b2, align 8, !dbg !210
  %r10 = load i64, ptr %slot.v, align 8, !dbg !211
  %r11 = add i64 8, 0, !dbg !211
  %r12.sramt = and i64 %r11, 63, !dbg !211
  %r12.srbig = icmp uge i64 %r11, 64, !dbg !211
  %r12.srval = ashr i64 %r10, %r12.sramt, !dbg !211
  %r12.srext = ashr i64 %r10, 63, !dbg !211
  %r12 = select i1 %r12.srbig, i64 %r12.srext, i64 %r12.srval, !dbg !211
  %r13 = add i64 255, 0, !dbg !211
  %r14 = and i64 %r12, %r13, !dbg !211
  store i64 %r14, ptr %slot.b1, align 8, !dbg !211
  %r15 = load i64, ptr %slot.v, align 8, !dbg !212
  %r16 = add i64 255, 0, !dbg !212
  %r17 = and i64 %r15, %r16, !dbg !212
  store i64 %r17, ptr %slot.b0, align 8, !dbg !212
  %r18 = load i64, ptr %slot.lst, align 8, !dbg !213
  %r19 = add i64 %r4, 0, !dbg !213
  %r20 = call i64 @nova_rt_list_append(i64 %r18, i64 %r19), !dbg !213
  %r21 = load i64, ptr %slot.lst, align 8, !dbg !214
  %r22 = add i64 %r9, 0, !dbg !214
  %r23 = call i64 @nova_rt_list_append(i64 %r21, i64 %r22), !dbg !214
  %r24 = load i64, ptr %slot.lst, align 8, !dbg !215
  %r25 = add i64 %r14, 0, !dbg !215
  %r26 = call i64 @nova_rt_list_append(i64 %r24, i64 %r25), !dbg !215
  %r27 = load i64, ptr %slot.lst, align 8, !dbg !216
  %r28 = add i64 %r17, 0, !dbg !216
  %r29 = call i64 @nova_rt_list_append(i64 %r27, i64 %r28), !dbg !216
  %r30 = add i64 0, 0, !dbg !217
  ret i64 %r30, !dbg !217
}

; ESCAPE _smf_read_u16: allocs=0 escape=0 local=0
define i64 @_smf_read_u16(i64 %p0, i64 %p1) nounwind uwtable !dbg !218 {
entry:
  %slot.bytes_list = alloca i64, align 8, !dbg !219
  store i64 %p0, ptr %slot.bytes_list, align 8, !dbg !219
  %slot.pos = alloca i64, align 8, !dbg !219
  store i64 %p1, ptr %slot.pos, align 8, !dbg !219
  %slot.n = alloca i64, align 8, !dbg !219
  store i64 0, ptr %slot.n, align 8, !dbg !219
  %slot.hi = alloca i64, align 8, !dbg !219
  store i64 0, ptr %slot.hi, align 8, !dbg !219
  %slot.lo = alloca i64, align 8, !dbg !219
  store i64 0, ptr %slot.lo, align 8, !dbg !219
  %r0 = load i64, ptr %slot.bytes_list, align 8, !dbg !220
  %r1 = call i64 @nova_rt_len_any(i64 %r0), !dbg !220
  store i64 %r1, ptr %slot.n, align 8, !dbg !220
  %r2 = load i64, ptr %slot.pos, align 8, !dbg !221
  %r3 = add i64 1, 0, !dbg !221
  %r4 = add i64 %r2, %r3, !dbg !221
  %r5 = add i64 %r1, 0, !dbg !221
  %r6.cmp = icmp sge i64 %r4, %r5, !dbg !221
  %r6 = zext i1 %r6.cmp to i64, !dbg !221
  %br_then00 = icmp ne i64 %r6, 0, !dbg !221
  br i1 %br_then00, label %then0, label %else1, !dbg !221
then0:
  %r7 = add i64 0, 0, !dbg !222
  ret i64 %r7, !dbg !222
else1:
  br label %endif2, !dbg !222
endif2:
  %r8 = load i64, ptr %slot.bytes_list, align 8, !dbg !223
  %r9 = load i64, ptr %slot.pos, align 8, !dbg !223
  %r10 = call i64 @nova_rt_index_get(i64 %r8, i64 %r9), !dbg !223
  %r11 = add i64 255, 0, !dbg !223
  %r12 = and i64 %r10, %r11, !dbg !223
  store i64 %r12, ptr %slot.hi, align 8, !dbg !223
  %r13 = load i64, ptr %slot.bytes_list, align 8, !dbg !224
  %r14 = load i64, ptr %slot.pos, align 8, !dbg !224
  %r15 = add i64 1, 0, !dbg !224
  %r16 = add i64 %r14, %r15, !dbg !224
  %r17 = call i64 @nova_rt_index_get(i64 %r13, i64 %r16), !dbg !224
  %r18 = add i64 255, 0, !dbg !224
  %r19 = and i64 %r17, %r18, !dbg !224
  store i64 %r19, ptr %slot.lo, align 8, !dbg !224
  %r20 = add i64 %r12, 0, !dbg !225
  %r21 = add i64 8, 0, !dbg !225
  %r22.shamt = and i64 %r21, 63, !dbg !225
  %r22.shbig = icmp uge i64 %r21, 64, !dbg !225
  %r22.shval = shl i64 %r20, %r22.shamt, !dbg !225
  %r22 = select i1 %r22.shbig, i64 0, i64 %r22.shval, !dbg !225
  %r23 = add i64 %r19, 0, !dbg !225
  %r24 = or i64 %r22, %r23, !dbg !225
  ret i64 %r24, !dbg !225
}

; ESCAPE _smf_read_u32: allocs=0 escape=0 local=0
define i64 @_smf_read_u32(i64 %p0, i64 %p1) nounwind uwtable !dbg !226 {
entry:
  %slot.bytes_list = alloca i64, align 8, !dbg !227
  store i64 %p0, ptr %slot.bytes_list, align 8, !dbg !227
  %slot.pos = alloca i64, align 8, !dbg !227
  store i64 %p1, ptr %slot.pos, align 8, !dbg !227
  %slot.n = alloca i64, align 8, !dbg !227
  store i64 0, ptr %slot.n, align 8, !dbg !227
  %slot.b3 = alloca i64, align 8, !dbg !227
  store i64 0, ptr %slot.b3, align 8, !dbg !227
  %slot.b2 = alloca i64, align 8, !dbg !227
  store i64 0, ptr %slot.b2, align 8, !dbg !227
  %slot.b1 = alloca i64, align 8, !dbg !227
  store i64 0, ptr %slot.b1, align 8, !dbg !227
  %slot.b0 = alloca i64, align 8, !dbg !227
  store i64 0, ptr %slot.b0, align 8, !dbg !227
  %r0 = load i64, ptr %slot.bytes_list, align 8, !dbg !228
  %r1 = call i64 @nova_rt_len_any(i64 %r0), !dbg !228
  store i64 %r1, ptr %slot.n, align 8, !dbg !228
  %r2 = load i64, ptr %slot.pos, align 8, !dbg !229
  %r3 = add i64 3, 0, !dbg !229
  %r4 = call i64 @nova_rt_add(i64 %r2, i64 %r3), !dbg !229
  %r5 = add i64 %r1, 0, !dbg !229
  %r6 = call i64 @nova_rt_ge(i64 %r4, i64 %r5), !dbg !229
  %br_then30 = icmp ne i64 %r6, 0, !dbg !229
  br i1 %br_then30, label %then3, label %else4, !dbg !229
then3:
  %r7 = add i64 0, 0, !dbg !230
  ret i64 %r7, !dbg !230
else4:
  br label %endif5, !dbg !230
endif5:
  %r8 = load i64, ptr %slot.bytes_list, align 8, !dbg !231
  %r9 = load i64, ptr %slot.pos, align 8, !dbg !231
  %r10 = call i64 @nova_rt_index_get(i64 %r8, i64 %r9), !dbg !231
  %r11 = add i64 255, 0, !dbg !231
  %r12 = and i64 %r10, %r11, !dbg !231
  store i64 %r12, ptr %slot.b3, align 8, !dbg !231
  %r13 = load i64, ptr %slot.bytes_list, align 8, !dbg !232
  %r14 = load i64, ptr %slot.pos, align 8, !dbg !232
  %r15 = add i64 1, 0, !dbg !232
  %r16 = call i64 @nova_rt_add(i64 %r14, i64 %r15), !dbg !232
  %r17 = call i64 @nova_rt_index_get(i64 %r13, i64 %r16), !dbg !232
  %r18 = add i64 255, 0, !dbg !232
  %r19 = and i64 %r17, %r18, !dbg !232
  store i64 %r19, ptr %slot.b2, align 8, !dbg !232
  %r20 = load i64, ptr %slot.bytes_list, align 8, !dbg !233
  %r21 = load i64, ptr %slot.pos, align 8, !dbg !233
  %r22 = add i64 2, 0, !dbg !233
  %r23 = call i64 @nova_rt_add(i64 %r21, i64 %r22), !dbg !233
  %r24 = call i64 @nova_rt_index_get(i64 %r20, i64 %r23), !dbg !233
  %r25 = add i64 255, 0, !dbg !233
  %r26 = and i64 %r24, %r25, !dbg !233
  store i64 %r26, ptr %slot.b1, align 8, !dbg !233
  %r27 = load i64, ptr %slot.bytes_list, align 8, !dbg !234
  %r28 = load i64, ptr %slot.pos, align 8, !dbg !234
  %r29 = add i64 3, 0, !dbg !234
  %r30 = call i64 @nova_rt_add(i64 %r28, i64 %r29), !dbg !234
  %r31 = call i64 @nova_rt_index_get(i64 %r27, i64 %r30), !dbg !234
  %r32 = add i64 255, 0, !dbg !234
  %r33 = and i64 %r31, %r32, !dbg !234
  store i64 %r33, ptr %slot.b0, align 8, !dbg !234
  %r34 = add i64 %r12, 0, !dbg !235
  %r35 = add i64 24, 0, !dbg !235
  %r36.shamt = and i64 %r35, 63, !dbg !235
  %r36.shbig = icmp uge i64 %r35, 64, !dbg !235
  %r36.shval = shl i64 %r34, %r36.shamt, !dbg !235
  %r36 = select i1 %r36.shbig, i64 0, i64 %r36.shval, !dbg !235
  %r37 = add i64 %r19, 0, !dbg !235
  %r38 = add i64 16, 0, !dbg !235
  %r39.shamt = and i64 %r38, 63, !dbg !235
  %r39.shbig = icmp uge i64 %r38, 64, !dbg !235
  %r39.shval = shl i64 %r37, %r39.shamt, !dbg !235
  %r39 = select i1 %r39.shbig, i64 0, i64 %r39.shval, !dbg !235
  %r40 = or i64 %r36, %r39, !dbg !235
  %r41 = add i64 %r26, 0, !dbg !235
  %r42 = add i64 8, 0, !dbg !235
  %r43.shamt = and i64 %r42, 63, !dbg !235
  %r43.shbig = icmp uge i64 %r42, 64, !dbg !235
  %r43.shval = shl i64 %r41, %r43.shamt, !dbg !235
  %r43 = select i1 %r43.shbig, i64 0, i64 %r43.shval, !dbg !235
  %r44 = or i64 %r40, %r43, !dbg !235
  %r45 = add i64 %r33, 0, !dbg !235
  %r46 = or i64 %r44, %r45, !dbg !235
  ret i64 %r46, !dbg !235
}

; ESCAPE _smf_tag_eq: allocs=0 escape=0 local=0
define i64 @_smf_tag_eq(i64 %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4, i64 %p5) nounwind uwtable !dbg !236 {
entry:
  %slot.bytes_list = alloca i64, align 8, !dbg !237
  store i64 %p0, ptr %slot.bytes_list, align 8, !dbg !237
  %slot.pos = alloca i64, align 8, !dbg !237
  store i64 %p1, ptr %slot.pos, align 8, !dbg !237
  %slot.ta = alloca i64, align 8, !dbg !237
  store i64 %p2, ptr %slot.ta, align 8, !dbg !237
  %slot.tb = alloca i64, align 8, !dbg !237
  store i64 %p3, ptr %slot.tb, align 8, !dbg !237
  %slot.tc = alloca i64, align 8, !dbg !237
  store i64 %p4, ptr %slot.tc, align 8, !dbg !237
  %slot.td = alloca i64, align 8, !dbg !237
  store i64 %p5, ptr %slot.td, align 8, !dbg !237
  %slot.n = alloca i64, align 8, !dbg !237
  store i64 0, ptr %slot.n, align 8, !dbg !237
  %r0 = load i64, ptr %slot.bytes_list, align 8, !dbg !238
  %r1 = call i64 @nova_rt_len_any(i64 %r0), !dbg !238
  store i64 %r1, ptr %slot.n, align 8, !dbg !238
  %r2 = load i64, ptr %slot.pos, align 8, !dbg !239
  %r3 = add i64 3, 0, !dbg !239
  %r4 = add i64 %r2, %r3, !dbg !239
  %r5 = add i64 %r1, 0, !dbg !239
  %r6.cmp = icmp sge i64 %r4, %r5, !dbg !239
  %r6 = zext i1 %r6.cmp to i64, !dbg !239
  %br_then60 = icmp ne i64 %r6, 0, !dbg !239
  br i1 %br_then60, label %then6, label %else7, !dbg !239
then6:
  %r7 = add i64 0, 0, !dbg !240
  ret i64 %r7, !dbg !240
else7:
  br label %endif8, !dbg !240
endif8:
  %r8 = load i64, ptr %slot.bytes_list, align 8, !dbg !241
  %r9 = load i64, ptr %slot.pos, align 8, !dbg !241
  %r10 = call i64 @nova_rt_index_get(i64 %r8, i64 %r9), !dbg !241
  %r11 = load i64, ptr %slot.ta, align 8, !dbg !241
  %r12 = call i64 @nova_rt_neq(i64 %r10, i64 %r11), !dbg !241
  %br_then91 = icmp ne i64 %r12, 0, !dbg !241
  br i1 %br_then91, label %then9, label %else10, !dbg !241
then9:
  %r13 = add i64 0, 0, !dbg !242
  ret i64 %r13, !dbg !242
else10:
  br label %endif11, !dbg !242
endif11:
  %r14 = load i64, ptr %slot.bytes_list, align 8, !dbg !243
  %r15 = load i64, ptr %slot.pos, align 8, !dbg !243
  %r16 = add i64 1, 0, !dbg !243
  %r17 = add i64 %r15, %r16, !dbg !243
  %r18 = call i64 @nova_rt_index_get(i64 %r14, i64 %r17), !dbg !243
  %r19 = load i64, ptr %slot.tb, align 8, !dbg !243
  %r20 = call i64 @nova_rt_neq(i64 %r18, i64 %r19), !dbg !243
  %br_then122 = icmp ne i64 %r20, 0, !dbg !243
  br i1 %br_then122, label %then12, label %else13, !dbg !243
then12:
  %r21 = add i64 0, 0, !dbg !244
  ret i64 %r21, !dbg !244
else13:
  br label %endif14, !dbg !244
endif14:
  %r22 = load i64, ptr %slot.bytes_list, align 8, !dbg !245
  %r23 = load i64, ptr %slot.pos, align 8, !dbg !245
  %r24 = add i64 2, 0, !dbg !245
  %r25 = add i64 %r23, %r24, !dbg !245
  %r26 = call i64 @nova_rt_index_get(i64 %r22, i64 %r25), !dbg !245
  %r27 = load i64, ptr %slot.tc, align 8, !dbg !245
  %r28 = call i64 @nova_rt_neq(i64 %r26, i64 %r27), !dbg !245
  %br_then153 = icmp ne i64 %r28, 0, !dbg !245
  br i1 %br_then153, label %then15, label %else16, !dbg !245
then15:
  %r29 = add i64 0, 0, !dbg !246
  ret i64 %r29, !dbg !246
else16:
  br label %endif17, !dbg !246
endif17:
  %r30 = load i64, ptr %slot.bytes_list, align 8, !dbg !247
  %r31 = load i64, ptr %slot.pos, align 8, !dbg !247
  %r32 = add i64 3, 0, !dbg !247
  %r33 = add i64 %r31, %r32, !dbg !247
  %r34 = call i64 @nova_rt_index_get(i64 %r30, i64 %r33), !dbg !247
  %r35 = load i64, ptr %slot.td, align 8, !dbg !247
  %r36 = call i64 @nova_rt_neq(i64 %r34, i64 %r35), !dbg !247
  %br_then184 = icmp ne i64 %r36, 0, !dbg !247
  br i1 %br_then184, label %then18, label %else19, !dbg !247
then18:
  %r37 = add i64 0, 0, !dbg !248
  ret i64 %r37, !dbg !248
else19:
  br label %endif20, !dbg !248
endif20:
  %r38 = add i64 1, 0, !dbg !249
  ret i64 %r38, !dbg !249
}

; ESCAPE smf_header: allocs=1 escape=1 local=0
define i64 @smf_header(i64 %p0, i64 %p1, i64 %p2) nounwind uwtable !dbg !250 {
entry:
  %slot.format = alloca i64, align 8, !dbg !251
  store i64 %p0, ptr %slot.format, align 8, !dbg !251
  %slot.ntracks = alloca i64, align 8, !dbg !251
  store i64 %p1, ptr %slot.ntracks, align 8, !dbg !251
  %slot.division = alloca i64, align 8, !dbg !251
  store i64 %p2, ptr %slot.division, align 8, !dbg !251
  %slot.out = alloca i64, align 8, !dbg !251
  store i64 0, ptr %slot.out, align 8, !dbg !251
  %r0 = call i64 @nova_rt_list_create(), !dbg !252
  store i64 %r0, ptr %slot.out, align 8, !dbg !252
  %r1 = add i64 %r0, 0, !dbg !253
  %r2 = add i64 77, 0, !dbg !253
  %r3 = call i64 @nova_rt_list_append(i64 %r1, i64 %r2), !dbg !253
  %r4 = add i64 %r0, 0, !dbg !254
  %r5 = add i64 84, 0, !dbg !254
  %r6 = call i64 @nova_rt_list_append(i64 %r4, i64 %r5), !dbg !254
  %r7 = add i64 %r0, 0, !dbg !255
  %r8 = add i64 104, 0, !dbg !255
  %r9 = call i64 @nova_rt_list_append(i64 %r7, i64 %r8), !dbg !255
  %r10 = add i64 %r0, 0, !dbg !256
  %r11 = add i64 100, 0, !dbg !256
  %r12 = call i64 @nova_rt_list_append(i64 %r10, i64 %r11), !dbg !256
  %r13 = add i64 %r0, 0, !dbg !257
  %r14 = add i64 6, 0, !dbg !257
  %r15 = call i64 @_smf_push_u32(i64 %r13, i64 %r14), !dbg !257
  %r16 = add i64 %r0, 0, !dbg !258
  %r17 = load i64, ptr %slot.format, align 8, !dbg !258
  %r18 = call i64 @_smf_push_u16(i64 %r16, i64 %r17), !dbg !258
  %r19 = add i64 %r0, 0, !dbg !259
  %r20 = load i64, ptr %slot.ntracks, align 8, !dbg !259
  %r21 = call i64 @_smf_push_u16(i64 %r19, i64 %r20), !dbg !259
  %r22 = add i64 %r0, 0, !dbg !260
  %r23 = load i64, ptr %slot.division, align 8, !dbg !260
  %r24 = call i64 @_smf_push_u16(i64 %r22, i64 %r23), !dbg !260
  %r25 = add i64 %r0, 0, !dbg !261
  ret i64 %r25, !dbg !261
}

; ESCAPE smf_track: allocs=1 escape=1 local=0
define i64 @smf_track(i64 %p0) nounwind uwtable !dbg !262 {
entry:
  %slot.event_bytes_list = alloca i64, align 8, !dbg !263
  store i64 %p0, ptr %slot.event_bytes_list, align 8, !dbg !263
  %slot.out = alloca i64, align 8, !dbg !263
  store i64 0, ptr %slot.out, align 8, !dbg !263
  %slot.ev_len = alloca i64, align 8, !dbg !263
  store i64 0, ptr %slot.ev_len, align 8, !dbg !263
  %slot.i = alloca i64, align 8, !dbg !263
  store i64 0, ptr %slot.i, align 8, !dbg !263
  %slot.event_bytes_list__s4f148 = alloca i64, align 8, !dbg !263
  store i64 0, ptr %slot.event_bytes_list__s4f148, align 8, !dbg !263
  %r0 = call i64 @nova_rt_list_create(), !dbg !264
  store i64 %r0, ptr %slot.out, align 8, !dbg !264
  %r1 = add i64 %r0, 0, !dbg !265
  %r2 = add i64 77, 0, !dbg !265
  %r3 = call i64 @nova_rt_list_append(i64 %r1, i64 %r2), !dbg !265
  %r4 = add i64 %r0, 0, !dbg !266
  %r5 = add i64 84, 0, !dbg !266
  %r6 = call i64 @nova_rt_list_append(i64 %r4, i64 %r5), !dbg !266
  %r7 = add i64 %r0, 0, !dbg !267
  %r8 = add i64 114, 0, !dbg !267
  %r9 = call i64 @nova_rt_list_append(i64 %r7, i64 %r8), !dbg !267
  %r10 = add i64 %r0, 0, !dbg !268
  %r11 = add i64 107, 0, !dbg !268
  %r12 = call i64 @nova_rt_list_append(i64 %r10, i64 %r11), !dbg !268
  %r13 = load i64, ptr %slot.event_bytes_list, align 8, !dbg !269
  %r14 = call i64 @nova_rt_len_any(i64 %r13), !dbg !269
  store i64 %r14, ptr %slot.ev_len, align 8, !dbg !269
  %r15 = add i64 %r0, 0, !dbg !270
  %r16 = add i64 %r14, 0, !dbg !270
  %r17 = call i64 @_smf_push_u32(i64 %r15, i64 %r16), !dbg !270
  %r18 = add i64 0, 0, !dbg !271
  store i64 %r18, ptr %slot.i, align 8, !dbg !271
  %r19 = load i64, ptr %slot.event_bytes_list, align 8, !dbg !272
  %r20 = call i64 @nova_rt_list_is_kind2(i64 %r19), !dbg !272
  %br_then210 = icmp ne i64 %r20, 0, !dbg !272
  br i1 %br_then210, label %then21, label %else22, !dbg !272
then21:
  %r21 = load i64, ptr %slot.event_bytes_list, align 8, !dbg !272
  %r22 = call i64 @nova_rt_floatlist_view(i64 %r21), !dbg !272
  store i64 %r22, ptr %slot.event_bytes_list__s4f148, align 8, !dbg !272
  br label %while_hdr24, !dbg !272
while_hdr24:
  %r23 = load i64, ptr %slot.i, align 8, !dbg !272
  %r24 = load i64, ptr %slot.ev_len, align 8, !dbg !272
  %r25.cmp = icmp slt i64 %r23, %r24, !dbg !272
  %r25 = zext i1 %r25.cmp to i64, !dbg !272
  %br_while_body251 = icmp ne i64 %r25, 0, !dbg !272
  br i1 %br_while_body251, label %while_body25, label %while_exit26, !prof !90, !dbg !272
while_body25:
  %r26 = load i64, ptr %slot.out, align 8, !dbg !273
  %r27 = load i64, ptr %slot.event_bytes_list__s4f148, align 8, !dbg !273
  %r28 = load i64, ptr %slot.i, align 8, !dbg !273
  %r29 = call i64 @nova_rt_list_get_f(i64 %r27, i64 %r28), !dbg !273
  %r30 = call i64 @nova_rt_list_append_fbox(i64 %r26, i64 %r29), !dbg !273
  %r31 = load i64, ptr %slot.i, align 8, !dbg !274
  %r32 = add i64 1, 0, !dbg !274
  %r33 = add i64 %r31, %r32, !dbg !274
  store i64 %r33, ptr %slot.i, align 8, !dbg !274
  br label %while_hdr24, !dbg !274
while_exit26:
  br label %endif23, !dbg !274
else22:
  br label %while_hdr27, !dbg !272
while_hdr27:
  %r34 = load i64, ptr %slot.i, align 8, !dbg !272
  %r35 = load i64, ptr %slot.ev_len, align 8, !dbg !272
  %r36.cmp = icmp slt i64 %r34, %r35, !dbg !272
  %r36 = zext i1 %r36.cmp to i64, !dbg !272
  %br_while_body282 = icmp ne i64 %r36, 0, !dbg !272
  br i1 %br_while_body282, label %while_body28, label %while_exit29, !prof !90, !dbg !272
while_body28:
  %r37 = load i64, ptr %slot.out, align 8, !dbg !273
  %r38 = load i64, ptr %slot.event_bytes_list, align 8, !dbg !273
  %r39 = load i64, ptr %slot.i, align 8, !dbg !273
  %r40 = call i64 @nova_rt_index_get(i64 %r38, i64 %r39), !dbg !273
  %r41 = call i64 @nova_rt_list_append(i64 %r37, i64 %r40), !dbg !273
  %r42 = load i64, ptr %slot.i, align 8, !dbg !274
  %r43 = add i64 1, 0, !dbg !274
  %r44 = add i64 %r42, %r43, !dbg !274
  store i64 %r44, ptr %slot.i, align 8, !dbg !274
  br label %while_hdr27, !dbg !274
while_exit29:
  br label %endif23, !dbg !274
endif23:
  %r45 = load i64, ptr %slot.out, align 8, !dbg !275
  ret i64 %r45, !dbg !275
}

; ESCAPE smf_parse_header: allocs=1 escape=1 local=0
define i64 @smf_parse_header(i64 %p0) nounwind uwtable !dbg !276 {
entry:
  %slot.bytes_list = alloca i64, align 8, !dbg !277
  store i64 %p0, ptr %slot.bytes_list, align 8, !dbg !277
  %slot.result = alloca i64, align 8, !dbg !277
  store i64 0, ptr %slot.result, align 8, !dbg !277
  %slot.n = alloca i64, align 8, !dbg !277
  store i64 0, ptr %slot.n, align 8, !dbg !277
  %r0 = call i64 @nova_rt_dict_create(), !dbg !278
  store i64 %r0, ptr %slot.result, align 8, !dbg !278
  %r1 = load i64, ptr %slot.bytes_list, align 8, !dbg !279
  %r2 = call i64 @nova_rt_len_any(i64 %r1), !dbg !279
  store i64 %r2, ptr %slot.n, align 8, !dbg !279
  %r3 = add i64 %r2, 0, !dbg !280
  %r4 = add i64 14, 0, !dbg !280
  %r5.cmp = icmp slt i64 %r3, %r4, !dbg !280
  %r5 = zext i1 %r5.cmp to i64, !dbg !280
  %br_then300 = icmp ne i64 %r5, 0, !dbg !280
  br i1 %br_then300, label %then30, label %else31, !dbg !280
then30:
  %r7 = add i64 -1, 0, !dbg !281
  %r8 = load i64, ptr %slot.result, align 8, !dbg !281
  %r9.p = getelementptr inbounds [7 x i8], ptr @.str.0, i64 0, i64 0, !dbg !281
  %r9 = ptrtoint ptr %r9.p to i64, !dbg !281
  %_is.dv1 = call i64 @nova_rt_dict_set(i64 %r8, i64 %r9, i64 %r7), !dbg !281
  %r10 = add i64 0, 0, !dbg !282
  %r11 = load i64, ptr %slot.result, align 8, !dbg !282
  %r12.p = getelementptr inbounds [8 x i8], ptr @.str.1, i64 0, i64 0, !dbg !282
  %r12 = ptrtoint ptr %r12.p to i64, !dbg !282
  %_is.dv2 = call i64 @nova_rt_dict_set(i64 %r11, i64 %r12, i64 %r10), !dbg !282
  %r13 = add i64 0, 0, !dbg !283
  %r14 = load i64, ptr %slot.result, align 8, !dbg !283
  %r15.p = getelementptr inbounds [9 x i8], ptr @.str.2, i64 0, i64 0, !dbg !283
  %r15 = ptrtoint ptr %r15.p to i64, !dbg !283
  %_is.dv3 = call i64 @nova_rt_dict_set(i64 %r14, i64 %r15, i64 %r13), !dbg !283
  %r16 = load i64, ptr %slot.result, align 8, !dbg !284
  ret i64 %r16, !dbg !284
else31:
  br label %endif32, !dbg !284
endif32:
  %r17 = load i64, ptr %slot.bytes_list, align 8, !dbg !285
  %r18 = add i64 0, 0, !dbg !285
  %r19 = add i64 77, 0, !dbg !285
  %r20 = add i64 84, 0, !dbg !285
  %r21 = add i64 104, 0, !dbg !285
  %r22 = add i64 100, 0, !dbg !285
  %r23 = call i64 @_smf_tag_eq(i64 %r17, i64 %r18, i64 %r19, i64 %r20, i64 %r21, i64 %r22), !dbg !285
  %r24 = add i64 0, 0, !dbg !285
  %r25.cmp = icmp eq i64 %r23, %r24, !dbg !285
  %r25 = zext i1 %r25.cmp to i64, !dbg !285
  %br_then334 = icmp ne i64 %r25, 0, !dbg !285
  br i1 %br_then334, label %then33, label %else34, !dbg !285
then33:
  %r27 = add i64 -1, 0, !dbg !286
  %r28 = load i64, ptr %slot.result, align 8, !dbg !286
  %r29.p = getelementptr inbounds [7 x i8], ptr @.str.0, i64 0, i64 0, !dbg !286
  %r29 = ptrtoint ptr %r29.p to i64, !dbg !286
  %_is.dv5 = call i64 @nova_rt_dict_set(i64 %r28, i64 %r29, i64 %r27), !dbg !286
  %r30 = add i64 0, 0, !dbg !287
  %r31 = load i64, ptr %slot.result, align 8, !dbg !287
  %r32.p = getelementptr inbounds [8 x i8], ptr @.str.1, i64 0, i64 0, !dbg !287
  %r32 = ptrtoint ptr %r32.p to i64, !dbg !287
  %_is.dv6 = call i64 @nova_rt_dict_set(i64 %r31, i64 %r32, i64 %r30), !dbg !287
  %r33 = add i64 0, 0, !dbg !288
  %r34 = load i64, ptr %slot.result, align 8, !dbg !288
  %r35.p = getelementptr inbounds [9 x i8], ptr @.str.2, i64 0, i64 0, !dbg !288
  %r35 = ptrtoint ptr %r35.p to i64, !dbg !288
  %_is.dv7 = call i64 @nova_rt_dict_set(i64 %r34, i64 %r35, i64 %r33), !dbg !288
  %r36 = load i64, ptr %slot.result, align 8, !dbg !289
  ret i64 %r36, !dbg !289
else34:
  br label %endif35, !dbg !289
endif35:
  %r37 = load i64, ptr %slot.bytes_list, align 8, !dbg !290
  %r38 = add i64 8, 0, !dbg !290
  %r39 = call i64 @_smf_read_u16(i64 %r37, i64 %r38), !dbg !290
  %r40 = load i64, ptr %slot.result, align 8, !dbg !290
  %r41.p = getelementptr inbounds [7 x i8], ptr @.str.0, i64 0, i64 0, !dbg !290
  %r41 = ptrtoint ptr %r41.p to i64, !dbg !290
  %_is.dv8 = call i64 @nova_rt_dict_set(i64 %r40, i64 %r41, i64 %r39), !dbg !290
  %r42 = load i64, ptr %slot.bytes_list, align 8, !dbg !291
  %r43 = add i64 10, 0, !dbg !291
  %r44 = call i64 @_smf_read_u16(i64 %r42, i64 %r43), !dbg !291
  %r45 = load i64, ptr %slot.result, align 8, !dbg !291
  %r46.p = getelementptr inbounds [8 x i8], ptr @.str.1, i64 0, i64 0, !dbg !291
  %r46 = ptrtoint ptr %r46.p to i64, !dbg !291
  %_is.dv9 = call i64 @nova_rt_dict_set(i64 %r45, i64 %r46, i64 %r44), !dbg !291
  %r47 = load i64, ptr %slot.bytes_list, align 8, !dbg !292
  %r48 = add i64 12, 0, !dbg !292
  %r49 = call i64 @_smf_read_u16(i64 %r47, i64 %r48), !dbg !292
  %r50 = load i64, ptr %slot.result, align 8, !dbg !292
  %r51.p = getelementptr inbounds [9 x i8], ptr @.str.2, i64 0, i64 0, !dbg !292
  %r51 = ptrtoint ptr %r51.p to i64, !dbg !292
  %_is.dv10 = call i64 @nova_rt_dict_set(i64 %r50, i64 %r51, i64 %r49), !dbg !292
  %r52 = load i64, ptr %slot.result, align 8, !dbg !293
  ret i64 %r52, !dbg !293
}

; ESCAPE smf_chunk_type: allocs=0 escape=0 local=0
define i64 @smf_chunk_type(i64 %p0) nounwind uwtable !dbg !294 {
entry:
  %slot.bytes_list = alloca i64, align 8, !dbg !295
  store i64 %p0, ptr %slot.bytes_list, align 8, !dbg !295
  %slot.n = alloca i64, align 8, !dbg !295
  store i64 0, ptr %slot.n, align 8, !dbg !295
  %slot.s = alloca i64, align 8, !dbg !295
  store i64 0, ptr %slot.s, align 8, !dbg !295
  %r0 = load i64, ptr %slot.bytes_list, align 8, !dbg !296
  %r1 = call i64 @nova_rt_len_any(i64 %r0), !dbg !296
  store i64 %r1, ptr %slot.n, align 8, !dbg !296
  %r2 = add i64 %r1, 0, !dbg !297
  %r3 = add i64 4, 0, !dbg !297
  %r4.cmp = icmp slt i64 %r2, %r3, !dbg !297
  %r4 = zext i1 %r4.cmp to i64, !dbg !297
  %br_then360 = icmp ne i64 %r4, 0, !dbg !297
  br i1 %br_then360, label %then36, label %else37, !dbg !297
then36:
  %r5.p = getelementptr inbounds [2 x i8], ptr @.str.3, i64 0, i64 0, !dbg !298
  %r5 = ptrtoint ptr %r5.p to i64, !dbg !298
  ret i64 %r5, !dbg !298
else37:
  br label %endif38, !dbg !298
endif38:
  %r6.p = getelementptr inbounds [1 x i8], ptr @.str.4, i64 0, i64 0, !dbg !299
  %r6 = ptrtoint ptr %r6.p to i64, !dbg !299
  store i64 %r6, ptr %slot.s, align 8, !dbg !299
  %r7 = add i64 %r6, 0, !dbg !300
  %r8 = load i64, ptr %slot.bytes_list, align 8, !dbg !300
  %r9 = add i64 0, 0, !dbg !300
  %r10 = call i64 @nova_rt_index_get(i64 %r8, i64 %r9), !dbg !300
  %r11 = add i64 255, 0, !dbg !300
  %r12 = and i64 %r10, %r11, !dbg !300
  %r13 = call i64 @nova_rt_chr(i64 %r12), !dbg !300
  %r14 = call i64 @nova_rt_str_concat(i64 %r7, i64 %r13), !dbg !300
  store i64 %r14, ptr %slot.s, align 8, !dbg !300
  %r15 = add i64 %r14, 0, !dbg !301
  %r16 = load i64, ptr %slot.bytes_list, align 8, !dbg !301
  %r17 = add i64 1, 0, !dbg !301
  %r18 = call i64 @nova_rt_index_get(i64 %r16, i64 %r17), !dbg !301
  %r19 = add i64 255, 0, !dbg !301
  %r20 = and i64 %r18, %r19, !dbg !301
  %r21 = call i64 @nova_rt_chr(i64 %r20), !dbg !301
  %r22 = call i64 @nova_rt_str_concat(i64 %r15, i64 %r21), !dbg !301
  store i64 %r22, ptr %slot.s, align 8, !dbg !301
  %r23 = add i64 %r22, 0, !dbg !302
  %r24 = load i64, ptr %slot.bytes_list, align 8, !dbg !302
  %r25 = add i64 2, 0, !dbg !302
  %r26 = call i64 @nova_rt_index_get(i64 %r24, i64 %r25), !dbg !302
  %r27 = add i64 255, 0, !dbg !302
  %r28 = and i64 %r26, %r27, !dbg !302
  %r29 = call i64 @nova_rt_chr(i64 %r28), !dbg !302
  %r30 = call i64 @nova_rt_str_concat(i64 %r23, i64 %r29), !dbg !302
  store i64 %r30, ptr %slot.s, align 8, !dbg !302
  %r31 = add i64 %r30, 0, !dbg !303
  %r32 = load i64, ptr %slot.bytes_list, align 8, !dbg !303
  %r33 = add i64 3, 0, !dbg !303
  %r34 = call i64 @nova_rt_index_get(i64 %r32, i64 %r33), !dbg !303
  %r35 = add i64 255, 0, !dbg !303
  %r36 = and i64 %r34, %r35, !dbg !303
  %r37 = call i64 @nova_rt_chr(i64 %r36), !dbg !303
  %r38 = call i64 @nova_rt_str_concat(i64 %r31, i64 %r37), !dbg !303
  store i64 %r38, ptr %slot.s, align 8, !dbg !303
  %r39 = add i64 %r38, 0, !dbg !304
  ret i64 %r39, !dbg !304
}

; ESCAPE nova_main: allocs=0 escape=0 local=0
define i64 @nova_main() nounwind uwtable {
entry:
  ret i64 0
}

; ESCAPE SUMMARY: allocs=3 escape=3 local=0 (0% local, RC-elidable)
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
@.str.0 = private unnamed_addr constant [7 x i8] c"format\00"
@.str.1 = private unnamed_addr constant [8 x i8] c"ntracks\00"
@.str.2 = private unnamed_addr constant [9 x i8] c"division\00"
@.str.3 = private unnamed_addr constant [2 x i8] c"?\00"
@.str.4 = private unnamed_addr constant [1 x i8] c"\00"

; Debug metadata
!llvm.dbg.cu = !{!100}
!llvm.module.flags = !{!102, !103}

!100 = distinct !DICompileUnit(language: DW_LANG_C99, file: !101, producer: "NOVA Compiler", isOptimized: false, emissionKind: LineTablesOnly)
!101 = !DIFile(filename: "std/midi/smf.nova", directory: ".")
!102 = !{i32 2, !"CodeView", i32 1}
!103 = !{i32 2, !"Debug Info Version", i32 3}
!104 = !DISubroutineType(types: !105)
!105 = !{null}
!200 = distinct !DISubprogram(name: "_smf_push_u16", scope: !101, file: !101, line: 45, type: !104, scopeLine: 45, spFlags: DISPFlagDefinition, unit: !100)
!201 = !DILocation(line: 45, column: 0, scope: !200)
!207 = distinct !DISubprogram(name: "_smf_push_u32", scope: !101, file: !101, line: 53, type: !104, scopeLine: 53, spFlags: DISPFlagDefinition, unit: !100)
!208 = !DILocation(line: 53, column: 0, scope: !207)
!218 = distinct !DISubprogram(name: "_smf_read_u16", scope: !101, file: !101, line: 66, type: !104, scopeLine: 66, spFlags: DISPFlagDefinition, unit: !100)
!219 = !DILocation(line: 66, column: 0, scope: !218)
!226 = distinct !DISubprogram(name: "_smf_read_u32", scope: !101, file: !101, line: 76, type: !104, scopeLine: 76, spFlags: DISPFlagDefinition, unit: !100)
!227 = !DILocation(line: 76, column: 0, scope: !226)
!236 = distinct !DISubprogram(name: "_smf_tag_eq", scope: !101, file: !101, line: 88, type: !104, scopeLine: 88, spFlags: DISPFlagDefinition, unit: !100)
!237 = !DILocation(line: 88, column: 0, scope: !236)
!250 = distinct !DISubprogram(name: "smf_header", scope: !101, file: !101, line: 112, type: !104, scopeLine: 112, spFlags: DISPFlagDefinition, unit: !100)
!251 = !DILocation(line: 112, column: 0, scope: !250)
!262 = distinct !DISubprogram(name: "smf_track", scope: !101, file: !101, line: 136, type: !104, scopeLine: 136, spFlags: DISPFlagDefinition, unit: !100)
!263 = !DILocation(line: 136, column: 0, scope: !262)
!276 = distinct !DISubprogram(name: "smf_parse_header", scope: !101, file: !101, line: 163, type: !104, scopeLine: 163, spFlags: DISPFlagDefinition, unit: !100)
!277 = !DILocation(line: 163, column: 0, scope: !276)
!294 = distinct !DISubprogram(name: "smf_chunk_type", scope: !101, file: !101, line: 191, type: !104, scopeLine: 191, spFlags: DISPFlagDefinition, unit: !100)
!295 = !DILocation(line: 191, column: 0, scope: !294)
!202 = !DILocation(line: 46, column: 0, scope: !200)
!203 = !DILocation(line: 47, column: 0, scope: !200)
!204 = !DILocation(line: 48, column: 0, scope: !200)
!205 = !DILocation(line: 49, column: 0, scope: !200)
!206 = !DILocation(line: 50, column: 0, scope: !200)
!209 = !DILocation(line: 54, column: 0, scope: !207)
!210 = !DILocation(line: 55, column: 0, scope: !207)
!211 = !DILocation(line: 56, column: 0, scope: !207)
!212 = !DILocation(line: 57, column: 0, scope: !207)
!213 = !DILocation(line: 58, column: 0, scope: !207)
!214 = !DILocation(line: 59, column: 0, scope: !207)
!215 = !DILocation(line: 60, column: 0, scope: !207)
!216 = !DILocation(line: 61, column: 0, scope: !207)
!217 = !DILocation(line: 62, column: 0, scope: !207)
!220 = !DILocation(line: 67, column: 0, scope: !218)
!221 = !DILocation(line: 68, column: 0, scope: !218)
!222 = !DILocation(line: 69, column: 0, scope: !218)
!223 = !DILocation(line: 70, column: 0, scope: !218)
!224 = !DILocation(line: 71, column: 0, scope: !218)
!225 = !DILocation(line: 72, column: 0, scope: !218)
!228 = !DILocation(line: 77, column: 0, scope: !226)
!229 = !DILocation(line: 78, column: 0, scope: !226)
!230 = !DILocation(line: 79, column: 0, scope: !226)
!231 = !DILocation(line: 80, column: 0, scope: !226)
!232 = !DILocation(line: 81, column: 0, scope: !226)
!233 = !DILocation(line: 82, column: 0, scope: !226)
!234 = !DILocation(line: 83, column: 0, scope: !226)
!235 = !DILocation(line: 84, column: 0, scope: !226)
!238 = !DILocation(line: 89, column: 0, scope: !236)
!239 = !DILocation(line: 90, column: 0, scope: !236)
!240 = !DILocation(line: 91, column: 0, scope: !236)
!241 = !DILocation(line: 92, column: 0, scope: !236)
!242 = !DILocation(line: 93, column: 0, scope: !236)
!243 = !DILocation(line: 94, column: 0, scope: !236)
!244 = !DILocation(line: 95, column: 0, scope: !236)
!245 = !DILocation(line: 96, column: 0, scope: !236)
!246 = !DILocation(line: 97, column: 0, scope: !236)
!247 = !DILocation(line: 98, column: 0, scope: !236)
!248 = !DILocation(line: 99, column: 0, scope: !236)
!249 = !DILocation(line: 100, column: 0, scope: !236)
!252 = !DILocation(line: 113, column: 0, scope: !250)
!253 = !DILocation(line: 115, column: 0, scope: !250)
!254 = !DILocation(line: 116, column: 0, scope: !250)
!255 = !DILocation(line: 117, column: 0, scope: !250)
!256 = !DILocation(line: 118, column: 0, scope: !250)
!257 = !DILocation(line: 120, column: 0, scope: !250)
!258 = !DILocation(line: 122, column: 0, scope: !250)
!259 = !DILocation(line: 124, column: 0, scope: !250)
!260 = !DILocation(line: 126, column: 0, scope: !250)
!261 = !DILocation(line: 127, column: 0, scope: !250)
!264 = !DILocation(line: 137, column: 0, scope: !262)
!265 = !DILocation(line: 139, column: 0, scope: !262)
!266 = !DILocation(line: 140, column: 0, scope: !262)
!267 = !DILocation(line: 141, column: 0, scope: !262)
!268 = !DILocation(line: 142, column: 0, scope: !262)
!269 = !DILocation(line: 144, column: 0, scope: !262)
!270 = !DILocation(line: 145, column: 0, scope: !262)
!271 = !DILocation(line: 147, column: 0, scope: !262)
!272 = !DILocation(line: 148, column: 0, scope: !262)
!273 = !DILocation(line: 149, column: 0, scope: !262)
!274 = !DILocation(line: 150, column: 0, scope: !262)
!275 = !DILocation(line: 151, column: 0, scope: !262)
!278 = !DILocation(line: 164, column: 0, scope: !276)
!279 = !DILocation(line: 165, column: 0, scope: !276)
!280 = !DILocation(line: 167, column: 0, scope: !276)
!281 = !DILocation(line: 168, column: 0, scope: !276)
!282 = !DILocation(line: 169, column: 0, scope: !276)
!283 = !DILocation(line: 170, column: 0, scope: !276)
!284 = !DILocation(line: 171, column: 0, scope: !276)
!285 = !DILocation(line: 173, column: 0, scope: !276)
!286 = !DILocation(line: 174, column: 0, scope: !276)
!287 = !DILocation(line: 175, column: 0, scope: !276)
!288 = !DILocation(line: 176, column: 0, scope: !276)
!289 = !DILocation(line: 177, column: 0, scope: !276)
!290 = !DILocation(line: 179, column: 0, scope: !276)
!291 = !DILocation(line: 180, column: 0, scope: !276)
!292 = !DILocation(line: 181, column: 0, scope: !276)
!293 = !DILocation(line: 182, column: 0, scope: !276)
!296 = !DILocation(line: 192, column: 0, scope: !294)
!297 = !DILocation(line: 193, column: 0, scope: !294)
!298 = !DILocation(line: 194, column: 0, scope: !294)
!299 = !DILocation(line: 195, column: 0, scope: !294)
!300 = !DILocation(line: 196, column: 0, scope: !294)
!301 = !DILocation(line: 197, column: 0, scope: !294)
!302 = !DILocation(line: 198, column: 0, scope: !294)
!303 = !DILocation(line: 199, column: 0, scope: !294)
!304 = !DILocation(line: 200, column: 0, scope: !294)

; TBAA metadata
!0 = !{!"NOVA TBAA"}
!1 = !{!"list_data_ptr", !0}
!2 = !{!1, !1, i64 0}
!3 = !{!"list_elem", !0}
!4 = !{!3, !3, i64 0}
!5 = !{!"list_size", !0}
!6 = !{!5, !5, i64 0}
!90 = !{!"branch_weights", i32 2000, i32 1}
