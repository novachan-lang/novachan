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

define i64 @set_new() nounwind !dbg !200 {
entry:
  %slot.items = alloca i64, align 8, !dbg !201
  store i64 0, ptr %slot.items, align 8, !dbg !201
  %r0 = call i64 @nova_rt_list_create(), !dbg !202
  store i64 %r0, ptr %slot.items, align 8, !dbg !202
  %r2 = add i64 %r0, 0, !dbg !203
  %r1 = call i64 @nova_rt_list_create(), !dbg !203
  call i64 @nova_rt_list_append(i64 %r1, i64 %r2), !dbg !203
  ret i64 %r1, !dbg !203
}

define i64 @set_add(i64 %p0, i64 %p1) nounwind !dbg !204 {
entry:
  %slot.s = alloca i64, align 8, !dbg !205
  store i64 %p0, ptr %slot.s, align 8, !dbg !205
  %slot.item = alloca i64, align 8, !dbg !205
  store i64 %p1, ptr %slot.item, align 8, !dbg !205
  %slot.items = alloca i64, align 8, !dbg !205
  store i64 0, ptr %slot.items, align 8, !dbg !205
  %slot.i = alloca i64, align 8, !dbg !205
  store i64 0, ptr %slot.i, align 8, !dbg !205
  %r0 = load i64, ptr %slot.s, align 8, !dbg !206
  %r1 = add i64 0, 0, !dbg !206
  %r2 = call i64 @nova_rt_index_get(i64 %r0, i64 %r1), !dbg !206
  store i64 %r2, ptr %slot.items, align 8, !dbg !206
  %r3 = add i64 0, 0, !dbg !207
  store i64 %r3, ptr %slot.i, align 8, !dbg !207
  br label %while_hdr0, !dbg !208
while_hdr0:
  %r4 = load i64, ptr %slot.i, align 8, !dbg !208
  %r5 = load i64, ptr %slot.items, align 8, !dbg !208
  %r6 = call i64 @nova_rt_len_any(i64 %r5), !dbg !208
  %r7.cmp = icmp slt i64 %r4, %r6, !dbg !208
  %r7 = zext i1 %r7.cmp to i64, !dbg !208
  %br_while_body1 = icmp ne i64 %r7, 0, !dbg !208
  br i1 %br_while_body1, label %while_body1, label %while_exit2, !prof !90, !dbg !208
while_body1:
  %r8 = load i64, ptr %slot.items, align 8, !dbg !209
  %r9 = load i64, ptr %slot.i, align 8, !dbg !209
  %r10 = call i64 @nova_rt_index_get(i64 %r8, i64 %r9), !dbg !209
  %r11 = load i64, ptr %slot.item, align 8, !dbg !209
  %r12 = call i64 @nova_rt_eq(i64 %r10, i64 %r11), !dbg !209
  %br_then3 = icmp ne i64 %r12, 0, !dbg !209
  br i1 %br_then3, label %then3, label %else4, !dbg !209
then3:
  %r13 = add i64 0, 0, !dbg !210
  ret i64 %r13, !dbg !210
else4:
  br label %endif5, !dbg !210
endif5:
  %r14 = load i64, ptr %slot.i, align 8, !dbg !211
  %r15 = add i64 1, 0, !dbg !211
  %r16 = add i64 %r14, %r15, !dbg !211
  store i64 %r16, ptr %slot.i, align 8, !dbg !211
  br label %while_hdr0, !dbg !211
while_exit2:
  %r17 = load i64, ptr %slot.items, align 8, !dbg !212
  %r18 = load i64, ptr %slot.item, align 8, !dbg !212
  %r19 = call i64 @nova_rt_list_append(i64 %r17, i64 %r18), !dbg !212
  %r20 = add i64 0, 0, !dbg !213
  ret i64 %r20, !dbg !213
}

define i64 @set_remove(i64 %p0, i64 %p1) nounwind !dbg !214 {
entry:
  %slot.s = alloca i64, align 8, !dbg !215
  store i64 %p0, ptr %slot.s, align 8, !dbg !215
  %slot.item = alloca i64, align 8, !dbg !215
  store i64 %p1, ptr %slot.item, align 8, !dbg !215
  %slot.items = alloca i64, align 8, !dbg !215
  store i64 0, ptr %slot.items, align 8, !dbg !215
  %slot.rebuilt = alloca i64, align 8, !dbg !215
  store i64 0, ptr %slot.rebuilt, align 8, !dbg !215
  %slot.i = alloca i64, align 8, !dbg !215
  store i64 0, ptr %slot.i, align 8, !dbg !215
  %r0 = load i64, ptr %slot.s, align 8, !dbg !216
  %r1 = add i64 0, 0, !dbg !216
  %r2 = call i64 @nova_rt_index_get(i64 %r0, i64 %r1), !dbg !216
  store i64 %r2, ptr %slot.items, align 8, !dbg !216
  %r3 = call i64 @nova_rt_list_create(), !dbg !217
  store i64 %r3, ptr %slot.rebuilt, align 8, !dbg !217
  %r4 = add i64 0, 0, !dbg !218
  store i64 %r4, ptr %slot.i, align 8, !dbg !218
  br label %while_hdr6, !dbg !219
while_hdr6:
  %r5 = load i64, ptr %slot.i, align 8, !dbg !219
  %r6 = load i64, ptr %slot.items, align 8, !dbg !219
  %r7 = call i64 @nova_rt_len_any(i64 %r6), !dbg !219
  %r8.cmp = icmp slt i64 %r5, %r7, !dbg !219
  %r8 = zext i1 %r8.cmp to i64, !dbg !219
  %br_while_body7 = icmp ne i64 %r8, 0, !dbg !219
  br i1 %br_while_body7, label %while_body7, label %while_exit8, !prof !90, !dbg !219
while_body7:
  %r9 = load i64, ptr %slot.items, align 8, !dbg !220
  %r10 = load i64, ptr %slot.i, align 8, !dbg !220
  %r11 = call i64 @nova_rt_index_get(i64 %r9, i64 %r10), !dbg !220
  %r12 = load i64, ptr %slot.item, align 8, !dbg !220
  %r13 = call i64 @nova_rt_neq(i64 %r11, i64 %r12), !dbg !220
  %br_then9 = icmp ne i64 %r13, 0, !dbg !220
  br i1 %br_then9, label %then9, label %else10, !dbg !220
then9:
  %r14 = load i64, ptr %slot.rebuilt, align 8, !dbg !221
  %r15 = load i64, ptr %slot.items, align 8, !dbg !221
  %r16 = load i64, ptr %slot.i, align 8, !dbg !221
  %r17 = call i64 @nova_rt_index_get(i64 %r15, i64 %r16), !dbg !221
  %r18 = call i64 @nova_rt_list_append(i64 %r14, i64 %r17), !dbg !221
  br label %endif11, !dbg !221
else10:
  br label %endif11, !dbg !221
endif11:
  %r19 = load i64, ptr %slot.i, align 8, !dbg !222
  %r20 = add i64 1, 0, !dbg !222
  %r21 = add i64 %r19, %r20, !dbg !222
  store i64 %r21, ptr %slot.i, align 8, !dbg !222
  br label %while_hdr6, !dbg !222
while_exit8:
  %r22 = load i64, ptr %slot.rebuilt, align 8, !dbg !223
  %r23 = load i64, ptr %slot.s, align 8, !dbg !223
  %r24 = add i64 0, 0, !dbg !223
  %_is.gv0 = call i64 @nova_rt_index_set(i64 %r23, i64 %r24, i64 %r22), !dbg !223
  %r25 = add i64 0, 0, !dbg !224
  ret i64 %r25, !dbg !224
}

define i64 @set_contains(i64 %p0, i64 %p1) nounwind !dbg !225 {
entry:
  %slot.s = alloca i64, align 8, !dbg !226
  store i64 %p0, ptr %slot.s, align 8, !dbg !226
  %slot.item = alloca i64, align 8, !dbg !226
  store i64 %p1, ptr %slot.item, align 8, !dbg !226
  %slot.items = alloca i64, align 8, !dbg !226
  store i64 0, ptr %slot.items, align 8, !dbg !226
  %slot.i = alloca i64, align 8, !dbg !226
  store i64 0, ptr %slot.i, align 8, !dbg !226
  %r0 = load i64, ptr %slot.s, align 8, !dbg !227
  %r1 = add i64 0, 0, !dbg !227
  %r2 = call i64 @nova_rt_index_get(i64 %r0, i64 %r1), !dbg !227
  store i64 %r2, ptr %slot.items, align 8, !dbg !227
  %r3 = add i64 0, 0, !dbg !228
  store i64 %r3, ptr %slot.i, align 8, !dbg !228
  br label %while_hdr12, !dbg !229
while_hdr12:
  %r4 = load i64, ptr %slot.i, align 8, !dbg !229
  %r5 = load i64, ptr %slot.items, align 8, !dbg !229
  %r6 = call i64 @nova_rt_len_any(i64 %r5), !dbg !229
  %r7.cmp = icmp slt i64 %r4, %r6, !dbg !229
  %r7 = zext i1 %r7.cmp to i64, !dbg !229
  %br_while_body13 = icmp ne i64 %r7, 0, !dbg !229
  br i1 %br_while_body13, label %while_body13, label %while_exit14, !prof !90, !dbg !229
while_body13:
  %r8 = load i64, ptr %slot.items, align 8, !dbg !230
  %r9 = load i64, ptr %slot.i, align 8, !dbg !230
  %r10 = call i64 @nova_rt_index_get(i64 %r8, i64 %r9), !dbg !230
  %r11 = load i64, ptr %slot.item, align 8, !dbg !230
  %r12 = call i64 @nova_rt_eq(i64 %r10, i64 %r11), !dbg !230
  %br_then15 = icmp ne i64 %r12, 0, !dbg !230
  br i1 %br_then15, label %then15, label %else16, !dbg !230
then15:
  %r13 = add i64 1, 0, !dbg !231
  ret i64 %r13, !dbg !231
else16:
  br label %endif17, !dbg !231
endif17:
  %r14 = load i64, ptr %slot.i, align 8, !dbg !232
  %r15 = add i64 1, 0, !dbg !232
  %r16 = add i64 %r14, %r15, !dbg !232
  store i64 %r16, ptr %slot.i, align 8, !dbg !232
  br label %while_hdr12, !dbg !232
while_exit14:
  %r17 = add i64 0, 0, !dbg !233
  ret i64 %r17, !dbg !233
}

define i64 @set_size(i64 %p0) nounwind !dbg !234 {
entry:
  %slot.s = alloca i64, align 8, !dbg !235
  store i64 %p0, ptr %slot.s, align 8, !dbg !235
  %r0 = load i64, ptr %slot.s, align 8, !dbg !236
  %r1 = add i64 0, 0, !dbg !236
  %r2 = call i64 @nova_rt_index_get(i64 %r0, i64 %r1), !dbg !236
  %r3 = call i64 @nova_rt_len_any(i64 %r2), !dbg !236
  ret i64 %r3, !dbg !236
}

define i64 @set_union(i64 %p0, i64 %p1) nounwind !dbg !237 {
entry:
  %slot.a = alloca i64, align 8, !dbg !238
  store i64 %p0, ptr %slot.a, align 8, !dbg !238
  %slot.b = alloca i64, align 8, !dbg !238
  store i64 %p1, ptr %slot.b, align 8, !dbg !238
  %slot.result = alloca i64, align 8, !dbg !238
  store i64 0, ptr %slot.result, align 8, !dbg !238
  %slot.ai = alloca i64, align 8, !dbg !238
  store i64 0, ptr %slot.ai, align 8, !dbg !238
  %slot.i = alloca i64, align 8, !dbg !238
  store i64 0, ptr %slot.i, align 8, !dbg !238
  %slot.bi = alloca i64, align 8, !dbg !238
  store i64 0, ptr %slot.bi, align 8, !dbg !238
  %slot.j = alloca i64, align 8, !dbg !238
  store i64 0, ptr %slot.j, align 8, !dbg !238
  %r0 = call i64 @set_new(), !dbg !239
  store i64 %r0, ptr %slot.result, align 8, !dbg !239
  %r1 = load i64, ptr %slot.a, align 8, !dbg !240
  %r2 = add i64 0, 0, !dbg !240
  %r3 = call i64 @nova_rt_index_get(i64 %r1, i64 %r2), !dbg !240
  store i64 %r3, ptr %slot.ai, align 8, !dbg !240
  %r4 = add i64 0, 0, !dbg !241
  store i64 %r4, ptr %slot.i, align 8, !dbg !241
  br label %while_hdr18, !dbg !242
while_hdr18:
  %r5 = load i64, ptr %slot.i, align 8, !dbg !242
  %r6 = load i64, ptr %slot.ai, align 8, !dbg !242
  %r7 = call i64 @nova_rt_len_any(i64 %r6), !dbg !242
  %r8.cmp = icmp slt i64 %r5, %r7, !dbg !242
  %r8 = zext i1 %r8.cmp to i64, !dbg !242
  %br_while_body19 = icmp ne i64 %r8, 0, !dbg !242
  br i1 %br_while_body19, label %while_body19, label %while_exit20, !prof !90, !dbg !242
while_body19:
  %r9 = load i64, ptr %slot.result, align 8, !dbg !243
  %r10 = load i64, ptr %slot.ai, align 8, !dbg !243
  %r11 = load i64, ptr %slot.i, align 8, !dbg !243
  %r12 = call i64 @nova_rt_index_get(i64 %r10, i64 %r11), !dbg !243
  %r13 = call i64 @nova_rt_set_add(i64 %r9, i64 %r12), !dbg !243
  %r14 = load i64, ptr %slot.i, align 8, !dbg !244
  %r15 = add i64 1, 0, !dbg !244
  %r16 = add i64 %r14, %r15, !dbg !244
  store i64 %r16, ptr %slot.i, align 8, !dbg !244
  br label %while_hdr18, !dbg !244
while_exit20:
  %r17 = load i64, ptr %slot.b, align 8, !dbg !245
  %r18 = add i64 0, 0, !dbg !245
  %r19 = call i64 @nova_rt_index_get(i64 %r17, i64 %r18), !dbg !245
  store i64 %r19, ptr %slot.bi, align 8, !dbg !245
  %r20 = add i64 0, 0, !dbg !246
  store i64 %r20, ptr %slot.j, align 8, !dbg !246
  br label %while_hdr21, !dbg !247
while_hdr21:
  %r21 = load i64, ptr %slot.j, align 8, !dbg !247
  %r22 = load i64, ptr %slot.bi, align 8, !dbg !247
  %r23 = call i64 @nova_rt_len_any(i64 %r22), !dbg !247
  %r24.cmp = icmp slt i64 %r21, %r23, !dbg !247
  %r24 = zext i1 %r24.cmp to i64, !dbg !247
  %br_while_body22 = icmp ne i64 %r24, 0, !dbg !247
  br i1 %br_while_body22, label %while_body22, label %while_exit23, !prof !90, !dbg !247
while_body22:
  %r25 = load i64, ptr %slot.result, align 8, !dbg !248
  %r26 = load i64, ptr %slot.bi, align 8, !dbg !248
  %r27 = load i64, ptr %slot.j, align 8, !dbg !248
  %r28 = call i64 @nova_rt_index_get(i64 %r26, i64 %r27), !dbg !248
  %r29 = call i64 @nova_rt_set_add(i64 %r25, i64 %r28), !dbg !248
  %r30 = load i64, ptr %slot.j, align 8, !dbg !249
  %r31 = add i64 1, 0, !dbg !249
  %r32 = add i64 %r30, %r31, !dbg !249
  store i64 %r32, ptr %slot.j, align 8, !dbg !249
  br label %while_hdr21, !dbg !249
while_exit23:
  %r33 = load i64, ptr %slot.result, align 8, !dbg !250
  ret i64 %r33, !dbg !250
}

define i64 @set_intersection(i64 %p0, i64 %p1) nounwind !dbg !251 {
entry:
  %slot.a = alloca i64, align 8, !dbg !252
  store i64 %p0, ptr %slot.a, align 8, !dbg !252
  %slot.b = alloca i64, align 8, !dbg !252
  store i64 %p1, ptr %slot.b, align 8, !dbg !252
  %slot.result = alloca i64, align 8, !dbg !252
  store i64 0, ptr %slot.result, align 8, !dbg !252
  %slot.ai = alloca i64, align 8, !dbg !252
  store i64 0, ptr %slot.ai, align 8, !dbg !252
  %slot.i = alloca i64, align 8, !dbg !252
  store i64 0, ptr %slot.i, align 8, !dbg !252
  %r0 = call i64 @set_new(), !dbg !253
  store i64 %r0, ptr %slot.result, align 8, !dbg !253
  %r1 = load i64, ptr %slot.a, align 8, !dbg !254
  %r2 = add i64 0, 0, !dbg !254
  %r3 = call i64 @nova_rt_index_get(i64 %r1, i64 %r2), !dbg !254
  store i64 %r3, ptr %slot.ai, align 8, !dbg !254
  %r4 = add i64 0, 0, !dbg !255
  store i64 %r4, ptr %slot.i, align 8, !dbg !255
  br label %while_hdr24, !dbg !256
while_hdr24:
  %r5 = load i64, ptr %slot.i, align 8, !dbg !256
  %r6 = load i64, ptr %slot.ai, align 8, !dbg !256
  %r7 = call i64 @nova_rt_len_any(i64 %r6), !dbg !256
  %r8.cmp = icmp slt i64 %r5, %r7, !dbg !256
  %r8 = zext i1 %r8.cmp to i64, !dbg !256
  %br_while_body25 = icmp ne i64 %r8, 0, !dbg !256
  br i1 %br_while_body25, label %while_body25, label %while_exit26, !prof !90, !dbg !256
while_body25:
  %r9 = load i64, ptr %slot.b, align 8, !dbg !257
  %r10 = load i64, ptr %slot.ai, align 8, !dbg !257
  %r11 = load i64, ptr %slot.i, align 8, !dbg !257
  %r12 = call i64 @nova_rt_index_get(i64 %r10, i64 %r11), !dbg !257
  %r13 = call i64 @set_contains(i64 %r9, i64 %r12), !dbg !257
  %br_then27 = icmp ne i64 %r13, 0, !dbg !257
  br i1 %br_then27, label %then27, label %else28, !dbg !257
then27:
  %r14 = load i64, ptr %slot.result, align 8, !dbg !258
  %r15 = load i64, ptr %slot.ai, align 8, !dbg !258
  %r16 = load i64, ptr %slot.i, align 8, !dbg !258
  %r17 = call i64 @nova_rt_index_get(i64 %r15, i64 %r16), !dbg !258
  %r18 = call i64 @nova_rt_set_add(i64 %r14, i64 %r17), !dbg !258
  br label %endif29, !dbg !258
else28:
  br label %endif29, !dbg !258
endif29:
  %r19 = load i64, ptr %slot.i, align 8, !dbg !259
  %r20 = add i64 1, 0, !dbg !259
  %r21 = add i64 %r19, %r20, !dbg !259
  store i64 %r21, ptr %slot.i, align 8, !dbg !259
  br label %while_hdr24, !dbg !259
while_exit26:
  %r22 = load i64, ptr %slot.result, align 8, !dbg !260
  ret i64 %r22, !dbg !260
}

define i64 @set_difference(i64 %p0, i64 %p1) nounwind !dbg !261 {
entry:
  %slot.a = alloca i64, align 8, !dbg !262
  store i64 %p0, ptr %slot.a, align 8, !dbg !262
  %slot.b = alloca i64, align 8, !dbg !262
  store i64 %p1, ptr %slot.b, align 8, !dbg !262
  %slot.result = alloca i64, align 8, !dbg !262
  store i64 0, ptr %slot.result, align 8, !dbg !262
  %slot.ai = alloca i64, align 8, !dbg !262
  store i64 0, ptr %slot.ai, align 8, !dbg !262
  %slot.i = alloca i64, align 8, !dbg !262
  store i64 0, ptr %slot.i, align 8, !dbg !262
  %r0 = call i64 @set_new(), !dbg !263
  store i64 %r0, ptr %slot.result, align 8, !dbg !263
  %r1 = load i64, ptr %slot.a, align 8, !dbg !264
  %r2 = add i64 0, 0, !dbg !264
  %r3 = call i64 @nova_rt_index_get(i64 %r1, i64 %r2), !dbg !264
  store i64 %r3, ptr %slot.ai, align 8, !dbg !264
  %r4 = add i64 0, 0, !dbg !265
  store i64 %r4, ptr %slot.i, align 8, !dbg !265
  br label %while_hdr30, !dbg !266
while_hdr30:
  %r5 = load i64, ptr %slot.i, align 8, !dbg !266
  %r6 = load i64, ptr %slot.ai, align 8, !dbg !266
  %r7 = call i64 @nova_rt_len_any(i64 %r6), !dbg !266
  %r8.cmp = icmp slt i64 %r5, %r7, !dbg !266
  %r8 = zext i1 %r8.cmp to i64, !dbg !266
  %br_while_body31 = icmp ne i64 %r8, 0, !dbg !266
  br i1 %br_while_body31, label %while_body31, label %while_exit32, !prof !90, !dbg !266
while_body31:
  %r9 = load i64, ptr %slot.b, align 8, !dbg !267
  %r10 = load i64, ptr %slot.ai, align 8, !dbg !267
  %r11 = load i64, ptr %slot.i, align 8, !dbg !267
  %r12 = call i64 @nova_rt_index_get(i64 %r10, i64 %r11), !dbg !267
  %r13 = call i64 @set_contains(i64 %r9, i64 %r12), !dbg !267
  %r14 = add i64 0, 0, !dbg !267
  %r15.cmp = icmp eq i64 %r13, %r14, !dbg !267
  %r15 = zext i1 %r15.cmp to i64, !dbg !267
  %br_then33 = icmp ne i64 %r15, 0, !dbg !267
  br i1 %br_then33, label %then33, label %else34, !dbg !267
then33:
  %r16 = load i64, ptr %slot.result, align 8, !dbg !268
  %r17 = load i64, ptr %slot.ai, align 8, !dbg !268
  %r18 = load i64, ptr %slot.i, align 8, !dbg !268
  %r19 = call i64 @nova_rt_index_get(i64 %r17, i64 %r18), !dbg !268
  %r20 = call i64 @nova_rt_set_add(i64 %r16, i64 %r19), !dbg !268
  br label %endif35, !dbg !268
else34:
  br label %endif35, !dbg !268
endif35:
  %r21 = load i64, ptr %slot.i, align 8, !dbg !269
  %r22 = add i64 1, 0, !dbg !269
  %r23 = add i64 %r21, %r22, !dbg !269
  store i64 %r23, ptr %slot.i, align 8, !dbg !269
  br label %while_hdr30, !dbg !269
while_exit32:
  %r24 = load i64, ptr %slot.result, align 8, !dbg !270
  ret i64 %r24, !dbg !270
}

define i64 @set_to_list(i64 %p0) nounwind !dbg !271 {
entry:
  %slot.s = alloca i64, align 8, !dbg !272
  store i64 %p0, ptr %slot.s, align 8, !dbg !272
  %slot.items = alloca i64, align 8, !dbg !272
  store i64 0, ptr %slot.items, align 8, !dbg !272
  %slot.result = alloca i64, align 8, !dbg !272
  store i64 0, ptr %slot.result, align 8, !dbg !272
  %slot.i = alloca i64, align 8, !dbg !272
  store i64 0, ptr %slot.i, align 8, !dbg !272
  %r0 = load i64, ptr %slot.s, align 8, !dbg !273
  %r1 = add i64 0, 0, !dbg !273
  %r2 = call i64 @nova_rt_index_get(i64 %r0, i64 %r1), !dbg !273
  store i64 %r2, ptr %slot.items, align 8, !dbg !273
  %r3 = call i64 @nova_rt_list_create(), !dbg !274
  store i64 %r3, ptr %slot.result, align 8, !dbg !274
  %r4 = add i64 0, 0, !dbg !275
  store i64 %r4, ptr %slot.i, align 8, !dbg !275
  br label %while_hdr36, !dbg !276
while_hdr36:
  %r5 = load i64, ptr %slot.i, align 8, !dbg !276
  %r6 = load i64, ptr %slot.items, align 8, !dbg !276
  %r7 = call i64 @nova_rt_len_any(i64 %r6), !dbg !276
  %r8.cmp = icmp slt i64 %r5, %r7, !dbg !276
  %r8 = zext i1 %r8.cmp to i64, !dbg !276
  %br_while_body37 = icmp ne i64 %r8, 0, !dbg !276
  br i1 %br_while_body37, label %while_body37, label %while_exit38, !prof !90, !dbg !276
while_body37:
  %r9 = load i64, ptr %slot.result, align 8, !dbg !277
  %r10 = load i64, ptr %slot.items, align 8, !dbg !277
  %r11 = load i64, ptr %slot.i, align 8, !dbg !277
  %r12 = call i64 @nova_rt_index_get(i64 %r10, i64 %r11), !dbg !277
  %r13 = call i64 @nova_rt_list_append(i64 %r9, i64 %r12), !dbg !277
  %r14 = load i64, ptr %slot.i, align 8, !dbg !278
  %r15 = add i64 1, 0, !dbg !278
  %r16 = add i64 %r14, %r15, !dbg !278
  store i64 %r16, ptr %slot.i, align 8, !dbg !278
  br label %while_hdr36, !dbg !278
while_exit38:
  %r17 = load i64, ptr %slot.result, align 8, !dbg !279
  ret i64 %r17, !dbg !279
}

