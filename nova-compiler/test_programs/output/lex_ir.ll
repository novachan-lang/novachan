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
  ret i64 0
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
  ret i64 0
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
  ret i64 0
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
  %slot.__sc_36 = alloca i64, align 8
  store i64 0, ptr %slot.__sc_36, align 8
  %slot.start_col = alloca i64, align 8
  store i64 0, ptr %slot.start_col, align 8
  %slot.word = alloca i64, align 8
  store i64 0, ptr %slot.word, align 8
  %slot.__sc_45 = alloca i64, align 8
  store i64 0, ptr %slot.__sc_45, align 8
  %slot.num = alloca i64, align 8
  store i64 0, ptr %slot.num, align 8
  %slot.__sc_54 = alloca i64, align 8
  store i64 0, ptr %slot.__sc_54, align 8
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
  br label %while_hdr24
while_hdr24:
  %r6 = load i64, ptr %slot.pos, align 8
  %r7 = load i64, ptr %slot.length, align 8
  %r8.cmp = icmp slt i64 %r6, %r7
  %r8 = zext i1 %r8.cmp to i64
  %br_while_body25 = icmp ne i64 %r8, 0
  br i1 %br_while_body25, label %while_body25, label %while_exit26
while_body25:
  %r9 = load i64, ptr %slot.source, align 8
  %r10 = load i64, ptr %slot.pos, align 8
  %r11 = call i64 @nova_rt_index_get(i64 %r9, i64 %r10)
  store i64 %r11, ptr %slot.ch, align 8
  %r12 = load i64, ptr %slot.ch, align 8
  %r13.p = getelementptr inbounds [2 x i8], ptr @.str.4, i64 0, i64 0
  %r13 = ptrtoint ptr %r13.p to i64
  %r14 = call i64 @nova_rt_eq(i64 %r12, i64 %r13)
  %br_then27 = icmp ne i64 %r14, 0
  br i1 %br_then27, label %then27, label %else28
then27:
  %r15 = load i64, ptr %slot.tokens, align 8
  %r16.p = getelementptr inbounds [8 x i8], ptr @.str.5, i64 0, i64 0
  %r16 = ptrtoint ptr %r16.p to i64
  %r17.p = getelementptr inbounds [3 x i8], ptr @.str.6, i64 0, i64 0
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
  br label %endif29
else28:
  %r29 = load i64, ptr %slot.ch, align 8
  %r30 = call i64 @is_ws(i64 %r29)
  %br_then30 = icmp ne i64 %r30, 0
  br i1 %br_then30, label %then30, label %else31
then30:
  br label %while_hdr33
while_hdr33:
  %r31 = load i64, ptr %slot.pos, align 8
  %r32 = load i64, ptr %slot.length, align 8
  %r33.cmp = icmp slt i64 %r31, %r32
  %r33 = zext i1 %r33.cmp to i64
  store i64 %r33, ptr %slot.__sc_36, align 8
  %br_and_rhs37 = icmp ne i64 %r33, 0
  br i1 %br_and_rhs37, label %and_rhs37, label %and_merge38
and_rhs37:
  %r34 = load i64, ptr %slot.source, align 8
  %r35 = load i64, ptr %slot.pos, align 8
  %r36 = call i64 @nova_rt_index_get(i64 %r34, i64 %r35)
  %r37 = call i64 @is_ws(i64 %r36)
  store i64 %r37, ptr %slot.__sc_36, align 8
  br label %and_merge38
and_merge38:
  %r38 = load i64, ptr %slot.__sc_36, align 8
  %br_while_body34 = icmp ne i64 %r38, 0
  br i1 %br_while_body34, label %while_body34, label %while_exit35
while_body34:
  %r39 = load i64, ptr %slot.pos, align 8
  %r40 = add i64 1, 0
  %r41 = add i64 %r39, %r40
  store i64 %r41, ptr %slot.pos, align 8
  %r42 = load i64, ptr %slot.col, align 8
  %r43 = add i64 1, 0
  %r44 = add i64 %r42, %r43
  store i64 %r44, ptr %slot.col, align 8
  br label %while_hdr33
while_exit35:
  br label %endif32
else31:
  %r45 = load i64, ptr %slot.ch, align 8
  %r46 = call i64 @is_alpha(i64 %r45)
  %br_then39 = icmp ne i64 %r46, 0
  br i1 %br_then39, label %then39, label %else40
