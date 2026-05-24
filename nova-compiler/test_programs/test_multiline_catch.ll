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

define i64 @risky_divide(i64 %p0, i64 %p1) nounwind {
entry:
  %slot.a = alloca i64, align 8
  store i64 %p0, ptr %slot.a, align 8
  %slot.b = alloca i64, align 8
  store i64 %p1, ptr %slot.b, align 8
  %r0 = load i64, ptr %slot.b, align 8
  %r1 = add i64 0, 0
  %r2.cmp = icmp eq i64 %r0, %r1
  %r2 = zext i1 %r2.cmp to i64
  %br_then0 = icmp ne i64 %r2, 0
  br i1 %br_then0, label %then0, label %else1
then0:
  %r3.p = getelementptr inbounds [17 x i8], ptr @.str.0, i64 0, i64 0
  %r3 = ptrtoint ptr %r3.p to i64
  store i64 1, ptr @__nova_error_flag
  store i64 %r3, ptr @__nova_error_msg
  %r4 = add i64 0, 0
  %r5 = add i64 0, 0
  ret i64 %r5
else1:
  br label %endif2
endif2:
  %r6 = load i64, ptr %slot.a, align 8
  %r7 = load i64, ptr %slot.b, align 8
  %r8 = sdiv i64 %r6, %r7
  ret i64 %r8
}

