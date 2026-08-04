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

; ESCAPE _u16le: allocs=0 escape=0 local=0
define i64 @_u16le(i64 %p0, i64 %p1) nounwind uwtable !dbg !200 {
entry:
  %slot.b = alloca i64, align 8, !dbg !201
  store i64 %p0, ptr %slot.b, align 8, !dbg !201
  %slot.p = alloca i64, align 8, !dbg !201
  store i64 %p1, ptr %slot.p, align 8, !dbg !201
  %r0 = load i64, ptr %slot.b, align 8, !dbg !202
  %r1 = call i64 @nova_rt_len_any(i64 %r0), !dbg !202
  %r2 = load i64, ptr %slot.p, align 8, !dbg !202
  %r3 = add i64 2, 0, !dbg !202
  %r4 = add i64 %r2, %r3, !dbg !202
  %r5.cmp = icmp slt i64 %r1, %r4, !dbg !202
  %r5 = zext i1 %r5.cmp to i64, !dbg !202
  %br_then00 = icmp ne i64 %r5, 0, !dbg !202
  br i1 %br_then00, label %then0, label %else1, !dbg !202
then0:
  %r6 = add i64 0, 0, !dbg !203
  ret i64 %r6, !dbg !203
else1:
  br label %endif2, !dbg !203
endif2:
  %r7 = load i64, ptr %slot.b, align 8, !dbg !204
  %r8 = load i64, ptr %slot.p, align 8, !dbg !204
  %r9 = call i64 @nova_rt_index_get(i64 %r7, i64 %r8), !dbg !204
  %r10 = load i64, ptr %slot.b, align 8, !dbg !204
  %r11 = load i64, ptr %slot.p, align 8, !dbg !204
  %r12 = add i64 1, 0, !dbg !204
  %r13 = add i64 %r11, %r12, !dbg !204
  %r14 = call i64 @nova_rt_index_get(i64 %r10, i64 %r13), !dbg !204
  %r15 = add i64 256, 0, !dbg !204
  %r16 = call i64 @nova_rt_mul(i64 %r14, i64 %r15), !dbg !204
  %r17 = call i64 @nova_rt_add(i64 %r9, i64 %r16), !dbg !204
  ret i64 %r17, !dbg !204
}

; ESCAPE _u16be: allocs=0 escape=0 local=0
define i64 @_u16be(i64 %p0, i64 %p1) nounwind uwtable !dbg !205 {
entry:
  %slot.b = alloca i64, align 8, !dbg !206
  store i64 %p0, ptr %slot.b, align 8, !dbg !206
  %slot.p = alloca i64, align 8, !dbg !206
  store i64 %p1, ptr %slot.p, align 8, !dbg !206
  %r0 = load i64, ptr %slot.b, align 8, !dbg !207
  %r1 = call i64 @nova_rt_len_any(i64 %r0), !dbg !207
  %r2 = load i64, ptr %slot.p, align 8, !dbg !207
  %r3 = add i64 2, 0, !dbg !207
  %r4 = add i64 %r2, %r3, !dbg !207
  %r5.cmp = icmp slt i64 %r1, %r4, !dbg !207
  %r5 = zext i1 %r5.cmp to i64, !dbg !207
  %br_then30 = icmp ne i64 %r5, 0, !dbg !207
  br i1 %br_then30, label %then3, label %else4, !dbg !207
then3:
  %r6 = add i64 0, 0, !dbg !208
  ret i64 %r6, !dbg !208
else4:
  br label %endif5, !dbg !208
endif5:
  %r7 = load i64, ptr %slot.b, align 8, !dbg !209
  %r8 = load i64, ptr %slot.p, align 8, !dbg !209
  %r9 = call i64 @nova_rt_index_get(i64 %r7, i64 %r8), !dbg !209
  %r10 = add i64 256, 0, !dbg !209
  %r11 = call i64 @nova_rt_mul(i64 %r9, i64 %r10), !dbg !209
  %r12 = load i64, ptr %slot.b, align 8, !dbg !209
  %r13 = load i64, ptr %slot.p, align 8, !dbg !209
  %r14 = add i64 1, 0, !dbg !209
  %r15 = add i64 %r13, %r14, !dbg !209
  %r16 = call i64 @nova_rt_index_get(i64 %r12, i64 %r15), !dbg !209
  %r17 = call i64 @nova_rt_add(i64 %r11, i64 %r16), !dbg !209
  ret i64 %r17, !dbg !209
}

