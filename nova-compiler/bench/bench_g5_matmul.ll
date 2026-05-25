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

define i64 @make_mat(i64 %p0, i64 %p1) nounwind !dbg !200 {
entry:
  %slot.n = alloca i64, align 8, !dbg !201
  store i64 %p0, ptr %slot.n, align 8, !dbg !201
  %slot.seed = alloca i64, align 8, !dbg !201
  store i64 %p1, ptr %slot.seed, align 8, !dbg !201
  %slot.m = alloca i64, align 8, !dbg !201
  store i64 0, ptr %slot.m, align 8, !dbg !201
  %slot.i = alloca i64, align 8, !dbg !201
  store i64 0, ptr %slot.i, align 8, !dbg !201
  %r0 = call i64 @nova_rt_list_create(), !dbg !202
  store i64 %r0, ptr %slot.m, align 8, !dbg !202
  %r1 = add i64 0, 0, !dbg !203
  store i64 %r1, ptr %slot.i, align 8, !dbg !203
  br label %while_hdr0, !dbg !204
while_hdr0:
  %r2 = load i64, ptr %slot.i, align 8, !dbg !204
  %r3 = load i64, ptr %slot.n, align 8, !dbg !204
  %r4 = load i64, ptr %slot.n, align 8, !dbg !204
  %r5 = mul i64 %r3, %r4, !dbg !204
  %r6.cmp = icmp slt i64 %r2, %r5, !dbg !204
  %r6 = zext i1 %r6.cmp to i64, !dbg !204
  %br_while_body1 = icmp ne i64 %r6, 0, !dbg !204
  br i1 %br_while_body1, label %while_body1, label %while_exit2, !prof !90, !dbg !204
while_body1:
  %r7 = load i64, ptr %slot.m, align 8, !dbg !205
  %r8 = load i64, ptr %slot.seed, align 8, !dbg !205
  %r9 = load i64, ptr %slot.i, align 8, !dbg !205
  %r10 = add i64 7, 0, !dbg !205
  %r11 = srem i64 %r9, %r10, !dbg !205
  %r12 = add i64 %r8, %r11, !dbg !205
  %r13 = call i64 @nova_rt_list_append(i64 %r7, i64 %r12), !dbg !205
  %r14 = load i64, ptr %slot.i, align 8, !dbg !206
  %r15 = add i64 1, 0, !dbg !206
  %r16 = add i64 %r14, %r15, !dbg !206
  store i64 %r16, ptr %slot.i, align 8, !dbg !206
  br label %while_hdr0, !dbg !206
while_exit2:
  %r17 = load i64, ptr %slot.m, align 8, !dbg !207
  ret i64 %r17, !dbg !207
}

