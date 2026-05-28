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

define i64 @make_point(i64 %p0, i64 %p1) nounwind {
entry:
  %slot.x = alloca i64, align 8
  store i64 %p0, ptr %slot.x, align 8
  %slot.y = alloca i64, align 8
  store i64 %p1, ptr %slot.y, align 8
  %r0 = load i64, ptr %slot.x, align 8
  %r1 = load i64, ptr %slot.y, align 8
  %r2.ptr = call ptr @nova_rt_struct_alloc(i64 24)
  %r2.thash = getelementptr i64, ptr %r2.ptr, i64 0
  store i64 210686530511, ptr %r2.thash, align 8
  %r2.f0 = getelementptr i64, ptr %r2.ptr, i64 1
  store i64 %r0, ptr %r2.f0, align 8
  %r2.f1 = getelementptr i64, ptr %r2.ptr, i64 2
  store i64 %r1, ptr %r2.f1, align 8
  %r2 = ptrtoint ptr %r2.ptr to i64
  ret i64 %r2
}

define i64 @point_sum(i64 %p0) nounwind {
entry:
  %slot.p = alloca i64, align 8
  store i64 %p0, ptr %slot.p, align 8
  %slot.x = alloca i64, align 8
  store i64 0, ptr %slot.x, align 8
  %slot.y = alloca i64, align 8
  store i64 0, ptr %slot.y, align 8
  %r0 = load i64, ptr %slot.p, align 8
  %r1.ptr = inttoptr i64 %r0 to ptr
  %r1.gep = getelementptr i64, ptr %r1.ptr, i64 0
  %r1 = load i64, ptr %r1.gep, align 8
  %r2 = add i64 210686530511, 0
  %r3.cmp = icmp eq i64 %r1, %r2
  %r3 = zext i1 %r3.cmp to i64
  %br_rmarm_00 = icmp ne i64 %r3, 0
  br i1 %br_rmarm_00, label %rmarm_00, label %rmatch_fall1
rmarm_00:
  %r4.ptr = inttoptr i64 %r0 to ptr
  %r4.gep = getelementptr i64, ptr %r4.ptr, i64 1
  %r4 = load i64, ptr %r4.gep, align 8
  store i64 %r4, ptr %slot.x, align 8
  %r5.ptr = inttoptr i64 %r0 to ptr
  %r5.gep = getelementptr i64, ptr %r5.ptr, i64 2
  %r5 = load i64, ptr %r5.gep, align 8
  store i64 %r5, ptr %slot.y, align 8
  %r6 = load i64, ptr %slot.x, align 8
  %r7 = load i64, ptr %slot.y, align 8
  %r8 = call i64 @nova_rt_add(i64 %r6, i64 %r7)
  ret i64 %r8
rmatch_fall1:
  ret i64 0
}

define i64 @find_first_negative(i64 %p0) nounwind {
entry:
  %slot.items = alloca i64, align 8
  store i64 %p0, ptr %slot.items, align 8
  %slot.i = alloca i64, align 8
  store i64 0, ptr %slot.i, align 8
  %r0 = add i64 0, 0
  store i64 %r0, ptr %slot.i, align 8
  br label %while_hdr2, !llvm.loop !91
while_hdr2:
  %r1 = load i64, ptr %slot.i, align 8
  %r2 = load i64, ptr %slot.items, align 8
  %r3 = call i64 @nova_rt_len_any(i64 %r2)
  %r4.cmp = icmp slt i64 %r1, %r3
  %r4 = zext i1 %r4.cmp to i64
  %br_while_body3 = icmp ne i64 %r4, 0
  br i1 %br_while_body3, label %while_body3, label %while_exit4, !prof !90
while_body3:
  %r5 = load i64, ptr %slot.items, align 8
  %r6 = load i64, ptr %slot.i, align 8
  %r7 = call i64 @nova_rt_index_get(i64 %r5, i64 %r6)
  %r8 = add i64 0, 0
  %r9.cmp = icmp slt i64 %r7, %r8
  %r9 = zext i1 %r9.cmp to i64
  %br_then5 = icmp ne i64 %r9, 0
  br i1 %br_then5, label %then5, label %else6
then5:
  %r10 = load i64, ptr %slot.items, align 8
  %r11 = load i64, ptr %slot.i, align 8
  %r12 = call i64 @nova_rt_index_get(i64 %r10, i64 %r11)
  ret i64 %r12
else6:
  br label %endif7
endif7:
  %r13 = load i64, ptr %slot.i, align 8
  %r14 = add i64 1, 0
  %r15 = add i64 %r13, %r14
  store i64 %r15, ptr %slot.i, align 8
  br label %while_hdr2, !llvm.loop !91
while_exit4:
  %r16 = add i64 0, 0
  ret i64 %r16
}

