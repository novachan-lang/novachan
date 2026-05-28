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

define i64 @run() nounwind {
entry:
  %slot.a = alloca i64, align 8
  store i64 0, ptr %slot.a, align 8
  %slot.env = alloca i64, align 8
  store i64 0, ptr %slot.env, align 8
  %slot.path = alloca i64, align 8
  store i64 0, ptr %slot.path, align 8
  %slot.random = alloca i64, align 8
  store i64 0, ptr %slot.random, align 8
  %slot.r = alloca i64, align 8
  store i64 0, ptr %slot.r, align 8
  %slot.__sc_0 = alloca i64, align 8
  store i64 0, ptr %slot.__sc_0, align 8
  %slot.shell = alloca i64, align 8
  store i64 0, ptr %slot.shell, align 8
  %slot.out = alloca i64, align 8
  store i64 0, ptr %slot.out, align 8
  %r0 = call i64 @nova_rt_args()
  store i64 %r0, ptr %slot.a, align 8
  %r1.p = getelementptr inbounds [12 x i8], ptr @.str.0, i64 0, i64 0
  %r1 = ptrtoint ptr %r1.p to i64
  %r2 = load i64, ptr %slot.a, align 8
  %r3 = call i64 @nova_rt_len_any(i64 %r2)
  %r4 = call i64 @nova_rt_any_to_str(i64 %r3)
  %r5 = call i64 @nova_rt_str_concat(i64 %r1, i64 %r4)
  %r6.p = getelementptr inbounds [1 x i8], ptr @.str.1, i64 0, i64 0
  %r6 = ptrtoint ptr %r6.p to i64
  %r7 = call i64 @nova_rt_str_concat(i64 %r5, i64 %r6)
  %r8 = call i64 @nova_rt_print_any(i64 %r7)
  %r9.p = getelementptr inbounds [10 x i8], ptr @.str.2, i64 0, i64 0
  %r9 = ptrtoint ptr %r9.p to i64
  %r10 = load i64, ptr %slot.a, align 8
  %r11 = add i64 0, 0
  %r12 = call i64 @nova_rt_index_get(i64 %r10, i64 %r11)
  %r13 = call i64 @nova_rt_any_to_str(i64 %r12)
  %r14 = call i64 @nova_rt_str_concat(i64 %r9, i64 %r13)
  %r15.p = getelementptr inbounds [1 x i8], ptr @.str.1, i64 0, i64 0
  %r15 = ptrtoint ptr %r15.p to i64
  %r16 = call i64 @nova_rt_str_concat(i64 %r14, i64 %r15)
  %r17 = call i64 @nova_rt_print_any(i64 %r16)
  %r18.p = getelementptr inbounds [5 x i8], ptr @.str.3, i64 0, i64 0
  %r18 = ptrtoint ptr %r18.p to i64
  %r20 = load i64, ptr %slot.env, align 8
  %r19.rec = inttoptr i64 %r20 to ptr
  %r19.fnraw = load i64, ptr %r19.rec, align 8
  %r19.fnptr = inttoptr i64 %r19.fnraw to ptr
  %r19 = call i64 %r19.fnptr(i64 %r20, i64 %r18)
  store i64 %r19, ptr %slot.path, align 8
  %r21 = load i64, ptr %slot.path, align 8
  %r22 = call i64 @nova_rt_len_any(i64 %r21)
  %r23 = add i64 0, 0
  %r24.cmp = icmp sgt i64 %r22, %r23
  %r24 = zext i1 %r24.cmp to i64
  %r25.p = getelementptr inbounds [25 x i8], ptr @.str.4, i64 0, i64 0
  %r25 = ptrtoint ptr %r25.p to i64
  %r26 = call i64 @nova_rt_assert(i64 %r24, i64 %r25)
  %r27.p = getelementptr inbounds [14 x i8], ptr @.str.5, i64 0, i64 0
  %r27 = ptrtoint ptr %r27.p to i64
  %r28 = load i64, ptr %slot.path, align 8
  %r29 = call i64 @nova_rt_len_any(i64 %r28)
  %r30 = call i64 @nova_rt_any_to_str(i64 %r29)
  %r31 = call i64 @nova_rt_str_concat(i64 %r27, i64 %r30)
  %r32.p = getelementptr inbounds [1 x i8], ptr @.str.1, i64 0, i64 0
  %r32 = ptrtoint ptr %r32.p to i64
  %r33 = call i64 @nova_rt_str_concat(i64 %r31, i64 %r32)
  %r34 = call i64 @nova_rt_print_any(i64 %r33)
  %r35 = add i64 1, 0
  %r36 = add i64 100, 0
  %r38 = load i64, ptr %slot.random, align 8
  %r37.rec = inttoptr i64 %r38 to ptr
  %r37.fnraw = load i64, ptr %r37.rec, align 8
  %r37.fnptr = inttoptr i64 %r37.fnraw to ptr
  %r37 = call i64 %r37.fnptr(i64 %r38, i64 %r35, i64 %r36)
  store i64 %r37, ptr %slot.r, align 8
  %r39 = load i64, ptr %slot.r, align 8
  %r40 = add i64 1, 0
  %r41.cmp = icmp sge i64 %r39, %r40
  %r41 = zext i1 %r41.cmp to i64
  store i64 %r41, ptr %slot.__sc_0, align 8
  %br_and_rhs1 = icmp ne i64 %r41, 0
  br i1 %br_and_rhs1, label %and_rhs1, label %and_merge2
and_rhs1:
  %r42 = load i64, ptr %slot.r, align 8
  %r43 = add i64 100, 0
  %r44.cmp = icmp sle i64 %r42, %r43
  %r44 = zext i1 %r44.cmp to i64
  store i64 %r44, ptr %slot.__sc_0, align 8
  br label %and_merge2
and_merge2:
  %r45 = load i64, ptr %slot.__sc_0, align 8
  %r46.p = getelementptr inbounds [20 x i8], ptr @.str.6, i64 0, i64 0
  %r46 = ptrtoint ptr %r46.p to i64
  %r47 = call i64 @nova_rt_assert(i64 %r45, i64 %r46)
  %r48.p = getelementptr inbounds [17 x i8], ptr @.str.7, i64 0, i64 0
  %r48 = ptrtoint ptr %r48.p to i64
  %r49 = load i64, ptr %slot.r, align 8
  %r50 = call i64 @nova_rt_any_to_str(i64 %r49)
  %r51 = call i64 @nova_rt_str_concat(i64 %r48, i64 %r50)
  %r52.p = getelementptr inbounds [1 x i8], ptr @.str.1, i64 0, i64 0
  %r52 = ptrtoint ptr %r52.p to i64
  %r53 = call i64 @nova_rt_str_concat(i64 %r51, i64 %r52)
  %r54 = call i64 @nova_rt_print_any(i64 %r53)
  %r55.p = getelementptr inbounds [11 x i8], ptr @.str.8, i64 0, i64 0
  %r55 = ptrtoint ptr %r55.p to i64
  %r57 = load i64, ptr %slot.shell, align 8
  %r56.rec = inttoptr i64 %r57 to ptr
  %r56.fnraw = load i64, ptr %r56.rec, align 8
  %r56.fnptr = inttoptr i64 %r56.fnraw to ptr
  %r56 = call i64 %r56.fnptr(i64 %r57, i64 %r55)
  store i64 %r56, ptr %slot.out, align 8
  %r58 = load i64, ptr %slot.out, align 8
  %r59.p = getelementptr inbounds [6 x i8], ptr @.str.9, i64 0, i64 0
  %r59 = ptrtoint ptr %r59.p to i64
  %r60.p0 = inttoptr i64 %r58 to ptr
  %r60.p1 = inttoptr i64 %r59 to ptr
  %r60.sc = call i32 @strcmp(ptr %r60.p0, ptr %r60.p1)
  %r60.cmp = icmp eq i32 %r60.sc, 0
  %r60 = zext i1 %r60.cmp to i64
  %r61.p = getelementptr inbounds [20 x i8], ptr @.str.10, i64 0, i64 0
  %r61 = ptrtoint ptr %r61.p to i64
  %r62 = load i64, ptr %slot.out, align 8
  %r63 = call i64 @nova_rt_any_to_str(i64 %r62)
  %r64 = call i64 @nova_rt_str_concat(i64 %r61, i64 %r63)
  %r65.p = getelementptr inbounds [2 x i8], ptr @.str.11, i64 0, i64 0
  %r65 = ptrtoint ptr %r65.p to i64
  %r66 = call i64 @nova_rt_str_concat(i64 %r64, i64 %r65)
  %r67 = call i64 @nova_rt_assert(i64 %r60, i64 %r66)
  %r68.p = getelementptr inbounds [13 x i8], ptr @.str.12, i64 0, i64 0
  %r68 = ptrtoint ptr %r68.p to i64
  %r69 = load i64, ptr %slot.out, align 8
  %r70 = call i64 @nova_rt_any_to_str(i64 %r69)
  %r71 = call i64 @nova_rt_str_concat(i64 %r68, i64 %r70)
  %r72.p = getelementptr inbounds [1 x i8], ptr @.str.1, i64 0, i64 0
  %r72 = ptrtoint ptr %r72.p to i64
  %r73 = call i64 @nova_rt_str_concat(i64 %r71, i64 %r72)
  %r74 = call i64 @nova_rt_print_any(i64 %r73)
  %r75.p = getelementptr inbounds [19 x i8], ptr @.str.13, i64 0, i64 0
  %r75 = ptrtoint ptr %r75.p to i64
  %r76 = call i64 @nova_rt_print_any(i64 %r75)
  ret i64 %r76
}