define i64 @mat_mul(i64 %p0, i64 %p1, i64 %p2) nounwind !dbg !208 {
entry:
  %slot.a = alloca i64, align 8, !dbg !209
  store i64 %p0, ptr %slot.a, align 8, !dbg !209
  %slot.b = alloca i64, align 8, !dbg !209
  store i64 %p1, ptr %slot.b, align 8, !dbg !209
  %slot.n = alloca i64, align 8, !dbg !209
  store i64 %p2, ptr %slot.n, align 8, !dbg !209
  %slot.c = alloca i64, align 8, !dbg !209
  store i64 0, ptr %slot.c, align 8, !dbg !209
  %slot.k = alloca i64, align 8, !dbg !209
  store i64 0, ptr %slot.k, align 8, !dbg !209
  %slot.i = alloca i64, align 8, !dbg !209
  store i64 0, ptr %slot.i, align 8, !dbg !209
  %slot.j = alloca i64, align 8, !dbg !209
  store i64 0, ptr %slot.j, align 8, !dbg !209
  %slot.s = alloca i64, align 8, !dbg !209
  store i64 0, ptr %slot.s, align 8, !dbg !209
  %r0 = call i64 @nova_rt_list_create(), !dbg !210
  store i64 %r0, ptr %slot.c, align 8, !dbg !210
  %r1 = add i64 0, 0, !dbg !211
  store i64 %r1, ptr %slot.k, align 8, !dbg !211
  br label %while_hdr3, !dbg !212
while_hdr3:
  %r2 = load i64, ptr %slot.k, align 8, !dbg !212
  %r3 = load i64, ptr %slot.n, align 8, !dbg !212
  %r4 = load i64, ptr %slot.n, align 8, !dbg !212
  %r5 = mul i64 %r3, %r4, !dbg !212
  %r6.cmp = icmp slt i64 %r2, %r5, !dbg !212
  %r6 = zext i1 %r6.cmp to i64, !dbg !212
  %br_while_body4 = icmp ne i64 %r6, 0, !dbg !212
  br i1 %br_while_body4, label %while_body4, label %while_exit5, !prof !90, !dbg !212
while_body4:
  %r7 = load i64, ptr %slot.c, align 8, !dbg !213
  %r8 = add i64 0, 0, !dbg !213
  %r9 = call i64 @nova_rt_list_append(i64 %r7, i64 %r8), !dbg !213
  %r10 = load i64, ptr %slot.k, align 8, !dbg !214
  %r11 = add i64 1, 0, !dbg !214
  %r12 = add i64 %r10, %r11, !dbg !214
  store i64 %r12, ptr %slot.k, align 8, !dbg !214
  br label %while_hdr3, !dbg !214
while_exit5:
  %r13 = add i64 0, 0, !dbg !215
  store i64 %r13, ptr %slot.i, align 8, !dbg !215
  br label %while_hdr6, !dbg !216
while_hdr6:
  %r14 = load i64, ptr %slot.i, align 8, !dbg !216
  %r15 = load i64, ptr %slot.n, align 8, !dbg !216
  %r16.cmp = icmp slt i64 %r14, %r15, !dbg !216
  %r16 = zext i1 %r16.cmp to i64, !dbg !216
  %br_while_body7 = icmp ne i64 %r16, 0, !dbg !216
  br i1 %br_while_body7, label %while_body7, label %while_exit8, !prof !90, !dbg !216
while_body7:
  %r17 = add i64 0, 0, !dbg !217
  store i64 %r17, ptr %slot.j, align 8, !dbg !217
  br label %while_hdr9, !dbg !218
while_hdr9:
  %r18 = load i64, ptr %slot.j, align 8, !dbg !218
  %r19 = load i64, ptr %slot.n, align 8, !dbg !218
  %r20.cmp = icmp slt i64 %r18, %r19, !dbg !218
  %r20 = zext i1 %r20.cmp to i64, !dbg !218
  %br_while_body10 = icmp ne i64 %r20, 0, !dbg !218
  br i1 %br_while_body10, label %while_body10, label %while_exit11, !prof !90, !dbg !218
while_body10:
  %r21 = add i64 0, 0, !dbg !219
  store i64 %r21, ptr %slot.s, align 8, !dbg !219
  %r22 = add i64 0, 0, !dbg !220
  store i64 %r22, ptr %slot.k, align 8, !dbg !220
  br label %while_hdr12, !dbg !221
while_hdr12:
  %r23 = load i64, ptr %slot.k, align 8, !dbg !221
  %r24 = load i64, ptr %slot.n, align 8, !dbg !221
  %r25.cmp = icmp slt i64 %r23, %r24, !dbg !221
  %r25 = zext i1 %r25.cmp to i64, !dbg !221
  %br_while_body13 = icmp ne i64 %r25, 0, !dbg !221
  br i1 %br_while_body13, label %while_body13, label %while_exit14, !prof !90, !dbg !221
while_body13:
  %r26 = load i64, ptr %slot.s, align 8, !dbg !222
  %r27 = load i64, ptr %slot.a, align 8, !dbg !222
  %r28 = load i64, ptr %slot.i, align 8, !dbg !222
  %r29 = load i64, ptr %slot.n, align 8, !dbg !222
  %r30 = mul i64 %r28, %r29, !dbg !222
  %r31 = load i64, ptr %slot.k, align 8, !dbg !222
  %r32 = add i64 %r30, %r31, !dbg !222
  %r33.lp = inttoptr i64 %r27 to ptr, !dbg !222
  %r33.dp = load ptr, ptr %r33.lp, align 8, !tbaa !2, !dbg !222
  %r33.szp = getelementptr i64, ptr %r33.lp, i64 1, !dbg !222
  %r33.sz = load i64, ptr %r33.szp, align 8, !tbaa !6, !dbg !222
  %r33.neg = icmp slt i64 %r32, 0, !dbg !222
  %r33.adj = add i64 %r32, %r33.sz, !dbg !222
  %r33.fi = select i1 %r33.neg, i64 %r33.adj, i64 %r32, !dbg !222
  %r33.ep = getelementptr i64, ptr %r33.dp, i64 %r33.fi, !dbg !222
  %r33 = load i64, ptr %r33.ep, align 8, !tbaa !4, !dbg !222
  %r34 = load i64, ptr %slot.b, align 8, !dbg !222
  %r35 = load i64, ptr %slot.k, align 8, !dbg !222
  %r36 = load i64, ptr %slot.n, align 8, !dbg !222
  %r37 = mul i64 %r35, %r36, !dbg !222
  %r38 = load i64, ptr %slot.j, align 8, !dbg !222
  %r39 = add i64 %r37, %r38, !dbg !222
  %r40.lp = inttoptr i64 %r34 to ptr, !dbg !222
  %r40.dp = load ptr, ptr %r40.lp, align 8, !tbaa !2, !dbg !222
  %r40.szp = getelementptr i64, ptr %r40.lp, i64 1, !dbg !222
  %r40.sz = load i64, ptr %r40.szp, align 8, !tbaa !6, !dbg !222
  %r40.neg = icmp slt i64 %r39, 0, !dbg !222
  %r40.adj = add i64 %r39, %r40.sz, !dbg !222
  %r40.fi = select i1 %r40.neg, i64 %r40.adj, i64 %r39, !dbg !222
  %r40.ep = getelementptr i64, ptr %r40.dp, i64 %r40.fi, !dbg !222
  %r40 = load i64, ptr %r40.ep, align 8, !tbaa !4, !dbg !222
  %r41 = mul i64 %r33, %r40, !dbg !222
  %r42 = add i64 %r26, %r41, !dbg !222
  store i64 %r42, ptr %slot.s, align 8, !dbg !222
  %r43 = load i64, ptr %slot.k, align 8, !dbg !223
  %r44 = add i64 1, 0, !dbg !223
  %r45 = add i64 %r43, %r44, !dbg !223
  store i64 %r45, ptr %slot.k, align 8, !dbg !223
  br label %while_hdr12, !dbg !223
while_exit14:
  %r46 = load i64, ptr %slot.s, align 8, !dbg !224
  %r47 = load i64, ptr %slot.c, align 8, !dbg !224
  %r48 = load i64, ptr %slot.i, align 8, !dbg !224
  %r49 = load i64, ptr %slot.n, align 8, !dbg !224
  %r50 = mul i64 %r48, %r49, !dbg !224
  %r51 = load i64, ptr %slot.j, align 8, !dbg !224
  %r52 = add i64 %r50, %r51, !dbg !224
  %_is.lp0 = inttoptr i64 %r47 to ptr, !dbg !224
  %_is.dp1 = load ptr, ptr %_is.lp0, align 8, !tbaa !2, !dbg !224
  %_is.szp3 = getelementptr i64, ptr %_is.lp0, i64 1, !dbg !224
  %_is.sz4 = load i64, ptr %_is.szp3, align 8, !tbaa !6, !dbg !224
  %_is.neg5 = icmp slt i64 %r52, 0, !dbg !224
  %_is.adj6 = add i64 %r52, %_is.sz4, !dbg !224
  %_is.fi7 = select i1 %_is.neg5, i64 %_is.adj6, i64 %r52, !dbg !224
  %_is.ep2 = getelementptr i64, ptr %_is.dp1, i64 %_is.fi7, !dbg !224
  store i64 %r46, ptr %_is.ep2, align 8, !tbaa !4, !dbg !224
  %r53 = load i64, ptr %slot.j, align 8, !dbg !225
  %r54 = add i64 1, 0, !dbg !225
  %r55 = add i64 %r53, %r54, !dbg !225
  store i64 %r55, ptr %slot.j, align 8, !dbg !225
  br label %while_hdr9, !dbg !225
while_exit11:
  %r56 = load i64, ptr %slot.i, align 8, !dbg !226
  %r57 = add i64 1, 0, !dbg !226
  %r58 = add i64 %r56, %r57, !dbg !226
  store i64 %r58, ptr %slot.i, align 8, !dbg !226
  br label %while_hdr6, !dbg !226
while_exit8:
  %r59 = load i64, ptr %slot.c, align 8, !dbg !227
  ret i64 %r59, !dbg !227
}

