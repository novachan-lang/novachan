; NOVA IR-Pipeline Compiler Output
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"

@__nova_error_flag = thread_local global i64 0
@__nova_error_msg = thread_local global i64 0

; Runtime declarations
declare i32 @puts(ptr) nounwind
declare i32 @printf(ptr, ...) nounwind
declare i32 @strcmp(ptr, ptr) nounwind
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
declare i64 @nova_rt_system(i64) nounwind
declare i64 @nova_rt_exec(i64) nounwind
declare i64 @nova_rt_create_string(ptr) nounwind
declare void @nova_rt_init_args(i64, i64) nounwind
declare void @nova_rt_cleanup() nounwind

define i64 @abs_val(i64 %p0) nounwind {
entry:
  %slot.x = alloca i64, align 8
  store i64 %p0, ptr %slot.x, align 8
  %slot.__ifexpr_0 = alloca i64, align 8
  store i64 0, ptr %slot.__ifexpr_0, align 8
  %slot.result = alloca i64, align 8
  store i64 0, ptr %slot.result, align 8
  %r0 = load i64, ptr %slot.x, align 8
  %r1 = add i64 0, 0
  %r2.cmp = icmp slt i64 %r0, %r1
  %r2 = zext i1 %r2.cmp to i64
  %br_ife_then1 = icmp ne i64 %r2, 0
  br i1 %br_ife_then1, label %ife_then1, label %ife_else2
ife_then1:
  %r3 = add i64 0, 0
  %r4 = load i64, ptr %slot.x, align 8
  %r5 = sub i64 %r3, %r4
  store i64 %r5, ptr %slot.__ifexpr_0, align 8
  br label %ife_merge3
ife_else2:
  %r6 = load i64, ptr %slot.x, align 8
  store i64 %r6, ptr %slot.__ifexpr_0, align 8
  br label %ife_merge3
ife_merge3:
  %r7 = load i64, ptr %slot.__ifexpr_0, align 8
  store i64 %r7, ptr %slot.result, align 8
  %r8 = load i64, ptr %slot.result, align 8
  ret i64 %r8
}

define i64 @classify(i64 %p0) nounwind {
entry:
  %slot.n = alloca i64, align 8
  store i64 %p0, ptr %slot.n, align 8
  %slot.__ifexpr_4 = alloca i64, align 8
  store i64 0, ptr %slot.__ifexpr_4, align 8
  %slot.__ifexpr_8 = alloca i64, align 8
  store i64 0, ptr %slot.__ifexpr_8, align 8
  %slot.label = alloca i64, align 8
  store i64 0, ptr %slot.label, align 8
  %r0 = load i64, ptr %slot.n, align 8
  %r1 = add i64 0, 0
  %r2.cmp = icmp sgt i64 %r0, %r1
  %r2 = zext i1 %r2.cmp to i64
  %br_ife_then5 = icmp ne i64 %r2, 0
  br i1 %br_ife_then5, label %ife_then5, label %ife_else6
ife_then5:
  %r3.p = getelementptr inbounds [9 x i8], ptr @.str.0, i64 0, i64 0
  %r3 = ptrtoint ptr %r3.p to i64
  store i64 %r3, ptr %slot.__ifexpr_4, align 8
  br label %ife_merge7
ife_else6:
  %r4 = load i64, ptr %slot.n, align 8
  %r5 = add i64 0, 0
  %r6.cmp = icmp slt i64 %r4, %r5
  %r6 = zext i1 %r6.cmp to i64
  %br_ife_then9 = icmp ne i64 %r6, 0
  br i1 %br_ife_then9, label %ife_then9, label %ife_else10
ife_then9:
  %r7.p = getelementptr inbounds [9 x i8], ptr @.str.1, i64 0, i64 0
  %r7 = ptrtoint ptr %r7.p to i64
  store i64 %r7, ptr %slot.__ifexpr_8, align 8
  br label %ife_merge11
ife_else10:
  %r8.p = getelementptr inbounds [5 x i8], ptr @.str.2, i64 0, i64 0
  %r8 = ptrtoint ptr %r8.p to i64
  store i64 %r8, ptr %slot.__ifexpr_8, align 8
  br label %ife_merge11
ife_merge11:
  %r9 = load i64, ptr %slot.__ifexpr_8, align 8
  store i64 %r9, ptr %slot.__ifexpr_4, align 8
  br label %ife_merge7
ife_merge7:
  %r10 = load i64, ptr %slot.__ifexpr_4, align 8
  store i64 %r10, ptr %slot.label, align 8
  %r11 = load i64, ptr %slot.label, align 8
  ret i64 %r11
}

