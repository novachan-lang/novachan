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

define i64 @make_token(i64 %p0, i64 %p1) nounwind {
entry:
  %slot.k = alloca i64, align 8
  store i64 %p0, ptr %slot.k, align 8
  %slot.v = alloca i64, align 8
  store i64 %p1, ptr %slot.v, align 8
  %r0 = load i64, ptr %slot.k, align 8
  %r1 = load i64, ptr %slot.v, align 8
  %r2.ptr = call ptr @nova_rt_struct_alloc(i64 24)
  %r2.thash = getelementptr i64, ptr %r2.ptr, i64 0
  store i64 210691276070, ptr %r2.thash, align 8
  %r2.f0 = getelementptr i64, ptr %r2.ptr, i64 1
  store i64 %r0, ptr %r2.f0, align 8
  %r2.f1 = getelementptr i64, ptr %r2.ptr, i64 2
  store i64 %r1, ptr %r2.f1, align 8
  %r2 = ptrtoint ptr %r2.ptr to i64
  ret i64 %r2
}

define i64 @is_keyword(i64 %p0) nounwind {
entry:
  %slot.t = alloca i64, align 8
  store i64 %p0, ptr %slot.t, align 8
  %slot.kind = alloca i64, align 8
  store i64 0, ptr %slot.kind, align 8
  %slot.value = alloca i64, align 8
  store i64 0, ptr %slot.value, align 8
  %r0 = load i64, ptr %slot.t, align 8
  %r1.ptr = inttoptr i64 %r0 to ptr
  %r1.gep = getelementptr i64, ptr %r1.ptr, i64 0
  %r1 = load i64, ptr %r1.gep, align 8
  %r2 = add i64 210691276070, 0
  %r3.cmp = icmp eq i64 %r1, %r2
  %r3 = zext i1 %r3.cmp to i64
  %br_marm_01 = icmp ne i64 %r3, 0
  br i1 %br_marm_01, label %marm_01, label %match_fall2
marm_01:
  %r4.ptr = inttoptr i64 %r0 to ptr
  %r4.gep = getelementptr i64, ptr %r4.ptr, i64 1
  %r4 = load i64, ptr %r4.gep, align 8
  store i64 %r4, ptr %slot.kind, align 8
  %r5.ptr = inttoptr i64 %r0 to ptr
  %r5.gep = getelementptr i64, ptr %r5.ptr, i64 2
  %r5 = load i64, ptr %r5.gep, align 8
  store i64 %r5, ptr %slot.value, align 8
  %r6 = load i64, ptr %slot.kind, align 8
  %r7.p = getelementptr inbounds [3 x i8], ptr @.str.0, i64 0, i64 0
  %r7 = ptrtoint ptr %r7.p to i64
  %r8.p0 = inttoptr i64 %r6 to ptr
  %r8.p1 = inttoptr i64 %r7 to ptr
  %r8.sc = call i32 @strcmp(ptr %r8.p0, ptr %r8.p1)
  %r8.cmp = icmp eq i32 %r8.sc, 0
  %r8 = zext i1 %r8.cmp to i64
  %br_then3 = icmp ne i64 %r8, 0
  br i1 %br_then3, label %then3, label %else4
then3:
  %r9 = add i64 1, 0
  ret i64 %r9
else4:
  br label %endif5
endif5:
  br label %match_exit0
match_fall2:
  br label %match_exit0
match_exit0:
  %r10 = add i64 0, 0
  ret i64 %r10
}