define i64 @deque_new() nounwind !dbg !280 {
entry:
  %slot.items = alloca i64, align 8, !dbg !281
  store i64 0, ptr %slot.items, align 8, !dbg !281
  %r0 = call i64 @nova_rt_list_create(), !dbg !282
  store i64 %r0, ptr %slot.items, align 8, !dbg !282
  %r2 = add i64 %r0, 0, !dbg !283
  %r1 = call i64 @nova_rt_list_create(), !dbg !283
  call i64 @nova_rt_list_append(i64 %r1, i64 %r2), !dbg !283
  ret i64 %r1, !dbg !283
}

define i64 @deque_push_back(i64 %p0, i64 %p1) nounwind !dbg !284 {
entry:
  %slot.d = alloca i64, align 8, !dbg !285
  store i64 %p0, ptr %slot.d, align 8, !dbg !285
  %slot.item = alloca i64, align 8, !dbg !285
  store i64 %p1, ptr %slot.item, align 8, !dbg !285
  %slot.items = alloca i64, align 8, !dbg !285
  store i64 0, ptr %slot.items, align 8, !dbg !285
  %r0 = load i64, ptr %slot.d, align 8, !dbg !286
  %r1 = add i64 0, 0, !dbg !286
  %r2 = call i64 @nova_rt_index_get(i64 %r0, i64 %r1), !dbg !286
  store i64 %r2, ptr %slot.items, align 8, !dbg !286
  %r3 = add i64 %r2, 0, !dbg !287
  %r4 = load i64, ptr %slot.item, align 8, !dbg !287
  %r5 = call i64 @nova_rt_list_append(i64 %r3, i64 %r4), !dbg !287
  ret i64 %r5, !dbg !287
}

define i64 @deque_push_front(i64 %p0, i64 %p1) nounwind !dbg !288 {
entry:
  %slot.d = alloca i64, align 8, !dbg !289
  store i64 %p0, ptr %slot.d, align 8, !dbg !289
  %slot.item = alloca i64, align 8, !dbg !289
  store i64 %p1, ptr %slot.item, align 8, !dbg !289
  %slot.items = alloca i64, align 8, !dbg !289
  store i64 0, ptr %slot.items, align 8, !dbg !289
  %slot.i = alloca i64, align 8, !dbg !289
  store i64 0, ptr %slot.i, align 8, !dbg !289
  %r0 = load i64, ptr %slot.d, align 8, !dbg !290
  %r1 = add i64 0, 0, !dbg !290
  %r2 = call i64 @nova_rt_index_get(i64 %r0, i64 %r1), !dbg !290
  store i64 %r2, ptr %slot.items, align 8, !dbg !290
  %r3 = add i64 %r2, 0, !dbg !291
  %r4 = add i64 0, 0, !dbg !291
  %r5 = call i64 @nova_rt_list_append(i64 %r3, i64 %r4), !dbg !291
  %r6 = add i64 %r2, 0, !dbg !292
  %r7 = call i64 @nova_rt_len_any(i64 %r6), !dbg !292
  %r8 = add i64 1, 0, !dbg !292
  %r9 = sub i64 %r7, %r8, !dbg !292
  store i64 %r9, ptr %slot.i, align 8, !dbg !292
  br label %while_hdr39, !dbg !293
while_hdr39:
  %r10 = load i64, ptr %slot.i, align 8, !dbg !293
  %r11 = add i64 0, 0, !dbg !293
  %r12.cmp = icmp sgt i64 %r10, %r11, !dbg !293
  %r12 = zext i1 %r12.cmp to i64, !dbg !293
  %br_while_body40 = icmp ne i64 %r12, 0, !dbg !293
  br i1 %br_while_body40, label %while_body40, label %while_exit41, !prof !90, !dbg !293
while_body40:
  %r13 = load i64, ptr %slot.items, align 8, !dbg !294
  %r14 = load i64, ptr %slot.i, align 8, !dbg !294
  %r15 = add i64 1, 0, !dbg !294
  %r16 = sub i64 %r14, %r15, !dbg !294
  %r17 = call i64 @nova_rt_index_get(i64 %r13, i64 %r16), !dbg !294
  %r18 = load i64, ptr %slot.items, align 8, !dbg !294
  %r19 = load i64, ptr %slot.i, align 8, !dbg !294
  %_is.gv0 = call i64 @nova_rt_index_set(i64 %r18, i64 %r19, i64 %r17), !dbg !294
  %r20 = load i64, ptr %slot.i, align 8, !dbg !295
  %r21 = add i64 1, 0, !dbg !295
  %r22 = sub i64 %r20, %r21, !dbg !295
  store i64 %r22, ptr %slot.i, align 8, !dbg !295
  br label %while_hdr39, !dbg !295
while_exit41:
  %r23 = load i64, ptr %slot.item, align 8, !dbg !296
  %r24 = load i64, ptr %slot.items, align 8, !dbg !296
  %r25 = add i64 0, 0, !dbg !296
  %_is.gv1 = call i64 @nova_rt_index_set(i64 %r24, i64 %r25, i64 %r23), !dbg !296
  ret i64 0, !dbg !296
}

define i64 @deque_pop_back(i64 %p0) nounwind !dbg !297 {
entry:
  %slot.d = alloca i64, align 8, !dbg !298
  store i64 %p0, ptr %slot.d, align 8, !dbg !298
  %slot.items = alloca i64, align 8, !dbg !298
  store i64 0, ptr %slot.items, align 8, !dbg !298
  %slot.n = alloca i64, align 8, !dbg !298
  store i64 0, ptr %slot.n, align 8, !dbg !298
  %slot.val = alloca i64, align 8, !dbg !298
  store i64 0, ptr %slot.val, align 8, !dbg !298
  %r0 = load i64, ptr %slot.d, align 8, !dbg !299
  %r1 = add i64 0, 0, !dbg !299
  %r2 = call i64 @nova_rt_index_get(i64 %r0, i64 %r1), !dbg !299
  store i64 %r2, ptr %slot.items, align 8, !dbg !299
  %r3 = add i64 %r2, 0, !dbg !300
  %r4 = call i64 @nova_rt_len_any(i64 %r3), !dbg !300
  store i64 %r4, ptr %slot.n, align 8, !dbg !300
  %r5 = add i64 %r4, 0, !dbg !301
  %r6 = add i64 0, 0, !dbg !301
  %r7.cmp = icmp eq i64 %r5, %r6, !dbg !301
  %r7 = zext i1 %r7.cmp to i64, !dbg !301
  %br_then42 = icmp ne i64 %r7, 0, !dbg !301
  br i1 %br_then42, label %then42, label %else43, !dbg !301
then42:
  %r8 = add i64 0, 0, !dbg !302
  ret i64 %r8, !dbg !302
else43:
  br label %endif44, !dbg !302
endif44:
  %r9 = load i64, ptr %slot.items, align 8, !dbg !303
  %r10 = load i64, ptr %slot.n, align 8, !dbg !303
  %r11 = add i64 1, 0, !dbg !303
  %r12 = sub i64 %r10, %r11, !dbg !303
  %r13 = call i64 @nova_rt_index_get(i64 %r9, i64 %r12), !dbg !303
  store i64 %r13, ptr %slot.val, align 8, !dbg !303
  %r14 = load i64, ptr %slot.items, align 8, !dbg !304
  %r15 = add i64 0, 0, !dbg !304
  %r16 = load i64, ptr %slot.n, align 8, !dbg !304
  %r17 = add i64 1, 0, !dbg !304
  %r18 = sub i64 %r16, %r17, !dbg !304
  %r19 = call i64 @nova_rt_slice_any(i64 %r14, i64 %r15, i64 %r18), !dbg !304
  %r20 = load i64, ptr %slot.d, align 8, !dbg !304
  %r21 = add i64 0, 0, !dbg !304
  %_is.gv0 = call i64 @nova_rt_index_set(i64 %r20, i64 %r21, i64 %r19), !dbg !304
  %r22 = add i64 %r13, 0, !dbg !305
  ret i64 %r22, !dbg !305
}

define i64 @deque_pop_front(i64 %p0) nounwind !dbg !306 {
entry:
  %slot.d = alloca i64, align 8, !dbg !307
  store i64 %p0, ptr %slot.d, align 8, !dbg !307
  %slot.items = alloca i64, align 8, !dbg !307
  store i64 0, ptr %slot.items, align 8, !dbg !307
  %slot.n = alloca i64, align 8, !dbg !307
  store i64 0, ptr %slot.n, align 8, !dbg !307
  %slot.val = alloca i64, align 8, !dbg !307
  store i64 0, ptr %slot.val, align 8, !dbg !307
  %r0 = load i64, ptr %slot.d, align 8, !dbg !308
  %r1 = add i64 0, 0, !dbg !308
  %r2 = call i64 @nova_rt_index_get(i64 %r0, i64 %r1), !dbg !308
  store i64 %r2, ptr %slot.items, align 8, !dbg !308
  %r3 = add i64 %r2, 0, !dbg !309
  %r4 = call i64 @nova_rt_len_any(i64 %r3), !dbg !309
  store i64 %r4, ptr %slot.n, align 8, !dbg !309
  %r5 = add i64 %r4, 0, !dbg !310
  %r6 = add i64 0, 0, !dbg !310
  %r7.cmp = icmp eq i64 %r5, %r6, !dbg !310
  %r7 = zext i1 %r7.cmp to i64, !dbg !310
  %br_then45 = icmp ne i64 %r7, 0, !dbg !310
  br i1 %br_then45, label %then45, label %else46, !dbg !310
then45:
  %r8 = add i64 0, 0, !dbg !311
  ret i64 %r8, !dbg !311
else46:
  br label %endif47, !dbg !311
endif47:
  %r9 = load i64, ptr %slot.items, align 8, !dbg !312
  %r10 = add i64 0, 0, !dbg !312
  %r11 = call i64 @nova_rt_index_get(i64 %r9, i64 %r10), !dbg !312
  store i64 %r11, ptr %slot.val, align 8, !dbg !312
  %r12 = load i64, ptr %slot.items, align 8, !dbg !313
  %r13 = add i64 1, 0, !dbg !313
  %r14 = load i64, ptr %slot.n, align 8, !dbg !313
  %r15 = call i64 @nova_rt_slice_any(i64 %r12, i64 %r13, i64 %r14), !dbg !313
  %r16 = load i64, ptr %slot.d, align 8, !dbg !313
  %r17 = add i64 0, 0, !dbg !313
  %_is.gv0 = call i64 @nova_rt_index_set(i64 %r16, i64 %r17, i64 %r15), !dbg !313
  %r18 = add i64 %r11, 0, !dbg !314
  ret i64 %r18, !dbg !314
}

define i64 @deque_peek_front(i64 %p0) nounwind !dbg !315 {
entry:
  %slot.d = alloca i64, align 8, !dbg !316
  store i64 %p0, ptr %slot.d, align 8, !dbg !316
  %slot.items = alloca i64, align 8, !dbg !316
  store i64 0, ptr %slot.items, align 8, !dbg !316
  %r0 = load i64, ptr %slot.d, align 8, !dbg !317
  %r1 = add i64 0, 0, !dbg !317
  %r2 = call i64 @nova_rt_index_get(i64 %r0, i64 %r1), !dbg !317
  store i64 %r2, ptr %slot.items, align 8, !dbg !317
  %r3 = add i64 %r2, 0, !dbg !318
  %r4 = call i64 @nova_rt_len_any(i64 %r3), !dbg !318
  %r5 = add i64 0, 0, !dbg !318
  %r6.cmp = icmp eq i64 %r4, %r5, !dbg !318
  %r6 = zext i1 %r6.cmp to i64, !dbg !318
  %br_then48 = icmp ne i64 %r6, 0, !dbg !318
  br i1 %br_then48, label %then48, label %else49, !dbg !318
then48:
  %r7 = add i64 0, 0, !dbg !319
  ret i64 %r7, !dbg !319
else49:
  br label %endif50, !dbg !319
endif50:
  %r8 = load i64, ptr %slot.items, align 8, !dbg !320
  %r9 = add i64 0, 0, !dbg !320
  %r10 = call i64 @nova_rt_index_get(i64 %r8, i64 %r9), !dbg !320
  ret i64 %r10, !dbg !320
}

define i64 @deque_peek_back(i64 %p0) nounwind !dbg !321 {
entry:
  %slot.d = alloca i64, align 8, !dbg !322
  store i64 %p0, ptr %slot.d, align 8, !dbg !322
  %slot.items = alloca i64, align 8, !dbg !322
  store i64 0, ptr %slot.items, align 8, !dbg !322
  %slot.n = alloca i64, align 8, !dbg !322
  store i64 0, ptr %slot.n, align 8, !dbg !322
  %r0 = load i64, ptr %slot.d, align 8, !dbg !323
  %r1 = add i64 0, 0, !dbg !323
  %r2 = call i64 @nova_rt_index_get(i64 %r0, i64 %r1), !dbg !323
  store i64 %r2, ptr %slot.items, align 8, !dbg !323
  %r3 = add i64 %r2, 0, !dbg !324
  %r4 = call i64 @nova_rt_len_any(i64 %r3), !dbg !324
  store i64 %r4, ptr %slot.n, align 8, !dbg !324
  %r5 = add i64 %r4, 0, !dbg !325
  %r6 = add i64 0, 0, !dbg !325
  %r7.cmp = icmp eq i64 %r5, %r6, !dbg !325
  %r7 = zext i1 %r7.cmp to i64, !dbg !325
  %br_then51 = icmp ne i64 %r7, 0, !dbg !325
  br i1 %br_then51, label %then51, label %else52, !dbg !325
then51:
  %r8 = add i64 0, 0, !dbg !326
  ret i64 %r8, !dbg !326
else52:
  br label %endif53, !dbg !326
endif53:
  %r9 = load i64, ptr %slot.items, align 8, !dbg !327
  %r10 = load i64, ptr %slot.n, align 8, !dbg !327
  %r11 = add i64 1, 0, !dbg !327
  %r12 = sub i64 %r10, %r11, !dbg !327
  %r13 = call i64 @nova_rt_index_get(i64 %r9, i64 %r12), !dbg !327
  ret i64 %r13, !dbg !327
}

define i64 @deque_size(i64 %p0) nounwind !dbg !328 {
entry:
  %slot.d = alloca i64, align 8, !dbg !329
  store i64 %p0, ptr %slot.d, align 8, !dbg !329
  %r0 = load i64, ptr %slot.d, align 8, !dbg !330
  %r1 = add i64 0, 0, !dbg !330
  %r2 = call i64 @nova_rt_index_get(i64 %r0, i64 %r1), !dbg !330
  %r3 = call i64 @nova_rt_len_any(i64 %r2), !dbg !330
  ret i64 %r3, !dbg !330
}

define i64 @pq_new() nounwind !dbg !331 {
entry:
  %slot.heap = alloca i64, align 8, !dbg !332
  store i64 0, ptr %slot.heap, align 8, !dbg !332
  %r0 = call i64 @nova_rt_list_create(), !dbg !333
  store i64 %r0, ptr %slot.heap, align 8, !dbg !333
  %r2 = add i64 %r0, 0, !dbg !334
  %r1 = call i64 @nova_rt_list_create(), !dbg !334
  call i64 @nova_rt_list_append(i64 %r1, i64 %r2), !dbg !334
  ret i64 %r1, !dbg !334
}

define i64 @pq_push(i64 %p0, i64 %p1, i64 %p2) nounwind !dbg !335 {
entry:
  %slot.pq = alloca i64, align 8, !dbg !336
  store i64 %p0, ptr %slot.pq, align 8, !dbg !336
  %slot.priority = alloca i64, align 8, !dbg !336
  store i64 %p1, ptr %slot.priority, align 8, !dbg !336
  %slot.value = alloca i64, align 8, !dbg !336
  store i64 %p2, ptr %slot.value, align 8, !dbg !336
  %slot.heap = alloca i64, align 8, !dbg !336
  store i64 0, ptr %slot.heap, align 8, !dbg !336
  %slot.entry = alloca i64, align 8, !dbg !336
  store i64 0, ptr %slot.entry, align 8, !dbg !336
  %r0 = load i64, ptr %slot.pq, align 8, !dbg !337
  %r1 = add i64 0, 0, !dbg !337
  %r2 = call i64 @nova_rt_index_get(i64 %r0, i64 %r1), !dbg !337
  store i64 %r2, ptr %slot.heap, align 8, !dbg !337
  %r4 = load i64, ptr %slot.priority, align 8, !dbg !338
  %r5 = load i64, ptr %slot.value, align 8, !dbg !338
  %r3 = call i64 @nova_rt_list_create(), !dbg !338
  call i64 @nova_rt_list_append(i64 %r3, i64 %r4), !dbg !338
  call i64 @nova_rt_list_append(i64 %r3, i64 %r5), !dbg !338
  store i64 %r3, ptr %slot.entry, align 8, !dbg !338
  %r6 = add i64 %r2, 0, !dbg !339
  %r7 = add i64 %r3, 0, !dbg !339
  %r8 = call i64 @nova_rt_list_append(i64 %r6, i64 %r7), !dbg !339
  %r9 = add i64 %r2, 0, !dbg !340
  %r10 = add i64 %r2, 0, !dbg !340
  %r11 = call i64 @nova_rt_len_any(i64 %r10), !dbg !340
  %r12 = add i64 1, 0, !dbg !340
  %r13 = sub i64 %r11, %r12, !dbg !340
  %r14 = call i64 @_pq_sift_up(i64 %r9, i64 %r13), !dbg !340
  ret i64 %r14, !dbg !340
}

define i64 @pq_pop(i64 %p0) nounwind !dbg !341 {
entry:
  %slot.pq = alloca i64, align 8, !dbg !342
  store i64 %p0, ptr %slot.pq, align 8, !dbg !342
  %slot.heap = alloca i64, align 8, !dbg !342
  store i64 0, ptr %slot.heap, align 8, !dbg !342
  %slot.n = alloca i64, align 8, !dbg !342
  store i64 0, ptr %slot.n, align 8, !dbg !342
  %slot.min_entry = alloca i64, align 8, !dbg !342
  store i64 0, ptr %slot.min_entry, align 8, !dbg !342
  %slot.new_heap = alloca i64, align 8, !dbg !342
  store i64 0, ptr %slot.new_heap, align 8, !dbg !342
  %r0 = load i64, ptr %slot.pq, align 8, !dbg !343
  %r1 = add i64 0, 0, !dbg !343
  %r2 = call i64 @nova_rt_index_get(i64 %r0, i64 %r1), !dbg !343
  store i64 %r2, ptr %slot.heap, align 8, !dbg !343
  %r3 = add i64 %r2, 0, !dbg !344
  %r4 = call i64 @nova_rt_len_any(i64 %r3), !dbg !344
  store i64 %r4, ptr %slot.n, align 8, !dbg !344
  %r5 = add i64 %r4, 0, !dbg !345
  %r6 = add i64 0, 0, !dbg !345
  %r7.cmp = icmp eq i64 %r5, %r6, !dbg !345
  %r7 = zext i1 %r7.cmp to i64, !dbg !345
  %br_then54 = icmp ne i64 %r7, 0, !dbg !345
  br i1 %br_then54, label %then54, label %else55, !dbg !345
then54:
  %r8 = call i64 @nova_rt_list_create(), !dbg !346
  ret i64 %r8, !dbg !346
else55:
  br label %endif56, !dbg !346
endif56:
  %r9 = load i64, ptr %slot.heap, align 8, !dbg !347
  %r10 = add i64 0, 0, !dbg !347
  %r11 = call i64 @nova_rt_index_get(i64 %r9, i64 %r10), !dbg !347
  store i64 %r11, ptr %slot.min_entry, align 8, !dbg !347
  %r12 = load i64, ptr %slot.n, align 8, !dbg !348
  %r13 = add i64 1, 0, !dbg !348
  %r14.cmp = icmp eq i64 %r12, %r13, !dbg !348
  %r14 = zext i1 %r14.cmp to i64, !dbg !348
  %br_then57 = icmp ne i64 %r14, 0, !dbg !348
  br i1 %br_then57, label %then57, label %else58, !dbg !348
then57:
  %r15 = call i64 @nova_rt_list_create(), !dbg !349
  %r16 = load i64, ptr %slot.pq, align 8, !dbg !349
  %r17 = add i64 0, 0, !dbg !349
  %_is.gv0 = call i64 @nova_rt_index_set(i64 %r16, i64 %r17, i64 %r15), !dbg !349
  %r18 = load i64, ptr %slot.min_entry, align 8, !dbg !350
  ret i64 %r18, !dbg !350
else58:
  br label %endif59, !dbg !350
endif59:
  %r19 = load i64, ptr %slot.heap, align 8, !dbg !351
  %r20 = load i64, ptr %slot.n, align 8, !dbg !351
  %r21 = add i64 1, 0, !dbg !351
  %r22 = sub i64 %r20, %r21, !dbg !351
  %r23 = call i64 @nova_rt_index_get(i64 %r19, i64 %r22), !dbg !351
  %r24 = load i64, ptr %slot.heap, align 8, !dbg !351
  %r25 = add i64 0, 0, !dbg !351
  %_is.gv1 = call i64 @nova_rt_index_set(i64 %r24, i64 %r25, i64 %r23), !dbg !351
  %r26 = load i64, ptr %slot.heap, align 8, !dbg !352
  %r27 = add i64 0, 0, !dbg !352
  %r28 = load i64, ptr %slot.n, align 8, !dbg !352
  %r29 = add i64 1, 0, !dbg !352
  %r30 = sub i64 %r28, %r29, !dbg !352
  %r31 = call i64 @nova_rt_slice_any(i64 %r26, i64 %r27, i64 %r30), !dbg !352
  %r32 = load i64, ptr %slot.pq, align 8, !dbg !352
  %r33 = add i64 0, 0, !dbg !352
  %_is.gv2 = call i64 @nova_rt_index_set(i64 %r32, i64 %r33, i64 %r31), !dbg !352
  %r34 = load i64, ptr %slot.pq, align 8, !dbg !353
  %r35 = add i64 0, 0, !dbg !353
  %r36 = call i64 @nova_rt_index_get(i64 %r34, i64 %r35), !dbg !353
  store i64 %r36, ptr %slot.new_heap, align 8, !dbg !353
  %r37 = add i64 %r36, 0, !dbg !354
  %r38 = add i64 0, 0, !dbg !354
  %r39 = call i64 @_pq_sift_down(i64 %r37, i64 %r38), !dbg !354
  %r40 = load i64, ptr %slot.min_entry, align 8, !dbg !355
  ret i64 %r40, !dbg !355
}

define i64 @pq_peek(i64 %p0) nounwind !dbg !356 {
entry:
  %slot.pq = alloca i64, align 8, !dbg !357
  store i64 %p0, ptr %slot.pq, align 8, !dbg !357
  %slot.heap = alloca i64, align 8, !dbg !357
  store i64 0, ptr %slot.heap, align 8, !dbg !357
  %r0 = load i64, ptr %slot.pq, align 8, !dbg !358
  %r1 = add i64 0, 0, !dbg !358
  %r2 = call i64 @nova_rt_index_get(i64 %r0, i64 %r1), !dbg !358
  store i64 %r2, ptr %slot.heap, align 8, !dbg !358
  %r3 = add i64 %r2, 0, !dbg !359
  %r4 = call i64 @nova_rt_len_any(i64 %r3), !dbg !359
  %r5 = add i64 0, 0, !dbg !359
  %r6.cmp = icmp eq i64 %r4, %r5, !dbg !359
  %r6 = zext i1 %r6.cmp to i64, !dbg !359
  %br_then60 = icmp ne i64 %r6, 0, !dbg !359
  br i1 %br_then60, label %then60, label %else61, !dbg !359
then60:
  %r7 = call i64 @nova_rt_list_create(), !dbg !360
  ret i64 %r7, !dbg !360
else61:
  br label %endif62, !dbg !360
endif62:
  %r8 = load i64, ptr %slot.heap, align 8, !dbg !361
  %r9 = add i64 0, 0, !dbg !361
  %r10 = call i64 @nova_rt_index_get(i64 %r8, i64 %r9), !dbg !361
  ret i64 %r10, !dbg !361
}

