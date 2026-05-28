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

define i64 @test_loop_temps() nounwind {
entry:
  %slot.total = alloca i64, align 8
  store i64 0, ptr %slot.total, align 8
  %slot.__for_idx_0 = alloca i64, align 8
  store i64 0, ptr %slot.__for_idx_0, align 8
  %slot.i = alloca i64, align 8
  store i64 0, ptr %slot.i, align 8
  %r0 = add i64 0, 0
  store i64 %r0, ptr %slot.total, align 8
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
  %r7 = load i64, ptr %slot.total, align 8
  %r9 = load i64, ptr %slot.i, align 8
  %r10 = load i64, ptr %slot.i, align 8
  %r11 = add i64 1, 0
  %r12 = call i64 @nova_rt_add(i64 %r10, i64 %r11)
  %r13 = load i64, ptr %slot.i, align 8
  %r14 = add i64 2, 0
  %r15 = call i64 @nova_rt_add(i64 %r13, i64 %r14)
  %r8 = call i64 @nova_rt_list_create()
  call i64 @nova_rt_list_append(i64 %r8, i64 %r9)
  call i64 @nova_rt_list_append(i64 %r8, i64 %r12)
  call i64 @nova_rt_list_append(i64 %r8, i64 %r15)
  %r16 = call i64 @nova_rt_len_any(i64 %r8)
  %r17 = add i64 %r7, %r16
  store i64 %r17, ptr %slot.total, align 8
  %r18 = load i64, ptr %slot.__for_idx_0, align 8
  %r19 = add i64 1, 0
  %r20 = add i64 %r18, %r19
  store i64 %r20, ptr %slot.__for_idx_0, align 8
  br label %for_hdr0, !llvm.loop !91
for_exit2:
  %r21 = load i64, ptr %slot.total, align 8
  %r22 = call i64 @nova_rt_print_any(i64 %r21)
  ret i64 %r22
}

define i64 @test_nested_chains() nounwind {
entry:
  %slot.reverse = alloca i64, align 8
  store i64 0, ptr %slot.reverse, align 8
  %slot.result = alloca i64, align 8
  store i64 0, ptr %slot.result, align 8
  %r1 = add i64 5, 0
  %r2 = add i64 4, 0
  %r3 = add i64 3, 0
  %r4 = add i64 2, 0
  %r5 = add i64 1, 0
  %r0 = call i64 @nova_rt_list_create()
  call i64 @nova_rt_list_append(i64 %r0, i64 %r1)
  call i64 @nova_rt_list_append(i64 %r0, i64 %r2)
  call i64 @nova_rt_list_append(i64 %r0, i64 %r3)
  call i64 @nova_rt_list_append(i64 %r0, i64 %r4)
  call i64 @nova_rt_list_append(i64 %r0, i64 %r5)
  %r7 = load i64, ptr %slot.reverse, align 8
  %r6.rec = inttoptr i64 %r7 to ptr
  %r6.fnraw = load i64, ptr %r6.rec, align 8
  %r6.fnptr = inttoptr i64 %r6.fnraw to ptr
  %r6 = call i64 %r6.fnptr(i64 %r7, i64 %r0)
  %r9 = load i64, ptr %slot.reverse, align 8
  %r8.rec = inttoptr i64 %r9 to ptr
  %r8.fnraw = load i64, ptr %r8.rec, align 8
  %r8.fnptr = inttoptr i64 %r8.fnraw to ptr
  %r8 = call i64 %r8.fnptr(i64 %r9, i64 %r6)
  %r11 = load i64, ptr %slot.reverse, align 8
  %r10.rec = inttoptr i64 %r11 to ptr
  %r10.fnraw = load i64, ptr %r10.rec, align 8
  %r10.fnptr = inttoptr i64 %r10.fnraw to ptr
  %r10 = call i64 %r10.fnptr(i64 %r11, i64 %r8)
  %r12 = call i64 @nova_rt_len_any(i64 %r10)
  store i64 %r12, ptr %slot.result, align 8
  %r13 = load i64, ptr %slot.result, align 8
  %r14 = call i64 @nova_rt_print_any(i64 %r13)
  ret i64 %r14
}

