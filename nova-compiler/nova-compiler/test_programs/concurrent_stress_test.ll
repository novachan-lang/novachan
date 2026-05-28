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

define i64 @compute_squares(i64 %p0, i64 %p1, i64 %p2) nounwind !dbg !200 {
entry:
  %slot.ch = alloca i64, align 8, !dbg !201
  store i64 %p0, ptr %slot.ch, align 8, !dbg !201
  %slot.start = alloca i64, align 8, !dbg !201
  store i64 %p1, ptr %slot.start, align 8, !dbg !201
  %slot.count = alloca i64, align 8, !dbg !201
  store i64 %p2, ptr %slot.count, align 8, !dbg !201
  %slot.total = alloca i64, align 8, !dbg !201
  store i64 0, ptr %slot.total, align 8, !dbg !201
  %slot.i = alloca i64, align 8, !dbg !201
  store i64 0, ptr %slot.i, align 8, !dbg !201
  %r0 = add i64 0, 0, !dbg !202
  store i64 %r0, ptr %slot.total, align 8, !dbg !202
  %r1 = load i64, ptr %slot.start, align 8, !dbg !203
  store i64 %r1, ptr %slot.i, align 8, !dbg !203
  br label %while_hdr0, !dbg !204
while_hdr0:
  %r2 = load i64, ptr %slot.i, align 8, !dbg !204
  %r3 = load i64, ptr %slot.start, align 8, !dbg !204
  %r4 = load i64, ptr %slot.count, align 8, !dbg !204
  %r5 = add i64 %r3, %r4, !dbg !204
  %r6.cmp = icmp slt i64 %r2, %r5, !dbg !204
  %r6 = zext i1 %r6.cmp to i64, !dbg !204
  %br_while_body1 = icmp ne i64 %r6, 0, !dbg !204
  br i1 %br_while_body1, label %while_body1, label %while_exit2, !prof !90, !dbg !204
while_body1:
  %r7 = load i64, ptr %slot.total, align 8, !dbg !205
  %r8 = load i64, ptr %slot.i, align 8, !dbg !205
  %r9 = load i64, ptr %slot.i, align 8, !dbg !205
  %r10 = mul i64 %r8, %r9, !dbg !205
  %r11 = add i64 %r7, %r10, !dbg !205
  store i64 %r11, ptr %slot.total, align 8, !dbg !205
  %r12 = load i64, ptr %slot.i, align 8, !dbg !206
  %r13 = add i64 1, 0, !dbg !206
  %r14 = add i64 %r12, %r13, !dbg !206
  store i64 %r14, ptr %slot.i, align 8, !dbg !206
  br label %while_hdr0, !dbg !206
while_exit2:
  %r15 = load i64, ptr %slot.ch, align 8, !dbg !207
  %r16 = load i64, ptr %slot.total, align 8, !dbg !207
  %r17 = call i64 @nova_rt_channel_send(i64 %r15, i64 %r16), !dbg !207
  ret i64 %r17, !dbg !207
}

define i64 @is_prime(i64 %p0) nounwind !dbg !208 {
entry:
  %slot.n = alloca i64, align 8, !dbg !209
  store i64 %p0, ptr %slot.n, align 8, !dbg !209
  %slot.d = alloca i64, align 8, !dbg !209
  store i64 0, ptr %slot.d, align 8, !dbg !209
  %r0 = load i64, ptr %slot.n, align 8, !dbg !210
  %r1 = add i64 2, 0, !dbg !210
  %r2.cmp = icmp slt i64 %r0, %r1, !dbg !210
  %r2 = zext i1 %r2.cmp to i64, !dbg !210
  %br_then3 = icmp ne i64 %r2, 0, !dbg !210
  br i1 %br_then3, label %then3, label %else4, !dbg !210
then3:
  %r3 = add i64 0, 0, !dbg !211
  ret i64 %r3, !dbg !211
else4:
  br label %endif5, !dbg !211
endif5:
  %r4 = load i64, ptr %slot.n, align 8, !dbg !212
  %r5 = add i64 2, 0, !dbg !212
  %r6 = call i64 @nova_rt_eq(i64 %r4, i64 %r5), !dbg !212
  %br_then6 = icmp ne i64 %r6, 0, !dbg !212
  br i1 %br_then6, label %then6, label %else7, !dbg !212
then6:
  %r7 = add i64 1, 0, !dbg !213
  ret i64 %r7, !dbg !213
else7:
  br label %endif8, !dbg !213
endif8:
  %r8 = load i64, ptr %slot.n, align 8, !dbg !214
  %r9 = add i64 2, 0, !dbg !214
  %r10 = srem i64 %r8, %r9, !dbg !214
  %r11 = add i64 0, 0, !dbg !214
  %r12 = call i64 @nova_rt_eq(i64 %r10, i64 %r11), !dbg !214
  %br_then9 = icmp ne i64 %r12, 0, !dbg !214
  br i1 %br_then9, label %then9, label %else10, !dbg !214
then9:
  %r13 = add i64 0, 0, !dbg !215
  ret i64 %r13, !dbg !215
else10:
  br label %endif11, !dbg !215
endif11:
  %r14 = add i64 3, 0, !dbg !216
  store i64 %r14, ptr %slot.d, align 8, !dbg !216
  br label %while_hdr12, !dbg !217
while_hdr12:
  %r15 = load i64, ptr %slot.d, align 8, !dbg !217
  %r16 = load i64, ptr %slot.d, align 8, !dbg !217
  %r17 = mul i64 %r15, %r16, !dbg !217
  %r18 = load i64, ptr %slot.n, align 8, !dbg !217
  %r19.cmp = icmp sle i64 %r17, %r18, !dbg !217
  %r19 = zext i1 %r19.cmp to i64, !dbg !217
  %br_while_body13 = icmp ne i64 %r19, 0, !dbg !217
  br i1 %br_while_body13, label %while_body13, label %while_exit14, !prof !90, !dbg !217
while_body13:
  %r20 = load i64, ptr %slot.n, align 8, !dbg !218
  %r21 = load i64, ptr %slot.d, align 8, !dbg !218
  %r22 = srem i64 %r20, %r21, !dbg !218
  %r23 = add i64 0, 0, !dbg !218
  %r24 = call i64 @nova_rt_eq(i64 %r22, i64 %r23), !dbg !218
  %br_then15 = icmp ne i64 %r24, 0, !dbg !218
  br i1 %br_then15, label %then15, label %else16, !dbg !218
then15:
  %r25 = add i64 0, 0, !dbg !219
  ret i64 %r25, !dbg !219
else16:
  br label %endif17, !dbg !219
endif17:
  %r26 = load i64, ptr %slot.d, align 8, !dbg !220
  %r27 = add i64 2, 0, !dbg !220
  %r28 = add i64 %r26, %r27, !dbg !220
  store i64 %r28, ptr %slot.d, align 8, !dbg !220
  br label %while_hdr12, !dbg !220
while_exit14:
  %r29 = add i64 1, 0, !dbg !221
  ret i64 %r29, !dbg !221
}

define i64 @count_primes_range(i64 %p0, i64 %p1, i64 %p2) nounwind !dbg !222 {
entry:
  %slot.ch = alloca i64, align 8, !dbg !223
  store i64 %p0, ptr %slot.ch, align 8, !dbg !223
  %slot.lo = alloca i64, align 8, !dbg !223
  store i64 %p1, ptr %slot.lo, align 8, !dbg !223
  %slot.hi = alloca i64, align 8, !dbg !223
  store i64 %p2, ptr %slot.hi, align 8, !dbg !223
  %slot.count = alloca i64, align 8, !dbg !223
  store i64 0, ptr %slot.count, align 8, !dbg !223
  %slot.i = alloca i64, align 8, !dbg !223
  store i64 0, ptr %slot.i, align 8, !dbg !223
  %r0 = add i64 0, 0, !dbg !224
  store i64 %r0, ptr %slot.count, align 8, !dbg !224
  %r1 = load i64, ptr %slot.lo, align 8, !dbg !225
  store i64 %r1, ptr %slot.i, align 8, !dbg !225
  br label %while_hdr18, !dbg !226
while_hdr18:
  %r2 = load i64, ptr %slot.i, align 8, !dbg !226
  %r3 = load i64, ptr %slot.hi, align 8, !dbg !226
  %r4.cmp = icmp sle i64 %r2, %r3, !dbg !226
  %r4 = zext i1 %r4.cmp to i64, !dbg !226
  %br_while_body19 = icmp ne i64 %r4, 0, !dbg !226
  br i1 %br_while_body19, label %while_body19, label %while_exit20, !prof !90, !dbg !226
while_body19:
  %r5 = load i64, ptr %slot.count, align 8, !dbg !227
  %r6 = load i64, ptr %slot.i, align 8, !dbg !227
  %r7 = call i64 @is_prime(i64 %r6), !dbg !227
  %r8 = add i64 %r5, %r7, !dbg !227
  store i64 %r8, ptr %slot.count, align 8, !dbg !227
  %r9 = load i64, ptr %slot.i, align 8, !dbg !228
  %r10 = add i64 1, 0, !dbg !228
  %r11 = add i64 %r9, %r10, !dbg !228
  store i64 %r11, ptr %slot.i, align 8, !dbg !228
  br label %while_hdr18, !dbg !228
while_exit20:
  %r12 = load i64, ptr %slot.ch, align 8, !dbg !229
  %r13 = load i64, ptr %slot.count, align 8, !dbg !229
  %r14 = call i64 @nova_rt_channel_send(i64 %r12, i64 %r13), !dbg !229
  ret i64 %r14, !dbg !229
}

