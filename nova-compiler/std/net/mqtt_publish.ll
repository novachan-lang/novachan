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

; ESCAPE mqtt_remlen_encode: allocs=1 escape=1 local=0
define i64 @mqtt_remlen_encode(i64 %p0) nounwind uwtable {
entry:
  %slot.n = alloca i64, align 8
  store i64 %p0, ptr %slot.n, align 8
  %slot.out = alloca i64, align 8
  store i64 0, ptr %slot.out, align 8
  %slot.v = alloca i64, align 8
  store i64 0, ptr %slot.v, align 8
  %slot.done = alloca i64, align 8
  store i64 0, ptr %slot.done, align 8
  %slot.b = alloca i64, align 8
  store i64 0, ptr %slot.b, align 8
  %r0 = call i64 @nova_rt_list_create()
  store i64 %r0, ptr %slot.out, align 8
  %r1 = load i64, ptr %slot.n, align 8
  store i64 %r1, ptr %slot.v, align 8
  %r2 = add i64 0, 0
  store i64 %r2, ptr %slot.done, align 8
  br label %while_hdr0
while_hdr0:
  %r3 = load i64, ptr %slot.done, align 8
  %r4 = add i64 0, 0
  %r5.cmp = icmp eq i64 %r3, %r4
  %r5 = zext i1 %r5.cmp to i64
  %br_while_body10 = icmp ne i64 %r5, 0
  br i1 %br_while_body10, label %while_body1, label %while_exit2, !prof !90
while_body1:
  %r6 = load i64, ptr %slot.v, align 8
  %r7 = add i64 127, 0
  %r8 = and i64 %r6, %r7
  store i64 %r8, ptr %slot.b, align 8
  %r9 = load i64, ptr %slot.v, align 8
  %r10 = add i64 7, 0
  %r11.sramt = and i64 %r10, 63
  %r11.srbig = icmp uge i64 %r10, 64
  %r11.srval = ashr i64 %r9, %r11.sramt
  %r11.srext = ashr i64 %r9, 63
  %r11 = select i1 %r11.srbig, i64 %r11.srext, i64 %r11.srval
  store i64 %r11, ptr %slot.v, align 8
  %r12 = load i64, ptr %slot.v, align 8
  %r13 = add i64 0, 0
  %r14 = call i64 @nova_rt_gt(i64 %r12, i64 %r13)
  %br_then31 = icmp ne i64 %r14, 0
  br i1 %br_then31, label %then3, label %else4
then3:
  %r15 = load i64, ptr %slot.b, align 8
  %r16 = add i64 128, 0
  %r17 = or i64 %r15, %r16
  store i64 %r17, ptr %slot.b, align 8
  br label %endif5
else4:
  br label %endif5
endif5:
  %r18 = load i64, ptr %slot.out, align 8
  %r19 = load i64, ptr %slot.b, align 8
  %r20 = call i64 @nova_rt_list_append(i64 %r18, i64 %r19)
  %r21 = load i64, ptr %slot.v, align 8
  %r22 = add i64 0, 0
  %r23 = call i64 @nova_rt_eq(i64 %r21, i64 %r22)
  %br_then62 = icmp ne i64 %r23, 0
  br i1 %br_then62, label %then6, label %else7
then6:
  %r24 = add i64 1, 0
  store i64 %r24, ptr %slot.done, align 8
  br label %endif8
else7:
  br label %endif8
endif8:
  br label %while_hdr0
while_exit2:
  %r25 = load i64, ptr %slot.out, align 8
  ret i64 %r25
}

; ESCAPE mqtt_remlen_decode: allocs=2 escape=2 local=0
define i64 @mqtt_remlen_decode(i64 %p0, i64 %p1) nounwind uwtable {
entry:
  %slot.blist = alloca i64, align 8
  store i64 %p0, ptr %slot.blist, align 8
  %slot.pos = alloca i64, align 8
  store i64 %p1, ptr %slot.pos, align 8
  %slot.total = alloca i64, align 8
  store i64 0, ptr %slot.total, align 8
  %slot.value = alloca i64, align 8
  store i64 0, ptr %slot.value, align 8
  %slot.shift = alloca i64, align 8
  store i64 0, ptr %slot.shift, align 8
  %slot.cur = alloca i64, align 8
  store i64 0, ptr %slot.cur, align 8
  %slot.ok = alloca i64, align 8
  store i64 0, ptr %slot.ok, align 8
  %slot.running = alloca i64, align 8
  store i64 0, ptr %slot.running, align 8
  %slot.blist__s4f70 = alloca i64, align 8
  store i64 0, ptr %slot.blist__s4f70, align 8
  %slot.byte__s4f70 = alloca i64, align 8
  store i64 0, ptr %slot.byte__s4f70, align 8
  %slot.byte = alloca i64, align 8
  store i64 0, ptr %slot.byte, align 8
  %r0 = load i64, ptr %slot.blist, align 8
  %r1.lp = inttoptr i64 %r0 to ptr
  %r1.szp = getelementptr i64, ptr %r1.lp, i64 1
  %r1 = load i64, ptr %r1.szp, align 8, !tbaa !6
  store i64 %r1, ptr %slot.total, align 8
  %r2 = add i64 0, 0
  store i64 %r2, ptr %slot.value, align 8
  %r3 = add i64 0, 0
  store i64 %r3, ptr %slot.shift, align 8
  %r4 = load i64, ptr %slot.pos, align 8
  store i64 %r4, ptr %slot.cur, align 8
  %r5 = add i64 1, 0
  store i64 %r5, ptr %slot.ok, align 8
  %r6 = add i64 1, 0
  store i64 %r6, ptr %slot.running, align 8
  %r7 = load i64, ptr %slot.blist, align 8
  %r8 = call i64 @nova_rt_list_is_kind2(i64 %r7)
  %br_then90 = icmp ne i64 %r8, 0
  br i1 %br_then90, label %then9, label %else10
then9:
  %r9 = load i64, ptr %slot.blist, align 8
  %r10 = call i64 @nova_rt_floatlist_view(i64 %r9)
  store i64 %r10, ptr %slot.blist__s4f70, align 8
  br label %while_hdr12
while_hdr12:
  %r11 = load i64, ptr %slot.running, align 8
  %r12 = add i64 1, 0
  %r13.cmp = icmp eq i64 %r11, %r12
  %r13 = zext i1 %r13.cmp to i64
  %br_while_body131 = icmp ne i64 %r13, 0
  br i1 %br_while_body131, label %while_body13, label %while_exit14, !prof !90
while_body13:
  %r14 = load i64, ptr %slot.cur, align 8
  %r15 = load i64, ptr %slot.total, align 8
  %r16.cmp = icmp sge i64 %r14, %r15
  %r16 = zext i1 %r16.cmp to i64
  %br_then152 = icmp ne i64 %r16, 0
  br i1 %br_then152, label %then15, label %else16
then15:
  %r17 = add i64 0, 0
  store i64 %r17, ptr %slot.ok, align 8
  %r18 = add i64 0, 0
  store i64 %r18, ptr %slot.running, align 8
  br label %endif17
else16:
  %r19 = load i64, ptr %slot.blist__s4f70, align 8
  %r20 = load i64, ptr %slot.cur, align 8
  %r21 = call i64 @nova_rt_list_get_f(i64 %r19, i64 %r20)
  store i64 %r21, ptr %slot.byte__s4f70, align 8
  %r22 = load i64, ptr %slot.cur, align 8
  %r23 = add i64 1, 0
  %r24 = add i64 %r22, %r23
  store i64 %r24, ptr %slot.cur, align 8
  %r25 = load i64, ptr %slot.value, align 8
  %r26 = load i64, ptr %slot.byte__s4f70, align 8
  %r27 = add i64 127, 0
  %r28 = and i64 %r26, %r27
  %r29 = load i64, ptr %slot.shift, align 8
  %r30.shamt = and i64 %r29, 63
  %r30.shbig = icmp uge i64 %r29, 64
  %r30.shval = shl i64 %r28, %r30.shamt
  %r30 = select i1 %r30.shbig, i64 0, i64 %r30.shval
  %r31 = or i64 %r25, %r30
  store i64 %r31, ptr %slot.value, align 8
  %r32 = load i64, ptr %slot.shift, align 8
  %r33 = add i64 7, 0
  %r34 = add i64 %r32, %r33
  store i64 %r34, ptr %slot.shift, align 8
  %r35 = load i64, ptr %slot.byte__s4f70, align 8
  %r36 = add i64 128, 0
  %r37 = and i64 %r35, %r36
  %r38 = add i64 0, 0
  %r39 = call i64 @nova_rt_eq(i64 %r37, i64 %r38)
  %br_then183 = icmp ne i64 %r39, 0
  br i1 %br_then183, label %then18, label %else19
then18:
  %r40 = add i64 0, 0
  store i64 %r40, ptr %slot.running, align 8
  br label %endif20
else19:
  %r41 = load i64, ptr %slot.shift, align 8
  %r42 = add i64 28, 0
  %r43.cmp = icmp sge i64 %r41, %r42
  %r43 = zext i1 %r43.cmp to i64
  %br_then214 = icmp ne i64 %r43, 0
  br i1 %br_then214, label %then21, label %else22
then21:
  %r44 = add i64 0, 0
  store i64 %r44, ptr %slot.ok, align 8
  %r45 = add i64 0, 0
  store i64 %r45, ptr %slot.running, align 8
  br label %endif23
else22:
  br label %endif23
endif23:
  br label %endif20
endif20:
  br label %endif17
endif17:
  br label %while_hdr12
while_exit14:
  br label %endif11
else10:
  br label %while_hdr24
while_hdr24:
  %r46 = load i64, ptr %slot.running, align 8
  %r47 = add i64 1, 0
  %r48.cmp = icmp eq i64 %r46, %r47
  %r48 = zext i1 %r48.cmp to i64
  %br_while_body255 = icmp ne i64 %r48, 0
  br i1 %br_while_body255, label %while_body25, label %while_exit26, !prof !90
while_body25:
  %r49 = load i64, ptr %slot.cur, align 8
  %r50 = load i64, ptr %slot.total, align 8
  %r51.cmp = icmp sge i64 %r49, %r50
  %r51 = zext i1 %r51.cmp to i64
  %br_then276 = icmp ne i64 %r51, 0
  br i1 %br_then276, label %then27, label %else28
then27:
  %r52 = add i64 0, 0
  store i64 %r52, ptr %slot.ok, align 8
  %r53 = add i64 0, 0
  store i64 %r53, ptr %slot.running, align 8
  br label %endif29
else28:
  %r54 = load i64, ptr %slot.blist, align 8
  %r55 = load i64, ptr %slot.cur, align 8
  %r56 = call i64 @nova_rt_list_get(i64 %r54, i64 %r55)
  store i64 %r56, ptr %slot.byte, align 8
  %r57 = load i64, ptr %slot.cur, align 8
  %r58 = add i64 1, 0
  %r59 = add i64 %r57, %r58
  store i64 %r59, ptr %slot.cur, align 8
  %r60 = load i64, ptr %slot.value, align 8
  %r61 = load i64, ptr %slot.byte, align 8
  %r62 = add i64 127, 0
  %r63 = and i64 %r61, %r62
  %r64 = load i64, ptr %slot.shift, align 8
  %r65.shamt = and i64 %r64, 63
  %r65.shbig = icmp uge i64 %r64, 64
  %r65.shval = shl i64 %r63, %r65.shamt
  %r65 = select i1 %r65.shbig, i64 0, i64 %r65.shval
  %r66 = or i64 %r60, %r65
  store i64 %r66, ptr %slot.value, align 8
  %r67 = load i64, ptr %slot.shift, align 8
  %r68 = add i64 7, 0
  %r69 = add i64 %r67, %r68
  store i64 %r69, ptr %slot.shift, align 8
  %r70 = load i64, ptr %slot.byte, align 8
  %r71 = add i64 128, 0
  %r72 = and i64 %r70, %r71
  %r73 = add i64 0, 0
  %r74 = call i64 @nova_rt_eq(i64 %r72, i64 %r73)
  %br_then307 = icmp ne i64 %r74, 0
  br i1 %br_then307, label %then30, label %else31
then30:
  %r75 = add i64 0, 0
  store i64 %r75, ptr %slot.running, align 8
  br label %endif32
else31:
  %r76 = load i64, ptr %slot.shift, align 8
  %r77 = add i64 28, 0
  %r78.cmp = icmp sge i64 %r76, %r77
  %r78 = zext i1 %r78.cmp to i64
  %br_then338 = icmp ne i64 %r78, 0
  br i1 %br_then338, label %then33, label %else34
then33:
  %r79 = add i64 0, 0
  store i64 %r79, ptr %slot.ok, align 8
  %r80 = add i64 0, 0
  store i64 %r80, ptr %slot.running, align 8
  br label %endif35
else34:
  br label %endif35
endif35:
  br label %endif32
endif32:
  br label %endif29
endif29:
  br label %while_hdr24
while_exit26:
  br label %endif11
endif11:
  %r81 = load i64, ptr %slot.ok, align 8
  %r82 = add i64 0, 0
  %r83.cmp = icmp eq i64 %r81, %r82
  %r83 = zext i1 %r83.cmp to i64
  %br_then369 = icmp ne i64 %r83, 0
  br i1 %br_then369, label %then36, label %else37
then36:
  %r85 = add i64 1, 0
  %r86 = sub i64 0, %r85
  %r87 = load i64, ptr %slot.pos, align 8
  %r84 = call i64 @nova_rt_list_create()
  call i64 @nova_rt_list_append(i64 %r84, i64 %r86)
  call i64 @nova_rt_list_append(i64 %r84, i64 %r87)
  ret i64 %r84
else37:
  br label %endif38
endif38:
  %r89 = load i64, ptr %slot.value, align 8
  %r90 = load i64, ptr %slot.cur, align 8
  %r88 = call i64 @nova_rt_list_create()
  call i64 @nova_rt_list_append(i64 %r88, i64 %r89)
  call i64 @nova_rt_list_append(i64 %r88, i64 %r90)
  ret i64 %r88
}

