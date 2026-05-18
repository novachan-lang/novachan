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

define i64 @is_alpha(i64 %p0) nounwind {
entry:
  %slot.ch = alloca i64, align 8
  store i64 %p0, ptr %slot.ch, align 8
  %slot.c = alloca i64, align 8
  store i64 0, ptr %slot.c, align 8
  %slot.__sc_0 = alloca i64, align 8
  store i64 0, ptr %slot.__sc_0, align 8
  %slot.__sc_3 = alloca i64, align 8
  store i64 0, ptr %slot.__sc_3, align 8
  %slot.__sc_6 = alloca i64, align 8
  store i64 0, ptr %slot.__sc_6, align 8
  %slot.__sc_9 = alloca i64, align 8
  store i64 0, ptr %slot.__sc_9, align 8
  %r0 = load i64, ptr %slot.ch, align 8
  %r1 = call i64 @nova_rt_ord(i64 %r0)
  store i64 %r1, ptr %slot.c, align 8
  %r2 = load i64, ptr %slot.c, align 8
  %r3 = add i64 65, 0
  %r4.cmp = icmp sge i64 %r2, %r3
  %r4 = zext i1 %r4.cmp to i64
  store i64 %r4, ptr %slot.__sc_0, align 8
  %br_and_rhs1 = icmp ne i64 %r4, 0
  br i1 %br_and_rhs1, label %and_rhs1, label %and_merge2
and_rhs1:
  %r5 = load i64, ptr %slot.c, align 8
  %r6 = add i64 90, 0
  %r7.cmp = icmp sle i64 %r5, %r6
  %r7 = zext i1 %r7.cmp to i64
  store i64 %r7, ptr %slot.__sc_0, align 8
  br label %and_merge2
and_merge2:
  %r8 = load i64, ptr %slot.__sc_0, align 8
  store i64 %r8, ptr %slot.__sc_3, align 8
  %br_or_merge5 = icmp ne i64 %r8, 0
  br i1 %br_or_merge5, label %or_merge5, label %or_rhs4
or_rhs4:
  %r9 = load i64, ptr %slot.c, align 8
  %r10 = add i64 97, 0
  %r11.cmp = icmp sge i64 %r9, %r10
  %r11 = zext i1 %r11.cmp to i64
  store i64 %r11, ptr %slot.__sc_6, align 8
  %br_and_rhs7 = icmp ne i64 %r11, 0
  br i1 %br_and_rhs7, label %and_rhs7, label %and_merge8
and_rhs7:
  %r12 = load i64, ptr %slot.c, align 8
  %r13 = add i64 122, 0
  %r14.cmp = icmp sle i64 %r12, %r13
  %r14 = zext i1 %r14.cmp to i64
  store i64 %r14, ptr %slot.__sc_6, align 8
  br label %and_merge8
and_merge8:
  %r15 = load i64, ptr %slot.__sc_6, align 8
  store i64 %r15, ptr %slot.__sc_3, align 8
  br label %or_merge5
or_merge5:
  %r16 = load i64, ptr %slot.__sc_3, align 8
  store i64 %r16, ptr %slot.__sc_9, align 8
  %br_or_merge11 = icmp ne i64 %r16, 0
  br i1 %br_or_merge11, label %or_merge11, label %or_rhs10
or_rhs10:
  %r17 = load i64, ptr %slot.ch, align 8
  %r18.p = getelementptr inbounds [2 x i8], ptr @.str.0, i64 0, i64 0
  %r18 = ptrtoint ptr %r18.p to i64
  %r19 = call i64 @nova_rt_eq(i64 %r17, i64 %r18)
  store i64 %r19, ptr %slot.__sc_9, align 8
  br label %or_merge11
or_merge11:
  %r20 = load i64, ptr %slot.__sc_9, align 8
  ret i64 %r20
}

define i64 @is_digit(i64 %p0) nounwind {
entry:
  %slot.ch = alloca i64, align 8
  store i64 %p0, ptr %slot.ch, align 8
  %slot.c = alloca i64, align 8
  store i64 0, ptr %slot.c, align 8
  %slot.__sc_12 = alloca i64, align 8
  store i64 0, ptr %slot.__sc_12, align 8
  %r0 = load i64, ptr %slot.ch, align 8
  %r1 = call i64 @nova_rt_ord(i64 %r0)
  store i64 %r1, ptr %slot.c, align 8
  %r2 = load i64, ptr %slot.c, align 8
  %r3 = add i64 48, 0
  %r4.cmp = icmp sge i64 %r2, %r3
  %r4 = zext i1 %r4.cmp to i64
  store i64 %r4, ptr %slot.__sc_12, align 8
  %br_and_rhs13 = icmp ne i64 %r4, 0
  br i1 %br_and_rhs13, label %and_rhs13, label %and_merge14
and_rhs13:
  %r5 = load i64, ptr %slot.c, align 8
  %r6 = add i64 57, 0
  %r7.cmp = icmp sle i64 %r5, %r6
  %r7 = zext i1 %r7.cmp to i64
  store i64 %r7, ptr %slot.__sc_12, align 8
  br label %and_merge14
and_merge14:
  %r8 = load i64, ptr %slot.__sc_12, align 8
  ret i64 %r8
}

define i64 @is_alnum(i64 %p0) nounwind {
entry:
  %slot.ch = alloca i64, align 8
  store i64 %p0, ptr %slot.ch, align 8
  %slot.__sc_15 = alloca i64, align 8
  store i64 0, ptr %slot.__sc_15, align 8
  %r0 = load i64, ptr %slot.ch, align 8
  %r1 = call i64 @is_alpha(i64 %r0)
  store i64 %r1, ptr %slot.__sc_15, align 8
  %br_or_merge17 = icmp ne i64 %r1, 0
  br i1 %br_or_merge17, label %or_merge17, label %or_rhs16
or_rhs16:
  %r2 = load i64, ptr %slot.ch, align 8
  %r3 = call i64 @is_digit(i64 %r2)
  store i64 %r3, ptr %slot.__sc_15, align 8
  br label %or_merge17
or_merge17:
  %r4 = load i64, ptr %slot.__sc_15, align 8
  ret i64 %r4
}

define i64 @is_ws(i64 %p0) nounwind {
entry:
  %slot.ch = alloca i64, align 8
  store i64 %p0, ptr %slot.ch, align 8
  %slot.__sc_18 = alloca i64, align 8
  store i64 0, ptr %slot.__sc_18, align 8
  %slot.__sc_21 = alloca i64, align 8
  store i64 0, ptr %slot.__sc_21, align 8
  %r0 = load i64, ptr %slot.ch, align 8
  %r1.p = getelementptr inbounds [2 x i8], ptr @.str.1, i64 0, i64 0
  %r1 = ptrtoint ptr %r1.p to i64
  %r2 = call i64 @nova_rt_eq(i64 %r0, i64 %r1)
  store i64 %r2, ptr %slot.__sc_18, align 8
  %br_or_merge20 = icmp ne i64 %r2, 0
  br i1 %br_or_merge20, label %or_merge20, label %or_rhs19
or_rhs19:
  %r3 = load i64, ptr %slot.ch, align 8
  %r4.p = getelementptr inbounds [2 x i8], ptr @.str.2, i64 0, i64 0
  %r4 = ptrtoint ptr %r4.p to i64
  %r5 = call i64 @nova_rt_eq(i64 %r3, i64 %r4)
  store i64 %r5, ptr %slot.__sc_18, align 8
  br label %or_merge20
or_merge20:
  %r6 = load i64, ptr %slot.__sc_18, align 8
  store i64 %r6, ptr %slot.__sc_21, align 8
  %br_or_merge23 = icmp ne i64 %r6, 0
  br i1 %br_or_merge23, label %or_merge23, label %or_rhs22
or_rhs22:
  %r7 = load i64, ptr %slot.ch, align 8
  %r8.p = getelementptr inbounds [2 x i8], ptr @.str.3, i64 0, i64 0
  %r8 = ptrtoint ptr %r8.p to i64
  %r9 = call i64 @nova_rt_eq(i64 %r7, i64 %r8)
  store i64 %r9, ptr %slot.__sc_21, align 8
  br label %or_merge23
or_merge23:
  %r10 = load i64, ptr %slot.__sc_21, align 8
  ret i64 %r10
}

