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

; ESCAPE _mx_name_encode: allocs=0 escape=0 local=0
define i64 @_mx_name_encode(i64 %p0) nounwind uwtable !dbg !200 {
entry:
  %slot.name = alloca i64, align 8, !dbg !201
  store i64 %p0, ptr %slot.name, align 8, !dbg !201
  %slot.out = alloca i64, align 8, !dbg !201
  store i64 0, ptr %slot.out, align 8, !dbg !201
  %slot.parts = alloca i64, align 8, !dbg !201
  store i64 0, ptr %slot.parts, align 8, !dbg !201
  %slot.i = alloca i64, align 8, !dbg !201
  store i64 0, ptr %slot.i, align 8, !dbg !201
  %slot.lbl = alloca i64, align 8, !dbg !201
  store i64 0, ptr %slot.lbl, align 8, !dbg !201
  %slot.n = alloca i64, align 8, !dbg !201
  store i64 0, ptr %slot.n, align 8, !dbg !201
  %slot.__sc_6 = alloca i64, align 8, !dbg !201
  store i64 0, ptr %slot.__sc_6, align 8, !dbg !201
  %slot.j = alloca i64, align 8, !dbg !201
  store i64 0, ptr %slot.j, align 8, !dbg !201
  %r0 = add i64 0, 0, !dbg !202
  %r1 = call i64 @nova_rt_bytes_create(i64 %r0), !dbg !202
  store i64 %r1, ptr %slot.out, align 8, !dbg !202
  %r2 = load i64, ptr %slot.name, align 8, !dbg !203
  %r3 = call i64 @nova_rt_len_any(i64 %r2), !dbg !203
  %r4 = add i64 0, 0, !dbg !203
  %r5.cmp = icmp eq i64 %r3, %r4, !dbg !203
  %r5 = zext i1 %r5.cmp to i64, !dbg !203
  %br_then00 = icmp ne i64 %r5, 0, !dbg !203
  br i1 %br_then00, label %then0, label %else1, !dbg !203
then0:
  %r6 = load i64, ptr %slot.out, align 8, !dbg !204
  %r7 = add i64 0, 0, !dbg !204
  %r8 = call i64 @nova_rt_bytes_append(i64 %r6, i64 %r7), !dbg !204
  store i64 %r8, ptr %slot.out, align 8, !dbg !204
  %r9 = add i64 %r8, 0, !dbg !205
  ret i64 %r9, !dbg !205
else1:
  br label %endif2, !dbg !205
endif2:
  %r10 = load i64, ptr %slot.name, align 8, !dbg !206
  %r11.p = getelementptr inbounds [2 x i8], ptr @.str.0, i64 0, i64 0, !dbg !206
  %r11 = ptrtoint ptr %r11.p to i64, !dbg !206
  %r12 = call i64 @nova_rt_split(i64 %r10, i64 %r11), !dbg !206
  store i64 %r12, ptr %slot.parts, align 8, !dbg !206
  %r13 = add i64 0, 0, !dbg !207
  store i64 %r13, ptr %slot.i, align 8, !dbg !207
  br label %while_hdr3, !dbg !208
while_hdr3:
  %r14 = load i64, ptr %slot.i, align 8, !dbg !208
  %r15 = load i64, ptr %slot.parts, align 8, !dbg !208
  %r16.lp = inttoptr i64 %r15 to ptr, !dbg !208
  %r16.szp = getelementptr i64, ptr %r16.lp, i64 1, !dbg !208
  %r16 = load i64, ptr %r16.szp, align 8, !tbaa !6, !dbg !208
  %r17.cmp = icmp slt i64 %r14, %r16, !dbg !208
  %r17 = zext i1 %r17.cmp to i64, !dbg !208
  %br_while_body41 = icmp ne i64 %r17, 0, !dbg !208
  br i1 %br_while_body41, label %while_body4, label %while_exit5, !prof !90, !dbg !208
while_body4:
  %r18 = load i64, ptr %slot.parts, align 8, !dbg !209
  %r19 = load i64, ptr %slot.i, align 8, !dbg !209
  %r20 = call i64 @nova_rt_index_get(i64 %r18, i64 %r19), !dbg !209
  store i64 %r20, ptr %slot.lbl, align 8, !dbg !209
  %r21 = add i64 %r20, 0, !dbg !210
  %r22 = call i64 @nova_rt_len_any(i64 %r21), !dbg !210
  store i64 %r22, ptr %slot.n, align 8, !dbg !210
  %r23 = add i64 %r22, 0, !dbg !211
  %r24 = add i64 0, 0, !dbg !211
  %r25.cmp = icmp eq i64 %r23, %r24, !dbg !211
  %r25 = zext i1 %r25.cmp to i64, !dbg !211
  store i64 %r25, ptr %slot.__sc_6, align 8, !dbg !211
  %br_or_merge82 = icmp ne i64 %r25, 0, !dbg !211
  br i1 %br_or_merge82, label %or_merge8, label %or_rhs7, !dbg !211
or_rhs7:
  %r26 = load i64, ptr %slot.n, align 8, !dbg !211
  %r27 = add i64 63, 0, !dbg !211
  %r28.cmp = icmp sgt i64 %r26, %r27, !dbg !211
  %r28 = zext i1 %r28.cmp to i64, !dbg !211
  store i64 %r28, ptr %slot.__sc_6, align 8, !dbg !211
  br label %or_merge8, !dbg !211
or_merge8:
  %r29 = load i64, ptr %slot.__sc_6, align 8, !dbg !211
  %br_then93 = icmp ne i64 %r29, 0, !dbg !211
  br i1 %br_then93, label %then9, label %else10, !dbg !211
then9:
  %r30 = add i64 0, 0, !dbg !212
  %r31 = call i64 @nova_rt_bytes_create(i64 %r30), !dbg !212
  ret i64 %r31, !dbg !212
else10:
  br label %endif11, !dbg !212
endif11:
  %r32 = load i64, ptr %slot.out, align 8, !dbg !213
  %r33 = load i64, ptr %slot.n, align 8, !dbg !213
  %r34 = call i64 @nova_rt_bytes_append(i64 %r32, i64 %r33), !dbg !213
  store i64 %r34, ptr %slot.out, align 8, !dbg !213
  %r35 = add i64 0, 0, !dbg !214
  store i64 %r35, ptr %slot.j, align 8, !dbg !214
  br label %while_hdr12, !dbg !215
while_hdr12:
  %r36 = load i64, ptr %slot.j, align 8, !dbg !215
  %r37 = load i64, ptr %slot.n, align 8, !dbg !215
  %r38.cmp = icmp slt i64 %r36, %r37, !dbg !215
  %r38 = zext i1 %r38.cmp to i64, !dbg !215
  %br_while_body134 = icmp ne i64 %r38, 0, !dbg !215
  br i1 %br_while_body134, label %while_body13, label %while_exit14, !prof !90, !dbg !215
while_body13:
  %r39 = load i64, ptr %slot.out, align 8, !dbg !216
  %r40 = load i64, ptr %slot.lbl, align 8, !dbg !216
  %r41 = load i64, ptr %slot.j, align 8, !dbg !216
  %r42 = call i64 @nova_rt_char_at(i64 %r40, i64 %r41), !dbg !216
  %r43 = call i64 @nova_rt_ord(i64 %r42), !dbg !216
  %r44 = call i64 @nova_rt_bytes_append(i64 %r39, i64 %r43), !dbg !216
  store i64 %r44, ptr %slot.out, align 8, !dbg !216
  %r45 = load i64, ptr %slot.j, align 8, !dbg !217
  %r46 = add i64 1, 0, !dbg !217
  %r47 = add i64 %r45, %r46, !dbg !217
  store i64 %r47, ptr %slot.j, align 8, !dbg !217
  br label %while_hdr12, !dbg !217
while_exit14:
  %r48 = load i64, ptr %slot.i, align 8, !dbg !218
  %r49 = add i64 1, 0, !dbg !218
  %r50 = add i64 %r48, %r49, !dbg !218
  store i64 %r50, ptr %slot.i, align 8, !dbg !218
  br label %while_hdr3, !dbg !218
while_exit5:
  %r51 = load i64, ptr %slot.out, align 8, !dbg !219
  %r52 = add i64 0, 0, !dbg !219
  %r53 = call i64 @nova_rt_bytes_append(i64 %r51, i64 %r52), !dbg !219
  store i64 %r53, ptr %slot.out, align 8, !dbg !219
  %r54 = add i64 %r53, 0, !dbg !220
  ret i64 %r54, !dbg !220
}

