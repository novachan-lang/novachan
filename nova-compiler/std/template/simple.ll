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

; ESCAPE _ts_parse: allocs=4 escape=1 local=3
define i64 @_ts_parse(i64 %p0) nounwind uwtable !dbg !200 {
entry:
  %slot.template = alloca i64, align 8, !dbg !201
  store i64 %p0, ptr %slot.template, align 8, !dbg !201
  %slot.toks = alloca i64, align 8, !dbg !201
  store i64 0, ptr %slot.toks, align 8, !dbg !201
  %slot.lit = alloca i64, align 8, !dbg !201
  store i64 0, ptr %slot.lit, align 8, !dbg !201
  %slot.i = alloca i64, align 8, !dbg !201
  store i64 0, ptr %slot.i, align 8, !dbg !201
  %slot.n = alloca i64, align 8, !dbg !201
  store i64 0, ptr %slot.n, align 8, !dbg !201
  %slot.__sc_3 = alloca i64, align 8, !dbg !201
  store i64 0, ptr %slot.__sc_3, align 8, !dbg !201
  %slot.__sc_6 = alloca i64, align 8, !dbg !201
  store i64 0, ptr %slot.__sc_6, align 8, !dbg !201
  %slot.j = alloca i64, align 8, !dbg !201
  store i64 0, ptr %slot.j, align 8, !dbg !201
  %slot.key = alloca i64, align 8, !dbg !201
  store i64 0, ptr %slot.key, align 8, !dbg !201
  %slot.closed = alloca i64, align 8, !dbg !201
  store i64 0, ptr %slot.closed, align 8, !dbg !201
  %slot.__sc_18 = alloca i64, align 8, !dbg !201
  store i64 0, ptr %slot.__sc_18, align 8, !dbg !201
  %slot.__sc_21 = alloca i64, align 8, !dbg !201
  store i64 0, ptr %slot.__sc_21, align 8, !dbg !201
  %r0 = call i64 @nova_rt_list_create(), !dbg !202
  store i64 %r0, ptr %slot.toks, align 8, !dbg !202
  %r1.p = getelementptr inbounds [1 x i8], ptr @.str.0, i64 0, i64 0, !dbg !203
  %r1 = ptrtoint ptr %r1.p to i64, !dbg !203
  store i64 %r1, ptr %slot.lit, align 8, !dbg !203
  %r2 = add i64 0, 0, !dbg !204
  store i64 %r2, ptr %slot.i, align 8, !dbg !204
  %r3 = load i64, ptr %slot.template, align 8, !dbg !205
  %r4 = call i64 @nova_rt_len_any(i64 %r3), !dbg !205
  store i64 %r4, ptr %slot.n, align 8, !dbg !205
  br label %while_hdr0, !dbg !206
while_hdr0:
  %r5 = load i64, ptr %slot.i, align 8, !dbg !206
  %r6 = load i64, ptr %slot.n, align 8, !dbg !206
  %r7.cmp = icmp slt i64 %r5, %r6, !dbg !206
  %r7 = zext i1 %r7.cmp to i64, !dbg !206
  %br_while_body10 = icmp ne i64 %r7, 0, !dbg !206
  br i1 %br_while_body10, label %while_body1, label %while_exit2, !prof !90, !dbg !206
while_body1:
  %r8 = load i64, ptr %slot.i, align 8, !dbg !207
  %r9 = add i64 1, 0, !dbg !207
  %r10 = add i64 %r8, %r9, !dbg !207
  %r11 = load i64, ptr %slot.n, align 8, !dbg !207
  %r12.cmp = icmp slt i64 %r10, %r11, !dbg !207
  %r12 = zext i1 %r12.cmp to i64, !dbg !207
  store i64 %r12, ptr %slot.__sc_3, align 8, !dbg !207
  %br_and_rhs41 = icmp ne i64 %r12, 0, !dbg !207
  br i1 %br_and_rhs41, label %and_rhs4, label %and_merge5, !dbg !207
and_rhs4:
  %r13 = load i64, ptr %slot.template, align 8, !dbg !207
  %r14 = load i64, ptr %slot.i, align 8, !dbg !207
  %r15 = call i64 @nova_rt_char_at(i64 %r13, i64 %r14), !dbg !207
  %r16 = call i64 @nova_rt_ord(i64 %r15), !dbg !207
  %r17 = add i64 123, 0, !dbg !207
  %r18.cmp = icmp eq i64 %r16, %r17, !dbg !207
  %r18 = zext i1 %r18.cmp to i64, !dbg !207
  store i64 %r18, ptr %slot.__sc_3, align 8, !dbg !207
  br label %and_merge5, !dbg !207
and_merge5:
  %r19 = load i64, ptr %slot.__sc_3, align 8, !dbg !207
  store i64 %r19, ptr %slot.__sc_6, align 8, !dbg !207
  %br_and_rhs72 = icmp ne i64 %r19, 0, !dbg !207
  br i1 %br_and_rhs72, label %and_rhs7, label %and_merge8, !dbg !207
and_rhs7:
  %r20 = load i64, ptr %slot.template, align 8, !dbg !207
  %r21 = load i64, ptr %slot.i, align 8, !dbg !207
  %r22 = add i64 1, 0, !dbg !207
  %r23 = add i64 %r21, %r22, !dbg !207
  %r24 = call i64 @nova_rt_char_at(i64 %r20, i64 %r23), !dbg !207
  %r25 = call i64 @nova_rt_ord(i64 %r24), !dbg !207
  %r26 = add i64 123, 0, !dbg !207
  %r27.cmp = icmp eq i64 %r25, %r26, !dbg !207
  %r27 = zext i1 %r27.cmp to i64, !dbg !207
  store i64 %r27, ptr %slot.__sc_6, align 8, !dbg !207
  br label %and_merge8, !dbg !207
and_merge8:
  %r28 = load i64, ptr %slot.__sc_6, align 8, !dbg !207
  %br_then93 = icmp ne i64 %r28, 0, !dbg !207
  br i1 %br_then93, label %then9, label %else10, !dbg !207
then9:
  %r29 = load i64, ptr %slot.lit, align 8, !dbg !208
  %r30 = call i64 @nova_rt_len_any(i64 %r29), !dbg !208
  %r31 = add i64 0, 0, !dbg !208
  %r32.cmp = icmp sgt i64 %r30, %r31, !dbg !208
  %r32 = zext i1 %r32.cmp to i64, !dbg !208
  %br_then124 = icmp ne i64 %r32, 0, !dbg !208
  br i1 %br_then124, label %then12, label %else13, !dbg !208
then12:
  %r33 = load i64, ptr %slot.toks, align 8, !dbg !209
  %r35.p = getelementptr inbounds [2 x i8], ptr @.str.1, i64 0, i64 0, !dbg !209
  %r35 = ptrtoint ptr %r35.p to i64, !dbg !209
  %r36 = load i64, ptr %slot.lit, align 8, !dbg !209
  %r34 = call i64 @nova_rt_list_create(), !dbg !209
  call i64 @nova_rt_list_append(i64 %r34, i64 %r35), !dbg !209
  call i64 @nova_rt_list_append(i64 %r34, i64 %r36), !dbg !209
  %r37 = call i64 @nova_rt_list_append(i64 %r33, i64 %r34), !dbg !209
  %r38.p = getelementptr inbounds [1 x i8], ptr @.str.0, i64 0, i64 0, !dbg !210
  %r38 = ptrtoint ptr %r38.p to i64, !dbg !210
  store i64 %r38, ptr %slot.lit, align 8, !dbg !210
  br label %endif14, !dbg !210
else13:
  br label %endif14, !dbg !210
endif14:
  %r39 = load i64, ptr %slot.i, align 8, !dbg !211
  %r40 = add i64 2, 0, !dbg !211
  %r41 = add i64 %r39, %r40, !dbg !211
  store i64 %r41, ptr %slot.j, align 8, !dbg !211
  %r42.p = getelementptr inbounds [1 x i8], ptr @.str.0, i64 0, i64 0, !dbg !212
  %r42 = ptrtoint ptr %r42.p to i64, !dbg !212
  store i64 %r42, ptr %slot.key, align 8, !dbg !212
  %r43 = add i64 0, 0, !dbg !213
  store i64 %r43, ptr %slot.closed, align 8, !dbg !213
  br label %while_hdr15, !dbg !214
while_hdr15:
  %r44 = load i64, ptr %slot.j, align 8, !dbg !214
  %r45 = add i64 1, 0, !dbg !214
  %r46 = add i64 %r44, %r45, !dbg !214
  %r47 = load i64, ptr %slot.n, align 8, !dbg !214
  %r48.cmp = icmp slt i64 %r46, %r47, !dbg !214
  %r48 = zext i1 %r48.cmp to i64, !dbg !214
  store i64 %r48, ptr %slot.__sc_18, align 8, !dbg !214
  %br_and_rhs195 = icmp ne i64 %r48, 0, !dbg !214
  br i1 %br_and_rhs195, label %and_rhs19, label %and_merge20, !dbg !214
and_rhs19:
  %r49 = load i64, ptr %slot.closed, align 8, !dbg !214
  %r50.cmp = icmp eq i64 %r49, 0, !dbg !214
  %r50 = zext i1 %r50.cmp to i64, !dbg !214
  store i64 %r50, ptr %slot.__sc_18, align 8, !dbg !214
  br label %and_merge20, !dbg !214
and_merge20:
  %r51 = load i64, ptr %slot.__sc_18, align 8, !dbg !214
  %br_while_body166 = icmp ne i64 %r51, 0, !dbg !214
  br i1 %br_while_body166, label %while_body16, label %while_exit17, !prof !90, !dbg !214
while_body16:
  %r52 = load i64, ptr %slot.template, align 8, !dbg !215
  %r53 = load i64, ptr %slot.j, align 8, !dbg !215
  %r54 = call i64 @nova_rt_char_at(i64 %r52, i64 %r53), !dbg !215
  %r55 = call i64 @nova_rt_ord(i64 %r54), !dbg !215
  %r56 = add i64 125, 0, !dbg !215
  %r57.cmp = icmp eq i64 %r55, %r56, !dbg !215
  %r57 = zext i1 %r57.cmp to i64, !dbg !215
  store i64 %r57, ptr %slot.__sc_21, align 8, !dbg !215
  %br_and_rhs227 = icmp ne i64 %r57, 0, !dbg !215
  br i1 %br_and_rhs227, label %and_rhs22, label %and_merge23, !dbg !215
and_rhs22:
  %r58 = load i64, ptr %slot.template, align 8, !dbg !215
  %r59 = load i64, ptr %slot.j, align 8, !dbg !215
  %r60 = add i64 1, 0, !dbg !215
  %r61 = add i64 %r59, %r60, !dbg !215
  %r62 = call i64 @nova_rt_char_at(i64 %r58, i64 %r61), !dbg !215
  %r63 = call i64 @nova_rt_ord(i64 %r62), !dbg !215
  %r64 = add i64 125, 0, !dbg !215
  %r65.cmp = icmp eq i64 %r63, %r64, !dbg !215
  %r65 = zext i1 %r65.cmp to i64, !dbg !215
  store i64 %r65, ptr %slot.__sc_21, align 8, !dbg !215
  br label %and_merge23, !dbg !215
and_merge23:
  %r66 = load i64, ptr %slot.__sc_21, align 8, !dbg !215
  %br_then248 = icmp ne i64 %r66, 0, !dbg !215
  br i1 %br_then248, label %then24, label %else25, !dbg !215
then24:
  %r67 = add i64 1, 0, !dbg !216
  store i64 %r67, ptr %slot.closed, align 8, !dbg !216
  br label %endif26, !dbg !216
else25:
  %r68 = load i64, ptr %slot.key, align 8, !dbg !217
  %r69 = load i64, ptr %slot.template, align 8, !dbg !217
  %r70 = load i64, ptr %slot.j, align 8, !dbg !217
  %r71 = call i64 @nova_rt_char_at(i64 %r69, i64 %r70), !dbg !217
  %r72 = call i64 @nova_rt_str_concat(i64 %r68, i64 %r71), !dbg !217
  store i64 %r72, ptr %slot.key, align 8, !dbg !217
  %r73 = load i64, ptr %slot.j, align 8, !dbg !218
  %r74 = add i64 1, 0, !dbg !218
  %r75 = add i64 %r73, %r74, !dbg !218
  store i64 %r75, ptr %slot.j, align 8, !dbg !218
  br label %endif26, !dbg !218
endif26:
  br label %while_hdr15, !dbg !218
while_exit17:
  %r76 = load i64, ptr %slot.closed, align 8, !dbg !219
  %br_then279 = icmp ne i64 %r76, 0, !dbg !219
  br i1 %br_then279, label %then27, label %else28, !dbg !219
then27:
  %r77 = load i64, ptr %slot.toks, align 8, !dbg !220
  %r79.p = getelementptr inbounds [2 x i8], ptr @.str.2, i64 0, i64 0, !dbg !220
  %r79 = ptrtoint ptr %r79.p to i64, !dbg !220
  %r80 = load i64, ptr %slot.key, align 8, !dbg !220
  %r81 = call i64 @nova_rt_trim(i64 %r80), !dbg !220
  %r78 = call i64 @nova_rt_list_create(), !dbg !220
  call i64 @nova_rt_list_append(i64 %r78, i64 %r79), !dbg !220
  call i64 @nova_rt_list_append(i64 %r78, i64 %r81), !dbg !220
  %r82 = call i64 @nova_rt_list_append(i64 %r77, i64 %r78), !dbg !220
  %r83 = load i64, ptr %slot.j, align 8, !dbg !221
  %r84 = add i64 2, 0, !dbg !221
  %r85 = add i64 %r83, %r84, !dbg !221
  store i64 %r85, ptr %slot.i, align 8, !dbg !221
  br label %endif29, !dbg !221
else28:
  br label %while_hdr30, !dbg !222
while_hdr30:
  %r86 = load i64, ptr %slot.j, align 8, !dbg !222
  %r87 = load i64, ptr %slot.n, align 8, !dbg !222
  %r88.cmp = icmp slt i64 %r86, %r87, !dbg !222
  %r88 = zext i1 %r88.cmp to i64, !dbg !222
  %br_while_body3110 = icmp ne i64 %r88, 0, !dbg !222
  br i1 %br_while_body3110, label %while_body31, label %while_exit32, !prof !90, !dbg !222
while_body31:
  %r89 = load i64, ptr %slot.key, align 8, !dbg !223
  %r90 = load i64, ptr %slot.template, align 8, !dbg !223
  %r91 = load i64, ptr %slot.j, align 8, !dbg !223
  %r92 = call i64 @nova_rt_char_at(i64 %r90, i64 %r91), !dbg !223
  %r93 = call i64 @nova_rt_str_concat(i64 %r89, i64 %r92), !dbg !223
  store i64 %r93, ptr %slot.key, align 8, !dbg !223
  %r94 = load i64, ptr %slot.j, align 8, !dbg !224
  %r95 = add i64 1, 0, !dbg !224
  %r96 = add i64 %r94, %r95, !dbg !224
  store i64 %r96, ptr %slot.j, align 8, !dbg !224
  br label %while_hdr30, !dbg !224
while_exit32:
  %r97 = load i64, ptr %slot.lit, align 8, !dbg !225
  %r98 = load i64, ptr %slot.template, align 8, !dbg !225
  %r99 = load i64, ptr %slot.i, align 8, !dbg !225
  %r100 = call i64 @nova_rt_char_at(i64 %r98, i64 %r99), !dbg !225
  %r101 = call i64 @nova_rt_str_concat(i64 %r97, i64 %r100), !dbg !225
  %r102 = load i64, ptr %slot.template, align 8, !dbg !225
  %r103 = load i64, ptr %slot.i, align 8, !dbg !225
  %r104 = add i64 1, 0, !dbg !225
  %r105 = add i64 %r103, %r104, !dbg !225
  %r106 = call i64 @nova_rt_char_at(i64 %r102, i64 %r105), !dbg !225
  %r107 = call i64 @nova_rt_str_concat(i64 %r101, i64 %r106), !dbg !225
  %r108 = load i64, ptr %slot.key, align 8, !dbg !225
  %r109 = call i64 @nova_rt_str_concat(i64 %r107, i64 %r108), !dbg !225
  store i64 %r109, ptr %slot.lit, align 8, !dbg !225
  %r110 = load i64, ptr %slot.n, align 8, !dbg !226
  store i64 %r110, ptr %slot.i, align 8, !dbg !226
  br label %endif29, !dbg !226
endif29:
  br label %endif11, !dbg !226
else10:
  %r111 = load i64, ptr %slot.lit, align 8, !dbg !227
  %r112 = load i64, ptr %slot.template, align 8, !dbg !227
  %r113 = load i64, ptr %slot.i, align 8, !dbg !227
  %r114 = call i64 @nova_rt_char_at(i64 %r112, i64 %r113), !dbg !227
  %r115 = call i64 @nova_rt_str_concat(i64 %r111, i64 %r114), !dbg !227
  store i64 %r115, ptr %slot.lit, align 8, !dbg !227
  %r116 = load i64, ptr %slot.i, align 8, !dbg !228
  %r117 = add i64 1, 0, !dbg !228
  %r118 = add i64 %r116, %r117, !dbg !228
  store i64 %r118, ptr %slot.i, align 8, !dbg !228
  br label %endif11, !dbg !228
endif11:
  br label %while_hdr0, !dbg !228
while_exit2:
  %r119 = load i64, ptr %slot.lit, align 8, !dbg !229
  %r120 = call i64 @nova_rt_len_any(i64 %r119), !dbg !229
  %r121 = add i64 0, 0, !dbg !229
  %r122.cmp = icmp sgt i64 %r120, %r121, !dbg !229
  %r122 = zext i1 %r122.cmp to i64, !dbg !229
  %br_then3311 = icmp ne i64 %r122, 0, !dbg !229
  br i1 %br_then3311, label %then33, label %else34, !dbg !229
then33:
  %r123 = load i64, ptr %slot.toks, align 8, !dbg !230
  %r125.p = getelementptr inbounds [2 x i8], ptr @.str.1, i64 0, i64 0, !dbg !230
  %r125 = ptrtoint ptr %r125.p to i64, !dbg !230
  %r126 = load i64, ptr %slot.lit, align 8, !dbg !230
  %r124 = call i64 @nova_rt_list_create(), !dbg !230
  call i64 @nova_rt_list_append(i64 %r124, i64 %r125), !dbg !230
  call i64 @nova_rt_list_append(i64 %r124, i64 %r126), !dbg !230
  %r127 = call i64 @nova_rt_list_append(i64 %r123, i64 %r124), !dbg !230
  br label %endif35, !dbg !230
else34:
  br label %endif35, !dbg !230
endif35:
  %r128 = load i64, ptr %slot.toks, align 8, !dbg !231
  ret i64 %r128, !dbg !231
}

