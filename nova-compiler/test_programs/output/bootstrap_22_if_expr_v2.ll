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

define i64 @abs_val(i64 %p0) nounwind {
entry:
  %slot.n = alloca i64, align 8
  store i64 %p0, ptr %slot.n, align 8
  %slot.__ifexpr_0 = alloca i64, align 8
  store i64 0, ptr %slot.__ifexpr_0, align 8
  %r0 = load i64, ptr %slot.n, align 8
  %r1 = add i64 0, 0
  %r2.cmp = icmp slt i64 %r0, %r1
  %r2 = zext i1 %r2.cmp to i64
  %br_ife_then1 = icmp ne i64 %r2, 0
  br i1 %br_ife_then1, label %ife_then1, label %ife_else2
ife_then1:
  %r3 = load i64, ptr %slot.n, align 8
  %r4 = sub i64 0, %r3
  store i64 %r4, ptr %slot.__ifexpr_0, align 8
  br label %ife_merge3
ife_else2:
  %r5 = load i64, ptr %slot.n, align 8
  store i64 %r5, ptr %slot.__ifexpr_0, align 8
  br label %ife_merge3
ife_merge3:
  %r6 = load i64, ptr %slot.__ifexpr_0, align 8
  ret i64 %r6
}

define i64 @sign(i64 %p0) nounwind {
entry:
  %slot.n = alloca i64, align 8
  store i64 %p0, ptr %slot.n, align 8
  %slot.__ifexpr_4 = alloca i64, align 8
  store i64 0, ptr %slot.__ifexpr_4, align 8
  %slot.__ifexpr_8 = alloca i64, align 8
  store i64 0, ptr %slot.__ifexpr_8, align 8
  %r0 = load i64, ptr %slot.n, align 8
  %r1 = add i64 0, 0
  %r2.cmp = icmp sgt i64 %r0, %r1
  %r2 = zext i1 %r2.cmp to i64
  %br_ife_then5 = icmp ne i64 %r2, 0
  br i1 %br_ife_then5, label %ife_then5, label %ife_else6
ife_then5:
  %r3.p = getelementptr inbounds [9 x i8], ptr @.str.0, i64 0, i64 0
  %r3 = ptrtoint ptr %r3.p to i64
  store i64 %r3, ptr %slot.__ifexpr_4, align 8
  br label %ife_merge7
ife_else6:
  %r4 = load i64, ptr %slot.n, align 8
  %r5 = add i64 0, 0
  %r6.cmp = icmp slt i64 %r4, %r5
  %r6 = zext i1 %r6.cmp to i64
  %br_ife_then9 = icmp ne i64 %r6, 0
  br i1 %br_ife_then9, label %ife_then9, label %ife_else10
ife_then9:
  %r7.p = getelementptr inbounds [9 x i8], ptr @.str.1, i64 0, i64 0
  %r7 = ptrtoint ptr %r7.p to i64
  store i64 %r7, ptr %slot.__ifexpr_8, align 8
  br label %ife_merge11
ife_else10:
  %r8.p = getelementptr inbounds [5 x i8], ptr @.str.2, i64 0, i64 0
  %r8 = ptrtoint ptr %r8.p to i64
  store i64 %r8, ptr %slot.__ifexpr_8, align 8
  br label %ife_merge11
ife_merge11:
  %r9 = load i64, ptr %slot.__ifexpr_8, align 8
  store i64 %r9, ptr %slot.__ifexpr_4, align 8
  br label %ife_merge7
ife_merge7:
  %r10 = load i64, ptr %slot.__ifexpr_4, align 8
  ret i64 %r10
}

