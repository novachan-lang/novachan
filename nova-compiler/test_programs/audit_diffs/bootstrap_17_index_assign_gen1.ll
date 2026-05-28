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
  %slot.d = alloca i64, align 8
  store i64 0, ptr %slot.d, align 8
  %slot.items = alloca i64, align 8
  store i64 0, ptr %slot.items, align 8
  %slot.table = alloca i64, align 8
  store i64 0, ptr %slot.table, align 8
  %slot.i = alloca i64, align 8
  store i64 0, ptr %slot.i, align 8
  %slot.outer = alloca i64, align 8
  store i64 0, ptr %slot.outer, align 8
  %slot.inner = alloca i64, align 8
  store i64 0, ptr %slot.inner, align 8
  %r0 = call i64 @nova_rt_dict_create()
  store i64 %r0, ptr %slot.d, align 8
  %r1 = add i64 10, 0
  %r2 = load i64, ptr %slot.d, align 8
  %r3.p = getelementptr inbounds [2 x i8], ptr @.str.0, i64 0, i64 0
  %r3 = ptrtoint ptr %r3.p to i64
  call i64 @nova_rt_index_set(i64 %r2, i64 %r3, i64 %r1)
  %r4 = add i64 20, 0
  %r5 = load i64, ptr %slot.d, align 8
  %r6.p = getelementptr inbounds [2 x i8], ptr @.str.1, i64 0, i64 0
  %r6 = ptrtoint ptr %r6.p to i64
  call i64 @nova_rt_index_set(i64 %r5, i64 %r6, i64 %r4)
  %r7 = add i64 30, 0
  %r8 = load i64, ptr %slot.d, align 8
  %r9.p = getelementptr inbounds [2 x i8], ptr @.str.2, i64 0, i64 0
  %r9 = ptrtoint ptr %r9.p to i64
  call i64 @nova_rt_index_set(i64 %r8, i64 %r9, i64 %r7)
  %r10 = load i64, ptr %slot.d, align 8
  %r11.p = getelementptr inbounds [2 x i8], ptr @.str.0, i64 0, i64 0
  %r11 = ptrtoint ptr %r11.p to i64
  %r12 = call i64 @nova_rt_index_get(i64 %r10, i64 %r11)
  %r13 = call i64 @nova_rt_print_any(i64 %r12)
  %r14 = load i64, ptr %slot.d, align 8
  %r15.p = getelementptr inbounds [2 x i8], ptr @.str.1, i64 0, i64 0
  %r15 = ptrtoint ptr %r15.p to i64
  %r16 = call i64 @nova_rt_index_get(i64 %r14, i64 %r15)
  %r17 = call i64 @nova_rt_print_any(i64 %r16)
  %r18 = load i64, ptr %slot.d, align 8
  %r19.p = getelementptr inbounds [2 x i8], ptr @.str.2, i64 0, i64 0
  %r19 = ptrtoint ptr %r19.p to i64
  %r20 = call i64 @nova_rt_index_get(i64 %r18, i64 %r19)
  %r21 = call i64 @nova_rt_print_any(i64 %r20)
  %r22 = add i64 99, 0
  %r23 = load i64, ptr %slot.d, align 8
  %r24.p = getelementptr inbounds [2 x i8], ptr @.str.0, i64 0, i64 0
  %r24 = ptrtoint ptr %r24.p to i64
  call i64 @nova_rt_index_set(i64 %r23, i64 %r24, i64 %r22)
  %r25 = load i64, ptr %slot.d, align 8
  %r26.p = getelementptr inbounds [2 x i8], ptr @.str.0, i64 0, i64 0
  %r26 = ptrtoint ptr %r26.p to i64
  %r27 = call i64 @nova_rt_index_get(i64 %r25, i64 %r26)
  %r28 = call i64 @nova_rt_print_any(i64 %r27)
  %r30 = add i64 0, 0
  %r31 = add i64 0, 0
  %r32 = add i64 0, 0
  %r33 = add i64 0, 0
  %r34 = add i64 0, 0
  %r29 = call i64 @nova_rt_list_create()
  call i64 @nova_rt_list_append(i64 %r29, i64 %r30)
  call i64 @nova_rt_list_append(i64 %r29, i64 %r31)
  call i64 @nova_rt_list_append(i64 %r29, i64 %r32)
  call i64 @nova_rt_list_append(i64 %r29, i64 %r33)
  call i64 @nova_rt_list_append(i64 %r29, i64 %r34)
  store i64 %r29, ptr %slot.items, align 8
  %r35 = add i64 10, 0
  %r36 = load i64, ptr %slot.items, align 8
  %r37 = add i64 0, 0
  call i64 @nova_rt_index_set(i64 %r36, i64 %r37, i64 %r35)
  %r38 = add i64 30, 0
  %r39 = load i64, ptr %slot.items, align 8
  %r40 = add i64 2, 0
  call i64 @nova_rt_index_set(i64 %r39, i64 %r40, i64 %r38)
  %r41 = add i64 50, 0
  %r42 = load i64, ptr %slot.items, align 8
  %r43 = add i64 4, 0
  call i64 @nova_rt_index_set(i64 %r42, i64 %r43, i64 %r41)
  %r44 = load i64, ptr %slot.items, align 8
  %r45 = add i64 0, 0
  %r46 = call i64 @nova_rt_index_get(i64 %r44, i64 %r45)
  %r47 = call i64 @nova_rt_print_any(i64 %r46)
  %r48 = load i64, ptr %slot.items, align 8
  %r49 = add i64 2, 0
  %r50 = call i64 @nova_rt_index_get(i64 %r48, i64 %r49)
  %r51 = call i64 @nova_rt_print_any(i64 %r50)
  %r52 = load i64, ptr %slot.items, align 8
  %r53 = add i64 4, 0
  %r54 = call i64 @nova_rt_index_get(i64 %r52, i64 %r53)
  %r55 = call i64 @nova_rt_print_any(i64 %r54)
  %r56 = call i64 @nova_rt_dict_create()
  store i64 %r56, ptr %slot.table, align 8
  %r57 = add i64 0, 0
  store i64 %r57, ptr %slot.i, align 8
  br label %while_hdr0
