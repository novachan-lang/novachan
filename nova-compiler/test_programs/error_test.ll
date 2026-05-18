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

define i64 @risky_divide(i64 %p0, i64 %p1) nounwind {
entry:
  %slot.a = alloca i64, align 8
  store i64 %p0, ptr %slot.a, align 8
  %slot.b = alloca i64, align 8
  store i64 %p1, ptr %slot.b, align 8
  %r0 = load i64, ptr %slot.b, align 8
  %r1 = add i64 0, 0
  %r2 = call i64 @nova_rt_eq(i64 %r0, i64 %r1)
  %br_then0 = icmp ne i64 %r2, 0
  br i1 %br_then0, label %then0, label %else1
then0:
  %r3.p = getelementptr inbounds [17 x i8], ptr @.str.0, i64 0, i64 0
  %r3 = ptrtoint ptr %r3.p to i64
  store i64 1, ptr @__nova_error_flag
  store i64 %r3, ptr @__nova_error_msg
  %r4 = add i64 0, 0
  %r5 = add i64 0, 0
  ret i64 %r5
else1:
  br label %endif2
endif2:
  %r6 = load i64, ptr %slot.a, align 8
  %r7 = load i64, ptr %slot.b, align 8
  %r8 = sdiv i64 %r6, %r7
  ret i64 %r8
}

define i64 @risky_lookup(i64 %p0, i64 %p1) nounwind {
entry:
  %slot.items = alloca i64, align 8
  store i64 %p0, ptr %slot.items, align 8
  %slot.idx = alloca i64, align 8
  store i64 %p1, ptr %slot.idx, align 8
  %slot.__sc_3 = alloca i64, align 8
  store i64 0, ptr %slot.__sc_3, align 8
  %r0 = load i64, ptr %slot.idx, align 8
  %r1 = add i64 0, 0
  %r2.cmp = icmp slt i64 %r0, %r1
  %r2 = zext i1 %r2.cmp to i64
  store i64 %r2, ptr %slot.__sc_3, align 8
  %br_or_merge5 = icmp ne i64 %r2, 0
  br i1 %br_or_merge5, label %or_merge5, label %or_rhs4
or_rhs4:
  %r3 = load i64, ptr %slot.idx, align 8
  %r4 = load i64, ptr %slot.items, align 8
  %r5 = call i64 @nova_rt_len_any(i64 %r4)
  %r6.cmp = icmp sge i64 %r3, %r5
  %r6 = zext i1 %r6.cmp to i64
  store i64 %r6, ptr %slot.__sc_3, align 8
  br label %or_merge5
or_merge5:
  %r7 = load i64, ptr %slot.__sc_3, align 8
  %br_then6 = icmp ne i64 %r7, 0
  br i1 %br_then6, label %then6, label %else7
then6:
  %r8.p = getelementptr inbounds [20 x i8], ptr @.str.1, i64 0, i64 0
  %r8 = ptrtoint ptr %r8.p to i64
  store i64 1, ptr @__nova_error_flag
  store i64 %r8, ptr @__nova_error_msg
  %r9 = add i64 0, 0
  %r10.p = getelementptr inbounds [1 x i8], ptr @.str.2, i64 0, i64 0
  %r10 = ptrtoint ptr %r10.p to i64
  ret i64 %r10
else7:
  br label %endif8
endif8:
  %r11 = load i64, ptr %slot.items, align 8
  %r12 = load i64, ptr %slot.idx, align 8
  %r13 = call i64 @nova_rt_index_get(i64 %r11, i64 %r12)
  ret i64 %r13
}

