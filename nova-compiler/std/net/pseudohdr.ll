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

; ESCAPE _ph_w32: allocs=0 escape=0 local=0
define i64 @_ph_w32(i64 %p0, i64 %p1) nounwind uwtable !dbg !200 {
entry:
  %slot.out = alloca i64, align 8, !dbg !201
  store i64 %p0, ptr %slot.out, align 8, !dbg !201
  %slot.v = alloca i64, align 8, !dbg !201
  store i64 %p1, ptr %slot.v, align 8, !dbg !201
  %r0 = load i64, ptr %slot.out, align 8, !dbg !202
  %r1 = load i64, ptr %slot.v, align 8, !dbg !202
  %r2 = add i64 24, 0, !dbg !202
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
  %r9 = add i64 16, 0, !dbg !203
  %r10.sramt = and i64 %r9, 63, !dbg !203
  %r10.srbig = icmp uge i64 %r9, 64, !dbg !203
  %r10.srval = ashr i64 %r8, %r10.sramt, !dbg !203
  %r10.srext = ashr i64 %r8, 63, !dbg !203
  %r10 = select i1 %r10.srbig, i64 %r10.srext, i64 %r10.srval, !dbg !203
  %r11 = add i64 255, 0, !dbg !203
  %r12 = and i64 %r10, %r11, !dbg !203
  %r13 = call i64 @nova_rt_bytes_append(i64 %r7, i64 %r12), !dbg !203
  store i64 %r13, ptr %slot.out, align 8, !dbg !203
  %r14 = add i64 %r13, 0, !dbg !204
  %r15 = load i64, ptr %slot.v, align 8, !dbg !204
  %r16 = add i64 8, 0, !dbg !204
  %r17.sramt = and i64 %r16, 63, !dbg !204
  %r17.srbig = icmp uge i64 %r16, 64, !dbg !204
  %r17.srval = ashr i64 %r15, %r17.sramt, !dbg !204
  %r17.srext = ashr i64 %r15, 63, !dbg !204
  %r17 = select i1 %r17.srbig, i64 %r17.srext, i64 %r17.srval, !dbg !204
  %r18 = add i64 255, 0, !dbg !204
  %r19 = and i64 %r17, %r18, !dbg !204
  %r20 = call i64 @nova_rt_bytes_append(i64 %r14, i64 %r19), !dbg !204
  store i64 %r20, ptr %slot.out, align 8, !dbg !204
  %r21 = add i64 %r20, 0, !dbg !205
  %r22 = load i64, ptr %slot.v, align 8, !dbg !205
  %r23 = add i64 255, 0, !dbg !205
  %r24 = and i64 %r22, %r23, !dbg !205
  %r25 = call i64 @nova_rt_bytes_append(i64 %r21, i64 %r24), !dbg !205
  store i64 %r25, ptr %slot.out, align 8, !dbg !205
  %r26 = add i64 %r25, 0, !dbg !206
  ret i64 %r26, !dbg !206
}

; ESCAPE _ph_w16: allocs=0 escape=0 local=0
define i64 @_ph_w16(i64 %p0, i64 %p1) nounwind uwtable !dbg !207 {
entry:
  %slot.out = alloca i64, align 8, !dbg !208
  store i64 %p0, ptr %slot.out, align 8, !dbg !208
  %slot.v = alloca i64, align 8, !dbg !208
  store i64 %p1, ptr %slot.v, align 8, !dbg !208
  %r0 = load i64, ptr %slot.out, align 8, !dbg !209
  %r1 = load i64, ptr %slot.v, align 8, !dbg !209
  %r2 = add i64 8, 0, !dbg !209
  %r3.sramt = and i64 %r2, 63, !dbg !209
  %r3.srbig = icmp uge i64 %r2, 64, !dbg !209
  %r3.srval = ashr i64 %r1, %r3.sramt, !dbg !209
  %r3.srext = ashr i64 %r1, 63, !dbg !209
  %r3 = select i1 %r3.srbig, i64 %r3.srext, i64 %r3.srval, !dbg !209
  %r4 = add i64 255, 0, !dbg !209
  %r5 = and i64 %r3, %r4, !dbg !209
  %r6 = call i64 @nova_rt_bytes_append(i64 %r0, i64 %r5), !dbg !209
  store i64 %r6, ptr %slot.out, align 8, !dbg !209
  %r7 = add i64 %r6, 0, !dbg !210
  %r8 = load i64, ptr %slot.v, align 8, !dbg !210
  %r9 = add i64 255, 0, !dbg !210
  %r10 = and i64 %r8, %r9, !dbg !210
  %r11 = call i64 @nova_rt_bytes_append(i64 %r7, i64 %r10), !dbg !210
  store i64 %r11, ptr %slot.out, align 8, !dbg !210
  %r12 = add i64 %r11, 0, !dbg !211
  ret i64 %r12, !dbg !211
}

