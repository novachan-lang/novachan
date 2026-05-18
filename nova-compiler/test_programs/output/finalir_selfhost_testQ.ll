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
  ret i64 %r20
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
  %r1 = add i64 0, 0
  store i64 %r1, ptr %slot.i, align 8
  br label %while_hdr0
while_hdr0:
  %r2 = load i64, ptr %slot.i, align 8
  %r3 = load i64, ptr %slot.src, align 8
  %r4 = call i64 @nova_rt_len_any(i64 %r3)
  %r5.cmp = icmp slt i64 %r2, %r4
  %r5 = zext i1 %r5.cmp to i64
  %br_while_body1 = icmp ne i64 %r5, 0
  br i1 %br_while_body1, label %while_body1, label %while_exit2
while_body1:
  %r6 = load i64, ptr %slot.src, align 8
  %r7 = load i64, ptr %slot.i, align 8
  %r8 = call i64 @nova_rt_index_get(i64 %r6, i64 %r7)
  store i64 %r8, ptr %slot.ch, align 8
  %r9 = load i64, ptr %slot.ch, align 8
  %r10.p = getelementptr inbounds [2 x i8], ptr @.str.1, i64 0, i64 0
  %r10 = ptrtoint ptr %r10.p to i64
  %r11 = call i64 @nova_rt_eq(i64 %r9, i64 %r10)
  %r12 = load i64, ptr %slot.ch, align 8
  %r13.p = getelementptr inbounds [2 x i8], ptr @.str.2, i64 0, i64 0
  %r13 = ptrtoint ptr %r13.p to i64
  %r14 = call i64 @nova_rt_eq(i64 %r12, i64 %r13)
  %r15.cmp = icmp ne i64 %r11, 0
  %r15.cmp2 = icmp ne i64 %r14, 0
  %r15.or = or i1 %r15.cmp, %r15.cmp2
  %r15 = zext i1 %r15.or to i64
  %br_then3 = icmp ne i64 %r15, 0
  br i1 %br_then3, label %then3, label %else4
then3:
  %r16 = load i64, ptr %slot.i, align 8
  %r17 = add i64 1, 0
  %r18 = add i64 %r16, %r17
  store i64 %r18, ptr %slot.i, align 8
  br label %endif5
else4:
  %r19 = load i64, ptr %slot.ch, align 8
  %r20.p = getelementptr inbounds [2 x i8], ptr @.str.3, i64 0, i64 0
  %r20 = ptrtoint ptr %r20.p to i64
  %r21 = call i64 @nova_rt_eq(i64 %r19, i64 %r20)
  %br_then6 = icmp ne i64 %r21, 0
  br i1 %br_then6, label %then6, label %else7
then6:
  %r22 = load i64, ptr %slot.tokens, align 8
  %r23.p = getelementptr inbounds [3 x i8], ptr @.str.4, i64 0, i64 0
  %r23 = ptrtoint ptr %r23.p to i64
  %r24.p = getelementptr inbounds [3 x i8], ptr @.str.5, i64 0, i64 0
  %r24 = ptrtoint ptr %r24.p to i64
  %r25.ptr = call ptr @nova_rt_struct_alloc(i64 16)
  %r25.f0 = getelementptr i64, ptr %r25.ptr, i64 0
  store i64 %r23, ptr %r25.f0, align 8
  %r25.f1 = getelementptr i64, ptr %r25.ptr, i64 1
  store i64 %r24, ptr %r25.f1, align 8
  %r25 = ptrtoint ptr %r25.ptr to i64
  %r26 = call i64 @nova_rt_list_append(i64 %r22, i64 %r25)
  %r27 = load i64, ptr %slot.i, align 8
  %r28 = add i64 1, 0
  %r29 = add i64 %r27, %r28
  store i64 %r29, ptr %slot.i, align 8
  br label %endif8
else7:
  %r30 = load i64, ptr %slot.ch, align 8
  %r31 = call i64 @is_alpha_char(i64 %r30)
  %br_then9 = icmp ne i64 %r31, 0
  br i1 %br_then9, label %then9, label %else10
