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
  %t4 = icmp sge i64 %r2, 65
  %r3 = zext i1 %t4 to i64
  %r5 = load i64, ptr %slot.c, align 8
  %t7 = icmp sle i64 %r5, 90
  %r6 = zext i1 %t7 to i64
  br label %and_entry0
and_entry0:
  %t9 = icmp ne i64 %r3, 0
  br i1 %t9, label %and_rhs1, label %and_end2
and_rhs1:
  %r10 = load i64, ptr %slot.c, align 8
  %t12 = icmp sle i64 %r10, 90
  %r11 = zext i1 %t12 to i64
  br label %and_done3
and_done3:
  br label %and_end2
and_end2:
  %r8 = phi i64 [0, %and_entry0], [%r11, %and_done3]
  %r13 = load i64, ptr %slot.c, align 8
  %t15 = icmp sge i64 %r13, 97
  %r14 = zext i1 %t15 to i64
  %r16 = load i64, ptr %slot.c, align 8
  %t18 = icmp sle i64 %r16, 122
  %r17 = zext i1 %t18 to i64
  br label %and_entry4
and_entry4:
  %t20 = icmp ne i64 %r14, 0
  br i1 %t20, label %and_rhs5, label %and_end6
and_rhs5:
  %r21 = load i64, ptr %slot.c, align 8
  %t23 = icmp sle i64 %r21, 122
  %r22 = zext i1 %t23 to i64
  br label %and_done7
and_done7:
  br label %and_end6
and_end6:
  %r19 = phi i64 [0, %and_entry4], [%r22, %and_done7]
  br label %or_entry8
or_entry8:
  %t25 = icmp ne i64 %r8, 0
  br i1 %t25, label %or_end10, label %or_rhs9
or_rhs9:
  %r26 = load i64, ptr %slot.c, align 8
  %t28 = icmp sge i64 %r26, 97
  %r27 = zext i1 %t28 to i64
  %r29 = load i64, ptr %slot.c, align 8
  %t31 = icmp sle i64 %r29, 122
  %r30 = zext i1 %t31 to i64
  br label %and_entry11
and_entry11:
  %t33 = icmp ne i64 %r27, 0
  br i1 %t33, label %and_rhs12, label %and_end13
and_rhs12:
  %r34 = load i64, ptr %slot.c, align 8
  %t36 = icmp sle i64 %r34, 122
  %r35 = zext i1 %t36 to i64
  br label %and_done14
and_done14:
  br label %and_end13
and_end13:
  %r32 = phi i64 [0, %and_entry11], [%r35, %and_done14]
  br label %or_done15
or_done15:
  br label %or_end10
or_end10:
  %r24 = phi i64 [%r8, %or_entry8], [%r32, %or_done15]
  %r37 = load i64, ptr %slot.ch, align 8
  %r38 = getelementptr inbounds [2 x i8], ptr @.str.0, i64 0, i64 0
  %r39 = ptrtoint ptr %r38 to i64
  %t41 = call i64 @nova_rt_eq(i64 %r37, i64 %r39)
  %r40 = and i64 %t41, 1
  br label %or_entry16
or_entry16:
  %t43 = icmp ne i64 %r24, 0
  br i1 %t43, label %or_end18, label %or_rhs17
or_rhs17:
  %r44 = load i64, ptr %slot.ch, align 8
  %r45 = getelementptr inbounds [2 x i8], ptr @.str.0, i64 0, i64 0
  %r46 = ptrtoint ptr %r45 to i64
  %t48 = call i64 @nova_rt_eq(i64 %r44, i64 %r46)
  %r47 = and i64 %t48, 1
  br label %or_done19
or_done19:
  br label %or_end18
or_end18:
  %r42 = phi i64 [%r24, %or_entry16], [%t48, %or_done19]
  ret i64 %r42
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
  %t4 = icmp sge i64 %r2, 48
  %r3 = zext i1 %t4 to i64
  %r5 = load i64, ptr %slot.c, align 8
  %t7 = icmp sle i64 %r5, 57
  %r6 = zext i1 %t7 to i64
  br label %and_entry20
and_entry20:
  %t9 = icmp ne i64 %r3, 0
  br i1 %t9, label %and_rhs21, label %and_end22
and_rhs21:
  %r10 = load i64, ptr %slot.c, align 8
  %t12 = icmp sle i64 %r10, 57
  %r11 = zext i1 %t12 to i64
  br label %and_done23