; ESCAPE _ph_copy16: allocs=0 escape=0 local=0
define i64 @_ph_copy16(i64 %p0, i64 %p1, i64 %p2) nounwind uwtable !dbg !212 {
entry:
  %slot.dst_b = alloca i64, align 8, !dbg !213
  store i64 %p0, ptr %slot.dst_b, align 8, !dbg !213
  %slot.src_b = alloca i64, align 8, !dbg !213
  store i64 %p1, ptr %slot.src_b, align 8, !dbg !213
  %slot.off = alloca i64, align 8, !dbg !213
  store i64 %p2, ptr %slot.off, align 8, !dbg !213
  %slot.src_len = alloca i64, align 8, !dbg !213
  store i64 0, ptr %slot.src_len, align 8, !dbg !213
  %slot.i = alloca i64, align 8, !dbg !213
  store i64 0, ptr %slot.i, align 8, !dbg !213
  %r0 = load i64, ptr %slot.src_b, align 8, !dbg !214
  %r1 = call i64 @nova_rt_bytes_len(i64 %r0), !dbg !214
  store i64 %r1, ptr %slot.src_len, align 8, !dbg !214
  %r2 = add i64 0, 0, !dbg !215
  store i64 %r2, ptr %slot.i, align 8, !dbg !215
  br label %while_hdr0, !dbg !216
while_hdr0:
  %r3 = load i64, ptr %slot.i, align 8, !dbg !216
  %r4 = add i64 16, 0, !dbg !216
  %r5.cmp = icmp slt i64 %r3, %r4, !dbg !216
  %r5 = zext i1 %r5.cmp to i64, !dbg !216
  %br_while_body10 = icmp ne i64 %r5, 0, !dbg !216
  br i1 %br_while_body10, label %while_body1, label %while_exit2, !prof !90, !dbg !216
while_body1:
  %r6 = load i64, ptr %slot.i, align 8, !dbg !217
  %r7 = load i64, ptr %slot.src_len, align 8, !dbg !217
  %r8.cmp = icmp slt i64 %r6, %r7, !dbg !217
  %r8 = zext i1 %r8.cmp to i64, !dbg !217
  %br_then31 = icmp ne i64 %r8, 0, !dbg !217
  br i1 %br_then31, label %then3, label %else4, !dbg !217
then3:
  %r9 = load i64, ptr %slot.dst_b, align 8, !dbg !218
  %r10 = load i64, ptr %slot.off, align 8, !dbg !218
  %r11 = load i64, ptr %slot.i, align 8, !dbg !218
  %r12 = add i64 %r10, %r11, !dbg !218
  %r13 = load i64, ptr %slot.src_b, align 8, !dbg !218
  %r14 = load i64, ptr %slot.i, align 8, !dbg !218
  %r15 = call i64 @nova_rt_bytes_get(i64 %r13, i64 %r14), !dbg !218
  %r16 = call i64 @nova_rt_bytes_set(i64 %r9, i64 %r12, i64 %r15), !dbg !218
  br label %endif5, !dbg !218
else4:
  br label %endif5, !dbg !218
endif5:
  %r17 = load i64, ptr %slot.i, align 8, !dbg !219
  %r18 = add i64 1, 0, !dbg !219
  %r19 = add i64 %r17, %r18, !dbg !219
  store i64 %r19, ptr %slot.i, align 8, !dbg !219
  br label %while_hdr0, !dbg !219
while_exit2:
  %r20 = load i64, ptr %slot.dst_b, align 8, !dbg !220
  ret i64 %r20, !dbg !220
}