then39:
  %r47 = load i64, ptr %slot.col, align 8
  store i64 %r47, ptr %slot.start_col, align 8
  %r48.p = getelementptr inbounds [1 x i8], ptr @.str.7, i64 0, i64 0
  %r48 = ptrtoint ptr %r48.p to i64
  store i64 %r48, ptr %slot.word, align 8
  br label %while_hdr42
while_hdr42:
  %r49 = load i64, ptr %slot.pos, align 8
  %r50 = load i64, ptr %slot.length, align 8
  %r51.cmp = icmp slt i64 %r49, %r50
  %r51 = zext i1 %r51.cmp to i64
  store i64 %r51, ptr %slot.__sc_45, align 8
  %br_and_rhs46 = icmp ne i64 %r51, 0
  br i1 %br_and_rhs46, label %and_rhs46, label %and_merge47
and_rhs46:
  %r52 = load i64, ptr %slot.source, align 8
  %r53 = load i64, ptr %slot.pos, align 8
  %r54 = call i64 @nova_rt_index_get(i64 %r52, i64 %r53)
  %r55 = call i64 @is_alnum(i64 %r54)
  store i64 %r55, ptr %slot.__sc_45, align 8
  br label %and_merge47
and_merge47:
  %r56 = load i64, ptr %slot.__sc_45, align 8
  %br_while_body43 = icmp ne i64 %r56, 0
  br i1 %br_while_body43, label %while_body43, label %while_exit44
while_body43:
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
  br label %while_hdr42
while_exit44:
  %r68 = load i64, ptr %slot.tokens, align 8
  %r69.p = getelementptr inbounds [6 x i8], ptr @.str.8, i64 0, i64 0
  %r69 = ptrtoint ptr %r69.p to i64
  %r70 = load i64, ptr %slot.word, align 8
  %r71 = load i64, ptr %slot.line, align 8
  %r72 = load i64, ptr %slot.start_col, align 8
  %r73.ptr = call ptr @nova_rt_struct_alloc(i64 32)
  %r73.f0 = getelementptr i64, ptr %r73.ptr, i64 0
  store i64 %r69, ptr %r73.f0, align 8
  %r73.f1 = getelementptr i64, ptr %r73.ptr, i64 1
  store i64 %r70, ptr %r73.f1, align 8
  %r73.f2 = getelementptr i64, ptr %r73.ptr, i64 2
  store i64 %r71, ptr %r73.f2, align 8
  %r73.f3 = getelementptr i64, ptr %r73.ptr, i64 3
  store i64 %r72, ptr %r73.f3, align 8
  %r73 = ptrtoint ptr %r73.ptr to i64
  %r74 = call i64 @nova_rt_list_append(i64 %r68, i64 %r73)
  br label %endif41
else40:
  %r75 = load i64, ptr %slot.ch, align 8
  %r76 = call i64 @is_digit(i64 %r75)
  %br_then48 = icmp ne i64 %r76, 0
  br i1 %br_then48, label %then48, label %else49
then48:
  %r77 = load i64, ptr %slot.col, align 8
  store i64 %r77, ptr %slot.start_col, align 8
  %r78.p = getelementptr inbounds [1 x i8], ptr @.str.7, i64 0, i64 0
  %r78 = ptrtoint ptr %r78.p to i64
  store i64 %r78, ptr %slot.num, align 8
  br label %while_hdr51
while_hdr51:
  %r79 = load i64, ptr %slot.pos, align 8
  %r80 = load i64, ptr %slot.length, align 8
  %r81.cmp = icmp slt i64 %r79, %r80
  %r81 = zext i1 %r81.cmp to i64
  store i64 %r81, ptr %slot.__sc_54, align 8
  %br_and_rhs55 = icmp ne i64 %r81, 0
  br i1 %br_and_rhs55, label %and_rhs55, label %and_merge56
and_rhs55:
  %r82 = load i64, ptr %slot.source, align 8
  %r83 = load i64, ptr %slot.pos, align 8
  %r84 = call i64 @nova_rt_index_get(i64 %r82, i64 %r83)
  %r85 = call i64 @is_digit(i64 %r84)
  store i64 %r85, ptr %slot.__sc_54, align 8
  br label %and_merge56
and_merge56:
  %r86 = load i64, ptr %slot.__sc_54, align 8
  %br_while_body52 = icmp ne i64 %r86, 0
  br i1 %br_while_body52, label %while_body52, label %while_exit53
