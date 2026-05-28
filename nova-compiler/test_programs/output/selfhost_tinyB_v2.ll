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

define i64 @make_tok(i64 %p0, i64 %p1, i64 %p2, i64 %p3) nounwind {
entry:
  %slot.kind = alloca i64, align 8
  store i64 %p0, ptr %slot.kind, align 8
  %slot.val = alloca i64, align 8
  store i64 %p1, ptr %slot.val, align 8
  %slot.line = alloca i64, align 8
  store i64 %p2, ptr %slot.line, align 8
  %slot.col = alloca i64, align 8
  store i64 %p3, ptr %slot.col, align 8
  %r0 = load i64, ptr %slot.kind, align 8
  %r1 = load i64, ptr %slot.val, align 8
  %r2 = load i64, ptr %slot.line, align 8
  %r3 = load i64, ptr %slot.col, align 8
  %r4.ptr = call ptr @nova_rt_struct_alloc(i64 40)
  %r4.thash = getelementptr i64, ptr %r4.ptr, i64 0
  store i64 193472243, ptr %r4.thash, align 8
  %r4.f0 = getelementptr i64, ptr %r4.ptr, i64 1
  store i64 %r0, ptr %r4.f0, align 8
  %r4.f1 = getelementptr i64, ptr %r4.ptr, i64 2
  store i64 %r1, ptr %r4.f1, align 8
  %r4.f2 = getelementptr i64, ptr %r4.ptr, i64 3
  store i64 %r2, ptr %r4.f2, align 8
  %r4.f3 = getelementptr i64, ptr %r4.ptr, i64 4
  store i64 %r3, ptr %r4.f3, align 8
  %r4 = ptrtoint ptr %r4.ptr to i64
  ret i64 %r4
}

define i64 @nova_main() nounwind {
entry:
  %slot.t1 = alloca i64, align 8
  store i64 0, ptr %slot.t1, align 8
  %slot.k = alloca i64, align 8
  store i64 0, ptr %slot.k, align 8
  %slot.v = alloca i64, align 8
  store i64 0, ptr %slot.v, align 8
  %slot.ln = alloca i64, align 8
  store i64 0, ptr %slot.ln, align 8
  %slot.co = alloca i64, align 8
  store i64 0, ptr %slot.co, align 8
  %r0.p = getelementptr inbounds [3 x i8], ptr @.str.0, i64 0, i64 0
  %r0 = ptrtoint ptr %r0.p to i64
  %r1.p = getelementptr inbounds [4 x i8], ptr @.str.1, i64 0, i64 0
  %r1 = ptrtoint ptr %r1.p to i64
  %r2 = add i64 3, 0
  %r3 = add i64 1, 0
  %r4 = call i64 @make_tok(i64 %r0, i64 %r1, i64 %r2, i64 %r3)
  store i64 %r4, ptr %slot.t1, align 8
  %r5 = load i64, ptr %slot.t1, align 8
  %r6.ptr = inttoptr i64 %r5 to ptr
  %r6.gep = getelementptr i64, ptr %r6.ptr, i64 0
  %r6 = load i64, ptr %r6.gep, align 8
  %r7 = add i64 193472243, 0
  %r8.cmp = icmp eq i64 %r6, %r7
  %r8 = zext i1 %r8.cmp to i64
  %br_marm_01 = icmp ne i64 %r8, 0
  br i1 %br_marm_01, label %marm_01, label %match_fall2
marm_01:
  %r9.ptr = inttoptr i64 %r5 to ptr
  %r9.gep = getelementptr i64, ptr %r9.ptr, i64 1
  %r9 = load i64, ptr %r9.gep, align 8
  store i64 %r9, ptr %slot.k, align 8
  %r10.ptr = inttoptr i64 %r5 to ptr
  %r10.gep = getelementptr i64, ptr %r10.ptr, i64 2
  %r10 = load i64, ptr %r10.gep, align 8
  store i64 %r10, ptr %slot.v, align 8
  %r11.ptr = inttoptr i64 %r5 to ptr
  %r11.gep = getelementptr i64, ptr %r11.ptr, i64 3
  %r11 = load i64, ptr %r11.gep, align 8
  store i64 %r11, ptr %slot.ln, align 8
  %r12.ptr = inttoptr i64 %r5 to ptr
  %r12.gep = getelementptr i64, ptr %r12.ptr, i64 4
  %r12 = load i64, ptr %r12.gep, align 8
  store i64 %r12, ptr %slot.co, align 8
  %r13 = load i64, ptr %slot.k, align 8
  %r14 = call i64 @nova_rt_print_any(i64 %r13)
  %r15 = load i64, ptr %slot.v, align 8
  %r16 = call i64 @nova_rt_print_any(i64 %r15)
  %r17 = load i64, ptr %slot.co, align 8
  %r18 = call i64 @nova_rt_print_any(i64 %r17)
  %r19 = load i64, ptr %slot.co, align 8
  %r20 = add i64 1, 0
  %r21.cmp = icmp sle i64 %r19, %r20
  %r21 = zext i1 %r21.cmp to i64
  %br_then3 = icmp ne i64 %r21, 0
  br i1 %br_then3, label %then3, label %else4
then3:
  %r22.p = getelementptr inbounds [12 x i8], ptr @.str.2, i64 0, i64 0
  %r22 = ptrtoint ptr %r22.p to i64
  %r23 = call i64 @nova_rt_print_any(i64 %r22)
  br label %endif5
else4:
  %r24.p = getelementptr inbounds [13 x i8], ptr @.str.3, i64 0, i64 0
  %r24 = ptrtoint ptr %r24.p to i64
  %r25 = call i64 @nova_rt_print_any(i64 %r24)
  br label %endif5
endif5:
  br label %match_exit0
match_fall2:
  br label %match_exit0
match_exit0:
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
@.str.0 = private unnamed_addr constant [3 x i8] c"KW\00"
@.str.1 = private unnamed_addr constant [4 x i8] c"let\00"
@.str.2 = private unnamed_addr constant [12 x i8] c"col<=1 TRUE\00"
@.str.3 = private unnamed_addr constant [13 x i8] c"col<=1 FALSE\00"

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