define i64 @is_keyword(i64 %p0) nounwind {
entry:
  %slot.word = alloca i64, align 8
  store i64 %p0, ptr %slot.word, align 8
  %slot.__sc_24 = alloca i64, align 8
  store i64 0, ptr %slot.__sc_24, align 8
  %slot.__sc_27 = alloca i64, align 8
  store i64 0, ptr %slot.__sc_27, align 8
  %slot.__sc_30 = alloca i64, align 8
  store i64 0, ptr %slot.__sc_30, align 8
  %slot.__sc_33 = alloca i64, align 8
  store i64 0, ptr %slot.__sc_33, align 8
  %slot.__sc_36 = alloca i64, align 8
  store i64 0, ptr %slot.__sc_36, align 8
  %slot.__sc_39 = alloca i64, align 8
  store i64 0, ptr %slot.__sc_39, align 8
  %slot.__sc_42 = alloca i64, align 8
  store i64 0, ptr %slot.__sc_42, align 8
  %slot.__sc_45 = alloca i64, align 8
  store i64 0, ptr %slot.__sc_45, align 8
  %slot.__sc_48 = alloca i64, align 8
  store i64 0, ptr %slot.__sc_48, align 8
  %slot.__sc_51 = alloca i64, align 8
  store i64 0, ptr %slot.__sc_51, align 8
  %slot.__sc_54 = alloca i64, align 8
  store i64 0, ptr %slot.__sc_54, align 8
  %slot.__sc_57 = alloca i64, align 8
  store i64 0, ptr %slot.__sc_57, align 8
  %slot.__sc_60 = alloca i64, align 8
  store i64 0, ptr %slot.__sc_60, align 8
  %slot.__sc_63 = alloca i64, align 8
  store i64 0, ptr %slot.__sc_63, align 8
  %slot.__sc_66 = alloca i64, align 8
  store i64 0, ptr %slot.__sc_66, align 8
  %slot.__sc_69 = alloca i64, align 8
  store i64 0, ptr %slot.__sc_69, align 8
  %slot.__sc_72 = alloca i64, align 8
  store i64 0, ptr %slot.__sc_72, align 8
  %slot.__sc_75 = alloca i64, align 8
  store i64 0, ptr %slot.__sc_75, align 8
  %slot.__sc_78 = alloca i64, align 8
  store i64 0, ptr %slot.__sc_78, align 8
  %r0 = load i64, ptr %slot.word, align 8
  %r1.p = getelementptr inbounds [4 x i8], ptr @.str.4, i64 0, i64 0
  %r1 = ptrtoint ptr %r1.p to i64
  %r2 = call i64 @nova_rt_eq(i64 %r0, i64 %r1)
  store i64 %r2, ptr %slot.__sc_24, align 8
  %br_or_merge26 = icmp ne i64 %r2, 0
  br i1 %br_or_merge26, label %or_merge26, label %or_rhs25
or_rhs25:
  %r3 = load i64, ptr %slot.word, align 8
  %r4.p = getelementptr inbounds [3 x i8], ptr @.str.5, i64 0, i64 0
  %r4 = ptrtoint ptr %r4.p to i64
  %r5 = call i64 @nova_rt_eq(i64 %r3, i64 %r4)
  store i64 %r5, ptr %slot.__sc_24, align 8
  br label %or_merge26
or_merge26:
  %r6 = load i64, ptr %slot.__sc_24, align 8
  store i64 %r6, ptr %slot.__sc_27, align 8
  %br_or_merge29 = icmp ne i64 %r6, 0
  br i1 %br_or_merge29, label %or_merge29, label %or_rhs28
or_rhs28:
  %r7 = load i64, ptr %slot.word, align 8
  %r8.p = getelementptr inbounds [5 x i8], ptr @.str.6, i64 0, i64 0
  %r8 = ptrtoint ptr %r8.p to i64
  %r9 = call i64 @nova_rt_eq(i64 %r7, i64 %r8)
  store i64 %r9, ptr %slot.__sc_27, align 8
  br label %or_merge29
or_merge29:
  %r10 = load i64, ptr %slot.__sc_27, align 8
  store i64 %r10, ptr %slot.__sc_30, align 8
  %br_or_merge32 = icmp ne i64 %r10, 0
  br i1 %br_or_merge32, label %or_merge32, label %or_rhs31
or_rhs31:
  %r11 = load i64, ptr %slot.word, align 8
  %r12.p = getelementptr inbounds [3 x i8], ptr @.str.7, i64 0, i64 0
  %r12 = ptrtoint ptr %r12.p to i64
  %r13 = call i64 @nova_rt_eq(i64 %r11, i64 %r12)
  store i64 %r13, ptr %slot.__sc_30, align 8
  br label %or_merge32
or_merge32:
  %r14 = load i64, ptr %slot.__sc_30, align 8
  store i64 %r14, ptr %slot.__sc_33, align 8
  %br_or_merge35 = icmp ne i64 %r14, 0
  br i1 %br_or_merge35, label %or_merge35, label %or_rhs34
or_rhs34:
  %r15 = load i64, ptr %slot.word, align 8
  %r16.p = getelementptr inbounds [6 x i8], ptr @.str.8, i64 0, i64 0
  %r16 = ptrtoint ptr %r16.p to i64
  %r17 = call i64 @nova_rt_eq(i64 %r15, i64 %r16)
  store i64 %r17, ptr %slot.__sc_33, align 8
  br label %or_merge35
or_merge35:
  %r18 = load i64, ptr %slot.__sc_33, align 8
  store i64 %r18, ptr %slot.__sc_36, align 8
  %br_or_merge38 = icmp ne i64 %r18, 0
  br i1 %br_or_merge38, label %or_merge38, label %or_rhs37
or_rhs37:
  %r19 = load i64, ptr %slot.word, align 8
  %r20.p = getelementptr inbounds [4 x i8], ptr @.str.9, i64 0, i64 0
  %r20 = ptrtoint ptr %r20.p to i64
  %r21 = call i64 @nova_rt_eq(i64 %r19, i64 %r20)
  store i64 %r21, ptr %slot.__sc_36, align 8
  br label %or_merge38
or_merge38:
  %r22 = load i64, ptr %slot.__sc_36, align 8
  store i64 %r22, ptr %slot.__sc_39, align 8
  %br_or_merge41 = icmp ne i64 %r22, 0
  br i1 %br_or_merge41, label %or_merge41, label %or_rhs40
or_rhs40:
  %r23 = load i64, ptr %slot.word, align 8
  %r24.p = getelementptr inbounds [7 x i8], ptr @.str.10, i64 0, i64 0
  %r24 = ptrtoint ptr %r24.p to i64
  %r25 = call i64 @nova_rt_eq(i64 %r23, i64 %r24)
  store i64 %r25, ptr %slot.__sc_39, align 8
  br label %or_merge41
or_merge41:
  %r26 = load i64, ptr %slot.__sc_39, align 8
  store i64 %r26, ptr %slot.__sc_42, align 8
  %br_or_merge44 = icmp ne i64 %r26, 0
  br i1 %br_or_merge44, label %or_merge44, label %or_rhs43
or_rhs43:
  %r27 = load i64, ptr %slot.word, align 8
  %r28.p = getelementptr inbounds [6 x i8], ptr @.str.11, i64 0, i64 0
  %r28 = ptrtoint ptr %r28.p to i64
  %r29 = call i64 @nova_rt_eq(i64 %r27, i64 %r28)
  store i64 %r29, ptr %slot.__sc_42, align 8
  br label %or_merge44
or_merge44:
  %r30 = load i64, ptr %slot.__sc_42, align 8
  store i64 %r30, ptr %slot.__sc_45, align 8
  %br_or_merge47 = icmp ne i64 %r30, 0
  br i1 %br_or_merge47, label %or_merge47, label %or_rhs46
or_rhs46:
  %r31 = load i64, ptr %slot.word, align 8
  %r32.p = getelementptr inbounds [5 x i8], ptr @.str.12, i64 0, i64 0
  %r32 = ptrtoint ptr %r32.p to i64
  %r33 = call i64 @nova_rt_eq(i64 %r31, i64 %r32)
  store i64 %r33, ptr %slot.__sc_45, align 8
  br label %or_merge47
or_merge47:
  %r34 = load i64, ptr %slot.__sc_45, align 8
  store i64 %r34, ptr %slot.__sc_48, align 8
  %br_or_merge50 = icmp ne i64 %r34, 0
  br i1 %br_or_merge50, label %or_merge50, label %or_rhs49
or_rhs49:
  %r35 = load i64, ptr %slot.word, align 8
  %r36.p = getelementptr inbounds [5 x i8], ptr @.str.13, i64 0, i64 0
  %r36 = ptrtoint ptr %r36.p to i64
  %r37 = call i64 @nova_rt_eq(i64 %r35, i64 %r36)
  store i64 %r37, ptr %slot.__sc_48, align 8
  br label %or_merge50
or_merge50:
  %r38 = load i64, ptr %slot.__sc_48, align 8
  store i64 %r38, ptr %slot.__sc_51, align 8
  %br_or_merge53 = icmp ne i64 %r38, 0
  br i1 %br_or_merge53, label %or_merge53, label %or_rhs52
or_rhs52:
  %r39 = load i64, ptr %slot.word, align 8
  %r40.p = getelementptr inbounds [6 x i8], ptr @.str.14, i64 0, i64 0
  %r40 = ptrtoint ptr %r40.p to i64
  %r41 = call i64 @nova_rt_eq(i64 %r39, i64 %r40)
  store i64 %r41, ptr %slot.__sc_51, align 8
  br label %or_merge53
or_merge53:
  %r42 = load i64, ptr %slot.__sc_51, align 8
  store i64 %r42, ptr %slot.__sc_54, align 8
  %br_or_merge56 = icmp ne i64 %r42, 0
  br i1 %br_or_merge56, label %or_merge56, label %or_rhs55
or_rhs55:
  %r43 = load i64, ptr %slot.word, align 8
  %r44.p = getelementptr inbounds [4 x i8], ptr @.str.15, i64 0, i64 0
  %r44 = ptrtoint ptr %r44.p to i64
  %r45 = call i64 @nova_rt_eq(i64 %r43, i64 %r44)
  store i64 %r45, ptr %slot.__sc_54, align 8
  br label %or_merge56
or_merge56:
  %r46 = load i64, ptr %slot.__sc_54, align 8
  store i64 %r46, ptr %slot.__sc_57, align 8
  %br_or_merge59 = icmp ne i64 %r46, 0
  br i1 %br_or_merge59, label %or_merge59, label %or_rhs58
or_rhs58:
  %r47 = load i64, ptr %slot.word, align 8
  %r48.p = getelementptr inbounds [3 x i8], ptr @.str.16, i64 0, i64 0
  %r48 = ptrtoint ptr %r48.p to i64
  %r49 = call i64 @nova_rt_eq(i64 %r47, i64 %r48)
  store i64 %r49, ptr %slot.__sc_57, align 8
  br label %or_merge59
or_merge59:
  %r50 = load i64, ptr %slot.__sc_57, align 8
  store i64 %r50, ptr %slot.__sc_60, align 8
  %br_or_merge62 = icmp ne i64 %r50, 0
  br i1 %br_or_merge62, label %or_merge62, label %or_rhs61
or_rhs61:
  %r51 = load i64, ptr %slot.word, align 8
  %r52.p = getelementptr inbounds [4 x i8], ptr @.str.17, i64 0, i64 0
  %r52 = ptrtoint ptr %r52.p to i64
  %r53 = call i64 @nova_rt_eq(i64 %r51, i64 %r52)
  store i64 %r53, ptr %slot.__sc_60, align 8
  br label %or_merge62
or_merge62:
  %r54 = load i64, ptr %slot.__sc_60, align 8
  store i64 %r54, ptr %slot.__sc_63, align 8
  %br_or_merge65 = icmp ne i64 %r54, 0
  br i1 %br_or_merge65, label %or_merge65, label %or_rhs64
or_rhs64:
  %r55 = load i64, ptr %slot.word, align 8
  %r56.p = getelementptr inbounds [3 x i8], ptr @.str.18, i64 0, i64 0
  %r56 = ptrtoint ptr %r56.p to i64
  %r57 = call i64 @nova_rt_eq(i64 %r55, i64 %r56)
  store i64 %r57, ptr %slot.__sc_63, align 8
  br label %or_merge65
or_merge65:
  %r58 = load i64, ptr %slot.__sc_63, align 8
  store i64 %r58, ptr %slot.__sc_66, align 8
  %br_or_merge68 = icmp ne i64 %r58, 0
  br i1 %br_or_merge68, label %or_merge68, label %or_rhs67
or_rhs67:
  %r59 = load i64, ptr %slot.word, align 8
  %r60.p = getelementptr inbounds [6 x i8], ptr @.str.19, i64 0, i64 0
  %r60 = ptrtoint ptr %r60.p to i64
  %r61 = call i64 @nova_rt_eq(i64 %r59, i64 %r60)
  store i64 %r61, ptr %slot.__sc_66, align 8
  br label %or_merge68
or_merge68:
  %r62 = load i64, ptr %slot.__sc_66, align 8
  store i64 %r62, ptr %slot.__sc_69, align 8
  %br_or_merge71 = icmp ne i64 %r62, 0
  br i1 %br_or_merge71, label %or_merge71, label %or_rhs70
or_rhs70:
  %r63 = load i64, ptr %slot.word, align 8
  %r64.p = getelementptr inbounds [9 x i8], ptr @.str.20, i64 0, i64 0
  %r64 = ptrtoint ptr %r64.p to i64
  %r65 = call i64 @nova_rt_eq(i64 %r63, i64 %r64)
  store i64 %r65, ptr %slot.__sc_69, align 8
  br label %or_merge71
or_merge71:
  %r66 = load i64, ptr %slot.__sc_69, align 8
  store i64 %r66, ptr %slot.__sc_72, align 8
  %br_or_merge74 = icmp ne i64 %r66, 0
  br i1 %br_or_merge74, label %or_merge74, label %or_rhs73
or_rhs73:
  %r67 = load i64, ptr %slot.word, align 8
  %r68.p = getelementptr inbounds [7 x i8], ptr @.str.21, i64 0, i64 0
  %r68 = ptrtoint ptr %r68.p to i64
  %r69 = call i64 @nova_rt_eq(i64 %r67, i64 %r68)
  store i64 %r69, ptr %slot.__sc_72, align 8
  br label %or_merge74
or_merge74:
  %r70 = load i64, ptr %slot.__sc_72, align 8
  store i64 %r70, ptr %slot.__sc_75, align 8
  %br_or_merge77 = icmp ne i64 %r70, 0
  br i1 %br_or_merge77, label %or_merge77, label %or_rhs76
or_rhs76:
  %r71 = load i64, ptr %slot.word, align 8
  %r72.p = getelementptr inbounds [3 x i8], ptr @.str.22, i64 0, i64 0
  %r72 = ptrtoint ptr %r72.p to i64
  %r73 = call i64 @nova_rt_eq(i64 %r71, i64 %r72)
  store i64 %r73, ptr %slot.__sc_75, align 8
  br label %or_merge77
or_merge77:
  %r74 = load i64, ptr %slot.__sc_75, align 8
  store i64 %r74, ptr %slot.__sc_78, align 8
  %br_or_merge80 = icmp ne i64 %r74, 0
  br i1 %br_or_merge80, label %or_merge80, label %or_rhs79
or_rhs79:
  %r75 = load i64, ptr %slot.word, align 8
  %r76.p = getelementptr inbounds [5 x i8], ptr @.str.23, i64 0, i64 0
  %r76 = ptrtoint ptr %r76.p to i64
  %r77 = call i64 @nova_rt_eq(i64 %r75, i64 %r76)
  store i64 %r77, ptr %slot.__sc_78, align 8
  br label %or_merge80
or_merge80:
  %r78 = load i64, ptr %slot.__sc_78, align 8
  ret i64 %r78
}

