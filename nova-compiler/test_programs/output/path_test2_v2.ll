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
  %slot.p = alloca i64, align 8
  store i64 0, ptr %slot.p, align 8
  %slot.parent = alloca i64, align 8
  store i64 0, ptr %slot.parent, align 8
  %slot.name = alloca i64, align 8
  store i64 0, ptr %slot.name, align 8
  %slot.path_ext = alloca i64, align 8
  store i64 0, ptr %slot.path_ext, align 8
  %slot.ext = alloca i64, align 8
  store i64 0, ptr %slot.ext, align 8
  %r0.p = getelementptr inbounds [4 x i8], ptr @.str.0, i64 0, i64 0
  %r0 = ptrtoint ptr %r0.p to i64
  %r1.p = getelementptr inbounds [10 x i8], ptr @.str.1, i64 0, i64 0
  %r1 = ptrtoint ptr %r1.p to i64
  %r2 = call i64 @nova_rt_path_join(i64 %r0, i64 %r1)
  store i64 %r2, ptr %slot.p, align 8
  %r3.p = getelementptr inbounds [7 x i8], ptr @.str.2, i64 0, i64 0
  %r3 = ptrtoint ptr %r3.p to i64
  %r4 = load i64, ptr %slot.p, align 8
  %r5 = call i64 @nova_rt_any_to_str(i64 %r4)
  %r6 = call i64 @nova_rt_str_concat(i64 %r3, i64 %r5)
  %r7.p = getelementptr inbounds [1 x i8], ptr @.str.3, i64 0, i64 0
  %r7 = ptrtoint ptr %r7.p to i64
  %r8 = call i64 @nova_rt_str_concat(i64 %r6, i64 %r7)
  %r9 = call i64 @nova_rt_print_any(i64 %r8)
  %r10.p = getelementptr inbounds [23 x i8], ptr @.str.4, i64 0, i64 0
  %r10 = ptrtoint ptr %r10.p to i64
  %r11 = call i64 @nova_rt_path_parent(i64 %r10)
  store i64 %r11, ptr %slot.parent, align 8
  %r12.p = getelementptr inbounds [9 x i8], ptr @.str.5, i64 0, i64 0
  %r12 = ptrtoint ptr %r12.p to i64
  %r13 = load i64, ptr %slot.parent, align 8
  %r14 = call i64 @nova_rt_any_to_str(i64 %r13)
  %r15 = call i64 @nova_rt_str_concat(i64 %r12, i64 %r14)
  %r16.p = getelementptr inbounds [1 x i8], ptr @.str.3, i64 0, i64 0
  %r16 = ptrtoint ptr %r16.p to i64
  %r17 = call i64 @nova_rt_str_concat(i64 %r15, i64 %r16)
  %r18 = call i64 @nova_rt_print_any(i64 %r17)
  %r19.p = getelementptr inbounds [19 x i8], ptr @.str.6, i64 0, i64 0
  %r19 = ptrtoint ptr %r19.p to i64
  %r20 = call i64 @nova_rt_path_name(i64 %r19)
  store i64 %r20, ptr %slot.name, align 8
  %r21.p = getelementptr inbounds [7 x i8], ptr @.str.7, i64 0, i64 0
  %r21 = ptrtoint ptr %r21.p to i64
  %r22 = load i64, ptr %slot.name, align 8
  %r23 = call i64 @nova_rt_any_to_str(i64 %r22)
  %r24 = call i64 @nova_rt_str_concat(i64 %r21, i64 %r23)
  %r25.p = getelementptr inbounds [1 x i8], ptr @.str.3, i64 0, i64 0
  %r25 = ptrtoint ptr %r25.p to i64
  %r26 = call i64 @nova_rt_str_concat(i64 %r24, i64 %r25)
  %r27 = call i64 @nova_rt_print_any(i64 %r26)
  %r28.p = getelementptr inbounds [15 x i8], ptr @.str.8, i64 0, i64 0
  %r28 = ptrtoint ptr %r28.p to i64
  %r30 = load i64, ptr %slot.path_ext, align 8
  %r29.rec = inttoptr i64 %r30 to ptr
  %r29.fnraw = load i64, ptr %r29.rec, align 8
  %r29.fnptr = inttoptr i64 %r29.fnraw to ptr
  %r29 = call i64 %r29.fnptr(i64 %r30, i64 %r28)
  store i64 %r29, ptr %slot.ext, align 8
  %r31.p = getelementptr inbounds [6 x i8], ptr @.str.9, i64 0, i64 0
  %r31 = ptrtoint ptr %r31.p to i64
  %r32 = load i64, ptr %slot.ext, align 8
  %r33 = call i64 @nova_rt_any_to_str(i64 %r32)
  %r34 = call i64 @nova_rt_str_concat(i64 %r31, i64 %r33)
  %r35.p = getelementptr inbounds [1 x i8], ptr @.str.3, i64 0, i64 0
  %r35 = ptrtoint ptr %r35.p to i64
  %r36 = call i64 @nova_rt_str_concat(i64 %r34, i64 %r35)
  %r37 = call i64 @nova_rt_print_any(i64 %r36)
  %r38.p = getelementptr inbounds [17 x i8], ptr @.str.10, i64 0, i64 0
  %r38 = ptrtoint ptr %r38.p to i64
  %r39 = call i64 @nova_rt_print_any(i64 %r38)
  ret i64 %r39
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
@.str.0 = private unnamed_addr constant [4 x i8] c"src\00"
@.str.1 = private unnamed_addr constant [10 x i8] c"main.nova\00"
@.str.2 = private unnamed_addr constant [7 x i8] c"join: \00"
@.str.3 = private unnamed_addr constant [1 x i8] c"\00"
@.str.4 = private unnamed_addr constant [23 x i8] c"C:/Users/test/file.txt\00"
@.str.5 = private unnamed_addr constant [9 x i8] c"parent: \00"
@.str.6 = private unnamed_addr constant [19 x i8] c"/home/user/doc.pdf\00"
@.str.7 = private unnamed_addr constant [7 x i8] c"name: \00"
@.str.8 = private unnamed_addr constant [15 x i8] c"archive.tar.gz\00"
@.str.9 = private unnamed_addr constant [6 x i8] c"ext: \00"
@.str.10 = private unnamed_addr constant [17 x i8] c"PATH: ALL PASSED\00"

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