; ESCAPE _mx_name_decode: allocs=6 escape=6 local=0
define i64 @_mx_name_decode(i64 %p0, i64 %p1) nounwind uwtable !dbg !221 {
entry:
  %slot.msg = alloca i64, align 8, !dbg !222
  store i64 %p0, ptr %slot.msg, align 8, !dbg !222
  %slot.pos = alloca i64, align 8, !dbg !222
  store i64 %p1, ptr %slot.pos, align 8, !dbg !222
  %slot.mlen = alloca i64, align 8, !dbg !222
  store i64 0, ptr %slot.mlen, align 8, !dbg !222
  %slot.name = alloca i64, align 8, !dbg !222
  store i64 0, ptr %slot.name, align 8, !dbg !222
  %slot.cur = alloca i64, align 8, !dbg !222
  store i64 0, ptr %slot.cur, align 8, !dbg !222
  %slot.jumps = alloca i64, align 8, !dbg !222
  store i64 0, ptr %slot.jumps, align 8, !dbg !222
  %slot.jumped = alloca i64, align 8, !dbg !222
  store i64 0, ptr %slot.jumped, align 8, !dbg !222
  %slot.final_pos = alloca i64, align 8, !dbg !222
  store i64 0, ptr %slot.final_pos, align 8, !dbg !222
  %slot.b0 = alloca i64, align 8, !dbg !222
  store i64 0, ptr %slot.b0, align 8, !dbg !222
  %slot.b1 = alloca i64, align 8, !dbg !222
  store i64 0, ptr %slot.b1, align 8, !dbg !222
  %slot.offset = alloca i64, align 8, !dbg !222
  store i64 0, ptr %slot.offset, align 8, !dbg !222
  %slot.ln = alloca i64, align 8, !dbg !222
  store i64 0, ptr %slot.ln, align 8, !dbg !222
  %slot.lend = alloca i64, align 8, !dbg !222
  store i64 0, ptr %slot.lend, align 8, !dbg !222
  %slot.lbl = alloca i64, align 8, !dbg !222
  store i64 0, ptr %slot.lbl, align 8, !dbg !222
  %slot.i = alloca i64, align 8, !dbg !222
  store i64 0, ptr %slot.i, align 8, !dbg !222
  %r0 = load i64, ptr %slot.msg, align 8, !dbg !223
  %r1 = call i64 @nova_rt_bytes_len(i64 %r0), !dbg !223
  store i64 %r1, ptr %slot.mlen, align 8, !dbg !223
  %r2.p = getelementptr inbounds [1 x i8], ptr @.str.1, i64 0, i64 0, !dbg !224
  %r2 = ptrtoint ptr %r2.p to i64, !dbg !224
  store i64 %r2, ptr %slot.name, align 8, !dbg !224
  %r3 = load i64, ptr %slot.pos, align 8, !dbg !225
  store i64 %r3, ptr %slot.cur, align 8, !dbg !225
  %r4 = add i64 0, 0, !dbg !226
  store i64 %r4, ptr %slot.jumps, align 8, !dbg !226
  %r5 = add i64 0, 0, !dbg !227
  store i64 %r5, ptr %slot.jumped, align 8, !dbg !227
  %r6 = load i64, ptr %slot.pos, align 8, !dbg !228
  store i64 %r6, ptr %slot.final_pos, align 8, !dbg !228
  br label %while_hdr15, !dbg !229
while_hdr15:
  br label %while_body16, !dbg !229
while_body16:
  %r8 = load i64, ptr %slot.cur, align 8, !dbg !230
  %r9 = load i64, ptr %slot.mlen, align 8, !dbg !230
  %r10 = call i64 @nova_rt_ge(i64 %r8, i64 %r9), !dbg !230
  %br_then180 = icmp ne i64 %r10, 0, !dbg !230
  br i1 %br_then180, label %then18, label %else19, !dbg !230
then18:
  %r12.p = getelementptr inbounds [1 x i8], ptr @.str.1, i64 0, i64 0, !dbg !231
  %r12 = ptrtoint ptr %r12.p to i64, !dbg !231
  %r13 = load i64, ptr %slot.pos, align 8, !dbg !231
  %r11 = call i64 @nova_rt_list_create(), !dbg !231
  call i64 @nova_rt_list_append(i64 %r11, i64 %r12), !dbg !231
  call i64 @nova_rt_list_append(i64 %r11, i64 %r13), !dbg !231
  ret i64 %r11, !dbg !231
else19:
  br label %endif20, !dbg !231
endif20:
  %r14 = load i64, ptr %slot.msg, align 8, !dbg !232
  %r15 = load i64, ptr %slot.cur, align 8, !dbg !232
  %r16 = call i64 @nova_rt_bytes_get(i64 %r14, i64 %r15), !dbg !232
  store i64 %r16, ptr %slot.b0, align 8, !dbg !232
  %r17 = add i64 %r16, 0, !dbg !233
  %r18 = add i64 192, 0, !dbg !233
  %r19 = and i64 %r17, %r18, !dbg !233
  %r20 = add i64 192, 0, !dbg !233
  %r21 = call i64 @nova_rt_eq(i64 %r19, i64 %r20), !dbg !233
  %br_then211 = icmp ne i64 %r21, 0, !dbg !233
  br i1 %br_then211, label %then21, label %else22, !dbg !233
then21:
  %r22 = load i64, ptr %slot.cur, align 8, !dbg !234
  %r23 = add i64 1, 0, !dbg !234
  %r24 = call i64 @nova_rt_add(i64 %r22, i64 %r23), !dbg !234
  %r25 = load i64, ptr %slot.mlen, align 8, !dbg !234
  %r26 = call i64 @nova_rt_ge(i64 %r24, i64 %r25), !dbg !234
  %br_then242 = icmp ne i64 %r26, 0, !dbg !234
  br i1 %br_then242, label %then24, label %else25, !dbg !234
then24:
  %r28.p = getelementptr inbounds [1 x i8], ptr @.str.1, i64 0, i64 0, !dbg !235
  %r28 = ptrtoint ptr %r28.p to i64, !dbg !235
  %r29 = load i64, ptr %slot.pos, align 8, !dbg !235
  %r27 = call i64 @nova_rt_list_create(), !dbg !235
  call i64 @nova_rt_list_append(i64 %r27, i64 %r28), !dbg !235
  call i64 @nova_rt_list_append(i64 %r27, i64 %r29), !dbg !235
  ret i64 %r27, !dbg !235
else25:
  br label %endif26, !dbg !235
endif26:
  %r30 = load i64, ptr %slot.msg, align 8, !dbg !236
  %r31 = load i64, ptr %slot.cur, align 8, !dbg !236
  %r32 = add i64 1, 0, !dbg !236
  %r33 = call i64 @nova_rt_add(i64 %r31, i64 %r32), !dbg !236
  %r34 = call i64 @nova_rt_bytes_get(i64 %r30, i64 %r33), !dbg !236
  store i64 %r34, ptr %slot.b1, align 8, !dbg !236
  %r35 = load i64, ptr %slot.b0, align 8, !dbg !237
  %r36 = add i64 63, 0, !dbg !237
  %r37 = and i64 %r35, %r36, !dbg !237
  %r38 = add i64 8, 0, !dbg !237
  %r39.shamt = and i64 %r38, 63, !dbg !237
  %r39.shbig = icmp uge i64 %r38, 64, !dbg !237
  %r39.shval = shl i64 %r37, %r39.shamt, !dbg !237
  %r39 = select i1 %r39.shbig, i64 0, i64 %r39.shval, !dbg !237
  %r40 = add i64 %r34, 0, !dbg !237
  %r41 = or i64 %r39, %r40, !dbg !237
  store i64 %r41, ptr %slot.offset, align 8, !dbg !237
  %r42 = load i64, ptr %slot.jumped, align 8, !dbg !238
  %r43 = add i64 0, 0, !dbg !238
  %r44 = call i64 @nova_rt_eq(i64 %r42, i64 %r43), !dbg !238
  %br_then273 = icmp ne i64 %r44, 0, !dbg !238
  br i1 %br_then273, label %then27, label %else28, !dbg !238
then27:
  %r45 = load i64, ptr %slot.cur, align 8, !dbg !239
  %r46 = add i64 2, 0, !dbg !239
  %r47 = call i64 @nova_rt_add(i64 %r45, i64 %r46), !dbg !239
  store i64 %r47, ptr %slot.final_pos, align 8, !dbg !239
  br label %endif29, !dbg !239
else28:
  br label %endif29, !dbg !239
endif29:
  %r48 = add i64 1, 0, !dbg !240
  store i64 %r48, ptr %slot.jumped, align 8, !dbg !240
  %r49 = load i64, ptr %slot.jumps, align 8, !dbg !241
  %r50 = add i64 1, 0, !dbg !241
  %r51 = add i64 %r49, %r50, !dbg !241
  store i64 %r51, ptr %slot.jumps, align 8, !dbg !241
  %r52 = add i64 %r51, 0, !dbg !242
  %r53 = add i64 128, 0, !dbg !242
  %r54.cmp = icmp sgt i64 %r52, %r53, !dbg !242
  %r54 = zext i1 %r54.cmp to i64, !dbg !242
  %br_then304 = icmp ne i64 %r54, 0, !dbg !242
  br i1 %br_then304, label %then30, label %else31, !dbg !242
then30:
  %r56.p = getelementptr inbounds [1 x i8], ptr @.str.1, i64 0, i64 0, !dbg !243
  %r56 = ptrtoint ptr %r56.p to i64, !dbg !243
  %r57 = load i64, ptr %slot.pos, align 8, !dbg !243
  %r55 = call i64 @nova_rt_list_create(), !dbg !243
  call i64 @nova_rt_list_append(i64 %r55, i64 %r56), !dbg !243
  call i64 @nova_rt_list_append(i64 %r55, i64 %r57), !dbg !243
  ret i64 %r55, !dbg !243
else31:
  br label %endif32, !dbg !243
endif32:
  %r58 = load i64, ptr %slot.offset, align 8, !dbg !244
  store i64 %r58, ptr %slot.cur, align 8, !dbg !244
  br label %endif23, !dbg !244
else22:
  %r59 = load i64, ptr %slot.b0, align 8, !dbg !245
  %r60 = add i64 255, 0, !dbg !245
  %r61 = and i64 %r59, %r60, !dbg !245
  store i64 %r61, ptr %slot.ln, align 8, !dbg !245
  %r62 = add i64 %r61, 0, !dbg !246
  %r63 = add i64 0, 0, !dbg !246
  %r64 = call i64 @nova_rt_eq(i64 %r62, i64 %r63), !dbg !246
  %br_then335 = icmp ne i64 %r64, 0, !dbg !246
  br i1 %br_then335, label %then33, label %else34, !dbg !246
then33:
  %r65 = load i64, ptr %slot.jumped, align 8, !dbg !247
  %r66 = add i64 0, 0, !dbg !247
  %r67 = call i64 @nova_rt_eq(i64 %r65, i64 %r66), !dbg !247
  %br_then366 = icmp ne i64 %r67, 0, !dbg !247
  br i1 %br_then366, label %then36, label %else37, !dbg !247
then36:
  %r68 = load i64, ptr %slot.cur, align 8, !dbg !248
  %r69 = add i64 1, 0, !dbg !248
  %r70 = call i64 @nova_rt_add(i64 %r68, i64 %r69), !dbg !248
  store i64 %r70, ptr %slot.final_pos, align 8, !dbg !248
  br label %endif38, !dbg !248
else37:
  br label %endif38, !dbg !248
endif38:
  %r72 = load i64, ptr %slot.name, align 8, !dbg !249
  %r73 = load i64, ptr %slot.final_pos, align 8, !dbg !249
  %r71 = call i64 @nova_rt_list_create(), !dbg !249
  call i64 @nova_rt_list_append(i64 %r71, i64 %r72), !dbg !249
  call i64 @nova_rt_list_append(i64 %r71, i64 %r73), !dbg !249
  ret i64 %r71, !dbg !249
else34:
  br label %endif35, !dbg !249
endif35:
  %r74 = load i64, ptr %slot.ln, align 8, !dbg !250
  %r75 = add i64 63, 0, !dbg !250
  %r76 = call i64 @nova_rt_gt(i64 %r74, i64 %r75), !dbg !250
  %br_then397 = icmp ne i64 %r76, 0, !dbg !250
  br i1 %br_then397, label %then39, label %else40, !dbg !250
then39:
  %r78.p = getelementptr inbounds [1 x i8], ptr @.str.1, i64 0, i64 0, !dbg !251
  %r78 = ptrtoint ptr %r78.p to i64, !dbg !251
  %r79 = load i64, ptr %slot.pos, align 8, !dbg !251
  %r77 = call i64 @nova_rt_list_create(), !dbg !251
  call i64 @nova_rt_list_append(i64 %r77, i64 %r78), !dbg !251
  call i64 @nova_rt_list_append(i64 %r77, i64 %r79), !dbg !251
  ret i64 %r77, !dbg !251
else40:
  br label %endif41, !dbg !251
endif41:
  %r80 = load i64, ptr %slot.cur, align 8, !dbg !252
  %r81 = add i64 1, 0, !dbg !252
  %r82 = call i64 @nova_rt_add(i64 %r80, i64 %r81), !dbg !252
  %r83 = load i64, ptr %slot.ln, align 8, !dbg !252
  %r84 = call i64 @nova_rt_add(i64 %r82, i64 %r83), !dbg !252
  %r85 = load i64, ptr %slot.mlen, align 8, !dbg !252
  %r86 = call i64 @nova_rt_gt(i64 %r84, i64 %r85), !dbg !252
  %br_then428 = icmp ne i64 %r86, 0, !dbg !252
  br i1 %br_then428, label %then42, label %else43, !dbg !252
then42:
  %r88.p = getelementptr inbounds [1 x i8], ptr @.str.1, i64 0, i64 0, !dbg !253
  %r88 = ptrtoint ptr %r88.p to i64, !dbg !253
  %r89 = load i64, ptr %slot.pos, align 8, !dbg !253
  %r87 = call i64 @nova_rt_list_create(), !dbg !253
  call i64 @nova_rt_list_append(i64 %r87, i64 %r88), !dbg !253
  call i64 @nova_rt_list_append(i64 %r87, i64 %r89), !dbg !253
  ret i64 %r87, !dbg !253
else43:
  br label %endif44, !dbg !253
endif44:
  %r90 = load i64, ptr %slot.cur, align 8, !dbg !254
  %r91 = add i64 1, 0, !dbg !254
  %r92 = call i64 @nova_rt_add(i64 %r90, i64 %r91), !dbg !254
  %r93 = load i64, ptr %slot.ln, align 8, !dbg !254
  %r94 = call i64 @nova_rt_add(i64 %r92, i64 %r93), !dbg !254
  store i64 %r94, ptr %slot.lend, align 8, !dbg !254
  %r95.p = getelementptr inbounds [1 x i8], ptr @.str.1, i64 0, i64 0, !dbg !255
  %r95 = ptrtoint ptr %r95.p to i64, !dbg !255
  store i64 %r95, ptr %slot.lbl, align 8, !dbg !255
  %r96 = load i64, ptr %slot.cur, align 8, !dbg !256
  %r97 = add i64 1, 0, !dbg !256
  %r98 = call i64 @nova_rt_add(i64 %r96, i64 %r97), !dbg !256
  store i64 %r98, ptr %slot.i, align 8, !dbg !256
  br label %while_hdr45, !dbg !257
while_hdr45:
  %r99 = load i64, ptr %slot.i, align 8, !dbg !257
  %r100 = load i64, ptr %slot.lend, align 8, !dbg !257
  %r101 = call i64 @nova_rt_lt(i64 %r99, i64 %r100), !dbg !257
  %br_while_body469 = icmp ne i64 %r101, 0, !dbg !257
  br i1 %br_while_body469, label %while_body46, label %while_exit47, !prof !90, !dbg !257
while_body46:
  %r102 = load i64, ptr %slot.lbl, align 8, !dbg !258
  %r103 = load i64, ptr %slot.msg, align 8, !dbg !258
  %r104 = load i64, ptr %slot.i, align 8, !dbg !258
  %r105 = call i64 @nova_rt_bytes_get(i64 %r103, i64 %r104), !dbg !258
  %r106 = call i64 @nova_rt_chr(i64 %r105), !dbg !258
  %r107 = call i64 @nova_rt_str_concat(i64 %r102, i64 %r106), !dbg !258
  store i64 %r107, ptr %slot.lbl, align 8, !dbg !258
  %r108 = load i64, ptr %slot.i, align 8, !dbg !259
  %r109 = add i64 1, 0, !dbg !259
  %r110 = call i64 @nova_rt_add(i64 %r108, i64 %r109), !dbg !259
  store i64 %r110, ptr %slot.i, align 8, !dbg !259
  br label %while_hdr45, !dbg !259
while_exit47:
  %r111 = load i64, ptr %slot.name, align 8, !dbg !260
  %r112 = call i64 @nova_rt_len_any(i64 %r111), !dbg !260
  %r113 = add i64 0, 0, !dbg !260
  %r114.cmp = icmp eq i64 %r112, %r113, !dbg !260
  %r114 = zext i1 %r114.cmp to i64, !dbg !260
  %br_then4810 = icmp ne i64 %r114, 0, !dbg !260
  br i1 %br_then4810, label %then48, label %else49, !dbg !260
then48:
  %r115 = load i64, ptr %slot.lbl, align 8, !dbg !261
  store i64 %r115, ptr %slot.name, align 8, !dbg !261
  br label %endif50, !dbg !261
else49:
  %r116 = load i64, ptr %slot.name, align 8, !dbg !262
  %r117.p = getelementptr inbounds [2 x i8], ptr @.str.0, i64 0, i64 0, !dbg !262
  %r117 = ptrtoint ptr %r117.p to i64, !dbg !262
  %r118 = call i64 @nova_rt_str_concat(i64 %r116, i64 %r117), !dbg !262
  %r119 = load i64, ptr %slot.lbl, align 8, !dbg !262
  %r120 = call i64 @nova_rt_str_concat(i64 %r118, i64 %r119), !dbg !262
  store i64 %r120, ptr %slot.name, align 8, !dbg !262
  br label %endif50, !dbg !262
endif50:
  %r121 = load i64, ptr %slot.lend, align 8, !dbg !263
  store i64 %r121, ptr %slot.cur, align 8, !dbg !263
  br label %endif23, !dbg !263
endif23:
  br label %while_hdr15, !dbg !263
}