define i64 @count_positives(i64 %p0) nounwind {
entry:
  %slot.items = alloca i64, align 8
  store i64 %p0, ptr %slot.items, align 8
  %slot.count = alloca i64, align 8
  store i64 0, ptr %slot.count, align 8
  %slot.__for_idx_8 = alloca i64, align 8
  store i64 0, ptr %slot.__for_idx_8, align 8
  %slot.item = alloca i64, align 8
  store i64 0, ptr %slot.item, align 8
  %r0 = add i64 0, 0
  store i64 %r0, ptr %slot.count, align 8
  %r1 = load i64, ptr %slot.items, align 8
  %r2 = call i64 @nova_rt_len_any(i64 %r1)
  %r3 = add i64 0, 0
  store i64 %r3, ptr %slot.__for_idx_8, align 8
  br label %for_hdr8, !llvm.loop !91
for_hdr8:
  %r4 = load i64, ptr %slot.__for_idx_8, align 8
  %r5.cmp = icmp slt i64 %r4, %r2
  %r5 = zext i1 %r5.cmp to i64
  %br_for_body9 = icmp ne i64 %r5, 0
  br i1 %br_for_body9, label %for_body9, label %for_exit10, !prof !90
for_body9:
  %r6 = call i64 @nova_rt_index_get(i64 %r1, i64 %r4)
  store i64 %r6, ptr %slot.item, align 8
  %r7 = load i64, ptr %slot.item, align 8
  %r8 = add i64 0, 0
  %r9.cmp = icmp sgt i64 %r7, %r8
  %r9 = zext i1 %r9.cmp to i64
  %br_then11 = icmp ne i64 %r9, 0
  br i1 %br_then11, label %then11, label %else12
then11:
  %r10 = load i64, ptr %slot.count, align 8
  %r11 = add i64 1, 0
  %r12 = add i64 %r10, %r11
  store i64 %r12, ptr %slot.count, align 8
  br label %endif13
else12:
  br label %endif13
endif13:
  %r13 = load i64, ptr %slot.__for_idx_8, align 8
  %r14 = add i64 1, 0
  %r15 = add i64 %r13, %r14
  store i64 %r15, ptr %slot.__for_idx_8, align 8
  br label %for_hdr8, !llvm.loop !91
for_exit10:
  %r16 = load i64, ptr %slot.count, align 8
  ret i64 %r16
}

