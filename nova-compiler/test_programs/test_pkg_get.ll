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

define i64 @nova_parse_toml_deps(i64 %p0) nounwind {
entry:
  %slot.content = alloca i64, align 8
  store i64 %p0, ptr %slot.content, align 8
  %slot.deps = alloca i64, align 8
  store i64 0, ptr %slot.deps, align 8
  %slot.lines = alloca i64, align 8
  store i64 0, ptr %slot.lines, align 8
  %slot.in_deps = alloca i64, align 8
  store i64 0, ptr %slot.in_deps, align 8
  %slot.__for_idx_0 = alloca i64, align 8
  store i64 0, ptr %slot.__for_idx_0, align 8
  %slot.line = alloca i64, align 8
  store i64 0, ptr %slot.line, align 8
  %slot.trimmed = alloca i64, align 8
  store i64 0, ptr %slot.trimmed, align 8
  %slot.__sc_6 = alloca i64, align 8
  store i64 0, ptr %slot.__sc_6, align 8
  %slot.__sc_12 = alloca i64, align 8
  store i64 0, ptr %slot.__sc_12, align 8
  %slot.__sc_15 = alloca i64, align 8
  store i64 0, ptr %slot.__sc_15, align 8
  %slot.eq_pos = alloca i64, align 8
  store i64 0, ptr %slot.eq_pos, align 8
  %slot.key = alloca i64, align 8
  store i64 0, ptr %slot.key, align 8
  %slot.val = alloca i64, align 8
  store i64 0, ptr %slot.val, align 8
  %slot.__sc_24 = alloca i64, align 8
  store i64 0, ptr %slot.__sc_24, align 8
  %r0 = call i64 @nova_rt_dict_create()
  store i64 %r0, ptr %slot.deps, align 8
  %r1 = load i64, ptr %slot.content, align 8
  %r2.p = getelementptr inbounds [2 x i8], ptr @.str.0, i64 0, i64 0
  %r2 = ptrtoint ptr %r2.p to i64
  %r3 = call i64 @nova_rt_split(i64 %r1, i64 %r2)
  store i64 %r3, ptr %slot.lines, align 8
  %r4 = add i64 0, 0
  store i64 %r4, ptr %slot.in_deps, align 8
  %r5 = load i64, ptr %slot.lines, align 8
  %r6 = call i64 @nova_rt_len_any(i64 %r5)
  %r7 = add i64 0, 0
  store i64 %r7, ptr %slot.__for_idx_0, align 8
  br label %for_hdr0, !llvm.loop !91
for_hdr0:
  %r8 = load i64, ptr %slot.__for_idx_0, align 8
  %r9.cmp = icmp slt i64 %r8, %r6
  %r9 = zext i1 %r9.cmp to i64
  %br_for_body1 = icmp ne i64 %r9, 0
  br i1 %br_for_body1, label %for_body1, label %for_exit2, !prof !90
for_body1:
  %r10 = call i64 @nova_rt_index_get(i64 %r5, i64 %r8)
  store i64 %r10, ptr %slot.line, align 8
  %r11 = load i64, ptr %slot.line, align 8
  %r12 = call i64 @nova_rt_trim(i64 %r11)
  store i64 %r12, ptr %slot.trimmed, align 8
  %r13 = load i64, ptr %slot.trimmed, align 8
  %r14.p = getelementptr inbounds [15 x i8], ptr @.str.1, i64 0, i64 0
  %r14 = ptrtoint ptr %r14.p to i64
  %r15.p0 = inttoptr i64 %r13 to ptr
  %r15.p1 = inttoptr i64 %r14 to ptr
  %r15.sc = call i32 @strcmp(ptr %r15.p0, ptr %r15.p1)
  %r15.cmp = icmp eq i32 %r15.sc, 0
  %r15 = zext i1 %r15.cmp to i64
  %br_then3 = icmp ne i64 %r15, 0
  br i1 %br_then3, label %then3, label %else4
then3:
  %r16 = add i64 1, 0
  store i64 %r16, ptr %slot.in_deps, align 8
  br label %endif5
else4:
  %r17 = load i64, ptr %slot.trimmed, align 8
  %r18 = call i64 @nova_rt_len_any(i64 %r17)
  %r19 = add i64 0, 0
  %r20.cmp = icmp sgt i64 %r18, %r19
  %r20 = zext i1 %r20.cmp to i64
  store i64 %r20, ptr %slot.__sc_6, align 8
  %br_and_rhs7 = icmp ne i64 %r20, 0
  br i1 %br_and_rhs7, label %and_rhs7, label %and_merge8
and_rhs7:
  %r21 = load i64, ptr %slot.trimmed, align 8
  %r22 = add i64 0, 0
  %r23 = call i64 @nova_rt_index_get(i64 %r21, i64 %r22)
  %r24.p = getelementptr inbounds [2 x i8], ptr @.str.2, i64 0, i64 0
  %r24 = ptrtoint ptr %r24.p to i64
  %r25.p0 = inttoptr i64 %r23 to ptr
  %r25.p1 = inttoptr i64 %r24 to ptr
  %r25.sc = call i32 @strcmp(ptr %r25.p0, ptr %r25.p1)
  %r25.cmp = icmp eq i32 %r25.sc, 0
  %r25 = zext i1 %r25.cmp to i64
  store i64 %r25, ptr %slot.__sc_6, align 8
  br label %and_merge8
and_merge8:
  %r26 = load i64, ptr %slot.__sc_6, align 8
  %br_then9 = icmp ne i64 %r26, 0
  br i1 %br_then9, label %then9, label %else10
then9:
  %r27 = add i64 0, 0
  store i64 %r27, ptr %slot.in_deps, align 8
  br label %endif11
else10:
  %r28 = load i64, ptr %slot.in_deps, align 8
  %r29 = add i64 1, 0
  %r30.cmp = icmp eq i64 %r28, %r29
  %r30 = zext i1 %r30.cmp to i64
  store i64 %r30, ptr %slot.__sc_12, align 8
  %br_and_rhs13 = icmp ne i64 %r30, 0
  br i1 %br_and_rhs13, label %and_rhs13, label %and_merge14
and_rhs13:
  %r31 = load i64, ptr %slot.trimmed, align 8
  %r32 = call i64 @nova_rt_len_any(i64 %r31)
  %r33 = add i64 0, 0
  %r34.cmp = icmp sgt i64 %r32, %r33
  %r34 = zext i1 %r34.cmp to i64
  store i64 %r34, ptr %slot.__sc_12, align 8
  br label %and_merge14
and_merge14:
  %r35 = load i64, ptr %slot.__sc_12, align 8
  store i64 %r35, ptr %slot.__sc_15, align 8
  %br_and_rhs16 = icmp ne i64 %r35, 0
  br i1 %br_and_rhs16, label %and_rhs16, label %and_merge17
and_rhs16:
  %r36 = load i64, ptr %slot.trimmed, align 8
  %r37 = add i64 0, 0
  %r38 = call i64 @nova_rt_index_get(i64 %r36, i64 %r37)
  %r39.p = getelementptr inbounds [2 x i8], ptr @.str.3, i64 0, i64 0
  %r39 = ptrtoint ptr %r39.p to i64
  %r40.p0 = inttoptr i64 %r38 to ptr
  %r40.p1 = inttoptr i64 %r39 to ptr
  %r40.sc = call i32 @strcmp(ptr %r40.p0, ptr %r40.p1)
  %r40.cmp = icmp ne i32 %r40.sc, 0
  %r40 = zext i1 %r40.cmp to i64
  store i64 %r40, ptr %slot.__sc_15, align 8
  br label %and_merge17
and_merge17:
  %r41 = load i64, ptr %slot.__sc_15, align 8
  %br_then18 = icmp ne i64 %r41, 0
  br i1 %br_then18, label %then18, label %else19
then18:
  %r42 = load i64, ptr %slot.trimmed, align 8
  %r43.p = getelementptr inbounds [2 x i8], ptr @.str.4, i64 0, i64 0
  %r43 = ptrtoint ptr %r43.p to i64
  %r44 = call i64 @nova_rt_find(i64 %r42, i64 %r43)
  store i64 %r44, ptr %slot.eq_pos, align 8
  %r45 = load i64, ptr %slot.eq_pos, align 8
  %r46 = add i64 0, 0
  %r47.cmp = icmp sge i64 %r45, %r46
  %r47 = zext i1 %r47.cmp to i64
  %br_then21 = icmp ne i64 %r47, 0
  br i1 %br_then21, label %then21, label %else22
then21:
  %r48 = load i64, ptr %slot.trimmed, align 8
  %r49 = add i64 0, 0
  %r50 = load i64, ptr %slot.eq_pos, align 8
  %r51 = call i64 @nova_rt_slice(i64 %r48, i64 %r49, i64 %r50)
  %r52 = call i64 @nova_rt_trim(i64 %r51)
  store i64 %r52, ptr %slot.key, align 8
  %r53 = load i64, ptr %slot.trimmed, align 8
  %r54 = load i64, ptr %slot.eq_pos, align 8
  %r55 = add i64 1, 0
  %r56 = call i64 @nova_rt_add(i64 %r54, i64 %r55)
  %r57 = load i64, ptr %slot.trimmed, align 8
  %r58 = call i64 @nova_rt_len_any(i64 %r57)
  %r59 = call i64 @nova_rt_slice(i64 %r53, i64 %r56, i64 %r58)
  %r60 = call i64 @nova_rt_trim(i64 %r59)
  store i64 %r60, ptr %slot.val, align 8
  %r61 = load i64, ptr %slot.val, align 8
  %r62 = call i64 @nova_rt_len_any(i64 %r61)
  %r63 = add i64 2, 0
  %r64.cmp = icmp sge i64 %r62, %r63
  %r64 = zext i1 %r64.cmp to i64
  store i64 %r64, ptr %slot.__sc_24, align 8
  %br_and_rhs25 = icmp ne i64 %r64, 0
  br i1 %br_and_rhs25, label %and_rhs25, label %and_merge26
and_rhs25:
  %r65 = load i64, ptr %slot.val, align 8
  %r66 = add i64 0, 0
  %r67 = call i64 @nova_rt_index_get(i64 %r65, i64 %r66)
  %r68.p = getelementptr inbounds [2 x i8], ptr @.str.5, i64 0, i64 0
  %r68 = ptrtoint ptr %r68.p to i64
  %r69.p0 = inttoptr i64 %r67 to ptr
  %r69.p1 = inttoptr i64 %r68 to ptr
  %r69.sc = call i32 @strcmp(ptr %r69.p0, ptr %r69.p1)
  %r69.cmp = icmp eq i32 %r69.sc, 0
  %r69 = zext i1 %r69.cmp to i64
  store i64 %r69, ptr %slot.__sc_24, align 8
  br label %and_merge26
and_merge26:
  %r70 = load i64, ptr %slot.__sc_24, align 8
  %br_then27 = icmp ne i64 %r70, 0
  br i1 %br_then27, label %then27, label %else28
then27:
  %r71 = load i64, ptr %slot.val, align 8
  %r72 = add i64 1, 0
  %r73 = load i64, ptr %slot.val, align 8
  %r74 = call i64 @nova_rt_len_any(i64 %r73)
  %r75 = add i64 1, 0
  %r76 = sub i64 %r74, %r75
  %r77 = call i64 @nova_rt_slice(i64 %r71, i64 %r72, i64 %r76)
  store i64 %r77, ptr %slot.val, align 8
  br label %endif29
else28:
  br label %endif29
endif29:
  %r78 = load i64, ptr %slot.val, align 8
  %r79 = load i64, ptr %slot.deps, align 8
  %r80 = load i64, ptr %slot.key, align 8
  call i64 @nova_rt_index_set(i64 %r79, i64 %r80, i64 %r78)
  br label %endif23
else22:
  br label %endif23
endif23:
  br label %endif20
else19:
  br label %endif20
endif20:
  br label %endif11
endif11:
  br label %endif5
endif5:
  %r81 = load i64, ptr %slot.__for_idx_0, align 8
  %r82 = add i64 1, 0
  %r83 = add i64 %r81, %r82
  store i64 %r83, ptr %slot.__for_idx_0, align 8
  br label %for_hdr0, !llvm.loop !91
for_exit2:
  %r84 = load i64, ptr %slot.deps, align 8
  ret i64 %r84
}

