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

define i64 @tokenize(i64 %p0) nounwind {
entry:
  %slot.input = alloca i64, align 8
  store i64 %p0, ptr %slot.input, align 8
  %slot.tokens = alloca i64, align 8
  store i64 0, ptr %slot.tokens, align 8
  %slot.i = alloca i64, align 8
  store i64 0, ptr %slot.i, align 8
  %slot.current = alloca i64, align 8
  store i64 0, ptr %slot.current, align 8
  %slot.ch = alloca i64, align 8
  store i64 0, ptr %slot.ch, align 8
  %slot.__sc_3 = alloca i64, align 8
  store i64 0, ptr %slot.__sc_3, align 8
  %slot.__sc_12 = alloca i64, align 8
  store i64 0, ptr %slot.__sc_12, align 8
  %slot.__sc_15 = alloca i64, align 8
  store i64 0, ptr %slot.__sc_15, align 8
  %slot.__sc_18 = alloca i64, align 8
  store i64 0, ptr %slot.__sc_18, align 8
  %r0 = call i64 @nova_rt_list_create()
  store i64 %r0, ptr %slot.tokens, align 8
  %r1 = add i64 0, 0
  store i64 %r1, ptr %slot.i, align 8
  %r2.p = getelementptr inbounds [1 x i8], ptr @.str.0, i64 0, i64 0
  %r2 = ptrtoint ptr %r2.p to i64
  store i64 %r2, ptr %slot.current, align 8
  br label %while_hdr0, !llvm.loop !91
while_hdr0:
  %r3 = load i64, ptr %slot.i, align 8
  %r4 = load i64, ptr %slot.input, align 8
  %r5 = call i64 @nova_rt_len_any(i64 %r4)
  %r6.cmp = icmp slt i64 %r3, %r5
  %r6 = zext i1 %r6.cmp to i64
  %br_while_body1 = icmp ne i64 %r6, 0
  br i1 %br_while_body1, label %while_body1, label %while_exit2, !prof !90
while_body1:
  %r7 = load i64, ptr %slot.input, align 8
  %r8 = load i64, ptr %slot.i, align 8
  %r9 = call i64 @nova_rt_index_get(i64 %r7, i64 %r8)
  store i64 %r9, ptr %slot.ch, align 8
  %r10 = load i64, ptr %slot.ch, align 8
  %r11.p = getelementptr inbounds [2 x i8], ptr @.str.1, i64 0, i64 0
  %r11 = ptrtoint ptr %r11.p to i64
  %r12.p0 = inttoptr i64 %r10 to ptr
  %r12.p1 = inttoptr i64 %r11 to ptr
  %r12.sc = call i32 @strcmp(ptr %r12.p0, ptr %r12.p1)
  %r12.cmp = icmp eq i32 %r12.sc, 0
  %r12 = zext i1 %r12.cmp to i64
  store i64 %r12, ptr %slot.__sc_3, align 8
  %br_or_merge5 = icmp ne i64 %r12, 0
  br i1 %br_or_merge5, label %or_merge5, label %or_rhs4
or_rhs4:
  %r13 = load i64, ptr %slot.ch, align 8
  %r14.p = getelementptr inbounds [2 x i8], ptr @.str.2, i64 0, i64 0
  %r14 = ptrtoint ptr %r14.p to i64
  %r15.p0 = inttoptr i64 %r13 to ptr
  %r15.p1 = inttoptr i64 %r14 to ptr
  %r15.sc = call i32 @strcmp(ptr %r15.p0, ptr %r15.p1)
  %r15.cmp = icmp eq i32 %r15.sc, 0
  %r15 = zext i1 %r15.cmp to i64
  store i64 %r15, ptr %slot.__sc_3, align 8
  br label %or_merge5
or_merge5:
  %r16 = load i64, ptr %slot.__sc_3, align 8
  %br_then6 = icmp ne i64 %r16, 0
  br i1 %br_then6, label %then6, label %else7
then6:
  %r17 = load i64, ptr %slot.current, align 8
  %r18 = call i64 @nova_rt_len_any(i64 %r17)
  %r19 = add i64 0, 0
  %r20.cmp = icmp sgt i64 %r18, %r19
  %r20 = zext i1 %r20.cmp to i64
  %br_then9 = icmp ne i64 %r20, 0
  br i1 %br_then9, label %then9, label %else10
then9:
  %r21 = load i64, ptr %slot.tokens, align 8
  %r22.p = getelementptr inbounds [5 x i8], ptr @.str.3, i64 0, i64 0
  %r22 = ptrtoint ptr %r22.p to i64
  %r23 = load i64, ptr %slot.current, align 8
  %r24.ptr = call ptr @nova_rt_struct_alloc(i64 24)
  %r24.thash = getelementptr i64, ptr %r24.ptr, i64 0
  store i64 210691276070, ptr %r24.thash, align 8
  %r24.f0 = getelementptr i64, ptr %r24.ptr, i64 1
  store i64 %r22, ptr %r24.f0, align 8
  %r24.f1 = getelementptr i64, ptr %r24.ptr, i64 2
  store i64 %r23, ptr %r24.f1, align 8
  %r24 = ptrtoint ptr %r24.ptr to i64
  %r25 = call i64 @nova_rt_list_append(i64 %r21, i64 %r24)
  %r26.p = getelementptr inbounds [1 x i8], ptr @.str.0, i64 0, i64 0
  %r26 = ptrtoint ptr %r26.p to i64
  store i64 %r26, ptr %slot.current, align 8
  br label %endif11
else10:
  br label %endif11
endif11:
  br label %endif8
else7:
  %r27 = load i64, ptr %slot.ch, align 8
  %r28.p = getelementptr inbounds [2 x i8], ptr @.str.4, i64 0, i64 0
  %r28 = ptrtoint ptr %r28.p to i64
  %r29.p0 = inttoptr i64 %r27 to ptr
  %r29.p1 = inttoptr i64 %r28 to ptr
  %r29.sc = call i32 @strcmp(ptr %r29.p0, ptr %r29.p1)
  %r29.cmp = icmp eq i32 %r29.sc, 0
  %r29 = zext i1 %r29.cmp to i64
  store i64 %r29, ptr %slot.__sc_12, align 8
  %br_or_merge14 = icmp ne i64 %r29, 0
  br i1 %br_or_merge14, label %or_merge14, label %or_rhs13
or_rhs13:
  %r30 = load i64, ptr %slot.ch, align 8
  %r31.p = getelementptr inbounds [2 x i8], ptr @.str.5, i64 0, i64 0
  %r31 = ptrtoint ptr %r31.p to i64
  %r32.p0 = inttoptr i64 %r30 to ptr
  %r32.p1 = inttoptr i64 %r31 to ptr
  %r32.sc = call i32 @strcmp(ptr %r32.p0, ptr %r32.p1)
  %r32.cmp = icmp eq i32 %r32.sc, 0
  %r32 = zext i1 %r32.cmp to i64
  store i64 %r32, ptr %slot.__sc_12, align 8
  br label %or_merge14
or_merge14:
  %r33 = load i64, ptr %slot.__sc_12, align 8
  store i64 %r33, ptr %slot.__sc_15, align 8
  %br_or_merge17 = icmp ne i64 %r33, 0
  br i1 %br_or_merge17, label %or_merge17, label %or_rhs16
or_rhs16:
  %r34 = load i64, ptr %slot.ch, align 8
  %r35.p = getelementptr inbounds [2 x i8], ptr @.str.6, i64 0, i64 0
  %r35 = ptrtoint ptr %r35.p to i64
  %r36.p0 = inttoptr i64 %r34 to ptr
  %r36.p1 = inttoptr i64 %r35 to ptr
  %r36.sc = call i32 @strcmp(ptr %r36.p0, ptr %r36.p1)
  %r36.cmp = icmp eq i32 %r36.sc, 0
  %r36 = zext i1 %r36.cmp to i64
  store i64 %r36, ptr %slot.__sc_15, align 8
  br label %or_merge17
or_merge17:
  %r37 = load i64, ptr %slot.__sc_15, align 8
  store i64 %r37, ptr %slot.__sc_18, align 8
  %br_or_merge20 = icmp ne i64 %r37, 0
  br i1 %br_or_merge20, label %or_merge20, label %or_rhs19
or_rhs19:
  %r38 = load i64, ptr %slot.ch, align 8
  %r39.p = getelementptr inbounds [2 x i8], ptr @.str.7, i64 0, i64 0
  %r39 = ptrtoint ptr %r39.p to i64
  %r40.p0 = inttoptr i64 %r38 to ptr
  %r40.p1 = inttoptr i64 %r39 to ptr
  %r40.sc = call i32 @strcmp(ptr %r40.p0, ptr %r40.p1)
  %r40.cmp = icmp eq i32 %r40.sc, 0
  %r40 = zext i1 %r40.cmp to i64
  store i64 %r40, ptr %slot.__sc_18, align 8
  br label %or_merge20
or_merge20:
  %r41 = load i64, ptr %slot.__sc_18, align 8
  %br_then21 = icmp ne i64 %r41, 0
  br i1 %br_then21, label %then21, label %else22
then21:
  %r42 = load i64, ptr %slot.current, align 8
  %r43 = call i64 @nova_rt_len_any(i64 %r42)
  %r44 = add i64 0, 0
  %r45.cmp = icmp sgt i64 %r43, %r44
  %r45 = zext i1 %r45.cmp to i64
  %br_then24 = icmp ne i64 %r45, 0
  br i1 %br_then24, label %then24, label %else25
then24:
  %r46 = load i64, ptr %slot.tokens, align 8
  %r47.p = getelementptr inbounds [5 x i8], ptr @.str.3, i64 0, i64 0
  %r47 = ptrtoint ptr %r47.p to i64
  %r48 = load i64, ptr %slot.current, align 8
  %r49.ptr = call ptr @nova_rt_struct_alloc(i64 24)
  %r49.thash = getelementptr i64, ptr %r49.ptr, i64 0
  store i64 210691276070, ptr %r49.thash, align 8
  %r49.f0 = getelementptr i64, ptr %r49.ptr, i64 1
  store i64 %r47, ptr %r49.f0, align 8
  %r49.f1 = getelementptr i64, ptr %r49.ptr, i64 2
  store i64 %r48, ptr %r49.f1, align 8
  %r49 = ptrtoint ptr %r49.ptr to i64
  %r50 = call i64 @nova_rt_list_append(i64 %r46, i64 %r49)
  %r51.p = getelementptr inbounds [1 x i8], ptr @.str.0, i64 0, i64 0
  %r51 = ptrtoint ptr %r51.p to i64
  store i64 %r51, ptr %slot.current, align 8
  br label %endif26
else25:
  br label %endif26
endif26:
  %r52 = load i64, ptr %slot.tokens, align 8
  %r53.p = getelementptr inbounds [4 x i8], ptr @.str.8, i64 0, i64 0
  %r53 = ptrtoint ptr %r53.p to i64
  %r54 = load i64, ptr %slot.ch, align 8
  %r55.ptr = call ptr @nova_rt_struct_alloc(i64 24)
  %r55.thash = getelementptr i64, ptr %r55.ptr, i64 0
  store i64 210691276070, ptr %r55.thash, align 8
  %r55.f0 = getelementptr i64, ptr %r55.ptr, i64 1
  store i64 %r53, ptr %r55.f0, align 8
  %r55.f1 = getelementptr i64, ptr %r55.ptr, i64 2
  store i64 %r54, ptr %r55.f1, align 8
  %r55 = ptrtoint ptr %r55.ptr to i64
  %r56 = call i64 @nova_rt_list_append(i64 %r52, i64 %r55)
  br label %endif23
else22:
  %r57 = load i64, ptr %slot.current, align 8
  %r58 = load i64, ptr %slot.ch, align 8
  %r59 = call i64 @nova_rt_str_concat(i64 %r57, i64 %r58)
  store i64 %r59, ptr %slot.current, align 8
  br label %endif23
endif23:
  br label %endif8
endif8:
  %r60 = load i64, ptr %slot.i, align 8
  %r61 = add i64 1, 0
  %r62 = add i64 %r60, %r61
  store i64 %r62, ptr %slot.i, align 8
  br label %while_hdr0, !llvm.loop !91
while_exit2:
  %r63 = load i64, ptr %slot.current, align 8
  %r64 = call i64 @nova_rt_len_any(i64 %r63)
  %r65 = add i64 0, 0
  %r66.cmp = icmp sgt i64 %r64, %r65
  %r66 = zext i1 %r66.cmp to i64
  %br_then27 = icmp ne i64 %r66, 0
  br i1 %br_then27, label %then27, label %else28
then27:
  %r67 = load i64, ptr %slot.tokens, align 8
  %r68.p = getelementptr inbounds [5 x i8], ptr @.str.3, i64 0, i64 0
  %r68 = ptrtoint ptr %r68.p to i64
  %r69 = load i64, ptr %slot.current, align 8
  %r70.ptr = call ptr @nova_rt_struct_alloc(i64 24)
  %r70.thash = getelementptr i64, ptr %r70.ptr, i64 0
  store i64 210691276070, ptr %r70.thash, align 8
  %r70.f0 = getelementptr i64, ptr %r70.ptr, i64 1
  store i64 %r68, ptr %r70.f0, align 8
  %r70.f1 = getelementptr i64, ptr %r70.ptr, i64 2
  store i64 %r69, ptr %r70.f1, align 8
  %r70 = ptrtoint ptr %r70.ptr to i64
  %r71 = call i64 @nova_rt_list_append(i64 %r67, i64 %r70)
  br label %endif29
else28:
  br label %endif29
endif29:
  %r72 = load i64, ptr %slot.tokens, align 8
  ret i64 %r72
}