then9:
  %r32 = load i64, ptr %slot.i, align 8
  store i64 %r32, ptr %slot.start, align 8
  br label %while_hdr12
while_hdr12:
  %r33 = load i64, ptr %slot.i, align 8
  %r34 = load i64, ptr %slot.src, align 8
  %r35 = call i64 @nova_rt_len_any(i64 %r34)
  %r36.cmp = icmp slt i64 %r33, %r35
  %r36 = zext i1 %r36.cmp to i64
  %r37 = load i64, ptr %slot.src, align 8
  %r38 = load i64, ptr %slot.i, align 8
  %r39 = call i64 @nova_rt_index_get(i64 %r37, i64 %r38)
  %r40 = call i64 @is_alpha_char(i64 %r39)
  %r41 = load i64, ptr %slot.src, align 8
  %r42 = load i64, ptr %slot.i, align 8
  %r43 = call i64 @nova_rt_index_get(i64 %r41, i64 %r42)
  %r44 = call i64 @is_digit_char(i64 %r43)
  %r45.cmp = icmp ne i64 %r40, 0
  %r45.cmp2 = icmp ne i64 %r44, 0
  %r45.or = or i1 %r45.cmp, %r45.cmp2
  %r45 = zext i1 %r45.or to i64
  %r46.cmp = icmp ne i64 %r36, 0
  %r46.cmp2 = icmp ne i64 %r45, 0
  %r46.and = and i1 %r46.cmp, %r46.cmp2
  %r46 = zext i1 %r46.and to i64
  %br_while_body13 = icmp ne i64 %r46, 0
  br i1 %br_while_body13, label %while_body13, label %while_exit14
while_body13:
  %r47 = load i64, ptr %slot.i, align 8
  %r48 = add i64 1, 0
  %r49 = add i64 %r47, %r48
  store i64 %r49, ptr %slot.i, align 8
  br label %while_hdr12
while_exit14:
  %r50.p = getelementptr inbounds [1 x i8], ptr @.str.6, i64 0, i64 0
  %r50 = ptrtoint ptr %r50.p to i64
  store i64 %r50, ptr %slot.word, align 8
  %r51 = load i64, ptr %slot.start, align 8
  store i64 %r51, ptr %slot.j, align 8
  br label %while_hdr15
while_hdr15:
  %r52 = load i64, ptr %slot.j, align 8
  %r53 = load i64, ptr %slot.i, align 8
  %r54.cmp = icmp slt i64 %r52, %r53
  %r54 = zext i1 %r54.cmp to i64
  %br_while_body16 = icmp ne i64 %r54, 0
  br i1 %br_while_body16, label %while_body16, label %while_exit17
while_body16:
  %r55 = load i64, ptr %slot.word, align 8
  %r56 = load i64, ptr %slot.src, align 8
  %r57 = load i64, ptr %slot.j, align 8
  %r58 = call i64 @nova_rt_index_get(i64 %r56, i64 %r57)
  %r59 = call i64 @nova_rt_str_concat(i64 %r55, i64 %r58)
  store i64 %r59, ptr %slot.word, align 8
  %r60 = load i64, ptr %slot.j, align 8
  %r61 = add i64 1, 0
  %r62 = add i64 %r60, %r61
  store i64 %r62, ptr %slot.j, align 8
  br label %while_hdr15
while_exit17:
  %r63 = load i64, ptr %slot.tokens, align 8
  %r64.p = getelementptr inbounds [3 x i8], ptr @.str.7, i64 0, i64 0
  %r64 = ptrtoint ptr %r64.p to i64
  %r65 = load i64, ptr %slot.word, align 8
  %r66.ptr = call ptr @nova_rt_struct_alloc(i64 16)
  %r66.f0 = getelementptr i64, ptr %r66.ptr, i64 0
  store i64 %r64, ptr %r66.f0, align 8
  %r66.f1 = getelementptr i64, ptr %r66.ptr, i64 1
  store i64 %r65, ptr %r66.f1, align 8
  %r66 = ptrtoint ptr %r66.ptr to i64
  %r67 = call i64 @nova_rt_list_append(i64 %r63, i64 %r66)
  br label %endif11
