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

define i64 @my_map(i64 %p0, i64 %p1) nounwind {
entry:
  %slot.items = alloca i64, align 8
  store i64 %p0, ptr %slot.items, align 8
  %slot.f = alloca i64, align 8
  store i64 %p1, ptr %slot.f, align 8
  %slot.result = alloca i64, align 8
  store i64 0, ptr %slot.result, align 8
  %slot.__for_idx_0 = alloca i64, align 8
  store i64 0, ptr %slot.__for_idx_0, align 8
  %slot.item = alloca i64, align 8
  store i64 0, ptr %slot.item, align 8
  %r0 = call i64 @nova_rt_list_create()
  store i64 %r0, ptr %slot.result, align 8
  %r1 = load i64, ptr %slot.items, align 8
  %r2 = call i64 @nova_rt_len_any(i64 %r1)
  %r3 = add i64 0, 0
  store i64 %r3, ptr %slot.__for_idx_0, align 8
  br label %for_hdr0, !llvm.loop !91
for_hdr0:
  %r4 = load i64, ptr %slot.__for_idx_0, align 8
  %r5.cmp = icmp slt i64 %r4, %r2
  %r5 = zext i1 %r5.cmp to i64
  %br_for_body1 = icmp ne i64 %r5, 0
  br i1 %br_for_body1, label %for_body1, label %for_exit2, !prof !90
for_body1:
  %r6 = call i64 @nova_rt_index_get(i64 %r1, i64 %r4)
  store i64 %r6, ptr %slot.item, align 8
  %r7 = load i64, ptr %slot.result, align 8
  %r8 = load i64, ptr %slot.item, align 8
  %r10 = load i64, ptr %slot.f, align 8
  %r9.rec = inttoptr i64 %r10 to ptr
  %r9.fnraw = load i64, ptr %r9.rec, align 8
  %r9.fnptr = inttoptr i64 %r9.fnraw to ptr
  %r9 = call i64 %r9.fnptr(i64 %r10, i64 %r8)
  %r11 = call i64 @nova_rt_list_append(i64 %r7, i64 %r9)
  %r12 = load i64, ptr %slot.__for_idx_0, align 8
  %r13 = add i64 1, 0
  %r14 = add i64 %r12, %r13
  store i64 %r14, ptr %slot.__for_idx_0, align 8
  br label %for_hdr0, !llvm.loop !91
for_exit2:
  %r15 = load i64, ptr %slot.result, align 8
  ret i64 %r15
}

define i64 @my_filter(i64 %p0, i64 %p1) nounwind {
entry:
  %slot.items = alloca i64, align 8
  store i64 %p0, ptr %slot.items, align 8
  %slot.pred = alloca i64, align 8
  store i64 %p1, ptr %slot.pred, align 8
  %slot.result = alloca i64, align 8
  store i64 0, ptr %slot.result, align 8
  %slot.__for_idx_3 = alloca i64, align 8
  store i64 0, ptr %slot.__for_idx_3, align 8
  %slot.item = alloca i64, align 8
  store i64 0, ptr %slot.item, align 8
  %r0 = call i64 @nova_rt_list_create()
  store i64 %r0, ptr %slot.result, align 8
  %r1 = load i64, ptr %slot.items, align 8
  %r2 = call i64 @nova_rt_len_any(i64 %r1)
  %r3 = add i64 0, 0
  store i64 %r3, ptr %slot.__for_idx_3, align 8
  br label %for_hdr3, !llvm.loop !91
for_hdr3:
  %r4 = load i64, ptr %slot.__for_idx_3, align 8
  %r5.cmp = icmp slt i64 %r4, %r2
  %r5 = zext i1 %r5.cmp to i64
  %br_for_body4 = icmp ne i64 %r5, 0
  br i1 %br_for_body4, label %for_body4, label %for_exit5, !prof !90
for_body4:
  %r6 = call i64 @nova_rt_index_get(i64 %r1, i64 %r4)
  store i64 %r6, ptr %slot.item, align 8
  %r7 = load i64, ptr %slot.item, align 8
  %r9 = load i64, ptr %slot.pred, align 8
  %r8.rec = inttoptr i64 %r9 to ptr
  %r8.fnraw = load i64, ptr %r8.rec, align 8
  %r8.fnptr = inttoptr i64 %r8.fnraw to ptr
  %r8 = call i64 %r8.fnptr(i64 %r9, i64 %r7)
  %br_then6 = icmp ne i64 %r8, 0
  br i1 %br_then6, label %then6, label %else7
then6:
  %r10 = load i64, ptr %slot.result, align 8
  %r11 = load i64, ptr %slot.item, align 8
  %r12 = call i64 @nova_rt_list_append(i64 %r10, i64 %r11)
  br label %endif8
else7:
  br label %endif8
endif8:
  %r13 = load i64, ptr %slot.__for_idx_3, align 8
  %r14 = add i64 1, 0
  %r15 = add i64 %r13, %r14
  store i64 %r15, ptr %slot.__for_idx_3, align 8
  br label %for_hdr3, !llvm.loop !91
for_exit5:
  %r16 = load i64, ptr %slot.result, align 8
  ret i64 %r16
}