; ESCAPE dns_mx_encode: allocs=0 escape=0 local=0
define i64 @dns_mx_encode(i64 %p0, i64 %p1) nounwind uwtable !dbg !264 {
entry:
  %slot.pref = alloca i64, align 8, !dbg !265
  store i64 %p0, ptr %slot.pref, align 8, !dbg !265
  %slot.exchange = alloca i64, align 8, !dbg !265
  store i64 %p1, ptr %slot.exchange, align 8, !dbg !265
  %slot.out = alloca i64, align 8, !dbg !265
  store i64 0, ptr %slot.out, align 8, !dbg !265
  %slot.name_bytes = alloca i64, align 8, !dbg !265
  store i64 0, ptr %slot.name_bytes, align 8, !dbg !265
  %slot.__sc_51 = alloca i64, align 8, !dbg !265
  store i64 0, ptr %slot.__sc_51, align 8, !dbg !265
  %r0 = add i64 0, 0, !dbg !266
  %r1 = call i64 @nova_rt_bytes_create(i64 %r0), !dbg !266
  store i64 %r1, ptr %slot.out, align 8, !dbg !266
  %r2 = add i64 %r1, 0, !dbg !267
  %r3 = load i64, ptr %slot.pref, align 8, !dbg !267
  %r4 = add i64 8, 0, !dbg !267
  %r5.sramt = and i64 %r4, 63, !dbg !267
  %r5.srbig = icmp uge i64 %r4, 64, !dbg !267
  %r5.srval = ashr i64 %r3, %r5.sramt, !dbg !267
  %r5.srext = ashr i64 %r3, 63, !dbg !267
  %r5 = select i1 %r5.srbig, i64 %r5.srext, i64 %r5.srval, !dbg !267
  %r6 = add i64 255, 0, !dbg !267
  %r7 = and i64 %r5, %r6, !dbg !267
  %r8 = call i64 @nova_rt_bytes_append(i64 %r2, i64 %r7), !dbg !267
  store i64 %r8, ptr %slot.out, align 8, !dbg !267
  %r9 = add i64 %r8, 0, !dbg !268
  %r10 = load i64, ptr %slot.pref, align 8, !dbg !268
  %r11 = add i64 255, 0, !dbg !268
  %r12 = and i64 %r10, %r11, !dbg !268
  %r13 = call i64 @nova_rt_bytes_append(i64 %r9, i64 %r12), !dbg !268
  store i64 %r13, ptr %slot.out, align 8, !dbg !268
  %r14 = load i64, ptr %slot.exchange, align 8, !dbg !269
  %r15 = call i64 @_mx_name_encode(i64 %r14), !dbg !269
  store i64 %r15, ptr %slot.name_bytes, align 8, !dbg !269
  %r16 = add i64 %r15, 0, !dbg !270
  %r17 = call i64 @nova_rt_bytes_len(i64 %r16), !dbg !270
  %r18 = add i64 0, 0, !dbg !270
  %r19.cmp = icmp eq i64 %r17, %r18, !dbg !270
  %r19 = zext i1 %r19.cmp to i64, !dbg !270
  store i64 %r19, ptr %slot.__sc_51, align 8, !dbg !270
  %br_and_rhs520 = icmp ne i64 %r19, 0, !dbg !270
  br i1 %br_and_rhs520, label %and_rhs52, label %and_merge53, !dbg !270
and_rhs52:
  %r20 = load i64, ptr %slot.exchange, align 8, !dbg !270
  %r21 = call i64 @nova_rt_len_any(i64 %r20), !dbg !270
  %r22 = add i64 0, 0, !dbg !270
  %r23.cmp = icmp sgt i64 %r21, %r22, !dbg !270
  %r23 = zext i1 %r23.cmp to i64, !dbg !270
  store i64 %r23, ptr %slot.__sc_51, align 8, !dbg !270
  br label %and_merge53, !dbg !270
and_merge53:
  %r24 = load i64, ptr %slot.__sc_51, align 8, !dbg !270
  %br_then541 = icmp ne i64 %r24, 0, !dbg !270
  br i1 %br_then541, label %then54, label %else55, !dbg !270
then54:
  %r25 = add i64 0, 0, !dbg !271
  %r26 = call i64 @nova_rt_bytes_create(i64 %r25), !dbg !271
  ret i64 %r26, !dbg !271
else55:
  br label %endif56, !dbg !271
endif56:
  %r27 = load i64, ptr %slot.out, align 8, !dbg !272
  %r28 = load i64, ptr %slot.name_bytes, align 8, !dbg !272
  %r29 = call i64 @nova_rt_bytes_concat(i64 %r27, i64 %r28), !dbg !272
  store i64 %r29, ptr %slot.out, align 8, !dbg !272
  %r30 = add i64 %r29, 0, !dbg !273
  ret i64 %r30, !dbg !273
}

