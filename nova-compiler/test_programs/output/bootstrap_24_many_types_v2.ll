; NOVA IR-Pipeline Compiler Output
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"

@__nova_error_flag = thread_local global i64 0
@__nova_error_msg = thread_local global i64 0

; Runtime declarations
declare i32 @puts(ptr) nounwind
declare i32 @printf(ptr, ...) nounwind
declare i32 @strcmp(ptr, ptr) nounwind
declare i64 @nova_rt_list_create() nounwind
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
declare i64 @nova_rt_float_bits(i64) nounwind
declare ptr @nova_rt_struct_alloc(i64) nounwind
declare i64 @nova_rt_slice(i64, i64, i64) nounwind
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
declare i64 @nova_rt_dict_has(i64, i64) nounwind
declare i64 @nova_rt_dict_del(i64, i64) nounwind
declare i64 @nova_rt_system(i64) nounwind
declare i64 @nova_rt_exec(i64) nounwind
declare i64 @nova_rt_create_string(ptr) nounwind
declare void @nova_rt_init_args(i64, i64) nounwind
declare void @nova_rt_wait_all() nounwind
declare void @nova_rt_cleanup() nounwind
declare i64 @nova_rt_parse_float(i64) nounwind
declare i64 @nova_rt_read_line() nounwind
declare i64 @nova_rt_append_file(i64, i64) nounwind
declare i64 @nova_rt_file_exists(i64) nounwind
declare i64 @nova_rt_find(i64, i64) nounwind
declare i64 @nova_rt_list_concat(i64, i64) nounwind
declare i64 @nova_rt_list_reverse(i64) nounwind
declare i64 @nova_rt_list_sort(i64) nounwind
declare i64 @nova_rt_list_slice(i64, i64, i64) nounwind
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

