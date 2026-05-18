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
  %t13 = icmp ne i64 %r8, 0
  br i1 %t13, label %then4, label %else5
then4:
  ret i64 1
  br label %merge6
else5:
  br label %merge6
merge6:
  %r14 = load i64, ptr %slot.c, align 8
  %t16 = icmp sge i64 %r14, 97
  %r15 = zext i1 %t16 to i64
  %r17 = load i64, ptr %slot.c, align 8
  %t19 = icmp sle i64 %r17, 122
  %r18 = zext i1 %t19 to i64
  br label %and_entry7
and_entry7:
  %t21 = icmp ne i64 %r15, 0
  br i1 %t21, label %and_rhs8, label %and_end9
and_rhs8:
  %r22 = load i64, ptr %slot.c, align 8
  %t24 = icmp sle i64 %r22, 122
  %r23 = zext i1 %t24 to i64
  br label %and_done10
and_done10:
  br label %and_end9
and_end9:
  %r20 = phi i64 [0, %and_entry7], [%r23, %and_done10]
  %t25 = icmp ne i64 %r20, 0
  br i1 %t25, label %then11, label %else12
then11:
  ret i64 1
  br label %merge13
else12:
  br label %merge13
merge13:
  %r26 = load i64, ptr %slot.ch, align 8
  %r27 = getelementptr inbounds [2 x i8], ptr @.str.0, i64 0, i64 0
  %r28 = ptrtoint ptr %r27 to i64
  %t30 = call i64 @nova_rt_eq(i64 %r26, i64 %r28)
  %r29 = and i64 %t30, 1
  %t31 = icmp ne i64 %t30, 0
  br i1 %t31, label %then14, label %else15
then14:
  ret i64 1
  br label %merge16
else15:
  br label %merge16
merge16:
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
  %t4 = icmp sge i64 %r2, 48
  %r3 = zext i1 %t4 to i64
  %r5 = load i64, ptr %slot.c, align 8
  %t7 = icmp sle i64 %r5, 57
  %r6 = zext i1 %t7 to i64
  br label %and_entry17
and_entry17:
  %t9 = icmp ne i64 %r3, 0
  br i1 %t9, label %and_rhs18, label %and_end19
and_rhs18:
  %r10 = load i64, ptr %slot.c, align 8
  %t12 = icmp sle i64 %r10, 57
  %r11 = zext i1 %t12 to i64
  br label %and_done20
and_done20:
  br label %and_end19
and_end19:
  %r8 = phi i64 [0, %and_entry17], [%r11, %and_done20]
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
  br label %while_hdr21
while_hdr21:
  %r1 = load i64, ptr %slot.i, align 8
  %r2 = load i64, ptr %slot.source, align 8
  %r3 = call i64 @nova_rt_len_any(i64 %r2)
  %t5 = icmp slt i64 %r1, %r3
  %r4 = zext i1 %t5 to i64
  %t6 = icmp ne i64 %r4, 0
  br i1 %t6, label %while_body22, label %while_exit23
while_body22:
  %r7 = load i64, ptr %slot.source, align 8
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
  br label %or_entry24
or_entry24:
  %t21 = icmp ne i64 %t14, 0
  br i1 %t21, label %or_end26, label %or_rhs25
or_rhs25:
  %r22 = load i64, ptr %slot.ch, align 8
  %r23 = getelementptr inbounds [2 x i8], ptr @.str.2, i64 0, i64 0
  %r24 = ptrtoint ptr %r23 to i64
  %t26 = call i64 @nova_rt_eq(i64 %r22, i64 %r24)
  %r25 = and i64 %t26, 1
  br label %or_done27
or_done27:
  br label %or_end26
or_end26:
  %r20 = phi i64 [%t14, %or_entry24], [%t26, %or_done27]
  %t27 = icmp ne i64 %r20, 0
  br i1 %t27, label %then28, label %else29
then28:
  %r28 = load i64, ptr %slot.i, align 8
  %r29 = call i64 @nova_rt_add(i64 %r28, i64 1)
  store i64 %r29, ptr %slot.i, align 8
  br label %merge30