; ESCAPE dns_mx_decode: allocs=6 escape=4 local=2
define i64 @dns_mx_decode(i64 %p0, i64 %p1, i64 %p2) nounwind uwtable !dbg !274 {
entry:
  %slot.msg = alloca i64, align 8, !dbg !275
  store i64 %p0, ptr %slot.msg, align 8, !dbg !275
  %slot.pos = alloca i64, align 8, !dbg !275
  store i64 %p1, ptr %slot.pos, align 8, !dbg !275
  %slot.rdlength = alloca i64, align 8, !dbg !275
  store i64 %p2, ptr %slot.rdlength, align 8, !dbg !275
  %slot.mlen = alloca i64, align 8, !dbg !275
  store i64 0, ptr %slot.mlen, align 8, !dbg !275
  %slot.empty = alloca i64, align 8, !dbg !275
  store i64 0, ptr %slot.empty, align 8, !dbg !275
  %slot.limit = alloca i64, align 8, !dbg !275
  store i64 0, ptr %slot.limit, align 8, !dbg !275
  %slot.hi = alloca i64, align 8, !dbg !275
  store i64 0, ptr %slot.hi, align 8, !dbg !275
  %slot.lo = alloca i64, align 8, !dbg !275
  store i64 0, ptr %slot.lo, align 8, !dbg !275
  %slot.pref = alloca i64, align 8, !dbg !275
  store i64 0, ptr %slot.pref, align 8, !dbg !275
  %slot.name_pos = alloca i64, align 8, !dbg !275
  store i64 0, ptr %slot.name_pos, align 8, !dbg !275
  %slot.nd = alloca i64, align 8, !dbg !275
  store i64 0, ptr %slot.nd, align 8, !dbg !275
  %slot.exchange = alloca i64, align 8, !dbg !275
  store i64 0, ptr %slot.exchange, align 8, !dbg !275
  %slot.next_pos = alloca i64, align 8, !dbg !275
  store i64 0, ptr %slot.next_pos, align 8, !dbg !275
  %slot.__sc_63 = alloca i64, align 8, !dbg !275
  store i64 0, ptr %slot.__sc_63, align 8, !dbg !275
  %slot.rec = alloca i64, align 8, !dbg !275
  store i64 0, ptr %slot.rec, align 8, !dbg !275
  %r0 = load i64, ptr %slot.msg, align 8, !dbg !276
  %r1 = call i64 @nova_rt_bytes_len(i64 %r0), !dbg !276
  store i64 %r1, ptr %slot.mlen, align 8, !dbg !276
  %r2 = call i64 @nova_rt_dict_create(), !dbg !277
  %r3.p = getelementptr inbounds [5 x i8], ptr @.str.2, i64 0, i64 0, !dbg !277
  %r3 = ptrtoint ptr %r3.p to i64, !dbg !277
  %r4 = add i64 0, 0, !dbg !277
  call i64 @nova_rt_dict_set_no_rc(i64 %r2, i64 %r3, i64 %r4), !dbg !277
  %r5.p = getelementptr inbounds [9 x i8], ptr @.str.3, i64 0, i64 0, !dbg !277
  %r5 = ptrtoint ptr %r5.p to i64, !dbg !277
  %r6.p = getelementptr inbounds [1 x i8], ptr @.str.1, i64 0, i64 0, !dbg !277
  %r6 = ptrtoint ptr %r6.p to i64, !dbg !277
  call i64 @nova_rt_dict_set_no_rc(i64 %r2, i64 %r5, i64 %r6), !dbg !277
  store i64 %r2, ptr %slot.empty, align 8, !dbg !277
  %r7 = load i64, ptr %slot.rdlength, align 8, !dbg !278
  %r8 = add i64 3, 0, !dbg !278
  %r9.cmp = icmp slt i64 %r7, %r8, !dbg !278
  %r9 = zext i1 %r9.cmp to i64, !dbg !278
  %br_then570 = icmp ne i64 %r9, 0, !dbg !278
  br i1 %br_then570, label %then57, label %else58, !dbg !278
then57:
  %r11 = load i64, ptr %slot.empty, align 8, !dbg !279
  %r12 = load i64, ptr %slot.pos, align 8, !dbg !279
  %r10 = call i64 @nova_rt_list_create(), !dbg !279
  call i64 @nova_rt_list_append(i64 %r10, i64 %r11), !dbg !279
  call i64 @nova_rt_list_append(i64 %r10, i64 %r12), !dbg !279
  ret i64 %r10, !dbg !279
else58:
  br label %endif59, !dbg !279
endif59:
  %r13 = load i64, ptr %slot.pos, align 8, !dbg !280
  %r14 = load i64, ptr %slot.rdlength, align 8, !dbg !280
  %r15 = add i64 %r13, %r14, !dbg !280
  %r16 = load i64, ptr %slot.mlen, align 8, !dbg !280
  %r17.cmp = icmp sgt i64 %r15, %r16, !dbg !280
  %r17 = zext i1 %r17.cmp to i64, !dbg !280
  %br_then601 = icmp ne i64 %r17, 0, !dbg !280
  br i1 %br_then601, label %then60, label %else61, !dbg !280
then60:
  %r19 = load i64, ptr %slot.empty, align 8, !dbg !281
  %r20 = load i64, ptr %slot.pos, align 8, !dbg !281
  %r18 = call i64 @nova_rt_list_create(), !dbg !281
  call i64 @nova_rt_list_append(i64 %r18, i64 %r19), !dbg !281
  call i64 @nova_rt_list_append(i64 %r18, i64 %r20), !dbg !281
  ret i64 %r18, !dbg !281
else61:
  br label %endif62, !dbg !281
endif62:
  %r21 = load i64, ptr %slot.pos, align 8, !dbg !282
  %r22 = load i64, ptr %slot.rdlength, align 8, !dbg !282
  %r23 = add i64 %r21, %r22, !dbg !282
  store i64 %r23, ptr %slot.limit, align 8, !dbg !282
  %r24 = load i64, ptr %slot.msg, align 8, !dbg !283
  %r25 = load i64, ptr %slot.pos, align 8, !dbg !283
  %r26 = call i64 @nova_rt_bytes_get(i64 %r24, i64 %r25), !dbg !283
  store i64 %r26, ptr %slot.hi, align 8, !dbg !283
  %r27 = load i64, ptr %slot.msg, align 8, !dbg !284
  %r28 = load i64, ptr %slot.pos, align 8, !dbg !284
  %r29 = add i64 1, 0, !dbg !284
  %r30 = add i64 %r28, %r29, !dbg !284
  %r31 = call i64 @nova_rt_bytes_get(i64 %r27, i64 %r30), !dbg !284
  store i64 %r31, ptr %slot.lo, align 8, !dbg !284
  %r32 = add i64 %r26, 0, !dbg !285
  %r33 = add i64 8, 0, !dbg !285
  %r34.shamt = and i64 %r33, 63, !dbg !285
  %r34.shbig = icmp uge i64 %r33, 64, !dbg !285
  %r34.shval = shl i64 %r32, %r34.shamt, !dbg !285
  %r34 = select i1 %r34.shbig, i64 0, i64 %r34.shval, !dbg !285
  %r35 = add i64 %r31, 0, !dbg !285
  %r36 = or i64 %r34, %r35, !dbg !285
  store i64 %r36, ptr %slot.pref, align 8, !dbg !285
  %r37 = load i64, ptr %slot.pos, align 8, !dbg !286
  %r38 = add i64 2, 0, !dbg !286
  %r39 = add i64 %r37, %r38, !dbg !286
  store i64 %r39, ptr %slot.name_pos, align 8, !dbg !286
  %r40 = load i64, ptr %slot.msg, align 8, !dbg !287
  %r41 = add i64 %r39, 0, !dbg !287
  %r42 = call i64 @_mx_name_decode(i64 %r40, i64 %r41), !dbg !287
  store i64 %r42, ptr %slot.nd, align 8, !dbg !287
  %r43 = add i64 %r42, 0, !dbg !288
  %r44 = add i64 0, 0, !dbg !288
  %r45 = call i64 @nova_rt_index_get(i64 %r43, i64 %r44), !dbg !288
  store i64 %r45, ptr %slot.exchange, align 8, !dbg !288
  %r46 = add i64 %r42, 0, !dbg !289
  %r47 = add i64 1, 0, !dbg !289
  %r48 = call i64 @nova_rt_index_get(i64 %r46, i64 %r47), !dbg !289
  store i64 %r48, ptr %slot.next_pos, align 8, !dbg !289
  %r49 = add i64 %r48, 0, !dbg !290
  %r50 = add i64 %r39, 0, !dbg !290
  %r51 = call i64 @nova_rt_le(i64 %r49, i64 %r50), !dbg !290
  store i64 %r51, ptr %slot.__sc_63, align 8, !dbg !290
  %br_or_merge652 = icmp ne i64 %r51, 0, !dbg !290
  br i1 %br_or_merge652, label %or_merge65, label %or_rhs64, !dbg !290
or_rhs64:
  %r52 = load i64, ptr %slot.next_pos, align 8, !dbg !290
  %r53 = load i64, ptr %slot.limit, align 8, !dbg !290
  %r54 = call i64 @nova_rt_gt(i64 %r52, i64 %r53), !dbg !290
  store i64 %r54, ptr %slot.__sc_63, align 8, !dbg !290
  br label %or_merge65, !dbg !290
or_merge65:
  %r55 = load i64, ptr %slot.__sc_63, align 8, !dbg !290
  %br_then663 = icmp ne i64 %r55, 0, !dbg !290
  br i1 %br_then663, label %then66, label %else67, !dbg !290
then66:
  %r57 = load i64, ptr %slot.empty, align 8, !dbg !291
  %r58 = load i64, ptr %slot.pos, align 8, !dbg !291
  %r56 = call i64 @nova_rt_list_create(), !dbg !291
  call i64 @nova_rt_list_append(i64 %r56, i64 %r57), !dbg !291
  call i64 @nova_rt_list_append(i64 %r56, i64 %r58), !dbg !291
  ret i64 %r56, !dbg !291
else67:
  br label %endif68, !dbg !291
endif68:
  %r59 = call i64 @nova_rt_dict_create(), !dbg !292
  %r60.p = getelementptr inbounds [5 x i8], ptr @.str.2, i64 0, i64 0, !dbg !292
  %r60 = ptrtoint ptr %r60.p to i64, !dbg !292
  %r61 = load i64, ptr %slot.pref, align 8, !dbg !292
  call i64 @nova_rt_dict_set_no_rc(i64 %r59, i64 %r60, i64 %r61), !dbg !292
  %r62.p = getelementptr inbounds [9 x i8], ptr @.str.3, i64 0, i64 0, !dbg !292
  %r62 = ptrtoint ptr %r62.p to i64, !dbg !292
  %r63 = load i64, ptr %slot.exchange, align 8, !dbg !292
  call i64 @nova_rt_dict_set_no_rc(i64 %r59, i64 %r62, i64 %r63), !dbg !292
  store i64 %r59, ptr %slot.rec, align 8, !dbg !292
  %r65 = add i64 %r59, 0, !dbg !293
  %r66 = load i64, ptr %slot.next_pos, align 8, !dbg !293
  %r64 = call i64 @nova_rt_list_create(), !dbg !293
  call i64 @nova_rt_list_append(i64 %r64, i64 %r65), !dbg !293
  call i64 @nova_rt_list_append(i64 %r64, i64 %r66), !dbg !293
  ret i64 %r64, !dbg !293
}