else10:
  %r68 = load i64, ptr %slot.ch, align 8
  %r69 = call i64 @is_digit_char(i64 %r68)
  %br_then18 = icmp ne i64 %r69, 0
  br i1 %br_then18, label %then18, label %else19
then18:
  %r70 = load i64, ptr %slot.i, align 8
  store i64 %r70, ptr %slot.start, align 8
  br label %while_hdr21
while_hdr21:
  %r71 = load i64, ptr %slot.i, align 8
  %r72 = load i64, ptr %slot.src, align 8
  %r73 = call i64 @nova_rt_len_any(i64 %r72)
  %r74.cmp = icmp slt i64 %r71, %r73
  %r74 = zext i1 %r74.cmp to i64
  %r75 = load i64, ptr %slot.src, align 8
  %r76 = load i64, ptr %slot.i, align 8
  %r77 = call i64 @nova_rt_index_get(i64 %r75, i64 %r76)
  %r78 = call i64 @is_digit_char(i64 %r77)
  %r79.cmp = icmp ne i64 %r74, 0
  %r79.cmp2 = icmp ne i64 %r78, 0
  %r79.and = and i1 %r79.cmp, %r79.cmp2
  %r79 = zext i1 %r79.and to i64
  %br_while_body22 = icmp ne i64 %r79, 0
  br i1 %br_while_body22, label %while_body22, label %while_exit23
while_body22:
  %r80 = load i64, ptr %slot.i, align 8
  %r81 = add i64 1, 0
  %r82 = add i64 %r80, %r81
  store i64 %r82, ptr %slot.i, align 8
  br label %while_hdr21
while_exit23:
  %r83.p = getelementptr inbounds [1 x i8], ptr @.str.6, i64 0, i64 0
  %r83 = ptrtoint ptr %r83.p to i64
  store i64 %r83, ptr %slot.num, align 8
  %r84 = load i64, ptr %slot.start, align 8
  store i64 %r84, ptr %slot.j, align 8
  br label %while_hdr24
while_hdr24:
  %r85 = load i64, ptr %slot.j, align 8
  %r86 = load i64, ptr %slot.i, align 8
  %r87.cmp = icmp slt i64 %r85, %r86
  %r87 = zext i1 %r87.cmp to i64
  %br_while_body25 = icmp ne i64 %r87, 0
  br i1 %br_while_body25, label %while_body25, label %while_exit26
while_body25:
  %r88 = load i64, ptr %slot.num, align 8
  %r89 = load i64, ptr %slot.src, align 8
  %r90 = load i64, ptr %slot.j, align 8
  %r91 = call i64 @nova_rt_index_get(i64 %r89, i64 %r90)
  %r92 = call i64 @nova_rt_str_concat(i64 %r88, i64 %r91)
  store i64 %r92, ptr %slot.num, align 8
  %r93 = load i64, ptr %slot.j, align 8
  %r94 = add i64 1, 0
  %r95 = add i64 %r93, %r94
  store i64 %r95, ptr %slot.j, align 8
  br label %while_hdr24
while_exit26:
  %r96 = load i64, ptr %slot.tokens, align 8
  %r97.p = getelementptr inbounds [4 x i8], ptr @.str.8, i64 0, i64 0
  %r97 = ptrtoint ptr %r97.p to i64
  %r98 = load i64, ptr %slot.num, align 8
  %r99.ptr = call ptr @nova_rt_struct_alloc(i64 16)
  %r99.f0 = getelementptr i64, ptr %r99.ptr, i64 0
  store i64 %r97, ptr %r99.f0, align 8
  %r99.f1 = getelementptr i64, ptr %r99.ptr, i64 1
  store i64 %r98, ptr %r99.f1, align 8
  %r99 = ptrtoint ptr %r99.ptr to i64
  %r100 = call i64 @nova_rt_list_append(i64 %r96, i64 %r99)
  br label %endif20
