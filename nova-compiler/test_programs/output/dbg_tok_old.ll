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

define i64 @mini_tokenize(i64 %p0) nounwind {
entry:
  %slot.source = alloca i64, align 8
  store i64 %p0, ptr %slot.source, align 8
  %slot.tokens = alloca i64, align 8
  store i64 0, ptr %slot.tokens, align 8
  %slot.i = alloca i64, align 8
  store i64 0, ptr %slot.i, align 8
  %slot.n = alloca i64, align 8
  store i64 0, ptr %slot.n, align 8
  %slot.ch = alloca i64, align 8
  store i64 0, ptr %slot.ch, align 8
  %slot.start = alloca i64, align 8
  store i64 0, ptr %slot.start, align 8
  %slot.word = alloca i64, align 8
  store i64 0, ptr %slot.word, align 8
  %r0 = call i64 @nova_rt_list_create()
  store i64 %r0, ptr %slot.tokens, align 8
  store i64 0, ptr %slot.i, align 8
  %r1 = load i64, ptr %slot.source, align 8
  %r2 = call i64 @nova_rt_len_any(i64 %r1)
  store i64 %r2, ptr %slot.n, align 8
  br label %while_hdr0
while_hdr0:
  %r3 = load i64, ptr %slot.i, align 8
  %r4 = load i64, ptr %slot.n, align 8
  %t6 = icmp slt i64 %r3, %r4
  %r5 = zext i1 %t6 to i64
  %t7 = icmp ne i64 %r5, 0
  br i1 %t7, label %while_body1, label %while_exit2
while_body1:
  %r8 = load i64, ptr %slot.source, align 8
  %r9 = load i64, ptr %slot.i, align 8
  %r10 = call i64 @nova_rt_index_get(i64 %r8, i64 %r9)
  store i64 %r10, ptr %slot.ch, align 8
  %r11 = load i64, ptr %slot.ch, align 8
  %r12 = getelementptr inbounds [2 x i8], ptr @.str.0, i64 0, i64 0
  %r13 = ptrtoint ptr %r12 to i64
  %t15 = call i64 @nova_rt_eq(i64 %r11, i64 %r13)
  %r14 = and i64 %t15, 1
  %r16 = load i64, ptr %slot.ch, align 8
  %r17 = getelementptr inbounds [2 x i8], ptr @.str.1, i64 0, i64 0
  %r18 = ptrtoint ptr %r17 to i64
  %t20 = call i64 @nova_rt_eq(i64 %r16, i64 %r18)
  %r19 = and i64 %t20, 1
  br label %or_entry3
or_entry3:
  %t22 = icmp ne i64 %t15, 0
  br i1 %t22, label %or_end5, label %or_rhs4
or_rhs4:
  %r23 = load i64, ptr %slot.ch, align 8
  %r24 = getelementptr inbounds [2 x i8], ptr @.str.1, i64 0, i64 0
  %r25 = ptrtoint ptr %r24 to i64
  %t27 = call i64 @nova_rt_eq(i64 %r23, i64 %r25)
  %r26 = and i64 %t27, 1
  br label %or_done6
or_done6:
  br label %or_end5
or_end5:
  %r21 = phi i64 [%t15, %or_entry3], [%t27, %or_done6]
  %t28 = icmp ne i64 %r21, 0
  br i1 %t28, label %then7, label %else8
then7:
  %r29 = load i64, ptr %slot.i, align 8
  %r30 = call i64 @nova_rt_add(i64 %r29, i64 1)
  store i64 %r30, ptr %slot.i, align 8
  br label %merge9
else8:
  %r31 = load i64, ptr %slot.ch, align 8
  %r32 = getelementptr inbounds [2 x i8], ptr @.str.2, i64 0, i64 0
  %r33 = ptrtoint ptr %r32 to i64
  %t35 = call i64 @nova_rt_eq(i64 %r31, i64 %r33)
  %r34 = and i64 %t35, 1
  %t36 = icmp ne i64 %t35, 0
  br i1 %t36, label %then10, label %else11
then10:
  %r37 = load i64, ptr %slot.tokens, align 8
  %r38 = getelementptr inbounds [2 x i8], ptr @.str.2, i64 0, i64 0
  %r39 = ptrtoint ptr %r38 to i64
  %r40 = call i64 @nova_rt_list_append(i64 %r37, i64 %r39)
  %r41 = load i64, ptr %slot.i, align 8
  %r42 = call i64 @nova_rt_add(i64 %r41, i64 1)
  store i64 %r42, ptr %slot.i, align 8
  br label %merge12
else11:
  %r43 = load i64, ptr %slot.ch, align 8
  %r44 = getelementptr inbounds [2 x i8], ptr @.str.3, i64 0, i64 0
  %r45 = ptrtoint ptr %r44 to i64
  %t47 = call i64 @nova_rt_eq(i64 %r43, i64 %r45)
  %r46 = and i64 %t47, 1
  %t48 = icmp ne i64 %t47, 0
  br i1 %t48, label %then13, label %else14
then13:
  %r49 = load i64, ptr %slot.tokens, align 8
  %r50 = getelementptr inbounds [2 x i8], ptr @.str.3, i64 0, i64 0
  %r51 = ptrtoint ptr %r50 to i64
  %r52 = call i64 @nova_rt_list_append(i64 %r49, i64 %r51)
  %r53 = load i64, ptr %slot.i, align 8
  %r54 = call i64 @nova_rt_add(i64 %r53, i64 1)
  store i64 %r54, ptr %slot.i, align 8
  br label %merge15
else14:
  %r55 = load i64, ptr %slot.i, align 8
  store i64 %r55, ptr %slot.start, align 8
  %r56 = getelementptr inbounds [1 x i8], ptr @.str.4, i64 0, i64 0
  %r57 = ptrtoint ptr %r56 to i64
  store i64 %r57, ptr %slot.word, align 8
  br label %while_hdr16
while_hdr16:
  %r58 = load i64, ptr %slot.i, align 8
  %r59 = load i64, ptr %slot.n, align 8
  %t61 = icmp slt i64 %r58, %r59
  %r60 = zext i1 %t61 to i64
  %r62 = load i64, ptr %slot.source, align 8
  %r63 = load i64, ptr %slot.i, align 8
  %r64 = call i64 @nova_rt_index_get(i64 %r62, i64 %r63)
  %r65 = getelementptr inbounds [2 x i8], ptr @.str.0, i64 0, i64 0
  %r66 = ptrtoint ptr %r65 to i64
  %t68 = call i64 @nova_rt_neq(i64 %r64, i64 %r66)
  br label %and_entry19
and_entry19:
  %t70 = icmp ne i64 %r60, 0
  br i1 %t70, label %and_rhs20, label %and_end21
and_rhs20:
  %r71 = load i64, ptr %slot.source, align 8
  %r72 = load i64, ptr %slot.i, align 8
  %r73 = call i64 @nova_rt_index_get(i64 %r71, i64 %r72)
  %r74 = getelementptr inbounds [2 x i8], ptr @.str.0, i64 0, i64 0
  %r75 = ptrtoint ptr %r74 to i64
  %t77 = call i64 @nova_rt_neq(i64 %r73, i64 %r75)
  br label %and_done22
and_done22:
  br label %and_end21
and_end21:
  %r69 = phi i64 [0, %and_entry19], [%t77, %and_done22]
  %r78 = load i64, ptr %slot.source, align 8
  %r79 = load i64, ptr %slot.i, align 8
  %r80 = call i64 @nova_rt_index_get(i64 %r78, i64 %r79)
  %r81 = getelementptr inbounds [2 x i8], ptr @.str.1, i64 0, i64 0
  %r82 = ptrtoint ptr %r81 to i64
  %t84 = call i64 @nova_rt_neq(i64 %r80, i64 %r82)
  br label %and_entry23
and_entry23:
  %t86 = icmp ne i64 %r69, 0
  br i1 %t86, label %and_rhs24, label %and_end25
and_rhs24:
  %r87 = load i64, ptr %slot.source, align 8
  %r88 = load i64, ptr %slot.i, align 8
  %r89 = call i64 @nova_rt_index_get(i64 %r87, i64 %r88)
  %r90 = getelementptr inbounds [2 x i8], ptr @.str.1, i64 0, i64 0
  %r91 = ptrtoint ptr %r90 to i64
  %t93 = call i64 @nova_rt_neq(i64 %r89, i64 %r91)
  br label %and_done26
and_done26:
  br label %and_end25
and_end25:
  %r85 = phi i64 [0, %and_entry23], [%t93, %and_done26]
  %r94 = load i64, ptr %slot.source, align 8
  %r95 = load i64, ptr %slot.i, align 8
  %r96 = call i64 @nova_rt_index_get(i64 %r94, i64 %r95)
  %r97 = getelementptr inbounds [2 x i8], ptr @.str.2, i64 0, i64 0
  %r98 = ptrtoint ptr %r97 to i64
  %t100 = call i64 @nova_rt_neq(i64 %r96, i64 %r98)
  br label %and_entry27
and_entry27:
  %t102 = icmp ne i64 %r85, 0
  br i1 %t102, label %and_rhs28, label %and_end29
and_rhs28:
  %r103 = load i64, ptr %slot.source, align 8
  %r104 = load i64, ptr %slot.i, align 8
  %r105 = call i64 @nova_rt_index_get(i64 %r103, i64 %r104)
  %r106 = getelementptr inbounds [2 x i8], ptr @.str.2, i64 0, i64 0
  %r107 = ptrtoint ptr %r106 to i64
  %t109 = call i64 @nova_rt_neq(i64 %r105, i64 %r107)
  br label %and_done30
and_done30:
  br label %and_end29
and_end29:
  %r101 = phi i64 [0, %and_entry27], [%t109, %and_done30]
  %r110 = load i64, ptr %slot.source, align 8
  %r111 = load i64, ptr %slot.i, align 8
  %r112 = call i64 @nova_rt_index_get(i64 %r110, i64 %r111)
  %r113 = getelementptr inbounds [2 x i8], ptr @.str.3, i64 0, i64 0
  %r114 = ptrtoint ptr %r113 to i64
  %t116 = call i64 @nova_rt_neq(i64 %r112, i64 %r114)
  br label %and_entry31
and_entry31:
  %t118 = icmp ne i64 %r101, 0
  br i1 %t118, label %and_rhs32, label %and_end33
and_rhs32:
  %r119 = load i64, ptr %slot.source, align 8
  %r120 = load i64, ptr %slot.i, align 8
  %r121 = call i64 @nova_rt_index_get(i64 %r119, i64 %r120)
  %r122 = getelementptr inbounds [2 x i8], ptr @.str.3, i64 0, i64 0
  %r123 = ptrtoint ptr %r122 to i64
  %t125 = call i64 @nova_rt_neq(i64 %r121, i64 %r123)
  br label %and_done34
and_done34:
  br label %and_end33
and_end33:
  %r117 = phi i64 [0, %and_entry31], [%t125, %and_done34]
  %t126 = icmp ne i64 %r117, 0
  br i1 %t126, label %while_body17, label %while_exit18
while_body17:
  %r127 = load i64, ptr %slot.word, align 8
  %r128 = load i64, ptr %slot.source, align 8
  %r129 = load i64, ptr %slot.i, align 8
  %r130 = call i64 @nova_rt_index_get(i64 %r128, i64 %r129)
  %r131 = call i64 @nova_rt_add(i64 %r127, i64 %r130)
  store i64 %r131, ptr %slot.word, align 8
  %r132 = load i64, ptr %slot.i, align 8
  %r133 = call i64 @nova_rt_add(i64 %r132, i64 1)
  store i64 %r133, ptr %slot.i, align 8
  br label %while_hdr16
while_exit18:
  %r134 = load i64, ptr %slot.tokens, align 8
  %r135 = load i64, ptr %slot.word, align 8
  %r136 = call i64 @nova_rt_list_append(i64 %r134, i64 %r135)
  br label %merge15
merge15:
  br label %merge12
merge12:
  br label %merge9
merge9:
  br label %while_hdr0
while_exit2:
  %r137 = load i64, ptr %slot.tokens, align 8
  ret i64 %r137
}

