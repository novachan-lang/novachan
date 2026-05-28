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

define i64 @check(i64 %p0, i64 %p1) nounwind {
entry:
  %slot.val = alloca i64, align 8
  store i64 %p0, ptr %slot.val, align 8
  %slot.expected = alloca i64, align 8
  store i64 %p1, ptr %slot.expected, align 8
  %r0 = load i64, ptr %slot.val, align 8
  %r1 = load i64, ptr %slot.expected, align 8
  %r2 = call i64 @nova_rt_eq(i64 %r0, i64 %r1)
  %br_retthen0 = icmp ne i64 %r2, 0
  br i1 %br_retthen0, label %retthen0, label %retelse1
retthen0:
  %r3.p = getelementptr inbounds [3 x i8], ptr @.str.0, i64 0, i64 0
  %r3 = ptrtoint ptr %r3.p to i64
  %r4 = call i64 @nova_rt_print_any(i64 %r3)
  ret i64 %r4
retelse1:
  %r5.p = getelementptr inbounds [5 x i8], ptr @.str.1, i64 0, i64 0
  %r5 = ptrtoint ptr %r5.p to i64
  %r6 = call i64 @nova_rt_print_any(i64 %r5)
  ret i64 %r6
}

define i64 @inc_and_true() nounwind {
entry:
  %slot.counter = alloca i64, align 8
  store i64 0, ptr %slot.counter, align 8
  %r0 = load i64, ptr %slot.counter, align 8
  %r1 = add i64 1, 0
  %r2 = call i64 @nova_rt_add(i64 %r0, i64 %r1)
  store i64 %r2, ptr %slot.counter, align 8
  %r3 = add i64 1, 0
  ret i64 %r3
}

define i64 @inc_and_false() nounwind {
entry:
  %slot.counter = alloca i64, align 8
  store i64 0, ptr %slot.counter, align 8
  %r0 = load i64, ptr %slot.counter, align 8
  %r1 = add i64 1, 0
  %r2 = call i64 @nova_rt_add(i64 %r0, i64 %r1)
  store i64 %r2, ptr %slot.counter, align 8
  %r3 = add i64 0, 0
  ret i64 %r3
}

define i64 @classify(i64 %p0) nounwind {
entry:
  %slot.x = alloca i64, align 8
  store i64 %p0, ptr %slot.x, align 8
  %slot.__sc_2 = alloca i64, align 8
  store i64 0, ptr %slot.__sc_2, align 8
  %slot.__sc_8 = alloca i64, align 8
  store i64 0, ptr %slot.__sc_8, align 8
  %r0 = load i64, ptr %slot.x, align 8
  %r1 = add i64 0, 0
  %r2.cmp = icmp sgt i64 %r0, %r1
  %r2 = zext i1 %r2.cmp to i64
  store i64 %r2, ptr %slot.__sc_2, align 8
  %br_and_rhs3 = icmp ne i64 %r2, 0
  br i1 %br_and_rhs3, label %and_rhs3, label %and_merge4
and_rhs3:
  %r3 = load i64, ptr %slot.x, align 8
  %r4 = add i64 10, 0
  %r5.cmp = icmp slt i64 %r3, %r4
  %r5 = zext i1 %r5.cmp to i64
  store i64 %r5, ptr %slot.__sc_2, align 8
  br label %and_merge4
and_merge4:
  %r6 = load i64, ptr %slot.__sc_2, align 8
  %br_then5 = icmp ne i64 %r6, 0
  br i1 %br_then5, label %then5, label %else6
then5:
  %r7.p = getelementptr inbounds [10 x i8], ptr @.str.2, i64 0, i64 0
  %r7 = ptrtoint ptr %r7.p to i64
  ret i64 %r7
else6:
  br label %endif7
endif7:
  %r8 = load i64, ptr %slot.x, align 8
  %r9 = add i64 0, 0
  %r10.cmp = icmp slt i64 %r8, %r9
  %r10 = zext i1 %r10.cmp to i64
  store i64 %r10, ptr %slot.__sc_8, align 8
  %br_or_merge10 = icmp ne i64 %r10, 0
  br i1 %br_or_merge10, label %or_merge10, label %or_rhs9
or_rhs9:
  %r11 = load i64, ptr %slot.x, align 8
  %r12 = add i64 100, 0
  %r13.cmp = icmp sgt i64 %r11, %r12
  %r13 = zext i1 %r13.cmp to i64
  store i64 %r13, ptr %slot.__sc_8, align 8
  br label %or_merge10
or_merge10:
  %r14 = load i64, ptr %slot.__sc_8, align 8
  %br_then11 = icmp ne i64 %r14, 0
  br i1 %br_then11, label %then11, label %else12
then11:
  %r15.p = getelementptr inbounds [13 x i8], ptr @.str.3, i64 0, i64 0
  %r15 = ptrtoint ptr %r15.p to i64
  ret i64 %r15
else12:
  br label %endif13
endif13:
  %r16.p = getelementptr inbounds [6 x i8], ptr @.str.4, i64 0, i64 0
  %r16 = ptrtoint ptr %r16.p to i64
  ret i64 %r16
}

