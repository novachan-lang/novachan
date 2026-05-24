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
declare i64 @nova_rt_print_float(i64) nounwind
declare i64 @nova_rt_print_int(i64) nounwind
declare i64 @nova_rt_print_str(i64) nounwind
declare i64 @nova_rt_float_bits(i64) nounwind
declare i64 @nova_rt_float_to_str(i64) nounwind
declare ptr @nova_rt_struct_alloc(i64) nounwind
declare i64 @nova_rt_slice(i64, i64, i64) nounwind
declare i64 @nova_rt_slice_any(i64, i64, i64) nounwind
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
declare i64 @nova_rt_for_iter_init(i64) nounwind
declare i64 @nova_rt_dict_has(i64, i64) nounwind
declare i64 @nova_rt_dict_del(i64, i64) nounwind
declare i64 @nova_rt_system(i64) nounwind
declare i64 @nova_rt_exec(i64) nounwind
declare i64 @nova_rt_create_string(ptr) nounwind
declare void @nova_rt_init_args(i64, i64) nounwind
declare void @nova_rt_wait_all() nounwind
declare void @nova_rt_cleanup() nounwind
declare i64 @nova_rt_channel_create() nounwind
declare i64 @nova_rt_channel_send(i64, i64) nounwind
declare i64 @nova_rt_channel_recv(i64) nounwind
declare i64 @nova_rt_channel_close(i64) nounwind
declare i64 @nova_rt_channel_select(i64, i64) nounwind
declare i64 @nova_rt_select(i64) nounwind
declare i64 @nova_rt_channel_recv_timeout(i64, i64) nounwind
declare i64 @nova_rt_spawn(i64, i64) nounwind
declare i64 @nova_rt_monitor(i64) nounwind
declare i64 @nova_rt_parse_float(i64) nounwind
declare i64 @nova_rt_read_line() nounwind
declare i64 @nova_rt_append_file(i64, i64) nounwind
declare i64 @nova_rt_file_exists(i64) nounwind
declare i64 @nova_rt_find(i64, i64) nounwind
declare i64 @nova_rt_list_concat(i64, i64) nounwind
declare i64 @nova_rt_list_reverse(i64) nounwind
declare i64 @nova_rt_list_sort(i64) nounwind
declare i64 @nova_rt_list_slice(i64, i64, i64) nounwind
declare i64 @nova_rt_list_map(i64, i64) nounwind
declare i64 @nova_rt_list_filter(i64, i64) nounwind
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
declare i64 @nova_rt_abs(i64) nounwind
declare i64 @nova_rt_max(i64, i64) nounwind
declare i64 @nova_rt_min(i64, i64) nounwind
declare i64 @nova_rt_sqrt(i64) nounwind
declare i64 @nova_rt_floor(i64) nounwind
declare i64 @nova_rt_ceil(i64) nounwind
declare i64 @nova_rt_pow(i64, i64) nounwind
declare i64 @nova_rt_round(i64) nounwind
declare i64 @nova_rt_sin(i64) nounwind
declare i64 @nova_rt_cos(i64) nounwind
declare i64 @nova_rt_tan(i64) nounwind
declare i64 @nova_rt_log(i64) nounwind
declare i64 @nova_rt_log2(i64) nounwind
declare i64 @nova_rt_log10(i64) nounwind
declare i64 @nova_rt_exp(i64) nounwind
declare i64 @nova_rt_fabs(i64) nounwind
declare i64 @nova_rt_fmax(i64, i64) nounwind
declare i64 @nova_rt_fmin(i64, i64) nounwind
declare i64 @nova_rt_fmod(i64, i64) nounwind
declare i64 @nova_rt_float_to_int(i64) nounwind
declare i64 @nova_rt_int_to_float(i64) nounwind
declare i64 @nova_rt_to_int(i64) nounwind
declare i64 @nova_rt_to_float(i64) nounwind