define i64 @generate(i64 %p0, i64 %p1) nounwind !dbg !230 {
entry:
  %slot.out = alloca i64, align 8, !dbg !231
  store i64 %p0, ptr %slot.out, align 8, !dbg !231
  %slot.n = alloca i64, align 8, !dbg !231
  store i64 %p1, ptr %slot.n, align 8, !dbg !231
  %slot.i = alloca i64, align 8, !dbg !231
  store i64 0, ptr %slot.i, align 8, !dbg !231
  %r0 = add i64 2, 0, !dbg !232
  store i64 %r0, ptr %slot.i, align 8, !dbg !232
  br label %while_hdr21, !dbg !233
while_hdr21:
  %r1 = load i64, ptr %slot.i, align 8, !dbg !233
  %r2 = load i64, ptr %slot.n, align 8, !dbg !233
  %r3.cmp = icmp sle i64 %r1, %r2, !dbg !233
  %r3 = zext i1 %r3.cmp to i64, !dbg !233
  %br_while_body22 = icmp ne i64 %r3, 0, !dbg !233
  br i1 %br_while_body22, label %while_body22, label %while_exit23, !prof !90, !dbg !233
while_body22:
  %r4 = load i64, ptr %slot.out, align 8, !dbg !234
  %r5 = load i64, ptr %slot.i, align 8, !dbg !234
  %r6 = call i64 @nova_rt_channel_send(i64 %r4, i64 %r5), !dbg !234
  %r7 = load i64, ptr %slot.i, align 8, !dbg !235
  %r8 = add i64 1, 0, !dbg !235
  %r9 = add i64 %r7, %r8, !dbg !235
  store i64 %r9, ptr %slot.i, align 8, !dbg !235
  br label %while_hdr21, !dbg !235
while_exit23:
  %r10 = load i64, ptr %slot.out, align 8, !dbg !236
  %r11 = add i64 1, 0, !dbg !236
  %r12 = sub i64 0, %r11, !dbg !236
  %r13 = call i64 @nova_rt_channel_send(i64 %r10, i64 %r12), !dbg !236
  ret i64 %r13, !dbg !236
}

define i64 @filter_stage(i64 %p0, i64 %p1, i64 %p2) nounwind !dbg !237 {
entry:
  %slot.in_ch = alloca i64, align 8, !dbg !238
  store i64 %p0, ptr %slot.in_ch, align 8, !dbg !238
  %slot.out = alloca i64, align 8, !dbg !238
  store i64 %p1, ptr %slot.out, align 8, !dbg !238
  %slot.prime = alloca i64, align 8, !dbg !238
  store i64 %p2, ptr %slot.prime, align 8, !dbg !238
  %slot.val = alloca i64, align 8, !dbg !238
  store i64 0, ptr %slot.val, align 8, !dbg !238
  br label %while_hdr24, !dbg !239
while_hdr24:
  br label %while_body25, !dbg !239
while_body25:
  %r1 = load i64, ptr %slot.in_ch, align 8, !dbg !240
  %r2 = call i64 @nova_rt_channel_recv(i64 %r1), !dbg !240
  store i64 %r2, ptr %slot.val, align 8, !dbg !240
  %r3 = add i64 %r2, 0, !dbg !241
  %r4 = add i64 1, 0, !dbg !241
  %r5 = sub i64 0, %r4, !dbg !241
  %r6 = call i64 @nova_rt_eq(i64 %r3, i64 %r5), !dbg !241
  %br_then27 = icmp ne i64 %r6, 0, !dbg !241
  br i1 %br_then27, label %then27, label %else28, !dbg !241
then27:
  %r7 = load i64, ptr %slot.out, align 8, !dbg !242
  %r8 = add i64 1, 0, !dbg !242
  %r9 = sub i64 0, %r8, !dbg !242
  %r10 = call i64 @nova_rt_channel_send(i64 %r7, i64 %r9), !dbg !242
  %r11 = add i64 0, 0, !dbg !243
  ret i64 %r11, !dbg !243
else28:
  br label %endif29, !dbg !243
endif29:
  %r12 = load i64, ptr %slot.val, align 8, !dbg !244
  %r13 = load i64, ptr %slot.prime, align 8, !dbg !244
  %r14 = srem i64 %r12, %r13, !dbg !244
  %r15 = add i64 0, 0, !dbg !244
  %r16 = call i64 @nova_rt_neq(i64 %r14, i64 %r15), !dbg !244
  %br_then30 = icmp ne i64 %r16, 0, !dbg !244
  br i1 %br_then30, label %then30, label %else31, !dbg !244
then30:
  %r17 = load i64, ptr %slot.out, align 8, !dbg !245
  %r18 = load i64, ptr %slot.val, align 8, !dbg !245
  %r19 = call i64 @nova_rt_channel_send(i64 %r17, i64 %r18), !dbg !245
  br label %endif32, !dbg !245
else31:
  br label %endif32, !dbg !245
endif32:
  br label %while_hdr24, !dbg !245
}

define i64 @collect_primes(i64 %p0, i64 %p1, i64 %p2) nounwind !dbg !246 {
entry:
  %slot.in_ch = alloca i64, align 8, !dbg !247
  store i64 %p0, ptr %slot.in_ch, align 8, !dbg !247
  %slot.result_ch = alloca i64, align 8, !dbg !247
  store i64 %p1, ptr %slot.result_ch, align 8, !dbg !247
  %slot.limit = alloca i64, align 8, !dbg !247
  store i64 %p2, ptr %slot.limit, align 8, !dbg !247
  %slot.count = alloca i64, align 8, !dbg !247
  store i64 0, ptr %slot.count, align 8, !dbg !247
  %slot.val = alloca i64, align 8, !dbg !247
  store i64 0, ptr %slot.val, align 8, !dbg !247
  %r0 = add i64 0, 0, !dbg !248
  store i64 %r0, ptr %slot.count, align 8, !dbg !248
  br label %while_hdr33, !dbg !249
while_hdr33:
  br label %while_body34, !dbg !249
while_body34:
  %r2 = load i64, ptr %slot.in_ch, align 8, !dbg !250
  %r3 = call i64 @nova_rt_channel_recv(i64 %r2), !dbg !250
  store i64 %r3, ptr %slot.val, align 8, !dbg !250
  %r4 = add i64 %r3, 0, !dbg !251
  %r5 = add i64 1, 0, !dbg !251
  %r6 = sub i64 0, %r5, !dbg !251
  %r7 = call i64 @nova_rt_eq(i64 %r4, i64 %r6), !dbg !251
  %br_then36 = icmp ne i64 %r7, 0, !dbg !251
  br i1 %br_then36, label %then36, label %else37, !dbg !251
then36:
  %r8 = load i64, ptr %slot.result_ch, align 8, !dbg !252
  %r9 = load i64, ptr %slot.count, align 8, !dbg !252
  %r10 = call i64 @nova_rt_channel_send(i64 %r8, i64 %r9), !dbg !252
  %r11 = add i64 0, 0, !dbg !253
  ret i64 %r11, !dbg !253
else37:
  br label %endif38, !dbg !253
endif38:
  %r12 = load i64, ptr %slot.count, align 8, !dbg !254
  %r13 = add i64 1, 0, !dbg !254
  %r14 = add i64 %r12, %r13, !dbg !254
  store i64 %r14, ptr %slot.count, align 8, !dbg !254
  %r15 = add i64 %r14, 0, !dbg !255
  %r16 = load i64, ptr %slot.limit, align 8, !dbg !255
  %r17.cmp = icmp sge i64 %r15, %r16, !dbg !255
  %r17 = zext i1 %r17.cmp to i64, !dbg !255
  %br_then39 = icmp ne i64 %r17, 0, !dbg !255
  br i1 %br_then39, label %then39, label %else40, !dbg !255
then39:
  %r18 = load i64, ptr %slot.result_ch, align 8, !dbg !256
  %r19 = load i64, ptr %slot.count, align 8, !dbg !256
  %r20 = call i64 @nova_rt_channel_send(i64 %r18, i64 %r19), !dbg !256
  %r21 = add i64 0, 0, !dbg !257
  ret i64 %r21, !dbg !257
else40:
  br label %endif41, !dbg !257
endif41:
  br label %while_hdr33, !dbg !257
}