define i64 @main() nounwind {
entry:
  %slot.__catch_9 = alloca i64, align 8
  store i64 0, ptr %slot.__catch_9, align 8
  %slot.e = alloca i64, align 8
  store i64 0, ptr %slot.e, align 8
  %slot.result = alloca i64, align 8
  store i64 0, ptr %slot.result, align 8
  %slot.__catch_13 = alloca i64, align 8
  store i64 0, ptr %slot.__catch_13, align 8
  %slot.good = alloca i64, align 8
  store i64 0, ptr %slot.good, align 8
  %slot.items = alloca i64, align 8
  store i64 0, ptr %slot.items, align 8
  %slot.__catch_17 = alloca i64, align 8
  store i64 0, ptr %slot.__catch_17, align 8
  %slot.val = alloca i64, align 8
  store i64 0, ptr %slot.val, align 8
  %slot.__catch_21 = alloca i64, align 8
  store i64 0, ptr %slot.__catch_21, align 8
  %slot.val2 = alloca i64, align 8
  store i64 0, ptr %slot.val2, align 8
  %r0 = add i64 10, 0
  %r1 = add i64 0, 0
  %r2 = call i64 @risky_divide(i64 %r0, i64 %r1)
  store i64 %r2, ptr %slot.__catch_9, align 8
  %r3.fl = load i64, ptr @__nova_error_flag
  store i64 0, ptr @__nova_error_flag
  %r3.cmp = icmp ne i64 %r3.fl, 0
  %r3 = zext i1 %r3.cmp to i64
  %br_catch_err10 = icmp ne i64 %r3, 0
  br i1 %br_catch_err10, label %catch_err10, label %catch_ok11
catch_err10:
  %r4.raw = load i64, ptr @__nova_error_msg
  store i64 0, ptr @__nova_error_msg
  %r4 = add i64 %r4.raw, 0
  store i64 %r4, ptr %slot.e, align 8
  %r5.p = getelementptr inbounds [15 x i8], ptr @.str.3, i64 0, i64 0
  %r5 = ptrtoint ptr %r5.p to i64
  %r6 = load i64, ptr %slot.e, align 8
  %r7 = call i64 @nova_rt_any_to_str(i64 %r6)
  %r8 = call i64 @nova_rt_str_concat(i64 %r5, i64 %r7)
  %r9.p = getelementptr inbounds [1 x i8], ptr @.str.2, i64 0, i64 0
  %r9 = ptrtoint ptr %r9.p to i64
  %r10 = call i64 @nova_rt_str_concat(i64 %r8, i64 %r9)
  %r11 = call i64 @nova_rt_print_any(i64 %r10)
  store i64 %r11, ptr %slot.__catch_9, align 8
  br label %catch_merge12
catch_ok11:
  store i64 %r2, ptr %slot.__catch_9, align 8
  br label %catch_merge12
catch_merge12:
  %r12 = load i64, ptr %slot.__catch_9, align 8
  store i64 %r12, ptr %slot.result, align 8
  %r13 = add i64 1, 0
  %r14 = sub i64 0, %r13
  %r15.p = getelementptr inbounds [9 x i8], ptr @.str.4, i64 0, i64 0
  %r15 = ptrtoint ptr %r15.p to i64
  %r16 = load i64, ptr %slot.result, align 8
  %r17 = call i64 @nova_rt_any_to_str(i64 %r16)
  %r18 = call i64 @nova_rt_str_concat(i64 %r15, i64 %r17)
  %r19.p = getelementptr inbounds [1 x i8], ptr @.str.2, i64 0, i64 0
  %r19 = ptrtoint ptr %r19.p to i64
  %r20 = call i64 @nova_rt_str_concat(i64 %r18, i64 %r19)
  %r21 = call i64 @nova_rt_print_any(i64 %r20)
  %r22 = add i64 20, 0
  %r23 = add i64 4, 0
  %r24 = call i64 @risky_divide(i64 %r22, i64 %r23)
  store i64 %r24, ptr %slot.__catch_13, align 8
  %r25.fl = load i64, ptr @__nova_error_flag
  store i64 0, ptr @__nova_error_flag
  %r25.cmp = icmp ne i64 %r25.fl, 0
  %r25 = zext i1 %r25.cmp to i64
  %br_catch_err14 = icmp ne i64 %r25, 0
  br i1 %br_catch_err14, label %catch_err14, label %catch_ok15
catch_err14:
  %r26.raw = load i64, ptr @__nova_error_msg
  store i64 0, ptr @__nova_error_msg
  %r26 = add i64 %r26.raw, 0
  store i64 %r26, ptr %slot.e, align 8
  %r27.p = getelementptr inbounds [22 x i8], ptr @.str.5, i64 0, i64 0
  %r27 = ptrtoint ptr %r27.p to i64
  %r28 = call i64 @nova_rt_print_any(i64 %r27)
  store i64 %r28, ptr %slot.__catch_13, align 8
  br label %catch_merge16
catch_ok15:
  store i64 %r24, ptr %slot.__catch_13, align 8
  br label %catch_merge16
catch_merge16:
  %r29 = load i64, ptr %slot.__catch_13, align 8
  store i64 %r29, ptr %slot.good, align 8
  %r30 = add i64 1, 0
  %r31 = sub i64 0, %r30
  %r32.p = getelementptr inbounds [14 x i8], ptr @.str.6, i64 0, i64 0
  %r32 = ptrtoint ptr %r32.p to i64
  %r33 = load i64, ptr %slot.good, align 8
  %r34 = call i64 @nova_rt_any_to_str(i64 %r33)
  %r35 = call i64 @nova_rt_str_concat(i64 %r32, i64 %r34)
  %r36.p = getelementptr inbounds [1 x i8], ptr @.str.2, i64 0, i64 0
  %r36 = ptrtoint ptr %r36.p to i64
  %r37 = call i64 @nova_rt_str_concat(i64 %r35, i64 %r36)
  %r38 = call i64 @nova_rt_print_any(i64 %r37)
  %r40.p = getelementptr inbounds [6 x i8], ptr @.str.7, i64 0, i64 0
  %r40 = ptrtoint ptr %r40.p to i64
  %r41.p = getelementptr inbounds [6 x i8], ptr @.str.8, i64 0, i64 0
  %r41 = ptrtoint ptr %r41.p to i64
  %r39 = call i64 @nova_rt_list_create()
  call i64 @nova_rt_list_append(i64 %r39, i64 %r40)
  call i64 @nova_rt_list_append(i64 %r39, i64 %r41)
  store i64 %r39, ptr %slot.items, align 8
  %r42 = load i64, ptr %slot.items, align 8
  %r43 = add i64 5, 0
  %r44 = call i64 @risky_lookup(i64 %r42, i64 %r43)
  store i64 %r44, ptr %slot.__catch_17, align 8
  %r45.fl = load i64, ptr @__nova_error_flag
  store i64 0, ptr @__nova_error_flag
  %r45.cmp = icmp ne i64 %r45.fl, 0
  %r45 = zext i1 %r45.cmp to i64
  %br_catch_err18 = icmp ne i64 %r45, 0
  br i1 %br_catch_err18, label %catch_err18, label %catch_ok19
catch_err18:
  %r46.raw = load i64, ptr @__nova_error_msg
  store i64 0, ptr @__nova_error_msg
  %r46 = add i64 %r46.raw, 0
  store i64 %r46, ptr %slot.e, align 8
  %r47.p = getelementptr inbounds [15 x i8], ptr @.str.9, i64 0, i64 0
  %r47 = ptrtoint ptr %r47.p to i64
  %r48 = load i64, ptr %slot.e, align 8
  %r49 = call i64 @nova_rt_any_to_str(i64 %r48)
  %r50 = call i64 @nova_rt_str_concat(i64 %r47, i64 %r49)
  %r51.p = getelementptr inbounds [1 x i8], ptr @.str.2, i64 0, i64 0
  %r51 = ptrtoint ptr %r51.p to i64
  %r52 = call i64 @nova_rt_str_concat(i64 %r50, i64 %r51)
  %r53 = call i64 @nova_rt_print_any(i64 %r52)
  store i64 %r53, ptr %slot.__catch_17, align 8
  br label %catch_merge20
catch_ok19:
  store i64 %r44, ptr %slot.__catch_17, align 8
  br label %catch_merge20
catch_merge20:
  %r54 = load i64, ptr %slot.__catch_17, align 8
  store i64 %r54, ptr %slot.val, align 8
  %r55.p = getelementptr inbounds [8 x i8], ptr @.str.10, i64 0, i64 0
  %r55 = ptrtoint ptr %r55.p to i64
  %r56.p = getelementptr inbounds [16 x i8], ptr @.str.11, i64 0, i64 0
  %r56 = ptrtoint ptr %r56.p to i64
  %r57 = load i64, ptr %slot.val, align 8
  %r58 = call i64 @nova_rt_any_to_str(i64 %r57)
  %r59 = call i64 @nova_rt_str_concat(i64 %r56, i64 %r58)
  %r60.p = getelementptr inbounds [1 x i8], ptr @.str.2, i64 0, i64 0
  %r60 = ptrtoint ptr %r60.p to i64
  %r61 = call i64 @nova_rt_str_concat(i64 %r59, i64 %r60)
  %r62 = call i64 @nova_rt_print_any(i64 %r61)
  %r63 = load i64, ptr %slot.items, align 8
  %r64 = add i64 0, 0
  %r65 = call i64 @risky_lookup(i64 %r63, i64 %r64)
  store i64 %r65, ptr %slot.__catch_21, align 8
  %r66.fl = load i64, ptr @__nova_error_flag
  store i64 0, ptr @__nova_error_flag
  %r66.cmp = icmp ne i64 %r66.fl, 0
  %r66 = zext i1 %r66.cmp to i64
  %br_catch_err22 = icmp ne i64 %r66, 0
  br i1 %br_catch_err22, label %catch_err22, label %catch_ok23
catch_err22:
  %r67.raw = load i64, ptr @__nova_error_msg
  store i64 0, ptr @__nova_error_msg
  %r67 = add i64 %r67.raw, 0
  store i64 %r67, ptr %slot.e, align 8
  %r68.p = getelementptr inbounds [9 x i8], ptr @.str.12, i64 0, i64 0
  %r68 = ptrtoint ptr %r68.p to i64
  store i64 %r68, ptr %slot.__catch_21, align 8
  br label %catch_merge24
catch_ok23:
  store i64 %r65, ptr %slot.__catch_21, align 8
  br label %catch_merge24
catch_merge24:
  %r69 = load i64, ptr %slot.__catch_21, align 8
  store i64 %r69, ptr %slot.val2, align 8
  %r70.p = getelementptr inbounds [12 x i8], ptr @.str.13, i64 0, i64 0
  %r70 = ptrtoint ptr %r70.p to i64
  %r71 = load i64, ptr %slot.val2, align 8
  %r72 = call i64 @nova_rt_any_to_str(i64 %r71)
  %r73 = call i64 @nova_rt_str_concat(i64 %r70, i64 %r72)
  %r74.p = getelementptr inbounds [1 x i8], ptr @.str.2, i64 0, i64 0
  %r74 = ptrtoint ptr %r74.p to i64
  %r75 = call i64 @nova_rt_str_concat(i64 %r73, i64 %r74)
  %r76 = call i64 @nova_rt_print_any(i64 %r75)
  %r77.p = getelementptr inbounds [24 x i8], ptr @.str.14, i64 0, i64 0
  %r77 = ptrtoint ptr %r77.p to i64
  %r78 = call i64 @nova_rt_print_any(i64 %r77)
  ret i64 %r78
}