define i64 @make_mat(i64 %p0, i64 %p1) nounwind {
entry:
  %slot.n = alloca i64, align 8
  store i64 %p0, ptr %slot.n, align 8
  %slot.seed = alloca i64, align 8
  store i64 %p1, ptr %slot.seed, align 8
  %slot.m = alloca i64, align 8
  store i64 0, ptr %slot.m, align 8
  %slot.i = alloca i64, align 8
  store i64 0, ptr %slot.i, align 8
  %r0 = call i64 @nova_rt_list_create()
  store i64 %r0, ptr %slot.m, align 8
  %r1 = add i64 0, 0
  store i64 %r1, ptr %slot.i, align 8
  br label %while_hdr0, !llvm.loop !91
while_hdr0:
  %r2 = load i64, ptr %slot.i, align 8
  %r3 = load i64, ptr %slot.n, align 8
  %r4 = load i64, ptr %slot.n, align 8
  %r5 = mul i64 %r3, %r4
  %r6.cmp = icmp slt i64 %r2, %r5
  %r6 = zext i1 %r6.cmp to i64
  %br_while_body1 = icmp ne i64 %r6, 0
  br i1 %br_while_body1, label %while_body1, label %while_exit2, !prof !90
while_body1:
  %r7 = load i64, ptr %slot.m, align 8
  %r8 = load i64, ptr %slot.seed, align 8
  %r9 = load i64, ptr %slot.i, align 8
  %r10 = add i64 7, 0
  %r11 = srem i64 %r9, %r10
  %r12 = add i64 %r8, %r11
  %r13 = call i64 @nova_rt_list_append(i64 %r7, i64 %r12)
  %r14 = load i64, ptr %slot.i, align 8
  %r15 = add i64 1, 0
  %r16 = add i64 %r14, %r15
  store i64 %r16, ptr %slot.i, align 8
  br label %while_hdr0, !llvm.loop !91
while_exit2:
  %r17 = load i64, ptr %slot.m, align 8
  ret i64 %r17
}