; ESCAPE _u32le: allocs=0 escape=0 local=0
define i64 @_u32le(i64 %p0, i64 %p1) nounwind uwtable !dbg !210 {
entry:
  %slot.b = alloca i64, align 8, !dbg !211
  store i64 %p0, ptr %slot.b, align 8, !dbg !211
  %slot.p = alloca i64, align 8, !dbg !211
  store i64 %p1, ptr %slot.p, align 8, !dbg !211
  %r0 = load i64, ptr %slot.b, align 8, !dbg !212
  %r1 = call i64 @nova_rt_len_any(i64 %r0), !dbg !212
  %r2 = load i64, ptr %slot.p, align 8, !dbg !212
  %r3 = add i64 4, 0, !dbg !212
  %r4 = add i64 %r2, %r3, !dbg !212
  %r5.cmp = icmp slt i64 %r1, %r4, !dbg !212
  %r5 = zext i1 %r5.cmp to i64, !dbg !212
  %br_then60 = icmp ne i64 %r5, 0, !dbg !212
  br i1 %br_then60, label %then6, label %else7, !dbg !212
then6:
  %r6 = add i64 0, 0, !dbg !213
  ret i64 %r6, !dbg !213
else7:
  br label %endif8, !dbg !213
endif8:
  %r7 = load i64, ptr %slot.b, align 8, !dbg !214
  %r8 = load i64, ptr %slot.p, align 8, !dbg !214
  %r9 = call i64 @nova_rt_index_get(i64 %r7, i64 %r8), !dbg !214
  %r10 = load i64, ptr %slot.b, align 8, !dbg !214
  %r11 = load i64, ptr %slot.p, align 8, !dbg !214
  %r12 = add i64 1, 0, !dbg !214
  %r13 = add i64 %r11, %r12, !dbg !214
  %r14 = call i64 @nova_rt_index_get(i64 %r10, i64 %r13), !dbg !214
  %r15 = add i64 256, 0, !dbg !214
  %r16 = call i64 @nova_rt_mul(i64 %r14, i64 %r15), !dbg !214
  %r17 = call i64 @nova_rt_add(i64 %r9, i64 %r16), !dbg !214
  %r18 = load i64, ptr %slot.b, align 8, !dbg !214
  %r19 = load i64, ptr %slot.p, align 8, !dbg !214
  %r20 = add i64 2, 0, !dbg !214
  %r21 = add i64 %r19, %r20, !dbg !214
  %r22 = call i64 @nova_rt_index_get(i64 %r18, i64 %r21), !dbg !214
  %r23 = add i64 65536, 0, !dbg !214
  %r24 = call i64 @nova_rt_mul(i64 %r22, i64 %r23), !dbg !214
  %r25 = call i64 @nova_rt_add(i64 %r17, i64 %r24), !dbg !214
  %r26 = load i64, ptr %slot.b, align 8, !dbg !214
  %r27 = load i64, ptr %slot.p, align 8, !dbg !214
  %r28 = add i64 3, 0, !dbg !214
  %r29 = add i64 %r27, %r28, !dbg !214
  %r30 = call i64 @nova_rt_index_get(i64 %r26, i64 %r29), !dbg !214
  %r31 = add i64 16777216, 0, !dbg !214
  %r32 = call i64 @nova_rt_mul(i64 %r30, i64 %r31), !dbg !214
  %r33 = call i64 @nova_rt_add(i64 %r25, i64 %r32), !dbg !214
  ret i64 %r33, !dbg !214
}

; ESCAPE _u32be: allocs=0 escape=0 local=0
define i64 @_u32be(i64 %p0, i64 %p1) nounwind uwtable !dbg !215 {
entry:
  %slot.b = alloca i64, align 8, !dbg !216
  store i64 %p0, ptr %slot.b, align 8, !dbg !216
  %slot.p = alloca i64, align 8, !dbg !216
  store i64 %p1, ptr %slot.p, align 8, !dbg !216
  %r0 = load i64, ptr %slot.b, align 8, !dbg !217
  %r1 = call i64 @nova_rt_len_any(i64 %r0), !dbg !217
  %r2 = load i64, ptr %slot.p, align 8, !dbg !217
  %r3 = add i64 4, 0, !dbg !217
  %r4 = add i64 %r2, %r3, !dbg !217
  %r5.cmp = icmp slt i64 %r1, %r4, !dbg !217
  %r5 = zext i1 %r5.cmp to i64, !dbg !217
  %br_then90 = icmp ne i64 %r5, 0, !dbg !217
  br i1 %br_then90, label %then9, label %else10, !dbg !217
then9:
  %r6 = add i64 0, 0, !dbg !218
  ret i64 %r6, !dbg !218
else10:
  br label %endif11, !dbg !218
endif11:
  %r7 = load i64, ptr %slot.b, align 8, !dbg !219
  %r8 = load i64, ptr %slot.p, align 8, !dbg !219
  %r9 = call i64 @nova_rt_index_get(i64 %r7, i64 %r8), !dbg !219
  %r10 = add i64 16777216, 0, !dbg !219
  %r11 = call i64 @nova_rt_mul(i64 %r9, i64 %r10), !dbg !219
  %r12 = load i64, ptr %slot.b, align 8, !dbg !219
  %r13 = load i64, ptr %slot.p, align 8, !dbg !219
  %r14 = add i64 1, 0, !dbg !219
  %r15 = add i64 %r13, %r14, !dbg !219
  %r16 = call i64 @nova_rt_index_get(i64 %r12, i64 %r15), !dbg !219
  %r17 = add i64 65536, 0, !dbg !219
  %r18 = call i64 @nova_rt_mul(i64 %r16, i64 %r17), !dbg !219
  %r19 = call i64 @nova_rt_add(i64 %r11, i64 %r18), !dbg !219
  %r20 = load i64, ptr %slot.b, align 8, !dbg !219
  %r21 = load i64, ptr %slot.p, align 8, !dbg !219
  %r22 = add i64 2, 0, !dbg !219
  %r23 = add i64 %r21, %r22, !dbg !219
  %r24 = call i64 @nova_rt_index_get(i64 %r20, i64 %r23), !dbg !219
  %r25 = add i64 256, 0, !dbg !219
  %r26 = call i64 @nova_rt_mul(i64 %r24, i64 %r25), !dbg !219
  %r27 = call i64 @nova_rt_add(i64 %r19, i64 %r26), !dbg !219
  %r28 = load i64, ptr %slot.b, align 8, !dbg !219
  %r29 = load i64, ptr %slot.p, align 8, !dbg !219
  %r30 = add i64 3, 0, !dbg !219
  %r31 = add i64 %r29, %r30, !dbg !219
  %r32 = call i64 @nova_rt_index_get(i64 %r28, i64 %r31), !dbg !219
  %r33 = call i64 @nova_rt_add(i64 %r27, i64 %r32), !dbg !219
  ret i64 %r33, !dbg !219
}