define i64 @producer(i64 %p0, i64 %p1) nounwind !dbg !258 {
entry:
  %slot.ch = alloca i64, align 8, !dbg !259
  store i64 %p0, ptr %slot.ch, align 8, !dbg !259
  %slot.n = alloca i64, align 8, !dbg !259
  store i64 %p1, ptr %slot.n, align 8, !dbg !259
  %slot.i = alloca i64, align 8, !dbg !259
  store i64 0, ptr %slot.i, align 8, !dbg !259
  %r0 = add i64 1, 0, !dbg !260
  store i64 %r0, ptr %slot.i, align 8, !dbg !260
  br label %while_hdr42, !dbg !261
while_hdr42:
  %r1 = load i64, ptr %slot.i, align 8, !dbg !261
  %r2 = load i64, ptr %slot.n, align 8, !dbg !261
  %r3.cmp = icmp sle i64 %r1, %r2, !dbg !261
  %r3 = zext i1 %r3.cmp to i64, !dbg !261
  %br_while_body43 = icmp ne i64 %r3, 0, !dbg !261
  br i1 %br_while_body43, label %while_body43, label %while_exit44, !prof !90, !dbg !261
while_body43:
  %r4 = load i64, ptr %slot.ch, align 8, !dbg !262
  %r5 = load i64, ptr %slot.i, align 8, !dbg !262
  %r6 = add i64 10, 0, !dbg !262
  %r7 = mul i64 %r5, %r6, !dbg !262
  %r8 = call i64 @nova_rt_channel_send(i64 %r4, i64 %r7), !dbg !262
  %r9 = load i64, ptr %slot.i, align 8, !dbg !263
  %r10 = add i64 1, 0, !dbg !263
  %r11 = add i64 %r9, %r10, !dbg !263
  store i64 %r11, ptr %slot.i, align 8, !dbg !263
  br label %while_hdr42, !dbg !263
while_exit44:
  %r12 = load i64, ptr %slot.ch, align 8, !dbg !264
  %r13 = call i64 @nova_rt_channel_close(i64 %r12), !dbg !264
  ret i64 %r13, !dbg !264
}

define i64 @make_worker(i64 %p0) nounwind !dbg !265 {
entry:
  %slot.multiplier = alloca i64, align 8, !dbg !266
  store i64 %p0, ptr %slot.multiplier, align 8, !dbg !266
  %r0 = load i64, ptr %slot.multiplier, align 8, !dbg !267
  %r1.ptr = call ptr @nova_rt_struct_alloc(i64 16), !dbg !267
  %r1.tgep = getelementptr i64, ptr %r1.ptr, i64 0, !dbg !267
  %r1.tfn = ptrtoint ptr @__tramp_0 to i64, !dbg !267
  store i64 %r1.tfn, ptr %r1.tgep, align 8, !dbg !267
  %r1.c0 = getelementptr i64, ptr %r1.ptr, i64 1, !dbg !267
  store i64 %r0, ptr %r1.c0, align 8, !dbg !267
  %r1 = ptrtoint ptr %r1.ptr to i64, !dbg !267
  ret i64 %r1, !dbg !267
}

define i64 @__lambda_0(i64 %p0, i64 %p1, i64 %p2) nounwind {
entry:
  %slot.multiplier = alloca i64, align 8
  store i64 %p0, ptr %slot.multiplier, align 8
  %slot.ch = alloca i64, align 8
  store i64 %p1, ptr %slot.ch, align 8
  %slot.value = alloca i64, align 8
  store i64 %p2, ptr %slot.value, align 8
  %r0 = load i64, ptr %slot.ch, align 8
  %r1 = load i64, ptr %slot.value, align 8
  %r2 = load i64, ptr %slot.multiplier, align 8
  %r3 = call i64 @nova_rt_mul(i64 %r1, i64 %r2)
  %r4 = call i64 @nova_rt_channel_send(i64 %r0, i64 %r3)
  ret i64 %r4
}