else29:
  %r30 = load i64, ptr %slot.ch, align 8
  %r31 = call i64 @is_alpha(i64 %r30)
  %t32 = icmp ne i64 %r31, 0
  br i1 %t32, label %then31, label %else32
then31:
  %r33 = load i64, ptr %slot.i, align 8
  store i64 %r33, ptr %slot.start, align 8
  br label %while_hdr34
while_hdr34:
  %r34 = load i64, ptr %slot.i, align 8
  %r35 = load i64, ptr %slot.source, align 8
  %r36 = call i64 @nova_rt_len_any(i64 %r35)
  %t38 = icmp slt i64 %r34, %r36
  %r37 = zext i1 %t38 to i64
  %r39 = load i64, ptr %slot.source, align 8
  %r40 = load i64, ptr %slot.i, align 8
  %r41 = call i64 @nova_rt_index_get(i64 %r39, i64 %r40)
  %r42 = call i64 @is_alpha(i64 %r41)
  br label %and_entry37
and_entry37:
  %t44 = icmp ne i64 %r37, 0
  br i1 %t44, label %and_rhs38, label %and_end39
and_rhs38:
  %r45 = load i64, ptr %slot.source, align 8
  %r46 = load i64, ptr %slot.i, align 8
  %r47 = call i64 @nova_rt_index_get(i64 %r45, i64 %r46)
  %r48 = call i64 @is_alpha(i64 %r47)
  br label %and_done40
and_done40:
  br label %and_end39
and_end39:
  %r43 = phi i64 [0, %and_entry37], [%r48, %and_done40]
  %t49 = icmp ne i64 %r43, 0
  br i1 %t49, label %while_body35, label %while_exit36
while_body35:
  %r50 = load i64, ptr %slot.i, align 8
  %r51 = call i64 @nova_rt_add(i64 %r50, i64 1)
  store i64 %r51, ptr %slot.i, align 8
  br label %while_hdr34
while_exit36:
  %r52 = getelementptr inbounds [1 x i8], ptr @.str.3, i64 0, i64 0
  %r53 = ptrtoint ptr %r52 to i64
  store i64 %r53, ptr %slot.word, align 8
  %r54 = load i64, ptr %slot.start, align 8
  store i64 %r54, ptr %slot.j, align 8
  br label %while_hdr41
while_hdr41:
  %r55 = load i64, ptr %slot.j, align 8
  %r56 = load i64, ptr %slot.i, align 8
  %t58 = icmp slt i64 %r55, %r56
  %r57 = zext i1 %t58 to i64
  %t59 = icmp ne i64 %r57, 0
  br i1 %t59, label %while_body42, label %while_exit43
while_body42:
  %r60 = load i64, ptr %slot.word, align 8
  %r61 = load i64, ptr %slot.source, align 8
  %r62 = load i64, ptr %slot.j, align 8
  %r63 = call i64 @nova_rt_index_get(i64 %r61, i64 %r62)
  %r64 = call i64 @nova_rt_add(i64 %r60, i64 %r63)
  store i64 %r64, ptr %slot.word, align 8
  %r65 = load i64, ptr %slot.j, align 8
  %r66 = call i64 @nova_rt_add(i64 %r65, i64 1)
  store i64 %r66, ptr %slot.j, align 8
  br label %while_hdr41
while_exit43:
  %r67 = load i64, ptr %slot.tokens, align 8
  %r68 = call ptr @nova_rt_struct_alloc(i64 16)
  %r69 = getelementptr inbounds [6 x i8], ptr @.str.4, i64 0, i64 0
  %r70 = ptrtoint ptr %r69 to i64
  %t71 = getelementptr i64, ptr %r68, i64 0
  store i64 %r70, ptr %t71, align 8
  %r72 = load i64, ptr %slot.word, align 8
  %t73 = getelementptr i64, ptr %r68, i64 1
  store i64 %r72, ptr %t73, align 8
  %r74 = ptrtoint ptr %r68 to i64
  %r75 = call i64 @nova_rt_list_append(i64 %r67, i64 %r74)
  br label %merge33
else32:
  %r76 = load i64, ptr %slot.ch, align 8
  %r77 = call i64 @is_digit(i64 %r76)
  %t78 = icmp ne i64 %r77, 0
  br i1 %t78, label %then44, label %else45
