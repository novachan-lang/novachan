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

define i64 @describe(i64 %p0) nounwind {
entry:
  %slot.p = alloca i64, align 8
  store i64 %p0, ptr %slot.p, align 8
  %slot.x = alloca i64, align 8
  store i64 0, ptr %slot.x, align 8
  %slot.y = alloca i64, align 8
  store i64 0, ptr %slot.y, align 8
  %r0 = load i64, ptr %slot.p, align 8
  %r1.ptr = inttoptr i64 %r0 to ptr
  %r1.gep = getelementptr i64, ptr %r1.ptr, i64 0
  %r1 = load i64, ptr %r1.gep, align 8
  %r2 = add i64 210686530511, 0
  %r3.cmp = icmp eq i64 %r1, %r2
  %r3 = zext i1 %r3.cmp to i64
  %br_rmarm_00 = icmp ne i64 %r3, 0
  br i1 %br_rmarm_00, label %rmarm_00, label %rmatch_fall1
rmarm_00:
  %r4.ptr = inttoptr i64 %r0 to ptr
  %r4.gep = getelementptr i64, ptr %r4.ptr, i64 1
  %r4 = load i64, ptr %r4.gep, align 8
  store i64 %r4, ptr %slot.x, align 8
  %r5.ptr = inttoptr i64 %r0 to ptr
  %r5.gep = getelementptr i64, ptr %r5.ptr, i64 2
  %r5 = load i64, ptr %r5.gep, align 8
  store i64 %r5, ptr %slot.y, align 8
  %r6.p = getelementptr inbounds [2 x i8], ptr @.str.0, i64 0, i64 0
  %r6 = ptrtoint ptr %r6.p to i64
  %r7 = load i64, ptr %slot.x, align 8
  %r8 = call i64 @nova_rt_int_to_str(i64 %r7)
  %r9 = call i64 @nova_rt_str_concat(i64 %r6, i64 %r8)
  %r10.p = getelementptr inbounds [3 x i8], ptr @.str.1, i64 0, i64 0
  %r10 = ptrtoint ptr %r10.p to i64
  %r11 = call i64 @nova_rt_str_concat(i64 %r9, i64 %r10)
  %r12 = load i64, ptr %slot.y, align 8
  %r13 = call i64 @nova_rt_int_to_str(i64 %r12)
  %r14 = call i64 @nova_rt_str_concat(i64 %r11, i64 %r13)
  %r15.p = getelementptr inbounds [2 x i8], ptr @.str.2, i64 0, i64 0
  %r15 = ptrtoint ptr %r15.p to i64
  %r16 = call i64 @nova_rt_str_concat(i64 %r14, i64 %r15)
  ret i64 %r16
rmatch_fall1:
  ret i64 0
}

define i64 @area_label(i64 %p0) nounwind {
entry:
  %slot.c = alloca i64, align 8
  store i64 %p0, ptr %slot.c, align 8
  %slot.r = alloca i64, align 8
  store i64 0, ptr %slot.r, align 8
  %r0 = load i64, ptr %slot.c, align 8
  %r1.ptr = inttoptr i64 %r0 to ptr
  %r1.gep = getelementptr i64, ptr %r1.ptr, i64 0
  %r1 = load i64, ptr %r1.gep, align 8
  %r2 = add i64 6952139942519, 0
  %r3.cmp = icmp eq i64 %r1, %r2
  %r3 = zext i1 %r3.cmp to i64
  %br_rmarm_02 = icmp ne i64 %r3, 0
  br i1 %br_rmarm_02, label %rmarm_02, label %rmatch_fall3
rmarm_02:
  %r4.ptr = inttoptr i64 %r0 to ptr
  %r4.gep = getelementptr i64, ptr %r4.ptr, i64 2
  %r4 = load i64, ptr %r4.gep, align 8
  store i64 %r4, ptr %slot.r, align 8
  %r5.p = getelementptr inbounds [6 x i8], ptr @.str.3, i64 0, i64 0
  %r5 = ptrtoint ptr %r5.p to i64
  %r6 = load i64, ptr %slot.r, align 8
  %r7 = load i64, ptr %slot.r, align 8
  %r8 = mul i64 %r6, %r7
  %r9 = call i64 @nova_rt_int_to_str(i64 %r8)
  %r10 = call i64 @nova_rt_str_concat(i64 %r5, i64 %r9)
  ret i64 %r10
rmatch_fall3:
  ret i64 0
}

