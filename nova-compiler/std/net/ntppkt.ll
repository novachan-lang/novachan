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

; ESCAPE _ntp_write_u16: allocs=0 escape=0 local=0
define i64 @_ntp_write_u16(i64 %p0, i64 %p1) nounwind uwtable !dbg !200 {
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
  %r6 = call i64 @nova_rt_bytes_append(i64 %r0, i64 %r5), !dbg !202
  store i64 %r6, ptr %slot.out, align 8, !dbg !202
  %r7 = add i64 %r6, 0, !dbg !203
  %r8 = load i64, ptr %slot.v, align 8, !dbg !203
  %r9 = add i64 255, 0, !dbg !203
  %r10 = and i64 %r8, %r9, !dbg !203
  %r11 = call i64 @nova_rt_bytes_append(i64 %r7, i64 %r10), !dbg !203
  store i64 %r11, ptr %slot.out, align 8, !dbg !203
  %r12 = add i64 %r11, 0, !dbg !204
  ret i64 %r12, !dbg !204
}

; ESCAPE _ntp_write_u32: allocs=0 escape=0 local=0
define i64 @_ntp_write_u32(i64 %p0, i64 %p1) nounwind uwtable !dbg !205 {
entry:
  %slot.out = alloca i64, align 8, !dbg !206
  store i64 %p0, ptr %slot.out, align 8, !dbg !206
  %slot.v = alloca i64, align 8, !dbg !206
  store i64 %p1, ptr %slot.v, align 8, !dbg !206
  %r0 = load i64, ptr %slot.out, align 8, !dbg !207
  %r1 = load i64, ptr %slot.v, align 8, !dbg !207
  %r2 = add i64 24, 0, !dbg !207
  %r3.sramt = and i64 %r2, 63, !dbg !207
  %r3.srbig = icmp uge i64 %r2, 64, !dbg !207
  %r3.srval = ashr i64 %r1, %r3.sramt, !dbg !207
  %r3.srext = ashr i64 %r1, 63, !dbg !207
  %r3 = select i1 %r3.srbig, i64 %r3.srext, i64 %r3.srval, !dbg !207
  %r4 = add i64 255, 0, !dbg !207
  %r5 = and i64 %r3, %r4, !dbg !207
  %r6 = call i64 @nova_rt_bytes_append(i64 %r0, i64 %r5), !dbg !207
  store i64 %r6, ptr %slot.out, align 8, !dbg !207
  %r7 = add i64 %r6, 0, !dbg !208
  %r8 = load i64, ptr %slot.v, align 8, !dbg !208
  %r9 = add i64 16, 0, !dbg !208
  %r10.sramt = and i64 %r9, 63, !dbg !208
  %r10.srbig = icmp uge i64 %r9, 64, !dbg !208
  %r10.srval = ashr i64 %r8, %r10.sramt, !dbg !208
  %r10.srext = ashr i64 %r8, 63, !dbg !208
  %r10 = select i1 %r10.srbig, i64 %r10.srext, i64 %r10.srval, !dbg !208
  %r11 = add i64 255, 0, !dbg !208
  %r12 = and i64 %r10, %r11, !dbg !208
  %r13 = call i64 @nova_rt_bytes_append(i64 %r7, i64 %r12), !dbg !208
  store i64 %r13, ptr %slot.out, align 8, !dbg !208
  %r14 = add i64 %r13, 0, !dbg !209
  %r15 = load i64, ptr %slot.v, align 8, !dbg !209
  %r16 = add i64 8, 0, !dbg !209
  %r17.sramt = and i64 %r16, 63, !dbg !209
  %r17.srbig = icmp uge i64 %r16, 64, !dbg !209
  %r17.srval = ashr i64 %r15, %r17.sramt, !dbg !209
  %r17.srext = ashr i64 %r15, 63, !dbg !209
  %r17 = select i1 %r17.srbig, i64 %r17.srext, i64 %r17.srval, !dbg !209
  %r18 = add i64 255, 0, !dbg !209
  %r19 = and i64 %r17, %r18, !dbg !209
  %r20 = call i64 @nova_rt_bytes_append(i64 %r14, i64 %r19), !dbg !209
  store i64 %r20, ptr %slot.out, align 8, !dbg !209
  %r21 = add i64 %r20, 0, !dbg !210
  %r22 = load i64, ptr %slot.v, align 8, !dbg !210
  %r23 = add i64 255, 0, !dbg !210
  %r24 = and i64 %r22, %r23, !dbg !210
  %r25 = call i64 @nova_rt_bytes_append(i64 %r21, i64 %r24), !dbg !210
  store i64 %r25, ptr %slot.out, align 8, !dbg !210
  %r26 = add i64 %r25, 0, !dbg !211
  ret i64 %r26, !dbg !211
}

