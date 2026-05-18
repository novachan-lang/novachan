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
declare i64 @nova_rt_dict_items(i64) nounwind
declare i64 @nova_rt_system(i64) nounwind
declare i64 @nova_rt_exec(i64) nounwind
declare i64 @nova_rt_create_string(ptr) nounwind
declare void @nova_rt_init_args(i64, i64) nounwind
declare void @nova_rt_cleanup() nounwind
declare i64 @nova_rt_parse_float(i64) nounwind
declare i64 @nova_rt_read_line() nounwind
declare i64 @nova_rt_append_file(i64, i64) nounwind
declare i64 @nova_rt_file_exists(i64) nounwind
declare i64 @nova_rt_find(i64, i64) nounwind
declare i64 @nova_rt_list_concat(i64, i64) nounwind
declare i64 @nova_rt_list_reverse(i64) nounwind
declare i64 @nova_rt_list_sort(i64) nounwind
declare i64 @nova_rt_list_slice(i64, i64, i64) nounwind

define i64 @nova_user_main() nounwind {
entry:
  %slot.config = alloca i64, align 8
  store i64 0, ptr %slot.config, align 8
  %slot.name = alloca i64, align 8
  store i64 0, ptr %slot.name, align 8
  %slot.k = alloca i64, align 8
  store i64 0, ptr %slot.k, align 8
  %r0 = call i64 @nova_rt_dict_create()
  store i64 %r0, ptr %slot.config, align 8
  %r1.p = getelementptr inbounds [10 x i8], ptr @.str.0, i64 0, i64 0
  %r1 = ptrtoint ptr %r1.p to i64
  %r2 = load i64, ptr %slot.config, align 8
  %r3.p = getelementptr inbounds [5 x i8], ptr @.str.1, i64 0, i64 0
  %r3 = ptrtoint ptr %r3.p to i64
  call i64 @nova_rt_index_set(i64 %r2, i64 %r3, i64 %r1)
  %r4.p = getelementptr inbounds [5 x i8], ptr @.str.2, i64 0, i64 0
  %r4 = ptrtoint ptr %r4.p to i64
  %r5 = load i64, ptr %slot.config, align 8
  %r6.p = getelementptr inbounds [5 x i8], ptr @.str.3, i64 0, i64 0
  %r6 = ptrtoint ptr %r6.p to i64
  call i64 @nova_rt_index_set(i64 %r5, i64 %r6, i64 %r4)
  %r7.p = getelementptr inbounds [5 x i8], ptr @.str.4, i64 0, i64 0
  %r7 = ptrtoint ptr %r7.p to i64
  store i64 %r7, ptr %slot.name, align 8
  %r8.p = getelementptr inbounds [7 x i8], ptr @.str.5, i64 0, i64 0
  %r8 = ptrtoint ptr %r8.p to i64
  %r9 = load i64, ptr %slot.name, align 8
  %r10 = call i64 @nova_rt_any_to_str(i64 %r9)
  %r11 = call i64 @nova_rt_str_concat(i64 %r8, i64 %r10)
  %r12.p = getelementptr inbounds [2 x i8], ptr @.str.6, i64 0, i64 0
  %r12 = ptrtoint ptr %r12.p to i64
  %r13 = call i64 @nova_rt_str_concat(i64 %r11, i64 %r12)
  %r14 = call i64 @nova_rt_print_any(i64 %r13)
  %r15.p = getelementptr inbounds [9 x i8], ptr @.str.7, i64 0, i64 0
  %r15 = ptrtoint ptr %r15.p to i64
  %r16 = add i64 2, 0
  %r17 = add i64 3, 0
  %r18 = call i64 @nova_rt_add(i64 %r16, i64 %r17)
  %r19 = call i64 @nova_rt_any_to_str(i64 %r18)
  %r20 = call i64 @nova_rt_str_concat(i64 %r15, i64 %r19)
  %r21.p = getelementptr inbounds [1 x i8], ptr @.str.8, i64 0, i64 0
  %r21 = ptrtoint ptr %r21.p to i64
  %r22 = call i64 @nova_rt_str_concat(i64 %r20, i64 %r21)
  %r23 = call i64 @nova_rt_print_any(i64 %r22)
  %r24.p = getelementptr inbounds [5 x i8], ptr @.str.1, i64 0, i64 0
  %r24 = ptrtoint ptr %r24.p to i64
  store i64 %r24, ptr %slot.k, align 8
  %r25.p = getelementptr inbounds [8 x i8], ptr @.str.9, i64 0, i64 0
  %r25 = ptrtoint ptr %r25.p to i64
  %r26 = load i64, ptr %slot.config, align 8
  %r27 = load i64, ptr %slot.k, align 8
  %r28 = call i64 @nova_rt_index_get(i64 %r26, i64 %r27)
  %r29 = call i64 @nova_rt_any_to_str(i64 %r28)
  %r30 = call i64 @nova_rt_str_concat(i64 %r25, i64 %r29)
  %r31.p = getelementptr inbounds [1 x i8], ptr @.str.8, i64 0, i64 0
  %r31 = ptrtoint ptr %r31.p to i64
  %r32 = call i64 @nova_rt_str_concat(i64 %r30, i64 %r31)
  %r33 = call i64 @nova_rt_print_any(i64 %r32)
  %r34.p = getelementptr inbounds [8 x i8], ptr @.str.9, i64 0, i64 0
  %r34 = ptrtoint ptr %r34.p to i64
  %r35 = load i64, ptr %slot.config, align 8
  %r36.p = getelementptr inbounds [5 x i8], ptr @.str.1, i64 0, i64 0
  %r36 = ptrtoint ptr %r36.p to i64
  %r37 = call i64 @nova_rt_index_get(i64 %r35, i64 %r36)
  %r38 = call i64 @nova_rt_any_to_str(i64 %r37)
  %r39 = call i64 @nova_rt_str_concat(i64 %r34, i64 %r38)
  %r40.p = getelementptr inbounds [1 x i8], ptr @.str.8, i64 0, i64 0
  %r40 = ptrtoint ptr %r40.p to i64
  %r41 = call i64 @nova_rt_str_concat(i64 %r39, i64 %r40)
  %r42 = call i64 @nova_rt_print_any(i64 %r41)
  %r43.p = getelementptr inbounds [5 x i8], ptr @.str.10, i64 0, i64 0
  %r43 = ptrtoint ptr %r43.p to i64
  %r44 = call i64 @nova_rt_print_any(i64 %r43)
  ret i64 %r44
}

define i64 @nova_main() nounwind {
entry:
  %r0 = call i64 @nova_user_main()
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
@.str.0 = private unnamed_addr constant [10 x i8] c"localhost\00"
@.str.1 = private unnamed_addr constant [5 x i8] c"host\00"
@.str.2 = private unnamed_addr constant [5 x i8] c"8080\00"
@.str.3 = private unnamed_addr constant [5 x i8] c"port\00"
@.str.4 = private unnamed_addr constant [5 x i8] c"NOVA\00"
@.str.5 = private unnamed_addr constant [7 x i8] c"Hello \00"
@.str.6 = private unnamed_addr constant [2 x i8] c"!\00"
@.str.7 = private unnamed_addr constant [9 x i8] c"2 + 3 = \00"
@.str.8 = private unnamed_addr constant [1 x i8] c"\00"
@.str.9 = private unnamed_addr constant [8 x i8] c"host = \00"
@.str.10 = private unnamed_addr constant [5 x i8] c"done\00"
