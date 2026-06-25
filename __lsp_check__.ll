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
declare i64 @nova_rt_shell(i64) nounwind
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
declare void @nova_rt_set_arena_mode(i64) nounwind
declare i64 @nova_rt_is_arena_mode() nounwind
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

define i64 @take_any(i64 %p0) nounwind !dbg !200 {
entry:
  %slot.v = alloca i64, align 8, !dbg !201
  store i64 %p0, ptr %slot.v, align 8, !dbg !201
  %r0 = load i64, ptr %slot.v, align 8, !dbg !202
  ret i64 %r0, !dbg !202
}

define i64 @sumlist(i64 %p0) nounwind !dbg !203 {
entry:
  %slot.xs = alloca i64, align 8, !dbg !204
  store i64 %p0, ptr %slot.xs, align 8, !dbg !204
  %slot.s = alloca i64, align 8, !dbg !204
  store i64 0, ptr %slot.s, align 8, !dbg !204
  %slot.i = alloca i64, align 8, !dbg !204
  store i64 0, ptr %slot.i, align 8, !dbg !204
  %r0 = add i64 0, 0, !dbg !205
  store i64 %r0, ptr %slot.s, align 8, !dbg !205
  %r1 = add i64 0, 0, !dbg !206
  store i64 %r1, ptr %slot.i, align 8, !dbg !206
  br label %while_hdr0, !dbg !207
while_hdr0:
  %r2 = load i64, ptr %slot.i, align 8, !dbg !207
  %r3 = load i64, ptr %slot.xs, align 8, !dbg !207
  %r4.lp = inttoptr i64 %r3 to ptr, !dbg !207
  %r4.szp = getelementptr i64, ptr %r4.lp, i64 1, !dbg !207
  %r4 = load i64, ptr %r4.szp, align 8, !tbaa !6, !dbg !207
  %r5.cmp = icmp slt i64 %r2, %r4, !dbg !207
  %r5 = zext i1 %r5.cmp to i64, !dbg !207
  %br_while_body1 = icmp ne i64 %r5, 0, !dbg !207
  br i1 %br_while_body1, label %while_body1, label %while_exit2, !prof !90, !dbg !207
while_body1:
  %r6 = load i64, ptr %slot.s, align 8, !dbg !208
  %r7 = load i64, ptr %slot.xs, align 8, !dbg !208
  %r8 = load i64, ptr %slot.i, align 8, !dbg !208
  %r9.lp = inttoptr i64 %r7 to ptr, !dbg !208
  %r9.dp = load ptr, ptr %r9.lp, align 8, !tbaa !2, !dbg !208
  %r9.ep = getelementptr i64, ptr %r9.dp, i64 %r8, !dbg !208
  %r9 = load i64, ptr %r9.ep, align 8, !tbaa !4, !dbg !208
  %r10 = call i64 @nova_rt_add(i64 %r6, i64 %r9), !dbg !208
  store i64 %r10, ptr %slot.s, align 8, !dbg !208
  %r11 = load i64, ptr %slot.i, align 8, !dbg !209
  %r12 = add i64 1, 0, !dbg !209
  %r13 = add i64 %r11, %r12, !dbg !209
  store i64 %r13, ptr %slot.i, align 8, !dbg !209
  br label %while_hdr0, !dbg !209
while_exit2:
  %r14 = load i64, ptr %slot.s, align 8, !dbg !210
  ret i64 %r14, !dbg !210
}