define i64 @my_reduce(i64 %p0, i64 %p1, i64 %p2) nounwind {
entry:
  %slot.items = alloca i64, align 8
  store i64 %p0, ptr %slot.items, align 8
  %slot.init = alloca i64, align 8
  store i64 %p1, ptr %slot.init, align 8
  %slot.f = alloca i64, align 8
  store i64 %p2, ptr %slot.f, align 8
  %slot.acc = alloca i64, align 8
  store i64 0, ptr %slot.acc, align 8
  %slot.__for_idx_9 = alloca i64, align 8
  store i64 0, ptr %slot.__for_idx_9, align 8
  %slot.item = alloca i64, align 8
  store i64 0, ptr %slot.item, align 8
  %r0 = load i64, ptr %slot.init, align 8
  store i64 %r0, ptr %slot.acc, align 8
  %r1 = load i64, ptr %slot.items, align 8
  %r2 = call i64 @nova_rt_len_any(i64 %r1)
  %r3 = add i64 0, 0
  store i64 %r3, ptr %slot.__for_idx_9, align 8
  br label %for_hdr9, !llvm.loop !91
for_hdr9:
  %r4 = load i64, ptr %slot.__for_idx_9, align 8
  %r5.cmp = icmp slt i64 %r4, %r2
  %r5 = zext i1 %r5.cmp to i64
  %br_for_body10 = icmp ne i64 %r5, 0
  br i1 %br_for_body10, label %for_body10, label %for_exit11, !prof !90
for_body10:
  %r6 = call i64 @nova_rt_index_get(i64 %r1, i64 %r4)
  store i64 %r6, ptr %slot.item, align 8
  %r7 = load i64, ptr %slot.acc, align 8
  %r8 = load i64, ptr %slot.item, align 8
  %r10 = load i64, ptr %slot.f, align 8
  %r9.rec = inttoptr i64 %r10 to ptr
  %r9.fnraw = load i64, ptr %r9.rec, align 8
  %r9.fnptr = inttoptr i64 %r9.fnraw to ptr
  %r9 = call i64 %r9.fnptr(i64 %r10, i64 %r7, i64 %r8)
  store i64 %r9, ptr %slot.acc, align 8
  %r11 = load i64, ptr %slot.__for_idx_9, align 8
  %r12 = add i64 1, 0
  %r13 = add i64 %r11, %r12
  store i64 %r13, ptr %slot.__for_idx_9, align 8
  br label %for_hdr9, !llvm.loop !91
for_exit11:
  %r14 = load i64, ptr %slot.acc, align 8
  ret i64 %r14
}