; ESCAPE tpl_render: allocs=0 escape=0 local=0
define i64 @tpl_render(i64 %p0, i64 %p1) nounwind uwtable !dbg !232 {
entry:
  %slot.template_str = alloca i64, align 8, !dbg !233
  store i64 %p0, ptr %slot.template_str, align 8, !dbg !233
  %slot.vars_dict = alloca i64, align 8, !dbg !233
  store i64 %p1, ptr %slot.vars_dict, align 8, !dbg !233
  %slot.toks = alloca i64, align 8, !dbg !233
  store i64 0, ptr %slot.toks, align 8, !dbg !233
  %slot.n = alloca i64, align 8, !dbg !233
  store i64 0, ptr %slot.n, align 8, !dbg !233
  %slot.out = alloca i64, align 8, !dbg !233
  store i64 0, ptr %slot.out, align 8, !dbg !233
  %slot.i = alloca i64, align 8, !dbg !233
  store i64 0, ptr %slot.i, align 8, !dbg !233
  %slot.toks__s4f91 = alloca i64, align 8, !dbg !233
  store i64 0, ptr %slot.toks__s4f91, align 8, !dbg !233
  %slot.tok__s4f91 = alloca i64, align 8, !dbg !233
  store i64 0, ptr %slot.tok__s4f91, align 8, !dbg !233
  %slot.tok = alloca i64, align 8, !dbg !233
  store i64 0, ptr %slot.tok, align 8, !dbg !233
  %r0 = load i64, ptr %slot.template_str, align 8, !dbg !234
  %r1 = call i64 @_ts_parse(i64 %r0), !dbg !234
  store i64 %r1, ptr %slot.toks, align 8, !dbg !234
  %r2 = add i64 %r1, 0, !dbg !235
  %r3.lp = inttoptr i64 %r2 to ptr, !dbg !235
  %r3.szp = getelementptr i64, ptr %r3.lp, i64 1, !dbg !235
  %r3 = load i64, ptr %r3.szp, align 8, !tbaa !6, !dbg !235
  store i64 %r3, ptr %slot.n, align 8, !dbg !235
  %r4.p = getelementptr inbounds [1 x i8], ptr @.str.0, i64 0, i64 0, !dbg !236
  %r4 = ptrtoint ptr %r4.p to i64, !dbg !236
  store i64 %r4, ptr %slot.out, align 8, !dbg !236
  %r5 = add i64 0, 0, !dbg !237
  store i64 %r5, ptr %slot.i, align 8, !dbg !237
  %r6 = add i64 %r1, 0, !dbg !238
  %r7 = call i64 @nova_rt_list_is_kind2(i64 %r6), !dbg !238
  %br_then360 = icmp ne i64 %r7, 0, !dbg !238
  br i1 %br_then360, label %then36, label %else37, !dbg !238
then36:
  %r8 = load i64, ptr %slot.toks, align 8, !dbg !238
  %r9 = call i64 @nova_rt_floatlist_view(i64 %r8), !dbg !238
  store i64 %r9, ptr %slot.toks__s4f91, align 8, !dbg !238
  br label %while_hdr39, !dbg !238
while_hdr39:
  %r10 = load i64, ptr %slot.i, align 8, !dbg !238
  %r11 = load i64, ptr %slot.n, align 8, !dbg !238
  %r12.cmp = icmp slt i64 %r10, %r11, !dbg !238
  %r12 = zext i1 %r12.cmp to i64, !dbg !238
  %br_while_body401 = icmp ne i64 %r12, 0, !dbg !238
  br i1 %br_while_body401, label %while_body40, label %while_exit41, !prof !90, !dbg !238
while_body40:
  %r13 = load i64, ptr %slot.toks__s4f91, align 8, !dbg !239
  %r14 = load i64, ptr %slot.i, align 8, !dbg !239
  %r15 = call i64 @nova_rt_list_get_f(i64 %r13, i64 %r14), !dbg !239
  store i64 %r15, ptr %slot.tok__s4f91, align 8, !dbg !239
  %r16 = add i64 %r15, 0, !dbg !240
  %r17 = add i64 0, 0, !dbg !240
  %r18 = call i64 @nova_rt_index_get(i64 %r16, i64 %r17), !dbg !240
  %r19.p = getelementptr inbounds [2 x i8], ptr @.str.1, i64 0, i64 0, !dbg !240
  %r19 = ptrtoint ptr %r19.p to i64, !dbg !240
  %r20 = call i64 @nova_rt_eq(i64 %r18, i64 %r19), !dbg !240
  %br_then422 = icmp ne i64 %r20, 0, !dbg !240
  br i1 %br_then422, label %then42, label %else43, !dbg !240
then42:
  %r21 = load i64, ptr %slot.out, align 8, !dbg !241
  %r22 = load i64, ptr %slot.tok__s4f91, align 8, !dbg !241
  %r23 = add i64 1, 0, !dbg !241
  %r24 = call i64 @nova_rt_index_get(i64 %r22, i64 %r23), !dbg !241
  %r25 = call i64 @nova_rt_str_concat(i64 %r21, i64 %r24), !dbg !241
  store i64 %r25, ptr %slot.out, align 8, !dbg !241
  br label %endif44, !dbg !241
else43:
  %r26 = load i64, ptr %slot.vars_dict, align 8, !dbg !242
  %r27 = load i64, ptr %slot.tok__s4f91, align 8, !dbg !242
  %r28 = add i64 1, 0, !dbg !242
  %r29 = call i64 @nova_rt_index_get(i64 %r27, i64 %r28), !dbg !242
  %r30 = call i64 @nova_rt_contains(i64 %r26, i64 %r29), !dbg !242
  %br_then453 = icmp ne i64 %r30, 0, !dbg !242
  br i1 %br_then453, label %then45, label %else46, !dbg !242
then45:
  %r31 = load i64, ptr %slot.out, align 8, !dbg !243
  %r32 = load i64, ptr %slot.vars_dict, align 8, !dbg !243
  %r33 = load i64, ptr %slot.tok__s4f91, align 8, !dbg !243
  %r34 = add i64 1, 0, !dbg !243
  %r35 = call i64 @nova_rt_index_get(i64 %r33, i64 %r34), !dbg !243
  %r36 = call i64 @nova_rt_index_get(i64 %r32, i64 %r35), !dbg !243
  %r37 = call i64 @nova_rt_any_to_str(i64 %r36), !dbg !243
  %r38 = call i64 @nova_rt_str_concat(i64 %r31, i64 %r37), !dbg !243
  store i64 %r38, ptr %slot.out, align 8, !dbg !243
  br label %endif47, !dbg !243
else46:
  br label %endif47, !dbg !243
endif47:
  br label %endif44, !dbg !243
endif44:
  %r39 = load i64, ptr %slot.i, align 8, !dbg !244
  %r40 = add i64 1, 0, !dbg !244
  %r41 = add i64 %r39, %r40, !dbg !244
  store i64 %r41, ptr %slot.i, align 8, !dbg !244
  br label %while_hdr39, !dbg !244
while_exit41:
  br label %endif38, !dbg !244
else37:
  br label %while_hdr48, !dbg !238
while_hdr48:
  %r42 = load i64, ptr %slot.i, align 8, !dbg !238
  %r43 = load i64, ptr %slot.n, align 8, !dbg !238
  %r44.cmp = icmp slt i64 %r42, %r43, !dbg !238
  %r44 = zext i1 %r44.cmp to i64, !dbg !238
  %br_while_body494 = icmp ne i64 %r44, 0, !dbg !238
  br i1 %br_while_body494, label %while_body49, label %while_exit50, !prof !90, !dbg !238
while_body49:
  %r45 = load i64, ptr %slot.toks, align 8, !dbg !239
  %r46 = load i64, ptr %slot.i, align 8, !dbg !239
  %r47 = call i64 @nova_rt_index_get(i64 %r45, i64 %r46), !dbg !239
  store i64 %r47, ptr %slot.tok, align 8, !dbg !239
  %r48 = add i64 %r47, 0, !dbg !240
  %r49 = add i64 0, 0, !dbg !240
  %r50 = call i64 @nova_rt_index_get(i64 %r48, i64 %r49), !dbg !240
  %r51.p = getelementptr inbounds [2 x i8], ptr @.str.1, i64 0, i64 0, !dbg !240
  %r51 = ptrtoint ptr %r51.p to i64, !dbg !240
  %r52 = call i64 @nova_rt_eq(i64 %r50, i64 %r51), !dbg !240
  %br_then515 = icmp ne i64 %r52, 0, !dbg !240
  br i1 %br_then515, label %then51, label %else52, !dbg !240
then51:
  %r53 = load i64, ptr %slot.out, align 8, !dbg !241
  %r54 = load i64, ptr %slot.tok, align 8, !dbg !241
  %r55 = add i64 1, 0, !dbg !241
  %r56 = call i64 @nova_rt_index_get(i64 %r54, i64 %r55), !dbg !241
  %r57 = call i64 @nova_rt_str_concat(i64 %r53, i64 %r56), !dbg !241
  store i64 %r57, ptr %slot.out, align 8, !dbg !241
  br label %endif53, !dbg !241
else52:
  %r58 = load i64, ptr %slot.vars_dict, align 8, !dbg !242
  %r59 = load i64, ptr %slot.tok, align 8, !dbg !242
  %r60 = add i64 1, 0, !dbg !242
  %r61 = call i64 @nova_rt_index_get(i64 %r59, i64 %r60), !dbg !242
  %r62 = call i64 @nova_rt_contains(i64 %r58, i64 %r61), !dbg !242
  %br_then546 = icmp ne i64 %r62, 0, !dbg !242
  br i1 %br_then546, label %then54, label %else55, !dbg !242
then54:
  %r63 = load i64, ptr %slot.out, align 8, !dbg !243
  %r64 = load i64, ptr %slot.vars_dict, align 8, !dbg !243
  %r65 = load i64, ptr %slot.tok, align 8, !dbg !243
  %r66 = add i64 1, 0, !dbg !243
  %r67 = call i64 @nova_rt_index_get(i64 %r65, i64 %r66), !dbg !243
  %r68 = call i64 @nova_rt_index_get(i64 %r64, i64 %r67), !dbg !243
  %r69 = call i64 @nova_rt_any_to_str(i64 %r68), !dbg !243
  %r70 = call i64 @nova_rt_str_concat(i64 %r63, i64 %r69), !dbg !243
  store i64 %r70, ptr %slot.out, align 8, !dbg !243
  br label %endif56, !dbg !243
else55:
  br label %endif56, !dbg !243
endif56:
  br label %endif53, !dbg !243
endif53:
  %r71 = load i64, ptr %slot.i, align 8, !dbg !244
  %r72 = add i64 1, 0, !dbg !244
  %r73 = add i64 %r71, %r72, !dbg !244
  store i64 %r73, ptr %slot.i, align 8, !dbg !244
  br label %while_hdr48, !dbg !244
while_exit50:
  br label %endif38, !dbg !244
endif38:
  %r74 = load i64, ptr %slot.out, align 8, !dbg !245
  ret i64 %r74, !dbg !245
}