define i64 @nova_main() nounwind {
entry:
  %slot.results = alloca i64, align 8
  store i64 0, ptr %slot.results, align 8
  %slot.r1 = alloca i64, align 8
  store i64 0, ptr %slot.r1, align 8
  %slot.r2 = alloca i64, align 8
  store i64 0, ptr %slot.r2, align 8
  %slot.prime_ch = alloca i64, align 8
  store i64 0, ptr %slot.prime_ch, align 8
  %slot.p1 = alloca i64, align 8
  store i64 0, ptr %slot.p1, align 8
  %slot.p2 = alloca i64, align 8
  store i64 0, ptr %slot.p2, align 8
  %slot.p3 = alloca i64, align 8
  store i64 0, ptr %slot.p3, align 8
  %slot.p4 = alloca i64, align 8
  store i64 0, ptr %slot.p4, align 8
  %slot.gen_out = alloca i64, align 8
  store i64 0, ptr %slot.gen_out, align 8
  %slot.f2_out = alloca i64, align 8
  store i64 0, ptr %slot.f2_out, align 8
  %slot.f3_out = alloca i64, align 8
  store i64 0, ptr %slot.f3_out, align 8
  %slot.f5_out = alloca i64, align 8
  store i64 0, ptr %slot.f5_out, align 8
  %slot.f7_out = alloca i64, align 8
  store i64 0, ptr %slot.f7_out, align 8
  %slot.sieve_result = alloca i64, align 8
  store i64 0, ptr %slot.sieve_result, align 8
  %slot.sieve_count = alloca i64, align 8
  store i64 0, ptr %slot.sieve_count, align 8
  %slot.prod_ch = alloca i64, align 8
  store i64 0, ptr %slot.prod_ch, align 8
  %slot.sum = alloca i64, align 8
  store i64 0, ptr %slot.sum, align 8
  %slot.doubler = alloca i64, align 8
  store i64 0, ptr %slot.doubler, align 8
  %slot.tripler = alloca i64, align 8
  store i64 0, ptr %slot.tripler, align 8
  %slot.cap_ch = alloca i64, align 8
  store i64 0, ptr %slot.cap_ch, align 8
  %slot.c1 = alloca i64, align 8
  store i64 0, ptr %slot.c1, align 8
  %slot.c2 = alloca i64, align 8
  store i64 0, ptr %slot.c2, align 8
  %r0 = call i64 @nova_rt_channel_create()
  store i64 %r0, ptr %slot.results, align 8
  %r1 = load i64, ptr %slot.results, align 8
  %r2.ptr = call ptr @nova_rt_struct_alloc(i64 16)
  %r2.tgep = getelementptr i64, ptr %r2.ptr, i64 0
  %r2.tfn = ptrtoint ptr @__ntramp___spawn_call_1 to i64
  store i64 %r2.tfn, ptr %r2.tgep, align 8
  %r2.c0 = getelementptr i64, ptr %r2.ptr, i64 1
  store i64 %r1, ptr %r2.c0, align 8
  %r2 = ptrtoint ptr %r2.ptr to i64
  %r3.ptr = inttoptr i64 %r2 to ptr
  %r3.gep = getelementptr i64, ptr %r3.ptr, i64 0
  %r3 = load i64, ptr %r3.gep, align 8
  %r4 = call i64 @nova_rt_spawn(i64 %r3, i64 %r2)
  %r5 = load i64, ptr %slot.results, align 8
  %r6.ptr = call ptr @nova_rt_struct_alloc(i64 16)
  %r6.tgep = getelementptr i64, ptr %r6.ptr, i64 0
  %r6.tfn = ptrtoint ptr @__ntramp___spawn_call_2 to i64
  store i64 %r6.tfn, ptr %r6.tgep, align 8
  %r6.c0 = getelementptr i64, ptr %r6.ptr, i64 1
  store i64 %r5, ptr %r6.c0, align 8
  %r6 = ptrtoint ptr %r6.ptr to i64
  %r7.ptr = inttoptr i64 %r6 to ptr
  %r7.gep = getelementptr i64, ptr %r7.ptr, i64 0
  %r7 = load i64, ptr %r7.gep, align 8
  %r8 = call i64 @nova_rt_spawn(i64 %r7, i64 %r6)
  %r9 = load i64, ptr %slot.results, align 8
  %r10 = call i64 @nova_rt_channel_recv(i64 %r9)
  store i64 %r10, ptr %slot.r1, align 8
  %r11 = load i64, ptr %slot.results, align 8
  %r12 = call i64 @nova_rt_channel_recv(i64 %r11)
  store i64 %r12, ptr %slot.r2, align 8
  %r13.p = getelementptr inbounds [25 x i8], ptr @.str.0, i64 0, i64 0
  %r13 = ptrtoint ptr %r13.p to i64
  %r14 = load i64, ptr %slot.r1, align 8
  %r15 = load i64, ptr %slot.r2, align 8
  %r16 = call i64 @nova_rt_add(i64 %r14, i64 %r15)
  %r17 = call i64 @nova_rt_int_to_str(i64 %r16)
  %r18 = call i64 @nova_rt_str_concat(i64 %r13, i64 %r17)
  %r19 = call i64 @nova_rt_print_str(i64 %r18)
  %r20 = call i64 @nova_rt_channel_create()
  store i64 %r20, ptr %slot.prime_ch, align 8
  %r21 = load i64, ptr %slot.prime_ch, align 8
  %r22.ptr = call ptr @nova_rt_struct_alloc(i64 16)
  %r22.tgep = getelementptr i64, ptr %r22.ptr, i64 0
  %r22.tfn = ptrtoint ptr @__ntramp___spawn_call_3 to i64
  store i64 %r22.tfn, ptr %r22.tgep, align 8
  %r22.c0 = getelementptr i64, ptr %r22.ptr, i64 1
  store i64 %r21, ptr %r22.c0, align 8
  %r22 = ptrtoint ptr %r22.ptr to i64
  %r23.ptr = inttoptr i64 %r22 to ptr
  %r23.gep = getelementptr i64, ptr %r23.ptr, i64 0
  %r23 = load i64, ptr %r23.gep, align 8
  %r24 = call i64 @nova_rt_spawn(i64 %r23, i64 %r22)
  %r25 = load i64, ptr %slot.prime_ch, align 8
  %r26.ptr = call ptr @nova_rt_struct_alloc(i64 16)
  %r26.tgep = getelementptr i64, ptr %r26.ptr, i64 0
  %r26.tfn = ptrtoint ptr @__ntramp___spawn_call_4 to i64
  store i64 %r26.tfn, ptr %r26.tgep, align 8
  %r26.c0 = getelementptr i64, ptr %r26.ptr, i64 1
  store i64 %r25, ptr %r26.c0, align 8
  %r26 = ptrtoint ptr %r26.ptr to i64
  %r27.ptr = inttoptr i64 %r26 to ptr
  %r27.gep = getelementptr i64, ptr %r27.ptr, i64 0
  %r27 = load i64, ptr %r27.gep, align 8
  %r28 = call i64 @nova_rt_spawn(i64 %r27, i64 %r26)
  %r29 = load i64, ptr %slot.prime_ch, align 8
  %r30.ptr = call ptr @nova_rt_struct_alloc(i64 16)
  %r30.tgep = getelementptr i64, ptr %r30.ptr, i64 0
  %r30.tfn = ptrtoint ptr @__ntramp___spawn_call_5 to i64
  store i64 %r30.tfn, ptr %r30.tgep, align 8
  %r30.c0 = getelementptr i64, ptr %r30.ptr, i64 1
  store i64 %r29, ptr %r30.c0, align 8
  %r30 = ptrtoint ptr %r30.ptr to i64
  %r31.ptr = inttoptr i64 %r30 to ptr
  %r31.gep = getelementptr i64, ptr %r31.ptr, i64 0
  %r31 = load i64, ptr %r31.gep, align 8
  %r32 = call i64 @nova_rt_spawn(i64 %r31, i64 %r30)
  %r33 = load i64, ptr %slot.prime_ch, align 8
  %r34.ptr = call ptr @nova_rt_struct_alloc(i64 16)
  %r34.tgep = getelementptr i64, ptr %r34.ptr, i64 0
  %r34.tfn = ptrtoint ptr @__ntramp___spawn_call_6 to i64
  store i64 %r34.tfn, ptr %r34.tgep, align 8
  %r34.c0 = getelementptr i64, ptr %r34.ptr, i64 1
  store i64 %r33, ptr %r34.c0, align 8
  %r34 = ptrtoint ptr %r34.ptr to i64
  %r35.ptr = inttoptr i64 %r34 to ptr
  %r35.gep = getelementptr i64, ptr %r35.ptr, i64 0
  %r35 = load i64, ptr %r35.gep, align 8
  %r36 = call i64 @nova_rt_spawn(i64 %r35, i64 %r34)
  %r37 = load i64, ptr %slot.prime_ch, align 8
  %r38 = call i64 @nova_rt_channel_recv(i64 %r37)
  store i64 %r38, ptr %slot.p1, align 8
  %r39 = load i64, ptr %slot.prime_ch, align 8
  %r40 = call i64 @nova_rt_channel_recv(i64 %r39)
  store i64 %r40, ptr %slot.p2, align 8
  %r41 = load i64, ptr %slot.prime_ch, align 8
  %r42 = call i64 @nova_rt_channel_recv(i64 %r41)
  store i64 %r42, ptr %slot.p3, align 8
  %r43 = load i64, ptr %slot.prime_ch, align 8
  %r44 = call i64 @nova_rt_channel_recv(i64 %r43)
  store i64 %r44, ptr %slot.p4, align 8
  %r45.p = getelementptr inbounds [22 x i8], ptr @.str.1, i64 0, i64 0
  %r45 = ptrtoint ptr %r45.p to i64
  %r46 = load i64, ptr %slot.p1, align 8
  %r47 = load i64, ptr %slot.p2, align 8
  %r48 = call i64 @nova_rt_add(i64 %r46, i64 %r47)
  %r49 = load i64, ptr %slot.p3, align 8
  %r50 = call i64 @nova_rt_add(i64 %r48, i64 %r49)
  %r51 = load i64, ptr %slot.p4, align 8
  %r52 = call i64 @nova_rt_add(i64 %r50, i64 %r51)
  %r53 = call i64 @nova_rt_int_to_str(i64 %r52)
  %r54 = call i64 @nova_rt_str_concat(i64 %r45, i64 %r53)
  %r55 = call i64 @nova_rt_print_str(i64 %r54)
  %r56 = call i64 @nova_rt_channel_create()
  store i64 %r56, ptr %slot.gen_out, align 8
  %r57 = load i64, ptr %slot.gen_out, align 8
  %r58.ptr = call ptr @nova_rt_struct_alloc(i64 16)
  %r58.tgep = getelementptr i64, ptr %r58.ptr, i64 0
  %r58.tfn = ptrtoint ptr @__ntramp___spawn_call_7 to i64
  store i64 %r58.tfn, ptr %r58.tgep, align 8
  %r58.c0 = getelementptr i64, ptr %r58.ptr, i64 1
  store i64 %r57, ptr %r58.c0, align 8
  %r58 = ptrtoint ptr %r58.ptr to i64
  %r59.ptr = inttoptr i64 %r58 to ptr
  %r59.gep = getelementptr i64, ptr %r59.ptr, i64 0
  %r59 = load i64, ptr %r59.gep, align 8
  %r60 = call i64 @nova_rt_spawn(i64 %r59, i64 %r58)
  %r61 = call i64 @nova_rt_channel_create()
  store i64 %r61, ptr %slot.f2_out, align 8
  %r62 = load i64, ptr %slot.gen_out, align 8
  %r63 = load i64, ptr %slot.f2_out, align 8
  %r64.ptr = call ptr @nova_rt_struct_alloc(i64 24)
  %r64.tgep = getelementptr i64, ptr %r64.ptr, i64 0
  %r64.tfn = ptrtoint ptr @__ntramp___spawn_call_8 to i64
  store i64 %r64.tfn, ptr %r64.tgep, align 8
  %r64.c0 = getelementptr i64, ptr %r64.ptr, i64 1
  store i64 %r62, ptr %r64.c0, align 8
  %r64.c1 = getelementptr i64, ptr %r64.ptr, i64 2
  store i64 %r63, ptr %r64.c1, align 8
  %r64 = ptrtoint ptr %r64.ptr to i64
  %r65.ptr = inttoptr i64 %r64 to ptr
  %r65.gep = getelementptr i64, ptr %r65.ptr, i64 0
  %r65 = load i64, ptr %r65.gep, align 8
  %r66 = call i64 @nova_rt_spawn(i64 %r65, i64 %r64)
  %r67 = call i64 @nova_rt_channel_create()
  store i64 %r67, ptr %slot.f3_out, align 8
  %r68 = load i64, ptr %slot.f2_out, align 8
  %r69 = load i64, ptr %slot.f3_out, align 8
  %r70.ptr = call ptr @nova_rt_struct_alloc(i64 24)
  %r70.tgep = getelementptr i64, ptr %r70.ptr, i64 0
  %r70.tfn = ptrtoint ptr @__ntramp___spawn_call_9 to i64
  store i64 %r70.tfn, ptr %r70.tgep, align 8
  %r70.c0 = getelementptr i64, ptr %r70.ptr, i64 1
  store i64 %r68, ptr %r70.c0, align 8
  %r70.c1 = getelementptr i64, ptr %r70.ptr, i64 2
  store i64 %r69, ptr %r70.c1, align 8
  %r70 = ptrtoint ptr %r70.ptr to i64
  %r71.ptr = inttoptr i64 %r70 to ptr
  %r71.gep = getelementptr i64, ptr %r71.ptr, i64 0
  %r71 = load i64, ptr %r71.gep, align 8
  %r72 = call i64 @nova_rt_spawn(i64 %r71, i64 %r70)
  %r73 = call i64 @nova_rt_channel_create()
  store i64 %r73, ptr %slot.f5_out, align 8
  %r74 = load i64, ptr %slot.f3_out, align 8
  %r75 = load i64, ptr %slot.f5_out, align 8
  %r76.ptr = call ptr @nova_rt_struct_alloc(i64 24)
  %r76.tgep = getelementptr i64, ptr %r76.ptr, i64 0
  %r76.tfn = ptrtoint ptr @__ntramp___spawn_call_10 to i64
  store i64 %r76.tfn, ptr %r76.tgep, align 8
  %r76.c0 = getelementptr i64, ptr %r76.ptr, i64 1
  store i64 %r74, ptr %r76.c0, align 8
  %r76.c1 = getelementptr i64, ptr %r76.ptr, i64 2
  store i64 %r75, ptr %r76.c1, align 8
  %r76 = ptrtoint ptr %r76.ptr to i64
  %r77.ptr = inttoptr i64 %r76 to ptr
  %r77.gep = getelementptr i64, ptr %r77.ptr, i64 0
  %r77 = load i64, ptr %r77.gep, align 8
  %r78 = call i64 @nova_rt_spawn(i64 %r77, i64 %r76)
  %r79 = call i64 @nova_rt_channel_create()
  store i64 %r79, ptr %slot.f7_out, align 8
  %r80 = load i64, ptr %slot.f5_out, align 8
  %r81 = load i64, ptr %slot.f7_out, align 8
  %r82.ptr = call ptr @nova_rt_struct_alloc(i64 24)
  %r82.tgep = getelementptr i64, ptr %r82.ptr, i64 0
  %r82.tfn = ptrtoint ptr @__ntramp___spawn_call_11 to i64
  store i64 %r82.tfn, ptr %r82.tgep, align 8
  %r82.c0 = getelementptr i64, ptr %r82.ptr, i64 1
  store i64 %r80, ptr %r82.c0, align 8
  %r82.c1 = getelementptr i64, ptr %r82.ptr, i64 2
  store i64 %r81, ptr %r82.c1, align 8
  %r82 = ptrtoint ptr %r82.ptr to i64
  %r83.ptr = inttoptr i64 %r82 to ptr
  %r83.gep = getelementptr i64, ptr %r83.ptr, i64 0
  %r83 = load i64, ptr %r83.gep, align 8
  %r84 = call i64 @nova_rt_spawn(i64 %r83, i64 %r82)
  %r85 = call i64 @nova_rt_channel_create()
  store i64 %r85, ptr %slot.sieve_result, align 8
  %r86 = load i64, ptr %slot.f7_out, align 8
  %r87 = load i64, ptr %slot.sieve_result, align 8
  %r88.ptr = call ptr @nova_rt_struct_alloc(i64 24)
  %r88.tgep = getelementptr i64, ptr %r88.ptr, i64 0
  %r88.tfn = ptrtoint ptr @__ntramp___spawn_call_12 to i64
  store i64 %r88.tfn, ptr %r88.tgep, align 8
  %r88.c0 = getelementptr i64, ptr %r88.ptr, i64 1
  store i64 %r86, ptr %r88.c0, align 8
  %r88.c1 = getelementptr i64, ptr %r88.ptr, i64 2
  store i64 %r87, ptr %r88.c1, align 8
  %r88 = ptrtoint ptr %r88.ptr to i64
  %r89.ptr = inttoptr i64 %r88 to ptr
  %r89.gep = getelementptr i64, ptr %r89.ptr, i64 0
  %r89 = load i64, ptr %r89.gep, align 8
  %r90 = call i64 @nova_rt_spawn(i64 %r89, i64 %r88)
  %r91 = load i64, ptr %slot.sieve_result, align 8
  %r92 = call i64 @nova_rt_channel_recv(i64 %r91)
  store i64 %r92, ptr %slot.sieve_count, align 8
  %r93.p = getelementptr inbounds [52 x i8], ptr @.str.2, i64 0, i64 0
  %r93 = ptrtoint ptr %r93.p to i64
  %r94 = load i64, ptr %slot.sieve_count, align 8
  %r95 = call i64 @nova_rt_any_to_str(i64 %r94)
  %r96 = call i64 @nova_rt_str_concat(i64 %r93, i64 %r95)
  %r97 = call i64 @nova_rt_print_str(i64 %r96)
  %r98 = call i64 @nova_rt_channel_create()
  store i64 %r98, ptr %slot.prod_ch, align 8
  %r99 = load i64, ptr %slot.prod_ch, align 8
  %r100.ptr = call ptr @nova_rt_struct_alloc(i64 16)
  %r100.tgep = getelementptr i64, ptr %r100.ptr, i64 0
  %r100.tfn = ptrtoint ptr @__ntramp___spawn_call_13 to i64
  store i64 %r100.tfn, ptr %r100.tgep, align 8
  %r100.c0 = getelementptr i64, ptr %r100.ptr, i64 1
  store i64 %r99, ptr %r100.c0, align 8
  %r100 = ptrtoint ptr %r100.ptr to i64
  %r101.ptr = inttoptr i64 %r100 to ptr
  %r101.gep = getelementptr i64, ptr %r101.ptr, i64 0
  %r101 = load i64, ptr %r101.gep, align 8
  %r102 = call i64 @nova_rt_spawn(i64 %r101, i64 %r100)
  %r103 = add i64 0, 0
  store i64 %r103, ptr %slot.sum, align 8
  %r104 = load i64, ptr %slot.sum, align 8
  %r105 = load i64, ptr %slot.prod_ch, align 8
  %r106 = call i64 @nova_rt_channel_recv(i64 %r105)
  %r107 = call i64 @nova_rt_add(i64 %r104, i64 %r106)
  store i64 %r107, ptr %slot.sum, align 8
  %r108 = load i64, ptr %slot.sum, align 8
  %r109 = load i64, ptr %slot.prod_ch, align 8
  %r110 = call i64 @nova_rt_channel_recv(i64 %r109)
  %r111 = call i64 @nova_rt_add(i64 %r108, i64 %r110)
  store i64 %r111, ptr %slot.sum, align 8
  %r112 = load i64, ptr %slot.sum, align 8
  %r113 = load i64, ptr %slot.prod_ch, align 8
  %r114 = call i64 @nova_rt_channel_recv(i64 %r113)
  %r115 = call i64 @nova_rt_add(i64 %r112, i64 %r114)
  store i64 %r115, ptr %slot.sum, align 8
  %r116 = load i64, ptr %slot.sum, align 8
  %r117 = load i64, ptr %slot.prod_ch, align 8
  %r118 = call i64 @nova_rt_channel_recv(i64 %r117)
  %r119 = call i64 @nova_rt_add(i64 %r116, i64 %r118)
  store i64 %r119, ptr %slot.sum, align 8
  %r120 = load i64, ptr %slot.sum, align 8
  %r121 = load i64, ptr %slot.prod_ch, align 8
  %r122 = call i64 @nova_rt_channel_recv(i64 %r121)
  %r123 = call i64 @nova_rt_add(i64 %r120, i64 %r122)
  store i64 %r123, ptr %slot.sum, align 8
  %r124.p = getelementptr inbounds [16 x i8], ptr @.str.3, i64 0, i64 0
  %r124 = ptrtoint ptr %r124.p to i64
  %r125 = load i64, ptr %slot.sum, align 8
  %r126 = call i64 @nova_rt_int_to_str(i64 %r125)
  %r127 = call i64 @nova_rt_str_concat(i64 %r124, i64 %r126)
  %r128 = call i64 @nova_rt_print_str(i64 %r127)
  %r129 = add i64 2, 0
  %r130 = call i64 @make_worker(i64 %r129)
  store i64 %r130, ptr %slot.doubler, align 8
  %r131 = add i64 3, 0
  %r132 = call i64 @make_worker(i64 %r131)
  store i64 %r132, ptr %slot.tripler, align 8
  %r133 = call i64 @nova_rt_channel_create()
  store i64 %r133, ptr %slot.cap_ch, align 8
  %r134 = load i64, ptr %slot.doubler, align 8
  %r135 = load i64, ptr %slot.cap_ch, align 8
  %r136.ptr = call ptr @nova_rt_struct_alloc(i64 24)
  %r136.tgep = getelementptr i64, ptr %r136.ptr, i64 0
  %r136.tfn = ptrtoint ptr @__ntramp___spawn_call_14 to i64
  store i64 %r136.tfn, ptr %r136.tgep, align 8
  %r136.c0 = getelementptr i64, ptr %r136.ptr, i64 1
  store i64 %r134, ptr %r136.c0, align 8
  %r136.c1 = getelementptr i64, ptr %r136.ptr, i64 2
  store i64 %r135, ptr %r136.c1, align 8
  %r136 = ptrtoint ptr %r136.ptr to i64
  %r137.ptr = inttoptr i64 %r136 to ptr
  %r137.gep = getelementptr i64, ptr %r137.ptr, i64 0
  %r137 = load i64, ptr %r137.gep, align 8
  %r138 = call i64 @nova_rt_spawn(i64 %r137, i64 %r136)
  %r139 = load i64, ptr %slot.tripler, align 8
  %r140 = load i64, ptr %slot.cap_ch, align 8
  %r141.ptr = call ptr @nova_rt_struct_alloc(i64 24)
  %r141.tgep = getelementptr i64, ptr %r141.ptr, i64 0
  %r141.tfn = ptrtoint ptr @__ntramp___spawn_call_15 to i64
  store i64 %r141.tfn, ptr %r141.tgep, align 8
  %r141.c0 = getelementptr i64, ptr %r141.ptr, i64 1
  store i64 %r139, ptr %r141.c0, align 8
  %r141.c1 = getelementptr i64, ptr %r141.ptr, i64 2
  store i64 %r140, ptr %r141.c1, align 8
  %r141 = ptrtoint ptr %r141.ptr to i64
  %r142.ptr = inttoptr i64 %r141 to ptr
  %r142.gep = getelementptr i64, ptr %r142.ptr, i64 0
  %r142 = load i64, ptr %r142.gep, align 8
  %r143 = call i64 @nova_rt_spawn(i64 %r142, i64 %r141)
  %r144 = load i64, ptr %slot.cap_ch, align 8
  %r145 = call i64 @nova_rt_channel_recv(i64 %r144)
  store i64 %r145, ptr %slot.c1, align 8
  %r146 = load i64, ptr %slot.cap_ch, align 8
  %r147 = call i64 @nova_rt_channel_recv(i64 %r146)
  store i64 %r147, ptr %slot.c2, align 8
  %r148.p = getelementptr inbounds [19 x i8], ptr @.str.4, i64 0, i64 0
  %r148 = ptrtoint ptr %r148.p to i64
  %r149 = load i64, ptr %slot.c1, align 8
  %r150 = call i64 @nova_rt_any_to_str(i64 %r149)
  %r151 = call i64 @nova_rt_str_concat(i64 %r148, i64 %r150)
  %r152.p = getelementptr inbounds [6 x i8], ptr @.str.5, i64 0, i64 0
  %r152 = ptrtoint ptr %r152.p to i64
  %r153 = call i64 @nova_rt_str_concat(i64 %r151, i64 %r152)
  %r154 = load i64, ptr %slot.c2, align 8
  %r155 = call i64 @nova_rt_any_to_str(i64 %r154)
  %r156 = call i64 @nova_rt_str_concat(i64 %r153, i64 %r155)
  %r157 = call i64 @nova_rt_print_str(i64 %r156)
  %r158.p = getelementptr inbounds [1 x i8], ptr @.str.6, i64 0, i64 0
  %r158 = ptrtoint ptr %r158.p to i64
  %r159 = call i64 @nova_rt_print_str(i64 %r158)
  %r160.p = getelementptr inbounds [29 x i8], ptr @.str.7, i64 0, i64 0
  %r160 = ptrtoint ptr %r160.p to i64
  %r161 = call i64 @nova_rt_print_str(i64 %r160)
  ret i64 0
}

