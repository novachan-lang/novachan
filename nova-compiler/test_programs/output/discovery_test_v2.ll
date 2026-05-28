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

define i64 @test_addition() nounwind {
entry:
  %r0 = add i64 1, 0
  %r1 = add i64 1, 0
  %r2 = add i64 %r0, %r1
  %r3 = add i64 2, 0
  %r4.cmp = icmp eq i64 %r2, %r3
  %r4 = zext i1 %r4.cmp to i64
  %r5.p = getelementptr inbounds [16 x i8], ptr @.str.0, i64 0, i64 0
  %r5 = ptrtoint ptr %r5.p to i64
  %r6 = call i64 @nova_rt_assert(i64 %r4, i64 %r5)
  %r7 = add i64 10, 0
  %r8 = add i64 20, 0
  %r9 = add i64 %r7, %r8
  %r10 = add i64 30, 0
  %r11.cmp = icmp eq i64 %r9, %r10
  %r11 = zext i1 %r11.cmp to i64
  %r12.p = getelementptr inbounds [19 x i8], ptr @.str.1, i64 0, i64 0
  %r12 = ptrtoint ptr %r12.p to i64
  %r13 = call i64 @nova_rt_assert(i64 %r11, i64 %r12)
  %r14.p = getelementptr inbounds [14 x i8], ptr @.str.2, i64 0, i64 0
  %r14 = ptrtoint ptr %r14.p to i64
  %r15 = call i64 @nova_rt_print_any(i64 %r14)
  ret i64 %r15
}

define i64 @test_strings() nounwind {
entry:
  %slot.s = alloca i64, align 8
  store i64 0, ptr %slot.s, align 8
  %slot.s2 = alloca i64, align 8
  store i64 0, ptr %slot.s2, align 8
  %r0.p = getelementptr inbounds [6 x i8], ptr @.str.3, i64 0, i64 0
  %r0 = ptrtoint ptr %r0.p to i64
  store i64 %r0, ptr %slot.s, align 8
  %r1 = load i64, ptr %slot.s, align 8
  %r2 = call i64 @nova_rt_len_any(i64 %r1)
  %r3 = add i64 5, 0
  %r4.cmp = icmp eq i64 %r2, %r3
  %r4 = zext i1 %r4.cmp to i64
  %r5.p = getelementptr inbounds [14 x i8], ptr @.str.4, i64 0, i64 0
  %r5 = ptrtoint ptr %r5.p to i64
  %r6 = call i64 @nova_rt_assert(i64 %r4, i64 %r5)
  %r7 = load i64, ptr %slot.s, align 8
  %r8 = call i64 @nova_rt_upper(i64 %r7)
  store i64 %r8, ptr %slot.s2, align 8
  %r9 = load i64, ptr %slot.s2, align 8
  %r10.p = getelementptr inbounds [6 x i8], ptr @.str.5, i64 0, i64 0
  %r10 = ptrtoint ptr %r10.p to i64
  %r11.p0 = inttoptr i64 %r9 to ptr
  %r11.p1 = inttoptr i64 %r10 to ptr
  %r11.sc = call i32 @strcmp(ptr %r11.p0, ptr %r11.p1)
  %r11.cmp = icmp eq i32 %r11.sc, 0
  %r11 = zext i1 %r11.cmp to i64
  %r12.p = getelementptr inbounds [18 x i8], ptr @.str.6, i64 0, i64 0
  %r12 = ptrtoint ptr %r12.p to i64
  %r13 = call i64 @nova_rt_assert(i64 %r11, i64 %r12)
  %r14.p = getelementptr inbounds [13 x i8], ptr @.str.7, i64 0, i64 0
  %r14 = ptrtoint ptr %r14.p to i64
  %r15 = call i64 @nova_rt_print_any(i64 %r14)
  ret i64 %r15
}