; ESCAPE _ph_checksum: allocs=0 escape=0 local=0
define i64 @_ph_checksum(i64 %p0) nounwind uwtable !dbg !221 {
entry:
  %slot.b = alloca i64, align 8, !dbg !222
  store i64 %p0, ptr %slot.b, align 8, !dbg !222
  %slot.acc = alloca i64, align 8, !dbg !222
  store i64 0, ptr %slot.acc, align 8, !dbg !222
  %slot.i = alloca i64, align 8, !dbg !222
  store i64 0, ptr %slot.i, align 8, !dbg !222
  %slot.n = alloca i64, align 8, !dbg !222
  store i64 0, ptr %slot.n, align 8, !dbg !222
  %r0 = add i64 0, 0, !dbg !223
  store i64 %r0, ptr %slot.acc, align 8, !dbg !223
  %r1 = add i64 0, 0, !dbg !224
  store i64 %r1, ptr %slot.i, align 8, !dbg !224
  %r2 = load i64, ptr %slot.b, align 8, !dbg !225
  %r3 = call i64 @nova_rt_bytes_len(i64 %r2), !dbg !225
  store i64 %r3, ptr %slot.n, align 8, !dbg !225
  br label %while_hdr6, !dbg !226
while_hdr6:
  %r4 = load i64, ptr %slot.i, align 8, !dbg !226
  %r5 = add i64 1, 0, !dbg !226
  %r6 = add i64 %r4, %r5, !dbg !226
  %r7 = load i64, ptr %slot.n, align 8, !dbg !226
  %r8.cmp = icmp slt i64 %r6, %r7, !dbg !226
  %r8 = zext i1 %r8.cmp to i64, !dbg !226
  %br_while_body70 = icmp ne i64 %r8, 0, !dbg !226
  br i1 %br_while_body70, label %while_body7, label %while_exit8, !prof !90, !dbg !226
while_body7:
  %r9 = load i64, ptr %slot.acc, align 8, !dbg !227
  %r10 = load i64, ptr %slot.b, align 8, !dbg !227
  %r11 = load i64, ptr %slot.i, align 8, !dbg !227
  %r12 = call i64 @nova_rt_bytes_get(i64 %r10, i64 %r11), !dbg !227
  %r13 = add i64 8, 0, !dbg !227
  %r14.shamt = and i64 %r13, 63, !dbg !227
  %r14.shbig = icmp uge i64 %r13, 64, !dbg !227
  %r14.shval = shl i64 %r12, %r14.shamt, !dbg !227
  %r14 = select i1 %r14.shbig, i64 0, i64 %r14.shval, !dbg !227
  %r15 = load i64, ptr %slot.b, align 8, !dbg !227
  %r16 = load i64, ptr %slot.i, align 8, !dbg !227
  %r17 = add i64 1, 0, !dbg !227
  %r18 = add i64 %r16, %r17, !dbg !227
  %r19 = call i64 @nova_rt_bytes_get(i64 %r15, i64 %r18), !dbg !227
  %r20 = or i64 %r14, %r19, !dbg !227
  %r21 = call i64 @nova_rt_add(i64 %r9, i64 %r20), !dbg !227
  store i64 %r21, ptr %slot.acc, align 8, !dbg !227
  %r22 = load i64, ptr %slot.i, align 8, !dbg !228
  %r23 = add i64 2, 0, !dbg !228
  %r24 = add i64 %r22, %r23, !dbg !228
  store i64 %r24, ptr %slot.i, align 8, !dbg !228
  br label %while_hdr6, !dbg !228
while_exit8:
  %r25 = load i64, ptr %slot.i, align 8, !dbg !229
  %r26 = load i64, ptr %slot.n, align 8, !dbg !229
  %r27.cmp = icmp slt i64 %r25, %r26, !dbg !229
  %r27 = zext i1 %r27.cmp to i64, !dbg !229
  %br_then91 = icmp ne i64 %r27, 0, !dbg !229
  br i1 %br_then91, label %then9, label %else10, !dbg !229
then9:
  %r28 = load i64, ptr %slot.acc, align 8, !dbg !230
  %r29 = load i64, ptr %slot.b, align 8, !dbg !230
  %r30 = load i64, ptr %slot.i, align 8, !dbg !230
  %r31 = call i64 @nova_rt_bytes_get(i64 %r29, i64 %r30), !dbg !230
  %r32 = add i64 8, 0, !dbg !230
  %r33.shamt = and i64 %r32, 63, !dbg !230
  %r33.shbig = icmp uge i64 %r32, 64, !dbg !230
  %r33.shval = shl i64 %r31, %r33.shamt, !dbg !230
  %r33 = select i1 %r33.shbig, i64 0, i64 %r33.shval, !dbg !230
  %r34 = call i64 @nova_rt_add(i64 %r28, i64 %r33), !dbg !230
  store i64 %r34, ptr %slot.acc, align 8, !dbg !230
  br label %endif11, !dbg !230
else10:
  br label %endif11, !dbg !230
endif11:
  br label %while_hdr12, !dbg !231
while_hdr12:
  %r35 = load i64, ptr %slot.acc, align 8, !dbg !231
  %r36 = add i64 16, 0, !dbg !231
  %r37.sramt = and i64 %r36, 63, !dbg !231
  %r37.srbig = icmp uge i64 %r36, 64, !dbg !231
  %r37.srval = ashr i64 %r35, %r37.sramt, !dbg !231
  %r37.srext = ashr i64 %r35, 63, !dbg !231
  %r37 = select i1 %r37.srbig, i64 %r37.srext, i64 %r37.srval, !dbg !231
  %r38 = add i64 0, 0, !dbg !231
  %r39 = call i64 @nova_rt_neq(i64 %r37, i64 %r38), !dbg !231
  %br_while_body132 = icmp ne i64 %r39, 0, !dbg !231
  br i1 %br_while_body132, label %while_body13, label %while_exit14, !prof !90, !dbg !231
while_body13:
  %r40 = load i64, ptr %slot.acc, align 8, !dbg !232
  %r41 = add i64 65535, 0, !dbg !232
  %r42 = and i64 %r40, %r41, !dbg !232
  %r43 = load i64, ptr %slot.acc, align 8, !dbg !232
  %r44 = add i64 16, 0, !dbg !232
  %r45.sramt = and i64 %r44, 63, !dbg !232
  %r45.srbig = icmp uge i64 %r44, 64, !dbg !232
  %r45.srval = ashr i64 %r43, %r45.sramt, !dbg !232
  %r45.srext = ashr i64 %r43, 63, !dbg !232
  %r45 = select i1 %r45.srbig, i64 %r45.srext, i64 %r45.srval, !dbg !232
  %r46 = call i64 @nova_rt_add(i64 %r42, i64 %r45), !dbg !232
  store i64 %r46, ptr %slot.acc, align 8, !dbg !232
  br label %while_hdr12, !dbg !232
while_exit14:
  %r47 = load i64, ptr %slot.acc, align 8, !dbg !233
  %r48 = xor i64 %r47, -1, !dbg !233
  %r49 = add i64 65535, 0, !dbg !233
  %r50 = and i64 %r48, %r49, !dbg !233
  ret i64 %r50, !dbg !233
}