define i64 @test_string_loop() nounwind {
entry:
  %slot.count = alloca i64, align 8
  store i64 0, ptr %slot.count, align 8
  %slot.__for_idx_3 = alloca i64, align 8
  store i64 0, ptr %slot.__for_idx_3, align 8
  %slot.i = alloca i64, align 8
  store i64 0, ptr %slot.i, align 8
  %slot.n = alloca i64, align 8
  store i64 0, ptr %slot.n, align 8
  %r0 = add i64 0, 0
  store i64 %r0, ptr %slot.count, align 8
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
  %r7.p = getelementptr inbounds [6 x i8], ptr @.str.0, i64 0, i64 0
  %r7 = ptrtoint ptr %r7.p to i64
  %r8 = call i64 @nova_rt_upper(i64 %r7)
  %r9.p = getelementptr inbounds [6 x i8], ptr @.str.1, i64 0, i64 0
  %r9 = ptrtoint ptr %r9.p to i64
  %r10 = call i64 @nova_rt_lower(i64 %r9)
  %r11 = call i64 @nova_rt_add(i64 %r8, i64 %r10)
  %r12 = call i64 @nova_rt_len_any(i64 %r11)
  store i64 %r12, ptr %slot.n, align 8
  %r13 = load i64, ptr %slot.count, align 8
  %r14 = load i64, ptr %slot.n, align 8
  %r15 = add i64 %r13, %r14
  store i64 %r15, ptr %slot.count, align 8
  %r16 = load i64, ptr %slot.__for_idx_3, align 8
  %r17 = add i64 1, 0
  %r18 = add i64 %r16, %r17
  store i64 %r18, ptr %slot.__for_idx_3, align 8
  br label %for_hdr3, !llvm.loop !91
for_exit5:
  %r19 = load i64, ptr %slot.count, align 8
  %r20 = call i64 @nova_rt_print_any(i64 %r19)
  ret i64 %r20
}

define i64 @test_unused_temps() nounwind {
entry:
  %slot.reverse = alloca i64, align 8
  store i64 0, ptr %slot.reverse, align 8
  %r1 = add i64 1, 0
  %r2 = add i64 2, 0
  %r3 = add i64 3, 0
  %r0 = call i64 @nova_rt_list_create()
  call i64 @nova_rt_list_append(i64 %r0, i64 %r1)
  call i64 @nova_rt_list_append(i64 %r0, i64 %r2)
  call i64 @nova_rt_list_append(i64 %r0, i64 %r3)
  %r4.p = getelementptr inbounds [6 x i8], ptr @.str.0, i64 0, i64 0
  %r4 = ptrtoint ptr %r4.p to i64
  %r5 = call i64 @nova_rt_upper(i64 %r4)
  %r7 = add i64 10, 0
  %r8 = add i64 20, 0
  %r6 = call i64 @nova_rt_list_create()
  call i64 @nova_rt_list_append(i64 %r6, i64 %r7)
  call i64 @nova_rt_list_append(i64 %r6, i64 %r8)
  %r10 = load i64, ptr %slot.reverse, align 8
  %r9.rec = inttoptr i64 %r10 to ptr
  %r9.fnraw = load i64, ptr %r9.rec, align 8
  %r9.fnptr = inttoptr i64 %r9.fnraw to ptr
  %r9 = call i64 %r9.fnptr(i64 %r10, i64 %r6)
  %r11.p = getelementptr inbounds [10 x i8], ptr @.str.2, i64 0, i64 0
  %r11 = ptrtoint ptr %r11.p to i64
  %r12 = call i64 @nova_rt_print_any(i64 %r11)
  ret i64 %r12
}