; ESCAPE elf_magic_check: allocs=0 escape=0 local=0
define i64 @elf_magic_check(i64 %p0) nounwind uwtable !dbg !220 {
entry:
  %slot.buf = alloca i64, align 8, !dbg !221
  store i64 %p0, ptr %slot.buf, align 8, !dbg !221
  %r0 = load i64, ptr %slot.buf, align 8, !dbg !222
  %r1 = call i64 @nova_rt_len_any(i64 %r0), !dbg !222
  %r2 = add i64 4, 0, !dbg !222
  %r3.cmp = icmp slt i64 %r1, %r2, !dbg !222
  %r3 = zext i1 %r3.cmp to i64, !dbg !222
  %br_then120 = icmp ne i64 %r3, 0, !dbg !222
  br i1 %br_then120, label %then12, label %else13, !dbg !222
then12:
  %r4 = add i64 0, 0, !dbg !223
  ret i64 %r4, !dbg !223
else13:
  br label %endif14, !dbg !223
endif14:
  %r5 = load i64, ptr %slot.buf, align 8, !dbg !224
  %r6 = add i64 0, 0, !dbg !224
  %r7 = call i64 @nova_rt_index_get(i64 %r5, i64 %r6), !dbg !224
  %r8 = add i64 127, 0, !dbg !224
  %r9 = call i64 @nova_rt_neq(i64 %r7, i64 %r8), !dbg !224
  %br_then151 = icmp ne i64 %r9, 0, !dbg !224
  br i1 %br_then151, label %then15, label %else16, !dbg !224
then15:
  %r10 = add i64 0, 0, !dbg !225
  ret i64 %r10, !dbg !225
else16:
  br label %endif17, !dbg !225
endif17:
  %r11 = load i64, ptr %slot.buf, align 8, !dbg !226
  %r12 = add i64 1, 0, !dbg !226
  %r13 = call i64 @nova_rt_index_get(i64 %r11, i64 %r12), !dbg !226
  %r14 = add i64 69, 0, !dbg !226
  %r15 = call i64 @nova_rt_neq(i64 %r13, i64 %r14), !dbg !226
  %br_then182 = icmp ne i64 %r15, 0, !dbg !226
  br i1 %br_then182, label %then18, label %else19, !dbg !226
then18:
  %r16 = add i64 0, 0, !dbg !227
  ret i64 %r16, !dbg !227
else19:
  br label %endif20, !dbg !227
endif20:
  %r17 = load i64, ptr %slot.buf, align 8, !dbg !228
  %r18 = add i64 2, 0, !dbg !228
  %r19 = call i64 @nova_rt_index_get(i64 %r17, i64 %r18), !dbg !228
  %r20 = add i64 76, 0, !dbg !228
  %r21 = call i64 @nova_rt_neq(i64 %r19, i64 %r20), !dbg !228
  %br_then213 = icmp ne i64 %r21, 0, !dbg !228
  br i1 %br_then213, label %then21, label %else22, !dbg !228
then21:
  %r22 = add i64 0, 0, !dbg !229
  ret i64 %r22, !dbg !229
else22:
  br label %endif23, !dbg !229
endif23:
  %r23 = load i64, ptr %slot.buf, align 8, !dbg !230
  %r24 = add i64 3, 0, !dbg !230
  %r25 = call i64 @nova_rt_index_get(i64 %r23, i64 %r24), !dbg !230
  %r26 = add i64 70, 0, !dbg !230
  %r27 = call i64 @nova_rt_neq(i64 %r25, i64 %r26), !dbg !230
  %br_then244 = icmp ne i64 %r27, 0, !dbg !230
  br i1 %br_then244, label %then24, label %else25, !dbg !230
then24:
  %r28 = add i64 0, 0, !dbg !231
  ret i64 %r28, !dbg !231
else25:
  br label %endif26, !dbg !231
endif26:
  %r29 = add i64 1, 0, !dbg !232
  ret i64 %r29, !dbg !232
}

; ESCAPE elf_ei_class: allocs=0 escape=0 local=0
define i64 @elf_ei_class(i64 %p0) nounwind uwtable !dbg !233 {
entry:
  %slot.buf = alloca i64, align 8, !dbg !234
  store i64 %p0, ptr %slot.buf, align 8, !dbg !234
  %r0 = load i64, ptr %slot.buf, align 8, !dbg !235
  %r1 = call i64 @nova_rt_len_any(i64 %r0), !dbg !235
  %r2 = add i64 5, 0, !dbg !235
  %r3.cmp = icmp slt i64 %r1, %r2, !dbg !235
  %r3 = zext i1 %r3.cmp to i64, !dbg !235
  %br_then270 = icmp ne i64 %r3, 0, !dbg !235
  br i1 %br_then270, label %then27, label %else28, !dbg !235
then27:
  %r4 = add i64 0, 0, !dbg !236
  ret i64 %r4, !dbg !236
else28:
  br label %endif29, !dbg !236
endif29:
  %r5 = load i64, ptr %slot.buf, align 8, !dbg !237
  %r6 = add i64 4, 0, !dbg !237
  %r7 = call i64 @nova_rt_index_get(i64 %r5, i64 %r6), !dbg !237
  ret i64 %r7, !dbg !237
}

; ESCAPE elf_ei_data: allocs=0 escape=0 local=0
define i64 @elf_ei_data(i64 %p0) nounwind uwtable !dbg !238 {
entry:
  %slot.buf = alloca i64, align 8, !dbg !239
  store i64 %p0, ptr %slot.buf, align 8, !dbg !239
  %r0 = load i64, ptr %slot.buf, align 8, !dbg !240
  %r1 = call i64 @nova_rt_len_any(i64 %r0), !dbg !240
  %r2 = add i64 6, 0, !dbg !240
  %r3.cmp = icmp slt i64 %r1, %r2, !dbg !240
  %r3 = zext i1 %r3.cmp to i64, !dbg !240
  %br_then300 = icmp ne i64 %r3, 0, !dbg !240
  br i1 %br_then300, label %then30, label %else31, !dbg !240
then30:
  %r4 = add i64 0, 0, !dbg !241
  ret i64 %r4, !dbg !241
else31:
  br label %endif32, !dbg !241
endif32:
  %r5 = load i64, ptr %slot.buf, align 8, !dbg !242
  %r6 = add i64 5, 0, !dbg !242
  %r7 = call i64 @nova_rt_index_get(i64 %r5, i64 %r6), !dbg !242
  ret i64 %r7, !dbg !242
}

; ESCAPE elf_is_64bit: allocs=0 escape=0 local=0
define i64 @elf_is_64bit(i64 %p0) nounwind uwtable !dbg !243 {
entry:
  %slot.buf = alloca i64, align 8, !dbg !244
  store i64 %p0, ptr %slot.buf, align 8, !dbg !244
  %r0 = load i64, ptr %slot.buf, align 8, !dbg !245
  %r1 = call i64 @elf_ei_class(i64 %r0), !dbg !245
  %r2 = add i64 2, 0, !dbg !245
  %r3.cmp = icmp eq i64 %r1, %r2, !dbg !245
  %r3 = zext i1 %r3.cmp to i64, !dbg !245
  ret i64 %r3, !dbg !245
}

