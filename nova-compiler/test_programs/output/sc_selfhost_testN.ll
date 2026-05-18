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
  %slot.__sc_6 = alloca i64, align 8
  store i64 0, ptr %slot.__sc_6, align 8
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
  %br_then3 = icmp ne i64 %r8, 0
  br i1 %br_then3, label %then3, label %else4
then3:
  %r9 = add i64 1, 0
  ret i64 %r9
else4:
  br label %endif5
endif5:
  %r10 = load i64, ptr %slot.c, align 8
  %r11 = add i64 97, 0
  %r12.cmp = icmp sge i64 %r10, %r11
  %r12 = zext i1 %r12.cmp to i64
  store i64 %r12, ptr %slot.__sc_6, align 8
  %br_and_rhs7 = icmp ne i64 %r12, 0
  br i1 %br_and_rhs7, label %and_rhs7, label %and_merge8
and_rhs7:
  %r13 = load i64, ptr %slot.c, align 8
  %r14 = add i64 122, 0
  %r15.cmp = icmp sle i64 %r13, %r14
  %r15 = zext i1 %r15.cmp to i64
  store i64 %r15, ptr %slot.__sc_6, align 8
  br label %and_merge8
and_merge8:
  %r16 = load i64, ptr %slot.__sc_6, align 8
  %br_then9 = icmp ne i64 %r16, 0
  br i1 %br_then9, label %then9, label %else10
then9:
  %r17 = add i64 1, 0
  ret i64 %r17
else10:
  br label %endif11
endif11:
  %r18 = load i64, ptr %slot.ch, align 8
  %r19.p = getelementptr inbounds [2 x i8], ptr @.str.0, i64 0, i64 0
  %r19 = ptrtoint ptr %r19.p to i64
  %r20 = call i64 @nova_rt_eq(i64 %r18, i64 %r19)
  %br_then12 = icmp ne i64 %r20, 0
  br i1 %br_then12, label %then12, label %else13
then12:
  %r21 = add i64 1, 0
  ret i64 %r21
else13:
  br label %endif14
endif14:
  %r22 = add i64 0, 0
  ret i64 %r22
}

define i64 @is_digit(i64 %p0) nounwind {
entry:
  %slot.ch = alloca i64, align 8
  store i64 %p0, ptr %slot.ch, align 8
  %slot.c = alloca i64, align 8
  store i64 0, ptr %slot.c, align 8
  %slot.__sc_15 = alloca i64, align 8
  store i64 0, ptr %slot.__sc_15, align 8
  %r0 = load i64, ptr %slot.ch, align 8
  %r1 = call i64 @nova_rt_ord(i64 %r0)
  store i64 %r1, ptr %slot.c, align 8
  %r2 = load i64, ptr %slot.c, align 8
  %r3 = add i64 48, 0
  %r4.cmp = icmp sge i64 %r2, %r3
  %r4 = zext i1 %r4.cmp to i64
  store i64 %r4, ptr %slot.__sc_15, align 8
  %br_and_rhs16 = icmp ne i64 %r4, 0
  br i1 %br_and_rhs16, label %and_rhs16, label %and_merge17
and_rhs16:
  %r5 = load i64, ptr %slot.c, align 8
  %r6 = add i64 57, 0
  %r7.cmp = icmp sle i64 %r5, %r6
  %r7 = zext i1 %r7.cmp to i64
  store i64 %r7, ptr %slot.__sc_15, align 8
  br label %and_merge17
and_merge17:
  %r8 = load i64, ptr %slot.__sc_15, align 8
  ret i64 %r8
}

