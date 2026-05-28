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

define i64 @make_leaf(i64 %p0, i64 %p1) nounwind {
entry:
  %slot.kind = alloca i64, align 8
  store i64 %p0, ptr %slot.kind, align 8
  %slot.value = alloca i64, align 8
  store i64 %p1, ptr %slot.value, align 8
  %r0 = load i64, ptr %slot.kind, align 8
  %r1 = load i64, ptr %slot.value, align 8
  %r2 = call i64 @nova_rt_list_create()
  %r3.ptr = call ptr @nova_rt_struct_alloc(i64 32)
  %r3.thash = getelementptr i64, ptr %r3.ptr, i64 0
  store i64 6384368267, ptr %r3.thash, align 8
  %r3.f0 = getelementptr i64, ptr %r3.ptr, i64 1
  store i64 %r0, ptr %r3.f0, align 8
  %r3.f1 = getelementptr i64, ptr %r3.ptr, i64 2
  store i64 %r1, ptr %r3.f1, align 8
  %r3.f2 = getelementptr i64, ptr %r3.ptr, i64 3
  store i64 %r2, ptr %r3.f2, align 8
  %r3 = ptrtoint ptr %r3.ptr to i64
  ret i64 %r3
}

define i64 @make_node(i64 %p0, i64 %p1) nounwind {
entry:
  %slot.kind = alloca i64, align 8
  store i64 %p0, ptr %slot.kind, align 8
  %slot.children = alloca i64, align 8
  store i64 %p1, ptr %slot.children, align 8
  %r0 = load i64, ptr %slot.kind, align 8
  %r1.p = getelementptr inbounds [1 x i8], ptr @.str.0, i64 0, i64 0
  %r1 = ptrtoint ptr %r1.p to i64
  %r2 = load i64, ptr %slot.children, align 8
  %r3.ptr = call ptr @nova_rt_struct_alloc(i64 32)
  %r3.thash = getelementptr i64, ptr %r3.ptr, i64 0
  store i64 6384368267, ptr %r3.thash, align 8
  %r3.f0 = getelementptr i64, ptr %r3.ptr, i64 1
  store i64 %r0, ptr %r3.f0, align 8
  %r3.f1 = getelementptr i64, ptr %r3.ptr, i64 2
  store i64 %r1, ptr %r3.f1, align 8
  %r3.f2 = getelementptr i64, ptr %r3.ptr, i64 3
  store i64 %r2, ptr %r3.f2, align 8
  %r3 = ptrtoint ptr %r3.ptr to i64
  ret i64 %r3
}