define i64 @nova_user_main() nounwind {
entry:
  %slot.__catch_3 = alloca i64, align 8
  store i64 0, ptr %slot.__catch_3, align 8
  %slot.e = alloca i64, align 8
  store i64 0, ptr %slot.e, align 8
  %slot.r1 = alloca i64, align 8
  store i64 0, ptr %slot.r1, align 8
  %slot.__catch_7 = alloca i64, align 8
  store i64 0, ptr %slot.__catch_7, align 8
  %slot.fallback = alloca i64, align 8
  store i64 0, ptr %slot.fallback, align 8
  %slot.r2 = alloca i64, align 8
  store i64 0, ptr %slot.r2, align 8
  %slot.__catch_11 = alloca i64, align 8
  store i64 0, ptr %slot.__catch_11, align 8
  %slot.r3 = alloca i64, align 8
  store i64 0, ptr %slot.r3, align 8
  %slot.__catch_15 = alloca i64, align 8
  store i64 0, ptr %slot.__catch_15, align 8
  %slot.a = alloca i64, align 8
  store i64 0, ptr %slot.a, align 8
  %slot.b = alloca i64, align 8
  store i64 0, ptr %slot.b, align 8
  %slot.r4 = alloca i64, align 8
  store i64 0, ptr %slot.r4, align 8
  %r0 = add i64 10, 0
  %r1 = add i64 0, 0
  %r2 = call i64 @risky_divide(i64 %r0, i64 %r1)
  store i64 %r2, ptr %slot.__catch_3, align 8
  %r3.fl = load i64, ptr @__nova_error_flag
  store i64 0, ptr @__nova_error_flag
  %r3.cmp = icmp ne i64 %r3.fl, 0
  %r3 = zext i1 %r3.cmp to i64
  %br_catch_err4 = icmp ne i64 %r3, 0
  br i1 %br_catch_err4, label %catch_err4, label %catch_ok5
catch_err4:
  %r4.raw = load i64, ptr @__nova_error_msg
  store i64 0, ptr @__nova_error_msg
  %r4 = add i64 %r4.raw, 0
  store i64 %r4, ptr %slot.e, align 8
  %r5 = add i64 1, 0
  %r6 = sub i64 0, %r5
  store i64 %r6, ptr %slot.__catch_3, align 8
  br label %catch_merge6
catch_ok5:
  store i64 %r2, ptr %slot.__catch_3, align 8
  br label %catch_merge6
catch_merge6:
  %r7 = load i64, ptr %slot.__catch_3, align 8
  store i64 %r7, ptr %slot.r1, align 8
  %r8.p = getelementptr inbounds [14 x i8], ptr @.str.1, i64 0, i64 0
  %r8 = ptrtoint ptr %r8.p to i64
  %r9 = load i64, ptr %slot.r1, align 8
  %r10 = call i64 @nova_rt_any_to_str(i64 %r9)
  %r11 = call i64 @nova_rt_str_concat(i64 %r8, i64 %r10)
  %r12.p = getelementptr inbounds [1 x i8], ptr @.str.2, i64 0, i64 0
  %r12 = ptrtoint ptr %r12.p to i64
  %r13 = call i64 @nova_rt_str_concat(i64 %r11, i64 %r12)
  %r14 = call i64 @nova_rt_print_any(i64 %r13)
  %r15 = add i64 10, 0
  %r16 = add i64 0, 0
  %r17 = call i64 @risky_divide(i64 %r15, i64 %r16)
  store i64 %r17, ptr %slot.__catch_7, align 8
  %r18.fl = load i64, ptr @__nova_error_flag
  store i64 0, ptr @__nova_error_flag
  %r18.cmp = icmp ne i64 %r18.fl, 0
  %r18 = zext i1 %r18.cmp to i64
  %br_catch_err8 = icmp ne i64 %r18, 0
  br i1 %br_catch_err8, label %catch_err8, label %catch_ok9
catch_err8:
  %r19.raw = load i64, ptr @__nova_error_msg
  store i64 0, ptr @__nova_error_msg
  %r19 = add i64 %r19.raw, 0
  store i64 %r19, ptr %slot.e, align 8
  %r20.p = getelementptr inbounds [15 x i8], ptr @.str.3, i64 0, i64 0
  %r20 = ptrtoint ptr %r20.p to i64
  %r21 = load i64, ptr %slot.e, align 8
  %r22 = call i64 @nova_rt_any_to_str(i64 %r21)
  %r23 = call i64 @nova_rt_str_concat(i64 %r20, i64 %r22)
  %r24.p = getelementptr inbounds [1 x i8], ptr @.str.2, i64 0, i64 0
  %r24 = ptrtoint ptr %r24.p to i64
  %r25 = call i64 @nova_rt_str_concat(i64 %r23, i64 %r24)
  %r26 = call i64 @nova_rt_print_any(i64 %r25)
  %r27 = add i64 42, 0
  store i64 %r27, ptr %slot.fallback, align 8
  %r28 = load i64, ptr %slot.fallback, align 8
  store i64 %r28, ptr %slot.__catch_7, align 8
  br label %catch_merge10
catch_ok9:
  store i64 %r17, ptr %slot.__catch_7, align 8
  br label %catch_merge10
catch_merge10:
  %r29 = load i64, ptr %slot.__catch_7, align 8
  store i64 %r29, ptr %slot.r2, align 8
  %r30.p = getelementptr inbounds [13 x i8], ptr @.str.4, i64 0, i64 0
  %r30 = ptrtoint ptr %r30.p to i64
  %r31 = load i64, ptr %slot.r2, align 8
  %r32 = call i64 @nova_rt_any_to_str(i64 %r31)
  %r33 = call i64 @nova_rt_str_concat(i64 %r30, i64 %r32)
  %r34.p = getelementptr inbounds [1 x i8], ptr @.str.2, i64 0, i64 0
  %r34 = ptrtoint ptr %r34.p to i64
  %r35 = call i64 @nova_rt_str_concat(i64 %r33, i64 %r34)
  %r36 = call i64 @nova_rt_print_any(i64 %r35)
  %r37 = add i64 100, 0
  %r38 = add i64 5, 0
  %r39 = call i64 @risky_divide(i64 %r37, i64 %r38)
  store i64 %r39, ptr %slot.__catch_11, align 8
  %r40.fl = load i64, ptr @__nova_error_flag
  store i64 0, ptr @__nova_error_flag
  %r40.cmp = icmp ne i64 %r40.fl, 0
  %r40 = zext i1 %r40.cmp to i64
  %br_catch_err12 = icmp ne i64 %r40, 0
  br i1 %br_catch_err12, label %catch_err12, label %catch_ok13
catch_err12:
  %r41.raw = load i64, ptr @__nova_error_msg
  store i64 0, ptr @__nova_error_msg
  %r41 = add i64 %r41.raw, 0
  store i64 %r41, ptr %slot.e, align 8
  %r42.p = getelementptr inbounds [17 x i8], ptr @.str.5, i64 0, i64 0
  %r42 = ptrtoint ptr %r42.p to i64
  %r43 = call i64 @nova_rt_print_any(i64 %r42)
  %r44 = add i64 1, 0
  %r45 = sub i64 0, %r44
  store i64 %r45, ptr %slot.__catch_11, align 8
  br label %catch_merge14
catch_ok13:
  store i64 %r39, ptr %slot.__catch_11, align 8
  br label %catch_merge14
catch_merge14:
  %r46 = load i64, ptr %slot.__catch_11, align 8
  store i64 %r46, ptr %slot.r3, align 8
  %r47.p = getelementptr inbounds [11 x i8], ptr @.str.6, i64 0, i64 0
  %r47 = ptrtoint ptr %r47.p to i64
  %r48 = load i64, ptr %slot.r3, align 8
  %r49 = call i64 @nova_rt_any_to_str(i64 %r48)
  %r50 = call i64 @nova_rt_str_concat(i64 %r47, i64 %r49)
  %r51.p = getelementptr inbounds [1 x i8], ptr @.str.2, i64 0, i64 0
  %r51 = ptrtoint ptr %r51.p to i64
  %r52 = call i64 @nova_rt_str_concat(i64 %r50, i64 %r51)
  %r53 = call i64 @nova_rt_print_any(i64 %r52)
  %r54 = add i64 10, 0
  %r55 = add i64 0, 0
  %r56 = call i64 @risky_divide(i64 %r54, i64 %r55)
  store i64 %r56, ptr %slot.__catch_15, align 8
  %r57.fl = load i64, ptr @__nova_error_flag
  store i64 0, ptr @__nova_error_flag
  %r57.cmp = icmp ne i64 %r57.fl, 0
  %r57 = zext i1 %r57.cmp to i64
  %br_catch_err16 = icmp ne i64 %r57, 0
  br i1 %br_catch_err16, label %catch_err16, label %catch_ok17
catch_err16:
  %r58.raw = load i64, ptr @__nova_error_msg
  store i64 0, ptr @__nova_error_msg
  %r58 = add i64 %r58.raw, 0
  store i64 %r58, ptr %slot.e, align 8
  %r59 = add i64 10, 0
  store i64 %r59, ptr %slot.a, align 8
  %r60 = add i64 20, 0
  store i64 %r60, ptr %slot.b, align 8
  %r61 = load i64, ptr %slot.a, align 8
  %r62 = load i64, ptr %slot.b, align 8
  %r63 = add i64 %r61, %r62
  store i64 %r63, ptr %slot.__catch_15, align 8
  br label %catch_merge18
catch_ok17:
  store i64 %r56, ptr %slot.__catch_15, align 8
  br label %catch_merge18
catch_merge18:
  %r64 = load i64, ptr %slot.__catch_15, align 8
  store i64 %r64, ptr %slot.r4, align 8
  %r65.p = getelementptr inbounds [11 x i8], ptr @.str.7, i64 0, i64 0
  %r65 = ptrtoint ptr %r65.p to i64
  %r66 = load i64, ptr %slot.r4, align 8
  %r67 = call i64 @nova_rt_any_to_str(i64 %r66)
  %r68 = call i64 @nova_rt_str_concat(i64 %r65, i64 %r67)
  %r69.p = getelementptr inbounds [1 x i8], ptr @.str.2, i64 0, i64 0
  %r69 = ptrtoint ptr %r69.p to i64
  %r70 = call i64 @nova_rt_str_concat(i64 %r68, i64 %r69)
  %r71 = call i64 @nova_rt_print_any(i64 %r70)
  %r72.p = getelementptr inbounds [5 x i8], ptr @.str.8, i64 0, i64 0
  %r72 = ptrtoint ptr %r72.p to i64
  %r73 = call i64 @nova_rt_print_any(i64 %r72)
  ret i64 %r73
}

define i64 @nova_main() nounwind {
entry:
  %r0 = call i64 @nova_user_main()
  %r1 = call i64 @nova_user_main()
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
@.str.0 = private unnamed_addr constant [17 x i8] c"division by zero\00"
@.str.1 = private unnamed_addr constant [14 x i8] c"single-line: \00"
@.str.2 = private unnamed_addr constant [1 x i8] c"\00"
@.str.3 = private unnamed_addr constant [15 x i8] c"caught error: \00"
@.str.4 = private unnamed_addr constant [13 x i8] c"multi-line: \00"
@.str.5 = private unnamed_addr constant [17 x i8] c"should not print\00"
@.str.6 = private unnamed_addr constant [11 x i8] c"no-error: \00"
@.str.7 = private unnamed_addr constant [11 x i8] c"computed: \00"
@.str.8 = private unnamed_addr constant [5 x i8] c"done\00"

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