define i64 @nova_main() nounwind {
entry:
  %slot.n = alloca i64, align 8
  store i64 0, ptr %slot.n, align 8
  %slot.a = alloca i64, align 8
  store i64 0, ptr %slot.a, align 8
  %slot.b = alloca i64, align 8
  store i64 0, ptr %slot.b, align 8
  %slot.c = alloca i64, align 8
  store i64 0, ptr %slot.c, align 8
  %slot.total = alloca i64, align 8
  store i64 0, ptr %slot.total, align 8
  %slot.i = alloca i64, align 8
  store i64 0, ptr %slot.i, align 8
  %r0 = add i64 300, 0
  store i64 %r0, ptr %slot.n, align 8
  %r1 = load i64, ptr %slot.n, align 8
  %r2 = add i64 1, 0
  %r3 = call i64 @make_mat(i64 %r1, i64 %r2)
  store i64 %r3, ptr %slot.a, align 8
  %r4 = load i64, ptr %slot.n, align 8
  %r5 = add i64 2, 0
  %r6 = call i64 @make_mat(i64 %r4, i64 %r5)
  store i64 %r6, ptr %slot.b, align 8
  %r7 = load i64, ptr %slot.a, align 8
  %r8 = load i64, ptr %slot.b, align 8
  %r9 = load i64, ptr %slot.n, align 8
  %r10 = call i64 @mat_mul(i64 %r7, i64 %r8, i64 %r9)
  store i64 %r10, ptr %slot.c, align 8
  %r11 = add i64 0, 0
  store i64 %r11, ptr %slot.total, align 8
  %r12 = add i64 0, 0
  store i64 %r12, ptr %slot.i, align 8
  br label %while_hdr15
while_hdr15:
  %r13 = load i64, ptr %slot.i, align 8
  %r14 = load i64, ptr %slot.n, align 8
  %r15 = load i64, ptr %slot.n, align 8
  %r16 = mul i64 %r14, %r15
  %r17.cmp = icmp slt i64 %r13, %r16
  %r17 = zext i1 %r17.cmp to i64
  %br_while_body16 = icmp ne i64 %r17, 0
  br i1 %br_while_body16, label %while_body16, label %while_exit17, !prof !90
while_body16:
  %r18 = load i64, ptr %slot.total, align 8
  %r19 = load i64, ptr %slot.c, align 8
  %r20 = load i64, ptr %slot.i, align 8
  %r21 = call i64 @nova_rt_index_get(i64 %r19, i64 %r20)
  %r22 = add i64 %r18, %r21
  store i64 %r22, ptr %slot.total, align 8
  %r23 = load i64, ptr %slot.i, align 8
  %r24 = add i64 1, 0
  %r25 = add i64 %r23, %r24
  store i64 %r25, ptr %slot.i, align 8
  br label %while_hdr15
while_exit17:
  %r26.p = getelementptr inbounds [26 x i8], ptr @.str.0, i64 0, i64 0
  %r26 = ptrtoint ptr %r26.p to i64
  %r27 = load i64, ptr %slot.total, align 8
  %r28 = call i64 @nova_rt_int_to_str(i64 %r27)
  %r29 = call i64 @nova_rt_str_concat(i64 %r26, i64 %r28)
  %r30 = call i64 @nova_rt_print_str(i64 %r29)
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
@.str.0 = private unnamed_addr constant [26 x i8] c"Matmul 300x300 checksum: \00"

; Debug metadata
!llvm.dbg.cu = !{!100}
!llvm.module.flags = !{!102, !103}

!100 = distinct !DICompileUnit(language: DW_LANG_C99, file: !101, producer: "NOVA Compiler", isOptimized: false, emissionKind: LineTablesOnly)
!101 = !DIFile(filename: "bench_g5_matmul.nova", directory: ".")
!102 = !{i32 2, !"CodeView", i32 1}
!103 = !{i32 2, !"Debug Info Version", i32 3}
!104 = !DISubroutineType(types: !105)
!105 = !{null}
!200 = distinct !DISubprogram(name: "make_mat", scope: !101, file: !101, line: 5, type: !104, scopeLine: 5, spFlags: DISPFlagDefinition, unit: !100)
!201 = !DILocation(line: 5, column: 0, scope: !200)
!208 = distinct !DISubprogram(name: "mat_mul", scope: !101, file: !101, line: 13, type: !104, scopeLine: 13, spFlags: DISPFlagDefinition, unit: !100)
!209 = !DILocation(line: 13, column: 0, scope: !208)
!202 = !DILocation(line: 6, column: 0, scope: !200)
!203 = !DILocation(line: 7, column: 0, scope: !200)
!204 = !DILocation(line: 8, column: 0, scope: !200)
!205 = !DILocation(line: 9, column: 0, scope: !200)
!206 = !DILocation(line: 10, column: 0, scope: !200)
!207 = !DILocation(line: 11, column: 0, scope: !200)
!210 = !DILocation(line: 14, column: 0, scope: !208)
!211 = !DILocation(line: 15, column: 0, scope: !208)
!212 = !DILocation(line: 16, column: 0, scope: !208)
!213 = !DILocation(line: 17, column: 0, scope: !208)
!214 = !DILocation(line: 18, column: 0, scope: !208)
!215 = !DILocation(line: 19, column: 0, scope: !208)
!216 = !DILocation(line: 20, column: 0, scope: !208)
!217 = !DILocation(line: 21, column: 0, scope: !208)
!218 = !DILocation(line: 22, column: 0, scope: !208)
!219 = !DILocation(line: 23, column: 0, scope: !208)
!220 = !DILocation(line: 24, column: 0, scope: !208)
!221 = !DILocation(line: 25, column: 0, scope: !208)
!222 = !DILocation(line: 26, column: 0, scope: !208)
!223 = !DILocation(line: 27, column: 0, scope: !208)
!224 = !DILocation(line: 28, column: 0, scope: !208)
!225 = !DILocation(line: 29, column: 0, scope: !208)
!226 = !DILocation(line: 30, column: 0, scope: !208)
!227 = !DILocation(line: 31, column: 0, scope: !208)

; TBAA metadata
!0 = !{!"NOVA TBAA"}
!1 = !{!"list_data_ptr", !0}
!2 = !{!1, !1, i64 0}
!3 = !{!"list_elem", !0}
!4 = !{!3, !3, i64 0}
!5 = !{!"list_size", !0}
!6 = !{!5, !5, i64 0}
!90 = !{!"branch_weights", i32 2000, i32 1}
