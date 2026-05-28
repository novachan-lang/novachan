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
  %r2 = call i64 @nova_rt_list_create()
  %r3.ptr = call ptr @nova_rt_struct_alloc(i64 32)
  %r3.thash = getelementptr i64, ptr %r3.ptr, i64 0
  store i64 6384368267, ptr %r3.thash, align 8
  %r3.f0 = getelementptr i64, ptr %r3.ptr, i64 1
  store i64 %r0, ptr %r3.f0, align 8
  %r3.f1 = getelementptr i64, ptr %r3.ptr, i64 2
  store i64 %r1, ptr %r3.f1, align 8
  %r3.f2 = getelementptr i64, ptr %r3.ptr, i64 3
  store i64 %r2, ptr %r3.f2, align 8
  %r3 = ptrtoint ptr %r3.ptr to i64
  ret i64 %r3
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
  %r3 = load i64, ptr %slot.l, align 8
  %r4 = load i64, ptr %slot.r, align 8
  %r2 = call i64 @nova_rt_list_create()
  call i64 @nova_rt_list_append(i64 %r2, i64 %r3)
  call i64 @nova_rt_list_append(i64 %r2, i64 %r4)
  %r5.ptr = call ptr @nova_rt_struct_alloc(i64 32)
  %r5.thash = getelementptr i64, ptr %r5.ptr, i64 0
  store i64 6384368267, ptr %r5.thash, align 8
  %r5.f0 = getelementptr i64, ptr %r5.ptr, i64 1
  store i64 %r0, ptr %r5.f0, align 8
  %r5.f1 = getelementptr i64, ptr %r5.ptr, i64 2
  store i64 %r1, ptr %r5.f1, align 8
  %r5.f2 = getelementptr i64, ptr %r5.ptr, i64 3
  store i64 %r2, ptr %r5.f2, align 8
  %r5 = ptrtoint ptr %r5.ptr to i64
  ret i64 %r5
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
  %r3 = load i64, ptr %slot.l, align 8
  %r4 = load i64, ptr %slot.r, align 8
  %r2 = call i64 @nova_rt_list_create()
  call i64 @nova_rt_list_append(i64 %r2, i64 %r3)
  call i64 @nova_rt_list_append(i64 %r2, i64 %r4)
  %r5.ptr = call ptr @nova_rt_struct_alloc(i64 32)
  %r5.thash = getelementptr i64, ptr %r5.ptr, i64 0
  store i64 6384368267, ptr %r5.thash, align 8
  %r5.f0 = getelementptr i64, ptr %r5.ptr, i64 1
  store i64 %r0, ptr %r5.f0, align 8
  %r5.f1 = getelementptr i64, ptr %r5.ptr, i64 2
  store i64 %r1, ptr %r5.f1, align 8
  %r5.f2 = getelementptr i64, ptr %r5.ptr, i64 3
  store i64 %r2, ptr %r5.f2, align 8
  %r5 = ptrtoint ptr %r5.ptr to i64
  ret i64 %r5
}

define i64 @eval(i64 %p0) nounwind {
entry:
  %slot.e = alloca i64, align 8
  store i64 %p0, ptr %slot.e, align 8
  %slot.kind = alloca i64, align 8
  store i64 0, ptr %slot.kind, align 8
  %slot.value = alloca i64, align 8
  store i64 0, ptr %slot.value, align 8
  %slot.children = alloca i64, align 8
  store i64 0, ptr %slot.children, align 8
  %r0 = load i64, ptr %slot.e, align 8
  %r1.ptr = inttoptr i64 %r0 to ptr
  %r1.gep = getelementptr i64, ptr %r1.ptr, i64 0
  %r1 = load i64, ptr %r1.gep, align 8
  %r2 = add i64 6384368267, 0
  %r3.cmp = icmp eq i64 %r1, %r2
  %r3 = zext i1 %r3.cmp to i64
  %br_rmarm_00 = icmp ne i64 %r3, 0
  br i1 %br_rmarm_00, label %rmarm_00, label %rmatch_fall1
rmarm_00:
  %r4.ptr = inttoptr i64 %r0 to ptr
  %r4.gep = getelementptr i64, ptr %r4.ptr, i64 1
  %r4 = load i64, ptr %r4.gep, align 8
  store i64 %r4, ptr %slot.kind, align 8
  %r5.ptr = inttoptr i64 %r0 to ptr
  %r5.gep = getelementptr i64, ptr %r5.ptr, i64 2
  %r5 = load i64, ptr %r5.gep, align 8
  store i64 %r5, ptr %slot.value, align 8
  %r6.ptr = inttoptr i64 %r0 to ptr
  %r6.gep = getelementptr i64, ptr %r6.ptr, i64 3
  %r6 = load i64, ptr %r6.gep, align 8
  store i64 %r6, ptr %slot.children, align 8
  %r7 = load i64, ptr %slot.kind, align 8
  %r8.p = getelementptr inbounds [4 x i8], ptr @.str.0, i64 0, i64 0
  %r8 = ptrtoint ptr %r8.p to i64
  %r9.p0 = inttoptr i64 %r7 to ptr
  %r9.p1 = inttoptr i64 %r8 to ptr
  %r9.sc = call i32 @strcmp(ptr %r9.p0, ptr %r9.p1)
  %r9.cmp = icmp eq i32 %r9.sc, 0
  %r9 = zext i1 %r9.cmp to i64
  %br_retthen2 = icmp ne i64 %r9, 0
  br i1 %br_retthen2, label %retthen2, label %retelse3
retthen2:
  %r10 = load i64, ptr %slot.value, align 8
  ret i64 %r10
retelse3:
  %r11 = load i64, ptr %slot.kind, align 8
  %r12.p = getelementptr inbounds [4 x i8], ptr @.str.1, i64 0, i64 0
  %r12 = ptrtoint ptr %r12.p to i64
  %r13.p0 = inttoptr i64 %r11 to ptr
  %r13.p1 = inttoptr i64 %r12 to ptr
  %r13.sc = call i32 @strcmp(ptr %r13.p0, ptr %r13.p1)
  %r13.cmp = icmp eq i32 %r13.sc, 0
  %r13 = zext i1 %r13.cmp to i64
  %br_retthen4 = icmp ne i64 %r13, 0
  br i1 %br_retthen4, label %retthen4, label %retelse5
retthen4:
  %r14 = load i64, ptr %slot.children, align 8
  %r15 = add i64 0, 0
  %r16 = call i64 @nova_rt_index_get(i64 %r14, i64 %r15)
  %r17 = call i64 @eval(i64 %r16)
  %r18 = load i64, ptr %slot.children, align 8
  %r19 = add i64 1, 0
  %r20 = call i64 @nova_rt_index_get(i64 %r18, i64 %r19)
  %r21 = call i64 @eval(i64 %r20)
  %r22 = call i64 @nova_rt_add(i64 %r17, i64 %r21)
  ret i64 %r22
retelse5:
  %r23 = load i64, ptr %slot.children, align 8
  %r24 = add i64 0, 0
  %r25 = call i64 @nova_rt_index_get(i64 %r23, i64 %r24)
  %r26 = call i64 @eval(i64 %r25)
  %r27 = load i64, ptr %slot.children, align 8
  %r28 = add i64 1, 0
  %r29 = call i64 @nova_rt_index_get(i64 %r27, i64 %r28)
  %r30 = call i64 @eval(i64 %r29)
  %r31 = mul i64 %r26, %r30
  ret i64 %r31
rmatch_fall1:
  ret i64 0
}

