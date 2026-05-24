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
declare void @nova_rt_wait_all() nounwind
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

define i64 @nt_var(i64 %p0) nounwind {
entry:
  %slot.vid = alloca i64, align 8
  store i64 %p0, ptr %slot.vid, align 8
  %r0.p = getelementptr inbounds [4 x i8], ptr @.str.0, i64 0, i64 0
  %r0 = ptrtoint ptr %r0.p to i64
  %r1.p = getelementptr inbounds [1 x i8], ptr @.str.1, i64 0, i64 0
  %r1 = ptrtoint ptr %r1.p to i64
  %r2 = call i64 @nova_rt_list_create()
  %r3 = load i64, ptr %slot.vid, align 8
  %r4.ptr = call ptr @nova_rt_struct_alloc(i64 40)
  %r4.thash = getelementptr i64, ptr %r4.ptr, i64 0
  store i64 210683205845, ptr %r4.thash, align 8
  %r4.f0 = getelementptr i64, ptr %r4.ptr, i64 1
  store i64 %r0, ptr %r4.f0, align 8
  %r4.f1 = getelementptr i64, ptr %r4.ptr, i64 2
  store i64 %r1, ptr %r4.f1, align 8
  %r4.f2 = getelementptr i64, ptr %r4.ptr, i64 3
  store i64 %r2, ptr %r4.f2, align 8
  %r4.f3 = getelementptr i64, ptr %r4.ptr, i64 4
  store i64 %r3, ptr %r4.f3, align 8
  %r4 = ptrtoint ptr %r4.ptr to i64
  ret i64 %r4
}

define i64 @nt_unit() nounwind {
entry:
  %r0.p = getelementptr inbounds [5 x i8], ptr @.str.2, i64 0, i64 0
  %r0 = ptrtoint ptr %r0.p to i64
  %r1.p = getelementptr inbounds [1 x i8], ptr @.str.1, i64 0, i64 0
  %r1 = ptrtoint ptr %r1.p to i64
  %r2 = call i64 @nova_rt_list_create()
  %r3 = add i64 0, 0
  %r4.ptr = call ptr @nova_rt_struct_alloc(i64 40)
  %r4.thash = getelementptr i64, ptr %r4.ptr, i64 0
  store i64 210683205845, ptr %r4.thash, align 8
  %r4.f0 = getelementptr i64, ptr %r4.ptr, i64 1
  store i64 %r0, ptr %r4.f0, align 8
  %r4.f1 = getelementptr i64, ptr %r4.ptr, i64 2
  store i64 %r1, ptr %r4.f1, align 8
  %r4.f2 = getelementptr i64, ptr %r4.ptr, i64 3
  store i64 %r2, ptr %r4.f2, align 8
  %r4.f3 = getelementptr i64, ptr %r4.ptr, i64 4
  store i64 %r3, ptr %r4.f3, align 8
  %r4 = ptrtoint ptr %r4.ptr to i64
  ret i64 %r4
}

define i64 @nt_int() nounwind {
entry:
  %r0.p = getelementptr inbounds [4 x i8], ptr @.str.3, i64 0, i64 0
  %r0 = ptrtoint ptr %r0.p to i64
  %r1.p = getelementptr inbounds [1 x i8], ptr @.str.1, i64 0, i64 0
  %r1 = ptrtoint ptr %r1.p to i64
  %r2 = call i64 @nova_rt_list_create()
  %r3 = add i64 0, 0
  %r4.ptr = call ptr @nova_rt_struct_alloc(i64 40)
  %r4.thash = getelementptr i64, ptr %r4.ptr, i64 0
  store i64 210683205845, ptr %r4.thash, align 8
  %r4.f0 = getelementptr i64, ptr %r4.ptr, i64 1
  store i64 %r0, ptr %r4.f0, align 8
  %r4.f1 = getelementptr i64, ptr %r4.ptr, i64 2
  store i64 %r1, ptr %r4.f1, align 8
  %r4.f2 = getelementptr i64, ptr %r4.ptr, i64 3
  store i64 %r2, ptr %r4.f2, align 8
  %r4.f3 = getelementptr i64, ptr %r4.ptr, i64 4
  store i64 %r3, ptr %r4.f3, align 8
  %r4 = ptrtoint ptr %r4.ptr to i64
  ret i64 %r4
}