define i64 @pq_size(i64 %p0) nounwind !dbg !362 {
entry:
  %slot.pq = alloca i64, align 8, !dbg !363
  store i64 %p0, ptr %slot.pq, align 8, !dbg !363
  %r0 = load i64, ptr %slot.pq, align 8, !dbg !364
  %r1 = add i64 0, 0, !dbg !364
  %r2 = call i64 @nova_rt_index_get(i64 %r0, i64 %r1), !dbg !364
  %r3 = call i64 @nova_rt_len_any(i64 %r2), !dbg !364
  ret i64 %r3, !dbg !364
}

define i64 @_pq_sift_up(i64 %p0, i64 %p1) nounwind !dbg !365 {
entry:
  %slot.heap = alloca i64, align 8, !dbg !366
  store i64 %p0, ptr %slot.heap, align 8, !dbg !366
  %slot.i = alloca i64, align 8, !dbg !366
  store i64 %p1, ptr %slot.i, align 8, !dbg !366
  %slot.parent = alloca i64, align 8, !dbg !366
  store i64 0, ptr %slot.parent, align 8, !dbg !366
  br label %while_hdr63, !dbg !367
while_hdr63:
  %r0 = load i64, ptr %slot.i, align 8, !dbg !367
  %r1 = add i64 0, 0, !dbg !367
  %r2.cmp = icmp sgt i64 %r0, %r1, !dbg !367
  %r2 = zext i1 %r2.cmp to i64, !dbg !367
  %br_while_body64 = icmp ne i64 %r2, 0, !dbg !367
  br i1 %br_while_body64, label %while_body64, label %while_exit65, !prof !90, !dbg !367
while_body64:
  %r3 = load i64, ptr %slot.i, align 8, !dbg !368
  %r4 = add i64 1, 0, !dbg !368
  %r5 = sub i64 %r3, %r4, !dbg !368
  %r6 = add i64 2, 0, !dbg !368
  %r7 = sdiv i64 %r5, %r6, !dbg !368
  store i64 %r7, ptr %slot.parent, align 8, !dbg !368
  %r8 = load i64, ptr %slot.heap, align 8, !dbg !369
  %r9 = load i64, ptr %slot.i, align 8, !dbg !369
  %r10 = call i64 @nova_rt_index_get(i64 %r8, i64 %r9), !dbg !369
  %r11 = add i64 0, 0, !dbg !369
  %r12 = call i64 @nova_rt_index_get(i64 %r10, i64 %r11), !dbg !369
  %r13 = load i64, ptr %slot.heap, align 8, !dbg !369
  %r14 = add i64 %r7, 0, !dbg !369
  %r15 = call i64 @nova_rt_index_get(i64 %r13, i64 %r14), !dbg !369
  %r16 = add i64 0, 0, !dbg !369
  %r17 = call i64 @nova_rt_index_get(i64 %r15, i64 %r16), !dbg !369
  %r18.cmp = icmp slt i64 %r12, %r17, !dbg !369
  %r18 = zext i1 %r18.cmp to i64, !dbg !369
  %br_then66 = icmp ne i64 %r18, 0, !dbg !369
  br i1 %br_then66, label %then66, label %else67, !dbg !369
then66:
  %r19 = load i64, ptr %slot.heap, align 8, !dbg !370
  %r20 = load i64, ptr %slot.i, align 8, !dbg !370
  %r21 = load i64, ptr %slot.parent, align 8, !dbg !370
  %r22 = call i64 @_pq_swap(i64 %r19, i64 %r20, i64 %r21), !dbg !370
  %r23 = load i64, ptr %slot.parent, align 8, !dbg !371
  store i64 %r23, ptr %slot.i, align 8, !dbg !371
  br label %endif68, !dbg !371
else67:
  %r24 = add i64 0, 0, !dbg !372
  ret i64 %r24, !dbg !372
endif68:
  br label %while_hdr63, !dbg !372
while_exit65:
  ret i64 0, !dbg !372
}

define i64 @_pq_sift_down(i64 %p0, i64 %p1) nounwind !dbg !373 {
entry:
  %slot.heap = alloca i64, align 8, !dbg !374
  store i64 %p0, ptr %slot.heap, align 8, !dbg !374
  %slot.i = alloca i64, align 8, !dbg !374
  store i64 %p1, ptr %slot.i, align 8, !dbg !374
  %slot.n = alloca i64, align 8, !dbg !374
  store i64 0, ptr %slot.n, align 8, !dbg !374
  %slot.smallest = alloca i64, align 8, !dbg !374
  store i64 0, ptr %slot.smallest, align 8, !dbg !374
  %slot.left = alloca i64, align 8, !dbg !374
  store i64 0, ptr %slot.left, align 8, !dbg !374
  %slot.right = alloca i64, align 8, !dbg !374
  store i64 0, ptr %slot.right, align 8, !dbg !374
  %r0 = load i64, ptr %slot.heap, align 8, !dbg !375
  %r1 = call i64 @nova_rt_len_any(i64 %r0), !dbg !375
  store i64 %r1, ptr %slot.n, align 8, !dbg !375
  br label %while_hdr69, !dbg !376
while_hdr69:
  br label %while_body70, !dbg !376
while_body70:
  %r3 = load i64, ptr %slot.i, align 8, !dbg !377
  store i64 %r3, ptr %slot.smallest, align 8, !dbg !377
  %r4 = add i64 2, 0, !dbg !378
  %r5 = load i64, ptr %slot.i, align 8, !dbg !378
  %r6 = mul i64 %r4, %r5, !dbg !378
  %r7 = add i64 1, 0, !dbg !378
  %r8 = add i64 %r6, %r7, !dbg !378
  store i64 %r8, ptr %slot.left, align 8, !dbg !378
  %r9 = add i64 2, 0, !dbg !379
  %r10 = load i64, ptr %slot.i, align 8, !dbg !379
  %r11 = mul i64 %r9, %r10, !dbg !379
  %r12 = add i64 2, 0, !dbg !379
  %r13 = add i64 %r11, %r12, !dbg !379
  store i64 %r13, ptr %slot.right, align 8, !dbg !379
  %r14 = add i64 %r8, 0, !dbg !380
  %r15 = load i64, ptr %slot.n, align 8, !dbg !380
  %r16.cmp = icmp slt i64 %r14, %r15, !dbg !380
  %r16 = zext i1 %r16.cmp to i64, !dbg !380
  %br_then72 = icmp ne i64 %r16, 0, !dbg !380
  br i1 %br_then72, label %then72, label %else73, !dbg !380
then72:
  %r17 = load i64, ptr %slot.heap, align 8, !dbg !381
  %r18 = load i64, ptr %slot.left, align 8, !dbg !381
  %r19 = call i64 @nova_rt_index_get(i64 %r17, i64 %r18), !dbg !381
  %r20 = add i64 0, 0, !dbg !381
  %r21 = call i64 @nova_rt_index_get(i64 %r19, i64 %r20), !dbg !381
  %r22 = load i64, ptr %slot.heap, align 8, !dbg !381
  %r23 = load i64, ptr %slot.smallest, align 8, !dbg !381
  %r24 = call i64 @nova_rt_index_get(i64 %r22, i64 %r23), !dbg !381
  %r25 = add i64 0, 0, !dbg !381
  %r26 = call i64 @nova_rt_index_get(i64 %r24, i64 %r25), !dbg !381
  %r27.cmp = icmp slt i64 %r21, %r26, !dbg !381
  %r27 = zext i1 %r27.cmp to i64, !dbg !381
  %br_then75 = icmp ne i64 %r27, 0, !dbg !381
  br i1 %br_then75, label %then75, label %else76, !dbg !381
then75:
  %r28 = load i64, ptr %slot.left, align 8, !dbg !382
  store i64 %r28, ptr %slot.smallest, align 8, !dbg !382
  br label %endif77, !dbg !382
else76:
  br label %endif77, !dbg !382
endif77:
  br label %endif74, !dbg !382
else73:
  br label %endif74, !dbg !382
endif74:
  %r29 = load i64, ptr %slot.right, align 8, !dbg !383
  %r30 = load i64, ptr %slot.n, align 8, !dbg !383
  %r31.cmp = icmp slt i64 %r29, %r30, !dbg !383
  %r31 = zext i1 %r31.cmp to i64, !dbg !383
  %br_then78 = icmp ne i64 %r31, 0, !dbg !383
  br i1 %br_then78, label %then78, label %else79, !dbg !383
then78:
  %r32 = load i64, ptr %slot.heap, align 8, !dbg !384
  %r33 = load i64, ptr %slot.right, align 8, !dbg !384
  %r34 = call i64 @nova_rt_index_get(i64 %r32, i64 %r33), !dbg !384
  %r35 = add i64 0, 0, !dbg !384
  %r36 = call i64 @nova_rt_index_get(i64 %r34, i64 %r35), !dbg !384
  %r37 = load i64, ptr %slot.heap, align 8, !dbg !384
  %r38 = load i64, ptr %slot.smallest, align 8, !dbg !384
  %r39 = call i64 @nova_rt_index_get(i64 %r37, i64 %r38), !dbg !384
  %r40 = add i64 0, 0, !dbg !384
  %r41 = call i64 @nova_rt_index_get(i64 %r39, i64 %r40), !dbg !384
  %r42.cmp = icmp slt i64 %r36, %r41, !dbg !384
  %r42 = zext i1 %r42.cmp to i64, !dbg !384
  %br_then81 = icmp ne i64 %r42, 0, !dbg !384
  br i1 %br_then81, label %then81, label %else82, !dbg !384
then81:
  %r43 = load i64, ptr %slot.right, align 8, !dbg !385
  store i64 %r43, ptr %slot.smallest, align 8, !dbg !385
  br label %endif83, !dbg !385
else82:
  br label %endif83, !dbg !385
endif83:
  br label %endif80, !dbg !385
else79:
  br label %endif80, !dbg !385
endif80:
  %r44 = load i64, ptr %slot.smallest, align 8, !dbg !386
  %r45 = load i64, ptr %slot.i, align 8, !dbg !386
  %r46.cmp = icmp eq i64 %r44, %r45, !dbg !386
  %r46 = zext i1 %r46.cmp to i64, !dbg !386
  %br_then84 = icmp ne i64 %r46, 0, !dbg !386
  br i1 %br_then84, label %then84, label %else85, !dbg !386
then84:
  %r47 = add i64 0, 0, !dbg !387
  ret i64 %r47, !dbg !387
else85:
  br label %endif86, !dbg !387
endif86:
  %r48 = load i64, ptr %slot.heap, align 8, !dbg !388
  %r49 = load i64, ptr %slot.i, align 8, !dbg !388
  %r50 = load i64, ptr %slot.smallest, align 8, !dbg !388
  %r51 = call i64 @_pq_swap(i64 %r48, i64 %r49, i64 %r50), !dbg !388
  %r52 = load i64, ptr %slot.smallest, align 8, !dbg !389
  store i64 %r52, ptr %slot.i, align 8, !dbg !389
  br label %while_hdr69, !dbg !389
}

define i64 @_pq_swap(i64 %p0, i64 %p1, i64 %p2) nounwind !dbg !390 {
entry:
  %slot.heap = alloca i64, align 8, !dbg !391
  store i64 %p0, ptr %slot.heap, align 8, !dbg !391
  %slot.i = alloca i64, align 8, !dbg !391
  store i64 %p1, ptr %slot.i, align 8, !dbg !391
  %slot.j = alloca i64, align 8, !dbg !391
  store i64 %p2, ptr %slot.j, align 8, !dbg !391
  %slot.tmp = alloca i64, align 8, !dbg !391
  store i64 0, ptr %slot.tmp, align 8, !dbg !391
  %r0 = load i64, ptr %slot.heap, align 8, !dbg !392
  %r1 = load i64, ptr %slot.i, align 8, !dbg !392
  %r2 = call i64 @nova_rt_index_get(i64 %r0, i64 %r1), !dbg !392
  store i64 %r2, ptr %slot.tmp, align 8, !dbg !392
  %r3 = load i64, ptr %slot.heap, align 8, !dbg !393
  %r4 = load i64, ptr %slot.j, align 8, !dbg !393
  %r5 = call i64 @nova_rt_index_get(i64 %r3, i64 %r4), !dbg !393
  %r6 = load i64, ptr %slot.heap, align 8, !dbg !393
  %r7 = load i64, ptr %slot.i, align 8, !dbg !393
  %_is.gv0 = call i64 @nova_rt_index_set(i64 %r6, i64 %r7, i64 %r5), !dbg !393
  %r8 = add i64 %r2, 0, !dbg !394
  %r9 = load i64, ptr %slot.heap, align 8, !dbg !394
  %r10 = load i64, ptr %slot.j, align 8, !dbg !394
  %_is.gv1 = call i64 @nova_rt_index_set(i64 %r9, i64 %r10, i64 %r8), !dbg !394
  ret i64 0, !dbg !394
}

define i64 @counter_new() nounwind !dbg !395 {
entry:
  %slot.c = alloca i64, align 8, !dbg !396
  store i64 0, ptr %slot.c, align 8, !dbg !396
  %r0 = call i64 @nova_rt_dict_create(), !dbg !397
  store i64 %r0, ptr %slot.c, align 8, !dbg !397
  %r1 = add i64 %r0, 0, !dbg !398
  ret i64 %r1, !dbg !398
}

define i64 @counter_add(i64 %p0, i64 %p1) nounwind !dbg !399 {
entry:
  %slot.c = alloca i64, align 8, !dbg !400
  store i64 %p0, ptr %slot.c, align 8, !dbg !400
  %slot.item = alloca i64, align 8, !dbg !400
  store i64 %p1, ptr %slot.item, align 8, !dbg !400
  %slot.k = alloca i64, align 8, !dbg !400
  store i64 0, ptr %slot.k, align 8, !dbg !400
  %slot.found = alloca i64, align 8, !dbg !400
  store i64 0, ptr %slot.found, align 8, !dbg !400
  %slot.i = alloca i64, align 8, !dbg !400
  store i64 0, ptr %slot.i, align 8, !dbg !400
  %r0 = load i64, ptr %slot.c, align 8, !dbg !401
  %r1 = call i64 @nova_rt_dict_keys(i64 %r0), !dbg !401
  store i64 %r1, ptr %slot.k, align 8, !dbg !401
  %r2 = add i64 0, 0, !dbg !402
  store i64 %r2, ptr %slot.found, align 8, !dbg !402
  %r3 = add i64 0, 0, !dbg !403
  store i64 %r3, ptr %slot.i, align 8, !dbg !403
  br label %while_hdr87, !dbg !404
while_hdr87:
  %r4 = load i64, ptr %slot.i, align 8, !dbg !404
  %r5 = load i64, ptr %slot.k, align 8, !dbg !404
  %r6.lp = inttoptr i64 %r5 to ptr, !dbg !404
  %r6.szp = getelementptr i64, ptr %r6.lp, i64 1, !dbg !404
  %r6 = load i64, ptr %r6.szp, align 8, !tbaa !6, !dbg !404
  %r7.cmp = icmp slt i64 %r4, %r6, !dbg !404
  %r7 = zext i1 %r7.cmp to i64, !dbg !404
  %br_while_body88 = icmp ne i64 %r7, 0, !dbg !404
  br i1 %br_while_body88, label %while_body88, label %while_exit89, !prof !90, !dbg !404
while_body88:
  %r8 = load i64, ptr %slot.k, align 8, !dbg !405
  %r9 = load i64, ptr %slot.i, align 8, !dbg !405
  %r10 = call i64 @nova_rt_index_get(i64 %r8, i64 %r9), !dbg !405
  %r11 = load i64, ptr %slot.item, align 8, !dbg !405
  %r12 = call i64 @nova_rt_eq(i64 %r10, i64 %r11), !dbg !405
  %br_then90 = icmp ne i64 %r12, 0, !dbg !405
  br i1 %br_then90, label %then90, label %else91, !dbg !405
then90:
  %r13 = add i64 1, 0, !dbg !406
  store i64 %r13, ptr %slot.found, align 8, !dbg !406
  br label %endif92, !dbg !406
else91:
  br label %endif92, !dbg !406
endif92:
  %r14 = load i64, ptr %slot.i, align 8, !dbg !407
  %r15 = add i64 1, 0, !dbg !407
  %r16 = add i64 %r14, %r15, !dbg !407
  store i64 %r16, ptr %slot.i, align 8, !dbg !407
  br label %while_hdr87, !dbg !407
while_exit89:
  %r17 = load i64, ptr %slot.found, align 8, !dbg !408
  %br_retthen93 = icmp ne i64 %r17, 0, !dbg !408
  br i1 %br_retthen93, label %retthen93, label %retelse94, !dbg !408
retthen93:
  %r18 = load i64, ptr %slot.c, align 8, !dbg !409
  %r19 = load i64, ptr %slot.item, align 8, !dbg !409
  %r20 = call i64 @nova_rt_index_get(i64 %r18, i64 %r19), !dbg !409
  %r21 = add i64 1, 0, !dbg !409
  %r22 = call i64 @nova_rt_add(i64 %r20, i64 %r21), !dbg !409
  %r23 = load i64, ptr %slot.c, align 8, !dbg !409
  %r24 = load i64, ptr %slot.item, align 8, !dbg !409
  %_is.gv0 = call i64 @nova_rt_index_set(i64 %r23, i64 %r24, i64 %r22), !dbg !409
  ret i64 0, !dbg !409
retelse94:
  %r25 = add i64 1, 0, !dbg !410
  %r26 = load i64, ptr %slot.c, align 8, !dbg !410
  %r27 = load i64, ptr %slot.item, align 8, !dbg !410
  %_is.gv1 = call i64 @nova_rt_index_set(i64 %r26, i64 %r27, i64 %r25), !dbg !410
  ret i64 0, !dbg !410
}

define i64 @counter_add_n(i64 %p0, i64 %p1, i64 %p2) nounwind !dbg !411 {
entry:
  %slot.c = alloca i64, align 8, !dbg !412
  store i64 %p0, ptr %slot.c, align 8, !dbg !412
  %slot.item = alloca i64, align 8, !dbg !412
  store i64 %p1, ptr %slot.item, align 8, !dbg !412
  %slot.n = alloca i64, align 8, !dbg !412
  store i64 %p2, ptr %slot.n, align 8, !dbg !412
  %slot.k = alloca i64, align 8, !dbg !412
  store i64 0, ptr %slot.k, align 8, !dbg !412
  %slot.found = alloca i64, align 8, !dbg !412
  store i64 0, ptr %slot.found, align 8, !dbg !412
  %slot.i = alloca i64, align 8, !dbg !412
  store i64 0, ptr %slot.i, align 8, !dbg !412
  %r0 = load i64, ptr %slot.c, align 8, !dbg !413
  %r1 = call i64 @nova_rt_dict_keys(i64 %r0), !dbg !413
  store i64 %r1, ptr %slot.k, align 8, !dbg !413
  %r2 = add i64 0, 0, !dbg !414
  store i64 %r2, ptr %slot.found, align 8, !dbg !414
  %r3 = add i64 0, 0, !dbg !415
  store i64 %r3, ptr %slot.i, align 8, !dbg !415
  br label %while_hdr95, !dbg !416
while_hdr95:
  %r4 = load i64, ptr %slot.i, align 8, !dbg !416
  %r5 = load i64, ptr %slot.k, align 8, !dbg !416
  %r6.lp = inttoptr i64 %r5 to ptr, !dbg !416
  %r6.szp = getelementptr i64, ptr %r6.lp, i64 1, !dbg !416
  %r6 = load i64, ptr %r6.szp, align 8, !tbaa !6, !dbg !416
  %r7.cmp = icmp slt i64 %r4, %r6, !dbg !416
  %r7 = zext i1 %r7.cmp to i64, !dbg !416
  %br_while_body96 = icmp ne i64 %r7, 0, !dbg !416
  br i1 %br_while_body96, label %while_body96, label %while_exit97, !prof !90, !dbg !416
while_body96:
  %r8 = load i64, ptr %slot.k, align 8, !dbg !417
  %r9 = load i64, ptr %slot.i, align 8, !dbg !417
  %r10 = call i64 @nova_rt_index_get(i64 %r8, i64 %r9), !dbg !417
  %r11 = load i64, ptr %slot.item, align 8, !dbg !417
  %r12 = call i64 @nova_rt_eq(i64 %r10, i64 %r11), !dbg !417
  %br_then98 = icmp ne i64 %r12, 0, !dbg !417
  br i1 %br_then98, label %then98, label %else99, !dbg !417
then98:
  %r13 = add i64 1, 0, !dbg !418
  store i64 %r13, ptr %slot.found, align 8, !dbg !418
  br label %endif100, !dbg !418
else99:
  br label %endif100, !dbg !418
endif100:
  %r14 = load i64, ptr %slot.i, align 8, !dbg !419
  %r15 = add i64 1, 0, !dbg !419
  %r16 = add i64 %r14, %r15, !dbg !419
  store i64 %r16, ptr %slot.i, align 8, !dbg !419
  br label %while_hdr95, !dbg !419
while_exit97:
  %r17 = load i64, ptr %slot.found, align 8, !dbg !420
  %br_retthen101 = icmp ne i64 %r17, 0, !dbg !420
  br i1 %br_retthen101, label %retthen101, label %retelse102, !dbg !420
retthen101:
  %r18 = load i64, ptr %slot.c, align 8, !dbg !421
  %r19 = load i64, ptr %slot.item, align 8, !dbg !421
  %r20 = call i64 @nova_rt_index_get(i64 %r18, i64 %r19), !dbg !421
  %r21 = load i64, ptr %slot.n, align 8, !dbg !421
  %r22 = call i64 @nova_rt_add(i64 %r20, i64 %r21), !dbg !421
  %r23 = load i64, ptr %slot.c, align 8, !dbg !421
  %r24 = load i64, ptr %slot.item, align 8, !dbg !421
  %_is.gv0 = call i64 @nova_rt_index_set(i64 %r23, i64 %r24, i64 %r22), !dbg !421
  ret i64 0, !dbg !421
retelse102:
  %r25 = load i64, ptr %slot.n, align 8, !dbg !422
  %r26 = load i64, ptr %slot.c, align 8, !dbg !422
  %r27 = load i64, ptr %slot.item, align 8, !dbg !422
  %_is.gv1 = call i64 @nova_rt_index_set(i64 %r26, i64 %r27, i64 %r25), !dbg !422
  ret i64 0, !dbg !422
}

define i64 @counter_count(i64 %p0, i64 %p1) nounwind !dbg !423 {
entry:
  %slot.c = alloca i64, align 8, !dbg !424
  store i64 %p0, ptr %slot.c, align 8, !dbg !424
  %slot.item = alloca i64, align 8, !dbg !424
  store i64 %p1, ptr %slot.item, align 8, !dbg !424
  %slot.k = alloca i64, align 8, !dbg !424
  store i64 0, ptr %slot.k, align 8, !dbg !424
  %slot.i = alloca i64, align 8, !dbg !424
  store i64 0, ptr %slot.i, align 8, !dbg !424
  %r0 = load i64, ptr %slot.c, align 8, !dbg !425
  %r1 = call i64 @nova_rt_dict_keys(i64 %r0), !dbg !425
  store i64 %r1, ptr %slot.k, align 8, !dbg !425
  %r2 = add i64 0, 0, !dbg !426
  store i64 %r2, ptr %slot.i, align 8, !dbg !426
  br label %while_hdr103, !dbg !427
while_hdr103:
  %r3 = load i64, ptr %slot.i, align 8, !dbg !427
  %r4 = load i64, ptr %slot.k, align 8, !dbg !427
  %r5.lp = inttoptr i64 %r4 to ptr, !dbg !427
  %r5.szp = getelementptr i64, ptr %r5.lp, i64 1, !dbg !427
  %r5 = load i64, ptr %r5.szp, align 8, !tbaa !6, !dbg !427
  %r6.cmp = icmp slt i64 %r3, %r5, !dbg !427
  %r6 = zext i1 %r6.cmp to i64, !dbg !427
  %br_while_body104 = icmp ne i64 %r6, 0, !dbg !427
  br i1 %br_while_body104, label %while_body104, label %while_exit105, !prof !90, !dbg !427
while_body104:
  %r7 = load i64, ptr %slot.k, align 8, !dbg !428
  %r8 = load i64, ptr %slot.i, align 8, !dbg !428
  %r9 = call i64 @nova_rt_index_get(i64 %r7, i64 %r8), !dbg !428
  %r10 = load i64, ptr %slot.item, align 8, !dbg !428
  %r11 = call i64 @nova_rt_eq(i64 %r9, i64 %r10), !dbg !428
  %br_then106 = icmp ne i64 %r11, 0, !dbg !428
  br i1 %br_then106, label %then106, label %else107, !dbg !428
then106:
  %r12 = load i64, ptr %slot.c, align 8, !dbg !429
  %r13 = load i64, ptr %slot.item, align 8, !dbg !429
  %r14 = call i64 @nova_rt_index_get(i64 %r12, i64 %r13), !dbg !429
  ret i64 %r14, !dbg !429
else107:
  br label %endif108, !dbg !429
endif108:
  %r15 = load i64, ptr %slot.i, align 8, !dbg !430
  %r16 = add i64 1, 0, !dbg !430
  %r17 = add i64 %r15, %r16, !dbg !430
  store i64 %r17, ptr %slot.i, align 8, !dbg !430
  br label %while_hdr103, !dbg !430
while_exit105:
  %r18 = add i64 0, 0, !dbg !431
  ret i64 %r18, !dbg !431
}