define i64 @__nfn___spawn_call_1(i64 %p0) nounwind {
entry:
  %slot.results = alloca i64, align 8
  store i64 %p0, ptr %slot.results, align 8
  %r0 = load i64, ptr %slot.results, align 8
  %r1 = add i64 1, 0
  %r2 = add i64 50, 0
  %r3 = call i64 @compute_squares(i64 %r0, i64 %r1, i64 %r2)
  ret i64 %r3
}

define i64 @__nfn___spawn_call_2(i64 %p0) nounwind {
entry:
  %slot.results = alloca i64, align 8
  store i64 %p0, ptr %slot.results, align 8
  %r0 = load i64, ptr %slot.results, align 8
  %r1 = add i64 51, 0
  %r2 = add i64 50, 0
  %r3 = call i64 @compute_squares(i64 %r0, i64 %r1, i64 %r2)
  ret i64 %r3
}

define i64 @__nfn___spawn_call_3(i64 %p0) nounwind {
entry:
  %slot.prime_ch = alloca i64, align 8
  store i64 %p0, ptr %slot.prime_ch, align 8
  %r0 = load i64, ptr %slot.prime_ch, align 8
  %r1 = add i64 2, 0
  %r2 = add i64 2500, 0
  %r3 = call i64 @count_primes_range(i64 %r0, i64 %r1, i64 %r2)
  ret i64 %r3
}

