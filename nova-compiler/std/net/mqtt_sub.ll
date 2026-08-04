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

; ESCAPE _mqs_enc_varint: allocs=0 escape=0 local=0
define i64 @_mqs_enc_varint(i64 %p0, i64 %p1) nounwind uwtable !dbg !200 {
entry:
  %slot.out = alloca i64, align 8, !dbg !201
  store i64 %p0, ptr %slot.out, align 8, !dbg !201
  %slot.v = alloca i64, align 8, !dbg !201
  store i64 %p1, ptr %slot.v, align 8, !dbg !201
  %slot.done = alloca i64, align 8, !dbg !201
  store i64 0, ptr %slot.done, align 8, !dbg !201
  %slot.enc_byte = alloca i64, align 8, !dbg !201
  store i64 0, ptr %slot.enc_byte, align 8, !dbg !201
  %r0 = add i64 0, 0, !dbg !202
  store i64 %r0, ptr %slot.done, align 8, !dbg !202
  br label %while_hdr0, !dbg !203
while_hdr0:
  %r1 = load i64, ptr %slot.done, align 8, !dbg !203
  %r2 = add i64 0, 0, !dbg !203
  %r3.cmp = icmp eq i64 %r1, %r2, !dbg !203
  %r3 = zext i1 %r3.cmp to i64, !dbg !203
  %br_while_body10 = icmp ne i64 %r3, 0, !dbg !203
  br i1 %br_while_body10, label %while_body1, label %while_exit2, !prof !90, !dbg !203
while_body1:
  %r4 = load i64, ptr %slot.v, align 8, !dbg !204
  %r5 = add i64 127, 0, !dbg !204
  %r6 = and i64 %r4, %r5, !dbg !204
  store i64 %r6, ptr %slot.enc_byte, align 8, !dbg !204
  %r7 = load i64, ptr %slot.v, align 8, !dbg !205
  %r8 = add i64 7, 0, !dbg !205
  %r9.sramt = and i64 %r8, 63, !dbg !205
  %r9.srbig = icmp uge i64 %r8, 64, !dbg !205
  %r9.srval = ashr i64 %r7, %r9.sramt, !dbg !205
  %r9.srext = ashr i64 %r7, 63, !dbg !205
  %r9 = select i1 %r9.srbig, i64 %r9.srext, i64 %r9.srval, !dbg !205
  store i64 %r9, ptr %slot.v, align 8, !dbg !205
  %r10 = add i64 %r9, 0, !dbg !206
  %r11 = add i64 0, 0, !dbg !206
  %r12 = call i64 @nova_rt_gt(i64 %r10, i64 %r11), !dbg !206
  %br_then31 = icmp ne i64 %r12, 0, !dbg !206
  br i1 %br_then31, label %then3, label %else4, !dbg !206
then3:
  %r13 = load i64, ptr %slot.enc_byte, align 8, !dbg !207
  %r14 = add i64 128, 0, !dbg !207
  %r15 = or i64 %r13, %r14, !dbg !207
  store i64 %r15, ptr %slot.enc_byte, align 8, !dbg !207
  br label %endif5, !dbg !207
else4:
  br label %endif5, !dbg !207
endif5:
  %r16 = load i64, ptr %slot.out, align 8, !dbg !208
  %r17 = load i64, ptr %slot.enc_byte, align 8, !dbg !208
  %r18 = call i64 @nova_rt_list_append(i64 %r16, i64 %r17), !dbg !208
  %r19 = load i64, ptr %slot.v, align 8, !dbg !209
  %r20 = add i64 0, 0, !dbg !209
  %r21 = call i64 @nova_rt_eq(i64 %r19, i64 %r20), !dbg !209
  %br_then62 = icmp ne i64 %r21, 0, !dbg !209
  br i1 %br_then62, label %then6, label %else7, !dbg !209
then6:
  %r22 = add i64 1, 0, !dbg !210
  store i64 %r22, ptr %slot.done, align 8, !dbg !210
  br label %endif8, !dbg !210
else7:
  br label %endif8, !dbg !210
endif8:
  br label %while_hdr0, !dbg !210
while_exit2:
  %r23 = load i64, ptr %slot.out, align 8, !dbg !211
  ret i64 %r23, !dbg !211
}

; ESCAPE _mqs_push_u16: allocs=0 escape=0 local=0
define i64 @_mqs_push_u16(i64 %p0, i64 %p1) nounwind uwtable !dbg !212 {
entry:
  %slot.out = alloca i64, align 8, !dbg !213
  store i64 %p0, ptr %slot.out, align 8, !dbg !213
  %slot.v = alloca i64, align 8, !dbg !213
  store i64 %p1, ptr %slot.v, align 8, !dbg !213
  %r0 = load i64, ptr %slot.out, align 8, !dbg !214
  %r1 = load i64, ptr %slot.v, align 8, !dbg !214
  %r2 = add i64 8, 0, !dbg !214
  %r3.sramt = and i64 %r2, 63, !dbg !214
  %r3.srbig = icmp uge i64 %r2, 64, !dbg !214
  %r3.srval = ashr i64 %r1, %r3.sramt, !dbg !214
  %r3.srext = ashr i64 %r1, 63, !dbg !214
  %r3 = select i1 %r3.srbig, i64 %r3.srext, i64 %r3.srval, !dbg !214
  %r4 = add i64 255, 0, !dbg !214
  %r5 = and i64 %r3, %r4, !dbg !214
  %r6 = call i64 @nova_rt_list_append(i64 %r0, i64 %r5), !dbg !214
  %r7 = load i64, ptr %slot.out, align 8, !dbg !215
  %r8 = load i64, ptr %slot.v, align 8, !dbg !215
  %r9 = add i64 255, 0, !dbg !215
  %r10 = and i64 %r8, %r9, !dbg !215
  %r11 = call i64 @nova_rt_list_append(i64 %r7, i64 %r10), !dbg !215
  %r12 = load i64, ptr %slot.out, align 8, !dbg !216
  ret i64 %r12, !dbg !216
}

; ESCAPE _mqs_push_str: allocs=0 escape=0 local=0
define i64 @_mqs_push_str(i64 %p0, i64 %p1) nounwind uwtable !dbg !217 {
entry:
  %slot.out = alloca i64, align 8, !dbg !218
  store i64 %p0, ptr %slot.out, align 8, !dbg !218
  %slot.s = alloca i64, align 8, !dbg !218
  store i64 %p1, ptr %slot.s, align 8, !dbg !218
  %slot.n = alloca i64, align 8, !dbg !218
  store i64 0, ptr %slot.n, align 8, !dbg !218
  %slot.i = alloca i64, align 8, !dbg !218
  store i64 0, ptr %slot.i, align 8, !dbg !218
  %r0 = load i64, ptr %slot.s, align 8, !dbg !219
  %r1 = call i64 @nova_rt_len_any(i64 %r0), !dbg !219
  store i64 %r1, ptr %slot.n, align 8, !dbg !219
  %r2 = load i64, ptr %slot.out, align 8, !dbg !220
  %r3 = add i64 %r1, 0, !dbg !220
  %r4 = call i64 @_mqs_push_u16(i64 %r2, i64 %r3), !dbg !220
  store i64 %r4, ptr %slot.out, align 8, !dbg !220
  %r5 = add i64 0, 0, !dbg !221
  store i64 %r5, ptr %slot.i, align 8, !dbg !221
  br label %while_hdr9, !dbg !222
while_hdr9:
  %r6 = load i64, ptr %slot.i, align 8, !dbg !222
  %r7 = load i64, ptr %slot.n, align 8, !dbg !222
  %r8.cmp = icmp slt i64 %r6, %r7, !dbg !222
  %r8 = zext i1 %r8.cmp to i64, !dbg !222
  %br_while_body100 = icmp ne i64 %r8, 0, !dbg !222
  br i1 %br_while_body100, label %while_body10, label %while_exit11, !prof !90, !dbg !222
while_body10:
  %r9 = load i64, ptr %slot.out, align 8, !dbg !223
  %r10 = load i64, ptr %slot.s, align 8, !dbg !223
  %r11 = load i64, ptr %slot.i, align 8, !dbg !223
  %r12 = load i64, ptr %slot.i, align 8, !dbg !223
  %r13 = add i64 1, 0, !dbg !223
  %r14 = add i64 %r12, %r13, !dbg !223
  %r15 = call i64 @nova_rt_slice(i64 %r10, i64 %r11, i64 %r14), !dbg !223
  %r16 = call i64 @nova_rt_ord(i64 %r15), !dbg !223
  %r17 = call i64 @nova_rt_list_append(i64 %r9, i64 %r16), !dbg !223
  %r18 = load i64, ptr %slot.i, align 8, !dbg !224
  %r19 = add i64 1, 0, !dbg !224
  %r20 = add i64 %r18, %r19, !dbg !224
  store i64 %r20, ptr %slot.i, align 8, !dbg !224
  br label %while_hdr9, !dbg !224
while_exit11:
  %r21 = load i64, ptr %slot.out, align 8, !dbg !225
  ret i64 %r21, !dbg !225
}