define i64 @is_alpha(i64 %p0) nounwind {
entry:
  %slot.ch = alloca i64, align 8
  store i64 %p0, ptr %slot.ch, align 8
  %slot.c = alloca i64, align 8
  store i64 0, ptr %slot.c, align 8
  %slot.__sc_14 = alloca i64, align 8
  store i64 0, ptr %slot.__sc_14, align 8
  %slot.__sc_17 = alloca i64, align 8
  store i64 0, ptr %slot.__sc_17, align 8
  %slot.__sc_20 = alloca i64, align 8
  store i64 0, ptr %slot.__sc_20, align 8
  %slot.__sc_23 = alloca i64, align 8
  store i64 0, ptr %slot.__sc_23, align 8
  %r0 = load i64, ptr %slot.ch, align 8
  %r1 = call i64 @nova_rt_ord(i64 %r0)
  store i64 %r1, ptr %slot.c, align 8
  %r2 = load i64, ptr %slot.c, align 8
  %r3 = add i64 65, 0
  %r4.cmp = icmp sge i64 %r2, %r3
  %r4 = zext i1 %r4.cmp to i64
  store i64 %r4, ptr %slot.__sc_14, align 8
  %br_and_rhs15 = icmp ne i64 %r4, 0
  br i1 %br_and_rhs15, label %and_rhs15, label %and_merge16
and_rhs15:
  %r5 = load i64, ptr %slot.c, align 8
  %r6 = add i64 90, 0
  %r7.cmp = icmp sle i64 %r5, %r6
  %r7 = zext i1 %r7.cmp to i64
  store i64 %r7, ptr %slot.__sc_14, align 8
  br label %and_merge16
and_merge16:
  %r8 = load i64, ptr %slot.__sc_14, align 8
  store i64 %r8, ptr %slot.__sc_17, align 8
  %br_or_merge19 = icmp ne i64 %r8, 0
  br i1 %br_or_merge19, label %or_merge19, label %or_rhs18
or_rhs18:
  %r9 = load i64, ptr %slot.c, align 8
  %r10 = add i64 97, 0
  %r11.cmp = icmp sge i64 %r9, %r10
  %r11 = zext i1 %r11.cmp to i64
  store i64 %r11, ptr %slot.__sc_20, align 8
  %br_and_rhs21 = icmp ne i64 %r11, 0
  br i1 %br_and_rhs21, label %and_rhs21, label %and_merge22
and_rhs21:
  %r12 = load i64, ptr %slot.c, align 8
  %r13 = add i64 122, 0
  %r14.cmp = icmp sle i64 %r12, %r13
  %r14 = zext i1 %r14.cmp to i64
  store i64 %r14, ptr %slot.__sc_20, align 8
  br label %and_merge22
and_merge22:
  %r15 = load i64, ptr %slot.__sc_20, align 8
  store i64 %r15, ptr %slot.__sc_17, align 8
  br label %or_merge19
or_merge19:
  %r16 = load i64, ptr %slot.__sc_17, align 8
  store i64 %r16, ptr %slot.__sc_23, align 8
  %br_or_merge25 = icmp ne i64 %r16, 0
  br i1 %br_or_merge25, label %or_merge25, label %or_rhs24
or_rhs24:
  %r17 = load i64, ptr %slot.ch, align 8
  %r18.p = getelementptr inbounds [2 x i8], ptr @.str.0, i64 0, i64 0
  %r18 = ptrtoint ptr %r18.p to i64
  %r19.p0 = inttoptr i64 %r17 to ptr
  %r19.p1 = inttoptr i64 %r18 to ptr
  %r19.sc = call i32 @strcmp(ptr %r19.p0, ptr %r19.p1)
  %r19.cmp = icmp eq i32 %r19.sc, 0
  %r19 = zext i1 %r19.cmp to i64
  store i64 %r19, ptr %slot.__sc_23, align 8
  br label %or_merge25
or_merge25:
  %r20 = load i64, ptr %slot.__sc_23, align 8
  ret i64 %r20
}

