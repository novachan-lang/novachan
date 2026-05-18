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
declare i64 @nova_rt_system(i64) nounwind
declare i64 @nova_rt_exec(i64) nounwind
declare i64 @nova_rt_create_string(ptr) nounwind
declare void @nova_rt_init_args(i64, i64) nounwind
declare void @nova_rt_cleanup() nounwind

define i64 @double(i64 %p0) nounwind {
entry:
  %slot.x = alloca i64, align 8
  store i64 %p0, ptr %slot.x, align 8
  %r0 = load i64, ptr %slot.x, align 8
  %r1 = add i64 2, 0
  %r2 = mul i64 %r0, %r1
  ret i64 %r2
}

define i64 @add_three(i64 %p0, i64 %p1, i64 %p2) nounwind {
entry:
  %slot.a = alloca i64, align 8
  store i64 %p0, ptr %slot.a, align 8
  %slot.b = alloca i64, align 8
  store i64 %p1, ptr %slot.b, align 8
  %slot.c = alloca i64, align 8
  store i64 %p2, ptr %slot.c, align 8
  %r0 = load i64, ptr %slot.a, align 8
  %r1 = load i64, ptr %slot.b, align 8
  %r2 = add i64 %r0, %r1
  %r3 = load i64, ptr %slot.c, align 8
  %r4 = add i64 %r2, %r3
  ret i64 %r4
}

define i64 @greet(i64 %p0) nounwind {
entry:
  %slot.name = alloca i64, align 8
  store i64 %p0, ptr %slot.name, align 8
  %r0.p = getelementptr inbounds [7 x i8], ptr @.str.0, i64 0, i64 0
  %r0 = ptrtoint ptr %r0.p to i64
  %r1 = load i64, ptr %slot.name, align 8
  %r2 = call i64 @nova_rt_str_concat(i64 %r0, i64 %r1)
  ret i64 %r2
}

define i64 @make_list_of(i64 %p0) nounwind {
entry:
  %slot.n = alloca i64, align 8
  store i64 %p0, ptr %slot.n, align 8
  %slot.result = alloca i64, align 8
  store i64 0, ptr %slot.result, align 8
  %slot.i = alloca i64, align 8
  store i64 0, ptr %slot.i, align 8
  %r0 = call i64 @nova_rt_list_create()
  store i64 %r0, ptr %slot.result, align 8
  %r1 = add i64 0, 0
  store i64 %r1, ptr %slot.i, align 8
  br label %while_hdr0
while_hdr0:
  %r2 = load i64, ptr %slot.i, align 8
  %r3 = load i64, ptr %slot.n, align 8
  %r4.cmp = icmp slt i64 %r2, %r3
  %r4 = zext i1 %r4.cmp to i64
  %br_while_body1 = icmp ne i64 %r4, 0
  br i1 %br_while_body1, label %while_body1, label %while_exit2
while_body1:
  %r5 = load i64, ptr %slot.result, align 8
  %r6 = load i64, ptr %slot.i, align 8
  %r7 = call i64 @nova_rt_list_append(i64 %r5, i64 %r6)
  %r8 = load i64, ptr %slot.i, align 8
  %r9 = add i64 1, 0
  %r10 = add i64 %r8, %r9
  store i64 %r10, ptr %slot.i, align 8
  br label %while_hdr0
while_exit2:
  %r11 = load i64, ptr %slot.result, align 8
  ret i64 %r11
}

define i64 @sum_list(i64 %p0) nounwind {
entry:
  %slot.lst = alloca i64, align 8
  store i64 %p0, ptr %slot.lst, align 8
  %slot.total = alloca i64, align 8
  store i64 0, ptr %slot.total, align 8
  %slot.i = alloca i64, align 8
  store i64 0, ptr %slot.i, align 8
  %r0 = add i64 0, 0
  store i64 %r0, ptr %slot.total, align 8
  %r1 = add i64 0, 0
  store i64 %r1, ptr %slot.i, align 8
  br label %while_hdr3
while_hdr3:
  %r2 = load i64, ptr %slot.i, align 8
  %r3 = load i64, ptr %slot.lst, align 8
  %r4 = call i64 @nova_rt_len_any(i64 %r3)
  %r5.cmp = icmp slt i64 %r2, %r4
  %r5 = zext i1 %r5.cmp to i64
  %br_while_body4 = icmp ne i64 %r5, 0
  br i1 %br_while_body4, label %while_body4, label %while_exit5
while_body4:
  %r6 = load i64, ptr %slot.total, align 8
  %r7 = load i64, ptr %slot.lst, align 8
  %r8 = load i64, ptr %slot.i, align 8
  %r9 = call i64 @nova_rt_index_get(i64 %r7, i64 %r8)
  %r10 = call i64 @nova_rt_add(i64 %r6, i64 %r9)
  store i64 %r10, ptr %slot.total, align 8
  %r11 = load i64, ptr %slot.i, align 8
  %r12 = add i64 1, 0
  %r13 = add i64 %r11, %r12
  store i64 %r13, ptr %slot.i, align 8
  br label %while_hdr3
while_exit5:
  %r14 = load i64, ptr %slot.total, align 8
  ret i64 %r14
}