define i64 @nova_user_main() nounwind !dbg !211 {
entry:
  %slot.fl = alloca i64, align 8, !dbg !212
  store i64 0, ptr %slot.fl, align 8, !dbg !212
  %slot.s = alloca i64, align 8, !dbg !212
  store i64 0, ptr %slot.s, align 8, !dbg !212
  %slot.fl2 = alloca i64, align 8, !dbg !212
  store i64 0, ptr %slot.fl2, align 8, !dbg !212
  %slot.fl3 = alloca i64, align 8, !dbg !212
  store i64 0, ptr %slot.fl3, align 8, !dbg !212
  %slot.a = alloca i64, align 8, !dbg !212
  store i64 0, ptr %slot.a, align 8, !dbg !212
  %slot.g = alloca i64, align 8, !dbg !212
  store i64 0, ptr %slot.g, align 8, !dbg !212
  %slot.h = alloca i64, align 8, !dbg !212
  store i64 0, ptr %slot.h, align 8, !dbg !212
  %slot.d = alloca i64, align 8, !dbg !212
  store i64 0, ptr %slot.d, align 8, !dbg !212
  %slot.back = alloca i64, align 8, !dbg !212
  store i64 0, ptr %slot.back, align 8, !dbg !212
  %r0 = call i64 @nova_rt_list_create(), !dbg !213
  store i64 %r0, ptr %slot.fl, align 8, !dbg !213
  %r1 = add i64 %r0, 0, !dbg !214
  %r2 = add i64 4609434218613702656, 0, !dbg !214
  %r3 = call i64 @nova_rt_list_append(i64 %r1, i64 %r2), !dbg !214
  %r4 = add i64 %r0, 0, !dbg !215
  %r5 = add i64 4612811918334230528, 0, !dbg !215
  %r6 = call i64 @nova_rt_list_append(i64 %r4, i64 %r5), !dbg !215
  %r7 = add i64 %r0, 0, !dbg !216
  %r8 = add i64 4616189618054758400, 0, !dbg !216
  %r9 = call i64 @nova_rt_list_append(i64 %r7, i64 %r8), !dbg !216
  %r10 = add i64 %r0, 0, !dbg !217
  %r11 = add i64 0, 0, !dbg !217
  %r12.lp = inttoptr i64 %r10 to ptr, !dbg !217
  %r12.dp = load ptr, ptr %r12.lp, align 8, !tbaa !2, !dbg !217
  %r12.ep = getelementptr i64, ptr %r12.dp, i64 %r11, !dbg !217
  %r12 = load i64, ptr %r12.ep, align 8, !tbaa !4, !dbg !217
  %r13 = add i64 4609434218613702656, 0, !dbg !217
  %r14 = call i64 @nova_rt_eq(i64 %r12, i64 %r13), !dbg !217
  %r15.p = getelementptr inbounds [14 x i8], ptr @.str.0, i64 0, i64 0, !dbg !217
  %r15 = ptrtoint ptr %r15.p to i64, !dbg !217
  %r16 = call i64 @nova_rt_assert(i64 %r14, i64 %r15), !dbg !217
  %r17 = add i64 %r0, 0, !dbg !218
  %r18 = add i64 2, 0, !dbg !218
  %r19.lp = inttoptr i64 %r17 to ptr, !dbg !218
  %r19.dp = load ptr, ptr %r19.lp, align 8, !tbaa !2, !dbg !218
  %r19.ep = getelementptr i64, ptr %r19.dp, i64 %r18, !dbg !218
  %r19 = load i64, ptr %r19.ep, align 8, !tbaa !4, !dbg !218
  %r20 = add i64 4616189618054758400, 0, !dbg !218
  %r21 = call i64 @nova_rt_eq(i64 %r19, i64 %r20), !dbg !218
  %r22.p = getelementptr inbounds [14 x i8], ptr @.str.1, i64 0, i64 0, !dbg !218
  %r22 = ptrtoint ptr %r22.p to i64, !dbg !218
  %r23 = call i64 @nova_rt_assert(i64 %r21, i64 %r22), !dbg !218
  %r24 = add i64 %r0, 0, !dbg !219
  %r25.lp = inttoptr i64 %r24 to ptr, !dbg !219
  %r25.szp = getelementptr i64, ptr %r25.lp, i64 1, !dbg !219
  %r25 = load i64, ptr %r25.szp, align 8, !tbaa !6, !dbg !219
  %r26 = add i64 3, 0, !dbg !219
  %r27.cmp = icmp eq i64 %r25, %r26, !dbg !219
  %r27 = zext i1 %r27.cmp to i64, !dbg !219
  %r28.p = getelementptr inbounds [4 x i8], ptr @.str.2, i64 0, i64 0, !dbg !219
  %r28 = ptrtoint ptr %r28.p to i64, !dbg !219
  %r29 = call i64 @nova_rt_assert(i64 %r27, i64 %r28), !dbg !219
  %r30 = add i64 %r0, 0, !dbg !220
  %r31 = call i64 @sumlist(i64 %r30), !dbg !220
  %r32 = add i64 4620693217682128896, 0, !dbg !220
  %r33.af = bitcast i64 %r31 to double, !dbg !220
  %r33.bf = bitcast i64 %r32 to double, !dbg !220
  %r33.cmp = fcmp oeq double %r33.af, %r33.bf, !dbg !220
  %r33 = zext i1 %r33.cmp to i64, !dbg !220
  %r34.p = getelementptr inbounds [17 x i8], ptr @.str.3, i64 0, i64 0, !dbg !220
  %r34 = ptrtoint ptr %r34.p to i64, !dbg !220
  %r35 = call i64 @nova_rt_assert(i64 %r33, i64 %r34), !dbg !220
  %r36 = add i64 %r0, 0, !dbg !221
  %r37 = call i64 @nova_rt_any_to_str(i64 %r36), !dbg !221
  store i64 %r37, ptr %slot.s, align 8, !dbg !221
  %r38 = add i64 %r37, 0, !dbg !222
  %r39.p = getelementptr inbounds [4 x i8], ptr @.str.4, i64 0, i64 0, !dbg !222
  %r39 = ptrtoint ptr %r39.p to i64, !dbg !222
  %r40 = call i64 @nova_rt_contains(i64 %r38, i64 %r39), !dbg !222
  %r41.p = getelementptr inbounds [17 x i8], ptr @.str.5, i64 0, i64 0, !dbg !222
  %r41 = ptrtoint ptr %r41.p to i64, !dbg !222
  %r42 = call i64 @nova_rt_assert(i64 %r40, i64 %r41), !dbg !222
  %r43 = add i64 %r37, 0, !dbg !223
  %r44.p = getelementptr inbounds [2 x i8], ptr @.str.6, i64 0, i64 0, !dbg !223
  %r44 = ptrtoint ptr %r44.p to i64, !dbg !223
  %r45 = call i64 @nova_rt_contains(i64 %r43, i64 %r44), !dbg !223
  %r46.p = getelementptr inbounds [15 x i8], ptr @.str.7, i64 0, i64 0, !dbg !223
  %r46 = ptrtoint ptr %r46.p to i64, !dbg !223
  %r47 = call i64 @nova_rt_assert(i64 %r45, i64 %r46), !dbg !223
  %r48 = call i64 @nova_rt_list_create(), !dbg !224
  store i64 %r48, ptr %slot.fl2, align 8, !dbg !224
  %r49 = add i64 %r48, 0, !dbg !225
  %r50 = add i64 4609434218613702656, 0, !dbg !225
  %r51 = call i64 @nova_rt_list_append(i64 %r49, i64 %r50), !dbg !225
  %r52 = add i64 %r48, 0, !dbg !226
  %r53 = add i64 4612811918334230528, 0, !dbg !226
  %r54 = call i64 @nova_rt_list_append(i64 %r52, i64 %r53), !dbg !226
  %r55 = add i64 %r48, 0, !dbg !227
  %r56 = add i64 4616189618054758400, 0, !dbg !227
  %r57 = call i64 @nova_rt_list_append(i64 %r55, i64 %r56), !dbg !227
  %r58 = add i64 %r0, 0, !dbg !228
  %r59 = add i64 %r48, 0, !dbg !228
  %r60 = call i64 @nova_rt_eq(i64 %r58, i64 %r59), !dbg !228
  %r61.p = getelementptr inbounds [28 x i8], ptr @.str.8, i64 0, i64 0, !dbg !228
  %r61 = ptrtoint ptr %r61.p to i64, !dbg !228
  %r62 = call i64 @nova_rt_assert(i64 %r60, i64 %r61), !dbg !228
  %r63 = call i64 @nova_rt_list_create(), !dbg !229
  store i64 %r63, ptr %slot.fl3, align 8, !dbg !229
  %r64 = add i64 %r63, 0, !dbg !230
  %r65 = add i64 4609434218613702656, 0, !dbg !230
  %r66 = call i64 @nova_rt_list_append(i64 %r64, i64 %r65), !dbg !230
  %r67 = add i64 %r63, 0, !dbg !231
  %r68 = add i64 4621762822593629389, 0, !dbg !231
  %r69 = call i64 @nova_rt_list_append(i64 %r67, i64 %r68), !dbg !231
  %r70 = add i64 %r0, 0, !dbg !232
  %r71 = add i64 %r63, 0, !dbg !232
  %r72 = call i64 @nova_rt_eq(i64 %r70, i64 %r71), !dbg !232
  %r73.cmp = icmp eq i64 %r72, 0, !dbg !232
  %r73 = zext i1 %r73.cmp to i64, !dbg !232
  %r74.p = getelementptr inbounds [9 x i8], ptr @.str.9, i64 0, i64 0, !dbg !232
  %r74 = ptrtoint ptr %r74.p to i64, !dbg !232
  %r75 = call i64 @nova_rt_assert(i64 %r73, i64 %r74), !dbg !232
  %r76 = add i64 %r0, 0, !dbg !233
  %r77 = call i64 @take_any(i64 %r76), !dbg !233
  store i64 %r77, ptr %slot.a, align 8, !dbg !233
  %r78 = add i64 %r77, 0, !dbg !234
  %r79 = add i64 1, 0, !dbg !234
  %r80 = call i64 @nova_rt_index_get(i64 %r78, i64 %r79), !dbg !234
  %r81 = add i64 4612811918334230528, 0, !dbg !234
  %r82 = call i64 @nova_rt_eq(i64 %r80, i64 %r81), !dbg !234
  %r83.p = getelementptr inbounds [25 x i8], ptr @.str.10, i64 0, i64 0, !dbg !234
  %r83 = ptrtoint ptr %r83.p to i64, !dbg !234
  %r84 = call i64 @nova_rt_assert(i64 %r82, i64 %r83), !dbg !234
  %r85 = add i64 %r0, 0, !dbg !235
  store i64 %r85, ptr %slot.g, align 8, !dbg !235
  %r86 = add i64 %r85, 0, !dbg !236
  %r87 = add i64 0, 0, !dbg !236
  %r88.lp = inttoptr i64 %r86 to ptr, !dbg !236
  %r88.dp = load ptr, ptr %r88.lp, align 8, !tbaa !2, !dbg !236
  %r88.ep = getelementptr i64, ptr %r88.dp, i64 %r87, !dbg !236
  %r88 = load i64, ptr %r88.ep, align 8, !tbaa !4, !dbg !236
  %r89 = add i64 4609434218613702656, 0, !dbg !236
  %r90 = call i64 @nova_rt_eq(i64 %r88, i64 %r89), !dbg !236
  %r91.p = getelementptr inbounds [13 x i8], ptr @.str.11, i64 0, i64 0, !dbg !236
  %r91 = ptrtoint ptr %r91.p to i64, !dbg !236
  %r92 = call i64 @nova_rt_assert(i64 %r90, i64 %r91), !dbg !236
  %r93 = add i64 %r85, 0, !dbg !237
  %r94 = add i64 4617878467915022336, 0, !dbg !237
  %r95 = call i64 @nova_rt_list_append(i64 %r93, i64 %r94), !dbg !237
  %r96 = add i64 %r0, 0, !dbg !238
  %r97 = add i64 3, 0, !dbg !238
  %r98.lp = inttoptr i64 %r96 to ptr, !dbg !238
  %r98.dp = load ptr, ptr %r98.lp, align 8, !tbaa !2, !dbg !238
  %r98.ep = getelementptr i64, ptr %r98.dp, i64 %r97, !dbg !238
  %r98 = load i64, ptr %r98.ep, align 8, !tbaa !4, !dbg !238
  %r99 = add i64 4617878467915022336, 0, !dbg !238
  %r100 = call i64 @nova_rt_eq(i64 %r98, i64 %r99), !dbg !238
  %r101.p = getelementptr inbounds [32 x i8], ptr @.str.12, i64 0, i64 0, !dbg !238
  %r101 = ptrtoint ptr %r101.p to i64, !dbg !238
  %r102 = call i64 @nova_rt_assert(i64 %r100, i64 %r101), !dbg !238
  %r103 = add i64 %r0, 0, !dbg !239
  %r104.ptr = call ptr @nova_rt_struct_alloc(i64 16), !dbg !239
  %r104.thash = getelementptr i64, ptr %r104.ptr, i64 0, !dbg !239
  store i64 6952342520259, ptr %r104.thash, align 8, !dbg !239
  %r104.f0 = getelementptr i64, ptr %r104.ptr, i64 1, !dbg !239
  store i64 %r103, ptr %r104.f0, align 8, !dbg !239
  %r104 = ptrtoint ptr %r104.ptr to i64, !dbg !239
  store i64 %r104, ptr %slot.h, align 8, !dbg !239
  %r105 = add i64 %r104, 0, !dbg !240
  %r106.ptr = inttoptr i64 %r105 to ptr, !dbg !240
  %r106.gep = getelementptr i64, ptr %r106.ptr, i64 1, !dbg !240
  %r106 = load i64, ptr %r106.gep, align 8, !dbg !240
  %r107 = add i64 2, 0, !dbg !240
  %r108 = call i64 @nova_rt_index_get(i64 %r106, i64 %r107), !dbg !240
  %r109 = add i64 4616189618054758400, 0, !dbg !240
  %r110 = call i64 @nova_rt_eq(i64 %r108, i64 %r109), !dbg !240
  %r111.p = getelementptr inbounds [23 x i8], ptr @.str.13, i64 0, i64 0, !dbg !240
  %r111 = ptrtoint ptr %r111.p to i64, !dbg !240
  %r112 = call i64 @nova_rt_assert(i64 %r110, i64 %r111), !dbg !240
  %r113 = call i64 @nova_rt_dict_create(), !dbg !241
  store i64 %r113, ptr %slot.d, align 8, !dbg !241
  %r114 = add i64 %r0, 0, !dbg !242
  %r115 = add i64 %r113, 0, !dbg !242
  %r116.p = getelementptr inbounds [3 x i8], ptr @.str.14, i64 0, i64 0, !dbg !242
  %r116 = ptrtoint ptr %r116.p to i64, !dbg !242
  %_is.dv0 = call i64 @nova_rt_dict_set(i64 %r115, i64 %r116, i64 %r114), !dbg !242
  %r117 = add i64 %r113, 0, !dbg !243
  %r118.p = getelementptr inbounds [3 x i8], ptr @.str.14, i64 0, i64 0, !dbg !243
  %r118 = ptrtoint ptr %r118.p to i64, !dbg !243
  %r119 = call i64 @nova_rt_dict_get(i64 %r117, i64 %r118), !dbg !243
  store i64 %r119, ptr %slot.back, align 8, !dbg !243
  %r120 = add i64 %r119, 0, !dbg !244
  %r121 = add i64 0, 0, !dbg !244
  %r122 = call i64 @nova_rt_index_get(i64 %r120, i64 %r121), !dbg !244
  %r123 = add i64 4609434218613702656, 0, !dbg !244
  %r124 = call i64 @nova_rt_eq(i64 %r122, i64 %r123), !dbg !244
  %r125.p = getelementptr inbounds [22 x i8], ptr @.str.15, i64 0, i64 0, !dbg !244
  %r125 = ptrtoint ptr %r125.p to i64, !dbg !244
  %r126 = call i64 @nova_rt_assert(i64 %r124, i64 %r125), !dbg !244
  %r127 = add i64 4620130267728707584, 0, !dbg !245
  %r128 = add i64 %r0, 0, !dbg !245
  %r129 = add i64 0, 0, !dbg !245
  %_is.lp1 = inttoptr i64 %r128 to ptr, !dbg !245
  %_is.dp2 = load ptr, ptr %_is.lp1, align 8, !tbaa !2, !dbg !245
  %_is.ep3 = getelementptr i64, ptr %_is.dp2, i64 %r129, !dbg !245
  store i64 %r127, ptr %_is.ep3, align 8, !tbaa !4, !dbg !245
  %r130 = add i64 %r0, 0, !dbg !246
  %r131 = add i64 0, 0, !dbg !246
  %r132.lp = inttoptr i64 %r130 to ptr, !dbg !246
  %r132.dp = load ptr, ptr %r132.lp, align 8, !tbaa !2, !dbg !246
  %r132.ep = getelementptr i64, ptr %r132.dp, i64 %r131, !dbg !246
  %r132 = load i64, ptr %r132.ep, align 8, !tbaa !4, !dbg !246
  %r133 = add i64 4620130267728707584, 0, !dbg !246
  %r134 = call i64 @nova_rt_eq(i64 %r132, i64 %r133), !dbg !246
  %r135.p = getelementptr inbounds [20 x i8], ptr @.str.16, i64 0, i64 0, !dbg !246
  %r135 = ptrtoint ptr %r135.p to i64, !dbg !246
  %r136 = call i64 @nova_rt_assert(i64 %r134, i64 %r135), !dbg !246
  %r137 = add i64 %r0, 0, !dbg !247
  %r138 = add i64 1, 0, !dbg !247
  %r139.lp = inttoptr i64 %r137 to ptr, !dbg !247
  %r139.dp = load ptr, ptr %r139.lp, align 8, !tbaa !2, !dbg !247
  %r139.ep = getelementptr i64, ptr %r139.dp, i64 %r138, !dbg !247
  %r139 = load i64, ptr %r139.ep, align 8, !tbaa !4, !dbg !247
  %r140 = add i64 4612811918334230528, 0, !dbg !247
  %r141 = call i64 @nova_rt_eq(i64 %r139, i64 %r140), !dbg !247
  %r142.p = getelementptr inbounds [32 x i8], ptr @.str.17, i64 0, i64 0, !dbg !247
  %r142 = ptrtoint ptr %r142.p to i64, !dbg !247
  %r143 = call i64 @nova_rt_assert(i64 %r141, i64 %r142), !dbg !247
  %r144.p = getelementptr inbounds [36 x i8], ptr @.str.18, i64 0, i64 0, !dbg !248
  %r144 = ptrtoint ptr %r144.p to i64, !dbg !248
  %r145 = call i64 @nova_rt_print_str(i64 %r144), !dbg !248
  ret i64 %r145, !dbg !248
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
@.str.0 = private unnamed_addr constant [14 x i8] c"direct read 0\00"
@.str.1 = private unnamed_addr constant [14 x i8] c"direct read 2\00"
@.str.2 = private unnamed_addr constant [4 x i8] c"len\00"
@.str.3 = private unnamed_addr constant [17 x i8] c"sum via fn param\00"
@.str.4 = private unnamed_addr constant [4 x i8] c"1.5\00"
@.str.5 = private unnamed_addr constant [17 x i8] c"str contains 1.5\00"
@.str.6 = private unnamed_addr constant [2 x i8] c"4\00"
@.str.7 = private unnamed_addr constant [15 x i8] c"str contains 4\00"
@.str.8 = private unnamed_addr constant [28 x i8] c"deep eq of two float arrays\00"
@.str.9 = private unnamed_addr constant [9 x i8] c"deep neq\00"
@.str.10 = private unnamed_addr constant [25 x i8] c"read via any-typed alias\00"
@.str.11 = private unnamed_addr constant [13 x i8] c"alias read 0\00"
@.str.12 = private unnamed_addr constant [32 x i8] c"alias mutation visible (shared)\00"
@.str.13 = private unnamed_addr constant [23 x i8] c"struct field list read\00"
@.str.14 = private unnamed_addr constant [3 x i8] c"xs\00"
@.str.15 = private unnamed_addr constant [22 x i8] c"dict-stored list read\00"
@.str.16 = private unnamed_addr constant [20 x i8] c"index_set then read\00"
@.str.17 = private unnamed_addr constant [32 x i8] c"neighbor intact after index_set\00"
@.str.18 = private unnamed_addr constant [36 x i8] c"float_array_escape_test: all passed\00"

; Debug metadata
!llvm.dbg.cu = !{!100}
!llvm.module.flags = !{!102, !103}

!100 = distinct !DICompileUnit(language: DW_LANG_C99, file: !101, producer: "NOVA Compiler", isOptimized: false, emissionKind: LineTablesOnly)
!101 = !DIFile(filename: "__lsp_check__.nova", directory: ".")
!102 = !{i32 2, !"CodeView", i32 1}
!103 = !{i32 2, !"Debug Info Version", i32 3}
!104 = !DISubroutineType(types: !105)
!105 = !{null}
!200 = distinct !DISubprogram(name: "take_any", scope: !101, file: !101, line: 10, type: !104, scopeLine: 10, spFlags: DISPFlagDefinition, unit: !100)
!201 = !DILocation(line: 10, column: 0, scope: !200)
!203 = distinct !DISubprogram(name: "sumlist", scope: !101, file: !101, line: 13, type: !104, scopeLine: 13, spFlags: DISPFlagDefinition, unit: !100)
!204 = !DILocation(line: 13, column: 0, scope: !203)
!211 = distinct !DISubprogram(name: "nova_user_main", scope: !101, file: !101, line: 21, type: !104, scopeLine: 21, spFlags: DISPFlagDefinition, unit: !100)
!212 = !DILocation(line: 21, column: 0, scope: !211)
!202 = !DILocation(line: 11, column: 0, scope: !200)
!205 = !DILocation(line: 14, column: 0, scope: !203)
!206 = !DILocation(line: 15, column: 0, scope: !203)
!207 = !DILocation(line: 16, column: 0, scope: !203)
!208 = !DILocation(line: 17, column: 0, scope: !203)
!209 = !DILocation(line: 18, column: 0, scope: !203)
!210 = !DILocation(line: 19, column: 0, scope: !203)
!213 = !DILocation(line: 22, column: 0, scope: !211)
!214 = !DILocation(line: 23, column: 0, scope: !211)
!215 = !DILocation(line: 24, column: 0, scope: !211)
!216 = !DILocation(line: 25, column: 0, scope: !211)
!217 = !DILocation(line: 28, column: 0, scope: !211)
!218 = !DILocation(line: 29, column: 0, scope: !211)
!219 = !DILocation(line: 30, column: 0, scope: !211)
!220 = !DILocation(line: 31, column: 0, scope: !211)
!221 = !DILocation(line: 34, column: 0, scope: !211)
!222 = !DILocation(line: 35, column: 0, scope: !211)
!223 = !DILocation(line: 36, column: 0, scope: !211)
!224 = !DILocation(line: 39, column: 0, scope: !211)
!225 = !DILocation(line: 40, column: 0, scope: !211)
!226 = !DILocation(line: 41, column: 0, scope: !211)
!227 = !DILocation(line: 42, column: 0, scope: !211)
!228 = !DILocation(line: 43, column: 0, scope: !211)
!229 = !DILocation(line: 44, column: 0, scope: !211)
!230 = !DILocation(line: 45, column: 0, scope: !211)
!231 = !DILocation(line: 46, column: 0, scope: !211)
!232 = !DILocation(line: 47, column: 0, scope: !211)
!233 = !DILocation(line: 50, column: 0, scope: !211)
!234 = !DILocation(line: 51, column: 0, scope: !211)
!235 = !DILocation(line: 54, column: 0, scope: !211)
!236 = !DILocation(line: 55, column: 0, scope: !211)
!237 = !DILocation(line: 56, column: 0, scope: !211)
!238 = !DILocation(line: 57, column: 0, scope: !211)
!239 = !DILocation(line: 60, column: 0, scope: !211)
!240 = !DILocation(line: 61, column: 0, scope: !211)
!241 = !DILocation(line: 64, column: 0, scope: !211)
!242 = !DILocation(line: 65, column: 0, scope: !211)
!243 = !DILocation(line: 66, column: 0, scope: !211)
!244 = !DILocation(line: 67, column: 0, scope: !211)
!245 = !DILocation(line: 70, column: 0, scope: !211)
!246 = !DILocation(line: 71, column: 0, scope: !211)
!247 = !DILocation(line: 72, column: 0, scope: !211)
!248 = !DILocation(line: 74, column: 0, scope: !211)

; TBAA metadata
!0 = !{!"NOVA TBAA"}
!1 = !{!"list_data_ptr", !0}
!2 = !{!1, !1, i64 0}
!3 = !{!"list_elem", !0}
!4 = !{!3, !3, i64 0}
!5 = !{!"list_size", !0}
!6 = !{!5, !5, i64 0}
!90 = !{!"branch_weights", i32 2000, i32 1}