define i64 @tokenize_word(i64 %p0, i64 %p1) nounwind {
entry:
  %slot.s = alloca i64, align 8
  store i64 %p0, ptr %slot.s, align 8
  %slot.pos = alloca i64, align 8
  store i64 %p1, ptr %slot.pos, align 8
  %slot.word = alloca i64, align 8
  store i64 0, ptr %slot.word, align 8
  %slot.__sc_29 = alloca i64, align 8
  store i64 0, ptr %slot.__sc_29, align 8
  %r0.p = getelementptr inbounds [1 x i8], ptr @.str.1, i64 0, i64 0
  %r0 = ptrtoint ptr %r0.p to i64
  store i64 %r0, ptr %slot.word, align 8
  br label %while_hdr26, !llvm.loop !91
while_hdr26:
  %r1 = load i64, ptr %slot.pos, align 8
  %r2 = load i64, ptr %slot.s, align 8
  %r3 = call i64 @nova_rt_len_any(i64 %r2)
  %r4.cmp = icmp slt i64 %r1, %r3
  %r4 = zext i1 %r4.cmp to i64
  store i64 %r4, ptr %slot.__sc_29, align 8
  %br_and_rhs30 = icmp ne i64 %r4, 0
  br i1 %br_and_rhs30, label %and_rhs30, label %and_merge31
and_rhs30:
  %r5 = load i64, ptr %slot.s, align 8
  %r6 = load i64, ptr %slot.pos, align 8
  %r7 = call i64 @nova_rt_index_get(i64 %r5, i64 %r6)
  %r8 = call i64 @is_alpha(i64 %r7)
  store i64 %r8, ptr %slot.__sc_29, align 8
  br label %and_merge31
and_merge31:
  %r9 = load i64, ptr %slot.__sc_29, align 8
  %br_while_body27 = icmp ne i64 %r9, 0
  br i1 %br_while_body27, label %while_body27, label %while_exit28, !prof !90
while_body27:
  %r10 = load i64, ptr %slot.word, align 8
  %r11 = load i64, ptr %slot.s, align 8
  %r12 = load i64, ptr %slot.pos, align 8
  %r13 = call i64 @nova_rt_index_get(i64 %r11, i64 %r12)
  %r14 = call i64 @nova_rt_str_concat(i64 %r10, i64 %r13)
  store i64 %r14, ptr %slot.word, align 8
  %r15 = load i64, ptr %slot.pos, align 8
  %r16 = add i64 1, 0
  %r17 = add i64 %r15, %r16
  store i64 %r17, ptr %slot.pos, align 8
  br label %while_hdr26, !llvm.loop !91
while_exit28:
  %r18 = load i64, ptr %slot.word, align 8
  ret i64 %r18
}