then44:
  %r79 = load i64, ptr %slot.i, align 8
  store i64 %r79, ptr %slot.start, align 8
  br label %while_hdr47
while_hdr47:
  %r80 = load i64, ptr %slot.i, align 8
  %r81 = load i64, ptr %slot.source, align 8
  %r82 = call i64 @nova_rt_len_any(i64 %r81)
  %t84 = icmp slt i64 %r80, %r82
  %r83 = zext i1 %t84 to i64
  %r85 = load i64, ptr %slot.source, align 8
  %r86 = load i64, ptr %slot.i, align 8
  %r87 = call i64 @nova_rt_index_get(i64 %r85, i64 %r86)
  %r88 = call i64 @is_digit(i64 %r87)
  br label %and_entry50
and_entry50:
  %t90 = icmp ne i64 %r83, 0
  br i1 %t90, label %and_rhs51, label %and_end52
and_rhs51:
  %r91 = load i64, ptr %slot.source, align 8
  %r92 = load i64, ptr %slot.i, align 8
  %r93 = call i64 @nova_rt_index_get(i64 %r91, i64 %r92)
  %r94 = call i64 @is_digit(i64 %r93)
  br label %and_done53
and_done53:
  br label %and_end52
and_end52:
  %r89 = phi i64 [0, %and_entry50], [%r94, %and_done53]
  %t95 = icmp ne i64 %r89, 0
  br i1 %t95, label %while_body48, label %while_exit49
while_body48:
  %r96 = load i64, ptr %slot.i, align 8
  %r97 = call i64 @nova_rt_add(i64 %r96, i64 1)
  store i64 %r97, ptr %slot.i, align 8
  br label %while_hdr47
while_exit49:
  %r98 = getelementptr inbounds [1 x i8], ptr @.str.3, i64 0, i64 0
  %r99 = ptrtoint ptr %r98 to i64
  store i64 %r99, ptr %slot.num, align 8
  %r100 = load i64, ptr %slot.start, align 8
  store i64 %r100, ptr %slot.j, align 8
  br label %while_hdr54
while_hdr54:
  %r101 = load i64, ptr %slot.j, align 8
  %r102 = load i64, ptr %slot.i, align 8
  %t104 = icmp slt i64 %r101, %r102
  %r103 = zext i1 %t104 to i64
  %t105 = icmp ne i64 %r103, 0
  br i1 %t105, label %while_body55, label %while_exit56
while_body55:
  %r106 = load i64, ptr %slot.num, align 8
  %r107 = load i64, ptr %slot.source, align 8
  %r108 = load i64, ptr %slot.j, align 8
  %r109 = call i64 @nova_rt_index_get(i64 %r107, i64 %r108)
  %r110 = call i64 @nova_rt_add(i64 %r106, i64 %r109)
  store i64 %r110, ptr %slot.num, align 8
  %r111 = load i64, ptr %slot.j, align 8
  %r112 = call i64 @nova_rt_add(i64 %r111, i64 1)
  store i64 %r112, ptr %slot.j, align 8
  br label %while_hdr54
while_exit56:
  %r113 = load i64, ptr %slot.tokens, align 8
  %r114 = call ptr @nova_rt_struct_alloc(i64 16)
  %r115 = getelementptr inbounds [4 x i8], ptr @.str.5, i64 0, i64 0
  %r116 = ptrtoint ptr %r115 to i64
  %t117 = getelementptr i64, ptr %r114, i64 0
  store i64 %r116, ptr %t117, align 8
  %r118 = load i64, ptr %slot.num, align 8
  %t119 = getelementptr i64, ptr %r114, i64 1
  store i64 %r118, ptr %t119, align 8
  %r120 = ptrtoint ptr %r114 to i64
  %r121 = call i64 @nova_rt_list_append(i64 %r113, i64 %r120)
  br label %merge46
else45:
  %r122 = load i64, ptr %slot.ch, align 8
  %r123 = getelementptr inbounds [2 x i8], ptr @.str.6, i64 0, i64 0
  %r124 = ptrtoint ptr %r123 to i64
  %t126 = call i64 @nova_rt_eq(i64 %r122, i64 %r124)
  %r125 = and i64 %t126, 1
  %t127 = icmp ne i64 %t126, 0
  br i1 %t127, label %then57, label %else58