define i64 @token_str(i64 %p0) nounwind {
entry:
  %slot.t = alloca i64, align 8
  store i64 %p0, ptr %slot.t, align 8
  %slot.kind = alloca i64, align 8
  store i64 0, ptr %slot.kind, align 8
  %slot.value = alloca i64, align 8
  store i64 0, ptr %slot.value, align 8
  %r0 = load i64, ptr %slot.t, align 8
  %r1.ptr = inttoptr i64 %r0 to ptr
  %r1.gep = getelementptr i64, ptr %r1.ptr, i64 0
  %r1 = load i64, ptr %r1.gep, align 8
  %r2 = add i64 210691276070, 0
  %r3.cmp = icmp eq i64 %r1, %r2
  %r3 = zext i1 %r3.cmp to i64
  %br_marm_07 = icmp ne i64 %r3, 0
  br i1 %br_marm_07, label %marm_07, label %match_fall8
marm_07:
  %r4.ptr = inttoptr i64 %r0 to ptr
  %r4.gep = getelementptr i64, ptr %r4.ptr, i64 1
  %r4 = load i64, ptr %r4.gep, align 8
  store i64 %r4, ptr %slot.kind, align 8
  %r5.ptr = inttoptr i64 %r0 to ptr
  %r5.gep = getelementptr i64, ptr %r5.ptr, i64 2
  %r5 = load i64, ptr %r5.gep, align 8
  store i64 %r5, ptr %slot.value, align 8
  %r6 = load i64, ptr %slot.kind, align 8
  %r7.p = getelementptr inbounds [2 x i8], ptr @.str.1, i64 0, i64 0
  %r7 = ptrtoint ptr %r7.p to i64
  %r8 = call i64 @nova_rt_str_concat(i64 %r6, i64 %r7)
  %r9 = load i64, ptr %slot.value, align 8
  %r10 = call i64 @nova_rt_str_concat(i64 %r8, i64 %r9)
  ret i64 %r10
match_fall8:
  br label %match_exit6
match_exit6:
  %r11.p = getelementptr inbounds [1 x i8], ptr @.str.2, i64 0, i64 0
  %r11 = ptrtoint ptr %r11.p to i64
  ret i64 %r11
}

define i64 @nova_main() nounwind {
entry:
  %slot.t1 = alloca i64, align 8
  store i64 0, ptr %slot.t1, align 8
  %slot.t2 = alloca i64, align 8
  store i64 0, ptr %slot.t2, align 8
  %slot.t3 = alloca i64, align 8
  store i64 0, ptr %slot.t3, align 8
  %r0.p = getelementptr inbounds [3 x i8], ptr @.str.0, i64 0, i64 0
  %r0 = ptrtoint ptr %r0.p to i64
  %r1.p = getelementptr inbounds [3 x i8], ptr @.str.3, i64 0, i64 0
  %r1 = ptrtoint ptr %r1.p to i64
  %r2 = call i64 @make_token(i64 %r0, i64 %r1)
  store i64 %r2, ptr %slot.t1, align 8
  %r3.p = getelementptr inbounds [6 x i8], ptr @.str.4, i64 0, i64 0
  %r3 = ptrtoint ptr %r3.p to i64
  %r4.p = getelementptr inbounds [6 x i8], ptr @.str.5, i64 0, i64 0
  %r4 = ptrtoint ptr %r4.p to i64
  %r5 = call i64 @make_token(i64 %r3, i64 %r4)
  store i64 %r5, ptr %slot.t2, align 8
  %r6.p = getelementptr inbounds [4 x i8], ptr @.str.6, i64 0, i64 0
  %r6 = ptrtoint ptr %r6.p to i64
  %r7.p = getelementptr inbounds [3 x i8], ptr @.str.7, i64 0, i64 0
  %r7 = ptrtoint ptr %r7.p to i64
  %r8 = call i64 @make_token(i64 %r6, i64 %r7)
  store i64 %r8, ptr %slot.t3, align 8
  %r9 = load i64, ptr %slot.t1, align 8
  %r10 = call i64 @is_keyword(i64 %r9)
  %r11 = call i64 @nova_rt_print_any(i64 %r10)
  %r12 = load i64, ptr %slot.t2, align 8
  %r13 = call i64 @is_keyword(i64 %r12)
  %r14 = call i64 @nova_rt_print_any(i64 %r13)
  %r15 = load i64, ptr %slot.t1, align 8
  %r16 = call i64 @token_str(i64 %r15)
  %r17 = call i64 @nova_rt_print_any(i64 %r16)
  %r18 = load i64, ptr %slot.t2, align 8
  %r19 = call i64 @token_str(i64 %r18)
  %r20 = call i64 @nova_rt_print_any(i64 %r19)
  %r21 = load i64, ptr %slot.t3, align 8
  %r22 = call i64 @token_str(i64 %r21)
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
@.str.0 = private unnamed_addr constant [3 x i8] c"KW\00"
@.str.1 = private unnamed_addr constant [2 x i8] c":\00"
@.str.2 = private unnamed_addr constant [1 x i8] c"\00"
@.str.3 = private unnamed_addr constant [3 x i8] c"fn\00"
@.str.4 = private unnamed_addr constant [6 x i8] c"IDENT\00"
@.str.5 = private unnamed_addr constant [6 x i8] c"hello\00"
@.str.6 = private unnamed_addr constant [4 x i8] c"NUM\00"
@.str.7 = private unnamed_addr constant [3 x i8] c"42\00"

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