; ESCAPE elf_is_le: allocs=0 escape=0 local=0
define i64 @elf_is_le(i64 %p0) nounwind uwtable !dbg !246 {
entry:
  %slot.buf = alloca i64, align 8, !dbg !247
  store i64 %p0, ptr %slot.buf, align 8, !dbg !247
  %r0 = load i64, ptr %slot.buf, align 8, !dbg !248
  %r1 = call i64 @elf_ei_data(i64 %r0), !dbg !248
  %r2 = add i64 1, 0, !dbg !248
  %r3.cmp = icmp eq i64 %r1, %r2, !dbg !248
  %r3 = zext i1 %r3.cmp to i64, !dbg !248
  ret i64 %r3, !dbg !248
}

; ESCAPE elf_ei_osabi: allocs=0 escape=0 local=0
define i64 @elf_ei_osabi(i64 %p0) nounwind uwtable !dbg !249 {
entry:
  %slot.buf = alloca i64, align 8, !dbg !250
  store i64 %p0, ptr %slot.buf, align 8, !dbg !250
  %r0 = load i64, ptr %slot.buf, align 8, !dbg !251
  %r1 = call i64 @nova_rt_len_any(i64 %r0), !dbg !251
  %r2 = add i64 8, 0, !dbg !251
  %r3.cmp = icmp slt i64 %r1, %r2, !dbg !251
  %r3 = zext i1 %r3.cmp to i64, !dbg !251
  %br_then330 = icmp ne i64 %r3, 0, !dbg !251
  br i1 %br_then330, label %then33, label %else34, !dbg !251
then33:
  %r4 = add i64 0, 0, !dbg !252
  ret i64 %r4, !dbg !252
else34:
  br label %endif35, !dbg !252
endif35:
  %r5 = load i64, ptr %slot.buf, align 8, !dbg !253
  %r6 = add i64 7, 0, !dbg !253
  %r7 = call i64 @nova_rt_index_get(i64 %r5, i64 %r6), !dbg !253
  ret i64 %r7, !dbg !253
}

; ESCAPE elf_e_type: allocs=0 escape=0 local=0
define i64 @elf_e_type(i64 %p0) nounwind uwtable !dbg !254 {
entry:
  %slot.buf = alloca i64, align 8, !dbg !255
  store i64 %p0, ptr %slot.buf, align 8, !dbg !255
  %r0 = load i64, ptr %slot.buf, align 8, !dbg !256
  %r1 = call i64 @nova_rt_len_any(i64 %r0), !dbg !256
  %r2 = add i64 18, 0, !dbg !256
  %r3.cmp = icmp slt i64 %r1, %r2, !dbg !256
  %r3 = zext i1 %r3.cmp to i64, !dbg !256
  %br_then360 = icmp ne i64 %r3, 0, !dbg !256
  br i1 %br_then360, label %then36, label %else37, !dbg !256
then36:
  %r4 = add i64 0, 0, !dbg !257
  ret i64 %r4, !dbg !257
else37:
  br label %endif38, !dbg !257
endif38:
  %r5 = load i64, ptr %slot.buf, align 8, !dbg !258
  %r6 = call i64 @elf_ei_data(i64 %r5), !dbg !258
  %r7 = add i64 2, 0, !dbg !258
  %r8.cmp = icmp eq i64 %r6, %r7, !dbg !258
  %r8 = zext i1 %r8.cmp to i64, !dbg !258
  %br_then391 = icmp ne i64 %r8, 0, !dbg !258
  br i1 %br_then391, label %then39, label %else40, !dbg !258
then39:
  %r9 = load i64, ptr %slot.buf, align 8, !dbg !259
  %r10 = add i64 16, 0, !dbg !259
  %r11 = call i64 @_u16be(i64 %r9, i64 %r10), !dbg !259
  ret i64 %r11, !dbg !259
else40:
  br label %endif41, !dbg !259
endif41:
  %r12 = load i64, ptr %slot.buf, align 8, !dbg !260
  %r13 = add i64 16, 0, !dbg !260
  %r14 = call i64 @_u16le(i64 %r12, i64 %r13), !dbg !260
  ret i64 %r14, !dbg !260
}

; ESCAPE elf_e_machine: allocs=0 escape=0 local=0
define i64 @elf_e_machine(i64 %p0) nounwind uwtable !dbg !261 {
entry:
  %slot.buf = alloca i64, align 8, !dbg !262
  store i64 %p0, ptr %slot.buf, align 8, !dbg !262
  %r0 = load i64, ptr %slot.buf, align 8, !dbg !263
  %r1 = call i64 @nova_rt_len_any(i64 %r0), !dbg !263
  %r2 = add i64 20, 0, !dbg !263
  %r3.cmp = icmp slt i64 %r1, %r2, !dbg !263
  %r3 = zext i1 %r3.cmp to i64, !dbg !263
  %br_then420 = icmp ne i64 %r3, 0, !dbg !263
  br i1 %br_then420, label %then42, label %else43, !dbg !263
then42:
  %r4 = add i64 0, 0, !dbg !264
  ret i64 %r4, !dbg !264
else43:
  br label %endif44, !dbg !264
endif44:
  %r5 = load i64, ptr %slot.buf, align 8, !dbg !265
  %r6 = call i64 @elf_ei_data(i64 %r5), !dbg !265
  %r7 = add i64 2, 0, !dbg !265
  %r8.cmp = icmp eq i64 %r6, %r7, !dbg !265
  %r8 = zext i1 %r8.cmp to i64, !dbg !265
  %br_then451 = icmp ne i64 %r8, 0, !dbg !265
  br i1 %br_then451, label %then45, label %else46, !dbg !265
then45:
  %r9 = load i64, ptr %slot.buf, align 8, !dbg !266
  %r10 = add i64 18, 0, !dbg !266
  %r11 = call i64 @_u16be(i64 %r9, i64 %r10), !dbg !266
  ret i64 %r11, !dbg !266
else46:
  br label %endif47, !dbg !266
endif47:
  %r12 = load i64, ptr %slot.buf, align 8, !dbg !267
  %r13 = add i64 18, 0, !dbg !267
  %r14 = call i64 @_u16le(i64 %r12, i64 %r13), !dbg !267
  ret i64 %r14, !dbg !267
}