; ESCAPE tpl_has_vars: allocs=0 escape=0 local=0
define i64 @tpl_has_vars(i64 %p0) nounwind uwtable !dbg !246 {
entry:
  %slot.template_str = alloca i64, align 8, !dbg !247
  store i64 %p0, ptr %slot.template_str, align 8, !dbg !247
  %slot.toks = alloca i64, align 8, !dbg !247
  store i64 0, ptr %slot.toks, align 8, !dbg !247
  %slot.n = alloca i64, align 8, !dbg !247
  store i64 0, ptr %slot.n, align 8, !dbg !247
  %slot.i = alloca i64, align 8, !dbg !247
  store i64 0, ptr %slot.i, align 8, !dbg !247
  %slot.toks__s4f107 = alloca i64, align 8, !dbg !247
  store i64 0, ptr %slot.toks__s4f107, align 8, !dbg !247
  %r0 = load i64, ptr %slot.template_str, align 8, !dbg !248
  %r1 = call i64 @_ts_parse(i64 %r0), !dbg !248
  store i64 %r1, ptr %slot.toks, align 8, !dbg !248
  %r2 = add i64 %r1, 0, !dbg !249
  %r3.lp = inttoptr i64 %r2 to ptr, !dbg !249
  %r3.szp = getelementptr i64, ptr %r3.lp, i64 1, !dbg !249
  %r3 = load i64, ptr %r3.szp, align 8, !tbaa !6, !dbg !249
  store i64 %r3, ptr %slot.n, align 8, !dbg !249
  %r4 = add i64 0, 0, !dbg !250
  store i64 %r4, ptr %slot.i, align 8, !dbg !250
  %r5 = add i64 %r1, 0, !dbg !251
  %r6 = call i64 @nova_rt_list_is_kind2(i64 %r5), !dbg !251
  %br_then570 = icmp ne i64 %r6, 0, !dbg !251
  br i1 %br_then570, label %then57, label %else58, !dbg !251
then57:
  %r7 = load i64, ptr %slot.toks, align 8, !dbg !251
  %r8 = call i64 @nova_rt_floatlist_view(i64 %r7), !dbg !251
  store i64 %r8, ptr %slot.toks__s4f107, align 8, !dbg !251
  br label %while_hdr60, !dbg !251
while_hdr60:
  %r9 = load i64, ptr %slot.i, align 8, !dbg !251
  %r10 = load i64, ptr %slot.n, align 8, !dbg !251
  %r11.cmp = icmp slt i64 %r9, %r10, !dbg !251
  %r11 = zext i1 %r11.cmp to i64, !dbg !251
  %br_while_body611 = icmp ne i64 %r11, 0, !dbg !251
  br i1 %br_while_body611, label %while_body61, label %while_exit62, !prof !90, !dbg !251
while_body61:
  %r12 = load i64, ptr %slot.toks__s4f107, align 8, !dbg !252
  %r13 = load i64, ptr %slot.i, align 8, !dbg !252
  %r14 = call i64 @nova_rt_list_get_f(i64 %r12, i64 %r13), !dbg !252
  %r15 = add i64 0, 0, !dbg !252
  %r16 = call i64 @nova_rt_index_get(i64 %r14, i64 %r15), !dbg !252
  %r17.p = getelementptr inbounds [2 x i8], ptr @.str.2, i64 0, i64 0, !dbg !252
  %r17 = ptrtoint ptr %r17.p to i64, !dbg !252
  %r18 = call i64 @nova_rt_eq(i64 %r16, i64 %r17), !dbg !252
  %br_then632 = icmp ne i64 %r18, 0, !dbg !252
  br i1 %br_then632, label %then63, label %else64, !dbg !252
then63:
  %r19 = add i64 1, 0, !dbg !253
  ret i64 %r19, !dbg !253
else64:
  br label %endif65, !dbg !253
endif65:
  %r20 = load i64, ptr %slot.i, align 8, !dbg !254
  %r21 = add i64 1, 0, !dbg !254
  %r22 = add i64 %r20, %r21, !dbg !254
  store i64 %r22, ptr %slot.i, align 8, !dbg !254
  br label %while_hdr60, !dbg !254
while_exit62:
  br label %endif59, !dbg !254
else58:
  br label %while_hdr66, !dbg !251
while_hdr66:
  %r23 = load i64, ptr %slot.i, align 8, !dbg !251
  %r24 = load i64, ptr %slot.n, align 8, !dbg !251
  %r25.cmp = icmp slt i64 %r23, %r24, !dbg !251
  %r25 = zext i1 %r25.cmp to i64, !dbg !251
  %br_while_body673 = icmp ne i64 %r25, 0, !dbg !251
  br i1 %br_while_body673, label %while_body67, label %while_exit68, !prof !90, !dbg !251
while_body67:
  %r26 = load i64, ptr %slot.toks, align 8, !dbg !252
  %r27 = load i64, ptr %slot.i, align 8, !dbg !252
  %r28 = call i64 @nova_rt_index_get(i64 %r26, i64 %r27), !dbg !252
  %r29 = add i64 0, 0, !dbg !252
  %r30 = call i64 @nova_rt_index_get(i64 %r28, i64 %r29), !dbg !252
  %r31.p = getelementptr inbounds [2 x i8], ptr @.str.2, i64 0, i64 0, !dbg !252
  %r31 = ptrtoint ptr %r31.p to i64, !dbg !252
  %r32 = call i64 @nova_rt_eq(i64 %r30, i64 %r31), !dbg !252
  %br_then694 = icmp ne i64 %r32, 0, !dbg !252
  br i1 %br_then694, label %then69, label %else70, !dbg !252
then69:
  %r33 = add i64 1, 0, !dbg !253
  ret i64 %r33, !dbg !253
else70:
  br label %endif71, !dbg !253
endif71:
  %r34 = load i64, ptr %slot.i, align 8, !dbg !254
  %r35 = add i64 1, 0, !dbg !254
  %r36 = add i64 %r34, %r35, !dbg !254
  store i64 %r36, ptr %slot.i, align 8, !dbg !254
  br label %while_hdr66, !dbg !254
while_exit68:
  br label %endif59, !dbg !254
endif59:
  %r37 = add i64 0, 0, !dbg !255
  ret i64 %r37, !dbg !255
}