define i64 @counter_total(i64 %p0) nounwind !dbg !432 {
entry:
  %slot.c = alloca i64, align 8, !dbg !433
  store i64 %p0, ptr %slot.c, align 8, !dbg !433
  %slot.total = alloca i64, align 8, !dbg !433
  store i64 0, ptr %slot.total, align 8, !dbg !433
  %slot.__for_idx_109 = alloca i64, align 8, !dbg !433
  store i64 0, ptr %slot.__for_idx_109, align 8, !dbg !433
  %slot.k = alloca i64, align 8, !dbg !433
  store i64 0, ptr %slot.k, align 8, !dbg !433
  %r0 = add i64 0, 0, !dbg !434
  store i64 %r0, ptr %slot.total, align 8, !dbg !434
  %r1 = load i64, ptr %slot.c, align 8, !dbg !435
  %r2 = call i64 @nova_rt_dict_keys(i64 %r1), !dbg !435
  %r3 = add i64 %r2, 0, !dbg !435
  %r4.lp = inttoptr i64 %r3 to ptr, !dbg !435
  %r4.szp = getelementptr i64, ptr %r4.lp, i64 1, !dbg !435
  %r4 = load i64, ptr %r4.szp, align 8, !tbaa !6, !dbg !435
  %r5 = add i64 0, 0, !dbg !435
  store i64 %r5, ptr %slot.__for_idx_109, align 8, !dbg !435
  br label %for_hdr109, !dbg !435
for_hdr109:
  %r6 = load i64, ptr %slot.__for_idx_109, align 8, !dbg !435
  %r7.cmp = icmp slt i64 %r6, %r4, !dbg !435
  %r7 = zext i1 %r7.cmp to i64, !dbg !435
  %br_for_body110 = icmp ne i64 %r7, 0, !dbg !435
  br i1 %br_for_body110, label %for_body110, label %for_exit111, !prof !90, !dbg !435
for_body110:
  %r8 = call i64 @nova_rt_index_get(i64 %r3, i64 %r6), !dbg !435
  store i64 %r8, ptr %slot.k, align 8, !dbg !435
  %r9 = load i64, ptr %slot.total, align 8, !dbg !436
  %r10 = load i64, ptr %slot.c, align 8, !dbg !436
  %r11 = add i64 %r8, 0, !dbg !436
  %r12 = call i64 @nova_rt_index_get(i64 %r10, i64 %r11), !dbg !436
  %r13 = call i64 @nova_rt_add(i64 %r9, i64 %r12), !dbg !436
  store i64 %r13, ptr %slot.total, align 8, !dbg !436
  %r14 = load i64, ptr %slot.__for_idx_109, align 8, !dbg !436
  %r15 = add i64 1, 0, !dbg !436
  %r16 = add i64 %r14, %r15, !dbg !436
  store i64 %r16, ptr %slot.__for_idx_109, align 8, !dbg !436
  br label %for_hdr109, !dbg !436
for_exit111:
  %r17 = load i64, ptr %slot.total, align 8, !dbg !437
  ret i64 %r17, !dbg !437
}

define i64 @counter_most_common(i64 %p0, i64 %p1) nounwind !dbg !438 {
entry:
  %slot.c = alloca i64, align 8, !dbg !439
  store i64 %p0, ptr %slot.c, align 8, !dbg !439
  %slot.n = alloca i64, align 8, !dbg !439
  store i64 %p1, ptr %slot.n, align 8, !dbg !439
  %slot.pairs = alloca i64, align 8, !dbg !439
  store i64 0, ptr %slot.pairs, align 8, !dbg !439
  %slot.__for_idx_112 = alloca i64, align 8, !dbg !439
  store i64 0, ptr %slot.__for_idx_112, align 8, !dbg !439
  %slot.k = alloca i64, align 8, !dbg !439
  store i64 0, ptr %slot.k, align 8, !dbg !439
  %slot.num_pairs = alloca i64, align 8, !dbg !439
  store i64 0, ptr %slot.num_pairs, align 8, !dbg !439
  %slot.outer = alloca i64, align 8, !dbg !439
  store i64 0, ptr %slot.outer, align 8, !dbg !439
  %slot.inner = alloca i64, align 8, !dbg !439
  store i64 0, ptr %slot.inner, align 8, !dbg !439
  %slot.tmp = alloca i64, align 8, !dbg !439
  store i64 0, ptr %slot.tmp, align 8, !dbg !439
  %slot.result = alloca i64, align 8, !dbg !439
  store i64 0, ptr %slot.result, align 8, !dbg !439
  %slot.limit = alloca i64, align 8, !dbg !439
  store i64 0, ptr %slot.limit, align 8, !dbg !439
  %slot.i = alloca i64, align 8, !dbg !439
  store i64 0, ptr %slot.i, align 8, !dbg !439
  %r0 = call i64 @nova_rt_list_create(), !dbg !440
  store i64 %r0, ptr %slot.pairs, align 8, !dbg !440
  %r1 = load i64, ptr %slot.c, align 8, !dbg !441
  %r2 = call i64 @nova_rt_dict_keys(i64 %r1), !dbg !441
  %r3 = add i64 %r2, 0, !dbg !441
  %r4.lp = inttoptr i64 %r3 to ptr, !dbg !441
  %r4.szp = getelementptr i64, ptr %r4.lp, i64 1, !dbg !441
  %r4 = load i64, ptr %r4.szp, align 8, !tbaa !6, !dbg !441
  %r5 = add i64 0, 0, !dbg !441
  store i64 %r5, ptr %slot.__for_idx_112, align 8, !dbg !441
  br label %for_hdr112, !dbg !441
for_hdr112:
  %r6 = load i64, ptr %slot.__for_idx_112, align 8, !dbg !441
  %r7.cmp = icmp slt i64 %r6, %r4, !dbg !441
  %r7 = zext i1 %r7.cmp to i64, !dbg !441
  %br_for_body113 = icmp ne i64 %r7, 0, !dbg !441
  br i1 %br_for_body113, label %for_body113, label %for_exit114, !prof !90, !dbg !441
for_body113:
  %r8 = call i64 @nova_rt_index_get(i64 %r3, i64 %r6), !dbg !441
  store i64 %r8, ptr %slot.k, align 8, !dbg !441
  %r9 = load i64, ptr %slot.pairs, align 8, !dbg !442
  %r11 = add i64 %r8, 0, !dbg !442
  %r12 = load i64, ptr %slot.c, align 8, !dbg !442
  %r13 = add i64 %r8, 0, !dbg !442
  %r14 = call i64 @nova_rt_index_get(i64 %r12, i64 %r13), !dbg !442
  %r10 = call i64 @nova_rt_list_create(), !dbg !442
  call i64 @nova_rt_list_append(i64 %r10, i64 %r11), !dbg !442
  call i64 @nova_rt_list_append(i64 %r10, i64 %r14), !dbg !442
  %r15 = call i64 @nova_rt_list_append(i64 %r9, i64 %r10), !dbg !442
  %r16 = load i64, ptr %slot.__for_idx_112, align 8, !dbg !442
  %r17 = add i64 1, 0, !dbg !442
  %r18 = add i64 %r16, %r17, !dbg !442
  store i64 %r18, ptr %slot.__for_idx_112, align 8, !dbg !442
  br label %for_hdr112, !dbg !442
for_exit114:
  %r19 = load i64, ptr %slot.pairs, align 8, !dbg !443
  %r20.lp = inttoptr i64 %r19 to ptr, !dbg !443
  %r20.szp = getelementptr i64, ptr %r20.lp, i64 1, !dbg !443
  %r20 = load i64, ptr %r20.szp, align 8, !tbaa !6, !dbg !443
  store i64 %r20, ptr %slot.num_pairs, align 8, !dbg !443
  %r21 = add i64 0, 0, !dbg !444
  store i64 %r21, ptr %slot.outer, align 8, !dbg !444
  br label %while_hdr115, !dbg !445
while_hdr115:
  %r22 = load i64, ptr %slot.outer, align 8, !dbg !445
  %r23 = load i64, ptr %slot.num_pairs, align 8, !dbg !445
  %r24.cmp = icmp slt i64 %r22, %r23, !dbg !445
  %r24 = zext i1 %r24.cmp to i64, !dbg !445
  %br_while_body116 = icmp ne i64 %r24, 0, !dbg !445
  br i1 %br_while_body116, label %while_body116, label %while_exit117, !prof !90, !dbg !445
while_body116:
  %r25 = add i64 0, 0, !dbg !446
  store i64 %r25, ptr %slot.inner, align 8, !dbg !446
  br label %while_hdr118, !dbg !447
while_hdr118:
  %r26 = load i64, ptr %slot.inner, align 8, !dbg !447
  %r27 = load i64, ptr %slot.num_pairs, align 8, !dbg !447
  %r28 = add i64 1, 0, !dbg !447
  %r29 = sub i64 %r27, %r28, !dbg !447
  %r30.cmp = icmp slt i64 %r26, %r29, !dbg !447
  %r30 = zext i1 %r30.cmp to i64, !dbg !447
  %br_while_body119 = icmp ne i64 %r30, 0, !dbg !447
  br i1 %br_while_body119, label %while_body119, label %while_exit120, !prof !90, !dbg !447
while_body119:
  %r31 = load i64, ptr %slot.pairs, align 8, !dbg !448
  %r32 = load i64, ptr %slot.inner, align 8, !dbg !448
  %r33.lp = inttoptr i64 %r31 to ptr, !dbg !448
  %r33.dp = load ptr, ptr %r33.lp, align 8, !tbaa !2, !dbg !448
  %r33.ep = getelementptr i64, ptr %r33.dp, i64 %r32, !dbg !448
  %r33 = load i64, ptr %r33.ep, align 8, !tbaa !4, !dbg !448
  %r34 = add i64 1, 0, !dbg !448
  %r35 = call i64 @nova_rt_index_get(i64 %r33, i64 %r34), !dbg !448
  %r36 = load i64, ptr %slot.pairs, align 8, !dbg !448
  %r37 = load i64, ptr %slot.inner, align 8, !dbg !448
  %r38 = add i64 1, 0, !dbg !448
  %r39 = add i64 %r37, %r38, !dbg !448
  %r40.lp = inttoptr i64 %r36 to ptr, !dbg !448
  %r40.dp = load ptr, ptr %r40.lp, align 8, !tbaa !2, !dbg !448
  %r40.ep = getelementptr i64, ptr %r40.dp, i64 %r39, !dbg !448
  %r40 = load i64, ptr %r40.ep, align 8, !tbaa !4, !dbg !448
  %r41 = add i64 1, 0, !dbg !448
  %r42 = call i64 @nova_rt_index_get(i64 %r40, i64 %r41), !dbg !448
  %r43.cmp = icmp slt i64 %r35, %r42, !dbg !448
  %r43 = zext i1 %r43.cmp to i64, !dbg !448
  %br_then121 = icmp ne i64 %r43, 0, !dbg !448
  br i1 %br_then121, label %then121, label %else122, !dbg !448
then121:
  %r44 = load i64, ptr %slot.pairs, align 8, !dbg !449
  %r45 = load i64, ptr %slot.inner, align 8, !dbg !449
  %r46.lp = inttoptr i64 %r44 to ptr, !dbg !449
  %r46.dp = load ptr, ptr %r46.lp, align 8, !tbaa !2, !dbg !449
  %r46.ep = getelementptr i64, ptr %r46.dp, i64 %r45, !dbg !449
  %r46 = load i64, ptr %r46.ep, align 8, !tbaa !4, !dbg !449
  store i64 %r46, ptr %slot.tmp, align 8, !dbg !449
  %r47 = load i64, ptr %slot.pairs, align 8, !dbg !450
  %r48 = load i64, ptr %slot.inner, align 8, !dbg !450
  %r49 = add i64 1, 0, !dbg !450
  %r50 = add i64 %r48, %r49, !dbg !450
  %r51.lp = inttoptr i64 %r47 to ptr, !dbg !450
  %r51.dp = load ptr, ptr %r51.lp, align 8, !tbaa !2, !dbg !450
  %r51.ep = getelementptr i64, ptr %r51.dp, i64 %r50, !dbg !450
  %r51 = load i64, ptr %r51.ep, align 8, !tbaa !4, !dbg !450
  %r52 = load i64, ptr %slot.pairs, align 8, !dbg !450
  %r53 = load i64, ptr %slot.inner, align 8, !dbg !450
  %_is.lp0 = inttoptr i64 %r52 to ptr, !dbg !450
  %_is.dp1 = load ptr, ptr %_is.lp0, align 8, !tbaa !2, !dbg !450
  %_is.ep2 = getelementptr i64, ptr %_is.dp1, i64 %r53, !dbg !450
  store i64 %r51, ptr %_is.ep2, align 8, !tbaa !4, !dbg !450
  %r54 = add i64 %r46, 0, !dbg !451
  %r55 = load i64, ptr %slot.pairs, align 8, !dbg !451
  %r56 = load i64, ptr %slot.inner, align 8, !dbg !451
  %r57 = add i64 1, 0, !dbg !451
  %r58 = add i64 %r56, %r57, !dbg !451
  %_is.lp3 = inttoptr i64 %r55 to ptr, !dbg !451
  %_is.dp4 = load ptr, ptr %_is.lp3, align 8, !tbaa !2, !dbg !451
  %_is.ep5 = getelementptr i64, ptr %_is.dp4, i64 %r58, !dbg !451
  store i64 %r54, ptr %_is.ep5, align 8, !tbaa !4, !dbg !451
  br label %endif123, !dbg !451
else122:
  br label %endif123, !dbg !451
endif123:
  %r59 = load i64, ptr %slot.inner, align 8, !dbg !452
  %r60 = add i64 1, 0, !dbg !452
  %r61 = add i64 %r59, %r60, !dbg !452
  store i64 %r61, ptr %slot.inner, align 8, !dbg !452
  br label %while_hdr118, !dbg !452
while_exit120:
  %r62 = load i64, ptr %slot.outer, align 8, !dbg !453
  %r63 = add i64 1, 0, !dbg !453
  %r64 = add i64 %r62, %r63, !dbg !453
  store i64 %r64, ptr %slot.outer, align 8, !dbg !453
  br label %while_hdr115, !dbg !453
while_exit117:
  %r65 = call i64 @nova_rt_list_create(), !dbg !454
  store i64 %r65, ptr %slot.result, align 8, !dbg !454
  %r66 = load i64, ptr %slot.n, align 8, !dbg !455
  store i64 %r66, ptr %slot.limit, align 8, !dbg !455
  %r67 = add i64 %r66, 0, !dbg !456
  %r68 = load i64, ptr %slot.num_pairs, align 8, !dbg !456
  %r69.cmp = icmp sgt i64 %r67, %r68, !dbg !456
  %r69 = zext i1 %r69.cmp to i64, !dbg !456
  %br_then124 = icmp ne i64 %r69, 0, !dbg !456
  br i1 %br_then124, label %then124, label %else125, !dbg !456
then124:
  %r70 = load i64, ptr %slot.num_pairs, align 8, !dbg !457
  store i64 %r70, ptr %slot.limit, align 8, !dbg !457
  br label %endif126, !dbg !457
else125:
  br label %endif126, !dbg !457
endif126:
  %r71 = add i64 0, 0, !dbg !458
  store i64 %r71, ptr %slot.i, align 8, !dbg !458
  br label %while_hdr127, !dbg !459
while_hdr127:
  %r72 = load i64, ptr %slot.i, align 8, !dbg !459
  %r73 = load i64, ptr %slot.limit, align 8, !dbg !459
  %r74.cmp = icmp slt i64 %r72, %r73, !dbg !459
  %r74 = zext i1 %r74.cmp to i64, !dbg !459
  %br_while_body128 = icmp ne i64 %r74, 0, !dbg !459
  br i1 %br_while_body128, label %while_body128, label %while_exit129, !prof !90, !dbg !459
while_body128:
  %r75 = load i64, ptr %slot.result, align 8, !dbg !460
  %r76 = load i64, ptr %slot.pairs, align 8, !dbg !460
  %r77 = load i64, ptr %slot.i, align 8, !dbg !460
  %r78.lp = inttoptr i64 %r76 to ptr, !dbg !460
  %r78.dp = load ptr, ptr %r78.lp, align 8, !tbaa !2, !dbg !460
  %r78.ep = getelementptr i64, ptr %r78.dp, i64 %r77, !dbg !460
  %r78 = load i64, ptr %r78.ep, align 8, !tbaa !4, !dbg !460
  %r79 = call i64 @nova_rt_list_append(i64 %r75, i64 %r78), !dbg !460
  %r80 = load i64, ptr %slot.i, align 8, !dbg !461
  %r81 = add i64 1, 0, !dbg !461
  %r82 = add i64 %r80, %r81, !dbg !461
  store i64 %r82, ptr %slot.i, align 8, !dbg !461
  br label %while_hdr127, !dbg !461
while_exit129:
  %r83 = load i64, ptr %slot.result, align 8, !dbg !462
  ret i64 %r83, !dbg !462
}

define i64 @lru_new(i64 %p0) nounwind !dbg !463 {
entry:
  %slot.capacity = alloca i64, align 8, !dbg !464
  store i64 %p0, ptr %slot.capacity, align 8, !dbg !464
  %slot.data = alloca i64, align 8, !dbg !464
  store i64 0, ptr %slot.data, align 8, !dbg !464
  %slot.order = alloca i64, align 8, !dbg !464
  store i64 0, ptr %slot.order, align 8, !dbg !464
  %r0 = call i64 @nova_rt_dict_create(), !dbg !465
  store i64 %r0, ptr %slot.data, align 8, !dbg !465
  %r1 = call i64 @nova_rt_list_create(), !dbg !466
  store i64 %r1, ptr %slot.order, align 8, !dbg !466
  %r3 = add i64 %r0, 0, !dbg !467
  %r4 = add i64 %r1, 0, !dbg !467
  %r5 = load i64, ptr %slot.capacity, align 8, !dbg !467
  %r2 = call i64 @nova_rt_list_create(), !dbg !467
  call i64 @nova_rt_list_append(i64 %r2, i64 %r3), !dbg !467
  call i64 @nova_rt_list_append(i64 %r2, i64 %r4), !dbg !467
  call i64 @nova_rt_list_append(i64 %r2, i64 %r5), !dbg !467
  ret i64 %r2, !dbg !467
}

define i64 @lru_get(i64 %p0, i64 %p1) nounwind !dbg !468 {
entry:
  %slot.cache = alloca i64, align 8, !dbg !469
  store i64 %p0, ptr %slot.cache, align 8, !dbg !469
  %slot.key = alloca i64, align 8, !dbg !469
  store i64 %p1, ptr %slot.key, align 8, !dbg !469
  %slot.data = alloca i64, align 8, !dbg !469
  store i64 0, ptr %slot.data, align 8, !dbg !469
  %slot.idx = alloca i64, align 8, !dbg !469
  store i64 0, ptr %slot.idx, align 8, !dbg !469
  %r0 = load i64, ptr %slot.cache, align 8, !dbg !470
  %r1 = add i64 0, 0, !dbg !470
  %r2 = call i64 @nova_rt_index_get(i64 %r0, i64 %r1), !dbg !470
  store i64 %r2, ptr %slot.data, align 8, !dbg !470
  %r3 = load i64, ptr %slot.cache, align 8, !dbg !471
  %r4 = add i64 1, 0, !dbg !471
  %r5 = call i64 @nova_rt_index_get(i64 %r3, i64 %r4), !dbg !471
  %r6 = load i64, ptr %slot.key, align 8, !dbg !471
  %r7 = call i64 @_lru_find_index(i64 %r5, i64 %r6), !dbg !471
  store i64 %r7, ptr %slot.idx, align 8, !dbg !471
  %r8 = add i64 %r7, 0, !dbg !472
  %r9 = add i64 0, 0, !dbg !472
  %r10.cmp = icmp slt i64 %r8, %r9, !dbg !472
  %r10 = zext i1 %r10.cmp to i64, !dbg !472
  %br_then130 = icmp ne i64 %r10, 0, !dbg !472
  br i1 %br_then130, label %then130, label %else131, !dbg !472
then130:
  %r11 = add i64 0, 0, !dbg !473
  ret i64 %r11, !dbg !473
else131:
  br label %endif132, !dbg !473
endif132:
  %r12 = load i64, ptr %slot.cache, align 8, !dbg !474
  %r13 = load i64, ptr %slot.key, align 8, !dbg !474
  %r14 = call i64 @_lru_move_to_end(i64 %r12, i64 %r13), !dbg !474
  %r15 = load i64, ptr %slot.data, align 8, !dbg !475
  %r16 = load i64, ptr %slot.key, align 8, !dbg !475
  %r17 = call i64 @nova_rt_index_get(i64 %r15, i64 %r16), !dbg !475
  ret i64 %r17, !dbg !475
}

define i64 @lru_put(i64 %p0, i64 %p1, i64 %p2) nounwind !dbg !476 {
entry:
  %slot.cache = alloca i64, align 8, !dbg !477
  store i64 %p0, ptr %slot.cache, align 8, !dbg !477
  %slot.key = alloca i64, align 8, !dbg !477
  store i64 %p1, ptr %slot.key, align 8, !dbg !477
  %slot.value = alloca i64, align 8, !dbg !477
  store i64 %p2, ptr %slot.value, align 8, !dbg !477
  %slot.data = alloca i64, align 8, !dbg !477
  store i64 0, ptr %slot.data, align 8, !dbg !477
  %slot.capacity = alloca i64, align 8, !dbg !477
  store i64 0, ptr %slot.capacity, align 8, !dbg !477
  %slot.existing = alloca i64, align 8, !dbg !477
  store i64 0, ptr %slot.existing, align 8, !dbg !477
  %slot.order = alloca i64, align 8, !dbg !477
  store i64 0, ptr %slot.order, align 8, !dbg !477
  %slot.current_order = alloca i64, align 8, !dbg !477
  store i64 0, ptr %slot.current_order, align 8, !dbg !477
  %r0 = load i64, ptr %slot.cache, align 8, !dbg !478
  %r1 = add i64 0, 0, !dbg !478
  %r2 = call i64 @nova_rt_index_get(i64 %r0, i64 %r1), !dbg !478
  store i64 %r2, ptr %slot.data, align 8, !dbg !478
  %r3 = load i64, ptr %slot.cache, align 8, !dbg !479
  %r4 = add i64 2, 0, !dbg !479
  %r5 = call i64 @nova_rt_index_get(i64 %r3, i64 %r4), !dbg !479
  store i64 %r5, ptr %slot.capacity, align 8, !dbg !479
  %r6 = load i64, ptr %slot.cache, align 8, !dbg !480
  %r7 = add i64 1, 0, !dbg !480
  %r8 = call i64 @nova_rt_index_get(i64 %r6, i64 %r7), !dbg !480
  %r9 = load i64, ptr %slot.key, align 8, !dbg !480
  %r10 = call i64 @_lru_find_index(i64 %r8, i64 %r9), !dbg !480
  store i64 %r10, ptr %slot.existing, align 8, !dbg !480
  %r11 = add i64 %r10, 0, !dbg !481
  %r12 = add i64 0, 0, !dbg !481
  %r13.cmp = icmp sge i64 %r11, %r12, !dbg !481
  %r13 = zext i1 %r13.cmp to i64, !dbg !481
  %br_then133 = icmp ne i64 %r13, 0, !dbg !481
  br i1 %br_then133, label %then133, label %else134, !dbg !481
then133:
  %r14 = load i64, ptr %slot.value, align 8, !dbg !482
  %r15 = load i64, ptr %slot.data, align 8, !dbg !482
  %r16 = load i64, ptr %slot.key, align 8, !dbg !482
  %_is.gv0 = call i64 @nova_rt_index_set(i64 %r15, i64 %r16, i64 %r14), !dbg !482
  %r17 = load i64, ptr %slot.cache, align 8, !dbg !483
  %r18 = load i64, ptr %slot.key, align 8, !dbg !483
  %r19 = call i64 @_lru_move_to_end(i64 %r17, i64 %r18), !dbg !483
  %r20 = add i64 0, 0, !dbg !484
  ret i64 %r20, !dbg !484
else134:
  br label %endif135, !dbg !484
endif135:
  %r21 = load i64, ptr %slot.cache, align 8, !dbg !485
  %r22 = add i64 1, 0, !dbg !485
  %r23 = call i64 @nova_rt_index_get(i64 %r21, i64 %r22), !dbg !485
  store i64 %r23, ptr %slot.order, align 8, !dbg !485
  %r24 = add i64 %r23, 0, !dbg !486
  %r25 = call i64 @nova_rt_len_any(i64 %r24), !dbg !486
  %r26 = load i64, ptr %slot.capacity, align 8, !dbg !486
  %r27.cmp = icmp sge i64 %r25, %r26, !dbg !486
  %r27 = zext i1 %r27.cmp to i64, !dbg !486
  %br_then136 = icmp ne i64 %r27, 0, !dbg !486
  br i1 %br_then136, label %then136, label %else137, !dbg !486
then136:
  %r28 = load i64, ptr %slot.order, align 8, !dbg !487
  %r29 = add i64 1, 0, !dbg !487
  %r30 = load i64, ptr %slot.order, align 8, !dbg !487
  %r31 = call i64 @nova_rt_len_any(i64 %r30), !dbg !487
  %r32 = call i64 @nova_rt_slice_any(i64 %r28, i64 %r29, i64 %r31), !dbg !487
  %r33 = load i64, ptr %slot.cache, align 8, !dbg !487
  %r34 = add i64 1, 0, !dbg !487
  %_is.gv1 = call i64 @nova_rt_index_set(i64 %r33, i64 %r34, i64 %r32), !dbg !487
  br label %endif138, !dbg !487
else137:
  br label %endif138, !dbg !487
endif138:
  %r35 = load i64, ptr %slot.cache, align 8, !dbg !488
  %r36 = add i64 1, 0, !dbg !488
  %r37 = call i64 @nova_rt_index_get(i64 %r35, i64 %r36), !dbg !488
  store i64 %r37, ptr %slot.current_order, align 8, !dbg !488
  %r38 = load i64, ptr %slot.value, align 8, !dbg !489
  %r39 = load i64, ptr %slot.data, align 8, !dbg !489
  %r40 = load i64, ptr %slot.key, align 8, !dbg !489
  %_is.gv2 = call i64 @nova_rt_index_set(i64 %r39, i64 %r40, i64 %r38), !dbg !489
  %r41 = add i64 %r37, 0, !dbg !490
  %r42 = load i64, ptr %slot.key, align 8, !dbg !490
  %r43 = call i64 @nova_rt_list_append(i64 %r41, i64 %r42), !dbg !490
  %r44 = add i64 0, 0, !dbg !491
  ret i64 %r44, !dbg !491
}