; ESCAPE elf_e_entry_low32: allocs=0 escape=0 local=0
define i64 @elf_e_entry_low32(i64 %p0) nounwind uwtable !dbg !268 {
entry:
  %slot.buf = alloca i64, align 8, !dbg !269
  store i64 %p0, ptr %slot.buf, align 8, !dbg !269
  %r0 = load i64, ptr %slot.buf, align 8, !dbg !270
  %r1 = call i64 @nova_rt_len_any(i64 %r0), !dbg !270
  %r2 = add i64 28, 0, !dbg !270
  %r3.cmp = icmp slt i64 %r1, %r2, !dbg !270
  %r3 = zext i1 %r3.cmp to i64, !dbg !270
  %br_then480 = icmp ne i64 %r3, 0, !dbg !270
  br i1 %br_then480, label %then48, label %else49, !dbg !270
then48:
  %r4 = add i64 0, 0, !dbg !271
  ret i64 %r4, !dbg !271
else49:
  br label %endif50, !dbg !271
endif50:
  %r5 = load i64, ptr %slot.buf, align 8, !dbg !272
  %r6 = call i64 @elf_ei_data(i64 %r5), !dbg !272
  %r7 = add i64 2, 0, !dbg !272
  %r8.cmp = icmp eq i64 %r6, %r7, !dbg !272
  %r8 = zext i1 %r8.cmp to i64, !dbg !272
  %br_then511 = icmp ne i64 %r8, 0, !dbg !272
  br i1 %br_then511, label %then51, label %else52, !dbg !272
then51:
  %r9 = load i64, ptr %slot.buf, align 8, !dbg !273
  %r10 = add i64 24, 0, !dbg !273
  %r11 = call i64 @_u32be(i64 %r9, i64 %r10), !dbg !273
  ret i64 %r11, !dbg !273
else52:
  br label %endif53, !dbg !273
endif53:
  %r12 = load i64, ptr %slot.buf, align 8, !dbg !274
  %r13 = add i64 24, 0, !dbg !274
  %r14 = call i64 @_u32le(i64 %r12, i64 %r13), !dbg !274
  ret i64 %r14, !dbg !274
}

; ESCAPE elf_class_name: allocs=0 escape=0 local=0
define i64 @elf_class_name(i64 %p0) nounwind uwtable !dbg !275 {
entry:
  %slot.buf = alloca i64, align 8, !dbg !276
  store i64 %p0, ptr %slot.buf, align 8, !dbg !276
  %slot.c = alloca i64, align 8, !dbg !276
  store i64 0, ptr %slot.c, align 8, !dbg !276
  %r0 = load i64, ptr %slot.buf, align 8, !dbg !277
  %r1 = call i64 @elf_ei_class(i64 %r0), !dbg !277
  store i64 %r1, ptr %slot.c, align 8, !dbg !277
  %r2 = add i64 %r1, 0, !dbg !278
  %r3 = add i64 1, 0, !dbg !278
  %r4.cmp = icmp eq i64 %r2, %r3, !dbg !278
  %r4 = zext i1 %r4.cmp to i64, !dbg !278
  %br_then540 = icmp ne i64 %r4, 0, !dbg !278
  br i1 %br_then540, label %then54, label %else55, !dbg !278
then54:
  %r5.p = getelementptr inbounds [6 x i8], ptr @.str.0, i64 0, i64 0, !dbg !279
  %r5 = ptrtoint ptr %r5.p to i64, !dbg !279
  ret i64 %r5, !dbg !279
else55:
  br label %endif56, !dbg !279
endif56:
  %r6 = load i64, ptr %slot.c, align 8, !dbg !280
  %r7 = add i64 2, 0, !dbg !280
  %r8.cmp = icmp eq i64 %r6, %r7, !dbg !280
  %r8 = zext i1 %r8.cmp to i64, !dbg !280
  %br_then571 = icmp ne i64 %r8, 0, !dbg !280
  br i1 %br_then571, label %then57, label %else58, !dbg !280
then57:
  %r9.p = getelementptr inbounds [6 x i8], ptr @.str.1, i64 0, i64 0, !dbg !281
  %r9 = ptrtoint ptr %r9.p to i64, !dbg !281
  ret i64 %r9, !dbg !281
else58:
  br label %endif59, !dbg !281
endif59:
  %r10.p = getelementptr inbounds [8 x i8], ptr @.str.2, i64 0, i64 0, !dbg !282
  %r10 = ptrtoint ptr %r10.p to i64, !dbg !282
  ret i64 %r10, !dbg !282
}

