; NOVA IR-Pipeline Compiler Output
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

@__nova_error_flag = thread_local global i64 0
@__nova_error_msg = thread_local global i64 0

; Runtime declarations
declare i32 @puts(ptr) nounwind
declare i32 @printf(ptr, ...) nounwind
declare i32 @strcmp(ptr, ptr) nounwind readonly
declare i64 @nova_rt_list_create() nounwind
declare i64 @nova_rt_deep_copy(i64) nounwind
declare i64 @nova_rt_list_create_filled(i64, i64) nounwind
declare i64 @nova_rt_list_append(i64, i64) nounwind
declare i64 @nova_rt_list_get(i64, i64) nounwind readonly
declare i64 @nova_rt_list_len(i64) nounwind readonly
declare i64 @nova_rt_dict_create() nounwind
declare i64 @nova_rt_dict_set(i64, i64, i64) nounwind
declare i64 @nova_rt_dict_get(i64, i64) nounwind readonly
declare i64 @nova_rt_dict_contains(i64, i64) nounwind readonly
declare i64 @nova_rt_str_concat(i64, i64) nounwind
declare i64 @nova_rt_int_to_str(i64) nounwind
declare i64 @nova_rt_parse_int(i64) nounwind readonly
declare i64 @nova_rt_len(i64) nounwind readonly
declare i64 @nova_rt_len_any(i64) nounwind readonly
declare i64 @nova_rt_ord(i64) nounwind readonly
declare i64 @nova_rt_chr(i64) nounwind
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
declare i64 @nova_rt_args() nounwind
declare void @nova_rt_exit(i64) nounwind
declare i64 @nova_rt_split(i64, i64) nounwind
declare i64 @nova_rt_join(i64, i64) nounwind
declare i64 @nova_rt_upper(i64) nounwind
declare i64 @nova_rt_lower(i64) nounwind
declare i64 @nova_rt_trim(i64) nounwind
declare i64 @nova_rt_replace(i64, i64, i64) nounwind
declare i64 @nova_rt_starts_with(i64, i64) nounwind readonly
declare i64 @nova_rt_ends_with(i64, i64) nounwind readonly
declare i64 @nova_rt_print_any(i64) nounwind
declare i64 @nova_rt_print_bool(i64) nounwind
declare i64 @nova_rt_print_float(i64) nounwind
declare i64 @nova_rt_print_int(i64) nounwind
declare i64 @nova_rt_print_str(i64) nounwind
declare i64 @nova_rt_float_bits(i64) nounwind
declare i64 @nova_rt_float_to_str(i64) nounwind
declare ptr @nova_rt_struct_alloc(i64) nounwind
declare i64 @nova_rt_slice(i64, i64, i64) nounwind
declare i64 @nova_rt_slice_any(i64, i64, i64) nounwind
declare i64 @nova_rt_repeat(i64, i64) nounwind
declare i64 @nova_rt_chars(i64) nounwind
declare i64 @nova_rt_time_ms() nounwind
declare i64 @nova_rt_sleep_ms(i64) nounwind
declare i64 @nova_rt_clock_ns() nounwind
declare i64 @nova_rt_type_of(i64) nounwind
declare i64 @nova_rt_range(i64) nounwind
declare i64 @nova_rt_range_from_to(i64, i64) nounwind
declare i64 @nova_rt_dict_keys(i64) nounwind readonly
declare i64 @nova_rt_dict_values(i64) nounwind readonly
declare i64 @nova_rt_dict_items(i64) nounwind readonly
declare i64 @nova_rt_for_iter_init(i64) nounwind
declare i64 @nova_rt_dict_has(i64, i64) nounwind readonly
declare i64 @nova_rt_dict_del(i64, i64) nounwind
declare i64 @nova_rt_system(i64) nounwind
declare i64 @nova_rt_exec(i64) nounwind
declare i64 @nova_rt_create_string(ptr) nounwind
declare void @nova_rt_init_args(i64, i64) nounwind
declare void @nova_rt_wait_all() nounwind
declare void @nova_rt_cleanup() nounwind
declare i64 @nova_rt_channel_create() nounwind
declare i64 @nova_rt_channel_send(i64, i64) nounwind
declare i64 @nova_rt_channel_send_move(i64, i64) nounwind
declare i64 @nova_rt_channel_recv(i64) nounwind
declare i64 @nova_rt_channel_close(i64) nounwind
declare i64 @nova_rt_channel_select(i64, i64) nounwind
declare i64 @nova_rt_select(i64) nounwind
declare i64 @nova_rt_channel_recv_timeout(i64, i64) nounwind
declare i64 @nova_rt_spawn(i64, i64) nounwind
declare i64 @nova_rt_monitor(i64) nounwind
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
declare i64 @nova_rt_write_raw(i64) nounwind
declare i64 @nova_rt_abs(i64) nounwind readnone
declare i64 @nova_rt_max(i64, i64) nounwind readnone
declare i64 @nova_rt_min(i64, i64) nounwind readnone
declare i64 @nova_rt_sqrt(i64) nounwind readnone
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
declare i64 @nova_rt_random_int(i64, i64) nounwind
declare i64 @nova_rt_random_float() nounwind
declare i64 @nova_rt_json_parse(i64) nounwind
declare i64 @nova_rt_json_stringify(i64) nounwind
declare i64 @nova_rt_regex_match(i64, i64) nounwind
declare i64 @nova_rt_regex_find(i64, i64) nounwind
declare i64 @nova_rt_regex_replace(i64, i64, i64) nounwind
declare i64 @nova_rt_regex_split(i64, i64) nounwind
declare i64 @nova_rt_path_ext(i64) nounwind
declare i64 @nova_rt_tcp_connect(i64, i64) nounwind
declare i64 @nova_rt_tcp_listen(i64) nounwind
declare i64 @nova_rt_tcp_accept(i64) nounwind
declare i64 @nova_rt_tcp_send(i64, i64) nounwind
declare i64 @nova_rt_tcp_recv(i64) nounwind
declare void @nova_rt_tcp_close(i64) nounwind
declare i64 @nova_rt_bytes_create(i64) nounwind
declare i64 @nova_rt_bytes_get(i64, i64) nounwind
declare void @nova_rt_bytes_set(i64, i64, i64) nounwind
declare i64 @nova_rt_bytes_len(i64) nounwind
declare i64 @nova_rt_bytes_slice(i64, i64, i64) nounwind
declare i64 @nova_rt_bytes_to_str(i64) nounwind
declare i64 @nova_rt_str_to_bytes(i64) nounwind
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
declare i64 @nova_rt_set_create() nounwind
declare i64 @nova_rt_set_add(i64, i64) nounwind
declare i64 @nova_rt_set_has(i64, i64) nounwind readonly
declare i64 @nova_rt_set_remove(i64, i64) nounwind
declare i64 @nova_rt_set_len(i64) nounwind readonly
declare i64 @nova_rt_set_to_list(i64) nounwind
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
declare i64 @nova_rt_list_dir(i64) nounwind
declare i64 @nova_rt_hash(i64) nounwind readnone
declare i64 @nova_rt_sha256(i64) nounwind
declare i64 @nova_rt_sha256_bytes(i64, i64) nounwind
declare i64 @nova_rt_hmac_sha256(i64, i64) nounwind
declare i64 @nova_rt_hex_encode(i64) nounwind
declare i64 @nova_rt_hex_decode(i64) nounwind
declare i64 @nova_rt_base64_encode(i64) nounwind
declare i64 @nova_rt_base64_decode(i64) nounwind
declare i64 @nova_rt_uuid4() nounwind
declare i64 @nova_rt_random_bytes(i64) nounwind
declare i64 @nova_rt_dir_walk(i64) nounwind
declare i64 @nova_rt_flatten(i64) nounwind
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
declare i64 @nova_rt_tensor_to_list(i64) nounwind
declare i64 @nova_rt_ok(i64) nounwind
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
declare i64 @nova_rt_result_map(i64, i64) nounwind
declare i64 @nova_rt_result_map_err(i64, i64) nounwind
declare i64 @nova_rt_result_and_then(i64, i64) nounwind
declare i64 @nova_rt_result_or_else(i64, i64) nounwind
declare i64 @nova_rt_format(i64, i64) nounwind
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
declare void @nova_rt_set_arena_mode() nounwind
declare i64 @nova_rt_is_arena_mode() nounwind readnone
declare i64 @nova_rt_semver_parse(i64) nounwind
declare i64 @nova_rt_semver_compare(i64, i64) nounwind readonly
declare i64 @nova_rt_semver_satisfies(i64, i64) nounwind readonly
declare i64 @nova_rt_semver_format(i64, i64, i64) nounwind
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

