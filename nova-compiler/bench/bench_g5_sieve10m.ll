; NOVA IR-Pipeline Compiler Output
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

@__nova_error_flag = thread_local global i64 0
@__nova_error_msg = thread_local global i64 0

; Runtime declarations
declare i32 @puts(ptr) nounwind
declare i32 @printf(ptr, ...) nounwind
declare i32 @strcmp(ptr, ptr) nounwind
declare i64 @nova_rt_list_create() nounwind
declare i64 @nova_rt_deep_copy(i64) nounwind
declare i64 @nova_rt_list_create_filled(i64, i64) nounwind
declare i64 @nova_rt_list_append(i64, i64) nounwind
declare i64 @nova_rt_list_get(i64, i64) nounwind
declare i64 @nova_rt_list_len(i64) nounwind
declare i64 @nova_rt_dict_create() nounwind
declare i64 @nova_rt_dict_set(i64, i64, i64) nounwind
declare i64 @nova_rt_dict_get(i64, i64) nounwind
declare i64 @nova_rt_dict_contains(i64, i64) nounwind
declare i64 @nova_rt_str_concat(i64, i64) nounwind
declare i64 @nova_rt_int_to_str(i64) nounwind
declare i64 @nova_rt_parse_int(i64) nounwind
declare i64 @nova_rt_len(i64) nounwind
declare i64 @nova_rt_len_any(i64) nounwind
declare i64 @nova_rt_ord(i64) nounwind
declare i64 @nova_rt_chr(i64) nounwind
declare i64 @nova_rt_contains(i64, i64) nounwind
declare i64 @nova_rt_index_get(i64, i64) nounwind
declare i64 @nova_rt_index_set(i64, i64, i64) nounwind
declare i64 @nova_rt_add(i64, i64) nounwind
declare i64 @nova_rt_sub(i64, i64) nounwind
declare i64 @nova_rt_mul(i64, i64) nounwind
declare i64 @nova_rt_div(i64, i64) nounwind
declare i64 @nova_rt_eq(i64, i64) nounwind
declare i64 @nova_rt_neq(i64, i64) nounwind
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
declare i64 @nova_rt_starts_with(i64, i64) nounwind
declare i64 @nova_rt_ends_with(i64, i64) nounwind
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
declare i64 @nova_rt_dict_keys(i64) nounwind
declare i64 @nova_rt_dict_values(i64) nounwind
declare i64 @nova_rt_dict_items(i64) nounwind
declare i64 @nova_rt_for_iter_init(i64) nounwind
declare i64 @nova_rt_dict_has(i64, i64) nounwind
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
declare i64 @nova_rt_find(i64, i64) nounwind
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
declare i64 @nova_rt_path_exists(i64) nounwind
declare i64 @nova_rt_path_parent(i64) nounwind
declare i64 @nova_rt_path_name(i64) nounwind
declare i64 @nova_rt_read_bytes(i64) nounwind
declare i64 @nova_rt_write_raw(i64) nounwind
declare i64 @nova_rt_abs(i64) nounwind
declare i64 @nova_rt_max(i64, i64) nounwind
declare i64 @nova_rt_min(i64, i64) nounwind
declare i64 @nova_rt_sqrt(i64) nounwind
declare i64 @nova_rt_floor(i64) nounwind
declare i64 @nova_rt_ceil(i64) nounwind
declare i64 @nova_rt_pow(i64, i64) nounwind
declare i64 @nova_rt_round(i64) nounwind
declare i64 @nova_rt_sin(i64) nounwind
declare i64 @nova_rt_cos(i64) nounwind
declare i64 @nova_rt_tan(i64) nounwind
declare i64 @nova_rt_log(i64) nounwind
declare i64 @nova_rt_log2(i64) nounwind
declare i64 @nova_rt_log10(i64) nounwind
declare i64 @nova_rt_exp(i64) nounwind
declare i64 @nova_rt_fabs(i64) nounwind
declare i64 @nova_rt_fmax(i64, i64) nounwind
declare i64 @nova_rt_fmin(i64, i64) nounwind
declare i64 @nova_rt_fmod(i64, i64) nounwind
declare i64 @nova_rt_float_to_int(i64) nounwind
declare i64 @nova_rt_int_to_float(i64) nounwind
declare i64 @nova_rt_to_int(i64) nounwind
declare i64 @nova_rt_to_float(i64) nounwind
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
declare i64 @nova_rt_asin(i64) nounwind
declare i64 @nova_rt_acos(i64) nounwind
declare i64 @nova_rt_atan(i64) nounwind
declare i64 @nova_rt_atan2(i64, i64) nounwind
declare i64 @nova_rt_int_pow(i64, i64) nounwind
declare i64 @nova_rt_alloc_count() nounwind
declare i64 @nova_rt_live_count() nounwind
declare i64 @nova_rt_enumerate(i64) nounwind
declare i64 @nova_rt_zip(i64, i64) nounwind
declare i64 @nova_rt_reduce(i64, i64, i64) nounwind
declare i64 @nova_rt_any_match(i64, i64) nounwind
declare i64 @nova_rt_all_match(i64, i64) nounwind
declare i64 @nova_rt_sum(i64) nounwind
declare i64 @nova_rt_index_of(i64, i64) nounwind
declare i64 @nova_rt_sort_by(i64, i64) nounwind
declare i64 @nova_rt_dict_merge(i64, i64) nounwind
declare i64 @nova_rt_str_count(i64, i64) nounwind
declare i64 @nova_rt_lstrip(i64) nounwind
declare i64 @nova_rt_rstrip(i64) nounwind
declare i64 @nova_rt_pad_left(i64, i64, i64) nounwind
declare i64 @nova_rt_pad_right(i64, i64, i64) nounwind
declare i64 @nova_rt_cwd() nounwind
declare i64 @nova_rt_list_dir(i64) nounwind
declare i64 @nova_rt_hash(i64) nounwind
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
declare i64 @nova_rt_is_ok(i64) nounwind
declare i64 @nova_rt_is_err(i64) nounwind
declare i64 @nova_rt_is_some(i64) nounwind
declare i64 @nova_rt_is_none(i64) nounwind
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