then57:
  %r128 = load i64, ptr %slot.tokens, align 8
  %r129 = call ptr @nova_rt_struct_alloc(i64 16)
  %r130 = getelementptr inbounds [7 x i8], ptr @.str.7, i64 0, i64 0
  %r131 = ptrtoint ptr %r130 to i64
  %t132 = getelementptr i64, ptr %r129, i64 0
  store i64 %r131, ptr %t132, align 8
  %r133 = getelementptr inbounds [2 x i8], ptr @.str.6, i64 0, i64 0
  %r134 = ptrtoint ptr %r133 to i64
  %t135 = getelementptr i64, ptr %r129, i64 1
  store i64 %r134, ptr %t135, align 8
  %r136 = ptrtoint ptr %r129 to i64
  %r137 = call i64 @nova_rt_list_append(i64 %r128, i64 %r136)
  %r138 = load i64, ptr %slot.i, align 8
  %r139 = call i64 @nova_rt_add(i64 %r138, i64 1)
  store i64 %r139, ptr %slot.i, align 8
  br label %merge59
else58:
  %r140 = load i64, ptr %slot.ch, align 8
  %r141 = getelementptr inbounds [2 x i8], ptr @.str.8, i64 0, i64 0
  %r142 = ptrtoint ptr %r141 to i64
  %t144 = call i64 @nova_rt_eq(i64 %r140, i64 %r142)
  %r143 = and i64 %t144, 1
  %t145 = icmp ne i64 %t144, 0
  br i1 %t145, label %then60, label %else61
then60:
  %r146 = load i64, ptr %slot.tokens, align 8
  %r147 = call ptr @nova_rt_struct_alloc(i64 16)
  %r148 = getelementptr inbounds [3 x i8], ptr @.str.9, i64 0, i64 0
  %r149 = ptrtoint ptr %r148 to i64
  %t150 = getelementptr i64, ptr %r147, i64 0
  store i64 %r149, ptr %t150, align 8
  %r151 = getelementptr inbounds [2 x i8], ptr @.str.8, i64 0, i64 0
  %r152 = ptrtoint ptr %r151 to i64
  %t153 = getelementptr i64, ptr %r147, i64 1
  store i64 %r152, ptr %t153, align 8
  %r154 = ptrtoint ptr %r147 to i64
  %r155 = call i64 @nova_rt_list_append(i64 %r146, i64 %r154)
  %r156 = load i64, ptr %slot.i, align 8
  %r157 = call i64 @nova_rt_add(i64 %r156, i64 1)
  store i64 %r157, ptr %slot.i, align 8
  br label %merge62
else61:
  %r158 = load i64, ptr %slot.ch, align 8
  %r159 = getelementptr inbounds [2 x i8], ptr @.str.10, i64 0, i64 0
  %r160 = ptrtoint ptr %r159 to i64
  %t162 = call i64 @nova_rt_eq(i64 %r158, i64 %r160)
  %r161 = and i64 %t162, 1
  %t163 = icmp ne i64 %t162, 0
  br i1 %t163, label %then63, label %else64
then63:
  %r164 = load i64, ptr %slot.tokens, align 8
  %r165 = call ptr @nova_rt_struct_alloc(i64 16)
  %r166 = getelementptr inbounds [7 x i8], ptr @.str.11, i64 0, i64 0
  %r167 = ptrtoint ptr %r166 to i64
  %t168 = getelementptr i64, ptr %r165, i64 0
  store i64 %r167, ptr %t168, align 8
  %r169 = getelementptr inbounds [2 x i8], ptr @.str.10, i64 0, i64 0
  %r170 = ptrtoint ptr %r169 to i64
  %t171 = getelementptr i64, ptr %r165, i64 1
  store i64 %r170, ptr %t171, align 8
  %r172 = ptrtoint ptr %r165 to i64
  %r173 = call i64 @nova_rt_list_append(i64 %r164, i64 %r172)
  %r174 = load i64, ptr %slot.i, align 8
  %r175 = call i64 @nova_rt_add(i64 %r174, i64 1)
  store i64 %r175, ptr %slot.i, align 8
  br label %merge65