; ESCAPE _mqs_dec_varint: allocs=1 escape=1 local=0
define i64 @_mqs_dec_varint(i64 %p0, i64 %p1) nounwind uwtable !dbg !226 {
entry:
  %slot.pkt = alloca i64, align 8, !dbg !227
  store i64 %p0, ptr %slot.pkt, align 8, !dbg !227
  %slot.pos = alloca i64, align 8, !dbg !227
  store i64 %p1, ptr %slot.pos, align 8, !dbg !227
  %slot.value = alloca i64, align 8, !dbg !227
  store i64 0, ptr %slot.value, align 8, !dbg !227
  %slot.shift = alloca i64, align 8, !dbg !227
  store i64 0, ptr %slot.shift, align 8, !dbg !227
  %slot.more = alloca i64, align 8, !dbg !227
  store i64 0, ptr %slot.more, align 8, !dbg !227
  %slot.__sc_15 = alloca i64, align 8, !dbg !227
  store i64 0, ptr %slot.__sc_15, align 8, !dbg !227
  %slot.b = alloca i64, align 8, !dbg !227
  store i64 0, ptr %slot.b, align 8, !dbg !227
  %slot.result = alloca i64, align 8, !dbg !227
  store i64 0, ptr %slot.result, align 8, !dbg !227
  %r0 = add i64 0, 0, !dbg !228
  store i64 %r0, ptr %slot.value, align 8, !dbg !228
  %r1 = add i64 0, 0, !dbg !229
  store i64 %r1, ptr %slot.shift, align 8, !dbg !229
  %r2 = add i64 1, 0, !dbg !230
  store i64 %r2, ptr %slot.more, align 8, !dbg !230
  br label %while_hdr12, !dbg !231
while_hdr12:
  %r3 = load i64, ptr %slot.more, align 8, !dbg !231
  %r4 = add i64 1, 0, !dbg !231
  %r5.cmp = icmp eq i64 %r3, %r4, !dbg !231
  %r5 = zext i1 %r5.cmp to i64, !dbg !231
  store i64 %r5, ptr %slot.__sc_15, align 8, !dbg !231
  %br_and_rhs160 = icmp ne i64 %r5, 0, !dbg !231
  br i1 %br_and_rhs160, label %and_rhs16, label %and_merge17, !dbg !231
and_rhs16:
  %r6 = load i64, ptr %slot.pos, align 8, !dbg !231
  %r7 = load i64, ptr %slot.pkt, align 8, !dbg !231
  %r8 = call i64 @nova_rt_len_any(i64 %r7), !dbg !231
  %r9.cmp = icmp slt i64 %r6, %r8, !dbg !231
  %r9 = zext i1 %r9.cmp to i64, !dbg !231
  store i64 %r9, ptr %slot.__sc_15, align 8, !dbg !231
  br label %and_merge17, !dbg !231
and_merge17:
  %r10 = load i64, ptr %slot.__sc_15, align 8, !dbg !231
  %br_while_body131 = icmp ne i64 %r10, 0, !dbg !231
  br i1 %br_while_body131, label %while_body13, label %while_exit14, !prof !90, !dbg !231
while_body13:
  %r11 = load i64, ptr %slot.pkt, align 8, !dbg !232
  %r12 = load i64, ptr %slot.pos, align 8, !dbg !232
  %r13 = call i64 @nova_rt_index_get(i64 %r11, i64 %r12), !dbg !232
  store i64 %r13, ptr %slot.b, align 8, !dbg !232
  %r14 = load i64, ptr %slot.pos, align 8, !dbg !233
  %r15 = add i64 1, 0, !dbg !233
  %r16 = add i64 %r14, %r15, !dbg !233
  store i64 %r16, ptr %slot.pos, align 8, !dbg !233
  %r17 = load i64, ptr %slot.value, align 8, !dbg !234
  %r18 = add i64 %r13, 0, !dbg !234
  %r19 = add i64 127, 0, !dbg !234
  %r20 = and i64 %r18, %r19, !dbg !234
  %r21 = load i64, ptr %slot.shift, align 8, !dbg !234
  %r22.shamt = and i64 %r21, 63, !dbg !234
  %r22.shbig = icmp uge i64 %r21, 64, !dbg !234
  %r22.shval = shl i64 %r20, %r22.shamt, !dbg !234
  %r22 = select i1 %r22.shbig, i64 0, i64 %r22.shval, !dbg !234
  %r23 = or i64 %r17, %r22, !dbg !234
  store i64 %r23, ptr %slot.value, align 8, !dbg !234
  %r24 = load i64, ptr %slot.shift, align 8, !dbg !235
  %r25 = add i64 7, 0, !dbg !235
  %r26 = add i64 %r24, %r25, !dbg !235
  store i64 %r26, ptr %slot.shift, align 8, !dbg !235
  %r27 = add i64 %r13, 0, !dbg !236
  %r28 = add i64 128, 0, !dbg !236
  %r29 = and i64 %r27, %r28, !dbg !236
  %r30 = add i64 0, 0, !dbg !236
  %r31 = call i64 @nova_rt_eq(i64 %r29, i64 %r30), !dbg !236
  %br_then182 = icmp ne i64 %r31, 0, !dbg !236
  br i1 %br_then182, label %then18, label %else19, !dbg !236
then18:
  %r32 = add i64 0, 0, !dbg !237
  store i64 %r32, ptr %slot.more, align 8, !dbg !237
  br label %endif20, !dbg !237
else19:
  br label %endif20, !dbg !237
endif20:
  br label %while_hdr12, !dbg !237
while_exit14:
  %r33 = call i64 @nova_rt_list_create(), !dbg !238
  store i64 %r33, ptr %slot.result, align 8, !dbg !238
  %r34 = add i64 %r33, 0, !dbg !239
  %r35 = load i64, ptr %slot.value, align 8, !dbg !239
  %r36 = call i64 @nova_rt_list_append(i64 %r34, i64 %r35), !dbg !239
  %r37 = add i64 %r33, 0, !dbg !240
  %r38 = load i64, ptr %slot.pos, align 8, !dbg !240
  %r39 = call i64 @nova_rt_list_append(i64 %r37, i64 %r38), !dbg !240
  %r40 = add i64 %r33, 0, !dbg !241
  ret i64 %r40, !dbg !241
}

; ESCAPE _mqs_r16: allocs=0 escape=0 local=0
define i64 @_mqs_r16(i64 %p0, i64 %p1) nounwind uwtable !dbg !242 {
entry:
  %slot.pkt = alloca i64, align 8, !dbg !243
  store i64 %p0, ptr %slot.pkt, align 8, !dbg !243
  %slot.pos = alloca i64, align 8, !dbg !243
  store i64 %p1, ptr %slot.pos, align 8, !dbg !243
  %r0 = load i64, ptr %slot.pkt, align 8, !dbg !244
  %r1 = load i64, ptr %slot.pos, align 8, !dbg !244
  %r2 = call i64 @nova_rt_index_get(i64 %r0, i64 %r1), !dbg !244
  %r3 = add i64 8, 0, !dbg !244
  %r4.shamt = and i64 %r3, 63, !dbg !244
  %r4.shbig = icmp uge i64 %r3, 64, !dbg !244
  %r4.shval = shl i64 %r2, %r4.shamt, !dbg !244
  %r4 = select i1 %r4.shbig, i64 0, i64 %r4.shval, !dbg !244
  %r5 = load i64, ptr %slot.pkt, align 8, !dbg !244
  %r6 = load i64, ptr %slot.pos, align 8, !dbg !244
  %r7 = add i64 1, 0, !dbg !244
  %r8 = call i64 @nova_rt_add(i64 %r6, i64 %r7), !dbg !244
  %r9 = call i64 @nova_rt_index_get(i64 %r5, i64 %r8), !dbg !244
  %r10 = or i64 %r4, %r9, !dbg !244
  %r11 = add i64 65535, 0, !dbg !244
  %r12 = and i64 %r10, %r11, !dbg !244
  ret i64 %r12, !dbg !244
}