while_hdr0:
  %r58 = load i64, ptr %slot.i, align 8
  %r59 = add i64 5, 0
  %r60.cmp = icmp slt i64 %r58, %r59
  %r60 = zext i1 %r60.cmp to i64
  %br_while_body1 = icmp ne i64 %r60, 0
  br i1 %br_while_body1, label %while_body1, label %while_exit2
while_body1:
  %r61 = load i64, ptr %slot.i, align 8
  %r62 = load i64, ptr %slot.i, align 8
  %r63 = mul i64 %r61, %r62
  %r64 = load i64, ptr %slot.table, align 8
  %r65 = load i64, ptr %slot.i, align 8
  %r66 = call i64 @nova_rt_int_to_str(i64 %r65)
  call i64 @nova_rt_index_set(i64 %r64, i64 %r66, i64 %r63)
  %r67 = load i64, ptr %slot.i, align 8
  %r68 = add i64 1, 0
  %r69 = add i64 %r67, %r68
  store i64 %r69, ptr %slot.i, align 8
  br label %while_hdr0
while_exit2:
  %r70 = load i64, ptr %slot.table, align 8
  %r71.p = getelementptr inbounds [2 x i8], ptr @.str.3, i64 0, i64 0
  %r71 = ptrtoint ptr %r71.p to i64
  %r72 = call i64 @nova_rt_index_get(i64 %r70, i64 %r71)
  %r73 = call i64 @nova_rt_print_any(i64 %r72)
  %r74 = load i64, ptr %slot.table, align 8
  %r75.p = getelementptr inbounds [2 x i8], ptr @.str.4, i64 0, i64 0
  %r75 = ptrtoint ptr %r75.p to i64
  %r76 = call i64 @nova_rt_index_get(i64 %r74, i64 %r75)
  %r77 = call i64 @nova_rt_print_any(i64 %r76)
  %r78 = call i64 @nova_rt_dict_create()
  store i64 %r78, ptr %slot.outer, align 8
  %r79 = call i64 @nova_rt_dict_create()
  %r80 = load i64, ptr %slot.outer, align 8
  %r81.p = getelementptr inbounds [2 x i8], ptr @.str.5, i64 0, i64 0
  %r81 = ptrtoint ptr %r81.p to i64
  call i64 @nova_rt_index_set(i64 %r80, i64 %r81, i64 %r79)
  %r82 = load i64, ptr %slot.outer, align 8
  %r83.p = getelementptr inbounds [2 x i8], ptr @.str.5, i64 0, i64 0
  %r83 = ptrtoint ptr %r83.p to i64
  %r84 = call i64 @nova_rt_index_get(i64 %r82, i64 %r83)
  store i64 %r84, ptr %slot.inner, align 8
  %r85 = add i64 42, 0
  %r86 = load i64, ptr %slot.inner, align 8
  %r87.p = getelementptr inbounds [4 x i8], ptr @.str.6, i64 0, i64 0
  %r87 = ptrtoint ptr %r87.p to i64
  call i64 @nova_rt_index_set(i64 %r86, i64 %r87, i64 %r85)
  %r88 = load i64, ptr %slot.inner, align 8
  %r89.p = getelementptr inbounds [4 x i8], ptr @.str.6, i64 0, i64 0
  %r89 = ptrtoint ptr %r89.p to i64
  %r90 = call i64 @nova_rt_index_get(i64 %r88, i64 %r89)
  %r91 = call i64 @nova_rt_print_any(i64 %r90)
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
@.str.0 = private unnamed_addr constant [2 x i8] c"x\00"
@.str.1 = private unnamed_addr constant [2 x i8] c"y\00"
@.str.2 = private unnamed_addr constant [2 x i8] c"z\00"
@.str.3 = private unnamed_addr constant [2 x i8] c"3\00"
@.str.4 = private unnamed_addr constant [2 x i8] c"4\00"
@.str.5 = private unnamed_addr constant [2 x i8] c"a\00"
@.str.6 = private unnamed_addr constant [4 x i8] c"val\00"
