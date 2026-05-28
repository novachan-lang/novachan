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
  %slot.items = alloca i64, align 8
  store i64 0, ptr %slot.items, align 8
  %slot.first = alloca i64, align 8
  store i64 0, ptr %slot.first, align 8
  %slot.a = alloca i64, align 8
  store i64 0, ptr %slot.a, align 8
  %slot.b = alloca i64, align 8
  store i64 0, ptr %slot.b, align 8
  %slot.second = alloca i64, align 8
  store i64 0, ptr %slot.second, align 8
  %r0 = call i64 @nova_rt_list_create()
  store i64 %r0, ptr %slot.items, align 8
  %r1 = load i64, ptr %slot.items, align 8
  %r2.p = getelementptr inbounds [6 x i8], ptr @.str.0, i64 0, i64 0
  %r2 = ptrtoint ptr %r2.p to i64
  %r3 = add i64 1, 0
  %r4.ptr = call ptr @nova_rt_struct_alloc(i64 24)
  %r4.thash = getelementptr i64, ptr %r4.ptr, i64 0
  store i64 6384425073, ptr %r4.thash, align 8
  %r4.f0 = getelementptr i64, ptr %r4.ptr, i64 1
  store i64 %r2, ptr %r4.f0, align 8
  %r4.f1 = getelementptr i64, ptr %r4.ptr, i64 2
  store i64 %r3, ptr %r4.f1, align 8
  %r4 = ptrtoint ptr %r4.ptr to i64
  %r5 = call i64 @nova_rt_list_append(i64 %r1, i64 %r4)
  %r6 = load i64, ptr %slot.items, align 8
  %r7.p = getelementptr inbounds [6 x i8], ptr @.str.1, i64 0, i64 0
  %r7 = ptrtoint ptr %r7.p to i64
  %r8 = add i64 2, 0
  %r9.ptr = call ptr @nova_rt_struct_alloc(i64 24)
  %r9.thash = getelementptr i64, ptr %r9.ptr, i64 0
  store i64 6384425073, ptr %r9.thash, align 8
  %r9.f0 = getelementptr i64, ptr %r9.ptr, i64 1
  store i64 %r7, ptr %r9.f0, align 8
  %r9.f1 = getelementptr i64, ptr %r9.ptr, i64 2
  store i64 %r8, ptr %r9.f1, align 8
  %r9 = ptrtoint ptr %r9.ptr to i64
  %r10 = call i64 @nova_rt_list_append(i64 %r6, i64 %r9)
  %r11 = load i64, ptr %slot.items, align 8
  %r12 = add i64 0, 0
  %r13.lp = inttoptr i64 %r11 to ptr
  %r13.dp = load ptr, ptr %r13.lp, align 8, !tbaa !2
  %r13.ep = getelementptr i64, ptr %r13.dp, i64 %r12
  %r13 = load i64, ptr %r13.ep, align 8, !tbaa !4
  store i64 %r13, ptr %slot.first, align 8
  %r14 = load i64, ptr %slot.first, align 8
  %r15.ptr = inttoptr i64 %r14 to ptr
  %r15.gep = getelementptr i64, ptr %r15.ptr, i64 0
  %r15 = load i64, ptr %r15.gep, align 8
  %r16 = add i64 6384425073, 0
  %r17.cmp = icmp eq i64 %r15, %r16
  %r17 = zext i1 %r17.cmp to i64
  %br_marm_01 = icmp ne i64 %r17, 0
  br i1 %br_marm_01, label %marm_01, label %match_fall2
marm_01:
  %r18.ptr = inttoptr i64 %r14 to ptr
  %r18.gep = getelementptr i64, ptr %r18.ptr, i64 1
  %r18 = load i64, ptr %r18.gep, align 8
  store i64 %r18, ptr %slot.a, align 8
  %r19.ptr = inttoptr i64 %r14 to ptr
  %r19.gep = getelementptr i64, ptr %r19.ptr, i64 2
  %r19 = load i64, ptr %r19.gep, align 8
  store i64 %r19, ptr %slot.b, align 8
  %r20 = load i64, ptr %slot.a, align 8
  %r21 = call i64 @nova_rt_print_any(i64 %r20)
  %r22 = load i64, ptr %slot.b, align 8
  %r23 = call i64 @nova_rt_int_to_str(i64 %r22)
  %r24 = call i64 @nova_rt_print_any(i64 %r23)
  br label %match_exit0
match_fall2:
  br label %match_exit0
match_exit0:
  %r25 = load i64, ptr %slot.items, align 8
  %r26 = add i64 1, 0
  %r27.lp = inttoptr i64 %r25 to ptr
  %r27.dp = load ptr, ptr %r27.lp, align 8, !tbaa !2
  %r27.ep = getelementptr i64, ptr %r27.dp, i64 %r26
  %r27 = load i64, ptr %r27.ep, align 8, !tbaa !4
  store i64 %r27, ptr %slot.second, align 8
  %r28 = load i64, ptr %slot.second, align 8
  %r29.ptr = inttoptr i64 %r28 to ptr
  %r29.gep = getelementptr i64, ptr %r29.ptr, i64 0
  %r29 = load i64, ptr %r29.gep, align 8
  %r30 = add i64 6384425073, 0
  %r31.cmp = icmp eq i64 %r29, %r30
  %r31 = zext i1 %r31.cmp to i64
  %br_marm_04 = icmp ne i64 %r31, 0
  br i1 %br_marm_04, label %marm_04, label %match_fall5
marm_04:
  %r32.ptr = inttoptr i64 %r28 to ptr
  %r32.gep = getelementptr i64, ptr %r32.ptr, i64 1
  %r32 = load i64, ptr %r32.gep, align 8
  store i64 %r32, ptr %slot.a, align 8
  %r33.ptr = inttoptr i64 %r28 to ptr
  %r33.gep = getelementptr i64, ptr %r33.ptr, i64 2
  %r33 = load i64, ptr %r33.gep, align 8
  store i64 %r33, ptr %slot.b, align 8
  %r34 = load i64, ptr %slot.a, align 8
  %r35 = call i64 @nova_rt_print_any(i64 %r34)
  %r36 = load i64, ptr %slot.b, align 8
  %r37 = call i64 @nova_rt_int_to_str(i64 %r36)
  %r38 = call i64 @nova_rt_print_any(i64 %r37)
  br label %match_exit3
match_fall5:
  br label %match_exit3
match_exit3:
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
@.str.1 = private unnamed_addr constant [6 x i8] c"world\00"

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