; ESCAPE tpl_extract_vars: allocs=2 escape=1 local=1
define i64 @tpl_extract_vars(i64 %p0) nounwind uwtable !dbg !256 {
entry:
  %slot.template_str = alloca i64, align 8, !dbg !257
  store i64 %p0, ptr %slot.template_str, align 8, !dbg !257
  %slot.toks = alloca i64, align 8, !dbg !257
  store i64 0, ptr %slot.toks, align 8, !dbg !257
  %slot.n = alloca i64, align 8, !dbg !257
  store i64 0, ptr %slot.n, align 8, !dbg !257
  %slot.seen = alloca i64, align 8, !dbg !257
  store i64 0, ptr %slot.seen, align 8, !dbg !257
  %slot.out = alloca i64, align 8, !dbg !257
  store i64 0, ptr %slot.out, align 8, !dbg !257
  %slot.i = alloca i64, align 8, !dbg !257
  store i64 0, ptr %slot.i, align 8, !dbg !257
  %slot.toks__s4f121 = alloca i64, align 8, !dbg !257
  store i64 0, ptr %slot.toks__s4f121, align 8, !dbg !257
  %slot.tok__s4f121 = alloca i64, align 8, !dbg !257
  store i64 0, ptr %slot.tok__s4f121, align 8, !dbg !257
  %slot.k__s4f121 = alloca i64, align 8, !dbg !257
  store i64 0, ptr %slot.k__s4f121, align 8, !dbg !257
  %slot.tok = alloca i64, align 8, !dbg !257
  store i64 0, ptr %slot.tok, align 8, !dbg !257
  %slot.k = alloca i64, align 8, !dbg !257
  store i64 0, ptr %slot.k, align 8, !dbg !257
  %r0 = load i64, ptr %slot.template_str, align 8, !dbg !258
  %r1 = call i64 @_ts_parse(i64 %r0), !dbg !258
  store i64 %r1, ptr %slot.toks, align 8, !dbg !258
  %r2 = add i64 %r1, 0, !dbg !259
  %r3.lp = inttoptr i64 %r2 to ptr, !dbg !259
  %r3.szp = getelementptr i64, ptr %r3.lp, i64 1, !dbg !259
  %r3 = load i64, ptr %r3.szp, align 8, !tbaa !6, !dbg !259
  store i64 %r3, ptr %slot.n, align 8, !dbg !259
  %r4 = call i64 @nova_rt_dict_create(), !dbg !260
  store i64 %r4, ptr %slot.seen, align 8, !dbg !260
  %r5 = call i64 @nova_rt_list_create(), !dbg !261
  store i64 %r5, ptr %slot.out, align 8, !dbg !261
  %r6 = add i64 0, 0, !dbg !262
  store i64 %r6, ptr %slot.i, align 8, !dbg !262
  %r7 = add i64 %r1, 0, !dbg !263
  %r8 = call i64 @nova_rt_list_is_kind2(i64 %r7), !dbg !263
  %br_then720 = icmp ne i64 %r8, 0, !dbg !263
  br i1 %br_then720, label %then72, label %else73, !dbg !263
then72:
  %r9 = load i64, ptr %slot.toks, align 8, !dbg !263
  %r10 = call i64 @nova_rt_floatlist_view(i64 %r9), !dbg !263
  store i64 %r10, ptr %slot.toks__s4f121, align 8, !dbg !263
  br label %while_hdr75, !dbg !263
while_hdr75:
  %r11 = load i64, ptr %slot.i, align 8, !dbg !263
  %r12 = load i64, ptr %slot.n, align 8, !dbg !263
  %r13.cmp = icmp slt i64 %r11, %r12, !dbg !263
  %r13 = zext i1 %r13.cmp to i64, !dbg !263
  %br_while_body761 = icmp ne i64 %r13, 0, !dbg !263
  br i1 %br_while_body761, label %while_body76, label %while_exit77, !prof !90, !dbg !263
while_body76:
  %r14 = load i64, ptr %slot.toks__s4f121, align 8, !dbg !264
  %r15 = load i64, ptr %slot.i, align 8, !dbg !264
  %r16 = call i64 @nova_rt_list_get_f(i64 %r14, i64 %r15), !dbg !264
  store i64 %r16, ptr %slot.tok__s4f121, align 8, !dbg !264
  %r17 = add i64 %r16, 0, !dbg !265
  %r18 = add i64 0, 0, !dbg !265
  %r19 = call i64 @nova_rt_index_get(i64 %r17, i64 %r18), !dbg !265
  %r20.p = getelementptr inbounds [2 x i8], ptr @.str.2, i64 0, i64 0, !dbg !265
  %r20 = ptrtoint ptr %r20.p to i64, !dbg !265
  %r21 = call i64 @nova_rt_eq(i64 %r19, i64 %r20), !dbg !265
  %br_then782 = icmp ne i64 %r21, 0, !dbg !265
  br i1 %br_then782, label %then78, label %else79, !dbg !265
then78:
  %r22 = load i64, ptr %slot.tok__s4f121, align 8, !dbg !266
  %r23 = add i64 1, 0, !dbg !266
  %r24 = call i64 @nova_rt_index_get(i64 %r22, i64 %r23), !dbg !266
  store i64 %r24, ptr %slot.k__s4f121, align 8, !dbg !266
  %r25 = load i64, ptr %slot.seen, align 8, !dbg !267
  %r26 = add i64 %r24, 0, !dbg !267
  %r27 = call i64 @nova_rt_contains(i64 %r25, i64 %r26), !dbg !267
  %r28 = add i64 0, 0, !dbg !267
  %r29 = call i64 @nova_rt_eq(i64 %r27, i64 %r28), !dbg !267
  %br_then813 = icmp ne i64 %r29, 0, !dbg !267
  br i1 %br_then813, label %then81, label %else82, !dbg !267
then81:
  %r30 = add i64 1, 0, !dbg !268
  %r31 = load i64, ptr %slot.seen, align 8, !dbg !268
  %r32 = load i64, ptr %slot.k__s4f121, align 8, !dbg !268
  %_is.dv4 = call i64 @nova_rt_dict_set_no_rc(i64 %r31, i64 %r32, i64 %r30), !dbg !268
  %r33 = load i64, ptr %slot.out, align 8, !dbg !269
  %r34 = load i64, ptr %slot.k__s4f121, align 8, !dbg !269
  %r35 = call i64 @nova_rt_list_append(i64 %r33, i64 %r34), !dbg !269
  br label %endif83, !dbg !269
else82:
  br label %endif83, !dbg !269
endif83:
  br label %endif80, !dbg !269
else79:
  br label %endif80, !dbg !269
endif80:
  %r36 = load i64, ptr %slot.i, align 8, !dbg !270
  %r37 = add i64 1, 0, !dbg !270
  %r38 = add i64 %r36, %r37, !dbg !270
  store i64 %r38, ptr %slot.i, align 8, !dbg !270
  br label %while_hdr75, !dbg !270
while_exit77:
  br label %endif74, !dbg !270
else73:
  br label %while_hdr84, !dbg !263
while_hdr84:
  %r39 = load i64, ptr %slot.i, align 8, !dbg !263
  %r40 = load i64, ptr %slot.n, align 8, !dbg !263
  %r41.cmp = icmp slt i64 %r39, %r40, !dbg !263
  %r41 = zext i1 %r41.cmp to i64, !dbg !263
  %br_while_body855 = icmp ne i64 %r41, 0, !dbg !263
  br i1 %br_while_body855, label %while_body85, label %while_exit86, !prof !90, !dbg !263
while_body85:
  %r42 = load i64, ptr %slot.toks, align 8, !dbg !264
  %r43 = load i64, ptr %slot.i, align 8, !dbg !264
  %r44 = call i64 @nova_rt_index_get(i64 %r42, i64 %r43), !dbg !264
  store i64 %r44, ptr %slot.tok, align 8, !dbg !264
  %r45 = add i64 %r44, 0, !dbg !265
  %r46 = add i64 0, 0, !dbg !265
  %r47 = call i64 @nova_rt_index_get(i64 %r45, i64 %r46), !dbg !265
  %r48.p = getelementptr inbounds [2 x i8], ptr @.str.2, i64 0, i64 0, !dbg !265
  %r48 = ptrtoint ptr %r48.p to i64, !dbg !265
  %r49 = call i64 @nova_rt_eq(i64 %r47, i64 %r48), !dbg !265
  %br_then876 = icmp ne i64 %r49, 0, !dbg !265
  br i1 %br_then876, label %then87, label %else88, !dbg !265
then87:
  %r50 = load i64, ptr %slot.tok, align 8, !dbg !266
  %r51 = add i64 1, 0, !dbg !266
  %r52 = call i64 @nova_rt_index_get(i64 %r50, i64 %r51), !dbg !266
  store i64 %r52, ptr %slot.k, align 8, !dbg !266
  %r53 = load i64, ptr %slot.seen, align 8, !dbg !267
  %r54 = add i64 %r52, 0, !dbg !267
  %r55 = call i64 @nova_rt_contains(i64 %r53, i64 %r54), !dbg !267
  %r56 = add i64 0, 0, !dbg !267
  %r57 = call i64 @nova_rt_eq(i64 %r55, i64 %r56), !dbg !267
  %br_then907 = icmp ne i64 %r57, 0, !dbg !267
  br i1 %br_then907, label %then90, label %else91, !dbg !267
then90:
  %r58 = add i64 1, 0, !dbg !268
  %r59 = load i64, ptr %slot.seen, align 8, !dbg !268
  %r60 = load i64, ptr %slot.k, align 8, !dbg !268
  %_is.dv8 = call i64 @nova_rt_dict_set_no_rc(i64 %r59, i64 %r60, i64 %r58), !dbg !268
  %r61 = load i64, ptr %slot.out, align 8, !dbg !269
  %r62 = load i64, ptr %slot.k, align 8, !dbg !269
  %r63 = call i64 @nova_rt_list_append(i64 %r61, i64 %r62), !dbg !269
  br label %endif92, !dbg !269
else91:
  br label %endif92, !dbg !269
endif92:
  br label %endif89, !dbg !269
else88:
  br label %endif89, !dbg !269
endif89:
  %r64 = load i64, ptr %slot.i, align 8, !dbg !270
  %r65 = add i64 1, 0, !dbg !270
  %r66 = add i64 %r64, %r65, !dbg !270
  store i64 %r66, ptr %slot.i, align 8, !dbg !270
  br label %while_hdr84, !dbg !270
while_exit86:
  br label %endif74, !dbg !270
endif74:
  %r67 = load i64, ptr %slot.out, align 8, !dbg !271
  ret i64 %r67, !dbg !271
}

