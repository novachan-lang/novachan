; NOVA IR-Pipeline Compiler Output
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
  %r0.p = getelementptr inbounds [4 x i8], ptr @.str.0, i64 0, i64 0
  %r0 = ptrtoint ptr %r0.p to i64
  %r1 = load i64, ptr %slot.n, align 8
  %r2 = add i64 0, 0
  %r3 = add i64 0, 0
  %r4.ptr = call ptr @nova_rt_struct_alloc(i64 32)
  %r4.f0 = getelementptr i64, ptr %r4.ptr, i64 0
  store i64 %r0, ptr %r4.f0, align 8
  %r4.f1 = getelementptr i64, ptr %r4.ptr, i64 1
  store i64 %r1, ptr %r4.f1, align 8
  %r4.f2 = getelementptr i64, ptr %r4.ptr, i64 2
  store i64 %r2, ptr %r4.f2, align 8
  %r4.f3 = getelementptr i64, ptr %r4.ptr, i64 3
  store i64 %r3, ptr %r4.f3, align 8
  %r4 = ptrtoint ptr %r4.ptr to i64
  ret i64 0
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
  %r4.ptr = call ptr @nova_rt_struct_alloc(i64 32)
  %r4.f0 = getelementptr i64, ptr %r4.ptr, i64 0
  store i64 %r0, ptr %r4.f0, align 8
  %r4.f1 = getelementptr i64, ptr %r4.ptr, i64 1
  store i64 %r1, ptr %r4.f1, align 8
  %r4.f2 = getelementptr i64, ptr %r4.ptr, i64 2
  store i64 %r2, ptr %r4.f2, align 8
  %r4.f3 = getelementptr i64, ptr %r4.ptr, i64 3
  store i64 %r3, ptr %r4.f3, align 8
  %r4 = ptrtoint ptr %r4.ptr to i64
  ret i64 0
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
  %r4.ptr = call ptr @nova_rt_struct_alloc(i64 32)
  %r4.f0 = getelementptr i64, ptr %r4.ptr, i64 0
  store i64 %r0, ptr %r4.f0, align 8
  %r4.f1 = getelementptr i64, ptr %r4.ptr, i64 1
  store i64 %r1, ptr %r4.f1, align 8
  %r4.f2 = getelementptr i64, ptr %r4.ptr, i64 2
  store i64 %r2, ptr %r4.f2, align 8
  %r4.f3 = getelementptr i64, ptr %r4.ptr, i64 3
  store i64 %r3, ptr %r4.f3, align 8
  %r4 = ptrtoint ptr %r4.ptr to i64
  ret i64 0
}

define i64 @eval_expr(i64 %p0) nounwind {
entry:
  %slot.e = alloca i64, align 8
  store i64 %p0, ptr %slot.e, align 8
  %r0 = add i64 0, 0
  ret i64 %r0
}

define i64 @expr_to_string(i64 %p0) nounwind {
entry:
  %slot.e = alloca i64, align 8
  store i64 %p0, ptr %slot.e, align 8
  %r0.p = getelementptr inbounds [2 x i8], ptr @.str.3, i64 0, i64 0
  %r0 = ptrtoint ptr %r0.p to i64
  ret i64 %r0
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
  call void @nova_rt_cleanup()
  ret i32 0
}

; String constants
@.str.0 = private unnamed_addr constant [4 x i8] c"num\00"
@.str.1 = private unnamed_addr constant [4 x i8] c"add\00"
@.str.2 = private unnamed_addr constant [4 x i8] c"mul\00"
@.str.3 = private unnamed_addr constant [2 x i8] c"?\00"
