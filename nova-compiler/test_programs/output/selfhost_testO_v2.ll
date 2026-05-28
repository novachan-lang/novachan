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

define i64 @make_num(i64 %p0) nounwind {
entry:
  %slot.n = alloca i64, align 8
  store i64 %p0, ptr %slot.n, align 8
  %r0.p = getelementptr inbounds [4 x i8], ptr @.str.0, i64 0, i64 0
  %r0 = ptrtoint ptr %r0.p to i64
  %r1 = load i64, ptr %slot.n, align 8
  %r2 = add i64 0, 0
  %r3 = add i64 0, 0
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

define i64 @make_add(i64 %p0, i64 %p1) nounwind {
entry:
  %slot.l = alloca i64, align 8
  store i64 %p0, ptr %slot.l, align 8
  %slot.r = alloca i64, align 8
  store i64 %p1, ptr %slot.r, align 8
  %r0.p = getelementptr inbounds [4 x i8], ptr @.str.1, i64 0, i64 0
  %r0 = ptrtoint ptr %r0.p to i64
  %r1 = add i64 0, 0
  %r2 = load i64, ptr %slot.l, align 8
  %r3 = load i64, ptr %slot.r, align 8
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

define i64 @make_mul(i64 %p0, i64 %p1) nounwind {
entry:
  %slot.l = alloca i64, align 8
  store i64 %p0, ptr %slot.l, align 8
  %slot.r = alloca i64, align 8
  store i64 %p1, ptr %slot.r, align 8
  %r0.p = getelementptr inbounds [4 x i8], ptr @.str.2, i64 0, i64 0
  %r0 = ptrtoint ptr %r0.p to i64
  %r1 = add i64 0, 0
  %r2 = load i64, ptr %slot.l, align 8
  %r3 = load i64, ptr %slot.r, align 8
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

define i64 @eval_expr(i64 %p0) nounwind {
entry:
  %slot.e = alloca i64, align 8
  store i64 %p0, ptr %slot.e, align 8
  %slot.tag = alloca i64, align 8
  store i64 0, ptr %slot.tag, align 8
  %slot.value = alloca i64, align 8
  store i64 0, ptr %slot.value, align 8
  %slot.left = alloca i64, align 8
  store i64 0, ptr %slot.left, align 8
  %slot.right = alloca i64, align 8
  store i64 0, ptr %slot.right, align 8
  %r0 = load i64, ptr %slot.e, align 8
  %r1.ptr = inttoptr i64 %r0 to ptr
  %r1.gep = getelementptr i64, ptr %r1.ptr, i64 0
  %r1 = load i64, ptr %r1.gep, align 8
  %r2 = add i64 6384055044, 0
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
  store i64 %r5, ptr %slot.value, align 8
  %r6.ptr = inttoptr i64 %r0 to ptr
  %r6.gep = getelementptr i64, ptr %r6.ptr, i64 3
  %r6 = load i64, ptr %r6.gep, align 8
  store i64 %r6, ptr %slot.left, align 8
  %r7.ptr = inttoptr i64 %r0 to ptr
  %r7.gep = getelementptr i64, ptr %r7.ptr, i64 4
  %r7 = load i64, ptr %r7.gep, align 8
  store i64 %r7, ptr %slot.right, align 8
  %r8 = load i64, ptr %slot.tag, align 8
  %r9.p = getelementptr inbounds [4 x i8], ptr @.str.0, i64 0, i64 0
  %r9 = ptrtoint ptr %r9.p to i64
  %r10.p0 = inttoptr i64 %r8 to ptr
  %r10.p1 = inttoptr i64 %r9 to ptr
  %r10.sc = call i32 @strcmp(ptr %r10.p0, ptr %r10.p1)
  %r10.cmp = icmp eq i32 %r10.sc, 0
  %r10 = zext i1 %r10.cmp to i64
  %br_then3 = icmp ne i64 %r10, 0
  br i1 %br_then3, label %then3, label %else4
then3:
  %r11 = load i64, ptr %slot.value, align 8
  ret i64 %r11
else4:
  %r12 = load i64, ptr %slot.tag, align 8
  %r13.p = getelementptr inbounds [4 x i8], ptr @.str.1, i64 0, i64 0
  %r13 = ptrtoint ptr %r13.p to i64
  %r14.p0 = inttoptr i64 %r12 to ptr
  %r14.p1 = inttoptr i64 %r13 to ptr
  %r14.sc = call i32 @strcmp(ptr %r14.p0, ptr %r14.p1)
  %r14.cmp = icmp eq i32 %r14.sc, 0
  %r14 = zext i1 %r14.cmp to i64
  %br_then6 = icmp ne i64 %r14, 0
  br i1 %br_then6, label %then6, label %else7
then6:
  %r15 = load i64, ptr %slot.left, align 8
  %r16 = call i64 @eval_expr(i64 %r15)
  %r17 = load i64, ptr %slot.right, align 8
  %r18 = call i64 @eval_expr(i64 %r17)
  %r19 = add i64 %r16, %r18
  ret i64 %r19
else7:
  %r20 = load i64, ptr %slot.tag, align 8
  %r21.p = getelementptr inbounds [4 x i8], ptr @.str.2, i64 0, i64 0
  %r21 = ptrtoint ptr %r21.p to i64
  %r22.p0 = inttoptr i64 %r20 to ptr
  %r22.p1 = inttoptr i64 %r21 to ptr
  %r22.sc = call i32 @strcmp(ptr %r22.p0, ptr %r22.p1)
  %r22.cmp = icmp eq i32 %r22.sc, 0
  %r22 = zext i1 %r22.cmp to i64
  %br_then9 = icmp ne i64 %r22, 0
  br i1 %br_then9, label %then9, label %else10
then9:
  %r23 = load i64, ptr %slot.left, align 8
  %r24 = call i64 @eval_expr(i64 %r23)
  %r25 = load i64, ptr %slot.right, align 8
  %r26 = call i64 @eval_expr(i64 %r25)
  %r27 = mul i64 %r24, %r26
  ret i64 %r27
else10:
  br label %endif11
endif11:
  br label %endif8
endif8:
  br label %endif5
endif5:
  br label %match_exit0
match_fall2:
  br label %match_exit0
match_exit0:
  %r28 = add i64 0, 0
  ret i64 %r28
}

define i64 @expr_to_string(i64 %p0) nounwind {
entry:
  %slot.e = alloca i64, align 8
  store i64 %p0, ptr %slot.e, align 8
  %slot.tag = alloca i64, align 8
  store i64 0, ptr %slot.tag, align 8
  %slot.value = alloca i64, align 8
  store i64 0, ptr %slot.value, align 8
  %slot.left = alloca i64, align 8
  store i64 0, ptr %slot.left, align 8
  %slot.right = alloca i64, align 8
  store i64 0, ptr %slot.right, align 8
  %r0 = load i64, ptr %slot.e, align 8
  %r1.ptr = inttoptr i64 %r0 to ptr
  %r1.gep = getelementptr i64, ptr %r1.ptr, i64 0
  %r1 = load i64, ptr %r1.gep, align 8
  %r2 = add i64 6384055044, 0
  %r3.cmp = icmp eq i64 %r1, %r2
  %r3 = zext i1 %r3.cmp to i64
  %br_marm_013 = icmp ne i64 %r3, 0
  br i1 %br_marm_013, label %marm_013, label %match_fall14
marm_013:
  %r4.ptr = inttoptr i64 %r0 to ptr
  %r4.gep = getelementptr i64, ptr %r4.ptr, i64 1
  %r4 = load i64, ptr %r4.gep, align 8
  store i64 %r4, ptr %slot.tag, align 8
  %r5.ptr = inttoptr i64 %r0 to ptr
  %r5.gep = getelementptr i64, ptr %r5.ptr, i64 2
  %r5 = load i64, ptr %r5.gep, align 8
  store i64 %r5, ptr %slot.value, align 8
  %r6.ptr = inttoptr i64 %r0 to ptr
  %r6.gep = getelementptr i64, ptr %r6.ptr, i64 3
  %r6 = load i64, ptr %r6.gep, align 8
  store i64 %r6, ptr %slot.left, align 8
  %r7.ptr = inttoptr i64 %r0 to ptr
  %r7.gep = getelementptr i64, ptr %r7.ptr, i64 4
  %r7 = load i64, ptr %r7.gep, align 8
  store i64 %r7, ptr %slot.right, align 8
  %r8 = load i64, ptr %slot.tag, align 8
  %r9.p = getelementptr inbounds [4 x i8], ptr @.str.0, i64 0, i64 0
  %r9 = ptrtoint ptr %r9.p to i64
  %r10.p0 = inttoptr i64 %r8 to ptr
  %r10.p1 = inttoptr i64 %r9 to ptr
  %r10.sc = call i32 @strcmp(ptr %r10.p0, ptr %r10.p1)
  %r10.cmp = icmp eq i32 %r10.sc, 0
  %r10 = zext i1 %r10.cmp to i64
  %br_then15 = icmp ne i64 %r10, 0
  br i1 %br_then15, label %then15, label %else16
then15:
  %r11 = load i64, ptr %slot.value, align 8
  %r12 = call i64 @nova_rt_int_to_str(i64 %r11)
  ret i64 %r12
else16:
  %r13 = load i64, ptr %slot.tag, align 8
  %r14.p = getelementptr inbounds [4 x i8], ptr @.str.1, i64 0, i64 0
  %r14 = ptrtoint ptr %r14.p to i64
  %r15.p0 = inttoptr i64 %r13 to ptr
  %r15.p1 = inttoptr i64 %r14 to ptr
  %r15.sc = call i32 @strcmp(ptr %r15.p0, ptr %r15.p1)
  %r15.cmp = icmp eq i32 %r15.sc, 0
  %r15 = zext i1 %r15.cmp to i64
  %br_then18 = icmp ne i64 %r15, 0
  br i1 %br_then18, label %then18, label %else19
then18:
  %r16.p = getelementptr inbounds [2 x i8], ptr @.str.3, i64 0, i64 0
  %r16 = ptrtoint ptr %r16.p to i64
  %r17 = load i64, ptr %slot.left, align 8
  %r18 = call i64 @expr_to_string(i64 %r17)
  %r19 = call i64 @nova_rt_str_concat(i64 %r16, i64 %r18)
  %r20.p = getelementptr inbounds [4 x i8], ptr @.str.4, i64 0, i64 0
  %r20 = ptrtoint ptr %r20.p to i64
  %r21 = call i64 @nova_rt_str_concat(i64 %r19, i64 %r20)
  %r22 = load i64, ptr %slot.right, align 8
  %r23 = call i64 @expr_to_string(i64 %r22)
  %r24 = call i64 @nova_rt_str_concat(i64 %r21, i64 %r23)
  %r25.p = getelementptr inbounds [2 x i8], ptr @.str.5, i64 0, i64 0
  %r25 = ptrtoint ptr %r25.p to i64
  %r26 = call i64 @nova_rt_str_concat(i64 %r24, i64 %r25)
  ret i64 %r26
else19:
  %r27 = load i64, ptr %slot.tag, align 8
  %r28.p = getelementptr inbounds [4 x i8], ptr @.str.2, i64 0, i64 0
  %r28 = ptrtoint ptr %r28.p to i64
  %r29.p0 = inttoptr i64 %r27 to ptr
  %r29.p1 = inttoptr i64 %r28 to ptr
  %r29.sc = call i32 @strcmp(ptr %r29.p0, ptr %r29.p1)
  %r29.cmp = icmp eq i32 %r29.sc, 0
  %r29 = zext i1 %r29.cmp to i64
  %br_then21 = icmp ne i64 %r29, 0
  br i1 %br_then21, label %then21, label %else22
then21:
  %r30.p = getelementptr inbounds [2 x i8], ptr @.str.3, i64 0, i64 0
  %r30 = ptrtoint ptr %r30.p to i64
  %r31 = load i64, ptr %slot.left, align 8
  %r32 = call i64 @expr_to_string(i64 %r31)
  %r33 = call i64 @nova_rt_str_concat(i64 %r30, i64 %r32)
  %r34.p = getelementptr inbounds [4 x i8], ptr @.str.6, i64 0, i64 0
  %r34 = ptrtoint ptr %r34.p to i64
  %r35 = call i64 @nova_rt_str_concat(i64 %r33, i64 %r34)
  %r36 = load i64, ptr %slot.right, align 8
  %r37 = call i64 @expr_to_string(i64 %r36)
  %r38 = call i64 @nova_rt_str_concat(i64 %r35, i64 %r37)
  %r39.p = getelementptr inbounds [2 x i8], ptr @.str.5, i64 0, i64 0
  %r39 = ptrtoint ptr %r39.p to i64
  %r40 = call i64 @nova_rt_str_concat(i64 %r38, i64 %r39)
  ret i64 %r40
else22:
  br label %endif23
endif23:
  br label %endif20
endif20:
  br label %endif17
endif17:
  br label %match_exit12
match_fall14:
  br label %match_exit12
match_exit12:
  %r41.p = getelementptr inbounds [2 x i8], ptr @.str.7, i64 0, i64 0
  %r41 = ptrtoint ptr %r41.p to i64
  ret i64 %r41
}

define i64 @nova_main() nounwind {
entry:
  %slot.e1 = alloca i64, align 8
  store i64 0, ptr %slot.e1, align 8
  %slot.e2 = alloca i64, align 8
  store i64 0, ptr %slot.e2, align 8
  %slot.e3 = alloca i64, align 8
  store i64 0, ptr %slot.e3, align 8
  %slot.e4 = alloca i64, align 8
  store i64 0, ptr %slot.e4, align 8
  %r0 = add i64 3, 0
  %r1 = call i64 @make_num(i64 %r0)
  %r2 = add i64 4, 0
  %r3 = call i64 @make_num(i64 %r2)
  %r4 = call i64 @make_add(i64 %r1, i64 %r3)
  store i64 %r4, ptr %slot.e1, align 8
  %r5 = add i64 2, 0
  %r6 = call i64 @make_num(i64 %r5)
  %r7 = add i64 5, 0
  %r8 = call i64 @make_num(i64 %r7)
  %r9 = call i64 @make_add(i64 %r6, i64 %r8)
  store i64 %r9, ptr %slot.e2, align 8
  %r10 = load i64, ptr %slot.e1, align 8
  %r11 = load i64, ptr %slot.e2, align 8
  %r12 = call i64 @make_mul(i64 %r10, i64 %r11)
  store i64 %r12, ptr %slot.e3, align 8
  %r13 = load i64, ptr %slot.e3, align 8
  %r14 = call i64 @expr_to_string(i64 %r13)
  %r15 = call i64 @nova_rt_print_any(i64 %r14)
  %r16 = load i64, ptr %slot.e3, align 8
  %r17 = call i64 @eval_expr(i64 %r16)
  %r18 = call i64 @nova_rt_print_any(i64 %r17)
  %r19 = add i64 10, 0
  %r20 = call i64 @make_num(i64 %r19)
  %r21 = add i64 20, 0
  %r22 = call i64 @make_num(i64 %r21)
  %r23 = add i64 3, 0
  %r24 = call i64 @make_num(i64 %r23)
  %r25 = call i64 @make_mul(i64 %r22, i64 %r24)
  %r26 = call i64 @make_add(i64 %r20, i64 %r25)
  store i64 %r26, ptr %slot.e4, align 8
  %r27 = load i64, ptr %slot.e4, align 8
  %r28 = call i64 @expr_to_string(i64 %r27)
  %r29 = call i64 @nova_rt_print_any(i64 %r28)
  %r30 = load i64, ptr %slot.e4, align 8
  %r31 = call i64 @eval_expr(i64 %r30)
  %r32 = call i64 @nova_rt_print_any(i64 %r31)
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
@.str.0 = private unnamed_addr constant [4 x i8] c"num\00"
@.str.1 = private unnamed_addr constant [4 x i8] c"add\00"
@.str.2 = private unnamed_addr constant [4 x i8] c"mul\00"
@.str.3 = private unnamed_addr constant [2 x i8] c"(\00"
@.str.4 = private unnamed_addr constant [4 x i8] c" + \00"
@.str.5 = private unnamed_addr constant [2 x i8] c")\00"
@.str.6 = private unnamed_addr constant [4 x i8] c" * \00"
@.str.7 = private unnamed_addr constant [2 x i8] c"?\00"

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
