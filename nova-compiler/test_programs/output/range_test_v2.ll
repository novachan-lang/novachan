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

define i64 @factorial(i64 %p0) nounwind {
entry:
  %slot.n = alloca i64, align 8
  store i64 %p0, ptr %slot.n, align 8
  %slot.result = alloca i64, align 8
  store i64 0, ptr %slot.result, align 8
  %slot.__for_idx_0 = alloca i64, align 8
  store i64 0, ptr %slot.__for_idx_0, align 8
  %slot.i = alloca i64, align 8
  store i64 0, ptr %slot.i, align 8
  %r0 = add i64 1, 0
  store i64 %r0, ptr %slot.result, align 8
  %r1 = add i64 0, 0
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
  store i64 %r6, ptr %slot.i, align 8
  %r7 = load i64, ptr %slot.n, align 8
  %r8 = load i64, ptr %slot.result, align 8
  %r9 = load i64, ptr %slot.i, align 8
  %r10 = mul i64 %r8, %r9
  store i64 %r10, ptr %slot.result, align 8
  %r11 = load i64, ptr %slot.__for_idx_0, align 8
  %r12 = add i64 1, 0
  %r13 = add i64 %r11, %r12
  store i64 %r13, ptr %slot.__for_idx_0, align 8
  br label %for_hdr0, !llvm.loop !91
for_exit2:
  %r14 = load i64, ptr %slot.result, align 8
  ret i64 %r14
}

define i64 @nova_main() nounwind {
entry:
  %slot.total = alloca i64, align 8
  store i64 0, ptr %slot.total, align 8
  %slot.__for_idx_3 = alloca i64, align 8
  store i64 0, ptr %slot.__for_idx_3, align 8
  %slot.i = alloca i64, align 8
  store i64 0, ptr %slot.i, align 8
  %slot.sum = alloca i64, align 8
  store i64 0, ptr %slot.sum, align 8
  %slot.__for_idx_6 = alloca i64, align 8
  store i64 0, ptr %slot.__for_idx_6, align 8
  %slot.x = alloca i64, align 8
  store i64 0, ptr %slot.x, align 8
  %slot.__for_idx_9 = alloca i64, align 8
  store i64 0, ptr %slot.__for_idx_9, align 8
  %r0 = add i64 0, 0
  store i64 %r0, ptr %slot.total, align 8
  %r1 = add i64 0, 0
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
  store i64 %r6, ptr %slot.i, align 8
  %r7 = load i64, ptr %slot.total, align 8
  %r8 = load i64, ptr %slot.i, align 8
  %r9 = call i64 @nova_rt_add(i64 %r7, i64 %r8)
  store i64 %r9, ptr %slot.total, align 8
  %r10 = load i64, ptr %slot.__for_idx_3, align 8
  %r11 = add i64 1, 0
  %r12 = add i64 %r10, %r11
  store i64 %r12, ptr %slot.__for_idx_3, align 8
  br label %for_hdr3, !llvm.loop !91
for_exit5:
  %r13 = load i64, ptr %slot.total, align 8
  %r14 = call i64 @nova_rt_print_any(i64 %r13)
  %r15 = add i64 0, 0
  store i64 %r15, ptr %slot.sum, align 8
  %r16 = add i64 0, 0
  %r17 = call i64 @nova_rt_len_any(i64 %r16)
  %r18 = add i64 0, 0
  store i64 %r18, ptr %slot.__for_idx_6, align 8
  br label %for_hdr6, !llvm.loop !91
for_hdr6:
  %r19 = load i64, ptr %slot.__for_idx_6, align 8
  %r20.cmp = icmp slt i64 %r19, %r17
  %r20 = zext i1 %r20.cmp to i64
  %br_for_body7 = icmp ne i64 %r20, 0
  br i1 %br_for_body7, label %for_body7, label %for_exit8, !prof !90
for_body7:
  %r21 = call i64 @nova_rt_index_get(i64 %r16, i64 %r19)
  store i64 %r21, ptr %slot.x, align 8
  %r22 = load i64, ptr %slot.sum, align 8
  %r23 = load i64, ptr %slot.x, align 8
  %r24 = call i64 @nova_rt_add(i64 %r22, i64 %r23)
  store i64 %r24, ptr %slot.sum, align 8
  %r25 = load i64, ptr %slot.__for_idx_6, align 8
  %r26 = add i64 1, 0
  %r27 = add i64 %r25, %r26
  store i64 %r27, ptr %slot.__for_idx_6, align 8
  br label %for_hdr6, !llvm.loop !91
for_exit8:
  %r28 = load i64, ptr %slot.sum, align 8
  %r29 = call i64 @nova_rt_print_any(i64 %r28)
  %r30 = add i64 5, 0
  %r31 = call i64 @factorial(i64 %r30)
  %r32 = call i64 @nova_rt_print_any(i64 %r31)
  %r33 = add i64 10, 0
  %r34 = call i64 @factorial(i64 %r33)
  %r35 = call i64 @nova_rt_print_any(i64 %r34)
  %r36 = add i64 0, 0
  %r37 = call i64 @nova_rt_len_any(i64 %r36)
  %r38 = add i64 0, 0
  store i64 %r38, ptr %slot.__for_idx_9, align 8
  br label %for_hdr9, !llvm.loop !91
for_hdr9:
  %r39 = load i64, ptr %slot.__for_idx_9, align 8
  %r40.cmp = icmp slt i64 %r39, %r37
  %r40 = zext i1 %r40.cmp to i64
  %br_for_body10 = icmp ne i64 %r40, 0
  br i1 %br_for_body10, label %for_body10, label %for_exit11, !prof !90
for_body10:
  %r41 = call i64 @nova_rt_index_get(i64 %r36, i64 %r39)
  store i64 %r41, ptr %slot.i, align 8
  %r42 = load i64, ptr %slot.i, align 8
  %r43 = load i64, ptr %slot.i, align 8
  %r44 = mul i64 %r42, %r43
  %r45 = call i64 @nova_rt_print_any(i64 %r44)
  %r46 = load i64, ptr %slot.__for_idx_9, align 8
  %r47 = add i64 1, 0
  %r48 = add i64 %r46, %r47
  store i64 %r48, ptr %slot.__for_idx_9, align 8
  br label %for_hdr9, !llvm.loop !91
for_exit11:
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