define i64 @__nfn___spawn_call_4(i64 %p0) nounwind {
entry:
  %slot.prime_ch = alloca i64, align 8
  store i64 %p0, ptr %slot.prime_ch, align 8
  %r0 = load i64, ptr %slot.prime_ch, align 8
  %r1 = add i64 2501, 0
  %r2 = add i64 5000, 0
  %r3 = call i64 @count_primes_range(i64 %r0, i64 %r1, i64 %r2)
  ret i64 %r3
}

define i64 @__nfn___spawn_call_5(i64 %p0) nounwind {
entry:
  %slot.prime_ch = alloca i64, align 8
  store i64 %p0, ptr %slot.prime_ch, align 8
  %r0 = load i64, ptr %slot.prime_ch, align 8
  %r1 = add i64 5001, 0
  %r2 = add i64 7500, 0
  %r3 = call i64 @count_primes_range(i64 %r0, i64 %r1, i64 %r2)
  ret i64 %r3
}

define i64 @__nfn___spawn_call_6(i64 %p0) nounwind {
entry:
  %slot.prime_ch = alloca i64, align 8
  store i64 %p0, ptr %slot.prime_ch, align 8
  %r0 = load i64, ptr %slot.prime_ch, align 8
  %r1 = add i64 7501, 0
  %r2 = add i64 10000, 0
  %r3 = call i64 @count_primes_range(i64 %r0, i64 %r1, i64 %r2)
  ret i64 %r3
}

define i64 @__nfn___spawn_call_7(i64 %p0) nounwind {
entry:
  %slot.gen_out = alloca i64, align 8
  store i64 %p0, ptr %slot.gen_out, align 8
  %r0 = load i64, ptr %slot.gen_out, align 8
  %r1 = add i64 50, 0
  %r2 = call i64 @generate(i64 %r0, i64 %r1)
  ret i64 %r2
}

define i64 @__nfn___spawn_call_8(i64 %p0, i64 %p1) nounwind {
entry:
  %slot.gen_out = alloca i64, align 8
  store i64 %p0, ptr %slot.gen_out, align 8
  %slot.f2_out = alloca i64, align 8
  store i64 %p1, ptr %slot.f2_out, align 8
  %r0 = load i64, ptr %slot.gen_out, align 8
  %r1 = load i64, ptr %slot.f2_out, align 8
  %r2 = add i64 2, 0
  %r3 = call i64 @filter_stage(i64 %r0, i64 %r1, i64 %r2)
  ret i64 %r3
}

define i64 @__nfn___spawn_call_9(i64 %p0, i64 %p1) nounwind {
entry:
  %slot.f2_out = alloca i64, align 8
  store i64 %p0, ptr %slot.f2_out, align 8
  %slot.f3_out = alloca i64, align 8
  store i64 %p1, ptr %slot.f3_out, align 8
  %r0 = load i64, ptr %slot.f2_out, align 8
  %r1 = load i64, ptr %slot.f3_out, align 8
  %r2 = add i64 3, 0
  %r3 = call i64 @filter_stage(i64 %r0, i64 %r1, i64 %r2)
  ret i64 %r3
}

define i64 @__nfn___spawn_call_10(i64 %p0, i64 %p1) nounwind {
entry:
  %slot.f3_out = alloca i64, align 8
  store i64 %p0, ptr %slot.f3_out, align 8
  %slot.f5_out = alloca i64, align 8
  store i64 %p1, ptr %slot.f5_out, align 8
  %r0 = load i64, ptr %slot.f3_out, align 8
  %r1 = load i64, ptr %slot.f5_out, align 8
  %r2 = add i64 5, 0
  %r3 = call i64 @filter_stage(i64 %r0, i64 %r1, i64 %r2)
  ret i64 %r3
}

define i64 @__nfn___spawn_call_11(i64 %p0, i64 %p1) nounwind {
entry:
  %slot.f5_out = alloca i64, align 8
  store i64 %p0, ptr %slot.f5_out, align 8
  %slot.f7_out = alloca i64, align 8
  store i64 %p1, ptr %slot.f7_out, align 8
  %r0 = load i64, ptr %slot.f5_out, align 8
  %r1 = load i64, ptr %slot.f7_out, align 8
  %r2 = add i64 7, 0
  %r3 = call i64 @filter_stage(i64 %r0, i64 %r1, i64 %r2)
  ret i64 %r3
}

