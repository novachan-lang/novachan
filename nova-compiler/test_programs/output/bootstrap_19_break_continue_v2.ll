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

define i64 @find_first(i64 %p0, i64 %p1) nounwind {
entry:
  %slot.items = alloca i64, align 8
  store i64 %p0, ptr %slot.items, align 8
  %slot.target = alloca i64, align 8
  store i64 %p1, ptr %slot.target, align 8
  %slot.result = alloca i64, align 8
  store i64 0, ptr %slot.result, align 8
  %slot.idx = alloca i64, align 8
  store i64 0, ptr %slot.idx, align 8
  %r0 = add i64 1, 0
  %r1 = sub i64 0, %r0
  store i64 %r1, ptr %slot.result, align 8
  %r2 = add i64 0, 0
  store i64 %r2, ptr %slot.idx, align 8
  br label %while_hdr0, !llvm.loop !91
while_hdr0:
  %r3 = load i64, ptr %slot.idx, align 8
  %r4 = load i64, ptr %slot.items, align 8
  %r5 = call i64 @nova_rt_len_any(i64 %r4)
  %r6.cmp = icmp slt i64 %r3, %r5
  %r6 = zext i1 %r6.cmp to i64
  %br_while_body1 = icmp ne i64 %r6, 0
  br i1 %br_while_body1, label %while_body1, label %while_exit2, !prof !90
while_body1:
  %r7 = load i64, ptr %slot.items, align 8
  %r8 = load i64, ptr %slot.idx, align 8
  %r9 = call i64 @nova_rt_index_get(i64 %r7, i64 %r8)
  %r10 = load i64, ptr %slot.target, align 8
  %r11 = call i64 @nova_rt_eq(i64 %r9, i64 %r10)
  %br_then3 = icmp ne i64 %r11, 0
  br i1 %br_then3, label %then3, label %else4
then3:
  %r12 = load i64, ptr %slot.idx, align 8
  store i64 %r12, ptr %slot.result, align 8
  br label %while_exit2
else4:
  br label %endif5
endif5:
  %r13 = load i64, ptr %slot.idx, align 8
  %r14 = add i64 1, 0
  %r15 = add i64 %r13, %r14
  store i64 %r15, ptr %slot.idx, align 8
  br label %while_hdr0, !llvm.loop !91
while_exit2:
  %r16 = load i64, ptr %slot.result, align 8
  ret i64 %r16
}