; ESCAPE _ntp_read_u32: allocs=0 escape=0 local=0
define i64 @_ntp_read_u32(i64 %p0, i64 %p1) nounwind uwtable !dbg !212 {
entry:
  %slot.b = alloca i64, align 8, !dbg !213
  store i64 %p0, ptr %slot.b, align 8, !dbg !213
  %slot.i = alloca i64, align 8, !dbg !213
  store i64 %p1, ptr %slot.i, align 8, !dbg !213
  %slot.a0 = alloca i64, align 8, !dbg !213
  store i64 0, ptr %slot.a0, align 8, !dbg !213
  %slot.a1 = alloca i64, align 8, !dbg !213
  store i64 0, ptr %slot.a1, align 8, !dbg !213
  %slot.a2 = alloca i64, align 8, !dbg !213
  store i64 0, ptr %slot.a2, align 8, !dbg !213
  %slot.a3 = alloca i64, align 8, !dbg !213
  store i64 0, ptr %slot.a3, align 8, !dbg !213
  %r0 = load i64, ptr %slot.b, align 8, !dbg !214
  %r1 = load i64, ptr %slot.i, align 8, !dbg !214
  %r2 = call i64 @nova_rt_bytes_get(i64 %r0, i64 %r1), !dbg !214
  store i64 %r2, ptr %slot.a0, align 8, !dbg !214
  %r3 = load i64, ptr %slot.b, align 8, !dbg !215
  %r4 = load i64, ptr %slot.i, align 8, !dbg !215
  %r5 = add i64 1, 0, !dbg !215
  %r6 = add i64 %r4, %r5, !dbg !215
  %r7 = call i64 @nova_rt_bytes_get(i64 %r3, i64 %r6), !dbg !215
  store i64 %r7, ptr %slot.a1, align 8, !dbg !215
  %r8 = load i64, ptr %slot.b, align 8, !dbg !216
  %r9 = load i64, ptr %slot.i, align 8, !dbg !216
  %r10 = add i64 2, 0, !dbg !216
  %r11 = add i64 %r9, %r10, !dbg !216
  %r12 = call i64 @nova_rt_bytes_get(i64 %r8, i64 %r11), !dbg !216
  store i64 %r12, ptr %slot.a2, align 8, !dbg !216
  %r13 = load i64, ptr %slot.b, align 8, !dbg !217
  %r14 = load i64, ptr %slot.i, align 8, !dbg !217
  %r15 = add i64 3, 0, !dbg !217
  %r16 = add i64 %r14, %r15, !dbg !217
  %r17 = call i64 @nova_rt_bytes_get(i64 %r13, i64 %r16), !dbg !217
  store i64 %r17, ptr %slot.a3, align 8, !dbg !217
  %r18 = add i64 %r2, 0, !dbg !218
  %r19 = add i64 24, 0, !dbg !218
  %r20.shamt = and i64 %r19, 63, !dbg !218
  %r20.shbig = icmp uge i64 %r19, 64, !dbg !218
  %r20.shval = shl i64 %r18, %r20.shamt, !dbg !218
  %r20 = select i1 %r20.shbig, i64 0, i64 %r20.shval, !dbg !218
  %r21 = add i64 %r7, 0, !dbg !218
  %r22 = add i64 16, 0, !dbg !218
  %r23.shamt = and i64 %r22, 63, !dbg !218
  %r23.shbig = icmp uge i64 %r22, 64, !dbg !218
  %r23.shval = shl i64 %r21, %r23.shamt, !dbg !218
  %r23 = select i1 %r23.shbig, i64 0, i64 %r23.shval, !dbg !218
  %r24 = or i64 %r20, %r23, !dbg !218
  %r25 = add i64 %r12, 0, !dbg !218
  %r26 = add i64 8, 0, !dbg !218
  %r27.shamt = and i64 %r26, 63, !dbg !218
  %r27.shbig = icmp uge i64 %r26, 64, !dbg !218
  %r27.shval = shl i64 %r25, %r27.shamt, !dbg !218
  %r27 = select i1 %r27.shbig, i64 0, i64 %r27.shval, !dbg !218
  %r28 = or i64 %r24, %r27, !dbg !218
  %r29 = add i64 %r17, 0, !dbg !218
  %r30 = or i64 %r28, %r29, !dbg !218
  %r31 = add i64 4294967295, 0, !dbg !218
  %r32 = and i64 %r30, %r31, !dbg !218
  ret i64 %r32, !dbg !218
}

; ESCAPE _ntp_get: allocs=0 escape=0 local=0
define i64 @_ntp_get(i64 %p0, i64 %p1) nounwind uwtable !dbg !219 {
entry:
  %slot.h = alloca i64, align 8, !dbg !220
  store i64 %p0, ptr %slot.h, align 8, !dbg !220
  %slot.key = alloca i64, align 8, !dbg !220
  store i64 %p1, ptr %slot.key, align 8, !dbg !220
  %r0 = load i64, ptr %slot.h, align 8, !dbg !221
  %r1 = load i64, ptr %slot.key, align 8, !dbg !221
  %r2 = call i64 @nova_rt_contains(i64 %r0, i64 %r1), !dbg !221
  %br_then00 = icmp ne i64 %r2, 0, !dbg !221
  br i1 %br_then00, label %then0, label %else1, !dbg !221
then0:
  %r3 = load i64, ptr %slot.h, align 8, !dbg !222
  %r4 = load i64, ptr %slot.key, align 8, !dbg !222
  %r5 = call i64 @nova_rt_index_get(i64 %r3, i64 %r4), !dbg !222
  ret i64 %r5, !dbg !222
else1:
  br label %endif2, !dbg !222
endif2:
  %r6 = add i64 0, 0, !dbg !223
  ret i64 %r6, !dbg !223
}

