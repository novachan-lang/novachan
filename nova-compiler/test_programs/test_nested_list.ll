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
  %slot.matrix = alloca i64, align 8
  store i64 0, ptr %slot.matrix, align 8
  %slot.nested = alloca i64, align 8
  store i64 0, ptr %slot.nested, align 8
  %slot.sum = alloca i64, align 8
  store i64 0, ptr %slot.sum, align 8
  %r0.p = getelementptr inbounds [25 x i8], ptr @.str.0, i64 0, i64 0
  %r0 = ptrtoint ptr %r0.p to i64
  %r1 = call i64 @nova_rt_print_any(i64 %r0)
  %r4 = add i64 1, 0
  %r5 = add i64 2, 0
  %r6 = add i64 3, 0
  %r3 = call i64 @nova_rt_list_create()
  call i64 @nova_rt_list_append(i64 %r3, i64 %r4)
  call i64 @nova_rt_list_append(i64 %r3, i64 %r5)
  call i64 @nova_rt_list_append(i64 %r3, i64 %r6)
  %r8 = add i64 4, 0
  %r9 = add i64 5, 0
  %r10 = add i64 6, 0
  %r7 = call i64 @nova_rt_list_create()
  call i64 @nova_rt_list_append(i64 %r7, i64 %r8)
  call i64 @nova_rt_list_append(i64 %r7, i64 %r9)
  call i64 @nova_rt_list_append(i64 %r7, i64 %r10)
  %r12 = add i64 7, 0
  %r13 = add i64 8, 0
  %r14 = add i64 9, 0
  %r11 = call i64 @nova_rt_list_create()
  call i64 @nova_rt_list_append(i64 %r11, i64 %r12)
  call i64 @nova_rt_list_append(i64 %r11, i64 %r13)
  call i64 @nova_rt_list_append(i64 %r11, i64 %r14)
  %r2 = call i64 @nova_rt_list_create()
  call i64 @nova_rt_list_append(i64 %r2, i64 %r3)
  call i64 @nova_rt_list_append(i64 %r2, i64 %r7)
  call i64 @nova_rt_list_append(i64 %r2, i64 %r11)
  store i64 %r2, ptr %slot.matrix, align 8
  %r15 = load i64, ptr %slot.matrix, align 8
  %r16 = call i64 @nova_rt_print_any(i64 %r15)
  %r17 = load i64, ptr %slot.matrix, align 8
  %r18 = add i64 0, 0
  %r19 = call i64 @nova_rt_index_get(i64 %r17, i64 %r18)
  %r20 = call i64 @nova_rt_print_any(i64 %r19)
  %r21 = load i64, ptr %slot.matrix, align 8
  %r22 = add i64 1, 0
  %r23 = call i64 @nova_rt_index_get(i64 %r21, i64 %r22)
  %r24 = call i64 @nova_rt_print_any(i64 %r23)
  %r25 = load i64, ptr %slot.matrix, align 8
  %r26 = add i64 2, 0
  %r27 = call i64 @nova_rt_index_get(i64 %r25, i64 %r26)
  %r28 = call i64 @nova_rt_print_any(i64 %r27)
  %r29 = load i64, ptr %slot.matrix, align 8
  %r30 = add i64 1, 0
  %r31 = call i64 @nova_rt_index_get(i64 %r29, i64 %r30)
  %r32 = add i64 2, 0
  %r33 = call i64 @nova_rt_index_get(i64 %r31, i64 %r32)
  %r34 = call i64 @nova_rt_print_any(i64 %r33)
  %r37 = add i64 10, 0
  %r38 = add i64 20, 0
  %r36 = call i64 @nova_rt_list_create()
  call i64 @nova_rt_list_append(i64 %r36, i64 %r37)
  call i64 @nova_rt_list_append(i64 %r36, i64 %r38)
  %r40 = add i64 30, 0
  %r41 = add i64 40, 0
  %r39 = call i64 @nova_rt_list_create()
  call i64 @nova_rt_list_append(i64 %r39, i64 %r40)
  call i64 @nova_rt_list_append(i64 %r39, i64 %r41)
  %r35 = call i64 @nova_rt_list_create()
  call i64 @nova_rt_list_append(i64 %r35, i64 %r36)
  call i64 @nova_rt_list_append(i64 %r35, i64 %r39)
  store i64 %r35, ptr %slot.nested, align 8
  %r42 = load i64, ptr %slot.nested, align 8
  %r43 = add i64 0, 0
  %r44 = call i64 @nova_rt_index_get(i64 %r42, i64 %r43)
  %r45 = add i64 0, 0
  %r46 = call i64 @nova_rt_index_get(i64 %r44, i64 %r45)
  %r47 = load i64, ptr %slot.nested, align 8
  %r48 = add i64 0, 0
  %r49 = call i64 @nova_rt_index_get(i64 %r47, i64 %r48)
  %r50 = add i64 1, 0
  %r51 = call i64 @nova_rt_index_get(i64 %r49, i64 %r50)
  %r52 = call i64 @nova_rt_add(i64 %r46, i64 %r51)
  %r53 = load i64, ptr %slot.nested, align 8
  %r54 = add i64 1, 0
  %r55 = call i64 @nova_rt_index_get(i64 %r53, i64 %r54)
  %r56 = add i64 0, 0
  %r57 = call i64 @nova_rt_index_get(i64 %r55, i64 %r56)
  %r58 = call i64 @nova_rt_add(i64 %r52, i64 %r57)
  %r59 = load i64, ptr %slot.nested, align 8
  %r60 = add i64 1, 0
  %r61 = call i64 @nova_rt_index_get(i64 %r59, i64 %r60)
  %r62 = add i64 1, 0
  %r63 = call i64 @nova_rt_index_get(i64 %r61, i64 %r62)
  %r64 = call i64 @nova_rt_add(i64 %r58, i64 %r63)
  store i64 %r64, ptr %slot.sum, align 8
  %r65 = load i64, ptr %slot.sum, align 8
  %r66 = call i64 @nova_rt_print_any(i64 %r65)
  %r67.p = getelementptr inbounds [13 x i8], ptr @.str.1, i64 0, i64 0
  %r67 = ptrtoint ptr %r67.p to i64
  %r68 = call i64 @nova_rt_print_any(i64 %r67)
  ret i64 %r68
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
@.str.0 = private unnamed_addr constant [25 x i8] c"=== nested list test ===\00"
@.str.1 = private unnamed_addr constant [13 x i8] c"=== done ===\00"