; ESCAPE mqtt_fixed_header: allocs=1 escape=1 local=0
define i64 @mqtt_fixed_header(i64 %p0, i64 %p1, i64 %p2) nounwind uwtable {
entry:
  %slot.pkt_type = alloca i64, align 8
  store i64 %p0, ptr %slot.pkt_type, align 8
  %slot.flags = alloca i64, align 8
  store i64 %p1, ptr %slot.flags, align 8
  %slot.remlen = alloca i64, align 8
  store i64 %p2, ptr %slot.remlen, align 8
  %slot.out = alloca i64, align 8
  store i64 0, ptr %slot.out, align 8
  %slot.byte0 = alloca i64, align 8
  store i64 0, ptr %slot.byte0, align 8
  %slot.rl = alloca i64, align 8
  store i64 0, ptr %slot.rl, align 8
  %slot.i = alloca i64, align 8
  store i64 0, ptr %slot.i, align 8
  %slot.n = alloca i64, align 8
  store i64 0, ptr %slot.n, align 8
  %slot.rl__s4f100 = alloca i64, align 8
  store i64 0, ptr %slot.rl__s4f100, align 8
  %r0 = call i64 @nova_rt_list_create()
  store i64 %r0, ptr %slot.out, align 8
  %r1 = load i64, ptr %slot.pkt_type, align 8
  %r2 = add i64 4, 0
  %r3.shamt = and i64 %r2, 63
  %r3.shbig = icmp uge i64 %r2, 64
  %r3.shval = shl i64 %r1, %r3.shamt
  %r3 = select i1 %r3.shbig, i64 0, i64 %r3.shval
  %r4 = add i64 240, 0
  %r5 = and i64 %r3, %r4
  %r6 = load i64, ptr %slot.flags, align 8
  %r7 = add i64 15, 0
  %r8 = and i64 %r6, %r7
  %r9 = or i64 %r5, %r8
  store i64 %r9, ptr %slot.byte0, align 8
  %r10 = load i64, ptr %slot.out, align 8
  %r11 = load i64, ptr %slot.byte0, align 8
  %r12 = call i64 @nova_rt_list_append(i64 %r10, i64 %r11)
  %r13 = load i64, ptr %slot.remlen, align 8
  %r14 = call i64 @mqtt_remlen_encode(i64 %r13)
  store i64 %r14, ptr %slot.rl, align 8
  %r15 = add i64 0, 0
  store i64 %r15, ptr %slot.i, align 8
  %r16 = load i64, ptr %slot.rl, align 8
  %r17.lp = inttoptr i64 %r16 to ptr
  %r17.szp = getelementptr i64, ptr %r17.lp, i64 1
  %r17 = load i64, ptr %r17.szp, align 8, !tbaa !6
  store i64 %r17, ptr %slot.n, align 8
  %r18 = load i64, ptr %slot.rl, align 8
  %r19 = call i64 @nova_rt_list_is_kind2(i64 %r18)
  %br_then390 = icmp ne i64 %r19, 0
  br i1 %br_then390, label %then39, label %else40
then39:
  %r20 = load i64, ptr %slot.rl, align 8
  %r21 = call i64 @nova_rt_floatlist_view(i64 %r20)
  store i64 %r21, ptr %slot.rl__s4f100, align 8
  br label %while_hdr42
while_hdr42:
  %r22 = load i64, ptr %slot.i, align 8
  %r23 = load i64, ptr %slot.n, align 8
  %r24.cmp = icmp slt i64 %r22, %r23
  %r24 = zext i1 %r24.cmp to i64
  %br_while_body431 = icmp ne i64 %r24, 0
  br i1 %br_while_body431, label %while_body43, label %while_exit44, !prof !90
while_body43:
  %r25 = load i64, ptr %slot.out, align 8
  %r26 = load i64, ptr %slot.rl__s4f100, align 8
  %r27 = load i64, ptr %slot.i, align 8
  %r28 = call i64 @nova_rt_list_get_f(i64 %r26, i64 %r27)
  %r29 = call i64 @nova_rt_list_append_fbox(i64 %r25, i64 %r28)
  %r30 = load i64, ptr %slot.i, align 8
  %r31 = add i64 1, 0
  %r32 = add i64 %r30, %r31
  store i64 %r32, ptr %slot.i, align 8
  br label %while_hdr42
while_exit44:
  br label %endif41
else40:
  br label %while_hdr45
while_hdr45:
  %r33 = load i64, ptr %slot.i, align 8
  %r34 = load i64, ptr %slot.n, align 8
  %r35.cmp = icmp slt i64 %r33, %r34
  %r35 = zext i1 %r35.cmp to i64
  %br_while_body462 = icmp ne i64 %r35, 0
  br i1 %br_while_body462, label %while_body46, label %while_exit47, !prof !90
while_body46:
  %r36 = load i64, ptr %slot.out, align 8
  %r37 = load i64, ptr %slot.rl, align 8
  %r38 = load i64, ptr %slot.i, align 8
  %r39 = call i64 @nova_rt_index_get(i64 %r37, i64 %r38)
  %r40 = call i64 @nova_rt_list_append(i64 %r36, i64 %r39)
  %r41 = load i64, ptr %slot.i, align 8
  %r42 = add i64 1, 0
  %r43 = add i64 %r41, %r42
  store i64 %r43, ptr %slot.i, align 8
  br label %while_hdr45
while_exit47:
  br label %endif41
endif41:
  %r44 = load i64, ptr %slot.out, align 8
  ret i64 %r44
}