else19:
  %r101 = load i64, ptr %slot.ch, align 8
  %r102.p = getelementptr inbounds [2 x i8], ptr @.str.9, i64 0, i64 0
  %r102 = ptrtoint ptr %r102.p to i64
  %r103 = call i64 @nova_rt_eq(i64 %r101, i64 %r102)
  %br_then27 = icmp ne i64 %r103, 0
  br i1 %br_then27, label %then27, label %else28
then27:
  %r104 = load i64, ptr %slot.tokens, align 8
  %r105.p = getelementptr inbounds [3 x i8], ptr @.str.10, i64 0, i64 0
  %r105 = ptrtoint ptr %r105.p to i64
  %r106.p = getelementptr inbounds [2 x i8], ptr @.str.9, i64 0, i64 0
  %r106 = ptrtoint ptr %r106.p to i64
  %r107.ptr = call ptr @nova_rt_struct_alloc(i64 16)
  %r107.f0 = getelementptr i64, ptr %r107.ptr, i64 0
  store i64 %r105, ptr %r107.f0, align 8
  %r107.f1 = getelementptr i64, ptr %r107.ptr, i64 1
  store i64 %r106, ptr %r107.f1, align 8
  %r107 = ptrtoint ptr %r107.ptr to i64
  %r108 = call i64 @nova_rt_list_append(i64 %r104, i64 %r107)
  %r109 = load i64, ptr %slot.i, align 8
  %r110 = add i64 1, 0
  %r111 = add i64 %r109, %r110
  store i64 %r111, ptr %slot.i, align 8
  br label %endif29
else28:
  %r112 = load i64, ptr %slot.ch, align 8
  %r113.p = getelementptr inbounds [2 x i8], ptr @.str.11, i64 0, i64 0
  %r113 = ptrtoint ptr %r113.p to i64
  %r114 = call i64 @nova_rt_eq(i64 %r112, i64 %r113)
  %br_then30 = icmp ne i64 %r114, 0
  br i1 %br_then30, label %then30, label %else31
then30:
  %r115 = load i64, ptr %slot.tokens, align 8
  %r116.p = getelementptr inbounds [3 x i8], ptr @.str.12, i64 0, i64 0
  %r116 = ptrtoint ptr %r116.p to i64
  %r117.p = getelementptr inbounds [2 x i8], ptr @.str.11, i64 0, i64 0
  %r117 = ptrtoint ptr %r117.p to i64
  %r118.ptr = call ptr @nova_rt_struct_alloc(i64 16)
  %r118.f0 = getelementptr i64, ptr %r118.ptr, i64 0
  store i64 %r116, ptr %r118.f0, align 8
  %r118.f1 = getelementptr i64, ptr %r118.ptr, i64 1
  store i64 %r117, ptr %r118.f1, align 8
  %r118 = ptrtoint ptr %r118.ptr to i64
  %r119 = call i64 @nova_rt_list_append(i64 %r115, i64 %r118)
  %r120 = load i64, ptr %slot.i, align 8
  %r121 = add i64 1, 0
  %r122 = add i64 %r120, %r121
  store i64 %r122, ptr %slot.i, align 8
  br label %endif32
else31:
  %r123 = load i64, ptr %slot.ch, align 8
  %r124.p = getelementptr inbounds [2 x i8], ptr @.str.13, i64 0, i64 0
  %r124 = ptrtoint ptr %r124.p to i64
  %r125 = call i64 @nova_rt_eq(i64 %r123, i64 %r124)
  %br_then33 = icmp ne i64 %r125, 0
  br i1 %br_then33, label %then33, label %else34
then33:
  %r126 = load i64, ptr %slot.tokens, align 8
  %r127.p = getelementptr inbounds [3 x i8], ptr @.str.14, i64 0, i64 0
  %r127 = ptrtoint ptr %r127.p to i64
  %r128.p = getelementptr inbounds [2 x i8], ptr @.str.13, i64 0, i64 0
  %r128 = ptrtoint ptr %r128.p to i64
  %r129.ptr = call ptr @nova_rt_struct_alloc(i64 16)
  %r129.f0 = getelementptr i64, ptr %r129.ptr, i64 0
  store i64 %r127, ptr %r129.f0, align 8
  %r129.f1 = getelementptr i64, ptr %r129.ptr, i64 1
  store i64 %r128, ptr %r129.f1, align 8
  %r129 = ptrtoint ptr %r129.ptr to i64
  %r130 = call i64 @nova_rt_list_append(i64 %r126, i64 %r129)
  %r131 = load i64, ptr %slot.i, align 8
  %r132 = add i64 1, 0
  %r133 = add i64 %r131, %r132
  store i64 %r133, ptr %slot.i, align 8
  br label %endif35