define i64 @nova_main() nounwind {
entry:
  %r0 = call i64 @main()
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
@.str.0 = private unnamed_addr constant [17 x i8] c"division by zero\00"
@.str.1 = private unnamed_addr constant [20 x i8] c"index out of bounds\00"
@.str.2 = private unnamed_addr constant [1 x i8] c"\00"
@.str.3 = private unnamed_addr constant [15 x i8] c"Caught error: \00"
@.str.4 = private unnamed_addr constant [9 x i8] c"Result: \00"
@.str.5 = private unnamed_addr constant [22 x i8] c"Should not reach here\00"
@.str.6 = private unnamed_addr constant [14 x i8] c"Good result: \00"
@.str.7 = private unnamed_addr constant [6 x i8] c"hello\00"
@.str.8 = private unnamed_addr constant [6 x i8] c"world\00"
@.str.9 = private unnamed_addr constant [15 x i8] c"Lookup error: \00"
@.str.10 = private unnamed_addr constant [8 x i8] c"default\00"
@.str.11 = private unnamed_addr constant [16 x i8] c"Lookup result: \00"
@.str.12 = private unnamed_addr constant [9 x i8] c"fallback\00"
@.str.13 = private unnamed_addr constant [12 x i8] c"Lookup ok: \00"
@.str.14 = private unnamed_addr constant [24 x i8] c"All error tests passed!\00"