define i64 @nova_user_main() nounwind {
entry:
  %slot.t1 = alloca i64, align 8
  store i64 0, ptr %slot.t1, align 8
  %slot.k = alloca i64, align 8
  store i64 0, ptr %slot.k, align 8
  %slot.n = alloca i64, align 8
  store i64 0, ptr %slot.n, align 8
  %slot.p = alloca i64, align 8
  store i64 0, ptr %slot.p, align 8
  %slot.i = alloca i64, align 8
  store i64 0, ptr %slot.i, align 8
  %slot.t2 = alloca i64, align 8
  store i64 0, ptr %slot.t2, align 8
  %slot.t3 = alloca i64, align 8
  store i64 0, ptr %slot.t3, align 8
  %slot.t4 = alloca i64, align 8
  store i64 0, ptr %slot.t4, align 8
  %slot.t5 = alloca i64, align 8
  store i64 0, ptr %slot.t5, align 8
  %r0 = call i64 @nt_unit()
  store i64 %r0, ptr %slot.t1, align 8
  %r1 = load i64, ptr %slot.t1, align 8
  %r2.ptr = inttoptr i64 %r1 to ptr
  %r2.gep = getelementptr i64, ptr %r2.ptr, i64 0
  %r2 = load i64, ptr %r2.gep, align 8
  %r3 = add i64 210683205845, 0
  %r4.cmp = icmp eq i64 %r2, %r3
  %r4 = zext i1 %r4.cmp to i64
  %br_marm_01 = icmp ne i64 %r4, 0
  br i1 %br_marm_01, label %marm_01, label %match_fall2
marm_01:
  %r5.ptr = inttoptr i64 %r1 to ptr
  %r5.gep = getelementptr i64, ptr %r5.ptr, i64 1
  %r5 = load i64, ptr %r5.gep, align 8
  store i64 %r5, ptr %slot.k, align 8
  %r6.ptr = inttoptr i64 %r1 to ptr
  %r6.gep = getelementptr i64, ptr %r6.ptr, i64 2
  %r6 = load i64, ptr %r6.gep, align 8
  store i64 %r6, ptr %slot.n, align 8
  %r7.ptr = inttoptr i64 %r1 to ptr
  %r7.gep = getelementptr i64, ptr %r7.ptr, i64 3
  %r7 = load i64, ptr %r7.gep, align 8
  store i64 %r7, ptr %slot.p, align 8
  %r8.ptr = inttoptr i64 %r1 to ptr
  %r8.gep = getelementptr i64, ptr %r8.ptr, i64 4
  %r8 = load i64, ptr %r8.gep, align 8
  store i64 %r8, ptr %slot.i, align 8
  %r9.p = getelementptr inbounds [9 x i8], ptr @.str.4, i64 0, i64 0
  %r9 = ptrtoint ptr %r9.p to i64
  %r10 = load i64, ptr %slot.k, align 8
  %r11 = call i64 @nova_rt_str_concat(i64 %r9, i64 %r10)
  %r12.p = getelementptr inbounds [5 x i8], ptr @.str.5, i64 0, i64 0
  %r12 = ptrtoint ptr %r12.p to i64
  %r13 = call i64 @nova_rt_str_concat(i64 %r11, i64 %r12)
  %r14 = load i64, ptr %slot.i, align 8
  %r15 = call i64 @nova_rt_int_to_str(i64 %r14)
  %r16 = call i64 @nova_rt_str_concat(i64 %r13, i64 %r15)
  %r17 = call i64 @nova_rt_print_any(i64 %r16)
  br label %match_exit0
match_fall2:
  br label %match_exit0
match_exit0:
  %r18 = call i64 @nt_int()
  store i64 %r18, ptr %slot.t2, align 8
  %r19 = load i64, ptr %slot.t2, align 8
  %r20.ptr = inttoptr i64 %r19 to ptr
  %r20.gep = getelementptr i64, ptr %r20.ptr, i64 0
  %r20 = load i64, ptr %r20.gep, align 8
  %r21 = add i64 210683205845, 0
  %r22.cmp = icmp eq i64 %r20, %r21
  %r22 = zext i1 %r22.cmp to i64
  %br_marm_04 = icmp ne i64 %r22, 0
  br i1 %br_marm_04, label %marm_04, label %match_fall5
marm_04:
  %r23.ptr = inttoptr i64 %r19 to ptr
  %r23.gep = getelementptr i64, ptr %r23.ptr, i64 1
  %r23 = load i64, ptr %r23.gep, align 8
  store i64 %r23, ptr %slot.k, align 8
  %r24.ptr = inttoptr i64 %r19 to ptr
  %r24.gep = getelementptr i64, ptr %r24.ptr, i64 2
  %r24 = load i64, ptr %r24.gep, align 8
  store i64 %r24, ptr %slot.n, align 8
  %r25.ptr = inttoptr i64 %r19 to ptr
  %r25.gep = getelementptr i64, ptr %r25.ptr, i64 3
  %r25 = load i64, ptr %r25.gep, align 8
  store i64 %r25, ptr %slot.p, align 8
  %r26.ptr = inttoptr i64 %r19 to ptr
  %r26.gep = getelementptr i64, ptr %r26.ptr, i64 4
  %r26 = load i64, ptr %r26.gep, align 8
  store i64 %r26, ptr %slot.i, align 8
  %r27.p = getelementptr inbounds [9 x i8], ptr @.str.6, i64 0, i64 0
  %r27 = ptrtoint ptr %r27.p to i64
  %r28 = load i64, ptr %slot.k, align 8
  %r29 = call i64 @nova_rt_str_concat(i64 %r27, i64 %r28)
  %r30.p = getelementptr inbounds [5 x i8], ptr @.str.5, i64 0, i64 0
  %r30 = ptrtoint ptr %r30.p to i64
  %r31 = call i64 @nova_rt_str_concat(i64 %r29, i64 %r30)
  %r32 = load i64, ptr %slot.i, align 8
  %r33 = call i64 @nova_rt_int_to_str(i64 %r32)
  %r34 = call i64 @nova_rt_str_concat(i64 %r31, i64 %r33)
  %r35 = call i64 @nova_rt_print_any(i64 %r34)
  br label %match_exit3
match_fall5:
  br label %match_exit3
match_exit3:
  %r36 = add i64 1, 0
  %r37 = sub i64 0, %r36
  %r38 = call i64 @nt_var(i64 %r37)
  store i64 %r38, ptr %slot.t3, align 8
  %r39 = load i64, ptr %slot.t3, align 8
  %r40.ptr = inttoptr i64 %r39 to ptr
  %r40.gep = getelementptr i64, ptr %r40.ptr, i64 0
  %r40 = load i64, ptr %r40.gep, align 8
  %r41 = add i64 210683205845, 0
  %r42.cmp = icmp eq i64 %r40, %r41
  %r42 = zext i1 %r42.cmp to i64
  %br_marm_07 = icmp ne i64 %r42, 0
  br i1 %br_marm_07, label %marm_07, label %match_fall8
marm_07:
  %r43.ptr = inttoptr i64 %r39 to ptr
  %r43.gep = getelementptr i64, ptr %r43.ptr, i64 1
  %r43 = load i64, ptr %r43.gep, align 8
  store i64 %r43, ptr %slot.k, align 8
  %r44.ptr = inttoptr i64 %r39 to ptr
  %r44.gep = getelementptr i64, ptr %r44.ptr, i64 2
  %r44 = load i64, ptr %r44.gep, align 8
  store i64 %r44, ptr %slot.n, align 8
  %r45.ptr = inttoptr i64 %r39 to ptr
  %r45.gep = getelementptr i64, ptr %r45.ptr, i64 3
  %r45 = load i64, ptr %r45.gep, align 8
  store i64 %r45, ptr %slot.p, align 8
  %r46.ptr = inttoptr i64 %r39 to ptr
  %r46.gep = getelementptr i64, ptr %r46.ptr, i64 4
  %r46 = load i64, ptr %r46.gep, align 8
  store i64 %r46, ptr %slot.i, align 8
  %r47.p = getelementptr inbounds [9 x i8], ptr @.str.7, i64 0, i64 0
  %r47 = ptrtoint ptr %r47.p to i64
  %r48 = load i64, ptr %slot.k, align 8
  %r49 = call i64 @nova_rt_str_concat(i64 %r47, i64 %r48)
  %r50.p = getelementptr inbounds [5 x i8], ptr @.str.5, i64 0, i64 0
  %r50 = ptrtoint ptr %r50.p to i64
  %r51 = call i64 @nova_rt_str_concat(i64 %r49, i64 %r50)
  %r52 = load i64, ptr %slot.i, align 8
  %r53 = call i64 @nova_rt_int_to_str(i64 %r52)
  %r54 = call i64 @nova_rt_str_concat(i64 %r51, i64 %r53)
  %r55 = call i64 @nova_rt_print_any(i64 %r54)
  br label %match_exit6
match_fall8:
  br label %match_exit6
match_exit6:
  %r56 = add i64 42, 0
  %r57 = call i64 @nt_var(i64 %r56)
  store i64 %r57, ptr %slot.t4, align 8
  %r58 = load i64, ptr %slot.t4, align 8
  %r59.ptr = inttoptr i64 %r58 to ptr
  %r59.gep = getelementptr i64, ptr %r59.ptr, i64 0
  %r59 = load i64, ptr %r59.gep, align 8
  %r60 = add i64 210683205845, 0
  %r61.cmp = icmp eq i64 %r59, %r60
  %r61 = zext i1 %r61.cmp to i64
  %br_marm_010 = icmp ne i64 %r61, 0
  br i1 %br_marm_010, label %marm_010, label %match_fall11
marm_010:
  %r62.ptr = inttoptr i64 %r58 to ptr
  %r62.gep = getelementptr i64, ptr %r62.ptr, i64 1
  %r62 = load i64, ptr %r62.gep, align 8
  store i64 %r62, ptr %slot.k, align 8
  %r63.ptr = inttoptr i64 %r58 to ptr
  %r63.gep = getelementptr i64, ptr %r63.ptr, i64 2
  %r63 = load i64, ptr %r63.gep, align 8
  store i64 %r63, ptr %slot.n, align 8
  %r64.ptr = inttoptr i64 %r58 to ptr
  %r64.gep = getelementptr i64, ptr %r64.ptr, i64 3
  %r64 = load i64, ptr %r64.gep, align 8
  store i64 %r64, ptr %slot.p, align 8
  %r65.ptr = inttoptr i64 %r58 to ptr
  %r65.gep = getelementptr i64, ptr %r65.ptr, i64 4
  %r65 = load i64, ptr %r65.gep, align 8
  store i64 %r65, ptr %slot.i, align 8
  %r66.p = getelementptr inbounds [9 x i8], ptr @.str.8, i64 0, i64 0
  %r66 = ptrtoint ptr %r66.p to i64
  %r67 = load i64, ptr %slot.k, align 8
  %r68 = call i64 @nova_rt_str_concat(i64 %r66, i64 %r67)
  %r69.p = getelementptr inbounds [5 x i8], ptr @.str.5, i64 0, i64 0
  %r69 = ptrtoint ptr %r69.p to i64
  %r70 = call i64 @nova_rt_str_concat(i64 %r68, i64 %r69)
  %r71 = load i64, ptr %slot.i, align 8
  %r72 = call i64 @nova_rt_int_to_str(i64 %r71)
  %r73 = call i64 @nova_rt_str_concat(i64 %r70, i64 %r72)
  %r74 = call i64 @nova_rt_print_any(i64 %r73)
  br label %match_exit9
match_fall11:
  br label %match_exit9
match_exit9:
  %r75.p = getelementptr inbounds [4 x i8], ptr @.str.0, i64 0, i64 0
  %r75 = ptrtoint ptr %r75.p to i64
  %r76.p = getelementptr inbounds [1 x i8], ptr @.str.1, i64 0, i64 0
  %r76 = ptrtoint ptr %r76.p to i64
  %r77 = call i64 @nova_rt_list_create()
  %r78 = add i64 1, 0
  %r79 = sub i64 0, %r78
  %r80.ptr = call ptr @nova_rt_struct_alloc(i64 40)
  %r80.thash = getelementptr i64, ptr %r80.ptr, i64 0
  store i64 210683205845, ptr %r80.thash, align 8
  %r80.f0 = getelementptr i64, ptr %r80.ptr, i64 1
  store i64 %r75, ptr %r80.f0, align 8
  %r80.f1 = getelementptr i64, ptr %r80.ptr, i64 2
  store i64 %r76, ptr %r80.f1, align 8
  %r80.f2 = getelementptr i64, ptr %r80.ptr, i64 3
  store i64 %r77, ptr %r80.f2, align 8
  %r80.f3 = getelementptr i64, ptr %r80.ptr, i64 4
  store i64 %r79, ptr %r80.f3, align 8
  %r80 = ptrtoint ptr %r80.ptr to i64
  store i64 %r80, ptr %slot.t5, align 8
  %r81 = load i64, ptr %slot.t5, align 8
  %r82.ptr = inttoptr i64 %r81 to ptr
  %r82.gep = getelementptr i64, ptr %r82.ptr, i64 0
  %r82 = load i64, ptr %r82.gep, align 8
  %r83 = add i64 210683205845, 0
  %r84.cmp = icmp eq i64 %r82, %r83
  %r84 = zext i1 %r84.cmp to i64
  %br_marm_013 = icmp ne i64 %r84, 0
  br i1 %br_marm_013, label %marm_013, label %match_fall14
marm_013:
  %r85.ptr = inttoptr i64 %r81 to ptr
  %r85.gep = getelementptr i64, ptr %r85.ptr, i64 1
  %r85 = load i64, ptr %r85.gep, align 8
  store i64 %r85, ptr %slot.k, align 8
  %r86.ptr = inttoptr i64 %r81 to ptr
  %r86.gep = getelementptr i64, ptr %r86.ptr, i64 2
  %r86 = load i64, ptr %r86.gep, align 8
  store i64 %r86, ptr %slot.n, align 8
  %r87.ptr = inttoptr i64 %r81 to ptr
  %r87.gep = getelementptr i64, ptr %r87.ptr, i64 3
  %r87 = load i64, ptr %r87.gep, align 8
  store i64 %r87, ptr %slot.p, align 8
  %r88.ptr = inttoptr i64 %r81 to ptr
  %r88.gep = getelementptr i64, ptr %r88.ptr, i64 4
  %r88 = load i64, ptr %r88.gep, align 8
  store i64 %r88, ptr %slot.i, align 8
  %r89.p = getelementptr inbounds [9 x i8], ptr @.str.9, i64 0, i64 0
  %r89 = ptrtoint ptr %r89.p to i64
  %r90 = load i64, ptr %slot.k, align 8
  %r91 = call i64 @nova_rt_str_concat(i64 %r89, i64 %r90)
  %r92.p = getelementptr inbounds [5 x i8], ptr @.str.5, i64 0, i64 0
  %r92 = ptrtoint ptr %r92.p to i64
  %r93 = call i64 @nova_rt_str_concat(i64 %r91, i64 %r92)
  %r94 = load i64, ptr %slot.i, align 8
  %r95 = call i64 @nova_rt_int_to_str(i64 %r94)
  %r96 = call i64 @nova_rt_str_concat(i64 %r93, i64 %r95)
  %r97 = call i64 @nova_rt_print_any(i64 %r96)
  br label %match_exit12
match_fall14:
  br label %match_exit12
match_exit12:
  %r98.p = getelementptr inbounds [5 x i8], ptr @.str.10, i64 0, i64 0
  %r98 = ptrtoint ptr %r98.p to i64
  %r99 = call i64 @nova_rt_print_any(i64 %r98)
  ret i64 %r99
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
  call void @nova_rt_wait_all()
  call void @nova_rt_cleanup()
  ret i32 0
}