define i64 @__nfn___spawn_call_12(i64 %p0, i64 %p1) nounwind {
entry:
  %slot.f7_out = alloca i64, align 8
  store i64 %p0, ptr %slot.f7_out, align 8
  %slot.sieve_result = alloca i64, align 8
  store i64 %p1, ptr %slot.sieve_result, align 8
  %r0 = load i64, ptr %slot.f7_out, align 8
  %r1 = load i64, ptr %slot.sieve_result, align 8
  %r2 = add i64 100, 0
  %r3 = call i64 @collect_primes(i64 %r0, i64 %r1, i64 %r2)
  ret i64 %r3
}

define i64 @__nfn___spawn_call_13(i64 %p0) nounwind {
entry:
  %slot.prod_ch = alloca i64, align 8
  store i64 %p0, ptr %slot.prod_ch, align 8
  %r0 = load i64, ptr %slot.prod_ch, align 8
  %r1 = add i64 5, 0
  %r2 = call i64 @producer(i64 %r0, i64 %r1)
  ret i64 %r2
}

define i64 @__nfn___spawn_call_14(i64 %p0, i64 %p1) nounwind {
entry:
  %slot.doubler = alloca i64, align 8
  store i64 %p0, ptr %slot.doubler, align 8
  %slot.cap_ch = alloca i64, align 8
  store i64 %p1, ptr %slot.cap_ch, align 8
  %r0 = load i64, ptr %slot.cap_ch, align 8
  %r1 = add i64 21, 0
  %r3 = load i64, ptr %slot.doubler, align 8
  %r2.rec = inttoptr i64 %r3 to ptr
  %r2.fnraw = load i64, ptr %r2.rec, align 8
  %r2.fnptr = inttoptr i64 %r2.fnraw to ptr
  %r2 = call i64 %r2.fnptr(i64 %r3, i64 %r0, i64 %r1)
  ret i64 %r2
}

define i64 @__nfn___spawn_call_15(i64 %p0, i64 %p1) nounwind {
entry:
  %slot.tripler = alloca i64, align 8
  store i64 %p0, ptr %slot.tripler, align 8
  %slot.cap_ch = alloca i64, align 8
  store i64 %p1, ptr %slot.cap_ch, align 8
  %r0 = load i64, ptr %slot.cap_ch, align 8
  %r1 = add i64 14, 0
  %r3 = load i64, ptr %slot.tripler, align 8
  %r2.rec = inttoptr i64 %r3 to ptr
  %r2.fnraw = load i64, ptr %r2.rec, align 8
  %r2.fnptr = inttoptr i64 %r2.fnraw to ptr
  %r2 = call i64 %r2.fnptr(i64 %r3, i64 %r0, i64 %r1)
  ret i64 %r2
}

define i64 @__tramp_0(i64 %record, i64 %p0, i64 %p1) nounwind {
entry:
  %rec_ptr = inttoptr i64 %record to ptr
  %cap0_ptr = getelementptr i64, ptr %rec_ptr, i64 1
  %cap0 = load i64, ptr %cap0_ptr, align 8
  %result = call i64 @__lambda_0(i64 %cap0, i64 %p0, i64 %p1)
  ret i64 %result
}

define i64 @__ntramp___spawn_call_1(i64 %record) nounwind {
entry:
  %rec_ptr = inttoptr i64 %record to ptr
  %cap0_ptr = getelementptr i64, ptr %rec_ptr, i64 1
  %cap0 = load i64, ptr %cap0_ptr, align 8
  %result = call i64 @__nfn___spawn_call_1(i64 %cap0)
  ret i64 %result
}

define i64 @__ntramp___spawn_call_2(i64 %record) nounwind {
entry:
  %rec_ptr = inttoptr i64 %record to ptr
  %cap0_ptr = getelementptr i64, ptr %rec_ptr, i64 1
  %cap0 = load i64, ptr %cap0_ptr, align 8
  %result = call i64 @__nfn___spawn_call_2(i64 %cap0)
  ret i64 %result
}

define i64 @__ntramp___spawn_call_3(i64 %record) nounwind {
entry:
  %rec_ptr = inttoptr i64 %record to ptr
  %cap0_ptr = getelementptr i64, ptr %rec_ptr, i64 1
  %cap0 = load i64, ptr %cap0_ptr, align 8
  %result = call i64 @__nfn___spawn_call_3(i64 %cap0)
  ret i64 %result
}

define i64 @__ntramp___spawn_call_4(i64 %record) nounwind {
entry:
  %rec_ptr = inttoptr i64 %record to ptr
  %cap0_ptr = getelementptr i64, ptr %rec_ptr, i64 1
  %cap0 = load i64, ptr %cap0_ptr, align 8
  %result = call i64 @__nfn___spawn_call_4(i64 %cap0)
  ret i64 %result
}

define i64 @__ntramp___spawn_call_5(i64 %record) nounwind {
entry:
  %rec_ptr = inttoptr i64 %record to ptr
  %cap0_ptr = getelementptr i64, ptr %rec_ptr, i64 1
  %cap0 = load i64, ptr %cap0_ptr, align 8
  %result = call i64 @__nfn___spawn_call_5(i64 %cap0)
  ret i64 %result
}

define i64 @__ntramp___spawn_call_6(i64 %record) nounwind {
entry:
  %rec_ptr = inttoptr i64 %record to ptr
  %cap0_ptr = getelementptr i64, ptr %rec_ptr, i64 1
  %cap0 = load i64, ptr %cap0_ptr, align 8
  %result = call i64 @__nfn___spawn_call_6(i64 %cap0)
  ret i64 %result
}

define i64 @__ntramp___spawn_call_7(i64 %record) nounwind {
entry:
  %rec_ptr = inttoptr i64 %record to ptr
  %cap0_ptr = getelementptr i64, ptr %rec_ptr, i64 1
  %cap0 = load i64, ptr %cap0_ptr, align 8
  %result = call i64 @__nfn___spawn_call_7(i64 %cap0)
  ret i64 %result
}

define i64 @__ntramp___spawn_call_8(i64 %record) nounwind {
entry:
  %rec_ptr = inttoptr i64 %record to ptr
  %cap0_ptr = getelementptr i64, ptr %rec_ptr, i64 1
  %cap0 = load i64, ptr %cap0_ptr, align 8
  %cap1_ptr = getelementptr i64, ptr %rec_ptr, i64 2
  %cap1 = load i64, ptr %cap1_ptr, align 8
  %result = call i64 @__nfn___spawn_call_8(i64 %cap0, i64 %cap1)
  ret i64 %result
}

define i64 @__ntramp___spawn_call_9(i64 %record) nounwind {
entry:
  %rec_ptr = inttoptr i64 %record to ptr
  %cap0_ptr = getelementptr i64, ptr %rec_ptr, i64 1
  %cap0 = load i64, ptr %cap0_ptr, align 8
  %cap1_ptr = getelementptr i64, ptr %rec_ptr, i64 2
  %cap1 = load i64, ptr %cap1_ptr, align 8
  %result = call i64 @__nfn___spawn_call_9(i64 %cap0, i64 %cap1)
  ret i64 %result
}

define i64 @__ntramp___spawn_call_10(i64 %record) nounwind {
entry:
  %rec_ptr = inttoptr i64 %record to ptr
  %cap0_ptr = getelementptr i64, ptr %rec_ptr, i64 1
  %cap0 = load i64, ptr %cap0_ptr, align 8
  %cap1_ptr = getelementptr i64, ptr %rec_ptr, i64 2
  %cap1 = load i64, ptr %cap1_ptr, align 8
  %result = call i64 @__nfn___spawn_call_10(i64 %cap0, i64 %cap1)
  ret i64 %result
}

define i64 @__ntramp___spawn_call_11(i64 %record) nounwind {
entry:
  %rec_ptr = inttoptr i64 %record to ptr
  %cap0_ptr = getelementptr i64, ptr %rec_ptr, i64 1
  %cap0 = load i64, ptr %cap0_ptr, align 8
  %cap1_ptr = getelementptr i64, ptr %rec_ptr, i64 2
  %cap1 = load i64, ptr %cap1_ptr, align 8
  %result = call i64 @__nfn___spawn_call_11(i64 %cap0, i64 %cap1)
  ret i64 %result
}

define i64 @__ntramp___spawn_call_12(i64 %record) nounwind {
entry:
  %rec_ptr = inttoptr i64 %record to ptr
  %cap0_ptr = getelementptr i64, ptr %rec_ptr, i64 1
  %cap0 = load i64, ptr %cap0_ptr, align 8
  %cap1_ptr = getelementptr i64, ptr %rec_ptr, i64 2
  %cap1 = load i64, ptr %cap1_ptr, align 8
  %result = call i64 @__nfn___spawn_call_12(i64 %cap0, i64 %cap1)
  ret i64 %result
}