; ESCAPE ntp_encode: allocs=0 escape=0 local=0
define i64 @ntp_encode(i64 %p0) nounwind uwtable !dbg !224 {
entry:
  %slot.h = alloca i64, align 8, !dbg !225
  store i64 %p0, ptr %slot.h, align 8, !dbg !225
  %slot.li = alloca i64, align 8, !dbg !225
  store i64 0, ptr %slot.li, align 8, !dbg !225
  %slot.vn = alloca i64, align 8, !dbg !225
  store i64 0, ptr %slot.vn, align 8, !dbg !225
  %slot.mode = alloca i64, align 8, !dbg !225
  store i64 0, ptr %slot.mode, align 8, !dbg !225
  %slot.flags = alloca i64, align 8, !dbg !225
  store i64 0, ptr %slot.flags, align 8, !dbg !225
  %slot.stratum = alloca i64, align 8, !dbg !225
  store i64 0, ptr %slot.stratum, align 8, !dbg !225
  %slot.poll = alloca i64, align 8, !dbg !225
  store i64 0, ptr %slot.poll, align 8, !dbg !225
  %slot.precision = alloca i64, align 8, !dbg !225
  store i64 0, ptr %slot.precision, align 8, !dbg !225
  %slot.root_delay = alloca i64, align 8, !dbg !225
  store i64 0, ptr %slot.root_delay, align 8, !dbg !225
  %slot.root_dispersion = alloca i64, align 8, !dbg !225
  store i64 0, ptr %slot.root_dispersion, align 8, !dbg !225
  %slot.reference_id = alloca i64, align 8, !dbg !225
  store i64 0, ptr %slot.reference_id, align 8, !dbg !225
  %slot.ref_sec = alloca i64, align 8, !dbg !225
  store i64 0, ptr %slot.ref_sec, align 8, !dbg !225
  %slot.ref_frac = alloca i64, align 8, !dbg !225
  store i64 0, ptr %slot.ref_frac, align 8, !dbg !225
  %slot.org_sec = alloca i64, align 8, !dbg !225
  store i64 0, ptr %slot.org_sec, align 8, !dbg !225
  %slot.org_frac = alloca i64, align 8, !dbg !225
  store i64 0, ptr %slot.org_frac, align 8, !dbg !225
  %slot.rx_sec = alloca i64, align 8, !dbg !225
  store i64 0, ptr %slot.rx_sec, align 8, !dbg !225
  %slot.rx_frac = alloca i64, align 8, !dbg !225
  store i64 0, ptr %slot.rx_frac, align 8, !dbg !225
  %slot.tx_sec = alloca i64, align 8, !dbg !225
  store i64 0, ptr %slot.tx_sec, align 8, !dbg !225
  %slot.tx_frac = alloca i64, align 8, !dbg !225
  store i64 0, ptr %slot.tx_frac, align 8, !dbg !225
  %slot.out = alloca i64, align 8, !dbg !225
  store i64 0, ptr %slot.out, align 8, !dbg !225
  %r0 = load i64, ptr %slot.h, align 8, !dbg !226
  %r1.p = getelementptr inbounds [3 x i8], ptr @.str.0, i64 0, i64 0, !dbg !226
  %r1 = ptrtoint ptr %r1.p to i64, !dbg !226
  %r2 = call i64 @_ntp_get(i64 %r0, i64 %r1), !dbg !226
  store i64 %r2, ptr %slot.li, align 8, !dbg !226
  %r3 = load i64, ptr %slot.h, align 8, !dbg !227
  %r4.p = getelementptr inbounds [3 x i8], ptr @.str.1, i64 0, i64 0, !dbg !227
  %r4 = ptrtoint ptr %r4.p to i64, !dbg !227
  %r5 = call i64 @_ntp_get(i64 %r3, i64 %r4), !dbg !227
  store i64 %r5, ptr %slot.vn, align 8, !dbg !227
  %r6 = load i64, ptr %slot.h, align 8, !dbg !228
  %r7.p = getelementptr inbounds [5 x i8], ptr @.str.2, i64 0, i64 0, !dbg !228
  %r7 = ptrtoint ptr %r7.p to i64, !dbg !228
  %r8 = call i64 @_ntp_get(i64 %r6, i64 %r7), !dbg !228
  store i64 %r8, ptr %slot.mode, align 8, !dbg !228
  %r9 = add i64 %r2, 0, !dbg !229
  %r10 = add i64 3, 0, !dbg !229
  %r11 = and i64 %r9, %r10, !dbg !229
  %r12 = add i64 6, 0, !dbg !229
  %r13.shamt = and i64 %r12, 63, !dbg !229
  %r13.shbig = icmp uge i64 %r12, 64, !dbg !229
  %r13.shval = shl i64 %r11, %r13.shamt, !dbg !229
  %r13 = select i1 %r13.shbig, i64 0, i64 %r13.shval, !dbg !229
  %r14 = add i64 %r5, 0, !dbg !229
  %r15 = add i64 7, 0, !dbg !229
  %r16 = and i64 %r14, %r15, !dbg !229
  %r17 = add i64 3, 0, !dbg !229
  %r18.shamt = and i64 %r17, 63, !dbg !229
  %r18.shbig = icmp uge i64 %r17, 64, !dbg !229
  %r18.shval = shl i64 %r16, %r18.shamt, !dbg !229
  %r18 = select i1 %r18.shbig, i64 0, i64 %r18.shval, !dbg !229
  %r19 = or i64 %r13, %r18, !dbg !229
  %r20 = add i64 %r8, 0, !dbg !229
  %r21 = add i64 7, 0, !dbg !229
  %r22 = and i64 %r20, %r21, !dbg !229
  %r23 = or i64 %r19, %r22, !dbg !229
  store i64 %r23, ptr %slot.flags, align 8, !dbg !229
  %r24 = load i64, ptr %slot.h, align 8, !dbg !230
  %r25.p = getelementptr inbounds [8 x i8], ptr @.str.3, i64 0, i64 0, !dbg !230
  %r25 = ptrtoint ptr %r25.p to i64, !dbg !230
  %r26 = call i64 @_ntp_get(i64 %r24, i64 %r25), !dbg !230
  store i64 %r26, ptr %slot.stratum, align 8, !dbg !230
  %r27 = load i64, ptr %slot.h, align 8, !dbg !231
  %r28.p = getelementptr inbounds [5 x i8], ptr @.str.4, i64 0, i64 0, !dbg !231
  %r28 = ptrtoint ptr %r28.p to i64, !dbg !231
  %r29 = call i64 @_ntp_get(i64 %r27, i64 %r28), !dbg !231
  store i64 %r29, ptr %slot.poll, align 8, !dbg !231
  %r30 = load i64, ptr %slot.h, align 8, !dbg !232
  %r31.p = getelementptr inbounds [10 x i8], ptr @.str.5, i64 0, i64 0, !dbg !232
  %r31 = ptrtoint ptr %r31.p to i64, !dbg !232
  %r32 = call i64 @_ntp_get(i64 %r30, i64 %r31), !dbg !232
  store i64 %r32, ptr %slot.precision, align 8, !dbg !232
  %r33 = load i64, ptr %slot.h, align 8, !dbg !233
  %r34.p = getelementptr inbounds [11 x i8], ptr @.str.6, i64 0, i64 0, !dbg !233
  %r34 = ptrtoint ptr %r34.p to i64, !dbg !233
  %r35 = call i64 @_ntp_get(i64 %r33, i64 %r34), !dbg !233
  store i64 %r35, ptr %slot.root_delay, align 8, !dbg !233
  %r36 = load i64, ptr %slot.h, align 8, !dbg !234
  %r37.p = getelementptr inbounds [16 x i8], ptr @.str.7, i64 0, i64 0, !dbg !234
  %r37 = ptrtoint ptr %r37.p to i64, !dbg !234
  %r38 = call i64 @_ntp_get(i64 %r36, i64 %r37), !dbg !234
  store i64 %r38, ptr %slot.root_dispersion, align 8, !dbg !234
  %r39 = load i64, ptr %slot.h, align 8, !dbg !235
  %r40.p = getelementptr inbounds [13 x i8], ptr @.str.8, i64 0, i64 0, !dbg !235
  %r40 = ptrtoint ptr %r40.p to i64, !dbg !235
  %r41 = call i64 @_ntp_get(i64 %r39, i64 %r40), !dbg !235
  store i64 %r41, ptr %slot.reference_id, align 8, !dbg !235
  %r42 = load i64, ptr %slot.h, align 8, !dbg !236
  %r43.p = getelementptr inbounds [8 x i8], ptr @.str.9, i64 0, i64 0, !dbg !236
  %r43 = ptrtoint ptr %r43.p to i64, !dbg !236
  %r44 = call i64 @_ntp_get(i64 %r42, i64 %r43), !dbg !236
  store i64 %r44, ptr %slot.ref_sec, align 8, !dbg !236
  %r45 = load i64, ptr %slot.h, align 8, !dbg !237
  %r46.p = getelementptr inbounds [9 x i8], ptr @.str.10, i64 0, i64 0, !dbg !237
  %r46 = ptrtoint ptr %r46.p to i64, !dbg !237
  %r47 = call i64 @_ntp_get(i64 %r45, i64 %r46), !dbg !237
  store i64 %r47, ptr %slot.ref_frac, align 8, !dbg !237
  %r48 = load i64, ptr %slot.h, align 8, !dbg !238
  %r49.p = getelementptr inbounds [8 x i8], ptr @.str.11, i64 0, i64 0, !dbg !238
  %r49 = ptrtoint ptr %r49.p to i64, !dbg !238
  %r50 = call i64 @_ntp_get(i64 %r48, i64 %r49), !dbg !238
  store i64 %r50, ptr %slot.org_sec, align 8, !dbg !238
  %r51 = load i64, ptr %slot.h, align 8, !dbg !239
  %r52.p = getelementptr inbounds [9 x i8], ptr @.str.12, i64 0, i64 0, !dbg !239
  %r52 = ptrtoint ptr %r52.p to i64, !dbg !239
  %r53 = call i64 @_ntp_get(i64 %r51, i64 %r52), !dbg !239
  store i64 %r53, ptr %slot.org_frac, align 8, !dbg !239
  %r54 = load i64, ptr %slot.h, align 8, !dbg !240
  %r55.p = getelementptr inbounds [7 x i8], ptr @.str.13, i64 0, i64 0, !dbg !240
  %r55 = ptrtoint ptr %r55.p to i64, !dbg !240
  %r56 = call i64 @_ntp_get(i64 %r54, i64 %r55), !dbg !240
  store i64 %r56, ptr %slot.rx_sec, align 8, !dbg !240
  %r57 = load i64, ptr %slot.h, align 8, !dbg !241
  %r58.p = getelementptr inbounds [8 x i8], ptr @.str.14, i64 0, i64 0, !dbg !241
  %r58 = ptrtoint ptr %r58.p to i64, !dbg !241
  %r59 = call i64 @_ntp_get(i64 %r57, i64 %r58), !dbg !241
  store i64 %r59, ptr %slot.rx_frac, align 8, !dbg !241
  %r60 = load i64, ptr %slot.h, align 8, !dbg !242
  %r61.p = getelementptr inbounds [7 x i8], ptr @.str.15, i64 0, i64 0, !dbg !242
  %r61 = ptrtoint ptr %r61.p to i64, !dbg !242
  %r62 = call i64 @_ntp_get(i64 %r60, i64 %r61), !dbg !242
  store i64 %r62, ptr %slot.tx_sec, align 8, !dbg !242
  %r63 = load i64, ptr %slot.h, align 8, !dbg !243
  %r64.p = getelementptr inbounds [8 x i8], ptr @.str.16, i64 0, i64 0, !dbg !243
  %r64 = ptrtoint ptr %r64.p to i64, !dbg !243
  %r65 = call i64 @_ntp_get(i64 %r63, i64 %r64), !dbg !243
  store i64 %r65, ptr %slot.tx_frac, align 8, !dbg !243
  %r66 = add i64 0, 0, !dbg !244
  %r67 = call i64 @nova_rt_bytes_create(i64 %r66), !dbg !244
  store i64 %r67, ptr %slot.out, align 8, !dbg !244
  %r68 = add i64 %r67, 0, !dbg !245
  %r69 = add i64 %r23, 0, !dbg !245
  %r70 = add i64 255, 0, !dbg !245
  %r71 = and i64 %r69, %r70, !dbg !245
  %r72 = call i64 @nova_rt_bytes_append(i64 %r68, i64 %r71), !dbg !245
  store i64 %r72, ptr %slot.out, align 8, !dbg !245
  %r73 = add i64 %r72, 0, !dbg !246
  %r74 = add i64 %r26, 0, !dbg !246
  %r75 = add i64 255, 0, !dbg !246
  %r76 = and i64 %r74, %r75, !dbg !246
  %r77 = call i64 @nova_rt_bytes_append(i64 %r73, i64 %r76), !dbg !246
  store i64 %r77, ptr %slot.out, align 8, !dbg !246
  %r78 = add i64 %r77, 0, !dbg !247
  %r79 = add i64 %r29, 0, !dbg !247
  %r80 = add i64 255, 0, !dbg !247
  %r81 = and i64 %r79, %r80, !dbg !247
  %r82 = call i64 @nova_rt_bytes_append(i64 %r78, i64 %r81), !dbg !247
  store i64 %r82, ptr %slot.out, align 8, !dbg !247
  %r83 = add i64 %r82, 0, !dbg !248
  %r84 = add i64 %r32, 0, !dbg !248
  %r85 = add i64 255, 0, !dbg !248
  %r86 = and i64 %r84, %r85, !dbg !248
  %r87 = call i64 @nova_rt_bytes_append(i64 %r83, i64 %r86), !dbg !248
  store i64 %r87, ptr %slot.out, align 8, !dbg !248
  %r88 = add i64 %r87, 0, !dbg !249
  %r89 = add i64 %r35, 0, !dbg !249
  %r90 = add i64 4294967295, 0, !dbg !249
  %r91 = and i64 %r89, %r90, !dbg !249
  %r92 = call i64 @_ntp_write_u32(i64 %r88, i64 %r91), !dbg !249
  store i64 %r92, ptr %slot.out, align 8, !dbg !249
  %r93 = add i64 %r92, 0, !dbg !250
  %r94 = add i64 %r38, 0, !dbg !250
  %r95 = add i64 4294967295, 0, !dbg !250
  %r96 = and i64 %r94, %r95, !dbg !250
  %r97 = call i64 @_ntp_write_u32(i64 %r93, i64 %r96), !dbg !250
  store i64 %r97, ptr %slot.out, align 8, !dbg !250
  %r98 = add i64 %r97, 0, !dbg !251
  %r99 = add i64 %r41, 0, !dbg !251
  %r100 = add i64 4294967295, 0, !dbg !251
  %r101 = and i64 %r99, %r100, !dbg !251
  %r102 = call i64 @_ntp_write_u32(i64 %r98, i64 %r101), !dbg !251
  store i64 %r102, ptr %slot.out, align 8, !dbg !251
  %r103 = add i64 %r102, 0, !dbg !252
  %r104 = add i64 %r44, 0, !dbg !252
  %r105 = add i64 4294967295, 0, !dbg !252
  %r106 = and i64 %r104, %r105, !dbg !252
  %r107 = call i64 @_ntp_write_u32(i64 %r103, i64 %r106), !dbg !252
  store i64 %r107, ptr %slot.out, align 8, !dbg !252
  %r108 = add i64 %r107, 0, !dbg !253
  %r109 = add i64 %r47, 0, !dbg !253
  %r110 = add i64 4294967295, 0, !dbg !253
  %r111 = and i64 %r109, %r110, !dbg !253
  %r112 = call i64 @_ntp_write_u32(i64 %r108, i64 %r111), !dbg !253
  store i64 %r112, ptr %slot.out, align 8, !dbg !253
  %r113 = add i64 %r112, 0, !dbg !254
  %r114 = add i64 %r50, 0, !dbg !254
  %r115 = add i64 4294967295, 0, !dbg !254
  %r116 = and i64 %r114, %r115, !dbg !254
  %r117 = call i64 @_ntp_write_u32(i64 %r113, i64 %r116), !dbg !254
  store i64 %r117, ptr %slot.out, align 8, !dbg !254
  %r118 = add i64 %r117, 0, !dbg !255
  %r119 = add i64 %r53, 0, !dbg !255
  %r120 = add i64 4294967295, 0, !dbg !255
  %r121 = and i64 %r119, %r120, !dbg !255
  %r122 = call i64 @_ntp_write_u32(i64 %r118, i64 %r121), !dbg !255
  store i64 %r122, ptr %slot.out, align 8, !dbg !255
  %r123 = add i64 %r122, 0, !dbg !256
  %r124 = add i64 %r56, 0, !dbg !256
  %r125 = add i64 4294967295, 0, !dbg !256
  %r126 = and i64 %r124, %r125, !dbg !256
  %r127 = call i64 @_ntp_write_u32(i64 %r123, i64 %r126), !dbg !256
  store i64 %r127, ptr %slot.out, align 8, !dbg !256
  %r128 = add i64 %r127, 0, !dbg !257
  %r129 = add i64 %r59, 0, !dbg !257
  %r130 = add i64 4294967295, 0, !dbg !257
  %r131 = and i64 %r129, %r130, !dbg !257
  %r132 = call i64 @_ntp_write_u32(i64 %r128, i64 %r131), !dbg !257
  store i64 %r132, ptr %slot.out, align 8, !dbg !257
  %r133 = add i64 %r132, 0, !dbg !258
  %r134 = add i64 %r62, 0, !dbg !258
  %r135 = add i64 4294967295, 0, !dbg !258
  %r136 = and i64 %r134, %r135, !dbg !258
  %r137 = call i64 @_ntp_write_u32(i64 %r133, i64 %r136), !dbg !258
  store i64 %r137, ptr %slot.out, align 8, !dbg !258
  %r138 = add i64 %r137, 0, !dbg !259
  %r139 = add i64 %r65, 0, !dbg !259
  %r140 = add i64 4294967295, 0, !dbg !259
  %r141 = and i64 %r139, %r140, !dbg !259
  %r142 = call i64 @_ntp_write_u32(i64 %r138, i64 %r141), !dbg !259
  store i64 %r142, ptr %slot.out, align 8, !dbg !259
  %r143 = add i64 %r142, 0, !dbg !260
  ret i64 %r143, !dbg !260
}