; ESCAPE elf_machine_name: allocs=0 escape=0 local=0
define i64 @elf_machine_name(i64 %p0) nounwind uwtable !dbg !283 {
entry:
  %slot.buf = alloca i64, align 8, !dbg !284
  store i64 %p0, ptr %slot.buf, align 8, !dbg !284
  %slot.m = alloca i64, align 8, !dbg !284
  store i64 0, ptr %slot.m, align 8, !dbg !284
  %r0 = load i64, ptr %slot.buf, align 8, !dbg !285
  %r1 = call i64 @elf_e_machine(i64 %r0), !dbg !285
  store i64 %r1, ptr %slot.m, align 8, !dbg !285
  %r2 = add i64 %r1, 0, !dbg !286
  %r3 = add i64 62, 0, !dbg !286
  %r4.cmp = icmp eq i64 %r2, %r3, !dbg !286
  %r4 = zext i1 %r4.cmp to i64, !dbg !286
  %br_then600 = icmp ne i64 %r4, 0, !dbg !286
  br i1 %br_then600, label %then60, label %else61, !dbg !286
then60:
  %r5.p = getelementptr inbounds [7 x i8], ptr @.str.3, i64 0, i64 0, !dbg !287
  %r5 = ptrtoint ptr %r5.p to i64, !dbg !287
  ret i64 %r5, !dbg !287
else61:
  br label %endif62, !dbg !287
endif62:
  %r6 = load i64, ptr %slot.m, align 8, !dbg !288
  %r7 = add i64 3, 0, !dbg !288
  %r8.cmp = icmp eq i64 %r6, %r7, !dbg !288
  %r8 = zext i1 %r8.cmp to i64, !dbg !288
  %br_then631 = icmp ne i64 %r8, 0, !dbg !288
  br i1 %br_then631, label %then63, label %else64, !dbg !288
then63:
  %r9.p = getelementptr inbounds [4 x i8], ptr @.str.4, i64 0, i64 0, !dbg !289
  %r9 = ptrtoint ptr %r9.p to i64, !dbg !289
  ret i64 %r9, !dbg !289
else64:
  br label %endif65, !dbg !289
endif65:
  %r10 = load i64, ptr %slot.m, align 8, !dbg !290
  %r11 = add i64 40, 0, !dbg !290
  %r12.cmp = icmp eq i64 %r10, %r11, !dbg !290
  %r12 = zext i1 %r12.cmp to i64, !dbg !290
  %br_then662 = icmp ne i64 %r12, 0, !dbg !290
  br i1 %br_then662, label %then66, label %else67, !dbg !290
then66:
  %r13.p = getelementptr inbounds [4 x i8], ptr @.str.5, i64 0, i64 0, !dbg !291
  %r13 = ptrtoint ptr %r13.p to i64, !dbg !291
  ret i64 %r13, !dbg !291
else67:
  br label %endif68, !dbg !291
endif68:
  %r14 = load i64, ptr %slot.m, align 8, !dbg !292
  %r15 = add i64 183, 0, !dbg !292
  %r16.cmp = icmp eq i64 %r14, %r15, !dbg !292
  %r16 = zext i1 %r16.cmp to i64, !dbg !292
  %br_then693 = icmp ne i64 %r16, 0, !dbg !292
  br i1 %br_then693, label %then69, label %else70, !dbg !292
then69:
  %r17.p = getelementptr inbounds [8 x i8], ptr @.str.6, i64 0, i64 0, !dbg !293
  %r17 = ptrtoint ptr %r17.p to i64, !dbg !293
  ret i64 %r17, !dbg !293
else70:
  br label %endif71, !dbg !293
endif71:
  %r18 = load i64, ptr %slot.m, align 8, !dbg !294
  %r19 = add i64 243, 0, !dbg !294
  %r20.cmp = icmp eq i64 %r18, %r19, !dbg !294
  %r20 = zext i1 %r20.cmp to i64, !dbg !294
  %br_then724 = icmp ne i64 %r20, 0, !dbg !294
  br i1 %br_then724, label %then72, label %else73, !dbg !294
then72:
  %r21.p = getelementptr inbounds [7 x i8], ptr @.str.7, i64 0, i64 0, !dbg !295
  %r21 = ptrtoint ptr %r21.p to i64, !dbg !295
  ret i64 %r21, !dbg !295
else73:
  br label %endif74, !dbg !295
endif74:
  %r22.p = getelementptr inbounds [8 x i8], ptr @.str.2, i64 0, i64 0, !dbg !296
  %r22 = ptrtoint ptr %r22.p to i64, !dbg !296
  ret i64 %r22, !dbg !296
}

