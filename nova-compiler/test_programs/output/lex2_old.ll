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
  %r0 = getelementptr inbounds [11 x i8], ptr @.str.1, i64 0, i64 0
  %r1 = ptrtoint ptr %r0 to i64
  store i64 %r1, ptr %slot.s, align 8
  %r2 = getelementptr inbounds [6 x i8], ptr @.str.2, i64 0, i64 0
  %r3 = ptrtoint ptr %r2 to i64
  %r4 = load i64, ptr %slot.s, align 8
  %r5 = call i64 @nova_rt_len_any(i64 %r4)
  %r6 = call i64 @nova_rt_int_to_str(i64 %r5)
  %r7 = call i64 @nova_rt_add(i64 %r3, i64 %r6)
  %r8 = call i64 @nova_rt_print_any(i64 %r7)
  %r9 = getelementptr inbounds [8 x i8], ptr @.str.3, i64 0, i64 0
  %r10 = ptrtoint ptr %r9 to i64
  %r11 = load i64, ptr %slot.s, align 8
  %r12 = call i64 @nova_rt_index_get(i64 %r11, i64 0)
  %r13 = call i64 @nova_rt_add(i64 %r10, i64 %r12)
  %r14 = getelementptr inbounds [2 x i8], ptr @.str.4, i64 0, i64 0
  %r15 = ptrtoint ptr %r14 to i64
  %r16 = call i64 @nova_rt_add(i64 %r13, i64 %r15)
  %r17 = call i64 @nova_rt_print_any(i64 %r16)
  %r18 = getelementptr inbounds [8 x i8], ptr @.str.5, i64 0, i64 0
  %r19 = ptrtoint ptr %r18 to i64
  %r20 = load i64, ptr %slot.s, align 8
  %r21 = call i64 @nova_rt_index_get(i64 %r20, i64 1)
  %r22 = call i64 @nova_rt_add(i64 %r19, i64 %r21)
  %r23 = getelementptr inbounds [2 x i8], ptr @.str.4, i64 0, i64 0
  %r24 = ptrtoint ptr %r23 to i64
  %r25 = call i64 @nova_rt_add(i64 %r22, i64 %r24)
  %r26 = call i64 @nova_rt_print_any(i64 %r25)
  %r27 = getelementptr inbounds [8 x i8], ptr @.str.6, i64 0, i64 0
  %r28 = ptrtoint ptr %r27 to i64
  %r29 = load i64, ptr %slot.s, align 8
  %r30 = call i64 @nova_rt_index_get(i64 %r29, i64 2)
  %r31 = call i64 @nova_rt_add(i64 %r28, i64 %r30)
  %r32 = getelementptr inbounds [2 x i8], ptr @.str.4, i64 0, i64 0
  %r33 = ptrtoint ptr %r32 to i64
  %r34 = call i64 @nova_rt_add(i64 %r31, i64 %r33)
  %r35 = call i64 @nova_rt_print_any(i64 %r34)
  %r36 = getelementptr inbounds [9 x i8], ptr @.str.7, i64 0, i64 0
  %r37 = ptrtoint ptr %r36 to i64
  %r38 = getelementptr inbounds [2 x i8], ptr @.str.8, i64 0, i64 0
  %r39 = ptrtoint ptr %r38 to i64
  %r40 = call i64 @nova_rt_ord(i64 %r39)
  %r41 = call i64 @nova_rt_int_to_str(i64 %r40)
  %r42 = call i64 @nova_rt_add(i64 %r37, i64 %r41)
  %r43 = call i64 @nova_rt_print_any(i64 %r42)
  %r44 = getelementptr inbounds [14 x i8], ptr @.str.9, i64 0, i64 0
  %r45 = ptrtoint ptr %r44 to i64
  %r46 = getelementptr inbounds [2 x i8], ptr @.str.8, i64 0, i64 0
  %r47 = ptrtoint ptr %r46 to i64
  %r48 = call i64 @is_alpha(i64 %r47)
  %r49 = call i64 @nova_rt_int_to_str(i64 %r48)
  %r50 = call i64 @nova_rt_add(i64 %r45, i64 %r49)
  %r51 = call i64 @nova_rt_print_any(i64 %r50)
  %r52 = getelementptr inbounds [17 x i8], ptr @.str.10, i64 0, i64 0
  %r53 = ptrtoint ptr %r52 to i64
  %r54 = load i64, ptr %slot.s, align 8
  %r55 = call i64 @nova_rt_index_get(i64 %r54, i64 0)
  %r56 = call i64 @is_alpha(i64 %r55)
  %r57 = call i64 @nova_rt_int_to_str(i64 %r56)
  %r58 = call i64 @nova_rt_add(i64 %r53, i64 %r57)
  %r59 = call i64 @nova_rt_print_any(i64 %r58)
  store i64 0, ptr %slot.pos, align 8
  %r60 = load i64, ptr %slot.s, align 8
  %r61 = call i64 @nova_rt_len_any(i64 %r60)
  store i64 %r61, ptr %slot.length, align 8
  %r62 = load i64, ptr %slot.s, align 8
  %r63 = load i64, ptr %slot.pos, align 8
  %r64 = call i64 @nova_rt_index_get(i64 %r62, i64 %r63)
  store i64 %r64, ptr %slot.ch, align 8
  %r65 = getelementptr inbounds [6 x i8], ptr @.str.11, i64 0, i64 0
  %r66 = ptrtoint ptr %r65 to i64
  %r67 = load i64, ptr %slot.ch, align 8
  %r68 = call i64 @nova_rt_add(i64 %r66, i64 %r67)
  %r69 = getelementptr inbounds [2 x i8], ptr @.str.4, i64 0, i64 0
  %r70 = ptrtoint ptr %r69 to i64
  %r71 = call i64 @nova_rt_add(i64 %r68, i64 %r70)
  %r72 = call i64 @nova_rt_print_any(i64 %r71)
  %r73 = getelementptr inbounds [15 x i8], ptr @.str.12, i64 0, i64 0
  %r74 = ptrtoint ptr %r73 to i64
  %r75 = load i64, ptr %slot.pos, align 8
  %r76 = load i64, ptr %slot.length, align 8
  %t78 = icmp slt i64 %r75, %r76
  %r77 = zext i1 %t78 to i64
  %r79 = call i64 @nova_rt_int_to_str(i64 %r77)
  %r80 = call i64 @nova_rt_add(i64 %r74, i64 %r79)
  %r81 = call i64 @nova_rt_print_any(i64 %r80)
  %r82 = getelementptr inbounds [15 x i8], ptr @.str.13, i64 0, i64 0
  %r83 = ptrtoint ptr %r82 to i64
  %r84 = load i64, ptr %slot.ch, align 8
  %r85 = call i64 @is_alpha(i64 %r84)
  %r86 = call i64 @nova_rt_int_to_str(i64 %r85)
  %r87 = call i64 @nova_rt_add(i64 %r83, i64 %r86)
  %r88 = call i64 @nova_rt_print_any(i64 %r87)
  %r89 = getelementptr inbounds [22 x i8], ptr @.str.14, i64 0, i64 0
  %r90 = ptrtoint ptr %r89 to i64
  %r91 = call i64 @nova_rt_print_any(i64 %r90)
  %r92 = getelementptr inbounds [1 x i8], ptr @.str.15, i64 0, i64 0
  %r93 = ptrtoint ptr %r92 to i64
  store i64 %r93, ptr %slot.word, align 8
  br label %while_hdr20