define i64 @test() nounwind {
entry:
  %slot.nums = alloca i64, align 8
  store i64 0, ptr %slot.nums, align 8
  %slot.doubled = alloca i64, align 8
  store i64 0, ptr %slot.doubled, align 8
  %slot.evens = alloca i64, align 8
  store i64 0, ptr %slot.evens, align 8
  %slot.total = alloca i64, align 8
  store i64 0, ptr %slot.total, align 8
  %slot.product = alloca i64, align 8
  store i64 0, ptr %slot.product, align 8
  %slot.factor = alloca i64, align 8
  store i64 0, ptr %slot.factor, align 8
  %slot.scaled = alloca i64, align 8
  store i64 0, ptr %slot.scaled, align 8
  %r1 = add i64 1, 0
  %r2 = add i64 2, 0
  %r3 = add i64 3, 0
  %r4 = add i64 4, 0
  %r5 = add i64 5, 0
  %r0 = call i64 @nova_rt_list_create()
  call i64 @nova_rt_list_append(i64 %r0, i64 %r1)
  call i64 @nova_rt_list_append(i64 %r0, i64 %r2)
  call i64 @nova_rt_list_append(i64 %r0, i64 %r3)
  call i64 @nova_rt_list_append(i64 %r0, i64 %r4)
  call i64 @nova_rt_list_append(i64 %r0, i64 %r5)
  store i64 %r0, ptr %slot.nums, align 8
  %r6 = load i64, ptr %slot.nums, align 8
  %r7.ptr = call ptr @nova_rt_struct_alloc(i64 8)
  %r7.tgep = getelementptr i64, ptr %r7.ptr, i64 0
  %r7.tfn = ptrtoint ptr @__tramp_0 to i64
  store i64 %r7.tfn, ptr %r7.tgep, align 8
  %r7 = ptrtoint ptr %r7.ptr to i64
  %r8 = call i64 @my_map(i64 %r6, i64 %r7)
  store i64 %r8, ptr %slot.doubled, align 8
  %r9 = load i64, ptr %slot.doubled, align 8
  %r10 = add i64 0, 0
  %r11 = call i64 @nova_rt_index_get(i64 %r9, i64 %r10)
  %r12 = add i64 2, 0
  %r13 = call i64 @nova_rt_eq(i64 %r11, i64 %r12)
  %r14.p = getelementptr inbounds [5 x i8], ptr @.str.0, i64 0, i64 0
  %r14 = ptrtoint ptr %r14.p to i64
  %r15 = call i64 @nova_rt_assert(i64 %r13, i64 %r14)
  %r16 = load i64, ptr %slot.doubled, align 8
  %r17 = add i64 2, 0
  %r18 = call i64 @nova_rt_index_get(i64 %r16, i64 %r17)
  %r19 = add i64 6, 0
  %r20 = call i64 @nova_rt_eq(i64 %r18, i64 %r19)
  %r21.p = getelementptr inbounds [5 x i8], ptr @.str.1, i64 0, i64 0
  %r21 = ptrtoint ptr %r21.p to i64
  %r22 = call i64 @nova_rt_assert(i64 %r20, i64 %r21)
  %r23 = load i64, ptr %slot.doubled, align 8
  %r24 = add i64 4, 0
  %r25 = call i64 @nova_rt_index_get(i64 %r23, i64 %r24)
  %r26 = add i64 10, 0
  %r27 = call i64 @nova_rt_eq(i64 %r25, i64 %r26)
  %r28.p = getelementptr inbounds [5 x i8], ptr @.str.2, i64 0, i64 0
  %r28 = ptrtoint ptr %r28.p to i64
  %r29 = call i64 @nova_rt_assert(i64 %r27, i64 %r28)
  %r30 = load i64, ptr %slot.nums, align 8
  %r31.ptr = call ptr @nova_rt_struct_alloc(i64 8)
  %r31.tgep = getelementptr i64, ptr %r31.ptr, i64 0
  %r31.tfn = ptrtoint ptr @__tramp_1 to i64
  store i64 %r31.tfn, ptr %r31.tgep, align 8
  %r31 = ptrtoint ptr %r31.ptr to i64
  %r32 = call i64 @my_filter(i64 %r30, i64 %r31)
  store i64 %r32, ptr %slot.evens, align 8
  %r33 = load i64, ptr %slot.evens, align 8
  %r34 = call i64 @nova_rt_len_any(i64 %r33)
  %r35 = add i64 2, 0
  %r36.cmp = icmp eq i64 %r34, %r35
  %r36 = zext i1 %r36.cmp to i64
  %r37.p = getelementptr inbounds [13 x i8], ptr @.str.3, i64 0, i64 0
  %r37 = ptrtoint ptr %r37.p to i64
  %r38 = call i64 @nova_rt_assert(i64 %r36, i64 %r37)
  %r39 = load i64, ptr %slot.evens, align 8
  %r40 = add i64 0, 0
  %r41 = call i64 @nova_rt_index_get(i64 %r39, i64 %r40)
  %r42 = add i64 2, 0
  %r43 = call i64 @nova_rt_eq(i64 %r41, i64 %r42)
  %r44.p = getelementptr inbounds [8 x i8], ptr @.str.4, i64 0, i64 0
  %r44 = ptrtoint ptr %r44.p to i64
  %r45 = call i64 @nova_rt_assert(i64 %r43, i64 %r44)
  %r46 = load i64, ptr %slot.evens, align 8
  %r47 = add i64 1, 0
  %r48 = call i64 @nova_rt_index_get(i64 %r46, i64 %r47)
  %r49 = add i64 4, 0
  %r50 = call i64 @nova_rt_eq(i64 %r48, i64 %r49)
  %r51.p = getelementptr inbounds [8 x i8], ptr @.str.5, i64 0, i64 0
  %r51 = ptrtoint ptr %r51.p to i64
  %r52 = call i64 @nova_rt_assert(i64 %r50, i64 %r51)
  %r53 = load i64, ptr %slot.nums, align 8
  %r54 = add i64 0, 0
  %r55.ptr = call ptr @nova_rt_struct_alloc(i64 8)
  %r55.tgep = getelementptr i64, ptr %r55.ptr, i64 0
  %r55.tfn = ptrtoint ptr @__tramp_2 to i64
  store i64 %r55.tfn, ptr %r55.tgep, align 8
  %r55 = ptrtoint ptr %r55.ptr to i64
  %r56 = call i64 @my_reduce(i64 %r53, i64 %r54, i64 %r55)
  store i64 %r56, ptr %slot.total, align 8
  %r57 = load i64, ptr %slot.total, align 8
  %r58 = add i64 15, 0
  %r59 = call i64 @nova_rt_eq(i64 %r57, i64 %r58)
  %r60.p = getelementptr inbounds [11 x i8], ptr @.str.6, i64 0, i64 0
  %r60 = ptrtoint ptr %r60.p to i64
  %r61 = call i64 @nova_rt_assert(i64 %r59, i64 %r60)
  %r62 = load i64, ptr %slot.nums, align 8
  %r63 = add i64 1, 0
  %r64.ptr = call ptr @nova_rt_struct_alloc(i64 8)
  %r64.tgep = getelementptr i64, ptr %r64.ptr, i64 0
  %r64.tfn = ptrtoint ptr @__tramp_3 to i64
  store i64 %r64.tfn, ptr %r64.tgep, align 8
  %r64 = ptrtoint ptr %r64.ptr to i64
  %r65 = call i64 @my_reduce(i64 %r62, i64 %r63, i64 %r64)
  store i64 %r65, ptr %slot.product, align 8
  %r66 = load i64, ptr %slot.product, align 8
  %r67 = add i64 120, 0
  %r68 = call i64 @nova_rt_eq(i64 %r66, i64 %r67)
  %r69.p = getelementptr inbounds [15 x i8], ptr @.str.7, i64 0, i64 0
  %r69 = ptrtoint ptr %r69.p to i64
  %r70 = call i64 @nova_rt_assert(i64 %r68, i64 %r69)
  %r71 = add i64 10, 0
  store i64 %r71, ptr %slot.factor, align 8
  %r72 = load i64, ptr %slot.nums, align 8
  %r73 = load i64, ptr %slot.factor, align 8
  %r74.ptr = call ptr @nova_rt_struct_alloc(i64 16)
  %r74.tgep = getelementptr i64, ptr %r74.ptr, i64 0
  %r74.tfn = ptrtoint ptr @__tramp_4 to i64
  store i64 %r74.tfn, ptr %r74.tgep, align 8
  %r74.c0 = getelementptr i64, ptr %r74.ptr, i64 1
  store i64 %r73, ptr %r74.c0, align 8
  %r74 = ptrtoint ptr %r74.ptr to i64
  %r75 = call i64 @my_map(i64 %r72, i64 %r74)
  store i64 %r75, ptr %slot.scaled, align 8
  %r76 = load i64, ptr %slot.scaled, align 8
  %r77 = add i64 0, 0
  %r78 = call i64 @nova_rt_index_get(i64 %r76, i64 %r77)
  %r79 = add i64 10, 0
  %r80 = call i64 @nova_rt_eq(i64 %r78, i64 %r79)
  %r81.p = getelementptr inbounds [9 x i8], ptr @.str.8, i64 0, i64 0
  %r81 = ptrtoint ptr %r81.p to i64
  %r82 = call i64 @nova_rt_assert(i64 %r80, i64 %r81)
  %r83 = load i64, ptr %slot.scaled, align 8
  %r84 = add i64 4, 0
  %r85 = call i64 @nova_rt_index_get(i64 %r83, i64 %r84)
  %r86 = add i64 50, 0
  %r87 = call i64 @nova_rt_eq(i64 %r85, i64 %r86)
  %r88.p = getelementptr inbounds [9 x i8], ptr @.str.9, i64 0, i64 0
  %r88 = ptrtoint ptr %r88.p to i64
  %r89 = call i64 @nova_rt_assert(i64 %r87, i64 %r88)
  %r90.p = getelementptr inbounds [40 x i8], ptr @.str.10, i64 0, i64 0
  %r90 = ptrtoint ptr %r90.p to i64
  %r91 = call i64 @nova_rt_print_any(i64 %r90)
  ret i64 %r91
}

