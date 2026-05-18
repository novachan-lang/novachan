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

define i64 @double(i64 %p0) nounwind {
entry:
  %slot.x = alloca i64, align 8
  store i64 %p0, ptr %slot.x, align 8
  %r0 = load i64, ptr %slot.x, align 8
  %r1 = mul i64 %r0, 2
  ret i64 %r1
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
  %r2 = call i64 @nova_rt_add(i64 %r0, i64 %r1)
  %r3 = load i64, ptr %slot.c, align 8
  %r4 = call i64 @nova_rt_add(i64 %r2, i64 %r3)
  ret i64 %r4
}

define i64 @greet(i64 %p0) nounwind {
entry:
  %slot.name = alloca i64, align 8
  store i64 %p0, ptr %slot.name, align 8
  %r0 = getelementptr inbounds [7 x i8], ptr @.str.0, i64 0, i64 0
  %r1 = ptrtoint ptr %r0 to i64
  %r2 = load i64, ptr %slot.name, align 8
  %r3 = call i64 @nova_rt_add(i64 %r1, i64 %r2)
  ret i64 %r3
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
  store i64 0, ptr %slot.i, align 8
  br label %while_hdr0
while_hdr0:
  %r1 = load i64, ptr %slot.i, align 8
  %r2 = load i64, ptr %slot.n, align 8
  %t4 = icmp slt i64 %r1, %r2
  %r3 = zext i1 %t4 to i64
  %t5 = icmp ne i64 %r3, 0
  br i1 %t5, label %while_body1, label %while_exit2
while_body1:
  %r6 = load i64, ptr %slot.result, align 8
  %r7 = load i64, ptr %slot.i, align 8
  %r8 = call i64 @nova_rt_list_append(i64 %r6, i64 %r7)
  %r9 = load i64, ptr %slot.i, align 8
  %r10 = call i64 @nova_rt_add(i64 %r9, i64 1)
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
  store i64 0, ptr %slot.total, align 8
  store i64 0, ptr %slot.i, align 8
  br label %while_hdr3
while_hdr3:
  %r0 = load i64, ptr %slot.i, align 8
  %r1 = load i64, ptr %slot.lst, align 8
  %r2 = call i64 @nova_rt_len_any(i64 %r1)
  %t4 = icmp slt i64 %r0, %r2
  %r3 = zext i1 %t4 to i64
  %t5 = icmp ne i64 %r3, 0
  br i1 %t5, label %while_body4, label %while_exit5
while_body4:
  %r6 = load i64, ptr %slot.total, align 8
  %r7 = load i64, ptr %slot.lst, align 8
  %r8 = load i64, ptr %slot.i, align 8
  %r9 = call i64 @nova_rt_index_get(i64 %r7, i64 %r8)
  %r10 = call i64 @nova_rt_add(i64 %r6, i64 %r9)
  store i64 %r10, ptr %slot.total, align 8
  %r11 = load i64, ptr %slot.i, align 8
  %r12 = call i64 @nova_rt_add(i64 %r11, i64 1)
  store i64 %r12, ptr %slot.i, align 8
  br label %while_hdr3
while_exit5:
  %r13 = load i64, ptr %slot.total, align 8
  ret i64 %r13
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
  %r0 = call i64 @double(i64 21)
  store i64 %r0, ptr %slot.x, align 8
  %r1 = call i64 @add_three(i64 1, i64 2, i64 3)
  store i64 %r1, ptr %slot.y, align 8
  %r2 = load i64, ptr %slot.y, align 8
  %r3 = call i64 @double(i64 %r2)
  %r4 = load i64, ptr %slot.x, align 8
  %r5 = call i64 @nova_rt_add(i64 %r3, i64 %r4)
  store i64 %r5, ptr %slot.z, align 8
  %r6 = getelementptr inbounds [6 x i8], ptr @.str.1, i64 0, i64 0
  %r7 = ptrtoint ptr %r6 to i64
  %r8 = call i64 @greet(i64 %r7)
  store i64 %r8, ptr %slot.msg, align 8
  %r9 = call i64 @make_list_of(i64 5)
  store i64 %r9, ptr %slot.nums, align 8
  %r10 = load i64, ptr %slot.nums, align 8
  %r11 = call i64 @sum_list(i64 %r10)
  store i64 %r11, ptr %slot.total, align 8
  %r12 = getelementptr inbounds [14 x i8], ptr @.str.2, i64 0, i64 0
  %r13 = ptrtoint ptr %r12 to i64
  %r14 = load i64, ptr %slot.x, align 8
  %r15 = call i64 @nova_rt_int_to_str(i64 %r14)
  %r16 = call i64 @nova_rt_add(i64 %r13, i64 %r15)
  %r17 = call i64 @nova_rt_print_any(i64 %r16)
  %r18 = getelementptr inbounds [20 x i8], ptr @.str.3, i64 0, i64 0
  %r19 = ptrtoint ptr %r18 to i64
  %r20 = load i64, ptr %slot.y, align 8
  %r21 = call i64 @nova_rt_int_to_str(i64 %r20)
  %r22 = call i64 @nova_rt_add(i64 %r19, i64 %r21)
  %r23 = call i64 @nova_rt_print_any(i64 %r22)
  %r24 = getelementptr inbounds [5 x i8], ptr @.str.4, i64 0, i64 0
  %r25 = ptrtoint ptr %r24 to i64
  %r26 = load i64, ptr %slot.z, align 8
  %r27 = call i64 @nova_rt_int_to_str(i64 %r26)
  %r28 = call i64 @nova_rt_add(i64 %r25, i64 %r27)
  %r29 = call i64 @nova_rt_print_any(i64 %r28)
  %r30 = getelementptr inbounds [9 x i8], ptr @.str.5, i64 0, i64 0
  %r31 = ptrtoint ptr %r30 to i64
  %r32 = load i64, ptr %slot.msg, align 8
  %r33 = call i64 @nova_rt_add(i64 %r31, i64 %r32)
  %r34 = call i64 @nova_rt_print_any(i64 %r33)
  %r35 = getelementptr inbounds [13 x i8], ptr @.str.6, i64 0, i64 0
  %r36 = ptrtoint ptr %r35 to i64
  %r37 = load i64, ptr %slot.total, align 8
  %r38 = call i64 @nova_rt_int_to_str(i64 %r37)
  %r39 = call i64 @nova_rt_add(i64 %r36, i64 %r38)
  %r40 = call i64 @nova_rt_print_any(i64 %r39)
  %r41 = load i64, ptr %slot.x, align 8
  %t43 = call i64 @nova_rt_eq(i64 %r41, i64 42)
  %r42 = and i64 %t43, 1
  %r44 = load i64, ptr %slot.y, align 8
  %t46 = call i64 @nova_rt_eq(i64 %r44, i64 6)
  %r45 = and i64 %t46, 1
  br label %and_entry6
and_entry6:
  %t48 = icmp ne i64 %t43, 0
  br i1 %t48, label %and_rhs7, label %and_end8
and_rhs7:
  %r49 = load i64, ptr %slot.y, align 8
  %t51 = call i64 @nova_rt_eq(i64 %r49, i64 6)
  %r50 = and i64 %t51, 1
  br label %and_done9
and_done9:
  br label %and_end8
and_end8:
  %r47 = phi i64 [0, %and_entry6], [%t51, %and_done9]
  %r52 = load i64, ptr %slot.z, align 8
  %t54 = call i64 @nova_rt_eq(i64 %r52, i64 54)
  %r53 = and i64 %t54, 1
  br label %and_entry10
and_entry10:
  %t56 = icmp ne i64 %r47, 0
  br i1 %t56, label %and_rhs11, label %and_end12
and_rhs11:
  %r57 = load i64, ptr %slot.z, align 8
  %t59 = call i64 @nova_rt_eq(i64 %r57, i64 54)
  %r58 = and i64 %t59, 1
  br label %and_done13
and_done13:
  br label %and_end12
and_end12:
  %r55 = phi i64 [0, %and_entry10], [%t59, %and_done13]
  %r60 = load i64, ptr %slot.msg, align 8
  %r61 = getelementptr inbounds [12 x i8], ptr @.str.7, i64 0, i64 0
  %r62 = ptrtoint ptr %r61 to i64
  %t64 = call i64 @nova_rt_eq(i64 %r60, i64 %r62)
  %r63 = and i64 %t64, 1
  br label %and_entry14
and_entry14:
  %t66 = icmp ne i64 %r55, 0
  br i1 %t66, label %and_rhs15, label %and_end16
and_rhs15:
  %r67 = load i64, ptr %slot.msg, align 8
  %r68 = getelementptr inbounds [12 x i8], ptr @.str.7, i64 0, i64 0
  %r69 = ptrtoint ptr %r68 to i64
  %t71 = call i64 @nova_rt_eq(i64 %r67, i64 %r69)
  %r70 = and i64 %t71, 1
  br label %and_done17
and_done17:
  br label %and_end16
and_end16:
  %r65 = phi i64 [0, %and_entry14], [%t71, %and_done17]
  %r72 = load i64, ptr %slot.total, align 8
  %t74 = call i64 @nova_rt_eq(i64 %r72, i64 10)
  %r73 = and i64 %t74, 1
  br label %and_entry18
and_entry18:
  %t76 = icmp ne i64 %r65, 0
  br i1 %t76, label %and_rhs19, label %and_end20
and_rhs19:
  %r77 = load i64, ptr %slot.total, align 8
  %t79 = call i64 @nova_rt_eq(i64 %r77, i64 10)
  %r78 = and i64 %t79, 1
  br label %and_done21
and_done21:
  br label %and_end20
and_end20:
  %r75 = phi i64 [0, %and_entry18], [%t79, %and_done21]
  %t80 = icmp ne i64 %r75, 0
  br i1 %t80, label %then22, label %else23
then22:
  %r81 = getelementptr inbounds [5 x i8], ptr @.str.8, i64 0, i64 0
  %r82 = ptrtoint ptr %r81 to i64
  %r83 = call i64 @nova_rt_print_any(i64 %r82)
  br label %merge24
else23:
  %r84 = getelementptr inbounds [5 x i8], ptr @.str.9, i64 0, i64 0
  %r85 = ptrtoint ptr %r84 to i64
  %r86 = call i64 @nova_rt_print_any(i64 %r85)
  br label %merge24
merge24:
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