define i64 @__ntramp___spawn_call_13(i64 %record) nounwind {
entry:
  %rec_ptr = inttoptr i64 %record to ptr
  %cap0_ptr = getelementptr i64, ptr %rec_ptr, i64 1
  %cap0 = load i64, ptr %cap0_ptr, align 8
  %result = call i64 @__nfn___spawn_call_13(i64 %cap0)
  ret i64 %result
}

define i64 @__ntramp___spawn_call_14(i64 %record) nounwind {
entry:
  %rec_ptr = inttoptr i64 %record to ptr
  %cap0_ptr = getelementptr i64, ptr %rec_ptr, i64 1
  %cap0 = load i64, ptr %cap0_ptr, align 8
  %cap1_ptr = getelementptr i64, ptr %rec_ptr, i64 2
  %cap1 = load i64, ptr %cap1_ptr, align 8
  %result = call i64 @__nfn___spawn_call_14(i64 %cap0, i64 %cap1)
  ret i64 %result
}

define i64 @__ntramp___spawn_call_15(i64 %record) nounwind {
entry:
  %rec_ptr = inttoptr i64 %record to ptr
  %cap0_ptr = getelementptr i64, ptr %rec_ptr, i64 1
  %cap0 = load i64, ptr %cap0_ptr, align 8
  %cap1_ptr = getelementptr i64, ptr %rec_ptr, i64 2
  %cap1 = load i64, ptr %cap1_ptr, align 8
  %result = call i64 @__nfn___spawn_call_15(i64 %cap0, i64 %cap1)
  ret i64 %result
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
@.str.0 = private unnamed_addr constant [25 x i8] c"Sum of squares 1..100 = \00"
@.str.1 = private unnamed_addr constant [22 x i8] c"Primes up to 10000 = \00"
@.str.2 = private unnamed_addr constant [52 x i8] c"Primes remaining after sieve(2,3,5,7) from 2..50 = \00"
@.str.3 = private unnamed_addr constant [16 x i8] c"Producer sum = \00"
@.str.4 = private unnamed_addr constant [19 x i8] c"Closure captures: \00"
@.str.5 = private unnamed_addr constant [6 x i8] c" and \00"
@.str.6 = private unnamed_addr constant [1 x i8] c"\00"
@.str.7 = private unnamed_addr constant [29 x i8] c"All concurrent tests passed!\00"

; Debug metadata
!llvm.dbg.cu = !{!100}
!llvm.module.flags = !{!102, !103}

!100 = distinct !DICompileUnit(language: DW_LANG_C99, file: !101, producer: "NOVA Compiler", isOptimized: false, emissionKind: LineTablesOnly)
!101 = !DIFile(filename: "..\nova-compiler\test_programs\concurrent_stress_test.nova", directory: ".")
!102 = !{i32 2, !"CodeView", i32 1}
!103 = !{i32 2, !"Debug Info Version", i32 3}
!104 = !DISubroutineType(types: !105)
!105 = !{null}
!200 = distinct !DISubprogram(name: "compute_squares", scope: !101, file: !101, line: 7, type: !104, scopeLine: 7, spFlags: DISPFlagDefinition, unit: !100)
!201 = !DILocation(line: 7, column: 0, scope: !200)
!208 = distinct !DISubprogram(name: "is_prime", scope: !101, file: !101, line: 25, type: !104, scopeLine: 25, spFlags: DISPFlagDefinition, unit: !100)
!209 = !DILocation(line: 25, column: 0, scope: !208)
!222 = distinct !DISubprogram(name: "count_primes_range", scope: !101, file: !101, line: 39, type: !104, scopeLine: 39, spFlags: DISPFlagDefinition, unit: !100)
!223 = !DILocation(line: 39, column: 0, scope: !222)
!230 = distinct !DISubprogram(name: "generate", scope: !101, file: !101, line: 61, type: !104, scopeLine: 61, spFlags: DISPFlagDefinition, unit: !100)
!231 = !DILocation(line: 61, column: 0, scope: !230)
!237 = distinct !DISubprogram(name: "filter_stage", scope: !101, file: !101, line: 68, type: !104, scopeLine: 68, spFlags: DISPFlagDefinition, unit: !100)
!238 = !DILocation(line: 68, column: 0, scope: !237)
!246 = distinct !DISubprogram(name: "collect_primes", scope: !101, file: !101, line: 78, type: !104, scopeLine: 78, spFlags: DISPFlagDefinition, unit: !100)
!247 = !DILocation(line: 78, column: 0, scope: !246)
!258 = distinct !DISubprogram(name: "producer", scope: !101, file: !101, line: 114, type: !104, scopeLine: 114, spFlags: DISPFlagDefinition, unit: !100)
!259 = !DILocation(line: 114, column: 0, scope: !258)
!265 = distinct !DISubprogram(name: "make_worker", scope: !101, file: !101, line: 134, type: !104, scopeLine: 134, spFlags: DISPFlagDefinition, unit: !100)
!266 = !DILocation(line: 134, column: 0, scope: !265)
!202 = !DILocation(line: 8, column: 0, scope: !200)
!203 = !DILocation(line: 9, column: 0, scope: !200)
!204 = !DILocation(line: 10, column: 0, scope: !200)
!205 = !DILocation(line: 11, column: 0, scope: !200)
!206 = !DILocation(line: 12, column: 0, scope: !200)
!207 = !DILocation(line: 13, column: 0, scope: !200)
!210 = !DILocation(line: 26, column: 0, scope: !208)
!211 = !DILocation(line: 27, column: 0, scope: !208)
!212 = !DILocation(line: 28, column: 0, scope: !208)
!213 = !DILocation(line: 29, column: 0, scope: !208)
!214 = !DILocation(line: 30, column: 0, scope: !208)
!215 = !DILocation(line: 31, column: 0, scope: !208)
!216 = !DILocation(line: 32, column: 0, scope: !208)
!217 = !DILocation(line: 33, column: 0, scope: !208)
!218 = !DILocation(line: 34, column: 0, scope: !208)
!219 = !DILocation(line: 35, column: 0, scope: !208)
!220 = !DILocation(line: 36, column: 0, scope: !208)
!221 = !DILocation(line: 37, column: 0, scope: !208)
!224 = !DILocation(line: 40, column: 0, scope: !222)
!225 = !DILocation(line: 41, column: 0, scope: !222)
!226 = !DILocation(line: 42, column: 0, scope: !222)
!227 = !DILocation(line: 43, column: 0, scope: !222)
!228 = !DILocation(line: 44, column: 0, scope: !222)
!229 = !DILocation(line: 45, column: 0, scope: !222)
!232 = !DILocation(line: 62, column: 0, scope: !230)
!233 = !DILocation(line: 63, column: 0, scope: !230)
!234 = !DILocation(line: 64, column: 0, scope: !230)
!235 = !DILocation(line: 65, column: 0, scope: !230)
!236 = !DILocation(line: 66, column: 0, scope: !230)
!239 = !DILocation(line: 69, column: 0, scope: !237)
!240 = !DILocation(line: 70, column: 0, scope: !237)
!241 = !DILocation(line: 71, column: 0, scope: !237)
!242 = !DILocation(line: 72, column: 0, scope: !237)
!243 = !DILocation(line: 73, column: 0, scope: !237)
!244 = !DILocation(line: 74, column: 0, scope: !237)
!245 = !DILocation(line: 75, column: 0, scope: !237)
!248 = !DILocation(line: 79, column: 0, scope: !246)
!249 = !DILocation(line: 80, column: 0, scope: !246)
!250 = !DILocation(line: 81, column: 0, scope: !246)
!251 = !DILocation(line: 82, column: 0, scope: !246)
!252 = !DILocation(line: 83, column: 0, scope: !246)
!253 = !DILocation(line: 84, column: 0, scope: !246)
!254 = !DILocation(line: 85, column: 0, scope: !246)
!255 = !DILocation(line: 86, column: 0, scope: !246)
!256 = !DILocation(line: 87, column: 0, scope: !246)
!257 = !DILocation(line: 88, column: 0, scope: !246)
!260 = !DILocation(line: 115, column: 0, scope: !258)
!261 = !DILocation(line: 116, column: 0, scope: !258)
!262 = !DILocation(line: 117, column: 0, scope: !258)
!263 = !DILocation(line: 118, column: 0, scope: !258)
!264 = !DILocation(line: 119, column: 0, scope: !258)
!267 = !DILocation(line: 135, column: 0, scope: !265)

; TBAA metadata
!0 = !{!"NOVA TBAA"}
!1 = !{!"list_data_ptr", !0}
!2 = !{!1, !1, i64 0}
!3 = !{!"list_elem", !0}
!4 = !{!3, !3, i64 0}
!5 = !{!"list_size", !0}
!6 = !{!5, !5, i64 0}
!90 = !{!"branch_weights", i32 2000, i32 1}
