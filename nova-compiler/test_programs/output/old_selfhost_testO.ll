; NOVA Self-Hosted Compiler Output
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"

@__nova_error_flag = thread_local global i64 0
@__nova_error_msg = thread_local global i64 0

; Runtime declarations
declare i32 @puts(ptr) nounwind
declare i32 @printf(ptr, ...) nounwind
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
declare i64 @nova_rt_float_bits(i64) nounwind
declare ptr @nova_rt_struct_alloc(i64) nounwind
declare i64 @nova_rt_slice(i64, i64, i64) nounwind
declare i64 @nova_rt_repeat(i64, i64) nounwind
declare i64 @nova_rt_chars(i64) nounwind
declare i64 @nova_rt_time_ms() nounwind
declare i64 @nova_rt_sleep_ms(i64) nounwind
declare i64 @nova_rt_clock_ns() nounwind
declare i64 @nova_rt_type_of(i64) nounwind
declare i64 @nova_rt_range(i64, i64) nounwind
declare i64 @nova_rt_sort(i64) nounwind
declare i64 @nova_rt_dict_keys(i64) nounwind
declare i64 @nova_rt_dict_values(i64) nounwind
declare i64 @nova_rt_create_string(ptr) nounwind
declare void @nova_rt_init_args(i64, i64) nounwind
declare void @nova_rt_cleanup() nounwind

define i64 @make_num(i64 %p0) nounwind {
entry:
  %slot.n = alloca i64, align 8
  store i64 %p0, ptr %slot.n, align 8
  %r0 = call ptr @nova_rt_struct_alloc(i64 32)
  %r1 = getelementptr inbounds [4 x i8], ptr @.str.0, i64 0, i64 0
  %r2 = ptrtoint ptr %r1 to i64
  %t3 = getelementptr i64, ptr %r0, i64 0
  store i64 %r2, ptr %t3, align 8
  %r4 = load i64, ptr %slot.n, align 8
  %t5 = getelementptr i64, ptr %r0, i64 1
  store i64 %r4, ptr %t5, align 8
  %t6 = getelementptr i64, ptr %r0, i64 2
  store i64 0, ptr %t6, align 8
  %t7 = getelementptr i64, ptr %r0, i64 3
  store i64 0, ptr %t7, align 8
  %r8 = ptrtoint ptr %r0 to i64
  ret i64 %r8
}

define i64 @make_add(i64 %p0, i64 %p1) nounwind {
entry:
  %slot.l = alloca i64, align 8
  store i64 %p0, ptr %slot.l, align 8
  %slot.r = alloca i64, align 8
  store i64 %p1, ptr %slot.r, align 8
  %r0 = call ptr @nova_rt_struct_alloc(i64 32)
  %r1 = getelementptr inbounds [4 x i8], ptr @.str.1, i64 0, i64 0
  %r2 = ptrtoint ptr %r1 to i64
  %t3 = getelementptr i64, ptr %r0, i64 0
  store i64 %r2, ptr %t3, align 8
  %t4 = getelementptr i64, ptr %r0, i64 1
  store i64 0, ptr %t4, align 8
  %r5 = load i64, ptr %slot.l, align 8
  %t6 = getelementptr i64, ptr %r0, i64 2
  store i64 %r5, ptr %t6, align 8
  %r7 = load i64, ptr %slot.r, align 8
  %t8 = getelementptr i64, ptr %r0, i64 3
  store i64 %r7, ptr %t8, align 8
  %r9 = ptrtoint ptr %r0 to i64
  ret i64 %r9
}