define i64 @tokenize(i64 %p0) nounwind {
entry:
  %slot.source = alloca i64, align 8
  store i64 %p0, ptr %slot.source, align 8
  %slot.tokens = alloca i64, align 8
  store i64 0, ptr %slot.tokens, align 8
  %slot.pos = alloca i64, align 8
  store i64 0, ptr %slot.pos, align 8
  %slot.line = alloca i64, align 8
  store i64 0, ptr %slot.line, align 8
  %slot.col = alloca i64, align 8
  store i64 0, ptr %slot.col, align 8
  %slot.length = alloca i64, align 8
  store i64 0, ptr %slot.length, align 8
  %slot.ch = alloca i64, align 8
  store i64 0, ptr %slot.ch, align 8
  %slot.__sc_93 = alloca i64, align 8
  store i64 0, ptr %slot.__sc_93, align 8
  %slot.start_col = alloca i64, align 8
  store i64 0, ptr %slot.start_col, align 8
  %slot.word = alloca i64, align 8
  store i64 0, ptr %slot.word, align 8
  %slot.__sc_102 = alloca i64, align 8
  store i64 0, ptr %slot.__sc_102, align 8
  %slot.num = alloca i64, align 8
  store i64 0, ptr %slot.num, align 8
  %slot.__sc_114 = alloca i64, align 8
  store i64 0, ptr %slot.__sc_114, align 8
  %r0 = call i64 @nova_rt_list_create()
  store i64 %r0, ptr %slot.tokens, align 8
  %r1 = add i64 0, 0
  store i64 %r1, ptr %slot.pos, align 8
  %r2 = add i64 1, 0
  store i64 %r2, ptr %slot.line, align 8
  %r3 = add i64 1, 0
  store i64 %r3, ptr %slot.col, align 8
  %r4 = load i64, ptr %slot.source, align 8
  %r5 = call i64 @nova_rt_len_any(i64 %r4)
  store i64 %r5, ptr %slot.length, align 8
  br label %while_hdr81
while_hdr81:
  %r6 = load i64, ptr %slot.pos, align 8
  %r7 = load i64, ptr %slot.length, align 8
  %r8.cmp = icmp slt i64 %r6, %r7
  %r8 = zext i1 %r8.cmp to i64
  %br_while_body82 = icmp ne i64 %r8, 0
  br i1 %br_while_body82, label %while_body82, label %while_exit83
while_body82:
  %r9 = load i64, ptr %slot.source, align 8
  %r10 = load i64, ptr %slot.pos, align 8
  %r11 = call i64 @nova_rt_index_get(i64 %r9, i64 %r10)
  store i64 %r11, ptr %slot.ch, align 8
  %r12 = load i64, ptr %slot.ch, align 8
  %r13.p = getelementptr inbounds [2 x i8], ptr @.str.24, i64 0, i64 0
  %r13 = ptrtoint ptr %r13.p to i64
  %r14 = call i64 @nova_rt_eq(i64 %r12, i64 %r13)
  %br_then84 = icmp ne i64 %r14, 0
  br i1 %br_then84, label %then84, label %else85
then84:
  %r15 = load i64, ptr %slot.tokens, align 8
  %r16.p = getelementptr inbounds [8 x i8], ptr @.str.25, i64 0, i64 0
  %r16 = ptrtoint ptr %r16.p to i64
  %r17.p = getelementptr inbounds [3 x i8], ptr @.str.26, i64 0, i64 0
  %r17 = ptrtoint ptr %r17.p to i64
  %r18 = load i64, ptr %slot.line, align 8
  %r19 = load i64, ptr %slot.col, align 8
  %r20.ptr = call ptr @nova_rt_struct_alloc(i64 32)
  %r20.f0 = getelementptr i64, ptr %r20.ptr, i64 0
  store i64 %r16, ptr %r20.f0, align 8
  %r20.f1 = getelementptr i64, ptr %r20.ptr, i64 1
  store i64 %r17, ptr %r20.f1, align 8
  %r20.f2 = getelementptr i64, ptr %r20.ptr, i64 2
  store i64 %r18, ptr %r20.f2, align 8
  %r20.f3 = getelementptr i64, ptr %r20.ptr, i64 3
  store i64 %r19, ptr %r20.f3, align 8
  %r20 = ptrtoint ptr %r20.ptr to i64
  %r21 = call i64 @nova_rt_list_append(i64 %r15, i64 %r20)
  %r22 = load i64, ptr %slot.line, align 8
  %r23 = add i64 1, 0
  %r24 = add i64 %r22, %r23
  store i64 %r24, ptr %slot.line, align 8
  %r25 = add i64 1, 0
  store i64 %r25, ptr %slot.col, align 8
  %r26 = load i64, ptr %slot.pos, align 8
  %r27 = add i64 1, 0
  %r28 = add i64 %r26, %r27
  store i64 %r28, ptr %slot.pos, align 8
  br label %endif86
else85:
  %r29 = load i64, ptr %slot.ch, align 8
  %r30 = call i64 @is_ws(i64 %r29)
  %br_then87 = icmp ne i64 %r30, 0
  br i1 %br_then87, label %then87, label %else88
then87:
  br label %while_hdr90
while_hdr90:
  %r31 = load i64, ptr %slot.pos, align 8
  %r32 = load i64, ptr %slot.length, align 8
  %r33.cmp = icmp slt i64 %r31, %r32
  %r33 = zext i1 %r33.cmp to i64
  store i64 %r33, ptr %slot.__sc_93, align 8
  %br_and_rhs94 = icmp ne i64 %r33, 0
  br i1 %br_and_rhs94, label %and_rhs94, label %and_merge95
and_rhs94:
  %r34 = load i64, ptr %slot.source, align 8
  %r35 = load i64, ptr %slot.pos, align 8
  %r36 = call i64 @nova_rt_index_get(i64 %r34, i64 %r35)
  %r37 = call i64 @is_ws(i64 %r36)
  store i64 %r37, ptr %slot.__sc_93, align 8
  br label %and_merge95
and_merge95:
  %r38 = load i64, ptr %slot.__sc_93, align 8
  %br_while_body91 = icmp ne i64 %r38, 0
  br i1 %br_while_body91, label %while_body91, label %while_exit92
while_body91:
  %r39 = load i64, ptr %slot.pos, align 8
  %r40 = add i64 1, 0
  %r41 = add i64 %r39, %r40
  store i64 %r41, ptr %slot.pos, align 8
  %r42 = load i64, ptr %slot.col, align 8
  %r43 = add i64 1, 0
  %r44 = add i64 %r42, %r43
  store i64 %r44, ptr %slot.col, align 8
  br label %while_hdr90
while_exit92:
  br label %endif89
else88:
  %r45 = load i64, ptr %slot.ch, align 8
  %r46 = call i64 @is_alpha(i64 %r45)
  %br_then96 = icmp ne i64 %r46, 0
  br i1 %br_then96, label %then96, label %else97
then96:
  %r47 = load i64, ptr %slot.col, align 8
  store i64 %r47, ptr %slot.start_col, align 8
  %r48.p = getelementptr inbounds [1 x i8], ptr @.str.27, i64 0, i64 0
  %r48 = ptrtoint ptr %r48.p to i64
  store i64 %r48, ptr %slot.word, align 8
  br label %while_hdr99
while_hdr99:
  %r49 = load i64, ptr %slot.pos, align 8
  %r50 = load i64, ptr %slot.length, align 8
  %r51.cmp = icmp slt i64 %r49, %r50
  %r51 = zext i1 %r51.cmp to i64
  store i64 %r51, ptr %slot.__sc_102, align 8
  %br_and_rhs103 = icmp ne i64 %r51, 0
  br i1 %br_and_rhs103, label %and_rhs103, label %and_merge104
and_rhs103:
  %r52 = load i64, ptr %slot.source, align 8
  %r53 = load i64, ptr %slot.pos, align 8
  %r54 = call i64 @nova_rt_index_get(i64 %r52, i64 %r53)
  %r55 = call i64 @is_alnum(i64 %r54)
  store i64 %r55, ptr %slot.__sc_102, align 8
  br label %and_merge104
and_merge104:
  %r56 = load i64, ptr %slot.__sc_102, align 8
  %br_while_body100 = icmp ne i64 %r56, 0
  br i1 %br_while_body100, label %while_body100, label %while_exit101
while_body100:
  %r57 = load i64, ptr %slot.word, align 8
  %r58 = load i64, ptr %slot.source, align 8
  %r59 = load i64, ptr %slot.pos, align 8
  %r60 = call i64 @nova_rt_index_get(i64 %r58, i64 %r59)
  %r61 = call i64 @nova_rt_str_concat(i64 %r57, i64 %r60)
  store i64 %r61, ptr %slot.word, align 8
  %r62 = load i64, ptr %slot.pos, align 8
  %r63 = add i64 1, 0
  %r64 = add i64 %r62, %r63
  store i64 %r64, ptr %slot.pos, align 8
  %r65 = load i64, ptr %slot.col, align 8
  %r66 = add i64 1, 0
  %r67 = add i64 %r65, %r66
  store i64 %r67, ptr %slot.col, align 8
  br label %while_hdr99
while_exit101:
  %r68 = load i64, ptr %slot.word, align 8
  %r69 = call i64 @is_keyword(i64 %r68)
  %br_then105 = icmp ne i64 %r69, 0
  br i1 %br_then105, label %then105, label %else106
then105:
  %r70 = load i64, ptr %slot.tokens, align 8
  %r71.p = getelementptr inbounds [3 x i8], ptr @.str.28, i64 0, i64 0
  %r71 = ptrtoint ptr %r71.p to i64
  %r72 = load i64, ptr %slot.word, align 8
  %r73 = load i64, ptr %slot.line, align 8
  %r74 = load i64, ptr %slot.start_col, align 8
  %r75.ptr = call ptr @nova_rt_struct_alloc(i64 32)
  %r75.f0 = getelementptr i64, ptr %r75.ptr, i64 0
  store i64 %r71, ptr %r75.f0, align 8
  %r75.f1 = getelementptr i64, ptr %r75.ptr, i64 1
  store i64 %r72, ptr %r75.f1, align 8
  %r75.f2 = getelementptr i64, ptr %r75.ptr, i64 2
  store i64 %r73, ptr %r75.f2, align 8
  %r75.f3 = getelementptr i64, ptr %r75.ptr, i64 3
  store i64 %r74, ptr %r75.f3, align 8
  %r75 = ptrtoint ptr %r75.ptr to i64
  %r76 = call i64 @nova_rt_list_append(i64 %r70, i64 %r75)
  br label %endif107
else106:
  %r77 = load i64, ptr %slot.tokens, align 8
  %r78.p = getelementptr inbounds [6 x i8], ptr @.str.29, i64 0, i64 0
  %r78 = ptrtoint ptr %r78.p to i64
  %r79 = load i64, ptr %slot.word, align 8
  %r80 = load i64, ptr %slot.line, align 8
  %r81 = load i64, ptr %slot.start_col, align 8
  %r82.ptr = call ptr @nova_rt_struct_alloc(i64 32)
  %r82.f0 = getelementptr i64, ptr %r82.ptr, i64 0
  store i64 %r78, ptr %r82.f0, align 8
  %r82.f1 = getelementptr i64, ptr %r82.ptr, i64 1
  store i64 %r79, ptr %r82.f1, align 8
  %r82.f2 = getelementptr i64, ptr %r82.ptr, i64 2
  store i64 %r80, ptr %r82.f2, align 8
  %r82.f3 = getelementptr i64, ptr %r82.ptr, i64 3
  store i64 %r81, ptr %r82.f3, align 8
  %r82 = ptrtoint ptr %r82.ptr to i64
  %r83 = call i64 @nova_rt_list_append(i64 %r77, i64 %r82)
  br label %endif107
endif107:
  br label %endif98
else97:
  %r84 = load i64, ptr %slot.ch, align 8
  %r85 = call i64 @is_digit(i64 %r84)
  %br_then108 = icmp ne i64 %r85, 0
  br i1 %br_then108, label %then108, label %else109
then108:
  %r86 = load i64, ptr %slot.col, align 8
  store i64 %r86, ptr %slot.start_col, align 8
  %r87.p = getelementptr inbounds [1 x i8], ptr @.str.27, i64 0, i64 0
  %r87 = ptrtoint ptr %r87.p to i64
  store i64 %r87, ptr %slot.num, align 8
  br label %while_hdr111
while_hdr111:
  %r88 = load i64, ptr %slot.pos, align 8
  %r89 = load i64, ptr %slot.length, align 8
  %r90.cmp = icmp slt i64 %r88, %r89
  %r90 = zext i1 %r90.cmp to i64
  store i64 %r90, ptr %slot.__sc_114, align 8
  %br_and_rhs115 = icmp ne i64 %r90, 0
  br i1 %br_and_rhs115, label %and_rhs115, label %and_merge116
and_rhs115:
  %r91 = load i64, ptr %slot.source, align 8
  %r92 = load i64, ptr %slot.pos, align 8
  %r93 = call i64 @nova_rt_index_get(i64 %r91, i64 %r92)
  %r94 = call i64 @is_digit(i64 %r93)
  store i64 %r94, ptr %slot.__sc_114, align 8
  br label %and_merge116
and_merge116:
  %r95 = load i64, ptr %slot.__sc_114, align 8
  %br_while_body112 = icmp ne i64 %r95, 0
  br i1 %br_while_body112, label %while_body112, label %while_exit113
while_body112:
  %r96 = load i64, ptr %slot.num, align 8
  %r97 = load i64, ptr %slot.source, align 8
  %r98 = load i64, ptr %slot.pos, align 8
  %r99 = call i64 @nova_rt_index_get(i64 %r97, i64 %r98)
  %r100 = call i64 @nova_rt_str_concat(i64 %r96, i64 %r99)
  store i64 %r100, ptr %slot.num, align 8
  %r101 = load i64, ptr %slot.pos, align 8
  %r102 = add i64 1, 0
  %r103 = add i64 %r101, %r102
  store i64 %r103, ptr %slot.pos, align 8
  %r104 = load i64, ptr %slot.col, align 8
  %r105 = add i64 1, 0
  %r106 = add i64 %r104, %r105
  store i64 %r106, ptr %slot.col, align 8
  br label %while_hdr111
while_exit113:
  %r107 = load i64, ptr %slot.tokens, align 8
  %r108.p = getelementptr inbounds [4 x i8], ptr @.str.30, i64 0, i64 0
  %r108 = ptrtoint ptr %r108.p to i64
  %r109 = load i64, ptr %slot.num, align 8
  %r110 = load i64, ptr %slot.line, align 8
  %r111 = load i64, ptr %slot.start_col, align 8
  %r112.ptr = call ptr @nova_rt_struct_alloc(i64 32)
  %r112.f0 = getelementptr i64, ptr %r112.ptr, i64 0
  store i64 %r108, ptr %r112.f0, align 8
  %r112.f1 = getelementptr i64, ptr %r112.ptr, i64 1
  store i64 %r109, ptr %r112.f1, align 8
  %r112.f2 = getelementptr i64, ptr %r112.ptr, i64 2
  store i64 %r110, ptr %r112.f2, align 8
  %r112.f3 = getelementptr i64, ptr %r112.ptr, i64 3
  store i64 %r111, ptr %r112.f3, align 8
  %r112 = ptrtoint ptr %r112.ptr to i64
  %r113 = call i64 @nova_rt_list_append(i64 %r107, i64 %r112)
  br label %endif110
else109:
  %r114 = load i64, ptr %slot.ch, align 8
  %r115.p = getelementptr inbounds [2 x i8], ptr @.str.31, i64 0, i64 0
  %r115 = ptrtoint ptr %r115.p to i64
  %r116 = call i64 @nova_rt_eq(i64 %r114, i64 %r115)
  %br_then117 = icmp ne i64 %r116, 0
  br i1 %br_then117, label %then117, label %else118
then117:
  %r117 = load i64, ptr %slot.tokens, align 8
  %r118.p = getelementptr inbounds [7 x i8], ptr @.str.32, i64 0, i64 0
  %r118 = ptrtoint ptr %r118.p to i64
  %r119.p = getelementptr inbounds [2 x i8], ptr @.str.31, i64 0, i64 0
  %r119 = ptrtoint ptr %r119.p to i64
  %r120 = load i64, ptr %slot.line, align 8
  %r121 = load i64, ptr %slot.col, align 8
  %r122.ptr = call ptr @nova_rt_struct_alloc(i64 32)
  %r122.f0 = getelementptr i64, ptr %r122.ptr, i64 0
  store i64 %r118, ptr %r122.f0, align 8
  %r122.f1 = getelementptr i64, ptr %r122.ptr, i64 1
  store i64 %r119, ptr %r122.f1, align 8
  %r122.f2 = getelementptr i64, ptr %r122.ptr, i64 2
  store i64 %r120, ptr %r122.f2, align 8
  %r122.f3 = getelementptr i64, ptr %r122.ptr, i64 3
  store i64 %r121, ptr %r122.f3, align 8
  %r122 = ptrtoint ptr %r122.ptr to i64
  %r123 = call i64 @nova_rt_list_append(i64 %r117, i64 %r122)
  %r124 = load i64, ptr %slot.pos, align 8
  %r125 = add i64 1, 0
  %r126 = add i64 %r124, %r125
  store i64 %r126, ptr %slot.pos, align 8
  %r127 = load i64, ptr %slot.col, align 8
  %r128 = add i64 1, 0
  %r129 = add i64 %r127, %r128
  store i64 %r129, ptr %slot.col, align 8
  br label %endif119
else118:
  %r130 = load i64, ptr %slot.ch, align 8
  %r131.p = getelementptr inbounds [2 x i8], ptr @.str.33, i64 0, i64 0
  %r131 = ptrtoint ptr %r131.p to i64
  %r132 = call i64 @nova_rt_eq(i64 %r130, i64 %r131)
  %br_then120 = icmp ne i64 %r132, 0
  br i1 %br_then120, label %then120, label %else121
then120:
  %r133 = load i64, ptr %slot.tokens, align 8
  %r134.p = getelementptr inbounds [3 x i8], ptr @.str.34, i64 0, i64 0
  %r134 = ptrtoint ptr %r134.p to i64
  %r135.p = getelementptr inbounds [2 x i8], ptr @.str.33, i64 0, i64 0
  %r135 = ptrtoint ptr %r135.p to i64
  %r136 = load i64, ptr %slot.line, align 8
  %r137 = load i64, ptr %slot.col, align 8
  %r138.ptr = call ptr @nova_rt_struct_alloc(i64 32)
  %r138.f0 = getelementptr i64, ptr %r138.ptr, i64 0
  store i64 %r134, ptr %r138.f0, align 8
  %r138.f1 = getelementptr i64, ptr %r138.ptr, i64 1
  store i64 %r135, ptr %r138.f1, align 8
  %r138.f2 = getelementptr i64, ptr %r138.ptr, i64 2
  store i64 %r136, ptr %r138.f2, align 8
  %r138.f3 = getelementptr i64, ptr %r138.ptr, i64 3
  store i64 %r137, ptr %r138.f3, align 8
  %r138 = ptrtoint ptr %r138.ptr to i64
  %r139 = call i64 @nova_rt_list_append(i64 %r133, i64 %r138)
  %r140 = load i64, ptr %slot.pos, align 8
  %r141 = add i64 1, 0
  %r142 = add i64 %r140, %r141
  store i64 %r142, ptr %slot.pos, align 8
  %r143 = load i64, ptr %slot.col, align 8
  %r144 = add i64 1, 0
  %r145 = add i64 %r143, %r144
  store i64 %r145, ptr %slot.col, align 8
  br label %endif122
else121:
  %r146 = load i64, ptr %slot.pos, align 8
  %r147 = add i64 1, 0
  %r148 = add i64 %r146, %r147
  store i64 %r148, ptr %slot.pos, align 8
  %r149 = load i64, ptr %slot.col, align 8
  %r150 = add i64 1, 0
  %r151 = add i64 %r149, %r150
  store i64 %r151, ptr %slot.col, align 8
  br label %endif122
endif122:
  br label %endif119
endif119:
  br label %endif110
endif110:
  br label %endif98
endif98:
  br label %endif89
endif89:
  br label %endif86
endif86:
  br label %while_hdr81
while_exit83:
  %r152 = load i64, ptr %slot.tokens, align 8
  %r153.p = getelementptr inbounds [4 x i8], ptr @.str.35, i64 0, i64 0
  %r153 = ptrtoint ptr %r153.p to i64
  %r154.p = getelementptr inbounds [1 x i8], ptr @.str.27, i64 0, i64 0
  %r154 = ptrtoint ptr %r154.p to i64
  %r155 = load i64, ptr %slot.line, align 8
  %r156 = load i64, ptr %slot.col, align 8
  %r157.ptr = call ptr @nova_rt_struct_alloc(i64 32)
  %r157.f0 = getelementptr i64, ptr %r157.ptr, i64 0
  store i64 %r153, ptr %r157.f0, align 8
  %r157.f1 = getelementptr i64, ptr %r157.ptr, i64 1
  store i64 %r154, ptr %r157.f1, align 8
  %r157.f2 = getelementptr i64, ptr %r157.ptr, i64 2
  store i64 %r155, ptr %r157.f2, align 8
  %r157.f3 = getelementptr i64, ptr %r157.ptr, i64 3
  store i64 %r156, ptr %r157.f3, align 8
  %r157 = ptrtoint ptr %r157.ptr to i64
  %r158 = call i64 @nova_rt_list_append(i64 %r152, i64 %r157)
  %r159 = load i64, ptr %slot.tokens, align 8
  ret i64 %r159
}