define i64 @nova_main() nounwind {
entry:
  %slot.t = alloca i64, align 8
  store i64 0, ptr %slot.t, align 8
  %slot.f = alloca i64, align 8
  store i64 0, ptr %slot.f, align 8
  %slot.__sc_14 = alloca i64, align 8
  store i64 0, ptr %slot.__sc_14, align 8
  %slot.__sc_17 = alloca i64, align 8
  store i64 0, ptr %slot.__sc_17, align 8
  %slot.__sc_20 = alloca i64, align 8
  store i64 0, ptr %slot.__sc_20, align 8
  %slot.__sc_23 = alloca i64, align 8
  store i64 0, ptr %slot.__sc_23, align 8
  %slot.__sc_26 = alloca i64, align 8
  store i64 0, ptr %slot.__sc_26, align 8
  %slot.__sc_29 = alloca i64, align 8
  store i64 0, ptr %slot.__sc_29, align 8
  %slot.__sc_32 = alloca i64, align 8
  store i64 0, ptr %slot.__sc_32, align 8
  %slot.__sc_35 = alloca i64, align 8
  store i64 0, ptr %slot.__sc_35, align 8
  %slot.counter = alloca i64, align 8
  store i64 0, ptr %slot.counter, align 8
  %slot.__sc_38 = alloca i64, align 8
  store i64 0, ptr %slot.__sc_38, align 8
  %slot.r1 = alloca i64, align 8
  store i64 0, ptr %slot.r1, align 8
  %slot.__sc_41 = alloca i64, align 8
  store i64 0, ptr %slot.__sc_41, align 8
  %slot.r2 = alloca i64, align 8
  store i64 0, ptr %slot.r2, align 8
  %r0 = add i64 1, 0
  store i64 %r0, ptr %slot.t, align 8
  %r1 = add i64 0, 0
  store i64 %r1, ptr %slot.f, align 8
  %r2 = load i64, ptr %slot.t, align 8
  %r3 = add i64 1, 0
  %r4 = call i64 @check(i64 %r2, i64 %r3)
  %r5 = load i64, ptr %slot.f, align 8
  %r6 = add i64 0, 0
  %r7 = call i64 @check(i64 %r5, i64 %r6)
  %r8 = add i64 1, 0
  %r9.cmp = icmp eq i64 %r8, 0
  %r9 = zext i1 %r9.cmp to i64
  %r10 = add i64 0, 0
  %r11 = call i64 @check(i64 %r9, i64 %r10)
  %r12 = add i64 0, 0
  %r13.cmp = icmp eq i64 %r12, 0
  %r13 = zext i1 %r13.cmp to i64
  %r14 = add i64 1, 0
  %r15 = call i64 @check(i64 %r13, i64 %r14)
  %r16 = add i64 1, 0
  store i64 %r16, ptr %slot.__sc_14, align 8
  %br_and_rhs15 = icmp ne i64 %r16, 0
  br i1 %br_and_rhs15, label %and_rhs15, label %and_merge16
and_rhs15:
  %r17 = add i64 1, 0
  store i64 %r17, ptr %slot.__sc_14, align 8
  br label %and_merge16
and_merge16:
  %r18 = load i64, ptr %slot.__sc_14, align 8
  %r19 = add i64 1, 0
  %r20 = call i64 @check(i64 %r18, i64 %r19)
  %r21 = add i64 1, 0
  store i64 %r21, ptr %slot.__sc_17, align 8
  %br_and_rhs18 = icmp ne i64 %r21, 0
  br i1 %br_and_rhs18, label %and_rhs18, label %and_merge19
and_rhs18:
  %r22 = add i64 0, 0
  store i64 %r22, ptr %slot.__sc_17, align 8
  br label %and_merge19
and_merge19:
  %r23 = load i64, ptr %slot.__sc_17, align 8
  %r24 = add i64 0, 0
  %r25 = call i64 @check(i64 %r23, i64 %r24)
  %r26 = add i64 0, 0
  store i64 %r26, ptr %slot.__sc_20, align 8
  %br_and_rhs21 = icmp ne i64 %r26, 0
  br i1 %br_and_rhs21, label %and_rhs21, label %and_merge22
and_rhs21:
  %r27 = add i64 1, 0
  store i64 %r27, ptr %slot.__sc_20, align 8
  br label %and_merge22
and_merge22:
  %r28 = load i64, ptr %slot.__sc_20, align 8
  %r29 = add i64 0, 0
  %r30 = call i64 @check(i64 %r28, i64 %r29)
  %r31 = add i64 0, 0
  store i64 %r31, ptr %slot.__sc_23, align 8
  %br_and_rhs24 = icmp ne i64 %r31, 0
  br i1 %br_and_rhs24, label %and_rhs24, label %and_merge25
and_rhs24:
  %r32 = add i64 0, 0
  store i64 %r32, ptr %slot.__sc_23, align 8
  br label %and_merge25
and_merge25:
  %r33 = load i64, ptr %slot.__sc_23, align 8
  %r34 = add i64 0, 0
  %r35 = call i64 @check(i64 %r33, i64 %r34)
  %r36 = add i64 1, 0
  store i64 %r36, ptr %slot.__sc_26, align 8
  %br_or_merge28 = icmp ne i64 %r36, 0
  br i1 %br_or_merge28, label %or_merge28, label %or_rhs27
or_rhs27:
  %r37 = add i64 1, 0
  store i64 %r37, ptr %slot.__sc_26, align 8
  br label %or_merge28
or_merge28:
  %r38 = load i64, ptr %slot.__sc_26, align 8
  %r39 = add i64 1, 0
  %r40 = call i64 @check(i64 %r38, i64 %r39)
  %r41 = add i64 1, 0
  store i64 %r41, ptr %slot.__sc_29, align 8
  %br_or_merge31 = icmp ne i64 %r41, 0
  br i1 %br_or_merge31, label %or_merge31, label %or_rhs30
or_rhs30:
  %r42 = add i64 0, 0
  store i64 %r42, ptr %slot.__sc_29, align 8
  br label %or_merge31
or_merge31:
  %r43 = load i64, ptr %slot.__sc_29, align 8
  %r44 = add i64 1, 0
  %r45 = call i64 @check(i64 %r43, i64 %r44)
  %r46 = add i64 0, 0
  store i64 %r46, ptr %slot.__sc_32, align 8
  %br_or_merge34 = icmp ne i64 %r46, 0
  br i1 %br_or_merge34, label %or_merge34, label %or_rhs33
or_rhs33:
  %r47 = add i64 1, 0
  store i64 %r47, ptr %slot.__sc_32, align 8
  br label %or_merge34
or_merge34:
  %r48 = load i64, ptr %slot.__sc_32, align 8
  %r49 = add i64 1, 0
  %r50 = call i64 @check(i64 %r48, i64 %r49)
  %r51 = add i64 0, 0
  store i64 %r51, ptr %slot.__sc_35, align 8
  %br_or_merge37 = icmp ne i64 %r51, 0
  br i1 %br_or_merge37, label %or_merge37, label %or_rhs36
or_rhs36:
  %r52 = add i64 0, 0
  store i64 %r52, ptr %slot.__sc_35, align 8
  br label %or_merge37
or_merge37:
  %r53 = load i64, ptr %slot.__sc_35, align 8
  %r54 = add i64 0, 0
  %r55 = call i64 @check(i64 %r53, i64 %r54)
  %r56 = add i64 0, 0
  store i64 %r56, ptr %slot.counter, align 8
  %r57 = add i64 0, 0
  store i64 %r57, ptr %slot.counter, align 8
  %r58 = add i64 0, 0
  store i64 %r58, ptr %slot.__sc_38, align 8
  %br_and_rhs39 = icmp ne i64 %r58, 0
  br i1 %br_and_rhs39, label %and_rhs39, label %and_merge40
and_rhs39:
  %r59 = call i64 @inc_and_true()
  store i64 %r59, ptr %slot.__sc_38, align 8
  br label %and_merge40
and_merge40:
  %r60 = load i64, ptr %slot.__sc_38, align 8
  store i64 %r60, ptr %slot.r1, align 8
  %r61 = load i64, ptr %slot.counter, align 8
  %r62 = add i64 0, 0
  %r63 = call i64 @check(i64 %r61, i64 %r62)
  %r64 = add i64 0, 0
  store i64 %r64, ptr %slot.counter, align 8
  %r65 = add i64 1, 0
  store i64 %r65, ptr %slot.__sc_41, align 8
  %br_or_merge43 = icmp ne i64 %r65, 0
  br i1 %br_or_merge43, label %or_merge43, label %or_rhs42
or_rhs42:
  %r66 = call i64 @inc_and_true()
  store i64 %r66, ptr %slot.__sc_41, align 8
  br label %or_merge43
or_merge43:
  %r67 = load i64, ptr %slot.__sc_41, align 8
  store i64 %r67, ptr %slot.r2, align 8
  %r68 = load i64, ptr %slot.counter, align 8
  %r69 = add i64 0, 0
  %r70 = call i64 @check(i64 %r68, i64 %r69)
  %r71 = add i64 5, 0
  %r72 = call i64 @classify(i64 %r71)
  %r73 = call i64 @nova_rt_print_any(i64 %r72)
  %r74 = add i64 3, 0
  %r75 = sub i64 0, %r74
  %r76 = call i64 @classify(i64 %r75)
  %r77 = call i64 @nova_rt_print_any(i64 %r76)
  %r78 = add i64 50, 0
  %r79 = call i64 @classify(i64 %r78)
  %r80 = call i64 @nova_rt_print_any(i64 %r79)
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
@.str.0 = private unnamed_addr constant [3 x i8] c"ok\00"
@.str.1 = private unnamed_addr constant [5 x i8] c"FAIL\00"
@.str.2 = private unnamed_addr constant [10 x i8] c"small_pos\00"
@.str.3 = private unnamed_addr constant [13 x i8] c"out_of_range\00"
@.str.4 = private unnamed_addr constant [6 x i8] c"other\00"