define i64 @nova_main() nounwind {
entry:
  %slot.__ifexpr_12 = alloca i64, align 8
  store i64 0, ptr %slot.__ifexpr_12, align 8
  %slot.x = alloca i64, align 8
  store i64 0, ptr %slot.x, align 8
  %slot.__sc_16 = alloca i64, align 8
  store i64 0, ptr %slot.__sc_16, align 8
  %slot.__sc_19 = alloca i64, align 8
  store i64 0, ptr %slot.__sc_19, align 8
  %slot.__sc_22 = alloca i64, align 8
  store i64 0, ptr %slot.__sc_22, align 8
  %r0.p = getelementptr inbounds [11 x i8], ptr @.str.3, i64 0, i64 0
  %r0 = ptrtoint ptr %r0.p to i64
  %r1 = add i64 5, 0
  %r2 = sub i64 0, %r1
  %r3 = call i64 @abs_val(i64 %r2)
  %r4 = call i64 @nova_rt_int_to_str(i64 %r3)
  %r5 = call i64 @nova_rt_add(i64 %r0, i64 %r4)
  %r6 = call i64 @nova_rt_print_any(i64 %r5)
  %r7.p = getelementptr inbounds [10 x i8], ptr @.str.4, i64 0, i64 0
  %r7 = ptrtoint ptr %r7.p to i64
  %r8 = add i64 3, 0
  %r9 = call i64 @abs_val(i64 %r8)
  %r10 = call i64 @nova_rt_int_to_str(i64 %r9)
  %r11 = call i64 @nova_rt_add(i64 %r7, i64 %r10)
  %r12 = call i64 @nova_rt_print_any(i64 %r11)
  %r13.p = getelementptr inbounds [16 x i8], ptr @.str.5, i64 0, i64 0
  %r13 = ptrtoint ptr %r13.p to i64
  %r14 = add i64 10, 0
  %r15 = call i64 @classify(i64 %r14)
  %r16 = call i64 @nova_rt_add(i64 %r13, i64 %r15)
  %r17 = call i64 @nova_rt_print_any(i64 %r16)
  %r18.p = getelementptr inbounds [16 x i8], ptr @.str.6, i64 0, i64 0
  %r18 = ptrtoint ptr %r18.p to i64
  %r19 = add i64 3, 0
  %r20 = sub i64 0, %r19
  %r21 = call i64 @classify(i64 %r20)
  %r22 = call i64 @nova_rt_add(i64 %r18, i64 %r21)
  %r23 = call i64 @nova_rt_print_any(i64 %r22)
  %r24.p = getelementptr inbounds [15 x i8], ptr @.str.7, i64 0, i64 0
  %r24 = ptrtoint ptr %r24.p to i64
  %r25 = add i64 0, 0
  %r26 = call i64 @classify(i64 %r25)
  %r27 = call i64 @nova_rt_add(i64 %r24, i64 %r26)
  %r28 = call i64 @nova_rt_print_any(i64 %r27)
  %r29 = add i64 1, 0
  %br_ife_then13 = icmp ne i64 %r29, 0
  br i1 %br_ife_then13, label %ife_then13, label %ife_else14
ife_then13:
  %r30 = add i64 42, 0
  store i64 %r30, ptr %slot.__ifexpr_12, align 8
  br label %ife_merge15
ife_else14:
  %r31 = add i64 0, 0
  store i64 %r31, ptr %slot.__ifexpr_12, align 8
  br label %ife_merge15
ife_merge15:
  %r32 = load i64, ptr %slot.__ifexpr_12, align 8
  store i64 %r32, ptr %slot.x, align 8
  %r33.p = getelementptr inbounds [5 x i8], ptr @.str.8, i64 0, i64 0
  %r33 = ptrtoint ptr %r33.p to i64
  %r34 = load i64, ptr %slot.x, align 8
  %r35 = call i64 @nova_rt_int_to_str(i64 %r34)
  %r36 = call i64 @nova_rt_add(i64 %r33, i64 %r35)
  %r37 = call i64 @nova_rt_print_any(i64 %r36)
  %r38 = add i64 5, 0
  %r39 = sub i64 0, %r38
  %r40 = call i64 @abs_val(i64 %r39)
  %r41 = add i64 5, 0
  %r42 = call i64 @nova_rt_eq(i64 %r40, i64 %r41)
  store i64 %r42, ptr %slot.__sc_16, align 8
  %br_and_rhs17 = icmp ne i64 %r42, 0
  br i1 %br_and_rhs17, label %and_rhs17, label %and_merge18
and_rhs17:
  %r43 = add i64 3, 0
  %r44 = call i64 @abs_val(i64 %r43)
  %r45 = add i64 3, 0
  %r46 = call i64 @nova_rt_eq(i64 %r44, i64 %r45)
  store i64 %r46, ptr %slot.__sc_16, align 8
  br label %and_merge18
and_merge18:
  %r47 = load i64, ptr %slot.__sc_16, align 8
  store i64 %r47, ptr %slot.__sc_19, align 8
  %br_and_rhs20 = icmp ne i64 %r47, 0
  br i1 %br_and_rhs20, label %and_rhs20, label %and_merge21
and_rhs20:
  %r48 = add i64 0, 0
  %r49 = call i64 @classify(i64 %r48)
  %r50.p = getelementptr inbounds [5 x i8], ptr @.str.2, i64 0, i64 0
  %r50 = ptrtoint ptr %r50.p to i64
  %r51 = call i64 @nova_rt_eq(i64 %r49, i64 %r50)
  store i64 %r51, ptr %slot.__sc_19, align 8
  br label %and_merge21
and_merge21:
  %r52 = load i64, ptr %slot.__sc_19, align 8
  store i64 %r52, ptr %slot.__sc_22, align 8
  %br_and_rhs23 = icmp ne i64 %r52, 0
  br i1 %br_and_rhs23, label %and_rhs23, label %and_merge24
and_rhs23:
  %r53 = load i64, ptr %slot.x, align 8
  %r54 = add i64 42, 0
  %r55 = call i64 @nova_rt_eq(i64 %r53, i64 %r54)
  store i64 %r55, ptr %slot.__sc_22, align 8
  br label %and_merge24
and_merge24:
  %r56 = load i64, ptr %slot.__sc_22, align 8
  %br_then25 = icmp ne i64 %r56, 0
  br i1 %br_then25, label %then25, label %else26
then25:
  %r57.p = getelementptr inbounds [5 x i8], ptr @.str.9, i64 0, i64 0
  %r57 = ptrtoint ptr %r57.p to i64
  %r58 = call i64 @nova_rt_print_any(i64 %r57)
  br label %endif27
else26:
  %r59.p = getelementptr inbounds [5 x i8], ptr @.str.10, i64 0, i64 0
  %r59 = ptrtoint ptr %r59.p to i64
  %r60 = call i64 @nova_rt_print_any(i64 %r59)
  br label %endif27
endif27:
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
@.str.0 = private unnamed_addr constant [9 x i8] c"positive\00"
@.str.1 = private unnamed_addr constant [9 x i8] c"negative\00"
@.str.2 = private unnamed_addr constant [5 x i8] c"zero\00"
@.str.3 = private unnamed_addr constant [11 x i8] c"abs(-5) = \00"
@.str.4 = private unnamed_addr constant [10 x i8] c"abs(3) = \00"
@.str.5 = private unnamed_addr constant [16 x i8] c"classify(10) = \00"
@.str.6 = private unnamed_addr constant [16 x i8] c"classify(-3) = \00"
@.str.7 = private unnamed_addr constant [15 x i8] c"classify(0) = \00"
@.str.8 = private unnamed_addr constant [5 x i8] c"x = \00"
@.str.9 = private unnamed_addr constant [5 x i8] c"PASS\00"
@.str.10 = private unnamed_addr constant [5 x i8] c"FAIL\00"