define i64 @magnitude(i64 %p0) nounwind {
entry:
  %slot.p = alloca i64, align 8
  store i64 %p0, ptr %slot.p, align 8
  %slot.x = alloca i64, align 8
  store i64 0, ptr %slot.x, align 8
  %slot.y = alloca i64, align 8
  store i64 0, ptr %slot.y, align 8
  %r0 = load i64, ptr %slot.p, align 8
  %r1.ptr = inttoptr i64 %r0 to ptr
  %r1.gep = getelementptr i64, ptr %r1.ptr, i64 0
  %r1 = load i64, ptr %r1.gep, align 8
  %r2 = add i64 210686530511, 0
  %r3.cmp = icmp eq i64 %r1, %r2
  %r3 = zext i1 %r3.cmp to i64
  %br_rmarm_04 = icmp ne i64 %r3, 0
  br i1 %br_rmarm_04, label %rmarm_04, label %rmatch_fall5
rmarm_04:
  %r4.ptr = inttoptr i64 %r0 to ptr
  %r4.gep = getelementptr i64, ptr %r4.ptr, i64 1
  %r4 = load i64, ptr %r4.gep, align 8
  store i64 %r4, ptr %slot.x, align 8
  %r5.ptr = inttoptr i64 %r0 to ptr
  %r5.gep = getelementptr i64, ptr %r5.ptr, i64 2
  %r5 = load i64, ptr %r5.gep, align 8
  store i64 %r5, ptr %slot.y, align 8
  %r6 = load i64, ptr %slot.x, align 8
  %r7 = load i64, ptr %slot.x, align 8
  %r8 = mul i64 %r6, %r7
  %r9 = load i64, ptr %slot.y, align 8
  %r10 = load i64, ptr %slot.y, align 8
  %r11 = mul i64 %r9, %r10
  %r12 = add i64 %r8, %r11
  ret i64 %r12
rmatch_fall5:
  ret i64 0
}

define i64 @nova_main() nounwind {
entry:
  %slot.p = alloca i64, align 8
  store i64 0, ptr %slot.p, align 8
  %slot.c = alloca i64, align 8
  store i64 0, ptr %slot.c, align 8
  %r0 = add i64 3, 0
  %r1 = add i64 4, 0
  %r2.ptr = call ptr @nova_rt_struct_alloc(i64 24)
  %r2.thash = getelementptr i64, ptr %r2.ptr, i64 0
  store i64 210686530511, ptr %r2.thash, align 8
  %r2.f0 = getelementptr i64, ptr %r2.ptr, i64 1
  store i64 %r0, ptr %r2.f0, align 8
  %r2.f1 = getelementptr i64, ptr %r2.ptr, i64 2
  store i64 %r1, ptr %r2.f1, align 8
  %r2 = ptrtoint ptr %r2.ptr to i64
  store i64 %r2, ptr %slot.p, align 8
  %r3 = add i64 0, 0
  %r4 = add i64 5, 0
  %r5.ptr = call ptr @nova_rt_struct_alloc(i64 24)
  %r5.thash = getelementptr i64, ptr %r5.ptr, i64 0
  store i64 6952139942519, ptr %r5.thash, align 8
  %r5.f0 = getelementptr i64, ptr %r5.ptr, i64 1
  store i64 %r3, ptr %r5.f0, align 8
  %r5.f1 = getelementptr i64, ptr %r5.ptr, i64 2
  store i64 %r4, ptr %r5.f1, align 8
  %r5 = ptrtoint ptr %r5.ptr to i64
  store i64 %r5, ptr %slot.c, align 8
  %r6 = load i64, ptr %slot.p, align 8
  %r7 = call i64 @describe(i64 %r6)
  %r8 = call i64 @nova_rt_print_any(i64 %r7)
  %r9 = load i64, ptr %slot.c, align 8
  %r10 = call i64 @area_label(i64 %r9)
  %r11 = call i64 @nova_rt_print_any(i64 %r10)
  %r12 = add i64 3, 0
  %r13 = add i64 4, 0
  %r14.ptr = call ptr @nova_rt_struct_alloc(i64 24)
  %r14.thash = getelementptr i64, ptr %r14.ptr, i64 0
  store i64 210686530511, ptr %r14.thash, align 8
  %r14.f0 = getelementptr i64, ptr %r14.ptr, i64 1
  store i64 %r12, ptr %r14.f0, align 8
  %r14.f1 = getelementptr i64, ptr %r14.ptr, i64 2
  store i64 %r13, ptr %r14.f1, align 8
  %r14 = ptrtoint ptr %r14.ptr to i64
  %r15 = call i64 @magnitude(i64 %r14)
  %r16 = call i64 @nova_rt_int_to_str(i64 %r15)
  %r17 = call i64 @nova_rt_print_any(i64 %r16)
  %r18 = add i64 5, 0
  %r19 = add i64 12, 0
  %r20.ptr = call ptr @nova_rt_struct_alloc(i64 24)
  %r20.thash = getelementptr i64, ptr %r20.ptr, i64 0
  store i64 210686530511, ptr %r20.thash, align 8
  %r20.f0 = getelementptr i64, ptr %r20.ptr, i64 1
  store i64 %r18, ptr %r20.f0, align 8
  %r20.f1 = getelementptr i64, ptr %r20.ptr, i64 2
  store i64 %r19, ptr %r20.f1, align 8
  %r20 = ptrtoint ptr %r20.ptr to i64
  %r21 = call i64 @magnitude(i64 %r20)
  %r22 = call i64 @nova_rt_int_to_str(i64 %r21)
  %r23 = call i64 @nova_rt_print_any(i64 %r22)
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
@.str.0 = private unnamed_addr constant [2 x i8] c"(\00"
@.str.1 = private unnamed_addr constant [3 x i8] c", \00"
@.str.2 = private unnamed_addr constant [2 x i8] c")\00"
@.str.3 = private unnamed_addr constant [6 x i8] c"area=\00"

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
