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
  %slot.start = alloca i64, align 8
  store i64 0, ptr %slot.start, align 8
  %slot.end = alloca i64, align 8
  store i64 0, ptr %slot.end, align 8
  %slot.elapsed = alloca i64, align 8
  store i64 0, ptr %slot.elapsed, align 8
  %slot.t1 = alloca i64, align 8
  store i64 0, ptr %slot.t1, align 8
  %slot.t2 = alloca i64, align 8
  store i64 0, ptr %slot.t2, align 8
  %r0 = call i64 @nova_rt_time_ms()
  store i64 %r0, ptr %slot.start, align 8
  %r1 = add i64 10, 0
  %r2 = call i64 @nova_rt_sleep_ms(i64 %r1)
  %r3 = call i64 @nova_rt_time_ms()
  store i64 %r3, ptr %slot.end, align 8
  %r4 = load i64, ptr %slot.end, align 8
  %r5 = load i64, ptr %slot.start, align 8
  %r6 = sub i64 %r4, %r5
  store i64 %r6, ptr %slot.elapsed, align 8
  %r7.p = getelementptr inbounds [19 x i8], ptr @.str.0, i64 0, i64 0
  %r7 = ptrtoint ptr %r7.p to i64
  %r8 = load i64, ptr %slot.elapsed, align 8
  %r9 = add i64 10, 0
  %r10.cmp = icmp sge i64 %r8, %r9
  %r10 = zext i1 %r10.cmp to i64
  %r11 = call i64 @nova_rt_int_to_str(i64 %r10)
  %r12 = call i64 @nova_rt_str_concat(i64 %r7, i64 %r11)
  %r13 = call i64 @nova_rt_print_any(i64 %r12)
  %r14 = call i64 @nova_rt_clock_ns()
  store i64 %r14, ptr %slot.t1, align 8
  %r15 = call i64 @nova_rt_clock_ns()
  store i64 %r15, ptr %slot.t2, align 8
  %r16.p = getelementptr inbounds [21 x i8], ptr @.str.1, i64 0, i64 0
  %r16 = ptrtoint ptr %r16.p to i64
  %r17 = load i64, ptr %slot.t2, align 8
  %r18 = load i64, ptr %slot.t1, align 8
  %r19.cmp = icmp sge i64 %r17, %r18
  %r19 = zext i1 %r19.cmp to i64
  %r20 = call i64 @nova_rt_int_to_str(i64 %r19)
  %r21 = call i64 @nova_rt_str_concat(i64 %r16, i64 %r20)
  %r22 = call i64 @nova_rt_print_any(i64 %r21)
  %r23.p = getelementptr inbounds [14 x i8], ptr @.str.2, i64 0, i64 0
  %r23 = ptrtoint ptr %r23.p to i64
  %r24 = load i64, ptr %slot.start, align 8
  %r25 = add i64 0, 0
  %r26.cmp = icmp sgt i64 %r24, %r25
  %r26 = zext i1 %r26.cmp to i64
  %r27 = call i64 @nova_rt_int_to_str(i64 %r26)
  %r28 = call i64 @nova_rt_str_concat(i64 %r23, i64 %r27)
  %r29 = call i64 @nova_rt_print_any(i64 %r28)
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
@.str.0 = private unnamed_addr constant [19 x i8] c"elapsed_ms >= 10: \00"
@.str.1 = private unnamed_addr constant [21 x i8] c"clock_ns monotonic: \00"
@.str.2 = private unnamed_addr constant [14 x i8] c"time_ms > 0: \00"

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