; ESCAPE _mp_push_u16: allocs=0 escape=0 local=0
define i64 @_mp_push_u16(i64 %p0, i64 %p1) nounwind uwtable !dbg !200 {
entry:
  %slot.out = alloca i64, align 8, !dbg !201
  store i64 %p0, ptr %slot.out, align 8, !dbg !201
  %slot.v = alloca i64, align 8, !dbg !201
  store i64 %p1, ptr %slot.v, align 8, !dbg !201
  %r0 = load i64, ptr %slot.out, align 8, !dbg !202
  %r1 = load i64, ptr %slot.v, align 8, !dbg !202
  %r2 = add i64 8, 0, !dbg !202
  %r3.sramt = and i64 %r2, 63, !dbg !202
  %r3.srbig = icmp uge i64 %r2, 64, !dbg !202
  %r3.srval = ashr i64 %r1, %r3.sramt, !dbg !202
  %r3.srext = ashr i64 %r1, 63, !dbg !202
  %r3 = select i1 %r3.srbig, i64 %r3.srext, i64 %r3.srval, !dbg !202
  %r4 = add i64 255, 0, !dbg !202
  %r5 = and i64 %r3, %r4, !dbg !202
  %r6 = call i64 @nova_rt_list_append(i64 %r0, i64 %r5), !dbg !202
  %r7 = load i64, ptr %slot.out, align 8, !dbg !203
  %r8 = load i64, ptr %slot.v, align 8, !dbg !203
  %r9 = add i64 255, 0, !dbg !203
  %r10 = and i64 %r8, %r9, !dbg !203
  %r11 = call i64 @nova_rt_list_append(i64 %r7, i64 %r10), !dbg !203
  ret i64 %r11, !dbg !203
}

; ESCAPE _mp_push_str: allocs=0 escape=0 local=0
define i64 @_mp_push_str(i64 %p0, i64 %p1) nounwind uwtable !dbg !204 {
entry:
  %slot.out = alloca i64, align 8, !dbg !205
  store i64 %p0, ptr %slot.out, align 8, !dbg !205
  %slot.s = alloca i64, align 8, !dbg !205
  store i64 %p1, ptr %slot.s, align 8, !dbg !205
  %slot.slen = alloca i64, align 8, !dbg !205
  store i64 0, ptr %slot.slen, align 8, !dbg !205
  %slot.i = alloca i64, align 8, !dbg !205
  store i64 0, ptr %slot.i, align 8, !dbg !205
  %r0 = load i64, ptr %slot.s, align 8, !dbg !206
  %r1 = call i64 @nova_rt_len_any(i64 %r0), !dbg !206
  store i64 %r1, ptr %slot.slen, align 8, !dbg !206
  %r2 = load i64, ptr %slot.out, align 8, !dbg !207
  %r3 = add i64 %r1, 0, !dbg !207
  %r4 = call i64 @_mp_push_u16(i64 %r2, i64 %r3), !dbg !207
  %r5 = add i64 0, 0, !dbg !208
  store i64 %r5, ptr %slot.i, align 8, !dbg !208
  br label %while_hdr48, !dbg !209
while_hdr48:
  %r6 = load i64, ptr %slot.i, align 8, !dbg !209
  %r7 = load i64, ptr %slot.slen, align 8, !dbg !209
  %r8.cmp = icmp slt i64 %r6, %r7, !dbg !209
  %r8 = zext i1 %r8.cmp to i64, !dbg !209
  %br_while_body490 = icmp ne i64 %r8, 0, !dbg !209
  br i1 %br_while_body490, label %while_body49, label %while_exit50, !prof !90, !dbg !209
while_body49:
  %r9 = load i64, ptr %slot.out, align 8, !dbg !210
  %r10 = load i64, ptr %slot.s, align 8, !dbg !210
  %r11 = load i64, ptr %slot.i, align 8, !dbg !210
  %r12 = load i64, ptr %slot.i, align 8, !dbg !210
  %r13 = add i64 1, 0, !dbg !210
  %r14 = add i64 %r12, %r13, !dbg !210
  %r15 = call i64 @nova_rt_slice(i64 %r10, i64 %r11, i64 %r14), !dbg !210
  %r16 = call i64 @nova_rt_ord(i64 %r15), !dbg !210
  %r17 = call i64 @nova_rt_list_append(i64 %r9, i64 %r16), !dbg !210
  %r18 = load i64, ptr %slot.i, align 8, !dbg !211
  %r19 = add i64 1, 0, !dbg !211
  %r20 = add i64 %r18, %r19, !dbg !211
  store i64 %r20, ptr %slot.i, align 8, !dbg !211
  br label %while_hdr48, !dbg !211
while_exit50:
  ret i64 0, !dbg !211
}

; ESCAPE _mp_read_u16: allocs=0 escape=0 local=0
define i64 @_mp_read_u16(i64 %p0, i64 %p1) nounwind uwtable !dbg !212 {
entry:
  %slot.blist = alloca i64, align 8, !dbg !213
  store i64 %p0, ptr %slot.blist, align 8, !dbg !213
  %slot.pos = alloca i64, align 8, !dbg !213
  store i64 %p1, ptr %slot.pos, align 8, !dbg !213
  %slot.total = alloca i64, align 8, !dbg !213
  store i64 0, ptr %slot.total, align 8, !dbg !213
  %slot.hi = alloca i64, align 8, !dbg !213
  store i64 0, ptr %slot.hi, align 8, !dbg !213
  %slot.lo = alloca i64, align 8, !dbg !213
  store i64 0, ptr %slot.lo, align 8, !dbg !213
  %r0 = load i64, ptr %slot.blist, align 8, !dbg !214
  %r1.lp = inttoptr i64 %r0 to ptr, !dbg !214
  %r1.szp = getelementptr i64, ptr %r1.lp, i64 1, !dbg !214
  %r1 = load i64, ptr %r1.szp, align 8, !tbaa !6, !dbg !214
  store i64 %r1, ptr %slot.total, align 8, !dbg !214
  %r2 = load i64, ptr %slot.pos, align 8, !dbg !215
  %r3 = add i64 1, 0, !dbg !215
  %r4 = add i64 %r2, %r3, !dbg !215
  %r5 = add i64 %r1, 0, !dbg !215
  %r6.cmp = icmp sge i64 %r4, %r5, !dbg !215
  %r6 = zext i1 %r6.cmp to i64, !dbg !215
  %br_then510 = icmp ne i64 %r6, 0, !dbg !215
  br i1 %br_then510, label %then51, label %else52, !dbg !215
then51:
  %r8 = add i64 -1, 0, !dbg !216
  ret i64 %r8, !dbg !216
else52:
  br label %endif53, !dbg !216
endif53:
  %r9 = load i64, ptr %slot.blist, align 8, !dbg !217
  %r10 = load i64, ptr %slot.pos, align 8, !dbg !217
  %r11 = call i64 @nova_rt_list_get(i64 %r9, i64 %r10), !dbg !217
  store i64 %r11, ptr %slot.hi, align 8, !dbg !217
  %r12 = load i64, ptr %slot.blist, align 8, !dbg !218
  %r13 = load i64, ptr %slot.pos, align 8, !dbg !218
  %r14 = add i64 1, 0, !dbg !218
  %r15 = add i64 %r13, %r14, !dbg !218
  %r16 = call i64 @nova_rt_list_get(i64 %r12, i64 %r15), !dbg !218
  store i64 %r16, ptr %slot.lo, align 8, !dbg !218
  %r17 = add i64 %r11, 0, !dbg !219
  %r18 = add i64 8, 0, !dbg !219
  %r19.shamt = and i64 %r18, 63, !dbg !219
  %r19.shbig = icmp uge i64 %r18, 64, !dbg !219
  %r19.shval = shl i64 %r17, %r19.shamt, !dbg !219
  %r19 = select i1 %r19.shbig, i64 0, i64 %r19.shval, !dbg !219
  %r20 = add i64 %r16, 0, !dbg !219
  %r21 = or i64 %r19, %r20, !dbg !219
  ret i64 %r21, !dbg !219
}