; ESCAPE dns_name_rdata_encode: allocs=0 escape=0 local=0
define i64 @dns_name_rdata_encode(i64 %p0) nounwind uwtable !dbg !294 {
entry:
  %slot.name = alloca i64, align 8, !dbg !295
  store i64 %p0, ptr %slot.name, align 8, !dbg !295
  %r0 = load i64, ptr %slot.name, align 8, !dbg !296
  %r1 = call i64 @_mx_name_encode(i64 %r0), !dbg !296
  ret i64 %r1, !dbg !296
}

; ESCAPE dns_name_rdata_decode: allocs=0 escape=0 local=0
define i64 @dns_name_rdata_decode(i64 %p0, i64 %p1) nounwind uwtable !dbg !297 {
entry:
  %slot.msg = alloca i64, align 8, !dbg !298
  store i64 %p0, ptr %slot.msg, align 8, !dbg !298
  %slot.pos = alloca i64, align 8, !dbg !298
  store i64 %p1, ptr %slot.pos, align 8, !dbg !298
  %r0 = load i64, ptr %slot.msg, align 8, !dbg !299
  %r1 = load i64, ptr %slot.pos, align 8, !dbg !299
  %r2 = call i64 @_mx_name_decode(i64 %r0, i64 %r1), !dbg !299
  ret i64 %r2, !dbg !299
}