define i64 @count_primes(i64 %p0) nounwind !dbg !200 {
entry:
  %slot.limit = alloca i64, align 8, !dbg !201
  store i64 %p0, ptr %slot.limit, align 8, !dbg !201
  %slot.sieve = alloca i64, align 8, !dbg !201
  store i64 0, ptr %slot.sieve, align 8, !dbg !201
  %slot.idx = alloca i64, align 8, !dbg !201
  store i64 0, ptr %slot.idx, align 8, !dbg !201
  %slot.count = alloca i64, align 8, !dbg !201
  store i64 0, ptr %slot.count, align 8, !dbg !201
  %slot.i = alloca i64, align 8, !dbg !201
  store i64 0, ptr %slot.i, align 8, !dbg !201
  %slot.j = alloca i64, align 8, !dbg !201
  store i64 0, ptr %slot.j, align 8, !dbg !201
  %r0 = load i64, ptr %slot.limit, align 8, !dbg !201
  %r1 = add i64 1, 0, !dbg !201
  %r2 = add i64 %r0, %r1, !dbg !201
  %r3 = add i64 0, 0, !dbg !201
  %r4 = call i64 @nova_rt_list_create_filled(i64 %r2, i64 %r3), !dbg !201
  store i64 %r4, ptr %slot.sieve, align 8, !dbg !201
  %r5 = add i64 0, 0, !dbg !201
  %r6 = call i64 @nova_rt_max(i64 %r5, i64 %r2), !dbg !201
  store i64 %r6, ptr %slot.idx, align 8, !dbg !201
  %r7 = add i64 0, 0, !dbg !202
  store i64 %r7, ptr %slot.count, align 8, !dbg !202
  %r8 = add i64 2, 0, !dbg !203
  store i64 %r8, ptr %slot.i, align 8, !dbg !203
  br label %while_hdr0, !llvm.loop !91, !dbg !204
while_hdr0:
  %r9 = load i64, ptr %slot.i, align 8, !dbg !204
  %r10 = load i64, ptr %slot.limit, align 8, !dbg !204
  %r11.cmp = icmp sle i64 %r9, %r10, !dbg !204
  %r11 = zext i1 %r11.cmp to i64, !dbg !204
  %br_while_body1 = icmp ne i64 %r11, 0, !dbg !204
  br i1 %br_while_body1, label %while_body1, label %while_exit2, !prof !90, !dbg !204
while_body1:
  %r12 = load i64, ptr %slot.sieve, align 8, !dbg !205
  %r13 = load i64, ptr %slot.i, align 8, !dbg !205
  %r14.lp = inttoptr i64 %r12 to ptr, !dbg !205
  %r14.dp = load ptr, ptr %r14.lp, align 8, !tbaa !2, !dbg !205
  %r14.ep = getelementptr i64, ptr %r14.dp, i64 %r13, !dbg !205
  %r14 = load i64, ptr %r14.ep, align 8, !tbaa !4, !dbg !205
  %r15 = add i64 0, 0, !dbg !205
  %r16.cmp = icmp eq i64 %r14, %r15, !dbg !205
  %r16 = zext i1 %r16.cmp to i64, !dbg !205
  %br_then3 = icmp ne i64 %r16, 0, !dbg !205
  br i1 %br_then3, label %then3, label %else4, !dbg !205
then3:
  %r17 = load i64, ptr %slot.count, align 8, !dbg !206
  %r18 = add i64 1, 0, !dbg !206
  %r19 = add i64 %r17, %r18, !dbg !206
  store i64 %r19, ptr %slot.count, align 8, !dbg !206
  %r20 = load i64, ptr %slot.i, align 8, !dbg !207
  %r21 = load i64, ptr %slot.i, align 8, !dbg !207
  %r22 = mul i64 %r20, %r21, !dbg !207
  store i64 %r22, ptr %slot.j, align 8, !dbg !207
  br label %while_hdr6, !llvm.loop !91, !dbg !208
while_hdr6:
  %r23 = load i64, ptr %slot.j, align 8, !dbg !208
  %r24 = load i64, ptr %slot.limit, align 8, !dbg !208
  %r25.cmp = icmp sle i64 %r23, %r24, !dbg !208
  %r25 = zext i1 %r25.cmp to i64, !dbg !208
  %br_while_body7 = icmp ne i64 %r25, 0, !dbg !208
  br i1 %br_while_body7, label %while_body7, label %while_exit8, !prof !90, !dbg !208
while_body7:
  %r26 = add i64 1, 0, !dbg !209
  %r27 = load i64, ptr %slot.sieve, align 8, !dbg !209
  %r28 = load i64, ptr %slot.j, align 8, !dbg !209
  %_is.lp0 = inttoptr i64 %r27 to ptr, !dbg !209
  %_is.dp1 = load ptr, ptr %_is.lp0, align 8, !tbaa !2, !dbg !209
  %_is.ep2 = getelementptr i64, ptr %_is.dp1, i64 %r28, !dbg !209
  store i64 %r26, ptr %_is.ep2, align 8, !tbaa !4, !dbg !209
  %r29 = load i64, ptr %slot.j, align 8, !dbg !210
  %r30 = load i64, ptr %slot.i, align 8, !dbg !210
  %r31 = add i64 %r29, %r30, !dbg !210
  store i64 %r31, ptr %slot.j, align 8, !dbg !210
  br label %while_hdr6, !llvm.loop !91, !dbg !210
while_exit8:
  br label %endif5, !dbg !210
else4:
  br label %endif5, !dbg !210
endif5:
  %r32 = load i64, ptr %slot.i, align 8, !dbg !211
  %r33 = add i64 1, 0, !dbg !211
  %r34 = add i64 %r32, %r33, !dbg !211
  store i64 %r34, ptr %slot.i, align 8, !dbg !211
  br label %while_hdr0, !llvm.loop !91, !dbg !211
while_exit2:
  %r35 = load i64, ptr %slot.count, align 8, !dbg !212
  ret i64 %r35, !dbg !212
}