; ESCAPE _mqs_read_str: allocs=2 escape=2 local=0
define i64 @_mqs_read_str(i64 %p0, i64 %p1) nounwind uwtable !dbg !245 {
entry:
  %slot.pkt = alloca i64, align 8, !dbg !246
  store i64 %p0, ptr %slot.pkt, align 8, !dbg !246
  %slot.pos = alloca i64, align 8, !dbg !246
  store i64 %p1, ptr %slot.pos, align 8, !dbg !246
  %slot.pkt_len = alloca i64, align 8, !dbg !246
  store i64 0, ptr %slot.pkt_len, align 8, !dbg !246
  %slot.fail = alloca i64, align 8, !dbg !246
  store i64 0, ptr %slot.fail, align 8, !dbg !246
  %slot.slen = alloca i64, align 8, !dbg !246
  store i64 0, ptr %slot.slen, align 8, !dbg !246
  %slot.s = alloca i64, align 8, !dbg !246
  store i64 0, ptr %slot.s, align 8, !dbg !246
  %slot.i = alloca i64, align 8, !dbg !246
  store i64 0, ptr %slot.i, align 8, !dbg !246
  %slot.pkt__s4f112 = alloca i64, align 8, !dbg !246
  store i64 0, ptr %slot.pkt__s4f112, align 8, !dbg !246
  %slot.__sc_30 = alloca i64, align 8, !dbg !246
  store i64 0, ptr %slot.__sc_30, align 8, !dbg !246
  %slot.__sc_36 = alloca i64, align 8, !dbg !246
  store i64 0, ptr %slot.__sc_36, align 8, !dbg !246
  %slot.result = alloca i64, align 8, !dbg !246
  store i64 0, ptr %slot.result, align 8, !dbg !246
  %r0 = load i64, ptr %slot.pkt, align 8, !dbg !247
  %r1 = call i64 @nova_rt_len_any(i64 %r0), !dbg !247
  store i64 %r1, ptr %slot.pkt_len, align 8, !dbg !247
  %r2 = load i64, ptr %slot.pos, align 8, !dbg !248
  %r3 = add i64 1, 0, !dbg !248
  %r4 = call i64 @nova_rt_add(i64 %r2, i64 %r3), !dbg !248
  %r5 = add i64 %r1, 0, !dbg !248
  %r6 = call i64 @nova_rt_ge(i64 %r4, i64 %r5), !dbg !248
  %br_then210 = icmp ne i64 %r6, 0, !dbg !248
  br i1 %br_then210, label %then21, label %else22, !dbg !248
then21:
  %r7 = call i64 @nova_rt_list_create(), !dbg !249
  store i64 %r7, ptr %slot.fail, align 8, !dbg !249
  %r8 = add i64 %r7, 0, !dbg !250
  %r9.p = getelementptr inbounds [1 x i8], ptr @.str.0, i64 0, i64 0, !dbg !250
  %r9 = ptrtoint ptr %r9.p to i64, !dbg !250
  %r10 = call i64 @nova_rt_list_append(i64 %r8, i64 %r9), !dbg !250
  %r11 = add i64 %r7, 0, !dbg !251
  %r12 = load i64, ptr %slot.pos, align 8, !dbg !251
  %r13 = call i64 @nova_rt_list_append(i64 %r11, i64 %r12), !dbg !251
  %r14 = add i64 %r7, 0, !dbg !252
  ret i64 %r14, !dbg !252
else22:
  br label %endif23, !dbg !252
endif23:
  %r15 = load i64, ptr %slot.pkt, align 8, !dbg !253
  %r16 = load i64, ptr %slot.pos, align 8, !dbg !253
  %r17 = call i64 @_mqs_r16(i64 %r15, i64 %r16), !dbg !253
  store i64 %r17, ptr %slot.slen, align 8, !dbg !253
  %r18 = load i64, ptr %slot.pos, align 8, !dbg !254
  %r19 = add i64 2, 0, !dbg !254
  %r20 = call i64 @nova_rt_add(i64 %r18, i64 %r19), !dbg !254
  store i64 %r20, ptr %slot.pos, align 8, !dbg !254
  %r21.p = getelementptr inbounds [1 x i8], ptr @.str.0, i64 0, i64 0, !dbg !255
  %r21 = ptrtoint ptr %r21.p to i64, !dbg !255
  store i64 %r21, ptr %slot.s, align 8, !dbg !255
  %r22 = add i64 0, 0, !dbg !256
  store i64 %r22, ptr %slot.i, align 8, !dbg !256
  %r23 = load i64, ptr %slot.pkt, align 8, !dbg !257
  %r24 = call i64 @nova_rt_list_is_kind2(i64 %r23), !dbg !257
  %br_then241 = icmp ne i64 %r24, 0, !dbg !257
  br i1 %br_then241, label %then24, label %else25, !dbg !257
then24:
  %r25 = load i64, ptr %slot.pkt, align 8, !dbg !257
  %r26 = call i64 @nova_rt_floatlist_view(i64 %r25), !dbg !257
  store i64 %r26, ptr %slot.pkt__s4f112, align 8, !dbg !257
  br label %while_hdr27, !dbg !257
while_hdr27:
  %r27 = load i64, ptr %slot.i, align 8, !dbg !257
  %r28 = load i64, ptr %slot.slen, align 8, !dbg !257
  %r29.cmp = icmp slt i64 %r27, %r28, !dbg !257
  %r29 = zext i1 %r29.cmp to i64, !dbg !257
  store i64 %r29, ptr %slot.__sc_30, align 8, !dbg !257
  %br_and_rhs312 = icmp ne i64 %r29, 0, !dbg !257
  br i1 %br_and_rhs312, label %and_rhs31, label %and_merge32, !dbg !257
and_rhs31:
  %r30 = load i64, ptr %slot.pos, align 8, !dbg !257
  %r31 = load i64, ptr %slot.pkt_len, align 8, !dbg !257
  %r32 = call i64 @nova_rt_lt(i64 %r30, i64 %r31), !dbg !257
  store i64 %r32, ptr %slot.__sc_30, align 8, !dbg !257
  br label %and_merge32, !dbg !257
and_merge32:
  %r33 = load i64, ptr %slot.__sc_30, align 8, !dbg !257
  %br_while_body283 = icmp ne i64 %r33, 0, !dbg !257
  br i1 %br_while_body283, label %while_body28, label %while_exit29, !prof !90, !dbg !257
while_body28:
  %r34 = load i64, ptr %slot.s, align 8, !dbg !258
  %r35 = load i64, ptr %slot.pkt__s4f112, align 8, !dbg !258
  %r36 = load i64, ptr %slot.pos, align 8, !dbg !258
  %r37 = call i64 @nova_rt_list_get_f(i64 %r35, i64 %r36), !dbg !258
  %wbox0 = call i64 @nova_rt_box_float(i64 %r37), !dbg !258
  %r38 = call i64 @nova_rt_chr(i64 %wbox0), !dbg !258
  %r39 = call i64 @nova_rt_str_concat(i64 %r34, i64 %r38), !dbg !258
  store i64 %r39, ptr %slot.s, align 8, !dbg !258
  %r40 = load i64, ptr %slot.pos, align 8, !dbg !259
  %r41 = add i64 1, 0, !dbg !259
  %r42 = call i64 @nova_rt_add(i64 %r40, i64 %r41), !dbg !259
  store i64 %r42, ptr %slot.pos, align 8, !dbg !259
  %r43 = load i64, ptr %slot.i, align 8, !dbg !260
  %r44 = add i64 1, 0, !dbg !260
  %r45 = add i64 %r43, %r44, !dbg !260
  store i64 %r45, ptr %slot.i, align 8, !dbg !260
  br label %while_hdr27, !dbg !260
while_exit29:
  br label %endif26, !dbg !260
else25:
  br label %while_hdr33, !dbg !257
while_hdr33:
  %r46 = load i64, ptr %slot.i, align 8, !dbg !257
  %r47 = load i64, ptr %slot.slen, align 8, !dbg !257
  %r48.cmp = icmp slt i64 %r46, %r47, !dbg !257
  %r48 = zext i1 %r48.cmp to i64, !dbg !257
  store i64 %r48, ptr %slot.__sc_36, align 8, !dbg !257
  %br_and_rhs374 = icmp ne i64 %r48, 0, !dbg !257
  br i1 %br_and_rhs374, label %and_rhs37, label %and_merge38, !dbg !257
and_rhs37:
  %r49 = load i64, ptr %slot.pos, align 8, !dbg !257
  %r50 = load i64, ptr %slot.pkt_len, align 8, !dbg !257
  %r51 = call i64 @nova_rt_lt(i64 %r49, i64 %r50), !dbg !257
  store i64 %r51, ptr %slot.__sc_36, align 8, !dbg !257
  br label %and_merge38, !dbg !257
and_merge38:
  %r52 = load i64, ptr %slot.__sc_36, align 8, !dbg !257
  %br_while_body345 = icmp ne i64 %r52, 0, !dbg !257
  br i1 %br_while_body345, label %while_body34, label %while_exit35, !prof !90, !dbg !257
while_body34:
  %r53 = load i64, ptr %slot.s, align 8, !dbg !258
  %r54 = load i64, ptr %slot.pkt, align 8, !dbg !258
  %r55 = load i64, ptr %slot.pos, align 8, !dbg !258
  %r56 = call i64 @nova_rt_index_get(i64 %r54, i64 %r55), !dbg !258
  %r57 = call i64 @nova_rt_chr(i64 %r56), !dbg !258
  %r58 = call i64 @nova_rt_str_concat(i64 %r53, i64 %r57), !dbg !258
  store i64 %r58, ptr %slot.s, align 8, !dbg !258
  %r59 = load i64, ptr %slot.pos, align 8, !dbg !259
  %r60 = add i64 1, 0, !dbg !259
  %r61 = call i64 @nova_rt_add(i64 %r59, i64 %r60), !dbg !259
  store i64 %r61, ptr %slot.pos, align 8, !dbg !259
  %r62 = load i64, ptr %slot.i, align 8, !dbg !260
  %r63 = add i64 1, 0, !dbg !260
  %r64 = add i64 %r62, %r63, !dbg !260
  store i64 %r64, ptr %slot.i, align 8, !dbg !260
  br label %while_hdr33, !dbg !260
while_exit35:
  br label %endif26, !dbg !260
endif26:
  %r65 = call i64 @nova_rt_list_create(), !dbg !261
  store i64 %r65, ptr %slot.result, align 8, !dbg !261
  %r66 = add i64 %r65, 0, !dbg !262
  %r67 = load i64, ptr %slot.s, align 8, !dbg !262
  %r68 = call i64 @nova_rt_list_append(i64 %r66, i64 %r67), !dbg !262
  %r69 = add i64 %r65, 0, !dbg !263
  %r70 = load i64, ptr %slot.pos, align 8, !dbg !263
  %r71 = call i64 @nova_rt_list_append(i64 %r69, i64 %r70), !dbg !263
  %r72 = add i64 %r65, 0, !dbg !264
  ret i64 %r72, !dbg !264
}