define i64 @nova_pkg_get(i64 %p0) nounwind {
entry:
  %slot.pkg_spec = alloca i64, align 8
  store i64 %p0, ptr %slot.pkg_spec, align 8
  %slot.pkg_name = alloca i64, align 8
  store i64 0, ptr %slot.pkg_name, align 8
  %slot.pkg_version = alloca i64, align 8
  store i64 0, ptr %slot.pkg_version, align 8
  %slot.at_pos = alloca i64, align 8
  store i64 0, ptr %slot.at_pos, align 8
  %slot.toml = alloca i64, align 8
  store i64 0, ptr %slot.toml, align 8
  %slot.deps = alloca i64, align 8
  store i64 0, ptr %slot.deps, align 8
  %slot.existing_ver = alloca i64, align 8
  store i64 0, ptr %slot.existing_ver, align 8
  %slot.dep_line = alloca i64, align 8
  store i64 0, ptr %slot.dep_line, align 8
  %r0 = load i64, ptr %slot.pkg_spec, align 8
  store i64 %r0, ptr %slot.pkg_name, align 8
  %r1.p = getelementptr inbounds [2 x i8], ptr @.str.6, i64 0, i64 0
  %r1 = ptrtoint ptr %r1.p to i64
  store i64 %r1, ptr %slot.pkg_version, align 8
  %r2 = load i64, ptr %slot.pkg_spec, align 8
  %r3.p = getelementptr inbounds [2 x i8], ptr @.str.7, i64 0, i64 0
  %r3 = ptrtoint ptr %r3.p to i64
  %r4 = call i64 @nova_rt_find(i64 %r2, i64 %r3)
  store i64 %r4, ptr %slot.at_pos, align 8
  %r5 = load i64, ptr %slot.at_pos, align 8
  %r6 = add i64 0, 0
  %r7.cmp = icmp sge i64 %r5, %r6
  %r7 = zext i1 %r7.cmp to i64
  %br_then30 = icmp ne i64 %r7, 0
  br i1 %br_then30, label %then30, label %else31
then30:
  %r8 = load i64, ptr %slot.pkg_spec, align 8
  %r9 = add i64 0, 0
  %r10 = load i64, ptr %slot.at_pos, align 8
  %r11 = call i64 @nova_rt_slice(i64 %r8, i64 %r9, i64 %r10)
  store i64 %r11, ptr %slot.pkg_name, align 8
  %r12 = load i64, ptr %slot.pkg_spec, align 8
  %r13 = load i64, ptr %slot.at_pos, align 8
  %r14 = add i64 1, 0
  %r15 = call i64 @nova_rt_add(i64 %r13, i64 %r14)
  %r16 = load i64, ptr %slot.pkg_spec, align 8
  %r17 = call i64 @nova_rt_len_any(i64 %r16)
  %r18 = call i64 @nova_rt_slice(i64 %r12, i64 %r15, i64 %r17)
  store i64 %r18, ptr %slot.pkg_version, align 8
  br label %endif32
else31:
  br label %endif32
endif32:
  %r19.p = getelementptr inbounds [10 x i8], ptr @.str.8, i64 0, i64 0
  %r19 = ptrtoint ptr %r19.p to i64
  %r20 = call i64 @nova_rt_read_file(i64 %r19)
  store i64 %r20, ptr %slot.toml, align 8
  %r21 = load i64, ptr %slot.toml, align 8
  %r22 = call i64 @nova_rt_len_any(i64 %r21)
  %r23 = add i64 0, 0
  %r24.cmp = icmp eq i64 %r22, %r23
  %r24 = zext i1 %r24.cmp to i64
  %br_then33 = icmp ne i64 %r24, 0
  br i1 %br_then33, label %then33, label %else34
then33:
  %r25.p = getelementptr inbounds [26 x i8], ptr @.str.9, i64 0, i64 0
  %r25 = ptrtoint ptr %r25.p to i64
  %r26 = call i64 @nova_rt_print_any(i64 %r25)
  %r27 = add i64 1, 0
  %r28 = call i64 @nova_rt_exit(i64 %r27)
  br label %endif35
else34:
  br label %endif35
endif35:
  %r29 = load i64, ptr %slot.toml, align 8
  %r30 = call i64 @nova_parse_toml_deps(i64 %r29)
  store i64 %r30, ptr %slot.deps, align 8
  %r31 = load i64, ptr %slot.deps, align 8
  %r32 = load i64, ptr %slot.pkg_name, align 8
  %r33 = call i64 @nova_rt_contains(i64 %r31, i64 %r32)
  %br_then36 = icmp ne i64 %r33, 0
  br i1 %br_then36, label %then36, label %else37
then36:
  %r34 = load i64, ptr %slot.deps, align 8
  %r35 = load i64, ptr %slot.pkg_name, align 8
  %r36 = call i64 @nova_rt_index_get(i64 %r34, i64 %r35)
  store i64 %r36, ptr %slot.existing_ver, align 8
  %r37.p = getelementptr inbounds [10 x i8], ptr @.str.10, i64 0, i64 0
  %r37 = ptrtoint ptr %r37.p to i64
  %r38 = load i64, ptr %slot.pkg_name, align 8
  %r39 = call i64 @nova_rt_any_to_str(i64 %r38)
  %r40 = call i64 @nova_rt_str_concat(i64 %r37, i64 %r39)
  %r41.p = getelementptr inbounds [28 x i8], ptr @.str.11, i64 0, i64 0
  %r41 = ptrtoint ptr %r41.p to i64
  %r42 = call i64 @nova_rt_str_concat(i64 %r40, i64 %r41)
  %r43 = load i64, ptr %slot.existing_ver, align 8
  %r44 = call i64 @nova_rt_any_to_str(i64 %r43)
  %r45 = call i64 @nova_rt_str_concat(i64 %r42, i64 %r44)
  %r46.p = getelementptr inbounds [2 x i8], ptr @.str.12, i64 0, i64 0
  %r46 = ptrtoint ptr %r46.p to i64
  %r47 = call i64 @nova_rt_str_concat(i64 %r45, i64 %r46)
  %r48 = call i64 @nova_rt_print_any(i64 %r47)
  %r49 = add i64 0, 0
  ret i64 %r49
else37:
  br label %endif38
endif38:
  %r50 = load i64, ptr %slot.pkg_name, align 8
  %r51.p = getelementptr inbounds [5 x i8], ptr @.str.13, i64 0, i64 0
  %r51 = ptrtoint ptr %r51.p to i64
  %r52 = call i64 @nova_rt_str_concat(i64 %r50, i64 %r51)
  %r53 = load i64, ptr %slot.pkg_version, align 8
  %r54 = call i64 @nova_rt_str_concat(i64 %r52, i64 %r53)
  %r55.p = getelementptr inbounds [3 x i8], ptr @.str.14, i64 0, i64 0
  %r55 = ptrtoint ptr %r55.p to i64
  %r56 = call i64 @nova_rt_str_concat(i64 %r54, i64 %r55)
  store i64 %r56, ptr %slot.dep_line, align 8
  %r57 = load i64, ptr %slot.dep_line, align 8
  %r58 = call i64 @nova_rt_print_any(i64 %r57)
  ret i64 %r58
}