; ESCAPE dns_name_rdata_decode_bounded: allocs=3 escape=3 local=0
define i64 @dns_name_rdata_decode_bounded(i64 %p0, i64 %p1, i64 %p2) nounwind uwtable !dbg !300 {
entry:
  %slot.msg = alloca i64, align 8, !dbg !301
  store i64 %p0, ptr %slot.msg, align 8, !dbg !301
  %slot.pos = alloca i64, align 8, !dbg !301
  store i64 %p1, ptr %slot.pos, align 8, !dbg !301
  %slot.rdlength = alloca i64, align 8, !dbg !301
  store i64 %p2, ptr %slot.rdlength, align 8, !dbg !301
  %slot.mlen = alloca i64, align 8, !dbg !301
  store i64 0, ptr %slot.mlen, align 8, !dbg !301
  %slot.__sc_69 = alloca i64, align 8, !dbg !301
  store i64 0, ptr %slot.__sc_69, align 8, !dbg !301
  %slot.limit = alloca i64, align 8, !dbg !301
  store i64 0, ptr %slot.limit, align 8, !dbg !301
  %slot.nd = alloca i64, align 8, !dbg !301
  store i64 0, ptr %slot.nd, align 8, !dbg !301
  %slot.name = alloca i64, align 8, !dbg !301
  store i64 0, ptr %slot.name, align 8, !dbg !301
  %slot.next_pos = alloca i64, align 8, !dbg !301
  store i64 0, ptr %slot.next_pos, align 8, !dbg !301
  %slot.__sc_75 = alloca i64, align 8, !dbg !301
  store i64 0, ptr %slot.__sc_75, align 8, !dbg !301
  %r0 = load i64, ptr %slot.msg, align 8, !dbg !302
  %r1 = call i64 @nova_rt_bytes_len(i64 %r0), !dbg !302
  store i64 %r1, ptr %slot.mlen, align 8, !dbg !302
  %r2 = load i64, ptr %slot.rdlength, align 8, !dbg !303
  %r3 = add i64 0, 0, !dbg !303
  %r4.cmp = icmp slt i64 %r2, %r3, !dbg !303
  %r4 = zext i1 %r4.cmp to i64, !dbg !303
  store i64 %r4, ptr %slot.__sc_69, align 8, !dbg !303
  %br_or_merge710 = icmp ne i64 %r4, 0, !dbg !303
  br i1 %br_or_merge710, label %or_merge71, label %or_rhs70, !dbg !303
or_rhs70:
  %r5 = load i64, ptr %slot.pos, align 8, !dbg !303
  %r6 = load i64, ptr %slot.rdlength, align 8, !dbg !303
  %r7 = add i64 %r5, %r6, !dbg !303
  %r8 = load i64, ptr %slot.mlen, align 8, !dbg !303
  %r9.cmp = icmp sgt i64 %r7, %r8, !dbg !303
  %r9 = zext i1 %r9.cmp to i64, !dbg !303
  store i64 %r9, ptr %slot.__sc_69, align 8, !dbg !303
  br label %or_merge71, !dbg !303
or_merge71:
  %r10 = load i64, ptr %slot.__sc_69, align 8, !dbg !303
  %br_then721 = icmp ne i64 %r10, 0, !dbg !303
  br i1 %br_then721, label %then72, label %else73, !dbg !303
then72:
  %r12.p = getelementptr inbounds [1 x i8], ptr @.str.1, i64 0, i64 0, !dbg !304
  %r12 = ptrtoint ptr %r12.p to i64, !dbg !304
  %r13 = load i64, ptr %slot.pos, align 8, !dbg !304
  %r11 = call i64 @nova_rt_list_create(), !dbg !304
  call i64 @nova_rt_list_append(i64 %r11, i64 %r12), !dbg !304
  call i64 @nova_rt_list_append(i64 %r11, i64 %r13), !dbg !304
  ret i64 %r11, !dbg !304
else73:
  br label %endif74, !dbg !304
endif74:
  %r14 = load i64, ptr %slot.pos, align 8, !dbg !305
  %r15 = load i64, ptr %slot.rdlength, align 8, !dbg !305
  %r16 = add i64 %r14, %r15, !dbg !305
  store i64 %r16, ptr %slot.limit, align 8, !dbg !305
  %r17 = load i64, ptr %slot.msg, align 8, !dbg !306
  %r18 = load i64, ptr %slot.pos, align 8, !dbg !306
  %r19 = call i64 @_mx_name_decode(i64 %r17, i64 %r18), !dbg !306
  store i64 %r19, ptr %slot.nd, align 8, !dbg !306
  %r20 = add i64 %r19, 0, !dbg !307
  %r21 = add i64 0, 0, !dbg !307
  %r22 = call i64 @nova_rt_index_get(i64 %r20, i64 %r21), !dbg !307
  store i64 %r22, ptr %slot.name, align 8, !dbg !307
  %r23 = add i64 %r19, 0, !dbg !308
  %r24 = add i64 1, 0, !dbg !308
  %r25 = call i64 @nova_rt_index_get(i64 %r23, i64 %r24), !dbg !308
  store i64 %r25, ptr %slot.next_pos, align 8, !dbg !308
  %r26 = add i64 %r25, 0, !dbg !309
  %r27 = load i64, ptr %slot.pos, align 8, !dbg !309
  %r28 = call i64 @nova_rt_le(i64 %r26, i64 %r27), !dbg !309
  store i64 %r28, ptr %slot.__sc_75, align 8, !dbg !309
  %br_or_merge772 = icmp ne i64 %r28, 0, !dbg !309
  br i1 %br_or_merge772, label %or_merge77, label %or_rhs76, !dbg !309
or_rhs76:
  %r29 = load i64, ptr %slot.next_pos, align 8, !dbg !309
  %r30 = load i64, ptr %slot.limit, align 8, !dbg !309
  %r31 = call i64 @nova_rt_gt(i64 %r29, i64 %r30), !dbg !309
  store i64 %r31, ptr %slot.__sc_75, align 8, !dbg !309
  br label %or_merge77, !dbg !309
or_merge77:
  %r32 = load i64, ptr %slot.__sc_75, align 8, !dbg !309
  %br_then783 = icmp ne i64 %r32, 0, !dbg !309
  br i1 %br_then783, label %then78, label %else79, !dbg !309
then78:
  %r34.p = getelementptr inbounds [1 x i8], ptr @.str.1, i64 0, i64 0, !dbg !310
  %r34 = ptrtoint ptr %r34.p to i64, !dbg !310
  %r35 = load i64, ptr %slot.pos, align 8, !dbg !310
  %r33 = call i64 @nova_rt_list_create(), !dbg !310
  call i64 @nova_rt_list_append(i64 %r33, i64 %r34), !dbg !310
  call i64 @nova_rt_list_append(i64 %r33, i64 %r35), !dbg !310
  ret i64 %r33, !dbg !310
else79:
  br label %endif80, !dbg !310
endif80:
  %r37 = load i64, ptr %slot.name, align 8, !dbg !311
  %r38 = load i64, ptr %slot.next_pos, align 8, !dbg !311
  %r36 = call i64 @nova_rt_list_create(), !dbg !311
  call i64 @nova_rt_list_append(i64 %r36, i64 %r37), !dbg !311
  call i64 @nova_rt_list_append(i64 %r36, i64 %r38), !dbg !311
  ret i64 %r36, !dbg !311
}