; ESCAPE pseudo4: allocs=0 escape=0 local=0
define i64 @pseudo4(i64 %p0, i64 %p1, i64 %p2, i64 %p3) nounwind uwtable !dbg !234 {
entry:
  %slot.src = alloca i64, align 8, !dbg !235
  store i64 %p0, ptr %slot.src, align 8, !dbg !235
  %slot.dst = alloca i64, align 8, !dbg !235
  store i64 %p1, ptr %slot.dst, align 8, !dbg !235
  %slot.protocol = alloca i64, align 8, !dbg !235
  store i64 %p2, ptr %slot.protocol, align 8, !dbg !235
  %slot.length = alloca i64, align 8, !dbg !235
  store i64 %p3, ptr %slot.length, align 8, !dbg !235
  %slot.out = alloca i64, align 8, !dbg !235
  store i64 0, ptr %slot.out, align 8, !dbg !235
  %r0 = add i64 0, 0, !dbg !236
  %r1 = call i64 @nova_rt_bytes_create(i64 %r0), !dbg !236
  store i64 %r1, ptr %slot.out, align 8, !dbg !236
  %r2 = add i64 %r1, 0, !dbg !237
  %r3 = load i64, ptr %slot.src, align 8, !dbg !237
  %r4 = add i64 4294967295, 0, !dbg !237
  %r5 = and i64 %r3, %r4, !dbg !237
  %r6 = call i64 @_ph_w32(i64 %r2, i64 %r5), !dbg !237
  store i64 %r6, ptr %slot.out, align 8, !dbg !237
  %r7 = add i64 %r6, 0, !dbg !238
  %r8 = load i64, ptr %slot.dst, align 8, !dbg !238
  %r9 = add i64 4294967295, 0, !dbg !238
  %r10 = and i64 %r8, %r9, !dbg !238
  %r11 = call i64 @_ph_w32(i64 %r7, i64 %r10), !dbg !238
  store i64 %r11, ptr %slot.out, align 8, !dbg !238
  %r12 = add i64 %r11, 0, !dbg !239
  %r13 = add i64 0, 0, !dbg !239
  %r14 = call i64 @nova_rt_bytes_append(i64 %r12, i64 %r13), !dbg !239
  store i64 %r14, ptr %slot.out, align 8, !dbg !239
  %r15 = add i64 %r14, 0, !dbg !240
  %r16 = load i64, ptr %slot.protocol, align 8, !dbg !240
  %r17 = add i64 255, 0, !dbg !240
  %r18 = and i64 %r16, %r17, !dbg !240
  %r19 = call i64 @nova_rt_bytes_append(i64 %r15, i64 %r18), !dbg !240
  store i64 %r19, ptr %slot.out, align 8, !dbg !240
  %r20 = add i64 %r19, 0, !dbg !241
  %r21 = load i64, ptr %slot.length, align 8, !dbg !241
  %r22 = add i64 65535, 0, !dbg !241
  %r23 = and i64 %r21, %r22, !dbg !241
  %r24 = call i64 @_ph_w16(i64 %r20, i64 %r23), !dbg !241
  store i64 %r24, ptr %slot.out, align 8, !dbg !241
  %r25 = add i64 %r24, 0, !dbg !242
  ret i64 %r25, !dbg !242
}