define i64 @emit_code(i64 %p0) nounwind {
entry:
  %slot.tokens = alloca i64, align 8
  store i64 %p0, ptr %slot.tokens, align 8
  %slot.output = alloca i64, align 8
  store i64 0, ptr %slot.output, align 8
  %slot.__for_idx_30 = alloca i64, align 8
  store i64 0, ptr %slot.__for_idx_30, align 8
  %slot.tok = alloca i64, align 8
  store i64 0, ptr %slot.tok, align 8
  %slot.kind = alloca i64, align 8
  store i64 0, ptr %slot.kind, align 8
  %slot.value = alloca i64, align 8
  store i64 0, ptr %slot.value, align 8
  %r0.p = getelementptr inbounds [1 x i8], ptr @.str.0, i64 0, i64 0
  %r0 = ptrtoint ptr %r0.p to i64
  store i64 %r0, ptr %slot.output, align 8
  %r1 = load i64, ptr %slot.tokens, align 8
  %r2 = call i64 @nova_rt_len_any(i64 %r1)
  %r3 = add i64 0, 0
  store i64 %r3, ptr %slot.__for_idx_30, align 8
  br label %for_hdr30, !llvm.loop !91
for_hdr30:
  %r4 = load i64, ptr %slot.__for_idx_30, align 8
  %r5.cmp = icmp slt i64 %r4, %r2
  %r5 = zext i1 %r5.cmp to i64
  %br_for_body31 = icmp ne i64 %r5, 0
  br i1 %br_for_body31, label %for_body31, label %for_exit32, !prof !90
for_body31:
  %r6 = call i64 @nova_rt_index_get(i64 %r1, i64 %r4)
  store i64 %r6, ptr %slot.tok, align 8
  %r7 = load i64, ptr %slot.tok, align 8
  %r8.ptr = inttoptr i64 %r7 to ptr
  %r8.gep = getelementptr i64, ptr %r8.ptr, i64 0
  %r8 = load i64, ptr %r8.gep, align 8
  %r9 = add i64 210691276070, 0
  %r10.cmp = icmp eq i64 %r8, %r9
  %r10 = zext i1 %r10.cmp to i64
  %br_marm_034 = icmp ne i64 %r10, 0
  br i1 %br_marm_034, label %marm_034, label %match_fall35
marm_034:
  %r11.ptr = inttoptr i64 %r7 to ptr
  %r11.gep = getelementptr i64, ptr %r11.ptr, i64 1
  %r11 = load i64, ptr %r11.gep, align 8
  store i64 %r11, ptr %slot.kind, align 8
  %r12.ptr = inttoptr i64 %r7 to ptr
  %r12.gep = getelementptr i64, ptr %r12.ptr, i64 2
  %r12 = load i64, ptr %r12.gep, align 8
  store i64 %r12, ptr %slot.value, align 8
  %r13 = load i64, ptr %slot.kind, align 8
  %r14.p = getelementptr inbounds [5 x i8], ptr @.str.3, i64 0, i64 0
  %r14 = ptrtoint ptr %r14.p to i64
  %r15.p0 = inttoptr i64 %r13 to ptr
  %r15.p1 = inttoptr i64 %r14 to ptr
  %r15.sc = call i32 @strcmp(ptr %r15.p0, ptr %r15.p1)
  %r15.cmp = icmp eq i32 %r15.sc, 0
  %r15 = zext i1 %r15.cmp to i64
  %br_then36 = icmp ne i64 %r15, 0
  br i1 %br_then36, label %then36, label %else37
then36:
  %r16 = load i64, ptr %slot.output, align 8
  %r17 = load i64, ptr %slot.value, align 8
  %r18 = call i64 @nova_rt_str_concat(i64 %r16, i64 %r17)
  %r19.p = getelementptr inbounds [2 x i8], ptr @.str.1, i64 0, i64 0
  %r19 = ptrtoint ptr %r19.p to i64
  %r20 = call i64 @nova_rt_str_concat(i64 %r18, i64 %r19)
  store i64 %r20, ptr %slot.output, align 8
  br label %endif38
else37:
  %r21 = load i64, ptr %slot.output, align 8
  %r22 = load i64, ptr %slot.value, align 8
  %r23 = call i64 @nova_rt_str_concat(i64 %r21, i64 %r22)
  %r24.p = getelementptr inbounds [2 x i8], ptr @.str.1, i64 0, i64 0
  %r24 = ptrtoint ptr %r24.p to i64
  %r25 = call i64 @nova_rt_str_concat(i64 %r23, i64 %r24)
  store i64 %r25, ptr %slot.output, align 8
  br label %endif38
endif38:
  br label %match_exit33
match_fall35:
  br label %match_exit33
match_exit33:
  %r26 = load i64, ptr %slot.__for_idx_30, align 8
  %r27 = add i64 1, 0
  %r28 = add i64 %r26, %r27
  store i64 %r28, ptr %slot.__for_idx_30, align 8
  br label %for_hdr30, !llvm.loop !91
for_exit32:
  %r29 = load i64, ptr %slot.output, align 8
  ret i64 %r29
}