; ESCAPE nova_main: allocs=0 escape=0 local=0
define i64 @nova_main() nounwind uwtable {
entry:
  ret i64 0
}

; ESCAPE SUMMARY: allocs=15 escape=13 local=2 (13% local, RC-elidable)
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
@.str.0 = private unnamed_addr constant [2 x i8] c".\00"
@.str.1 = private unnamed_addr constant [1 x i8] c"\00"
@.str.2 = private unnamed_addr constant [5 x i8] c"pref\00"
@.str.3 = private unnamed_addr constant [9 x i8] c"exchange\00"

; Debug metadata
!llvm.dbg.cu = !{!100}
!llvm.module.flags = !{!102, !103}

!100 = distinct !DICompileUnit(language: DW_LANG_C99, file: !101, producer: "NOVA Compiler", isOptimized: false, emissionKind: LineTablesOnly)
!101 = !DIFile(filename: "std/net/dns_rdata_mx.nova", directory: ".")
!102 = !{i32 2, !"CodeView", i32 1}
!103 = !{i32 2, !"Debug Info Version", i32 3}
!104 = !DISubroutineType(types: !105)
!105 = !{null}
!200 = distinct !DISubprogram(name: "_mx_name_encode", scope: !101, file: !101, line: 71, type: !104, scopeLine: 71, spFlags: DISPFlagDefinition, unit: !100)
!201 = !DILocation(line: 71, column: 0, scope: !200)
!221 = distinct !DISubprogram(name: "_mx_name_decode", scope: !101, file: !101, line: 98, type: !104, scopeLine: 98, spFlags: DISPFlagDefinition, unit: !100)
!222 = !DILocation(line: 98, column: 0, scope: !221)
!264 = distinct !DISubprogram(name: "dns_mx_encode", scope: !101, file: !101, line: 153, type: !104, scopeLine: 153, spFlags: DISPFlagDefinition, unit: !100)
!265 = !DILocation(line: 153, column: 0, scope: !264)
!274 = distinct !DISubprogram(name: "dns_mx_decode", scope: !101, file: !101, line: 170, type: !104, scopeLine: 170, spFlags: DISPFlagDefinition, unit: !100)
!275 = !DILocation(line: 170, column: 0, scope: !274)
!294 = distinct !DISubprogram(name: "dns_name_rdata_encode", scope: !101, file: !101, line: 196, type: !104, scopeLine: 196, spFlags: DISPFlagDefinition, unit: !100)
!295 = !DILocation(line: 196, column: 0, scope: !294)
!297 = distinct !DISubprogram(name: "dns_name_rdata_decode", scope: !101, file: !101, line: 205, type: !104, scopeLine: 205, spFlags: DISPFlagDefinition, unit: !100)
!298 = !DILocation(line: 205, column: 0, scope: !297)
!300 = distinct !DISubprogram(name: "dns_name_rdata_decode_bounded", scope: !101, file: !101, line: 215, type: !104, scopeLine: 215, spFlags: DISPFlagDefinition, unit: !100)
!301 = !DILocation(line: 215, column: 0, scope: !300)
!202 = !DILocation(line: 72, column: 0, scope: !200)
!203 = !DILocation(line: 73, column: 0, scope: !200)
!204 = !DILocation(line: 74, column: 0, scope: !200)
!205 = !DILocation(line: 75, column: 0, scope: !200)
!206 = !DILocation(line: 76, column: 0, scope: !200)
!207 = !DILocation(line: 77, column: 0, scope: !200)
!208 = !DILocation(line: 78, column: 0, scope: !200)
!209 = !DILocation(line: 79, column: 0, scope: !200)
!210 = !DILocation(line: 80, column: 0, scope: !200)
!211 = !DILocation(line: 81, column: 0, scope: !200)
!212 = !DILocation(line: 82, column: 0, scope: !200)
!213 = !DILocation(line: 83, column: 0, scope: !200)
!214 = !DILocation(line: 84, column: 0, scope: !200)
!215 = !DILocation(line: 85, column: 0, scope: !200)
!216 = !DILocation(line: 86, column: 0, scope: !200)
!217 = !DILocation(line: 87, column: 0, scope: !200)
!218 = !DILocation(line: 88, column: 0, scope: !200)
!219 = !DILocation(line: 89, column: 0, scope: !200)
!220 = !DILocation(line: 90, column: 0, scope: !200)
!223 = !DILocation(line: 99, column: 0, scope: !221)
!224 = !DILocation(line: 100, column: 0, scope: !221)
!225 = !DILocation(line: 101, column: 0, scope: !221)
!226 = !DILocation(line: 102, column: 0, scope: !221)
!227 = !DILocation(line: 103, column: 0, scope: !221)
!228 = !DILocation(line: 104, column: 0, scope: !221)
!229 = !DILocation(line: 105, column: 0, scope: !221)
!230 = !DILocation(line: 106, column: 0, scope: !221)
!231 = !DILocation(line: 107, column: 0, scope: !221)
!232 = !DILocation(line: 108, column: 0, scope: !221)
!233 = !DILocation(line: 109, column: 0, scope: !221)
!234 = !DILocation(line: 110, column: 0, scope: !221)
!235 = !DILocation(line: 111, column: 0, scope: !221)
!236 = !DILocation(line: 112, column: 0, scope: !221)
!237 = !DILocation(line: 113, column: 0, scope: !221)
!238 = !DILocation(line: 114, column: 0, scope: !221)
!239 = !DILocation(line: 115, column: 0, scope: !221)
!240 = !DILocation(line: 116, column: 0, scope: !221)
!241 = !DILocation(line: 117, column: 0, scope: !221)
!242 = !DILocation(line: 118, column: 0, scope: !221)
!243 = !DILocation(line: 119, column: 0, scope: !221)
!244 = !DILocation(line: 120, column: 0, scope: !221)
!245 = !DILocation(line: 122, column: 0, scope: !221)
!246 = !DILocation(line: 123, column: 0, scope: !221)
!247 = !DILocation(line: 124, column: 0, scope: !221)
!248 = !DILocation(line: 125, column: 0, scope: !221)
!249 = !DILocation(line: 126, column: 0, scope: !221)
!250 = !DILocation(line: 127, column: 0, scope: !221)
!251 = !DILocation(line: 128, column: 0, scope: !221)
!252 = !DILocation(line: 129, column: 0, scope: !221)
!253 = !DILocation(line: 130, column: 0, scope: !221)
!254 = !DILocation(line: 131, column: 0, scope: !221)
!255 = !DILocation(line: 132, column: 0, scope: !221)
!256 = !DILocation(line: 133, column: 0, scope: !221)
!257 = !DILocation(line: 134, column: 0, scope: !221)
!258 = !DILocation(line: 135, column: 0, scope: !221)
!259 = !DILocation(line: 136, column: 0, scope: !221)
!260 = !DILocation(line: 137, column: 0, scope: !221)
!261 = !DILocation(line: 138, column: 0, scope: !221)
!262 = !DILocation(line: 140, column: 0, scope: !221)
!263 = !DILocation(line: 141, column: 0, scope: !221)
!266 = !DILocation(line: 154, column: 0, scope: !264)
!267 = !DILocation(line: 155, column: 0, scope: !264)
!268 = !DILocation(line: 156, column: 0, scope: !264)
!269 = !DILocation(line: 157, column: 0, scope: !264)
!270 = !DILocation(line: 158, column: 0, scope: !264)
!271 = !DILocation(line: 159, column: 0, scope: !264)
!272 = !DILocation(line: 160, column: 0, scope: !264)
!273 = !DILocation(line: 161, column: 0, scope: !264)
!276 = !DILocation(line: 171, column: 0, scope: !274)
!277 = !DILocation(line: 172, column: 0, scope: !274)
!278 = !DILocation(line: 173, column: 0, scope: !274)
!279 = !DILocation(line: 174, column: 0, scope: !274)
!280 = !DILocation(line: 175, column: 0, scope: !274)
!281 = !DILocation(line: 176, column: 0, scope: !274)
!282 = !DILocation(line: 177, column: 0, scope: !274)
!283 = !DILocation(line: 178, column: 0, scope: !274)
!284 = !DILocation(line: 179, column: 0, scope: !274)
!285 = !DILocation(line: 180, column: 0, scope: !274)
!286 = !DILocation(line: 181, column: 0, scope: !274)
!287 = !DILocation(line: 182, column: 0, scope: !274)
!288 = !DILocation(line: 183, column: 0, scope: !274)
!289 = !DILocation(line: 184, column: 0, scope: !274)
!290 = !DILocation(line: 185, column: 0, scope: !274)
!291 = !DILocation(line: 186, column: 0, scope: !274)
!292 = !DILocation(line: 187, column: 0, scope: !274)
!293 = !DILocation(line: 188, column: 0, scope: !274)
!296 = !DILocation(line: 197, column: 0, scope: !294)
!299 = !DILocation(line: 206, column: 0, scope: !297)
!302 = !DILocation(line: 216, column: 0, scope: !300)
!303 = !DILocation(line: 217, column: 0, scope: !300)
!304 = !DILocation(line: 218, column: 0, scope: !300)
!305 = !DILocation(line: 219, column: 0, scope: !300)
!306 = !DILocation(line: 220, column: 0, scope: !300)
!307 = !DILocation(line: 221, column: 0, scope: !300)
!308 = !DILocation(line: 222, column: 0, scope: !300)
!309 = !DILocation(line: 223, column: 0, scope: !300)
!310 = !DILocation(line: 224, column: 0, scope: !300)
!311 = !DILocation(line: 225, column: 0, scope: !300)

; TBAA metadata
!0 = !{!"NOVA TBAA"}
!1 = !{!"list_data_ptr", !0}
!2 = !{!1, !1, i64 0}
!3 = !{!"list_elem", !0}
!4 = !{!3, !3, i64 0}
!5 = !{!"list_size", !0}
!6 = !{!5, !5, i64 0}
!90 = !{!"branch_weights", i32 2000, i32 1}