; ESCAPE _mqs_init_payload: allocs=1 escape=0 local=1
define i64 @_mqs_init_payload(i64 %p0) nounwind uwtable !dbg !265 {
entry:
  %slot.packet_id = alloca i64, align 8, !dbg !266
  store i64 %p0, ptr %slot.packet_id, align 8, !dbg !266
  %slot.payload = alloca i64, align 8, !dbg !266
  store i64 0, ptr %slot.payload, align 8, !dbg !266
  %r0 = call i64 @nova_rt_list_create(), !dbg !267
  store i64 %r0, ptr %slot.payload, align 8, !dbg !267
  %r1 = add i64 %r0, 0, !dbg !268
  %r2 = load i64, ptr %slot.packet_id, align 8, !dbg !268
  %r3 = call i64 @_mqs_push_u16(i64 %r1, i64 %r2), !dbg !268
  store i64 %r3, ptr %slot.payload, align 8, !dbg !268
  %r4 = add i64 %r3, 0, !dbg !269
  ret i64 %r4, !dbg !269
}

; ESCAPE _mqs_frame: allocs=1 escape=1 local=0
define i64 @_mqs_frame(i64 %p0, i64 %p1) nounwind uwtable !dbg !270 {
entry:
  %slot.header_byte = alloca i64, align 8, !dbg !271
  store i64 %p0, ptr %slot.header_byte, align 8, !dbg !271
  %slot.payload = alloca i64, align 8, !dbg !271
  store i64 %p1, ptr %slot.payload, align 8, !dbg !271
  %slot.rem_len = alloca i64, align 8, !dbg !271
  store i64 0, ptr %slot.rem_len, align 8, !dbg !271
  %slot.out = alloca i64, align 8, !dbg !271
  store i64 0, ptr %slot.out, align 8, !dbg !271
  %slot.pi = alloca i64, align 8, !dbg !271
  store i64 0, ptr %slot.pi, align 8, !dbg !271
  %slot.payload__s4f138 = alloca i64, align 8, !dbg !271
  store i64 0, ptr %slot.payload__s4f138, align 8, !dbg !271
  %r0 = load i64, ptr %slot.payload, align 8, !dbg !272
  %r1.lp = inttoptr i64 %r0 to ptr, !dbg !272
  %r1.szp = getelementptr i64, ptr %r1.lp, i64 1, !dbg !272
  %r1 = load i64, ptr %r1.szp, align 8, !tbaa !6, !dbg !272
  store i64 %r1, ptr %slot.rem_len, align 8, !dbg !272
  %r2 = call i64 @nova_rt_list_create(), !dbg !273
  store i64 %r2, ptr %slot.out, align 8, !dbg !273
  %r3 = add i64 %r2, 0, !dbg !274
  %r4 = load i64, ptr %slot.header_byte, align 8, !dbg !274
  %r5 = call i64 @nova_rt_list_append(i64 %r3, i64 %r4), !dbg !274
  %r6 = add i64 %r2, 0, !dbg !275
  %r7 = add i64 %r1, 0, !dbg !275
  %r8 = call i64 @_mqs_enc_varint(i64 %r6, i64 %r7), !dbg !275
  store i64 %r8, ptr %slot.out, align 8, !dbg !275
  %r9 = add i64 0, 0, !dbg !276
  store i64 %r9, ptr %slot.pi, align 8, !dbg !276
  %r10 = load i64, ptr %slot.payload, align 8, !dbg !277
  %r11 = call i64 @nova_rt_list_is_kind2(i64 %r10), !dbg !277
  %br_then390 = icmp ne i64 %r11, 0, !dbg !277
  br i1 %br_then390, label %then39, label %else40, !dbg !277
then39:
  %r12 = load i64, ptr %slot.payload, align 8, !dbg !277
  %r13 = call i64 @nova_rt_floatlist_view(i64 %r12), !dbg !277
  store i64 %r13, ptr %slot.payload__s4f138, align 8, !dbg !277
  br label %while_hdr42, !dbg !277
while_hdr42:
  %r14 = load i64, ptr %slot.pi, align 8, !dbg !277
  %r15 = load i64, ptr %slot.rem_len, align 8, !dbg !277
  %r16.cmp = icmp slt i64 %r14, %r15, !dbg !277
  %r16 = zext i1 %r16.cmp to i64, !dbg !277
  %br_while_body431 = icmp ne i64 %r16, 0, !dbg !277
  br i1 %br_while_body431, label %while_body43, label %while_exit44, !prof !90, !dbg !277
while_body43:
  %r17 = load i64, ptr %slot.out, align 8, !dbg !278
  %r18 = load i64, ptr %slot.payload__s4f138, align 8, !dbg !278
  %r19 = load i64, ptr %slot.pi, align 8, !dbg !278
  %r20 = call i64 @nova_rt_list_get_f(i64 %r18, i64 %r19), !dbg !278
  %r21 = call i64 @nova_rt_list_append_fbox(i64 %r17, i64 %r20), !dbg !278
  %r22 = load i64, ptr %slot.pi, align 8, !dbg !279
  %r23 = add i64 1, 0, !dbg !279
  %r24 = add i64 %r22, %r23, !dbg !279
  store i64 %r24, ptr %slot.pi, align 8, !dbg !279
  br label %while_hdr42, !dbg !279
while_exit44:
  br label %endif41, !dbg !279
else40:
  br label %while_hdr45, !dbg !277
while_hdr45:
  %r25 = load i64, ptr %slot.pi, align 8, !dbg !277
  %r26 = load i64, ptr %slot.rem_len, align 8, !dbg !277
  %r27.cmp = icmp slt i64 %r25, %r26, !dbg !277
  %r27 = zext i1 %r27.cmp to i64, !dbg !277
  %br_while_body462 = icmp ne i64 %r27, 0, !dbg !277
  br i1 %br_while_body462, label %while_body46, label %while_exit47, !prof !90, !dbg !277
while_body46:
  %r28 = load i64, ptr %slot.out, align 8, !dbg !278
  %r29 = load i64, ptr %slot.payload, align 8, !dbg !278
  %r30 = load i64, ptr %slot.pi, align 8, !dbg !278
  %r31 = call i64 @nova_rt_list_get(i64 %r29, i64 %r30), !dbg !278
  %r32 = call i64 @nova_rt_list_append(i64 %r28, i64 %r31), !dbg !278
  %r33 = load i64, ptr %slot.pi, align 8, !dbg !279
  %r34 = add i64 1, 0, !dbg !279
  %r35 = add i64 %r33, %r34, !dbg !279
  store i64 %r35, ptr %slot.pi, align 8, !dbg !279
  br label %while_hdr45, !dbg !279
while_exit47:
  br label %endif41, !dbg !279
endif41:
  %r36 = load i64, ptr %slot.out, align 8, !dbg !280
  ret i64 %r36, !dbg !280
}