while_body52:
  %r87 = load i64, ptr %slot.num, align 8
  %r88 = load i64, ptr %slot.source, align 8
  %r89 = load i64, ptr %slot.pos, align 8
  %r90 = call i64 @nova_rt_index_get(i64 %r88, i64 %r89)
  %r91 = call i64 @nova_rt_str_concat(i64 %r87, i64 %r90)
  store i64 %r91, ptr %slot.num, align 8
  %r92 = load i64, ptr %slot.pos, align 8
  %r93 = add i64 1, 0
  %r94 = add i64 %r92, %r93
  store i64 %r94, ptr %slot.pos, align 8
  %r95 = load i64, ptr %slot.col, align 8
  %r96 = add i64 1, 0
  %r97 = add i64 %r95, %r96
  store i64 %r97, ptr %slot.col, align 8
  br label %while_hdr51
while_exit53:
  %r98 = load i64, ptr %slot.tokens, align 8
  %r99.p = getelementptr inbounds [4 x i8], ptr @.str.9, i64 0, i64 0
  %r99 = ptrtoint ptr %r99.p to i64
  %r100 = load i64, ptr %slot.num, align 8
  %r101 = load i64, ptr %slot.line, align 8
  %r102 = load i64, ptr %slot.start_col, align 8
  %r103.ptr = call ptr @nova_rt_struct_alloc(i64 32)
  %r103.f0 = getelementptr i64, ptr %r103.ptr, i64 0
  store i64 %r99, ptr %r103.f0, align 8
  %r103.f1 = getelementptr i64, ptr %r103.ptr, i64 1
  store i64 %r100, ptr %r103.f1, align 8
  %r103.f2 = getelementptr i64, ptr %r103.ptr, i64 2
  store i64 %r101, ptr %r103.f2, align 8
  %r103.f3 = getelementptr i64, ptr %r103.ptr, i64 3
  store i64 %r102, ptr %r103.f3, align 8
  %r103 = ptrtoint ptr %r103.ptr to i64
  %r104 = call i64 @nova_rt_list_append(i64 %r98, i64 %r103)
  br label %endif50
else49:
  %r105 = load i64, ptr %slot.ch, align 8
  %r106.p = getelementptr inbounds [2 x i8], ptr @.str.10, i64 0, i64 0
  %r106 = ptrtoint ptr %r106.p to i64
  %r107 = call i64 @nova_rt_eq(i64 %r105, i64 %r106)
  %br_then57 = icmp ne i64 %r107, 0
  br i1 %br_then57, label %then57, label %else58
then57:
  %r108 = load i64, ptr %slot.tokens, align 8
  %r109.p = getelementptr inbounds [3 x i8], ptr @.str.11, i64 0, i64 0
  %r109 = ptrtoint ptr %r109.p to i64
  %r110.p = getelementptr inbounds [2 x i8], ptr @.str.10, i64 0, i64 0
  %r110 = ptrtoint ptr %r110.p to i64
  %r111 = load i64, ptr %slot.line, align 8
  %r112 = load i64, ptr %slot.col, align 8
  %r113.ptr = call ptr @nova_rt_struct_alloc(i64 32)
  %r113.f0 = getelementptr i64, ptr %r113.ptr, i64 0
  store i64 %r109, ptr %r113.f0, align 8
  %r113.f1 = getelementptr i64, ptr %r113.ptr, i64 1
  store i64 %r110, ptr %r113.f1, align 8
  %r113.f2 = getelementptr i64, ptr %r113.ptr, i64 2
  store i64 %r111, ptr %r113.f2, align 8
  %r113.f3 = getelementptr i64, ptr %r113.ptr, i64 3
  store i64 %r112, ptr %r113.f3, align 8
  %r113 = ptrtoint ptr %r113.ptr to i64
  %r114 = call i64 @nova_rt_list_append(i64 %r108, i64 %r113)
  %r115 = load i64, ptr %slot.pos, align 8
  %r116 = add i64 1, 0
  %r117 = add i64 %r115, %r116
  store i64 %r117, ptr %slot.pos, align 8
  %r118 = load i64, ptr %slot.col, align 8
  %r119 = add i64 1, 0
  %r120 = add i64 %r118, %r119
  store i64 %r120, ptr %slot.col, align 8
  br label %endif59