define i64 @lru_size(i64 %p0) nounwind !dbg !492 {
entry:
  %slot.cache = alloca i64, align 8, !dbg !493
  store i64 %p0, ptr %slot.cache, align 8, !dbg !493
  %r0 = load i64, ptr %slot.cache, align 8, !dbg !494
  %r1 = add i64 1, 0, !dbg !494
  %r2 = call i64 @nova_rt_index_get(i64 %r0, i64 %r1), !dbg !494
  %r3 = call i64 @nova_rt_len_any(i64 %r2), !dbg !494
  ret i64 %r3, !dbg !494
}

define i64 @_lru_move_to_end(i64 %p0, i64 %p1) nounwind !dbg !495 {
entry:
  %slot.cache = alloca i64, align 8, !dbg !496
  store i64 %p0, ptr %slot.cache, align 8, !dbg !496
  %slot.key = alloca i64, align 8, !dbg !496
  store i64 %p1, ptr %slot.key, align 8, !dbg !496
  %slot.order = alloca i64, align 8, !dbg !496
  store i64 0, ptr %slot.order, align 8, !dbg !496
  %slot.idx = alloca i64, align 8, !dbg !496
  store i64 0, ptr %slot.idx, align 8, !dbg !496
  %slot.rebuilt = alloca i64, align 8, !dbg !496
  store i64 0, ptr %slot.rebuilt, align 8, !dbg !496
  %slot.i = alloca i64, align 8, !dbg !496
  store i64 0, ptr %slot.i, align 8, !dbg !496
  %r0 = load i64, ptr %slot.cache, align 8, !dbg !497
  %r1 = add i64 1, 0, !dbg !497
  %r2 = call i64 @nova_rt_index_get(i64 %r0, i64 %r1), !dbg !497
  store i64 %r2, ptr %slot.order, align 8, !dbg !497
  %r3 = add i64 %r2, 0, !dbg !498
  %r4 = load i64, ptr %slot.key, align 8, !dbg !498
  %r5 = call i64 @_lru_find_index(i64 %r3, i64 %r4), !dbg !498
  store i64 %r5, ptr %slot.idx, align 8, !dbg !498
  %r6 = add i64 %r5, 0, !dbg !499
  %r7 = add i64 0, 0, !dbg !499
  %r8.cmp = icmp sge i64 %r6, %r7, !dbg !499
  %r8 = zext i1 %r8.cmp to i64, !dbg !499
  %br_retthen139 = icmp ne i64 %r8, 0, !dbg !499
  br i1 %br_retthen139, label %retthen139, label %retelse140, !dbg !499
retthen139:
  %r9 = call i64 @nova_rt_list_create(), !dbg !500
  store i64 %r9, ptr %slot.rebuilt, align 8, !dbg !500
  %r10 = add i64 0, 0, !dbg !501
  store i64 %r10, ptr %slot.i, align 8, !dbg !501
  br label %while_hdr141, !dbg !502
while_hdr141:
  %r11 = load i64, ptr %slot.i, align 8, !dbg !502
  %r12 = load i64, ptr %slot.order, align 8, !dbg !502
  %r13 = call i64 @nova_rt_len_any(i64 %r12), !dbg !502
  %r14.cmp = icmp slt i64 %r11, %r13, !dbg !502
  %r14 = zext i1 %r14.cmp to i64, !dbg !502
  %br_while_body142 = icmp ne i64 %r14, 0, !dbg !502
  br i1 %br_while_body142, label %while_body142, label %while_exit143, !prof !90, !dbg !502
while_body142:
  %r15 = load i64, ptr %slot.i, align 8, !dbg !503
  %r16 = load i64, ptr %slot.idx, align 8, !dbg !503
  %r17.cmp = icmp ne i64 %r15, %r16, !dbg !503
  %r17 = zext i1 %r17.cmp to i64, !dbg !503
  %br_then144 = icmp ne i64 %r17, 0, !dbg !503
  br i1 %br_then144, label %then144, label %else145, !dbg !503
then144:
  %r18 = load i64, ptr %slot.rebuilt, align 8, !dbg !504
  %r19 = load i64, ptr %slot.order, align 8, !dbg !504
  %r20 = load i64, ptr %slot.i, align 8, !dbg !504
  %r21 = call i64 @nova_rt_index_get(i64 %r19, i64 %r20), !dbg !504
  %r22 = call i64 @nova_rt_list_append(i64 %r18, i64 %r21), !dbg !504
  br label %endif146, !dbg !504
else145:
  br label %endif146, !dbg !504
endif146:
  %r23 = load i64, ptr %slot.i, align 8, !dbg !505
  %r24 = add i64 1, 0, !dbg !505
  %r25 = add i64 %r23, %r24, !dbg !505
  store i64 %r25, ptr %slot.i, align 8, !dbg !505
  br label %while_hdr141, !dbg !505
while_exit143:
  %r26 = load i64, ptr %slot.rebuilt, align 8, !dbg !506
  %r27 = load i64, ptr %slot.key, align 8, !dbg !506
  %r28 = call i64 @nova_rt_list_append(i64 %r26, i64 %r27), !dbg !506
  %r29 = load i64, ptr %slot.rebuilt, align 8, !dbg !507
  %r30 = load i64, ptr %slot.cache, align 8, !dbg !507
  %r31 = add i64 1, 0, !dbg !507
  %_is.gv0 = call i64 @nova_rt_index_set(i64 %r30, i64 %r31, i64 %r29), !dbg !507
  ret i64 0, !dbg !507
retelse140:
  ret i64 0, !dbg !507
}

define i64 @_lru_find_index(i64 %p0, i64 %p1) nounwind !dbg !508 {
entry:
  %slot.order = alloca i64, align 8, !dbg !509
  store i64 %p0, ptr %slot.order, align 8, !dbg !509
  %slot.key = alloca i64, align 8, !dbg !509
  store i64 %p1, ptr %slot.key, align 8, !dbg !509
  %slot.i = alloca i64, align 8, !dbg !509
  store i64 0, ptr %slot.i, align 8, !dbg !509
  %r0 = add i64 0, 0, !dbg !510
  store i64 %r0, ptr %slot.i, align 8, !dbg !510
  br label %while_hdr147, !dbg !511
while_hdr147:
  %r1 = load i64, ptr %slot.i, align 8, !dbg !511
  %r2 = load i64, ptr %slot.order, align 8, !dbg !511
  %r3 = call i64 @nova_rt_len_any(i64 %r2), !dbg !511
  %r4.cmp = icmp slt i64 %r1, %r3, !dbg !511
  %r4 = zext i1 %r4.cmp to i64, !dbg !511
  %br_while_body148 = icmp ne i64 %r4, 0, !dbg !511
  br i1 %br_while_body148, label %while_body148, label %while_exit149, !prof !90, !dbg !511
while_body148:
  %r5 = load i64, ptr %slot.order, align 8, !dbg !512
  %r6 = load i64, ptr %slot.i, align 8, !dbg !512
  %r7 = call i64 @nova_rt_index_get(i64 %r5, i64 %r6), !dbg !512
  %r8 = load i64, ptr %slot.key, align 8, !dbg !512
  %r9 = call i64 @nova_rt_eq(i64 %r7, i64 %r8), !dbg !512
  %br_then150 = icmp ne i64 %r9, 0, !dbg !512
  br i1 %br_then150, label %then150, label %else151, !dbg !512
then150:
  %r10 = load i64, ptr %slot.i, align 8, !dbg !513
  ret i64 %r10, !dbg !513
else151:
  br label %endif152, !dbg !513
endif152:
  %r11 = load i64, ptr %slot.i, align 8, !dbg !514
  %r12 = add i64 1, 0, !dbg !514
  %r13 = add i64 %r11, %r12, !dbg !514
  store i64 %r13, ptr %slot.i, align 8, !dbg !514
  br label %while_hdr147, !dbg !514
while_exit149:
  %r14 = add i64 1, 0, !dbg !515
  %r15 = sub i64 0, %r14, !dbg !515
  ret i64 %r15, !dbg !515
}

define i64 @sorted_map_new() nounwind !dbg !516 {
entry:
  %slot.pairs = alloca i64, align 8, !dbg !517
  store i64 0, ptr %slot.pairs, align 8, !dbg !517
  %r0 = call i64 @nova_rt_list_create(), !dbg !518
  store i64 %r0, ptr %slot.pairs, align 8, !dbg !518
  %r2 = add i64 %r0, 0, !dbg !519
  %r1 = call i64 @nova_rt_list_create(), !dbg !519
  call i64 @nova_rt_list_append(i64 %r1, i64 %r2), !dbg !519
  ret i64 %r1, !dbg !519
}

define i64 @_sm_bsearch(i64 %p0, i64 %p1) nounwind !dbg !520 {
entry:
  %slot.pairs = alloca i64, align 8, !dbg !521
  store i64 %p0, ptr %slot.pairs, align 8, !dbg !521
  %slot.key = alloca i64, align 8, !dbg !521
  store i64 %p1, ptr %slot.key, align 8, !dbg !521
  %slot.lo = alloca i64, align 8, !dbg !521
  store i64 0, ptr %slot.lo, align 8, !dbg !521
  %slot.hi = alloca i64, align 8, !dbg !521
  store i64 0, ptr %slot.hi, align 8, !dbg !521
  %slot.mid = alloca i64, align 8, !dbg !521
  store i64 0, ptr %slot.mid, align 8, !dbg !521
  %slot.mk = alloca i64, align 8, !dbg !521
  store i64 0, ptr %slot.mk, align 8, !dbg !521
  %r0 = add i64 0, 0, !dbg !522
  store i64 %r0, ptr %slot.lo, align 8, !dbg !522
  %r1 = load i64, ptr %slot.pairs, align 8, !dbg !523
  %r2 = call i64 @nova_rt_len_any(i64 %r1), !dbg !523
  %r3 = add i64 1, 0, !dbg !523
  %r4 = sub i64 %r2, %r3, !dbg !523
  store i64 %r4, ptr %slot.hi, align 8, !dbg !523
  br label %while_hdr153, !dbg !524
while_hdr153:
  %r5 = load i64, ptr %slot.lo, align 8, !dbg !524
  %r6 = load i64, ptr %slot.hi, align 8, !dbg !524
  %r7.cmp = icmp sle i64 %r5, %r6, !dbg !524
  %r7 = zext i1 %r7.cmp to i64, !dbg !524
  %br_while_body154 = icmp ne i64 %r7, 0, !dbg !524
  br i1 %br_while_body154, label %while_body154, label %while_exit155, !prof !90, !dbg !524
while_body154:
  %r8 = load i64, ptr %slot.lo, align 8, !dbg !525
  %r9 = load i64, ptr %slot.hi, align 8, !dbg !525
  %r10 = add i64 %r8, %r9, !dbg !525
  %r11 = add i64 2, 0, !dbg !525
  %r12 = sdiv i64 %r10, %r11, !dbg !525
  store i64 %r12, ptr %slot.mid, align 8, !dbg !525
  %r13 = load i64, ptr %slot.pairs, align 8, !dbg !526
  %r14 = add i64 %r12, 0, !dbg !526
  %r15 = call i64 @nova_rt_index_get(i64 %r13, i64 %r14), !dbg !526
  %r16 = add i64 0, 0, !dbg !526
  %r17 = call i64 @nova_rt_index_get(i64 %r15, i64 %r16), !dbg !526
  store i64 %r17, ptr %slot.mk, align 8, !dbg !526
  %r18 = add i64 %r17, 0, !dbg !527
  %r19 = load i64, ptr %slot.key, align 8, !dbg !527
  %r20 = call i64 @nova_rt_eq(i64 %r18, i64 %r19), !dbg !527
  %br_then156 = icmp ne i64 %r20, 0, !dbg !527
  br i1 %br_then156, label %then156, label %else157, !dbg !527
then156:
  %r21 = load i64, ptr %slot.mid, align 8, !dbg !528
  ret i64 %r21, !dbg !528
else157:
  br label %endif158, !dbg !528
endif158:
  %r22 = load i64, ptr %slot.mk, align 8, !dbg !529
  %r23 = load i64, ptr %slot.key, align 8, !dbg !529
  %r24.cmp = icmp slt i64 %r22, %r23, !dbg !529
  %r24 = zext i1 %r24.cmp to i64, !dbg !529
  %br_then159 = icmp ne i64 %r24, 0, !dbg !529
  br i1 %br_then159, label %then159, label %else160, !dbg !529
then159:
  %r25 = load i64, ptr %slot.mid, align 8, !dbg !530
  %r26 = add i64 1, 0, !dbg !530
  %r27 = add i64 %r25, %r26, !dbg !530
  store i64 %r27, ptr %slot.lo, align 8, !dbg !530
  br label %endif161, !dbg !530
else160:
  %r28 = load i64, ptr %slot.mid, align 8, !dbg !531
  %r29 = add i64 1, 0, !dbg !531
  %r30 = sub i64 %r28, %r29, !dbg !531
  store i64 %r30, ptr %slot.hi, align 8, !dbg !531
  br label %endif161, !dbg !531
endif161:
  br label %while_hdr153, !dbg !531
while_exit155:
  %r31 = load i64, ptr %slot.lo, align 8, !dbg !532
  %r32 = add i64 1, 0, !dbg !532
  %r33 = add i64 %r31, %r32, !dbg !532
  %r34 = sub i64 0, %r33, !dbg !532
  ret i64 %r34, !dbg !532
}

define i64 @sorted_map_set(i64 %p0, i64 %p1, i64 %p2) nounwind !dbg !533 {
entry:
  %slot.sm = alloca i64, align 8, !dbg !534
  store i64 %p0, ptr %slot.sm, align 8, !dbg !534
  %slot.key = alloca i64, align 8, !dbg !534
  store i64 %p1, ptr %slot.key, align 8, !dbg !534
  %slot.value = alloca i64, align 8, !dbg !534
  store i64 %p2, ptr %slot.value, align 8, !dbg !534
  %slot.pairs = alloca i64, align 8, !dbg !534
  store i64 0, ptr %slot.pairs, align 8, !dbg !534
  %slot.idx = alloca i64, align 8, !dbg !534
  store i64 0, ptr %slot.idx, align 8, !dbg !534
  %slot.insert_at = alloca i64, align 8, !dbg !534
  store i64 0, ptr %slot.insert_at, align 8, !dbg !534
  %slot.i = alloca i64, align 8, !dbg !534
  store i64 0, ptr %slot.i, align 8, !dbg !534
  %r0 = load i64, ptr %slot.sm, align 8, !dbg !535
  %r1 = add i64 0, 0, !dbg !535
  %r2 = call i64 @nova_rt_index_get(i64 %r0, i64 %r1), !dbg !535
  store i64 %r2, ptr %slot.pairs, align 8, !dbg !535
  %r3 = add i64 %r2, 0, !dbg !536
  %r4 = load i64, ptr %slot.key, align 8, !dbg !536
  %r5 = call i64 @_sm_bsearch(i64 %r3, i64 %r4), !dbg !536
  store i64 %r5, ptr %slot.idx, align 8, !dbg !536
  %r6 = add i64 %r5, 0, !dbg !537
  %r7 = add i64 0, 0, !dbg !537
  %r8.cmp = icmp sge i64 %r6, %r7, !dbg !537
  %r8 = zext i1 %r8.cmp to i64, !dbg !537
  %br_then162 = icmp ne i64 %r8, 0, !dbg !537
  br i1 %br_then162, label %then162, label %else163, !dbg !537
then162:
  %r10 = load i64, ptr %slot.key, align 8, !dbg !538
  %r11 = load i64, ptr %slot.value, align 8, !dbg !538
  %r9 = call i64 @nova_rt_list_create(), !dbg !538
  call i64 @nova_rt_list_append(i64 %r9, i64 %r10), !dbg !538
  call i64 @nova_rt_list_append(i64 %r9, i64 %r11), !dbg !538
  %r12 = load i64, ptr %slot.pairs, align 8, !dbg !538
  %r13 = load i64, ptr %slot.idx, align 8, !dbg !538
  %_is.gv0 = call i64 @nova_rt_index_set(i64 %r12, i64 %r13, i64 %r9), !dbg !538
  %r14 = add i64 0, 0, !dbg !539
  ret i64 %r14, !dbg !539
else163:
  br label %endif164, !dbg !539
endif164:
  %r15 = load i64, ptr %slot.idx, align 8, !dbg !540
  %r16 = add i64 1, 0, !dbg !540
  %r17 = add i64 %r15, %r16, !dbg !540
  %r18 = sub i64 0, %r17, !dbg !540
  store i64 %r18, ptr %slot.insert_at, align 8, !dbg !540
  %r19 = load i64, ptr %slot.pairs, align 8, !dbg !541
  %r21 = load i64, ptr %slot.key, align 8, !dbg !541
  %r22 = load i64, ptr %slot.value, align 8, !dbg !541
  %r20 = call i64 @nova_rt_list_create(), !dbg !541
  call i64 @nova_rt_list_append(i64 %r20, i64 %r21), !dbg !541
  call i64 @nova_rt_list_append(i64 %r20, i64 %r22), !dbg !541
  %r23 = call i64 @nova_rt_list_append(i64 %r19, i64 %r20), !dbg !541
  %r24 = load i64, ptr %slot.pairs, align 8, !dbg !542
  %r25 = call i64 @nova_rt_len_any(i64 %r24), !dbg !542
  %r26 = add i64 1, 0, !dbg !542
  %r27 = sub i64 %r25, %r26, !dbg !542
  store i64 %r27, ptr %slot.i, align 8, !dbg !542
  br label %while_hdr165, !dbg !543
while_hdr165:
  %r28 = load i64, ptr %slot.i, align 8, !dbg !543
  %r29 = load i64, ptr %slot.insert_at, align 8, !dbg !543
  %r30.cmp = icmp sgt i64 %r28, %r29, !dbg !543
  %r30 = zext i1 %r30.cmp to i64, !dbg !543
  %br_while_body166 = icmp ne i64 %r30, 0, !dbg !543
  br i1 %br_while_body166, label %while_body166, label %while_exit167, !prof !90, !dbg !543
while_body166:
  %r31 = load i64, ptr %slot.pairs, align 8, !dbg !544
  %r32 = load i64, ptr %slot.i, align 8, !dbg !544
  %r33 = add i64 1, 0, !dbg !544
  %r34 = sub i64 %r32, %r33, !dbg !544
  %r35 = call i64 @nova_rt_index_get(i64 %r31, i64 %r34), !dbg !544
  %r36 = load i64, ptr %slot.pairs, align 8, !dbg !544
  %r37 = load i64, ptr %slot.i, align 8, !dbg !544
  %_is.gv1 = call i64 @nova_rt_index_set(i64 %r36, i64 %r37, i64 %r35), !dbg !544
  %r38 = load i64, ptr %slot.i, align 8, !dbg !545
  %r39 = add i64 1, 0, !dbg !545
  %r40 = sub i64 %r38, %r39, !dbg !545
  store i64 %r40, ptr %slot.i, align 8, !dbg !545
  br label %while_hdr165, !dbg !545
while_exit167:
  %r42 = load i64, ptr %slot.key, align 8, !dbg !546
  %r43 = load i64, ptr %slot.value, align 8, !dbg !546
  %r41 = call i64 @nova_rt_list_create(), !dbg !546
  call i64 @nova_rt_list_append(i64 %r41, i64 %r42), !dbg !546
  call i64 @nova_rt_list_append(i64 %r41, i64 %r43), !dbg !546
  %r44 = load i64, ptr %slot.pairs, align 8, !dbg !546
  %r45 = load i64, ptr %slot.insert_at, align 8, !dbg !546
  %_is.gv2 = call i64 @nova_rt_index_set(i64 %r44, i64 %r45, i64 %r41), !dbg !546
  %r46 = add i64 0, 0, !dbg !547
  ret i64 %r46, !dbg !547
}

define i64 @sorted_map_get(i64 %p0, i64 %p1) nounwind !dbg !548 {
entry:
  %slot.sm = alloca i64, align 8, !dbg !549
  store i64 %p0, ptr %slot.sm, align 8, !dbg !549
  %slot.key = alloca i64, align 8, !dbg !549
  store i64 %p1, ptr %slot.key, align 8, !dbg !549
  %slot.pairs = alloca i64, align 8, !dbg !549
  store i64 0, ptr %slot.pairs, align 8, !dbg !549
  %slot.idx = alloca i64, align 8, !dbg !549
  store i64 0, ptr %slot.idx, align 8, !dbg !549
  %r0 = load i64, ptr %slot.sm, align 8, !dbg !550
  %r1 = add i64 0, 0, !dbg !550
  %r2 = call i64 @nova_rt_index_get(i64 %r0, i64 %r1), !dbg !550
  store i64 %r2, ptr %slot.pairs, align 8, !dbg !550
  %r3 = add i64 %r2, 0, !dbg !551
  %r4 = load i64, ptr %slot.key, align 8, !dbg !551
  %r5 = call i64 @_sm_bsearch(i64 %r3, i64 %r4), !dbg !551
  store i64 %r5, ptr %slot.idx, align 8, !dbg !551
  %r6 = add i64 %r5, 0, !dbg !552
  %r7 = add i64 0, 0, !dbg !552
  %r8.cmp = icmp sge i64 %r6, %r7, !dbg !552
  %r8 = zext i1 %r8.cmp to i64, !dbg !552
  %br_then168 = icmp ne i64 %r8, 0, !dbg !552
  br i1 %br_then168, label %then168, label %else169, !dbg !552
then168:
  %r9 = load i64, ptr %slot.pairs, align 8, !dbg !553
  %r10 = load i64, ptr %slot.idx, align 8, !dbg !553
  %r11 = call i64 @nova_rt_index_get(i64 %r9, i64 %r10), !dbg !553
  %r12 = add i64 1, 0, !dbg !553
  %r13 = call i64 @nova_rt_index_get(i64 %r11, i64 %r12), !dbg !553
  ret i64 %r13, !dbg !553
else169:
  br label %endif170, !dbg !553
endif170:
  %r14 = add i64 0, 0, !dbg !554
  ret i64 %r14, !dbg !554
}

