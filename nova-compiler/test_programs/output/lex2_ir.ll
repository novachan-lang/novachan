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

define i64 @test_basics() nounwind {
entry:
  %slot.s = alloca i64, align 8
  store i64 0, ptr %slot.s, align 8
  %slot.pos = alloca i64, align 8
  store i64 0, ptr %slot.pos, align 8
  %slot.length = alloca i64, align 8
  store i64 0, ptr %slot.length, align 8
  %slot.ch = alloca i64, align 8
  store i64 0, ptr %slot.ch, align 8
  %slot.word = alloca i64, align 8
  store i64 0, ptr %slot.word, align 8
  %slot.__sc_15 = alloca i64, align 8
  store i64 0, ptr %slot.__sc_15, align 8
  %r0.p = getelementptr inbounds [11 x i8], ptr @.str.1, i64 0, i64 0
  %r0 = ptrtoint ptr %r0.p to i64
  store i64 %r0, ptr %slot.s, align 8
  %r1.p = getelementptr inbounds [6 x i8], ptr @.str.2, i64 0, i64 0
  %r1 = ptrtoint ptr %r1.p to i64
  %r2 = load i64, ptr %slot.s, align 8
  %r3 = call i64 @nova_rt_len_any(i64 %r2)
  %r4 = call i64 @nova_rt_int_to_str(i64 %r3)
  %r5 = call i64 @nova_rt_str_concat(i64 %r1, i64 %r4)
  %r6 = call i64 @nova_rt_print_any(i64 %r5)
  %r7.p = getelementptr inbounds [8 x i8], ptr @.str.3, i64 0, i64 0
  %r7 = ptrtoint ptr %r7.p to i64
  %r8 = load i64, ptr %slot.s, align 8
  %r9 = add i64 0, 0
  %r10 = call i64 @nova_rt_index_get(i64 %r8, i64 %r9)
  %r11 = call i64 @nova_rt_str_concat(i64 %r7, i64 %r10)
  %r12.p = getelementptr inbounds [2 x i8], ptr @.str.4, i64 0, i64 0
  %r12 = ptrtoint ptr %r12.p to i64
  %r13 = call i64 @nova_rt_str_concat(i64 %r11, i64 %r12)
  %r14 = call i64 @nova_rt_print_any(i64 %r13)
  %r15.p = getelementptr inbounds [8 x i8], ptr @.str.5, i64 0, i64 0
  %r15 = ptrtoint ptr %r15.p to i64
  %r16 = load i64, ptr %slot.s, align 8
  %r17 = add i64 1, 0
  %r18 = call i64 @nova_rt_index_get(i64 %r16, i64 %r17)
  %r19 = call i64 @nova_rt_str_concat(i64 %r15, i64 %r18)
  %r20.p = getelementptr inbounds [2 x i8], ptr @.str.4, i64 0, i64 0
  %r20 = ptrtoint ptr %r20.p to i64
  %r21 = call i64 @nova_rt_str_concat(i64 %r19, i64 %r20)
  %r22 = call i64 @nova_rt_print_any(i64 %r21)
  %r23.p = getelementptr inbounds [8 x i8], ptr @.str.6, i64 0, i64 0
  %r23 = ptrtoint ptr %r23.p to i64
  %r24 = load i64, ptr %slot.s, align 8
  %r25 = add i64 2, 0
  %r26 = call i64 @nova_rt_index_get(i64 %r24, i64 %r25)
  %r27 = call i64 @nova_rt_str_concat(i64 %r23, i64 %r26)
  %r28.p = getelementptr inbounds [2 x i8], ptr @.str.4, i64 0, i64 0
  %r28 = ptrtoint ptr %r28.p to i64
  %r29 = call i64 @nova_rt_str_concat(i64 %r27, i64 %r28)
  %r30 = call i64 @nova_rt_print_any(i64 %r29)
  %r31.p = getelementptr inbounds [9 x i8], ptr @.str.7, i64 0, i64 0
  %r31 = ptrtoint ptr %r31.p to i64
  %r32.p = getelementptr inbounds [2 x i8], ptr @.str.8, i64 0, i64 0
  %r32 = ptrtoint ptr %r32.p to i64
  %r33 = call i64 @nova_rt_ord(i64 %r32)
  %r34 = call i64 @nova_rt_int_to_str(i64 %r33)
  %r35 = call i64 @nova_rt_str_concat(i64 %r31, i64 %r34)
  %r36 = call i64 @nova_rt_print_any(i64 %r35)
  %r37.p = getelementptr inbounds [14 x i8], ptr @.str.9, i64 0, i64 0
  %r37 = ptrtoint ptr %r37.p to i64
  %r38.p = getelementptr inbounds [2 x i8], ptr @.str.8, i64 0, i64 0
  %r38 = ptrtoint ptr %r38.p to i64
  %r39 = call i64 @is_alpha(i64 %r38)
  %r40 = call i64 @nova_rt_int_to_str(i64 %r39)
  %r41 = call i64 @nova_rt_str_concat(i64 %r37, i64 %r40)
  %r42 = call i64 @nova_rt_print_any(i64 %r41)
  %r43.p = getelementptr inbounds [17 x i8], ptr @.str.10, i64 0, i64 0
  %r43 = ptrtoint ptr %r43.p to i64
  %r44 = load i64, ptr %slot.s, align 8
  %r45 = add i64 0, 0
  %r46 = call i64 @nova_rt_index_get(i64 %r44, i64 %r45)
  %r47 = call i64 @is_alpha(i64 %r46)
  %r48 = call i64 @nova_rt_int_to_str(i64 %r47)
  %r49 = call i64 @nova_rt_str_concat(i64 %r43, i64 %r48)
  %r50 = call i64 @nova_rt_print_any(i64 %r49)
  %r51 = add i64 0, 0
  store i64 %r51, ptr %slot.pos, align 8
  %r52 = load i64, ptr %slot.s, align 8
  %r53 = call i64 @nova_rt_len_any(i64 %r52)
  store i64 %r53, ptr %slot.length, align 8
  %r54 = load i64, ptr %slot.s, align 8
  %r55 = load i64, ptr %slot.pos, align 8
  %r56 = call i64 @nova_rt_index_get(i64 %r54, i64 %r55)
  store i64 %r56, ptr %slot.ch, align 8
  %r57.p = getelementptr inbounds [6 x i8], ptr @.str.11, i64 0, i64 0
  %r57 = ptrtoint ptr %r57.p to i64
  %r58 = load i64, ptr %slot.ch, align 8
  %r59 = call i64 @nova_rt_str_concat(i64 %r57, i64 %r58)
  %r60.p = getelementptr inbounds [2 x i8], ptr @.str.4, i64 0, i64 0
  %r60 = ptrtoint ptr %r60.p to i64
  %r61 = call i64 @nova_rt_str_concat(i64 %r59, i64 %r60)
  %r62 = call i64 @nova_rt_print_any(i64 %r61)
  %r63.p = getelementptr inbounds [15 x i8], ptr @.str.12, i64 0, i64 0
  %r63 = ptrtoint ptr %r63.p to i64
  %r64 = load i64, ptr %slot.pos, align 8
  %r65 = load i64, ptr %slot.length, align 8
  %r66.cmp = icmp slt i64 %r64, %r65
  %r66 = zext i1 %r66.cmp to i64
  %r67 = call i64 @nova_rt_int_to_str(i64 %r66)
  %r68 = call i64 @nova_rt_str_concat(i64 %r63, i64 %r67)
  %r69 = call i64 @nova_rt_print_any(i64 %r68)
  %r70.p = getelementptr inbounds [15 x i8], ptr @.str.13, i64 0, i64 0
  %r70 = ptrtoint ptr %r70.p to i64
  %r71 = load i64, ptr %slot.ch, align 8
  %r72 = call i64 @is_alpha(i64 %r71)
  %r73 = call i64 @nova_rt_int_to_str(i64 %r72)
  %r74 = call i64 @nova_rt_str_concat(i64 %r70, i64 %r73)
  %r75 = call i64 @nova_rt_print_any(i64 %r74)
  %r76.p = getelementptr inbounds [22 x i8], ptr @.str.14, i64 0, i64 0
  %r76 = ptrtoint ptr %r76.p to i64
  %r77 = call i64 @nova_rt_print_any(i64 %r76)
  %r78.p = getelementptr inbounds [1 x i8], ptr @.str.15, i64 0, i64 0
  %r78 = ptrtoint ptr %r78.p to i64
  store i64 %r78, ptr %slot.word, align 8
  br label %while_hdr12
while_hdr12:
  %r79 = load i64, ptr %slot.pos, align 8
  %r80 = load i64, ptr %slot.length, align 8
  %r81.cmp = icmp slt i64 %r79, %r80
  %r81 = zext i1 %r81.cmp to i64
  store i64 %r81, ptr %slot.__sc_15, align 8
  %br_and_rhs16 = icmp ne i64 %r81, 0
  br i1 %br_and_rhs16, label %and_rhs16, label %and_merge17
and_rhs16:
  %r82 = load i64, ptr %slot.s, align 8
  %r83 = load i64, ptr %slot.pos, align 8
  %r84 = call i64 @nova_rt_index_get(i64 %r82, i64 %r83)
  %r85 = call i64 @is_alpha(i64 %r84)
  store i64 %r85, ptr %slot.__sc_15, align 8
  br label %and_merge17
and_merge17:
  %r86 = load i64, ptr %slot.__sc_15, align 8
  %br_while_body13 = icmp ne i64 %r86, 0
  br i1 %br_while_body13, label %while_body13, label %while_exit14
while_body13:
  %r87 = load i64, ptr %slot.word, align 8
  %r88 = load i64, ptr %slot.s, align 8
  %r89 = load i64, ptr %slot.pos, align 8
  %r90 = call i64 @nova_rt_index_get(i64 %r88, i64 %r89)
  %r91 = call i64 @nova_rt_str_concat(i64 %r87, i64 %r90)
  store i64 %r91, ptr %slot.word, align 8
  %r92 = load i64, ptr %slot.pos, align 8
  %r93 = add i64 1, 0
  %r94 = add i64 %r92, %r93
  store i64 %r94, ptr %slot.pos, align 8
  br label %while_hdr12
while_exit14:
  %r95.p = getelementptr inbounds [8 x i8], ptr @.str.16, i64 0, i64 0
  %r95 = ptrtoint ptr %r95.p to i64
  %r96 = load i64, ptr %slot.word, align 8
  %r97 = call i64 @nova_rt_str_concat(i64 %r95, i64 %r96)
  %r98.p = getelementptr inbounds [2 x i8], ptr @.str.4, i64 0, i64 0
  %r98 = ptrtoint ptr %r98.p to i64
  %r99 = call i64 @nova_rt_str_concat(i64 %r97, i64 %r98)
  %r100 = call i64 @nova_rt_print_any(i64 %r99)
  %r101.p = getelementptr inbounds [12 x i8], ptr @.str.17, i64 0, i64 0
  %r101 = ptrtoint ptr %r101.p to i64
  %r102 = load i64, ptr %slot.pos, align 8
  %r103 = call i64 @nova_rt_int_to_str(i64 %r102)
  %r104 = call i64 @nova_rt_str_concat(i64 %r101, i64 %r103)
  %r105 = call i64 @nova_rt_print_any(i64 %r104)
  ret i64 0
}