else58:
  %r121 = load i64, ptr %slot.ch, align 8
  %r122.p = getelementptr inbounds [2 x i8], ptr @.str.12, i64 0, i64 0
  %r122 = ptrtoint ptr %r122.p to i64
  %r123 = call i64 @nova_rt_eq(i64 %r121, i64 %r122)
  %br_then60 = icmp ne i64 %r123, 0
  br i1 %br_then60, label %then60, label %else61
then60:
  %r124 = load i64, ptr %slot.tokens, align 8
  %r125.p = getelementptr inbounds [7 x i8], ptr @.str.13, i64 0, i64 0
  %r125 = ptrtoint ptr %r125.p to i64
  %r126.p = getelementptr inbounds [2 x i8], ptr @.str.12, i64 0, i64 0
  %r126 = ptrtoint ptr %r126.p to i64
  %r127 = load i64, ptr %slot.line, align 8
  %r128 = load i64, ptr %slot.col, align 8
  %r129.ptr = call ptr @nova_rt_struct_alloc(i64 32)
  %r129.f0 = getelementptr i64, ptr %r129.ptr, i64 0
  store i64 %r125, ptr %r129.f0, align 8
  %r129.f1 = getelementptr i64, ptr %r129.ptr, i64 1
  store i64 %r126, ptr %r129.f1, align 8
  %r129.f2 = getelementptr i64, ptr %r129.ptr, i64 2
  store i64 %r127, ptr %r129.f2, align 8
  %r129.f3 = getelementptr i64, ptr %r129.ptr, i64 3
  store i64 %r128, ptr %r129.f3, align 8
  %r129 = ptrtoint ptr %r129.ptr to i64
  %r130 = call i64 @nova_rt_list_append(i64 %r124, i64 %r129)
  %r131 = load i64, ptr %slot.pos, align 8
  %r132 = add i64 1, 0
  %r133 = add i64 %r131, %r132
  store i64 %r133, ptr %slot.pos, align 8
  %r134 = load i64, ptr %slot.col, align 8
  %r135 = add i64 1, 0
  %r136 = add i64 %r134, %r135
  store i64 %r136, ptr %slot.col, align 8
  br label %endif62
else61:
  %r137 = load i64, ptr %slot.pos, align 8
  %r138 = add i64 1, 0
  %r139 = add i64 %r137, %r138
  store i64 %r139, ptr %slot.pos, align 8
  %r140 = load i64, ptr %slot.col, align 8
  %r141 = add i64 1, 0
  %r142 = add i64 %r140, %r141
  store i64 %r142, ptr %slot.col, align 8
  br label %endif62
endif62:
  br label %endif59
endif59:
  br label %endif50
endif50:
  br label %endif41
endif41:
  br label %endif32
endif32:
  br label %endif29
endif29:
  br label %while_hdr24
while_exit26:
  %r143 = load i64, ptr %slot.tokens, align 8
  %r144.p = getelementptr inbounds [4 x i8], ptr @.str.14, i64 0, i64 0
  %r144 = ptrtoint ptr %r144.p to i64
  %r145.p = getelementptr inbounds [1 x i8], ptr @.str.7, i64 0, i64 0
  %r145 = ptrtoint ptr %r145.p to i64
  %r146 = load i64, ptr %slot.line, align 8
  %r147 = load i64, ptr %slot.col, align 8
  %r148.ptr = call ptr @nova_rt_struct_alloc(i64 32)
  %r148.f0 = getelementptr i64, ptr %r148.ptr, i64 0
  store i64 %r144, ptr %r148.f0, align 8
  %r148.f1 = getelementptr i64, ptr %r148.ptr, i64 1
  store i64 %r145, ptr %r148.f1, align 8
  %r148.f2 = getelementptr i64, ptr %r148.ptr, i64 2
  store i64 %r146, ptr %r148.f2, align 8
  %r148.f3 = getelementptr i64, ptr %r148.ptr, i64 3
  store i64 %r147, ptr %r148.f3, align 8
  %r148 = ptrtoint ptr %r148.ptr to i64
  %r149 = call i64 @nova_rt_list_append(i64 %r143, i64 %r148)
  %r150 = load i64, ptr %slot.tokens, align 8
  ret i64 %r150
}

