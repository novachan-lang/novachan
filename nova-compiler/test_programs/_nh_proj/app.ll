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
declare i64 @nova_rt_eq(i64, i64) nounwind readonly
declare i64 @nova_rt_neq(i64, i64) nounwind readonly
declare i64 @nova_rt_any_to_str(i64) nounwind
declare void @nova_rt_assert(i64, i64) nounwind
declare i64 @nova_rt_read_file(i64) nounwind
declare i64 @nova_rt_write_file(i64, i64) nounwind
declare i64 @nova_rt_remove_file(i64) nounwind
declare i64 @nova_rt_remove_dir(i64) nounwind
declare i64 @nova_rt_rename_path(i64, i64) nounwind
declare i64 @nova_rt_copy_file(i64, i64) nounwind
declare i64 @nova_rt_file_size(i64) nounwind
declare i64 @nova_rt_file_mtime(i64) nounwind
declare i64 @nova_rt_rc_drop_reassign(i64, i64) nounwind
declare i64 @nova_rt_is_dir(i64) nounwind
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
declare i64 @nova_rt_float_to_str(i64) nounwind
declare ptr @nova_rt_struct_alloc(i64) nounwind
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
declare i64 @nova_rt_regex_replace_all(i64, i64, i64) nounwind
declare i64 @nova_rt_path_ext(i64) nounwind
declare i64 @nova_rt_tcp_connect(i64, i64) nounwind
declare i64 @nova_rt_tcp_listen(i64) nounwind
declare i64 @nova_rt_tcp_accept(i64) nounwind
declare i64 @nova_rt_tcp_send(i64, i64) nounwind
declare i64 @nova_rt_tcp_recv(i64) nounwind
declare i64 @nova_rt_udp_bind(i64) nounwind
declare i64 @nova_rt_udp_send(i64, i64, i64, i64) nounwind
declare i64 @nova_rt_udp_recv(i64) nounwind
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

; ESCAPE _status_line: allocs=0 escape=0 local=0
define i64 @_status_line(i64 %p0) nounwind uwtable {
entry:
  %slot.status = alloca i64, align 8
  store i64 %p0, ptr %slot.status, align 8
  %r0 = load i64, ptr %slot.status, align 8
  %r1 = add i64 200, 0
  %r2.cmp = icmp eq i64 %r0, %r1
  %r2 = zext i1 %r2.cmp to i64
  %br_then00 = icmp ne i64 %r2, 0
  br i1 %br_then00, label %then0, label %else1
then0:
  %r3.p = getelementptr inbounds [7 x i8], ptr @.str.0, i64 0, i64 0
  %r3 = ptrtoint ptr %r3.p to i64
  ret i64 %r3
else1:
  br label %endif2
endif2:
  %r4 = load i64, ptr %slot.status, align 8
  %r5 = add i64 201, 0
  %r6.cmp = icmp eq i64 %r4, %r5
  %r6 = zext i1 %r6.cmp to i64
  %br_then31 = icmp ne i64 %r6, 0
  br i1 %br_then31, label %then3, label %else4
then3:
  %r7.p = getelementptr inbounds [12 x i8], ptr @.str.1, i64 0, i64 0
  %r7 = ptrtoint ptr %r7.p to i64
  ret i64 %r7
else4:
  br label %endif5
endif5:
  %r8 = load i64, ptr %slot.status, align 8
  %r9 = add i64 204, 0
  %r10.cmp = icmp eq i64 %r8, %r9
  %r10 = zext i1 %r10.cmp to i64
  %br_then62 = icmp ne i64 %r10, 0
  br i1 %br_then62, label %then6, label %else7
then6:
  %r11.p = getelementptr inbounds [15 x i8], ptr @.str.2, i64 0, i64 0
  %r11 = ptrtoint ptr %r11.p to i64
  ret i64 %r11
else7:
  br label %endif8
endif8:
  %r12 = load i64, ptr %slot.status, align 8
  %r13 = add i64 301, 0
  %r14.cmp = icmp eq i64 %r12, %r13
  %r14 = zext i1 %r14.cmp to i64
  %br_then93 = icmp ne i64 %r14, 0
  br i1 %br_then93, label %then9, label %else10
then9:
  %r15.p = getelementptr inbounds [22 x i8], ptr @.str.3, i64 0, i64 0
  %r15 = ptrtoint ptr %r15.p to i64
  ret i64 %r15
else10:
  br label %endif11
endif11:
  %r16 = load i64, ptr %slot.status, align 8
  %r17 = add i64 302, 0
  %r18.cmp = icmp eq i64 %r16, %r17
  %r18 = zext i1 %r18.cmp to i64
  %br_then124 = icmp ne i64 %r18, 0
  br i1 %br_then124, label %then12, label %else13
then12:
  %r19.p = getelementptr inbounds [10 x i8], ptr @.str.4, i64 0, i64 0
  %r19 = ptrtoint ptr %r19.p to i64
  ret i64 %r19
else13:
  br label %endif14
endif14:
  %r20 = load i64, ptr %slot.status, align 8
  %r21 = add i64 400, 0
  %r22.cmp = icmp eq i64 %r20, %r21
  %r22 = zext i1 %r22.cmp to i64
  %br_then155 = icmp ne i64 %r22, 0
  br i1 %br_then155, label %then15, label %else16
then15:
  %r23.p = getelementptr inbounds [16 x i8], ptr @.str.5, i64 0, i64 0
  %r23 = ptrtoint ptr %r23.p to i64
  ret i64 %r23
else16:
  br label %endif17
endif17:
  %r24 = load i64, ptr %slot.status, align 8
  %r25 = add i64 401, 0
  %r26.cmp = icmp eq i64 %r24, %r25
  %r26 = zext i1 %r26.cmp to i64
  %br_then186 = icmp ne i64 %r26, 0
  br i1 %br_then186, label %then18, label %else19
then18:
  %r27.p = getelementptr inbounds [17 x i8], ptr @.str.6, i64 0, i64 0
  %r27 = ptrtoint ptr %r27.p to i64
  ret i64 %r27
else19:
  br label %endif20
endif20:
  %r28 = load i64, ptr %slot.status, align 8
  %r29 = add i64 403, 0
  %r30.cmp = icmp eq i64 %r28, %r29
  %r30 = zext i1 %r30.cmp to i64
  %br_then217 = icmp ne i64 %r30, 0
  br i1 %br_then217, label %then21, label %else22
then21:
  %r31.p = getelementptr inbounds [14 x i8], ptr @.str.7, i64 0, i64 0
  %r31 = ptrtoint ptr %r31.p to i64
  ret i64 %r31
else22:
  br label %endif23
endif23:
  %r32 = load i64, ptr %slot.status, align 8
  %r33 = add i64 404, 0
  %r34.cmp = icmp eq i64 %r32, %r33
  %r34 = zext i1 %r34.cmp to i64
  %br_then248 = icmp ne i64 %r34, 0
  br i1 %br_then248, label %then24, label %else25
then24:
  %r35.p = getelementptr inbounds [14 x i8], ptr @.str.8, i64 0, i64 0
  %r35 = ptrtoint ptr %r35.p to i64
  ret i64 %r35
else25:
  br label %endif26
endif26:
  %r36 = load i64, ptr %slot.status, align 8
  %r37 = add i64 500, 0
  %r38.cmp = icmp eq i64 %r36, %r37
  %r38 = zext i1 %r38.cmp to i64
  %br_then279 = icmp ne i64 %r38, 0
  br i1 %br_then279, label %then27, label %else28
then27:
  %r39.p = getelementptr inbounds [26 x i8], ptr @.str.9, i64 0, i64 0
  %r39 = ptrtoint ptr %r39.p to i64
  ret i64 %r39
else28:
  br label %endif29
endif29:
  %r40 = load i64, ptr %slot.status, align 8
  %r41 = call i64 @nova_rt_int_to_str(i64 %r40)
  %r42.p = getelementptr inbounds [4 x i8], ptr @.str.10, i64 0, i64 0
  %r42 = ptrtoint ptr %r42.p to i64
  %r43 = call i64 @nova_rt_str_concat(i64 %r41, i64 %r42)
  ret i64 %r43
}

; ESCAPE _build: allocs=0 escape=0 local=0
define i64 @_build(i64 %p0, i64 %p1, i64 %p2) nounwind uwtable {
entry:
  %slot.status = alloca i64, align 8
  store i64 %p0, ptr %slot.status, align 8
  %slot.ctype = alloca i64, align 8
  store i64 %p1, ptr %slot.ctype, align 8
  %slot.body = alloca i64, align 8
  store i64 %p2, ptr %slot.body, align 8
  %slot.r = alloca i64, align 8
  store i64 0, ptr %slot.r, align 8
  %r0.p = getelementptr inbounds [10 x i8], ptr @.str.11, i64 0, i64 0
  %r0 = ptrtoint ptr %r0.p to i64
  %r1 = load i64, ptr %slot.status, align 8
  %r2 = call i64 @_status_line(i64 %r1)
  %r3 = call i64 @nova_rt_str_concat(i64 %r0, i64 %r2)
  %r4.p = getelementptr inbounds [3 x i8], ptr @.str.12, i64 0, i64 0
  %r4 = ptrtoint ptr %r4.p to i64
  %r5 = call i64 @nova_rt_str_concat(i64 %r3, i64 %r4)
  store i64 %r5, ptr %slot.r, align 8
  %r6 = load i64, ptr %slot.r, align 8
  %r7.p = getelementptr inbounds [15 x i8], ptr @.str.13, i64 0, i64 0
  %r7 = ptrtoint ptr %r7.p to i64
  %r8 = call i64 @nova_rt_str_concat(i64 %r6, i64 %r7)
  %r9 = load i64, ptr %slot.ctype, align 8
  %r10 = call i64 @nova_rt_str_concat(i64 %r8, i64 %r9)
  %r11.p = getelementptr inbounds [3 x i8], ptr @.str.12, i64 0, i64 0
  %r11 = ptrtoint ptr %r11.p to i64
  %r12 = call i64 @nova_rt_str_concat(i64 %r10, i64 %r11)
  store i64 %r12, ptr %slot.r, align 8
  %r13 = load i64, ptr %slot.r, align 8
  %r14.p = getelementptr inbounds [17 x i8], ptr @.str.14, i64 0, i64 0
  %r14 = ptrtoint ptr %r14.p to i64
  %r15 = call i64 @nova_rt_str_concat(i64 %r13, i64 %r14)
  %r16 = load i64, ptr %slot.body, align 8
  %r17 = call i64 @nova_rt_len_any(i64 %r16)
  %r18 = call i64 @nova_rt_int_to_str(i64 %r17)
  %r19 = call i64 @nova_rt_str_concat(i64 %r15, i64 %r18)
  %r20.p = getelementptr inbounds [3 x i8], ptr @.str.12, i64 0, i64 0
  %r20 = ptrtoint ptr %r20.p to i64
  %r21 = call i64 @nova_rt_str_concat(i64 %r19, i64 %r20)
  store i64 %r21, ptr %slot.r, align 8
  %r22 = load i64, ptr %slot.r, align 8
  %r23.p = getelementptr inbounds [20 x i8], ptr @.str.15, i64 0, i64 0
  %r23 = ptrtoint ptr %r23.p to i64
  %r24 = call i64 @nova_rt_str_concat(i64 %r22, i64 %r23)
  store i64 %r24, ptr %slot.r, align 8
  %r25 = load i64, ptr %slot.r, align 8
  %r26.p = getelementptr inbounds [21 x i8], ptr @.str.16, i64 0, i64 0
  %r26 = ptrtoint ptr %r26.p to i64
  %r27 = call i64 @nova_rt_str_concat(i64 %r25, i64 %r26)
  store i64 %r27, ptr %slot.r, align 8
  %r28 = load i64, ptr %slot.r, align 8
  %r29.p = getelementptr inbounds [3 x i8], ptr @.str.12, i64 0, i64 0
  %r29 = ptrtoint ptr %r29.p to i64
  %r30 = call i64 @nova_rt_str_concat(i64 %r28, i64 %r29)
  store i64 %r30, ptr %slot.r, align 8
  %r31 = load i64, ptr %slot.r, align 8
  %r32 = load i64, ptr %slot.body, align 8
  %r33 = call i64 @nova_rt_str_concat(i64 %r31, i64 %r32)
  store i64 %r33, ptr %slot.r, align 8
  %r34 = load i64, ptr %slot.r, align 8
  ret i64 %r34
}

; ESCAPE text: allocs=0 escape=0 local=0
define i64 @text(i64 %p0, i64 %p1) nounwind uwtable {
entry:
  %slot.status = alloca i64, align 8
  store i64 %p0, ptr %slot.status, align 8
  %slot.body = alloca i64, align 8
  store i64 %p1, ptr %slot.body, align 8
  %r0 = load i64, ptr %slot.status, align 8
  %r1.p = getelementptr inbounds [26 x i8], ptr @.str.17, i64 0, i64 0
  %r1 = ptrtoint ptr %r1.p to i64
  %r2 = load i64, ptr %slot.body, align 8
  %r3 = call i64 @_build(i64 %r0, i64 %r1, i64 %r2)
  ret i64 %r3
}

; ESCAPE html: allocs=0 escape=0 local=0
define i64 @html(i64 %p0, i64 %p1) nounwind uwtable {
entry:
  %slot.status = alloca i64, align 8
  store i64 %p0, ptr %slot.status, align 8
  %slot.body = alloca i64, align 8
  store i64 %p1, ptr %slot.body, align 8
  %r0 = load i64, ptr %slot.status, align 8
  %r1.p = getelementptr inbounds [25 x i8], ptr @.str.18, i64 0, i64 0
  %r1 = ptrtoint ptr %r1.p to i64
  %r2 = load i64, ptr %slot.body, align 8
  %r3 = call i64 @_build(i64 %r0, i64 %r1, i64 %r2)
  ret i64 %r3
}

; ESCAPE json: allocs=0 escape=0 local=0
define i64 @json(i64 %p0, i64 %p1) nounwind uwtable {
entry:
  %slot.status = alloca i64, align 8
  store i64 %p0, ptr %slot.status, align 8
  %slot.body = alloca i64, align 8
  store i64 %p1, ptr %slot.body, align 8
  %r0 = load i64, ptr %slot.status, align 8
  %r1.p = getelementptr inbounds [17 x i8], ptr @.str.19, i64 0, i64 0
  %r1 = ptrtoint ptr %r1.p to i64
  %r2 = load i64, ptr %slot.body, align 8
  %r3 = call i64 @_build(i64 %r0, i64 %r1, i64 %r2)
  ret i64 %r3
}

; ESCAPE json_of: allocs=0 escape=0 local=0
define i64 @json_of(i64 %p0, i64 %p1) nounwind uwtable {
entry:
  %slot.status = alloca i64, align 8
  store i64 %p0, ptr %slot.status, align 8
  %slot.value = alloca i64, align 8
  store i64 %p1, ptr %slot.value, align 8
  %r0 = load i64, ptr %slot.status, align 8
  %r1 = load i64, ptr %slot.value, align 8
  %r2 = call i64 @nova_rt_json_stringify(i64 %r1)
  %r3 = call i64 @json(i64 %r0, i64 %r2)
  ret i64 %r3
}

; ESCAPE parse_method: allocs=0 escape=0 local=0
define i64 @parse_method(i64 %p0) nounwind uwtable {
entry:
  %slot.req = alloca i64, align 8
  store i64 %p0, ptr %slot.req, align 8
  %slot.sp = alloca i64, align 8
  store i64 0, ptr %slot.sp, align 8
  %r0 = load i64, ptr %slot.req, align 8
  %r1.p = getelementptr inbounds [2 x i8], ptr @.str.20, i64 0, i64 0
  %r1 = ptrtoint ptr %r1.p to i64
  %r2 = call i64 @nova_rt_find(i64 %r0, i64 %r1)
  store i64 %r2, ptr %slot.sp, align 8
  %r3 = load i64, ptr %slot.sp, align 8
  %r4 = add i64 0, 0
  %r5.cmp = icmp slt i64 %r3, %r4
  %r5 = zext i1 %r5.cmp to i64
  %br_then300 = icmp ne i64 %r5, 0
  br i1 %br_then300, label %then30, label %else31
then30:
  %r6.p = getelementptr inbounds [4 x i8], ptr @.str.21, i64 0, i64 0
  %r6 = ptrtoint ptr %r6.p to i64
  ret i64 %r6
else31:
  br label %endif32
endif32:
  %r7 = load i64, ptr %slot.req, align 8
  %r8 = add i64 0, 0
  %r9 = load i64, ptr %slot.sp, align 8
  %r10 = call i64 @nova_rt_slice(i64 %r7, i64 %r8, i64 %r9)
  ret i64 %r10
}

; ESCAPE parse_path: allocs=0 escape=0 local=0
define i64 @parse_path(i64 %p0) nounwind uwtable {
entry:
  %slot.req = alloca i64, align 8
  store i64 %p0, ptr %slot.req, align 8
  %slot.sp1 = alloca i64, align 8
  store i64 0, ptr %slot.sp1, align 8
  %slot.rest = alloca i64, align 8
  store i64 0, ptr %slot.rest, align 8
  %slot.sp2 = alloca i64, align 8
  store i64 0, ptr %slot.sp2, align 8
  %r0 = load i64, ptr %slot.req, align 8
  %r1.p = getelementptr inbounds [2 x i8], ptr @.str.20, i64 0, i64 0
  %r1 = ptrtoint ptr %r1.p to i64
  %r2 = call i64 @nova_rt_find(i64 %r0, i64 %r1)
  store i64 %r2, ptr %slot.sp1, align 8
  %r3 = load i64, ptr %slot.sp1, align 8
  %r4 = add i64 0, 0
  %r5.cmp = icmp slt i64 %r3, %r4
  %r5 = zext i1 %r5.cmp to i64
  %br_then330 = icmp ne i64 %r5, 0
  br i1 %br_then330, label %then33, label %else34
then33:
  %r6.p = getelementptr inbounds [2 x i8], ptr @.str.22, i64 0, i64 0
  %r6 = ptrtoint ptr %r6.p to i64
  ret i64 %r6
else34:
  br label %endif35
endif35:
  %r7 = load i64, ptr %slot.req, align 8
  %r8 = load i64, ptr %slot.sp1, align 8
  %r9 = add i64 1, 0
  %r10 = add i64 %r8, %r9
  %r11 = load i64, ptr %slot.req, align 8
  %r12 = call i64 @nova_rt_len_any(i64 %r11)
  %r13 = call i64 @nova_rt_slice(i64 %r7, i64 %r10, i64 %r12)
  store i64 %r13, ptr %slot.rest, align 8
  %r14 = load i64, ptr %slot.rest, align 8
  %r15.p = getelementptr inbounds [2 x i8], ptr @.str.20, i64 0, i64 0
  %r15 = ptrtoint ptr %r15.p to i64
  %r16 = call i64 @nova_rt_find(i64 %r14, i64 %r15)
  store i64 %r16, ptr %slot.sp2, align 8
  %r17 = load i64, ptr %slot.sp2, align 8
  %r18 = add i64 0, 0
  %r19.cmp = icmp slt i64 %r17, %r18
  %r19 = zext i1 %r19.cmp to i64
  %br_then361 = icmp ne i64 %r19, 0
  br i1 %br_then361, label %then36, label %else37
then36:
  %r20 = load i64, ptr %slot.rest, align 8
  ret i64 %r20
else37:
  br label %endif38
endif38:
  %r21 = load i64, ptr %slot.rest, align 8
  %r22 = add i64 0, 0
  %r23 = load i64, ptr %slot.sp2, align 8
  %r24 = call i64 @nova_rt_slice(i64 %r21, i64 %r22, i64 %r23)
  ret i64 %r24
}

; ESCAPE parse_body: allocs=0 escape=0 local=0
define i64 @parse_body(i64 %p0) nounwind uwtable {
entry:
  %slot.req = alloca i64, align 8
  store i64 %p0, ptr %slot.req, align 8
  %slot.sep = alloca i64, align 8
  store i64 0, ptr %slot.sep, align 8
  %r0 = load i64, ptr %slot.req, align 8
  %r1.p = getelementptr inbounds [5 x i8], ptr @.str.23, i64 0, i64 0
  %r1 = ptrtoint ptr %r1.p to i64
  %r2 = call i64 @nova_rt_find(i64 %r0, i64 %r1)
  store i64 %r2, ptr %slot.sep, align 8
  %r3 = load i64, ptr %slot.sep, align 8
  %r4 = add i64 0, 0
  %r5.cmp = icmp slt i64 %r3, %r4
  %r5 = zext i1 %r5.cmp to i64
  %br_then390 = icmp ne i64 %r5, 0
  br i1 %br_then390, label %then39, label %else40
then39:
  %r6.p = getelementptr inbounds [1 x i8], ptr @.str.24, i64 0, i64 0
  %r6 = ptrtoint ptr %r6.p to i64
  ret i64 %r6
else40:
  br label %endif41
endif41:
  %r7 = load i64, ptr %slot.req, align 8
  %r8 = load i64, ptr %slot.sep, align 8
  %r9 = add i64 4, 0
  %r10 = add i64 %r8, %r9
  %r11 = load i64, ptr %slot.req, align 8
  %r12 = call i64 @nova_rt_len_any(i64 %r11)
  %r13 = call i64 @nova_rt_slice(i64 %r7, i64 %r10, i64 %r12)
  ret i64 %r13
}

; ESCAPE parse_query: allocs=0 escape=0 local=0
define i64 @parse_query(i64 %p0) nounwind uwtable {
entry:
  %slot.req = alloca i64, align 8
  store i64 %p0, ptr %slot.req, align 8
  %slot.p = alloca i64, align 8
  store i64 0, ptr %slot.p, align 8
  %slot.q = alloca i64, align 8
  store i64 0, ptr %slot.q, align 8
  %r0 = load i64, ptr %slot.req, align 8
  %r1 = call i64 @parse_path(i64 %r0)
  store i64 %r1, ptr %slot.p, align 8
  %r2 = load i64, ptr %slot.p, align 8
  %r3.p = getelementptr inbounds [2 x i8], ptr @.str.25, i64 0, i64 0
  %r3 = ptrtoint ptr %r3.p to i64
  %r4 = call i64 @nova_rt_find(i64 %r2, i64 %r3)
  store i64 %r4, ptr %slot.q, align 8
  %r5 = load i64, ptr %slot.q, align 8
  %r6 = add i64 0, 0
  %r7.cmp = icmp slt i64 %r5, %r6
  %r7 = zext i1 %r7.cmp to i64
  %br_then420 = icmp ne i64 %r7, 0
  br i1 %br_then420, label %then42, label %else43
then42:
  %r8.p = getelementptr inbounds [1 x i8], ptr @.str.24, i64 0, i64 0
  %r8 = ptrtoint ptr %r8.p to i64
  ret i64 %r8
else43:
  br label %endif44
endif44:
  %r9 = load i64, ptr %slot.p, align 8
  %r10 = load i64, ptr %slot.q, align 8
  %r11 = add i64 1, 0
  %r12 = add i64 %r10, %r11
  %r13 = load i64, ptr %slot.p, align 8
  %r14 = call i64 @nova_rt_len_any(i64 %r13)
  %r15 = call i64 @nova_rt_slice(i64 %r9, i64 %r12, i64 %r14)
  ret i64 %r15
}

; ESCAPE parse_path_clean: allocs=0 escape=0 local=0
define i64 @parse_path_clean(i64 %p0) nounwind uwtable {
entry:
  %slot.req = alloca i64, align 8
  store i64 %p0, ptr %slot.req, align 8
  %slot.p = alloca i64, align 8
  store i64 0, ptr %slot.p, align 8
  %slot.q = alloca i64, align 8
  store i64 0, ptr %slot.q, align 8
  %r0 = load i64, ptr %slot.req, align 8
  %r1 = call i64 @parse_path(i64 %r0)
  store i64 %r1, ptr %slot.p, align 8
  %r2 = load i64, ptr %slot.p, align 8
  %r3.p = getelementptr inbounds [2 x i8], ptr @.str.25, i64 0, i64 0
  %r3 = ptrtoint ptr %r3.p to i64
  %r4 = call i64 @nova_rt_find(i64 %r2, i64 %r3)
  store i64 %r4, ptr %slot.q, align 8
  %r5 = load i64, ptr %slot.q, align 8
  %r6 = add i64 0, 0
  %r7.cmp = icmp slt i64 %r5, %r6
  %r7 = zext i1 %r7.cmp to i64
  %br_then450 = icmp ne i64 %r7, 0
  br i1 %br_then450, label %then45, label %else46
then45:
  %r8 = load i64, ptr %slot.p, align 8
  ret i64 %r8
else46:
  br label %endif47
endif47:
  %r9 = load i64, ptr %slot.p, align 8
  %r10 = add i64 0, 0
  %r11 = load i64, ptr %slot.q, align 8
  %r12 = call i64 @nova_rt_slice(i64 %r9, i64 %r10, i64 %r11)
  ret i64 %r12
}

; ESCAPE query_get: allocs=0 escape=0 local=0
define i64 @query_get(i64 %p0, i64 %p1) nounwind uwtable {
entry:
  %slot.req = alloca i64, align 8
  store i64 %p0, ptr %slot.req, align 8
  %slot.key = alloca i64, align 8
  store i64 %p1, ptr %slot.key, align 8
  %slot.q = alloca i64, align 8
  store i64 0, ptr %slot.q, align 8
  %slot.needle = alloca i64, align 8
  store i64 0, ptr %slot.needle, align 8
  %slot.i = alloca i64, align 8
  store i64 0, ptr %slot.i, align 8
  %slot.prev = alloca i64, align 8
  store i64 0, ptr %slot.prev, align 8
  %slot.rest = alloca i64, align 8
  store i64 0, ptr %slot.rest, align 8
  %slot.amp = alloca i64, align 8
  store i64 0, ptr %slot.amp, align 8
  %r0 = load i64, ptr %slot.req, align 8
  %r1 = call i64 @parse_query(i64 %r0)
  store i64 %r1, ptr %slot.q, align 8
  %r2 = load i64, ptr %slot.q, align 8
  %r3 = call i64 @nova_rt_len_any(i64 %r2)
  %r4 = add i64 0, 0
  %r5.cmp = icmp eq i64 %r3, %r4
  %r5 = zext i1 %r5.cmp to i64
  %br_then480 = icmp ne i64 %r5, 0
  br i1 %br_then480, label %then48, label %else49
then48:
  %r6.p = getelementptr inbounds [1 x i8], ptr @.str.24, i64 0, i64 0
  %r6 = ptrtoint ptr %r6.p to i64
  ret i64 %r6
else49:
  br label %endif50
endif50:
  %r7 = load i64, ptr %slot.key, align 8
  %r8.p = getelementptr inbounds [2 x i8], ptr @.str.26, i64 0, i64 0
  %r8 = ptrtoint ptr %r8.p to i64
  %r9 = call i64 @nova_rt_str_concat(i64 %r7, i64 %r8)
  store i64 %r9, ptr %slot.needle, align 8
  %r10 = load i64, ptr %slot.q, align 8
  %r11 = load i64, ptr %slot.needle, align 8
  %r12 = call i64 @nova_rt_find(i64 %r10, i64 %r11)
  store i64 %r12, ptr %slot.i, align 8
  %r13 = load i64, ptr %slot.i, align 8
  %r14 = add i64 0, 0
  %r15.cmp = icmp slt i64 %r13, %r14
  %r15 = zext i1 %r15.cmp to i64
  %br_then511 = icmp ne i64 %r15, 0
  br i1 %br_then511, label %then51, label %else52
then51:
  %r16.p = getelementptr inbounds [1 x i8], ptr @.str.24, i64 0, i64 0
  %r16 = ptrtoint ptr %r16.p to i64
  ret i64 %r16
else52:
  br label %endif53
endif53:
  %r17 = load i64, ptr %slot.i, align 8
  %r18 = add i64 0, 0
  %r19.cmp = icmp sgt i64 %r17, %r18
  %r19 = zext i1 %r19.cmp to i64
  %br_then542 = icmp ne i64 %r19, 0
  br i1 %br_then542, label %then54, label %else55
then54:
  %r20 = load i64, ptr %slot.q, align 8
  %r21 = load i64, ptr %slot.i, align 8
  %r22 = add i64 1, 0
  %r23 = sub i64 %r21, %r22
  %r24 = call i64 @nova_rt_index_get(i64 %r20, i64 %r23)
  store i64 %r24, ptr %slot.prev, align 8
  %r25 = load i64, ptr %slot.prev, align 8
  %r26.p = getelementptr inbounds [2 x i8], ptr @.str.27, i64 0, i64 0
  %r26 = ptrtoint ptr %r26.p to i64
  %r27.p0 = inttoptr i64 %r25 to ptr
  %r27.p1 = inttoptr i64 %r26 to ptr
  %r27.sc = call i32 @strcmp(ptr %r27.p0, ptr %r27.p1)
  %r27.cmp = icmp ne i32 %r27.sc, 0
  %r27 = zext i1 %r27.cmp to i64
  %br_then573 = icmp ne i64 %r27, 0
  br i1 %br_then573, label %then57, label %else58
then57:
  %r28.p = getelementptr inbounds [1 x i8], ptr @.str.24, i64 0, i64 0
  %r28 = ptrtoint ptr %r28.p to i64
  ret i64 %r28
else58:
  br label %endif59
endif59:
  br label %endif56
else55:
  br label %endif56
endif56:
  %r29 = load i64, ptr %slot.q, align 8
  %r30 = load i64, ptr %slot.i, align 8
  %r31 = load i64, ptr %slot.needle, align 8
  %r32 = call i64 @nova_rt_len_any(i64 %r31)
  %r33 = add i64 %r30, %r32
  %r34 = load i64, ptr %slot.q, align 8
  %r35 = call i64 @nova_rt_len_any(i64 %r34)
  %r36 = call i64 @nova_rt_slice(i64 %r29, i64 %r33, i64 %r35)
  store i64 %r36, ptr %slot.rest, align 8
  %r37 = load i64, ptr %slot.rest, align 8
  %r38.p = getelementptr inbounds [2 x i8], ptr @.str.27, i64 0, i64 0
  %r38 = ptrtoint ptr %r38.p to i64
  %r39 = call i64 @nova_rt_find(i64 %r37, i64 %r38)
  store i64 %r39, ptr %slot.amp, align 8
  %r40 = load i64, ptr %slot.amp, align 8
  %r41 = add i64 0, 0
  %r42.cmp = icmp slt i64 %r40, %r41
  %r42 = zext i1 %r42.cmp to i64
  %br_then604 = icmp ne i64 %r42, 0
  br i1 %br_then604, label %then60, label %else61
then60:
  %r43 = load i64, ptr %slot.rest, align 8
  ret i64 %r43
else61:
  br label %endif62
endif62:
  %r44 = load i64, ptr %slot.rest, align 8
  %r45 = add i64 0, 0
  %r46 = load i64, ptr %slot.amp, align 8
  %r47 = call i64 @nova_rt_slice(i64 %r44, i64 %r45, i64 %r46)
  ret i64 %r47
}

; ESCAPE header_get: allocs=0 escape=0 local=0
define i64 @header_get(i64 %p0, i64 %p1) nounwind uwtable {
entry:
  %slot.req = alloca i64, align 8
  store i64 %p0, ptr %slot.req, align 8
  %slot.name = alloca i64, align 8
  store i64 %p1, ptr %slot.name, align 8
  %slot.hdr_end = alloca i64, align 8
  store i64 0, ptr %slot.hdr_end, align 8
  %slot.region = alloca i64, align 8
  store i64 0, ptr %slot.region, align 8
  %slot.needle = alloca i64, align 8
  store i64 0, ptr %slot.needle, align 8
  %slot.i = alloca i64, align 8
  store i64 0, ptr %slot.i, align 8
  %slot.rest = alloca i64, align 8
  store i64 0, ptr %slot.rest, align 8
  %slot.nl = alloca i64, align 8
  store i64 0, ptr %slot.nl, align 8
  %r0 = load i64, ptr %slot.req, align 8
  %r1.p = getelementptr inbounds [5 x i8], ptr @.str.23, i64 0, i64 0
  %r1 = ptrtoint ptr %r1.p to i64
  %r2 = call i64 @nova_rt_find(i64 %r0, i64 %r1)
  store i64 %r2, ptr %slot.hdr_end, align 8
  %r3 = load i64, ptr %slot.req, align 8
  store i64 %r3, ptr %slot.region, align 8
  %r4 = load i64, ptr %slot.hdr_end, align 8
  %r5 = add i64 0, 0
  %r6.cmp = icmp sge i64 %r4, %r5
  %r6 = zext i1 %r6.cmp to i64
  %br_then630 = icmp ne i64 %r6, 0
  br i1 %br_then630, label %then63, label %else64
then63:
  %r7 = load i64, ptr %slot.req, align 8
  %r8 = add i64 0, 0
  %r9 = load i64, ptr %slot.hdr_end, align 8
  %r10 = call i64 @nova_rt_slice(i64 %r7, i64 %r8, i64 %r9)
  store i64 %r10, ptr %slot.region, align 8
  br label %endif65
else64:
  br label %endif65
endif65:
  %r11.p = getelementptr inbounds [3 x i8], ptr @.str.12, i64 0, i64 0
  %r11 = ptrtoint ptr %r11.p to i64
  %r12 = load i64, ptr %slot.name, align 8
  %r13 = call i64 @nova_rt_str_concat(i64 %r11, i64 %r12)
  %r14.p = getelementptr inbounds [3 x i8], ptr @.str.28, i64 0, i64 0
  %r14 = ptrtoint ptr %r14.p to i64
  %r15 = call i64 @nova_rt_str_concat(i64 %r13, i64 %r14)
  store i64 %r15, ptr %slot.needle, align 8
  %r16 = load i64, ptr %slot.region, align 8
  %r17 = load i64, ptr %slot.needle, align 8
  %r18 = call i64 @nova_rt_find(i64 %r16, i64 %r17)
  store i64 %r18, ptr %slot.i, align 8
  %r19 = load i64, ptr %slot.i, align 8
  %r20 = add i64 0, 0
  %r21.cmp = icmp slt i64 %r19, %r20
  %r21 = zext i1 %r21.cmp to i64
  %br_then661 = icmp ne i64 %r21, 0
  br i1 %br_then661, label %then66, label %else67
then66:
  %r22.p = getelementptr inbounds [1 x i8], ptr @.str.24, i64 0, i64 0
  %r22 = ptrtoint ptr %r22.p to i64
  ret i64 %r22
else67:
  br label %endif68
endif68:
  %r23 = load i64, ptr %slot.region, align 8
  %r24 = load i64, ptr %slot.i, align 8
  %r25 = load i64, ptr %slot.needle, align 8
  %r26 = call i64 @nova_rt_len_any(i64 %r25)
  %r27 = add i64 %r24, %r26
  %r28 = load i64, ptr %slot.region, align 8
  %r29 = call i64 @nova_rt_len_any(i64 %r28)
  %r30 = call i64 @nova_rt_slice(i64 %r23, i64 %r27, i64 %r29)
  store i64 %r30, ptr %slot.rest, align 8
  %r31 = load i64, ptr %slot.rest, align 8
  %r32.p = getelementptr inbounds [3 x i8], ptr @.str.12, i64 0, i64 0
  %r32 = ptrtoint ptr %r32.p to i64
  %r33 = call i64 @nova_rt_find(i64 %r31, i64 %r32)
  store i64 %r33, ptr %slot.nl, align 8
  %r34 = load i64, ptr %slot.nl, align 8
  %r35 = add i64 0, 0
  %r36.cmp = icmp slt i64 %r34, %r35
  %r36 = zext i1 %r36.cmp to i64
  %br_then692 = icmp ne i64 %r36, 0
  br i1 %br_then692, label %then69, label %else70
then69:
  %r37 = load i64, ptr %slot.rest, align 8
  ret i64 %r37
else70:
  br label %endif71
endif71:
  %r38 = load i64, ptr %slot.rest, align 8
  %r39 = add i64 0, 0
  %r40 = load i64, ptr %slot.nl, align 8
  %r41 = call i64 @nova_rt_slice(i64 %r38, i64 %r39, i64 %r40)
  ret i64 %r41
}

; ESCAPE redirect: allocs=0 escape=0 local=0
define i64 @redirect(i64 %p0, i64 %p1) nounwind uwtable {
entry:
  %slot.status = alloca i64, align 8
  store i64 %p0, ptr %slot.status, align 8
  %slot.url = alloca i64, align 8
  store i64 %p1, ptr %slot.url, align 8
  %slot.r = alloca i64, align 8
  store i64 0, ptr %slot.r, align 8
  %r0.p = getelementptr inbounds [10 x i8], ptr @.str.11, i64 0, i64 0
  %r0 = ptrtoint ptr %r0.p to i64
  %r1 = load i64, ptr %slot.status, align 8
  %r2 = call i64 @_status_line(i64 %r1)
  %r3 = call i64 @nova_rt_str_concat(i64 %r0, i64 %r2)
  %r4.p = getelementptr inbounds [3 x i8], ptr @.str.12, i64 0, i64 0
  %r4 = ptrtoint ptr %r4.p to i64
  %r5 = call i64 @nova_rt_str_concat(i64 %r3, i64 %r4)
  store i64 %r5, ptr %slot.r, align 8
  %r6 = load i64, ptr %slot.r, align 8
  %r7.p = getelementptr inbounds [11 x i8], ptr @.str.29, i64 0, i64 0
  %r7 = ptrtoint ptr %r7.p to i64
  %r8 = call i64 @nova_rt_str_concat(i64 %r6, i64 %r7)
  %r9 = load i64, ptr %slot.url, align 8
  %r10 = call i64 @nova_rt_str_concat(i64 %r8, i64 %r9)
  %r11.p = getelementptr inbounds [3 x i8], ptr @.str.12, i64 0, i64 0
  %r11 = ptrtoint ptr %r11.p to i64
  %r12 = call i64 @nova_rt_str_concat(i64 %r10, i64 %r11)
  store i64 %r12, ptr %slot.r, align 8
  %r13 = load i64, ptr %slot.r, align 8
  %r14.p = getelementptr inbounds [20 x i8], ptr @.str.30, i64 0, i64 0
  %r14 = ptrtoint ptr %r14.p to i64
  %r15 = call i64 @nova_rt_str_concat(i64 %r13, i64 %r14)
  store i64 %r15, ptr %slot.r, align 8
  %r16 = load i64, ptr %slot.r, align 8
  %r17.p = getelementptr inbounds [20 x i8], ptr @.str.15, i64 0, i64 0
  %r17 = ptrtoint ptr %r17.p to i64
  %r18 = call i64 @nova_rt_str_concat(i64 %r16, i64 %r17)
  store i64 %r18, ptr %slot.r, align 8
  %r19 = load i64, ptr %slot.r, align 8
  %r20.p = getelementptr inbounds [21 x i8], ptr @.str.16, i64 0, i64 0
  %r20 = ptrtoint ptr %r20.p to i64
  %r21 = call i64 @nova_rt_str_concat(i64 %r19, i64 %r20)
  store i64 %r21, ptr %slot.r, align 8
  %r22 = load i64, ptr %slot.r, align 8
  %r23.p = getelementptr inbounds [3 x i8], ptr @.str.12, i64 0, i64 0
  %r23 = ptrtoint ptr %r23.p to i64
  %r24 = call i64 @nova_rt_str_concat(i64 %r22, i64 %r23)
  store i64 %r24, ptr %slot.r, align 8
  %r25 = load i64, ptr %slot.r, align 8
  ret i64 %r25
}

; ESCAPE _ext_ctype: allocs=0 escape=0 local=0
define i64 @_ext_ctype(i64 %p0) nounwind uwtable {
entry:
  %slot.path = alloca i64, align 8
  store i64 %p0, ptr %slot.path, align 8
  %slot.__sc_72 = alloca i64, align 8
  store i64 0, ptr %slot.__sc_72, align 8
  %slot.__sc_90 = alloca i64, align 8
  store i64 0, ptr %slot.__sc_90, align 8
  %r0 = load i64, ptr %slot.path, align 8
  %r1.p = getelementptr inbounds [6 x i8], ptr @.str.31, i64 0, i64 0
  %r1 = ptrtoint ptr %r1.p to i64
  %r2 = call i64 @nova_rt_ends_with(i64 %r0, i64 %r1)
  store i64 %r2, ptr %slot.__sc_72, align 8
  %br_or_merge740 = icmp ne i64 %r2, 0
  br i1 %br_or_merge740, label %or_merge74, label %or_rhs73
or_rhs73:
  %r3 = load i64, ptr %slot.path, align 8
  %r4.p = getelementptr inbounds [5 x i8], ptr @.str.32, i64 0, i64 0
  %r4 = ptrtoint ptr %r4.p to i64
  %r5 = call i64 @nova_rt_ends_with(i64 %r3, i64 %r4)
  store i64 %r5, ptr %slot.__sc_72, align 8
  br label %or_merge74
or_merge74:
  %r6 = load i64, ptr %slot.__sc_72, align 8
  %br_then751 = icmp ne i64 %r6, 0
  br i1 %br_then751, label %then75, label %else76
then75:
  %r7.p = getelementptr inbounds [25 x i8], ptr @.str.18, i64 0, i64 0
  %r7 = ptrtoint ptr %r7.p to i64
  ret i64 %r7
else76:
  br label %endif77
endif77:
  %r8 = load i64, ptr %slot.path, align 8
  %r9.p = getelementptr inbounds [5 x i8], ptr @.str.33, i64 0, i64 0
  %r9 = ptrtoint ptr %r9.p to i64
  %r10 = call i64 @nova_rt_ends_with(i64 %r8, i64 %r9)
  %br_then782 = icmp ne i64 %r10, 0
  br i1 %br_then782, label %then78, label %else79
then78:
  %r11.p = getelementptr inbounds [24 x i8], ptr @.str.34, i64 0, i64 0
  %r11 = ptrtoint ptr %r11.p to i64
  ret i64 %r11
else79:
  br label %endif80
endif80:
  %r12 = load i64, ptr %slot.path, align 8
  %r13.p = getelementptr inbounds [4 x i8], ptr @.str.35, i64 0, i64 0
  %r13 = ptrtoint ptr %r13.p to i64
  %r14 = call i64 @nova_rt_ends_with(i64 %r12, i64 %r13)
  %br_then813 = icmp ne i64 %r14, 0
  br i1 %br_then813, label %then81, label %else82
then81:
  %r15.p = getelementptr inbounds [38 x i8], ptr @.str.36, i64 0, i64 0
  %r15 = ptrtoint ptr %r15.p to i64
  ret i64 %r15
else82:
  br label %endif83
endif83:
  %r16 = load i64, ptr %slot.path, align 8
  %r17.p = getelementptr inbounds [6 x i8], ptr @.str.37, i64 0, i64 0
  %r17 = ptrtoint ptr %r17.p to i64
  %r18 = call i64 @nova_rt_ends_with(i64 %r16, i64 %r17)
  %br_then844 = icmp ne i64 %r18, 0
  br i1 %br_then844, label %then84, label %else85
then84:
  %r19.p = getelementptr inbounds [17 x i8], ptr @.str.19, i64 0, i64 0
  %r19 = ptrtoint ptr %r19.p to i64
  ret i64 %r19
else85:
  br label %endif86
endif86:
  %r20 = load i64, ptr %slot.path, align 8
  %r21.p = getelementptr inbounds [5 x i8], ptr @.str.38, i64 0, i64 0
  %r21 = ptrtoint ptr %r21.p to i64
  %r22 = call i64 @nova_rt_ends_with(i64 %r20, i64 %r21)
  %br_then875 = icmp ne i64 %r22, 0
  br i1 %br_then875, label %then87, label %else88
then87:
  %r23.p = getelementptr inbounds [10 x i8], ptr @.str.39, i64 0, i64 0
  %r23 = ptrtoint ptr %r23.p to i64
  ret i64 %r23
else88:
  br label %endif89
endif89:
  %r24 = load i64, ptr %slot.path, align 8
  %r25.p = getelementptr inbounds [5 x i8], ptr @.str.40, i64 0, i64 0
  %r25 = ptrtoint ptr %r25.p to i64
  %r26 = call i64 @nova_rt_ends_with(i64 %r24, i64 %r25)
  store i64 %r26, ptr %slot.__sc_90, align 8
  %br_or_merge926 = icmp ne i64 %r26, 0
  br i1 %br_or_merge926, label %or_merge92, label %or_rhs91
or_rhs91:
  %r27 = load i64, ptr %slot.path, align 8
  %r28.p = getelementptr inbounds [6 x i8], ptr @.str.41, i64 0, i64 0
  %r28 = ptrtoint ptr %r28.p to i64
  %r29 = call i64 @nova_rt_ends_with(i64 %r27, i64 %r28)
  store i64 %r29, ptr %slot.__sc_90, align 8
  br label %or_merge92
or_merge92:
  %r30 = load i64, ptr %slot.__sc_90, align 8
  %br_then937 = icmp ne i64 %r30, 0
  br i1 %br_then937, label %then93, label %else94
then93:
  %r31.p = getelementptr inbounds [11 x i8], ptr @.str.42, i64 0, i64 0
  %r31 = ptrtoint ptr %r31.p to i64
  ret i64 %r31
else94:
  br label %endif95
endif95:
  %r32 = load i64, ptr %slot.path, align 8
  %r33.p = getelementptr inbounds [5 x i8], ptr @.str.43, i64 0, i64 0
  %r33 = ptrtoint ptr %r33.p to i64
  %r34 = call i64 @nova_rt_ends_with(i64 %r32, i64 %r33)
  %br_then968 = icmp ne i64 %r34, 0
  br i1 %br_then968, label %then96, label %else97
then96:
  %r35.p = getelementptr inbounds [14 x i8], ptr @.str.44, i64 0, i64 0
  %r35 = ptrtoint ptr %r35.p to i64
  ret i64 %r35
else97:
  br label %endif98
endif98:
  %r36 = load i64, ptr %slot.path, align 8
  %r37.p = getelementptr inbounds [6 x i8], ptr @.str.45, i64 0, i64 0
  %r37 = ptrtoint ptr %r37.p to i64
  %r38 = call i64 @nova_rt_ends_with(i64 %r36, i64 %r37)
  %br_then999 = icmp ne i64 %r38, 0
  br i1 %br_then999, label %then99, label %else100
then99:
  %r39.p = getelementptr inbounds [17 x i8], ptr @.str.46, i64 0, i64 0
  %r39 = ptrtoint ptr %r39.p to i64
  ret i64 %r39
else100:
  br label %endif101
endif101:
  %r40.p = getelementptr inbounds [25 x i8], ptr @.str.47, i64 0, i64 0
  %r40 = ptrtoint ptr %r40.p to i64
  ret i64 %r40
}

; ESCAPE serve_file: allocs=0 escape=0 local=0
define i64 @serve_file(i64 %p0) nounwind uwtable {
entry:
  %slot.path = alloca i64, align 8
  store i64 %p0, ptr %slot.path, align 8
  %slot.content = alloca i64, align 8
  store i64 0, ptr %slot.content, align 8
  %r0 = load i64, ptr %slot.path, align 8
  %r1 = call i64 @nova_rt_read_file(i64 %r0)
  store i64 %r1, ptr %slot.content, align 8
  %r2 = load i64, ptr %slot.content, align 8
  %r3 = call i64 @nova_rt_len_any(i64 %r2)
  %r4 = add i64 0, 0
  %r5.cmp = icmp eq i64 %r3, %r4
  %r5 = zext i1 %r5.cmp to i64
  %br_then1020 = icmp ne i64 %r5, 0
  br i1 %br_then1020, label %then102, label %else103
then102:
  %r6 = add i64 404, 0
  %r7.p = getelementptr inbounds [17 x i8], ptr @.str.48, i64 0, i64 0
  %r7 = ptrtoint ptr %r7.p to i64
  %r8 = load i64, ptr %slot.path, align 8
  %r9 = call i64 @nova_rt_str_concat(i64 %r7, i64 %r8)
  %r10 = call i64 @text(i64 %r6, i64 %r9)
  ret i64 %r10
else103:
  br label %endif104
endif104:
  %r11 = add i64 200, 0
  %r12 = load i64, ptr %slot.path, align 8
  %r13 = call i64 @_ext_ctype(i64 %r12)
  %r14 = load i64, ptr %slot.content, align 8
  %r15 = call i64 @_build(i64 %r11, i64 %r13, i64 %r14)
  ret i64 %r15
}

; ESCAPE json_obj: allocs=0 escape=0 local=0
define i64 @json_obj(i64 %p0, i64 %p1) nounwind uwtable {
entry:
  %slot.status = alloca i64, align 8
  store i64 %p0, ptr %slot.status, align 8
  %slot.pairs = alloca i64, align 8
  store i64 %p1, ptr %slot.pairs, align 8
  %slot.body = alloca i64, align 8
  store i64 0, ptr %slot.body, align 8
  %slot.n = alloca i64, align 8
  store i64 0, ptr %slot.n, align 8
  %slot.i = alloca i64, align 8
  store i64 0, ptr %slot.i, align 8
  %slot.kv = alloca i64, align 8
  store i64 0, ptr %slot.kv, align 8
  %slot.k = alloca i64, align 8
  store i64 0, ptr %slot.k, align 8
  %slot.v = alloca i64, align 8
  store i64 0, ptr %slot.v, align 8
  %r0.p = getelementptr inbounds [2 x i8], ptr @.str.49, i64 0, i64 0
  %r0 = ptrtoint ptr %r0.p to i64
  store i64 %r0, ptr %slot.body, align 8
  %r1 = load i64, ptr %slot.pairs, align 8
  %r2.lp = inttoptr i64 %r1 to ptr
  %r2.szp = getelementptr i64, ptr %r2.lp, i64 1
  %r2 = load i64, ptr %r2.szp, align 8, !tbaa !6
  store i64 %r2, ptr %slot.n, align 8
  %r3 = add i64 0, 0
  store i64 %r3, ptr %slot.i, align 8
  br label %while_hdr105
while_hdr105:
  %r4 = load i64, ptr %slot.i, align 8
  %r5 = load i64, ptr %slot.n, align 8
  %r6.cmp = icmp slt i64 %r4, %r5
  %r6 = zext i1 %r6.cmp to i64
  %br_while_body1060 = icmp ne i64 %r6, 0
  br i1 %br_while_body1060, label %while_body106, label %while_exit107, !prof !90
while_body106:
  %r7 = load i64, ptr %slot.pairs, align 8
  %r8 = load i64, ptr %slot.i, align 8
  %r9.lp = inttoptr i64 %r7 to ptr
  %r9.dp = load ptr, ptr %r9.lp, align 8, !tbaa !2
  %r9.ep = getelementptr i64, ptr %r9.dp, i64 %r8
  %r9.lv = load i64, ptr %r9.ep, align 8, !tbaa !4
  %r9 = call i64 @nova_rt_unbox_elem(i64 %r9.lv)
  store i64 %r9, ptr %slot.kv, align 8
  %r10 = load i64, ptr %slot.kv, align 8
  %r11 = add i64 0, 0
  %r12 = call i64 @nova_rt_index_get(i64 %r10, i64 %r11)
  store i64 %r12, ptr %slot.k, align 8
  %r13 = load i64, ptr %slot.kv, align 8
  %r14 = add i64 1, 0
  %r15 = call i64 @nova_rt_index_get(i64 %r13, i64 %r14)
  store i64 %r15, ptr %slot.v, align 8
  %r16 = load i64, ptr %slot.i, align 8
  %r17 = add i64 0, 0
  %r18.cmp = icmp sgt i64 %r16, %r17
  %r18 = zext i1 %r18.cmp to i64
  %br_then1081 = icmp ne i64 %r18, 0
  br i1 %br_then1081, label %then108, label %else109
then108:
  %r19 = load i64, ptr %slot.body, align 8
  %r20.p = getelementptr inbounds [2 x i8], ptr @.str.50, i64 0, i64 0
  %r20 = ptrtoint ptr %r20.p to i64
  %r21 = call i64 @nova_rt_str_concat(i64 %r19, i64 %r20)
  store i64 %r21, ptr %slot.body, align 8
  br label %endif110
else109:
  br label %endif110
endif110:
  %r22 = load i64, ptr %slot.body, align 8
  %r23.p = getelementptr inbounds [2 x i8], ptr @.str.51, i64 0, i64 0
  %r23 = ptrtoint ptr %r23.p to i64
  %r24 = call i64 @nova_rt_str_concat(i64 %r22, i64 %r23)
  %r25 = load i64, ptr %slot.k, align 8
  %r26 = call i64 @nova_rt_str_concat(i64 %r24, i64 %r25)
  %r27.p = getelementptr inbounds [4 x i8], ptr @.str.52, i64 0, i64 0
  %r27 = ptrtoint ptr %r27.p to i64
  %r28 = call i64 @nova_rt_str_concat(i64 %r26, i64 %r27)
  %r29 = load i64, ptr %slot.v, align 8
  %r30 = call i64 @nova_rt_str_concat(i64 %r28, i64 %r29)
  %r31.p = getelementptr inbounds [2 x i8], ptr @.str.51, i64 0, i64 0
  %r31 = ptrtoint ptr %r31.p to i64
  %r32 = call i64 @nova_rt_str_concat(i64 %r30, i64 %r31)
  store i64 %r32, ptr %slot.body, align 8
  %r33 = load i64, ptr %slot.i, align 8
  %r34 = add i64 1, 0
  %r35 = add i64 %r33, %r34
  store i64 %r35, ptr %slot.i, align 8
  br label %while_hdr105
while_exit107:
  %r36 = load i64, ptr %slot.body, align 8
  %r37.p = getelementptr inbounds [2 x i8], ptr @.str.53, i64 0, i64 0
  %r37 = ptrtoint ptr %r37.p to i64
  %r38 = call i64 @nova_rt_str_concat(i64 %r36, i64 %r37)
  store i64 %r38, ptr %slot.body, align 8
  %r39 = load i64, ptr %slot.status, align 8
  %r40.p = getelementptr inbounds [17 x i8], ptr @.str.19, i64 0, i64 0
  %r40 = ptrtoint ptr %r40.p to i64
  %r41 = load i64, ptr %slot.body, align 8
  %r42 = call i64 @_build(i64 %r39, i64 %r40, i64 %r41)
  ret i64 %r42
}

; ESCAPE _content_length: allocs=0 escape=0 local=0
define i64 @_content_length(i64 %p0) nounwind uwtable {
entry:
  %slot.raw = alloca i64, align 8
  store i64 %p0, ptr %slot.raw, align 8
  %slot.idx = alloca i64, align 8
  store i64 0, ptr %slot.idx, align 8
  %slot.after = alloca i64, align 8
  store i64 0, ptr %slot.after, align 8
  %slot.nl = alloca i64, align 8
  store i64 0, ptr %slot.nl, align 8
  %r0 = load i64, ptr %slot.raw, align 8
  %r1.p = getelementptr inbounds [16 x i8], ptr @.str.54, i64 0, i64 0
  %r1 = ptrtoint ptr %r1.p to i64
  %r2 = call i64 @nova_rt_find(i64 %r0, i64 %r1)
  store i64 %r2, ptr %slot.idx, align 8
  %r3 = load i64, ptr %slot.idx, align 8
  %r4 = add i64 0, 0
  %r5.cmp = icmp slt i64 %r3, %r4
  %r5 = zext i1 %r5.cmp to i64
  %br_then1110 = icmp ne i64 %r5, 0
  br i1 %br_then1110, label %then111, label %else112
then111:
  %r6 = add i64 0, 0
  ret i64 %r6
else112:
  br label %endif113
endif113:
  %r7 = load i64, ptr %slot.raw, align 8
  %r8 = load i64, ptr %slot.idx, align 8
  %r9 = add i64 15, 0
  %r10 = add i64 %r8, %r9
  %r11 = load i64, ptr %slot.raw, align 8
  %r12 = call i64 @nova_rt_len_any(i64 %r11)
  %r13 = call i64 @nova_rt_slice(i64 %r7, i64 %r10, i64 %r12)
  store i64 %r13, ptr %slot.after, align 8
  %r14 = load i64, ptr %slot.after, align 8
  %r15.p = getelementptr inbounds [3 x i8], ptr @.str.12, i64 0, i64 0
  %r15 = ptrtoint ptr %r15.p to i64
  %r16 = call i64 @nova_rt_find(i64 %r14, i64 %r15)
  store i64 %r16, ptr %slot.nl, align 8
  %r17 = load i64, ptr %slot.nl, align 8
  %r18 = add i64 0, 0
  %r19.cmp = icmp slt i64 %r17, %r18
  %r19 = zext i1 %r19.cmp to i64
  %br_then1141 = icmp ne i64 %r19, 0
  br i1 %br_then1141, label %then114, label %else115
then114:
  %r20 = add i64 0, 0
  ret i64 %r20
else115:
  br label %endif116
endif116:
  %r21 = load i64, ptr %slot.after, align 8
  %r22 = add i64 0, 0
  %r23 = load i64, ptr %slot.nl, align 8
  %r24 = call i64 @nova_rt_slice(i64 %r21, i64 %r22, i64 %r23)
  %r25 = call i64 @nova_rt_trim(i64 %r24)
  %r26 = call i64 @nova_rt_parse_int(i64 %r25)
  ret i64 %r26
}

; ESCAPE recv_request: allocs=0 escape=0 local=0
define i64 @recv_request(i64 %p0) nounwind uwtable {
entry:
  %slot.conn = alloca i64, align 8
  store i64 %p0, ptr %slot.conn, align 8
  %slot.req = alloca i64, align 8
  store i64 0, ptr %slot.req, align 8
  %slot.sep = alloca i64, align 8
  store i64 0, ptr %slot.sep, align 8
  %slot.more = alloca i64, align 8
  store i64 0, ptr %slot.more, align 8
  %slot.cl = alloca i64, align 8
  store i64 0, ptr %slot.cl, align 8
  %slot.__sc_129 = alloca i64, align 8
  store i64 0, ptr %slot.__sc_129, align 8
  %r0 = load i64, ptr %slot.conn, align 8
  %r1 = call i64 @nova_rt_tcp_recv(i64 %r0)
  store i64 %r1, ptr %slot.req, align 8
  %r2 = load i64, ptr %slot.req, align 8
  %r3 = call i64 @nova_rt_len_any(i64 %r2)
  %r4 = add i64 0, 0
  %r5.cmp = icmp eq i64 %r3, %r4
  %r5 = zext i1 %r5.cmp to i64
  %br_then1170 = icmp ne i64 %r5, 0
  br i1 %br_then1170, label %then117, label %else118
then117:
  %r6 = load i64, ptr %slot.req, align 8
  ret i64 %r6
else118:
  br label %endif119
endif119:
  %r7 = load i64, ptr %slot.req, align 8
  %r8.p = getelementptr inbounds [5 x i8], ptr @.str.23, i64 0, i64 0
  %r8 = ptrtoint ptr %r8.p to i64
  %r9 = call i64 @nova_rt_find(i64 %r7, i64 %r8)
  store i64 %r9, ptr %slot.sep, align 8
  br label %while_hdr120
while_hdr120:
  %r10 = load i64, ptr %slot.sep, align 8
  %r11 = add i64 0, 0
  %r12.cmp = icmp slt i64 %r10, %r11
  %r12 = zext i1 %r12.cmp to i64
  %br_while_body1211 = icmp ne i64 %r12, 0
  br i1 %br_while_body1211, label %while_body121, label %while_exit122, !prof !90
while_body121:
  %r13 = load i64, ptr %slot.conn, align 8
  %r14 = call i64 @nova_rt_tcp_recv(i64 %r13)
  store i64 %r14, ptr %slot.more, align 8
  %r15 = load i64, ptr %slot.more, align 8
  %r16 = call i64 @nova_rt_len_any(i64 %r15)
  %r17 = add i64 0, 0
  %r18.cmp = icmp eq i64 %r16, %r17
  %r18 = zext i1 %r18.cmp to i64
  %br_then1232 = icmp ne i64 %r18, 0
  br i1 %br_then1232, label %then123, label %else124
then123:
  %r19 = load i64, ptr %slot.req, align 8
  ret i64 %r19
else124:
  br label %endif125
endif125:
  %r20 = load i64, ptr %slot.req, align 8
  %r21 = load i64, ptr %slot.more, align 8
  %r22 = call i64 @nova_rt_add(i64 %r20, i64 %r21)
  store i64 %r22, ptr %slot.req, align 8
  %r23 = load i64, ptr %slot.req, align 8
  %r24.p = getelementptr inbounds [5 x i8], ptr @.str.23, i64 0, i64 0
  %r24 = ptrtoint ptr %r24.p to i64
  %r25 = call i64 @nova_rt_find(i64 %r23, i64 %r24)
  store i64 %r25, ptr %slot.sep, align 8
  br label %while_hdr120
while_exit122:
  %r26 = load i64, ptr %slot.req, align 8
  %r27 = call i64 @_content_length(i64 %r26)
  store i64 %r27, ptr %slot.cl, align 8
  br label %while_hdr126
while_hdr126:
  %r28 = load i64, ptr %slot.cl, align 8
  %r29 = add i64 0, 0
  %r30.cmp = icmp sgt i64 %r28, %r29
  %r30 = zext i1 %r30.cmp to i64
  store i64 %r30, ptr %slot.__sc_129, align 8
  %br_and_rhs1303 = icmp ne i64 %r30, 0
  br i1 %br_and_rhs1303, label %and_rhs130, label %and_merge131
and_rhs130:
  %r31 = load i64, ptr %slot.req, align 8
  %r32 = call i64 @nova_rt_len_any(i64 %r31)
  %r33 = load i64, ptr %slot.sep, align 8
  %r34 = add i64 4, 0
  %r35 = add i64 %r33, %r34
  %r36 = sub i64 %r32, %r35
  %r37 = load i64, ptr %slot.cl, align 8
  %r38.cmp = icmp slt i64 %r36, %r37
  %r38 = zext i1 %r38.cmp to i64
  store i64 %r38, ptr %slot.__sc_129, align 8
  br label %and_merge131
and_merge131:
  %r39 = load i64, ptr %slot.__sc_129, align 8
  %br_while_body1274 = icmp ne i64 %r39, 0
  br i1 %br_while_body1274, label %while_body127, label %while_exit128, !prof !90
while_body127:
  %r40 = load i64, ptr %slot.conn, align 8
  %r41 = call i64 @nova_rt_tcp_recv(i64 %r40)
  store i64 %r41, ptr %slot.more, align 8
  %r42 = load i64, ptr %slot.more, align 8
  %r43 = call i64 @nova_rt_len_any(i64 %r42)
  %r44 = add i64 0, 0
  %r45.cmp = icmp eq i64 %r43, %r44
  %r45 = zext i1 %r45.cmp to i64
  %br_then1325 = icmp ne i64 %r45, 0
  br i1 %br_then1325, label %then132, label %else133
then132:
  %r46 = load i64, ptr %slot.req, align 8
  ret i64 %r46
else133:
  br label %endif134
endif134:
  %r47 = load i64, ptr %slot.req, align 8
  %r48 = load i64, ptr %slot.more, align 8
  %r49 = call i64 @nova_rt_add(i64 %r47, i64 %r48)
  store i64 %r49, ptr %slot.req, align 8
  br label %while_hdr126
while_exit128:
  %r50 = load i64, ptr %slot.req, align 8
  ret i64 %r50
}

; ESCAPE _handle_one: allocs=0 escape=0 local=0
define i64 @_handle_one(i64 %p0, i64 %p1) nounwind uwtable {
entry:
  %slot.conn = alloca i64, align 8
  store i64 %p0, ptr %slot.conn, align 8
  %slot.handler = alloca i64, align 8
  store i64 %p1, ptr %slot.handler, align 8
  %slot.req = alloca i64, align 8
  store i64 0, ptr %slot.req, align 8
  %slot.m = alloca i64, align 8
  store i64 0, ptr %slot.m, align 8
  %slot.p = alloca i64, align 8
  store i64 0, ptr %slot.p, align 8
  %slot.b = alloca i64, align 8
  store i64 0, ptr %slot.b, align 8
  %slot.resp = alloca i64, align 8
  store i64 0, ptr %slot.resp, align 8
  %r0 = load i64, ptr %slot.conn, align 8
  %r1 = call i64 @recv_request(i64 %r0)
  store i64 %r1, ptr %slot.req, align 8
  %r2 = load i64, ptr %slot.req, align 8
  %r3 = call i64 @parse_method(i64 %r2)
  store i64 %r3, ptr %slot.m, align 8
  %r4 = load i64, ptr %slot.req, align 8
  %r5 = call i64 @parse_path(i64 %r4)
  store i64 %r5, ptr %slot.p, align 8
  %r6 = load i64, ptr %slot.req, align 8
  %r7 = call i64 @parse_body(i64 %r6)
  store i64 %r7, ptr %slot.b, align 8
  %r8 = load i64, ptr %slot.m, align 8
  %r9 = load i64, ptr %slot.p, align 8
  %r10 = load i64, ptr %slot.b, align 8
  %r12 = load i64, ptr %slot.handler, align 8
  %r11.rec = inttoptr i64 %r12 to ptr
  %r11.fnraw = load i64, ptr %r11.rec, align 8
  %r11.fnptr = inttoptr i64 %r11.fnraw to ptr
  %r11 = call i64 %r11.fnptr(i64 %r12, i64 %r8, i64 %r9, i64 %r10)
  store i64 %r11, ptr %slot.resp, align 8
  %r13 = load i64, ptr %slot.conn, align 8
  %r14 = load i64, ptr %slot.resp, align 8
  %r15 = call i64 @nova_rt_tcp_send(i64 %r13, i64 %r14)
  %r16 = load i64, ptr %slot.conn, align 8
  %r17 = call i64 @nova_rt_tcp_close(i64 %r16)
  ret i64 %r17
}

; ESCAPE serve: allocs=0 escape=0 local=0
define i64 @serve(i64 %p0, i64 %p1) nounwind uwtable {
entry:
  %slot.port = alloca i64, align 8
  store i64 %p0, ptr %slot.port, align 8
  %slot.handler = alloca i64, align 8
  store i64 %p1, ptr %slot.handler, align 8
  %slot.listener = alloca i64, align 8
  store i64 0, ptr %slot.listener, align 8
  %slot.conn = alloca i64, align 8
  store i64 0, ptr %slot.conn, align 8
  %r0 = load i64, ptr %slot.port, align 8
  %r1 = call i64 @nova_rt_tcp_listen(i64 %r0)
  store i64 %r1, ptr %slot.listener, align 8
  br label %while_hdr135
while_hdr135:
  %r2 = add i64 1, 0
  %br_while_body1360 = icmp ne i64 %r2, 0
  br i1 %br_while_body1360, label %while_body136, label %while_exit137, !prof !90
while_body136:
  %r3 = load i64, ptr %slot.listener, align 8
  %r4 = call i64 @nova_rt_tcp_accept(i64 %r3)
  store i64 %r4, ptr %slot.conn, align 8
  %r5 = load i64, ptr %slot.conn, align 8
  %r6 = load i64, ptr %slot.handler, align 8
  %r7 = call i64 @_handle_one(i64 %r5, i64 %r6)
  br label %while_hdr135
while_exit137:
  ret i64 0
}

; ESCAPE serve_n: allocs=0 escape=0 local=0
define i64 @serve_n(i64 %p0, i64 %p1, i64 %p2) nounwind uwtable {
entry:
  %slot.port = alloca i64, align 8
  store i64 %p0, ptr %slot.port, align 8
  %slot.handler = alloca i64, align 8
  store i64 %p1, ptr %slot.handler, align 8
  %slot.n = alloca i64, align 8
  store i64 %p2, ptr %slot.n, align 8
  %slot.listener = alloca i64, align 8
  store i64 0, ptr %slot.listener, align 8
  %slot.i = alloca i64, align 8
  store i64 0, ptr %slot.i, align 8
  %slot.conn = alloca i64, align 8
  store i64 0, ptr %slot.conn, align 8
  %r0 = load i64, ptr %slot.port, align 8
  %r1 = call i64 @nova_rt_tcp_listen(i64 %r0)
  store i64 %r1, ptr %slot.listener, align 8
  %r2 = add i64 0, 0
  store i64 %r2, ptr %slot.i, align 8
  br label %while_hdr138
while_hdr138:
  %r3 = load i64, ptr %slot.i, align 8
  %r4 = load i64, ptr %slot.n, align 8
  %r5.cmp = icmp slt i64 %r3, %r4
  %r5 = zext i1 %r5.cmp to i64
  %br_while_body1390 = icmp ne i64 %r5, 0
  br i1 %br_while_body1390, label %while_body139, label %while_exit140, !prof !90
while_body139:
  %r6 = load i64, ptr %slot.listener, align 8
  %r7 = call i64 @nova_rt_tcp_accept(i64 %r6)
  store i64 %r7, ptr %slot.conn, align 8
  %r8 = load i64, ptr %slot.conn, align 8
  %r9 = load i64, ptr %slot.handler, align 8
  %r10 = call i64 @_handle_one(i64 %r8, i64 %r9)
  %r11 = load i64, ptr %slot.i, align 8
  %r12 = add i64 1, 0
  %r13 = add i64 %r11, %r12
  store i64 %r13, ptr %slot.i, align 8
  br label %while_hdr138
while_exit140:
  %r14 = load i64, ptr %slot.listener, align 8
  %r15 = call i64 @nova_rt_tcp_close(i64 %r14)
  ret i64 %r15
}

; ESCAPE _handle_one_arena: allocs=0 escape=0 local=0
define i64 @_handle_one_arena(i64 %p0, i64 %p1) nounwind uwtable {
entry:
  %slot.conn = alloca i64, align 8
  store i64 %p0, ptr %slot.conn, align 8
  %slot.handler = alloca i64, align 8
  store i64 %p1, ptr %slot.handler, align 8
  %slot.prev = alloca i64, align 8
  store i64 0, ptr %slot.prev, align 8
  %slot.req = alloca i64, align 8
  store i64 0, ptr %slot.req, align 8
  %slot.m = alloca i64, align 8
  store i64 0, ptr %slot.m, align 8
  %slot.p = alloca i64, align 8
  store i64 0, ptr %slot.p, align 8
  %slot.b = alloca i64, align 8
  store i64 0, ptr %slot.b, align 8
  %slot.resp = alloca i64, align 8
  store i64 0, ptr %slot.resp, align 8
  %r0 = call i64 @nova_rt_arena_scope_enter()
  store i64 %r0, ptr %slot.prev, align 8
  %r1 = load i64, ptr %slot.conn, align 8
  %r2 = call i64 @recv_request(i64 %r1)
  store i64 %r2, ptr %slot.req, align 8
  %r3 = load i64, ptr %slot.req, align 8
  %r4 = call i64 @parse_method(i64 %r3)
  store i64 %r4, ptr %slot.m, align 8
  %r5 = load i64, ptr %slot.req, align 8
  %r6 = call i64 @parse_path(i64 %r5)
  store i64 %r6, ptr %slot.p, align 8
  %r7 = load i64, ptr %slot.req, align 8
  %r8 = call i64 @parse_body(i64 %r7)
  store i64 %r8, ptr %slot.b, align 8
  %r9 = load i64, ptr %slot.m, align 8
  %r10 = load i64, ptr %slot.p, align 8
  %r11 = load i64, ptr %slot.b, align 8
  %r13 = load i64, ptr %slot.handler, align 8
  %r12.rec = inttoptr i64 %r13 to ptr
  %r12.fnraw = load i64, ptr %r12.rec, align 8
  %r12.fnptr = inttoptr i64 %r12.fnraw to ptr
  %r12 = call i64 %r12.fnptr(i64 %r13, i64 %r9, i64 %r10, i64 %r11)
  store i64 %r12, ptr %slot.resp, align 8
  %r14 = load i64, ptr %slot.conn, align 8
  %r15 = load i64, ptr %slot.resp, align 8
  %r16 = call i64 @nova_rt_tcp_send(i64 %r14, i64 %r15)
  %r17 = load i64, ptr %slot.prev, align 8
  %r18 = call i64 @nova_rt_arena_scope_exit(i64 %r17)
  %r19 = load i64, ptr %slot.conn, align 8
  %r20 = call i64 @nova_rt_tcp_close(i64 %r19)
  ret i64 %r20
}

; ESCAPE serve_n_arena: allocs=0 escape=0 local=0
define i64 @serve_n_arena(i64 %p0, i64 %p1, i64 %p2) nounwind uwtable {
entry:
  %slot.port = alloca i64, align 8
  store i64 %p0, ptr %slot.port, align 8
  %slot.handler = alloca i64, align 8
  store i64 %p1, ptr %slot.handler, align 8
  %slot.n = alloca i64, align 8
  store i64 %p2, ptr %slot.n, align 8
  %slot.listener = alloca i64, align 8
  store i64 0, ptr %slot.listener, align 8
  %slot.i = alloca i64, align 8
  store i64 0, ptr %slot.i, align 8
  %slot.conn = alloca i64, align 8
  store i64 0, ptr %slot.conn, align 8
  %r0 = load i64, ptr %slot.port, align 8
  %r1 = call i64 @nova_rt_tcp_listen(i64 %r0)
  store i64 %r1, ptr %slot.listener, align 8
  %r2 = add i64 0, 0
  store i64 %r2, ptr %slot.i, align 8
  br label %while_hdr141
while_hdr141:
  %r3 = load i64, ptr %slot.i, align 8
  %r4 = load i64, ptr %slot.n, align 8
  %r5.cmp = icmp slt i64 %r3, %r4
  %r5 = zext i1 %r5.cmp to i64
  %br_while_body1420 = icmp ne i64 %r5, 0
  br i1 %br_while_body1420, label %while_body142, label %while_exit143, !prof !90
while_body142:
  %r6 = load i64, ptr %slot.listener, align 8
  %r7 = call i64 @nova_rt_tcp_accept(i64 %r6)
  store i64 %r7, ptr %slot.conn, align 8
  %r8 = load i64, ptr %slot.conn, align 8
  %r9 = load i64, ptr %slot.handler, align 8
  %r10 = call i64 @_handle_one_arena(i64 %r8, i64 %r9)
  %r11 = load i64, ptr %slot.i, align 8
  %r12 = add i64 1, 0
  %r13 = add i64 %r11, %r12
  store i64 %r13, ptr %slot.i, align 8
  br label %while_hdr141
while_exit143:
  %r14 = load i64, ptr %slot.listener, align 8
  %r15 = call i64 @nova_rt_tcp_close(i64 %r14)
  ret i64 %r15
}

; ESCAPE serve_arena: allocs=0 escape=0 local=0
define i64 @serve_arena(i64 %p0, i64 %p1) nounwind uwtable {
entry:
  %slot.port = alloca i64, align 8
  store i64 %p0, ptr %slot.port, align 8
  %slot.handler = alloca i64, align 8
  store i64 %p1, ptr %slot.handler, align 8
  %slot.listener = alloca i64, align 8
  store i64 0, ptr %slot.listener, align 8
  %slot.conn = alloca i64, align 8
  store i64 0, ptr %slot.conn, align 8
  %r0 = load i64, ptr %slot.port, align 8
  %r1 = call i64 @nova_rt_tcp_listen(i64 %r0)
  store i64 %r1, ptr %slot.listener, align 8
  br label %while_hdr144
while_hdr144:
  %r2 = add i64 1, 0
  %br_while_body1450 = icmp ne i64 %r2, 0
  br i1 %br_while_body1450, label %while_body145, label %while_exit146, !prof !90
while_body145:
  %r3 = load i64, ptr %slot.listener, align 8
  %r4 = call i64 @nova_rt_tcp_accept(i64 %r3)
  store i64 %r4, ptr %slot.conn, align 8
  %r5 = load i64, ptr %slot.conn, align 8
  %r6 = load i64, ptr %slot.handler, align 8
  %r7 = call i64 @_handle_one_arena(i64 %r5, i64 %r6)
  br label %while_hdr144
while_exit146:
  ret i64 0
}

; ESCAPE with_cors: allocs=0 escape=0 local=0
define i64 @with_cors(i64 %p0, i64 %p1) nounwind uwtable {
entry:
  %slot.resp = alloca i64, align 8
  store i64 %p0, ptr %slot.resp, align 8
  %slot.origin = alloca i64, align 8
  store i64 %p1, ptr %slot.origin, align 8
  %slot.marker = alloca i64, align 8
  store i64 0, ptr %slot.marker, align 8
  %slot.i = alloca i64, align 8
  store i64 0, ptr %slot.i, align 8
  %slot.head = alloca i64, align 8
  store i64 0, ptr %slot.head, align 8
  %slot.body = alloca i64, align 8
  store i64 0, ptr %slot.body, align 8
  %slot.extra = alloca i64, align 8
  store i64 0, ptr %slot.extra, align 8
  %r0.p = getelementptr inbounds [5 x i8], ptr @.str.23, i64 0, i64 0
  %r0 = ptrtoint ptr %r0.p to i64
  store i64 %r0, ptr %slot.marker, align 8
  %r1 = load i64, ptr %slot.resp, align 8
  %r2 = load i64, ptr %slot.marker, align 8
  %r3 = call i64 @nova_rt_find(i64 %r1, i64 %r2)
  store i64 %r3, ptr %slot.i, align 8
  %r4 = load i64, ptr %slot.i, align 8
  %r5 = add i64 0, 0
  %r6.cmp = icmp slt i64 %r4, %r5
  %r6 = zext i1 %r6.cmp to i64
  %br_then1470 = icmp ne i64 %r6, 0
  br i1 %br_then1470, label %then147, label %else148
then147:
  %r7 = load i64, ptr %slot.resp, align 8
  ret i64 %r7
else148:
  br label %endif149
endif149:
  %r8 = load i64, ptr %slot.resp, align 8
  %r9 = add i64 0, 0
  %r10 = load i64, ptr %slot.i, align 8
  %r11 = call i64 @nova_rt_slice(i64 %r8, i64 %r9, i64 %r10)
  store i64 %r11, ptr %slot.head, align 8
  %r12 = load i64, ptr %slot.resp, align 8
  %r13 = load i64, ptr %slot.i, align 8
  %r14 = add i64 4, 0
  %r15 = add i64 %r13, %r14
  %r16 = load i64, ptr %slot.resp, align 8
  %r17 = call i64 @nova_rt_len_any(i64 %r16)
  %r18 = call i64 @nova_rt_slice(i64 %r12, i64 %r15, i64 %r17)
  store i64 %r18, ptr %slot.body, align 8
  %r19.p = getelementptr inbounds [32 x i8], ptr @.str.55, i64 0, i64 0
  %r19 = ptrtoint ptr %r19.p to i64
  %r20 = load i64, ptr %slot.origin, align 8
  %r21 = call i64 @nova_rt_str_concat(i64 %r19, i64 %r20)
  %r22.p = getelementptr inbounds [108 x i8], ptr @.str.56, i64 0, i64 0
  %r22 = ptrtoint ptr %r22.p to i64
  %r23 = call i64 @nova_rt_str_concat(i64 %r21, i64 %r22)
  store i64 %r23, ptr %slot.extra, align 8
  %r24 = load i64, ptr %slot.head, align 8
  %r25 = load i64, ptr %slot.extra, align 8
  %r26 = call i64 @nova_rt_str_concat(i64 %r24, i64 %r25)
  %r27 = load i64, ptr %slot.marker, align 8
  %r28 = call i64 @nova_rt_str_concat(i64 %r26, i64 %r27)
  %r29 = load i64, ptr %slot.body, align 8
  %r30 = call i64 @nova_rt_str_concat(i64 %r28, i64 %r29)
  ret i64 %r30
}

; ESCAPE ok_text: allocs=0 escape=0 local=0
define i64 @ok_text(i64 %p0) nounwind uwtable {
entry:
  %slot.body = alloca i64, align 8
  store i64 %p0, ptr %slot.body, align 8
  %r0 = add i64 200, 0
  %r1 = load i64, ptr %slot.body, align 8
  %r2 = call i64 @text(i64 %r0, i64 %r1)
  ret i64 %r2
}

; ESCAPE ok_json: allocs=0 escape=0 local=0
define i64 @ok_json(i64 %p0) nounwind uwtable {
entry:
  %slot.body = alloca i64, align 8
  store i64 %p0, ptr %slot.body, align 8
  %r0 = add i64 200, 0
  %r1 = load i64, ptr %slot.body, align 8
  %r2 = call i64 @json(i64 %r0, i64 %r1)
  ret i64 %r2
}

; ESCAPE ok_html: allocs=0 escape=0 local=0
define i64 @ok_html(i64 %p0) nounwind uwtable {
entry:
  %slot.body = alloca i64, align 8
  store i64 %p0, ptr %slot.body, align 8
  %r0 = add i64 200, 0
  %r1 = load i64, ptr %slot.body, align 8
  %r2 = call i64 @html(i64 %r0, i64 %r1)
  ret i64 %r2
}

; ESCAPE bad_request: allocs=0 escape=0 local=0
define i64 @bad_request(i64 %p0) nounwind uwtable {
entry:
  %slot.msg = alloca i64, align 8
  store i64 %p0, ptr %slot.msg, align 8
  %r0 = add i64 400, 0
  %r1 = load i64, ptr %slot.msg, align 8
  %r2 = call i64 @text(i64 %r0, i64 %r1)
  ret i64 %r2
}

; ESCAPE not_found: allocs=0 escape=0 local=0
define i64 @not_found(i64 %p0) nounwind uwtable {
entry:
  %slot.msg = alloca i64, align 8
  store i64 %p0, ptr %slot.msg, align 8
  %r0 = add i64 404, 0
  %r1 = load i64, ptr %slot.msg, align 8
  %r2 = call i64 @text(i64 %r0, i64 %r1)
  ret i64 %r2
}

; ESCAPE internal_error: allocs=0 escape=0 local=0
define i64 @internal_error(i64 %p0) nounwind uwtable {
entry:
  %slot.msg = alloca i64, align 8
  store i64 %p0, ptr %slot.msg, align 8
  %r0 = add i64 500, 0
  %r1 = load i64, ptr %slot.msg, align 8
  %r2 = call i64 @text(i64 %r0, i64 %r1)
  ret i64 %r2
}

; ESCAPE cors_preflight: allocs=0 escape=0 local=0
define i64 @cors_preflight(i64 %p0) nounwind uwtable {
entry:
  %slot.origin = alloca i64, align 8
  store i64 %p0, ptr %slot.origin, align 8
  %slot.r = alloca i64, align 8
  store i64 0, ptr %slot.r, align 8
  %r0 = add i64 204, 0
  %r1.p = getelementptr inbounds [1 x i8], ptr @.str.24, i64 0, i64 0
  %r1 = ptrtoint ptr %r1.p to i64
  %r2 = call i64 @text(i64 %r0, i64 %r1)
  store i64 %r2, ptr %slot.r, align 8
  %r3 = load i64, ptr %slot.r, align 8
  %r4 = load i64, ptr %slot.origin, align 8
  %r5 = call i64 @with_cors(i64 %r3, i64 %r4)
  ret i64 %r5
}

; ESCAPE app: allocs=4 escape=4 local=0
define i64 @app() nounwind uwtable {
entry:
  %slot.a = alloca i64, align 8
  store i64 0, ptr %slot.a, align 8
  %r0 = call i64 @nova_rt_dict_create()
  store i64 %r0, ptr %slot.a, align 8
  %r1 = call i64 @nova_rt_list_create()
  %r2 = load i64, ptr %slot.a, align 8
  %r3.p = getelementptr inbounds [7 x i8], ptr @.str.57, i64 0, i64 0
  %r3 = ptrtoint ptr %r3.p to i64
  %_is.dv0 = call i64 @nova_rt_dict_set(i64 %r2, i64 %r3, i64 %r1)
  %r4 = call i64 @nova_rt_list_create()
  %r5 = load i64, ptr %slot.a, align 8
  %r6.p = getelementptr inbounds [4 x i8], ptr @.str.58, i64 0, i64 0
  %r6 = ptrtoint ptr %r6.p to i64
  %_is.dv1 = call i64 @nova_rt_dict_set(i64 %r5, i64 %r6, i64 %r4)
  %r7 = call i64 @nova_rt_list_create()
  %r8 = load i64, ptr %slot.a, align 8
  %r9.p = getelementptr inbounds [8 x i8], ptr @.str.59, i64 0, i64 0
  %r9 = ptrtoint ptr %r9.p to i64
  %_is.dv2 = call i64 @nova_rt_dict_set(i64 %r8, i64 %r9, i64 %r7)
  %r10 = load i64, ptr %slot.a, align 8
  ret i64 %r10
}

; ESCAPE use: allocs=0 escape=0 local=0
define i64 @use(i64 %p0, i64 %p1) nounwind uwtable {
entry:
  %slot.a = alloca i64, align 8
  store i64 %p0, ptr %slot.a, align 8
  %slot.mw = alloca i64, align 8
  store i64 %p1, ptr %slot.mw, align 8
  %r0 = load i64, ptr %slot.a, align 8
  %r1.p = getelementptr inbounds [4 x i8], ptr @.str.58, i64 0, i64 0
  %r1 = ptrtoint ptr %r1.p to i64
  %r2 = call i64 @nova_rt_index_get(i64 %r0, i64 %r1)
  %r3 = load i64, ptr %slot.mw, align 8
  %r4 = call i64 @nova_rt_list_append(i64 %r2, i64 %r3)
  %r5 = load i64, ptr %slot.a, align 8
  ret i64 %r5
}

; ESCAPE group: allocs=1 escape=1 local=0
define i64 @group(i64 %p0, i64 %p1) nounwind uwtable {
entry:
  %slot.a = alloca i64, align 8
  store i64 %p0, ptr %slot.a, align 8
  %slot.prefix = alloca i64, align 8
  store i64 %p1, ptr %slot.prefix, align 8
  %slot.g = alloca i64, align 8
  store i64 0, ptr %slot.g, align 8
  %r0 = call i64 @nova_rt_dict_create()
  store i64 %r0, ptr %slot.g, align 8
  %r1 = load i64, ptr %slot.a, align 8
  %r2.p = getelementptr inbounds [7 x i8], ptr @.str.57, i64 0, i64 0
  %r2 = ptrtoint ptr %r2.p to i64
  %r3 = call i64 @nova_rt_index_get(i64 %r1, i64 %r2)
  %r4 = load i64, ptr %slot.g, align 8
  %r5.p = getelementptr inbounds [7 x i8], ptr @.str.57, i64 0, i64 0
  %r5 = ptrtoint ptr %r5.p to i64
  %_is.dv0 = call i64 @nova_rt_dict_set(i64 %r4, i64 %r5, i64 %r3)
  %r6 = load i64, ptr %slot.a, align 8
  %r7.p = getelementptr inbounds [4 x i8], ptr @.str.58, i64 0, i64 0
  %r7 = ptrtoint ptr %r7.p to i64
  %r8 = call i64 @nova_rt_index_get(i64 %r6, i64 %r7)
  %r9 = load i64, ptr %slot.g, align 8
  %r10.p = getelementptr inbounds [4 x i8], ptr @.str.58, i64 0, i64 0
  %r10 = ptrtoint ptr %r10.p to i64
  %_is.dv1 = call i64 @nova_rt_dict_set(i64 %r9, i64 %r10, i64 %r8)
  %r11 = load i64, ptr %slot.a, align 8
  %r12.p = getelementptr inbounds [8 x i8], ptr @.str.59, i64 0, i64 0
  %r12 = ptrtoint ptr %r12.p to i64
  %r13 = call i64 @nova_rt_index_get(i64 %r11, i64 %r12)
  %r14 = load i64, ptr %slot.g, align 8
  %r15.p = getelementptr inbounds [8 x i8], ptr @.str.59, i64 0, i64 0
  %r15 = ptrtoint ptr %r15.p to i64
  %_is.dv2 = call i64 @nova_rt_dict_set(i64 %r14, i64 %r15, i64 %r13)
  %r16 = load i64, ptr %slot.prefix, align 8
  %r17 = load i64, ptr %slot.g, align 8
  %r18.p = getelementptr inbounds [7 x i8], ptr @.str.60, i64 0, i64 0
  %r18 = ptrtoint ptr %r18.p to i64
  %_is.dv3 = call i64 @nova_rt_dict_set(i64 %r17, i64 %r18, i64 %r16)
  %r19 = load i64, ptr %slot.g, align 8
  ret i64 %r19
}

; ESCAPE _fr_route: allocs=1 escape=0 local=1
define i64 @_fr_route(i64 %p0, i64 %p1, i64 %p2, i64 %p3) nounwind uwtable {
entry:
  %slot.a = alloca i64, align 8
  store i64 %p0, ptr %slot.a, align 8
  %slot.method = alloca i64, align 8
  store i64 %p1, ptr %slot.method, align 8
  %slot.pattern = alloca i64, align 8
  store i64 %p2, ptr %slot.pattern, align 8
  %slot.handler = alloca i64, align 8
  store i64 %p3, ptr %slot.handler, align 8
  %slot.full = alloca i64, align 8
  store i64 0, ptr %slot.full, align 8
  %r0 = load i64, ptr %slot.pattern, align 8
  store i64 %r0, ptr %slot.full, align 8
  %r1 = load i64, ptr %slot.a, align 8
  %r2.p = getelementptr inbounds [7 x i8], ptr @.str.60, i64 0, i64 0
  %r2 = ptrtoint ptr %r2.p to i64
  %r3 = call i64 @nova_rt_contains(i64 %r1, i64 %r2)
  %br_then1500 = icmp ne i64 %r3, 0
  br i1 %br_then1500, label %then150, label %else151
then150:
  %r4 = load i64, ptr %slot.a, align 8
  %r5.p = getelementptr inbounds [7 x i8], ptr @.str.60, i64 0, i64 0
  %r5 = ptrtoint ptr %r5.p to i64
  %r6 = call i64 @nova_rt_index_get(i64 %r4, i64 %r5)
  %r7 = load i64, ptr %slot.pattern, align 8
  %r8 = call i64 @nova_rt_str_concat(i64 %r6, i64 %r7)
  store i64 %r8, ptr %slot.full, align 8
  br label %endif152
else151:
  br label %endif152
endif152:
  %r9 = load i64, ptr %slot.a, align 8
  %r10.p = getelementptr inbounds [7 x i8], ptr @.str.57, i64 0, i64 0
  %r10 = ptrtoint ptr %r10.p to i64
  %r11 = call i64 @nova_rt_index_get(i64 %r9, i64 %r10)
  %r13 = load i64, ptr %slot.method, align 8
  %r14 = load i64, ptr %slot.full, align 8
  %r15 = load i64, ptr %slot.handler, align 8
  %r12 = call i64 @nova_rt_list_create()
  call i64 @nova_rt_list_append(i64 %r12, i64 %r13)
  call i64 @nova_rt_list_append(i64 %r12, i64 %r14)
  call i64 @nova_rt_list_append(i64 %r12, i64 %r15)
  %r16 = call i64 @nova_rt_list_append(i64 %r11, i64 %r12)
  %r17 = load i64, ptr %slot.a, align 8
  ret i64 %r17
}

; ESCAPE get: allocs=0 escape=0 local=0
define i64 @get(i64 %p0, i64 %p1, i64 %p2) nounwind uwtable {
entry:
  %slot.a = alloca i64, align 8
  store i64 %p0, ptr %slot.a, align 8
  %slot.pattern = alloca i64, align 8
  store i64 %p1, ptr %slot.pattern, align 8
  %slot.handler = alloca i64, align 8
  store i64 %p2, ptr %slot.handler, align 8
  %r0 = load i64, ptr %slot.a, align 8
  %r1.p = getelementptr inbounds [4 x i8], ptr @.str.21, i64 0, i64 0
  %r1 = ptrtoint ptr %r1.p to i64
  %r2 = load i64, ptr %slot.pattern, align 8
  %r3 = load i64, ptr %slot.handler, align 8
  %r4 = call i64 @_fr_route(i64 %r0, i64 %r1, i64 %r2, i64 %r3)
  ret i64 %r4
}

; ESCAPE post: allocs=0 escape=0 local=0
define i64 @post(i64 %p0, i64 %p1, i64 %p2) nounwind uwtable {
entry:
  %slot.a = alloca i64, align 8
  store i64 %p0, ptr %slot.a, align 8
  %slot.pattern = alloca i64, align 8
  store i64 %p1, ptr %slot.pattern, align 8
  %slot.handler = alloca i64, align 8
  store i64 %p2, ptr %slot.handler, align 8
  %r0 = load i64, ptr %slot.a, align 8
  %r1.p = getelementptr inbounds [5 x i8], ptr @.str.61, i64 0, i64 0
  %r1 = ptrtoint ptr %r1.p to i64
  %r2 = load i64, ptr %slot.pattern, align 8
  %r3 = load i64, ptr %slot.handler, align 8
  %r4 = call i64 @_fr_route(i64 %r0, i64 %r1, i64 %r2, i64 %r3)
  ret i64 %r4
}

; ESCAPE put: allocs=0 escape=0 local=0
define i64 @put(i64 %p0, i64 %p1, i64 %p2) nounwind uwtable {
entry:
  %slot.a = alloca i64, align 8
  store i64 %p0, ptr %slot.a, align 8
  %slot.pattern = alloca i64, align 8
  store i64 %p1, ptr %slot.pattern, align 8
  %slot.handler = alloca i64, align 8
  store i64 %p2, ptr %slot.handler, align 8
  %r0 = load i64, ptr %slot.a, align 8
  %r1.p = getelementptr inbounds [4 x i8], ptr @.str.62, i64 0, i64 0
  %r1 = ptrtoint ptr %r1.p to i64
  %r2 = load i64, ptr %slot.pattern, align 8
  %r3 = load i64, ptr %slot.handler, align 8
  %r4 = call i64 @_fr_route(i64 %r0, i64 %r1, i64 %r2, i64 %r3)
  ret i64 %r4
}

; ESCAPE delete: allocs=0 escape=0 local=0
define i64 @delete(i64 %p0, i64 %p1, i64 %p2) nounwind uwtable {
entry:
  %slot.a = alloca i64, align 8
  store i64 %p0, ptr %slot.a, align 8
  %slot.pattern = alloca i64, align 8
  store i64 %p1, ptr %slot.pattern, align 8
  %slot.handler = alloca i64, align 8
  store i64 %p2, ptr %slot.handler, align 8
  %r0 = load i64, ptr %slot.a, align 8
  %r1.p = getelementptr inbounds [7 x i8], ptr @.str.63, i64 0, i64 0
  %r1 = ptrtoint ptr %r1.p to i64
  %r2 = load i64, ptr %slot.pattern, align 8
  %r3 = load i64, ptr %slot.handler, align 8
  %r4 = call i64 @_fr_route(i64 %r0, i64 %r1, i64 %r2, i64 %r3)
  ret i64 %r4
}

; ESCAPE patch: allocs=0 escape=0 local=0
define i64 @patch(i64 %p0, i64 %p1, i64 %p2) nounwind uwtable {
entry:
  %slot.a = alloca i64, align 8
  store i64 %p0, ptr %slot.a, align 8
  %slot.pattern = alloca i64, align 8
  store i64 %p1, ptr %slot.pattern, align 8
  %slot.handler = alloca i64, align 8
  store i64 %p2, ptr %slot.handler, align 8
  %r0 = load i64, ptr %slot.a, align 8
  %r1.p = getelementptr inbounds [6 x i8], ptr @.str.64, i64 0, i64 0
  %r1 = ptrtoint ptr %r1.p to i64
  %r2 = load i64, ptr %slot.pattern, align 8
  %r3 = load i64, ptr %slot.handler, align 8
  %r4 = call i64 @_fr_route(i64 %r0, i64 %r1, i64 %r2, i64 %r3)
  ret i64 %r4
}

; ESCAPE _fr_match: allocs=1 escape=0 local=1
define i64 @_fr_match(i64 %p0, i64 %p1) nounwind uwtable {
entry:
  %slot.pattern = alloca i64, align 8
  store i64 %p0, ptr %slot.pattern, align 8
  %slot.path = alloca i64, align 8
  store i64 %p1, ptr %slot.path, align 8
  %slot.pat_parts = alloca i64, align 8
  store i64 0, ptr %slot.pat_parts, align 8
  %slot.path_parts = alloca i64, align 8
  store i64 0, ptr %slot.path_parts, align 8
  %slot.params = alloca i64, align 8
  store i64 0, ptr %slot.params, align 8
  %slot.i = alloca i64, align 8
  store i64 0, ptr %slot.i, align 8
  %slot.pp = alloca i64, align 8
  store i64 0, ptr %slot.pp, align 8
  %slot.vp = alloca i64, align 8
  store i64 0, ptr %slot.vp, align 8
  %slot.__sc_159 = alloca i64, align 8
  store i64 0, ptr %slot.__sc_159, align 8
  %slot.pn = alloca i64, align 8
  store i64 0, ptr %slot.pn, align 8
  %r0 = load i64, ptr %slot.pattern, align 8
  %r1.p = getelementptr inbounds [2 x i8], ptr @.str.22, i64 0, i64 0
  %r1 = ptrtoint ptr %r1.p to i64
  %r2 = call i64 @nova_rt_split(i64 %r0, i64 %r1)
  store i64 %r2, ptr %slot.pat_parts, align 8
  %r3 = load i64, ptr %slot.path, align 8
  %r4.p = getelementptr inbounds [2 x i8], ptr @.str.22, i64 0, i64 0
  %r4 = ptrtoint ptr %r4.p to i64
  %r5 = call i64 @nova_rt_split(i64 %r3, i64 %r4)
  store i64 %r5, ptr %slot.path_parts, align 8
  %r6 = load i64, ptr %slot.pat_parts, align 8
  %r7.lp = inttoptr i64 %r6 to ptr
  %r7.szp = getelementptr i64, ptr %r7.lp, i64 1
  %r7 = load i64, ptr %r7.szp, align 8, !tbaa !6
  %r8 = load i64, ptr %slot.path_parts, align 8
  %r9.lp = inttoptr i64 %r8 to ptr
  %r9.szp = getelementptr i64, ptr %r9.lp, i64 1
  %r9 = load i64, ptr %r9.szp, align 8, !tbaa !6
  %r10.cmp = icmp ne i64 %r7, %r9
  %r10 = zext i1 %r10.cmp to i64
  %br_then1530 = icmp ne i64 %r10, 0
  br i1 %br_then1530, label %then153, label %else154
then153:
  %r11.p = getelementptr inbounds [16 x i8], ptr @.str.65, i64 0, i64 0
  %r11 = ptrtoint ptr %r11.p to i64
  %r12 = call i64 @nova_rt_err(i64 %r11)
  ret i64 %r12
else154:
  br label %endif155
endif155:
  %r13 = call i64 @nova_rt_dict_create()
  store i64 %r13, ptr %slot.params, align 8
  %r14 = add i64 0, 0
  store i64 %r14, ptr %slot.i, align 8
  br label %while_hdr156
while_hdr156:
  %r15 = load i64, ptr %slot.i, align 8
  %r16 = load i64, ptr %slot.pat_parts, align 8
  %r17.lp = inttoptr i64 %r16 to ptr
  %r17.szp = getelementptr i64, ptr %r17.lp, i64 1
  %r17 = load i64, ptr %r17.szp, align 8, !tbaa !6
  %r18.cmp = icmp slt i64 %r15, %r17
  %r18 = zext i1 %r18.cmp to i64
  %br_while_body1571 = icmp ne i64 %r18, 0
  br i1 %br_while_body1571, label %while_body157, label %while_exit158, !prof !90
while_body157:
  %r19 = load i64, ptr %slot.pat_parts, align 8
  %r20 = load i64, ptr %slot.i, align 8
  %r21 = call i64 @nova_rt_index_get(i64 %r19, i64 %r20)
  store i64 %r21, ptr %slot.pp, align 8
  %r22 = load i64, ptr %slot.path_parts, align 8
  %r23 = load i64, ptr %slot.i, align 8
  %r24 = call i64 @nova_rt_index_get(i64 %r22, i64 %r23)
  store i64 %r24, ptr %slot.vp, align 8
  %r25 = load i64, ptr %slot.pp, align 8
  %r26 = call i64 @nova_rt_len_any(i64 %r25)
  %r27 = add i64 0, 0
  %r28.cmp = icmp sgt i64 %r26, %r27
  %r28 = zext i1 %r28.cmp to i64
  store i64 %r28, ptr %slot.__sc_159, align 8
  %br_and_rhs1602 = icmp ne i64 %r28, 0
  br i1 %br_and_rhs1602, label %and_rhs160, label %and_merge161
and_rhs160:
  %r29 = load i64, ptr %slot.pp, align 8
  %r30.p = getelementptr inbounds [2 x i8], ptr @.str.66, i64 0, i64 0
  %r30 = ptrtoint ptr %r30.p to i64
  %r31 = call i64 @nova_rt_starts_with(i64 %r29, i64 %r30)
  store i64 %r31, ptr %slot.__sc_159, align 8
  br label %and_merge161
and_merge161:
  %r32 = load i64, ptr %slot.__sc_159, align 8
  %br_then1623 = icmp ne i64 %r32, 0
  br i1 %br_then1623, label %then162, label %else163
then162:
  %r33 = load i64, ptr %slot.pp, align 8
  %r34 = add i64 1, 0
  %r35 = load i64, ptr %slot.pp, align 8
  %r36 = call i64 @nova_rt_len_any(i64 %r35)
  %r37 = call i64 @nova_rt_slice(i64 %r33, i64 %r34, i64 %r36)
  store i64 %r37, ptr %slot.pn, align 8
  %r38 = load i64, ptr %slot.vp, align 8
  %r39 = load i64, ptr %slot.params, align 8
  %r40 = load i64, ptr %slot.pn, align 8
  %_is.dv4 = call i64 @nova_rt_dict_set_no_rc(i64 %r39, i64 %r40, i64 %r38)
  br label %endif164
else163:
  %r41 = load i64, ptr %slot.pp, align 8
  %r42 = load i64, ptr %slot.vp, align 8
  %r43 = call i64 @nova_rt_neq(i64 %r41, i64 %r42)
  %br_then1655 = icmp ne i64 %r43, 0
  br i1 %br_then1655, label %then165, label %else166
then165:
  %r44.p = getelementptr inbounds [9 x i8], ptr @.str.67, i64 0, i64 0
  %r44 = ptrtoint ptr %r44.p to i64
  %r45 = call i64 @nova_rt_err(i64 %r44)
  ret i64 %r45
else166:
  br label %endif167
endif167:
  br label %endif164
endif164:
  %r46 = load i64, ptr %slot.i, align 8
  %r47 = add i64 1, 0
  %r48 = add i64 %r46, %r47
  store i64 %r48, ptr %slot.i, align 8
  br label %while_hdr156
while_exit158:
  %r49 = load i64, ptr %slot.params, align 8
  %r50 = call i64 @nova_rt_ok(i64 %r49)
  ret i64 %r50
}

; ESCAPE _fr_path_clean: allocs=0 escape=0 local=0
define i64 @_fr_path_clean(i64 %p0) nounwind uwtable {
entry:
  %slot.path = alloca i64, align 8
  store i64 %p0, ptr %slot.path, align 8
  %slot.q = alloca i64, align 8
  store i64 0, ptr %slot.q, align 8
  %r0 = load i64, ptr %slot.path, align 8
  %r1.p = getelementptr inbounds [2 x i8], ptr @.str.25, i64 0, i64 0
  %r1 = ptrtoint ptr %r1.p to i64
  %r2 = call i64 @nova_rt_find(i64 %r0, i64 %r1)
  store i64 %r2, ptr %slot.q, align 8
  %r3 = load i64, ptr %slot.q, align 8
  %r4 = add i64 0, 0
  %r5.cmp = icmp slt i64 %r3, %r4
  %r5 = zext i1 %r5.cmp to i64
  %br_then1680 = icmp ne i64 %r5, 0
  br i1 %br_then1680, label %then168, label %else169
then168:
  %r6 = load i64, ptr %slot.path, align 8
  ret i64 %r6
else169:
  br label %endif170
endif170:
  %r7 = load i64, ptr %slot.path, align 8
  %r8 = add i64 0, 0
  %r9 = load i64, ptr %slot.q, align 8
  %r10 = call i64 @nova_rt_slice(i64 %r7, i64 %r8, i64 %r9)
  ret i64 %r10
}

; ESCAPE _fr_route_dispatch: allocs=0 escape=0 local=0
define i64 @_fr_route_dispatch(i64 %p0, i64 %p1) nounwind uwtable {
entry:
  %slot.a = alloca i64, align 8
  store i64 %p0, ptr %slot.a, align 8
  %slot.req = alloca i64, align 8
  store i64 %p1, ptr %slot.req, align 8
  %slot.routes = alloca i64, align 8
  store i64 0, ptr %slot.routes, align 8
  %slot.other = alloca i64, align 8
  store i64 0, ptr %slot.other, align 8
  %slot.i = alloca i64, align 8
  store i64 0, ptr %slot.i, align 8
  %slot.rt = alloca i64, align 8
  store i64 0, ptr %slot.rt, align 8
  %slot.mr = alloca i64, align 8
  store i64 0, ptr %slot.mr, align 8
  %slot.__sc_177 = alloca i64, align 8
  store i64 0, ptr %slot.__sc_177, align 8
  %slot.h = alloca i64, align 8
  store i64 0, ptr %slot.h, align 8
  %r0 = load i64, ptr %slot.a, align 8
  %r1.p = getelementptr inbounds [7 x i8], ptr @.str.57, i64 0, i64 0
  %r1 = ptrtoint ptr %r1.p to i64
  %r2 = call i64 @nova_rt_index_get(i64 %r0, i64 %r1)
  store i64 %r2, ptr %slot.routes, align 8
  %r3 = add i64 0, 0
  store i64 %r3, ptr %slot.other, align 8
  %r4 = add i64 0, 0
  store i64 %r4, ptr %slot.i, align 8
  br label %while_hdr171
while_hdr171:
  %r5 = load i64, ptr %slot.i, align 8
  %r6 = load i64, ptr %slot.routes, align 8
  %r7 = call i64 @nova_rt_len_any(i64 %r6)
  %r8.cmp = icmp slt i64 %r5, %r7
  %r8 = zext i1 %r8.cmp to i64
  %br_while_body1720 = icmp ne i64 %r8, 0
  br i1 %br_while_body1720, label %while_body172, label %while_exit173, !prof !90
while_body172:
  %r9 = load i64, ptr %slot.routes, align 8
  %r10 = load i64, ptr %slot.i, align 8
  %r11 = call i64 @nova_rt_index_get(i64 %r9, i64 %r10)
  store i64 %r11, ptr %slot.rt, align 8
  %r12 = load i64, ptr %slot.rt, align 8
  %r13 = add i64 1, 0
  %r14 = call i64 @nova_rt_index_get(i64 %r12, i64 %r13)
  %r15 = load i64, ptr %slot.req, align 8
  %r16.p = getelementptr inbounds [5 x i8], ptr @.str.68, i64 0, i64 0
  %r16 = ptrtoint ptr %r16.p to i64
  %r17 = call i64 @nova_rt_index_get(i64 %r15, i64 %r16)
  %r18 = call i64 @_fr_match(i64 %r14, i64 %r17)
  store i64 %r18, ptr %slot.mr, align 8
  %r19 = load i64, ptr %slot.mr, align 8
  %r20 = call i64 @nova_rt_is_ok(i64 %r19)
  %br_then1741 = icmp ne i64 %r20, 0
  br i1 %br_then1741, label %then174, label %else175
then174:
  %r21 = load i64, ptr %slot.rt, align 8
  %r22 = add i64 0, 0
  %r23 = call i64 @nova_rt_index_get(i64 %r21, i64 %r22)
  %r24 = load i64, ptr %slot.req, align 8
  %r25.p = getelementptr inbounds [7 x i8], ptr @.str.69, i64 0, i64 0
  %r25 = ptrtoint ptr %r25.p to i64
  %r26 = call i64 @nova_rt_index_get(i64 %r24, i64 %r25)
  %r27 = call i64 @nova_rt_eq(i64 %r23, i64 %r26)
  store i64 %r27, ptr %slot.__sc_177, align 8
  %br_or_merge1792 = icmp ne i64 %r27, 0
  br i1 %br_or_merge1792, label %or_merge179, label %or_rhs178
or_rhs178:
  %r28 = load i64, ptr %slot.rt, align 8
  %r29 = add i64 0, 0
  %r30 = call i64 @nova_rt_index_get(i64 %r28, i64 %r29)
  %r31.p = getelementptr inbounds [2 x i8], ptr @.str.70, i64 0, i64 0
  %r31 = ptrtoint ptr %r31.p to i64
  %r32.p0 = inttoptr i64 %r30 to ptr
  %r32.p1 = inttoptr i64 %r31 to ptr
  %r32.sc = call i32 @strcmp(ptr %r32.p0, ptr %r32.p1)
  %r32.cmp = icmp eq i32 %r32.sc, 0
  %r32 = zext i1 %r32.cmp to i64
  store i64 %r32, ptr %slot.__sc_177, align 8
  br label %or_merge179
or_merge179:
  %r33 = load i64, ptr %slot.__sc_177, align 8
  %br_then1803 = icmp ne i64 %r33, 0
  br i1 %br_then1803, label %then180, label %else181
then180:
  %r34 = load i64, ptr %slot.mr, align 8
  %r35 = call i64 @nova_rt_unwrap(i64 %r34)
  %r36 = load i64, ptr %slot.req, align 8
  %r37.p = getelementptr inbounds [7 x i8], ptr @.str.71, i64 0, i64 0
  %r37 = ptrtoint ptr %r37.p to i64
  %_is.gv4 = call i64 @nova_rt_index_set(i64 %r36, i64 %r37, i64 %r35)
  %r38 = load i64, ptr %slot.rt, align 8
  %r39 = add i64 2, 0
  %r40 = call i64 @nova_rt_index_get(i64 %r38, i64 %r39)
  store i64 %r40, ptr %slot.h, align 8
  %r41 = load i64, ptr %slot.req, align 8
  %r43 = load i64, ptr %slot.h, align 8
  %r42.rec = inttoptr i64 %r43 to ptr
  %r42.fnraw = load i64, ptr %r42.rec, align 8
  %r42.fnptr = inttoptr i64 %r42.fnraw to ptr
  %r42 = call i64 %r42.fnptr(i64 %r43, i64 %r41)
  ret i64 %r42
else181:
  %r44 = add i64 1, 0
  store i64 %r44, ptr %slot.other, align 8
  br label %endif182
endif182:
  br label %endif176
else175:
  br label %endif176
endif176:
  %r45 = load i64, ptr %slot.i, align 8
  %r46 = add i64 1, 0
  %r47 = add i64 %r45, %r46
  store i64 %r47, ptr %slot.i, align 8
  br label %while_hdr171
while_exit173:
  %r48 = load i64, ptr %slot.other, align 8
  %r49 = add i64 1, 0
  %r50.cmp = icmp eq i64 %r48, %r49
  %r50 = zext i1 %r50.cmp to i64
  %br_then1835 = icmp ne i64 %r50, 0
  br i1 %br_then1835, label %then183, label %else184
then183:
  %r51 = add i64 405, 0
  %r52.p = getelementptr inbounds [19 x i8], ptr @.str.72, i64 0, i64 0
  %r52 = ptrtoint ptr %r52.p to i64
  %r53 = call i64 @text(i64 %r51, i64 %r52)
  ret i64 %r53
else184:
  br label %endif185
endif185:
  %r54.p = getelementptr inbounds [11 x i8], ptr @.str.73, i64 0, i64 0
  %r54 = ptrtoint ptr %r54.p to i64
  %r55 = load i64, ptr %slot.req, align 8
  %r56.p = getelementptr inbounds [7 x i8], ptr @.str.69, i64 0, i64 0
  %r56 = ptrtoint ptr %r56.p to i64
  %r57 = call i64 @nova_rt_index_get(i64 %r55, i64 %r56)
  %r58 = call i64 @nova_rt_str_concat(i64 %r54, i64 %r57)
  %r59.p = getelementptr inbounds [2 x i8], ptr @.str.20, i64 0, i64 0
  %r59 = ptrtoint ptr %r59.p to i64
  %r60 = call i64 @nova_rt_str_concat(i64 %r58, i64 %r59)
  %r61 = load i64, ptr %slot.req, align 8
  %r62.p = getelementptr inbounds [5 x i8], ptr @.str.68, i64 0, i64 0
  %r62 = ptrtoint ptr %r62.p to i64
  %r63 = call i64 @nova_rt_index_get(i64 %r61, i64 %r62)
  %r64 = call i64 @nova_rt_str_concat(i64 %r60, i64 %r63)
  %r65 = call i64 @not_found(i64 %r64)
  ret i64 %r65
}

; ESCAPE dispatch: allocs=2 escape=1 local=1
define i64 @dispatch(i64 %p0, i64 %p1, i64 %p2, i64 %p3) nounwind uwtable {
entry:
  %slot.a = alloca i64, align 8
  store i64 %p0, ptr %slot.a, align 8
  %slot.method = alloca i64, align 8
  store i64 %p1, ptr %slot.method, align 8
  %slot.path = alloca i64, align 8
  store i64 %p2, ptr %slot.path, align 8
  %slot.body = alloca i64, align 8
  store i64 %p3, ptr %slot.body, align 8
  %slot.req = alloca i64, align 8
  store i64 0, ptr %slot.req, align 8
  %slot.h = alloca i64, align 8
  store i64 0, ptr %slot.h, align 8
  %slot.mws = alloca i64, align 8
  store i64 0, ptr %slot.mws, align 8
  %slot.i = alloca i64, align 8
  store i64 0, ptr %slot.i, align 8
  %r0 = call i64 @nova_rt_dict_create()
  store i64 %r0, ptr %slot.req, align 8
  %r1 = load i64, ptr %slot.method, align 8
  %r2 = load i64, ptr %slot.req, align 8
  %r3.p = getelementptr inbounds [7 x i8], ptr @.str.69, i64 0, i64 0
  %r3 = ptrtoint ptr %r3.p to i64
  %_is.dv0 = call i64 @nova_rt_dict_set_no_rc(i64 %r2, i64 %r3, i64 %r1)
  %r4 = load i64, ptr %slot.path, align 8
  %r5 = call i64 @_fr_path_clean(i64 %r4)
  %r6 = load i64, ptr %slot.req, align 8
  %r7.p = getelementptr inbounds [5 x i8], ptr @.str.68, i64 0, i64 0
  %r7 = ptrtoint ptr %r7.p to i64
  %_is.dv1 = call i64 @nova_rt_dict_set_no_rc(i64 %r6, i64 %r7, i64 %r5)
  %r8 = load i64, ptr %slot.body, align 8
  %r9 = load i64, ptr %slot.req, align 8
  %r10.p = getelementptr inbounds [5 x i8], ptr @.str.74, i64 0, i64 0
  %r10 = ptrtoint ptr %r10.p to i64
  %_is.dv2 = call i64 @nova_rt_dict_set_no_rc(i64 %r9, i64 %r10, i64 %r8)
  %r11 = call i64 @nova_rt_dict_create()
  %r12 = load i64, ptr %slot.req, align 8
  %r13.p = getelementptr inbounds [7 x i8], ptr @.str.71, i64 0, i64 0
  %r13 = ptrtoint ptr %r13.p to i64
  %_is.dv3 = call i64 @nova_rt_dict_set_no_rc(i64 %r12, i64 %r13, i64 %r11)
  %r14 = load i64, ptr %slot.a, align 8
  %r15.ptr = call ptr @nova_rt_struct_alloc(i64 16)
  %r15.tgep = getelementptr i64, ptr %r15.ptr, i64 0
  %r15.tfn = ptrtoint ptr @__tramp_0 to i64
  store i64 %r15.tfn, ptr %r15.tgep, align 8
  %r15.c0 = getelementptr i64, ptr %r15.ptr, i64 1
  store i64 %r14, ptr %r15.c0, align 8
  %r15 = ptrtoint ptr %r15.ptr to i64
  store i64 %r15, ptr %slot.h, align 8
  %r16 = load i64, ptr %slot.a, align 8
  %r17.p = getelementptr inbounds [4 x i8], ptr @.str.58, i64 0, i64 0
  %r17 = ptrtoint ptr %r17.p to i64
  %r18 = call i64 @nova_rt_index_get(i64 %r16, i64 %r17)
  store i64 %r18, ptr %slot.mws, align 8
  %r19 = load i64, ptr %slot.mws, align 8
  %r20 = call i64 @nova_rt_len_any(i64 %r19)
  %r21 = add i64 1, 0
  %r22 = sub i64 %r20, %r21
  store i64 %r22, ptr %slot.i, align 8
  br label %while_hdr186
while_hdr186:
  %r23 = load i64, ptr %slot.i, align 8
  %r24 = add i64 0, 0
  %r25.cmp = icmp sge i64 %r23, %r24
  %r25 = zext i1 %r25.cmp to i64
  %br_while_body1874 = icmp ne i64 %r25, 0
  br i1 %br_while_body1874, label %while_body187, label %while_exit188, !prof !90
while_body187:
  %r26 = load i64, ptr %slot.mws, align 8
  %r27 = load i64, ptr %slot.i, align 8
  %r28 = call i64 @nova_rt_index_get(i64 %r26, i64 %r27)
  %r29 = load i64, ptr %slot.h, align 8
  %r30 = call i64 @_fr_wrap(i64 %r28, i64 %r29)
  store i64 %r30, ptr %slot.h, align 8
  %r31 = load i64, ptr %slot.i, align 8
  %r32 = add i64 1, 0
  %r33 = sub i64 %r31, %r32
  store i64 %r33, ptr %slot.i, align 8
  br label %while_hdr186
while_exit188:
  %r34 = load i64, ptr %slot.req, align 8
  %r36 = load i64, ptr %slot.h, align 8
  %r35.rec = inttoptr i64 %r36 to ptr
  %r35.fnraw = load i64, ptr %r35.rec, align 8
  %r35.fnptr = inttoptr i64 %r35.fnraw to ptr
  %r35 = call i64 %r35.fnptr(i64 %r36, i64 %r34)
  ret i64 %r35
}

; ESCAPE serve_app_n: allocs=0 escape=0 local=0
define i64 @serve_app_n(i64 %p0, i64 %p1, i64 %p2) nounwind uwtable {
entry:
  %slot.a = alloca i64, align 8
  store i64 %p0, ptr %slot.a, align 8
  %slot.port = alloca i64, align 8
  store i64 %p1, ptr %slot.port, align 8
  %slot.n = alloca i64, align 8
  store i64 %p2, ptr %slot.n, align 8
  %r0 = load i64, ptr %slot.port, align 8
  %r1 = load i64, ptr %slot.a, align 8
  %r2.ptr = call ptr @nova_rt_struct_alloc(i64 16)
  %r2.tgep = getelementptr i64, ptr %r2.ptr, i64 0
  %r2.tfn = ptrtoint ptr @__tramp_1 to i64
  store i64 %r2.tfn, ptr %r2.tgep, align 8
  %r2.c0 = getelementptr i64, ptr %r2.ptr, i64 1
  store i64 %r1, ptr %r2.c0, align 8
  %r2 = ptrtoint ptr %r2.ptr to i64
  %r3 = load i64, ptr %slot.n, align 8
  %r4 = call i64 @serve_n_arena(i64 %r0, i64 %r2, i64 %r3)
  ret i64 %r4
}

; ESCAPE serve_app: allocs=0 escape=0 local=0
define i64 @serve_app(i64 %p0, i64 %p1) nounwind uwtable {
entry:
  %slot.a = alloca i64, align 8
  store i64 %p0, ptr %slot.a, align 8
  %slot.port = alloca i64, align 8
  store i64 %p1, ptr %slot.port, align 8
  %r0 = load i64, ptr %slot.port, align 8
  %r1 = load i64, ptr %slot.a, align 8
  %r2.ptr = call ptr @nova_rt_struct_alloc(i64 16)
  %r2.tgep = getelementptr i64, ptr %r2.ptr, i64 0
  %r2.tfn = ptrtoint ptr @__tramp_2 to i64
  store i64 %r2.tfn, ptr %r2.tgep, align 8
  %r2.c0 = getelementptr i64, ptr %r2.ptr, i64 1
  store i64 %r1, ptr %r2.c0, align 8
  %r2 = ptrtoint ptr %r2.ptr to i64
  %r3 = call i64 @serve_arena(i64 %r0, i64 %r2)
  ret i64 %r3
}

; ESCAPE _fr_wrap: allocs=0 escape=0 local=0
define i64 @_fr_wrap(i64 %p0, i64 %p1) nounwind uwtable {
entry:
  %slot.mw = alloca i64, align 8
  store i64 %p0, ptr %slot.mw, align 8
  %slot.next = alloca i64, align 8
  store i64 %p1, ptr %slot.next, align 8
  %r0 = load i64, ptr %slot.mw, align 8
  %r1 = load i64, ptr %slot.next, align 8
  %r2.ptr = call ptr @nova_rt_struct_alloc(i64 24)
  %r2.tgep = getelementptr i64, ptr %r2.ptr, i64 0
  %r2.tfn = ptrtoint ptr @__tramp_3 to i64
  store i64 %r2.tfn, ptr %r2.tgep, align 8
  %r2.c0 = getelementptr i64, ptr %r2.ptr, i64 1
  store i64 %r0, ptr %r2.c0, align 8
  %r2.c1 = getelementptr i64, ptr %r2.ptr, i64 2
  store i64 %r1, ptr %r2.c1, align 8
  %r2 = ptrtoint ptr %r2.ptr to i64
  ret i64 %r2
}

; ESCAPE _fr_add_header: allocs=0 escape=0 local=0
define i64 @_fr_add_header(i64 %p0, i64 %p1, i64 %p2) nounwind uwtable {
entry:
  %slot.resp = alloca i64, align 8
  store i64 %p0, ptr %slot.resp, align 8
  %slot.name = alloca i64, align 8
  store i64 %p1, ptr %slot.name, align 8
  %slot.value = alloca i64, align 8
  store i64 %p2, ptr %slot.value, align 8
  %slot.marker = alloca i64, align 8
  store i64 0, ptr %slot.marker, align 8
  %slot.i = alloca i64, align 8
  store i64 0, ptr %slot.i, align 8
  %slot.head = alloca i64, align 8
  store i64 0, ptr %slot.head, align 8
  %slot.body = alloca i64, align 8
  store i64 0, ptr %slot.body, align 8
  %r0.p = getelementptr inbounds [5 x i8], ptr @.str.23, i64 0, i64 0
  %r0 = ptrtoint ptr %r0.p to i64
  store i64 %r0, ptr %slot.marker, align 8
  %r1 = load i64, ptr %slot.resp, align 8
  %r2 = load i64, ptr %slot.marker, align 8
  %r3 = call i64 @nova_rt_find(i64 %r1, i64 %r2)
  store i64 %r3, ptr %slot.i, align 8
  %r4 = load i64, ptr %slot.i, align 8
  %r5 = add i64 0, 0
  %r6.cmp = icmp slt i64 %r4, %r5
  %r6 = zext i1 %r6.cmp to i64
  %br_then1890 = icmp ne i64 %r6, 0
  br i1 %br_then1890, label %then189, label %else190
then189:
  %r7 = load i64, ptr %slot.resp, align 8
  ret i64 %r7
else190:
  br label %endif191
endif191:
  %r8 = load i64, ptr %slot.resp, align 8
  %r9 = add i64 0, 0
  %r10 = load i64, ptr %slot.i, align 8
  %r11 = call i64 @nova_rt_slice(i64 %r8, i64 %r9, i64 %r10)
  store i64 %r11, ptr %slot.head, align 8
  %r12 = load i64, ptr %slot.resp, align 8
  %r13 = load i64, ptr %slot.i, align 8
  %r14 = add i64 4, 0
  %r15 = add i64 %r13, %r14
  %r16 = load i64, ptr %slot.resp, align 8
  %r17 = call i64 @nova_rt_len_any(i64 %r16)
  %r18 = call i64 @nova_rt_slice(i64 %r12, i64 %r15, i64 %r17)
  store i64 %r18, ptr %slot.body, align 8
  %r19 = load i64, ptr %slot.head, align 8
  %r20.p = getelementptr inbounds [3 x i8], ptr @.str.12, i64 0, i64 0
  %r20 = ptrtoint ptr %r20.p to i64
  %r21 = call i64 @nova_rt_str_concat(i64 %r19, i64 %r20)
  %r22 = load i64, ptr %slot.name, align 8
  %r23 = call i64 @nova_rt_str_concat(i64 %r21, i64 %r22)
  %r24.p = getelementptr inbounds [3 x i8], ptr @.str.28, i64 0, i64 0
  %r24 = ptrtoint ptr %r24.p to i64
  %r25 = call i64 @nova_rt_str_concat(i64 %r23, i64 %r24)
  %r26 = load i64, ptr %slot.value, align 8
  %r27 = call i64 @nova_rt_str_concat(i64 %r25, i64 %r26)
  %r28 = load i64, ptr %slot.marker, align 8
  %r29 = call i64 @nova_rt_str_concat(i64 %r27, i64 %r28)
  %r30 = load i64, ptr %slot.body, align 8
  %r31 = call i64 @nova_rt_str_concat(i64 %r29, i64 %r30)
  ret i64 %r31
}

; ESCAPE mw_cors: allocs=0 escape=0 local=0
define i64 @mw_cors(i64 %p0) nounwind uwtable {
entry:
  %slot.origin = alloca i64, align 8
  store i64 %p0, ptr %slot.origin, align 8
  %r0 = load i64, ptr %slot.origin, align 8
  %r1.ptr = call ptr @nova_rt_struct_alloc(i64 16)
  %r1.tgep = getelementptr i64, ptr %r1.ptr, i64 0
  %r1.tfn = ptrtoint ptr @__tramp_4 to i64
  store i64 %r1.tfn, ptr %r1.tgep, align 8
  %r1.c0 = getelementptr i64, ptr %r1.ptr, i64 1
  store i64 %r0, ptr %r1.c0, align 8
  %r1 = ptrtoint ptr %r1.ptr to i64
  ret i64 %r1
}

; ESCAPE mw_header: allocs=0 escape=0 local=0
define i64 @mw_header(i64 %p0, i64 %p1) nounwind uwtable {
entry:
  %slot.name = alloca i64, align 8
  store i64 %p0, ptr %slot.name, align 8
  %slot.value = alloca i64, align 8
  store i64 %p1, ptr %slot.value, align 8
  %r0 = load i64, ptr %slot.name, align 8
  %r1 = load i64, ptr %slot.value, align 8
  %r2.ptr = call ptr @nova_rt_struct_alloc(i64 24)
  %r2.tgep = getelementptr i64, ptr %r2.ptr, i64 0
  %r2.tfn = ptrtoint ptr @__tramp_5 to i64
  store i64 %r2.tfn, ptr %r2.tgep, align 8
  %r2.c0 = getelementptr i64, ptr %r2.ptr, i64 1
  store i64 %r0, ptr %r2.c0, align 8
  %r2.c1 = getelementptr i64, ptr %r2.ptr, i64 2
  store i64 %r1, ptr %r2.c1, align 8
  %r2 = ptrtoint ptr %r2.ptr to i64
  ret i64 %r2
}

; ESCAPE _fr_log_next: allocs=0 escape=0 local=0
define i64 @_fr_log_next(i64 %p0, i64 %p1) nounwind uwtable {
entry:
  %slot.req = alloca i64, align 8
  store i64 %p0, ptr %slot.req, align 8
  %slot.next = alloca i64, align 8
  store i64 %p1, ptr %slot.next, align 8
  %r0.p = getelementptr inbounds [9 x i8], ptr @.str.75, i64 0, i64 0
  %r0 = ptrtoint ptr %r0.p to i64
  %r1 = load i64, ptr %slot.req, align 8
  %r2.p = getelementptr inbounds [7 x i8], ptr @.str.69, i64 0, i64 0
  %r2 = ptrtoint ptr %r2.p to i64
  %r3 = call i64 @nova_rt_index_get(i64 %r1, i64 %r2)
  %r4 = call i64 @nova_rt_str_concat(i64 %r0, i64 %r3)
  %r5.p = getelementptr inbounds [2 x i8], ptr @.str.20, i64 0, i64 0
  %r5 = ptrtoint ptr %r5.p to i64
  %r6 = call i64 @nova_rt_str_concat(i64 %r4, i64 %r5)
  %r7 = load i64, ptr %slot.req, align 8
  %r8.p = getelementptr inbounds [5 x i8], ptr @.str.68, i64 0, i64 0
  %r8 = ptrtoint ptr %r8.p to i64
  %r9 = call i64 @nova_rt_index_get(i64 %r7, i64 %r8)
  %r10 = call i64 @nova_rt_str_concat(i64 %r6, i64 %r9)
  %r11 = call i64 @nova_rt_print_str(i64 %r10)
  %r12 = load i64, ptr %slot.req, align 8
  %r14 = load i64, ptr %slot.next, align 8
  %r13.rec = inttoptr i64 %r14 to ptr
  %r13.fnraw = load i64, ptr %r13.rec, align 8
  %r13.fnptr = inttoptr i64 %r13.fnraw to ptr
  %r13 = call i64 %r13.fnptr(i64 %r14, i64 %r12)
  ret i64 %r13
}

; ESCAPE mw_logger: allocs=0 escape=0 local=0
define i64 @mw_logger() nounwind uwtable {
entry:
  %r0.ptr = call ptr @nova_rt_struct_alloc(i64 8)
  %r0.tgep = getelementptr i64, ptr %r0.ptr, i64 0
  %r0.tfn = ptrtoint ptr @__tramp_6 to i64
  store i64 %r0.tfn, ptr %r0.tgep, align 8
  %r0 = ptrtoint ptr %r0.ptr to i64
  ret i64 %r0
}

; ESCAPE body_json: allocs=0 escape=0 local=0
define i64 @body_json(i64 %p0) nounwind uwtable {
entry:
  %slot.req = alloca i64, align 8
  store i64 %p0, ptr %slot.req, align 8
  %r0 = load i64, ptr %slot.req, align 8
  %r1.p = getelementptr inbounds [5 x i8], ptr @.str.74, i64 0, i64 0
  %r1 = ptrtoint ptr %r1.p to i64
  %r2 = call i64 @nova_rt_index_get(i64 %r0, i64 %r1)
  %r3 = call i64 @nova_rt_json_decode(i64 %r2)
  ret i64 %r3
}

; ESCAPE form_decode: allocs=1 escape=1 local=0
define i64 @form_decode(i64 %p0) nounwind uwtable {
entry:
  %slot.s = alloca i64, align 8
  store i64 %p0, ptr %slot.s, align 8
  %slot.d = alloca i64, align 8
  store i64 0, ptr %slot.d, align 8
  %slot.pairs = alloca i64, align 8
  store i64 0, ptr %slot.pairs, align 8
  %slot.i = alloca i64, align 8
  store i64 0, ptr %slot.i, align 8
  %slot.kv = alloca i64, align 8
  store i64 0, ptr %slot.kv, align 8
  %slot.eq = alloca i64, align 8
  store i64 0, ptr %slot.eq, align 8
  %r0 = call i64 @nova_rt_dict_create()
  store i64 %r0, ptr %slot.d, align 8
  %r1 = load i64, ptr %slot.s, align 8
  %r2 = call i64 @nova_rt_len_any(i64 %r1)
  %r3 = add i64 0, 0
  %r4.cmp = icmp eq i64 %r2, %r3
  %r4 = zext i1 %r4.cmp to i64
  %br_then1920 = icmp ne i64 %r4, 0
  br i1 %br_then1920, label %then192, label %else193
then192:
  %r5 = load i64, ptr %slot.d, align 8
  ret i64 %r5
else193:
  br label %endif194
endif194:
  %r6 = load i64, ptr %slot.s, align 8
  %r7.p = getelementptr inbounds [2 x i8], ptr @.str.27, i64 0, i64 0
  %r7 = ptrtoint ptr %r7.p to i64
  %r8 = call i64 @nova_rt_split(i64 %r6, i64 %r7)
  store i64 %r8, ptr %slot.pairs, align 8
  %r9 = add i64 0, 0
  store i64 %r9, ptr %slot.i, align 8
  br label %while_hdr195
while_hdr195:
  %r10 = load i64, ptr %slot.i, align 8
  %r11 = load i64, ptr %slot.pairs, align 8
  %r12.lp = inttoptr i64 %r11 to ptr
  %r12.szp = getelementptr i64, ptr %r12.lp, i64 1
  %r12 = load i64, ptr %r12.szp, align 8, !tbaa !6
  %r13.cmp = icmp slt i64 %r10, %r12
  %r13 = zext i1 %r13.cmp to i64
  %br_while_body1961 = icmp ne i64 %r13, 0
  br i1 %br_while_body1961, label %while_body196, label %while_exit197, !prof !90
while_body196:
  %r14 = load i64, ptr %slot.pairs, align 8
  %r15 = load i64, ptr %slot.i, align 8
  %r16 = call i64 @nova_rt_index_get(i64 %r14, i64 %r15)
  store i64 %r16, ptr %slot.kv, align 8
  %r17 = load i64, ptr %slot.kv, align 8
  %r18.p = getelementptr inbounds [2 x i8], ptr @.str.26, i64 0, i64 0
  %r18 = ptrtoint ptr %r18.p to i64
  %r19 = call i64 @nova_rt_find(i64 %r17, i64 %r18)
  store i64 %r19, ptr %slot.eq, align 8
  %r20 = load i64, ptr %slot.eq, align 8
  %r21 = add i64 0, 0
  %r22.cmp = icmp sge i64 %r20, %r21
  %r22 = zext i1 %r22.cmp to i64
  %br_then1982 = icmp ne i64 %r22, 0
  br i1 %br_then1982, label %then198, label %else199
then198:
  %r23 = load i64, ptr %slot.kv, align 8
  %r24 = load i64, ptr %slot.eq, align 8
  %r25 = add i64 1, 0
  %r26 = add i64 %r24, %r25
  %r27 = load i64, ptr %slot.kv, align 8
  %r28 = call i64 @nova_rt_len_any(i64 %r27)
  %r29 = call i64 @nova_rt_slice(i64 %r23, i64 %r26, i64 %r28)
  %r30 = load i64, ptr %slot.d, align 8
  %r31 = load i64, ptr %slot.kv, align 8
  %r32 = add i64 0, 0
  %r33 = load i64, ptr %slot.eq, align 8
  %r34 = call i64 @nova_rt_slice(i64 %r31, i64 %r32, i64 %r33)
  %_is.dv3 = call i64 @nova_rt_dict_set(i64 %r30, i64 %r34, i64 %r29)
  br label %endif200
else199:
  br label %endif200
endif200:
  %r35 = load i64, ptr %slot.i, align 8
  %r36 = add i64 1, 0
  %r37 = add i64 %r35, %r36
  store i64 %r37, ptr %slot.i, align 8
  br label %while_hdr195
while_exit197:
  %r38 = load i64, ptr %slot.d, align 8
  ret i64 %r38
}

; ESCAPE body_form: allocs=0 escape=0 local=0
define i64 @body_form(i64 %p0) nounwind uwtable {
entry:
  %slot.req = alloca i64, align 8
  store i64 %p0, ptr %slot.req, align 8
  %r0 = load i64, ptr %slot.req, align 8
  %r1.p = getelementptr inbounds [5 x i8], ptr @.str.74, i64 0, i64 0
  %r1 = ptrtoint ptr %r1.p to i64
  %r2 = call i64 @nova_rt_index_get(i64 %r0, i64 %r1)
  %r3 = call i64 @form_decode(i64 %r2)
  ret i64 %r3
}

; ESCAPE row_dict: allocs=1 escape=1 local=0
define i64 @row_dict(i64 %p0, i64 %p1) nounwind uwtable {
entry:
  %slot.columns = alloca i64, align 8
  store i64 %p0, ptr %slot.columns, align 8
  %slot.row = alloca i64, align 8
  store i64 %p1, ptr %slot.row, align 8
  %slot.d = alloca i64, align 8
  store i64 0, ptr %slot.d, align 8
  %slot.i = alloca i64, align 8
  store i64 0, ptr %slot.i, align 8
  %slot.__sc_204 = alloca i64, align 8
  store i64 0, ptr %slot.__sc_204, align 8
  %r0 = call i64 @nova_rt_dict_create()
  store i64 %r0, ptr %slot.d, align 8
  %r1 = add i64 0, 0
  store i64 %r1, ptr %slot.i, align 8
  br label %while_hdr201
while_hdr201:
  %r2 = load i64, ptr %slot.i, align 8
  %r3 = load i64, ptr %slot.columns, align 8
  %r4.lp = inttoptr i64 %r3 to ptr
  %r4.szp = getelementptr i64, ptr %r4.lp, i64 1
  %r4 = load i64, ptr %r4.szp, align 8, !tbaa !6
  %r5.cmp = icmp slt i64 %r2, %r4
  %r5 = zext i1 %r5.cmp to i64
  store i64 %r5, ptr %slot.__sc_204, align 8
  %br_and_rhs2050 = icmp ne i64 %r5, 0
  br i1 %br_and_rhs2050, label %and_rhs205, label %and_merge206
and_rhs205:
  %r6 = load i64, ptr %slot.i, align 8
  %r7 = load i64, ptr %slot.row, align 8
  %r8.lp = inttoptr i64 %r7 to ptr
  %r8.szp = getelementptr i64, ptr %r8.lp, i64 1
  %r8 = load i64, ptr %r8.szp, align 8, !tbaa !6
  %r9.cmp = icmp slt i64 %r6, %r8
  %r9 = zext i1 %r9.cmp to i64
  store i64 %r9, ptr %slot.__sc_204, align 8
  br label %and_merge206
and_merge206:
  %r10 = load i64, ptr %slot.__sc_204, align 8
  %br_while_body2021 = icmp ne i64 %r10, 0
  br i1 %br_while_body2021, label %while_body202, label %while_exit203, !prof !90
while_body202:
  %r11 = load i64, ptr %slot.row, align 8
  %r12 = load i64, ptr %slot.i, align 8
  %r13.lp = inttoptr i64 %r11 to ptr
  %r13.dp = load ptr, ptr %r13.lp, align 8, !tbaa !2
  %r13.ep = getelementptr i64, ptr %r13.dp, i64 %r12
  %r13.lv = load i64, ptr %r13.ep, align 8, !tbaa !4
  %r13 = call i64 @nova_rt_unbox_elem(i64 %r13.lv)
  %r14 = load i64, ptr %slot.d, align 8
  %r15 = load i64, ptr %slot.columns, align 8
  %r16 = load i64, ptr %slot.i, align 8
  %r17.lp = inttoptr i64 %r15 to ptr
  %r17.dp = load ptr, ptr %r17.lp, align 8, !tbaa !2
  %r17.ep = getelementptr i64, ptr %r17.dp, i64 %r16
  %r17.lv = load i64, ptr %r17.ep, align 8, !tbaa !4
  %r17 = call i64 @nova_rt_unbox_elem(i64 %r17.lv)
  %_is.dv2 = call i64 @nova_rt_dict_set(i64 %r14, i64 %r17, i64 %r13)
  %r18 = load i64, ptr %slot.i, align 8
  %r19 = add i64 1, 0
  %r20 = add i64 %r18, %r19
  store i64 %r20, ptr %slot.i, align 8
  br label %while_hdr201
while_exit203:
  %r21 = load i64, ptr %slot.d, align 8
  ret i64 %r21
}

; ESCAPE rows_dicts: allocs=1 escape=1 local=0
define i64 @rows_dicts(i64 %p0, i64 %p1) nounwind uwtable {
entry:
  %slot.columns = alloca i64, align 8
  store i64 %p0, ptr %slot.columns, align 8
  %slot.rows = alloca i64, align 8
  store i64 %p1, ptr %slot.rows, align 8
  %slot.out = alloca i64, align 8
  store i64 0, ptr %slot.out, align 8
  %slot.i = alloca i64, align 8
  store i64 0, ptr %slot.i, align 8
  %r0 = call i64 @nova_rt_list_create()
  store i64 %r0, ptr %slot.out, align 8
  %r1 = add i64 0, 0
  store i64 %r1, ptr %slot.i, align 8
  br label %while_hdr207
while_hdr207:
  %r2 = load i64, ptr %slot.i, align 8
  %r3 = load i64, ptr %slot.rows, align 8
  %r4.lp = inttoptr i64 %r3 to ptr
  %r4.szp = getelementptr i64, ptr %r4.lp, i64 1
  %r4 = load i64, ptr %r4.szp, align 8, !tbaa !6
  %r5.cmp = icmp slt i64 %r2, %r4
  %r5 = zext i1 %r5.cmp to i64
  %br_while_body2080 = icmp ne i64 %r5, 0
  br i1 %br_while_body2080, label %while_body208, label %while_exit209, !prof !90
while_body208:
  %r6 = load i64, ptr %slot.out, align 8
  %r7 = load i64, ptr %slot.columns, align 8
  %r8 = load i64, ptr %slot.rows, align 8
  %r9 = load i64, ptr %slot.i, align 8
  %r10.lp = inttoptr i64 %r8 to ptr
  %r10.dp = load ptr, ptr %r10.lp, align 8, !tbaa !2
  %r10.ep = getelementptr i64, ptr %r10.dp, i64 %r9
  %r10.lv = load i64, ptr %r10.ep, align 8, !tbaa !4
  %r10 = call i64 @nova_rt_unbox_elem(i64 %r10.lv)
  %r11 = call i64 @row_dict(i64 %r7, i64 %r10)
  %r12 = call i64 @nova_rt_list_append(i64 %r6, i64 %r11)
  %r13 = load i64, ptr %slot.i, align 8
  %r14 = add i64 1, 0
  %r15 = add i64 %r13, %r14
  store i64 %r15, ptr %slot.i, align 8
  br label %while_hdr207
while_exit209:
  %r16 = load i64, ptr %slot.out, align 8
  ret i64 %r16
}

; ESCAPE _query_dict: allocs=1 escape=1 local=0
define i64 @_query_dict(i64 %p0) nounwind uwtable {
entry:
  %slot.raw_path = alloca i64, align 8
  store i64 %p0, ptr %slot.raw_path, align 8
  %slot.d = alloca i64, align 8
  store i64 0, ptr %slot.d, align 8
  %slot.q = alloca i64, align 8
  store i64 0, ptr %slot.q, align 8
  %slot.qs = alloca i64, align 8
  store i64 0, ptr %slot.qs, align 8
  %slot.pairs = alloca i64, align 8
  store i64 0, ptr %slot.pairs, align 8
  %slot.i = alloca i64, align 8
  store i64 0, ptr %slot.i, align 8
  %slot.kv = alloca i64, align 8
  store i64 0, ptr %slot.kv, align 8
  %slot.eq = alloca i64, align 8
  store i64 0, ptr %slot.eq, align 8
  %r0 = call i64 @nova_rt_dict_create()
  store i64 %r0, ptr %slot.d, align 8
  %r1 = load i64, ptr %slot.raw_path, align 8
  %r2.p = getelementptr inbounds [2 x i8], ptr @.str.25, i64 0, i64 0
  %r2 = ptrtoint ptr %r2.p to i64
  %r3 = call i64 @nova_rt_find(i64 %r1, i64 %r2)
  store i64 %r3, ptr %slot.q, align 8
  %r4 = load i64, ptr %slot.q, align 8
  %r5 = add i64 0, 0
  %r6.cmp = icmp slt i64 %r4, %r5
  %r6 = zext i1 %r6.cmp to i64
  %br_then2100 = icmp ne i64 %r6, 0
  br i1 %br_then2100, label %then210, label %else211
then210:
  %r7 = load i64, ptr %slot.d, align 8
  ret i64 %r7
else211:
  br label %endif212
endif212:
  %r8 = load i64, ptr %slot.raw_path, align 8
  %r9 = load i64, ptr %slot.q, align 8
  %r10 = add i64 1, 0
  %r11 = add i64 %r9, %r10
  %r12 = load i64, ptr %slot.raw_path, align 8
  %r13 = call i64 @nova_rt_len_any(i64 %r12)
  %r14 = call i64 @nova_rt_slice(i64 %r8, i64 %r11, i64 %r13)
  store i64 %r14, ptr %slot.qs, align 8
  %r15 = load i64, ptr %slot.qs, align 8
  %r16.p = getelementptr inbounds [2 x i8], ptr @.str.27, i64 0, i64 0
  %r16 = ptrtoint ptr %r16.p to i64
  %r17 = call i64 @nova_rt_split(i64 %r15, i64 %r16)
  store i64 %r17, ptr %slot.pairs, align 8
  %r18 = add i64 0, 0
  store i64 %r18, ptr %slot.i, align 8
  br label %while_hdr213
while_hdr213:
  %r19 = load i64, ptr %slot.i, align 8
  %r20 = load i64, ptr %slot.pairs, align 8
  %r21.lp = inttoptr i64 %r20 to ptr
  %r21.szp = getelementptr i64, ptr %r21.lp, i64 1
  %r21 = load i64, ptr %r21.szp, align 8, !tbaa !6
  %r22.cmp = icmp slt i64 %r19, %r21
  %r22 = zext i1 %r22.cmp to i64
  %br_while_body2141 = icmp ne i64 %r22, 0
  br i1 %br_while_body2141, label %while_body214, label %while_exit215, !prof !90
while_body214:
  %r23 = load i64, ptr %slot.pairs, align 8
  %r24 = load i64, ptr %slot.i, align 8
  %r25 = call i64 @nova_rt_index_get(i64 %r23, i64 %r24)
  store i64 %r25, ptr %slot.kv, align 8
  %r26 = load i64, ptr %slot.kv, align 8
  %r27.p = getelementptr inbounds [2 x i8], ptr @.str.26, i64 0, i64 0
  %r27 = ptrtoint ptr %r27.p to i64
  %r28 = call i64 @nova_rt_find(i64 %r26, i64 %r27)
  store i64 %r28, ptr %slot.eq, align 8
  %r29 = load i64, ptr %slot.eq, align 8
  %r30 = add i64 0, 0
  %r31.cmp = icmp sge i64 %r29, %r30
  %r31 = zext i1 %r31.cmp to i64
  %br_then2162 = icmp ne i64 %r31, 0
  br i1 %br_then2162, label %then216, label %else217
then216:
  %r32 = load i64, ptr %slot.kv, align 8
  %r33 = load i64, ptr %slot.eq, align 8
  %r34 = add i64 1, 0
  %r35 = add i64 %r33, %r34
  %r36 = load i64, ptr %slot.kv, align 8
  %r37 = call i64 @nova_rt_len_any(i64 %r36)
  %r38 = call i64 @nova_rt_slice(i64 %r32, i64 %r35, i64 %r37)
  %r39 = load i64, ptr %slot.d, align 8
  %r40 = load i64, ptr %slot.kv, align 8
  %r41 = add i64 0, 0
  %r42 = load i64, ptr %slot.eq, align 8
  %r43 = call i64 @nova_rt_slice(i64 %r40, i64 %r41, i64 %r42)
  %_is.dv3 = call i64 @nova_rt_dict_set(i64 %r39, i64 %r43, i64 %r38)
  br label %endif218
else217:
  br label %endif218
endif218:
  %r44 = load i64, ptr %slot.i, align 8
  %r45 = add i64 1, 0
  %r46 = add i64 %r44, %r45
  store i64 %r46, ptr %slot.i, align 8
  br label %while_hdr213
while_exit215:
  %r47 = load i64, ptr %slot.d, align 8
  ret i64 %r47
}

; ESCAPE _headers_dict: allocs=1 escape=1 local=0
define i64 @_headers_dict(i64 %p0) nounwind uwtable {
entry:
  %slot.raw = alloca i64, align 8
  store i64 %p0, ptr %slot.raw, align 8
  %slot.d = alloca i64, align 8
  store i64 0, ptr %slot.d, align 8
  %slot.hdr_end = alloca i64, align 8
  store i64 0, ptr %slot.hdr_end, align 8
  %slot.region = alloca i64, align 8
  store i64 0, ptr %slot.region, align 8
  %slot.first_nl = alloca i64, align 8
  store i64 0, ptr %slot.first_nl, align 8
  %slot.block = alloca i64, align 8
  store i64 0, ptr %slot.block, align 8
  %slot.lines = alloca i64, align 8
  store i64 0, ptr %slot.lines, align 8
  %slot.i = alloca i64, align 8
  store i64 0, ptr %slot.i, align 8
  %slot.line = alloca i64, align 8
  store i64 0, ptr %slot.line, align 8
  %slot.colon = alloca i64, align 8
  store i64 0, ptr %slot.colon, align 8
  %slot.name = alloca i64, align 8
  store i64 0, ptr %slot.name, align 8
  %slot.val = alloca i64, align 8
  store i64 0, ptr %slot.val, align 8
  %r0 = call i64 @nova_rt_dict_create()
  store i64 %r0, ptr %slot.d, align 8
  %r1 = load i64, ptr %slot.raw, align 8
  %r2.p = getelementptr inbounds [5 x i8], ptr @.str.23, i64 0, i64 0
  %r2 = ptrtoint ptr %r2.p to i64
  %r3 = call i64 @nova_rt_find(i64 %r1, i64 %r2)
  store i64 %r3, ptr %slot.hdr_end, align 8
  %r4 = load i64, ptr %slot.raw, align 8
  store i64 %r4, ptr %slot.region, align 8
  %r5 = load i64, ptr %slot.hdr_end, align 8
  %r6 = add i64 0, 0
  %r7.cmp = icmp sge i64 %r5, %r6
  %r7 = zext i1 %r7.cmp to i64
  %br_then2190 = icmp ne i64 %r7, 0
  br i1 %br_then2190, label %then219, label %else220
then219:
  %r8 = load i64, ptr %slot.raw, align 8
  %r9 = add i64 0, 0
  %r10 = load i64, ptr %slot.hdr_end, align 8
  %r11 = call i64 @nova_rt_slice(i64 %r8, i64 %r9, i64 %r10)
  store i64 %r11, ptr %slot.region, align 8
  br label %endif221
else220:
  br label %endif221
endif221:
  %r12 = load i64, ptr %slot.region, align 8
  %r13.p = getelementptr inbounds [3 x i8], ptr @.str.12, i64 0, i64 0
  %r13 = ptrtoint ptr %r13.p to i64
  %r14 = call i64 @nova_rt_find(i64 %r12, i64 %r13)
  store i64 %r14, ptr %slot.first_nl, align 8
  %r15 = load i64, ptr %slot.first_nl, align 8
  %r16 = add i64 0, 0
  %r17.cmp = icmp slt i64 %r15, %r16
  %r17 = zext i1 %r17.cmp to i64
  %br_then2221 = icmp ne i64 %r17, 0
  br i1 %br_then2221, label %then222, label %else223
then222:
  %r18 = load i64, ptr %slot.d, align 8
  ret i64 %r18
else223:
  br label %endif224
endif224:
  %r19 = load i64, ptr %slot.region, align 8
  %r20 = load i64, ptr %slot.first_nl, align 8
  %r21 = add i64 2, 0
  %r22 = add i64 %r20, %r21
  %r23 = load i64, ptr %slot.region, align 8
  %r24 = call i64 @nova_rt_len_any(i64 %r23)
  %r25 = call i64 @nova_rt_slice(i64 %r19, i64 %r22, i64 %r24)
  store i64 %r25, ptr %slot.block, align 8
  %r26 = load i64, ptr %slot.block, align 8
  %r27.p = getelementptr inbounds [3 x i8], ptr @.str.12, i64 0, i64 0
  %r27 = ptrtoint ptr %r27.p to i64
  %r28 = call i64 @nova_rt_split(i64 %r26, i64 %r27)
  store i64 %r28, ptr %slot.lines, align 8
  %r29 = add i64 0, 0
  store i64 %r29, ptr %slot.i, align 8
  br label %while_hdr225
while_hdr225:
  %r30 = load i64, ptr %slot.i, align 8
  %r31 = load i64, ptr %slot.lines, align 8
  %r32.lp = inttoptr i64 %r31 to ptr
  %r32.szp = getelementptr i64, ptr %r32.lp, i64 1
  %r32 = load i64, ptr %r32.szp, align 8, !tbaa !6
  %r33.cmp = icmp slt i64 %r30, %r32
  %r33 = zext i1 %r33.cmp to i64
  %br_while_body2262 = icmp ne i64 %r33, 0
  br i1 %br_while_body2262, label %while_body226, label %while_exit227, !prof !90
while_body226:
  %r34 = load i64, ptr %slot.lines, align 8
  %r35 = load i64, ptr %slot.i, align 8
  %r36 = call i64 @nova_rt_index_get(i64 %r34, i64 %r35)
  store i64 %r36, ptr %slot.line, align 8
  %r37 = load i64, ptr %slot.line, align 8
  %r38.p = getelementptr inbounds [2 x i8], ptr @.str.66, i64 0, i64 0
  %r38 = ptrtoint ptr %r38.p to i64
  %r39 = call i64 @nova_rt_find(i64 %r37, i64 %r38)
  store i64 %r39, ptr %slot.colon, align 8
  %r40 = load i64, ptr %slot.colon, align 8
  %r41 = add i64 0, 0
  %r42.cmp = icmp sge i64 %r40, %r41
  %r42 = zext i1 %r42.cmp to i64
  %br_then2283 = icmp ne i64 %r42, 0
  br i1 %br_then2283, label %then228, label %else229
then228:
  %r43 = load i64, ptr %slot.line, align 8
  %r44 = add i64 0, 0
  %r45 = load i64, ptr %slot.colon, align 8
  %r46 = call i64 @nova_rt_slice(i64 %r43, i64 %r44, i64 %r45)
  %r47 = call i64 @nova_rt_trim(i64 %r46)
  %r48 = call i64 @nova_rt_lower(i64 %r47)
  store i64 %r48, ptr %slot.name, align 8
  %r49 = load i64, ptr %slot.line, align 8
  %r50 = load i64, ptr %slot.colon, align 8
  %r51 = add i64 1, 0
  %r52 = add i64 %r50, %r51
  %r53 = load i64, ptr %slot.line, align 8
  %r54 = call i64 @nova_rt_len_any(i64 %r53)
  %r55 = call i64 @nova_rt_slice(i64 %r49, i64 %r52, i64 %r54)
  %r56 = call i64 @nova_rt_trim(i64 %r55)
  store i64 %r56, ptr %slot.val, align 8
  %r57 = load i64, ptr %slot.val, align 8
  %r58 = load i64, ptr %slot.d, align 8
  %r59 = load i64, ptr %slot.name, align 8
  %_is.dv4 = call i64 @nova_rt_dict_set(i64 %r58, i64 %r59, i64 %r57)
  br label %endif230
else229:
  br label %endif230
endif230:
  %r60 = load i64, ptr %slot.i, align 8
  %r61 = add i64 1, 0
  %r62 = add i64 %r60, %r61
  store i64 %r62, ptr %slot.i, align 8
  br label %while_hdr225
while_exit227:
  %r63 = load i64, ptr %slot.d, align 8
  ret i64 %r63
}

; ESCAPE build_request: allocs=3 escape=1 local=2
define i64 @build_request(i64 %p0, i64 %p1) nounwind uwtable {
entry:
  %slot.raw = alloca i64, align 8
  store i64 %p0, ptr %slot.raw, align 8
  %slot.conn = alloca i64, align 8
  store i64 %p1, ptr %slot.conn, align 8
  %slot.rp = alloca i64, align 8
  store i64 0, ptr %slot.rp, align 8
  %slot.q = alloca i64, align 8
  store i64 0, ptr %slot.q, align 8
  %slot.h = alloca i64, align 8
  store i64 0, ptr %slot.h, align 8
  %r0 = load i64, ptr %slot.raw, align 8
  %r1 = call i64 @parse_path(i64 %r0)
  store i64 %r1, ptr %slot.rp, align 8
  %r2 = load i64, ptr %slot.rp, align 8
  %r3 = call i64 @_query_dict(i64 %r2)
  store i64 %r3, ptr %slot.q, align 8
  %r4 = load i64, ptr %slot.raw, align 8
  %r5 = call i64 @_headers_dict(i64 %r4)
  store i64 %r5, ptr %slot.h, align 8
  %r6 = load i64, ptr %slot.raw, align 8
  %r7 = call i64 @parse_method(i64 %r6)
  %r8 = load i64, ptr %slot.raw, align 8
  %r9 = call i64 @parse_path_clean(i64 %r8)
  %r10 = load i64, ptr %slot.rp, align 8
  %r11 = call i64 @nova_rt_dict_create()
  %r12 = load i64, ptr %slot.q, align 8
  %r13 = load i64, ptr %slot.h, align 8
  %r14 = load i64, ptr %slot.raw, align 8
  %r15 = call i64 @parse_body(i64 %r14)
  %r16 = call i64 @nova_rt_dict_create()
  %r17 = load i64, ptr %slot.conn, align 8
  %r18.ptr = call ptr @nova_rt_struct_alloc(i64 80)
  %r18.thash = getelementptr i64, ptr %r18.ptr, i64 0
  store i64 229439833034990, ptr %r18.thash, align 8
  %r18.f0 = getelementptr i64, ptr %r18.ptr, i64 1
  store i64 %r7, ptr %r18.f0, align 8
  %r18.f1 = getelementptr i64, ptr %r18.ptr, i64 2
  store i64 %r9, ptr %r18.f1, align 8
  %r18.f2 = getelementptr i64, ptr %r18.ptr, i64 3
  store i64 %r10, ptr %r18.f2, align 8
  %r18.f3 = getelementptr i64, ptr %r18.ptr, i64 4
  store i64 %r11, ptr %r18.f3, align 8
  %r18.f4 = getelementptr i64, ptr %r18.ptr, i64 5
  store i64 %r12, ptr %r18.f4, align 8
  %r18.f5 = getelementptr i64, ptr %r18.ptr, i64 6
  store i64 %r13, ptr %r18.f5, align 8
  %r18.f6 = getelementptr i64, ptr %r18.ptr, i64 7
  store i64 %r15, ptr %r18.f6, align 8
  %r18.f7 = getelementptr i64, ptr %r18.ptr, i64 8
  store i64 %r16, ptr %r18.f7, align 8
  %r18.f8 = getelementptr i64, ptr %r18.ptr, i64 9
  store i64 %r17, ptr %r18.f8, align 8
  %r18 = ptrtoint ptr %r18.ptr to i64
  ret i64 %r18
}

; ESCAPE req_header: allocs=0 escape=0 local=0
define i64 @req_header(i64 %p0, i64 %p1) nounwind uwtable {
entry:
  %slot.req = alloca i64, align 8
  store i64 %p0, ptr %slot.req, align 8
  %slot.name = alloca i64, align 8
  store i64 %p1, ptr %slot.name, align 8
  %slot.k = alloca i64, align 8
  store i64 0, ptr %slot.k, align 8
  %r0 = load i64, ptr %slot.name, align 8
  %r1 = call i64 @nova_rt_lower(i64 %r0)
  store i64 %r1, ptr %slot.k, align 8
  %r2 = load i64, ptr %slot.req, align 8
  %r3.ptr = inttoptr i64 %r2 to ptr
  %r3.gep = getelementptr i64, ptr %r3.ptr, i64 6
  %r3 = load i64, ptr %r3.gep, align 8
  %r4 = load i64, ptr %slot.k, align 8
  %r5 = call i64 @nova_rt_contains(i64 %r3, i64 %r4)
  %br_then2310 = icmp ne i64 %r5, 0
  br i1 %br_then2310, label %then231, label %else232
then231:
  %r6 = load i64, ptr %slot.req, align 8
  %r7.ptr = inttoptr i64 %r6 to ptr
  %r7.gep = getelementptr i64, ptr %r7.ptr, i64 6
  %r7 = load i64, ptr %r7.gep, align 8
  %r8 = load i64, ptr %slot.k, align 8
  %r9 = call i64 @nova_rt_index_get(i64 %r7, i64 %r8)
  ret i64 %r9
else232:
  br label %endif233
endif233:
  %r10.p = getelementptr inbounds [1 x i8], ptr @.str.24, i64 0, i64 0
  %r10 = ptrtoint ptr %r10.p to i64
  ret i64 %r10
}

; ESCAPE finalize: allocs=0 escape=0 local=0
define i64 @finalize(i64 %p0) nounwind uwtable {
entry:
  %slot.resp = alloca i64, align 8
  store i64 %p0, ptr %slot.resp, align 8
  %slot.r = alloca i64, align 8
  store i64 0, ptr %slot.r, align 8
  %slot.ks = alloca i64, align 8
  store i64 0, ptr %slot.ks, align 8
  %slot.i = alloca i64, align 8
  store i64 0, ptr %slot.i, align 8
  %slot.k = alloca i64, align 8
  store i64 0, ptr %slot.k, align 8
  %r0.p = getelementptr inbounds [10 x i8], ptr @.str.11, i64 0, i64 0
  %r0 = ptrtoint ptr %r0.p to i64
  %r1 = load i64, ptr %slot.resp, align 8
  %r2.ptr = inttoptr i64 %r1 to ptr
  %r2.gep = getelementptr i64, ptr %r2.ptr, i64 1
  %r2 = load i64, ptr %r2.gep, align 8
  %r3 = call i64 @_status_line(i64 %r2)
  %r4 = call i64 @nova_rt_str_concat(i64 %r0, i64 %r3)
  %r5.p = getelementptr inbounds [3 x i8], ptr @.str.12, i64 0, i64 0
  %r5 = ptrtoint ptr %r5.p to i64
  %r6 = call i64 @nova_rt_str_concat(i64 %r4, i64 %r5)
  store i64 %r6, ptr %slot.r, align 8
  %r7 = load i64, ptr %slot.resp, align 8
  %r8.ptr = inttoptr i64 %r7 to ptr
  %r8.gep = getelementptr i64, ptr %r8.ptr, i64 2
  %r8 = load i64, ptr %r8.gep, align 8
  %r9 = call i64 @nova_rt_dict_keys(i64 %r8)
  store i64 %r9, ptr %slot.ks, align 8
  %r10 = add i64 0, 0
  store i64 %r10, ptr %slot.i, align 8
  br label %while_hdr234
while_hdr234:
  %r11 = load i64, ptr %slot.i, align 8
  %r12 = load i64, ptr %slot.ks, align 8
  %r13.lp = inttoptr i64 %r12 to ptr
  %r13.szp = getelementptr i64, ptr %r13.lp, i64 1
  %r13 = load i64, ptr %r13.szp, align 8, !tbaa !6
  %r14.cmp = icmp slt i64 %r11, %r13
  %r14 = zext i1 %r14.cmp to i64
  %br_while_body2350 = icmp ne i64 %r14, 0
  br i1 %br_while_body2350, label %while_body235, label %while_exit236, !prof !90
while_body235:
  %r15 = load i64, ptr %slot.ks, align 8
  %r16 = load i64, ptr %slot.i, align 8
  %r17 = call i64 @nova_rt_index_get(i64 %r15, i64 %r16)
  store i64 %r17, ptr %slot.k, align 8
  %r18 = load i64, ptr %slot.r, align 8
  %r19 = load i64, ptr %slot.k, align 8
  %r20 = call i64 @nova_rt_str_concat(i64 %r18, i64 %r19)
  %r21.p = getelementptr inbounds [3 x i8], ptr @.str.28, i64 0, i64 0
  %r21 = ptrtoint ptr %r21.p to i64
  %r22 = call i64 @nova_rt_str_concat(i64 %r20, i64 %r21)
  %r23 = load i64, ptr %slot.resp, align 8
  %r24.ptr = inttoptr i64 %r23 to ptr
  %r24.gep = getelementptr i64, ptr %r24.ptr, i64 2
  %r24 = load i64, ptr %r24.gep, align 8
  %r25 = load i64, ptr %slot.k, align 8
  %r26 = call i64 @nova_rt_index_get(i64 %r24, i64 %r25)
  %r27 = call i64 @nova_rt_str_concat(i64 %r22, i64 %r26)
  %r28.p = getelementptr inbounds [3 x i8], ptr @.str.12, i64 0, i64 0
  %r28 = ptrtoint ptr %r28.p to i64
  %r29 = call i64 @nova_rt_str_concat(i64 %r27, i64 %r28)
  store i64 %r29, ptr %slot.r, align 8
  %r30 = load i64, ptr %slot.i, align 8
  %r31 = add i64 1, 0
  %r32 = add i64 %r30, %r31
  store i64 %r32, ptr %slot.i, align 8
  br label %while_hdr234
while_exit236:
  %r33 = load i64, ptr %slot.r, align 8
  %r34.p = getelementptr inbounds [17 x i8], ptr @.str.14, i64 0, i64 0
  %r34 = ptrtoint ptr %r34.p to i64
  %r35 = call i64 @nova_rt_str_concat(i64 %r33, i64 %r34)
  %r36 = load i64, ptr %slot.resp, align 8
  %r37.ptr = inttoptr i64 %r36 to ptr
  %r37.gep = getelementptr i64, ptr %r37.ptr, i64 3
  %r37 = load i64, ptr %r37.gep, align 8
  %r38 = call i64 @nova_rt_len_any(i64 %r37)
  %r39 = call i64 @nova_rt_int_to_str(i64 %r38)
  %r40 = call i64 @nova_rt_str_concat(i64 %r35, i64 %r39)
  %r41.p = getelementptr inbounds [3 x i8], ptr @.str.12, i64 0, i64 0
  %r41 = ptrtoint ptr %r41.p to i64
  %r42 = call i64 @nova_rt_str_concat(i64 %r40, i64 %r41)
  store i64 %r42, ptr %slot.r, align 8
  %r43 = load i64, ptr %slot.r, align 8
  %r44.p = getelementptr inbounds [20 x i8], ptr @.str.15, i64 0, i64 0
  %r44 = ptrtoint ptr %r44.p to i64
  %r45 = call i64 @nova_rt_str_concat(i64 %r43, i64 %r44)
  store i64 %r45, ptr %slot.r, align 8
  %r46 = load i64, ptr %slot.r, align 8
  %r47.p = getelementptr inbounds [21 x i8], ptr @.str.16, i64 0, i64 0
  %r47 = ptrtoint ptr %r47.p to i64
  %r48 = call i64 @nova_rt_str_concat(i64 %r46, i64 %r47)
  store i64 %r48, ptr %slot.r, align 8
  %r49 = load i64, ptr %slot.r, align 8
  %r50.p = getelementptr inbounds [3 x i8], ptr @.str.12, i64 0, i64 0
  %r50 = ptrtoint ptr %r50.p to i64
  %r51 = call i64 @nova_rt_str_concat(i64 %r49, i64 %r50)
  store i64 %r51, ptr %slot.r, align 8
  %r52 = load i64, ptr %slot.r, align 8
  %r53 = load i64, ptr %slot.resp, align 8
  %r54.ptr = inttoptr i64 %r53 to ptr
  %r54.gep = getelementptr i64, ptr %r54.ptr, i64 3
  %r54 = load i64, ptr %r54.gep, align 8
  %r55 = call i64 @nova_rt_str_concat(i64 %r52, i64 %r54)
  store i64 %r55, ptr %slot.r, align 8
  %r56 = load i64, ptr %slot.r, align 8
  ret i64 %r56
}

; ESCAPE resp_new: allocs=2 escape=1 local=1
define i64 @resp_new(i64 %p0, i64 %p1) nounwind uwtable {
entry:
  %slot.status = alloca i64, align 8
  store i64 %p0, ptr %slot.status, align 8
  %slot.body = alloca i64, align 8
  store i64 %p1, ptr %slot.body, align 8
  %r0 = load i64, ptr %slot.status, align 8
  %r1 = call i64 @nova_rt_dict_create()
  %r2 = load i64, ptr %slot.body, align 8
  %r3 = add i64 0, 0
  %r4.ptr = call ptr @nova_rt_struct_alloc(i64 40)
  %r4.thash = getelementptr i64, ptr %r4.ptr, i64 0
  store i64 7571514562849844, ptr %r4.thash, align 8
  %r4.f0 = getelementptr i64, ptr %r4.ptr, i64 1
  store i64 %r0, ptr %r4.f0, align 8
  %r4.f1 = getelementptr i64, ptr %r4.ptr, i64 2
  store i64 %r1, ptr %r4.f1, align 8
  %r4.f2 = getelementptr i64, ptr %r4.ptr, i64 3
  store i64 %r2, ptr %r4.f2, align 8
  %r4.f3 = getelementptr i64, ptr %r4.ptr, i64 4
  store i64 %r3, ptr %r4.f3, align 8
  %r4 = ptrtoint ptr %r4.ptr to i64
  ret i64 %r4
}

; ESCAPE resp_text: allocs=2 escape=1 local=1
define i64 @resp_text(i64 %p0, i64 %p1) nounwind uwtable {
entry:
  %slot.status = alloca i64, align 8
  store i64 %p0, ptr %slot.status, align 8
  %slot.body = alloca i64, align 8
  store i64 %p1, ptr %slot.body, align 8
  %slot.h = alloca i64, align 8
  store i64 0, ptr %slot.h, align 8
  %r0 = call i64 @nova_rt_dict_create()
  store i64 %r0, ptr %slot.h, align 8
  %r1.p = getelementptr inbounds [26 x i8], ptr @.str.17, i64 0, i64 0
  %r1 = ptrtoint ptr %r1.p to i64
  %r2 = load i64, ptr %slot.h, align 8
  %r3.p = getelementptr inbounds [13 x i8], ptr @.str.76, i64 0, i64 0
  %r3 = ptrtoint ptr %r3.p to i64
  %_is.dv0 = call i64 @nova_rt_dict_set_no_rc(i64 %r2, i64 %r3, i64 %r1)
  %r4 = load i64, ptr %slot.status, align 8
  %r5 = load i64, ptr %slot.h, align 8
  %r6 = load i64, ptr %slot.body, align 8
  %r7 = add i64 0, 0
  %r8.ptr = call ptr @nova_rt_struct_alloc(i64 40)
  %r8.thash = getelementptr i64, ptr %r8.ptr, i64 0
  store i64 7571514562849844, ptr %r8.thash, align 8
  %r8.f0 = getelementptr i64, ptr %r8.ptr, i64 1
  store i64 %r4, ptr %r8.f0, align 8
  %r8.f1 = getelementptr i64, ptr %r8.ptr, i64 2
  store i64 %r5, ptr %r8.f1, align 8
  %r8.f2 = getelementptr i64, ptr %r8.ptr, i64 3
  store i64 %r6, ptr %r8.f2, align 8
  %r8.f3 = getelementptr i64, ptr %r8.ptr, i64 4
  store i64 %r7, ptr %r8.f3, align 8
  %r8 = ptrtoint ptr %r8.ptr to i64
  ret i64 %r8
}

; ESCAPE resp_html: allocs=2 escape=1 local=1
define i64 @resp_html(i64 %p0, i64 %p1) nounwind uwtable {
entry:
  %slot.status = alloca i64, align 8
  store i64 %p0, ptr %slot.status, align 8
  %slot.body = alloca i64, align 8
  store i64 %p1, ptr %slot.body, align 8
  %slot.h = alloca i64, align 8
  store i64 0, ptr %slot.h, align 8
  %r0 = call i64 @nova_rt_dict_create()
  store i64 %r0, ptr %slot.h, align 8
  %r1.p = getelementptr inbounds [25 x i8], ptr @.str.18, i64 0, i64 0
  %r1 = ptrtoint ptr %r1.p to i64
  %r2 = load i64, ptr %slot.h, align 8
  %r3.p = getelementptr inbounds [13 x i8], ptr @.str.76, i64 0, i64 0
  %r3 = ptrtoint ptr %r3.p to i64
  %_is.dv0 = call i64 @nova_rt_dict_set_no_rc(i64 %r2, i64 %r3, i64 %r1)
  %r4 = load i64, ptr %slot.status, align 8
  %r5 = load i64, ptr %slot.h, align 8
  %r6 = load i64, ptr %slot.body, align 8
  %r7 = add i64 0, 0
  %r8.ptr = call ptr @nova_rt_struct_alloc(i64 40)
  %r8.thash = getelementptr i64, ptr %r8.ptr, i64 0
  store i64 7571514562849844, ptr %r8.thash, align 8
  %r8.f0 = getelementptr i64, ptr %r8.ptr, i64 1
  store i64 %r4, ptr %r8.f0, align 8
  %r8.f1 = getelementptr i64, ptr %r8.ptr, i64 2
  store i64 %r5, ptr %r8.f1, align 8
  %r8.f2 = getelementptr i64, ptr %r8.ptr, i64 3
  store i64 %r6, ptr %r8.f2, align 8
  %r8.f3 = getelementptr i64, ptr %r8.ptr, i64 4
  store i64 %r7, ptr %r8.f3, align 8
  %r8 = ptrtoint ptr %r8.ptr to i64
  ret i64 %r8
}

; ESCAPE resp_json: allocs=2 escape=1 local=1
define i64 @resp_json(i64 %p0, i64 %p1) nounwind uwtable {
entry:
  %slot.status = alloca i64, align 8
  store i64 %p0, ptr %slot.status, align 8
  %slot.value = alloca i64, align 8
  store i64 %p1, ptr %slot.value, align 8
  %slot.h = alloca i64, align 8
  store i64 0, ptr %slot.h, align 8
  %r0 = call i64 @nova_rt_dict_create()
  store i64 %r0, ptr %slot.h, align 8
  %r1.p = getelementptr inbounds [17 x i8], ptr @.str.19, i64 0, i64 0
  %r1 = ptrtoint ptr %r1.p to i64
  %r2 = load i64, ptr %slot.h, align 8
  %r3.p = getelementptr inbounds [13 x i8], ptr @.str.76, i64 0, i64 0
  %r3 = ptrtoint ptr %r3.p to i64
  %_is.dv0 = call i64 @nova_rt_dict_set_no_rc(i64 %r2, i64 %r3, i64 %r1)
  %r4 = load i64, ptr %slot.status, align 8
  %r5 = load i64, ptr %slot.h, align 8
  %r6 = load i64, ptr %slot.value, align 8
  %r7 = call i64 @nova_rt_json_stringify(i64 %r6)
  %r8 = add i64 0, 0
  %r9.ptr = call ptr @nova_rt_struct_alloc(i64 40)
  %r9.thash = getelementptr i64, ptr %r9.ptr, i64 0
  store i64 7571514562849844, ptr %r9.thash, align 8
  %r9.f0 = getelementptr i64, ptr %r9.ptr, i64 1
  store i64 %r4, ptr %r9.f0, align 8
  %r9.f1 = getelementptr i64, ptr %r9.ptr, i64 2
  store i64 %r5, ptr %r9.f1, align 8
  %r9.f2 = getelementptr i64, ptr %r9.ptr, i64 3
  store i64 %r7, ptr %r9.f2, align 8
  %r9.f3 = getelementptr i64, ptr %r9.ptr, i64 4
  store i64 %r8, ptr %r9.f3, align 8
  %r9 = ptrtoint ptr %r9.ptr to i64
  ret i64 %r9
}

; ESCAPE resp_set_header: allocs=0 escape=0 local=0
define i64 @resp_set_header(i64 %p0, i64 %p1, i64 %p2) nounwind uwtable {
entry:
  %slot.resp = alloca i64, align 8
  store i64 %p0, ptr %slot.resp, align 8
  %slot.name = alloca i64, align 8
  store i64 %p1, ptr %slot.name, align 8
  %slot.value = alloca i64, align 8
  store i64 %p2, ptr %slot.value, align 8
  %r0 = load i64, ptr %slot.value, align 8
  %r1 = load i64, ptr %slot.resp, align 8
  %r2.ptr = inttoptr i64 %r1 to ptr
  %r2.gep = getelementptr i64, ptr %r2.ptr, i64 2
  %r2 = load i64, ptr %r2.gep, align 8
  %r3 = load i64, ptr %slot.name, align 8
  %_is.gv0 = call i64 @nova_rt_index_set(i64 %r2, i64 %r3, i64 %r0)
  %r4 = load i64, ptr %slot.resp, align 8
  ret i64 %r4
}

; ESCAPE _coerce: allocs=0 escape=0 local=0
define i64 @_coerce(i64 %p0) nounwind uwtable {
entry:
  %slot.v = alloca i64, align 8
  store i64 %p0, ptr %slot.v, align 8
  %slot.tn = alloca i64, align 8
  store i64 0, ptr %slot.tn, align 8
  %r0 = load i64, ptr %slot.v, align 8
  %r1 = call i64 @nova_rt_type_name(i64 %r0)
  store i64 %r1, ptr %slot.tn, align 8
  %r2 = load i64, ptr %slot.tn, align 8
  %r3.p = getelementptr inbounds [9 x i8], ptr @.str.77, i64 0, i64 0
  %r3 = ptrtoint ptr %r3.p to i64
  %r4.p0 = inttoptr i64 %r2 to ptr
  %r4.p1 = inttoptr i64 %r3 to ptr
  %r4.sc = call i32 @strcmp(ptr %r4.p0, ptr %r4.p1)
  %r4.cmp = icmp eq i32 %r4.sc, 0
  %r4 = zext i1 %r4.cmp to i64
  %br_then2370 = icmp ne i64 %r4, 0
  br i1 %br_then2370, label %then237, label %else238
then237:
  %r5 = load i64, ptr %slot.v, align 8
  ret i64 %r5
else238:
  br label %endif239
endif239:
  %r6 = load i64, ptr %slot.tn, align 8
  %r7.p = getelementptr inbounds [7 x i8], ptr @.str.78, i64 0, i64 0
  %r7 = ptrtoint ptr %r7.p to i64
  %r8.p0 = inttoptr i64 %r6 to ptr
  %r8.p1 = inttoptr i64 %r7 to ptr
  %r8.sc = call i32 @strcmp(ptr %r8.p0, ptr %r8.p1)
  %r8.cmp = icmp eq i32 %r8.sc, 0
  %r8 = zext i1 %r8.cmp to i64
  %br_then2401 = icmp ne i64 %r8, 0
  br i1 %br_then2401, label %then240, label %else241
then240:
  %r9 = add i64 200, 0
  %r10 = load i64, ptr %slot.v, align 8
  %r11 = call i64 @resp_text(i64 %r9, i64 %r10)
  ret i64 %r11
else241:
  br label %endif242
endif242:
  %r12 = add i64 200, 0
  %r13 = load i64, ptr %slot.v, align 8
  %r14 = call i64 @resp_json(i64 %r12, i64 %r13)
  ret i64 %r14
}

; ESCAPE static: allocs=1 escape=0 local=1
define i64 @static(i64 %p0, i64 %p1, i64 %p2) nounwind uwtable {
entry:
  %slot.a = alloca i64, align 8
  store i64 %p0, ptr %slot.a, align 8
  %slot.url_prefix = alloca i64, align 8
  store i64 %p1, ptr %slot.url_prefix, align 8
  %slot.root_dir = alloca i64, align 8
  store i64 %p2, ptr %slot.root_dir, align 8
  %r0 = load i64, ptr %slot.a, align 8
  %r1.p = getelementptr inbounds [8 x i8], ptr @.str.59, i64 0, i64 0
  %r1 = ptrtoint ptr %r1.p to i64
  %r2 = call i64 @nova_rt_index_get(i64 %r0, i64 %r1)
  %r4 = load i64, ptr %slot.url_prefix, align 8
  %r5 = load i64, ptr %slot.root_dir, align 8
  %r3 = call i64 @nova_rt_list_create()
  call i64 @nova_rt_list_append(i64 %r3, i64 %r4)
  call i64 @nova_rt_list_append(i64 %r3, i64 %r5)
  %r6 = call i64 @nova_rt_list_append(i64 %r2, i64 %r3)
  %r7 = load i64, ptr %slot.a, align 8
  ret i64 %r7
}

; ESCAPE _unsafe_segment: allocs=0 escape=0 local=0
define i64 @_unsafe_segment(i64 %p0) nounwind uwtable {
entry:
  %slot.seg = alloca i64, align 8
  store i64 %p0, ptr %slot.seg, align 8
  %r0 = load i64, ptr %slot.seg, align 8
  %r1.p = getelementptr inbounds [3 x i8], ptr @.str.79, i64 0, i64 0
  %r1 = ptrtoint ptr %r1.p to i64
  %r2.p0 = inttoptr i64 %r0 to ptr
  %r2.p1 = inttoptr i64 %r1 to ptr
  %r2.sc = call i32 @strcmp(ptr %r2.p0, ptr %r2.p1)
  %r2.cmp = icmp eq i32 %r2.sc, 0
  %r2 = zext i1 %r2.cmp to i64
  %br_then2430 = icmp ne i64 %r2, 0
  br i1 %br_then2430, label %then243, label %else244
then243:
  %r3 = add i64 1, 0
  ret i64 %r3
else244:
  br label %endif245
endif245:
  %r4 = load i64, ptr %slot.seg, align 8
  %r5.p = getelementptr inbounds [2 x i8], ptr @.str.80, i64 0, i64 0
  %r5 = ptrtoint ptr %r5.p to i64
  %r6 = call i64 @nova_rt_starts_with(i64 %r4, i64 %r5)
  %br_then2461 = icmp ne i64 %r6, 0
  br i1 %br_then2461, label %then246, label %else247
then246:
  %r7 = add i64 1, 0
  ret i64 %r7
else247:
  br label %endif248
endif248:
  %r8 = load i64, ptr %slot.seg, align 8
  %r9.p = getelementptr inbounds [2 x i8], ptr @.str.81, i64 0, i64 0
  %r9 = ptrtoint ptr %r9.p to i64
  %r10 = call i64 @nova_rt_find(i64 %r8, i64 %r9)
  %r11 = add i64 0, 0
  %r12.cmp = icmp sge i64 %r10, %r11
  %r12 = zext i1 %r12.cmp to i64
  %br_then2492 = icmp ne i64 %r12, 0
  br i1 %br_then2492, label %then249, label %else250
then249:
  %r13 = add i64 1, 0
  ret i64 %r13
else250:
  br label %endif251
endif251:
  %r14 = load i64, ptr %slot.seg, align 8
  %r15.p = getelementptr inbounds [2 x i8], ptr @.str.66, i64 0, i64 0
  %r15 = ptrtoint ptr %r15.p to i64
  %r16 = call i64 @nova_rt_find(i64 %r14, i64 %r15)
  %r17 = add i64 0, 0
  %r18.cmp = icmp sge i64 %r16, %r17
  %r18 = zext i1 %r18.cmp to i64
  %br_then2523 = icmp ne i64 %r18, 0
  br i1 %br_then2523, label %then252, label %else253
then252:
  %r19 = add i64 1, 0
  ret i64 %r19
else253:
  br label %endif254
endif254:
  %r20 = add i64 0, 0
  ret i64 %r20
}

; ESCAPE _safe_subpath: allocs=0 escape=0 local=0
define i64 @_safe_subpath(i64 %p0) nounwind uwtable {
entry:
  %slot.rel = alloca i64, align 8
  store i64 %p0, ptr %slot.rel, align 8
  %slot.r = alloca i64, align 8
  store i64 0, ptr %slot.r, align 8
  %slot.parts = alloca i64, align 8
  store i64 0, ptr %slot.parts, align 8
  %slot.clean = alloca i64, align 8
  store i64 0, ptr %slot.clean, align 8
  %slot.i = alloca i64, align 8
  store i64 0, ptr %slot.i, align 8
  %slot.seg = alloca i64, align 8
  store i64 0, ptr %slot.seg, align 8
  %slot.__sc_261 = alloca i64, align 8
  store i64 0, ptr %slot.__sc_261, align 8
  %r0 = load i64, ptr %slot.rel, align 8
  store i64 %r0, ptr %slot.r, align 8
  %r1 = load i64, ptr %slot.r, align 8
  %r2.p = getelementptr inbounds [2 x i8], ptr @.str.22, i64 0, i64 0
  %r2 = ptrtoint ptr %r2.p to i64
  %r3 = call i64 @nova_rt_starts_with(i64 %r1, i64 %r2)
  %br_then2550 = icmp ne i64 %r3, 0
  br i1 %br_then2550, label %then255, label %else256
then255:
  %r4 = load i64, ptr %slot.r, align 8
  %r5 = add i64 1, 0
  %r6 = load i64, ptr %slot.r, align 8
  %r7 = call i64 @nova_rt_len_any(i64 %r6)
  %r8 = call i64 @nova_rt_slice(i64 %r4, i64 %r5, i64 %r7)
  store i64 %r8, ptr %slot.r, align 8
  br label %endif257
else256:
  br label %endif257
endif257:
  %r9 = load i64, ptr %slot.r, align 8
  %r10.p = getelementptr inbounds [2 x i8], ptr @.str.22, i64 0, i64 0
  %r10 = ptrtoint ptr %r10.p to i64
  %r11 = call i64 @nova_rt_split(i64 %r9, i64 %r10)
  store i64 %r11, ptr %slot.parts, align 8
  %r12.p = getelementptr inbounds [1 x i8], ptr @.str.24, i64 0, i64 0
  %r12 = ptrtoint ptr %r12.p to i64
  store i64 %r12, ptr %slot.clean, align 8
  %r13 = add i64 0, 0
  store i64 %r13, ptr %slot.i, align 8
  br label %while_hdr258
while_hdr258:
  %r14 = load i64, ptr %slot.i, align 8
  %r15 = load i64, ptr %slot.parts, align 8
  %r16.lp = inttoptr i64 %r15 to ptr
  %r16.szp = getelementptr i64, ptr %r16.lp, i64 1
  %r16 = load i64, ptr %r16.szp, align 8, !tbaa !6
  %r17.cmp = icmp slt i64 %r14, %r16
  %r17 = zext i1 %r17.cmp to i64
  %br_while_body2591 = icmp ne i64 %r17, 0
  br i1 %br_while_body2591, label %while_body259, label %while_exit260, !prof !90
while_body259:
  %r18 = load i64, ptr %slot.parts, align 8
  %r19 = load i64, ptr %slot.i, align 8
  %r20 = call i64 @nova_rt_index_get(i64 %r18, i64 %r19)
  store i64 %r20, ptr %slot.seg, align 8
  %r21 = load i64, ptr %slot.seg, align 8
  %r22.p = getelementptr inbounds [1 x i8], ptr @.str.24, i64 0, i64 0
  %r22 = ptrtoint ptr %r22.p to i64
  %r23.p0 = inttoptr i64 %r21 to ptr
  %r23.p1 = inttoptr i64 %r22 to ptr
  %r23.sc = call i32 @strcmp(ptr %r23.p0, ptr %r23.p1)
  %r23.cmp = icmp eq i32 %r23.sc, 0
  %r23 = zext i1 %r23.cmp to i64
  store i64 %r23, ptr %slot.__sc_261, align 8
  %br_or_merge2632 = icmp ne i64 %r23, 0
  br i1 %br_or_merge2632, label %or_merge263, label %or_rhs262
or_rhs262:
  %r24 = load i64, ptr %slot.seg, align 8
  %r25.p = getelementptr inbounds [2 x i8], ptr @.str.80, i64 0, i64 0
  %r25 = ptrtoint ptr %r25.p to i64
  %r26.p0 = inttoptr i64 %r24 to ptr
  %r26.p1 = inttoptr i64 %r25 to ptr
  %r26.sc = call i32 @strcmp(ptr %r26.p0, ptr %r26.p1)
  %r26.cmp = icmp eq i32 %r26.sc, 0
  %r26 = zext i1 %r26.cmp to i64
  store i64 %r26, ptr %slot.__sc_261, align 8
  br label %or_merge263
or_merge263:
  %r27 = load i64, ptr %slot.__sc_261, align 8
  %br_then2643 = icmp ne i64 %r27, 0
  br i1 %br_then2643, label %then264, label %else265
then264:
  %r28 = load i64, ptr %slot.i, align 8
  %r29 = add i64 1, 0
  %r30 = add i64 %r28, %r29
  store i64 %r30, ptr %slot.i, align 8
  br label %endif266
else265:
  %r31 = load i64, ptr %slot.seg, align 8
  %r32 = call i64 @_unsafe_segment(i64 %r31)
  %br_then2674 = icmp ne i64 %r32, 0
  br i1 %br_then2674, label %then267, label %else268
then267:
  %r33.p = getelementptr inbounds [20 x i8], ptr @.str.82, i64 0, i64 0
  %r33 = ptrtoint ptr %r33.p to i64
  %r34 = call i64 @nova_rt_err(i64 %r33)
  ret i64 %r34
else268:
  %r35 = load i64, ptr %slot.clean, align 8
  %r36.p = getelementptr inbounds [1 x i8], ptr @.str.24, i64 0, i64 0
  %r36 = ptrtoint ptr %r36.p to i64
  %r37.p0 = inttoptr i64 %r35 to ptr
  %r37.p1 = inttoptr i64 %r36 to ptr
  %r37.sc = call i32 @strcmp(ptr %r37.p0, ptr %r37.p1)
  %r37.cmp = icmp eq i32 %r37.sc, 0
  %r37 = zext i1 %r37.cmp to i64
  %br_then2705 = icmp ne i64 %r37, 0
  br i1 %br_then2705, label %then270, label %else271
then270:
  %r38 = load i64, ptr %slot.seg, align 8
  store i64 %r38, ptr %slot.clean, align 8
  br label %endif272
else271:
  %r39 = load i64, ptr %slot.clean, align 8
  %r40.p = getelementptr inbounds [2 x i8], ptr @.str.22, i64 0, i64 0
  %r40 = ptrtoint ptr %r40.p to i64
  %r41 = call i64 @nova_rt_str_concat(i64 %r39, i64 %r40)
  %r42 = load i64, ptr %slot.seg, align 8
  %r43 = call i64 @nova_rt_str_concat(i64 %r41, i64 %r42)
  store i64 %r43, ptr %slot.clean, align 8
  br label %endif272
endif272:
  %r44 = load i64, ptr %slot.i, align 8
  %r45 = add i64 1, 0
  %r46 = add i64 %r44, %r45
  store i64 %r46, ptr %slot.i, align 8
  br label %endif269
endif269:
  br label %endif266
endif266:
  br label %while_hdr258
while_exit260:
  %r47 = load i64, ptr %slot.clean, align 8
  %r48 = call i64 @nova_rt_ok(i64 %r47)
  ret i64 %r48
}

; ESCAPE _try_static: allocs=2 escape=0 local=2
define i64 @_try_static(i64 %p0, i64 %p1) nounwind uwtable {
entry:
  %slot.a = alloca i64, align 8
  store i64 %p0, ptr %slot.a, align 8
  %slot.req = alloca i64, align 8
  store i64 %p1, ptr %slot.req, align 8
  %slot.mounts = alloca i64, align 8
  store i64 0, ptr %slot.mounts, align 8
  %slot.i = alloca i64, align 8
  store i64 0, ptr %slot.i, align 8
  %slot.m = alloca i64, align 8
  store i64 0, ptr %slot.m, align 8
  %slot.prefix = alloca i64, align 8
  store i64 0, ptr %slot.prefix, align 8
  %slot.root = alloca i64, align 8
  store i64 0, ptr %slot.root, align 8
  %slot.safe = alloca i64, align 8
  store i64 0, ptr %slot.safe, align 8
  %slot.cleanrel = alloca i64, align 8
  store i64 0, ptr %slot.cleanrel, align 8
  %slot.fpath = alloca i64, align 8
  store i64 0, ptr %slot.fpath, align 8
  %slot.h = alloca i64, align 8
  store i64 0, ptr %slot.h, align 8
  %r0 = load i64, ptr %slot.a, align 8
  %r1.p = getelementptr inbounds [8 x i8], ptr @.str.59, i64 0, i64 0
  %r1 = ptrtoint ptr %r1.p to i64
  %r2 = call i64 @nova_rt_index_get(i64 %r0, i64 %r1)
  store i64 %r2, ptr %slot.mounts, align 8
  %r3 = add i64 0, 0
  store i64 %r3, ptr %slot.i, align 8
  br label %while_hdr273
while_hdr273:
  %r4 = load i64, ptr %slot.i, align 8
  %r5 = load i64, ptr %slot.mounts, align 8
  %r6 = call i64 @nova_rt_len_any(i64 %r5)
  %r7.cmp = icmp slt i64 %r4, %r6
  %r7 = zext i1 %r7.cmp to i64
  %br_while_body2740 = icmp ne i64 %r7, 0
  br i1 %br_while_body2740, label %while_body274, label %while_exit275, !prof !90
while_body274:
  %r8 = load i64, ptr %slot.mounts, align 8
  %r9 = load i64, ptr %slot.i, align 8
  %r10 = call i64 @nova_rt_index_get(i64 %r8, i64 %r9)
  store i64 %r10, ptr %slot.m, align 8
  %r11 = load i64, ptr %slot.m, align 8
  %r12 = add i64 0, 0
  %r13 = call i64 @nova_rt_index_get(i64 %r11, i64 %r12)
  store i64 %r13, ptr %slot.prefix, align 8
  %r14 = load i64, ptr %slot.m, align 8
  %r15 = add i64 1, 0
  %r16 = call i64 @nova_rt_index_get(i64 %r14, i64 %r15)
  store i64 %r16, ptr %slot.root, align 8
  %r17 = load i64, ptr %slot.req, align 8
  %r18.ptr = inttoptr i64 %r17 to ptr
  %r18.gep = getelementptr i64, ptr %r18.ptr, i64 2
  %r18 = load i64, ptr %r18.gep, align 8
  %r19 = load i64, ptr %slot.prefix, align 8
  %r20 = call i64 @nova_rt_starts_with(i64 %r18, i64 %r19)
  %br_then2761 = icmp ne i64 %r20, 0
  br i1 %br_then2761, label %then276, label %else277
then276:
  %r21 = load i64, ptr %slot.req, align 8
  %r22.ptr = inttoptr i64 %r21 to ptr
  %r22.gep = getelementptr i64, ptr %r22.ptr, i64 2
  %r22 = load i64, ptr %r22.gep, align 8
  %r23 = load i64, ptr %slot.prefix, align 8
  %r24 = call i64 @nova_rt_len_any(i64 %r23)
  %r25 = load i64, ptr %slot.req, align 8
  %r26.ptr = inttoptr i64 %r25 to ptr
  %r26.gep = getelementptr i64, ptr %r26.ptr, i64 2
  %r26 = load i64, ptr %r26.gep, align 8
  %r27 = call i64 @nova_rt_len_any(i64 %r26)
  %r28 = call i64 @nova_rt_slice(i64 %r22, i64 %r24, i64 %r27)
  %r29 = call i64 @_safe_subpath(i64 %r28)
  store i64 %r29, ptr %slot.safe, align 8
  %r30 = load i64, ptr %slot.safe, align 8
  %r31 = call i64 @nova_rt_is_ok(i64 %r30)
  %br_then2792 = icmp ne i64 %r31, 0
  br i1 %br_then2792, label %then279, label %else280
then279:
  %r32 = load i64, ptr %slot.safe, align 8
  %r33 = call i64 @nova_rt_unwrap(i64 %r32)
  store i64 %r33, ptr %slot.cleanrel, align 8
  %r34 = load i64, ptr %slot.cleanrel, align 8
  %r35.p = getelementptr inbounds [1 x i8], ptr @.str.24, i64 0, i64 0
  %r35 = ptrtoint ptr %r35.p to i64
  %r36.p0 = inttoptr i64 %r34 to ptr
  %r36.p1 = inttoptr i64 %r35 to ptr
  %r36.sc = call i32 @strcmp(ptr %r36.p0, ptr %r36.p1)
  %r36.cmp = icmp eq i32 %r36.sc, 0
  %r36 = zext i1 %r36.cmp to i64
  %br_then2823 = icmp ne i64 %r36, 0
  br i1 %br_then2823, label %then282, label %else283
then282:
  %r37.p = getelementptr inbounds [11 x i8], ptr @.str.83, i64 0, i64 0
  %r37 = ptrtoint ptr %r37.p to i64
  store i64 %r37, ptr %slot.cleanrel, align 8
  br label %endif284
else283:
  br label %endif284
endif284:
  %r38 = load i64, ptr %slot.root, align 8
  %r39.p = getelementptr inbounds [2 x i8], ptr @.str.22, i64 0, i64 0
  %r39 = ptrtoint ptr %r39.p to i64
  %r40 = call i64 @nova_rt_str_concat(i64 %r38, i64 %r39)
  %r41 = load i64, ptr %slot.cleanrel, align 8
  %r42 = call i64 @nova_rt_str_concat(i64 %r40, i64 %r41)
  store i64 %r42, ptr %slot.fpath, align 8
  %r43 = load i64, ptr %slot.fpath, align 8
  %r44 = call i64 @nova_rt_file_exists(i64 %r43)
  %br_then2854 = icmp ne i64 %r44, 0
  br i1 %br_then2854, label %then285, label %else286
then285:
  %r45 = call i64 @nova_rt_dict_create()
  store i64 %r45, ptr %slot.h, align 8
  %r46 = load i64, ptr %slot.cleanrel, align 8
  %r47 = call i64 @_ext_ctype(i64 %r46)
  %r48 = load i64, ptr %slot.h, align 8
  %r49.p = getelementptr inbounds [13 x i8], ptr @.str.76, i64 0, i64 0
  %r49 = ptrtoint ptr %r49.p to i64
  %_is.dv5 = call i64 @nova_rt_dict_set_no_rc(i64 %r48, i64 %r49, i64 %r47)
  %r50 = add i64 200, 0
  %r51 = load i64, ptr %slot.h, align 8
  %r52 = load i64, ptr %slot.fpath, align 8
  %r53 = call i64 @nova_rt_read_file(i64 %r52)
  %r54 = add i64 0, 0
  %r55.ptr = call ptr @nova_rt_struct_alloc(i64 40)
  %r55.thash = getelementptr i64, ptr %r55.ptr, i64 0
  store i64 7571514562849844, ptr %r55.thash, align 8
  %r55.f0 = getelementptr i64, ptr %r55.ptr, i64 1
  store i64 %r50, ptr %r55.f0, align 8
  %r55.f1 = getelementptr i64, ptr %r55.ptr, i64 2
  store i64 %r51, ptr %r55.f1, align 8
  %r55.f2 = getelementptr i64, ptr %r55.ptr, i64 3
  store i64 %r53, ptr %r55.f2, align 8
  %r55.f3 = getelementptr i64, ptr %r55.ptr, i64 4
  store i64 %r54, ptr %r55.f3, align 8
  %r55 = ptrtoint ptr %r55.ptr to i64
  %r56 = call i64 @nova_rt_ok(i64 %r55)
  ret i64 %r56
else286:
  br label %endif287
endif287:
  br label %endif281
else280:
  br label %endif281
endif281:
  br label %endif278
else277:
  br label %endif278
endif278:
  %r57 = load i64, ptr %slot.i, align 8
  %r58 = add i64 1, 0
  %r59 = add i64 %r57, %r58
  store i64 %r59, ptr %slot.i, align 8
  br label %while_hdr273
while_exit275:
  %r60.p = getelementptr inbounds [16 x i8], ptr @.str.84, i64 0, i64 0
  %r60 = ptrtoint ptr %r60.p to i64
  %r61 = call i64 @nova_rt_err(i64 %r60)
  ret i64 %r61
}

; ESCAPE _dispatch_terminal: allocs=0 escape=0 local=0
define i64 @_dispatch_terminal(i64 %p0, i64 %p1) nounwind uwtable {
entry:
  %slot.a = alloca i64, align 8
  store i64 %p0, ptr %slot.a, align 8
  %slot.req = alloca i64, align 8
  store i64 %p1, ptr %slot.req, align 8
  %slot.routes = alloca i64, align 8
  store i64 0, ptr %slot.routes, align 8
  %slot.other = alloca i64, align 8
  store i64 0, ptr %slot.other, align 8
  %slot.i = alloca i64, align 8
  store i64 0, ptr %slot.i, align 8
  %slot.rt = alloca i64, align 8
  store i64 0, ptr %slot.rt, align 8
  %slot.mr = alloca i64, align 8
  store i64 0, ptr %slot.mr, align 8
  %slot.__sc_294 = alloca i64, align 8
  store i64 0, ptr %slot.__sc_294, align 8
  %slot.h = alloca i64, align 8
  store i64 0, ptr %slot.h, align 8
  %slot.__sc_300 = alloca i64, align 8
  store i64 0, ptr %slot.__sc_300, align 8
  %slot.sr = alloca i64, align 8
  store i64 0, ptr %slot.sr, align 8
  %r0 = load i64, ptr %slot.a, align 8
  %r1.p = getelementptr inbounds [7 x i8], ptr @.str.57, i64 0, i64 0
  %r1 = ptrtoint ptr %r1.p to i64
  %r2 = call i64 @nova_rt_index_get(i64 %r0, i64 %r1)
  store i64 %r2, ptr %slot.routes, align 8
  %r3 = add i64 0, 0
  store i64 %r3, ptr %slot.other, align 8
  %r4 = add i64 0, 0
  store i64 %r4, ptr %slot.i, align 8
  br label %while_hdr288
while_hdr288:
  %r5 = load i64, ptr %slot.i, align 8
  %r6 = load i64, ptr %slot.routes, align 8
  %r7 = call i64 @nova_rt_len_any(i64 %r6)
  %r8.cmp = icmp slt i64 %r5, %r7
  %r8 = zext i1 %r8.cmp to i64
  %br_while_body2890 = icmp ne i64 %r8, 0
  br i1 %br_while_body2890, label %while_body289, label %while_exit290, !prof !90
while_body289:
  %r9 = load i64, ptr %slot.routes, align 8
  %r10 = load i64, ptr %slot.i, align 8
  %r11 = call i64 @nova_rt_index_get(i64 %r9, i64 %r10)
  store i64 %r11, ptr %slot.rt, align 8
  %r12 = load i64, ptr %slot.rt, align 8
  %r13 = add i64 1, 0
  %r14 = call i64 @nova_rt_index_get(i64 %r12, i64 %r13)
  %r15 = load i64, ptr %slot.req, align 8
  %r16.ptr = inttoptr i64 %r15 to ptr
  %r16.gep = getelementptr i64, ptr %r16.ptr, i64 2
  %r16 = load i64, ptr %r16.gep, align 8
  %r17 = call i64 @_fr_match(i64 %r14, i64 %r16)
  store i64 %r17, ptr %slot.mr, align 8
  %r18 = load i64, ptr %slot.mr, align 8
  %r19 = call i64 @nova_rt_is_ok(i64 %r18)
  %br_then2911 = icmp ne i64 %r19, 0
  br i1 %br_then2911, label %then291, label %else292
then291:
  %r20 = load i64, ptr %slot.rt, align 8
  %r21 = add i64 0, 0
  %r22 = call i64 @nova_rt_index_get(i64 %r20, i64 %r21)
  %r23 = load i64, ptr %slot.req, align 8
  %r24.ptr = inttoptr i64 %r23 to ptr
  %r24.gep = getelementptr i64, ptr %r24.ptr, i64 1
  %r24 = load i64, ptr %r24.gep, align 8
  %r25.p0 = inttoptr i64 %r22 to ptr
  %r25.p1 = inttoptr i64 %r24 to ptr
  %r25.sc = call i32 @strcmp(ptr %r25.p0, ptr %r25.p1)
  %r25.cmp = icmp eq i32 %r25.sc, 0
  %r25 = zext i1 %r25.cmp to i64
  store i64 %r25, ptr %slot.__sc_294, align 8
  %br_or_merge2962 = icmp ne i64 %r25, 0
  br i1 %br_or_merge2962, label %or_merge296, label %or_rhs295
or_rhs295:
  %r26 = load i64, ptr %slot.rt, align 8
  %r27 = add i64 0, 0
  %r28 = call i64 @nova_rt_index_get(i64 %r26, i64 %r27)
  %r29.p = getelementptr inbounds [2 x i8], ptr @.str.70, i64 0, i64 0
  %r29 = ptrtoint ptr %r29.p to i64
  %r30.p0 = inttoptr i64 %r28 to ptr
  %r30.p1 = inttoptr i64 %r29 to ptr
  %r30.sc = call i32 @strcmp(ptr %r30.p0, ptr %r30.p1)
  %r30.cmp = icmp eq i32 %r30.sc, 0
  %r30 = zext i1 %r30.cmp to i64
  store i64 %r30, ptr %slot.__sc_294, align 8
  br label %or_merge296
or_merge296:
  %r31 = load i64, ptr %slot.__sc_294, align 8
  %br_then2973 = icmp ne i64 %r31, 0
  br i1 %br_then2973, label %then297, label %else298
then297:
  %r32 = load i64, ptr %slot.mr, align 8
  %r33 = call i64 @nova_rt_unwrap(i64 %r32)
  %r34 = load i64, ptr %slot.req, align 8
  %r35.ptr = inttoptr i64 %r34 to ptr
  %r35.gep = getelementptr i64, ptr %r35.ptr, i64 4
  store i64 %r33, ptr %r35.gep, align 8
  %r36 = load i64, ptr %slot.rt, align 8
  %r37 = add i64 2, 0
  %r38 = call i64 @nova_rt_index_get(i64 %r36, i64 %r37)
  store i64 %r38, ptr %slot.h, align 8
  %r39 = load i64, ptr %slot.req, align 8
  %r41 = load i64, ptr %slot.h, align 8
  %r40.rec = inttoptr i64 %r41 to ptr
  %r40.fnraw = load i64, ptr %r40.rec, align 8
  %r40.fnptr = inttoptr i64 %r40.fnraw to ptr
  %r40 = call i64 %r40.fnptr(i64 %r41, i64 %r39)
  %r42 = call i64 @_coerce(i64 %r40)
  ret i64 %r42
else298:
  %r43 = add i64 1, 0
  store i64 %r43, ptr %slot.other, align 8
  br label %endif299
endif299:
  br label %endif293
else292:
  br label %endif293
endif293:
  %r44 = load i64, ptr %slot.i, align 8
  %r45 = add i64 1, 0
  %r46 = add i64 %r44, %r45
  store i64 %r46, ptr %slot.i, align 8
  br label %while_hdr288
while_exit290:
  %r47 = load i64, ptr %slot.req, align 8
  %r48.ptr = inttoptr i64 %r47 to ptr
  %r48.gep = getelementptr i64, ptr %r48.ptr, i64 1
  %r48 = load i64, ptr %r48.gep, align 8
  %r49.p = getelementptr inbounds [4 x i8], ptr @.str.21, i64 0, i64 0
  %r49 = ptrtoint ptr %r49.p to i64
  %r50.p0 = inttoptr i64 %r48 to ptr
  %r50.p1 = inttoptr i64 %r49 to ptr
  %r50.sc = call i32 @strcmp(ptr %r50.p0, ptr %r50.p1)
  %r50.cmp = icmp eq i32 %r50.sc, 0
  %r50 = zext i1 %r50.cmp to i64
  store i64 %r50, ptr %slot.__sc_300, align 8
  %br_or_merge3024 = icmp ne i64 %r50, 0
  br i1 %br_or_merge3024, label %or_merge302, label %or_rhs301
or_rhs301:
  %r51 = load i64, ptr %slot.req, align 8
  %r52.ptr = inttoptr i64 %r51 to ptr
  %r52.gep = getelementptr i64, ptr %r52.ptr, i64 1
  %r52 = load i64, ptr %r52.gep, align 8
  %r53.p = getelementptr inbounds [5 x i8], ptr @.str.85, i64 0, i64 0
  %r53 = ptrtoint ptr %r53.p to i64
  %r54.p0 = inttoptr i64 %r52 to ptr
  %r54.p1 = inttoptr i64 %r53 to ptr
  %r54.sc = call i32 @strcmp(ptr %r54.p0, ptr %r54.p1)
  %r54.cmp = icmp eq i32 %r54.sc, 0
  %r54 = zext i1 %r54.cmp to i64
  store i64 %r54, ptr %slot.__sc_300, align 8
  br label %or_merge302
or_merge302:
  %r55 = load i64, ptr %slot.__sc_300, align 8
  %br_then3035 = icmp ne i64 %r55, 0
  br i1 %br_then3035, label %then303, label %else304
then303:
  %r56 = load i64, ptr %slot.a, align 8
  %r57 = load i64, ptr %slot.req, align 8
  %r58 = call i64 @_try_static(i64 %r56, i64 %r57)
  store i64 %r58, ptr %slot.sr, align 8
  %r59 = load i64, ptr %slot.sr, align 8
  %r60 = call i64 @nova_rt_is_ok(i64 %r59)
  %br_then3066 = icmp ne i64 %r60, 0
  br i1 %br_then3066, label %then306, label %else307
then306:
  %r61 = load i64, ptr %slot.sr, align 8
  %r62 = call i64 @nova_rt_unwrap(i64 %r61)
  ret i64 %r62
else307:
  br label %endif308
endif308:
  br label %endif305
else304:
  br label %endif305
endif305:
  %r63 = load i64, ptr %slot.other, align 8
  %r64 = add i64 1, 0
  %r65.cmp = icmp eq i64 %r63, %r64
  %r65 = zext i1 %r65.cmp to i64
  %br_then3097 = icmp ne i64 %r65, 0
  br i1 %br_then3097, label %then309, label %else310
then309:
  %r66 = add i64 405, 0
  %r67.p = getelementptr inbounds [19 x i8], ptr @.str.72, i64 0, i64 0
  %r67 = ptrtoint ptr %r67.p to i64
  %r68 = call i64 @resp_text(i64 %r66, i64 %r67)
  ret i64 %r68
else310:
  br label %endif311
endif311:
  %r69 = add i64 404, 0
  %r70.p = getelementptr inbounds [11 x i8], ptr @.str.73, i64 0, i64 0
  %r70 = ptrtoint ptr %r70.p to i64
  %r71 = load i64, ptr %slot.req, align 8
  %r72.ptr = inttoptr i64 %r71 to ptr
  %r72.gep = getelementptr i64, ptr %r72.ptr, i64 1
  %r72 = load i64, ptr %r72.gep, align 8
  %r73 = call i64 @nova_rt_str_concat(i64 %r70, i64 %r72)
  %r74.p = getelementptr inbounds [2 x i8], ptr @.str.20, i64 0, i64 0
  %r74 = ptrtoint ptr %r74.p to i64
  %r75 = call i64 @nova_rt_str_concat(i64 %r73, i64 %r74)
  %r76 = load i64, ptr %slot.req, align 8
  %r77.ptr = inttoptr i64 %r76 to ptr
  %r77.gep = getelementptr i64, ptr %r77.ptr, i64 2
  %r77 = load i64, ptr %r77.gep, align 8
  %r78 = call i64 @nova_rt_str_concat(i64 %r75, i64 %r77)
  %r79 = call i64 @resp_text(i64 %r69, i64 %r78)
  ret i64 %r79
}

; ESCAPE _t_wrap: allocs=0 escape=0 local=0
define i64 @_t_wrap(i64 %p0, i64 %p1) nounwind uwtable {
entry:
  %slot.mw = alloca i64, align 8
  store i64 %p0, ptr %slot.mw, align 8
  %slot.next = alloca i64, align 8
  store i64 %p1, ptr %slot.next, align 8
  %r0 = load i64, ptr %slot.mw, align 8
  %r1 = load i64, ptr %slot.next, align 8
  %r2.ptr = call ptr @nova_rt_struct_alloc(i64 24)
  %r2.tgep = getelementptr i64, ptr %r2.ptr, i64 0
  %r2.tfn = ptrtoint ptr @__tramp_7 to i64
  store i64 %r2.tfn, ptr %r2.tgep, align 8
  %r2.c0 = getelementptr i64, ptr %r2.ptr, i64 1
  store i64 %r0, ptr %r2.c0, align 8
  %r2.c1 = getelementptr i64, ptr %r2.ptr, i64 2
  store i64 %r1, ptr %r2.c1, align 8
  %r2 = ptrtoint ptr %r2.ptr to i64
  ret i64 %r2
}

; ESCAPE dispatch_req: allocs=0 escape=0 local=0
define i64 @dispatch_req(i64 %p0, i64 %p1) nounwind uwtable {
entry:
  %slot.a = alloca i64, align 8
  store i64 %p0, ptr %slot.a, align 8
  %slot.req = alloca i64, align 8
  store i64 %p1, ptr %slot.req, align 8
  %slot.h = alloca i64, align 8
  store i64 0, ptr %slot.h, align 8
  %slot.mws = alloca i64, align 8
  store i64 0, ptr %slot.mws, align 8
  %slot.i = alloca i64, align 8
  store i64 0, ptr %slot.i, align 8
  %r0 = load i64, ptr %slot.a, align 8
  %r1.ptr = call ptr @nova_rt_struct_alloc(i64 16)
  %r1.tgep = getelementptr i64, ptr %r1.ptr, i64 0
  %r1.tfn = ptrtoint ptr @__tramp_8 to i64
  store i64 %r1.tfn, ptr %r1.tgep, align 8
  %r1.c0 = getelementptr i64, ptr %r1.ptr, i64 1
  store i64 %r0, ptr %r1.c0, align 8
  %r1 = ptrtoint ptr %r1.ptr to i64
  store i64 %r1, ptr %slot.h, align 8
  %r2 = load i64, ptr %slot.a, align 8
  %r3.p = getelementptr inbounds [4 x i8], ptr @.str.58, i64 0, i64 0
  %r3 = ptrtoint ptr %r3.p to i64
  %r4 = call i64 @nova_rt_dict_get(i64 %r2, i64 %r3)
  store i64 %r4, ptr %slot.mws, align 8
  %r5 = load i64, ptr %slot.mws, align 8
  %r6 = call i64 @nova_rt_len_any(i64 %r5)
  %r7 = add i64 1, 0
  %r8 = sub i64 %r6, %r7
  store i64 %r8, ptr %slot.i, align 8
  br label %while_hdr312
while_hdr312:
  %r9 = load i64, ptr %slot.i, align 8
  %r10 = add i64 0, 0
  %r11.cmp = icmp sge i64 %r9, %r10
  %r11 = zext i1 %r11.cmp to i64
  %br_while_body3130 = icmp ne i64 %r11, 0
  br i1 %br_while_body3130, label %while_body313, label %while_exit314, !prof !90
while_body313:
  %r12 = load i64, ptr %slot.mws, align 8
  %r13 = load i64, ptr %slot.i, align 8
  %r14 = call i64 @nova_rt_index_get(i64 %r12, i64 %r13)
  %r15 = load i64, ptr %slot.h, align 8
  %r16 = call i64 @_t_wrap(i64 %r14, i64 %r15)
  store i64 %r16, ptr %slot.h, align 8
  %r17 = load i64, ptr %slot.i, align 8
  %r18 = add i64 1, 0
  %r19 = sub i64 %r17, %r18
  store i64 %r19, ptr %slot.i, align 8
  br label %while_hdr312
while_exit314:
  %r20 = load i64, ptr %slot.req, align 8
  %r22 = load i64, ptr %slot.h, align 8
  %r21.rec = inttoptr i64 %r22 to ptr
  %r21.fnraw = load i64, ptr %r21.rec, align 8
  %r21.fnptr = inttoptr i64 %r21.fnraw to ptr
  %r21 = call i64 %r21.fnptr(i64 %r22, i64 %r20)
  ret i64 %r21
}

; ESCAPE mw_set_header: allocs=0 escape=0 local=0
define i64 @mw_set_header(i64 %p0, i64 %p1) nounwind uwtable {
entry:
  %slot.name = alloca i64, align 8
  store i64 %p0, ptr %slot.name, align 8
  %slot.value = alloca i64, align 8
  store i64 %p1, ptr %slot.value, align 8
  %r0 = load i64, ptr %slot.name, align 8
  %r1 = load i64, ptr %slot.value, align 8
  %r2.ptr = call ptr @nova_rt_struct_alloc(i64 24)
  %r2.tgep = getelementptr i64, ptr %r2.ptr, i64 0
  %r2.tfn = ptrtoint ptr @__tramp_9 to i64
  store i64 %r2.tfn, ptr %r2.tgep, align 8
  %r2.c0 = getelementptr i64, ptr %r2.ptr, i64 1
  store i64 %r0, ptr %r2.c0, align 8
  %r2.c1 = getelementptr i64, ptr %r2.ptr, i64 2
  store i64 %r1, ptr %r2.c1, align 8
  %r2 = ptrtoint ptr %r2.ptr to i64
  ret i64 %r2
}

; ESCAPE mw_cors_origin: allocs=0 escape=0 local=0
define i64 @mw_cors_origin(i64 %p0) nounwind uwtable {
entry:
  %slot.origin = alloca i64, align 8
  store i64 %p0, ptr %slot.origin, align 8
  %r0 = load i64, ptr %slot.origin, align 8
  %r1.ptr = call ptr @nova_rt_struct_alloc(i64 16)
  %r1.tgep = getelementptr i64, ptr %r1.ptr, i64 0
  %r1.tfn = ptrtoint ptr @__tramp_10 to i64
  store i64 %r1.tfn, ptr %r1.tgep, align 8
  %r1.c0 = getelementptr i64, ptr %r1.ptr, i64 1
  store i64 %r0, ptr %r1.c0, align 8
  %r1 = ptrtoint ptr %r1.ptr to i64
  ret i64 %r1
}

; ESCAPE _t_log_next: allocs=0 escape=0 local=0
define i64 @_t_log_next(i64 %p0, i64 %p1) nounwind uwtable {
entry:
  %slot.req = alloca i64, align 8
  store i64 %p0, ptr %slot.req, align 8
  %slot.next = alloca i64, align 8
  store i64 %p1, ptr %slot.next, align 8
  %r0.p = getelementptr inbounds [9 x i8], ptr @.str.75, i64 0, i64 0
  %r0 = ptrtoint ptr %r0.p to i64
  %r1 = load i64, ptr %slot.req, align 8
  %r2.ptr = inttoptr i64 %r1 to ptr
  %r2.gep = getelementptr i64, ptr %r2.ptr, i64 1
  %r2 = load i64, ptr %r2.gep, align 8
  %r3 = call i64 @nova_rt_str_concat(i64 %r0, i64 %r2)
  %r4.p = getelementptr inbounds [2 x i8], ptr @.str.20, i64 0, i64 0
  %r4 = ptrtoint ptr %r4.p to i64
  %r5 = call i64 @nova_rt_str_concat(i64 %r3, i64 %r4)
  %r6 = load i64, ptr %slot.req, align 8
  %r7.ptr = inttoptr i64 %r6 to ptr
  %r7.gep = getelementptr i64, ptr %r7.ptr, i64 2
  %r7 = load i64, ptr %r7.gep, align 8
  %r8 = call i64 @nova_rt_str_concat(i64 %r5, i64 %r7)
  %r9 = call i64 @nova_rt_print_str(i64 %r8)
  %r10 = load i64, ptr %slot.req, align 8
  %r12 = load i64, ptr %slot.next, align 8
  %r11.rec = inttoptr i64 %r12 to ptr
  %r11.fnraw = load i64, ptr %r11.rec, align 8
  %r11.fnptr = inttoptr i64 %r11.fnraw to ptr
  %r11 = call i64 %r11.fnptr(i64 %r12, i64 %r10)
  ret i64 %r11
}

; ESCAPE mw_log: allocs=0 escape=0 local=0
define i64 @mw_log() nounwind uwtable {
entry:
  %r0.ptr = call ptr @nova_rt_struct_alloc(i64 8)
  %r0.tgep = getelementptr i64, ptr %r0.ptr, i64 0
  %r0.tfn = ptrtoint ptr @__tramp_11 to i64
  store i64 %r0.tfn, ptr %r0.tgep, align 8
  %r0 = ptrtoint ptr %r0.ptr to i64
  ret i64 %r0
}

; ESCAPE _handle_req_arena: allocs=0 escape=0 local=0
define i64 @_handle_req_arena(i64 %p0, i64 %p1) nounwind uwtable {
entry:
  %slot.conn = alloca i64, align 8
  store i64 %p0, ptr %slot.conn, align 8
  %slot.a = alloca i64, align 8
  store i64 %p1, ptr %slot.a, align 8
  %slot.prev = alloca i64, align 8
  store i64 0, ptr %slot.prev, align 8
  %slot.raw = alloca i64, align 8
  store i64 0, ptr %slot.raw, align 8
  %slot.req = alloca i64, align 8
  store i64 0, ptr %slot.req, align 8
  %slot.resp = alloca i64, align 8
  store i64 0, ptr %slot.resp, align 8
  %r0 = call i64 @nova_rt_arena_scope_enter()
  store i64 %r0, ptr %slot.prev, align 8
  %r1 = load i64, ptr %slot.conn, align 8
  %r2 = call i64 @recv_request(i64 %r1)
  store i64 %r2, ptr %slot.raw, align 8
  %r3 = load i64, ptr %slot.raw, align 8
  %r4 = load i64, ptr %slot.conn, align 8
  %r5 = call i64 @build_request(i64 %r3, i64 %r4)
  store i64 %r5, ptr %slot.req, align 8
  %r6 = load i64, ptr %slot.a, align 8
  %r7 = load i64, ptr %slot.req, align 8
  %r8 = call i64 @dispatch_req(i64 %r6, i64 %r7)
  store i64 %r8, ptr %slot.resp, align 8
  %r9 = load i64, ptr %slot.conn, align 8
  %r10 = load i64, ptr %slot.resp, align 8
  %r11 = call i64 @finalize(i64 %r10)
  %r12 = call i64 @nova_rt_tcp_send(i64 %r9, i64 %r11)
  %r13 = load i64, ptr %slot.prev, align 8
  %r14 = call i64 @nova_rt_arena_scope_exit(i64 %r13)
  %r15 = load i64, ptr %slot.conn, align 8
  %r16 = call i64 @nova_rt_tcp_close(i64 %r15)
  ret i64 %r16
}

; ESCAPE _handle_req_done: allocs=0 escape=0 local=0
define i64 @_handle_req_done(i64 %p0, i64 %p1, i64 %p2) nounwind uwtable {
entry:
  %slot.conn = alloca i64, align 8
  store i64 %p0, ptr %slot.conn, align 8
  %slot.a = alloca i64, align 8
  store i64 %p1, ptr %slot.a, align 8
  %slot.done = alloca i64, align 8
  store i64 %p2, ptr %slot.done, align 8
  %r0 = load i64, ptr %slot.conn, align 8
  %r1 = load i64, ptr %slot.a, align 8
  %r2 = call i64 @_handle_req_arena(i64 %r0, i64 %r1)
  %r3 = load i64, ptr %slot.done, align 8
  %r4 = add i64 1, 0
  %r5 = call i64 @nova_rt_channel_send(i64 %r3, i64 %r4)
  ret i64 %r5
}

; ESCAPE serve_req_n: allocs=0 escape=0 local=0
define i64 @serve_req_n(i64 %p0, i64 %p1, i64 %p2) nounwind uwtable {
entry:
  %slot.a = alloca i64, align 8
  store i64 %p0, ptr %slot.a, align 8
  %slot.port = alloca i64, align 8
  store i64 %p1, ptr %slot.port, align 8
  %slot.n = alloca i64, align 8
  store i64 %p2, ptr %slot.n, align 8
  %slot.listener = alloca i64, align 8
  store i64 0, ptr %slot.listener, align 8
  %slot.done = alloca i64, align 8
  store i64 0, ptr %slot.done, align 8
  %slot.i = alloca i64, align 8
  store i64 0, ptr %slot.i, align 8
  %slot.conn = alloca i64, align 8
  store i64 0, ptr %slot.conn, align 8
  %slot.c = alloca i64, align 8
  store i64 0, ptr %slot.c, align 8
  %slot.ap = alloca i64, align 8
  store i64 0, ptr %slot.ap, align 8
  %slot.dc = alloca i64, align 8
  store i64 0, ptr %slot.dc, align 8
  %slot.j = alloca i64, align 8
  store i64 0, ptr %slot.j, align 8
  %r0 = load i64, ptr %slot.port, align 8
  %r1 = call i64 @nova_rt_tcp_listen(i64 %r0)
  store i64 %r1, ptr %slot.listener, align 8
  %r2 = call i64 @nova_rt_channel_create()
  store i64 %r2, ptr %slot.done, align 8
  %r3 = add i64 0, 0
  store i64 %r3, ptr %slot.i, align 8
  br label %while_hdr315
while_hdr315:
  %r4 = load i64, ptr %slot.i, align 8
  %r5 = load i64, ptr %slot.n, align 8
  %r6.cmp = icmp slt i64 %r4, %r5
  %r6 = zext i1 %r6.cmp to i64
  %br_while_body3160 = icmp ne i64 %r6, 0
  br i1 %br_while_body3160, label %while_body316, label %while_exit317, !prof !90
while_body316:
  %r7 = load i64, ptr %slot.listener, align 8
  %r8 = call i64 @nova_rt_tcp_accept(i64 %r7)
  store i64 %r8, ptr %slot.conn, align 8
  %r9 = load i64, ptr %slot.conn, align 8
  %r10 = add i64 0, 0
  %r11 = call i64 @nova_rt_ge(i64 %r9, i64 %r10)
  %br_then3181 = icmp ne i64 %r11, 0
  br i1 %br_then3181, label %then318, label %else319
then318:
  %r12 = load i64, ptr %slot.conn, align 8
  store i64 %r12, ptr %slot.c, align 8
  %r13 = load i64, ptr %slot.a, align 8
  store i64 %r13, ptr %slot.ap, align 8
  %r14 = load i64, ptr %slot.done, align 8
  store i64 %r14, ptr %slot.dc, align 8
  %r15 = load i64, ptr %slot.c, align 8
  %r16 = load i64, ptr %slot.ap, align 8
  %r17 = load i64, ptr %slot.dc, align 8
  %r18.ptr = call ptr @nova_rt_struct_alloc(i64 32)
  %r18.tgep = getelementptr i64, ptr %r18.ptr, i64 0
  %r18.tfn = ptrtoint ptr @__tramp_12 to i64
  store i64 %r18.tfn, ptr %r18.tgep, align 8
  %r18.c0 = getelementptr i64, ptr %r18.ptr, i64 1
  store i64 %r15, ptr %r18.c0, align 8
  %r18.c1 = getelementptr i64, ptr %r18.ptr, i64 2
  store i64 %r16, ptr %r18.c1, align 8
  %r18.c2 = getelementptr i64, ptr %r18.ptr, i64 3
  store i64 %r17, ptr %r18.c2, align 8
  %r18 = ptrtoint ptr %r18.ptr to i64
  %r19 = call i64 @nova_rt_sched_spawn(i64 %r18)
  br label %endif320
else319:
  br label %endif320
endif320:
  %r20 = load i64, ptr %slot.i, align 8
  %r21 = add i64 1, 0
  %r22 = add i64 %r20, %r21
  store i64 %r22, ptr %slot.i, align 8
  br label %while_hdr315
while_exit317:
  %r23 = add i64 0, 0
  store i64 %r23, ptr %slot.j, align 8
  br label %while_hdr321
while_hdr321:
  %r24 = load i64, ptr %slot.j, align 8
  %r25 = load i64, ptr %slot.n, align 8
  %r26.cmp = icmp slt i64 %r24, %r25
  %r26 = zext i1 %r26.cmp to i64
  %br_while_body3222 = icmp ne i64 %r26, 0
  br i1 %br_while_body3222, label %while_body322, label %while_exit323, !prof !90
while_body322:
  %r27 = load i64, ptr %slot.done, align 8
  %r28 = call i64 @nova_rt_channel_recv(i64 %r27)
  %r29 = load i64, ptr %slot.j, align 8
  %r30 = add i64 1, 0
  %r31 = add i64 %r29, %r30
  store i64 %r31, ptr %slot.j, align 8
  br label %while_hdr321
while_exit323:
  %r32 = load i64, ptr %slot.listener, align 8
  %r33 = call i64 @nova_rt_tcp_close(i64 %r32)
  ret i64 %r33
}

; ESCAPE serve_req: allocs=0 escape=0 local=0
define i64 @serve_req(i64 %p0, i64 %p1) nounwind uwtable {
entry:
  %slot.a = alloca i64, align 8
  store i64 %p0, ptr %slot.a, align 8
  %slot.port = alloca i64, align 8
  store i64 %p1, ptr %slot.port, align 8
  %slot.listener = alloca i64, align 8
  store i64 0, ptr %slot.listener, align 8
  %slot.conn = alloca i64, align 8
  store i64 0, ptr %slot.conn, align 8
  %slot.c = alloca i64, align 8
  store i64 0, ptr %slot.c, align 8
  %slot.ap = alloca i64, align 8
  store i64 0, ptr %slot.ap, align 8
  %r0 = load i64, ptr %slot.port, align 8
  %r1 = call i64 @nova_rt_tcp_listen(i64 %r0)
  store i64 %r1, ptr %slot.listener, align 8
  br label %while_hdr324
while_hdr324:
  %r2 = add i64 1, 0
  %br_while_body3250 = icmp ne i64 %r2, 0
  br i1 %br_while_body3250, label %while_body325, label %while_exit326, !prof !90
while_body325:
  %r3 = load i64, ptr %slot.listener, align 8
  %r4 = call i64 @nova_rt_tcp_accept(i64 %r3)
  store i64 %r4, ptr %slot.conn, align 8
  %r5 = load i64, ptr %slot.conn, align 8
  %r6 = add i64 0, 0
  %r7 = call i64 @nova_rt_ge(i64 %r5, i64 %r6)
  %br_then3271 = icmp ne i64 %r7, 0
  br i1 %br_then3271, label %then327, label %else328
then327:
  %r8 = load i64, ptr %slot.conn, align 8
  store i64 %r8, ptr %slot.c, align 8
  %r9 = load i64, ptr %slot.a, align 8
  store i64 %r9, ptr %slot.ap, align 8
  %r10 = load i64, ptr %slot.c, align 8
  %r11 = load i64, ptr %slot.ap, align 8
  %r12.ptr = call ptr @nova_rt_struct_alloc(i64 24)
  %r12.tgep = getelementptr i64, ptr %r12.ptr, i64 0
  %r12.tfn = ptrtoint ptr @__tramp_13 to i64
  store i64 %r12.tfn, ptr %r12.tgep, align 8
  %r12.c0 = getelementptr i64, ptr %r12.ptr, i64 1
  store i64 %r10, ptr %r12.c0, align 8
  %r12.c1 = getelementptr i64, ptr %r12.ptr, i64 2
  store i64 %r11, ptr %r12.c1, align 8
  %r12 = ptrtoint ptr %r12.ptr to i64
  %r13 = call i64 @nova_rt_sched_spawn(i64 %r12)
  br label %endif329
else328:
  br label %endif329
endif329:
  br label %while_hdr324
while_exit326:
  ret i64 0
}

; ESCAPE _dispatch_run: allocs=0 escape=0 local=0
define i64 @_dispatch_run(i64 %p0, i64 %p1, i64 %p2) nounwind uwtable {
entry:
  %slot.a = alloca i64, align 8
  store i64 %p0, ptr %slot.a, align 8
  %slot.req = alloca i64, align 8
  store i64 %p1, ptr %slot.req, align 8
  %slot.rc = alloca i64, align 8
  store i64 %p2, ptr %slot.rc, align 8
  %slot.r = alloca i64, align 8
  store i64 0, ptr %slot.r, align 8
  %r0 = load i64, ptr %slot.a, align 8
  %r1 = load i64, ptr %slot.req, align 8
  %r2 = call i64 @dispatch_req(i64 %r0, i64 %r1)
  store i64 %r2, ptr %slot.r, align 8
  %r3 = load i64, ptr %slot.rc, align 8
  %r4 = load i64, ptr %slot.r, align 8
  %r5 = call i64 @nova_rt_channel_send_move(i64 %r3, i64 %r4)
  ret i64 %r5
}

; ESCAPE dispatch_safe: allocs=0 escape=0 local=0
define i64 @dispatch_safe(i64 %p0, i64 %p1) nounwind uwtable {
entry:
  %slot.a = alloca i64, align 8
  store i64 %p0, ptr %slot.a, align 8
  %slot.req = alloca i64, align 8
  store i64 %p1, ptr %slot.req, align 8
  %slot.rc = alloca i64, align 8
  store i64 0, ptr %slot.rc, align 8
  %slot.ap = alloca i64, align 8
  store i64 0, ptr %slot.ap, align 8
  %slot.rq = alloca i64, align 8
  store i64 0, ptr %slot.rq, align 8
  %slot.c = alloca i64, align 8
  store i64 0, ptr %slot.c, align 8
  %slot.p = alloca i64, align 8
  store i64 0, ptr %slot.p, align 8
  %slot.m = alloca i64, align 8
  store i64 0, ptr %slot.m, align 8
  %slot.st = alloca i64, align 8
  store i64 0, ptr %slot.st, align 8
  %r0 = call i64 @nova_rt_channel_create()
  store i64 %r0, ptr %slot.rc, align 8
  %r1 = load i64, ptr %slot.a, align 8
  store i64 %r1, ptr %slot.ap, align 8
  %r2 = load i64, ptr %slot.req, align 8
  store i64 %r2, ptr %slot.rq, align 8
  %r3 = load i64, ptr %slot.rc, align 8
  store i64 %r3, ptr %slot.c, align 8
  %r4 = load i64, ptr %slot.ap, align 8
  %r5 = load i64, ptr %slot.rq, align 8
  %r6 = load i64, ptr %slot.c, align 8
  %r7.ptr = call ptr @nova_rt_struct_alloc(i64 32)
  %r7.tgep = getelementptr i64, ptr %r7.ptr, i64 0
  %r7.tfn = ptrtoint ptr @__ntramp___spawn_call_14 to i64
  store i64 %r7.tfn, ptr %r7.tgep, align 8
  %r7.c0 = getelementptr i64, ptr %r7.ptr, i64 1
  store i64 %r4, ptr %r7.c0, align 8
  %r7.c1 = getelementptr i64, ptr %r7.ptr, i64 2
  store i64 %r5, ptr %r7.c1, align 8
  %r7.c2 = getelementptr i64, ptr %r7.ptr, i64 3
  store i64 %r6, ptr %r7.c2, align 8
  %r7 = ptrtoint ptr %r7.ptr to i64
  %r8.ptr = inttoptr i64 %r7 to ptr
  %r8.gep = getelementptr i64, ptr %r8.ptr, i64 0
  %r8 = load i64, ptr %r8.gep, align 8
  %r9 = call i64 @nova_rt_spawn(i64 %r8, i64 %r7)
  store i64 %r9, ptr %slot.p, align 8
  %r10 = load i64, ptr %slot.p, align 8
  %r11 = call i64 @nova_rt_monitor(i64 %r10)
  store i64 %r11, ptr %slot.m, align 8
  %r12 = load i64, ptr %slot.m, align 8
  %r13 = call i64 @nova_rt_channel_recv(i64 %r12)
  store i64 %r13, ptr %slot.st, align 8
  %r14 = load i64, ptr %slot.st, align 8
  %r15 = add i64 0, 0
  %r16 = call i64 @nova_rt_eq(i64 %r14, i64 %r15)
  %br_then3300 = icmp ne i64 %r16, 0
  br i1 %br_then3300, label %then330, label %else331
then330:
  %r17 = load i64, ptr %slot.rc, align 8
  %r18 = call i64 @nova_rt_channel_recv(i64 %r17)
  ret i64 %r18
else331:
  br label %endif332
endif332:
  %r19 = add i64 500, 0
  %r20.p = getelementptr inbounds [22 x i8], ptr @.str.86, i64 0, i64 0
  %r20 = ptrtoint ptr %r20.p to i64
  %r21 = call i64 @resp_text(i64 %r19, i64 %r20)
  ret i64 %r21
}

; ESCAPE _handle_req_safe: allocs=0 escape=0 local=0
define i64 @_handle_req_safe(i64 %p0, i64 %p1) nounwind uwtable {
entry:
  %slot.conn = alloca i64, align 8
  store i64 %p0, ptr %slot.conn, align 8
  %slot.a = alloca i64, align 8
  store i64 %p1, ptr %slot.a, align 8
  %slot.prev = alloca i64, align 8
  store i64 0, ptr %slot.prev, align 8
  %slot.raw = alloca i64, align 8
  store i64 0, ptr %slot.raw, align 8
  %slot.req = alloca i64, align 8
  store i64 0, ptr %slot.req, align 8
  %slot.resp = alloca i64, align 8
  store i64 0, ptr %slot.resp, align 8
  %r0 = call i64 @nova_rt_arena_scope_enter()
  store i64 %r0, ptr %slot.prev, align 8
  %r1 = load i64, ptr %slot.conn, align 8
  %r2 = call i64 @recv_request(i64 %r1)
  store i64 %r2, ptr %slot.raw, align 8
  %r3 = load i64, ptr %slot.raw, align 8
  %r4 = load i64, ptr %slot.conn, align 8
  %r5 = call i64 @build_request(i64 %r3, i64 %r4)
  store i64 %r5, ptr %slot.req, align 8
  %r6 = load i64, ptr %slot.a, align 8
  %r7 = load i64, ptr %slot.req, align 8
  %r8 = call i64 @dispatch_safe(i64 %r6, i64 %r7)
  store i64 %r8, ptr %slot.resp, align 8
  %r9 = load i64, ptr %slot.conn, align 8
  %r10 = load i64, ptr %slot.resp, align 8
  %r11 = call i64 @finalize(i64 %r10)
  %r12 = call i64 @nova_rt_tcp_send(i64 %r9, i64 %r11)
  %r13 = load i64, ptr %slot.prev, align 8
  %r14 = call i64 @nova_rt_arena_scope_exit(i64 %r13)
  %r15 = load i64, ptr %slot.conn, align 8
  %r16 = call i64 @nova_rt_tcp_close(i64 %r15)
  ret i64 %r16
}

; ESCAPE _handle_req_safe_done: allocs=0 escape=0 local=0
define i64 @_handle_req_safe_done(i64 %p0, i64 %p1, i64 %p2) nounwind uwtable {
entry:
  %slot.conn = alloca i64, align 8
  store i64 %p0, ptr %slot.conn, align 8
  %slot.a = alloca i64, align 8
  store i64 %p1, ptr %slot.a, align 8
  %slot.done = alloca i64, align 8
  store i64 %p2, ptr %slot.done, align 8
  %r0 = load i64, ptr %slot.conn, align 8
  %r1 = load i64, ptr %slot.a, align 8
  %r2 = call i64 @_handle_req_safe(i64 %r0, i64 %r1)
  %r3 = load i64, ptr %slot.done, align 8
  %r4 = add i64 1, 0
  %r5 = call i64 @nova_rt_channel_send(i64 %r3, i64 %r4)
  ret i64 %r5
}

; ESCAPE serve_safe_req_n: allocs=0 escape=0 local=0
define i64 @serve_safe_req_n(i64 %p0, i64 %p1, i64 %p2) nounwind uwtable {
entry:
  %slot.a = alloca i64, align 8
  store i64 %p0, ptr %slot.a, align 8
  %slot.port = alloca i64, align 8
  store i64 %p1, ptr %slot.port, align 8
  %slot.n = alloca i64, align 8
  store i64 %p2, ptr %slot.n, align 8
  %slot.listener = alloca i64, align 8
  store i64 0, ptr %slot.listener, align 8
  %slot.done = alloca i64, align 8
  store i64 0, ptr %slot.done, align 8
  %slot.i = alloca i64, align 8
  store i64 0, ptr %slot.i, align 8
  %slot.conn = alloca i64, align 8
  store i64 0, ptr %slot.conn, align 8
  %slot.c = alloca i64, align 8
  store i64 0, ptr %slot.c, align 8
  %slot.ap = alloca i64, align 8
  store i64 0, ptr %slot.ap, align 8
  %slot.dc = alloca i64, align 8
  store i64 0, ptr %slot.dc, align 8
  %slot.j = alloca i64, align 8
  store i64 0, ptr %slot.j, align 8
  %r0 = load i64, ptr %slot.port, align 8
  %r1 = call i64 @nova_rt_tcp_listen(i64 %r0)
  store i64 %r1, ptr %slot.listener, align 8
  %r2 = call i64 @nova_rt_channel_create()
  store i64 %r2, ptr %slot.done, align 8
  %r3 = add i64 0, 0
  store i64 %r3, ptr %slot.i, align 8
  br label %while_hdr333
while_hdr333:
  %r4 = load i64, ptr %slot.i, align 8
  %r5 = load i64, ptr %slot.n, align 8
  %r6.cmp = icmp slt i64 %r4, %r5
  %r6 = zext i1 %r6.cmp to i64
  %br_while_body3340 = icmp ne i64 %r6, 0
  br i1 %br_while_body3340, label %while_body334, label %while_exit335, !prof !90
while_body334:
  %r7 = load i64, ptr %slot.listener, align 8
  %r8 = call i64 @nova_rt_tcp_accept(i64 %r7)
  store i64 %r8, ptr %slot.conn, align 8
  %r9 = load i64, ptr %slot.conn, align 8
  %r10 = add i64 0, 0
  %r11 = call i64 @nova_rt_ge(i64 %r9, i64 %r10)
  %br_then3361 = icmp ne i64 %r11, 0
  br i1 %br_then3361, label %then336, label %else337
then336:
  %r12 = load i64, ptr %slot.conn, align 8
  store i64 %r12, ptr %slot.c, align 8
  %r13 = load i64, ptr %slot.a, align 8
  store i64 %r13, ptr %slot.ap, align 8
  %r14 = load i64, ptr %slot.done, align 8
  store i64 %r14, ptr %slot.dc, align 8
  %r15 = load i64, ptr %slot.c, align 8
  %r16 = load i64, ptr %slot.ap, align 8
  %r17 = load i64, ptr %slot.dc, align 8
  %r18.ptr = call ptr @nova_rt_struct_alloc(i64 32)
  %r18.tgep = getelementptr i64, ptr %r18.ptr, i64 0
  %r18.tfn = ptrtoint ptr @__tramp_15 to i64
  store i64 %r18.tfn, ptr %r18.tgep, align 8
  %r18.c0 = getelementptr i64, ptr %r18.ptr, i64 1
  store i64 %r15, ptr %r18.c0, align 8
  %r18.c1 = getelementptr i64, ptr %r18.ptr, i64 2
  store i64 %r16, ptr %r18.c1, align 8
  %r18.c2 = getelementptr i64, ptr %r18.ptr, i64 3
  store i64 %r17, ptr %r18.c2, align 8
  %r18 = ptrtoint ptr %r18.ptr to i64
  %r19 = call i64 @nova_rt_sched_spawn(i64 %r18)
  br label %endif338
else337:
  br label %endif338
endif338:
  %r20 = load i64, ptr %slot.i, align 8
  %r21 = add i64 1, 0
  %r22 = add i64 %r20, %r21
  store i64 %r22, ptr %slot.i, align 8
  br label %while_hdr333
while_exit335:
  %r23 = add i64 0, 0
  store i64 %r23, ptr %slot.j, align 8
  br label %while_hdr339
while_hdr339:
  %r24 = load i64, ptr %slot.j, align 8
  %r25 = load i64, ptr %slot.n, align 8
  %r26.cmp = icmp slt i64 %r24, %r25
  %r26 = zext i1 %r26.cmp to i64
  %br_while_body3402 = icmp ne i64 %r26, 0
  br i1 %br_while_body3402, label %while_body340, label %while_exit341, !prof !90
while_body340:
  %r27 = load i64, ptr %slot.done, align 8
  %r28 = call i64 @nova_rt_channel_recv(i64 %r27)
  %r29 = load i64, ptr %slot.j, align 8
  %r30 = add i64 1, 0
  %r31 = add i64 %r29, %r30
  store i64 %r31, ptr %slot.j, align 8
  br label %while_hdr339
while_exit341:
  %r32 = load i64, ptr %slot.listener, align 8
  %r33 = call i64 @nova_rt_tcp_close(i64 %r32)
  ret i64 %r33
}

; ESCAPE serve_safe_req: allocs=0 escape=0 local=0
define i64 @serve_safe_req(i64 %p0, i64 %p1) nounwind uwtable {
entry:
  %slot.a = alloca i64, align 8
  store i64 %p0, ptr %slot.a, align 8
  %slot.port = alloca i64, align 8
  store i64 %p1, ptr %slot.port, align 8
  %slot.listener = alloca i64, align 8
  store i64 0, ptr %slot.listener, align 8
  %slot.conn = alloca i64, align 8
  store i64 0, ptr %slot.conn, align 8
  %slot.c = alloca i64, align 8
  store i64 0, ptr %slot.c, align 8
  %slot.ap = alloca i64, align 8
  store i64 0, ptr %slot.ap, align 8
  %r0 = load i64, ptr %slot.port, align 8
  %r1 = call i64 @nova_rt_tcp_listen(i64 %r0)
  store i64 %r1, ptr %slot.listener, align 8
  br label %while_hdr342
while_hdr342:
  %r2 = add i64 1, 0
  %br_while_body3430 = icmp ne i64 %r2, 0
  br i1 %br_while_body3430, label %while_body343, label %while_exit344, !prof !90
while_body343:
  %r3 = load i64, ptr %slot.listener, align 8
  %r4 = call i64 @nova_rt_tcp_accept(i64 %r3)
  store i64 %r4, ptr %slot.conn, align 8
  %r5 = load i64, ptr %slot.conn, align 8
  %r6 = add i64 0, 0
  %r7 = call i64 @nova_rt_ge(i64 %r5, i64 %r6)
  %br_then3451 = icmp ne i64 %r7, 0
  br i1 %br_then3451, label %then345, label %else346
then345:
  %r8 = load i64, ptr %slot.conn, align 8
  store i64 %r8, ptr %slot.c, align 8
  %r9 = load i64, ptr %slot.a, align 8
  store i64 %r9, ptr %slot.ap, align 8
  %r10 = load i64, ptr %slot.c, align 8
  %r11 = load i64, ptr %slot.ap, align 8
  %r12.ptr = call ptr @nova_rt_struct_alloc(i64 24)
  %r12.tgep = getelementptr i64, ptr %r12.ptr, i64 0
  %r12.tfn = ptrtoint ptr @__tramp_16 to i64
  store i64 %r12.tfn, ptr %r12.tgep, align 8
  %r12.c0 = getelementptr i64, ptr %r12.ptr, i64 1
  store i64 %r10, ptr %r12.c0, align 8
  %r12.c1 = getelementptr i64, ptr %r12.ptr, i64 2
  store i64 %r11, ptr %r12.c1, align 8
  %r12 = ptrtoint ptr %r12.ptr to i64
  %r13 = call i64 @nova_rt_sched_spawn(i64 %r12)
  br label %endif347
else346:
  br label %endif347
endif347:
  br label %while_hdr342
while_exit344:
  ret i64 0
}

; ESCAPE Request__show: allocs=0 escape=0 local=0
define i64 @Request__show(i64 %p0) nounwind uwtable {
entry:
  %slot.self = alloca i64, align 8
  store i64 %p0, ptr %slot.self, align 8
  %r0.p = getelementptr inbounds [10 x i8], ptr @.str.87, i64 0, i64 0
  %r0 = ptrtoint ptr %r0.p to i64
  %r1.p = getelementptr inbounds [10 x i8], ptr @.str.88, i64 0, i64 0
  %r1 = ptrtoint ptr %r1.p to i64
  %r2 = call i64 @nova_rt_str_concat(i64 %r0, i64 %r1)
  %r3 = load i64, ptr %slot.self, align 8
  %r4.ptr = inttoptr i64 %r3 to ptr
  %r4.gep = getelementptr i64, ptr %r4.ptr, i64 1
  %r4 = load i64, ptr %r4.gep, align 8
  %r5 = add i64 %r4, 0
  %r6 = call i64 @nova_rt_str_concat(i64 %r2, i64 %r5)
  %r7.p = getelementptr inbounds [9 x i8], ptr @.str.89, i64 0, i64 0
  %r7 = ptrtoint ptr %r7.p to i64
  %r8 = call i64 @nova_rt_str_concat(i64 %r6, i64 %r7)
  %r9 = load i64, ptr %slot.self, align 8
  %r10.ptr = inttoptr i64 %r9 to ptr
  %r10.gep = getelementptr i64, ptr %r10.ptr, i64 2
  %r10 = load i64, ptr %r10.gep, align 8
  %r11 = add i64 %r10, 0
  %r12 = call i64 @nova_rt_str_concat(i64 %r8, i64 %r11)
  %r13.p = getelementptr inbounds [13 x i8], ptr @.str.90, i64 0, i64 0
  %r13 = ptrtoint ptr %r13.p to i64
  %r14 = call i64 @nova_rt_str_concat(i64 %r12, i64 %r13)
  %r15 = load i64, ptr %slot.self, align 8
  %r16.ptr = inttoptr i64 %r15 to ptr
  %r16.gep = getelementptr i64, ptr %r16.ptr, i64 3
  %r16 = load i64, ptr %r16.gep, align 8
  %r17 = add i64 %r16, 0
  %r18 = call i64 @nova_rt_str_concat(i64 %r14, i64 %r17)
  %r19.p = getelementptr inbounds [11 x i8], ptr @.str.91, i64 0, i64 0
  %r19 = ptrtoint ptr %r19.p to i64
  %r20 = call i64 @nova_rt_str_concat(i64 %r18, i64 %r19)
  %r21 = load i64, ptr %slot.self, align 8
  %r22.ptr = inttoptr i64 %r21 to ptr
  %r22.gep = getelementptr i64, ptr %r22.ptr, i64 4
  %r22 = load i64, ptr %r22.gep, align 8
  %r23 = call i64 @nova_rt_any_to_str(i64 %r22)
  %r24 = call i64 @nova_rt_str_concat(i64 %r20, i64 %r23)
  %r25.p = getelementptr inbounds [10 x i8], ptr @.str.92, i64 0, i64 0
  %r25 = ptrtoint ptr %r25.p to i64
  %r26 = call i64 @nova_rt_str_concat(i64 %r24, i64 %r25)
  %r27 = load i64, ptr %slot.self, align 8
  %r28.ptr = inttoptr i64 %r27 to ptr
  %r28.gep = getelementptr i64, ptr %r28.ptr, i64 5
  %r28 = load i64, ptr %r28.gep, align 8
  %r29 = call i64 @nova_rt_any_to_str(i64 %r28)
  %r30 = call i64 @nova_rt_str_concat(i64 %r26, i64 %r29)
  %r31.p = getelementptr inbounds [12 x i8], ptr @.str.93, i64 0, i64 0
  %r31 = ptrtoint ptr %r31.p to i64
  %r32 = call i64 @nova_rt_str_concat(i64 %r30, i64 %r31)
  %r33 = load i64, ptr %slot.self, align 8
  %r34.ptr = inttoptr i64 %r33 to ptr
  %r34.gep = getelementptr i64, ptr %r34.ptr, i64 6
  %r34 = load i64, ptr %r34.gep, align 8
  %r35 = call i64 @nova_rt_any_to_str(i64 %r34)
  %r36 = call i64 @nova_rt_str_concat(i64 %r32, i64 %r35)
  %r37.p = getelementptr inbounds [9 x i8], ptr @.str.94, i64 0, i64 0
  %r37 = ptrtoint ptr %r37.p to i64
  %r38 = call i64 @nova_rt_str_concat(i64 %r36, i64 %r37)
  %r39 = load i64, ptr %slot.self, align 8
  %r40.ptr = inttoptr i64 %r39 to ptr
  %r40.gep = getelementptr i64, ptr %r40.ptr, i64 7
  %r40 = load i64, ptr %r40.gep, align 8
  %r41 = add i64 %r40, 0
  %r42 = call i64 @nova_rt_str_concat(i64 %r38, i64 %r41)
  %r43.p = getelementptr inbounds [10 x i8], ptr @.str.95, i64 0, i64 0
  %r43 = ptrtoint ptr %r43.p to i64
  %r44 = call i64 @nova_rt_str_concat(i64 %r42, i64 %r43)
  %r45 = load i64, ptr %slot.self, align 8
  %r46.ptr = inttoptr i64 %r45 to ptr
  %r46.gep = getelementptr i64, ptr %r46.ptr, i64 8
  %r46 = load i64, ptr %r46.gep, align 8
  %r47 = call i64 @nova_rt_any_to_str(i64 %r46)
  %r48 = call i64 @nova_rt_str_concat(i64 %r44, i64 %r47)
  %r49.p = getelementptr inbounds [9 x i8], ptr @.str.96, i64 0, i64 0
  %r49 = ptrtoint ptr %r49.p to i64
  %r50 = call i64 @nova_rt_str_concat(i64 %r48, i64 %r49)
  %r51 = load i64, ptr %slot.self, align 8
  %r52.ptr = inttoptr i64 %r51 to ptr
  %r52.gep = getelementptr i64, ptr %r52.ptr, i64 9
  %r52 = load i64, ptr %r52.gep, align 8
  %r53 = call i64 @nova_rt_int_to_str(i64 %r52)
  %r54 = call i64 @nova_rt_str_concat(i64 %r50, i64 %r53)
  %r55.p = getelementptr inbounds [3 x i8], ptr @.str.97, i64 0, i64 0
  %r55 = ptrtoint ptr %r55.p to i64
  %r56 = call i64 @nova_rt_str_concat(i64 %r54, i64 %r55)
  ret i64 %r56
}

; ESCAPE Request__to_json: allocs=0 escape=0 local=0
define i64 @Request__to_json(i64 %p0) nounwind uwtable {
entry:
  %slot.self = alloca i64, align 8
  store i64 %p0, ptr %slot.self, align 8
  %r0.p = getelementptr inbounds [2 x i8], ptr @.str.49, i64 0, i64 0
  %r0 = ptrtoint ptr %r0.p to i64
  %r1.p = getelementptr inbounds [10 x i8], ptr @.str.98, i64 0, i64 0
  %r1 = ptrtoint ptr %r1.p to i64
  %r2 = call i64 @nova_rt_str_concat(i64 %r0, i64 %r1)
  %r3 = load i64, ptr %slot.self, align 8
  %r4.ptr = inttoptr i64 %r3 to ptr
  %r4.gep = getelementptr i64, ptr %r4.ptr, i64 1
  %r4 = load i64, ptr %r4.gep, align 8
  %r5 = call i64 @nova_rt_json_stringify(i64 %r4)
  %r6 = call i64 @nova_rt_str_concat(i64 %r2, i64 %r5)
  %r7.p = getelementptr inbounds [9 x i8], ptr @.str.99, i64 0, i64 0
  %r7 = ptrtoint ptr %r7.p to i64
  %r8 = call i64 @nova_rt_str_concat(i64 %r6, i64 %r7)
  %r9 = load i64, ptr %slot.self, align 8
  %r10.ptr = inttoptr i64 %r9 to ptr
  %r10.gep = getelementptr i64, ptr %r10.ptr, i64 2
  %r10 = load i64, ptr %r10.gep, align 8
  %r11 = call i64 @nova_rt_json_stringify(i64 %r10)
  %r12 = call i64 @nova_rt_str_concat(i64 %r8, i64 %r11)
  %r13.p = getelementptr inbounds [13 x i8], ptr @.str.100, i64 0, i64 0
  %r13 = ptrtoint ptr %r13.p to i64
  %r14 = call i64 @nova_rt_str_concat(i64 %r12, i64 %r13)
  %r15 = load i64, ptr %slot.self, align 8
  %r16.ptr = inttoptr i64 %r15 to ptr
  %r16.gep = getelementptr i64, ptr %r16.ptr, i64 3
  %r16 = load i64, ptr %r16.gep, align 8
  %r17 = call i64 @nova_rt_json_stringify(i64 %r16)
  %r18 = call i64 @nova_rt_str_concat(i64 %r14, i64 %r17)
  %r19.p = getelementptr inbounds [11 x i8], ptr @.str.101, i64 0, i64 0
  %r19 = ptrtoint ptr %r19.p to i64
  %r20 = call i64 @nova_rt_str_concat(i64 %r18, i64 %r19)
  %r21 = load i64, ptr %slot.self, align 8
  %r22.ptr = inttoptr i64 %r21 to ptr
  %r22.gep = getelementptr i64, ptr %r22.ptr, i64 4
  %r22 = load i64, ptr %r22.gep, align 8
  %r23 = call i64 @nova_rt_json_stringify(i64 %r22)
  %r24 = call i64 @nova_rt_str_concat(i64 %r20, i64 %r23)
  %r25.p = getelementptr inbounds [10 x i8], ptr @.str.102, i64 0, i64 0
  %r25 = ptrtoint ptr %r25.p to i64
  %r26 = call i64 @nova_rt_str_concat(i64 %r24, i64 %r25)
  %r27 = load i64, ptr %slot.self, align 8
  %r28.ptr = inttoptr i64 %r27 to ptr
  %r28.gep = getelementptr i64, ptr %r28.ptr, i64 5
  %r28 = load i64, ptr %r28.gep, align 8
  %r29 = call i64 @nova_rt_json_stringify(i64 %r28)
  %r30 = call i64 @nova_rt_str_concat(i64 %r26, i64 %r29)
  %r31.p = getelementptr inbounds [12 x i8], ptr @.str.103, i64 0, i64 0
  %r31 = ptrtoint ptr %r31.p to i64
  %r32 = call i64 @nova_rt_str_concat(i64 %r30, i64 %r31)
  %r33 = load i64, ptr %slot.self, align 8
  %r34.ptr = inttoptr i64 %r33 to ptr
  %r34.gep = getelementptr i64, ptr %r34.ptr, i64 6
  %r34 = load i64, ptr %r34.gep, align 8
  %r35 = call i64 @nova_rt_json_stringify(i64 %r34)
  %r36 = call i64 @nova_rt_str_concat(i64 %r32, i64 %r35)
  %r37.p = getelementptr inbounds [9 x i8], ptr @.str.104, i64 0, i64 0
  %r37 = ptrtoint ptr %r37.p to i64
  %r38 = call i64 @nova_rt_str_concat(i64 %r36, i64 %r37)
  %r39 = load i64, ptr %slot.self, align 8
  %r40.ptr = inttoptr i64 %r39 to ptr
  %r40.gep = getelementptr i64, ptr %r40.ptr, i64 7
  %r40 = load i64, ptr %r40.gep, align 8
  %r41 = call i64 @nova_rt_json_stringify(i64 %r40)
  %r42 = call i64 @nova_rt_str_concat(i64 %r38, i64 %r41)
  %r43.p = getelementptr inbounds [10 x i8], ptr @.str.105, i64 0, i64 0
  %r43 = ptrtoint ptr %r43.p to i64
  %r44 = call i64 @nova_rt_str_concat(i64 %r42, i64 %r43)
  %r45 = load i64, ptr %slot.self, align 8
  %r46.ptr = inttoptr i64 %r45 to ptr
  %r46.gep = getelementptr i64, ptr %r46.ptr, i64 8
  %r46 = load i64, ptr %r46.gep, align 8
  %r47 = call i64 @nova_rt_json_stringify(i64 %r46)
  %r48 = call i64 @nova_rt_str_concat(i64 %r44, i64 %r47)
  %r49.p = getelementptr inbounds [9 x i8], ptr @.str.106, i64 0, i64 0
  %r49 = ptrtoint ptr %r49.p to i64
  %r50 = call i64 @nova_rt_str_concat(i64 %r48, i64 %r49)
  %r51 = load i64, ptr %slot.self, align 8
  %r52.ptr = inttoptr i64 %r51 to ptr
  %r52.gep = getelementptr i64, ptr %r52.ptr, i64 9
  %r52 = load i64, ptr %r52.gep, align 8
  %r53 = call i64 @nova_rt_json_stringify(i64 %r52)
  %r54 = call i64 @nova_rt_str_concat(i64 %r50, i64 %r53)
  %r55.p = getelementptr inbounds [2 x i8], ptr @.str.53, i64 0, i64 0
  %r55 = ptrtoint ptr %r55.p to i64
  %r56 = call i64 @nova_rt_str_concat(i64 %r54, i64 %r55)
  ret i64 %r56
}

; ESCAPE Request__from_json: allocs=1 escape=1 local=0
define i64 @Request__from_json(i64 %p0) nounwind uwtable {
entry:
  %slot.d = alloca i64, align 8
  store i64 %p0, ptr %slot.d, align 8
  %r0 = load i64, ptr %slot.d, align 8
  %r1.p = getelementptr inbounds [7 x i8], ptr @.str.69, i64 0, i64 0
  %r1 = ptrtoint ptr %r1.p to i64
  %r2 = call i64 @nova_rt_dict_get(i64 %r0, i64 %r1)
  %r3 = load i64, ptr %slot.d, align 8
  %r4.p = getelementptr inbounds [5 x i8], ptr @.str.68, i64 0, i64 0
  %r4 = ptrtoint ptr %r4.p to i64
  %r5 = call i64 @nova_rt_dict_get(i64 %r3, i64 %r4)
  %r6 = load i64, ptr %slot.d, align 8
  %r7.p = getelementptr inbounds [9 x i8], ptr @.str.107, i64 0, i64 0
  %r7 = ptrtoint ptr %r7.p to i64
  %r8 = call i64 @nova_rt_dict_get(i64 %r6, i64 %r7)
  %r9 = load i64, ptr %slot.d, align 8
  %r10.p = getelementptr inbounds [7 x i8], ptr @.str.71, i64 0, i64 0
  %r10 = ptrtoint ptr %r10.p to i64
  %r11 = call i64 @nova_rt_dict_get(i64 %r9, i64 %r10)
  %r12 = load i64, ptr %slot.d, align 8
  %r13.p = getelementptr inbounds [6 x i8], ptr @.str.108, i64 0, i64 0
  %r13 = ptrtoint ptr %r13.p to i64
  %r14 = call i64 @nova_rt_dict_get(i64 %r12, i64 %r13)
  %r15 = load i64, ptr %slot.d, align 8
  %r16.p = getelementptr inbounds [8 x i8], ptr @.str.109, i64 0, i64 0
  %r16 = ptrtoint ptr %r16.p to i64
  %r17 = call i64 @nova_rt_dict_get(i64 %r15, i64 %r16)
  %r18 = load i64, ptr %slot.d, align 8
  %r19.p = getelementptr inbounds [5 x i8], ptr @.str.74, i64 0, i64 0
  %r19 = ptrtoint ptr %r19.p to i64
  %r20 = call i64 @nova_rt_dict_get(i64 %r18, i64 %r19)
  %r21 = load i64, ptr %slot.d, align 8
  %r22.p = getelementptr inbounds [6 x i8], ptr @.str.110, i64 0, i64 0
  %r22 = ptrtoint ptr %r22.p to i64
  %r23 = call i64 @nova_rt_dict_get(i64 %r21, i64 %r22)
  %r24 = load i64, ptr %slot.d, align 8
  %r25.p = getelementptr inbounds [5 x i8], ptr @.str.111, i64 0, i64 0
  %r25 = ptrtoint ptr %r25.p to i64
  %r26 = call i64 @nova_rt_dict_get(i64 %r24, i64 %r25)
  %r27.ptr = call ptr @nova_rt_struct_alloc(i64 80)
  %r27.thash = getelementptr i64, ptr %r27.ptr, i64 0
  store i64 229439833034990, ptr %r27.thash, align 8
  %r27.f0 = getelementptr i64, ptr %r27.ptr, i64 1
  store i64 %r2, ptr %r27.f0, align 8
  %r27.f1 = getelementptr i64, ptr %r27.ptr, i64 2
  store i64 %r5, ptr %r27.f1, align 8
  %r27.f2 = getelementptr i64, ptr %r27.ptr, i64 3
  store i64 %r8, ptr %r27.f2, align 8
  %r27.f3 = getelementptr i64, ptr %r27.ptr, i64 4
  store i64 %r11, ptr %r27.f3, align 8
  %r27.f4 = getelementptr i64, ptr %r27.ptr, i64 5
  store i64 %r14, ptr %r27.f4, align 8
  %r27.f5 = getelementptr i64, ptr %r27.ptr, i64 6
  store i64 %r17, ptr %r27.f5, align 8
  %r27.f6 = getelementptr i64, ptr %r27.ptr, i64 7
  store i64 %r20, ptr %r27.f6, align 8
  %r27.f7 = getelementptr i64, ptr %r27.ptr, i64 8
  store i64 %r23, ptr %r27.f7, align 8
  %r27.f8 = getelementptr i64, ptr %r27.ptr, i64 9
  store i64 %r26, ptr %r27.f8, align 8
  %r27 = ptrtoint ptr %r27.ptr to i64
  ret i64 %r27
}

; ESCAPE Request__fields: allocs=1 escape=1 local=0
define i64 @Request__fields(i64 %p0) nounwind uwtable {
entry:
  %slot.self = alloca i64, align 8
  store i64 %p0, ptr %slot.self, align 8
  %r1.p = getelementptr inbounds [7 x i8], ptr @.str.69, i64 0, i64 0
  %r1 = ptrtoint ptr %r1.p to i64
  %r2.p = getelementptr inbounds [5 x i8], ptr @.str.68, i64 0, i64 0
  %r2 = ptrtoint ptr %r2.p to i64
  %r3.p = getelementptr inbounds [9 x i8], ptr @.str.107, i64 0, i64 0
  %r3 = ptrtoint ptr %r3.p to i64
  %r4.p = getelementptr inbounds [7 x i8], ptr @.str.71, i64 0, i64 0
  %r4 = ptrtoint ptr %r4.p to i64
  %r5.p = getelementptr inbounds [6 x i8], ptr @.str.108, i64 0, i64 0
  %r5 = ptrtoint ptr %r5.p to i64
  %r6.p = getelementptr inbounds [8 x i8], ptr @.str.109, i64 0, i64 0
  %r6 = ptrtoint ptr %r6.p to i64
  %r7.p = getelementptr inbounds [5 x i8], ptr @.str.74, i64 0, i64 0
  %r7 = ptrtoint ptr %r7.p to i64
  %r8.p = getelementptr inbounds [6 x i8], ptr @.str.110, i64 0, i64 0
  %r8 = ptrtoint ptr %r8.p to i64
  %r9.p = getelementptr inbounds [5 x i8], ptr @.str.111, i64 0, i64 0
  %r9 = ptrtoint ptr %r9.p to i64
  %r0 = call i64 @nova_rt_list_create()
  call i64 @nova_rt_list_append(i64 %r0, i64 %r1)
  call i64 @nova_rt_list_append(i64 %r0, i64 %r2)
  call i64 @nova_rt_list_append(i64 %r0, i64 %r3)
  call i64 @nova_rt_list_append(i64 %r0, i64 %r4)
  call i64 @nova_rt_list_append(i64 %r0, i64 %r5)
  call i64 @nova_rt_list_append(i64 %r0, i64 %r6)
  call i64 @nova_rt_list_append(i64 %r0, i64 %r7)
  call i64 @nova_rt_list_append(i64 %r0, i64 %r8)
  call i64 @nova_rt_list_append(i64 %r0, i64 %r9)
  ret i64 %r0
}

; ESCAPE Request__type_name: allocs=0 escape=0 local=0
define i64 @Request__type_name(i64 %p0) nounwind uwtable {
entry:
  %slot.self = alloca i64, align 8
  store i64 %p0, ptr %slot.self, align 8
  %r0.p = getelementptr inbounds [8 x i8], ptr @.str.112, i64 0, i64 0
  %r0 = ptrtoint ptr %r0.p to i64
  ret i64 %r0
}

; ESCAPE Request__field_types: allocs=1 escape=1 local=0
define i64 @Request__field_types(i64 %p0) nounwind uwtable {
entry:
  %slot.self = alloca i64, align 8
  store i64 %p0, ptr %slot.self, align 8
  %r1.p = getelementptr inbounds [7 x i8], ptr @.str.78, i64 0, i64 0
  %r1 = ptrtoint ptr %r1.p to i64
  %r2.p = getelementptr inbounds [7 x i8], ptr @.str.78, i64 0, i64 0
  %r2 = ptrtoint ptr %r2.p to i64
  %r3.p = getelementptr inbounds [7 x i8], ptr @.str.78, i64 0, i64 0
  %r3 = ptrtoint ptr %r3.p to i64
  %r4.p = getelementptr inbounds [5 x i8], ptr @.str.113, i64 0, i64 0
  %r4 = ptrtoint ptr %r4.p to i64
  %r5.p = getelementptr inbounds [5 x i8], ptr @.str.113, i64 0, i64 0
  %r5 = ptrtoint ptr %r5.p to i64
  %r6.p = getelementptr inbounds [5 x i8], ptr @.str.113, i64 0, i64 0
  %r6 = ptrtoint ptr %r6.p to i64
  %r7.p = getelementptr inbounds [7 x i8], ptr @.str.78, i64 0, i64 0
  %r7 = ptrtoint ptr %r7.p to i64
  %r8.p = getelementptr inbounds [5 x i8], ptr @.str.113, i64 0, i64 0
  %r8 = ptrtoint ptr %r8.p to i64
  %r9.p = getelementptr inbounds [4 x i8], ptr @.str.114, i64 0, i64 0
  %r9 = ptrtoint ptr %r9.p to i64
  %r0 = call i64 @nova_rt_list_create()
  call i64 @nova_rt_list_append(i64 %r0, i64 %r1)
  call i64 @nova_rt_list_append(i64 %r0, i64 %r2)
  call i64 @nova_rt_list_append(i64 %r0, i64 %r3)
  call i64 @nova_rt_list_append(i64 %r0, i64 %r4)
  call i64 @nova_rt_list_append(i64 %r0, i64 %r5)
  call i64 @nova_rt_list_append(i64 %r0, i64 %r6)
  call i64 @nova_rt_list_append(i64 %r0, i64 %r7)
  call i64 @nova_rt_list_append(i64 %r0, i64 %r8)
  call i64 @nova_rt_list_append(i64 %r0, i64 %r9)
  ret i64 %r0
}

; ESCAPE Request__field_names: allocs=1 escape=1 local=0
define i64 @Request__field_names(i64 %p0) nounwind uwtable {
entry:
  %slot.self = alloca i64, align 8
  store i64 %p0, ptr %slot.self, align 8
  %r1.p = getelementptr inbounds [7 x i8], ptr @.str.69, i64 0, i64 0
  %r1 = ptrtoint ptr %r1.p to i64
  %r2.p = getelementptr inbounds [5 x i8], ptr @.str.68, i64 0, i64 0
  %r2 = ptrtoint ptr %r2.p to i64
  %r3.p = getelementptr inbounds [9 x i8], ptr @.str.107, i64 0, i64 0
  %r3 = ptrtoint ptr %r3.p to i64
  %r4.p = getelementptr inbounds [7 x i8], ptr @.str.71, i64 0, i64 0
  %r4 = ptrtoint ptr %r4.p to i64
  %r5.p = getelementptr inbounds [6 x i8], ptr @.str.108, i64 0, i64 0
  %r5 = ptrtoint ptr %r5.p to i64
  %r6.p = getelementptr inbounds [8 x i8], ptr @.str.109, i64 0, i64 0
  %r6 = ptrtoint ptr %r6.p to i64
  %r7.p = getelementptr inbounds [5 x i8], ptr @.str.74, i64 0, i64 0
  %r7 = ptrtoint ptr %r7.p to i64
  %r8.p = getelementptr inbounds [6 x i8], ptr @.str.110, i64 0, i64 0
  %r8 = ptrtoint ptr %r8.p to i64
  %r9.p = getelementptr inbounds [5 x i8], ptr @.str.111, i64 0, i64 0
  %r9 = ptrtoint ptr %r9.p to i64
  %r0 = call i64 @nova_rt_list_create()
  call i64 @nova_rt_list_append(i64 %r0, i64 %r1)
  call i64 @nova_rt_list_append(i64 %r0, i64 %r2)
  call i64 @nova_rt_list_append(i64 %r0, i64 %r3)
  call i64 @nova_rt_list_append(i64 %r0, i64 %r4)
  call i64 @nova_rt_list_append(i64 %r0, i64 %r5)
  call i64 @nova_rt_list_append(i64 %r0, i64 %r6)
  call i64 @nova_rt_list_append(i64 %r0, i64 %r7)
  call i64 @nova_rt_list_append(i64 %r0, i64 %r8)
  call i64 @nova_rt_list_append(i64 %r0, i64 %r9)
  ret i64 %r0
}

; ESCAPE Request__field_get: allocs=1 escape=0 local=1
define i64 @Request__field_get(i64 %p0, i64 %p1) nounwind uwtable {
entry:
  %slot.self = alloca i64, align 8
  store i64 %p0, ptr %slot.self, align 8
  %slot.name = alloca i64, align 8
  store i64 %p1, ptr %slot.name, align 8
  %slot._fg_box = alloca i64, align 8
  store i64 0, ptr %slot._fg_box, align 8
  %r0 = call i64 @nova_rt_list_create()
  store i64 %r0, ptr %slot._fg_box, align 8
  %r1 = load i64, ptr %slot.name, align 8
  %r2.p = getelementptr inbounds [7 x i8], ptr @.str.69, i64 0, i64 0
  %r2 = ptrtoint ptr %r2.p to i64
  %r3.p0 = inttoptr i64 %r1 to ptr
  %r3.p1 = inttoptr i64 %r2 to ptr
  %r3.sc = call i32 @strcmp(ptr %r3.p0, ptr %r3.p1)
  %r3.cmp = icmp eq i32 %r3.sc, 0
  %r3 = zext i1 %r3.cmp to i64
  %br_then3480 = icmp ne i64 %r3, 0
  br i1 %br_then3480, label %then348, label %else349
then348:
  %r4 = load i64, ptr %slot._fg_box, align 8
  %r5 = load i64, ptr %slot.self, align 8
  %r6.ptr = inttoptr i64 %r5 to ptr
  %r6.gep = getelementptr i64, ptr %r6.ptr, i64 1
  %r6 = load i64, ptr %r6.gep, align 8
  %r7 = call i64 @nova_rt_list_append_no_rc(i64 %r4, i64 %r6)
  %r8 = load i64, ptr %slot._fg_box, align 8
  %r9 = add i64 0, 0
  %r10.lp = inttoptr i64 %r8 to ptr
  %r10.dp = load ptr, ptr %r10.lp, align 8, !tbaa !2
  %r10.ep = getelementptr i64, ptr %r10.dp, i64 %r9
  %r10.lv = load i64, ptr %r10.ep, align 8, !tbaa !4
  %r10 = call i64 @nova_rt_unbox_elem(i64 %r10.lv)
  ret i64 %r10
else349:
  br label %endif350
endif350:
  %r11 = load i64, ptr %slot.name, align 8
  %r12.p = getelementptr inbounds [5 x i8], ptr @.str.68, i64 0, i64 0
  %r12 = ptrtoint ptr %r12.p to i64
  %r13.p0 = inttoptr i64 %r11 to ptr
  %r13.p1 = inttoptr i64 %r12 to ptr
  %r13.sc = call i32 @strcmp(ptr %r13.p0, ptr %r13.p1)
  %r13.cmp = icmp eq i32 %r13.sc, 0
  %r13 = zext i1 %r13.cmp to i64
  %br_then3511 = icmp ne i64 %r13, 0
  br i1 %br_then3511, label %then351, label %else352
then351:
  %r14 = load i64, ptr %slot._fg_box, align 8
  %r15 = load i64, ptr %slot.self, align 8
  %r16.ptr = inttoptr i64 %r15 to ptr
  %r16.gep = getelementptr i64, ptr %r16.ptr, i64 2
  %r16 = load i64, ptr %r16.gep, align 8
  %r17 = call i64 @nova_rt_list_append_no_rc(i64 %r14, i64 %r16)
  %r18 = load i64, ptr %slot._fg_box, align 8
  %r19 = add i64 0, 0
  %r20.lp = inttoptr i64 %r18 to ptr
  %r20.dp = load ptr, ptr %r20.lp, align 8, !tbaa !2
  %r20.ep = getelementptr i64, ptr %r20.dp, i64 %r19
  %r20.lv = load i64, ptr %r20.ep, align 8, !tbaa !4
  %r20 = call i64 @nova_rt_unbox_elem(i64 %r20.lv)
  ret i64 %r20
else352:
  br label %endif353
endif353:
  %r21 = load i64, ptr %slot.name, align 8
  %r22.p = getelementptr inbounds [9 x i8], ptr @.str.107, i64 0, i64 0
  %r22 = ptrtoint ptr %r22.p to i64
  %r23.p0 = inttoptr i64 %r21 to ptr
  %r23.p1 = inttoptr i64 %r22 to ptr
  %r23.sc = call i32 @strcmp(ptr %r23.p0, ptr %r23.p1)
  %r23.cmp = icmp eq i32 %r23.sc, 0
  %r23 = zext i1 %r23.cmp to i64
  %br_then3542 = icmp ne i64 %r23, 0
  br i1 %br_then3542, label %then354, label %else355
then354:
  %r24 = load i64, ptr %slot._fg_box, align 8
  %r25 = load i64, ptr %slot.self, align 8
  %r26.ptr = inttoptr i64 %r25 to ptr
  %r26.gep = getelementptr i64, ptr %r26.ptr, i64 3
  %r26 = load i64, ptr %r26.gep, align 8
  %r27 = call i64 @nova_rt_list_append_no_rc(i64 %r24, i64 %r26)
  %r28 = load i64, ptr %slot._fg_box, align 8
  %r29 = add i64 0, 0
  %r30.lp = inttoptr i64 %r28 to ptr
  %r30.dp = load ptr, ptr %r30.lp, align 8, !tbaa !2
  %r30.ep = getelementptr i64, ptr %r30.dp, i64 %r29
  %r30.lv = load i64, ptr %r30.ep, align 8, !tbaa !4
  %r30 = call i64 @nova_rt_unbox_elem(i64 %r30.lv)
  ret i64 %r30
else355:
  br label %endif356
endif356:
  %r31 = load i64, ptr %slot.name, align 8
  %r32.p = getelementptr inbounds [7 x i8], ptr @.str.71, i64 0, i64 0
  %r32 = ptrtoint ptr %r32.p to i64
  %r33.p0 = inttoptr i64 %r31 to ptr
  %r33.p1 = inttoptr i64 %r32 to ptr
  %r33.sc = call i32 @strcmp(ptr %r33.p0, ptr %r33.p1)
  %r33.cmp = icmp eq i32 %r33.sc, 0
  %r33 = zext i1 %r33.cmp to i64
  %br_then3573 = icmp ne i64 %r33, 0
  br i1 %br_then3573, label %then357, label %else358
then357:
  %r34 = load i64, ptr %slot._fg_box, align 8
  %r35 = load i64, ptr %slot.self, align 8
  %r36.ptr = inttoptr i64 %r35 to ptr
  %r36.gep = getelementptr i64, ptr %r36.ptr, i64 4
  %r36 = load i64, ptr %r36.gep, align 8
  %r37 = call i64 @nova_rt_list_append_no_rc(i64 %r34, i64 %r36)
  %r38 = load i64, ptr %slot._fg_box, align 8
  %r39 = add i64 0, 0
  %r40.lp = inttoptr i64 %r38 to ptr
  %r40.dp = load ptr, ptr %r40.lp, align 8, !tbaa !2
  %r40.ep = getelementptr i64, ptr %r40.dp, i64 %r39
  %r40.lv = load i64, ptr %r40.ep, align 8, !tbaa !4
  %r40 = call i64 @nova_rt_unbox_elem(i64 %r40.lv)
  ret i64 %r40
else358:
  br label %endif359
endif359:
  %r41 = load i64, ptr %slot.name, align 8
  %r42.p = getelementptr inbounds [6 x i8], ptr @.str.108, i64 0, i64 0
  %r42 = ptrtoint ptr %r42.p to i64
  %r43.p0 = inttoptr i64 %r41 to ptr
  %r43.p1 = inttoptr i64 %r42 to ptr
  %r43.sc = call i32 @strcmp(ptr %r43.p0, ptr %r43.p1)
  %r43.cmp = icmp eq i32 %r43.sc, 0
  %r43 = zext i1 %r43.cmp to i64
  %br_then3604 = icmp ne i64 %r43, 0
  br i1 %br_then3604, label %then360, label %else361
then360:
  %r44 = load i64, ptr %slot._fg_box, align 8
  %r45 = load i64, ptr %slot.self, align 8
  %r46.ptr = inttoptr i64 %r45 to ptr
  %r46.gep = getelementptr i64, ptr %r46.ptr, i64 5
  %r46 = load i64, ptr %r46.gep, align 8
  %r47 = call i64 @nova_rt_list_append_no_rc(i64 %r44, i64 %r46)
  %r48 = load i64, ptr %slot._fg_box, align 8
  %r49 = add i64 0, 0
  %r50.lp = inttoptr i64 %r48 to ptr
  %r50.dp = load ptr, ptr %r50.lp, align 8, !tbaa !2
  %r50.ep = getelementptr i64, ptr %r50.dp, i64 %r49
  %r50.lv = load i64, ptr %r50.ep, align 8, !tbaa !4
  %r50 = call i64 @nova_rt_unbox_elem(i64 %r50.lv)
  ret i64 %r50
else361:
  br label %endif362
endif362:
  %r51 = load i64, ptr %slot.name, align 8
  %r52.p = getelementptr inbounds [8 x i8], ptr @.str.109, i64 0, i64 0
  %r52 = ptrtoint ptr %r52.p to i64
  %r53.p0 = inttoptr i64 %r51 to ptr
  %r53.p1 = inttoptr i64 %r52 to ptr
  %r53.sc = call i32 @strcmp(ptr %r53.p0, ptr %r53.p1)
  %r53.cmp = icmp eq i32 %r53.sc, 0
  %r53 = zext i1 %r53.cmp to i64
  %br_then3635 = icmp ne i64 %r53, 0
  br i1 %br_then3635, label %then363, label %else364
then363:
  %r54 = load i64, ptr %slot._fg_box, align 8
  %r55 = load i64, ptr %slot.self, align 8
  %r56.ptr = inttoptr i64 %r55 to ptr
  %r56.gep = getelementptr i64, ptr %r56.ptr, i64 6
  %r56 = load i64, ptr %r56.gep, align 8
  %r57 = call i64 @nova_rt_list_append_no_rc(i64 %r54, i64 %r56)
  %r58 = load i64, ptr %slot._fg_box, align 8
  %r59 = add i64 0, 0
  %r60.lp = inttoptr i64 %r58 to ptr
  %r60.dp = load ptr, ptr %r60.lp, align 8, !tbaa !2
  %r60.ep = getelementptr i64, ptr %r60.dp, i64 %r59
  %r60.lv = load i64, ptr %r60.ep, align 8, !tbaa !4
  %r60 = call i64 @nova_rt_unbox_elem(i64 %r60.lv)
  ret i64 %r60
else364:
  br label %endif365
endif365:
  %r61 = load i64, ptr %slot.name, align 8
  %r62.p = getelementptr inbounds [5 x i8], ptr @.str.74, i64 0, i64 0
  %r62 = ptrtoint ptr %r62.p to i64
  %r63.p0 = inttoptr i64 %r61 to ptr
  %r63.p1 = inttoptr i64 %r62 to ptr
  %r63.sc = call i32 @strcmp(ptr %r63.p0, ptr %r63.p1)
  %r63.cmp = icmp eq i32 %r63.sc, 0
  %r63 = zext i1 %r63.cmp to i64
  %br_then3666 = icmp ne i64 %r63, 0
  br i1 %br_then3666, label %then366, label %else367
then366:
  %r64 = load i64, ptr %slot._fg_box, align 8
  %r65 = load i64, ptr %slot.self, align 8
  %r66.ptr = inttoptr i64 %r65 to ptr
  %r66.gep = getelementptr i64, ptr %r66.ptr, i64 7
  %r66 = load i64, ptr %r66.gep, align 8
  %r67 = call i64 @nova_rt_list_append_no_rc(i64 %r64, i64 %r66)
  %r68 = load i64, ptr %slot._fg_box, align 8
  %r69 = add i64 0, 0
  %r70.lp = inttoptr i64 %r68 to ptr
  %r70.dp = load ptr, ptr %r70.lp, align 8, !tbaa !2
  %r70.ep = getelementptr i64, ptr %r70.dp, i64 %r69
  %r70.lv = load i64, ptr %r70.ep, align 8, !tbaa !4
  %r70 = call i64 @nova_rt_unbox_elem(i64 %r70.lv)
  ret i64 %r70
else367:
  br label %endif368
endif368:
  %r71 = load i64, ptr %slot.name, align 8
  %r72.p = getelementptr inbounds [6 x i8], ptr @.str.110, i64 0, i64 0
  %r72 = ptrtoint ptr %r72.p to i64
  %r73.p0 = inttoptr i64 %r71 to ptr
  %r73.p1 = inttoptr i64 %r72 to ptr
  %r73.sc = call i32 @strcmp(ptr %r73.p0, ptr %r73.p1)
  %r73.cmp = icmp eq i32 %r73.sc, 0
  %r73 = zext i1 %r73.cmp to i64
  %br_then3697 = icmp ne i64 %r73, 0
  br i1 %br_then3697, label %then369, label %else370
then369:
  %r74 = load i64, ptr %slot._fg_box, align 8
  %r75 = load i64, ptr %slot.self, align 8
  %r76.ptr = inttoptr i64 %r75 to ptr
  %r76.gep = getelementptr i64, ptr %r76.ptr, i64 8
  %r76 = load i64, ptr %r76.gep, align 8
  %r77 = call i64 @nova_rt_list_append_no_rc(i64 %r74, i64 %r76)
  %r78 = load i64, ptr %slot._fg_box, align 8
  %r79 = add i64 0, 0
  %r80.lp = inttoptr i64 %r78 to ptr
  %r80.dp = load ptr, ptr %r80.lp, align 8, !tbaa !2
  %r80.ep = getelementptr i64, ptr %r80.dp, i64 %r79
  %r80.lv = load i64, ptr %r80.ep, align 8, !tbaa !4
  %r80 = call i64 @nova_rt_unbox_elem(i64 %r80.lv)
  ret i64 %r80
else370:
  br label %endif371
endif371:
  %r81 = load i64, ptr %slot.name, align 8
  %r82.p = getelementptr inbounds [5 x i8], ptr @.str.111, i64 0, i64 0
  %r82 = ptrtoint ptr %r82.p to i64
  %r83.p0 = inttoptr i64 %r81 to ptr
  %r83.p1 = inttoptr i64 %r82 to ptr
  %r83.sc = call i32 @strcmp(ptr %r83.p0, ptr %r83.p1)
  %r83.cmp = icmp eq i32 %r83.sc, 0
  %r83 = zext i1 %r83.cmp to i64
  %br_then3728 = icmp ne i64 %r83, 0
  br i1 %br_then3728, label %then372, label %else373
then372:
  %r84 = load i64, ptr %slot._fg_box, align 8
  %r85 = load i64, ptr %slot.self, align 8
  %r86.ptr = inttoptr i64 %r85 to ptr
  %r86.gep = getelementptr i64, ptr %r86.ptr, i64 9
  %r86 = load i64, ptr %r86.gep, align 8
  %r87 = call i64 @nova_rt_list_append_no_rc(i64 %r84, i64 %r86)
  %r88 = load i64, ptr %slot._fg_box, align 8
  %r89 = add i64 0, 0
  %r90.lp = inttoptr i64 %r88 to ptr
  %r90.dp = load ptr, ptr %r90.lp, align 8, !tbaa !2
  %r90.ep = getelementptr i64, ptr %r90.dp, i64 %r89
  %r90.lv = load i64, ptr %r90.ep, align 8, !tbaa !4
  %r90 = call i64 @nova_rt_unbox_elem(i64 %r90.lv)
  ret i64 %r90
else373:
  br label %endif374
endif374:
  %r91 = add i64 0, 0
  ret i64 %r91
}

; ESCAPE Response__show: allocs=1 escape=0 local=1
define i64 @Response__show(i64 %p0) nounwind uwtable {
entry:
  %slot.self = alloca i64, align 8
  store i64 %p0, ptr %slot.self, align 8
  %r0.p = getelementptr inbounds [11 x i8], ptr @.str.115, i64 0, i64 0
  %r0 = ptrtoint ptr %r0.p to i64
  %r1.p = getelementptr inbounds [10 x i8], ptr @.str.116, i64 0, i64 0
  %r1 = ptrtoint ptr %r1.p to i64
  %r2 = call i64 @nova_rt_str_concat(i64 %r0, i64 %r1)
  %r3 = load i64, ptr %slot.self, align 8
  %r4.ptr = inttoptr i64 %r3 to ptr
  %r4.gep = getelementptr i64, ptr %r4.ptr, i64 1
  %r4 = load i64, ptr %r4.gep, align 8
  %r5 = call i64 @nova_rt_int_to_str(i64 %r4)
  %r6 = call i64 @nova_rt_str_concat(i64 %r2, i64 %r5)
  %r7.p = getelementptr inbounds [12 x i8], ptr @.str.93, i64 0, i64 0
  %r7 = ptrtoint ptr %r7.p to i64
  %r8 = call i64 @nova_rt_str_concat(i64 %r6, i64 %r7)
  %r9 = load i64, ptr %slot.self, align 8
  %r10.ptr = inttoptr i64 %r9 to ptr
  %r10.gep = getelementptr i64, ptr %r10.ptr, i64 2
  %r10 = load i64, ptr %r10.gep, align 8
  %r11 = call i64 @nova_rt_any_to_str(i64 %r10)
  %r12 = call i64 @nova_rt_str_concat(i64 %r8, i64 %r11)
  %r13.p = getelementptr inbounds [9 x i8], ptr @.str.94, i64 0, i64 0
  %r13 = ptrtoint ptr %r13.p to i64
  %r14 = call i64 @nova_rt_str_concat(i64 %r12, i64 %r13)
  %r15 = load i64, ptr %slot.self, align 8
  %r16.ptr = inttoptr i64 %r15 to ptr
  %r16.gep = getelementptr i64, ptr %r16.ptr, i64 3
  %r16 = load i64, ptr %r16.gep, align 8
  %r17 = add i64 %r16, 0
  %r18 = call i64 @nova_rt_str_concat(i64 %r14, i64 %r17)
  %r19.p = getelementptr inbounds [11 x i8], ptr @.str.117, i64 0, i64 0
  %r19 = ptrtoint ptr %r19.p to i64
  %r20 = call i64 @nova_rt_str_concat(i64 %r18, i64 %r19)
  %r22.p = getelementptr inbounds [6 x i8], ptr @.str.118, i64 0, i64 0
  %r22 = ptrtoint ptr %r22.p to i64
  %r23.p = getelementptr inbounds [5 x i8], ptr @.str.119, i64 0, i64 0
  %r23 = ptrtoint ptr %r23.p to i64
  %r21 = call i64 @nova_rt_list_create()
  call i64 @nova_rt_list_append(i64 %r21, i64 %r22)
  call i64 @nova_rt_list_append(i64 %r21, i64 %r23)
  %r24 = load i64, ptr %slot.self, align 8
  %r25.ptr = inttoptr i64 %r24 to ptr
  %r25.gep = getelementptr i64, ptr %r25.ptr, i64 4
  %r25 = load i64, ptr %r25.gep, align 8
  %r26.lp = inttoptr i64 %r21 to ptr
  %r26.dp = load ptr, ptr %r26.lp, align 8, !tbaa !2
  %r26.szp = getelementptr i64, ptr %r26.lp, i64 1
  %r26.sz = load i64, ptr %r26.szp, align 8, !tbaa !6
  %r26.neg = icmp slt i64 %r25, 0
  %r26.adj = add i64 %r25, %r26.sz
  %r26.fi = select i1 %r26.neg, i64 %r26.adj, i64 %r25
  %r26.ep = getelementptr i64, ptr %r26.dp, i64 %r26.fi
  %r26.lv = load i64, ptr %r26.ep, align 8, !tbaa !4
  %r26 = call i64 @nova_rt_unbox_elem(i64 %r26.lv)
  %r27 = call i64 @nova_rt_str_concat(i64 %r20, i64 %r26)
  %r28.p = getelementptr inbounds [3 x i8], ptr @.str.97, i64 0, i64 0
  %r28 = ptrtoint ptr %r28.p to i64
  %r29 = call i64 @nova_rt_str_concat(i64 %r27, i64 %r28)
  ret i64 %r29
}

; ESCAPE Response__to_json: allocs=1 escape=0 local=1
define i64 @Response__to_json(i64 %p0) nounwind uwtable {
entry:
  %slot.self = alloca i64, align 8
  store i64 %p0, ptr %slot.self, align 8
  %r0.p = getelementptr inbounds [2 x i8], ptr @.str.49, i64 0, i64 0
  %r0 = ptrtoint ptr %r0.p to i64
  %r1.p = getelementptr inbounds [10 x i8], ptr @.str.120, i64 0, i64 0
  %r1 = ptrtoint ptr %r1.p to i64
  %r2 = call i64 @nova_rt_str_concat(i64 %r0, i64 %r1)
  %r3 = load i64, ptr %slot.self, align 8
  %r4.ptr = inttoptr i64 %r3 to ptr
  %r4.gep = getelementptr i64, ptr %r4.ptr, i64 1
  %r4 = load i64, ptr %r4.gep, align 8
  %r5 = call i64 @nova_rt_json_stringify(i64 %r4)
  %r6 = call i64 @nova_rt_str_concat(i64 %r2, i64 %r5)
  %r7.p = getelementptr inbounds [12 x i8], ptr @.str.103, i64 0, i64 0
  %r7 = ptrtoint ptr %r7.p to i64
  %r8 = call i64 @nova_rt_str_concat(i64 %r6, i64 %r7)
  %r9 = load i64, ptr %slot.self, align 8
  %r10.ptr = inttoptr i64 %r9 to ptr
  %r10.gep = getelementptr i64, ptr %r10.ptr, i64 2
  %r10 = load i64, ptr %r10.gep, align 8
  %r11 = call i64 @nova_rt_json_stringify(i64 %r10)
  %r12 = call i64 @nova_rt_str_concat(i64 %r8, i64 %r11)
  %r13.p = getelementptr inbounds [9 x i8], ptr @.str.104, i64 0, i64 0
  %r13 = ptrtoint ptr %r13.p to i64
  %r14 = call i64 @nova_rt_str_concat(i64 %r12, i64 %r13)
  %r15 = load i64, ptr %slot.self, align 8
  %r16.ptr = inttoptr i64 %r15 to ptr
  %r16.gep = getelementptr i64, ptr %r16.ptr, i64 3
  %r16 = load i64, ptr %r16.gep, align 8
  %r17 = call i64 @nova_rt_json_stringify(i64 %r16)
  %r18 = call i64 @nova_rt_str_concat(i64 %r14, i64 %r17)
  %r19.p = getelementptr inbounds [11 x i8], ptr @.str.121, i64 0, i64 0
  %r19 = ptrtoint ptr %r19.p to i64
  %r20 = call i64 @nova_rt_str_concat(i64 %r18, i64 %r19)
  %r22.p = getelementptr inbounds [6 x i8], ptr @.str.118, i64 0, i64 0
  %r22 = ptrtoint ptr %r22.p to i64
  %r23.p = getelementptr inbounds [5 x i8], ptr @.str.119, i64 0, i64 0
  %r23 = ptrtoint ptr %r23.p to i64
  %r21 = call i64 @nova_rt_list_create()
  call i64 @nova_rt_list_append(i64 %r21, i64 %r22)
  call i64 @nova_rt_list_append(i64 %r21, i64 %r23)
  %r24 = load i64, ptr %slot.self, align 8
  %r25.ptr = inttoptr i64 %r24 to ptr
  %r25.gep = getelementptr i64, ptr %r25.ptr, i64 4
  %r25 = load i64, ptr %r25.gep, align 8
  %r26.lp = inttoptr i64 %r21 to ptr
  %r26.dp = load ptr, ptr %r26.lp, align 8, !tbaa !2
  %r26.szp = getelementptr i64, ptr %r26.lp, i64 1
  %r26.sz = load i64, ptr %r26.szp, align 8, !tbaa !6
  %r26.neg = icmp slt i64 %r25, 0
  %r26.adj = add i64 %r25, %r26.sz
  %r26.fi = select i1 %r26.neg, i64 %r26.adj, i64 %r25
  %r26.ep = getelementptr i64, ptr %r26.dp, i64 %r26.fi
  %r26.lv = load i64, ptr %r26.ep, align 8, !tbaa !4
  %r26 = call i64 @nova_rt_unbox_elem(i64 %r26.lv)
  %r27 = call i64 @nova_rt_str_concat(i64 %r20, i64 %r26)
  %r28.p = getelementptr inbounds [2 x i8], ptr @.str.53, i64 0, i64 0
  %r28 = ptrtoint ptr %r28.p to i64
  %r29 = call i64 @nova_rt_str_concat(i64 %r27, i64 %r28)
  ret i64 %r29
}

; ESCAPE Response__from_json: allocs=1 escape=1 local=0
define i64 @Response__from_json(i64 %p0) nounwind uwtable {
entry:
  %slot.d = alloca i64, align 8
  store i64 %p0, ptr %slot.d, align 8
  %r0 = load i64, ptr %slot.d, align 8
  %r1.p = getelementptr inbounds [7 x i8], ptr @.str.122, i64 0, i64 0
  %r1 = ptrtoint ptr %r1.p to i64
  %r2 = call i64 @nova_rt_dict_get(i64 %r0, i64 %r1)
  %r3 = load i64, ptr %slot.d, align 8
  %r4.p = getelementptr inbounds [8 x i8], ptr @.str.109, i64 0, i64 0
  %r4 = ptrtoint ptr %r4.p to i64
  %r5 = call i64 @nova_rt_dict_get(i64 %r3, i64 %r4)
  %r6 = load i64, ptr %slot.d, align 8
  %r7.p = getelementptr inbounds [5 x i8], ptr @.str.74, i64 0, i64 0
  %r7 = ptrtoint ptr %r7.p to i64
  %r8 = call i64 @nova_rt_dict_get(i64 %r6, i64 %r7)
  %r9 = load i64, ptr %slot.d, align 8
  %r10.p = getelementptr inbounds [7 x i8], ptr @.str.123, i64 0, i64 0
  %r10 = ptrtoint ptr %r10.p to i64
  %r11 = call i64 @nova_rt_dict_get(i64 %r9, i64 %r10)
  %r12.ptr = call ptr @nova_rt_struct_alloc(i64 40)
  %r12.thash = getelementptr i64, ptr %r12.ptr, i64 0
  store i64 7571514562849844, ptr %r12.thash, align 8
  %r12.f0 = getelementptr i64, ptr %r12.ptr, i64 1
  store i64 %r2, ptr %r12.f0, align 8
  %r12.f1 = getelementptr i64, ptr %r12.ptr, i64 2
  store i64 %r5, ptr %r12.f1, align 8
  %r12.f2 = getelementptr i64, ptr %r12.ptr, i64 3
  store i64 %r8, ptr %r12.f2, align 8
  %r12.f3 = getelementptr i64, ptr %r12.ptr, i64 4
  store i64 %r11, ptr %r12.f3, align 8
  %r12 = ptrtoint ptr %r12.ptr to i64
  ret i64 %r12
}

; ESCAPE Response__fields: allocs=1 escape=1 local=0
define i64 @Response__fields(i64 %p0) nounwind uwtable {
entry:
  %slot.self = alloca i64, align 8
  store i64 %p0, ptr %slot.self, align 8
  %r1.p = getelementptr inbounds [7 x i8], ptr @.str.122, i64 0, i64 0
  %r1 = ptrtoint ptr %r1.p to i64
  %r2.p = getelementptr inbounds [8 x i8], ptr @.str.109, i64 0, i64 0
  %r2 = ptrtoint ptr %r2.p to i64
  %r3.p = getelementptr inbounds [5 x i8], ptr @.str.74, i64 0, i64 0
  %r3 = ptrtoint ptr %r3.p to i64
  %r4.p = getelementptr inbounds [7 x i8], ptr @.str.123, i64 0, i64 0
  %r4 = ptrtoint ptr %r4.p to i64
  %r0 = call i64 @nova_rt_list_create()
  call i64 @nova_rt_list_append(i64 %r0, i64 %r1)
  call i64 @nova_rt_list_append(i64 %r0, i64 %r2)
  call i64 @nova_rt_list_append(i64 %r0, i64 %r3)
  call i64 @nova_rt_list_append(i64 %r0, i64 %r4)
  ret i64 %r0
}

; ESCAPE Response__type_name: allocs=0 escape=0 local=0
define i64 @Response__type_name(i64 %p0) nounwind uwtable {
entry:
  %slot.self = alloca i64, align 8
  store i64 %p0, ptr %slot.self, align 8
  %r0.p = getelementptr inbounds [9 x i8], ptr @.str.77, i64 0, i64 0
  %r0 = ptrtoint ptr %r0.p to i64
  ret i64 %r0
}

; ESCAPE Response__field_types: allocs=1 escape=1 local=0
define i64 @Response__field_types(i64 %p0) nounwind uwtable {
entry:
  %slot.self = alloca i64, align 8
  store i64 %p0, ptr %slot.self, align 8
  %r1.p = getelementptr inbounds [4 x i8], ptr @.str.114, i64 0, i64 0
  %r1 = ptrtoint ptr %r1.p to i64
  %r2.p = getelementptr inbounds [5 x i8], ptr @.str.113, i64 0, i64 0
  %r2 = ptrtoint ptr %r2.p to i64
  %r3.p = getelementptr inbounds [7 x i8], ptr @.str.78, i64 0, i64 0
  %r3 = ptrtoint ptr %r3.p to i64
  %r4.p = getelementptr inbounds [5 x i8], ptr @.str.124, i64 0, i64 0
  %r4 = ptrtoint ptr %r4.p to i64
  %r0 = call i64 @nova_rt_list_create()
  call i64 @nova_rt_list_append(i64 %r0, i64 %r1)
  call i64 @nova_rt_list_append(i64 %r0, i64 %r2)
  call i64 @nova_rt_list_append(i64 %r0, i64 %r3)
  call i64 @nova_rt_list_append(i64 %r0, i64 %r4)
  ret i64 %r0
}

; ESCAPE Response__field_names: allocs=1 escape=1 local=0
define i64 @Response__field_names(i64 %p0) nounwind uwtable {
entry:
  %slot.self = alloca i64, align 8
  store i64 %p0, ptr %slot.self, align 8
  %r1.p = getelementptr inbounds [7 x i8], ptr @.str.122, i64 0, i64 0
  %r1 = ptrtoint ptr %r1.p to i64
  %r2.p = getelementptr inbounds [8 x i8], ptr @.str.109, i64 0, i64 0
  %r2 = ptrtoint ptr %r2.p to i64
  %r3.p = getelementptr inbounds [5 x i8], ptr @.str.74, i64 0, i64 0
  %r3 = ptrtoint ptr %r3.p to i64
  %r4.p = getelementptr inbounds [7 x i8], ptr @.str.123, i64 0, i64 0
  %r4 = ptrtoint ptr %r4.p to i64
  %r0 = call i64 @nova_rt_list_create()
  call i64 @nova_rt_list_append(i64 %r0, i64 %r1)
  call i64 @nova_rt_list_append(i64 %r0, i64 %r2)
  call i64 @nova_rt_list_append(i64 %r0, i64 %r3)
  call i64 @nova_rt_list_append(i64 %r0, i64 %r4)
  ret i64 %r0
}

; ESCAPE Response__field_get: allocs=1 escape=0 local=1
define i64 @Response__field_get(i64 %p0, i64 %p1) nounwind uwtable {
entry:
  %slot.self = alloca i64, align 8
  store i64 %p0, ptr %slot.self, align 8
  %slot.name = alloca i64, align 8
  store i64 %p1, ptr %slot.name, align 8
  %slot._fg_box = alloca i64, align 8
  store i64 0, ptr %slot._fg_box, align 8
  %r0 = call i64 @nova_rt_list_create()
  store i64 %r0, ptr %slot._fg_box, align 8
  %r1 = load i64, ptr %slot.name, align 8
  %r2.p = getelementptr inbounds [7 x i8], ptr @.str.122, i64 0, i64 0
  %r2 = ptrtoint ptr %r2.p to i64
  %r3.p0 = inttoptr i64 %r1 to ptr
  %r3.p1 = inttoptr i64 %r2 to ptr
  %r3.sc = call i32 @strcmp(ptr %r3.p0, ptr %r3.p1)
  %r3.cmp = icmp eq i32 %r3.sc, 0
  %r3 = zext i1 %r3.cmp to i64
  %br_then3750 = icmp ne i64 %r3, 0
  br i1 %br_then3750, label %then375, label %else376
then375:
  %r4 = load i64, ptr %slot._fg_box, align 8
  %r5 = load i64, ptr %slot.self, align 8
  %r6.ptr = inttoptr i64 %r5 to ptr
  %r6.gep = getelementptr i64, ptr %r6.ptr, i64 1
  %r6 = load i64, ptr %r6.gep, align 8
  %r7 = call i64 @nova_rt_list_append_no_rc(i64 %r4, i64 %r6)
  %r8 = load i64, ptr %slot._fg_box, align 8
  %r9 = add i64 0, 0
  %r10.lp = inttoptr i64 %r8 to ptr
  %r10.dp = load ptr, ptr %r10.lp, align 8, !tbaa !2
  %r10.ep = getelementptr i64, ptr %r10.dp, i64 %r9
  %r10.lv = load i64, ptr %r10.ep, align 8, !tbaa !4
  %r10 = call i64 @nova_rt_unbox_elem(i64 %r10.lv)
  ret i64 %r10
else376:
  br label %endif377
endif377:
  %r11 = load i64, ptr %slot.name, align 8
  %r12.p = getelementptr inbounds [8 x i8], ptr @.str.109, i64 0, i64 0
  %r12 = ptrtoint ptr %r12.p to i64
  %r13.p0 = inttoptr i64 %r11 to ptr
  %r13.p1 = inttoptr i64 %r12 to ptr
  %r13.sc = call i32 @strcmp(ptr %r13.p0, ptr %r13.p1)
  %r13.cmp = icmp eq i32 %r13.sc, 0
  %r13 = zext i1 %r13.cmp to i64
  %br_then3781 = icmp ne i64 %r13, 0
  br i1 %br_then3781, label %then378, label %else379
then378:
  %r14 = load i64, ptr %slot._fg_box, align 8
  %r15 = load i64, ptr %slot.self, align 8
  %r16.ptr = inttoptr i64 %r15 to ptr
  %r16.gep = getelementptr i64, ptr %r16.ptr, i64 2
  %r16 = load i64, ptr %r16.gep, align 8
  %r17 = call i64 @nova_rt_list_append_no_rc(i64 %r14, i64 %r16)
  %r18 = load i64, ptr %slot._fg_box, align 8
  %r19 = add i64 0, 0
  %r20.lp = inttoptr i64 %r18 to ptr
  %r20.dp = load ptr, ptr %r20.lp, align 8, !tbaa !2
  %r20.ep = getelementptr i64, ptr %r20.dp, i64 %r19
  %r20.lv = load i64, ptr %r20.ep, align 8, !tbaa !4
  %r20 = call i64 @nova_rt_unbox_elem(i64 %r20.lv)
  ret i64 %r20
else379:
  br label %endif380
endif380:
  %r21 = load i64, ptr %slot.name, align 8
  %r22.p = getelementptr inbounds [5 x i8], ptr @.str.74, i64 0, i64 0
  %r22 = ptrtoint ptr %r22.p to i64
  %r23.p0 = inttoptr i64 %r21 to ptr
  %r23.p1 = inttoptr i64 %r22 to ptr
  %r23.sc = call i32 @strcmp(ptr %r23.p0, ptr %r23.p1)
  %r23.cmp = icmp eq i32 %r23.sc, 0
  %r23 = zext i1 %r23.cmp to i64
  %br_then3812 = icmp ne i64 %r23, 0
  br i1 %br_then3812, label %then381, label %else382
then381:
  %r24 = load i64, ptr %slot._fg_box, align 8
  %r25 = load i64, ptr %slot.self, align 8
  %r26.ptr = inttoptr i64 %r25 to ptr
  %r26.gep = getelementptr i64, ptr %r26.ptr, i64 3
  %r26 = load i64, ptr %r26.gep, align 8
  %r27 = call i64 @nova_rt_list_append_no_rc(i64 %r24, i64 %r26)
  %r28 = load i64, ptr %slot._fg_box, align 8
  %r29 = add i64 0, 0
  %r30.lp = inttoptr i64 %r28 to ptr
  %r30.dp = load ptr, ptr %r30.lp, align 8, !tbaa !2
  %r30.ep = getelementptr i64, ptr %r30.dp, i64 %r29
  %r30.lv = load i64, ptr %r30.ep, align 8, !tbaa !4
  %r30 = call i64 @nova_rt_unbox_elem(i64 %r30.lv)
  ret i64 %r30
else382:
  br label %endif383
endif383:
  %r31 = load i64, ptr %slot.name, align 8
  %r32.p = getelementptr inbounds [7 x i8], ptr @.str.123, i64 0, i64 0
  %r32 = ptrtoint ptr %r32.p to i64
  %r33.p0 = inttoptr i64 %r31 to ptr
  %r33.p1 = inttoptr i64 %r32 to ptr
  %r33.sc = call i32 @strcmp(ptr %r33.p0, ptr %r33.p1)
  %r33.cmp = icmp eq i32 %r33.sc, 0
  %r33 = zext i1 %r33.cmp to i64
  %br_then3843 = icmp ne i64 %r33, 0
  br i1 %br_then3843, label %then384, label %else385
then384:
  %r34 = load i64, ptr %slot._fg_box, align 8
  %r35 = load i64, ptr %slot.self, align 8
  %r36.ptr = inttoptr i64 %r35 to ptr
  %r36.gep = getelementptr i64, ptr %r36.ptr, i64 4
  %r36 = load i64, ptr %r36.gep, align 8
  %r37 = call i64 @nova_rt_list_append_no_rc(i64 %r34, i64 %r36)
  %r38 = load i64, ptr %slot._fg_box, align 8
  %r39 = add i64 0, 0
  %r40.lp = inttoptr i64 %r38 to ptr
  %r40.dp = load ptr, ptr %r40.lp, align 8, !tbaa !2
  %r40.ep = getelementptr i64, ptr %r40.dp, i64 %r39
  %r40.lv = load i64, ptr %r40.ep, align 8, !tbaa !4
  %r40 = call i64 @nova_rt_unbox_elem(i64 %r40.lv)
  ret i64 %r40
else385:
  br label %endif386
endif386:
  %r41 = add i64 0, 0
  ret i64 %r41
}

; ESCAPE __lambda_0: allocs=0 escape=0 local=0
define i64 @__lambda_0(i64 %p0, i64 %p1) nounwind uwtable {
entry:
  %slot.a = alloca i64, align 8
  store i64 %p0, ptr %slot.a, align 8
  %slot.r = alloca i64, align 8
  store i64 %p1, ptr %slot.r, align 8
  %r0 = load i64, ptr %slot.a, align 8
  %r1 = load i64, ptr %slot.r, align 8
  %r2 = call i64 @_fr_route_dispatch(i64 %r0, i64 %r1)
  ret i64 %r2
}

; ESCAPE __lambda_1: allocs=0 escape=0 local=0
define i64 @__lambda_1(i64 %p0, i64 %p1, i64 %p2, i64 %p3) nounwind uwtable {
entry:
  %slot.a = alloca i64, align 8
  store i64 %p0, ptr %slot.a, align 8
  %slot.m = alloca i64, align 8
  store i64 %p1, ptr %slot.m, align 8
  %slot.p = alloca i64, align 8
  store i64 %p2, ptr %slot.p, align 8
  %slot.b = alloca i64, align 8
  store i64 %p3, ptr %slot.b, align 8
  %r0 = load i64, ptr %slot.a, align 8
  %r1 = load i64, ptr %slot.m, align 8
  %r2 = load i64, ptr %slot.p, align 8
  %r3 = load i64, ptr %slot.b, align 8
  %r4 = call i64 @dispatch(i64 %r0, i64 %r1, i64 %r2, i64 %r3)
  ret i64 %r4
}

; ESCAPE __lambda_2: allocs=0 escape=0 local=0
define i64 @__lambda_2(i64 %p0, i64 %p1, i64 %p2, i64 %p3) nounwind uwtable {
entry:
  %slot.a = alloca i64, align 8
  store i64 %p0, ptr %slot.a, align 8
  %slot.m = alloca i64, align 8
  store i64 %p1, ptr %slot.m, align 8
  %slot.p = alloca i64, align 8
  store i64 %p2, ptr %slot.p, align 8
  %slot.b = alloca i64, align 8
  store i64 %p3, ptr %slot.b, align 8
  %r0 = load i64, ptr %slot.a, align 8
  %r1 = load i64, ptr %slot.m, align 8
  %r2 = load i64, ptr %slot.p, align 8
  %r3 = load i64, ptr %slot.b, align 8
  %r4 = call i64 @dispatch(i64 %r0, i64 %r1, i64 %r2, i64 %r3)
  ret i64 %r4
}

; ESCAPE __lambda_3: allocs=0 escape=0 local=0
define i64 @__lambda_3(i64 %p0, i64 %p1, i64 %p2) nounwind uwtable {
entry:
  %slot.mw = alloca i64, align 8
  store i64 %p0, ptr %slot.mw, align 8
  %slot.next = alloca i64, align 8
  store i64 %p1, ptr %slot.next, align 8
  %slot.req = alloca i64, align 8
  store i64 %p2, ptr %slot.req, align 8
  %r0 = load i64, ptr %slot.req, align 8
  %r1 = load i64, ptr %slot.next, align 8
  %r3 = load i64, ptr %slot.mw, align 8
  %r2.rec = inttoptr i64 %r3 to ptr
  %r2.fnraw = load i64, ptr %r2.rec, align 8
  %r2.fnptr = inttoptr i64 %r2.fnraw to ptr
  %r2 = call i64 %r2.fnptr(i64 %r3, i64 %r0, i64 %r1)
  ret i64 %r2
}

; ESCAPE __lambda_4: allocs=0 escape=0 local=0
define i64 @__lambda_4(i64 %p0, i64 %p1, i64 %p2) nounwind uwtable {
entry:
  %slot.origin = alloca i64, align 8
  store i64 %p0, ptr %slot.origin, align 8
  %slot.req = alloca i64, align 8
  store i64 %p1, ptr %slot.req, align 8
  %slot.next = alloca i64, align 8
  store i64 %p2, ptr %slot.next, align 8
  %r0 = load i64, ptr %slot.req, align 8
  %r2 = load i64, ptr %slot.next, align 8
  %r1.rec = inttoptr i64 %r2 to ptr
  %r1.fnraw = load i64, ptr %r1.rec, align 8
  %r1.fnptr = inttoptr i64 %r1.fnraw to ptr
  %r1 = call i64 %r1.fnptr(i64 %r2, i64 %r0)
  %r3 = load i64, ptr %slot.origin, align 8
  %r4 = call i64 @with_cors(i64 %r1, i64 %r3)
  ret i64 %r4
}

; ESCAPE __lambda_5: allocs=0 escape=0 local=0
define i64 @__lambda_5(i64 %p0, i64 %p1, i64 %p2, i64 %p3) nounwind uwtable {
entry:
  %slot.name = alloca i64, align 8
  store i64 %p0, ptr %slot.name, align 8
  %slot.value = alloca i64, align 8
  store i64 %p1, ptr %slot.value, align 8
  %slot.req = alloca i64, align 8
  store i64 %p2, ptr %slot.req, align 8
  %slot.next = alloca i64, align 8
  store i64 %p3, ptr %slot.next, align 8
  %r0 = load i64, ptr %slot.req, align 8
  %r2 = load i64, ptr %slot.next, align 8
  %r1.rec = inttoptr i64 %r2 to ptr
  %r1.fnraw = load i64, ptr %r1.rec, align 8
  %r1.fnptr = inttoptr i64 %r1.fnraw to ptr
  %r1 = call i64 %r1.fnptr(i64 %r2, i64 %r0)
  %r3 = load i64, ptr %slot.name, align 8
  %r4 = load i64, ptr %slot.value, align 8
  %r5 = call i64 @_fr_add_header(i64 %r1, i64 %r3, i64 %r4)
  ret i64 %r5
}

; ESCAPE __lambda_6: allocs=0 escape=0 local=0
define i64 @__lambda_6(i64 %p0, i64 %p1) nounwind uwtable {
entry:
  %slot.req = alloca i64, align 8
  store i64 %p0, ptr %slot.req, align 8
  %slot.next = alloca i64, align 8
  store i64 %p1, ptr %slot.next, align 8
  %r0 = load i64, ptr %slot.req, align 8
  %r1 = load i64, ptr %slot.next, align 8
  %r2 = call i64 @_fr_log_next(i64 %r0, i64 %r1)
  ret i64 %r2
}

; ESCAPE __lambda_7: allocs=0 escape=0 local=0
define i64 @__lambda_7(i64 %p0, i64 %p1, i64 %p2) nounwind uwtable {
entry:
  %slot.mw = alloca i64, align 8
  store i64 %p0, ptr %slot.mw, align 8
  %slot.next = alloca i64, align 8
  store i64 %p1, ptr %slot.next, align 8
  %slot.req = alloca i64, align 8
  store i64 %p2, ptr %slot.req, align 8
  %r0 = load i64, ptr %slot.req, align 8
  %r1 = load i64, ptr %slot.next, align 8
  %r3 = load i64, ptr %slot.mw, align 8
  %r2.rec = inttoptr i64 %r3 to ptr
  %r2.fnraw = load i64, ptr %r2.rec, align 8
  %r2.fnptr = inttoptr i64 %r2.fnraw to ptr
  %r2 = call i64 %r2.fnptr(i64 %r3, i64 %r0, i64 %r1)
  %r4 = call i64 @_coerce(i64 %r2)
  ret i64 %r4
}

; ESCAPE __lambda_8: allocs=0 escape=0 local=0
define i64 @__lambda_8(i64 %p0, i64 %p1) nounwind uwtable {
entry:
  %slot.a = alloca i64, align 8
  store i64 %p0, ptr %slot.a, align 8
  %slot.r = alloca i64, align 8
  store i64 %p1, ptr %slot.r, align 8
  %r0 = load i64, ptr %slot.a, align 8
  %r1 = load i64, ptr %slot.r, align 8
  %r2 = call i64 @_dispatch_terminal(i64 %r0, i64 %r1)
  ret i64 %r2
}

; ESCAPE __lambda_9: allocs=0 escape=0 local=0
define i64 @__lambda_9(i64 %p0, i64 %p1, i64 %p2, i64 %p3) nounwind uwtable {
entry:
  %slot.name = alloca i64, align 8
  store i64 %p0, ptr %slot.name, align 8
  %slot.value = alloca i64, align 8
  store i64 %p1, ptr %slot.value, align 8
  %slot.req = alloca i64, align 8
  store i64 %p2, ptr %slot.req, align 8
  %slot.next = alloca i64, align 8
  store i64 %p3, ptr %slot.next, align 8
  %r0 = load i64, ptr %slot.req, align 8
  %r2 = load i64, ptr %slot.next, align 8
  %r1.rec = inttoptr i64 %r2 to ptr
  %r1.fnraw = load i64, ptr %r1.rec, align 8
  %r1.fnptr = inttoptr i64 %r1.fnraw to ptr
  %r1 = call i64 %r1.fnptr(i64 %r2, i64 %r0)
  %r3 = load i64, ptr %slot.name, align 8
  %r4 = load i64, ptr %slot.value, align 8
  %r5 = call i64 @resp_set_header(i64 %r1, i64 %r3, i64 %r4)
  ret i64 %r5
}

; ESCAPE __lambda_10: allocs=0 escape=0 local=0
define i64 @__lambda_10(i64 %p0, i64 %p1, i64 %p2) nounwind uwtable {
entry:
  %slot.origin = alloca i64, align 8
  store i64 %p0, ptr %slot.origin, align 8
  %slot.req = alloca i64, align 8
  store i64 %p1, ptr %slot.req, align 8
  %slot.next = alloca i64, align 8
  store i64 %p2, ptr %slot.next, align 8
  %r0 = load i64, ptr %slot.req, align 8
  %r2 = load i64, ptr %slot.next, align 8
  %r1.rec = inttoptr i64 %r2 to ptr
  %r1.fnraw = load i64, ptr %r1.rec, align 8
  %r1.fnptr = inttoptr i64 %r1.fnraw to ptr
  %r1 = call i64 %r1.fnptr(i64 %r2, i64 %r0)
  %r3.p = getelementptr inbounds [28 x i8], ptr @.str.125, i64 0, i64 0
  %r3 = ptrtoint ptr %r3.p to i64
  %r4 = load i64, ptr %slot.origin, align 8
  %r5 = call i64 @resp_set_header(i64 %r1, i64 %r3, i64 %r4)
  ret i64 %r5
}

; ESCAPE __lambda_11: allocs=0 escape=0 local=0
define i64 @__lambda_11(i64 %p0, i64 %p1) nounwind uwtable {
entry:
  %slot.req = alloca i64, align 8
  store i64 %p0, ptr %slot.req, align 8
  %slot.next = alloca i64, align 8
  store i64 %p1, ptr %slot.next, align 8
  %r0 = load i64, ptr %slot.req, align 8
  %r1 = load i64, ptr %slot.next, align 8
  %r2 = call i64 @_t_log_next(i64 %r0, i64 %r1)
  ret i64 %r2
}

; ESCAPE __lambda_12: allocs=0 escape=0 local=0
define i64 @__lambda_12(i64 %p0, i64 %p1, i64 %p2, i64 %p3) nounwind uwtable {
entry:
  %slot.c = alloca i64, align 8
  store i64 %p0, ptr %slot.c, align 8
  %slot.ap = alloca i64, align 8
  store i64 %p1, ptr %slot.ap, align 8
  %slot.dc = alloca i64, align 8
  store i64 %p2, ptr %slot.dc, align 8
  %slot.z = alloca i64, align 8
  store i64 %p3, ptr %slot.z, align 8
  %r0 = load i64, ptr %slot.c, align 8
  %r1 = load i64, ptr %slot.ap, align 8
  %r2 = load i64, ptr %slot.dc, align 8
  %r3 = call i64 @_handle_req_done(i64 %r0, i64 %r1, i64 %r2)
  ret i64 %r3
}

; ESCAPE __lambda_13: allocs=0 escape=0 local=0
define i64 @__lambda_13(i64 %p0, i64 %p1, i64 %p2) nounwind uwtable {
entry:
  %slot.c = alloca i64, align 8
  store i64 %p0, ptr %slot.c, align 8
  %slot.ap = alloca i64, align 8
  store i64 %p1, ptr %slot.ap, align 8
  %slot.z = alloca i64, align 8
  store i64 %p2, ptr %slot.z, align 8
  %r0 = load i64, ptr %slot.c, align 8
  %r1 = load i64, ptr %slot.ap, align 8
  %r2 = call i64 @_handle_req_arena(i64 %r0, i64 %r1)
  ret i64 %r2
}

; ESCAPE __nfn___spawn_call_14: allocs=0 escape=0 local=0
define i64 @__nfn___spawn_call_14(i64 %p0, i64 %p1, i64 %p2) nounwind uwtable {
entry:
  %slot.ap = alloca i64, align 8
  store i64 %p0, ptr %slot.ap, align 8
  %slot.rq = alloca i64, align 8
  store i64 %p1, ptr %slot.rq, align 8
  %slot.c = alloca i64, align 8
  store i64 %p2, ptr %slot.c, align 8
  %r0 = load i64, ptr %slot.ap, align 8
  %r1 = load i64, ptr %slot.rq, align 8
  %r2 = load i64, ptr %slot.c, align 8
  %r3 = call i64 @_dispatch_run(i64 %r0, i64 %r1, i64 %r2)
  ret i64 %r3
}

; ESCAPE __lambda_15: allocs=0 escape=0 local=0
define i64 @__lambda_15(i64 %p0, i64 %p1, i64 %p2, i64 %p3) nounwind uwtable {
entry:
  %slot.c = alloca i64, align 8
  store i64 %p0, ptr %slot.c, align 8
  %slot.ap = alloca i64, align 8
  store i64 %p1, ptr %slot.ap, align 8
  %slot.dc = alloca i64, align 8
  store i64 %p2, ptr %slot.dc, align 8
  %slot.z = alloca i64, align 8
  store i64 %p3, ptr %slot.z, align 8
  %r0 = load i64, ptr %slot.c, align 8
  %r1 = load i64, ptr %slot.ap, align 8
  %r2 = load i64, ptr %slot.dc, align 8
  %r3 = call i64 @_handle_req_safe_done(i64 %r0, i64 %r1, i64 %r2)
  ret i64 %r3
}

; ESCAPE __lambda_16: allocs=0 escape=0 local=0
define i64 @__lambda_16(i64 %p0, i64 %p1, i64 %p2) nounwind uwtable {
entry:
  %slot.c = alloca i64, align 8
  store i64 %p0, ptr %slot.c, align 8
  %slot.ap = alloca i64, align 8
  store i64 %p1, ptr %slot.ap, align 8
  %slot.z = alloca i64, align 8
  store i64 %p2, ptr %slot.z, align 8
  %r0 = load i64, ptr %slot.c, align 8
  %r1 = load i64, ptr %slot.ap, align 8
  %r2 = call i64 @_handle_req_safe(i64 %r0, i64 %r1)
  ret i64 %r2
}

; ESCAPE h: allocs=0 escape=0 local=0
define i64 @h(i64 %p0) nounwind uwtable !dbg !200 {
entry:
  %slot.req = alloca i64, align 8, !dbg !201
  store i64 %p0, ptr %slot.req, align 8, !dbg !201
  %r0.p = getelementptr inbounds [15 x i8], ptr @.str.126, i64 0, i64 0, !dbg !202
  %r0 = ptrtoint ptr %r0.p to i64, !dbg !202
  ret i64 %r0, !dbg !202
}

; ESCAPE nova_user_main: allocs=0 escape=0 local=0
define i64 @nova_user_main() nounwind uwtable !dbg !203 {
entry:
  %slot.a = alloca i64, align 8, !dbg !204
  store i64 0, ptr %slot.a, align 8, !dbg !204
  %slot.r = alloca i64, align 8, !dbg !204
  store i64 0, ptr %slot.r, align 8, !dbg !204
  %r0 = call i64 @app(), !dbg !205
  store i64 %r0, ptr %slot.a, align 8, !dbg !205
  %r1 = add i64 %r0, 0, !dbg !206
  %r2.p = getelementptr inbounds [3 x i8], ptr @.str.127, i64 0, i64 0, !dbg !206
  %r2 = ptrtoint ptr %r2.p to i64, !dbg !206
  %r3.ptr = call ptr @nova_rt_struct_alloc(i64 8), !dbg !206
  %r3.tgep = getelementptr i64, ptr %r3.ptr, i64 0, !dbg !206
  %r3.tfn = ptrtoint ptr @__fnref_h to i64, !dbg !206
  store i64 %r3.tfn, ptr %r3.tgep, align 8, !dbg !206
  %r3 = ptrtoint ptr %r3.ptr to i64, !dbg !206
  %r4 = call i64 @get(i64 %r1, i64 %r2, i64 %r3), !dbg !206
  %r5 = add i64 %r0, 0, !dbg !207
  %r6.p = getelementptr inbounds [20 x i8], ptr @.str.128, i64 0, i64 0, !dbg !207
  %r6 = ptrtoint ptr %r6.p to i64, !dbg !207
  %r7 = add i64 0, 0, !dbg !207
  %r8 = call i64 @build_request(i64 %r6, i64 %r7), !dbg !207
  %r9 = call i64 @dispatch_req(i64 %r5, i64 %r8), !dbg !207
  store i64 %r9, ptr %slot.r, align 8, !dbg !207
  %r10.p = getelementptr inbounds [8 x i8], ptr @.str.129, i64 0, i64 0, !dbg !208
  %r10 = ptrtoint ptr %r10.p to i64, !dbg !208
  %r11 = add i64 %r9, 0, !dbg !208
  %r12.ptr = inttoptr i64 %r11 to ptr, !dbg !208
  %r12.gep = getelementptr i64, ptr %r12.ptr, i64 1, !dbg !208
  %r12 = load i64, ptr %r12.gep, align 8, !dbg !208
  %r13 = call i64 @nova_rt_int_to_str(i64 %r12), !dbg !208
  %r14 = call i64 @nova_rt_str_concat(i64 %r10, i64 %r13), !dbg !208
  %r15.p = getelementptr inbounds [7 x i8], ptr @.str.130, i64 0, i64 0, !dbg !208
  %r15 = ptrtoint ptr %r15.p to i64, !dbg !208
  %r16 = call i64 @nova_rt_str_concat(i64 %r14, i64 %r15), !dbg !208
  %r17 = add i64 %r9, 0, !dbg !208
  %r18.ptr = inttoptr i64 %r17 to ptr, !dbg !208
  %r18.gep = getelementptr i64, ptr %r18.ptr, i64 3, !dbg !208
  %r18 = load i64, ptr %r18.gep, align 8, !dbg !208
  %r19 = call i64 @nova_rt_str_concat(i64 %r16, i64 %r18), !dbg !208
  %r20 = call i64 @nova_rt_print_str(i64 %r19), !dbg !208
  ret i64 %r20, !dbg !208
}

; ESCAPE nova_main: allocs=0 escape=0 local=0
define i64 @nova_main() nounwind uwtable {
entry:
  %r0 = call i64 @nova_user_main()
  ret i64 0
}

; ESCAPE SUMMARY: allocs=40 escape=24 local=16 (40% local, RC-elidable)
define i64 @__tramp_0(i64 %record, i64 %p0) nounwind uwtable {
entry:
  %rec_ptr = inttoptr i64 %record to ptr
  %cap0_ptr = getelementptr i64, ptr %rec_ptr, i64 1
  %cap0 = load i64, ptr %cap0_ptr, align 8
  %result = call i64 @__lambda_0(i64 %cap0, i64 %p0)
  ret i64 %result
}

define i64 @__tramp_1(i64 %record, i64 %p0, i64 %p1, i64 %p2) nounwind uwtable {
entry:
  %rec_ptr = inttoptr i64 %record to ptr
  %cap0_ptr = getelementptr i64, ptr %rec_ptr, i64 1
  %cap0 = load i64, ptr %cap0_ptr, align 8
  %result = call i64 @__lambda_1(i64 %cap0, i64 %p0, i64 %p1, i64 %p2)
  ret i64 %result
}

define i64 @__tramp_2(i64 %record, i64 %p0, i64 %p1, i64 %p2) nounwind uwtable {
entry:
  %rec_ptr = inttoptr i64 %record to ptr
  %cap0_ptr = getelementptr i64, ptr %rec_ptr, i64 1
  %cap0 = load i64, ptr %cap0_ptr, align 8
  %result = call i64 @__lambda_2(i64 %cap0, i64 %p0, i64 %p1, i64 %p2)
  ret i64 %result
}

define i64 @__tramp_3(i64 %record, i64 %p0) nounwind uwtable {
entry:
  %rec_ptr = inttoptr i64 %record to ptr
  %cap0_ptr = getelementptr i64, ptr %rec_ptr, i64 1
  %cap0 = load i64, ptr %cap0_ptr, align 8
  %cap1_ptr = getelementptr i64, ptr %rec_ptr, i64 2
  %cap1 = load i64, ptr %cap1_ptr, align 8
  %result = call i64 @__lambda_3(i64 %cap0, i64 %cap1, i64 %p0)
  ret i64 %result
}

define i64 @__tramp_4(i64 %record, i64 %p0, i64 %p1) nounwind uwtable {
entry:
  %rec_ptr = inttoptr i64 %record to ptr
  %cap0_ptr = getelementptr i64, ptr %rec_ptr, i64 1
  %cap0 = load i64, ptr %cap0_ptr, align 8
  %result = call i64 @__lambda_4(i64 %cap0, i64 %p0, i64 %p1)
  ret i64 %result
}

define i64 @__tramp_5(i64 %record, i64 %p0, i64 %p1) nounwind uwtable {
entry:
  %rec_ptr = inttoptr i64 %record to ptr
  %cap0_ptr = getelementptr i64, ptr %rec_ptr, i64 1
  %cap0 = load i64, ptr %cap0_ptr, align 8
  %cap1_ptr = getelementptr i64, ptr %rec_ptr, i64 2
  %cap1 = load i64, ptr %cap1_ptr, align 8
  %result = call i64 @__lambda_5(i64 %cap0, i64 %cap1, i64 %p0, i64 %p1)
  ret i64 %result
}

define i64 @__tramp_6(i64 %record, i64 %p0, i64 %p1) nounwind uwtable {
entry:
  %result = call i64 @__lambda_6(i64 %p0, i64 %p1)
  ret i64 %result
}

define i64 @__tramp_7(i64 %record, i64 %p0) nounwind uwtable {
entry:
  %rec_ptr = inttoptr i64 %record to ptr
  %cap0_ptr = getelementptr i64, ptr %rec_ptr, i64 1
  %cap0 = load i64, ptr %cap0_ptr, align 8
  %cap1_ptr = getelementptr i64, ptr %rec_ptr, i64 2
  %cap1 = load i64, ptr %cap1_ptr, align 8
  %result = call i64 @__lambda_7(i64 %cap0, i64 %cap1, i64 %p0)
  ret i64 %result
}

define i64 @__tramp_8(i64 %record, i64 %p0) nounwind uwtable {
entry:
  %rec_ptr = inttoptr i64 %record to ptr
  %cap0_ptr = getelementptr i64, ptr %rec_ptr, i64 1
  %cap0 = load i64, ptr %cap0_ptr, align 8
  %result = call i64 @__lambda_8(i64 %cap0, i64 %p0)
  ret i64 %result
}

define i64 @__tramp_9(i64 %record, i64 %p0, i64 %p1) nounwind uwtable {
entry:
  %rec_ptr = inttoptr i64 %record to ptr
  %cap0_ptr = getelementptr i64, ptr %rec_ptr, i64 1
  %cap0 = load i64, ptr %cap0_ptr, align 8
  %cap1_ptr = getelementptr i64, ptr %rec_ptr, i64 2
  %cap1 = load i64, ptr %cap1_ptr, align 8
  %result = call i64 @__lambda_9(i64 %cap0, i64 %cap1, i64 %p0, i64 %p1)
  ret i64 %result
}

define i64 @__tramp_10(i64 %record, i64 %p0, i64 %p1) nounwind uwtable {
entry:
  %rec_ptr = inttoptr i64 %record to ptr
  %cap0_ptr = getelementptr i64, ptr %rec_ptr, i64 1
  %cap0 = load i64, ptr %cap0_ptr, align 8
  %result = call i64 @__lambda_10(i64 %cap0, i64 %p0, i64 %p1)
  ret i64 %result
}

define i64 @__tramp_11(i64 %record, i64 %p0, i64 %p1) nounwind uwtable {
entry:
  %result = call i64 @__lambda_11(i64 %p0, i64 %p1)
  ret i64 %result
}

define i64 @__tramp_12(i64 %record, i64 %p0) nounwind uwtable {
entry:
  %rec_ptr = inttoptr i64 %record to ptr
  %cap0_ptr = getelementptr i64, ptr %rec_ptr, i64 1
  %cap0 = load i64, ptr %cap0_ptr, align 8
  %cap1_ptr = getelementptr i64, ptr %rec_ptr, i64 2
  %cap1 = load i64, ptr %cap1_ptr, align 8
  %cap2_ptr = getelementptr i64, ptr %rec_ptr, i64 3
  %cap2 = load i64, ptr %cap2_ptr, align 8
  %result = call i64 @__lambda_12(i64 %cap0, i64 %cap1, i64 %cap2, i64 %p0)
  ret i64 %result
}

define i64 @__tramp_13(i64 %record, i64 %p0) nounwind uwtable {
entry:
  %rec_ptr = inttoptr i64 %record to ptr
  %cap0_ptr = getelementptr i64, ptr %rec_ptr, i64 1
  %cap0 = load i64, ptr %cap0_ptr, align 8
  %cap1_ptr = getelementptr i64, ptr %rec_ptr, i64 2
  %cap1 = load i64, ptr %cap1_ptr, align 8
  %result = call i64 @__lambda_13(i64 %cap0, i64 %cap1, i64 %p0)
  ret i64 %result
}

define i64 @__ntramp___spawn_call_14(i64 %record) nounwind uwtable {
entry:
  %rec_ptr = inttoptr i64 %record to ptr
  %cap0_ptr = getelementptr i64, ptr %rec_ptr, i64 1
  %cap0 = load i64, ptr %cap0_ptr, align 8
  %cap1_ptr = getelementptr i64, ptr %rec_ptr, i64 2
  %cap1 = load i64, ptr %cap1_ptr, align 8
  %cap2_ptr = getelementptr i64, ptr %rec_ptr, i64 3
  %cap2 = load i64, ptr %cap2_ptr, align 8
  %result = call i64 @__nfn___spawn_call_14(i64 %cap0, i64 %cap1, i64 %cap2)
  ret i64 %result
}

define i64 @__tramp_15(i64 %record, i64 %p0) nounwind uwtable {
entry:
  %rec_ptr = inttoptr i64 %record to ptr
  %cap0_ptr = getelementptr i64, ptr %rec_ptr, i64 1
  %cap0 = load i64, ptr %cap0_ptr, align 8
  %cap1_ptr = getelementptr i64, ptr %rec_ptr, i64 2
  %cap1 = load i64, ptr %cap1_ptr, align 8
  %cap2_ptr = getelementptr i64, ptr %rec_ptr, i64 3
  %cap2 = load i64, ptr %cap2_ptr, align 8
  %result = call i64 @__lambda_15(i64 %cap0, i64 %cap1, i64 %cap2, i64 %p0)
  ret i64 %result
}

define i64 @__tramp_16(i64 %record, i64 %p0) nounwind uwtable {
entry:
  %rec_ptr = inttoptr i64 %record to ptr
  %cap0_ptr = getelementptr i64, ptr %rec_ptr, i64 1
  %cap0 = load i64, ptr %cap0_ptr, align 8
  %cap1_ptr = getelementptr i64, ptr %rec_ptr, i64 2
  %cap1 = load i64, ptr %cap1_ptr, align 8
  %result = call i64 @__lambda_16(i64 %cap0, i64 %cap1, i64 %p0)
  ret i64 %result
}

define i64 @__fnref_h(i64 %record, i64 %p0) nounwind uwtable {
entry:
  %result = call i64 @h(i64 %p0)
  ret i64 %result
}

define i32 @main(i32 %argc, ptr %argv) nounwind uwtable {
entry:
  %argc64 = sext i32 %argc to i64
  %argv64 = ptrtoint ptr %argv to i64
  call void @nova_rt_init_args(i64 %argc64, i64 %argv64)
  ; RTTI: register struct type names + field metadata (hash-keyed, for json/show through any)
  %sreg.p0 = getelementptr inbounds [8 x i8], ptr @.str.112, i64 0, i64 0
  %sreg.pi0 = ptrtoint ptr %sreg.p0 to i64
  call void @nova_rt_register_struct_name(i64 229439833034990, i64 %sreg.pi0)
  call void @nova_rt_register_struct_meta(i64 229439833034990, i64 %sreg.pi0, i64 9)
  %sfld.n0 = getelementptr inbounds [7 x i8], ptr @.str.69, i64 0, i64 0
  %sfld.ni0 = ptrtoint ptr %sfld.n0 to i64
  %sfld.t0 = getelementptr inbounds [7 x i8], ptr @.str.78, i64 0, i64 0
  %sfld.ti0 = ptrtoint ptr %sfld.t0 to i64
  call void @nova_rt_register_struct_field(i64 229439833034990, i64 0, i64 %sfld.ni0, i64 %sfld.ti0)
  %sfld.n1 = getelementptr inbounds [5 x i8], ptr @.str.68, i64 0, i64 0
  %sfld.ni1 = ptrtoint ptr %sfld.n1 to i64
  %sfld.t1 = getelementptr inbounds [7 x i8], ptr @.str.78, i64 0, i64 0
  %sfld.ti1 = ptrtoint ptr %sfld.t1 to i64
  call void @nova_rt_register_struct_field(i64 229439833034990, i64 1, i64 %sfld.ni1, i64 %sfld.ti1)
  %sfld.n2 = getelementptr inbounds [9 x i8], ptr @.str.107, i64 0, i64 0
  %sfld.ni2 = ptrtoint ptr %sfld.n2 to i64
  %sfld.t2 = getelementptr inbounds [7 x i8], ptr @.str.78, i64 0, i64 0
  %sfld.ti2 = ptrtoint ptr %sfld.t2 to i64
  call void @nova_rt_register_struct_field(i64 229439833034990, i64 2, i64 %sfld.ni2, i64 %sfld.ti2)
  %sfld.n3 = getelementptr inbounds [7 x i8], ptr @.str.71, i64 0, i64 0
  %sfld.ni3 = ptrtoint ptr %sfld.n3 to i64
  %sfld.t3 = getelementptr inbounds [5 x i8], ptr @.str.113, i64 0, i64 0
  %sfld.ti3 = ptrtoint ptr %sfld.t3 to i64
  call void @nova_rt_register_struct_field(i64 229439833034990, i64 3, i64 %sfld.ni3, i64 %sfld.ti3)
  %sfld.n4 = getelementptr inbounds [6 x i8], ptr @.str.108, i64 0, i64 0
  %sfld.ni4 = ptrtoint ptr %sfld.n4 to i64
  %sfld.t4 = getelementptr inbounds [5 x i8], ptr @.str.113, i64 0, i64 0
  %sfld.ti4 = ptrtoint ptr %sfld.t4 to i64
  call void @nova_rt_register_struct_field(i64 229439833034990, i64 4, i64 %sfld.ni4, i64 %sfld.ti4)
  %sfld.n5 = getelementptr inbounds [8 x i8], ptr @.str.109, i64 0, i64 0
  %sfld.ni5 = ptrtoint ptr %sfld.n5 to i64
  %sfld.t5 = getelementptr inbounds [5 x i8], ptr @.str.113, i64 0, i64 0
  %sfld.ti5 = ptrtoint ptr %sfld.t5 to i64
  call void @nova_rt_register_struct_field(i64 229439833034990, i64 5, i64 %sfld.ni5, i64 %sfld.ti5)
  %sfld.n6 = getelementptr inbounds [5 x i8], ptr @.str.74, i64 0, i64 0
  %sfld.ni6 = ptrtoint ptr %sfld.n6 to i64
  %sfld.t6 = getelementptr inbounds [7 x i8], ptr @.str.78, i64 0, i64 0
  %sfld.ti6 = ptrtoint ptr %sfld.t6 to i64
  call void @nova_rt_register_struct_field(i64 229439833034990, i64 6, i64 %sfld.ni6, i64 %sfld.ti6)
  %sfld.n7 = getelementptr inbounds [6 x i8], ptr @.str.110, i64 0, i64 0
  %sfld.ni7 = ptrtoint ptr %sfld.n7 to i64
  %sfld.t7 = getelementptr inbounds [5 x i8], ptr @.str.113, i64 0, i64 0
  %sfld.ti7 = ptrtoint ptr %sfld.t7 to i64
  call void @nova_rt_register_struct_field(i64 229439833034990, i64 7, i64 %sfld.ni7, i64 %sfld.ti7)
  %sfld.n8 = getelementptr inbounds [5 x i8], ptr @.str.111, i64 0, i64 0
  %sfld.ni8 = ptrtoint ptr %sfld.n8 to i64
  %sfld.t8 = getelementptr inbounds [4 x i8], ptr @.str.114, i64 0, i64 0
  %sfld.ti8 = ptrtoint ptr %sfld.t8 to i64
  call void @nova_rt_register_struct_field(i64 229439833034990, i64 8, i64 %sfld.ni8, i64 %sfld.ti8)
  %sreg.p1 = getelementptr inbounds [9 x i8], ptr @.str.77, i64 0, i64 0
  %sreg.pi1 = ptrtoint ptr %sreg.p1 to i64
  call void @nova_rt_register_struct_name(i64 7571514562849844, i64 %sreg.pi1)
  call void @nova_rt_register_struct_meta(i64 7571514562849844, i64 %sreg.pi1, i64 4)
  %sfld.n9 = getelementptr inbounds [7 x i8], ptr @.str.122, i64 0, i64 0
  %sfld.ni9 = ptrtoint ptr %sfld.n9 to i64
  %sfld.t9 = getelementptr inbounds [4 x i8], ptr @.str.114, i64 0, i64 0
  %sfld.ti9 = ptrtoint ptr %sfld.t9 to i64
  call void @nova_rt_register_struct_field(i64 7571514562849844, i64 0, i64 %sfld.ni9, i64 %sfld.ti9)
  %sfld.n10 = getelementptr inbounds [8 x i8], ptr @.str.109, i64 0, i64 0
  %sfld.ni10 = ptrtoint ptr %sfld.n10 to i64
  %sfld.t10 = getelementptr inbounds [5 x i8], ptr @.str.113, i64 0, i64 0
  %sfld.ti10 = ptrtoint ptr %sfld.t10 to i64
  call void @nova_rt_register_struct_field(i64 7571514562849844, i64 1, i64 %sfld.ni10, i64 %sfld.ti10)
  %sfld.n11 = getelementptr inbounds [5 x i8], ptr @.str.74, i64 0, i64 0
  %sfld.ni11 = ptrtoint ptr %sfld.n11 to i64
  %sfld.t11 = getelementptr inbounds [7 x i8], ptr @.str.78, i64 0, i64 0
  %sfld.ti11 = ptrtoint ptr %sfld.t11 to i64
  call void @nova_rt_register_struct_field(i64 7571514562849844, i64 2, i64 %sfld.ni11, i64 %sfld.ti11)
  %sfld.n12 = getelementptr inbounds [7 x i8], ptr @.str.123, i64 0, i64 0
  %sfld.ni12 = ptrtoint ptr %sfld.n12 to i64
  %sfld.t12 = getelementptr inbounds [5 x i8], ptr @.str.124, i64 0, i64 0
  %sfld.ti12 = ptrtoint ptr %sfld.t12 to i64
  call void @nova_rt_register_struct_field(i64 7571514562849844, i64 3, i64 %sfld.ni12, i64 %sfld.ti12)
  call void @nova_rt_main_dispatch(i64 ptrtoint (ptr @nova_main to i64))
  call void @nova_rt_wait_all()
  call void @nova_rt_cleanup()
  ret i32 0
}

; String constants
@.str.0 = private unnamed_addr constant [7 x i8] c"200 OK\00"
@.str.1 = private unnamed_addr constant [12 x i8] c"201 Created\00"
@.str.2 = private unnamed_addr constant [15 x i8] c"204 No Content\00"
@.str.3 = private unnamed_addr constant [22 x i8] c"301 Moved Permanently\00"
@.str.4 = private unnamed_addr constant [10 x i8] c"302 Found\00"
@.str.5 = private unnamed_addr constant [16 x i8] c"400 Bad Request\00"
@.str.6 = private unnamed_addr constant [17 x i8] c"401 Unauthorized\00"
@.str.7 = private unnamed_addr constant [14 x i8] c"403 Forbidden\00"
@.str.8 = private unnamed_addr constant [14 x i8] c"404 Not Found\00"
@.str.9 = private unnamed_addr constant [26 x i8] c"500 Internal Server Error\00"
@.str.10 = private unnamed_addr constant [4 x i8] c" OK\00"
@.str.11 = private unnamed_addr constant [10 x i8] c"HTTP/1.1 \00"
@.str.12 = private unnamed_addr constant [3 x i8] c"\0D\0A\00"
@.str.13 = private unnamed_addr constant [15 x i8] c"Content-Type: \00"
@.str.14 = private unnamed_addr constant [17 x i8] c"Content-Length: \00"
@.str.15 = private unnamed_addr constant [20 x i8] c"Connection: close\0D\0A\00"
@.str.16 = private unnamed_addr constant [21 x i8] c"Server: NOVA Forge\0D\0A\00"
@.str.17 = private unnamed_addr constant [26 x i8] c"text/plain; charset=utf-8\00"
@.str.18 = private unnamed_addr constant [25 x i8] c"text/html; charset=utf-8\00"
@.str.19 = private unnamed_addr constant [17 x i8] c"application/json\00"
@.str.20 = private unnamed_addr constant [2 x i8] c" \00"
@.str.21 = private unnamed_addr constant [4 x i8] c"GET\00"
@.str.22 = private unnamed_addr constant [2 x i8] c"/\00"
@.str.23 = private unnamed_addr constant [5 x i8] c"\0D\0A\0D\0A\00"
@.str.24 = private unnamed_addr constant [1 x i8] c"\00"
@.str.25 = private unnamed_addr constant [2 x i8] c"?\00"
@.str.26 = private unnamed_addr constant [2 x i8] c"=\00"
@.str.27 = private unnamed_addr constant [2 x i8] c"&\00"
@.str.28 = private unnamed_addr constant [3 x i8] c": \00"
@.str.29 = private unnamed_addr constant [11 x i8] c"Location: \00"
@.str.30 = private unnamed_addr constant [20 x i8] c"Content-Length: 0\0D\0A\00"
@.str.31 = private unnamed_addr constant [6 x i8] c".html\00"
@.str.32 = private unnamed_addr constant [5 x i8] c".htm\00"
@.str.33 = private unnamed_addr constant [5 x i8] c".css\00"
@.str.34 = private unnamed_addr constant [24 x i8] c"text/css; charset=utf-8\00"
@.str.35 = private unnamed_addr constant [4 x i8] c".js\00"
@.str.36 = private unnamed_addr constant [38 x i8] c"application/javascript; charset=utf-8\00"
@.str.37 = private unnamed_addr constant [6 x i8] c".json\00"
@.str.38 = private unnamed_addr constant [5 x i8] c".png\00"
@.str.39 = private unnamed_addr constant [10 x i8] c"image/png\00"
@.str.40 = private unnamed_addr constant [5 x i8] c".jpg\00"
@.str.41 = private unnamed_addr constant [6 x i8] c".jpeg\00"
@.str.42 = private unnamed_addr constant [11 x i8] c"image/jpeg\00"
@.str.43 = private unnamed_addr constant [5 x i8] c".svg\00"
@.str.44 = private unnamed_addr constant [14 x i8] c"image/svg+xml\00"
@.str.45 = private unnamed_addr constant [6 x i8] c".wasm\00"
@.str.46 = private unnamed_addr constant [17 x i8] c"application/wasm\00"
@.str.47 = private unnamed_addr constant [25 x i8] c"application/octet-stream\00"
@.str.48 = private unnamed_addr constant [17 x i8] c"file not found: \00"
@.str.49 = private unnamed_addr constant [2 x i8] c"{\00"
@.str.50 = private unnamed_addr constant [2 x i8] c",\00"
@.str.51 = private unnamed_addr constant [2 x i8] c"\22\00"
@.str.52 = private unnamed_addr constant [4 x i8] c"\22:\22\00"
@.str.53 = private unnamed_addr constant [2 x i8] c"}\00"
@.str.54 = private unnamed_addr constant [16 x i8] c"Content-Length:\00"
@.str.55 = private unnamed_addr constant [32 x i8] c"\0D\0AAccess-Control-Allow-Origin: \00"
@.str.56 = private unnamed_addr constant [108 x i8] c"\0D\0AAccess-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS\0D\0AAccess-Control-Allow-Headers: Content-Type\00"
@.str.57 = private unnamed_addr constant [7 x i8] c"routes\00"
@.str.58 = private unnamed_addr constant [4 x i8] c"mws\00"
@.str.59 = private unnamed_addr constant [8 x i8] c"statics\00"
@.str.60 = private unnamed_addr constant [7 x i8] c"prefix\00"
@.str.61 = private unnamed_addr constant [5 x i8] c"POST\00"
@.str.62 = private unnamed_addr constant [4 x i8] c"PUT\00"
@.str.63 = private unnamed_addr constant [7 x i8] c"DELETE\00"
@.str.64 = private unnamed_addr constant [6 x i8] c"PATCH\00"
@.str.65 = private unnamed_addr constant [16 x i8] c"length mismatch\00"
@.str.66 = private unnamed_addr constant [2 x i8] c":\00"
@.str.67 = private unnamed_addr constant [9 x i8] c"mismatch\00"
@.str.68 = private unnamed_addr constant [5 x i8] c"path\00"
@.str.69 = private unnamed_addr constant [7 x i8] c"method\00"
@.str.70 = private unnamed_addr constant [2 x i8] c"*\00"
@.str.71 = private unnamed_addr constant [7 x i8] c"params\00"
@.str.72 = private unnamed_addr constant [19 x i8] c"method not allowed\00"
@.str.73 = private unnamed_addr constant [11 x i8] c"no route: \00"
@.str.74 = private unnamed_addr constant [5 x i8] c"body\00"
@.str.75 = private unnamed_addr constant [9 x i8] c"[forge] \00"
@.str.76 = private unnamed_addr constant [13 x i8] c"Content-Type\00"
@.str.77 = private unnamed_addr constant [9 x i8] c"Response\00"
@.str.78 = private unnamed_addr constant [7 x i8] c"string\00"
@.str.79 = private unnamed_addr constant [3 x i8] c"..\00"
@.str.80 = private unnamed_addr constant [2 x i8] c".\00"
@.str.81 = private unnamed_addr constant [2 x i8] c"\\\00"
@.str.82 = private unnamed_addr constant [20 x i8] c"unsafe path segment\00"
@.str.83 = private unnamed_addr constant [11 x i8] c"index.html\00"
@.str.84 = private unnamed_addr constant [16 x i8] c"no static match\00"
@.str.85 = private unnamed_addr constant [5 x i8] c"HEAD\00"
@.str.86 = private unnamed_addr constant [22 x i8] c"Internal Server Error\00"
@.str.87 = private unnamed_addr constant [10 x i8] c"Request {\00"
@.str.88 = private unnamed_addr constant [10 x i8] c" method: \00"
@.str.89 = private unnamed_addr constant [9 x i8] c", path: \00"
@.str.90 = private unnamed_addr constant [13 x i8] c", raw_path: \00"
@.str.91 = private unnamed_addr constant [11 x i8] c", params: \00"
@.str.92 = private unnamed_addr constant [10 x i8] c", query: \00"
@.str.93 = private unnamed_addr constant [12 x i8] c", headers: \00"
@.str.94 = private unnamed_addr constant [9 x i8] c", body: \00"
@.str.95 = private unnamed_addr constant [10 x i8] c", state: \00"
@.str.96 = private unnamed_addr constant [9 x i8] c", conn: \00"
@.str.97 = private unnamed_addr constant [3 x i8] c" }\00"
@.str.98 = private unnamed_addr constant [10 x i8] c"\22method\22:\00"
@.str.99 = private unnamed_addr constant [9 x i8] c",\22path\22:\00"
@.str.100 = private unnamed_addr constant [13 x i8] c",\22raw_path\22:\00"
@.str.101 = private unnamed_addr constant [11 x i8] c",\22params\22:\00"
@.str.102 = private unnamed_addr constant [10 x i8] c",\22query\22:\00"
@.str.103 = private unnamed_addr constant [12 x i8] c",\22headers\22:\00"
@.str.104 = private unnamed_addr constant [9 x i8] c",\22body\22:\00"
@.str.105 = private unnamed_addr constant [10 x i8] c",\22state\22:\00"
@.str.106 = private unnamed_addr constant [9 x i8] c",\22conn\22:\00"
@.str.107 = private unnamed_addr constant [9 x i8] c"raw_path\00"
@.str.108 = private unnamed_addr constant [6 x i8] c"query\00"
@.str.109 = private unnamed_addr constant [8 x i8] c"headers\00"
@.str.110 = private unnamed_addr constant [6 x i8] c"state\00"
@.str.111 = private unnamed_addr constant [5 x i8] c"conn\00"
@.str.112 = private unnamed_addr constant [8 x i8] c"Request\00"
@.str.113 = private unnamed_addr constant [5 x i8] c"dict\00"
@.str.114 = private unnamed_addr constant [4 x i8] c"int\00"
@.str.115 = private unnamed_addr constant [11 x i8] c"Response {\00"
@.str.116 = private unnamed_addr constant [10 x i8] c" status: \00"
@.str.117 = private unnamed_addr constant [11 x i8] c", halted: \00"
@.str.118 = private unnamed_addr constant [6 x i8] c"false\00"
@.str.119 = private unnamed_addr constant [5 x i8] c"true\00"
@.str.120 = private unnamed_addr constant [10 x i8] c"\22status\22:\00"
@.str.121 = private unnamed_addr constant [11 x i8] c",\22halted\22:\00"
@.str.122 = private unnamed_addr constant [7 x i8] c"status\00"
@.str.123 = private unnamed_addr constant [7 x i8] c"halted\00"
@.str.124 = private unnamed_addr constant [5 x i8] c"bool\00"
@.str.125 = private unnamed_addr constant [28 x i8] c"Access-Control-Allow-Origin\00"
@.str.126 = private unnamed_addr constant [15 x i8] c"from-nova-home\00"
@.str.127 = private unnamed_addr constant [3 x i8] c"/x\00"
@.str.128 = private unnamed_addr constant [20 x i8] c"GET /x HTTP/1.1\0D\0A\0D\0A\00"
@.str.129 = private unnamed_addr constant [8 x i8] c"status=\00"
@.str.130 = private unnamed_addr constant [7 x i8] c" body=\00"

; Debug metadata
!llvm.dbg.cu = !{!100}
!llvm.module.flags = !{!102, !103}

!100 = distinct !DICompileUnit(language: DW_LANG_C99, file: !101, producer: "NOVA Compiler", isOptimized: false, emissionKind: LineTablesOnly)
!101 = !DIFile(filename: "app.nova", directory: ".")
!102 = !{i32 2, !"CodeView", i32 1}
!103 = !{i32 2, !"Debug Info Version", i32 3}
!104 = !DISubroutineType(types: !105)
!105 = !{null}
!200 = distinct !DISubprogram(name: "h", scope: !101, file: !101, line: 5, type: !104, scopeLine: 5, spFlags: DISPFlagDefinition, unit: !100)
!201 = !DILocation(line: 5, column: 0, scope: !200)
!203 = distinct !DISubprogram(name: "nova_user_main", scope: !101, file: !101, line: 8, type: !104, scopeLine: 8, spFlags: DISPFlagDefinition, unit: !100)
!204 = !DILocation(line: 8, column: 0, scope: !203)
!202 = !DILocation(line: 6, column: 0, scope: !200)
!205 = !DILocation(line: 9, column: 0, scope: !203)
!206 = !DILocation(line: 10, column: 0, scope: !203)
!207 = !DILocation(line: 11, column: 0, scope: !203)
!208 = !DILocation(line: 12, column: 0, scope: !203)

; TBAA metadata
!0 = !{!"NOVA TBAA"}
!1 = !{!"list_data_ptr", !0}
!2 = !{!1, !1, i64 0}
!3 = !{!"list_elem", !0}
!4 = !{!3, !3, i64 0}
!5 = !{!"list_size", !0}
!6 = !{!5, !5, i64 0}
!90 = !{!"branch_weights", i32 2000, i32 1}