define i64 @__lambda_0(i64 %p0) nounwind {
entry:
  %slot.x = alloca i64, align 8
  store i64 %p0, ptr %slot.x, align 8
  %r0 = load i64, ptr %slot.x, align 8
  %r1 = add i64 2, 0
  %r2 = mul i64 %r0, %r1
  ret i64 %r2
}

define i64 @__lambda_1(i64 %p0) nounwind {
entry:
  %slot.x = alloca i64, align 8
  store i64 %p0, ptr %slot.x, align 8
  %r0 = load i64, ptr %slot.x, align 8
  %r1 = add i64 2, 0
  %r2 = srem i64 %r0, %r1
  %r3 = add i64 0, 0
  %r4.cmp = icmp eq i64 %r2, %r3
  %r4 = zext i1 %r4.cmp to i64
  ret i64 %r4
}

define i64 @__lambda_2(i64 %p0, i64 %p1) nounwind {
entry:
  %slot.acc = alloca i64, align 8
  store i64 %p0, ptr %slot.acc, align 8
  %slot.x = alloca i64, align 8
  store i64 %p1, ptr %slot.x, align 8
  %r0 = load i64, ptr %slot.acc, align 8
  %r1 = load i64, ptr %slot.x, align 8
  %r2 = call i64 @nova_rt_add(i64 %r0, i64 %r1)
  ret i64 %r2
}