define i64 @nova_main() nounwind {
entry:
  %slot.x = alloca i64, align 8
  store i64 0, ptr %slot.x, align 8
  %slot.__ifexpr_12 = alloca i64, align 8
  store i64 0, ptr %slot.__ifexpr_12, align 8
  %slot.label = alloca i64, align 8
  store i64 0, ptr %slot.label, align 8
  %slot.a = alloca i64, align 8
  store i64 0, ptr %slot.a, align 8
  %slot.b = alloca i64, align 8
  store i64 0, ptr %slot.b, align 8
  %slot.__ifexpr_16 = alloca i64, align 8
  store i64 0, ptr %slot.__ifexpr_16, align 8
  %slot.max_val = alloca i64, align 8
  store i64 0, ptr %slot.max_val, align 8
  %r0 = add i64 5, 0
  store i64 %r0, ptr %slot.x, align 8
  %r1 = load i64, ptr %slot.x, align 8
  %r2 = add i64 3, 0
  %r3.cmp = icmp sgt i64 %r1, %r2
  %r3 = zext i1 %r3.cmp to i64
  %br_ife_then13 = icmp ne i64 %r3, 0
  br i1 %br_ife_then13, label %ife_then13, label %ife_else14
ife_then13:
  %r4.p = getelementptr inbounds [4 x i8], ptr @.str.3, i64 0, i64 0
  %r4 = ptrtoint ptr %r4.p to i64
  store i64 %r4, ptr %slot.__ifexpr_12, align 8
  br label %ife_merge15
ife_else14:
  %r5.p = getelementptr inbounds [6 x i8], ptr @.str.4, i64 0, i64 0
  %r5 = ptrtoint ptr %r5.p to i64
  store i64 %r5, ptr %slot.__ifexpr_12, align 8
  br label %ife_merge15
ife_merge15:
  %r6 = load i64, ptr %slot.__ifexpr_12, align 8
  store i64 %r6, ptr %slot.label, align 8
  %r7 = load i64, ptr %slot.label, align 8
  %r8 = call i64 @nova_rt_print_any(i64 %r7)
  %r9 = add i64 7, 0
  %r10 = sub i64 0, %r9
  %r11 = call i64 @abs_val(i64 %r10)
  %r12 = call i64 @nova_rt_print_any(i64 %r11)
  %r13 = add i64 3, 0
  %r14 = call i64 @abs_val(i64 %r13)
  %r15 = call i64 @nova_rt_print_any(i64 %r14)
  %r16 = add i64 10, 0
  store i64 %r16, ptr %slot.a, align 8
  %r17 = add i64 20, 0
  store i64 %r17, ptr %slot.b, align 8
  %r18 = load i64, ptr %slot.a, align 8
  %r19 = load i64, ptr %slot.b, align 8
  %r20.cmp = icmp sgt i64 %r18, %r19
  %r20 = zext i1 %r20.cmp to i64
  %br_ife_then17 = icmp ne i64 %r20, 0
  br i1 %br_ife_then17, label %ife_then17, label %ife_else18
ife_then17:
  %r21 = load i64, ptr %slot.a, align 8
  store i64 %r21, ptr %slot.__ifexpr_16, align 8
  br label %ife_merge19
ife_else18:
  %r22 = load i64, ptr %slot.b, align 8
  store i64 %r22, ptr %slot.__ifexpr_16, align 8
  br label %ife_merge19
ife_merge19:
  %r23 = load i64, ptr %slot.__ifexpr_16, align 8
  store i64 %r23, ptr %slot.max_val, align 8
  %r24 = load i64, ptr %slot.max_val, align 8
  %r25 = call i64 @nova_rt_print_any(i64 %r24)
  %r26 = add i64 5, 0
  %r27 = call i64 @sign(i64 %r26)
  %r28 = call i64 @nova_rt_print_any(i64 %r27)
  %r29 = add i64 3, 0
  %r30 = sub i64 0, %r29
  %r31 = call i64 @sign(i64 %r30)
  %r32 = call i64 @nova_rt_print_any(i64 %r31)
  %r33 = add i64 0, 0
  %r34 = call i64 @sign(i64 %r33)
  %r35 = call i64 @nova_rt_print_any(i64 %r34)
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
@.str.0 = private unnamed_addr constant [9 x i8] c"positive\00"
@.str.1 = private unnamed_addr constant [9 x i8] c"negative\00"
@.str.2 = private unnamed_addr constant [5 x i8] c"zero\00"
@.str.3 = private unnamed_addr constant [4 x i8] c"big\00"
@.str.4 = private unnamed_addr constant [6 x i8] c"small\00"

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