; Extern (FFI) declarations
declare i64 @my_c_add(i64, i64) nounwind
declare double @my_c_sqrt(double) nounwind
define i64 @nova_ffi_my_c_sqrt(i64 %a0) nounwind {
entry:
  %f0 = bitcast i64 %a0 to double
  %r = call double @my_c_sqrt(double %f0)
  %ri = bitcast double %r to i64
  ret i64 %ri
}
declare i64 @my_c_strlen(ptr) nounwind
define i64 @nova_ffi_my_c_strlen(i64 %a0) nounwind {
entry:
  %p0 = inttoptr i64 %a0 to ptr
  %r = call i64 @my_c_strlen(ptr %p0)
  ret i64 %r
}
declare i64 @my_c_strchr_idx(ptr, i64) nounwind
define i64 @nova_ffi_my_c_strchr_idx(i64 %a0, i64 %a1) nounwind {
entry:
  %p0 = inttoptr i64 %a0 to ptr
  %r = call i64 @my_c_strchr_idx(ptr %p0, i64 %a1)
  ret i64 %r
}
declare void @my_c_log_msg(ptr) nounwind
define i64 @nova_ffi_my_c_log_msg(i64 %a0) nounwind {
entry:
  %p0 = inttoptr i64 %a0 to ptr
  call void @my_c_log_msg(ptr %p0)
  ret i64 0
}
declare i64 @my_c_count_calls() nounwind