define i64 @test_mixed_types() nounwind {
entry:
  %slot.a = alloca i64, align 8
  store i64 0, ptr %slot.a, align 8
  %slot.b = alloca i64, align 8
  store i64 0, ptr %slot.b, align 8
  %slot.reverse = alloca i64, align 8
  store i64 0, ptr %slot.reverse, align 8
  %slot.c = alloca i64, align 8
  store i64 0, ptr %slot.c, align 8
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
  %r6 = call i64 @nova_rt_len_any(i64 %r0)
  store i64 %r6, ptr %slot.a, align 8
  %r7.p = getelementptr inbounds [3 x i8], ptr @.str.3, i64 0, i64 0
  %r7 = ptrtoint ptr %r7.p to i64
  %r8 = call i64 @nova_rt_upper(i64 %r7)
  %r9.p = getelementptr inbounds [4 x i8], ptr @.str.4, i64 0, i64 0
  %r9 = ptrtoint ptr %r9.p to i64
  %r10 = call i64 @nova_rt_lower(i64 %r9)
  %r11 = call i64 @nova_rt_add(i64 %r8, i64 %r10)
  %r12 = call i64 @nova_rt_len_any(i64 %r11)
  store i64 %r12, ptr %slot.b, align 8
  %r14 = add i64 10, 0
  %r15 = add i64 20, 0
  %r16 = add i64 30, 0
  %r13 = call i64 @nova_rt_list_create()
  call i64 @nova_rt_list_append(i64 %r13, i64 %r14)
  call i64 @nova_rt_list_append(i64 %r13, i64 %r15)
  call i64 @nova_rt_list_append(i64 %r13, i64 %r16)
  %r18 = load i64, ptr %slot.reverse, align 8
  %r17.rec = inttoptr i64 %r18 to ptr
  %r17.fnraw = load i64, ptr %r17.rec, align 8
  %r17.fnptr = inttoptr i64 %r17.fnraw to ptr
  %r17 = call i64 %r17.fnptr(i64 %r18, i64 %r13)
  %r19 = call i64 @nova_rt_len_any(i64 %r17)
  store i64 %r19, ptr %slot.c, align 8
  %r20 = load i64, ptr %slot.a, align 8
  %r21 = load i64, ptr %slot.b, align 8
  %r22 = add i64 %r20, %r21
  %r23 = load i64, ptr %slot.c, align 8
  %r24 = add i64 %r22, %r23
  %r25 = call i64 @nova_rt_print_any(i64 %r24)
  ret i64 %r25
}

define i64 @test_reassignment() nounwind {
entry:
  %slot.x = alloca i64, align 8
  store i64 0, ptr %slot.x, align 8
  %r1 = add i64 1, 0
  %r2 = add i64 2, 0
  %r3 = add i64 3, 0
  %r0 = call i64 @nova_rt_list_create()
  call i64 @nova_rt_list_append(i64 %r0, i64 %r1)
  call i64 @nova_rt_list_append(i64 %r0, i64 %r2)
  call i64 @nova_rt_list_append(i64 %r0, i64 %r3)
  store i64 %r0, ptr %slot.x, align 8
  %r5 = add i64 4, 0
  %r6 = add i64 5, 0
  %r7 = add i64 6, 0
  %r8 = add i64 7, 0
  %r4 = call i64 @nova_rt_list_create()
  call i64 @nova_rt_list_append(i64 %r4, i64 %r5)
  call i64 @nova_rt_list_append(i64 %r4, i64 %r6)
  call i64 @nova_rt_list_append(i64 %r4, i64 %r7)
  call i64 @nova_rt_list_append(i64 %r4, i64 %r8)
  store i64 %r4, ptr %slot.x, align 8
  %r10 = add i64 8, 0
  %r11 = add i64 9, 0
  %r9 = call i64 @nova_rt_list_create()
  call i64 @nova_rt_list_append(i64 %r9, i64 %r10)
  call i64 @nova_rt_list_append(i64 %r9, i64 %r11)
  store i64 %r9, ptr %slot.x, align 8
  %r12 = load i64, ptr %slot.x, align 8
  %r13 = call i64 @nova_rt_len_any(i64 %r12)
  %r14 = call i64 @nova_rt_print_any(i64 %r13)
  ret i64 %r14
}

define i64 @nova_main() nounwind {
entry:
  %r0 = call i64 @test_loop_temps()
  %r1 = call i64 @test_nested_chains()
  %r2 = call i64 @test_string_loop()
  %r3 = call i64 @test_unused_temps()
  %r4 = call i64 @test_mixed_types()
  %r5 = call i64 @test_reassignment()
  %r6.p = getelementptr inbounds [17 x i8], ptr @.str.5, i64 0, i64 0
  %r6 = ptrtoint ptr %r6.p to i64
  %r7 = call i64 @nova_rt_print_any(i64 %r6)
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
@.str.0 = private unnamed_addr constant [6 x i8] c"hello\00"
@.str.1 = private unnamed_addr constant [6 x i8] c"WORLD\00"
@.str.2 = private unnamed_addr constant [10 x i8] c"unused_ok\00"
@.str.3 = private unnamed_addr constant [3 x i8] c"hi\00"
@.str.4 = private unnamed_addr constant [4 x i8] c"BYE\00"
@.str.5 = private unnamed_addr constant [17 x i8] c"all_rc_stress_ok\00"

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