; ESCAPE pseudo6: allocs=0 escape=0 local=0
define i64 @pseudo6(i64 %p0, i64 %p1, i64 %p2, i64 %p3) nounwind uwtable !dbg !243 {
entry:
  %slot.src_bytes = alloca i64, align 8, !dbg !244
  store i64 %p0, ptr %slot.src_bytes, align 8, !dbg !244
  %slot.dst_bytes = alloca i64, align 8, !dbg !244
  store i64 %p1, ptr %slot.dst_bytes, align 8, !dbg !244
  %slot.next_header = alloca i64, align 8, !dbg !244
  store i64 %p2, ptr %slot.next_header, align 8, !dbg !244
  %slot.length = alloca i64, align 8, !dbg !244
  store i64 %p3, ptr %slot.length, align 8, !dbg !244
  %slot.out = alloca i64, align 8, !dbg !244
  store i64 0, ptr %slot.out, align 8, !dbg !244
  %r0 = add i64 40, 0, !dbg !245
  %r1 = call i64 @nova_rt_bytes_create(i64 %r0), !dbg !245
  store i64 %r1, ptr %slot.out, align 8, !dbg !245
  %r2 = add i64 %r1, 0, !dbg !246
  %r3 = load i64, ptr %slot.src_bytes, align 8, !dbg !246
  %r4 = add i64 0, 0, !dbg !246
  %r5 = call i64 @_ph_copy16(i64 %r2, i64 %r3, i64 %r4), !dbg !246
  store i64 %r5, ptr %slot.out, align 8, !dbg !246
  %r6 = add i64 %r5, 0, !dbg !247
  %r7 = load i64, ptr %slot.dst_bytes, align 8, !dbg !247
  %r8 = add i64 16, 0, !dbg !247
  %r9 = call i64 @_ph_copy16(i64 %r6, i64 %r7, i64 %r8), !dbg !247
  store i64 %r9, ptr %slot.out, align 8, !dbg !247
  %r10 = add i64 %r9, 0, !dbg !248
  %r11 = add i64 32, 0, !dbg !248
  %r12 = load i64, ptr %slot.length, align 8, !dbg !248
  %r13 = add i64 24, 0, !dbg !248
  %r14.sramt = and i64 %r13, 63, !dbg !248
  %r14.srbig = icmp uge i64 %r13, 64, !dbg !248
  %r14.srval = ashr i64 %r12, %r14.sramt, !dbg !248
  %r14.srext = ashr i64 %r12, 63, !dbg !248
  %r14 = select i1 %r14.srbig, i64 %r14.srext, i64 %r14.srval, !dbg !248
  %r15 = add i64 255, 0, !dbg !248
  %r16 = and i64 %r14, %r15, !dbg !248
  %r17 = call i64 @nova_rt_bytes_set(i64 %r10, i64 %r11, i64 %r16), !dbg !248
  %r18 = add i64 %r9, 0, !dbg !249
  %r19 = add i64 33, 0, !dbg !249
  %r20 = load i64, ptr %slot.length, align 8, !dbg !249
  %r21 = add i64 16, 0, !dbg !249
  %r22.sramt = and i64 %r21, 63, !dbg !249
  %r22.srbig = icmp uge i64 %r21, 64, !dbg !249
  %r22.srval = ashr i64 %r20, %r22.sramt, !dbg !249
  %r22.srext = ashr i64 %r20, 63, !dbg !249
  %r22 = select i1 %r22.srbig, i64 %r22.srext, i64 %r22.srval, !dbg !249
  %r23 = add i64 255, 0, !dbg !249
  %r24 = and i64 %r22, %r23, !dbg !249
  %r25 = call i64 @nova_rt_bytes_set(i64 %r18, i64 %r19, i64 %r24), !dbg !249
  %r26 = add i64 %r9, 0, !dbg !250
  %r27 = add i64 34, 0, !dbg !250
  %r28 = load i64, ptr %slot.length, align 8, !dbg !250
  %r29 = add i64 8, 0, !dbg !250
  %r30.sramt = and i64 %r29, 63, !dbg !250
  %r30.srbig = icmp uge i64 %r29, 64, !dbg !250
  %r30.srval = ashr i64 %r28, %r30.sramt, !dbg !250
  %r30.srext = ashr i64 %r28, 63, !dbg !250
  %r30 = select i1 %r30.srbig, i64 %r30.srext, i64 %r30.srval, !dbg !250
  %r31 = add i64 255, 0, !dbg !250
  %r32 = and i64 %r30, %r31, !dbg !250
  %r33 = call i64 @nova_rt_bytes_set(i64 %r26, i64 %r27, i64 %r32), !dbg !250
  %r34 = add i64 %r9, 0, !dbg !251
  %r35 = add i64 35, 0, !dbg !251
  %r36 = load i64, ptr %slot.length, align 8, !dbg !251
  %r37 = add i64 255, 0, !dbg !251
  %r38 = and i64 %r36, %r37, !dbg !251
  %r39 = call i64 @nova_rt_bytes_set(i64 %r34, i64 %r35, i64 %r38), !dbg !251
  %r40 = add i64 %r9, 0, !dbg !252
  %r41 = add i64 36, 0, !dbg !252
  %r42 = add i64 0, 0, !dbg !252
  %r43 = call i64 @nova_rt_bytes_set(i64 %r40, i64 %r41, i64 %r42), !dbg !252
  %r44 = add i64 %r9, 0, !dbg !253
  %r45 = add i64 37, 0, !dbg !253
  %r46 = add i64 0, 0, !dbg !253
  %r47 = call i64 @nova_rt_bytes_set(i64 %r44, i64 %r45, i64 %r46), !dbg !253
  %r48 = add i64 %r9, 0, !dbg !254
  %r49 = add i64 38, 0, !dbg !254
  %r50 = add i64 0, 0, !dbg !254
  %r51 = call i64 @nova_rt_bytes_set(i64 %r48, i64 %r49, i64 %r50), !dbg !254
  %r52 = add i64 %r9, 0, !dbg !255
  %r53 = add i64 39, 0, !dbg !255
  %r54 = load i64, ptr %slot.next_header, align 8, !dbg !255
  %r55 = add i64 255, 0, !dbg !255
  %r56 = and i64 %r54, %r55, !dbg !255
  %r57 = call i64 @nova_rt_bytes_set(i64 %r52, i64 %r53, i64 %r56), !dbg !255
  %r58 = add i64 %r9, 0, !dbg !256
  ret i64 %r58, !dbg !256
}