define i64 @make_token(i64 %p0, i64 %p1) nounwind {
entry:
  %slot.k = alloca i64, align 8
  store i64 %p0, ptr %slot.k, align 8
  %slot.v = alloca i64, align 8
  store i64 %p1, ptr %slot.v, align 8
  %r0 = load i64, ptr %slot.k, align 8
  %r1 = load i64, ptr %slot.v, align 8
  %r2 = add i64 0, 0
  %r3 = add i64 0, 0
  %r4.ptr = call ptr @nova_rt_struct_alloc(i64 40)
  %r4.thash = getelementptr i64, ptr %r4.ptr, i64 0
  store i64 210691276070, ptr %r4.thash, align 8
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

define i64 @make_expr(i64 %p0, i64 %p1, i64 %p2) nounwind {
entry:
  %slot.t = alloca i64, align 8
  store i64 %p0, ptr %slot.t, align 8
  %slot.v = alloca i64, align 8
  store i64 %p1, ptr %slot.v, align 8
  %slot.n = alloca i64, align 8
  store i64 %p2, ptr %slot.n, align 8
  %r0 = load i64, ptr %slot.t, align 8
  %r1 = load i64, ptr %slot.v, align 8
  %r2 = load i64, ptr %slot.n, align 8
  %r3 = call i64 @nova_rt_list_create()
  %r4.ptr = call ptr @nova_rt_struct_alloc(i64 40)
  %r4.thash = getelementptr i64, ptr %r4.ptr, i64 0
  store i64 6384055044, ptr %r4.thash, align 8
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

define i64 @make_stmt(i64 %p0, i64 %p1, i64 %p2) nounwind {
entry:
  %slot.t = alloca i64, align 8
  store i64 %p0, ptr %slot.t, align 8
  %slot.n = alloca i64, align 8
  store i64 %p1, ptr %slot.n, align 8
  %slot.e = alloca i64, align 8
  store i64 %p2, ptr %slot.e, align 8
  %r0 = load i64, ptr %slot.t, align 8
  %r1 = load i64, ptr %slot.n, align 8
  %r2 = load i64, ptr %slot.e, align 8
  %r3 = call i64 @nova_rt_list_create()
  %r4.ptr = call ptr @nova_rt_struct_alloc(i64 40)
  %r4.thash = getelementptr i64, ptr %r4.ptr, i64 0
  store i64 6384553709, ptr %r4.thash, align 8
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

define i64 @describe_stmt(i64 %p0) nounwind {
entry:
  %slot.s = alloca i64, align 8
  store i64 %p0, ptr %slot.s, align 8
  %slot.tag = alloca i64, align 8
  store i64 0, ptr %slot.tag, align 8
  %slot.name = alloca i64, align 8
  store i64 0, ptr %slot.name, align 8
  %slot.expr = alloca i64, align 8
  store i64 0, ptr %slot.expr, align 8
  %slot.body = alloca i64, align 8
  store i64 0, ptr %slot.body, align 8
  %slot.etag = alloca i64, align 8
  store i64 0, ptr %slot.etag, align 8
  %slot.eval = alloca i64, align 8
  store i64 0, ptr %slot.eval, align 8
  %slot.ecount = alloca i64, align 8
  store i64 0, ptr %slot.ecount, align 8
  %slot.ech = alloca i64, align 8
  store i64 0, ptr %slot.ech, align 8
  %r0 = load i64, ptr %slot.s, align 8
  %r1.ptr = inttoptr i64 %r0 to ptr
  %r1.gep = getelementptr i64, ptr %r1.ptr, i64 0
  %r1 = load i64, ptr %r1.gep, align 8
  %r2 = add i64 6384553709, 0
  %r3.cmp = icmp eq i64 %r1, %r2
  %r3 = zext i1 %r3.cmp to i64
  %br_marm_01 = icmp ne i64 %r3, 0
  br i1 %br_marm_01, label %marm_01, label %match_fall2
marm_01:
  %r4.ptr = inttoptr i64 %r0 to ptr
  %r4.gep = getelementptr i64, ptr %r4.ptr, i64 1
  %r4 = load i64, ptr %r4.gep, align 8
  store i64 %r4, ptr %slot.tag, align 8
  %r5.ptr = inttoptr i64 %r0 to ptr
  %r5.gep = getelementptr i64, ptr %r5.ptr, i64 2
  %r5 = load i64, ptr %r5.gep, align 8
  store i64 %r5, ptr %slot.name, align 8
  %r6.ptr = inttoptr i64 %r0 to ptr
  %r6.gep = getelementptr i64, ptr %r6.ptr, i64 3
  %r6 = load i64, ptr %r6.gep, align 8
  store i64 %r6, ptr %slot.expr, align 8
  %r7.ptr = inttoptr i64 %r0 to ptr
  %r7.gep = getelementptr i64, ptr %r7.ptr, i64 4
  %r7 = load i64, ptr %r7.gep, align 8
  store i64 %r7, ptr %slot.body, align 8
  %r8 = load i64, ptr %slot.expr, align 8
  %r9.ptr = inttoptr i64 %r8 to ptr
  %r9.gep = getelementptr i64, ptr %r9.ptr, i64 0
  %r9 = load i64, ptr %r9.gep, align 8
  %r10 = add i64 6384055044, 0
  %r11.cmp = icmp eq i64 %r9, %r10
  %r11 = zext i1 %r11.cmp to i64
  %br_marm_04 = icmp ne i64 %r11, 0
  br i1 %br_marm_04, label %marm_04, label %match_fall5
marm_04:
  %r12.ptr = inttoptr i64 %r8 to ptr
  %r12.gep = getelementptr i64, ptr %r12.ptr, i64 1
  %r12 = load i64, ptr %r12.gep, align 8
  store i64 %r12, ptr %slot.etag, align 8
  %r13.ptr = inttoptr i64 %r8 to ptr
  %r13.gep = getelementptr i64, ptr %r13.ptr, i64 2
  %r13 = load i64, ptr %r13.gep, align 8
  store i64 %r13, ptr %slot.eval, align 8
  %r14.ptr = inttoptr i64 %r8 to ptr
  %r14.gep = getelementptr i64, ptr %r14.ptr, i64 3
  %r14 = load i64, ptr %r14.gep, align 8
  store i64 %r14, ptr %slot.ecount, align 8
  %r15.ptr = inttoptr i64 %r8 to ptr
  %r15.gep = getelementptr i64, ptr %r15.ptr, i64 4
  %r15 = load i64, ptr %r15.gep, align 8
  store i64 %r15, ptr %slot.ech, align 8
  %r16.p = getelementptr inbounds [1 x i8], ptr @.str.0, i64 0, i64 0
  %r16 = ptrtoint ptr %r16.p to i64
  %r17 = load i64, ptr %slot.tag, align 8
  %r18 = call i64 @nova_rt_any_to_str(i64 %r17)
  %r19 = call i64 @nova_rt_str_concat(i64 %r16, i64 %r18)
  %r20.p = getelementptr inbounds [2 x i8], ptr @.str.1, i64 0, i64 0
  %r20 = ptrtoint ptr %r20.p to i64
  %r21 = call i64 @nova_rt_str_concat(i64 %r19, i64 %r20)
  %r22 = load i64, ptr %slot.name, align 8
  %r23 = call i64 @nova_rt_any_to_str(i64 %r22)
  %r24 = call i64 @nova_rt_str_concat(i64 %r21, i64 %r23)
  %r25.p = getelementptr inbounds [4 x i8], ptr @.str.2, i64 0, i64 0
  %r25 = ptrtoint ptr %r25.p to i64
  %r26 = call i64 @nova_rt_str_concat(i64 %r24, i64 %r25)
  %r27 = load i64, ptr %slot.etag, align 8
  %r28 = call i64 @nova_rt_any_to_str(i64 %r27)
  %r29 = call i64 @nova_rt_str_concat(i64 %r26, i64 %r28)
  %r30.p = getelementptr inbounds [2 x i8], ptr @.str.3, i64 0, i64 0
  %r30 = ptrtoint ptr %r30.p to i64
  %r31 = call i64 @nova_rt_str_concat(i64 %r29, i64 %r30)
  %r32 = load i64, ptr %slot.eval, align 8
  %r33 = call i64 @nova_rt_any_to_str(i64 %r32)
  %r34 = call i64 @nova_rt_str_concat(i64 %r31, i64 %r33)
  %r35.p = getelementptr inbounds [2 x i8], ptr @.str.4, i64 0, i64 0
  %r35 = ptrtoint ptr %r35.p to i64
  %r36 = call i64 @nova_rt_str_concat(i64 %r34, i64 %r35)
  ret i64 %r36
match_fall5:
  br label %match_exit3
match_exit3:
  br label %match_exit0
match_fall2:
  br label %match_exit0
match_exit0:
  %r37.p = getelementptr inbounds [8 x i8], ptr @.str.5, i64 0, i64 0
  %r37 = ptrtoint ptr %r37.p to i64
  ret i64 %r37
}

define i64 @token_str(i64 %p0) nounwind {
entry:
  %slot.t = alloca i64, align 8
  store i64 %p0, ptr %slot.t, align 8
  %slot.k = alloca i64, align 8
  store i64 0, ptr %slot.k, align 8
  %slot.v = alloca i64, align 8
  store i64 0, ptr %slot.v, align 8
  %slot.line = alloca i64, align 8
  store i64 0, ptr %slot.line, align 8
  %slot.col = alloca i64, align 8
  store i64 0, ptr %slot.col, align 8
  %r0 = load i64, ptr %slot.t, align 8
  %r1.ptr = inttoptr i64 %r0 to ptr
  %r1.gep = getelementptr i64, ptr %r1.ptr, i64 0
  %r1 = load i64, ptr %r1.gep, align 8
  %r2 = add i64 210691276070, 0
  %r3.cmp = icmp eq i64 %r1, %r2
  %r3 = zext i1 %r3.cmp to i64
  %br_marm_07 = icmp ne i64 %r3, 0
  br i1 %br_marm_07, label %marm_07, label %match_fall8
marm_07:
  %r4.ptr = inttoptr i64 %r0 to ptr
  %r4.gep = getelementptr i64, ptr %r4.ptr, i64 1
  %r4 = load i64, ptr %r4.gep, align 8
  store i64 %r4, ptr %slot.k, align 8
  %r5.ptr = inttoptr i64 %r0 to ptr
  %r5.gep = getelementptr i64, ptr %r5.ptr, i64 2
  %r5 = load i64, ptr %r5.gep, align 8
  store i64 %r5, ptr %slot.v, align 8
  %r6.ptr = inttoptr i64 %r0 to ptr
  %r6.gep = getelementptr i64, ptr %r6.ptr, i64 3
  %r6 = load i64, ptr %r6.gep, align 8
  store i64 %r6, ptr %slot.line, align 8
  %r7.ptr = inttoptr i64 %r0 to ptr
  %r7.gep = getelementptr i64, ptr %r7.ptr, i64 4
  %r7 = load i64, ptr %r7.gep, align 8
  store i64 %r7, ptr %slot.col, align 8
  %r8.p = getelementptr inbounds [1 x i8], ptr @.str.0, i64 0, i64 0
  %r8 = ptrtoint ptr %r8.p to i64
  %r9 = load i64, ptr %slot.k, align 8
  %r10 = call i64 @nova_rt_any_to_str(i64 %r9)
  %r11 = call i64 @nova_rt_str_concat(i64 %r8, i64 %r10)
  %r12.p = getelementptr inbounds [2 x i8], ptr @.str.6, i64 0, i64 0
  %r12 = ptrtoint ptr %r12.p to i64
  %r13 = call i64 @nova_rt_str_concat(i64 %r11, i64 %r12)
  %r14 = load i64, ptr %slot.v, align 8
  %r15 = call i64 @nova_rt_any_to_str(i64 %r14)
  %r16 = call i64 @nova_rt_str_concat(i64 %r13, i64 %r15)
  %r17.p = getelementptr inbounds [1 x i8], ptr @.str.0, i64 0, i64 0
  %r17 = ptrtoint ptr %r17.p to i64
  %r18 = call i64 @nova_rt_str_concat(i64 %r16, i64 %r17)
  ret i64 %r18
match_fall8:
  br label %match_exit6
match_exit6:
  %r19.p = getelementptr inbounds [2 x i8], ptr @.str.7, i64 0, i64 0
  %r19 = ptrtoint ptr %r19.p to i64
  ret i64 %r19
}

define i64 @nova_main() nounwind {
entry:
  %slot.tok = alloca i64, align 8
  store i64 0, ptr %slot.tok, align 8
  %slot.expr = alloca i64, align 8
  store i64 0, ptr %slot.expr, align 8
  %slot.stmt = alloca i64, align 8
  store i64 0, ptr %slot.stmt, align 8
  %slot.param = alloca i64, align 8
  store i64 0, ptr %slot.param, align 8
  %slot.tokens = alloca i64, align 8
  store i64 0, ptr %slot.tokens, align 8
  %slot.i = alloca i64, align 8
  store i64 0, ptr %slot.i, align 8
  %slot.n = alloca i64, align 8
  store i64 0, ptr %slot.n, align 8
  %slot.t = alloca i64, align 8
  store i64 0, ptr %slot.t, align 8
  %r0.p = getelementptr inbounds [6 x i8], ptr @.str.8, i64 0, i64 0
  %r0 = ptrtoint ptr %r0.p to i64
  %r1.p = getelementptr inbounds [6 x i8], ptr @.str.9, i64 0, i64 0
  %r1 = ptrtoint ptr %r1.p to i64
  %r2 = call i64 @make_token(i64 %r0, i64 %r1)
  store i64 %r2, ptr %slot.tok, align 8
  %r3.p = getelementptr inbounds [4 x i8], ptr @.str.10, i64 0, i64 0
  %r3 = ptrtoint ptr %r3.p to i64
  %r4.p = getelementptr inbounds [3 x i8], ptr @.str.11, i64 0, i64 0
  %r4 = ptrtoint ptr %r4.p to i64
  %r5 = add i64 42, 0
  %r6 = call i64 @make_expr(i64 %r3, i64 %r4, i64 %r5)
  store i64 %r6, ptr %slot.expr, align 8
  %r7.p = getelementptr inbounds [7 x i8], ptr @.str.12, i64 0, i64 0
  %r7 = ptrtoint ptr %r7.p to i64
  %r8.p = getelementptr inbounds [2 x i8], ptr @.str.13, i64 0, i64 0
  %r8 = ptrtoint ptr %r8.p to i64
  %r9 = load i64, ptr %slot.expr, align 8
  %r10 = call i64 @make_stmt(i64 %r7, i64 %r8, i64 %r9)
  store i64 %r10, ptr %slot.stmt, align 8
  %r11.p = getelementptr inbounds [2 x i8], ptr @.str.14, i64 0, i64 0
  %r11 = ptrtoint ptr %r11.p to i64
  %r12.p = getelementptr inbounds [4 x i8], ptr @.str.10, i64 0, i64 0
  %r12 = ptrtoint ptr %r12.p to i64
  %r13.ptr = call ptr @nova_rt_struct_alloc(i64 24)
  %r13.thash = getelementptr i64, ptr %r13.ptr, i64 0
  store i64 210686036758, ptr %r13.thash, align 8
  %r13.f0 = getelementptr i64, ptr %r13.ptr, i64 1
  store i64 %r11, ptr %r13.f0, align 8
  %r13.f1 = getelementptr i64, ptr %r13.ptr, i64 2
  store i64 %r12, ptr %r13.f1, align 8
  %r13 = ptrtoint ptr %r13.ptr to i64
  store i64 %r13, ptr %slot.param, align 8
  %r14 = load i64, ptr %slot.stmt, align 8
  %r15 = call i64 @describe_stmt(i64 %r14)
  %r16 = call i64 @nova_rt_print_any(i64 %r15)
  %r17 = load i64, ptr %slot.tok, align 8
  %r18 = call i64 @token_str(i64 %r17)
  %r19 = call i64 @nova_rt_print_any(i64 %r18)
  %r21.p = getelementptr inbounds [3 x i8], ptr @.str.15, i64 0, i64 0
  %r21 = ptrtoint ptr %r21.p to i64
  %r22.p = getelementptr inbounds [3 x i8], ptr @.str.16, i64 0, i64 0
  %r22 = ptrtoint ptr %r22.p to i64
  %r23 = call i64 @make_token(i64 %r21, i64 %r22)
  %r24.p = getelementptr inbounds [6 x i8], ptr @.str.8, i64 0, i64 0
  %r24 = ptrtoint ptr %r24.p to i64
  %r25.p = getelementptr inbounds [5 x i8], ptr @.str.17, i64 0, i64 0
  %r25 = ptrtoint ptr %r25.p to i64
  %r26 = call i64 @make_token(i64 %r24, i64 %r25)
  %r27.p = getelementptr inbounds [6 x i8], ptr @.str.18, i64 0, i64 0
  %r27 = ptrtoint ptr %r27.p to i64
  %r28.p = getelementptr inbounds [2 x i8], ptr @.str.3, i64 0, i64 0
  %r28 = ptrtoint ptr %r28.p to i64
  %r29 = call i64 @make_token(i64 %r27, i64 %r28)
  %r20 = call i64 @nova_rt_list_create()
  call i64 @nova_rt_list_append(i64 %r20, i64 %r23)
  call i64 @nova_rt_list_append(i64 %r20, i64 %r26)
  call i64 @nova_rt_list_append(i64 %r20, i64 %r29)
  store i64 %r20, ptr %slot.tokens, align 8
  %r30 = add i64 0, 0
  store i64 %r30, ptr %slot.i, align 8
  br label %while_hdr9, !llvm.loop !91
while_hdr9:
  %r31 = load i64, ptr %slot.i, align 8
  %r32 = load i64, ptr %slot.tokens, align 8
  %r33 = call i64 @nova_rt_len_any(i64 %r32)
  %r34.cmp = icmp slt i64 %r31, %r33
  %r34 = zext i1 %r34.cmp to i64
  %br_while_body10 = icmp ne i64 %r34, 0
  br i1 %br_while_body10, label %while_body10, label %while_exit11, !prof !90
while_body10:
  %r35 = load i64, ptr %slot.tokens, align 8
  %r36 = load i64, ptr %slot.i, align 8
  %r37.lp = inttoptr i64 %r35 to ptr
  %r37.dp = load ptr, ptr %r37.lp, align 8, !tbaa !2
  %r37.ep = getelementptr i64, ptr %r37.dp, i64 %r36
  %r37 = load i64, ptr %r37.ep, align 8, !tbaa !4
  %r38 = call i64 @token_str(i64 %r37)
  %r39 = call i64 @nova_rt_print_any(i64 %r38)
  %r40 = load i64, ptr %slot.i, align 8
  %r41 = add i64 1, 0
  %r42 = add i64 %r40, %r41
  store i64 %r42, ptr %slot.i, align 8
  br label %while_hdr9, !llvm.loop !91
while_exit11:
  %r43 = load i64, ptr %slot.param, align 8
  %r44.ptr = inttoptr i64 %r43 to ptr
  %r44.gep = getelementptr i64, ptr %r44.ptr, i64 0
  %r44 = load i64, ptr %r44.gep, align 8
  %r45 = add i64 210686036758, 0
  %r46.cmp = icmp eq i64 %r44, %r45
  %r46 = zext i1 %r46.cmp to i64
  %br_marm_013 = icmp ne i64 %r46, 0
  br i1 %br_marm_013, label %marm_013, label %match_fall14
marm_013:
  %r47.ptr = inttoptr i64 %r43 to ptr
  %r47.gep = getelementptr i64, ptr %r47.ptr, i64 1
  %r47 = load i64, ptr %r47.gep, align 8
  store i64 %r47, ptr %slot.n, align 8
  %r48.ptr = inttoptr i64 %r43 to ptr
  %r48.gep = getelementptr i64, ptr %r48.ptr, i64 2
  %r48 = load i64, ptr %r48.gep, align 8
  store i64 %r48, ptr %slot.t, align 8
  %r49.p = getelementptr inbounds [1 x i8], ptr @.str.0, i64 0, i64 0
  %r49 = ptrtoint ptr %r49.p to i64
  %r50 = load i64, ptr %slot.n, align 8
  %r51 = call i64 @nova_rt_any_to_str(i64 %r50)
  %r52 = call i64 @nova_rt_str_concat(i64 %r49, i64 %r51)
  %r53.p = getelementptr inbounds [3 x i8], ptr @.str.19, i64 0, i64 0
  %r53 = ptrtoint ptr %r53.p to i64
  %r54 = call i64 @nova_rt_str_concat(i64 %r52, i64 %r53)
  %r55 = load i64, ptr %slot.t, align 8
  %r56 = call i64 @nova_rt_any_to_str(i64 %r55)
  %r57 = call i64 @nova_rt_str_concat(i64 %r54, i64 %r56)
  %r58.p = getelementptr inbounds [1 x i8], ptr @.str.0, i64 0, i64 0
  %r58 = ptrtoint ptr %r58.p to i64
  %r59 = call i64 @nova_rt_str_concat(i64 %r57, i64 %r58)
  %r60 = call i64 @nova_rt_print_any(i64 %r59)
  br label %match_exit12
match_fall14:
  br label %match_exit12
match_exit12:
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
@.str.0 = private unnamed_addr constant [1 x i8] c"\00"
@.str.1 = private unnamed_addr constant [2 x i8] c" \00"
@.str.2 = private unnamed_addr constant [4 x i8] c" = \00"
@.str.3 = private unnamed_addr constant [2 x i8] c"(\00"
@.str.4 = private unnamed_addr constant [2 x i8] c")\00"
@.str.5 = private unnamed_addr constant [8 x i8] c"unknown\00"
@.str.6 = private unnamed_addr constant [2 x i8] c":\00"
@.str.7 = private unnamed_addr constant [2 x i8] c"?\00"
@.str.8 = private unnamed_addr constant [6 x i8] c"IDENT\00"
@.str.9 = private unnamed_addr constant [6 x i8] c"hello\00"
@.str.10 = private unnamed_addr constant [4 x i8] c"int\00"
@.str.11 = private unnamed_addr constant [3 x i8] c"42\00"
@.str.12 = private unnamed_addr constant [7 x i8] c"assign\00"
@.str.13 = private unnamed_addr constant [2 x i8] c"x\00"
@.str.14 = private unnamed_addr constant [2 x i8] c"n\00"
@.str.15 = private unnamed_addr constant [3 x i8] c"KW\00"
@.str.16 = private unnamed_addr constant [3 x i8] c"fn\00"
@.str.17 = private unnamed_addr constant [5 x i8] c"main\00"
@.str.18 = private unnamed_addr constant [6 x i8] c"DELIM\00"
@.str.19 = private unnamed_addr constant [3 x i8] c": \00"

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