define i64 @mat_mul(i64 %p0, i64 %p1, i64 %p2) nounwind {
entry:
  %slot.a = alloca i64, align 8
  store i64 %p0, ptr %slot.a, align 8
  %slot.b = alloca i64, align 8
  store i64 %p1, ptr %slot.b, align 8
  %slot.n = alloca i64, align 8
  store i64 %p2, ptr %slot.n, align 8
  %slot.c = alloca i64, align 8
  store i64 0, ptr %slot.c, align 8
  %slot.k = alloca i64, align 8
  store i64 0, ptr %slot.k, align 8
  %slot.i = alloca i64, align 8
  store i64 0, ptr %slot.i, align 8
  %slot.j = alloca i64, align 8
  store i64 0, ptr %slot.j, align 8
  %slot.s = alloca i64, align 8
  store i64 0, ptr %slot.s, align 8
  %r0 = call i64 @nova_rt_list_create()
  store i64 %r0, ptr %slot.c, align 8
  %r1 = add i64 0, 0
  store i64 %r1, ptr %slot.k, align 8
  br label %while_hdr3, !llvm.loop !91
while_hdr3:
  %r2 = load i64, ptr %slot.k, align 8
  %r3 = load i64, ptr %slot.n, align 8
  %r4 = load i64, ptr %slot.n, align 8
  %r5 = mul i64 %r3, %r4
  %r6.cmp = icmp slt i64 %r2, %r5
  %r6 = zext i1 %r6.cmp to i64
  %br_while_body4 = icmp ne i64 %r6, 0
  br i1 %br_while_body4, label %while_body4, label %while_exit5, !prof !90
while_body4:
  %r7 = load i64, ptr %slot.c, align 8
  %r8 = add i64 0, 0
  %r9 = call i64 @nova_rt_list_append(i64 %r7, i64 %r8)
  %r10 = load i64, ptr %slot.k, align 8
  %r11 = add i64 1, 0
  %r12 = add i64 %r10, %r11
  store i64 %r12, ptr %slot.k, align 8
  br label %while_hdr3, !llvm.loop !91
while_exit5:
  %r13 = add i64 0, 0
  store i64 %r13, ptr %slot.i, align 8
  br label %while_hdr6, !llvm.loop !91
while_hdr6:
  %r14 = load i64, ptr %slot.i, align 8
  %r15 = load i64, ptr %slot.n, align 8
  %r16.cmp = icmp slt i64 %r14, %r15
  %r16 = zext i1 %r16.cmp to i64
  %br_while_body7 = icmp ne i64 %r16, 0
  br i1 %br_while_body7, label %while_body7, label %while_exit8, !prof !90
while_body7:
  %r17 = add i64 0, 0
  store i64 %r17, ptr %slot.j, align 8
  br label %while_hdr9, !llvm.loop !91
while_hdr9:
  %r18 = load i64, ptr %slot.j, align 8
  %r19 = load i64, ptr %slot.n, align 8
  %r20.cmp = icmp slt i64 %r18, %r19
  %r20 = zext i1 %r20.cmp to i64
  %br_while_body10 = icmp ne i64 %r20, 0
  br i1 %br_while_body10, label %while_body10, label %while_exit11, !prof !90
while_body10:
  %r21 = add i64 0, 0
  store i64 %r21, ptr %slot.s, align 8
  %r22 = add i64 0, 0
  store i64 %r22, ptr %slot.k, align 8
  br label %while_hdr12, !llvm.loop !91
while_hdr12:
  %r23 = load i64, ptr %slot.k, align 8
  %r24 = load i64, ptr %slot.n, align 8
  %r25.cmp = icmp slt i64 %r23, %r24
  %r25 = zext i1 %r25.cmp to i64
  %br_while_body13 = icmp ne i64 %r25, 0
  br i1 %br_while_body13, label %while_body13, label %while_exit14, !prof !90
while_body13:
  %r26 = load i64, ptr %slot.s, align 8
  %r27 = load i64, ptr %slot.a, align 8
  %r28 = load i64, ptr %slot.i, align 8
  %r29 = load i64, ptr %slot.n, align 8
  %r30 = mul i64 %r28, %r29
  %r31 = load i64, ptr %slot.k, align 8
  %r32 = add i64 %r30, %r31
  %r33.lp = inttoptr i64 %r27 to ptr
  %r33.dp = load ptr, ptr %r33.lp, align 8, !tbaa !2
  %r33.szp = getelementptr i64, ptr %r33.lp, i64 1
  %r33.sz = load i64, ptr %r33.szp, align 8, !tbaa !6
  %r33.neg = icmp slt i64 %r32, 0
  %r33.adj = add i64 %r32, %r33.sz
  %r33.fi = select i1 %r33.neg, i64 %r33.adj, i64 %r32
  %r33.ep = getelementptr i64, ptr %r33.dp, i64 %r33.fi
  %r33 = load i64, ptr %r33.ep, align 8, !tbaa !4
  %r34 = load i64, ptr %slot.b, align 8
  %r35 = load i64, ptr %slot.k, align 8
  %r36 = load i64, ptr %slot.n, align 8
  %r37 = mul i64 %r35, %r36
  %r38 = load i64, ptr %slot.j, align 8
  %r39 = add i64 %r37, %r38
  %r40.lp = inttoptr i64 %r34 to ptr
  %r40.dp = load ptr, ptr %r40.lp, align 8, !tbaa !2
  %r40.szp = getelementptr i64, ptr %r40.lp, i64 1
  %r40.sz = load i64, ptr %r40.szp, align 8, !tbaa !6
  %r40.neg = icmp slt i64 %r39, 0
  %r40.adj = add i64 %r39, %r40.sz
  %r40.fi = select i1 %r40.neg, i64 %r40.adj, i64 %r39
  %r40.ep = getelementptr i64, ptr %r40.dp, i64 %r40.fi
  %r40 = load i64, ptr %r40.ep, align 8, !tbaa !4
  %r41 = call i64 @nova_rt_mul(i64 %r33, i64 %r40)
  %r42 = call i64 @nova_rt_add(i64 %r26, i64 %r41)
  store i64 %r42, ptr %slot.s, align 8
  %r43 = load i64, ptr %slot.k, align 8
  %r44 = add i64 1, 0
  %r45 = add i64 %r43, %r44
  store i64 %r45, ptr %slot.k, align 8
  br label %while_hdr12, !llvm.loop !91
while_exit14:
  %r46 = load i64, ptr %slot.s, align 8
  %r47 = load i64, ptr %slot.c, align 8
  %r48 = load i64, ptr %slot.i, align 8
  %r49 = load i64, ptr %slot.n, align 8
  %r50 = mul i64 %r48, %r49
  %r51 = load i64, ptr %slot.j, align 8
  %r52 = add i64 %r50, %r51
  %_is.lp0 = inttoptr i64 %r47 to ptr
  %_is.dp1 = load ptr, ptr %_is.lp0, align 8, !tbaa !2
  %_is.szp2 = getelementptr i64, ptr %_is.lp0, i64 1
  %_is.sz3 = load i64, ptr %_is.szp2, align 8, !tbaa !6
  %_is.neg4 = icmp slt i64 %r52, 0
  %_is.adj5 = add i64 %r52, %_is.sz3
  %_is.fi6 = select i1 %_is.neg4, i64 %_is.adj5, i64 %r52
  %_is.ep7 = getelementptr i64, ptr %_is.dp1, i64 %_is.fi6
  store i64 %r46, ptr %_is.ep7, align 8, !tbaa !4
  %r53 = load i64, ptr %slot.j, align 8
  %r54 = add i64 1, 0
  %r55 = add i64 %r53, %r54
  store i64 %r55, ptr %slot.j, align 8
  br label %while_hdr9, !llvm.loop !91
while_exit11:
  %r56 = load i64, ptr %slot.i, align 8
  %r57 = add i64 1, 0
  %r58 = add i64 %r56, %r57
  store i64 %r58, ptr %slot.i, align 8
  br label %while_hdr6, !llvm.loop !91
while_exit8:
  %r59 = load i64, ptr %slot.c, align 8
  ret i64 %r59
}

