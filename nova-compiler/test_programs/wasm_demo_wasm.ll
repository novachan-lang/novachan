; NOVA IR-Pipeline Compiler Output
target triple = "wasm32-unknown-wasi"

@__nova_error_flag = global i64 0
@__nova_error_msg = global i64 0

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
declare i64 @nova_rt_flatten(i64) nounwind
declare i64 @nova_rt_pmap(i64, i64) nounwind
declare i64 @nova_rt_pfilter(i64, i64) nounwind
declare i64 @nova_rt_pfor(i64, i64, i64) nounwind
declare i64 @nova_rt_cpu_count() nounwind
declare i64 @nova_rt_http_listen(i64) nounwind
declare i64 @nova_rt_http_accept_raw(i64) nounwind
declare void @nova_rt_http_send_raw(i64, i64) nounwind

define i64 @fib(i64 %p0) nounwind {
entry:
  %slot.n = alloca i64, align 8
  store i64 %p0, ptr %slot.n, align 8
  %r0 = load i64, ptr %slot.n, align 8
  %r1 = add i64 2, 0
  %r2.cmp = icmp slt i64 %r0, %r1
  %r2 = zext i1 %r2.cmp to i64
  %br_then0 = icmp ne i64 %r2, 0
  br i1 %br_then0, label %then0, label %else1
then0:
  %r3 = load i64, ptr %slot.n, align 8
  ret i64 %r3
else1:
  br label %endif2
endif2:
  %r4 = load i64, ptr %slot.n, align 8
  %r5 = add i64 1, 0
  %r6 = sub i64 %r4, %r5
  %r7 = call i64 @fib(i64 %r6)
  %r8 = load i64, ptr %slot.n, align 8
  %r9 = add i64 2, 0
  %r10 = sub i64 %r8, %r9
  %r11 = call i64 @fib(i64 %r10)
  %r12 = add i64 %r7, %r11
  ret i64 %r12
}

define i64 @factorial(i64 %p0) nounwind {
entry:
  %slot.n = alloca i64, align 8
  store i64 %p0, ptr %slot.n, align 8
  %slot.r = alloca i64, align 8
  store i64 0, ptr %slot.r, align 8
  %slot.i = alloca i64, align 8
  store i64 0, ptr %slot.i, align 8
  %r0 = add i64 1, 0
  store i64 %r0, ptr %slot.r, align 8
  %r1 = add i64 2, 0
  store i64 %r1, ptr %slot.i, align 8
  br label %while_hdr3, !llvm.loop !91
while_hdr3:
  %r2 = load i64, ptr %slot.i, align 8
  %r3 = load i64, ptr %slot.n, align 8
  %r4.cmp = icmp sle i64 %r2, %r3
  %r4 = zext i1 %r4.cmp to i64
  %br_while_body4 = icmp ne i64 %r4, 0
  br i1 %br_while_body4, label %while_body4, label %while_exit5, !prof !90
while_body4:
  %r5 = load i64, ptr %slot.r, align 8
  %r6 = load i64, ptr %slot.i, align 8
  %r7 = mul i64 %r5, %r6
  store i64 %r7, ptr %slot.r, align 8
  %r8 = load i64, ptr %slot.i, align 8
  %r9 = add i64 1, 0
  %r10 = add i64 %r8, %r9
  store i64 %r10, ptr %slot.i, align 8
  br label %while_hdr3, !llvm.loop !91
while_exit5:
  %r11 = load i64, ptr %slot.r, align 8
  ret i64 %r11
}

define i64 @sum_squares(i64 %p0) nounwind {
entry:
  %slot.n = alloca i64, align 8
  store i64 %p0, ptr %slot.n, align 8
  %slot.total = alloca i64, align 8
  store i64 0, ptr %slot.total, align 8
  %slot.i = alloca i64, align 8
  store i64 0, ptr %slot.i, align 8
  %r0 = add i64 0, 0
  store i64 %r0, ptr %slot.total, align 8
  %r1 = add i64 1, 0
  store i64 %r1, ptr %slot.i, align 8
  br label %while_hdr6, !llvm.loop !91
while_hdr6:
  %r2 = load i64, ptr %slot.i, align 8
  %r3 = load i64, ptr %slot.n, align 8
  %r4.cmp = icmp sle i64 %r2, %r3
  %r4 = zext i1 %r4.cmp to i64
  %br_while_body7 = icmp ne i64 %r4, 0
  br i1 %br_while_body7, label %while_body7, label %while_exit8, !prof !90
while_body7:
  %r5 = load i64, ptr %slot.total, align 8
  %r6 = load i64, ptr %slot.i, align 8
  %r7 = load i64, ptr %slot.i, align 8
  %r8 = mul i64 %r6, %r7
  %r9 = add i64 %r5, %r8
  store i64 %r9, ptr %slot.total, align 8
  %r10 = load i64, ptr %slot.i, align 8
  %r11 = add i64 1, 0
  %r12 = add i64 %r10, %r11
  store i64 %r12, ptr %slot.i, align 8
  br label %while_hdr6, !llvm.loop !91
while_exit8:
  %r13 = load i64, ptr %slot.total, align 8
  ret i64 %r13
}

define i64 @nova_user_main() nounwind {
entry:
  %slot.a = alloca i64, align 8
  store i64 0, ptr %slot.a, align 8
  %slot.b = alloca i64, align 8
  store i64 0, ptr %slot.b, align 8
  %slot.c = alloca i64, align 8
  store i64 0, ptr %slot.c, align 8
  %r0 = add i64 15, 0
  %r1 = call i64 @fib(i64 %r0)
  store i64 %r1, ptr %slot.a, align 8
  %r2 = add i64 10, 0
  %r3 = call i64 @factorial(i64 %r2)
  store i64 %r3, ptr %slot.b, align 8
  %r4 = add i64 100, 0
  %r5 = call i64 @sum_squares(i64 %r4)
  store i64 %r5, ptr %slot.c, align 8
  %r6 = add i64 %r1, 0
  %r7 = add i64 %r3, 0
  %r8 = call i64 @nova_rt_add(i64 %r6, i64 %r7)
  %r9 = add i64 %r5, 0
  %r10 = call i64 @nova_rt_add(i64 %r8, i64 %r9)
  ret i64 %r10
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