; ESCAPE _mp_read_str_n: allocs=0 escape=0 local=0
define i64 @_mp_read_str_n(i64 %p0, i64 %p1, i64 %p2) nounwind uwtable !dbg !220 {
entry:
  %slot.blist = alloca i64, align 8, !dbg !221
  store i64 %p0, ptr %slot.blist, align 8, !dbg !221
  %slot.pos = alloca i64, align 8, !dbg !221
  store i64 %p1, ptr %slot.pos, align 8, !dbg !221
  %slot.count = alloca i64, align 8, !dbg !221
  store i64 %p2, ptr %slot.count, align 8, !dbg !221
  %slot.total = alloca i64, align 8, !dbg !221
  store i64 0, ptr %slot.total, align 8, !dbg !221
  %slot.s = alloca i64, align 8, !dbg !221
  store i64 0, ptr %slot.s, align 8, !dbg !221
  %slot.i = alloca i64, align 8, !dbg !221
  store i64 0, ptr %slot.i, align 8, !dbg !221
  %slot.blist__s4f79 = alloca i64, align 8, !dbg !221
  store i64 0, ptr %slot.blist__s4f79, align 8, !dbg !221
  %r0 = load i64, ptr %slot.blist, align 8, !dbg !222
  %r1.lp = inttoptr i64 %r0 to ptr, !dbg !222
  %r1.szp = getelementptr i64, ptr %r1.lp, i64 1, !dbg !222
  %r1 = load i64, ptr %r1.szp, align 8, !tbaa !6, !dbg !222
  store i64 %r1, ptr %slot.total, align 8, !dbg !222
  %r2 = load i64, ptr %slot.pos, align 8, !dbg !223
  %r3 = load i64, ptr %slot.count, align 8, !dbg !223
  %r4 = add i64 %r2, %r3, !dbg !223
  %r5 = add i64 %r1, 0, !dbg !223
  %r6.cmp = icmp sgt i64 %r4, %r5, !dbg !223
  %r6 = zext i1 %r6.cmp to i64, !dbg !223
  %br_then540 = icmp ne i64 %r6, 0, !dbg !223
  br i1 %br_then540, label %then54, label %else55, !dbg !223
then54:
  %r7.p = getelementptr inbounds [1 x i8], ptr @.str.0, i64 0, i64 0, !dbg !224
  %r7 = ptrtoint ptr %r7.p to i64, !dbg !224
  ret i64 %r7, !dbg !224
else55:
  br label %endif56, !dbg !224
endif56:
  %r8.p = getelementptr inbounds [1 x i8], ptr @.str.0, i64 0, i64 0, !dbg !225
  %r8 = ptrtoint ptr %r8.p to i64, !dbg !225
  store i64 %r8, ptr %slot.s, align 8, !dbg !225
  %r9 = add i64 0, 0, !dbg !226
  store i64 %r9, ptr %slot.i, align 8, !dbg !226
  %r10 = load i64, ptr %slot.blist, align 8, !dbg !227
  %r11 = call i64 @nova_rt_list_is_kind2(i64 %r10), !dbg !227
  %br_then571 = icmp ne i64 %r11, 0, !dbg !227
  br i1 %br_then571, label %then57, label %else58, !dbg !227
then57:
  %r12 = load i64, ptr %slot.blist, align 8, !dbg !227
  %r13 = call i64 @nova_rt_floatlist_view(i64 %r12), !dbg !227
  store i64 %r13, ptr %slot.blist__s4f79, align 8, !dbg !227
  br label %while_hdr60, !dbg !227
while_hdr60:
  %r14 = load i64, ptr %slot.i, align 8, !dbg !227
  %r15 = load i64, ptr %slot.count, align 8, !dbg !227
  %r16.cmp = icmp slt i64 %r14, %r15, !dbg !227
  %r16 = zext i1 %r16.cmp to i64, !dbg !227
  %br_while_body612 = icmp ne i64 %r16, 0, !dbg !227
  br i1 %br_while_body612, label %while_body61, label %while_exit62, !prof !90, !dbg !227
while_body61:
  %r17 = load i64, ptr %slot.s, align 8, !dbg !228
  %r18 = load i64, ptr %slot.blist__s4f79, align 8, !dbg !228
  %r19 = load i64, ptr %slot.pos, align 8, !dbg !228
  %r20 = load i64, ptr %slot.i, align 8, !dbg !228
  %r21 = add i64 %r19, %r20, !dbg !228
  %r22 = call i64 @nova_rt_list_get_f(i64 %r18, i64 %r21), !dbg !228
  %wbox0 = call i64 @nova_rt_box_float(i64 %r22), !dbg !228
  %r23 = call i64 @nova_rt_chr(i64 %wbox0), !dbg !228
  %r24 = call i64 @nova_rt_str_concat(i64 %r17, i64 %r23), !dbg !228
  store i64 %r24, ptr %slot.s, align 8, !dbg !228
  %r25 = load i64, ptr %slot.i, align 8, !dbg !229
  %r26 = add i64 1, 0, !dbg !229
  %r27 = add i64 %r25, %r26, !dbg !229
  store i64 %r27, ptr %slot.i, align 8, !dbg !229
  br label %while_hdr60, !dbg !229
while_exit62:
  br label %endif59, !dbg !229
else58:
  br label %while_hdr63, !dbg !227
while_hdr63:
  %r28 = load i64, ptr %slot.i, align 8, !dbg !227
  %r29 = load i64, ptr %slot.count, align 8, !dbg !227
  %r30.cmp = icmp slt i64 %r28, %r29, !dbg !227
  %r30 = zext i1 %r30.cmp to i64, !dbg !227
  %br_while_body643 = icmp ne i64 %r30, 0, !dbg !227
  br i1 %br_while_body643, label %while_body64, label %while_exit65, !prof !90, !dbg !227
while_body64:
  %r31 = load i64, ptr %slot.s, align 8, !dbg !228
  %r32 = load i64, ptr %slot.blist, align 8, !dbg !228
  %r33 = load i64, ptr %slot.pos, align 8, !dbg !228
  %r34 = load i64, ptr %slot.i, align 8, !dbg !228
  %r35 = add i64 %r33, %r34, !dbg !228
  %r36 = call i64 @nova_rt_list_get(i64 %r32, i64 %r35), !dbg !228
  %r37 = call i64 @nova_rt_chr(i64 %r36), !dbg !228
  %r38 = call i64 @nova_rt_str_concat(i64 %r31, i64 %r37), !dbg !228
  store i64 %r38, ptr %slot.s, align 8, !dbg !228
  %r39 = load i64, ptr %slot.i, align 8, !dbg !229
  %r40 = add i64 1, 0, !dbg !229
  %r41 = add i64 %r39, %r40, !dbg !229
  store i64 %r41, ptr %slot.i, align 8, !dbg !229
  br label %while_hdr63, !dbg !229
while_exit65:
  br label %endif59, !dbg !229
endif59:
  %r42 = load i64, ptr %slot.s, align 8, !dbg !230
  ret i64 %r42, !dbg !230
}