define i64 @node_to_str(i64 %p0) nounwind {
entry:
  %slot.n = alloca i64, align 8
  store i64 %p0, ptr %slot.n, align 8
  %slot.k = alloca i64, align 8
  store i64 0, ptr %slot.k, align 8
  %slot.v = alloca i64, align 8
  store i64 0, ptr %slot.v, align 8
  %slot.ch = alloca i64, align 8
  store i64 0, ptr %slot.ch, align 8
  %slot.parts = alloca i64, align 8
  store i64 0, ptr %slot.parts, align 8
  %slot.i = alloca i64, align 8
  store i64 0, ptr %slot.i, align 8
  %r0 = load i64, ptr %slot.n, align 8
  %r1.ptr = inttoptr i64 %r0 to ptr
  %r1.gep = getelementptr i64, ptr %r1.ptr, i64 0
  %r1 = load i64, ptr %r1.gep, align 8
  %r2 = add i64 6384368267, 0
  %r3.cmp = icmp eq i64 %r1, %r2
  %r3 = zext i1 %r3.cmp to i64
  %br_marm_01 = icmp ne i64 %r3, 0
  br i1 %br_marm_01, label %marm_01, label %match_fall2
marm_01:
  %r4.ptr = inttoptr i64 %r0 to ptr
  %r4.gep = getelementptr i64, ptr %r4.ptr, i64 1
  %r4 = load i64, ptr %r4.gep, align 8
  store i64 %r4, ptr %slot.k, align 8
  %r5.ptr = inttoptr i64 %r0 to ptr
  %r5.gep = getelementptr i64, ptr %r5.ptr, i64 2
  %r5 = load i64, ptr %r5.gep, align 8
  store i64 %r5, ptr %slot.v, align 8
  %r6.ptr = inttoptr i64 %r0 to ptr
  %r6.gep = getelementptr i64, ptr %r6.ptr, i64 3
  %r6 = load i64, ptr %r6.gep, align 8
  store i64 %r6, ptr %slot.ch, align 8
  %r7 = load i64, ptr %slot.ch, align 8
  %r8 = call i64 @nova_rt_len_any(i64 %r7)
  %r9 = add i64 0, 0
  %r10.cmp = icmp eq i64 %r8, %r9
  %r10 = zext i1 %r10.cmp to i64
  %br_then3 = icmp ne i64 %r10, 0
  br i1 %br_then3, label %then3, label %else4
then3:
  %r11 = load i64, ptr %slot.k, align 8
  %r12.p = getelementptr inbounds [2 x i8], ptr @.str.1, i64 0, i64 0
  %r12 = ptrtoint ptr %r12.p to i64
  %r13 = call i64 @nova_rt_str_concat(i64 %r11, i64 %r12)
  %r14 = load i64, ptr %slot.v, align 8
  %r15 = call i64 @nova_rt_str_concat(i64 %r13, i64 %r14)
  %r16.p = getelementptr inbounds [2 x i8], ptr @.str.2, i64 0, i64 0
  %r16 = ptrtoint ptr %r16.p to i64
  %r17 = call i64 @nova_rt_str_concat(i64 %r15, i64 %r16)
  ret i64 %r17
else4:
  br label %endif5
endif5:
  %r18 = load i64, ptr %slot.k, align 8
  %r19.p = getelementptr inbounds [2 x i8], ptr @.str.3, i64 0, i64 0
  %r19 = ptrtoint ptr %r19.p to i64
  %r20 = call i64 @nova_rt_str_concat(i64 %r18, i64 %r19)
  store i64 %r20, ptr %slot.parts, align 8
  %r21 = add i64 0, 0
  store i64 %r21, ptr %slot.i, align 8
  br label %while_hdr6, !llvm.loop !91
while_hdr6:
  %r22 = load i64, ptr %slot.i, align 8
  %r23 = load i64, ptr %slot.ch, align 8
  %r24 = call i64 @nova_rt_len_any(i64 %r23)
  %r25.cmp = icmp slt i64 %r22, %r24
  %r25 = zext i1 %r25.cmp to i64
  %br_while_body7 = icmp ne i64 %r25, 0
  br i1 %br_while_body7, label %while_body7, label %while_exit8, !prof !90
while_body7:
  %r26 = load i64, ptr %slot.i, align 8
  %r27 = add i64 0, 0
  %r28.cmp = icmp sgt i64 %r26, %r27
  %r28 = zext i1 %r28.cmp to i64
  %br_then9 = icmp ne i64 %r28, 0
  br i1 %br_then9, label %then9, label %else10
then9:
  %r29 = load i64, ptr %slot.parts, align 8
  %r30.p = getelementptr inbounds [3 x i8], ptr @.str.4, i64 0, i64 0
  %r30 = ptrtoint ptr %r30.p to i64
  %r31 = call i64 @nova_rt_str_concat(i64 %r29, i64 %r30)
  store i64 %r31, ptr %slot.parts, align 8
  br label %endif11
else10:
  br label %endif11
endif11:
  %r32 = load i64, ptr %slot.parts, align 8
  %r33 = load i64, ptr %slot.ch, align 8
  %r34 = load i64, ptr %slot.i, align 8
  %r35 = call i64 @nova_rt_index_get(i64 %r33, i64 %r34)
  %r36 = call i64 @node_to_str(i64 %r35)
  %r37 = call i64 @nova_rt_str_concat(i64 %r32, i64 %r36)
  store i64 %r37, ptr %slot.parts, align 8
  %r38 = load i64, ptr %slot.i, align 8
  %r39 = add i64 1, 0
  %r40 = add i64 %r38, %r39
  store i64 %r40, ptr %slot.i, align 8
  br label %while_hdr6, !llvm.loop !91
while_exit8:
  %r41 = load i64, ptr %slot.parts, align 8
  %r42.p = getelementptr inbounds [2 x i8], ptr @.str.5, i64 0, i64 0
  %r42 = ptrtoint ptr %r42.p to i64
  %r43 = call i64 @nova_rt_str_concat(i64 %r41, i64 %r42)
  ret i64 %r43
match_fall2:
  br label %match_exit0
match_exit0:
  %r44.p = getelementptr inbounds [2 x i8], ptr @.str.6, i64 0, i64 0
  %r44 = ptrtoint ptr %r44.p to i64
  ret i64 %r44
}

define i64 @lookup(i64 %p0, i64 %p1) nounwind {
entry:
  %slot.table = alloca i64, align 8
  store i64 %p0, ptr %slot.table, align 8
  %slot.name = alloca i64, align 8
  store i64 %p1, ptr %slot.name, align 8
  %r0 = load i64, ptr %slot.table, align 8
  %r1 = load i64, ptr %slot.name, align 8
  %r2 = call i64 @nova_rt_contains(i64 %r0, i64 %r1)
  %br_then12 = icmp ne i64 %r2, 0
  br i1 %br_then12, label %then12, label %else13
then12:
  %r3 = load i64, ptr %slot.table, align 8
  %r4 = load i64, ptr %slot.name, align 8
  %r5 = call i64 @nova_rt_index_get(i64 %r3, i64 %r4)
  ret i64 %r5
else13:
  br label %endif14
endif14:
  %r6.p = getelementptr inbounds [8 x i8], ptr @.str.7, i64 0, i64 0
  %r6 = ptrtoint ptr %r6.p to i64
  ret i64 %r6
}