else34:
  %r134 = load i64, ptr %slot.tokens, align 8
  %r135.p = getelementptr inbounds [2 x i8], ptr @.str.15, i64 0, i64 0
  %r135 = ptrtoint ptr %r135.p to i64
  %r136 = load i64, ptr %slot.ch, align 8
  %r137.ptr = call ptr @nova_rt_struct_alloc(i64 16)
  %r137.f0 = getelementptr i64, ptr %r137.ptr, i64 0
  store i64 %r135, ptr %r137.f0, align 8
  %r137.f1 = getelementptr i64, ptr %r137.ptr, i64 1
  store i64 %r136, ptr %r137.f1, align 8
  %r137 = ptrtoint ptr %r137.ptr to i64
  %r138 = call i64 @nova_rt_list_append(i64 %r134, i64 %r137)
  %r139 = load i64, ptr %slot.i, align 8
  %r140 = add i64 1, 0
  %r141 = add i64 %r139, %r140
  store i64 %r141, ptr %slot.i, align 8
  br label %endif35
endif35:
  br label %endif32
endif32:
  br label %endif29
endif29:
  br label %endif20
endif20:
  br label %endif11
endif11:
  br label %endif8
endif8:
  br label %endif5
endif5:
  br label %while_hdr0
while_exit2:
  %r142 = load i64, ptr %slot.tokens, align 8
  ret i64 %r142
}

define i64 @nova_main() nounwind {
entry:
  %slot.test_src = alloca i64, align 8
  store i64 0, ptr %slot.test_src, align 8
  %slot.toks = alloca i64, align 8
  store i64 0, ptr %slot.toks, align 8
  %slot.__for_idx_36 = alloca i64, align 8
  store i64 0, ptr %slot.__for_idx_36, align 8
  %slot.t = alloca i64, align 8
  store i64 0, ptr %slot.t, align 8
  %r0.p = getelementptr inbounds [21 x i8], ptr @.str.16, i64 0, i64 0
  %r0 = ptrtoint ptr %r0.p to i64
  store i64 %r0, ptr %slot.test_src, align 8
  %r1 = load i64, ptr %slot.test_src, align 8
  %r2 = call i64 @tokenize_simple(i64 %r1)
  store i64 %r2, ptr %slot.toks, align 8
  %r3 = load i64, ptr %slot.toks, align 8
  %r4 = call i64 @nova_rt_len_any(i64 %r3)
  %r5 = call i64 @nova_rt_print_any(i64 %r4)
  %r6 = load i64, ptr %slot.toks, align 8
  %r7 = call i64 @nova_rt_len_any(i64 %r6)
  %r8 = add i64 0, 0
  store i64 %r8, ptr %slot.__for_idx_36, align 8
  br label %for_hdr36
for_hdr36:
  %r9 = load i64, ptr %slot.__for_idx_36, align 8
  %r10.cmp = icmp slt i64 %r9, %r7
  %r10 = zext i1 %r10.cmp to i64
  %br_for_body37 = icmp ne i64 %r10, 0
  br i1 %br_for_body37, label %for_body37, label %for_exit38
for_body37:
  %r11 = call i64 @nova_rt_index_get(i64 %r6, i64 %r9)
  store i64 %r11, ptr %slot.t, align 8
  %r12 = load i64, ptr %slot.__for_idx_36, align 8
  %r13 = add i64 1, 0
  %r14 = add i64 %r12, %r13
  store i64 %r14, ptr %slot.__for_idx_36, align 8
  br label %for_hdr36
for_exit38:
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