; ESCAPE mqtt_subscribe: allocs=0 escape=0 local=0
define i64 @mqtt_subscribe(i64 %p0, i64 %p1) nounwind uwtable !dbg !281 {
entry:
  %slot.packet_id = alloca i64, align 8, !dbg !282
  store i64 %p0, ptr %slot.packet_id, align 8, !dbg !282
  %slot.filters = alloca i64, align 8, !dbg !282
  store i64 %p1, ptr %slot.filters, align 8, !dbg !282
  %slot.payload = alloca i64, align 8, !dbg !282
  store i64 0, ptr %slot.payload, align 8, !dbg !282
  %slot.fi = alloca i64, align 8, !dbg !282
  store i64 0, ptr %slot.fi, align 8, !dbg !282
  %slot.flen = alloca i64, align 8, !dbg !282
  store i64 0, ptr %slot.flen, align 8, !dbg !282
  %slot.filters__s4f154 = alloca i64, align 8, !dbg !282
  store i64 0, ptr %slot.filters__s4f154, align 8, !dbg !282
  %slot.entry__s4f154 = alloca i64, align 8, !dbg !282
  store i64 0, ptr %slot.entry__s4f154, align 8, !dbg !282
  %slot.topic__s4f154 = alloca i64, align 8, !dbg !282
  store i64 0, ptr %slot.topic__s4f154, align 8, !dbg !282
  %slot.qos__s4f154 = alloca i64, align 8, !dbg !282
  store i64 0, ptr %slot.qos__s4f154, align 8, !dbg !282
  %slot.entry = alloca i64, align 8, !dbg !282
  store i64 0, ptr %slot.entry, align 8, !dbg !282
  %slot.topic = alloca i64, align 8, !dbg !282
  store i64 0, ptr %slot.topic, align 8, !dbg !282
  %slot.qos = alloca i64, align 8, !dbg !282
  store i64 0, ptr %slot.qos, align 8, !dbg !282
  %r0 = load i64, ptr %slot.packet_id, align 8, !dbg !283
  %r1 = call i64 @_mqs_init_payload(i64 %r0), !dbg !283
  store i64 %r1, ptr %slot.payload, align 8, !dbg !283
  %r2 = add i64 0, 0, !dbg !284
  store i64 %r2, ptr %slot.fi, align 8, !dbg !284
  %r3 = load i64, ptr %slot.filters, align 8, !dbg !285
  %r4 = call i64 @nova_rt_len_any(i64 %r3), !dbg !285
  store i64 %r4, ptr %slot.flen, align 8, !dbg !285
  %r5 = load i64, ptr %slot.filters, align 8, !dbg !286
  %r6 = call i64 @nova_rt_list_is_kind2(i64 %r5), !dbg !286
  %br_then480 = icmp ne i64 %r6, 0, !dbg !286
  br i1 %br_then480, label %then48, label %else49, !dbg !286
then48:
  %r7 = load i64, ptr %slot.filters, align 8, !dbg !286
  %r8 = call i64 @nova_rt_floatlist_view(i64 %r7), !dbg !286
  store i64 %r8, ptr %slot.filters__s4f154, align 8, !dbg !286
  br label %while_hdr51, !dbg !286
while_hdr51:
  %r9 = load i64, ptr %slot.fi, align 8, !dbg !286
  %r10 = load i64, ptr %slot.flen, align 8, !dbg !286
  %r11.cmp = icmp slt i64 %r9, %r10, !dbg !286
  %r11 = zext i1 %r11.cmp to i64, !dbg !286
  %br_while_body521 = icmp ne i64 %r11, 0, !dbg !286
  br i1 %br_while_body521, label %while_body52, label %while_exit53, !prof !90, !dbg !286
while_body52:
  %r12 = load i64, ptr %slot.filters__s4f154, align 8, !dbg !287
  %r13 = load i64, ptr %slot.fi, align 8, !dbg !287
  %r14 = call i64 @nova_rt_list_get_f(i64 %r12, i64 %r13), !dbg !287
  store i64 %r14, ptr %slot.entry__s4f154, align 8, !dbg !287
  %r15 = add i64 %r14, 0, !dbg !288
  %r16 = add i64 0, 0, !dbg !288
  %r17 = call i64 @nova_rt_index_get(i64 %r15, i64 %r16), !dbg !288
  store i64 %r17, ptr %slot.topic__s4f154, align 8, !dbg !288
  %r18 = add i64 %r14, 0, !dbg !289
  %r19 = add i64 1, 0, !dbg !289
  %r20 = call i64 @nova_rt_index_get(i64 %r18, i64 %r19), !dbg !289
  store i64 %r20, ptr %slot.qos__s4f154, align 8, !dbg !289
  %r21 = load i64, ptr %slot.payload, align 8, !dbg !290
  %r22 = add i64 %r17, 0, !dbg !290
  %r23 = call i64 @_mqs_push_str(i64 %r21, i64 %r22), !dbg !290
  store i64 %r23, ptr %slot.payload, align 8, !dbg !290
  %r24 = add i64 %r23, 0, !dbg !291
  %r25 = add i64 %r20, 0, !dbg !291
  %r26 = add i64 3, 0, !dbg !291
  %r27 = and i64 %r25, %r26, !dbg !291
  %r28 = call i64 @nova_rt_list_append(i64 %r24, i64 %r27), !dbg !291
  %r29 = load i64, ptr %slot.fi, align 8, !dbg !292
  %r30 = add i64 1, 0, !dbg !292
  %r31 = add i64 %r29, %r30, !dbg !292
  store i64 %r31, ptr %slot.fi, align 8, !dbg !292
  br label %while_hdr51, !dbg !292
while_exit53:
  br label %endif50, !dbg !292
else49:
  br label %while_hdr54, !dbg !286
while_hdr54:
  %r32 = load i64, ptr %slot.fi, align 8, !dbg !286
  %r33 = load i64, ptr %slot.flen, align 8, !dbg !286
  %r34.cmp = icmp slt i64 %r32, %r33, !dbg !286
  %r34 = zext i1 %r34.cmp to i64, !dbg !286
  %br_while_body552 = icmp ne i64 %r34, 0, !dbg !286
  br i1 %br_while_body552, label %while_body55, label %while_exit56, !prof !90, !dbg !286
while_body55:
  %r35 = load i64, ptr %slot.filters, align 8, !dbg !287
  %r36 = load i64, ptr %slot.fi, align 8, !dbg !287
  %r37 = call i64 @nova_rt_index_get(i64 %r35, i64 %r36), !dbg !287
  store i64 %r37, ptr %slot.entry, align 8, !dbg !287
  %r38 = add i64 %r37, 0, !dbg !288
  %r39 = add i64 0, 0, !dbg !288
  %r40 = call i64 @nova_rt_index_get(i64 %r38, i64 %r39), !dbg !288
  store i64 %r40, ptr %slot.topic, align 8, !dbg !288
  %r41 = add i64 %r37, 0, !dbg !289
  %r42 = add i64 1, 0, !dbg !289
  %r43 = call i64 @nova_rt_index_get(i64 %r41, i64 %r42), !dbg !289
  store i64 %r43, ptr %slot.qos, align 8, !dbg !289
  %r44 = load i64, ptr %slot.payload, align 8, !dbg !290
  %r45 = add i64 %r40, 0, !dbg !290
  %r46 = call i64 @_mqs_push_str(i64 %r44, i64 %r45), !dbg !290
  store i64 %r46, ptr %slot.payload, align 8, !dbg !290
  %r47 = add i64 %r46, 0, !dbg !291
  %r48 = add i64 %r43, 0, !dbg !291
  %r49 = add i64 3, 0, !dbg !291
  %r50 = and i64 %r48, %r49, !dbg !291
  %r51 = call i64 @nova_rt_list_append(i64 %r47, i64 %r50), !dbg !291
  %r52 = load i64, ptr %slot.fi, align 8, !dbg !292
  %r53 = add i64 1, 0, !dbg !292
  %r54 = add i64 %r52, %r53, !dbg !292
  store i64 %r54, ptr %slot.fi, align 8, !dbg !292
  br label %while_hdr54, !dbg !292
while_exit56:
  br label %endif50, !dbg !292
endif50:
  %r55 = add i64 130, 0, !dbg !293
  %r56 = load i64, ptr %slot.payload, align 8, !dbg !293
  %r57 = call i64 @_mqs_frame(i64 %r55, i64 %r56), !dbg !293
  ret i64 %r57, !dbg !293
}

