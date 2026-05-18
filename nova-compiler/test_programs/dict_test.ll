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

define i64 @nova_main() nounwind {
entry:
  %slot.d = alloca i64, align 8
  store i64 0, ptr %slot.d, align 8
  %slot.freq = alloca i64, align 8
  store i64 0, ptr %slot.freq, align 8
  %slot.__for_idx_0 = alloca i64, align 8
  store i64 0, ptr %slot.__for_idx_0, align 8
  %slot.k = alloca i64, align 8
  store i64 0, ptr %slot.k, align 8
  %r0 = call i64 @nova_rt_dict_create()
  %r1.p = getelementptr inbounds [6 x i8], ptr @.str.0, i64 0, i64 0
  %r1 = ptrtoint ptr %r1.p to i64
  %r2 = add i64 5, 0
  call i64 @nova_rt_dict_set(i64 %r0, i64 %r1, i64 %r2)
  %r3.p = getelementptr inbounds [7 x i8], ptr @.str.1, i64 0, i64 0
  %r3 = ptrtoint ptr %r3.p to i64
  %r4 = add i64 3, 0
  call i64 @nova_rt_dict_set(i64 %r0, i64 %r3, i64 %r4)
  %r5.p = getelementptr inbounds [7 x i8], ptr @.str.2, i64 0, i64 0
  %r5 = ptrtoint ptr %r5.p to i64
  %r6 = add i64 8, 0
  call i64 @nova_rt_dict_set(i64 %r0, i64 %r5, i64 %r6)
  store i64 %r0, ptr %slot.d, align 8
  %r7 = load i64, ptr %slot.d, align 8
  %r8.p = getelementptr inbounds [6 x i8], ptr @.str.0, i64 0, i64 0
  %r8 = ptrtoint ptr %r8.p to i64
  %r9 = call i64 @nova_rt_index_get(i64 %r7, i64 %r8)
  %r10 = call i64 @nova_rt_print_any(i64 %r9)
  %r11 = load i64, ptr %slot.d, align 8
  %r12.p = getelementptr inbounds [7 x i8], ptr @.str.1, i64 0, i64 0
  %r12 = ptrtoint ptr %r12.p to i64
  %r13 = call i64 @nova_rt_index_get(i64 %r11, i64 %r12)
  %r14 = call i64 @nova_rt_print_any(i64 %r13)
  %r15 = add i64 10, 0
  %r16 = load i64, ptr %slot.d, align 8
  %r17.p = getelementptr inbounds [6 x i8], ptr @.str.0, i64 0, i64 0
  %r17 = ptrtoint ptr %r17.p to i64
  call i64 @nova_rt_index_set(i64 %r16, i64 %r17, i64 %r15)
  %r18 = load i64, ptr %slot.d, align 8
  %r19.p = getelementptr inbounds [6 x i8], ptr @.str.0, i64 0, i64 0
  %r19 = ptrtoint ptr %r19.p to i64
  %r20 = call i64 @nova_rt_index_get(i64 %r18, i64 %r19)
  %r21 = call i64 @nova_rt_print_any(i64 %r20)
  %r22 = load i64, ptr %slot.d, align 8
  %r23.p = getelementptr inbounds [7 x i8], ptr @.str.2, i64 0, i64 0
  %r23 = ptrtoint ptr %r23.p to i64
  %r24 = call i64 @nova_rt_has(i64 %r22, i64 %r23)
  %r25 = call i64 @nova_rt_print_any(i64 %r24)
  %r26 = load i64, ptr %slot.d, align 8
  %r27.p = getelementptr inbounds [6 x i8], ptr @.str.3, i64 0, i64 0
  %r27 = ptrtoint ptr %r27.p to i64
  %r28 = call i64 @nova_rt_has(i64 %r26, i64 %r27)
  %r29 = call i64 @nova_rt_print_any(i64 %r28)
  %r30 = load i64, ptr %slot.d, align 8
  %r31 = call i64 @nova_rt_len(i64 %r30)
  %r32 = call i64 @nova_rt_print_any(i64 %r31)
  %r33 = add i64 7, 0
  %r34 = load i64, ptr %slot.d, align 8
  %r35.p = getelementptr inbounds [6 x i8], ptr @.str.3, i64 0, i64 0
  %r35 = ptrtoint ptr %r35.p to i64
  call i64 @nova_rt_index_set(i64 %r34, i64 %r35, i64 %r33)
  %r36 = load i64, ptr %slot.d, align 8
  %r37 = call i64 @nova_rt_len(i64 %r36)
  %r38 = call i64 @nova_rt_print_any(i64 %r37)
  %r39 = load i64, ptr %slot.d, align 8
  %r40.p = getelementptr inbounds [7 x i8], ptr @.str.1, i64 0, i64 0
  %r40 = ptrtoint ptr %r40.p to i64
  %r41 = call i64 @nova_rt_del(i64 %r39, i64 %r40)
  %r42 = load i64, ptr %slot.d, align 8
  %r43 = call i64 @nova_rt_len(i64 %r42)
  %r44 = call i64 @nova_rt_print_any(i64 %r43)
  %r45 = load i64, ptr %slot.d, align 8
  %r46.p = getelementptr inbounds [7 x i8], ptr @.str.1, i64 0, i64 0
  %r46 = ptrtoint ptr %r46.p to i64
  %r47 = call i64 @nova_rt_has(i64 %r45, i64 %r46)
  %r48 = call i64 @nova_rt_print_any(i64 %r47)
  %r49 = call i64 @nova_rt_dict_create()
  store i64 %r49, ptr %slot.freq, align 8
  %r50 = add i64 1, 0
  %r51 = load i64, ptr %slot.freq, align 8
  %r52.p = getelementptr inbounds [2 x i8], ptr @.str.4, i64 0, i64 0
  %r52 = ptrtoint ptr %r52.p to i64
  call i64 @nova_rt_index_set(i64 %r51, i64 %r52, i64 %r50)
  %r53 = add i64 2, 0
  %r54 = load i64, ptr %slot.freq, align 8
  %r55.p = getelementptr inbounds [2 x i8], ptr @.str.5, i64 0, i64 0
  %r55 = ptrtoint ptr %r55.p to i64
  call i64 @nova_rt_index_set(i64 %r54, i64 %r55, i64 %r53)
  %r56 = add i64 3, 0
  %r57 = load i64, ptr %slot.freq, align 8
  %r58.p = getelementptr inbounds [2 x i8], ptr @.str.6, i64 0, i64 0
  %r58 = ptrtoint ptr %r58.p to i64
  call i64 @nova_rt_index_set(i64 %r57, i64 %r58, i64 %r56)
  %r59 = load i64, ptr %slot.freq, align 8
  %r60 = call i64 @nova_rt_keys(i64 %r59)
  %r61 = call i64 @nova_rt_len_any(i64 %r60)
  %r62 = add i64 0, 0
  store i64 %r62, ptr %slot.__for_idx_0, align 8
  br label %for_hdr0
for_hdr0:
  %r63 = load i64, ptr %slot.__for_idx_0, align 8
  %r64.cmp = icmp slt i64 %r63, %r61
  %r64 = zext i1 %r64.cmp to i64
  %br_for_body1 = icmp ne i64 %r64, 0
  br i1 %br_for_body1, label %for_body1, label %for_exit2
for_body1:
  %r65 = call i64 @nova_rt_index_get(i64 %r60, i64 %r63)
  store i64 %r65, ptr %slot.k, align 8
  %r66 = load i64, ptr %slot.k, align 8
  %r67 = call i64 @nova_rt_print_any(i64 %r66)
  %r68 = load i64, ptr %slot.__for_idx_0, align 8
  %r69 = add i64 1, 0
  %r70 = call i64 @nova_rt_add(i64 %r68, i64 %r69)
  store i64 %r70, ptr %slot.__for_idx_0, align 8
  br label %for_hdr0
for_exit2:
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
@.str.0 = private unnamed_addr constant [6 x i8] c"apple\00"
@.str.1 = private unnamed_addr constant [7 x i8] c"banana\00"
@.str.2 = private unnamed_addr constant [7 x i8] c"cherry\00"
@.str.3 = private unnamed_addr constant [6 x i8] c"grape\00"
@.str.4 = private unnamed_addr constant [2 x i8] c"a\00"
@.str.5 = private unnamed_addr constant [2 x i8] c"b\00"
@.str.6 = private unnamed_addr constant [2 x i8] c"c\00"