define i64 @nova_main() nounwind {
entry:
  %slot.expr = alloca i64, align 8
  store i64 0, ptr %slot.expr, align 8
  %slot.result = alloca i64, align 8
  store i64 0, ptr %slot.result, align 8
  %slot.expr2 = alloca i64, align 8
  store i64 0, ptr %slot.expr2, align 8
  %r0 = add i64 3, 0
  %r1 = call i64 @make_num(i64 %r0)
  %r2 = add i64 4, 0
  %r3 = call i64 @make_num(i64 %r2)
  %r4 = call i64 @make_mul(i64 %r1, i64 %r3)
  %r5 = add i64 5, 0
  %r6 = call i64 @make_num(i64 %r5)
  %r7 = call i64 @make_add(i64 %r4, i64 %r6)
  store i64 %r7, ptr %slot.expr, align 8
  %r8 = load i64, ptr %slot.expr, align 8
  %r9 = call i64 @eval(i64 %r8)
  store i64 %r9, ptr %slot.result, align 8
  %r10 = load i64, ptr %slot.result, align 8
  %r11 = add i64 17, 0
  %r12 = call i64 @nova_rt_eq(i64 %r10, i64 %r11)
  %r13.p = getelementptr inbounds [12 x i8], ptr @.str.3, i64 0, i64 0
  %r13 = ptrtoint ptr %r13.p to i64
  %r14 = call i64 @nova_rt_assert(i64 %r12, i64 %r13)
  %r15 = add i64 2, 0
  %r16 = call i64 @make_num(i64 %r15)
  %r17 = add i64 3, 0
  %r18 = call i64 @make_num(i64 %r17)
  %r19 = call i64 @make_add(i64 %r16, i64 %r18)
  %r20 = add i64 4, 0
  %r21 = call i64 @make_num(i64 %r20)
  %r22 = call i64 @make_mul(i64 %r19, i64 %r21)
  store i64 %r22, ptr %slot.expr2, align 8
  %r23 = load i64, ptr %slot.expr2, align 8
  %r24 = call i64 @eval(i64 %r23)
  %r25 = add i64 20, 0
  %r26 = call i64 @nova_rt_eq(i64 %r24, i64 %r25)
  %r27.p = getelementptr inbounds [14 x i8], ptr @.str.4, i64 0, i64 0
  %r27 = ptrtoint ptr %r27.p to i64
  %r28 = call i64 @nova_rt_assert(i64 %r26, i64 %r27)
  %r29.p = getelementptr inbounds [29 x i8], ptr @.str.5, i64 0, i64 0
  %r29 = ptrtoint ptr %r29.p to i64
  %r30 = load i64, ptr %slot.result, align 8
  %r31 = call i64 @nova_rt_int_to_str(i64 %r30)
  %r32 = call i64 @nova_rt_str_concat(i64 %r29, i64 %r31)
  %r33 = call i64 @nova_rt_print_any(i64 %r32)
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
@.str.3 = private unnamed_addr constant [12 x i8] c"3*4+5 == 17\00"
@.str.4 = private unnamed_addr constant [14 x i8] c"(2+3)*4 == 20\00"
@.str.5 = private unnamed_addr constant [29 x i8] c"Recursive data test passed: \00"

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
