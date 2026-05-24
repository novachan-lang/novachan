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

define i64 @nt_int() nounwind {
entry:
  %r0.p = getelementptr inbounds [4 x i8], ptr @.str.0, i64 0, i64 0
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

define i64 @nt_float() nounwind {
entry:
  %r0.p = getelementptr inbounds [6 x i8], ptr @.str.2, i64 0, i64 0
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

define i64 @nt_string() nounwind {
entry:
  %r0.p = getelementptr inbounds [7 x i8], ptr @.str.3, i64 0, i64 0
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

define i64 @nt_bool() nounwind {
entry:
  %r0.p = getelementptr inbounds [5 x i8], ptr @.str.4, i64 0, i64 0
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

define i64 @nt_unit() nounwind {
entry:
  %r0.p = getelementptr inbounds [5 x i8], ptr @.str.5, i64 0, i64 0
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

define i64 @nt_any() nounwind {
entry:
  %r0.p = getelementptr inbounds [4 x i8], ptr @.str.6, i64 0, i64 0
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

define i64 @nt_var(i64 %p0) nounwind {
entry:
  %slot.vid = alloca i64, align 8
  store i64 %p0, ptr %slot.vid, align 8
  %r0.p = getelementptr inbounds [4 x i8], ptr @.str.7, i64 0, i64 0
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

define i64 @nt_fn(i64 %p0, i64 %p1) nounwind {
entry:
  %slot.p = alloca i64, align 8
  store i64 %p0, ptr %slot.p, align 8
  %slot.ret = alloca i64, align 8
  store i64 %p1, ptr %slot.ret, align 8
  %slot.combined = alloca i64, align 8
  store i64 0, ptr %slot.combined, align 8
  %slot.__for_idx_0 = alloca i64, align 8
  store i64 0, ptr %slot.__for_idx_0, align 8
  %slot.x = alloca i64, align 8
  store i64 0, ptr %slot.x, align 8
  %r0 = call i64 @nova_rt_list_create()
  store i64 %r0, ptr %slot.combined, align 8
  %r1 = load i64, ptr %slot.p, align 8
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
  %r6.lp = inttoptr i64 %r1 to ptr
  %r6.dp = load ptr, ptr %r6.lp, align 8, !tbaa !2
  %r6.ep = getelementptr i64, ptr %r6.dp, i64 %r4
  %r6 = load i64, ptr %r6.ep, align 8, !tbaa !4
  store i64 %r6, ptr %slot.x, align 8
  %r7 = load i64, ptr %slot.combined, align 8
  %r8 = load i64, ptr %slot.x, align 8
  %r9 = call i64 @nova_rt_list_append(i64 %r7, i64 %r8)
  %r10 = load i64, ptr %slot.__for_idx_0, align 8
  %r11 = add i64 1, 0
  %r12 = add i64 %r10, %r11
  store i64 %r12, ptr %slot.__for_idx_0, align 8
  br label %for_hdr0, !llvm.loop !91
for_exit2:
  %r13 = load i64, ptr %slot.combined, align 8
  %r14 = load i64, ptr %slot.ret, align 8
  %r15 = call i64 @nova_rt_list_append(i64 %r13, i64 %r14)
  %r16.p = getelementptr inbounds [3 x i8], ptr @.str.8, i64 0, i64 0
  %r16 = ptrtoint ptr %r16.p to i64
  %r17.p = getelementptr inbounds [1 x i8], ptr @.str.1, i64 0, i64 0
  %r17 = ptrtoint ptr %r17.p to i64
  %r18 = load i64, ptr %slot.combined, align 8
  %r19 = add i64 0, 0
  %r20.ptr = call ptr @nova_rt_struct_alloc(i64 40)
  %r20.thash = getelementptr i64, ptr %r20.ptr, i64 0
  store i64 210683205845, ptr %r20.thash, align 8
  %r20.f0 = getelementptr i64, ptr %r20.ptr, i64 1
  store i64 %r16, ptr %r20.f0, align 8
  %r20.f1 = getelementptr i64, ptr %r20.ptr, i64 2
  store i64 %r17, ptr %r20.f1, align 8
  %r20.f2 = getelementptr i64, ptr %r20.ptr, i64 3
  store i64 %r18, ptr %r20.f2, align 8
  %r20.f3 = getelementptr i64, ptr %r20.ptr, i64 4
  store i64 %r19, ptr %r20.f3, align 8
  %r20 = ptrtoint ptr %r20.ptr to i64
  ret i64 %r20
}

define i64 @nt_list(i64 %p0) nounwind {
entry:
  %slot.elem = alloca i64, align 8
  store i64 %p0, ptr %slot.elem, align 8
  %r0.p = getelementptr inbounds [5 x i8], ptr @.str.9, i64 0, i64 0
  %r0 = ptrtoint ptr %r0.p to i64
  %r1.p = getelementptr inbounds [1 x i8], ptr @.str.1, i64 0, i64 0
  %r1 = ptrtoint ptr %r1.p to i64
  %r3 = load i64, ptr %slot.elem, align 8
  %r2 = call i64 @nova_rt_list_create()
  call i64 @nova_rt_list_append(i64 %r2, i64 %r3)
  %r4 = add i64 0, 0
  %r5.ptr = call ptr @nova_rt_struct_alloc(i64 40)
  %r5.thash = getelementptr i64, ptr %r5.ptr, i64 0
  store i64 210683205845, ptr %r5.thash, align 8
  %r5.f0 = getelementptr i64, ptr %r5.ptr, i64 1
  store i64 %r0, ptr %r5.f0, align 8
  %r5.f1 = getelementptr i64, ptr %r5.ptr, i64 2
  store i64 %r1, ptr %r5.f1, align 8
  %r5.f2 = getelementptr i64, ptr %r5.ptr, i64 3
  store i64 %r2, ptr %r5.f2, align 8
  %r5.f3 = getelementptr i64, ptr %r5.ptr, i64 4
  store i64 %r4, ptr %r5.f3, align 8
  %r5 = ptrtoint ptr %r5.ptr to i64
  ret i64 %r5
}

define i64 @ti_build_stdlib() nounwind {
entry:
  %slot.reg = alloca i64, align 8
  store i64 0, ptr %slot.reg, align 8
  %slot.T = alloca i64, align 8
  store i64 0, ptr %slot.T, align 8
  %slot.U = alloca i64, align 8
  store i64 0, ptr %slot.U, align 8
  %r0 = call i64 @nova_rt_dict_create()
  store i64 %r0, ptr %slot.reg, align 8
  %r1 = add i64 1, 0
  %r2 = sub i64 0, %r1
  %r3 = call i64 @nt_var(i64 %r2)
  store i64 %r3, ptr %slot.T, align 8
  %r4 = add i64 2, 0
  %r5 = sub i64 0, %r4
  %r6 = call i64 @nt_var(i64 %r5)
  store i64 %r6, ptr %slot.U, align 8
  %r8 = add i64 1, 0
  %r9 = sub i64 0, %r8
  %r7 = call i64 @nova_rt_list_create()
  call i64 @nova_rt_list_append(i64 %r7, i64 %r9)
  %r11 = load i64, ptr %slot.T, align 8
  %r10 = call i64 @nova_rt_list_create()
  call i64 @nova_rt_list_append(i64 %r10, i64 %r11)
  %r12 = call i64 @nt_unit()
  %r13 = call i64 @nt_fn(i64 %r10, i64 %r12)
  %r14.ptr = call ptr @nova_rt_struct_alloc(i64 24)
  %r14.thash = getelementptr i64, ptr %r14.ptr, i64 0
  store i64 -4610549147222700502, ptr %r14.thash, align 8
  %r14.f0 = getelementptr i64, ptr %r14.ptr, i64 1
  store i64 %r7, ptr %r14.f0, align 8
  %r14.f1 = getelementptr i64, ptr %r14.ptr, i64 2
  store i64 %r13, ptr %r14.f1, align 8
  %r14 = ptrtoint ptr %r14.ptr to i64
  %r15 = load i64, ptr %slot.reg, align 8
  %r16.p = getelementptr inbounds [6 x i8], ptr @.str.10, i64 0, i64 0
  %r16 = ptrtoint ptr %r16.p to i64
  call i64 @nova_rt_index_set(i64 %r15, i64 %r16, i64 %r14)
  %r17 = call i64 @nova_rt_list_create()
  %r18 = call i64 @nova_rt_list_create()
  %r19 = call i64 @nt_string()
  %r20 = call i64 @nt_fn(i64 %r18, i64 %r19)
  %r21.ptr = call ptr @nova_rt_struct_alloc(i64 24)
  %r21.thash = getelementptr i64, ptr %r21.ptr, i64 0
  store i64 -4610549147222700502, ptr %r21.thash, align 8
  %r21.f0 = getelementptr i64, ptr %r21.ptr, i64 1
  store i64 %r17, ptr %r21.f0, align 8
  %r21.f1 = getelementptr i64, ptr %r21.ptr, i64 2
  store i64 %r20, ptr %r21.f1, align 8
  %r21 = ptrtoint ptr %r21.ptr to i64
  %r22 = load i64, ptr %slot.reg, align 8
  %r23.p = getelementptr inbounds [6 x i8], ptr @.str.11, i64 0, i64 0
  %r23 = ptrtoint ptr %r23.p to i64
  call i64 @nova_rt_index_set(i64 %r22, i64 %r23, i64 %r21)
  %r25 = add i64 1, 0
  %r26 = sub i64 0, %r25
  %r24 = call i64 @nova_rt_list_create()
  call i64 @nova_rt_list_append(i64 %r24, i64 %r26)
  %r28 = load i64, ptr %slot.T, align 8
  %r27 = call i64 @nova_rt_list_create()
  call i64 @nova_rt_list_append(i64 %r27, i64 %r28)
  %r29 = call i64 @nt_string()
  %r30 = call i64 @nt_fn(i64 %r27, i64 %r29)
  %r31.ptr = call ptr @nova_rt_struct_alloc(i64 24)
  %r31.thash = getelementptr i64, ptr %r31.ptr, i64 0
  store i64 -4610549147222700502, ptr %r31.thash, align 8
  %r31.f0 = getelementptr i64, ptr %r31.ptr, i64 1
  store i64 %r24, ptr %r31.f0, align 8
  %r31.f1 = getelementptr i64, ptr %r31.ptr, i64 2
  store i64 %r30, ptr %r31.f1, align 8
  %r31 = ptrtoint ptr %r31.ptr to i64
  %r32 = load i64, ptr %slot.reg, align 8
  %r33.p = getelementptr inbounds [4 x i8], ptr @.str.12, i64 0, i64 0
  %r33 = ptrtoint ptr %r33.p to i64
  call i64 @nova_rt_index_set(i64 %r32, i64 %r33, i64 %r31)
  %r35 = add i64 1, 0
  %r36 = sub i64 0, %r35
  %r34 = call i64 @nova_rt_list_create()
  call i64 @nova_rt_list_append(i64 %r34, i64 %r36)
  %r38 = load i64, ptr %slot.T, align 8
  %r37 = call i64 @nova_rt_list_create()
  call i64 @nova_rt_list_append(i64 %r37, i64 %r38)
  %r39 = call i64 @nt_int()
  %r40 = call i64 @nt_fn(i64 %r37, i64 %r39)
  %r41.ptr = call ptr @nova_rt_struct_alloc(i64 24)
  %r41.thash = getelementptr i64, ptr %r41.ptr, i64 0
  store i64 -4610549147222700502, ptr %r41.thash, align 8
  %r41.f0 = getelementptr i64, ptr %r41.ptr, i64 1
  store i64 %r34, ptr %r41.f0, align 8
  %r41.f1 = getelementptr i64, ptr %r41.ptr, i64 2
  store i64 %r40, ptr %r41.f1, align 8
  %r41 = ptrtoint ptr %r41.ptr to i64
  %r42 = load i64, ptr %slot.reg, align 8
  %r43.p = getelementptr inbounds [4 x i8], ptr @.str.0, i64 0, i64 0
  %r43 = ptrtoint ptr %r43.p to i64
  call i64 @nova_rt_index_set(i64 %r42, i64 %r43, i64 %r41)
  %r45 = add i64 1, 0
  %r46 = sub i64 0, %r45
  %r44 = call i64 @nova_rt_list_create()
  call i64 @nova_rt_list_append(i64 %r44, i64 %r46)
  %r48 = load i64, ptr %slot.T, align 8
  %r47 = call i64 @nova_rt_list_create()
  call i64 @nova_rt_list_append(i64 %r47, i64 %r48)
  %r49 = call i64 @nt_float()
  %r50 = call i64 @nt_fn(i64 %r47, i64 %r49)
  %r51.ptr = call ptr @nova_rt_struct_alloc(i64 24)
  %r51.thash = getelementptr i64, ptr %r51.ptr, i64 0
  store i64 -4610549147222700502, ptr %r51.thash, align 8
  %r51.f0 = getelementptr i64, ptr %r51.ptr, i64 1
  store i64 %r44, ptr %r51.f0, align 8
  %r51.f1 = getelementptr i64, ptr %r51.ptr, i64 2
  store i64 %r50, ptr %r51.f1, align 8
  %r51 = ptrtoint ptr %r51.ptr to i64
  %r52 = load i64, ptr %slot.reg, align 8
  %r53.p = getelementptr inbounds [6 x i8], ptr @.str.2, i64 0, i64 0
  %r53 = ptrtoint ptr %r53.p to i64
  call i64 @nova_rt_index_set(i64 %r52, i64 %r53, i64 %r51)
  %r55 = add i64 1, 0
  %r56 = sub i64 0, %r55
  %r54 = call i64 @nova_rt_list_create()
  call i64 @nova_rt_list_append(i64 %r54, i64 %r56)
  %r58 = load i64, ptr %slot.T, align 8
  %r57 = call i64 @nova_rt_list_create()
  call i64 @nova_rt_list_append(i64 %r57, i64 %r58)
  %r59 = call i64 @nt_int()
  %r60 = call i64 @nt_fn(i64 %r57, i64 %r59)
  %r61.ptr = call ptr @nova_rt_struct_alloc(i64 24)
  %r61.thash = getelementptr i64, ptr %r61.ptr, i64 0
  store i64 -4610549147222700502, ptr %r61.thash, align 8
  %r61.f0 = getelementptr i64, ptr %r61.ptr, i64 1
  store i64 %r54, ptr %r61.f0, align 8
  %r61.f1 = getelementptr i64, ptr %r61.ptr, i64 2
  store i64 %r60, ptr %r61.f1, align 8
  %r61 = ptrtoint ptr %r61.ptr to i64
  %r62 = load i64, ptr %slot.reg, align 8
  %r63.p = getelementptr inbounds [4 x i8], ptr @.str.13, i64 0, i64 0
  %r63 = ptrtoint ptr %r63.p to i64
  call i64 @nova_rt_index_set(i64 %r62, i64 %r63, i64 %r61)
  %r65 = add i64 1, 0
  %r66 = sub i64 0, %r65
  %r64 = call i64 @nova_rt_list_create()
  call i64 @nova_rt_list_append(i64 %r64, i64 %r66)
  %r68 = load i64, ptr %slot.T, align 8
  %r69 = call i64 @nt_list(i64 %r68)
  %r70 = load i64, ptr %slot.T, align 8
  %r67 = call i64 @nova_rt_list_create()
  call i64 @nova_rt_list_append(i64 %r67, i64 %r69)
  call i64 @nova_rt_list_append(i64 %r67, i64 %r70)
  %r71 = call i64 @nt_unit()
  %r72 = call i64 @nt_fn(i64 %r67, i64 %r71)
  %r73.ptr = call ptr @nova_rt_struct_alloc(i64 24)
  %r73.thash = getelementptr i64, ptr %r73.ptr, i64 0
  store i64 -4610549147222700502, ptr %r73.thash, align 8
  %r73.f0 = getelementptr i64, ptr %r73.ptr, i64 1
  store i64 %r64, ptr %r73.f0, align 8
  %r73.f1 = getelementptr i64, ptr %r73.ptr, i64 2
  store i64 %r72, ptr %r73.f1, align 8
  %r73 = ptrtoint ptr %r73.ptr to i64
  %r74 = load i64, ptr %slot.reg, align 8
  %r75.p = getelementptr inbounds [5 x i8], ptr @.str.14, i64 0, i64 0
  %r75 = ptrtoint ptr %r75.p to i64
  call i64 @nova_rt_index_set(i64 %r74, i64 %r75, i64 %r73)
  %r76 = call i64 @nova_rt_list_create()
  %r78 = call i64 @nt_string()
  %r77 = call i64 @nova_rt_list_create()
  call i64 @nova_rt_list_append(i64 %r77, i64 %r78)
  %r79 = call i64 @nt_int()
  %r80 = call i64 @nt_fn(i64 %r77, i64 %r79)
  %r81.ptr = call ptr @nova_rt_struct_alloc(i64 24)
  %r81.thash = getelementptr i64, ptr %r81.ptr, i64 0
  store i64 -4610549147222700502, ptr %r81.thash, align 8
  %r81.f0 = getelementptr i64, ptr %r81.ptr, i64 1
  store i64 %r76, ptr %r81.f0, align 8
  %r81.f1 = getelementptr i64, ptr %r81.ptr, i64 2
  store i64 %r80, ptr %r81.f1, align 8
  %r81 = ptrtoint ptr %r81.ptr to i64
  %r82 = load i64, ptr %slot.reg, align 8
  %r83.p = getelementptr inbounds [4 x i8], ptr @.str.15, i64 0, i64 0
  %r83 = ptrtoint ptr %r83.p to i64
  call i64 @nova_rt_index_set(i64 %r82, i64 %r83, i64 %r81)
  %r84 = call i64 @nova_rt_list_create()
  %r86 = call i64 @nt_int()
  %r85 = call i64 @nova_rt_list_create()
  call i64 @nova_rt_list_append(i64 %r85, i64 %r86)
  %r87 = call i64 @nt_string()
  %r88 = call i64 @nt_fn(i64 %r85, i64 %r87)
  %r89.ptr = call ptr @nova_rt_struct_alloc(i64 24)
  %r89.thash = getelementptr i64, ptr %r89.ptr, i64 0
  store i64 -4610549147222700502, ptr %r89.thash, align 8
  %r89.f0 = getelementptr i64, ptr %r89.ptr, i64 1
  store i64 %r84, ptr %r89.f0, align 8
  %r89.f1 = getelementptr i64, ptr %r89.ptr, i64 2
  store i64 %r88, ptr %r89.f1, align 8
  %r89 = ptrtoint ptr %r89.ptr to i64
  %r90 = load i64, ptr %slot.reg, align 8
  %r91.p = getelementptr inbounds [4 x i8], ptr @.str.16, i64 0, i64 0
  %r91 = ptrtoint ptr %r91.p to i64
  call i64 @nova_rt_index_set(i64 %r90, i64 %r91, i64 %r89)
  %r92 = load i64, ptr %slot.reg, align 8
  ret i64 %r92
}

define i64 @ti_subst(i64 %p0, i64 %p1) nounwind {
entry:
  %slot.t = alloca i64, align 8
  store i64 %p0, ptr %slot.t, align 8
  %slot.subst = alloca i64, align 8
  store i64 %p1, ptr %slot.subst, align 8
  %slot.kind = alloca i64, align 8
  store i64 0, ptr %slot.kind, align 8
  %slot.name = alloca i64, align 8
  store i64 0, ptr %slot.name, align 8
  %slot.params = alloca i64, align 8
  store i64 0, ptr %slot.params, align 8
  %slot.id = alloca i64, align 8
  store i64 0, ptr %slot.id, align 8
  %slot.key = alloca i64, align 8
  store i64 0, ptr %slot.key, align 8
  %slot.np = alloca i64, align 8
  store i64 0, ptr %slot.np, align 8
  %slot.__for_idx_15 = alloca i64, align 8
  store i64 0, ptr %slot.__for_idx_15, align 8
  %slot.p = alloca i64, align 8
  store i64 0, ptr %slot.p, align 8
  %r0 = load i64, ptr %slot.t, align 8
  %r1.ptr = inttoptr i64 %r0 to ptr
  %r1.gep = getelementptr i64, ptr %r1.ptr, i64 0
  %r1 = load i64, ptr %r1.gep, align 8
  %r2 = add i64 210683205845, 0
  %r3.cmp = icmp eq i64 %r1, %r2
  %r3 = zext i1 %r3.cmp to i64
  %br_marm_04 = icmp ne i64 %r3, 0
  br i1 %br_marm_04, label %marm_04, label %match_fall5
marm_04:
  %r4.ptr = inttoptr i64 %r0 to ptr
  %r4.gep = getelementptr i64, ptr %r4.ptr, i64 1
  %r4 = load i64, ptr %r4.gep, align 8
  store i64 %r4, ptr %slot.kind, align 8
  %r5.ptr = inttoptr i64 %r0 to ptr
  %r5.gep = getelementptr i64, ptr %r5.ptr, i64 2
  %r5 = load i64, ptr %r5.gep, align 8
  store i64 %r5, ptr %slot.name, align 8
  %r6.ptr = inttoptr i64 %r0 to ptr
  %r6.gep = getelementptr i64, ptr %r6.ptr, i64 3
  %r6 = load i64, ptr %r6.gep, align 8
  store i64 %r6, ptr %slot.params, align 8
  %r7.ptr = inttoptr i64 %r0 to ptr
  %r7.gep = getelementptr i64, ptr %r7.ptr, i64 4
  %r7 = load i64, ptr %r7.gep, align 8
  store i64 %r7, ptr %slot.id, align 8
  %r8 = load i64, ptr %slot.kind, align 8
  %r9.p = getelementptr inbounds [4 x i8], ptr @.str.7, i64 0, i64 0
  %r9 = ptrtoint ptr %r9.p to i64
  %r10.p0 = inttoptr i64 %r8 to ptr
  %r10.p1 = inttoptr i64 %r9 to ptr
  %r10.sc = call i32 @strcmp(ptr %r10.p0, ptr %r10.p1)
  %r10.cmp = icmp eq i32 %r10.sc, 0
  %r10 = zext i1 %r10.cmp to i64
  %br_then6 = icmp ne i64 %r10, 0
  br i1 %br_then6, label %then6, label %else7
then6:
  %r11 = load i64, ptr %slot.id, align 8
  %r12 = call i64 @nova_rt_int_to_str(i64 %r11)
  store i64 %r12, ptr %slot.key, align 8
  %r13 = load i64, ptr %slot.subst, align 8
  %r14 = load i64, ptr %slot.key, align 8
  %r15 = call i64 @nova_rt_contains(i64 %r13, i64 %r14)
  %br_then9 = icmp ne i64 %r15, 0
  br i1 %br_then9, label %then9, label %else10
then9:
  %r16 = load i64, ptr %slot.subst, align 8
  %r17 = load i64, ptr %slot.key, align 8
  %r18 = call i64 @nova_rt_dict_get(i64 %r16, i64 %r17)
  ret i64 %r18
else10:
  br label %endif11
endif11:
  %r19 = load i64, ptr %slot.t, align 8
  ret i64 %r19
else7:
  br label %endif8
endif8:
  %r20 = load i64, ptr %slot.params, align 8
  %r21 = call i64 @nova_rt_len_any(i64 %r20)
  %r22 = add i64 0, 0
  %r23.cmp = icmp eq i64 %r21, %r22
  %r23 = zext i1 %r23.cmp to i64
  %br_then12 = icmp ne i64 %r23, 0
  br i1 %br_then12, label %then12, label %else13
then12:
  %r24 = load i64, ptr %slot.t, align 8
  ret i64 %r24
else13:
  br label %endif14
endif14:
  %r25 = call i64 @nova_rt_list_create()
  store i64 %r25, ptr %slot.np, align 8
  %r26 = load i64, ptr %slot.params, align 8
  %r27 = call i64 @nova_rt_len_any(i64 %r26)
  %r28 = add i64 0, 0
  store i64 %r28, ptr %slot.__for_idx_15, align 8
  br label %for_hdr15, !llvm.loop !91
for_hdr15:
  %r29 = load i64, ptr %slot.__for_idx_15, align 8
  %r30.cmp = icmp slt i64 %r29, %r27
  %r30 = zext i1 %r30.cmp to i64
  %br_for_body16 = icmp ne i64 %r30, 0
  br i1 %br_for_body16, label %for_body16, label %for_exit17, !prof !90
for_body16:
  %r31 = call i64 @nova_rt_index_get(i64 %r26, i64 %r29)
  store i64 %r31, ptr %slot.p, align 8
  %r32 = load i64, ptr %slot.np, align 8
  %r33 = load i64, ptr %slot.p, align 8
  %r34 = load i64, ptr %slot.subst, align 8
  %r35 = call i64 @ti_subst(i64 %r33, i64 %r34)
  %r36 = call i64 @nova_rt_list_append(i64 %r32, i64 %r35)
  %r37 = load i64, ptr %slot.__for_idx_15, align 8
  %r38 = add i64 1, 0
  %r39 = add i64 %r37, %r38
  store i64 %r39, ptr %slot.__for_idx_15, align 8
  br label %for_hdr15, !llvm.loop !91
for_exit17:
  %r40 = load i64, ptr %slot.kind, align 8
  %r41 = load i64, ptr %slot.name, align 8
  %r42 = load i64, ptr %slot.np, align 8
  %r43 = load i64, ptr %slot.id, align 8
  %r44.ptr = call ptr @nova_rt_struct_alloc(i64 40)
  %r44.thash = getelementptr i64, ptr %r44.ptr, i64 0
  store i64 210683205845, ptr %r44.thash, align 8
  %r44.f0 = getelementptr i64, ptr %r44.ptr, i64 1
  store i64 %r40, ptr %r44.f0, align 8
  %r44.f1 = getelementptr i64, ptr %r44.ptr, i64 2
  store i64 %r41, ptr %r44.f1, align 8
  %r44.f2 = getelementptr i64, ptr %r44.ptr, i64 3
  store i64 %r42, ptr %r44.f2, align 8
  %r44.f3 = getelementptr i64, ptr %r44.ptr, i64 4
  store i64 %r43, ptr %r44.f3, align 8
  %r44 = ptrtoint ptr %r44.ptr to i64
  ret i64 %r44
match_fall5:
  br label %match_exit3
match_exit3:
  %r45 = load i64, ptr %slot.t, align 8
  ret i64 %r45
}

define i64 @test_ntype() nounwind {
entry:
  %slot.t1 = alloca i64, align 8
  store i64 0, ptr %slot.t1, align 8
  %slot.t2 = alloca i64, align 8
  store i64 0, ptr %slot.t2, align 8
  %slot.t3 = alloca i64, align 8
  store i64 0, ptr %slot.t3, align 8
  %slot.t4 = alloca i64, align 8
  store i64 0, ptr %slot.t4, align 8
  %slot.t5 = alloca i64, align 8
  store i64 0, ptr %slot.t5, align 8
  %slot.k = alloca i64, align 8
  store i64 0, ptr %slot.k, align 8
  %slot.n = alloca i64, align 8
  store i64 0, ptr %slot.n, align 8
  %slot.p = alloca i64, align 8
  store i64 0, ptr %slot.p, align 8
  %slot.i = alloca i64, align 8
  store i64 0, ptr %slot.i, align 8
  %slot.scheme = alloca i64, align 8
  store i64 0, ptr %slot.scheme, align 8
  %slot.q = alloca i64, align 8
  store i64 0, ptr %slot.q, align 8
  %slot.b = alloca i64, align 8
  store i64 0, ptr %slot.b, align 8
  %slot.stdlib = alloca i64, align 8
  store i64 0, ptr %slot.stdlib, align 8
  %slot.sub = alloca i64, align 8
  store i64 0, ptr %slot.sub, align 8
  %slot.result = alloca i64, align 8
  store i64 0, ptr %slot.result, align 8
  %r0.p = getelementptr inbounds [26 x i8], ptr @.str.17, i64 0, i64 0
  %r0 = ptrtoint ptr %r0.p to i64
  %r1 = call i64 @nova_rt_print_any(i64 %r0)
  %r2 = call i64 @nt_int()
  store i64 %r2, ptr %slot.t1, align 8
  %r3 = call i64 @nt_string()
  store i64 %r3, ptr %slot.t2, align 8
  %r4 = call i64 @nt_unit()
  store i64 %r4, ptr %slot.t3, align 8
  %r5 = add i64 1, 0
  %r6 = sub i64 0, %r5
  %r7 = call i64 @nt_var(i64 %r6)
  store i64 %r7, ptr %slot.t4, align 8
  %r8 = add i64 2, 0
  %r9 = sub i64 0, %r8
  %r10 = call i64 @nt_var(i64 %r9)
  store i64 %r10, ptr %slot.t5, align 8
  %r11 = load i64, ptr %slot.t1, align 8
  %r12.ptr = inttoptr i64 %r11 to ptr
  %r12.gep = getelementptr i64, ptr %r12.ptr, i64 0
  %r12 = load i64, ptr %r12.gep, align 8
  %r13 = add i64 210683205845, 0
  %r14.cmp = icmp eq i64 %r12, %r13
  %r14 = zext i1 %r14.cmp to i64
  %br_marm_019 = icmp ne i64 %r14, 0
  br i1 %br_marm_019, label %marm_019, label %match_fall20
marm_019:
  %r15.ptr = inttoptr i64 %r11 to ptr
  %r15.gep = getelementptr i64, ptr %r15.ptr, i64 1
  %r15 = load i64, ptr %r15.gep, align 8
  store i64 %r15, ptr %slot.k, align 8
  %r16.ptr = inttoptr i64 %r11 to ptr
  %r16.gep = getelementptr i64, ptr %r16.ptr, i64 2
  %r16 = load i64, ptr %r16.gep, align 8
  store i64 %r16, ptr %slot.n, align 8
  %r17.ptr = inttoptr i64 %r11 to ptr
  %r17.gep = getelementptr i64, ptr %r17.ptr, i64 3
  %r17 = load i64, ptr %r17.gep, align 8
  store i64 %r17, ptr %slot.p, align 8
  %r18.ptr = inttoptr i64 %r11 to ptr
  %r18.gep = getelementptr i64, ptr %r18.ptr, i64 4
  %r18 = load i64, ptr %r18.gep, align 8
  store i64 %r18, ptr %slot.i, align 8
  %r19.p = getelementptr inbounds [10 x i8], ptr @.str.18, i64 0, i64 0
  %r19 = ptrtoint ptr %r19.p to i64
  %r20 = load i64, ptr %slot.k, align 8
  %r21 = call i64 @nova_rt_str_concat(i64 %r19, i64 %r20)
  %r22 = call i64 @nova_rt_print_any(i64 %r21)
  br label %match_exit18
match_fall20:
  br label %match_exit18
match_exit18:
  %r23 = load i64, ptr %slot.t4, align 8
  %r24.ptr = inttoptr i64 %r23 to ptr
  %r24.gep = getelementptr i64, ptr %r24.ptr, i64 0
  %r24 = load i64, ptr %r24.gep, align 8
  %r25 = add i64 210683205845, 0
  %r26.cmp = icmp eq i64 %r24, %r25
  %r26 = zext i1 %r26.cmp to i64
  %br_marm_022 = icmp ne i64 %r26, 0
  br i1 %br_marm_022, label %marm_022, label %match_fall23
marm_022:
  %r27.ptr = inttoptr i64 %r23 to ptr
  %r27.gep = getelementptr i64, ptr %r27.ptr, i64 1
  %r27 = load i64, ptr %r27.gep, align 8
  store i64 %r27, ptr %slot.k, align 8
  %r28.ptr = inttoptr i64 %r23 to ptr
  %r28.gep = getelementptr i64, ptr %r28.ptr, i64 2
  %r28 = load i64, ptr %r28.gep, align 8
  store i64 %r28, ptr %slot.n, align 8
  %r29.ptr = inttoptr i64 %r23 to ptr
  %r29.gep = getelementptr i64, ptr %r29.ptr, i64 3
  %r29 = load i64, ptr %r29.gep, align 8
  store i64 %r29, ptr %slot.p, align 8
  %r30.ptr = inttoptr i64 %r23 to ptr
  %r30.gep = getelementptr i64, ptr %r30.ptr, i64 4
  %r30 = load i64, ptr %r30.gep, align 8
  store i64 %r30, ptr %slot.i, align 8
  %r31.p = getelementptr inbounds [10 x i8], ptr @.str.19, i64 0, i64 0
  %r31 = ptrtoint ptr %r31.p to i64
  %r32 = load i64, ptr %slot.k, align 8
  %r33 = call i64 @nova_rt_str_concat(i64 %r31, i64 %r32)
  %r34.p = getelementptr inbounds [6 x i8], ptr @.str.20, i64 0, i64 0
  %r34 = ptrtoint ptr %r34.p to i64
  %r35 = call i64 @nova_rt_str_concat(i64 %r33, i64 %r34)
  %r36 = load i64, ptr %slot.i, align 8
  %r37 = call i64 @nova_rt_int_to_str(i64 %r36)
  %r38 = call i64 @nova_rt_str_concat(i64 %r35, i64 %r37)
  %r39 = call i64 @nova_rt_print_any(i64 %r38)
  br label %match_exit21
match_fall23:
  br label %match_exit21
match_exit21:
  %r41 = add i64 1, 0
  %r42 = sub i64 0, %r41
  %r40 = call i64 @nova_rt_list_create()
  call i64 @nova_rt_list_append(i64 %r40, i64 %r42)
  %r44 = load i64, ptr %slot.t4, align 8
  %r43 = call i64 @nova_rt_list_create()
  call i64 @nova_rt_list_append(i64 %r43, i64 %r44)
  %r45 = load i64, ptr %slot.t3, align 8
  %r46 = call i64 @nt_fn(i64 %r43, i64 %r45)
  %r47.ptr = call ptr @nova_rt_struct_alloc(i64 24)
  %r47.thash = getelementptr i64, ptr %r47.ptr, i64 0
  store i64 -4610549147222700502, ptr %r47.thash, align 8
  %r47.f0 = getelementptr i64, ptr %r47.ptr, i64 1
  store i64 %r40, ptr %r47.f0, align 8
  %r47.f1 = getelementptr i64, ptr %r47.ptr, i64 2
  store i64 %r46, ptr %r47.f1, align 8
  %r47 = ptrtoint ptr %r47.ptr to i64
  store i64 %r47, ptr %slot.scheme, align 8
  %r48 = load i64, ptr %slot.scheme, align 8
  %r49.ptr = inttoptr i64 %r48 to ptr
  %r49.gep = getelementptr i64, ptr %r49.ptr, i64 0
  %r49 = load i64, ptr %r49.gep, align 8
  %r50 = add i64 -4610549147222700502, 0
  %r51.cmp = icmp eq i64 %r49, %r50
  %r51 = zext i1 %r51.cmp to i64
  %br_marm_025 = icmp ne i64 %r51, 0
  br i1 %br_marm_025, label %marm_025, label %match_fall26
marm_025:
  %r52.ptr = inttoptr i64 %r48 to ptr
  %r52.gep = getelementptr i64, ptr %r52.ptr, i64 1
  %r52 = load i64, ptr %r52.gep, align 8
  store i64 %r52, ptr %slot.q, align 8
  %r53.ptr = inttoptr i64 %r48 to ptr
  %r53.gep = getelementptr i64, ptr %r53.ptr, i64 2
  %r53 = load i64, ptr %r53.gep, align 8
  store i64 %r53, ptr %slot.b, align 8
  %r54 = load i64, ptr %slot.b, align 8
  %r55.ptr = inttoptr i64 %r54 to ptr
  %r55.gep = getelementptr i64, ptr %r55.ptr, i64 0
  %r55 = load i64, ptr %r55.gep, align 8
  %r56 = add i64 210683205845, 0
  %r57.cmp = icmp eq i64 %r55, %r56
  %r57 = zext i1 %r57.cmp to i64
  %br_marm_028 = icmp ne i64 %r57, 0
  br i1 %br_marm_028, label %marm_028, label %match_fall29
marm_028:
  %r58.ptr = inttoptr i64 %r54 to ptr
  %r58.gep = getelementptr i64, ptr %r58.ptr, i64 1
  %r58 = load i64, ptr %r58.gep, align 8
  store i64 %r58, ptr %slot.k, align 8
  %r59.ptr = inttoptr i64 %r54 to ptr
  %r59.gep = getelementptr i64, ptr %r59.ptr, i64 2
  %r59 = load i64, ptr %r59.gep, align 8
  store i64 %r59, ptr %slot.n, align 8
  %r60.ptr = inttoptr i64 %r54 to ptr
  %r60.gep = getelementptr i64, ptr %r60.ptr, i64 3
  %r60 = load i64, ptr %r60.gep, align 8
  store i64 %r60, ptr %slot.p, align 8
  %r61.ptr = inttoptr i64 %r54 to ptr
  %r61.gep = getelementptr i64, ptr %r61.ptr, i64 4
  %r61 = load i64, ptr %r61.gep, align 8
  store i64 %r61, ptr %slot.i, align 8
  %r62.p = getelementptr inbounds [19 x i8], ptr @.str.21, i64 0, i64 0
  %r62 = ptrtoint ptr %r62.p to i64
  %r63 = load i64, ptr %slot.k, align 8
  %r64 = call i64 @nova_rt_str_concat(i64 %r62, i64 %r63)
  %r65 = call i64 @nova_rt_print_any(i64 %r64)
  br label %match_exit27
match_fall29:
  br label %match_exit27
match_exit27:
  br label %match_exit24
match_fall26:
  br label %match_exit24
match_exit24:
  %r66.p = getelementptr inbounds [19 x i8], ptr @.str.22, i64 0, i64 0
  %r66 = ptrtoint ptr %r66.p to i64
  %r67 = call i64 @nova_rt_print_any(i64 %r66)
  %r68 = call i64 @ti_build_stdlib()
  store i64 %r68, ptr %slot.stdlib, align 8
  %r69.p = getelementptr inbounds [19 x i8], ptr @.str.23, i64 0, i64 0
  %r69 = ptrtoint ptr %r69.p to i64
  %r70 = load i64, ptr %slot.stdlib, align 8
  %r71 = call i64 @nova_rt_len_any(i64 %r70)
  %r72 = call i64 @nova_rt_int_to_str(i64 %r71)
  %r73 = call i64 @nova_rt_str_concat(i64 %r69, i64 %r72)
  %r74.p = getelementptr inbounds [9 x i8], ptr @.str.24, i64 0, i64 0
  %r74 = ptrtoint ptr %r74.p to i64
  %r75 = call i64 @nova_rt_str_concat(i64 %r73, i64 %r74)
  %r76 = call i64 @nova_rt_print_any(i64 %r75)
  %r77 = call i64 @nova_rt_dict_create()
  store i64 %r77, ptr %slot.sub, align 8
  %r78 = call i64 @nt_int()
  %r79 = load i64, ptr %slot.sub, align 8
  %r80.p = getelementptr inbounds [3 x i8], ptr @.str.25, i64 0, i64 0
  %r80 = ptrtoint ptr %r80.p to i64
  call i64 @nova_rt_index_set(i64 %r79, i64 %r80, i64 %r78)
  %r81 = add i64 1, 0
  %r82 = sub i64 0, %r81
  %r83 = call i64 @nt_var(i64 %r82)
  %r84 = load i64, ptr %slot.sub, align 8
  %r85 = call i64 @ti_subst(i64 %r83, i64 %r84)
  store i64 %r85, ptr %slot.result, align 8
  %r86 = load i64, ptr %slot.result, align 8
  %r87.ptr = inttoptr i64 %r86 to ptr
  %r87.gep = getelementptr i64, ptr %r87.ptr, i64 0
  %r87 = load i64, ptr %r87.gep, align 8
  %r88 = add i64 210683205845, 0
  %r89.cmp = icmp eq i64 %r87, %r88
  %r89 = zext i1 %r89.cmp to i64
  %br_marm_031 = icmp ne i64 %r89, 0
  br i1 %br_marm_031, label %marm_031, label %match_fall32
marm_031:
  %r90.ptr = inttoptr i64 %r86 to ptr
  %r90.gep = getelementptr i64, ptr %r90.ptr, i64 1
  %r90 = load i64, ptr %r90.gep, align 8
  store i64 %r90, ptr %slot.k, align 8
  %r91.ptr = inttoptr i64 %r86 to ptr
  %r91.gep = getelementptr i64, ptr %r91.ptr, i64 2
  %r91 = load i64, ptr %r91.gep, align 8
  store i64 %r91, ptr %slot.n, align 8
  %r92.ptr = inttoptr i64 %r86 to ptr
  %r92.gep = getelementptr i64, ptr %r92.ptr, i64 3
  %r92 = load i64, ptr %r92.gep, align 8
  store i64 %r92, ptr %slot.p, align 8
  %r93.ptr = inttoptr i64 %r86 to ptr
  %r93.gep = getelementptr i64, ptr %r93.ptr, i64 4
  %r93 = load i64, ptr %r93.gep, align 8
  store i64 %r93, ptr %slot.i, align 8
  %r94.p = getelementptr inbounds [14 x i8], ptr @.str.26, i64 0, i64 0
  %r94 = ptrtoint ptr %r94.p to i64
  %r95 = load i64, ptr %slot.k, align 8
  %r96 = call i64 @nova_rt_str_concat(i64 %r94, i64 %r95)
  %r97 = call i64 @nova_rt_print_any(i64 %r96)
  br label %match_exit30
match_fall32:
  br label %match_exit30
match_exit30:
  %r98.p = getelementptr inbounds [24 x i8], ptr @.str.27, i64 0, i64 0
  %r98 = ptrtoint ptr %r98.p to i64
  %r99 = call i64 @nova_rt_print_any(i64 %r98)
  ret i64 %r99
}

define i64 @test_expr_stmt() nounwind {
entry:
  %slot.e = alloca i64, align 8
  store i64 0, ptr %slot.e, align 8
  %slot.tag = alloca i64, align 8
  store i64 0, ptr %slot.tag, align 8
  %slot.value = alloca i64, align 8
  store i64 0, ptr %slot.value, align 8
  %slot.num = alloca i64, align 8
  store i64 0, ptr %slot.num, align 8
  %slot.children = alloca i64, align 8
  store i64 0, ptr %slot.children, align 8
  %slot.fields = alloca i64, align 8
  store i64 0, ptr %slot.fields, align 8
  %slot.eline = alloca i64, align 8
  store i64 0, ptr %slot.eline, align 8
  %slot.null_e = alloca i64, align 8
  store i64 0, ptr %slot.null_e, align 8
  %slot.s = alloca i64, align 8
  store i64 0, ptr %slot.s, align 8
  %slot.name = alloca i64, align 8
  store i64 0, ptr %slot.name, align 8
  %slot.expr = alloca i64, align 8
  store i64 0, ptr %slot.expr, align 8
  %slot.body = alloca i64, align 8
  store i64 0, ptr %slot.body, align 8
  %slot.params = alloca i64, align 8
  store i64 0, ptr %slot.params, align 8
  %slot.else_body = alloca i64, align 8
  store i64 0, ptr %slot.else_body, align 8
  %slot.annotations = alloca i64, align 8
  store i64 0, ptr %slot.annotations, align 8
  %slot.sline = alloca i64, align 8
  store i64 0, ptr %slot.sline, align 8
  %r0.p = getelementptr inbounds [6 x i8], ptr @.str.28, i64 0, i64 0
  %r0 = ptrtoint ptr %r0.p to i64
  %r1.p = getelementptr inbounds [2 x i8], ptr @.str.29, i64 0, i64 0
  %r1 = ptrtoint ptr %r1.p to i64
  %r2 = add i64 0, 0
  %r3 = call i64 @nova_rt_list_create()
  %r4 = call i64 @nova_rt_list_create()
  %r5 = add i64 42, 0
  %r6.ptr = call ptr @nova_rt_struct_alloc(i64 56)
  %r6.thash = getelementptr i64, ptr %r6.ptr, i64 0
  store i64 6384055044, ptr %r6.thash, align 8
  %r6.f0 = getelementptr i64, ptr %r6.ptr, i64 1
  store i64 %r0, ptr %r6.f0, align 8
  %r6.f1 = getelementptr i64, ptr %r6.ptr, i64 2
  store i64 %r1, ptr %r6.f1, align 8
  %r6.f2 = getelementptr i64, ptr %r6.ptr, i64 3
  store i64 %r2, ptr %r6.f2, align 8
  %r6.f3 = getelementptr i64, ptr %r6.ptr, i64 4
  store i64 %r3, ptr %r6.f3, align 8
  %r6.f4 = getelementptr i64, ptr %r6.ptr, i64 5
  store i64 %r4, ptr %r6.f4, align 8
  %r6.f5 = getelementptr i64, ptr %r6.ptr, i64 6
  store i64 %r5, ptr %r6.f5, align 8
  %r6 = ptrtoint ptr %r6.ptr to i64
  store i64 %r6, ptr %slot.e, align 8
  %r7 = load i64, ptr %slot.e, align 8
  %r8.ptr = inttoptr i64 %r7 to ptr
  %r8.gep = getelementptr i64, ptr %r8.ptr, i64 0
  %r8 = load i64, ptr %r8.gep, align 8
  %r9 = add i64 6384055044, 0
  %r10.cmp = icmp eq i64 %r8, %r9
  %r10 = zext i1 %r10.cmp to i64
  %br_marm_034 = icmp ne i64 %r10, 0
  br i1 %br_marm_034, label %marm_034, label %match_fall35
marm_034:
  %r11.ptr = inttoptr i64 %r7 to ptr
  %r11.gep = getelementptr i64, ptr %r11.ptr, i64 1
  %r11 = load i64, ptr %r11.gep, align 8
  store i64 %r11, ptr %slot.tag, align 8
  %r12.ptr = inttoptr i64 %r7 to ptr
  %r12.gep = getelementptr i64, ptr %r12.ptr, i64 2
  %r12 = load i64, ptr %r12.gep, align 8
  store i64 %r12, ptr %slot.value, align 8
  %r13.ptr = inttoptr i64 %r7 to ptr
  %r13.gep = getelementptr i64, ptr %r13.ptr, i64 3
  %r13 = load i64, ptr %r13.gep, align 8
  store i64 %r13, ptr %slot.num, align 8
  %r14.ptr = inttoptr i64 %r7 to ptr
  %r14.gep = getelementptr i64, ptr %r14.ptr, i64 4
  %r14 = load i64, ptr %r14.gep, align 8
  store i64 %r14, ptr %slot.children, align 8
  %r15.ptr = inttoptr i64 %r7 to ptr
  %r15.gep = getelementptr i64, ptr %r15.ptr, i64 5
  %r15 = load i64, ptr %r15.gep, align 8
  store i64 %r15, ptr %slot.fields, align 8
  %r16.ptr = inttoptr i64 %r7 to ptr
  %r16.gep = getelementptr i64, ptr %r16.ptr, i64 6
  %r16 = load i64, ptr %r16.gep, align 8
  store i64 %r16, ptr %slot.eline, align 8
  %r17.p = getelementptr inbounds [11 x i8], ptr @.str.30, i64 0, i64 0
  %r17 = ptrtoint ptr %r17.p to i64
  %r18 = load i64, ptr %slot.tag, align 8
  %r19 = call i64 @nova_rt_str_concat(i64 %r17, i64 %r18)
  %r20.p = getelementptr inbounds [9 x i8], ptr @.str.31, i64 0, i64 0
  %r20 = ptrtoint ptr %r20.p to i64
  %r21 = call i64 @nova_rt_str_concat(i64 %r19, i64 %r20)
  %r22 = load i64, ptr %slot.eline, align 8
  %r23 = call i64 @nova_rt_int_to_str(i64 %r22)
  %r24 = call i64 @nova_rt_str_concat(i64 %r21, i64 %r23)
  %r25 = call i64 @nova_rt_print_any(i64 %r24)
  br label %match_exit33
match_fall35:
  br label %match_exit33
match_exit33:
  %r26.p = getelementptr inbounds [5 x i8], ptr @.str.32, i64 0, i64 0
  %r26 = ptrtoint ptr %r26.p to i64
  %r27.p = getelementptr inbounds [1 x i8], ptr @.str.1, i64 0, i64 0
  %r27 = ptrtoint ptr %r27.p to i64
  %r28 = add i64 0, 0
  %r29 = call i64 @nova_rt_list_create()
  %r30 = call i64 @nova_rt_list_create()
  %r31 = add i64 0, 0
  %r32.ptr = call ptr @nova_rt_struct_alloc(i64 56)
  %r32.thash = getelementptr i64, ptr %r32.ptr, i64 0
  store i64 6384055044, ptr %r32.thash, align 8
  %r32.f0 = getelementptr i64, ptr %r32.ptr, i64 1
  store i64 %r26, ptr %r32.f0, align 8
  %r32.f1 = getelementptr i64, ptr %r32.ptr, i64 2
  store i64 %r27, ptr %r32.f1, align 8
  %r32.f2 = getelementptr i64, ptr %r32.ptr, i64 3
  store i64 %r28, ptr %r32.f2, align 8
  %r32.f3 = getelementptr i64, ptr %r32.ptr, i64 4
  store i64 %r29, ptr %r32.f3, align 8
  %r32.f4 = getelementptr i64, ptr %r32.ptr, i64 5
  store i64 %r30, ptr %r32.f4, align 8
  %r32.f5 = getelementptr i64, ptr %r32.ptr, i64 6
  store i64 %r31, ptr %r32.f5, align 8
  %r32 = ptrtoint ptr %r32.ptr to i64
  store i64 %r32, ptr %slot.null_e, align 8
  %r33.p = getelementptr inbounds [4 x i8], ptr @.str.33, i64 0, i64 0
  %r33 = ptrtoint ptr %r33.p to i64
  %r34.p = getelementptr inbounds [2 x i8], ptr @.str.29, i64 0, i64 0
  %r34 = ptrtoint ptr %r34.p to i64
  %r35 = load i64, ptr %slot.null_e, align 8
  %r36 = call i64 @nova_rt_list_create()
  %r37 = call i64 @nova_rt_list_create()
  %r38 = call i64 @nova_rt_list_create()
  %r39 = call i64 @nova_rt_list_create()
  %r40 = add i64 10, 0
  %r41.ptr = call ptr @nova_rt_struct_alloc(i64 72)
  %r41.thash = getelementptr i64, ptr %r41.ptr, i64 0
  store i64 6384553709, ptr %r41.thash, align 8
  %r41.f0 = getelementptr i64, ptr %r41.ptr, i64 1
  store i64 %r33, ptr %r41.f0, align 8
  %r41.f1 = getelementptr i64, ptr %r41.ptr, i64 2
  store i64 %r34, ptr %r41.f1, align 8
  %r41.f2 = getelementptr i64, ptr %r41.ptr, i64 3
  store i64 %r35, ptr %r41.f2, align 8
  %r41.f3 = getelementptr i64, ptr %r41.ptr, i64 4
  store i64 %r36, ptr %r41.f3, align 8
  %r41.f4 = getelementptr i64, ptr %r41.ptr, i64 5
  store i64 %r37, ptr %r41.f4, align 8
  %r41.f5 = getelementptr i64, ptr %r41.ptr, i64 6
  store i64 %r38, ptr %r41.f5, align 8
  %r41.f6 = getelementptr i64, ptr %r41.ptr, i64 7
  store i64 %r39, ptr %r41.f6, align 8
  %r41.f7 = getelementptr i64, ptr %r41.ptr, i64 8
  store i64 %r40, ptr %r41.f7, align 8
  %r41 = ptrtoint ptr %r41.ptr to i64
  store i64 %r41, ptr %slot.s, align 8
  %r42 = load i64, ptr %slot.s, align 8
  %r43.ptr = inttoptr i64 %r42 to ptr
  %r43.gep = getelementptr i64, ptr %r43.ptr, i64 0
  %r43 = load i64, ptr %r43.gep, align 8
  %r44 = add i64 6384553709, 0
  %r45.cmp = icmp eq i64 %r43, %r44
  %r45 = zext i1 %r45.cmp to i64
  %br_marm_037 = icmp ne i64 %r45, 0
  br i1 %br_marm_037, label %marm_037, label %match_fall38
marm_037:
  %r46.ptr = inttoptr i64 %r42 to ptr
  %r46.gep = getelementptr i64, ptr %r46.ptr, i64 1
  %r46 = load i64, ptr %r46.gep, align 8
  store i64 %r46, ptr %slot.tag, align 8
  %r47.ptr = inttoptr i64 %r42 to ptr
  %r47.gep = getelementptr i64, ptr %r47.ptr, i64 2
  %r47 = load i64, ptr %r47.gep, align 8
  store i64 %r47, ptr %slot.name, align 8
  %r48.ptr = inttoptr i64 %r42 to ptr
  %r48.gep = getelementptr i64, ptr %r48.ptr, i64 3
  %r48 = load i64, ptr %r48.gep, align 8
  store i64 %r48, ptr %slot.expr, align 8
  %r49.ptr = inttoptr i64 %r42 to ptr
  %r49.gep = getelementptr i64, ptr %r49.ptr, i64 4
  %r49 = load i64, ptr %r49.gep, align 8
  store i64 %r49, ptr %slot.body, align 8
  %r50.ptr = inttoptr i64 %r42 to ptr
  %r50.gep = getelementptr i64, ptr %r50.ptr, i64 5
  %r50 = load i64, ptr %r50.gep, align 8
  store i64 %r50, ptr %slot.params, align 8
  %r51.ptr = inttoptr i64 %r42 to ptr
  %r51.gep = getelementptr i64, ptr %r51.ptr, i64 6
  %r51 = load i64, ptr %r51.gep, align 8
  store i64 %r51, ptr %slot.else_body, align 8
  %r52.ptr = inttoptr i64 %r42 to ptr
  %r52.gep = getelementptr i64, ptr %r52.ptr, i64 7
  %r52 = load i64, ptr %r52.gep, align 8
  store i64 %r52, ptr %slot.annotations, align 8
  %r53.ptr = inttoptr i64 %r42 to ptr
  %r53.gep = getelementptr i64, ptr %r53.ptr, i64 8
  %r53 = load i64, ptr %r53.gep, align 8
  store i64 %r53, ptr %slot.sline, align 8
  %r54.p = getelementptr inbounds [11 x i8], ptr @.str.34, i64 0, i64 0
  %r54 = ptrtoint ptr %r54.p to i64
  %r55 = load i64, ptr %slot.tag, align 8
  %r56 = call i64 @nova_rt_str_concat(i64 %r54, i64 %r55)
  %r57.p = getelementptr inbounds [9 x i8], ptr @.str.35, i64 0, i64 0
  %r57 = ptrtoint ptr %r57.p to i64
  %r58 = call i64 @nova_rt_str_concat(i64 %r56, i64 %r57)
  %r59 = load i64, ptr %slot.sline, align 8
  %r60 = call i64 @nova_rt_int_to_str(i64 %r59)
  %r61 = call i64 @nova_rt_str_concat(i64 %r58, i64 %r60)
  %r62 = call i64 @nova_rt_print_any(i64 %r61)
  br label %match_exit36
match_fall38:
  br label %match_exit36
match_exit36:
  %r63.p = getelementptr inbounds [24 x i8], ptr @.str.36, i64 0, i64 0
  %r63 = ptrtoint ptr %r63.p to i64
  %r64 = call i64 @nova_rt_print_any(i64 %r63)
  ret i64 %r64
}

define i64 @test_token() nounwind {
entry:
  %slot.tok = alloca i64, align 8
  store i64 0, ptr %slot.tok, align 8
  %slot.kind = alloca i64, align 8
  store i64 0, ptr %slot.kind, align 8
  %slot.value = alloca i64, align 8
  store i64 0, ptr %slot.value, align 8
  %slot.line = alloca i64, align 8
  store i64 0, ptr %slot.line, align 8
  %slot.col = alloca i64, align 8
  store i64 0, ptr %slot.col, align 8
  %r0.p = getelementptr inbounds [6 x i8], ptr @.str.37, i64 0, i64 0
  %r0 = ptrtoint ptr %r0.p to i64
  %r1.p = getelementptr inbounds [6 x i8], ptr @.str.38, i64 0, i64 0
  %r1 = ptrtoint ptr %r1.p to i64
  %r2 = add i64 1, 0
  %r3 = add i64 5, 0
  %r4.ptr = call ptr @nova_rt_struct_alloc(i64 40)
  %r4.thash = getelementptr i64, ptr %r4.ptr, i64 0
  store i64 210691276070, ptr %r4.thash, align 8
  %r4.f0 = getelementptr i64, ptr %r4.ptr, i64 1
  store i64 %r0, ptr %r4.f0, align 8
  %r4.f1 = getelementptr i64, ptr %r4.ptr, i64 2
  store i64 %r1, ptr %r4.f1, align 8
  %r4.f2 = getelementptr i64, ptr %r4.ptr, i64 3
  store i64 %r2, ptr %r4.f2, align 8
  %r4.f3 = getelementptr i64, ptr %r4.ptr, i64 4
  store i64 %r3, ptr %r4.f3, align 8
  %r4 = ptrtoint ptr %r4.ptr to i64
  store i64 %r4, ptr %slot.tok, align 8
  %r5 = load i64, ptr %slot.tok, align 8
  %r6.ptr = inttoptr i64 %r5 to ptr
  %r6.gep = getelementptr i64, ptr %r6.ptr, i64 0
  %r6 = load i64, ptr %r6.gep, align 8
  %r7 = add i64 210691276070, 0
  %r8.cmp = icmp eq i64 %r6, %r7
  %r8 = zext i1 %r8.cmp to i64
  %br_marm_040 = icmp ne i64 %r8, 0
  br i1 %br_marm_040, label %marm_040, label %match_fall41
marm_040:
  %r9.ptr = inttoptr i64 %r5 to ptr
  %r9.gep = getelementptr i64, ptr %r9.ptr, i64 1
  %r9 = load i64, ptr %r9.gep, align 8
  store i64 %r9, ptr %slot.kind, align 8
  %r10.ptr = inttoptr i64 %r5 to ptr
  %r10.gep = getelementptr i64, ptr %r10.ptr, i64 2
  %r10 = load i64, ptr %r10.gep, align 8
  store i64 %r10, ptr %slot.value, align 8
  %r11.ptr = inttoptr i64 %r5 to ptr
  %r11.gep = getelementptr i64, ptr %r11.ptr, i64 3
  %r11 = load i64, ptr %r11.gep, align 8
  store i64 %r11, ptr %slot.line, align 8
  %r12.ptr = inttoptr i64 %r5 to ptr
  %r12.gep = getelementptr i64, ptr %r12.ptr, i64 4
  %r12 = load i64, ptr %r12.gep, align 8
  store i64 %r12, ptr %slot.col, align 8
  %r13.p = getelementptr inbounds [13 x i8], ptr @.str.39, i64 0, i64 0
  %r13 = ptrtoint ptr %r13.p to i64
  %r14 = load i64, ptr %slot.kind, align 8
  %r15 = call i64 @nova_rt_str_concat(i64 %r13, i64 %r14)
  %r16.p = getelementptr inbounds [8 x i8], ptr @.str.40, i64 0, i64 0
  %r16 = ptrtoint ptr %r16.p to i64
  %r17 = call i64 @nova_rt_str_concat(i64 %r15, i64 %r16)
  %r18 = load i64, ptr %slot.line, align 8
  %r19 = call i64 @nova_rt_int_to_str(i64 %r18)
  %r20 = call i64 @nova_rt_str_concat(i64 %r17, i64 %r19)
  %r21 = call i64 @nova_rt_print_any(i64 %r20)
  br label %match_exit39
match_fall41:
  br label %match_exit39
match_exit39:
  %r22.p = getelementptr inbounds [20 x i8], ptr @.str.41, i64 0, i64 0
  %r22 = ptrtoint ptr %r22.p to i64
  %r23 = call i64 @nova_rt_print_any(i64 %r22)
  ret i64 %r23
}

define i64 @test_irtype() nounwind {
entry:
  %slot.ir = alloca i64, align 8
  store i64 0, ptr %slot.ir, align 8
  %slot.kind = alloca i64, align 8
  store i64 0, ptr %slot.kind, align 8
  %slot.name = alloca i64, align 8
  store i64 0, ptr %slot.name, align 8
  %slot.params = alloca i64, align 8
  store i64 0, ptr %slot.params, align 8
  %slot.id = alloca i64, align 8
  store i64 0, ptr %slot.id, align 8
  %r0.p = getelementptr inbounds [4 x i8], ptr @.str.0, i64 0, i64 0
  %r0 = ptrtoint ptr %r0.p to i64
  %r1.p = getelementptr inbounds [1 x i8], ptr @.str.1, i64 0, i64 0
  %r1 = ptrtoint ptr %r1.p to i64
  %r2 = call i64 @nova_rt_list_create()
  %r3 = add i64 0, 0
  %r4.ptr = call ptr @nova_rt_struct_alloc(i64 40)
  %r4.thash = getelementptr i64, ptr %r4.ptr, i64 0
  store i64 6952384374146, ptr %r4.thash, align 8
  %r4.f0 = getelementptr i64, ptr %r4.ptr, i64 1
  store i64 %r0, ptr %r4.f0, align 8
  %r4.f1 = getelementptr i64, ptr %r4.ptr, i64 2
  store i64 %r1, ptr %r4.f1, align 8
  %r4.f2 = getelementptr i64, ptr %r4.ptr, i64 3
  store i64 %r2, ptr %r4.f2, align 8
  %r4.f3 = getelementptr i64, ptr %r4.ptr, i64 4
  store i64 %r3, ptr %r4.f3, align 8
  %r4 = ptrtoint ptr %r4.ptr to i64
  store i64 %r4, ptr %slot.ir, align 8
  %r5 = load i64, ptr %slot.ir, align 8
  %r6.ptr = inttoptr i64 %r5 to ptr
  %r6.gep = getelementptr i64, ptr %r6.ptr, i64 0
  %r6 = load i64, ptr %r6.gep, align 8
  %r7 = add i64 6952384374146, 0
  %r8.cmp = icmp eq i64 %r6, %r7
  %r8 = zext i1 %r8.cmp to i64
  %br_marm_043 = icmp ne i64 %r8, 0
  br i1 %br_marm_043, label %marm_043, label %match_fall44
marm_043:
  %r9.ptr = inttoptr i64 %r5 to ptr
  %r9.gep = getelementptr i64, ptr %r9.ptr, i64 1
  %r9 = load i64, ptr %r9.gep, align 8
  store i64 %r9, ptr %slot.kind, align 8
  %r10.ptr = inttoptr i64 %r5 to ptr
  %r10.gep = getelementptr i64, ptr %r10.ptr, i64 2
  %r10 = load i64, ptr %r10.gep, align 8
  store i64 %r10, ptr %slot.name, align 8
  %r11.ptr = inttoptr i64 %r5 to ptr
  %r11.gep = getelementptr i64, ptr %r11.ptr, i64 3
  %r11 = load i64, ptr %r11.gep, align 8
  store i64 %r11, ptr %slot.params, align 8
  %r12.ptr = inttoptr i64 %r5 to ptr
  %r12.gep = getelementptr i64, ptr %r12.ptr, i64 4
  %r12 = load i64, ptr %r12.gep, align 8
  store i64 %r12, ptr %slot.id, align 8
  %r13.p = getelementptr inbounds [14 x i8], ptr @.str.42, i64 0, i64 0
  %r13 = ptrtoint ptr %r13.p to i64
  %r14 = load i64, ptr %slot.kind, align 8
  %r15 = call i64 @nova_rt_str_concat(i64 %r13, i64 %r14)
  %r16 = call i64 @nova_rt_print_any(i64 %r15)
  br label %match_exit42
match_fall44:
  br label %match_exit42
match_exit42:
  %r17.p = getelementptr inbounds [21 x i8], ptr @.str.43, i64 0, i64 0
  %r17 = ptrtoint ptr %r17.p to i64
  %r18 = call i64 @nova_rt_print_any(i64 %r17)
  ret i64 %r18
}

define i64 @nova_main() nounwind {
entry:
  %r0 = call i64 @test_token()
  %r1 = call i64 @test_irtype()
  %r2 = call i64 @test_ntype()
  %r3 = call i64 @test_expr_stmt()
  %r4.p = getelementptr inbounds [17 x i8], ptr @.str.44, i64 0, i64 0
  %r4 = ptrtoint ptr %r4.p to i64
  %r5 = call i64 @nova_rt_print_any(i64 %r4)
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
@.str.0 = private unnamed_addr constant [4 x i8] c"int\00"
@.str.1 = private unnamed_addr constant [1 x i8] c"\00"
@.str.2 = private unnamed_addr constant [6 x i8] c"float\00"
@.str.3 = private unnamed_addr constant [7 x i8] c"string\00"
@.str.4 = private unnamed_addr constant [5 x i8] c"bool\00"
@.str.5 = private unnamed_addr constant [5 x i8] c"unit\00"
@.str.6 = private unnamed_addr constant [4 x i8] c"any\00"
@.str.7 = private unnamed_addr constant [4 x i8] c"var\00"
@.str.8 = private unnamed_addr constant [3 x i8] c"fn\00"
@.str.9 = private unnamed_addr constant [5 x i8] c"list\00"
@.str.10 = private unnamed_addr constant [6 x i8] c"print\00"
@.str.11 = private unnamed_addr constant [6 x i8] c"input\00"
@.str.12 = private unnamed_addr constant [4 x i8] c"str\00"
@.str.13 = private unnamed_addr constant [4 x i8] c"len\00"
@.str.14 = private unnamed_addr constant [5 x i8] c"push\00"
@.str.15 = private unnamed_addr constant [4 x i8] c"ord\00"
@.str.16 = private unnamed_addr constant [4 x i8] c"chr\00"
@.str.17 = private unnamed_addr constant [26 x i8] c"Creating NType objects...\00"
@.str.18 = private unnamed_addr constant [10 x i8] c"t1 kind: \00"
@.str.19 = private unnamed_addr constant [10 x i8] c"t4 kind: \00"
@.str.20 = private unnamed_addr constant [6 x i8] c" id: \00"
@.str.21 = private unnamed_addr constant [19 x i8] c"scheme body kind: \00"
@.str.22 = private unnamed_addr constant [19 x i8] c"Building stdlib...\00"
@.str.23 = private unnamed_addr constant [19 x i8] c"Stdlib built with \00"
@.str.24 = private unnamed_addr constant [9 x i8] c" entries\00"
@.str.25 = private unnamed_addr constant [3 x i8] c"-1\00"
@.str.26 = private unnamed_addr constant [14 x i8] c"Substituted: \00"
@.str.27 = private unnamed_addr constant [24 x i8] c"All NType tests passed!\00"
@.str.28 = private unnamed_addr constant [6 x i8] c"ident\00"
@.str.29 = private unnamed_addr constant [2 x i8] c"x\00"
@.str.30 = private unnamed_addr constant [11 x i8] c"Expr tag: \00"
@.str.31 = private unnamed_addr constant [9 x i8] c" eline: \00"
@.str.32 = private unnamed_addr constant [5 x i8] c"null\00"
@.str.33 = private unnamed_addr constant [4 x i8] c"let\00"
@.str.34 = private unnamed_addr constant [11 x i8] c"Stmt tag: \00"
@.str.35 = private unnamed_addr constant [9 x i8] c" sline: \00"
@.str.36 = private unnamed_addr constant [24 x i8] c"Expr/Stmt tests passed!\00"
@.str.37 = private unnamed_addr constant [6 x i8] c"IDENT\00"
@.str.38 = private unnamed_addr constant [6 x i8] c"hello\00"
@.str.39 = private unnamed_addr constant [13 x i8] c"Token kind: \00"
@.str.40 = private unnamed_addr constant [8 x i8] c" line: \00"
@.str.41 = private unnamed_addr constant [20 x i8] c"Token tests passed!\00"
@.str.42 = private unnamed_addr constant [14 x i8] c"IrType kind: \00"
@.str.43 = private unnamed_addr constant [21 x i8] c"IrType tests passed!\00"
@.str.44 = private unnamed_addr constant [17 x i8] c"ALL TESTS PASSED\00"

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