define i64 @sorted_map_has(i64 %p0, i64 %p1) nounwind !dbg !555 {
entry:
  %slot.sm = alloca i64, align 8, !dbg !556
  store i64 %p0, ptr %slot.sm, align 8, !dbg !556
  %slot.key = alloca i64, align 8, !dbg !556
  store i64 %p1, ptr %slot.key, align 8, !dbg !556
  %slot.pairs = alloca i64, align 8, !dbg !556
  store i64 0, ptr %slot.pairs, align 8, !dbg !556
  %r0 = load i64, ptr %slot.sm, align 8, !dbg !557
  %r1 = add i64 0, 0, !dbg !557
  %r2 = call i64 @nova_rt_index_get(i64 %r0, i64 %r1), !dbg !557
  store i64 %r2, ptr %slot.pairs, align 8, !dbg !557
  %r3 = add i64 %r2, 0, !dbg !558
  %r4 = load i64, ptr %slot.key, align 8, !dbg !558
  %r5 = call i64 @_sm_bsearch(i64 %r3, i64 %r4), !dbg !558
  %r6 = add i64 0, 0, !dbg !558
  %r7.cmp = icmp sge i64 %r5, %r6, !dbg !558
  %r7 = zext i1 %r7.cmp to i64, !dbg !558
  ret i64 %r7, !dbg !558
}

define i64 @sorted_map_remove(i64 %p0, i64 %p1) nounwind !dbg !559 {
entry:
  %slot.sm = alloca i64, align 8, !dbg !560
  store i64 %p0, ptr %slot.sm, align 8, !dbg !560
  %slot.key = alloca i64, align 8, !dbg !560
  store i64 %p1, ptr %slot.key, align 8, !dbg !560
  %slot.pairs = alloca i64, align 8, !dbg !560
  store i64 0, ptr %slot.pairs, align 8, !dbg !560
  %slot.idx = alloca i64, align 8, !dbg !560
  store i64 0, ptr %slot.idx, align 8, !dbg !560
  %slot.rebuilt = alloca i64, align 8, !dbg !560
  store i64 0, ptr %slot.rebuilt, align 8, !dbg !560
  %slot.i = alloca i64, align 8, !dbg !560
  store i64 0, ptr %slot.i, align 8, !dbg !560
  %r0 = load i64, ptr %slot.sm, align 8, !dbg !561
  %r1 = add i64 0, 0, !dbg !561
  %r2 = call i64 @nova_rt_index_get(i64 %r0, i64 %r1), !dbg !561
  store i64 %r2, ptr %slot.pairs, align 8, !dbg !561
  %r3 = add i64 %r2, 0, !dbg !562
  %r4 = load i64, ptr %slot.key, align 8, !dbg !562
  %r5 = call i64 @_sm_bsearch(i64 %r3, i64 %r4), !dbg !562
  store i64 %r5, ptr %slot.idx, align 8, !dbg !562
  %r6 = add i64 %r5, 0, !dbg !563
  %r7 = add i64 0, 0, !dbg !563
  %r8.cmp = icmp slt i64 %r6, %r7, !dbg !563
  %r8 = zext i1 %r8.cmp to i64, !dbg !563
  %br_then171 = icmp ne i64 %r8, 0, !dbg !563
  br i1 %br_then171, label %then171, label %else172, !dbg !563
then171:
  %r9 = add i64 0, 0, !dbg !564
  ret i64 %r9, !dbg !564
else172:
  br label %endif173, !dbg !564
endif173:
  %r10 = call i64 @nova_rt_list_create(), !dbg !565
  store i64 %r10, ptr %slot.rebuilt, align 8, !dbg !565
  %r11 = add i64 0, 0, !dbg !566
  store i64 %r11, ptr %slot.i, align 8, !dbg !566
  br label %while_hdr174, !dbg !567
while_hdr174:
  %r12 = load i64, ptr %slot.i, align 8, !dbg !567
  %r13 = load i64, ptr %slot.pairs, align 8, !dbg !567
  %r14 = call i64 @nova_rt_len_any(i64 %r13), !dbg !567
  %r15.cmp = icmp slt i64 %r12, %r14, !dbg !567
  %r15 = zext i1 %r15.cmp to i64, !dbg !567
  %br_while_body175 = icmp ne i64 %r15, 0, !dbg !567
  br i1 %br_while_body175, label %while_body175, label %while_exit176, !prof !90, !dbg !567
while_body175:
  %r16 = load i64, ptr %slot.i, align 8, !dbg !568
  %r17 = load i64, ptr %slot.idx, align 8, !dbg !568
  %r18.cmp = icmp ne i64 %r16, %r17, !dbg !568
  %r18 = zext i1 %r18.cmp to i64, !dbg !568
  %br_then177 = icmp ne i64 %r18, 0, !dbg !568
  br i1 %br_then177, label %then177, label %else178, !dbg !568
then177:
  %r19 = load i64, ptr %slot.rebuilt, align 8, !dbg !569
  %r20 = load i64, ptr %slot.pairs, align 8, !dbg !569
  %r21 = load i64, ptr %slot.i, align 8, !dbg !569
  %r22 = call i64 @nova_rt_index_get(i64 %r20, i64 %r21), !dbg !569
  %r23 = call i64 @nova_rt_list_append(i64 %r19, i64 %r22), !dbg !569
  br label %endif179, !dbg !569
else178:
  br label %endif179, !dbg !569
endif179:
  %r24 = load i64, ptr %slot.i, align 8, !dbg !570
  %r25 = add i64 1, 0, !dbg !570
  %r26 = add i64 %r24, %r25, !dbg !570
  store i64 %r26, ptr %slot.i, align 8, !dbg !570
  br label %while_hdr174, !dbg !570
while_exit176:
  %r27 = load i64, ptr %slot.rebuilt, align 8, !dbg !571
  %r28 = load i64, ptr %slot.sm, align 8, !dbg !571
  %r29 = add i64 0, 0, !dbg !571
  %_is.gv0 = call i64 @nova_rt_index_set(i64 %r28, i64 %r29, i64 %r27), !dbg !571
  %r30 = add i64 1, 0, !dbg !572
  ret i64 %r30, !dbg !572
}

define i64 @sorted_map_size(i64 %p0) nounwind !dbg !573 {
entry:
  %slot.sm = alloca i64, align 8, !dbg !574
  store i64 %p0, ptr %slot.sm, align 8, !dbg !574
  %r0 = load i64, ptr %slot.sm, align 8, !dbg !575
  %r1 = add i64 0, 0, !dbg !575
  %r2 = call i64 @nova_rt_index_get(i64 %r0, i64 %r1), !dbg !575
  %r3 = call i64 @nova_rt_len_any(i64 %r2), !dbg !575
  ret i64 %r3, !dbg !575
}

define i64 @sorted_map_keys(i64 %p0) nounwind !dbg !576 {
entry:
  %slot.sm = alloca i64, align 8, !dbg !577
  store i64 %p0, ptr %slot.sm, align 8, !dbg !577
  %slot.pairs = alloca i64, align 8, !dbg !577
  store i64 0, ptr %slot.pairs, align 8, !dbg !577
  %slot.result = alloca i64, align 8, !dbg !577
  store i64 0, ptr %slot.result, align 8, !dbg !577
  %slot.i = alloca i64, align 8, !dbg !577
  store i64 0, ptr %slot.i, align 8, !dbg !577
  %r0 = load i64, ptr %slot.sm, align 8, !dbg !578
  %r1 = add i64 0, 0, !dbg !578
  %r2 = call i64 @nova_rt_index_get(i64 %r0, i64 %r1), !dbg !578
  store i64 %r2, ptr %slot.pairs, align 8, !dbg !578
  %r3 = call i64 @nova_rt_list_create(), !dbg !579
  store i64 %r3, ptr %slot.result, align 8, !dbg !579
  %r4 = add i64 0, 0, !dbg !580
  store i64 %r4, ptr %slot.i, align 8, !dbg !580
  br label %while_hdr180, !dbg !581
while_hdr180:
  %r5 = load i64, ptr %slot.i, align 8, !dbg !581
  %r6 = load i64, ptr %slot.pairs, align 8, !dbg !581
  %r7 = call i64 @nova_rt_len_any(i64 %r6), !dbg !581
  %r8.cmp = icmp slt i64 %r5, %r7, !dbg !581
  %r8 = zext i1 %r8.cmp to i64, !dbg !581
  %br_while_body181 = icmp ne i64 %r8, 0, !dbg !581
  br i1 %br_while_body181, label %while_body181, label %while_exit182, !prof !90, !dbg !581
while_body181:
  %r9 = load i64, ptr %slot.result, align 8, !dbg !582
  %r10 = load i64, ptr %slot.pairs, align 8, !dbg !582
  %r11 = load i64, ptr %slot.i, align 8, !dbg !582
  %r12 = call i64 @nova_rt_index_get(i64 %r10, i64 %r11), !dbg !582
  %r13 = add i64 0, 0, !dbg !582
  %r14 = call i64 @nova_rt_index_get(i64 %r12, i64 %r13), !dbg !582
  %r15 = call i64 @nova_rt_list_append(i64 %r9, i64 %r14), !dbg !582
  %r16 = load i64, ptr %slot.i, align 8, !dbg !583
  %r17 = add i64 1, 0, !dbg !583
  %r18 = add i64 %r16, %r17, !dbg !583
  store i64 %r18, ptr %slot.i, align 8, !dbg !583
  br label %while_hdr180, !dbg !583
while_exit182:
  %r19 = load i64, ptr %slot.result, align 8, !dbg !584
  ret i64 %r19, !dbg !584
}

define i64 @sorted_map_values(i64 %p0) nounwind !dbg !585 {
entry:
  %slot.sm = alloca i64, align 8, !dbg !586
  store i64 %p0, ptr %slot.sm, align 8, !dbg !586
  %slot.pairs = alloca i64, align 8, !dbg !586
  store i64 0, ptr %slot.pairs, align 8, !dbg !586
  %slot.result = alloca i64, align 8, !dbg !586
  store i64 0, ptr %slot.result, align 8, !dbg !586
  %slot.i = alloca i64, align 8, !dbg !586
  store i64 0, ptr %slot.i, align 8, !dbg !586
  %r0 = load i64, ptr %slot.sm, align 8, !dbg !587
  %r1 = add i64 0, 0, !dbg !587
  %r2 = call i64 @nova_rt_index_get(i64 %r0, i64 %r1), !dbg !587
  store i64 %r2, ptr %slot.pairs, align 8, !dbg !587
  %r3 = call i64 @nova_rt_list_create(), !dbg !588
  store i64 %r3, ptr %slot.result, align 8, !dbg !588
  %r4 = add i64 0, 0, !dbg !589
  store i64 %r4, ptr %slot.i, align 8, !dbg !589
  br label %while_hdr183, !dbg !590
while_hdr183:
  %r5 = load i64, ptr %slot.i, align 8, !dbg !590
  %r6 = load i64, ptr %slot.pairs, align 8, !dbg !590
  %r7 = call i64 @nova_rt_len_any(i64 %r6), !dbg !590
  %r8.cmp = icmp slt i64 %r5, %r7, !dbg !590
  %r8 = zext i1 %r8.cmp to i64, !dbg !590
  %br_while_body184 = icmp ne i64 %r8, 0, !dbg !590
  br i1 %br_while_body184, label %while_body184, label %while_exit185, !prof !90, !dbg !590
while_body184:
  %r9 = load i64, ptr %slot.result, align 8, !dbg !591
  %r10 = load i64, ptr %slot.pairs, align 8, !dbg !591
  %r11 = load i64, ptr %slot.i, align 8, !dbg !591
  %r12 = call i64 @nova_rt_index_get(i64 %r10, i64 %r11), !dbg !591
  %r13 = add i64 1, 0, !dbg !591
  %r14 = call i64 @nova_rt_index_get(i64 %r12, i64 %r13), !dbg !591
  %r15 = call i64 @nova_rt_list_append(i64 %r9, i64 %r14), !dbg !591
  %r16 = load i64, ptr %slot.i, align 8, !dbg !592
  %r17 = add i64 1, 0, !dbg !592
  %r18 = add i64 %r16, %r17, !dbg !592
  store i64 %r18, ptr %slot.i, align 8, !dbg !592
  br label %while_hdr183, !dbg !592
while_exit185:
  %r19 = load i64, ptr %slot.result, align 8, !dbg !593
  ret i64 %r19, !dbg !593
}

define i64 @sorted_map_min_key(i64 %p0) nounwind !dbg !594 {
entry:
  %slot.sm = alloca i64, align 8, !dbg !595
  store i64 %p0, ptr %slot.sm, align 8, !dbg !595
  %slot.pairs = alloca i64, align 8, !dbg !595
  store i64 0, ptr %slot.pairs, align 8, !dbg !595
  %r0 = load i64, ptr %slot.sm, align 8, !dbg !596
  %r1 = add i64 0, 0, !dbg !596
  %r2 = call i64 @nova_rt_index_get(i64 %r0, i64 %r1), !dbg !596
  store i64 %r2, ptr %slot.pairs, align 8, !dbg !596
  %r3 = add i64 %r2, 0, !dbg !597
  %r4 = call i64 @nova_rt_len_any(i64 %r3), !dbg !597
  %r5 = add i64 0, 0, !dbg !597
  %r6.cmp = icmp eq i64 %r4, %r5, !dbg !597
  %r6 = zext i1 %r6.cmp to i64, !dbg !597
  %br_then186 = icmp ne i64 %r6, 0, !dbg !597
  br i1 %br_then186, label %then186, label %else187, !dbg !597
then186:
  %r7 = add i64 0, 0, !dbg !598
  ret i64 %r7, !dbg !598
else187:
  br label %endif188, !dbg !598
endif188:
  %r8 = load i64, ptr %slot.pairs, align 8, !dbg !599
  %r9 = add i64 0, 0, !dbg !599
  %r10 = call i64 @nova_rt_index_get(i64 %r8, i64 %r9), !dbg !599
  %r11 = add i64 0, 0, !dbg !599
  %r12 = call i64 @nova_rt_index_get(i64 %r10, i64 %r11), !dbg !599
  ret i64 %r12, !dbg !599
}

define i64 @sorted_map_max_key(i64 %p0) nounwind !dbg !600 {
entry:
  %slot.sm = alloca i64, align 8, !dbg !601
  store i64 %p0, ptr %slot.sm, align 8, !dbg !601
  %slot.pairs = alloca i64, align 8, !dbg !601
  store i64 0, ptr %slot.pairs, align 8, !dbg !601
  %r0 = load i64, ptr %slot.sm, align 8, !dbg !602
  %r1 = add i64 0, 0, !dbg !602
  %r2 = call i64 @nova_rt_index_get(i64 %r0, i64 %r1), !dbg !602
  store i64 %r2, ptr %slot.pairs, align 8, !dbg !602
  %r3 = add i64 %r2, 0, !dbg !603
  %r4 = call i64 @nova_rt_len_any(i64 %r3), !dbg !603
  %r5 = add i64 0, 0, !dbg !603
  %r6.cmp = icmp eq i64 %r4, %r5, !dbg !603
  %r6 = zext i1 %r6.cmp to i64, !dbg !603
  %br_then189 = icmp ne i64 %r6, 0, !dbg !603
  br i1 %br_then189, label %then189, label %else190, !dbg !603
then189:
  %r7 = add i64 0, 0, !dbg !604
  ret i64 %r7, !dbg !604
else190:
  br label %endif191, !dbg !604
endif191:
  %r8 = load i64, ptr %slot.pairs, align 8, !dbg !605
  %r9 = load i64, ptr %slot.pairs, align 8, !dbg !605
  %r10 = call i64 @nova_rt_len_any(i64 %r9), !dbg !605
  %r11 = add i64 1, 0, !dbg !605
  %r12 = sub i64 %r10, %r11, !dbg !605
  %r13 = call i64 @nova_rt_index_get(i64 %r8, i64 %r12), !dbg !605
  %r14 = add i64 0, 0, !dbg !605
  %r15 = call i64 @nova_rt_index_get(i64 %r13, i64 %r14), !dbg !605
  ret i64 %r15, !dbg !605
}

define i64 @sorted_map_range(i64 %p0, i64 %p1, i64 %p2) nounwind !dbg !606 {
entry:
  %slot.sm = alloca i64, align 8, !dbg !607
  store i64 %p0, ptr %slot.sm, align 8, !dbg !607
  %slot.lo_key = alloca i64, align 8, !dbg !607
  store i64 %p1, ptr %slot.lo_key, align 8, !dbg !607
  %slot.hi_key = alloca i64, align 8, !dbg !607
  store i64 %p2, ptr %slot.hi_key, align 8, !dbg !607
  %slot.pairs = alloca i64, align 8, !dbg !607
  store i64 0, ptr %slot.pairs, align 8, !dbg !607
  %slot.result = alloca i64, align 8, !dbg !607
  store i64 0, ptr %slot.result, align 8, !dbg !607
  %slot.i = alloca i64, align 8, !dbg !607
  store i64 0, ptr %slot.i, align 8, !dbg !607
  %slot.k = alloca i64, align 8, !dbg !607
  store i64 0, ptr %slot.k, align 8, !dbg !607
  %slot.__sc_195 = alloca i64, align 8, !dbg !607
  store i64 0, ptr %slot.__sc_195, align 8, !dbg !607
  %r0 = load i64, ptr %slot.sm, align 8, !dbg !608
  %r1 = add i64 0, 0, !dbg !608
  %r2 = call i64 @nova_rt_index_get(i64 %r0, i64 %r1), !dbg !608
  store i64 %r2, ptr %slot.pairs, align 8, !dbg !608
  %r3 = call i64 @nova_rt_list_create(), !dbg !609
  store i64 %r3, ptr %slot.result, align 8, !dbg !609
  %r4 = add i64 0, 0, !dbg !610
  store i64 %r4, ptr %slot.i, align 8, !dbg !610
  br label %while_hdr192, !dbg !611
while_hdr192:
  %r5 = load i64, ptr %slot.i, align 8, !dbg !611
  %r6 = load i64, ptr %slot.pairs, align 8, !dbg !611
  %r7 = call i64 @nova_rt_len_any(i64 %r6), !dbg !611
  %r8.cmp = icmp slt i64 %r5, %r7, !dbg !611
  %r8 = zext i1 %r8.cmp to i64, !dbg !611
  %br_while_body193 = icmp ne i64 %r8, 0, !dbg !611
  br i1 %br_while_body193, label %while_body193, label %while_exit194, !prof !90, !dbg !611
while_body193:
  %r9 = load i64, ptr %slot.pairs, align 8, !dbg !612
  %r10 = load i64, ptr %slot.i, align 8, !dbg !612
  %r11 = call i64 @nova_rt_index_get(i64 %r9, i64 %r10), !dbg !612
  %r12 = add i64 0, 0, !dbg !612
  %r13 = call i64 @nova_rt_index_get(i64 %r11, i64 %r12), !dbg !612
  store i64 %r13, ptr %slot.k, align 8, !dbg !612
  %r14 = add i64 %r13, 0, !dbg !613
  %r15 = load i64, ptr %slot.lo_key, align 8, !dbg !613
  %r16.cmp = icmp sge i64 %r14, %r15, !dbg !613
  %r16 = zext i1 %r16.cmp to i64, !dbg !613
  store i64 %r16, ptr %slot.__sc_195, align 8, !dbg !613
  %br_and_rhs196 = icmp ne i64 %r16, 0, !dbg !613
  br i1 %br_and_rhs196, label %and_rhs196, label %and_merge197, !dbg !613
and_rhs196:
  %r17 = load i64, ptr %slot.k, align 8, !dbg !613
  %r18 = load i64, ptr %slot.hi_key, align 8, !dbg !613
  %r19.cmp = icmp sle i64 %r17, %r18, !dbg !613
  %r19 = zext i1 %r19.cmp to i64, !dbg !613
  store i64 %r19, ptr %slot.__sc_195, align 8, !dbg !613
  br label %and_merge197, !dbg !613
and_merge197:
  %r20 = load i64, ptr %slot.__sc_195, align 8, !dbg !613
  %br_then198 = icmp ne i64 %r20, 0, !dbg !613
  br i1 %br_then198, label %then198, label %else199, !dbg !613
then198:
  %r21 = load i64, ptr %slot.result, align 8, !dbg !614
  %r22 = load i64, ptr %slot.pairs, align 8, !dbg !614
  %r23 = load i64, ptr %slot.i, align 8, !dbg !614
  %r24 = call i64 @nova_rt_index_get(i64 %r22, i64 %r23), !dbg !614
  %r25 = call i64 @nova_rt_list_append(i64 %r21, i64 %r24), !dbg !614
  br label %endif200, !dbg !614
else199:
  br label %endif200, !dbg !614
endif200:
  %r26 = load i64, ptr %slot.i, align 8, !dbg !615
  %r27 = add i64 1, 0, !dbg !615
  %r28 = add i64 %r26, %r27, !dbg !615
  store i64 %r28, ptr %slot.i, align 8, !dbg !615
  br label %while_hdr192, !dbg !615
while_exit194:
  %r29 = load i64, ptr %slot.result, align 8, !dbg !616
  ret i64 %r29, !dbg !616
}

define i64 @ring_new(i64 %p0) nounwind !dbg !617 {
entry:
  %slot.capacity = alloca i64, align 8, !dbg !618
  store i64 %p0, ptr %slot.capacity, align 8, !dbg !618
  %slot.backing = alloca i64, align 8, !dbg !618
  store i64 0, ptr %slot.backing, align 8, !dbg !618
  %slot.i = alloca i64, align 8, !dbg !618
  store i64 0, ptr %slot.i, align 8, !dbg !618
  %r0 = call i64 @nova_rt_list_create(), !dbg !619
  store i64 %r0, ptr %slot.backing, align 8, !dbg !619
  %r1 = add i64 0, 0, !dbg !620
  store i64 %r1, ptr %slot.i, align 8, !dbg !620
  br label %while_hdr201, !dbg !621
while_hdr201:
  %r2 = load i64, ptr %slot.i, align 8, !dbg !621
  %r3 = load i64, ptr %slot.capacity, align 8, !dbg !621
  %r4.cmp = icmp slt i64 %r2, %r3, !dbg !621
  %r4 = zext i1 %r4.cmp to i64, !dbg !621
  %br_while_body202 = icmp ne i64 %r4, 0, !dbg !621
  br i1 %br_while_body202, label %while_body202, label %while_exit203, !prof !90, !dbg !621
while_body202:
  %r5 = load i64, ptr %slot.backing, align 8, !dbg !622
  %r6 = add i64 0, 0, !dbg !622
  %r7 = call i64 @nova_rt_list_append(i64 %r5, i64 %r6), !dbg !622
  %r8 = load i64, ptr %slot.i, align 8, !dbg !623
  %r9 = add i64 1, 0, !dbg !623
  %r10 = add i64 %r8, %r9, !dbg !623
  store i64 %r10, ptr %slot.i, align 8, !dbg !623
  br label %while_hdr201, !dbg !623
while_exit203:
  %r12 = load i64, ptr %slot.backing, align 8, !dbg !624
  %r13 = add i64 0, 0, !dbg !624
  %r14 = add i64 0, 0, !dbg !624
  %r15 = load i64, ptr %slot.capacity, align 8, !dbg !624
  %r16 = add i64 0, 0, !dbg !624
  %r11 = call i64 @nova_rt_list_create(), !dbg !624
  call i64 @nova_rt_list_append(i64 %r11, i64 %r12), !dbg !624
  call i64 @nova_rt_list_append(i64 %r11, i64 %r13), !dbg !624
  call i64 @nova_rt_list_append(i64 %r11, i64 %r14), !dbg !624
  call i64 @nova_rt_list_append(i64 %r11, i64 %r15), !dbg !624
  call i64 @nova_rt_list_append(i64 %r11, i64 %r16), !dbg !624
  ret i64 %r11, !dbg !624
}

