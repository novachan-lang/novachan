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
declare i64 @nova_rt_print_bool(i64) nounwind
declare i64 @nova_rt_float_bits(i64) nounwind
declare ptr @nova_rt_struct_alloc(i64) nounwind
declare i64 @nova_rt_slice(i64, i64, i64) nounwind
declare i64 @nova_rt_repeat(i64, i64) nounwind
declare i64 @nova_rt_chars(i64) nounwind
declare i64 @nova_rt_time_ms() nounwind
declare i64 @nova_rt_sleep_ms(i64) nounwind
declare i64 @nova_rt_clock_ns() nounwind
declare i64 @nova_rt_type_of(i64) nounwind
declare i64 @nova_rt_range(i64) nounwind
declare i64 @nova_rt_range_from_to(i64, i64) nounwind
declare i64 @nova_rt_dict_keys(i64) nounwind
declare i64 @nova_rt_dict_values(i64) nounwind
declare i64 @nova_rt_dict_items(i64) nounwind
declare i64 @nova_rt_dict_has(i64, i64) nounwind
declare i64 @nova_rt_dict_del(i64, i64) nounwind
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
declare i64 @nova_rt_http_get(i64) nounwind
declare i64 @nova_rt_http_post(i64, i64, i64) nounwind
declare i64 @nova_rt_mkdir(i64) nounwind
declare i64 @nova_rt_mkdir_p(i64) nounwind
declare i64 @nova_rt_path_join(i64, i64) nounwind
declare i64 @nova_rt_path_exists(i64) nounwind
declare i64 @nova_rt_path_parent(i64) nounwind
declare i64 @nova_rt_path_name(i64) nounwind
declare i64 @nova_rt_read_bytes(i64) nounwind
declare i64 @nova_rt_write_raw(i64) nounwind