define i64 @make_mul(i64 %p0, i64 %p1) nounwind {
entry:
  %slot.l = alloca i64, align 8
  store i64 %p0, ptr %slot.l, align 8
  %slot.r = alloca i64, align 8
  store i64 %p1, ptr %slot.r, align 8
  %r0 = call ptr @nova_rt_struct_alloc(i64 32)
  %r1 = getelementptr inbounds [4 x i8], ptr @.str.2, i64 0, i64 0
  %r2 = ptrtoint ptr %r1 to i64
  %t3 = getelementptr i64, ptr %r0, i64 0
  store i64 %r2, ptr %t3, align 8
  %t4 = getelementptr i64, ptr %r0, i64 1
  store i64 0, ptr %t4, align 8
  %r5 = load i64, ptr %slot.l, align 8
  %t6 = getelementptr i64, ptr %r0, i64 2
  store i64 %r5, ptr %t6, align 8
  %r7 = load i64, ptr %slot.r, align 8
  %t8 = getelementptr i64, ptr %r0, i64 3
  store i64 %r7, ptr %t8, align 8
  %r9 = ptrtoint ptr %r0 to i64
  ret i64 %r9
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
  %t1 = inttoptr i64 %r0 to ptr
  %t2 = getelementptr i64, ptr %t1, i64 0
  %r3 = load i64, ptr %t2, align 8
  store i64 %r3, ptr %slot.tag, align 8
  %t4 = getelementptr i64, ptr %t1, i64 1
  %r5 = load i64, ptr %t4, align 8
  store i64 %r5, ptr %slot.value, align 8
  %t6 = getelementptr i64, ptr %t1, i64 2
  %r7 = load i64, ptr %t6, align 8
  store i64 %r7, ptr %slot.left, align 8
  %t8 = getelementptr i64, ptr %t1, i64 3
  %r9 = load i64, ptr %t8, align 8
  store i64 %r9, ptr %slot.right, align 8
  %r10 = load i64, ptr %slot.tag, align 8
  %r11 = getelementptr inbounds [4 x i8], ptr @.str.0, i64 0, i64 0
  %r12 = ptrtoint ptr %r11 to i64
  %t14 = call i64 @nova_rt_eq(i64 %r10, i64 %r12)
  %r13 = and i64 %t14, 1
  %t15 = icmp ne i64 %t14, 0
  br i1 %t15, label %then0, label %else1
then0:
  %r16 = load i64, ptr %slot.value, align 8
  ret i64 %r16
  br label %merge2
else1:
  %r17 = load i64, ptr %slot.tag, align 8
  %r18 = getelementptr inbounds [4 x i8], ptr @.str.1, i64 0, i64 0
  %r19 = ptrtoint ptr %r18 to i64
  %t21 = call i64 @nova_rt_eq(i64 %r17, i64 %r19)
  %r20 = and i64 %t21, 1
  %t22 = icmp ne i64 %t21, 0
  br i1 %t22, label %then3, label %else4
then3:
  %r23 = load i64, ptr %slot.left, align 8
  %r24 = call i64 @eval_expr(i64 %r23)
  %r25 = load i64, ptr %slot.right, align 8
  %r26 = call i64 @eval_expr(i64 %r25)
  %r27 = call i64 @nova_rt_add(i64 %r24, i64 %r26)
  ret i64 %r27
  br label %merge5
else4:
  %r28 = load i64, ptr %slot.tag, align 8
  %r29 = getelementptr inbounds [4 x i8], ptr @.str.2, i64 0, i64 0
  %r30 = ptrtoint ptr %r29 to i64
  %t32 = call i64 @nova_rt_eq(i64 %r28, i64 %r30)
  %r31 = and i64 %t32, 1
  %t33 = icmp ne i64 %t32, 0
  br i1 %t33, label %then6, label %else7
then6:
  %r34 = load i64, ptr %slot.left, align 8
  %r35 = call i64 @eval_expr(i64 %r34)
  %r36 = load i64, ptr %slot.right, align 8
  %r37 = call i64 @eval_expr(i64 %r36)
  %r38 = mul i64 %r35, %r37
  ret i64 %r38
  br label %merge8
else7:
  br label %merge8
merge8:
  br label %merge5
merge5:
  br label %merge2
merge2:
  ret i64 0
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
  %t1 = inttoptr i64 %r0 to ptr
  %t2 = getelementptr i64, ptr %t1, i64 0
  %r3 = load i64, ptr %t2, align 8
  store i64 %r3, ptr %slot.tag, align 8
  %t4 = getelementptr i64, ptr %t1, i64 1
  %r5 = load i64, ptr %t4, align 8
  store i64 %r5, ptr %slot.value, align 8
  %t6 = getelementptr i64, ptr %t1, i64 2
  %r7 = load i64, ptr %t6, align 8
  store i64 %r7, ptr %slot.left, align 8
  %t8 = getelementptr i64, ptr %t1, i64 3
  %r9 = load i64, ptr %t8, align 8
  store i64 %r9, ptr %slot.right, align 8
  %r10 = load i64, ptr %slot.tag, align 8
  %r11 = getelementptr inbounds [4 x i8], ptr @.str.0, i64 0, i64 0
  %r12 = ptrtoint ptr %r11 to i64
  %t14 = call i64 @nova_rt_eq(i64 %r10, i64 %r12)
  %r13 = and i64 %t14, 1
  %t15 = icmp ne i64 %t14, 0
  br i1 %t15, label %then9, label %else10
then9:
  %r16 = load i64, ptr %slot.value, align 8
  %r17 = call i64 @nova_rt_int_to_str(i64 %r16)
  ret i64 %r17
  br label %merge11
else10:
  %r18 = load i64, ptr %slot.tag, align 8
  %r19 = getelementptr inbounds [4 x i8], ptr @.str.1, i64 0, i64 0
  %r20 = ptrtoint ptr %r19 to i64
  %t22 = call i64 @nova_rt_eq(i64 %r18, i64 %r20)
  %r21 = and i64 %t22, 1
  %t23 = icmp ne i64 %t22, 0
  br i1 %t23, label %then12, label %else13
then12:
  %r24 = getelementptr inbounds [2 x i8], ptr @.str.3, i64 0, i64 0
  %r25 = ptrtoint ptr %r24 to i64
  %r26 = load i64, ptr %slot.left, align 8
  %r27 = call i64 @expr_to_string(i64 %r26)
  %r28 = call i64 @nova_rt_add(i64 %r25, i64 %r27)
  %r29 = getelementptr inbounds [4 x i8], ptr @.str.4, i64 0, i64 0
  %r30 = ptrtoint ptr %r29 to i64
  %r31 = call i64 @nova_rt_add(i64 %r28, i64 %r30)
  %r32 = load i64, ptr %slot.right, align 8
  %r33 = call i64 @expr_to_string(i64 %r32)
  %r34 = call i64 @nova_rt_add(i64 %r31, i64 %r33)
  %r35 = getelementptr inbounds [2 x i8], ptr @.str.5, i64 0, i64 0
  %r36 = ptrtoint ptr %r35 to i64
  %r37 = call i64 @nova_rt_add(i64 %r34, i64 %r36)
  ret i64 %r37
  br label %merge14
else13:
  %r38 = load i64, ptr %slot.tag, align 8
  %r39 = getelementptr inbounds [4 x i8], ptr @.str.2, i64 0, i64 0
  %r40 = ptrtoint ptr %r39 to i64
  %t42 = call i64 @nova_rt_eq(i64 %r38, i64 %r40)
  %r41 = and i64 %t42, 1
  %t43 = icmp ne i64 %t42, 0
  br i1 %t43, label %then15, label %else16
then15:
  %r44 = getelementptr inbounds [2 x i8], ptr @.str.3, i64 0, i64 0
  %r45 = ptrtoint ptr %r44 to i64
  %r46 = load i64, ptr %slot.left, align 8
  %r47 = call i64 @expr_to_string(i64 %r46)
  %r48 = call i64 @nova_rt_add(i64 %r45, i64 %r47)
  %r49 = getelementptr inbounds [4 x i8], ptr @.str.6, i64 0, i64 0
  %r50 = ptrtoint ptr %r49 to i64
  %r51 = call i64 @nova_rt_add(i64 %r48, i64 %r50)
  %r52 = load i64, ptr %slot.right, align 8
  %r53 = call i64 @expr_to_string(i64 %r52)
  %r54 = call i64 @nova_rt_add(i64 %r51, i64 %r53)
  %r55 = getelementptr inbounds [2 x i8], ptr @.str.5, i64 0, i64 0
  %r56 = ptrtoint ptr %r55 to i64
  %r57 = call i64 @nova_rt_add(i64 %r54, i64 %r56)
  ret i64 %r57
  br label %merge17
else16:
  br label %merge17
merge17:
  br label %merge14
merge14:
  br label %merge11
merge11:
  %r58 = getelementptr inbounds [2 x i8], ptr @.str.7, i64 0, i64 0
  %r59 = ptrtoint ptr %r58 to i64
  ret i64 %r59
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
  %r0 = call i64 @make_num(i64 3)
  %r1 = call i64 @make_num(i64 4)
  %r2 = call i64 @make_add(i64 %r0, i64 %r1)
  store i64 %r2, ptr %slot.e1, align 8
  %r3 = call i64 @make_num(i64 2)
  %r4 = call i64 @make_num(i64 5)
  %r5 = call i64 @make_add(i64 %r3, i64 %r4)
  store i64 %r5, ptr %slot.e2, align 8
  %r6 = load i64, ptr %slot.e1, align 8
  %r7 = load i64, ptr %slot.e2, align 8
  %r8 = call i64 @make_mul(i64 %r6, i64 %r7)
  store i64 %r8, ptr %slot.e3, align 8
  %r9 = load i64, ptr %slot.e3, align 8
  %r10 = call i64 @expr_to_string(i64 %r9)
  %r11 = call i64 @nova_rt_print_any(i64 %r10)
  %r12 = load i64, ptr %slot.e3, align 8
  %r13 = call i64 @eval_expr(i64 %r12)
  %r14 = call i64 @nova_rt_print_any(i64 %r13)
  %r15 = call i64 @make_num(i64 10)
  %r16 = call i64 @make_num(i64 20)
  %r17 = call i64 @make_num(i64 3)
  %r18 = call i64 @make_mul(i64 %r16, i64 %r17)
  %r19 = call i64 @make_add(i64 %r15, i64 %r18)
  store i64 %r19, ptr %slot.e4, align 8
  %r20 = load i64, ptr %slot.e4, align 8
  %r21 = call i64 @expr_to_string(i64 %r20)
  %r22 = call i64 @nova_rt_print_any(i64 %r21)
  %r23 = load i64, ptr %slot.e4, align 8
  %r24 = call i64 @eval_expr(i64 %r23)
  %r25 = call i64 @nova_rt_print_any(i64 %r24)
  ret i64 0
}

define i32 @main(i32 %argc, ptr %argv) nounwind {
entry:
  %argc64 = sext i32 %argc to i64
  %argv64 = ptrtoint ptr %argv to i64
  call void @nova_rt_init_args(i64 %argc64, i64 %argv64)
  call i64 @nova_main()
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