; ESCAPE mqtt_publish: allocs=1 escape=0 local=1
define i64 @mqtt_publish(i64 %p0, i64 %p1, i64 %p2, i64 %p3) nounwind uwtable !dbg !231 {
entry:
  %slot.topic = alloca i64, align 8, !dbg !232
  store i64 %p0, ptr %slot.topic, align 8, !dbg !232
  %slot.payload_bytes = alloca i64, align 8, !dbg !232
  store i64 %p1, ptr %slot.payload_bytes, align 8, !dbg !232
  %slot.qos = alloca i64, align 8, !dbg !232
  store i64 %p2, ptr %slot.qos, align 8, !dbg !232
  %slot.packet_id = alloca i64, align 8, !dbg !232
  store i64 %p3, ptr %slot.packet_id, align 8, !dbg !232
  %slot.var_payload = alloca i64, align 8, !dbg !232
  store i64 0, ptr %slot.var_payload, align 8, !dbg !232
  %slot.plen = alloca i64, align 8, !dbg !232
  store i64 0, ptr %slot.plen, align 8, !dbg !232
  %slot.i = alloca i64, align 8, !dbg !232
  store i64 0, ptr %slot.i, align 8, !dbg !232
  %slot.payload_bytes__s4f102 = alloca i64, align 8, !dbg !232
  store i64 0, ptr %slot.payload_bytes__s4f102, align 8, !dbg !232
  %slot.flags = alloca i64, align 8, !dbg !232
  store i64 0, ptr %slot.flags, align 8, !dbg !232
  %slot.remlen = alloca i64, align 8, !dbg !232
  store i64 0, ptr %slot.remlen, align 8, !dbg !232
  %slot.out = alloca i64, align 8, !dbg !232
  store i64 0, ptr %slot.out, align 8, !dbg !232
  %slot.j = alloca i64, align 8, !dbg !232
  store i64 0, ptr %slot.j, align 8, !dbg !232
  %slot.n = alloca i64, align 8, !dbg !232
  store i64 0, ptr %slot.n, align 8, !dbg !232
  %slot.var_payload__s4f114 = alloca i64, align 8, !dbg !232
  store i64 0, ptr %slot.var_payload__s4f114, align 8, !dbg !232
  %r0 = call i64 @nova_rt_list_create(), !dbg !233
  store i64 %r0, ptr %slot.var_payload, align 8, !dbg !233
  %r1 = add i64 %r0, 0, !dbg !234
  %r2 = load i64, ptr %slot.topic, align 8, !dbg !234
  %r3 = call i64 @_mp_push_str(i64 %r1, i64 %r2), !dbg !234
  %r4 = load i64, ptr %slot.qos, align 8, !dbg !235
  %r5 = add i64 0, 0, !dbg !235
  %r6.cmp = icmp sgt i64 %r4, %r5, !dbg !235
  %r6 = zext i1 %r6.cmp to i64, !dbg !235
  %br_then660 = icmp ne i64 %r6, 0, !dbg !235
  br i1 %br_then660, label %then66, label %else67, !dbg !235
then66:
  %r7 = load i64, ptr %slot.var_payload, align 8, !dbg !236
  %r8 = load i64, ptr %slot.packet_id, align 8, !dbg !236
  %r9 = call i64 @_mp_push_u16(i64 %r7, i64 %r8), !dbg !236
  br label %endif68, !dbg !236
else67:
  br label %endif68, !dbg !236
endif68:
  %r10 = load i64, ptr %slot.payload_bytes, align 8, !dbg !237
  %r11.lp = inttoptr i64 %r10 to ptr, !dbg !237
  %r11.szp = getelementptr i64, ptr %r11.lp, i64 1, !dbg !237
  %r11 = load i64, ptr %r11.szp, align 8, !tbaa !6, !dbg !237
  store i64 %r11, ptr %slot.plen, align 8, !dbg !237
  %r12 = add i64 0, 0, !dbg !238
  store i64 %r12, ptr %slot.i, align 8, !dbg !238
  %r13 = load i64, ptr %slot.payload_bytes, align 8, !dbg !239
  %r14 = call i64 @nova_rt_list_is_kind2(i64 %r13), !dbg !239
  %br_then691 = icmp ne i64 %r14, 0, !dbg !239
  br i1 %br_then691, label %then69, label %else70, !dbg !239
then69:
  %r15 = load i64, ptr %slot.payload_bytes, align 8, !dbg !239
  %r16 = call i64 @nova_rt_floatlist_view(i64 %r15), !dbg !239
  store i64 %r16, ptr %slot.payload_bytes__s4f102, align 8, !dbg !239
  br label %while_hdr72, !dbg !239
while_hdr72:
  %r17 = load i64, ptr %slot.i, align 8, !dbg !239
  %r18 = load i64, ptr %slot.plen, align 8, !dbg !239
  %r19.cmp = icmp slt i64 %r17, %r18, !dbg !239
  %r19 = zext i1 %r19.cmp to i64, !dbg !239
  %br_while_body732 = icmp ne i64 %r19, 0, !dbg !239
  br i1 %br_while_body732, label %while_body73, label %while_exit74, !prof !90, !dbg !239
while_body73:
  %r20 = load i64, ptr %slot.var_payload, align 8, !dbg !240
  %r21 = load i64, ptr %slot.payload_bytes__s4f102, align 8, !dbg !240
  %r22 = load i64, ptr %slot.i, align 8, !dbg !240
  %r23 = call i64 @nova_rt_list_get_f(i64 %r21, i64 %r22), !dbg !240
  %r24 = call i64 @nova_rt_list_append_fbox(i64 %r20, i64 %r23), !dbg !240
  %r25 = load i64, ptr %slot.i, align 8, !dbg !241
  %r26 = add i64 1, 0, !dbg !241
  %r27 = add i64 %r25, %r26, !dbg !241
  store i64 %r27, ptr %slot.i, align 8, !dbg !241
  br label %while_hdr72, !dbg !241
while_exit74:
  br label %endif71, !dbg !241
else70:
  br label %while_hdr75, !dbg !239
while_hdr75:
  %r28 = load i64, ptr %slot.i, align 8, !dbg !239
  %r29 = load i64, ptr %slot.plen, align 8, !dbg !239
  %r30.cmp = icmp slt i64 %r28, %r29, !dbg !239
  %r30 = zext i1 %r30.cmp to i64, !dbg !239
  %br_while_body763 = icmp ne i64 %r30, 0, !dbg !239
  br i1 %br_while_body763, label %while_body76, label %while_exit77, !prof !90, !dbg !239
while_body76:
  %r31 = load i64, ptr %slot.var_payload, align 8, !dbg !240
  %r32 = load i64, ptr %slot.payload_bytes, align 8, !dbg !240
  %r33 = load i64, ptr %slot.i, align 8, !dbg !240
  %r34 = call i64 @nova_rt_list_get(i64 %r32, i64 %r33), !dbg !240
  %r35 = call i64 @nova_rt_list_append_no_rc(i64 %r31, i64 %r34), !dbg !240
  %r36 = load i64, ptr %slot.i, align 8, !dbg !241
  %r37 = add i64 1, 0, !dbg !241
  %r38 = add i64 %r36, %r37, !dbg !241
  store i64 %r38, ptr %slot.i, align 8, !dbg !241
  br label %while_hdr75, !dbg !241
while_exit77:
  br label %endif71, !dbg !241
endif71:
  %r39 = load i64, ptr %slot.qos, align 8, !dbg !242
  %r40 = add i64 1, 0, !dbg !242
  %r41.shamt = and i64 %r40, 63, !dbg !242
  %r41.shbig = icmp uge i64 %r40, 64, !dbg !242
  %r41.shval = shl i64 %r39, %r41.shamt, !dbg !242
  %r41 = select i1 %r41.shbig, i64 0, i64 %r41.shval, !dbg !242
  %r42 = add i64 6, 0, !dbg !242
  %r43 = and i64 %r41, %r42, !dbg !242
  store i64 %r43, ptr %slot.flags, align 8, !dbg !242
  %r44 = load i64, ptr %slot.var_payload, align 8, !dbg !243
  %r45.lp = inttoptr i64 %r44 to ptr, !dbg !243
  %r45.szp = getelementptr i64, ptr %r45.lp, i64 1, !dbg !243
  %r45 = load i64, ptr %r45.szp, align 8, !tbaa !6, !dbg !243
  store i64 %r45, ptr %slot.remlen, align 8, !dbg !243
  %r46 = add i64 3, 0, !dbg !244
  %r47 = add i64 %r43, 0, !dbg !244
  %r48 = add i64 %r45, 0, !dbg !244
  %r49 = call i64 @mqtt_fixed_header(i64 %r46, i64 %r47, i64 %r48), !dbg !244
  store i64 %r49, ptr %slot.out, align 8, !dbg !244
  %r50 = add i64 0, 0, !dbg !245
  store i64 %r50, ptr %slot.j, align 8, !dbg !245
  %r51 = load i64, ptr %slot.var_payload, align 8, !dbg !246
  %r52.lp = inttoptr i64 %r51 to ptr, !dbg !246
  %r52.szp = getelementptr i64, ptr %r52.lp, i64 1, !dbg !246
  %r52 = load i64, ptr %r52.szp, align 8, !tbaa !6, !dbg !246
  store i64 %r52, ptr %slot.n, align 8, !dbg !246
  %r53 = load i64, ptr %slot.var_payload, align 8, !dbg !247
  %r54 = call i64 @nova_rt_list_is_kind2(i64 %r53), !dbg !247
  %br_then784 = icmp ne i64 %r54, 0, !dbg !247
  br i1 %br_then784, label %then78, label %else79, !dbg !247
then78:
  %r55 = load i64, ptr %slot.var_payload, align 8, !dbg !247
  %r56 = call i64 @nova_rt_floatlist_view(i64 %r55), !dbg !247
  store i64 %r56, ptr %slot.var_payload__s4f114, align 8, !dbg !247
  br label %while_hdr81, !dbg !247
while_hdr81:
  %r57 = load i64, ptr %slot.j, align 8, !dbg !247
  %r58 = load i64, ptr %slot.n, align 8, !dbg !247
  %r59.cmp = icmp slt i64 %r57, %r58, !dbg !247
  %r59 = zext i1 %r59.cmp to i64, !dbg !247
  %br_while_body825 = icmp ne i64 %r59, 0, !dbg !247
  br i1 %br_while_body825, label %while_body82, label %while_exit83, !prof !90, !dbg !247
while_body82:
  %r60 = load i64, ptr %slot.out, align 8, !dbg !248
  %r61 = load i64, ptr %slot.var_payload__s4f114, align 8, !dbg !248
  %r62 = load i64, ptr %slot.j, align 8, !dbg !248
  %r63 = call i64 @nova_rt_list_get_f(i64 %r61, i64 %r62), !dbg !248
  %r64 = call i64 @nova_rt_list_append_fbox(i64 %r60, i64 %r63), !dbg !248
  %r65 = load i64, ptr %slot.j, align 8, !dbg !249
  %r66 = add i64 1, 0, !dbg !249
  %r67 = add i64 %r65, %r66, !dbg !249
  store i64 %r67, ptr %slot.j, align 8, !dbg !249
  br label %while_hdr81, !dbg !249
while_exit83:
  br label %endif80, !dbg !249
else79:
  br label %while_hdr84, !dbg !247
while_hdr84:
  %r68 = load i64, ptr %slot.j, align 8, !dbg !247
  %r69 = load i64, ptr %slot.n, align 8, !dbg !247
  %r70.cmp = icmp slt i64 %r68, %r69, !dbg !247
  %r70 = zext i1 %r70.cmp to i64, !dbg !247
  %br_while_body856 = icmp ne i64 %r70, 0, !dbg !247
  br i1 %br_while_body856, label %while_body85, label %while_exit86, !prof !90, !dbg !247
while_body85:
  %r71 = load i64, ptr %slot.out, align 8, !dbg !248
  %r72 = load i64, ptr %slot.var_payload, align 8, !dbg !248
  %r73 = load i64, ptr %slot.j, align 8, !dbg !248
  %r74 = call i64 @nova_rt_list_get(i64 %r72, i64 %r73), !dbg !248
  %r75 = call i64 @nova_rt_list_append(i64 %r71, i64 %r74), !dbg !248
  %r76 = load i64, ptr %slot.j, align 8, !dbg !249
  %r77 = add i64 1, 0, !dbg !249
  %r78 = add i64 %r76, %r77, !dbg !249
  store i64 %r78, ptr %slot.j, align 8, !dbg !249
  br label %while_hdr84, !dbg !249
while_exit86:
  br label %endif80, !dbg !249
endif80:
  %r79 = load i64, ptr %slot.out, align 8, !dbg !250
  ret i64 %r79, !dbg !250
}