; ESCAPE ntp_decode: allocs=2 escape=2 local=0
define i64 @ntp_decode(i64 %p0) nounwind uwtable !dbg !261 {
entry:
  %slot.b = alloca i64, align 8, !dbg !262
  store i64 %p0, ptr %slot.b, align 8, !dbg !262
  %slot.empty = alloca i64, align 8, !dbg !262
  store i64 0, ptr %slot.empty, align 8, !dbg !262
  %slot.flags = alloca i64, align 8, !dbg !262
  store i64 0, ptr %slot.flags, align 8, !dbg !262
  %slot.li = alloca i64, align 8, !dbg !262
  store i64 0, ptr %slot.li, align 8, !dbg !262
  %slot.vn = alloca i64, align 8, !dbg !262
  store i64 0, ptr %slot.vn, align 8, !dbg !262
  %slot.mode = alloca i64, align 8, !dbg !262
  store i64 0, ptr %slot.mode, align 8, !dbg !262
  %slot.stratum = alloca i64, align 8, !dbg !262
  store i64 0, ptr %slot.stratum, align 8, !dbg !262
  %slot.poll = alloca i64, align 8, !dbg !262
  store i64 0, ptr %slot.poll, align 8, !dbg !262
  %slot.precision = alloca i64, align 8, !dbg !262
  store i64 0, ptr %slot.precision, align 8, !dbg !262
  %slot.root_delay = alloca i64, align 8, !dbg !262
  store i64 0, ptr %slot.root_delay, align 8, !dbg !262
  %slot.root_dispersion = alloca i64, align 8, !dbg !262
  store i64 0, ptr %slot.root_dispersion, align 8, !dbg !262
  %slot.reference_id = alloca i64, align 8, !dbg !262
  store i64 0, ptr %slot.reference_id, align 8, !dbg !262
  %slot.ref_sec = alloca i64, align 8, !dbg !262
  store i64 0, ptr %slot.ref_sec, align 8, !dbg !262
  %slot.ref_frac = alloca i64, align 8, !dbg !262
  store i64 0, ptr %slot.ref_frac, align 8, !dbg !262
  %slot.org_sec = alloca i64, align 8, !dbg !262
  store i64 0, ptr %slot.org_sec, align 8, !dbg !262
  %slot.org_frac = alloca i64, align 8, !dbg !262
  store i64 0, ptr %slot.org_frac, align 8, !dbg !262
  %slot.rx_sec = alloca i64, align 8, !dbg !262
  store i64 0, ptr %slot.rx_sec, align 8, !dbg !262
  %slot.rx_frac = alloca i64, align 8, !dbg !262
  store i64 0, ptr %slot.rx_frac, align 8, !dbg !262
  %slot.tx_sec = alloca i64, align 8, !dbg !262
  store i64 0, ptr %slot.tx_sec, align 8, !dbg !262
  %slot.tx_frac = alloca i64, align 8, !dbg !262
  store i64 0, ptr %slot.tx_frac, align 8, !dbg !262
  %r0 = call i64 @nova_rt_dict_create(), !dbg !263
  store i64 %r0, ptr %slot.empty, align 8, !dbg !263
  %r1 = load i64, ptr %slot.b, align 8, !dbg !264
  %r2 = call i64 @nova_rt_bytes_len(i64 %r1), !dbg !264
  %r3 = add i64 48, 0, !dbg !264
  %r4.cmp = icmp slt i64 %r2, %r3, !dbg !264
  %r4 = zext i1 %r4.cmp to i64, !dbg !264
  %br_then30 = icmp ne i64 %r4, 0, !dbg !264
  br i1 %br_then30, label %then3, label %else4, !dbg !264
then3:
  %r5 = load i64, ptr %slot.empty, align 8, !dbg !265
  ret i64 %r5, !dbg !265
else4:
  br label %endif5, !dbg !265
endif5:
  %r6 = load i64, ptr %slot.b, align 8, !dbg !266
  %r7 = add i64 0, 0, !dbg !266
  %r8 = call i64 @nova_rt_bytes_get(i64 %r6, i64 %r7), !dbg !266
  store i64 %r8, ptr %slot.flags, align 8, !dbg !266
  %r9 = add i64 %r8, 0, !dbg !267
  %r10 = add i64 6, 0, !dbg !267
  %r11.sramt = and i64 %r10, 63, !dbg !267
  %r11.srbig = icmp uge i64 %r10, 64, !dbg !267
  %r11.srval = ashr i64 %r9, %r11.sramt, !dbg !267
  %r11.srext = ashr i64 %r9, 63, !dbg !267
  %r11 = select i1 %r11.srbig, i64 %r11.srext, i64 %r11.srval, !dbg !267
  %r12 = add i64 3, 0, !dbg !267
  %r13 = and i64 %r11, %r12, !dbg !267
  store i64 %r13, ptr %slot.li, align 8, !dbg !267
  %r14 = add i64 %r8, 0, !dbg !268
  %r15 = add i64 3, 0, !dbg !268
  %r16.sramt = and i64 %r15, 63, !dbg !268
  %r16.srbig = icmp uge i64 %r15, 64, !dbg !268
  %r16.srval = ashr i64 %r14, %r16.sramt, !dbg !268
  %r16.srext = ashr i64 %r14, 63, !dbg !268
  %r16 = select i1 %r16.srbig, i64 %r16.srext, i64 %r16.srval, !dbg !268
  %r17 = add i64 7, 0, !dbg !268
  %r18 = and i64 %r16, %r17, !dbg !268
  store i64 %r18, ptr %slot.vn, align 8, !dbg !268
  %r19 = add i64 %r8, 0, !dbg !269
  %r20 = add i64 7, 0, !dbg !269
  %r21 = and i64 %r19, %r20, !dbg !269
  store i64 %r21, ptr %slot.mode, align 8, !dbg !269
  %r22 = load i64, ptr %slot.b, align 8, !dbg !270
  %r23 = add i64 1, 0, !dbg !270
  %r24 = call i64 @nova_rt_bytes_get(i64 %r22, i64 %r23), !dbg !270
  store i64 %r24, ptr %slot.stratum, align 8, !dbg !270
  %r25 = load i64, ptr %slot.b, align 8, !dbg !271
  %r26 = add i64 2, 0, !dbg !271
  %r27 = call i64 @nova_rt_bytes_get(i64 %r25, i64 %r26), !dbg !271
  store i64 %r27, ptr %slot.poll, align 8, !dbg !271
  %r28 = load i64, ptr %slot.b, align 8, !dbg !272
  %r29 = add i64 3, 0, !dbg !272
  %r30 = call i64 @nova_rt_bytes_get(i64 %r28, i64 %r29), !dbg !272
  store i64 %r30, ptr %slot.precision, align 8, !dbg !272
  %r31 = load i64, ptr %slot.b, align 8, !dbg !273
  %r32 = add i64 4, 0, !dbg !273
  %r33 = call i64 @_ntp_read_u32(i64 %r31, i64 %r32), !dbg !273
  store i64 %r33, ptr %slot.root_delay, align 8, !dbg !273
  %r34 = load i64, ptr %slot.b, align 8, !dbg !274
  %r35 = add i64 8, 0, !dbg !274
  %r36 = call i64 @_ntp_read_u32(i64 %r34, i64 %r35), !dbg !274
  store i64 %r36, ptr %slot.root_dispersion, align 8, !dbg !274
  %r37 = load i64, ptr %slot.b, align 8, !dbg !275
  %r38 = add i64 12, 0, !dbg !275
  %r39 = call i64 @_ntp_read_u32(i64 %r37, i64 %r38), !dbg !275
  store i64 %r39, ptr %slot.reference_id, align 8, !dbg !275
  %r40 = load i64, ptr %slot.b, align 8, !dbg !276
  %r41 = add i64 16, 0, !dbg !276
  %r42 = call i64 @_ntp_read_u32(i64 %r40, i64 %r41), !dbg !276
  store i64 %r42, ptr %slot.ref_sec, align 8, !dbg !276
  %r43 = load i64, ptr %slot.b, align 8, !dbg !277
  %r44 = add i64 20, 0, !dbg !277
  %r45 = call i64 @_ntp_read_u32(i64 %r43, i64 %r44), !dbg !277
  store i64 %r45, ptr %slot.ref_frac, align 8, !dbg !277
  %r46 = load i64, ptr %slot.b, align 8, !dbg !278
  %r47 = add i64 24, 0, !dbg !278
  %r48 = call i64 @_ntp_read_u32(i64 %r46, i64 %r47), !dbg !278
  store i64 %r48, ptr %slot.org_sec, align 8, !dbg !278
  %r49 = load i64, ptr %slot.b, align 8, !dbg !279
  %r50 = add i64 28, 0, !dbg !279
  %r51 = call i64 @_ntp_read_u32(i64 %r49, i64 %r50), !dbg !279
  store i64 %r51, ptr %slot.org_frac, align 8, !dbg !279
  %r52 = load i64, ptr %slot.b, align 8, !dbg !280
  %r53 = add i64 32, 0, !dbg !280
  %r54 = call i64 @_ntp_read_u32(i64 %r52, i64 %r53), !dbg !280
  store i64 %r54, ptr %slot.rx_sec, align 8, !dbg !280
  %r55 = load i64, ptr %slot.b, align 8, !dbg !281
  %r56 = add i64 36, 0, !dbg !281
  %r57 = call i64 @_ntp_read_u32(i64 %r55, i64 %r56), !dbg !281
  store i64 %r57, ptr %slot.rx_frac, align 8, !dbg !281
  %r58 = load i64, ptr %slot.b, align 8, !dbg !282
  %r59 = add i64 40, 0, !dbg !282
  %r60 = call i64 @_ntp_read_u32(i64 %r58, i64 %r59), !dbg !282
  store i64 %r60, ptr %slot.tx_sec, align 8, !dbg !282
  %r61 = load i64, ptr %slot.b, align 8, !dbg !283
  %r62 = add i64 44, 0, !dbg !283
  %r63 = call i64 @_ntp_read_u32(i64 %r61, i64 %r62), !dbg !283
  store i64 %r63, ptr %slot.tx_frac, align 8, !dbg !283
  %r64 = call i64 @nova_rt_dict_create(), !dbg !284
  %r65.p = getelementptr inbounds [3 x i8], ptr @.str.0, i64 0, i64 0, !dbg !284
  %r65 = ptrtoint ptr %r65.p to i64, !dbg !284
  %r66 = add i64 %r13, 0, !dbg !284
  call i64 @nova_rt_dict_set(i64 %r64, i64 %r65, i64 %r66), !dbg !284
  %r67.p = getelementptr inbounds [3 x i8], ptr @.str.1, i64 0, i64 0, !dbg !284
  %r67 = ptrtoint ptr %r67.p to i64, !dbg !284
  %r68 = add i64 %r18, 0, !dbg !284
  call i64 @nova_rt_dict_set(i64 %r64, i64 %r67, i64 %r68), !dbg !284
  %r69.p = getelementptr inbounds [5 x i8], ptr @.str.2, i64 0, i64 0, !dbg !284
  %r69 = ptrtoint ptr %r69.p to i64, !dbg !284
  %r70 = add i64 %r21, 0, !dbg !284
  call i64 @nova_rt_dict_set(i64 %r64, i64 %r69, i64 %r70), !dbg !284
  %r71.p = getelementptr inbounds [8 x i8], ptr @.str.3, i64 0, i64 0, !dbg !284
  %r71 = ptrtoint ptr %r71.p to i64, !dbg !284
  %r72 = add i64 %r24, 0, !dbg !284
  call i64 @nova_rt_dict_set(i64 %r64, i64 %r71, i64 %r72), !dbg !284
  %r73.p = getelementptr inbounds [5 x i8], ptr @.str.4, i64 0, i64 0, !dbg !284
  %r73 = ptrtoint ptr %r73.p to i64, !dbg !284
  %r74 = add i64 %r27, 0, !dbg !284
  call i64 @nova_rt_dict_set(i64 %r64, i64 %r73, i64 %r74), !dbg !284
  %r75.p = getelementptr inbounds [10 x i8], ptr @.str.5, i64 0, i64 0, !dbg !284
  %r75 = ptrtoint ptr %r75.p to i64, !dbg !284
  %r76 = add i64 %r30, 0, !dbg !284
  call i64 @nova_rt_dict_set(i64 %r64, i64 %r75, i64 %r76), !dbg !284
  %r77.p = getelementptr inbounds [11 x i8], ptr @.str.6, i64 0, i64 0, !dbg !284
  %r77 = ptrtoint ptr %r77.p to i64, !dbg !284
  %r78 = add i64 %r33, 0, !dbg !284
  call i64 @nova_rt_dict_set(i64 %r64, i64 %r77, i64 %r78), !dbg !284
  %r79.p = getelementptr inbounds [16 x i8], ptr @.str.7, i64 0, i64 0, !dbg !284
  %r79 = ptrtoint ptr %r79.p to i64, !dbg !284
  %r80 = add i64 %r36, 0, !dbg !284
  call i64 @nova_rt_dict_set(i64 %r64, i64 %r79, i64 %r80), !dbg !284
  %r81.p = getelementptr inbounds [13 x i8], ptr @.str.8, i64 0, i64 0, !dbg !284
  %r81 = ptrtoint ptr %r81.p to i64, !dbg !284
  %r82 = add i64 %r39, 0, !dbg !284
  call i64 @nova_rt_dict_set(i64 %r64, i64 %r81, i64 %r82), !dbg !284
  %r83.p = getelementptr inbounds [8 x i8], ptr @.str.9, i64 0, i64 0, !dbg !284
  %r83 = ptrtoint ptr %r83.p to i64, !dbg !284
  %r84 = add i64 %r42, 0, !dbg !284
  call i64 @nova_rt_dict_set(i64 %r64, i64 %r83, i64 %r84), !dbg !284
  %r85.p = getelementptr inbounds [9 x i8], ptr @.str.10, i64 0, i64 0, !dbg !284
  %r85 = ptrtoint ptr %r85.p to i64, !dbg !284
  %r86 = add i64 %r45, 0, !dbg !284
  call i64 @nova_rt_dict_set(i64 %r64, i64 %r85, i64 %r86), !dbg !284
  %r87.p = getelementptr inbounds [8 x i8], ptr @.str.11, i64 0, i64 0, !dbg !284
  %r87 = ptrtoint ptr %r87.p to i64, !dbg !284
  %r88 = add i64 %r48, 0, !dbg !284
  call i64 @nova_rt_dict_set(i64 %r64, i64 %r87, i64 %r88), !dbg !284
  %r89.p = getelementptr inbounds [9 x i8], ptr @.str.12, i64 0, i64 0, !dbg !284
  %r89 = ptrtoint ptr %r89.p to i64, !dbg !284
  %r90 = add i64 %r51, 0, !dbg !284
  call i64 @nova_rt_dict_set(i64 %r64, i64 %r89, i64 %r90), !dbg !284
  %r91.p = getelementptr inbounds [7 x i8], ptr @.str.13, i64 0, i64 0, !dbg !284
  %r91 = ptrtoint ptr %r91.p to i64, !dbg !284
  %r92 = add i64 %r54, 0, !dbg !284
  call i64 @nova_rt_dict_set(i64 %r64, i64 %r91, i64 %r92), !dbg !284
  %r93.p = getelementptr inbounds [8 x i8], ptr @.str.14, i64 0, i64 0, !dbg !284
  %r93 = ptrtoint ptr %r93.p to i64, !dbg !284
  %r94 = add i64 %r57, 0, !dbg !284
  call i64 @nova_rt_dict_set(i64 %r64, i64 %r93, i64 %r94), !dbg !284
  %r95.p = getelementptr inbounds [7 x i8], ptr @.str.15, i64 0, i64 0, !dbg !284
  %r95 = ptrtoint ptr %r95.p to i64, !dbg !284
  %r96 = add i64 %r60, 0, !dbg !284
  call i64 @nova_rt_dict_set(i64 %r64, i64 %r95, i64 %r96), !dbg !284
  %r97.p = getelementptr inbounds [8 x i8], ptr @.str.16, i64 0, i64 0, !dbg !284
  %r97 = ptrtoint ptr %r97.p to i64, !dbg !284
  %r98 = add i64 %r63, 0, !dbg !284
  call i64 @nova_rt_dict_set(i64 %r64, i64 %r97, i64 %r98), !dbg !284
  ret i64 %r64, !dbg !284
}