define i64 @ring_push(i64 %p0, i64 %p1) nounwind !dbg !625 {
entry:
  %slot.r = alloca i64, align 8, !dbg !626
  store i64 %p0, ptr %slot.r, align 8, !dbg !626
  %slot.item = alloca i64, align 8, !dbg !626
  store i64 %p1, ptr %slot.item, align 8, !dbg !626
  %slot.count = alloca i64, align 8, !dbg !626
  store i64 0, ptr %slot.count, align 8, !dbg !626
  %slot.cap = alloca i64, align 8, !dbg !626
  store i64 0, ptr %slot.cap, align 8, !dbg !626
  %slot.backing = alloca i64, align 8, !dbg !626
  store i64 0, ptr %slot.backing, align 8, !dbg !626
  %slot.tail = alloca i64, align 8, !dbg !626
  store i64 0, ptr %slot.tail, align 8, !dbg !626
  %r0 = load i64, ptr %slot.r, align 8, !dbg !627
  %r1 = add i64 4, 0, !dbg !627
  %r2 = call i64 @nova_rt_index_get(i64 %r0, i64 %r1), !dbg !627
  store i64 %r2, ptr %slot.count, align 8, !dbg !627
  %r3 = load i64, ptr %slot.r, align 8, !dbg !628
  %r4 = add i64 3, 0, !dbg !628
  %r5 = call i64 @nova_rt_index_get(i64 %r3, i64 %r4), !dbg !628
  store i64 %r5, ptr %slot.cap, align 8, !dbg !628
  %r6 = add i64 %r2, 0, !dbg !629
  %r7 = add i64 %r5, 0, !dbg !629
  %r8.cmp = icmp sge i64 %r6, %r7, !dbg !629
  %r8 = zext i1 %r8.cmp to i64, !dbg !629
  %br_then204 = icmp ne i64 %r8, 0, !dbg !629
  br i1 %br_then204, label %then204, label %else205, !dbg !629
then204:
  %r9 = add i64 0, 0, !dbg !630
  ret i64 %r9, !dbg !630
else205:
  br label %endif206, !dbg !630
endif206:
  %r10 = load i64, ptr %slot.r, align 8, !dbg !631
  %r11 = add i64 0, 0, !dbg !631
  %r12 = call i64 @nova_rt_index_get(i64 %r10, i64 %r11), !dbg !631
  store i64 %r12, ptr %slot.backing, align 8, !dbg !631
  %r13 = load i64, ptr %slot.r, align 8, !dbg !632
  %r14 = add i64 2, 0, !dbg !632
  %r15 = call i64 @nova_rt_index_get(i64 %r13, i64 %r14), !dbg !632
  store i64 %r15, ptr %slot.tail, align 8, !dbg !632
  %r16 = load i64, ptr %slot.item, align 8, !dbg !633
  %r17 = add i64 %r12, 0, !dbg !633
  %r18 = add i64 %r15, 0, !dbg !633
  %_is.gv0 = call i64 @nova_rt_index_set(i64 %r17, i64 %r18, i64 %r16), !dbg !633
  %r19 = add i64 %r15, 0, !dbg !634
  %r20 = add i64 1, 0, !dbg !634
  %r21 = call i64 @nova_rt_add(i64 %r19, i64 %r20), !dbg !634
  %r22 = load i64, ptr %slot.cap, align 8, !dbg !634
  %r23 = srem i64 %r21, %r22, !dbg !634
  %r24 = load i64, ptr %slot.r, align 8, !dbg !634
  %r25 = add i64 2, 0, !dbg !634
  %_is.gv1 = call i64 @nova_rt_index_set(i64 %r24, i64 %r25, i64 %r23), !dbg !634
  %r26 = load i64, ptr %slot.count, align 8, !dbg !635
  %r27 = add i64 1, 0, !dbg !635
  %r28 = call i64 @nova_rt_add(i64 %r26, i64 %r27), !dbg !635
  %r29 = load i64, ptr %slot.r, align 8, !dbg !635
  %r30 = add i64 4, 0, !dbg !635
  %_is.gv2 = call i64 @nova_rt_index_set(i64 %r29, i64 %r30, i64 %r28), !dbg !635
  %r31 = add i64 1, 0, !dbg !636
  ret i64 %r31, !dbg !636
}

define i64 @ring_pop(i64 %p0) nounwind !dbg !637 {
entry:
  %slot.r = alloca i64, align 8, !dbg !638
  store i64 %p0, ptr %slot.r, align 8, !dbg !638
  %slot.count = alloca i64, align 8, !dbg !638
  store i64 0, ptr %slot.count, align 8, !dbg !638
  %slot.backing = alloca i64, align 8, !dbg !638
  store i64 0, ptr %slot.backing, align 8, !dbg !638
  %slot.head = alloca i64, align 8, !dbg !638
  store i64 0, ptr %slot.head, align 8, !dbg !638
  %slot.val = alloca i64, align 8, !dbg !638
  store i64 0, ptr %slot.val, align 8, !dbg !638
  %r0 = load i64, ptr %slot.r, align 8, !dbg !639
  %r1 = add i64 4, 0, !dbg !639
  %r2 = call i64 @nova_rt_index_get(i64 %r0, i64 %r1), !dbg !639
  store i64 %r2, ptr %slot.count, align 8, !dbg !639
  %r3 = add i64 %r2, 0, !dbg !640
  %r4 = add i64 0, 0, !dbg !640
  %r5 = call i64 @nova_rt_eq(i64 %r3, i64 %r4), !dbg !640
  %br_then207 = icmp ne i64 %r5, 0, !dbg !640
  br i1 %br_then207, label %then207, label %else208, !dbg !640
then207:
  %r6 = add i64 0, 0, !dbg !641
  ret i64 %r6, !dbg !641
else208:
  br label %endif209, !dbg !641
endif209:
  %r7 = load i64, ptr %slot.r, align 8, !dbg !642
  %r8 = add i64 0, 0, !dbg !642
  %r9 = call i64 @nova_rt_index_get(i64 %r7, i64 %r8), !dbg !642
  store i64 %r9, ptr %slot.backing, align 8, !dbg !642
  %r10 = load i64, ptr %slot.r, align 8, !dbg !643
  %r11 = add i64 1, 0, !dbg !643
  %r12 = call i64 @nova_rt_index_get(i64 %r10, i64 %r11), !dbg !643
  store i64 %r12, ptr %slot.head, align 8, !dbg !643
  %r13 = add i64 %r9, 0, !dbg !644
  %r14 = add i64 %r12, 0, !dbg !644
  %r15 = call i64 @nova_rt_index_get(i64 %r13, i64 %r14), !dbg !644
  store i64 %r15, ptr %slot.val, align 8, !dbg !644
  %r16 = add i64 %r12, 0, !dbg !645
  %r17 = add i64 1, 0, !dbg !645
  %r18 = call i64 @nova_rt_add(i64 %r16, i64 %r17), !dbg !645
  %r19 = load i64, ptr %slot.r, align 8, !dbg !645
  %r20 = add i64 3, 0, !dbg !645
  %r21 = call i64 @nova_rt_index_get(i64 %r19, i64 %r20), !dbg !645
  %r22 = srem i64 %r18, %r21, !dbg !645
  %r23 = load i64, ptr %slot.r, align 8, !dbg !645
  %r24 = add i64 1, 0, !dbg !645
  %_is.gv0 = call i64 @nova_rt_index_set(i64 %r23, i64 %r24, i64 %r22), !dbg !645
  %r25 = load i64, ptr %slot.count, align 8, !dbg !646
  %r26 = add i64 1, 0, !dbg !646
  %r27 = call i64 @nova_rt_sub(i64 %r25, i64 %r26), !dbg !646
  %r28 = load i64, ptr %slot.r, align 8, !dbg !646
  %r29 = add i64 4, 0, !dbg !646
  %_is.gv1 = call i64 @nova_rt_index_set(i64 %r28, i64 %r29, i64 %r27), !dbg !646
  %r30 = add i64 %r15, 0, !dbg !647
  ret i64 %r30, !dbg !647
}

define i64 @ring_peek(i64 %p0) nounwind !dbg !648 {
entry:
  %slot.r = alloca i64, align 8, !dbg !649
  store i64 %p0, ptr %slot.r, align 8, !dbg !649
  %r0 = load i64, ptr %slot.r, align 8, !dbg !650
  %r1 = add i64 4, 0, !dbg !650
  %r2 = call i64 @nova_rt_index_get(i64 %r0, i64 %r1), !dbg !650
  %r3 = add i64 0, 0, !dbg !650
  %r4 = call i64 @nova_rt_eq(i64 %r2, i64 %r3), !dbg !650
  %br_then210 = icmp ne i64 %r4, 0, !dbg !650
  br i1 %br_then210, label %then210, label %else211, !dbg !650
then210:
  %r5 = add i64 0, 0, !dbg !651
  ret i64 %r5, !dbg !651
else211:
  br label %endif212, !dbg !651
endif212:
  %r6 = load i64, ptr %slot.r, align 8, !dbg !652
  %r7 = add i64 0, 0, !dbg !652
  %r8 = call i64 @nova_rt_index_get(i64 %r6, i64 %r7), !dbg !652
  %r9 = load i64, ptr %slot.r, align 8, !dbg !652
  %r10 = add i64 1, 0, !dbg !652
  %r11 = call i64 @nova_rt_index_get(i64 %r9, i64 %r10), !dbg !652
  %r12 = call i64 @nova_rt_index_get(i64 %r8, i64 %r11), !dbg !652
  ret i64 %r12, !dbg !652
}

define i64 @ring_size(i64 %p0) nounwind !dbg !653 {
entry:
  %slot.r = alloca i64, align 8, !dbg !654
  store i64 %p0, ptr %slot.r, align 8, !dbg !654
  %r0 = load i64, ptr %slot.r, align 8, !dbg !655
  %r1 = add i64 4, 0, !dbg !655
  %r2 = call i64 @nova_rt_index_get(i64 %r0, i64 %r1), !dbg !655
  ret i64 %r2, !dbg !655
}

define i64 @ring_capacity(i64 %p0) nounwind !dbg !656 {
entry:
  %slot.r = alloca i64, align 8, !dbg !657
  store i64 %p0, ptr %slot.r, align 8, !dbg !657
  %r0 = load i64, ptr %slot.r, align 8, !dbg !658
  %r1 = add i64 3, 0, !dbg !658
  %r2 = call i64 @nova_rt_index_get(i64 %r0, i64 %r1), !dbg !658
  ret i64 %r2, !dbg !658
}

define i64 @ring_is_full(i64 %p0) nounwind !dbg !659 {
entry:
  %slot.r = alloca i64, align 8, !dbg !660
  store i64 %p0, ptr %slot.r, align 8, !dbg !660
  %r0 = load i64, ptr %slot.r, align 8, !dbg !661
  %r1 = add i64 4, 0, !dbg !661
  %r2 = call i64 @nova_rt_index_get(i64 %r0, i64 %r1), !dbg !661
  %r3 = load i64, ptr %slot.r, align 8, !dbg !661
  %r4 = add i64 3, 0, !dbg !661
  %r5 = call i64 @nova_rt_index_get(i64 %r3, i64 %r4), !dbg !661
  %r6.cmp = icmp sge i64 %r2, %r5, !dbg !661
  %r6 = zext i1 %r6.cmp to i64, !dbg !661
  ret i64 %r6, !dbg !661
}

define i64 @ring_is_empty(i64 %p0) nounwind !dbg !662 {
entry:
  %slot.r = alloca i64, align 8, !dbg !663
  store i64 %p0, ptr %slot.r, align 8, !dbg !663
  %r0 = load i64, ptr %slot.r, align 8, !dbg !664
  %r1 = add i64 4, 0, !dbg !664
  %r2 = call i64 @nova_rt_index_get(i64 %r0, i64 %r1), !dbg !664
  %r3 = add i64 0, 0, !dbg !664
  %r4 = call i64 @nova_rt_eq(i64 %r2, i64 %r3), !dbg !664
  ret i64 %r4, !dbg !664
}