while_hdr20:
  %r94 = load i64, ptr %slot.pos, align 8
  %r95 = load i64, ptr %slot.length, align 8
  %t97 = icmp slt i64 %r94, %r95
  %r96 = zext i1 %t97 to i64
  %r98 = load i64, ptr %slot.s, align 8
  %r99 = load i64, ptr %slot.pos, align 8
  %r100 = call i64 @nova_rt_index_get(i64 %r98, i64 %r99)
  %r101 = call i64 @is_alpha(i64 %r100)
  br label %and_entry23
and_entry23:
  %t103 = icmp ne i64 %r96, 0
  br i1 %t103, label %and_rhs24, label %and_end25
and_rhs24:
  %r104 = load i64, ptr %slot.s, align 8
  %r105 = load i64, ptr %slot.pos, align 8
  %r106 = call i64 @nova_rt_index_get(i64 %r104, i64 %r105)
  %r107 = call i64 @is_alpha(i64 %r106)
  br label %and_done26
and_done26:
  br label %and_end25
and_end25:
  %r102 = phi i64 [0, %and_entry23], [%r107, %and_done26]
  %t108 = icmp ne i64 %r102, 0
  br i1 %t108, label %while_body21, label %while_exit22
while_body21:
  %r109 = load i64, ptr %slot.word, align 8
  %r110 = load i64, ptr %slot.s, align 8
  %r111 = load i64, ptr %slot.pos, align 8
  %r112 = call i64 @nova_rt_index_get(i64 %r110, i64 %r111)
  %r113 = call i64 @nova_rt_add(i64 %r109, i64 %r112)
  store i64 %r113, ptr %slot.word, align 8
  %r114 = load i64, ptr %slot.pos, align 8
  %r115 = call i64 @nova_rt_add(i64 %r114, i64 1)
  store i64 %r115, ptr %slot.pos, align 8
  br label %while_hdr20
while_exit22:
  %r116 = getelementptr inbounds [8 x i8], ptr @.str.16, i64 0, i64 0
  %r117 = ptrtoint ptr %r116 to i64
  %r118 = load i64, ptr %slot.word, align 8
  %r119 = call i64 @nova_rt_add(i64 %r117, i64 %r118)
  %r120 = getelementptr inbounds [2 x i8], ptr @.str.4, i64 0, i64 0
  %r121 = ptrtoint ptr %r120 to i64
  %r122 = call i64 @nova_rt_add(i64 %r119, i64 %r121)
  %r123 = call i64 @nova_rt_print_any(i64 %r122)
  %r124 = getelementptr inbounds [12 x i8], ptr @.str.17, i64 0, i64 0
  %r125 = ptrtoint ptr %r124 to i64
  %r126 = load i64, ptr %slot.pos, align 8
  %r127 = call i64 @nova_rt_int_to_str(i64 %r126)
  %r128 = call i64 @nova_rt_add(i64 %r125, i64 %r127)
  %r129 = call i64 @nova_rt_print_any(i64 %r128)
  ret i64 %r129
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