define i64 @nova_main() nounwind {
entry:
  %slot.tree = alloca i64, align 8
  store i64 0, ptr %slot.tree, align 8
  %slot.syms = alloca i64, align 8
  store i64 0, ptr %slot.syms, align 8
  %r0.p = getelementptr inbounds [4 x i8], ptr @.str.8, i64 0, i64 0
  %r0 = ptrtoint ptr %r0.p to i64
  %r2.p = getelementptr inbounds [4 x i8], ptr @.str.9, i64 0, i64 0
  %r2 = ptrtoint ptr %r2.p to i64
  %r3.p = getelementptr inbounds [2 x i8], ptr @.str.10, i64 0, i64 0
  %r3 = ptrtoint ptr %r3.p to i64
  %r4 = call i64 @make_leaf(i64 %r2, i64 %r3)
  %r5.p = getelementptr inbounds [4 x i8], ptr @.str.9, i64 0, i64 0
  %r5 = ptrtoint ptr %r5.p to i64
  %r6.p = getelementptr inbounds [2 x i8], ptr @.str.11, i64 0, i64 0
  %r6 = ptrtoint ptr %r6.p to i64
  %r7 = call i64 @make_leaf(i64 %r5, i64 %r6)
  %r1 = call i64 @nova_rt_list_create()
  call i64 @nova_rt_list_append(i64 %r1, i64 %r4)
  call i64 @nova_rt_list_append(i64 %r1, i64 %r7)
  %r8 = call i64 @make_node(i64 %r0, i64 %r1)
  store i64 %r8, ptr %slot.tree, align 8
  %r9 = load i64, ptr %slot.tree, align 8
  %r10 = call i64 @node_to_str(i64 %r9)
  %r11 = call i64 @nova_rt_print_any(i64 %r10)
  %r12 = call i64 @nova_rt_dict_create()
  store i64 %r12, ptr %slot.syms, align 8
  %r13.p = getelementptr inbounds [4 x i8], ptr @.str.9, i64 0, i64 0
  %r13 = ptrtoint ptr %r13.p to i64
  %r14 = load i64, ptr %slot.syms, align 8
  %r15.p = getelementptr inbounds [2 x i8], ptr @.str.12, i64 0, i64 0
  %r15 = ptrtoint ptr %r15.p to i64
  call i64 @nova_rt_index_set(i64 %r14, i64 %r15, i64 %r13)
  %r16.p = getelementptr inbounds [7 x i8], ptr @.str.13, i64 0, i64 0
  %r16 = ptrtoint ptr %r16.p to i64
  %r17 = load i64, ptr %slot.syms, align 8
  %r18.p = getelementptr inbounds [2 x i8], ptr @.str.14, i64 0, i64 0
  %r18 = ptrtoint ptr %r18.p to i64
  call i64 @nova_rt_index_set(i64 %r17, i64 %r18, i64 %r16)
  %r19.p = getelementptr inbounds [5 x i8], ptr @.str.15, i64 0, i64 0
  %r19 = ptrtoint ptr %r19.p to i64
  %r20 = load i64, ptr %slot.syms, align 8
  %r21.p = getelementptr inbounds [2 x i8], ptr @.str.16, i64 0, i64 0
  %r21 = ptrtoint ptr %r21.p to i64
  call i64 @nova_rt_index_set(i64 %r20, i64 %r21, i64 %r19)
  %r22 = load i64, ptr %slot.syms, align 8
  %r23.p = getelementptr inbounds [2 x i8], ptr @.str.12, i64 0, i64 0
  %r23 = ptrtoint ptr %r23.p to i64
  %r24 = call i64 @lookup(i64 %r22, i64 %r23)
  %r25 = call i64 @nova_rt_print_any(i64 %r24)
  %r26 = load i64, ptr %slot.syms, align 8
  %r27.p = getelementptr inbounds [2 x i8], ptr @.str.17, i64 0, i64 0
  %r27 = ptrtoint ptr %r27.p to i64
  %r28 = call i64 @lookup(i64 %r26, i64 %r27)
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
@.str.0 = private unnamed_addr constant [1 x i8] c"\00"
@.str.1 = private unnamed_addr constant [2 x i8] c"(\00"
@.str.2 = private unnamed_addr constant [2 x i8] c")\00"
@.str.3 = private unnamed_addr constant [2 x i8] c"[\00"
@.str.4 = private unnamed_addr constant [3 x i8] c", \00"
@.str.5 = private unnamed_addr constant [2 x i8] c"]\00"
@.str.6 = private unnamed_addr constant [2 x i8] c"?\00"
@.str.7 = private unnamed_addr constant [8 x i8] c"unknown\00"
@.str.8 = private unnamed_addr constant [4 x i8] c"add\00"
@.str.9 = private unnamed_addr constant [4 x i8] c"int\00"
@.str.10 = private unnamed_addr constant [2 x i8] c"3\00"
@.str.11 = private unnamed_addr constant [2 x i8] c"4\00"
@.str.12 = private unnamed_addr constant [2 x i8] c"x\00"
@.str.13 = private unnamed_addr constant [7 x i8] c"string\00"
@.str.14 = private unnamed_addr constant [2 x i8] c"y\00"
@.str.15 = private unnamed_addr constant [5 x i8] c"bool\00"
@.str.16 = private unnamed_addr constant [2 x i8] c"z\00"
@.str.17 = private unnamed_addr constant [2 x i8] c"w\00"

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