; ESCAPE l4_checksum: allocs=0 escape=0 local=0
define i64 @l4_checksum(i64 %p0, i64 %p1) nounwind uwtable !dbg !257 {
entry:
  %slot.pseudo = alloca i64, align 8, !dbg !258
  store i64 %p0, ptr %slot.pseudo, align 8, !dbg !258
  %slot.l4_bytes = alloca i64, align 8, !dbg !258
  store i64 %p1, ptr %slot.l4_bytes, align 8, !dbg !258
  %slot.combined = alloca i64, align 8, !dbg !258
  store i64 0, ptr %slot.combined, align 8, !dbg !258
  %r0 = load i64, ptr %slot.pseudo, align 8, !dbg !259
  %r1 = load i64, ptr %slot.l4_bytes, align 8, !dbg !259
  %r2 = call i64 @nova_rt_bytes_concat(i64 %r0, i64 %r1), !dbg !259
  store i64 %r2, ptr %slot.combined, align 8, !dbg !259
  %r3 = add i64 %r2, 0, !dbg !260
  %r4 = call i64 @_ph_checksum(i64 %r3), !dbg !260
  ret i64 %r4, !dbg !260
}

; ESCAPE nova_main: allocs=0 escape=0 local=0
define i64 @nova_main() nounwind uwtable {
entry:
  ret i64 0
}