define i64 @nova_main() nounwind {
entry:
  %r0 = call i64 @test_basics()
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
@.str.1 = private unnamed_addr constant [11 x i8] c"let x = 42\00"
@.str.2 = private unnamed_addr constant [6 x i8] c"len: \00"
@.str.3 = private unnamed_addr constant [8 x i8] c"s[0]: '\00"
@.str.4 = private unnamed_addr constant [2 x i8] c"'\00"
@.str.5 = private unnamed_addr constant [8 x i8] c"s[1]: '\00"
@.str.6 = private unnamed_addr constant [8 x i8] c"s[2]: '\00"
@.str.7 = private unnamed_addr constant [9 x i8] c"ord(l): \00"
@.str.8 = private unnamed_addr constant [2 x i8] c"l\00"
@.str.9 = private unnamed_addr constant [14 x i8] c"is_alpha(l): \00"
@.str.10 = private unnamed_addr constant [17 x i8] c"is_alpha(s[0]): \00"
@.str.11 = private unnamed_addr constant [6 x i8] c"ch: '\00"
@.str.12 = private unnamed_addr constant [15 x i8] c"pos < length: \00"
@.str.13 = private unnamed_addr constant [15 x i8] c"is_alpha(ch): \00"
@.str.14 = private unnamed_addr constant [22 x i8] c"Testing while loop...\00"
@.str.15 = private unnamed_addr constant [1 x i8] c"\00"
@.str.16 = private unnamed_addr constant [8 x i8] c"word: '\00"
@.str.17 = private unnamed_addr constant [12 x i8] c"pos after: \00"