define i64 @nova_main() nounwind {
entry:
  %r0 = call i64 @run()
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
@.str.0 = private unnamed_addr constant [12 x i8] c"arg count: \00"
@.str.1 = private unnamed_addr constant [1 x i8] c"\00"
@.str.2 = private unnamed_addr constant [10 x i8] c"program: \00"
@.str.3 = private unnamed_addr constant [5 x i8] c"PATH\00"
@.str.4 = private unnamed_addr constant [25 x i8] c"PATH should not be empty\00"
@.str.5 = private unnamed_addr constant [14 x i8] c"PATH length: \00"
@.str.6 = private unnamed_addr constant [20 x i8] c"random out of range\00"
@.str.7 = private unnamed_addr constant [17 x i8] c"random(1,100) = \00"
@.str.8 = private unnamed_addr constant [11 x i8] c"echo hello\00"
@.str.9 = private unnamed_addr constant [6 x i8] c"hello\00"
@.str.10 = private unnamed_addr constant [20 x i8] c"shell failed: got '\00"
@.str.11 = private unnamed_addr constant [2 x i8] c"'\00"
@.str.12 = private unnamed_addr constant [13 x i8] c"shell echo: \00"
@.str.13 = private unnamed_addr constant [19 x i8] c"SYSTEM: ALL PASSED\00"

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