; ESCAPE nova_main: allocs=0 escape=0 local=0
define i64 @nova_main() nounwind uwtable {
entry:
  ret i64 0
}

; ESCAPE SUMMARY: allocs=2 escape=2 local=0 (0% local, RC-elidable)
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
@.str.0 = private unnamed_addr constant [3 x i8] c"li\00"
@.str.1 = private unnamed_addr constant [3 x i8] c"vn\00"
@.str.2 = private unnamed_addr constant [5 x i8] c"mode\00"
@.str.3 = private unnamed_addr constant [8 x i8] c"stratum\00"
@.str.4 = private unnamed_addr constant [5 x i8] c"poll\00"
@.str.5 = private unnamed_addr constant [10 x i8] c"precision\00"
@.str.6 = private unnamed_addr constant [11 x i8] c"root_delay\00"
@.str.7 = private unnamed_addr constant [16 x i8] c"root_dispersion\00"
@.str.8 = private unnamed_addr constant [13 x i8] c"reference_id\00"
@.str.9 = private unnamed_addr constant [8 x i8] c"ref_sec\00"
@.str.10 = private unnamed_addr constant [9 x i8] c"ref_frac\00"
@.str.11 = private unnamed_addr constant [8 x i8] c"org_sec\00"
@.str.12 = private unnamed_addr constant [9 x i8] c"org_frac\00"
@.str.13 = private unnamed_addr constant [7 x i8] c"rx_sec\00"
@.str.14 = private unnamed_addr constant [8 x i8] c"rx_frac\00"
@.str.15 = private unnamed_addr constant [7 x i8] c"tx_sec\00"
@.str.16 = private unnamed_addr constant [8 x i8] c"tx_frac\00"