else64:
  %r176 = load i64, ptr %slot.ch, align 8
  %r177 = getelementptr inbounds [2 x i8], ptr @.str.12, i64 0, i64 0
  %r178 = ptrtoint ptr %r177 to i64
  %t180 = call i64 @nova_rt_eq(i64 %r176, i64 %r178)
  %r179 = and i64 %t180, 1
  %t181 = icmp ne i64 %t180, 0
  br i1 %t181, label %then66, label %else67
then66:
  %r182 = load i64, ptr %slot.tokens, align 8
  %r183 = call ptr @nova_rt_struct_alloc(i64 16)
  %r184 = getelementptr inbounds [7 x i8], ptr @.str.13, i64 0, i64 0
  %r185 = ptrtoint ptr %r184 to i64
  %t186 = getelementptr i64, ptr %r183, i64 0
  store i64 %r185, ptr %t186, align 8
  %r187 = getelementptr inbounds [2 x i8], ptr @.str.12, i64 0, i64 0
  %r188 = ptrtoint ptr %r187 to i64
  %t189 = getelementptr i64, ptr %r183, i64 1
  store i64 %r188, ptr %t189, align 8
  %r190 = ptrtoint ptr %r183 to i64
  %r191 = call i64 @nova_rt_list_append(i64 %r182, i64 %r190)
  %r192 = load i64, ptr %slot.i, align 8
  %r193 = call i64 @nova_rt_add(i64 %r192, i64 1)
  store i64 %r193, ptr %slot.i, align 8
  br label %merge68
else67:
  %r194 = load i64, ptr %slot.i, align 8
  %r195 = call i64 @nova_rt_add(i64 %r194, i64 1)
  store i64 %r195, ptr %slot.i, align 8
  br label %merge68
merge68:
  br label %merge65
merge65:
  br label %merge62
merge62:
  br label %merge59
merge59:
  br label %merge46
merge46:
  br label %merge33
merge33:
  br label %merge30
merge30:
  br label %while_hdr21
while_exit23:
  %r196 = load i64, ptr %slot.tokens, align 8
  ret i64 %r196
}

define i64 @nova_main() nounwind {
entry:
  %slot.src = alloca i64, align 8
  store i64 0, ptr %slot.src, align 8
  %slot.toks = alloca i64, align 8
  store i64 0, ptr %slot.toks, align 8
  %slot.t = alloca i64, align 8
  store i64 0, ptr %slot.t, align 8
  %slot.kind = alloca i64, align 8
  store i64 0, ptr %slot.kind, align 8
  %slot.value = alloca i64, align 8
  store i64 0, ptr %slot.value, align 8
  %r0 = getelementptr inbounds [15 x i8], ptr @.str.14, i64 0, i64 0
  %r1 = ptrtoint ptr %r0 to i64
  store i64 %r1, ptr %slot.src, align 8
  %r2 = load i64, ptr %slot.src, align 8
  %r3 = call i64 @tokenize(i64 %r2)
  store i64 %r3, ptr %slot.toks, align 8
  %r4 = load i64, ptr %slot.toks, align 8
  %r5 = call i64 @nova_rt_len_any(i64 %r4)
  %r6 = call i64 @nova_rt_print_any(i64 %r5)
  %r7 = load i64, ptr %slot.toks, align 8
  %r8 = call i64 @nova_rt_len_any(i64 %r7)
  %slot.__for_idx_69 = alloca i64, align 8
  store i64 0, ptr %slot.__for_idx_69, align 8
  br label %for_hdr69
for_hdr69:
  %r9 = load i64, ptr %slot.__for_idx_69, align 8
  %t10 = icmp slt i64 %r9, %r8
  br i1 %t10, label %for_body70, label %for_exit71
for_body70:
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
  %r26 = load i64, ptr %slot.__for_idx_69, align 8
  %r25 = add i64 %r26, 1
  store i64 %r25, ptr %slot.__for_idx_69, align 8
  br label %for_hdr69
for_exit71:
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