define i64 @run_test() nounwind {
entry:
  %slot.tokens = alloca i64, align 8
  store i64 0, ptr %slot.tokens, align 8
  %slot.kind = alloca i64, align 8
  store i64 0, ptr %slot.kind, align 8
  %slot.value = alloca i64, align 8
  store i64 0, ptr %slot.value, align 8
  %slot.code = alloca i64, align 8
  store i64 0, ptr %slot.code, align 8
  %r0.p = getelementptr inbounds [16 x i8], ptr @.str.9, i64 0, i64 0
  %r0 = ptrtoint ptr %r0.p to i64
  %r1 = call i64 @tokenize(i64 %r0)
  store i64 %r1, ptr %slot.tokens, align 8
  %r2 = load i64, ptr %slot.tokens, align 8
  %r3 = call i64 @nova_rt_len_any(i64 %r2)
  %r4 = add i64 8, 0
  %r5.cmp = icmp eq i64 %r3, %r4
  %r5 = zext i1 %r5.cmp to i64
  %r6.p = getelementptr inbounds [14 x i8], ptr @.str.10, i64 0, i64 0
  %r6 = ptrtoint ptr %r6.p to i64
  %r7 = load i64, ptr %slot.tokens, align 8
  %r8 = call i64 @nova_rt_len_any(i64 %r7)
  %r9 = call i64 @nova_rt_int_to_str(i64 %r8)
  %r10 = call i64 @nova_rt_str_concat(i64 %r6, i64 %r9)
  %r11 = call i64 @nova_rt_assert(i64 %r5, i64 %r10)
  %r12 = load i64, ptr %slot.tokens, align 8
  %r13 = add i64 0, 0
  %r14 = call i64 @nova_rt_index_get(i64 %r12, i64 %r13)
  %r15.ptr = inttoptr i64 %r14 to ptr
  %r15.gep = getelementptr i64, ptr %r15.ptr, i64 0
  %r15 = load i64, ptr %r15.gep, align 8
  %r16 = add i64 210691276070, 0
  %r17.cmp = icmp eq i64 %r15, %r16
  %r17 = zext i1 %r17.cmp to i64
  %br_marm_040 = icmp ne i64 %r17, 0
  br i1 %br_marm_040, label %marm_040, label %match_fall41
marm_040:
  %r18.ptr = inttoptr i64 %r14 to ptr
  %r18.gep = getelementptr i64, ptr %r18.ptr, i64 1
  %r18 = load i64, ptr %r18.gep, align 8
  store i64 %r18, ptr %slot.kind, align 8
  %r19.ptr = inttoptr i64 %r14 to ptr
  %r19.gep = getelementptr i64, ptr %r19.ptr, i64 2
  %r19 = load i64, ptr %r19.gep, align 8
  store i64 %r19, ptr %slot.value, align 8
  %r20 = load i64, ptr %slot.kind, align 8
  %r21.p = getelementptr inbounds [5 x i8], ptr @.str.3, i64 0, i64 0
  %r21 = ptrtoint ptr %r21.p to i64
  %r22.p0 = inttoptr i64 %r20 to ptr
  %r22.p1 = inttoptr i64 %r21 to ptr
  %r22.sc = call i32 @strcmp(ptr %r22.p0, ptr %r22.p1)
  %r22.cmp = icmp eq i32 %r22.sc, 0
  %r22 = zext i1 %r22.cmp to i64
  %r23.p = getelementptr inbounds [16 x i8], ptr @.str.11, i64 0, i64 0
  %r23 = ptrtoint ptr %r23.p to i64
  %r24 = load i64, ptr %slot.kind, align 8
  %r25 = call i64 @nova_rt_str_concat(i64 %r23, i64 %r24)
  %r26 = call i64 @nova_rt_assert(i64 %r22, i64 %r25)
  %r27 = load i64, ptr %slot.value, align 8
  %r28.p = getelementptr inbounds [4 x i8], ptr @.str.12, i64 0, i64 0
  %r28 = ptrtoint ptr %r28.p to i64
  %r29.p0 = inttoptr i64 %r27 to ptr
  %r29.p1 = inttoptr i64 %r28 to ptr
  %r29.sc = call i32 @strcmp(ptr %r29.p0, ptr %r29.p1)
  %r29.cmp = icmp eq i32 %r29.sc, 0
  %r29 = zext i1 %r29.cmp to i64
  %r30.p = getelementptr inbounds [17 x i8], ptr @.str.13, i64 0, i64 0
  %r30 = ptrtoint ptr %r30.p to i64
  %r31 = load i64, ptr %slot.value, align 8
  %r32 = call i64 @nova_rt_str_concat(i64 %r30, i64 %r31)
  %r33 = call i64 @nova_rt_assert(i64 %r29, i64 %r32)
  br label %match_exit39
match_fall41:
  br label %match_exit39
match_exit39:
  %r34 = load i64, ptr %slot.tokens, align 8
  %r35 = add i64 3, 0
  %r36 = call i64 @nova_rt_index_get(i64 %r34, i64 %r35)
  %r37.ptr = inttoptr i64 %r36 to ptr
  %r37.gep = getelementptr i64, ptr %r37.ptr, i64 0
  %r37 = load i64, ptr %r37.gep, align 8
  %r38 = add i64 210691276070, 0
  %r39.cmp = icmp eq i64 %r37, %r38
  %r39 = zext i1 %r39.cmp to i64
  %br_marm_043 = icmp ne i64 %r39, 0
  br i1 %br_marm_043, label %marm_043, label %match_fall44
marm_043:
  %r40.ptr = inttoptr i64 %r36 to ptr
  %r40.gep = getelementptr i64, ptr %r40.ptr, i64 1
  %r40 = load i64, ptr %r40.gep, align 8
  store i64 %r40, ptr %slot.kind, align 8
  %r41.ptr = inttoptr i64 %r36 to ptr
  %r41.gep = getelementptr i64, ptr %r41.ptr, i64 2
  %r41 = load i64, ptr %r41.gep, align 8
  store i64 %r41, ptr %slot.value, align 8
  %r42 = load i64, ptr %slot.kind, align 8
  %r43.p = getelementptr inbounds [4 x i8], ptr @.str.8, i64 0, i64 0
  %r43 = ptrtoint ptr %r43.p to i64
  %r44.p0 = inttoptr i64 %r42 to ptr
  %r44.p1 = inttoptr i64 %r43 to ptr
  %r44.sc = call i32 @strcmp(ptr %r44.p0, ptr %r44.p1)
  %r44.cmp = icmp eq i32 %r44.sc, 0
  %r44 = zext i1 %r44.cmp to i64
  %r45.p = getelementptr inbounds [15 x i8], ptr @.str.14, i64 0, i64 0
  %r45 = ptrtoint ptr %r45.p to i64
  %r46 = load i64, ptr %slot.kind, align 8
  %r47 = call i64 @nova_rt_str_concat(i64 %r45, i64 %r46)
  %r48 = call i64 @nova_rt_assert(i64 %r44, i64 %r47)
  %r49 = load i64, ptr %slot.value, align 8
  %r50.p = getelementptr inbounds [2 x i8], ptr @.str.4, i64 0, i64 0
  %r50 = ptrtoint ptr %r50.p to i64
  %r51.p0 = inttoptr i64 %r49 to ptr
  %r51.p1 = inttoptr i64 %r50 to ptr
  %r51.sc = call i32 @strcmp(ptr %r51.p0, ptr %r51.p1)
  %r51.cmp = icmp eq i32 %r51.sc, 0
  %r51 = zext i1 %r51.cmp to i64
  %r52.p = getelementptr inbounds [14 x i8], ptr @.str.15, i64 0, i64 0
  %r52 = ptrtoint ptr %r52.p to i64
  %r53 = load i64, ptr %slot.value, align 8
  %r54 = call i64 @nova_rt_str_concat(i64 %r52, i64 %r53)
  %r55 = call i64 @nova_rt_assert(i64 %r51, i64 %r54)
  br label %match_exit42
match_fall44:
  br label %match_exit42
match_exit42:
  %r56 = load i64, ptr %slot.tokens, align 8
  %r57 = call i64 @emit_code(i64 %r56)
  store i64 %r57, ptr %slot.code, align 8
  %r58 = load i64, ptr %slot.code, align 8
  %r59.p = getelementptr inbounds [18 x i8], ptr @.str.16, i64 0, i64 0
  %r59 = ptrtoint ptr %r59.p to i64
  %r60 = call i64 @nova_rt_starts_with(i64 %r58, i64 %r59)
  %r61.p = getelementptr inbounds [10 x i8], ptr @.str.17, i64 0, i64 0
  %r61 = ptrtoint ptr %r61.p to i64
  %r62 = load i64, ptr %slot.code, align 8
  %r63 = call i64 @nova_rt_str_concat(i64 %r61, i64 %r62)
  %r64 = call i64 @nova_rt_assert(i64 %r60, i64 %r63)
  %r65.p = getelementptr inbounds [29 x i8], ptr @.str.18, i64 0, i64 0
  %r65 = ptrtoint ptr %r65.p to i64
  %r66 = call i64 @nova_rt_print_any(i64 %r65)
  %r67.p = getelementptr inbounds [9 x i8], ptr @.str.19, i64 0, i64 0
  %r67 = ptrtoint ptr %r67.p to i64
  %r68 = load i64, ptr %slot.tokens, align 8
  %r69 = call i64 @nova_rt_len_any(i64 %r68)
  %r70 = call i64 @nova_rt_int_to_str(i64 %r69)
  %r71 = call i64 @nova_rt_str_concat(i64 %r67, i64 %r70)
  %r72 = call i64 @nova_rt_print_any(i64 %r71)
  %r73.p = getelementptr inbounds [9 x i8], ptr @.str.20, i64 0, i64 0
  %r73 = ptrtoint ptr %r73.p to i64
  %r74 = load i64, ptr %slot.code, align 8
  %r75 = call i64 @nova_rt_str_concat(i64 %r73, i64 %r74)
  %r76 = call i64 @nova_rt_print_any(i64 %r75)
  ret i64 %r76
}

