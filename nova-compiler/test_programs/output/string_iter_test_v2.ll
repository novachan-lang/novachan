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

define i64 @nova_main() nounwind {
entry:
  %slot.word = alloca i64, align 8
  store i64 0, ptr %slot.word, align 8
  %slot.result = alloca i64, align 8
  store i64 0, ptr %slot.result, align 8
  %slot.__for_idx_0 = alloca i64, align 8
  store i64 0, ptr %slot.__for_idx_0, align 8
  %slot.ch = alloca i64, align 8
  store i64 0, ptr %slot.ch, align 8
  %slot.count = alloca i64, align 8
  store i64 0, ptr %slot.count, align 8
  %slot.__for_idx_3 = alloca i64, align 8
  store i64 0, ptr %slot.__for_idx_3, align 8
  %slot.c = alloca i64, align 8
  store i64 0, ptr %slot.c, align 8
  %slot.vowels = alloca i64, align 8
  store i64 0, ptr %slot.vowels, align 8
  %slot.__for_idx_6 = alloca i64, align 8
  store i64 0, ptr %slot.__for_idx_6, align 8
  %slot.__sc_9 = alloca i64, align 8
  store i64 0, ptr %slot.__sc_9, align 8
  %slot.__sc_12 = alloca i64, align 8
  store i64 0, ptr %slot.__sc_12, align 8
  %slot.__sc_15 = alloca i64, align 8
  store i64 0, ptr %slot.__sc_15, align 8
  %slot.__sc_18 = alloca i64, align 8
  store i64 0, ptr %slot.__sc_18, align 8
  %r0.p = getelementptr inbounds [5 x i8], ptr @.str.0, i64 0, i64 0
  %r0 = ptrtoint ptr %r0.p to i64
  store i64 %r0, ptr %slot.word, align 8
  %r1.p = getelementptr inbounds [1 x i8], ptr @.str.1, i64 0, i64 0
  %r1 = ptrtoint ptr %r1.p to i64
  store i64 %r1, ptr %slot.result, align 8
  %r2 = load i64, ptr %slot.word, align 8
  %r3 = call i64 @nova_rt_len_any(i64 %r2)
  %r4 = add i64 0, 0
  store i64 %r4, ptr %slot.__for_idx_0, align 8
  br label %for_hdr0, !llvm.loop !91
for_hdr0:
  %r5 = load i64, ptr %slot.__for_idx_0, align 8
  %r6.cmp = icmp slt i64 %r5, %r3
  %r6 = zext i1 %r6.cmp to i64
  %br_for_body1 = icmp ne i64 %r6, 0
  br i1 %br_for_body1, label %for_body1, label %for_exit2, !prof !90
for_body1:
  %r7 = call i64 @nova_rt_index_get(i64 %r2, i64 %r5)
  store i64 %r7, ptr %slot.ch, align 8
  %r8 = load i64, ptr %slot.result, align 8
  %r9 = load i64, ptr %slot.ch, align 8
  %r10 = call i64 @nova_rt_str_concat(i64 %r8, i64 %r9)
  %r11.p = getelementptr inbounds [2 x i8], ptr @.str.2, i64 0, i64 0
  %r11 = ptrtoint ptr %r11.p to i64
  %r12 = call i64 @nova_rt_str_concat(i64 %r10, i64 %r11)
  store i64 %r12, ptr %slot.result, align 8
  %r13 = load i64, ptr %slot.__for_idx_0, align 8
  %r14 = add i64 1, 0
  %r15 = add i64 %r13, %r14
  store i64 %r15, ptr %slot.__for_idx_0, align 8
  br label %for_hdr0, !llvm.loop !91
for_exit2:
  %r16 = load i64, ptr %slot.result, align 8
  %r17 = call i64 @nova_rt_print_any(i64 %r16)
  %r18 = add i64 0, 0
  store i64 %r18, ptr %slot.count, align 8
  %r19.p = getelementptr inbounds [6 x i8], ptr @.str.3, i64 0, i64 0
  %r19 = ptrtoint ptr %r19.p to i64
  %r20 = call i64 @nova_rt_len_any(i64 %r19)
  %r21 = add i64 0, 0
  store i64 %r21, ptr %slot.__for_idx_3, align 8
  br label %for_hdr3, !llvm.loop !91
for_hdr3:
  %r22 = load i64, ptr %slot.__for_idx_3, align 8
  %r23.cmp = icmp slt i64 %r22, %r20
  %r23 = zext i1 %r23.cmp to i64
  %br_for_body4 = icmp ne i64 %r23, 0
  br i1 %br_for_body4, label %for_body4, label %for_exit5, !prof !90
for_body4:
  %r24 = call i64 @nova_rt_index_get(i64 %r19, i64 %r22)
  store i64 %r24, ptr %slot.c, align 8
  %r25 = load i64, ptr %slot.count, align 8
  %r26 = add i64 1, 0
  %r27 = add i64 %r25, %r26
  store i64 %r27, ptr %slot.count, align 8
  %r28 = load i64, ptr %slot.__for_idx_3, align 8
  %r29 = add i64 1, 0
  %r30 = add i64 %r28, %r29
  store i64 %r30, ptr %slot.__for_idx_3, align 8
  br label %for_hdr3, !llvm.loop !91
for_exit5:
  %r31 = load i64, ptr %slot.count, align 8
  %r32 = call i64 @nova_rt_int_to_str(i64 %r31)
  %r33 = call i64 @nova_rt_print_any(i64 %r32)
  %r34.p = getelementptr inbounds [1 x i8], ptr @.str.1, i64 0, i64 0
  %r34 = ptrtoint ptr %r34.p to i64
  store i64 %r34, ptr %slot.vowels, align 8
  %r35.p = getelementptr inbounds [12 x i8], ptr @.str.4, i64 0, i64 0
  %r35 = ptrtoint ptr %r35.p to i64
  %r36 = call i64 @nova_rt_len_any(i64 %r35)
  %r37 = add i64 0, 0
  store i64 %r37, ptr %slot.__for_idx_6, align 8
  br label %for_hdr6, !llvm.loop !91
for_hdr6:
  %r38 = load i64, ptr %slot.__for_idx_6, align 8
  %r39.cmp = icmp slt i64 %r38, %r36
  %r39 = zext i1 %r39.cmp to i64
  %br_for_body7 = icmp ne i64 %r39, 0
  br i1 %br_for_body7, label %for_body7, label %for_exit8, !prof !90
for_body7:
  %r40 = call i64 @nova_rt_index_get(i64 %r35, i64 %r38)
  store i64 %r40, ptr %slot.c, align 8
  %r41 = load i64, ptr %slot.c, align 8
  %r42.p = getelementptr inbounds [2 x i8], ptr @.str.5, i64 0, i64 0
  %r42 = ptrtoint ptr %r42.p to i64
  %r43.p0 = inttoptr i64 %r41 to ptr
  %r43.p1 = inttoptr i64 %r42 to ptr
  %r43.sc = call i32 @strcmp(ptr %r43.p0, ptr %r43.p1)
  %r43.cmp = icmp eq i32 %r43.sc, 0
  %r43 = zext i1 %r43.cmp to i64
  store i64 %r43, ptr %slot.__sc_9, align 8
  %br_or_merge11 = icmp ne i64 %r43, 0
  br i1 %br_or_merge11, label %or_merge11, label %or_rhs10
or_rhs10:
  %r44 = load i64, ptr %slot.c, align 8
  %r45.p = getelementptr inbounds [2 x i8], ptr @.str.6, i64 0, i64 0
  %r45 = ptrtoint ptr %r45.p to i64
  %r46.p0 = inttoptr i64 %r44 to ptr
  %r46.p1 = inttoptr i64 %r45 to ptr
  %r46.sc = call i32 @strcmp(ptr %r46.p0, ptr %r46.p1)
  %r46.cmp = icmp eq i32 %r46.sc, 0
  %r46 = zext i1 %r46.cmp to i64
  store i64 %r46, ptr %slot.__sc_9, align 8
  br label %or_merge11
or_merge11:
  %r47 = load i64, ptr %slot.__sc_9, align 8
  store i64 %r47, ptr %slot.__sc_12, align 8
  %br_or_merge14 = icmp ne i64 %r47, 0
  br i1 %br_or_merge14, label %or_merge14, label %or_rhs13
or_rhs13:
  %r48 = load i64, ptr %slot.c, align 8
  %r49.p = getelementptr inbounds [2 x i8], ptr @.str.7, i64 0, i64 0
  %r49 = ptrtoint ptr %r49.p to i64
  %r50.p0 = inttoptr i64 %r48 to ptr
  %r50.p1 = inttoptr i64 %r49 to ptr
  %r50.sc = call i32 @strcmp(ptr %r50.p0, ptr %r50.p1)
  %r50.cmp = icmp eq i32 %r50.sc, 0
  %r50 = zext i1 %r50.cmp to i64
  store i64 %r50, ptr %slot.__sc_12, align 8
  br label %or_merge14
or_merge14:
  %r51 = load i64, ptr %slot.__sc_12, align 8
  store i64 %r51, ptr %slot.__sc_15, align 8
  %br_or_merge17 = icmp ne i64 %r51, 0
  br i1 %br_or_merge17, label %or_merge17, label %or_rhs16
or_rhs16:
  %r52 = load i64, ptr %slot.c, align 8
  %r53.p = getelementptr inbounds [2 x i8], ptr @.str.8, i64 0, i64 0
  %r53 = ptrtoint ptr %r53.p to i64
  %r54.p0 = inttoptr i64 %r52 to ptr
  %r54.p1 = inttoptr i64 %r53 to ptr
  %r54.sc = call i32 @strcmp(ptr %r54.p0, ptr %r54.p1)
  %r54.cmp = icmp eq i32 %r54.sc, 0
  %r54 = zext i1 %r54.cmp to i64
  store i64 %r54, ptr %slot.__sc_15, align 8
  br label %or_merge17
or_merge17:
  %r55 = load i64, ptr %slot.__sc_15, align 8
  store i64 %r55, ptr %slot.__sc_18, align 8
  %br_or_merge20 = icmp ne i64 %r55, 0
  br i1 %br_or_merge20, label %or_merge20, label %or_rhs19
or_rhs19:
  %r56 = load i64, ptr %slot.c, align 8
  %r57.p = getelementptr inbounds [2 x i8], ptr @.str.9, i64 0, i64 0
  %r57 = ptrtoint ptr %r57.p to i64
  %r58.p0 = inttoptr i64 %r56 to ptr
  %r58.p1 = inttoptr i64 %r57 to ptr
  %r58.sc = call i32 @strcmp(ptr %r58.p0, ptr %r58.p1)
  %r58.cmp = icmp eq i32 %r58.sc, 0
  %r58 = zext i1 %r58.cmp to i64
  store i64 %r58, ptr %slot.__sc_18, align 8
  br label %or_merge20
or_merge20:
  %r59 = load i64, ptr %slot.__sc_18, align 8
  %br_then21 = icmp ne i64 %r59, 0
  br i1 %br_then21, label %then21, label %else22
then21:
  %r60 = load i64, ptr %slot.vowels, align 8
  %r61 = load i64, ptr %slot.c, align 8
  %r62 = call i64 @nova_rt_str_concat(i64 %r60, i64 %r61)
  store i64 %r62, ptr %slot.vowels, align 8
  br label %endif23
else22:
  br label %endif23
endif23:
  %r63 = load i64, ptr %slot.__for_idx_6, align 8
  %r64 = add i64 1, 0
  %r65 = add i64 %r63, %r64
  store i64 %r65, ptr %slot.__for_idx_6, align 8
  br label %for_hdr6, !llvm.loop !91
for_exit8:
  %r66 = load i64, ptr %slot.vowels, align 8
  %r67 = call i64 @nova_rt_print_any(i64 %r66)
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
@.str.0 = private unnamed_addr constant [5 x i8] c"NOVA\00"
@.str.1 = private unnamed_addr constant [1 x i8] c"\00"
@.str.2 = private unnamed_addr constant [2 x i8] c"-\00"
@.str.3 = private unnamed_addr constant [6 x i8] c"hello\00"
@.str.4 = private unnamed_addr constant [12 x i8] c"programming\00"
@.str.5 = private unnamed_addr constant [2 x i8] c"a\00"
@.str.6 = private unnamed_addr constant [2 x i8] c"e\00"
@.str.7 = private unnamed_addr constant [2 x i8] c"i\00"
@.str.8 = private unnamed_addr constant [2 x i8] c"o\00"
@.str.9 = private unnamed_addr constant [2 x i8] c"u\00"

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