define i64 @__lambda_3(i64 %p0, i64 %p1) nounwind {
entry:
  %slot.acc = alloca i64, align 8
  store i64 %p0, ptr %slot.acc, align 8
  %slot.x = alloca i64, align 8
  store i64 %p1, ptr %slot.x, align 8
  %r0 = load i64, ptr %slot.acc, align 8
  %r1 = load i64, ptr %slot.x, align 8
  %r2 = mul i64 %r0, %r1
  ret i64 %r2
}

define i64 @__lambda_4(i64 %p0, i64 %p1) nounwind {
entry:
  %slot.factor = alloca i64, align 8
  store i64 %p0, ptr %slot.factor, align 8
  %slot.x = alloca i64, align 8
  store i64 %p1, ptr %slot.x, align 8
  %r0 = load i64, ptr %slot.x, align 8
  %r1 = load i64, ptr %slot.factor, align 8
  %r2 = mul i64 %r0, %r1
  ret i64 %r2
}

define i64 @nova_main() nounwind {
entry:
  %r0 = call i64 @test()
  ret i64 0
}

define i64 @__tramp_0(i64 %record, i64 %p0) nounwind {
entry:
  %result = call i64 @__lambda_0(i64 %p0)
  ret i64 %result
}

define i64 @__tramp_1(i64 %record, i64 %p0) nounwind {
entry:
  %result = call i64 @__lambda_1(i64 %p0)
  ret i64 %result
}

define i64 @__tramp_2(i64 %record, i64 %p0, i64 %p1) nounwind {
entry:
  %result = call i64 @__lambda_2(i64 %p0, i64 %p1)
  ret i64 %result
}

define i64 @__tramp_3(i64 %record, i64 %p0, i64 %p1) nounwind {
entry:
  %result = call i64 @__lambda_3(i64 %p0, i64 %p1)
  ret i64 %result
}

define i64 @__tramp_4(i64 %record, i64 %p0) nounwind {
entry:
  %rec_ptr = inttoptr i64 %record to ptr
  %cap0_ptr = getelementptr i64, ptr %rec_ptr, i64 1
  %cap0 = load i64, ptr %cap0_ptr, align 8
  %result = call i64 @__lambda_4(i64 %cap0, i64 %p0)
  ret i64 %result
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
@.str.0 = private unnamed_addr constant [5 x i8] c"map0\00"
@.str.1 = private unnamed_addr constant [5 x i8] c"map2\00"
@.str.2 = private unnamed_addr constant [5 x i8] c"map4\00"
@.str.3 = private unnamed_addr constant [13 x i8] c"filter count\00"
@.str.4 = private unnamed_addr constant [8 x i8] c"filter0\00"
@.str.5 = private unnamed_addr constant [8 x i8] c"filter1\00"
@.str.6 = private unnamed_addr constant [11 x i8] c"reduce sum\00"
@.str.7 = private unnamed_addr constant [15 x i8] c"reduce product\00"
@.str.8 = private unnamed_addr constant [9 x i8] c"capture0\00"
@.str.9 = private unnamed_addr constant [9 x i8] c"capture4\00"
@.str.10 = private unnamed_addr constant [40 x i8] c"Higher-order function tests: ALL PASSED\00"

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