and_done23:
  br label %and_end22
and_end22:
  %r8 = phi i64 [0, %and_entry20], [%r11, %and_done23]
  ret i64 %r8
}

define i64 @is_alnum(i64 %p0) nounwind {
entry:
  %slot.ch = alloca i64, align 8
  store i64 %p0, ptr %slot.ch, align 8
  %r0 = load i64, ptr %slot.ch, align 8
  %r1 = call i64 @is_alpha(i64 %r0)
  %r2 = load i64, ptr %slot.ch, align 8
  %r3 = call i64 @is_digit(i64 %r2)
  br label %or_entry24
or_entry24:
  %t5 = icmp ne i64 %r1, 0
  br i1 %t5, label %or_end26, label %or_rhs25
or_rhs25:
  %r6 = load i64, ptr %slot.ch, align 8
  %r7 = call i64 @is_digit(i64 %r6)
  br label %or_done27
or_done27:
  br label %or_end26
or_end26:
  %r4 = phi i64 [%r1, %or_entry24], [%r7, %or_done27]
  ret i64 %r4
}

define i64 @is_ws(i64 %p0) nounwind {
entry:
  %slot.ch = alloca i64, align 8
  store i64 %p0, ptr %slot.ch, align 8
  %r0 = load i64, ptr %slot.ch, align 8
  %r1 = getelementptr inbounds [2 x i8], ptr @.str.1, i64 0, i64 0
  %r2 = ptrtoint ptr %r1 to i64
  %t4 = call i64 @nova_rt_eq(i64 %r0, i64 %r2)
  %r3 = and i64 %t4, 1
  %r5 = load i64, ptr %slot.ch, align 8
  %r6 = getelementptr inbounds [2 x i8], ptr @.str.2, i64 0, i64 0
  %r7 = ptrtoint ptr %r6 to i64
  %t9 = call i64 @nova_rt_eq(i64 %r5, i64 %r7)
  %r8 = and i64 %t9, 1
  br label %or_entry28
or_entry28:
  %t11 = icmp ne i64 %t4, 0
  br i1 %t11, label %or_end30, label %or_rhs29
or_rhs29:
  %r12 = load i64, ptr %slot.ch, align 8
  %r13 = getelementptr inbounds [2 x i8], ptr @.str.2, i64 0, i64 0
  %r14 = ptrtoint ptr %r13 to i64
  %t16 = call i64 @nova_rt_eq(i64 %r12, i64 %r14)
  %r15 = and i64 %t16, 1
  br label %or_done31
or_done31:
  br label %or_end30
or_end30:
  %r10 = phi i64 [%t4, %or_entry28], [%t16, %or_done31]
  %r17 = load i64, ptr %slot.ch, align 8
  %r18 = getelementptr inbounds [2 x i8], ptr @.str.3, i64 0, i64 0
  %r19 = ptrtoint ptr %r18 to i64
  %t21 = call i64 @nova_rt_eq(i64 %r17, i64 %r19)
  %r20 = and i64 %t21, 1
  br label %or_entry32
or_entry32:
  %t23 = icmp ne i64 %r10, 0
  br i1 %t23, label %or_end34, label %or_rhs33
or_rhs33:
  %r24 = load i64, ptr %slot.ch, align 8
  %r25 = getelementptr inbounds [2 x i8], ptr @.str.3, i64 0, i64 0
  %r26 = ptrtoint ptr %r25 to i64
  %t28 = call i64 @nova_rt_eq(i64 %r24, i64 %r26)
  %r27 = and i64 %t28, 1
  br label %or_done35
or_done35:
  br label %or_end34
or_end34:
  %r22 = phi i64 [%r10, %or_entry32], [%t28, %or_done35]
  ret i64 %r22
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
  %r0 = call i64 @nova_rt_list_create()
  store i64 %r0, ptr %slot.tokens, align 8
  store i64 0, ptr %slot.pos, align 8
  store i64 1, ptr %slot.line, align 8
  store i64 1, ptr %slot.col, align 8
  %r1 = load i64, ptr %slot.source, align 8
  %r2 = call i64 @nova_rt_len_any(i64 %r1)
  store i64 %r2, ptr %slot.length, align 8
  br label %while_hdr36
while_hdr36:
  %r3 = load i64, ptr %slot.pos, align 8
  %r4 = load i64, ptr %slot.length, align 8
  %t6 = icmp slt i64 %r3, %r4
  %r5 = zext i1 %t6 to i64
  %t7 = icmp ne i64 %r5, 0
  br i1 %t7, label %while_body37, label %while_exit38
while_body37:
  %r8 = load i64, ptr %slot.source, align 8
  %r9 = load i64, ptr %slot.pos, align 8
  %r10 = call i64 @nova_rt_index_get(i64 %r8, i64 %r9)
  store i64 %r10, ptr %slot.ch, align 8
  %r11 = load i64, ptr %slot.ch, align 8
  %r12 = getelementptr inbounds [2 x i8], ptr @.str.4, i64 0, i64 0
  %r13 = ptrtoint ptr %r12 to i64
  %t15 = call i64 @nova_rt_eq(i64 %r11, i64 %r13)
  %r14 = and i64 %t15, 1
  %t16 = icmp ne i64 %t15, 0
  br i1 %t16, label %then39, label %else40
then39:
  %r17 = load i64, ptr %slot.tokens, align 8
  %r18 = call ptr @nova_rt_struct_alloc(i64 32)
  %r19 = getelementptr inbounds [8 x i8], ptr @.str.5, i64 0, i64 0
  %r20 = ptrtoint ptr %r19 to i64
  %t21 = getelementptr i64, ptr %r18, i64 0
  store i64 %r20, ptr %t21, align 8
  %r22 = getelementptr inbounds [3 x i8], ptr @.str.6, i64 0, i64 0
  %r23 = ptrtoint ptr %r22 to i64
  %t24 = getelementptr i64, ptr %r18, i64 1
  store i64 %r23, ptr %t24, align 8
  %r25 = load i64, ptr %slot.line, align 8
  %t26 = getelementptr i64, ptr %r18, i64 2
  store i64 %r25, ptr %t26, align 8
  %r27 = load i64, ptr %slot.col, align 8
  %t28 = getelementptr i64, ptr %r18, i64 3
  store i64 %r27, ptr %t28, align 8
  %r29 = ptrtoint ptr %r18 to i64
  %r30 = call i64 @nova_rt_list_append(i64 %r17, i64 %r29)
  %r31 = load i64, ptr %slot.line, align 8
  %r32 = call i64 @nova_rt_add(i64 %r31, i64 1)
  store i64 %r32, ptr %slot.line, align 8
  store i64 1, ptr %slot.col, align 8
  %r33 = load i64, ptr %slot.pos, align 8
  %r34 = call i64 @nova_rt_add(i64 %r33, i64 1)
  store i64 %r34, ptr %slot.pos, align 8
  br label %merge41
else40:
  %r35 = load i64, ptr %slot.ch, align 8
  %r36 = call i64 @is_ws(i64 %r35)
  %t37 = icmp ne i64 %r36, 0
  br i1 %t37, label %then42, label %else43
then42:
  br label %while_hdr45
while_hdr45:
  %r38 = load i64, ptr %slot.pos, align 8
  %r39 = load i64, ptr %slot.length, align 8
  %t41 = icmp slt i64 %r38, %r39
  %r40 = zext i1 %t41 to i64
  %r42 = load i64, ptr %slot.source, align 8
  %r43 = load i64, ptr %slot.pos, align 8
  %r44 = call i64 @nova_rt_index_get(i64 %r42, i64 %r43)
  %r45 = call i64 @is_ws(i64 %r44)
  br label %and_entry48
and_entry48:
  %t47 = icmp ne i64 %r40, 0
  br i1 %t47, label %and_rhs49, label %and_end50
and_rhs49:
  %r48 = load i64, ptr %slot.source, align 8
  %r49 = load i64, ptr %slot.pos, align 8
  %r50 = call i64 @nova_rt_index_get(i64 %r48, i64 %r49)
  %r51 = call i64 @is_ws(i64 %r50)
  br label %and_done51
and_done51:
  br label %and_end50
and_end50:
  %r46 = phi i64 [0, %and_entry48], [%r51, %and_done51]
  %t52 = icmp ne i64 %r46, 0
  br i1 %t52, label %while_body46, label %while_exit47
while_body46:
  %r53 = load i64, ptr %slot.pos, align 8
  %r54 = call i64 @nova_rt_add(i64 %r53, i64 1)
  store i64 %r54, ptr %slot.pos, align 8
  %r55 = load i64, ptr %slot.col, align 8
  %r56 = call i64 @nova_rt_add(i64 %r55, i64 1)
  store i64 %r56, ptr %slot.col, align 8
  br label %while_hdr45
while_exit47:
  br label %merge44
else43:
  %r57 = load i64, ptr %slot.ch, align 8
  %r58 = call i64 @is_alpha(i64 %r57)
  %t59 = icmp ne i64 %r58, 0
  br i1 %t59, label %then52, label %else53
then52:
  %r60 = load i64, ptr %slot.col, align 8
  store i64 %r60, ptr %slot.start_col, align 8
  %r61 = getelementptr inbounds [1 x i8], ptr @.str.7, i64 0, i64 0
  %r62 = ptrtoint ptr %r61 to i64
  store i64 %r62, ptr %slot.word, align 8
  br label %while_hdr55
while_hdr55:
  %r63 = load i64, ptr %slot.pos, align 8
  %r64 = load i64, ptr %slot.length, align 8
  %t66 = icmp slt i64 %r63, %r64
  %r65 = zext i1 %t66 to i64
  %r67 = load i64, ptr %slot.source, align 8
  %r68 = load i64, ptr %slot.pos, align 8
  %r69 = call i64 @nova_rt_index_get(i64 %r67, i64 %r68)
  %r70 = call i64 @is_alnum(i64 %r69)
  br label %and_entry58
and_entry58:
  %t72 = icmp ne i64 %r65, 0
  br i1 %t72, label %and_rhs59, label %and_end60
and_rhs59:
  %r73 = load i64, ptr %slot.source, align 8
  %r74 = load i64, ptr %slot.pos, align 8
  %r75 = call i64 @nova_rt_index_get(i64 %r73, i64 %r74)
  %r76 = call i64 @is_alnum(i64 %r75)
  br label %and_done61
and_done61:
  br label %and_end60
and_end60:
  %r71 = phi i64 [0, %and_entry58], [%r76, %and_done61]
  %t77 = icmp ne i64 %r71, 0
  br i1 %t77, label %while_body56, label %while_exit57
while_body56:
  %r78 = load i64, ptr %slot.word, align 8
  %r79 = load i64, ptr %slot.source, align 8
  %r80 = load i64, ptr %slot.pos, align 8
  %r81 = call i64 @nova_rt_index_get(i64 %r79, i64 %r80)
  %r82 = call i64 @nova_rt_add(i64 %r78, i64 %r81)
  store i64 %r82, ptr %slot.word, align 8
  %r83 = load i64, ptr %slot.pos, align 8
  %r84 = call i64 @nova_rt_add(i64 %r83, i64 1)
  store i64 %r84, ptr %slot.pos, align 8
  %r85 = load i64, ptr %slot.col, align 8
  %r86 = call i64 @nova_rt_add(i64 %r85, i64 1)
  store i64 %r86, ptr %slot.col, align 8
  br label %while_hdr55
while_exit57:
  %r87 = load i64, ptr %slot.tokens, align 8
  %r88 = call ptr @nova_rt_struct_alloc(i64 32)
  %r89 = getelementptr inbounds [6 x i8], ptr @.str.8, i64 0, i64 0
  %r90 = ptrtoint ptr %r89 to i64
  %t91 = getelementptr i64, ptr %r88, i64 0
  store i64 %r90, ptr %t91, align 8
  %r92 = load i64, ptr %slot.word, align 8
  %t93 = getelementptr i64, ptr %r88, i64 1
  store i64 %r92, ptr %t93, align 8
  %r94 = load i64, ptr %slot.line, align 8
  %t95 = getelementptr i64, ptr %r88, i64 2
  store i64 %r94, ptr %t95, align 8
  %r96 = load i64, ptr %slot.start_col, align 8
  %t97 = getelementptr i64, ptr %r88, i64 3
  store i64 %r96, ptr %t97, align 8
  %r98 = ptrtoint ptr %r88 to i64
  %r99 = call i64 @nova_rt_list_append(i64 %r87, i64 %r98)
  br label %merge54
else53:
  %r100 = load i64, ptr %slot.ch, align 8
  %r101 = call i64 @is_digit(i64 %r100)
  %t102 = icmp ne i64 %r101, 0
  br i1 %t102, label %then62, label %else63
then62:
  %r103 = load i64, ptr %slot.col, align 8
  store i64 %r103, ptr %slot.start_col, align 8
  %r104 = getelementptr inbounds [1 x i8], ptr @.str.7, i64 0, i64 0
  %r105 = ptrtoint ptr %r104 to i64
  store i64 %r105, ptr %slot.num, align 8
  br label %while_hdr65
while_hdr65:
  %r106 = load i64, ptr %slot.pos, align 8
  %r107 = load i64, ptr %slot.length, align 8
  %t109 = icmp slt i64 %r106, %r107
  %r108 = zext i1 %t109 to i64
  %r110 = load i64, ptr %slot.source, align 8
  %r111 = load i64, ptr %slot.pos, align 8
  %r112 = call i64 @nova_rt_index_get(i64 %r110, i64 %r111)
  %r113 = call i64 @is_digit(i64 %r112)
  br label %and_entry68
and_entry68:
  %t115 = icmp ne i64 %r108, 0
  br i1 %t115, label %and_rhs69, label %and_end70
and_rhs69:
  %r116 = load i64, ptr %slot.source, align 8
  %r117 = load i64, ptr %slot.pos, align 8
  %r118 = call i64 @nova_rt_index_get(i64 %r116, i64 %r117)
  %r119 = call i64 @is_digit(i64 %r118)
  br label %and_done71
and_done71:
  br label %and_end70
and_end70:
  %r114 = phi i64 [0, %and_entry68], [%r119, %and_done71]
  %t120 = icmp ne i64 %r114, 0
  br i1 %t120, label %while_body66, label %while_exit67
while_body66:
  %r121 = load i64, ptr %slot.num, align 8
  %r122 = load i64, ptr %slot.source, align 8
  %r123 = load i64, ptr %slot.pos, align 8
  %r124 = call i64 @nova_rt_index_get(i64 %r122, i64 %r123)
  %r125 = call i64 @nova_rt_add(i64 %r121, i64 %r124)
  store i64 %r125, ptr %slot.num, align 8
  %r126 = load i64, ptr %slot.pos, align 8
  %r127 = call i64 @nova_rt_add(i64 %r126, i64 1)
  store i64 %r127, ptr %slot.pos, align 8
  %r128 = load i64, ptr %slot.col, align 8
  %r129 = call i64 @nova_rt_add(i64 %r128, i64 1)
  store i64 %r129, ptr %slot.col, align 8
  br label %while_hdr65
while_exit67:
  %r130 = load i64, ptr %slot.tokens, align 8
  %r131 = call ptr @nova_rt_struct_alloc(i64 32)
  %r132 = getelementptr inbounds [4 x i8], ptr @.str.9, i64 0, i64 0
  %r133 = ptrtoint ptr %r132 to i64
  %t134 = getelementptr i64, ptr %r131, i64 0
  store i64 %r133, ptr %t134, align 8
  %r135 = load i64, ptr %slot.num, align 8
  %t136 = getelementptr i64, ptr %r131, i64 1
  store i64 %r135, ptr %t136, align 8
  %r137 = load i64, ptr %slot.line, align 8
  %t138 = getelementptr i64, ptr %r131, i64 2
  store i64 %r137, ptr %t138, align 8
  %r139 = load i64, ptr %slot.start_col, align 8
  %t140 = getelementptr i64, ptr %r131, i64 3
  store i64 %r139, ptr %t140, align 8
  %r141 = ptrtoint ptr %r131 to i64
  %r142 = call i64 @nova_rt_list_append(i64 %r130, i64 %r141)
  br label %merge64
else63:
  %r143 = load i64, ptr %slot.ch, align 8
  %r144 = getelementptr inbounds [2 x i8], ptr @.str.10, i64 0, i64 0
  %r145 = ptrtoint ptr %r144 to i64
  %t147 = call i64 @nova_rt_eq(i64 %r143, i64 %r145)
  %r146 = and i64 %t147, 1
  %t148 = icmp ne i64 %t147, 0
  br i1 %t148, label %then72, label %else73
then72:
  %r149 = load i64, ptr %slot.tokens, align 8
  %r150 = call ptr @nova_rt_struct_alloc(i64 32)
  %r151 = getelementptr inbounds [3 x i8], ptr @.str.11, i64 0, i64 0
  %r152 = ptrtoint ptr %r151 to i64
  %t153 = getelementptr i64, ptr %r150, i64 0
  store i64 %r152, ptr %t153, align 8
  %r154 = getelementptr inbounds [2 x i8], ptr @.str.10, i64 0, i64 0
  %r155 = ptrtoint ptr %r154 to i64
  %t156 = getelementptr i64, ptr %r150, i64 1
  store i64 %r155, ptr %t156, align 8
  %r157 = load i64, ptr %slot.line, align 8
  %t158 = getelementptr i64, ptr %r150, i64 2
  store i64 %r157, ptr %t158, align 8
  %r159 = load i64, ptr %slot.col, align 8
  %t160 = getelementptr i64, ptr %r150, i64 3
  store i64 %r159, ptr %t160, align 8
  %r161 = ptrtoint ptr %r150 to i64
  %r162 = call i64 @nova_rt_list_append(i64 %r149, i64 %r161)
  %r163 = load i64, ptr %slot.pos, align 8
  %r164 = call i64 @nova_rt_add(i64 %r163, i64 1)
  store i64 %r164, ptr %slot.pos, align 8
  %r165 = load i64, ptr %slot.col, align 8
  %r166 = call i64 @nova_rt_add(i64 %r165, i64 1)
  store i64 %r166, ptr %slot.col, align 8
  br label %merge74
else73:
  %r167 = load i64, ptr %slot.ch, align 8
  %r168 = getelementptr inbounds [2 x i8], ptr @.str.12, i64 0, i64 0
  %r169 = ptrtoint ptr %r168 to i64
  %t171 = call i64 @nova_rt_eq(i64 %r167, i64 %r169)
  %r170 = and i64 %t171, 1
  %t172 = icmp ne i64 %t171, 0
  br i1 %t172, label %then75, label %else76
then75:
  %r173 = load i64, ptr %slot.tokens, align 8
  %r174 = call ptr @nova_rt_struct_alloc(i64 32)
  %r175 = getelementptr inbounds [7 x i8], ptr @.str.13, i64 0, i64 0
  %r176 = ptrtoint ptr %r175 to i64
  %t177 = getelementptr i64, ptr %r174, i64 0
  store i64 %r176, ptr %t177, align 8
  %r178 = getelementptr inbounds [2 x i8], ptr @.str.12, i64 0, i64 0
  %r179 = ptrtoint ptr %r178 to i64
  %t180 = getelementptr i64, ptr %r174, i64 1
  store i64 %r179, ptr %t180, align 8
  %r181 = load i64, ptr %slot.line, align 8
  %t182 = getelementptr i64, ptr %r174, i64 2
  store i64 %r181, ptr %t182, align 8
  %r183 = load i64, ptr %slot.col, align 8
  %t184 = getelementptr i64, ptr %r174, i64 3
  store i64 %r183, ptr %t184, align 8
  %r185 = ptrtoint ptr %r174 to i64
  %r186 = call i64 @nova_rt_list_append(i64 %r173, i64 %r185)
  %r187 = load i64, ptr %slot.pos, align 8
  %r188 = call i64 @nova_rt_add(i64 %r187, i64 1)
  store i64 %r188, ptr %slot.pos, align 8
  %r189 = load i64, ptr %slot.col, align 8
  %r190 = call i64 @nova_rt_add(i64 %r189, i64 1)
  store i64 %r190, ptr %slot.col, align 8
  br label %merge77
else76:
  %r191 = load i64, ptr %slot.pos, align 8
  %r192 = call i64 @nova_rt_add(i64 %r191, i64 1)
  store i64 %r192, ptr %slot.pos, align 8
  %r193 = load i64, ptr %slot.col, align 8
  %r194 = call i64 @nova_rt_add(i64 %r193, i64 1)
  store i64 %r194, ptr %slot.col, align 8
  br label %merge77
merge77:
  br label %merge74
merge74:
  br label %merge64
merge64:
  br label %merge54
merge54:
  br label %merge44
merge44:
  br label %merge41
merge41:
  br label %while_hdr36
while_exit38:
  %r195 = load i64, ptr %slot.tokens, align 8
  %r196 = call ptr @nova_rt_struct_alloc(i64 32)
  %r197 = getelementptr inbounds [4 x i8], ptr @.str.14, i64 0, i64 0
  %r198 = ptrtoint ptr %r197 to i64
  %t199 = getelementptr i64, ptr %r196, i64 0
  store i64 %r198, ptr %t199, align 8
  %r200 = getelementptr inbounds [1 x i8], ptr @.str.7, i64 0, i64 0
  %r201 = ptrtoint ptr %r200 to i64
  %t202 = getelementptr i64, ptr %r196, i64 1
  store i64 %r201, ptr %t202, align 8
  %r203 = load i64, ptr %slot.line, align 8
  %t204 = getelementptr i64, ptr %r196, i64 2
  store i64 %r203, ptr %t204, align 8
  %r205 = load i64, ptr %slot.col, align 8
  %t206 = getelementptr i64, ptr %r196, i64 3
  store i64 %r205, ptr %t206, align 8
  %r207 = ptrtoint ptr %r196 to i64
  %r208 = call i64 @nova_rt_list_append(i64 %r195, i64 %r207)
  %r209 = load i64, ptr %slot.tokens, align 8
  ret i64 %r209
}