define i64 @nova_user_main() nounwind !dbg !200 {
entry:
  %slot.a = alloca i64, align 8, !dbg !201
  store i64 0, ptr %slot.a, align 8, !dbg !201
  %slot.s = alloca i64, align 8, !dbg !201
  store i64 0, ptr %slot.s, align 8, !dbg !201
  %slot.l = alloca i64, align 8, !dbg !201
  store i64 0, ptr %slot.l, align 8, !dbg !201
  %slot.idx = alloca i64, align 8, !dbg !201
  store i64 0, ptr %slot.idx, align 8, !dbg !201
  %slot.n = alloca i64, align 8, !dbg !201
  store i64 0, ptr %slot.n, align 8, !dbg !201
  %slot.n2 = alloca i64, align 8, !dbg !201
  store i64 0, ptr %slot.n2, align 8, !dbg !201
  %r0 = add i64 40, 0, !dbg !202
  %r1 = add i64 2, 0, !dbg !202
  %r2 = call i64 @my_c_add(i64 %r0, i64 %r1), !dbg !202
  store i64 %r2, ptr %slot.a, align 8, !dbg !202
  %r3.p = getelementptr inbounds [13 x i8], ptr @.str.0, i64 0, i64 0, !dbg !203
  %r3 = ptrtoint ptr %r3.p to i64, !dbg !203
  %r4 = call i64 @nova_rt_print_str(i64 %r3), !dbg !203
  %r5 = add i64 %r2, 0, !dbg !204
  %r6 = call i64 @nova_rt_print_any(i64 %r5), !dbg !204
  %r7 = add i64 16, 0, !dbg !205
  %r8 = call i64 @nova_rt_int_to_float(i64 %r7), !dbg !205
  %r9 = call i64 @nova_ffi_my_c_sqrt(i64 %r8), !dbg !205
  store i64 %r9, ptr %slot.s, align 8, !dbg !205
  %r10.p = getelementptr inbounds [18 x i8], ptr @.str.1, i64 0, i64 0, !dbg !206
  %r10 = ptrtoint ptr %r10.p to i64, !dbg !206
  %r11 = call i64 @nova_rt_print_str(i64 %r10), !dbg !206
  %r12 = add i64 %r9, 0, !dbg !207
  %r13 = call i64 @nova_rt_print_any(i64 %r12), !dbg !207
  %r14.p = getelementptr inbounds [11 x i8], ptr @.str.2, i64 0, i64 0, !dbg !208
  %r14 = ptrtoint ptr %r14.p to i64, !dbg !208
  %r15 = call i64 @nova_rt_print_str(i64 %r14), !dbg !208
  %r16 = add i64 %r9, 0, !dbg !209
  %r17 = call i64 @nova_rt_print_any(i64 %r16), !dbg !209
  %r18.p = getelementptr inbounds [12 x i8], ptr @.str.3, i64 0, i64 0, !dbg !210
  %r18 = ptrtoint ptr %r18.p to i64, !dbg !210
  %r19 = call i64 @nova_ffi_my_c_strlen(i64 %r18), !dbg !210
  store i64 %r19, ptr %slot.l, align 8, !dbg !210
  %r20.p = getelementptr inbounds [24 x i8], ptr @.str.4, i64 0, i64 0, !dbg !211
  %r20 = ptrtoint ptr %r20.p to i64, !dbg !211
  %r21 = call i64 @nova_rt_print_str(i64 %r20), !dbg !211
  %r22 = add i64 %r19, 0, !dbg !212
  %r23 = call i64 @nova_rt_print_any(i64 %r22), !dbg !212
  %r24.p = getelementptr inbounds [6 x i8], ptr @.str.5, i64 0, i64 0, !dbg !213
  %r24 = ptrtoint ptr %r24.p to i64, !dbg !213
  %r25.p = getelementptr inbounds [2 x i8], ptr @.str.6, i64 0, i64 0, !dbg !213
  %r25 = ptrtoint ptr %r25.p to i64, !dbg !213
  %r26 = call i64 @nova_rt_ord(i64 %r25), !dbg !213
  %r27 = call i64 @nova_ffi_my_c_strchr_idx(i64 %r24, i64 %r26), !dbg !213
  store i64 %r27, ptr %slot.idx, align 8, !dbg !213
  %r28.p = getelementptr inbounds [27 x i8], ptr @.str.7, i64 0, i64 0, !dbg !214
  %r28 = ptrtoint ptr %r28.p to i64, !dbg !214
  %r29 = call i64 @nova_rt_print_str(i64 %r28), !dbg !214
  %r30 = add i64 %r27, 0, !dbg !215
  %r31 = call i64 @nova_rt_print_any(i64 %r30), !dbg !215
  %r32.p = getelementptr inbounds [38 x i8], ptr @.str.8, i64 0, i64 0, !dbg !216
  %r32 = ptrtoint ptr %r32.p to i64, !dbg !216
  %r33 = call i64 @nova_ffi_my_c_log_msg(i64 %r32), !dbg !216
  %r34 = call i64 @my_c_count_calls(), !dbg !217
  store i64 %r34, ptr %slot.n, align 8, !dbg !217
  %r35.p = getelementptr inbounds [28 x i8], ptr @.str.9, i64 0, i64 0, !dbg !218
  %r35 = ptrtoint ptr %r35.p to i64, !dbg !218
  %r36 = call i64 @nova_rt_print_str(i64 %r35), !dbg !218
  %r37 = add i64 %r34, 0, !dbg !219
  %r38 = call i64 @nova_rt_print_any(i64 %r37), !dbg !219
  %r39.p = getelementptr inbounds [12 x i8], ptr @.str.10, i64 0, i64 0, !dbg !220
  %r39 = ptrtoint ptr %r39.p to i64, !dbg !220
  %r40 = call i64 @nova_ffi_my_c_log_msg(i64 %r39), !dbg !220
  %r41 = call i64 @my_c_count_calls(), !dbg !221
  store i64 %r41, ptr %slot.n2, align 8, !dbg !221
  %r42.p = getelementptr inbounds [29 x i8], ptr @.str.11, i64 0, i64 0, !dbg !222
  %r42 = ptrtoint ptr %r42.p to i64, !dbg !222
  %r43 = call i64 @nova_rt_print_str(i64 %r42), !dbg !222
  %r44 = add i64 %r41, 0, !dbg !223
  %r45 = call i64 @nova_rt_print_any(i64 %r44), !dbg !223
  ret i64 %r45, !dbg !223
}