; ESCAPE SUMMARY: allocs=0 escape=0 local=0 (0% local, RC-elidable)
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

; Debug metadata
!llvm.dbg.cu = !{!100}
!llvm.module.flags = !{!102, !103}

!100 = distinct !DICompileUnit(language: DW_LANG_C99, file: !101, producer: "NOVA Compiler", isOptimized: false, emissionKind: LineTablesOnly)
!101 = !DIFile(filename: "std/net/pseudohdr.nova", directory: ".")
!102 = !{i32 2, !"CodeView", i32 1}
!103 = !{i32 2, !"Debug Info Version", i32 3}
!104 = !DISubroutineType(types: !105)
!105 = !{null}
!200 = distinct !DISubprogram(name: "_ph_w32", scope: !101, file: !101, line: 53, type: !104, scopeLine: 53, spFlags: DISPFlagDefinition, unit: !100)
!201 = !DILocation(line: 53, column: 0, scope: !200)
!207 = distinct !DISubprogram(name: "_ph_w16", scope: !101, file: !101, line: 61, type: !104, scopeLine: 61, spFlags: DISPFlagDefinition, unit: !100)
!208 = !DILocation(line: 61, column: 0, scope: !207)
!212 = distinct !DISubprogram(name: "_ph_copy16", scope: !101, file: !101, line: 68, type: !104, scopeLine: 68, spFlags: DISPFlagDefinition, unit: !100)
!213 = !DILocation(line: 68, column: 0, scope: !212)
!221 = distinct !DISubprogram(name: "_ph_checksum", scope: !101, file: !101, line: 79, type: !104, scopeLine: 79, spFlags: DISPFlagDefinition, unit: !100)
!222 = !DILocation(line: 79, column: 0, scope: !221)
!234 = distinct !DISubprogram(name: "pseudo4", scope: !101, file: !101, line: 107, type: !104, scopeLine: 107, spFlags: DISPFlagDefinition, unit: !100)
!235 = !DILocation(line: 107, column: 0, scope: !234)
!243 = distinct !DISubprogram(name: "pseudo6", scope: !101, file: !101, line: 129, type: !104, scopeLine: 129, spFlags: DISPFlagDefinition, unit: !100)
!244 = !DILocation(line: 129, column: 0, scope: !243)
!257 = distinct !DISubprogram(name: "l4_checksum", scope: !101, file: !101, line: 166, type: !104, scopeLine: 166, spFlags: DISPFlagDefinition, unit: !100)
!258 = !DILocation(line: 166, column: 0, scope: !257)
!202 = !DILocation(line: 54, column: 0, scope: !200)
!203 = !DILocation(line: 55, column: 0, scope: !200)
!204 = !DILocation(line: 56, column: 0, scope: !200)
!205 = !DILocation(line: 57, column: 0, scope: !200)
!206 = !DILocation(line: 58, column: 0, scope: !200)
!209 = !DILocation(line: 62, column: 0, scope: !207)
!210 = !DILocation(line: 63, column: 0, scope: !207)
!211 = !DILocation(line: 64, column: 0, scope: !207)
!214 = !DILocation(line: 69, column: 0, scope: !212)
!215 = !DILocation(line: 70, column: 0, scope: !212)
!216 = !DILocation(line: 71, column: 0, scope: !212)
!217 = !DILocation(line: 72, column: 0, scope: !212)
!218 = !DILocation(line: 73, column: 0, scope: !212)
!219 = !DILocation(line: 74, column: 0, scope: !212)
!220 = !DILocation(line: 75, column: 0, scope: !212)
!223 = !DILocation(line: 80, column: 0, scope: !221)
!224 = !DILocation(line: 81, column: 0, scope: !221)
!225 = !DILocation(line: 82, column: 0, scope: !221)
!226 = !DILocation(line: 83, column: 0, scope: !221)
!227 = !DILocation(line: 84, column: 0, scope: !221)
!228 = !DILocation(line: 85, column: 0, scope: !221)
!229 = !DILocation(line: 86, column: 0, scope: !221)
!230 = !DILocation(line: 87, column: 0, scope: !221)
!231 = !DILocation(line: 88, column: 0, scope: !221)
!232 = !DILocation(line: 89, column: 0, scope: !221)
!233 = !DILocation(line: 90, column: 0, scope: !221)
!236 = !DILocation(line: 108, column: 0, scope: !234)
!237 = !DILocation(line: 109, column: 0, scope: !234)
!238 = !DILocation(line: 110, column: 0, scope: !234)
!239 = !DILocation(line: 111, column: 0, scope: !234)
!240 = !DILocation(line: 112, column: 0, scope: !234)
!241 = !DILocation(line: 113, column: 0, scope: !234)
!242 = !DILocation(line: 114, column: 0, scope: !234)
!245 = !DILocation(line: 130, column: 0, scope: !243)
!246 = !DILocation(line: 131, column: 0, scope: !243)
!247 = !DILocation(line: 132, column: 0, scope: !243)
!248 = !DILocation(line: 133, column: 0, scope: !243)
!249 = !DILocation(line: 134, column: 0, scope: !243)
!250 = !DILocation(line: 135, column: 0, scope: !243)
!251 = !DILocation(line: 136, column: 0, scope: !243)
!252 = !DILocation(line: 137, column: 0, scope: !243)
!253 = !DILocation(line: 138, column: 0, scope: !243)
!254 = !DILocation(line: 139, column: 0, scope: !243)
!255 = !DILocation(line: 140, column: 0, scope: !243)
!256 = !DILocation(line: 141, column: 0, scope: !243)
!259 = !DILocation(line: 167, column: 0, scope: !257)
!260 = !DILocation(line: 168, column: 0, scope: !257)

; TBAA metadata
!0 = !{!"NOVA TBAA"}
!1 = !{!"list_data_ptr", !0}
!2 = !{!1, !1, i64 0}
!3 = !{!"list_elem", !0}
!4 = !{!3, !3, i64 0}
!5 = !{!"list_size", !0}
!6 = !{!5, !5, i64 0}
!90 = !{!"branch_weights", i32 2000, i32 1}
