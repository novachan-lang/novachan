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

define i64 @count_primes(i64 %p0) nounwind {
entry:
  %slot.limit = alloca i64, align 8
  store i64 %p0, ptr %slot.limit, align 8
  %slot.sieve = alloca i64, align 8
  store i64 0, ptr %slot.sieve, align 8
  %slot.idx = alloca i64, align 8
  store i64 0, ptr %slot.idx, align 8
  %slot.count = alloca i64, align 8
  store i64 0, ptr %slot.count, align 8
  %slot.i = alloca i64, align 8
  store i64 0, ptr %slot.i, align 8
  %slot.j = alloca i64, align 8
  store i64 0, ptr %slot.j, align 8
  %r0 = call i64 @nova_rt_list_create()
  store i64 %r0, ptr %slot.sieve, align 8
  %r1 = add i64 0, 0
  store i64 %r1, ptr %slot.idx, align 8
  br label %while_hdr0, !llvm.loop !91
while_hdr0:
  %r2 = load i64, ptr %slot.idx, align 8
  %r3 = load i64, ptr %slot.limit, align 8
  %r4.cmp = icmp sle i64 %r2, %r3
  %r4 = zext i1 %r4.cmp to i64
  %br_while_body1 = icmp ne i64 %r4, 0
  br i1 %br_while_body1, label %while_body1, label %while_exit2, !prof !90
while_body1:
  %r5 = load i64, ptr %slot.sieve, align 8
  %r6 = add i64 0, 0
  %r7 = call i64 @nova_rt_list_append(i64 %r5, i64 %r6)
  %r8 = load i64, ptr %slot.idx, align 8
  %r9 = add i64 1, 0
  %r10 = add i64 %r8, %r9
  store i64 %r10, ptr %slot.idx, align 8
  br label %while_hdr0, !llvm.loop !91
while_exit2:
  %r11 = add i64 0, 0
  store i64 %r11, ptr %slot.count, align 8
  %r12 = add i64 2, 0
  store i64 %r12, ptr %slot.i, align 8
  br label %while_hdr3, !llvm.loop !91
while_hdr3:
  %r13 = load i64, ptr %slot.i, align 8
  %r14 = load i64, ptr %slot.limit, align 8
  %r15.cmp = icmp sle i64 %r13, %r14
  %r15 = zext i1 %r15.cmp to i64
  %br_while_body4 = icmp ne i64 %r15, 0
  br i1 %br_while_body4, label %while_body4, label %while_exit5, !prof !90
while_body4:
  %r16 = load i64, ptr %slot.sieve, align 8
  %r17 = load i64, ptr %slot.i, align 8
  %r18.lp = inttoptr i64 %r16 to ptr
  %r18.dp = load ptr, ptr %r18.lp, align 8, !tbaa !2
  %r18.ep = getelementptr i64, ptr %r18.dp, i64 %r17
  %r18 = load i64, ptr %r18.ep, align 8, !tbaa !4
  %r19 = add i64 0, 0
  %r20 = call i64 @nova_rt_eq(i64 %r18, i64 %r19)
  %br_then6 = icmp ne i64 %r20, 0
  br i1 %br_then6, label %then6, label %else7
then6:
  %r21 = load i64, ptr %slot.count, align 8
  %r22 = add i64 1, 0
  %r23 = add i64 %r21, %r22
  store i64 %r23, ptr %slot.count, align 8
  %r24 = load i64, ptr %slot.i, align 8
  %r25 = load i64, ptr %slot.i, align 8
  %r26 = mul i64 %r24, %r25
  store i64 %r26, ptr %slot.j, align 8
  br label %while_hdr9, !llvm.loop !91
while_hdr9:
  %r27 = load i64, ptr %slot.j, align 8
  %r28 = load i64, ptr %slot.limit, align 8
  %r29.cmp = icmp sle i64 %r27, %r28
  %r29 = zext i1 %r29.cmp to i64
  %br_while_body10 = icmp ne i64 %r29, 0
  br i1 %br_while_body10, label %while_body10, label %while_exit11, !prof !90
while_body10:
  %r30 = add i64 1, 0
  %r31 = load i64, ptr %slot.sieve, align 8
  %r32 = load i64, ptr %slot.j, align 8
  %_iset.lp0 = inttoptr i64 %r31 to ptr
  %_iset.dp1 = load ptr, ptr %_iset.lp0, align 8, !tbaa !2
  %_iset.ep2 = getelementptr i64, ptr %_iset.dp1, i64 %r32
  store i64 %r30, ptr %_iset.ep2, align 8, !tbaa !4
  %r33 = load i64, ptr %slot.j, align 8
  %r34 = load i64, ptr %slot.i, align 8
  %r35 = add i64 %r33, %r34
  store i64 %r35, ptr %slot.j, align 8
  br label %while_hdr9, !llvm.loop !91
while_exit11:
  br label %endif8
else7:
  br label %endif8
endif8:
  %r36 = load i64, ptr %slot.i, align 8
  %r37 = add i64 1, 0
  %r38 = add i64 %r36, %r37
  store i64 %r38, ptr %slot.i, align 8
  br label %while_hdr3, !llvm.loop !91
while_exit5:
  %r39 = load i64, ptr %slot.count, align 8
  ret i64 %r39
}

define i64 @nova_main() nounwind {
entry:
  %slot.result = alloca i64, align 8
  store i64 0, ptr %slot.result, align 8
  %r0 = add i64 10000000, 0
  %r1 = call i64 @count_primes(i64 %r0)
  store i64 %r1, ptr %slot.result, align 8
  %r2.p = getelementptr inbounds [19 x i8], ptr @.str.0, i64 0, i64 0
  %r2 = ptrtoint ptr %r2.p to i64
  %r3 = load i64, ptr %slot.result, align 8
  %r4 = call i64 @nova_rt_int_to_str(i64 %r3)
  %r5 = call i64 @nova_rt_str_concat(i64 %r2, i64 %r4)
  %r6 = call i64 @nova_rt_print_any(i64 %r5)
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
@.str.0 = private unnamed_addr constant [19 x i8] c"Primes up to 10M: \00"

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
