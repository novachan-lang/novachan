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

define i64 @is_alpha_char(i64 %p0) nounwind {
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

define i64 @is_digit_char(i64 %p0) nounwind {
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

define i64 @tokenize_simple(i64 %p0) nounwind {
entry:
  %slot.src = alloca i64, align 8
  store i64 %p0, ptr %slot.src, align 8
  %slot.tokens = alloca i64, align 8
  store i64 0, ptr %slot.tokens, align 8
  %slot.i = alloca i64, align 8
  store i64 0, ptr %slot.i, align 8
  %slot.ch = alloca i64, align 8
  store i64 0, ptr %slot.ch, align 8
  %slot.start = alloca i64, align 8
  store i64 0, ptr %slot.start, align 8
  %slot.word = alloca i64, align 8
  store i64 0, ptr %slot.word, align 8
  %slot.j = alloca i64, align 8
  store i64 0, ptr %slot.j, align 8
  %slot.num = alloca i64, align 8
  store i64 0, ptr %slot.num, align 8
  %r0 = call i64 @nova_rt_list_create()
  store i64 %r0, ptr %slot.tokens, align 8
  store i64 0, ptr %slot.i, align 8
  br label %while_hdr24
while_hdr24:
  %r1 = load i64, ptr %slot.i, align 8
  %r2 = load i64, ptr %slot.src, align 8
  %r3 = call i64 @nova_rt_len_any(i64 %r2)
  %t5 = icmp slt i64 %r1, %r3
  %r4 = zext i1 %t5 to i64
  %t6 = icmp ne i64 %r4, 0
  br i1 %t6, label %while_body25, label %while_exit26
while_body25:
  %r7 = load i64, ptr %slot.src, align 8
  %r8 = load i64, ptr %slot.i, align 8
  %r9 = call i64 @nova_rt_index_get(i64 %r7, i64 %r8)
  store i64 %r9, ptr %slot.ch, align 8
  %r10 = load i64, ptr %slot.ch, align 8
  %r11 = getelementptr inbounds [2 x i8], ptr @.str.1, i64 0, i64 0
  %r12 = ptrtoint ptr %r11 to i64
  %t14 = call i64 @nova_rt_eq(i64 %r10, i64 %r12)
  %r13 = and i64 %t14, 1
  %r15 = load i64, ptr %slot.ch, align 8
  %r16 = getelementptr inbounds [2 x i8], ptr @.str.2, i64 0, i64 0
  %r17 = ptrtoint ptr %r16 to i64
  %t19 = call i64 @nova_rt_eq(i64 %r15, i64 %r17)
  %r18 = and i64 %t19, 1
  br label %or_entry27
or_entry27:
  %t21 = icmp ne i64 %t14, 0
  br i1 %t21, label %or_end29, label %or_rhs28
or_rhs28:
  %r22 = load i64, ptr %slot.ch, align 8
  %r23 = getelementptr inbounds [2 x i8], ptr @.str.2, i64 0, i64 0
  %r24 = ptrtoint ptr %r23 to i64
  %t26 = call i64 @nova_rt_eq(i64 %r22, i64 %r24)
  %r25 = and i64 %t26, 1
  br label %or_done30
or_done30:
  br label %or_end29
or_end29:
  %r20 = phi i64 [%t14, %or_entry27], [%t26, %or_done30]
  %t27 = icmp ne i64 %r20, 0
  br i1 %t27, label %then31, label %else32
then31:
  %r28 = load i64, ptr %slot.i, align 8
  %r29 = call i64 @nova_rt_add(i64 %r28, i64 1)
  store i64 %r29, ptr %slot.i, align 8
  br label %merge33
else32:
  %r30 = load i64, ptr %slot.ch, align 8
  %r31 = getelementptr inbounds [2 x i8], ptr @.str.3, i64 0, i64 0
  %r32 = ptrtoint ptr %r31 to i64
  %t34 = call i64 @nova_rt_eq(i64 %r30, i64 %r32)
  %r33 = and i64 %t34, 1
  %t35 = icmp ne i64 %t34, 0
  br i1 %t35, label %then34, label %else35
then34:
  %r36 = load i64, ptr %slot.tokens, align 8
  %r37 = call ptr @nova_rt_struct_alloc(i64 16)
  %r38 = getelementptr inbounds [3 x i8], ptr @.str.4, i64 0, i64 0
  %r39 = ptrtoint ptr %r38 to i64
  %t40 = getelementptr i64, ptr %r37, i64 0
  store i64 %r39, ptr %t40, align 8
  %r41 = getelementptr inbounds [3 x i8], ptr @.str.5, i64 0, i64 0
  %r42 = ptrtoint ptr %r41 to i64
  %t43 = getelementptr i64, ptr %r37, i64 1
  store i64 %r42, ptr %t43, align 8
  %r44 = ptrtoint ptr %r37 to i64
  %r45 = call i64 @nova_rt_list_append(i64 %r36, i64 %r44)
  %r46 = load i64, ptr %slot.i, align 8
  %r47 = call i64 @nova_rt_add(i64 %r46, i64 1)
  store i64 %r47, ptr %slot.i, align 8
  br label %merge36
else35:
  %r48 = load i64, ptr %slot.ch, align 8
  %r49 = call i64 @is_alpha_char(i64 %r48)
  %t50 = icmp ne i64 %r49, 0
  br i1 %t50, label %then37, label %else38
then37:
  %r51 = load i64, ptr %slot.i, align 8
  store i64 %r51, ptr %slot.start, align 8
  br label %while_hdr40
while_hdr40:
  %r52 = load i64, ptr %slot.i, align 8
  %r53 = load i64, ptr %slot.src, align 8
  %r54 = call i64 @nova_rt_len_any(i64 %r53)
  %t56 = icmp slt i64 %r52, %r54
  %r55 = zext i1 %t56 to i64
  %r57 = load i64, ptr %slot.src, align 8
  %r58 = load i64, ptr %slot.i, align 8
  %r59 = call i64 @nova_rt_index_get(i64 %r57, i64 %r58)
  %r60 = call i64 @is_alpha_char(i64 %r59)
  %r61 = load i64, ptr %slot.src, align 8
  %r62 = load i64, ptr %slot.i, align 8
  %r63 = call i64 @nova_rt_index_get(i64 %r61, i64 %r62)
  %r64 = call i64 @is_digit_char(i64 %r63)
  br label %or_entry43
or_entry43:
  %t66 = icmp ne i64 %r60, 0
  br i1 %t66, label %or_end45, label %or_rhs44
or_rhs44:
  %r67 = load i64, ptr %slot.src, align 8
  %r68 = load i64, ptr %slot.i, align 8
  %r69 = call i64 @nova_rt_index_get(i64 %r67, i64 %r68)
  %r70 = call i64 @is_digit_char(i64 %r69)
  br label %or_done46
or_done46:
  br label %or_end45
or_end45:
  %r65 = phi i64 [%r60, %or_entry43], [%r70, %or_done46]
  br label %and_entry47
and_entry47:
  %t72 = icmp ne i64 %r55, 0
  br i1 %t72, label %and_rhs48, label %and_end49
and_rhs48:
  %r73 = load i64, ptr %slot.src, align 8
  %r74 = load i64, ptr %slot.i, align 8
  %r75 = call i64 @nova_rt_index_get(i64 %r73, i64 %r74)
  %r76 = call i64 @is_alpha_char(i64 %r75)
  %r77 = load i64, ptr %slot.src, align 8
  %r78 = load i64, ptr %slot.i, align 8
  %r79 = call i64 @nova_rt_index_get(i64 %r77, i64 %r78)
  %r80 = call i64 @is_digit_char(i64 %r79)
  br label %or_entry50
or_entry50:
  %t82 = icmp ne i64 %r76, 0
  br i1 %t82, label %or_end52, label %or_rhs51
or_rhs51:
  %r83 = load i64, ptr %slot.src, align 8
  %r84 = load i64, ptr %slot.i, align 8
  %r85 = call i64 @nova_rt_index_get(i64 %r83, i64 %r84)
  %r86 = call i64 @is_digit_char(i64 %r85)
  br label %or_done53
or_done53:
  br label %or_end52
or_end52:
  %r81 = phi i64 [%r76, %or_entry50], [%r86, %or_done53]
  br label %and_done54
and_done54:
  br label %and_end49
and_end49:
  %r71 = phi i64 [0, %and_entry47], [%r81, %and_done54]
  %t87 = icmp ne i64 %r71, 0
  br i1 %t87, label %while_body41, label %while_exit42
while_body41:
  %r88 = load i64, ptr %slot.i, align 8
  %r89 = call i64 @nova_rt_add(i64 %r88, i64 1)
  store i64 %r89, ptr %slot.i, align 8
  br label %while_hdr40
while_exit42:
  %r90 = getelementptr inbounds [1 x i8], ptr @.str.6, i64 0, i64 0
  %r91 = ptrtoint ptr %r90 to i64
  store i64 %r91, ptr %slot.word, align 8
  %r92 = load i64, ptr %slot.start, align 8
  store i64 %r92, ptr %slot.j, align 8
  br label %while_hdr55
while_hdr55:
  %r93 = load i64, ptr %slot.j, align 8
  %r94 = load i64, ptr %slot.i, align 8
  %t96 = icmp slt i64 %r93, %r94
  %r95 = zext i1 %t96 to i64
  %t97 = icmp ne i64 %r95, 0
  br i1 %t97, label %while_body56, label %while_exit57
while_body56:
  %r98 = load i64, ptr %slot.word, align 8
  %r99 = load i64, ptr %slot.src, align 8
  %r100 = load i64, ptr %slot.j, align 8
  %r101 = call i64 @nova_rt_index_get(i64 %r99, i64 %r100)
  %r102 = call i64 @nova_rt_add(i64 %r98, i64 %r101)
  store i64 %r102, ptr %slot.word, align 8
  %r103 = load i64, ptr %slot.j, align 8
  %r104 = call i64 @nova_rt_add(i64 %r103, i64 1)
  store i64 %r104, ptr %slot.j, align 8
  br label %while_hdr55
while_exit57:
  %r105 = load i64, ptr %slot.tokens, align 8
  %r106 = call ptr @nova_rt_struct_alloc(i64 16)
  %r107 = getelementptr inbounds [3 x i8], ptr @.str.7, i64 0, i64 0
  %r108 = ptrtoint ptr %r107 to i64
  %t109 = getelementptr i64, ptr %r106, i64 0
  store i64 %r108, ptr %t109, align 8
  %r110 = load i64, ptr %slot.word, align 8
  %t111 = getelementptr i64, ptr %r106, i64 1
  store i64 %r110, ptr %t111, align 8
  %r112 = ptrtoint ptr %r106 to i64
  %r113 = call i64 @nova_rt_list_append(i64 %r105, i64 %r112)
  br label %merge39
else38:
  %r114 = load i64, ptr %slot.ch, align 8
  %r115 = call i64 @is_digit_char(i64 %r114)
  %t116 = icmp ne i64 %r115, 0
  br i1 %t116, label %then58, label %else59
then58:
  %r117 = load i64, ptr %slot.i, align 8
  store i64 %r117, ptr %slot.start, align 8
  br label %while_hdr61
while_hdr61:
  %r118 = load i64, ptr %slot.i, align 8
  %r119 = load i64, ptr %slot.src, align 8
  %r120 = call i64 @nova_rt_len_any(i64 %r119)
  %t122 = icmp slt i64 %r118, %r120
  %r121 = zext i1 %t122 to i64
  %r123 = load i64, ptr %slot.src, align 8
  %r124 = load i64, ptr %slot.i, align 8
  %r125 = call i64 @nova_rt_index_get(i64 %r123, i64 %r124)
  %r126 = call i64 @is_digit_char(i64 %r125)
  br label %and_entry64
and_entry64:
  %t128 = icmp ne i64 %r121, 0
  br i1 %t128, label %and_rhs65, label %and_end66
and_rhs65:
  %r129 = load i64, ptr %slot.src, align 8
  %r130 = load i64, ptr %slot.i, align 8
  %r131 = call i64 @nova_rt_index_get(i64 %r129, i64 %r130)
  %r132 = call i64 @is_digit_char(i64 %r131)
  br label %and_done67
and_done67:
  br label %and_end66
and_end66:
  %r127 = phi i64 [0, %and_entry64], [%r132, %and_done67]
  %t133 = icmp ne i64 %r127, 0
  br i1 %t133, label %while_body62, label %while_exit63
while_body62:
  %r134 = load i64, ptr %slot.i, align 8
  %r135 = call i64 @nova_rt_add(i64 %r134, i64 1)
  store i64 %r135, ptr %slot.i, align 8
  br label %while_hdr61
while_exit63:
  %r136 = getelementptr inbounds [1 x i8], ptr @.str.6, i64 0, i64 0
  %r137 = ptrtoint ptr %r136 to i64
  store i64 %r137, ptr %slot.num, align 8
  %r138 = load i64, ptr %slot.start, align 8
  store i64 %r138, ptr %slot.j, align 8
  br label %while_hdr68
while_hdr68:
  %r139 = load i64, ptr %slot.j, align 8
  %r140 = load i64, ptr %slot.i, align 8
  %t142 = icmp slt i64 %r139, %r140
  %r141 = zext i1 %t142 to i64
  %t143 = icmp ne i64 %r141, 0
  br i1 %t143, label %while_body69, label %while_exit70
while_body69:
  %r144 = load i64, ptr %slot.num, align 8
  %r145 = load i64, ptr %slot.src, align 8
  %r146 = load i64, ptr %slot.j, align 8
  %r147 = call i64 @nova_rt_index_get(i64 %r145, i64 %r146)
  %r148 = call i64 @nova_rt_add(i64 %r144, i64 %r147)
  store i64 %r148, ptr %slot.num, align 8
  %r149 = load i64, ptr %slot.j, align 8
  %r150 = call i64 @nova_rt_add(i64 %r149, i64 1)
  store i64 %r150, ptr %slot.j, align 8
  br label %while_hdr68
while_exit70:
  %r151 = load i64, ptr %slot.tokens, align 8
  %r152 = call ptr @nova_rt_struct_alloc(i64 16)
  %r153 = getelementptr inbounds [4 x i8], ptr @.str.8, i64 0, i64 0
  %r154 = ptrtoint ptr %r153 to i64
  %t155 = getelementptr i64, ptr %r152, i64 0
  store i64 %r154, ptr %t155, align 8
  %r156 = load i64, ptr %slot.num, align 8
  %t157 = getelementptr i64, ptr %r152, i64 1
  store i64 %r156, ptr %t157, align 8
  %r158 = ptrtoint ptr %r152 to i64
  %r159 = call i64 @nova_rt_list_append(i64 %r151, i64 %r158)
  br label %merge60
else59:
  %r160 = load i64, ptr %slot.ch, align 8
  %r161 = getelementptr inbounds [2 x i8], ptr @.str.9, i64 0, i64 0
  %r162 = ptrtoint ptr %r161 to i64
  %t164 = call i64 @nova_rt_eq(i64 %r160, i64 %r162)
  %r163 = and i64 %t164, 1
  %t165 = icmp ne i64 %t164, 0
  br i1 %t165, label %then71, label %else72
then71:
  %r166 = load i64, ptr %slot.tokens, align 8
  %r167 = call ptr @nova_rt_struct_alloc(i64 16)
  %r168 = getelementptr inbounds [3 x i8], ptr @.str.10, i64 0, i64 0
  %r169 = ptrtoint ptr %r168 to i64
  %t170 = getelementptr i64, ptr %r167, i64 0
  store i64 %r169, ptr %t170, align 8
  %r171 = getelementptr inbounds [2 x i8], ptr @.str.9, i64 0, i64 0
  %r172 = ptrtoint ptr %r171 to i64
  %t173 = getelementptr i64, ptr %r167, i64 1
  store i64 %r172, ptr %t173, align 8
  %r174 = ptrtoint ptr %r167 to i64
  %r175 = call i64 @nova_rt_list_append(i64 %r166, i64 %r174)
  %r176 = load i64, ptr %slot.i, align 8
  %r177 = call i64 @nova_rt_add(i64 %r176, i64 1)
  store i64 %r177, ptr %slot.i, align 8
  br label %merge73
else72:
  %r178 = load i64, ptr %slot.ch, align 8
  %r179 = getelementptr inbounds [2 x i8], ptr @.str.11, i64 0, i64 0
  %r180 = ptrtoint ptr %r179 to i64
  %t182 = call i64 @nova_rt_eq(i64 %r178, i64 %r180)
  %r181 = and i64 %t182, 1
  %t183 = icmp ne i64 %t182, 0
  br i1 %t183, label %then74, label %else75
then74:
  %r184 = load i64, ptr %slot.tokens, align 8
  %r185 = call ptr @nova_rt_struct_alloc(i64 16)
  %r186 = getelementptr inbounds [3 x i8], ptr @.str.12, i64 0, i64 0
  %r187 = ptrtoint ptr %r186 to i64
  %t188 = getelementptr i64, ptr %r185, i64 0
  store i64 %r187, ptr %t188, align 8
  %r189 = getelementptr inbounds [2 x i8], ptr @.str.11, i64 0, i64 0
  %r190 = ptrtoint ptr %r189 to i64
  %t191 = getelementptr i64, ptr %r185, i64 1
  store i64 %r190, ptr %t191, align 8
  %r192 = ptrtoint ptr %r185 to i64
  %r193 = call i64 @nova_rt_list_append(i64 %r184, i64 %r192)
  %r194 = load i64, ptr %slot.i, align 8
  %r195 = call i64 @nova_rt_add(i64 %r194, i64 1)
  store i64 %r195, ptr %slot.i, align 8
  br label %merge76
else75:
  %r196 = load i64, ptr %slot.ch, align 8
  %r197 = getelementptr inbounds [2 x i8], ptr @.str.13, i64 0, i64 0
  %r198 = ptrtoint ptr %r197 to i64
  %t200 = call i64 @nova_rt_eq(i64 %r196, i64 %r198)
  %r199 = and i64 %t200, 1
  %t201 = icmp ne i64 %t200, 0
  br i1 %t201, label %then77, label %else78
then77:
  %r202 = load i64, ptr %slot.tokens, align 8
  %r203 = call ptr @nova_rt_struct_alloc(i64 16)
  %r204 = getelementptr inbounds [3 x i8], ptr @.str.14, i64 0, i64 0
  %r205 = ptrtoint ptr %r204 to i64
  %t206 = getelementptr i64, ptr %r203, i64 0
  store i64 %r205, ptr %t206, align 8
  %r207 = getelementptr inbounds [2 x i8], ptr @.str.13, i64 0, i64 0
  %r208 = ptrtoint ptr %r207 to i64
  %t209 = getelementptr i64, ptr %r203, i64 1
  store i64 %r208, ptr %t209, align 8
  %r210 = ptrtoint ptr %r203 to i64
  %r211 = call i64 @nova_rt_list_append(i64 %r202, i64 %r210)
  %r212 = load i64, ptr %slot.i, align 8
  %r213 = call i64 @nova_rt_add(i64 %r212, i64 1)
  store i64 %r213, ptr %slot.i, align 8
  br label %merge79
else78:
  %r214 = load i64, ptr %slot.tokens, align 8
  %r215 = call ptr @nova_rt_struct_alloc(i64 16)
  %r216 = getelementptr inbounds [2 x i8], ptr @.str.15, i64 0, i64 0
  %r217 = ptrtoint ptr %r216 to i64
  %t218 = getelementptr i64, ptr %r215, i64 0
  store i64 %r217, ptr %t218, align 8
  %r219 = load i64, ptr %slot.ch, align 8
  %t220 = getelementptr i64, ptr %r215, i64 1
  store i64 %r219, ptr %t220, align 8
  %r221 = ptrtoint ptr %r215 to i64
  %r222 = call i64 @nova_rt_list_append(i64 %r214, i64 %r221)
  %r223 = load i64, ptr %slot.i, align 8
  %r224 = call i64 @nova_rt_add(i64 %r223, i64 1)
  store i64 %r224, ptr %slot.i, align 8
  br label %merge79
merge79:
  br label %merge76
merge76:
  br label %merge73
merge73:
  br label %merge60
merge60:
  br label %merge39
merge39:
  br label %merge36
merge36:
  br label %merge33
merge33:
  br label %while_hdr24
while_exit26:
  %r225 = load i64, ptr %slot.tokens, align 8
  ret i64 %r225
}

define i64 @nova_main() nounwind {
entry:
  %slot.test_src = alloca i64, align 8
  store i64 0, ptr %slot.test_src, align 8
  %slot.toks = alloca i64, align 8
  store i64 0, ptr %slot.toks, align 8
  %slot.t = alloca i64, align 8
  store i64 0, ptr %slot.t, align 8
  %slot.kind = alloca i64, align 8
  store i64 0, ptr %slot.kind, align 8
  %slot.value = alloca i64, align 8
  store i64 0, ptr %slot.value, align 8
  %r0 = getelementptr inbounds [21 x i8], ptr @.str.16, i64 0, i64 0
  %r1 = ptrtoint ptr %r0 to i64
  store i64 %r1, ptr %slot.test_src, align 8
  %r2 = load i64, ptr %slot.test_src, align 8
  %r3 = call i64 @tokenize_simple(i64 %r2)
  store i64 %r3, ptr %slot.toks, align 8
  %r4 = load i64, ptr %slot.toks, align 8
  %r5 = call i64 @nova_rt_len_any(i64 %r4)
  %r6 = call i64 @nova_rt_print_any(i64 %r5)
  %r7 = load i64, ptr %slot.toks, align 8
  %r8 = call i64 @nova_rt_len_any(i64 %r7)
  %slot.__for_idx_80 = alloca i64, align 8
  store i64 0, ptr %slot.__for_idx_80, align 8
  br label %for_hdr80
for_hdr80:
  %r9 = load i64, ptr %slot.__for_idx_80, align 8
  %t10 = icmp slt i64 %r9, %r8
  br i1 %t10, label %for_body81, label %for_exit82
for_body81:
  %r11 = call i64 @nova_rt_index_get(i64 %r7, i64 %r9)
  store i64 %r11, ptr %slot.t, align 8
  %r12 = load i64, ptr %slot.t, align 8
  %t13 = inttoptr i64 %r12 to ptr
  %t14 = getelementptr i64, ptr %t13, i64 0
  %r15 = load i64, ptr %t14, align 8
  store i64 %r15, ptr %slot.kind, align 8
  %t16 = getelementptr i64, ptr %t13, i64 1
  %r17 = load i64, ptr %t16, align 8
  store i64 %r17, ptr %slot.value, align 8
  %r18 = load i64, ptr %slot.kind, align 8
  %r19 = getelementptr inbounds [2 x i8], ptr @.str.1, i64 0, i64 0
  %r20 = ptrtoint ptr %r19 to i64
  %r21 = call i64 @nova_rt_add(i64 %r18, i64 %r20)
  %r22 = load i64, ptr %slot.value, align 8
  %r23 = call i64 @nova_rt_add(i64 %r21, i64 %r22)
  %r24 = call i64 @nova_rt_print_any(i64 %r23)
  %r26 = load i64, ptr %slot.__for_idx_80, align 8
  %r25 = add i64 %r26, 1
  store i64 %r25, ptr %slot.__for_idx_80, align 8
  br label %for_hdr80
for_exit82:
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
@.str.3 = private unnamed_addr constant [2 x i8] c"\0A\00"
@.str.4 = private unnamed_addr constant [3 x i8] c"NL\00"
@.str.5 = private unnamed_addr constant [3 x i8] c"\\n\00"
@.str.6 = private unnamed_addr constant [1 x i8] c"\00"
@.str.7 = private unnamed_addr constant [3 x i8] c"ID\00"
@.str.8 = private unnamed_addr constant [4 x i8] c"NUM\00"
@.str.9 = private unnamed_addr constant [2 x i8] c"=\00"
@.str.10 = private unnamed_addr constant [3 x i8] c"EQ\00"
@.str.11 = private unnamed_addr constant [2 x i8] c"(\00"
@.str.12 = private unnamed_addr constant [3 x i8] c"LP\00"
@.str.13 = private unnamed_addr constant [2 x i8] c")\00"
@.str.14 = private unnamed_addr constant [3 x i8] c"RP\00"
@.str.15 = private unnamed_addr constant [2 x i8] c"?\00"
@.str.16 = private unnamed_addr constant [21 x i8] c"let x = 42\0Aprint(x)\0A\00"