define i64 @nova_main() nounwind {
entry:
  %slot.tokens = alloca i64, align 8
  store i64 0, ptr %slot.tokens, align 8
  %slot.non_nl = alloca i64, align 8
  store i64 0, ptr %slot.non_nl, align 8
  %slot.__for_idx_123 = alloca i64, align 8
  store i64 0, ptr %slot.__for_idx_123, align 8
  %slot.t = alloca i64, align 8
  store i64 0, ptr %slot.t, align 8
  %slot.kind = alloca i64, align 8
  store i64 0, ptr %slot.kind, align 8
  %slot.value = alloca i64, align 8
  store i64 0, ptr %slot.value, align 8
  %slot.line = alloca i64, align 8
  store i64 0, ptr %slot.line, align 8
  %slot.col = alloca i64, align 8
  store i64 0, ptr %slot.col, align 8
  %slot.__sc_126 = alloca i64, align 8
  store i64 0, ptr %slot.__sc_126, align 8
  %r0.p = getelementptr inbounds [23 x i8], ptr @.str.36, i64 0, i64 0
  %r0 = ptrtoint ptr %r0.p to i64
  %r1 = call i64 @nova_rt_print_any(i64 %r0)
  %r2.p = getelementptr inbounds [15 x i8], ptr @.str.37, i64 0, i64 0
  %r2 = ptrtoint ptr %r2.p to i64
  %r3 = call i64 @tokenize(i64 %r2)
  store i64 %r3, ptr %slot.tokens, align 8
  %r4.p = getelementptr inbounds [12 x i8], ptr @.str.38, i64 0, i64 0
  %r4 = ptrtoint ptr %r4.p to i64
  %r5 = load i64, ptr %slot.tokens, align 8
  %r6 = call i64 @nova_rt_len_any(i64 %r5)
  %r7 = call i64 @nova_rt_int_to_str(i64 %r6)
  %r8 = call i64 @nova_rt_str_concat(i64 %r4, i64 %r7)
  %r9.p = getelementptr inbounds [8 x i8], ptr @.str.39, i64 0, i64 0
  %r9 = ptrtoint ptr %r9.p to i64
  %r10 = call i64 @nova_rt_str_concat(i64 %r8, i64 %r9)
  %r11 = call i64 @nova_rt_print_any(i64 %r10)
  %r12 = call i64 @nova_rt_list_create()
  store i64 %r12, ptr %slot.non_nl, align 8
  %r13 = load i64, ptr %slot.tokens, align 8
  %r14 = call i64 @nova_rt_len_any(i64 %r13)
  %r15 = add i64 0, 0
  store i64 %r15, ptr %slot.__for_idx_123, align 8
  br label %for_hdr123
for_hdr123:
  %r16 = load i64, ptr %slot.__for_idx_123, align 8
  %r17.cmp = icmp slt i64 %r16, %r14
  %r17 = zext i1 %r17.cmp to i64
  %br_for_body124 = icmp ne i64 %r17, 0
  br i1 %br_for_body124, label %for_body124, label %for_exit125
for_body124:
  %r18 = call i64 @nova_rt_index_get(i64 %r13, i64 %r16)
  store i64 %r18, ptr %slot.t, align 8
  %r19 = load i64, ptr %slot.t, align 8
  %r20.ptr = inttoptr i64 %r19 to ptr
  %r20.gep = getelementptr i64, ptr %r20.ptr, i64 0
  %r20 = load i64, ptr %r20.gep, align 8
  store i64 %r20, ptr %slot.kind, align 8
  %r21.ptr = inttoptr i64 %r19 to ptr
  %r21.gep = getelementptr i64, ptr %r21.ptr, i64 1
  %r21 = load i64, ptr %r21.gep, align 8
  store i64 %r21, ptr %slot.value, align 8
  %r22.ptr = inttoptr i64 %r19 to ptr
  %r22.gep = getelementptr i64, ptr %r22.ptr, i64 2
  %r22 = load i64, ptr %r22.gep, align 8
  store i64 %r22, ptr %slot.line, align 8
  %r23.ptr = inttoptr i64 %r19 to ptr
  %r23.gep = getelementptr i64, ptr %r23.ptr, i64 3
  %r23 = load i64, ptr %r23.gep, align 8
  store i64 %r23, ptr %slot.col, align 8
  %r24 = load i64, ptr %slot.kind, align 8
  %r25.p = getelementptr inbounds [8 x i8], ptr @.str.25, i64 0, i64 0
  %r25 = ptrtoint ptr %r25.p to i64
  %r26 = call i64 @nova_rt_neq(i64 %r24, i64 %r25)
  store i64 %r26, ptr %slot.__sc_126, align 8
  %br_and_rhs127 = icmp ne i64 %r26, 0
  br i1 %br_and_rhs127, label %and_rhs127, label %and_merge128
and_rhs127:
  %r27 = load i64, ptr %slot.kind, align 8
  %r28.p = getelementptr inbounds [4 x i8], ptr @.str.35, i64 0, i64 0
  %r28 = ptrtoint ptr %r28.p to i64
  %r29 = call i64 @nova_rt_neq(i64 %r27, i64 %r28)
  store i64 %r29, ptr %slot.__sc_126, align 8
  br label %and_merge128
and_merge128:
  %r30 = load i64, ptr %slot.__sc_126, align 8
  %br_then129 = icmp ne i64 %r30, 0
  br i1 %br_then129, label %then129, label %else130
then129:
  %r31 = load i64, ptr %slot.non_nl, align 8
  %r32 = load i64, ptr %slot.t, align 8
  %r33 = call i64 @nova_rt_list_append(i64 %r31, i64 %r32)
  br label %endif131
else130:
  br label %endif131
endif131:
  %r34 = load i64, ptr %slot.kind, align 8
  %r35.p = getelementptr inbounds [2 x i8], ptr @.str.40, i64 0, i64 0
  %r35 = ptrtoint ptr %r35.p to i64
  %r36 = call i64 @nova_rt_str_concat(i64 %r34, i64 %r35)
  %r37 = load i64, ptr %slot.value, align 8
  %r38 = call i64 @nova_rt_str_concat(i64 %r36, i64 %r37)
  %r39 = call i64 @nova_rt_print_any(i64 %r38)
  %r40 = load i64, ptr %slot.__for_idx_123, align 8
  %r41 = add i64 1, 0
  %r42 = add i64 %r40, %r41
  store i64 %r42, ptr %slot.__for_idx_123, align 8
  br label %for_hdr123
for_exit125:
  %r43.p = getelementptr inbounds [15 x i8], ptr @.str.41, i64 0, i64 0
  %r43 = ptrtoint ptr %r43.p to i64
  %r44 = load i64, ptr %slot.non_nl, align 8
  %r45 = call i64 @nova_rt_len_any(i64 %r44)
  %r46 = call i64 @nova_rt_int_to_str(i64 %r45)
  %r47 = call i64 @nova_rt_str_concat(i64 %r43, i64 %r46)
  %r48 = call i64 @nova_rt_print_any(i64 %r47)
  %r49 = load i64, ptr %slot.non_nl, align 8
  %r50 = call i64 @nova_rt_len_any(i64 %r49)
  %r51 = add i64 6, 0
  %r52.cmp = icmp eq i64 %r50, %r51
  %r52 = zext i1 %r52.cmp to i64
  %br_then132 = icmp ne i64 %r52, 0
  br i1 %br_then132, label %then132, label %else133
then132:
  %r53.p = getelementptr inbounds [5 x i8], ptr @.str.42, i64 0, i64 0
  %r53 = ptrtoint ptr %r53.p to i64
  %r54 = call i64 @nova_rt_print_any(i64 %r53)
  br label %endif134
else133:
  %r55.p = getelementptr inbounds [23 x i8], ptr @.str.43, i64 0, i64 0
  %r55 = ptrtoint ptr %r55.p to i64
  %r56 = load i64, ptr %slot.non_nl, align 8
  %r57 = call i64 @nova_rt_len_any(i64 %r56)
  %r58 = call i64 @nova_rt_int_to_str(i64 %r57)
  %r59 = call i64 @nova_rt_str_concat(i64 %r55, i64 %r58)
  %r60 = call i64 @nova_rt_print_any(i64 %r59)
  br label %endif134
endif134:
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
@.str.0 = private unnamed_addr constant [2 x i8] c"_\00"
@.str.1 = private unnamed_addr constant [2 x i8] c" \00"
@.str.2 = private unnamed_addr constant [2 x i8] c"\09\00"
@.str.3 = private unnamed_addr constant [2 x i8] c"\0D\00"
@.str.4 = private unnamed_addr constant [4 x i8] c"let\00"
@.str.5 = private unnamed_addr constant [3 x i8] c"if\00"
@.str.6 = private unnamed_addr constant [5 x i8] c"else\00"
@.str.7 = private unnamed_addr constant [3 x i8] c"fn\00"
@.str.8 = private unnamed_addr constant [6 x i8] c"while\00"
@.str.9 = private unnamed_addr constant [4 x i8] c"for\00"
@.str.10 = private unnamed_addr constant [7 x i8] c"return\00"
@.str.11 = private unnamed_addr constant [6 x i8] c"match\00"
@.str.12 = private unnamed_addr constant [5 x i8] c"type\00"
@.str.13 = private unnamed_addr constant [5 x i8] c"true\00"
@.str.14 = private unnamed_addr constant [6 x i8] c"false\00"
@.str.15 = private unnamed_addr constant [4 x i8] c"and\00"
@.str.16 = private unnamed_addr constant [3 x i8] c"or\00"
@.str.17 = private unnamed_addr constant [4 x i8] c"not\00"
@.str.18 = private unnamed_addr constant [3 x i8] c"in\00"
@.str.19 = private unnamed_addr constant [6 x i8] c"break\00"
@.str.20 = private unnamed_addr constant [9 x i8] c"continue\00"
@.str.21 = private unnamed_addr constant [7 x i8] c"import\00"
@.str.22 = private unnamed_addr constant [3 x i8] c"as\00"
@.str.23 = private unnamed_addr constant [5 x i8] c"from\00"
@.str.24 = private unnamed_addr constant [2 x i8] c"\0A\00"
@.str.25 = private unnamed_addr constant [8 x i8] c"NEWLINE\00"
@.str.26 = private unnamed_addr constant [3 x i8] c"\\n\00"
@.str.27 = private unnamed_addr constant [1 x i8] c"\00"
@.str.28 = private unnamed_addr constant [3 x i8] c"KW\00"
@.str.29 = private unnamed_addr constant [6 x i8] c"IDENT\00"
@.str.30 = private unnamed_addr constant [4 x i8] c"INT\00"
@.str.31 = private unnamed_addr constant [2 x i8] c"=\00"
@.str.32 = private unnamed_addr constant [7 x i8] c"ASSIGN\00"
@.str.33 = private unnamed_addr constant [2 x i8] c"+\00"
@.str.34 = private unnamed_addr constant [3 x i8] c"OP\00"
@.str.35 = private unnamed_addr constant [4 x i8] c"EOF\00"
@.str.36 = private unnamed_addr constant [23 x i8] c"Starting diagnostic...\00"
@.str.37 = private unnamed_addr constant [15 x i8] c"let x = 42 + 3\00"
@.str.38 = private unnamed_addr constant [12 x i8] c"Tokenized: \00"
@.str.39 = private unnamed_addr constant [8 x i8] c" tokens\00"
@.str.40 = private unnamed_addr constant [2 x i8] c":\00"
@.str.41 = private unnamed_addr constant [15 x i8] c"Non-NL count: \00"
@.str.42 = private unnamed_addr constant [5 x i8] c"PASS\00"
@.str.43 = private unnamed_addr constant [23 x i8] c"FAIL: expected 6, got \00"