; Debug metadata
!llvm.dbg.cu = !{!100}
!llvm.module.flags = !{!102, !103}

!100 = distinct !DICompileUnit(language: DW_LANG_C99, file: !101, producer: "NOVA Compiler", isOptimized: false, emissionKind: LineTablesOnly)
!101 = !DIFile(filename: "std/net/ntppkt.nova", directory: ".")
!102 = !{i32 2, !"CodeView", i32 1}
!103 = !{i32 2, !"Debug Info Version", i32 3}
!104 = !DISubroutineType(types: !105)
!105 = !{null}
!200 = distinct !DISubprogram(name: "_ntp_write_u16", scope: !101, file: !101, line: 43, type: !104, scopeLine: 43, spFlags: DISPFlagDefinition, unit: !100)
!201 = !DILocation(line: 43, column: 0, scope: !200)
!205 = distinct !DISubprogram(name: "_ntp_write_u32", scope: !101, file: !101, line: 49, type: !104, scopeLine: 49, spFlags: DISPFlagDefinition, unit: !100)
!206 = !DILocation(line: 49, column: 0, scope: !205)
!212 = distinct !DISubprogram(name: "_ntp_read_u32", scope: !101, file: !101, line: 58, type: !104, scopeLine: 58, spFlags: DISPFlagDefinition, unit: !100)
!213 = !DILocation(line: 58, column: 0, scope: !212)
!219 = distinct !DISubprogram(name: "_ntp_get", scope: !101, file: !101, line: 66, type: !104, scopeLine: 66, spFlags: DISPFlagDefinition, unit: !100)
!220 = !DILocation(line: 66, column: 0, scope: !219)
!224 = distinct !DISubprogram(name: "ntp_encode", scope: !101, file: !101, line: 93, type: !104, scopeLine: 93, spFlags: DISPFlagDefinition, unit: !100)
!225 = !DILocation(line: 93, column: 0, scope: !224)
!261 = distinct !DISubprogram(name: "ntp_decode", scope: !101, file: !101, line: 147, type: !104, scopeLine: 147, spFlags: DISPFlagDefinition, unit: !100)
!262 = !DILocation(line: 147, column: 0, scope: !261)
!202 = !DILocation(line: 44, column: 0, scope: !200)
!203 = !DILocation(line: 45, column: 0, scope: !200)
!204 = !DILocation(line: 46, column: 0, scope: !200)
!207 = !DILocation(line: 50, column: 0, scope: !205)
!208 = !DILocation(line: 51, column: 0, scope: !205)
!209 = !DILocation(line: 52, column: 0, scope: !205)
!210 = !DILocation(line: 53, column: 0, scope: !205)
!211 = !DILocation(line: 54, column: 0, scope: !205)
!214 = !DILocation(line: 59, column: 0, scope: !212)
!215 = !DILocation(line: 60, column: 0, scope: !212)
!216 = !DILocation(line: 61, column: 0, scope: !212)
!217 = !DILocation(line: 62, column: 0, scope: !212)
!218 = !DILocation(line: 63, column: 0, scope: !212)
!221 = !DILocation(line: 67, column: 0, scope: !219)
!222 = !DILocation(line: 68, column: 0, scope: !219)
!223 = !DILocation(line: 69, column: 0, scope: !219)
!226 = !DILocation(line: 94, column: 0, scope: !224)
!227 = !DILocation(line: 95, column: 0, scope: !224)
!228 = !DILocation(line: 96, column: 0, scope: !224)
!229 = !DILocation(line: 97, column: 0, scope: !224)
!230 = !DILocation(line: 98, column: 0, scope: !224)
!231 = !DILocation(line: 99, column: 0, scope: !224)
!232 = !DILocation(line: 100, column: 0, scope: !224)
!233 = !DILocation(line: 101, column: 0, scope: !224)
!234 = !DILocation(line: 102, column: 0, scope: !224)
!235 = !DILocation(line: 103, column: 0, scope: !224)
!236 = !DILocation(line: 104, column: 0, scope: !224)
!237 = !DILocation(line: 105, column: 0, scope: !224)
!238 = !DILocation(line: 106, column: 0, scope: !224)
!239 = !DILocation(line: 107, column: 0, scope: !224)
!240 = !DILocation(line: 108, column: 0, scope: !224)
!241 = !DILocation(line: 109, column: 0, scope: !224)
!242 = !DILocation(line: 110, column: 0, scope: !224)
!243 = !DILocation(line: 111, column: 0, scope: !224)
!244 = !DILocation(line: 112, column: 0, scope: !224)
!245 = !DILocation(line: 113, column: 0, scope: !224)
!246 = !DILocation(line: 114, column: 0, scope: !224)
!247 = !DILocation(line: 115, column: 0, scope: !224)
!248 = !DILocation(line: 116, column: 0, scope: !224)
!249 = !DILocation(line: 117, column: 0, scope: !224)
!250 = !DILocation(line: 118, column: 0, scope: !224)
!251 = !DILocation(line: 119, column: 0, scope: !224)
!252 = !DILocation(line: 120, column: 0, scope: !224)
!253 = !DILocation(line: 121, column: 0, scope: !224)
!254 = !DILocation(line: 122, column: 0, scope: !224)
!255 = !DILocation(line: 123, column: 0, scope: !224)
!256 = !DILocation(line: 124, column: 0, scope: !224)
!257 = !DILocation(line: 125, column: 0, scope: !224)
!258 = !DILocation(line: 126, column: 0, scope: !224)
!259 = !DILocation(line: 127, column: 0, scope: !224)
!260 = !DILocation(line: 128, column: 0, scope: !224)
!263 = !DILocation(line: 148, column: 0, scope: !261)
!264 = !DILocation(line: 149, column: 0, scope: !261)
!265 = !DILocation(line: 150, column: 0, scope: !261)
!266 = !DILocation(line: 151, column: 0, scope: !261)
!267 = !DILocation(line: 152, column: 0, scope: !261)
!268 = !DILocation(line: 153, column: 0, scope: !261)
!269 = !DILocation(line: 154, column: 0, scope: !261)
!270 = !DILocation(line: 155, column: 0, scope: !261)
!271 = !DILocation(line: 156, column: 0, scope: !261)
!272 = !DILocation(line: 157, column: 0, scope: !261)
!273 = !DILocation(line: 158, column: 0, scope: !261)
!274 = !DILocation(line: 159, column: 0, scope: !261)
!275 = !DILocation(line: 160, column: 0, scope: !261)
!276 = !DILocation(line: 161, column: 0, scope: !261)
!277 = !DILocation(line: 162, column: 0, scope: !261)
!278 = !DILocation(line: 163, column: 0, scope: !261)
!279 = !DILocation(line: 164, column: 0, scope: !261)
!280 = !DILocation(line: 165, column: 0, scope: !261)
!281 = !DILocation(line: 166, column: 0, scope: !261)
!282 = !DILocation(line: 167, column: 0, scope: !261)
!283 = !DILocation(line: 168, column: 0, scope: !261)
!284 = !DILocation(line: 169, column: 0, scope: !261)

; TBAA metadata
!0 = !{!"NOVA TBAA"}
!1 = !{!"list_data_ptr", !0}
!2 = !{!1, !1, i64 0}
!3 = !{!"list_elem", !0}
!4 = !{!3, !3, i64 0}
!5 = !{!"list_size", !0}
!6 = !{!5, !5, i64 0}
!90 = !{!"branch_weights", i32 2000, i32 1}
