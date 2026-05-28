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

define i64 @log_msg(i64 %p0) nounwind !dbg !200 {
entry:
  %slot.s = alloca i64, align 8, !dbg !201
  store i64 %p0, ptr %slot.s, align 8, !dbg !201
  %r0 = load i64, ptr %slot.s, align 8, !dbg !202
  %r1.p = getelementptr inbounds [2 x i8], ptr @.str.0, i64 0, i64 0, !dbg !202
  %r1 = ptrtoint ptr %r1.p to i64, !dbg !202
  %r2 = call i64 @nova_rt_str_concat(i64 %r0, i64 %r1), !dbg !202
  %r3 = call i64 @nova_rt_write_raw(i64 %r2), !dbg !202
  ret i64 %r3, !dbg !202
}

define i64 @json_str(i64 %p0) nounwind !dbg !203 {
entry:
  %slot.s = alloca i64, align 8, !dbg !204
  store i64 %p0, ptr %slot.s, align 8, !dbg !204
  %slot.q = alloca i64, align 8, !dbg !204
  store i64 0, ptr %slot.q, align 8, !dbg !204
  %slot.out = alloca i64, align 8, !dbg !204
  store i64 0, ptr %slot.out, align 8, !dbg !204
  %slot.i = alloca i64, align 8, !dbg !204
  store i64 0, ptr %slot.i, align 8, !dbg !204
  %slot.c = alloca i64, align 8, !dbg !204
  store i64 0, ptr %slot.c, align 8, !dbg !204
  %slot.co = alloca i64, align 8, !dbg !204
  store i64 0, ptr %slot.co, align 8, !dbg !204
  %r0 = add i64 34, 0, !dbg !205
  %r1 = call i64 @nova_rt_chr(i64 %r0), !dbg !205
  store i64 %r1, ptr %slot.q, align 8, !dbg !205
  %r2 = add i64 %r1, 0, !dbg !206
  store i64 %r2, ptr %slot.out, align 8, !dbg !206
  %r3 = add i64 0, 0, !dbg !207
  store i64 %r3, ptr %slot.i, align 8, !dbg !207
  br label %while_hdr0, !dbg !208
while_hdr0:
  %r4 = load i64, ptr %slot.i, align 8, !dbg !208
  %r5 = load i64, ptr %slot.s, align 8, !dbg !208
  %r6 = call i64 @nova_rt_len_any(i64 %r5), !dbg !208
  %r7.cmp = icmp slt i64 %r4, %r6, !dbg !208
  %r7 = zext i1 %r7.cmp to i64, !dbg !208
  %br_while_body1 = icmp ne i64 %r7, 0, !dbg !208
  br i1 %br_while_body1, label %while_body1, label %while_exit2, !prof !90, !dbg !208
while_body1:
  %r8 = load i64, ptr %slot.s, align 8, !dbg !209
  %r9 = load i64, ptr %slot.i, align 8, !dbg !209
  %r10 = call i64 @nova_rt_index_get(i64 %r8, i64 %r9), !dbg !209
  store i64 %r10, ptr %slot.c, align 8, !dbg !209
  %r11 = add i64 %r10, 0, !dbg !210
  %r12 = call i64 @nova_rt_ord(i64 %r11), !dbg !210
  store i64 %r12, ptr %slot.co, align 8, !dbg !210
  %r13 = add i64 %r10, 0, !dbg !211
  %r14 = load i64, ptr %slot.q, align 8, !dbg !211
  %r15.p0 = inttoptr i64 %r13 to ptr, !dbg !211
  %r15.p1 = inttoptr i64 %r14 to ptr, !dbg !211
  %r15.sc = call i32 @strcmp(ptr %r15.p0, ptr %r15.p1), !dbg !211
  %r15.cmp = icmp eq i32 %r15.sc, 0, !dbg !211
  %r15 = zext i1 %r15.cmp to i64, !dbg !211
  %br_then3 = icmp ne i64 %r15, 0, !dbg !211
  br i1 %br_then3, label %then3, label %else4, !dbg !211
then3:
  %r16 = load i64, ptr %slot.out, align 8, !dbg !212
  %r17.p = getelementptr inbounds [2 x i8], ptr @.str.1, i64 0, i64 0, !dbg !212
  %r17 = ptrtoint ptr %r17.p to i64, !dbg !212
  %r18 = call i64 @nova_rt_str_concat(i64 %r16, i64 %r17), !dbg !212
  %r19 = load i64, ptr %slot.q, align 8, !dbg !212
  %r20 = call i64 @nova_rt_str_concat(i64 %r18, i64 %r19), !dbg !212
  store i64 %r20, ptr %slot.out, align 8, !dbg !212
  br label %endif5, !dbg !212
else4:
  %r21 = load i64, ptr %slot.c, align 8, !dbg !213
  %r22.p = getelementptr inbounds [2 x i8], ptr @.str.1, i64 0, i64 0, !dbg !213
  %r22 = ptrtoint ptr %r22.p to i64, !dbg !213
  %r23.p0 = inttoptr i64 %r21 to ptr, !dbg !213
  %r23.p1 = inttoptr i64 %r22 to ptr, !dbg !213
  %r23.sc = call i32 @strcmp(ptr %r23.p0, ptr %r23.p1), !dbg !213
  %r23.cmp = icmp eq i32 %r23.sc, 0, !dbg !213
  %r23 = zext i1 %r23.cmp to i64, !dbg !213
  %br_then6 = icmp ne i64 %r23, 0, !dbg !213
  br i1 %br_then6, label %then6, label %else7, !dbg !213
then6:
  %r24 = load i64, ptr %slot.out, align 8, !dbg !214
  %r25.p = getelementptr inbounds [3 x i8], ptr @.str.2, i64 0, i64 0, !dbg !214
  %r25 = ptrtoint ptr %r25.p to i64, !dbg !214
  %r26 = call i64 @nova_rt_str_concat(i64 %r24, i64 %r25), !dbg !214
  store i64 %r26, ptr %slot.out, align 8, !dbg !214
  br label %endif8, !dbg !214
else7:
  %r27 = load i64, ptr %slot.co, align 8, !dbg !215
  %r28 = add i64 10, 0, !dbg !215
  %r29.cmp = icmp eq i64 %r27, %r28, !dbg !215
  %r29 = zext i1 %r29.cmp to i64, !dbg !215
  %br_then9 = icmp ne i64 %r29, 0, !dbg !215
  br i1 %br_then9, label %then9, label %else10, !dbg !215
then9:
  %r30 = load i64, ptr %slot.out, align 8, !dbg !216
  %r31.p = getelementptr inbounds [3 x i8], ptr @.str.3, i64 0, i64 0, !dbg !216
  %r31 = ptrtoint ptr %r31.p to i64, !dbg !216
  %r32 = call i64 @nova_rt_str_concat(i64 %r30, i64 %r31), !dbg !216
  store i64 %r32, ptr %slot.out, align 8, !dbg !216
  br label %endif11, !dbg !216
else10:
  %r33 = load i64, ptr %slot.co, align 8, !dbg !217
  %r34 = add i64 13, 0, !dbg !217
  %r35.cmp = icmp eq i64 %r33, %r34, !dbg !217
  %r35 = zext i1 %r35.cmp to i64, !dbg !217
  %br_then12 = icmp ne i64 %r35, 0, !dbg !217
  br i1 %br_then12, label %then12, label %else13, !dbg !217
then12:
  %r36 = load i64, ptr %slot.out, align 8, !dbg !218
  %r37.p = getelementptr inbounds [3 x i8], ptr @.str.4, i64 0, i64 0, !dbg !218
  %r37 = ptrtoint ptr %r37.p to i64, !dbg !218
  %r38 = call i64 @nova_rt_str_concat(i64 %r36, i64 %r37), !dbg !218
  store i64 %r38, ptr %slot.out, align 8, !dbg !218
  br label %endif14, !dbg !218
else13:
  %r39 = load i64, ptr %slot.co, align 8, !dbg !219
  %r40 = add i64 9, 0, !dbg !219
  %r41.cmp = icmp eq i64 %r39, %r40, !dbg !219
  %r41 = zext i1 %r41.cmp to i64, !dbg !219
  %br_then15 = icmp ne i64 %r41, 0, !dbg !219
  br i1 %br_then15, label %then15, label %else16, !dbg !219
then15:
  %r42 = load i64, ptr %slot.out, align 8, !dbg !220
  %r43.p = getelementptr inbounds [3 x i8], ptr @.str.5, i64 0, i64 0, !dbg !220
  %r43 = ptrtoint ptr %r43.p to i64, !dbg !220
  %r44 = call i64 @nova_rt_str_concat(i64 %r42, i64 %r43), !dbg !220
  store i64 %r44, ptr %slot.out, align 8, !dbg !220
  br label %endif17, !dbg !220
else16:
  %r45 = load i64, ptr %slot.co, align 8, !dbg !221
  %r46 = add i64 32, 0, !dbg !221
  %r47.cmp = icmp slt i64 %r45, %r46, !dbg !221
  %r47 = zext i1 %r47.cmp to i64, !dbg !221
  %br_then18 = icmp ne i64 %r47, 0, !dbg !221
  br i1 %br_then18, label %then18, label %else19, !dbg !221
then18:
  %r48 = load i64, ptr %slot.out, align 8, !dbg !222
  %r49.p = getelementptr inbounds [5 x i8], ptr @.str.6, i64 0, i64 0, !dbg !222
  %r49 = ptrtoint ptr %r49.p to i64, !dbg !222
  %r50 = call i64 @nova_rt_str_concat(i64 %r48, i64 %r49), !dbg !222
  %r51 = add i64 48, 0, !dbg !222
  %r52 = load i64, ptr %slot.co, align 8, !dbg !222
  %r53 = add i64 16, 0, !dbg !222
  %r54 = sdiv i64 %r52, %r53, !dbg !222
  %r55 = add i64 %r51, %r54, !dbg !222
  %r56 = call i64 @nova_rt_chr(i64 %r55), !dbg !222
  %r57 = call i64 @nova_rt_str_concat(i64 %r50, i64 %r56), !dbg !222
  %r58 = add i64 48, 0, !dbg !222
  %r59 = load i64, ptr %slot.co, align 8, !dbg !222
  %r60 = load i64, ptr %slot.co, align 8, !dbg !222
  %r61 = add i64 16, 0, !dbg !222
  %r62 = sdiv i64 %r60, %r61, !dbg !222
  %r63 = add i64 16, 0, !dbg !222
  %r64 = mul i64 %r62, %r63, !dbg !222
  %r65 = sub i64 %r59, %r64, !dbg !222
  %r66 = add i64 %r58, %r65, !dbg !222
  %r67 = call i64 @nova_rt_chr(i64 %r66), !dbg !222
  %r68 = call i64 @nova_rt_str_concat(i64 %r57, i64 %r67), !dbg !222
  store i64 %r68, ptr %slot.out, align 8, !dbg !222
  br label %endif20, !dbg !222
else19:
  %r69 = load i64, ptr %slot.out, align 8, !dbg !223
  %r70 = load i64, ptr %slot.c, align 8, !dbg !223
  %r71 = call i64 @nova_rt_str_concat(i64 %r69, i64 %r70), !dbg !223
  store i64 %r71, ptr %slot.out, align 8, !dbg !223
  br label %endif20, !dbg !223
endif20:
  br label %endif17, !dbg !223
endif17:
  br label %endif14, !dbg !223
endif14:
  br label %endif11, !dbg !223
endif11:
  br label %endif8, !dbg !223
endif8:
  br label %endif5, !dbg !223
endif5:
  %r72 = load i64, ptr %slot.i, align 8, !dbg !224
  %r73 = add i64 1, 0, !dbg !224
  %r74 = add i64 %r72, %r73, !dbg !224
  store i64 %r74, ptr %slot.i, align 8, !dbg !224
  br label %while_hdr0, !dbg !224
while_exit2:
  %r75 = load i64, ptr %slot.out, align 8, !dbg !225
  %r76 = load i64, ptr %slot.q, align 8, !dbg !225
  %r77 = call i64 @nova_rt_str_concat(i64 %r75, i64 %r76), !dbg !225
  ret i64 %r77, !dbg !225
}

define i64 @json_int(i64 %p0) nounwind !dbg !226 {
entry:
  %slot.n = alloca i64, align 8, !dbg !227
  store i64 %p0, ptr %slot.n, align 8, !dbg !227
  %r0 = load i64, ptr %slot.n, align 8, !dbg !228
  %r1 = call i64 @nova_rt_int_to_str(i64 %r0), !dbg !228
  ret i64 %r1, !dbg !228
}

define i64 @read_header_line() nounwind !dbg !229 {
entry:
  %slot.line = alloca i64, align 8, !dbg !230
  store i64 0, ptr %slot.line, align 8, !dbg !230
  %slot.done = alloca i64, align 8, !dbg !230
  store i64 0, ptr %slot.done, align 8, !dbg !230
  %slot.eof = alloca i64, align 8, !dbg !230
  store i64 0, ptr %slot.eof, align 8, !dbg !230
  %slot.c = alloca i64, align 8, !dbg !230
  store i64 0, ptr %slot.c, align 8, !dbg !230
  %r0.p = getelementptr inbounds [1 x i8], ptr @.str.7, i64 0, i64 0, !dbg !231
  %r0 = ptrtoint ptr %r0.p to i64, !dbg !231
  store i64 %r0, ptr %slot.line, align 8, !dbg !231
  %r1 = add i64 0, 0, !dbg !232
  store i64 %r1, ptr %slot.done, align 8, !dbg !232
  %r2 = add i64 0, 0, !dbg !233
  store i64 %r2, ptr %slot.eof, align 8, !dbg !233
  br label %while_hdr21, !dbg !234
while_hdr21:
  %r3 = load i64, ptr %slot.done, align 8, !dbg !234
  %r4 = add i64 0, 0, !dbg !234
  %r5.cmp = icmp eq i64 %r3, %r4, !dbg !234
  %r5 = zext i1 %r5.cmp to i64, !dbg !234
  %br_while_body22 = icmp ne i64 %r5, 0, !dbg !234
  br i1 %br_while_body22, label %while_body22, label %while_exit23, !prof !90, !dbg !234
while_body22:
  %r6 = add i64 1, 0, !dbg !235
  %r7 = call i64 @nova_rt_stdin_read_n(i64 %r6), !dbg !235
  store i64 %r7, ptr %slot.c, align 8, !dbg !235
  %r8 = add i64 %r7, 0, !dbg !236
  %r9 = call i64 @nova_rt_len_any(i64 %r8), !dbg !236
  %r10 = add i64 0, 0, !dbg !236
  %r11.cmp = icmp eq i64 %r9, %r10, !dbg !236
  %r11 = zext i1 %r11.cmp to i64, !dbg !236
  %br_then24 = icmp ne i64 %r11, 0, !dbg !236
  br i1 %br_then24, label %then24, label %else25, !dbg !236
then24:
  %r12 = add i64 1, 0, !dbg !237
  store i64 %r12, ptr %slot.done, align 8, !dbg !237
  %r13 = add i64 1, 0, !dbg !238
  store i64 %r13, ptr %slot.eof, align 8, !dbg !238
  br label %endif26, !dbg !238
else25:
  %r14 = load i64, ptr %slot.c, align 8, !dbg !239
  %r15.p = getelementptr inbounds [2 x i8], ptr @.str.0, i64 0, i64 0, !dbg !239
  %r15 = ptrtoint ptr %r15.p to i64, !dbg !239
  %r16.p0 = inttoptr i64 %r14 to ptr, !dbg !239
  %r16.p1 = inttoptr i64 %r15 to ptr, !dbg !239
  %r16.sc = call i32 @strcmp(ptr %r16.p0, ptr %r16.p1), !dbg !239
  %r16.cmp = icmp eq i32 %r16.sc, 0, !dbg !239
  %r16 = zext i1 %r16.cmp to i64, !dbg !239
  %br_then27 = icmp ne i64 %r16, 0, !dbg !239
  br i1 %br_then27, label %then27, label %else28, !dbg !239
then27:
  %r17 = add i64 1, 0, !dbg !240
  store i64 %r17, ptr %slot.done, align 8, !dbg !240
  br label %endif29, !dbg !240
else28:
  %r18 = load i64, ptr %slot.c, align 8, !dbg !241
  %r19.p = getelementptr inbounds [2 x i8], ptr @.str.8, i64 0, i64 0, !dbg !241
  %r19 = ptrtoint ptr %r19.p to i64, !dbg !241
  %r20.p0 = inttoptr i64 %r18 to ptr, !dbg !241
  %r20.p1 = inttoptr i64 %r19 to ptr, !dbg !241
  %r20.sc = call i32 @strcmp(ptr %r20.p0, ptr %r20.p1), !dbg !241
  %r20.cmp = icmp eq i32 %r20.sc, 0, !dbg !241
  %r20 = zext i1 %r20.cmp to i64, !dbg !241
  %br_then30 = icmp ne i64 %r20, 0, !dbg !241
  br i1 %br_then30, label %then30, label %else31, !dbg !241
then30:
  %r21 = load i64, ptr %slot.line, align 8, !dbg !242
  store i64 %r21, ptr %slot.line, align 8, !dbg !242
  br label %endif32, !dbg !242
else31:
  %r22 = load i64, ptr %slot.line, align 8, !dbg !243
  %r23 = load i64, ptr %slot.c, align 8, !dbg !243
  %r24 = call i64 @nova_rt_str_concat(i64 %r22, i64 %r23), !dbg !243
  store i64 %r24, ptr %slot.line, align 8, !dbg !243
  br label %endif32, !dbg !243
endif32:
  br label %endif29, !dbg !243
endif29:
  br label %endif26, !dbg !243
endif26:
  br label %while_hdr21, !dbg !243
while_exit23:
  %r25 = load i64, ptr %slot.eof, align 8, !dbg !244
  %r26 = add i64 1, 0, !dbg !244
  %r27.cmp = icmp eq i64 %r25, %r26, !dbg !244
  %r27 = zext i1 %r27.cmp to i64, !dbg !244
  %br_then33 = icmp ne i64 %r27, 0, !dbg !244
  br i1 %br_then33, label %then33, label %else34, !dbg !244
then33:
  %r28.p = getelementptr inbounds [1 x i8], ptr @.str.7, i64 0, i64 0, !dbg !245
  %r28 = ptrtoint ptr %r28.p to i64, !dbg !245
  ret i64 %r28, !dbg !245
else34:
  br label %endif35, !dbg !245
endif35:
  %r29 = load i64, ptr %slot.line, align 8, !dbg !246
  ret i64 %r29, !dbg !246
}

define i64 @read_message() nounwind !dbg !247 {
entry:
  %slot.content_length = alloca i64, align 8, !dbg !248
  store i64 0, ptr %slot.content_length, align 8, !dbg !248
  %slot.done = alloca i64, align 8, !dbg !248
  store i64 0, ptr %slot.done, align 8, !dbg !248
  %slot.result = alloca i64, align 8, !dbg !248
  store i64 0, ptr %slot.result, align 8, !dbg !248
  %slot.hdr = alloca i64, align 8, !dbg !248
  store i64 0, ptr %slot.hdr, align 8, !dbg !248
  %slot.cl_pos = alloca i64, align 8, !dbg !248
  store i64 0, ptr %slot.cl_pos, align 8, !dbg !248
  %slot.colon = alloca i64, align 8, !dbg !248
  store i64 0, ptr %slot.colon, align 8, !dbg !248
  %r0 = add i64 0, 0, !dbg !249
  store i64 %r0, ptr %slot.content_length, align 8, !dbg !249
  %r1 = add i64 0, 0, !dbg !250
  store i64 %r1, ptr %slot.done, align 8, !dbg !250
  %r2.p = getelementptr inbounds [1 x i8], ptr @.str.7, i64 0, i64 0, !dbg !251
  %r2 = ptrtoint ptr %r2.p to i64, !dbg !251
  store i64 %r2, ptr %slot.result, align 8, !dbg !251
  br label %while_hdr36, !dbg !252
while_hdr36:
  %r3 = load i64, ptr %slot.done, align 8, !dbg !252
  %r4 = add i64 0, 0, !dbg !252
  %r5.cmp = icmp eq i64 %r3, %r4, !dbg !252
  %r5 = zext i1 %r5.cmp to i64, !dbg !252
  %br_while_body37 = icmp ne i64 %r5, 0, !dbg !252
  br i1 %br_while_body37, label %while_body37, label %while_exit38, !prof !90, !dbg !252
while_body37:
  %r6 = call i64 @read_header_line(), !dbg !253
  store i64 %r6, ptr %slot.hdr, align 8, !dbg !253
  %r7 = add i64 %r6, 0, !dbg !254
  %r8 = call i64 @nova_rt_len_any(i64 %r7), !dbg !254
  %r9 = add i64 0, 0, !dbg !254
  %r10.cmp = icmp eq i64 %r8, %r9, !dbg !254
  %r10 = zext i1 %r10.cmp to i64, !dbg !254
  %br_then39 = icmp ne i64 %r10, 0, !dbg !254
  br i1 %br_then39, label %then39, label %else40, !dbg !254
then39:
  %r11 = load i64, ptr %slot.content_length, align 8, !dbg !255
  %r12 = add i64 0, 0, !dbg !255
  %r13.cmp = icmp eq i64 %r11, %r12, !dbg !255
  %r13 = zext i1 %r13.cmp to i64, !dbg !255
  %br_then42 = icmp ne i64 %r13, 0, !dbg !255
  br i1 %br_then42, label %then42, label %else43, !dbg !255
then42:
  %r14 = add i64 1, 0, !dbg !256
  store i64 %r14, ptr %slot.done, align 8, !dbg !256
  br label %endif44, !dbg !256
else43:
  %r15 = load i64, ptr %slot.content_length, align 8, !dbg !257
  %r16 = call i64 @nova_rt_stdin_read_n(i64 %r15), !dbg !257
  store i64 %r16, ptr %slot.result, align 8, !dbg !257
  %r17 = add i64 1, 0, !dbg !258
  store i64 %r17, ptr %slot.done, align 8, !dbg !258
  br label %endif44, !dbg !258
endif44:
  br label %endif41, !dbg !258
else40:
  %r18 = load i64, ptr %slot.hdr, align 8, !dbg !259
  %r19 = call i64 @nova_rt_lower(i64 %r18), !dbg !259
  %r20.p = getelementptr inbounds [16 x i8], ptr @.str.9, i64 0, i64 0, !dbg !259
  %r20 = ptrtoint ptr %r20.p to i64, !dbg !259
  %r21 = call i64 @nova_rt_find(i64 %r19, i64 %r20), !dbg !259
  store i64 %r21, ptr %slot.cl_pos, align 8, !dbg !259
  %r22 = add i64 %r21, 0, !dbg !260
  %r23 = add i64 0, 0, !dbg !260
  %r24.cmp = icmp eq i64 %r22, %r23, !dbg !260
  %r24 = zext i1 %r24.cmp to i64, !dbg !260
  %br_then45 = icmp ne i64 %r24, 0, !dbg !260
  br i1 %br_then45, label %then45, label %else46, !dbg !260
then45:
  %r25 = load i64, ptr %slot.hdr, align 8, !dbg !261
  %r26.p = getelementptr inbounds [2 x i8], ptr @.str.10, i64 0, i64 0, !dbg !261
  %r26 = ptrtoint ptr %r26.p to i64, !dbg !261
  %r27 = call i64 @nova_rt_find(i64 %r25, i64 %r26), !dbg !261
  store i64 %r27, ptr %slot.colon, align 8, !dbg !261
  %r28 = add i64 %r27, 0, !dbg !262
  %r29 = add i64 0, 0, !dbg !262
  %r30.cmp = icmp sge i64 %r28, %r29, !dbg !262
  %r30 = zext i1 %r30.cmp to i64, !dbg !262
  %br_then48 = icmp ne i64 %r30, 0, !dbg !262
  br i1 %br_then48, label %then48, label %else49, !dbg !262
then48:
  %r31 = load i64, ptr %slot.hdr, align 8, !dbg !263
  %r32 = load i64, ptr %slot.colon, align 8, !dbg !263
  %r33 = add i64 1, 0, !dbg !263
  %r34 = add i64 %r32, %r33, !dbg !263
  %r35 = load i64, ptr %slot.hdr, align 8, !dbg !263
  %r36 = call i64 @nova_rt_len_any(i64 %r35), !dbg !263
  %r37 = call i64 @nova_rt_slice(i64 %r31, i64 %r34, i64 %r36), !dbg !263
  %r38 = call i64 @nova_rt_trim(i64 %r37), !dbg !263
  %r39 = call i64 @nova_rt_parse_int(i64 %r38), !dbg !263
  store i64 %r39, ptr %slot.content_length, align 8, !dbg !263
  br label %endif50, !dbg !263
else49:
  br label %endif50, !dbg !263
endif50:
  br label %endif47, !dbg !263
else46:
  br label %endif47, !dbg !263
endif47:
  br label %endif41, !dbg !263
endif41:
  br label %while_hdr36, !dbg !263
while_exit38:
  %r40 = load i64, ptr %slot.result, align 8, !dbg !264
  ret i64 %r40, !dbg !264
}

define i64 @send_message(i64 %p0) nounwind !dbg !265 {
entry:
  %slot.body = alloca i64, align 8, !dbg !266
  store i64 %p0, ptr %slot.body, align 8, !dbg !266
  %slot.body_len = alloca i64, align 8, !dbg !266
  store i64 0, ptr %slot.body_len, align 8, !dbg !266
  %slot.framed = alloca i64, align 8, !dbg !266
  store i64 0, ptr %slot.framed, align 8, !dbg !266
  %r0 = load i64, ptr %slot.body, align 8, !dbg !267
  %r1 = call i64 @nova_rt_len_any(i64 %r0), !dbg !267
  store i64 %r1, ptr %slot.body_len, align 8, !dbg !267
  %r2.p = getelementptr inbounds [29 x i8], ptr @.str.11, i64 0, i64 0, !dbg !268
  %r2 = ptrtoint ptr %r2.p to i64, !dbg !268
  %r3 = add i64 %r1, 0, !dbg !268
  %r4 = call i64 @nova_rt_int_to_str(i64 %r3), !dbg !268
  %r5 = call i64 @nova_rt_str_concat(i64 %r2, i64 %r4), !dbg !268
  %r6 = call i64 @log_msg(i64 %r5), !dbg !268
  %r7.p = getelementptr inbounds [17 x i8], ptr @.str.12, i64 0, i64 0, !dbg !269
  %r7 = ptrtoint ptr %r7.p to i64, !dbg !269
  %r8 = add i64 %r1, 0, !dbg !269
  %r9 = call i64 @nova_rt_int_to_str(i64 %r8), !dbg !269
  %r10 = call i64 @nova_rt_str_concat(i64 %r7, i64 %r9), !dbg !269
  %r11.p = getelementptr inbounds [5 x i8], ptr @.str.13, i64 0, i64 0, !dbg !269
  %r11 = ptrtoint ptr %r11.p to i64, !dbg !269
  %r12 = call i64 @nova_rt_str_concat(i64 %r10, i64 %r11), !dbg !269
  %r13 = load i64, ptr %slot.body, align 8, !dbg !269
  %r14 = call i64 @nova_rt_str_concat(i64 %r12, i64 %r13), !dbg !269
  store i64 %r14, ptr %slot.framed, align 8, !dbg !269
  %r15 = add i64 %r14, 0, !dbg !270
  %r16 = call i64 @nova_rt_stdout_write(i64 %r15), !dbg !270
  %r17.p = getelementptr inbounds [29 x i8], ptr @.str.14, i64 0, i64 0, !dbg !271
  %r17 = ptrtoint ptr %r17.p to i64, !dbg !271
  %r18 = call i64 @log_msg(i64 %r17), !dbg !271
  ret i64 %r18, !dbg !271
}

define i64 @build_response(i64 %p0, i64 %p1) nounwind !dbg !272 {
entry:
  %slot.id = alloca i64, align 8, !dbg !273
  store i64 %p0, ptr %slot.id, align 8, !dbg !273
  %slot.result_json = alloca i64, align 8, !dbg !273
  store i64 %p1, ptr %slot.result_json, align 8, !dbg !273
  %r0.p = getelementptr inbounds [23 x i8], ptr @.str.15, i64 0, i64 0, !dbg !274
  %r0 = ptrtoint ptr %r0.p to i64, !dbg !274
  %r1 = load i64, ptr %slot.id, align 8, !dbg !274
  %r2 = call i64 @nova_rt_int_to_str(i64 %r1), !dbg !274
  %r3 = call i64 @nova_rt_str_concat(i64 %r0, i64 %r2), !dbg !274
  %r4.p = getelementptr inbounds [11 x i8], ptr @.str.16, i64 0, i64 0, !dbg !274
  %r4 = ptrtoint ptr %r4.p to i64, !dbg !274
  %r5 = call i64 @nova_rt_str_concat(i64 %r3, i64 %r4), !dbg !274
  %r6 = load i64, ptr %slot.result_json, align 8, !dbg !274
  %r7 = call i64 @nova_rt_str_concat(i64 %r5, i64 %r6), !dbg !274
  %r8.p = getelementptr inbounds [2 x i8], ptr @.str.17, i64 0, i64 0, !dbg !274
  %r8 = ptrtoint ptr %r8.p to i64, !dbg !274
  %r9 = call i64 @nova_rt_str_concat(i64 %r7, i64 %r8), !dbg !274
  ret i64 %r9, !dbg !274
}

define i64 @build_notification(i64 %p0, i64 %p1) nounwind !dbg !275 {
entry:
  %slot.method = alloca i64, align 8, !dbg !276
  store i64 %p0, ptr %slot.method, align 8, !dbg !276
  %slot.params_json = alloca i64, align 8, !dbg !276
  store i64 %p1, ptr %slot.params_json, align 8, !dbg !276
  %r0.p = getelementptr inbounds [27 x i8], ptr @.str.18, i64 0, i64 0, !dbg !277
  %r0 = ptrtoint ptr %r0.p to i64, !dbg !277
  %r1 = load i64, ptr %slot.method, align 8, !dbg !277
  %r2 = call i64 @json_str(i64 %r1), !dbg !277
  %r3 = call i64 @nova_rt_str_concat(i64 %r0, i64 %r2), !dbg !277
  %r4.p = getelementptr inbounds [11 x i8], ptr @.str.19, i64 0, i64 0, !dbg !277
  %r4 = ptrtoint ptr %r4.p to i64, !dbg !277
  %r5 = call i64 @nova_rt_str_concat(i64 %r3, i64 %r4), !dbg !277
  %r6 = load i64, ptr %slot.params_json, align 8, !dbg !277
  %r7 = call i64 @nova_rt_str_concat(i64 %r5, i64 %r6), !dbg !277
  %r8.p = getelementptr inbounds [2 x i8], ptr @.str.17, i64 0, i64 0, !dbg !277
  %r8 = ptrtoint ptr %r8.p to i64, !dbg !277
  %r9 = call i64 @nova_rt_str_concat(i64 %r7, i64 %r8), !dbg !277
  ret i64 %r9, !dbg !277
}

define i64 @json_extract_int(i64 %p0, i64 %p1) nounwind !dbg !278 {
entry:
  %slot.json = alloca i64, align 8, !dbg !279
  store i64 %p0, ptr %slot.json, align 8, !dbg !279
  %slot.key = alloca i64, align 8, !dbg !279
  store i64 %p1, ptr %slot.key, align 8, !dbg !279
  %slot.needle = alloca i64, align 8, !dbg !279
  store i64 0, ptr %slot.needle, align 8, !dbg !279
  %slot.pos = alloca i64, align 8, !dbg !279
  store i64 0, ptr %slot.pos, align 8, !dbg !279
  %slot.start = alloca i64, align 8, !dbg !279
  store i64 0, ptr %slot.start, align 8, !dbg !279
  %slot.__sc_57 = alloca i64, align 8, !dbg !279
  store i64 0, ptr %slot.__sc_57, align 8, !dbg !279
  %slot.__sc_60 = alloca i64, align 8, !dbg !279
  store i64 0, ptr %slot.__sc_60, align 8, !dbg !279
  %slot.end = alloca i64, align 8, !dbg !279
  store i64 0, ptr %slot.end, align 8, !dbg !279
  %slot.c = alloca i64, align 8, !dbg !279
  store i64 0, ptr %slot.c, align 8, !dbg !279
  %slot.__sc_66 = alloca i64, align 8, !dbg !279
  store i64 0, ptr %slot.__sc_66, align 8, !dbg !279
  %slot.__sc_69 = alloca i64, align 8, !dbg !279
  store i64 0, ptr %slot.__sc_69, align 8, !dbg !279
  %slot.__sc_72 = alloca i64, align 8, !dbg !279
  store i64 0, ptr %slot.__sc_72, align 8, !dbg !279
  %slot.__sc_75 = alloca i64, align 8, !dbg !279
  store i64 0, ptr %slot.__sc_75, align 8, !dbg !279
  %slot.__sc_78 = alloca i64, align 8, !dbg !279
  store i64 0, ptr %slot.__sc_78, align 8, !dbg !279
  %r0 = load i64, ptr %slot.key, align 8, !dbg !280
  %r1 = call i64 @json_str(i64 %r0), !dbg !280
  %r2.p = getelementptr inbounds [2 x i8], ptr @.str.10, i64 0, i64 0, !dbg !280
  %r2 = ptrtoint ptr %r2.p to i64, !dbg !280
  %r3 = call i64 @nova_rt_str_concat(i64 %r1, i64 %r2), !dbg !280
  store i64 %r3, ptr %slot.needle, align 8, !dbg !280
  %r4 = load i64, ptr %slot.json, align 8, !dbg !281
  %r5 = add i64 %r3, 0, !dbg !281
  %r6 = call i64 @nova_rt_find(i64 %r4, i64 %r5), !dbg !281
  store i64 %r6, ptr %slot.pos, align 8, !dbg !281
  %r7 = add i64 %r6, 0, !dbg !282
  %r8 = add i64 0, 0, !dbg !282
  %r9.cmp = icmp slt i64 %r7, %r8, !dbg !282
  %r9 = zext i1 %r9.cmp to i64, !dbg !282
  %br_then51 = icmp ne i64 %r9, 0, !dbg !282
  br i1 %br_then51, label %then51, label %else52, !dbg !282
then51:
  %r10 = add i64 1, 0, !dbg !283
  %r11 = sub i64 0, %r10, !dbg !283
  ret i64 %r11, !dbg !283
else52:
  br label %endif53, !dbg !283
endif53:
  %r12 = load i64, ptr %slot.pos, align 8, !dbg !284
  %r13 = load i64, ptr %slot.needle, align 8, !dbg !284
  %r14 = call i64 @nova_rt_len_any(i64 %r13), !dbg !284
  %r15 = add i64 %r12, %r14, !dbg !284
  store i64 %r15, ptr %slot.start, align 8, !dbg !284
  br label %while_hdr54, !dbg !285
while_hdr54:
  %r16 = load i64, ptr %slot.start, align 8, !dbg !285
  %r17 = load i64, ptr %slot.json, align 8, !dbg !285
  %r18 = call i64 @nova_rt_len_any(i64 %r17), !dbg !285
  %r19.cmp = icmp slt i64 %r16, %r18, !dbg !285
  %r19 = zext i1 %r19.cmp to i64, !dbg !285
  store i64 %r19, ptr %slot.__sc_57, align 8, !dbg !285
  %br_and_rhs58 = icmp ne i64 %r19, 0, !dbg !285
  br i1 %br_and_rhs58, label %and_rhs58, label %and_merge59, !dbg !285
and_rhs58:
  %r20 = load i64, ptr %slot.json, align 8, !dbg !285
  %r21 = load i64, ptr %slot.start, align 8, !dbg !285
  %r22 = call i64 @nova_rt_index_get(i64 %r20, i64 %r21), !dbg !285
  %r23.p = getelementptr inbounds [2 x i8], ptr @.str.20, i64 0, i64 0, !dbg !285
  %r23 = ptrtoint ptr %r23.p to i64, !dbg !285
  %r24.p0 = inttoptr i64 %r22 to ptr, !dbg !285
  %r24.p1 = inttoptr i64 %r23 to ptr, !dbg !285
  %r24.sc = call i32 @strcmp(ptr %r24.p0, ptr %r24.p1), !dbg !285
  %r24.cmp = icmp eq i32 %r24.sc, 0, !dbg !285
  %r24 = zext i1 %r24.cmp to i64, !dbg !285
  store i64 %r24, ptr %slot.__sc_60, align 8, !dbg !285
  %br_or_merge62 = icmp ne i64 %r24, 0, !dbg !285
  br i1 %br_or_merge62, label %or_merge62, label %or_rhs61, !dbg !285
or_rhs61:
  %r25 = load i64, ptr %slot.json, align 8, !dbg !285
  %r26 = load i64, ptr %slot.start, align 8, !dbg !285
  %r27 = call i64 @nova_rt_index_get(i64 %r25, i64 %r26), !dbg !285
  %r28.p = getelementptr inbounds [2 x i8], ptr @.str.21, i64 0, i64 0, !dbg !285
  %r28 = ptrtoint ptr %r28.p to i64, !dbg !285
  %r29.p0 = inttoptr i64 %r27 to ptr, !dbg !285
  %r29.p1 = inttoptr i64 %r28 to ptr, !dbg !285
  %r29.sc = call i32 @strcmp(ptr %r29.p0, ptr %r29.p1), !dbg !285
  %r29.cmp = icmp eq i32 %r29.sc, 0, !dbg !285
  %r29 = zext i1 %r29.cmp to i64, !dbg !285
  store i64 %r29, ptr %slot.__sc_60, align 8, !dbg !285
  br label %or_merge62, !dbg !285
or_merge62:
  %r30 = load i64, ptr %slot.__sc_60, align 8, !dbg !285
  store i64 %r30, ptr %slot.__sc_57, align 8, !dbg !285
  br label %and_merge59, !dbg !285
and_merge59:
  %r31 = load i64, ptr %slot.__sc_57, align 8, !dbg !285
  %br_while_body55 = icmp ne i64 %r31, 0, !dbg !285
  br i1 %br_while_body55, label %while_body55, label %while_exit56, !prof !90, !dbg !285
while_body55:
  %r32 = load i64, ptr %slot.start, align 8, !dbg !286
  %r33 = add i64 1, 0, !dbg !286
  %r34 = add i64 %r32, %r33, !dbg !286
  store i64 %r34, ptr %slot.start, align 8, !dbg !286
  br label %while_hdr54, !dbg !286
while_exit56:
  %r35 = load i64, ptr %slot.start, align 8, !dbg !287
  store i64 %r35, ptr %slot.end, align 8, !dbg !287
  br label %while_hdr63, !dbg !288
while_hdr63:
  %r36 = load i64, ptr %slot.end, align 8, !dbg !288
  %r37 = load i64, ptr %slot.json, align 8, !dbg !288
  %r38 = call i64 @nova_rt_len_any(i64 %r37), !dbg !288
  %r39.cmp = icmp slt i64 %r36, %r38, !dbg !288
  %r39 = zext i1 %r39.cmp to i64, !dbg !288
  %br_while_body64 = icmp ne i64 %r39, 0, !dbg !288
  br i1 %br_while_body64, label %while_body64, label %while_exit65, !prof !90, !dbg !288
while_body64:
  %r40 = load i64, ptr %slot.json, align 8, !dbg !289
  %r41 = load i64, ptr %slot.end, align 8, !dbg !289
  %r42 = call i64 @nova_rt_index_get(i64 %r40, i64 %r41), !dbg !289
  store i64 %r42, ptr %slot.c, align 8, !dbg !289
  %r43 = add i64 %r42, 0, !dbg !290
  %r44.p = getelementptr inbounds [2 x i8], ptr @.str.22, i64 0, i64 0, !dbg !290
  %r44 = ptrtoint ptr %r44.p to i64, !dbg !290
  %r45.p0 = inttoptr i64 %r43 to ptr, !dbg !290
  %r45.p1 = inttoptr i64 %r44 to ptr, !dbg !290
  %r45.sc = call i32 @strcmp(ptr %r45.p0, ptr %r45.p1), !dbg !290
  %r45.cmp = icmp eq i32 %r45.sc, 0, !dbg !290
  %r45 = zext i1 %r45.cmp to i64, !dbg !290
  store i64 %r45, ptr %slot.__sc_66, align 8, !dbg !290
  %br_or_merge68 = icmp ne i64 %r45, 0, !dbg !290
  br i1 %br_or_merge68, label %or_merge68, label %or_rhs67, !dbg !290
or_rhs67:
  %r46 = load i64, ptr %slot.c, align 8, !dbg !290
  %r47.p = getelementptr inbounds [2 x i8], ptr @.str.17, i64 0, i64 0, !dbg !290
  %r47 = ptrtoint ptr %r47.p to i64, !dbg !290
  %r48.p0 = inttoptr i64 %r46 to ptr, !dbg !290
  %r48.p1 = inttoptr i64 %r47 to ptr, !dbg !290
  %r48.sc = call i32 @strcmp(ptr %r48.p0, ptr %r48.p1), !dbg !290
  %r48.cmp = icmp eq i32 %r48.sc, 0, !dbg !290
  %r48 = zext i1 %r48.cmp to i64, !dbg !290
  store i64 %r48, ptr %slot.__sc_66, align 8, !dbg !290
  br label %or_merge68, !dbg !290
or_merge68:
  %r49 = load i64, ptr %slot.__sc_66, align 8, !dbg !290
  store i64 %r49, ptr %slot.__sc_69, align 8, !dbg !290
  %br_or_merge71 = icmp ne i64 %r49, 0, !dbg !290
  br i1 %br_or_merge71, label %or_merge71, label %or_rhs70, !dbg !290
or_rhs70:
  %r50 = load i64, ptr %slot.c, align 8, !dbg !290
  %r51.p = getelementptr inbounds [2 x i8], ptr @.str.23, i64 0, i64 0, !dbg !290
  %r51 = ptrtoint ptr %r51.p to i64, !dbg !290
  %r52.p0 = inttoptr i64 %r50 to ptr, !dbg !290
  %r52.p1 = inttoptr i64 %r51 to ptr, !dbg !290
  %r52.sc = call i32 @strcmp(ptr %r52.p0, ptr %r52.p1), !dbg !290
  %r52.cmp = icmp eq i32 %r52.sc, 0, !dbg !290
  %r52 = zext i1 %r52.cmp to i64, !dbg !290
  store i64 %r52, ptr %slot.__sc_69, align 8, !dbg !290
  br label %or_merge71, !dbg !290
or_merge71:
  %r53 = load i64, ptr %slot.__sc_69, align 8, !dbg !290
  store i64 %r53, ptr %slot.__sc_72, align 8, !dbg !290
  %br_or_merge74 = icmp ne i64 %r53, 0, !dbg !290
  br i1 %br_or_merge74, label %or_merge74, label %or_rhs73, !dbg !290
or_rhs73:
  %r54 = load i64, ptr %slot.c, align 8, !dbg !290
  %r55.p = getelementptr inbounds [2 x i8], ptr @.str.20, i64 0, i64 0, !dbg !290
  %r55 = ptrtoint ptr %r55.p to i64, !dbg !290
  %r56.p0 = inttoptr i64 %r54 to ptr, !dbg !290
  %r56.p1 = inttoptr i64 %r55 to ptr, !dbg !290
  %r56.sc = call i32 @strcmp(ptr %r56.p0, ptr %r56.p1), !dbg !290
  %r56.cmp = icmp eq i32 %r56.sc, 0, !dbg !290
  %r56 = zext i1 %r56.cmp to i64, !dbg !290
  store i64 %r56, ptr %slot.__sc_72, align 8, !dbg !290
  br label %or_merge74, !dbg !290
or_merge74:
  %r57 = load i64, ptr %slot.__sc_72, align 8, !dbg !290
  store i64 %r57, ptr %slot.__sc_75, align 8, !dbg !290
  %br_or_merge77 = icmp ne i64 %r57, 0, !dbg !290
  br i1 %br_or_merge77, label %or_merge77, label %or_rhs76, !dbg !290
or_rhs76:
  %r58 = load i64, ptr %slot.c, align 8, !dbg !290
  %r59.p = getelementptr inbounds [2 x i8], ptr @.str.0, i64 0, i64 0, !dbg !290
  %r59 = ptrtoint ptr %r59.p to i64, !dbg !290
  %r60.p0 = inttoptr i64 %r58 to ptr, !dbg !290
  %r60.p1 = inttoptr i64 %r59 to ptr, !dbg !290
  %r60.sc = call i32 @strcmp(ptr %r60.p0, ptr %r60.p1), !dbg !290
  %r60.cmp = icmp eq i32 %r60.sc, 0, !dbg !290
  %r60 = zext i1 %r60.cmp to i64, !dbg !290
  store i64 %r60, ptr %slot.__sc_75, align 8, !dbg !290
  br label %or_merge77, !dbg !290
or_merge77:
  %r61 = load i64, ptr %slot.__sc_75, align 8, !dbg !290
  store i64 %r61, ptr %slot.__sc_78, align 8, !dbg !290
  %br_or_merge80 = icmp ne i64 %r61, 0, !dbg !290
  br i1 %br_or_merge80, label %or_merge80, label %or_rhs79, !dbg !290
or_rhs79:
  %r62 = load i64, ptr %slot.c, align 8, !dbg !290
  %r63.p = getelementptr inbounds [2 x i8], ptr @.str.8, i64 0, i64 0, !dbg !290
  %r63 = ptrtoint ptr %r63.p to i64, !dbg !290
  %r64.p0 = inttoptr i64 %r62 to ptr, !dbg !290
  %r64.p1 = inttoptr i64 %r63 to ptr, !dbg !290
  %r64.sc = call i32 @strcmp(ptr %r64.p0, ptr %r64.p1), !dbg !290
  %r64.cmp = icmp eq i32 %r64.sc, 0, !dbg !290
  %r64 = zext i1 %r64.cmp to i64, !dbg !290
  store i64 %r64, ptr %slot.__sc_78, align 8, !dbg !290
  br label %or_merge80, !dbg !290
or_merge80:
  %r65 = load i64, ptr %slot.__sc_78, align 8, !dbg !290
  %br_then81 = icmp ne i64 %r65, 0, !dbg !290
  br i1 %br_then81, label %then81, label %else82, !dbg !290
then81:
  br label %while_exit65, !dbg !291
else82:
  br label %endif83, !dbg !291
endif83:
  %r66 = load i64, ptr %slot.end, align 8, !dbg !292
  %r67 = add i64 1, 0, !dbg !292
  %r68 = add i64 %r66, %r67, !dbg !292
  store i64 %r68, ptr %slot.end, align 8, !dbg !292
  br label %while_hdr63, !dbg !292
while_exit65:
  %r69 = load i64, ptr %slot.json, align 8, !dbg !293
  %r70 = load i64, ptr %slot.start, align 8, !dbg !293
  %r71 = load i64, ptr %slot.end, align 8, !dbg !293
  %r72 = call i64 @nova_rt_slice(i64 %r69, i64 %r70, i64 %r71), !dbg !293
  %r73 = call i64 @nova_rt_parse_int(i64 %r72), !dbg !293
  ret i64 %r73, !dbg !293
}

define i64 @json_extract_string(i64 %p0, i64 %p1) nounwind !dbg !294 {
entry:
  %slot.json = alloca i64, align 8, !dbg !295
  store i64 %p0, ptr %slot.json, align 8, !dbg !295
  %slot.key = alloca i64, align 8, !dbg !295
  store i64 %p1, ptr %slot.key, align 8, !dbg !295
  %slot.needle = alloca i64, align 8, !dbg !295
  store i64 0, ptr %slot.needle, align 8, !dbg !295
  %slot.pos = alloca i64, align 8, !dbg !295
  store i64 0, ptr %slot.pos, align 8, !dbg !295
  %slot.q = alloca i64, align 8, !dbg !295
  store i64 0, ptr %slot.q, align 8, !dbg !295
  %slot.qpos = alloca i64, align 8, !dbg !295
  store i64 0, ptr %slot.qpos, align 8, !dbg !295
  %slot.i = alloca i64, align 8, !dbg !295
  store i64 0, ptr %slot.i, align 8, !dbg !295
  %slot.start = alloca i64, align 8, !dbg !295
  store i64 0, ptr %slot.start, align 8, !dbg !295
  %slot.out = alloca i64, align 8, !dbg !295
  store i64 0, ptr %slot.out, align 8, !dbg !295
  %slot.j = alloca i64, align 8, !dbg !295
  store i64 0, ptr %slot.j, align 8, !dbg !295
  %slot.c = alloca i64, align 8, !dbg !295
  store i64 0, ptr %slot.c, align 8, !dbg !295
  %slot.__sc_99 = alloca i64, align 8, !dbg !295
  store i64 0, ptr %slot.__sc_99, align 8, !dbg !295
  %slot.nc = alloca i64, align 8, !dbg !295
  store i64 0, ptr %slot.nc, align 8, !dbg !295
  %r0 = load i64, ptr %slot.key, align 8, !dbg !296
  %r1 = call i64 @json_str(i64 %r0), !dbg !296
  %r2.p = getelementptr inbounds [2 x i8], ptr @.str.10, i64 0, i64 0, !dbg !296
  %r2 = ptrtoint ptr %r2.p to i64, !dbg !296
  %r3 = call i64 @nova_rt_str_concat(i64 %r1, i64 %r2), !dbg !296
  store i64 %r3, ptr %slot.needle, align 8, !dbg !296
  %r4 = load i64, ptr %slot.json, align 8, !dbg !297
  %r5 = add i64 %r3, 0, !dbg !297
  %r6 = call i64 @nova_rt_find(i64 %r4, i64 %r5), !dbg !297
  store i64 %r6, ptr %slot.pos, align 8, !dbg !297
  %r7 = add i64 %r6, 0, !dbg !298
  %r8 = add i64 0, 0, !dbg !298
  %r9.cmp = icmp slt i64 %r7, %r8, !dbg !298
  %r9 = zext i1 %r9.cmp to i64, !dbg !298
  %br_then84 = icmp ne i64 %r9, 0, !dbg !298
  br i1 %br_then84, label %then84, label %else85, !dbg !298
then84:
  %r10.p = getelementptr inbounds [1 x i8], ptr @.str.7, i64 0, i64 0, !dbg !299
  %r10 = ptrtoint ptr %r10.p to i64, !dbg !299
  ret i64 %r10, !dbg !299
else85:
  br label %endif86, !dbg !299
endif86:
  %r11 = add i64 34, 0, !dbg !300
  %r12 = call i64 @nova_rt_chr(i64 %r11), !dbg !300
  store i64 %r12, ptr %slot.q, align 8, !dbg !300
  %r13 = add i64 1, 0, !dbg !301
  %r14 = sub i64 0, %r13, !dbg !301
  store i64 %r14, ptr %slot.qpos, align 8, !dbg !301
  %r15 = load i64, ptr %slot.pos, align 8, !dbg !302
  %r16 = load i64, ptr %slot.needle, align 8, !dbg !302
  %r17 = call i64 @nova_rt_len_any(i64 %r16), !dbg !302
  %r18 = add i64 %r15, %r17, !dbg !302
  store i64 %r18, ptr %slot.i, align 8, !dbg !302
  br label %while_hdr87, !dbg !303
while_hdr87:
  %r19 = load i64, ptr %slot.i, align 8, !dbg !303
  %r20 = load i64, ptr %slot.json, align 8, !dbg !303
  %r21 = call i64 @nova_rt_len_any(i64 %r20), !dbg !303
  %r22.cmp = icmp slt i64 %r19, %r21, !dbg !303
  %r22 = zext i1 %r22.cmp to i64, !dbg !303
  %br_while_body88 = icmp ne i64 %r22, 0, !dbg !303
  br i1 %br_while_body88, label %while_body88, label %while_exit89, !prof !90, !dbg !303
while_body88:
  %r23 = load i64, ptr %slot.json, align 8, !dbg !304
  %r24 = load i64, ptr %slot.i, align 8, !dbg !304
  %r25 = call i64 @nova_rt_index_get(i64 %r23, i64 %r24), !dbg !304
  %r26 = load i64, ptr %slot.q, align 8, !dbg !304
  %r27.p0 = inttoptr i64 %r25 to ptr, !dbg !304
  %r27.p1 = inttoptr i64 %r26 to ptr, !dbg !304
  %r27.sc = call i32 @strcmp(ptr %r27.p0, ptr %r27.p1), !dbg !304
  %r27.cmp = icmp eq i32 %r27.sc, 0, !dbg !304
  %r27 = zext i1 %r27.cmp to i64, !dbg !304
  %br_then90 = icmp ne i64 %r27, 0, !dbg !304
  br i1 %br_then90, label %then90, label %else91, !dbg !304
then90:
  %r28 = load i64, ptr %slot.i, align 8, !dbg !305
  store i64 %r28, ptr %slot.qpos, align 8, !dbg !305
  %r29 = load i64, ptr %slot.json, align 8, !dbg !306
  %r30 = call i64 @nova_rt_len_any(i64 %r29), !dbg !306
  store i64 %r30, ptr %slot.i, align 8, !dbg !306
  br label %endif92, !dbg !306
else91:
  %r31 = load i64, ptr %slot.i, align 8, !dbg !307
  %r32 = add i64 1, 0, !dbg !307
  %r33 = add i64 %r31, %r32, !dbg !307
  store i64 %r33, ptr %slot.i, align 8, !dbg !307
  br label %endif92, !dbg !307
endif92:
  br label %while_hdr87, !dbg !307
while_exit89:
  %r34 = load i64, ptr %slot.qpos, align 8, !dbg !308
  %r35 = add i64 0, 0, !dbg !308
  %r36.cmp = icmp slt i64 %r34, %r35, !dbg !308
  %r36 = zext i1 %r36.cmp to i64, !dbg !308
  %br_then93 = icmp ne i64 %r36, 0, !dbg !308
  br i1 %br_then93, label %then93, label %else94, !dbg !308
then93:
  %r37.p = getelementptr inbounds [1 x i8], ptr @.str.7, i64 0, i64 0, !dbg !309
  %r37 = ptrtoint ptr %r37.p to i64, !dbg !309
  ret i64 %r37, !dbg !309
else94:
  br label %endif95, !dbg !309
endif95:
  %r38 = load i64, ptr %slot.qpos, align 8, !dbg !310
  %r39 = add i64 1, 0, !dbg !310
  %r40 = add i64 %r38, %r39, !dbg !310
  store i64 %r40, ptr %slot.start, align 8, !dbg !310
  %r41.p = getelementptr inbounds [1 x i8], ptr @.str.7, i64 0, i64 0, !dbg !311
  %r41 = ptrtoint ptr %r41.p to i64, !dbg !311
  store i64 %r41, ptr %slot.out, align 8, !dbg !311
  %r42 = add i64 %r40, 0, !dbg !312
  store i64 %r42, ptr %slot.j, align 8, !dbg !312
  br label %while_hdr96, !dbg !313
while_hdr96:
  %r43 = load i64, ptr %slot.j, align 8, !dbg !313
  %r44 = load i64, ptr %slot.json, align 8, !dbg !313
  %r45 = call i64 @nova_rt_len_any(i64 %r44), !dbg !313
  %r46.cmp = icmp slt i64 %r43, %r45, !dbg !313
  %r46 = zext i1 %r46.cmp to i64, !dbg !313
  %br_while_body97 = icmp ne i64 %r46, 0, !dbg !313
  br i1 %br_while_body97, label %while_body97, label %while_exit98, !prof !90, !dbg !313
while_body97:
  %r47 = load i64, ptr %slot.json, align 8, !dbg !314
  %r48 = load i64, ptr %slot.j, align 8, !dbg !314
  %r49 = call i64 @nova_rt_index_get(i64 %r47, i64 %r48), !dbg !314
  store i64 %r49, ptr %slot.c, align 8, !dbg !314
  %r50 = add i64 %r49, 0, !dbg !315
  %r51.p = getelementptr inbounds [2 x i8], ptr @.str.1, i64 0, i64 0, !dbg !315
  %r51 = ptrtoint ptr %r51.p to i64, !dbg !315
  %r52.p0 = inttoptr i64 %r50 to ptr, !dbg !315
  %r52.p1 = inttoptr i64 %r51 to ptr, !dbg !315
  %r52.sc = call i32 @strcmp(ptr %r52.p0, ptr %r52.p1), !dbg !315
  %r52.cmp = icmp eq i32 %r52.sc, 0, !dbg !315
  %r52 = zext i1 %r52.cmp to i64, !dbg !315
  store i64 %r52, ptr %slot.__sc_99, align 8, !dbg !315
  %br_and_rhs100 = icmp ne i64 %r52, 0, !dbg !315
  br i1 %br_and_rhs100, label %and_rhs100, label %and_merge101, !dbg !315
and_rhs100:
  %r53 = load i64, ptr %slot.j, align 8, !dbg !315
  %r54 = add i64 1, 0, !dbg !315
  %r55 = add i64 %r53, %r54, !dbg !315
  %r56 = load i64, ptr %slot.json, align 8, !dbg !315
  %r57 = call i64 @nova_rt_len_any(i64 %r56), !dbg !315
  %r58.cmp = icmp slt i64 %r55, %r57, !dbg !315
  %r58 = zext i1 %r58.cmp to i64, !dbg !315
  store i64 %r58, ptr %slot.__sc_99, align 8, !dbg !315
  br label %and_merge101, !dbg !315
and_merge101:
  %r59 = load i64, ptr %slot.__sc_99, align 8, !dbg !315
  %br_then102 = icmp ne i64 %r59, 0, !dbg !315
  br i1 %br_then102, label %then102, label %else103, !dbg !315
then102:
  %r60 = load i64, ptr %slot.json, align 8, !dbg !316
  %r61 = load i64, ptr %slot.j, align 8, !dbg !316
  %r62 = add i64 1, 0, !dbg !316
  %r63 = add i64 %r61, %r62, !dbg !316
  %r64 = call i64 @nova_rt_index_get(i64 %r60, i64 %r63), !dbg !316
  store i64 %r64, ptr %slot.nc, align 8, !dbg !316
  %r65 = add i64 %r64, 0, !dbg !317
  %r66.p = getelementptr inbounds [2 x i8], ptr @.str.24, i64 0, i64 0, !dbg !317
  %r66 = ptrtoint ptr %r66.p to i64, !dbg !317
  %r67.p0 = inttoptr i64 %r65 to ptr, !dbg !317
  %r67.p1 = inttoptr i64 %r66 to ptr, !dbg !317
  %r67.sc = call i32 @strcmp(ptr %r67.p0, ptr %r67.p1), !dbg !317
  %r67.cmp = icmp eq i32 %r67.sc, 0, !dbg !317
  %r67 = zext i1 %r67.cmp to i64, !dbg !317
  %br_then105 = icmp ne i64 %r67, 0, !dbg !317
  br i1 %br_then105, label %then105, label %else106, !dbg !317
then105:
  %r68 = load i64, ptr %slot.out, align 8, !dbg !318
  %r69.p = getelementptr inbounds [2 x i8], ptr @.str.0, i64 0, i64 0, !dbg !318
  %r69 = ptrtoint ptr %r69.p to i64, !dbg !318
  %r70 = call i64 @nova_rt_str_concat(i64 %r68, i64 %r69), !dbg !318
  store i64 %r70, ptr %slot.out, align 8, !dbg !318
  br label %endif107, !dbg !318
else106:
  %r71 = load i64, ptr %slot.nc, align 8, !dbg !319
  %r72.p = getelementptr inbounds [2 x i8], ptr @.str.25, i64 0, i64 0, !dbg !319
  %r72 = ptrtoint ptr %r72.p to i64, !dbg !319
  %r73.p0 = inttoptr i64 %r71 to ptr, !dbg !319
  %r73.p1 = inttoptr i64 %r72 to ptr, !dbg !319
  %r73.sc = call i32 @strcmp(ptr %r73.p0, ptr %r73.p1), !dbg !319
  %r73.cmp = icmp eq i32 %r73.sc, 0, !dbg !319
  %r73 = zext i1 %r73.cmp to i64, !dbg !319
  %br_then108 = icmp ne i64 %r73, 0, !dbg !319
  br i1 %br_then108, label %then108, label %else109, !dbg !319
then108:
  %r74 = load i64, ptr %slot.out, align 8, !dbg !320
  %r75.p = getelementptr inbounds [2 x i8], ptr @.str.8, i64 0, i64 0, !dbg !320
  %r75 = ptrtoint ptr %r75.p to i64, !dbg !320
  %r76 = call i64 @nova_rt_str_concat(i64 %r74, i64 %r75), !dbg !320
  store i64 %r76, ptr %slot.out, align 8, !dbg !320
  br label %endif110, !dbg !320
else109:
  %r77 = load i64, ptr %slot.nc, align 8, !dbg !321
  %r78.p = getelementptr inbounds [2 x i8], ptr @.str.26, i64 0, i64 0, !dbg !321
  %r78 = ptrtoint ptr %r78.p to i64, !dbg !321
  %r79.p0 = inttoptr i64 %r77 to ptr, !dbg !321
  %r79.p1 = inttoptr i64 %r78 to ptr, !dbg !321
  %r79.sc = call i32 @strcmp(ptr %r79.p0, ptr %r79.p1), !dbg !321
  %r79.cmp = icmp eq i32 %r79.sc, 0, !dbg !321
  %r79 = zext i1 %r79.cmp to i64, !dbg !321
  %br_then111 = icmp ne i64 %r79, 0, !dbg !321
  br i1 %br_then111, label %then111, label %else112, !dbg !321
then111:
  %r80 = load i64, ptr %slot.out, align 8, !dbg !322
  %r81.p = getelementptr inbounds [2 x i8], ptr @.str.21, i64 0, i64 0, !dbg !322
  %r81 = ptrtoint ptr %r81.p to i64, !dbg !322
  %r82 = call i64 @nova_rt_str_concat(i64 %r80, i64 %r81), !dbg !322
  store i64 %r82, ptr %slot.out, align 8, !dbg !322
  br label %endif113, !dbg !322
else112:
  %r83 = load i64, ptr %slot.nc, align 8, !dbg !323
  %r84 = load i64, ptr %slot.q, align 8, !dbg !323
  %r85.p0 = inttoptr i64 %r83 to ptr, !dbg !323
  %r85.p1 = inttoptr i64 %r84 to ptr, !dbg !323
  %r85.sc = call i32 @strcmp(ptr %r85.p0, ptr %r85.p1), !dbg !323
  %r85.cmp = icmp eq i32 %r85.sc, 0, !dbg !323
  %r85 = zext i1 %r85.cmp to i64, !dbg !323
  %br_then114 = icmp ne i64 %r85, 0, !dbg !323
  br i1 %br_then114, label %then114, label %else115, !dbg !323
then114:
  %r86 = load i64, ptr %slot.out, align 8, !dbg !324
  %r87 = load i64, ptr %slot.q, align 8, !dbg !324
  %r88 = call i64 @nova_rt_str_concat(i64 %r86, i64 %r87), !dbg !324
  store i64 %r88, ptr %slot.out, align 8, !dbg !324
  br label %endif116, !dbg !324
else115:
  %r89 = load i64, ptr %slot.nc, align 8, !dbg !325
  %r90.p = getelementptr inbounds [2 x i8], ptr @.str.1, i64 0, i64 0, !dbg !325
  %r90 = ptrtoint ptr %r90.p to i64, !dbg !325
  %r91.p0 = inttoptr i64 %r89 to ptr, !dbg !325
  %r91.p1 = inttoptr i64 %r90 to ptr, !dbg !325
  %r91.sc = call i32 @strcmp(ptr %r91.p0, ptr %r91.p1), !dbg !325
  %r91.cmp = icmp eq i32 %r91.sc, 0, !dbg !325
  %r91 = zext i1 %r91.cmp to i64, !dbg !325
  %br_then117 = icmp ne i64 %r91, 0, !dbg !325
  br i1 %br_then117, label %then117, label %else118, !dbg !325
then117:
  %r92 = load i64, ptr %slot.out, align 8, !dbg !326
  %r93.p = getelementptr inbounds [2 x i8], ptr @.str.1, i64 0, i64 0, !dbg !326
  %r93 = ptrtoint ptr %r93.p to i64, !dbg !326
  %r94 = call i64 @nova_rt_str_concat(i64 %r92, i64 %r93), !dbg !326
  store i64 %r94, ptr %slot.out, align 8, !dbg !326
  br label %endif119, !dbg !326
else118:
  %r95 = load i64, ptr %slot.out, align 8, !dbg !327
  %r96 = load i64, ptr %slot.nc, align 8, !dbg !327
  %r97 = call i64 @nova_rt_str_concat(i64 %r95, i64 %r96), !dbg !327
  store i64 %r97, ptr %slot.out, align 8, !dbg !327
  br label %endif119, !dbg !327
endif119:
  br label %endif116, !dbg !327
endif116:
  br label %endif113, !dbg !327
endif113:
  br label %endif110, !dbg !327
endif110:
  br label %endif107, !dbg !327
endif107:
  %r98 = load i64, ptr %slot.j, align 8, !dbg !328
  %r99 = add i64 2, 0, !dbg !328
  %r100 = add i64 %r98, %r99, !dbg !328
  store i64 %r100, ptr %slot.j, align 8, !dbg !328
  br label %endif104, !dbg !328
else103:
  %r101 = load i64, ptr %slot.c, align 8, !dbg !329
  %r102 = load i64, ptr %slot.q, align 8, !dbg !329
  %r103.p0 = inttoptr i64 %r101 to ptr, !dbg !329
  %r103.p1 = inttoptr i64 %r102 to ptr, !dbg !329
  %r103.sc = call i32 @strcmp(ptr %r103.p0, ptr %r103.p1), !dbg !329
  %r103.cmp = icmp eq i32 %r103.sc, 0, !dbg !329
  %r103 = zext i1 %r103.cmp to i64, !dbg !329
  %br_then120 = icmp ne i64 %r103, 0, !dbg !329
  br i1 %br_then120, label %then120, label %else121, !dbg !329
then120:
  %r104 = load i64, ptr %slot.out, align 8, !dbg !330
  ret i64 %r104, !dbg !330
else121:
  %r105 = load i64, ptr %slot.out, align 8, !dbg !331
  %r106 = load i64, ptr %slot.c, align 8, !dbg !331
  %r107 = call i64 @nova_rt_str_concat(i64 %r105, i64 %r106), !dbg !331
  store i64 %r107, ptr %slot.out, align 8, !dbg !331
  %r108 = load i64, ptr %slot.j, align 8, !dbg !332
  %r109 = add i64 1, 0, !dbg !332
  %r110 = add i64 %r108, %r109, !dbg !332
  store i64 %r110, ptr %slot.j, align 8, !dbg !332
  br label %endif122, !dbg !332
endif122:
  br label %endif104, !dbg !332
endif104:
  br label %while_hdr96, !dbg !332
while_exit98:
  %r111 = load i64, ptr %slot.out, align 8, !dbg !333
  ret i64 %r111, !dbg !333
}

define i64 @parse_errors(i64 %p0) nounwind !dbg !334 {
entry:
  %slot.compiler_output = alloca i64, align 8, !dbg !335
  store i64 %p0, ptr %slot.compiler_output, align 8, !dbg !335
  %slot.diagnostics = alloca i64, align 8, !dbg !335
  store i64 0, ptr %slot.diagnostics, align 8, !dbg !335
  %slot.lines = alloca i64, align 8, !dbg !335
  store i64 0, ptr %slot.lines, align 8, !dbg !335
  %slot.i = alloca i64, align 8, !dbg !335
  store i64 0, ptr %slot.i, align 8, !dbg !335
  %slot.cur_line = alloca i64, align 8, !dbg !335
  store i64 0, ptr %slot.cur_line, align 8, !dbg !335
  %slot.cur_msg = alloca i64, align 8, !dbg !335
  store i64 0, ptr %slot.cur_msg, align 8, !dbg !335
  %slot.line = alloca i64, align 8, !dbg !335
  store i64 0, ptr %slot.line, align 8, !dbg !335
  %slot.err_pos = alloca i64, align 8, !dbg !335
  store i64 0, ptr %slot.err_pos, align 8, !dbg !335
  %slot.colon = alloca i64, align 8, !dbg !335
  store i64 0, ptr %slot.colon, align 8, !dbg !335
  %slot.arrow = alloca i64, align 8, !dbg !335
  store i64 0, ptr %slot.arrow, align 8, !dbg !335
  %slot.rest = alloca i64, align 8, !dbg !335
  store i64 0, ptr %slot.rest, align 8, !dbg !335
  %slot.after = alloca i64, align 8, !dbg !335
  store i64 0, ptr %slot.after, align 8, !dbg !335
  %slot.next_colon = alloca i64, align 8, !dbg !335
  store i64 0, ptr %slot.next_colon, align 8, !dbg !335
  %slot.line_str = alloca i64, align 8, !dbg !335
  store i64 0, ptr %slot.line_str, align 8, !dbg !335
  %slot.__sc_141 = alloca i64, align 8, !dbg !335
  store i64 0, ptr %slot.__sc_141, align 8, !dbg !335
  %r0 = call i64 @nova_rt_list_create(), !dbg !336
  store i64 %r0, ptr %slot.diagnostics, align 8, !dbg !336
  %r1 = load i64, ptr %slot.compiler_output, align 8, !dbg !337
  %r2.p = getelementptr inbounds [2 x i8], ptr @.str.0, i64 0, i64 0, !dbg !337
  %r2 = ptrtoint ptr %r2.p to i64, !dbg !337
  %r3 = call i64 @nova_rt_split(i64 %r1, i64 %r2), !dbg !337
  store i64 %r3, ptr %slot.lines, align 8, !dbg !337
  %r4 = add i64 0, 0, !dbg !338
  store i64 %r4, ptr %slot.i, align 8, !dbg !338
  %r5 = add i64 1, 0, !dbg !339
  %r6 = sub i64 0, %r5, !dbg !339
  store i64 %r6, ptr %slot.cur_line, align 8, !dbg !339
  %r7.p = getelementptr inbounds [1 x i8], ptr @.str.7, i64 0, i64 0, !dbg !340
  %r7 = ptrtoint ptr %r7.p to i64, !dbg !340
  store i64 %r7, ptr %slot.cur_msg, align 8, !dbg !340
  br label %while_hdr123, !dbg !341
while_hdr123:
  %r8 = load i64, ptr %slot.i, align 8, !dbg !341
  %r9 = load i64, ptr %slot.lines, align 8, !dbg !341
  %r10.lp = inttoptr i64 %r9 to ptr, !dbg !341
  %r10.szp = getelementptr i64, ptr %r10.lp, i64 1, !dbg !341
  %r10 = load i64, ptr %r10.szp, align 8, !tbaa !6, !dbg !341
  %r11.cmp = icmp slt i64 %r8, %r10, !dbg !341
  %r11 = zext i1 %r11.cmp to i64, !dbg !341
  %br_while_body124 = icmp ne i64 %r11, 0, !dbg !341
  br i1 %br_while_body124, label %while_body124, label %while_exit125, !prof !90, !dbg !341
while_body124:
  %r12 = load i64, ptr %slot.lines, align 8, !dbg !342
  %r13 = load i64, ptr %slot.i, align 8, !dbg !342
  %r14 = call i64 @nova_rt_index_get(i64 %r12, i64 %r13), !dbg !342
  store i64 %r14, ptr %slot.line, align 8, !dbg !342
  %r15 = add i64 %r14, 0, !dbg !343
  %r16.p = getelementptr inbounds [7 x i8], ptr @.str.27, i64 0, i64 0, !dbg !343
  %r16 = ptrtoint ptr %r16.p to i64, !dbg !343
  %r17 = call i64 @nova_rt_find(i64 %r15, i64 %r16), !dbg !343
  store i64 %r17, ptr %slot.err_pos, align 8, !dbg !343
  %r18 = add i64 %r17, 0, !dbg !344
  %r19 = add i64 0, 0, !dbg !344
  %r20.cmp = icmp sge i64 %r18, %r19, !dbg !344
  %r20 = zext i1 %r20.cmp to i64, !dbg !344
  %br_then126 = icmp ne i64 %r20, 0, !dbg !344
  br i1 %br_then126, label %then126, label %else127, !dbg !344
then126:
  %r21 = load i64, ptr %slot.line, align 8, !dbg !345
  %r22.p = getelementptr inbounds [3 x i8], ptr @.str.28, i64 0, i64 0, !dbg !345
  %r22 = ptrtoint ptr %r22.p to i64, !dbg !345
  %r23 = call i64 @nova_rt_find(i64 %r21, i64 %r22), !dbg !345
  store i64 %r23, ptr %slot.colon, align 8, !dbg !345
  %r24 = add i64 %r23, 0, !dbg !346
  %r25 = load i64, ptr %slot.err_pos, align 8, !dbg !346
  %r26.cmp = icmp sgt i64 %r24, %r25, !dbg !346
  %r26 = zext i1 %r26.cmp to i64, !dbg !346
  %br_then129 = icmp ne i64 %r26, 0, !dbg !346
  br i1 %br_then129, label %then129, label %else130, !dbg !346
then129:
  %r27 = load i64, ptr %slot.line, align 8, !dbg !347
  %r28 = load i64, ptr %slot.colon, align 8, !dbg !347
  %r29 = add i64 2, 0, !dbg !347
  %r30 = add i64 %r28, %r29, !dbg !347
  %r31 = load i64, ptr %slot.line, align 8, !dbg !347
  %r32 = call i64 @nova_rt_len_any(i64 %r31), !dbg !347
  %r33 = call i64 @nova_rt_slice(i64 %r27, i64 %r30, i64 %r32), !dbg !347
  %r34 = call i64 @nova_rt_trim(i64 %r33), !dbg !347
  store i64 %r34, ptr %slot.cur_msg, align 8, !dbg !347
  br label %endif131, !dbg !347
else130:
  br label %endif131, !dbg !347
endif131:
  br label %endif128, !dbg !347
else127:
  %r35 = load i64, ptr %slot.line, align 8, !dbg !348
  %r36.p = getelementptr inbounds [5 x i8], ptr @.str.29, i64 0, i64 0, !dbg !348
  %r36 = ptrtoint ptr %r36.p to i64, !dbg !348
  %r37 = call i64 @nova_rt_find(i64 %r35, i64 %r36), !dbg !348
  %r38 = add i64 0, 0, !dbg !348
  %r39.cmp = icmp sge i64 %r37, %r38, !dbg !348
  %r39 = zext i1 %r39.cmp to i64, !dbg !348
  %br_then132 = icmp ne i64 %r39, 0, !dbg !348
  br i1 %br_then132, label %then132, label %else133, !dbg !348
then132:
  %r40 = load i64, ptr %slot.line, align 8, !dbg !349
  %r41.p = getelementptr inbounds [5 x i8], ptr @.str.29, i64 0, i64 0, !dbg !349
  %r41 = ptrtoint ptr %r41.p to i64, !dbg !349
  %r42 = call i64 @nova_rt_find(i64 %r40, i64 %r41), !dbg !349
  store i64 %r42, ptr %slot.arrow, align 8, !dbg !349
  %r43 = load i64, ptr %slot.line, align 8, !dbg !350
  %r44 = add i64 %r42, 0, !dbg !350
  %r45 = add i64 4, 0, !dbg !350
  %r46 = add i64 %r44, %r45, !dbg !350
  %r47 = load i64, ptr %slot.line, align 8, !dbg !350
  %r48 = call i64 @nova_rt_len_any(i64 %r47), !dbg !350
  %r49 = call i64 @nova_rt_slice(i64 %r43, i64 %r46, i64 %r48), !dbg !350
  store i64 %r49, ptr %slot.rest, align 8, !dbg !350
  %r50 = add i64 %r49, 0, !dbg !351
  %r51.p = getelementptr inbounds [2 x i8], ptr @.str.10, i64 0, i64 0, !dbg !351
  %r51 = ptrtoint ptr %r51.p to i64, !dbg !351
  %r52 = call i64 @nova_rt_find(i64 %r50, i64 %r51), !dbg !351
  store i64 %r52, ptr %slot.colon, align 8, !dbg !351
  %r53 = add i64 %r52, 0, !dbg !352
  %r54 = add i64 0, 0, !dbg !352
  %r55.cmp = icmp sgt i64 %r53, %r54, !dbg !352
  %r55 = zext i1 %r55.cmp to i64, !dbg !352
  %br_then135 = icmp ne i64 %r55, 0, !dbg !352
  br i1 %br_then135, label %then135, label %else136, !dbg !352
then135:
  %r56 = load i64, ptr %slot.rest, align 8, !dbg !353
  %r57 = load i64, ptr %slot.colon, align 8, !dbg !353
  %r58 = add i64 1, 0, !dbg !353
  %r59 = add i64 %r57, %r58, !dbg !353
  %r60 = load i64, ptr %slot.rest, align 8, !dbg !353
  %r61 = call i64 @nova_rt_len_any(i64 %r60), !dbg !353
  %r62 = call i64 @nova_rt_slice(i64 %r56, i64 %r59, i64 %r61), !dbg !353
  store i64 %r62, ptr %slot.after, align 8, !dbg !353
  %r63 = add i64 %r62, 0, !dbg !354
  %r64.p = getelementptr inbounds [2 x i8], ptr @.str.10, i64 0, i64 0, !dbg !354
  %r64 = ptrtoint ptr %r64.p to i64, !dbg !354
  %r65 = call i64 @nova_rt_find(i64 %r63, i64 %r64), !dbg !354
  store i64 %r65, ptr %slot.next_colon, align 8, !dbg !354
  %r66 = add i64 %r62, 0, !dbg !355
  store i64 %r66, ptr %slot.line_str, align 8, !dbg !355
  %r67 = add i64 %r65, 0, !dbg !356
  %r68 = add i64 0, 0, !dbg !356
  %r69.cmp = icmp sgt i64 %r67, %r68, !dbg !356
  %r69 = zext i1 %r69.cmp to i64, !dbg !356
  %br_then138 = icmp ne i64 %r69, 0, !dbg !356
  br i1 %br_then138, label %then138, label %else139, !dbg !356
then138:
  %r70 = load i64, ptr %slot.after, align 8, !dbg !357
  %r71 = add i64 0, 0, !dbg !357
  %r72 = load i64, ptr %slot.next_colon, align 8, !dbg !357
  %r73 = call i64 @nova_rt_slice(i64 %r70, i64 %r71, i64 %r72), !dbg !357
  store i64 %r73, ptr %slot.line_str, align 8, !dbg !357
  br label %endif140, !dbg !357
else139:
  br label %endif140, !dbg !357
endif140:
  %r74 = load i64, ptr %slot.line_str, align 8, !dbg !358
  %r75 = call i64 @nova_rt_parse_int(i64 %r74), !dbg !358
  store i64 %r75, ptr %slot.cur_line, align 8, !dbg !358
  %r76 = add i64 %r75, 0, !dbg !359
  %r77 = add i64 0, 0, !dbg !359
  %r78.cmp = icmp sgt i64 %r76, %r77, !dbg !359
  %r78 = zext i1 %r78.cmp to i64, !dbg !359
  store i64 %r78, ptr %slot.__sc_141, align 8, !dbg !359
  %br_and_rhs142 = icmp ne i64 %r78, 0, !dbg !359
  br i1 %br_and_rhs142, label %and_rhs142, label %and_merge143, !dbg !359
and_rhs142:
  %r79 = load i64, ptr %slot.cur_msg, align 8, !dbg !359
  %r80 = call i64 @nova_rt_len_any(i64 %r79), !dbg !359
  %r81 = add i64 0, 0, !dbg !359
  %r82.cmp = icmp sgt i64 %r80, %r81, !dbg !359
  %r82 = zext i1 %r82.cmp to i64, !dbg !359
  store i64 %r82, ptr %slot.__sc_141, align 8, !dbg !359
  br label %and_merge143, !dbg !359
and_merge143:
  %r83 = load i64, ptr %slot.__sc_141, align 8, !dbg !359
  %br_then144 = icmp ne i64 %r83, 0, !dbg !359
  br i1 %br_then144, label %then144, label %else145, !dbg !359
then144:
  %r84 = load i64, ptr %slot.diagnostics, align 8, !dbg !360
  %r85 = load i64, ptr %slot.cur_line, align 8, !dbg !360
  %r86 = add i64 1, 0, !dbg !360
  %r87 = sub i64 %r85, %r86, !dbg !360
  %r88 = add i64 1, 0, !dbg !360
  %r89 = load i64, ptr %slot.cur_msg, align 8, !dbg !360
  %r90.ptr = call ptr @nova_rt_struct_alloc(i64 32), !dbg !360
  %r90.thash = getelementptr i64, ptr %r90.ptr, i64 0, !dbg !360
  store i64 8244734445003210858, ptr %r90.thash, align 8, !dbg !360
  %r90.f0 = getelementptr i64, ptr %r90.ptr, i64 1, !dbg !360
  store i64 %r87, ptr %r90.f0, align 8, !dbg !360
  %r90.f1 = getelementptr i64, ptr %r90.ptr, i64 2, !dbg !360
  store i64 %r88, ptr %r90.f1, align 8, !dbg !360
  %r90.f2 = getelementptr i64, ptr %r90.ptr, i64 3, !dbg !360
  store i64 %r89, ptr %r90.f2, align 8, !dbg !360
  %r90 = ptrtoint ptr %r90.ptr to i64, !dbg !360
  %r91 = call i64 @nova_rt_list_append(i64 %r84, i64 %r90), !dbg !360
  %r92 = add i64 1, 0, !dbg !361
  %r93 = sub i64 0, %r92, !dbg !361
  store i64 %r93, ptr %slot.cur_line, align 8, !dbg !361
  %r94.p = getelementptr inbounds [1 x i8], ptr @.str.7, i64 0, i64 0, !dbg !362
  %r94 = ptrtoint ptr %r94.p to i64, !dbg !362
  store i64 %r94, ptr %slot.cur_msg, align 8, !dbg !362
  br label %endif146, !dbg !362
else145:
  br label %endif146, !dbg !362
endif146:
  br label %endif137, !dbg !362
else136:
  br label %endif137, !dbg !362
endif137:
  br label %endif134, !dbg !362
else133:
  br label %endif134, !dbg !362
endif134:
  br label %endif128, !dbg !362
endif128:
  %r95 = load i64, ptr %slot.i, align 8, !dbg !363
  %r96 = add i64 1, 0, !dbg !363
  %r97 = add i64 %r95, %r96, !dbg !363
  store i64 %r97, ptr %slot.i, align 8, !dbg !363
  br label %while_hdr123, !dbg !363
while_exit125:
  %r98 = load i64, ptr %slot.diagnostics, align 8, !dbg !364
  ret i64 %r98, !dbg !364
}

define i64 @run_compile_for_uri(i64 %p0, i64 %p1, i64 %p2) nounwind !dbg !365 {
entry:
  %slot.uri = alloca i64, align 8, !dbg !366
  store i64 %p0, ptr %slot.uri, align 8, !dbg !366
  %slot.content = alloca i64, align 8, !dbg !366
  store i64 %p1, ptr %slot.content, align 8, !dbg !366
  %slot.compiler = alloca i64, align 8, !dbg !366
  store i64 %p2, ptr %slot.compiler, align 8, !dbg !366
  %slot.check_path = alloca i64, align 8, !dbg !366
  store i64 0, ptr %slot.check_path, align 8, !dbg !366
  %slot.q = alloca i64, align 8, !dbg !366
  store i64 0, ptr %slot.q, align 8, !dbg !366
  %slot.output = alloca i64, align 8, !dbg !366
  store i64 0, ptr %slot.output, align 8, !dbg !366
  %r0.p = getelementptr inbounds [19 x i8], ptr @.str.30, i64 0, i64 0, !dbg !367
  %r0 = ptrtoint ptr %r0.p to i64, !dbg !367
  store i64 %r0, ptr %slot.check_path, align 8, !dbg !367
  %r1 = add i64 %r0, 0, !dbg !368
  %r2 = load i64, ptr %slot.content, align 8, !dbg !368
  %r3 = call i64 @nova_rt_write_file(i64 %r1, i64 %r2), !dbg !368
  %r4 = add i64 34, 0, !dbg !369
  %r5 = call i64 @nova_rt_chr(i64 %r4), !dbg !369
  store i64 %r5, ptr %slot.q, align 8, !dbg !369
  %r6 = add i64 %r5, 0, !dbg !370
  %r7 = load i64, ptr %slot.compiler, align 8, !dbg !370
  %r8 = call i64 @nova_rt_str_concat(i64 %r6, i64 %r7), !dbg !370
  %r9 = add i64 %r5, 0, !dbg !370
  %r10 = call i64 @nova_rt_str_concat(i64 %r8, i64 %r9), !dbg !370
  %r11.p = getelementptr inbounds [2 x i8], ptr @.str.20, i64 0, i64 0, !dbg !370
  %r11 = ptrtoint ptr %r11.p to i64, !dbg !370
  %r12 = call i64 @nova_rt_str_concat(i64 %r10, i64 %r11), !dbg !370
  %r13 = add i64 %r0, 0, !dbg !370
  %r14 = call i64 @nova_rt_str_concat(i64 %r12, i64 %r13), !dbg !370
  %r15 = call i64 @nova_rt_exec(i64 %r14), !dbg !370
  store i64 %r15, ptr %slot.output, align 8, !dbg !370
  %r16 = add i64 %r15, 0, !dbg !371
  %r17 = call i64 @parse_errors(i64 %r16), !dbg !371
  ret i64 %r17, !dbg !371
}

define i64 @diag_to_json(i64 %p0) nounwind !dbg !372 {
entry:
  %slot.d = alloca i64, align 8, !dbg !373
  store i64 %p0, ptr %slot.d, align 8, !dbg !373
  %slot.line_no = alloca i64, align 8, !dbg !373
  store i64 0, ptr %slot.line_no, align 8, !dbg !373
  %slot.sev = alloca i64, align 8, !dbg !373
  store i64 0, ptr %slot.sev, align 8, !dbg !373
  %slot.msg = alloca i64, align 8, !dbg !373
  store i64 0, ptr %slot.msg, align 8, !dbg !373
  %r0 = load i64, ptr %slot.d, align 8, !dbg !374
  %r1.ptr = inttoptr i64 %r0 to ptr, !dbg !374
  %r1.gep = getelementptr i64, ptr %r1.ptr, i64 0, !dbg !374
  %r1 = load i64, ptr %r1.gep, align 8, !dbg !374
  %r2 = add i64 8244734445003210858, 0, !dbg !374
  %r3.cmp = icmp eq i64 %r1, %r2, !dbg !374
  %r3 = zext i1 %r3.cmp to i64, !dbg !374
  %br_rmarm_0147 = icmp ne i64 %r3, 0, !dbg !374
  br i1 %br_rmarm_0147, label %rmarm_0147, label %rmatch_fall148, !dbg !374
rmarm_0147:
  %r4.ptr = inttoptr i64 %r0 to ptr, !dbg !374
  %r4.gep = getelementptr i64, ptr %r4.ptr, i64 1, !dbg !374
  %r4 = load i64, ptr %r4.gep, align 8, !dbg !374
  store i64 %r4, ptr %slot.line_no, align 8, !dbg !374
  %r5.ptr = inttoptr i64 %r0 to ptr, !dbg !374
  %r5.gep = getelementptr i64, ptr %r5.ptr, i64 2, !dbg !374
  %r5 = load i64, ptr %r5.gep, align 8, !dbg !374
  store i64 %r5, ptr %slot.sev, align 8, !dbg !374
  %r6.ptr = inttoptr i64 %r0 to ptr, !dbg !374
  %r6.gep = getelementptr i64, ptr %r6.ptr, i64 3, !dbg !374
  %r6 = load i64, ptr %r6.gep, align 8, !dbg !374
  store i64 %r6, ptr %slot.msg, align 8, !dbg !374
  %r7.p = getelementptr inbounds [27 x i8], ptr @.str.31, i64 0, i64 0, !dbg !375
  %r7 = ptrtoint ptr %r7.p to i64, !dbg !375
  %r8 = add i64 %r4, 0, !dbg !375
  %r9 = call i64 @nova_rt_int_to_str(i64 %r8), !dbg !375
  %r10 = call i64 @nova_rt_str_concat(i64 %r7, i64 %r9), !dbg !375
  %r11.p = getelementptr inbounds [31 x i8], ptr @.str.32, i64 0, i64 0, !dbg !375
  %r11 = ptrtoint ptr %r11.p to i64, !dbg !375
  %r12 = call i64 @nova_rt_str_concat(i64 %r10, i64 %r11), !dbg !375
  %r13 = add i64 %r4, 0, !dbg !375
  %r14 = call i64 @nova_rt_int_to_str(i64 %r13), !dbg !375
  %r15 = call i64 @nova_rt_str_concat(i64 %r12, i64 %r14), !dbg !375
  %r16.p = getelementptr inbounds [31 x i8], ptr @.str.33, i64 0, i64 0, !dbg !375
  %r16 = ptrtoint ptr %r16.p to i64, !dbg !375
  %r17 = call i64 @nova_rt_str_concat(i64 %r15, i64 %r16), !dbg !375
  %r18 = add i64 %r5, 0, !dbg !375
  %r19 = call i64 @nova_rt_int_to_str(i64 %r18), !dbg !375
  %r20 = call i64 @nova_rt_str_concat(i64 %r17, i64 %r19), !dbg !375
  %r21.p = getelementptr inbounds [28 x i8], ptr @.str.34, i64 0, i64 0, !dbg !375
  %r21 = ptrtoint ptr %r21.p to i64, !dbg !375
  %r22 = call i64 @nova_rt_str_concat(i64 %r20, i64 %r21), !dbg !375
  %r23 = add i64 %r6, 0, !dbg !375
  %r24 = call i64 @json_str(i64 %r23), !dbg !375
  %r25 = call i64 @nova_rt_str_concat(i64 %r22, i64 %r24), !dbg !375
  %r26.p = getelementptr inbounds [2 x i8], ptr @.str.17, i64 0, i64 0, !dbg !375
  %r26 = ptrtoint ptr %r26.p to i64, !dbg !375
  %r27 = call i64 @nova_rt_str_concat(i64 %r25, i64 %r26), !dbg !375
  ret i64 %r27, !dbg !375
rmatch_fall148:
  ret i64 0, !dbg !375
}

define i64 @diags_to_array(i64 %p0) nounwind !dbg !376 {
entry:
  %slot.ds = alloca i64, align 8, !dbg !377
  store i64 %p0, ptr %slot.ds, align 8, !dbg !377
  %slot.out = alloca i64, align 8, !dbg !377
  store i64 0, ptr %slot.out, align 8, !dbg !377
  %slot.i = alloca i64, align 8, !dbg !377
  store i64 0, ptr %slot.i, align 8, !dbg !377
  %slot.__for_idx_149 = alloca i64, align 8, !dbg !377
  store i64 0, ptr %slot.__for_idx_149, align 8, !dbg !377
  %slot.d = alloca i64, align 8, !dbg !377
  store i64 0, ptr %slot.d, align 8, !dbg !377
  %r0.p = getelementptr inbounds [2 x i8], ptr @.str.35, i64 0, i64 0, !dbg !378
  %r0 = ptrtoint ptr %r0.p to i64, !dbg !378
  store i64 %r0, ptr %slot.out, align 8, !dbg !378
  %r1 = add i64 0, 0, !dbg !379
  store i64 %r1, ptr %slot.i, align 8, !dbg !379
  %r2 = load i64, ptr %slot.ds, align 8, !dbg !380
  %r3 = add i64 %r2, 0, !dbg !380
  %r4.lp = inttoptr i64 %r3 to ptr, !dbg !380
  %r4.szp = getelementptr i64, ptr %r4.lp, i64 1, !dbg !380
  %r4 = load i64, ptr %r4.szp, align 8, !tbaa !6, !dbg !380
  %r5 = add i64 0, 0, !dbg !380
  store i64 %r5, ptr %slot.__for_idx_149, align 8, !dbg !380
  br label %for_hdr149, !dbg !380
for_hdr149:
  %r6 = load i64, ptr %slot.__for_idx_149, align 8, !dbg !380
  %r7.cmp = icmp slt i64 %r6, %r4, !dbg !380
  %r7 = zext i1 %r7.cmp to i64, !dbg !380
  %br_for_body150 = icmp ne i64 %r7, 0, !dbg !380
  br i1 %br_for_body150, label %for_body150, label %for_exit151, !prof !90, !dbg !380
for_body150:
  %r8.lp = inttoptr i64 %r3 to ptr, !dbg !380
  %r8.dp = load ptr, ptr %r8.lp, align 8, !tbaa !2, !dbg !380
  %r8.ep = getelementptr i64, ptr %r8.dp, i64 %r6, !dbg !380
  %r8 = load i64, ptr %r8.ep, align 8, !tbaa !4, !dbg !380
  store i64 %r8, ptr %slot.d, align 8, !dbg !380
  %r9 = load i64, ptr %slot.i, align 8, !dbg !381
  %r10 = add i64 0, 0, !dbg !381
  %r11.cmp = icmp sgt i64 %r9, %r10, !dbg !381
  %r11 = zext i1 %r11.cmp to i64, !dbg !381
  %br_then152 = icmp ne i64 %r11, 0, !dbg !381
  br i1 %br_then152, label %then152, label %else153, !dbg !381
then152:
  %r12 = load i64, ptr %slot.out, align 8, !dbg !382
  %r13.p = getelementptr inbounds [2 x i8], ptr @.str.22, i64 0, i64 0, !dbg !382
  %r13 = ptrtoint ptr %r13.p to i64, !dbg !382
  %r14 = call i64 @nova_rt_str_concat(i64 %r12, i64 %r13), !dbg !382
  store i64 %r14, ptr %slot.out, align 8, !dbg !382
  br label %endif154, !dbg !382
else153:
  br label %endif154, !dbg !382
endif154:
  %r15 = load i64, ptr %slot.out, align 8, !dbg !383
  %r16 = load i64, ptr %slot.d, align 8, !dbg !383
  %r17 = call i64 @diag_to_json(i64 %r16), !dbg !383
  %r18 = call i64 @nova_rt_str_concat(i64 %r15, i64 %r17), !dbg !383
  store i64 %r18, ptr %slot.out, align 8, !dbg !383
  %r19 = load i64, ptr %slot.i, align 8, !dbg !384
  %r20 = add i64 1, 0, !dbg !384
  %r21 = add i64 %r19, %r20, !dbg !384
  store i64 %r21, ptr %slot.i, align 8, !dbg !384
  %r22 = load i64, ptr %slot.__for_idx_149, align 8, !dbg !384
  %r23 = add i64 1, 0, !dbg !384
  %r24 = add i64 %r22, %r23, !dbg !384
  store i64 %r24, ptr %slot.__for_idx_149, align 8, !dbg !384
  br label %for_hdr149, !dbg !384
for_exit151:
  %r25 = load i64, ptr %slot.out, align 8, !dbg !385
  %r26.p = getelementptr inbounds [2 x i8], ptr @.str.23, i64 0, i64 0, !dbg !385
  %r26 = ptrtoint ptr %r26.p to i64, !dbg !385
  %r27 = call i64 @nova_rt_str_concat(i64 %r25, i64 %r26), !dbg !385
  ret i64 %r27, !dbg !385
}

define i64 @publish_diagnostics(i64 %p0, i64 %p1) nounwind !dbg !386 {
entry:
  %slot.uri = alloca i64, align 8, !dbg !387
  store i64 %p0, ptr %slot.uri, align 8, !dbg !387
  %slot.ds = alloca i64, align 8, !dbg !387
  store i64 %p1, ptr %slot.ds, align 8, !dbg !387
  %slot.diag_array = alloca i64, align 8, !dbg !387
  store i64 0, ptr %slot.diag_array, align 8, !dbg !387
  %slot.params = alloca i64, align 8, !dbg !387
  store i64 0, ptr %slot.params, align 8, !dbg !387
  %r0 = load i64, ptr %slot.ds, align 8, !dbg !388
  %r1 = call i64 @diags_to_array(i64 %r0), !dbg !388
  store i64 %r1, ptr %slot.diag_array, align 8, !dbg !388
  %r2.p = getelementptr inbounds [8 x i8], ptr @.str.36, i64 0, i64 0, !dbg !389
  %r2 = ptrtoint ptr %r2.p to i64, !dbg !389
  %r3 = load i64, ptr %slot.uri, align 8, !dbg !389
  %r4 = call i64 @json_str(i64 %r3), !dbg !389
  %r5 = call i64 @nova_rt_str_concat(i64 %r2, i64 %r4), !dbg !389
  %r6.p = getelementptr inbounds [16 x i8], ptr @.str.37, i64 0, i64 0, !dbg !389
  %r6 = ptrtoint ptr %r6.p to i64, !dbg !389
  %r7 = call i64 @nova_rt_str_concat(i64 %r5, i64 %r6), !dbg !389
  %r8 = add i64 %r1, 0, !dbg !389
  %r9 = call i64 @nova_rt_str_concat(i64 %r7, i64 %r8), !dbg !389
  %r10.p = getelementptr inbounds [2 x i8], ptr @.str.17, i64 0, i64 0, !dbg !389
  %r10 = ptrtoint ptr %r10.p to i64, !dbg !389
  %r11 = call i64 @nova_rt_str_concat(i64 %r9, i64 %r10), !dbg !389
  store i64 %r11, ptr %slot.params, align 8, !dbg !389
  %r12.p = getelementptr inbounds [32 x i8], ptr @.str.38, i64 0, i64 0, !dbg !390
  %r12 = ptrtoint ptr %r12.p to i64, !dbg !390
  %r13 = add i64 %r11, 0, !dbg !390
  %r14 = call i64 @build_notification(i64 %r12, i64 %r13), !dbg !390
  %r15 = call i64 @send_message(i64 %r14), !dbg !390
  ret i64 %r15, !dbg !390
}

define i64 @server_capabilities() nounwind !dbg !391 {
entry:
  %slot.caps = alloca i64, align 8, !dbg !392
  store i64 0, ptr %slot.caps, align 8, !dbg !392
  %slot.info = alloca i64, align 8, !dbg !392
  store i64 0, ptr %slot.info, align 8, !dbg !392
  %r0.p = getelementptr inbounds [2 x i8], ptr @.str.39, i64 0, i64 0, !dbg !393
  %r0 = ptrtoint ptr %r0.p to i64, !dbg !393
  store i64 %r0, ptr %slot.caps, align 8, !dbg !393
  %r1 = add i64 %r0, 0, !dbg !394
  %r2.p = getelementptr inbounds [22 x i8], ptr @.str.40, i64 0, i64 0, !dbg !394
  %r2 = ptrtoint ptr %r2.p to i64, !dbg !394
  %r3 = call i64 @nova_rt_str_concat(i64 %r1, i64 %r2), !dbg !394
  store i64 %r3, ptr %slot.caps, align 8, !dbg !394
  %r4 = add i64 %r3, 0, !dbg !395
  %r5.p = getelementptr inbounds [22 x i8], ptr @.str.41, i64 0, i64 0, !dbg !395
  %r5 = ptrtoint ptr %r5.p to i64, !dbg !395
  %r6 = call i64 @nova_rt_str_concat(i64 %r4, i64 %r5), !dbg !395
  store i64 %r6, ptr %slot.caps, align 8, !dbg !395
  %r7 = add i64 %r6, 0, !dbg !396
  %r8.p = getelementptr inbounds [27 x i8], ptr @.str.42, i64 0, i64 0, !dbg !396
  %r8 = ptrtoint ptr %r8.p to i64, !dbg !396
  %r9 = call i64 @nova_rt_str_concat(i64 %r7, i64 %r8), !dbg !396
  store i64 %r9, ptr %slot.caps, align 8, !dbg !396
  %r10 = add i64 %r9, 0, !dbg !397
  %r11.p = getelementptr inbounds [50 x i8], ptr @.str.43, i64 0, i64 0, !dbg !397
  %r11 = ptrtoint ptr %r11.p to i64, !dbg !397
  %r12 = call i64 @nova_rt_str_concat(i64 %r10, i64 %r11), !dbg !397
  store i64 %r12, ptr %slot.caps, align 8, !dbg !397
  %r13 = add i64 %r12, 0, !dbg !398
  %r14.p = getelementptr inbounds [82 x i8], ptr @.str.44, i64 0, i64 0, !dbg !398
  %r14 = ptrtoint ptr %r14.p to i64, !dbg !398
  %r15 = call i64 @nova_rt_str_concat(i64 %r13, i64 %r14), !dbg !398
  store i64 %r15, ptr %slot.caps, align 8, !dbg !398
  %r16 = add i64 %r15, 0, !dbg !399
  %r17.p = getelementptr inbounds [2 x i8], ptr @.str.17, i64 0, i64 0, !dbg !399
  %r17 = ptrtoint ptr %r17.p to i64, !dbg !399
  %r18 = call i64 @nova_rt_str_concat(i64 %r16, i64 %r17), !dbg !399
  store i64 %r18, ptr %slot.caps, align 8, !dbg !399
  %r19.p = getelementptr inbounds [38 x i8], ptr @.str.45, i64 0, i64 0, !dbg !400
  %r19 = ptrtoint ptr %r19.p to i64, !dbg !400
  store i64 %r19, ptr %slot.info, align 8, !dbg !400
  %r20.p = getelementptr inbounds [17 x i8], ptr @.str.46, i64 0, i64 0, !dbg !401
  %r20 = ptrtoint ptr %r20.p to i64, !dbg !401
  %r21 = add i64 %r18, 0, !dbg !401
  %r22 = call i64 @nova_rt_str_concat(i64 %r20, i64 %r21), !dbg !401
  %r23.p = getelementptr inbounds [15 x i8], ptr @.str.47, i64 0, i64 0, !dbg !401
  %r23 = ptrtoint ptr %r23.p to i64, !dbg !401
  %r24 = call i64 @nova_rt_str_concat(i64 %r22, i64 %r23), !dbg !401
  %r25 = add i64 %r19, 0, !dbg !401
  %r26 = call i64 @nova_rt_str_concat(i64 %r24, i64 %r25), !dbg !401
  %r27.p = getelementptr inbounds [2 x i8], ptr @.str.17, i64 0, i64 0, !dbg !401
  %r27 = ptrtoint ptr %r27.p to i64, !dbg !401
  %r28 = call i64 @nova_rt_str_concat(i64 %r26, i64 %r27), !dbg !401
  ret i64 %r28, !dbg !401
}

define i64 @document_set(i64 %p0, i64 %p1, i64 %p2) nounwind !dbg !402 {
entry:
  %slot.docs = alloca i64, align 8, !dbg !403
  store i64 %p0, ptr %slot.docs, align 8, !dbg !403
  %slot.uri = alloca i64, align 8, !dbg !403
  store i64 %p1, ptr %slot.uri, align 8, !dbg !403
  %slot.text = alloca i64, align 8, !dbg !403
  store i64 %p2, ptr %slot.text, align 8, !dbg !403
  %r0 = load i64, ptr %slot.text, align 8, !dbg !404
  %r1 = load i64, ptr %slot.docs, align 8, !dbg !404
  %r2 = load i64, ptr %slot.uri, align 8, !dbg !404
  %_is.dv0 = call i64 @nova_rt_dict_set(i64 %r1, i64 %r2, i64 %r0), !dbg !404
  ret i64 0, !dbg !404
}

define i64 @document_get(i64 %p0, i64 %p1) nounwind !dbg !405 {
entry:
  %slot.docs = alloca i64, align 8, !dbg !406
  store i64 %p0, ptr %slot.docs, align 8, !dbg !406
  %slot.uri = alloca i64, align 8, !dbg !406
  store i64 %p1, ptr %slot.uri, align 8, !dbg !406
  %r0 = load i64, ptr %slot.docs, align 8, !dbg !407
  %r1 = load i64, ptr %slot.uri, align 8, !dbg !407
  %r2 = call i64 @nova_rt_dict_has(i64 %r0, i64 %r1), !dbg !407
  %br_then155 = icmp ne i64 %r2, 0, !dbg !407
  br i1 %br_then155, label %then155, label %else156, !dbg !407
then155:
  %r3 = load i64, ptr %slot.docs, align 8, !dbg !408
  %r4 = load i64, ptr %slot.uri, align 8, !dbg !408
  %r5 = call i64 @nova_rt_dict_get(i64 %r3, i64 %r4), !dbg !408
  ret i64 %r5, !dbg !408
else156:
  br label %endif157, !dbg !408
endif157:
  %r6.p = getelementptr inbounds [1 x i8], ptr @.str.7, i64 0, i64 0, !dbg !409
  %r6 = ptrtoint ptr %r6.p to i64, !dbg !409
  ret i64 %r6, !dbg !409
}

define i64 @word_at_position(i64 %p0, i64 %p1, i64 %p2) nounwind !dbg !410 {
entry:
  %slot.text = alloca i64, align 8, !dbg !411
  store i64 %p0, ptr %slot.text, align 8, !dbg !411
  %slot.line_no = alloca i64, align 8, !dbg !411
  store i64 %p1, ptr %slot.line_no, align 8, !dbg !411
  %slot.ch = alloca i64, align 8, !dbg !411
  store i64 %p2, ptr %slot.ch, align 8, !dbg !411
  %slot.lines = alloca i64, align 8, !dbg !411
  store i64 0, ptr %slot.lines, align 8, !dbg !411
  %slot.__sc_158 = alloca i64, align 8, !dbg !411
  store i64 0, ptr %slot.__sc_158, align 8, !dbg !411
  %slot.line = alloca i64, align 8, !dbg !411
  store i64 0, ptr %slot.line, align 8, !dbg !411
  %slot.__sc_164 = alloca i64, align 8, !dbg !411
  store i64 0, ptr %slot.__sc_164, align 8, !dbg !411
  %slot.start = alloca i64, align 8, !dbg !411
  store i64 0, ptr %slot.start, align 8, !dbg !411
  %slot.c = alloca i64, align 8, !dbg !411
  store i64 0, ptr %slot.c, align 8, !dbg !411
  %slot.co = alloca i64, align 8, !dbg !411
  store i64 0, ptr %slot.co, align 8, !dbg !411
  %slot.is_id = alloca i64, align 8, !dbg !411
  store i64 0, ptr %slot.is_id, align 8, !dbg !411
  %slot.__sc_173 = alloca i64, align 8, !dbg !411
  store i64 0, ptr %slot.__sc_173, align 8, !dbg !411
  %slot.__sc_179 = alloca i64, align 8, !dbg !411
  store i64 0, ptr %slot.__sc_179, align 8, !dbg !411
  %slot.__sc_185 = alloca i64, align 8, !dbg !411
  store i64 0, ptr %slot.__sc_185, align 8, !dbg !411
  %slot.end_idx = alloca i64, align 8, !dbg !411
  store i64 0, ptr %slot.end_idx, align 8, !dbg !411
  %slot.__sc_200 = alloca i64, align 8, !dbg !411
  store i64 0, ptr %slot.__sc_200, align 8, !dbg !411
  %slot.__sc_206 = alloca i64, align 8, !dbg !411
  store i64 0, ptr %slot.__sc_206, align 8, !dbg !411
  %slot.__sc_212 = alloca i64, align 8, !dbg !411
  store i64 0, ptr %slot.__sc_212, align 8, !dbg !411
  %r0 = load i64, ptr %slot.text, align 8, !dbg !412
  %r1.p = getelementptr inbounds [2 x i8], ptr @.str.0, i64 0, i64 0, !dbg !412
  %r1 = ptrtoint ptr %r1.p to i64, !dbg !412
  %r2 = call i64 @nova_rt_split(i64 %r0, i64 %r1), !dbg !412
  store i64 %r2, ptr %slot.lines, align 8, !dbg !412
  %r3 = load i64, ptr %slot.line_no, align 8, !dbg !413
  %r4 = add i64 0, 0, !dbg !413
  %r5.cmp = icmp slt i64 %r3, %r4, !dbg !413
  %r5 = zext i1 %r5.cmp to i64, !dbg !413
  store i64 %r5, ptr %slot.__sc_158, align 8, !dbg !413
  %br_or_merge160 = icmp ne i64 %r5, 0, !dbg !413
  br i1 %br_or_merge160, label %or_merge160, label %or_rhs159, !dbg !413
or_rhs159:
  %r6 = load i64, ptr %slot.line_no, align 8, !dbg !413
  %r7 = load i64, ptr %slot.lines, align 8, !dbg !413
  %r8.lp = inttoptr i64 %r7 to ptr, !dbg !413
  %r8.szp = getelementptr i64, ptr %r8.lp, i64 1, !dbg !413
  %r8 = load i64, ptr %r8.szp, align 8, !tbaa !6, !dbg !413
  %r9.cmp = icmp sge i64 %r6, %r8, !dbg !413
  %r9 = zext i1 %r9.cmp to i64, !dbg !413
  store i64 %r9, ptr %slot.__sc_158, align 8, !dbg !413
  br label %or_merge160, !dbg !413
or_merge160:
  %r10 = load i64, ptr %slot.__sc_158, align 8, !dbg !413
  %br_then161 = icmp ne i64 %r10, 0, !dbg !413
  br i1 %br_then161, label %then161, label %else162, !dbg !413
then161:
  %r11.p = getelementptr inbounds [1 x i8], ptr @.str.7, i64 0, i64 0, !dbg !414
  %r11 = ptrtoint ptr %r11.p to i64, !dbg !414
  ret i64 %r11, !dbg !414
else162:
  br label %endif163, !dbg !414
endif163:
  %r12 = load i64, ptr %slot.lines, align 8, !dbg !415
  %r13 = load i64, ptr %slot.line_no, align 8, !dbg !415
  %r14 = call i64 @nova_rt_index_get(i64 %r12, i64 %r13), !dbg !415
  store i64 %r14, ptr %slot.line, align 8, !dbg !415
  %r15 = load i64, ptr %slot.ch, align 8, !dbg !416
  %r16 = add i64 0, 0, !dbg !416
  %r17.cmp = icmp slt i64 %r15, %r16, !dbg !416
  %r17 = zext i1 %r17.cmp to i64, !dbg !416
  store i64 %r17, ptr %slot.__sc_164, align 8, !dbg !416
  %br_or_merge166 = icmp ne i64 %r17, 0, !dbg !416
  br i1 %br_or_merge166, label %or_merge166, label %or_rhs165, !dbg !416
or_rhs165:
  %r18 = load i64, ptr %slot.ch, align 8, !dbg !416
  %r19 = load i64, ptr %slot.line, align 8, !dbg !416
  %r20 = call i64 @nova_rt_len_any(i64 %r19), !dbg !416
  %r21.cmp = icmp sgt i64 %r18, %r20, !dbg !416
  %r21 = zext i1 %r21.cmp to i64, !dbg !416
  store i64 %r21, ptr %slot.__sc_164, align 8, !dbg !416
  br label %or_merge166, !dbg !416
or_merge166:
  %r22 = load i64, ptr %slot.__sc_164, align 8, !dbg !416
  %br_then167 = icmp ne i64 %r22, 0, !dbg !416
  br i1 %br_then167, label %then167, label %else168, !dbg !416
then167:
  %r23.p = getelementptr inbounds [1 x i8], ptr @.str.7, i64 0, i64 0, !dbg !417
  %r23 = ptrtoint ptr %r23.p to i64, !dbg !417
  ret i64 %r23, !dbg !417
else168:
  br label %endif169, !dbg !417
endif169:
  %r24 = load i64, ptr %slot.ch, align 8, !dbg !418
  store i64 %r24, ptr %slot.start, align 8, !dbg !418
  br label %while_hdr170, !dbg !419
while_hdr170:
  %r25 = load i64, ptr %slot.start, align 8, !dbg !419
  %r26 = add i64 0, 0, !dbg !419
  %r27.cmp = icmp sgt i64 %r25, %r26, !dbg !419
  %r27 = zext i1 %r27.cmp to i64, !dbg !419
  %br_while_body171 = icmp ne i64 %r27, 0, !dbg !419
  br i1 %br_while_body171, label %while_body171, label %while_exit172, !prof !90, !dbg !419
while_body171:
  %r28 = load i64, ptr %slot.line, align 8, !dbg !420
  %r29 = load i64, ptr %slot.start, align 8, !dbg !420
  %r30 = add i64 1, 0, !dbg !420
  %r31 = sub i64 %r29, %r30, !dbg !420
  %r32 = call i64 @nova_rt_index_get(i64 %r28, i64 %r31), !dbg !420
  store i64 %r32, ptr %slot.c, align 8, !dbg !420
  %r33 = add i64 %r32, 0, !dbg !421
  %r34 = call i64 @nova_rt_ord(i64 %r33), !dbg !421
  store i64 %r34, ptr %slot.co, align 8, !dbg !421
  %r35 = add i64 0, 0, !dbg !422
  store i64 %r35, ptr %slot.is_id, align 8, !dbg !422
  %r36 = add i64 %r34, 0, !dbg !423
  %r37 = add i64 65, 0, !dbg !423
  %r38.cmp = icmp sge i64 %r36, %r37, !dbg !423
  %r38 = zext i1 %r38.cmp to i64, !dbg !423
  store i64 %r38, ptr %slot.__sc_173, align 8, !dbg !423
  %br_and_rhs174 = icmp ne i64 %r38, 0, !dbg !423
  br i1 %br_and_rhs174, label %and_rhs174, label %and_merge175, !dbg !423
and_rhs174:
  %r39 = load i64, ptr %slot.co, align 8, !dbg !423
  %r40 = add i64 90, 0, !dbg !423
  %r41.cmp = icmp sle i64 %r39, %r40, !dbg !423
  %r41 = zext i1 %r41.cmp to i64, !dbg !423
  store i64 %r41, ptr %slot.__sc_173, align 8, !dbg !423
  br label %and_merge175, !dbg !423
and_merge175:
  %r42 = load i64, ptr %slot.__sc_173, align 8, !dbg !423
  %br_then176 = icmp ne i64 %r42, 0, !dbg !423
  br i1 %br_then176, label %then176, label %else177, !dbg !423
then176:
  %r43 = add i64 1, 0, !dbg !424
  store i64 %r43, ptr %slot.is_id, align 8, !dbg !424
  br label %endif178, !dbg !424
else177:
  br label %endif178, !dbg !424
endif178:
  %r44 = load i64, ptr %slot.co, align 8, !dbg !425
  %r45 = add i64 97, 0, !dbg !425
  %r46.cmp = icmp sge i64 %r44, %r45, !dbg !425
  %r46 = zext i1 %r46.cmp to i64, !dbg !425
  store i64 %r46, ptr %slot.__sc_179, align 8, !dbg !425
  %br_and_rhs180 = icmp ne i64 %r46, 0, !dbg !425
  br i1 %br_and_rhs180, label %and_rhs180, label %and_merge181, !dbg !425
and_rhs180:
  %r47 = load i64, ptr %slot.co, align 8, !dbg !425
  %r48 = add i64 122, 0, !dbg !425
  %r49.cmp = icmp sle i64 %r47, %r48, !dbg !425
  %r49 = zext i1 %r49.cmp to i64, !dbg !425
  store i64 %r49, ptr %slot.__sc_179, align 8, !dbg !425
  br label %and_merge181, !dbg !425
and_merge181:
  %r50 = load i64, ptr %slot.__sc_179, align 8, !dbg !425
  %br_then182 = icmp ne i64 %r50, 0, !dbg !425
  br i1 %br_then182, label %then182, label %else183, !dbg !425
then182:
  %r51 = add i64 1, 0, !dbg !426
  store i64 %r51, ptr %slot.is_id, align 8, !dbg !426
  br label %endif184, !dbg !426
else183:
  br label %endif184, !dbg !426
endif184:
  %r52 = load i64, ptr %slot.co, align 8, !dbg !427
  %r53 = add i64 48, 0, !dbg !427
  %r54.cmp = icmp sge i64 %r52, %r53, !dbg !427
  %r54 = zext i1 %r54.cmp to i64, !dbg !427
  store i64 %r54, ptr %slot.__sc_185, align 8, !dbg !427
  %br_and_rhs186 = icmp ne i64 %r54, 0, !dbg !427
  br i1 %br_and_rhs186, label %and_rhs186, label %and_merge187, !dbg !427
and_rhs186:
  %r55 = load i64, ptr %slot.co, align 8, !dbg !427
  %r56 = add i64 57, 0, !dbg !427
  %r57.cmp = icmp sle i64 %r55, %r56, !dbg !427
  %r57 = zext i1 %r57.cmp to i64, !dbg !427
  store i64 %r57, ptr %slot.__sc_185, align 8, !dbg !427
  br label %and_merge187, !dbg !427
and_merge187:
  %r58 = load i64, ptr %slot.__sc_185, align 8, !dbg !427
  %br_then188 = icmp ne i64 %r58, 0, !dbg !427
  br i1 %br_then188, label %then188, label %else189, !dbg !427
then188:
  %r59 = add i64 1, 0, !dbg !428
  store i64 %r59, ptr %slot.is_id, align 8, !dbg !428
  br label %endif190, !dbg !428
else189:
  br label %endif190, !dbg !428
endif190:
  %r60 = load i64, ptr %slot.c, align 8, !dbg !429
  %r61.p = getelementptr inbounds [2 x i8], ptr @.str.48, i64 0, i64 0, !dbg !429
  %r61 = ptrtoint ptr %r61.p to i64, !dbg !429
  %r62.p0 = inttoptr i64 %r60 to ptr, !dbg !429
  %r62.p1 = inttoptr i64 %r61 to ptr, !dbg !429
  %r62.sc = call i32 @strcmp(ptr %r62.p0, ptr %r62.p1), !dbg !429
  %r62.cmp = icmp eq i32 %r62.sc, 0, !dbg !429
  %r62 = zext i1 %r62.cmp to i64, !dbg !429
  %br_then191 = icmp ne i64 %r62, 0, !dbg !429
  br i1 %br_then191, label %then191, label %else192, !dbg !429
then191:
  %r63 = add i64 1, 0, !dbg !430
  store i64 %r63, ptr %slot.is_id, align 8, !dbg !430
  br label %endif193, !dbg !430
else192:
  br label %endif193, !dbg !430
endif193:
  %r64 = load i64, ptr %slot.is_id, align 8, !dbg !431
  %r65 = add i64 0, 0, !dbg !431
  %r66.cmp = icmp eq i64 %r64, %r65, !dbg !431
  %r66 = zext i1 %r66.cmp to i64, !dbg !431
  %br_then194 = icmp ne i64 %r66, 0, !dbg !431
  br i1 %br_then194, label %then194, label %else195, !dbg !431
then194:
  %r67 = load i64, ptr %slot.start, align 8, !dbg !432
  store i64 %r67, ptr %slot.start, align 8, !dbg !432
  br label %while_exit172, !dbg !433
else195:
  br label %endif196, !dbg !433
endif196:
  %r68 = load i64, ptr %slot.start, align 8, !dbg !434
  %r69 = add i64 1, 0, !dbg !434
  %r70 = sub i64 %r68, %r69, !dbg !434
  store i64 %r70, ptr %slot.start, align 8, !dbg !434
  br label %while_hdr170, !dbg !434
while_exit172:
  %r71 = load i64, ptr %slot.ch, align 8, !dbg !435
  store i64 %r71, ptr %slot.end_idx, align 8, !dbg !435
  br label %while_hdr197, !dbg !436
while_hdr197:
  %r72 = load i64, ptr %slot.end_idx, align 8, !dbg !436
  %r73 = load i64, ptr %slot.line, align 8, !dbg !436
  %r74 = call i64 @nova_rt_len_any(i64 %r73), !dbg !436
  %r75.cmp = icmp slt i64 %r72, %r74, !dbg !436
  %r75 = zext i1 %r75.cmp to i64, !dbg !436
  %br_while_body198 = icmp ne i64 %r75, 0, !dbg !436
  br i1 %br_while_body198, label %while_body198, label %while_exit199, !prof !90, !dbg !436
while_body198:
  %r76 = load i64, ptr %slot.line, align 8, !dbg !437
  %r77 = load i64, ptr %slot.end_idx, align 8, !dbg !437
  %r78 = call i64 @nova_rt_index_get(i64 %r76, i64 %r77), !dbg !437
  store i64 %r78, ptr %slot.c, align 8, !dbg !437
  %r79 = add i64 %r78, 0, !dbg !438
  %r80 = call i64 @nova_rt_ord(i64 %r79), !dbg !438
  store i64 %r80, ptr %slot.co, align 8, !dbg !438
  %r81 = add i64 0, 0, !dbg !439
  store i64 %r81, ptr %slot.is_id, align 8, !dbg !439
  %r82 = add i64 %r80, 0, !dbg !440
  %r83 = add i64 65, 0, !dbg !440
  %r84.cmp = icmp sge i64 %r82, %r83, !dbg !440
  %r84 = zext i1 %r84.cmp to i64, !dbg !440
  store i64 %r84, ptr %slot.__sc_200, align 8, !dbg !440
  %br_and_rhs201 = icmp ne i64 %r84, 0, !dbg !440
  br i1 %br_and_rhs201, label %and_rhs201, label %and_merge202, !dbg !440
and_rhs201:
  %r85 = load i64, ptr %slot.co, align 8, !dbg !440
  %r86 = add i64 90, 0, !dbg !440
  %r87.cmp = icmp sle i64 %r85, %r86, !dbg !440
  %r87 = zext i1 %r87.cmp to i64, !dbg !440
  store i64 %r87, ptr %slot.__sc_200, align 8, !dbg !440
  br label %and_merge202, !dbg !440
and_merge202:
  %r88 = load i64, ptr %slot.__sc_200, align 8, !dbg !440
  %br_then203 = icmp ne i64 %r88, 0, !dbg !440
  br i1 %br_then203, label %then203, label %else204, !dbg !440
then203:
  %r89 = add i64 1, 0, !dbg !441
  store i64 %r89, ptr %slot.is_id, align 8, !dbg !441
  br label %endif205, !dbg !441
else204:
  br label %endif205, !dbg !441
endif205:
  %r90 = load i64, ptr %slot.co, align 8, !dbg !442
  %r91 = add i64 97, 0, !dbg !442
  %r92.cmp = icmp sge i64 %r90, %r91, !dbg !442
  %r92 = zext i1 %r92.cmp to i64, !dbg !442
  store i64 %r92, ptr %slot.__sc_206, align 8, !dbg !442
  %br_and_rhs207 = icmp ne i64 %r92, 0, !dbg !442
  br i1 %br_and_rhs207, label %and_rhs207, label %and_merge208, !dbg !442
and_rhs207:
  %r93 = load i64, ptr %slot.co, align 8, !dbg !442
  %r94 = add i64 122, 0, !dbg !442
  %r95.cmp = icmp sle i64 %r93, %r94, !dbg !442
  %r95 = zext i1 %r95.cmp to i64, !dbg !442
  store i64 %r95, ptr %slot.__sc_206, align 8, !dbg !442
  br label %and_merge208, !dbg !442
and_merge208:
  %r96 = load i64, ptr %slot.__sc_206, align 8, !dbg !442
  %br_then209 = icmp ne i64 %r96, 0, !dbg !442
  br i1 %br_then209, label %then209, label %else210, !dbg !442
then209:
  %r97 = add i64 1, 0, !dbg !443
  store i64 %r97, ptr %slot.is_id, align 8, !dbg !443
  br label %endif211, !dbg !443
else210:
  br label %endif211, !dbg !443
endif211:
  %r98 = load i64, ptr %slot.co, align 8, !dbg !444
  %r99 = add i64 48, 0, !dbg !444
  %r100.cmp = icmp sge i64 %r98, %r99, !dbg !444
  %r100 = zext i1 %r100.cmp to i64, !dbg !444
  store i64 %r100, ptr %slot.__sc_212, align 8, !dbg !444
  %br_and_rhs213 = icmp ne i64 %r100, 0, !dbg !444
  br i1 %br_and_rhs213, label %and_rhs213, label %and_merge214, !dbg !444
and_rhs213:
  %r101 = load i64, ptr %slot.co, align 8, !dbg !444
  %r102 = add i64 57, 0, !dbg !444
  %r103.cmp = icmp sle i64 %r101, %r102, !dbg !444
  %r103 = zext i1 %r103.cmp to i64, !dbg !444
  store i64 %r103, ptr %slot.__sc_212, align 8, !dbg !444
  br label %and_merge214, !dbg !444
and_merge214:
  %r104 = load i64, ptr %slot.__sc_212, align 8, !dbg !444
  %br_then215 = icmp ne i64 %r104, 0, !dbg !444
  br i1 %br_then215, label %then215, label %else216, !dbg !444
then215:
  %r105 = add i64 1, 0, !dbg !445
  store i64 %r105, ptr %slot.is_id, align 8, !dbg !445
  br label %endif217, !dbg !445
else216:
  br label %endif217, !dbg !445
endif217:
  %r106 = load i64, ptr %slot.c, align 8, !dbg !446
  %r107.p = getelementptr inbounds [2 x i8], ptr @.str.48, i64 0, i64 0, !dbg !446
  %r107 = ptrtoint ptr %r107.p to i64, !dbg !446
  %r108.p0 = inttoptr i64 %r106 to ptr, !dbg !446
  %r108.p1 = inttoptr i64 %r107 to ptr, !dbg !446
  %r108.sc = call i32 @strcmp(ptr %r108.p0, ptr %r108.p1), !dbg !446
  %r108.cmp = icmp eq i32 %r108.sc, 0, !dbg !446
  %r108 = zext i1 %r108.cmp to i64, !dbg !446
  %br_then218 = icmp ne i64 %r108, 0, !dbg !446
  br i1 %br_then218, label %then218, label %else219, !dbg !446
then218:
  %r109 = add i64 1, 0, !dbg !447
  store i64 %r109, ptr %slot.is_id, align 8, !dbg !447
  br label %endif220, !dbg !447
else219:
  br label %endif220, !dbg !447
endif220:
  %r110 = load i64, ptr %slot.is_id, align 8, !dbg !448
  %r111 = add i64 0, 0, !dbg !448
  %r112.cmp = icmp eq i64 %r110, %r111, !dbg !448
  %r112 = zext i1 %r112.cmp to i64, !dbg !448
  %br_then221 = icmp ne i64 %r112, 0, !dbg !448
  br i1 %br_then221, label %then221, label %else222, !dbg !448
then221:
  %r113 = load i64, ptr %slot.end_idx, align 8, !dbg !449
  store i64 %r113, ptr %slot.end_idx, align 8, !dbg !449
  br label %while_exit199, !dbg !450
else222:
  br label %endif223, !dbg !450
endif223:
  %r114 = load i64, ptr %slot.end_idx, align 8, !dbg !451
  %r115 = add i64 1, 0, !dbg !451
  %r116 = add i64 %r114, %r115, !dbg !451
  store i64 %r116, ptr %slot.end_idx, align 8, !dbg !451
  br label %while_hdr197, !dbg !451
while_exit199:
  %r117 = load i64, ptr %slot.start, align 8, !dbg !452
  %r118 = load i64, ptr %slot.end_idx, align 8, !dbg !452
  %r119.cmp = icmp sge i64 %r117, %r118, !dbg !452
  %r119 = zext i1 %r119.cmp to i64, !dbg !452
  %br_then224 = icmp ne i64 %r119, 0, !dbg !452
  br i1 %br_then224, label %then224, label %else225, !dbg !452
then224:
  %r120.p = getelementptr inbounds [1 x i8], ptr @.str.7, i64 0, i64 0, !dbg !453
  %r120 = ptrtoint ptr %r120.p to i64, !dbg !453
  ret i64 %r120, !dbg !453
else225:
  br label %endif226, !dbg !453
endif226:
  %r121 = load i64, ptr %slot.line, align 8, !dbg !454
  %r122 = load i64, ptr %slot.start, align 8, !dbg !454
  %r123 = load i64, ptr %slot.end_idx, align 8, !dbg !454
  %r124 = call i64 @nova_rt_slice(i64 %r121, i64 %r122, i64 %r123), !dbg !454
  ret i64 %r124, !dbg !454
}

define i64 @builtin_doc(i64 %p0) nounwind !dbg !455 {
entry:
  %slot.name = alloca i64, align 8, !dbg !456
  store i64 %p0, ptr %slot.name, align 8, !dbg !456
  %r0 = load i64, ptr %slot.name, align 8, !dbg !457
  %r1.p = getelementptr inbounds [6 x i8], ptr @.str.49, i64 0, i64 0, !dbg !457
  %r1 = ptrtoint ptr %r1.p to i64, !dbg !457
  %r2.p0 = inttoptr i64 %r0 to ptr, !dbg !457
  %r2.p1 = inttoptr i64 %r1 to ptr, !dbg !457
  %r2.sc = call i32 @strcmp(ptr %r2.p0, ptr %r2.p1), !dbg !457
  %r2.cmp = icmp eq i32 %r2.sc, 0, !dbg !457
  %r2 = zext i1 %r2.cmp to i64, !dbg !457
  %br_then227 = icmp ne i64 %r2, 0, !dbg !457
  br i1 %br_then227, label %then227, label %else228, !dbg !457
then227:
  %r3.p = getelementptr inbounds [66 x i8], ptr @.str.50, i64 0, i64 0, !dbg !458
  %r3 = ptrtoint ptr %r3.p to i64, !dbg !458
  ret i64 %r3, !dbg !458
else228:
  br label %endif229, !dbg !458
endif229:
  %r4 = load i64, ptr %slot.name, align 8, !dbg !459
  %r5.p = getelementptr inbounds [4 x i8], ptr @.str.51, i64 0, i64 0, !dbg !459
  %r5 = ptrtoint ptr %r5.p to i64, !dbg !459
  %r6.p0 = inttoptr i64 %r4 to ptr, !dbg !459
  %r6.p1 = inttoptr i64 %r5 to ptr, !dbg !459
  %r6.sc = call i32 @strcmp(ptr %r6.p0, ptr %r6.p1), !dbg !459
  %r6.cmp = icmp eq i32 %r6.sc, 0, !dbg !459
  %r6 = zext i1 %r6.cmp to i64, !dbg !459
  %br_then230 = icmp ne i64 %r6, 0, !dbg !459
  br i1 %br_then230, label %then230, label %else231, !dbg !459
then230:
  %r7.p = getelementptr inbounds [56 x i8], ptr @.str.52, i64 0, i64 0, !dbg !460
  %r7 = ptrtoint ptr %r7.p to i64, !dbg !460
  ret i64 %r7, !dbg !460
else231:
  br label %endif232, !dbg !460
endif232:
  %r8 = load i64, ptr %slot.name, align 8, !dbg !461
  %r9.p = getelementptr inbounds [4 x i8], ptr @.str.53, i64 0, i64 0, !dbg !461
  %r9 = ptrtoint ptr %r9.p to i64, !dbg !461
  %r10.p0 = inttoptr i64 %r8 to ptr, !dbg !461
  %r10.p1 = inttoptr i64 %r9 to ptr, !dbg !461
  %r10.sc = call i32 @strcmp(ptr %r10.p0, ptr %r10.p1), !dbg !461
  %r10.cmp = icmp eq i32 %r10.sc, 0, !dbg !461
  %r10 = zext i1 %r10.cmp to i64, !dbg !461
  %br_then233 = icmp ne i64 %r10, 0, !dbg !461
  br i1 %br_then233, label %then233, label %else234, !dbg !461
then233:
  %r11.p = getelementptr inbounds [48 x i8], ptr @.str.54, i64 0, i64 0, !dbg !462
  %r11 = ptrtoint ptr %r11.p to i64, !dbg !462
  ret i64 %r11, !dbg !462
else234:
  br label %endif235, !dbg !462
endif235:
  %r12 = load i64, ptr %slot.name, align 8, !dbg !463
  %r13.p = getelementptr inbounds [4 x i8], ptr @.str.55, i64 0, i64 0, !dbg !463
  %r13 = ptrtoint ptr %r13.p to i64, !dbg !463
  %r14.p0 = inttoptr i64 %r12 to ptr, !dbg !463
  %r14.p1 = inttoptr i64 %r13 to ptr, !dbg !463
  %r14.sc = call i32 @strcmp(ptr %r14.p0, ptr %r14.p1), !dbg !463
  %r14.cmp = icmp eq i32 %r14.sc, 0, !dbg !463
  %r14 = zext i1 %r14.cmp to i64, !dbg !463
  %br_then236 = icmp ne i64 %r14, 0, !dbg !463
  br i1 %br_then236, label %then236, label %else237, !dbg !463
then236:
  %r15.p = getelementptr inbounds [42 x i8], ptr @.str.56, i64 0, i64 0, !dbg !464
  %r15 = ptrtoint ptr %r15.p to i64, !dbg !464
  ret i64 %r15, !dbg !464
else237:
  br label %endif238, !dbg !464
endif238:
  %r16 = load i64, ptr %slot.name, align 8, !dbg !465
  %r17.p = getelementptr inbounds [6 x i8], ptr @.str.57, i64 0, i64 0, !dbg !465
  %r17 = ptrtoint ptr %r17.p to i64, !dbg !465
  %r18.p0 = inttoptr i64 %r16 to ptr, !dbg !465
  %r18.p1 = inttoptr i64 %r17 to ptr, !dbg !465
  %r18.sc = call i32 @strcmp(ptr %r18.p0, ptr %r18.p1), !dbg !465
  %r18.cmp = icmp eq i32 %r18.sc, 0, !dbg !465
  %r18 = zext i1 %r18.cmp to i64, !dbg !465
  %br_then239 = icmp ne i64 %r18, 0, !dbg !465
  br i1 %br_then239, label %then239, label %else240, !dbg !465
then239:
  %r19.p = getelementptr inbounds [48 x i8], ptr @.str.58, i64 0, i64 0, !dbg !466
  %r19 = ptrtoint ptr %r19.p to i64, !dbg !466
  ret i64 %r19, !dbg !466
else240:
  br label %endif241, !dbg !466
endif241:
  %r20 = load i64, ptr %slot.name, align 8, !dbg !467
  %r21.p = getelementptr inbounds [5 x i8], ptr @.str.59, i64 0, i64 0, !dbg !467
  %r21 = ptrtoint ptr %r21.p to i64, !dbg !467
  %r22.p0 = inttoptr i64 %r20 to ptr, !dbg !467
  %r22.p1 = inttoptr i64 %r21 to ptr, !dbg !467
  %r22.sc = call i32 @strcmp(ptr %r22.p0, ptr %r22.p1), !dbg !467
  %r22.cmp = icmp eq i32 %r22.sc, 0, !dbg !467
  %r22 = zext i1 %r22.cmp to i64, !dbg !467
  %br_then242 = icmp ne i64 %r22, 0, !dbg !467
  br i1 %br_then242, label %then242, label %else243, !dbg !467
then242:
  %r23.p = getelementptr inbounds [57 x i8], ptr @.str.60, i64 0, i64 0, !dbg !468
  %r23 = ptrtoint ptr %r23.p to i64, !dbg !468
  ret i64 %r23, !dbg !468
else243:
  br label %endif244, !dbg !468
endif244:
  %r24 = load i64, ptr %slot.name, align 8, !dbg !469
  %r25.p = getelementptr inbounds [4 x i8], ptr @.str.61, i64 0, i64 0, !dbg !469
  %r25 = ptrtoint ptr %r25.p to i64, !dbg !469
  %r26.p0 = inttoptr i64 %r24 to ptr, !dbg !469
  %r26.p1 = inttoptr i64 %r25 to ptr, !dbg !469
  %r26.sc = call i32 @strcmp(ptr %r26.p0, ptr %r26.p1), !dbg !469
  %r26.cmp = icmp eq i32 %r26.sc, 0, !dbg !469
  %r26 = zext i1 %r26.cmp to i64, !dbg !469
  %br_then245 = icmp ne i64 %r26, 0, !dbg !469
  br i1 %br_then245, label %then245, label %else246, !dbg !469
then245:
  %r27.p = getelementptr inbounds [42 x i8], ptr @.str.62, i64 0, i64 0, !dbg !470
  %r27 = ptrtoint ptr %r27.p to i64, !dbg !470
  ret i64 %r27, !dbg !470
else246:
  br label %endif247, !dbg !470
endif247:
  %r28 = load i64, ptr %slot.name, align 8, !dbg !471
  %r29.p = getelementptr inbounds [7 x i8], ptr @.str.63, i64 0, i64 0, !dbg !471
  %r29 = ptrtoint ptr %r29.p to i64, !dbg !471
  %r30.p0 = inttoptr i64 %r28 to ptr, !dbg !471
  %r30.p1 = inttoptr i64 %r29 to ptr, !dbg !471
  %r30.sc = call i32 @strcmp(ptr %r30.p0, ptr %r30.p1), !dbg !471
  %r30.cmp = icmp eq i32 %r30.sc, 0, !dbg !471
  %r30 = zext i1 %r30.cmp to i64, !dbg !471
  %br_then248 = icmp ne i64 %r30, 0, !dbg !471
  br i1 %br_then248, label %then248, label %else249, !dbg !471
then248:
  %r31.p = getelementptr inbounds [48 x i8], ptr @.str.64, i64 0, i64 0, !dbg !472
  %r31 = ptrtoint ptr %r31.p to i64, !dbg !472
  ret i64 %r31, !dbg !472
else249:
  br label %endif250, !dbg !472
endif250:
  %r32 = load i64, ptr %slot.name, align 8, !dbg !473
  %r33.p = getelementptr inbounds [7 x i8], ptr @.str.65, i64 0, i64 0, !dbg !473
  %r33 = ptrtoint ptr %r33.p to i64, !dbg !473
  %r34.p0 = inttoptr i64 %r32 to ptr, !dbg !473
  %r34.p1 = inttoptr i64 %r33 to ptr, !dbg !473
  %r34.sc = call i32 @strcmp(ptr %r34.p0, ptr %r34.p1), !dbg !473
  %r34.cmp = icmp eq i32 %r34.sc, 0, !dbg !473
  %r34 = zext i1 %r34.cmp to i64, !dbg !473
  %br_then251 = icmp ne i64 %r34, 0, !dbg !473
  br i1 %br_then251, label %then251, label %else252, !dbg !473
then251:
  %r35.p = getelementptr inbounds [53 x i8], ptr @.str.66, i64 0, i64 0, !dbg !474
  %r35 = ptrtoint ptr %r35.p to i64, !dbg !474
  ret i64 %r35, !dbg !474
else252:
  br label %endif253, !dbg !474
endif253:
  %r36 = load i64, ptr %slot.name, align 8, !dbg !475
  %r37.p = getelementptr inbounds [4 x i8], ptr @.str.67, i64 0, i64 0, !dbg !475
  %r37 = ptrtoint ptr %r37.p to i64, !dbg !475
  %r38.p0 = inttoptr i64 %r36 to ptr, !dbg !475
  %r38.p1 = inttoptr i64 %r37 to ptr, !dbg !475
  %r38.sc = call i32 @strcmp(ptr %r38.p0, ptr %r38.p1), !dbg !475
  %r38.cmp = icmp eq i32 %r38.sc, 0, !dbg !475
  %r38 = zext i1 %r38.cmp to i64, !dbg !475
  %br_then254 = icmp ne i64 %r38, 0, !dbg !475
  br i1 %br_then254, label %then254, label %else255, !dbg !475
then254:
  %r39.p = getelementptr inbounds [29 x i8], ptr @.str.68, i64 0, i64 0, !dbg !476
  %r39 = ptrtoint ptr %r39.p to i64, !dbg !476
  ret i64 %r39, !dbg !476
else255:
  br label %endif256, !dbg !476
endif256:
  %r40 = load i64, ptr %slot.name, align 8, !dbg !477
  %r41.p = getelementptr inbounds [5 x i8], ptr @.str.69, i64 0, i64 0, !dbg !477
  %r41 = ptrtoint ptr %r41.p to i64, !dbg !477
  %r42.p0 = inttoptr i64 %r40 to ptr, !dbg !477
  %r42.p1 = inttoptr i64 %r41 to ptr, !dbg !477
  %r42.sc = call i32 @strcmp(ptr %r42.p0, ptr %r42.p1), !dbg !477
  %r42.cmp = icmp eq i32 %r42.sc, 0, !dbg !477
  %r42 = zext i1 %r42.cmp to i64, !dbg !477
  %br_then257 = icmp ne i64 %r42, 0, !dbg !477
  br i1 %br_then257, label %then257, label %else258, !dbg !477
then257:
  %r43.p = getelementptr inbounds [61 x i8], ptr @.str.70, i64 0, i64 0, !dbg !478
  %r43 = ptrtoint ptr %r43.p to i64, !dbg !478
  ret i64 %r43, !dbg !478
else258:
  br label %endif259, !dbg !478
endif259:
  %r44 = load i64, ptr %slot.name, align 8, !dbg !479
  %r45.p = getelementptr inbounds [5 x i8], ptr @.str.71, i64 0, i64 0, !dbg !479
  %r45 = ptrtoint ptr %r45.p to i64, !dbg !479
  %r46.p0 = inttoptr i64 %r44 to ptr, !dbg !479
  %r46.p1 = inttoptr i64 %r45 to ptr, !dbg !479
  %r46.sc = call i32 @strcmp(ptr %r46.p0, ptr %r46.p1), !dbg !479
  %r46.cmp = icmp eq i32 %r46.sc, 0, !dbg !479
  %r46 = zext i1 %r46.cmp to i64, !dbg !479
  %br_then260 = icmp ne i64 %r46, 0, !dbg !479
  br i1 %br_then260, label %then260, label %else261, !dbg !479
then260:
  %r47.p = getelementptr inbounds [70 x i8], ptr @.str.72, i64 0, i64 0, !dbg !480
  %r47 = ptrtoint ptr %r47.p to i64, !dbg !480
  ret i64 %r47, !dbg !480
else261:
  br label %endif262, !dbg !480
endif262:
  %r48 = load i64, ptr %slot.name, align 8, !dbg !481
  %r49.p = getelementptr inbounds [6 x i8], ptr @.str.73, i64 0, i64 0, !dbg !481
  %r49 = ptrtoint ptr %r49.p to i64, !dbg !481
  %r50.p0 = inttoptr i64 %r48 to ptr, !dbg !481
  %r50.p1 = inttoptr i64 %r49 to ptr, !dbg !481
  %r50.sc = call i32 @strcmp(ptr %r50.p0, ptr %r50.p1), !dbg !481
  %r50.cmp = icmp eq i32 %r50.sc, 0, !dbg !481
  %r50 = zext i1 %r50.cmp to i64, !dbg !481
  %br_then263 = icmp ne i64 %r50, 0, !dbg !481
  br i1 %br_then263, label %then263, label %else264, !dbg !481
then263:
  %r51.p = getelementptr inbounds [49 x i8], ptr @.str.74, i64 0, i64 0, !dbg !482
  %r51 = ptrtoint ptr %r51.p to i64, !dbg !482
  ret i64 %r51, !dbg !482
else264:
  br label %endif265, !dbg !482
endif265:
  %r52 = load i64, ptr %slot.name, align 8, !dbg !483
  %r53.p = getelementptr inbounds [8 x i8], ptr @.str.75, i64 0, i64 0, !dbg !483
  %r53 = ptrtoint ptr %r53.p to i64, !dbg !483
  %r54.p0 = inttoptr i64 %r52 to ptr, !dbg !483
  %r54.p1 = inttoptr i64 %r53 to ptr, !dbg !483
  %r54.sc = call i32 @strcmp(ptr %r54.p0, ptr %r54.p1), !dbg !483
  %r54.cmp = icmp eq i32 %r54.sc, 0, !dbg !483
  %r54 = zext i1 %r54.cmp to i64, !dbg !483
  %br_then266 = icmp ne i64 %r54, 0, !dbg !483
  br i1 %br_then266, label %then266, label %else267, !dbg !483
then266:
  %r55.p = getelementptr inbounds [27 x i8], ptr @.str.76, i64 0, i64 0, !dbg !484
  %r55 = ptrtoint ptr %r55.p to i64, !dbg !484
  ret i64 %r55, !dbg !484
else267:
  br label %endif268, !dbg !484
endif268:
  %r56 = load i64, ptr %slot.name, align 8, !dbg !485
  %r57.p = getelementptr inbounds [5 x i8], ptr @.str.77, i64 0, i64 0, !dbg !485
  %r57 = ptrtoint ptr %r57.p to i64, !dbg !485
  %r58.p0 = inttoptr i64 %r56 to ptr, !dbg !485
  %r58.p1 = inttoptr i64 %r57 to ptr, !dbg !485
  %r58.sc = call i32 @strcmp(ptr %r58.p0, ptr %r58.p1), !dbg !485
  %r58.cmp = icmp eq i32 %r58.sc, 0, !dbg !485
  %r58 = zext i1 %r58.cmp to i64, !dbg !485
  %br_then269 = icmp ne i64 %r58, 0, !dbg !485
  br i1 %br_then269, label %then269, label %else270, !dbg !485
then269:
  %r59.p = getelementptr inbounds [38 x i8], ptr @.str.78, i64 0, i64 0, !dbg !486
  %r59 = ptrtoint ptr %r59.p to i64, !dbg !486
  ret i64 %r59, !dbg !486
else270:
  br label %endif271, !dbg !486
endif271:
  %r60 = load i64, ptr %slot.name, align 8, !dbg !487
  %r61.p = getelementptr inbounds [5 x i8], ptr @.str.79, i64 0, i64 0, !dbg !487
  %r61 = ptrtoint ptr %r61.p to i64, !dbg !487
  %r62.p0 = inttoptr i64 %r60 to ptr, !dbg !487
  %r62.p1 = inttoptr i64 %r61 to ptr, !dbg !487
  %r62.sc = call i32 @strcmp(ptr %r62.p0, ptr %r62.p1), !dbg !487
  %r62.cmp = icmp eq i32 %r62.sc, 0, !dbg !487
  %r62 = zext i1 %r62.cmp to i64, !dbg !487
  %br_then272 = icmp ne i64 %r62, 0, !dbg !487
  br i1 %br_then272, label %then272, label %else273, !dbg !487
then272:
  %r63.p = getelementptr inbounds [29 x i8], ptr @.str.80, i64 0, i64 0, !dbg !488
  %r63 = ptrtoint ptr %r63.p to i64, !dbg !488
  ret i64 %r63, !dbg !488
else273:
  br label %endif274, !dbg !488
endif274:
  %r64 = load i64, ptr %slot.name, align 8, !dbg !489
  %r65.p = getelementptr inbounds [13 x i8], ptr @.str.81, i64 0, i64 0, !dbg !489
  %r65 = ptrtoint ptr %r65.p to i64, !dbg !489
  %r66.p0 = inttoptr i64 %r64 to ptr, !dbg !489
  %r66.p1 = inttoptr i64 %r65 to ptr, !dbg !489
  %r66.sc = call i32 @strcmp(ptr %r66.p0, ptr %r66.p1), !dbg !489
  %r66.cmp = icmp eq i32 %r66.sc, 0, !dbg !489
  %r66 = zext i1 %r66.cmp to i64, !dbg !489
  %br_then275 = icmp ne i64 %r66, 0, !dbg !489
  br i1 %br_then275, label %then275, label %else276, !dbg !489
then275:
  %r67.p = getelementptr inbounds [44 x i8], ptr @.str.82, i64 0, i64 0, !dbg !490
  %r67 = ptrtoint ptr %r67.p to i64, !dbg !490
  ret i64 %r67, !dbg !490
else276:
  br label %endif277, !dbg !490
endif277:
  %r68 = load i64, ptr %slot.name, align 8, !dbg !491
  %r69.p = getelementptr inbounds [14 x i8], ptr @.str.83, i64 0, i64 0, !dbg !491
  %r69 = ptrtoint ptr %r69.p to i64, !dbg !491
  %r70.p0 = inttoptr i64 %r68 to ptr, !dbg !491
  %r70.p1 = inttoptr i64 %r69 to ptr, !dbg !491
  %r70.sc = call i32 @strcmp(ptr %r70.p0, ptr %r70.p1), !dbg !491
  %r70.cmp = icmp eq i32 %r70.sc, 0, !dbg !491
  %r70 = zext i1 %r70.cmp to i64, !dbg !491
  %br_then278 = icmp ne i64 %r70, 0, !dbg !491
  br i1 %br_then278, label %then278, label %else279, !dbg !491
then278:
  %r71.p = getelementptr inbounds [49 x i8], ptr @.str.84, i64 0, i64 0, !dbg !492
  %r71 = ptrtoint ptr %r71.p to i64, !dbg !492
  ret i64 %r71, !dbg !492
else279:
  br label %endif280, !dbg !492
endif280:
  %r72 = load i64, ptr %slot.name, align 8, !dbg !493
  %r73.p = getelementptr inbounds [12 x i8], ptr @.str.85, i64 0, i64 0, !dbg !493
  %r73 = ptrtoint ptr %r73.p to i64, !dbg !493
  %r74.p0 = inttoptr i64 %r72 to ptr, !dbg !493
  %r74.p1 = inttoptr i64 %r73 to ptr, !dbg !493
  %r74.sc = call i32 @strcmp(ptr %r74.p0, ptr %r74.p1), !dbg !493
  %r74.cmp = icmp eq i32 %r74.sc, 0, !dbg !493
  %r74 = zext i1 %r74.cmp to i64, !dbg !493
  %br_then281 = icmp ne i64 %r74, 0, !dbg !493
  br i1 %br_then281, label %then281, label %else282, !dbg !493
then281:
  %r75.p = getelementptr inbounds [36 x i8], ptr @.str.86, i64 0, i64 0, !dbg !494
  %r75 = ptrtoint ptr %r75.p to i64, !dbg !494
  ret i64 %r75, !dbg !494
else282:
  br label %endif283, !dbg !494
endif283:
  %r76 = load i64, ptr %slot.name, align 8, !dbg !495
  %r77.p = getelementptr inbounds [7 x i8], ptr @.str.87, i64 0, i64 0, !dbg !495
  %r77 = ptrtoint ptr %r77.p to i64, !dbg !495
  %r78.p0 = inttoptr i64 %r76 to ptr, !dbg !495
  %r78.p1 = inttoptr i64 %r77 to ptr, !dbg !495
  %r78.sc = call i32 @strcmp(ptr %r78.p0, ptr %r78.p1), !dbg !495
  %r78.cmp = icmp eq i32 %r78.sc, 0, !dbg !495
  %r78 = zext i1 %r78.cmp to i64, !dbg !495
  %br_then284 = icmp ne i64 %r78, 0, !dbg !495
  br i1 %br_then284, label %then284, label %else285, !dbg !495
then284:
  %r79.p = getelementptr inbounds [47 x i8], ptr @.str.88, i64 0, i64 0, !dbg !496
  %r79 = ptrtoint ptr %r79.p to i64, !dbg !496
  ret i64 %r79, !dbg !496
else285:
  br label %endif286, !dbg !496
endif286:
  %r80 = load i64, ptr %slot.name, align 8, !dbg !497
  %r81.p = getelementptr inbounds [12 x i8], ptr @.str.89, i64 0, i64 0, !dbg !497
  %r81 = ptrtoint ptr %r81.p to i64, !dbg !497
  %r82.p0 = inttoptr i64 %r80 to ptr, !dbg !497
  %r82.p1 = inttoptr i64 %r81 to ptr, !dbg !497
  %r82.sc = call i32 @strcmp(ptr %r82.p0, ptr %r82.p1), !dbg !497
  %r82.cmp = icmp eq i32 %r82.sc, 0, !dbg !497
  %r82 = zext i1 %r82.cmp to i64, !dbg !497
  %br_then287 = icmp ne i64 %r82, 0, !dbg !497
  br i1 %br_then287, label %then287, label %else288, !dbg !497
then287:
  %r83.p = getelementptr inbounds [33 x i8], ptr @.str.90, i64 0, i64 0, !dbg !498
  %r83 = ptrtoint ptr %r83.p to i64, !dbg !498
  ret i64 %r83, !dbg !498
else288:
  br label %endif289, !dbg !498
endif289:
  %r84 = load i64, ptr %slot.name, align 8, !dbg !499
  %r85.p = getelementptr inbounds [11 x i8], ptr @.str.91, i64 0, i64 0, !dbg !499
  %r85 = ptrtoint ptr %r85.p to i64, !dbg !499
  %r86.p0 = inttoptr i64 %r84 to ptr, !dbg !499
  %r86.p1 = inttoptr i64 %r85 to ptr, !dbg !499
  %r86.sc = call i32 @strcmp(ptr %r86.p0, ptr %r86.p1), !dbg !499
  %r86.cmp = icmp eq i32 %r86.sc, 0, !dbg !499
  %r86 = zext i1 %r86.cmp to i64, !dbg !499
  %br_then290 = icmp ne i64 %r86, 0, !dbg !499
  br i1 %br_then290, label %then290, label %else291, !dbg !499
then290:
  %r87.p = getelementptr inbounds [34 x i8], ptr @.str.92, i64 0, i64 0, !dbg !500
  %r87 = ptrtoint ptr %r87.p to i64, !dbg !500
  ret i64 %r87, !dbg !500
else291:
  br label %endif292, !dbg !500
endif292:
  %r88.p = getelementptr inbounds [1 x i8], ptr @.str.7, i64 0, i64 0, !dbg !501
  %r88 = ptrtoint ptr %r88.p to i64, !dbg !501
  ret i64 %r88, !dbg !501
}

define i64 @user_symbol_doc(i64 %p0, i64 %p1) nounwind !dbg !502 {
entry:
  %slot.source = alloca i64, align 8, !dbg !503
  store i64 %p0, ptr %slot.source, align 8, !dbg !503
  %slot.name = alloca i64, align 8, !dbg !503
  store i64 %p1, ptr %slot.name, align 8, !dbg !503
  %slot.lines = alloca i64, align 8, !dbg !503
  store i64 0, ptr %slot.lines, align 8, !dbg !503
  %slot.i = alloca i64, align 8, !dbg !503
  store i64 0, ptr %slot.i, align 8, !dbg !503
  %slot.line = alloca i64, align 8, !dbg !503
  store i64 0, ptr %slot.line, align 8, !dbg !503
  %slot.__sc_296 = alloca i64, align 8, !dbg !503
  store i64 0, ptr %slot.__sc_296, align 8, !dbg !503
  %slot.__sc_299 = alloca i64, align 8, !dbg !503
  store i64 0, ptr %slot.__sc_299, align 8, !dbg !503
  %slot.__sc_305 = alloca i64, align 8, !dbg !503
  store i64 0, ptr %slot.__sc_305, align 8, !dbg !503
  %slot.__sc_311 = alloca i64, align 8, !dbg !503
  store i64 0, ptr %slot.__sc_311, align 8, !dbg !503
  %r0 = load i64, ptr %slot.source, align 8, !dbg !504
  %r1.p = getelementptr inbounds [2 x i8], ptr @.str.0, i64 0, i64 0, !dbg !504
  %r1 = ptrtoint ptr %r1.p to i64, !dbg !504
  %r2 = call i64 @nova_rt_split(i64 %r0, i64 %r1), !dbg !504
  store i64 %r2, ptr %slot.lines, align 8, !dbg !504
  %r3 = add i64 0, 0, !dbg !505
  store i64 %r3, ptr %slot.i, align 8, !dbg !505
  br label %while_hdr293, !dbg !506
while_hdr293:
  %r4 = load i64, ptr %slot.i, align 8, !dbg !506
  %r5 = load i64, ptr %slot.lines, align 8, !dbg !506
  %r6.lp = inttoptr i64 %r5 to ptr, !dbg !506
  %r6.szp = getelementptr i64, ptr %r6.lp, i64 1, !dbg !506
  %r6 = load i64, ptr %r6.szp, align 8, !tbaa !6, !dbg !506
  %r7.cmp = icmp slt i64 %r4, %r6, !dbg !506
  %r7 = zext i1 %r7.cmp to i64, !dbg !506
  %br_while_body294 = icmp ne i64 %r7, 0, !dbg !506
  br i1 %br_while_body294, label %while_body294, label %while_exit295, !prof !90, !dbg !506
while_body294:
  %r8 = load i64, ptr %slot.lines, align 8, !dbg !507
  %r9 = load i64, ptr %slot.i, align 8, !dbg !507
  %r10 = call i64 @nova_rt_index_get(i64 %r8, i64 %r9), !dbg !507
  %r11 = call i64 @nova_rt_trim(i64 %r10), !dbg !507
  store i64 %r11, ptr %slot.line, align 8, !dbg !507
  %r12 = add i64 %r11, 0, !dbg !508
  %r13.p = getelementptr inbounds [4 x i8], ptr @.str.93, i64 0, i64 0, !dbg !508
  %r13 = ptrtoint ptr %r13.p to i64, !dbg !508
  %r14 = load i64, ptr %slot.name, align 8, !dbg !508
  %r15 = call i64 @nova_rt_str_concat(i64 %r13, i64 %r14), !dbg !508
  %r16.p = getelementptr inbounds [2 x i8], ptr @.str.94, i64 0, i64 0, !dbg !508
  %r16 = ptrtoint ptr %r16.p to i64, !dbg !508
  %r17 = call i64 @nova_rt_str_concat(i64 %r15, i64 %r16), !dbg !508
  %r18 = call i64 @nova_rt_starts_with(i64 %r12, i64 %r17), !dbg !508
  store i64 %r18, ptr %slot.__sc_296, align 8, !dbg !508
  %br_or_merge298 = icmp ne i64 %r18, 0, !dbg !508
  br i1 %br_or_merge298, label %or_merge298, label %or_rhs297, !dbg !508
or_rhs297:
  %r19 = load i64, ptr %slot.line, align 8, !dbg !508
  %r20.p = getelementptr inbounds [4 x i8], ptr @.str.93, i64 0, i64 0, !dbg !508
  %r20 = ptrtoint ptr %r20.p to i64, !dbg !508
  %r21 = load i64, ptr %slot.name, align 8, !dbg !508
  %r22 = call i64 @nova_rt_str_concat(i64 %r20, i64 %r21), !dbg !508
  %r23.p = getelementptr inbounds [2 x i8], ptr @.str.20, i64 0, i64 0, !dbg !508
  %r23 = ptrtoint ptr %r23.p to i64, !dbg !508
  %r24 = call i64 @nova_rt_str_concat(i64 %r22, i64 %r23), !dbg !508
  %r25 = call i64 @nova_rt_starts_with(i64 %r19, i64 %r24), !dbg !508
  store i64 %r25, ptr %slot.__sc_296, align 8, !dbg !508
  br label %or_merge298, !dbg !508
or_merge298:
  %r26 = load i64, ptr %slot.__sc_296, align 8, !dbg !508
  store i64 %r26, ptr %slot.__sc_299, align 8, !dbg !508
  %br_or_merge301 = icmp ne i64 %r26, 0, !dbg !508
  br i1 %br_or_merge301, label %or_merge301, label %or_rhs300, !dbg !508
or_rhs300:
  %r27 = load i64, ptr %slot.line, align 8, !dbg !508
  %r28.p = getelementptr inbounds [4 x i8], ptr @.str.93, i64 0, i64 0, !dbg !508
  %r28 = ptrtoint ptr %r28.p to i64, !dbg !508
  %r29 = load i64, ptr %slot.name, align 8, !dbg !508
  %r30 = call i64 @nova_rt_str_concat(i64 %r28, i64 %r29), !dbg !508
  %r31.p = getelementptr inbounds [2 x i8], ptr @.str.95, i64 0, i64 0, !dbg !508
  %r31 = ptrtoint ptr %r31.p to i64, !dbg !508
  %r32 = call i64 @nova_rt_str_concat(i64 %r30, i64 %r31), !dbg !508
  %r33 = call i64 @nova_rt_contains(i64 %r27, i64 %r32), !dbg !508
  store i64 %r33, ptr %slot.__sc_299, align 8, !dbg !508
  br label %or_merge301, !dbg !508
or_merge301:
  %r34 = load i64, ptr %slot.__sc_299, align 8, !dbg !508
  %br_then302 = icmp ne i64 %r34, 0, !dbg !508
  br i1 %br_then302, label %then302, label %else303, !dbg !508
then302:
  %r35 = load i64, ptr %slot.line, align 8, !dbg !509
  ret i64 %r35, !dbg !509
else303:
  br label %endif304, !dbg !509
endif304:
  %r36 = load i64, ptr %slot.line, align 8, !dbg !510
  %r37.p = getelementptr inbounds [5 x i8], ptr @.str.96, i64 0, i64 0, !dbg !510
  %r37 = ptrtoint ptr %r37.p to i64, !dbg !510
  %r38 = load i64, ptr %slot.name, align 8, !dbg !510
  %r39 = call i64 @nova_rt_str_concat(i64 %r37, i64 %r38), !dbg !510
  %r40.p = getelementptr inbounds [2 x i8], ptr @.str.20, i64 0, i64 0, !dbg !510
  %r40 = ptrtoint ptr %r40.p to i64, !dbg !510
  %r41 = call i64 @nova_rt_str_concat(i64 %r39, i64 %r40), !dbg !510
  %r42 = call i64 @nova_rt_starts_with(i64 %r36, i64 %r41), !dbg !510
  store i64 %r42, ptr %slot.__sc_305, align 8, !dbg !510
  %br_or_merge307 = icmp ne i64 %r42, 0, !dbg !510
  br i1 %br_or_merge307, label %or_merge307, label %or_rhs306, !dbg !510
or_rhs306:
  %r43 = load i64, ptr %slot.line, align 8, !dbg !510
  %r44.p = getelementptr inbounds [5 x i8], ptr @.str.96, i64 0, i64 0, !dbg !510
  %r44 = ptrtoint ptr %r44.p to i64, !dbg !510
  %r45 = load i64, ptr %slot.name, align 8, !dbg !510
  %r46 = call i64 @nova_rt_str_concat(i64 %r44, i64 %r45), !dbg !510
  %r47.p = getelementptr inbounds [2 x i8], ptr @.str.97, i64 0, i64 0, !dbg !510
  %r47 = ptrtoint ptr %r47.p to i64, !dbg !510
  %r48 = call i64 @nova_rt_str_concat(i64 %r46, i64 %r47), !dbg !510
  %r49 = call i64 @nova_rt_starts_with(i64 %r43, i64 %r48), !dbg !510
  store i64 %r49, ptr %slot.__sc_305, align 8, !dbg !510
  br label %or_merge307, !dbg !510
or_merge307:
  %r50 = load i64, ptr %slot.__sc_305, align 8, !dbg !510
  %br_then308 = icmp ne i64 %r50, 0, !dbg !510
  br i1 %br_then308, label %then308, label %else309, !dbg !510
then308:
  %r51 = load i64, ptr %slot.line, align 8, !dbg !511
  ret i64 %r51, !dbg !511
else309:
  br label %endif310, !dbg !511
endif310:
  %r52 = load i64, ptr %slot.line, align 8, !dbg !512
  %r53.p = getelementptr inbounds [6 x i8], ptr @.str.98, i64 0, i64 0, !dbg !512
  %r53 = ptrtoint ptr %r53.p to i64, !dbg !512
  %r54 = load i64, ptr %slot.name, align 8, !dbg !512
  %r55 = call i64 @nova_rt_str_concat(i64 %r53, i64 %r54), !dbg !512
  %r56.p = getelementptr inbounds [2 x i8], ptr @.str.20, i64 0, i64 0, !dbg !512
  %r56 = ptrtoint ptr %r56.p to i64, !dbg !512
  %r57 = call i64 @nova_rt_str_concat(i64 %r55, i64 %r56), !dbg !512
  %r58 = call i64 @nova_rt_starts_with(i64 %r52, i64 %r57), !dbg !512
  store i64 %r58, ptr %slot.__sc_311, align 8, !dbg !512
  %br_or_merge313 = icmp ne i64 %r58, 0, !dbg !512
  br i1 %br_or_merge313, label %or_merge313, label %or_rhs312, !dbg !512
or_rhs312:
  %r59 = load i64, ptr %slot.line, align 8, !dbg !512
  %r60.p = getelementptr inbounds [6 x i8], ptr @.str.98, i64 0, i64 0, !dbg !512
  %r60 = ptrtoint ptr %r60.p to i64, !dbg !512
  %r61 = load i64, ptr %slot.name, align 8, !dbg !512
  %r62 = call i64 @nova_rt_str_concat(i64 %r60, i64 %r61), !dbg !512
  %r63.p = getelementptr inbounds [2 x i8], ptr @.str.95, i64 0, i64 0, !dbg !512
  %r63 = ptrtoint ptr %r63.p to i64, !dbg !512
  %r64 = call i64 @nova_rt_str_concat(i64 %r62, i64 %r63), !dbg !512
  %r65 = call i64 @nova_rt_starts_with(i64 %r59, i64 %r64), !dbg !512
  store i64 %r65, ptr %slot.__sc_311, align 8, !dbg !512
  br label %or_merge313, !dbg !512
or_merge313:
  %r66 = load i64, ptr %slot.__sc_311, align 8, !dbg !512
  %br_then314 = icmp ne i64 %r66, 0, !dbg !512
  br i1 %br_then314, label %then314, label %else315, !dbg !512
then314:
  %r67 = load i64, ptr %slot.line, align 8, !dbg !513
  ret i64 %r67, !dbg !513
else315:
  br label %endif316, !dbg !513
endif316:
  %r68 = load i64, ptr %slot.i, align 8, !dbg !514
  %r69 = add i64 1, 0, !dbg !514
  %r70 = add i64 %r68, %r69, !dbg !514
  store i64 %r70, ptr %slot.i, align 8, !dbg !514
  br label %while_hdr293, !dbg !514
while_exit295:
  %r71.p = getelementptr inbounds [1 x i8], ptr @.str.7, i64 0, i64 0, !dbg !515
  %r71 = ptrtoint ptr %r71.p to i64, !dbg !515
  ret i64 %r71, !dbg !515
}

define i64 @build_hover_response(i64 %p0, i64 %p1) nounwind !dbg !516 {
entry:
  %slot.id = alloca i64, align 8, !dbg !517
  store i64 %p0, ptr %slot.id, align 8, !dbg !517
  %slot.doc = alloca i64, align 8, !dbg !517
  store i64 %p1, ptr %slot.doc, align 8, !dbg !517
  %slot.contents = alloca i64, align 8, !dbg !517
  store i64 0, ptr %slot.contents, align 8, !dbg !517
  %r0 = load i64, ptr %slot.doc, align 8, !dbg !518
  %r1 = call i64 @nova_rt_len_any(i64 %r0), !dbg !518
  %r2 = add i64 0, 0, !dbg !518
  %r3.cmp = icmp eq i64 %r1, %r2, !dbg !518
  %r3 = zext i1 %r3.cmp to i64, !dbg !518
  %br_then317 = icmp ne i64 %r3, 0, !dbg !518
  br i1 %br_then317, label %then317, label %else318, !dbg !518
then317:
  %r4 = load i64, ptr %slot.id, align 8, !dbg !519
  %r5.p = getelementptr inbounds [5 x i8], ptr @.str.99, i64 0, i64 0, !dbg !519
  %r5 = ptrtoint ptr %r5.p to i64, !dbg !519
  %r6 = call i64 @build_response(i64 %r4, i64 %r5), !dbg !519
  ret i64 %r6, !dbg !519
else318:
  br label %endif319, !dbg !519
endif319:
  %r7.p = getelementptr inbounds [28 x i8], ptr @.str.100, i64 0, i64 0, !dbg !520
  %r7 = ptrtoint ptr %r7.p to i64, !dbg !520
  %r8.p = getelementptr inbounds [9 x i8], ptr @.str.101, i64 0, i64 0, !dbg !520
  %r8 = ptrtoint ptr %r8.p to i64, !dbg !520
  %r9 = load i64, ptr %slot.doc, align 8, !dbg !520
  %r10 = call i64 @nova_rt_str_concat(i64 %r8, i64 %r9), !dbg !520
  %r11.p = getelementptr inbounds [5 x i8], ptr @.str.102, i64 0, i64 0, !dbg !520
  %r11 = ptrtoint ptr %r11.p to i64, !dbg !520
  %r12 = call i64 @nova_rt_str_concat(i64 %r10, i64 %r11), !dbg !520
  %r13 = call i64 @json_str(i64 %r12), !dbg !520
  %r14 = call i64 @nova_rt_str_concat(i64 %r7, i64 %r13), !dbg !520
  %r15.p = getelementptr inbounds [2 x i8], ptr @.str.17, i64 0, i64 0, !dbg !520
  %r15 = ptrtoint ptr %r15.p to i64, !dbg !520
  %r16 = call i64 @nova_rt_str_concat(i64 %r14, i64 %r15), !dbg !520
  store i64 %r16, ptr %slot.contents, align 8, !dbg !520
  %r17 = load i64, ptr %slot.id, align 8, !dbg !521
  %r18.p = getelementptr inbounds [13 x i8], ptr @.str.103, i64 0, i64 0, !dbg !521
  %r18 = ptrtoint ptr %r18.p to i64, !dbg !521
  %r19 = add i64 %r16, 0, !dbg !521
  %r20 = call i64 @nova_rt_str_concat(i64 %r18, i64 %r19), !dbg !521
  %r21.p = getelementptr inbounds [2 x i8], ptr @.str.17, i64 0, i64 0, !dbg !521
  %r21 = ptrtoint ptr %r21.p to i64, !dbg !521
  %r22 = call i64 @nova_rt_str_concat(i64 %r20, i64 %r21), !dbg !521
  %r23 = call i64 @build_response(i64 %r17, i64 %r22), !dbg !521
  ret i64 %r23, !dbg !521
}

define i64 @find_definition_location(i64 %p0, i64 %p1) nounwind !dbg !522 {
entry:
  %slot.source = alloca i64, align 8, !dbg !523
  store i64 %p0, ptr %slot.source, align 8, !dbg !523
  %slot.name = alloca i64, align 8, !dbg !523
  store i64 %p1, ptr %slot.name, align 8, !dbg !523
  %slot.result = alloca i64, align 8, !dbg !523
  store i64 0, ptr %slot.result, align 8, !dbg !523
  %slot.lines = alloca i64, align 8, !dbg !523
  store i64 0, ptr %slot.lines, align 8, !dbg !523
  %slot.i = alloca i64, align 8, !dbg !523
  store i64 0, ptr %slot.i, align 8, !dbg !523
  %slot.raw = alloca i64, align 8, !dbg !523
  store i64 0, ptr %slot.raw, align 8, !dbg !523
  %slot.line = alloca i64, align 8, !dbg !523
  store i64 0, ptr %slot.line, align 8, !dbg !523
  %slot.prefix = alloca i64, align 8, !dbg !523
  store i64 0, ptr %slot.prefix, align 8, !dbg !523
  %slot.__sc_326 = alloca i64, align 8, !dbg !523
  store i64 0, ptr %slot.__sc_326, align 8, !dbg !523
  %slot.__sc_329 = alloca i64, align 8, !dbg !523
  store i64 0, ptr %slot.__sc_329, align 8, !dbg !523
  %slot.__sc_335 = alloca i64, align 8, !dbg !523
  store i64 0, ptr %slot.__sc_335, align 8, !dbg !523
  %slot.__sc_338 = alloca i64, align 8, !dbg !523
  store i64 0, ptr %slot.__sc_338, align 8, !dbg !523
  %slot.__sc_344 = alloca i64, align 8, !dbg !523
  store i64 0, ptr %slot.__sc_344, align 8, !dbg !523
  %slot.__sc_347 = alloca i64, align 8, !dbg !523
  store i64 0, ptr %slot.__sc_347, align 8, !dbg !523
  %slot.__sc_350 = alloca i64, align 8, !dbg !523
  store i64 0, ptr %slot.__sc_350, align 8, !dbg !523
  %slot.__sc_356 = alloca i64, align 8, !dbg !523
  store i64 0, ptr %slot.__sc_356, align 8, !dbg !523
  %slot.__sc_359 = alloca i64, align 8, !dbg !523
  store i64 0, ptr %slot.__sc_359, align 8, !dbg !523
  %slot.__sc_365 = alloca i64, align 8, !dbg !523
  store i64 0, ptr %slot.__sc_365, align 8, !dbg !523
  %slot.__sc_368 = alloca i64, align 8, !dbg !523
  store i64 0, ptr %slot.__sc_368, align 8, !dbg !523
  %slot.lead = alloca i64, align 8, !dbg !523
  store i64 0, ptr %slot.lead, align 8, !dbg !523
  %slot.__sc_380 = alloca i64, align 8, !dbg !523
  store i64 0, ptr %slot.__sc_380, align 8, !dbg !523
  %slot.__sc_383 = alloca i64, align 8, !dbg !523
  store i64 0, ptr %slot.__sc_383, align 8, !dbg !523
  %slot.start_col = alloca i64, align 8, !dbg !523
  store i64 0, ptr %slot.start_col, align 8, !dbg !523
  %r0 = call i64 @nova_rt_dict_create(), !dbg !524
  store i64 %r0, ptr %slot.result, align 8, !dbg !524
  %r1 = add i64 0, 0, !dbg !525
  %r2 = add i64 %r0, 0, !dbg !525
  %r3.p = getelementptr inbounds [6 x i8], ptr @.str.104, i64 0, i64 0, !dbg !525
  %r3 = ptrtoint ptr %r3.p to i64, !dbg !525
  %_is.dv0 = call i64 @nova_rt_dict_set(i64 %r2, i64 %r3, i64 %r1), !dbg !525
  %r4 = add i64 0, 0, !dbg !526
  %r5 = add i64 %r0, 0, !dbg !526
  %r6.p = getelementptr inbounds [5 x i8], ptr @.str.105, i64 0, i64 0, !dbg !526
  %r6 = ptrtoint ptr %r6.p to i64, !dbg !526
  %_is.dv1 = call i64 @nova_rt_dict_set(i64 %r5, i64 %r6, i64 %r4), !dbg !526
  %r7 = add i64 0, 0, !dbg !527
  %r8 = add i64 %r0, 0, !dbg !527
  %r9.p = getelementptr inbounds [10 x i8], ptr @.str.106, i64 0, i64 0, !dbg !527
  %r9 = ptrtoint ptr %r9.p to i64, !dbg !527
  %_is.dv2 = call i64 @nova_rt_dict_set(i64 %r8, i64 %r9, i64 %r7), !dbg !527
  %r10 = add i64 0, 0, !dbg !528
  %r11 = add i64 %r0, 0, !dbg !528
  %r12.p = getelementptr inbounds [8 x i8], ptr @.str.107, i64 0, i64 0, !dbg !528
  %r12 = ptrtoint ptr %r12.p to i64, !dbg !528
  %_is.dv3 = call i64 @nova_rt_dict_set(i64 %r11, i64 %r12, i64 %r10), !dbg !528
  %r13 = load i64, ptr %slot.name, align 8, !dbg !529
  %r14 = call i64 @nova_rt_len_any(i64 %r13), !dbg !529
  %r15 = add i64 0, 0, !dbg !529
  %r16.cmp = icmp eq i64 %r14, %r15, !dbg !529
  %r16 = zext i1 %r16.cmp to i64, !dbg !529
  %br_then320 = icmp ne i64 %r16, 0, !dbg !529
  br i1 %br_then320, label %then320, label %else321, !dbg !529
then320:
  %r17 = load i64, ptr %slot.result, align 8, !dbg !530
  ret i64 %r17, !dbg !530
else321:
  br label %endif322, !dbg !530
endif322:
  %r18 = load i64, ptr %slot.source, align 8, !dbg !531
  %r19.p = getelementptr inbounds [2 x i8], ptr @.str.0, i64 0, i64 0, !dbg !531
  %r19 = ptrtoint ptr %r19.p to i64, !dbg !531
  %r20 = call i64 @nova_rt_split(i64 %r18, i64 %r19), !dbg !531
  store i64 %r20, ptr %slot.lines, align 8, !dbg !531
  %r21 = add i64 0, 0, !dbg !532
  store i64 %r21, ptr %slot.i, align 8, !dbg !532
  br label %while_hdr323, !dbg !533
while_hdr323:
  %r22 = load i64, ptr %slot.i, align 8, !dbg !533
  %r23 = load i64, ptr %slot.lines, align 8, !dbg !533
  %r24.lp = inttoptr i64 %r23 to ptr, !dbg !533
  %r24.szp = getelementptr i64, ptr %r24.lp, i64 1, !dbg !533
  %r24 = load i64, ptr %r24.szp, align 8, !tbaa !6, !dbg !533
  %r25.cmp = icmp slt i64 %r22, %r24, !dbg !533
  %r25 = zext i1 %r25.cmp to i64, !dbg !533
  %br_while_body324 = icmp ne i64 %r25, 0, !dbg !533
  br i1 %br_while_body324, label %while_body324, label %while_exit325, !prof !90, !dbg !533
while_body324:
  %r26 = load i64, ptr %slot.lines, align 8, !dbg !534
  %r27 = load i64, ptr %slot.i, align 8, !dbg !534
  %r28 = call i64 @nova_rt_index_get(i64 %r26, i64 %r27), !dbg !534
  store i64 %r28, ptr %slot.raw, align 8, !dbg !534
  %r29 = add i64 %r28, 0, !dbg !535
  %r30 = call i64 @nova_rt_trim(i64 %r29), !dbg !535
  store i64 %r30, ptr %slot.line, align 8, !dbg !535
  %r31.p = getelementptr inbounds [1 x i8], ptr @.str.7, i64 0, i64 0, !dbg !536
  %r31 = ptrtoint ptr %r31.p to i64, !dbg !536
  store i64 %r31, ptr %slot.prefix, align 8, !dbg !536
  %r32 = add i64 %r30, 0, !dbg !537
  %r33.p = getelementptr inbounds [4 x i8], ptr @.str.93, i64 0, i64 0, !dbg !537
  %r33 = ptrtoint ptr %r33.p to i64, !dbg !537
  %r34 = load i64, ptr %slot.name, align 8, !dbg !537
  %r35 = call i64 @nova_rt_str_concat(i64 %r33, i64 %r34), !dbg !537
  %r36.p = getelementptr inbounds [2 x i8], ptr @.str.94, i64 0, i64 0, !dbg !537
  %r36 = ptrtoint ptr %r36.p to i64, !dbg !537
  %r37 = call i64 @nova_rt_str_concat(i64 %r35, i64 %r36), !dbg !537
  %r38 = call i64 @nova_rt_starts_with(i64 %r32, i64 %r37), !dbg !537
  store i64 %r38, ptr %slot.__sc_326, align 8, !dbg !537
  %br_or_merge328 = icmp ne i64 %r38, 0, !dbg !537
  br i1 %br_or_merge328, label %or_merge328, label %or_rhs327, !dbg !537
or_rhs327:
  %r39 = load i64, ptr %slot.line, align 8, !dbg !537
  %r40.p = getelementptr inbounds [4 x i8], ptr @.str.93, i64 0, i64 0, !dbg !537
  %r40 = ptrtoint ptr %r40.p to i64, !dbg !537
  %r41 = load i64, ptr %slot.name, align 8, !dbg !537
  %r42 = call i64 @nova_rt_str_concat(i64 %r40, i64 %r41), !dbg !537
  %r43.p = getelementptr inbounds [2 x i8], ptr @.str.20, i64 0, i64 0, !dbg !537
  %r43 = ptrtoint ptr %r43.p to i64, !dbg !537
  %r44 = call i64 @nova_rt_str_concat(i64 %r42, i64 %r43), !dbg !537
  %r45 = call i64 @nova_rt_starts_with(i64 %r39, i64 %r44), !dbg !537
  store i64 %r45, ptr %slot.__sc_326, align 8, !dbg !537
  br label %or_merge328, !dbg !537
or_merge328:
  %r46 = load i64, ptr %slot.__sc_326, align 8, !dbg !537
  store i64 %r46, ptr %slot.__sc_329, align 8, !dbg !537
  %br_or_merge331 = icmp ne i64 %r46, 0, !dbg !537
  br i1 %br_or_merge331, label %or_merge331, label %or_rhs330, !dbg !537
or_rhs330:
  %r47 = load i64, ptr %slot.line, align 8, !dbg !537
  %r48.p = getelementptr inbounds [4 x i8], ptr @.str.93, i64 0, i64 0, !dbg !537
  %r48 = ptrtoint ptr %r48.p to i64, !dbg !537
  %r49 = load i64, ptr %slot.name, align 8, !dbg !537
  %r50 = call i64 @nova_rt_str_concat(i64 %r48, i64 %r49), !dbg !537
  %r51.p = getelementptr inbounds [2 x i8], ptr @.str.95, i64 0, i64 0, !dbg !537
  %r51 = ptrtoint ptr %r51.p to i64, !dbg !537
  %r52 = call i64 @nova_rt_str_concat(i64 %r50, i64 %r51), !dbg !537
  %r53 = call i64 @nova_rt_starts_with(i64 %r47, i64 %r52), !dbg !537
  store i64 %r53, ptr %slot.__sc_329, align 8, !dbg !537
  br label %or_merge331, !dbg !537
or_merge331:
  %r54 = load i64, ptr %slot.__sc_329, align 8, !dbg !537
  %br_then332 = icmp ne i64 %r54, 0, !dbg !537
  br i1 %br_then332, label %then332, label %else333, !dbg !537
then332:
  %r55.p = getelementptr inbounds [4 x i8], ptr @.str.93, i64 0, i64 0, !dbg !538
  %r55 = ptrtoint ptr %r55.p to i64, !dbg !538
  store i64 %r55, ptr %slot.prefix, align 8, !dbg !538
  br label %endif334, !dbg !538
else333:
  %r56 = load i64, ptr %slot.line, align 8, !dbg !539
  %r57.p = getelementptr inbounds [5 x i8], ptr @.str.96, i64 0, i64 0, !dbg !539
  %r57 = ptrtoint ptr %r57.p to i64, !dbg !539
  %r58 = load i64, ptr %slot.name, align 8, !dbg !539
  %r59 = call i64 @nova_rt_str_concat(i64 %r57, i64 %r58), !dbg !539
  %r60.p = getelementptr inbounds [2 x i8], ptr @.str.20, i64 0, i64 0, !dbg !539
  %r60 = ptrtoint ptr %r60.p to i64, !dbg !539
  %r61 = call i64 @nova_rt_str_concat(i64 %r59, i64 %r60), !dbg !539
  %r62 = call i64 @nova_rt_starts_with(i64 %r56, i64 %r61), !dbg !539
  store i64 %r62, ptr %slot.__sc_335, align 8, !dbg !539
  %br_or_merge337 = icmp ne i64 %r62, 0, !dbg !539
  br i1 %br_or_merge337, label %or_merge337, label %or_rhs336, !dbg !539
or_rhs336:
  %r63 = load i64, ptr %slot.line, align 8, !dbg !539
  %r64.p = getelementptr inbounds [5 x i8], ptr @.str.96, i64 0, i64 0, !dbg !539
  %r64 = ptrtoint ptr %r64.p to i64, !dbg !539
  %r65 = load i64, ptr %slot.name, align 8, !dbg !539
  %r66 = call i64 @nova_rt_str_concat(i64 %r64, i64 %r65), !dbg !539
  %r67.p = getelementptr inbounds [2 x i8], ptr @.str.97, i64 0, i64 0, !dbg !539
  %r67 = ptrtoint ptr %r67.p to i64, !dbg !539
  %r68 = call i64 @nova_rt_str_concat(i64 %r66, i64 %r67), !dbg !539
  %r69 = call i64 @nova_rt_starts_with(i64 %r63, i64 %r68), !dbg !539
  store i64 %r69, ptr %slot.__sc_335, align 8, !dbg !539
  br label %or_merge337, !dbg !539
or_merge337:
  %r70 = load i64, ptr %slot.__sc_335, align 8, !dbg !539
  store i64 %r70, ptr %slot.__sc_338, align 8, !dbg !539
  %br_or_merge340 = icmp ne i64 %r70, 0, !dbg !539
  br i1 %br_or_merge340, label %or_merge340, label %or_rhs339, !dbg !539
or_rhs339:
  %r71 = load i64, ptr %slot.line, align 8, !dbg !539
  %r72.p = getelementptr inbounds [5 x i8], ptr @.str.96, i64 0, i64 0, !dbg !539
  %r72 = ptrtoint ptr %r72.p to i64, !dbg !539
  %r73 = load i64, ptr %slot.name, align 8, !dbg !539
  %r74 = call i64 @nova_rt_str_concat(i64 %r72, i64 %r73), !dbg !539
  %r75.p = getelementptr inbounds [2 x i8], ptr @.str.10, i64 0, i64 0, !dbg !539
  %r75 = ptrtoint ptr %r75.p to i64, !dbg !539
  %r76 = call i64 @nova_rt_str_concat(i64 %r74, i64 %r75), !dbg !539
  %r77 = call i64 @nova_rt_starts_with(i64 %r71, i64 %r76), !dbg !539
  store i64 %r77, ptr %slot.__sc_338, align 8, !dbg !539
  br label %or_merge340, !dbg !539
or_merge340:
  %r78 = load i64, ptr %slot.__sc_338, align 8, !dbg !539
  %br_then341 = icmp ne i64 %r78, 0, !dbg !539
  br i1 %br_then341, label %then341, label %else342, !dbg !539
then341:
  %r79.p = getelementptr inbounds [5 x i8], ptr @.str.96, i64 0, i64 0, !dbg !540
  %r79 = ptrtoint ptr %r79.p to i64, !dbg !540
  store i64 %r79, ptr %slot.prefix, align 8, !dbg !540
  br label %endif343, !dbg !540
else342:
  %r80 = load i64, ptr %slot.line, align 8, !dbg !541
  %r81.p = getelementptr inbounds [6 x i8], ptr @.str.98, i64 0, i64 0, !dbg !541
  %r81 = ptrtoint ptr %r81.p to i64, !dbg !541
  %r82 = load i64, ptr %slot.name, align 8, !dbg !541
  %r83 = call i64 @nova_rt_str_concat(i64 %r81, i64 %r82), !dbg !541
  %r84.p = getelementptr inbounds [2 x i8], ptr @.str.20, i64 0, i64 0, !dbg !541
  %r84 = ptrtoint ptr %r84.p to i64, !dbg !541
  %r85 = call i64 @nova_rt_str_concat(i64 %r83, i64 %r84), !dbg !541
  %r86 = call i64 @nova_rt_starts_with(i64 %r80, i64 %r85), !dbg !541
  store i64 %r86, ptr %slot.__sc_344, align 8, !dbg !541
  %br_or_merge346 = icmp ne i64 %r86, 0, !dbg !541
  br i1 %br_or_merge346, label %or_merge346, label %or_rhs345, !dbg !541
or_rhs345:
  %r87 = load i64, ptr %slot.line, align 8, !dbg !541
  %r88.p = getelementptr inbounds [6 x i8], ptr @.str.98, i64 0, i64 0, !dbg !541
  %r88 = ptrtoint ptr %r88.p to i64, !dbg !541
  %r89 = load i64, ptr %slot.name, align 8, !dbg !541
  %r90 = call i64 @nova_rt_str_concat(i64 %r88, i64 %r89), !dbg !541
  %r91.p = getelementptr inbounds [2 x i8], ptr @.str.95, i64 0, i64 0, !dbg !541
  %r91 = ptrtoint ptr %r91.p to i64, !dbg !541
  %r92 = call i64 @nova_rt_str_concat(i64 %r90, i64 %r91), !dbg !541
  %r93 = call i64 @nova_rt_starts_with(i64 %r87, i64 %r92), !dbg !541
  store i64 %r93, ptr %slot.__sc_344, align 8, !dbg !541
  br label %or_merge346, !dbg !541
or_merge346:
  %r94 = load i64, ptr %slot.__sc_344, align 8, !dbg !541
  store i64 %r94, ptr %slot.__sc_347, align 8, !dbg !541
  %br_or_merge349 = icmp ne i64 %r94, 0, !dbg !541
  br i1 %br_or_merge349, label %or_merge349, label %or_rhs348, !dbg !541
or_rhs348:
  %r95 = load i64, ptr %slot.line, align 8, !dbg !541
  %r96.p = getelementptr inbounds [6 x i8], ptr @.str.98, i64 0, i64 0, !dbg !541
  %r96 = ptrtoint ptr %r96.p to i64, !dbg !541
  %r97 = load i64, ptr %slot.name, align 8, !dbg !541
  %r98 = call i64 @nova_rt_str_concat(i64 %r96, i64 %r97), !dbg !541
  %r99.p = getelementptr inbounds [2 x i8], ptr @.str.0, i64 0, i64 0, !dbg !541
  %r99 = ptrtoint ptr %r99.p to i64, !dbg !541
  %r100 = call i64 @nova_rt_str_concat(i64 %r98, i64 %r99), !dbg !541
  %r101 = call i64 @nova_rt_starts_with(i64 %r95, i64 %r100), !dbg !541
  store i64 %r101, ptr %slot.__sc_347, align 8, !dbg !541
  br label %or_merge349, !dbg !541
or_merge349:
  %r102 = load i64, ptr %slot.__sc_347, align 8, !dbg !541
  store i64 %r102, ptr %slot.__sc_350, align 8, !dbg !541
  %br_or_merge352 = icmp ne i64 %r102, 0, !dbg !541
  br i1 %br_or_merge352, label %or_merge352, label %or_rhs351, !dbg !541
or_rhs351:
  %r103 = load i64, ptr %slot.line, align 8, !dbg !541
  %r104.p = getelementptr inbounds [6 x i8], ptr @.str.98, i64 0, i64 0, !dbg !541
  %r104 = ptrtoint ptr %r104.p to i64, !dbg !541
  %r105 = load i64, ptr %slot.name, align 8, !dbg !541
  %r106 = call i64 @nova_rt_str_concat(i64 %r104, i64 %r105), !dbg !541
  %r107.p0 = inttoptr i64 %r103 to ptr, !dbg !541
  %r107.p1 = inttoptr i64 %r106 to ptr, !dbg !541
  %r107.sc = call i32 @strcmp(ptr %r107.p0, ptr %r107.p1), !dbg !541
  %r107.cmp = icmp eq i32 %r107.sc, 0, !dbg !541
  %r107 = zext i1 %r107.cmp to i64, !dbg !541
  store i64 %r107, ptr %slot.__sc_350, align 8, !dbg !541
  br label %or_merge352, !dbg !541
or_merge352:
  %r108 = load i64, ptr %slot.__sc_350, align 8, !dbg !541
  %br_then353 = icmp ne i64 %r108, 0, !dbg !541
  br i1 %br_then353, label %then353, label %else354, !dbg !541
then353:
  %r109.p = getelementptr inbounds [6 x i8], ptr @.str.98, i64 0, i64 0, !dbg !542
  %r109 = ptrtoint ptr %r109.p to i64, !dbg !542
  store i64 %r109, ptr %slot.prefix, align 8, !dbg !542
  br label %endif355, !dbg !542
else354:
  %r110 = load i64, ptr %slot.line, align 8, !dbg !543
  %r111.p = getelementptr inbounds [6 x i8], ptr @.str.108, i64 0, i64 0, !dbg !543
  %r111 = ptrtoint ptr %r111.p to i64, !dbg !543
  %r112 = load i64, ptr %slot.name, align 8, !dbg !543
  %r113 = call i64 @nova_rt_str_concat(i64 %r111, i64 %r112), !dbg !543
  %r114.p = getelementptr inbounds [2 x i8], ptr @.str.20, i64 0, i64 0, !dbg !543
  %r114 = ptrtoint ptr %r114.p to i64, !dbg !543
  %r115 = call i64 @nova_rt_str_concat(i64 %r113, i64 %r114), !dbg !543
  %r116 = call i64 @nova_rt_starts_with(i64 %r110, i64 %r115), !dbg !543
  store i64 %r116, ptr %slot.__sc_356, align 8, !dbg !543
  %br_or_merge358 = icmp ne i64 %r116, 0, !dbg !543
  br i1 %br_or_merge358, label %or_merge358, label %or_rhs357, !dbg !543
or_rhs357:
  %r117 = load i64, ptr %slot.line, align 8, !dbg !543
  %r118.p = getelementptr inbounds [6 x i8], ptr @.str.108, i64 0, i64 0, !dbg !543
  %r118 = ptrtoint ptr %r118.p to i64, !dbg !543
  %r119 = load i64, ptr %slot.name, align 8, !dbg !543
  %r120 = call i64 @nova_rt_str_concat(i64 %r118, i64 %r119), !dbg !543
  %r121.p = getelementptr inbounds [2 x i8], ptr @.str.95, i64 0, i64 0, !dbg !543
  %r121 = ptrtoint ptr %r121.p to i64, !dbg !543
  %r122 = call i64 @nova_rt_str_concat(i64 %r120, i64 %r121), !dbg !543
  %r123 = call i64 @nova_rt_starts_with(i64 %r117, i64 %r122), !dbg !543
  store i64 %r123, ptr %slot.__sc_356, align 8, !dbg !543
  br label %or_merge358, !dbg !543
or_merge358:
  %r124 = load i64, ptr %slot.__sc_356, align 8, !dbg !543
  store i64 %r124, ptr %slot.__sc_359, align 8, !dbg !543
  %br_or_merge361 = icmp ne i64 %r124, 0, !dbg !543
  br i1 %br_or_merge361, label %or_merge361, label %or_rhs360, !dbg !543
or_rhs360:
  %r125 = load i64, ptr %slot.line, align 8, !dbg !543
  %r126.p = getelementptr inbounds [6 x i8], ptr @.str.108, i64 0, i64 0, !dbg !543
  %r126 = ptrtoint ptr %r126.p to i64, !dbg !543
  %r127 = load i64, ptr %slot.name, align 8, !dbg !543
  %r128 = call i64 @nova_rt_str_concat(i64 %r126, i64 %r127), !dbg !543
  %r129.p0 = inttoptr i64 %r125 to ptr, !dbg !543
  %r129.p1 = inttoptr i64 %r128 to ptr, !dbg !543
  %r129.sc = call i32 @strcmp(ptr %r129.p0, ptr %r129.p1), !dbg !543
  %r129.cmp = icmp eq i32 %r129.sc, 0, !dbg !543
  %r129 = zext i1 %r129.cmp to i64, !dbg !543
  store i64 %r129, ptr %slot.__sc_359, align 8, !dbg !543
  br label %or_merge361, !dbg !543
or_merge361:
  %r130 = load i64, ptr %slot.__sc_359, align 8, !dbg !543
  %br_then362 = icmp ne i64 %r130, 0, !dbg !543
  br i1 %br_then362, label %then362, label %else363, !dbg !543
then362:
  %r131.p = getelementptr inbounds [6 x i8], ptr @.str.108, i64 0, i64 0, !dbg !544
  %r131 = ptrtoint ptr %r131.p to i64, !dbg !544
  store i64 %r131, ptr %slot.prefix, align 8, !dbg !544
  br label %endif364, !dbg !544
else363:
  %r132 = load i64, ptr %slot.line, align 8, !dbg !545
  %r133.p = getelementptr inbounds [7 x i8], ptr @.str.109, i64 0, i64 0, !dbg !545
  %r133 = ptrtoint ptr %r133.p to i64, !dbg !545
  %r134 = load i64, ptr %slot.name, align 8, !dbg !545
  %r135 = call i64 @nova_rt_str_concat(i64 %r133, i64 %r134), !dbg !545
  %r136.p = getelementptr inbounds [2 x i8], ptr @.str.20, i64 0, i64 0, !dbg !545
  %r136 = ptrtoint ptr %r136.p to i64, !dbg !545
  %r137 = call i64 @nova_rt_str_concat(i64 %r135, i64 %r136), !dbg !545
  %r138 = call i64 @nova_rt_starts_with(i64 %r132, i64 %r137), !dbg !545
  store i64 %r138, ptr %slot.__sc_365, align 8, !dbg !545
  %br_or_merge367 = icmp ne i64 %r138, 0, !dbg !545
  br i1 %br_or_merge367, label %or_merge367, label %or_rhs366, !dbg !545
or_rhs366:
  %r139 = load i64, ptr %slot.line, align 8, !dbg !545
  %r140.p = getelementptr inbounds [7 x i8], ptr @.str.109, i64 0, i64 0, !dbg !545
  %r140 = ptrtoint ptr %r140.p to i64, !dbg !545
  %r141 = load i64, ptr %slot.name, align 8, !dbg !545
  %r142 = call i64 @nova_rt_str_concat(i64 %r140, i64 %r141), !dbg !545
  %r143.p = getelementptr inbounds [2 x i8], ptr @.str.95, i64 0, i64 0, !dbg !545
  %r143 = ptrtoint ptr %r143.p to i64, !dbg !545
  %r144 = call i64 @nova_rt_str_concat(i64 %r142, i64 %r143), !dbg !545
  %r145 = call i64 @nova_rt_starts_with(i64 %r139, i64 %r144), !dbg !545
  store i64 %r145, ptr %slot.__sc_365, align 8, !dbg !545
  br label %or_merge367, !dbg !545
or_merge367:
  %r146 = load i64, ptr %slot.__sc_365, align 8, !dbg !545
  store i64 %r146, ptr %slot.__sc_368, align 8, !dbg !545
  %br_or_merge370 = icmp ne i64 %r146, 0, !dbg !545
  br i1 %br_or_merge370, label %or_merge370, label %or_rhs369, !dbg !545
or_rhs369:
  %r147 = load i64, ptr %slot.line, align 8, !dbg !545
  %r148.p = getelementptr inbounds [7 x i8], ptr @.str.109, i64 0, i64 0, !dbg !545
  %r148 = ptrtoint ptr %r148.p to i64, !dbg !545
  %r149 = load i64, ptr %slot.name, align 8, !dbg !545
  %r150 = call i64 @nova_rt_str_concat(i64 %r148, i64 %r149), !dbg !545
  %r151.p0 = inttoptr i64 %r147 to ptr, !dbg !545
  %r151.p1 = inttoptr i64 %r150 to ptr, !dbg !545
  %r151.sc = call i32 @strcmp(ptr %r151.p0, ptr %r151.p1), !dbg !545
  %r151.cmp = icmp eq i32 %r151.sc, 0, !dbg !545
  %r151 = zext i1 %r151.cmp to i64, !dbg !545
  store i64 %r151, ptr %slot.__sc_368, align 8, !dbg !545
  br label %or_merge370, !dbg !545
or_merge370:
  %r152 = load i64, ptr %slot.__sc_368, align 8, !dbg !545
  %br_then371 = icmp ne i64 %r152, 0, !dbg !545
  br i1 %br_then371, label %then371, label %else372, !dbg !545
then371:
  %r153.p = getelementptr inbounds [7 x i8], ptr @.str.109, i64 0, i64 0, !dbg !546
  %r153 = ptrtoint ptr %r153.p to i64, !dbg !546
  store i64 %r153, ptr %slot.prefix, align 8, !dbg !546
  br label %endif373, !dbg !546
else372:
  br label %endif373, !dbg !546
endif373:
  br label %endif364, !dbg !546
endif364:
  br label %endif355, !dbg !546
endif355:
  br label %endif343, !dbg !546
endif343:
  br label %endif334, !dbg !546
endif334:
  %r154 = load i64, ptr %slot.prefix, align 8, !dbg !547
  %r155 = call i64 @nova_rt_len_any(i64 %r154), !dbg !547
  %r156 = add i64 0, 0, !dbg !547
  %r157.cmp = icmp sgt i64 %r155, %r156, !dbg !547
  %r157 = zext i1 %r157.cmp to i64, !dbg !547
  %br_then374 = icmp ne i64 %r157, 0, !dbg !547
  br i1 %br_then374, label %then374, label %else375, !dbg !547
then374:
  %r158 = add i64 0, 0, !dbg !548
  store i64 %r158, ptr %slot.lead, align 8, !dbg !548
  br label %while_hdr377, !dbg !549
while_hdr377:
  %r159 = load i64, ptr %slot.lead, align 8, !dbg !549
  %r160 = load i64, ptr %slot.raw, align 8, !dbg !549
  %r161 = call i64 @nova_rt_len_any(i64 %r160), !dbg !549
  %r162.cmp = icmp slt i64 %r159, %r161, !dbg !549
  %r162 = zext i1 %r162.cmp to i64, !dbg !549
  store i64 %r162, ptr %slot.__sc_380, align 8, !dbg !549
  %br_and_rhs381 = icmp ne i64 %r162, 0, !dbg !549
  br i1 %br_and_rhs381, label %and_rhs381, label %and_merge382, !dbg !549
and_rhs381:
  %r163 = load i64, ptr %slot.raw, align 8, !dbg !549
  %r164 = load i64, ptr %slot.lead, align 8, !dbg !549
  %r165 = call i64 @nova_rt_index_get(i64 %r163, i64 %r164), !dbg !549
  %r166.p = getelementptr inbounds [2 x i8], ptr @.str.20, i64 0, i64 0, !dbg !549
  %r166 = ptrtoint ptr %r166.p to i64, !dbg !549
  %r167.p0 = inttoptr i64 %r165 to ptr, !dbg !549
  %r167.p1 = inttoptr i64 %r166 to ptr, !dbg !549
  %r167.sc = call i32 @strcmp(ptr %r167.p0, ptr %r167.p1), !dbg !549
  %r167.cmp = icmp eq i32 %r167.sc, 0, !dbg !549
  %r167 = zext i1 %r167.cmp to i64, !dbg !549
  store i64 %r167, ptr %slot.__sc_383, align 8, !dbg !549
  %br_or_merge385 = icmp ne i64 %r167, 0, !dbg !549
  br i1 %br_or_merge385, label %or_merge385, label %or_rhs384, !dbg !549
or_rhs384:
  %r168 = load i64, ptr %slot.raw, align 8, !dbg !549
  %r169 = load i64, ptr %slot.lead, align 8, !dbg !549
  %r170 = call i64 @nova_rt_index_get(i64 %r168, i64 %r169), !dbg !549
  %r171.p = getelementptr inbounds [2 x i8], ptr @.str.21, i64 0, i64 0, !dbg !549
  %r171 = ptrtoint ptr %r171.p to i64, !dbg !549
  %r172.p0 = inttoptr i64 %r170 to ptr, !dbg !549
  %r172.p1 = inttoptr i64 %r171 to ptr, !dbg !549
  %r172.sc = call i32 @strcmp(ptr %r172.p0, ptr %r172.p1), !dbg !549
  %r172.cmp = icmp eq i32 %r172.sc, 0, !dbg !549
  %r172 = zext i1 %r172.cmp to i64, !dbg !549
  store i64 %r172, ptr %slot.__sc_383, align 8, !dbg !549
  br label %or_merge385, !dbg !549
or_merge385:
  %r173 = load i64, ptr %slot.__sc_383, align 8, !dbg !549
  store i64 %r173, ptr %slot.__sc_380, align 8, !dbg !549
  br label %and_merge382, !dbg !549
and_merge382:
  %r174 = load i64, ptr %slot.__sc_380, align 8, !dbg !549
  %br_while_body378 = icmp ne i64 %r174, 0, !dbg !549
  br i1 %br_while_body378, label %while_body378, label %while_exit379, !prof !90, !dbg !549
while_body378:
  %r175 = load i64, ptr %slot.lead, align 8, !dbg !550
  %r176 = add i64 1, 0, !dbg !550
  %r177 = add i64 %r175, %r176, !dbg !550
  store i64 %r177, ptr %slot.lead, align 8, !dbg !550
  br label %while_hdr377, !dbg !550
while_exit379:
  %r178 = load i64, ptr %slot.lead, align 8, !dbg !551
  %r179 = load i64, ptr %slot.prefix, align 8, !dbg !551
  %r180 = call i64 @nova_rt_len_any(i64 %r179), !dbg !551
  %r181 = add i64 %r178, %r180, !dbg !551
  store i64 %r181, ptr %slot.start_col, align 8, !dbg !551
  %r182 = add i64 1, 0, !dbg !552
  %r183 = load i64, ptr %slot.result, align 8, !dbg !552
  %r184.p = getelementptr inbounds [6 x i8], ptr @.str.104, i64 0, i64 0, !dbg !552
  %r184 = ptrtoint ptr %r184.p to i64, !dbg !552
  %_is.dv4 = call i64 @nova_rt_dict_set(i64 %r183, i64 %r184, i64 %r182), !dbg !552
  %r185 = load i64, ptr %slot.i, align 8, !dbg !553
  %r186 = load i64, ptr %slot.result, align 8, !dbg !553
  %r187.p = getelementptr inbounds [5 x i8], ptr @.str.105, i64 0, i64 0, !dbg !553
  %r187 = ptrtoint ptr %r187.p to i64, !dbg !553
  %_is.dv5 = call i64 @nova_rt_dict_set(i64 %r186, i64 %r187, i64 %r185), !dbg !553
  %r188 = add i64 %r181, 0, !dbg !554
  %r189 = load i64, ptr %slot.result, align 8, !dbg !554
  %r190.p = getelementptr inbounds [10 x i8], ptr @.str.106, i64 0, i64 0, !dbg !554
  %r190 = ptrtoint ptr %r190.p to i64, !dbg !554
  %_is.dv6 = call i64 @nova_rt_dict_set(i64 %r189, i64 %r190, i64 %r188), !dbg !554
  %r191 = add i64 %r181, 0, !dbg !555
  %r192 = load i64, ptr %slot.name, align 8, !dbg !555
  %r193 = call i64 @nova_rt_len_any(i64 %r192), !dbg !555
  %r194 = add i64 %r191, %r193, !dbg !555
  %r195 = load i64, ptr %slot.result, align 8, !dbg !555
  %r196.p = getelementptr inbounds [8 x i8], ptr @.str.107, i64 0, i64 0, !dbg !555
  %r196 = ptrtoint ptr %r196.p to i64, !dbg !555
  %_is.dv7 = call i64 @nova_rt_dict_set(i64 %r195, i64 %r196, i64 %r194), !dbg !555
  %r197 = load i64, ptr %slot.result, align 8, !dbg !556
  ret i64 %r197, !dbg !556
else375:
  br label %endif376, !dbg !556
endif376:
  %r198 = load i64, ptr %slot.i, align 8, !dbg !557
  %r199 = add i64 1, 0, !dbg !557
  %r200 = add i64 %r198, %r199, !dbg !557
  store i64 %r200, ptr %slot.i, align 8, !dbg !557
  br label %while_hdr323, !dbg !557
while_exit325:
  %r201 = load i64, ptr %slot.result, align 8, !dbg !558
  ret i64 %r201, !dbg !558
}

define i64 @build_definition_response(i64 %p0, i64 %p1, i64 %p2) nounwind !dbg !559 {
entry:
  %slot.id = alloca i64, align 8, !dbg !560
  store i64 %p0, ptr %slot.id, align 8, !dbg !560
  %slot.uri = alloca i64, align 8, !dbg !560
  store i64 %p1, ptr %slot.uri, align 8, !dbg !560
  %slot.loc = alloca i64, align 8, !dbg !560
  store i64 %p2, ptr %slot.loc, align 8, !dbg !560
  %slot.line = alloca i64, align 8, !dbg !560
  store i64 0, ptr %slot.line, align 8, !dbg !560
  %slot.sc = alloca i64, align 8, !dbg !560
  store i64 0, ptr %slot.sc, align 8, !dbg !560
  %slot.ec = alloca i64, align 8, !dbg !560
  store i64 0, ptr %slot.ec, align 8, !dbg !560
  %slot.range = alloca i64, align 8, !dbg !560
  store i64 0, ptr %slot.range, align 8, !dbg !560
  %slot.location = alloca i64, align 8, !dbg !560
  store i64 0, ptr %slot.location, align 8, !dbg !560
  %r0 = load i64, ptr %slot.loc, align 8, !dbg !561
  %r1.p = getelementptr inbounds [6 x i8], ptr @.str.104, i64 0, i64 0, !dbg !561
  %r1 = ptrtoint ptr %r1.p to i64, !dbg !561
  %r2 = call i64 @nova_rt_dict_get(i64 %r0, i64 %r1), !dbg !561
  %r3 = add i64 0, 0, !dbg !561
  %r4 = call i64 @nova_rt_eq(i64 %r2, i64 %r3), !dbg !561
  %br_then386 = icmp ne i64 %r4, 0, !dbg !561
  br i1 %br_then386, label %then386, label %else387, !dbg !561
then386:
  %r5 = load i64, ptr %slot.id, align 8, !dbg !562
  %r6.p = getelementptr inbounds [5 x i8], ptr @.str.99, i64 0, i64 0, !dbg !562
  %r6 = ptrtoint ptr %r6.p to i64, !dbg !562
  %r7 = call i64 @build_response(i64 %r5, i64 %r6), !dbg !562
  ret i64 %r7, !dbg !562
else387:
  br label %endif388, !dbg !562
endif388:
  %r8 = load i64, ptr %slot.loc, align 8, !dbg !563
  %r9.p = getelementptr inbounds [5 x i8], ptr @.str.105, i64 0, i64 0, !dbg !563
  %r9 = ptrtoint ptr %r9.p to i64, !dbg !563
  %r10 = call i64 @nova_rt_dict_get(i64 %r8, i64 %r9), !dbg !563
  store i64 %r10, ptr %slot.line, align 8, !dbg !563
  %r11 = load i64, ptr %slot.loc, align 8, !dbg !564
  %r12.p = getelementptr inbounds [10 x i8], ptr @.str.106, i64 0, i64 0, !dbg !564
  %r12 = ptrtoint ptr %r12.p to i64, !dbg !564
  %r13 = call i64 @nova_rt_dict_get(i64 %r11, i64 %r12), !dbg !564
  store i64 %r13, ptr %slot.sc, align 8, !dbg !564
  %r14 = load i64, ptr %slot.loc, align 8, !dbg !565
  %r15.p = getelementptr inbounds [8 x i8], ptr @.str.107, i64 0, i64 0, !dbg !565
  %r15 = ptrtoint ptr %r15.p to i64, !dbg !565
  %r16 = call i64 @nova_rt_dict_get(i64 %r14, i64 %r15), !dbg !565
  store i64 %r16, ptr %slot.ec, align 8, !dbg !565
  %r17.p = getelementptr inbounds [18 x i8], ptr @.str.110, i64 0, i64 0, !dbg !566
  %r17 = ptrtoint ptr %r17.p to i64, !dbg !566
  %r18 = add i64 %r10, 0, !dbg !566
  %r19 = call i64 @nova_rt_any_to_str(i64 %r18), !dbg !566
  %r20 = call i64 @nova_rt_str_concat(i64 %r17, i64 %r19), !dbg !566
  %r21.p = getelementptr inbounds [14 x i8], ptr @.str.111, i64 0, i64 0, !dbg !566
  %r21 = ptrtoint ptr %r21.p to i64, !dbg !566
  %r22 = call i64 @nova_rt_str_concat(i64 %r20, i64 %r21), !dbg !566
  %r23 = add i64 %r13, 0, !dbg !566
  %r24 = call i64 @nova_rt_any_to_str(i64 %r23), !dbg !566
  %r25 = call i64 @nova_rt_str_concat(i64 %r22, i64 %r24), !dbg !566
  %r26.p = getelementptr inbounds [17 x i8], ptr @.str.112, i64 0, i64 0, !dbg !566
  %r26 = ptrtoint ptr %r26.p to i64, !dbg !566
  %r27 = call i64 @nova_rt_str_concat(i64 %r25, i64 %r26), !dbg !566
  %r28 = add i64 %r10, 0, !dbg !566
  %r29 = call i64 @nova_rt_any_to_str(i64 %r28), !dbg !566
  %r30 = call i64 @nova_rt_str_concat(i64 %r27, i64 %r29), !dbg !566
  %r31.p = getelementptr inbounds [14 x i8], ptr @.str.111, i64 0, i64 0, !dbg !566
  %r31 = ptrtoint ptr %r31.p to i64, !dbg !566
  %r32 = call i64 @nova_rt_str_concat(i64 %r30, i64 %r31), !dbg !566
  %r33 = add i64 %r16, 0, !dbg !566
  %r34 = call i64 @nova_rt_any_to_str(i64 %r33), !dbg !566
  %r35 = call i64 @nova_rt_str_concat(i64 %r32, i64 %r34), !dbg !566
  %r36.p = getelementptr inbounds [3 x i8], ptr @.str.113, i64 0, i64 0, !dbg !566
  %r36 = ptrtoint ptr %r36.p to i64, !dbg !566
  %r37 = call i64 @nova_rt_str_concat(i64 %r35, i64 %r36), !dbg !566
  store i64 %r37, ptr %slot.range, align 8, !dbg !566
  %r38.p = getelementptr inbounds [8 x i8], ptr @.str.36, i64 0, i64 0, !dbg !567
  %r38 = ptrtoint ptr %r38.p to i64, !dbg !567
  %r39 = load i64, ptr %slot.uri, align 8, !dbg !567
  %r40 = call i64 @json_str(i64 %r39), !dbg !567
  %r41 = call i64 @nova_rt_str_concat(i64 %r38, i64 %r40), !dbg !567
  %r42.p = getelementptr inbounds [10 x i8], ptr @.str.114, i64 0, i64 0, !dbg !567
  %r42 = ptrtoint ptr %r42.p to i64, !dbg !567
  %r43 = call i64 @nova_rt_str_concat(i64 %r41, i64 %r42), !dbg !567
  %r44 = add i64 %r37, 0, !dbg !567
  %r45 = call i64 @nova_rt_str_concat(i64 %r43, i64 %r44), !dbg !567
  %r46.p = getelementptr inbounds [2 x i8], ptr @.str.17, i64 0, i64 0, !dbg !567
  %r46 = ptrtoint ptr %r46.p to i64, !dbg !567
  %r47 = call i64 @nova_rt_str_concat(i64 %r45, i64 %r46), !dbg !567
  store i64 %r47, ptr %slot.location, align 8, !dbg !567
  %r48 = load i64, ptr %slot.id, align 8, !dbg !568
  %r49 = add i64 %r47, 0, !dbg !568
  %r50 = call i64 @build_response(i64 %r48, i64 %r49), !dbg !568
  ret i64 %r50, !dbg !568
}

define i64 @completion_items() nounwind !dbg !569 {
entry:
  %slot.names = alloca i64, align 8, !dbg !570
  store i64 0, ptr %slot.names, align 8, !dbg !570
  %r1.p = getelementptr inbounds [6 x i8], ptr @.str.49, i64 0, i64 0, !dbg !571
  %r1 = ptrtoint ptr %r1.p to i64, !dbg !571
  %r2.p = getelementptr inbounds [4 x i8], ptr @.str.51, i64 0, i64 0, !dbg !571
  %r2 = ptrtoint ptr %r2.p to i64, !dbg !571
  %r3.p = getelementptr inbounds [4 x i8], ptr @.str.53, i64 0, i64 0, !dbg !571
  %r3 = ptrtoint ptr %r3.p to i64, !dbg !571
  %r4.p = getelementptr inbounds [4 x i8], ptr @.str.55, i64 0, i64 0, !dbg !571
  %r4 = ptrtoint ptr %r4.p to i64, !dbg !571
  %r5.p = getelementptr inbounds [6 x i8], ptr @.str.57, i64 0, i64 0, !dbg !571
  %r5 = ptrtoint ptr %r5.p to i64, !dbg !571
  %r6.p = getelementptr inbounds [5 x i8], ptr @.str.115, i64 0, i64 0, !dbg !571
  %r6 = ptrtoint ptr %r6.p to i64, !dbg !571
  %r7.p = getelementptr inbounds [8 x i8], ptr @.str.116, i64 0, i64 0, !dbg !571
  %r7 = ptrtoint ptr %r7.p to i64, !dbg !571
  %r8.p = getelementptr inbounds [7 x i8], ptr @.str.117, i64 0, i64 0, !dbg !571
  %r8 = ptrtoint ptr %r8.p to i64, !dbg !571
  %r9.p = getelementptr inbounds [5 x i8], ptr @.str.118, i64 0, i64 0, !dbg !571
  %r9 = ptrtoint ptr %r9.p to i64, !dbg !571
  %r0 = call i64 @nova_rt_list_create(), !dbg !571
  call i64 @nova_rt_list_append(i64 %r0, i64 %r1), !dbg !571
  call i64 @nova_rt_list_append(i64 %r0, i64 %r2), !dbg !571
  call i64 @nova_rt_list_append(i64 %r0, i64 %r3), !dbg !571
  call i64 @nova_rt_list_append(i64 %r0, i64 %r4), !dbg !571
  call i64 @nova_rt_list_append(i64 %r0, i64 %r5), !dbg !571
  call i64 @nova_rt_list_append(i64 %r0, i64 %r6), !dbg !571
  call i64 @nova_rt_list_append(i64 %r0, i64 %r7), !dbg !571
  call i64 @nova_rt_list_append(i64 %r0, i64 %r8), !dbg !571
  call i64 @nova_rt_list_append(i64 %r0, i64 %r9), !dbg !571
  store i64 %r0, ptr %slot.names, align 8, !dbg !571
  %r10 = add i64 %r0, 0, !dbg !572
  %r11.p = getelementptr inbounds [5 x i8], ptr @.str.59, i64 0, i64 0, !dbg !572
  %r11 = ptrtoint ptr %r11.p to i64, !dbg !572
  %r12 = call i64 @nova_rt_list_append(i64 %r10, i64 %r11), !dbg !572
  %r13 = add i64 %r0, 0, !dbg !573
  %r14.p = getelementptr inbounds [4 x i8], ptr @.str.61, i64 0, i64 0, !dbg !573
  %r14 = ptrtoint ptr %r14.p to i64, !dbg !573
  %r15 = call i64 @nova_rt_list_append(i64 %r13, i64 %r14), !dbg !573
  %r16 = add i64 %r0, 0, !dbg !574
  %r17.p = getelementptr inbounds [7 x i8], ptr @.str.63, i64 0, i64 0, !dbg !574
  %r17 = ptrtoint ptr %r17.p to i64, !dbg !574
  %r18 = call i64 @nova_rt_list_append(i64 %r16, i64 %r17), !dbg !574
  %r19 = add i64 %r0, 0, !dbg !575
  %r20.p = getelementptr inbounds [7 x i8], ptr @.str.65, i64 0, i64 0, !dbg !575
  %r20 = ptrtoint ptr %r20.p to i64, !dbg !575
  %r21 = call i64 @nova_rt_list_append(i64 %r19, i64 %r20), !dbg !575
  %r22 = add i64 %r0, 0, !dbg !576
  %r23.p = getelementptr inbounds [4 x i8], ptr @.str.67, i64 0, i64 0, !dbg !576
  %r23 = ptrtoint ptr %r23.p to i64, !dbg !576
  %r24 = call i64 @nova_rt_list_append(i64 %r22, i64 %r23), !dbg !576
  %r25 = add i64 %r0, 0, !dbg !577
  %r26.p = getelementptr inbounds [5 x i8], ptr @.str.119, i64 0, i64 0, !dbg !577
  %r26 = ptrtoint ptr %r26.p to i64, !dbg !577
  %r27 = call i64 @nova_rt_list_append(i64 %r25, i64 %r26), !dbg !577
  %r28 = add i64 %r0, 0, !dbg !578
  %r29.p = getelementptr inbounds [8 x i8], ptr @.str.120, i64 0, i64 0, !dbg !578
  %r29 = ptrtoint ptr %r29.p to i64, !dbg !578
  %r30 = call i64 @nova_rt_list_append(i64 %r28, i64 %r29), !dbg !578
  %r31 = add i64 %r0, 0, !dbg !579
  %r32.p = getelementptr inbounds [8 x i8], ptr @.str.121, i64 0, i64 0, !dbg !579
  %r32 = ptrtoint ptr %r32.p to i64, !dbg !579
  %r33 = call i64 @nova_rt_list_append(i64 %r31, i64 %r32), !dbg !579
  %r34 = add i64 %r0, 0, !dbg !580
  %r35.p = getelementptr inbounds [10 x i8], ptr @.str.122, i64 0, i64 0, !dbg !580
  %r35 = ptrtoint ptr %r35.p to i64, !dbg !580
  %r36 = call i64 @nova_rt_list_append(i64 %r34, i64 %r35), !dbg !580
  %r37 = add i64 %r0, 0, !dbg !581
  %r38.p = getelementptr inbounds [10 x i8], ptr @.str.123, i64 0, i64 0, !dbg !581
  %r38 = ptrtoint ptr %r38.p to i64, !dbg !581
  %r39 = call i64 @nova_rt_list_append(i64 %r37, i64 %r38), !dbg !581
  %r40 = add i64 %r0, 0, !dbg !582
  %r41.p = getelementptr inbounds [10 x i8], ptr @.str.124, i64 0, i64 0, !dbg !582
  %r41 = ptrtoint ptr %r41.p to i64, !dbg !582
  %r42 = call i64 @nova_rt_list_append(i64 %r40, i64 %r41), !dbg !582
  %r43 = add i64 %r0, 0, !dbg !583
  %r44.p = getelementptr inbounds [4 x i8], ptr @.str.125, i64 0, i64 0, !dbg !583
  %r44 = ptrtoint ptr %r44.p to i64, !dbg !583
  %r45 = call i64 @nova_rt_list_append(i64 %r43, i64 %r44), !dbg !583
  %r46 = add i64 %r0, 0, !dbg !584
  %r47.p = getelementptr inbounds [8 x i8], ptr @.str.126, i64 0, i64 0, !dbg !584
  %r47 = ptrtoint ptr %r47.p to i64, !dbg !584
  %r48 = call i64 @nova_rt_list_append(i64 %r46, i64 %r47), !dbg !584
  %r49 = add i64 %r0, 0, !dbg !585
  %r50.p = getelementptr inbounds [9 x i8], ptr @.str.127, i64 0, i64 0, !dbg !585
  %r50 = ptrtoint ptr %r50.p to i64, !dbg !585
  %r51 = call i64 @nova_rt_list_append(i64 %r49, i64 %r50), !dbg !585
  %r52 = add i64 %r0, 0, !dbg !586
  %r53.p = getelementptr inbounds [6 x i8], ptr @.str.128, i64 0, i64 0, !dbg !586
  %r53 = ptrtoint ptr %r53.p to i64, !dbg !586
  %r54 = call i64 @nova_rt_list_append(i64 %r52, i64 %r53), !dbg !586
  %r55 = add i64 %r0, 0, !dbg !587
  %r56.p = getelementptr inbounds [5 x i8], ptr @.str.129, i64 0, i64 0, !dbg !587
  %r56 = ptrtoint ptr %r56.p to i64, !dbg !587
  %r57 = call i64 @nova_rt_list_append(i64 %r55, i64 %r56), !dbg !587
  %r58 = add i64 %r0, 0, !dbg !588
  %r59.p = getelementptr inbounds [5 x i8], ptr @.str.130, i64 0, i64 0, !dbg !588
  %r59 = ptrtoint ptr %r59.p to i64, !dbg !588
  %r60 = call i64 @nova_rt_list_append(i64 %r58, i64 %r59), !dbg !588
  %r61 = add i64 %r0, 0, !dbg !589
  %r62.p = getelementptr inbounds [6 x i8], ptr @.str.131, i64 0, i64 0, !dbg !589
  %r62 = ptrtoint ptr %r62.p to i64, !dbg !589
  %r63 = call i64 @nova_rt_list_append(i64 %r61, i64 %r62), !dbg !589
  %r64 = add i64 %r0, 0, !dbg !590
  %r65.p = getelementptr inbounds [6 x i8], ptr @.str.132, i64 0, i64 0, !dbg !590
  %r65 = ptrtoint ptr %r65.p to i64, !dbg !590
  %r66 = call i64 @nova_rt_list_append(i64 %r64, i64 %r65), !dbg !590
  %r67 = add i64 %r0, 0, !dbg !591
  %r68.p = getelementptr inbounds [12 x i8], ptr @.str.133, i64 0, i64 0, !dbg !591
  %r68 = ptrtoint ptr %r68.p to i64, !dbg !591
  %r69 = call i64 @nova_rt_list_append(i64 %r67, i64 %r68), !dbg !591
  %r70 = add i64 %r0, 0, !dbg !592
  %r71.p = getelementptr inbounds [10 x i8], ptr @.str.134, i64 0, i64 0, !dbg !592
  %r71 = ptrtoint ptr %r71.p to i64, !dbg !592
  %r72 = call i64 @nova_rt_list_append(i64 %r70, i64 %r71), !dbg !592
  %r73 = add i64 %r0, 0, !dbg !593
  %r74.p = getelementptr inbounds [5 x i8], ptr @.str.135, i64 0, i64 0, !dbg !593
  %r74 = ptrtoint ptr %r74.p to i64, !dbg !593
  %r75 = call i64 @nova_rt_list_append(i64 %r73, i64 %r74), !dbg !593
  %r76 = add i64 %r0, 0, !dbg !594
  %r77.p = getelementptr inbounds [8 x i8], ptr @.str.136, i64 0, i64 0, !dbg !594
  %r77 = ptrtoint ptr %r77.p to i64, !dbg !594
  %r78 = call i64 @nova_rt_list_append(i64 %r76, i64 %r77), !dbg !594
  %r79 = add i64 %r0, 0, !dbg !595
  %r80.p = getelementptr inbounds [7 x i8], ptr @.str.87, i64 0, i64 0, !dbg !595
  %r80 = ptrtoint ptr %r80.p to i64, !dbg !595
  %r81 = call i64 @nova_rt_list_append(i64 %r79, i64 %r80), !dbg !595
  %r82 = add i64 %r0, 0, !dbg !596
  %r83.p = getelementptr inbounds [5 x i8], ptr @.str.69, i64 0, i64 0, !dbg !596
  %r83 = ptrtoint ptr %r83.p to i64, !dbg !596
  %r84 = call i64 @nova_rt_list_append(i64 %r82, i64 %r83), !dbg !596
  %r85 = add i64 %r0, 0, !dbg !597
  %r86.p = getelementptr inbounds [8 x i8], ptr @.str.137, i64 0, i64 0, !dbg !597
  %r86 = ptrtoint ptr %r86.p to i64, !dbg !597
  %r87 = call i64 @nova_rt_list_append(i64 %r85, i64 %r86), !dbg !597
  %r88 = add i64 %r0, 0, !dbg !598
  %r89.p = getelementptr inbounds [5 x i8], ptr @.str.71, i64 0, i64 0, !dbg !598
  %r89 = ptrtoint ptr %r89.p to i64, !dbg !598
  %r90 = call i64 @nova_rt_list_append(i64 %r88, i64 %r89), !dbg !598
  %r91 = add i64 %r0, 0, !dbg !599
  %r92.p = getelementptr inbounds [10 x i8], ptr @.str.138, i64 0, i64 0, !dbg !599
  %r92 = ptrtoint ptr %r92.p to i64, !dbg !599
  %r93 = call i64 @nova_rt_list_append(i64 %r91, i64 %r92), !dbg !599
  %r94 = add i64 %r0, 0, !dbg !600
  %r95.p = getelementptr inbounds [6 x i8], ptr @.str.73, i64 0, i64 0, !dbg !600
  %r95 = ptrtoint ptr %r95.p to i64, !dbg !600
  %r96 = call i64 @nova_rt_list_append(i64 %r94, i64 %r95), !dbg !600
  %r97 = add i64 %r0, 0, !dbg !601
  %r98.p = getelementptr inbounds [8 x i8], ptr @.str.75, i64 0, i64 0, !dbg !601
  %r98 = ptrtoint ptr %r98.p to i64, !dbg !601
  %r99 = call i64 @nova_rt_list_append(i64 %r97, i64 %r98), !dbg !601
  %r100 = add i64 %r0, 0, !dbg !602
  %r101.p = getelementptr inbounds [5 x i8], ptr @.str.77, i64 0, i64 0, !dbg !602
  %r101 = ptrtoint ptr %r101.p to i64, !dbg !602
  %r102 = call i64 @nova_rt_list_append(i64 %r100, i64 %r101), !dbg !602
  %r103 = add i64 %r0, 0, !dbg !603
  %r104.p = getelementptr inbounds [5 x i8], ptr @.str.79, i64 0, i64 0, !dbg !603
  %r104 = ptrtoint ptr %r104.p to i64, !dbg !603
  %r105 = call i64 @nova_rt_list_append(i64 %r103, i64 %r104), !dbg !603
  %r106 = add i64 %r0, 0, !dbg !604
  %r107.p = getelementptr inbounds [13 x i8], ptr @.str.81, i64 0, i64 0, !dbg !604
  %r107 = ptrtoint ptr %r107.p to i64, !dbg !604
  %r108 = call i64 @nova_rt_list_append(i64 %r106, i64 %r107), !dbg !604
  %r109 = add i64 %r0, 0, !dbg !605
  %r110.p = getelementptr inbounds [17 x i8], ptr @.str.139, i64 0, i64 0, !dbg !605
  %r110 = ptrtoint ptr %r110.p to i64, !dbg !605
  %r111 = call i64 @nova_rt_list_append(i64 %r109, i64 %r110), !dbg !605
  %r112 = add i64 %r0, 0, !dbg !606
  %r113.p = getelementptr inbounds [11 x i8], ptr @.str.140, i64 0, i64 0, !dbg !606
  %r113 = ptrtoint ptr %r113.p to i64, !dbg !606
  %r114 = call i64 @nova_rt_list_append(i64 %r112, i64 %r113), !dbg !606
  %r115 = add i64 %r0, 0, !dbg !607
  %r116.p = getelementptr inbounds [11 x i8], ptr @.str.141, i64 0, i64 0, !dbg !607
  %r116 = ptrtoint ptr %r116.p to i64, !dbg !607
  %r117 = call i64 @nova_rt_list_append(i64 %r115, i64 %r116), !dbg !607
  %r118 = add i64 %r0, 0, !dbg !608
  %r119.p = getelementptr inbounds [14 x i8], ptr @.str.83, i64 0, i64 0, !dbg !608
  %r119 = ptrtoint ptr %r119.p to i64, !dbg !608
  %r120 = call i64 @nova_rt_list_append(i64 %r118, i64 %r119), !dbg !608
  %r121 = add i64 %r0, 0, !dbg !609
  %r122.p = getelementptr inbounds [12 x i8], ptr @.str.85, i64 0, i64 0, !dbg !609
  %r122 = ptrtoint ptr %r122.p to i64, !dbg !609
  %r123 = call i64 @nova_rt_list_append(i64 %r121, i64 %r122), !dbg !609
  %r124 = add i64 %r0, 0, !dbg !610
  %r125.p = getelementptr inbounds [11 x i8], ptr @.str.142, i64 0, i64 0, !dbg !610
  %r125 = ptrtoint ptr %r125.p to i64, !dbg !610
  %r126 = call i64 @nova_rt_list_append(i64 %r124, i64 %r125), !dbg !610
  %r127 = add i64 %r0, 0, !dbg !611
  %r128.p = getelementptr inbounds [12 x i8], ptr @.str.89, i64 0, i64 0, !dbg !611
  %r128 = ptrtoint ptr %r128.p to i64, !dbg !611
  %r129 = call i64 @nova_rt_list_append(i64 %r127, i64 %r128), !dbg !611
  %r130 = add i64 %r0, 0, !dbg !612
  %r131.p = getelementptr inbounds [11 x i8], ptr @.str.91, i64 0, i64 0, !dbg !612
  %r131 = ptrtoint ptr %r131.p to i64, !dbg !612
  %r132 = call i64 @nova_rt_list_append(i64 %r130, i64 %r131), !dbg !612
  %r133 = add i64 %r0, 0, !dbg !613
  %r134.p = getelementptr inbounds [3 x i8], ptr @.str.143, i64 0, i64 0, !dbg !613
  %r134 = ptrtoint ptr %r134.p to i64, !dbg !613
  %r135 = call i64 @nova_rt_list_append(i64 %r133, i64 %r134), !dbg !613
  %r136 = add i64 %r0, 0, !dbg !614
  %r137.p = getelementptr inbounds [4 x i8], ptr @.str.144, i64 0, i64 0, !dbg !614
  %r137 = ptrtoint ptr %r137.p to i64, !dbg !614
  %r138 = call i64 @nova_rt_list_append(i64 %r136, i64 %r137), !dbg !614
  %r139 = add i64 %r0, 0, !dbg !615
  %r140.p = getelementptr inbounds [3 x i8], ptr @.str.145, i64 0, i64 0, !dbg !615
  %r140 = ptrtoint ptr %r140.p to i64, !dbg !615
  %r141 = call i64 @nova_rt_list_append(i64 %r139, i64 %r140), !dbg !615
  %r142 = add i64 %r0, 0, !dbg !616
  %r143.p = getelementptr inbounds [5 x i8], ptr @.str.146, i64 0, i64 0, !dbg !616
  %r143 = ptrtoint ptr %r143.p to i64, !dbg !616
  %r144 = call i64 @nova_rt_list_append(i64 %r142, i64 %r143), !dbg !616
  %r145 = add i64 %r0, 0, !dbg !617
  %r146.p = getelementptr inbounds [6 x i8], ptr @.str.147, i64 0, i64 0, !dbg !617
  %r146 = ptrtoint ptr %r146.p to i64, !dbg !617
  %r147 = call i64 @nova_rt_list_append(i64 %r145, i64 %r146), !dbg !617
  %r148 = add i64 %r0, 0, !dbg !618
  %r149.p = getelementptr inbounds [4 x i8], ptr @.str.148, i64 0, i64 0, !dbg !618
  %r149 = ptrtoint ptr %r149.p to i64, !dbg !618
  %r150 = call i64 @nova_rt_list_append(i64 %r148, i64 %r149), !dbg !618
  %r151 = add i64 %r0, 0, !dbg !619
  %r152.p = getelementptr inbounds [7 x i8], ptr @.str.149, i64 0, i64 0, !dbg !619
  %r152 = ptrtoint ptr %r152.p to i64, !dbg !619
  %r153 = call i64 @nova_rt_list_append(i64 %r151, i64 %r152), !dbg !619
  %r154 = add i64 %r0, 0, !dbg !620
  %r155.p = getelementptr inbounds [6 x i8], ptr @.str.150, i64 0, i64 0, !dbg !620
  %r155 = ptrtoint ptr %r155.p to i64, !dbg !620
  %r156 = call i64 @nova_rt_list_append(i64 %r154, i64 %r155), !dbg !620
  %r157 = add i64 %r0, 0, !dbg !621
  ret i64 %r157, !dbg !621
}

define i64 @build_completion_response(i64 %p0) nounwind !dbg !622 {
entry:
  %slot.id = alloca i64, align 8, !dbg !623
  store i64 %p0, ptr %slot.id, align 8, !dbg !623
  %slot.items_json = alloca i64, align 8, !dbg !623
  store i64 0, ptr %slot.items_json, align 8, !dbg !623
  %slot.items = alloca i64, align 8, !dbg !623
  store i64 0, ptr %slot.items, align 8, !dbg !623
  %slot.i = alloca i64, align 8, !dbg !623
  store i64 0, ptr %slot.i, align 8, !dbg !623
  %slot.__for_idx_389 = alloca i64, align 8, !dbg !623
  store i64 0, ptr %slot.__for_idx_389, align 8, !dbg !623
  %slot.n = alloca i64, align 8, !dbg !623
  store i64 0, ptr %slot.n, align 8, !dbg !623
  %slot.doc = alloca i64, align 8, !dbg !623
  store i64 0, ptr %slot.doc, align 8, !dbg !623
  %r0.p = getelementptr inbounds [2 x i8], ptr @.str.35, i64 0, i64 0, !dbg !624
  %r0 = ptrtoint ptr %r0.p to i64, !dbg !624
  store i64 %r0, ptr %slot.items_json, align 8, !dbg !624
  %r1 = call i64 @completion_items(), !dbg !625
  store i64 %r1, ptr %slot.items, align 8, !dbg !625
  %r2 = add i64 0, 0, !dbg !626
  store i64 %r2, ptr %slot.i, align 8, !dbg !626
  %r3 = add i64 %r1, 0, !dbg !627
  %r4 = add i64 %r3, 0, !dbg !627
  %r5.lp = inttoptr i64 %r4 to ptr, !dbg !627
  %r5.szp = getelementptr i64, ptr %r5.lp, i64 1, !dbg !627
  %r5 = load i64, ptr %r5.szp, align 8, !tbaa !6, !dbg !627
  %r6 = add i64 0, 0, !dbg !627
  store i64 %r6, ptr %slot.__for_idx_389, align 8, !dbg !627
  br label %for_hdr389, !dbg !627
for_hdr389:
  %r7 = load i64, ptr %slot.__for_idx_389, align 8, !dbg !627
  %r8.cmp = icmp slt i64 %r7, %r5, !dbg !627
  %r8 = zext i1 %r8.cmp to i64, !dbg !627
  %br_for_body390 = icmp ne i64 %r8, 0, !dbg !627
  br i1 %br_for_body390, label %for_body390, label %for_exit391, !prof !90, !dbg !627
for_body390:
  %r9 = call i64 @nova_rt_index_get(i64 %r4, i64 %r7), !dbg !627
  store i64 %r9, ptr %slot.n, align 8, !dbg !627
  %r10 = load i64, ptr %slot.i, align 8, !dbg !628
  %r11 = add i64 0, 0, !dbg !628
  %r12.cmp = icmp sgt i64 %r10, %r11, !dbg !628
  %r12 = zext i1 %r12.cmp to i64, !dbg !628
  %br_then392 = icmp ne i64 %r12, 0, !dbg !628
  br i1 %br_then392, label %then392, label %else393, !dbg !628
then392:
  %r13 = load i64, ptr %slot.items_json, align 8, !dbg !629
  %r14.p = getelementptr inbounds [2 x i8], ptr @.str.22, i64 0, i64 0, !dbg !629
  %r14 = ptrtoint ptr %r14.p to i64, !dbg !629
  %r15 = call i64 @nova_rt_str_concat(i64 %r13, i64 %r14), !dbg !629
  store i64 %r15, ptr %slot.items_json, align 8, !dbg !629
  br label %endif394, !dbg !629
else393:
  br label %endif394, !dbg !629
endif394:
  %r16 = load i64, ptr %slot.n, align 8, !dbg !630
  %r17 = call i64 @builtin_doc(i64 %r16), !dbg !630
  store i64 %r17, ptr %slot.doc, align 8, !dbg !630
  %r18 = load i64, ptr %slot.items_json, align 8, !dbg !631
  %r19.p = getelementptr inbounds [10 x i8], ptr @.str.151, i64 0, i64 0, !dbg !631
  %r19 = ptrtoint ptr %r19.p to i64, !dbg !631
  %r20 = call i64 @nova_rt_str_concat(i64 %r18, i64 %r19), !dbg !631
  %r21 = load i64, ptr %slot.n, align 8, !dbg !631
  %r22 = call i64 @json_str(i64 %r21), !dbg !631
  %r23 = call i64 @nova_rt_str_concat(i64 %r20, i64 %r22), !dbg !631
  %r24.p = getelementptr inbounds [20 x i8], ptr @.str.152, i64 0, i64 0, !dbg !631
  %r24 = ptrtoint ptr %r24.p to i64, !dbg !631
  %r25 = call i64 @nova_rt_str_concat(i64 %r23, i64 %r24), !dbg !631
  %r26 = add i64 %r17, 0, !dbg !631
  %r27 = call i64 @json_str(i64 %r26), !dbg !631
  %r28 = call i64 @nova_rt_str_concat(i64 %r25, i64 %r27), !dbg !631
  %r29.p = getelementptr inbounds [2 x i8], ptr @.str.17, i64 0, i64 0, !dbg !631
  %r29 = ptrtoint ptr %r29.p to i64, !dbg !631
  %r30 = call i64 @nova_rt_str_concat(i64 %r28, i64 %r29), !dbg !631
  store i64 %r30, ptr %slot.items_json, align 8, !dbg !631
  %r31 = load i64, ptr %slot.i, align 8, !dbg !632
  %r32 = add i64 1, 0, !dbg !632
  %r33 = add i64 %r31, %r32, !dbg !632
  store i64 %r33, ptr %slot.i, align 8, !dbg !632
  %r34 = load i64, ptr %slot.__for_idx_389, align 8, !dbg !632
  %r35 = add i64 1, 0, !dbg !632
  %r36 = add i64 %r34, %r35, !dbg !632
  store i64 %r36, ptr %slot.__for_idx_389, align 8, !dbg !632
  br label %for_hdr389, !dbg !632
for_exit391:
  %r37 = load i64, ptr %slot.items_json, align 8, !dbg !633
  %r38.p = getelementptr inbounds [2 x i8], ptr @.str.23, i64 0, i64 0, !dbg !633
  %r38 = ptrtoint ptr %r38.p to i64, !dbg !633
  %r39 = call i64 @nova_rt_str_concat(i64 %r37, i64 %r38), !dbg !633
  store i64 %r39, ptr %slot.items_json, align 8, !dbg !633
  %r40 = load i64, ptr %slot.id, align 8, !dbg !634
  %r41.p = getelementptr inbounds [31 x i8], ptr @.str.153, i64 0, i64 0, !dbg !634
  %r41 = ptrtoint ptr %r41.p to i64, !dbg !634
  %r42 = add i64 %r39, 0, !dbg !634
  %r43 = call i64 @nova_rt_str_concat(i64 %r41, i64 %r42), !dbg !634
  %r44.p = getelementptr inbounds [2 x i8], ptr @.str.17, i64 0, i64 0, !dbg !634
  %r44 = ptrtoint ptr %r44.p to i64, !dbg !634
  %r45 = call i64 @nova_rt_str_concat(i64 %r43, i64 %r44), !dbg !634
  %r46 = call i64 @build_response(i64 %r40, i64 %r45), !dbg !634
  ret i64 %r46, !dbg !634
}

define i64 @handle_message(i64 %p0, i64 %p1, i64 %p2) nounwind !dbg !635 {
entry:
  %slot.msg = alloca i64, align 8, !dbg !636
  store i64 %p0, ptr %slot.msg, align 8, !dbg !636
  %slot.docs = alloca i64, align 8, !dbg !636
  store i64 %p1, ptr %slot.docs, align 8, !dbg !636
  %slot.compiler = alloca i64, align 8, !dbg !636
  store i64 %p2, ptr %slot.compiler, align 8, !dbg !636
  %slot.method = alloca i64, align 8, !dbg !636
  store i64 0, ptr %slot.method, align 8, !dbg !636
  %slot.id = alloca i64, align 8, !dbg !636
  store i64 0, ptr %slot.id, align 8, !dbg !636
  %slot.__sc_407 = alloca i64, align 8, !dbg !636
  store i64 0, ptr %slot.__sc_407, align 8, !dbg !636
  %slot.uri = alloca i64, align 8, !dbg !636
  store i64 0, ptr %slot.uri, align 8, !dbg !636
  %slot.text = alloca i64, align 8, !dbg !636
  store i64 0, ptr %slot.text, align 8, !dbg !636
  %slot.ds = alloca i64, align 8, !dbg !636
  store i64 0, ptr %slot.ds, align 8, !dbg !636
  %slot.line_no = alloca i64, align 8, !dbg !636
  store i64 0, ptr %slot.line_no, align 8, !dbg !636
  %slot.ch = alloca i64, align 8, !dbg !636
  store i64 0, ptr %slot.ch, align 8, !dbg !636
  %slot.source = alloca i64, align 8, !dbg !636
  store i64 0, ptr %slot.source, align 8, !dbg !636
  %slot.word = alloca i64, align 8, !dbg !636
  store i64 0, ptr %slot.word, align 8, !dbg !636
  %slot.doc = alloca i64, align 8, !dbg !636
  store i64 0, ptr %slot.doc, align 8, !dbg !636
  %slot.loc = alloca i64, align 8, !dbg !636
  store i64 0, ptr %slot.loc, align 8, !dbg !636
  %r0 = load i64, ptr %slot.msg, align 8, !dbg !637
  %r1.p = getelementptr inbounds [7 x i8], ptr @.str.154, i64 0, i64 0, !dbg !637
  %r1 = ptrtoint ptr %r1.p to i64, !dbg !637
  %r2 = call i64 @json_extract_string(i64 %r0, i64 %r1), !dbg !637
  store i64 %r2, ptr %slot.method, align 8, !dbg !637
  %r3 = load i64, ptr %slot.msg, align 8, !dbg !638
  %r4.p = getelementptr inbounds [3 x i8], ptr @.str.155, i64 0, i64 0, !dbg !638
  %r4 = ptrtoint ptr %r4.p to i64, !dbg !638
  %r5 = call i64 @json_extract_int(i64 %r3, i64 %r4), !dbg !638
  store i64 %r5, ptr %slot.id, align 8, !dbg !638
  %r6.p = getelementptr inbounds [19 x i8], ptr @.str.156, i64 0, i64 0, !dbg !639
  %r6 = ptrtoint ptr %r6.p to i64, !dbg !639
  %r7 = add i64 %r2, 0, !dbg !639
  %r8 = call i64 @nova_rt_str_concat(i64 %r6, i64 %r7), !dbg !639
  %r9.p = getelementptr inbounds [5 x i8], ptr @.str.157, i64 0, i64 0, !dbg !639
  %r9 = ptrtoint ptr %r9.p to i64, !dbg !639
  %r10 = call i64 @nova_rt_str_concat(i64 %r8, i64 %r9), !dbg !639
  %r11 = add i64 %r5, 0, !dbg !639
  %r12 = call i64 @nova_rt_int_to_str(i64 %r11), !dbg !639
  %r13 = call i64 @nova_rt_str_concat(i64 %r10, i64 %r12), !dbg !639
  %r14 = call i64 @log_msg(i64 %r13), !dbg !639
  %r15 = add i64 %r2, 0, !dbg !640
  %r16.p = getelementptr inbounds [11 x i8], ptr @.str.158, i64 0, i64 0, !dbg !640
  %r16 = ptrtoint ptr %r16.p to i64, !dbg !640
  %r17.p0 = inttoptr i64 %r15 to ptr, !dbg !640
  %r17.p1 = inttoptr i64 %r16 to ptr, !dbg !640
  %r17.sc = call i32 @strcmp(ptr %r17.p0, ptr %r17.p1), !dbg !640
  %r17.cmp = icmp eq i32 %r17.sc, 0, !dbg !640
  %r17 = zext i1 %r17.cmp to i64, !dbg !640
  %br_then395 = icmp ne i64 %r17, 0, !dbg !640
  br i1 %br_then395, label %then395, label %else396, !dbg !640
then395:
  %r18 = load i64, ptr %slot.id, align 8, !dbg !641
  %r19 = call i64 @server_capabilities(), !dbg !641
  %r20 = call i64 @build_response(i64 %r18, i64 %r19), !dbg !641
  %r21 = call i64 @send_message(i64 %r20), !dbg !641
  %r22 = add i64 0, 0, !dbg !642
  ret i64 %r22, !dbg !642
else396:
  br label %endif397, !dbg !642
endif397:
  %r23 = load i64, ptr %slot.method, align 8, !dbg !643
  %r24.p = getelementptr inbounds [12 x i8], ptr @.str.159, i64 0, i64 0, !dbg !643
  %r24 = ptrtoint ptr %r24.p to i64, !dbg !643
  %r25.p0 = inttoptr i64 %r23 to ptr, !dbg !643
  %r25.p1 = inttoptr i64 %r24 to ptr, !dbg !643
  %r25.sc = call i32 @strcmp(ptr %r25.p0, ptr %r25.p1), !dbg !643
  %r25.cmp = icmp eq i32 %r25.sc, 0, !dbg !643
  %r25 = zext i1 %r25.cmp to i64, !dbg !643
  %br_then398 = icmp ne i64 %r25, 0, !dbg !643
  br i1 %br_then398, label %then398, label %else399, !dbg !643
then398:
  %r26 = add i64 0, 0, !dbg !644
  ret i64 %r26, !dbg !644
else399:
  br label %endif400, !dbg !644
endif400:
  %r27 = load i64, ptr %slot.method, align 8, !dbg !645
  %r28.p = getelementptr inbounds [9 x i8], ptr @.str.160, i64 0, i64 0, !dbg !645
  %r28 = ptrtoint ptr %r28.p to i64, !dbg !645
  %r29.p0 = inttoptr i64 %r27 to ptr, !dbg !645
  %r29.p1 = inttoptr i64 %r28 to ptr, !dbg !645
  %r29.sc = call i32 @strcmp(ptr %r29.p0, ptr %r29.p1), !dbg !645
  %r29.cmp = icmp eq i32 %r29.sc, 0, !dbg !645
  %r29 = zext i1 %r29.cmp to i64, !dbg !645
  %br_then401 = icmp ne i64 %r29, 0, !dbg !645
  br i1 %br_then401, label %then401, label %else402, !dbg !645
then401:
  %r30 = load i64, ptr %slot.id, align 8, !dbg !646
  %r31.p = getelementptr inbounds [5 x i8], ptr @.str.99, i64 0, i64 0, !dbg !646
  %r31 = ptrtoint ptr %r31.p to i64, !dbg !646
  %r32 = call i64 @build_response(i64 %r30, i64 %r31), !dbg !646
  %r33 = call i64 @send_message(i64 %r32), !dbg !646
  %r34 = add i64 0, 0, !dbg !647
  ret i64 %r34, !dbg !647
else402:
  br label %endif403, !dbg !647
endif403:
  %r35 = load i64, ptr %slot.method, align 8, !dbg !648
  %r36.p = getelementptr inbounds [5 x i8], ptr @.str.118, i64 0, i64 0, !dbg !648
  %r36 = ptrtoint ptr %r36.p to i64, !dbg !648
  %r37.p0 = inttoptr i64 %r35 to ptr, !dbg !648
  %r37.p1 = inttoptr i64 %r36 to ptr, !dbg !648
  %r37.sc = call i32 @strcmp(ptr %r37.p0, ptr %r37.p1), !dbg !648
  %r37.cmp = icmp eq i32 %r37.sc, 0, !dbg !648
  %r37 = zext i1 %r37.cmp to i64, !dbg !648
  %br_then404 = icmp ne i64 %r37, 0, !dbg !648
  br i1 %br_then404, label %then404, label %else405, !dbg !648
then404:
  %r38 = add i64 1, 0, !dbg !649
  ret i64 %r38, !dbg !649
else405:
  br label %endif406, !dbg !649
endif406:
  %r39 = load i64, ptr %slot.method, align 8, !dbg !650
  %r40.p = getelementptr inbounds [21 x i8], ptr @.str.161, i64 0, i64 0, !dbg !650
  %r40 = ptrtoint ptr %r40.p to i64, !dbg !650
  %r41.p0 = inttoptr i64 %r39 to ptr, !dbg !650
  %r41.p1 = inttoptr i64 %r40 to ptr, !dbg !650
  %r41.sc = call i32 @strcmp(ptr %r41.p0, ptr %r41.p1), !dbg !650
  %r41.cmp = icmp eq i32 %r41.sc, 0, !dbg !650
  %r41 = zext i1 %r41.cmp to i64, !dbg !650
  store i64 %r41, ptr %slot.__sc_407, align 8, !dbg !650
  %br_or_merge409 = icmp ne i64 %r41, 0, !dbg !650
  br i1 %br_or_merge409, label %or_merge409, label %or_rhs408, !dbg !650
or_rhs408:
  %r42 = load i64, ptr %slot.method, align 8, !dbg !650
  %r43.p = getelementptr inbounds [23 x i8], ptr @.str.162, i64 0, i64 0, !dbg !650
  %r43 = ptrtoint ptr %r43.p to i64, !dbg !650
  %r44.p0 = inttoptr i64 %r42 to ptr, !dbg !650
  %r44.p1 = inttoptr i64 %r43 to ptr, !dbg !650
  %r44.sc = call i32 @strcmp(ptr %r44.p0, ptr %r44.p1), !dbg !650
  %r44.cmp = icmp eq i32 %r44.sc, 0, !dbg !650
  %r44 = zext i1 %r44.cmp to i64, !dbg !650
  store i64 %r44, ptr %slot.__sc_407, align 8, !dbg !650
  br label %or_merge409, !dbg !650
or_merge409:
  %r45 = load i64, ptr %slot.__sc_407, align 8, !dbg !650
  %br_then410 = icmp ne i64 %r45, 0, !dbg !650
  br i1 %br_then410, label %then410, label %else411, !dbg !650
then410:
  %r46 = load i64, ptr %slot.msg, align 8, !dbg !651
  %r47.p = getelementptr inbounds [4 x i8], ptr @.str.163, i64 0, i64 0, !dbg !651
  %r47 = ptrtoint ptr %r47.p to i64, !dbg !651
  %r48 = call i64 @json_extract_string(i64 %r46, i64 %r47), !dbg !651
  store i64 %r48, ptr %slot.uri, align 8, !dbg !651
  %r49 = load i64, ptr %slot.msg, align 8, !dbg !652
  %r50.p = getelementptr inbounds [5 x i8], ptr @.str.164, i64 0, i64 0, !dbg !652
  %r50 = ptrtoint ptr %r50.p to i64, !dbg !652
  %r51 = call i64 @json_extract_string(i64 %r49, i64 %r50), !dbg !652
  store i64 %r51, ptr %slot.text, align 8, !dbg !652
  %r52 = add i64 %r51, 0, !dbg !653
  %r53 = call i64 @nova_rt_len_any(i64 %r52), !dbg !653
  %r54 = add i64 0, 0, !dbg !653
  %r55.cmp = icmp sgt i64 %r53, %r54, !dbg !653
  %r55 = zext i1 %r55.cmp to i64, !dbg !653
  %br_then413 = icmp ne i64 %r55, 0, !dbg !653
  br i1 %br_then413, label %then413, label %else414, !dbg !653
then413:
  %r56 = load i64, ptr %slot.docs, align 8, !dbg !654
  %r57 = load i64, ptr %slot.uri, align 8, !dbg !654
  %r58 = load i64, ptr %slot.text, align 8, !dbg !654
  %r59 = call i64 @document_set(i64 %r56, i64 %r57, i64 %r58), !dbg !654
  %r60 = load i64, ptr %slot.uri, align 8, !dbg !655
  %r61 = load i64, ptr %slot.text, align 8, !dbg !655
  %r62 = load i64, ptr %slot.compiler, align 8, !dbg !655
  %r63 = call i64 @run_compile_for_uri(i64 %r60, i64 %r61, i64 %r62), !dbg !655
  store i64 %r63, ptr %slot.ds, align 8, !dbg !655
  %r64 = load i64, ptr %slot.uri, align 8, !dbg !656
  %r65 = add i64 %r63, 0, !dbg !656
  %r66 = call i64 @publish_diagnostics(i64 %r64, i64 %r65), !dbg !656
  br label %endif415, !dbg !656
else414:
  br label %endif415, !dbg !656
endif415:
  %r67 = add i64 0, 0, !dbg !657
  ret i64 %r67, !dbg !657
else411:
  br label %endif412, !dbg !657
endif412:
  %r68 = load i64, ptr %slot.method, align 8, !dbg !658
  %r69.p = getelementptr inbounds [22 x i8], ptr @.str.165, i64 0, i64 0, !dbg !658
  %r69 = ptrtoint ptr %r69.p to i64, !dbg !658
  %r70.p0 = inttoptr i64 %r68 to ptr, !dbg !658
  %r70.p1 = inttoptr i64 %r69 to ptr, !dbg !658
  %r70.sc = call i32 @strcmp(ptr %r70.p0, ptr %r70.p1), !dbg !658
  %r70.cmp = icmp eq i32 %r70.sc, 0, !dbg !658
  %r70 = zext i1 %r70.cmp to i64, !dbg !658
  %br_then416 = icmp ne i64 %r70, 0, !dbg !658
  br i1 %br_then416, label %then416, label %else417, !dbg !658
then416:
  %r71 = load i64, ptr %slot.msg, align 8, !dbg !659
  %r72.p = getelementptr inbounds [4 x i8], ptr @.str.163, i64 0, i64 0, !dbg !659
  %r72 = ptrtoint ptr %r72.p to i64, !dbg !659
  %r73 = call i64 @json_extract_string(i64 %r71, i64 %r72), !dbg !659
  store i64 %r73, ptr %slot.uri, align 8, !dbg !659
  %r74 = load i64, ptr %slot.docs, align 8, !dbg !660
  %r75 = add i64 %r73, 0, !dbg !660
  %r76.p = getelementptr inbounds [1 x i8], ptr @.str.7, i64 0, i64 0, !dbg !660
  %r76 = ptrtoint ptr %r76.p to i64, !dbg !660
  %r77 = call i64 @document_set(i64 %r74, i64 %r75, i64 %r76), !dbg !660
  %r78 = add i64 0, 0, !dbg !661
  ret i64 %r78, !dbg !661
else417:
  br label %endif418, !dbg !661
endif418:
  %r79 = load i64, ptr %slot.method, align 8, !dbg !662
  %r80.p = getelementptr inbounds [19 x i8], ptr @.str.166, i64 0, i64 0, !dbg !662
  %r80 = ptrtoint ptr %r80.p to i64, !dbg !662
  %r81.p0 = inttoptr i64 %r79 to ptr, !dbg !662
  %r81.p1 = inttoptr i64 %r80 to ptr, !dbg !662
  %r81.sc = call i32 @strcmp(ptr %r81.p0, ptr %r81.p1), !dbg !662
  %r81.cmp = icmp eq i32 %r81.sc, 0, !dbg !662
  %r81 = zext i1 %r81.cmp to i64, !dbg !662
  %br_then419 = icmp ne i64 %r81, 0, !dbg !662
  br i1 %br_then419, label %then419, label %else420, !dbg !662
then419:
  %r82 = load i64, ptr %slot.msg, align 8, !dbg !663
  %r83.p = getelementptr inbounds [4 x i8], ptr @.str.163, i64 0, i64 0, !dbg !663
  %r83 = ptrtoint ptr %r83.p to i64, !dbg !663
  %r84 = call i64 @json_extract_string(i64 %r82, i64 %r83), !dbg !663
  store i64 %r84, ptr %slot.uri, align 8, !dbg !663
  %r85 = load i64, ptr %slot.msg, align 8, !dbg !664
  %r86.p = getelementptr inbounds [5 x i8], ptr @.str.105, i64 0, i64 0, !dbg !664
  %r86 = ptrtoint ptr %r86.p to i64, !dbg !664
  %r87 = call i64 @json_extract_int(i64 %r85, i64 %r86), !dbg !664
  store i64 %r87, ptr %slot.line_no, align 8, !dbg !664
  %r88 = load i64, ptr %slot.msg, align 8, !dbg !665
  %r89.p = getelementptr inbounds [10 x i8], ptr @.str.167, i64 0, i64 0, !dbg !665
  %r89 = ptrtoint ptr %r89.p to i64, !dbg !665
  %r90 = call i64 @json_extract_int(i64 %r88, i64 %r89), !dbg !665
  store i64 %r90, ptr %slot.ch, align 8, !dbg !665
  %r91 = load i64, ptr %slot.docs, align 8, !dbg !666
  %r92 = add i64 %r84, 0, !dbg !666
  %r93 = call i64 @document_get(i64 %r91, i64 %r92), !dbg !666
  store i64 %r93, ptr %slot.source, align 8, !dbg !666
  %r94 = add i64 %r93, 0, !dbg !667
  %r95 = call i64 @nova_rt_len_any(i64 %r94), !dbg !667
  %r96 = add i64 0, 0, !dbg !667
  %r97.cmp = icmp eq i64 %r95, %r96, !dbg !667
  %r97 = zext i1 %r97.cmp to i64, !dbg !667
  %br_then422 = icmp ne i64 %r97, 0, !dbg !667
  br i1 %br_then422, label %then422, label %else423, !dbg !667
then422:
  %r98 = load i64, ptr %slot.id, align 8, !dbg !668
  %r99.p = getelementptr inbounds [1 x i8], ptr @.str.7, i64 0, i64 0, !dbg !668
  %r99 = ptrtoint ptr %r99.p to i64, !dbg !668
  %r100 = call i64 @build_hover_response(i64 %r98, i64 %r99), !dbg !668
  %r101 = call i64 @send_message(i64 %r100), !dbg !668
  %r102 = add i64 0, 0, !dbg !669
  ret i64 %r102, !dbg !669
else423:
  br label %endif424, !dbg !669
endif424:
  %r103 = load i64, ptr %slot.source, align 8, !dbg !670
  %r104 = load i64, ptr %slot.line_no, align 8, !dbg !670
  %r105 = load i64, ptr %slot.ch, align 8, !dbg !670
  %r106 = call i64 @word_at_position(i64 %r103, i64 %r104, i64 %r105), !dbg !670
  store i64 %r106, ptr %slot.word, align 8, !dbg !670
  %r107.p = getelementptr inbounds [23 x i8], ptr @.str.168, i64 0, i64 0, !dbg !671
  %r107 = ptrtoint ptr %r107.p to i64, !dbg !671
  %r108 = add i64 %r106, 0, !dbg !671
  %r109 = call i64 @nova_rt_str_concat(i64 %r107, i64 %r108), !dbg !671
  %r110 = call i64 @log_msg(i64 %r109), !dbg !671
  %r111 = add i64 %r106, 0, !dbg !672
  %r112 = call i64 @builtin_doc(i64 %r111), !dbg !672
  store i64 %r112, ptr %slot.doc, align 8, !dbg !672
  %r113 = add i64 %r112, 0, !dbg !673
  %r114 = call i64 @nova_rt_len_any(i64 %r113), !dbg !673
  %r115 = add i64 0, 0, !dbg !673
  %r116.cmp = icmp eq i64 %r114, %r115, !dbg !673
  %r116 = zext i1 %r116.cmp to i64, !dbg !673
  %br_then425 = icmp ne i64 %r116, 0, !dbg !673
  br i1 %br_then425, label %then425, label %else426, !dbg !673
then425:
  %r117 = load i64, ptr %slot.source, align 8, !dbg !674
  %r118 = load i64, ptr %slot.word, align 8, !dbg !674
  %r119 = call i64 @user_symbol_doc(i64 %r117, i64 %r118), !dbg !674
  store i64 %r119, ptr %slot.doc, align 8, !dbg !674
  br label %endif427, !dbg !674
else426:
  br label %endif427, !dbg !674
endif427:
  %r120 = load i64, ptr %slot.id, align 8, !dbg !675
  %r121 = load i64, ptr %slot.doc, align 8, !dbg !675
  %r122 = call i64 @build_hover_response(i64 %r120, i64 %r121), !dbg !675
  %r123 = call i64 @send_message(i64 %r122), !dbg !675
  %r124 = add i64 0, 0, !dbg !676
  ret i64 %r124, !dbg !676
else420:
  br label %endif421, !dbg !676
endif421:
  %r125 = load i64, ptr %slot.method, align 8, !dbg !677
  %r126.p = getelementptr inbounds [24 x i8], ptr @.str.169, i64 0, i64 0, !dbg !677
  %r126 = ptrtoint ptr %r126.p to i64, !dbg !677
  %r127.p0 = inttoptr i64 %r125 to ptr, !dbg !677
  %r127.p1 = inttoptr i64 %r126 to ptr, !dbg !677
  %r127.sc = call i32 @strcmp(ptr %r127.p0, ptr %r127.p1), !dbg !677
  %r127.cmp = icmp eq i32 %r127.sc, 0, !dbg !677
  %r127 = zext i1 %r127.cmp to i64, !dbg !677
  %br_then428 = icmp ne i64 %r127, 0, !dbg !677
  br i1 %br_then428, label %then428, label %else429, !dbg !677
then428:
  %r128 = load i64, ptr %slot.msg, align 8, !dbg !678
  %r129.p = getelementptr inbounds [4 x i8], ptr @.str.163, i64 0, i64 0, !dbg !678
  %r129 = ptrtoint ptr %r129.p to i64, !dbg !678
  %r130 = call i64 @json_extract_string(i64 %r128, i64 %r129), !dbg !678
  store i64 %r130, ptr %slot.uri, align 8, !dbg !678
  %r131 = load i64, ptr %slot.msg, align 8, !dbg !679
  %r132.p = getelementptr inbounds [5 x i8], ptr @.str.105, i64 0, i64 0, !dbg !679
  %r132 = ptrtoint ptr %r132.p to i64, !dbg !679
  %r133 = call i64 @json_extract_int(i64 %r131, i64 %r132), !dbg !679
  store i64 %r133, ptr %slot.line_no, align 8, !dbg !679
  %r134 = load i64, ptr %slot.msg, align 8, !dbg !680
  %r135.p = getelementptr inbounds [10 x i8], ptr @.str.167, i64 0, i64 0, !dbg !680
  %r135 = ptrtoint ptr %r135.p to i64, !dbg !680
  %r136 = call i64 @json_extract_int(i64 %r134, i64 %r135), !dbg !680
  store i64 %r136, ptr %slot.ch, align 8, !dbg !680
  %r137 = load i64, ptr %slot.docs, align 8, !dbg !681
  %r138 = add i64 %r130, 0, !dbg !681
  %r139 = call i64 @document_get(i64 %r137, i64 %r138), !dbg !681
  store i64 %r139, ptr %slot.source, align 8, !dbg !681
  %r140 = add i64 %r139, 0, !dbg !682
  %r141 = call i64 @nova_rt_len_any(i64 %r140), !dbg !682
  %r142 = add i64 0, 0, !dbg !682
  %r143.cmp = icmp eq i64 %r141, %r142, !dbg !682
  %r143 = zext i1 %r143.cmp to i64, !dbg !682
  %br_then431 = icmp ne i64 %r143, 0, !dbg !682
  br i1 %br_then431, label %then431, label %else432, !dbg !682
then431:
  %r144 = load i64, ptr %slot.id, align 8, !dbg !683
  %r145 = load i64, ptr %slot.uri, align 8, !dbg !683
  %r146.p = getelementptr inbounds [1 x i8], ptr @.str.7, i64 0, i64 0, !dbg !683
  %r146 = ptrtoint ptr %r146.p to i64, !dbg !683
  %r147.p = getelementptr inbounds [1 x i8], ptr @.str.7, i64 0, i64 0, !dbg !683
  %r147 = ptrtoint ptr %r147.p to i64, !dbg !683
  %r148 = call i64 @find_definition_location(i64 %r146, i64 %r147), !dbg !683
  %r149 = call i64 @build_definition_response(i64 %r144, i64 %r145, i64 %r148), !dbg !683
  %r150 = call i64 @send_message(i64 %r149), !dbg !683
  %r151 = add i64 0, 0, !dbg !684
  ret i64 %r151, !dbg !684
else432:
  br label %endif433, !dbg !684
endif433:
  %r152 = load i64, ptr %slot.source, align 8, !dbg !685
  %r153 = load i64, ptr %slot.line_no, align 8, !dbg !685
  %r154 = load i64, ptr %slot.ch, align 8, !dbg !685
  %r155 = call i64 @word_at_position(i64 %r152, i64 %r153, i64 %r154), !dbg !685
  store i64 %r155, ptr %slot.word, align 8, !dbg !685
  %r156.p = getelementptr inbounds [28 x i8], ptr @.str.170, i64 0, i64 0, !dbg !686
  %r156 = ptrtoint ptr %r156.p to i64, !dbg !686
  %r157 = add i64 %r155, 0, !dbg !686
  %r158 = call i64 @nova_rt_str_concat(i64 %r156, i64 %r157), !dbg !686
  %r159 = call i64 @log_msg(i64 %r158), !dbg !686
  %r160 = load i64, ptr %slot.source, align 8, !dbg !687
  %r161 = add i64 %r155, 0, !dbg !687
  %r162 = call i64 @find_definition_location(i64 %r160, i64 %r161), !dbg !687
  store i64 %r162, ptr %slot.loc, align 8, !dbg !687
  %r163 = load i64, ptr %slot.id, align 8, !dbg !688
  %r164 = load i64, ptr %slot.uri, align 8, !dbg !688
  %r165 = add i64 %r162, 0, !dbg !688
  %r166 = call i64 @build_definition_response(i64 %r163, i64 %r164, i64 %r165), !dbg !688
  %r167 = call i64 @send_message(i64 %r166), !dbg !688
  %r168 = add i64 0, 0, !dbg !689
  ret i64 %r168, !dbg !689
else429:
  br label %endif430, !dbg !689
endif430:
  %r169 = load i64, ptr %slot.method, align 8, !dbg !690
  %r170.p = getelementptr inbounds [24 x i8], ptr @.str.171, i64 0, i64 0, !dbg !690
  %r170 = ptrtoint ptr %r170.p to i64, !dbg !690
  %r171.p0 = inttoptr i64 %r169 to ptr, !dbg !690
  %r171.p1 = inttoptr i64 %r170 to ptr, !dbg !690
  %r171.sc = call i32 @strcmp(ptr %r171.p0, ptr %r171.p1), !dbg !690
  %r171.cmp = icmp eq i32 %r171.sc, 0, !dbg !690
  %r171 = zext i1 %r171.cmp to i64, !dbg !690
  %br_then434 = icmp ne i64 %r171, 0, !dbg !690
  br i1 %br_then434, label %then434, label %else435, !dbg !690
then434:
  %r172 = load i64, ptr %slot.id, align 8, !dbg !691
  %r173 = call i64 @build_completion_response(i64 %r172), !dbg !691
  %r174 = call i64 @send_message(i64 %r173), !dbg !691
  %r175 = add i64 0, 0, !dbg !692
  ret i64 %r175, !dbg !692
else435:
  br label %endif436, !dbg !692
endif436:
  %r176 = load i64, ptr %slot.method, align 8, !dbg !693
  %r177.p = getelementptr inbounds [24 x i8], ptr @.str.172, i64 0, i64 0, !dbg !693
  %r177 = ptrtoint ptr %r177.p to i64, !dbg !693
  %r178.p0 = inttoptr i64 %r176 to ptr, !dbg !693
  %r178.p1 = inttoptr i64 %r177 to ptr, !dbg !693
  %r178.sc = call i32 @strcmp(ptr %r178.p0, ptr %r178.p1), !dbg !693
  %r178.cmp = icmp eq i32 %r178.sc, 0, !dbg !693
  %r178 = zext i1 %r178.cmp to i64, !dbg !693
  %br_then437 = icmp ne i64 %r178, 0, !dbg !693
  br i1 %br_then437, label %then437, label %else438, !dbg !693
then437:
  %r179 = load i64, ptr %slot.msg, align 8, !dbg !694
  %r180.p = getelementptr inbounds [4 x i8], ptr @.str.163, i64 0, i64 0, !dbg !694
  %r180 = ptrtoint ptr %r180.p to i64, !dbg !694
  %r181 = call i64 @json_extract_string(i64 %r179, i64 %r180), !dbg !694
  store i64 %r181, ptr %slot.uri, align 8, !dbg !694
  %r182 = load i64, ptr %slot.id, align 8, !dbg !695
  %r183.p = getelementptr inbounds [27 x i8], ptr @.str.173, i64 0, i64 0, !dbg !695
  %r183 = ptrtoint ptr %r183.p to i64, !dbg !695
  %r184 = call i64 @build_response(i64 %r182, i64 %r183), !dbg !695
  %r185 = call i64 @send_message(i64 %r184), !dbg !695
  %r186 = add i64 0, 0, !dbg !696
  ret i64 %r186, !dbg !696
else438:
  br label %endif439, !dbg !696
endif439:
  %r187 = add i64 0, 0, !dbg !697
  ret i64 %r187, !dbg !697
}

define i64 @nova_user_main() nounwind !dbg !698 {
entry:
  %slot.compiler = alloca i64, align 8, !dbg !699
  store i64 0, ptr %slot.compiler, align 8, !dbg !699
  %slot.a = alloca i64, align 8, !dbg !699
  store i64 0, ptr %slot.a, align 8, !dbg !699
  %slot.docs = alloca i64, align 8, !dbg !699
  store i64 0, ptr %slot.docs, align 8, !dbg !699
  %slot.running = alloca i64, align 8, !dbg !699
  store i64 0, ptr %slot.running, align 8, !dbg !699
  %slot.msg = alloca i64, align 8, !dbg !699
  store i64 0, ptr %slot.msg, align 8, !dbg !699
  %slot.should_exit = alloca i64, align 8, !dbg !699
  store i64 0, ptr %slot.should_exit, align 8, !dbg !699
  %r0.p = getelementptr inbounds [30 x i8], ptr @.str.174, i64 0, i64 0, !dbg !700
  %r0 = ptrtoint ptr %r0.p to i64, !dbg !700
  %r1 = call i64 @log_msg(i64 %r0), !dbg !700
  %r2.p = getelementptr inbounds [16 x i8], ptr @.str.175, i64 0, i64 0, !dbg !701
  %r2 = ptrtoint ptr %r2.p to i64, !dbg !701
  store i64 %r2, ptr %slot.compiler, align 8, !dbg !701
  %r3 = call i64 @nova_rt_args(), !dbg !702
  store i64 %r3, ptr %slot.a, align 8, !dbg !702
  %r4 = add i64 %r3, 0, !dbg !703
  %r5.lp = inttoptr i64 %r4 to ptr, !dbg !703
  %r5.szp = getelementptr i64, ptr %r5.lp, i64 1, !dbg !703
  %r5 = load i64, ptr %r5.szp, align 8, !tbaa !6, !dbg !703
  %r6 = add i64 1, 0, !dbg !703
  %r7.cmp = icmp sgt i64 %r5, %r6, !dbg !703
  %r7 = zext i1 %r7.cmp to i64, !dbg !703
  %br_then440 = icmp ne i64 %r7, 0, !dbg !703
  br i1 %br_then440, label %then440, label %else441, !dbg !703
then440:
  %r8 = load i64, ptr %slot.a, align 8, !dbg !704
  %r9 = add i64 1, 0, !dbg !704
  %r10 = call i64 @nova_rt_index_get(i64 %r8, i64 %r9), !dbg !704
  store i64 %r10, ptr %slot.compiler, align 8, !dbg !704
  br label %endif442, !dbg !704
else441:
  br label %endif442, !dbg !704
endif442:
  %r11.p = getelementptr inbounds [22 x i8], ptr @.str.176, i64 0, i64 0, !dbg !705
  %r11 = ptrtoint ptr %r11.p to i64, !dbg !705
  %r12 = load i64, ptr %slot.compiler, align 8, !dbg !705
  %r13 = call i64 @nova_rt_str_concat(i64 %r11, i64 %r12), !dbg !705
  %r14 = call i64 @log_msg(i64 %r13), !dbg !705
  %r15 = call i64 @nova_rt_dict_create(), !dbg !706
  store i64 %r15, ptr %slot.docs, align 8, !dbg !706
  %r16 = add i64 1, 0, !dbg !707
  store i64 %r16, ptr %slot.running, align 8, !dbg !707
  br label %while_hdr443, !dbg !708
while_hdr443:
  %r17 = load i64, ptr %slot.running, align 8, !dbg !708
  %r18 = add i64 1, 0, !dbg !708
  %r19.cmp = icmp eq i64 %r17, %r18, !dbg !708
  %r19 = zext i1 %r19.cmp to i64, !dbg !708
  %br_while_body444 = icmp ne i64 %r19, 0, !dbg !708
  br i1 %br_while_body444, label %while_body444, label %while_exit445, !prof !90, !dbg !708
while_body444:
  %r20 = call i64 @read_message(), !dbg !709
  store i64 %r20, ptr %slot.msg, align 8, !dbg !709
  %r21 = add i64 %r20, 0, !dbg !710
  %r22 = call i64 @nova_rt_len_any(i64 %r21), !dbg !710
  %r23 = add i64 0, 0, !dbg !710
  %r24.cmp = icmp eq i64 %r22, %r23, !dbg !710
  %r24 = zext i1 %r24.cmp to i64, !dbg !710
  %br_then446 = icmp ne i64 %r24, 0, !dbg !710
  br i1 %br_then446, label %then446, label %else447, !dbg !710
then446:
  %r25.p = getelementptr inbounds [24 x i8], ptr @.str.177, i64 0, i64 0, !dbg !711
  %r25 = ptrtoint ptr %r25.p to i64, !dbg !711
  %r26 = call i64 @log_msg(i64 %r25), !dbg !711
  %r27 = add i64 0, 0, !dbg !712
  store i64 %r27, ptr %slot.running, align 8, !dbg !712
  br label %endif448, !dbg !712
else447:
  %r28 = load i64, ptr %slot.msg, align 8, !dbg !713
  %r29 = load i64, ptr %slot.docs, align 8, !dbg !713
  %r30 = load i64, ptr %slot.compiler, align 8, !dbg !713
  %r31 = call i64 @handle_message(i64 %r28, i64 %r29, i64 %r30), !dbg !713
  store i64 %r31, ptr %slot.should_exit, align 8, !dbg !713
  %r32 = add i64 %r31, 0, !dbg !714
  %r33 = add i64 1, 0, !dbg !714
  %r34.cmp = icmp eq i64 %r32, %r33, !dbg !714
  %r34 = zext i1 %r34.cmp to i64, !dbg !714
  %br_then449 = icmp ne i64 %r34, 0, !dbg !714
  br i1 %br_then449, label %then449, label %else450, !dbg !714
then449:
  %r35.p = getelementptr inbounds [26 x i8], ptr @.str.178, i64 0, i64 0, !dbg !715
  %r35 = ptrtoint ptr %r35.p to i64, !dbg !715
  %r36 = call i64 @log_msg(i64 %r35), !dbg !715
  %r37 = add i64 0, 0, !dbg !716
  store i64 %r37, ptr %slot.running, align 8, !dbg !716
  br label %endif451, !dbg !716
else450:
  br label %endif451, !dbg !716
endif451:
  br label %endif448, !dbg !716
endif448:
  br label %while_hdr443, !dbg !716
while_exit445:
  %r38.p = getelementptr inbounds [26 x i8], ptr @.str.179, i64 0, i64 0, !dbg !717
  %r38 = ptrtoint ptr %r38.p to i64, !dbg !717
  %r39 = call i64 @log_msg(i64 %r38), !dbg !717
  ret i64 %r39, !dbg !717
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
@.str.0 = private unnamed_addr constant [2 x i8] c"\0A\00"
@.str.1 = private unnamed_addr constant [2 x i8] c"\\\00"
@.str.2 = private unnamed_addr constant [3 x i8] c"\\\\\00"
@.str.3 = private unnamed_addr constant [3 x i8] c"\\n\00"
@.str.4 = private unnamed_addr constant [3 x i8] c"\\r\00"
@.str.5 = private unnamed_addr constant [3 x i8] c"\\t\00"
@.str.6 = private unnamed_addr constant [5 x i8] c"\\u00\00"
@.str.7 = private unnamed_addr constant [1 x i8] c"\00"
@.str.8 = private unnamed_addr constant [2 x i8] c"\0D\00"
@.str.9 = private unnamed_addr constant [16 x i8] c"content-length:\00"
@.str.10 = private unnamed_addr constant [2 x i8] c":\00"
@.str.11 = private unnamed_addr constant [29 x i8] c"[nova-lsp] send_message len=\00"
@.str.12 = private unnamed_addr constant [17 x i8] c"Content-Length: \00"
@.str.13 = private unnamed_addr constant [5 x i8] c"\0D\0A\0D\0A\00"
@.str.14 = private unnamed_addr constant [29 x i8] c"[nova-lsp] send_message done\00"
@.str.15 = private unnamed_addr constant [23 x i8] c"{\22jsonrpc\22:\222.0\22,\22id\22:\00"
@.str.16 = private unnamed_addr constant [11 x i8] c",\22result\22:\00"
@.str.17 = private unnamed_addr constant [2 x i8] c"}\00"
@.str.18 = private unnamed_addr constant [27 x i8] c"{\22jsonrpc\22:\222.0\22,\22method\22:\00"
@.str.19 = private unnamed_addr constant [11 x i8] c",\22params\22:\00"
@.str.20 = private unnamed_addr constant [2 x i8] c" \00"
@.str.21 = private unnamed_addr constant [2 x i8] c"\09\00"
@.str.22 = private unnamed_addr constant [2 x i8] c",\00"
@.str.23 = private unnamed_addr constant [2 x i8] c"]\00"
@.str.24 = private unnamed_addr constant [2 x i8] c"n\00"
@.str.25 = private unnamed_addr constant [2 x i8] c"r\00"
@.str.26 = private unnamed_addr constant [2 x i8] c"t\00"
@.str.27 = private unnamed_addr constant [7 x i8] c"error[\00"
@.str.28 = private unnamed_addr constant [3 x i8] c"]:\00"
@.str.29 = private unnamed_addr constant [5 x i8] c"--> \00"
@.str.30 = private unnamed_addr constant [19 x i8] c"__lsp_check__.nova\00"
@.str.31 = private unnamed_addr constant [27 x i8] c"{\22range\22:{\22start\22:{\22line\22:\00"
@.str.32 = private unnamed_addr constant [31 x i8] c",\22character\22:0},\22end\22:{\22line\22:\00"
@.str.33 = private unnamed_addr constant [31 x i8] c",\22character\22:120}},\22severity\22:\00"
@.str.34 = private unnamed_addr constant [28 x i8] c",\22source\22:\22nova\22,\22message\22:\00"
@.str.35 = private unnamed_addr constant [2 x i8] c"[\00"
@.str.36 = private unnamed_addr constant [8 x i8] c"{\22uri\22:\00"
@.str.37 = private unnamed_addr constant [16 x i8] c",\22diagnostics\22:\00"
@.str.38 = private unnamed_addr constant [32 x i8] c"textDocument/publishDiagnostics\00"
@.str.39 = private unnamed_addr constant [2 x i8] c"{\00"
@.str.40 = private unnamed_addr constant [22 x i8] c"\22textDocumentSync\22:1,\00"
@.str.41 = private unnamed_addr constant [22 x i8] c"\22hoverProvider\22:true,\00"
@.str.42 = private unnamed_addr constant [27 x i8] c"\22definitionProvider\22:true,\00"
@.str.43 = private unnamed_addr constant [50 x i8] c"\22completionProvider\22:{\22triggerCharacters\22:[\22.\22]},\00"
@.str.44 = private unnamed_addr constant [82 x i8] c"\22diagnosticProvider\22:{\22interFileDependencies\22:false,\22workspaceDiagnostics\22:false}\00"
@.str.45 = private unnamed_addr constant [38 x i8] c"{\22name\22:\22nova-lsp\22,\22version\22:\220.1.0\22}\00"
@.str.46 = private unnamed_addr constant [17 x i8] c"{\22capabilities\22:\00"
@.str.47 = private unnamed_addr constant [15 x i8] c",\22serverInfo\22:\00"
@.str.48 = private unnamed_addr constant [2 x i8] c"_\00"
@.str.49 = private unnamed_addr constant [6 x i8] c"print\00"
@.str.50 = private unnamed_addr constant [66 x i8] c"fn print(x: any) -> unit  --  print a value followed by a newline\00"
@.str.51 = private unnamed_addr constant [4 x i8] c"len\00"
@.str.52 = private unnamed_addr constant [56 x i8] c"fn len(x: any) -> int  --  length of a string/list/dict\00"
@.str.53 = private unnamed_addr constant [4 x i8] c"str\00"
@.str.54 = private unnamed_addr constant [48 x i8] c"fn str(x: any) -> string  --  convert to string\00"
@.str.55 = private unnamed_addr constant [4 x i8] c"int\00"
@.str.56 = private unnamed_addr constant [42 x i8] c"fn int(x: any) -> int  --  convert to int\00"
@.str.57 = private unnamed_addr constant [6 x i8] c"float\00"
@.str.58 = private unnamed_addr constant [48 x i8] c"fn float(x: any) -> float  --  convert to float\00"
@.str.59 = private unnamed_addr constant [5 x i8] c"push\00"
@.str.60 = private unnamed_addr constant [57 x i8] c"fn push(xs: List<T>, v: T) -> unit  --  append to a list\00"
@.str.61 = private unnamed_addr constant [4 x i8] c"map\00"
@.str.62 = private unnamed_addr constant [42 x i8] c"fn map(xs: List<T>, f: T -> U) -> List<U>\00"
@.str.63 = private unnamed_addr constant [7 x i8] c"filter\00"
@.str.64 = private unnamed_addr constant [48 x i8] c"fn filter(xs: List<T>, p: T -> bool) -> List<T>\00"
@.str.65 = private unnamed_addr constant [7 x i8] c"reduce\00"
@.str.66 = private unnamed_addr constant [53 x i8] c"fn reduce(xs: List<T>, f: (U, T) -> U, init: U) -> U\00"
@.str.67 = private unnamed_addr constant [4 x i8] c"sum\00"
@.str.68 = private unnamed_addr constant [29 x i8] c"fn sum(xs: List<int>) -> int\00"
@.str.69 = private unnamed_addr constant [5 x i8] c"pmap\00"
@.str.70 = private unnamed_addr constant [61 x i8] c"fn pmap(xs: List<T>, f: T -> U) -> List<U>  --  parallel map\00"
@.str.71 = private unnamed_addr constant [5 x i8] c"pfor\00"
@.str.72 = private unnamed_addr constant [70 x i8] c"fn pfor(start: int, end: int, f: int -> unit)  --  parallel for-range\00"
@.str.73 = private unnamed_addr constant [6 x i8] c"spawn\00"
@.str.74 = private unnamed_addr constant [49 x i8] c"spawn fn() body  --  run body on a worker thread\00"
@.str.75 = private unnamed_addr constant [8 x i8] c"channel\00"
@.str.76 = private unnamed_addr constant [27 x i8] c"fn channel() -> Channel<T>\00"
@.str.77 = private unnamed_addr constant [5 x i8] c"send\00"
@.str.78 = private unnamed_addr constant [38 x i8] c"fn send(ch: Channel<T>, v: T) -> unit\00"
@.str.79 = private unnamed_addr constant [5 x i8] c"recv\00"
@.str.80 = private unnamed_addr constant [29 x i8] c"fn recv(ch: Channel<T>) -> T\00"
@.str.81 = private unnamed_addr constant [13 x i8] c"tensor_zeros\00"
@.str.82 = private unnamed_addr constant [44 x i8] c"fn tensor_zeros(shape: List<int>) -> Tensor\00"
@.str.83 = private unnamed_addr constant [14 x i8] c"tensor_matmul\00"
@.str.84 = private unnamed_addr constant [49 x i8] c"fn tensor_matmul(a: Tensor, b: Tensor) -> Tensor\00"
@.str.85 = private unnamed_addr constant [12 x i8] c"tensor_relu\00"
@.str.86 = private unnamed_addr constant [36 x i8] c"fn tensor_relu(t: Tensor) -> Tensor\00"
@.str.87 = private unnamed_addr constant [7 x i8] c"format\00"
@.str.88 = private unnamed_addr constant [47 x i8] c"fn format(template: string, args...) -> string\00"
@.str.89 = private unnamed_addr constant [12 x i8] c"http_listen\00"
@.str.90 = private unnamed_addr constant [33 x i8] c"fn http_listen(port: int) -> int\00"
@.str.91 = private unnamed_addr constant [11 x i8] c"tcp_accept\00"
@.str.92 = private unnamed_addr constant [34 x i8] c"fn tcp_accept(server: int) -> int\00"
@.str.93 = private unnamed_addr constant [4 x i8] c"fn \00"
@.str.94 = private unnamed_addr constant [2 x i8] c"(\00"
@.str.95 = private unnamed_addr constant [2 x i8] c"<\00"
@.str.96 = private unnamed_addr constant [5 x i8] c"let \00"
@.str.97 = private unnamed_addr constant [2 x i8] c"=\00"
@.str.98 = private unnamed_addr constant [6 x i8] c"type \00"
@.str.99 = private unnamed_addr constant [5 x i8] c"null\00"
@.str.100 = private unnamed_addr constant [28 x i8] c"{\22kind\22:\22markdown\22,\22value\22:\00"
@.str.101 = private unnamed_addr constant [9 x i8] c"```nova\0A\00"
@.str.102 = private unnamed_addr constant [5 x i8] c"\0A```\00"
@.str.103 = private unnamed_addr constant [13 x i8] c"{\22contents\22:\00"
@.str.104 = private unnamed_addr constant [6 x i8] c"found\00"
@.str.105 = private unnamed_addr constant [5 x i8] c"line\00"
@.str.106 = private unnamed_addr constant [10 x i8] c"start_col\00"
@.str.107 = private unnamed_addr constant [8 x i8] c"end_col\00"
@.str.108 = private unnamed_addr constant [6 x i8] c"enum \00"
@.str.109 = private unnamed_addr constant [7 x i8] c"trait \00"
@.str.110 = private unnamed_addr constant [18 x i8] c"{\22start\22:{\22line\22:\00"
@.str.111 = private unnamed_addr constant [14 x i8] c",\22character\22:\00"
@.str.112 = private unnamed_addr constant [17 x i8] c"},\22end\22:{\22line\22:\00"
@.str.113 = private unnamed_addr constant [3 x i8] c"}}\00"
@.str.114 = private unnamed_addr constant [10 x i8] c",\22range\22:\00"
@.str.115 = private unnamed_addr constant [5 x i8] c"bool\00"
@.str.116 = private unnamed_addr constant [8 x i8] c"type_of\00"
@.str.117 = private unnamed_addr constant [7 x i8] c"assert\00"
@.str.118 = private unnamed_addr constant [5 x i8] c"exit\00"
@.str.119 = private unnamed_addr constant [5 x i8] c"sort\00"
@.str.120 = private unnamed_addr constant [8 x i8] c"sort_by\00"
@.str.121 = private unnamed_addr constant [8 x i8] c"reverse\00"
@.str.122 = private unnamed_addr constant [10 x i8] c"any_match\00"
@.str.123 = private unnamed_addr constant [10 x i8] c"all_match\00"
@.str.124 = private unnamed_addr constant [10 x i8] c"enumerate\00"
@.str.125 = private unnamed_addr constant [4 x i8] c"zip\00"
@.str.126 = private unnamed_addr constant [8 x i8] c"flatten\00"
@.str.127 = private unnamed_addr constant [9 x i8] c"index_of\00"
@.str.128 = private unnamed_addr constant [6 x i8] c"split\00"
@.str.129 = private unnamed_addr constant [5 x i8] c"join\00"
@.str.130 = private unnamed_addr constant [5 x i8] c"trim\00"
@.str.131 = private unnamed_addr constant [6 x i8] c"upper\00"
@.str.132 = private unnamed_addr constant [6 x i8] c"lower\00"
@.str.133 = private unnamed_addr constant [12 x i8] c"starts_with\00"
@.str.134 = private unnamed_addr constant [10 x i8] c"ends_with\00"
@.str.135 = private unnamed_addr constant [5 x i8] c"find\00"
@.str.136 = private unnamed_addr constant [8 x i8] c"replace\00"
@.str.137 = private unnamed_addr constant [8 x i8] c"pfilter\00"
@.str.138 = private unnamed_addr constant [10 x i8] c"cpu_count\00"
@.str.139 = private unnamed_addr constant [17 x i8] c"tensor_from_list\00"
@.str.140 = private unnamed_addr constant [11 x i8] c"tensor_add\00"
@.str.141 = private unnamed_addr constant [11 x i8] c"tensor_mul\00"
@.str.142 = private unnamed_addr constant [11 x i8] c"tensor_sum\00"
@.str.143 = private unnamed_addr constant [3 x i8] c"fn\00"
@.str.144 = private unnamed_addr constant [4 x i8] c"let\00"
@.str.145 = private unnamed_addr constant [3 x i8] c"if\00"
@.str.146 = private unnamed_addr constant [5 x i8] c"else\00"
@.str.147 = private unnamed_addr constant [6 x i8] c"while\00"
@.str.148 = private unnamed_addr constant [4 x i8] c"for\00"
@.str.149 = private unnamed_addr constant [7 x i8] c"return\00"
@.str.150 = private unnamed_addr constant [6 x i8] c"match\00"
@.str.151 = private unnamed_addr constant [10 x i8] c"{\22label\22:\00"
@.str.152 = private unnamed_addr constant [20 x i8] c",\22kind\22:3,\22detail\22:\00"
@.str.153 = private unnamed_addr constant [31 x i8] c"{\22isIncomplete\22:false,\22items\22:\00"
@.str.154 = private unnamed_addr constant [7 x i8] c"method\00"
@.str.155 = private unnamed_addr constant [3 x i8] c"id\00"
@.str.156 = private unnamed_addr constant [19 x i8] c"[nova-lsp] method=\00"
@.str.157 = private unnamed_addr constant [5 x i8] c" id=\00"
@.str.158 = private unnamed_addr constant [11 x i8] c"initialize\00"
@.str.159 = private unnamed_addr constant [12 x i8] c"initialized\00"
@.str.160 = private unnamed_addr constant [9 x i8] c"shutdown\00"
@.str.161 = private unnamed_addr constant [21 x i8] c"textDocument/didOpen\00"
@.str.162 = private unnamed_addr constant [23 x i8] c"textDocument/didChange\00"
@.str.163 = private unnamed_addr constant [4 x i8] c"uri\00"
@.str.164 = private unnamed_addr constant [5 x i8] c"text\00"
@.str.165 = private unnamed_addr constant [22 x i8] c"textDocument/didClose\00"
@.str.166 = private unnamed_addr constant [19 x i8] c"textDocument/hover\00"
@.str.167 = private unnamed_addr constant [10 x i8] c"character\00"
@.str.168 = private unnamed_addr constant [23 x i8] c"[nova-lsp] hover word=\00"
@.str.169 = private unnamed_addr constant [24 x i8] c"textDocument/definition\00"
@.str.170 = private unnamed_addr constant [28 x i8] c"[nova-lsp] definition word=\00"
@.str.171 = private unnamed_addr constant [24 x i8] c"textDocument/completion\00"
@.str.172 = private unnamed_addr constant [24 x i8] c"textDocument/diagnostic\00"
@.str.173 = private unnamed_addr constant [27 x i8] c"{\22kind\22:\22full\22,\22items\22:[]}\00"
@.str.174 = private unnamed_addr constant [30 x i8] c"[nova-lsp] server starting...\00"
@.str.175 = private unnamed_addr constant [16 x i8] c".\\gen2_move.exe\00"
@.str.176 = private unnamed_addr constant [22 x i8] c"[nova-lsp] compiler: \00"
@.str.177 = private unnamed_addr constant [24 x i8] c"[nova-lsp] stdin closed\00"
@.str.178 = private unnamed_addr constant [26 x i8] c"[nova-lsp] exit requested\00"
@.str.179 = private unnamed_addr constant [26 x i8] c"[nova-lsp] server stopped\00"

; Debug metadata
!llvm.dbg.cu = !{!100}
!llvm.module.flags = !{!102, !103}

!100 = distinct !DICompileUnit(language: DW_LANG_C99, file: !101, producer: "NOVA Compiler", isOptimized: false, emissionKind: LineTablesOnly)
!101 = !DIFile(filename: "lsp_server.nova", directory: ".")
!102 = !{i32 2, !"CodeView", i32 1}
!103 = !{i32 2, !"Debug Info Version", i32 3}
!104 = !DISubroutineType(types: !105)
!105 = !{null}
!200 = distinct !DISubprogram(name: "log_msg", scope: !101, file: !101, line: 8, type: !104, scopeLine: 8, spFlags: DISPFlagDefinition, unit: !100)
!201 = !DILocation(line: 8, column: 0, scope: !200)
!203 = distinct !DISubprogram(name: "json_str", scope: !101, file: !101, line: 13, type: !104, scopeLine: 13, spFlags: DISPFlagDefinition, unit: !100)
!204 = !DILocation(line: 13, column: 0, scope: !203)
!226 = distinct !DISubprogram(name: "json_int", scope: !101, file: !101, line: 37, type: !104, scopeLine: 37, spFlags: DISPFlagDefinition, unit: !100)
!227 = !DILocation(line: 37, column: 0, scope: !226)
!229 = distinct !DISubprogram(name: "read_header_line", scope: !101, file: !101, line: 42, type: !104, scopeLine: 42, spFlags: DISPFlagDefinition, unit: !100)
!230 = !DILocation(line: 42, column: 0, scope: !229)
!247 = distinct !DISubprogram(name: "read_message", scope: !101, file: !101, line: 61, type: !104, scopeLine: 61, spFlags: DISPFlagDefinition, unit: !100)
!248 = !DILocation(line: 61, column: 0, scope: !247)
!265 = distinct !DISubprogram(name: "send_message", scope: !101, file: !101, line: 83, type: !104, scopeLine: 83, spFlags: DISPFlagDefinition, unit: !100)
!266 = !DILocation(line: 83, column: 0, scope: !265)
!272 = distinct !DISubprogram(name: "build_response", scope: !101, file: !101, line: 92, type: !104, scopeLine: 92, spFlags: DISPFlagDefinition, unit: !100)
!273 = !DILocation(line: 92, column: 0, scope: !272)
!275 = distinct !DISubprogram(name: "build_notification", scope: !101, file: !101, line: 95, type: !104, scopeLine: 95, spFlags: DISPFlagDefinition, unit: !100)
!276 = !DILocation(line: 95, column: 0, scope: !275)
!278 = distinct !DISubprogram(name: "json_extract_int", scope: !101, file: !101, line: 100, type: !104, scopeLine: 100, spFlags: DISPFlagDefinition, unit: !100)
!279 = !DILocation(line: 100, column: 0, scope: !278)
!294 = distinct !DISubprogram(name: "json_extract_string", scope: !101, file: !101, line: 116, type: !104, scopeLine: 116, spFlags: DISPFlagDefinition, unit: !100)
!295 = !DILocation(line: 116, column: 0, scope: !294)
!334 = distinct !DISubprogram(name: "parse_errors", scope: !101, file: !101, line: 166, type: !104, scopeLine: 166, spFlags: DISPFlagDefinition, unit: !100)
!335 = !DILocation(line: 166, column: 0, scope: !334)
!365 = distinct !DISubprogram(name: "run_compile_for_uri", scope: !101, file: !101, line: 197, type: !104, scopeLine: 197, spFlags: DISPFlagDefinition, unit: !100)
!366 = !DILocation(line: 197, column: 0, scope: !365)
!372 = distinct !DISubprogram(name: "diag_to_json", scope: !101, file: !101, line: 204, type: !104, scopeLine: 204, spFlags: DISPFlagDefinition, unit: !100)
!373 = !DILocation(line: 204, column: 0, scope: !372)
!376 = distinct !DISubprogram(name: "diags_to_array", scope: !101, file: !101, line: 209, type: !104, scopeLine: 209, spFlags: DISPFlagDefinition, unit: !100)
!377 = !DILocation(line: 209, column: 0, scope: !376)
!386 = distinct !DISubprogram(name: "publish_diagnostics", scope: !101, file: !101, line: 219, type: !104, scopeLine: 219, spFlags: DISPFlagDefinition, unit: !100)
!387 = !DILocation(line: 219, column: 0, scope: !386)
!391 = distinct !DISubprogram(name: "server_capabilities", scope: !101, file: !101, line: 226, type: !104, scopeLine: 226, spFlags: DISPFlagDefinition, unit: !100)
!392 = !DILocation(line: 226, column: 0, scope: !391)
!402 = distinct !DISubprogram(name: "document_set", scope: !101, file: !101, line: 241, type: !104, scopeLine: 241, spFlags: DISPFlagDefinition, unit: !100)
!403 = !DILocation(line: 241, column: 0, scope: !402)
!405 = distinct !DISubprogram(name: "document_get", scope: !101, file: !101, line: 244, type: !104, scopeLine: 244, spFlags: DISPFlagDefinition, unit: !100)
!406 = !DILocation(line: 244, column: 0, scope: !405)
!410 = distinct !DISubprogram(name: "word_at_position", scope: !101, file: !101, line: 250, type: !104, scopeLine: 250, spFlags: DISPFlagDefinition, unit: !100)
!411 = !DILocation(line: 250, column: 0, scope: !410)
!455 = distinct !DISubprogram(name: "builtin_doc", scope: !101, file: !101, line: 296, type: !104, scopeLine: 296, spFlags: DISPFlagDefinition, unit: !100)
!456 = !DILocation(line: 296, column: 0, scope: !455)
!502 = distinct !DISubprogram(name: "user_symbol_doc", scope: !101, file: !101, line: 343, type: !104, scopeLine: 343, spFlags: DISPFlagDefinition, unit: !100)
!503 = !DILocation(line: 343, column: 0, scope: !502)
!516 = distinct !DISubprogram(name: "build_hover_response", scope: !101, file: !101, line: 357, type: !104, scopeLine: 357, spFlags: DISPFlagDefinition, unit: !100)
!517 = !DILocation(line: 357, column: 0, scope: !516)
!522 = distinct !DISubprogram(name: "find_definition_location", scope: !101, file: !101, line: 365, type: !104, scopeLine: 365, spFlags: DISPFlagDefinition, unit: !100)
!523 = !DILocation(line: 365, column: 0, scope: !522)
!559 = distinct !DISubprogram(name: "build_definition_response", scope: !101, file: !101, line: 403, type: !104, scopeLine: 403, spFlags: DISPFlagDefinition, unit: !100)
!560 = !DILocation(line: 403, column: 0, scope: !559)
!569 = distinct !DISubprogram(name: "completion_items", scope: !101, file: !101, line: 414, type: !104, scopeLine: 414, spFlags: DISPFlagDefinition, unit: !100)
!570 = !DILocation(line: 414, column: 0, scope: !569)
!622 = distinct !DISubprogram(name: "build_completion_response", scope: !101, file: !101, line: 467, type: !104, scopeLine: 467, spFlags: DISPFlagDefinition, unit: !100)
!623 = !DILocation(line: 467, column: 0, scope: !622)
!635 = distinct !DISubprogram(name: "handle_message", scope: !101, file: !101, line: 482, type: !104, scopeLine: 482, spFlags: DISPFlagDefinition, unit: !100)
!636 = !DILocation(line: 482, column: 0, scope: !635)
!698 = distinct !DISubprogram(name: "nova_user_main", scope: !101, file: !101, line: 546, type: !104, scopeLine: 546, spFlags: DISPFlagDefinition, unit: !100)
!699 = !DILocation(line: 546, column: 0, scope: !698)
!202 = !DILocation(line: 9, column: 0, scope: !200)
!205 = !DILocation(line: 14, column: 0, scope: !203)
!206 = !DILocation(line: 15, column: 0, scope: !203)
!207 = !DILocation(line: 16, column: 0, scope: !203)
!208 = !DILocation(line: 17, column: 0, scope: !203)
!209 = !DILocation(line: 18, column: 0, scope: !203)
!210 = !DILocation(line: 19, column: 0, scope: !203)
!211 = !DILocation(line: 20, column: 0, scope: !203)
!212 = !DILocation(line: 21, column: 0, scope: !203)
!213 = !DILocation(line: 22, column: 0, scope: !203)
!214 = !DILocation(line: 23, column: 0, scope: !203)
!215 = !DILocation(line: 24, column: 0, scope: !203)
!216 = !DILocation(line: 25, column: 0, scope: !203)
!217 = !DILocation(line: 26, column: 0, scope: !203)
!218 = !DILocation(line: 27, column: 0, scope: !203)
!219 = !DILocation(line: 28, column: 0, scope: !203)
!220 = !DILocation(line: 29, column: 0, scope: !203)
!221 = !DILocation(line: 30, column: 0, scope: !203)
!222 = !DILocation(line: 31, column: 0, scope: !203)
!223 = !DILocation(line: 33, column: 0, scope: !203)
!224 = !DILocation(line: 34, column: 0, scope: !203)
!225 = !DILocation(line: 35, column: 0, scope: !203)
!228 = !DILocation(line: 38, column: 0, scope: !226)
!231 = !DILocation(line: 43, column: 0, scope: !229)
!232 = !DILocation(line: 44, column: 0, scope: !229)
!233 = !DILocation(line: 45, column: 0, scope: !229)
!234 = !DILocation(line: 46, column: 0, scope: !229)
!235 = !DILocation(line: 47, column: 0, scope: !229)
!236 = !DILocation(line: 48, column: 0, scope: !229)
!237 = !DILocation(line: 49, column: 0, scope: !229)
!238 = !DILocation(line: 50, column: 0, scope: !229)
!239 = !DILocation(line: 51, column: 0, scope: !229)
!240 = !DILocation(line: 52, column: 0, scope: !229)
!241 = !DILocation(line: 53, column: 0, scope: !229)
!242 = !DILocation(line: 54, column: 0, scope: !229)
!243 = !DILocation(line: 56, column: 0, scope: !229)
!244 = !DILocation(line: 57, column: 0, scope: !229)
!245 = !DILocation(line: 58, column: 0, scope: !229)
!246 = !DILocation(line: 59, column: 0, scope: !229)
!249 = !DILocation(line: 62, column: 0, scope: !247)
!250 = !DILocation(line: 63, column: 0, scope: !247)
!251 = !DILocation(line: 64, column: 0, scope: !247)
!252 = !DILocation(line: 65, column: 0, scope: !247)
!253 = !DILocation(line: 66, column: 0, scope: !247)
!254 = !DILocation(line: 67, column: 0, scope: !247)
!255 = !DILocation(line: 68, column: 0, scope: !247)
!256 = !DILocation(line: 69, column: 0, scope: !247)
!257 = !DILocation(line: 71, column: 0, scope: !247)
!258 = !DILocation(line: 72, column: 0, scope: !247)
!259 = !DILocation(line: 74, column: 0, scope: !247)
!260 = !DILocation(line: 75, column: 0, scope: !247)
!261 = !DILocation(line: 76, column: 0, scope: !247)
!262 = !DILocation(line: 77, column: 0, scope: !247)
!263 = !DILocation(line: 78, column: 0, scope: !247)
!264 = !DILocation(line: 79, column: 0, scope: !247)
!267 = !DILocation(line: 84, column: 0, scope: !265)
!268 = !DILocation(line: 85, column: 0, scope: !265)
!269 = !DILocation(line: 86, column: 0, scope: !265)
!270 = !DILocation(line: 87, column: 0, scope: !265)
!271 = !DILocation(line: 88, column: 0, scope: !265)
!274 = !DILocation(line: 93, column: 0, scope: !272)
!277 = !DILocation(line: 96, column: 0, scope: !275)
!280 = !DILocation(line: 101, column: 0, scope: !278)
!281 = !DILocation(line: 102, column: 0, scope: !278)
!282 = !DILocation(line: 103, column: 0, scope: !278)
!283 = !DILocation(line: 104, column: 0, scope: !278)
!284 = !DILocation(line: 105, column: 0, scope: !278)
!285 = !DILocation(line: 106, column: 0, scope: !278)
!286 = !DILocation(line: 107, column: 0, scope: !278)
!287 = !DILocation(line: 108, column: 0, scope: !278)
!288 = !DILocation(line: 109, column: 0, scope: !278)
!289 = !DILocation(line: 110, column: 0, scope: !278)
!290 = !DILocation(line: 111, column: 0, scope: !278)
!291 = !DILocation(line: 112, column: 0, scope: !278)
!292 = !DILocation(line: 113, column: 0, scope: !278)
!293 = !DILocation(line: 114, column: 0, scope: !278)
!296 = !DILocation(line: 117, column: 0, scope: !294)
!297 = !DILocation(line: 118, column: 0, scope: !294)
!298 = !DILocation(line: 119, column: 0, scope: !294)
!299 = !DILocation(line: 120, column: 0, scope: !294)
!300 = !DILocation(line: 121, column: 0, scope: !294)
!301 = !DILocation(line: 122, column: 0, scope: !294)
!302 = !DILocation(line: 123, column: 0, scope: !294)
!303 = !DILocation(line: 124, column: 0, scope: !294)
!304 = !DILocation(line: 125, column: 0, scope: !294)
!305 = !DILocation(line: 126, column: 0, scope: !294)
!306 = !DILocation(line: 127, column: 0, scope: !294)
!307 = !DILocation(line: 129, column: 0, scope: !294)
!308 = !DILocation(line: 130, column: 0, scope: !294)
!309 = !DILocation(line: 131, column: 0, scope: !294)
!310 = !DILocation(line: 132, column: 0, scope: !294)
!311 = !DILocation(line: 133, column: 0, scope: !294)
!312 = !DILocation(line: 134, column: 0, scope: !294)
!313 = !DILocation(line: 135, column: 0, scope: !294)
!314 = !DILocation(line: 136, column: 0, scope: !294)
!315 = !DILocation(line: 137, column: 0, scope: !294)
!316 = !DILocation(line: 138, column: 0, scope: !294)
!317 = !DILocation(line: 139, column: 0, scope: !294)
!318 = !DILocation(line: 140, column: 0, scope: !294)
!319 = !DILocation(line: 141, column: 0, scope: !294)
!320 = !DILocation(line: 142, column: 0, scope: !294)
!321 = !DILocation(line: 143, column: 0, scope: !294)
!322 = !DILocation(line: 144, column: 0, scope: !294)
!323 = !DILocation(line: 145, column: 0, scope: !294)
!324 = !DILocation(line: 146, column: 0, scope: !294)
!325 = !DILocation(line: 147, column: 0, scope: !294)
!326 = !DILocation(line: 148, column: 0, scope: !294)
!327 = !DILocation(line: 150, column: 0, scope: !294)
!328 = !DILocation(line: 151, column: 0, scope: !294)
!329 = !DILocation(line: 152, column: 0, scope: !294)
!330 = !DILocation(line: 153, column: 0, scope: !294)
!331 = !DILocation(line: 155, column: 0, scope: !294)
!332 = !DILocation(line: 156, column: 0, scope: !294)
!333 = !DILocation(line: 157, column: 0, scope: !294)
!336 = !DILocation(line: 167, column: 0, scope: !334)
!337 = !DILocation(line: 168, column: 0, scope: !334)
!338 = !DILocation(line: 169, column: 0, scope: !334)
!339 = !DILocation(line: 170, column: 0, scope: !334)
!340 = !DILocation(line: 171, column: 0, scope: !334)
!341 = !DILocation(line: 172, column: 0, scope: !334)
!342 = !DILocation(line: 173, column: 0, scope: !334)
!343 = !DILocation(line: 174, column: 0, scope: !334)
!344 = !DILocation(line: 175, column: 0, scope: !334)
!345 = !DILocation(line: 176, column: 0, scope: !334)
!346 = !DILocation(line: 177, column: 0, scope: !334)
!347 = !DILocation(line: 178, column: 0, scope: !334)
!348 = !DILocation(line: 179, column: 0, scope: !334)
!349 = !DILocation(line: 180, column: 0, scope: !334)
!350 = !DILocation(line: 181, column: 0, scope: !334)
!351 = !DILocation(line: 182, column: 0, scope: !334)
!352 = !DILocation(line: 183, column: 0, scope: !334)
!353 = !DILocation(line: 184, column: 0, scope: !334)
!354 = !DILocation(line: 185, column: 0, scope: !334)
!355 = !DILocation(line: 186, column: 0, scope: !334)
!356 = !DILocation(line: 187, column: 0, scope: !334)
!357 = !DILocation(line: 188, column: 0, scope: !334)
!358 = !DILocation(line: 189, column: 0, scope: !334)
!359 = !DILocation(line: 190, column: 0, scope: !334)
!360 = !DILocation(line: 191, column: 0, scope: !334)
!361 = !DILocation(line: 192, column: 0, scope: !334)
!362 = !DILocation(line: 193, column: 0, scope: !334)
!363 = !DILocation(line: 194, column: 0, scope: !334)
!364 = !DILocation(line: 195, column: 0, scope: !334)
!367 = !DILocation(line: 198, column: 0, scope: !365)
!368 = !DILocation(line: 199, column: 0, scope: !365)
!369 = !DILocation(line: 200, column: 0, scope: !365)
!370 = !DILocation(line: 201, column: 0, scope: !365)
!371 = !DILocation(line: 202, column: 0, scope: !365)
!374 = !DILocation(line: 205, column: 0, scope: !372)
!375 = !DILocation(line: 207, column: 0, scope: !372)
!378 = !DILocation(line: 210, column: 0, scope: !376)
!379 = !DILocation(line: 211, column: 0, scope: !376)
!380 = !DILocation(line: 212, column: 0, scope: !376)
!381 = !DILocation(line: 213, column: 0, scope: !376)
!382 = !DILocation(line: 214, column: 0, scope: !376)
!383 = !DILocation(line: 215, column: 0, scope: !376)
!384 = !DILocation(line: 216, column: 0, scope: !376)
!385 = !DILocation(line: 217, column: 0, scope: !376)
!388 = !DILocation(line: 220, column: 0, scope: !386)
!389 = !DILocation(line: 221, column: 0, scope: !386)
!390 = !DILocation(line: 222, column: 0, scope: !386)
!393 = !DILocation(line: 227, column: 0, scope: !391)
!394 = !DILocation(line: 228, column: 0, scope: !391)
!395 = !DILocation(line: 229, column: 0, scope: !391)
!396 = !DILocation(line: 230, column: 0, scope: !391)
!397 = !DILocation(line: 231, column: 0, scope: !391)
!398 = !DILocation(line: 232, column: 0, scope: !391)
!399 = !DILocation(line: 233, column: 0, scope: !391)
!400 = !DILocation(line: 234, column: 0, scope: !391)
!401 = !DILocation(line: 235, column: 0, scope: !391)
!404 = !DILocation(line: 242, column: 0, scope: !402)
!407 = !DILocation(line: 245, column: 0, scope: !405)
!408 = !DILocation(line: 246, column: 0, scope: !405)
!409 = !DILocation(line: 247, column: 0, scope: !405)
!412 = !DILocation(line: 251, column: 0, scope: !410)
!413 = !DILocation(line: 252, column: 0, scope: !410)
!414 = !DILocation(line: 253, column: 0, scope: !410)
!415 = !DILocation(line: 254, column: 0, scope: !410)
!416 = !DILocation(line: 255, column: 0, scope: !410)
!417 = !DILocation(line: 256, column: 0, scope: !410)
!418 = !DILocation(line: 257, column: 0, scope: !410)
!419 = !DILocation(line: 258, column: 0, scope: !410)
!420 = !DILocation(line: 259, column: 0, scope: !410)
!421 = !DILocation(line: 260, column: 0, scope: !410)
!422 = !DILocation(line: 261, column: 0, scope: !410)
!423 = !DILocation(line: 262, column: 0, scope: !410)
!424 = !DILocation(line: 263, column: 0, scope: !410)
!425 = !DILocation(line: 264, column: 0, scope: !410)
!426 = !DILocation(line: 265, column: 0, scope: !410)
!427 = !DILocation(line: 266, column: 0, scope: !410)
!428 = !DILocation(line: 267, column: 0, scope: !410)
!429 = !DILocation(line: 268, column: 0, scope: !410)
!430 = !DILocation(line: 269, column: 0, scope: !410)
!431 = !DILocation(line: 270, column: 0, scope: !410)
!432 = !DILocation(line: 271, column: 0, scope: !410)
!433 = !DILocation(line: 272, column: 0, scope: !410)
!434 = !DILocation(line: 273, column: 0, scope: !410)
!435 = !DILocation(line: 274, column: 0, scope: !410)
!436 = !DILocation(line: 275, column: 0, scope: !410)
!437 = !DILocation(line: 276, column: 0, scope: !410)
!438 = !DILocation(line: 277, column: 0, scope: !410)
!439 = !DILocation(line: 278, column: 0, scope: !410)
!440 = !DILocation(line: 279, column: 0, scope: !410)
!441 = !DILocation(line: 280, column: 0, scope: !410)
!442 = !DILocation(line: 281, column: 0, scope: !410)
!443 = !DILocation(line: 282, column: 0, scope: !410)
!444 = !DILocation(line: 283, column: 0, scope: !410)
!445 = !DILocation(line: 284, column: 0, scope: !410)
!446 = !DILocation(line: 285, column: 0, scope: !410)
!447 = !DILocation(line: 286, column: 0, scope: !410)
!448 = !DILocation(line: 287, column: 0, scope: !410)
!449 = !DILocation(line: 288, column: 0, scope: !410)
!450 = !DILocation(line: 289, column: 0, scope: !410)
!451 = !DILocation(line: 290, column: 0, scope: !410)
!452 = !DILocation(line: 291, column: 0, scope: !410)
!453 = !DILocation(line: 292, column: 0, scope: !410)
!454 = !DILocation(line: 293, column: 0, scope: !410)
!457 = !DILocation(line: 297, column: 0, scope: !455)
!458 = !DILocation(line: 298, column: 0, scope: !455)
!459 = !DILocation(line: 299, column: 0, scope: !455)
!460 = !DILocation(line: 300, column: 0, scope: !455)
!461 = !DILocation(line: 301, column: 0, scope: !455)
!462 = !DILocation(line: 302, column: 0, scope: !455)
!463 = !DILocation(line: 303, column: 0, scope: !455)
!464 = !DILocation(line: 304, column: 0, scope: !455)
!465 = !DILocation(line: 305, column: 0, scope: !455)
!466 = !DILocation(line: 306, column: 0, scope: !455)
!467 = !DILocation(line: 307, column: 0, scope: !455)
!468 = !DILocation(line: 308, column: 0, scope: !455)
!469 = !DILocation(line: 309, column: 0, scope: !455)
!470 = !DILocation(line: 310, column: 0, scope: !455)
!471 = !DILocation(line: 311, column: 0, scope: !455)
!472 = !DILocation(line: 312, column: 0, scope: !455)
!473 = !DILocation(line: 313, column: 0, scope: !455)
!474 = !DILocation(line: 314, column: 0, scope: !455)
!475 = !DILocation(line: 315, column: 0, scope: !455)
!476 = !DILocation(line: 316, column: 0, scope: !455)
!477 = !DILocation(line: 317, column: 0, scope: !455)
!478 = !DILocation(line: 318, column: 0, scope: !455)
!479 = !DILocation(line: 319, column: 0, scope: !455)
!480 = !DILocation(line: 320, column: 0, scope: !455)
!481 = !DILocation(line: 321, column: 0, scope: !455)
!482 = !DILocation(line: 322, column: 0, scope: !455)
!483 = !DILocation(line: 323, column: 0, scope: !455)
!484 = !DILocation(line: 324, column: 0, scope: !455)
!485 = !DILocation(line: 325, column: 0, scope: !455)
!486 = !DILocation(line: 326, column: 0, scope: !455)
!487 = !DILocation(line: 327, column: 0, scope: !455)
!488 = !DILocation(line: 328, column: 0, scope: !455)
!489 = !DILocation(line: 329, column: 0, scope: !455)
!490 = !DILocation(line: 330, column: 0, scope: !455)
!491 = !DILocation(line: 331, column: 0, scope: !455)
!492 = !DILocation(line: 332, column: 0, scope: !455)
!493 = !DILocation(line: 333, column: 0, scope: !455)
!494 = !DILocation(line: 334, column: 0, scope: !455)
!495 = !DILocation(line: 335, column: 0, scope: !455)
!496 = !DILocation(line: 336, column: 0, scope: !455)
!497 = !DILocation(line: 337, column: 0, scope: !455)
!498 = !DILocation(line: 338, column: 0, scope: !455)
!499 = !DILocation(line: 339, column: 0, scope: !455)
!500 = !DILocation(line: 340, column: 0, scope: !455)
!501 = !DILocation(line: 341, column: 0, scope: !455)
!504 = !DILocation(line: 344, column: 0, scope: !502)
!505 = !DILocation(line: 345, column: 0, scope: !502)
!506 = !DILocation(line: 346, column: 0, scope: !502)
!507 = !DILocation(line: 347, column: 0, scope: !502)
!508 = !DILocation(line: 348, column: 0, scope: !502)
!509 = !DILocation(line: 349, column: 0, scope: !502)
!510 = !DILocation(line: 350, column: 0, scope: !502)
!511 = !DILocation(line: 351, column: 0, scope: !502)
!512 = !DILocation(line: 352, column: 0, scope: !502)
!513 = !DILocation(line: 353, column: 0, scope: !502)
!514 = !DILocation(line: 354, column: 0, scope: !502)
!515 = !DILocation(line: 355, column: 0, scope: !502)
!518 = !DILocation(line: 358, column: 0, scope: !516)
!519 = !DILocation(line: 359, column: 0, scope: !516)
!520 = !DILocation(line: 360, column: 0, scope: !516)
!521 = !DILocation(line: 361, column: 0, scope: !516)
!524 = !DILocation(line: 366, column: 0, scope: !522)
!525 = !DILocation(line: 367, column: 0, scope: !522)
!526 = !DILocation(line: 368, column: 0, scope: !522)
!527 = !DILocation(line: 369, column: 0, scope: !522)
!528 = !DILocation(line: 370, column: 0, scope: !522)
!529 = !DILocation(line: 371, column: 0, scope: !522)
!530 = !DILocation(line: 372, column: 0, scope: !522)
!531 = !DILocation(line: 373, column: 0, scope: !522)
!532 = !DILocation(line: 374, column: 0, scope: !522)
!533 = !DILocation(line: 375, column: 0, scope: !522)
!534 = !DILocation(line: 376, column: 0, scope: !522)
!535 = !DILocation(line: 377, column: 0, scope: !522)
!536 = !DILocation(line: 378, column: 0, scope: !522)
!537 = !DILocation(line: 379, column: 0, scope: !522)
!538 = !DILocation(line: 380, column: 0, scope: !522)
!539 = !DILocation(line: 381, column: 0, scope: !522)
!540 = !DILocation(line: 382, column: 0, scope: !522)
!541 = !DILocation(line: 383, column: 0, scope: !522)
!542 = !DILocation(line: 384, column: 0, scope: !522)
!543 = !DILocation(line: 385, column: 0, scope: !522)
!544 = !DILocation(line: 386, column: 0, scope: !522)
!545 = !DILocation(line: 387, column: 0, scope: !522)
!546 = !DILocation(line: 388, column: 0, scope: !522)
!547 = !DILocation(line: 389, column: 0, scope: !522)
!548 = !DILocation(line: 391, column: 0, scope: !522)
!549 = !DILocation(line: 392, column: 0, scope: !522)
!550 = !DILocation(line: 393, column: 0, scope: !522)
!551 = !DILocation(line: 394, column: 0, scope: !522)
!552 = !DILocation(line: 395, column: 0, scope: !522)
!553 = !DILocation(line: 396, column: 0, scope: !522)
!554 = !DILocation(line: 397, column: 0, scope: !522)
!555 = !DILocation(line: 398, column: 0, scope: !522)
!556 = !DILocation(line: 399, column: 0, scope: !522)
!557 = !DILocation(line: 400, column: 0, scope: !522)
!558 = !DILocation(line: 401, column: 0, scope: !522)
!561 = !DILocation(line: 404, column: 0, scope: !559)
!562 = !DILocation(line: 405, column: 0, scope: !559)
!563 = !DILocation(line: 406, column: 0, scope: !559)
!564 = !DILocation(line: 407, column: 0, scope: !559)
!565 = !DILocation(line: 408, column: 0, scope: !559)
!566 = !DILocation(line: 409, column: 0, scope: !559)
!567 = !DILocation(line: 410, column: 0, scope: !559)
!568 = !DILocation(line: 411, column: 0, scope: !559)
!571 = !DILocation(line: 415, column: 0, scope: !569)
!572 = !DILocation(line: 416, column: 0, scope: !569)
!573 = !DILocation(line: 417, column: 0, scope: !569)
!574 = !DILocation(line: 418, column: 0, scope: !569)
!575 = !DILocation(line: 419, column: 0, scope: !569)
!576 = !DILocation(line: 420, column: 0, scope: !569)
!577 = !DILocation(line: 421, column: 0, scope: !569)
!578 = !DILocation(line: 422, column: 0, scope: !569)
!579 = !DILocation(line: 423, column: 0, scope: !569)
!580 = !DILocation(line: 424, column: 0, scope: !569)
!581 = !DILocation(line: 425, column: 0, scope: !569)
!582 = !DILocation(line: 426, column: 0, scope: !569)
!583 = !DILocation(line: 427, column: 0, scope: !569)
!584 = !DILocation(line: 428, column: 0, scope: !569)
!585 = !DILocation(line: 429, column: 0, scope: !569)
!586 = !DILocation(line: 430, column: 0, scope: !569)
!587 = !DILocation(line: 431, column: 0, scope: !569)
!588 = !DILocation(line: 432, column: 0, scope: !569)
!589 = !DILocation(line: 433, column: 0, scope: !569)
!590 = !DILocation(line: 434, column: 0, scope: !569)
!591 = !DILocation(line: 435, column: 0, scope: !569)
!592 = !DILocation(line: 436, column: 0, scope: !569)
!593 = !DILocation(line: 437, column: 0, scope: !569)
!594 = !DILocation(line: 438, column: 0, scope: !569)
!595 = !DILocation(line: 439, column: 0, scope: !569)
!596 = !DILocation(line: 440, column: 0, scope: !569)
!597 = !DILocation(line: 441, column: 0, scope: !569)
!598 = !DILocation(line: 442, column: 0, scope: !569)
!599 = !DILocation(line: 443, column: 0, scope: !569)
!600 = !DILocation(line: 444, column: 0, scope: !569)
!601 = !DILocation(line: 445, column: 0, scope: !569)
!602 = !DILocation(line: 446, column: 0, scope: !569)
!603 = !DILocation(line: 447, column: 0, scope: !569)
!604 = !DILocation(line: 448, column: 0, scope: !569)
!605 = !DILocation(line: 449, column: 0, scope: !569)
!606 = !DILocation(line: 450, column: 0, scope: !569)
!607 = !DILocation(line: 451, column: 0, scope: !569)
!608 = !DILocation(line: 452, column: 0, scope: !569)
!609 = !DILocation(line: 453, column: 0, scope: !569)
!610 = !DILocation(line: 454, column: 0, scope: !569)
!611 = !DILocation(line: 455, column: 0, scope: !569)
!612 = !DILocation(line: 456, column: 0, scope: !569)
!613 = !DILocation(line: 457, column: 0, scope: !569)
!614 = !DILocation(line: 458, column: 0, scope: !569)
!615 = !DILocation(line: 459, column: 0, scope: !569)
!616 = !DILocation(line: 460, column: 0, scope: !569)
!617 = !DILocation(line: 461, column: 0, scope: !569)
!618 = !DILocation(line: 462, column: 0, scope: !569)
!619 = !DILocation(line: 463, column: 0, scope: !569)
!620 = !DILocation(line: 464, column: 0, scope: !569)
!621 = !DILocation(line: 465, column: 0, scope: !569)
!624 = !DILocation(line: 468, column: 0, scope: !622)
!625 = !DILocation(line: 469, column: 0, scope: !622)
!626 = !DILocation(line: 470, column: 0, scope: !622)
!627 = !DILocation(line: 471, column: 0, scope: !622)
!628 = !DILocation(line: 472, column: 0, scope: !622)
!629 = !DILocation(line: 473, column: 0, scope: !622)
!630 = !DILocation(line: 474, column: 0, scope: !622)
!631 = !DILocation(line: 475, column: 0, scope: !622)
!632 = !DILocation(line: 476, column: 0, scope: !622)
!633 = !DILocation(line: 477, column: 0, scope: !622)
!634 = !DILocation(line: 478, column: 0, scope: !622)
!637 = !DILocation(line: 483, column: 0, scope: !635)
!638 = !DILocation(line: 484, column: 0, scope: !635)
!639 = !DILocation(line: 485, column: 0, scope: !635)
!640 = !DILocation(line: 487, column: 0, scope: !635)
!641 = !DILocation(line: 488, column: 0, scope: !635)
!642 = !DILocation(line: 489, column: 0, scope: !635)
!643 = !DILocation(line: 490, column: 0, scope: !635)
!644 = !DILocation(line: 491, column: 0, scope: !635)
!645 = !DILocation(line: 492, column: 0, scope: !635)
!646 = !DILocation(line: 493, column: 0, scope: !635)
!647 = !DILocation(line: 494, column: 0, scope: !635)
!648 = !DILocation(line: 495, column: 0, scope: !635)
!649 = !DILocation(line: 496, column: 0, scope: !635)
!650 = !DILocation(line: 497, column: 0, scope: !635)
!651 = !DILocation(line: 498, column: 0, scope: !635)
!652 = !DILocation(line: 499, column: 0, scope: !635)
!653 = !DILocation(line: 500, column: 0, scope: !635)
!654 = !DILocation(line: 501, column: 0, scope: !635)
!655 = !DILocation(line: 502, column: 0, scope: !635)
!656 = !DILocation(line: 503, column: 0, scope: !635)
!657 = !DILocation(line: 504, column: 0, scope: !635)
!658 = !DILocation(line: 505, column: 0, scope: !635)
!659 = !DILocation(line: 506, column: 0, scope: !635)
!660 = !DILocation(line: 507, column: 0, scope: !635)
!661 = !DILocation(line: 508, column: 0, scope: !635)
!662 = !DILocation(line: 509, column: 0, scope: !635)
!663 = !DILocation(line: 510, column: 0, scope: !635)
!664 = !DILocation(line: 511, column: 0, scope: !635)
!665 = !DILocation(line: 512, column: 0, scope: !635)
!666 = !DILocation(line: 513, column: 0, scope: !635)
!667 = !DILocation(line: 514, column: 0, scope: !635)
!668 = !DILocation(line: 515, column: 0, scope: !635)
!669 = !DILocation(line: 516, column: 0, scope: !635)
!670 = !DILocation(line: 517, column: 0, scope: !635)
!671 = !DILocation(line: 518, column: 0, scope: !635)
!672 = !DILocation(line: 519, column: 0, scope: !635)
!673 = !DILocation(line: 520, column: 0, scope: !635)
!674 = !DILocation(line: 521, column: 0, scope: !635)
!675 = !DILocation(line: 522, column: 0, scope: !635)
!676 = !DILocation(line: 523, column: 0, scope: !635)
!677 = !DILocation(line: 524, column: 0, scope: !635)
!678 = !DILocation(line: 525, column: 0, scope: !635)
!679 = !DILocation(line: 526, column: 0, scope: !635)
!680 = !DILocation(line: 527, column: 0, scope: !635)
!681 = !DILocation(line: 528, column: 0, scope: !635)
!682 = !DILocation(line: 529, column: 0, scope: !635)
!683 = !DILocation(line: 530, column: 0, scope: !635)
!684 = !DILocation(line: 531, column: 0, scope: !635)
!685 = !DILocation(line: 532, column: 0, scope: !635)
!686 = !DILocation(line: 533, column: 0, scope: !635)
!687 = !DILocation(line: 534, column: 0, scope: !635)
!688 = !DILocation(line: 535, column: 0, scope: !635)
!689 = !DILocation(line: 536, column: 0, scope: !635)
!690 = !DILocation(line: 537, column: 0, scope: !635)
!691 = !DILocation(line: 538, column: 0, scope: !635)
!692 = !DILocation(line: 539, column: 0, scope: !635)
!693 = !DILocation(line: 540, column: 0, scope: !635)
!694 = !DILocation(line: 541, column: 0, scope: !635)
!695 = !DILocation(line: 542, column: 0, scope: !635)
!696 = !DILocation(line: 543, column: 0, scope: !635)
!697 = !DILocation(line: 544, column: 0, scope: !635)
!700 = !DILocation(line: 547, column: 0, scope: !698)
!701 = !DILocation(line: 548, column: 0, scope: !698)
!702 = !DILocation(line: 549, column: 0, scope: !698)
!703 = !DILocation(line: 550, column: 0, scope: !698)
!704 = !DILocation(line: 551, column: 0, scope: !698)
!705 = !DILocation(line: 552, column: 0, scope: !698)
!706 = !DILocation(line: 553, column: 0, scope: !698)
!707 = !DILocation(line: 554, column: 0, scope: !698)
!708 = !DILocation(line: 555, column: 0, scope: !698)
!709 = !DILocation(line: 556, column: 0, scope: !698)
!710 = !DILocation(line: 557, column: 0, scope: !698)
!711 = !DILocation(line: 558, column: 0, scope: !698)
!712 = !DILocation(line: 559, column: 0, scope: !698)
!713 = !DILocation(line: 561, column: 0, scope: !698)
!714 = !DILocation(line: 562, column: 0, scope: !698)
!715 = !DILocation(line: 563, column: 0, scope: !698)
!716 = !DILocation(line: 564, column: 0, scope: !698)
!717 = !DILocation(line: 565, column: 0, scope: !698)

; TBAA metadata
!0 = !{!"NOVA TBAA"}
!1 = !{!"list_data_ptr", !0}
!2 = !{!1, !1, i64 0}
!3 = !{!"list_elem", !0}
!4 = !{!3, !3, i64 0}
!5 = !{!"list_size", !0}
!6 = !{!5, !5, i64 0}
!90 = !{!"branch_weights", i32 2000, i32 1}