define i64 @nova_main() nounwind {
entry:
  %r0 = call i64 @nova_user_main()
  ret i64 0
}

define i32 @main(i32 %argc, ptr %argv) nounwind {
entry:
  %argc64 = sext i32 %argc to i64
  %argv64 = ptrtoint ptr %argv to i64
  call void @nova_rt_init_args(i64 %argc64, i64 %argv64)
  call i64 @nova_main()
  call void @nova_rt_wait_all()
  call void @nova_rt_cleanup()
  ret i32 0
}

; String constants
@.str.0 = private unnamed_addr constant [13 x i8] c"add(40, 2) =\00"
@.str.1 = private unnamed_addr constant [18 x i8] c"sqrt(16.0) bits =\00"
@.str.2 = private unnamed_addr constant [11 x i8] c"as float =\00"
@.str.3 = private unnamed_addr constant [12 x i8] c"hello world\00"
@.str.4 = private unnamed_addr constant [24 x i8] c"strlen(\22hello world\22) =\00"
@.str.5 = private unnamed_addr constant [6 x i8] c"hello\00"
@.str.6 = private unnamed_addr constant [2 x i8] c"l\00"
@.str.7 = private unnamed_addr constant [27 x i8] c"strchr(\22hello\22, 'l') idx =\00"
@.str.8 = private unnamed_addr constant [38 x i8] c"logging from NOVA via FFI void return\00"
@.str.9 = private unnamed_addr constant [28 x i8] c"count_calls after one log =\00"
@.str.10 = private unnamed_addr constant [12 x i8] c"another log\00"
@.str.11 = private unnamed_addr constant [29 x i8] c"count_calls after two logs =\00"