define i64 @nova_main() nounwind {
entry:
  %r0 = call i64 @run_test()
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
@.str.0 = private unnamed_addr constant [1 x i8] c"\00"
@.str.1 = private unnamed_addr constant [2 x i8] c" \00"
@.str.2 = private unnamed_addr constant [2 x i8] c"\0A\00"
@.str.3 = private unnamed_addr constant [5 x i8] c"word\00"
@.str.4 = private unnamed_addr constant [2 x i8] c"(\00"
@.str.5 = private unnamed_addr constant [2 x i8] c")\00"
@.str.6 = private unnamed_addr constant [2 x i8] c"+\00"
@.str.7 = private unnamed_addr constant [2 x i8] c"=\00"
@.str.8 = private unnamed_addr constant [4 x i8] c"sym\00"
@.str.9 = private unnamed_addr constant [16 x i8] c"let x = (a + b)\00"
@.str.10 = private unnamed_addr constant [14 x i8] c"token count: \00"
@.str.11 = private unnamed_addr constant [16 x i8] c"first is word: \00"
@.str.12 = private unnamed_addr constant [4 x i8] c"let\00"
@.str.13 = private unnamed_addr constant [17 x i8] c"first is 'let': \00"
@.str.14 = private unnamed_addr constant [15 x i8] c"paren is sym: \00"
@.str.15 = private unnamed_addr constant [14 x i8] c"paren value: \00"
@.str.16 = private unnamed_addr constant [18 x i8] c"let x = ( a + b )\00"
@.str.17 = private unnamed_addr constant [10 x i8] c"codegen: \00"
@.str.18 = private unnamed_addr constant [29 x i8] c"Codegen pattern test passed!\00"
@.str.19 = private unnamed_addr constant [9 x i8] c"Tokens: \00"
@.str.20 = private unnamed_addr constant [9 x i8] c"Output: \00"

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