; ESCAPE mqtt_publish_decode: allocs=8 escape=8 local=0
define i64 @mqtt_publish_decode(i64 %p0) nounwind uwtable !dbg !251 {
entry:
  %slot.packet = alloca i64, align 8, !dbg !252
  store i64 %p0, ptr %slot.packet, align 8, !dbg !252
  %slot.total = alloca i64, align 8, !dbg !252
  store i64 0, ptr %slot.total, align 8, !dbg !252
  %slot.byte0 = alloca i64, align 8, !dbg !252
  store i64 0, ptr %slot.byte0, align 8, !dbg !252
  %slot.pkt_type = alloca i64, align 8, !dbg !252
  store i64 0, ptr %slot.pkt_type, align 8, !dbg !252
  %slot.flags = alloca i64, align 8, !dbg !252
  store i64 0, ptr %slot.flags, align 8, !dbg !252
  %slot.qos = alloca i64, align 8, !dbg !252
  store i64 0, ptr %slot.qos, align 8, !dbg !252
  %slot.dec = alloca i64, align 8, !dbg !252
  store i64 0, ptr %slot.dec, align 8, !dbg !252
  %slot.var_start = alloca i64, align 8, !dbg !252
  store i64 0, ptr %slot.var_start, align 8, !dbg !252
  %slot.topic_len = alloca i64, align 8, !dbg !252
  store i64 0, ptr %slot.topic_len, align 8, !dbg !252
  %slot.topic = alloca i64, align 8, !dbg !252
  store i64 0, ptr %slot.topic, align 8, !dbg !252
  %slot.pos = alloca i64, align 8, !dbg !252
  store i64 0, ptr %slot.pos, align 8, !dbg !252
  %slot.packet_id = alloca i64, align 8, !dbg !252
  store i64 0, ptr %slot.packet_id, align 8, !dbg !252
  %slot.pid = alloca i64, align 8, !dbg !252
  store i64 0, ptr %slot.pid, align 8, !dbg !252
  %slot.payload = alloca i64, align 8, !dbg !252
  store i64 0, ptr %slot.payload, align 8, !dbg !252
  %slot.packet__s4f160 = alloca i64, align 8, !dbg !252
  store i64 0, ptr %slot.packet__s4f160, align 8, !dbg !252
  %slot.result = alloca i64, align 8, !dbg !252
  store i64 0, ptr %slot.result, align 8, !dbg !252
  %r0 = load i64, ptr %slot.packet, align 8, !dbg !253
  %r1.lp = inttoptr i64 %r0 to ptr, !dbg !253
  %r1.szp = getelementptr i64, ptr %r1.lp, i64 1, !dbg !253
  %r1 = load i64, ptr %r1.szp, align 8, !tbaa !6, !dbg !253
  store i64 %r1, ptr %slot.total, align 8, !dbg !253
  %r2 = add i64 %r1, 0, !dbg !254
  %r3 = add i64 2, 0, !dbg !254
  %r4.cmp = icmp slt i64 %r2, %r3, !dbg !254
  %r4 = zext i1 %r4.cmp to i64, !dbg !254
  %br_then870 = icmp ne i64 %r4, 0, !dbg !254
  br i1 %br_then870, label %then87, label %else88, !dbg !254
then87:
  %r5 = call i64 @nova_rt_dict_create(), !dbg !255
  ret i64 %r5, !dbg !255
else88:
  br label %endif89, !dbg !255
endif89:
  %r6 = load i64, ptr %slot.packet, align 8, !dbg !256
  %r7 = add i64 0, 0, !dbg !256
  %r8 = call i64 @nova_rt_list_get(i64 %r6, i64 %r7), !dbg !256
  store i64 %r8, ptr %slot.byte0, align 8, !dbg !256
  %r9 = add i64 %r8, 0, !dbg !257
  %r10 = add i64 4, 0, !dbg !257
  %r11.sramt = and i64 %r10, 63, !dbg !257
  %r11.srbig = icmp uge i64 %r10, 64, !dbg !257
  %r11.srval = ashr i64 %r9, %r11.sramt, !dbg !257
  %r11.srext = ashr i64 %r9, 63, !dbg !257
  %r11 = select i1 %r11.srbig, i64 %r11.srext, i64 %r11.srval, !dbg !257
  %r12 = add i64 15, 0, !dbg !257
  %r13 = and i64 %r11, %r12, !dbg !257
  store i64 %r13, ptr %slot.pkt_type, align 8, !dbg !257
  %r14 = add i64 %r13, 0, !dbg !258
  %r15 = add i64 3, 0, !dbg !258
  %r16 = call i64 @nova_rt_neq(i64 %r14, i64 %r15), !dbg !258
  %br_then901 = icmp ne i64 %r16, 0, !dbg !258
  br i1 %br_then901, label %then90, label %else91, !dbg !258
then90:
  %r17 = call i64 @nova_rt_dict_create(), !dbg !259
  ret i64 %r17, !dbg !259
else91:
  br label %endif92, !dbg !259
endif92:
  %r18 = load i64, ptr %slot.byte0, align 8, !dbg !260
  %r19 = add i64 15, 0, !dbg !260
  %r20 = and i64 %r18, %r19, !dbg !260
  store i64 %r20, ptr %slot.flags, align 8, !dbg !260
  %r21 = add i64 %r20, 0, !dbg !261
  %r22 = add i64 1, 0, !dbg !261
  %r23.sramt = and i64 %r22, 63, !dbg !261
  %r23.srbig = icmp uge i64 %r22, 64, !dbg !261
  %r23.srval = ashr i64 %r21, %r23.sramt, !dbg !261
  %r23.srext = ashr i64 %r21, 63, !dbg !261
  %r23 = select i1 %r23.srbig, i64 %r23.srext, i64 %r23.srval, !dbg !261
  %r24 = add i64 3, 0, !dbg !261
  %r25 = and i64 %r23, %r24, !dbg !261
  store i64 %r25, ptr %slot.qos, align 8, !dbg !261
  %r26 = load i64, ptr %slot.packet, align 8, !dbg !262
  %r27 = add i64 1, 0, !dbg !262
  %r28 = call i64 @mqtt_remlen_decode(i64 %r26, i64 %r27), !dbg !262
  store i64 %r28, ptr %slot.dec, align 8, !dbg !262
  %r29 = add i64 %r28, 0, !dbg !263
  %r30 = add i64 0, 0, !dbg !263
  %r31 = call i64 @nova_rt_index_get(i64 %r29, i64 %r30), !dbg !263
  %r32 = add i64 0, 0, !dbg !263
  %r33 = call i64 @nova_rt_lt(i64 %r31, i64 %r32), !dbg !263
  %br_then932 = icmp ne i64 %r33, 0, !dbg !263
  br i1 %br_then932, label %then93, label %else94, !dbg !263
then93:
  %r34 = call i64 @nova_rt_dict_create(), !dbg !264
  ret i64 %r34, !dbg !264
else94:
  br label %endif95, !dbg !264
endif95:
  %r35 = load i64, ptr %slot.dec, align 8, !dbg !265
  %r36 = add i64 1, 0, !dbg !265
  %r37 = call i64 @nova_rt_index_get(i64 %r35, i64 %r36), !dbg !265
  store i64 %r37, ptr %slot.var_start, align 8, !dbg !265
  %r38 = load i64, ptr %slot.packet, align 8, !dbg !266
  %r39 = add i64 %r37, 0, !dbg !266
  %r40 = call i64 @_mp_read_u16(i64 %r38, i64 %r39), !dbg !266
  store i64 %r40, ptr %slot.topic_len, align 8, !dbg !266
  %r41 = add i64 %r40, 0, !dbg !267
  %r42 = add i64 0, 0, !dbg !267
  %r43.cmp = icmp slt i64 %r41, %r42, !dbg !267
  %r43 = zext i1 %r43.cmp to i64, !dbg !267
  %br_then963 = icmp ne i64 %r43, 0, !dbg !267
  br i1 %br_then963, label %then96, label %else97, !dbg !267
then96:
  %r44 = call i64 @nova_rt_dict_create(), !dbg !268
  ret i64 %r44, !dbg !268
else97:
  br label %endif98, !dbg !268
endif98:
  %r45 = load i64, ptr %slot.var_start, align 8, !dbg !269
  %r46 = add i64 2, 0, !dbg !269
  %r47 = call i64 @nova_rt_add(i64 %r45, i64 %r46), !dbg !269
  %r48 = load i64, ptr %slot.topic_len, align 8, !dbg !269
  %r49 = call i64 @nova_rt_add(i64 %r47, i64 %r48), !dbg !269
  %r50 = load i64, ptr %slot.total, align 8, !dbg !269
  %r51 = call i64 @nova_rt_gt(i64 %r49, i64 %r50), !dbg !269
  %br_then994 = icmp ne i64 %r51, 0, !dbg !269
  br i1 %br_then994, label %then99, label %else100, !dbg !269
then99:
  %r52 = call i64 @nova_rt_dict_create(), !dbg !270
  ret i64 %r52, !dbg !270
else100:
  br label %endif101, !dbg !270
endif101:
  %r53 = load i64, ptr %slot.packet, align 8, !dbg !271
  %r54 = load i64, ptr %slot.var_start, align 8, !dbg !271
  %r55 = add i64 2, 0, !dbg !271
  %r56 = call i64 @nova_rt_add(i64 %r54, i64 %r55), !dbg !271
  %r57 = load i64, ptr %slot.topic_len, align 8, !dbg !271
  %r58 = call i64 @_mp_read_str_n(i64 %r53, i64 %r56, i64 %r57), !dbg !271
  store i64 %r58, ptr %slot.topic, align 8, !dbg !271
  %r59 = load i64, ptr %slot.var_start, align 8, !dbg !272
  %r60 = add i64 2, 0, !dbg !272
  %r61 = call i64 @nova_rt_add(i64 %r59, i64 %r60), !dbg !272
  %r62 = load i64, ptr %slot.topic_len, align 8, !dbg !272
  %r63 = call i64 @nova_rt_add(i64 %r61, i64 %r62), !dbg !272
  store i64 %r63, ptr %slot.pos, align 8, !dbg !272
  %r64 = add i64 0, 0, !dbg !273
  store i64 %r64, ptr %slot.packet_id, align 8, !dbg !273
  %r65 = load i64, ptr %slot.qos, align 8, !dbg !274
  %r66 = add i64 0, 0, !dbg !274
  %r67 = call i64 @nova_rt_gt(i64 %r65, i64 %r66), !dbg !274
  %br_then1025 = icmp ne i64 %r67, 0, !dbg !274
  br i1 %br_then1025, label %then102, label %else103, !dbg !274
then102:
  %r68 = load i64, ptr %slot.packet, align 8, !dbg !275
  %r69 = load i64, ptr %slot.pos, align 8, !dbg !275
  %r70 = call i64 @_mp_read_u16(i64 %r68, i64 %r69), !dbg !275
  store i64 %r70, ptr %slot.pid, align 8, !dbg !275
  %r71 = add i64 %r70, 0, !dbg !276
  %r72 = add i64 0, 0, !dbg !276
  %r73.cmp = icmp slt i64 %r71, %r72, !dbg !276
  %r73 = zext i1 %r73.cmp to i64, !dbg !276
  %br_then1056 = icmp ne i64 %r73, 0, !dbg !276
  br i1 %br_then1056, label %then105, label %else106, !dbg !276
then105:
  %r74 = call i64 @nova_rt_dict_create(), !dbg !277
  ret i64 %r74, !dbg !277
else106:
  br label %endif107, !dbg !277
endif107:
  %r75 = load i64, ptr %slot.pid, align 8, !dbg !278
  store i64 %r75, ptr %slot.packet_id, align 8, !dbg !278
  %r76 = load i64, ptr %slot.pos, align 8, !dbg !279
  %r77 = add i64 2, 0, !dbg !279
  %r78 = call i64 @nova_rt_add(i64 %r76, i64 %r77), !dbg !279
  store i64 %r78, ptr %slot.pos, align 8, !dbg !279
  br label %endif104, !dbg !279
else103:
  br label %endif104, !dbg !279
endif104:
  %r79 = call i64 @nova_rt_list_create(), !dbg !280
  store i64 %r79, ptr %slot.payload, align 8, !dbg !280
  %r80 = load i64, ptr %slot.packet, align 8, !dbg !281
  %r81 = call i64 @nova_rt_list_is_kind2(i64 %r80), !dbg !281
  %br_then1087 = icmp ne i64 %r81, 0, !dbg !281
  br i1 %br_then1087, label %then108, label %else109, !dbg !281
then108:
  %r82 = load i64, ptr %slot.packet, align 8, !dbg !281
  %r83 = call i64 @nova_rt_floatlist_view(i64 %r82), !dbg !281
  store i64 %r83, ptr %slot.packet__s4f160, align 8, !dbg !281
  br label %while_hdr111, !dbg !281
while_hdr111:
  %r84 = load i64, ptr %slot.pos, align 8, !dbg !281
  %r85 = load i64, ptr %slot.total, align 8, !dbg !281
  %r86 = call i64 @nova_rt_lt(i64 %r84, i64 %r85), !dbg !281
  %br_while_body1128 = icmp ne i64 %r86, 0, !dbg !281
  br i1 %br_while_body1128, label %while_body112, label %while_exit113, !prof !90, !dbg !281
while_body112:
  %r87 = load i64, ptr %slot.payload, align 8, !dbg !282
  %r88 = load i64, ptr %slot.packet__s4f160, align 8, !dbg !282
  %r89 = load i64, ptr %slot.pos, align 8, !dbg !282
  %r90 = call i64 @nova_rt_list_get_f(i64 %r88, i64 %r89), !dbg !282
  %r91 = call i64 @nova_rt_list_append_fbox(i64 %r87, i64 %r90), !dbg !282
  %r92 = load i64, ptr %slot.pos, align 8, !dbg !283
  %r93 = add i64 1, 0, !dbg !283
  %r94 = call i64 @nova_rt_add(i64 %r92, i64 %r93), !dbg !283
  store i64 %r94, ptr %slot.pos, align 8, !dbg !283
  br label %while_hdr111, !dbg !283
while_exit113:
  br label %endif110, !dbg !283
else109:
  br label %while_hdr114, !dbg !281
while_hdr114:
  %r95 = load i64, ptr %slot.pos, align 8, !dbg !281
  %r96 = load i64, ptr %slot.total, align 8, !dbg !281
  %r97 = call i64 @nova_rt_lt(i64 %r95, i64 %r96), !dbg !281
  %br_while_body1159 = icmp ne i64 %r97, 0, !dbg !281
  br i1 %br_while_body1159, label %while_body115, label %while_exit116, !prof !90, !dbg !281
while_body115:
  %r98 = load i64, ptr %slot.payload, align 8, !dbg !282
  %r99 = load i64, ptr %slot.packet, align 8, !dbg !282
  %r100 = load i64, ptr %slot.pos, align 8, !dbg !282
  %r101 = call i64 @nova_rt_list_get(i64 %r99, i64 %r100), !dbg !282
  %r102 = call i64 @nova_rt_list_append(i64 %r98, i64 %r101), !dbg !282
  %r103 = load i64, ptr %slot.pos, align 8, !dbg !283
  %r104 = add i64 1, 0, !dbg !283
  %r105 = call i64 @nova_rt_add(i64 %r103, i64 %r104), !dbg !283
  store i64 %r105, ptr %slot.pos, align 8, !dbg !283
  br label %while_hdr114, !dbg !283
while_exit116:
  br label %endif110, !dbg !283
endif110:
  %r106 = call i64 @nova_rt_dict_create(), !dbg !284
  store i64 %r106, ptr %slot.result, align 8, !dbg !284
  %r107 = load i64, ptr %slot.topic, align 8, !dbg !285
  %r108 = add i64 %r106, 0, !dbg !285
  %r109.p = getelementptr inbounds [6 x i8], ptr @.str.1, i64 0, i64 0, !dbg !285
  %r109 = ptrtoint ptr %r109.p to i64, !dbg !285
  %_is.dv10 = call i64 @nova_rt_dict_set(i64 %r108, i64 %r109, i64 %r107), !dbg !285
  %r110 = load i64, ptr %slot.payload, align 8, !dbg !286
  %r111 = add i64 %r106, 0, !dbg !286
  %r112.p = getelementptr inbounds [8 x i8], ptr @.str.2, i64 0, i64 0, !dbg !286
  %r112 = ptrtoint ptr %r112.p to i64, !dbg !286
  %_is.dv11 = call i64 @nova_rt_dict_set(i64 %r111, i64 %r112, i64 %r110), !dbg !286
  %r113 = load i64, ptr %slot.qos, align 8, !dbg !287
  %r114 = add i64 %r106, 0, !dbg !287
  %r115.p = getelementptr inbounds [4 x i8], ptr @.str.3, i64 0, i64 0, !dbg !287
  %r115 = ptrtoint ptr %r115.p to i64, !dbg !287
  %_is.dv12 = call i64 @nova_rt_dict_set(i64 %r114, i64 %r115, i64 %r113), !dbg !287
  %r116 = load i64, ptr %slot.packet_id, align 8, !dbg !288
  %r117 = add i64 %r106, 0, !dbg !288
  %r118.p = getelementptr inbounds [10 x i8], ptr @.str.4, i64 0, i64 0, !dbg !288
  %r118 = ptrtoint ptr %r118.p to i64, !dbg !288
  %_is.dv13 = call i64 @nova_rt_dict_set(i64 %r117, i64 %r118, i64 %r116), !dbg !288
  %r119 = add i64 %r106, 0, !dbg !289
  ret i64 %r119, !dbg !289
}