define i64 @nova_main() nounwind {
entry:
  %slot.i = alloca i64, align 8
  store i64 0, ptr %slot.i, align 8
  %slot.total = alloca i64, align 8
  store i64 0, ptr %slot.total, align 8
  %slot.j = alloca i64, align 8
  store i64 0, ptr %slot.j, align 8
  %slot.__sc_15 = alloca i64, align 8
  store i64 0, ptr %slot.__sc_15, align 8
  %slot.found = alloca i64, align 8
  store i64 0, ptr %slot.found, align 8
  %slot.row = alloca i64, align 8
  store i64 0, ptr %slot.row, align 8
  %slot.col = alloca i64, align 8
  store i64 0, ptr %slot.col, align 8
  %slot.__sc_27 = alloca i64, align 8
  store i64 0, ptr %slot.__sc_27, align 8
  %r0 = add i64 0, 0
  store i64 %r0, ptr %slot.i, align 8
  %r1 = add i64 0, 0
  store i64 %r1, ptr %slot.total, align 8
  br label %while_hdr6, !llvm.loop !91
while_hdr6:
  %r2 = add i64 1, 0
  %br_while_body7 = icmp ne i64 %r2, 0
  br i1 %br_while_body7, label %while_body7, label %while_exit8, !prof !90
while_body7:
  %r3 = load i64, ptr %slot.i, align 8
  %r4 = add i64 5, 0
  %r5.cmp = icmp sge i64 %r3, %r4
  %r5 = zext i1 %r5.cmp to i64
  %br_then9 = icmp ne i64 %r5, 0
  br i1 %br_then9, label %then9, label %else10
then9:
  br label %while_exit8
else10:
  br label %endif11
endif11:
  %r6 = load i64, ptr %slot.total, align 8
  %r7 = load i64, ptr %slot.i, align 8
  %r8 = add i64 %r6, %r7
  store i64 %r8, ptr %slot.total, align 8
  %r9 = load i64, ptr %slot.i, align 8
  %r10 = add i64 1, 0
  %r11 = add i64 %r9, %r10
  store i64 %r11, ptr %slot.i, align 8
  br label %while_hdr6, !llvm.loop !91
while_exit8:
  %r12 = load i64, ptr %slot.total, align 8
  %r13 = call i64 @nova_rt_print_any(i64 %r12)
  %r14 = add i64 0, 0
  store i64 %r14, ptr %slot.total, align 8
  %r15 = add i64 0, 0
  store i64 %r15, ptr %slot.j, align 8
  br label %while_hdr12, !llvm.loop !91
while_hdr12:
  %r16 = load i64, ptr %slot.j, align 8
  %r17 = add i64 10, 0
  %r18.cmp = icmp slt i64 %r16, %r17
  %r18 = zext i1 %r18.cmp to i64
  %br_while_body13 = icmp ne i64 %r18, 0
  br i1 %br_while_body13, label %while_body13, label %while_exit14, !prof !90
while_body13:
  %r19 = load i64, ptr %slot.j, align 8
  %r20 = add i64 1, 0
  %r21 = add i64 %r19, %r20
  store i64 %r21, ptr %slot.j, align 8
  %r22 = load i64, ptr %slot.j, align 8
  %r23 = add i64 3, 0
  %r24.cmp = icmp eq i64 %r22, %r23
  %r24 = zext i1 %r24.cmp to i64
  store i64 %r24, ptr %slot.__sc_15, align 8
  %br_or_merge17 = icmp ne i64 %r24, 0
  br i1 %br_or_merge17, label %or_merge17, label %or_rhs16
or_rhs16:
  %r25 = load i64, ptr %slot.j, align 8
  %r26 = add i64 7, 0
  %r27.cmp = icmp eq i64 %r25, %r26
  %r27 = zext i1 %r27.cmp to i64
  store i64 %r27, ptr %slot.__sc_15, align 8
  br label %or_merge17
or_merge17:
  %r28 = load i64, ptr %slot.__sc_15, align 8
  %br_then18 = icmp ne i64 %r28, 0
  br i1 %br_then18, label %then18, label %else19
then18:
  br label %while_hdr12, !llvm.loop !91
else19:
  br label %endif20
endif20:
  %r29 = load i64, ptr %slot.total, align 8
  %r30 = load i64, ptr %slot.j, align 8
  %r31 = add i64 %r29, %r30
  store i64 %r31, ptr %slot.total, align 8
  br label %while_hdr12, !llvm.loop !91
while_exit14:
  %r32 = load i64, ptr %slot.total, align 8
  %r33 = call i64 @nova_rt_print_any(i64 %r32)
  %r35.p = getelementptr inbounds [2 x i8], ptr @.str.0, i64 0, i64 0
  %r35 = ptrtoint ptr %r35.p to i64
  %r36.p = getelementptr inbounds [2 x i8], ptr @.str.1, i64 0, i64 0
  %r36 = ptrtoint ptr %r36.p to i64
  %r37.p = getelementptr inbounds [2 x i8], ptr @.str.2, i64 0, i64 0
  %r37 = ptrtoint ptr %r37.p to i64
  %r38.p = getelementptr inbounds [2 x i8], ptr @.str.3, i64 0, i64 0
  %r38 = ptrtoint ptr %r38.p to i64
  %r34 = call i64 @nova_rt_list_create()
  call i64 @nova_rt_list_append(i64 %r34, i64 %r35)
  call i64 @nova_rt_list_append(i64 %r34, i64 %r36)
  call i64 @nova_rt_list_append(i64 %r34, i64 %r37)
  call i64 @nova_rt_list_append(i64 %r34, i64 %r38)
  %r39.p = getelementptr inbounds [2 x i8], ptr @.str.2, i64 0, i64 0
  %r39 = ptrtoint ptr %r39.p to i64
  %r40 = call i64 @find_first(i64 %r34, i64 %r39)
  %r41 = call i64 @nova_rt_print_any(i64 %r40)
  %r42.p = getelementptr inbounds [1 x i8], ptr @.str.4, i64 0, i64 0
  %r42 = ptrtoint ptr %r42.p to i64
  store i64 %r42, ptr %slot.found, align 8
  %r43 = add i64 0, 0
  store i64 %r43, ptr %slot.row, align 8
  br label %while_hdr21, !llvm.loop !91
while_hdr21:
  %r44 = load i64, ptr %slot.row, align 8
  %r45 = add i64 3, 0
  %r46.cmp = icmp slt i64 %r44, %r45
  %r46 = zext i1 %r46.cmp to i64
  %br_while_body22 = icmp ne i64 %r46, 0
  br i1 %br_while_body22, label %while_body22, label %while_exit23, !prof !90
while_body22:
  %r47 = add i64 0, 0
  store i64 %r47, ptr %slot.col, align 8
  br label %while_hdr24, !llvm.loop !91
while_hdr24:
  %r48 = load i64, ptr %slot.col, align 8
  %r49 = add i64 3, 0
  %r50.cmp = icmp slt i64 %r48, %r49
  %r50 = zext i1 %r50.cmp to i64
  %br_while_body25 = icmp ne i64 %r50, 0
  br i1 %br_while_body25, label %while_body25, label %while_exit26, !prof !90
while_body25:
  %r51 = load i64, ptr %slot.row, align 8
  %r52 = add i64 1, 0
  %r53.cmp = icmp eq i64 %r51, %r52
  %r53 = zext i1 %r53.cmp to i64
  store i64 %r53, ptr %slot.__sc_27, align 8
  %br_and_rhs28 = icmp ne i64 %r53, 0
  br i1 %br_and_rhs28, label %and_rhs28, label %and_merge29
and_rhs28:
  %r54 = load i64, ptr %slot.col, align 8
  %r55 = add i64 2, 0
  %r56.cmp = icmp eq i64 %r54, %r55
  %r56 = zext i1 %r56.cmp to i64
  store i64 %r56, ptr %slot.__sc_27, align 8
  br label %and_merge29
and_merge29:
  %r57 = load i64, ptr %slot.__sc_27, align 8
  %br_then30 = icmp ne i64 %r57, 0
  br i1 %br_then30, label %then30, label %else31
then30:
  %r58 = load i64, ptr %slot.row, align 8
  %r59 = call i64 @nova_rt_int_to_str(i64 %r58)
  %r60.p = getelementptr inbounds [2 x i8], ptr @.str.5, i64 0, i64 0
  %r60 = ptrtoint ptr %r60.p to i64
  %r61 = call i64 @nova_rt_str_concat(i64 %r59, i64 %r60)
  %r62 = load i64, ptr %slot.col, align 8
  %r63 = call i64 @nova_rt_int_to_str(i64 %r62)
  %r64 = call i64 @nova_rt_str_concat(i64 %r61, i64 %r63)
  store i64 %r64, ptr %slot.found, align 8
  br label %while_exit26
else31:
  br label %endif32
endif32:
  %r65 = load i64, ptr %slot.col, align 8
  %r66 = add i64 1, 0
  %r67 = add i64 %r65, %r66
  store i64 %r67, ptr %slot.col, align 8
  br label %while_hdr24, !llvm.loop !91
while_exit26:
  %r68 = load i64, ptr %slot.found, align 8
  %r69.p = getelementptr inbounds [1 x i8], ptr @.str.4, i64 0, i64 0
  %r69 = ptrtoint ptr %r69.p to i64
  %r70.p0 = inttoptr i64 %r68 to ptr
  %r70.p1 = inttoptr i64 %r69 to ptr
  %r70.sc = call i32 @strcmp(ptr %r70.p0, ptr %r70.p1)
  %r70.cmp = icmp ne i32 %r70.sc, 0
  %r70 = zext i1 %r70.cmp to i64
  %br_then33 = icmp ne i64 %r70, 0
  br i1 %br_then33, label %then33, label %else34
then33:
  br label %while_exit23
else34:
  br label %endif35
endif35:
  %r71 = load i64, ptr %slot.row, align 8
  %r72 = add i64 1, 0
  %r73 = add i64 %r71, %r72
  store i64 %r73, ptr %slot.row, align 8
  br label %while_hdr21, !llvm.loop !91
while_exit23:
  %r74 = load i64, ptr %slot.found, align 8
  %r75 = call i64 @nova_rt_print_any(i64 %r74)
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
@.str.0 = private unnamed_addr constant [2 x i8] c"a\00"
@.str.1 = private unnamed_addr constant [2 x i8] c"b\00"
@.str.2 = private unnamed_addr constant [2 x i8] c"c\00"
@.str.3 = private unnamed_addr constant [2 x i8] c"d\00"
@.str.4 = private unnamed_addr constant [1 x i8] c"\00"
@.str.5 = private unnamed_addr constant [2 x i8] c",\00"

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
