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

define i64 @test_alpha() nounwind {
entry:
  %slot.c = alloca i64, align 8
  store i64 0, ptr %slot.c, align 8
  %slot.r1 = alloca i64, align 8
  store i64 0, ptr %slot.r1, align 8
  %slot.r2 = alloca i64, align 8
  store i64 0, ptr %slot.r2, align 8
  %r0 = getelementptr inbounds [2 x i8], ptr @.str.0, i64 0, i64 0
  %r1 = ptrtoint ptr %r0 to i64
  %r2 = call i64 @nova_rt_ord(i64 %r1)
  store i64 %r2, ptr %slot.c, align 8
  %r3 = getelementptr inbounds [10 x i8], ptr @.str.1, i64 0, i64 0
  %r4 = ptrtoint ptr %r3 to i64
  %r5 = load i64, ptr %slot.c, align 8
  %r6 = call i64 @nova_rt_int_to_str(i64 %r5)
  %r7 = call i64 @nova_rt_add(i64 %r4, i64 %r6)
  %r8 = call i64 @nova_rt_print_any(i64 %r7)
  %r9 = getelementptr inbounds [10 x i8], ptr @.str.2, i64 0, i64 0
  %r10 = ptrtoint ptr %r9 to i64
  %r11 = load i64, ptr %slot.c, align 8
  %t13 = icmp sge i64 %r11, 65
  %r12 = zext i1 %t13 to i64
  %r14 = call i64 @nova_rt_int_to_str(i64 %r12)
  %r15 = call i64 @nova_rt_add(i64 %r10, i64 %r14)
  %r16 = call i64 @nova_rt_print_any(i64 %r15)
  %r17 = getelementptr inbounds [10 x i8], ptr @.str.3, i64 0, i64 0
  %r18 = ptrtoint ptr %r17 to i64
  %r19 = load i64, ptr %slot.c, align 8
  %t21 = icmp sle i64 %r19, 90
  %r20 = zext i1 %t21 to i64
  %r22 = call i64 @nova_rt_int_to_str(i64 %r20)
  %r23 = call i64 @nova_rt_add(i64 %r18, i64 %r22)
  %r24 = call i64 @nova_rt_print_any(i64 %r23)
  %r25 = getelementptr inbounds [10 x i8], ptr @.str.4, i64 0, i64 0
  %r26 = ptrtoint ptr %r25 to i64
  %r27 = load i64, ptr %slot.c, align 8
  %t29 = icmp sge i64 %r27, 97
  %r28 = zext i1 %t29 to i64
  %r30 = call i64 @nova_rt_int_to_str(i64 %r28)
  %r31 = call i64 @nova_rt_add(i64 %r26, i64 %r30)
  %r32 = call i64 @nova_rt_print_any(i64 %r31)
  %r33 = getelementptr inbounds [11 x i8], ptr @.str.5, i64 0, i64 0
  %r34 = ptrtoint ptr %r33 to i64
  %r35 = load i64, ptr %slot.c, align 8
  %t37 = icmp sle i64 %r35, 122
  %r36 = zext i1 %t37 to i64
  %r38 = call i64 @nova_rt_int_to_str(i64 %r36)
  %r39 = call i64 @nova_rt_add(i64 %r34, i64 %r38)
  %r40 = call i64 @nova_rt_print_any(i64 %r39)
  %r41 = getelementptr inbounds [24 x i8], ptr @.str.6, i64 0, i64 0
  %r42 = ptrtoint ptr %r41 to i64
  %r43 = load i64, ptr %slot.c, align 8
  %t45 = icmp sge i64 %r43, 65
  %r44 = zext i1 %t45 to i64
  %r46 = load i64, ptr %slot.c, align 8
  %t48 = icmp sle i64 %r46, 90
  %r47 = zext i1 %t48 to i64
  br label %and_entry0
and_entry0:
  %t50 = icmp ne i64 %r44, 0
  br i1 %t50, label %and_rhs1, label %and_end2
and_rhs1:
  %r51 = load i64, ptr %slot.c, align 8
  %t53 = icmp sle i64 %r51, 90
  %r52 = zext i1 %t53 to i64
  br label %and_done3
and_done3:
  br label %and_end2
and_end2:
  %r49 = phi i64 [0, %and_entry0], [%r52, %and_done3]
  %r54 = call i64 @nova_rt_int_to_str(i64 %r49)
  %r55 = call i64 @nova_rt_add(i64 %r42, i64 %r54)
  %r56 = call i64 @nova_rt_print_any(i64 %r55)
  %r57 = getelementptr inbounds [25 x i8], ptr @.str.7, i64 0, i64 0
  %r58 = ptrtoint ptr %r57 to i64
  %r59 = load i64, ptr %slot.c, align 8
  %t61 = icmp sge i64 %r59, 97
  %r60 = zext i1 %t61 to i64
  %r62 = load i64, ptr %slot.c, align 8
  %t64 = icmp sle i64 %r62, 122
  %r63 = zext i1 %t64 to i64
  br label %and_entry4
and_entry4:
  %t66 = icmp ne i64 %r60, 0
  br i1 %t66, label %and_rhs5, label %and_end6
and_rhs5:
  %r67 = load i64, ptr %slot.c, align 8
  %t69 = icmp sle i64 %r67, 122
  %r68 = zext i1 %t69 to i64
  br label %and_done7
and_done7:
  br label %and_end6
and_end6:
  %r65 = phi i64 [0, %and_entry4], [%r68, %and_done7]
  %r70 = call i64 @nova_rt_int_to_str(i64 %r65)
  %r71 = call i64 @nova_rt_add(i64 %r58, i64 %r70)
  %r72 = call i64 @nova_rt_print_any(i64 %r71)
  %r73 = load i64, ptr %slot.c, align 8
  %t75 = icmp sge i64 %r73, 65
  %r74 = zext i1 %t75 to i64
  %r76 = load i64, ptr %slot.c, align 8
  %t78 = icmp sle i64 %r76, 90
  %r77 = zext i1 %t78 to i64
  br label %and_entry8
and_entry8:
  %t80 = icmp ne i64 %r74, 0
  br i1 %t80, label %and_rhs9, label %and_end10
and_rhs9:
  %r81 = load i64, ptr %slot.c, align 8
  %t83 = icmp sle i64 %r81, 90
  %r82 = zext i1 %t83 to i64
  br label %and_done11
and_done11:
  br label %and_end10
and_end10:
  %r79 = phi i64 [0, %and_entry8], [%r82, %and_done11]
  store i64 %r79, ptr %slot.r1, align 8
  %r84 = load i64, ptr %slot.c, align 8
  %t86 = icmp sge i64 %r84, 97
  %r85 = zext i1 %t86 to i64
  %r87 = load i64, ptr %slot.c, align 8
  %t89 = icmp sle i64 %r87, 122
  %r88 = zext i1 %t89 to i64
  br label %and_entry12
and_entry12:
  %t91 = icmp ne i64 %r85, 0
  br i1 %t91, label %and_rhs13, label %and_end14
and_rhs13:
  %r92 = load i64, ptr %slot.c, align 8
  %t94 = icmp sle i64 %r92, 122
  %r93 = zext i1 %t94 to i64
  br label %and_done15
and_done15:
  br label %and_end14
and_end14:
  %r90 = phi i64 [0, %and_entry12], [%r93, %and_done15]
  store i64 %r90, ptr %slot.r2, align 8
  %r95 = getelementptr inbounds [5 x i8], ptr @.str.8, i64 0, i64 0
  %r96 = ptrtoint ptr %r95 to i64
  %r97 = load i64, ptr %slot.r1, align 8
  %r98 = call i64 @nova_rt_int_to_str(i64 %r97)
  %r99 = call i64 @nova_rt_add(i64 %r96, i64 %r98)
  %r100 = call i64 @nova_rt_print_any(i64 %r99)
  %r101 = getelementptr inbounds [5 x i8], ptr @.str.9, i64 0, i64 0
  %r102 = ptrtoint ptr %r101 to i64
  %r103 = load i64, ptr %slot.r2, align 8
  %r104 = call i64 @nova_rt_int_to_str(i64 %r103)
  %r105 = call i64 @nova_rt_add(i64 %r102, i64 %r104)
  %r106 = call i64 @nova_rt_print_any(i64 %r105)
  %r107 = getelementptr inbounds [11 x i8], ptr @.str.10, i64 0, i64 0
  %r108 = ptrtoint ptr %r107 to i64
  %r109 = load i64, ptr %slot.r1, align 8
  %r110 = load i64, ptr %slot.r2, align 8
  br label %or_entry16
or_entry16:
  %t112 = icmp ne i64 %r109, 0
  br i1 %t112, label %or_end18, label %or_rhs17
or_rhs17:
  %r113 = load i64, ptr %slot.r2, align 8
  br label %or_done19
or_done19:
  br label %or_end18
or_end18:
  %r111 = phi i64 [%r109, %or_entry16], [%r113, %or_done19]
  %r114 = call i64 @nova_rt_int_to_str(i64 %r111)
  %r115 = call i64 @nova_rt_add(i64 %r108, i64 %r114)
  %r116 = call i64 @nova_rt_print_any(i64 %r115)
  ret i64 %r116
}

define i64 @nova_main() nounwind {
entry:
  %r0 = call i64 @test_alpha()
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
@.str.0 = private unnamed_addr constant [2 x i8] c"l\00"
@.str.1 = private unnamed_addr constant [10 x i8] c"ord(l) = \00"
@.str.2 = private unnamed_addr constant [10 x i8] c"c >= 65: \00"
@.str.3 = private unnamed_addr constant [10 x i8] c"c <= 90: \00"
@.str.4 = private unnamed_addr constant [10 x i8] c"c >= 97: \00"
@.str.5 = private unnamed_addr constant [11 x i8] c"c <= 122: \00"
@.str.6 = private unnamed_addr constant [24 x i8] c"(c >= 65 and c <= 90): \00"
@.str.7 = private unnamed_addr constant [25 x i8] c"(c >= 97 and c <= 122): \00"
@.str.8 = private unnamed_addr constant [5 x i8] c"r1: \00"
@.str.9 = private unnamed_addr constant [5 x i8] c"r2: \00"
@.str.10 = private unnamed_addr constant [11 x i8] c"r1 or r2: \00"