; ESCAPE tpl_render_list: allocs=1 escape=1 local=0
define i64 @tpl_render_list(i64 %p0, i64 %p1) nounwind uwtable !dbg !272 {
entry:
  %slot.template_str = alloca i64, align 8, !dbg !273
  store i64 %p0, ptr %slot.template_str, align 8, !dbg !273
  %slot.list_of_dicts = alloca i64, align 8, !dbg !273
  store i64 %p1, ptr %slot.list_of_dicts, align 8, !dbg !273
  %slot.n = alloca i64, align 8, !dbg !273
  store i64 0, ptr %slot.n, align 8, !dbg !273
  %slot.out = alloca i64, align 8, !dbg !273
  store i64 0, ptr %slot.out, align 8, !dbg !273
  %slot.i = alloca i64, align 8, !dbg !273
  store i64 0, ptr %slot.i, align 8, !dbg !273
  %slot.list_of_dicts__s4f137 = alloca i64, align 8, !dbg !273
  store i64 0, ptr %slot.list_of_dicts__s4f137, align 8, !dbg !273
  %r0 = load i64, ptr %slot.list_of_dicts, align 8, !dbg !274
  %r1 = call i64 @nova_rt_len_any(i64 %r0), !dbg !274
  store i64 %r1, ptr %slot.n, align 8, !dbg !274
  %r2 = call i64 @nova_rt_list_create(), !dbg !275
  store i64 %r2, ptr %slot.out, align 8, !dbg !275
  %r3 = add i64 0, 0, !dbg !276
  store i64 %r3, ptr %slot.i, align 8, !dbg !276
  %r4 = load i64, ptr %slot.list_of_dicts, align 8, !dbg !277
  %r5 = call i64 @nova_rt_list_is_kind2(i64 %r4), !dbg !277
  %br_then930 = icmp ne i64 %r5, 0, !dbg !277
  br i1 %br_then930, label %then93, label %else94, !dbg !277
then93:
  %r6 = load i64, ptr %slot.list_of_dicts, align 8, !dbg !277
  %r7 = call i64 @nova_rt_floatlist_view(i64 %r6), !dbg !277
  store i64 %r7, ptr %slot.list_of_dicts__s4f137, align 8, !dbg !277
  br label %while_hdr96, !dbg !277
while_hdr96:
  %r8 = load i64, ptr %slot.i, align 8, !dbg !277
  %r9 = load i64, ptr %slot.n, align 8, !dbg !277
  %r10.cmp = icmp slt i64 %r8, %r9, !dbg !277
  %r10 = zext i1 %r10.cmp to i64, !dbg !277
  %br_while_body971 = icmp ne i64 %r10, 0, !dbg !277
  br i1 %br_while_body971, label %while_body97, label %while_exit98, !prof !90, !dbg !277
while_body97:
  %r11 = load i64, ptr %slot.out, align 8, !dbg !278
  %r12 = load i64, ptr %slot.template_str, align 8, !dbg !278
  %r13 = load i64, ptr %slot.list_of_dicts__s4f137, align 8, !dbg !278
  %r14 = load i64, ptr %slot.i, align 8, !dbg !278
  %r15 = call i64 @nova_rt_list_get_f(i64 %r13, i64 %r14), !dbg !278
  %wbox0 = call i64 @nova_rt_box_float(i64 %r15), !dbg !278
  %r16 = call i64 @tpl_render(i64 %r12, i64 %wbox0), !dbg !278
  %r17 = call i64 @nova_rt_list_append(i64 %r11, i64 %r16), !dbg !278
  %r18 = load i64, ptr %slot.i, align 8, !dbg !279
  %r19 = add i64 1, 0, !dbg !279
  %r20 = add i64 %r18, %r19, !dbg !279
  store i64 %r20, ptr %slot.i, align 8, !dbg !279
  br label %while_hdr96, !dbg !279
while_exit98:
  br label %endif95, !dbg !279
else94:
  br label %while_hdr99, !dbg !277
while_hdr99:
  %r21 = load i64, ptr %slot.i, align 8, !dbg !277
  %r22 = load i64, ptr %slot.n, align 8, !dbg !277
  %r23.cmp = icmp slt i64 %r21, %r22, !dbg !277
  %r23 = zext i1 %r23.cmp to i64, !dbg !277
  %br_while_body1002 = icmp ne i64 %r23, 0, !dbg !277
  br i1 %br_while_body1002, label %while_body100, label %while_exit101, !prof !90, !dbg !277
while_body100:
  %r24 = load i64, ptr %slot.out, align 8, !dbg !278
  %r25 = load i64, ptr %slot.template_str, align 8, !dbg !278
  %r26 = load i64, ptr %slot.list_of_dicts, align 8, !dbg !278
  %r27 = load i64, ptr %slot.i, align 8, !dbg !278
  %r28 = call i64 @nova_rt_index_get(i64 %r26, i64 %r27), !dbg !278
  %r29 = call i64 @tpl_render(i64 %r25, i64 %r28), !dbg !278
  %r30 = call i64 @nova_rt_list_append(i64 %r24, i64 %r29), !dbg !278
  %r31 = load i64, ptr %slot.i, align 8, !dbg !279
  %r32 = add i64 1, 0, !dbg !279
  %r33 = add i64 %r31, %r32, !dbg !279
  store i64 %r33, ptr %slot.i, align 8, !dbg !279
  br label %while_hdr99, !dbg !279
while_exit101:
  br label %endif95, !dbg !279
endif95:
  %r34 = load i64, ptr %slot.out, align 8, !dbg !280
  ret i64 %r34, !dbg !280
}