define i64 @nova_main() nounwind {
entry:
  %slot.result = alloca i64, align 8
  store i64 0, ptr %slot.result, align 8
  %slot.non_nl = alloca i64, align 8
  store i64 0, ptr %slot.non_nl, align 8
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
  %r0 = getelementptr inbounds [15 x i8], ptr @.str.15, i64 0, i64 0
  %r1 = ptrtoint ptr %r0 to i64
  %r2 = call i64 @tokenize(i64 %r1)
  store i64 %r2, ptr %slot.result, align 8
  %r3 = call i64 @nova_rt_list_create()
  store i64 %r3, ptr %slot.non_nl, align 8
  %r4 = load i64, ptr %slot.result, align 8
  %r5 = call i64 @nova_rt_len_any(i64 %r4)
  %slot.__for_idx_78 = alloca i64, align 8
  store i64 0, ptr %slot.__for_idx_78, align 8
  br label %for_hdr78
for_hdr78:
  %r6 = load i64, ptr %slot.__for_idx_78, align 8
  %t7 = icmp slt i64 %r6, %r5
  br i1 %t7, label %for_body79, label %for_exit80
for_body79:
  %r8 = call i64 @nova_rt_index_get(i64 %r4, i64 %r6)
  store i64 %r8, ptr %slot.t, align 8
  %r9 = load i64, ptr %slot.t, align 8
  %t10 = inttoptr i64 %r9 to ptr
  %t11 = getelementptr i64, ptr %t10, i64 0
  %r12 = load i64, ptr %t11, align 8
  store i64 %r12, ptr %slot.kind, align 8
  %t13 = getelementptr i64, ptr %t10, i64 1
  %r14 = load i64, ptr %t13, align 8
  store i64 %r14, ptr %slot.value, align 8
  %t15 = getelementptr i64, ptr %t10, i64 2
  %r16 = load i64, ptr %t15, align 8
  store i64 %r16, ptr %slot.line, align 8
  %t17 = getelementptr i64, ptr %t10, i64 3
  %r18 = load i64, ptr %t17, align 8
  store i64 %r18, ptr %slot.col, align 8
  %r19 = load i64, ptr %slot.kind, align 8
  %r20 = getelementptr inbounds [8 x i8], ptr @.str.5, i64 0, i64 0
  %r21 = ptrtoint ptr %r20 to i64
  %t23 = call i64 @nova_rt_neq(i64 %r19, i64 %r21)
  %r24 = load i64, ptr %slot.kind, align 8
  %r25 = getelementptr inbounds [4 x i8], ptr @.str.14, i64 0, i64 0
  %r26 = ptrtoint ptr %r25 to i64
  %t28 = call i64 @nova_rt_neq(i64 %r24, i64 %r26)
  br label %and_entry81
and_entry81:
  %t30 = icmp ne i64 %t23, 0
  br i1 %t30, label %and_rhs82, label %and_end83
and_rhs82:
  %r31 = load i64, ptr %slot.kind, align 8
  %r32 = getelementptr inbounds [4 x i8], ptr @.str.14, i64 0, i64 0
  %r33 = ptrtoint ptr %r32 to i64
  %t35 = call i64 @nova_rt_neq(i64 %r31, i64 %r33)
  br label %and_done84
and_done84:
  br label %and_end83
and_end83:
  %r29 = phi i64 [0, %and_entry81], [%t35, %and_done84]
  %t36 = icmp ne i64 %r29, 0
  br i1 %t36, label %then85, label %else86
then85:
  %r37 = load i64, ptr %slot.non_nl, align 8
  %r38 = load i64, ptr %slot.t, align 8
  %r39 = call i64 @nova_rt_list_append(i64 %r37, i64 %r38)
  br label %merge87
else86:
  br label %merge87
merge87:
  %r40 = load i64, ptr %slot.kind, align 8
  %r41 = getelementptr inbounds [2 x i8], ptr @.str.16, i64 0, i64 0
  %r42 = ptrtoint ptr %r41 to i64
  %r43 = call i64 @nova_rt_add(i64 %r40, i64 %r42)
  %r44 = load i64, ptr %slot.value, align 8
  %r45 = call i64 @nova_rt_add(i64 %r43, i64 %r44)
  %r46 = call i64 @nova_rt_print_any(i64 %r45)
  %r48 = load i64, ptr %slot.__for_idx_78, align 8
  %r47 = add i64 %r48, 1
  store i64 %r47, ptr %slot.__for_idx_78, align 8
  br label %for_hdr78
for_exit80:
  %r49 = getelementptr inbounds [8 x i8], ptr @.str.17, i64 0, i64 0
  %r50 = ptrtoint ptr %r49 to i64
  %r51 = load i64, ptr %slot.result, align 8
  %r52 = call i64 @nova_rt_len_any(i64 %r51)
  %r53 = call i64 @nova_rt_int_to_str(i64 %r52)
  %r54 = call i64 @nova_rt_add(i64 %r50, i64 %r53)
  %r55 = getelementptr inbounds [11 x i8], ptr @.str.18, i64 0, i64 0
  %r56 = ptrtoint ptr %r55 to i64
  %r57 = call i64 @nova_rt_add(i64 %r54, i64 %r56)
  %r58 = load i64, ptr %slot.non_nl, align 8
  %r59 = call i64 @nova_rt_len_any(i64 %r58)
  %r60 = call i64 @nova_rt_int_to_str(i64 %r59)
  %r61 = call i64 @nova_rt_add(i64 %r57, i64 %r60)
  %r62 = call i64 @nova_rt_print_any(i64 %r61)
  %r63 = load i64, ptr %slot.non_nl, align 8
  %r64 = call i64 @nova_rt_len_any(i64 %r63)
  %t66 = call i64 @nova_rt_eq(i64 %r64, i64 6)
  %r65 = and i64 %t66, 1
  %t67 = icmp ne i64 %t66, 0
  br i1 %t67, label %then88, label %else89
then88:
  %r68 = getelementptr inbounds [5 x i8], ptr @.str.19, i64 0, i64 0
  %r69 = ptrtoint ptr %r68 to i64
  %r70 = call i64 @nova_rt_print_any(i64 %r69)
  br label %merge90
else89:
  %r71 = getelementptr inbounds [23 x i8], ptr @.str.20, i64 0, i64 0
  %r72 = ptrtoint ptr %r71 to i64
  %r73 = load i64, ptr %slot.non_nl, align 8
  %r74 = call i64 @nova_rt_len_any(i64 %r73)
  %r75 = call i64 @nova_rt_int_to_str(i64 %r74)
  %r76 = call i64 @nova_rt_add(i64 %r72, i64 %r75)
  %r77 = call i64 @nova_rt_print_any(i64 %r76)
  br label %merge90
merge90:
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
@.str.4 = private unnamed_addr constant [2 x i8] c"\0A\00"
@.str.5 = private unnamed_addr constant [8 x i8] c"NEWLINE\00"
@.str.6 = private unnamed_addr constant [3 x i8] c"\\n\00"
@.str.7 = private unnamed_addr constant [1 x i8] c"\00"
@.str.8 = private unnamed_addr constant [6 x i8] c"IDENT\00"
@.str.9 = private unnamed_addr constant [4 x i8] c"INT\00"
@.str.10 = private unnamed_addr constant [2 x i8] c"+\00"
@.str.11 = private unnamed_addr constant [3 x i8] c"OP\00"
@.str.12 = private unnamed_addr constant [2 x i8] c"=\00"
@.str.13 = private unnamed_addr constant [7 x i8] c"ASSIGN\00"
@.str.14 = private unnamed_addr constant [4 x i8] c"EOF\00"
@.str.15 = private unnamed_addr constant [15 x i8] c"let x = 42 + 3\00"
@.str.16 = private unnamed_addr constant [2 x i8] c":\00"
@.str.17 = private unnamed_addr constant [8 x i8] c"Total: \00"
@.str.18 = private unnamed_addr constant [11 x i8] c", non-nl: \00"
@.str.19 = private unnamed_addr constant [5 x i8] c"PASS\00"
@.str.20 = private unnamed_addr constant [23 x i8] c"FAIL: expected 6, got \00"