define i64 @nova_main() nounwind {
entry:
  %slot.x = alloca i64, align 8
  store i64 0, ptr %slot.x, align 8
  %slot.y = alloca i64, align 8
  store i64 0, ptr %slot.y, align 8
  %slot.z = alloca i64, align 8
  store i64 0, ptr %slot.z, align 8
  %slot.msg = alloca i64, align 8
  store i64 0, ptr %slot.msg, align 8
  %slot.nums = alloca i64, align 8
  store i64 0, ptr %slot.nums, align 8
  %slot.total = alloca i64, align 8
  store i64 0, ptr %slot.total, align 8
  %slot.__sc_6 = alloca i64, align 8
  store i64 0, ptr %slot.__sc_6, align 8
  %slot.__sc_9 = alloca i64, align 8
  store i64 0, ptr %slot.__sc_9, align 8
  %slot.__sc_12 = alloca i64, align 8
  store i64 0, ptr %slot.__sc_12, align 8
  %slot.__sc_15 = alloca i64, align 8
  store i64 0, ptr %slot.__sc_15, align 8
  %r0 = add i64 21, 0
  %r1 = call i64 @double(i64 %r0)
  store i64 %r1, ptr %slot.x, align 8
  %r2 = add i64 1, 0
  %r3 = add i64 2, 0
  %r4 = add i64 3, 0
  %r5 = call i64 @add_three(i64 %r2, i64 %r3, i64 %r4)
  store i64 %r5, ptr %slot.y, align 8
  %r6 = load i64, ptr %slot.y, align 8
  %r7 = call i64 @double(i64 %r6)
  %r8 = load i64, ptr %slot.x, align 8
  %r9 = add i64 %r7, %r8
  store i64 %r9, ptr %slot.z, align 8
  %r10.p = getelementptr inbounds [6 x i8], ptr @.str.1, i64 0, i64 0
  %r10 = ptrtoint ptr %r10.p to i64
  %r11 = call i64 @greet(i64 %r10)
  store i64 %r11, ptr %slot.msg, align 8
  %r12 = add i64 5, 0
  %r13 = call i64 @make_list_of(i64 %r12)
  store i64 %r13, ptr %slot.nums, align 8
  %r14 = load i64, ptr %slot.nums, align 8
  %r15 = call i64 @sum_list(i64 %r14)
  store i64 %r15, ptr %slot.total, align 8
  %r16.p = getelementptr inbounds [14 x i8], ptr @.str.2, i64 0, i64 0
  %r16 = ptrtoint ptr %r16.p to i64
  %r17 = load i64, ptr %slot.x, align 8
  %r18 = call i64 @nova_rt_int_to_str(i64 %r17)
  %r19 = call i64 @nova_rt_str_concat(i64 %r16, i64 %r18)
  %r20 = call i64 @nova_rt_print_any(i64 %r19)
  %r21.p = getelementptr inbounds [20 x i8], ptr @.str.3, i64 0, i64 0
  %r21 = ptrtoint ptr %r21.p to i64
  %r22 = load i64, ptr %slot.y, align 8
  %r23 = call i64 @nova_rt_int_to_str(i64 %r22)
  %r24 = call i64 @nova_rt_str_concat(i64 %r21, i64 %r23)
  %r25 = call i64 @nova_rt_print_any(i64 %r24)
  %r26.p = getelementptr inbounds [5 x i8], ptr @.str.4, i64 0, i64 0
  %r26 = ptrtoint ptr %r26.p to i64
  %r27 = load i64, ptr %slot.z, align 8
  %r28 = call i64 @nova_rt_int_to_str(i64 %r27)
  %r29 = call i64 @nova_rt_str_concat(i64 %r26, i64 %r28)
  %r30 = call i64 @nova_rt_print_any(i64 %r29)
  %r31.p = getelementptr inbounds [9 x i8], ptr @.str.5, i64 0, i64 0
  %r31 = ptrtoint ptr %r31.p to i64
  %r32 = load i64, ptr %slot.msg, align 8
  %r33 = call i64 @nova_rt_str_concat(i64 %r31, i64 %r32)
  %r34 = call i64 @nova_rt_print_any(i64 %r33)
  %r35.p = getelementptr inbounds [13 x i8], ptr @.str.6, i64 0, i64 0
  %r35 = ptrtoint ptr %r35.p to i64
  %r36 = load i64, ptr %slot.total, align 8
  %r37 = call i64 @nova_rt_int_to_str(i64 %r36)
  %r38 = call i64 @nova_rt_str_concat(i64 %r35, i64 %r37)
  %r39 = call i64 @nova_rt_print_any(i64 %r38)
  %r40 = load i64, ptr %slot.x, align 8
  %r41 = add i64 42, 0
  %r42.cmp = icmp eq i64 %r40, %r41
  %r42 = zext i1 %r42.cmp to i64
  store i64 %r42, ptr %slot.__sc_6, align 8
  %br_and_rhs7 = icmp ne i64 %r42, 0
  br i1 %br_and_rhs7, label %and_rhs7, label %and_merge8
and_rhs7:
  %r43 = load i64, ptr %slot.y, align 8
  %r44 = add i64 6, 0
  %r45.cmp = icmp eq i64 %r43, %r44
  %r45 = zext i1 %r45.cmp to i64
  store i64 %r45, ptr %slot.__sc_6, align 8
  br label %and_merge8
and_merge8:
  %r46 = load i64, ptr %slot.__sc_6, align 8
  store i64 %r46, ptr %slot.__sc_9, align 8
  %br_and_rhs10 = icmp ne i64 %r46, 0
  br i1 %br_and_rhs10, label %and_rhs10, label %and_merge11
and_rhs10:
  %r47 = load i64, ptr %slot.z, align 8
  %r48 = add i64 54, 0
  %r49.cmp = icmp eq i64 %r47, %r48
  %r49 = zext i1 %r49.cmp to i64
  store i64 %r49, ptr %slot.__sc_9, align 8
  br label %and_merge11
and_merge11:
  %r50 = load i64, ptr %slot.__sc_9, align 8
  store i64 %r50, ptr %slot.__sc_12, align 8
  %br_and_rhs13 = icmp ne i64 %r50, 0
  br i1 %br_and_rhs13, label %and_rhs13, label %and_merge14
and_rhs13:
  %r51 = load i64, ptr %slot.msg, align 8
  %r52.p = getelementptr inbounds [12 x i8], ptr @.str.7, i64 0, i64 0
  %r52 = ptrtoint ptr %r52.p to i64
  %r53.p0 = inttoptr i64 %r51 to ptr
  %r53.p1 = inttoptr i64 %r52 to ptr
  %r53.sc = call i32 @strcmp(ptr %r53.p0, ptr %r53.p1)
  %r53.cmp = icmp eq i32 %r53.sc, 0
  %r53 = zext i1 %r53.cmp to i64
  store i64 %r53, ptr %slot.__sc_12, align 8
  br label %and_merge14
and_merge14:
  %r54 = load i64, ptr %slot.__sc_12, align 8
  store i64 %r54, ptr %slot.__sc_15, align 8
  %br_and_rhs16 = icmp ne i64 %r54, 0
  br i1 %br_and_rhs16, label %and_rhs16, label %and_merge17
and_rhs16:
  %r55 = load i64, ptr %slot.total, align 8
  %r56 = add i64 10, 0
  %r57 = call i64 @nova_rt_eq(i64 %r55, i64 %r56)
  store i64 %r57, ptr %slot.__sc_15, align 8
  br label %and_merge17
and_merge17:
  %r58 = load i64, ptr %slot.__sc_15, align 8
  %br_then18 = icmp ne i64 %r58, 0
  br i1 %br_then18, label %then18, label %else19
then18:
  %r59.p = getelementptr inbounds [5 x i8], ptr @.str.8, i64 0, i64 0
  %r59 = ptrtoint ptr %r59.p to i64
  %r60 = call i64 @nova_rt_print_any(i64 %r59)
  br label %endif20
else19:
  %r61.p = getelementptr inbounds [5 x i8], ptr @.str.9, i64 0, i64 0
  %r61 = ptrtoint ptr %r61.p to i64
  %r62 = call i64 @nova_rt_print_any(i64 %r61)
  br label %endif20
endif20:
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
@.str.0 = private unnamed_addr constant [7 x i8] c"hello \00"
@.str.1 = private unnamed_addr constant [6 x i8] c"world\00"
@.str.2 = private unnamed_addr constant [14 x i8] c"double(21) = \00"
@.str.3 = private unnamed_addr constant [20 x i8] c"add_three(1,2,3) = \00"
@.str.4 = private unnamed_addr constant [5 x i8] c"z = \00"
@.str.5 = private unnamed_addr constant [9 x i8] c"greet = \00"
@.str.6 = private unnamed_addr constant [13 x i8] c"sum(0..5) = \00"
@.str.7 = private unnamed_addr constant [12 x i8] c"hello world\00"
@.str.8 = private unnamed_addr constant [5 x i8] c"PASS\00"
@.str.9 = private unnamed_addr constant [5 x i8] c"FAIL\00"