define i64 @nova_main() nounwind {
entry:
  %slot.n = alloca i64, align 8
  store i64 0, ptr %slot.n, align 8
  %slot.a = alloca i64, align 8
  store i64 0, ptr %slot.a, align 8
  %slot.b = alloca i64, align 8
  store i64 0, ptr %slot.b, align 8
  %slot.c = alloca i64, align 8
  store i64 0, ptr %slot.c, align 8
  %slot.total = alloca i64, align 8
  store i64 0, ptr %slot.total, align 8
  %slot.i = alloca i64, align 8
  store i64 0, ptr %slot.i, align 8
  %r0 = add i64 300, 0
  store i64 %r0, ptr %slot.n, align 8
  %r1 = load i64, ptr %slot.n, align 8
  %r2 = add i64 1, 0
  %r3 = call i64 @make_mat(i64 %r1, i64 %r2)
  store i64 %r3, ptr %slot.a, align 8
  %r4 = load i64, ptr %slot.n, align 8
  %r5 = add i64 2, 0
  %r6 = call i64 @make_mat(i64 %r4, i64 %r5)
  store i64 %r6, ptr %slot.b, align 8
  %r7 = load i64, ptr %slot.a, align 8
  %r8 = load i64, ptr %slot.b, align 8
  %r9 = load i64, ptr %slot.n, align 8
  %r10 = call i64 @mat_mul(i64 %r7, i64 %r8, i64 %r9)
  store i64 %r10, ptr %slot.c, align 8
  %r11 = add i64 0, 0
  store i64 %r11, ptr %slot.total, align 8
  %r12 = add i64 0, 0
  store i64 %r12, ptr %slot.i, align 8
  br label %while_hdr15, !llvm.loop !91
while_hdr15:
  %r13 = load i64, ptr %slot.i, align 8
  %r14 = load i64, ptr %slot.n, align 8
  %r15 = load i64, ptr %slot.n, align 8
  %r16 = mul i64 %r14, %r15
  %r17.cmp = icmp slt i64 %r13, %r16
  %r17 = zext i1 %r17.cmp to i64
  %br_while_body16 = icmp ne i64 %r17, 0
  br i1 %br_while_body16, label %while_body16, label %while_exit17, !prof !90
while_body16:
  %r18 = load i64, ptr %slot.total, align 8
  %r19 = load i64, ptr %slot.c, align 8
  %r20 = load i64, ptr %slot.i, align 8
  %r21 = call i64 @nova_rt_index_get(i64 %r19, i64 %r20)
  %r22 = call i64 @nova_rt_add(i64 %r18, i64 %r21)
  store i64 %r22, ptr %slot.total, align 8
  %r23 = load i64, ptr %slot.i, align 8
  %r24 = add i64 1, 0
  %r25 = add i64 %r23, %r24
  store i64 %r25, ptr %slot.i, align 8
  br label %while_hdr15, !llvm.loop !91
while_exit17:
  %r26.p = getelementptr inbounds [26 x i8], ptr @.str.0, i64 0, i64 0
  %r26 = ptrtoint ptr %r26.p to i64
  %r27 = load i64, ptr %slot.total, align 8
  %r28 = call i64 @nova_rt_int_to_str(i64 %r27)
  %r29 = call i64 @nova_rt_str_concat(i64 %r26, i64 %r28)
  %r30 = call i64 @nova_rt_print_str(i64 %r29)
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
@.str.0 = private unnamed_addr constant [26 x i8] c"Matmul 300x300 checksum: \00"

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
