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

define i64 @test_alpha() nounwind {
entry:
  %slot.c = alloca i64, align 8
  store i64 0, ptr %slot.c, align 8
  %slot.__sc_0 = alloca i64, align 8
  store i64 0, ptr %slot.__sc_0, align 8
  %slot.__sc_3 = alloca i64, align 8
  store i64 0, ptr %slot.__sc_3, align 8
  %slot.__sc_6 = alloca i64, align 8
  store i64 0, ptr %slot.__sc_6, align 8
  %slot.r1 = alloca i64, align 8
  store i64 0, ptr %slot.r1, align 8
  %slot.__sc_9 = alloca i64, align 8
  store i64 0, ptr %slot.__sc_9, align 8
  %slot.r2 = alloca i64, align 8
  store i64 0, ptr %slot.r2, align 8
  %slot.__sc_12 = alloca i64, align 8
  store i64 0, ptr %slot.__sc_12, align 8
  %r0.p = getelementptr inbounds [2 x i8], ptr @.str.0, i64 0, i64 0
  %r0 = ptrtoint ptr %r0.p to i64
  %r1 = call i64 @nova_rt_ord(i64 %r0)
  store i64 %r1, ptr %slot.c, align 8
  %r2.p = getelementptr inbounds [10 x i8], ptr @.str.1, i64 0, i64 0
  %r2 = ptrtoint ptr %r2.p to i64
  %r3 = load i64, ptr %slot.c, align 8
  %r4 = call i64 @nova_rt_int_to_str(i64 %r3)
  %r5 = call i64 @nova_rt_str_concat(i64 %r2, i64 %r4)
  %r6 = call i64 @nova_rt_print_any(i64 %r5)
  %r7.p = getelementptr inbounds [10 x i8], ptr @.str.2, i64 0, i64 0
  %r7 = ptrtoint ptr %r7.p to i64
  %r8 = load i64, ptr %slot.c, align 8
  %r9 = add i64 65, 0
  %r10.cmp = icmp sge i64 %r8, %r9
  %r10 = zext i1 %r10.cmp to i64
  %r11 = call i64 @nova_rt_int_to_str(i64 %r10)
  %r12 = call i64 @nova_rt_str_concat(i64 %r7, i64 %r11)
  %r13 = call i64 @nova_rt_print_any(i64 %r12)
  %r14.p = getelementptr inbounds [10 x i8], ptr @.str.3, i64 0, i64 0
  %r14 = ptrtoint ptr %r14.p to i64
  %r15 = load i64, ptr %slot.c, align 8
  %r16 = add i64 90, 0
  %r17.cmp = icmp sle i64 %r15, %r16
  %r17 = zext i1 %r17.cmp to i64
  %r18 = call i64 @nova_rt_int_to_str(i64 %r17)
  %r19 = call i64 @nova_rt_str_concat(i64 %r14, i64 %r18)
  %r20 = call i64 @nova_rt_print_any(i64 %r19)
  %r21.p = getelementptr inbounds [10 x i8], ptr @.str.4, i64 0, i64 0
  %r21 = ptrtoint ptr %r21.p to i64
  %r22 = load i64, ptr %slot.c, align 8
  %r23 = add i64 97, 0
  %r24.cmp = icmp sge i64 %r22, %r23
  %r24 = zext i1 %r24.cmp to i64
  %r25 = call i64 @nova_rt_int_to_str(i64 %r24)
  %r26 = call i64 @nova_rt_str_concat(i64 %r21, i64 %r25)
  %r27 = call i64 @nova_rt_print_any(i64 %r26)
  %r28.p = getelementptr inbounds [11 x i8], ptr @.str.5, i64 0, i64 0
  %r28 = ptrtoint ptr %r28.p to i64
  %r29 = load i64, ptr %slot.c, align 8
  %r30 = add i64 122, 0
  %r31.cmp = icmp sle i64 %r29, %r30
  %r31 = zext i1 %r31.cmp to i64
  %r32 = call i64 @nova_rt_int_to_str(i64 %r31)
  %r33 = call i64 @nova_rt_str_concat(i64 %r28, i64 %r32)
  %r34 = call i64 @nova_rt_print_any(i64 %r33)
  %r35.p = getelementptr inbounds [24 x i8], ptr @.str.6, i64 0, i64 0
  %r35 = ptrtoint ptr %r35.p to i64
  %r36 = load i64, ptr %slot.c, align 8
  %r37 = add i64 65, 0
  %r38.cmp = icmp sge i64 %r36, %r37
  %r38 = zext i1 %r38.cmp to i64
  store i64 %r38, ptr %slot.__sc_0, align 8
  %br_and_rhs1 = icmp ne i64 %r38, 0
  br i1 %br_and_rhs1, label %and_rhs1, label %and_merge2
and_rhs1:
  %r39 = load i64, ptr %slot.c, align 8
  %r40 = add i64 90, 0
  %r41.cmp = icmp sle i64 %r39, %r40
  %r41 = zext i1 %r41.cmp to i64
  store i64 %r41, ptr %slot.__sc_0, align 8
  br label %and_merge2
and_merge2:
  %r42 = load i64, ptr %slot.__sc_0, align 8
  %r43 = call i64 @nova_rt_int_to_str(i64 %r42)
  %r44 = call i64 @nova_rt_str_concat(i64 %r35, i64 %r43)
  %r45 = call i64 @nova_rt_print_any(i64 %r44)
  %r46.p = getelementptr inbounds [25 x i8], ptr @.str.7, i64 0, i64 0
  %r46 = ptrtoint ptr %r46.p to i64
  %r47 = load i64, ptr %slot.c, align 8
  %r48 = add i64 97, 0
  %r49.cmp = icmp sge i64 %r47, %r48
  %r49 = zext i1 %r49.cmp to i64
  store i64 %r49, ptr %slot.__sc_3, align 8
  %br_and_rhs4 = icmp ne i64 %r49, 0
  br i1 %br_and_rhs4, label %and_rhs4, label %and_merge5
and_rhs4:
  %r50 = load i64, ptr %slot.c, align 8
  %r51 = add i64 122, 0
  %r52.cmp = icmp sle i64 %r50, %r51
  %r52 = zext i1 %r52.cmp to i64
  store i64 %r52, ptr %slot.__sc_3, align 8
  br label %and_merge5
and_merge5:
  %r53 = load i64, ptr %slot.__sc_3, align 8
  %r54 = call i64 @nova_rt_int_to_str(i64 %r53)
  %r55 = call i64 @nova_rt_str_concat(i64 %r46, i64 %r54)
  %r56 = call i64 @nova_rt_print_any(i64 %r55)
  %r57 = load i64, ptr %slot.c, align 8
  %r58 = add i64 65, 0
  %r59.cmp = icmp sge i64 %r57, %r58
  %r59 = zext i1 %r59.cmp to i64
  store i64 %r59, ptr %slot.__sc_6, align 8
  %br_and_rhs7 = icmp ne i64 %r59, 0
  br i1 %br_and_rhs7, label %and_rhs7, label %and_merge8
and_rhs7:
  %r60 = load i64, ptr %slot.c, align 8
  %r61 = add i64 90, 0
  %r62.cmp = icmp sle i64 %r60, %r61
  %r62 = zext i1 %r62.cmp to i64
  store i64 %r62, ptr %slot.__sc_6, align 8
  br label %and_merge8
and_merge8:
  %r63 = load i64, ptr %slot.__sc_6, align 8
  store i64 %r63, ptr %slot.r1, align 8
  %r64 = load i64, ptr %slot.c, align 8
  %r65 = add i64 97, 0
  %r66.cmp = icmp sge i64 %r64, %r65
  %r66 = zext i1 %r66.cmp to i64
  store i64 %r66, ptr %slot.__sc_9, align 8
  %br_and_rhs10 = icmp ne i64 %r66, 0
  br i1 %br_and_rhs10, label %and_rhs10, label %and_merge11
and_rhs10:
  %r67 = load i64, ptr %slot.c, align 8
  %r68 = add i64 122, 0
  %r69.cmp = icmp sle i64 %r67, %r68
  %r69 = zext i1 %r69.cmp to i64
  store i64 %r69, ptr %slot.__sc_9, align 8
  br label %and_merge11
and_merge11:
  %r70 = load i64, ptr %slot.__sc_9, align 8
  store i64 %r70, ptr %slot.r2, align 8
  %r71.p = getelementptr inbounds [5 x i8], ptr @.str.8, i64 0, i64 0
  %r71 = ptrtoint ptr %r71.p to i64
  %r72 = load i64, ptr %slot.r1, align 8
  %r73 = call i64 @nova_rt_int_to_str(i64 %r72)
  %r74 = call i64 @nova_rt_str_concat(i64 %r71, i64 %r73)
  %r75 = call i64 @nova_rt_print_any(i64 %r74)
  %r76.p = getelementptr inbounds [5 x i8], ptr @.str.9, i64 0, i64 0
  %r76 = ptrtoint ptr %r76.p to i64
  %r77 = load i64, ptr %slot.r2, align 8
  %r78 = call i64 @nova_rt_int_to_str(i64 %r77)
  %r79 = call i64 @nova_rt_str_concat(i64 %r76, i64 %r78)
  %r80 = call i64 @nova_rt_print_any(i64 %r79)
  %r81.p = getelementptr inbounds [11 x i8], ptr @.str.10, i64 0, i64 0
  %r81 = ptrtoint ptr %r81.p to i64
  %r82 = load i64, ptr %slot.r1, align 8
  store i64 %r82, ptr %slot.__sc_12, align 8
  %br_or_merge14 = icmp ne i64 %r82, 0
  br i1 %br_or_merge14, label %or_merge14, label %or_rhs13
or_rhs13:
  %r83 = load i64, ptr %slot.r2, align 8
  store i64 %r83, ptr %slot.__sc_12, align 8
  br label %or_merge14
or_merge14:
  %r84 = load i64, ptr %slot.__sc_12, align 8
  %r85 = call i64 @nova_rt_int_to_str(i64 %r84)
  %r86 = call i64 @nova_rt_str_concat(i64 %r81, i64 %r85)
  %r87 = call i64 @nova_rt_print_any(i64 %r86)
  ret i64 0
}

define i64 @nova_main() nounwind {
entry:
  %r0 = call i64 @test_alpha()
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
@.str.0 = private unnamed_addr constant [2 x i8] c"l\00"
@.str.1 = private unnamed_addr constant [10 x i8] c"ord(l) = \00"
@.str.2 = private unnamed_addr constant [10 x i8] c"c >= 65: \00"
@.str.3 = private unnamed_addr constant [10 x i8] c"c <= 90: \00"
@.str.4 = private unnamed_addr constant [10 x i8] c"c >= 97: \00"
@.str.5 = private unnamed_addr constant [11 x i8] c"c <= 122: \00"
@.str.6 = private unnamed_addr constant [24 x i8] c"(c >= 65 and c <= 90): \00"
@.str.7 = private unnamed_addr constant [25 x i8] c"(c >= 97 and c <= 122): \00"
@.str.8 = private unnamed_addr constant [5 x i8] c"r1: \00"
@.str.9 = private unnamed_addr constant [5 x i8] c"r2: \00"
@.str.10 = private unnamed_addr constant [11 x i8] c"r1 or r2: \00"