define i64 @test_list_ops() nounwind {
entry:
  %slot.lst = alloca i64, align 8
  store i64 0, ptr %slot.lst, align 8
  %slot.sum = alloca i64, align 8
  store i64 0, ptr %slot.sum, align 8
  %r1 = add i64 3, 0
  %r2 = add i64 1, 0
  %r3 = add i64 4, 0
  %r4 = add i64 1, 0
  %r5 = add i64 5, 0
  %r0 = call i64 @nova_rt_list_create()
  call i64 @nova_rt_list_append(i64 %r0, i64 %r1)
  call i64 @nova_rt_list_append(i64 %r0, i64 %r2)
  call i64 @nova_rt_list_append(i64 %r0, i64 %r3)
  call i64 @nova_rt_list_append(i64 %r0, i64 %r4)
  call i64 @nova_rt_list_append(i64 %r0, i64 %r5)
  store i64 %r0, ptr %slot.lst, align 8
  %r6 = load i64, ptr %slot.lst, align 8
  %r7 = call i64 @nova_rt_len_any(i64 %r6)
  %r8 = add i64 5, 0
  %r9.cmp = icmp eq i64 %r7, %r8
  %r9 = zext i1 %r9.cmp to i64
  %r10.p = getelementptr inbounds [12 x i8], ptr @.str.8, i64 0, i64 0
  %r10 = ptrtoint ptr %r10.p to i64
  %r11 = call i64 @nova_rt_assert(i64 %r9, i64 %r10)
  %r12 = load i64, ptr %slot.lst, align 8
  %r14 = load i64, ptr %slot.sum, align 8
  %r13.rec = inttoptr i64 %r14 to ptr
  %r13.fnraw = load i64, ptr %r13.rec, align 8
  %r13.fnptr = inttoptr i64 %r13.fnraw to ptr
  %r13 = call i64 %r13.fnptr(i64 %r14, i64 %r12)
  %r15 = add i64 14, 0
  %r16 = call i64 @nova_rt_eq(i64 %r13, i64 %r15)
  %r17.p = getelementptr inbounds [9 x i8], ptr @.str.9, i64 0, i64 0
  %r17 = ptrtoint ptr %r17.p to i64
  %r18 = call i64 @nova_rt_assert(i64 %r16, i64 %r17)
  %r19.p = getelementptr inbounds [14 x i8], ptr @.str.10, i64 0, i64 0
  %r19 = ptrtoint ptr %r19.p to i64
  %r20 = call i64 @nova_rt_print_any(i64 %r19)
  ret i64 %r20
}

define i64 @test_bool_logic() nounwind {
entry:
  %r0 = add i64 1, 0
  %r1 = add i64 1, 0
  %r2.cmp = icmp eq i64 %r0, %r1
  %r2 = zext i1 %r2.cmp to i64
  %r3.p = getelementptr inbounds [9 x i8], ptr @.str.11, i64 0, i64 0
  %r3 = ptrtoint ptr %r3.p to i64
  %r4 = call i64 @nova_rt_assert(i64 %r2, i64 %r3)
  %r5 = add i64 0, 0
  %r6 = add i64 1, 0
  %r7.cmp = icmp ne i64 %r5, %r6
  %r7 = zext i1 %r7.cmp to i64
  %r8.p = getelementptr inbounds [11 x i8], ptr @.str.12, i64 0, i64 0
  %r8 = ptrtoint ptr %r8.p to i64
  %r9 = call i64 @nova_rt_assert(i64 %r7, i64 %r8)
  %r10 = add i64 5, 0
  %r11 = add i64 3, 0
  %r12.cmp = icmp sgt i64 %r10, %r11
  %r12 = zext i1 %r12.cmp to i64
  %r13.p = getelementptr inbounds [8 x i8], ptr @.str.13, i64 0, i64 0
  %r13 = ptrtoint ptr %r13.p to i64
  %r14 = call i64 @nova_rt_assert(i64 %r12, i64 %r13)
  %r15 = add i64 2, 0
  %r16 = add i64 7, 0
  %r17.cmp = icmp slt i64 %r15, %r16
  %r17 = zext i1 %r17.cmp to i64
  %r18.p = getelementptr inbounds [5 x i8], ptr @.str.14, i64 0, i64 0
  %r18 = ptrtoint ptr %r18.p to i64
  %r19 = call i64 @nova_rt_assert(i64 %r17, i64 %r18)
  %r20.p = getelementptr inbounds [16 x i8], ptr @.str.15, i64 0, i64 0
  %r20 = ptrtoint ptr %r20.p to i64
  %r21 = call i64 @nova_rt_print_any(i64 %r20)
  ret i64 %r21
}

define i64 @nova_main() nounwind {
entry:
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
@.str.0 = private unnamed_addr constant [16 x i8] c"1+1 should be 2\00"
@.str.1 = private unnamed_addr constant [19 x i8] c"10+20 should be 30\00"
@.str.2 = private unnamed_addr constant [14 x i8] c"  addition ok\00"
@.str.3 = private unnamed_addr constant [6 x i8] c"hello\00"
@.str.4 = private unnamed_addr constant [14 x i8] c"len hello = 5\00"
@.str.5 = private unnamed_addr constant [6 x i8] c"HELLO\00"
@.str.6 = private unnamed_addr constant [18 x i8] c"upper should work\00"
@.str.7 = private unnamed_addr constant [13 x i8] c"  strings ok\00"
@.str.8 = private unnamed_addr constant [12 x i8] c"list length\00"
@.str.9 = private unnamed_addr constant [9 x i8] c"list sum\00"
@.str.10 = private unnamed_addr constant [14 x i8] c"  list ops ok\00"
@.str.11 = private unnamed_addr constant [9 x i8] c"identity\00"
@.str.12 = private unnamed_addr constant [11 x i8] c"inequality\00"
@.str.13 = private unnamed_addr constant [8 x i8] c"greater\00"
@.str.14 = private unnamed_addr constant [5 x i8] c"less\00"
@.str.15 = private unnamed_addr constant [16 x i8] c"  bool logic ok\00"

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