define i64 @nova_main() nounwind {
entry:
  %slot.result = alloca i64, align 8
  store i64 0, ptr %slot.result, align 8
  %slot.t = alloca i64, align 8
  store i64 0, ptr %slot.t, align 8
  %r0 = getelementptr inbounds [15 x i8], ptr @.str.5, i64 0, i64 0
  %r1 = ptrtoint ptr %r0 to i64
  %r2 = call i64 @mini_tokenize(i64 %r1)
  store i64 %r2, ptr %slot.result, align 8
  %r3 = getelementptr inbounds [14 x i8], ptr @.str.6, i64 0, i64 0
  %r4 = ptrtoint ptr %r3 to i64
  %r5 = load i64, ptr %slot.result, align 8
  %r6 = call i64 @nova_rt_len_any(i64 %r5)
  %r7 = call i64 @nova_rt_int_to_str(i64 %r6)
  %r8 = call i64 @nova_rt_add(i64 %r4, i64 %r7)
  %r9 = call i64 @nova_rt_print_any(i64 %r8)
  %r10 = load i64, ptr %slot.result, align 8
  %r11 = call i64 @nova_rt_len_any(i64 %r10)
  %slot.__for_idx_35 = alloca i64, align 8
  store i64 0, ptr %slot.__for_idx_35, align 8
  br label %for_hdr35
for_hdr35:
  %r12 = load i64, ptr %slot.__for_idx_35, align 8
  %t13 = icmp slt i64 %r12, %r11
  br i1 %t13, label %for_body36, label %for_exit37
for_body36:
  %r14 = call i64 @nova_rt_index_get(i64 %r10, i64 %r12)
  store i64 %r14, ptr %slot.t, align 8
  %r15 = getelementptr inbounds [3 x i8], ptr @.str.7, i64 0, i64 0
  %r16 = ptrtoint ptr %r15 to i64
  %r17 = load i64, ptr %slot.t, align 8
  %r18 = call i64 @nova_rt_add(i64 %r16, i64 %r17)
  %r19 = call i64 @nova_rt_print_any(i64 %r18)
  %r21 = load i64, ptr %slot.__for_idx_35, align 8
  %r20 = add i64 %r21, 1
  store i64 %r20, ptr %slot.__for_idx_35, align 8
  br label %for_hdr35
for_exit37:
  %r22 = load i64, ptr %slot.result, align 8
  %r23 = call i64 @nova_rt_len_any(i64 %r22)
  %t25 = call i64 @nova_rt_eq(i64 %r23, i64 6)
  %r24 = and i64 %t25, 1
  %t26 = icmp ne i64 %t25, 0
  br i1 %t26, label %then38, label %else39
then38:
  %r27 = getelementptr inbounds [5 x i8], ptr @.str.8, i64 0, i64 0
  %r28 = ptrtoint ptr %r27 to i64
  %r29 = call i64 @nova_rt_print_any(i64 %r28)
  br label %merge40
else39:
  %r30 = getelementptr inbounds [24 x i8], ptr @.str.9, i64 0, i64 0
  %r31 = ptrtoint ptr %r30 to i64
  %r32 = call i64 @nova_rt_print_any(i64 %r31)
  br label %merge40
merge40:
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
@.str.0 = private unnamed_addr constant [2 x i8] c" \00"
@.str.1 = private unnamed_addr constant [2 x i8] c"\0A\00"
@.str.2 = private unnamed_addr constant [2 x i8] c"+\00"
@.str.3 = private unnamed_addr constant [2 x i8] c"=\00"
@.str.4 = private unnamed_addr constant [1 x i8] c"\00"
@.str.5 = private unnamed_addr constant [15 x i8] c"let x = 42 + 3\00"
@.str.6 = private unnamed_addr constant [14 x i8] c"Token count: \00"
@.str.7 = private unnamed_addr constant [3 x i8] c"  \00"
@.str.8 = private unnamed_addr constant [5 x i8] c"PASS\00"
@.str.9 = private unnamed_addr constant [24 x i8] c"FAIL: expected 6 tokens\00"