define i64 @nova_main() nounwind {
entry:
  %slot.result = alloca i64, align 8
  store i64 0, ptr %slot.result, align 8
  %slot.non_nl = alloca i64, align 8
  store i64 0, ptr %slot.non_nl, align 8
  %slot.__for_idx_63 = alloca i64, align 8
  store i64 0, ptr %slot.__for_idx_63, align 8
  %slot.t = alloca i64, align 8
  store i64 0, ptr %slot.t, align 8
  %r0.p = getelementptr inbounds [15 x i8], ptr @.str.15, i64 0, i64 0
  %r0 = ptrtoint ptr %r0.p to i64
  %r1 = call i64 @tokenize(i64 %r0)
  store i64 %r1, ptr %slot.result, align 8
  %r2 = call i64 @nova_rt_list_create()
  store i64 %r2, ptr %slot.non_nl, align 8
  %r3 = load i64, ptr %slot.result, align 8
  %r4 = call i64 @nova_rt_len_any(i64 %r3)
  %r5 = add i64 0, 0
  store i64 %r5, ptr %slot.__for_idx_63, align 8
  br label %for_hdr63
for_hdr63:
  %r6 = load i64, ptr %slot.__for_idx_63, align 8
  %r7.cmp = icmp slt i64 %r6, %r4
  %r7 = zext i1 %r7.cmp to i64
  %br_for_body64 = icmp ne i64 %r7, 0
  br i1 %br_for_body64, label %for_body64, label %for_exit65
for_body64:
  %r8 = call i64 @nova_rt_index_get(i64 %r3, i64 %r6)
  store i64 %r8, ptr %slot.t, align 8
  %r9 = load i64, ptr %slot.__for_idx_63, align 8
  %r10 = add i64 1, 0
  %r11 = add i64 %r9, %r10
  store i64 %r11, ptr %slot.__for_idx_63, align 8
  br label %for_hdr63
for_exit65:
  %r12.p = getelementptr inbounds [8 x i8], ptr @.str.16, i64 0, i64 0
  %r12 = ptrtoint ptr %r12.p to i64
  %r13 = load i64, ptr %slot.result, align 8
  %r14 = call i64 @nova_rt_len_any(i64 %r13)
  %r15 = call i64 @nova_rt_int_to_str(i64 %r14)
  %r16 = call i64 @nova_rt_str_concat(i64 %r12, i64 %r15)
  %r17.p = getelementptr inbounds [11 x i8], ptr @.str.17, i64 0, i64 0
  %r17 = ptrtoint ptr %r17.p to i64
  %r18 = call i64 @nova_rt_str_concat(i64 %r16, i64 %r17)
  %r19 = load i64, ptr %slot.non_nl, align 8
  %r20 = call i64 @nova_rt_len_any(i64 %r19)
  %r21 = call i64 @nova_rt_int_to_str(i64 %r20)
  %r22 = call i64 @nova_rt_str_concat(i64 %r18, i64 %r21)
  %r23 = call i64 @nova_rt_print_any(i64 %r22)
  %r24 = load i64, ptr %slot.non_nl, align 8
  %r25 = call i64 @nova_rt_len_any(i64 %r24)
  %r26 = add i64 6, 0
  %r27.cmp = icmp eq i64 %r25, %r26
  %r27 = zext i1 %r27.cmp to i64
  %br_then66 = icmp ne i64 %r27, 0
  br i1 %br_then66, label %then66, label %else67
then66:
  %r28.p = getelementptr inbounds [5 x i8], ptr @.str.18, i64 0, i64 0
  %r28 = ptrtoint ptr %r28.p to i64
  %r29 = call i64 @nova_rt_print_any(i64 %r28)
  br label %endif68
else67:
  %r30.p = getelementptr inbounds [23 x i8], ptr @.str.19, i64 0, i64 0
  %r30 = ptrtoint ptr %r30.p to i64
  %r31 = load i64, ptr %slot.non_nl, align 8
  %r32 = call i64 @nova_rt_len_any(i64 %r31)
  %r33 = call i64 @nova_rt_int_to_str(i64 %r32)
  %r34 = call i64 @nova_rt_str_concat(i64 %r30, i64 %r33)
  %r35 = call i64 @nova_rt_print_any(i64 %r34)
  br label %endif68
endif68:
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
@.str.16 = private unnamed_addr constant [8 x i8] c"Total: \00"
@.str.17 = private unnamed_addr constant [11 x i8] c", non-nl: \00"
@.str.18 = private unnamed_addr constant [5 x i8] c"PASS\00"
@.str.19 = private unnamed_addr constant [23 x i8] c"FAIL: expected 6, got \00"
