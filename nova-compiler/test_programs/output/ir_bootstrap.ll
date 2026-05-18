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
  %r0 = load i64, ptr %slot.ch, align 8
  %r1 = call i64 @nova_rt_ord(i64 %r0)
  store i64 %r1, ptr %slot.c, align 8
  %r2 = load i64, ptr %slot.c, align 8
  %r3 = add i64 65, 0
  %r4.cmp = icmp sge i64 %r2, %r3
  %r4 = zext i1 %r4.cmp to i64
  %r5 = load i64, ptr %slot.c, align 8
  %r6 = add i64 90, 0
  %r7.cmp = icmp sle i64 %r5, %r6
  %r7 = zext i1 %r7.cmp to i64
  %r8.cmp = icmp ne i64 %r4, 0
  %r8.cmp2 = icmp ne i64 %r7, 0
  %r8.and = and i1 %r8.cmp, %r8.cmp2
  %r8 = zext i1 %r8.and to i64
  %r9 = load i64, ptr %slot.c, align 8
  %r10 = add i64 97, 0
  %r11.cmp = icmp sge i64 %r9, %r10
  %r11 = zext i1 %r11.cmp to i64
  %r12 = load i64, ptr %slot.c, align 8
  %r13 = add i64 122, 0
  %r14.cmp = icmp sle i64 %r12, %r13
  %r14 = zext i1 %r14.cmp to i64
  %r15.cmp = icmp ne i64 %r11, 0
  %r15.cmp2 = icmp ne i64 %r14, 0
  %r15.and = and i1 %r15.cmp, %r15.cmp2
  %r15 = zext i1 %r15.and to i64
  %r16.cmp = icmp ne i64 %r8, 0
  %r16.cmp2 = icmp ne i64 %r15, 0
  %r16.or = or i1 %r16.cmp, %r16.cmp2
  %r16 = zext i1 %r16.or to i64
  %r17 = load i64, ptr %slot.ch, align 8
  %r18.p = getelementptr inbounds [2 x i8], ptr @.str.0, i64 0, i64 0
  %r18 = ptrtoint ptr %r18.p to i64
  %r19 = call i64 @nova_rt_eq(i64 %r17, i64 %r18)
  %r20.cmp = icmp ne i64 %r16, 0
  %r20.cmp2 = icmp ne i64 %r19, 0
  %r20.or = or i1 %r20.cmp, %r20.cmp2
  %r20 = zext i1 %r20.or to i64
  ret i64 0
}

define i64 @is_digit(i64 %p0) nounwind {
entry:
  %slot.ch = alloca i64, align 8
  store i64 %p0, ptr %slot.ch, align 8
  %slot.c = alloca i64, align 8
  store i64 0, ptr %slot.c, align 8
  %r0 = load i64, ptr %slot.ch, align 8
  %r1 = call i64 @nova_rt_ord(i64 %r0)
  store i64 %r1, ptr %slot.c, align 8
  %r2 = load i64, ptr %slot.c, align 8
  %r3 = add i64 48, 0
  %r4.cmp = icmp sge i64 %r2, %r3
  %r4 = zext i1 %r4.cmp to i64
  %r5 = load i64, ptr %slot.c, align 8
  %r6 = add i64 57, 0
  %r7.cmp = icmp sle i64 %r5, %r6
  %r7 = zext i1 %r7.cmp to i64
  %r8.cmp = icmp ne i64 %r4, 0
  %r8.cmp2 = icmp ne i64 %r7, 0
  %r8.and = and i1 %r8.cmp, %r8.cmp2
  %r8 = zext i1 %r8.and to i64
  ret i64 0
}

define i64 @is_alnum(i64 %p0) nounwind {
entry:
  %slot.ch = alloca i64, align 8
  store i64 %p0, ptr %slot.ch, align 8
  %r0 = load i64, ptr %slot.ch, align 8
  %r1 = call i64 @is_alpha(i64 %r0)
  %r2 = load i64, ptr %slot.ch, align 8
  %r3 = call i64 @is_digit(i64 %r2)
  %r4.cmp = icmp ne i64 %r1, 0
  %r4.cmp2 = icmp ne i64 %r3, 0
  %r4.or = or i1 %r4.cmp, %r4.cmp2
  %r4 = zext i1 %r4.or to i64
  ret i64 0
}

define i64 @is_ws(i64 %p0) nounwind {
entry:
  %slot.ch = alloca i64, align 8
  store i64 %p0, ptr %slot.ch, align 8
  %r0 = load i64, ptr %slot.ch, align 8
  %r1.p = getelementptr inbounds [2 x i8], ptr @.str.1, i64 0, i64 0
  %r1 = ptrtoint ptr %r1.p to i64
  %r2 = call i64 @nova_rt_eq(i64 %r0, i64 %r1)
  %r3 = load i64, ptr %slot.ch, align 8
  %r4.p = getelementptr inbounds [2 x i8], ptr @.str.2, i64 0, i64 0
  %r4 = ptrtoint ptr %r4.p to i64
  %r5 = call i64 @nova_rt_eq(i64 %r3, i64 %r4)
  %r6.cmp = icmp ne i64 %r2, 0
  %r6.cmp2 = icmp ne i64 %r5, 0
  %r6.or = or i1 %r6.cmp, %r6.cmp2
  %r6 = zext i1 %r6.or to i64
  %r7 = load i64, ptr %slot.ch, align 8
  %r8.p = getelementptr inbounds [2 x i8], ptr @.str.3, i64 0, i64 0
  %r8 = ptrtoint ptr %r8.p to i64
  %r9 = call i64 @nova_rt_eq(i64 %r7, i64 %r8)
  %r10.cmp = icmp ne i64 %r6, 0
  %r10.cmp2 = icmp ne i64 %r9, 0
  %r10.or = or i1 %r10.cmp, %r10.cmp2
  %r10 = zext i1 %r10.or to i64
  ret i64 0
}

define i64 @is_keyword(i64 %p0) nounwind {
entry:
  %slot.word = alloca i64, align 8
  store i64 %p0, ptr %slot.word, align 8
  %r0 = load i64, ptr %slot.word, align 8
  %r1.p = getelementptr inbounds [3 x i8], ptr @.str.4, i64 0, i64 0
  %r1 = ptrtoint ptr %r1.p to i64
  %r2 = call i64 @nova_rt_eq(i64 %r0, i64 %r1)
  %r3 = load i64, ptr %slot.word, align 8
  %r4.p = getelementptr inbounds [7 x i8], ptr @.str.5, i64 0, i64 0
  %r4 = ptrtoint ptr %r4.p to i64
  %r5 = call i64 @nova_rt_eq(i64 %r3, i64 %r4)
  %r6.cmp = icmp ne i64 %r2, 0
  %r6.cmp2 = icmp ne i64 %r5, 0
  %r6.or = or i1 %r6.cmp, %r6.cmp2
  %r6 = zext i1 %r6.or to i64
  %r7 = load i64, ptr %slot.word, align 8
  %r8.p = getelementptr inbounds [3 x i8], ptr @.str.6, i64 0, i64 0
  %r8 = ptrtoint ptr %r8.p to i64
  %r9 = call i64 @nova_rt_eq(i64 %r7, i64 %r8)
  %r10.cmp = icmp ne i64 %r6, 0
  %r10.cmp2 = icmp ne i64 %r9, 0
  %r10.or = or i1 %r10.cmp, %r10.cmp2
  %r10 = zext i1 %r10.or to i64
  %r11 = load i64, ptr %slot.word, align 8
  %r12.p = getelementptr inbounds [5 x i8], ptr @.str.7, i64 0, i64 0
  %r12 = ptrtoint ptr %r12.p to i64
  %r13 = call i64 @nova_rt_eq(i64 %r11, i64 %r12)
  %r14.cmp = icmp ne i64 %r10, 0
  %r14.cmp2 = icmp ne i64 %r13, 0
  %r14.or = or i1 %r14.cmp, %r14.cmp2
  %r14 = zext i1 %r14.or to i64
  %r15 = load i64, ptr %slot.word, align 8
  %r16.p = getelementptr inbounds [4 x i8], ptr @.str.8, i64 0, i64 0
  %r16 = ptrtoint ptr %r16.p to i64
  %r17 = call i64 @nova_rt_eq(i64 %r15, i64 %r16)
  %r18.cmp = icmp ne i64 %r14, 0
  %r18.cmp2 = icmp ne i64 %r17, 0
  %r18.or = or i1 %r18.cmp, %r18.cmp2
  %r18 = zext i1 %r18.or to i64
  %r19 = load i64, ptr %slot.word, align 8
  %r20.p = getelementptr inbounds [6 x i8], ptr @.str.9, i64 0, i64 0
  %r20 = ptrtoint ptr %r20.p to i64
  %r21 = call i64 @nova_rt_eq(i64 %r19, i64 %r20)
  %r22.cmp = icmp ne i64 %r18, 0
  %r22.cmp2 = icmp ne i64 %r21, 0
  %r22.or = or i1 %r22.cmp, %r22.cmp2
  %r22 = zext i1 %r22.or to i64
  %r23 = load i64, ptr %slot.word, align 8
  %r24.p = getelementptr inbounds [6 x i8], ptr @.str.10, i64 0, i64 0
  %r24 = ptrtoint ptr %r24.p to i64
  %r25 = call i64 @nova_rt_eq(i64 %r23, i64 %r24)
  %r26.cmp = icmp ne i64 %r22, 0
  %r26.cmp2 = icmp ne i64 %r25, 0
  %r26.or = or i1 %r26.cmp, %r26.cmp2
  %r26 = zext i1 %r26.or to i64
  %r27 = load i64, ptr %slot.word, align 8
  %r28.p = getelementptr inbounds [6 x i8], ptr @.str.11, i64 0, i64 0
  %r28 = ptrtoint ptr %r28.p to i64
  %r29 = call i64 @nova_rt_eq(i64 %r27, i64 %r28)
  %r30.cmp = icmp ne i64 %r26, 0
  %r30.cmp2 = icmp ne i64 %r29, 0
  %r30.or = or i1 %r30.cmp, %r30.cmp2
  %r30 = zext i1 %r30.or to i64
  %r31 = load i64, ptr %slot.word, align 8
  %r32.p = getelementptr inbounds [9 x i8], ptr @.str.12, i64 0, i64 0
  %r32 = ptrtoint ptr %r32.p to i64
  %r33 = call i64 @nova_rt_eq(i64 %r31, i64 %r32)
  %r34.cmp = icmp ne i64 %r30, 0
  %r34.cmp2 = icmp ne i64 %r33, 0
  %r34.or = or i1 %r34.cmp, %r34.cmp2
  %r34 = zext i1 %r34.or to i64
  %r35 = load i64, ptr %slot.word, align 8
  %r36.p = getelementptr inbounds [5 x i8], ptr @.str.13, i64 0, i64 0
  %r36 = ptrtoint ptr %r36.p to i64
  %r37 = call i64 @nova_rt_eq(i64 %r35, i64 %r36)
  %r38.cmp = icmp ne i64 %r34, 0
  %r38.cmp2 = icmp ne i64 %r37, 0
  %r38.or = or i1 %r38.cmp, %r38.cmp2
  %r38 = zext i1 %r38.or to i64
  %r39 = load i64, ptr %slot.word, align 8
  %r40.p = getelementptr inbounds [5 x i8], ptr @.str.14, i64 0, i64 0
  %r40 = ptrtoint ptr %r40.p to i64
  %r41 = call i64 @nova_rt_eq(i64 %r39, i64 %r40)
  %r42.cmp = icmp ne i64 %r38, 0
  %r42.cmp2 = icmp ne i64 %r41, 0
  %r42.or = or i1 %r42.cmp, %r42.cmp2
  %r42 = zext i1 %r42.or to i64
  %r43 = load i64, ptr %slot.word, align 8
  %r44.p = getelementptr inbounds [6 x i8], ptr @.str.15, i64 0, i64 0
  %r44 = ptrtoint ptr %r44.p to i64
  %r45 = call i64 @nova_rt_eq(i64 %r43, i64 %r44)
  %r46.cmp = icmp ne i64 %r42, 0
  %r46.cmp2 = icmp ne i64 %r45, 0
  %r46.or = or i1 %r46.cmp, %r46.cmp2
  %r46 = zext i1 %r46.or to i64
  %r47 = load i64, ptr %slot.word, align 8
  %r48.p = getelementptr inbounds [5 x i8], ptr @.str.16, i64 0, i64 0
  %r48 = ptrtoint ptr %r48.p to i64
  %r49 = call i64 @nova_rt_eq(i64 %r47, i64 %r48)
  %r50.cmp = icmp ne i64 %r46, 0
  %r50.cmp2 = icmp ne i64 %r49, 0
  %r50.or = or i1 %r50.cmp, %r50.cmp2
  %r50 = zext i1 %r50.or to i64
  %r51 = load i64, ptr %slot.word, align 8
  %r52.p = getelementptr inbounds [8 x i8], ptr @.str.17, i64 0, i64 0
  %r52 = ptrtoint ptr %r52.p to i64
  %r53 = call i64 @nova_rt_eq(i64 %r51, i64 %r52)
  %r54.cmp = icmp ne i64 %r50, 0
  %r54.cmp2 = icmp ne i64 %r53, 0
  %r54.or = or i1 %r54.cmp, %r54.cmp2
  %r54 = zext i1 %r54.or to i64
  %r55 = load i64, ptr %slot.word, align 8
  %r56.p = getelementptr inbounds [8 x i8], ptr @.str.18, i64 0, i64 0
  %r56 = ptrtoint ptr %r56.p to i64
  %r57 = call i64 @nova_rt_eq(i64 %r55, i64 %r56)
  %r58.cmp = icmp ne i64 %r54, 0
  %r58.cmp2 = icmp ne i64 %r57, 0
  %r58.or = or i1 %r58.cmp, %r58.cmp2
  %r58 = zext i1 %r58.or to i64
  %r59 = load i64, ptr %slot.word, align 8
  %r60.p = getelementptr inbounds [3 x i8], ptr @.str.19, i64 0, i64 0
  %r60 = ptrtoint ptr %r60.p to i64
  %r61 = call i64 @nova_rt_eq(i64 %r59, i64 %r60)
  %r62.cmp = icmp ne i64 %r58, 0
  %r62.cmp2 = icmp ne i64 %r61, 0
  %r62.or = or i1 %r62.cmp, %r62.cmp2
  %r62 = zext i1 %r62.or to i64
  %r63 = load i64, ptr %slot.word, align 8
  %r64.p = getelementptr inbounds [4 x i8], ptr @.str.20, i64 0, i64 0
  %r64 = ptrtoint ptr %r64.p to i64
  %r65 = call i64 @nova_rt_eq(i64 %r63, i64 %r64)
  %r66.cmp = icmp ne i64 %r62, 0
  %r66.cmp2 = icmp ne i64 %r65, 0
  %r66.or = or i1 %r66.cmp, %r66.cmp2
  %r66 = zext i1 %r66.or to i64
  %r67 = load i64, ptr %slot.word, align 8
  %r68.p = getelementptr inbounds [4 x i8], ptr @.str.21, i64 0, i64 0
  %r68 = ptrtoint ptr %r68.p to i64
  %r69 = call i64 @nova_rt_eq(i64 %r67, i64 %r68)
  %r70.cmp = icmp ne i64 %r66, 0
  %r70.cmp2 = icmp ne i64 %r69, 0
  %r70.or = or i1 %r70.cmp, %r70.cmp2
  %r70 = zext i1 %r70.or to i64
  %r71 = load i64, ptr %slot.word, align 8
  %r72.p = getelementptr inbounds [5 x i8], ptr @.str.22, i64 0, i64 0
  %r72 = ptrtoint ptr %r72.p to i64
  %r73 = call i64 @nova_rt_eq(i64 %r71, i64 %r72)
  %r74.cmp = icmp ne i64 %r70, 0
  %r74.cmp2 = icmp ne i64 %r73, 0
  %r74.or = or i1 %r74.cmp, %r74.cmp2
  %r74 = zext i1 %r74.or to i64
  %r75 = load i64, ptr %slot.word, align 8
  %r76.p = getelementptr inbounds [7 x i8], ptr @.str.23, i64 0, i64 0
  %r76 = ptrtoint ptr %r76.p to i64
  %r77 = call i64 @nova_rt_eq(i64 %r75, i64 %r76)
  %r78.cmp = icmp ne i64 %r74, 0
  %r78.cmp2 = icmp ne i64 %r77, 0
  %r78.or = or i1 %r78.cmp, %r78.cmp2
  %r78 = zext i1 %r78.or to i64
  %r79 = load i64, ptr %slot.word, align 8
  %r80.p = getelementptr inbounds [5 x i8], ptr @.str.24, i64 0, i64 0
  %r80 = ptrtoint ptr %r80.p to i64
  %r81 = call i64 @nova_rt_eq(i64 %r79, i64 %r80)
  %r82.cmp = icmp ne i64 %r78, 0
  %r82.cmp2 = icmp ne i64 %r81, 0
  %r82.or = or i1 %r82.cmp, %r82.cmp2
  %r82 = zext i1 %r82.or to i64
  %r83 = load i64, ptr %slot.word, align 8
  %r84.p = getelementptr inbounds [6 x i8], ptr @.str.25, i64 0, i64 0
  %r84 = ptrtoint ptr %r84.p to i64
  %r85 = call i64 @nova_rt_eq(i64 %r83, i64 %r84)
  %r86.cmp = icmp ne i64 %r82, 0
  %r86.cmp2 = icmp ne i64 %r85, 0
  %r86.or = or i1 %r86.cmp, %r86.cmp2
  %r86 = zext i1 %r86.or to i64
  %r87 = load i64, ptr %slot.word, align 8
  %r88.p = getelementptr inbounds [5 x i8], ptr @.str.26, i64 0, i64 0
  %r88 = ptrtoint ptr %r88.p to i64
  %r89 = call i64 @nova_rt_eq(i64 %r87, i64 %r88)
  %r90.cmp = icmp ne i64 %r86, 0
  %r90.cmp2 = icmp ne i64 %r89, 0
  %r90.or = or i1 %r90.cmp, %r90.cmp2
  %r90 = zext i1 %r90.or to i64
  %r91 = load i64, ptr %slot.word, align 8
  %r92.p = getelementptr inbounds [3 x i8], ptr @.str.27, i64 0, i64 0
  %r92 = ptrtoint ptr %r92.p to i64
  %r93 = call i64 @nova_rt_eq(i64 %r91, i64 %r92)
  %r94.cmp = icmp ne i64 %r90, 0
  %r94.cmp2 = icmp ne i64 %r93, 0
  %r94.or = or i1 %r94.cmp, %r94.cmp2
  %r94 = zext i1 %r94.or to i64
  %r95 = load i64, ptr %slot.word, align 8
  %r96.p = getelementptr inbounds [3 x i8], ptr @.str.28, i64 0, i64 0
  %r96 = ptrtoint ptr %r96.p to i64
  %r97 = call i64 @nova_rt_eq(i64 %r95, i64 %r96)
  %r98.cmp = icmp ne i64 %r94, 0
  %r98.cmp2 = icmp ne i64 %r97, 0
  %r98.or = or i1 %r98.cmp, %r98.cmp2
  %r98 = zext i1 %r98.or to i64
  %r99 = load i64, ptr %slot.word, align 8
  %r100.p = getelementptr inbounds [7 x i8], ptr @.str.29, i64 0, i64 0
  %r100 = ptrtoint ptr %r100.p to i64
  %r101 = call i64 @nova_rt_eq(i64 %r99, i64 %r100)
  %r102.cmp = icmp ne i64 %r98, 0
  %r102.cmp2 = icmp ne i64 %r101, 0
  %r102.or = or i1 %r102.cmp, %r102.cmp2
  %r102 = zext i1 %r102.or to i64
  %r103 = load i64, ptr %slot.word, align 8
  %r104.p = getelementptr inbounds [4 x i8], ptr @.str.30, i64 0, i64 0
  %r104 = ptrtoint ptr %r104.p to i64
  %r105 = call i64 @nova_rt_eq(i64 %r103, i64 %r104)
  %r106.cmp = icmp ne i64 %r102, 0
  %r106.cmp2 = icmp ne i64 %r105, 0
  %r106.or = or i1 %r106.cmp, %r106.cmp2
  %r106 = zext i1 %r106.or to i64
  %r107 = load i64, ptr %slot.word, align 8
  %r108.p = getelementptr inbounds [6 x i8], ptr @.str.31, i64 0, i64 0
  %r108 = ptrtoint ptr %r108.p to i64
  %r109 = call i64 @nova_rt_eq(i64 %r107, i64 %r108)
  %r110.cmp = icmp ne i64 %r106, 0
  %r110.cmp2 = icmp ne i64 %r109, 0
  %r110.or = or i1 %r110.cmp, %r110.cmp2
  %r110 = zext i1 %r110.or to i64
  %r111 = load i64, ptr %slot.word, align 8
  %r112.p = getelementptr inbounds [6 x i8], ptr @.str.32, i64 0, i64 0
  %r112 = ptrtoint ptr %r112.p to i64
  %r113 = call i64 @nova_rt_eq(i64 %r111, i64 %r112)
  %r114.cmp = icmp ne i64 %r110, 0
  %r114.cmp2 = icmp ne i64 %r113, 0
  %r114.or = or i1 %r114.cmp, %r114.cmp2
  %r114 = zext i1 %r114.or to i64
  %r115 = load i64, ptr %slot.word, align 8
  %r116.p = getelementptr inbounds [8 x i8], ptr @.str.33, i64 0, i64 0
  %r116 = ptrtoint ptr %r116.p to i64
  %r117 = call i64 @nova_rt_eq(i64 %r115, i64 %r116)
  %r118.cmp = icmp ne i64 %r114, 0
  %r118.cmp2 = icmp ne i64 %r117, 0
  %r118.or = or i1 %r118.cmp, %r118.cmp2
  %r118 = zext i1 %r118.or to i64
  %r119 = load i64, ptr %slot.word, align 8
  %r120.p = getelementptr inbounds [6 x i8], ptr @.str.34, i64 0, i64 0
  %r120 = ptrtoint ptr %r120.p to i64
  %r121 = call i64 @nova_rt_eq(i64 %r119, i64 %r120)
  %r122.cmp = icmp ne i64 %r118, 0
  %r122.cmp2 = icmp ne i64 %r121, 0
  %r122.or = or i1 %r122.cmp, %r122.cmp2
  %r122 = zext i1 %r122.or to i64
  %r123 = load i64, ptr %slot.word, align 8
  %r124.p = getelementptr inbounds [4 x i8], ptr @.str.35, i64 0, i64 0
  %r124 = ptrtoint ptr %r124.p to i64
  %r125 = call i64 @nova_rt_eq(i64 %r123, i64 %r124)
  %r126.cmp = icmp ne i64 %r122, 0
  %r126.cmp2 = icmp ne i64 %r125, 0
  %r126.or = or i1 %r126.cmp, %r126.cmp2
  %r126 = zext i1 %r126.or to i64
  ret i64 0
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
  %slot.start_col = alloca i64, align 8
  store i64 0, ptr %slot.start_col, align 8
  %slot.word = alloca i64, align 8
  store i64 0, ptr %slot.word, align 8
  %slot.num = alloca i64, align 8
  store i64 0, ptr %slot.num, align 8
  %slot.is_float = alloca i64, align 8
  store i64 0, ptr %slot.is_float, align 8
  %slot.str_val = alloca i64, align 8
  store i64 0, ptr %slot.str_val, align 8
  %slot.esc = alloca i64, align 8
  store i64 0, ptr %slot.esc, align 8
  %slot.raw = alloca i64, align 8
  store i64 0, ptr %slot.raw, align 8
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
  br label %while_hdr0
while_hdr0:
  %r6 = load i64, ptr %slot.pos, align 8
  %r7 = load i64, ptr %slot.length, align 8
  %r8.cmp = icmp slt i64 %r6, %r7
  %r8 = zext i1 %r8.cmp to i64
  %br_while_body1 = icmp ne i64 %r8, 0
  br i1 %br_while_body1, label %while_body1, label %while_exit2
while_body1:
  %r9 = load i64, ptr %slot.source, align 8
  %r10 = load i64, ptr %slot.pos, align 8
  %r11 = call i64 @nova_rt_index_get(i64 %r9, i64 %r10)
  store i64 %r11, ptr %slot.ch, align 8
  %r12 = load i64, ptr %slot.ch, align 8
  %r13.p = getelementptr inbounds [2 x i8], ptr @.str.36, i64 0, i64 0
  %r13 = ptrtoint ptr %r13.p to i64
  %r14 = call i64 @nova_rt_eq(i64 %r12, i64 %r13)
  %br_then3 = icmp ne i64 %r14, 0
  br i1 %br_then3, label %then3, label %else4
then3:
  %r15 = load i64, ptr %slot.tokens, align 8
  %r16.p = getelementptr inbounds [8 x i8], ptr @.str.37, i64 0, i64 0
  %r16 = ptrtoint ptr %r16.p to i64
  %r17.p = getelementptr inbounds [3 x i8], ptr @.str.38, i64 0, i64 0
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
  br label %endif5
else4:
  %r29 = load i64, ptr %slot.ch, align 8
  %r30 = call i64 @is_ws(i64 %r29)
  %br_then6 = icmp ne i64 %r30, 0
  br i1 %br_then6, label %then6, label %else7
then6:
  br label %while_hdr9
while_hdr9:
  %r31 = load i64, ptr %slot.pos, align 8
  %r32 = load i64, ptr %slot.length, align 8
  %r33.cmp = icmp slt i64 %r31, %r32
  %r33 = zext i1 %r33.cmp to i64
  %r34 = load i64, ptr %slot.source, align 8
  %r35 = load i64, ptr %slot.pos, align 8
  %r36 = call i64 @nova_rt_index_get(i64 %r34, i64 %r35)
  %r37 = call i64 @is_ws(i64 %r36)
  %r38.cmp = icmp ne i64 %r33, 0
  %r38.cmp2 = icmp ne i64 %r37, 0
  %r38.and = and i1 %r38.cmp, %r38.cmp2
  %r38 = zext i1 %r38.and to i64
  %br_while_body10 = icmp ne i64 %r38, 0
  br i1 %br_while_body10, label %while_body10, label %while_exit11
while_body10:
  %r39 = load i64, ptr %slot.pos, align 8
  %r40 = add i64 1, 0
  %r41 = add i64 %r39, %r40
  store i64 %r41, ptr %slot.pos, align 8
  %r42 = load i64, ptr %slot.col, align 8
  %r43 = add i64 1, 0
  %r44 = add i64 %r42, %r43
  store i64 %r44, ptr %slot.col, align 8
  br label %while_hdr9
while_exit11:
  br label %endif8
else7:
  %r45 = load i64, ptr %slot.ch, align 8
  %r46.p = getelementptr inbounds [2 x i8], ptr @.str.39, i64 0, i64 0
  %r46 = ptrtoint ptr %r46.p to i64
  %r47 = call i64 @nova_rt_eq(i64 %r45, i64 %r46)
  %r48 = load i64, ptr %slot.pos, align 8
  %r49 = add i64 1, 0
  %r50 = add i64 %r48, %r49
  %r51 = load i64, ptr %slot.length, align 8
  %r52.cmp = icmp slt i64 %r50, %r51
  %r52 = zext i1 %r52.cmp to i64
  %r53.cmp = icmp ne i64 %r47, 0
  %r53.cmp2 = icmp ne i64 %r52, 0
  %r53.and = and i1 %r53.cmp, %r53.cmp2
  %r53 = zext i1 %r53.and to i64
  %r54 = load i64, ptr %slot.source, align 8
  %r55 = load i64, ptr %slot.pos, align 8
  %r56 = add i64 1, 0
  %r57 = add i64 %r55, %r56
  %r58 = call i64 @nova_rt_index_get(i64 %r54, i64 %r57)
  %r59.p = getelementptr inbounds [2 x i8], ptr @.str.39, i64 0, i64 0
  %r59 = ptrtoint ptr %r59.p to i64
  %r60 = call i64 @nova_rt_eq(i64 %r58, i64 %r59)
  %r61.cmp = icmp ne i64 %r53, 0
  %r61.cmp2 = icmp ne i64 %r60, 0
  %r61.and = and i1 %r61.cmp, %r61.cmp2
  %r61 = zext i1 %r61.and to i64
  %br_then12 = icmp ne i64 %r61, 0
  br i1 %br_then12, label %then12, label %else13
then12:
  br label %while_hdr15
while_hdr15:
  %r62 = load i64, ptr %slot.pos, align 8
  %r63 = load i64, ptr %slot.length, align 8
  %r64.cmp = icmp slt i64 %r62, %r63
  %r64 = zext i1 %r64.cmp to i64
  %r65 = load i64, ptr %slot.source, align 8
  %r66 = load i64, ptr %slot.pos, align 8
  %r67 = call i64 @nova_rt_index_get(i64 %r65, i64 %r66)
  %r68.p = getelementptr inbounds [2 x i8], ptr @.str.36, i64 0, i64 0
  %r68 = ptrtoint ptr %r68.p to i64
  %r69 = call i64 @nova_rt_neq(i64 %r67, i64 %r68)
  %r70.cmp = icmp ne i64 %r64, 0
  %r70.cmp2 = icmp ne i64 %r69, 0
  %r70.and = and i1 %r70.cmp, %r70.cmp2
  %r70 = zext i1 %r70.and to i64
  %br_while_body16 = icmp ne i64 %r70, 0
  br i1 %br_while_body16, label %while_body16, label %while_exit17
while_body16:
  %r71 = load i64, ptr %slot.pos, align 8
  %r72 = add i64 1, 0
  %r73 = add i64 %r71, %r72
  store i64 %r73, ptr %slot.pos, align 8
  %r74 = load i64, ptr %slot.col, align 8
  %r75 = add i64 1, 0
  %r76 = add i64 %r74, %r75
  store i64 %r76, ptr %slot.col, align 8
  br label %while_hdr15
while_exit17:
  br label %endif14
else13:
  %r77 = load i64, ptr %slot.ch, align 8
  %r78.p = getelementptr inbounds [2 x i8], ptr @.str.40, i64 0, i64 0
  %r78 = ptrtoint ptr %r78.p to i64
  %r79 = call i64 @nova_rt_eq(i64 %r77, i64 %r78)
  %br_then18 = icmp ne i64 %r79, 0
  br i1 %br_then18, label %then18, label %else19
then18:
  %r80 = load i64, ptr %slot.tokens, align 8
  %r81.p = getelementptr inbounds [3 x i8], ptr @.str.41, i64 0, i64 0
  %r81 = ptrtoint ptr %r81.p to i64
  %r82.p = getelementptr inbounds [2 x i8], ptr @.str.40, i64 0, i64 0
  %r82 = ptrtoint ptr %r82.p to i64
  %r83 = load i64, ptr %slot.line, align 8
  %r84 = load i64, ptr %slot.col, align 8
  %r85.ptr = call ptr @nova_rt_struct_alloc(i64 32)
  %r85.f0 = getelementptr i64, ptr %r85.ptr, i64 0
  store i64 %r81, ptr %r85.f0, align 8
  %r85.f1 = getelementptr i64, ptr %r85.ptr, i64 1
  store i64 %r82, ptr %r85.f1, align 8
  %r85.f2 = getelementptr i64, ptr %r85.ptr, i64 2
  store i64 %r83, ptr %r85.f2, align 8
  %r85.f3 = getelementptr i64, ptr %r85.ptr, i64 3
  store i64 %r84, ptr %r85.f3, align 8
  %r85 = ptrtoint ptr %r85.ptr to i64
  %r86 = call i64 @nova_rt_list_append(i64 %r80, i64 %r85)
  %r87 = load i64, ptr %slot.pos, align 8
  %r88 = add i64 1, 0
  %r89 = add i64 %r87, %r88
  store i64 %r89, ptr %slot.pos, align 8
  %r90 = load i64, ptr %slot.col, align 8
  %r91 = add i64 1, 0
  %r92 = add i64 %r90, %r91
  store i64 %r92, ptr %slot.col, align 8
  br label %endif20
else19:
  %r93 = load i64, ptr %slot.ch, align 8
  %r94 = call i64 @is_alpha(i64 %r93)
  %br_then21 = icmp ne i64 %r94, 0
  br i1 %br_then21, label %then21, label %else22
then21:
  %r95 = load i64, ptr %slot.col, align 8
  store i64 %r95, ptr %slot.start_col, align 8
  %r96.p = getelementptr inbounds [1 x i8], ptr @.str.42, i64 0, i64 0
  %r96 = ptrtoint ptr %r96.p to i64
  store i64 %r96, ptr %slot.word, align 8
  br label %while_hdr24
while_hdr24:
  %r97 = load i64, ptr %slot.pos, align 8
  %r98 = load i64, ptr %slot.length, align 8
  %r99.cmp = icmp slt i64 %r97, %r98
  %r99 = zext i1 %r99.cmp to i64
  %r100 = load i64, ptr %slot.source, align 8
  %r101 = load i64, ptr %slot.pos, align 8
  %r102 = call i64 @nova_rt_index_get(i64 %r100, i64 %r101)
  %r103 = call i64 @is_alnum(i64 %r102)
  %r104.cmp = icmp ne i64 %r99, 0
  %r104.cmp2 = icmp ne i64 %r103, 0
  %r104.and = and i1 %r104.cmp, %r104.cmp2
  %r104 = zext i1 %r104.and to i64
  %br_while_body25 = icmp ne i64 %r104, 0
  br i1 %br_while_body25, label %while_body25, label %while_exit26
while_body25:
  %r105 = load i64, ptr %slot.word, align 8
  %r106 = load i64, ptr %slot.source, align 8
  %r107 = load i64, ptr %slot.pos, align 8
  %r108 = call i64 @nova_rt_index_get(i64 %r106, i64 %r107)
  %r109 = call i64 @nova_rt_str_concat(i64 %r105, i64 %r108)
  store i64 %r109, ptr %slot.word, align 8
  %r110 = load i64, ptr %slot.pos, align 8
  %r111 = add i64 1, 0
  %r112 = add i64 %r110, %r111
  store i64 %r112, ptr %slot.pos, align 8
  %r113 = load i64, ptr %slot.col, align 8
  %r114 = add i64 1, 0
  %r115 = add i64 %r113, %r114
  store i64 %r115, ptr %slot.col, align 8
  br label %while_hdr24
while_exit26:
  %r116 = load i64, ptr %slot.word, align 8
  %r117 = call i64 @is_keyword(i64 %r116)
  %br_then27 = icmp ne i64 %r117, 0
  br i1 %br_then27, label %then27, label %else28
then27:
  %r118 = load i64, ptr %slot.tokens, align 8
  %r119.p = getelementptr inbounds [3 x i8], ptr @.str.43, i64 0, i64 0
  %r119 = ptrtoint ptr %r119.p to i64
  %r120 = load i64, ptr %slot.word, align 8
  %r121 = load i64, ptr %slot.line, align 8
  %r122 = load i64, ptr %slot.start_col, align 8
  %r123.ptr = call ptr @nova_rt_struct_alloc(i64 32)
  %r123.f0 = getelementptr i64, ptr %r123.ptr, i64 0
  store i64 %r119, ptr %r123.f0, align 8
  %r123.f1 = getelementptr i64, ptr %r123.ptr, i64 1
  store i64 %r120, ptr %r123.f1, align 8
  %r123.f2 = getelementptr i64, ptr %r123.ptr, i64 2
  store i64 %r121, ptr %r123.f2, align 8
  %r123.f3 = getelementptr i64, ptr %r123.ptr, i64 3
  store i64 %r122, ptr %r123.f3, align 8
  %r123 = ptrtoint ptr %r123.ptr to i64
  %r124 = call i64 @nova_rt_list_append(i64 %r118, i64 %r123)
  br label %endif29
else28:
  %r125 = load i64, ptr %slot.tokens, align 8
  %r126.p = getelementptr inbounds [6 x i8], ptr @.str.44, i64 0, i64 0
  %r126 = ptrtoint ptr %r126.p to i64
  %r127 = load i64, ptr %slot.word, align 8
  %r128 = load i64, ptr %slot.line, align 8
  %r129 = load i64, ptr %slot.start_col, align 8
  %r130.ptr = call ptr @nova_rt_struct_alloc(i64 32)
  %r130.f0 = getelementptr i64, ptr %r130.ptr, i64 0
  store i64 %r126, ptr %r130.f0, align 8
  %r130.f1 = getelementptr i64, ptr %r130.ptr, i64 1
  store i64 %r127, ptr %r130.f1, align 8
  %r130.f2 = getelementptr i64, ptr %r130.ptr, i64 2
  store i64 %r128, ptr %r130.f2, align 8
  %r130.f3 = getelementptr i64, ptr %r130.ptr, i64 3
  store i64 %r129, ptr %r130.f3, align 8
  %r130 = ptrtoint ptr %r130.ptr to i64
  %r131 = call i64 @nova_rt_list_append(i64 %r125, i64 %r130)
  br label %endif29
endif29:
  br label %endif23
else22:
  %r132 = load i64, ptr %slot.ch, align 8
  %r133 = call i64 @is_digit(i64 %r132)
  %br_then30 = icmp ne i64 %r133, 0
  br i1 %br_then30, label %then30, label %else31
then30:
  %r134 = load i64, ptr %slot.col, align 8
  store i64 %r134, ptr %slot.start_col, align 8
  %r135.p = getelementptr inbounds [1 x i8], ptr @.str.42, i64 0, i64 0
  %r135 = ptrtoint ptr %r135.p to i64
  store i64 %r135, ptr %slot.num, align 8
  %r136 = add i64 0, 0
  store i64 %r136, ptr %slot.is_float, align 8
  br label %while_hdr33
while_hdr33:
  %r137 = load i64, ptr %slot.pos, align 8
  %r138 = load i64, ptr %slot.length, align 8
  %r139.cmp = icmp slt i64 %r137, %r138
  %r139 = zext i1 %r139.cmp to i64
  %r140 = load i64, ptr %slot.source, align 8
  %r141 = load i64, ptr %slot.pos, align 8
  %r142 = call i64 @nova_rt_index_get(i64 %r140, i64 %r141)
  %r143 = call i64 @is_digit(i64 %r142)
  %r144 = load i64, ptr %slot.source, align 8
  %r145 = load i64, ptr %slot.pos, align 8
  %r146 = call i64 @nova_rt_index_get(i64 %r144, i64 %r145)
  %r147.p = getelementptr inbounds [2 x i8], ptr @.str.45, i64 0, i64 0
  %r147 = ptrtoint ptr %r147.p to i64
  %r148 = call i64 @nova_rt_eq(i64 %r146, i64 %r147)
  %r149.cmp = icmp ne i64 %r143, 0
  %r149.cmp2 = icmp ne i64 %r148, 0
  %r149.or = or i1 %r149.cmp, %r149.cmp2
  %r149 = zext i1 %r149.or to i64
  %r150 = load i64, ptr %slot.source, align 8
  %r151 = load i64, ptr %slot.pos, align 8
  %r152 = call i64 @nova_rt_index_get(i64 %r150, i64 %r151)
  %r153.p = getelementptr inbounds [2 x i8], ptr @.str.0, i64 0, i64 0
  %r153 = ptrtoint ptr %r153.p to i64
  %r154 = call i64 @nova_rt_eq(i64 %r152, i64 %r153)
  %r155.cmp = icmp ne i64 %r149, 0
  %r155.cmp2 = icmp ne i64 %r154, 0
  %r155.or = or i1 %r155.cmp, %r155.cmp2
  %r155 = zext i1 %r155.or to i64
  %r156 = load i64, ptr %slot.source, align 8
  %r157 = load i64, ptr %slot.pos, align 8
  %r158 = call i64 @nova_rt_index_get(i64 %r156, i64 %r157)
  %r159.p = getelementptr inbounds [2 x i8], ptr @.str.46, i64 0, i64 0
  %r159 = ptrtoint ptr %r159.p to i64
  %r160 = call i64 @nova_rt_eq(i64 %r158, i64 %r159)
  %r161.cmp = icmp ne i64 %r155, 0
  %r161.cmp2 = icmp ne i64 %r160, 0
  %r161.or = or i1 %r161.cmp, %r161.cmp2
  %r161 = zext i1 %r161.or to i64
  %r162 = load i64, ptr %slot.source, align 8
  %r163 = load i64, ptr %slot.pos, align 8
  %r164 = call i64 @nova_rt_index_get(i64 %r162, i64 %r163)
  %r165.p = getelementptr inbounds [2 x i8], ptr @.str.47, i64 0, i64 0
  %r165 = ptrtoint ptr %r165.p to i64
  %r166 = call i64 @nova_rt_eq(i64 %r164, i64 %r165)
  %r167.cmp = icmp ne i64 %r161, 0
  %r167.cmp2 = icmp ne i64 %r166, 0
  %r167.or = or i1 %r167.cmp, %r167.cmp2
  %r167 = zext i1 %r167.or to i64
  %r168.cmp = icmp ne i64 %r139, 0
  %r168.cmp2 = icmp ne i64 %r167, 0
  %r168.and = and i1 %r168.cmp, %r168.cmp2
  %r168 = zext i1 %r168.and to i64
  %br_while_body34 = icmp ne i64 %r168, 0
  br i1 %br_while_body34, label %while_body34, label %while_exit35
while_body34:
  %r169 = load i64, ptr %slot.source, align 8
  %r170 = load i64, ptr %slot.pos, align 8
  %r171 = call i64 @nova_rt_index_get(i64 %r169, i64 %r170)
  %r172.p = getelementptr inbounds [2 x i8], ptr @.str.45, i64 0, i64 0
  %r172 = ptrtoint ptr %r172.p to i64
  %r173 = call i64 @nova_rt_eq(i64 %r171, i64 %r172)
  %r174 = load i64, ptr %slot.source, align 8
  %r175 = load i64, ptr %slot.pos, align 8
  %r176 = call i64 @nova_rt_index_get(i64 %r174, i64 %r175)
  %r177.p = getelementptr inbounds [2 x i8], ptr @.str.46, i64 0, i64 0
  %r177 = ptrtoint ptr %r177.p to i64
  %r178 = call i64 @nova_rt_eq(i64 %r176, i64 %r177)
  %r179.cmp = icmp ne i64 %r173, 0
  %r179.cmp2 = icmp ne i64 %r178, 0
  %r179.or = or i1 %r179.cmp, %r179.cmp2
  %r179 = zext i1 %r179.or to i64
  %r180 = load i64, ptr %slot.source, align 8
  %r181 = load i64, ptr %slot.pos, align 8
  %r182 = call i64 @nova_rt_index_get(i64 %r180, i64 %r181)
  %r183.p = getelementptr inbounds [2 x i8], ptr @.str.47, i64 0, i64 0
  %r183 = ptrtoint ptr %r183.p to i64
  %r184 = call i64 @nova_rt_eq(i64 %r182, i64 %r183)
  %r185.cmp = icmp ne i64 %r179, 0
  %r185.cmp2 = icmp ne i64 %r184, 0
  %r185.or = or i1 %r185.cmp, %r185.cmp2
  %r185 = zext i1 %r185.or to i64
  %br_then36 = icmp ne i64 %r185, 0
  br i1 %br_then36, label %then36, label %else37
then36:
  %r186 = add i64 1, 0
  store i64 %r186, ptr %slot.is_float, align 8
  br label %endif38
else37:
  br label %endif38
endif38:
  %r187 = load i64, ptr %slot.source, align 8
  %r188 = load i64, ptr %slot.pos, align 8
  %r189 = call i64 @nova_rt_index_get(i64 %r187, i64 %r188)
  %r190.p = getelementptr inbounds [2 x i8], ptr @.str.0, i64 0, i64 0
  %r190 = ptrtoint ptr %r190.p to i64
  %r191 = call i64 @nova_rt_neq(i64 %r189, i64 %r190)
  %br_then39 = icmp ne i64 %r191, 0
  br i1 %br_then39, label %then39, label %else40
then39:
  %r192 = load i64, ptr %slot.num, align 8
  %r193 = load i64, ptr %slot.source, align 8
  %r194 = load i64, ptr %slot.pos, align 8
  %r195 = call i64 @nova_rt_index_get(i64 %r193, i64 %r194)
  %r196 = call i64 @nova_rt_str_concat(i64 %r192, i64 %r195)
  store i64 %r196, ptr %slot.num, align 8
  br label %endif41
else40:
  br label %endif41
endif41:
  %r197 = load i64, ptr %slot.pos, align 8
  %r198 = add i64 1, 0
  %r199 = add i64 %r197, %r198
  store i64 %r199, ptr %slot.pos, align 8
  %r200 = load i64, ptr %slot.col, align 8
  %r201 = add i64 1, 0
  %r202 = add i64 %r200, %r201
  store i64 %r202, ptr %slot.col, align 8
  br label %while_hdr33
while_exit35:
  %r203 = load i64, ptr %slot.is_float, align 8
  %br_then42 = icmp ne i64 %r203, 0
  br i1 %br_then42, label %then42, label %else43
then42:
  %r204 = load i64, ptr %slot.tokens, align 8
  %r205.p = getelementptr inbounds [6 x i8], ptr @.str.48, i64 0, i64 0
  %r205 = ptrtoint ptr %r205.p to i64
  %r206 = load i64, ptr %slot.num, align 8
  %r207 = load i64, ptr %slot.line, align 8
  %r208 = load i64, ptr %slot.start_col, align 8
  %r209.ptr = call ptr @nova_rt_struct_alloc(i64 32)
  %r209.f0 = getelementptr i64, ptr %r209.ptr, i64 0
  store i64 %r205, ptr %r209.f0, align 8
  %r209.f1 = getelementptr i64, ptr %r209.ptr, i64 1
  store i64 %r206, ptr %r209.f1, align 8
  %r209.f2 = getelementptr i64, ptr %r209.ptr, i64 2
  store i64 %r207, ptr %r209.f2, align 8
  %r209.f3 = getelementptr i64, ptr %r209.ptr, i64 3
  store i64 %r208, ptr %r209.f3, align 8
  %r209 = ptrtoint ptr %r209.ptr to i64
  %r210 = call i64 @nova_rt_list_append(i64 %r204, i64 %r209)
  br label %endif44
else43:
  %r211 = load i64, ptr %slot.tokens, align 8
  %r212.p = getelementptr inbounds [4 x i8], ptr @.str.49, i64 0, i64 0
  %r212 = ptrtoint ptr %r212.p to i64
  %r213 = load i64, ptr %slot.num, align 8
  %r214 = load i64, ptr %slot.line, align 8
  %r215 = load i64, ptr %slot.start_col, align 8
  %r216.ptr = call ptr @nova_rt_struct_alloc(i64 32)
  %r216.f0 = getelementptr i64, ptr %r216.ptr, i64 0
  store i64 %r212, ptr %r216.f0, align 8
  %r216.f1 = getelementptr i64, ptr %r216.ptr, i64 1
  store i64 %r213, ptr %r216.f1, align 8
  %r216.f2 = getelementptr i64, ptr %r216.ptr, i64 2
  store i64 %r214, ptr %r216.f2, align 8
  %r216.f3 = getelementptr i64, ptr %r216.ptr, i64 3
  store i64 %r215, ptr %r216.f3, align 8
  %r216 = ptrtoint ptr %r216.ptr to i64
  %r217 = call i64 @nova_rt_list_append(i64 %r211, i64 %r216)
  br label %endif44
endif44:
  br label %endif32
else31:
  %r218 = load i64, ptr %slot.ch, align 8
  %r219.p = getelementptr inbounds [2 x i8], ptr @.str.50, i64 0, i64 0
  %r219 = ptrtoint ptr %r219.p to i64
  %r220 = call i64 @nova_rt_eq(i64 %r218, i64 %r219)
  %br_then45 = icmp ne i64 %r220, 0
  br i1 %br_then45, label %then45, label %else46
then45:
  %r221 = load i64, ptr %slot.col, align 8
  store i64 %r221, ptr %slot.start_col, align 8
  %r222 = load i64, ptr %slot.pos, align 8
  %r223 = add i64 1, 0
  %r224 = add i64 %r222, %r223
  store i64 %r224, ptr %slot.pos, align 8
  %r225 = load i64, ptr %slot.col, align 8
  %r226 = add i64 1, 0
  %r227 = add i64 %r225, %r226
  store i64 %r227, ptr %slot.col, align 8
  %r228.p = getelementptr inbounds [1 x i8], ptr @.str.42, i64 0, i64 0
  %r228 = ptrtoint ptr %r228.p to i64
  store i64 %r228, ptr %slot.str_val, align 8
  br label %while_hdr48
while_hdr48:
  %r229 = load i64, ptr %slot.pos, align 8
  %r230 = load i64, ptr %slot.length, align 8
  %r231.cmp = icmp slt i64 %r229, %r230
  %r231 = zext i1 %r231.cmp to i64
  %r232 = load i64, ptr %slot.source, align 8
  %r233 = load i64, ptr %slot.pos, align 8
  %r234 = call i64 @nova_rt_index_get(i64 %r232, i64 %r233)
  %r235.p = getelementptr inbounds [2 x i8], ptr @.str.50, i64 0, i64 0
  %r235 = ptrtoint ptr %r235.p to i64
  %r236 = call i64 @nova_rt_neq(i64 %r234, i64 %r235)
  %r237.cmp = icmp ne i64 %r231, 0
  %r237.cmp2 = icmp ne i64 %r236, 0
  %r237.and = and i1 %r237.cmp, %r237.cmp2
  %r237 = zext i1 %r237.and to i64
  %br_while_body49 = icmp ne i64 %r237, 0
  br i1 %br_while_body49, label %while_body49, label %while_exit50
while_body49:
  %r238 = load i64, ptr %slot.source, align 8
  %r239 = load i64, ptr %slot.pos, align 8
  %r240 = call i64 @nova_rt_index_get(i64 %r238, i64 %r239)
  %r241.p = getelementptr inbounds [2 x i8], ptr @.str.51, i64 0, i64 0
  %r241 = ptrtoint ptr %r241.p to i64
  %r242 = call i64 @nova_rt_eq(i64 %r240, i64 %r241)
  %br_then51 = icmp ne i64 %r242, 0
  br i1 %br_then51, label %then51, label %else52
then51:
  %r243 = load i64, ptr %slot.pos, align 8
  %r244 = add i64 1, 0
  %r245 = add i64 %r243, %r244
  store i64 %r245, ptr %slot.pos, align 8
  %r246 = load i64, ptr %slot.col, align 8
  %r247 = add i64 1, 0
  %r248 = add i64 %r246, %r247
  store i64 %r248, ptr %slot.col, align 8
  %r249 = load i64, ptr %slot.pos, align 8
  %r250 = load i64, ptr %slot.length, align 8
  %r251.cmp = icmp slt i64 %r249, %r250
  %r251 = zext i1 %r251.cmp to i64
  %br_then54 = icmp ne i64 %r251, 0
  br i1 %br_then54, label %then54, label %else55
then54:
  %r252 = load i64, ptr %slot.source, align 8
  %r253 = load i64, ptr %slot.pos, align 8
  %r254 = call i64 @nova_rt_index_get(i64 %r252, i64 %r253)
  store i64 %r254, ptr %slot.esc, align 8
  %r255 = load i64, ptr %slot.esc, align 8
  %r256.p = getelementptr inbounds [2 x i8], ptr @.str.52, i64 0, i64 0
  %r256 = ptrtoint ptr %r256.p to i64
  %r257 = call i64 @nova_rt_eq(i64 %r255, i64 %r256)
  %br_then57 = icmp ne i64 %r257, 0
  br i1 %br_then57, label %then57, label %else58
then57:
  %r258 = load i64, ptr %slot.str_val, align 8
  %r259.p = getelementptr inbounds [2 x i8], ptr @.str.36, i64 0, i64 0
  %r259 = ptrtoint ptr %r259.p to i64
  %r260 = call i64 @nova_rt_str_concat(i64 %r258, i64 %r259)
  store i64 %r260, ptr %slot.str_val, align 8
  br label %endif59
else58:
  %r261 = load i64, ptr %slot.esc, align 8
  %r262.p = getelementptr inbounds [2 x i8], ptr @.str.53, i64 0, i64 0
  %r262 = ptrtoint ptr %r262.p to i64
  %r263 = call i64 @nova_rt_eq(i64 %r261, i64 %r262)
  %br_then60 = icmp ne i64 %r263, 0
  br i1 %br_then60, label %then60, label %else61
then60:
  %r264 = load i64, ptr %slot.str_val, align 8
  %r265.p = getelementptr inbounds [2 x i8], ptr @.str.2, i64 0, i64 0
  %r265 = ptrtoint ptr %r265.p to i64
  %r266 = call i64 @nova_rt_str_concat(i64 %r264, i64 %r265)
  store i64 %r266, ptr %slot.str_val, align 8
  br label %endif62
else61:
  %r267 = load i64, ptr %slot.esc, align 8
  %r268.p = getelementptr inbounds [2 x i8], ptr @.str.54, i64 0, i64 0
  %r268 = ptrtoint ptr %r268.p to i64
  %r269 = call i64 @nova_rt_eq(i64 %r267, i64 %r268)
  %br_then63 = icmp ne i64 %r269, 0
  br i1 %br_then63, label %then63, label %else64
then63:
  %r270 = load i64, ptr %slot.str_val, align 8
  %r271.p = getelementptr inbounds [2 x i8], ptr @.str.3, i64 0, i64 0
  %r271 = ptrtoint ptr %r271.p to i64
  %r272 = call i64 @nova_rt_str_concat(i64 %r270, i64 %r271)
  store i64 %r272, ptr %slot.str_val, align 8
  br label %endif65
else64:
  %r273 = load i64, ptr %slot.esc, align 8
  %r274.p = getelementptr inbounds [2 x i8], ptr @.str.51, i64 0, i64 0
  %r274 = ptrtoint ptr %r274.p to i64
  %r275 = call i64 @nova_rt_eq(i64 %r273, i64 %r274)
  %br_then66 = icmp ne i64 %r275, 0
  br i1 %br_then66, label %then66, label %else67
then66:
  %r276 = load i64, ptr %slot.str_val, align 8
  %r277.p = getelementptr inbounds [2 x i8], ptr @.str.51, i64 0, i64 0
  %r277 = ptrtoint ptr %r277.p to i64
  %r278 = call i64 @nova_rt_str_concat(i64 %r276, i64 %r277)
  store i64 %r278, ptr %slot.str_val, align 8
  br label %endif68
else67:
  %r279 = load i64, ptr %slot.esc, align 8
  %r280.p = getelementptr inbounds [2 x i8], ptr @.str.50, i64 0, i64 0
  %r280 = ptrtoint ptr %r280.p to i64
  %r281 = call i64 @nova_rt_eq(i64 %r279, i64 %r280)
  %br_then69 = icmp ne i64 %r281, 0
  br i1 %br_then69, label %then69, label %else70
then69:
  %r282 = load i64, ptr %slot.str_val, align 8
  %r283.p = getelementptr inbounds [2 x i8], ptr @.str.50, i64 0, i64 0
  %r283 = ptrtoint ptr %r283.p to i64
  %r284 = call i64 @nova_rt_str_concat(i64 %r282, i64 %r283)
  store i64 %r284, ptr %slot.str_val, align 8
  br label %endif71
else70:
  %r285 = load i64, ptr %slot.esc, align 8
  %r286.p = getelementptr inbounds [2 x i8], ptr @.str.55, i64 0, i64 0
  %r286 = ptrtoint ptr %r286.p to i64
  %r287 = call i64 @nova_rt_eq(i64 %r285, i64 %r286)
  %br_then72 = icmp ne i64 %r287, 0
  br i1 %br_then72, label %then72, label %else73
then72:
  %r288 = load i64, ptr %slot.str_val, align 8
  %r289.p = getelementptr inbounds [1 x i8], ptr @.str.42, i64 0, i64 0
  %r289 = ptrtoint ptr %r289.p to i64
  %r290 = call i64 @nova_rt_str_concat(i64 %r288, i64 %r289)
  store i64 %r290, ptr %slot.str_val, align 8
  br label %endif74
else73:
  %r291 = load i64, ptr %slot.str_val, align 8
  %r292 = load i64, ptr %slot.esc, align 8
  %r293 = call i64 @nova_rt_str_concat(i64 %r291, i64 %r292)
  store i64 %r293, ptr %slot.str_val, align 8
  br label %endif74
endif74:
  br label %endif71
endif71:
  br label %endif68
endif68:
  br label %endif65
endif65:
  br label %endif62
endif62:
  br label %endif59
endif59:
  br label %endif56
else55:
  br label %endif56
endif56:
  br label %endif53
else52:
  %r294 = load i64, ptr %slot.str_val, align 8
  %r295 = load i64, ptr %slot.source, align 8
  %r296 = load i64, ptr %slot.pos, align 8
  %r297 = call i64 @nova_rt_index_get(i64 %r295, i64 %r296)
  %r298 = call i64 @nova_rt_str_concat(i64 %r294, i64 %r297)
  store i64 %r298, ptr %slot.str_val, align 8
  br label %endif53
endif53:
  %r299 = load i64, ptr %slot.pos, align 8
  %r300 = add i64 1, 0
  %r301 = add i64 %r299, %r300
  store i64 %r301, ptr %slot.pos, align 8
  %r302 = load i64, ptr %slot.col, align 8
  %r303 = add i64 1, 0
  %r304 = add i64 %r302, %r303
  store i64 %r304, ptr %slot.col, align 8
  br label %while_hdr48
while_exit50:
  %r305 = load i64, ptr %slot.pos, align 8
  %r306 = load i64, ptr %slot.length, align 8
  %r307.cmp = icmp slt i64 %r305, %r306
  %r307 = zext i1 %r307.cmp to i64
  %br_then75 = icmp ne i64 %r307, 0
  br i1 %br_then75, label %then75, label %else76
then75:
  %r308 = load i64, ptr %slot.pos, align 8
  %r309 = add i64 1, 0
  %r310 = add i64 %r308, %r309
  store i64 %r310, ptr %slot.pos, align 8
  %r311 = load i64, ptr %slot.col, align 8
  %r312 = add i64 1, 0
  %r313 = add i64 %r311, %r312
  store i64 %r313, ptr %slot.col, align 8
  br label %endif77
else76:
  br label %endif77
endif77:
  %r314 = load i64, ptr %slot.tokens, align 8
  %r315.p = getelementptr inbounds [4 x i8], ptr @.str.56, i64 0, i64 0
  %r315 = ptrtoint ptr %r315.p to i64
  %r316 = load i64, ptr %slot.str_val, align 8
  %r317 = load i64, ptr %slot.line, align 8
  %r318 = load i64, ptr %slot.start_col, align 8
  %r319.ptr = call ptr @nova_rt_struct_alloc(i64 32)
  %r319.f0 = getelementptr i64, ptr %r319.ptr, i64 0
  store i64 %r315, ptr %r319.f0, align 8
  %r319.f1 = getelementptr i64, ptr %r319.ptr, i64 1
  store i64 %r316, ptr %r319.f1, align 8
  %r319.f2 = getelementptr i64, ptr %r319.ptr, i64 2
  store i64 %r317, ptr %r319.f2, align 8
  %r319.f3 = getelementptr i64, ptr %r319.ptr, i64 3
  store i64 %r318, ptr %r319.f3, align 8
  %r319 = ptrtoint ptr %r319.ptr to i64
  %r320 = call i64 @nova_rt_list_append(i64 %r314, i64 %r319)
  br label %endif47
else46:
  %r321 = load i64, ptr %slot.ch, align 8
  %r322.p = getelementptr inbounds [2 x i8], ptr @.str.57, i64 0, i64 0
  %r322 = ptrtoint ptr %r322.p to i64
  %r323 = call i64 @nova_rt_eq(i64 %r321, i64 %r322)
  %br_then78 = icmp ne i64 %r323, 0
  br i1 %br_then78, label %then78, label %else79
then78:
  %r324 = load i64, ptr %slot.col, align 8
  store i64 %r324, ptr %slot.start_col, align 8
  %r325 = load i64, ptr %slot.pos, align 8
  %r326 = add i64 1, 0
  %r327 = add i64 %r325, %r326
  store i64 %r327, ptr %slot.pos, align 8
  %r328 = load i64, ptr %slot.col, align 8
  %r329 = add i64 1, 0
  %r330 = add i64 %r328, %r329
  store i64 %r330, ptr %slot.col, align 8
  %r331.p = getelementptr inbounds [1 x i8], ptr @.str.42, i64 0, i64 0
  %r331 = ptrtoint ptr %r331.p to i64
  store i64 %r331, ptr %slot.raw, align 8
  br label %while_hdr81
while_hdr81:
  %r332 = load i64, ptr %slot.pos, align 8
  %r333 = load i64, ptr %slot.length, align 8
  %r334.cmp = icmp slt i64 %r332, %r333
  %r334 = zext i1 %r334.cmp to i64
  %r335 = load i64, ptr %slot.source, align 8
  %r336 = load i64, ptr %slot.pos, align 8
  %r337 = call i64 @nova_rt_index_get(i64 %r335, i64 %r336)
  %r338.p = getelementptr inbounds [2 x i8], ptr @.str.57, i64 0, i64 0
  %r338 = ptrtoint ptr %r338.p to i64
  %r339 = call i64 @nova_rt_neq(i64 %r337, i64 %r338)
  %r340.cmp = icmp ne i64 %r334, 0
  %r340.cmp2 = icmp ne i64 %r339, 0
  %r340.and = and i1 %r340.cmp, %r340.cmp2
  %r340 = zext i1 %r340.and to i64
  %br_while_body82 = icmp ne i64 %r340, 0
  br i1 %br_while_body82, label %while_body82, label %while_exit83
while_body82:
  %r341 = load i64, ptr %slot.raw, align 8
  %r342 = load i64, ptr %slot.source, align 8
  %r343 = load i64, ptr %slot.pos, align 8
  %r344 = call i64 @nova_rt_index_get(i64 %r342, i64 %r343)
  %r345 = call i64 @nova_rt_str_concat(i64 %r341, i64 %r344)
  store i64 %r345, ptr %slot.raw, align 8
  %r346 = load i64, ptr %slot.pos, align 8
  %r347 = add i64 1, 0
  %r348 = add i64 %r346, %r347
  store i64 %r348, ptr %slot.pos, align 8
  %r349 = load i64, ptr %slot.col, align 8
  %r350 = add i64 1, 0
  %r351 = add i64 %r349, %r350
  store i64 %r351, ptr %slot.col, align 8
  br label %while_hdr81
while_exit83:
  %r352 = load i64, ptr %slot.pos, align 8
  %r353 = load i64, ptr %slot.length, align 8
  %r354.cmp = icmp slt i64 %r352, %r353
  %r354 = zext i1 %r354.cmp to i64
  %br_then84 = icmp ne i64 %r354, 0
  br i1 %br_then84, label %then84, label %else85
then84:
  %r355 = load i64, ptr %slot.pos, align 8
  %r356 = add i64 1, 0
  %r357 = add i64 %r355, %r356
  store i64 %r357, ptr %slot.pos, align 8
  %r358 = load i64, ptr %slot.col, align 8
  %r359 = add i64 1, 0
  %r360 = add i64 %r358, %r359
  store i64 %r360, ptr %slot.col, align 8
  br label %endif86
else85:
  br label %endif86
endif86:
  %r361 = load i64, ptr %slot.tokens, align 8
  %r362.p = getelementptr inbounds [8 x i8], ptr @.str.58, i64 0, i64 0
  %r362 = ptrtoint ptr %r362.p to i64
  %r363 = load i64, ptr %slot.raw, align 8
  %r364 = load i64, ptr %slot.line, align 8
  %r365 = load i64, ptr %slot.start_col, align 8
  %r366.ptr = call ptr @nova_rt_struct_alloc(i64 32)
  %r366.f0 = getelementptr i64, ptr %r366.ptr, i64 0
  store i64 %r362, ptr %r366.f0, align 8
  %r366.f1 = getelementptr i64, ptr %r366.ptr, i64 1
  store i64 %r363, ptr %r366.f1, align 8
  %r366.f2 = getelementptr i64, ptr %r366.ptr, i64 2
  store i64 %r364, ptr %r366.f2, align 8
  %r366.f3 = getelementptr i64, ptr %r366.ptr, i64 3
  store i64 %r365, ptr %r366.f3, align 8
  %r366 = ptrtoint ptr %r366.ptr to i64
  %r367 = call i64 @nova_rt_list_append(i64 %r361, i64 %r366)
  br label %endif80
else79:
  %r368 = load i64, ptr %slot.ch, align 8
  %r369.p = getelementptr inbounds [2 x i8], ptr @.str.59, i64 0, i64 0
  %r369 = ptrtoint ptr %r369.p to i64
  %r370 = call i64 @nova_rt_eq(i64 %r368, i64 %r369)
  %r371 = load i64, ptr %slot.ch, align 8
  %r372.p = getelementptr inbounds [2 x i8], ptr @.str.60, i64 0, i64 0
  %r372 = ptrtoint ptr %r372.p to i64
  %r373 = call i64 @nova_rt_eq(i64 %r371, i64 %r372)
  %r374.cmp = icmp ne i64 %r370, 0
  %r374.cmp2 = icmp ne i64 %r373, 0
  %r374.or = or i1 %r374.cmp, %r374.cmp2
  %r374 = zext i1 %r374.or to i64
  %r375 = load i64, ptr %slot.ch, align 8
  %r376.p = getelementptr inbounds [2 x i8], ptr @.str.61, i64 0, i64 0
  %r376 = ptrtoint ptr %r376.p to i64
  %r377 = call i64 @nova_rt_eq(i64 %r375, i64 %r376)
  %r378.cmp = icmp ne i64 %r374, 0
  %r378.cmp2 = icmp ne i64 %r377, 0
  %r378.or = or i1 %r378.cmp, %r378.cmp2
  %r378 = zext i1 %r378.or to i64
  %r379 = load i64, ptr %slot.ch, align 8
  %r380.p = getelementptr inbounds [2 x i8], ptr @.str.62, i64 0, i64 0
  %r380 = ptrtoint ptr %r380.p to i64
  %r381 = call i64 @nova_rt_eq(i64 %r379, i64 %r380)
  %r382.cmp = icmp ne i64 %r378, 0
  %r382.cmp2 = icmp ne i64 %r381, 0
  %r382.or = or i1 %r382.cmp, %r382.cmp2
  %r382 = zext i1 %r382.or to i64
  %r383 = load i64, ptr %slot.ch, align 8
  %r384.p = getelementptr inbounds [2 x i8], ptr @.str.63, i64 0, i64 0
  %r384 = ptrtoint ptr %r384.p to i64
  %r385 = call i64 @nova_rt_eq(i64 %r383, i64 %r384)
  %r386.cmp = icmp ne i64 %r382, 0
  %r386.cmp2 = icmp ne i64 %r385, 0
  %r386.or = or i1 %r386.cmp, %r386.cmp2
  %r386 = zext i1 %r386.or to i64
  %r387 = load i64, ptr %slot.ch, align 8
  %r388.p = getelementptr inbounds [2 x i8], ptr @.str.64, i64 0, i64 0
  %r388 = ptrtoint ptr %r388.p to i64
  %r389 = call i64 @nova_rt_eq(i64 %r387, i64 %r388)
  %r390.cmp = icmp ne i64 %r386, 0
  %r390.cmp2 = icmp ne i64 %r389, 0
  %r390.or = or i1 %r390.cmp, %r390.cmp2
  %r390 = zext i1 %r390.or to i64
  %br_then87 = icmp ne i64 %r390, 0
  br i1 %br_then87, label %then87, label %else88
then87:
  %r391 = load i64, ptr %slot.tokens, align 8
  %r392.p = getelementptr inbounds [6 x i8], ptr @.str.65, i64 0, i64 0
  %r392 = ptrtoint ptr %r392.p to i64
  %r393 = load i64, ptr %slot.ch, align 8
  %r394 = load i64, ptr %slot.line, align 8
  %r395 = load i64, ptr %slot.col, align 8
  %r396.ptr = call ptr @nova_rt_struct_alloc(i64 32)
  %r396.f0 = getelementptr i64, ptr %r396.ptr, i64 0
  store i64 %r392, ptr %r396.f0, align 8
  %r396.f1 = getelementptr i64, ptr %r396.ptr, i64 1
  store i64 %r393, ptr %r396.f1, align 8
  %r396.f2 = getelementptr i64, ptr %r396.ptr, i64 2
  store i64 %r394, ptr %r396.f2, align 8
  %r396.f3 = getelementptr i64, ptr %r396.ptr, i64 3
  store i64 %r395, ptr %r396.f3, align 8
  %r396 = ptrtoint ptr %r396.ptr to i64
  %r397 = call i64 @nova_rt_list_append(i64 %r391, i64 %r396)
  %r398 = load i64, ptr %slot.pos, align 8
  %r399 = add i64 1, 0
  %r400 = add i64 %r398, %r399
  store i64 %r400, ptr %slot.pos, align 8
  %r401 = load i64, ptr %slot.col, align 8
  %r402 = add i64 1, 0
  %r403 = add i64 %r401, %r402
  store i64 %r403, ptr %slot.col, align 8
  br label %endif89
else88:
  %r404 = load i64, ptr %slot.ch, align 8
  %r405.p = getelementptr inbounds [2 x i8], ptr @.str.66, i64 0, i64 0
  %r405 = ptrtoint ptr %r405.p to i64
  %r406 = call i64 @nova_rt_eq(i64 %r404, i64 %r405)
  %br_then90 = icmp ne i64 %r406, 0
  br i1 %br_then90, label %then90, label %else91
then90:
  %r407 = load i64, ptr %slot.tokens, align 8
  %r408.p = getelementptr inbounds [6 x i8], ptr @.str.67, i64 0, i64 0
  %r408 = ptrtoint ptr %r408.p to i64
  %r409.p = getelementptr inbounds [2 x i8], ptr @.str.66, i64 0, i64 0
  %r409 = ptrtoint ptr %r409.p to i64
  %r410 = load i64, ptr %slot.line, align 8
  %r411 = load i64, ptr %slot.col, align 8
  %r412.ptr = call ptr @nova_rt_struct_alloc(i64 32)
  %r412.f0 = getelementptr i64, ptr %r412.ptr, i64 0
  store i64 %r408, ptr %r412.f0, align 8
  %r412.f1 = getelementptr i64, ptr %r412.ptr, i64 1
  store i64 %r409, ptr %r412.f1, align 8
  %r412.f2 = getelementptr i64, ptr %r412.ptr, i64 2
  store i64 %r410, ptr %r412.f2, align 8
  %r412.f3 = getelementptr i64, ptr %r412.ptr, i64 3
  store i64 %r411, ptr %r412.f3, align 8
  %r412 = ptrtoint ptr %r412.ptr to i64
  %r413 = call i64 @nova_rt_list_append(i64 %r407, i64 %r412)
  %r414 = load i64, ptr %slot.pos, align 8
  %r415 = add i64 1, 0
  %r416 = add i64 %r414, %r415
  store i64 %r416, ptr %slot.pos, align 8
  %r417 = load i64, ptr %slot.col, align 8
  %r418 = add i64 1, 0
  %r419 = add i64 %r417, %r418
  store i64 %r419, ptr %slot.col, align 8
  br label %endif92
else91:
  %r420 = load i64, ptr %slot.ch, align 8
  %r421.p = getelementptr inbounds [2 x i8], ptr @.str.68, i64 0, i64 0
  %r421 = ptrtoint ptr %r421.p to i64
  %r422 = call i64 @nova_rt_eq(i64 %r420, i64 %r421)
  %br_then93 = icmp ne i64 %r422, 0
  br i1 %br_then93, label %then93, label %else94
then93:
  %r423 = load i64, ptr %slot.tokens, align 8
  %r424.p = getelementptr inbounds [6 x i8], ptr @.str.69, i64 0, i64 0
  %r424 = ptrtoint ptr %r424.p to i64
  %r425.p = getelementptr inbounds [2 x i8], ptr @.str.68, i64 0, i64 0
  %r425 = ptrtoint ptr %r425.p to i64
  %r426 = load i64, ptr %slot.line, align 8
  %r427 = load i64, ptr %slot.col, align 8
  %r428.ptr = call ptr @nova_rt_struct_alloc(i64 32)
  %r428.f0 = getelementptr i64, ptr %r428.ptr, i64 0
  store i64 %r424, ptr %r428.f0, align 8
  %r428.f1 = getelementptr i64, ptr %r428.ptr, i64 1
  store i64 %r425, ptr %r428.f1, align 8
  %r428.f2 = getelementptr i64, ptr %r428.ptr, i64 2
  store i64 %r426, ptr %r428.f2, align 8
  %r428.f3 = getelementptr i64, ptr %r428.ptr, i64 3
  store i64 %r427, ptr %r428.f3, align 8
  %r428 = ptrtoint ptr %r428.ptr to i64
  %r429 = call i64 @nova_rt_list_append(i64 %r423, i64 %r428)
  %r430 = load i64, ptr %slot.pos, align 8
  %r431 = add i64 1, 0
  %r432 = add i64 %r430, %r431
  store i64 %r432, ptr %slot.pos, align 8
  %r433 = load i64, ptr %slot.col, align 8
  %r434 = add i64 1, 0
  %r435 = add i64 %r433, %r434
  store i64 %r435, ptr %slot.col, align 8
  br label %endif95
else94:
  %r436 = load i64, ptr %slot.ch, align 8
  %r437.p = getelementptr inbounds [2 x i8], ptr @.str.45, i64 0, i64 0
  %r437 = ptrtoint ptr %r437.p to i64
  %r438 = call i64 @nova_rt_eq(i64 %r436, i64 %r437)
  %br_then96 = icmp ne i64 %r438, 0
  br i1 %br_then96, label %then96, label %else97
then96:
  %r439 = load i64, ptr %slot.pos, align 8
  %r440 = add i64 1, 0
  %r441 = add i64 %r439, %r440
  %r442 = load i64, ptr %slot.length, align 8
  %r443.cmp = icmp slt i64 %r441, %r442
  %r443 = zext i1 %r443.cmp to i64
  %r444 = load i64, ptr %slot.source, align 8
  %r445 = load i64, ptr %slot.pos, align 8
  %r446 = add i64 1, 0
  %r447 = add i64 %r445, %r446
  %r448 = call i64 @nova_rt_index_get(i64 %r444, i64 %r447)
  %r449.p = getelementptr inbounds [2 x i8], ptr @.str.45, i64 0, i64 0
  %r449 = ptrtoint ptr %r449.p to i64
  %r450 = call i64 @nova_rt_eq(i64 %r448, i64 %r449)
  %r451.cmp = icmp ne i64 %r443, 0
  %r451.cmp2 = icmp ne i64 %r450, 0
  %r451.and = and i1 %r451.cmp, %r451.cmp2
  %r451 = zext i1 %r451.and to i64
  %br_then99 = icmp ne i64 %r451, 0
  br i1 %br_then99, label %then99, label %else100
then99:
  %r452 = load i64, ptr %slot.tokens, align 8
  %r453.p = getelementptr inbounds [7 x i8], ptr @.str.70, i64 0, i64 0
  %r453 = ptrtoint ptr %r453.p to i64
  %r454.p = getelementptr inbounds [3 x i8], ptr @.str.71, i64 0, i64 0
  %r454 = ptrtoint ptr %r454.p to i64
  %r455 = load i64, ptr %slot.line, align 8
  %r456 = load i64, ptr %slot.col, align 8
  %r457.ptr = call ptr @nova_rt_struct_alloc(i64 32)
  %r457.f0 = getelementptr i64, ptr %r457.ptr, i64 0
  store i64 %r453, ptr %r457.f0, align 8
  %r457.f1 = getelementptr i64, ptr %r457.ptr, i64 1
  store i64 %r454, ptr %r457.f1, align 8
  %r457.f2 = getelementptr i64, ptr %r457.ptr, i64 2
  store i64 %r455, ptr %r457.f2, align 8
  %r457.f3 = getelementptr i64, ptr %r457.ptr, i64 3
  store i64 %r456, ptr %r457.f3, align 8
  %r457 = ptrtoint ptr %r457.ptr to i64
  %r458 = call i64 @nova_rt_list_append(i64 %r452, i64 %r457)
  %r459 = load i64, ptr %slot.pos, align 8
  %r460 = add i64 2, 0
  %r461 = add i64 %r459, %r460
  store i64 %r461, ptr %slot.pos, align 8
  %r462 = load i64, ptr %slot.col, align 8
  %r463 = add i64 2, 0
  %r464 = add i64 %r462, %r463
  store i64 %r464, ptr %slot.col, align 8
  br label %endif101
else100:
  %r465 = load i64, ptr %slot.tokens, align 8
  %r466.p = getelementptr inbounds [4 x i8], ptr @.str.72, i64 0, i64 0
  %r466 = ptrtoint ptr %r466.p to i64
  %r467.p = getelementptr inbounds [2 x i8], ptr @.str.45, i64 0, i64 0
  %r467 = ptrtoint ptr %r467.p to i64
  %r468 = load i64, ptr %slot.line, align 8
  %r469 = load i64, ptr %slot.col, align 8
  %r470.ptr = call ptr @nova_rt_struct_alloc(i64 32)
  %r470.f0 = getelementptr i64, ptr %r470.ptr, i64 0
  store i64 %r466, ptr %r470.f0, align 8
  %r470.f1 = getelementptr i64, ptr %r470.ptr, i64 1
  store i64 %r467, ptr %r470.f1, align 8
  %r470.f2 = getelementptr i64, ptr %r470.ptr, i64 2
  store i64 %r468, ptr %r470.f2, align 8
  %r470.f3 = getelementptr i64, ptr %r470.ptr, i64 3
  store i64 %r469, ptr %r470.f3, align 8
  %r470 = ptrtoint ptr %r470.ptr to i64
  %r471 = call i64 @nova_rt_list_append(i64 %r465, i64 %r470)
  %r472 = load i64, ptr %slot.pos, align 8
  %r473 = add i64 1, 0
  %r474 = add i64 %r472, %r473
  store i64 %r474, ptr %slot.pos, align 8
  %r475 = load i64, ptr %slot.col, align 8
  %r476 = add i64 1, 0
  %r477 = add i64 %r475, %r476
  store i64 %r477, ptr %slot.col, align 8
  br label %endif101
endif101:
  br label %endif98
else97:
  %r478 = load i64, ptr %slot.ch, align 8
  %r479.p = getelementptr inbounds [2 x i8], ptr @.str.73, i64 0, i64 0
  %r479 = ptrtoint ptr %r479.p to i64
  %r480 = call i64 @nova_rt_eq(i64 %r478, i64 %r479)
  %br_then102 = icmp ne i64 %r480, 0
  br i1 %br_then102, label %then102, label %else103
then102:
  %r481 = load i64, ptr %slot.pos, align 8
  %r482 = add i64 1, 0
  %r483 = add i64 %r481, %r482
  %r484 = load i64, ptr %slot.length, align 8
  %r485.cmp = icmp slt i64 %r483, %r484
  %r485 = zext i1 %r485.cmp to i64
  %r486 = load i64, ptr %slot.source, align 8
  %r487 = load i64, ptr %slot.pos, align 8
  %r488 = add i64 1, 0
  %r489 = add i64 %r487, %r488
  %r490 = call i64 @nova_rt_index_get(i64 %r486, i64 %r489)
  %r491.p = getelementptr inbounds [2 x i8], ptr @.str.74, i64 0, i64 0
  %r491 = ptrtoint ptr %r491.p to i64
  %r492 = call i64 @nova_rt_eq(i64 %r490, i64 %r491)
  %r493.cmp = icmp ne i64 %r485, 0
  %r493.cmp2 = icmp ne i64 %r492, 0
  %r493.and = and i1 %r493.cmp, %r493.cmp2
  %r493 = zext i1 %r493.and to i64
  %br_then105 = icmp ne i64 %r493, 0
  br i1 %br_then105, label %then105, label %else106
then105:
  %r494 = load i64, ptr %slot.tokens, align 8
  %r495.p = getelementptr inbounds [3 x i8], ptr @.str.75, i64 0, i64 0
  %r495 = ptrtoint ptr %r495.p to i64
  %r496.p = getelementptr inbounds [3 x i8], ptr @.str.76, i64 0, i64 0
  %r496 = ptrtoint ptr %r496.p to i64
  %r497 = load i64, ptr %slot.line, align 8
  %r498 = load i64, ptr %slot.col, align 8
  %r499.ptr = call ptr @nova_rt_struct_alloc(i64 32)
  %r499.f0 = getelementptr i64, ptr %r499.ptr, i64 0
  store i64 %r495, ptr %r499.f0, align 8
  %r499.f1 = getelementptr i64, ptr %r499.ptr, i64 1
  store i64 %r496, ptr %r499.f1, align 8
  %r499.f2 = getelementptr i64, ptr %r499.ptr, i64 2
  store i64 %r497, ptr %r499.f2, align 8
  %r499.f3 = getelementptr i64, ptr %r499.ptr, i64 3
  store i64 %r498, ptr %r499.f3, align 8
  %r499 = ptrtoint ptr %r499.ptr to i64
  %r500 = call i64 @nova_rt_list_append(i64 %r494, i64 %r499)
  %r501 = load i64, ptr %slot.pos, align 8
  %r502 = add i64 2, 0
  %r503 = add i64 %r501, %r502
  store i64 %r503, ptr %slot.pos, align 8
  %r504 = load i64, ptr %slot.col, align 8
  %r505 = add i64 2, 0
  %r506 = add i64 %r504, %r505
  store i64 %r506, ptr %slot.col, align 8
  br label %endif107
else106:
  %r507 = load i64, ptr %slot.tokens, align 8
  %r508.p = getelementptr inbounds [3 x i8], ptr @.str.75, i64 0, i64 0
  %r508 = ptrtoint ptr %r508.p to i64
  %r509.p = getelementptr inbounds [2 x i8], ptr @.str.73, i64 0, i64 0
  %r509 = ptrtoint ptr %r509.p to i64
  %r510 = load i64, ptr %slot.line, align 8
  %r511 = load i64, ptr %slot.col, align 8
  %r512.ptr = call ptr @nova_rt_struct_alloc(i64 32)
  %r512.f0 = getelementptr i64, ptr %r512.ptr, i64 0
  store i64 %r508, ptr %r512.f0, align 8
  %r512.f1 = getelementptr i64, ptr %r512.ptr, i64 1
  store i64 %r509, ptr %r512.f1, align 8
  %r512.f2 = getelementptr i64, ptr %r512.ptr, i64 2
  store i64 %r510, ptr %r512.f2, align 8
  %r512.f3 = getelementptr i64, ptr %r512.ptr, i64 3
  store i64 %r511, ptr %r512.f3, align 8
  %r512 = ptrtoint ptr %r512.ptr to i64
  %r513 = call i64 @nova_rt_list_append(i64 %r507, i64 %r512)
  %r514 = load i64, ptr %slot.pos, align 8
  %r515 = add i64 1, 0
  %r516 = add i64 %r514, %r515
  store i64 %r516, ptr %slot.pos, align 8
  %r517 = load i64, ptr %slot.col, align 8
  %r518 = add i64 1, 0
  %r519 = add i64 %r517, %r518
  store i64 %r519, ptr %slot.col, align 8
  br label %endif107
endif107:
  br label %endif104
else103:
  %r520 = load i64, ptr %slot.ch, align 8
  %r521.p = getelementptr inbounds [2 x i8], ptr @.str.77, i64 0, i64 0
  %r521 = ptrtoint ptr %r521.p to i64
  %r522 = call i64 @nova_rt_eq(i64 %r520, i64 %r521)
  %br_then108 = icmp ne i64 %r522, 0
  br i1 %br_then108, label %then108, label %else109
then108:
  %r523 = load i64, ptr %slot.pos, align 8
  %r524 = add i64 1, 0
  %r525 = add i64 %r523, %r524
  %r526 = load i64, ptr %slot.length, align 8
  %r527.cmp = icmp slt i64 %r525, %r526
  %r527 = zext i1 %r527.cmp to i64
  %r528 = load i64, ptr %slot.source, align 8
  %r529 = load i64, ptr %slot.pos, align 8
  %r530 = add i64 1, 0
  %r531 = add i64 %r529, %r530
  %r532 = call i64 @nova_rt_index_get(i64 %r528, i64 %r531)
  %r533.p = getelementptr inbounds [2 x i8], ptr @.str.78, i64 0, i64 0
  %r533 = ptrtoint ptr %r533.p to i64
  %r534 = call i64 @nova_rt_eq(i64 %r532, i64 %r533)
  %r535.cmp = icmp ne i64 %r527, 0
  %r535.cmp2 = icmp ne i64 %r534, 0
  %r535.and = and i1 %r535.cmp, %r535.cmp2
  %r535 = zext i1 %r535.and to i64
  %br_then111 = icmp ne i64 %r535, 0
  br i1 %br_then111, label %then111, label %else112
then111:
  %r536 = load i64, ptr %slot.tokens, align 8
  %r537.p = getelementptr inbounds [6 x i8], ptr @.str.79, i64 0, i64 0
  %r537 = ptrtoint ptr %r537.p to i64
  %r538.p = getelementptr inbounds [3 x i8], ptr @.str.80, i64 0, i64 0
  %r538 = ptrtoint ptr %r538.p to i64
  %r539 = load i64, ptr %slot.line, align 8
  %r540 = load i64, ptr %slot.col, align 8
  %r541.ptr = call ptr @nova_rt_struct_alloc(i64 32)
  %r541.f0 = getelementptr i64, ptr %r541.ptr, i64 0
  store i64 %r537, ptr %r541.f0, align 8
  %r541.f1 = getelementptr i64, ptr %r541.ptr, i64 1
  store i64 %r538, ptr %r541.f1, align 8
  %r541.f2 = getelementptr i64, ptr %r541.ptr, i64 2
  store i64 %r539, ptr %r541.f2, align 8
  %r541.f3 = getelementptr i64, ptr %r541.ptr, i64 3
  store i64 %r540, ptr %r541.f3, align 8
  %r541 = ptrtoint ptr %r541.ptr to i64
  %r542 = call i64 @nova_rt_list_append(i64 %r536, i64 %r541)
  %r543 = load i64, ptr %slot.pos, align 8
  %r544 = add i64 2, 0
  %r545 = add i64 %r543, %r544
  store i64 %r545, ptr %slot.pos, align 8
  %r546 = load i64, ptr %slot.col, align 8
  %r547 = add i64 2, 0
  %r548 = add i64 %r546, %r547
  store i64 %r548, ptr %slot.col, align 8
  br label %endif113
else112:
  %r549 = load i64, ptr %slot.pos, align 8
  %r550 = add i64 1, 0
  %r551 = add i64 %r549, %r550
  %r552 = load i64, ptr %slot.length, align 8
  %r553.cmp = icmp slt i64 %r551, %r552
  %r553 = zext i1 %r553.cmp to i64
  %r554 = load i64, ptr %slot.source, align 8
  %r555 = load i64, ptr %slot.pos, align 8
  %r556 = add i64 1, 0
  %r557 = add i64 %r555, %r556
  %r558 = call i64 @nova_rt_index_get(i64 %r554, i64 %r557)
  %r559.p = getelementptr inbounds [2 x i8], ptr @.str.74, i64 0, i64 0
  %r559 = ptrtoint ptr %r559.p to i64
  %r560 = call i64 @nova_rt_eq(i64 %r558, i64 %r559)
  %r561.cmp = icmp ne i64 %r553, 0
  %r561.cmp2 = icmp ne i64 %r560, 0
  %r561.and = and i1 %r561.cmp, %r561.cmp2
  %r561 = zext i1 %r561.and to i64
  %br_then114 = icmp ne i64 %r561, 0
  br i1 %br_then114, label %then114, label %else115
then114:
  %r562 = load i64, ptr %slot.tokens, align 8
  %r563.p = getelementptr inbounds [3 x i8], ptr @.str.75, i64 0, i64 0
  %r563 = ptrtoint ptr %r563.p to i64
  %r564.p = getelementptr inbounds [3 x i8], ptr @.str.81, i64 0, i64 0
  %r564 = ptrtoint ptr %r564.p to i64
  %r565 = load i64, ptr %slot.line, align 8
  %r566 = load i64, ptr %slot.col, align 8
  %r567.ptr = call ptr @nova_rt_struct_alloc(i64 32)
  %r567.f0 = getelementptr i64, ptr %r567.ptr, i64 0
  store i64 %r563, ptr %r567.f0, align 8
  %r567.f1 = getelementptr i64, ptr %r567.ptr, i64 1
  store i64 %r564, ptr %r567.f1, align 8
  %r567.f2 = getelementptr i64, ptr %r567.ptr, i64 2
  store i64 %r565, ptr %r567.f2, align 8
  %r567.f3 = getelementptr i64, ptr %r567.ptr, i64 3
  store i64 %r566, ptr %r567.f3, align 8
  %r567 = ptrtoint ptr %r567.ptr to i64
  %r568 = call i64 @nova_rt_list_append(i64 %r562, i64 %r567)
  %r569 = load i64, ptr %slot.pos, align 8
  %r570 = add i64 2, 0
  %r571 = add i64 %r569, %r570
  store i64 %r571, ptr %slot.pos, align 8
  %r572 = load i64, ptr %slot.col, align 8
  %r573 = add i64 2, 0
  %r574 = add i64 %r572, %r573
  store i64 %r574, ptr %slot.col, align 8
  br label %endif116
else115:
  %r575 = load i64, ptr %slot.tokens, align 8
  %r576.p = getelementptr inbounds [3 x i8], ptr @.str.75, i64 0, i64 0
  %r576 = ptrtoint ptr %r576.p to i64
  %r577.p = getelementptr inbounds [2 x i8], ptr @.str.77, i64 0, i64 0
  %r577 = ptrtoint ptr %r577.p to i64
  %r578 = load i64, ptr %slot.line, align 8
  %r579 = load i64, ptr %slot.col, align 8
  %r580.ptr = call ptr @nova_rt_struct_alloc(i64 32)
  %r580.f0 = getelementptr i64, ptr %r580.ptr, i64 0
  store i64 %r576, ptr %r580.f0, align 8
  %r580.f1 = getelementptr i64, ptr %r580.ptr, i64 1
  store i64 %r577, ptr %r580.f1, align 8
  %r580.f2 = getelementptr i64, ptr %r580.ptr, i64 2
  store i64 %r578, ptr %r580.f2, align 8
  %r580.f3 = getelementptr i64, ptr %r580.ptr, i64 3
  store i64 %r579, ptr %r580.f3, align 8
  %r580 = ptrtoint ptr %r580.ptr to i64
  %r581 = call i64 @nova_rt_list_append(i64 %r575, i64 %r580)
  %r582 = load i64, ptr %slot.pos, align 8
  %r583 = add i64 1, 0
  %r584 = add i64 %r582, %r583
  store i64 %r584, ptr %slot.pos, align 8
  %r585 = load i64, ptr %slot.col, align 8
  %r586 = add i64 1, 0
  %r587 = add i64 %r585, %r586
  store i64 %r587, ptr %slot.col, align 8
  br label %endif116
endif116:
  br label %endif113
endif113:
  br label %endif110
else109:
  %r588 = load i64, ptr %slot.ch, align 8
  %r589.p = getelementptr inbounds [2 x i8], ptr @.str.82, i64 0, i64 0
  %r589 = ptrtoint ptr %r589.p to i64
  %r590 = call i64 @nova_rt_eq(i64 %r588, i64 %r589)
  %br_then117 = icmp ne i64 %r590, 0
  br i1 %br_then117, label %then117, label %else118
then117:
  %r591 = load i64, ptr %slot.pos, align 8
  %r592 = add i64 1, 0
  %r593 = add i64 %r591, %r592
  %r594 = load i64, ptr %slot.length, align 8
  %r595.cmp = icmp slt i64 %r593, %r594
  %r595 = zext i1 %r595.cmp to i64
  %r596 = load i64, ptr %slot.source, align 8
  %r597 = load i64, ptr %slot.pos, align 8
  %r598 = add i64 1, 0
  %r599 = add i64 %r597, %r598
  %r600 = call i64 @nova_rt_index_get(i64 %r596, i64 %r599)
  %r601.p = getelementptr inbounds [2 x i8], ptr @.str.82, i64 0, i64 0
  %r601 = ptrtoint ptr %r601.p to i64
  %r602 = call i64 @nova_rt_eq(i64 %r600, i64 %r601)
  %r603.cmp = icmp ne i64 %r595, 0
  %r603.cmp2 = icmp ne i64 %r602, 0
  %r603.and = and i1 %r603.cmp, %r603.cmp2
  %r603 = zext i1 %r603.and to i64
  %br_then120 = icmp ne i64 %r603, 0
  br i1 %br_then120, label %then120, label %else121
then120:
  %r604 = load i64, ptr %slot.tokens, align 8
  %r605.p = getelementptr inbounds [3 x i8], ptr @.str.75, i64 0, i64 0
  %r605 = ptrtoint ptr %r605.p to i64
  %r606.p = getelementptr inbounds [3 x i8], ptr @.str.83, i64 0, i64 0
  %r606 = ptrtoint ptr %r606.p to i64
  %r607 = load i64, ptr %slot.line, align 8
  %r608 = load i64, ptr %slot.col, align 8
  %r609.ptr = call ptr @nova_rt_struct_alloc(i64 32)
  %r609.f0 = getelementptr i64, ptr %r609.ptr, i64 0
  store i64 %r605, ptr %r609.f0, align 8
  %r609.f1 = getelementptr i64, ptr %r609.ptr, i64 1
  store i64 %r606, ptr %r609.f1, align 8
  %r609.f2 = getelementptr i64, ptr %r609.ptr, i64 2
  store i64 %r607, ptr %r609.f2, align 8
  %r609.f3 = getelementptr i64, ptr %r609.ptr, i64 3
  store i64 %r608, ptr %r609.f3, align 8
  %r609 = ptrtoint ptr %r609.ptr to i64
  %r610 = call i64 @nova_rt_list_append(i64 %r604, i64 %r609)
  %r611 = load i64, ptr %slot.pos, align 8
  %r612 = add i64 2, 0
  %r613 = add i64 %r611, %r612
  store i64 %r613, ptr %slot.pos, align 8
  %r614 = load i64, ptr %slot.col, align 8
  %r615 = add i64 2, 0
  %r616 = add i64 %r614, %r615
  store i64 %r616, ptr %slot.col, align 8
  br label %endif122
else121:
  %r617 = load i64, ptr %slot.pos, align 8
  %r618 = add i64 1, 0
  %r619 = add i64 %r617, %r618
  %r620 = load i64, ptr %slot.length, align 8
  %r621.cmp = icmp slt i64 %r619, %r620
  %r621 = zext i1 %r621.cmp to i64
  %r622 = load i64, ptr %slot.source, align 8
  %r623 = load i64, ptr %slot.pos, align 8
  %r624 = add i64 1, 0
  %r625 = add i64 %r623, %r624
  %r626 = call i64 @nova_rt_index_get(i64 %r622, i64 %r625)
  %r627.p = getelementptr inbounds [2 x i8], ptr @.str.74, i64 0, i64 0
  %r627 = ptrtoint ptr %r627.p to i64
  %r628 = call i64 @nova_rt_eq(i64 %r626, i64 %r627)
  %r629.cmp = icmp ne i64 %r621, 0
  %r629.cmp2 = icmp ne i64 %r628, 0
  %r629.and = and i1 %r629.cmp, %r629.cmp2
  %r629 = zext i1 %r629.and to i64
  %br_then123 = icmp ne i64 %r629, 0
  br i1 %br_then123, label %then123, label %else124
then123:
  %r630 = load i64, ptr %slot.tokens, align 8
  %r631.p = getelementptr inbounds [3 x i8], ptr @.str.75, i64 0, i64 0
  %r631 = ptrtoint ptr %r631.p to i64
  %r632.p = getelementptr inbounds [3 x i8], ptr @.str.84, i64 0, i64 0
  %r632 = ptrtoint ptr %r632.p to i64
  %r633 = load i64, ptr %slot.line, align 8
  %r634 = load i64, ptr %slot.col, align 8
  %r635.ptr = call ptr @nova_rt_struct_alloc(i64 32)
  %r635.f0 = getelementptr i64, ptr %r635.ptr, i64 0
  store i64 %r631, ptr %r635.f0, align 8
  %r635.f1 = getelementptr i64, ptr %r635.ptr, i64 1
  store i64 %r632, ptr %r635.f1, align 8
  %r635.f2 = getelementptr i64, ptr %r635.ptr, i64 2
  store i64 %r633, ptr %r635.f2, align 8
  %r635.f3 = getelementptr i64, ptr %r635.ptr, i64 3
  store i64 %r634, ptr %r635.f3, align 8
  %r635 = ptrtoint ptr %r635.ptr to i64
  %r636 = call i64 @nova_rt_list_append(i64 %r630, i64 %r635)
  %r637 = load i64, ptr %slot.pos, align 8
  %r638 = add i64 2, 0
  %r639 = add i64 %r637, %r638
  store i64 %r639, ptr %slot.pos, align 8
  %r640 = load i64, ptr %slot.col, align 8
  %r641 = add i64 2, 0
  %r642 = add i64 %r640, %r641
  store i64 %r642, ptr %slot.col, align 8
  br label %endif125
else124:
  %r643 = load i64, ptr %slot.tokens, align 8
  %r644.p = getelementptr inbounds [3 x i8], ptr @.str.75, i64 0, i64 0
  %r644 = ptrtoint ptr %r644.p to i64
  %r645.p = getelementptr inbounds [2 x i8], ptr @.str.82, i64 0, i64 0
  %r645 = ptrtoint ptr %r645.p to i64
  %r646 = load i64, ptr %slot.line, align 8
  %r647 = load i64, ptr %slot.col, align 8
  %r648.ptr = call ptr @nova_rt_struct_alloc(i64 32)
  %r648.f0 = getelementptr i64, ptr %r648.ptr, i64 0
  store i64 %r644, ptr %r648.f0, align 8
  %r648.f1 = getelementptr i64, ptr %r648.ptr, i64 1
  store i64 %r645, ptr %r648.f1, align 8
  %r648.f2 = getelementptr i64, ptr %r648.ptr, i64 2
  store i64 %r646, ptr %r648.f2, align 8
  %r648.f3 = getelementptr i64, ptr %r648.ptr, i64 3
  store i64 %r647, ptr %r648.f3, align 8
  %r648 = ptrtoint ptr %r648.ptr to i64
  %r649 = call i64 @nova_rt_list_append(i64 %r643, i64 %r648)
  %r650 = load i64, ptr %slot.pos, align 8
  %r651 = add i64 1, 0
  %r652 = add i64 %r650, %r651
  store i64 %r652, ptr %slot.pos, align 8
  %r653 = load i64, ptr %slot.col, align 8
  %r654 = add i64 1, 0
  %r655 = add i64 %r653, %r654
  store i64 %r655, ptr %slot.col, align 8
  br label %endif125
endif125:
  br label %endif122
endif122:
  br label %endif119
else118:
  %r656 = load i64, ptr %slot.ch, align 8
  %r657.p = getelementptr inbounds [2 x i8], ptr @.str.39, i64 0, i64 0
  %r657 = ptrtoint ptr %r657.p to i64
  %r658 = call i64 @nova_rt_eq(i64 %r656, i64 %r657)
  %br_then126 = icmp ne i64 %r658, 0
  br i1 %br_then126, label %then126, label %else127
then126:
  %r659 = load i64, ptr %slot.pos, align 8
  %r660 = add i64 1, 0
  %r661 = add i64 %r659, %r660
  %r662 = load i64, ptr %slot.length, align 8
  %r663.cmp = icmp slt i64 %r661, %r662
  %r663 = zext i1 %r663.cmp to i64
  %r664 = load i64, ptr %slot.source, align 8
  %r665 = load i64, ptr %slot.pos, align 8
  %r666 = add i64 1, 0
  %r667 = add i64 %r665, %r666
  %r668 = call i64 @nova_rt_index_get(i64 %r664, i64 %r667)
  %r669.p = getelementptr inbounds [2 x i8], ptr @.str.74, i64 0, i64 0
  %r669 = ptrtoint ptr %r669.p to i64
  %r670 = call i64 @nova_rt_eq(i64 %r668, i64 %r669)
  %r671.cmp = icmp ne i64 %r663, 0
  %r671.cmp2 = icmp ne i64 %r670, 0
  %r671.and = and i1 %r671.cmp, %r671.cmp2
  %r671 = zext i1 %r671.and to i64
  %br_then129 = icmp ne i64 %r671, 0
  br i1 %br_then129, label %then129, label %else130
then129:
  %r672 = load i64, ptr %slot.tokens, align 8
  %r673.p = getelementptr inbounds [3 x i8], ptr @.str.75, i64 0, i64 0
  %r673 = ptrtoint ptr %r673.p to i64
  %r674.p = getelementptr inbounds [3 x i8], ptr @.str.85, i64 0, i64 0
  %r674 = ptrtoint ptr %r674.p to i64
  %r675 = load i64, ptr %slot.line, align 8
  %r676 = load i64, ptr %slot.col, align 8
  %r677.ptr = call ptr @nova_rt_struct_alloc(i64 32)
  %r677.f0 = getelementptr i64, ptr %r677.ptr, i64 0
  store i64 %r673, ptr %r677.f0, align 8
  %r677.f1 = getelementptr i64, ptr %r677.ptr, i64 1
  store i64 %r674, ptr %r677.f1, align 8
  %r677.f2 = getelementptr i64, ptr %r677.ptr, i64 2
  store i64 %r675, ptr %r677.f2, align 8
  %r677.f3 = getelementptr i64, ptr %r677.ptr, i64 3
  store i64 %r676, ptr %r677.f3, align 8
  %r677 = ptrtoint ptr %r677.ptr to i64
  %r678 = call i64 @nova_rt_list_append(i64 %r672, i64 %r677)
  %r679 = load i64, ptr %slot.pos, align 8
  %r680 = add i64 2, 0
  %r681 = add i64 %r679, %r680
  store i64 %r681, ptr %slot.pos, align 8
  %r682 = load i64, ptr %slot.col, align 8
  %r683 = add i64 2, 0
  %r684 = add i64 %r682, %r683
  store i64 %r684, ptr %slot.col, align 8
  br label %endif131
else130:
  %r685 = load i64, ptr %slot.tokens, align 8
  %r686.p = getelementptr inbounds [3 x i8], ptr @.str.75, i64 0, i64 0
  %r686 = ptrtoint ptr %r686.p to i64
  %r687.p = getelementptr inbounds [2 x i8], ptr @.str.39, i64 0, i64 0
  %r687 = ptrtoint ptr %r687.p to i64
  %r688 = load i64, ptr %slot.line, align 8
  %r689 = load i64, ptr %slot.col, align 8
  %r690.ptr = call ptr @nova_rt_struct_alloc(i64 32)
  %r690.f0 = getelementptr i64, ptr %r690.ptr, i64 0
  store i64 %r686, ptr %r690.f0, align 8
  %r690.f1 = getelementptr i64, ptr %r690.ptr, i64 1
  store i64 %r687, ptr %r690.f1, align 8
  %r690.f2 = getelementptr i64, ptr %r690.ptr, i64 2
  store i64 %r688, ptr %r690.f2, align 8
  %r690.f3 = getelementptr i64, ptr %r690.ptr, i64 3
  store i64 %r689, ptr %r690.f3, align 8
  %r690 = ptrtoint ptr %r690.ptr to i64
  %r691 = call i64 @nova_rt_list_append(i64 %r685, i64 %r690)
  %r692 = load i64, ptr %slot.pos, align 8
  %r693 = add i64 1, 0
  %r694 = add i64 %r692, %r693
  store i64 %r694, ptr %slot.pos, align 8
  %r695 = load i64, ptr %slot.col, align 8
  %r696 = add i64 1, 0
  %r697 = add i64 %r695, %r696
  store i64 %r697, ptr %slot.col, align 8
  br label %endif131
endif131:
  br label %endif128
else127:
  %r698 = load i64, ptr %slot.ch, align 8
  %r699.p = getelementptr inbounds [2 x i8], ptr @.str.86, i64 0, i64 0
  %r699 = ptrtoint ptr %r699.p to i64
  %r700 = call i64 @nova_rt_eq(i64 %r698, i64 %r699)
  %br_then132 = icmp ne i64 %r700, 0
  br i1 %br_then132, label %then132, label %else133
then132:
  %r701 = load i64, ptr %slot.pos, align 8
  %r702 = add i64 1, 0
  %r703 = add i64 %r701, %r702
  %r704 = load i64, ptr %slot.length, align 8
  %r705.cmp = icmp slt i64 %r703, %r704
  %r705 = zext i1 %r705.cmp to i64
  %r706 = load i64, ptr %slot.source, align 8
  %r707 = load i64, ptr %slot.pos, align 8
  %r708 = add i64 1, 0
  %r709 = add i64 %r707, %r708
  %r710 = call i64 @nova_rt_index_get(i64 %r706, i64 %r709)
  %r711.p = getelementptr inbounds [2 x i8], ptr @.str.74, i64 0, i64 0
  %r711 = ptrtoint ptr %r711.p to i64
  %r712 = call i64 @nova_rt_eq(i64 %r710, i64 %r711)
  %r713.cmp = icmp ne i64 %r705, 0
  %r713.cmp2 = icmp ne i64 %r712, 0
  %r713.and = and i1 %r713.cmp, %r713.cmp2
  %r713 = zext i1 %r713.and to i64
  %br_then135 = icmp ne i64 %r713, 0
  br i1 %br_then135, label %then135, label %else136
then135:
  %r714 = load i64, ptr %slot.tokens, align 8
  %r715.p = getelementptr inbounds [3 x i8], ptr @.str.75, i64 0, i64 0
  %r715 = ptrtoint ptr %r715.p to i64
  %r716.p = getelementptr inbounds [3 x i8], ptr @.str.87, i64 0, i64 0
  %r716 = ptrtoint ptr %r716.p to i64
  %r717 = load i64, ptr %slot.line, align 8
  %r718 = load i64, ptr %slot.col, align 8
  %r719.ptr = call ptr @nova_rt_struct_alloc(i64 32)
  %r719.f0 = getelementptr i64, ptr %r719.ptr, i64 0
  store i64 %r715, ptr %r719.f0, align 8
  %r719.f1 = getelementptr i64, ptr %r719.ptr, i64 1
  store i64 %r716, ptr %r719.f1, align 8
  %r719.f2 = getelementptr i64, ptr %r719.ptr, i64 2
  store i64 %r717, ptr %r719.f2, align 8
  %r719.f3 = getelementptr i64, ptr %r719.ptr, i64 3
  store i64 %r718, ptr %r719.f3, align 8
  %r719 = ptrtoint ptr %r719.ptr to i64
  %r720 = call i64 @nova_rt_list_append(i64 %r714, i64 %r719)
  %r721 = load i64, ptr %slot.pos, align 8
  %r722 = add i64 2, 0
  %r723 = add i64 %r721, %r722
  store i64 %r723, ptr %slot.pos, align 8
  %r724 = load i64, ptr %slot.col, align 8
  %r725 = add i64 2, 0
  %r726 = add i64 %r724, %r725
  store i64 %r726, ptr %slot.col, align 8
  br label %endif137
else136:
  %r727 = load i64, ptr %slot.tokens, align 8
  %r728.p = getelementptr inbounds [3 x i8], ptr @.str.75, i64 0, i64 0
  %r728 = ptrtoint ptr %r728.p to i64
  %r729.p = getelementptr inbounds [2 x i8], ptr @.str.86, i64 0, i64 0
  %r729 = ptrtoint ptr %r729.p to i64
  %r730 = load i64, ptr %slot.line, align 8
  %r731 = load i64, ptr %slot.col, align 8
  %r732.ptr = call ptr @nova_rt_struct_alloc(i64 32)
  %r732.f0 = getelementptr i64, ptr %r732.ptr, i64 0
  store i64 %r728, ptr %r732.f0, align 8
  %r732.f1 = getelementptr i64, ptr %r732.ptr, i64 1
  store i64 %r729, ptr %r732.f1, align 8
  %r732.f2 = getelementptr i64, ptr %r732.ptr, i64 2
  store i64 %r730, ptr %r732.f2, align 8
  %r732.f3 = getelementptr i64, ptr %r732.ptr, i64 3
  store i64 %r731, ptr %r732.f3, align 8
  %r732 = ptrtoint ptr %r732.ptr to i64
  %r733 = call i64 @nova_rt_list_append(i64 %r727, i64 %r732)
  %r734 = load i64, ptr %slot.pos, align 8
  %r735 = add i64 1, 0
  %r736 = add i64 %r734, %r735
  store i64 %r736, ptr %slot.pos, align 8
  %r737 = load i64, ptr %slot.col, align 8
  %r738 = add i64 1, 0
  %r739 = add i64 %r737, %r738
  store i64 %r739, ptr %slot.col, align 8
  br label %endif137
endif137:
  br label %endif134
else133:
  %r740 = load i64, ptr %slot.ch, align 8
  %r741.p = getelementptr inbounds [2 x i8], ptr @.str.74, i64 0, i64 0
  %r741 = ptrtoint ptr %r741.p to i64
  %r742 = call i64 @nova_rt_eq(i64 %r740, i64 %r741)
  %br_then138 = icmp ne i64 %r742, 0
  br i1 %br_then138, label %then138, label %else139
then138:
  %r743 = load i64, ptr %slot.pos, align 8
  %r744 = add i64 1, 0
  %r745 = add i64 %r743, %r744
  %r746 = load i64, ptr %slot.length, align 8
  %r747.cmp = icmp slt i64 %r745, %r746
  %r747 = zext i1 %r747.cmp to i64
  %r748 = load i64, ptr %slot.source, align 8
  %r749 = load i64, ptr %slot.pos, align 8
  %r750 = add i64 1, 0
  %r751 = add i64 %r749, %r750
  %r752 = call i64 @nova_rt_index_get(i64 %r748, i64 %r751)
  %r753.p = getelementptr inbounds [2 x i8], ptr @.str.74, i64 0, i64 0
  %r753 = ptrtoint ptr %r753.p to i64
  %r754 = call i64 @nova_rt_eq(i64 %r752, i64 %r753)
  %r755.cmp = icmp ne i64 %r747, 0
  %r755.cmp2 = icmp ne i64 %r754, 0
  %r755.and = and i1 %r755.cmp, %r755.cmp2
  %r755 = zext i1 %r755.and to i64
  %br_then141 = icmp ne i64 %r755, 0
  br i1 %br_then141, label %then141, label %else142
then141:
  %r756 = load i64, ptr %slot.tokens, align 8
  %r757.p = getelementptr inbounds [3 x i8], ptr @.str.75, i64 0, i64 0
  %r757 = ptrtoint ptr %r757.p to i64
  %r758.p = getelementptr inbounds [3 x i8], ptr @.str.88, i64 0, i64 0
  %r758 = ptrtoint ptr %r758.p to i64
  %r759 = load i64, ptr %slot.line, align 8
  %r760 = load i64, ptr %slot.col, align 8
  %r761.ptr = call ptr @nova_rt_struct_alloc(i64 32)
  %r761.f0 = getelementptr i64, ptr %r761.ptr, i64 0
  store i64 %r757, ptr %r761.f0, align 8
  %r761.f1 = getelementptr i64, ptr %r761.ptr, i64 1
  store i64 %r758, ptr %r761.f1, align 8
  %r761.f2 = getelementptr i64, ptr %r761.ptr, i64 2
  store i64 %r759, ptr %r761.f2, align 8
  %r761.f3 = getelementptr i64, ptr %r761.ptr, i64 3
  store i64 %r760, ptr %r761.f3, align 8
  %r761 = ptrtoint ptr %r761.ptr to i64
  %r762 = call i64 @nova_rt_list_append(i64 %r756, i64 %r761)
  %r763 = load i64, ptr %slot.pos, align 8
  %r764 = add i64 2, 0
  %r765 = add i64 %r763, %r764
  store i64 %r765, ptr %slot.pos, align 8
  %r766 = load i64, ptr %slot.col, align 8
  %r767 = add i64 2, 0
  %r768 = add i64 %r766, %r767
  store i64 %r768, ptr %slot.col, align 8
  br label %endif143
else142:
  %r769 = load i64, ptr %slot.pos, align 8
  %r770 = add i64 1, 0
  %r771 = add i64 %r769, %r770
  %r772 = load i64, ptr %slot.length, align 8
  %r773.cmp = icmp slt i64 %r771, %r772
  %r773 = zext i1 %r773.cmp to i64
  %r774 = load i64, ptr %slot.source, align 8
  %r775 = load i64, ptr %slot.pos, align 8
  %r776 = add i64 1, 0
  %r777 = add i64 %r775, %r776
  %r778 = call i64 @nova_rt_index_get(i64 %r774, i64 %r777)
  %r779.p = getelementptr inbounds [2 x i8], ptr @.str.78, i64 0, i64 0
  %r779 = ptrtoint ptr %r779.p to i64
  %r780 = call i64 @nova_rt_eq(i64 %r778, i64 %r779)
  %r781.cmp = icmp ne i64 %r773, 0
  %r781.cmp2 = icmp ne i64 %r780, 0
  %r781.and = and i1 %r781.cmp, %r781.cmp2
  %r781 = zext i1 %r781.and to i64
  %br_then144 = icmp ne i64 %r781, 0
  br i1 %br_then144, label %then144, label %else145
then144:
  %r782 = load i64, ptr %slot.tokens, align 8
  %r783.p = getelementptr inbounds [10 x i8], ptr @.str.89, i64 0, i64 0
  %r783 = ptrtoint ptr %r783.p to i64
  %r784.p = getelementptr inbounds [3 x i8], ptr @.str.90, i64 0, i64 0
  %r784 = ptrtoint ptr %r784.p to i64
  %r785 = load i64, ptr %slot.line, align 8
  %r786 = load i64, ptr %slot.col, align 8
  %r787.ptr = call ptr @nova_rt_struct_alloc(i64 32)
  %r787.f0 = getelementptr i64, ptr %r787.ptr, i64 0
  store i64 %r783, ptr %r787.f0, align 8
  %r787.f1 = getelementptr i64, ptr %r787.ptr, i64 1
  store i64 %r784, ptr %r787.f1, align 8
  %r787.f2 = getelementptr i64, ptr %r787.ptr, i64 2
  store i64 %r785, ptr %r787.f2, align 8
  %r787.f3 = getelementptr i64, ptr %r787.ptr, i64 3
  store i64 %r786, ptr %r787.f3, align 8
  %r787 = ptrtoint ptr %r787.ptr to i64
  %r788 = call i64 @nova_rt_list_append(i64 %r782, i64 %r787)
  %r789 = load i64, ptr %slot.pos, align 8
  %r790 = add i64 2, 0
  %r791 = add i64 %r789, %r790
  store i64 %r791, ptr %slot.pos, align 8
  %r792 = load i64, ptr %slot.col, align 8
  %r793 = add i64 2, 0
  %r794 = add i64 %r792, %r793
  store i64 %r794, ptr %slot.col, align 8
  br label %endif146
else145:
  %r795 = load i64, ptr %slot.tokens, align 8
  %r796.p = getelementptr inbounds [7 x i8], ptr @.str.91, i64 0, i64 0
  %r796 = ptrtoint ptr %r796.p to i64
  %r797.p = getelementptr inbounds [2 x i8], ptr @.str.74, i64 0, i64 0
  %r797 = ptrtoint ptr %r797.p to i64
  %r798 = load i64, ptr %slot.line, align 8
  %r799 = load i64, ptr %slot.col, align 8
  %r800.ptr = call ptr @nova_rt_struct_alloc(i64 32)
  %r800.f0 = getelementptr i64, ptr %r800.ptr, i64 0
  store i64 %r796, ptr %r800.f0, align 8
  %r800.f1 = getelementptr i64, ptr %r800.ptr, i64 1
  store i64 %r797, ptr %r800.f1, align 8
  %r800.f2 = getelementptr i64, ptr %r800.ptr, i64 2
  store i64 %r798, ptr %r800.f2, align 8
  %r800.f3 = getelementptr i64, ptr %r800.ptr, i64 3
  store i64 %r799, ptr %r800.f3, align 8
  %r800 = ptrtoint ptr %r800.ptr to i64
  %r801 = call i64 @nova_rt_list_append(i64 %r795, i64 %r800)
  %r802 = load i64, ptr %slot.pos, align 8
  %r803 = add i64 1, 0
  %r804 = add i64 %r802, %r803
  store i64 %r804, ptr %slot.pos, align 8
  %r805 = load i64, ptr %slot.col, align 8
  %r806 = add i64 1, 0
  %r807 = add i64 %r805, %r806
  store i64 %r807, ptr %slot.col, align 8
  br label %endif146
endif146:
  br label %endif143
endif143:
  br label %endif140
else139:
  %r808 = load i64, ptr %slot.ch, align 8
  %r809.p = getelementptr inbounds [2 x i8], ptr @.str.92, i64 0, i64 0
  %r809 = ptrtoint ptr %r809.p to i64
  %r810 = call i64 @nova_rt_eq(i64 %r808, i64 %r809)
  %br_then147 = icmp ne i64 %r810, 0
  br i1 %br_then147, label %then147, label %else148
then147:
  %r811 = load i64, ptr %slot.pos, align 8
  %r812 = add i64 1, 0
  %r813 = add i64 %r811, %r812
  %r814 = load i64, ptr %slot.length, align 8
  %r815.cmp = icmp slt i64 %r813, %r814
  %r815 = zext i1 %r815.cmp to i64
  %r816 = load i64, ptr %slot.source, align 8
  %r817 = load i64, ptr %slot.pos, align 8
  %r818 = add i64 1, 0
  %r819 = add i64 %r817, %r818
  %r820 = call i64 @nova_rt_index_get(i64 %r816, i64 %r819)
  %r821.p = getelementptr inbounds [2 x i8], ptr @.str.74, i64 0, i64 0
  %r821 = ptrtoint ptr %r821.p to i64
  %r822 = call i64 @nova_rt_eq(i64 %r820, i64 %r821)
  %r823.cmp = icmp ne i64 %r815, 0
  %r823.cmp2 = icmp ne i64 %r822, 0
  %r823.and = and i1 %r823.cmp, %r823.cmp2
  %r823 = zext i1 %r823.and to i64
  %br_then150 = icmp ne i64 %r823, 0
  br i1 %br_then150, label %then150, label %else151
then150:
  %r824 = load i64, ptr %slot.tokens, align 8
  %r825.p = getelementptr inbounds [3 x i8], ptr @.str.75, i64 0, i64 0
  %r825 = ptrtoint ptr %r825.p to i64
  %r826.p = getelementptr inbounds [3 x i8], ptr @.str.93, i64 0, i64 0
  %r826 = ptrtoint ptr %r826.p to i64
  %r827 = load i64, ptr %slot.line, align 8
  %r828 = load i64, ptr %slot.col, align 8
  %r829.ptr = call ptr @nova_rt_struct_alloc(i64 32)
  %r829.f0 = getelementptr i64, ptr %r829.ptr, i64 0
  store i64 %r825, ptr %r829.f0, align 8
  %r829.f1 = getelementptr i64, ptr %r829.ptr, i64 1
  store i64 %r826, ptr %r829.f1, align 8
  %r829.f2 = getelementptr i64, ptr %r829.ptr, i64 2
  store i64 %r827, ptr %r829.f2, align 8
  %r829.f3 = getelementptr i64, ptr %r829.ptr, i64 3
  store i64 %r828, ptr %r829.f3, align 8
  %r829 = ptrtoint ptr %r829.ptr to i64
  %r830 = call i64 @nova_rt_list_append(i64 %r824, i64 %r829)
  %r831 = load i64, ptr %slot.pos, align 8
  %r832 = add i64 2, 0
  %r833 = add i64 %r831, %r832
  store i64 %r833, ptr %slot.pos, align 8
  %r834 = load i64, ptr %slot.col, align 8
  %r835 = add i64 2, 0
  %r836 = add i64 %r834, %r835
  store i64 %r836, ptr %slot.col, align 8
  br label %endif152
else151:
  %r837 = load i64, ptr %slot.tokens, align 8
  %r838.p = getelementptr inbounds [3 x i8], ptr @.str.75, i64 0, i64 0
  %r838 = ptrtoint ptr %r838.p to i64
  %r839.p = getelementptr inbounds [2 x i8], ptr @.str.92, i64 0, i64 0
  %r839 = ptrtoint ptr %r839.p to i64
  %r840 = load i64, ptr %slot.line, align 8
  %r841 = load i64, ptr %slot.col, align 8
  %r842.ptr = call ptr @nova_rt_struct_alloc(i64 32)
  %r842.f0 = getelementptr i64, ptr %r842.ptr, i64 0
  store i64 %r838, ptr %r842.f0, align 8
  %r842.f1 = getelementptr i64, ptr %r842.ptr, i64 1
  store i64 %r839, ptr %r842.f1, align 8
  %r842.f2 = getelementptr i64, ptr %r842.ptr, i64 2
  store i64 %r840, ptr %r842.f2, align 8
  %r842.f3 = getelementptr i64, ptr %r842.ptr, i64 3
  store i64 %r841, ptr %r842.f3, align 8
  %r842 = ptrtoint ptr %r842.ptr to i64
  %r843 = call i64 @nova_rt_list_append(i64 %r837, i64 %r842)
  %r844 = load i64, ptr %slot.pos, align 8
  %r845 = add i64 1, 0
  %r846 = add i64 %r844, %r845
  store i64 %r846, ptr %slot.pos, align 8
  %r847 = load i64, ptr %slot.col, align 8
  %r848 = add i64 1, 0
  %r849 = add i64 %r847, %r848
  store i64 %r849, ptr %slot.col, align 8
  br label %endif152
endif152:
  br label %endif149
else148:
  %r850 = load i64, ptr %slot.ch, align 8
  %r851.p = getelementptr inbounds [2 x i8], ptr @.str.94, i64 0, i64 0
  %r851 = ptrtoint ptr %r851.p to i64
  %r852 = call i64 @nova_rt_eq(i64 %r850, i64 %r851)
  %br_then153 = icmp ne i64 %r852, 0
  br i1 %br_then153, label %then153, label %else154
then153:
  %r853 = load i64, ptr %slot.pos, align 8
  %r854 = add i64 1, 0
  %r855 = add i64 %r853, %r854
  %r856 = load i64, ptr %slot.length, align 8
  %r857.cmp = icmp slt i64 %r855, %r856
  %r857 = zext i1 %r857.cmp to i64
  %r858 = load i64, ptr %slot.source, align 8
  %r859 = load i64, ptr %slot.pos, align 8
  %r860 = add i64 1, 0
  %r861 = add i64 %r859, %r860
  %r862 = call i64 @nova_rt_index_get(i64 %r858, i64 %r861)
  %r863.p = getelementptr inbounds [2 x i8], ptr @.str.74, i64 0, i64 0
  %r863 = ptrtoint ptr %r863.p to i64
  %r864 = call i64 @nova_rt_eq(i64 %r862, i64 %r863)
  %r865.cmp = icmp ne i64 %r857, 0
  %r865.cmp2 = icmp ne i64 %r864, 0
  %r865.and = and i1 %r865.cmp, %r865.cmp2
  %r865 = zext i1 %r865.and to i64
  %br_then156 = icmp ne i64 %r865, 0
  br i1 %br_then156, label %then156, label %else157
then156:
  %r866 = load i64, ptr %slot.tokens, align 8
  %r867.p = getelementptr inbounds [3 x i8], ptr @.str.75, i64 0, i64 0
  %r867 = ptrtoint ptr %r867.p to i64
  %r868.p = getelementptr inbounds [3 x i8], ptr @.str.95, i64 0, i64 0
  %r868 = ptrtoint ptr %r868.p to i64
  %r869 = load i64, ptr %slot.line, align 8
  %r870 = load i64, ptr %slot.col, align 8
  %r871.ptr = call ptr @nova_rt_struct_alloc(i64 32)
  %r871.f0 = getelementptr i64, ptr %r871.ptr, i64 0
  store i64 %r867, ptr %r871.f0, align 8
  %r871.f1 = getelementptr i64, ptr %r871.ptr, i64 1
  store i64 %r868, ptr %r871.f1, align 8
  %r871.f2 = getelementptr i64, ptr %r871.ptr, i64 2
  store i64 %r869, ptr %r871.f2, align 8
  %r871.f3 = getelementptr i64, ptr %r871.ptr, i64 3
  store i64 %r870, ptr %r871.f3, align 8
  %r871 = ptrtoint ptr %r871.ptr to i64
  %r872 = call i64 @nova_rt_list_append(i64 %r866, i64 %r871)
  %r873 = load i64, ptr %slot.pos, align 8
  %r874 = add i64 2, 0
  %r875 = add i64 %r873, %r874
  store i64 %r875, ptr %slot.pos, align 8
  %r876 = load i64, ptr %slot.col, align 8
  %r877 = add i64 2, 0
  %r878 = add i64 %r876, %r877
  store i64 %r878, ptr %slot.col, align 8
  br label %endif158
else157:
  %r879 = load i64, ptr %slot.pos, align 8
  %r880 = add i64 1, 0
  %r881 = add i64 %r879, %r880
  %r882 = load i64, ptr %slot.length, align 8
  %r883.cmp = icmp slt i64 %r881, %r882
  %r883 = zext i1 %r883.cmp to i64
  %r884 = load i64, ptr %slot.source, align 8
  %r885 = load i64, ptr %slot.pos, align 8
  %r886 = add i64 1, 0
  %r887 = add i64 %r885, %r886
  %r888 = call i64 @nova_rt_index_get(i64 %r884, i64 %r887)
  %r889.p = getelementptr inbounds [2 x i8], ptr @.str.94, i64 0, i64 0
  %r889 = ptrtoint ptr %r889.p to i64
  %r890 = call i64 @nova_rt_eq(i64 %r888, i64 %r889)
  %r891.cmp = icmp ne i64 %r883, 0
  %r891.cmp2 = icmp ne i64 %r890, 0
  %r891.and = and i1 %r891.cmp, %r891.cmp2
  %r891 = zext i1 %r891.and to i64
  %br_then159 = icmp ne i64 %r891, 0
  br i1 %br_then159, label %then159, label %else160
then159:
  %r892 = load i64, ptr %slot.tokens, align 8
  %r893.p = getelementptr inbounds [3 x i8], ptr @.str.75, i64 0, i64 0
  %r893 = ptrtoint ptr %r893.p to i64
  %r894.p = getelementptr inbounds [3 x i8], ptr @.str.96, i64 0, i64 0
  %r894 = ptrtoint ptr %r894.p to i64
  %r895 = load i64, ptr %slot.line, align 8
  %r896 = load i64, ptr %slot.col, align 8
  %r897.ptr = call ptr @nova_rt_struct_alloc(i64 32)
  %r897.f0 = getelementptr i64, ptr %r897.ptr, i64 0
  store i64 %r893, ptr %r897.f0, align 8
  %r897.f1 = getelementptr i64, ptr %r897.ptr, i64 1
  store i64 %r894, ptr %r897.f1, align 8
  %r897.f2 = getelementptr i64, ptr %r897.ptr, i64 2
  store i64 %r895, ptr %r897.f2, align 8
  %r897.f3 = getelementptr i64, ptr %r897.ptr, i64 3
  store i64 %r896, ptr %r897.f3, align 8
  %r897 = ptrtoint ptr %r897.ptr to i64
  %r898 = call i64 @nova_rt_list_append(i64 %r892, i64 %r897)
  %r899 = load i64, ptr %slot.pos, align 8
  %r900 = add i64 2, 0
  %r901 = add i64 %r899, %r900
  store i64 %r901, ptr %slot.pos, align 8
  %r902 = load i64, ptr %slot.col, align 8
  %r903 = add i64 2, 0
  %r904 = add i64 %r902, %r903
  store i64 %r904, ptr %slot.col, align 8
  br label %endif161
else160:
  %r905 = load i64, ptr %slot.tokens, align 8
  %r906.p = getelementptr inbounds [3 x i8], ptr @.str.75, i64 0, i64 0
  %r906 = ptrtoint ptr %r906.p to i64
  %r907.p = getelementptr inbounds [2 x i8], ptr @.str.94, i64 0, i64 0
  %r907 = ptrtoint ptr %r907.p to i64
  %r908 = load i64, ptr %slot.line, align 8
  %r909 = load i64, ptr %slot.col, align 8
  %r910.ptr = call ptr @nova_rt_struct_alloc(i64 32)
  %r910.f0 = getelementptr i64, ptr %r910.ptr, i64 0
  store i64 %r906, ptr %r910.f0, align 8
  %r910.f1 = getelementptr i64, ptr %r910.ptr, i64 1
  store i64 %r907, ptr %r910.f1, align 8
  %r910.f2 = getelementptr i64, ptr %r910.ptr, i64 2
  store i64 %r908, ptr %r910.f2, align 8
  %r910.f3 = getelementptr i64, ptr %r910.ptr, i64 3
  store i64 %r909, ptr %r910.f3, align 8
  %r910 = ptrtoint ptr %r910.ptr to i64
  %r911 = call i64 @nova_rt_list_append(i64 %r905, i64 %r910)
  %r912 = load i64, ptr %slot.pos, align 8
  %r913 = add i64 1, 0
  %r914 = add i64 %r912, %r913
  store i64 %r914, ptr %slot.pos, align 8
  %r915 = load i64, ptr %slot.col, align 8
  %r916 = add i64 1, 0
  %r917 = add i64 %r915, %r916
  store i64 %r917, ptr %slot.col, align 8
  br label %endif161
endif161:
  br label %endif158
endif158:
  br label %endif155
else154:
  %r918 = load i64, ptr %slot.ch, align 8
  %r919.p = getelementptr inbounds [2 x i8], ptr @.str.78, i64 0, i64 0
  %r919 = ptrtoint ptr %r919.p to i64
  %r920 = call i64 @nova_rt_eq(i64 %r918, i64 %r919)
  %br_then162 = icmp ne i64 %r920, 0
  br i1 %br_then162, label %then162, label %else163
then162:
  %r921 = load i64, ptr %slot.pos, align 8
  %r922 = add i64 1, 0
  %r923 = add i64 %r921, %r922
  %r924 = load i64, ptr %slot.length, align 8
  %r925.cmp = icmp slt i64 %r923, %r924
  %r925 = zext i1 %r925.cmp to i64
  %r926 = load i64, ptr %slot.source, align 8
  %r927 = load i64, ptr %slot.pos, align 8
  %r928 = add i64 1, 0
  %r929 = add i64 %r927, %r928
  %r930 = call i64 @nova_rt_index_get(i64 %r926, i64 %r929)
  %r931.p = getelementptr inbounds [2 x i8], ptr @.str.74, i64 0, i64 0
  %r931 = ptrtoint ptr %r931.p to i64
  %r932 = call i64 @nova_rt_eq(i64 %r930, i64 %r931)
  %r933.cmp = icmp ne i64 %r925, 0
  %r933.cmp2 = icmp ne i64 %r932, 0
  %r933.and = and i1 %r933.cmp, %r933.cmp2
  %r933 = zext i1 %r933.and to i64
  %br_then165 = icmp ne i64 %r933, 0
  br i1 %br_then165, label %then165, label %else166
then165:
  %r934 = load i64, ptr %slot.tokens, align 8
  %r935.p = getelementptr inbounds [3 x i8], ptr @.str.75, i64 0, i64 0
  %r935 = ptrtoint ptr %r935.p to i64
  %r936.p = getelementptr inbounds [3 x i8], ptr @.str.97, i64 0, i64 0
  %r936 = ptrtoint ptr %r936.p to i64
  %r937 = load i64, ptr %slot.line, align 8
  %r938 = load i64, ptr %slot.col, align 8
  %r939.ptr = call ptr @nova_rt_struct_alloc(i64 32)
  %r939.f0 = getelementptr i64, ptr %r939.ptr, i64 0
  store i64 %r935, ptr %r939.f0, align 8
  %r939.f1 = getelementptr i64, ptr %r939.ptr, i64 1
  store i64 %r936, ptr %r939.f1, align 8
  %r939.f2 = getelementptr i64, ptr %r939.ptr, i64 2
  store i64 %r937, ptr %r939.f2, align 8
  %r939.f3 = getelementptr i64, ptr %r939.ptr, i64 3
  store i64 %r938, ptr %r939.f3, align 8
  %r939 = ptrtoint ptr %r939.ptr to i64
  %r940 = call i64 @nova_rt_list_append(i64 %r934, i64 %r939)
  %r941 = load i64, ptr %slot.pos, align 8
  %r942 = add i64 2, 0
  %r943 = add i64 %r941, %r942
  store i64 %r943, ptr %slot.pos, align 8
  %r944 = load i64, ptr %slot.col, align 8
  %r945 = add i64 2, 0
  %r946 = add i64 %r944, %r945
  store i64 %r946, ptr %slot.col, align 8
  br label %endif167
else166:
  %r947 = load i64, ptr %slot.pos, align 8
  %r948 = add i64 1, 0
  %r949 = add i64 %r947, %r948
  %r950 = load i64, ptr %slot.length, align 8
  %r951.cmp = icmp slt i64 %r949, %r950
  %r951 = zext i1 %r951.cmp to i64
  %r952 = load i64, ptr %slot.source, align 8
  %r953 = load i64, ptr %slot.pos, align 8
  %r954 = add i64 1, 0
  %r955 = add i64 %r953, %r954
  %r956 = call i64 @nova_rt_index_get(i64 %r952, i64 %r955)
  %r957.p = getelementptr inbounds [2 x i8], ptr @.str.78, i64 0, i64 0
  %r957 = ptrtoint ptr %r957.p to i64
  %r958 = call i64 @nova_rt_eq(i64 %r956, i64 %r957)
  %r959.cmp = icmp ne i64 %r951, 0
  %r959.cmp2 = icmp ne i64 %r958, 0
  %r959.and = and i1 %r959.cmp, %r959.cmp2
  %r959 = zext i1 %r959.and to i64
  %br_then168 = icmp ne i64 %r959, 0
  br i1 %br_then168, label %then168, label %else169
then168:
  %r960 = load i64, ptr %slot.tokens, align 8
  %r961.p = getelementptr inbounds [3 x i8], ptr @.str.75, i64 0, i64 0
  %r961 = ptrtoint ptr %r961.p to i64
  %r962.p = getelementptr inbounds [3 x i8], ptr @.str.98, i64 0, i64 0
  %r962 = ptrtoint ptr %r962.p to i64
  %r963 = load i64, ptr %slot.line, align 8
  %r964 = load i64, ptr %slot.col, align 8
  %r965.ptr = call ptr @nova_rt_struct_alloc(i64 32)
  %r965.f0 = getelementptr i64, ptr %r965.ptr, i64 0
  store i64 %r961, ptr %r965.f0, align 8
  %r965.f1 = getelementptr i64, ptr %r965.ptr, i64 1
  store i64 %r962, ptr %r965.f1, align 8
  %r965.f2 = getelementptr i64, ptr %r965.ptr, i64 2
  store i64 %r963, ptr %r965.f2, align 8
  %r965.f3 = getelementptr i64, ptr %r965.ptr, i64 3
  store i64 %r964, ptr %r965.f3, align 8
  %r965 = ptrtoint ptr %r965.ptr to i64
  %r966 = call i64 @nova_rt_list_append(i64 %r960, i64 %r965)
  %r967 = load i64, ptr %slot.pos, align 8
  %r968 = add i64 2, 0
  %r969 = add i64 %r967, %r968
  store i64 %r969, ptr %slot.pos, align 8
  %r970 = load i64, ptr %slot.col, align 8
  %r971 = add i64 2, 0
  %r972 = add i64 %r970, %r971
  store i64 %r972, ptr %slot.col, align 8
  br label %endif170
else169:
  %r973 = load i64, ptr %slot.tokens, align 8
  %r974.p = getelementptr inbounds [3 x i8], ptr @.str.75, i64 0, i64 0
  %r974 = ptrtoint ptr %r974.p to i64
  %r975.p = getelementptr inbounds [2 x i8], ptr @.str.78, i64 0, i64 0
  %r975 = ptrtoint ptr %r975.p to i64
  %r976 = load i64, ptr %slot.line, align 8
  %r977 = load i64, ptr %slot.col, align 8
  %r978.ptr = call ptr @nova_rt_struct_alloc(i64 32)
  %r978.f0 = getelementptr i64, ptr %r978.ptr, i64 0
  store i64 %r974, ptr %r978.f0, align 8
  %r978.f1 = getelementptr i64, ptr %r978.ptr, i64 1
  store i64 %r975, ptr %r978.f1, align 8
  %r978.f2 = getelementptr i64, ptr %r978.ptr, i64 2
  store i64 %r976, ptr %r978.f2, align 8
  %r978.f3 = getelementptr i64, ptr %r978.ptr, i64 3
  store i64 %r977, ptr %r978.f3, align 8
  %r978 = ptrtoint ptr %r978.ptr to i64
  %r979 = call i64 @nova_rt_list_append(i64 %r973, i64 %r978)
  %r980 = load i64, ptr %slot.pos, align 8
  %r981 = add i64 1, 0
  %r982 = add i64 %r980, %r981
  store i64 %r982, ptr %slot.pos, align 8
  %r983 = load i64, ptr %slot.col, align 8
  %r984 = add i64 1, 0
  %r985 = add i64 %r983, %r984
  store i64 %r985, ptr %slot.col, align 8
  br label %endif170
endif170:
  br label %endif167
endif167:
  br label %endif164
else163:
  %r986 = load i64, ptr %slot.ch, align 8
  %r987.p = getelementptr inbounds [2 x i8], ptr @.str.99, i64 0, i64 0
  %r987 = ptrtoint ptr %r987.p to i64
  %r988 = call i64 @nova_rt_eq(i64 %r986, i64 %r987)
  %br_then171 = icmp ne i64 %r988, 0
  br i1 %br_then171, label %then171, label %else172
then171:
  %r989 = load i64, ptr %slot.tokens, align 8
  %r990.p = getelementptr inbounds [3 x i8], ptr @.str.75, i64 0, i64 0
  %r990 = ptrtoint ptr %r990.p to i64
  %r991.p = getelementptr inbounds [2 x i8], ptr @.str.99, i64 0, i64 0
  %r991 = ptrtoint ptr %r991.p to i64
  %r992 = load i64, ptr %slot.line, align 8
  %r993 = load i64, ptr %slot.col, align 8
  %r994.ptr = call ptr @nova_rt_struct_alloc(i64 32)
  %r994.f0 = getelementptr i64, ptr %r994.ptr, i64 0
  store i64 %r990, ptr %r994.f0, align 8
  %r994.f1 = getelementptr i64, ptr %r994.ptr, i64 1
  store i64 %r991, ptr %r994.f1, align 8
  %r994.f2 = getelementptr i64, ptr %r994.ptr, i64 2
  store i64 %r992, ptr %r994.f2, align 8
  %r994.f3 = getelementptr i64, ptr %r994.ptr, i64 3
  store i64 %r993, ptr %r994.f3, align 8
  %r994 = ptrtoint ptr %r994.ptr to i64
  %r995 = call i64 @nova_rt_list_append(i64 %r989, i64 %r994)
  %r996 = load i64, ptr %slot.pos, align 8
  %r997 = add i64 1, 0
  %r998 = add i64 %r996, %r997
  store i64 %r998, ptr %slot.pos, align 8
  %r999 = load i64, ptr %slot.col, align 8
  %r1000 = add i64 1, 0
  %r1001 = add i64 %r999, %r1000
  store i64 %r1001, ptr %slot.col, align 8
  br label %endif173
else172:
  %r1002 = load i64, ptr %slot.ch, align 8
  %r1003.p = getelementptr inbounds [2 x i8], ptr @.str.100, i64 0, i64 0
  %r1003 = ptrtoint ptr %r1003.p to i64
  %r1004 = call i64 @nova_rt_eq(i64 %r1002, i64 %r1003)
  %br_then174 = icmp ne i64 %r1004, 0
  br i1 %br_then174, label %then174, label %else175
then174:
  %r1005 = load i64, ptr %slot.pos, align 8
  %r1006 = add i64 1, 0
  %r1007 = add i64 %r1005, %r1006
  %r1008 = load i64, ptr %slot.length, align 8
  %r1009.cmp = icmp slt i64 %r1007, %r1008
  %r1009 = zext i1 %r1009.cmp to i64
  %r1010 = load i64, ptr %slot.source, align 8
  %r1011 = load i64, ptr %slot.pos, align 8
  %r1012 = add i64 1, 0
  %r1013 = add i64 %r1011, %r1012
  %r1014 = call i64 @nova_rt_index_get(i64 %r1010, i64 %r1013)
  %r1015.p = getelementptr inbounds [2 x i8], ptr @.str.78, i64 0, i64 0
  %r1015 = ptrtoint ptr %r1015.p to i64
  %r1016 = call i64 @nova_rt_eq(i64 %r1014, i64 %r1015)
  %r1017.cmp = icmp ne i64 %r1009, 0
  %r1017.cmp2 = icmp ne i64 %r1016, 0
  %r1017.and = and i1 %r1017.cmp, %r1017.cmp2
  %r1017 = zext i1 %r1017.and to i64
  %br_then177 = icmp ne i64 %r1017, 0
  br i1 %br_then177, label %then177, label %else178
then177:
  %r1018 = load i64, ptr %slot.tokens, align 8
  %r1019.p = getelementptr inbounds [8 x i8], ptr @.str.101, i64 0, i64 0
  %r1019 = ptrtoint ptr %r1019.p to i64
  %r1020.p = getelementptr inbounds [3 x i8], ptr @.str.102, i64 0, i64 0
  %r1020 = ptrtoint ptr %r1020.p to i64
  %r1021 = load i64, ptr %slot.line, align 8
  %r1022 = load i64, ptr %slot.col, align 8
  %r1023.ptr = call ptr @nova_rt_struct_alloc(i64 32)
  %r1023.f0 = getelementptr i64, ptr %r1023.ptr, i64 0
  store i64 %r1019, ptr %r1023.f0, align 8
  %r1023.f1 = getelementptr i64, ptr %r1023.ptr, i64 1
  store i64 %r1020, ptr %r1023.f1, align 8
  %r1023.f2 = getelementptr i64, ptr %r1023.ptr, i64 2
  store i64 %r1021, ptr %r1023.f2, align 8
  %r1023.f3 = getelementptr i64, ptr %r1023.ptr, i64 3
  store i64 %r1022, ptr %r1023.f3, align 8
  %r1023 = ptrtoint ptr %r1023.ptr to i64
  %r1024 = call i64 @nova_rt_list_append(i64 %r1018, i64 %r1023)
  %r1025 = load i64, ptr %slot.pos, align 8
  %r1026 = add i64 2, 0
  %r1027 = add i64 %r1025, %r1026
  store i64 %r1027, ptr %slot.pos, align 8
  %r1028 = load i64, ptr %slot.col, align 8
  %r1029 = add i64 2, 0
  %r1030 = add i64 %r1028, %r1029
  store i64 %r1030, ptr %slot.col, align 8
  br label %endif179
else178:
  %r1031 = load i64, ptr %slot.tokens, align 8
  %r1032.p = getelementptr inbounds [3 x i8], ptr @.str.75, i64 0, i64 0
  %r1032 = ptrtoint ptr %r1032.p to i64
  %r1033.p = getelementptr inbounds [2 x i8], ptr @.str.100, i64 0, i64 0
  %r1033 = ptrtoint ptr %r1033.p to i64
  %r1034 = load i64, ptr %slot.line, align 8
  %r1035 = load i64, ptr %slot.col, align 8
  %r1036.ptr = call ptr @nova_rt_struct_alloc(i64 32)
  %r1036.f0 = getelementptr i64, ptr %r1036.ptr, i64 0
  store i64 %r1032, ptr %r1036.f0, align 8
  %r1036.f1 = getelementptr i64, ptr %r1036.ptr, i64 1
  store i64 %r1033, ptr %r1036.f1, align 8
  %r1036.f2 = getelementptr i64, ptr %r1036.ptr, i64 2
  store i64 %r1034, ptr %r1036.f2, align 8
  %r1036.f3 = getelementptr i64, ptr %r1036.ptr, i64 3
  store i64 %r1035, ptr %r1036.f3, align 8
  %r1036 = ptrtoint ptr %r1036.ptr to i64
  %r1037 = call i64 @nova_rt_list_append(i64 %r1031, i64 %r1036)
  %r1038 = load i64, ptr %slot.pos, align 8
  %r1039 = add i64 1, 0
  %r1040 = add i64 %r1038, %r1039
  store i64 %r1040, ptr %slot.pos, align 8
  %r1041 = load i64, ptr %slot.col, align 8
  %r1042 = add i64 1, 0
  %r1043 = add i64 %r1041, %r1042
  store i64 %r1043, ptr %slot.col, align 8
  br label %endif179
endif179:
  br label %endif176
else175:
  %r1044 = load i64, ptr %slot.ch, align 8
  %r1045.p = getelementptr inbounds [2 x i8], ptr @.str.103, i64 0, i64 0
  %r1045 = ptrtoint ptr %r1045.p to i64
  %r1046 = call i64 @nova_rt_eq(i64 %r1044, i64 %r1045)
  %br_then180 = icmp ne i64 %r1046, 0
  br i1 %br_then180, label %then180, label %else181
then180:
  %r1047 = load i64, ptr %slot.tokens, align 8
  %r1048.p = getelementptr inbounds [3 x i8], ptr @.str.75, i64 0, i64 0
  %r1048 = ptrtoint ptr %r1048.p to i64
  %r1049.p = getelementptr inbounds [2 x i8], ptr @.str.103, i64 0, i64 0
  %r1049 = ptrtoint ptr %r1049.p to i64
  %r1050 = load i64, ptr %slot.line, align 8
  %r1051 = load i64, ptr %slot.col, align 8
  %r1052.ptr = call ptr @nova_rt_struct_alloc(i64 32)
  %r1052.f0 = getelementptr i64, ptr %r1052.ptr, i64 0
  store i64 %r1048, ptr %r1052.f0, align 8
  %r1052.f1 = getelementptr i64, ptr %r1052.ptr, i64 1
  store i64 %r1049, ptr %r1052.f1, align 8
  %r1052.f2 = getelementptr i64, ptr %r1052.ptr, i64 2
  store i64 %r1050, ptr %r1052.f2, align 8
  %r1052.f3 = getelementptr i64, ptr %r1052.ptr, i64 3
  store i64 %r1051, ptr %r1052.f3, align 8
  %r1052 = ptrtoint ptr %r1052.ptr to i64
  %r1053 = call i64 @nova_rt_list_append(i64 %r1047, i64 %r1052)
  %r1054 = load i64, ptr %slot.pos, align 8
  %r1055 = add i64 1, 0
  %r1056 = add i64 %r1054, %r1055
  store i64 %r1056, ptr %slot.pos, align 8
  %r1057 = load i64, ptr %slot.col, align 8
  %r1058 = add i64 1, 0
  %r1059 = add i64 %r1057, %r1058
  store i64 %r1059, ptr %slot.col, align 8
  br label %endif182
else181:
  %r1060 = load i64, ptr %slot.ch, align 8
  %r1061.p = getelementptr inbounds [2 x i8], ptr @.str.104, i64 0, i64 0
  %r1061 = ptrtoint ptr %r1061.p to i64
  %r1062 = call i64 @nova_rt_eq(i64 %r1060, i64 %r1061)
  %br_then183 = icmp ne i64 %r1062, 0
  br i1 %br_then183, label %then183, label %else184
then183:
  %r1063 = load i64, ptr %slot.tokens, align 8
  %r1064.p = getelementptr inbounds [3 x i8], ptr @.str.75, i64 0, i64 0
  %r1064 = ptrtoint ptr %r1064.p to i64
  %r1065.p = getelementptr inbounds [2 x i8], ptr @.str.104, i64 0, i64 0
  %r1065 = ptrtoint ptr %r1065.p to i64
  %r1066 = load i64, ptr %slot.line, align 8
  %r1067 = load i64, ptr %slot.col, align 8
  %r1068.ptr = call ptr @nova_rt_struct_alloc(i64 32)
  %r1068.f0 = getelementptr i64, ptr %r1068.ptr, i64 0
  store i64 %r1064, ptr %r1068.f0, align 8
  %r1068.f1 = getelementptr i64, ptr %r1068.ptr, i64 1
  store i64 %r1065, ptr %r1068.f1, align 8
  %r1068.f2 = getelementptr i64, ptr %r1068.ptr, i64 2
  store i64 %r1066, ptr %r1068.f2, align 8
  %r1068.f3 = getelementptr i64, ptr %r1068.ptr, i64 3
  store i64 %r1067, ptr %r1068.f3, align 8
  %r1068 = ptrtoint ptr %r1068.ptr to i64
  %r1069 = call i64 @nova_rt_list_append(i64 %r1063, i64 %r1068)
  %r1070 = load i64, ptr %slot.pos, align 8
  %r1071 = add i64 1, 0
  %r1072 = add i64 %r1070, %r1071
  store i64 %r1072, ptr %slot.pos, align 8
  %r1073 = load i64, ptr %slot.col, align 8
  %r1074 = add i64 1, 0
  %r1075 = add i64 %r1073, %r1074
  store i64 %r1075, ptr %slot.col, align 8
  br label %endif185
else184:
  %r1076 = load i64, ptr %slot.ch, align 8
  %r1077.p = getelementptr inbounds [2 x i8], ptr @.str.105, i64 0, i64 0
  %r1077 = ptrtoint ptr %r1077.p to i64
  %r1078 = call i64 @nova_rt_eq(i64 %r1076, i64 %r1077)
  %br_then186 = icmp ne i64 %r1078, 0
  br i1 %br_then186, label %then186, label %else187
then186:
  %r1079 = load i64, ptr %slot.tokens, align 8
  %r1080.p = getelementptr inbounds [9 x i8], ptr @.str.106, i64 0, i64 0
  %r1080 = ptrtoint ptr %r1080.p to i64
  %r1081.p = getelementptr inbounds [2 x i8], ptr @.str.105, i64 0, i64 0
  %r1081 = ptrtoint ptr %r1081.p to i64
  %r1082 = load i64, ptr %slot.line, align 8
  %r1083 = load i64, ptr %slot.col, align 8
  %r1084.ptr = call ptr @nova_rt_struct_alloc(i64 32)
  %r1084.f0 = getelementptr i64, ptr %r1084.ptr, i64 0
  store i64 %r1080, ptr %r1084.f0, align 8
  %r1084.f1 = getelementptr i64, ptr %r1084.ptr, i64 1
  store i64 %r1081, ptr %r1084.f1, align 8
  %r1084.f2 = getelementptr i64, ptr %r1084.ptr, i64 2
  store i64 %r1082, ptr %r1084.f2, align 8
  %r1084.f3 = getelementptr i64, ptr %r1084.ptr, i64 3
  store i64 %r1083, ptr %r1084.f3, align 8
  %r1084 = ptrtoint ptr %r1084.ptr to i64
  %r1085 = call i64 @nova_rt_list_append(i64 %r1079, i64 %r1084)
  %r1086 = load i64, ptr %slot.pos, align 8
  %r1087 = add i64 1, 0
  %r1088 = add i64 %r1086, %r1087
  store i64 %r1088, ptr %slot.pos, align 8
  %r1089 = load i64, ptr %slot.col, align 8
  %r1090 = add i64 1, 0
  %r1091 = add i64 %r1089, %r1090
  store i64 %r1091, ptr %slot.col, align 8
  br label %endif188
else187:
  %r1092 = load i64, ptr %slot.pos, align 8
  %r1093 = add i64 1, 0
  %r1094 = add i64 %r1092, %r1093
  store i64 %r1094, ptr %slot.pos, align 8
  %r1095 = load i64, ptr %slot.col, align 8
  %r1096 = add i64 1, 0
  %r1097 = add i64 %r1095, %r1096
  store i64 %r1097, ptr %slot.col, align 8
  br label %endif188
endif188:
  br label %endif185
endif185:
  br label %endif182
endif182:
  br label %endif176
endif176:
  br label %endif173
endif173:
  br label %endif164
endif164:
  br label %endif155
endif155:
  br label %endif149
endif149:
  br label %endif140
endif140:
  br label %endif134
endif134:
  br label %endif128
endif128:
  br label %endif119
endif119:
  br label %endif110
endif110:
  br label %endif104
endif104:
  br label %endif98
endif98:
  br label %endif95
endif95:
  br label %endif92
endif92:
  br label %endif89
endif89:
  br label %endif80
endif80:
  br label %endif47
endif47:
  br label %endif32
endif32:
  br label %endif23
endif23:
  br label %endif20
endif20:
  br label %endif14
endif14:
  br label %endif8
endif8:
  br label %endif5
endif5:
  br label %while_hdr0
while_exit2:
  %r1098 = load i64, ptr %slot.tokens, align 8
  %r1099.p = getelementptr inbounds [4 x i8], ptr @.str.107, i64 0, i64 0
  %r1099 = ptrtoint ptr %r1099.p to i64
  %r1100.p = getelementptr inbounds [1 x i8], ptr @.str.42, i64 0, i64 0
  %r1100 = ptrtoint ptr %r1100.p to i64
  %r1101 = load i64, ptr %slot.line, align 8
  %r1102 = load i64, ptr %slot.col, align 8
  %r1103.ptr = call ptr @nova_rt_struct_alloc(i64 32)
  %r1103.f0 = getelementptr i64, ptr %r1103.ptr, i64 0
  store i64 %r1099, ptr %r1103.f0, align 8
  %r1103.f1 = getelementptr i64, ptr %r1103.ptr, i64 1
  store i64 %r1100, ptr %r1103.f1, align 8
  %r1103.f2 = getelementptr i64, ptr %r1103.ptr, i64 2
  store i64 %r1101, ptr %r1103.f2, align 8
  %r1103.f3 = getelementptr i64, ptr %r1103.ptr, i64 3
  store i64 %r1102, ptr %r1103.f3, align 8
  %r1103 = ptrtoint ptr %r1103.ptr to i64
  %r1104 = call i64 @nova_rt_list_append(i64 %r1098, i64 %r1103)
  %r1105 = load i64, ptr %slot.tokens, align 8
  ret i64 0
}

define i64 @tok_at(i64 %p0, i64 %p1) nounwind {
entry:
  %slot.tokens = alloca i64, align 8
  store i64 %p0, ptr %slot.tokens, align 8
  %slot.pos = alloca i64, align 8
  store i64 %p1, ptr %slot.pos, align 8
  %r0 = load i64, ptr %slot.tokens, align 8
  %r1 = load i64, ptr %slot.pos, align 8
  %r2 = call i64 @nova_rt_index_get(i64 %r0, i64 %r1)
  ret i64 0
}

define i64 @tk(i64 %p0, i64 %p1) nounwind {
entry:
  %slot.tokens = alloca i64, align 8
  store i64 %p0, ptr %slot.tokens, align 8
  %slot.pos = alloca i64, align 8
  store i64 %p1, ptr %slot.pos, align 8
  ret i64 0
}

define i64 @tv(i64 %p0, i64 %p1) nounwind {
entry:
  %slot.tokens = alloca i64, align 8
  store i64 %p0, ptr %slot.tokens, align 8
  %slot.pos = alloca i64, align 8
  store i64 %p1, ptr %slot.pos, align 8
  ret i64 0
}

define i64 @skip_nl(i64 %p0, i64 %p1) nounwind {
entry:
  %slot.tokens = alloca i64, align 8
  store i64 %p0, ptr %slot.tokens, align 8
  %slot.pos = alloca i64, align 8
  store i64 %p1, ptr %slot.pos, align 8
  br label %while_hdr189
while_hdr189:
  %r0 = load i64, ptr %slot.tokens, align 8
  %r1 = load i64, ptr %slot.pos, align 8
  %r2 = call i64 @tk(i64 %r0, i64 %r1)
  %r3.p = getelementptr inbounds [8 x i8], ptr @.str.37, i64 0, i64 0
  %r3 = ptrtoint ptr %r3.p to i64
  %r4 = call i64 @nova_rt_eq(i64 %r2, i64 %r3)
  %br_while_body190 = icmp ne i64 %r4, 0
  br i1 %br_while_body190, label %while_body190, label %while_exit191
while_body190:
  %r5 = load i64, ptr %slot.pos, align 8
  %r6 = add i64 1, 0
  %r7 = call i64 @nova_rt_add(i64 %r5, i64 %r6)
  store i64 %r7, ptr %slot.pos, align 8
  br label %while_hdr189
while_exit191:
  %r8 = load i64, ptr %slot.pos, align 8
  ret i64 0
}

define i64 @tok_line(i64 %p0, i64 %p1) nounwind {
entry:
  %slot.tokens = alloca i64, align 8
  store i64 %p0, ptr %slot.tokens, align 8
  %slot.pos = alloca i64, align 8
  store i64 %p1, ptr %slot.pos, align 8
  ret i64 0
}

define i64 @tok_col(i64 %p0, i64 %p1) nounwind {
entry:
  %slot.tokens = alloca i64, align 8
  store i64 %p0, ptr %slot.tokens, align 8
  %slot.pos = alloca i64, align 8
  store i64 %p1, ptr %slot.pos, align 8
  ret i64 0
}

define i64 @expect(i64 %p0, i64 %p1, i64 %p2) nounwind {
entry:
  %slot.tokens = alloca i64, align 8
  store i64 %p0, ptr %slot.tokens, align 8
  %slot.pos = alloca i64, align 8
  store i64 %p1, ptr %slot.pos, align 8
  %slot.expected_val = alloca i64, align 8
  store i64 %p2, ptr %slot.expected_val, align 8
  %r0 = load i64, ptr %slot.tokens, align 8
  %r1 = load i64, ptr %slot.pos, align 8
  %r2 = call i64 @tv(i64 %r0, i64 %r1)
  %r3 = load i64, ptr %slot.expected_val, align 8
  %r4 = call i64 @nova_rt_eq(i64 %r2, i64 %r3)
  %r5.p = getelementptr inbounds [11 x i8], ptr @.str.108, i64 0, i64 0
  %r5 = ptrtoint ptr %r5.p to i64
  %r6 = load i64, ptr %slot.expected_val, align 8
  %r7 = call i64 @nova_rt_str_concat(i64 %r5, i64 %r6)
  %r8.p = getelementptr inbounds [8 x i8], ptr @.str.109, i64 0, i64 0
  %r8 = ptrtoint ptr %r8.p to i64
  %r9 = call i64 @nova_rt_str_concat(i64 %r7, i64 %r8)
  %r10 = load i64, ptr %slot.tokens, align 8
  %r11 = load i64, ptr %slot.pos, align 8
  %r12 = call i64 @tv(i64 %r10, i64 %r11)
  %r13 = call i64 @nova_rt_str_concat(i64 %r9, i64 %r12)
  %r14.p = getelementptr inbounds [11 x i8], ptr @.str.110, i64 0, i64 0
  %r14 = ptrtoint ptr %r14.p to i64
  %r15 = call i64 @nova_rt_str_concat(i64 %r13, i64 %r14)
  %r16 = load i64, ptr %slot.tokens, align 8
  %r17 = load i64, ptr %slot.pos, align 8
  %r18 = call i64 @tok_line(i64 %r16, i64 %r17)
  %r19 = call i64 @nova_rt_int_to_str(i64 %r18)
  %r20 = call i64 @nova_rt_str_concat(i64 %r15, i64 %r19)
  %r21 = call i64 @nova_rt_assert(i64 %r4, i64 %r20)
  %r22 = load i64, ptr %slot.pos, align 8
  %r23 = add i64 1, 0
  %r24 = call i64 @nova_rt_add(i64 %r22, i64 %r23)
  ret i64 0
}

define i64 @prefix_bp(i64 %p0) nounwind {
entry:
  %slot.op = alloca i64, align 8
  store i64 %p0, ptr %slot.op, align 8
  %r0 = load i64, ptr %slot.op, align 8
  %r1.p = getelementptr inbounds [2 x i8], ptr @.str.77, i64 0, i64 0
  %r1 = ptrtoint ptr %r1.p to i64
  %r2 = call i64 @nova_rt_eq(i64 %r0, i64 %r1)
  %r3 = load i64, ptr %slot.op, align 8
  %r4.p = getelementptr inbounds [4 x i8], ptr @.str.21, i64 0, i64 0
  %r4 = ptrtoint ptr %r4.p to i64
  %r5 = call i64 @nova_rt_eq(i64 %r3, i64 %r4)
  %r6.cmp = icmp ne i64 %r2, 0
  %r6.cmp2 = icmp ne i64 %r5, 0
  %r6.or = or i1 %r6.cmp, %r6.cmp2
  %r6 = zext i1 %r6.or to i64
  %r7 = load i64, ptr %slot.op, align 8
  %r8.p = getelementptr inbounds [2 x i8], ptr @.str.104, i64 0, i64 0
  %r8 = ptrtoint ptr %r8.p to i64
  %r9 = call i64 @nova_rt_eq(i64 %r7, i64 %r8)
  %r10.cmp = icmp ne i64 %r6, 0
  %r10.cmp2 = icmp ne i64 %r9, 0
  %r10.or = or i1 %r10.cmp, %r10.cmp2
  %r10 = zext i1 %r10.or to i64
  %br_then192 = icmp ne i64 %r10, 0
  br i1 %br_then192, label %then192, label %else193
then192:
  %r11 = add i64 27, 0
  br label %endif194
else193:
  %r12 = add i64 0, 0
  br label %endif194
endif194:
  ret i64 0
}

define i64 @infix_bp(i64 %p0) nounwind {
entry:
  %slot.op = alloca i64, align 8
  store i64 %p0, ptr %slot.op, align 8
  %r0 = load i64, ptr %slot.op, align 8
  %r1.p = getelementptr inbounds [3 x i8], ptr @.str.19, i64 0, i64 0
  %r1 = ptrtoint ptr %r1.p to i64
  %r2 = call i64 @nova_rt_eq(i64 %r0, i64 %r1)
  %br_then195 = icmp ne i64 %r2, 0
  br i1 %br_then195, label %then195, label %else196
then195:
  %r4 = add i64 3, 0
  %r5 = add i64 4, 0
  %r3 = call i64 @nova_rt_list_create()
  call i64 @nova_rt_list_append(i64 %r3, i64 %r4)
  call i64 @nova_rt_list_append(i64 %r3, i64 %r5)
  br label %endif197
else196:
  %r6 = load i64, ptr %slot.op, align 8
  %r7.p = getelementptr inbounds [4 x i8], ptr @.str.20, i64 0, i64 0
  %r7 = ptrtoint ptr %r7.p to i64
  %r8 = call i64 @nova_rt_eq(i64 %r6, i64 %r7)
  %br_then198 = icmp ne i64 %r8, 0
  br i1 %br_then198, label %then198, label %else199
then198:
  %r10 = add i64 5, 0
  %r11 = add i64 6, 0
  %r9 = call i64 @nova_rt_list_create()
  call i64 @nova_rt_list_append(i64 %r9, i64 %r10)
  call i64 @nova_rt_list_append(i64 %r9, i64 %r11)
  br label %endif200
else199:
  %r12 = load i64, ptr %slot.op, align 8
  %r13.p = getelementptr inbounds [2 x i8], ptr @.str.100, i64 0, i64 0
  %r13 = ptrtoint ptr %r13.p to i64
  %r14 = call i64 @nova_rt_eq(i64 %r12, i64 %r13)
  %br_then201 = icmp ne i64 %r14, 0
  br i1 %br_then201, label %then201, label %else202
then201:
  %r16 = add i64 7, 0
  %r17 = add i64 8, 0
  %r15 = call i64 @nova_rt_list_create()
  call i64 @nova_rt_list_append(i64 %r15, i64 %r16)
  call i64 @nova_rt_list_append(i64 %r15, i64 %r17)
  br label %endif203
else202:
  %r18 = load i64, ptr %slot.op, align 8
  %r19.p = getelementptr inbounds [2 x i8], ptr @.str.103, i64 0, i64 0
  %r19 = ptrtoint ptr %r19.p to i64
  %r20 = call i64 @nova_rt_eq(i64 %r18, i64 %r19)
  %br_then204 = icmp ne i64 %r20, 0
  br i1 %br_then204, label %then204, label %else205
then204:
  %r22 = add i64 9, 0
  %r23 = add i64 10, 0
  %r21 = call i64 @nova_rt_list_create()
  call i64 @nova_rt_list_append(i64 %r21, i64 %r22)
  call i64 @nova_rt_list_append(i64 %r21, i64 %r23)
  br label %endif206
else205:
  %r24 = load i64, ptr %slot.op, align 8
  %r25.p = getelementptr inbounds [2 x i8], ptr @.str.99, i64 0, i64 0
  %r25 = ptrtoint ptr %r25.p to i64
  %r26 = call i64 @nova_rt_eq(i64 %r24, i64 %r25)
  %br_then207 = icmp ne i64 %r26, 0
  br i1 %br_then207, label %then207, label %else208
then207:
  %r28 = add i64 11, 0
  %r29 = add i64 12, 0
  %r27 = call i64 @nova_rt_list_create()
  call i64 @nova_rt_list_append(i64 %r27, i64 %r28)
  call i64 @nova_rt_list_append(i64 %r27, i64 %r29)
  br label %endif209
else208:
  %r30 = load i64, ptr %slot.op, align 8
  %r31.p = getelementptr inbounds [3 x i8], ptr @.str.88, i64 0, i64 0
  %r31 = ptrtoint ptr %r31.p to i64
  %r32 = call i64 @nova_rt_eq(i64 %r30, i64 %r31)
  %r33 = load i64, ptr %slot.op, align 8
  %r34.p = getelementptr inbounds [3 x i8], ptr @.str.93, i64 0, i64 0
  %r34 = ptrtoint ptr %r34.p to i64
  %r35 = call i64 @nova_rt_eq(i64 %r33, i64 %r34)
  %r36.cmp = icmp ne i64 %r32, 0
  %r36.cmp2 = icmp ne i64 %r35, 0
  %r36.or = or i1 %r36.cmp, %r36.cmp2
  %r36 = zext i1 %r36.or to i64
  %r37 = load i64, ptr %slot.op, align 8
  %r38.p = getelementptr inbounds [8 x i8], ptr @.str.33, i64 0, i64 0
  %r38 = ptrtoint ptr %r38.p to i64
  %r39 = call i64 @nova_rt_eq(i64 %r37, i64 %r38)
  %r40.cmp = icmp ne i64 %r36, 0
  %r40.cmp2 = icmp ne i64 %r39, 0
  %r40.or = or i1 %r40.cmp, %r40.cmp2
  %r40 = zext i1 %r40.or to i64
  %br_then210 = icmp ne i64 %r40, 0
  br i1 %br_then210, label %then210, label %else211
then210:
  %r42 = add i64 13, 0
  %r43 = add i64 14, 0
  %r41 = call i64 @nova_rt_list_create()
  call i64 @nova_rt_list_append(i64 %r41, i64 %r42)
  call i64 @nova_rt_list_append(i64 %r41, i64 %r43)
  br label %endif212
else211:
  %r44 = load i64, ptr %slot.op, align 8
  %r45.p = getelementptr inbounds [2 x i8], ptr @.str.94, i64 0, i64 0
  %r45 = ptrtoint ptr %r45.p to i64
  %r46 = call i64 @nova_rt_eq(i64 %r44, i64 %r45)
  %r47 = load i64, ptr %slot.op, align 8
  %r48.p = getelementptr inbounds [2 x i8], ptr @.str.78, i64 0, i64 0
  %r48 = ptrtoint ptr %r48.p to i64
  %r49 = call i64 @nova_rt_eq(i64 %r47, i64 %r48)
  %r50.cmp = icmp ne i64 %r46, 0
  %r50.cmp2 = icmp ne i64 %r49, 0
  %r50.or = or i1 %r50.cmp, %r50.cmp2
  %r50 = zext i1 %r50.or to i64
  %r51 = load i64, ptr %slot.op, align 8
  %r52.p = getelementptr inbounds [3 x i8], ptr @.str.95, i64 0, i64 0
  %r52 = ptrtoint ptr %r52.p to i64
  %r53 = call i64 @nova_rt_eq(i64 %r51, i64 %r52)
  %r54.cmp = icmp ne i64 %r50, 0
  %r54.cmp2 = icmp ne i64 %r53, 0
  %r54.or = or i1 %r54.cmp, %r54.cmp2
  %r54 = zext i1 %r54.or to i64
  %r55 = load i64, ptr %slot.op, align 8
  %r56.p = getelementptr inbounds [3 x i8], ptr @.str.97, i64 0, i64 0
  %r56 = ptrtoint ptr %r56.p to i64
  %r57 = call i64 @nova_rt_eq(i64 %r55, i64 %r56)
  %r58.cmp = icmp ne i64 %r54, 0
  %r58.cmp2 = icmp ne i64 %r57, 0
  %r58.or = or i1 %r58.cmp, %r58.cmp2
  %r58 = zext i1 %r58.or to i64
  %r59 = load i64, ptr %slot.op, align 8
  %r60.p = getelementptr inbounds [3 x i8], ptr @.str.27, i64 0, i64 0
  %r60 = ptrtoint ptr %r60.p to i64
  %r61 = call i64 @nova_rt_eq(i64 %r59, i64 %r60)
  %r62.cmp = icmp ne i64 %r58, 0
  %r62.cmp2 = icmp ne i64 %r61, 0
  %r62.or = or i1 %r62.cmp, %r62.cmp2
  %r62 = zext i1 %r62.or to i64
  %br_then213 = icmp ne i64 %r62, 0
  br i1 %br_then213, label %then213, label %else214
then213:
  %r64 = add i64 15, 0
  %r65 = add i64 16, 0
  %r63 = call i64 @nova_rt_list_create()
  call i64 @nova_rt_list_append(i64 %r63, i64 %r64)
  call i64 @nova_rt_list_append(i64 %r63, i64 %r65)
  br label %endif215
else214:
  %r66 = load i64, ptr %slot.op, align 8
  %r67.p = getelementptr inbounds [3 x i8], ptr @.str.96, i64 0, i64 0
  %r67 = ptrtoint ptr %r67.p to i64
  %r68 = call i64 @nova_rt_eq(i64 %r66, i64 %r67)
  %r69 = load i64, ptr %slot.op, align 8
  %r70.p = getelementptr inbounds [3 x i8], ptr @.str.98, i64 0, i64 0
  %r70 = ptrtoint ptr %r70.p to i64
  %r71 = call i64 @nova_rt_eq(i64 %r69, i64 %r70)
  %r72.cmp = icmp ne i64 %r68, 0
  %r72.cmp2 = icmp ne i64 %r71, 0
  %r72.or = or i1 %r72.cmp, %r72.cmp2
  %r72 = zext i1 %r72.or to i64
  %br_then216 = icmp ne i64 %r72, 0
  br i1 %br_then216, label %then216, label %else217
then216:
  %r74 = add i64 17, 0
  %r75 = add i64 18, 0
  %r73 = call i64 @nova_rt_list_create()
  call i64 @nova_rt_list_append(i64 %r73, i64 %r74)
  call i64 @nova_rt_list_append(i64 %r73, i64 %r75)
  br label %endif218
else217:
  %r76 = load i64, ptr %slot.op, align 8
  %r77.p = getelementptr inbounds [2 x i8], ptr @.str.73, i64 0, i64 0
  %r77 = ptrtoint ptr %r77.p to i64
  %r78 = call i64 @nova_rt_eq(i64 %r76, i64 %r77)
  %r79 = load i64, ptr %slot.op, align 8
  %r80.p = getelementptr inbounds [2 x i8], ptr @.str.77, i64 0, i64 0
  %r80 = ptrtoint ptr %r80.p to i64
  %r81 = call i64 @nova_rt_eq(i64 %r79, i64 %r80)
  %r82.cmp = icmp ne i64 %r78, 0
  %r82.cmp2 = icmp ne i64 %r81, 0
  %r82.or = or i1 %r82.cmp, %r82.cmp2
  %r82 = zext i1 %r82.or to i64
  %br_then219 = icmp ne i64 %r82, 0
  br i1 %br_then219, label %then219, label %else220
then219:
  %r84 = add i64 19, 0
  %r85 = add i64 20, 0
  %r83 = call i64 @nova_rt_list_create()
  call i64 @nova_rt_list_append(i64 %r83, i64 %r84)
  call i64 @nova_rt_list_append(i64 %r83, i64 %r85)
  br label %endif221
else220:
  %r86 = load i64, ptr %slot.op, align 8
  %r87.p = getelementptr inbounds [2 x i8], ptr @.str.82, i64 0, i64 0
  %r87 = ptrtoint ptr %r87.p to i64
  %r88 = call i64 @nova_rt_eq(i64 %r86, i64 %r87)
  %r89 = load i64, ptr %slot.op, align 8
  %r90.p = getelementptr inbounds [2 x i8], ptr @.str.39, i64 0, i64 0
  %r90 = ptrtoint ptr %r90.p to i64
  %r91 = call i64 @nova_rt_eq(i64 %r89, i64 %r90)
  %r92.cmp = icmp ne i64 %r88, 0
  %r92.cmp2 = icmp ne i64 %r91, 0
  %r92.or = or i1 %r92.cmp, %r92.cmp2
  %r92 = zext i1 %r92.or to i64
  %r93 = load i64, ptr %slot.op, align 8
  %r94.p = getelementptr inbounds [2 x i8], ptr @.str.86, i64 0, i64 0
  %r94 = ptrtoint ptr %r94.p to i64
  %r95 = call i64 @nova_rt_eq(i64 %r93, i64 %r94)
  %r96.cmp = icmp ne i64 %r92, 0
  %r96.cmp2 = icmp ne i64 %r95, 0
  %r96.or = or i1 %r96.cmp, %r96.cmp2
  %r96 = zext i1 %r96.or to i64
  %br_then222 = icmp ne i64 %r96, 0
  br i1 %br_then222, label %then222, label %else223
then222:
  %r98 = add i64 21, 0
  %r99 = add i64 22, 0
  %r97 = call i64 @nova_rt_list_create()
  call i64 @nova_rt_list_append(i64 %r97, i64 %r98)
  call i64 @nova_rt_list_append(i64 %r97, i64 %r99)
  br label %endif224
else223:
  %r100 = load i64, ptr %slot.op, align 8
  %r101.p = getelementptr inbounds [3 x i8], ptr @.str.83, i64 0, i64 0
  %r101 = ptrtoint ptr %r101.p to i64
  %r102 = call i64 @nova_rt_eq(i64 %r100, i64 %r101)
  %br_then225 = icmp ne i64 %r102, 0
  br i1 %br_then225, label %then225, label %else226
then225:
  %r104 = add i64 24, 0
  %r105 = add i64 23, 0
  %r103 = call i64 @nova_rt_list_create()
  call i64 @nova_rt_list_append(i64 %r103, i64 %r104)
  call i64 @nova_rt_list_append(i64 %r103, i64 %r105)
  br label %endif227
else226:
  %r107 = add i64 0, 0
  %r108 = add i64 0, 0
  %r106 = call i64 @nova_rt_list_create()
  call i64 @nova_rt_list_append(i64 %r106, i64 %r107)
  call i64 @nova_rt_list_append(i64 %r106, i64 %r108)
  br label %endif227
endif227:
  br label %endif224
endif224:
  br label %endif221
endif221:
  br label %endif218
endif218:
  br label %endif215
endif215:
  br label %endif212
endif212:
  br label %endif209
endif209:
  br label %endif206
endif206:
  br label %endif203
endif203:
  br label %endif200
endif200:
  br label %endif197
endif197:
  ret i64 0
}

define i64 @is_infix_op(i64 %p0, i64 %p1) nounwind {
entry:
  %slot.tokens = alloca i64, align 8
  store i64 %p0, ptr %slot.tokens, align 8
  %slot.pos = alloca i64, align 8
  store i64 %p1, ptr %slot.pos, align 8
  %slot.kind = alloca i64, align 8
  store i64 0, ptr %slot.kind, align 8
  %slot.val = alloca i64, align 8
  store i64 0, ptr %slot.val, align 8
  %slot.bp = alloca i64, align 8
  store i64 0, ptr %slot.bp, align 8
  %r0 = load i64, ptr %slot.tokens, align 8
  %r1 = load i64, ptr %slot.pos, align 8
  %r2 = call i64 @tk(i64 %r0, i64 %r1)
  store i64 %r2, ptr %slot.kind, align 8
  %r3 = load i64, ptr %slot.tokens, align 8
  %r4 = load i64, ptr %slot.pos, align 8
  %r5 = call i64 @tv(i64 %r3, i64 %r4)
  store i64 %r5, ptr %slot.val, align 8
  %r6 = load i64, ptr %slot.kind, align 8
  %r7.p = getelementptr inbounds [3 x i8], ptr @.str.75, i64 0, i64 0
  %r7 = ptrtoint ptr %r7.p to i64
  %r8 = call i64 @nova_rt_eq(i64 %r6, i64 %r7)
  %br_then228 = icmp ne i64 %r8, 0
  br i1 %br_then228, label %then228, label %else229
then228:
  %r9 = load i64, ptr %slot.val, align 8
  %r10 = call i64 @infix_bp(i64 %r9)
  store i64 %r10, ptr %slot.bp, align 8
  %r11 = load i64, ptr %slot.bp, align 8
  %r12 = add i64 0, 0
  %r13 = call i64 @nova_rt_index_get(i64 %r11, i64 %r12)
  %r14 = add i64 0, 0
  %r15.cmp = icmp sgt i64 %r13, %r14
  %r15 = zext i1 %r15.cmp to i64
  br label %endif230
else229:
  %r16 = load i64, ptr %slot.kind, align 8
  %r17.p = getelementptr inbounds [3 x i8], ptr @.str.43, i64 0, i64 0
  %r17 = ptrtoint ptr %r17.p to i64
  %r18 = call i64 @nova_rt_eq(i64 %r16, i64 %r17)
  %r19 = load i64, ptr %slot.val, align 8
  %r20.p = getelementptr inbounds [4 x i8], ptr @.str.20, i64 0, i64 0
  %r20 = ptrtoint ptr %r20.p to i64
  %r21 = call i64 @nova_rt_eq(i64 %r19, i64 %r20)
  %r22 = load i64, ptr %slot.val, align 8
  %r23.p = getelementptr inbounds [3 x i8], ptr @.str.19, i64 0, i64 0
  %r23 = ptrtoint ptr %r23.p to i64
  %r24 = call i64 @nova_rt_eq(i64 %r22, i64 %r23)
  %r25.cmp = icmp ne i64 %r21, 0
  %r25.cmp2 = icmp ne i64 %r24, 0
  %r25.or = or i1 %r25.cmp, %r25.cmp2
  %r25 = zext i1 %r25.or to i64
  %r26 = load i64, ptr %slot.val, align 8
  %r27.p = getelementptr inbounds [3 x i8], ptr @.str.27, i64 0, i64 0
  %r27 = ptrtoint ptr %r27.p to i64
  %r28 = call i64 @nova_rt_eq(i64 %r26, i64 %r27)
  %r29.cmp = icmp ne i64 %r25, 0
  %r29.cmp2 = icmp ne i64 %r28, 0
  %r29.or = or i1 %r29.cmp, %r29.cmp2
  %r29 = zext i1 %r29.or to i64
  %r30 = load i64, ptr %slot.val, align 8
  %r31.p = getelementptr inbounds [8 x i8], ptr @.str.33, i64 0, i64 0
  %r31 = ptrtoint ptr %r31.p to i64
  %r32 = call i64 @nova_rt_eq(i64 %r30, i64 %r31)
  %r33.cmp = icmp ne i64 %r29, 0
  %r33.cmp2 = icmp ne i64 %r32, 0
  %r33.or = or i1 %r33.cmp, %r33.cmp2
  %r33 = zext i1 %r33.or to i64
  %r34.cmp = icmp ne i64 %r18, 0
  %r34.cmp2 = icmp ne i64 %r33, 0
  %r34.and = and i1 %r34.cmp, %r34.cmp2
  %r34 = zext i1 %r34.and to i64
  %br_then231 = icmp ne i64 %r34, 0
  br i1 %br_then231, label %then231, label %else232
then231:
  %r35 = add i64 1, 0
  br label %endif233
else232:
  %r36 = add i64 0, 0
  br label %endif233
endif233:
  br label %endif230
endif230:
  ret i64 0
}

define i64 @get_infix_op(i64 %p0, i64 %p1) nounwind {
entry:
  %slot.tokens = alloca i64, align 8
  store i64 %p0, ptr %slot.tokens, align 8
  %slot.pos = alloca i64, align 8
  store i64 %p1, ptr %slot.pos, align 8
  %r0 = load i64, ptr %slot.tokens, align 8
  %r1 = load i64, ptr %slot.pos, align 8
  %r2 = call i64 @tv(i64 %r0, i64 %r1)
  ret i64 0
}

define i64 @null_expr() nounwind {
entry:
  %r0.p = getelementptr inbounds [5 x i8], ptr @.str.26, i64 0, i64 0
  %r0 = ptrtoint ptr %r0.p to i64
  %r1.p = getelementptr inbounds [1 x i8], ptr @.str.42, i64 0, i64 0
  %r1 = ptrtoint ptr %r1.p to i64
  %r2 = add i64 0, 0
  %r3 = call i64 @nova_rt_list_create()
  %r4 = call i64 @nova_rt_list_create()
  %r5.ptr = call ptr @nova_rt_struct_alloc(i64 40)
  %r5.f0 = getelementptr i64, ptr %r5.ptr, i64 0
  store i64 %r0, ptr %r5.f0, align 8
  %r5.f1 = getelementptr i64, ptr %r5.ptr, i64 1
  store i64 %r1, ptr %r5.f1, align 8
  %r5.f2 = getelementptr i64, ptr %r5.ptr, i64 2
  store i64 %r2, ptr %r5.f2, align 8
  %r5.f3 = getelementptr i64, ptr %r5.ptr, i64 3
  store i64 %r3, ptr %r5.f3, align 8
  %r5.f4 = getelementptr i64, ptr %r5.ptr, i64 4
  store i64 %r4, ptr %r5.f4, align 8
  %r5 = ptrtoint ptr %r5.ptr to i64
  ret i64 0
}

define i64 @parse_expr(i64 %p0, i64 %p1, i64 %p2) nounwind {
entry:
  %slot.tokens = alloca i64, align 8
  store i64 %p0, ptr %slot.tokens, align 8
  %slot.pos = alloca i64, align 8
  store i64 %p1, ptr %slot.pos, align 8
  %slot.min_bp = alloca i64, align 8
  store i64 %p2, ptr %slot.min_bp, align 8
  %slot.left_r = alloca i64, align 8
  store i64 0, ptr %slot.left_r, align 8
  %slot.left = alloca i64, align 8
  store i64 0, ptr %slot.left, align 8
  %slot.cur = alloca i64, align 8
  store i64 0, ptr %slot.cur, align 8
  %slot.call_r = alloca i64, align 8
  store i64 0, ptr %slot.call_r, align 8
  %slot.idx_r = alloca i64, align 8
  store i64 0, ptr %slot.idx_r, align 8
  %slot.member_name = alloca i64, align 8
  store i64 0, ptr %slot.member_name, align 8
  %slot.method_r = alloca i64, align 8
  store i64 0, ptr %slot.method_r, align 8
  %slot.op = alloca i64, align 8
  store i64 0, ptr %slot.op, align 8
  %slot.bp = alloca i64, align 8
  store i64 0, ptr %slot.bp, align 8
  %slot.lbp = alloca i64, align 8
  store i64 0, ptr %slot.lbp, align 8
  %slot.rbp = alloca i64, align 8
  store i64 0, ptr %slot.rbp, align 8
  %slot.right_r = alloca i64, align 8
  store i64 0, ptr %slot.right_r, align 8
  %r0 = load i64, ptr %slot.tokens, align 8
  %r1 = load i64, ptr %slot.pos, align 8
  %r2 = call i64 @parse_prefix(i64 %r0, i64 %r1)
  store i64 %r2, ptr %slot.left_r, align 8
  %r3 = add i64 0, 0
  store i64 %r3, ptr %slot.left, align 8
  %r4 = add i64 0, 0
  store i64 %r4, ptr %slot.cur, align 8
  br label %while_hdr234
while_hdr234:
  %r5 = load i64, ptr %slot.cur, align 8
  %r6 = load i64, ptr %slot.tokens, align 8
  %r7 = call i64 @nova_rt_len_any(i64 %r6)
  %r8.cmp = icmp slt i64 %r5, %r7
  %r8 = zext i1 %r8.cmp to i64
  %r9 = load i64, ptr %slot.tokens, align 8
  %r10 = load i64, ptr %slot.cur, align 8
  %r11 = call i64 @tk(i64 %r9, i64 %r10)
  %r12.p = getelementptr inbounds [4 x i8], ptr @.str.107, i64 0, i64 0
  %r12 = ptrtoint ptr %r12.p to i64
  %r13 = call i64 @nova_rt_neq(i64 %r11, i64 %r12)
  %r14.cmp = icmp ne i64 %r8, 0
  %r14.cmp2 = icmp ne i64 %r13, 0
  %r14.and = and i1 %r14.cmp, %r14.cmp2
  %r14 = zext i1 %r14.and to i64
  %r15 = load i64, ptr %slot.tokens, align 8
  %r16 = load i64, ptr %slot.cur, align 8
  %r17 = call i64 @tk(i64 %r15, i64 %r16)
  %r18.p = getelementptr inbounds [8 x i8], ptr @.str.37, i64 0, i64 0
  %r18 = ptrtoint ptr %r18.p to i64
  %r19 = call i64 @nova_rt_neq(i64 %r17, i64 %r18)
  %r20.cmp = icmp ne i64 %r14, 0
  %r20.cmp2 = icmp ne i64 %r19, 0
  %r20.and = and i1 %r20.cmp, %r20.cmp2
  %r20 = zext i1 %r20.and to i64
  %br_while_body235 = icmp ne i64 %r20, 0
  br i1 %br_while_body235, label %while_body235, label %while_exit236
while_body235:
  %r21 = load i64, ptr %slot.tokens, align 8
  %r22 = load i64, ptr %slot.cur, align 8
  %r23 = call i64 @tk(i64 %r21, i64 %r22)
  %r24.p = getelementptr inbounds [6 x i8], ptr @.str.65, i64 0, i64 0
  %r24 = ptrtoint ptr %r24.p to i64
  %r25 = call i64 @nova_rt_eq(i64 %r23, i64 %r24)
  %r26 = load i64, ptr %slot.tokens, align 8
  %r27 = load i64, ptr %slot.cur, align 8
  %r28 = call i64 @tv(i64 %r26, i64 %r27)
  %r29.p = getelementptr inbounds [2 x i8], ptr @.str.59, i64 0, i64 0
  %r29 = ptrtoint ptr %r29.p to i64
  %r30 = call i64 @nova_rt_eq(i64 %r28, i64 %r29)
  %r31.cmp = icmp ne i64 %r25, 0
  %r31.cmp2 = icmp ne i64 %r30, 0
  %r31.and = and i1 %r31.cmp, %r31.cmp2
  %r31 = zext i1 %r31.and to i64
  %br_then237 = icmp ne i64 %r31, 0
  br i1 %br_then237, label %then237, label %else238
then237:
  %r32 = load i64, ptr %slot.tokens, align 8
  %r33 = load i64, ptr %slot.cur, align 8
  %r34 = load i64, ptr %slot.left, align 8
  %r35 = call i64 @parse_call_args(i64 %r32, i64 %r33, i64 %r34)
  store i64 %r35, ptr %slot.call_r, align 8
  %r36 = add i64 0, 0
  store i64 %r36, ptr %slot.left, align 8
  %r37 = add i64 0, 0
  store i64 %r37, ptr %slot.cur, align 8
  br label %endif239
else238:
  %r38 = load i64, ptr %slot.tokens, align 8
  %r39 = load i64, ptr %slot.cur, align 8
  %r40 = call i64 @tk(i64 %r38, i64 %r39)
  %r41.p = getelementptr inbounds [6 x i8], ptr @.str.65, i64 0, i64 0
  %r41 = ptrtoint ptr %r41.p to i64
  %r42 = call i64 @nova_rt_eq(i64 %r40, i64 %r41)
  %r43 = load i64, ptr %slot.tokens, align 8
  %r44 = load i64, ptr %slot.cur, align 8
  %r45 = call i64 @tv(i64 %r43, i64 %r44)
  %r46.p = getelementptr inbounds [2 x i8], ptr @.str.61, i64 0, i64 0
  %r46 = ptrtoint ptr %r46.p to i64
  %r47 = call i64 @nova_rt_eq(i64 %r45, i64 %r46)
  %r48.cmp = icmp ne i64 %r42, 0
  %r48.cmp2 = icmp ne i64 %r47, 0
  %r48.and = and i1 %r48.cmp, %r48.cmp2
  %r48 = zext i1 %r48.and to i64
  %br_then240 = icmp ne i64 %r48, 0
  br i1 %br_then240, label %then240, label %else241
then240:
  %r49 = load i64, ptr %slot.tokens, align 8
  %r50 = load i64, ptr %slot.cur, align 8
  %r51 = load i64, ptr %slot.left, align 8
  %r52 = call i64 @parse_index(i64 %r49, i64 %r50, i64 %r51)
  store i64 %r52, ptr %slot.idx_r, align 8
  %r53 = add i64 0, 0
  store i64 %r53, ptr %slot.left, align 8
  %r54 = add i64 0, 0
  store i64 %r54, ptr %slot.cur, align 8
  br label %endif242
else241:
  %r55 = load i64, ptr %slot.tokens, align 8
  %r56 = load i64, ptr %slot.cur, align 8
  %r57 = call i64 @tk(i64 %r55, i64 %r56)
  %r58.p = getelementptr inbounds [4 x i8], ptr @.str.72, i64 0, i64 0
  %r58 = ptrtoint ptr %r58.p to i64
  %r59 = call i64 @nova_rt_eq(i64 %r57, i64 %r58)
  %br_then243 = icmp ne i64 %r59, 0
  br i1 %br_then243, label %then243, label %else244
then243:
  %r60 = load i64, ptr %slot.cur, align 8
  %r61 = add i64 1, 0
  %r62 = add i64 %r60, %r61
  store i64 %r62, ptr %slot.cur, align 8
  %r63 = load i64, ptr %slot.tokens, align 8
  %r64 = load i64, ptr %slot.cur, align 8
  %r65 = call i64 @tv(i64 %r63, i64 %r64)
  store i64 %r65, ptr %slot.member_name, align 8
  %r66 = load i64, ptr %slot.cur, align 8
  %r67 = add i64 1, 0
  %r68 = add i64 %r66, %r67
  store i64 %r68, ptr %slot.cur, align 8
  %r69 = load i64, ptr %slot.cur, align 8
  %r70 = load i64, ptr %slot.tokens, align 8
  %r71 = call i64 @nova_rt_len_any(i64 %r70)
  %r72.cmp = icmp slt i64 %r69, %r71
  %r72 = zext i1 %r72.cmp to i64
  %r73 = load i64, ptr %slot.tokens, align 8
  %r74 = load i64, ptr %slot.cur, align 8
  %r75 = call i64 @tk(i64 %r73, i64 %r74)
  %r76.p = getelementptr inbounds [6 x i8], ptr @.str.65, i64 0, i64 0
  %r76 = ptrtoint ptr %r76.p to i64
  %r77 = call i64 @nova_rt_eq(i64 %r75, i64 %r76)
  %r78.cmp = icmp ne i64 %r72, 0
  %r78.cmp2 = icmp ne i64 %r77, 0
  %r78.and = and i1 %r78.cmp, %r78.cmp2
  %r78 = zext i1 %r78.and to i64
  %r79 = load i64, ptr %slot.tokens, align 8
  %r80 = load i64, ptr %slot.cur, align 8
  %r81 = call i64 @tv(i64 %r79, i64 %r80)
  %r82.p = getelementptr inbounds [2 x i8], ptr @.str.59, i64 0, i64 0
  %r82 = ptrtoint ptr %r82.p to i64
  %r83 = call i64 @nova_rt_eq(i64 %r81, i64 %r82)
  %r84.cmp = icmp ne i64 %r78, 0
  %r84.cmp2 = icmp ne i64 %r83, 0
  %r84.and = and i1 %r84.cmp, %r84.cmp2
  %r84 = zext i1 %r84.and to i64
  %br_then246 = icmp ne i64 %r84, 0
  br i1 %br_then246, label %then246, label %else247
then246:
  %r85 = load i64, ptr %slot.tokens, align 8
  %r86 = load i64, ptr %slot.cur, align 8
  %r87.p = getelementptr inbounds [7 x i8], ptr @.str.111, i64 0, i64 0
  %r87 = ptrtoint ptr %r87.p to i64
  %r88 = load i64, ptr %slot.member_name, align 8
  %r89 = add i64 0, 0
  %r91 = load i64, ptr %slot.left, align 8
  %r90 = call i64 @nova_rt_list_create()
  call i64 @nova_rt_list_append(i64 %r90, i64 %r91)
  %r92 = call i64 @nova_rt_list_create()
  %r93.ptr = call ptr @nova_rt_struct_alloc(i64 40)
  %r93.f0 = getelementptr i64, ptr %r93.ptr, i64 0
  store i64 %r87, ptr %r93.f0, align 8
  %r93.f1 = getelementptr i64, ptr %r93.ptr, i64 1
  store i64 %r88, ptr %r93.f1, align 8
  %r93.f2 = getelementptr i64, ptr %r93.ptr, i64 2
  store i64 %r89, ptr %r93.f2, align 8
  %r93.f3 = getelementptr i64, ptr %r93.ptr, i64 3
  store i64 %r90, ptr %r93.f3, align 8
  %r93.f4 = getelementptr i64, ptr %r93.ptr, i64 4
  store i64 %r92, ptr %r93.f4, align 8
  %r93 = ptrtoint ptr %r93.ptr to i64
  %r94 = call i64 @parse_call_args(i64 %r85, i64 %r86, i64 %r93)
  store i64 %r94, ptr %slot.method_r, align 8
  %r95 = add i64 0, 0
  store i64 %r95, ptr %slot.left, align 8
  %r96 = add i64 0, 0
  store i64 %r96, ptr %slot.cur, align 8
  br label %endif248
else247:
  %r97.p = getelementptr inbounds [7 x i8], ptr @.str.111, i64 0, i64 0
  %r97 = ptrtoint ptr %r97.p to i64
  %r98 = load i64, ptr %slot.member_name, align 8
  %r99 = add i64 0, 0
  %r101 = load i64, ptr %slot.left, align 8
  %r100 = call i64 @nova_rt_list_create()
  call i64 @nova_rt_list_append(i64 %r100, i64 %r101)
  %r102 = call i64 @nova_rt_list_create()
  %r103.ptr = call ptr @nova_rt_struct_alloc(i64 40)
  %r103.f0 = getelementptr i64, ptr %r103.ptr, i64 0
  store i64 %r97, ptr %r103.f0, align 8
  %r103.f1 = getelementptr i64, ptr %r103.ptr, i64 1
  store i64 %r98, ptr %r103.f1, align 8
  %r103.f2 = getelementptr i64, ptr %r103.ptr, i64 2
  store i64 %r99, ptr %r103.f2, align 8
  %r103.f3 = getelementptr i64, ptr %r103.ptr, i64 3
  store i64 %r100, ptr %r103.f3, align 8
  %r103.f4 = getelementptr i64, ptr %r103.ptr, i64 4
  store i64 %r102, ptr %r103.f4, align 8
  %r103 = ptrtoint ptr %r103.ptr to i64
  store i64 %r103, ptr %slot.left, align 8
  br label %endif248
endif248:
  br label %endif245
else244:
  %r104 = load i64, ptr %slot.tokens, align 8
  %r105 = load i64, ptr %slot.cur, align 8
  %r106 = call i64 @is_infix_op(i64 %r104, i64 %r105)
  %br_then249 = icmp ne i64 %r106, 0
  br i1 %br_then249, label %then249, label %else250
then249:
  %r107 = load i64, ptr %slot.tokens, align 8
  %r108 = load i64, ptr %slot.cur, align 8
  %r109 = call i64 @get_infix_op(i64 %r107, i64 %r108)
  store i64 %r109, ptr %slot.op, align 8
  %r110 = load i64, ptr %slot.op, align 8
  %r111 = call i64 @infix_bp(i64 %r110)
  store i64 %r111, ptr %slot.bp, align 8
  %r112 = load i64, ptr %slot.bp, align 8
  %r113 = add i64 0, 0
  %r114 = call i64 @nova_rt_index_get(i64 %r112, i64 %r113)
  store i64 %r114, ptr %slot.lbp, align 8
  %r115 = load i64, ptr %slot.bp, align 8
  %r116 = add i64 1, 0
  %r117 = call i64 @nova_rt_index_get(i64 %r115, i64 %r116)
  store i64 %r117, ptr %slot.rbp, align 8
  %r118 = load i64, ptr %slot.lbp, align 8
  %r119 = load i64, ptr %slot.min_bp, align 8
  %r120.cmp = icmp slt i64 %r118, %r119
  %r120 = zext i1 %r120.cmp to i64
  %br_then252 = icmp ne i64 %r120, 0
  br i1 %br_then252, label %then252, label %else253
then252:
  br label %endif254
else253:
  br label %endif254
endif254:
  %r121 = load i64, ptr %slot.cur, align 8
  %r122 = add i64 1, 0
  %r123 = add i64 %r121, %r122
  store i64 %r123, ptr %slot.cur, align 8
  %r124 = load i64, ptr %slot.tokens, align 8
  %r125 = load i64, ptr %slot.cur, align 8
  %r126 = load i64, ptr %slot.rbp, align 8
  %r127 = call i64 @parse_expr(i64 %r124, i64 %r125, i64 %r126)
  store i64 %r127, ptr %slot.right_r, align 8
  %r128.p = getelementptr inbounds [6 x i8], ptr @.str.112, i64 0, i64 0
  %r128 = ptrtoint ptr %r128.p to i64
  %r129 = load i64, ptr %slot.op, align 8
  %r130 = add i64 0, 0
  %r132 = load i64, ptr %slot.left, align 8
  %r133 = add i64 0, 0
  %r131 = call i64 @nova_rt_list_create()
  call i64 @nova_rt_list_append(i64 %r131, i64 %r132)
  call i64 @nova_rt_list_append(i64 %r131, i64 %r133)
  %r134 = call i64 @nova_rt_list_create()
  %r135.ptr = call ptr @nova_rt_struct_alloc(i64 40)
  %r135.f0 = getelementptr i64, ptr %r135.ptr, i64 0
  store i64 %r128, ptr %r135.f0, align 8
  %r135.f1 = getelementptr i64, ptr %r135.ptr, i64 1
  store i64 %r129, ptr %r135.f1, align 8
  %r135.f2 = getelementptr i64, ptr %r135.ptr, i64 2
  store i64 %r130, ptr %r135.f2, align 8
  %r135.f3 = getelementptr i64, ptr %r135.ptr, i64 3
  store i64 %r131, ptr %r135.f3, align 8
  %r135.f4 = getelementptr i64, ptr %r135.ptr, i64 4
  store i64 %r134, ptr %r135.f4, align 8
  %r135 = ptrtoint ptr %r135.ptr to i64
  store i64 %r135, ptr %slot.left, align 8
  %r136 = add i64 0, 0
  store i64 %r136, ptr %slot.cur, align 8
  br label %endif251
else250:
  br label %endif251
endif251:
  br label %endif245
endif245:
  br label %endif242
endif242:
  br label %endif239
endif239:
  br label %while_hdr234
while_exit236:
  %r137 = load i64, ptr %slot.left, align 8
  %r138 = load i64, ptr %slot.cur, align 8
  %r139.ptr = call ptr @nova_rt_struct_alloc(i64 16)
  %r139.f0 = getelementptr i64, ptr %r139.ptr, i64 0
  store i64 %r137, ptr %r139.f0, align 8
  %r139.f1 = getelementptr i64, ptr %r139.ptr, i64 1
  store i64 %r138, ptr %r139.f1, align 8
  %r139 = ptrtoint ptr %r139.ptr to i64
  ret i64 0
}

define i64 @parse_prefix(i64 %p0, i64 %p1) nounwind {
entry:
  %slot.tokens = alloca i64, align 8
  store i64 %p0, ptr %slot.tokens, align 8
  %slot.pos = alloca i64, align 8
  store i64 %p1, ptr %slot.pos, align 8
  %slot.kind = alloca i64, align 8
  store i64 0, ptr %slot.kind, align 8
  %slot.val = alloca i64, align 8
  store i64 0, ptr %slot.val, align 8
  %slot.rbp = alloca i64, align 8
  store i64 0, ptr %slot.rbp, align 8
  %slot.operand_r = alloca i64, align 8
  store i64 0, ptr %slot.operand_r, align 8
  %slot.inner_r = alloca i64, align 8
  store i64 0, ptr %slot.inner_r, align 8
  %slot.elements = alloca i64, align 8
  store i64 0, ptr %slot.elements, align 8
  %slot.p = alloca i64, align 8
  store i64 0, ptr %slot.p, align 8
  %slot.elem_r = alloca i64, align 8
  store i64 0, ptr %slot.elem_r, align 8
  %slot.p2 = alloca i64, align 8
  store i64 0, ptr %slot.p2, align 8
  %slot.entries = alloca i64, align 8
  store i64 0, ptr %slot.entries, align 8
  %slot.key_r = alloca i64, align 8
  store i64 0, ptr %slot.key_r, align 8
  %slot.val_r = alloca i64, align 8
  store i64 0, ptr %slot.val_r, align 8
  %r0 = load i64, ptr %slot.tokens, align 8
  %r1 = load i64, ptr %slot.pos, align 8
  %r2 = call i64 @tk(i64 %r0, i64 %r1)
  store i64 %r2, ptr %slot.kind, align 8
  %r3 = load i64, ptr %slot.tokens, align 8
  %r4 = load i64, ptr %slot.pos, align 8
  %r5 = call i64 @tv(i64 %r3, i64 %r4)
  store i64 %r5, ptr %slot.val, align 8
  %r6 = load i64, ptr %slot.kind, align 8
  %r7.p = getelementptr inbounds [4 x i8], ptr @.str.49, i64 0, i64 0
  %r7 = ptrtoint ptr %r7.p to i64
  %r8 = call i64 @nova_rt_eq(i64 %r6, i64 %r7)
  %br_then255 = icmp ne i64 %r8, 0
  br i1 %br_then255, label %then255, label %else256
then255:
  %r9.p = getelementptr inbounds [4 x i8], ptr @.str.113, i64 0, i64 0
  %r9 = ptrtoint ptr %r9.p to i64
  %r10 = load i64, ptr %slot.val, align 8
  %r11 = load i64, ptr %slot.val, align 8
  %r12 = call i64 @nova_rt_parse_int(i64 %r11)
  %r13 = call i64 @nova_rt_list_create()
  %r14 = call i64 @nova_rt_list_create()
  %r15.ptr = call ptr @nova_rt_struct_alloc(i64 40)
  %r15.f0 = getelementptr i64, ptr %r15.ptr, i64 0
  store i64 %r9, ptr %r15.f0, align 8
  %r15.f1 = getelementptr i64, ptr %r15.ptr, i64 1
  store i64 %r10, ptr %r15.f1, align 8
  %r15.f2 = getelementptr i64, ptr %r15.ptr, i64 2
  store i64 %r12, ptr %r15.f2, align 8
  %r15.f3 = getelementptr i64, ptr %r15.ptr, i64 3
  store i64 %r13, ptr %r15.f3, align 8
  %r15.f4 = getelementptr i64, ptr %r15.ptr, i64 4
  store i64 %r14, ptr %r15.f4, align 8
  %r15 = ptrtoint ptr %r15.ptr to i64
  %r16 = load i64, ptr %slot.pos, align 8
  %r17 = add i64 1, 0
  %r18 = call i64 @nova_rt_add(i64 %r16, i64 %r17)
  %r19.ptr = call ptr @nova_rt_struct_alloc(i64 16)
  %r19.f0 = getelementptr i64, ptr %r19.ptr, i64 0
  store i64 %r15, ptr %r19.f0, align 8
  %r19.f1 = getelementptr i64, ptr %r19.ptr, i64 1
  store i64 %r18, ptr %r19.f1, align 8
  %r19 = ptrtoint ptr %r19.ptr to i64
  br label %endif257
else256:
  %r20 = load i64, ptr %slot.kind, align 8
  %r21.p = getelementptr inbounds [6 x i8], ptr @.str.48, i64 0, i64 0
  %r21 = ptrtoint ptr %r21.p to i64
  %r22 = call i64 @nova_rt_eq(i64 %r20, i64 %r21)
  %br_then258 = icmp ne i64 %r22, 0
  br i1 %br_then258, label %then258, label %else259
then258:
  %r23.p = getelementptr inbounds [6 x i8], ptr @.str.114, i64 0, i64 0
  %r23 = ptrtoint ptr %r23.p to i64
  %r24 = load i64, ptr %slot.val, align 8
  %r25 = add i64 0, 0
  %r26 = call i64 @nova_rt_list_create()
  %r27 = call i64 @nova_rt_list_create()
  %r28.ptr = call ptr @nova_rt_struct_alloc(i64 40)
  %r28.f0 = getelementptr i64, ptr %r28.ptr, i64 0
  store i64 %r23, ptr %r28.f0, align 8
  %r28.f1 = getelementptr i64, ptr %r28.ptr, i64 1
  store i64 %r24, ptr %r28.f1, align 8
  %r28.f2 = getelementptr i64, ptr %r28.ptr, i64 2
  store i64 %r25, ptr %r28.f2, align 8
  %r28.f3 = getelementptr i64, ptr %r28.ptr, i64 3
  store i64 %r26, ptr %r28.f3, align 8
  %r28.f4 = getelementptr i64, ptr %r28.ptr, i64 4
  store i64 %r27, ptr %r28.f4, align 8
  %r28 = ptrtoint ptr %r28.ptr to i64
  %r29 = load i64, ptr %slot.pos, align 8
  %r30 = add i64 1, 0
  %r31 = call i64 @nova_rt_add(i64 %r29, i64 %r30)
  %r32.ptr = call ptr @nova_rt_struct_alloc(i64 16)
  %r32.f0 = getelementptr i64, ptr %r32.ptr, i64 0
  store i64 %r28, ptr %r32.f0, align 8
  %r32.f1 = getelementptr i64, ptr %r32.ptr, i64 1
  store i64 %r31, ptr %r32.f1, align 8
  %r32 = ptrtoint ptr %r32.ptr to i64
  br label %endif260
else259:
  %r33 = load i64, ptr %slot.kind, align 8
  %r34.p = getelementptr inbounds [4 x i8], ptr @.str.56, i64 0, i64 0
  %r34 = ptrtoint ptr %r34.p to i64
  %r35 = call i64 @nova_rt_eq(i64 %r33, i64 %r34)
  %br_then261 = icmp ne i64 %r35, 0
  br i1 %br_then261, label %then261, label %else262
then261:
  %r36.p = getelementptr inbounds [4 x i8], ptr @.str.115, i64 0, i64 0
  %r36 = ptrtoint ptr %r36.p to i64
  %r37 = load i64, ptr %slot.val, align 8
  %r38 = add i64 0, 0
  %r39 = call i64 @nova_rt_list_create()
  %r40 = call i64 @nova_rt_list_create()
  %r41.ptr = call ptr @nova_rt_struct_alloc(i64 40)
  %r41.f0 = getelementptr i64, ptr %r41.ptr, i64 0
  store i64 %r36, ptr %r41.f0, align 8
  %r41.f1 = getelementptr i64, ptr %r41.ptr, i64 1
  store i64 %r37, ptr %r41.f1, align 8
  %r41.f2 = getelementptr i64, ptr %r41.ptr, i64 2
  store i64 %r38, ptr %r41.f2, align 8
  %r41.f3 = getelementptr i64, ptr %r41.ptr, i64 3
  store i64 %r39, ptr %r41.f3, align 8
  %r41.f4 = getelementptr i64, ptr %r41.ptr, i64 4
  store i64 %r40, ptr %r41.f4, align 8
  %r41 = ptrtoint ptr %r41.ptr to i64
  %r42 = load i64, ptr %slot.pos, align 8
  %r43 = add i64 1, 0
  %r44 = call i64 @nova_rt_add(i64 %r42, i64 %r43)
  %r45.ptr = call ptr @nova_rt_struct_alloc(i64 16)
  %r45.f0 = getelementptr i64, ptr %r45.ptr, i64 0
  store i64 %r41, ptr %r45.f0, align 8
  %r45.f1 = getelementptr i64, ptr %r45.ptr, i64 1
  store i64 %r44, ptr %r45.f1, align 8
  %r45 = ptrtoint ptr %r45.ptr to i64
  br label %endif263
else262:
  %r46 = load i64, ptr %slot.kind, align 8
  %r47.p = getelementptr inbounds [8 x i8], ptr @.str.58, i64 0, i64 0
  %r47 = ptrtoint ptr %r47.p to i64
  %r48 = call i64 @nova_rt_eq(i64 %r46, i64 %r47)
  %br_then264 = icmp ne i64 %r48, 0
  br i1 %br_then264, label %then264, label %else265
then264:
  %r49.p = getelementptr inbounds [4 x i8], ptr @.str.115, i64 0, i64 0
  %r49 = ptrtoint ptr %r49.p to i64
  %r50 = load i64, ptr %slot.val, align 8
  %r51 = add i64 0, 0
  %r52 = call i64 @nova_rt_list_create()
  %r53 = call i64 @nova_rt_list_create()
  %r54.ptr = call ptr @nova_rt_struct_alloc(i64 40)
  %r54.f0 = getelementptr i64, ptr %r54.ptr, i64 0
  store i64 %r49, ptr %r54.f0, align 8
  %r54.f1 = getelementptr i64, ptr %r54.ptr, i64 1
  store i64 %r50, ptr %r54.f1, align 8
  %r54.f2 = getelementptr i64, ptr %r54.ptr, i64 2
  store i64 %r51, ptr %r54.f2, align 8
  %r54.f3 = getelementptr i64, ptr %r54.ptr, i64 3
  store i64 %r52, ptr %r54.f3, align 8
  %r54.f4 = getelementptr i64, ptr %r54.ptr, i64 4
  store i64 %r53, ptr %r54.f4, align 8
  %r54 = ptrtoint ptr %r54.ptr to i64
  %r55 = load i64, ptr %slot.pos, align 8
  %r56 = add i64 1, 0
  %r57 = call i64 @nova_rt_add(i64 %r55, i64 %r56)
  %r58.ptr = call ptr @nova_rt_struct_alloc(i64 16)
  %r58.f0 = getelementptr i64, ptr %r58.ptr, i64 0
  store i64 %r54, ptr %r58.f0, align 8
  %r58.f1 = getelementptr i64, ptr %r58.ptr, i64 1
  store i64 %r57, ptr %r58.f1, align 8
  %r58 = ptrtoint ptr %r58.ptr to i64
  br label %endif266
else265:
  %r59 = load i64, ptr %slot.kind, align 8
  %r60.p = getelementptr inbounds [3 x i8], ptr @.str.43, i64 0, i64 0
  %r60 = ptrtoint ptr %r60.p to i64
  %r61 = call i64 @nova_rt_eq(i64 %r59, i64 %r60)
  %r62 = load i64, ptr %slot.val, align 8
  %r63.p = getelementptr inbounds [5 x i8], ptr @.str.24, i64 0, i64 0
  %r63 = ptrtoint ptr %r63.p to i64
  %r64 = call i64 @nova_rt_eq(i64 %r62, i64 %r63)
  %r65.cmp = icmp ne i64 %r61, 0
  %r65.cmp2 = icmp ne i64 %r64, 0
  %r65.and = and i1 %r65.cmp, %r65.cmp2
  %r65 = zext i1 %r65.and to i64
  %br_then267 = icmp ne i64 %r65, 0
  br i1 %br_then267, label %then267, label %else268
then267:
  %r66.p = getelementptr inbounds [5 x i8], ptr @.str.116, i64 0, i64 0
  %r66 = ptrtoint ptr %r66.p to i64
  %r67.p = getelementptr inbounds [5 x i8], ptr @.str.24, i64 0, i64 0
  %r67 = ptrtoint ptr %r67.p to i64
  %r68 = add i64 1, 0
  %r69 = call i64 @nova_rt_list_create()
  %r70 = call i64 @nova_rt_list_create()
  %r71.ptr = call ptr @nova_rt_struct_alloc(i64 40)
  %r71.f0 = getelementptr i64, ptr %r71.ptr, i64 0
  store i64 %r66, ptr %r71.f0, align 8
  %r71.f1 = getelementptr i64, ptr %r71.ptr, i64 1
  store i64 %r67, ptr %r71.f1, align 8
  %r71.f2 = getelementptr i64, ptr %r71.ptr, i64 2
  store i64 %r68, ptr %r71.f2, align 8
  %r71.f3 = getelementptr i64, ptr %r71.ptr, i64 3
  store i64 %r69, ptr %r71.f3, align 8
  %r71.f4 = getelementptr i64, ptr %r71.ptr, i64 4
  store i64 %r70, ptr %r71.f4, align 8
  %r71 = ptrtoint ptr %r71.ptr to i64
  %r72 = load i64, ptr %slot.pos, align 8
  %r73 = add i64 1, 0
  %r74 = call i64 @nova_rt_add(i64 %r72, i64 %r73)
  %r75.ptr = call ptr @nova_rt_struct_alloc(i64 16)
  %r75.f0 = getelementptr i64, ptr %r75.ptr, i64 0
  store i64 %r71, ptr %r75.f0, align 8
  %r75.f1 = getelementptr i64, ptr %r75.ptr, i64 1
  store i64 %r74, ptr %r75.f1, align 8
  %r75 = ptrtoint ptr %r75.ptr to i64
  br label %endif269
else268:
  %r76 = load i64, ptr %slot.kind, align 8
  %r77.p = getelementptr inbounds [3 x i8], ptr @.str.43, i64 0, i64 0
  %r77 = ptrtoint ptr %r77.p to i64
  %r78 = call i64 @nova_rt_eq(i64 %r76, i64 %r77)
  %r79 = load i64, ptr %slot.val, align 8
  %r80.p = getelementptr inbounds [6 x i8], ptr @.str.25, i64 0, i64 0
  %r80 = ptrtoint ptr %r80.p to i64
  %r81 = call i64 @nova_rt_eq(i64 %r79, i64 %r80)
  %r82.cmp = icmp ne i64 %r78, 0
  %r82.cmp2 = icmp ne i64 %r81, 0
  %r82.and = and i1 %r82.cmp, %r82.cmp2
  %r82 = zext i1 %r82.and to i64
  %br_then270 = icmp ne i64 %r82, 0
  br i1 %br_then270, label %then270, label %else271
then270:
  %r83.p = getelementptr inbounds [5 x i8], ptr @.str.116, i64 0, i64 0
  %r83 = ptrtoint ptr %r83.p to i64
  %r84.p = getelementptr inbounds [6 x i8], ptr @.str.25, i64 0, i64 0
  %r84 = ptrtoint ptr %r84.p to i64
  %r85 = add i64 0, 0
  %r86 = call i64 @nova_rt_list_create()
  %r87 = call i64 @nova_rt_list_create()
  %r88.ptr = call ptr @nova_rt_struct_alloc(i64 40)
  %r88.f0 = getelementptr i64, ptr %r88.ptr, i64 0
  store i64 %r83, ptr %r88.f0, align 8
  %r88.f1 = getelementptr i64, ptr %r88.ptr, i64 1
  store i64 %r84, ptr %r88.f1, align 8
  %r88.f2 = getelementptr i64, ptr %r88.ptr, i64 2
  store i64 %r85, ptr %r88.f2, align 8
  %r88.f3 = getelementptr i64, ptr %r88.ptr, i64 3
  store i64 %r86, ptr %r88.f3, align 8
  %r88.f4 = getelementptr i64, ptr %r88.ptr, i64 4
  store i64 %r87, ptr %r88.f4, align 8
  %r88 = ptrtoint ptr %r88.ptr to i64
  %r89 = load i64, ptr %slot.pos, align 8
  %r90 = add i64 1, 0
  %r91 = call i64 @nova_rt_add(i64 %r89, i64 %r90)
  %r92.ptr = call ptr @nova_rt_struct_alloc(i64 16)
  %r92.f0 = getelementptr i64, ptr %r92.ptr, i64 0
  store i64 %r88, ptr %r92.f0, align 8
  %r92.f1 = getelementptr i64, ptr %r92.ptr, i64 1
  store i64 %r91, ptr %r92.f1, align 8
  %r92 = ptrtoint ptr %r92.ptr to i64
  br label %endif272
else271:
  %r93 = load i64, ptr %slot.kind, align 8
  %r94.p = getelementptr inbounds [3 x i8], ptr @.str.43, i64 0, i64 0
  %r94 = ptrtoint ptr %r94.p to i64
  %r95 = call i64 @nova_rt_eq(i64 %r93, i64 %r94)
  %r96 = load i64, ptr %slot.val, align 8
  %r97.p = getelementptr inbounds [5 x i8], ptr @.str.26, i64 0, i64 0
  %r97 = ptrtoint ptr %r97.p to i64
  %r98 = call i64 @nova_rt_eq(i64 %r96, i64 %r97)
  %r99.cmp = icmp ne i64 %r95, 0
  %r99.cmp2 = icmp ne i64 %r98, 0
  %r99.and = and i1 %r99.cmp, %r99.cmp2
  %r99 = zext i1 %r99.and to i64
  %br_then273 = icmp ne i64 %r99, 0
  br i1 %br_then273, label %then273, label %else274
then273:
  %r100.p = getelementptr inbounds [5 x i8], ptr @.str.26, i64 0, i64 0
  %r100 = ptrtoint ptr %r100.p to i64
  %r101.p = getelementptr inbounds [1 x i8], ptr @.str.42, i64 0, i64 0
  %r101 = ptrtoint ptr %r101.p to i64
  %r102 = add i64 0, 0
  %r103 = call i64 @nova_rt_list_create()
  %r104 = call i64 @nova_rt_list_create()
  %r105.ptr = call ptr @nova_rt_struct_alloc(i64 40)
  %r105.f0 = getelementptr i64, ptr %r105.ptr, i64 0
  store i64 %r100, ptr %r105.f0, align 8
  %r105.f1 = getelementptr i64, ptr %r105.ptr, i64 1
  store i64 %r101, ptr %r105.f1, align 8
  %r105.f2 = getelementptr i64, ptr %r105.ptr, i64 2
  store i64 %r102, ptr %r105.f2, align 8
  %r105.f3 = getelementptr i64, ptr %r105.ptr, i64 3
  store i64 %r103, ptr %r105.f3, align 8
  %r105.f4 = getelementptr i64, ptr %r105.ptr, i64 4
  store i64 %r104, ptr %r105.f4, align 8
  %r105 = ptrtoint ptr %r105.ptr to i64
  %r106 = load i64, ptr %slot.pos, align 8
  %r107 = add i64 1, 0
  %r108 = call i64 @nova_rt_add(i64 %r106, i64 %r107)
  %r109.ptr = call ptr @nova_rt_struct_alloc(i64 16)
  %r109.f0 = getelementptr i64, ptr %r109.ptr, i64 0
  store i64 %r105, ptr %r109.f0, align 8
  %r109.f1 = getelementptr i64, ptr %r109.ptr, i64 1
  store i64 %r108, ptr %r109.f1, align 8
  %r109 = ptrtoint ptr %r109.ptr to i64
  br label %endif275
else274:
  %r110 = load i64, ptr %slot.kind, align 8
  %r111.p = getelementptr inbounds [6 x i8], ptr @.str.44, i64 0, i64 0
  %r111 = ptrtoint ptr %r111.p to i64
  %r112 = call i64 @nova_rt_eq(i64 %r110, i64 %r111)
  %br_then276 = icmp ne i64 %r112, 0
  br i1 %br_then276, label %then276, label %else277
then276:
  %r113.p = getelementptr inbounds [6 x i8], ptr @.str.117, i64 0, i64 0
  %r113 = ptrtoint ptr %r113.p to i64
  %r114 = load i64, ptr %slot.val, align 8
  %r115 = add i64 0, 0
  %r116 = call i64 @nova_rt_list_create()
  %r117 = call i64 @nova_rt_list_create()
  %r118.ptr = call ptr @nova_rt_struct_alloc(i64 40)
  %r118.f0 = getelementptr i64, ptr %r118.ptr, i64 0
  store i64 %r113, ptr %r118.f0, align 8
  %r118.f1 = getelementptr i64, ptr %r118.ptr, i64 1
  store i64 %r114, ptr %r118.f1, align 8
  %r118.f2 = getelementptr i64, ptr %r118.ptr, i64 2
  store i64 %r115, ptr %r118.f2, align 8
  %r118.f3 = getelementptr i64, ptr %r118.ptr, i64 3
  store i64 %r116, ptr %r118.f3, align 8
  %r118.f4 = getelementptr i64, ptr %r118.ptr, i64 4
  store i64 %r117, ptr %r118.f4, align 8
  %r118 = ptrtoint ptr %r118.ptr to i64
  %r119 = load i64, ptr %slot.pos, align 8
  %r120 = add i64 1, 0
  %r121 = call i64 @nova_rt_add(i64 %r119, i64 %r120)
  %r122.ptr = call ptr @nova_rt_struct_alloc(i64 16)
  %r122.f0 = getelementptr i64, ptr %r122.ptr, i64 0
  store i64 %r118, ptr %r122.f0, align 8
  %r122.f1 = getelementptr i64, ptr %r122.ptr, i64 1
  store i64 %r121, ptr %r122.f1, align 8
  %r122 = ptrtoint ptr %r122.ptr to i64
  br label %endif278
else277:
  %r123 = load i64, ptr %slot.kind, align 8
  %r124.p = getelementptr inbounds [3 x i8], ptr @.str.75, i64 0, i64 0
  %r124 = ptrtoint ptr %r124.p to i64
  %r125 = call i64 @nova_rt_eq(i64 %r123, i64 %r124)
  %r126 = load i64, ptr %slot.val, align 8
  %r127.p = getelementptr inbounds [2 x i8], ptr @.str.77, i64 0, i64 0
  %r127 = ptrtoint ptr %r127.p to i64
  %r128 = call i64 @nova_rt_eq(i64 %r126, i64 %r127)
  %r129.cmp = icmp ne i64 %r125, 0
  %r129.cmp2 = icmp ne i64 %r128, 0
  %r129.and = and i1 %r129.cmp, %r129.cmp2
  %r129 = zext i1 %r129.and to i64
  %br_then279 = icmp ne i64 %r129, 0
  br i1 %br_then279, label %then279, label %else280
then279:
  %r130.p = getelementptr inbounds [2 x i8], ptr @.str.77, i64 0, i64 0
  %r130 = ptrtoint ptr %r130.p to i64
  %r131 = call i64 @prefix_bp(i64 %r130)
  store i64 %r131, ptr %slot.rbp, align 8
  %r132 = load i64, ptr %slot.tokens, align 8
  %r133 = load i64, ptr %slot.pos, align 8
  %r134 = add i64 1, 0
  %r135 = call i64 @nova_rt_add(i64 %r133, i64 %r134)
  %r136 = load i64, ptr %slot.rbp, align 8
  %r137 = call i64 @parse_expr(i64 %r132, i64 %r135, i64 %r136)
  store i64 %r137, ptr %slot.operand_r, align 8
  %r138.p = getelementptr inbounds [6 x i8], ptr @.str.118, i64 0, i64 0
  %r138 = ptrtoint ptr %r138.p to i64
  %r139.p = getelementptr inbounds [2 x i8], ptr @.str.77, i64 0, i64 0
  %r139 = ptrtoint ptr %r139.p to i64
  %r140 = add i64 0, 0
  %r142 = add i64 0, 0
  %r141 = call i64 @nova_rt_list_create()
  call i64 @nova_rt_list_append(i64 %r141, i64 %r142)
  %r143 = call i64 @nova_rt_list_create()
  %r144.ptr = call ptr @nova_rt_struct_alloc(i64 40)
  %r144.f0 = getelementptr i64, ptr %r144.ptr, i64 0
  store i64 %r138, ptr %r144.f0, align 8
  %r144.f1 = getelementptr i64, ptr %r144.ptr, i64 1
  store i64 %r139, ptr %r144.f1, align 8
  %r144.f2 = getelementptr i64, ptr %r144.ptr, i64 2
  store i64 %r140, ptr %r144.f2, align 8
  %r144.f3 = getelementptr i64, ptr %r144.ptr, i64 3
  store i64 %r141, ptr %r144.f3, align 8
  %r144.f4 = getelementptr i64, ptr %r144.ptr, i64 4
  store i64 %r143, ptr %r144.f4, align 8
  %r144 = ptrtoint ptr %r144.ptr to i64
  %r145 = add i64 0, 0
  %r146.ptr = call ptr @nova_rt_struct_alloc(i64 16)
  %r146.f0 = getelementptr i64, ptr %r146.ptr, i64 0
  store i64 %r144, ptr %r146.f0, align 8
  %r146.f1 = getelementptr i64, ptr %r146.ptr, i64 1
  store i64 %r145, ptr %r146.f1, align 8
  %r146 = ptrtoint ptr %r146.ptr to i64
  br label %endif281
else280:
  %r147 = load i64, ptr %slot.kind, align 8
  %r148.p = getelementptr inbounds [3 x i8], ptr @.str.43, i64 0, i64 0
  %r148 = ptrtoint ptr %r148.p to i64
  %r149 = call i64 @nova_rt_eq(i64 %r147, i64 %r148)
  %r150 = load i64, ptr %slot.val, align 8
  %r151.p = getelementptr inbounds [4 x i8], ptr @.str.21, i64 0, i64 0
  %r151 = ptrtoint ptr %r151.p to i64
  %r152 = call i64 @nova_rt_eq(i64 %r150, i64 %r151)
  %r153.cmp = icmp ne i64 %r149, 0
  %r153.cmp2 = icmp ne i64 %r152, 0
  %r153.and = and i1 %r153.cmp, %r153.cmp2
  %r153 = zext i1 %r153.and to i64
  %br_then282 = icmp ne i64 %r153, 0
  br i1 %br_then282, label %then282, label %else283
then282:
  %r154.p = getelementptr inbounds [4 x i8], ptr @.str.21, i64 0, i64 0
  %r154 = ptrtoint ptr %r154.p to i64
  %r155 = call i64 @prefix_bp(i64 %r154)
  store i64 %r155, ptr %slot.rbp, align 8
  %r156 = load i64, ptr %slot.tokens, align 8
  %r157 = load i64, ptr %slot.pos, align 8
  %r158 = add i64 1, 0
  %r159 = call i64 @nova_rt_add(i64 %r157, i64 %r158)
  %r160 = load i64, ptr %slot.rbp, align 8
  %r161 = call i64 @parse_expr(i64 %r156, i64 %r159, i64 %r160)
  store i64 %r161, ptr %slot.operand_r, align 8
  %r162.p = getelementptr inbounds [6 x i8], ptr @.str.118, i64 0, i64 0
  %r162 = ptrtoint ptr %r162.p to i64
  %r163.p = getelementptr inbounds [4 x i8], ptr @.str.21, i64 0, i64 0
  %r163 = ptrtoint ptr %r163.p to i64
  %r164 = add i64 0, 0
  %r166 = add i64 0, 0
  %r165 = call i64 @nova_rt_list_create()
  call i64 @nova_rt_list_append(i64 %r165, i64 %r166)
  %r167 = call i64 @nova_rt_list_create()
  %r168.ptr = call ptr @nova_rt_struct_alloc(i64 40)
  %r168.f0 = getelementptr i64, ptr %r168.ptr, i64 0
  store i64 %r162, ptr %r168.f0, align 8
  %r168.f1 = getelementptr i64, ptr %r168.ptr, i64 1
  store i64 %r163, ptr %r168.f1, align 8
  %r168.f2 = getelementptr i64, ptr %r168.ptr, i64 2
  store i64 %r164, ptr %r168.f2, align 8
  %r168.f3 = getelementptr i64, ptr %r168.ptr, i64 3
  store i64 %r165, ptr %r168.f3, align 8
  %r168.f4 = getelementptr i64, ptr %r168.ptr, i64 4
  store i64 %r167, ptr %r168.f4, align 8
  %r168 = ptrtoint ptr %r168.ptr to i64
  %r169 = add i64 0, 0
  %r170.ptr = call ptr @nova_rt_struct_alloc(i64 16)
  %r170.f0 = getelementptr i64, ptr %r170.ptr, i64 0
  store i64 %r168, ptr %r170.f0, align 8
  %r170.f1 = getelementptr i64, ptr %r170.ptr, i64 1
  store i64 %r169, ptr %r170.f1, align 8
  %r170 = ptrtoint ptr %r170.ptr to i64
  br label %endif284
else283:
  %r171 = load i64, ptr %slot.kind, align 8
  %r172.p = getelementptr inbounds [3 x i8], ptr @.str.75, i64 0, i64 0
  %r172 = ptrtoint ptr %r172.p to i64
  %r173 = call i64 @nova_rt_eq(i64 %r171, i64 %r172)
  %r174 = load i64, ptr %slot.val, align 8
  %r175.p = getelementptr inbounds [2 x i8], ptr @.str.104, i64 0, i64 0
  %r175 = ptrtoint ptr %r175.p to i64
  %r176 = call i64 @nova_rt_eq(i64 %r174, i64 %r175)
  %r177.cmp = icmp ne i64 %r173, 0
  %r177.cmp2 = icmp ne i64 %r176, 0
  %r177.and = and i1 %r177.cmp, %r177.cmp2
  %r177 = zext i1 %r177.and to i64
  %br_then285 = icmp ne i64 %r177, 0
  br i1 %br_then285, label %then285, label %else286
then285:
  %r178.p = getelementptr inbounds [2 x i8], ptr @.str.104, i64 0, i64 0
  %r178 = ptrtoint ptr %r178.p to i64
  %r179 = call i64 @prefix_bp(i64 %r178)
  store i64 %r179, ptr %slot.rbp, align 8
  %r180 = load i64, ptr %slot.tokens, align 8
  %r181 = load i64, ptr %slot.pos, align 8
  %r182 = add i64 1, 0
  %r183 = call i64 @nova_rt_add(i64 %r181, i64 %r182)
  %r184 = load i64, ptr %slot.rbp, align 8
  %r185 = call i64 @parse_expr(i64 %r180, i64 %r183, i64 %r184)
  store i64 %r185, ptr %slot.operand_r, align 8
  %r186.p = getelementptr inbounds [6 x i8], ptr @.str.118, i64 0, i64 0
  %r186 = ptrtoint ptr %r186.p to i64
  %r187.p = getelementptr inbounds [2 x i8], ptr @.str.104, i64 0, i64 0
  %r187 = ptrtoint ptr %r187.p to i64
  %r188 = add i64 0, 0
  %r190 = add i64 0, 0
  %r189 = call i64 @nova_rt_list_create()
  call i64 @nova_rt_list_append(i64 %r189, i64 %r190)
  %r191 = call i64 @nova_rt_list_create()
  %r192.ptr = call ptr @nova_rt_struct_alloc(i64 40)
  %r192.f0 = getelementptr i64, ptr %r192.ptr, i64 0
  store i64 %r186, ptr %r192.f0, align 8
  %r192.f1 = getelementptr i64, ptr %r192.ptr, i64 1
  store i64 %r187, ptr %r192.f1, align 8
  %r192.f2 = getelementptr i64, ptr %r192.ptr, i64 2
  store i64 %r188, ptr %r192.f2, align 8
  %r192.f3 = getelementptr i64, ptr %r192.ptr, i64 3
  store i64 %r189, ptr %r192.f3, align 8
  %r192.f4 = getelementptr i64, ptr %r192.ptr, i64 4
  store i64 %r191, ptr %r192.f4, align 8
  %r192 = ptrtoint ptr %r192.ptr to i64
  %r193 = add i64 0, 0
  %r194.ptr = call ptr @nova_rt_struct_alloc(i64 16)
  %r194.f0 = getelementptr i64, ptr %r194.ptr, i64 0
  store i64 %r192, ptr %r194.f0, align 8
  %r194.f1 = getelementptr i64, ptr %r194.ptr, i64 1
  store i64 %r193, ptr %r194.f1, align 8
  %r194 = ptrtoint ptr %r194.ptr to i64
  br label %endif287
else286:
  %r195 = load i64, ptr %slot.kind, align 8
  %r196.p = getelementptr inbounds [6 x i8], ptr @.str.65, i64 0, i64 0
  %r196 = ptrtoint ptr %r196.p to i64
  %r197 = call i64 @nova_rt_eq(i64 %r195, i64 %r196)
  %r198 = load i64, ptr %slot.val, align 8
  %r199.p = getelementptr inbounds [2 x i8], ptr @.str.59, i64 0, i64 0
  %r199 = ptrtoint ptr %r199.p to i64
  %r200 = call i64 @nova_rt_eq(i64 %r198, i64 %r199)
  %r201.cmp = icmp ne i64 %r197, 0
  %r201.cmp2 = icmp ne i64 %r200, 0
  %r201.and = and i1 %r201.cmp, %r201.cmp2
  %r201 = zext i1 %r201.and to i64
  %br_then288 = icmp ne i64 %r201, 0
  br i1 %br_then288, label %then288, label %else289
then288:
  %r202 = load i64, ptr %slot.tokens, align 8
  %r203 = load i64, ptr %slot.pos, align 8
  %r204 = add i64 1, 0
  %r205 = call i64 @nova_rt_add(i64 %r203, i64 %r204)
  %r206 = add i64 0, 0
  %r207 = call i64 @parse_expr(i64 %r202, i64 %r205, i64 %r206)
  store i64 %r207, ptr %slot.inner_r, align 8
  %r208 = load i64, ptr %slot.tokens, align 8
  %r209 = add i64 0, 0
  %r210 = call i64 @tk(i64 %r208, i64 %r209)
  %r211.p = getelementptr inbounds [6 x i8], ptr @.str.67, i64 0, i64 0
  %r211 = ptrtoint ptr %r211.p to i64
  %r212 = call i64 @nova_rt_eq(i64 %r210, i64 %r211)
  %br_then291 = icmp ne i64 %r212, 0
  br i1 %br_then291, label %then291, label %else292
then291:
  %r214 = add i64 0, 0
  %r213 = call i64 @nova_rt_list_create()
  call i64 @nova_rt_list_append(i64 %r213, i64 %r214)
  store i64 %r213, ptr %slot.elements, align 8
  %r215 = add i64 0, 0
  store i64 %r215, ptr %slot.p, align 8
  br label %while_hdr294
while_hdr294:
  %r216 = load i64, ptr %slot.tokens, align 8
  %r217 = load i64, ptr %slot.p, align 8
  %r218 = call i64 @tv(i64 %r216, i64 %r217)
  %r219.p = getelementptr inbounds [2 x i8], ptr @.str.66, i64 0, i64 0
  %r219 = ptrtoint ptr %r219.p to i64
  %r220 = call i64 @nova_rt_eq(i64 %r218, i64 %r219)
  %br_while_body295 = icmp ne i64 %r220, 0
  br i1 %br_while_body295, label %while_body295, label %while_exit296
while_body295:
  %r221 = load i64, ptr %slot.p, align 8
  %r222 = add i64 1, 0
  %r223 = add i64 %r221, %r222
  store i64 %r223, ptr %slot.p, align 8
  %r224 = load i64, ptr %slot.tokens, align 8
  %r225 = load i64, ptr %slot.p, align 8
  %r226 = add i64 0, 0
  %r227 = call i64 @parse_expr(i64 %r224, i64 %r225, i64 %r226)
  store i64 %r227, ptr %slot.elem_r, align 8
  %r228 = load i64, ptr %slot.elements, align 8
  %r229 = add i64 0, 0
  %r230 = call i64 @nova_rt_list_append(i64 %r228, i64 %r229)
  %r231 = add i64 0, 0
  store i64 %r231, ptr %slot.p, align 8
  br label %while_hdr294
while_exit296:
  %r232 = load i64, ptr %slot.tokens, align 8
  %r233 = load i64, ptr %slot.p, align 8
  %r234.p = getelementptr inbounds [2 x i8], ptr @.str.60, i64 0, i64 0
  %r234 = ptrtoint ptr %r234.p to i64
  %r235 = call i64 @expect(i64 %r232, i64 %r233, i64 %r234)
  store i64 %r235, ptr %slot.p, align 8
  %r236.p = getelementptr inbounds [6 x i8], ptr @.str.119, i64 0, i64 0
  %r236 = ptrtoint ptr %r236.p to i64
  %r237.p = getelementptr inbounds [1 x i8], ptr @.str.42, i64 0, i64 0
  %r237 = ptrtoint ptr %r237.p to i64
  %r238 = add i64 0, 0
  %r239 = load i64, ptr %slot.elements, align 8
  %r240 = call i64 @nova_rt_list_create()
  %r241.ptr = call ptr @nova_rt_struct_alloc(i64 40)
  %r241.f0 = getelementptr i64, ptr %r241.ptr, i64 0
  store i64 %r236, ptr %r241.f0, align 8
  %r241.f1 = getelementptr i64, ptr %r241.ptr, i64 1
  store i64 %r237, ptr %r241.f1, align 8
  %r241.f2 = getelementptr i64, ptr %r241.ptr, i64 2
  store i64 %r238, ptr %r241.f2, align 8
  %r241.f3 = getelementptr i64, ptr %r241.ptr, i64 3
  store i64 %r239, ptr %r241.f3, align 8
  %r241.f4 = getelementptr i64, ptr %r241.ptr, i64 4
  store i64 %r240, ptr %r241.f4, align 8
  %r241 = ptrtoint ptr %r241.ptr to i64
  %r242 = load i64, ptr %slot.p, align 8
  %r243.ptr = call ptr @nova_rt_struct_alloc(i64 16)
  %r243.f0 = getelementptr i64, ptr %r243.ptr, i64 0
  store i64 %r241, ptr %r243.f0, align 8
  %r243.f1 = getelementptr i64, ptr %r243.ptr, i64 1
  store i64 %r242, ptr %r243.f1, align 8
  %r243 = ptrtoint ptr %r243.ptr to i64
  br label %endif293
else292:
  %r244 = load i64, ptr %slot.tokens, align 8
  %r245 = add i64 0, 0
  %r246.p = getelementptr inbounds [2 x i8], ptr @.str.60, i64 0, i64 0
  %r246 = ptrtoint ptr %r246.p to i64
  %r247 = call i64 @expect(i64 %r244, i64 %r245, i64 %r246)
  store i64 %r247, ptr %slot.p2, align 8
  %r248 = add i64 0, 0
  %r249 = load i64, ptr %slot.p2, align 8
  %r250.ptr = call ptr @nova_rt_struct_alloc(i64 16)
  %r250.f0 = getelementptr i64, ptr %r250.ptr, i64 0
  store i64 %r248, ptr %r250.f0, align 8
  %r250.f1 = getelementptr i64, ptr %r250.ptr, i64 1
  store i64 %r249, ptr %r250.f1, align 8
  %r250 = ptrtoint ptr %r250.ptr to i64
  br label %endif293
endif293:
  br label %endif290
else289:
  %r251 = load i64, ptr %slot.kind, align 8
  %r252.p = getelementptr inbounds [6 x i8], ptr @.str.65, i64 0, i64 0
  %r252 = ptrtoint ptr %r252.p to i64
  %r253 = call i64 @nova_rt_eq(i64 %r251, i64 %r252)
  %r254 = load i64, ptr %slot.val, align 8
  %r255.p = getelementptr inbounds [2 x i8], ptr @.str.61, i64 0, i64 0
  %r255 = ptrtoint ptr %r255.p to i64
  %r256 = call i64 @nova_rt_eq(i64 %r254, i64 %r255)
  %r257.cmp = icmp ne i64 %r253, 0
  %r257.cmp2 = icmp ne i64 %r256, 0
  %r257.and = and i1 %r257.cmp, %r257.cmp2
  %r257 = zext i1 %r257.and to i64
  %br_then297 = icmp ne i64 %r257, 0
  br i1 %br_then297, label %then297, label %else298
then297:
  %r258 = call i64 @nova_rt_list_create()
  store i64 %r258, ptr %slot.elements, align 8
  %r259 = load i64, ptr %slot.pos, align 8
  %r260 = add i64 1, 0
  %r261 = call i64 @nova_rt_add(i64 %r259, i64 %r260)
  store i64 %r261, ptr %slot.p, align 8
  br label %while_hdr300
while_hdr300:
  %r262 = load i64, ptr %slot.tokens, align 8
  %r263 = load i64, ptr %slot.p, align 8
  %r264 = call i64 @tv(i64 %r262, i64 %r263)
  %r265.p = getelementptr inbounds [2 x i8], ptr @.str.62, i64 0, i64 0
  %r265 = ptrtoint ptr %r265.p to i64
  %r266 = call i64 @nova_rt_neq(i64 %r264, i64 %r265)
  %br_while_body301 = icmp ne i64 %r266, 0
  br i1 %br_while_body301, label %while_body301, label %while_exit302
while_body301:
  %r267 = load i64, ptr %slot.elements, align 8
  %r268 = call i64 @nova_rt_len_any(i64 %r267)
  %r269 = add i64 0, 0
  %r270.cmp = icmp sgt i64 %r268, %r269
  %r270 = zext i1 %r270.cmp to i64
  %br_then303 = icmp ne i64 %r270, 0
  br i1 %br_then303, label %then303, label %else304
then303:
  %r271 = load i64, ptr %slot.tokens, align 8
  %r272 = load i64, ptr %slot.p, align 8
  %r273.p = getelementptr inbounds [2 x i8], ptr @.str.66, i64 0, i64 0
  %r273 = ptrtoint ptr %r273.p to i64
  %r274 = call i64 @expect(i64 %r271, i64 %r272, i64 %r273)
  store i64 %r274, ptr %slot.p, align 8
  br label %endif305
else304:
  br label %endif305
endif305:
  %r275 = load i64, ptr %slot.tokens, align 8
  %r276 = load i64, ptr %slot.p, align 8
  %r277 = add i64 0, 0
  %r278 = call i64 @parse_expr(i64 %r275, i64 %r276, i64 %r277)
  store i64 %r278, ptr %slot.elem_r, align 8
  %r279 = load i64, ptr %slot.elements, align 8
  %r280 = add i64 0, 0
  %r281 = call i64 @nova_rt_list_append(i64 %r279, i64 %r280)
  %r282 = add i64 0, 0
  store i64 %r282, ptr %slot.p, align 8
  br label %while_hdr300
while_exit302:
  %r283 = load i64, ptr %slot.tokens, align 8
  %r284 = load i64, ptr %slot.p, align 8
  %r285.p = getelementptr inbounds [2 x i8], ptr @.str.62, i64 0, i64 0
  %r285 = ptrtoint ptr %r285.p to i64
  %r286 = call i64 @expect(i64 %r283, i64 %r284, i64 %r285)
  store i64 %r286, ptr %slot.p, align 8
  %r287.p = getelementptr inbounds [5 x i8], ptr @.str.120, i64 0, i64 0
  %r287 = ptrtoint ptr %r287.p to i64
  %r288.p = getelementptr inbounds [1 x i8], ptr @.str.42, i64 0, i64 0
  %r288 = ptrtoint ptr %r288.p to i64
  %r289 = add i64 0, 0
  %r290 = load i64, ptr %slot.elements, align 8
  %r291 = call i64 @nova_rt_list_create()
  %r292.ptr = call ptr @nova_rt_struct_alloc(i64 40)
  %r292.f0 = getelementptr i64, ptr %r292.ptr, i64 0
  store i64 %r287, ptr %r292.f0, align 8
  %r292.f1 = getelementptr i64, ptr %r292.ptr, i64 1
  store i64 %r288, ptr %r292.f1, align 8
  %r292.f2 = getelementptr i64, ptr %r292.ptr, i64 2
  store i64 %r289, ptr %r292.f2, align 8
  %r292.f3 = getelementptr i64, ptr %r292.ptr, i64 3
  store i64 %r290, ptr %r292.f3, align 8
  %r292.f4 = getelementptr i64, ptr %r292.ptr, i64 4
  store i64 %r291, ptr %r292.f4, align 8
  %r292 = ptrtoint ptr %r292.ptr to i64
  %r293 = load i64, ptr %slot.p, align 8
  %r294.ptr = call ptr @nova_rt_struct_alloc(i64 16)
  %r294.f0 = getelementptr i64, ptr %r294.ptr, i64 0
  store i64 %r292, ptr %r294.f0, align 8
  %r294.f1 = getelementptr i64, ptr %r294.ptr, i64 1
  store i64 %r293, ptr %r294.f1, align 8
  %r294 = ptrtoint ptr %r294.ptr to i64
  br label %endif299
else298:
  %r295 = load i64, ptr %slot.kind, align 8
  %r296.p = getelementptr inbounds [6 x i8], ptr @.str.65, i64 0, i64 0
  %r296 = ptrtoint ptr %r296.p to i64
  %r297 = call i64 @nova_rt_eq(i64 %r295, i64 %r296)
  %r298 = load i64, ptr %slot.val, align 8
  %r299.p = getelementptr inbounds [2 x i8], ptr @.str.63, i64 0, i64 0
  %r299 = ptrtoint ptr %r299.p to i64
  %r300 = call i64 @nova_rt_eq(i64 %r298, i64 %r299)
  %r301.cmp = icmp ne i64 %r297, 0
  %r301.cmp2 = icmp ne i64 %r300, 0
  %r301.and = and i1 %r301.cmp, %r301.cmp2
  %r301 = zext i1 %r301.and to i64
  %br_then306 = icmp ne i64 %r301, 0
  br i1 %br_then306, label %then306, label %else307
then306:
  %r302 = call i64 @nova_rt_list_create()
  store i64 %r302, ptr %slot.entries, align 8
  %r303 = load i64, ptr %slot.pos, align 8
  %r304 = add i64 1, 0
  %r305 = call i64 @nova_rt_add(i64 %r303, i64 %r304)
  store i64 %r305, ptr %slot.p, align 8
  br label %while_hdr309
while_hdr309:
  %r306 = load i64, ptr %slot.tokens, align 8
  %r307 = load i64, ptr %slot.p, align 8
  %r308 = call i64 @tv(i64 %r306, i64 %r307)
  %r309.p = getelementptr inbounds [2 x i8], ptr @.str.64, i64 0, i64 0
  %r309 = ptrtoint ptr %r309.p to i64
  %r310 = call i64 @nova_rt_neq(i64 %r308, i64 %r309)
  %br_while_body310 = icmp ne i64 %r310, 0
  br i1 %br_while_body310, label %while_body310, label %while_exit311
while_body310:
  %r311 = load i64, ptr %slot.entries, align 8
  %r312 = call i64 @nova_rt_len_any(i64 %r311)
  %r313 = add i64 0, 0
  %r314.cmp = icmp sgt i64 %r312, %r313
  %r314 = zext i1 %r314.cmp to i64
  %br_then312 = icmp ne i64 %r314, 0
  br i1 %br_then312, label %then312, label %else313
then312:
  %r315 = load i64, ptr %slot.tokens, align 8
  %r316 = load i64, ptr %slot.p, align 8
  %r317.p = getelementptr inbounds [2 x i8], ptr @.str.66, i64 0, i64 0
  %r317 = ptrtoint ptr %r317.p to i64
  %r318 = call i64 @expect(i64 %r315, i64 %r316, i64 %r317)
  store i64 %r318, ptr %slot.p, align 8
  %r319 = load i64, ptr %slot.tokens, align 8
  %r320 = load i64, ptr %slot.p, align 8
  %r321 = call i64 @tv(i64 %r319, i64 %r320)
  %r322.p = getelementptr inbounds [2 x i8], ptr @.str.64, i64 0, i64 0
  %r322 = ptrtoint ptr %r322.p to i64
  %r323 = call i64 @nova_rt_eq(i64 %r321, i64 %r322)
  %br_then315 = icmp ne i64 %r323, 0
  br i1 %br_then315, label %then315, label %else316
then315:
  br label %endif317
else316:
  br label %endif317
endif317:
  br label %endif314
else313:
  br label %endif314
endif314:
  %r324 = load i64, ptr %slot.tokens, align 8
  %r325 = load i64, ptr %slot.p, align 8
  %r326 = add i64 0, 0
  %r327 = call i64 @parse_expr(i64 %r324, i64 %r325, i64 %r326)
  store i64 %r327, ptr %slot.key_r, align 8
  %r328 = load i64, ptr %slot.tokens, align 8
  %r329 = add i64 0, 0
  %r330.p = getelementptr inbounds [2 x i8], ptr @.str.68, i64 0, i64 0
  %r330 = ptrtoint ptr %r330.p to i64
  %r331 = call i64 @expect(i64 %r328, i64 %r329, i64 %r330)
  store i64 %r331, ptr %slot.p, align 8
  %r332 = load i64, ptr %slot.tokens, align 8
  %r333 = load i64, ptr %slot.p, align 8
  %r334 = add i64 0, 0
  %r335 = call i64 @parse_expr(i64 %r332, i64 %r333, i64 %r334)
  store i64 %r335, ptr %slot.val_r, align 8
  %r336 = load i64, ptr %slot.entries, align 8
  %r337.p = getelementptr inbounds [5 x i8], ptr @.str.121, i64 0, i64 0
  %r337 = ptrtoint ptr %r337.p to i64
  %r338.p = getelementptr inbounds [1 x i8], ptr @.str.42, i64 0, i64 0
  %r338 = ptrtoint ptr %r338.p to i64
  %r339 = add i64 0, 0
  %r341 = add i64 0, 0
  %r342 = add i64 0, 0
  %r340 = call i64 @nova_rt_list_create()
  call i64 @nova_rt_list_append(i64 %r340, i64 %r341)
  call i64 @nova_rt_list_append(i64 %r340, i64 %r342)
  %r343 = call i64 @nova_rt_list_create()
  %r344.ptr = call ptr @nova_rt_struct_alloc(i64 40)
  %r344.f0 = getelementptr i64, ptr %r344.ptr, i64 0
  store i64 %r337, ptr %r344.f0, align 8
  %r344.f1 = getelementptr i64, ptr %r344.ptr, i64 1
  store i64 %r338, ptr %r344.f1, align 8
  %r344.f2 = getelementptr i64, ptr %r344.ptr, i64 2
  store i64 %r339, ptr %r344.f2, align 8
  %r344.f3 = getelementptr i64, ptr %r344.ptr, i64 3
  store i64 %r340, ptr %r344.f3, align 8
  %r344.f4 = getelementptr i64, ptr %r344.ptr, i64 4
  store i64 %r343, ptr %r344.f4, align 8
  %r344 = ptrtoint ptr %r344.ptr to i64
  %r345 = call i64 @nova_rt_list_append(i64 %r336, i64 %r344)
  %r346 = add i64 0, 0
  store i64 %r346, ptr %slot.p, align 8
  br label %while_hdr309
while_exit311:
  %r347 = load i64, ptr %slot.tokens, align 8
  %r348 = load i64, ptr %slot.p, align 8
  %r349.p = getelementptr inbounds [2 x i8], ptr @.str.64, i64 0, i64 0
  %r349 = ptrtoint ptr %r349.p to i64
  %r350 = call i64 @expect(i64 %r347, i64 %r348, i64 %r349)
  store i64 %r350, ptr %slot.p, align 8
  %r351.p = getelementptr inbounds [5 x i8], ptr @.str.122, i64 0, i64 0
  %r351 = ptrtoint ptr %r351.p to i64
  %r352.p = getelementptr inbounds [1 x i8], ptr @.str.42, i64 0, i64 0
  %r352 = ptrtoint ptr %r352.p to i64
  %r353 = add i64 0, 0
  %r354 = load i64, ptr %slot.entries, align 8
  %r355 = call i64 @nova_rt_list_create()
  %r356.ptr = call ptr @nova_rt_struct_alloc(i64 40)
  %r356.f0 = getelementptr i64, ptr %r356.ptr, i64 0
  store i64 %r351, ptr %r356.f0, align 8
  %r356.f1 = getelementptr i64, ptr %r356.ptr, i64 1
  store i64 %r352, ptr %r356.f1, align 8
  %r356.f2 = getelementptr i64, ptr %r356.ptr, i64 2
  store i64 %r353, ptr %r356.f2, align 8
  %r356.f3 = getelementptr i64, ptr %r356.ptr, i64 3
  store i64 %r354, ptr %r356.f3, align 8
  %r356.f4 = getelementptr i64, ptr %r356.ptr, i64 4
  store i64 %r355, ptr %r356.f4, align 8
  %r356 = ptrtoint ptr %r356.ptr to i64
  %r357 = load i64, ptr %slot.p, align 8
  %r358.ptr = call ptr @nova_rt_struct_alloc(i64 16)
  %r358.f0 = getelementptr i64, ptr %r358.ptr, i64 0
  store i64 %r356, ptr %r358.f0, align 8
  %r358.f1 = getelementptr i64, ptr %r358.ptr, i64 1
  store i64 %r357, ptr %r358.f1, align 8
  %r358 = ptrtoint ptr %r358.ptr to i64
  br label %endif308
else307:
  %r359 = load i64, ptr %slot.kind, align 8
  %r360.p = getelementptr inbounds [3 x i8], ptr @.str.43, i64 0, i64 0
  %r360 = ptrtoint ptr %r360.p to i64
  %r361 = call i64 @nova_rt_eq(i64 %r359, i64 %r360)
  %r362 = load i64, ptr %slot.val, align 8
  %r363.p = getelementptr inbounds [3 x i8], ptr @.str.6, i64 0, i64 0
  %r363 = ptrtoint ptr %r363.p to i64
  %r364 = call i64 @nova_rt_eq(i64 %r362, i64 %r363)
  %r365.cmp = icmp ne i64 %r361, 0
  %r365.cmp2 = icmp ne i64 %r364, 0
  %r365.and = and i1 %r365.cmp, %r365.cmp2
  %r365 = zext i1 %r365.and to i64
  %br_then318 = icmp ne i64 %r365, 0
  br i1 %br_then318, label %then318, label %else319
then318:
  %r366 = load i64, ptr %slot.tokens, align 8
  %r367 = load i64, ptr %slot.pos, align 8
  %r368 = call i64 @parse_if_expr(i64 %r366, i64 %r367)
  br label %endif320
else319:
  %r369 = load i64, ptr %slot.kind, align 8
  %r370.p = getelementptr inbounds [3 x i8], ptr @.str.43, i64 0, i64 0
  %r370 = ptrtoint ptr %r370.p to i64
  %r371 = call i64 @nova_rt_eq(i64 %r369, i64 %r370)
  %r372 = load i64, ptr %slot.val, align 8
  %r373.p = getelementptr inbounds [6 x i8], ptr @.str.10, i64 0, i64 0
  %r373 = ptrtoint ptr %r373.p to i64
  %r374 = call i64 @nova_rt_eq(i64 %r372, i64 %r373)
  %r375.cmp = icmp ne i64 %r371, 0
  %r375.cmp2 = icmp ne i64 %r374, 0
  %r375.and = and i1 %r375.cmp, %r375.cmp2
  %r375 = zext i1 %r375.and to i64
  %br_then321 = icmp ne i64 %r375, 0
  br i1 %br_then321, label %then321, label %else322
then321:
  %r376 = load i64, ptr %slot.tokens, align 8
  %r377 = load i64, ptr %slot.pos, align 8
  %r378 = call i64 @parse_match_expr(i64 %r376, i64 %r377)
  br label %endif323
else322:
  %r379 = load i64, ptr %slot.kind, align 8
  %r380.p = getelementptr inbounds [3 x i8], ptr @.str.43, i64 0, i64 0
  %r380 = ptrtoint ptr %r380.p to i64
  %r381 = call i64 @nova_rt_eq(i64 %r379, i64 %r380)
  %r382 = load i64, ptr %slot.val, align 8
  %r383.p = getelementptr inbounds [4 x i8], ptr @.str.8, i64 0, i64 0
  %r383 = ptrtoint ptr %r383.p to i64
  %r384 = call i64 @nova_rt_eq(i64 %r382, i64 %r383)
  %r385.cmp = icmp ne i64 %r381, 0
  %r385.cmp2 = icmp ne i64 %r384, 0
  %r385.and = and i1 %r385.cmp, %r385.cmp2
  %r385 = zext i1 %r385.and to i64
  %br_then324 = icmp ne i64 %r385, 0
  br i1 %br_then324, label %then324, label %else325
then324:
  %r386 = load i64, ptr %slot.tokens, align 8
  %r387 = load i64, ptr %slot.pos, align 8
  %r388 = call i64 @parse_for_expr(i64 %r386, i64 %r387)
  br label %endif326
else325:
  %r389 = add i64 0, 0
  %r390.p = getelementptr inbounds [33 x i8], ptr @.str.123, i64 0, i64 0
  %r390 = ptrtoint ptr %r390.p to i64
  %r391 = load i64, ptr %slot.kind, align 8
  %r392 = call i64 @nova_rt_str_concat(i64 %r390, i64 %r391)
  %r393.p = getelementptr inbounds [2 x i8], ptr @.str.59, i64 0, i64 0
  %r393 = ptrtoint ptr %r393.p to i64
  %r394 = call i64 @nova_rt_str_concat(i64 %r392, i64 %r393)
  %r395 = load i64, ptr %slot.val, align 8
  %r396 = call i64 @nova_rt_str_concat(i64 %r394, i64 %r395)
  %r397.p = getelementptr inbounds [11 x i8], ptr @.str.124, i64 0, i64 0
  %r397 = ptrtoint ptr %r397.p to i64
  %r398 = call i64 @nova_rt_str_concat(i64 %r396, i64 %r397)
  %r399 = load i64, ptr %slot.tokens, align 8
  %r400 = load i64, ptr %slot.pos, align 8
  %r401 = call i64 @tok_line(i64 %r399, i64 %r400)
  %r402 = call i64 @nova_rt_int_to_str(i64 %r401)
  %r403 = call i64 @nova_rt_str_concat(i64 %r398, i64 %r402)
  %r404 = call i64 @nova_rt_assert(i64 %r389, i64 %r403)
  %r405 = call i64 @null_expr()
  %r406 = load i64, ptr %slot.pos, align 8
  %r407.ptr = call ptr @nova_rt_struct_alloc(i64 16)
  %r407.f0 = getelementptr i64, ptr %r407.ptr, i64 0
  store i64 %r405, ptr %r407.f0, align 8
  %r407.f1 = getelementptr i64, ptr %r407.ptr, i64 1
  store i64 %r406, ptr %r407.f1, align 8
  %r407 = ptrtoint ptr %r407.ptr to i64
  br label %endif326
endif326:
  br label %endif323
endif323:
  br label %endif320
endif320:
  br label %endif308
endif308:
  br label %endif299
endif299:
  br label %endif290
endif290:
  br label %endif287
endif287:
  br label %endif284
endif284:
  br label %endif281
endif281:
  br label %endif278
endif278:
  br label %endif275
endif275:
  br label %endif272
endif272:
  br label %endif269
endif269:
  br label %endif266
endif266:
  br label %endif263
endif263:
  br label %endif260
endif260:
  br label %endif257
endif257:
  ret i64 0
}

define i64 @parse_call_args(i64 %p0, i64 %p1, i64 %p2) nounwind {
entry:
  %slot.tokens = alloca i64, align 8
  store i64 %p0, ptr %slot.tokens, align 8
  %slot.pos = alloca i64, align 8
  store i64 %p1, ptr %slot.pos, align 8
  %slot.callee = alloca i64, align 8
  store i64 %p2, ptr %slot.callee, align 8
  %slot.p = alloca i64, align 8
  store i64 0, ptr %slot.p, align 8
  %slot.args = alloca i64, align 8
  store i64 0, ptr %slot.args, align 8
  %slot.arg_r = alloca i64, align 8
  store i64 0, ptr %slot.arg_r, align 8
  %r0 = load i64, ptr %slot.pos, align 8
  %r1 = add i64 1, 0
  %r2 = call i64 @nova_rt_add(i64 %r0, i64 %r1)
  store i64 %r2, ptr %slot.p, align 8
  %r3 = call i64 @nova_rt_list_create()
  store i64 %r3, ptr %slot.args, align 8
  br label %while_hdr327
while_hdr327:
  %r4 = load i64, ptr %slot.tokens, align 8
  %r5 = load i64, ptr %slot.p, align 8
  %r6 = call i64 @tv(i64 %r4, i64 %r5)
  %r7.p = getelementptr inbounds [2 x i8], ptr @.str.60, i64 0, i64 0
  %r7 = ptrtoint ptr %r7.p to i64
  %r8 = call i64 @nova_rt_neq(i64 %r6, i64 %r7)
  %br_while_body328 = icmp ne i64 %r8, 0
  br i1 %br_while_body328, label %while_body328, label %while_exit329
while_body328:
  %r9 = load i64, ptr %slot.args, align 8
  %r10 = call i64 @nova_rt_len_any(i64 %r9)
  %r11 = add i64 0, 0
  %r12.cmp = icmp sgt i64 %r10, %r11
  %r12 = zext i1 %r12.cmp to i64
  %br_then330 = icmp ne i64 %r12, 0
  br i1 %br_then330, label %then330, label %else331
then330:
  %r13 = load i64, ptr %slot.tokens, align 8
  %r14 = load i64, ptr %slot.p, align 8
  %r15.p = getelementptr inbounds [2 x i8], ptr @.str.66, i64 0, i64 0
  %r15 = ptrtoint ptr %r15.p to i64
  %r16 = call i64 @expect(i64 %r13, i64 %r14, i64 %r15)
  store i64 %r16, ptr %slot.p, align 8
  br label %endif332
else331:
  br label %endif332
endif332:
  %r17 = load i64, ptr %slot.tokens, align 8
  %r18 = load i64, ptr %slot.p, align 8
  %r19 = add i64 0, 0
  %r20 = call i64 @parse_expr(i64 %r17, i64 %r18, i64 %r19)
  store i64 %r20, ptr %slot.arg_r, align 8
  %r21 = load i64, ptr %slot.args, align 8
  %r22 = add i64 0, 0
  %r23 = call i64 @nova_rt_list_append(i64 %r21, i64 %r22)
  %r24 = add i64 0, 0
  store i64 %r24, ptr %slot.p, align 8
  br label %while_hdr327
while_exit329:
  %r25 = load i64, ptr %slot.tokens, align 8
  %r26 = load i64, ptr %slot.p, align 8
  %r27.p = getelementptr inbounds [2 x i8], ptr @.str.60, i64 0, i64 0
  %r27 = ptrtoint ptr %r27.p to i64
  %r28 = call i64 @expect(i64 %r25, i64 %r26, i64 %r27)
  store i64 %r28, ptr %slot.p, align 8
  ret i64 0
}

define i64 @parse_index(i64 %p0, i64 %p1, i64 %p2) nounwind {
entry:
  %slot.tokens = alloca i64, align 8
  store i64 %p0, ptr %slot.tokens, align 8
  %slot.pos = alloca i64, align 8
  store i64 %p1, ptr %slot.pos, align 8
  %slot.target = alloca i64, align 8
  store i64 %p2, ptr %slot.target, align 8
  %slot.p = alloca i64, align 8
  store i64 0, ptr %slot.p, align 8
  %slot.idx_r = alloca i64, align 8
  store i64 0, ptr %slot.idx_r, align 8
  %r0 = load i64, ptr %slot.pos, align 8
  %r1 = add i64 1, 0
  %r2 = call i64 @nova_rt_add(i64 %r0, i64 %r1)
  store i64 %r2, ptr %slot.p, align 8
  %r3 = load i64, ptr %slot.tokens, align 8
  %r4 = load i64, ptr %slot.p, align 8
  %r5 = add i64 0, 0
  %r6 = call i64 @parse_expr(i64 %r3, i64 %r4, i64 %r5)
  store i64 %r6, ptr %slot.idx_r, align 8
  %r7 = load i64, ptr %slot.tokens, align 8
  %r8 = add i64 0, 0
  %r9.p = getelementptr inbounds [2 x i8], ptr @.str.62, i64 0, i64 0
  %r9 = ptrtoint ptr %r9.p to i64
  %r10 = call i64 @expect(i64 %r7, i64 %r8, i64 %r9)
  store i64 %r10, ptr %slot.p, align 8
  %r11.p = getelementptr inbounds [6 x i8], ptr @.str.125, i64 0, i64 0
  %r11 = ptrtoint ptr %r11.p to i64
  %r12.p = getelementptr inbounds [1 x i8], ptr @.str.42, i64 0, i64 0
  %r12 = ptrtoint ptr %r12.p to i64
  %r13 = add i64 0, 0
  %r15 = load i64, ptr %slot.target, align 8
  %r16 = add i64 0, 0
  %r14 = call i64 @nova_rt_list_create()
  call i64 @nova_rt_list_append(i64 %r14, i64 %r15)
  call i64 @nova_rt_list_append(i64 %r14, i64 %r16)
  %r17 = call i64 @nova_rt_list_create()
  %r18.ptr = call ptr @nova_rt_struct_alloc(i64 40)
  %r18.f0 = getelementptr i64, ptr %r18.ptr, i64 0
  store i64 %r11, ptr %r18.f0, align 8
  %r18.f1 = getelementptr i64, ptr %r18.ptr, i64 1
  store i64 %r12, ptr %r18.f1, align 8
  %r18.f2 = getelementptr i64, ptr %r18.ptr, i64 2
  store i64 %r13, ptr %r18.f2, align 8
  %r18.f3 = getelementptr i64, ptr %r18.ptr, i64 3
  store i64 %r14, ptr %r18.f3, align 8
  %r18.f4 = getelementptr i64, ptr %r18.ptr, i64 4
  store i64 %r17, ptr %r18.f4, align 8
  %r18 = ptrtoint ptr %r18.ptr to i64
  %r19 = load i64, ptr %slot.p, align 8
  %r20.ptr = call ptr @nova_rt_struct_alloc(i64 16)
  %r20.f0 = getelementptr i64, ptr %r20.ptr, i64 0
  store i64 %r18, ptr %r20.f0, align 8
  %r20.f1 = getelementptr i64, ptr %r20.ptr, i64 1
  store i64 %r19, ptr %r20.f1, align 8
  %r20 = ptrtoint ptr %r20.ptr to i64
  ret i64 0
}

define i64 @parse_if_expr(i64 %p0, i64 %p1) nounwind {
entry:
  %slot.tokens = alloca i64, align 8
  store i64 %p0, ptr %slot.tokens, align 8
  %slot.pos = alloca i64, align 8
  store i64 %p1, ptr %slot.pos, align 8
  %slot.p = alloca i64, align 8
  store i64 0, ptr %slot.p, align 8
  %slot.cond_r = alloca i64, align 8
  store i64 0, ptr %slot.cond_r, align 8
  %slot.p2 = alloca i64, align 8
  store i64 0, ptr %slot.p2, align 8
  %slot.then_r = alloca i64, align 8
  store i64 0, ptr %slot.then_r, align 8
  %slot.p3 = alloca i64, align 8
  store i64 0, ptr %slot.p3, align 8
  %slot.p4 = alloca i64, align 8
  store i64 0, ptr %slot.p4, align 8
  %slot.else_r = alloca i64, align 8
  store i64 0, ptr %slot.else_r, align 8
  %r0 = load i64, ptr %slot.pos, align 8
  %r1 = add i64 1, 0
  %r2 = call i64 @nova_rt_add(i64 %r0, i64 %r1)
  store i64 %r2, ptr %slot.p, align 8
  %r3 = load i64, ptr %slot.tokens, align 8
  %r4 = load i64, ptr %slot.p, align 8
  %r5 = add i64 0, 0
  %r6 = call i64 @parse_expr(i64 %r3, i64 %r4, i64 %r5)
  store i64 %r6, ptr %slot.cond_r, align 8
  %r7 = load i64, ptr %slot.tokens, align 8
  %r8 = add i64 0, 0
  %r9 = call i64 @skip_nl(i64 %r7, i64 %r8)
  store i64 %r9, ptr %slot.p2, align 8
  %r10 = load i64, ptr %slot.tokens, align 8
  %r11 = load i64, ptr %slot.p2, align 8
  %r12 = add i64 0, 0
  %r13 = call i64 @parse_expr(i64 %r10, i64 %r11, i64 %r12)
  store i64 %r13, ptr %slot.then_r, align 8
  %r14 = load i64, ptr %slot.tokens, align 8
  %r15 = add i64 0, 0
  %r16 = call i64 @skip_nl(i64 %r14, i64 %r15)
  store i64 %r16, ptr %slot.p3, align 8
  %r17 = load i64, ptr %slot.tokens, align 8
  %r18 = load i64, ptr %slot.p3, align 8
  %r19 = call i64 @tk(i64 %r17, i64 %r18)
  %r20.p = getelementptr inbounds [3 x i8], ptr @.str.43, i64 0, i64 0
  %r20 = ptrtoint ptr %r20.p to i64
  %r21 = call i64 @nova_rt_eq(i64 %r19, i64 %r20)
  %r22 = load i64, ptr %slot.tokens, align 8
  %r23 = load i64, ptr %slot.p3, align 8
  %r24 = call i64 @tv(i64 %r22, i64 %r23)
  %r25.p = getelementptr inbounds [5 x i8], ptr @.str.7, i64 0, i64 0
  %r25 = ptrtoint ptr %r25.p to i64
  %r26 = call i64 @nova_rt_eq(i64 %r24, i64 %r25)
  %r27.cmp = icmp ne i64 %r21, 0
  %r27.cmp2 = icmp ne i64 %r26, 0
  %r27.and = and i1 %r27.cmp, %r27.cmp2
  %r27 = zext i1 %r27.and to i64
  %br_then333 = icmp ne i64 %r27, 0
  br i1 %br_then333, label %then333, label %else334
then333:
  %r28 = load i64, ptr %slot.tokens, align 8
  %r29 = load i64, ptr %slot.p3, align 8
  %r30 = add i64 1, 0
  %r31 = call i64 @nova_rt_add(i64 %r29, i64 %r30)
  %r32 = call i64 @skip_nl(i64 %r28, i64 %r31)
  store i64 %r32, ptr %slot.p4, align 8
  %r33 = load i64, ptr %slot.tokens, align 8
  %r34 = load i64, ptr %slot.p4, align 8
  %r35 = add i64 0, 0
  %r36 = call i64 @parse_expr(i64 %r33, i64 %r34, i64 %r35)
  store i64 %r36, ptr %slot.else_r, align 8
  %r37.p = getelementptr inbounds [3 x i8], ptr @.str.6, i64 0, i64 0
  %r37 = ptrtoint ptr %r37.p to i64
  %r38.p = getelementptr inbounds [1 x i8], ptr @.str.42, i64 0, i64 0
  %r38 = ptrtoint ptr %r38.p to i64
  %r39 = add i64 0, 0
  %r41 = add i64 0, 0
  %r42 = add i64 0, 0
  %r43 = add i64 0, 0
  %r40 = call i64 @nova_rt_list_create()
  call i64 @nova_rt_list_append(i64 %r40, i64 %r41)
  call i64 @nova_rt_list_append(i64 %r40, i64 %r42)
  call i64 @nova_rt_list_append(i64 %r40, i64 %r43)
  %r44 = call i64 @nova_rt_list_create()
  %r45.ptr = call ptr @nova_rt_struct_alloc(i64 40)
  %r45.f0 = getelementptr i64, ptr %r45.ptr, i64 0
  store i64 %r37, ptr %r45.f0, align 8
  %r45.f1 = getelementptr i64, ptr %r45.ptr, i64 1
  store i64 %r38, ptr %r45.f1, align 8
  %r45.f2 = getelementptr i64, ptr %r45.ptr, i64 2
  store i64 %r39, ptr %r45.f2, align 8
  %r45.f3 = getelementptr i64, ptr %r45.ptr, i64 3
  store i64 %r40, ptr %r45.f3, align 8
  %r45.f4 = getelementptr i64, ptr %r45.ptr, i64 4
  store i64 %r44, ptr %r45.f4, align 8
  %r45 = ptrtoint ptr %r45.ptr to i64
  %r46 = add i64 0, 0
  %r47.ptr = call ptr @nova_rt_struct_alloc(i64 16)
  %r47.f0 = getelementptr i64, ptr %r47.ptr, i64 0
  store i64 %r45, ptr %r47.f0, align 8
  %r47.f1 = getelementptr i64, ptr %r47.ptr, i64 1
  store i64 %r46, ptr %r47.f1, align 8
  %r47 = ptrtoint ptr %r47.ptr to i64
  br label %endif335
else334:
  %r48.p = getelementptr inbounds [3 x i8], ptr @.str.6, i64 0, i64 0
  %r48 = ptrtoint ptr %r48.p to i64
  %r49.p = getelementptr inbounds [1 x i8], ptr @.str.42, i64 0, i64 0
  %r49 = ptrtoint ptr %r49.p to i64
  %r50 = add i64 0, 0
  %r52 = add i64 0, 0
  %r53 = add i64 0, 0
  %r51 = call i64 @nova_rt_list_create()
  call i64 @nova_rt_list_append(i64 %r51, i64 %r52)
  call i64 @nova_rt_list_append(i64 %r51, i64 %r53)
  %r54 = call i64 @nova_rt_list_create()
  %r55.ptr = call ptr @nova_rt_struct_alloc(i64 40)
  %r55.f0 = getelementptr i64, ptr %r55.ptr, i64 0
  store i64 %r48, ptr %r55.f0, align 8
  %r55.f1 = getelementptr i64, ptr %r55.ptr, i64 1
  store i64 %r49, ptr %r55.f1, align 8
  %r55.f2 = getelementptr i64, ptr %r55.ptr, i64 2
  store i64 %r50, ptr %r55.f2, align 8
  %r55.f3 = getelementptr i64, ptr %r55.ptr, i64 3
  store i64 %r51, ptr %r55.f3, align 8
  %r55.f4 = getelementptr i64, ptr %r55.ptr, i64 4
  store i64 %r54, ptr %r55.f4, align 8
  %r55 = ptrtoint ptr %r55.ptr to i64
  %r56 = load i64, ptr %slot.p3, align 8
  %r57.ptr = call ptr @nova_rt_struct_alloc(i64 16)
  %r57.f0 = getelementptr i64, ptr %r57.ptr, i64 0
  store i64 %r55, ptr %r57.f0, align 8
  %r57.f1 = getelementptr i64, ptr %r57.ptr, i64 1
  store i64 %r56, ptr %r57.f1, align 8
  %r57 = ptrtoint ptr %r57.ptr to i64
  br label %endif335
endif335:
  ret i64 0
}

define i64 @parse_match_expr(i64 %p0, i64 %p1) nounwind {
entry:
  %slot.tokens = alloca i64, align 8
  store i64 %p0, ptr %slot.tokens, align 8
  %slot.pos = alloca i64, align 8
  store i64 %p1, ptr %slot.pos, align 8
  %slot.p = alloca i64, align 8
  store i64 0, ptr %slot.p, align 8
  %slot.subject_r = alloca i64, align 8
  store i64 0, ptr %slot.subject_r, align 8
  %slot.p2 = alloca i64, align 8
  store i64 0, ptr %slot.p2, align 8
  %slot.arms = alloca i64, align 8
  store i64 0, ptr %slot.arms, align 8
  %slot.pat_r = alloca i64, align 8
  store i64 0, ptr %slot.pat_r, align 8
  %slot.body_r = alloca i64, align 8
  store i64 0, ptr %slot.body_r, align 8
  %r0 = load i64, ptr %slot.pos, align 8
  %r1 = add i64 1, 0
  %r2 = call i64 @nova_rt_add(i64 %r0, i64 %r1)
  store i64 %r2, ptr %slot.p, align 8
  %r3 = load i64, ptr %slot.tokens, align 8
  %r4 = load i64, ptr %slot.p, align 8
  %r5 = add i64 0, 0
  %r6 = call i64 @parse_expr(i64 %r3, i64 %r4, i64 %r5)
  store i64 %r6, ptr %slot.subject_r, align 8
  %r7 = load i64, ptr %slot.tokens, align 8
  %r8 = add i64 0, 0
  %r9 = call i64 @skip_nl(i64 %r7, i64 %r8)
  store i64 %r9, ptr %slot.p2, align 8
  %r10 = call i64 @nova_rt_list_create()
  store i64 %r10, ptr %slot.arms, align 8
  br label %while_hdr336
while_hdr336:
  %r11 = load i64, ptr %slot.tokens, align 8
  %r12 = load i64, ptr %slot.p2, align 8
  %r13 = call i64 @tk(i64 %r11, i64 %r12)
  %r14.p = getelementptr inbounds [4 x i8], ptr @.str.107, i64 0, i64 0
  %r14 = ptrtoint ptr %r14.p to i64
  %r15 = call i64 @nova_rt_neq(i64 %r13, i64 %r14)
  %r16 = load i64, ptr %slot.tokens, align 8
  %r17 = load i64, ptr %slot.p2, align 8
  %r18 = call i64 @tk(i64 %r16, i64 %r17)
  %r19.p = getelementptr inbounds [8 x i8], ptr @.str.37, i64 0, i64 0
  %r19 = ptrtoint ptr %r19.p to i64
  %r20 = call i64 @nova_rt_neq(i64 %r18, i64 %r19)
  %r21.cmp = icmp ne i64 %r15, 0
  %r21.cmp2 = icmp ne i64 %r20, 0
  %r21.and = and i1 %r21.cmp, %r21.cmp2
  %r21 = zext i1 %r21.and to i64
  %br_while_body337 = icmp ne i64 %r21, 0
  br i1 %br_while_body337, label %while_body337, label %while_exit338
while_body337:
  %r22 = load i64, ptr %slot.tokens, align 8
  %r23 = load i64, ptr %slot.p2, align 8
  %r24 = call i64 @parse_pattern(i64 %r22, i64 %r23)
  store i64 %r24, ptr %slot.pat_r, align 8
  %r25 = load i64, ptr %slot.tokens, align 8
  %r26 = add i64 0, 0
  %r27 = call i64 @skip_nl(i64 %r25, i64 %r26)
  store i64 %r27, ptr %slot.p2, align 8
  %r28 = load i64, ptr %slot.tokens, align 8
  %r29 = load i64, ptr %slot.p2, align 8
  %r30.p = getelementptr inbounds [3 x i8], ptr @.str.90, i64 0, i64 0
  %r30 = ptrtoint ptr %r30.p to i64
  %r31 = call i64 @expect(i64 %r28, i64 %r29, i64 %r30)
  store i64 %r31, ptr %slot.p2, align 8
  %r32 = load i64, ptr %slot.tokens, align 8
  %r33 = load i64, ptr %slot.p2, align 8
  %r34 = call i64 @skip_nl(i64 %r32, i64 %r33)
  store i64 %r34, ptr %slot.p2, align 8
  %r35 = load i64, ptr %slot.tokens, align 8
  %r36 = load i64, ptr %slot.p2, align 8
  %r37 = add i64 0, 0
  %r38 = call i64 @parse_expr(i64 %r35, i64 %r36, i64 %r37)
  store i64 %r38, ptr %slot.body_r, align 8
  %r39 = load i64, ptr %slot.arms, align 8
  %r40.p = getelementptr inbounds [4 x i8], ptr @.str.126, i64 0, i64 0
  %r40 = ptrtoint ptr %r40.p to i64
  %r41.p = getelementptr inbounds [1 x i8], ptr @.str.42, i64 0, i64 0
  %r41 = ptrtoint ptr %r41.p to i64
  %r42 = add i64 0, 0
  %r44 = add i64 0, 0
  %r45 = add i64 0, 0
  %r43 = call i64 @nova_rt_list_create()
  call i64 @nova_rt_list_append(i64 %r43, i64 %r44)
  call i64 @nova_rt_list_append(i64 %r43, i64 %r45)
  %r46 = call i64 @nova_rt_list_create()
  %r47.ptr = call ptr @nova_rt_struct_alloc(i64 40)
  %r47.f0 = getelementptr i64, ptr %r47.ptr, i64 0
  store i64 %r40, ptr %r47.f0, align 8
  %r47.f1 = getelementptr i64, ptr %r47.ptr, i64 1
  store i64 %r41, ptr %r47.f1, align 8
  %r47.f2 = getelementptr i64, ptr %r47.ptr, i64 2
  store i64 %r42, ptr %r47.f2, align 8
  %r47.f3 = getelementptr i64, ptr %r47.ptr, i64 3
  store i64 %r43, ptr %r47.f3, align 8
  %r47.f4 = getelementptr i64, ptr %r47.ptr, i64 4
  store i64 %r46, ptr %r47.f4, align 8
  %r47 = ptrtoint ptr %r47.ptr to i64
  %r48 = call i64 @nova_rt_list_append(i64 %r39, i64 %r47)
  %r49 = load i64, ptr %slot.tokens, align 8
  %r50 = add i64 0, 0
  %r51 = call i64 @skip_nl(i64 %r49, i64 %r50)
  store i64 %r51, ptr %slot.p2, align 8
  br label %while_hdr336
while_exit338:
  %r52.p = getelementptr inbounds [6 x i8], ptr @.str.10, i64 0, i64 0
  %r52 = ptrtoint ptr %r52.p to i64
  %r53.p = getelementptr inbounds [1 x i8], ptr @.str.42, i64 0, i64 0
  %r53 = ptrtoint ptr %r53.p to i64
  %r54 = add i64 0, 0
  %r56 = add i64 0, 0
  %r55 = call i64 @nova_rt_list_create()
  call i64 @nova_rt_list_append(i64 %r55, i64 %r56)
  %r57 = load i64, ptr %slot.arms, align 8
  %r58 = call i64 @nova_rt_add(i64 %r55, i64 %r57)
  %r59 = call i64 @nova_rt_list_create()
  %r60.ptr = call ptr @nova_rt_struct_alloc(i64 40)
  %r60.f0 = getelementptr i64, ptr %r60.ptr, i64 0
  store i64 %r52, ptr %r60.f0, align 8
  %r60.f1 = getelementptr i64, ptr %r60.ptr, i64 1
  store i64 %r53, ptr %r60.f1, align 8
  %r60.f2 = getelementptr i64, ptr %r60.ptr, i64 2
  store i64 %r54, ptr %r60.f2, align 8
  %r60.f3 = getelementptr i64, ptr %r60.ptr, i64 3
  store i64 %r58, ptr %r60.f3, align 8
  %r60.f4 = getelementptr i64, ptr %r60.ptr, i64 4
  store i64 %r59, ptr %r60.f4, align 8
  %r60 = ptrtoint ptr %r60.ptr to i64
  %r61 = load i64, ptr %slot.p2, align 8
  %r62.ptr = call ptr @nova_rt_struct_alloc(i64 16)
  %r62.f0 = getelementptr i64, ptr %r62.ptr, i64 0
  store i64 %r60, ptr %r62.f0, align 8
  %r62.f1 = getelementptr i64, ptr %r62.ptr, i64 1
  store i64 %r61, ptr %r62.f1, align 8
  %r62 = ptrtoint ptr %r62.ptr to i64
  ret i64 0
}

define i64 @parse_pattern(i64 %p0, i64 %p1) nounwind {
entry:
  %slot.tokens = alloca i64, align 8
  store i64 %p0, ptr %slot.tokens, align 8
  %slot.pos = alloca i64, align 8
  store i64 %p1, ptr %slot.pos, align 8
  %slot.kind = alloca i64, align 8
  store i64 0, ptr %slot.kind, align 8
  %slot.val = alloca i64, align 8
  store i64 0, ptr %slot.val, align 8
  %slot.name = alloca i64, align 8
  store i64 0, ptr %slot.name, align 8
  %slot.p = alloca i64, align 8
  store i64 0, ptr %slot.p, align 8
  %slot.fields = alloca i64, align 8
  store i64 0, ptr %slot.fields, align 8
  %r0 = load i64, ptr %slot.tokens, align 8
  %r1 = load i64, ptr %slot.pos, align 8
  %r2 = call i64 @tk(i64 %r0, i64 %r1)
  store i64 %r2, ptr %slot.kind, align 8
  %r3 = load i64, ptr %slot.tokens, align 8
  %r4 = load i64, ptr %slot.pos, align 8
  %r5 = call i64 @tv(i64 %r3, i64 %r4)
  store i64 %r5, ptr %slot.val, align 8
  %r6 = load i64, ptr %slot.kind, align 8
  %r7.p = getelementptr inbounds [6 x i8], ptr @.str.44, i64 0, i64 0
  %r7 = ptrtoint ptr %r7.p to i64
  %r8 = call i64 @nova_rt_eq(i64 %r6, i64 %r7)
  %br_then339 = icmp ne i64 %r8, 0
  br i1 %br_then339, label %then339, label %else340
then339:
  %r9 = load i64, ptr %slot.pos, align 8
  %r10 = add i64 1, 0
  %r11 = call i64 @nova_rt_add(i64 %r9, i64 %r10)
  %r12 = load i64, ptr %slot.tokens, align 8
  %r13 = call i64 @nova_rt_len_any(i64 %r12)
  %r14.cmp = icmp slt i64 %r11, %r13
  %r14 = zext i1 %r14.cmp to i64
  %r15 = load i64, ptr %slot.tokens, align 8
  %r16 = load i64, ptr %slot.pos, align 8
  %r17 = add i64 1, 0
  %r18 = call i64 @nova_rt_add(i64 %r16, i64 %r17)
  %r19 = call i64 @tv(i64 %r15, i64 %r18)
  %r20.p = getelementptr inbounds [2 x i8], ptr @.str.59, i64 0, i64 0
  %r20 = ptrtoint ptr %r20.p to i64
  %r21 = call i64 @nova_rt_eq(i64 %r19, i64 %r20)
  %r22.cmp = icmp ne i64 %r14, 0
  %r22.cmp2 = icmp ne i64 %r21, 0
  %r22.and = and i1 %r22.cmp, %r22.cmp2
  %r22 = zext i1 %r22.and to i64
  %br_then342 = icmp ne i64 %r22, 0
  br i1 %br_then342, label %then342, label %else343
then342:
  %r23 = load i64, ptr %slot.val, align 8
  store i64 %r23, ptr %slot.name, align 8
  %r24 = load i64, ptr %slot.pos, align 8
  %r25 = add i64 2, 0
  %r26 = call i64 @nova_rt_add(i64 %r24, i64 %r25)
  store i64 %r26, ptr %slot.p, align 8
  %r27 = call i64 @nova_rt_list_create()
  store i64 %r27, ptr %slot.fields, align 8
  br label %while_hdr345
while_hdr345:
  %r28 = load i64, ptr %slot.tokens, align 8
  %r29 = load i64, ptr %slot.p, align 8
  %r30 = call i64 @tv(i64 %r28, i64 %r29)
  %r31.p = getelementptr inbounds [2 x i8], ptr @.str.60, i64 0, i64 0
  %r31 = ptrtoint ptr %r31.p to i64
  %r32 = call i64 @nova_rt_neq(i64 %r30, i64 %r31)
  %br_while_body346 = icmp ne i64 %r32, 0
  br i1 %br_while_body346, label %while_body346, label %while_exit347
while_body346:
  %r33 = load i64, ptr %slot.fields, align 8
  %r34 = call i64 @nova_rt_len_any(i64 %r33)
  %r35 = add i64 0, 0
  %r36.cmp = icmp sgt i64 %r34, %r35
  %r36 = zext i1 %r36.cmp to i64
  %br_then348 = icmp ne i64 %r36, 0
  br i1 %br_then348, label %then348, label %else349
then348:
  %r37 = load i64, ptr %slot.tokens, align 8
  %r38 = load i64, ptr %slot.p, align 8
  %r39.p = getelementptr inbounds [2 x i8], ptr @.str.66, i64 0, i64 0
  %r39 = ptrtoint ptr %r39.p to i64
  %r40 = call i64 @expect(i64 %r37, i64 %r38, i64 %r39)
  store i64 %r40, ptr %slot.p, align 8
  br label %endif350
else349:
  br label %endif350
endif350:
  %r41 = load i64, ptr %slot.fields, align 8
  %r42.p = getelementptr inbounds [8 x i8], ptr @.str.127, i64 0, i64 0
  %r42 = ptrtoint ptr %r42.p to i64
  %r43 = load i64, ptr %slot.tokens, align 8
  %r44 = load i64, ptr %slot.p, align 8
  %r45 = call i64 @tv(i64 %r43, i64 %r44)
  %r46 = add i64 0, 0
  %r47 = call i64 @nova_rt_list_create()
  %r48 = call i64 @nova_rt_list_create()
  %r49.ptr = call ptr @nova_rt_struct_alloc(i64 40)
  %r49.f0 = getelementptr i64, ptr %r49.ptr, i64 0
  store i64 %r42, ptr %r49.f0, align 8
  %r49.f1 = getelementptr i64, ptr %r49.ptr, i64 1
  store i64 %r45, ptr %r49.f1, align 8
  %r49.f2 = getelementptr i64, ptr %r49.ptr, i64 2
  store i64 %r46, ptr %r49.f2, align 8
  %r49.f3 = getelementptr i64, ptr %r49.ptr, i64 3
  store i64 %r47, ptr %r49.f3, align 8
  %r49.f4 = getelementptr i64, ptr %r49.ptr, i64 4
  store i64 %r48, ptr %r49.f4, align 8
  %r49 = ptrtoint ptr %r49.ptr to i64
  %r50 = call i64 @nova_rt_list_append(i64 %r41, i64 %r49)
  %r51 = load i64, ptr %slot.p, align 8
  %r52 = add i64 1, 0
  %r53 = call i64 @nova_rt_add(i64 %r51, i64 %r52)
  store i64 %r53, ptr %slot.p, align 8
  br label %while_hdr345
while_exit347:
  %r54 = load i64, ptr %slot.tokens, align 8
  %r55 = load i64, ptr %slot.p, align 8
  %r56.p = getelementptr inbounds [2 x i8], ptr @.str.60, i64 0, i64 0
  %r56 = ptrtoint ptr %r56.p to i64
  %r57 = call i64 @expect(i64 %r54, i64 %r55, i64 %r56)
  store i64 %r57, ptr %slot.p, align 8
  %r58.p = getelementptr inbounds [9 x i8], ptr @.str.128, i64 0, i64 0
  %r58 = ptrtoint ptr %r58.p to i64
  %r59 = load i64, ptr %slot.name, align 8
  %r60 = add i64 0, 0
  %r61 = load i64, ptr %slot.fields, align 8
  %r62 = call i64 @nova_rt_list_create()
  %r63.ptr = call ptr @nova_rt_struct_alloc(i64 40)
  %r63.f0 = getelementptr i64, ptr %r63.ptr, i64 0
  store i64 %r58, ptr %r63.f0, align 8
  %r63.f1 = getelementptr i64, ptr %r63.ptr, i64 1
  store i64 %r59, ptr %r63.f1, align 8
  %r63.f2 = getelementptr i64, ptr %r63.ptr, i64 2
  store i64 %r60, ptr %r63.f2, align 8
  %r63.f3 = getelementptr i64, ptr %r63.ptr, i64 3
  store i64 %r61, ptr %r63.f3, align 8
  %r63.f4 = getelementptr i64, ptr %r63.ptr, i64 4
  store i64 %r62, ptr %r63.f4, align 8
  %r63 = ptrtoint ptr %r63.ptr to i64
  %r64 = load i64, ptr %slot.p, align 8
  %r65.ptr = call ptr @nova_rt_struct_alloc(i64 16)
  %r65.f0 = getelementptr i64, ptr %r65.ptr, i64 0
  store i64 %r63, ptr %r65.f0, align 8
  %r65.f1 = getelementptr i64, ptr %r65.ptr, i64 1
  store i64 %r64, ptr %r65.f1, align 8
  %r65 = ptrtoint ptr %r65.ptr to i64
  br label %endif344
else343:
  %r66 = load i64, ptr %slot.val, align 8
  %r67.p = getelementptr inbounds [2 x i8], ptr @.str.0, i64 0, i64 0
  %r67 = ptrtoint ptr %r67.p to i64
  %r68 = call i64 @nova_rt_eq(i64 %r66, i64 %r67)
  %br_then351 = icmp ne i64 %r68, 0
  br i1 %br_then351, label %then351, label %else352
then351:
  %r69.p = getelementptr inbounds [9 x i8], ptr @.str.129, i64 0, i64 0
  %r69 = ptrtoint ptr %r69.p to i64
  %r70.p = getelementptr inbounds [2 x i8], ptr @.str.0, i64 0, i64 0
  %r70 = ptrtoint ptr %r70.p to i64
  %r71 = add i64 0, 0
  %r72 = call i64 @nova_rt_list_create()
  %r73 = call i64 @nova_rt_list_create()
  %r74.ptr = call ptr @nova_rt_struct_alloc(i64 40)
  %r74.f0 = getelementptr i64, ptr %r74.ptr, i64 0
  store i64 %r69, ptr %r74.f0, align 8
  %r74.f1 = getelementptr i64, ptr %r74.ptr, i64 1
  store i64 %r70, ptr %r74.f1, align 8
  %r74.f2 = getelementptr i64, ptr %r74.ptr, i64 2
  store i64 %r71, ptr %r74.f2, align 8
  %r74.f3 = getelementptr i64, ptr %r74.ptr, i64 3
  store i64 %r72, ptr %r74.f3, align 8
  %r74.f4 = getelementptr i64, ptr %r74.ptr, i64 4
  store i64 %r73, ptr %r74.f4, align 8
  %r74 = ptrtoint ptr %r74.ptr to i64
  %r75 = load i64, ptr %slot.pos, align 8
  %r76 = add i64 1, 0
  %r77 = call i64 @nova_rt_add(i64 %r75, i64 %r76)
  %r78.ptr = call ptr @nova_rt_struct_alloc(i64 16)
  %r78.f0 = getelementptr i64, ptr %r78.ptr, i64 0
  store i64 %r74, ptr %r78.f0, align 8
  %r78.f1 = getelementptr i64, ptr %r78.ptr, i64 1
  store i64 %r77, ptr %r78.f1, align 8
  %r78 = ptrtoint ptr %r78.ptr to i64
  br label %endif353
else352:
  %r79.p = getelementptr inbounds [8 x i8], ptr @.str.127, i64 0, i64 0
  %r79 = ptrtoint ptr %r79.p to i64
  %r80 = load i64, ptr %slot.val, align 8
  %r81 = add i64 0, 0
  %r82 = call i64 @nova_rt_list_create()
  %r83 = call i64 @nova_rt_list_create()
  %r84.ptr = call ptr @nova_rt_struct_alloc(i64 40)
  %r84.f0 = getelementptr i64, ptr %r84.ptr, i64 0
  store i64 %r79, ptr %r84.f0, align 8
  %r84.f1 = getelementptr i64, ptr %r84.ptr, i64 1
  store i64 %r80, ptr %r84.f1, align 8
  %r84.f2 = getelementptr i64, ptr %r84.ptr, i64 2
  store i64 %r81, ptr %r84.f2, align 8
  %r84.f3 = getelementptr i64, ptr %r84.ptr, i64 3
  store i64 %r82, ptr %r84.f3, align 8
  %r84.f4 = getelementptr i64, ptr %r84.ptr, i64 4
  store i64 %r83, ptr %r84.f4, align 8
  %r84 = ptrtoint ptr %r84.ptr to i64
  %r85 = load i64, ptr %slot.pos, align 8
  %r86 = add i64 1, 0
  %r87 = call i64 @nova_rt_add(i64 %r85, i64 %r86)
  %r88.ptr = call ptr @nova_rt_struct_alloc(i64 16)
  %r88.f0 = getelementptr i64, ptr %r88.ptr, i64 0
  store i64 %r84, ptr %r88.f0, align 8
  %r88.f1 = getelementptr i64, ptr %r88.ptr, i64 1
  store i64 %r87, ptr %r88.f1, align 8
  %r88 = ptrtoint ptr %r88.ptr to i64
  br label %endif353
endif353:
  br label %endif344
endif344:
  br label %endif341
else340:
  %r89 = load i64, ptr %slot.kind, align 8
  %r90.p = getelementptr inbounds [4 x i8], ptr @.str.49, i64 0, i64 0
  %r90 = ptrtoint ptr %r90.p to i64
  %r91 = call i64 @nova_rt_eq(i64 %r89, i64 %r90)
  %br_then354 = icmp ne i64 %r91, 0
  br i1 %br_then354, label %then354, label %else355
then354:
  %r92.p = getelementptr inbounds [8 x i8], ptr @.str.130, i64 0, i64 0
  %r92 = ptrtoint ptr %r92.p to i64
  %r93 = load i64, ptr %slot.val, align 8
  %r94 = load i64, ptr %slot.val, align 8
  %r95 = call i64 @nova_rt_parse_int(i64 %r94)
  %r96 = call i64 @nova_rt_list_create()
  %r97 = call i64 @nova_rt_list_create()
  %r98.ptr = call ptr @nova_rt_struct_alloc(i64 40)
  %r98.f0 = getelementptr i64, ptr %r98.ptr, i64 0
  store i64 %r92, ptr %r98.f0, align 8
  %r98.f1 = getelementptr i64, ptr %r98.ptr, i64 1
  store i64 %r93, ptr %r98.f1, align 8
  %r98.f2 = getelementptr i64, ptr %r98.ptr, i64 2
  store i64 %r95, ptr %r98.f2, align 8
  %r98.f3 = getelementptr i64, ptr %r98.ptr, i64 3
  store i64 %r96, ptr %r98.f3, align 8
  %r98.f4 = getelementptr i64, ptr %r98.ptr, i64 4
  store i64 %r97, ptr %r98.f4, align 8
  %r98 = ptrtoint ptr %r98.ptr to i64
  %r99 = load i64, ptr %slot.pos, align 8
  %r100 = add i64 1, 0
  %r101 = call i64 @nova_rt_add(i64 %r99, i64 %r100)
  %r102.ptr = call ptr @nova_rt_struct_alloc(i64 16)
  %r102.f0 = getelementptr i64, ptr %r102.ptr, i64 0
  store i64 %r98, ptr %r102.f0, align 8
  %r102.f1 = getelementptr i64, ptr %r102.ptr, i64 1
  store i64 %r101, ptr %r102.f1, align 8
  %r102 = ptrtoint ptr %r102.ptr to i64
  br label %endif356
else355:
  %r103 = load i64, ptr %slot.kind, align 8
  %r104.p = getelementptr inbounds [4 x i8], ptr @.str.56, i64 0, i64 0
  %r104 = ptrtoint ptr %r104.p to i64
  %r105 = call i64 @nova_rt_eq(i64 %r103, i64 %r104)
  %br_then357 = icmp ne i64 %r105, 0
  br i1 %br_then357, label %then357, label %else358
then357:
  %r106.p = getelementptr inbounds [8 x i8], ptr @.str.131, i64 0, i64 0
  %r106 = ptrtoint ptr %r106.p to i64
  %r107 = load i64, ptr %slot.val, align 8
  %r108 = add i64 0, 0
  %r109 = call i64 @nova_rt_list_create()
  %r110 = call i64 @nova_rt_list_create()
  %r111.ptr = call ptr @nova_rt_struct_alloc(i64 40)
  %r111.f0 = getelementptr i64, ptr %r111.ptr, i64 0
  store i64 %r106, ptr %r111.f0, align 8
  %r111.f1 = getelementptr i64, ptr %r111.ptr, i64 1
  store i64 %r107, ptr %r111.f1, align 8
  %r111.f2 = getelementptr i64, ptr %r111.ptr, i64 2
  store i64 %r108, ptr %r111.f2, align 8
  %r111.f3 = getelementptr i64, ptr %r111.ptr, i64 3
  store i64 %r109, ptr %r111.f3, align 8
  %r111.f4 = getelementptr i64, ptr %r111.ptr, i64 4
  store i64 %r110, ptr %r111.f4, align 8
  %r111 = ptrtoint ptr %r111.ptr to i64
  %r112 = load i64, ptr %slot.pos, align 8
  %r113 = add i64 1, 0
  %r114 = call i64 @nova_rt_add(i64 %r112, i64 %r113)
  %r115.ptr = call ptr @nova_rt_struct_alloc(i64 16)
  %r115.f0 = getelementptr i64, ptr %r115.ptr, i64 0
  store i64 %r111, ptr %r115.f0, align 8
  %r115.f1 = getelementptr i64, ptr %r115.ptr, i64 1
  store i64 %r114, ptr %r115.f1, align 8
  %r115 = ptrtoint ptr %r115.ptr to i64
  br label %endif359
else358:
  %r116.p = getelementptr inbounds [9 x i8], ptr @.str.129, i64 0, i64 0
  %r116 = ptrtoint ptr %r116.p to i64
  %r117.p = getelementptr inbounds [2 x i8], ptr @.str.0, i64 0, i64 0
  %r117 = ptrtoint ptr %r117.p to i64
  %r118 = add i64 0, 0
  %r119 = call i64 @nova_rt_list_create()
  %r120 = call i64 @nova_rt_list_create()
  %r121.ptr = call ptr @nova_rt_struct_alloc(i64 40)
  %r121.f0 = getelementptr i64, ptr %r121.ptr, i64 0
  store i64 %r116, ptr %r121.f0, align 8
  %r121.f1 = getelementptr i64, ptr %r121.ptr, i64 1
  store i64 %r117, ptr %r121.f1, align 8
  %r121.f2 = getelementptr i64, ptr %r121.ptr, i64 2
  store i64 %r118, ptr %r121.f2, align 8
  %r121.f3 = getelementptr i64, ptr %r121.ptr, i64 3
  store i64 %r119, ptr %r121.f3, align 8
  %r121.f4 = getelementptr i64, ptr %r121.ptr, i64 4
  store i64 %r120, ptr %r121.f4, align 8
  %r121 = ptrtoint ptr %r121.ptr to i64
  %r122 = load i64, ptr %slot.pos, align 8
  %r123.ptr = call ptr @nova_rt_struct_alloc(i64 16)
  %r123.f0 = getelementptr i64, ptr %r123.ptr, i64 0
  store i64 %r121, ptr %r123.f0, align 8
  %r123.f1 = getelementptr i64, ptr %r123.ptr, i64 1
  store i64 %r122, ptr %r123.f1, align 8
  %r123 = ptrtoint ptr %r123.ptr to i64
  br label %endif359
endif359:
  br label %endif356
endif356:
  br label %endif341
endif341:
  ret i64 0
}

define i64 @parse_for_expr(i64 %p0, i64 %p1) nounwind {
entry:
  %slot.tokens = alloca i64, align 8
  store i64 %p0, ptr %slot.tokens, align 8
  %slot.pos = alloca i64, align 8
  store i64 %p1, ptr %slot.pos, align 8
  %slot.p = alloca i64, align 8
  store i64 0, ptr %slot.p, align 8
  %slot.var_name = alloca i64, align 8
  store i64 0, ptr %slot.var_name, align 8
  %slot.iter_r = alloca i64, align 8
  store i64 0, ptr %slot.iter_r, align 8
  %slot.p2 = alloca i64, align 8
  store i64 0, ptr %slot.p2, align 8
  %slot.body_r = alloca i64, align 8
  store i64 0, ptr %slot.body_r, align 8
  %r0 = load i64, ptr %slot.pos, align 8
  %r1 = add i64 1, 0
  %r2 = call i64 @nova_rt_add(i64 %r0, i64 %r1)
  store i64 %r2, ptr %slot.p, align 8
  %r3 = load i64, ptr %slot.tokens, align 8
  %r4 = load i64, ptr %slot.p, align 8
  %r5 = call i64 @tv(i64 %r3, i64 %r4)
  store i64 %r5, ptr %slot.var_name, align 8
  %r6 = load i64, ptr %slot.p, align 8
  %r7 = add i64 1, 0
  %r8 = call i64 @nova_rt_add(i64 %r6, i64 %r7)
  store i64 %r8, ptr %slot.p, align 8
  %r9 = load i64, ptr %slot.tokens, align 8
  %r10 = load i64, ptr %slot.p, align 8
  %r11 = call i64 @skip_nl(i64 %r9, i64 %r10)
  store i64 %r11, ptr %slot.p, align 8
  %r12 = load i64, ptr %slot.tokens, align 8
  %r13 = load i64, ptr %slot.p, align 8
  %r14 = call i64 @tk(i64 %r12, i64 %r13)
  %r15.p = getelementptr inbounds [3 x i8], ptr @.str.43, i64 0, i64 0
  %r15 = ptrtoint ptr %r15.p to i64
  %r16 = call i64 @nova_rt_eq(i64 %r14, i64 %r15)
  %r17 = load i64, ptr %slot.tokens, align 8
  %r18 = load i64, ptr %slot.p, align 8
  %r19 = call i64 @tv(i64 %r17, i64 %r18)
  %r20.p = getelementptr inbounds [3 x i8], ptr @.str.27, i64 0, i64 0
  %r20 = ptrtoint ptr %r20.p to i64
  %r21 = call i64 @nova_rt_eq(i64 %r19, i64 %r20)
  %r22.cmp = icmp ne i64 %r16, 0
  %r22.cmp2 = icmp ne i64 %r21, 0
  %r22.and = and i1 %r22.cmp, %r22.cmp2
  %r22 = zext i1 %r22.and to i64
  %br_then360 = icmp ne i64 %r22, 0
  br i1 %br_then360, label %then360, label %else361
then360:
  %r23 = load i64, ptr %slot.p, align 8
  %r24 = add i64 1, 0
  %r25 = call i64 @nova_rt_add(i64 %r23, i64 %r24)
  store i64 %r25, ptr %slot.p, align 8
  br label %endif362
else361:
  br label %endif362
endif362:
  %r26 = load i64, ptr %slot.tokens, align 8
  %r27 = load i64, ptr %slot.p, align 8
  %r28 = add i64 0, 0
  %r29 = call i64 @parse_expr(i64 %r26, i64 %r27, i64 %r28)
  store i64 %r29, ptr %slot.iter_r, align 8
  %r30 = load i64, ptr %slot.tokens, align 8
  %r31 = add i64 0, 0
  %r32 = call i64 @skip_nl(i64 %r30, i64 %r31)
  store i64 %r32, ptr %slot.p2, align 8
  %r33 = load i64, ptr %slot.tokens, align 8
  %r34 = load i64, ptr %slot.p2, align 8
  %r35 = add i64 0, 0
  %r36 = call i64 @parse_expr(i64 %r33, i64 %r34, i64 %r35)
  store i64 %r36, ptr %slot.body_r, align 8
  %r37.p = getelementptr inbounds [4 x i8], ptr @.str.8, i64 0, i64 0
  %r37 = ptrtoint ptr %r37.p to i64
  %r38 = load i64, ptr %slot.var_name, align 8
  %r39 = add i64 0, 0
  %r41 = add i64 0, 0
  %r42 = add i64 0, 0
  %r40 = call i64 @nova_rt_list_create()
  call i64 @nova_rt_list_append(i64 %r40, i64 %r41)
  call i64 @nova_rt_list_append(i64 %r40, i64 %r42)
  %r43 = call i64 @nova_rt_list_create()
  %r44.ptr = call ptr @nova_rt_struct_alloc(i64 40)
  %r44.f0 = getelementptr i64, ptr %r44.ptr, i64 0
  store i64 %r37, ptr %r44.f0, align 8
  %r44.f1 = getelementptr i64, ptr %r44.ptr, i64 1
  store i64 %r38, ptr %r44.f1, align 8
  %r44.f2 = getelementptr i64, ptr %r44.ptr, i64 2
  store i64 %r39, ptr %r44.f2, align 8
  %r44.f3 = getelementptr i64, ptr %r44.ptr, i64 3
  store i64 %r40, ptr %r44.f3, align 8
  %r44.f4 = getelementptr i64, ptr %r44.ptr, i64 4
  store i64 %r43, ptr %r44.f4, align 8
  %r44 = ptrtoint ptr %r44.ptr to i64
  %r45 = add i64 0, 0
  %r46.ptr = call ptr @nova_rt_struct_alloc(i64 16)
  %r46.f0 = getelementptr i64, ptr %r46.ptr, i64 0
  store i64 %r44, ptr %r46.f0, align 8
  %r46.f1 = getelementptr i64, ptr %r46.ptr, i64 1
  store i64 %r45, ptr %r46.f1, align 8
  %r46 = ptrtoint ptr %r46.ptr to i64
  ret i64 0
}

define i64 @parse_block(i64 %p0, i64 %p1) nounwind {
entry:
  %slot.tokens = alloca i64, align 8
  store i64 %p0, ptr %slot.tokens, align 8
  %slot.pos = alloca i64, align 8
  store i64 %p1, ptr %slot.pos, align 8
  %slot.stmts = alloca i64, align 8
  store i64 0, ptr %slot.stmts, align 8
  %slot.p = alloca i64, align 8
  store i64 0, ptr %slot.p, align 8
  %slot.sr = alloca i64, align 8
  store i64 0, ptr %slot.sr, align 8
  %r0 = call i64 @nova_rt_list_create()
  store i64 %r0, ptr %slot.stmts, align 8
  %r1 = load i64, ptr %slot.tokens, align 8
  %r2 = load i64, ptr %slot.pos, align 8
  %r3 = call i64 @skip_nl(i64 %r1, i64 %r2)
  store i64 %r3, ptr %slot.p, align 8
  br label %while_hdr363
while_hdr363:
  %r4 = load i64, ptr %slot.tokens, align 8
  %r5 = load i64, ptr %slot.p, align 8
  %r6 = call i64 @tk(i64 %r4, i64 %r5)
  %r7.p = getelementptr inbounds [4 x i8], ptr @.str.107, i64 0, i64 0
  %r7 = ptrtoint ptr %r7.p to i64
  %r8 = call i64 @nova_rt_neq(i64 %r6, i64 %r7)
  %r9 = load i64, ptr %slot.tokens, align 8
  %r10 = load i64, ptr %slot.p, align 8
  %r11 = call i64 @tk(i64 %r9, i64 %r10)
  %r12.p = getelementptr inbounds [3 x i8], ptr @.str.43, i64 0, i64 0
  %r12 = ptrtoint ptr %r12.p to i64
  %r13 = call i64 @nova_rt_neq(i64 %r11, i64 %r12)
  %r14.cmp = icmp ne i64 %r8, 0
  %r14.cmp2 = icmp ne i64 %r13, 0
  %r14.and = and i1 %r14.cmp, %r14.cmp2
  %r14 = zext i1 %r14.and to i64
  %br_while_body364 = icmp ne i64 %r14, 0
  br i1 %br_while_body364, label %while_body364, label %while_exit365
while_body364:
  %r15 = load i64, ptr %slot.tokens, align 8
  %r16 = load i64, ptr %slot.p, align 8
  %r17 = call i64 @parse_stmt(i64 %r15, i64 %r16)
  store i64 %r17, ptr %slot.sr, align 8
  %r18 = load i64, ptr %slot.stmts, align 8
  %r19 = add i64 0, 0
  %r20 = call i64 @nova_rt_list_append(i64 %r18, i64 %r19)
  %r21 = load i64, ptr %slot.tokens, align 8
  %r22 = add i64 0, 0
  %r23 = call i64 @skip_nl(i64 %r21, i64 %r22)
  store i64 %r23, ptr %slot.p, align 8
  br label %while_hdr363
while_exit365:
  %r24.p = getelementptr inbounds [6 x i8], ptr @.str.132, i64 0, i64 0
  %r24 = ptrtoint ptr %r24.p to i64
  %r25.p = getelementptr inbounds [1 x i8], ptr @.str.42, i64 0, i64 0
  %r25 = ptrtoint ptr %r25.p to i64
  %r26 = call i64 @null_expr()
  %r27 = load i64, ptr %slot.stmts, align 8
  %r28 = call i64 @nova_rt_list_create()
  %r29 = call i64 @nova_rt_list_create()
  %r30 = call i64 @nova_rt_list_create()
  %r31.ptr = call ptr @nova_rt_struct_alloc(i64 56)
  %r31.f0 = getelementptr i64, ptr %r31.ptr, i64 0
  store i64 %r24, ptr %r31.f0, align 8
  %r31.f1 = getelementptr i64, ptr %r31.ptr, i64 1
  store i64 %r25, ptr %r31.f1, align 8
  %r31.f2 = getelementptr i64, ptr %r31.ptr, i64 2
  store i64 %r26, ptr %r31.f2, align 8
  %r31.f3 = getelementptr i64, ptr %r31.ptr, i64 3
  store i64 %r27, ptr %r31.f3, align 8
  %r31.f4 = getelementptr i64, ptr %r31.ptr, i64 4
  store i64 %r28, ptr %r31.f4, align 8
  %r31.f5 = getelementptr i64, ptr %r31.ptr, i64 5
  store i64 %r29, ptr %r31.f5, align 8
  %r31.f6 = getelementptr i64, ptr %r31.ptr, i64 6
  store i64 %r30, ptr %r31.f6, align 8
  %r31 = ptrtoint ptr %r31.ptr to i64
  %r32 = load i64, ptr %slot.p, align 8
  %r33.ptr = call ptr @nova_rt_struct_alloc(i64 16)
  %r33.f0 = getelementptr i64, ptr %r33.ptr, i64 0
  store i64 %r31, ptr %r33.f0, align 8
  %r33.f1 = getelementptr i64, ptr %r33.ptr, i64 1
  store i64 %r32, ptr %r33.f1, align 8
  %r33 = ptrtoint ptr %r33.ptr to i64
  ret i64 0
}

define i64 @parse_stmt(i64 %p0, i64 %p1) nounwind {
entry:
  %slot.tokens = alloca i64, align 8
  store i64 %p0, ptr %slot.tokens, align 8
  %slot.pos = alloca i64, align 8
  store i64 %p1, ptr %slot.pos, align 8
  %slot.kind = alloca i64, align 8
  store i64 0, ptr %slot.kind, align 8
  %slot.val = alloca i64, align 8
  store i64 0, ptr %slot.val, align 8
  %slot.ann_name = alloca i64, align 8
  store i64 0, ptr %slot.ann_name, align 8
  %slot.p = alloca i64, align 8
  store i64 0, ptr %slot.p, align 8
  %slot.inner_r = alloca i64, align 8
  store i64 0, ptr %slot.inner_r, align 8
  %slot.expr_r = alloca i64, align 8
  store i64 0, ptr %slot.expr_r, align 8
  %slot.name = alloca i64, align 8
  store i64 0, ptr %slot.name, align 8
  %slot.rhs_r = alloca i64, align 8
  store i64 0, ptr %slot.rhs_r, align 8
  %slot.op = alloca i64, align 8
  store i64 0, ptr %slot.op, align 8
  %r0 = load i64, ptr %slot.tokens, align 8
  %r1 = load i64, ptr %slot.pos, align 8
  %r2 = call i64 @tk(i64 %r0, i64 %r1)
  store i64 %r2, ptr %slot.kind, align 8
  %r3 = load i64, ptr %slot.tokens, align 8
  %r4 = load i64, ptr %slot.pos, align 8
  %r5 = call i64 @tv(i64 %r3, i64 %r4)
  store i64 %r5, ptr %slot.val, align 8
  %r6 = load i64, ptr %slot.kind, align 8
  %r7.p = getelementptr inbounds [3 x i8], ptr @.str.41, i64 0, i64 0
  %r7 = ptrtoint ptr %r7.p to i64
  %r8 = call i64 @nova_rt_eq(i64 %r6, i64 %r7)
  %br_then366 = icmp ne i64 %r8, 0
  br i1 %br_then366, label %then366, label %else367
then366:
  %r9 = load i64, ptr %slot.tokens, align 8
  %r10 = load i64, ptr %slot.pos, align 8
  %r11 = add i64 1, 0
  %r12 = call i64 @nova_rt_add(i64 %r10, i64 %r11)
  %r13 = call i64 @tv(i64 %r9, i64 %r12)
  store i64 %r13, ptr %slot.ann_name, align 8
  %r14 = load i64, ptr %slot.tokens, align 8
  %r15 = load i64, ptr %slot.pos, align 8
  %r16 = add i64 2, 0
  %r17 = call i64 @nova_rt_add(i64 %r15, i64 %r16)
  %r18 = call i64 @skip_nl(i64 %r14, i64 %r17)
  store i64 %r18, ptr %slot.p, align 8
  %r19 = load i64, ptr %slot.tokens, align 8
  %r20 = load i64, ptr %slot.p, align 8
  %r21 = call i64 @parse_stmt(i64 %r19, i64 %r20)
  store i64 %r21, ptr %slot.inner_r, align 8
  br label %endif368
else367:
  %r22 = load i64, ptr %slot.kind, align 8
  %r23.p = getelementptr inbounds [3 x i8], ptr @.str.43, i64 0, i64 0
  %r23 = ptrtoint ptr %r23.p to i64
  %r24 = call i64 @nova_rt_eq(i64 %r22, i64 %r23)
  %r25 = load i64, ptr %slot.val, align 8
  %r26.p = getelementptr inbounds [3 x i8], ptr @.str.4, i64 0, i64 0
  %r26 = ptrtoint ptr %r26.p to i64
  %r27 = call i64 @nova_rt_eq(i64 %r25, i64 %r26)
  %r28.cmp = icmp ne i64 %r24, 0
  %r28.cmp2 = icmp ne i64 %r27, 0
  %r28.and = and i1 %r28.cmp, %r28.cmp2
  %r28 = zext i1 %r28.and to i64
  %br_then369 = icmp ne i64 %r28, 0
  br i1 %br_then369, label %then369, label %else370
then369:
  %r29 = load i64, ptr %slot.tokens, align 8
  %r30 = load i64, ptr %slot.pos, align 8
  %r31 = call i64 @parse_fn_decl(i64 %r29, i64 %r30)
  br label %endif371
else370:
  %r32 = load i64, ptr %slot.kind, align 8
  %r33.p = getelementptr inbounds [3 x i8], ptr @.str.43, i64 0, i64 0
  %r33 = ptrtoint ptr %r33.p to i64
  %r34 = call i64 @nova_rt_eq(i64 %r32, i64 %r33)
  %r35 = load i64, ptr %slot.val, align 8
  %r36.p = getelementptr inbounds [5 x i8], ptr @.str.13, i64 0, i64 0
  %r36 = ptrtoint ptr %r36.p to i64
  %r37 = call i64 @nova_rt_eq(i64 %r35, i64 %r36)
  %r38.cmp = icmp ne i64 %r34, 0
  %r38.cmp2 = icmp ne i64 %r37, 0
  %r38.and = and i1 %r38.cmp, %r38.cmp2
  %r38 = zext i1 %r38.and to i64
  %br_then372 = icmp ne i64 %r38, 0
  br i1 %br_then372, label %then372, label %else373
then372:
  %r39 = load i64, ptr %slot.tokens, align 8
  %r40 = load i64, ptr %slot.pos, align 8
  %r41 = call i64 @parse_type_decl(i64 %r39, i64 %r40)
  br label %endif374
else373:
  %r42 = load i64, ptr %slot.kind, align 8
  %r43.p = getelementptr inbounds [3 x i8], ptr @.str.43, i64 0, i64 0
  %r43 = ptrtoint ptr %r43.p to i64
  %r44 = call i64 @nova_rt_eq(i64 %r42, i64 %r43)
  %r45 = load i64, ptr %slot.val, align 8
  %r46.p = getelementptr inbounds [3 x i8], ptr @.str.6, i64 0, i64 0
  %r46 = ptrtoint ptr %r46.p to i64
  %r47 = call i64 @nova_rt_eq(i64 %r45, i64 %r46)
  %r48.cmp = icmp ne i64 %r44, 0
  %r48.cmp2 = icmp ne i64 %r47, 0
  %r48.and = and i1 %r48.cmp, %r48.cmp2
  %r48 = zext i1 %r48.and to i64
  %br_then375 = icmp ne i64 %r48, 0
  br i1 %br_then375, label %then375, label %else376
then375:
  %r49 = load i64, ptr %slot.tokens, align 8
  %r50 = load i64, ptr %slot.pos, align 8
  %r51 = call i64 @parse_if_stmt(i64 %r49, i64 %r50)
  br label %endif377
else376:
  %r52 = load i64, ptr %slot.kind, align 8
  %r53.p = getelementptr inbounds [3 x i8], ptr @.str.43, i64 0, i64 0
  %r53 = ptrtoint ptr %r53.p to i64
  %r54 = call i64 @nova_rt_eq(i64 %r52, i64 %r53)
  %r55 = load i64, ptr %slot.val, align 8
  %r56.p = getelementptr inbounds [6 x i8], ptr @.str.9, i64 0, i64 0
  %r56 = ptrtoint ptr %r56.p to i64
  %r57 = call i64 @nova_rt_eq(i64 %r55, i64 %r56)
  %r58.cmp = icmp ne i64 %r54, 0
  %r58.cmp2 = icmp ne i64 %r57, 0
  %r58.and = and i1 %r58.cmp, %r58.cmp2
  %r58 = zext i1 %r58.and to i64
  %br_then378 = icmp ne i64 %r58, 0
  br i1 %br_then378, label %then378, label %else379
then378:
  %r59 = load i64, ptr %slot.tokens, align 8
  %r60 = load i64, ptr %slot.pos, align 8
  %r61 = call i64 @parse_while_stmt(i64 %r59, i64 %r60)
  br label %endif380
else379:
  %r62 = load i64, ptr %slot.kind, align 8
  %r63.p = getelementptr inbounds [3 x i8], ptr @.str.43, i64 0, i64 0
  %r63 = ptrtoint ptr %r63.p to i64
  %r64 = call i64 @nova_rt_eq(i64 %r62, i64 %r63)
  %r65 = load i64, ptr %slot.val, align 8
  %r66.p = getelementptr inbounds [4 x i8], ptr @.str.8, i64 0, i64 0
  %r66 = ptrtoint ptr %r66.p to i64
  %r67 = call i64 @nova_rt_eq(i64 %r65, i64 %r66)
  %r68.cmp = icmp ne i64 %r64, 0
  %r68.cmp2 = icmp ne i64 %r67, 0
  %r68.and = and i1 %r68.cmp, %r68.cmp2
  %r68 = zext i1 %r68.and to i64
  %br_then381 = icmp ne i64 %r68, 0
  br i1 %br_then381, label %then381, label %else382
then381:
  %r69 = load i64, ptr %slot.tokens, align 8
  %r70 = load i64, ptr %slot.pos, align 8
  %r71 = call i64 @parse_for_stmt(i64 %r69, i64 %r70)
  br label %endif383
else382:
  %r72 = load i64, ptr %slot.kind, align 8
  %r73.p = getelementptr inbounds [3 x i8], ptr @.str.43, i64 0, i64 0
  %r73 = ptrtoint ptr %r73.p to i64
  %r74 = call i64 @nova_rt_eq(i64 %r72, i64 %r73)
  %r75 = load i64, ptr %slot.val, align 8
  %r76.p = getelementptr inbounds [7 x i8], ptr @.str.5, i64 0, i64 0
  %r76 = ptrtoint ptr %r76.p to i64
  %r77 = call i64 @nova_rt_eq(i64 %r75, i64 %r76)
  %r78.cmp = icmp ne i64 %r74, 0
  %r78.cmp2 = icmp ne i64 %r77, 0
  %r78.and = and i1 %r78.cmp, %r78.cmp2
  %r78 = zext i1 %r78.and to i64
  %br_then384 = icmp ne i64 %r78, 0
  br i1 %br_then384, label %then384, label %else385
then384:
  %r79 = load i64, ptr %slot.pos, align 8
  %r80 = add i64 1, 0
  %r81 = call i64 @nova_rt_add(i64 %r79, i64 %r80)
  store i64 %r81, ptr %slot.p, align 8
  %r82 = load i64, ptr %slot.tokens, align 8
  %r83 = load i64, ptr %slot.p, align 8
  %r84 = call i64 @tk(i64 %r82, i64 %r83)
  %r85.p = getelementptr inbounds [8 x i8], ptr @.str.37, i64 0, i64 0
  %r85 = ptrtoint ptr %r85.p to i64
  %r86 = call i64 @nova_rt_eq(i64 %r84, i64 %r85)
  %r87 = load i64, ptr %slot.tokens, align 8
  %r88 = load i64, ptr %slot.p, align 8
  %r89 = call i64 @tk(i64 %r87, i64 %r88)
  %r90.p = getelementptr inbounds [4 x i8], ptr @.str.107, i64 0, i64 0
  %r90 = ptrtoint ptr %r90.p to i64
  %r91 = call i64 @nova_rt_eq(i64 %r89, i64 %r90)
  %r92.cmp = icmp ne i64 %r86, 0
  %r92.cmp2 = icmp ne i64 %r91, 0
  %r92.or = or i1 %r92.cmp, %r92.cmp2
  %r92 = zext i1 %r92.or to i64
  %br_then387 = icmp ne i64 %r92, 0
  br i1 %br_then387, label %then387, label %else388
then387:
  %r93.p = getelementptr inbounds [7 x i8], ptr @.str.5, i64 0, i64 0
  %r93 = ptrtoint ptr %r93.p to i64
  %r94.p = getelementptr inbounds [1 x i8], ptr @.str.42, i64 0, i64 0
  %r94 = ptrtoint ptr %r94.p to i64
  %r95 = call i64 @null_expr()
  %r96 = call i64 @nova_rt_list_create()
  %r97 = call i64 @nova_rt_list_create()
  %r98 = call i64 @nova_rt_list_create()
  %r99 = call i64 @nova_rt_list_create()
  %r100.ptr = call ptr @nova_rt_struct_alloc(i64 56)
  %r100.f0 = getelementptr i64, ptr %r100.ptr, i64 0
  store i64 %r93, ptr %r100.f0, align 8
  %r100.f1 = getelementptr i64, ptr %r100.ptr, i64 1
  store i64 %r94, ptr %r100.f1, align 8
  %r100.f2 = getelementptr i64, ptr %r100.ptr, i64 2
  store i64 %r95, ptr %r100.f2, align 8
  %r100.f3 = getelementptr i64, ptr %r100.ptr, i64 3
  store i64 %r96, ptr %r100.f3, align 8
  %r100.f4 = getelementptr i64, ptr %r100.ptr, i64 4
  store i64 %r97, ptr %r100.f4, align 8
  %r100.f5 = getelementptr i64, ptr %r100.ptr, i64 5
  store i64 %r98, ptr %r100.f5, align 8
  %r100.f6 = getelementptr i64, ptr %r100.ptr, i64 6
  store i64 %r99, ptr %r100.f6, align 8
  %r100 = ptrtoint ptr %r100.ptr to i64
  %r101 = load i64, ptr %slot.p, align 8
  %r102.ptr = call ptr @nova_rt_struct_alloc(i64 16)
  %r102.f0 = getelementptr i64, ptr %r102.ptr, i64 0
  store i64 %r100, ptr %r102.f0, align 8
  %r102.f1 = getelementptr i64, ptr %r102.ptr, i64 1
  store i64 %r101, ptr %r102.f1, align 8
  %r102 = ptrtoint ptr %r102.ptr to i64
  br label %endif389
else388:
  %r103 = load i64, ptr %slot.tokens, align 8
  %r104 = load i64, ptr %slot.p, align 8
  %r105 = add i64 0, 0
  %r106 = call i64 @parse_expr(i64 %r103, i64 %r104, i64 %r105)
  store i64 %r106, ptr %slot.expr_r, align 8
  %r107.p = getelementptr inbounds [7 x i8], ptr @.str.5, i64 0, i64 0
  %r107 = ptrtoint ptr %r107.p to i64
  %r108.p = getelementptr inbounds [1 x i8], ptr @.str.42, i64 0, i64 0
  %r108 = ptrtoint ptr %r108.p to i64
  %r109 = add i64 0, 0
  %r110 = call i64 @nova_rt_list_create()
  %r111 = call i64 @nova_rt_list_create()
  %r112 = call i64 @nova_rt_list_create()
  %r113 = call i64 @nova_rt_list_create()
  %r114.ptr = call ptr @nova_rt_struct_alloc(i64 56)
  %r114.f0 = getelementptr i64, ptr %r114.ptr, i64 0
  store i64 %r107, ptr %r114.f0, align 8
  %r114.f1 = getelementptr i64, ptr %r114.ptr, i64 1
  store i64 %r108, ptr %r114.f1, align 8
  %r114.f2 = getelementptr i64, ptr %r114.ptr, i64 2
  store i64 %r109, ptr %r114.f2, align 8
  %r114.f3 = getelementptr i64, ptr %r114.ptr, i64 3
  store i64 %r110, ptr %r114.f3, align 8
  %r114.f4 = getelementptr i64, ptr %r114.ptr, i64 4
  store i64 %r111, ptr %r114.f4, align 8
  %r114.f5 = getelementptr i64, ptr %r114.ptr, i64 5
  store i64 %r112, ptr %r114.f5, align 8
  %r114.f6 = getelementptr i64, ptr %r114.ptr, i64 6
  store i64 %r113, ptr %r114.f6, align 8
  %r114 = ptrtoint ptr %r114.ptr to i64
  %r115 = add i64 0, 0
  %r116.ptr = call ptr @nova_rt_struct_alloc(i64 16)
  %r116.f0 = getelementptr i64, ptr %r116.ptr, i64 0
  store i64 %r114, ptr %r116.f0, align 8
  %r116.f1 = getelementptr i64, ptr %r116.ptr, i64 1
  store i64 %r115, ptr %r116.f1, align 8
  %r116 = ptrtoint ptr %r116.ptr to i64
  br label %endif389
endif389:
  br label %endif386
else385:
  %r117 = load i64, ptr %slot.kind, align 8
  %r118.p = getelementptr inbounds [3 x i8], ptr @.str.43, i64 0, i64 0
  %r118 = ptrtoint ptr %r118.p to i64
  %r119 = call i64 @nova_rt_eq(i64 %r117, i64 %r118)
  %r120 = load i64, ptr %slot.val, align 8
  %r121.p = getelementptr inbounds [6 x i8], ptr @.str.34, i64 0, i64 0
  %r121 = ptrtoint ptr %r121.p to i64
  %r122 = call i64 @nova_rt_eq(i64 %r120, i64 %r121)
  %r123.cmp = icmp ne i64 %r119, 0
  %r123.cmp2 = icmp ne i64 %r122, 0
  %r123.and = and i1 %r123.cmp, %r123.cmp2
  %r123 = zext i1 %r123.and to i64
  %br_then390 = icmp ne i64 %r123, 0
  br i1 %br_then390, label %then390, label %else391
then390:
  %r124 = load i64, ptr %slot.tokens, align 8
  %r125 = load i64, ptr %slot.pos, align 8
  %r126 = add i64 1, 0
  %r127 = call i64 @nova_rt_add(i64 %r125, i64 %r126)
  %r128 = add i64 0, 0
  %r129 = call i64 @parse_expr(i64 %r124, i64 %r127, i64 %r128)
  store i64 %r129, ptr %slot.expr_r, align 8
  %r130.p = getelementptr inbounds [6 x i8], ptr @.str.34, i64 0, i64 0
  %r130 = ptrtoint ptr %r130.p to i64
  %r131.p = getelementptr inbounds [1 x i8], ptr @.str.42, i64 0, i64 0
  %r131 = ptrtoint ptr %r131.p to i64
  %r132 = add i64 0, 0
  %r133 = call i64 @nova_rt_list_create()
  %r134 = call i64 @nova_rt_list_create()
  %r135 = call i64 @nova_rt_list_create()
  %r136 = call i64 @nova_rt_list_create()
  %r137.ptr = call ptr @nova_rt_struct_alloc(i64 56)
  %r137.f0 = getelementptr i64, ptr %r137.ptr, i64 0
  store i64 %r130, ptr %r137.f0, align 8
  %r137.f1 = getelementptr i64, ptr %r137.ptr, i64 1
  store i64 %r131, ptr %r137.f1, align 8
  %r137.f2 = getelementptr i64, ptr %r137.ptr, i64 2
  store i64 %r132, ptr %r137.f2, align 8
  %r137.f3 = getelementptr i64, ptr %r137.ptr, i64 3
  store i64 %r133, ptr %r137.f3, align 8
  %r137.f4 = getelementptr i64, ptr %r137.ptr, i64 4
  store i64 %r134, ptr %r137.f4, align 8
  %r137.f5 = getelementptr i64, ptr %r137.ptr, i64 5
  store i64 %r135, ptr %r137.f5, align 8
  %r137.f6 = getelementptr i64, ptr %r137.ptr, i64 6
  store i64 %r136, ptr %r137.f6, align 8
  %r137 = ptrtoint ptr %r137.ptr to i64
  %r138 = add i64 0, 0
  %r139.ptr = call ptr @nova_rt_struct_alloc(i64 16)
  %r139.f0 = getelementptr i64, ptr %r139.ptr, i64 0
  store i64 %r137, ptr %r139.f0, align 8
  %r139.f1 = getelementptr i64, ptr %r139.ptr, i64 1
  store i64 %r138, ptr %r139.f1, align 8
  %r139 = ptrtoint ptr %r139.ptr to i64
  br label %endif392
else391:
  %r140 = load i64, ptr %slot.kind, align 8
  %r141.p = getelementptr inbounds [3 x i8], ptr @.str.43, i64 0, i64 0
  %r141 = ptrtoint ptr %r141.p to i64
  %r142 = call i64 @nova_rt_eq(i64 %r140, i64 %r141)
  %r143 = load i64, ptr %slot.val, align 8
  %r144.p = getelementptr inbounds [6 x i8], ptr @.str.11, i64 0, i64 0
  %r144 = ptrtoint ptr %r144.p to i64
  %r145 = call i64 @nova_rt_eq(i64 %r143, i64 %r144)
  %r146.cmp = icmp ne i64 %r142, 0
  %r146.cmp2 = icmp ne i64 %r145, 0
  %r146.and = and i1 %r146.cmp, %r146.cmp2
  %r146 = zext i1 %r146.and to i64
  %br_then393 = icmp ne i64 %r146, 0
  br i1 %br_then393, label %then393, label %else394
then393:
  %r147.p = getelementptr inbounds [6 x i8], ptr @.str.11, i64 0, i64 0
  %r147 = ptrtoint ptr %r147.p to i64
  %r148.p = getelementptr inbounds [1 x i8], ptr @.str.42, i64 0, i64 0
  %r148 = ptrtoint ptr %r148.p to i64
  %r149 = call i64 @null_expr()
  %r150 = call i64 @nova_rt_list_create()
  %r151 = call i64 @nova_rt_list_create()
  %r152 = call i64 @nova_rt_list_create()
  %r153 = call i64 @nova_rt_list_create()
  %r154.ptr = call ptr @nova_rt_struct_alloc(i64 56)
  %r154.f0 = getelementptr i64, ptr %r154.ptr, i64 0
  store i64 %r147, ptr %r154.f0, align 8
  %r154.f1 = getelementptr i64, ptr %r154.ptr, i64 1
  store i64 %r148, ptr %r154.f1, align 8
  %r154.f2 = getelementptr i64, ptr %r154.ptr, i64 2
  store i64 %r149, ptr %r154.f2, align 8
  %r154.f3 = getelementptr i64, ptr %r154.ptr, i64 3
  store i64 %r150, ptr %r154.f3, align 8
  %r154.f4 = getelementptr i64, ptr %r154.ptr, i64 4
  store i64 %r151, ptr %r154.f4, align 8
  %r154.f5 = getelementptr i64, ptr %r154.ptr, i64 5
  store i64 %r152, ptr %r154.f5, align 8
  %r154.f6 = getelementptr i64, ptr %r154.ptr, i64 6
  store i64 %r153, ptr %r154.f6, align 8
  %r154 = ptrtoint ptr %r154.ptr to i64
  %r155 = load i64, ptr %slot.pos, align 8
  %r156 = add i64 1, 0
  %r157 = call i64 @nova_rt_add(i64 %r155, i64 %r156)
  %r158.ptr = call ptr @nova_rt_struct_alloc(i64 16)
  %r158.f0 = getelementptr i64, ptr %r158.ptr, i64 0
  store i64 %r154, ptr %r158.f0, align 8
  %r158.f1 = getelementptr i64, ptr %r158.ptr, i64 1
  store i64 %r157, ptr %r158.f1, align 8
  %r158 = ptrtoint ptr %r158.ptr to i64
  br label %endif395
else394:
  %r159 = load i64, ptr %slot.kind, align 8
  %r160.p = getelementptr inbounds [3 x i8], ptr @.str.43, i64 0, i64 0
  %r160 = ptrtoint ptr %r160.p to i64
  %r161 = call i64 @nova_rt_eq(i64 %r159, i64 %r160)
  %r162 = load i64, ptr %slot.val, align 8
  %r163.p = getelementptr inbounds [9 x i8], ptr @.str.12, i64 0, i64 0
  %r163 = ptrtoint ptr %r163.p to i64
  %r164 = call i64 @nova_rt_eq(i64 %r162, i64 %r163)
  %r165.cmp = icmp ne i64 %r161, 0
  %r165.cmp2 = icmp ne i64 %r164, 0
  %r165.and = and i1 %r165.cmp, %r165.cmp2
  %r165 = zext i1 %r165.and to i64
  %br_then396 = icmp ne i64 %r165, 0
  br i1 %br_then396, label %then396, label %else397
then396:
  %r166.p = getelementptr inbounds [9 x i8], ptr @.str.12, i64 0, i64 0
  %r166 = ptrtoint ptr %r166.p to i64
  %r167.p = getelementptr inbounds [1 x i8], ptr @.str.42, i64 0, i64 0
  %r167 = ptrtoint ptr %r167.p to i64
  %r168 = call i64 @null_expr()
  %r169 = call i64 @nova_rt_list_create()
  %r170 = call i64 @nova_rt_list_create()
  %r171 = call i64 @nova_rt_list_create()
  %r172 = call i64 @nova_rt_list_create()
  %r173.ptr = call ptr @nova_rt_struct_alloc(i64 56)
  %r173.f0 = getelementptr i64, ptr %r173.ptr, i64 0
  store i64 %r166, ptr %r173.f0, align 8
  %r173.f1 = getelementptr i64, ptr %r173.ptr, i64 1
  store i64 %r167, ptr %r173.f1, align 8
  %r173.f2 = getelementptr i64, ptr %r173.ptr, i64 2
  store i64 %r168, ptr %r173.f2, align 8
  %r173.f3 = getelementptr i64, ptr %r173.ptr, i64 3
  store i64 %r169, ptr %r173.f3, align 8
  %r173.f4 = getelementptr i64, ptr %r173.ptr, i64 4
  store i64 %r170, ptr %r173.f4, align 8
  %r173.f5 = getelementptr i64, ptr %r173.ptr, i64 5
  store i64 %r171, ptr %r173.f5, align 8
  %r173.f6 = getelementptr i64, ptr %r173.ptr, i64 6
  store i64 %r172, ptr %r173.f6, align 8
  %r173 = ptrtoint ptr %r173.ptr to i64
  %r174 = load i64, ptr %slot.pos, align 8
  %r175 = add i64 1, 0
  %r176 = call i64 @nova_rt_add(i64 %r174, i64 %r175)
  %r177.ptr = call ptr @nova_rt_struct_alloc(i64 16)
  %r177.f0 = getelementptr i64, ptr %r177.ptr, i64 0
  store i64 %r173, ptr %r177.f0, align 8
  %r177.f1 = getelementptr i64, ptr %r177.ptr, i64 1
  store i64 %r176, ptr %r177.f1, align 8
  %r177 = ptrtoint ptr %r177.ptr to i64
  br label %endif398
else397:
  %r178 = load i64, ptr %slot.kind, align 8
  %r179.p = getelementptr inbounds [3 x i8], ptr @.str.43, i64 0, i64 0
  %r179 = ptrtoint ptr %r179.p to i64
  %r180 = call i64 @nova_rt_eq(i64 %r178, i64 %r179)
  %r181 = load i64, ptr %slot.val, align 8
  %r182.p = getelementptr inbounds [7 x i8], ptr @.str.23, i64 0, i64 0
  %r182 = ptrtoint ptr %r182.p to i64
  %r183 = call i64 @nova_rt_eq(i64 %r181, i64 %r182)
  %r184.cmp = icmp ne i64 %r180, 0
  %r184.cmp2 = icmp ne i64 %r183, 0
  %r184.and = and i1 %r184.cmp, %r184.cmp2
  %r184 = zext i1 %r184.and to i64
  %br_then399 = icmp ne i64 %r184, 0
  br i1 %br_then399, label %then399, label %else400
then399:
  %r185 = load i64, ptr %slot.tokens, align 8
  %r186 = load i64, ptr %slot.pos, align 8
  %r187 = call i64 @parse_import_stmt(i64 %r185, i64 %r186)
  br label %endif401
else400:
  %r188 = load i64, ptr %slot.kind, align 8
  %r189.p = getelementptr inbounds [3 x i8], ptr @.str.43, i64 0, i64 0
  %r189 = ptrtoint ptr %r189.p to i64
  %r190 = call i64 @nova_rt_eq(i64 %r188, i64 %r189)
  %r191 = load i64, ptr %slot.val, align 8
  %r192.p = getelementptr inbounds [6 x i8], ptr @.str.10, i64 0, i64 0
  %r192 = ptrtoint ptr %r192.p to i64
  %r193 = call i64 @nova_rt_eq(i64 %r191, i64 %r192)
  %r194.cmp = icmp ne i64 %r190, 0
  %r194.cmp2 = icmp ne i64 %r193, 0
  %r194.and = and i1 %r194.cmp, %r194.cmp2
  %r194 = zext i1 %r194.and to i64
  %br_then402 = icmp ne i64 %r194, 0
  br i1 %br_then402, label %then402, label %else403
then402:
  %r195 = load i64, ptr %slot.tokens, align 8
  %r196 = load i64, ptr %slot.pos, align 8
  %r197 = call i64 @parse_match_stmt(i64 %r195, i64 %r196)
  br label %endif404
else403:
  %r198 = load i64, ptr %slot.kind, align 8
  %r199.p = getelementptr inbounds [3 x i8], ptr @.str.43, i64 0, i64 0
  %r199 = ptrtoint ptr %r199.p to i64
  %r200 = call i64 @nova_rt_eq(i64 %r198, i64 %r199)
  %r201 = load i64, ptr %slot.val, align 8
  %r202.p = getelementptr inbounds [4 x i8], ptr @.str.35, i64 0, i64 0
  %r202 = ptrtoint ptr %r202.p to i64
  %r203 = call i64 @nova_rt_eq(i64 %r201, i64 %r202)
  %r204.cmp = icmp ne i64 %r200, 0
  %r204.cmp2 = icmp ne i64 %r203, 0
  %r204.and = and i1 %r204.cmp, %r204.cmp2
  %r204 = zext i1 %r204.and to i64
  %br_then405 = icmp ne i64 %r204, 0
  br i1 %br_then405, label %then405, label %else406
then405:
  %r205 = load i64, ptr %slot.tokens, align 8
  %r206 = load i64, ptr %slot.pos, align 8
  %r207 = add i64 1, 0
  %r208 = call i64 @nova_rt_add(i64 %r206, i64 %r207)
  %r209 = call i64 @tv(i64 %r205, i64 %r208)
  store i64 %r209, ptr %slot.name, align 8
  %r210 = load i64, ptr %slot.pos, align 8
  %r211 = add i64 2, 0
  %r212 = call i64 @nova_rt_add(i64 %r210, i64 %r211)
  store i64 %r212, ptr %slot.p, align 8
  %r213 = load i64, ptr %slot.tokens, align 8
  %r214 = load i64, ptr %slot.p, align 8
  %r215 = call i64 @tk(i64 %r213, i64 %r214)
  %r216.p = getelementptr inbounds [7 x i8], ptr @.str.91, i64 0, i64 0
  %r216 = ptrtoint ptr %r216.p to i64
  %r217 = call i64 @nova_rt_eq(i64 %r215, i64 %r216)
  %br_then408 = icmp ne i64 %r217, 0
  br i1 %br_then408, label %then408, label %else409
then408:
  %r218 = load i64, ptr %slot.p, align 8
  %r219 = add i64 1, 0
  %r220 = call i64 @nova_rt_add(i64 %r218, i64 %r219)
  store i64 %r220, ptr %slot.p, align 8
  %r221 = load i64, ptr %slot.tokens, align 8
  %r222 = load i64, ptr %slot.p, align 8
  %r223 = add i64 0, 0
  %r224 = call i64 @parse_expr(i64 %r221, i64 %r222, i64 %r223)
  store i64 %r224, ptr %slot.expr_r, align 8
  %r225.p = getelementptr inbounds [7 x i8], ptr @.str.133, i64 0, i64 0
  %r225 = ptrtoint ptr %r225.p to i64
  %r226 = load i64, ptr %slot.name, align 8
  %r227 = add i64 0, 0
  %r228 = call i64 @nova_rt_list_create()
  %r229 = call i64 @nova_rt_list_create()
  %r230 = call i64 @nova_rt_list_create()
  %r231 = call i64 @nova_rt_list_create()
  %r232.ptr = call ptr @nova_rt_struct_alloc(i64 56)
  %r232.f0 = getelementptr i64, ptr %r232.ptr, i64 0
  store i64 %r225, ptr %r232.f0, align 8
  %r232.f1 = getelementptr i64, ptr %r232.ptr, i64 1
  store i64 %r226, ptr %r232.f1, align 8
  %r232.f2 = getelementptr i64, ptr %r232.ptr, i64 2
  store i64 %r227, ptr %r232.f2, align 8
  %r232.f3 = getelementptr i64, ptr %r232.ptr, i64 3
  store i64 %r228, ptr %r232.f3, align 8
  %r232.f4 = getelementptr i64, ptr %r232.ptr, i64 4
  store i64 %r229, ptr %r232.f4, align 8
  %r232.f5 = getelementptr i64, ptr %r232.ptr, i64 5
  store i64 %r230, ptr %r232.f5, align 8
  %r232.f6 = getelementptr i64, ptr %r232.ptr, i64 6
  store i64 %r231, ptr %r232.f6, align 8
  %r232 = ptrtoint ptr %r232.ptr to i64
  %r233 = add i64 0, 0
  %r234.ptr = call ptr @nova_rt_struct_alloc(i64 16)
  %r234.f0 = getelementptr i64, ptr %r234.ptr, i64 0
  store i64 %r232, ptr %r234.f0, align 8
  %r234.f1 = getelementptr i64, ptr %r234.ptr, i64 1
  store i64 %r233, ptr %r234.f1, align 8
  %r234 = ptrtoint ptr %r234.ptr to i64
  br label %endif410
else409:
  %r235.p = getelementptr inbounds [7 x i8], ptr @.str.133, i64 0, i64 0
  %r235 = ptrtoint ptr %r235.p to i64
  %r236 = load i64, ptr %slot.name, align 8
  %r237 = call i64 @null_expr()
  %r238 = call i64 @nova_rt_list_create()
  %r239 = call i64 @nova_rt_list_create()
  %r240 = call i64 @nova_rt_list_create()
  %r241 = call i64 @nova_rt_list_create()
  %r242.ptr = call ptr @nova_rt_struct_alloc(i64 56)
  %r242.f0 = getelementptr i64, ptr %r242.ptr, i64 0
  store i64 %r235, ptr %r242.f0, align 8
  %r242.f1 = getelementptr i64, ptr %r242.ptr, i64 1
  store i64 %r236, ptr %r242.f1, align 8
  %r242.f2 = getelementptr i64, ptr %r242.ptr, i64 2
  store i64 %r237, ptr %r242.f2, align 8
  %r242.f3 = getelementptr i64, ptr %r242.ptr, i64 3
  store i64 %r238, ptr %r242.f3, align 8
  %r242.f4 = getelementptr i64, ptr %r242.ptr, i64 4
  store i64 %r239, ptr %r242.f4, align 8
  %r242.f5 = getelementptr i64, ptr %r242.ptr, i64 5
  store i64 %r240, ptr %r242.f5, align 8
  %r242.f6 = getelementptr i64, ptr %r242.ptr, i64 6
  store i64 %r241, ptr %r242.f6, align 8
  %r242 = ptrtoint ptr %r242.ptr to i64
  %r243 = load i64, ptr %slot.p, align 8
  %r244.ptr = call ptr @nova_rt_struct_alloc(i64 16)
  %r244.f0 = getelementptr i64, ptr %r244.ptr, i64 0
  store i64 %r242, ptr %r244.f0, align 8
  %r244.f1 = getelementptr i64, ptr %r244.ptr, i64 1
  store i64 %r243, ptr %r244.f1, align 8
  %r244 = ptrtoint ptr %r244.ptr to i64
  br label %endif410
endif410:
  br label %endif407
else406:
  %r245 = load i64, ptr %slot.kind, align 8
  %r246.p = getelementptr inbounds [6 x i8], ptr @.str.44, i64 0, i64 0
  %r246 = ptrtoint ptr %r246.p to i64
  %r247 = call i64 @nova_rt_eq(i64 %r245, i64 %r246)
  %br_then411 = icmp ne i64 %r247, 0
  br i1 %br_then411, label %then411, label %else412
then411:
  %r248 = load i64, ptr %slot.tokens, align 8
  %r249 = load i64, ptr %slot.pos, align 8
  %r250 = add i64 0, 0
  %r251 = call i64 @parse_expr(i64 %r248, i64 %r249, i64 %r250)
  store i64 %r251, ptr %slot.expr_r, align 8
  %r252 = add i64 0, 0
  store i64 %r252, ptr %slot.p, align 8
  %r253 = load i64, ptr %slot.tokens, align 8
  %r254 = load i64, ptr %slot.p, align 8
  %r255 = call i64 @tk(i64 %r253, i64 %r254)
  %r256.p = getelementptr inbounds [7 x i8], ptr @.str.91, i64 0, i64 0
  %r256 = ptrtoint ptr %r256.p to i64
  %r257 = call i64 @nova_rt_eq(i64 %r255, i64 %r256)
  %br_then414 = icmp ne i64 %r257, 0
  br i1 %br_then414, label %then414, label %else415
then414:
  %r258 = load i64, ptr %slot.p, align 8
  %r259 = add i64 1, 0
  %r260 = call i64 @nova_rt_add(i64 %r258, i64 %r259)
  store i64 %r260, ptr %slot.p, align 8
  %r261 = load i64, ptr %slot.tokens, align 8
  %r262 = load i64, ptr %slot.p, align 8
  %r263 = add i64 0, 0
  %r264 = call i64 @parse_expr(i64 %r261, i64 %r262, i64 %r263)
  store i64 %r264, ptr %slot.rhs_r, align 8
  %r265.p = getelementptr inbounds [7 x i8], ptr @.str.133, i64 0, i64 0
  %r265 = ptrtoint ptr %r265.p to i64
  %r266.p = getelementptr inbounds [1 x i8], ptr @.str.42, i64 0, i64 0
  %r266 = ptrtoint ptr %r266.p to i64
  %r267 = add i64 0, 0
  %r268 = call i64 @nova_rt_list_create()
  %r269 = call i64 @nova_rt_list_create()
  %r270 = call i64 @nova_rt_list_create()
  %r272 = add i64 0, 0
  %r271 = call i64 @nova_rt_list_create()
  call i64 @nova_rt_list_append(i64 %r271, i64 %r272)
  %r273.ptr = call ptr @nova_rt_struct_alloc(i64 56)
  %r273.f0 = getelementptr i64, ptr %r273.ptr, i64 0
  store i64 %r265, ptr %r273.f0, align 8
  %r273.f1 = getelementptr i64, ptr %r273.ptr, i64 1
  store i64 %r266, ptr %r273.f1, align 8
  %r273.f2 = getelementptr i64, ptr %r273.ptr, i64 2
  store i64 %r267, ptr %r273.f2, align 8
  %r273.f3 = getelementptr i64, ptr %r273.ptr, i64 3
  store i64 %r268, ptr %r273.f3, align 8
  %r273.f4 = getelementptr i64, ptr %r273.ptr, i64 4
  store i64 %r269, ptr %r273.f4, align 8
  %r273.f5 = getelementptr i64, ptr %r273.ptr, i64 5
  store i64 %r270, ptr %r273.f5, align 8
  %r273.f6 = getelementptr i64, ptr %r273.ptr, i64 6
  store i64 %r271, ptr %r273.f6, align 8
  %r273 = ptrtoint ptr %r273.ptr to i64
  %r274 = add i64 0, 0
  %r275.ptr = call ptr @nova_rt_struct_alloc(i64 16)
  %r275.f0 = getelementptr i64, ptr %r275.ptr, i64 0
  store i64 %r273, ptr %r275.f0, align 8
  %r275.f1 = getelementptr i64, ptr %r275.ptr, i64 1
  store i64 %r274, ptr %r275.f1, align 8
  %r275 = ptrtoint ptr %r275.ptr to i64
  br label %endif416
else415:
  %r276 = load i64, ptr %slot.tokens, align 8
  %r277 = load i64, ptr %slot.p, align 8
  %r278 = call i64 @tk(i64 %r276, i64 %r277)
  %r279.p = getelementptr inbounds [3 x i8], ptr @.str.75, i64 0, i64 0
  %r279 = ptrtoint ptr %r279.p to i64
  %r280 = call i64 @nova_rt_eq(i64 %r278, i64 %r279)
  %r281 = load i64, ptr %slot.tokens, align 8
  %r282 = load i64, ptr %slot.p, align 8
  %r283 = call i64 @tv(i64 %r281, i64 %r282)
  %r284.p = getelementptr inbounds [3 x i8], ptr @.str.76, i64 0, i64 0
  %r284 = ptrtoint ptr %r284.p to i64
  %r285 = call i64 @nova_rt_eq(i64 %r283, i64 %r284)
  %r286 = load i64, ptr %slot.tokens, align 8
  %r287 = load i64, ptr %slot.p, align 8
  %r288 = call i64 @tv(i64 %r286, i64 %r287)
  %r289.p = getelementptr inbounds [3 x i8], ptr @.str.81, i64 0, i64 0
  %r289 = ptrtoint ptr %r289.p to i64
  %r290 = call i64 @nova_rt_eq(i64 %r288, i64 %r289)
  %r291.cmp = icmp ne i64 %r285, 0
  %r291.cmp2 = icmp ne i64 %r290, 0
  %r291.or = or i1 %r291.cmp, %r291.cmp2
  %r291 = zext i1 %r291.or to i64
  %r292 = load i64, ptr %slot.tokens, align 8
  %r293 = load i64, ptr %slot.p, align 8
  %r294 = call i64 @tv(i64 %r292, i64 %r293)
  %r295.p = getelementptr inbounds [3 x i8], ptr @.str.84, i64 0, i64 0
  %r295 = ptrtoint ptr %r295.p to i64
  %r296 = call i64 @nova_rt_eq(i64 %r294, i64 %r295)
  %r297.cmp = icmp ne i64 %r291, 0
  %r297.cmp2 = icmp ne i64 %r296, 0
  %r297.or = or i1 %r297.cmp, %r297.cmp2
  %r297 = zext i1 %r297.or to i64
  %r298 = load i64, ptr %slot.tokens, align 8
  %r299 = load i64, ptr %slot.p, align 8
  %r300 = call i64 @tv(i64 %r298, i64 %r299)
  %r301.p = getelementptr inbounds [3 x i8], ptr @.str.85, i64 0, i64 0
  %r301 = ptrtoint ptr %r301.p to i64
  %r302 = call i64 @nova_rt_eq(i64 %r300, i64 %r301)
  %r303.cmp = icmp ne i64 %r297, 0
  %r303.cmp2 = icmp ne i64 %r302, 0
  %r303.or = or i1 %r303.cmp, %r303.cmp2
  %r303 = zext i1 %r303.or to i64
  %r304.cmp = icmp ne i64 %r280, 0
  %r304.cmp2 = icmp ne i64 %r303, 0
  %r304.and = and i1 %r304.cmp, %r304.cmp2
  %r304 = zext i1 %r304.and to i64
  %br_then417 = icmp ne i64 %r304, 0
  br i1 %br_then417, label %then417, label %else418
then417:
  %r305 = load i64, ptr %slot.tokens, align 8
  %r306 = load i64, ptr %slot.p, align 8
  %r307 = call i64 @tv(i64 %r305, i64 %r306)
  store i64 %r307, ptr %slot.op, align 8
  %r308 = load i64, ptr %slot.p, align 8
  %r309 = add i64 1, 0
  %r310 = call i64 @nova_rt_add(i64 %r308, i64 %r309)
  store i64 %r310, ptr %slot.p, align 8
  %r311 = load i64, ptr %slot.tokens, align 8
  %r312 = load i64, ptr %slot.p, align 8
  %r313 = add i64 0, 0
  %r314 = call i64 @parse_expr(i64 %r311, i64 %r312, i64 %r313)
  store i64 %r314, ptr %slot.rhs_r, align 8
  %r315.p = getelementptr inbounds [16 x i8], ptr @.str.134, i64 0, i64 0
  %r315 = ptrtoint ptr %r315.p to i64
  %r316 = load i64, ptr %slot.op, align 8
  %r317 = add i64 0, 0
  %r318 = call i64 @nova_rt_list_create()
  %r319 = call i64 @nova_rt_list_create()
  %r320 = call i64 @nova_rt_list_create()
  %r322 = add i64 0, 0
  %r321 = call i64 @nova_rt_list_create()
  call i64 @nova_rt_list_append(i64 %r321, i64 %r322)
  %r323.ptr = call ptr @nova_rt_struct_alloc(i64 56)
  %r323.f0 = getelementptr i64, ptr %r323.ptr, i64 0
  store i64 %r315, ptr %r323.f0, align 8
  %r323.f1 = getelementptr i64, ptr %r323.ptr, i64 1
  store i64 %r316, ptr %r323.f1, align 8
  %r323.f2 = getelementptr i64, ptr %r323.ptr, i64 2
  store i64 %r317, ptr %r323.f2, align 8
  %r323.f3 = getelementptr i64, ptr %r323.ptr, i64 3
  store i64 %r318, ptr %r323.f3, align 8
  %r323.f4 = getelementptr i64, ptr %r323.ptr, i64 4
  store i64 %r319, ptr %r323.f4, align 8
  %r323.f5 = getelementptr i64, ptr %r323.ptr, i64 5
  store i64 %r320, ptr %r323.f5, align 8
  %r323.f6 = getelementptr i64, ptr %r323.ptr, i64 6
  store i64 %r321, ptr %r323.f6, align 8
  %r323 = ptrtoint ptr %r323.ptr to i64
  %r324 = add i64 0, 0
  %r325.ptr = call ptr @nova_rt_struct_alloc(i64 16)
  %r325.f0 = getelementptr i64, ptr %r325.ptr, i64 0
  store i64 %r323, ptr %r325.f0, align 8
  %r325.f1 = getelementptr i64, ptr %r325.ptr, i64 1
  store i64 %r324, ptr %r325.f1, align 8
  %r325 = ptrtoint ptr %r325.ptr to i64
  br label %endif419
else418:
  %r326.p = getelementptr inbounds [5 x i8], ptr @.str.135, i64 0, i64 0
  %r326 = ptrtoint ptr %r326.p to i64
  %r327.p = getelementptr inbounds [1 x i8], ptr @.str.42, i64 0, i64 0
  %r327 = ptrtoint ptr %r327.p to i64
  %r328 = add i64 0, 0
  %r329 = call i64 @nova_rt_list_create()
  %r330 = call i64 @nova_rt_list_create()
  %r331 = call i64 @nova_rt_list_create()
  %r332 = call i64 @nova_rt_list_create()
  %r333.ptr = call ptr @nova_rt_struct_alloc(i64 56)
  %r333.f0 = getelementptr i64, ptr %r333.ptr, i64 0
  store i64 %r326, ptr %r333.f0, align 8
  %r333.f1 = getelementptr i64, ptr %r333.ptr, i64 1
  store i64 %r327, ptr %r333.f1, align 8
  %r333.f2 = getelementptr i64, ptr %r333.ptr, i64 2
  store i64 %r328, ptr %r333.f2, align 8
  %r333.f3 = getelementptr i64, ptr %r333.ptr, i64 3
  store i64 %r329, ptr %r333.f3, align 8
  %r333.f4 = getelementptr i64, ptr %r333.ptr, i64 4
  store i64 %r330, ptr %r333.f4, align 8
  %r333.f5 = getelementptr i64, ptr %r333.ptr, i64 5
  store i64 %r331, ptr %r333.f5, align 8
  %r333.f6 = getelementptr i64, ptr %r333.ptr, i64 6
  store i64 %r332, ptr %r333.f6, align 8
  %r333 = ptrtoint ptr %r333.ptr to i64
  %r334 = load i64, ptr %slot.p, align 8
  %r335.ptr = call ptr @nova_rt_struct_alloc(i64 16)
  %r335.f0 = getelementptr i64, ptr %r335.ptr, i64 0
  store i64 %r333, ptr %r335.f0, align 8
  %r335.f1 = getelementptr i64, ptr %r335.ptr, i64 1
  store i64 %r334, ptr %r335.f1, align 8
  %r335 = ptrtoint ptr %r335.ptr to i64
  br label %endif419
endif419:
  br label %endif416
endif416:
  br label %endif413
else412:
  %r336 = load i64, ptr %slot.tokens, align 8
  %r337 = load i64, ptr %slot.pos, align 8
  %r338 = add i64 0, 0
  %r339 = call i64 @parse_expr(i64 %r336, i64 %r337, i64 %r338)
  store i64 %r339, ptr %slot.expr_r, align 8
  %r340.p = getelementptr inbounds [5 x i8], ptr @.str.135, i64 0, i64 0
  %r340 = ptrtoint ptr %r340.p to i64
  %r341.p = getelementptr inbounds [1 x i8], ptr @.str.42, i64 0, i64 0
  %r341 = ptrtoint ptr %r341.p to i64
  %r342 = add i64 0, 0
  %r343 = call i64 @nova_rt_list_create()
  %r344 = call i64 @nova_rt_list_create()
  %r345 = call i64 @nova_rt_list_create()
  %r346 = call i64 @nova_rt_list_create()
  %r347.ptr = call ptr @nova_rt_struct_alloc(i64 56)
  %r347.f0 = getelementptr i64, ptr %r347.ptr, i64 0
  store i64 %r340, ptr %r347.f0, align 8
  %r347.f1 = getelementptr i64, ptr %r347.ptr, i64 1
  store i64 %r341, ptr %r347.f1, align 8
  %r347.f2 = getelementptr i64, ptr %r347.ptr, i64 2
  store i64 %r342, ptr %r347.f2, align 8
  %r347.f3 = getelementptr i64, ptr %r347.ptr, i64 3
  store i64 %r343, ptr %r347.f3, align 8
  %r347.f4 = getelementptr i64, ptr %r347.ptr, i64 4
  store i64 %r344, ptr %r347.f4, align 8
  %r347.f5 = getelementptr i64, ptr %r347.ptr, i64 5
  store i64 %r345, ptr %r347.f5, align 8
  %r347.f6 = getelementptr i64, ptr %r347.ptr, i64 6
  store i64 %r346, ptr %r347.f6, align 8
  %r347 = ptrtoint ptr %r347.ptr to i64
  %r348 = add i64 0, 0
  %r349.ptr = call ptr @nova_rt_struct_alloc(i64 16)
  %r349.f0 = getelementptr i64, ptr %r349.ptr, i64 0
  store i64 %r347, ptr %r349.f0, align 8
  %r349.f1 = getelementptr i64, ptr %r349.ptr, i64 1
  store i64 %r348, ptr %r349.f1, align 8
  %r349 = ptrtoint ptr %r349.ptr to i64
  br label %endif413
endif413:
  br label %endif407
endif407:
  br label %endif404
endif404:
  br label %endif401
endif401:
  br label %endif398
endif398:
  br label %endif395
endif395:
  br label %endif392
endif392:
  br label %endif386
endif386:
  br label %endif383
endif383:
  br label %endif380
endif380:
  br label %endif377
endif377:
  br label %endif374
endif374:
  br label %endif371
endif371:
  br label %endif368
endif368:
  ret i64 0
}

define i64 @parse_fn_decl(i64 %p0, i64 %p1) nounwind {
entry:
  %slot.tokens = alloca i64, align 8
  store i64 %p0, ptr %slot.tokens, align 8
  %slot.pos = alloca i64, align 8
  store i64 %p1, ptr %slot.pos, align 8
  %slot.p = alloca i64, align 8
  store i64 0, ptr %slot.p, align 8
  %slot.name = alloca i64, align 8
  store i64 0, ptr %slot.name, align 8
  %slot.params = alloca i64, align 8
  store i64 0, ptr %slot.params, align 8
  %slot.param_name = alloca i64, align 8
  store i64 0, ptr %slot.param_name, align 8
  %slot.type_ann = alloca i64, align 8
  store i64 0, ptr %slot.type_ann, align 8
  %slot.default_val = alloca i64, align 8
  store i64 0, ptr %slot.default_val, align 8
  %slot.def_r = alloca i64, align 8
  store i64 0, ptr %slot.def_r, align 8
  %slot.p2 = alloca i64, align 8
  store i64 0, ptr %slot.p2, align 8
  %slot.body = alloca i64, align 8
  store i64 0, ptr %slot.body, align 8
  %slot.cur_tok = alloca i64, align 8
  store i64 0, ptr %slot.cur_tok, align 8
  %slot.sr = alloca i64, align 8
  store i64 0, ptr %slot.sr, align 8
  %r0 = load i64, ptr %slot.pos, align 8
  %r1 = add i64 1, 0
  %r2 = call i64 @nova_rt_add(i64 %r0, i64 %r1)
  store i64 %r2, ptr %slot.p, align 8
  %r3 = load i64, ptr %slot.tokens, align 8
  %r4 = load i64, ptr %slot.p, align 8
  %r5 = call i64 @tv(i64 %r3, i64 %r4)
  store i64 %r5, ptr %slot.name, align 8
  %r6 = load i64, ptr %slot.p, align 8
  %r7 = add i64 1, 0
  %r8 = call i64 @nova_rt_add(i64 %r6, i64 %r7)
  store i64 %r8, ptr %slot.p, align 8
  %r9 = load i64, ptr %slot.tokens, align 8
  %r10 = load i64, ptr %slot.p, align 8
  %r11.p = getelementptr inbounds [2 x i8], ptr @.str.59, i64 0, i64 0
  %r11 = ptrtoint ptr %r11.p to i64
  %r12 = call i64 @expect(i64 %r9, i64 %r10, i64 %r11)
  store i64 %r12, ptr %slot.p, align 8
  %r13 = call i64 @nova_rt_list_create()
  store i64 %r13, ptr %slot.params, align 8
  br label %while_hdr420
while_hdr420:
  %r14 = load i64, ptr %slot.tokens, align 8
  %r15 = load i64, ptr %slot.p, align 8
  %r16 = call i64 @tv(i64 %r14, i64 %r15)
  %r17.p = getelementptr inbounds [2 x i8], ptr @.str.60, i64 0, i64 0
  %r17 = ptrtoint ptr %r17.p to i64
  %r18 = call i64 @nova_rt_neq(i64 %r16, i64 %r17)
  %br_while_body421 = icmp ne i64 %r18, 0
  br i1 %br_while_body421, label %while_body421, label %while_exit422
while_body421:
  %r19 = load i64, ptr %slot.params, align 8
  %r20 = call i64 @nova_rt_len_any(i64 %r19)
  %r21 = add i64 0, 0
  %r22.cmp = icmp sgt i64 %r20, %r21
  %r22 = zext i1 %r22.cmp to i64
  %br_then423 = icmp ne i64 %r22, 0
  br i1 %br_then423, label %then423, label %else424
then423:
  %r23 = load i64, ptr %slot.tokens, align 8
  %r24 = load i64, ptr %slot.p, align 8
  %r25.p = getelementptr inbounds [2 x i8], ptr @.str.66, i64 0, i64 0
  %r25 = ptrtoint ptr %r25.p to i64
  %r26 = call i64 @expect(i64 %r23, i64 %r24, i64 %r25)
  store i64 %r26, ptr %slot.p, align 8
  br label %endif425
else424:
  br label %endif425
endif425:
  %r27 = load i64, ptr %slot.tokens, align 8
  %r28 = load i64, ptr %slot.p, align 8
  %r29 = call i64 @tv(i64 %r27, i64 %r28)
  store i64 %r29, ptr %slot.param_name, align 8
  %r30 = load i64, ptr %slot.p, align 8
  %r31 = add i64 1, 0
  %r32 = call i64 @nova_rt_add(i64 %r30, i64 %r31)
  store i64 %r32, ptr %slot.p, align 8
  %r33.p = getelementptr inbounds [1 x i8], ptr @.str.42, i64 0, i64 0
  %r33 = ptrtoint ptr %r33.p to i64
  store i64 %r33, ptr %slot.type_ann, align 8
  %r34 = call i64 @null_expr()
  store i64 %r34, ptr %slot.default_val, align 8
  %r35 = load i64, ptr %slot.tokens, align 8
  %r36 = load i64, ptr %slot.p, align 8
  %r37 = call i64 @tk(i64 %r35, i64 %r36)
  %r38.p = getelementptr inbounds [6 x i8], ptr @.str.69, i64 0, i64 0
  %r38 = ptrtoint ptr %r38.p to i64
  %r39 = call i64 @nova_rt_eq(i64 %r37, i64 %r38)
  %br_then426 = icmp ne i64 %r39, 0
  br i1 %br_then426, label %then426, label %else427
then426:
  %r40 = load i64, ptr %slot.p, align 8
  %r41 = add i64 1, 0
  %r42 = call i64 @nova_rt_add(i64 %r40, i64 %r41)
  store i64 %r42, ptr %slot.p, align 8
  %r43 = load i64, ptr %slot.tokens, align 8
  %r44 = load i64, ptr %slot.p, align 8
  %r45 = call i64 @tv(i64 %r43, i64 %r44)
  store i64 %r45, ptr %slot.type_ann, align 8
  %r46 = load i64, ptr %slot.p, align 8
  %r47 = add i64 1, 0
  %r48 = call i64 @nova_rt_add(i64 %r46, i64 %r47)
  store i64 %r48, ptr %slot.p, align 8
  br label %endif428
else427:
  br label %endif428
endif428:
  %r49 = load i64, ptr %slot.tokens, align 8
  %r50 = load i64, ptr %slot.p, align 8
  %r51 = call i64 @tk(i64 %r49, i64 %r50)
  %r52.p = getelementptr inbounds [7 x i8], ptr @.str.91, i64 0, i64 0
  %r52 = ptrtoint ptr %r52.p to i64
  %r53 = call i64 @nova_rt_eq(i64 %r51, i64 %r52)
  %br_then429 = icmp ne i64 %r53, 0
  br i1 %br_then429, label %then429, label %else430
then429:
  %r54 = load i64, ptr %slot.p, align 8
  %r55 = add i64 1, 0
  %r56 = call i64 @nova_rt_add(i64 %r54, i64 %r55)
  store i64 %r56, ptr %slot.p, align 8
  %r57 = load i64, ptr %slot.tokens, align 8
  %r58 = load i64, ptr %slot.p, align 8
  %r59 = add i64 0, 0
  %r60 = call i64 @parse_expr(i64 %r57, i64 %r58, i64 %r59)
  store i64 %r60, ptr %slot.def_r, align 8
  %r61 = add i64 0, 0
  store i64 %r61, ptr %slot.default_val, align 8
  %r62 = add i64 0, 0
  store i64 %r62, ptr %slot.p, align 8
  br label %endif431
else430:
  br label %endif431
endif431:
  %r63 = load i64, ptr %slot.params, align 8
  %r64 = load i64, ptr %slot.param_name, align 8
  %r65 = load i64, ptr %slot.type_ann, align 8
  %r66 = load i64, ptr %slot.default_val, align 8
  %r67.ptr = call ptr @nova_rt_struct_alloc(i64 24)
  %r67.f0 = getelementptr i64, ptr %r67.ptr, i64 0
  store i64 %r64, ptr %r67.f0, align 8
  %r67.f1 = getelementptr i64, ptr %r67.ptr, i64 1
  store i64 %r65, ptr %r67.f1, align 8
  %r67.f2 = getelementptr i64, ptr %r67.ptr, i64 2
  store i64 %r66, ptr %r67.f2, align 8
  %r67 = ptrtoint ptr %r67.ptr to i64
  %r68 = call i64 @nova_rt_list_append(i64 %r63, i64 %r67)
  br label %while_hdr420
while_exit422:
  %r69 = load i64, ptr %slot.tokens, align 8
  %r70 = load i64, ptr %slot.p, align 8
  %r71.p = getelementptr inbounds [2 x i8], ptr @.str.60, i64 0, i64 0
  %r71 = ptrtoint ptr %r71.p to i64
  %r72 = call i64 @expect(i64 %r69, i64 %r70, i64 %r71)
  store i64 %r72, ptr %slot.p, align 8
  %r73 = load i64, ptr %slot.tokens, align 8
  %r74 = load i64, ptr %slot.p, align 8
  %r75 = call i64 @tk(i64 %r73, i64 %r74)
  %r76.p = getelementptr inbounds [6 x i8], ptr @.str.79, i64 0, i64 0
  %r76 = ptrtoint ptr %r76.p to i64
  %r77 = call i64 @nova_rt_eq(i64 %r75, i64 %r76)
  %br_then432 = icmp ne i64 %r77, 0
  br i1 %br_then432, label %then432, label %else433
then432:
  %r78 = load i64, ptr %slot.p, align 8
  %r79 = add i64 1, 0
  %r80 = call i64 @nova_rt_add(i64 %r78, i64 %r79)
  store i64 %r80, ptr %slot.p, align 8
  br label %while_hdr435
while_hdr435:
  %r81 = load i64, ptr %slot.tokens, align 8
  %r82 = load i64, ptr %slot.p, align 8
  %r83 = call i64 @tk(i64 %r81, i64 %r82)
  %r84.p = getelementptr inbounds [6 x i8], ptr @.str.44, i64 0, i64 0
  %r84 = ptrtoint ptr %r84.p to i64
  %r85 = call i64 @nova_rt_eq(i64 %r83, i64 %r84)
  %r86 = load i64, ptr %slot.tokens, align 8
  %r87 = load i64, ptr %slot.p, align 8
  %r88 = call i64 @tk(i64 %r86, i64 %r87)
  %r89.p = getelementptr inbounds [6 x i8], ptr @.str.65, i64 0, i64 0
  %r89 = ptrtoint ptr %r89.p to i64
  %r90 = call i64 @nova_rt_eq(i64 %r88, i64 %r89)
  %r91.cmp = icmp ne i64 %r85, 0
  %r91.cmp2 = icmp ne i64 %r90, 0
  %r91.or = or i1 %r91.cmp, %r91.cmp2
  %r91 = zext i1 %r91.or to i64
  %br_while_body436 = icmp ne i64 %r91, 0
  br i1 %br_while_body436, label %while_body436, label %while_exit437
while_body436:
  %r92 = load i64, ptr %slot.p, align 8
  %r93 = add i64 1, 0
  %r94 = call i64 @nova_rt_add(i64 %r92, i64 %r93)
  store i64 %r94, ptr %slot.p, align 8
  br label %while_hdr435
while_exit437:
  br label %endif434
else433:
  br label %endif434
endif434:
  %r95 = load i64, ptr %slot.tokens, align 8
  %r96 = load i64, ptr %slot.p, align 8
  %r97 = call i64 @skip_nl(i64 %r95, i64 %r96)
  store i64 %r97, ptr %slot.p2, align 8
  %r98 = call i64 @nova_rt_list_create()
  store i64 %r98, ptr %slot.body, align 8
  br label %while_hdr438
while_hdr438:
  %r99 = load i64, ptr %slot.tokens, align 8
  %r100 = load i64, ptr %slot.p2, align 8
  %r101 = call i64 @tk(i64 %r99, i64 %r100)
  %r102.p = getelementptr inbounds [4 x i8], ptr @.str.107, i64 0, i64 0
  %r102 = ptrtoint ptr %r102.p to i64
  %r103 = call i64 @nova_rt_neq(i64 %r101, i64 %r102)
  %br_while_body439 = icmp ne i64 %r103, 0
  br i1 %br_while_body439, label %while_body439, label %while_exit440
while_body439:
  %r104 = load i64, ptr %slot.tokens, align 8
  %r105 = load i64, ptr %slot.p2, align 8
  %r106 = call i64 @nova_rt_index_get(i64 %r104, i64 %r105)
  store i64 %r106, ptr %slot.cur_tok, align 8
  %r107 = load i64, ptr %slot.tokens, align 8
  %r108 = load i64, ptr %slot.p2, align 8
  %r109 = call i64 @parse_stmt(i64 %r107, i64 %r108)
  store i64 %r109, ptr %slot.sr, align 8
  %r110 = load i64, ptr %slot.body, align 8
  %r111 = add i64 0, 0
  %r112 = call i64 @nova_rt_list_append(i64 %r110, i64 %r111)
  %r113 = load i64, ptr %slot.tokens, align 8
  %r114 = add i64 0, 0
  %r115 = call i64 @skip_nl(i64 %r113, i64 %r114)
  store i64 %r115, ptr %slot.p2, align 8
  br label %while_hdr438
while_exit440:
  %r116.p = getelementptr inbounds [3 x i8], ptr @.str.4, i64 0, i64 0
  %r116 = ptrtoint ptr %r116.p to i64
  %r117 = load i64, ptr %slot.name, align 8
  %r118 = call i64 @null_expr()
  %r119 = load i64, ptr %slot.body, align 8
  %r120 = load i64, ptr %slot.params, align 8
  %r121 = call i64 @nova_rt_list_create()
  %r122 = call i64 @nova_rt_list_create()
  %r123.ptr = call ptr @nova_rt_struct_alloc(i64 56)
  %r123.f0 = getelementptr i64, ptr %r123.ptr, i64 0
  store i64 %r116, ptr %r123.f0, align 8
  %r123.f1 = getelementptr i64, ptr %r123.ptr, i64 1
  store i64 %r117, ptr %r123.f1, align 8
  %r123.f2 = getelementptr i64, ptr %r123.ptr, i64 2
  store i64 %r118, ptr %r123.f2, align 8
  %r123.f3 = getelementptr i64, ptr %r123.ptr, i64 3
  store i64 %r119, ptr %r123.f3, align 8
  %r123.f4 = getelementptr i64, ptr %r123.ptr, i64 4
  store i64 %r120, ptr %r123.f4, align 8
  %r123.f5 = getelementptr i64, ptr %r123.ptr, i64 5
  store i64 %r121, ptr %r123.f5, align 8
  %r123.f6 = getelementptr i64, ptr %r123.ptr, i64 6
  store i64 %r122, ptr %r123.f6, align 8
  %r123 = ptrtoint ptr %r123.ptr to i64
  %r124 = load i64, ptr %slot.p2, align 8
  %r125.ptr = call ptr @nova_rt_struct_alloc(i64 16)
  %r125.f0 = getelementptr i64, ptr %r125.ptr, i64 0
  store i64 %r123, ptr %r125.f0, align 8
  %r125.f1 = getelementptr i64, ptr %r125.ptr, i64 1
  store i64 %r124, ptr %r125.f1, align 8
  %r125 = ptrtoint ptr %r125.ptr to i64
  ret i64 0
}

define i64 @parse_type_decl(i64 %p0, i64 %p1) nounwind {
entry:
  %slot.tokens = alloca i64, align 8
  store i64 %p0, ptr %slot.tokens, align 8
  %slot.pos = alloca i64, align 8
  store i64 %p1, ptr %slot.pos, align 8
  %slot.p = alloca i64, align 8
  store i64 0, ptr %slot.p, align 8
  %slot.name = alloca i64, align 8
  store i64 0, ptr %slot.name, align 8
  %slot.p2 = alloca i64, align 8
  store i64 0, ptr %slot.p2, align 8
  %slot.fields = alloca i64, align 8
  store i64 0, ptr %slot.fields, align 8
  %slot.cur_tok = alloca i64, align 8
  store i64 0, ptr %slot.cur_tok, align 8
  %r0 = load i64, ptr %slot.pos, align 8
  %r1 = add i64 1, 0
  %r2 = call i64 @nova_rt_add(i64 %r0, i64 %r1)
  store i64 %r2, ptr %slot.p, align 8
  %r3 = load i64, ptr %slot.tokens, align 8
  %r4 = load i64, ptr %slot.p, align 8
  %r5 = call i64 @tv(i64 %r3, i64 %r4)
  store i64 %r5, ptr %slot.name, align 8
  %r6 = load i64, ptr %slot.p, align 8
  %r7 = add i64 1, 0
  %r8 = call i64 @nova_rt_add(i64 %r6, i64 %r7)
  store i64 %r8, ptr %slot.p, align 8
  %r9 = load i64, ptr %slot.tokens, align 8
  %r10 = load i64, ptr %slot.p, align 8
  %r11 = call i64 @skip_nl(i64 %r9, i64 %r10)
  store i64 %r11, ptr %slot.p2, align 8
  %r12 = call i64 @nova_rt_list_create()
  store i64 %r12, ptr %slot.fields, align 8
  br label %while_hdr441
while_hdr441:
  %r13 = load i64, ptr %slot.tokens, align 8
  %r14 = load i64, ptr %slot.p2, align 8
  %r15 = call i64 @tk(i64 %r13, i64 %r14)
  %r16.p = getelementptr inbounds [4 x i8], ptr @.str.107, i64 0, i64 0
  %r16 = ptrtoint ptr %r16.p to i64
  %r17 = call i64 @nova_rt_neq(i64 %r15, i64 %r16)
  %br_while_body442 = icmp ne i64 %r17, 0
  br i1 %br_while_body442, label %while_body442, label %while_exit443
while_body442:
  %r18 = load i64, ptr %slot.tokens, align 8
  %r19 = load i64, ptr %slot.p2, align 8
  %r20 = call i64 @nova_rt_index_get(i64 %r18, i64 %r19)
  store i64 %r20, ptr %slot.cur_tok, align 8
  br label %while_hdr441
while_exit443:
  %r21.p = getelementptr inbounds [5 x i8], ptr @.str.13, i64 0, i64 0
  %r21 = ptrtoint ptr %r21.p to i64
  %r22 = load i64, ptr %slot.name, align 8
  %r23 = call i64 @null_expr()
  %r24 = call i64 @nova_rt_list_create()
  %r25 = load i64, ptr %slot.fields, align 8
  %r26 = call i64 @nova_rt_list_create()
  %r27 = call i64 @nova_rt_list_create()
  %r28.ptr = call ptr @nova_rt_struct_alloc(i64 56)
  %r28.f0 = getelementptr i64, ptr %r28.ptr, i64 0
  store i64 %r21, ptr %r28.f0, align 8
  %r28.f1 = getelementptr i64, ptr %r28.ptr, i64 1
  store i64 %r22, ptr %r28.f1, align 8
  %r28.f2 = getelementptr i64, ptr %r28.ptr, i64 2
  store i64 %r23, ptr %r28.f2, align 8
  %r28.f3 = getelementptr i64, ptr %r28.ptr, i64 3
  store i64 %r24, ptr %r28.f3, align 8
  %r28.f4 = getelementptr i64, ptr %r28.ptr, i64 4
  store i64 %r25, ptr %r28.f4, align 8
  %r28.f5 = getelementptr i64, ptr %r28.ptr, i64 5
  store i64 %r26, ptr %r28.f5, align 8
  %r28.f6 = getelementptr i64, ptr %r28.ptr, i64 6
  store i64 %r27, ptr %r28.f6, align 8
  %r28 = ptrtoint ptr %r28.ptr to i64
  %r29 = load i64, ptr %slot.p2, align 8
  %r30.ptr = call ptr @nova_rt_struct_alloc(i64 16)
  %r30.f0 = getelementptr i64, ptr %r30.ptr, i64 0
  store i64 %r28, ptr %r30.f0, align 8
  %r30.f1 = getelementptr i64, ptr %r30.ptr, i64 1
  store i64 %r29, ptr %r30.f1, align 8
  %r30 = ptrtoint ptr %r30.ptr to i64
  ret i64 0
}

define i64 @parse_if_chain(i64 %p0, i64 %p1, i64 %p2) nounwind {
entry:
  %slot.tokens = alloca i64, align 8
  store i64 %p0, ptr %slot.tokens, align 8
  %slot.pos = alloca i64, align 8
  store i64 %p1, ptr %slot.pos, align 8
  %slot.base_col = alloca i64, align 8
  store i64 %p2, ptr %slot.base_col, align 8
  %slot.p = alloca i64, align 8
  store i64 0, ptr %slot.p, align 8
  %slot.cond_r = alloca i64, align 8
  store i64 0, ptr %slot.cond_r, align 8
  %slot.p2 = alloca i64, align 8
  store i64 0, ptr %slot.p2, align 8
  %slot.then_body = alloca i64, align 8
  store i64 0, ptr %slot.then_body, align 8
  %slot.sr = alloca i64, align 8
  store i64 0, ptr %slot.sr, align 8
  %slot.else_body = alloca i64, align 8
  store i64 0, ptr %slot.else_body, align 8
  %slot.nested_r = alloca i64, align 8
  store i64 0, ptr %slot.nested_r, align 8
  %r0 = load i64, ptr %slot.pos, align 8
  %r1 = add i64 1, 0
  %r2 = call i64 @nova_rt_add(i64 %r0, i64 %r1)
  store i64 %r2, ptr %slot.p, align 8
  %r3 = load i64, ptr %slot.tokens, align 8
  %r4 = load i64, ptr %slot.p, align 8
  %r5 = add i64 0, 0
  %r6 = call i64 @parse_expr(i64 %r3, i64 %r4, i64 %r5)
  store i64 %r6, ptr %slot.cond_r, align 8
  %r7 = load i64, ptr %slot.tokens, align 8
  %r8 = add i64 0, 0
  %r9 = call i64 @skip_nl(i64 %r7, i64 %r8)
  store i64 %r9, ptr %slot.p2, align 8
  %r10 = call i64 @nova_rt_list_create()
  store i64 %r10, ptr %slot.then_body, align 8
  br label %while_hdr444
while_hdr444:
  %r11 = load i64, ptr %slot.tokens, align 8
  %r12 = load i64, ptr %slot.p2, align 8
  %r13 = call i64 @tk(i64 %r11, i64 %r12)
  %r14.p = getelementptr inbounds [4 x i8], ptr @.str.107, i64 0, i64 0
  %r14 = ptrtoint ptr %r14.p to i64
  %r15 = call i64 @nova_rt_neq(i64 %r13, i64 %r14)
  %br_while_body445 = icmp ne i64 %r15, 0
  br i1 %br_while_body445, label %while_body445, label %while_exit446
while_body445:
  %r16 = load i64, ptr %slot.tokens, align 8
  %r17 = load i64, ptr %slot.p2, align 8
  %r18 = call i64 @tok_col(i64 %r16, i64 %r17)
  %r19 = load i64, ptr %slot.base_col, align 8
  %r20.cmp = icmp sle i64 %r18, %r19
  %r20 = zext i1 %r20.cmp to i64
  %br_then447 = icmp ne i64 %r20, 0
  br i1 %br_then447, label %then447, label %else448
then447:
  br label %endif449
else448:
  br label %endif449
endif449:
  %r21 = load i64, ptr %slot.tokens, align 8
  %r22 = load i64, ptr %slot.p2, align 8
  %r23 = call i64 @parse_stmt(i64 %r21, i64 %r22)
  store i64 %r23, ptr %slot.sr, align 8
  %r24 = load i64, ptr %slot.then_body, align 8
  %r25 = add i64 0, 0
  %r26 = call i64 @nova_rt_list_append(i64 %r24, i64 %r25)
  %r27 = load i64, ptr %slot.tokens, align 8
  %r28 = add i64 0, 0
  %r29 = call i64 @skip_nl(i64 %r27, i64 %r28)
  store i64 %r29, ptr %slot.p2, align 8
  br label %while_hdr444
while_exit446:
  %r30 = call i64 @nova_rt_list_create()
  store i64 %r30, ptr %slot.else_body, align 8
  %r31 = load i64, ptr %slot.tokens, align 8
  %r32 = load i64, ptr %slot.p2, align 8
  %r33 = call i64 @tk(i64 %r31, i64 %r32)
  %r34.p = getelementptr inbounds [3 x i8], ptr @.str.43, i64 0, i64 0
  %r34 = ptrtoint ptr %r34.p to i64
  %r35 = call i64 @nova_rt_eq(i64 %r33, i64 %r34)
  %r36 = load i64, ptr %slot.tokens, align 8
  %r37 = load i64, ptr %slot.p2, align 8
  %r38 = call i64 @tv(i64 %r36, i64 %r37)
  %r39.p = getelementptr inbounds [5 x i8], ptr @.str.7, i64 0, i64 0
  %r39 = ptrtoint ptr %r39.p to i64
  %r40 = call i64 @nova_rt_eq(i64 %r38, i64 %r39)
  %r41.cmp = icmp ne i64 %r35, 0
  %r41.cmp2 = icmp ne i64 %r40, 0
  %r41.and = and i1 %r41.cmp, %r41.cmp2
  %r41 = zext i1 %r41.and to i64
  %r42 = load i64, ptr %slot.tokens, align 8
  %r43 = load i64, ptr %slot.p2, align 8
  %r44 = call i64 @tok_col(i64 %r42, i64 %r43)
  %r45 = load i64, ptr %slot.base_col, align 8
  %r46 = call i64 @nova_rt_eq(i64 %r44, i64 %r45)
  %r47.cmp = icmp ne i64 %r41, 0
  %r47.cmp2 = icmp ne i64 %r46, 0
  %r47.and = and i1 %r47.cmp, %r47.cmp2
  %r47 = zext i1 %r47.and to i64
  %br_then450 = icmp ne i64 %r47, 0
  br i1 %br_then450, label %then450, label %else451
then450:
  %r48 = load i64, ptr %slot.p2, align 8
  %r49 = add i64 1, 0
  %r50 = call i64 @nova_rt_add(i64 %r48, i64 %r49)
  store i64 %r50, ptr %slot.p2, align 8
  %r51 = load i64, ptr %slot.tokens, align 8
  %r52 = load i64, ptr %slot.p2, align 8
  %r53 = call i64 @skip_nl(i64 %r51, i64 %r52)
  store i64 %r53, ptr %slot.p2, align 8
  %r54 = load i64, ptr %slot.tokens, align 8
  %r55 = load i64, ptr %slot.p2, align 8
  %r56 = call i64 @tk(i64 %r54, i64 %r55)
  %r57.p = getelementptr inbounds [3 x i8], ptr @.str.43, i64 0, i64 0
  %r57 = ptrtoint ptr %r57.p to i64
  %r58 = call i64 @nova_rt_eq(i64 %r56, i64 %r57)
  %r59 = load i64, ptr %slot.tokens, align 8
  %r60 = load i64, ptr %slot.p2, align 8
  %r61 = call i64 @tv(i64 %r59, i64 %r60)
  %r62.p = getelementptr inbounds [3 x i8], ptr @.str.6, i64 0, i64 0
  %r62 = ptrtoint ptr %r62.p to i64
  %r63 = call i64 @nova_rt_eq(i64 %r61, i64 %r62)
  %r64.cmp = icmp ne i64 %r58, 0
  %r64.cmp2 = icmp ne i64 %r63, 0
  %r64.and = and i1 %r64.cmp, %r64.cmp2
  %r64 = zext i1 %r64.and to i64
  %br_then453 = icmp ne i64 %r64, 0
  br i1 %br_then453, label %then453, label %else454
then453:
  %r65 = load i64, ptr %slot.tokens, align 8
  %r66 = load i64, ptr %slot.p2, align 8
  %r67 = load i64, ptr %slot.base_col, align 8
  %r68 = call i64 @parse_if_chain(i64 %r65, i64 %r66, i64 %r67)
  store i64 %r68, ptr %slot.nested_r, align 8
  %r69 = load i64, ptr %slot.else_body, align 8
  %r70 = add i64 0, 0
  %r71 = call i64 @nova_rt_list_append(i64 %r69, i64 %r70)
  %r72 = add i64 0, 0
  store i64 %r72, ptr %slot.p2, align 8
  br label %endif455
else454:
  br label %while_hdr456
while_hdr456:
  %r73 = load i64, ptr %slot.tokens, align 8
  %r74 = load i64, ptr %slot.p2, align 8
  %r75 = call i64 @tk(i64 %r73, i64 %r74)
  %r76.p = getelementptr inbounds [4 x i8], ptr @.str.107, i64 0, i64 0
  %r76 = ptrtoint ptr %r76.p to i64
  %r77 = call i64 @nova_rt_neq(i64 %r75, i64 %r76)
  %br_while_body457 = icmp ne i64 %r77, 0
  br i1 %br_while_body457, label %while_body457, label %while_exit458
while_body457:
  %r78 = load i64, ptr %slot.tokens, align 8
  %r79 = load i64, ptr %slot.p2, align 8
  %r80 = call i64 @tok_col(i64 %r78, i64 %r79)
  %r81 = load i64, ptr %slot.base_col, align 8
  %r82.cmp = icmp sle i64 %r80, %r81
  %r82 = zext i1 %r82.cmp to i64
  %br_then459 = icmp ne i64 %r82, 0
  br i1 %br_then459, label %then459, label %else460
then459:
  br label %endif461
else460:
  br label %endif461
endif461:
  %r83 = load i64, ptr %slot.tokens, align 8
  %r84 = load i64, ptr %slot.p2, align 8
  %r85 = call i64 @parse_stmt(i64 %r83, i64 %r84)
  store i64 %r85, ptr %slot.sr, align 8
  %r86 = load i64, ptr %slot.else_body, align 8
  %r87 = add i64 0, 0
  %r88 = call i64 @nova_rt_list_append(i64 %r86, i64 %r87)
  %r89 = load i64, ptr %slot.tokens, align 8
  %r90 = add i64 0, 0
  %r91 = call i64 @skip_nl(i64 %r89, i64 %r90)
  store i64 %r91, ptr %slot.p2, align 8
  br label %while_hdr456
while_exit458:
  br label %endif455
endif455:
  br label %endif452
else451:
  br label %endif452
endif452:
  %r92.p = getelementptr inbounds [3 x i8], ptr @.str.6, i64 0, i64 0
  %r92 = ptrtoint ptr %r92.p to i64
  %r93.p = getelementptr inbounds [1 x i8], ptr @.str.42, i64 0, i64 0
  %r93 = ptrtoint ptr %r93.p to i64
  %r94 = add i64 0, 0
  %r95 = load i64, ptr %slot.then_body, align 8
  %r96 = call i64 @nova_rt_list_create()
  %r97 = load i64, ptr %slot.else_body, align 8
  %r98 = call i64 @nova_rt_list_create()
  %r99.ptr = call ptr @nova_rt_struct_alloc(i64 56)
  %r99.f0 = getelementptr i64, ptr %r99.ptr, i64 0
  store i64 %r92, ptr %r99.f0, align 8
  %r99.f1 = getelementptr i64, ptr %r99.ptr, i64 1
  store i64 %r93, ptr %r99.f1, align 8
  %r99.f2 = getelementptr i64, ptr %r99.ptr, i64 2
  store i64 %r94, ptr %r99.f2, align 8
  %r99.f3 = getelementptr i64, ptr %r99.ptr, i64 3
  store i64 %r95, ptr %r99.f3, align 8
  %r99.f4 = getelementptr i64, ptr %r99.ptr, i64 4
  store i64 %r96, ptr %r99.f4, align 8
  %r99.f5 = getelementptr i64, ptr %r99.ptr, i64 5
  store i64 %r97, ptr %r99.f5, align 8
  %r99.f6 = getelementptr i64, ptr %r99.ptr, i64 6
  store i64 %r98, ptr %r99.f6, align 8
  %r99 = ptrtoint ptr %r99.ptr to i64
  %r100 = load i64, ptr %slot.p2, align 8
  %r101.ptr = call ptr @nova_rt_struct_alloc(i64 16)
  %r101.f0 = getelementptr i64, ptr %r101.ptr, i64 0
  store i64 %r99, ptr %r101.f0, align 8
  %r101.f1 = getelementptr i64, ptr %r101.ptr, i64 1
  store i64 %r100, ptr %r101.f1, align 8
  %r101 = ptrtoint ptr %r101.ptr to i64
  ret i64 0
}

define i64 @parse_if_stmt(i64 %p0, i64 %p1) nounwind {
entry:
  %slot.tokens = alloca i64, align 8
  store i64 %p0, ptr %slot.tokens, align 8
  %slot.pos = alloca i64, align 8
  store i64 %p1, ptr %slot.pos, align 8
  %r0 = load i64, ptr %slot.tokens, align 8
  %r1 = load i64, ptr %slot.pos, align 8
  %r2 = load i64, ptr %slot.tokens, align 8
  %r3 = load i64, ptr %slot.pos, align 8
  %r4 = call i64 @tok_col(i64 %r2, i64 %r3)
  %r5 = call i64 @parse_if_chain(i64 %r0, i64 %r1, i64 %r4)
  ret i64 0
}

define i64 @parse_while_stmt(i64 %p0, i64 %p1) nounwind {
entry:
  %slot.tokens = alloca i64, align 8
  store i64 %p0, ptr %slot.tokens, align 8
  %slot.pos = alloca i64, align 8
  store i64 %p1, ptr %slot.pos, align 8
  %slot.kw_col = alloca i64, align 8
  store i64 0, ptr %slot.kw_col, align 8
  %slot.p = alloca i64, align 8
  store i64 0, ptr %slot.p, align 8
  %slot.cond_r = alloca i64, align 8
  store i64 0, ptr %slot.cond_r, align 8
  %slot.p2 = alloca i64, align 8
  store i64 0, ptr %slot.p2, align 8
  %slot.body = alloca i64, align 8
  store i64 0, ptr %slot.body, align 8
  %slot.sr = alloca i64, align 8
  store i64 0, ptr %slot.sr, align 8
  %r0 = load i64, ptr %slot.tokens, align 8
  %r1 = load i64, ptr %slot.pos, align 8
  %r2 = call i64 @tok_col(i64 %r0, i64 %r1)
  store i64 %r2, ptr %slot.kw_col, align 8
  %r3 = load i64, ptr %slot.pos, align 8
  %r4 = add i64 1, 0
  %r5 = call i64 @nova_rt_add(i64 %r3, i64 %r4)
  store i64 %r5, ptr %slot.p, align 8
  %r6 = load i64, ptr %slot.tokens, align 8
  %r7 = load i64, ptr %slot.p, align 8
  %r8 = add i64 0, 0
  %r9 = call i64 @parse_expr(i64 %r6, i64 %r7, i64 %r8)
  store i64 %r9, ptr %slot.cond_r, align 8
  %r10 = load i64, ptr %slot.tokens, align 8
  %r11 = add i64 0, 0
  %r12 = call i64 @skip_nl(i64 %r10, i64 %r11)
  store i64 %r12, ptr %slot.p2, align 8
  %r13 = call i64 @nova_rt_list_create()
  store i64 %r13, ptr %slot.body, align 8
  br label %while_hdr462
while_hdr462:
  %r14 = load i64, ptr %slot.tokens, align 8
  %r15 = load i64, ptr %slot.p2, align 8
  %r16 = call i64 @tk(i64 %r14, i64 %r15)
  %r17.p = getelementptr inbounds [4 x i8], ptr @.str.107, i64 0, i64 0
  %r17 = ptrtoint ptr %r17.p to i64
  %r18 = call i64 @nova_rt_neq(i64 %r16, i64 %r17)
  %br_while_body463 = icmp ne i64 %r18, 0
  br i1 %br_while_body463, label %while_body463, label %while_exit464
while_body463:
  %r19 = load i64, ptr %slot.tokens, align 8
  %r20 = load i64, ptr %slot.p2, align 8
  %r21 = call i64 @tok_col(i64 %r19, i64 %r20)
  %r22 = load i64, ptr %slot.kw_col, align 8
  %r23.cmp = icmp sle i64 %r21, %r22
  %r23 = zext i1 %r23.cmp to i64
  %br_then465 = icmp ne i64 %r23, 0
  br i1 %br_then465, label %then465, label %else466
then465:
  br label %endif467
else466:
  br label %endif467
endif467:
  %r24 = load i64, ptr %slot.tokens, align 8
  %r25 = load i64, ptr %slot.p2, align 8
  %r26 = call i64 @parse_stmt(i64 %r24, i64 %r25)
  store i64 %r26, ptr %slot.sr, align 8
  %r27 = load i64, ptr %slot.body, align 8
  %r28 = add i64 0, 0
  %r29 = call i64 @nova_rt_list_append(i64 %r27, i64 %r28)
  %r30 = load i64, ptr %slot.tokens, align 8
  %r31 = add i64 0, 0
  %r32 = call i64 @skip_nl(i64 %r30, i64 %r31)
  store i64 %r32, ptr %slot.p2, align 8
  br label %while_hdr462
while_exit464:
  %r33.p = getelementptr inbounds [6 x i8], ptr @.str.9, i64 0, i64 0
  %r33 = ptrtoint ptr %r33.p to i64
  %r34.p = getelementptr inbounds [1 x i8], ptr @.str.42, i64 0, i64 0
  %r34 = ptrtoint ptr %r34.p to i64
  %r35 = add i64 0, 0
  %r36 = load i64, ptr %slot.body, align 8
  %r37 = call i64 @nova_rt_list_create()
  %r38 = call i64 @nova_rt_list_create()
  %r39 = call i64 @nova_rt_list_create()
  %r40.ptr = call ptr @nova_rt_struct_alloc(i64 56)
  %r40.f0 = getelementptr i64, ptr %r40.ptr, i64 0
  store i64 %r33, ptr %r40.f0, align 8
  %r40.f1 = getelementptr i64, ptr %r40.ptr, i64 1
  store i64 %r34, ptr %r40.f1, align 8
  %r40.f2 = getelementptr i64, ptr %r40.ptr, i64 2
  store i64 %r35, ptr %r40.f2, align 8
  %r40.f3 = getelementptr i64, ptr %r40.ptr, i64 3
  store i64 %r36, ptr %r40.f3, align 8
  %r40.f4 = getelementptr i64, ptr %r40.ptr, i64 4
  store i64 %r37, ptr %r40.f4, align 8
  %r40.f5 = getelementptr i64, ptr %r40.ptr, i64 5
  store i64 %r38, ptr %r40.f5, align 8
  %r40.f6 = getelementptr i64, ptr %r40.ptr, i64 6
  store i64 %r39, ptr %r40.f6, align 8
  %r40 = ptrtoint ptr %r40.ptr to i64
  %r41 = load i64, ptr %slot.p2, align 8
  %r42.ptr = call ptr @nova_rt_struct_alloc(i64 16)
  %r42.f0 = getelementptr i64, ptr %r42.ptr, i64 0
  store i64 %r40, ptr %r42.f0, align 8
  %r42.f1 = getelementptr i64, ptr %r42.ptr, i64 1
  store i64 %r41, ptr %r42.f1, align 8
  %r42 = ptrtoint ptr %r42.ptr to i64
  ret i64 0
}

define i64 @parse_for_stmt(i64 %p0, i64 %p1) nounwind {
entry:
  %slot.tokens = alloca i64, align 8
  store i64 %p0, ptr %slot.tokens, align 8
  %slot.pos = alloca i64, align 8
  store i64 %p1, ptr %slot.pos, align 8
  %slot.kw_col = alloca i64, align 8
  store i64 0, ptr %slot.kw_col, align 8
  %slot.p = alloca i64, align 8
  store i64 0, ptr %slot.p, align 8
  %slot.var_name = alloca i64, align 8
  store i64 0, ptr %slot.var_name, align 8
  %slot.iter_r = alloca i64, align 8
  store i64 0, ptr %slot.iter_r, align 8
  %slot.p2 = alloca i64, align 8
  store i64 0, ptr %slot.p2, align 8
  %slot.body = alloca i64, align 8
  store i64 0, ptr %slot.body, align 8
  %slot.sr = alloca i64, align 8
  store i64 0, ptr %slot.sr, align 8
  %r0 = load i64, ptr %slot.tokens, align 8
  %r1 = load i64, ptr %slot.pos, align 8
  %r2 = call i64 @tok_col(i64 %r0, i64 %r1)
  store i64 %r2, ptr %slot.kw_col, align 8
  %r3 = load i64, ptr %slot.pos, align 8
  %r4 = add i64 1, 0
  %r5 = call i64 @nova_rt_add(i64 %r3, i64 %r4)
  store i64 %r5, ptr %slot.p, align 8
  %r6 = load i64, ptr %slot.tokens, align 8
  %r7 = load i64, ptr %slot.p, align 8
  %r8 = call i64 @tv(i64 %r6, i64 %r7)
  store i64 %r8, ptr %slot.var_name, align 8
  %r9 = load i64, ptr %slot.p, align 8
  %r10 = add i64 1, 0
  %r11 = call i64 @nova_rt_add(i64 %r9, i64 %r10)
  store i64 %r11, ptr %slot.p, align 8
  %r12 = load i64, ptr %slot.tokens, align 8
  %r13 = load i64, ptr %slot.p, align 8
  %r14 = call i64 @tk(i64 %r12, i64 %r13)
  %r15.p = getelementptr inbounds [3 x i8], ptr @.str.43, i64 0, i64 0
  %r15 = ptrtoint ptr %r15.p to i64
  %r16 = call i64 @nova_rt_eq(i64 %r14, i64 %r15)
  %r17 = load i64, ptr %slot.tokens, align 8
  %r18 = load i64, ptr %slot.p, align 8
  %r19 = call i64 @tv(i64 %r17, i64 %r18)
  %r20.p = getelementptr inbounds [3 x i8], ptr @.str.27, i64 0, i64 0
  %r20 = ptrtoint ptr %r20.p to i64
  %r21 = call i64 @nova_rt_eq(i64 %r19, i64 %r20)
  %r22.cmp = icmp ne i64 %r16, 0
  %r22.cmp2 = icmp ne i64 %r21, 0
  %r22.and = and i1 %r22.cmp, %r22.cmp2
  %r22 = zext i1 %r22.and to i64
  %br_then468 = icmp ne i64 %r22, 0
  br i1 %br_then468, label %then468, label %else469
then468:
  %r23 = load i64, ptr %slot.p, align 8
  %r24 = add i64 1, 0
  %r25 = call i64 @nova_rt_add(i64 %r23, i64 %r24)
  store i64 %r25, ptr %slot.p, align 8
  br label %endif470
else469:
  br label %endif470
endif470:
  %r26 = load i64, ptr %slot.tokens, align 8
  %r27 = load i64, ptr %slot.p, align 8
  %r28 = add i64 0, 0
  %r29 = call i64 @parse_expr(i64 %r26, i64 %r27, i64 %r28)
  store i64 %r29, ptr %slot.iter_r, align 8
  %r30 = load i64, ptr %slot.tokens, align 8
  %r31 = add i64 0, 0
  %r32 = call i64 @skip_nl(i64 %r30, i64 %r31)
  store i64 %r32, ptr %slot.p2, align 8
  %r33 = call i64 @nova_rt_list_create()
  store i64 %r33, ptr %slot.body, align 8
  br label %while_hdr471
while_hdr471:
  %r34 = load i64, ptr %slot.tokens, align 8
  %r35 = load i64, ptr %slot.p2, align 8
  %r36 = call i64 @tk(i64 %r34, i64 %r35)
  %r37.p = getelementptr inbounds [4 x i8], ptr @.str.107, i64 0, i64 0
  %r37 = ptrtoint ptr %r37.p to i64
  %r38 = call i64 @nova_rt_neq(i64 %r36, i64 %r37)
  %br_while_body472 = icmp ne i64 %r38, 0
  br i1 %br_while_body472, label %while_body472, label %while_exit473
while_body472:
  %r39 = load i64, ptr %slot.tokens, align 8
  %r40 = load i64, ptr %slot.p2, align 8
  %r41 = call i64 @tok_col(i64 %r39, i64 %r40)
  %r42 = load i64, ptr %slot.kw_col, align 8
  %r43.cmp = icmp sle i64 %r41, %r42
  %r43 = zext i1 %r43.cmp to i64
  %br_then474 = icmp ne i64 %r43, 0
  br i1 %br_then474, label %then474, label %else475
then474:
  br label %endif476
else475:
  br label %endif476
endif476:
  %r44 = load i64, ptr %slot.tokens, align 8
  %r45 = load i64, ptr %slot.p2, align 8
  %r46 = call i64 @parse_stmt(i64 %r44, i64 %r45)
  store i64 %r46, ptr %slot.sr, align 8
  %r47 = load i64, ptr %slot.body, align 8
  %r48 = add i64 0, 0
  %r49 = call i64 @nova_rt_list_append(i64 %r47, i64 %r48)
  %r50 = load i64, ptr %slot.tokens, align 8
  %r51 = add i64 0, 0
  %r52 = call i64 @skip_nl(i64 %r50, i64 %r51)
  store i64 %r52, ptr %slot.p2, align 8
  br label %while_hdr471
while_exit473:
  %r53.p = getelementptr inbounds [4 x i8], ptr @.str.8, i64 0, i64 0
  %r53 = ptrtoint ptr %r53.p to i64
  %r54 = load i64, ptr %slot.var_name, align 8
  %r55 = add i64 0, 0
  %r56 = load i64, ptr %slot.body, align 8
  %r57 = call i64 @nova_rt_list_create()
  %r58 = call i64 @nova_rt_list_create()
  %r59 = call i64 @nova_rt_list_create()
  %r60.ptr = call ptr @nova_rt_struct_alloc(i64 56)
  %r60.f0 = getelementptr i64, ptr %r60.ptr, i64 0
  store i64 %r53, ptr %r60.f0, align 8
  %r60.f1 = getelementptr i64, ptr %r60.ptr, i64 1
  store i64 %r54, ptr %r60.f1, align 8
  %r60.f2 = getelementptr i64, ptr %r60.ptr, i64 2
  store i64 %r55, ptr %r60.f2, align 8
  %r60.f3 = getelementptr i64, ptr %r60.ptr, i64 3
  store i64 %r56, ptr %r60.f3, align 8
  %r60.f4 = getelementptr i64, ptr %r60.ptr, i64 4
  store i64 %r57, ptr %r60.f4, align 8
  %r60.f5 = getelementptr i64, ptr %r60.ptr, i64 5
  store i64 %r58, ptr %r60.f5, align 8
  %r60.f6 = getelementptr i64, ptr %r60.ptr, i64 6
  store i64 %r59, ptr %r60.f6, align 8
  %r60 = ptrtoint ptr %r60.ptr to i64
  %r61 = load i64, ptr %slot.p2, align 8
  %r62.ptr = call ptr @nova_rt_struct_alloc(i64 16)
  %r62.f0 = getelementptr i64, ptr %r62.ptr, i64 0
  store i64 %r60, ptr %r62.f0, align 8
  %r62.f1 = getelementptr i64, ptr %r62.ptr, i64 1
  store i64 %r61, ptr %r62.f1, align 8
  %r62 = ptrtoint ptr %r62.ptr to i64
  ret i64 0
}

define i64 @parse_match_stmt(i64 %p0, i64 %p1) nounwind {
entry:
  %slot.tokens = alloca i64, align 8
  store i64 %p0, ptr %slot.tokens, align 8
  %slot.pos = alloca i64, align 8
  store i64 %p1, ptr %slot.pos, align 8
  %slot.kw_col = alloca i64, align 8
  store i64 0, ptr %slot.kw_col, align 8
  %slot.p = alloca i64, align 8
  store i64 0, ptr %slot.p, align 8
  %slot.subject_r = alloca i64, align 8
  store i64 0, ptr %slot.subject_r, align 8
  %slot.p2 = alloca i64, align 8
  store i64 0, ptr %slot.p2, align 8
  %slot.arms = alloca i64, align 8
  store i64 0, ptr %slot.arms, align 8
  %slot.pat_r = alloca i64, align 8
  store i64 0, ptr %slot.pat_r, align 8
  %slot.arm_col = alloca i64, align 8
  store i64 0, ptr %slot.arm_col, align 8
  %slot.arm_body = alloca i64, align 8
  store i64 0, ptr %slot.arm_body, align 8
  %slot.sr = alloca i64, align 8
  store i64 0, ptr %slot.sr, align 8
  %r0 = load i64, ptr %slot.tokens, align 8
  %r1 = load i64, ptr %slot.pos, align 8
  %r2 = call i64 @tok_col(i64 %r0, i64 %r1)
  store i64 %r2, ptr %slot.kw_col, align 8
  %r3 = load i64, ptr %slot.pos, align 8
  %r4 = add i64 1, 0
  %r5 = call i64 @nova_rt_add(i64 %r3, i64 %r4)
  store i64 %r5, ptr %slot.p, align 8
  %r6 = load i64, ptr %slot.tokens, align 8
  %r7 = load i64, ptr %slot.p, align 8
  %r8 = add i64 0, 0
  %r9 = call i64 @parse_expr(i64 %r6, i64 %r7, i64 %r8)
  store i64 %r9, ptr %slot.subject_r, align 8
  %r10 = load i64, ptr %slot.tokens, align 8
  %r11 = add i64 0, 0
  %r12 = call i64 @skip_nl(i64 %r10, i64 %r11)
  store i64 %r12, ptr %slot.p2, align 8
  %r13 = call i64 @nova_rt_list_create()
  store i64 %r13, ptr %slot.arms, align 8
  br label %while_hdr477
while_hdr477:
  %r14 = load i64, ptr %slot.tokens, align 8
  %r15 = load i64, ptr %slot.p2, align 8
  %r16 = call i64 @tk(i64 %r14, i64 %r15)
  %r17.p = getelementptr inbounds [4 x i8], ptr @.str.107, i64 0, i64 0
  %r17 = ptrtoint ptr %r17.p to i64
  %r18 = call i64 @nova_rt_neq(i64 %r16, i64 %r17)
  %br_while_body478 = icmp ne i64 %r18, 0
  br i1 %br_while_body478, label %while_body478, label %while_exit479
while_body478:
  %r19 = load i64, ptr %slot.tokens, align 8
  %r20 = load i64, ptr %slot.p2, align 8
  %r21 = call i64 @tok_col(i64 %r19, i64 %r20)
  %r22 = load i64, ptr %slot.kw_col, align 8
  %r23.cmp = icmp sle i64 %r21, %r22
  %r23 = zext i1 %r23.cmp to i64
  %br_then480 = icmp ne i64 %r23, 0
  br i1 %br_then480, label %then480, label %else481
then480:
  br label %endif482
else481:
  br label %endif482
endif482:
  %r24 = load i64, ptr %slot.tokens, align 8
  %r25 = load i64, ptr %slot.p2, align 8
  %r26 = call i64 @parse_pattern(i64 %r24, i64 %r25)
  store i64 %r26, ptr %slot.pat_r, align 8
  %r27 = load i64, ptr %slot.tokens, align 8
  %r28 = load i64, ptr %slot.p2, align 8
  %r29 = call i64 @tok_col(i64 %r27, i64 %r28)
  store i64 %r29, ptr %slot.arm_col, align 8
  %r30 = add i64 0, 0
  store i64 %r30, ptr %slot.p2, align 8
  %r31 = load i64, ptr %slot.tokens, align 8
  %r32 = load i64, ptr %slot.p2, align 8
  %r33 = call i64 @tk(i64 %r31, i64 %r32)
  %r34.p = getelementptr inbounds [10 x i8], ptr @.str.89, i64 0, i64 0
  %r34 = ptrtoint ptr %r34.p to i64
  %r35 = call i64 @nova_rt_eq(i64 %r33, i64 %r34)
  %br_then483 = icmp ne i64 %r35, 0
  br i1 %br_then483, label %then483, label %else484
then483:
  %r36 = load i64, ptr %slot.p2, align 8
  %r37 = add i64 1, 0
  %r38 = call i64 @nova_rt_add(i64 %r36, i64 %r37)
  store i64 %r38, ptr %slot.p2, align 8
  br label %endif485
else484:
  br label %endif485
endif485:
  %r39 = load i64, ptr %slot.tokens, align 8
  %r40 = load i64, ptr %slot.p2, align 8
  %r41 = call i64 @skip_nl(i64 %r39, i64 %r40)
  store i64 %r41, ptr %slot.p2, align 8
  %r42 = call i64 @nova_rt_list_create()
  store i64 %r42, ptr %slot.arm_body, align 8
  br label %while_hdr486
while_hdr486:
  %r43 = load i64, ptr %slot.tokens, align 8
  %r44 = load i64, ptr %slot.p2, align 8
  %r45 = call i64 @tk(i64 %r43, i64 %r44)
  %r46.p = getelementptr inbounds [4 x i8], ptr @.str.107, i64 0, i64 0
  %r46 = ptrtoint ptr %r46.p to i64
  %r47 = call i64 @nova_rt_neq(i64 %r45, i64 %r46)
  %br_while_body487 = icmp ne i64 %r47, 0
  br i1 %br_while_body487, label %while_body487, label %while_exit488
while_body487:
  %r48 = load i64, ptr %slot.tokens, align 8
  %r49 = load i64, ptr %slot.p2, align 8
  %r50 = call i64 @tok_col(i64 %r48, i64 %r49)
  %r51 = load i64, ptr %slot.arm_col, align 8
  %r52.cmp = icmp sle i64 %r50, %r51
  %r52 = zext i1 %r52.cmp to i64
  %br_then489 = icmp ne i64 %r52, 0
  br i1 %br_then489, label %then489, label %else490
then489:
  br label %endif491
else490:
  br label %endif491
endif491:
  %r53 = load i64, ptr %slot.tokens, align 8
  %r54 = load i64, ptr %slot.p2, align 8
  %r55 = call i64 @parse_stmt(i64 %r53, i64 %r54)
  store i64 %r55, ptr %slot.sr, align 8
  %r56 = load i64, ptr %slot.arm_body, align 8
  %r57 = add i64 0, 0
  %r58 = call i64 @nova_rt_list_append(i64 %r56, i64 %r57)
  %r59 = load i64, ptr %slot.tokens, align 8
  %r60 = add i64 0, 0
  %r61 = call i64 @skip_nl(i64 %r59, i64 %r60)
  store i64 %r61, ptr %slot.p2, align 8
  br label %while_hdr486
while_exit488:
  %r62 = load i64, ptr %slot.arms, align 8
  %r63.p = getelementptr inbounds [4 x i8], ptr @.str.126, i64 0, i64 0
  %r63 = ptrtoint ptr %r63.p to i64
  %r64.p = getelementptr inbounds [1 x i8], ptr @.str.42, i64 0, i64 0
  %r64 = ptrtoint ptr %r64.p to i64
  %r65 = add i64 0, 0
  %r66 = load i64, ptr %slot.arm_body, align 8
  %r67 = call i64 @nova_rt_list_create()
  %r68 = call i64 @nova_rt_list_create()
  %r69 = call i64 @nova_rt_list_create()
  %r70.ptr = call ptr @nova_rt_struct_alloc(i64 56)
  %r70.f0 = getelementptr i64, ptr %r70.ptr, i64 0
  store i64 %r63, ptr %r70.f0, align 8
  %r70.f1 = getelementptr i64, ptr %r70.ptr, i64 1
  store i64 %r64, ptr %r70.f1, align 8
  %r70.f2 = getelementptr i64, ptr %r70.ptr, i64 2
  store i64 %r65, ptr %r70.f2, align 8
  %r70.f3 = getelementptr i64, ptr %r70.ptr, i64 3
  store i64 %r66, ptr %r70.f3, align 8
  %r70.f4 = getelementptr i64, ptr %r70.ptr, i64 4
  store i64 %r67, ptr %r70.f4, align 8
  %r70.f5 = getelementptr i64, ptr %r70.ptr, i64 5
  store i64 %r68, ptr %r70.f5, align 8
  %r70.f6 = getelementptr i64, ptr %r70.ptr, i64 6
  store i64 %r69, ptr %r70.f6, align 8
  %r70 = ptrtoint ptr %r70.ptr to i64
  %r71 = call i64 @nova_rt_list_append(i64 %r62, i64 %r70)
  br label %while_hdr477
while_exit479:
  %r72.p = getelementptr inbounds [6 x i8], ptr @.str.10, i64 0, i64 0
  %r72 = ptrtoint ptr %r72.p to i64
  %r73.p = getelementptr inbounds [1 x i8], ptr @.str.42, i64 0, i64 0
  %r73 = ptrtoint ptr %r73.p to i64
  %r74 = add i64 0, 0
  %r75 = load i64, ptr %slot.arms, align 8
  %r76 = call i64 @nova_rt_list_create()
  %r77 = call i64 @nova_rt_list_create()
  %r78 = call i64 @nova_rt_list_create()
  %r79.ptr = call ptr @nova_rt_struct_alloc(i64 56)
  %r79.f0 = getelementptr i64, ptr %r79.ptr, i64 0
  store i64 %r72, ptr %r79.f0, align 8
  %r79.f1 = getelementptr i64, ptr %r79.ptr, i64 1
  store i64 %r73, ptr %r79.f1, align 8
  %r79.f2 = getelementptr i64, ptr %r79.ptr, i64 2
  store i64 %r74, ptr %r79.f2, align 8
  %r79.f3 = getelementptr i64, ptr %r79.ptr, i64 3
  store i64 %r75, ptr %r79.f3, align 8
  %r79.f4 = getelementptr i64, ptr %r79.ptr, i64 4
  store i64 %r76, ptr %r79.f4, align 8
  %r79.f5 = getelementptr i64, ptr %r79.ptr, i64 5
  store i64 %r77, ptr %r79.f5, align 8
  %r79.f6 = getelementptr i64, ptr %r79.ptr, i64 6
  store i64 %r78, ptr %r79.f6, align 8
  %r79 = ptrtoint ptr %r79.ptr to i64
  %r80 = load i64, ptr %slot.p2, align 8
  %r81.ptr = call ptr @nova_rt_struct_alloc(i64 16)
  %r81.f0 = getelementptr i64, ptr %r81.ptr, i64 0
  store i64 %r79, ptr %r81.f0, align 8
  %r81.f1 = getelementptr i64, ptr %r81.ptr, i64 1
  store i64 %r80, ptr %r81.f1, align 8
  %r81 = ptrtoint ptr %r81.ptr to i64
  ret i64 0
}

define i64 @parse_import_stmt(i64 %p0, i64 %p1) nounwind {
entry:
  %slot.tokens = alloca i64, align 8
  store i64 %p0, ptr %slot.tokens, align 8
  %slot.pos = alloca i64, align 8
  store i64 %p1, ptr %slot.pos, align 8
  %slot.p = alloca i64, align 8
  store i64 0, ptr %slot.p, align 8
  %slot.module_name = alloca i64, align 8
  store i64 0, ptr %slot.module_name, align 8
  %slot.alias = alloca i64, align 8
  store i64 0, ptr %slot.alias, align 8
  %r0 = load i64, ptr %slot.pos, align 8
  %r1 = add i64 1, 0
  %r2 = call i64 @nova_rt_add(i64 %r0, i64 %r1)
  store i64 %r2, ptr %slot.p, align 8
  %r3 = load i64, ptr %slot.tokens, align 8
  %r4 = load i64, ptr %slot.p, align 8
  %r5 = call i64 @tv(i64 %r3, i64 %r4)
  store i64 %r5, ptr %slot.module_name, align 8
  %r6 = load i64, ptr %slot.p, align 8
  %r7 = add i64 1, 0
  %r8 = call i64 @nova_rt_add(i64 %r6, i64 %r7)
  store i64 %r8, ptr %slot.p, align 8
  %r9 = load i64, ptr %slot.module_name, align 8
  store i64 %r9, ptr %slot.alias, align 8
  %r10 = load i64, ptr %slot.tokens, align 8
  %r11 = load i64, ptr %slot.p, align 8
  %r12 = call i64 @tk(i64 %r10, i64 %r11)
  %r13.p = getelementptr inbounds [3 x i8], ptr @.str.43, i64 0, i64 0
  %r13 = ptrtoint ptr %r13.p to i64
  %r14 = call i64 @nova_rt_eq(i64 %r12, i64 %r13)
  %r15 = load i64, ptr %slot.tokens, align 8
  %r16 = load i64, ptr %slot.p, align 8
  %r17 = call i64 @tv(i64 %r15, i64 %r16)
  %r18.p = getelementptr inbounds [3 x i8], ptr @.str.28, i64 0, i64 0
  %r18 = ptrtoint ptr %r18.p to i64
  %r19 = call i64 @nova_rt_eq(i64 %r17, i64 %r18)
  %r20.cmp = icmp ne i64 %r14, 0
  %r20.cmp2 = icmp ne i64 %r19, 0
  %r20.and = and i1 %r20.cmp, %r20.cmp2
  %r20 = zext i1 %r20.and to i64
  %br_then492 = icmp ne i64 %r20, 0
  br i1 %br_then492, label %then492, label %else493
then492:
  %r21 = load i64, ptr %slot.p, align 8
  %r22 = add i64 1, 0
  %r23 = call i64 @nova_rt_add(i64 %r21, i64 %r22)
  store i64 %r23, ptr %slot.p, align 8
  %r24 = load i64, ptr %slot.tokens, align 8
  %r25 = load i64, ptr %slot.p, align 8
  %r26 = call i64 @tv(i64 %r24, i64 %r25)
  store i64 %r26, ptr %slot.alias, align 8
  %r27 = load i64, ptr %slot.p, align 8
  %r28 = add i64 1, 0
  %r29 = call i64 @nova_rt_add(i64 %r27, i64 %r28)
  store i64 %r29, ptr %slot.p, align 8
  br label %endif494
else493:
  br label %endif494
endif494:
  %r30.p = getelementptr inbounds [7 x i8], ptr @.str.23, i64 0, i64 0
  %r30 = ptrtoint ptr %r30.p to i64
  %r31 = load i64, ptr %slot.module_name, align 8
  %r32 = call i64 @null_expr()
  %r33 = call i64 @nova_rt_list_create()
  %r34 = call i64 @nova_rt_list_create()
  %r35 = call i64 @nova_rt_list_create()
  %r37 = load i64, ptr %slot.alias, align 8
  %r36 = call i64 @nova_rt_list_create()
  call i64 @nova_rt_list_append(i64 %r36, i64 %r37)
  %r38.ptr = call ptr @nova_rt_struct_alloc(i64 56)
  %r38.f0 = getelementptr i64, ptr %r38.ptr, i64 0
  store i64 %r30, ptr %r38.f0, align 8
  %r38.f1 = getelementptr i64, ptr %r38.ptr, i64 1
  store i64 %r31, ptr %r38.f1, align 8
  %r38.f2 = getelementptr i64, ptr %r38.ptr, i64 2
  store i64 %r32, ptr %r38.f2, align 8
  %r38.f3 = getelementptr i64, ptr %r38.ptr, i64 3
  store i64 %r33, ptr %r38.f3, align 8
  %r38.f4 = getelementptr i64, ptr %r38.ptr, i64 4
  store i64 %r34, ptr %r38.f4, align 8
  %r38.f5 = getelementptr i64, ptr %r38.ptr, i64 5
  store i64 %r35, ptr %r38.f5, align 8
  %r38.f6 = getelementptr i64, ptr %r38.ptr, i64 6
  store i64 %r36, ptr %r38.f6, align 8
  %r38 = ptrtoint ptr %r38.ptr to i64
  %r39 = load i64, ptr %slot.p, align 8
  %r40.ptr = call ptr @nova_rt_struct_alloc(i64 16)
  %r40.f0 = getelementptr i64, ptr %r40.ptr, i64 0
  store i64 %r38, ptr %r40.f0, align 8
  %r40.f1 = getelementptr i64, ptr %r40.ptr, i64 1
  store i64 %r39, ptr %r40.f1, align 8
  %r40 = ptrtoint ptr %r40.ptr to i64
  ret i64 0
}

define i64 @parse_program(i64 %p0) nounwind {
entry:
  %slot.tokens = alloca i64, align 8
  store i64 %p0, ptr %slot.tokens, align 8
  %slot.stmts = alloca i64, align 8
  store i64 0, ptr %slot.stmts, align 8
  %slot.pos = alloca i64, align 8
  store i64 0, ptr %slot.pos, align 8
  %slot.sr = alloca i64, align 8
  store i64 0, ptr %slot.sr, align 8
  %r0 = call i64 @nova_rt_list_create()
  store i64 %r0, ptr %slot.stmts, align 8
  %r1 = load i64, ptr %slot.tokens, align 8
  %r2 = add i64 0, 0
  %r3 = call i64 @skip_nl(i64 %r1, i64 %r2)
  store i64 %r3, ptr %slot.pos, align 8
  br label %while_hdr495
while_hdr495:
  %r4 = load i64, ptr %slot.tokens, align 8
  %r5 = load i64, ptr %slot.pos, align 8
  %r6 = call i64 @tk(i64 %r4, i64 %r5)
  %r7.p = getelementptr inbounds [4 x i8], ptr @.str.107, i64 0, i64 0
  %r7 = ptrtoint ptr %r7.p to i64
  %r8 = call i64 @nova_rt_neq(i64 %r6, i64 %r7)
  %br_while_body496 = icmp ne i64 %r8, 0
  br i1 %br_while_body496, label %while_body496, label %while_exit497
while_body496:
  %r9 = load i64, ptr %slot.tokens, align 8
  %r10 = load i64, ptr %slot.pos, align 8
  %r11 = call i64 @parse_stmt(i64 %r9, i64 %r10)
  store i64 %r11, ptr %slot.sr, align 8
  %r12 = load i64, ptr %slot.stmts, align 8
  %r13 = add i64 0, 0
  %r14 = call i64 @nova_rt_list_append(i64 %r12, i64 %r13)
  %r15 = load i64, ptr %slot.tokens, align 8
  %r16 = add i64 0, 0
  %r17 = call i64 @skip_nl(i64 %r15, i64 %r16)
  store i64 %r17, ptr %slot.pos, align 8
  br label %while_hdr495
while_exit497:
  %r18 = load i64, ptr %slot.stmts, align 8
  ret i64 0
}

define i64 @new_codegen() nounwind {
entry:
  %r0 = call i64 @nova_rt_list_create()
  %r1 = call i64 @nova_rt_list_create()
  %r2 = call i64 @nova_rt_dict_create()
  %r3 = add i64 0, 0
  %r4 = add i64 0, 0
  %r5 = call i64 @nova_rt_list_create()
  %r6 = call i64 @nova_rt_dict_create()
  %r7.p = getelementptr inbounds [1 x i8], ptr @.str.42, i64 0, i64 0
  %r7 = ptrtoint ptr %r7.p to i64
  %r8 = call i64 @nova_rt_dict_create()
  %r9.p = getelementptr inbounds [3 x i8], ptr @.str.136, i64 0, i64 0
  %r9 = ptrtoint ptr %r9.p to i64
  %r10.p = getelementptr inbounds [1 x i8], ptr @.str.42, i64 0, i64 0
  %r10 = ptrtoint ptr %r10.p to i64
  %r11.p = getelementptr inbounds [1 x i8], ptr @.str.42, i64 0, i64 0
  %r11 = ptrtoint ptr %r11.p to i64
  %r12 = call i64 @nova_rt_dict_create()
  %r13.ptr = call ptr @nova_rt_struct_alloc(i64 104)
  %r13.f0 = getelementptr i64, ptr %r13.ptr, i64 0
  store i64 %r0, ptr %r13.f0, align 8
  %r13.f1 = getelementptr i64, ptr %r13.ptr, i64 1
  store i64 %r1, ptr %r13.f1, align 8
  %r13.f2 = getelementptr i64, ptr %r13.ptr, i64 2
  store i64 %r2, ptr %r13.f2, align 8
  %r13.f3 = getelementptr i64, ptr %r13.ptr, i64 3
  store i64 %r3, ptr %r13.f3, align 8
  %r13.f4 = getelementptr i64, ptr %r13.ptr, i64 4
  store i64 %r4, ptr %r13.f4, align 8
  %r13.f5 = getelementptr i64, ptr %r13.ptr, i64 5
  store i64 %r5, ptr %r13.f5, align 8
  %r13.f6 = getelementptr i64, ptr %r13.ptr, i64 6
  store i64 %r6, ptr %r13.f6, align 8
  %r13.f7 = getelementptr i64, ptr %r13.ptr, i64 7
  store i64 %r7, ptr %r13.f7, align 8
  %r13.f8 = getelementptr i64, ptr %r13.ptr, i64 8
  store i64 %r8, ptr %r13.f8, align 8
  %r13.f9 = getelementptr i64, ptr %r13.ptr, i64 9
  store i64 %r9, ptr %r13.f9, align 8
  %r13.f10 = getelementptr i64, ptr %r13.ptr, i64 10
  store i64 %r10, ptr %r13.f10, align 8
  %r13.f11 = getelementptr i64, ptr %r13.ptr, i64 11
  store i64 %r11, ptr %r13.f11, align 8
  %r13.f12 = getelementptr i64, ptr %r13.ptr, i64 12
  store i64 %r12, ptr %r13.f12, align 8
  %r13 = ptrtoint ptr %r13.ptr to i64
  ret i64 0
}

define i64 @fresh_reg(i64 %p0) nounwind {
entry:
  %slot.cg = alloca i64, align 8
  store i64 %p0, ptr %slot.cg, align 8
  %slot.r = alloca i64, align 8
  store i64 0, ptr %slot.r, align 8
  %r0.p = getelementptr inbounds [3 x i8], ptr @.str.137, i64 0, i64 0
  %r0 = ptrtoint ptr %r0.p to i64
  %r1 = add i64 0, 0
  %r2 = call i64 @nova_rt_int_to_str(i64 %r1)
  %r3 = call i64 @nova_rt_str_concat(i64 %r0, i64 %r2)
  store i64 %r3, ptr %slot.r, align 8
  %r4 = add i64 0, 0
  %r5 = add i64 1, 0
  %r6 = add i64 %r4, %r5
  %r7 = load i64, ptr %slot.cg, align 8
  %r8.ptr = inttoptr i64 %r7 to ptr
  %r8.gep = getelementptr i64, ptr %r8.ptr, i64 3
  store i64 %r6, ptr %r8.gep, align 8
  %r9 = load i64, ptr %slot.r, align 8
  ret i64 0
}

define i64 @fresh_tmp(i64 %p0) nounwind {
entry:
  %slot.cg = alloca i64, align 8
  store i64 %p0, ptr %slot.cg, align 8
  %slot.t = alloca i64, align 8
  store i64 0, ptr %slot.t, align 8
  %r0.p = getelementptr inbounds [3 x i8], ptr @.str.138, i64 0, i64 0
  %r0 = ptrtoint ptr %r0.p to i64
  %r1 = add i64 0, 0
  %r2 = call i64 @nova_rt_int_to_str(i64 %r1)
  %r3 = call i64 @nova_rt_str_concat(i64 %r0, i64 %r2)
  store i64 %r3, ptr %slot.t, align 8
  %r4 = add i64 0, 0
  %r5 = add i64 1, 0
  %r6 = add i64 %r4, %r5
  %r7 = load i64, ptr %slot.cg, align 8
  %r8.ptr = inttoptr i64 %r7 to ptr
  %r8.gep = getelementptr i64, ptr %r8.ptr, i64 3
  store i64 %r6, ptr %r8.gep, align 8
  %r9 = load i64, ptr %slot.t, align 8
  ret i64 0
}

define i64 @fresh_label(i64 %p0, i64 %p1) nounwind {
entry:
  %slot.cg = alloca i64, align 8
  store i64 %p0, ptr %slot.cg, align 8
  %slot.prefix = alloca i64, align 8
  store i64 %p1, ptr %slot.prefix, align 8
  %slot.l = alloca i64, align 8
  store i64 0, ptr %slot.l, align 8
  %r0 = load i64, ptr %slot.prefix, align 8
  %r1 = add i64 0, 0
  %r2 = call i64 @nova_rt_int_to_str(i64 %r1)
  %r3 = call i64 @nova_rt_str_concat(i64 %r0, i64 %r2)
  store i64 %r3, ptr %slot.l, align 8
  %r4 = add i64 0, 0
  %r5 = add i64 1, 0
  %r6 = add i64 %r4, %r5
  %r7 = load i64, ptr %slot.cg, align 8
  %r8.ptr = inttoptr i64 %r7 to ptr
  %r8.gep = getelementptr i64, ptr %r8.ptr, i64 4
  store i64 %r6, ptr %r8.gep, align 8
  %r9 = load i64, ptr %slot.l, align 8
  ret i64 0
}

define i64 @intern_string(i64 %p0, i64 %p1) nounwind {
entry:
  %slot.cg = alloca i64, align 8
  store i64 %p0, ptr %slot.cg, align 8
  %slot.s = alloca i64, align 8
  store i64 %p1, ptr %slot.s, align 8
  %slot.idx = alloca i64, align 8
  store i64 0, ptr %slot.idx, align 8
  %r0 = add i64 0, 0
  %r1 = load i64, ptr %slot.s, align 8
  %r2 = call i64 @nova_rt_contains(i64 %r0, i64 %r1)
  %br_then498 = icmp ne i64 %r2, 0
  br i1 %br_then498, label %then498, label %else499
then498:
  %r3 = add i64 0, 0
  %r4 = load i64, ptr %slot.s, align 8
  %r5 = call i64 @nova_rt_index_get(i64 %r3, i64 %r4)
  ret i64 %r5
else499:
  br label %endif500
endif500:
  %r6 = add i64 0, 0
  %r7 = call i64 @nova_rt_len_any(i64 %r6)
  store i64 %r7, ptr %slot.idx, align 8
  %r8 = add i64 0, 0
  %r9 = load i64, ptr %slot.s, align 8
  %r10 = call i64 @nova_rt_list_append(i64 %r8, i64 %r9)
  %r11 = load i64, ptr %slot.idx, align 8
  %r12 = add i64 0, 0
  %r13 = load i64, ptr %slot.s, align 8
  call i64 @nova_rt_index_set(i64 %r12, i64 %r13, i64 %r11)
  %r14 = load i64, ptr %slot.idx, align 8
  ret i64 0
}

define i64 @emit(i64 %p0, i64 %p1) nounwind {
entry:
  %slot.cg = alloca i64, align 8
  store i64 %p0, ptr %slot.cg, align 8
  %slot.line = alloca i64, align 8
  store i64 %p1, ptr %slot.line, align 8
  %r0 = add i64 0, 0
  %r1 = load i64, ptr %slot.line, align 8
  %r2 = call i64 @nova_rt_list_append(i64 %r0, i64 %r1)
  ret i64 0
}

define i64 @emit_indent(i64 %p0, i64 %p1) nounwind {
entry:
  %slot.cg = alloca i64, align 8
  store i64 %p0, ptr %slot.cg, align 8
  %slot.line = alloca i64, align 8
  store i64 %p1, ptr %slot.line, align 8
  %r0 = add i64 0, 0
  %r1 = add i64 0, 0
  %r2 = load i64, ptr %slot.line, align 8
  %r3 = call i64 @nova_rt_add(i64 %r1, i64 %r2)
  %r4 = call i64 @nova_rt_list_append(i64 %r0, i64 %r3)
  ret i64 0
}

define i64 @get_slot(i64 %p0, i64 %p1) nounwind {
entry:
  %slot.cg = alloca i64, align 8
  store i64 %p0, ptr %slot.cg, align 8
  %slot.name = alloca i64, align 8
  store i64 %p1, ptr %slot.name, align 8
  %slot.slots = alloca i64, align 8
  store i64 0, ptr %slot.slots, align 8
  %slot.slot = alloca i64, align 8
  store i64 0, ptr %slot.slot, align 8
  %r0 = add i64 0, 0
  store i64 %r0, ptr %slot.slots, align 8
  %r1 = load i64, ptr %slot.slots, align 8
  %r2 = load i64, ptr %slot.name, align 8
  %r3 = call i64 @nova_rt_contains(i64 %r1, i64 %r2)
  %br_then501 = icmp ne i64 %r3, 0
  br i1 %br_then501, label %then501, label %else502
then501:
  %r4 = load i64, ptr %slot.slots, align 8
  %r5 = load i64, ptr %slot.name, align 8
  %r6 = call i64 @nova_rt_index_get(i64 %r4, i64 %r5)
  ret i64 %r6
else502:
  br label %endif503
endif503:
  %r7.p = getelementptr inbounds [7 x i8], ptr @.str.139, i64 0, i64 0
  %r7 = ptrtoint ptr %r7.p to i64
  %r8 = load i64, ptr %slot.name, align 8
  %r9 = call i64 @nova_rt_str_concat(i64 %r7, i64 %r8)
  store i64 %r9, ptr %slot.slot, align 8
  %r10 = load i64, ptr %slot.slot, align 8
  %r11 = load i64, ptr %slot.slots, align 8
  %r12 = load i64, ptr %slot.name, align 8
  call i64 @nova_rt_index_set(i64 %r11, i64 %r12, i64 %r10)
  %r13 = load i64, ptr %slot.slot, align 8
  ret i64 0
}

define i64 @codegen_expr(i64 %p0, i64 %p1) nounwind {
entry:
  %slot.cg = alloca i64, align 8
  store i64 %p0, ptr %slot.cg, align 8
  %slot.expr = alloca i64, align 8
  store i64 %p1, ptr %slot.expr, align 8
  ret i64 0
}

define i64 @codegen_binop(i64 %p0, i64 %p1, i64 %p2, i64 %p3) nounwind {
entry:
  %slot.cg = alloca i64, align 8
  store i64 %p0, ptr %slot.cg, align 8
  %slot.op = alloca i64, align 8
  store i64 %p1, ptr %slot.op, align 8
  %slot.left = alloca i64, align 8
  store i64 %p2, ptr %slot.left, align 8
  %slot.right = alloca i64, align 8
  store i64 %p3, ptr %slot.right, align 8
  %slot.l = alloca i64, align 8
  store i64 0, ptr %slot.l, align 8
  %slot.r_val = alloca i64, align 8
  store i64 0, ptr %slot.r_val, align 8
  %slot.result = alloca i64, align 8
  store i64 0, ptr %slot.result, align 8
  %slot.cmp = alloca i64, align 8
  store i64 0, ptr %slot.cmp, align 8
  %slot.lbl_entry = alloca i64, align 8
  store i64 0, ptr %slot.lbl_entry, align 8
  %slot.lbl_rhs = alloca i64, align 8
  store i64 0, ptr %slot.lbl_rhs, align 8
  %slot.lbl_end = alloca i64, align 8
  store i64 0, ptr %slot.lbl_end, align 8
  %slot.r2 = alloca i64, align 8
  store i64 0, ptr %slot.r2, align 8
  %slot.lbl_rhs_done = alloca i64, align 8
  store i64 0, ptr %slot.lbl_rhs_done, align 8
  %slot.llvm_op = alloca i64, align 8
  store i64 0, ptr %slot.llvm_op, align 8
  %r0 = load i64, ptr %slot.cg, align 8
  %r1 = load i64, ptr %slot.left, align 8
  %r2 = call i64 @codegen_expr(i64 %r0, i64 %r1)
  store i64 %r2, ptr %slot.l, align 8
  %r3 = load i64, ptr %slot.cg, align 8
  %r4 = load i64, ptr %slot.right, align 8
  %r5 = call i64 @codegen_expr(i64 %r3, i64 %r4)
  store i64 %r5, ptr %slot.r_val, align 8
  %r6 = load i64, ptr %slot.cg, align 8
  %r7 = call i64 @fresh_reg(i64 %r6)
  store i64 %r7, ptr %slot.result, align 8
  %r8 = load i64, ptr %slot.op, align 8
  %r9.p = getelementptr inbounds [2 x i8], ptr @.str.73, i64 0, i64 0
  %r9 = ptrtoint ptr %r9.p to i64
  %r10 = call i64 @nova_rt_eq(i64 %r8, i64 %r9)
  %br_then504 = icmp ne i64 %r10, 0
  br i1 %br_then504, label %then504, label %else505
then504:
  %r11 = load i64, ptr %slot.cg, align 8
  %r12 = load i64, ptr %slot.result, align 8
  %r13.p = getelementptr inbounds [30 x i8], ptr @.str.140, i64 0, i64 0
  %r13 = ptrtoint ptr %r13.p to i64
  %r14 = call i64 @nova_rt_str_concat(i64 %r12, i64 %r13)
  %r15 = load i64, ptr %slot.l, align 8
  %r16 = call i64 @nova_rt_str_concat(i64 %r14, i64 %r15)
  %r17.p = getelementptr inbounds [7 x i8], ptr @.str.141, i64 0, i64 0
  %r17 = ptrtoint ptr %r17.p to i64
  %r18 = call i64 @nova_rt_str_concat(i64 %r16, i64 %r17)
  %r19 = load i64, ptr %slot.r_val, align 8
  %r20 = call i64 @nova_rt_str_concat(i64 %r18, i64 %r19)
  %r21.p = getelementptr inbounds [2 x i8], ptr @.str.60, i64 0, i64 0
  %r21 = ptrtoint ptr %r21.p to i64
  %r22 = call i64 @nova_rt_str_concat(i64 %r20, i64 %r21)
  %r23 = call i64 @emit_indent(i64 %r11, i64 %r22)
  br label %endif506
else505:
  %r24 = load i64, ptr %slot.op, align 8
  %r25.p = getelementptr inbounds [2 x i8], ptr @.str.77, i64 0, i64 0
  %r25 = ptrtoint ptr %r25.p to i64
  %r26 = call i64 @nova_rt_eq(i64 %r24, i64 %r25)
  %br_then507 = icmp ne i64 %r26, 0
  br i1 %br_then507, label %then507, label %else508
then507:
  %r27 = load i64, ptr %slot.cg, align 8
  %r28 = load i64, ptr %slot.result, align 8
  %r29.p = getelementptr inbounds [12 x i8], ptr @.str.142, i64 0, i64 0
  %r29 = ptrtoint ptr %r29.p to i64
  %r30 = call i64 @nova_rt_str_concat(i64 %r28, i64 %r29)
  %r31 = load i64, ptr %slot.l, align 8
  %r32 = call i64 @nova_rt_str_concat(i64 %r30, i64 %r31)
  %r33.p = getelementptr inbounds [3 x i8], ptr @.str.143, i64 0, i64 0
  %r33 = ptrtoint ptr %r33.p to i64
  %r34 = call i64 @nova_rt_str_concat(i64 %r32, i64 %r33)
  %r35 = load i64, ptr %slot.r_val, align 8
  %r36 = call i64 @nova_rt_str_concat(i64 %r34, i64 %r35)
  %r37 = call i64 @emit_indent(i64 %r27, i64 %r36)
  br label %endif509
else508:
  %r38 = load i64, ptr %slot.op, align 8
  %r39.p = getelementptr inbounds [2 x i8], ptr @.str.82, i64 0, i64 0
  %r39 = ptrtoint ptr %r39.p to i64
  %r40 = call i64 @nova_rt_eq(i64 %r38, i64 %r39)
  %br_then510 = icmp ne i64 %r40, 0
  br i1 %br_then510, label %then510, label %else511
then510:
  %r41 = load i64, ptr %slot.cg, align 8
  %r42 = load i64, ptr %slot.result, align 8
  %r43.p = getelementptr inbounds [12 x i8], ptr @.str.144, i64 0, i64 0
  %r43 = ptrtoint ptr %r43.p to i64
  %r44 = call i64 @nova_rt_str_concat(i64 %r42, i64 %r43)
  %r45 = load i64, ptr %slot.l, align 8
  %r46 = call i64 @nova_rt_str_concat(i64 %r44, i64 %r45)
  %r47.p = getelementptr inbounds [3 x i8], ptr @.str.143, i64 0, i64 0
  %r47 = ptrtoint ptr %r47.p to i64
  %r48 = call i64 @nova_rt_str_concat(i64 %r46, i64 %r47)
  %r49 = load i64, ptr %slot.r_val, align 8
  %r50 = call i64 @nova_rt_str_concat(i64 %r48, i64 %r49)
  %r51 = call i64 @emit_indent(i64 %r41, i64 %r50)
  br label %endif512
else511:
  %r52 = load i64, ptr %slot.op, align 8
  %r53.p = getelementptr inbounds [2 x i8], ptr @.str.39, i64 0, i64 0
  %r53 = ptrtoint ptr %r53.p to i64
  %r54 = call i64 @nova_rt_eq(i64 %r52, i64 %r53)
  %br_then513 = icmp ne i64 %r54, 0
  br i1 %br_then513, label %then513, label %else514
then513:
  %r55 = load i64, ptr %slot.cg, align 8
  %r56 = load i64, ptr %slot.result, align 8
  %r57.p = getelementptr inbounds [13 x i8], ptr @.str.145, i64 0, i64 0
  %r57 = ptrtoint ptr %r57.p to i64
  %r58 = call i64 @nova_rt_str_concat(i64 %r56, i64 %r57)
  %r59 = load i64, ptr %slot.l, align 8
  %r60 = call i64 @nova_rt_str_concat(i64 %r58, i64 %r59)
  %r61.p = getelementptr inbounds [3 x i8], ptr @.str.143, i64 0, i64 0
  %r61 = ptrtoint ptr %r61.p to i64
  %r62 = call i64 @nova_rt_str_concat(i64 %r60, i64 %r61)
  %r63 = load i64, ptr %slot.r_val, align 8
  %r64 = call i64 @nova_rt_str_concat(i64 %r62, i64 %r63)
  %r65 = call i64 @emit_indent(i64 %r55, i64 %r64)
  br label %endif515
else514:
  %r66 = load i64, ptr %slot.op, align 8
  %r67.p = getelementptr inbounds [2 x i8], ptr @.str.86, i64 0, i64 0
  %r67 = ptrtoint ptr %r67.p to i64
  %r68 = call i64 @nova_rt_eq(i64 %r66, i64 %r67)
  %br_then516 = icmp ne i64 %r68, 0
  br i1 %br_then516, label %then516, label %else517
then516:
  %r69 = load i64, ptr %slot.cg, align 8
  %r70 = load i64, ptr %slot.result, align 8
  %r71.p = getelementptr inbounds [13 x i8], ptr @.str.146, i64 0, i64 0
  %r71 = ptrtoint ptr %r71.p to i64
  %r72 = call i64 @nova_rt_str_concat(i64 %r70, i64 %r71)
  %r73 = load i64, ptr %slot.l, align 8
  %r74 = call i64 @nova_rt_str_concat(i64 %r72, i64 %r73)
  %r75.p = getelementptr inbounds [3 x i8], ptr @.str.143, i64 0, i64 0
  %r75 = ptrtoint ptr %r75.p to i64
  %r76 = call i64 @nova_rt_str_concat(i64 %r74, i64 %r75)
  %r77 = load i64, ptr %slot.r_val, align 8
  %r78 = call i64 @nova_rt_str_concat(i64 %r76, i64 %r77)
  %r79 = call i64 @emit_indent(i64 %r69, i64 %r78)
  br label %endif518
else517:
  %r80 = load i64, ptr %slot.op, align 8
  %r81.p = getelementptr inbounds [3 x i8], ptr @.str.88, i64 0, i64 0
  %r81 = ptrtoint ptr %r81.p to i64
  %r82 = call i64 @nova_rt_eq(i64 %r80, i64 %r81)
  %br_then519 = icmp ne i64 %r82, 0
  br i1 %br_then519, label %then519, label %else520
then519:
  %r83 = load i64, ptr %slot.cg, align 8
  %r84 = call i64 @fresh_tmp(i64 %r83)
  store i64 %r84, ptr %slot.cmp, align 8
  %r85 = load i64, ptr %slot.cg, align 8
  %r86 = load i64, ptr %slot.cmp, align 8
  %r87.p = getelementptr inbounds [29 x i8], ptr @.str.147, i64 0, i64 0
  %r87 = ptrtoint ptr %r87.p to i64
  %r88 = call i64 @nova_rt_str_concat(i64 %r86, i64 %r87)
  %r89 = load i64, ptr %slot.l, align 8
  %r90 = call i64 @nova_rt_str_concat(i64 %r88, i64 %r89)
  %r91.p = getelementptr inbounds [7 x i8], ptr @.str.141, i64 0, i64 0
  %r91 = ptrtoint ptr %r91.p to i64
  %r92 = call i64 @nova_rt_str_concat(i64 %r90, i64 %r91)
  %r93 = load i64, ptr %slot.r_val, align 8
  %r94 = call i64 @nova_rt_str_concat(i64 %r92, i64 %r93)
  %r95.p = getelementptr inbounds [2 x i8], ptr @.str.60, i64 0, i64 0
  %r95 = ptrtoint ptr %r95.p to i64
  %r96 = call i64 @nova_rt_str_concat(i64 %r94, i64 %r95)
  %r97 = call i64 @emit_indent(i64 %r85, i64 %r96)
  %r98 = load i64, ptr %slot.cg, align 8
  %r99 = load i64, ptr %slot.result, align 8
  %r100.p = getelementptr inbounds [12 x i8], ptr @.str.148, i64 0, i64 0
  %r100 = ptrtoint ptr %r100.p to i64
  %r101 = call i64 @nova_rt_str_concat(i64 %r99, i64 %r100)
  %r102 = load i64, ptr %slot.cmp, align 8
  %r103 = call i64 @nova_rt_str_concat(i64 %r101, i64 %r102)
  %r104.p = getelementptr inbounds [4 x i8], ptr @.str.149, i64 0, i64 0
  %r104 = ptrtoint ptr %r104.p to i64
  %r105 = call i64 @nova_rt_str_concat(i64 %r103, i64 %r104)
  %r106 = call i64 @emit_indent(i64 %r98, i64 %r105)
  %r107 = load i64, ptr %slot.cmp, align 8
  ret i64 %r107
else520:
  %r108 = load i64, ptr %slot.op, align 8
  %r109.p = getelementptr inbounds [3 x i8], ptr @.str.93, i64 0, i64 0
  %r109 = ptrtoint ptr %r109.p to i64
  %r110 = call i64 @nova_rt_eq(i64 %r108, i64 %r109)
  %br_then522 = icmp ne i64 %r110, 0
  br i1 %br_then522, label %then522, label %else523
then522:
  %r111 = load i64, ptr %slot.cg, align 8
  %r112 = call i64 @fresh_tmp(i64 %r111)
  store i64 %r112, ptr %slot.cmp, align 8
  %r113 = load i64, ptr %slot.cg, align 8
  %r114 = load i64, ptr %slot.cmp, align 8
  %r115.p = getelementptr inbounds [30 x i8], ptr @.str.150, i64 0, i64 0
  %r115 = ptrtoint ptr %r115.p to i64
  %r116 = call i64 @nova_rt_str_concat(i64 %r114, i64 %r115)
  %r117 = load i64, ptr %slot.l, align 8
  %r118 = call i64 @nova_rt_str_concat(i64 %r116, i64 %r117)
  %r119.p = getelementptr inbounds [7 x i8], ptr @.str.141, i64 0, i64 0
  %r119 = ptrtoint ptr %r119.p to i64
  %r120 = call i64 @nova_rt_str_concat(i64 %r118, i64 %r119)
  %r121 = load i64, ptr %slot.r_val, align 8
  %r122 = call i64 @nova_rt_str_concat(i64 %r120, i64 %r121)
  %r123.p = getelementptr inbounds [2 x i8], ptr @.str.60, i64 0, i64 0
  %r123 = ptrtoint ptr %r123.p to i64
  %r124 = call i64 @nova_rt_str_concat(i64 %r122, i64 %r123)
  %r125 = call i64 @emit_indent(i64 %r113, i64 %r124)
  %r126 = load i64, ptr %slot.cmp, align 8
  ret i64 %r126
else523:
  %r127 = load i64, ptr %slot.op, align 8
  %r128.p = getelementptr inbounds [2 x i8], ptr @.str.94, i64 0, i64 0
  %r128 = ptrtoint ptr %r128.p to i64
  %r129 = call i64 @nova_rt_eq(i64 %r127, i64 %r128)
  %br_then525 = icmp ne i64 %r129, 0
  br i1 %br_then525, label %then525, label %else526
then525:
  %r130 = load i64, ptr %slot.cg, align 8
  %r131 = call i64 @fresh_tmp(i64 %r130)
  store i64 %r131, ptr %slot.cmp, align 8
  %r132 = load i64, ptr %slot.cg, align 8
  %r133 = load i64, ptr %slot.cmp, align 8
  %r134.p = getelementptr inbounds [17 x i8], ptr @.str.151, i64 0, i64 0
  %r134 = ptrtoint ptr %r134.p to i64
  %r135 = call i64 @nova_rt_str_concat(i64 %r133, i64 %r134)
  %r136 = load i64, ptr %slot.l, align 8
  %r137 = call i64 @nova_rt_str_concat(i64 %r135, i64 %r136)
  %r138.p = getelementptr inbounds [3 x i8], ptr @.str.143, i64 0, i64 0
  %r138 = ptrtoint ptr %r138.p to i64
  %r139 = call i64 @nova_rt_str_concat(i64 %r137, i64 %r138)
  %r140 = load i64, ptr %slot.r_val, align 8
  %r141 = call i64 @nova_rt_str_concat(i64 %r139, i64 %r140)
  %r142 = call i64 @emit_indent(i64 %r132, i64 %r141)
  %r143 = load i64, ptr %slot.cg, align 8
  %r144 = load i64, ptr %slot.result, align 8
  %r145.p = getelementptr inbounds [12 x i8], ptr @.str.152, i64 0, i64 0
  %r145 = ptrtoint ptr %r145.p to i64
  %r146 = call i64 @nova_rt_str_concat(i64 %r144, i64 %r145)
  %r147 = load i64, ptr %slot.cmp, align 8
  %r148 = call i64 @nova_rt_str_concat(i64 %r146, i64 %r147)
  %r149.p = getelementptr inbounds [8 x i8], ptr @.str.153, i64 0, i64 0
  %r149 = ptrtoint ptr %r149.p to i64
  %r150 = call i64 @nova_rt_str_concat(i64 %r148, i64 %r149)
  %r151 = call i64 @emit_indent(i64 %r143, i64 %r150)
  br label %endif527
else526:
  %r152 = load i64, ptr %slot.op, align 8
  %r153.p = getelementptr inbounds [2 x i8], ptr @.str.78, i64 0, i64 0
  %r153 = ptrtoint ptr %r153.p to i64
  %r154 = call i64 @nova_rt_eq(i64 %r152, i64 %r153)
  %br_then528 = icmp ne i64 %r154, 0
  br i1 %br_then528, label %then528, label %else529
then528:
  %r155 = load i64, ptr %slot.cg, align 8
  %r156 = call i64 @fresh_tmp(i64 %r155)
  store i64 %r156, ptr %slot.cmp, align 8
  %r157 = load i64, ptr %slot.cg, align 8
  %r158 = load i64, ptr %slot.cmp, align 8
  %r159.p = getelementptr inbounds [17 x i8], ptr @.str.154, i64 0, i64 0
  %r159 = ptrtoint ptr %r159.p to i64
  %r160 = call i64 @nova_rt_str_concat(i64 %r158, i64 %r159)
  %r161 = load i64, ptr %slot.l, align 8
  %r162 = call i64 @nova_rt_str_concat(i64 %r160, i64 %r161)
  %r163.p = getelementptr inbounds [3 x i8], ptr @.str.143, i64 0, i64 0
  %r163 = ptrtoint ptr %r163.p to i64
  %r164 = call i64 @nova_rt_str_concat(i64 %r162, i64 %r163)
  %r165 = load i64, ptr %slot.r_val, align 8
  %r166 = call i64 @nova_rt_str_concat(i64 %r164, i64 %r165)
  %r167 = call i64 @emit_indent(i64 %r157, i64 %r166)
  %r168 = load i64, ptr %slot.cg, align 8
  %r169 = load i64, ptr %slot.result, align 8
  %r170.p = getelementptr inbounds [12 x i8], ptr @.str.152, i64 0, i64 0
  %r170 = ptrtoint ptr %r170.p to i64
  %r171 = call i64 @nova_rt_str_concat(i64 %r169, i64 %r170)
  %r172 = load i64, ptr %slot.cmp, align 8
  %r173 = call i64 @nova_rt_str_concat(i64 %r171, i64 %r172)
  %r174.p = getelementptr inbounds [8 x i8], ptr @.str.153, i64 0, i64 0
  %r174 = ptrtoint ptr %r174.p to i64
  %r175 = call i64 @nova_rt_str_concat(i64 %r173, i64 %r174)
  %r176 = call i64 @emit_indent(i64 %r168, i64 %r175)
  br label %endif530
else529:
  %r177 = load i64, ptr %slot.op, align 8
  %r178.p = getelementptr inbounds [3 x i8], ptr @.str.95, i64 0, i64 0
  %r178 = ptrtoint ptr %r178.p to i64
  %r179 = call i64 @nova_rt_eq(i64 %r177, i64 %r178)
  %br_then531 = icmp ne i64 %r179, 0
  br i1 %br_then531, label %then531, label %else532
then531:
  %r180 = load i64, ptr %slot.cg, align 8
  %r181 = call i64 @fresh_tmp(i64 %r180)
  store i64 %r181, ptr %slot.cmp, align 8
  %r182 = load i64, ptr %slot.cg, align 8
  %r183 = load i64, ptr %slot.cmp, align 8
  %r184.p = getelementptr inbounds [17 x i8], ptr @.str.155, i64 0, i64 0
  %r184 = ptrtoint ptr %r184.p to i64
  %r185 = call i64 @nova_rt_str_concat(i64 %r183, i64 %r184)
  %r186 = load i64, ptr %slot.l, align 8
  %r187 = call i64 @nova_rt_str_concat(i64 %r185, i64 %r186)
  %r188.p = getelementptr inbounds [3 x i8], ptr @.str.143, i64 0, i64 0
  %r188 = ptrtoint ptr %r188.p to i64
  %r189 = call i64 @nova_rt_str_concat(i64 %r187, i64 %r188)
  %r190 = load i64, ptr %slot.r_val, align 8
  %r191 = call i64 @nova_rt_str_concat(i64 %r189, i64 %r190)
  %r192 = call i64 @emit_indent(i64 %r182, i64 %r191)
  %r193 = load i64, ptr %slot.cg, align 8
  %r194 = load i64, ptr %slot.result, align 8
  %r195.p = getelementptr inbounds [12 x i8], ptr @.str.152, i64 0, i64 0
  %r195 = ptrtoint ptr %r195.p to i64
  %r196 = call i64 @nova_rt_str_concat(i64 %r194, i64 %r195)
  %r197 = load i64, ptr %slot.cmp, align 8
  %r198 = call i64 @nova_rt_str_concat(i64 %r196, i64 %r197)
  %r199.p = getelementptr inbounds [8 x i8], ptr @.str.153, i64 0, i64 0
  %r199 = ptrtoint ptr %r199.p to i64
  %r200 = call i64 @nova_rt_str_concat(i64 %r198, i64 %r199)
  %r201 = call i64 @emit_indent(i64 %r193, i64 %r200)
  br label %endif533
else532:
  %r202 = load i64, ptr %slot.op, align 8
  %r203.p = getelementptr inbounds [3 x i8], ptr @.str.97, i64 0, i64 0
  %r203 = ptrtoint ptr %r203.p to i64
  %r204 = call i64 @nova_rt_eq(i64 %r202, i64 %r203)
  %br_then534 = icmp ne i64 %r204, 0
  br i1 %br_then534, label %then534, label %else535
then534:
  %r205 = load i64, ptr %slot.cg, align 8
  %r206 = call i64 @fresh_tmp(i64 %r205)
  store i64 %r206, ptr %slot.cmp, align 8
  %r207 = load i64, ptr %slot.cg, align 8
  %r208 = load i64, ptr %slot.cmp, align 8
  %r209.p = getelementptr inbounds [17 x i8], ptr @.str.156, i64 0, i64 0
  %r209 = ptrtoint ptr %r209.p to i64
  %r210 = call i64 @nova_rt_str_concat(i64 %r208, i64 %r209)
  %r211 = load i64, ptr %slot.l, align 8
  %r212 = call i64 @nova_rt_str_concat(i64 %r210, i64 %r211)
  %r213.p = getelementptr inbounds [3 x i8], ptr @.str.143, i64 0, i64 0
  %r213 = ptrtoint ptr %r213.p to i64
  %r214 = call i64 @nova_rt_str_concat(i64 %r212, i64 %r213)
  %r215 = load i64, ptr %slot.r_val, align 8
  %r216 = call i64 @nova_rt_str_concat(i64 %r214, i64 %r215)
  %r217 = call i64 @emit_indent(i64 %r207, i64 %r216)
  %r218 = load i64, ptr %slot.cg, align 8
  %r219 = load i64, ptr %slot.result, align 8
  %r220.p = getelementptr inbounds [12 x i8], ptr @.str.152, i64 0, i64 0
  %r220 = ptrtoint ptr %r220.p to i64
  %r221 = call i64 @nova_rt_str_concat(i64 %r219, i64 %r220)
  %r222 = load i64, ptr %slot.cmp, align 8
  %r223 = call i64 @nova_rt_str_concat(i64 %r221, i64 %r222)
  %r224.p = getelementptr inbounds [8 x i8], ptr @.str.153, i64 0, i64 0
  %r224 = ptrtoint ptr %r224.p to i64
  %r225 = call i64 @nova_rt_str_concat(i64 %r223, i64 %r224)
  %r226 = call i64 @emit_indent(i64 %r218, i64 %r225)
  br label %endif536
else535:
  %r227 = load i64, ptr %slot.op, align 8
  %r228.p = getelementptr inbounds [4 x i8], ptr @.str.20, i64 0, i64 0
  %r228 = ptrtoint ptr %r228.p to i64
  %r229 = call i64 @nova_rt_eq(i64 %r227, i64 %r228)
  %br_then537 = icmp ne i64 %r229, 0
  br i1 %br_then537, label %then537, label %else538
then537:
  %r230 = load i64, ptr %slot.cg, align 8
  %r231.p = getelementptr inbounds [10 x i8], ptr @.str.157, i64 0, i64 0
  %r231 = ptrtoint ptr %r231.p to i64
  %r232 = call i64 @fresh_label(i64 %r230, i64 %r231)
  store i64 %r232, ptr %slot.lbl_entry, align 8
  %r233 = load i64, ptr %slot.cg, align 8
  %r234.p = getelementptr inbounds [11 x i8], ptr @.str.158, i64 0, i64 0
  %r234 = ptrtoint ptr %r234.p to i64
  %r235 = load i64, ptr %slot.lbl_entry, align 8
  %r236 = call i64 @nova_rt_str_concat(i64 %r234, i64 %r235)
  %r237 = call i64 @emit_indent(i64 %r233, i64 %r236)
  %r238 = load i64, ptr %slot.cg, align 8
  %r239 = load i64, ptr %slot.lbl_entry, align 8
  %r240.p = getelementptr inbounds [2 x i8], ptr @.str.68, i64 0, i64 0
  %r240 = ptrtoint ptr %r240.p to i64
  %r241 = call i64 @nova_rt_str_concat(i64 %r239, i64 %r240)
  %r242 = call i64 @emit(i64 %r238, i64 %r241)
  %r243 = load i64, ptr %slot.cg, align 8
  %r244 = call i64 @fresh_tmp(i64 %r243)
  store i64 %r244, ptr %slot.cmp, align 8
  %r245 = load i64, ptr %slot.cg, align 8
  %r246 = load i64, ptr %slot.cmp, align 8
  %r247.p = getelementptr inbounds [16 x i8], ptr @.str.159, i64 0, i64 0
  %r247 = ptrtoint ptr %r247.p to i64
  %r248 = call i64 @nova_rt_str_concat(i64 %r246, i64 %r247)
  %r249 = load i64, ptr %slot.l, align 8
  %r250 = call i64 @nova_rt_str_concat(i64 %r248, i64 %r249)
  %r251.p = getelementptr inbounds [4 x i8], ptr @.str.160, i64 0, i64 0
  %r251 = ptrtoint ptr %r251.p to i64
  %r252 = call i64 @nova_rt_str_concat(i64 %r250, i64 %r251)
  %r253 = call i64 @emit_indent(i64 %r245, i64 %r252)
  %r254 = load i64, ptr %slot.cg, align 8
  %r255.p = getelementptr inbounds [8 x i8], ptr @.str.161, i64 0, i64 0
  %r255 = ptrtoint ptr %r255.p to i64
  %r256 = call i64 @fresh_label(i64 %r254, i64 %r255)
  store i64 %r256, ptr %slot.lbl_rhs, align 8
  %r257 = load i64, ptr %slot.cg, align 8
  %r258.p = getelementptr inbounds [8 x i8], ptr @.str.162, i64 0, i64 0
  %r258 = ptrtoint ptr %r258.p to i64
  %r259 = call i64 @fresh_label(i64 %r257, i64 %r258)
  store i64 %r259, ptr %slot.lbl_end, align 8
  %r260 = load i64, ptr %slot.cg, align 8
  %r261.p = getelementptr inbounds [7 x i8], ptr @.str.163, i64 0, i64 0
  %r261 = ptrtoint ptr %r261.p to i64
  %r262 = load i64, ptr %slot.cmp, align 8
  %r263 = call i64 @nova_rt_str_concat(i64 %r261, i64 %r262)
  %r264.p = getelementptr inbounds [10 x i8], ptr @.str.164, i64 0, i64 0
  %r264 = ptrtoint ptr %r264.p to i64
  %r265 = call i64 @nova_rt_str_concat(i64 %r263, i64 %r264)
  %r266 = load i64, ptr %slot.lbl_rhs, align 8
  %r267 = call i64 @nova_rt_str_concat(i64 %r265, i64 %r266)
  %r268.p = getelementptr inbounds [10 x i8], ptr @.str.164, i64 0, i64 0
  %r268 = ptrtoint ptr %r268.p to i64
  %r269 = call i64 @nova_rt_str_concat(i64 %r267, i64 %r268)
  %r270 = load i64, ptr %slot.lbl_end, align 8
  %r271 = call i64 @nova_rt_str_concat(i64 %r269, i64 %r270)
  %r272 = call i64 @emit_indent(i64 %r260, i64 %r271)
  %r273 = load i64, ptr %slot.cg, align 8
  %r274 = load i64, ptr %slot.lbl_rhs, align 8
  %r275.p = getelementptr inbounds [2 x i8], ptr @.str.68, i64 0, i64 0
  %r275 = ptrtoint ptr %r275.p to i64
  %r276 = call i64 @nova_rt_str_concat(i64 %r274, i64 %r275)
  %r277 = call i64 @emit(i64 %r273, i64 %r276)
  %r278 = load i64, ptr %slot.cg, align 8
  %r279 = load i64, ptr %slot.right, align 8
  %r280 = call i64 @codegen_expr(i64 %r278, i64 %r279)
  store i64 %r280, ptr %slot.r2, align 8
  %r281 = load i64, ptr %slot.cg, align 8
  %r282.p = getelementptr inbounds [9 x i8], ptr @.str.165, i64 0, i64 0
  %r282 = ptrtoint ptr %r282.p to i64
  %r283 = call i64 @fresh_label(i64 %r281, i64 %r282)
  store i64 %r283, ptr %slot.lbl_rhs_done, align 8
  %r284 = load i64, ptr %slot.cg, align 8
  %r285.p = getelementptr inbounds [11 x i8], ptr @.str.158, i64 0, i64 0
  %r285 = ptrtoint ptr %r285.p to i64
  %r286 = load i64, ptr %slot.lbl_rhs_done, align 8
  %r287 = call i64 @nova_rt_str_concat(i64 %r285, i64 %r286)
  %r288 = call i64 @emit_indent(i64 %r284, i64 %r287)
  %r289 = load i64, ptr %slot.cg, align 8
  %r290 = load i64, ptr %slot.lbl_rhs_done, align 8
  %r291.p = getelementptr inbounds [2 x i8], ptr @.str.68, i64 0, i64 0
  %r291 = ptrtoint ptr %r291.p to i64
  %r292 = call i64 @nova_rt_str_concat(i64 %r290, i64 %r291)
  %r293 = call i64 @emit(i64 %r289, i64 %r292)
  %r294 = load i64, ptr %slot.cg, align 8
  %r295.p = getelementptr inbounds [11 x i8], ptr @.str.158, i64 0, i64 0
  %r295 = ptrtoint ptr %r295.p to i64
  %r296 = load i64, ptr %slot.lbl_end, align 8
  %r297 = call i64 @nova_rt_str_concat(i64 %r295, i64 %r296)
  %r298 = call i64 @emit_indent(i64 %r294, i64 %r297)
  %r299 = load i64, ptr %slot.cg, align 8
  %r300 = load i64, ptr %slot.lbl_end, align 8
  %r301.p = getelementptr inbounds [2 x i8], ptr @.str.68, i64 0, i64 0
  %r301 = ptrtoint ptr %r301.p to i64
  %r302 = call i64 @nova_rt_str_concat(i64 %r300, i64 %r301)
  %r303 = call i64 @emit(i64 %r299, i64 %r302)
  %r304 = load i64, ptr %slot.cg, align 8
  %r305 = load i64, ptr %slot.result, align 8
  %r306.p = getelementptr inbounds [17 x i8], ptr @.str.166, i64 0, i64 0
  %r306 = ptrtoint ptr %r306.p to i64
  %r307 = call i64 @nova_rt_str_concat(i64 %r305, i64 %r306)
  %r308 = load i64, ptr %slot.lbl_entry, align 8
  %r309 = call i64 @nova_rt_str_concat(i64 %r307, i64 %r308)
  %r310.p = getelementptr inbounds [5 x i8], ptr @.str.167, i64 0, i64 0
  %r310 = ptrtoint ptr %r310.p to i64
  %r311 = call i64 @nova_rt_str_concat(i64 %r309, i64 %r310)
  %r312 = load i64, ptr %slot.r2, align 8
  %r313 = call i64 @nova_rt_str_concat(i64 %r311, i64 %r312)
  %r314.p = getelementptr inbounds [4 x i8], ptr @.str.168, i64 0, i64 0
  %r314 = ptrtoint ptr %r314.p to i64
  %r315 = call i64 @nova_rt_str_concat(i64 %r313, i64 %r314)
  %r316 = load i64, ptr %slot.lbl_rhs_done, align 8
  %r317 = call i64 @nova_rt_str_concat(i64 %r315, i64 %r316)
  %r318.p = getelementptr inbounds [2 x i8], ptr @.str.62, i64 0, i64 0
  %r318 = ptrtoint ptr %r318.p to i64
  %r319 = call i64 @nova_rt_str_concat(i64 %r317, i64 %r318)
  %r320 = call i64 @emit_indent(i64 %r304, i64 %r319)
  %r321 = load i64, ptr %slot.result, align 8
  ret i64 %r321
else538:
  %r322 = load i64, ptr %slot.op, align 8
  %r323.p = getelementptr inbounds [3 x i8], ptr @.str.19, i64 0, i64 0
  %r323 = ptrtoint ptr %r323.p to i64
  %r324 = call i64 @nova_rt_eq(i64 %r322, i64 %r323)
  %br_then540 = icmp ne i64 %r324, 0
  br i1 %br_then540, label %then540, label %else541
then540:
  %r325 = load i64, ptr %slot.cg, align 8
  %r326.p = getelementptr inbounds [9 x i8], ptr @.str.169, i64 0, i64 0
  %r326 = ptrtoint ptr %r326.p to i64
  %r327 = call i64 @fresh_label(i64 %r325, i64 %r326)
  store i64 %r327, ptr %slot.lbl_entry, align 8
  %r328 = load i64, ptr %slot.cg, align 8
  %r329.p = getelementptr inbounds [11 x i8], ptr @.str.158, i64 0, i64 0
  %r329 = ptrtoint ptr %r329.p to i64
  %r330 = load i64, ptr %slot.lbl_entry, align 8
  %r331 = call i64 @nova_rt_str_concat(i64 %r329, i64 %r330)
  %r332 = call i64 @emit_indent(i64 %r328, i64 %r331)
  %r333 = load i64, ptr %slot.cg, align 8
  %r334 = load i64, ptr %slot.lbl_entry, align 8
  %r335.p = getelementptr inbounds [2 x i8], ptr @.str.68, i64 0, i64 0
  %r335 = ptrtoint ptr %r335.p to i64
  %r336 = call i64 @nova_rt_str_concat(i64 %r334, i64 %r335)
  %r337 = call i64 @emit(i64 %r333, i64 %r336)
  %r338 = load i64, ptr %slot.cg, align 8
  %r339 = call i64 @fresh_tmp(i64 %r338)
  store i64 %r339, ptr %slot.cmp, align 8
  %r340 = load i64, ptr %slot.cg, align 8
  %r341 = load i64, ptr %slot.cmp, align 8
  %r342.p = getelementptr inbounds [16 x i8], ptr @.str.159, i64 0, i64 0
  %r342 = ptrtoint ptr %r342.p to i64
  %r343 = call i64 @nova_rt_str_concat(i64 %r341, i64 %r342)
  %r344 = load i64, ptr %slot.l, align 8
  %r345 = call i64 @nova_rt_str_concat(i64 %r343, i64 %r344)
  %r346.p = getelementptr inbounds [4 x i8], ptr @.str.160, i64 0, i64 0
  %r346 = ptrtoint ptr %r346.p to i64
  %r347 = call i64 @nova_rt_str_concat(i64 %r345, i64 %r346)
  %r348 = call i64 @emit_indent(i64 %r340, i64 %r347)
  %r349 = load i64, ptr %slot.cg, align 8
  %r350.p = getelementptr inbounds [7 x i8], ptr @.str.170, i64 0, i64 0
  %r350 = ptrtoint ptr %r350.p to i64
  %r351 = call i64 @fresh_label(i64 %r349, i64 %r350)
  store i64 %r351, ptr %slot.lbl_rhs, align 8
  %r352 = load i64, ptr %slot.cg, align 8
  %r353.p = getelementptr inbounds [7 x i8], ptr @.str.171, i64 0, i64 0
  %r353 = ptrtoint ptr %r353.p to i64
  %r354 = call i64 @fresh_label(i64 %r352, i64 %r353)
  store i64 %r354, ptr %slot.lbl_end, align 8
  %r355 = load i64, ptr %slot.cg, align 8
  %r356.p = getelementptr inbounds [7 x i8], ptr @.str.163, i64 0, i64 0
  %r356 = ptrtoint ptr %r356.p to i64
  %r357 = load i64, ptr %slot.cmp, align 8
  %r358 = call i64 @nova_rt_str_concat(i64 %r356, i64 %r357)
  %r359.p = getelementptr inbounds [10 x i8], ptr @.str.164, i64 0, i64 0
  %r359 = ptrtoint ptr %r359.p to i64
  %r360 = call i64 @nova_rt_str_concat(i64 %r358, i64 %r359)
  %r361 = load i64, ptr %slot.lbl_end, align 8
  %r362 = call i64 @nova_rt_str_concat(i64 %r360, i64 %r361)
  %r363.p = getelementptr inbounds [10 x i8], ptr @.str.164, i64 0, i64 0
  %r363 = ptrtoint ptr %r363.p to i64
  %r364 = call i64 @nova_rt_str_concat(i64 %r362, i64 %r363)
  %r365 = load i64, ptr %slot.lbl_rhs, align 8
  %r366 = call i64 @nova_rt_str_concat(i64 %r364, i64 %r365)
  %r367 = call i64 @emit_indent(i64 %r355, i64 %r366)
  %r368 = load i64, ptr %slot.cg, align 8
  %r369 = load i64, ptr %slot.lbl_rhs, align 8
  %r370.p = getelementptr inbounds [2 x i8], ptr @.str.68, i64 0, i64 0
  %r370 = ptrtoint ptr %r370.p to i64
  %r371 = call i64 @nova_rt_str_concat(i64 %r369, i64 %r370)
  %r372 = call i64 @emit(i64 %r368, i64 %r371)
  %r373 = load i64, ptr %slot.cg, align 8
  %r374 = load i64, ptr %slot.right, align 8
  %r375 = call i64 @codegen_expr(i64 %r373, i64 %r374)
  store i64 %r375, ptr %slot.r2, align 8
  %r376 = load i64, ptr %slot.cg, align 8
  %r377.p = getelementptr inbounds [8 x i8], ptr @.str.172, i64 0, i64 0
  %r377 = ptrtoint ptr %r377.p to i64
  %r378 = call i64 @fresh_label(i64 %r376, i64 %r377)
  store i64 %r378, ptr %slot.lbl_rhs_done, align 8
  %r379 = load i64, ptr %slot.cg, align 8
  %r380.p = getelementptr inbounds [11 x i8], ptr @.str.158, i64 0, i64 0
  %r380 = ptrtoint ptr %r380.p to i64
  %r381 = load i64, ptr %slot.lbl_rhs_done, align 8
  %r382 = call i64 @nova_rt_str_concat(i64 %r380, i64 %r381)
  %r383 = call i64 @emit_indent(i64 %r379, i64 %r382)
  %r384 = load i64, ptr %slot.cg, align 8
  %r385 = load i64, ptr %slot.lbl_rhs_done, align 8
  %r386.p = getelementptr inbounds [2 x i8], ptr @.str.68, i64 0, i64 0
  %r386 = ptrtoint ptr %r386.p to i64
  %r387 = call i64 @nova_rt_str_concat(i64 %r385, i64 %r386)
  %r388 = call i64 @emit(i64 %r384, i64 %r387)
  %r389 = load i64, ptr %slot.cg, align 8
  %r390.p = getelementptr inbounds [11 x i8], ptr @.str.158, i64 0, i64 0
  %r390 = ptrtoint ptr %r390.p to i64
  %r391 = load i64, ptr %slot.lbl_end, align 8
  %r392 = call i64 @nova_rt_str_concat(i64 %r390, i64 %r391)
  %r393 = call i64 @emit_indent(i64 %r389, i64 %r392)
  %r394 = load i64, ptr %slot.cg, align 8
  %r395 = load i64, ptr %slot.lbl_end, align 8
  %r396.p = getelementptr inbounds [2 x i8], ptr @.str.68, i64 0, i64 0
  %r396 = ptrtoint ptr %r396.p to i64
  %r397 = call i64 @nova_rt_str_concat(i64 %r395, i64 %r396)
  %r398 = call i64 @emit(i64 %r394, i64 %r397)
  %r399 = load i64, ptr %slot.cg, align 8
  %r400 = load i64, ptr %slot.result, align 8
  %r401.p = getelementptr inbounds [13 x i8], ptr @.str.173, i64 0, i64 0
  %r401 = ptrtoint ptr %r401.p to i64
  %r402 = call i64 @nova_rt_str_concat(i64 %r400, i64 %r401)
  %r403 = load i64, ptr %slot.l, align 8
  %r404 = call i64 @nova_rt_str_concat(i64 %r402, i64 %r403)
  %r405.p = getelementptr inbounds [4 x i8], ptr @.str.168, i64 0, i64 0
  %r405 = ptrtoint ptr %r405.p to i64
  %r406 = call i64 @nova_rt_str_concat(i64 %r404, i64 %r405)
  %r407 = load i64, ptr %slot.lbl_entry, align 8
  %r408 = call i64 @nova_rt_str_concat(i64 %r406, i64 %r407)
  %r409.p = getelementptr inbounds [5 x i8], ptr @.str.167, i64 0, i64 0
  %r409 = ptrtoint ptr %r409.p to i64
  %r410 = call i64 @nova_rt_str_concat(i64 %r408, i64 %r409)
  %r411 = load i64, ptr %slot.r2, align 8
  %r412 = call i64 @nova_rt_str_concat(i64 %r410, i64 %r411)
  %r413.p = getelementptr inbounds [4 x i8], ptr @.str.168, i64 0, i64 0
  %r413 = ptrtoint ptr %r413.p to i64
  %r414 = call i64 @nova_rt_str_concat(i64 %r412, i64 %r413)
  %r415 = load i64, ptr %slot.lbl_rhs_done, align 8
  %r416 = call i64 @nova_rt_str_concat(i64 %r414, i64 %r415)
  %r417.p = getelementptr inbounds [2 x i8], ptr @.str.62, i64 0, i64 0
  %r417 = ptrtoint ptr %r417.p to i64
  %r418 = call i64 @nova_rt_str_concat(i64 %r416, i64 %r417)
  %r419 = call i64 @emit_indent(i64 %r399, i64 %r418)
  %r420 = load i64, ptr %slot.result, align 8
  ret i64 %r420
else541:
  %r421 = load i64, ptr %slot.op, align 8
  %r422.p = getelementptr inbounds [3 x i8], ptr @.str.96, i64 0, i64 0
  %r422 = ptrtoint ptr %r422.p to i64
  %r423 = call i64 @nova_rt_eq(i64 %r421, i64 %r422)
  %r424 = load i64, ptr %slot.op, align 8
  %r425.p = getelementptr inbounds [3 x i8], ptr @.str.98, i64 0, i64 0
  %r425 = ptrtoint ptr %r425.p to i64
  %r426 = call i64 @nova_rt_eq(i64 %r424, i64 %r425)
  %r427.cmp = icmp ne i64 %r423, 0
  %r427.cmp2 = icmp ne i64 %r426, 0
  %r427.or = or i1 %r427.cmp, %r427.cmp2
  %r427 = zext i1 %r427.or to i64
  %r428 = load i64, ptr %slot.op, align 8
  %r429.p = getelementptr inbounds [2 x i8], ptr @.str.99, i64 0, i64 0
  %r429 = ptrtoint ptr %r429.p to i64
  %r430 = call i64 @nova_rt_eq(i64 %r428, i64 %r429)
  %r431.cmp = icmp ne i64 %r427, 0
  %r431.cmp2 = icmp ne i64 %r430, 0
  %r431.or = or i1 %r431.cmp, %r431.cmp2
  %r431 = zext i1 %r431.or to i64
  %r432 = load i64, ptr %slot.op, align 8
  %r433.p = getelementptr inbounds [2 x i8], ptr @.str.100, i64 0, i64 0
  %r433 = ptrtoint ptr %r433.p to i64
  %r434 = call i64 @nova_rt_eq(i64 %r432, i64 %r433)
  %r435.cmp = icmp ne i64 %r431, 0
  %r435.cmp2 = icmp ne i64 %r434, 0
  %r435.or = or i1 %r435.cmp, %r435.cmp2
  %r435 = zext i1 %r435.or to i64
  %r436 = load i64, ptr %slot.op, align 8
  %r437.p = getelementptr inbounds [2 x i8], ptr @.str.103, i64 0, i64 0
  %r437 = ptrtoint ptr %r437.p to i64
  %r438 = call i64 @nova_rt_eq(i64 %r436, i64 %r437)
  %r439.cmp = icmp ne i64 %r435, 0
  %r439.cmp2 = icmp ne i64 %r438, 0
  %r439.or = or i1 %r439.cmp, %r439.cmp2
  %r439 = zext i1 %r439.or to i64
  %br_then543 = icmp ne i64 %r439, 0
  br i1 %br_then543, label %then543, label %else544
then543:
  %r440 = add i64 0, 0
  store i64 %r440, ptr %slot.llvm_op, align 8
  %r441 = load i64, ptr %slot.cg, align 8
  %r442 = load i64, ptr %slot.result, align 8
  %r443.p = getelementptr inbounds [4 x i8], ptr @.str.174, i64 0, i64 0
  %r443 = ptrtoint ptr %r443.p to i64
  %r444 = call i64 @nova_rt_str_concat(i64 %r442, i64 %r443)
  %r445 = load i64, ptr %slot.llvm_op, align 8
  %r446 = call i64 @nova_rt_str_concat(i64 %r444, i64 %r445)
  %r447.p = getelementptr inbounds [6 x i8], ptr @.str.175, i64 0, i64 0
  %r447 = ptrtoint ptr %r447.p to i64
  %r448 = call i64 @nova_rt_str_concat(i64 %r446, i64 %r447)
  %r449 = load i64, ptr %slot.l, align 8
  %r450 = call i64 @nova_rt_str_concat(i64 %r448, i64 %r449)
  %r451.p = getelementptr inbounds [3 x i8], ptr @.str.143, i64 0, i64 0
  %r451 = ptrtoint ptr %r451.p to i64
  %r452 = call i64 @nova_rt_str_concat(i64 %r450, i64 %r451)
  %r453 = load i64, ptr %slot.r_val, align 8
  %r454 = call i64 @nova_rt_str_concat(i64 %r452, i64 %r453)
  %r455 = call i64 @emit_indent(i64 %r441, i64 %r454)
  br label %endif545
else544:
  %r456 = load i64, ptr %slot.cg, align 8
  %r457 = load i64, ptr %slot.result, align 8
  %r458.p = getelementptr inbounds [12 x i8], ptr @.str.176, i64 0, i64 0
  %r458 = ptrtoint ptr %r458.p to i64
  %r459 = call i64 @nova_rt_str_concat(i64 %r457, i64 %r458)
  %r460 = load i64, ptr %slot.l, align 8
  %r461 = call i64 @nova_rt_str_concat(i64 %r459, i64 %r460)
  %r462.p = getelementptr inbounds [3 x i8], ptr @.str.143, i64 0, i64 0
  %r462 = ptrtoint ptr %r462.p to i64
  %r463 = call i64 @nova_rt_str_concat(i64 %r461, i64 %r462)
  %r464 = load i64, ptr %slot.r_val, align 8
  %r465 = call i64 @nova_rt_str_concat(i64 %r463, i64 %r464)
  %r466 = call i64 @emit_indent(i64 %r456, i64 %r465)
  br label %endif545
endif545:
  br label %endif542
endif542:
  br label %endif539
endif539:
  br label %endif536
endif536:
  br label %endif533
endif533:
  br label %endif530
endif530:
  br label %endif527
endif527:
  br label %endif524
endif524:
  br label %endif521
endif521:
  br label %endif518
endif518:
  br label %endif515
endif515:
  br label %endif512
endif512:
  br label %endif509
endif509:
  br label %endif506
endif506:
  %r467 = load i64, ptr %slot.result, align 8
  ret i64 0
}

define i64 @codegen_unary(i64 %p0, i64 %p1, i64 %p2) nounwind {
entry:
  %slot.cg = alloca i64, align 8
  store i64 %p0, ptr %slot.cg, align 8
  %slot.op = alloca i64, align 8
  store i64 %p1, ptr %slot.op, align 8
  %slot.operand = alloca i64, align 8
  store i64 %p2, ptr %slot.operand, align 8
  %slot.val = alloca i64, align 8
  store i64 0, ptr %slot.val, align 8
  %slot.result = alloca i64, align 8
  store i64 0, ptr %slot.result, align 8
  %slot.cmp = alloca i64, align 8
  store i64 0, ptr %slot.cmp, align 8
  %r0 = load i64, ptr %slot.cg, align 8
  %r1 = load i64, ptr %slot.operand, align 8
  %r2 = call i64 @codegen_expr(i64 %r0, i64 %r1)
  store i64 %r2, ptr %slot.val, align 8
  %r3 = load i64, ptr %slot.cg, align 8
  %r4 = call i64 @fresh_reg(i64 %r3)
  store i64 %r4, ptr %slot.result, align 8
  %r5 = load i64, ptr %slot.op, align 8
  %r6.p = getelementptr inbounds [2 x i8], ptr @.str.77, i64 0, i64 0
  %r6 = ptrtoint ptr %r6.p to i64
  %r7 = call i64 @nova_rt_eq(i64 %r5, i64 %r6)
  %br_then546 = icmp ne i64 %r7, 0
  br i1 %br_then546, label %then546, label %else547
then546:
  %r8 = load i64, ptr %slot.cg, align 8
  %r9 = load i64, ptr %slot.result, align 8
  %r10.p = getelementptr inbounds [15 x i8], ptr @.str.177, i64 0, i64 0
  %r10 = ptrtoint ptr %r10.p to i64
  %r11 = call i64 @nova_rt_str_concat(i64 %r9, i64 %r10)
  %r12 = load i64, ptr %slot.val, align 8
  %r13 = call i64 @nova_rt_str_concat(i64 %r11, i64 %r12)
  %r14 = call i64 @emit_indent(i64 %r8, i64 %r13)
  br label %endif548
else547:
  %r15 = load i64, ptr %slot.op, align 8
  %r16.p = getelementptr inbounds [4 x i8], ptr @.str.21, i64 0, i64 0
  %r16 = ptrtoint ptr %r16.p to i64
  %r17 = call i64 @nova_rt_eq(i64 %r15, i64 %r16)
  %br_then549 = icmp ne i64 %r17, 0
  br i1 %br_then549, label %then549, label %else550
then549:
  %r18 = load i64, ptr %slot.cg, align 8
  %r19 = call i64 @fresh_tmp(i64 %r18)
  store i64 %r19, ptr %slot.cmp, align 8
  %r20 = load i64, ptr %slot.cg, align 8
  %r21 = load i64, ptr %slot.cmp, align 8
  %r22.p = getelementptr inbounds [16 x i8], ptr @.str.178, i64 0, i64 0
  %r22 = ptrtoint ptr %r22.p to i64
  %r23 = call i64 @nova_rt_str_concat(i64 %r21, i64 %r22)
  %r24 = load i64, ptr %slot.val, align 8
  %r25 = call i64 @nova_rt_str_concat(i64 %r23, i64 %r24)
  %r26.p = getelementptr inbounds [4 x i8], ptr @.str.160, i64 0, i64 0
  %r26 = ptrtoint ptr %r26.p to i64
  %r27 = call i64 @nova_rt_str_concat(i64 %r25, i64 %r26)
  %r28 = call i64 @emit_indent(i64 %r20, i64 %r27)
  %r29 = load i64, ptr %slot.cg, align 8
  %r30 = load i64, ptr %slot.result, align 8
  %r31.p = getelementptr inbounds [12 x i8], ptr @.str.152, i64 0, i64 0
  %r31 = ptrtoint ptr %r31.p to i64
  %r32 = call i64 @nova_rt_str_concat(i64 %r30, i64 %r31)
  %r33 = load i64, ptr %slot.cmp, align 8
  %r34 = call i64 @nova_rt_str_concat(i64 %r32, i64 %r33)
  %r35.p = getelementptr inbounds [8 x i8], ptr @.str.153, i64 0, i64 0
  %r35 = ptrtoint ptr %r35.p to i64
  %r36 = call i64 @nova_rt_str_concat(i64 %r34, i64 %r35)
  %r37 = call i64 @emit_indent(i64 %r29, i64 %r36)
  br label %endif551
else550:
  %r38 = load i64, ptr %slot.op, align 8
  %r39.p = getelementptr inbounds [2 x i8], ptr @.str.104, i64 0, i64 0
  %r39 = ptrtoint ptr %r39.p to i64
  %r40 = call i64 @nova_rt_eq(i64 %r38, i64 %r39)
  %br_then552 = icmp ne i64 %r40, 0
  br i1 %br_then552, label %then552, label %else553
then552:
  %r41 = load i64, ptr %slot.cg, align 8
  %r42 = load i64, ptr %slot.result, align 8
  %r43.p = getelementptr inbounds [12 x i8], ptr @.str.179, i64 0, i64 0
  %r43 = ptrtoint ptr %r43.p to i64
  %r44 = call i64 @nova_rt_str_concat(i64 %r42, i64 %r43)
  %r45 = load i64, ptr %slot.val, align 8
  %r46 = call i64 @nova_rt_str_concat(i64 %r44, i64 %r45)
  %r47.p = getelementptr inbounds [5 x i8], ptr @.str.180, i64 0, i64 0
  %r47 = ptrtoint ptr %r47.p to i64
  %r48 = call i64 @nova_rt_str_concat(i64 %r46, i64 %r47)
  %r49 = call i64 @emit_indent(i64 %r41, i64 %r48)
  br label %endif554
else553:
  %r50 = load i64, ptr %slot.val, align 8
  ret i64 %r50
endif554:
  br label %endif551
endif551:
  br label %endif548
endif548:
  %r51 = load i64, ptr %slot.result, align 8
  ret i64 0
}

define i64 @codegen_call(i64 %p0, i64 %p1, i64 %p2) nounwind {
entry:
  %slot.cg = alloca i64, align 8
  store i64 %p0, ptr %slot.cg, align 8
  %slot.name = alloca i64, align 8
  store i64 %p1, ptr %slot.name, align 8
  %slot.args = alloca i64, align 8
  store i64 %p2, ptr %slot.args, align 8
  %slot.num_fields = alloca i64, align 8
  store i64 0, ptr %slot.num_fields, align 8
  %slot.alloc_size = alloca i64, align 8
  store i64 0, ptr %slot.alloc_size, align 8
  %slot.ptr = alloca i64, align 8
  store i64 0, ptr %slot.ptr, align 8
  %slot.fi = alloca i64, align 8
  store i64 0, ptr %slot.fi, align 8
  %slot.__for_idx_558 = alloca i64, align 8
  store i64 0, ptr %slot.__for_idx_558, align 8
  %slot.arg = alloca i64, align 8
  store i64 0, ptr %slot.arg, align 8
  %slot.arg_r = alloca i64, align 8
  store i64 0, ptr %slot.arg_r, align 8
  %slot.gep = alloca i64, align 8
  store i64 0, ptr %slot.gep, align 8
  %slot.result = alloca i64, align 8
  store i64 0, ptr %slot.result, align 8
  %slot.rt_name = alloca i64, align 8
  store i64 0, ptr %slot.rt_name, align 8
  %slot.arg_strs = alloca i64, align 8
  store i64 0, ptr %slot.arg_strs, align 8
  %slot.__for_idx_561 = alloca i64, align 8
  store i64 0, ptr %slot.__for_idx_561, align 8
  %slot.a = alloca i64, align 8
  store i64 0, ptr %slot.a, align 8
  %slot.args_str = alloca i64, align 8
  store i64 0, ptr %slot.args_str, align 8
  %r0 = add i64 0, 0
  %r1 = load i64, ptr %slot.name, align 8
  %r2 = call i64 @nova_rt_contains(i64 %r0, i64 %r1)
  %br_then555 = icmp ne i64 %r2, 0
  br i1 %br_then555, label %then555, label %else556
then555:
  %r3 = load i64, ptr %slot.args, align 8
  %r4 = call i64 @nova_rt_len_any(i64 %r3)
  store i64 %r4, ptr %slot.num_fields, align 8
  %r5 = load i64, ptr %slot.num_fields, align 8
  %r6 = add i64 8, 0
  %r7 = mul i64 %r5, %r6
  store i64 %r7, ptr %slot.alloc_size, align 8
  %r8 = load i64, ptr %slot.cg, align 8
  %r9 = call i64 @fresh_reg(i64 %r8)
  store i64 %r9, ptr %slot.ptr, align 8
  %r10 = load i64, ptr %slot.cg, align 8
  %r11 = load i64, ptr %slot.ptr, align 8
  %r12.p = getelementptr inbounds [39 x i8], ptr @.str.181, i64 0, i64 0
  %r12 = ptrtoint ptr %r12.p to i64
  %r13 = call i64 @nova_rt_str_concat(i64 %r11, i64 %r12)
  %r14 = load i64, ptr %slot.alloc_size, align 8
  %r15 = call i64 @nova_rt_int_to_str(i64 %r14)
  %r16 = call i64 @nova_rt_str_concat(i64 %r13, i64 %r15)
  %r17.p = getelementptr inbounds [2 x i8], ptr @.str.60, i64 0, i64 0
  %r17 = ptrtoint ptr %r17.p to i64
  %r18 = call i64 @nova_rt_str_concat(i64 %r16, i64 %r17)
  %r19 = call i64 @emit_indent(i64 %r10, i64 %r18)
  %r20 = add i64 0, 0
  store i64 %r20, ptr %slot.fi, align 8
  %r21 = load i64, ptr %slot.args, align 8
  %r22 = call i64 @nova_rt_len_any(i64 %r21)
  %r23 = add i64 0, 0
  store i64 %r23, ptr %slot.__for_idx_558, align 8
  br label %for_hdr558
for_hdr558:
  %r24 = load i64, ptr %slot.__for_idx_558, align 8
  %r25.cmp = icmp slt i64 %r24, %r22
  %r25 = zext i1 %r25.cmp to i64
  %br_for_body559 = icmp ne i64 %r25, 0
  br i1 %br_for_body559, label %for_body559, label %for_exit560
for_body559:
  %r26 = call i64 @nova_rt_index_get(i64 %r21, i64 %r24)
  store i64 %r26, ptr %slot.arg, align 8
  %r27 = load i64, ptr %slot.cg, align 8
  %r28 = load i64, ptr %slot.arg, align 8
  %r29 = call i64 @codegen_expr(i64 %r27, i64 %r28)
  store i64 %r29, ptr %slot.arg_r, align 8
  %r30 = load i64, ptr %slot.cg, align 8
  %r31 = call i64 @fresh_tmp(i64 %r30)
  store i64 %r31, ptr %slot.gep, align 8
  %r32 = load i64, ptr %slot.cg, align 8
  %r33 = load i64, ptr %slot.gep, align 8
  %r34.p = getelementptr inbounds [27 x i8], ptr @.str.182, i64 0, i64 0
  %r34 = ptrtoint ptr %r34.p to i64
  %r35 = call i64 @nova_rt_str_concat(i64 %r33, i64 %r34)
  %r36 = load i64, ptr %slot.ptr, align 8
  %r37 = call i64 @nova_rt_str_concat(i64 %r35, i64 %r36)
  %r38.p = getelementptr inbounds [7 x i8], ptr @.str.141, i64 0, i64 0
  %r38 = ptrtoint ptr %r38.p to i64
  %r39 = call i64 @nova_rt_str_concat(i64 %r37, i64 %r38)
  %r40 = load i64, ptr %slot.fi, align 8
  %r41 = call i64 @nova_rt_int_to_str(i64 %r40)
  %r42 = call i64 @nova_rt_str_concat(i64 %r39, i64 %r41)
  %r43 = call i64 @emit_indent(i64 %r32, i64 %r42)
  %r44 = load i64, ptr %slot.cg, align 8
  %r45.p = getelementptr inbounds [11 x i8], ptr @.str.183, i64 0, i64 0
  %r45 = ptrtoint ptr %r45.p to i64
  %r46 = load i64, ptr %slot.arg_r, align 8
  %r47 = call i64 @nova_rt_str_concat(i64 %r45, i64 %r46)
  %r48.p = getelementptr inbounds [7 x i8], ptr @.str.184, i64 0, i64 0
  %r48 = ptrtoint ptr %r48.p to i64
  %r49 = call i64 @nova_rt_str_concat(i64 %r47, i64 %r48)
  %r50 = load i64, ptr %slot.gep, align 8
  %r51 = call i64 @nova_rt_str_concat(i64 %r49, i64 %r50)
  %r52.p = getelementptr inbounds [10 x i8], ptr @.str.185, i64 0, i64 0
  %r52 = ptrtoint ptr %r52.p to i64
  %r53 = call i64 @nova_rt_str_concat(i64 %r51, i64 %r52)
  %r54 = call i64 @emit_indent(i64 %r44, i64 %r53)
  %r55 = load i64, ptr %slot.fi, align 8
  %r56 = add i64 1, 0
  %r57 = add i64 %r55, %r56
  store i64 %r57, ptr %slot.fi, align 8
  %r58 = load i64, ptr %slot.__for_idx_558, align 8
  %r59 = add i64 1, 0
  %r60 = add i64 %r58, %r59
  store i64 %r60, ptr %slot.__for_idx_558, align 8
  br label %for_hdr558
for_exit560:
  %r61 = load i64, ptr %slot.cg, align 8
  %r62 = call i64 @fresh_reg(i64 %r61)
  store i64 %r62, ptr %slot.result, align 8
  %r63 = load i64, ptr %slot.cg, align 8
  %r64 = load i64, ptr %slot.result, align 8
  %r65.p = getelementptr inbounds [17 x i8], ptr @.str.186, i64 0, i64 0
  %r65 = ptrtoint ptr %r65.p to i64
  %r66 = call i64 @nova_rt_str_concat(i64 %r64, i64 %r65)
  %r67 = load i64, ptr %slot.ptr, align 8
  %r68 = call i64 @nova_rt_str_concat(i64 %r66, i64 %r67)
  %r69.p = getelementptr inbounds [8 x i8], ptr @.str.153, i64 0, i64 0
  %r69 = ptrtoint ptr %r69.p to i64
  %r70 = call i64 @nova_rt_str_concat(i64 %r68, i64 %r69)
  %r71 = call i64 @emit_indent(i64 %r63, i64 %r70)
  %r72 = load i64, ptr %slot.result, align 8
  ret i64 %r72
else556:
  br label %endif557
endif557:
  %r73 = load i64, ptr %slot.name, align 8
  %r74 = call i64 @resolve_runtime_fn(i64 %r73)
  store i64 %r74, ptr %slot.rt_name, align 8
  %r75 = call i64 @nova_rt_list_create()
  store i64 %r75, ptr %slot.arg_strs, align 8
  %r76 = load i64, ptr %slot.args, align 8
  %r77 = call i64 @nova_rt_len_any(i64 %r76)
  %r78 = add i64 0, 0
  store i64 %r78, ptr %slot.__for_idx_561, align 8
  br label %for_hdr561
for_hdr561:
  %r79 = load i64, ptr %slot.__for_idx_561, align 8
  %r80.cmp = icmp slt i64 %r79, %r77
  %r80 = zext i1 %r80.cmp to i64
  %br_for_body562 = icmp ne i64 %r80, 0
  br i1 %br_for_body562, label %for_body562, label %for_exit563
for_body562:
  %r81 = call i64 @nova_rt_index_get(i64 %r76, i64 %r79)
  store i64 %r81, ptr %slot.arg, align 8
  %r82 = load i64, ptr %slot.cg, align 8
  %r83 = load i64, ptr %slot.arg, align 8
  %r84 = call i64 @codegen_expr(i64 %r82, i64 %r83)
  store i64 %r84, ptr %slot.a, align 8
  %r85 = load i64, ptr %slot.arg_strs, align 8
  %r86.p = getelementptr inbounds [5 x i8], ptr @.str.187, i64 0, i64 0
  %r86 = ptrtoint ptr %r86.p to i64
  %r87 = load i64, ptr %slot.a, align 8
  %r88 = call i64 @nova_rt_str_concat(i64 %r86, i64 %r87)
  %r89 = call i64 @nova_rt_list_append(i64 %r85, i64 %r88)
  %r90 = load i64, ptr %slot.__for_idx_561, align 8
  %r91 = add i64 1, 0
  %r92 = add i64 %r90, %r91
  store i64 %r92, ptr %slot.__for_idx_561, align 8
  br label %for_hdr561
for_exit563:
  %r93 = load i64, ptr %slot.cg, align 8
  %r94 = call i64 @fresh_reg(i64 %r93)
  store i64 %r94, ptr %slot.result, align 8
  %r95 = load i64, ptr %slot.arg_strs, align 8
  %r96.p = getelementptr inbounds [3 x i8], ptr @.str.143, i64 0, i64 0
  %r96 = ptrtoint ptr %r96.p to i64
  %r97 = call i64 @nova_rt_join(i64 %r95, i64 %r96)
  store i64 %r97, ptr %slot.args_str, align 8
  %r98 = load i64, ptr %slot.cg, align 8
  %r99 = load i64, ptr %slot.result, align 8
  %r100.p = getelementptr inbounds [14 x i8], ptr @.str.188, i64 0, i64 0
  %r100 = ptrtoint ptr %r100.p to i64
  %r101 = call i64 @nova_rt_str_concat(i64 %r99, i64 %r100)
  %r102 = load i64, ptr %slot.rt_name, align 8
  %r103 = call i64 @nova_rt_str_concat(i64 %r101, i64 %r102)
  %r104.p = getelementptr inbounds [2 x i8], ptr @.str.59, i64 0, i64 0
  %r104 = ptrtoint ptr %r104.p to i64
  %r105 = call i64 @nova_rt_str_concat(i64 %r103, i64 %r104)
  %r106 = load i64, ptr %slot.args_str, align 8
  %r107 = call i64 @nova_rt_str_concat(i64 %r105, i64 %r106)
  %r108.p = getelementptr inbounds [2 x i8], ptr @.str.60, i64 0, i64 0
  %r108 = ptrtoint ptr %r108.p to i64
  %r109 = call i64 @nova_rt_str_concat(i64 %r107, i64 %r108)
  %r110 = call i64 @emit_indent(i64 %r98, i64 %r109)
  %r111 = load i64, ptr %slot.result, align 8
  ret i64 0
}

define i64 @codegen_method_call(i64 %p0, i64 %p1, i64 %p2) nounwind {
entry:
  %slot.cg = alloca i64, align 8
  store i64 %p0, ptr %slot.cg, align 8
  %slot.method = alloca i64, align 8
  store i64 %p1, ptr %slot.method, align 8
  %slot.args = alloca i64, align 8
  store i64 %p2, ptr %slot.args, align 8
  %slot.rt_name = alloca i64, align 8
  store i64 0, ptr %slot.rt_name, align 8
  %slot.arg_strs = alloca i64, align 8
  store i64 0, ptr %slot.arg_strs, align 8
  %slot.__for_idx_564 = alloca i64, align 8
  store i64 0, ptr %slot.__for_idx_564, align 8
  %slot.arg = alloca i64, align 8
  store i64 0, ptr %slot.arg, align 8
  %slot.a = alloca i64, align 8
  store i64 0, ptr %slot.a, align 8
  %slot.result = alloca i64, align 8
  store i64 0, ptr %slot.result, align 8
  %slot.args_str = alloca i64, align 8
  store i64 0, ptr %slot.args_str, align 8
  %r0 = load i64, ptr %slot.method, align 8
  %r1 = call i64 @resolve_method_fn(i64 %r0)
  store i64 %r1, ptr %slot.rt_name, align 8
  %r2 = call i64 @nova_rt_list_create()
  store i64 %r2, ptr %slot.arg_strs, align 8
  %r3 = load i64, ptr %slot.args, align 8
  %r4 = call i64 @nova_rt_len_any(i64 %r3)
  %r5 = add i64 0, 0
  store i64 %r5, ptr %slot.__for_idx_564, align 8
  br label %for_hdr564
for_hdr564:
  %r6 = load i64, ptr %slot.__for_idx_564, align 8
  %r7.cmp = icmp slt i64 %r6, %r4
  %r7 = zext i1 %r7.cmp to i64
  %br_for_body565 = icmp ne i64 %r7, 0
  br i1 %br_for_body565, label %for_body565, label %for_exit566
for_body565:
  %r8 = call i64 @nova_rt_index_get(i64 %r3, i64 %r6)
  store i64 %r8, ptr %slot.arg, align 8
  %r9 = load i64, ptr %slot.cg, align 8
  %r10 = load i64, ptr %slot.arg, align 8
  %r11 = call i64 @codegen_expr(i64 %r9, i64 %r10)
  store i64 %r11, ptr %slot.a, align 8
  %r12 = load i64, ptr %slot.arg_strs, align 8
  %r13.p = getelementptr inbounds [5 x i8], ptr @.str.187, i64 0, i64 0
  %r13 = ptrtoint ptr %r13.p to i64
  %r14 = load i64, ptr %slot.a, align 8
  %r15 = call i64 @nova_rt_str_concat(i64 %r13, i64 %r14)
  %r16 = call i64 @nova_rt_list_append(i64 %r12, i64 %r15)
  %r17 = load i64, ptr %slot.__for_idx_564, align 8
  %r18 = add i64 1, 0
  %r19 = add i64 %r17, %r18
  store i64 %r19, ptr %slot.__for_idx_564, align 8
  br label %for_hdr564
for_exit566:
  %r20 = load i64, ptr %slot.cg, align 8
  %r21 = call i64 @fresh_reg(i64 %r20)
  store i64 %r21, ptr %slot.result, align 8
  %r22 = load i64, ptr %slot.arg_strs, align 8
  %r23.p = getelementptr inbounds [3 x i8], ptr @.str.143, i64 0, i64 0
  %r23 = ptrtoint ptr %r23.p to i64
  %r24 = call i64 @nova_rt_join(i64 %r22, i64 %r23)
  store i64 %r24, ptr %slot.args_str, align 8
  %r25 = load i64, ptr %slot.cg, align 8
  %r26 = load i64, ptr %slot.result, align 8
  %r27.p = getelementptr inbounds [14 x i8], ptr @.str.188, i64 0, i64 0
  %r27 = ptrtoint ptr %r27.p to i64
  %r28 = call i64 @nova_rt_str_concat(i64 %r26, i64 %r27)
  %r29 = load i64, ptr %slot.rt_name, align 8
  %r30 = call i64 @nova_rt_str_concat(i64 %r28, i64 %r29)
  %r31.p = getelementptr inbounds [2 x i8], ptr @.str.59, i64 0, i64 0
  %r31 = ptrtoint ptr %r31.p to i64
  %r32 = call i64 @nova_rt_str_concat(i64 %r30, i64 %r31)
  %r33 = load i64, ptr %slot.args_str, align 8
  %r34 = call i64 @nova_rt_str_concat(i64 %r32, i64 %r33)
  %r35.p = getelementptr inbounds [2 x i8], ptr @.str.60, i64 0, i64 0
  %r35 = ptrtoint ptr %r35.p to i64
  %r36 = call i64 @nova_rt_str_concat(i64 %r34, i64 %r35)
  %r37 = call i64 @emit_indent(i64 %r25, i64 %r36)
  %r38 = load i64, ptr %slot.result, align 8
  ret i64 0
}

define i64 @codegen_if_expr(i64 %p0, i64 %p1) nounwind {
entry:
  %slot.cg = alloca i64, align 8
  store i64 %p0, ptr %slot.cg, align 8
  %slot.parts = alloca i64, align 8
  store i64 %p1, ptr %slot.parts, align 8
  %slot.cond_r = alloca i64, align 8
  store i64 0, ptr %slot.cond_r, align 8
  %slot.cmp = alloca i64, align 8
  store i64 0, ptr %slot.cmp, align 8
  %slot.lbl_then = alloca i64, align 8
  store i64 0, ptr %slot.lbl_then, align 8
  %slot.lbl_else = alloca i64, align 8
  store i64 0, ptr %slot.lbl_else, align 8
  %slot.lbl_merge = alloca i64, align 8
  store i64 0, ptr %slot.lbl_merge, align 8
  %slot.then_r = alloca i64, align 8
  store i64 0, ptr %slot.then_r, align 8
  %slot.lbl_then_done = alloca i64, align 8
  store i64 0, ptr %slot.lbl_then_done, align 8
  %slot.else_r = alloca i64, align 8
  store i64 0, ptr %slot.else_r, align 8
  %slot.lbl_else_done = alloca i64, align 8
  store i64 0, ptr %slot.lbl_else_done, align 8
  %slot.result = alloca i64, align 8
  store i64 0, ptr %slot.result, align 8
  %r0 = load i64, ptr %slot.cg, align 8
  %r1 = load i64, ptr %slot.parts, align 8
  %r2 = add i64 0, 0
  %r3 = call i64 @nova_rt_index_get(i64 %r1, i64 %r2)
  %r4 = call i64 @codegen_expr(i64 %r0, i64 %r3)
  store i64 %r4, ptr %slot.cond_r, align 8
  %r5 = load i64, ptr %slot.cg, align 8
  %r6 = call i64 @fresh_tmp(i64 %r5)
  store i64 %r6, ptr %slot.cmp, align 8
  %r7 = load i64, ptr %slot.cg, align 8
  %r8 = load i64, ptr %slot.cmp, align 8
  %r9.p = getelementptr inbounds [16 x i8], ptr @.str.159, i64 0, i64 0
  %r9 = ptrtoint ptr %r9.p to i64
  %r10 = call i64 @nova_rt_str_concat(i64 %r8, i64 %r9)
  %r11 = load i64, ptr %slot.cond_r, align 8
  %r12 = call i64 @nova_rt_str_concat(i64 %r10, i64 %r11)
  %r13.p = getelementptr inbounds [4 x i8], ptr @.str.160, i64 0, i64 0
  %r13 = ptrtoint ptr %r13.p to i64
  %r14 = call i64 @nova_rt_str_concat(i64 %r12, i64 %r13)
  %r15 = call i64 @emit_indent(i64 %r7, i64 %r14)
  %r16 = load i64, ptr %slot.cg, align 8
  %r17.p = getelementptr inbounds [8 x i8], ptr @.str.189, i64 0, i64 0
  %r17 = ptrtoint ptr %r17.p to i64
  %r18 = call i64 @fresh_label(i64 %r16, i64 %r17)
  store i64 %r18, ptr %slot.lbl_then, align 8
  %r19 = load i64, ptr %slot.cg, align 8
  %r20.p = getelementptr inbounds [8 x i8], ptr @.str.190, i64 0, i64 0
  %r20 = ptrtoint ptr %r20.p to i64
  %r21 = call i64 @fresh_label(i64 %r19, i64 %r20)
  store i64 %r21, ptr %slot.lbl_else, align 8
  %r22 = load i64, ptr %slot.cg, align 8
  %r23.p = getelementptr inbounds [9 x i8], ptr @.str.191, i64 0, i64 0
  %r23 = ptrtoint ptr %r23.p to i64
  %r24 = call i64 @fresh_label(i64 %r22, i64 %r23)
  store i64 %r24, ptr %slot.lbl_merge, align 8
  %r25 = load i64, ptr %slot.cg, align 8
  %r26.p = getelementptr inbounds [7 x i8], ptr @.str.163, i64 0, i64 0
  %r26 = ptrtoint ptr %r26.p to i64
  %r27 = load i64, ptr %slot.cmp, align 8
  %r28 = call i64 @nova_rt_str_concat(i64 %r26, i64 %r27)
  %r29.p = getelementptr inbounds [10 x i8], ptr @.str.164, i64 0, i64 0
  %r29 = ptrtoint ptr %r29.p to i64
  %r30 = call i64 @nova_rt_str_concat(i64 %r28, i64 %r29)
  %r31 = load i64, ptr %slot.lbl_then, align 8
  %r32 = call i64 @nova_rt_str_concat(i64 %r30, i64 %r31)
  %r33.p = getelementptr inbounds [10 x i8], ptr @.str.164, i64 0, i64 0
  %r33 = ptrtoint ptr %r33.p to i64
  %r34 = call i64 @nova_rt_str_concat(i64 %r32, i64 %r33)
  %r35 = load i64, ptr %slot.lbl_else, align 8
  %r36 = call i64 @nova_rt_str_concat(i64 %r34, i64 %r35)
  %r37 = call i64 @emit_indent(i64 %r25, i64 %r36)
  %r38 = load i64, ptr %slot.cg, align 8
  %r39 = load i64, ptr %slot.lbl_then, align 8
  %r40.p = getelementptr inbounds [2 x i8], ptr @.str.68, i64 0, i64 0
  %r40 = ptrtoint ptr %r40.p to i64
  %r41 = call i64 @nova_rt_str_concat(i64 %r39, i64 %r40)
  %r42 = call i64 @emit(i64 %r38, i64 %r41)
  %r43 = load i64, ptr %slot.cg, align 8
  %r44 = load i64, ptr %slot.parts, align 8
  %r45 = add i64 1, 0
  %r46 = call i64 @nova_rt_index_get(i64 %r44, i64 %r45)
  %r47 = call i64 @codegen_expr(i64 %r43, i64 %r46)
  store i64 %r47, ptr %slot.then_r, align 8
  %r48 = load i64, ptr %slot.cg, align 8
  %r49.p = getelementptr inbounds [13 x i8], ptr @.str.192, i64 0, i64 0
  %r49 = ptrtoint ptr %r49.p to i64
  %r50 = call i64 @fresh_label(i64 %r48, i64 %r49)
  store i64 %r50, ptr %slot.lbl_then_done, align 8
  %r51 = load i64, ptr %slot.cg, align 8
  %r52.p = getelementptr inbounds [11 x i8], ptr @.str.158, i64 0, i64 0
  %r52 = ptrtoint ptr %r52.p to i64
  %r53 = load i64, ptr %slot.lbl_then_done, align 8
  %r54 = call i64 @nova_rt_str_concat(i64 %r52, i64 %r53)
  %r55 = call i64 @emit_indent(i64 %r51, i64 %r54)
  %r56 = load i64, ptr %slot.cg, align 8
  %r57 = load i64, ptr %slot.lbl_then_done, align 8
  %r58.p = getelementptr inbounds [2 x i8], ptr @.str.68, i64 0, i64 0
  %r58 = ptrtoint ptr %r58.p to i64
  %r59 = call i64 @nova_rt_str_concat(i64 %r57, i64 %r58)
  %r60 = call i64 @emit(i64 %r56, i64 %r59)
  %r61 = load i64, ptr %slot.cg, align 8
  %r62.p = getelementptr inbounds [11 x i8], ptr @.str.158, i64 0, i64 0
  %r62 = ptrtoint ptr %r62.p to i64
  %r63 = load i64, ptr %slot.lbl_merge, align 8
  %r64 = call i64 @nova_rt_str_concat(i64 %r62, i64 %r63)
  %r65 = call i64 @emit_indent(i64 %r61, i64 %r64)
  %r66 = load i64, ptr %slot.cg, align 8
  %r67 = load i64, ptr %slot.lbl_else, align 8
  %r68.p = getelementptr inbounds [2 x i8], ptr @.str.68, i64 0, i64 0
  %r68 = ptrtoint ptr %r68.p to i64
  %r69 = call i64 @nova_rt_str_concat(i64 %r67, i64 %r68)
  %r70 = call i64 @emit(i64 %r66, i64 %r69)
  %r71 = add i64 0, 0
  store i64 %r71, ptr %slot.else_r, align 8
  %r72 = load i64, ptr %slot.cg, align 8
  %r73.p = getelementptr inbounds [13 x i8], ptr @.str.193, i64 0, i64 0
  %r73 = ptrtoint ptr %r73.p to i64
  %r74 = call i64 @fresh_label(i64 %r72, i64 %r73)
  store i64 %r74, ptr %slot.lbl_else_done, align 8
  %r75 = load i64, ptr %slot.cg, align 8
  %r76.p = getelementptr inbounds [11 x i8], ptr @.str.158, i64 0, i64 0
  %r76 = ptrtoint ptr %r76.p to i64
  %r77 = load i64, ptr %slot.lbl_else_done, align 8
  %r78 = call i64 @nova_rt_str_concat(i64 %r76, i64 %r77)
  %r79 = call i64 @emit_indent(i64 %r75, i64 %r78)
  %r80 = load i64, ptr %slot.cg, align 8
  %r81 = load i64, ptr %slot.lbl_else_done, align 8
  %r82.p = getelementptr inbounds [2 x i8], ptr @.str.68, i64 0, i64 0
  %r82 = ptrtoint ptr %r82.p to i64
  %r83 = call i64 @nova_rt_str_concat(i64 %r81, i64 %r82)
  %r84 = call i64 @emit(i64 %r80, i64 %r83)
  %r85 = load i64, ptr %slot.cg, align 8
  %r86.p = getelementptr inbounds [11 x i8], ptr @.str.158, i64 0, i64 0
  %r86 = ptrtoint ptr %r86.p to i64
  %r87 = load i64, ptr %slot.lbl_merge, align 8
  %r88 = call i64 @nova_rt_str_concat(i64 %r86, i64 %r87)
  %r89 = call i64 @emit_indent(i64 %r85, i64 %r88)
  %r90 = load i64, ptr %slot.cg, align 8
  %r91 = load i64, ptr %slot.lbl_merge, align 8
  %r92.p = getelementptr inbounds [2 x i8], ptr @.str.68, i64 0, i64 0
  %r92 = ptrtoint ptr %r92.p to i64
  %r93 = call i64 @nova_rt_str_concat(i64 %r91, i64 %r92)
  %r94 = call i64 @emit(i64 %r90, i64 %r93)
  %r95 = load i64, ptr %slot.cg, align 8
  %r96 = call i64 @fresh_reg(i64 %r95)
  store i64 %r96, ptr %slot.result, align 8
  %r97 = load i64, ptr %slot.cg, align 8
  %r98 = load i64, ptr %slot.result, align 8
  %r99.p = getelementptr inbounds [13 x i8], ptr @.str.173, i64 0, i64 0
  %r99 = ptrtoint ptr %r99.p to i64
  %r100 = call i64 @nova_rt_str_concat(i64 %r98, i64 %r99)
  %r101 = load i64, ptr %slot.then_r, align 8
  %r102 = call i64 @nova_rt_str_concat(i64 %r100, i64 %r101)
  %r103.p = getelementptr inbounds [4 x i8], ptr @.str.168, i64 0, i64 0
  %r103 = ptrtoint ptr %r103.p to i64
  %r104 = call i64 @nova_rt_str_concat(i64 %r102, i64 %r103)
  %r105 = load i64, ptr %slot.lbl_then_done, align 8
  %r106 = call i64 @nova_rt_str_concat(i64 %r104, i64 %r105)
  %r107.p = getelementptr inbounds [5 x i8], ptr @.str.167, i64 0, i64 0
  %r107 = ptrtoint ptr %r107.p to i64
  %r108 = call i64 @nova_rt_str_concat(i64 %r106, i64 %r107)
  %r109 = load i64, ptr %slot.else_r, align 8
  %r110 = call i64 @nova_rt_str_concat(i64 %r108, i64 %r109)
  %r111.p = getelementptr inbounds [4 x i8], ptr @.str.168, i64 0, i64 0
  %r111 = ptrtoint ptr %r111.p to i64
  %r112 = call i64 @nova_rt_str_concat(i64 %r110, i64 %r111)
  %r113 = load i64, ptr %slot.lbl_else_done, align 8
  %r114 = call i64 @nova_rt_str_concat(i64 %r112, i64 %r113)
  %r115.p = getelementptr inbounds [2 x i8], ptr @.str.62, i64 0, i64 0
  %r115 = ptrtoint ptr %r115.p to i64
  %r116 = call i64 @nova_rt_str_concat(i64 %r114, i64 %r115)
  %r117 = call i64 @emit_indent(i64 %r97, i64 %r116)
  %r118 = load i64, ptr %slot.result, align 8
  ret i64 0
}

define i64 @codegen_stmt(i64 %p0, i64 %p1) nounwind {
entry:
  %slot.cg = alloca i64, align 8
  store i64 %p0, ptr %slot.cg, align 8
  %slot.stmt = alloca i64, align 8
  store i64 %p1, ptr %slot.stmt, align 8
  ret i64 0
}

define i64 @codegen_assign_target(i64 %p0, i64 %p1, i64 %p2) nounwind {
entry:
  %slot.cg = alloca i64, align 8
  store i64 %p0, ptr %slot.cg, align 8
  %slot.target = alloca i64, align 8
  store i64 %p1, ptr %slot.target, align 8
  %slot.val_reg = alloca i64, align 8
  store i64 %p2, ptr %slot.val_reg, align 8
  ret i64 0
}

define i64 @codegen_if_stmt(i64 %p0, i64 %p1) nounwind {
entry:
  %slot.cg = alloca i64, align 8
  store i64 %p0, ptr %slot.cg, align 8
  %slot.stmt = alloca i64, align 8
  store i64 %p1, ptr %slot.stmt, align 8
  ret i64 0
}

define i64 @codegen_while_stmt(i64 %p0, i64 %p1) nounwind {
entry:
  %slot.cg = alloca i64, align 8
  store i64 %p0, ptr %slot.cg, align 8
  %slot.stmt = alloca i64, align 8
  store i64 %p1, ptr %slot.stmt, align 8
  ret i64 0
}

define i64 @codegen_for_stmt(i64 %p0, i64 %p1) nounwind {
entry:
  %slot.cg = alloca i64, align 8
  store i64 %p0, ptr %slot.cg, align 8
  %slot.stmt = alloca i64, align 8
  store i64 %p1, ptr %slot.stmt, align 8
  ret i64 0
}

define i64 @codegen_match_stmt(i64 %p0, i64 %p1) nounwind {
entry:
  %slot.cg = alloca i64, align 8
  store i64 %p0, ptr %slot.cg, align 8
  %slot.stmt = alloca i64, align 8
  store i64 %p1, ptr %slot.stmt, align 8
  ret i64 0
}

define i64 @resolve_runtime_fn(i64 %p0) nounwind {
entry:
  %slot.name = alloca i64, align 8
  store i64 %p0, ptr %slot.name, align 8
  %r0 = load i64, ptr %slot.name, align 8
  %r1.p = getelementptr inbounds [6 x i8], ptr @.str.194, i64 0, i64 0
  %r1 = ptrtoint ptr %r1.p to i64
  %r2 = call i64 @nova_rt_eq(i64 %r0, i64 %r1)
  %br_then567 = icmp ne i64 %r2, 0
  br i1 %br_then567, label %then567, label %else568
then567:
  %r3.p = getelementptr inbounds [18 x i8], ptr @.str.195, i64 0, i64 0
  %r3 = ptrtoint ptr %r3.p to i64
  br label %endif569
else568:
  %r4 = load i64, ptr %slot.name, align 8
  %r5.p = getelementptr inbounds [4 x i8], ptr @.str.196, i64 0, i64 0
  %r5 = ptrtoint ptr %r5.p to i64
  %r6 = call i64 @nova_rt_eq(i64 %r4, i64 %r5)
  %br_then570 = icmp ne i64 %r6, 0
  br i1 %br_then570, label %then570, label %else571
then570:
  %r7.p = getelementptr inbounds [16 x i8], ptr @.str.197, i64 0, i64 0
  %r7 = ptrtoint ptr %r7.p to i64
  br label %endif572
else571:
  %r8 = load i64, ptr %slot.name, align 8
  %r9.p = getelementptr inbounds [4 x i8], ptr @.str.115, i64 0, i64 0
  %r9 = ptrtoint ptr %r9.p to i64
  %r10 = call i64 @nova_rt_eq(i64 %r8, i64 %r9)
  %br_then573 = icmp ne i64 %r10, 0
  br i1 %br_then573, label %then573, label %else574
then573:
  %r11.p = getelementptr inbounds [19 x i8], ptr @.str.198, i64 0, i64 0
  %r11 = ptrtoint ptr %r11.p to i64
  br label %endif575
else574:
  %r12 = load i64, ptr %slot.name, align 8
  %r13.p = getelementptr inbounds [4 x i8], ptr @.str.113, i64 0, i64 0
  %r13 = ptrtoint ptr %r13.p to i64
  %r14 = call i64 @nova_rt_eq(i64 %r12, i64 %r13)
  %br_then576 = icmp ne i64 %r14, 0
  br i1 %br_then576, label %then576, label %else577
then576:
  %r15.p = getelementptr inbounds [18 x i8], ptr @.str.199, i64 0, i64 0
  %r15 = ptrtoint ptr %r15.p to i64
  br label %endif578
else577:
  %r16 = load i64, ptr %slot.name, align 8
  %r17.p = getelementptr inbounds [5 x i8], ptr @.str.200, i64 0, i64 0
  %r17 = ptrtoint ptr %r17.p to i64
  %r18 = call i64 @nova_rt_eq(i64 %r16, i64 %r17)
  %br_then579 = icmp ne i64 %r18, 0
  br i1 %br_then579, label %then579, label %else580
then579:
  %r19.p = getelementptr inbounds [20 x i8], ptr @.str.201, i64 0, i64 0
  %r19 = ptrtoint ptr %r19.p to i64
  br label %endif581
else580:
  %r20 = load i64, ptr %slot.name, align 8
  %r21.p = getelementptr inbounds [4 x i8], ptr @.str.202, i64 0, i64 0
  %r21 = ptrtoint ptr %r21.p to i64
  %r22 = call i64 @nova_rt_eq(i64 %r20, i64 %r21)
  %br_then582 = icmp ne i64 %r22, 0
  br i1 %br_then582, label %then582, label %else583
then582:
  %r23.p = getelementptr inbounds [12 x i8], ptr @.str.203, i64 0, i64 0
  %r23 = ptrtoint ptr %r23.p to i64
  br label %endif584
else583:
  %r24 = load i64, ptr %slot.name, align 8
  %r25.p = getelementptr inbounds [4 x i8], ptr @.str.204, i64 0, i64 0
  %r25 = ptrtoint ptr %r25.p to i64
  %r26 = call i64 @nova_rt_eq(i64 %r24, i64 %r25)
  %br_then585 = icmp ne i64 %r26, 0
  br i1 %br_then585, label %then585, label %else586
then585:
  %r27.p = getelementptr inbounds [12 x i8], ptr @.str.205, i64 0, i64 0
  %r27 = ptrtoint ptr %r27.p to i64
  br label %endif587
else586:
  %r28 = load i64, ptr %slot.name, align 8
  %r29.p = getelementptr inbounds [7 x i8], ptr @.str.206, i64 0, i64 0
  %r29 = ptrtoint ptr %r29.p to i64
  %r30 = call i64 @nova_rt_eq(i64 %r28, i64 %r29)
  %br_then588 = icmp ne i64 %r30, 0
  br i1 %br_then588, label %then588, label %else589
then588:
  %r31.p = getelementptr inbounds [15 x i8], ptr @.str.207, i64 0, i64 0
  %r31 = ptrtoint ptr %r31.p to i64
  br label %endif590
else589:
  %r32 = load i64, ptr %slot.name, align 8
  %r33.p = getelementptr inbounds [9 x i8], ptr @.str.208, i64 0, i64 0
  %r33 = ptrtoint ptr %r33.p to i64
  %r34 = call i64 @nova_rt_eq(i64 %r32, i64 %r33)
  %br_then591 = icmp ne i64 %r34, 0
  br i1 %br_then591, label %then591, label %else592
then591:
  %r35.p = getelementptr inbounds [17 x i8], ptr @.str.209, i64 0, i64 0
  %r35 = ptrtoint ptr %r35.p to i64
  br label %endif593
else592:
  %r36 = load i64, ptr %slot.name, align 8
  %r37.p = getelementptr inbounds [10 x i8], ptr @.str.210, i64 0, i64 0
  %r37 = ptrtoint ptr %r37.p to i64
  %r38 = call i64 @nova_rt_eq(i64 %r36, i64 %r37)
  %br_then594 = icmp ne i64 %r38, 0
  br i1 %br_then594, label %then594, label %else595
then594:
  %r39.p = getelementptr inbounds [18 x i8], ptr @.str.211, i64 0, i64 0
  %r39 = ptrtoint ptr %r39.p to i64
  br label %endif596
else595:
  %r40 = load i64, ptr %slot.name, align 8
  %r41.p = getelementptr inbounds [11 x i8], ptr @.str.212, i64 0, i64 0
  %r41 = ptrtoint ptr %r41.p to i64
  %r42 = call i64 @nova_rt_eq(i64 %r40, i64 %r41)
  %br_then597 = icmp ne i64 %r42, 0
  br i1 %br_then597, label %then597, label %else598
then597:
  %r43.p = getelementptr inbounds [19 x i8], ptr @.str.213, i64 0, i64 0
  %r43 = ptrtoint ptr %r43.p to i64
  br label %endif599
else598:
  %r44 = load i64, ptr %slot.name, align 8
  %r45.p = getelementptr inbounds [5 x i8], ptr @.str.214, i64 0, i64 0
  %r45 = ptrtoint ptr %r45.p to i64
  %r46 = call i64 @nova_rt_eq(i64 %r44, i64 %r45)
  %br_then600 = icmp ne i64 %r46, 0
  br i1 %br_then600, label %then600, label %else601
then600:
  %r47.p = getelementptr inbounds [13 x i8], ptr @.str.215, i64 0, i64 0
  %r47 = ptrtoint ptr %r47.p to i64
  br label %endif602
else601:
  %r48 = load i64, ptr %slot.name, align 8
  %r49.p = getelementptr inbounds [5 x i8], ptr @.str.216, i64 0, i64 0
  %r49 = ptrtoint ptr %r49.p to i64
  %r50 = call i64 @nova_rt_eq(i64 %r48, i64 %r49)
  %br_then603 = icmp ne i64 %r50, 0
  br i1 %br_then603, label %then603, label %else604
then603:
  %r51.p = getelementptr inbounds [13 x i8], ptr @.str.217, i64 0, i64 0
  %r51 = ptrtoint ptr %r51.p to i64
  br label %endif605
else604:
  %r52 = load i64, ptr %slot.name, align 8
  %r53.p = getelementptr inbounds [6 x i8], ptr @.str.218, i64 0, i64 0
  %r53 = ptrtoint ptr %r53.p to i64
  %r54 = call i64 @nova_rt_eq(i64 %r52, i64 %r53)
  %br_then606 = icmp ne i64 %r54, 0
  br i1 %br_then606, label %then606, label %else607
then606:
  %r55.p = getelementptr inbounds [14 x i8], ptr @.str.219, i64 0, i64 0
  %r55 = ptrtoint ptr %r55.p to i64
  br label %endif608
else607:
  %r56 = load i64, ptr %slot.name, align 8
  %r57.p = getelementptr inbounds [5 x i8], ptr @.str.220, i64 0, i64 0
  %r57 = ptrtoint ptr %r57.p to i64
  %r58 = call i64 @nova_rt_eq(i64 %r56, i64 %r57)
  %br_then609 = icmp ne i64 %r58, 0
  br i1 %br_then609, label %then609, label %else610
then609:
  %r59.p = getelementptr inbounds [13 x i8], ptr @.str.221, i64 0, i64 0
  %r59 = ptrtoint ptr %r59.p to i64
  br label %endif611
else610:
  %r60 = load i64, ptr %slot.name, align 8
  %r61.p = getelementptr inbounds [6 x i8], ptr @.str.222, i64 0, i64 0
  %r61 = ptrtoint ptr %r61.p to i64
  %r62 = call i64 @nova_rt_eq(i64 %r60, i64 %r61)
  %br_then612 = icmp ne i64 %r62, 0
  br i1 %br_then612, label %then612, label %else613
then612:
  %r63.p = getelementptr inbounds [14 x i8], ptr @.str.223, i64 0, i64 0
  %r63 = ptrtoint ptr %r63.p to i64
  br label %endif614
else613:
  %r64 = load i64, ptr %slot.name, align 8
  %r65.p = getelementptr inbounds [6 x i8], ptr @.str.224, i64 0, i64 0
  %r65 = ptrtoint ptr %r65.p to i64
  %r66 = call i64 @nova_rt_eq(i64 %r64, i64 %r65)
  %br_then615 = icmp ne i64 %r66, 0
  br i1 %br_then615, label %then615, label %else616
then615:
  %r67.p = getelementptr inbounds [14 x i8], ptr @.str.225, i64 0, i64 0
  %r67 = ptrtoint ptr %r67.p to i64
  br label %endif617
else616:
  %r68 = load i64, ptr %slot.name, align 8
  %r69.p = getelementptr inbounds [5 x i8], ptr @.str.226, i64 0, i64 0
  %r69 = ptrtoint ptr %r69.p to i64
  %r70 = call i64 @nova_rt_eq(i64 %r68, i64 %r69)
  %br_then618 = icmp ne i64 %r70, 0
  br i1 %br_then618, label %then618, label %else619
then618:
  %r71.p = getelementptr inbounds [13 x i8], ptr @.str.227, i64 0, i64 0
  %r71 = ptrtoint ptr %r71.p to i64
  br label %endif620
else619:
  %r72 = load i64, ptr %slot.name, align 8
  %r73.p = getelementptr inbounds [8 x i8], ptr @.str.228, i64 0, i64 0
  %r73 = ptrtoint ptr %r73.p to i64
  %r74 = call i64 @nova_rt_eq(i64 %r72, i64 %r73)
  %br_then621 = icmp ne i64 %r74, 0
  br i1 %br_then621, label %then621, label %else622
then621:
  %r75.p = getelementptr inbounds [16 x i8], ptr @.str.229, i64 0, i64 0
  %r75 = ptrtoint ptr %r75.p to i64
  br label %endif623
else622:
  %r76 = load i64, ptr %slot.name, align 8
  %r77.p = getelementptr inbounds [12 x i8], ptr @.str.230, i64 0, i64 0
  %r77 = ptrtoint ptr %r77.p to i64
  %r78 = call i64 @nova_rt_eq(i64 %r76, i64 %r77)
  %br_then624 = icmp ne i64 %r78, 0
  br i1 %br_then624, label %then624, label %else625
then624:
  %r79.p = getelementptr inbounds [20 x i8], ptr @.str.231, i64 0, i64 0
  %r79 = ptrtoint ptr %r79.p to i64
  br label %endif626
else625:
  %r80 = load i64, ptr %slot.name, align 8
  %r81.p = getelementptr inbounds [10 x i8], ptr @.str.232, i64 0, i64 0
  %r81 = ptrtoint ptr %r81.p to i64
  %r82 = call i64 @nova_rt_eq(i64 %r80, i64 %r81)
  %br_then627 = icmp ne i64 %r82, 0
  br i1 %br_then627, label %then627, label %else628
then627:
  %r83.p = getelementptr inbounds [18 x i8], ptr @.str.233, i64 0, i64 0
  %r83 = ptrtoint ptr %r83.p to i64
  br label %endif629
else628:
  %r84 = load i64, ptr %slot.name, align 8
  %r85.p = getelementptr inbounds [7 x i8], ptr @.str.234, i64 0, i64 0
  %r85 = ptrtoint ptr %r85.p to i64
  %r86 = call i64 @nova_rt_eq(i64 %r84, i64 %r85)
  %br_then630 = icmp ne i64 %r86, 0
  br i1 %br_then630, label %then630, label %else631
then630:
  %r87.p = getelementptr inbounds [20 x i8], ptr @.str.235, i64 0, i64 0
  %r87 = ptrtoint ptr %r87.p to i64
  br label %endif632
else631:
  %r88 = load i64, ptr %slot.name, align 8
  %r89.p = getelementptr inbounds [4 x i8], ptr @.str.236, i64 0, i64 0
  %r89 = ptrtoint ptr %r89.p to i64
  %r90 = call i64 @nova_rt_eq(i64 %r88, i64 %r89)
  %br_then633 = icmp ne i64 %r90, 0
  br i1 %br_then633, label %then633, label %else634
then633:
  %r91.p = getelementptr inbounds [17 x i8], ptr @.str.237, i64 0, i64 0
  %r91 = ptrtoint ptr %r91.p to i64
  br label %endif635
else634:
  %r92 = load i64, ptr %slot.name, align 8
  %r93.p = getelementptr inbounds [11 x i8], ptr @.str.238, i64 0, i64 0
  %r93 = ptrtoint ptr %r93.p to i64
  %r94 = call i64 @nova_rt_eq(i64 %r92, i64 %r93)
  %br_then636 = icmp ne i64 %r94, 0
  br i1 %br_then636, label %then636, label %else637
then636:
  %r95.p = getelementptr inbounds [19 x i8], ptr @.str.239, i64 0, i64 0
  %r95 = ptrtoint ptr %r95.p to i64
  br label %endif638
else637:
  %r96 = load i64, ptr %slot.name, align 8
  %r97.p = getelementptr inbounds [6 x i8], ptr @.str.240, i64 0, i64 0
  %r97 = ptrtoint ptr %r97.p to i64
  %r98 = call i64 @nova_rt_eq(i64 %r96, i64 %r97)
  %br_then639 = icmp ne i64 %r98, 0
  br i1 %br_then639, label %then639, label %else640
then639:
  %r99.p = getelementptr inbounds [14 x i8], ptr @.str.241, i64 0, i64 0
  %r99 = ptrtoint ptr %r99.p to i64
  br label %endif641
else640:
  %r100 = load i64, ptr %slot.name, align 8
  %r101.p = getelementptr inbounds [7 x i8], ptr @.str.242, i64 0, i64 0
  %r101 = ptrtoint ptr %r101.p to i64
  %r102 = call i64 @nova_rt_eq(i64 %r100, i64 %r101)
  %br_then642 = icmp ne i64 %r102, 0
  br i1 %br_then642, label %then642, label %else643
then642:
  %r103.p = getelementptr inbounds [15 x i8], ptr @.str.243, i64 0, i64 0
  %r103 = ptrtoint ptr %r103.p to i64
  br label %endif644
else643:
  %r104 = load i64, ptr %slot.name, align 8
  %r105.p = getelementptr inbounds [6 x i8], ptr @.str.244, i64 0, i64 0
  %r105 = ptrtoint ptr %r105.p to i64
  %r106 = call i64 @nova_rt_eq(i64 %r104, i64 %r105)
  %br_then645 = icmp ne i64 %r106, 0
  br i1 %br_then645, label %then645, label %else646
then645:
  %r107.p = getelementptr inbounds [14 x i8], ptr @.str.245, i64 0, i64 0
  %r107 = ptrtoint ptr %r107.p to i64
  br label %endif647
else646:
  %r108 = load i64, ptr %slot.name, align 8
  %r109.p = getelementptr inbounds [8 x i8], ptr @.str.246, i64 0, i64 0
  %r109 = ptrtoint ptr %r109.p to i64
  %r110 = call i64 @nova_rt_eq(i64 %r108, i64 %r109)
  %br_then648 = icmp ne i64 %r110, 0
  br i1 %br_then648, label %then648, label %else649
then648:
  %r111.p = getelementptr inbounds [16 x i8], ptr @.str.247, i64 0, i64 0
  %r111 = ptrtoint ptr %r111.p to i64
  br label %endif650
else649:
  %r112 = load i64, ptr %slot.name, align 8
  %r113.p = getelementptr inbounds [6 x i8], ptr @.str.248, i64 0, i64 0
  %r113 = ptrtoint ptr %r113.p to i64
  %r114 = call i64 @nova_rt_eq(i64 %r112, i64 %r113)
  %br_then651 = icmp ne i64 %r114, 0
  br i1 %br_then651, label %then651, label %else652
then651:
  %r115.p = getelementptr inbounds [17 x i8], ptr @.str.249, i64 0, i64 0
  %r115 = ptrtoint ptr %r115.p to i64
  br label %endif653
else652:
  %r116 = load i64, ptr %slot.name, align 8
  %r117.p = getelementptr inbounds [9 x i8], ptr @.str.250, i64 0, i64 0
  %r117 = ptrtoint ptr %r117.p to i64
  %r118 = call i64 @nova_rt_eq(i64 %r116, i64 %r117)
  %br_then654 = icmp ne i64 %r118, 0
  br i1 %br_then654, label %then654, label %else655
then654:
  %r119.p = getelementptr inbounds [17 x i8], ptr @.str.251, i64 0, i64 0
  %r119 = ptrtoint ptr %r119.p to i64
  br label %endif656
else655:
  %r120 = load i64, ptr %slot.name, align 8
  %r121.p = getelementptr inbounds [8 x i8], ptr @.str.252, i64 0, i64 0
  %r121 = ptrtoint ptr %r121.p to i64
  %r122 = call i64 @nova_rt_eq(i64 %r120, i64 %r121)
  %br_then657 = icmp ne i64 %r122, 0
  br i1 %br_then657, label %then657, label %else658
then657:
  %r123.p = getelementptr inbounds [16 x i8], ptr @.str.253, i64 0, i64 0
  %r123 = ptrtoint ptr %r123.p to i64
  br label %endif659
else658:
  %r124 = load i64, ptr %slot.name, align 8
  %r125.p = getelementptr inbounds [6 x i8], ptr @.str.254, i64 0, i64 0
  %r125 = ptrtoint ptr %r125.p to i64
  %r126 = call i64 @nova_rt_eq(i64 %r124, i64 %r125)
  %br_then660 = icmp ne i64 %r126, 0
  br i1 %br_then660, label %then660, label %else661
then660:
  %r127.p = getelementptr inbounds [14 x i8], ptr @.str.255, i64 0, i64 0
  %r127 = ptrtoint ptr %r127.p to i64
  br label %endif662
else661:
  %r128 = load i64, ptr %slot.name, align 8
  %r129.p = getelementptr inbounds [5 x i8], ptr @.str.256, i64 0, i64 0
  %r129 = ptrtoint ptr %r129.p to i64
  %r130 = call i64 @nova_rt_eq(i64 %r128, i64 %r129)
  %br_then663 = icmp ne i64 %r130, 0
  br i1 %br_then663, label %then663, label %else664
then663:
  %r131.p = getelementptr inbounds [13 x i8], ptr @.str.257, i64 0, i64 0
  %r131 = ptrtoint ptr %r131.p to i64
  br label %endif665
else664:
  %r132 = load i64, ptr %slot.name, align 8
  %r133.p = getelementptr inbounds [5 x i8], ptr @.str.258, i64 0, i64 0
  %r133 = ptrtoint ptr %r133.p to i64
  %r134 = call i64 @nova_rt_eq(i64 %r132, i64 %r133)
  %br_then666 = icmp ne i64 %r134, 0
  br i1 %br_then666, label %then666, label %else667
then666:
  %r135.p = getelementptr inbounds [18 x i8], ptr @.str.259, i64 0, i64 0
  %r135 = ptrtoint ptr %r135.p to i64
  br label %endif668
else667:
  %r136 = load i64, ptr %slot.name, align 8
  %r137.p = getelementptr inbounds [7 x i8], ptr @.str.260, i64 0, i64 0
  %r137 = ptrtoint ptr %r137.p to i64
  %r138 = call i64 @nova_rt_eq(i64 %r136, i64 %r137)
  %br_then669 = icmp ne i64 %r138, 0
  br i1 %br_then669, label %then669, label %else670
then669:
  %r139.p = getelementptr inbounds [20 x i8], ptr @.str.261, i64 0, i64 0
  %r139 = ptrtoint ptr %r139.p to i64
  br label %endif671
else670:
  %r140 = load i64, ptr %slot.name, align 8
  br label %endif671
endif671:
  br label %endif668
endif668:
  br label %endif665
endif665:
  br label %endif662
endif662:
  br label %endif659
endif659:
  br label %endif656
endif656:
  br label %endif653
endif653:
  br label %endif650
endif650:
  br label %endif647
endif647:
  br label %endif644
endif644:
  br label %endif641
endif641:
  br label %endif638
endif638:
  br label %endif635
endif635:
  br label %endif632
endif632:
  br label %endif629
endif629:
  br label %endif626
endif626:
  br label %endif623
endif623:
  br label %endif620
endif620:
  br label %endif617
endif617:
  br label %endif614
endif614:
  br label %endif611
endif611:
  br label %endif608
endif608:
  br label %endif605
endif605:
  br label %endif602
endif602:
  br label %endif599
endif599:
  br label %endif596
endif596:
  br label %endif593
endif593:
  br label %endif590
endif590:
  br label %endif587
endif587:
  br label %endif584
endif584:
  br label %endif581
endif581:
  br label %endif578
endif578:
  br label %endif575
endif575:
  br label %endif572
endif572:
  br label %endif569
endif569:
  ret i64 0
}

define i64 @resolve_method_fn(i64 %p0) nounwind {
entry:
  %slot.name = alloca i64, align 8
  store i64 %p0, ptr %slot.name, align 8
  %r0.p = getelementptr inbounds [9 x i8], ptr @.str.262, i64 0, i64 0
  %r0 = ptrtoint ptr %r0.p to i64
  %r1 = load i64, ptr %slot.name, align 8
  %r2 = call i64 @nova_rt_str_concat(i64 %r0, i64 %r1)
  ret i64 0
}

define i64 @get_field_index(i64 %p0, i64 %p1) nounwind {
entry:
  %slot.cg = alloca i64, align 8
  store i64 %p0, ptr %slot.cg, align 8
  %slot.field_name = alloca i64, align 8
  store i64 %p1, ptr %slot.field_name, align 8
  %r0 = add i64 0, 0
  %r1 = load i64, ptr %slot.field_name, align 8
  %r2 = call i64 @nova_rt_contains(i64 %r0, i64 %r1)
  %br_then672 = icmp ne i64 %r2, 0
  br i1 %br_then672, label %then672, label %else673
then672:
  %r3 = add i64 0, 0
  %r4 = load i64, ptr %slot.field_name, align 8
  %r5 = call i64 @nova_rt_index_get(i64 %r3, i64 %r4)
  ret i64 %r5
else673:
  br label %endif674
endif674:
  %r6 = add i64 0, 0
  ret i64 %r6
}

define i64 @emit_module_header(i64 %p0) nounwind {
entry:
  %slot.cg = alloca i64, align 8
  store i64 %p0, ptr %slot.cg, align 8
  %r0 = load i64, ptr %slot.cg, align 8
  %r1.p = getelementptr inbounds [35 x i8], ptr @.str.263, i64 0, i64 0
  %r1 = ptrtoint ptr %r1.p to i64
  %r2 = call i64 @emit(i64 %r0, i64 %r1)
  %r3 = load i64, ptr %slot.cg, align 8
  %r4.p = getelementptr inbounds [102 x i8], ptr @.str.264, i64 0, i64 0
  %r4 = ptrtoint ptr %r4.p to i64
  %r5 = call i64 @emit(i64 %r3, i64 %r4)
  %r6 = load i64, ptr %slot.cg, align 8
  %r7.p = getelementptr inbounds [1 x i8], ptr @.str.42, i64 0, i64 0
  %r7 = ptrtoint ptr %r7.p to i64
  %r8 = call i64 @emit(i64 %r6, i64 %r7)
  %r9 = load i64, ptr %slot.cg, align 8
  %r10.p = getelementptr inbounds [47 x i8], ptr @.str.265, i64 0, i64 0
  %r10 = ptrtoint ptr %r10.p to i64
  %r11 = call i64 @emit(i64 %r9, i64 %r10)
  %r12 = load i64, ptr %slot.cg, align 8
  %r13.p = getelementptr inbounds [46 x i8], ptr @.str.266, i64 0, i64 0
  %r13 = ptrtoint ptr %r13.p to i64
  %r14 = call i64 @emit(i64 %r12, i64 %r13)
  %r15 = load i64, ptr %slot.cg, align 8
  %r16.p = getelementptr inbounds [1 x i8], ptr @.str.42, i64 0, i64 0
  %r16 = ptrtoint ptr %r16.p to i64
  %r17 = call i64 @emit(i64 %r15, i64 %r16)
  ret i64 0
}

define i64 @emit_runtime_declarations(i64 %p0) nounwind {
entry:
  %slot.cg = alloca i64, align 8
  store i64 %p0, ptr %slot.cg, align 8
  %r0 = load i64, ptr %slot.cg, align 8
  %r1.p = getelementptr inbounds [23 x i8], ptr @.str.267, i64 0, i64 0
  %r1 = ptrtoint ptr %r1.p to i64
  %r2 = call i64 @emit(i64 %r0, i64 %r1)
  %r3 = load i64, ptr %slot.cg, align 8
  %r4.p = getelementptr inbounds [32 x i8], ptr @.str.268, i64 0, i64 0
  %r4 = ptrtoint ptr %r4.p to i64
  %r5 = call i64 @emit(i64 %r3, i64 %r4)
  %r6 = load i64, ptr %slot.cg, align 8
  %r7.p = getelementptr inbounds [39 x i8], ptr @.str.269, i64 0, i64 0
  %r7 = ptrtoint ptr %r7.p to i64
  %r8 = call i64 @emit(i64 %r6, i64 %r7)
  %r9 = load i64, ptr %slot.cg, align 8
  %r10.p = getelementptr inbounds [44 x i8], ptr @.str.270, i64 0, i64 0
  %r10 = ptrtoint ptr %r10.p to i64
  %r11 = call i64 @emit(i64 %r9, i64 %r10)
  %r12 = load i64, ptr %slot.cg, align 8
  %r13.p = getelementptr inbounds [52 x i8], ptr @.str.271, i64 0, i64 0
  %r13 = ptrtoint ptr %r13.p to i64
  %r14 = call i64 @emit(i64 %r12, i64 %r13)
  %r15 = load i64, ptr %slot.cg, align 8
  %r16.p = getelementptr inbounds [49 x i8], ptr @.str.272, i64 0, i64 0
  %r16 = ptrtoint ptr %r16.p to i64
  %r17 = call i64 @emit(i64 %r15, i64 %r16)
  %r18 = load i64, ptr %slot.cg, align 8
  %r19.p = getelementptr inbounds [44 x i8], ptr @.str.273, i64 0, i64 0
  %r19 = ptrtoint ptr %r19.p to i64
  %r20 = call i64 @emit(i64 %r18, i64 %r19)
  %r21 = load i64, ptr %slot.cg, align 8
  %r22.p = getelementptr inbounds [44 x i8], ptr @.str.274, i64 0, i64 0
  %r22 = ptrtoint ptr %r22.p to i64
  %r23 = call i64 @emit(i64 %r21, i64 %r22)
  %r24 = load i64, ptr %slot.cg, align 8
  %r25.p = getelementptr inbounds [54 x i8], ptr @.str.275, i64 0, i64 0
  %r25 = ptrtoint ptr %r25.p to i64
  %r26 = call i64 @emit(i64 %r24, i64 %r25)
  %r27 = load i64, ptr %slot.cg, align 8
  %r28.p = getelementptr inbounds [49 x i8], ptr @.str.276, i64 0, i64 0
  %r28 = ptrtoint ptr %r28.p to i64
  %r29 = call i64 @emit(i64 %r27, i64 %r28)
  %r30 = load i64, ptr %slot.cg, align 8
  %r31.p = getelementptr inbounds [54 x i8], ptr @.str.277, i64 0, i64 0
  %r31 = ptrtoint ptr %r31.p to i64
  %r32 = call i64 @emit(i64 %r30, i64 %r31)
  %r33 = load i64, ptr %slot.cg, align 8
  %r34.p = getelementptr inbounds [51 x i8], ptr @.str.278, i64 0, i64 0
  %r34 = ptrtoint ptr %r34.p to i64
  %r35 = call i64 @emit(i64 %r33, i64 %r34)
  %r36 = load i64, ptr %slot.cg, align 8
  %r37.p = getelementptr inbounds [46 x i8], ptr @.str.279, i64 0, i64 0
  %r37 = ptrtoint ptr %r37.p to i64
  %r38 = call i64 @emit(i64 %r36, i64 %r37)
  %r39 = load i64, ptr %slot.cg, align 8
  %r40.p = getelementptr inbounds [45 x i8], ptr @.str.280, i64 0, i64 0
  %r40 = ptrtoint ptr %r40.p to i64
  %r41 = call i64 @emit(i64 %r39, i64 %r40)
  %r42 = load i64, ptr %slot.cg, align 8
  %r43.p = getelementptr inbounds [39 x i8], ptr @.str.281, i64 0, i64 0
  %r43 = ptrtoint ptr %r43.p to i64
  %r44 = call i64 @emit(i64 %r42, i64 %r43)
  %r45 = load i64, ptr %slot.cg, align 8
  %r46.p = getelementptr inbounds [43 x i8], ptr @.str.282, i64 0, i64 0
  %r46 = ptrtoint ptr %r46.p to i64
  %r47 = call i64 @emit(i64 %r45, i64 %r46)
  %r48 = load i64, ptr %slot.cg, align 8
  %r49.p = getelementptr inbounds [39 x i8], ptr @.str.283, i64 0, i64 0
  %r49 = ptrtoint ptr %r49.p to i64
  %r50 = call i64 @emit(i64 %r48, i64 %r49)
  %r51 = load i64, ptr %slot.cg, align 8
  %r52.p = getelementptr inbounds [39 x i8], ptr @.str.284, i64 0, i64 0
  %r52 = ptrtoint ptr %r52.p to i64
  %r53 = call i64 @emit(i64 %r51, i64 %r52)
  %r54 = load i64, ptr %slot.cg, align 8
  %r55.p = getelementptr inbounds [49 x i8], ptr @.str.285, i64 0, i64 0
  %r55 = ptrtoint ptr %r55.p to i64
  %r56 = call i64 @emit(i64 %r54, i64 %r55)
  %r57 = load i64, ptr %slot.cg, align 8
  %r58.p = getelementptr inbounds [50 x i8], ptr @.str.286, i64 0, i64 0
  %r58 = ptrtoint ptr %r58.p to i64
  %r59 = call i64 @emit(i64 %r57, i64 %r58)
  %r60 = load i64, ptr %slot.cg, align 8
  %r61.p = getelementptr inbounds [55 x i8], ptr @.str.287, i64 0, i64 0
  %r61 = ptrtoint ptr %r61.p to i64
  %r62 = call i64 @emit(i64 %r60, i64 %r61)
  %r63 = load i64, ptr %slot.cg, align 8
  %r64.p = getelementptr inbounds [44 x i8], ptr @.str.288, i64 0, i64 0
  %r64 = ptrtoint ptr %r64.p to i64
  %r65 = call i64 @emit(i64 %r63, i64 %r64)
  %r66 = load i64, ptr %slot.cg, align 8
  %r67.p = getelementptr inbounds [43 x i8], ptr @.str.289, i64 0, i64 0
  %r67 = ptrtoint ptr %r67.p to i64
  %r68 = call i64 @emit(i64 %r66, i64 %r67)
  %r69 = load i64, ptr %slot.cg, align 8
  %r70.p = getelementptr inbounds [44 x i8], ptr @.str.290, i64 0, i64 0
  %r70 = ptrtoint ptr %r70.p to i64
  %r71 = call i64 @emit(i64 %r69, i64 %r70)
  %r72 = load i64, ptr %slot.cg, align 8
  %r73.p = getelementptr inbounds [46 x i8], ptr @.str.291, i64 0, i64 0
  %r73 = ptrtoint ptr %r73.p to i64
  %r74 = call i64 @emit(i64 %r72, i64 %r73)
  %r75 = load i64, ptr %slot.cg, align 8
  %r76.p = getelementptr inbounds [48 x i8], ptr @.str.292, i64 0, i64 0
  %r76 = ptrtoint ptr %r76.p to i64
  %r77 = call i64 @emit(i64 %r75, i64 %r76)
  %r78 = load i64, ptr %slot.cg, align 8
  %r79.p = getelementptr inbounds [45 x i8], ptr @.str.293, i64 0, i64 0
  %r79 = ptrtoint ptr %r79.p to i64
  %r80 = call i64 @emit(i64 %r78, i64 %r79)
  %r81 = load i64, ptr %slot.cg, align 8
  %r82.p = getelementptr inbounds [51 x i8], ptr @.str.294, i64 0, i64 0
  %r82 = ptrtoint ptr %r82.p to i64
  %r83 = call i64 @emit(i64 %r81, i64 %r82)
  %r84 = load i64, ptr %slot.cg, align 8
  %r85.p = getelementptr inbounds [37 x i8], ptr @.str.295, i64 0, i64 0
  %r85 = ptrtoint ptr %r85.p to i64
  %r86 = call i64 @emit(i64 %r84, i64 %r85)
  %r87 = load i64, ptr %slot.cg, align 8
  %r88.p = getelementptr inbounds [41 x i8], ptr @.str.296, i64 0, i64 0
  %r88 = ptrtoint ptr %r88.p to i64
  %r89 = call i64 @emit(i64 %r87, i64 %r88)
  %r90 = load i64, ptr %slot.cg, align 8
  %r91.p = getelementptr inbounds [46 x i8], ptr @.str.297, i64 0, i64 0
  %r91 = ptrtoint ptr %r91.p to i64
  %r92 = call i64 @emit(i64 %r90, i64 %r91)
  %r93 = load i64, ptr %slot.cg, align 8
  %r94.p = getelementptr inbounds [45 x i8], ptr @.str.298, i64 0, i64 0
  %r94 = ptrtoint ptr %r94.p to i64
  %r95 = call i64 @emit(i64 %r93, i64 %r94)
  %r96 = load i64, ptr %slot.cg, align 8
  %r97.p = getelementptr inbounds [41 x i8], ptr @.str.299, i64 0, i64 0
  %r97 = ptrtoint ptr %r97.p to i64
  %r98 = call i64 @emit(i64 %r96, i64 %r97)
  %r99 = load i64, ptr %slot.cg, align 8
  %r100.p = getelementptr inbounds [41 x i8], ptr @.str.300, i64 0, i64 0
  %r100 = ptrtoint ptr %r100.p to i64
  %r101 = call i64 @emit(i64 %r99, i64 %r100)
  %r102 = load i64, ptr %slot.cg, align 8
  %r103.p = getelementptr inbounds [40 x i8], ptr @.str.301, i64 0, i64 0
  %r103 = ptrtoint ptr %r103.p to i64
  %r104 = call i64 @emit(i64 %r102, i64 %r103)
  %r105 = load i64, ptr %slot.cg, align 8
  %r106.p = getelementptr inbounds [53 x i8], ptr @.str.302, i64 0, i64 0
  %r106 = ptrtoint ptr %r106.p to i64
  %r107 = call i64 @emit(i64 %r105, i64 %r106)
  %r108 = load i64, ptr %slot.cg, align 8
  %r109.p = getelementptr inbounds [52 x i8], ptr @.str.303, i64 0, i64 0
  %r109 = ptrtoint ptr %r109.p to i64
  %r110 = call i64 @emit(i64 %r108, i64 %r109)
  %r111 = load i64, ptr %slot.cg, align 8
  %r112.p = getelementptr inbounds [50 x i8], ptr @.str.304, i64 0, i64 0
  %r112 = ptrtoint ptr %r112.p to i64
  %r113 = call i64 @emit(i64 %r111, i64 %r112)
  %r114 = load i64, ptr %slot.cg, align 8
  %r115.p = getelementptr inbounds [45 x i8], ptr @.str.305, i64 0, i64 0
  %r115 = ptrtoint ptr %r115.p to i64
  %r116 = call i64 @emit(i64 %r114, i64 %r115)
  %r117 = load i64, ptr %slot.cg, align 8
  %r118.p = getelementptr inbounds [46 x i8], ptr @.str.306, i64 0, i64 0
  %r118 = ptrtoint ptr %r118.p to i64
  %r119 = call i64 @emit(i64 %r117, i64 %r118)
  %r120 = load i64, ptr %slot.cg, align 8
  %r121.p = getelementptr inbounds [48 x i8], ptr @.str.307, i64 0, i64 0
  %r121 = ptrtoint ptr %r121.p to i64
  %r122 = call i64 @emit(i64 %r120, i64 %r121)
  %r123 = load i64, ptr %slot.cg, align 8
  %r124.p = getelementptr inbounds [51 x i8], ptr @.str.308, i64 0, i64 0
  %r124 = ptrtoint ptr %r124.p to i64
  %r125 = call i64 @emit(i64 %r123, i64 %r124)
  %r126 = load i64, ptr %slot.cg, align 8
  %r127.p = getelementptr inbounds [47 x i8], ptr @.str.309, i64 0, i64 0
  %r127 = ptrtoint ptr %r127.p to i64
  %r128 = call i64 @emit(i64 %r126, i64 %r127)
  %r129 = load i64, ptr %slot.cg, align 8
  %r130.p = getelementptr inbounds [41 x i8], ptr @.str.310, i64 0, i64 0
  %r130 = ptrtoint ptr %r130.p to i64
  %r131 = call i64 @emit(i64 %r129, i64 %r130)
  %r132 = load i64, ptr %slot.cg, align 8
  %r133.p = getelementptr inbounds [40 x i8], ptr @.str.311, i64 0, i64 0
  %r133 = ptrtoint ptr %r133.p to i64
  %r134 = call i64 @emit(i64 %r132, i64 %r133)
  %r135 = load i64, ptr %slot.cg, align 8
  %r136.p = getelementptr inbounds [44 x i8], ptr @.str.312, i64 0, i64 0
  %r136 = ptrtoint ptr %r136.p to i64
  %r137 = call i64 @emit(i64 %r135, i64 %r136)
  %r138 = load i64, ptr %slot.cg, align 8
  %r139.p = getelementptr inbounds [41 x i8], ptr @.str.313, i64 0, i64 0
  %r139 = ptrtoint ptr %r139.p to i64
  %r140 = call i64 @emit(i64 %r138, i64 %r139)
  %r141 = load i64, ptr %slot.cg, align 8
  %r142.p = getelementptr inbounds [43 x i8], ptr @.str.314, i64 0, i64 0
  %r142 = ptrtoint ptr %r142.p to i64
  %r143 = call i64 @emit(i64 %r141, i64 %r142)
  %r144 = load i64, ptr %slot.cg, align 8
  %r145.p = getelementptr inbounds [46 x i8], ptr @.str.315, i64 0, i64 0
  %r145 = ptrtoint ptr %r145.p to i64
  %r146 = call i64 @emit(i64 %r144, i64 %r145)
  %r147 = load i64, ptr %slot.cg, align 8
  %r148.p = getelementptr inbounds [40 x i8], ptr @.str.316, i64 0, i64 0
  %r148 = ptrtoint ptr %r148.p to i64
  %r149 = call i64 @emit(i64 %r147, i64 %r148)
  %r150 = load i64, ptr %slot.cg, align 8
  %r151.p = getelementptr inbounds [45 x i8], ptr @.str.317, i64 0, i64 0
  %r151 = ptrtoint ptr %r151.p to i64
  %r152 = call i64 @emit(i64 %r150, i64 %r151)
  %r153 = load i64, ptr %slot.cg, align 8
  %r154.p = getelementptr inbounds [47 x i8], ptr @.str.318, i64 0, i64 0
  %r154 = ptrtoint ptr %r154.p to i64
  %r155 = call i64 @emit(i64 %r153, i64 %r154)
  %r156 = load i64, ptr %slot.cg, align 8
  %r157.p = getelementptr inbounds [49 x i8], ptr @.str.319, i64 0, i64 0
  %r157 = ptrtoint ptr %r157.p to i64
  %r158 = call i64 @emit(i64 %r156, i64 %r157)
  %r159 = load i64, ptr %slot.cg, align 8
  %r160.p = getelementptr inbounds [51 x i8], ptr @.str.320, i64 0, i64 0
  %r160 = ptrtoint ptr %r160.p to i64
  %r161 = call i64 @emit(i64 %r159, i64 %r160)
  %r162 = load i64, ptr %slot.cg, align 8
  %r163.p = getelementptr inbounds [41 x i8], ptr @.str.321, i64 0, i64 0
  %r163 = ptrtoint ptr %r163.p to i64
  %r164 = call i64 @emit(i64 %r162, i64 %r163)
  %r165 = load i64, ptr %slot.cg, align 8
  %r166.p = getelementptr inbounds [1 x i8], ptr @.str.42, i64 0, i64 0
  %r166 = ptrtoint ptr %r166.p to i64
  %r167 = call i64 @emit(i64 %r165, i64 %r166)
  ret i64 0
}

define i64 @emit_string_constants(i64 %p0) nounwind {
entry:
  %slot.cg = alloca i64, align 8
  store i64 %p0, ptr %slot.cg, align 8
  %slot.i = alloca i64, align 8
  store i64 0, ptr %slot.i, align 8
  %slot.__for_idx_678 = alloca i64, align 8
  store i64 0, ptr %slot.__for_idx_678, align 8
  %slot.s = alloca i64, align 8
  store i64 0, ptr %slot.s, align 8
  %slot.escaped = alloca i64, align 8
  store i64 0, ptr %slot.escaped, align 8
  %slot.byte_len = alloca i64, align 8
  store i64 0, ptr %slot.byte_len, align 8
  %r0 = add i64 0, 0
  %r1 = call i64 @nova_rt_len_any(i64 %r0)
  %r2 = add i64 0, 0
  %r3.cmp = icmp sgt i64 %r1, %r2
  %r3 = zext i1 %r3.cmp to i64
  %br_then675 = icmp ne i64 %r3, 0
  br i1 %br_then675, label %then675, label %else676
then675:
  %r4 = load i64, ptr %slot.cg, align 8
  %r5.p = getelementptr inbounds [19 x i8], ptr @.str.322, i64 0, i64 0
  %r5 = ptrtoint ptr %r5.p to i64
  %r6 = call i64 @emit(i64 %r4, i64 %r5)
  %r7 = add i64 0, 0
  store i64 %r7, ptr %slot.i, align 8
  %r8 = add i64 0, 0
  %r9 = call i64 @nova_rt_len_any(i64 %r8)
  %r10 = add i64 0, 0
  store i64 %r10, ptr %slot.__for_idx_678, align 8
  br label %for_hdr678
for_hdr678:
  %r11 = load i64, ptr %slot.__for_idx_678, align 8
  %r12.cmp = icmp slt i64 %r11, %r9
  %r12 = zext i1 %r12.cmp to i64
  %br_for_body679 = icmp ne i64 %r12, 0
  br i1 %br_for_body679, label %for_body679, label %for_exit680
for_body679:
  %r13 = call i64 @nova_rt_index_get(i64 %r8, i64 %r11)
  store i64 %r13, ptr %slot.s, align 8
  %r14 = load i64, ptr %slot.s, align 8
  %r15 = call i64 @llvm_escape_string(i64 %r14)
  store i64 %r15, ptr %slot.escaped, align 8
  %r16 = load i64, ptr %slot.s, align 8
  %r17 = call i64 @nova_rt_len_any(i64 %r16)
  %r18 = add i64 1, 0
  %r19 = add i64 %r17, %r18
  store i64 %r19, ptr %slot.byte_len, align 8
  %r20 = load i64, ptr %slot.cg, align 8
  %r21.p = getelementptr inbounds [7 x i8], ptr @.str.323, i64 0, i64 0
  %r21 = ptrtoint ptr %r21.p to i64
  %r22 = load i64, ptr %slot.i, align 8
  %r23 = call i64 @nova_rt_int_to_str(i64 %r22)
  %r24 = call i64 @nova_rt_str_concat(i64 %r21, i64 %r23)
  %r25.p = getelementptr inbounds [35 x i8], ptr @.str.324, i64 0, i64 0
  %r25 = ptrtoint ptr %r25.p to i64
  %r26 = call i64 @nova_rt_str_concat(i64 %r24, i64 %r25)
  %r27 = load i64, ptr %slot.byte_len, align 8
  %r28 = call i64 @nova_rt_int_to_str(i64 %r27)
  %r29 = call i64 @nova_rt_str_concat(i64 %r26, i64 %r28)
  %r30.p = getelementptr inbounds [10 x i8], ptr @.str.325, i64 0, i64 0
  %r30 = ptrtoint ptr %r30.p to i64
  %r31 = call i64 @nova_rt_str_concat(i64 %r29, i64 %r30)
  %r32 = load i64, ptr %slot.escaped, align 8
  %r33 = call i64 @nova_rt_str_concat(i64 %r31, i64 %r32)
  %r34.p = getelementptr inbounds [5 x i8], ptr @.str.326, i64 0, i64 0
  %r34 = ptrtoint ptr %r34.p to i64
  %r35 = call i64 @nova_rt_str_concat(i64 %r33, i64 %r34)
  %r36 = call i64 @emit(i64 %r20, i64 %r35)
  %r37 = load i64, ptr %slot.i, align 8
  %r38 = add i64 1, 0
  %r39 = add i64 %r37, %r38
  store i64 %r39, ptr %slot.i, align 8
  %r40 = load i64, ptr %slot.__for_idx_678, align 8
  %r41 = add i64 1, 0
  %r42 = add i64 %r40, %r41
  store i64 %r42, ptr %slot.__for_idx_678, align 8
  br label %for_hdr678
for_exit680:
  %r43 = load i64, ptr %slot.cg, align 8
  %r44.p = getelementptr inbounds [1 x i8], ptr @.str.42, i64 0, i64 0
  %r44 = ptrtoint ptr %r44.p to i64
  %r45 = call i64 @emit(i64 %r43, i64 %r44)
  br label %endif677
else676:
  br label %endif677
endif677:
  ret i64 0
}

define i64 @codegen_last_as_return(i64 %p0, i64 %p1) nounwind {
entry:
  %slot.cg = alloca i64, align 8
  store i64 %p0, ptr %slot.cg, align 8
  %slot.stmt = alloca i64, align 8
  store i64 %p1, ptr %slot.stmt, align 8
  ret i64 0
}

define i64 @emit_function(i64 %p0, i64 %p1) nounwind {
entry:
  %slot.cg = alloca i64, align 8
  store i64 %p0, ptr %slot.cg, align 8
  %slot.stmt = alloca i64, align 8
  store i64 %p1, ptr %slot.stmt, align 8
  ret i64 0
}

define i64 @emit_nova_main(i64 %p0, i64 %p1) nounwind {
entry:
  %slot.cg = alloca i64, align 8
  store i64 %p0, ptr %slot.cg, align 8
  %slot.stmts = alloca i64, align 8
  store i64 %p1, ptr %slot.stmts, align 8
  %slot.locals = alloca i64, align 8
  store i64 0, ptr %slot.locals, align 8
  %slot.__for_idx_681 = alloca i64, align 8
  store i64 0, ptr %slot.__for_idx_681, align 8
  %slot.local_name = alloca i64, align 8
  store i64 0, ptr %slot.local_name, align 8
  %slot.slot = alloca i64, align 8
  store i64 0, ptr %slot.slot, align 8
  %slot.__for_idx_684 = alloca i64, align 8
  store i64 0, ptr %slot.__for_idx_684, align 8
  %slot.s = alloca i64, align 8
  store i64 0, ptr %slot.s, align 8
  %r0 = call i64 @nova_rt_dict_create()
  %r1 = load i64, ptr %slot.cg, align 8
  %r2.ptr = inttoptr i64 %r1 to ptr
  %r2.gep = getelementptr i64, ptr %r2.ptr, i64 6
  store i64 %r0, ptr %r2.gep, align 8
  %r3 = add i64 0, 0
  %r4 = load i64, ptr %slot.cg, align 8
  %r5.ptr = inttoptr i64 %r4 to ptr
  %r5.gep = getelementptr i64, ptr %r5.ptr, i64 3
  store i64 %r3, ptr %r5.gep, align 8
  %r6 = load i64, ptr %slot.cg, align 8
  %r7.p = getelementptr inbounds [35 x i8], ptr @.str.327, i64 0, i64 0
  %r7 = ptrtoint ptr %r7.p to i64
  %r8 = call i64 @emit(i64 %r6, i64 %r7)
  %r9 = load i64, ptr %slot.cg, align 8
  %r10.p = getelementptr inbounds [7 x i8], ptr @.str.328, i64 0, i64 0
  %r10 = ptrtoint ptr %r10.p to i64
  %r11 = call i64 @emit(i64 %r9, i64 %r10)
  %r12 = load i64, ptr %slot.stmts, align 8
  %r13 = call i64 @collect_locals(i64 %r12)
  store i64 %r13, ptr %slot.locals, align 8
  %r14 = load i64, ptr %slot.locals, align 8
  %r15 = call i64 @nova_rt_len_any(i64 %r14)
  %r16 = add i64 0, 0
  store i64 %r16, ptr %slot.__for_idx_681, align 8
  br label %for_hdr681
for_hdr681:
  %r17 = load i64, ptr %slot.__for_idx_681, align 8
  %r18.cmp = icmp slt i64 %r17, %r15
  %r18 = zext i1 %r18.cmp to i64
  %br_for_body682 = icmp ne i64 %r18, 0
  br i1 %br_for_body682, label %for_body682, label %for_exit683
for_body682:
  %r19 = call i64 @nova_rt_index_get(i64 %r14, i64 %r17)
  store i64 %r19, ptr %slot.local_name, align 8
  %r20 = load i64, ptr %slot.cg, align 8
  %r21 = load i64, ptr %slot.local_name, align 8
  %r22 = call i64 @get_slot(i64 %r20, i64 %r21)
  store i64 %r22, ptr %slot.slot, align 8
  %r23 = load i64, ptr %slot.cg, align 8
  %r24 = load i64, ptr %slot.slot, align 8
  %r25.p = getelementptr inbounds [23 x i8], ptr @.str.329, i64 0, i64 0
  %r25 = ptrtoint ptr %r25.p to i64
  %r26 = call i64 @nova_rt_str_concat(i64 %r24, i64 %r25)
  %r27 = call i64 @emit_indent(i64 %r23, i64 %r26)
  %r28 = load i64, ptr %slot.cg, align 8
  %r29.p = getelementptr inbounds [18 x i8], ptr @.str.330, i64 0, i64 0
  %r29 = ptrtoint ptr %r29.p to i64
  %r30 = load i64, ptr %slot.slot, align 8
  %r31 = call i64 @nova_rt_str_concat(i64 %r29, i64 %r30)
  %r32.p = getelementptr inbounds [10 x i8], ptr @.str.185, i64 0, i64 0
  %r32 = ptrtoint ptr %r32.p to i64
  %r33 = call i64 @nova_rt_str_concat(i64 %r31, i64 %r32)
  %r34 = call i64 @emit_indent(i64 %r28, i64 %r33)
  %r35 = load i64, ptr %slot.__for_idx_681, align 8
  %r36 = add i64 1, 0
  %r37 = add i64 %r35, %r36
  store i64 %r37, ptr %slot.__for_idx_681, align 8
  br label %for_hdr681
for_exit683:
  %r38 = load i64, ptr %slot.stmts, align 8
  %r39 = call i64 @nova_rt_len_any(i64 %r38)
  %r40 = add i64 0, 0
  store i64 %r40, ptr %slot.__for_idx_684, align 8
  br label %for_hdr684
for_hdr684:
  %r41 = load i64, ptr %slot.__for_idx_684, align 8
  %r42.cmp = icmp slt i64 %r41, %r39
  %r42 = zext i1 %r42.cmp to i64
  %br_for_body685 = icmp ne i64 %r42, 0
  br i1 %br_for_body685, label %for_body685, label %for_exit686
for_body685:
  %r43 = call i64 @nova_rt_index_get(i64 %r38, i64 %r41)
  store i64 %r43, ptr %slot.s, align 8
  %r44 = load i64, ptr %slot.cg, align 8
  %r45 = load i64, ptr %slot.s, align 8
  %r46 = call i64 @codegen_stmt(i64 %r44, i64 %r45)
  %r47 = load i64, ptr %slot.__for_idx_684, align 8
  %r48 = add i64 1, 0
  %r49 = add i64 %r47, %r48
  store i64 %r49, ptr %slot.__for_idx_684, align 8
  br label %for_hdr684
for_exit686:
  %r50 = load i64, ptr %slot.cg, align 8
  %r51.p = getelementptr inbounds [10 x i8], ptr @.str.331, i64 0, i64 0
  %r51 = ptrtoint ptr %r51.p to i64
  %r52 = call i64 @emit_indent(i64 %r50, i64 %r51)
  %r53 = load i64, ptr %slot.cg, align 8
  %r54.p = getelementptr inbounds [2 x i8], ptr @.str.64, i64 0, i64 0
  %r54 = ptrtoint ptr %r54.p to i64
  %r55 = call i64 @emit(i64 %r53, i64 %r54)
  %r56 = load i64, ptr %slot.cg, align 8
  %r57.p = getelementptr inbounds [1 x i8], ptr @.str.42, i64 0, i64 0
  %r57 = ptrtoint ptr %r57.p to i64
  %r58 = call i64 @emit(i64 %r56, i64 %r57)
  ret i64 0
}

define i64 @emit_main_entry(i64 %p0) nounwind {
entry:
  %slot.cg = alloca i64, align 8
  store i64 %p0, ptr %slot.cg, align 8
  %r0 = load i64, ptr %slot.cg, align 8
  %r1.p = getelementptr inbounds [50 x i8], ptr @.str.332, i64 0, i64 0
  %r1 = ptrtoint ptr %r1.p to i64
  %r2 = call i64 @emit(i64 %r0, i64 %r1)
  %r3 = load i64, ptr %slot.cg, align 8
  %r4.p = getelementptr inbounds [7 x i8], ptr @.str.328, i64 0, i64 0
  %r4 = ptrtoint ptr %r4.p to i64
  %r5 = call i64 @emit(i64 %r3, i64 %r4)
  %r6 = load i64, ptr %slot.cg, align 8
  %r7.p = getelementptr inbounds [32 x i8], ptr @.str.333, i64 0, i64 0
  %r7 = ptrtoint ptr %r7.p to i64
  %r8 = call i64 @emit_indent(i64 %r6, i64 %r7)
  %r9 = load i64, ptr %slot.cg, align 8
  %r10.p = getelementptr inbounds [36 x i8], ptr @.str.334, i64 0, i64 0
  %r10 = ptrtoint ptr %r10.p to i64
  %r11 = call i64 @emit_indent(i64 %r9, i64 %r10)
  %r12 = load i64, ptr %slot.cg, align 8
  %r13.p = getelementptr inbounds [55 x i8], ptr @.str.335, i64 0, i64 0
  %r13 = ptrtoint ptr %r13.p to i64
  %r14 = call i64 @emit_indent(i64 %r12, i64 %r13)
  %r15 = load i64, ptr %slot.cg, align 8
  %r16.p = getelementptr inbounds [22 x i8], ptr @.str.336, i64 0, i64 0
  %r16 = ptrtoint ptr %r16.p to i64
  %r17 = call i64 @emit_indent(i64 %r15, i64 %r16)
  %r18 = load i64, ptr %slot.cg, align 8
  %r19.p = getelementptr inbounds [29 x i8], ptr @.str.337, i64 0, i64 0
  %r19 = ptrtoint ptr %r19.p to i64
  %r20 = call i64 @emit_indent(i64 %r18, i64 %r19)
  %r21 = load i64, ptr %slot.cg, align 8
  %r22.p = getelementptr inbounds [10 x i8], ptr @.str.338, i64 0, i64 0
  %r22 = ptrtoint ptr %r22.p to i64
  %r23 = call i64 @emit_indent(i64 %r21, i64 %r22)
  %r24 = load i64, ptr %slot.cg, align 8
  %r25.p = getelementptr inbounds [2 x i8], ptr @.str.64, i64 0, i64 0
  %r25 = ptrtoint ptr %r25.p to i64
  %r26 = call i64 @emit(i64 %r24, i64 %r25)
  ret i64 0
}

define i64 @extract_pattern_names(i64 %p0) nounwind {
entry:
  %slot.pattern = alloca i64, align 8
  store i64 %p0, ptr %slot.pattern, align 8
  %slot.names = alloca i64, align 8
  store i64 0, ptr %slot.names, align 8
  %r0 = call i64 @nova_rt_list_create()
  store i64 %r0, ptr %slot.names, align 8
  %r1 = load i64, ptr %slot.names, align 8
  ret i64 %r1
}

define i64 @expr_ident_name(i64 %p0) nounwind {
entry:
  %slot.e = alloca i64, align 8
  store i64 %p0, ptr %slot.e, align 8
  %r0.p = getelementptr inbounds [1 x i8], ptr @.str.42, i64 0, i64 0
  %r0 = ptrtoint ptr %r0.p to i64
  ret i64 %r0
}

define i64 @collect_locals(i64 %p0) nounwind {
entry:
  %slot.stmts = alloca i64, align 8
  store i64 %p0, ptr %slot.stmts, align 8
  %slot.locals = alloca i64, align 8
  store i64 0, ptr %slot.locals, align 8
  %slot.__for_idx_687 = alloca i64, align 8
  store i64 0, ptr %slot.__for_idx_687, align 8
  %slot.s = alloca i64, align 8
  store i64 0, ptr %slot.s, align 8
  %r0 = call i64 @nova_rt_list_create()
  store i64 %r0, ptr %slot.locals, align 8
  %r1 = load i64, ptr %slot.stmts, align 8
  %r2 = call i64 @nova_rt_len_any(i64 %r1)
  %r3 = add i64 0, 0
  store i64 %r3, ptr %slot.__for_idx_687, align 8
  br label %for_hdr687
for_hdr687:
  %r4 = load i64, ptr %slot.__for_idx_687, align 8
  %r5.cmp = icmp slt i64 %r4, %r2
  %r5 = zext i1 %r5.cmp to i64
  %br_for_body688 = icmp ne i64 %r5, 0
  br i1 %br_for_body688, label %for_body688, label %for_exit689
for_body688:
  %r6 = call i64 @nova_rt_index_get(i64 %r1, i64 %r4)
  store i64 %r6, ptr %slot.s, align 8
  %r7 = load i64, ptr %slot.__for_idx_687, align 8
  %r8 = add i64 1, 0
  %r9 = add i64 %r7, %r8
  store i64 %r9, ptr %slot.__for_idx_687, align 8
  br label %for_hdr687
for_exit689:
  %r10 = load i64, ptr %slot.locals, align 8
  ret i64 0
}

define i64 @list_contains(i64 %p0, i64 %p1) nounwind {
entry:
  %slot.lst = alloca i64, align 8
  store i64 %p0, ptr %slot.lst, align 8
  %slot.item = alloca i64, align 8
  store i64 %p1, ptr %slot.item, align 8
  %slot.__for_idx_690 = alloca i64, align 8
  store i64 0, ptr %slot.__for_idx_690, align 8
  %slot.x = alloca i64, align 8
  store i64 0, ptr %slot.x, align 8
  %r0 = load i64, ptr %slot.lst, align 8
  %r1 = call i64 @nova_rt_len_any(i64 %r0)
  %r2 = add i64 0, 0
  store i64 %r2, ptr %slot.__for_idx_690, align 8
  br label %for_hdr690
for_hdr690:
  %r3 = load i64, ptr %slot.__for_idx_690, align 8
  %r4.cmp = icmp slt i64 %r3, %r1
  %r4 = zext i1 %r4.cmp to i64
  %br_for_body691 = icmp ne i64 %r4, 0
  br i1 %br_for_body691, label %for_body691, label %for_exit692
for_body691:
  %r5 = call i64 @nova_rt_index_get(i64 %r0, i64 %r3)
  store i64 %r5, ptr %slot.x, align 8
  %r6 = load i64, ptr %slot.x, align 8
  %r7 = load i64, ptr %slot.item, align 8
  %r8 = call i64 @nova_rt_eq(i64 %r6, i64 %r7)
  %br_then693 = icmp ne i64 %r8, 0
  br i1 %br_then693, label %then693, label %else694
then693:
  %r9 = add i64 1, 0
  ret i64 %r9
else694:
  br label %endif695
endif695:
  %r10 = load i64, ptr %slot.__for_idx_690, align 8
  %r11 = add i64 1, 0
  %r12 = add i64 %r10, %r11
  store i64 %r12, ptr %slot.__for_idx_690, align 8
  br label %for_hdr690
for_exit692:
  %r13 = add i64 0, 0
  ret i64 0
}

define i64 @llvm_escape_string(i64 %p0) nounwind {
entry:
  %slot.s = alloca i64, align 8
  store i64 %p0, ptr %slot.s, align 8
  %slot.result = alloca i64, align 8
  store i64 0, ptr %slot.result, align 8
  %slot.i = alloca i64, align 8
  store i64 0, ptr %slot.i, align 8
  %slot.ch = alloca i64, align 8
  store i64 0, ptr %slot.ch, align 8
  %r0.p = getelementptr inbounds [1 x i8], ptr @.str.42, i64 0, i64 0
  %r0 = ptrtoint ptr %r0.p to i64
  store i64 %r0, ptr %slot.result, align 8
  %r1 = add i64 0, 0
  store i64 %r1, ptr %slot.i, align 8
  br label %while_hdr696
while_hdr696:
  %r2 = load i64, ptr %slot.i, align 8
  %r3 = load i64, ptr %slot.s, align 8
  %r4 = call i64 @nova_rt_len_any(i64 %r3)
  %r5.cmp = icmp slt i64 %r2, %r4
  %r5 = zext i1 %r5.cmp to i64
  %br_while_body697 = icmp ne i64 %r5, 0
  br i1 %br_while_body697, label %while_body697, label %while_exit698
while_body697:
  %r6 = load i64, ptr %slot.s, align 8
  %r7 = load i64, ptr %slot.i, align 8
  %r8 = call i64 @nova_rt_index_get(i64 %r6, i64 %r7)
  store i64 %r8, ptr %slot.ch, align 8
  %r9 = load i64, ptr %slot.ch, align 8
  %r10.p = getelementptr inbounds [2 x i8], ptr @.str.36, i64 0, i64 0
  %r10 = ptrtoint ptr %r10.p to i64
  %r11 = call i64 @nova_rt_eq(i64 %r9, i64 %r10)
  %br_then699 = icmp ne i64 %r11, 0
  br i1 %br_then699, label %then699, label %else700
then699:
  %r12 = load i64, ptr %slot.result, align 8
  %r13.p = getelementptr inbounds [4 x i8], ptr @.str.339, i64 0, i64 0
  %r13 = ptrtoint ptr %r13.p to i64
  %r14 = call i64 @nova_rt_str_concat(i64 %r12, i64 %r13)
  store i64 %r14, ptr %slot.result, align 8
  br label %endif701
else700:
  %r15 = load i64, ptr %slot.ch, align 8
  %r16.p = getelementptr inbounds [2 x i8], ptr @.str.3, i64 0, i64 0
  %r16 = ptrtoint ptr %r16.p to i64
  %r17 = call i64 @nova_rt_eq(i64 %r15, i64 %r16)
  %br_then702 = icmp ne i64 %r17, 0
  br i1 %br_then702, label %then702, label %else703
then702:
  %r18 = load i64, ptr %slot.result, align 8
  %r19.p = getelementptr inbounds [4 x i8], ptr @.str.340, i64 0, i64 0
  %r19 = ptrtoint ptr %r19.p to i64
  %r20 = call i64 @nova_rt_str_concat(i64 %r18, i64 %r19)
  store i64 %r20, ptr %slot.result, align 8
  br label %endif704
else703:
  %r21 = load i64, ptr %slot.ch, align 8
  %r22.p = getelementptr inbounds [2 x i8], ptr @.str.2, i64 0, i64 0
  %r22 = ptrtoint ptr %r22.p to i64
  %r23 = call i64 @nova_rt_eq(i64 %r21, i64 %r22)
  %br_then705 = icmp ne i64 %r23, 0
  br i1 %br_then705, label %then705, label %else706
then705:
  %r24 = load i64, ptr %slot.result, align 8
  %r25.p = getelementptr inbounds [4 x i8], ptr @.str.341, i64 0, i64 0
  %r25 = ptrtoint ptr %r25.p to i64
  %r26 = call i64 @nova_rt_str_concat(i64 %r24, i64 %r25)
  store i64 %r26, ptr %slot.result, align 8
  br label %endif707
else706:
  %r27 = load i64, ptr %slot.ch, align 8
  %r28.p = getelementptr inbounds [1 x i8], ptr @.str.42, i64 0, i64 0
  %r28 = ptrtoint ptr %r28.p to i64
  %r29 = call i64 @nova_rt_eq(i64 %r27, i64 %r28)
  %br_then708 = icmp ne i64 %r29, 0
  br i1 %br_then708, label %then708, label %else709
then708:
  %r30 = load i64, ptr %slot.result, align 8
  %r31.p = getelementptr inbounds [4 x i8], ptr @.str.342, i64 0, i64 0
  %r31 = ptrtoint ptr %r31.p to i64
  %r32 = call i64 @nova_rt_str_concat(i64 %r30, i64 %r31)
  store i64 %r32, ptr %slot.result, align 8
  br label %endif710
else709:
  %r33 = load i64, ptr %slot.ch, align 8
  %r34.p = getelementptr inbounds [2 x i8], ptr @.str.51, i64 0, i64 0
  %r34 = ptrtoint ptr %r34.p to i64
  %r35 = call i64 @nova_rt_eq(i64 %r33, i64 %r34)
  %br_then711 = icmp ne i64 %r35, 0
  br i1 %br_then711, label %then711, label %else712
then711:
  %r36 = load i64, ptr %slot.result, align 8
  %r37.p = getelementptr inbounds [3 x i8], ptr @.str.343, i64 0, i64 0
  %r37 = ptrtoint ptr %r37.p to i64
  %r38 = call i64 @nova_rt_str_concat(i64 %r36, i64 %r37)
  store i64 %r38, ptr %slot.result, align 8
  br label %endif713
else712:
  %r39 = load i64, ptr %slot.ch, align 8
  %r40.p = getelementptr inbounds [2 x i8], ptr @.str.50, i64 0, i64 0
  %r40 = ptrtoint ptr %r40.p to i64
  %r41 = call i64 @nova_rt_eq(i64 %r39, i64 %r40)
  %br_then714 = icmp ne i64 %r41, 0
  br i1 %br_then714, label %then714, label %else715
then714:
  %r42 = load i64, ptr %slot.result, align 8
  %r43.p = getelementptr inbounds [4 x i8], ptr @.str.344, i64 0, i64 0
  %r43 = ptrtoint ptr %r43.p to i64
  %r44 = call i64 @nova_rt_str_concat(i64 %r42, i64 %r43)
  store i64 %r44, ptr %slot.result, align 8
  br label %endif716
else715:
  %r45 = load i64, ptr %slot.result, align 8
  %r46 = load i64, ptr %slot.ch, align 8
  %r47 = call i64 @nova_rt_str_concat(i64 %r45, i64 %r46)
  store i64 %r47, ptr %slot.result, align 8
  br label %endif716
endif716:
  br label %endif713
endif713:
  br label %endif710
endif710:
  br label %endif707
endif707:
  br label %endif704
endif704:
  br label %endif701
endif701:
  %r48 = load i64, ptr %slot.i, align 8
  %r49 = add i64 1, 0
  %r50 = add i64 %r48, %r49
  store i64 %r50, ptr %slot.i, align 8
  br label %while_hdr696
while_exit698:
  %r51 = load i64, ptr %slot.result, align 8
  ret i64 0
}

define i64 @float_bits(i64 %p0) nounwind {
entry:
  %slot.s = alloca i64, align 8
  store i64 %p0, ptr %slot.s, align 8
  %r0 = add i64 0, 0
  ret i64 0
}

define i64 @ir_type_int() nounwind {
entry:
  %r0.p = getelementptr inbounds [4 x i8], ptr @.str.113, i64 0, i64 0
  %r0 = ptrtoint ptr %r0.p to i64
  %r1.p = getelementptr inbounds [1 x i8], ptr @.str.42, i64 0, i64 0
  %r1 = ptrtoint ptr %r1.p to i64
  %r2 = call i64 @nova_rt_list_create()
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

define i64 @ir_type_str() nounwind {
entry:
  %r0.p = getelementptr inbounds [4 x i8], ptr @.str.115, i64 0, i64 0
  %r0 = ptrtoint ptr %r0.p to i64
  %r1.p = getelementptr inbounds [1 x i8], ptr @.str.42, i64 0, i64 0
  %r1 = ptrtoint ptr %r1.p to i64
  %r2 = call i64 @nova_rt_list_create()
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

define i64 @ir_type_any() nounwind {
entry:
  %r0.p = getelementptr inbounds [4 x i8], ptr @.str.345, i64 0, i64 0
  %r0 = ptrtoint ptr %r0.p to i64
  %r1.p = getelementptr inbounds [1 x i8], ptr @.str.42, i64 0, i64 0
  %r1 = ptrtoint ptr %r1.p to i64
  %r2 = call i64 @nova_rt_list_create()
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

define i64 @ir_type_void() nounwind {
entry:
  %r0.p = getelementptr inbounds [5 x i8], ptr @.str.346, i64 0, i64 0
  %r0 = ptrtoint ptr %r0.p to i64
  %r1.p = getelementptr inbounds [1 x i8], ptr @.str.42, i64 0, i64 0
  %r1 = ptrtoint ptr %r1.p to i64
  %r2 = call i64 @nova_rt_list_create()
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

define i64 @new_ir_builder() nounwind {
entry:
  %r0 = call i64 @nova_rt_list_create()
  %r1 = add i64 0, 0
  %r2 = call i64 @nova_rt_list_create()
  %r3.p = getelementptr inbounds [6 x i8], ptr @.str.347, i64 0, i64 0
  %r3 = ptrtoint ptr %r3.p to i64
  %r4 = call i64 @nova_rt_dict_create()
  %r5 = call i64 @nova_rt_list_create()
  %r6 = call i64 @nova_rt_dict_create()
  %r7 = add i64 0, 0
  %r8 = call i64 @nova_rt_list_create()
  %r9 = call i64 @nova_rt_dict_create()
  %r10 = call i64 @nova_rt_dict_create()
  %r11.ptr = call ptr @nova_rt_struct_alloc(i64 88)
  %r11.f0 = getelementptr i64, ptr %r11.ptr, i64 0
  store i64 %r0, ptr %r11.f0, align 8
  %r11.f1 = getelementptr i64, ptr %r11.ptr, i64 1
  store i64 %r1, ptr %r11.f1, align 8
  %r11.f2 = getelementptr i64, ptr %r11.ptr, i64 2
  store i64 %r2, ptr %r11.f2, align 8
  %r11.f3 = getelementptr i64, ptr %r11.ptr, i64 3
  store i64 %r3, ptr %r11.f3, align 8
  %r11.f4 = getelementptr i64, ptr %r11.ptr, i64 4
  store i64 %r4, ptr %r11.f4, align 8
  %r11.f5 = getelementptr i64, ptr %r11.ptr, i64 5
  store i64 %r5, ptr %r11.f5, align 8
  %r11.f6 = getelementptr i64, ptr %r11.ptr, i64 6
  store i64 %r6, ptr %r11.f6, align 8
  %r11.f7 = getelementptr i64, ptr %r11.ptr, i64 7
  store i64 %r7, ptr %r11.f7, align 8
  %r11.f8 = getelementptr i64, ptr %r11.ptr, i64 8
  store i64 %r8, ptr %r11.f8, align 8
  %r11.f9 = getelementptr i64, ptr %r11.ptr, i64 9
  store i64 %r9, ptr %r11.f9, align 8
  %r11.f10 = getelementptr i64, ptr %r11.ptr, i64 10
  store i64 %r10, ptr %r11.f10, align 8
  %r11 = ptrtoint ptr %r11.ptr to i64
  ret i64 0
}

define i64 @ir_fresh_reg(i64 %p0) nounwind {
entry:
  %slot.b = alloca i64, align 8
  store i64 %p0, ptr %slot.b, align 8
  %slot.r = alloca i64, align 8
  store i64 0, ptr %slot.r, align 8
  %r0.p = getelementptr inbounds [3 x i8], ptr @.str.137, i64 0, i64 0
  %r0 = ptrtoint ptr %r0.p to i64
  %r1 = add i64 0, 0
  %r2 = call i64 @nova_rt_int_to_str(i64 %r1)
  %r3 = call i64 @nova_rt_str_concat(i64 %r0, i64 %r2)
  store i64 %r3, ptr %slot.r, align 8
  %r4 = add i64 0, 0
  %r5 = add i64 1, 0
  %r6 = add i64 %r4, %r5
  %r7 = load i64, ptr %slot.b, align 8
  %r8.ptr = inttoptr i64 %r7 to ptr
  %r8.gep = getelementptr i64, ptr %r8.ptr, i64 1
  store i64 %r6, ptr %r8.gep, align 8
  %r9 = load i64, ptr %slot.r, align 8
  ret i64 0
}

define i64 @ir_fresh_label(i64 %p0, i64 %p1) nounwind {
entry:
  %slot.b = alloca i64, align 8
  store i64 %p0, ptr %slot.b, align 8
  %slot.prefix = alloca i64, align 8
  store i64 %p1, ptr %slot.prefix, align 8
  %slot.l = alloca i64, align 8
  store i64 0, ptr %slot.l, align 8
  %r0 = load i64, ptr %slot.prefix, align 8
  %r1 = add i64 0, 0
  %r2 = call i64 @nova_rt_int_to_str(i64 %r1)
  %r3 = call i64 @nova_rt_str_concat(i64 %r0, i64 %r2)
  store i64 %r3, ptr %slot.l, align 8
  %r4 = add i64 0, 0
  %r5 = add i64 1, 0
  %r6 = add i64 %r4, %r5
  %r7 = load i64, ptr %slot.b, align 8
  %r8.ptr = inttoptr i64 %r7 to ptr
  %r8.gep = getelementptr i64, ptr %r8.ptr, i64 7
  store i64 %r6, ptr %r8.gep, align 8
  %r9 = load i64, ptr %slot.l, align 8
  ret i64 0
}

define i64 @ir_emit_inst(i64 %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4, i64 %p5, i64 %p6) nounwind {
entry:
  %slot.b = alloca i64, align 8
  store i64 %p0, ptr %slot.b, align 8
  %slot.op = alloca i64, align 8
  store i64 %p1, ptr %slot.op, align 8
  %slot.dest = alloca i64, align 8
  store i64 %p2, ptr %slot.dest, align 8
  %slot.typ = alloca i64, align 8
  store i64 %p3, ptr %slot.typ, align 8
  %slot.args = alloca i64, align 8
  store i64 %p4, ptr %slot.args, align 8
  %slot.value = alloca i64, align 8
  store i64 %p5, ptr %slot.value, align 8
  %slot.num = alloca i64, align 8
  store i64 %p6, ptr %slot.num, align 8
  %r0 = add i64 0, 0
  %r1 = load i64, ptr %slot.op, align 8
  %r2 = load i64, ptr %slot.dest, align 8
  %r3 = load i64, ptr %slot.typ, align 8
  %r4 = load i64, ptr %slot.args, align 8
  %r5 = load i64, ptr %slot.value, align 8
  %r6 = load i64, ptr %slot.num, align 8
  %r7.p = getelementptr inbounds [5 x i8], ptr @.str.348, i64 0, i64 0
  %r7 = ptrtoint ptr %r7.p to i64
  %r8.ptr = call ptr @nova_rt_struct_alloc(i64 56)
  %r8.f0 = getelementptr i64, ptr %r8.ptr, i64 0
  store i64 %r1, ptr %r8.f0, align 8
  %r8.f1 = getelementptr i64, ptr %r8.ptr, i64 1
  store i64 %r2, ptr %r8.f1, align 8
  %r8.f2 = getelementptr i64, ptr %r8.ptr, i64 2
  store i64 %r3, ptr %r8.f2, align 8
  %r8.f3 = getelementptr i64, ptr %r8.ptr, i64 3
  store i64 %r4, ptr %r8.f3, align 8
  %r8.f4 = getelementptr i64, ptr %r8.ptr, i64 4
  store i64 %r5, ptr %r8.f4, align 8
  %r8.f5 = getelementptr i64, ptr %r8.ptr, i64 5
  store i64 %r6, ptr %r8.f5, align 8
  %r8.f6 = getelementptr i64, ptr %r8.ptr, i64 6
  store i64 %r7, ptr %r8.f6, align 8
  %r8 = ptrtoint ptr %r8.ptr to i64
  %r9 = call i64 @nova_rt_list_append(i64 %r0, i64 %r8)
  ret i64 0
}

define i64 @ir_emit_side(i64 %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4, i64 %p5, i64 %p6) nounwind {
entry:
  %slot.b = alloca i64, align 8
  store i64 %p0, ptr %slot.b, align 8
  %slot.op = alloca i64, align 8
  store i64 %p1, ptr %slot.op, align 8
  %slot.dest = alloca i64, align 8
  store i64 %p2, ptr %slot.dest, align 8
  %slot.typ = alloca i64, align 8
  store i64 %p3, ptr %slot.typ, align 8
  %slot.args = alloca i64, align 8
  store i64 %p4, ptr %slot.args, align 8
  %slot.value = alloca i64, align 8
  store i64 %p5, ptr %slot.value, align 8
  %slot.num = alloca i64, align 8
  store i64 %p6, ptr %slot.num, align 8
  %r0 = add i64 0, 0
  %r1 = load i64, ptr %slot.op, align 8
  %r2 = load i64, ptr %slot.dest, align 8
  %r3 = load i64, ptr %slot.typ, align 8
  %r4 = load i64, ptr %slot.args, align 8
  %r5 = load i64, ptr %slot.value, align 8
  %r6 = load i64, ptr %slot.num, align 8
  %r7.p = getelementptr inbounds [12 x i8], ptr @.str.349, i64 0, i64 0
  %r7 = ptrtoint ptr %r7.p to i64
  %r8.ptr = call ptr @nova_rt_struct_alloc(i64 56)
  %r8.f0 = getelementptr i64, ptr %r8.ptr, i64 0
  store i64 %r1, ptr %r8.f0, align 8
  %r8.f1 = getelementptr i64, ptr %r8.ptr, i64 1
  store i64 %r2, ptr %r8.f1, align 8
  %r8.f2 = getelementptr i64, ptr %r8.ptr, i64 2
  store i64 %r3, ptr %r8.f2, align 8
  %r8.f3 = getelementptr i64, ptr %r8.ptr, i64 3
  store i64 %r4, ptr %r8.f3, align 8
  %r8.f4 = getelementptr i64, ptr %r8.ptr, i64 4
  store i64 %r5, ptr %r8.f4, align 8
  %r8.f5 = getelementptr i64, ptr %r8.ptr, i64 5
  store i64 %r6, ptr %r8.f5, align 8
  %r8.f6 = getelementptr i64, ptr %r8.ptr, i64 6
  store i64 %r7, ptr %r8.f6, align 8
  %r8 = ptrtoint ptr %r8.ptr to i64
  %r9 = call i64 @nova_rt_list_append(i64 %r0, i64 %r8)
  ret i64 0
}

define i64 @ir_finish_block(i64 %p0, i64 %p1) nounwind {
entry:
  %slot.b = alloca i64, align 8
  store i64 %p0, ptr %slot.b, align 8
  %slot.terminator = alloca i64, align 8
  store i64 %p1, ptr %slot.terminator, align 8
  %slot.block = alloca i64, align 8
  store i64 0, ptr %slot.block, align 8
  %r0 = add i64 0, 0
  %r1 = add i64 0, 0
  %r2 = load i64, ptr %slot.terminator, align 8
  %r3.ptr = call ptr @nova_rt_struct_alloc(i64 24)
  %r3.f0 = getelementptr i64, ptr %r3.ptr, i64 0
  store i64 %r0, ptr %r3.f0, align 8
  %r3.f1 = getelementptr i64, ptr %r3.ptr, i64 1
  store i64 %r1, ptr %r3.f1, align 8
  %r3.f2 = getelementptr i64, ptr %r3.ptr, i64 2
  store i64 %r2, ptr %r3.f2, align 8
  %r3 = ptrtoint ptr %r3.ptr to i64
  store i64 %r3, ptr %slot.block, align 8
  %r4 = add i64 0, 0
  %r5 = load i64, ptr %slot.block, align 8
  %r6 = call i64 @nova_rt_list_append(i64 %r4, i64 %r5)
  %r7 = call i64 @nova_rt_list_create()
  %r8 = load i64, ptr %slot.b, align 8
  %r9.ptr = inttoptr i64 %r8 to ptr
  %r9.gep = getelementptr i64, ptr %r9.ptr, i64 0
  store i64 %r7, ptr %r9.gep, align 8
  %r10.p = getelementptr inbounds [1 x i8], ptr @.str.42, i64 0, i64 0
  %r10 = ptrtoint ptr %r10.p to i64
  %r11 = load i64, ptr %slot.b, align 8
  %r12.ptr = inttoptr i64 %r11 to ptr
  %r12.gep = getelementptr i64, ptr %r12.ptr, i64 3
  store i64 %r10, ptr %r12.gep, align 8
  ret i64 0
}

define i64 @ir_start_block(i64 %p0, i64 %p1) nounwind {
entry:
  %slot.b = alloca i64, align 8
  store i64 %p0, ptr %slot.b, align 8
  %slot.label = alloca i64, align 8
  store i64 %p1, ptr %slot.label, align 8
  %r0 = load i64, ptr %slot.label, align 8
  %r1 = load i64, ptr %slot.b, align 8
  %r2.ptr = inttoptr i64 %r1 to ptr
  %r2.gep = getelementptr i64, ptr %r2.ptr, i64 3
  store i64 %r0, ptr %r2.gep, align 8
  ret i64 0
}

define i64 @ir_lower_expr(i64 %p0, i64 %p1) nounwind {
entry:
  %slot.b = alloca i64, align 8
  store i64 %p0, ptr %slot.b, align 8
  %slot.expr = alloca i64, align 8
  store i64 %p1, ptr %slot.expr, align 8
  ret i64 0
}

define i64 @get_ir_field_index(i64 %p0, i64 %p1) nounwind {
entry:
  %slot.b = alloca i64, align 8
  store i64 %p0, ptr %slot.b, align 8
  %slot.field_name = alloca i64, align 8
  store i64 %p1, ptr %slot.field_name, align 8
  %r0 = add i64 0, 0
  %r1 = load i64, ptr %slot.field_name, align 8
  %r2 = call i64 @nova_rt_contains(i64 %r0, i64 %r1)
  %br_then717 = icmp ne i64 %r2, 0
  br i1 %br_then717, label %then717, label %else718
then717:
  %r3 = add i64 0, 0
  %r4 = load i64, ptr %slot.field_name, align 8
  %r5 = call i64 @nova_rt_index_get(i64 %r3, i64 %r4)
  ret i64 %r5
else718:
  br label %endif719
endif719:
  %r6 = add i64 0, 0
  ret i64 0
}

define i64 @ir_lower_stmt(i64 %p0, i64 %p1) nounwind {
entry:
  %slot.b = alloca i64, align 8
  store i64 %p0, ptr %slot.b, align 8
  %slot.stmt = alloca i64, align 8
  store i64 %p1, ptr %slot.stmt, align 8
  ret i64 0
}

define i64 @ir_lower_assign_target(i64 %p0, i64 %p1, i64 %p2) nounwind {
entry:
  %slot.b = alloca i64, align 8
  store i64 %p0, ptr %slot.b, align 8
  %slot.target = alloca i64, align 8
  store i64 %p1, ptr %slot.target, align 8
  %slot.val_reg = alloca i64, align 8
  store i64 %p2, ptr %slot.val_reg, align 8
  ret i64 0
}

define i64 @ir_flush_pending_block(i64 %p0) nounwind {
entry:
  %slot.b = alloca i64, align 8
  store i64 %p0, ptr %slot.b, align 8
  %r0 = add i64 0, 0
  %r1.p = getelementptr inbounds [1 x i8], ptr @.str.42, i64 0, i64 0
  %r1 = ptrtoint ptr %r1.p to i64
  %r2 = call i64 @nova_rt_neq(i64 %r0, i64 %r1)
  %br_then720 = icmp ne i64 %r2, 0
  br i1 %br_then720, label %then720, label %else721
then720:
  %r3 = load i64, ptr %slot.b, align 8
  %r4.p = getelementptr inbounds [7 x i8], ptr @.str.5, i64 0, i64 0
  %r4 = ptrtoint ptr %r4.p to i64
  %r5.p = getelementptr inbounds [1 x i8], ptr @.str.42, i64 0, i64 0
  %r5 = ptrtoint ptr %r5.p to i64
  %r6 = call i64 @ir_type_void()
  %r8.p = getelementptr inbounds [2 x i8], ptr @.str.55, i64 0, i64 0
  %r8 = ptrtoint ptr %r8.p to i64
  %r7 = call i64 @nova_rt_list_create()
  call i64 @nova_rt_list_append(i64 %r7, i64 %r8)
  %r9.p = getelementptr inbounds [1 x i8], ptr @.str.42, i64 0, i64 0
  %r9 = ptrtoint ptr %r9.p to i64
  %r10 = add i64 0, 0
  %r11.p = getelementptr inbounds [5 x i8], ptr @.str.348, i64 0, i64 0
  %r11 = ptrtoint ptr %r11.p to i64
  %r12.ptr = call ptr @nova_rt_struct_alloc(i64 56)
  %r12.f0 = getelementptr i64, ptr %r12.ptr, i64 0
  store i64 %r4, ptr %r12.f0, align 8
  %r12.f1 = getelementptr i64, ptr %r12.ptr, i64 1
  store i64 %r5, ptr %r12.f1, align 8
  %r12.f2 = getelementptr i64, ptr %r12.ptr, i64 2
  store i64 %r6, ptr %r12.f2, align 8
  %r12.f3 = getelementptr i64, ptr %r12.ptr, i64 3
  store i64 %r7, ptr %r12.f3, align 8
  %r12.f4 = getelementptr i64, ptr %r12.ptr, i64 4
  store i64 %r9, ptr %r12.f4, align 8
  %r12.f5 = getelementptr i64, ptr %r12.ptr, i64 5
  store i64 %r10, ptr %r12.f5, align 8
  %r12.f6 = getelementptr i64, ptr %r12.ptr, i64 6
  store i64 %r11, ptr %r12.f6, align 8
  %r12 = ptrtoint ptr %r12.ptr to i64
  %r13 = call i64 @ir_finish_block(i64 %r3, i64 %r12)
  br label %endif722
else721:
  br label %endif722
endif722:
  ret i64 0
}

define i64 @ir_lower_function(i64 %p0, i64 %p1) nounwind {
entry:
  %slot.b = alloca i64, align 8
  store i64 %p0, ptr %slot.b, align 8
  %slot.stmt = alloca i64, align 8
  store i64 %p1, ptr %slot.stmt, align 8
  ret i64 0
}

define i64 @ir_reg_type(i64 %p0, i64 %p1) nounwind {
entry:
  %slot.reg_types = alloca i64, align 8
  store i64 %p0, ptr %slot.reg_types, align 8
  %slot.reg = alloca i64, align 8
  store i64 %p1, ptr %slot.reg, align 8
  %r0 = load i64, ptr %slot.reg_types, align 8
  %r1 = load i64, ptr %slot.reg, align 8
  %r2 = call i64 @nova_rt_contains(i64 %r0, i64 %r1)
  %br_then723 = icmp ne i64 %r2, 0
  br i1 %br_then723, label %then723, label %else724
then723:
  %r3 = load i64, ptr %slot.reg_types, align 8
  %r4 = load i64, ptr %slot.reg, align 8
  %r5 = call i64 @nova_rt_index_get(i64 %r3, i64 %r4)
  ret i64 %r5
else724:
  br label %endif725
endif725:
  %r6.p = getelementptr inbounds [4 x i8], ptr @.str.345, i64 0, i64 0
  %r6 = ptrtoint ptr %r6.p to i64
  ret i64 0
}

define i64 @ir_infer_one(i64 %p0, i64 %p1, i64 %p2) nounwind {
entry:
  %slot.rt = alloca i64, align 8
  store i64 %p0, ptr %slot.rt, align 8
  %slot.st = alloca i64, align 8
  store i64 %p1, ptr %slot.st, align 8
  %slot.inst = alloca i64, align 8
  store i64 %p2, ptr %slot.inst, align 8
  ret i64 0
}

define i64 @ir_infer_block(i64 %p0, i64 %p1, i64 %p2) nounwind {
entry:
  %slot.rt = alloca i64, align 8
  store i64 %p0, ptr %slot.rt, align 8
  %slot.st = alloca i64, align 8
  store i64 %p1, ptr %slot.st, align 8
  %slot.block = alloca i64, align 8
  store i64 %p2, ptr %slot.block, align 8
  ret i64 0
}

define i64 @ir_infer_types(i64 %p0) nounwind {
entry:
  %slot.func = alloca i64, align 8
  store i64 %p0, ptr %slot.func, align 8
  ret i64 0
}

define i64 @new_ir_emitter() nounwind {
entry:
  %r0 = call i64 @nova_rt_list_create()
  %r1 = call i64 @nova_rt_list_create()
  %r2 = call i64 @nova_rt_dict_create()
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

define i64 @ire_line(i64 %p0, i64 %p1) nounwind {
entry:
  %slot.e = alloca i64, align 8
  store i64 %p0, ptr %slot.e, align 8
  %slot.line = alloca i64, align 8
  store i64 %p1, ptr %slot.line, align 8
  %r0 = add i64 0, 0
  %r1 = load i64, ptr %slot.line, align 8
  %r2 = call i64 @nova_rt_list_append(i64 %r0, i64 %r1)
  ret i64 0
}

define i64 @ire_indent(i64 %p0, i64 %p1) nounwind {
entry:
  %slot.e = alloca i64, align 8
  store i64 %p0, ptr %slot.e, align 8
  %slot.line = alloca i64, align 8
  store i64 %p1, ptr %slot.line, align 8
  %r0 = add i64 0, 0
  %r1.p = getelementptr inbounds [3 x i8], ptr @.str.136, i64 0, i64 0
  %r1 = ptrtoint ptr %r1.p to i64
  %r2 = load i64, ptr %slot.line, align 8
  %r3 = call i64 @nova_rt_str_concat(i64 %r1, i64 %r2)
  %r4 = call i64 @nova_rt_list_append(i64 %r0, i64 %r3)
  ret i64 0
}

define i64 @ire_intern_string(i64 %p0, i64 %p1) nounwind {
entry:
  %slot.e = alloca i64, align 8
  store i64 %p0, ptr %slot.e, align 8
  %slot.s = alloca i64, align 8
  store i64 %p1, ptr %slot.s, align 8
  %slot.escaped = alloca i64, align 8
  store i64 0, ptr %slot.escaped, align 8
  %slot.name = alloca i64, align 8
  store i64 0, ptr %slot.name, align 8
  %slot.byte_len = alloca i64, align 8
  store i64 0, ptr %slot.byte_len, align 8
  %r0 = add i64 0, 0
  %r1 = load i64, ptr %slot.s, align 8
  %r2 = call i64 @nova_rt_contains(i64 %r0, i64 %r1)
  %br_then726 = icmp ne i64 %r2, 0
  br i1 %br_then726, label %then726, label %else727
then726:
  %r3 = add i64 0, 0
  %r4 = load i64, ptr %slot.s, align 8
  %r5 = call i64 @nova_rt_index_get(i64 %r3, i64 %r4)
  ret i64 %r5
else727:
  br label %endif728
endif728:
  %r6 = load i64, ptr %slot.s, align 8
  %r7 = call i64 @llvm_escape_string(i64 %r6)
  store i64 %r7, ptr %slot.escaped, align 8
  %r8.p = getelementptr inbounds [7 x i8], ptr @.str.323, i64 0, i64 0
  %r8 = ptrtoint ptr %r8.p to i64
  %r9 = add i64 0, 0
  %r10 = call i64 @nova_rt_int_to_str(i64 %r9)
  %r11 = call i64 @nova_rt_str_concat(i64 %r8, i64 %r10)
  store i64 %r11, ptr %slot.name, align 8
  %r12 = add i64 0, 0
  %r13 = add i64 1, 0
  %r14 = add i64 %r12, %r13
  %r15 = load i64, ptr %slot.e, align 8
  %r16.ptr = inttoptr i64 %r15 to ptr
  %r16.gep = getelementptr i64, ptr %r16.ptr, i64 3
  store i64 %r14, ptr %r16.gep, align 8
  %r17 = load i64, ptr %slot.s, align 8
  %r18 = call i64 @nova_rt_len_any(i64 %r17)
  %r19 = add i64 1, 0
  %r20 = add i64 %r18, %r19
  store i64 %r20, ptr %slot.byte_len, align 8
  %r21 = add i64 0, 0
  %r22 = load i64, ptr %slot.name, align 8
  %r23.p = getelementptr inbounds [35 x i8], ptr @.str.324, i64 0, i64 0
  %r23 = ptrtoint ptr %r23.p to i64
  %r24 = call i64 @nova_rt_str_concat(i64 %r22, i64 %r23)
  %r25 = load i64, ptr %slot.byte_len, align 8
  %r26 = call i64 @nova_rt_int_to_str(i64 %r25)
  %r27 = call i64 @nova_rt_str_concat(i64 %r24, i64 %r26)
  %r28.p = getelementptr inbounds [10 x i8], ptr @.str.325, i64 0, i64 0
  %r28 = ptrtoint ptr %r28.p to i64
  %r29 = call i64 @nova_rt_str_concat(i64 %r27, i64 %r28)
  %r30 = load i64, ptr %slot.escaped, align 8
  %r31 = call i64 @nova_rt_str_concat(i64 %r29, i64 %r30)
  %r32.p = getelementptr inbounds [5 x i8], ptr @.str.326, i64 0, i64 0
  %r32 = ptrtoint ptr %r32.p to i64
  %r33 = call i64 @nova_rt_str_concat(i64 %r31, i64 %r32)
  %r34 = call i64 @nova_rt_list_append(i64 %r21, i64 %r33)
  %r35 = load i64, ptr %slot.name, align 8
  %r36 = add i64 0, 0
  %r37 = load i64, ptr %slot.s, align 8
  call i64 @nova_rt_index_set(i64 %r36, i64 %r37, i64 %r35)
  %r38 = load i64, ptr %slot.name, align 8
  ret i64 0
}

define i64 @ire_emit_inst(i64 %p0, i64 %p1) nounwind {
entry:
  %slot.e = alloca i64, align 8
  store i64 %p0, ptr %slot.e, align 8
  %slot.inst = alloca i64, align 8
  store i64 %p1, ptr %slot.inst, align 8
  ret i64 0
}

define i64 @ire_emit_terminator(i64 %p0, i64 %p1) nounwind {
entry:
  %slot.e = alloca i64, align 8
  store i64 %p0, ptr %slot.e, align 8
  %slot.term = alloca i64, align 8
  store i64 %p1, ptr %slot.term, align 8
  ret i64 0
}

define i64 @ire_collect_slots(i64 %p0, i64 %p1) nounwind {
entry:
  %slot.blocks = alloca i64, align 8
  store i64 %p0, ptr %slot.blocks, align 8
  %slot.param_names = alloca i64, align 8
  store i64 %p1, ptr %slot.param_names, align 8
  %slot.slots = alloca i64, align 8
  store i64 0, ptr %slot.slots, align 8
  %slot.__for_idx_729 = alloca i64, align 8
  store i64 0, ptr %slot.__for_idx_729, align 8
  %slot.block = alloca i64, align 8
  store i64 0, ptr %slot.block, align 8
  %r0 = call i64 @nova_rt_list_create()
  store i64 %r0, ptr %slot.slots, align 8
  %r1 = load i64, ptr %slot.blocks, align 8
  %r2 = call i64 @nova_rt_len_any(i64 %r1)
  %r3 = add i64 0, 0
  store i64 %r3, ptr %slot.__for_idx_729, align 8
  br label %for_hdr729
for_hdr729:
  %r4 = load i64, ptr %slot.__for_idx_729, align 8
  %r5.cmp = icmp slt i64 %r4, %r2
  %r5 = zext i1 %r5.cmp to i64
  %br_for_body730 = icmp ne i64 %r5, 0
  br i1 %br_for_body730, label %for_body730, label %for_exit731
for_body730:
  %r6 = call i64 @nova_rt_index_get(i64 %r1, i64 %r4)
  store i64 %r6, ptr %slot.block, align 8
  %r7 = load i64, ptr %slot.__for_idx_729, align 8
  %r8 = add i64 1, 0
  %r9 = add i64 %r7, %r8
  store i64 %r9, ptr %slot.__for_idx_729, align 8
  br label %for_hdr729
for_exit731:
  %r10 = load i64, ptr %slot.slots, align 8
  ret i64 0
}

define i64 @ire_emit_function(i64 %p0, i64 %p1) nounwind {
entry:
  %slot.e = alloca i64, align 8
  store i64 %p0, ptr %slot.e, align 8
  %slot.func = alloca i64, align 8
  store i64 %p1, ptr %slot.func, align 8
  ret i64 0
}

define i64 @compile(i64 %p0) nounwind {
entry:
  %slot.source = alloca i64, align 8
  store i64 %p0, ptr %slot.source, align 8
  %slot.tokens = alloca i64, align 8
  store i64 0, ptr %slot.tokens, align 8
  %slot.stmts = alloca i64, align 8
  store i64 0, ptr %slot.stmts, align 8
  %slot.cg = alloca i64, align 8
  store i64 0, ptr %slot.cg, align 8
  %slot.functions = alloca i64, align 8
  store i64 0, ptr %slot.functions, align 8
  %slot.top_stmts = alloca i64, align 8
  store i64 0, ptr %slot.top_stmts, align 8
  %slot.__for_idx_732 = alloca i64, align 8
  store i64 0, ptr %slot.__for_idx_732, align 8
  %slot.s = alloca i64, align 8
  store i64 0, ptr %slot.s, align 8
  %slot.__for_idx_735 = alloca i64, align 8
  store i64 0, ptr %slot.__for_idx_735, align 8
  %slot.fn_stmt = alloca i64, align 8
  store i64 0, ptr %slot.fn_stmt, align 8
  %r0 = load i64, ptr %slot.source, align 8
  %r1 = call i64 @tokenize(i64 %r0)
  store i64 %r1, ptr %slot.tokens, align 8
  %r2 = load i64, ptr %slot.tokens, align 8
  %r3 = call i64 @parse_program(i64 %r2)
  store i64 %r3, ptr %slot.stmts, align 8
  %r4 = call i64 @new_codegen()
  store i64 %r4, ptr %slot.cg, align 8
  %r5 = call i64 @nova_rt_list_create()
  store i64 %r5, ptr %slot.functions, align 8
  %r6 = call i64 @nova_rt_list_create()
  store i64 %r6, ptr %slot.top_stmts, align 8
  %r7 = load i64, ptr %slot.stmts, align 8
  %r8 = call i64 @nova_rt_len_any(i64 %r7)
  %r9 = add i64 0, 0
  store i64 %r9, ptr %slot.__for_idx_732, align 8
  br label %for_hdr732
for_hdr732:
  %r10 = load i64, ptr %slot.__for_idx_732, align 8
  %r11.cmp = icmp slt i64 %r10, %r8
  %r11 = zext i1 %r11.cmp to i64
  %br_for_body733 = icmp ne i64 %r11, 0
  br i1 %br_for_body733, label %for_body733, label %for_exit734
for_body733:
  %r12 = call i64 @nova_rt_index_get(i64 %r7, i64 %r10)
  store i64 %r12, ptr %slot.s, align 8
  %r13 = load i64, ptr %slot.__for_idx_732, align 8
  %r14 = add i64 1, 0
  %r15 = add i64 %r13, %r14
  store i64 %r15, ptr %slot.__for_idx_732, align 8
  br label %for_hdr732
for_exit734:
  %r16 = load i64, ptr %slot.cg, align 8
  %r17 = call i64 @emit_module_header(i64 %r16)
  %r18 = load i64, ptr %slot.cg, align 8
  %r19 = call i64 @emit_runtime_declarations(i64 %r18)
  %r20 = load i64, ptr %slot.functions, align 8
  %r21 = call i64 @nova_rt_len_any(i64 %r20)
  %r22 = add i64 0, 0
  store i64 %r22, ptr %slot.__for_idx_735, align 8
  br label %for_hdr735
for_hdr735:
  %r23 = load i64, ptr %slot.__for_idx_735, align 8
  %r24.cmp = icmp slt i64 %r23, %r21
  %r24 = zext i1 %r24.cmp to i64
  %br_for_body736 = icmp ne i64 %r24, 0
  br i1 %br_for_body736, label %for_body736, label %for_exit737
for_body736:
  %r25 = call i64 @nova_rt_index_get(i64 %r20, i64 %r23)
  store i64 %r25, ptr %slot.fn_stmt, align 8
  %r26 = load i64, ptr %slot.cg, align 8
  %r27 = load i64, ptr %slot.fn_stmt, align 8
  %r28 = call i64 @emit_function(i64 %r26, i64 %r27)
  %r29 = load i64, ptr %slot.__for_idx_735, align 8
  %r30 = add i64 1, 0
  %r31 = add i64 %r29, %r30
  store i64 %r31, ptr %slot.__for_idx_735, align 8
  br label %for_hdr735
for_exit737:
  %r32 = load i64, ptr %slot.cg, align 8
  %r33 = load i64, ptr %slot.top_stmts, align 8
  %r34 = call i64 @emit_nova_main(i64 %r32, i64 %r33)
  %r35 = load i64, ptr %slot.cg, align 8
  %r36 = call i64 @emit_main_entry(i64 %r35)
  %r37 = load i64, ptr %slot.cg, align 8
  %r38 = call i64 @emit_string_constants(i64 %r37)
  %r39 = add i64 0, 0
  %r40.p = getelementptr inbounds [2 x i8], ptr @.str.36, i64 0, i64 0
  %r40 = ptrtoint ptr %r40.p to i64
  %r41 = call i64 @nova_rt_join(i64 %r39, i64 %r40)
  ret i64 0
}

define i64 @compile_ir(i64 %p0) nounwind {
entry:
  %slot.source = alloca i64, align 8
  store i64 %p0, ptr %slot.source, align 8
  %slot.tokens = alloca i64, align 8
  store i64 0, ptr %slot.tokens, align 8
  %slot.stmts = alloca i64, align 8
  store i64 0, ptr %slot.stmts, align 8
  %slot.b = alloca i64, align 8
  store i64 0, ptr %slot.b, align 8
  %slot.e = alloca i64, align 8
  store i64 0, ptr %slot.e, align 8
  %slot.functions = alloca i64, align 8
  store i64 0, ptr %slot.functions, align 8
  %slot.top_stmts = alloca i64, align 8
  store i64 0, ptr %slot.top_stmts, align 8
  %slot.__for_idx_738 = alloca i64, align 8
  store i64 0, ptr %slot.__for_idx_738, align 8
  %slot.s = alloca i64, align 8
  store i64 0, ptr %slot.s, align 8
  %slot.__for_idx_741 = alloca i64, align 8
  store i64 0, ptr %slot.__for_idx_741, align 8
  %slot.fn_stmt = alloca i64, align 8
  store i64 0, ptr %slot.fn_stmt, align 8
  %slot.ir_fn = alloca i64, align 8
  store i64 0, ptr %slot.ir_fn, align 8
  %slot.typed_fn = alloca i64, align 8
  store i64 0, ptr %slot.typed_fn, align 8
  %slot.__for_idx_744 = alloca i64, align 8
  store i64 0, ptr %slot.__for_idx_744, align 8
  %slot.main_fn = alloca i64, align 8
  store i64 0, ptr %slot.main_fn, align 8
  %slot.typed_main = alloca i64, align 8
  store i64 0, ptr %slot.typed_main, align 8
  %slot.__for_idx_753 = alloca i64, align 8
  store i64 0, ptr %slot.__for_idx_753, align 8
  %slot.sc = alloca i64, align 8
  store i64 0, ptr %slot.sc, align 8
  %r0 = load i64, ptr %slot.source, align 8
  %r1 = call i64 @tokenize(i64 %r0)
  store i64 %r1, ptr %slot.tokens, align 8
  %r2 = load i64, ptr %slot.tokens, align 8
  %r3 = call i64 @parse_program(i64 %r2)
  store i64 %r3, ptr %slot.stmts, align 8
  %r4 = call i64 @new_ir_builder()
  store i64 %r4, ptr %slot.b, align 8
  %r5 = call i64 @new_ir_emitter()
  store i64 %r5, ptr %slot.e, align 8
  %r6 = call i64 @nova_rt_list_create()
  store i64 %r6, ptr %slot.functions, align 8
  %r7 = call i64 @nova_rt_list_create()
  store i64 %r7, ptr %slot.top_stmts, align 8
  %r8 = load i64, ptr %slot.stmts, align 8
  %r9 = call i64 @nova_rt_len_any(i64 %r8)
  %r10 = add i64 0, 0
  store i64 %r10, ptr %slot.__for_idx_738, align 8
  br label %for_hdr738
for_hdr738:
  %r11 = load i64, ptr %slot.__for_idx_738, align 8
  %r12.cmp = icmp slt i64 %r11, %r9
  %r12 = zext i1 %r12.cmp to i64
  %br_for_body739 = icmp ne i64 %r12, 0
  br i1 %br_for_body739, label %for_body739, label %for_exit740
for_body739:
  %r13 = call i64 @nova_rt_index_get(i64 %r8, i64 %r11)
  store i64 %r13, ptr %slot.s, align 8
  %r14 = load i64, ptr %slot.__for_idx_738, align 8
  %r15 = add i64 1, 0
  %r16 = add i64 %r14, %r15
  store i64 %r16, ptr %slot.__for_idx_738, align 8
  br label %for_hdr738
for_exit740:
  %r17 = load i64, ptr %slot.e, align 8
  %r18.p = getelementptr inbounds [35 x i8], ptr @.str.350, i64 0, i64 0
  %r18 = ptrtoint ptr %r18.p to i64
  %r19 = call i64 @ire_line(i64 %r17, i64 %r18)
  %r20 = load i64, ptr %slot.e, align 8
  %r21.p = getelementptr inbounds [102 x i8], ptr @.str.264, i64 0, i64 0
  %r21 = ptrtoint ptr %r21.p to i64
  %r22 = call i64 @ire_line(i64 %r20, i64 %r21)
  %r23 = load i64, ptr %slot.e, align 8
  %r24.p = getelementptr inbounds [1 x i8], ptr @.str.42, i64 0, i64 0
  %r24 = ptrtoint ptr %r24.p to i64
  %r25 = call i64 @ire_line(i64 %r23, i64 %r24)
  %r26 = load i64, ptr %slot.e, align 8
  %r27.p = getelementptr inbounds [47 x i8], ptr @.str.265, i64 0, i64 0
  %r27 = ptrtoint ptr %r27.p to i64
  %r28 = call i64 @ire_line(i64 %r26, i64 %r27)
  %r29 = load i64, ptr %slot.e, align 8
  %r30.p = getelementptr inbounds [46 x i8], ptr @.str.266, i64 0, i64 0
  %r30 = ptrtoint ptr %r30.p to i64
  %r31 = call i64 @ire_line(i64 %r29, i64 %r30)
  %r32 = load i64, ptr %slot.e, align 8
  %r33.p = getelementptr inbounds [1 x i8], ptr @.str.42, i64 0, i64 0
  %r33 = ptrtoint ptr %r33.p to i64
  %r34 = call i64 @ire_line(i64 %r32, i64 %r33)
  %r35 = load i64, ptr %slot.e, align 8
  %r36.p = getelementptr inbounds [23 x i8], ptr @.str.267, i64 0, i64 0
  %r36 = ptrtoint ptr %r36.p to i64
  %r37 = call i64 @ire_line(i64 %r35, i64 %r36)
  %r38 = load i64, ptr %slot.e, align 8
  %r39.p = getelementptr inbounds [32 x i8], ptr @.str.268, i64 0, i64 0
  %r39 = ptrtoint ptr %r39.p to i64
  %r40 = call i64 @ire_line(i64 %r38, i64 %r39)
  %r41 = load i64, ptr %slot.e, align 8
  %r42.p = getelementptr inbounds [39 x i8], ptr @.str.269, i64 0, i64 0
  %r42 = ptrtoint ptr %r42.p to i64
  %r43 = call i64 @ire_line(i64 %r41, i64 %r42)
  %r44 = load i64, ptr %slot.e, align 8
  %r45.p = getelementptr inbounds [44 x i8], ptr @.str.270, i64 0, i64 0
  %r45 = ptrtoint ptr %r45.p to i64
  %r46 = call i64 @ire_line(i64 %r44, i64 %r45)
  %r47 = load i64, ptr %slot.e, align 8
  %r48.p = getelementptr inbounds [52 x i8], ptr @.str.271, i64 0, i64 0
  %r48 = ptrtoint ptr %r48.p to i64
  %r49 = call i64 @ire_line(i64 %r47, i64 %r48)
  %r50 = load i64, ptr %slot.e, align 8
  %r51.p = getelementptr inbounds [49 x i8], ptr @.str.272, i64 0, i64 0
  %r51 = ptrtoint ptr %r51.p to i64
  %r52 = call i64 @ire_line(i64 %r50, i64 %r51)
  %r53 = load i64, ptr %slot.e, align 8
  %r54.p = getelementptr inbounds [44 x i8], ptr @.str.273, i64 0, i64 0
  %r54 = ptrtoint ptr %r54.p to i64
  %r55 = call i64 @ire_line(i64 %r53, i64 %r54)
  %r56 = load i64, ptr %slot.e, align 8
  %r57.p = getelementptr inbounds [44 x i8], ptr @.str.274, i64 0, i64 0
  %r57 = ptrtoint ptr %r57.p to i64
  %r58 = call i64 @ire_line(i64 %r56, i64 %r57)
  %r59 = load i64, ptr %slot.e, align 8
  %r60.p = getelementptr inbounds [54 x i8], ptr @.str.275, i64 0, i64 0
  %r60 = ptrtoint ptr %r60.p to i64
  %r61 = call i64 @ire_line(i64 %r59, i64 %r60)
  %r62 = load i64, ptr %slot.e, align 8
  %r63.p = getelementptr inbounds [49 x i8], ptr @.str.276, i64 0, i64 0
  %r63 = ptrtoint ptr %r63.p to i64
  %r64 = call i64 @ire_line(i64 %r62, i64 %r63)
  %r65 = load i64, ptr %slot.e, align 8
  %r66.p = getelementptr inbounds [54 x i8], ptr @.str.277, i64 0, i64 0
  %r66 = ptrtoint ptr %r66.p to i64
  %r67 = call i64 @ire_line(i64 %r65, i64 %r66)
  %r68 = load i64, ptr %slot.e, align 8
  %r69.p = getelementptr inbounds [51 x i8], ptr @.str.278, i64 0, i64 0
  %r69 = ptrtoint ptr %r69.p to i64
  %r70 = call i64 @ire_line(i64 %r68, i64 %r69)
  %r71 = load i64, ptr %slot.e, align 8
  %r72.p = getelementptr inbounds [46 x i8], ptr @.str.279, i64 0, i64 0
  %r72 = ptrtoint ptr %r72.p to i64
  %r73 = call i64 @ire_line(i64 %r71, i64 %r72)
  %r74 = load i64, ptr %slot.e, align 8
  %r75.p = getelementptr inbounds [45 x i8], ptr @.str.280, i64 0, i64 0
  %r75 = ptrtoint ptr %r75.p to i64
  %r76 = call i64 @ire_line(i64 %r74, i64 %r75)
  %r77 = load i64, ptr %slot.e, align 8
  %r78.p = getelementptr inbounds [39 x i8], ptr @.str.281, i64 0, i64 0
  %r78 = ptrtoint ptr %r78.p to i64
  %r79 = call i64 @ire_line(i64 %r77, i64 %r78)
  %r80 = load i64, ptr %slot.e, align 8
  %r81.p = getelementptr inbounds [43 x i8], ptr @.str.282, i64 0, i64 0
  %r81 = ptrtoint ptr %r81.p to i64
  %r82 = call i64 @ire_line(i64 %r80, i64 %r81)
  %r83 = load i64, ptr %slot.e, align 8
  %r84.p = getelementptr inbounds [39 x i8], ptr @.str.283, i64 0, i64 0
  %r84 = ptrtoint ptr %r84.p to i64
  %r85 = call i64 @ire_line(i64 %r83, i64 %r84)
  %r86 = load i64, ptr %slot.e, align 8
  %r87.p = getelementptr inbounds [39 x i8], ptr @.str.284, i64 0, i64 0
  %r87 = ptrtoint ptr %r87.p to i64
  %r88 = call i64 @ire_line(i64 %r86, i64 %r87)
  %r89 = load i64, ptr %slot.e, align 8
  %r90.p = getelementptr inbounds [49 x i8], ptr @.str.285, i64 0, i64 0
  %r90 = ptrtoint ptr %r90.p to i64
  %r91 = call i64 @ire_line(i64 %r89, i64 %r90)
  %r92 = load i64, ptr %slot.e, align 8
  %r93.p = getelementptr inbounds [50 x i8], ptr @.str.286, i64 0, i64 0
  %r93 = ptrtoint ptr %r93.p to i64
  %r94 = call i64 @ire_line(i64 %r92, i64 %r93)
  %r95 = load i64, ptr %slot.e, align 8
  %r96.p = getelementptr inbounds [55 x i8], ptr @.str.287, i64 0, i64 0
  %r96 = ptrtoint ptr %r96.p to i64
  %r97 = call i64 @ire_line(i64 %r95, i64 %r96)
  %r98 = load i64, ptr %slot.e, align 8
  %r99.p = getelementptr inbounds [44 x i8], ptr @.str.288, i64 0, i64 0
  %r99 = ptrtoint ptr %r99.p to i64
  %r100 = call i64 @ire_line(i64 %r98, i64 %r99)
  %r101 = load i64, ptr %slot.e, align 8
  %r102.p = getelementptr inbounds [44 x i8], ptr @.str.351, i64 0, i64 0
  %r102 = ptrtoint ptr %r102.p to i64
  %r103 = call i64 @ire_line(i64 %r101, i64 %r102)
  %r104 = load i64, ptr %slot.e, align 8
  %r105.p = getelementptr inbounds [44 x i8], ptr @.str.352, i64 0, i64 0
  %r105 = ptrtoint ptr %r105.p to i64
  %r106 = call i64 @ire_line(i64 %r104, i64 %r105)
  %r107 = load i64, ptr %slot.e, align 8
  %r108.p = getelementptr inbounds [44 x i8], ptr @.str.353, i64 0, i64 0
  %r108 = ptrtoint ptr %r108.p to i64
  %r109 = call i64 @ire_line(i64 %r107, i64 %r108)
  %r110 = load i64, ptr %slot.e, align 8
  %r111.p = getelementptr inbounds [43 x i8], ptr @.str.289, i64 0, i64 0
  %r111 = ptrtoint ptr %r111.p to i64
  %r112 = call i64 @ire_line(i64 %r110, i64 %r111)
  %r113 = load i64, ptr %slot.e, align 8
  %r114.p = getelementptr inbounds [44 x i8], ptr @.str.290, i64 0, i64 0
  %r114 = ptrtoint ptr %r114.p to i64
  %r115 = call i64 @ire_line(i64 %r113, i64 %r114)
  %r116 = load i64, ptr %slot.e, align 8
  %r117.p = getelementptr inbounds [46 x i8], ptr @.str.291, i64 0, i64 0
  %r117 = ptrtoint ptr %r117.p to i64
  %r118 = call i64 @ire_line(i64 %r116, i64 %r117)
  %r119 = load i64, ptr %slot.e, align 8
  %r120.p = getelementptr inbounds [48 x i8], ptr @.str.292, i64 0, i64 0
  %r120 = ptrtoint ptr %r120.p to i64
  %r121 = call i64 @ire_line(i64 %r119, i64 %r120)
  %r122 = load i64, ptr %slot.e, align 8
  %r123.p = getelementptr inbounds [45 x i8], ptr @.str.293, i64 0, i64 0
  %r123 = ptrtoint ptr %r123.p to i64
  %r124 = call i64 @ire_line(i64 %r122, i64 %r123)
  %r125 = load i64, ptr %slot.e, align 8
  %r126.p = getelementptr inbounds [51 x i8], ptr @.str.294, i64 0, i64 0
  %r126 = ptrtoint ptr %r126.p to i64
  %r127 = call i64 @ire_line(i64 %r125, i64 %r126)
  %r128 = load i64, ptr %slot.e, align 8
  %r129.p = getelementptr inbounds [37 x i8], ptr @.str.295, i64 0, i64 0
  %r129 = ptrtoint ptr %r129.p to i64
  %r130 = call i64 @ire_line(i64 %r128, i64 %r129)
  %r131 = load i64, ptr %slot.e, align 8
  %r132.p = getelementptr inbounds [41 x i8], ptr @.str.296, i64 0, i64 0
  %r132 = ptrtoint ptr %r132.p to i64
  %r133 = call i64 @ire_line(i64 %r131, i64 %r132)
  %r134 = load i64, ptr %slot.e, align 8
  %r135.p = getelementptr inbounds [46 x i8], ptr @.str.297, i64 0, i64 0
  %r135 = ptrtoint ptr %r135.p to i64
  %r136 = call i64 @ire_line(i64 %r134, i64 %r135)
  %r137 = load i64, ptr %slot.e, align 8
  %r138.p = getelementptr inbounds [45 x i8], ptr @.str.298, i64 0, i64 0
  %r138 = ptrtoint ptr %r138.p to i64
  %r139 = call i64 @ire_line(i64 %r137, i64 %r138)
  %r140 = load i64, ptr %slot.e, align 8
  %r141.p = getelementptr inbounds [41 x i8], ptr @.str.299, i64 0, i64 0
  %r141 = ptrtoint ptr %r141.p to i64
  %r142 = call i64 @ire_line(i64 %r140, i64 %r141)
  %r143 = load i64, ptr %slot.e, align 8
  %r144.p = getelementptr inbounds [41 x i8], ptr @.str.300, i64 0, i64 0
  %r144 = ptrtoint ptr %r144.p to i64
  %r145 = call i64 @ire_line(i64 %r143, i64 %r144)
  %r146 = load i64, ptr %slot.e, align 8
  %r147.p = getelementptr inbounds [40 x i8], ptr @.str.301, i64 0, i64 0
  %r147 = ptrtoint ptr %r147.p to i64
  %r148 = call i64 @ire_line(i64 %r146, i64 %r147)
  %r149 = load i64, ptr %slot.e, align 8
  %r150.p = getelementptr inbounds [53 x i8], ptr @.str.302, i64 0, i64 0
  %r150 = ptrtoint ptr %r150.p to i64
  %r151 = call i64 @ire_line(i64 %r149, i64 %r150)
  %r152 = load i64, ptr %slot.e, align 8
  %r153.p = getelementptr inbounds [52 x i8], ptr @.str.303, i64 0, i64 0
  %r153 = ptrtoint ptr %r153.p to i64
  %r154 = call i64 @ire_line(i64 %r152, i64 %r153)
  %r155 = load i64, ptr %slot.e, align 8
  %r156.p = getelementptr inbounds [50 x i8], ptr @.str.304, i64 0, i64 0
  %r156 = ptrtoint ptr %r156.p to i64
  %r157 = call i64 @ire_line(i64 %r155, i64 %r156)
  %r158 = load i64, ptr %slot.e, align 8
  %r159.p = getelementptr inbounds [45 x i8], ptr @.str.305, i64 0, i64 0
  %r159 = ptrtoint ptr %r159.p to i64
  %r160 = call i64 @ire_line(i64 %r158, i64 %r159)
  %r161 = load i64, ptr %slot.e, align 8
  %r162.p = getelementptr inbounds [46 x i8], ptr @.str.306, i64 0, i64 0
  %r162 = ptrtoint ptr %r162.p to i64
  %r163 = call i64 @ire_line(i64 %r161, i64 %r162)
  %r164 = load i64, ptr %slot.e, align 8
  %r165.p = getelementptr inbounds [48 x i8], ptr @.str.307, i64 0, i64 0
  %r165 = ptrtoint ptr %r165.p to i64
  %r166 = call i64 @ire_line(i64 %r164, i64 %r165)
  %r167 = load i64, ptr %slot.e, align 8
  %r168.p = getelementptr inbounds [51 x i8], ptr @.str.308, i64 0, i64 0
  %r168 = ptrtoint ptr %r168.p to i64
  %r169 = call i64 @ire_line(i64 %r167, i64 %r168)
  %r170 = load i64, ptr %slot.e, align 8
  %r171.p = getelementptr inbounds [47 x i8], ptr @.str.309, i64 0, i64 0
  %r171 = ptrtoint ptr %r171.p to i64
  %r172 = call i64 @ire_line(i64 %r170, i64 %r171)
  %r173 = load i64, ptr %slot.e, align 8
  %r174.p = getelementptr inbounds [41 x i8], ptr @.str.310, i64 0, i64 0
  %r174 = ptrtoint ptr %r174.p to i64
  %r175 = call i64 @ire_line(i64 %r173, i64 %r174)
  %r176 = load i64, ptr %slot.e, align 8
  %r177.p = getelementptr inbounds [40 x i8], ptr @.str.311, i64 0, i64 0
  %r177 = ptrtoint ptr %r177.p to i64
  %r178 = call i64 @ire_line(i64 %r176, i64 %r177)
  %r179 = load i64, ptr %slot.e, align 8
  %r180.p = getelementptr inbounds [44 x i8], ptr @.str.312, i64 0, i64 0
  %r180 = ptrtoint ptr %r180.p to i64
  %r181 = call i64 @ire_line(i64 %r179, i64 %r180)
  %r182 = load i64, ptr %slot.e, align 8
  %r183.p = getelementptr inbounds [41 x i8], ptr @.str.313, i64 0, i64 0
  %r183 = ptrtoint ptr %r183.p to i64
  %r184 = call i64 @ire_line(i64 %r182, i64 %r183)
  %r185 = load i64, ptr %slot.e, align 8
  %r186.p = getelementptr inbounds [43 x i8], ptr @.str.314, i64 0, i64 0
  %r186 = ptrtoint ptr %r186.p to i64
  %r187 = call i64 @ire_line(i64 %r185, i64 %r186)
  %r188 = load i64, ptr %slot.e, align 8
  %r189.p = getelementptr inbounds [46 x i8], ptr @.str.315, i64 0, i64 0
  %r189 = ptrtoint ptr %r189.p to i64
  %r190 = call i64 @ire_line(i64 %r188, i64 %r189)
  %r191 = load i64, ptr %slot.e, align 8
  %r192.p = getelementptr inbounds [40 x i8], ptr @.str.316, i64 0, i64 0
  %r192 = ptrtoint ptr %r192.p to i64
  %r193 = call i64 @ire_line(i64 %r191, i64 %r192)
  %r194 = load i64, ptr %slot.e, align 8
  %r195.p = getelementptr inbounds [45 x i8], ptr @.str.317, i64 0, i64 0
  %r195 = ptrtoint ptr %r195.p to i64
  %r196 = call i64 @ire_line(i64 %r194, i64 %r195)
  %r197 = load i64, ptr %slot.e, align 8
  %r198.p = getelementptr inbounds [47 x i8], ptr @.str.318, i64 0, i64 0
  %r198 = ptrtoint ptr %r198.p to i64
  %r199 = call i64 @ire_line(i64 %r197, i64 %r198)
  %r200 = load i64, ptr %slot.e, align 8
  %r201.p = getelementptr inbounds [49 x i8], ptr @.str.319, i64 0, i64 0
  %r201 = ptrtoint ptr %r201.p to i64
  %r202 = call i64 @ire_line(i64 %r200, i64 %r201)
  %r203 = load i64, ptr %slot.e, align 8
  %r204.p = getelementptr inbounds [51 x i8], ptr @.str.320, i64 0, i64 0
  %r204 = ptrtoint ptr %r204.p to i64
  %r205 = call i64 @ire_line(i64 %r203, i64 %r204)
  %r206 = load i64, ptr %slot.e, align 8
  %r207.p = getelementptr inbounds [41 x i8], ptr @.str.321, i64 0, i64 0
  %r207 = ptrtoint ptr %r207.p to i64
  %r208 = call i64 @ire_line(i64 %r206, i64 %r207)
  %r209 = load i64, ptr %slot.e, align 8
  %r210.p = getelementptr inbounds [1 x i8], ptr @.str.42, i64 0, i64 0
  %r210 = ptrtoint ptr %r210.p to i64
  %r211 = call i64 @ire_line(i64 %r209, i64 %r210)
  %r212 = load i64, ptr %slot.functions, align 8
  %r213 = call i64 @nova_rt_len_any(i64 %r212)
  %r214 = add i64 0, 0
  store i64 %r214, ptr %slot.__for_idx_741, align 8
  br label %for_hdr741
for_hdr741:
  %r215 = load i64, ptr %slot.__for_idx_741, align 8
  %r216.cmp = icmp slt i64 %r215, %r213
  %r216 = zext i1 %r216.cmp to i64
  %br_for_body742 = icmp ne i64 %r216, 0
  br i1 %br_for_body742, label %for_body742, label %for_exit743
for_body742:
  %r217 = call i64 @nova_rt_index_get(i64 %r212, i64 %r215)
  store i64 %r217, ptr %slot.fn_stmt, align 8
  %r218 = load i64, ptr %slot.b, align 8
  %r219 = load i64, ptr %slot.fn_stmt, align 8
  %r220 = call i64 @ir_lower_function(i64 %r218, i64 %r219)
  store i64 %r220, ptr %slot.ir_fn, align 8
  %r221 = load i64, ptr %slot.ir_fn, align 8
  %r222 = call i64 @ir_infer_types(i64 %r221)
  store i64 %r222, ptr %slot.typed_fn, align 8
  %r223 = load i64, ptr %slot.e, align 8
  %r224 = load i64, ptr %slot.typed_fn, align 8
  %r225 = call i64 @ire_emit_function(i64 %r223, i64 %r224)
  %r226 = load i64, ptr %slot.__for_idx_741, align 8
  %r227 = add i64 1, 0
  %r228 = add i64 %r226, %r227
  store i64 %r228, ptr %slot.__for_idx_741, align 8
  br label %for_hdr741
for_exit743:
  %r229 = call i64 @nova_rt_list_create()
  %r230 = load i64, ptr %slot.b, align 8
  %r231.ptr = inttoptr i64 %r230 to ptr
  %r231.gep = getelementptr i64, ptr %r231.ptr, i64 0
  store i64 %r229, ptr %r231.gep, align 8
  %r232 = call i64 @nova_rt_list_create()
  %r233 = load i64, ptr %slot.b, align 8
  %r234.ptr = inttoptr i64 %r233 to ptr
  %r234.gep = getelementptr i64, ptr %r234.ptr, i64 2
  store i64 %r232, ptr %r234.gep, align 8
  %r235.p = getelementptr inbounds [6 x i8], ptr @.str.347, i64 0, i64 0
  %r235 = ptrtoint ptr %r235.p to i64
  %r236 = load i64, ptr %slot.b, align 8
  %r237.ptr = inttoptr i64 %r236 to ptr
  %r237.gep = getelementptr i64, ptr %r237.ptr, i64 3
  store i64 %r235, ptr %r237.gep, align 8
  %r238 = add i64 0, 0
  %r239 = load i64, ptr %slot.b, align 8
  %r240.ptr = inttoptr i64 %r239 to ptr
  %r240.gep = getelementptr i64, ptr %r240.ptr, i64 1
  store i64 %r238, ptr %r240.gep, align 8
  %r241 = load i64, ptr %slot.top_stmts, align 8
  %r242 = call i64 @nova_rt_len_any(i64 %r241)
  %r243 = add i64 0, 0
  store i64 %r243, ptr %slot.__for_idx_744, align 8
  br label %for_hdr744
for_hdr744:
  %r244 = load i64, ptr %slot.__for_idx_744, align 8
  %r245.cmp = icmp slt i64 %r244, %r242
  %r245 = zext i1 %r245.cmp to i64
  %br_for_body745 = icmp ne i64 %r245, 0
  br i1 %br_for_body745, label %for_body745, label %for_exit746
for_body745:
  %r246 = call i64 @nova_rt_index_get(i64 %r241, i64 %r244)
  store i64 %r246, ptr %slot.s, align 8
  %r247 = load i64, ptr %slot.b, align 8
  %r248 = load i64, ptr %slot.s, align 8
  %r249 = call i64 @ir_lower_stmt(i64 %r247, i64 %r248)
  %r250 = load i64, ptr %slot.__for_idx_744, align 8
  %r251 = add i64 1, 0
  %r252 = add i64 %r250, %r251
  store i64 %r252, ptr %slot.__for_idx_744, align 8
  br label %for_hdr744
for_exit746:
  %r253 = load i64, ptr %slot.b, align 8
  %r254 = call i64 @ir_flush_pending_block(i64 %r253)
  %r255 = add i64 0, 0
  %r256 = call i64 @nova_rt_len_any(i64 %r255)
  %r257 = add i64 0, 0
  %r258.cmp = icmp eq i64 %r256, %r257
  %r258 = zext i1 %r258.cmp to i64
  %br_then747 = icmp ne i64 %r258, 0
  br i1 %br_then747, label %then747, label %else748
then747:
  %r259 = load i64, ptr %slot.b, align 8
  %r260.p = getelementptr inbounds [7 x i8], ptr @.str.5, i64 0, i64 0
  %r260 = ptrtoint ptr %r260.p to i64
  %r261.p = getelementptr inbounds [1 x i8], ptr @.str.42, i64 0, i64 0
  %r261 = ptrtoint ptr %r261.p to i64
  %r262 = call i64 @ir_type_void()
  %r264.p = getelementptr inbounds [2 x i8], ptr @.str.55, i64 0, i64 0
  %r264 = ptrtoint ptr %r264.p to i64
  %r263 = call i64 @nova_rt_list_create()
  call i64 @nova_rt_list_append(i64 %r263, i64 %r264)
  %r265.p = getelementptr inbounds [1 x i8], ptr @.str.42, i64 0, i64 0
  %r265 = ptrtoint ptr %r265.p to i64
  %r266 = add i64 0, 0
  %r267.p = getelementptr inbounds [5 x i8], ptr @.str.348, i64 0, i64 0
  %r267 = ptrtoint ptr %r267.p to i64
  %r268.ptr = call ptr @nova_rt_struct_alloc(i64 56)
  %r268.f0 = getelementptr i64, ptr %r268.ptr, i64 0
  store i64 %r260, ptr %r268.f0, align 8
  %r268.f1 = getelementptr i64, ptr %r268.ptr, i64 1
  store i64 %r261, ptr %r268.f1, align 8
  %r268.f2 = getelementptr i64, ptr %r268.ptr, i64 2
  store i64 %r262, ptr %r268.f2, align 8
  %r268.f3 = getelementptr i64, ptr %r268.ptr, i64 3
  store i64 %r263, ptr %r268.f3, align 8
  %r268.f4 = getelementptr i64, ptr %r268.ptr, i64 4
  store i64 %r265, ptr %r268.f4, align 8
  %r268.f5 = getelementptr i64, ptr %r268.ptr, i64 5
  store i64 %r266, ptr %r268.f5, align 8
  %r268.f6 = getelementptr i64, ptr %r268.ptr, i64 6
  store i64 %r267, ptr %r268.f6, align 8
  %r268 = ptrtoint ptr %r268.ptr to i64
  %r269 = call i64 @ir_finish_block(i64 %r259, i64 %r268)
  br label %endif749
else748:
  br label %endif749
endif749:
  %r270.p = getelementptr inbounds [10 x i8], ptr @.str.354, i64 0, i64 0
  %r270 = ptrtoint ptr %r270.p to i64
  %r271 = call i64 @nova_rt_list_create()
  %r272 = call i64 @ir_type_any()
  %r273 = add i64 0, 0
  %r274 = call i64 @nova_rt_list_create()
  %r275 = add i64 0, 0
  %r276.ptr = call ptr @nova_rt_struct_alloc(i64 48)
  %r276.f0 = getelementptr i64, ptr %r276.ptr, i64 0
  store i64 %r270, ptr %r276.f0, align 8
  %r276.f1 = getelementptr i64, ptr %r276.ptr, i64 1
  store i64 %r271, ptr %r276.f1, align 8
  %r276.f2 = getelementptr i64, ptr %r276.ptr, i64 2
  store i64 %r272, ptr %r276.f2, align 8
  %r276.f3 = getelementptr i64, ptr %r276.ptr, i64 3
  store i64 %r273, ptr %r276.f3, align 8
  %r276.f4 = getelementptr i64, ptr %r276.ptr, i64 4
  store i64 %r274, ptr %r276.f4, align 8
  %r276.f5 = getelementptr i64, ptr %r276.ptr, i64 5
  store i64 %r275, ptr %r276.f5, align 8
  %r276 = ptrtoint ptr %r276.ptr to i64
  store i64 %r276, ptr %slot.main_fn, align 8
  %r277 = load i64, ptr %slot.main_fn, align 8
  %r278 = call i64 @ir_infer_types(i64 %r277)
  store i64 %r278, ptr %slot.typed_main, align 8
  %r279 = load i64, ptr %slot.e, align 8
  %r280 = load i64, ptr %slot.typed_main, align 8
  %r281 = call i64 @ire_emit_function(i64 %r279, i64 %r280)
  %r282 = load i64, ptr %slot.e, align 8
  %r283.p = getelementptr inbounds [50 x i8], ptr @.str.332, i64 0, i64 0
  %r283 = ptrtoint ptr %r283.p to i64
  %r284 = call i64 @ire_line(i64 %r282, i64 %r283)
  %r285 = load i64, ptr %slot.e, align 8
  %r286.p = getelementptr inbounds [7 x i8], ptr @.str.328, i64 0, i64 0
  %r286 = ptrtoint ptr %r286.p to i64
  %r287 = call i64 @ire_line(i64 %r285, i64 %r286)
  %r288 = load i64, ptr %slot.e, align 8
  %r289.p = getelementptr inbounds [32 x i8], ptr @.str.333, i64 0, i64 0
  %r289 = ptrtoint ptr %r289.p to i64
  %r290 = call i64 @ire_indent(i64 %r288, i64 %r289)
  %r291 = load i64, ptr %slot.e, align 8
  %r292.p = getelementptr inbounds [36 x i8], ptr @.str.334, i64 0, i64 0
  %r292 = ptrtoint ptr %r292.p to i64
  %r293 = call i64 @ire_indent(i64 %r291, i64 %r292)
  %r294 = load i64, ptr %slot.e, align 8
  %r295.p = getelementptr inbounds [55 x i8], ptr @.str.335, i64 0, i64 0
  %r295 = ptrtoint ptr %r295.p to i64
  %r296 = call i64 @ire_indent(i64 %r294, i64 %r295)
  %r297 = load i64, ptr %slot.e, align 8
  %r298.p = getelementptr inbounds [22 x i8], ptr @.str.336, i64 0, i64 0
  %r298 = ptrtoint ptr %r298.p to i64
  %r299 = call i64 @ire_indent(i64 %r297, i64 %r298)
  %r300 = load i64, ptr %slot.e, align 8
  %r301.p = getelementptr inbounds [29 x i8], ptr @.str.337, i64 0, i64 0
  %r301 = ptrtoint ptr %r301.p to i64
  %r302 = call i64 @ire_indent(i64 %r300, i64 %r301)
  %r303 = load i64, ptr %slot.e, align 8
  %r304.p = getelementptr inbounds [10 x i8], ptr @.str.338, i64 0, i64 0
  %r304 = ptrtoint ptr %r304.p to i64
  %r305 = call i64 @ire_indent(i64 %r303, i64 %r304)
  %r306 = load i64, ptr %slot.e, align 8
  %r307.p = getelementptr inbounds [2 x i8], ptr @.str.64, i64 0, i64 0
  %r307 = ptrtoint ptr %r307.p to i64
  %r308 = call i64 @ire_line(i64 %r306, i64 %r307)
  %r309 = load i64, ptr %slot.e, align 8
  %r310.p = getelementptr inbounds [1 x i8], ptr @.str.42, i64 0, i64 0
  %r310 = ptrtoint ptr %r310.p to i64
  %r311 = call i64 @ire_line(i64 %r309, i64 %r310)
  %r312 = add i64 0, 0
  %r313 = call i64 @nova_rt_len_any(i64 %r312)
  %r314 = add i64 0, 0
  %r315.cmp = icmp sgt i64 %r313, %r314
  %r315 = zext i1 %r315.cmp to i64
  %br_then750 = icmp ne i64 %r315, 0
  br i1 %br_then750, label %then750, label %else751
then750:
  %r316 = load i64, ptr %slot.e, align 8
  %r317.p = getelementptr inbounds [19 x i8], ptr @.str.322, i64 0, i64 0
  %r317 = ptrtoint ptr %r317.p to i64
  %r318 = call i64 @ire_line(i64 %r316, i64 %r317)
  %r319 = add i64 0, 0
  %r320 = call i64 @nova_rt_len_any(i64 %r319)
  %r321 = add i64 0, 0
  store i64 %r321, ptr %slot.__for_idx_753, align 8
  br label %for_hdr753
for_hdr753:
  %r322 = load i64, ptr %slot.__for_idx_753, align 8
  %r323.cmp = icmp slt i64 %r322, %r320
  %r323 = zext i1 %r323.cmp to i64
  %br_for_body754 = icmp ne i64 %r323, 0
  br i1 %br_for_body754, label %for_body754, label %for_exit755
for_body754:
  %r324 = call i64 @nova_rt_index_get(i64 %r319, i64 %r322)
  store i64 %r324, ptr %slot.sc, align 8
  %r325 = load i64, ptr %slot.e, align 8
  %r326 = load i64, ptr %slot.sc, align 8
  %r327 = call i64 @ire_line(i64 %r325, i64 %r326)
  %r328 = load i64, ptr %slot.__for_idx_753, align 8
  %r329 = add i64 1, 0
  %r330 = add i64 %r328, %r329
  store i64 %r330, ptr %slot.__for_idx_753, align 8
  br label %for_hdr753
for_exit755:
  %r331 = load i64, ptr %slot.e, align 8
  %r332.p = getelementptr inbounds [1 x i8], ptr @.str.42, i64 0, i64 0
  %r332 = ptrtoint ptr %r332.p to i64
  %r333 = call i64 @ire_line(i64 %r331, i64 %r332)
  br label %endif752
else751:
  br label %endif752
endif752:
  %r334 = add i64 0, 0
  %r335.p = getelementptr inbounds [2 x i8], ptr @.str.36, i64 0, i64 0
  %r335 = ptrtoint ptr %r335.p to i64
  %r336 = call i64 @nova_rt_join(i64 %r334, i64 %r335)
  ret i64 0
}

define i64 @compiler_main() nounwind {
entry:
  %slot.arguments = alloca i64, align 8
  store i64 0, ptr %slot.arguments, align 8
  %slot.use_ir = alloca i64, align 8
  store i64 0, ptr %slot.use_ir, align 8
  %slot.file_idx = alloca i64, align 8
  store i64 0, ptr %slot.file_idx, align 8
  %slot.input_path = alloca i64, align 8
  store i64 0, ptr %slot.input_path, align 8
  %slot.output_path = alloca i64, align 8
  store i64 0, ptr %slot.output_path, align 8
  %slot.source = alloca i64, align 8
  store i64 0, ptr %slot.source, align 8
  %slot.llvm_ir = alloca i64, align 8
  store i64 0, ptr %slot.llvm_ir, align 8
  %r0 = call i64 @nova_rt_args()
  store i64 %r0, ptr %slot.arguments, align 8
  %r1 = load i64, ptr %slot.arguments, align 8
  %r2 = call i64 @nova_rt_len_any(i64 %r1)
  %r3 = add i64 2, 0
  %r4.cmp = icmp slt i64 %r2, %r3
  %r4 = zext i1 %r4.cmp to i64
  %br_then756 = icmp ne i64 %r4, 0
  br i1 %br_then756, label %then756, label %else757
then756:
  %r5.p = getelementptr inbounds [53 x i8], ptr @.str.355, i64 0, i64 0
  %r5 = ptrtoint ptr %r5.p to i64
  %r6 = call i64 @nova_rt_print_any(i64 %r5)
  %r7 = add i64 1, 0
  %r8 = call i64 @nova_rt_exit(i64 %r7)
  br label %endif758
else757:
  br label %endif758
endif758:
  %r9 = add i64 0, 0
  store i64 %r9, ptr %slot.use_ir, align 8
  %r10 = add i64 1, 0
  store i64 %r10, ptr %slot.file_idx, align 8
  %r11 = load i64, ptr %slot.arguments, align 8
  %r12 = add i64 1, 0
  %r13 = call i64 @nova_rt_index_get(i64 %r11, i64 %r12)
  %r14.p = getelementptr inbounds [5 x i8], ptr @.str.356, i64 0, i64 0
  %r14 = ptrtoint ptr %r14.p to i64
  %r15 = call i64 @nova_rt_eq(i64 %r13, i64 %r14)
  %br_then759 = icmp ne i64 %r15, 0
  br i1 %br_then759, label %then759, label %else760
then759:
  %r16 = add i64 1, 0
  store i64 %r16, ptr %slot.use_ir, align 8
  %r17 = add i64 2, 0
  store i64 %r17, ptr %slot.file_idx, align 8
  br label %endif761
else760:
  br label %endif761
endif761:
  %r18 = load i64, ptr %slot.file_idx, align 8
  %r19 = load i64, ptr %slot.arguments, align 8
  %r20 = call i64 @nova_rt_len_any(i64 %r19)
  %r21.cmp = icmp sge i64 %r18, %r20
  %r21 = zext i1 %r21.cmp to i64
  %br_then762 = icmp ne i64 %r21, 0
  br i1 %br_then762, label %then762, label %else763
then762:
  %r22.p = getelementptr inbounds [53 x i8], ptr @.str.355, i64 0, i64 0
  %r22 = ptrtoint ptr %r22.p to i64
  %r23 = call i64 @nova_rt_print_any(i64 %r22)
  %r24 = add i64 1, 0
  %r25 = call i64 @nova_rt_exit(i64 %r24)
  br label %endif764
else763:
  br label %endif764
endif764:
  %r26 = load i64, ptr %slot.arguments, align 8
  %r27 = load i64, ptr %slot.file_idx, align 8
  %r28 = call i64 @nova_rt_index_get(i64 %r26, i64 %r27)
  store i64 %r28, ptr %slot.input_path, align 8
  %r29 = add i64 0, 0
  store i64 %r29, ptr %slot.output_path, align 8
  %r30 = load i64, ptr %slot.input_path, align 8
  %r31 = call i64 @nova_rt_read_file(i64 %r30)
  store i64 %r31, ptr %slot.source, align 8
  %r32 = add i64 0, 0
  store i64 %r32, ptr %slot.llvm_ir, align 8
  %r33 = load i64, ptr %slot.output_path, align 8
  %r34 = load i64, ptr %slot.llvm_ir, align 8
  %r35 = call i64 @nova_rt_write_file(i64 %r33, i64 %r34)
  %r36 = load i64, ptr %slot.use_ir, align 8
  %br_then765 = icmp ne i64 %r36, 0
  br i1 %br_then765, label %then765, label %else766
then765:
  %r37.p = getelementptr inbounds [16 x i8], ptr @.str.357, i64 0, i64 0
  %r37 = ptrtoint ptr %r37.p to i64
  %r38 = load i64, ptr %slot.input_path, align 8
  %r39 = call i64 @nova_rt_str_concat(i64 %r37, i64 %r38)
  %r40.p = getelementptr inbounds [5 x i8], ptr @.str.358, i64 0, i64 0
  %r40 = ptrtoint ptr %r40.p to i64
  %r41 = call i64 @nova_rt_str_concat(i64 %r39, i64 %r40)
  %r42 = load i64, ptr %slot.output_path, align 8
  %r43 = call i64 @nova_rt_str_concat(i64 %r41, i64 %r42)
  %r44 = call i64 @nova_rt_print_any(i64 %r43)
  br label %endif767
else766:
  %r45.p = getelementptr inbounds [11 x i8], ptr @.str.359, i64 0, i64 0
  %r45 = ptrtoint ptr %r45.p to i64
  %r46 = load i64, ptr %slot.input_path, align 8
  %r47 = call i64 @nova_rt_str_concat(i64 %r45, i64 %r46)
  %r48.p = getelementptr inbounds [5 x i8], ptr @.str.358, i64 0, i64 0
  %r48 = ptrtoint ptr %r48.p to i64
  %r49 = call i64 @nova_rt_str_concat(i64 %r47, i64 %r48)
  %r50 = load i64, ptr %slot.output_path, align 8
  %r51 = call i64 @nova_rt_str_concat(i64 %r49, i64 %r50)
  %r52 = call i64 @nova_rt_print_any(i64 %r51)
  br label %endif767
endif767:
  ret i64 0
}

define i64 @run_self_test() nounwind {
entry:
  %slot.tokens = alloca i64, align 8
  store i64 0, ptr %slot.tokens, align 8
  %slot.non_nl = alloca i64, align 8
  store i64 0, ptr %slot.non_nl, align 8
  %slot.__for_idx_768 = alloca i64, align 8
  store i64 0, ptr %slot.__for_idx_768, align 8
  %slot.t = alloca i64, align 8
  store i64 0, ptr %slot.t, align 8
  %slot.tokens2 = alloca i64, align 8
  store i64 0, ptr %slot.tokens2, align 8
  %slot.stmts = alloca i64, align 8
  store i64 0, ptr %slot.stmts, align 8
  %slot.source = alloca i64, align 8
  store i64 0, ptr %slot.source, align 8
  %slot.result = alloca i64, align 8
  store i64 0, ptr %slot.result, align 8
  %slot.fn_source = alloca i64, align 8
  store i64 0, ptr %slot.fn_source, align 8
  %slot.fn_result = alloca i64, align 8
  store i64 0, ptr %slot.fn_result, align 8
  %slot.str_source = alloca i64, align 8
  store i64 0, ptr %slot.str_source, align 8
  %slot.str_result = alloca i64, align 8
  store i64 0, ptr %slot.str_result, align 8
  %r0.p = getelementptr inbounds [15 x i8], ptr @.str.360, i64 0, i64 0
  %r0 = ptrtoint ptr %r0.p to i64
  %r1 = call i64 @tokenize(i64 %r0)
  store i64 %r1, ptr %slot.tokens, align 8
  %r2 = call i64 @nova_rt_list_create()
  store i64 %r2, ptr %slot.non_nl, align 8
  %r3 = load i64, ptr %slot.tokens, align 8
  %r4 = call i64 @nova_rt_len_any(i64 %r3)
  %r5 = add i64 0, 0
  store i64 %r5, ptr %slot.__for_idx_768, align 8
  br label %for_hdr768
for_hdr768:
  %r6 = load i64, ptr %slot.__for_idx_768, align 8
  %r7.cmp = icmp slt i64 %r6, %r4
  %r7 = zext i1 %r7.cmp to i64
  %br_for_body769 = icmp ne i64 %r7, 0
  br i1 %br_for_body769, label %for_body769, label %for_exit770
for_body769:
  %r8 = call i64 @nova_rt_index_get(i64 %r3, i64 %r6)
  store i64 %r8, ptr %slot.t, align 8
  %r9 = load i64, ptr %slot.__for_idx_768, align 8
  %r10 = add i64 1, 0
  %r11 = add i64 %r9, %r10
  store i64 %r11, ptr %slot.__for_idx_768, align 8
  br label %for_hdr768
for_exit770:
  %r12 = load i64, ptr %slot.non_nl, align 8
  %r13 = call i64 @nova_rt_len_any(i64 %r12)
  %r14 = add i64 6, 0
  %r15.cmp = icmp eq i64 %r13, %r14
  %r15 = zext i1 %r15.cmp to i64
  %r16.p = getelementptr inbounds [31 x i8], ptr @.str.361, i64 0, i64 0
  %r16 = ptrtoint ptr %r16.p to i64
  %r17 = load i64, ptr %slot.non_nl, align 8
  %r18 = call i64 @nova_rt_len_any(i64 %r17)
  %r19 = call i64 @nova_rt_int_to_str(i64 %r18)
  %r20 = call i64 @nova_rt_str_concat(i64 %r16, i64 %r19)
  %r21 = call i64 @nova_rt_assert(i64 %r15, i64 %r20)
  %r22.p = getelementptr inbounds [26 x i8], ptr @.str.362, i64 0, i64 0
  %r22 = ptrtoint ptr %r22.p to i64
  %r23 = call i64 @tokenize(i64 %r22)
  store i64 %r23, ptr %slot.tokens2, align 8
  %r24 = load i64, ptr %slot.tokens2, align 8
  %r25 = call i64 @parse_program(i64 %r24)
  store i64 %r25, ptr %slot.stmts, align 8
  %r26 = load i64, ptr %slot.stmts, align 8
  %r27 = call i64 @nova_rt_len_any(i64 %r26)
  %r28 = add i64 3, 0
  %r29.cmp = icmp eq i64 %r27, %r28
  %r29 = zext i1 %r29.cmp to i64
  %r30.p = getelementptr inbounds [31 x i8], ptr @.str.363, i64 0, i64 0
  %r30 = ptrtoint ptr %r30.p to i64
  %r31 = load i64, ptr %slot.stmts, align 8
  %r32 = call i64 @nova_rt_len_any(i64 %r31)
  %r33 = call i64 @nova_rt_int_to_str(i64 %r32)
  %r34 = call i64 @nova_rt_str_concat(i64 %r30, i64 %r33)
  %r35 = call i64 @nova_rt_assert(i64 %r29, i64 %r34)
  %r36.p = getelementptr inbounds [16 x i8], ptr @.str.364, i64 0, i64 0
  %r36 = ptrtoint ptr %r36.p to i64
  store i64 %r36, ptr %slot.source, align 8
  %r37 = load i64, ptr %slot.source, align 8
  %r38 = call i64 @compile(i64 %r37)
  store i64 %r38, ptr %slot.result, align 8
  %r39 = load i64, ptr %slot.result, align 8
  %r40.p = getelementptr inbounds [22 x i8], ptr @.str.365, i64 0, i64 0
  %r40 = ptrtoint ptr %r40.p to i64
  %r41 = call i64 @nova_rt_contains(i64 %r39, i64 %r40)
  %r42.p = getelementptr inbounds [23 x i8], ptr @.str.366, i64 0, i64 0
  %r42 = ptrtoint ptr %r42.p to i64
  %r43 = call i64 @nova_rt_assert(i64 %r41, i64 %r42)
  %r44 = load i64, ptr %slot.result, align 8
  %r45.p = getelementptr inbounds [18 x i8], ptr @.str.195, i64 0, i64 0
  %r45 = ptrtoint ptr %r45.p to i64
  %r46 = call i64 @nova_rt_contains(i64 %r44, i64 %r45)
  %r47.p = getelementptr inbounds [24 x i8], ptr @.str.367, i64 0, i64 0
  %r47 = ptrtoint ptr %r47.p to i64
  %r48 = call i64 @nova_rt_assert(i64 %r46, i64 %r47)
  %r49.p = getelementptr inbounds [63 x i8], ptr @.str.368, i64 0, i64 0
  %r49 = ptrtoint ptr %r49.p to i64
  store i64 %r49, ptr %slot.fn_source, align 8
  %r50 = load i64, ptr %slot.fn_source, align 8
  %r51 = call i64 @compile(i64 %r50)
  store i64 %r51, ptr %slot.fn_result, align 8
  %r52 = load i64, ptr %slot.fn_result, align 8
  %r53.p = getelementptr inbounds [16 x i8], ptr @.str.369, i64 0, i64 0
  %r53 = ptrtoint ptr %r53.p to i64
  %r54 = call i64 @nova_rt_contains(i64 %r52, i64 %r53)
  %r55.p = getelementptr inbounds [27 x i8], ptr @.str.370, i64 0, i64 0
  %r55 = ptrtoint ptr %r55.p to i64
  %r56 = call i64 @nova_rt_assert(i64 %r54, i64 %r55)
  %r57.p = getelementptr inbounds [21 x i8], ptr @.str.371, i64 0, i64 0
  %r57 = ptrtoint ptr %r57.p to i64
  store i64 %r57, ptr %slot.str_source, align 8
  %r58 = load i64, ptr %slot.str_source, align 8
  %r59 = call i64 @compile(i64 %r58)
  store i64 %r59, ptr %slot.str_result, align 8
  %r60 = load i64, ptr %slot.str_result, align 8
  %r61.p = getelementptr inbounds [7 x i8], ptr @.str.323, i64 0, i64 0
  %r61 = ptrtoint ptr %r61.p to i64
  %r62 = call i64 @nova_rt_contains(i64 %r60, i64 %r61)
  %r63.p = getelementptr inbounds [29 x i8], ptr @.str.372, i64 0, i64 0
  %r63 = ptrtoint ptr %r63.p to i64
  %r64 = call i64 @nova_rt_assert(i64 %r62, i64 %r63)
  %r65 = load i64, ptr %slot.str_result, align 8
  %r66.p = getelementptr inbounds [18 x i8], ptr @.str.195, i64 0, i64 0
  %r66 = ptrtoint ptr %r66.p to i64
  %r67 = call i64 @nova_rt_contains(i64 %r65, i64 %r66)
  %r68.p = getelementptr inbounds [27 x i8], ptr @.str.373, i64 0, i64 0
  %r68 = ptrtoint ptr %r68.p to i64
  %r69 = call i64 @nova_rt_assert(i64 %r67, i64 %r68)
  %r70.p = getelementptr inbounds [45 x i8], ptr @.str.374, i64 0, i64 0
  %r70 = ptrtoint ptr %r70.p to i64
  %r71 = call i64 @nova_rt_print_any(i64 %r70)
  ret i64 0
}

define i64 @nova_main() nounwind {
entry:
  %slot.arguments = alloca i64, align 8
  store i64 0, ptr %slot.arguments, align 8
  %r0 = call i64 @nova_rt_args()
  store i64 %r0, ptr %slot.arguments, align 8
  %r1 = load i64, ptr %slot.arguments, align 8
  %r2 = call i64 @nova_rt_len_any(i64 %r1)
  %r3 = add i64 2, 0
  %r4.cmp = icmp sge i64 %r2, %r3
  %r4 = zext i1 %r4.cmp to i64
  %br_then771 = icmp ne i64 %r4, 0
  br i1 %br_then771, label %then771, label %else772
then771:
  %r5 = call i64 @compiler_main()
  br label %endif773
else772:
  %r6 = call i64 @run_self_test()
  br label %endif773
endif773:
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
@.str.4 = private unnamed_addr constant [3 x i8] c"fn\00"
@.str.5 = private unnamed_addr constant [7 x i8] c"return\00"
@.str.6 = private unnamed_addr constant [3 x i8] c"if\00"
@.str.7 = private unnamed_addr constant [5 x i8] c"else\00"
@.str.8 = private unnamed_addr constant [4 x i8] c"for\00"
@.str.9 = private unnamed_addr constant [6 x i8] c"while\00"
@.str.10 = private unnamed_addr constant [6 x i8] c"match\00"
@.str.11 = private unnamed_addr constant [6 x i8] c"break\00"
@.str.12 = private unnamed_addr constant [9 x i8] c"continue\00"
@.str.13 = private unnamed_addr constant [5 x i8] c"type\00"
@.str.14 = private unnamed_addr constant [5 x i8] c"enum\00"
@.str.15 = private unnamed_addr constant [6 x i8] c"spawn\00"
@.str.16 = private unnamed_addr constant [5 x i8] c"send\00"
@.str.17 = private unnamed_addr constant [8 x i8] c"receive\00"
@.str.18 = private unnamed_addr constant [8 x i8] c"channel\00"
@.str.19 = private unnamed_addr constant [3 x i8] c"or\00"
@.str.20 = private unnamed_addr constant [4 x i8] c"and\00"
@.str.21 = private unnamed_addr constant [4 x i8] c"not\00"
@.str.22 = private unnamed_addr constant [5 x i8] c"copy\00"
@.str.23 = private unnamed_addr constant [7 x i8] c"import\00"
@.str.24 = private unnamed_addr constant [5 x i8] c"true\00"
@.str.25 = private unnamed_addr constant [6 x i8] c"false\00"
@.str.26 = private unnamed_addr constant [5 x i8] c"null\00"
@.str.27 = private unnamed_addr constant [3 x i8] c"in\00"
@.str.28 = private unnamed_addr constant [3 x i8] c"as\00"
@.str.29 = private unnamed_addr constant [7 x i8] c"select\00"
@.str.30 = private unnamed_addr constant [4 x i8] c"try\00"
@.str.31 = private unnamed_addr constant [6 x i8] c"catch\00"
@.str.32 = private unnamed_addr constant [6 x i8] c"trait\00"
@.str.33 = private unnamed_addr constant [8 x i8] c"matches\00"
@.str.34 = private unnamed_addr constant [6 x i8] c"yield\00"
@.str.35 = private unnamed_addr constant [4 x i8] c"let\00"
@.str.36 = private unnamed_addr constant [2 x i8] c"\0A\00"
@.str.37 = private unnamed_addr constant [8 x i8] c"NEWLINE\00"
@.str.38 = private unnamed_addr constant [3 x i8] c"\\n\00"
@.str.39 = private unnamed_addr constant [2 x i8] c"/\00"
@.str.40 = private unnamed_addr constant [2 x i8] c"@\00"
@.str.41 = private unnamed_addr constant [3 x i8] c"AT\00"
@.str.42 = private unnamed_addr constant [1 x i8] c"\00"
@.str.43 = private unnamed_addr constant [3 x i8] c"KW\00"
@.str.44 = private unnamed_addr constant [6 x i8] c"IDENT\00"
@.str.45 = private unnamed_addr constant [2 x i8] c".\00"
@.str.46 = private unnamed_addr constant [2 x i8] c"e\00"
@.str.47 = private unnamed_addr constant [2 x i8] c"E\00"
@.str.48 = private unnamed_addr constant [6 x i8] c"FLOAT\00"
@.str.49 = private unnamed_addr constant [4 x i8] c"INT\00"
@.str.50 = private unnamed_addr constant [2 x i8] c"\22\00"
@.str.51 = private unnamed_addr constant [2 x i8] c"\\\00"
@.str.52 = private unnamed_addr constant [2 x i8] c"n\00"
@.str.53 = private unnamed_addr constant [2 x i8] c"t\00"
@.str.54 = private unnamed_addr constant [2 x i8] c"r\00"
@.str.55 = private unnamed_addr constant [2 x i8] c"0\00"
@.str.56 = private unnamed_addr constant [4 x i8] c"STR\00"
@.str.57 = private unnamed_addr constant [2 x i8] c"`\00"
@.str.58 = private unnamed_addr constant [8 x i8] c"RAW_STR\00"
@.str.59 = private unnamed_addr constant [2 x i8] c"(\00"
@.str.60 = private unnamed_addr constant [2 x i8] c")\00"
@.str.61 = private unnamed_addr constant [2 x i8] c"[\00"
@.str.62 = private unnamed_addr constant [2 x i8] c"]\00"
@.str.63 = private unnamed_addr constant [2 x i8] c"{\00"
@.str.64 = private unnamed_addr constant [2 x i8] c"}\00"
@.str.65 = private unnamed_addr constant [6 x i8] c"DELIM\00"
@.str.66 = private unnamed_addr constant [2 x i8] c",\00"
@.str.67 = private unnamed_addr constant [6 x i8] c"COMMA\00"
@.str.68 = private unnamed_addr constant [2 x i8] c":\00"
@.str.69 = private unnamed_addr constant [6 x i8] c"COLON\00"
@.str.70 = private unnamed_addr constant [7 x i8] c"DOTDOT\00"
@.str.71 = private unnamed_addr constant [3 x i8] c"..\00"
@.str.72 = private unnamed_addr constant [4 x i8] c"DOT\00"
@.str.73 = private unnamed_addr constant [2 x i8] c"+\00"
@.str.74 = private unnamed_addr constant [2 x i8] c"=\00"
@.str.75 = private unnamed_addr constant [3 x i8] c"OP\00"
@.str.76 = private unnamed_addr constant [3 x i8] c"+=\00"
@.str.77 = private unnamed_addr constant [2 x i8] c"-\00"
@.str.78 = private unnamed_addr constant [2 x i8] c">\00"
@.str.79 = private unnamed_addr constant [6 x i8] c"ARROW\00"
@.str.80 = private unnamed_addr constant [3 x i8] c"->\00"
@.str.81 = private unnamed_addr constant [3 x i8] c"-=\00"
@.str.82 = private unnamed_addr constant [2 x i8] c"*\00"
@.str.83 = private unnamed_addr constant [3 x i8] c"**\00"
@.str.84 = private unnamed_addr constant [3 x i8] c"*=\00"
@.str.85 = private unnamed_addr constant [3 x i8] c"/=\00"
@.str.86 = private unnamed_addr constant [2 x i8] c"%\00"
@.str.87 = private unnamed_addr constant [3 x i8] c"%=\00"
@.str.88 = private unnamed_addr constant [3 x i8] c"==\00"
@.str.89 = private unnamed_addr constant [10 x i8] c"FAT_ARROW\00"
@.str.90 = private unnamed_addr constant [3 x i8] c"=>\00"
@.str.91 = private unnamed_addr constant [7 x i8] c"ASSIGN\00"
@.str.92 = private unnamed_addr constant [2 x i8] c"!\00"
@.str.93 = private unnamed_addr constant [3 x i8] c"!=\00"
@.str.94 = private unnamed_addr constant [2 x i8] c"<\00"
@.str.95 = private unnamed_addr constant [3 x i8] c"<=\00"
@.str.96 = private unnamed_addr constant [3 x i8] c"<<\00"
@.str.97 = private unnamed_addr constant [3 x i8] c">=\00"
@.str.98 = private unnamed_addr constant [3 x i8] c">>\00"
@.str.99 = private unnamed_addr constant [2 x i8] c"&\00"
@.str.100 = private unnamed_addr constant [2 x i8] c"|\00"
@.str.101 = private unnamed_addr constant [8 x i8] c"PIPE_GT\00"
@.str.102 = private unnamed_addr constant [3 x i8] c"|>\00"
@.str.103 = private unnamed_addr constant [2 x i8] c"^\00"
@.str.104 = private unnamed_addr constant [2 x i8] c"~\00"
@.str.105 = private unnamed_addr constant [2 x i8] c"?\00"
@.str.106 = private unnamed_addr constant [9 x i8] c"QUESTION\00"
@.str.107 = private unnamed_addr constant [4 x i8] c"EOF\00"
@.str.108 = private unnamed_addr constant [11 x i8] c"expected '\00"
@.str.109 = private unnamed_addr constant [8 x i8] c"' got '\00"
@.str.110 = private unnamed_addr constant [11 x i8] c"' at line \00"
@.str.111 = private unnamed_addr constant [7 x i8] c"member\00"
@.str.112 = private unnamed_addr constant [6 x i8] c"binop\00"
@.str.113 = private unnamed_addr constant [4 x i8] c"int\00"
@.str.114 = private unnamed_addr constant [6 x i8] c"float\00"
@.str.115 = private unnamed_addr constant [4 x i8] c"str\00"
@.str.116 = private unnamed_addr constant [5 x i8] c"bool\00"
@.str.117 = private unnamed_addr constant [6 x i8] c"ident\00"
@.str.118 = private unnamed_addr constant [6 x i8] c"unary\00"
@.str.119 = private unnamed_addr constant [6 x i8] c"tuple\00"
@.str.120 = private unnamed_addr constant [5 x i8] c"list\00"
@.str.121 = private unnamed_addr constant [5 x i8] c"pair\00"
@.str.122 = private unnamed_addr constant [5 x i8] c"dict\00"
@.str.123 = private unnamed_addr constant [33 x i8] c"unexpected token in expression: \00"
@.str.124 = private unnamed_addr constant [11 x i8] c") at line \00"
@.str.125 = private unnamed_addr constant [6 x i8] c"index\00"
@.str.126 = private unnamed_addr constant [4 x i8] c"arm\00"
@.str.127 = private unnamed_addr constant [8 x i8] c"pat_var\00"
@.str.128 = private unnamed_addr constant [9 x i8] c"pat_ctor\00"
@.str.129 = private unnamed_addr constant [9 x i8] c"pat_wild\00"
@.str.130 = private unnamed_addr constant [8 x i8] c"pat_lit\00"
@.str.131 = private unnamed_addr constant [8 x i8] c"pat_str\00"
@.str.132 = private unnamed_addr constant [6 x i8] c"block\00"
@.str.133 = private unnamed_addr constant [7 x i8] c"assign\00"
@.str.134 = private unnamed_addr constant [16 x i8] c"compound_assign\00"
@.str.135 = private unnamed_addr constant [5 x i8] c"expr\00"
@.str.136 = private unnamed_addr constant [3 x i8] c"  \00"
@.str.137 = private unnamed_addr constant [3 x i8] c"%r\00"
@.str.138 = private unnamed_addr constant [3 x i8] c"%t\00"
@.str.139 = private unnamed_addr constant [7 x i8] c"%slot.\00"
@.str.140 = private unnamed_addr constant [30 x i8] c" = call i64 @nova_rt_add(i64 \00"
@.str.141 = private unnamed_addr constant [7 x i8] c", i64 \00"
@.str.142 = private unnamed_addr constant [12 x i8] c" = sub i64 \00"
@.str.143 = private unnamed_addr constant [3 x i8] c", \00"
@.str.144 = private unnamed_addr constant [12 x i8] c" = mul i64 \00"
@.str.145 = private unnamed_addr constant [13 x i8] c" = sdiv i64 \00"
@.str.146 = private unnamed_addr constant [13 x i8] c" = srem i64 \00"
@.str.147 = private unnamed_addr constant [29 x i8] c" = call i64 @nova_rt_eq(i64 \00"
@.str.148 = private unnamed_addr constant [12 x i8] c" = and i64 \00"
@.str.149 = private unnamed_addr constant [4 x i8] c", 1\00"
@.str.150 = private unnamed_addr constant [30 x i8] c" = call i64 @nova_rt_neq(i64 \00"
@.str.151 = private unnamed_addr constant [17 x i8] c" = icmp slt i64 \00"
@.str.152 = private unnamed_addr constant [12 x i8] c" = zext i1 \00"
@.str.153 = private unnamed_addr constant [8 x i8] c" to i64\00"
@.str.154 = private unnamed_addr constant [17 x i8] c" = icmp sgt i64 \00"
@.str.155 = private unnamed_addr constant [17 x i8] c" = icmp sle i64 \00"
@.str.156 = private unnamed_addr constant [17 x i8] c" = icmp sge i64 \00"
@.str.157 = private unnamed_addr constant [10 x i8] c"and_entry\00"
@.str.158 = private unnamed_addr constant [11 x i8] c"br label %\00"
@.str.159 = private unnamed_addr constant [16 x i8] c" = icmp ne i64 \00"
@.str.160 = private unnamed_addr constant [4 x i8] c", 0\00"
@.str.161 = private unnamed_addr constant [8 x i8] c"and_rhs\00"
@.str.162 = private unnamed_addr constant [8 x i8] c"and_end\00"
@.str.163 = private unnamed_addr constant [7 x i8] c"br i1 \00"
@.str.164 = private unnamed_addr constant [10 x i8] c", label %\00"
@.str.165 = private unnamed_addr constant [9 x i8] c"and_done\00"
@.str.166 = private unnamed_addr constant [17 x i8] c" = phi i64 [0, %\00"
@.str.167 = private unnamed_addr constant [5 x i8] c"], [\00"
@.str.168 = private unnamed_addr constant [4 x i8] c", %\00"
@.str.169 = private unnamed_addr constant [9 x i8] c"or_entry\00"
@.str.170 = private unnamed_addr constant [7 x i8] c"or_rhs\00"
@.str.171 = private unnamed_addr constant [7 x i8] c"or_end\00"
@.str.172 = private unnamed_addr constant [8 x i8] c"or_done\00"
@.str.173 = private unnamed_addr constant [13 x i8] c" = phi i64 [\00"
@.str.174 = private unnamed_addr constant [4 x i8] c" = \00"
@.str.175 = private unnamed_addr constant [6 x i8] c" i64 \00"
@.str.176 = private unnamed_addr constant [12 x i8] c" = add i64 \00"
@.str.177 = private unnamed_addr constant [15 x i8] c" = sub i64 0, \00"
@.str.178 = private unnamed_addr constant [16 x i8] c" = icmp eq i64 \00"
@.str.179 = private unnamed_addr constant [12 x i8] c" = xor i64 \00"
@.str.180 = private unnamed_addr constant [5 x i8] c", -1\00"
@.str.181 = private unnamed_addr constant [39 x i8] c" = call ptr @nova_rt_struct_alloc(i64 \00"
@.str.182 = private unnamed_addr constant [27 x i8] c" = getelementptr i64, ptr \00"
@.str.183 = private unnamed_addr constant [11 x i8] c"store i64 \00"
@.str.184 = private unnamed_addr constant [7 x i8] c", ptr \00"
@.str.185 = private unnamed_addr constant [10 x i8] c", align 8\00"
@.str.186 = private unnamed_addr constant [17 x i8] c" = ptrtoint ptr \00"
@.str.187 = private unnamed_addr constant [5 x i8] c"i64 \00"
@.str.188 = private unnamed_addr constant [14 x i8] c" = call i64 @\00"
@.str.189 = private unnamed_addr constant [8 x i8] c"if_then\00"
@.str.190 = private unnamed_addr constant [8 x i8] c"if_else\00"
@.str.191 = private unnamed_addr constant [9 x i8] c"if_merge\00"
@.str.192 = private unnamed_addr constant [13 x i8] c"if_then_done\00"
@.str.193 = private unnamed_addr constant [13 x i8] c"if_else_done\00"
@.str.194 = private unnamed_addr constant [6 x i8] c"print\00"
@.str.195 = private unnamed_addr constant [18 x i8] c"nova_rt_print_any\00"
@.str.196 = private unnamed_addr constant [4 x i8] c"len\00"
@.str.197 = private unnamed_addr constant [16 x i8] c"nova_rt_len_any\00"
@.str.198 = private unnamed_addr constant [19 x i8] c"nova_rt_int_to_str\00"
@.str.199 = private unnamed_addr constant [18 x i8] c"nova_rt_parse_int\00"
@.str.200 = private unnamed_addr constant [5 x i8] c"push\00"
@.str.201 = private unnamed_addr constant [20 x i8] c"nova_rt_list_append\00"
@.str.202 = private unnamed_addr constant [4 x i8] c"ord\00"
@.str.203 = private unnamed_addr constant [12 x i8] c"nova_rt_ord\00"
@.str.204 = private unnamed_addr constant [4 x i8] c"chr\00"
@.str.205 = private unnamed_addr constant [12 x i8] c"nova_rt_chr\00"
@.str.206 = private unnamed_addr constant [7 x i8] c"assert\00"
@.str.207 = private unnamed_addr constant [15 x i8] c"nova_rt_assert\00"
@.str.208 = private unnamed_addr constant [9 x i8] c"contains\00"
@.str.209 = private unnamed_addr constant [17 x i8] c"nova_rt_contains\00"
@.str.210 = private unnamed_addr constant [10 x i8] c"read_file\00"
@.str.211 = private unnamed_addr constant [18 x i8] c"nova_rt_read_file\00"
@.str.212 = private unnamed_addr constant [11 x i8] c"write_file\00"
@.str.213 = private unnamed_addr constant [19 x i8] c"nova_rt_write_file\00"
@.str.214 = private unnamed_addr constant [5 x i8] c"args\00"
@.str.215 = private unnamed_addr constant [13 x i8] c"nova_rt_args\00"
@.str.216 = private unnamed_addr constant [5 x i8] c"exit\00"
@.str.217 = private unnamed_addr constant [13 x i8] c"nova_rt_exit\00"
@.str.218 = private unnamed_addr constant [6 x i8] c"split\00"
@.str.219 = private unnamed_addr constant [14 x i8] c"nova_rt_split\00"
@.str.220 = private unnamed_addr constant [5 x i8] c"join\00"
@.str.221 = private unnamed_addr constant [13 x i8] c"nova_rt_join\00"
@.str.222 = private unnamed_addr constant [6 x i8] c"upper\00"
@.str.223 = private unnamed_addr constant [14 x i8] c"nova_rt_upper\00"
@.str.224 = private unnamed_addr constant [6 x i8] c"lower\00"
@.str.225 = private unnamed_addr constant [14 x i8] c"nova_rt_lower\00"
@.str.226 = private unnamed_addr constant [5 x i8] c"trim\00"
@.str.227 = private unnamed_addr constant [13 x i8] c"nova_rt_trim\00"
@.str.228 = private unnamed_addr constant [8 x i8] c"replace\00"
@.str.229 = private unnamed_addr constant [16 x i8] c"nova_rt_replace\00"
@.str.230 = private unnamed_addr constant [12 x i8] c"starts_with\00"
@.str.231 = private unnamed_addr constant [20 x i8] c"nova_rt_starts_with\00"
@.str.232 = private unnamed_addr constant [10 x i8] c"ends_with\00"
@.str.233 = private unnamed_addr constant [18 x i8] c"nova_rt_ends_with\00"
@.str.234 = private unnamed_addr constant [7 x i8] c"filter\00"
@.str.235 = private unnamed_addr constant [20 x i8] c"nova_rt_list_filter\00"
@.str.236 = private unnamed_addr constant [4 x i8] c"map\00"
@.str.237 = private unnamed_addr constant [17 x i8] c"nova_rt_list_map\00"
@.str.238 = private unnamed_addr constant [11 x i8] c"float_bits\00"
@.str.239 = private unnamed_addr constant [19 x i8] c"nova_rt_float_bits\00"
@.str.240 = private unnamed_addr constant [6 x i8] c"slice\00"
@.str.241 = private unnamed_addr constant [14 x i8] c"nova_rt_slice\00"
@.str.242 = private unnamed_addr constant [7 x i8] c"repeat\00"
@.str.243 = private unnamed_addr constant [15 x i8] c"nova_rt_repeat\00"
@.str.244 = private unnamed_addr constant [6 x i8] c"chars\00"
@.str.245 = private unnamed_addr constant [14 x i8] c"nova_rt_chars\00"
@.str.246 = private unnamed_addr constant [8 x i8] c"time_ms\00"
@.str.247 = private unnamed_addr constant [16 x i8] c"nova_rt_time_ms\00"
@.str.248 = private unnamed_addr constant [6 x i8] c"sleep\00"
@.str.249 = private unnamed_addr constant [17 x i8] c"nova_rt_sleep_ms\00"
@.str.250 = private unnamed_addr constant [9 x i8] c"clock_ns\00"
@.str.251 = private unnamed_addr constant [17 x i8] c"nova_rt_clock_ns\00"
@.str.252 = private unnamed_addr constant [8 x i8] c"type_of\00"
@.str.253 = private unnamed_addr constant [16 x i8] c"nova_rt_type_of\00"
@.str.254 = private unnamed_addr constant [6 x i8] c"range\00"
@.str.255 = private unnamed_addr constant [14 x i8] c"nova_rt_range\00"
@.str.256 = private unnamed_addr constant [5 x i8] c"sort\00"
@.str.257 = private unnamed_addr constant [13 x i8] c"nova_rt_sort\00"
@.str.258 = private unnamed_addr constant [5 x i8] c"keys\00"
@.str.259 = private unnamed_addr constant [18 x i8] c"nova_rt_dict_keys\00"
@.str.260 = private unnamed_addr constant [7 x i8] c"values\00"
@.str.261 = private unnamed_addr constant [20 x i8] c"nova_rt_dict_values\00"
@.str.262 = private unnamed_addr constant [9 x i8] c"nova_rt_\00"
@.str.263 = private unnamed_addr constant [35 x i8] c"; NOVA Self-Hosted Compiler Output\00"
@.str.264 = private unnamed_addr constant [102 x i8] c"target datalayout = \22e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128\22\00"
@.str.265 = private unnamed_addr constant [47 x i8] c"@__nova_error_flag = thread_local global i64 0\00"
@.str.266 = private unnamed_addr constant [46 x i8] c"@__nova_error_msg = thread_local global i64 0\00"
@.str.267 = private unnamed_addr constant [23 x i8] c"; Runtime declarations\00"
@.str.268 = private unnamed_addr constant [32 x i8] c"declare i32 @puts(ptr) nounwind\00"
@.str.269 = private unnamed_addr constant [39 x i8] c"declare i32 @printf(ptr, ...) nounwind\00"
@.str.270 = private unnamed_addr constant [44 x i8] c"declare i64 @nova_rt_list_create() nounwind\00"
@.str.271 = private unnamed_addr constant [52 x i8] c"declare i64 @nova_rt_list_append(i64, i64) nounwind\00"
@.str.272 = private unnamed_addr constant [49 x i8] c"declare i64 @nova_rt_list_get(i64, i64) nounwind\00"
@.str.273 = private unnamed_addr constant [44 x i8] c"declare i64 @nova_rt_list_len(i64) nounwind\00"
@.str.274 = private unnamed_addr constant [44 x i8] c"declare i64 @nova_rt_dict_create() nounwind\00"
@.str.275 = private unnamed_addr constant [54 x i8] c"declare i64 @nova_rt_dict_set(i64, i64, i64) nounwind\00"
@.str.276 = private unnamed_addr constant [49 x i8] c"declare i64 @nova_rt_dict_get(i64, i64) nounwind\00"
@.str.277 = private unnamed_addr constant [54 x i8] c"declare i64 @nova_rt_dict_contains(i64, i64) nounwind\00"
@.str.278 = private unnamed_addr constant [51 x i8] c"declare i64 @nova_rt_str_concat(i64, i64) nounwind\00"
@.str.279 = private unnamed_addr constant [46 x i8] c"declare i64 @nova_rt_int_to_str(i64) nounwind\00"
@.str.280 = private unnamed_addr constant [45 x i8] c"declare i64 @nova_rt_parse_int(i64) nounwind\00"
@.str.281 = private unnamed_addr constant [39 x i8] c"declare i64 @nova_rt_len(i64) nounwind\00"
@.str.282 = private unnamed_addr constant [43 x i8] c"declare i64 @nova_rt_len_any(i64) nounwind\00"
@.str.283 = private unnamed_addr constant [39 x i8] c"declare i64 @nova_rt_ord(i64) nounwind\00"
@.str.284 = private unnamed_addr constant [39 x i8] c"declare i64 @nova_rt_chr(i64) nounwind\00"
@.str.285 = private unnamed_addr constant [49 x i8] c"declare i64 @nova_rt_contains(i64, i64) nounwind\00"
@.str.286 = private unnamed_addr constant [50 x i8] c"declare i64 @nova_rt_index_get(i64, i64) nounwind\00"
@.str.287 = private unnamed_addr constant [55 x i8] c"declare i64 @nova_rt_index_set(i64, i64, i64) nounwind\00"
@.str.288 = private unnamed_addr constant [44 x i8] c"declare i64 @nova_rt_add(i64, i64) nounwind\00"
@.str.289 = private unnamed_addr constant [43 x i8] c"declare i64 @nova_rt_eq(i64, i64) nounwind\00"
@.str.290 = private unnamed_addr constant [44 x i8] c"declare i64 @nova_rt_neq(i64, i64) nounwind\00"
@.str.291 = private unnamed_addr constant [46 x i8] c"declare i64 @nova_rt_any_to_str(i64) nounwind\00"
@.str.292 = private unnamed_addr constant [48 x i8] c"declare void @nova_rt_assert(i64, i64) nounwind\00"
@.str.293 = private unnamed_addr constant [45 x i8] c"declare i64 @nova_rt_read_file(i64) nounwind\00"
@.str.294 = private unnamed_addr constant [51 x i8] c"declare i64 @nova_rt_write_file(i64, i64) nounwind\00"
@.str.295 = private unnamed_addr constant [37 x i8] c"declare i64 @nova_rt_args() nounwind\00"
@.str.296 = private unnamed_addr constant [41 x i8] c"declare void @nova_rt_exit(i64) nounwind\00"
@.str.297 = private unnamed_addr constant [46 x i8] c"declare i64 @nova_rt_split(i64, i64) nounwind\00"
@.str.298 = private unnamed_addr constant [45 x i8] c"declare i64 @nova_rt_join(i64, i64) nounwind\00"
@.str.299 = private unnamed_addr constant [41 x i8] c"declare i64 @nova_rt_upper(i64) nounwind\00"
@.str.300 = private unnamed_addr constant [41 x i8] c"declare i64 @nova_rt_lower(i64) nounwind\00"
@.str.301 = private unnamed_addr constant [40 x i8] c"declare i64 @nova_rt_trim(i64) nounwind\00"
@.str.302 = private unnamed_addr constant [53 x i8] c"declare i64 @nova_rt_replace(i64, i64, i64) nounwind\00"
@.str.303 = private unnamed_addr constant [52 x i8] c"declare i64 @nova_rt_starts_with(i64, i64) nounwind\00"
@.str.304 = private unnamed_addr constant [50 x i8] c"declare i64 @nova_rt_ends_with(i64, i64) nounwind\00"
@.str.305 = private unnamed_addr constant [45 x i8] c"declare i64 @nova_rt_print_any(i64) nounwind\00"
@.str.306 = private unnamed_addr constant [46 x i8] c"declare i64 @nova_rt_float_bits(i64) nounwind\00"
@.str.307 = private unnamed_addr constant [48 x i8] c"declare ptr @nova_rt_struct_alloc(i64) nounwind\00"
@.str.308 = private unnamed_addr constant [51 x i8] c"declare i64 @nova_rt_slice(i64, i64, i64) nounwind\00"
@.str.309 = private unnamed_addr constant [47 x i8] c"declare i64 @nova_rt_repeat(i64, i64) nounwind\00"
@.str.310 = private unnamed_addr constant [41 x i8] c"declare i64 @nova_rt_chars(i64) nounwind\00"
@.str.311 = private unnamed_addr constant [40 x i8] c"declare i64 @nova_rt_time_ms() nounwind\00"
@.str.312 = private unnamed_addr constant [44 x i8] c"declare i64 @nova_rt_sleep_ms(i64) nounwind\00"
@.str.313 = private unnamed_addr constant [41 x i8] c"declare i64 @nova_rt_clock_ns() nounwind\00"
@.str.314 = private unnamed_addr constant [43 x i8] c"declare i64 @nova_rt_type_of(i64) nounwind\00"
@.str.315 = private unnamed_addr constant [46 x i8] c"declare i64 @nova_rt_range(i64, i64) nounwind\00"
@.str.316 = private unnamed_addr constant [40 x i8] c"declare i64 @nova_rt_sort(i64) nounwind\00"
@.str.317 = private unnamed_addr constant [45 x i8] c"declare i64 @nova_rt_dict_keys(i64) nounwind\00"
@.str.318 = private unnamed_addr constant [47 x i8] c"declare i64 @nova_rt_dict_values(i64) nounwind\00"
@.str.319 = private unnamed_addr constant [49 x i8] c"declare i64 @nova_rt_create_string(ptr) nounwind\00"
@.str.320 = private unnamed_addr constant [51 x i8] c"declare void @nova_rt_init_args(i64, i64) nounwind\00"
@.str.321 = private unnamed_addr constant [41 x i8] c"declare void @nova_rt_cleanup() nounwind\00"
@.str.322 = private unnamed_addr constant [19 x i8] c"; String constants\00"
@.str.323 = private unnamed_addr constant [7 x i8] c"@.str.\00"
@.str.324 = private unnamed_addr constant [35 x i8] c" = private unnamed_addr constant [\00"
@.str.325 = private unnamed_addr constant [10 x i8] c" x i8] c\22\00"
@.str.326 = private unnamed_addr constant [5 x i8] c"\\00\22\00"
@.str.327 = private unnamed_addr constant [35 x i8] c"define i64 @nova_main() nounwind {\00"
@.str.328 = private unnamed_addr constant [7 x i8] c"entry:\00"
@.str.329 = private unnamed_addr constant [23 x i8] c" = alloca i64, align 8\00"
@.str.330 = private unnamed_addr constant [18 x i8] c"store i64 0, ptr \00"
@.str.331 = private unnamed_addr constant [10 x i8] c"ret i64 0\00"
@.str.332 = private unnamed_addr constant [50 x i8] c"define i32 @main(i32 %argc, ptr %argv) nounwind {\00"
@.str.333 = private unnamed_addr constant [32 x i8] c"%argc64 = sext i32 %argc to i64\00"
@.str.334 = private unnamed_addr constant [36 x i8] c"%argv64 = ptrtoint ptr %argv to i64\00"
@.str.335 = private unnamed_addr constant [55 x i8] c"call void @nova_rt_init_args(i64 %argc64, i64 %argv64)\00"
@.str.336 = private unnamed_addr constant [22 x i8] c"call i64 @nova_main()\00"
@.str.337 = private unnamed_addr constant [29 x i8] c"call void @nova_rt_cleanup()\00"
@.str.338 = private unnamed_addr constant [10 x i8] c"ret i32 0\00"
@.str.339 = private unnamed_addr constant [4 x i8] c"\\0A\00"
@.str.340 = private unnamed_addr constant [4 x i8] c"\\0D\00"
@.str.341 = private unnamed_addr constant [4 x i8] c"\\09\00"
@.str.342 = private unnamed_addr constant [4 x i8] c"\\00\00"
@.str.343 = private unnamed_addr constant [3 x i8] c"\\\\\00"
@.str.344 = private unnamed_addr constant [4 x i8] c"\\22\00"
@.str.345 = private unnamed_addr constant [4 x i8] c"any\00"
@.str.346 = private unnamed_addr constant [5 x i8] c"void\00"
@.str.347 = private unnamed_addr constant [6 x i8] c"entry\00"
@.str.348 = private unnamed_addr constant [5 x i8] c"pure\00"
@.str.349 = private unnamed_addr constant [12 x i8] c"side_effect\00"
@.str.350 = private unnamed_addr constant [35 x i8] c"; NOVA IR-Pipeline Compiler Output\00"
@.str.351 = private unnamed_addr constant [44 x i8] c"declare i64 @nova_rt_sub(i64, i64) nounwind\00"
@.str.352 = private unnamed_addr constant [44 x i8] c"declare i64 @nova_rt_mul(i64, i64) nounwind\00"
@.str.353 = private unnamed_addr constant [44 x i8] c"declare i64 @nova_rt_div(i64, i64) nounwind\00"
@.str.354 = private unnamed_addr constant [10 x i8] c"nova_main\00"
@.str.355 = private unnamed_addr constant [53 x i8] c"Usage: nova_compiler [--ir] <input.nova> [output.ll]\00"
@.str.356 = private unnamed_addr constant [5 x i8] c"--ir\00"
@.str.357 = private unnamed_addr constant [16 x i8] c"Compiled (IR): \00"
@.str.358 = private unnamed_addr constant [5 x i8] c" -> \00"
@.str.359 = private unnamed_addr constant [11 x i8] c"Compiled: \00"
@.str.360 = private unnamed_addr constant [15 x i8] c"let x = 42 + 3\00"
@.str.361 = private unnamed_addr constant [31 x i8] c"lexer: expected 6 tokens, got \00"
@.str.362 = private unnamed_addr constant [26 x i8] c"x = 10\0Ay = x + 5\0Aprint(y)\00"
@.str.363 = private unnamed_addr constant [31 x i8] c"parser: expected 3 stmts, got \00"
@.str.364 = private unnamed_addr constant [16 x i8] c"x = 42\0Aprint(x)\00"
@.str.365 = private unnamed_addr constant [22 x i8] c"define i64 @nova_main\00"
@.str.366 = private unnamed_addr constant [23 x i8] c"codegen: has nova_main\00"
@.str.367 = private unnamed_addr constant [24 x i8] c"codegen: has print call\00"
@.str.368 = private unnamed_addr constant [63 x i8] c"fn add(a, b)\0A    return a + b\0Aresult = add(3, 4)\0Aprint(result)\00"
@.str.369 = private unnamed_addr constant [16 x i8] c"define i64 @add\00"
@.str.370 = private unnamed_addr constant [27 x i8] c"codegen: has user function\00"
@.str.371 = private unnamed_addr constant [21 x i8] c"x = \22hello\22\0Aprint(x)\00"
@.str.372 = private unnamed_addr constant [29 x i8] c"codegen: has string constant\00"
@.str.373 = private unnamed_addr constant [27 x i8] c"codegen: string print call\00"
@.str.374 = private unnamed_addr constant [45 x i8] c"NOVA Self-Hosting Compiler: ALL TESTS PASSED\00"