define i64 @nova_user_main() nounwind {
entry:
  %r0.p = getelementptr inbounds [10 x i8], ptr @.str.15, i64 0, i64 0
  %r0 = ptrtoint ptr %r0.p to i64
  %r1 = call i64 @nova_rt_print_any(i64 %r0)
  ret i64 %r1
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
@.str.0 = private unnamed_addr constant [2 x i8] c"\0A\00"
@.str.1 = private unnamed_addr constant [15 x i8] c"[dependencies]\00"
@.str.2 = private unnamed_addr constant [2 x i8] c"[\00"
@.str.3 = private unnamed_addr constant [2 x i8] c"#\00"
@.str.4 = private unnamed_addr constant [2 x i8] c"=\00"
@.str.5 = private unnamed_addr constant [2 x i8] c"\22\00"
@.str.6 = private unnamed_addr constant [2 x i8] c"*\00"
@.str.7 = private unnamed_addr constant [2 x i8] c"@\00"
@.str.8 = private unnamed_addr constant [10 x i8] c"nova.toml\00"
@.str.9 = private unnamed_addr constant [26 x i8] c"error: no nova.toml found\00"
@.str.10 = private unnamed_addr constant [10 x i8] c"Package '\00"
@.str.11 = private unnamed_addr constant [28 x i8] c"' already in deps (version \00"
@.str.12 = private unnamed_addr constant [2 x i8] c")\00"
@.str.13 = private unnamed_addr constant [5 x i8] c" = \22\00"
@.str.14 = private unnamed_addr constant [3 x i8] c"\22\0A\00"
@.str.15 = private unnamed_addr constant [10 x i8] c"test done\00"

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