; ESCAPE elf_type_name: allocs=0 escape=0 local=0
define i64 @elf_type_name(i64 %p0) nounwind uwtable !dbg !297 {
entry:
  %slot.buf = alloca i64, align 8, !dbg !298
  store i64 %p0, ptr %slot.buf, align 8, !dbg !298
  %slot.t = alloca i64, align 8, !dbg !298
  store i64 0, ptr %slot.t, align 8, !dbg !298
  %r0 = load i64, ptr %slot.buf, align 8, !dbg !299
  %r1 = call i64 @elf_e_type(i64 %r0), !dbg !299
  store i64 %r1, ptr %slot.t, align 8, !dbg !299
  %r2 = add i64 %r1, 0, !dbg !300
  %r3 = add i64 1, 0, !dbg !300
  %r4.cmp = icmp eq i64 %r2, %r3, !dbg !300
  %r4 = zext i1 %r4.cmp to i64, !dbg !300
  %br_then750 = icmp ne i64 %r4, 0, !dbg !300
  br i1 %br_then750, label %then75, label %else76, !dbg !300
then75:
  %r5.p = getelementptr inbounds [4 x i8], ptr @.str.8, i64 0, i64 0, !dbg !301
  %r5 = ptrtoint ptr %r5.p to i64, !dbg !301
  ret i64 %r5, !dbg !301
else76:
  br label %endif77, !dbg !301
endif77:
  %r6 = load i64, ptr %slot.t, align 8, !dbg !302
  %r7 = add i64 2, 0, !dbg !302
  %r8.cmp = icmp eq i64 %r6, %r7, !dbg !302
  %r8 = zext i1 %r8.cmp to i64, !dbg !302
  %br_then781 = icmp ne i64 %r8, 0, !dbg !302
  br i1 %br_then781, label %then78, label %else79, !dbg !302
then78:
  %r9.p = getelementptr inbounds [5 x i8], ptr @.str.9, i64 0, i64 0, !dbg !303
  %r9 = ptrtoint ptr %r9.p to i64, !dbg !303
  ret i64 %r9, !dbg !303
else79:
  br label %endif80, !dbg !303
endif80:
  %r10 = load i64, ptr %slot.t, align 8, !dbg !304
  %r11 = add i64 3, 0, !dbg !304
  %r12.cmp = icmp eq i64 %r10, %r11, !dbg !304
  %r12 = zext i1 %r12.cmp to i64, !dbg !304
  %br_then812 = icmp ne i64 %r12, 0, !dbg !304
  br i1 %br_then812, label %then81, label %else82, !dbg !304
then81:
  %r13.p = getelementptr inbounds [4 x i8], ptr @.str.10, i64 0, i64 0, !dbg !305
  %r13 = ptrtoint ptr %r13.p to i64, !dbg !305
  ret i64 %r13, !dbg !305
else82:
  br label %endif83, !dbg !305
endif83:
  %r14 = load i64, ptr %slot.t, align 8, !dbg !306
  %r15 = add i64 4, 0, !dbg !306
  %r16.cmp = icmp eq i64 %r14, %r15, !dbg !306
  %r16 = zext i1 %r16.cmp to i64, !dbg !306
  %br_then843 = icmp ne i64 %r16, 0, !dbg !306
  br i1 %br_then843, label %then84, label %else85, !dbg !306
then84:
  %r17.p = getelementptr inbounds [5 x i8], ptr @.str.11, i64 0, i64 0, !dbg !307
  %r17 = ptrtoint ptr %r17.p to i64, !dbg !307
  ret i64 %r17, !dbg !307
else85:
  br label %endif86, !dbg !307
endif86:
  %r18.p = getelementptr inbounds [8 x i8], ptr @.str.2, i64 0, i64 0, !dbg !308
  %r18 = ptrtoint ptr %r18.p to i64, !dbg !308
  ret i64 %r18, !dbg !308
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

; String constants
@.str.0 = private unnamed_addr constant [6 x i8] c"ELF32\00"
@.str.1 = private unnamed_addr constant [6 x i8] c"ELF64\00"
@.str.2 = private unnamed_addr constant [8 x i8] c"unknown\00"
@.str.3 = private unnamed_addr constant [7 x i8] c"x86-64\00"
@.str.4 = private unnamed_addr constant [4 x i8] c"x86\00"
@.str.5 = private unnamed_addr constant [4 x i8] c"ARM\00"
@.str.6 = private unnamed_addr constant [8 x i8] c"AArch64\00"
@.str.7 = private unnamed_addr constant [7 x i8] c"RISC-V\00"
@.str.8 = private unnamed_addr constant [4 x i8] c"REL\00"
@.str.9 = private unnamed_addr constant [5 x i8] c"EXEC\00"
@.str.10 = private unnamed_addr constant [4 x i8] c"DYN\00"
@.str.11 = private unnamed_addr constant [5 x i8] c"CORE\00"

; Debug metadata
!llvm.dbg.cu = !{!100}
!llvm.module.flags = !{!102, !103}

!100 = distinct !DICompileUnit(language: DW_LANG_C99, file: !101, producer: "NOVA Compiler", isOptimized: false, emissionKind: LineTablesOnly)
!101 = !DIFile(filename: "std/os/elf_header.nova", directory: ".")
!102 = !{i32 2, !"CodeView", i32 1}
!103 = !{i32 2, !"Debug Info Version", i32 3}
!104 = !DISubroutineType(types: !105)
!105 = !{null}
!200 = distinct !DISubprogram(name: "_u16le", scope: !101, file: !101, line: 7, type: !104, scopeLine: 7, spFlags: DISPFlagDefinition, unit: !100)
!201 = !DILocation(line: 7, column: 0, scope: !200)
!205 = distinct !DISubprogram(name: "_u16be", scope: !101, file: !101, line: 13, type: !104, scopeLine: 13, spFlags: DISPFlagDefinition, unit: !100)
!206 = !DILocation(line: 13, column: 0, scope: !205)
!210 = distinct !DISubprogram(name: "_u32le", scope: !101, file: !101, line: 19, type: !104, scopeLine: 19, spFlags: DISPFlagDefinition, unit: !100)
!211 = !DILocation(line: 19, column: 0, scope: !210)
!215 = distinct !DISubprogram(name: "_u32be", scope: !101, file: !101, line: 25, type: !104, scopeLine: 25, spFlags: DISPFlagDefinition, unit: !100)
!216 = !DILocation(line: 25, column: 0, scope: !215)
!220 = distinct !DISubprogram(name: "elf_magic_check", scope: !101, file: !101, line: 31, type: !104, scopeLine: 31, spFlags: DISPFlagDefinition, unit: !100)
!221 = !DILocation(line: 31, column: 0, scope: !220)
!233 = distinct !DISubprogram(name: "elf_ei_class", scope: !101, file: !101, line: 45, type: !104, scopeLine: 45, spFlags: DISPFlagDefinition, unit: !100)
!234 = !DILocation(line: 45, column: 0, scope: !233)
!238 = distinct !DISubprogram(name: "elf_ei_data", scope: !101, file: !101, line: 51, type: !104, scopeLine: 51, spFlags: DISPFlagDefinition, unit: !100)
!239 = !DILocation(line: 51, column: 0, scope: !238)
!243 = distinct !DISubprogram(name: "elf_is_64bit", scope: !101, file: !101, line: 57, type: !104, scopeLine: 57, spFlags: DISPFlagDefinition, unit: !100)
!244 = !DILocation(line: 57, column: 0, scope: !243)
!246 = distinct !DISubprogram(name: "elf_is_le", scope: !101, file: !101, line: 61, type: !104, scopeLine: 61, spFlags: DISPFlagDefinition, unit: !100)
!247 = !DILocation(line: 61, column: 0, scope: !246)
!249 = distinct !DISubprogram(name: "elf_ei_osabi", scope: !101, file: !101, line: 65, type: !104, scopeLine: 65, spFlags: DISPFlagDefinition, unit: !100)
!250 = !DILocation(line: 65, column: 0, scope: !249)
!254 = distinct !DISubprogram(name: "elf_e_type", scope: !101, file: !101, line: 71, type: !104, scopeLine: 71, spFlags: DISPFlagDefinition, unit: !100)
!255 = !DILocation(line: 71, column: 0, scope: !254)
!261 = distinct !DISubprogram(name: "elf_e_machine", scope: !101, file: !101, line: 79, type: !104, scopeLine: 79, spFlags: DISPFlagDefinition, unit: !100)
!262 = !DILocation(line: 79, column: 0, scope: !261)
!268 = distinct !DISubprogram(name: "elf_e_entry_low32", scope: !101, file: !101, line: 87, type: !104, scopeLine: 87, spFlags: DISPFlagDefinition, unit: !100)
!269 = !DILocation(line: 87, column: 0, scope: !268)
!275 = distinct !DISubprogram(name: "elf_class_name", scope: !101, file: !101, line: 95, type: !104, scopeLine: 95, spFlags: DISPFlagDefinition, unit: !100)
!276 = !DILocation(line: 95, column: 0, scope: !275)
!283 = distinct !DISubprogram(name: "elf_machine_name", scope: !101, file: !101, line: 104, type: !104, scopeLine: 104, spFlags: DISPFlagDefinition, unit: !100)
!284 = !DILocation(line: 104, column: 0, scope: !283)
!297 = distinct !DISubprogram(name: "elf_type_name", scope: !101, file: !101, line: 119, type: !104, scopeLine: 119, spFlags: DISPFlagDefinition, unit: !100)
!298 = !DILocation(line: 119, column: 0, scope: !297)
!202 = !DILocation(line: 8, column: 0, scope: !200)
!203 = !DILocation(line: 9, column: 0, scope: !200)
!204 = !DILocation(line: 10, column: 0, scope: !200)
!207 = !DILocation(line: 14, column: 0, scope: !205)
!208 = !DILocation(line: 15, column: 0, scope: !205)
!209 = !DILocation(line: 16, column: 0, scope: !205)
!212 = !DILocation(line: 20, column: 0, scope: !210)
!213 = !DILocation(line: 21, column: 0, scope: !210)
!214 = !DILocation(line: 22, column: 0, scope: !210)
!217 = !DILocation(line: 26, column: 0, scope: !215)
!218 = !DILocation(line: 27, column: 0, scope: !215)
!219 = !DILocation(line: 28, column: 0, scope: !215)
!222 = !DILocation(line: 32, column: 0, scope: !220)
!223 = !DILocation(line: 33, column: 0, scope: !220)
!224 = !DILocation(line: 34, column: 0, scope: !220)
!225 = !DILocation(line: 35, column: 0, scope: !220)
!226 = !DILocation(line: 36, column: 0, scope: !220)
!227 = !DILocation(line: 37, column: 0, scope: !220)
!228 = !DILocation(line: 38, column: 0, scope: !220)
!229 = !DILocation(line: 39, column: 0, scope: !220)
!230 = !DILocation(line: 40, column: 0, scope: !220)
!231 = !DILocation(line: 41, column: 0, scope: !220)
!232 = !DILocation(line: 42, column: 0, scope: !220)
!235 = !DILocation(line: 46, column: 0, scope: !233)
!236 = !DILocation(line: 47, column: 0, scope: !233)
!237 = !DILocation(line: 48, column: 0, scope: !233)
!240 = !DILocation(line: 52, column: 0, scope: !238)
!241 = !DILocation(line: 53, column: 0, scope: !238)
!242 = !DILocation(line: 54, column: 0, scope: !238)
!245 = !DILocation(line: 58, column: 0, scope: !243)
!248 = !DILocation(line: 62, column: 0, scope: !246)
!251 = !DILocation(line: 66, column: 0, scope: !249)
!252 = !DILocation(line: 67, column: 0, scope: !249)
!253 = !DILocation(line: 68, column: 0, scope: !249)
!256 = !DILocation(line: 72, column: 0, scope: !254)
!257 = !DILocation(line: 73, column: 0, scope: !254)
!258 = !DILocation(line: 74, column: 0, scope: !254)
!259 = !DILocation(line: 75, column: 0, scope: !254)
!260 = !DILocation(line: 76, column: 0, scope: !254)
!263 = !DILocation(line: 80, column: 0, scope: !261)
!264 = !DILocation(line: 81, column: 0, scope: !261)
!265 = !DILocation(line: 82, column: 0, scope: !261)
!266 = !DILocation(line: 83, column: 0, scope: !261)
!267 = !DILocation(line: 84, column: 0, scope: !261)
!270 = !DILocation(line: 88, column: 0, scope: !268)
!271 = !DILocation(line: 89, column: 0, scope: !268)
!272 = !DILocation(line: 90, column: 0, scope: !268)
!273 = !DILocation(line: 91, column: 0, scope: !268)
!274 = !DILocation(line: 92, column: 0, scope: !268)
!277 = !DILocation(line: 96, column: 0, scope: !275)
!278 = !DILocation(line: 97, column: 0, scope: !275)
!279 = !DILocation(line: 98, column: 0, scope: !275)
!280 = !DILocation(line: 99, column: 0, scope: !275)
!281 = !DILocation(line: 100, column: 0, scope: !275)
!282 = !DILocation(line: 101, column: 0, scope: !275)
!285 = !DILocation(line: 105, column: 0, scope: !283)
!286 = !DILocation(line: 106, column: 0, scope: !283)
!287 = !DILocation(line: 107, column: 0, scope: !283)
!288 = !DILocation(line: 108, column: 0, scope: !283)
!289 = !DILocation(line: 109, column: 0, scope: !283)
!290 = !DILocation(line: 110, column: 0, scope: !283)
!291 = !DILocation(line: 111, column: 0, scope: !283)
!292 = !DILocation(line: 112, column: 0, scope: !283)
!293 = !DILocation(line: 113, column: 0, scope: !283)
!294 = !DILocation(line: 114, column: 0, scope: !283)
!295 = !DILocation(line: 115, column: 0, scope: !283)
!296 = !DILocation(line: 116, column: 0, scope: !283)
!299 = !DILocation(line: 120, column: 0, scope: !297)
!300 = !DILocation(line: 121, column: 0, scope: !297)
!301 = !DILocation(line: 122, column: 0, scope: !297)
!302 = !DILocation(line: 123, column: 0, scope: !297)
!303 = !DILocation(line: 124, column: 0, scope: !297)
!304 = !DILocation(line: 125, column: 0, scope: !297)
!305 = !DILocation(line: 126, column: 0, scope: !297)
!306 = !DILocation(line: 127, column: 0, scope: !297)
!307 = !DILocation(line: 128, column: 0, scope: !297)
!308 = !DILocation(line: 129, column: 0, scope: !297)

; TBAA metadata
!0 = !{!"NOVA TBAA"}
!1 = !{!"list_data_ptr", !0}
!2 = !{!1, !1, i64 0}
!3 = !{!"list_elem", !0}
!4 = !{!3, !3, i64 0}
!5 = !{!"list_size", !0}
!6 = !{!5, !5, i64 0}
!90 = !{!"branch_weights", i32 2000, i32 1}