; Debug metadata
!llvm.dbg.cu = !{!100}
!llvm.module.flags = !{!102, !103}

!100 = distinct !DICompileUnit(language: DW_LANG_C99, file: !101, producer: "NOVA Compiler", isOptimized: false, emissionKind: LineTablesOnly)
!101 = !DIFile(filename: "ffi_full_test.nova", directory: ".")
!102 = !{i32 2, !"CodeView", i32 1}
!103 = !{i32 2, !"Debug Info Version", i32 3}
!104 = !DISubroutineType(types: !105)
!105 = !{null}
!200 = distinct !DISubprogram(name: "nova_user_main", scope: !101, file: !101, line: 10, type: !104, scopeLine: 10, spFlags: DISPFlagDefinition, unit: !100)
!201 = !DILocation(line: 10, column: 0, scope: !200)
!202 = !DILocation(line: 11, column: 0, scope: !200)
!203 = !DILocation(line: 12, column: 0, scope: !200)
!204 = !DILocation(line: 13, column: 0, scope: !200)
!205 = !DILocation(line: 15, column: 0, scope: !200)
!206 = !DILocation(line: 16, column: 0, scope: !200)
!207 = !DILocation(line: 17, column: 0, scope: !200)
!208 = !DILocation(line: 18, column: 0, scope: !200)
!209 = !DILocation(line: 19, column: 0, scope: !200)
!210 = !DILocation(line: 21, column: 0, scope: !200)
!211 = !DILocation(line: 22, column: 0, scope: !200)
!212 = !DILocation(line: 23, column: 0, scope: !200)
!213 = !DILocation(line: 25, column: 0, scope: !200)
!214 = !DILocation(line: 26, column: 0, scope: !200)
!215 = !DILocation(line: 27, column: 0, scope: !200)
!216 = !DILocation(line: 29, column: 0, scope: !200)
!217 = !DILocation(line: 30, column: 0, scope: !200)
!218 = !DILocation(line: 31, column: 0, scope: !200)
!219 = !DILocation(line: 32, column: 0, scope: !200)
!220 = !DILocation(line: 34, column: 0, scope: !200)
!221 = !DILocation(line: 35, column: 0, scope: !200)
!222 = !DILocation(line: 36, column: 0, scope: !200)
!223 = !DILocation(line: 37, column: 0, scope: !200)

; TBAA metadata
!0 = !{!"NOVA TBAA"}
!1 = !{!"list_data_ptr", !0}
!2 = !{!1, !1, i64 0}
!3 = !{!"list_elem", !0}
!4 = !{!3, !3, i64 0}
!5 = !{!"list_size", !0}
!6 = !{!5, !5, i64 0}
!90 = !{!"branch_weights", i32 2000, i32 1}
!91 = distinct !{!91, !92, !93}
!92 = !{!"llvm.loop.unroll.enable"}
!93 = !{!"llvm.loop.vectorize.enable", i1 true}