define i64 @nova_main() nounwind {
entry:
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

; Debug metadata
!llvm.dbg.cu = !{!100}
!llvm.module.flags = !{!102, !103}

!100 = distinct !DICompileUnit(language: DW_LANG_C99, file: !101, producer: "NOVA Compiler", isOptimized: false, emissionKind: LineTablesOnly)
!101 = !DIFile(filename: "__lsp_check__.nova", directory: ".")
!102 = !{i32 2, !"CodeView", i32 1}
!103 = !{i32 2, !"Debug Info Version", i32 3}
!104 = !DISubroutineType(types: !105)
!105 = !{null}
!200 = distinct !DISubprogram(name: "set_new", scope: !101, file: !101, line: 9, type: !104, scopeLine: 9, spFlags: DISPFlagDefinition, unit: !100)
!201 = !DILocation(line: 9, column: 0, scope: !200)
!204 = distinct !DISubprogram(name: "set_add", scope: !101, file: !101, line: 13, type: !104, scopeLine: 13, spFlags: DISPFlagDefinition, unit: !100)
!205 = !DILocation(line: 13, column: 0, scope: !204)
!214 = distinct !DISubprogram(name: "set_remove", scope: !101, file: !101, line: 23, type: !104, scopeLine: 23, spFlags: DISPFlagDefinition, unit: !100)
!215 = !DILocation(line: 23, column: 0, scope: !214)
!225 = distinct !DISubprogram(name: "set_contains", scope: !101, file: !101, line: 34, type: !104, scopeLine: 34, spFlags: DISPFlagDefinition, unit: !100)
!226 = !DILocation(line: 34, column: 0, scope: !225)
!234 = distinct !DISubprogram(name: "set_size", scope: !101, file: !101, line: 43, type: !104, scopeLine: 43, spFlags: DISPFlagDefinition, unit: !100)
!235 = !DILocation(line: 43, column: 0, scope: !234)
!237 = distinct !DISubprogram(name: "set_union", scope: !101, file: !101, line: 46, type: !104, scopeLine: 46, spFlags: DISPFlagDefinition, unit: !100)
!238 = !DILocation(line: 46, column: 0, scope: !237)
!251 = distinct !DISubprogram(name: "set_intersection", scope: !101, file: !101, line: 60, type: !104, scopeLine: 60, spFlags: DISPFlagDefinition, unit: !100)
!252 = !DILocation(line: 60, column: 0, scope: !251)
!261 = distinct !DISubprogram(name: "set_difference", scope: !101, file: !101, line: 70, type: !104, scopeLine: 70, spFlags: DISPFlagDefinition, unit: !100)
!262 = !DILocation(line: 70, column: 0, scope: !261)
!271 = distinct !DISubprogram(name: "set_to_list", scope: !101, file: !101, line: 80, type: !104, scopeLine: 80, spFlags: DISPFlagDefinition, unit: !100)
!272 = !DILocation(line: 80, column: 0, scope: !271)
!280 = distinct !DISubprogram(name: "deque_new", scope: !101, file: !101, line: 93, type: !104, scopeLine: 93, spFlags: DISPFlagDefinition, unit: !100)
!281 = !DILocation(line: 93, column: 0, scope: !280)
!284 = distinct !DISubprogram(name: "deque_push_back", scope: !101, file: !101, line: 97, type: !104, scopeLine: 97, spFlags: DISPFlagDefinition, unit: !100)
!285 = !DILocation(line: 97, column: 0, scope: !284)
!288 = distinct !DISubprogram(name: "deque_push_front", scope: !101, file: !101, line: 101, type: !104, scopeLine: 101, spFlags: DISPFlagDefinition, unit: !100)
!289 = !DILocation(line: 101, column: 0, scope: !288)
!297 = distinct !DISubprogram(name: "deque_pop_back", scope: !101, file: !101, line: 110, type: !104, scopeLine: 110, spFlags: DISPFlagDefinition, unit: !100)
!298 = !DILocation(line: 110, column: 0, scope: !297)
!306 = distinct !DISubprogram(name: "deque_pop_front", scope: !101, file: !101, line: 119, type: !104, scopeLine: 119, spFlags: DISPFlagDefinition, unit: !100)
!307 = !DILocation(line: 119, column: 0, scope: !306)
!315 = distinct !DISubprogram(name: "deque_peek_front", scope: !101, file: !101, line: 128, type: !104, scopeLine: 128, spFlags: DISPFlagDefinition, unit: !100)
!316 = !DILocation(line: 128, column: 0, scope: !315)
!321 = distinct !DISubprogram(name: "deque_peek_back", scope: !101, file: !101, line: 134, type: !104, scopeLine: 134, spFlags: DISPFlagDefinition, unit: !100)
!322 = !DILocation(line: 134, column: 0, scope: !321)
!328 = distinct !DISubprogram(name: "deque_size", scope: !101, file: !101, line: 141, type: !104, scopeLine: 141, spFlags: DISPFlagDefinition, unit: !100)
!329 = !DILocation(line: 141, column: 0, scope: !328)
!331 = distinct !DISubprogram(name: "pq_new", scope: !101, file: !101, line: 148, type: !104, scopeLine: 148, spFlags: DISPFlagDefinition, unit: !100)
!332 = !DILocation(line: 148, column: 0, scope: !331)
!335 = distinct !DISubprogram(name: "pq_push", scope: !101, file: !101, line: 152, type: !104, scopeLine: 152, spFlags: DISPFlagDefinition, unit: !100)
!336 = !DILocation(line: 152, column: 0, scope: !335)
!341 = distinct !DISubprogram(name: "pq_pop", scope: !101, file: !101, line: 158, type: !104, scopeLine: 158, spFlags: DISPFlagDefinition, unit: !100)
!342 = !DILocation(line: 158, column: 0, scope: !341)
!356 = distinct !DISubprogram(name: "pq_peek", scope: !101, file: !101, line: 173, type: !104, scopeLine: 173, spFlags: DISPFlagDefinition, unit: !100)
!357 = !DILocation(line: 173, column: 0, scope: !356)
!362 = distinct !DISubprogram(name: "pq_size", scope: !101, file: !101, line: 179, type: !104, scopeLine: 179, spFlags: DISPFlagDefinition, unit: !100)
!363 = !DILocation(line: 179, column: 0, scope: !362)
!365 = distinct !DISubprogram(name: "_pq_sift_up", scope: !101, file: !101, line: 182, type: !104, scopeLine: 182, spFlags: DISPFlagDefinition, unit: !100)
!366 = !DILocation(line: 182, column: 0, scope: !365)
!373 = distinct !DISubprogram(name: "_pq_sift_down", scope: !101, file: !101, line: 191, type: !104, scopeLine: 191, spFlags: DISPFlagDefinition, unit: !100)
!374 = !DILocation(line: 191, column: 0, scope: !373)
!390 = distinct !DISubprogram(name: "_pq_swap", scope: !101, file: !101, line: 208, type: !104, scopeLine: 208, spFlags: DISPFlagDefinition, unit: !100)
!391 = !DILocation(line: 208, column: 0, scope: !390)
!395 = distinct !DISubprogram(name: "counter_new", scope: !101, file: !101, line: 217, type: !104, scopeLine: 217, spFlags: DISPFlagDefinition, unit: !100)
!396 = !DILocation(line: 217, column: 0, scope: !395)
!399 = distinct !DISubprogram(name: "counter_add", scope: !101, file: !101, line: 221, type: !104, scopeLine: 221, spFlags: DISPFlagDefinition, unit: !100)
!400 = !DILocation(line: 221, column: 0, scope: !399)
!411 = distinct !DISubprogram(name: "counter_add_n", scope: !101, file: !101, line: 234, type: !104, scopeLine: 234, spFlags: DISPFlagDefinition, unit: !100)
!412 = !DILocation(line: 234, column: 0, scope: !411)
!423 = distinct !DISubprogram(name: "counter_count", scope: !101, file: !101, line: 247, type: !104, scopeLine: 247, spFlags: DISPFlagDefinition, unit: !100)
!424 = !DILocation(line: 247, column: 0, scope: !423)
!432 = distinct !DISubprogram(name: "counter_total", scope: !101, file: !101, line: 256, type: !104, scopeLine: 256, spFlags: DISPFlagDefinition, unit: !100)
!433 = !DILocation(line: 256, column: 0, scope: !432)
!438 = distinct !DISubprogram(name: "counter_most_common", scope: !101, file: !101, line: 262, type: !104, scopeLine: 262, spFlags: DISPFlagDefinition, unit: !100)
!439 = !DILocation(line: 262, column: 0, scope: !438)
!463 = distinct !DISubprogram(name: "lru_new", scope: !101, file: !101, line: 293, type: !104, scopeLine: 293, spFlags: DISPFlagDefinition, unit: !100)
!464 = !DILocation(line: 293, column: 0, scope: !463)
!468 = distinct !DISubprogram(name: "lru_get", scope: !101, file: !101, line: 298, type: !104, scopeLine: 298, spFlags: DISPFlagDefinition, unit: !100)
!469 = !DILocation(line: 298, column: 0, scope: !468)
!476 = distinct !DISubprogram(name: "lru_put", scope: !101, file: !101, line: 306, type: !104, scopeLine: 306, spFlags: DISPFlagDefinition, unit: !100)
!477 = !DILocation(line: 306, column: 0, scope: !476)
!492 = distinct !DISubprogram(name: "lru_size", scope: !101, file: !101, line: 323, type: !104, scopeLine: 323, spFlags: DISPFlagDefinition, unit: !100)
!493 = !DILocation(line: 323, column: 0, scope: !492)
!495 = distinct !DISubprogram(name: "_lru_move_to_end", scope: !101, file: !101, line: 326, type: !104, scopeLine: 326, spFlags: DISPFlagDefinition, unit: !100)
!496 = !DILocation(line: 326, column: 0, scope: !495)
!508 = distinct !DISubprogram(name: "_lru_find_index", scope: !101, file: !101, line: 339, type: !104, scopeLine: 339, spFlags: DISPFlagDefinition, unit: !100)
!509 = !DILocation(line: 339, column: 0, scope: !508)
!516 = distinct !DISubprogram(name: "sorted_map_new", scope: !101, file: !101, line: 353, type: !104, scopeLine: 353, spFlags: DISPFlagDefinition, unit: !100)
!517 = !DILocation(line: 353, column: 0, scope: !516)
!520 = distinct !DISubprogram(name: "_sm_bsearch", scope: !101, file: !101, line: 357, type: !104, scopeLine: 357, spFlags: DISPFlagDefinition, unit: !100)
!521 = !DILocation(line: 357, column: 0, scope: !520)
!533 = distinct !DISubprogram(name: "sorted_map_set", scope: !101, file: !101, line: 371, type: !104, scopeLine: 371, spFlags: DISPFlagDefinition, unit: !100)
!534 = !DILocation(line: 371, column: 0, scope: !533)
!548 = distinct !DISubprogram(name: "sorted_map_get", scope: !101, file: !101, line: 386, type: !104, scopeLine: 386, spFlags: DISPFlagDefinition, unit: !100)
!549 = !DILocation(line: 386, column: 0, scope: !548)
!555 = distinct !DISubprogram(name: "sorted_map_has", scope: !101, file: !101, line: 393, type: !104, scopeLine: 393, spFlags: DISPFlagDefinition, unit: !100)
!556 = !DILocation(line: 393, column: 0, scope: !555)
!559 = distinct !DISubprogram(name: "sorted_map_remove", scope: !101, file: !101, line: 397, type: !104, scopeLine: 397, spFlags: DISPFlagDefinition, unit: !100)
!560 = !DILocation(line: 397, column: 0, scope: !559)
!573 = distinct !DISubprogram(name: "sorted_map_size", scope: !101, file: !101, line: 411, type: !104, scopeLine: 411, spFlags: DISPFlagDefinition, unit: !100)
!574 = !DILocation(line: 411, column: 0, scope: !573)
!576 = distinct !DISubprogram(name: "sorted_map_keys", scope: !101, file: !101, line: 414, type: !104, scopeLine: 414, spFlags: DISPFlagDefinition, unit: !100)
!577 = !DILocation(line: 414, column: 0, scope: !576)
!585 = distinct !DISubprogram(name: "sorted_map_values", scope: !101, file: !101, line: 423, type: !104, scopeLine: 423, spFlags: DISPFlagDefinition, unit: !100)
!586 = !DILocation(line: 423, column: 0, scope: !585)
!594 = distinct !DISubprogram(name: "sorted_map_min_key", scope: !101, file: !101, line: 432, type: !104, scopeLine: 432, spFlags: DISPFlagDefinition, unit: !100)
!595 = !DILocation(line: 432, column: 0, scope: !594)
!600 = distinct !DISubprogram(name: "sorted_map_max_key", scope: !101, file: !101, line: 438, type: !104, scopeLine: 438, spFlags: DISPFlagDefinition, unit: !100)
!601 = !DILocation(line: 438, column: 0, scope: !600)
!606 = distinct !DISubprogram(name: "sorted_map_range", scope: !101, file: !101, line: 444, type: !104, scopeLine: 444, spFlags: DISPFlagDefinition, unit: !100)
!607 = !DILocation(line: 444, column: 0, scope: !606)
!617 = distinct !DISubprogram(name: "ring_new", scope: !101, file: !101, line: 459, type: !104, scopeLine: 459, spFlags: DISPFlagDefinition, unit: !100)
!618 = !DILocation(line: 459, column: 0, scope: !617)
!625 = distinct !DISubprogram(name: "ring_push", scope: !101, file: !101, line: 467, type: !104, scopeLine: 467, spFlags: DISPFlagDefinition, unit: !100)
!626 = !DILocation(line: 467, column: 0, scope: !625)
!637 = distinct !DISubprogram(name: "ring_pop", scope: !101, file: !101, line: 479, type: !104, scopeLine: 479, spFlags: DISPFlagDefinition, unit: !100)
!638 = !DILocation(line: 479, column: 0, scope: !637)
!648 = distinct !DISubprogram(name: "ring_peek", scope: !101, file: !101, line: 490, type: !104, scopeLine: 490, spFlags: DISPFlagDefinition, unit: !100)
!649 = !DILocation(line: 490, column: 0, scope: !648)
!653 = distinct !DISubprogram(name: "ring_size", scope: !101, file: !101, line: 495, type: !104, scopeLine: 495, spFlags: DISPFlagDefinition, unit: !100)
!654 = !DILocation(line: 495, column: 0, scope: !653)
!656 = distinct !DISubprogram(name: "ring_capacity", scope: !101, file: !101, line: 498, type: !104, scopeLine: 498, spFlags: DISPFlagDefinition, unit: !100)
!657 = !DILocation(line: 498, column: 0, scope: !656)
!659 = distinct !DISubprogram(name: "ring_is_full", scope: !101, file: !101, line: 501, type: !104, scopeLine: 501, spFlags: DISPFlagDefinition, unit: !100)
!660 = !DILocation(line: 501, column: 0, scope: !659)
!662 = distinct !DISubprogram(name: "ring_is_empty", scope: !101, file: !101, line: 504, type: !104, scopeLine: 504, spFlags: DISPFlagDefinition, unit: !100)
!663 = !DILocation(line: 504, column: 0, scope: !662)
!202 = !DILocation(line: 10, column: 0, scope: !200)
!203 = !DILocation(line: 11, column: 0, scope: !200)
!206 = !DILocation(line: 14, column: 0, scope: !204)
!207 = !DILocation(line: 15, column: 0, scope: !204)
!208 = !DILocation(line: 16, column: 0, scope: !204)
!209 = !DILocation(line: 17, column: 0, scope: !204)
!210 = !DILocation(line: 18, column: 0, scope: !204)
!211 = !DILocation(line: 19, column: 0, scope: !204)
!212 = !DILocation(line: 20, column: 0, scope: !204)
!213 = !DILocation(line: 21, column: 0, scope: !204)
!216 = !DILocation(line: 24, column: 0, scope: !214)
!217 = !DILocation(line: 25, column: 0, scope: !214)
!218 = !DILocation(line: 26, column: 0, scope: !214)
!219 = !DILocation(line: 27, column: 0, scope: !214)
!220 = !DILocation(line: 28, column: 0, scope: !214)
!221 = !DILocation(line: 29, column: 0, scope: !214)
!222 = !DILocation(line: 30, column: 0, scope: !214)
!223 = !DILocation(line: 31, column: 0, scope: !214)
!224 = !DILocation(line: 32, column: 0, scope: !214)
!227 = !DILocation(line: 35, column: 0, scope: !225)
!228 = !DILocation(line: 36, column: 0, scope: !225)
!229 = !DILocation(line: 37, column: 0, scope: !225)
!230 = !DILocation(line: 38, column: 0, scope: !225)
!231 = !DILocation(line: 39, column: 0, scope: !225)
!232 = !DILocation(line: 40, column: 0, scope: !225)
!233 = !DILocation(line: 41, column: 0, scope: !225)
!236 = !DILocation(line: 44, column: 0, scope: !234)
!239 = !DILocation(line: 47, column: 0, scope: !237)
!240 = !DILocation(line: 48, column: 0, scope: !237)
!241 = !DILocation(line: 49, column: 0, scope: !237)
!242 = !DILocation(line: 50, column: 0, scope: !237)
!243 = !DILocation(line: 51, column: 0, scope: !237)
!244 = !DILocation(line: 52, column: 0, scope: !237)
!245 = !DILocation(line: 53, column: 0, scope: !237)
!246 = !DILocation(line: 54, column: 0, scope: !237)
!247 = !DILocation(line: 55, column: 0, scope: !237)
!248 = !DILocation(line: 56, column: 0, scope: !237)
!249 = !DILocation(line: 57, column: 0, scope: !237)
!250 = !DILocation(line: 58, column: 0, scope: !237)
!253 = !DILocation(line: 61, column: 0, scope: !251)
!254 = !DILocation(line: 62, column: 0, scope: !251)
!255 = !DILocation(line: 63, column: 0, scope: !251)
!256 = !DILocation(line: 64, column: 0, scope: !251)
!257 = !DILocation(line: 65, column: 0, scope: !251)
!258 = !DILocation(line: 66, column: 0, scope: !251)
!259 = !DILocation(line: 67, column: 0, scope: !251)
!260 = !DILocation(line: 68, column: 0, scope: !251)
!263 = !DILocation(line: 71, column: 0, scope: !261)
!264 = !DILocation(line: 72, column: 0, scope: !261)
!265 = !DILocation(line: 73, column: 0, scope: !261)
!266 = !DILocation(line: 74, column: 0, scope: !261)
!267 = !DILocation(line: 75, column: 0, scope: !261)
!268 = !DILocation(line: 76, column: 0, scope: !261)
!269 = !DILocation(line: 77, column: 0, scope: !261)
!270 = !DILocation(line: 78, column: 0, scope: !261)
!273 = !DILocation(line: 81, column: 0, scope: !271)
!274 = !DILocation(line: 82, column: 0, scope: !271)
!275 = !DILocation(line: 83, column: 0, scope: !271)
!276 = !DILocation(line: 84, column: 0, scope: !271)
!277 = !DILocation(line: 85, column: 0, scope: !271)
!278 = !DILocation(line: 86, column: 0, scope: !271)
!279 = !DILocation(line: 87, column: 0, scope: !271)
!282 = !DILocation(line: 94, column: 0, scope: !280)
!283 = !DILocation(line: 95, column: 0, scope: !280)
!286 = !DILocation(line: 98, column: 0, scope: !284)
!287 = !DILocation(line: 99, column: 0, scope: !284)
!290 = !DILocation(line: 102, column: 0, scope: !288)
!291 = !DILocation(line: 103, column: 0, scope: !288)
!292 = !DILocation(line: 104, column: 0, scope: !288)
!293 = !DILocation(line: 105, column: 0, scope: !288)
!294 = !DILocation(line: 106, column: 0, scope: !288)
!295 = !DILocation(line: 107, column: 0, scope: !288)
!296 = !DILocation(line: 108, column: 0, scope: !288)
!299 = !DILocation(line: 111, column: 0, scope: !297)
!300 = !DILocation(line: 112, column: 0, scope: !297)
!301 = !DILocation(line: 113, column: 0, scope: !297)
!302 = !DILocation(line: 114, column: 0, scope: !297)
!303 = !DILocation(line: 115, column: 0, scope: !297)
!304 = !DILocation(line: 116, column: 0, scope: !297)
!305 = !DILocation(line: 117, column: 0, scope: !297)
!308 = !DILocation(line: 120, column: 0, scope: !306)
!309 = !DILocation(line: 121, column: 0, scope: !306)
!310 = !DILocation(line: 122, column: 0, scope: !306)
!311 = !DILocation(line: 123, column: 0, scope: !306)
!312 = !DILocation(line: 124, column: 0, scope: !306)
!313 = !DILocation(line: 125, column: 0, scope: !306)
!314 = !DILocation(line: 126, column: 0, scope: !306)
!317 = !DILocation(line: 129, column: 0, scope: !315)
!318 = !DILocation(line: 130, column: 0, scope: !315)
!319 = !DILocation(line: 131, column: 0, scope: !315)
!320 = !DILocation(line: 132, column: 0, scope: !315)
!323 = !DILocation(line: 135, column: 0, scope: !321)
!324 = !DILocation(line: 136, column: 0, scope: !321)
!325 = !DILocation(line: 137, column: 0, scope: !321)
!326 = !DILocation(line: 138, column: 0, scope: !321)
!327 = !DILocation(line: 139, column: 0, scope: !321)
!330 = !DILocation(line: 142, column: 0, scope: !328)
!333 = !DILocation(line: 149, column: 0, scope: !331)
!334 = !DILocation(line: 150, column: 0, scope: !331)
!337 = !DILocation(line: 153, column: 0, scope: !335)
!338 = !DILocation(line: 154, column: 0, scope: !335)
!339 = !DILocation(line: 155, column: 0, scope: !335)
!340 = !DILocation(line: 156, column: 0, scope: !335)
!343 = !DILocation(line: 159, column: 0, scope: !341)
!344 = !DILocation(line: 160, column: 0, scope: !341)
!345 = !DILocation(line: 161, column: 0, scope: !341)
!346 = !DILocation(line: 162, column: 0, scope: !341)
!347 = !DILocation(line: 163, column: 0, scope: !341)
!348 = !DILocation(line: 164, column: 0, scope: !341)
!349 = !DILocation(line: 165, column: 0, scope: !341)
!350 = !DILocation(line: 166, column: 0, scope: !341)
!351 = !DILocation(line: 167, column: 0, scope: !341)
!352 = !DILocation(line: 168, column: 0, scope: !341)
!353 = !DILocation(line: 169, column: 0, scope: !341)
!354 = !DILocation(line: 170, column: 0, scope: !341)
!355 = !DILocation(line: 171, column: 0, scope: !341)
!358 = !DILocation(line: 174, column: 0, scope: !356)
!359 = !DILocation(line: 175, column: 0, scope: !356)
!360 = !DILocation(line: 176, column: 0, scope: !356)
!361 = !DILocation(line: 177, column: 0, scope: !356)
!364 = !DILocation(line: 180, column: 0, scope: !362)
!367 = !DILocation(line: 183, column: 0, scope: !365)
!368 = !DILocation(line: 184, column: 0, scope: !365)
!369 = !DILocation(line: 185, column: 0, scope: !365)
!370 = !DILocation(line: 186, column: 0, scope: !365)
!371 = !DILocation(line: 187, column: 0, scope: !365)
!372 = !DILocation(line: 189, column: 0, scope: !365)
!375 = !DILocation(line: 192, column: 0, scope: !373)
!376 = !DILocation(line: 193, column: 0, scope: !373)
!377 = !DILocation(line: 194, column: 0, scope: !373)
!378 = !DILocation(line: 195, column: 0, scope: !373)
!379 = !DILocation(line: 196, column: 0, scope: !373)
!380 = !DILocation(line: 197, column: 0, scope: !373)
!381 = !DILocation(line: 198, column: 0, scope: !373)
!382 = !DILocation(line: 199, column: 0, scope: !373)
!383 = !DILocation(line: 200, column: 0, scope: !373)
!384 = !DILocation(line: 201, column: 0, scope: !373)
!385 = !DILocation(line: 202, column: 0, scope: !373)
!386 = !DILocation(line: 203, column: 0, scope: !373)
!387 = !DILocation(line: 204, column: 0, scope: !373)
!388 = !DILocation(line: 205, column: 0, scope: !373)
!389 = !DILocation(line: 206, column: 0, scope: !373)
!392 = !DILocation(line: 209, column: 0, scope: !390)
!393 = !DILocation(line: 210, column: 0, scope: !390)
!394 = !DILocation(line: 211, column: 0, scope: !390)
!397 = !DILocation(line: 218, column: 0, scope: !395)
!398 = !DILocation(line: 219, column: 0, scope: !395)
!401 = !DILocation(line: 222, column: 0, scope: !399)
!402 = !DILocation(line: 223, column: 0, scope: !399)
!403 = !DILocation(line: 224, column: 0, scope: !399)
!404 = !DILocation(line: 225, column: 0, scope: !399)
!405 = !DILocation(line: 226, column: 0, scope: !399)
!406 = !DILocation(line: 227, column: 0, scope: !399)
!407 = !DILocation(line: 228, column: 0, scope: !399)
!408 = !DILocation(line: 229, column: 0, scope: !399)
!409 = !DILocation(line: 230, column: 0, scope: !399)
!410 = !DILocation(line: 232, column: 0, scope: !399)
!413 = !DILocation(line: 235, column: 0, scope: !411)
!414 = !DILocation(line: 236, column: 0, scope: !411)
!415 = !DILocation(line: 237, column: 0, scope: !411)
!416 = !DILocation(line: 238, column: 0, scope: !411)
!417 = !DILocation(line: 239, column: 0, scope: !411)
!418 = !DILocation(line: 240, column: 0, scope: !411)
!419 = !DILocation(line: 241, column: 0, scope: !411)
!420 = !DILocation(line: 242, column: 0, scope: !411)
!421 = !DILocation(line: 243, column: 0, scope: !411)
!422 = !DILocation(line: 245, column: 0, scope: !411)
!425 = !DILocation(line: 248, column: 0, scope: !423)
!426 = !DILocation(line: 249, column: 0, scope: !423)
!427 = !DILocation(line: 250, column: 0, scope: !423)
!428 = !DILocation(line: 251, column: 0, scope: !423)
!429 = !DILocation(line: 252, column: 0, scope: !423)
!430 = !DILocation(line: 253, column: 0, scope: !423)
!431 = !DILocation(line: 254, column: 0, scope: !423)
!434 = !DILocation(line: 257, column: 0, scope: !432)
!435 = !DILocation(line: 258, column: 0, scope: !432)
!436 = !DILocation(line: 259, column: 0, scope: !432)
!437 = !DILocation(line: 260, column: 0, scope: !432)
!440 = !DILocation(line: 263, column: 0, scope: !438)
!441 = !DILocation(line: 264, column: 0, scope: !438)
!442 = !DILocation(line: 265, column: 0, scope: !438)
!443 = !DILocation(line: 266, column: 0, scope: !438)
!444 = !DILocation(line: 267, column: 0, scope: !438)
!445 = !DILocation(line: 268, column: 0, scope: !438)
!446 = !DILocation(line: 269, column: 0, scope: !438)
!447 = !DILocation(line: 270, column: 0, scope: !438)
!448 = !DILocation(line: 271, column: 0, scope: !438)
!449 = !DILocation(line: 272, column: 0, scope: !438)
!450 = !DILocation(line: 273, column: 0, scope: !438)
!451 = !DILocation(line: 274, column: 0, scope: !438)
!452 = !DILocation(line: 275, column: 0, scope: !438)
!453 = !DILocation(line: 276, column: 0, scope: !438)
!454 = !DILocation(line: 277, column: 0, scope: !438)
!455 = !DILocation(line: 278, column: 0, scope: !438)
!456 = !DILocation(line: 279, column: 0, scope: !438)
!457 = !DILocation(line: 280, column: 0, scope: !438)
!458 = !DILocation(line: 281, column: 0, scope: !438)
!459 = !DILocation(line: 282, column: 0, scope: !438)
!460 = !DILocation(line: 283, column: 0, scope: !438)
!461 = !DILocation(line: 284, column: 0, scope: !438)
!462 = !DILocation(line: 285, column: 0, scope: !438)
!465 = !DILocation(line: 294, column: 0, scope: !463)
!466 = !DILocation(line: 295, column: 0, scope: !463)
!467 = !DILocation(line: 296, column: 0, scope: !463)
!470 = !DILocation(line: 299, column: 0, scope: !468)
!471 = !DILocation(line: 300, column: 0, scope: !468)
!472 = !DILocation(line: 301, column: 0, scope: !468)
!473 = !DILocation(line: 302, column: 0, scope: !468)
!474 = !DILocation(line: 303, column: 0, scope: !468)
!475 = !DILocation(line: 304, column: 0, scope: !468)
!478 = !DILocation(line: 307, column: 0, scope: !476)
!479 = !DILocation(line: 308, column: 0, scope: !476)
!480 = !DILocation(line: 309, column: 0, scope: !476)
!481 = !DILocation(line: 310, column: 0, scope: !476)
!482 = !DILocation(line: 311, column: 0, scope: !476)
!483 = !DILocation(line: 312, column: 0, scope: !476)
!484 = !DILocation(line: 313, column: 0, scope: !476)
!485 = !DILocation(line: 314, column: 0, scope: !476)
!486 = !DILocation(line: 315, column: 0, scope: !476)
!487 = !DILocation(line: 317, column: 0, scope: !476)
!488 = !DILocation(line: 318, column: 0, scope: !476)
!489 = !DILocation(line: 319, column: 0, scope: !476)
!490 = !DILocation(line: 320, column: 0, scope: !476)
!491 = !DILocation(line: 321, column: 0, scope: !476)
!494 = !DILocation(line: 324, column: 0, scope: !492)
!497 = !DILocation(line: 327, column: 0, scope: !495)
!498 = !DILocation(line: 328, column: 0, scope: !495)
!499 = !DILocation(line: 329, column: 0, scope: !495)
!500 = !DILocation(line: 330, column: 0, scope: !495)
!501 = !DILocation(line: 331, column: 0, scope: !495)
!502 = !DILocation(line: 332, column: 0, scope: !495)
!503 = !DILocation(line: 333, column: 0, scope: !495)
!504 = !DILocation(line: 334, column: 0, scope: !495)
!505 = !DILocation(line: 335, column: 0, scope: !495)
!506 = !DILocation(line: 336, column: 0, scope: !495)
!507 = !DILocation(line: 337, column: 0, scope: !495)
!510 = !DILocation(line: 340, column: 0, scope: !508)
!511 = !DILocation(line: 341, column: 0, scope: !508)
!512 = !DILocation(line: 342, column: 0, scope: !508)
!513 = !DILocation(line: 343, column: 0, scope: !508)
!514 = !DILocation(line: 344, column: 0, scope: !508)
!515 = !DILocation(line: 345, column: 0, scope: !508)
!518 = !DILocation(line: 354, column: 0, scope: !516)
!519 = !DILocation(line: 355, column: 0, scope: !516)
!522 = !DILocation(line: 358, column: 0, scope: !520)
!523 = !DILocation(line: 359, column: 0, scope: !520)
!524 = !DILocation(line: 360, column: 0, scope: !520)
!525 = !DILocation(line: 361, column: 0, scope: !520)
!526 = !DILocation(line: 362, column: 0, scope: !520)
!527 = !DILocation(line: 363, column: 0, scope: !520)
!528 = !DILocation(line: 364, column: 0, scope: !520)
!529 = !DILocation(line: 365, column: 0, scope: !520)
!530 = !DILocation(line: 366, column: 0, scope: !520)
!531 = !DILocation(line: 368, column: 0, scope: !520)
!532 = !DILocation(line: 369, column: 0, scope: !520)
!535 = !DILocation(line: 372, column: 0, scope: !533)
!536 = !DILocation(line: 373, column: 0, scope: !533)
!537 = !DILocation(line: 374, column: 0, scope: !533)
!538 = !DILocation(line: 375, column: 0, scope: !533)
!539 = !DILocation(line: 376, column: 0, scope: !533)
!540 = !DILocation(line: 377, column: 0, scope: !533)
!541 = !DILocation(line: 378, column: 0, scope: !533)
!542 = !DILocation(line: 379, column: 0, scope: !533)
!543 = !DILocation(line: 380, column: 0, scope: !533)
!544 = !DILocation(line: 381, column: 0, scope: !533)
!545 = !DILocation(line: 382, column: 0, scope: !533)
!546 = !DILocation(line: 383, column: 0, scope: !533)
!547 = !DILocation(line: 384, column: 0, scope: !533)
!550 = !DILocation(line: 387, column: 0, scope: !548)
!551 = !DILocation(line: 388, column: 0, scope: !548)
!552 = !DILocation(line: 389, column: 0, scope: !548)
!553 = !DILocation(line: 390, column: 0, scope: !548)
!554 = !DILocation(line: 391, column: 0, scope: !548)
!557 = !DILocation(line: 394, column: 0, scope: !555)
!558 = !DILocation(line: 395, column: 0, scope: !555)
!561 = !DILocation(line: 398, column: 0, scope: !559)
!562 = !DILocation(line: 399, column: 0, scope: !559)
!563 = !DILocation(line: 400, column: 0, scope: !559)
!564 = !DILocation(line: 401, column: 0, scope: !559)
!565 = !DILocation(line: 402, column: 0, scope: !559)
!566 = !DILocation(line: 403, column: 0, scope: !559)
!567 = !DILocation(line: 404, column: 0, scope: !559)
!568 = !DILocation(line: 405, column: 0, scope: !559)
!569 = !DILocation(line: 406, column: 0, scope: !559)
!570 = !DILocation(line: 407, column: 0, scope: !559)
!571 = !DILocation(line: 408, column: 0, scope: !559)
!572 = !DILocation(line: 409, column: 0, scope: !559)
!575 = !DILocation(line: 412, column: 0, scope: !573)
!578 = !DILocation(line: 415, column: 0, scope: !576)
!579 = !DILocation(line: 416, column: 0, scope: !576)
!580 = !DILocation(line: 417, column: 0, scope: !576)
!581 = !DILocation(line: 418, column: 0, scope: !576)
!582 = !DILocation(line: 419, column: 0, scope: !576)
!583 = !DILocation(line: 420, column: 0, scope: !576)
!584 = !DILocation(line: 421, column: 0, scope: !576)
!587 = !DILocation(line: 424, column: 0, scope: !585)
!588 = !DILocation(line: 425, column: 0, scope: !585)
!589 = !DILocation(line: 426, column: 0, scope: !585)
!590 = !DILocation(line: 427, column: 0, scope: !585)
!591 = !DILocation(line: 428, column: 0, scope: !585)
!592 = !DILocation(line: 429, column: 0, scope: !585)
!593 = !DILocation(line: 430, column: 0, scope: !585)
!596 = !DILocation(line: 433, column: 0, scope: !594)
!597 = !DILocation(line: 434, column: 0, scope: !594)
!598 = !DILocation(line: 435, column: 0, scope: !594)
!599 = !DILocation(line: 436, column: 0, scope: !594)
!602 = !DILocation(line: 439, column: 0, scope: !600)
!603 = !DILocation(line: 440, column: 0, scope: !600)
!604 = !DILocation(line: 441, column: 0, scope: !600)
!605 = !DILocation(line: 442, column: 0, scope: !600)
!608 = !DILocation(line: 445, column: 0, scope: !606)
!609 = !DILocation(line: 446, column: 0, scope: !606)
!610 = !DILocation(line: 447, column: 0, scope: !606)
!611 = !DILocation(line: 448, column: 0, scope: !606)
!612 = !DILocation(line: 449, column: 0, scope: !606)
!613 = !DILocation(line: 450, column: 0, scope: !606)
!614 = !DILocation(line: 451, column: 0, scope: !606)
!615 = !DILocation(line: 452, column: 0, scope: !606)
!616 = !DILocation(line: 453, column: 0, scope: !606)
!619 = !DILocation(line: 460, column: 0, scope: !617)
!620 = !DILocation(line: 461, column: 0, scope: !617)
!621 = !DILocation(line: 462, column: 0, scope: !617)
!622 = !DILocation(line: 463, column: 0, scope: !617)
!623 = !DILocation(line: 464, column: 0, scope: !617)
!624 = !DILocation(line: 465, column: 0, scope: !617)
!627 = !DILocation(line: 468, column: 0, scope: !625)
!628 = !DILocation(line: 469, column: 0, scope: !625)
!629 = !DILocation(line: 470, column: 0, scope: !625)
!630 = !DILocation(line: 471, column: 0, scope: !625)
!631 = !DILocation(line: 472, column: 0, scope: !625)
!632 = !DILocation(line: 473, column: 0, scope: !625)
!633 = !DILocation(line: 474, column: 0, scope: !625)
!634 = !DILocation(line: 475, column: 0, scope: !625)
!635 = !DILocation(line: 476, column: 0, scope: !625)
!636 = !DILocation(line: 477, column: 0, scope: !625)
!639 = !DILocation(line: 480, column: 0, scope: !637)
!640 = !DILocation(line: 481, column: 0, scope: !637)
!641 = !DILocation(line: 482, column: 0, scope: !637)
!642 = !DILocation(line: 483, column: 0, scope: !637)
!643 = !DILocation(line: 484, column: 0, scope: !637)
!644 = !DILocation(line: 485, column: 0, scope: !637)
!645 = !DILocation(line: 486, column: 0, scope: !637)
!646 = !DILocation(line: 487, column: 0, scope: !637)
!647 = !DILocation(line: 488, column: 0, scope: !637)
!650 = !DILocation(line: 491, column: 0, scope: !648)
!651 = !DILocation(line: 492, column: 0, scope: !648)
!652 = !DILocation(line: 493, column: 0, scope: !648)
!655 = !DILocation(line: 496, column: 0, scope: !653)
!658 = !DILocation(line: 499, column: 0, scope: !656)
!661 = !DILocation(line: 502, column: 0, scope: !659)
!664 = !DILocation(line: 505, column: 0, scope: !662)

; TBAA metadata
!0 = !{!"NOVA TBAA"}
!1 = !{!"list_data_ptr", !0}
!2 = !{!1, !1, i64 0}
!3 = !{!"list_elem", !0}
!4 = !{!3, !3, i64 0}
!5 = !{!"list_size", !0}
!6 = !{!5, !5, i64 0}
!90 = !{!"branch_weights", i32 2000, i32 1}