define i64 @nova_main() nounwind {
entry:
  %slot.name = alloca i64, align 8
  store i64 0, ptr %slot.name, align 8
  %slot.x = alloca i64, align 8
  store i64 0, ptr %slot.x, align 8
  %slot.a = alloca i64, align 8
  store i64 0, ptr %slot.a, align 8
  %slot.b = alloca i64, align 8
  store i64 0, ptr %slot.b, align 8
  %slot.items = alloca i64, align 8
  store i64 0, ptr %slot.items, align 8
  %slot.prefix = alloca i64, align 8
  store i64 0, ptr %slot.prefix, align 8
  %slot.val = alloca i64, align 8
  store i64 0, ptr %slot.val, align 8
  %slot.parts = alloca i64, align 8
  store i64 0, ptr %slot.parts, align 8
  %slot.i = alloca i64, align 8
  store i64 0, ptr %slot.i, align 8
  %r0.p = getelementptr inbounds [6 x i8], ptr @.str.0, i64 0, i64 0
  %r0 = ptrtoint ptr %r0.p to i64
  store i64 %r0, ptr %slot.name, align 8
  %r1.p = getelementptr inbounds [7 x i8], ptr @.str.1, i64 0, i64 0
  %r1 = ptrtoint ptr %r1.p to i64
  %r2 = load i64, ptr %slot.name, align 8
  %r3 = call i64 @nova_rt_any_to_str(i64 %r2)
  %r4 = call i64 @nova_rt_str_concat(i64 %r1, i64 %r3)
  %r5.p = getelementptr inbounds [1 x i8], ptr @.str.2, i64 0, i64 0
  %r5 = ptrtoint ptr %r5.p to i64
  %r6 = call i64 @nova_rt_str_concat(i64 %r4, i64 %r5)
  %r7 = call i64 @nova_rt_print_any(i64 %r6)
  %r8 = add i64 42, 0
  store i64 %r8, ptr %slot.x, align 8
  %r9.p = getelementptr inbounds [10 x i8], ptr @.str.3, i64 0, i64 0
  %r9 = ptrtoint ptr %r9.p to i64
  %r10 = load i64, ptr %slot.x, align 8
  %r11 = call i64 @nova_rt_any_to_str(i64 %r10)
  %r12 = call i64 @nova_rt_str_concat(i64 %r9, i64 %r11)
  %r13.p = getelementptr inbounds [1 x i8], ptr @.str.2, i64 0, i64 0
  %r13 = ptrtoint ptr %r13.p to i64
  %r14 = call i64 @nova_rt_str_concat(i64 %r12, i64 %r13)
  %r15 = call i64 @nova_rt_print_any(i64 %r14)
  %r16 = add i64 10, 0
  store i64 %r16, ptr %slot.a, align 8
  %r17 = add i64 20, 0
  store i64 %r17, ptr %slot.b, align 8
  %r18.p = getelementptr inbounds [1 x i8], ptr @.str.2, i64 0, i64 0
  %r18 = ptrtoint ptr %r18.p to i64
  %r19 = load i64, ptr %slot.a, align 8
  %r20 = call i64 @nova_rt_any_to_str(i64 %r19)
  %r21 = call i64 @nova_rt_str_concat(i64 %r18, i64 %r20)
  %r22.p = getelementptr inbounds [4 x i8], ptr @.str.4, i64 0, i64 0
  %r22 = ptrtoint ptr %r22.p to i64
  %r23 = call i64 @nova_rt_str_concat(i64 %r21, i64 %r22)
  %r24 = load i64, ptr %slot.b, align 8
  %r25 = call i64 @nova_rt_any_to_str(i64 %r24)
  %r26 = call i64 @nova_rt_str_concat(i64 %r23, i64 %r25)
  %r27.p = getelementptr inbounds [4 x i8], ptr @.str.5, i64 0, i64 0
  %r27 = ptrtoint ptr %r27.p to i64
  %r28 = call i64 @nova_rt_str_concat(i64 %r26, i64 %r27)
  %r29 = load i64, ptr %slot.a, align 8
  %r30 = load i64, ptr %slot.b, align 8
  %r31 = add i64 %r29, %r30
  %r32 = call i64 @nova_rt_any_to_str(i64 %r31)
  %r33 = call i64 @nova_rt_str_concat(i64 %r28, i64 %r32)
  %r34.p = getelementptr inbounds [1 x i8], ptr @.str.2, i64 0, i64 0
  %r34 = ptrtoint ptr %r34.p to i64
  %r35 = call i64 @nova_rt_str_concat(i64 %r33, i64 %r34)
  %r36 = call i64 @nova_rt_print_any(i64 %r35)
  %r38 = add i64 1, 0
  %r39 = add i64 2, 0
  %r40 = add i64 3, 0
  %r37 = call i64 @nova_rt_list_create()
  call i64 @nova_rt_list_append(i64 %r37, i64 %r38)
  call i64 @nova_rt_list_append(i64 %r37, i64 %r39)
  call i64 @nova_rt_list_append(i64 %r37, i64 %r40)
  store i64 %r37, ptr %slot.items, align 8
  %r41.p = getelementptr inbounds [11 x i8], ptr @.str.6, i64 0, i64 0
  %r41 = ptrtoint ptr %r41.p to i64
  %r42 = load i64, ptr %slot.items, align 8
  %r43 = call i64 @nova_rt_len_any(i64 %r42)
  %r44 = call i64 @nova_rt_any_to_str(i64 %r43)
  %r45 = call i64 @nova_rt_str_concat(i64 %r41, i64 %r44)
  %r46.p = getelementptr inbounds [1 x i8], ptr @.str.2, i64 0, i64 0
  %r46 = ptrtoint ptr %r46.p to i64
  %r47 = call i64 @nova_rt_str_concat(i64 %r45, i64 %r46)
  %r48 = call i64 @nova_rt_print_any(i64 %r47)
  %r49.p = getelementptr inbounds [7 x i8], ptr @.str.7, i64 0, i64 0
  %r49 = ptrtoint ptr %r49.p to i64
  store i64 %r49, ptr %slot.prefix, align 8
  %r50 = add i64 99, 0
  store i64 %r50, ptr %slot.val, align 8
  %r51.p = getelementptr inbounds [1 x i8], ptr @.str.2, i64 0, i64 0
  %r51 = ptrtoint ptr %r51.p to i64
  %r52 = load i64, ptr %slot.prefix, align 8
  %r53 = call i64 @nova_rt_any_to_str(i64 %r52)
  %r54 = call i64 @nova_rt_str_concat(i64 %r51, i64 %r53)
  %r55.p = getelementptr inbounds [3 x i8], ptr @.str.8, i64 0, i64 0
  %r55 = ptrtoint ptr %r55.p to i64
  %r56 = call i64 @nova_rt_str_concat(i64 %r54, i64 %r55)
  %r57 = load i64, ptr %slot.val, align 8
  %r58 = call i64 @nova_rt_any_to_str(i64 %r57)
  %r59 = call i64 @nova_rt_str_concat(i64 %r56, i64 %r58)
  %r60.p = getelementptr inbounds [1 x i8], ptr @.str.2, i64 0, i64 0
  %r60 = ptrtoint ptr %r60.p to i64
  %r61 = call i64 @nova_rt_str_concat(i64 %r59, i64 %r60)
  %r62 = call i64 @nova_rt_print_any(i64 %r61)
  %r63.p = getelementptr inbounds [1 x i8], ptr @.str.2, i64 0, i64 0
  %r63 = ptrtoint ptr %r63.p to i64
  store i64 %r63, ptr %slot.parts, align 8
  %r64 = add i64 0, 0
  store i64 %r64, ptr %slot.i, align 8
  br label %while_hdr0
while_hdr0:
  %r65 = load i64, ptr %slot.i, align 8
  %r66 = add i64 3, 0
  %r67.cmp = icmp slt i64 %r65, %r66
  %r67 = zext i1 %r67.cmp to i64
  %br_while_body1 = icmp ne i64 %r67, 0
  br i1 %br_while_body1, label %while_body1, label %while_exit2
while_body1:
  %r68 = load i64, ptr %slot.parts, align 8
  %r69.p = getelementptr inbounds [2 x i8], ptr @.str.9, i64 0, i64 0
  %r69 = ptrtoint ptr %r69.p to i64
  %r70 = load i64, ptr %slot.i, align 8
  %r71 = call i64 @nova_rt_any_to_str(i64 %r70)
  %r72 = call i64 @nova_rt_str_concat(i64 %r69, i64 %r71)
  %r73.p = getelementptr inbounds [2 x i8], ptr @.str.10, i64 0, i64 0
  %r73 = ptrtoint ptr %r73.p to i64
  %r74 = call i64 @nova_rt_str_concat(i64 %r72, i64 %r73)
  %r75 = call i64 @nova_rt_str_concat(i64 %r68, i64 %r74)
  store i64 %r75, ptr %slot.parts, align 8
  %r76 = load i64, ptr %slot.i, align 8
  %r77 = add i64 1, 0
  %r78 = add i64 %r76, %r77
  store i64 %r78, ptr %slot.i, align 8
  br label %while_hdr0
while_exit2:
  %r79 = load i64, ptr %slot.parts, align 8
  %r80 = call i64 @nova_rt_print_any(i64 %r79)
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
@.str.0 = private unnamed_addr constant [6 x i8] c"world\00"
@.str.1 = private unnamed_addr constant [7 x i8] c"hello \00"
@.str.2 = private unnamed_addr constant [1 x i8] c"\00"
@.str.3 = private unnamed_addr constant [10 x i8] c"value is \00"
@.str.4 = private unnamed_addr constant [4 x i8] c" + \00"
@.str.5 = private unnamed_addr constant [4 x i8] c" = \00"
@.str.6 = private unnamed_addr constant [11 x i8] c"length is \00"
@.str.7 = private unnamed_addr constant [7 x i8] c"result\00"
@.str.8 = private unnamed_addr constant [3 x i8] c": \00"
@.str.9 = private unnamed_addr constant [2 x i8] c"r\00"
@.str.10 = private unnamed_addr constant [2 x i8] c" \00"