; ESCAPE nova_user_main: allocs=0 escape=0 local=0
define i64 @nova_user_main() nounwind uwtable !dbg !281 {
entry:
  %r0.p = getelementptr inbounds [30 x i8], ptr @.str.3, i64 0, i64 0, !dbg !283
  %r0 = ptrtoint ptr %r0.p to i64, !dbg !283
  %r1 = call i64 @nova_rt_print_str(i64 %r0), !dbg !283
  ret i64 %r1, !dbg !283
}

; ESCAPE nova_main: allocs=0 escape=0 local=0
define i64 @nova_main() nounwind uwtable {
entry:
  %r0 = call i64 @nova_user_main()
  ret i64 0
}

; ESCAPE SUMMARY: allocs=7 escape=3 local=4 (57% local, RC-elidable)
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
@.str.1 = private unnamed_addr constant [2 x i8] c"L\00"
@.str.2 = private unnamed_addr constant [2 x i8] c"K\00"
@.str.3 = private unnamed_addr constant [30 x i8] c"template simple module loaded\00"

; Debug metadata
!llvm.dbg.cu = !{!100}
!llvm.module.flags = !{!102, !103}

!100 = distinct !DICompileUnit(language: DW_LANG_C99, file: !101, producer: "NOVA Compiler", isOptimized: false, emissionKind: LineTablesOnly)
!101 = !DIFile(filename: "std/template/simple.nova", directory: ".")
!102 = !{i32 2, !"CodeView", i32 1}
!103 = !{i32 2, !"Debug Info Version", i32 3}
!104 = !DISubroutineType(types: !105)
!105 = !{null}
!200 = distinct !DISubprogram(name: "_ts_parse", scope: !101, file: !101, line: 46, type: !104, scopeLine: 46, spFlags: DISPFlagDefinition, unit: !100)
!201 = !DILocation(line: 46, column: 0, scope: !200)
!232 = distinct !DISubprogram(name: "tpl_render", scope: !101, file: !101, line: 86, type: !104, scopeLine: 86, spFlags: DISPFlagDefinition, unit: !100)
!233 = !DILocation(line: 86, column: 0, scope: !232)
!246 = distinct !DISubprogram(name: "tpl_has_vars", scope: !101, file: !101, line: 103, type: !104, scopeLine: 103, spFlags: DISPFlagDefinition, unit: !100)
!247 = !DILocation(line: 103, column: 0, scope: !246)
!256 = distinct !DISubprogram(name: "tpl_extract_vars", scope: !101, file: !101, line: 115, type: !104, scopeLine: 115, spFlags: DISPFlagDefinition, unit: !100)
!257 = !DILocation(line: 115, column: 0, scope: !256)
!272 = distinct !DISubprogram(name: "tpl_render_list", scope: !101, file: !101, line: 133, type: !104, scopeLine: 133, spFlags: DISPFlagDefinition, unit: !100)
!273 = !DILocation(line: 133, column: 0, scope: !272)
!281 = distinct !DISubprogram(name: "nova_user_main", scope: !101, file: !101, line: 142, type: !104, scopeLine: 142, spFlags: DISPFlagDefinition, unit: !100)
!282 = !DILocation(line: 142, column: 0, scope: !281)
!202 = !DILocation(line: 47, column: 0, scope: !200)
!203 = !DILocation(line: 48, column: 0, scope: !200)
!204 = !DILocation(line: 49, column: 0, scope: !200)
!205 = !DILocation(line: 50, column: 0, scope: !200)
!206 = !DILocation(line: 51, column: 0, scope: !200)
!207 = !DILocation(line: 52, column: 0, scope: !200)
!208 = !DILocation(line: 54, column: 0, scope: !200)
!209 = !DILocation(line: 55, column: 0, scope: !200)
!210 = !DILocation(line: 56, column: 0, scope: !200)
!211 = !DILocation(line: 57, column: 0, scope: !200)
!212 = !DILocation(line: 58, column: 0, scope: !200)
!213 = !DILocation(line: 59, column: 0, scope: !200)
!214 = !DILocation(line: 60, column: 0, scope: !200)
!215 = !DILocation(line: 61, column: 0, scope: !200)
!216 = !DILocation(line: 62, column: 0, scope: !200)
!217 = !DILocation(line: 64, column: 0, scope: !200)
!218 = !DILocation(line: 65, column: 0, scope: !200)
!219 = !DILocation(line: 66, column: 0, scope: !200)
!220 = !DILocation(line: 67, column: 0, scope: !200)
!221 = !DILocation(line: 68, column: 0, scope: !200)
!222 = !DILocation(line: 72, column: 0, scope: !200)
!223 = !DILocation(line: 73, column: 0, scope: !200)
!224 = !DILocation(line: 74, column: 0, scope: !200)
!225 = !DILocation(line: 75, column: 0, scope: !200)
!226 = !DILocation(line: 76, column: 0, scope: !200)
!227 = !DILocation(line: 78, column: 0, scope: !200)
!228 = !DILocation(line: 79, column: 0, scope: !200)
!229 = !DILocation(line: 80, column: 0, scope: !200)
!230 = !DILocation(line: 81, column: 0, scope: !200)
!231 = !DILocation(line: 82, column: 0, scope: !200)
!234 = !DILocation(line: 87, column: 0, scope: !232)
!235 = !DILocation(line: 88, column: 0, scope: !232)
!236 = !DILocation(line: 89, column: 0, scope: !232)
!237 = !DILocation(line: 90, column: 0, scope: !232)
!238 = !DILocation(line: 91, column: 0, scope: !232)
!239 = !DILocation(line: 92, column: 0, scope: !232)
!240 = !DILocation(line: 93, column: 0, scope: !232)
!241 = !DILocation(line: 94, column: 0, scope: !232)
!242 = !DILocation(line: 96, column: 0, scope: !232)
!243 = !DILocation(line: 97, column: 0, scope: !232)
!244 = !DILocation(line: 98, column: 0, scope: !232)
!245 = !DILocation(line: 99, column: 0, scope: !232)
!248 = !DILocation(line: 104, column: 0, scope: !246)
!249 = !DILocation(line: 105, column: 0, scope: !246)
!250 = !DILocation(line: 106, column: 0, scope: !246)
!251 = !DILocation(line: 107, column: 0, scope: !246)
!252 = !DILocation(line: 108, column: 0, scope: !246)
!253 = !DILocation(line: 109, column: 0, scope: !246)
!254 = !DILocation(line: 110, column: 0, scope: !246)
!255 = !DILocation(line: 111, column: 0, scope: !246)
!258 = !DILocation(line: 116, column: 0, scope: !256)
!259 = !DILocation(line: 117, column: 0, scope: !256)
!260 = !DILocation(line: 118, column: 0, scope: !256)
!261 = !DILocation(line: 119, column: 0, scope: !256)
!262 = !DILocation(line: 120, column: 0, scope: !256)
!263 = !DILocation(line: 121, column: 0, scope: !256)
!264 = !DILocation(line: 122, column: 0, scope: !256)
!265 = !DILocation(line: 123, column: 0, scope: !256)
!266 = !DILocation(line: 124, column: 0, scope: !256)
!267 = !DILocation(line: 125, column: 0, scope: !256)
!268 = !DILocation(line: 126, column: 0, scope: !256)
!269 = !DILocation(line: 127, column: 0, scope: !256)
!270 = !DILocation(line: 128, column: 0, scope: !256)
!271 = !DILocation(line: 129, column: 0, scope: !256)
!274 = !DILocation(line: 134, column: 0, scope: !272)
!275 = !DILocation(line: 135, column: 0, scope: !272)
!276 = !DILocation(line: 136, column: 0, scope: !272)
!277 = !DILocation(line: 137, column: 0, scope: !272)
!278 = !DILocation(line: 138, column: 0, scope: !272)
!279 = !DILocation(line: 139, column: 0, scope: !272)
!280 = !DILocation(line: 140, column: 0, scope: !272)
!283 = !DILocation(line: 143, column: 0, scope: !281)

; TBAA metadata
!0 = !{!"NOVA TBAA"}
!1 = !{!"list_data_ptr", !0}
!2 = !{!1, !1, i64 0}
!3 = !{!"list_elem", !0}
!4 = !{!3, !3, i64 0}
!5 = !{!"list_size", !0}
!6 = !{!5, !5, i64 0}
!90 = !{!"branch_weights", i32 2000, i32 1}