; ESCAPE mqtt_subscribe_decode: allocs=4 escape=3 local=1
define i64 @mqtt_subscribe_decode(i64 %p0) nounwind uwtable !dbg !294 {
entry:
  %slot.pkt = alloca i64, align 8, !dbg !295
  store i64 %p0, ptr %slot.pkt, align 8, !dbg !295
  %slot.result = alloca i64, align 8, !dbg !295
  store i64 0, ptr %slot.result, align 8, !dbg !295
  %slot.pkt_len = alloca i64, align 8, !dbg !295
  store i64 0, ptr %slot.pkt_len, align 8, !dbg !295
  %slot.fh = alloca i64, align 8, !dbg !295
  store i64 0, ptr %slot.fh, align 8, !dbg !295
  %slot.vr = alloca i64, align 8, !dbg !295
  store i64 0, ptr %slot.vr, align 8, !dbg !295
  %slot.rem_len = alloca i64, align 8, !dbg !295
  store i64 0, ptr %slot.rem_len, align 8, !dbg !295
  %slot.pos = alloca i64, align 8, !dbg !295
  store i64 0, ptr %slot.pos, align 8, !dbg !295
  %slot.pid = alloca i64, align 8, !dbg !295
  store i64 0, ptr %slot.pid, align 8, !dbg !295
  %slot.filter_list = alloca i64, align 8, !dbg !295
  store i64 0, ptr %slot.filter_list, align 8, !dbg !295
  %slot.end_pos = alloca i64, align 8, !dbg !295
  store i64 0, ptr %slot.end_pos, align 8, !dbg !295
  %slot.sr = alloca i64, align 8, !dbg !295
  store i64 0, ptr %slot.sr, align 8, !dbg !295
  %slot.topic = alloca i64, align 8, !dbg !295
  store i64 0, ptr %slot.topic, align 8, !dbg !295
  %slot.bad = alloca i64, align 8, !dbg !295
  store i64 0, ptr %slot.bad, align 8, !dbg !295
  %slot.qos = alloca i64, align 8, !dbg !295
  store i64 0, ptr %slot.qos, align 8, !dbg !295
  %slot.pair = alloca i64, align 8, !dbg !295
  store i64 0, ptr %slot.pair, align 8, !dbg !295
  %r0 = call i64 @nova_rt_dict_create(), !dbg !296
  store i64 %r0, ptr %slot.result, align 8, !dbg !296
  %r1 = load i64, ptr %slot.pkt, align 8, !dbg !297
  %r2 = call i64 @nova_rt_len_any(i64 %r1), !dbg !297
  store i64 %r2, ptr %slot.pkt_len, align 8, !dbg !297
  %r3 = add i64 %r2, 0, !dbg !298
  %r4 = add i64 4, 0, !dbg !298
  %r5.cmp = icmp slt i64 %r3, %r4, !dbg !298
  %r5 = zext i1 %r5.cmp to i64, !dbg !298
  %br_then570 = icmp ne i64 %r5, 0, !dbg !298
  br i1 %br_then570, label %then57, label %else58, !dbg !298
then57:
  %r6 = load i64, ptr %slot.result, align 8, !dbg !299
  ret i64 %r6, !dbg !299
else58:
  br label %endif59, !dbg !299
endif59:
  %r7 = load i64, ptr %slot.pkt, align 8, !dbg !300
  %r8 = add i64 0, 0, !dbg !300
  %r9 = call i64 @nova_rt_index_get(i64 %r7, i64 %r8), !dbg !300
  store i64 %r9, ptr %slot.fh, align 8, !dbg !300
  %r10 = add i64 %r9, 0, !dbg !301
  %r11 = add i64 130, 0, !dbg !301
  %r12 = call i64 @nova_rt_neq(i64 %r10, i64 %r11), !dbg !301
  %br_then601 = icmp ne i64 %r12, 0, !dbg !301
  br i1 %br_then601, label %then60, label %else61, !dbg !301
then60:
  %r13 = load i64, ptr %slot.result, align 8, !dbg !302
  ret i64 %r13, !dbg !302
else61:
  br label %endif62, !dbg !302
endif62:
  %r14 = load i64, ptr %slot.pkt, align 8, !dbg !303
  %r15 = add i64 1, 0, !dbg !303
  %r16 = call i64 @_mqs_dec_varint(i64 %r14, i64 %r15), !dbg !303
  store i64 %r16, ptr %slot.vr, align 8, !dbg !303
  %r17 = add i64 %r16, 0, !dbg !304
  %r18 = add i64 0, 0, !dbg !304
  %r19 = call i64 @nova_rt_index_get(i64 %r17, i64 %r18), !dbg !304
  store i64 %r19, ptr %slot.rem_len, align 8, !dbg !304
  %r20 = add i64 %r16, 0, !dbg !305
  %r21 = add i64 1, 0, !dbg !305
  %r22 = call i64 @nova_rt_index_get(i64 %r20, i64 %r21), !dbg !305
  store i64 %r22, ptr %slot.pos, align 8, !dbg !305
  %r23 = add i64 %r22, 0, !dbg !306
  %r24 = add i64 %r19, 0, !dbg !306
  %r25 = call i64 @nova_rt_add(i64 %r23, i64 %r24), !dbg !306
  %r26 = load i64, ptr %slot.pkt_len, align 8, !dbg !306
  %r27 = call i64 @nova_rt_gt(i64 %r25, i64 %r26), !dbg !306
  %br_then632 = icmp ne i64 %r27, 0, !dbg !306
  br i1 %br_then632, label %then63, label %else64, !dbg !306
then63:
  %r28 = load i64, ptr %slot.result, align 8, !dbg !307
  ret i64 %r28, !dbg !307
else64:
  br label %endif65, !dbg !307
endif65:
  %r29 = load i64, ptr %slot.pos, align 8, !dbg !308
  %r30 = add i64 1, 0, !dbg !308
  %r31 = call i64 @nova_rt_add(i64 %r29, i64 %r30), !dbg !308
  %r32 = load i64, ptr %slot.pkt_len, align 8, !dbg !308
  %r33 = call i64 @nova_rt_ge(i64 %r31, i64 %r32), !dbg !308
  %br_then663 = icmp ne i64 %r33, 0, !dbg !308
  br i1 %br_then663, label %then66, label %else67, !dbg !308
then66:
  %r34 = load i64, ptr %slot.result, align 8, !dbg !309
  ret i64 %r34, !dbg !309
else67:
  br label %endif68, !dbg !309
endif68:
  %r35 = load i64, ptr %slot.pkt, align 8, !dbg !310
  %r36 = load i64, ptr %slot.pos, align 8, !dbg !310
  %r37 = call i64 @_mqs_r16(i64 %r35, i64 %r36), !dbg !310
  store i64 %r37, ptr %slot.pid, align 8, !dbg !310
  %r38 = load i64, ptr %slot.pos, align 8, !dbg !311
  %r39 = add i64 2, 0, !dbg !311
  %r40 = call i64 @nova_rt_add(i64 %r38, i64 %r39), !dbg !311
  store i64 %r40, ptr %slot.pos, align 8, !dbg !311
  %r41 = add i64 %r37, 0, !dbg !312
  %r42 = load i64, ptr %slot.result, align 8, !dbg !312
  %r43.p = getelementptr inbounds [10 x i8], ptr @.str.1, i64 0, i64 0, !dbg !312
  %r43 = ptrtoint ptr %r43.p to i64, !dbg !312
  %_is.dv4 = call i64 @nova_rt_dict_set(i64 %r42, i64 %r43, i64 %r41), !dbg !312
  %r44 = call i64 @nova_rt_list_create(), !dbg !313
  store i64 %r44, ptr %slot.filter_list, align 8, !dbg !313
  %r45 = add i64 %r40, 0, !dbg !314
  %r46 = load i64, ptr %slot.rem_len, align 8, !dbg !314
  %r47 = call i64 @nova_rt_add(i64 %r45, i64 %r46), !dbg !314
  %r48 = add i64 2, 0, !dbg !314
  %r49 = call i64 @nova_rt_sub(i64 %r47, i64 %r48), !dbg !314
  store i64 %r49, ptr %slot.end_pos, align 8, !dbg !314
  br label %while_hdr69, !dbg !315
while_hdr69:
  %r50 = load i64, ptr %slot.pos, align 8, !dbg !315
  %r51 = load i64, ptr %slot.end_pos, align 8, !dbg !315
  %r52 = call i64 @nova_rt_lt(i64 %r50, i64 %r51), !dbg !315
  %br_while_body705 = icmp ne i64 %r52, 0, !dbg !315
  br i1 %br_while_body705, label %while_body70, label %while_exit71, !prof !90, !dbg !315
while_body70:
  %r53 = load i64, ptr %slot.pkt, align 8, !dbg !316
  %r54 = load i64, ptr %slot.pos, align 8, !dbg !316
  %r55 = call i64 @_mqs_read_str(i64 %r53, i64 %r54), !dbg !316
  store i64 %r55, ptr %slot.sr, align 8, !dbg !316
  %r56 = add i64 %r55, 0, !dbg !317
  %r57 = add i64 0, 0, !dbg !317
  %r58 = call i64 @nova_rt_index_get(i64 %r56, i64 %r57), !dbg !317
  store i64 %r58, ptr %slot.topic, align 8, !dbg !317
  %r59 = add i64 %r55, 0, !dbg !318
  %r60 = add i64 1, 0, !dbg !318
  %r61 = call i64 @nova_rt_index_get(i64 %r59, i64 %r60), !dbg !318
  store i64 %r61, ptr %slot.pos, align 8, !dbg !318
  %r62 = add i64 %r61, 0, !dbg !319
  %r63 = load i64, ptr %slot.pkt_len, align 8, !dbg !319
  %r64 = call i64 @nova_rt_ge(i64 %r62, i64 %r63), !dbg !319
  %br_then726 = icmp ne i64 %r64, 0, !dbg !319
  br i1 %br_then726, label %then72, label %else73, !dbg !319
then72:
  %r65 = call i64 @nova_rt_dict_create(), !dbg !320
  store i64 %r65, ptr %slot.bad, align 8, !dbg !320
  %r66 = add i64 %r65, 0, !dbg !321
  ret i64 %r66, !dbg !321
else73:
  br label %endif74, !dbg !321
endif74:
  %r67 = load i64, ptr %slot.pkt, align 8, !dbg !322
  %r68 = load i64, ptr %slot.pos, align 8, !dbg !322
  %r69 = call i64 @nova_rt_index_get(i64 %r67, i64 %r68), !dbg !322
  %r70 = add i64 3, 0, !dbg !322
  %r71 = and i64 %r69, %r70, !dbg !322
  store i64 %r71, ptr %slot.qos, align 8, !dbg !322
  %r72 = load i64, ptr %slot.pos, align 8, !dbg !323
  %r73 = add i64 1, 0, !dbg !323
  %r74 = call i64 @nova_rt_add(i64 %r72, i64 %r73), !dbg !323
  store i64 %r74, ptr %slot.pos, align 8, !dbg !323
  %r75 = call i64 @nova_rt_list_create(), !dbg !324
  store i64 %r75, ptr %slot.pair, align 8, !dbg !324
  %r76 = add i64 %r75, 0, !dbg !325
  %r77 = load i64, ptr %slot.topic, align 8, !dbg !325
  %r78 = call i64 @nova_rt_list_append(i64 %r76, i64 %r77), !dbg !325
  %r79 = add i64 %r75, 0, !dbg !326
  %r80 = add i64 %r71, 0, !dbg !326
  %r81 = call i64 @nova_rt_list_append(i64 %r79, i64 %r80), !dbg !326
  %r82 = load i64, ptr %slot.filter_list, align 8, !dbg !327
  %r83 = add i64 %r75, 0, !dbg !327
  %r84 = call i64 @nova_rt_list_append(i64 %r82, i64 %r83), !dbg !327
  br label %while_hdr69, !dbg !327
while_exit71:
  %r85 = load i64, ptr %slot.filter_list, align 8, !dbg !328
  %r86 = load i64, ptr %slot.result, align 8, !dbg !328
  %r87.p = getelementptr inbounds [8 x i8], ptr @.str.2, i64 0, i64 0, !dbg !328
  %r87 = ptrtoint ptr %r87.p to i64, !dbg !328
  %_is.dv7 = call i64 @nova_rt_dict_set(i64 %r86, i64 %r87, i64 %r85), !dbg !328
  %r88 = load i64, ptr %slot.result, align 8, !dbg !329
  ret i64 %r88, !dbg !329
}