; String constants
@.str.0 = private unnamed_addr constant [4 x i8] c"var\00"
@.str.1 = private unnamed_addr constant [1 x i8] c"\00"
@.str.2 = private unnamed_addr constant [5 x i8] c"unit\00"
@.str.3 = private unnamed_addr constant [4 x i8] c"int\00"
@.str.4 = private unnamed_addr constant [9 x i8] c"t1 kind=\00"
@.str.5 = private unnamed_addr constant [5 x i8] c" id=\00"
@.str.6 = private unnamed_addr constant [9 x i8] c"t2 kind=\00"
@.str.7 = private unnamed_addr constant [9 x i8] c"t3 kind=\00"
@.str.8 = private unnamed_addr constant [9 x i8] c"t4 kind=\00"
@.str.9 = private unnamed_addr constant [9 x i8] c"t5 kind=\00"
@.str.10 = private unnamed_addr constant [5 x i8] c"done\00"

; TBAA metadata
!0 = !{!"NOVA TBAA"}
!1 = !{!"list_data_ptr", !0}
!2 = !{!1, !1, i64 0}
!3 = !{!"list_elem", !0}
!4 = !{!3, !3, i64 0}
!5 = !{!"list_size", !0}
!6 = !{!5, !5, i64 0}
!90 = !{!"branch_weights", i32 2000, i32 1}
!91 = distinct !{!91, !92, !93}
!92 = !{!"llvm.loop.unroll.enable"}
!93 = !{!"llvm.loop.vectorize.enable", i1 true}