define i64 @tokenize(i64 %p0) nounwind {
entry:
  %slot.source = alloca i64, align 8
  store i64 %p0, ptr %slot.source, align 8
  %slot.tokens = alloca i64, align 8
  store i64 0, ptr %slot.tokens, align 8
  %slot.i = alloca i64, align 8
  store i64 0, ptr %slot.i, align 8
  %slot.ch = alloca i64, align 8
  store i64 0, ptr %slot.ch, align 8
  %slot.__sc_21 = alloca i64, align 8
  store i64 0, ptr %slot.__sc_21, align 8
  %slot.start = alloca i64, align 8
  store i64 0, ptr %slot.start, align 8
  %slot.__sc_33 = alloca i64, align 8
  store i64 0, ptr %slot.__sc_33, align 8
  %slot.word = alloca i64, align 8
  store i64 0, ptr %slot.word, align 8
  %slot.j = alloca i64, align 8
  store i64 0, ptr %slot.j, align 8
  %slot.__sc_45 = alloca i64, align 8
  store i64 0, ptr %slot.__sc_45, align 8
  %slot.num = alloca i64, align 8
  store i64 0, ptr %slot.num, align 8
  %r0 = call i64 @nova_rt_list_create()
  store i64 %r0, ptr %slot.tokens, align 8
  %r1 = add i64 0, 0
  store i64 %r1, ptr %slot.i, align 8
  br label %while_hdr18
while_hdr18:
  %r2 = load i64, ptr %slot.i, align 8
  %r3 = load i64, ptr %slot.source, align 8
  %r4 = call i64 @nova_rt_len_any(i64 %r3)
  %r5.cmp = icmp slt i64 %r2, %r4
  %r5 = zext i1 %r5.cmp to i64
  %br_while_body19 = icmp ne i64 %r5, 0
  br i1 %br_while_body19, label %while_body19, label %while_exit20
while_body19:
  %r6 = load i64, ptr %slot.source, align 8
  %r7 = load i64, ptr %slot.i, align 8
  %r8 = call i64 @nova_rt_index_get(i64 %r6, i64 %r7)
  store i64 %r8, ptr %slot.ch, align 8
  %r9 = load i64, ptr %slot.ch, align 8
  %r10.p = getelementptr inbounds [2 x i8], ptr @.str.1, i64 0, i64 0
  %r10 = ptrtoint ptr %r10.p to i64
  %r11 = call i64 @nova_rt_eq(i64 %r9, i64 %r10)
  store i64 %r11, ptr %slot.__sc_21, align 8
  %br_or_merge23 = icmp ne i64 %r11, 0
  br i1 %br_or_merge23, label %or_merge23, label %or_rhs22
or_rhs22:
  %r12 = load i64, ptr %slot.ch, align 8
  %r13.p = getelementptr inbounds [2 x i8], ptr @.str.2, i64 0, i64 0
  %r13 = ptrtoint ptr %r13.p to i64
  %r14 = call i64 @nova_rt_eq(i64 %r12, i64 %r13)
  store i64 %r14, ptr %slot.__sc_21, align 8
  br label %or_merge23
or_merge23:
  %r15 = load i64, ptr %slot.__sc_21, align 8
  %br_then24 = icmp ne i64 %r15, 0
  br i1 %br_then24, label %then24, label %else25
then24:
  %r16 = load i64, ptr %slot.i, align 8
  %r17 = add i64 1, 0
  %r18 = add i64 %r16, %r17
  store i64 %r18, ptr %slot.i, align 8
  br label %endif26
else25:
  %r19 = load i64, ptr %slot.ch, align 8
  %r20 = call i64 @is_alpha(i64 %r19)
  %br_then27 = icmp ne i64 %r20, 0
  br i1 %br_then27, label %then27, label %else28
then27:
  %r21 = load i64, ptr %slot.i, align 8
  store i64 %r21, ptr %slot.start, align 8
  br label %while_hdr30
while_hdr30:
  %r22 = load i64, ptr %slot.i, align 8
  %r23 = load i64, ptr %slot.source, align 8
  %r24 = call i64 @nova_rt_len_any(i64 %r23)
  %r25.cmp = icmp slt i64 %r22, %r24
  %r25 = zext i1 %r25.cmp to i64
  store i64 %r25, ptr %slot.__sc_33, align 8
  %br_and_rhs34 = icmp ne i64 %r25, 0
  br i1 %br_and_rhs34, label %and_rhs34, label %and_merge35
and_rhs34:
  %r26 = load i64, ptr %slot.source, align 8
  %r27 = load i64, ptr %slot.i, align 8
  %r28 = call i64 @nova_rt_index_get(i64 %r26, i64 %r27)
  %r29 = call i64 @is_alpha(i64 %r28)
  store i64 %r29, ptr %slot.__sc_33, align 8
  br label %and_merge35
and_merge35:
  %r30 = load i64, ptr %slot.__sc_33, align 8
  %br_while_body31 = icmp ne i64 %r30, 0
  br i1 %br_while_body31, label %while_body31, label %while_exit32
while_body31:
  %r31 = load i64, ptr %slot.i, align 8
  %r32 = add i64 1, 0
  %r33 = add i64 %r31, %r32
  store i64 %r33, ptr %slot.i, align 8
  br label %while_hdr30
while_exit32:
  %r34.p = getelementptr inbounds [1 x i8], ptr @.str.3, i64 0, i64 0
  %r34 = ptrtoint ptr %r34.p to i64
  store i64 %r34, ptr %slot.word, align 8
  %r35 = load i64, ptr %slot.start, align 8
  store i64 %r35, ptr %slot.j, align 8
  br label %while_hdr36
while_hdr36:
  %r36 = load i64, ptr %slot.j, align 8
  %r37 = load i64, ptr %slot.i, align 8
  %r38.cmp = icmp slt i64 %r36, %r37
  %r38 = zext i1 %r38.cmp to i64
  %br_while_body37 = icmp ne i64 %r38, 0
  br i1 %br_while_body37, label %while_body37, label %while_exit38
while_body37:
  %r39 = load i64, ptr %slot.word, align 8
  %r40 = load i64, ptr %slot.source, align 8
  %r41 = load i64, ptr %slot.j, align 8
  %r42 = call i64 @nova_rt_index_get(i64 %r40, i64 %r41)
  %r43 = call i64 @nova_rt_str_concat(i64 %r39, i64 %r42)
  store i64 %r43, ptr %slot.word, align 8
  %r44 = load i64, ptr %slot.j, align 8
  %r45 = add i64 1, 0
  %r46 = add i64 %r44, %r45
  store i64 %r46, ptr %slot.j, align 8
  br label %while_hdr36
while_exit38:
  %r47 = load i64, ptr %slot.tokens, align 8
  %r48.p = getelementptr inbounds [6 x i8], ptr @.str.4, i64 0, i64 0
  %r48 = ptrtoint ptr %r48.p to i64
  %r49 = load i64, ptr %slot.word, align 8
  %r50.ptr = call ptr @nova_rt_struct_alloc(i64 16)
  %r50.f0 = getelementptr i64, ptr %r50.ptr, i64 0
  store i64 %r48, ptr %r50.f0, align 8
  %r50.f1 = getelementptr i64, ptr %r50.ptr, i64 1
  store i64 %r49, ptr %r50.f1, align 8
  %r50 = ptrtoint ptr %r50.ptr to i64
  %r51 = call i64 @nova_rt_list_append(i64 %r47, i64 %r50)
  br label %endif29
else28:
  %r52 = load i64, ptr %slot.ch, align 8
  %r53 = call i64 @is_digit(i64 %r52)
  %br_then39 = icmp ne i64 %r53, 0
  br i1 %br_then39, label %then39, label %else40
then39:
  %r54 = load i64, ptr %slot.i, align 8
  store i64 %r54, ptr %slot.start, align 8
  br label %while_hdr42
while_hdr42:
  %r55 = load i64, ptr %slot.i, align 8
  %r56 = load i64, ptr %slot.source, align 8
  %r57 = call i64 @nova_rt_len_any(i64 %r56)
  %r58.cmp = icmp slt i64 %r55, %r57
  %r58 = zext i1 %r58.cmp to i64
  store i64 %r58, ptr %slot.__sc_45, align 8
  %br_and_rhs46 = icmp ne i64 %r58, 0
  br i1 %br_and_rhs46, label %and_rhs46, label %and_merge47
and_rhs46:
  %r59 = load i64, ptr %slot.source, align 8
  %r60 = load i64, ptr %slot.i, align 8
  %r61 = call i64 @nova_rt_index_get(i64 %r59, i64 %r60)
  %r62 = call i64 @is_digit(i64 %r61)
  store i64 %r62, ptr %slot.__sc_45, align 8
  br label %and_merge47
and_merge47:
  %r63 = load i64, ptr %slot.__sc_45, align 8
  %br_while_body43 = icmp ne i64 %r63, 0
  br i1 %br_while_body43, label %while_body43, label %while_exit44
while_body43:
  %r64 = load i64, ptr %slot.i, align 8
  %r65 = add i64 1, 0
  %r66 = add i64 %r64, %r65
  store i64 %r66, ptr %slot.i, align 8
  br label %while_hdr42
while_exit44:
  %r67.p = getelementptr inbounds [1 x i8], ptr @.str.3, i64 0, i64 0
  %r67 = ptrtoint ptr %r67.p to i64
  store i64 %r67, ptr %slot.num, align 8
  %r68 = load i64, ptr %slot.start, align 8
  store i64 %r68, ptr %slot.j, align 8
  br label %while_hdr48
while_hdr48:
  %r69 = load i64, ptr %slot.j, align 8
  %r70 = load i64, ptr %slot.i, align 8
  %r71.cmp = icmp slt i64 %r69, %r70
  %r71 = zext i1 %r71.cmp to i64
  %br_while_body49 = icmp ne i64 %r71, 0
  br i1 %br_while_body49, label %while_body49, label %while_exit50
while_body49:
  %r72 = load i64, ptr %slot.num, align 8
  %r73 = load i64, ptr %slot.source, align 8
  %r74 = load i64, ptr %slot.j, align 8
  %r75 = call i64 @nova_rt_index_get(i64 %r73, i64 %r74)
  %r76 = call i64 @nova_rt_str_concat(i64 %r72, i64 %r75)
  store i64 %r76, ptr %slot.num, align 8
  %r77 = load i64, ptr %slot.j, align 8
  %r78 = add i64 1, 0
  %r79 = add i64 %r77, %r78
  store i64 %r79, ptr %slot.j, align 8
  br label %while_hdr48
while_exit50:
  %r80 = load i64, ptr %slot.tokens, align 8
  %r81.p = getelementptr inbounds [4 x i8], ptr @.str.5, i64 0, i64 0
  %r81 = ptrtoint ptr %r81.p to i64
  %r82 = load i64, ptr %slot.num, align 8
  %r83.ptr = call ptr @nova_rt_struct_alloc(i64 16)
  %r83.f0 = getelementptr i64, ptr %r83.ptr, i64 0
  store i64 %r81, ptr %r83.f0, align 8
  %r83.f1 = getelementptr i64, ptr %r83.ptr, i64 1
  store i64 %r82, ptr %r83.f1, align 8
  %r83 = ptrtoint ptr %r83.ptr to i64
  %r84 = call i64 @nova_rt_list_append(i64 %r80, i64 %r83)
  br label %endif41
else40:
  %r85 = load i64, ptr %slot.ch, align 8
  %r86.p = getelementptr inbounds [2 x i8], ptr @.str.6, i64 0, i64 0
  %r86 = ptrtoint ptr %r86.p to i64
  %r87 = call i64 @nova_rt_eq(i64 %r85, i64 %r86)
  %br_then51 = icmp ne i64 %r87, 0
  br i1 %br_then51, label %then51, label %else52
then51:
  %r88 = load i64, ptr %slot.tokens, align 8
  %r89.p = getelementptr inbounds [7 x i8], ptr @.str.7, i64 0, i64 0
  %r89 = ptrtoint ptr %r89.p to i64
  %r90.p = getelementptr inbounds [2 x i8], ptr @.str.6, i64 0, i64 0
  %r90 = ptrtoint ptr %r90.p to i64
  %r91.ptr = call ptr @nova_rt_struct_alloc(i64 16)
  %r91.f0 = getelementptr i64, ptr %r91.ptr, i64 0
  store i64 %r89, ptr %r91.f0, align 8
  %r91.f1 = getelementptr i64, ptr %r91.ptr, i64 1
  store i64 %r90, ptr %r91.f1, align 8
  %r91 = ptrtoint ptr %r91.ptr to i64
  %r92 = call i64 @nova_rt_list_append(i64 %r88, i64 %r91)
  %r93 = load i64, ptr %slot.i, align 8
  %r94 = add i64 1, 0
  %r95 = add i64 %r93, %r94
  store i64 %r95, ptr %slot.i, align 8
  br label %endif53
else52:
  %r96 = load i64, ptr %slot.ch, align 8
  %r97.p = getelementptr inbounds [2 x i8], ptr @.str.8, i64 0, i64 0
  %r97 = ptrtoint ptr %r97.p to i64
  %r98 = call i64 @nova_rt_eq(i64 %r96, i64 %r97)
  %br_then54 = icmp ne i64 %r98, 0
  br i1 %br_then54, label %then54, label %else55
then54:
  %r99 = load i64, ptr %slot.tokens, align 8
  %r100.p = getelementptr inbounds [3 x i8], ptr @.str.9, i64 0, i64 0
  %r100 = ptrtoint ptr %r100.p to i64
  %r101.p = getelementptr inbounds [2 x i8], ptr @.str.8, i64 0, i64 0
  %r101 = ptrtoint ptr %r101.p to i64
  %r102.ptr = call ptr @nova_rt_struct_alloc(i64 16)
  %r102.f0 = getelementptr i64, ptr %r102.ptr, i64 0
  store i64 %r100, ptr %r102.f0, align 8
  %r102.f1 = getelementptr i64, ptr %r102.ptr, i64 1
  store i64 %r101, ptr %r102.f1, align 8
  %r102 = ptrtoint ptr %r102.ptr to i64
  %r103 = call i64 @nova_rt_list_append(i64 %r99, i64 %r102)
  %r104 = load i64, ptr %slot.i, align 8
  %r105 = add i64 1, 0
  %r106 = add i64 %r104, %r105
  store i64 %r106, ptr %slot.i, align 8
  br label %endif56
else55:
  %r107 = load i64, ptr %slot.ch, align 8
  %r108.p = getelementptr inbounds [2 x i8], ptr @.str.10, i64 0, i64 0
  %r108 = ptrtoint ptr %r108.p to i64
  %r109 = call i64 @nova_rt_eq(i64 %r107, i64 %r108)
  %br_then57 = icmp ne i64 %r109, 0
  br i1 %br_then57, label %then57, label %else58
then57:
  %r110 = load i64, ptr %slot.tokens, align 8
  %r111.p = getelementptr inbounds [7 x i8], ptr @.str.11, i64 0, i64 0
  %r111 = ptrtoint ptr %r111.p to i64
  %r112.p = getelementptr inbounds [2 x i8], ptr @.str.10, i64 0, i64 0
  %r112 = ptrtoint ptr %r112.p to i64
  %r113.ptr = call ptr @nova_rt_struct_alloc(i64 16)
  %r113.f0 = getelementptr i64, ptr %r113.ptr, i64 0
  store i64 %r111, ptr %r113.f0, align 8
  %r113.f1 = getelementptr i64, ptr %r113.ptr, i64 1
  store i64 %r112, ptr %r113.f1, align 8
  %r113 = ptrtoint ptr %r113.ptr to i64
  %r114 = call i64 @nova_rt_list_append(i64 %r110, i64 %r113)
  %r115 = load i64, ptr %slot.i, align 8
  %r116 = add i64 1, 0
  %r117 = add i64 %r115, %r116
  store i64 %r117, ptr %slot.i, align 8
  br label %endif59
else58:
  %r118 = load i64, ptr %slot.ch, align 8
  %r119.p = getelementptr inbounds [2 x i8], ptr @.str.12, i64 0, i64 0
  %r119 = ptrtoint ptr %r119.p to i64
  %r120 = call i64 @nova_rt_eq(i64 %r118, i64 %r119)
  %br_then60 = icmp ne i64 %r120, 0
  br i1 %br_then60, label %then60, label %else61
then60:
  %r121 = load i64, ptr %slot.tokens, align 8
  %r122.p = getelementptr inbounds [7 x i8], ptr @.str.13, i64 0, i64 0
  %r122 = ptrtoint ptr %r122.p to i64
  %r123.p = getelementptr inbounds [2 x i8], ptr @.str.12, i64 0, i64 0
  %r123 = ptrtoint ptr %r123.p to i64
  %r124.ptr = call ptr @nova_rt_struct_alloc(i64 16)
  %r124.f0 = getelementptr i64, ptr %r124.ptr, i64 0
  store i64 %r122, ptr %r124.f0, align 8
  %r124.f1 = getelementptr i64, ptr %r124.ptr, i64 1
  store i64 %r123, ptr %r124.f1, align 8
  %r124 = ptrtoint ptr %r124.ptr to i64
  %r125 = call i64 @nova_rt_list_append(i64 %r121, i64 %r124)
  %r126 = load i64, ptr %slot.i, align 8
  %r127 = add i64 1, 0
  %r128 = add i64 %r126, %r127
  store i64 %r128, ptr %slot.i, align 8
  br label %endif62
else61:
  %r129 = load i64, ptr %slot.i, align 8
  %r130 = add i64 1, 0
  %r131 = add i64 %r129, %r130
  store i64 %r131, ptr %slot.i, align 8
  br label %endif62
endif62:
  br label %endif59
endif59:
  br label %endif56
endif56:
  br label %endif53
endif53:
  br label %endif41
endif41:
  br label %endif29
endif29:
  br label %endif26
endif26:
  br label %while_hdr18
while_exit20:
  %r132 = load i64, ptr %slot.tokens, align 8
  ret i64 %r132
}