; ESCAPE mqtt_unsubscribe: allocs=0 escape=0 local=0
define i64 @mqtt_unsubscribe(i64 %p0, i64 %p1) nounwind uwtable !dbg !330 {
entry:
  %slot.packet_id = alloca i64, align 8, !dbg !331
  store i64 %p0, ptr %slot.packet_id, align 8, !dbg !331
  %slot.topics = alloca i64, align 8, !dbg !331
  store i64 %p1, ptr %slot.topics, align 8, !dbg !331
  %slot.payload = alloca i64, align 8, !dbg !331
  store i64 0, ptr %slot.payload, align 8, !dbg !331
  %slot.ti = alloca i64, align 8, !dbg !331
  store i64 0, ptr %slot.ti, align 8, !dbg !331
  %slot.tlen = alloca i64, align 8, !dbg !331
  store i64 0, ptr %slot.tlen, align 8, !dbg !331
  %slot.topics__s4f227 = alloca i64, align 8, !dbg !331
  store i64 0, ptr %slot.topics__s4f227, align 8, !dbg !331
  %slot.topic__s4f227 = alloca i64, align 8, !dbg !331
  store i64 0, ptr %slot.topic__s4f227, align 8, !dbg !331
  %slot.topic = alloca i64, align 8, !dbg !331
  store i64 0, ptr %slot.topic, align 8, !dbg !331
  %r0 = load i64, ptr %slot.packet_id, align 8, !dbg !332
  %r1 = call i64 @_mqs_init_payload(i64 %r0), !dbg !332
  store i64 %r1, ptr %slot.payload, align 8, !dbg !332
  %r2 = add i64 0, 0, !dbg !333
  store i64 %r2, ptr %slot.ti, align 8, !dbg !333
  %r3 = load i64, ptr %slot.topics, align 8, !dbg !334
  %r4 = call i64 @nova_rt_len_any(i64 %r3), !dbg !334
  store i64 %r4, ptr %slot.tlen, align 8, !dbg !334
  %r5 = load i64, ptr %slot.topics, align 8, !dbg !335
  %r6 = call i64 @nova_rt_list_is_kind2(i64 %r5), !dbg !335
  %br_then750 = icmp ne i64 %r6, 0, !dbg !335
  br i1 %br_then750, label %then75, label %else76, !dbg !335
then75:
  %r7 = load i64, ptr %slot.topics, align 8, !dbg !335
  %r8 = call i64 @nova_rt_floatlist_view(i64 %r7), !dbg !335
  store i64 %r8, ptr %slot.topics__s4f227, align 8, !dbg !335
  br label %while_hdr78, !dbg !335
while_hdr78:
  %r9 = load i64, ptr %slot.ti, align 8, !dbg !335
  %r10 = load i64, ptr %slot.tlen, align 8, !dbg !335
  %r11.cmp = icmp slt i64 %r9, %r10, !dbg !335
  %r11 = zext i1 %r11.cmp to i64, !dbg !335
  %br_while_body791 = icmp ne i64 %r11, 0, !dbg !335
  br i1 %br_while_body791, label %while_body79, label %while_exit80, !prof !90, !dbg !335
while_body79:
  %r12 = load i64, ptr %slot.topics__s4f227, align 8, !dbg !336
  %r13 = load i64, ptr %slot.ti, align 8, !dbg !336
  %r14 = call i64 @nova_rt_list_get_f(i64 %r12, i64 %r13), !dbg !336
  store i64 %r14, ptr %slot.topic__s4f227, align 8, !dbg !336
  %r15 = load i64, ptr %slot.payload, align 8, !dbg !337
  %r16 = add i64 %r14, 0, !dbg !337
  %wbox0 = call i64 @nova_rt_box_float(i64 %r16), !dbg !337
  %r17 = call i64 @_mqs_push_str(i64 %r15, i64 %wbox0), !dbg !337
  store i64 %r17, ptr %slot.payload, align 8, !dbg !337
  %r18 = load i64, ptr %slot.ti, align 8, !dbg !338
  %r19 = add i64 1, 0, !dbg !338
  %r20 = add i64 %r18, %r19, !dbg !338
  store i64 %r20, ptr %slot.ti, align 8, !dbg !338
  br label %while_hdr78, !dbg !338
while_exit80:
  br label %endif77, !dbg !338
else76:
  br label %while_hdr81, !dbg !335
while_hdr81:
  %r21 = load i64, ptr %slot.ti, align 8, !dbg !335
  %r22 = load i64, ptr %slot.tlen, align 8, !dbg !335
  %r23.cmp = icmp slt i64 %r21, %r22, !dbg !335
  %r23 = zext i1 %r23.cmp to i64, !dbg !335
  %br_while_body822 = icmp ne i64 %r23, 0, !dbg !335
  br i1 %br_while_body822, label %while_body82, label %while_exit83, !prof !90, !dbg !335
while_body82:
  %r24 = load i64, ptr %slot.topics, align 8, !dbg !336
  %r25 = load i64, ptr %slot.ti, align 8, !dbg !336
  %r26 = call i64 @nova_rt_index_get(i64 %r24, i64 %r25), !dbg !336
  store i64 %r26, ptr %slot.topic, align 8, !dbg !336
  %r27 = load i64, ptr %slot.payload, align 8, !dbg !337
  %r28 = add i64 %r26, 0, !dbg !337
  %r29 = call i64 @_mqs_push_str(i64 %r27, i64 %r28), !dbg !337
  store i64 %r29, ptr %slot.payload, align 8, !dbg !337
  %r30 = load i64, ptr %slot.ti, align 8, !dbg !338
  %r31 = add i64 1, 0, !dbg !338
  %r32 = add i64 %r30, %r31, !dbg !338
  store i64 %r32, ptr %slot.ti, align 8, !dbg !338
  br label %while_hdr81, !dbg !338
while_exit83:
  br label %endif77, !dbg !338
endif77:
  %r33 = add i64 162, 0, !dbg !339
  %r34 = load i64, ptr %slot.payload, align 8, !dbg !339
  %r35 = call i64 @_mqs_frame(i64 %r33, i64 %r34), !dbg !339
  ret i64 %r35, !dbg !339
}

; ESCAPE nova_main: allocs=0 escape=0 local=0
define i64 @nova_main() nounwind uwtable {
entry:
  ret i64 0
}

; ESCAPE SUMMARY: allocs=9 escape=7 local=2 (22% local, RC-elidable)
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
@.str.1 = private unnamed_addr constant [10 x i8] c"packet_id\00"
@.str.2 = private unnamed_addr constant [8 x i8] c"filters\00"

; Debug metadata
!llvm.dbg.cu = !{!100}
!llvm.module.flags = !{!102, !103}