; ESCAPE nova_main: allocs=0 escape=0 local=0
define i64 @nova_main() nounwind uwtable {
entry:
  ret i64 0
}

; ESCAPE SUMMARY: allocs=13 escape=12 local=1 (7% local, RC-elidable)
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
@.str.1 = private unnamed_addr constant [6 x i8] c"topic\00"
@.str.2 = private unnamed_addr constant [8 x i8] c"payload\00"
@.str.3 = private unnamed_addr constant [4 x i8] c"qos\00"
@.str.4 = private unnamed_addr constant [10 x i8] c"packet_id\00"

; Debug metadata
!llvm.dbg.cu = !{!100}
!llvm.module.flags = !{!102, !103}

!100 = distinct !DICompileUnit(language: DW_LANG_C99, file: !101, producer: "NOVA Compiler", isOptimized: false, emissionKind: LineTablesOnly)
!101 = !DIFile(filename: "std/net/mqtt_publish.nova", directory: ".")
!102 = !{i32 2, !"CodeView", i32 1}
!103 = !{i32 2, !"Debug Info Version", i32 3}
!104 = !DISubroutineType(types: !105)
!105 = !{null}
!200 = distinct !DISubprogram(name: "_mp_push_u16", scope: !101, file: !101, line: 48, type: !104, scopeLine: 48, spFlags: DISPFlagDefinition, unit: !100)
!201 = !DILocation(line: 48, column: 0, scope: !200)
!204 = distinct !DISubprogram(name: "_mp_push_str", scope: !101, file: !101, line: 53, type: !104, scopeLine: 53, spFlags: DISPFlagDefinition, unit: !100)
!205 = !DILocation(line: 53, column: 0, scope: !204)
!212 = distinct !DISubprogram(name: "_mp_read_u16", scope: !101, file: !101, line: 63, type: !104, scopeLine: 63, spFlags: DISPFlagDefinition, unit: !100)
!213 = !DILocation(line: 63, column: 0, scope: !212)
!220 = distinct !DISubprogram(name: "_mp_read_str_n", scope: !101, file: !101, line: 73, type: !104, scopeLine: 73, spFlags: DISPFlagDefinition, unit: !100)
!221 = !DILocation(line: 73, column: 0, scope: !220)
!231 = distinct !DISubprogram(name: "mqtt_publish", scope: !101, file: !101, line: 88, type: !104, scopeLine: 88, spFlags: DISPFlagDefinition, unit: !100)
!232 = !DILocation(line: 88, column: 0, scope: !231)
!251 = distinct !DISubprogram(name: "mqtt_publish_decode", scope: !101, file: !101, line: 121, type: !104, scopeLine: 121, spFlags: DISPFlagDefinition, unit: !100)
!252 = !DILocation(line: 121, column: 0, scope: !251)
!202 = !DILocation(line: 49, column: 0, scope: !200)
!203 = !DILocation(line: 50, column: 0, scope: !200)
!206 = !DILocation(line: 54, column: 0, scope: !204)
!207 = !DILocation(line: 55, column: 0, scope: !204)
!208 = !DILocation(line: 56, column: 0, scope: !204)
!209 = !DILocation(line: 57, column: 0, scope: !204)
!210 = !DILocation(line: 58, column: 0, scope: !204)
!211 = !DILocation(line: 59, column: 0, scope: !204)
!214 = !DILocation(line: 64, column: 0, scope: !212)
!215 = !DILocation(line: 65, column: 0, scope: !212)
!216 = !DILocation(line: 66, column: 0, scope: !212)
!217 = !DILocation(line: 67, column: 0, scope: !212)
!218 = !DILocation(line: 68, column: 0, scope: !212)
!219 = !DILocation(line: 69, column: 0, scope: !212)
!222 = !DILocation(line: 74, column: 0, scope: !220)
!223 = !DILocation(line: 75, column: 0, scope: !220)
!224 = !DILocation(line: 76, column: 0, scope: !220)
!225 = !DILocation(line: 77, column: 0, scope: !220)
!226 = !DILocation(line: 78, column: 0, scope: !220)
!227 = !DILocation(line: 79, column: 0, scope: !220)
!228 = !DILocation(line: 80, column: 0, scope: !220)
!229 = !DILocation(line: 81, column: 0, scope: !220)
!230 = !DILocation(line: 82, column: 0, scope: !220)
!233 = !DILocation(line: 90, column: 0, scope: !231)
!234 = !DILocation(line: 93, column: 0, scope: !231)
!235 = !DILocation(line: 96, column: 0, scope: !231)
!236 = !DILocation(line: 97, column: 0, scope: !231)
!237 = !DILocation(line: 100, column: 0, scope: !231)
!238 = !DILocation(line: 101, column: 0, scope: !231)
!239 = !DILocation(line: 102, column: 0, scope: !231)
!240 = !DILocation(line: 103, column: 0, scope: !231)
!241 = !DILocation(line: 104, column: 0, scope: !231)
!242 = !DILocation(line: 107, column: 0, scope: !231)
!243 = !DILocation(line: 108, column: 0, scope: !231)
!244 = !DILocation(line: 109, column: 0, scope: !231)
!245 = !DILocation(line: 112, column: 0, scope: !231)
!246 = !DILocation(line: 113, column: 0, scope: !231)
!247 = !DILocation(line: 114, column: 0, scope: !231)
!248 = !DILocation(line: 115, column: 0, scope: !231)
!249 = !DILocation(line: 116, column: 0, scope: !231)
!250 = !DILocation(line: 117, column: 0, scope: !231)
!253 = !DILocation(line: 122, column: 0, scope: !251)
!254 = !DILocation(line: 123, column: 0, scope: !251)
!255 = !DILocation(line: 124, column: 0, scope: !251)
!256 = !DILocation(line: 127, column: 0, scope: !251)
!257 = !DILocation(line: 128, column: 0, scope: !251)
!258 = !DILocation(line: 129, column: 0, scope: !251)
!259 = !DILocation(line: 130, column: 0, scope: !251)
!260 = !DILocation(line: 131, column: 0, scope: !251)
!261 = !DILocation(line: 132, column: 0, scope: !251)
!262 = !DILocation(line: 135, column: 0, scope: !251)
!263 = !DILocation(line: 136, column: 0, scope: !251)
!264 = !DILocation(line: 137, column: 0, scope: !251)
!265 = !DILocation(line: 138, column: 0, scope: !251)
!266 = !DILocation(line: 141, column: 0, scope: !251)
!267 = !DILocation(line: 142, column: 0, scope: !251)
!268 = !DILocation(line: 143, column: 0, scope: !251)
!269 = !DILocation(line: 144, column: 0, scope: !251)
!270 = !DILocation(line: 145, column: 0, scope: !251)
!271 = !DILocation(line: 146, column: 0, scope: !251)
!272 = !DILocation(line: 147, column: 0, scope: !251)
!273 = !DILocation(line: 150, column: 0, scope: !251)
!274 = !DILocation(line: 151, column: 0, scope: !251)
!275 = !DILocation(line: 152, column: 0, scope: !251)
!276 = !DILocation(line: 153, column: 0, scope: !251)
!277 = !DILocation(line: 154, column: 0, scope: !251)
!278 = !DILocation(line: 155, column: 0, scope: !251)
!279 = !DILocation(line: 156, column: 0, scope: !251)
!280 = !DILocation(line: 159, column: 0, scope: !251)
!281 = !DILocation(line: 160, column: 0, scope: !251)
!282 = !DILocation(line: 161, column: 0, scope: !251)
!283 = !DILocation(line: 162, column: 0, scope: !251)
!284 = !DILocation(line: 164, column: 0, scope: !251)
!285 = !DILocation(line: 165, column: 0, scope: !251)
!286 = !DILocation(line: 166, column: 0, scope: !251)
!287 = !DILocation(line: 167, column: 0, scope: !251)
!288 = !DILocation(line: 168, column: 0, scope: !251)
!289 = !DILocation(line: 169, column: 0, scope: !251)

; TBAA metadata
!0 = !{!"NOVA TBAA"}
!1 = !{!"list_data_ptr", !0}
!2 = !{!1, !1, i64 0}
!3 = !{!"list_elem", !0}
!4 = !{!3, !3, i64 0}
!5 = !{!"list_size", !0}
!6 = !{!5, !5, i64 0}
!90 = !{!"branch_weights", i32 2000, i32 1}