define i64 @nova_main() nounwind {
entry:
  %slot.result = alloca i64, align 8
  store i64 0, ptr %slot.result, align 8
  %r0 = add i64 10000000, 0
  %r1 = call i64 @count_primes(i64 %r0)
  store i64 %r1, ptr %slot.result, align 8
  %r2.p = getelementptr inbounds [19 x i8], ptr @.str.0, i64 0, i64 0
  %r2 = ptrtoint ptr %r2.p to i64
  %r3 = load i64, ptr %slot.result, align 8
  %r4 = call i64 @nova_rt_int_to_str(i64 %r3)
  %r5 = call i64 @nova_rt_str_concat(i64 %r2, i64 %r4)
  %r6 = call i64 @nova_rt_print_str(i64 %r5)
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
@.str.0 = private unnamed_addr constant [19 x i8] c"Primes up to 10M: \00"

; Debug metadata
!llvm.dbg.cu = !{!100}
!llvm.module.flags = !{!102, !103}

!100 = distinct !DICompileUnit(language: DW_LANG_C99, file: !101, producer: "NOVA Compiler", isOptimized: false, emissionKind: LineTablesOnly)
!101 = !DIFile(filename: "sieve_tmp.nova", directory: ".")
!102 = !{i32 2, !"CodeView", i32 1}
!103 = !{i32 2, !"Debug Info Version", i32 3}
!104 = !DISubroutineType(types: !105)
!105 = !{null}
!200 = distinct !DISubprogram(name: "count_primes", scope: !101, file: !101, line: 4, type: !104, scopeLine: 4, spFlags: DISPFlagDefinition, unit: !100)
!201 = !DILocation(line: 4, column: 0, scope: !200)
!202 = !DILocation(line: 10, column: 0, scope: !200)
!203 = !DILocation(line: 11, column: 0, scope: !200)
!204 = !DILocation(line: 12, column: 0, scope: !200)
!205 = !DILocation(line: 13, column: 0, scope: !200)
!206 = !DILocation(line: 14, column: 0, scope: !200)
!207 = !DILocation(line: 15, column: 0, scope: !200)
!208 = !DILocation(line: 16, column: 0, scope: !200)
!209 = !DILocation(line: 17, column: 0, scope: !200)
!210 = !DILocation(line: 18, column: 0, scope: !200)
!211 = !DILocation(line: 19, column: 0, scope: !200)
!212 = !DILocation(line: 20, column: 0, scope: !200)

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