!100 = distinct !DICompileUnit(language: DW_LANG_C99, file: !101, producer: "NOVA Compiler", isOptimized: false, emissionKind: LineTablesOnly)
!101 = !DIFile(filename: "std/net/mqtt_sub.nova", directory: ".")
!102 = !{i32 2, !"CodeView", i32 1}
!103 = !{i32 2, !"Debug Info Version", i32 3}
!104 = !DISubroutineType(types: !105)
!105 = !{null}
!200 = distinct !DISubprogram(name: "_mqs_enc_varint", scope: !101, file: !101, line: 45, type: !104, scopeLine: 45, spFlags: DISPFlagDefinition, unit: !100)
!201 = !DILocation(line: 45, column: 0, scope: !200)
!212 = distinct !DISubprogram(name: "_mqs_push_u16", scope: !101, file: !101, line: 59, type: !104, scopeLine: 59, spFlags: DISPFlagDefinition, unit: !100)
!213 = !DILocation(line: 59, column: 0, scope: !212)
!217 = distinct !DISubprogram(name: "_mqs_push_str", scope: !101, file: !101, line: 66, type: !104, scopeLine: 66, spFlags: DISPFlagDefinition, unit: !100)
!218 = !DILocation(line: 66, column: 0, scope: !217)
!226 = distinct !DISubprogram(name: "_mqs_dec_varint", scope: !101, file: !101, line: 77, type: !104, scopeLine: 77, spFlags: DISPFlagDefinition, unit: !100)
!227 = !DILocation(line: 77, column: 0, scope: !226)
!242 = distinct !DISubprogram(name: "_mqs_r16", scope: !101, file: !101, line: 95, type: !104, scopeLine: 95, spFlags: DISPFlagDefinition, unit: !100)
!243 = !DILocation(line: 95, column: 0, scope: !242)
!245 = distinct !DISubprogram(name: "_mqs_read_str", scope: !101, file: !101, line: 101, type: !104, scopeLine: 101, spFlags: DISPFlagDefinition, unit: !100)
!246 = !DILocation(line: 101, column: 0, scope: !245)
!265 = distinct !DISubprogram(name: "_mqs_init_payload", scope: !101, file: !101, line: 125, type: !104, scopeLine: 125, spFlags: DISPFlagDefinition, unit: !100)
!266 = !DILocation(line: 125, column: 0, scope: !265)
!270 = distinct !DISubprogram(name: "_mqs_frame", scope: !101, file: !101, line: 132, type: !104, scopeLine: 132, spFlags: DISPFlagDefinition, unit: !100)
!271 = !DILocation(line: 132, column: 0, scope: !270)
!281 = distinct !DISubprogram(name: "mqtt_subscribe", scope: !101, file: !101, line: 147, type: !104, scopeLine: 147, spFlags: DISPFlagDefinition, unit: !100)
!282 = !DILocation(line: 147, column: 0, scope: !281)
!294 = distinct !DISubprogram(name: "mqtt_subscribe_decode", scope: !101, file: !101, line: 169, type: !104, scopeLine: 169, spFlags: DISPFlagDefinition, unit: !100)
!295 = !DILocation(line: 169, column: 0, scope: !294)
!330 = distinct !DISubprogram(name: "mqtt_unsubscribe", scope: !101, file: !101, line: 220, type: !104, scopeLine: 220, spFlags: DISPFlagDefinition, unit: !100)
!331 = !DILocation(line: 220, column: 0, scope: !330)
!202 = !DILocation(line: 46, column: 0, scope: !200)
!203 = !DILocation(line: 47, column: 0, scope: !200)
!204 = !DILocation(line: 48, column: 0, scope: !200)
!205 = !DILocation(line: 49, column: 0, scope: !200)
!206 = !DILocation(line: 50, column: 0, scope: !200)
!207 = !DILocation(line: 51, column: 0, scope: !200)
!208 = !DILocation(line: 52, column: 0, scope: !200)
!209 = !DILocation(line: 53, column: 0, scope: !200)
!210 = !DILocation(line: 54, column: 0, scope: !200)
!211 = !DILocation(line: 55, column: 0, scope: !200)
!214 = !DILocation(line: 60, column: 0, scope: !212)
!215 = !DILocation(line: 61, column: 0, scope: !212)
!216 = !DILocation(line: 62, column: 0, scope: !212)
!219 = !DILocation(line: 67, column: 0, scope: !217)
!220 = !DILocation(line: 68, column: 0, scope: !217)
!221 = !DILocation(line: 69, column: 0, scope: !217)
!222 = !DILocation(line: 70, column: 0, scope: !217)
!223 = !DILocation(line: 71, column: 0, scope: !217)
!224 = !DILocation(line: 72, column: 0, scope: !217)
!225 = !DILocation(line: 73, column: 0, scope: !217)
!228 = !DILocation(line: 78, column: 0, scope: !226)
!229 = !DILocation(line: 79, column: 0, scope: !226)
!230 = !DILocation(line: 80, column: 0, scope: !226)
!231 = !DILocation(line: 81, column: 0, scope: !226)
!232 = !DILocation(line: 82, column: 0, scope: !226)
!233 = !DILocation(line: 83, column: 0, scope: !226)
!234 = !DILocation(line: 84, column: 0, scope: !226)
!235 = !DILocation(line: 85, column: 0, scope: !226)
!236 = !DILocation(line: 86, column: 0, scope: !226)
!237 = !DILocation(line: 87, column: 0, scope: !226)
!238 = !DILocation(line: 88, column: 0, scope: !226)
!239 = !DILocation(line: 89, column: 0, scope: !226)
!240 = !DILocation(line: 90, column: 0, scope: !226)
!241 = !DILocation(line: 91, column: 0, scope: !226)
!244 = !DILocation(line: 96, column: 0, scope: !242)
!247 = !DILocation(line: 102, column: 0, scope: !245)
!248 = !DILocation(line: 103, column: 0, scope: !245)
!249 = !DILocation(line: 104, column: 0, scope: !245)
!250 = !DILocation(line: 105, column: 0, scope: !245)
!251 = !DILocation(line: 106, column: 0, scope: !245)
!252 = !DILocation(line: 107, column: 0, scope: !245)
!253 = !DILocation(line: 108, column: 0, scope: !245)
!254 = !DILocation(line: 109, column: 0, scope: !245)
!255 = !DILocation(line: 110, column: 0, scope: !245)
!256 = !DILocation(line: 111, column: 0, scope: !245)
!257 = !DILocation(line: 112, column: 0, scope: !245)
!258 = !DILocation(line: 113, column: 0, scope: !245)
!259 = !DILocation(line: 114, column: 0, scope: !245)
!260 = !DILocation(line: 115, column: 0, scope: !245)
!261 = !DILocation(line: 116, column: 0, scope: !245)
!262 = !DILocation(line: 117, column: 0, scope: !245)
!263 = !DILocation(line: 118, column: 0, scope: !245)
!264 = !DILocation(line: 119, column: 0, scope: !245)
!267 = !DILocation(line: 126, column: 0, scope: !265)
!268 = !DILocation(line: 127, column: 0, scope: !265)
!269 = !DILocation(line: 128, column: 0, scope: !265)
!272 = !DILocation(line: 133, column: 0, scope: !270)
!273 = !DILocation(line: 134, column: 0, scope: !270)
!274 = !DILocation(line: 135, column: 0, scope: !270)
!275 = !DILocation(line: 136, column: 0, scope: !270)
!276 = !DILocation(line: 137, column: 0, scope: !270)
!277 = !DILocation(line: 138, column: 0, scope: !270)
!278 = !DILocation(line: 139, column: 0, scope: !270)
!279 = !DILocation(line: 140, column: 0, scope: !270)
!280 = !DILocation(line: 141, column: 0, scope: !270)
!283 = !DILocation(line: 149, column: 0, scope: !281)
!284 = !DILocation(line: 152, column: 0, scope: !281)
!285 = !DILocation(line: 153, column: 0, scope: !281)
!286 = !DILocation(line: 154, column: 0, scope: !281)
!287 = !DILocation(line: 155, column: 0, scope: !281)
!288 = !DILocation(line: 156, column: 0, scope: !281)
!289 = !DILocation(line: 157, column: 0, scope: !281)
!290 = !DILocation(line: 158, column: 0, scope: !281)
!291 = !DILocation(line: 159, column: 0, scope: !281)
!292 = !DILocation(line: 160, column: 0, scope: !281)
!293 = !DILocation(line: 163, column: 0, scope: !281)
!296 = !DILocation(line: 170, column: 0, scope: !294)
!297 = !DILocation(line: 171, column: 0, scope: !294)
!298 = !DILocation(line: 172, column: 0, scope: !294)
!299 = !DILocation(line: 173, column: 0, scope: !294)
!300 = !DILocation(line: 176, column: 0, scope: !294)
!301 = !DILocation(line: 177, column: 0, scope: !294)
!302 = !DILocation(line: 178, column: 0, scope: !294)
!303 = !DILocation(line: 181, column: 0, scope: !294)
!304 = !DILocation(line: 182, column: 0, scope: !294)
!305 = !DILocation(line: 183, column: 0, scope: !294)
!306 = !DILocation(line: 185, column: 0, scope: !294)
!307 = !DILocation(line: 186, column: 0, scope: !294)
!308 = !DILocation(line: 189, column: 0, scope: !294)
!309 = !DILocation(line: 190, column: 0, scope: !294)
!310 = !DILocation(line: 191, column: 0, scope: !294)
!311 = !DILocation(line: 192, column: 0, scope: !294)
!312 = !DILocation(line: 194, column: 0, scope: !294)
!313 = !DILocation(line: 197, column: 0, scope: !294)
!314 = !DILocation(line: 198, column: 0, scope: !294)
!315 = !DILocation(line: 199, column: 0, scope: !294)
!316 = !DILocation(line: 200, column: 0, scope: !294)
!317 = !DILocation(line: 201, column: 0, scope: !294)
!318 = !DILocation(line: 202, column: 0, scope: !294)
!319 = !DILocation(line: 203, column: 0, scope: !294)
!320 = !DILocation(line: 205, column: 0, scope: !294)
!321 = !DILocation(line: 206, column: 0, scope: !294)
!322 = !DILocation(line: 207, column: 0, scope: !294)
!323 = !DILocation(line: 208, column: 0, scope: !294)
!324 = !DILocation(line: 209, column: 0, scope: !294)
!325 = !DILocation(line: 210, column: 0, scope: !294)
!326 = !DILocation(line: 211, column: 0, scope: !294)
!327 = !DILocation(line: 212, column: 0, scope: !294)
!328 = !DILocation(line: 213, column: 0, scope: !294)
!329 = !DILocation(line: 214, column: 0, scope: !294)
!332 = !DILocation(line: 222, column: 0, scope: !330)
!333 = !DILocation(line: 225, column: 0, scope: !330)
!334 = !DILocation(line: 226, column: 0, scope: !330)
!335 = !DILocation(line: 227, column: 0, scope: !330)
!336 = !DILocation(line: 228, column: 0, scope: !330)
!337 = !DILocation(line: 229, column: 0, scope: !330)
!338 = !DILocation(line: 230, column: 0, scope: !330)
!339 = !DILocation(line: 233, column: 0, scope: !330)

; TBAA metadata
!0 = !{!"NOVA TBAA"}
!1 = !{!"list_data_ptr", !0}
!2 = !{!1, !1, i64 0}
!3 = !{!"list_elem", !0}
!4 = !{!3, !3, i64 0}
!5 = !{!"list_size", !0}
!6 = !{!5, !5, i64 0}
!90 = !{!"branch_weights", i32 2000, i32 1}