define i64 @nova_main() nounwind {
entry:
  %slot.src = alloca i64, align 8
  store i64 0, ptr %slot.src, align 8
  %slot.toks = alloca i64, align 8
  store i64 0, ptr %slot.toks, align 8
  %slot.__for_idx_63 = alloca i64, align 8
  store i64 0, ptr %slot.__for_idx_63, align 8
  %slot.t = alloca i64, align 8
  store i64 0, ptr %slot.t, align 8
  %r0.p = getelementptr inbounds [15 x i8], ptr @.str.14, i64 0, i64 0
  %r0 = ptrtoint ptr %r0.p to i64
  store i64 %r0, ptr %slot.src, align 8
  %r1 = load i64, ptr %slot.src, align 8
  %r2 = call i64 @tokenize(i64 %r1)
  store i64 %r2, ptr %slot.toks, align 8
  %r3 = load i64, ptr %slot.toks, align 8
  %r4 = call i64 @nova_rt_len_any(i64 %r3)
  %r5 = call i64 @nova_rt_print_any(i64 %r4)
  %r6 = load i64, ptr %slot.toks, align 8
  %r7 = call i64 @nova_rt_len_any(i64 %r6)
  %r8 = add i64 0, 0
  store i64 %r8, ptr %slot.__for_idx_63, align 8
  br label %for_hdr63
for_hdr63:
  %r9 = load i64, ptr %slot.__for_idx_63, align 8
  %r10.cmp = icmp slt i64 %r9, %r7
  %r10 = zext i1 %r10.cmp to i64
  %br_for_body64 = icmp ne i64 %r10, 0
  br i1 %br_for_body64, label %for_body64, label %for_exit65
for_body64:
  %r11 = call i64 @nova_rt_index_get(i64 %r6, i64 %r9)
  store i64 %r11, ptr %slot.t, align 8
  %r12 = load i64, ptr %slot.__for_idx_63, align 8
  %r13 = add i64 1, 0
  %r14 = add i64 %r12, %r13
  store i64 %r14, ptr %slot.__for_idx_63, align 8
  br label %for_hdr63
for_exit65:
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
@.str.2 = private unnamed_addr constant [2 x i8] c"\0A\00"
@.str.3 = private unnamed_addr constant [1 x i8] c"\00"
@.str.4 = private unnamed_addr constant [6 x i8] c"IDENT\00"
@.str.5 = private unnamed_addr constant [4 x i8] c"NUM\00"
@.str.6 = private unnamed_addr constant [2 x i8] c"=\00"
@.str.7 = private unnamed_addr constant [7 x i8] c"ASSIGN\00"
@.str.8 = private unnamed_addr constant [2 x i8] c"+\00"
@.str.9 = private unnamed_addr constant [3 x i8] c"OP\00"
@.str.10 = private unnamed_addr constant [2 x i8] c"(\00"
@.str.11 = private unnamed_addr constant [7 x i8] c"LPAREN\00"
@.str.12 = private unnamed_addr constant [2 x i8] c")\00"
@.str.13 = private unnamed_addr constant [7 x i8] c"RPAREN\00"
@.str.14 = private unnamed_addr constant [15 x i8] c"x = add(1 + 2)\00"