define i64 @nova_main() nounwind {
entry:
  %slot.p = alloca i64, align 8
  store i64 0, ptr %slot.p, align 8
  %slot.nums = alloca i64, align 8
  store i64 0, ptr %slot.nums, align 8
  %slot.points = alloca i64, align 8
  store i64 0, ptr %slot.points, align 8
  %slot.total = alloca i64, align 8
  store i64 0, ptr %slot.total, align 8
  %slot.__for_idx_32 = alloca i64, align 8
  store i64 0, ptr %slot.__for_idx_32, align 8
  %slot.pt = alloca i64, align 8
  store i64 0, ptr %slot.pt, align 8
  %slot.x = alloca i64, align 8
  store i64 0, ptr %slot.x, align 8
  %slot.y = alloca i64, align 8
  store i64 0, ptr %slot.y, align 8
  %slot.found = alloca i64, align 8
  store i64 0, ptr %slot.found, align 8
  %slot.j = alloca i64, align 8
  store i64 0, ptr %slot.j, align 8
  %r0 = add i64 3, 0
  %r1 = add i64 7, 0
  %r2 = call i64 @make_point(i64 %r0, i64 %r1)
  store i64 %r2, ptr %slot.p, align 8
  %r3.p = getelementptr inbounds [12 x i8], ptr @.str.2, i64 0, i64 0
  %r3 = ptrtoint ptr %r3.p to i64
  %r4 = load i64, ptr %slot.p, align 8
  %r5 = call i64 @point_sum(i64 %r4)
  %r6 = call i64 @nova_rt_int_to_str(i64 %r5)
  %r7 = call i64 @nova_rt_str_concat(i64 %r3, i64 %r6)
  %r8 = call i64 @nova_rt_print_any(i64 %r7)
  %r10 = add i64 5, 0
  %r11 = add i64 3, 0
  %r12 = add i64 2, 0
  %r13 = sub i64 0, %r12
  %r14 = add i64 8, 0
  %r15 = add i64 1, 0
  %r16 = sub i64 0, %r15
  %r9 = call i64 @nova_rt_list_create()
  call i64 @nova_rt_list_append(i64 %r9, i64 %r10)
  call i64 @nova_rt_list_append(i64 %r9, i64 %r11)
  call i64 @nova_rt_list_append(i64 %r9, i64 %r13)
  call i64 @nova_rt_list_append(i64 %r9, i64 %r14)
  call i64 @nova_rt_list_append(i64 %r9, i64 %r16)
  store i64 %r9, ptr %slot.nums, align 8
  %r17.p = getelementptr inbounds [12 x i8], ptr @.str.3, i64 0, i64 0
  %r17 = ptrtoint ptr %r17.p to i64
  %r18 = load i64, ptr %slot.nums, align 8
  %r19 = call i64 @find_first_negative(i64 %r18)
  %r20 = call i64 @nova_rt_int_to_str(i64 %r19)
  %r21 = call i64 @nova_rt_str_concat(i64 %r17, i64 %r20)
  %r22 = call i64 @nova_rt_print_any(i64 %r21)
  %r23.p = getelementptr inbounds [12 x i8], ptr @.str.4, i64 0, i64 0
  %r23 = ptrtoint ptr %r23.p to i64
  %r24 = load i64, ptr %slot.nums, align 8
  %r25 = call i64 @count_positives(i64 %r24)
  %r26 = call i64 @nova_rt_int_to_str(i64 %r25)
  %r27 = call i64 @nova_rt_str_concat(i64 %r23, i64 %r26)
  %r28 = call i64 @nova_rt_print_any(i64 %r27)
  %r29.p = getelementptr inbounds [14 x i8], ptr @.str.5, i64 0, i64 0
  %r29 = ptrtoint ptr %r29.p to i64
  %r30.p = getelementptr inbounds [2 x i8], ptr @.str.6, i64 0, i64 0
  %r30 = ptrtoint ptr %r30.p to i64
  %r31 = call i64 @is_alpha(i64 %r30)
  %r32 = call i64 @nova_rt_int_to_str(i64 %r31)
  %r33 = call i64 @nova_rt_str_concat(i64 %r29, i64 %r32)
  %r34 = call i64 @nova_rt_print_any(i64 %r33)
  %r35.p = getelementptr inbounds [14 x i8], ptr @.str.7, i64 0, i64 0
  %r35 = ptrtoint ptr %r35.p to i64
  %r36.p = getelementptr inbounds [2 x i8], ptr @.str.8, i64 0, i64 0
  %r36 = ptrtoint ptr %r36.p to i64
  %r37 = call i64 @is_alpha(i64 %r36)
  %r38 = call i64 @nova_rt_int_to_str(i64 %r37)
  %r39 = call i64 @nova_rt_str_concat(i64 %r35, i64 %r38)
  %r40 = call i64 @nova_rt_print_any(i64 %r39)
  %r41.p = getelementptr inbounds [7 x i8], ptr @.str.9, i64 0, i64 0
  %r41 = ptrtoint ptr %r41.p to i64
  %r42.p = getelementptr inbounds [12 x i8], ptr @.str.10, i64 0, i64 0
  %r42 = ptrtoint ptr %r42.p to i64
  %r43 = add i64 0, 0
  %r44 = call i64 @tokenize_word(i64 %r42, i64 %r43)
  %r45 = call i64 @nova_rt_str_concat(i64 %r41, i64 %r44)
  %r46 = call i64 @nova_rt_print_any(i64 %r45)
  %r48 = add i64 1, 0
  %r49 = add i64 2, 0
  %r50 = call i64 @make_point(i64 %r48, i64 %r49)
  %r51 = add i64 3, 0
  %r52 = add i64 4, 0
  %r53 = call i64 @make_point(i64 %r51, i64 %r52)
  %r54 = add i64 5, 0
  %r55 = add i64 6, 0
  %r56 = call i64 @make_point(i64 %r54, i64 %r55)
  %r47 = call i64 @nova_rt_list_create()
  call i64 @nova_rt_list_append(i64 %r47, i64 %r50)
  call i64 @nova_rt_list_append(i64 %r47, i64 %r53)
  call i64 @nova_rt_list_append(i64 %r47, i64 %r56)
  store i64 %r47, ptr %slot.points, align 8
  %r57 = add i64 0, 0
  store i64 %r57, ptr %slot.total, align 8
  %r58 = load i64, ptr %slot.points, align 8
  %r59 = call i64 @nova_rt_len_any(i64 %r58)
  %r60 = add i64 0, 0
  store i64 %r60, ptr %slot.__for_idx_32, align 8
  br label %for_hdr32, !llvm.loop !91
for_hdr32:
  %r61 = load i64, ptr %slot.__for_idx_32, align 8
  %r62.cmp = icmp slt i64 %r61, %r59
  %r62 = zext i1 %r62.cmp to i64
  %br_for_body33 = icmp ne i64 %r62, 0
  br i1 %br_for_body33, label %for_body33, label %for_exit34, !prof !90
for_body33:
  %r63.lp = inttoptr i64 %r58 to ptr
  %r63.dp = load ptr, ptr %r63.lp, align 8, !tbaa !2
  %r63.ep = getelementptr i64, ptr %r63.dp, i64 %r61
  %r63 = load i64, ptr %r63.ep, align 8, !tbaa !4
  store i64 %r63, ptr %slot.pt, align 8
  %r64 = load i64, ptr %slot.pt, align 8
  %r65.ptr = inttoptr i64 %r64 to ptr
  %r65.gep = getelementptr i64, ptr %r65.ptr, i64 0
  %r65 = load i64, ptr %r65.gep, align 8
  %r66 = add i64 210686530511, 0
  %r67.cmp = icmp eq i64 %r65, %r66
  %r67 = zext i1 %r67.cmp to i64
  %br_marm_036 = icmp ne i64 %r67, 0
  br i1 %br_marm_036, label %marm_036, label %match_fall37
marm_036:
  %r68.ptr = inttoptr i64 %r64 to ptr
  %r68.gep = getelementptr i64, ptr %r68.ptr, i64 1
  %r68 = load i64, ptr %r68.gep, align 8
  store i64 %r68, ptr %slot.x, align 8
  %r69.ptr = inttoptr i64 %r64 to ptr
  %r69.gep = getelementptr i64, ptr %r69.ptr, i64 2
  %r69 = load i64, ptr %r69.gep, align 8
  store i64 %r69, ptr %slot.y, align 8
  %r70 = load i64, ptr %slot.total, align 8
  %r71 = load i64, ptr %slot.x, align 8
  %r72 = call i64 @nova_rt_add(i64 %r70, i64 %r71)
  %r73 = load i64, ptr %slot.y, align 8
  %r74 = call i64 @nova_rt_add(i64 %r72, i64 %r73)
  store i64 %r74, ptr %slot.total, align 8
  br label %match_exit35
match_fall37:
  br label %match_exit35
match_exit35:
  %r75 = load i64, ptr %slot.__for_idx_32, align 8
  %r76 = add i64 1, 0
  %r77 = add i64 %r75, %r76
  store i64 %r77, ptr %slot.__for_idx_32, align 8
  br label %for_hdr32, !llvm.loop !91
for_exit34:
  %r78.p = getelementptr inbounds [8 x i8], ptr @.str.11, i64 0, i64 0
  %r78 = ptrtoint ptr %r78.p to i64
  %r79 = load i64, ptr %slot.total, align 8
  %r80 = call i64 @nova_rt_int_to_str(i64 %r79)
  %r81 = call i64 @nova_rt_str_concat(i64 %r78, i64 %r80)
  %r82 = call i64 @nova_rt_print_any(i64 %r81)
  %r83 = add i64 1, 0
  %r84 = sub i64 0, %r83
  store i64 %r84, ptr %slot.found, align 8
  %r85 = add i64 0, 0
  store i64 %r85, ptr %slot.j, align 8
  br label %while_hdr38, !llvm.loop !91
while_hdr38:
  %r86 = load i64, ptr %slot.j, align 8
  %r87 = load i64, ptr %slot.nums, align 8
  %r88 = call i64 @nova_rt_len_any(i64 %r87)
  %r89.cmp = icmp slt i64 %r86, %r88
  %r89 = zext i1 %r89.cmp to i64
  %br_while_body39 = icmp ne i64 %r89, 0
  br i1 %br_while_body39, label %while_body39, label %while_exit40, !prof !90
while_body39:
  %r90 = load i64, ptr %slot.nums, align 8
  %r91 = load i64, ptr %slot.j, align 8
  %r92.lp = inttoptr i64 %r90 to ptr
  %r92.dp = load ptr, ptr %r92.lp, align 8, !tbaa !2
  %r92.ep = getelementptr i64, ptr %r92.dp, i64 %r91
  %r92 = load i64, ptr %r92.ep, align 8, !tbaa !4
  %r93 = add i64 0, 0
  %r94.cmp = icmp slt i64 %r92, %r93
  %r94 = zext i1 %r94.cmp to i64
  %br_then41 = icmp ne i64 %r94, 0
  br i1 %br_then41, label %then41, label %else42
then41:
  %r95 = load i64, ptr %slot.nums, align 8
  %r96 = load i64, ptr %slot.j, align 8
  %r97.lp = inttoptr i64 %r95 to ptr
  %r97.dp = load ptr, ptr %r97.lp, align 8, !tbaa !2
  %r97.ep = getelementptr i64, ptr %r97.dp, i64 %r96
  %r97 = load i64, ptr %r97.ep, align 8, !tbaa !4
  store i64 %r97, ptr %slot.found, align 8
  br label %while_exit40
else42:
  br label %endif43
endif43:
  %r98 = load i64, ptr %slot.j, align 8
  %r99 = add i64 1, 0
  %r100 = add i64 %r98, %r99
  store i64 %r100, ptr %slot.j, align 8
  br label %while_hdr38, !llvm.loop !91
while_exit40:
  %r101.p = getelementptr inbounds [8 x i8], ptr @.str.12, i64 0, i64 0
  %r101 = ptrtoint ptr %r101.p to i64
  %r102 = load i64, ptr %slot.found, align 8
  %r103 = call i64 @nova_rt_int_to_str(i64 %r102)
  %r104 = call i64 @nova_rt_str_concat(i64 %r101, i64 %r103)
  %r105 = call i64 @nova_rt_print_any(i64 %r104)
  %r106.p = getelementptr inbounds [5 x i8], ptr @.str.13, i64 0, i64 0
  %r106 = ptrtoint ptr %r106.p to i64
  %r107 = call i64 @nova_rt_print_any(i64 %r106)
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
@.str.0 = private unnamed_addr constant [2 x i8] c"_\00"
@.str.1 = private unnamed_addr constant [1 x i8] c"\00"
@.str.2 = private unnamed_addr constant [12 x i8] c"point_sum: \00"
@.str.3 = private unnamed_addr constant [12 x i8] c"first neg: \00"
@.str.4 = private unnamed_addr constant [12 x i8] c"positives: \00"
@.str.5 = private unnamed_addr constant [14 x i8] c"is_alpha(a): \00"
@.str.6 = private unnamed_addr constant [2 x i8] c"a\00"
@.str.7 = private unnamed_addr constant [14 x i8] c"is_alpha(1): \00"
@.str.8 = private unnamed_addr constant [2 x i8] c"1\00"
@.str.9 = private unnamed_addr constant [7 x i8] c"word: \00"
@.str.10 = private unnamed_addr constant [12 x i8] c"hello world\00"
@.str.11 = private unnamed_addr constant [8 x i8] c"total: \00"
@.str.12 = private unnamed_addr constant [8 x i8] c"found: \00"
@.str.13 = private unnamed_addr constant [5 x i8] c"PASS\00"

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
