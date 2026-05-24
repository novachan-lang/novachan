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

define i64 @null_expr() nounwind {
entry:
  %r0.p = getelementptr inbounds [5 x i8], ptr @.str.0, i64 0, i64 0
  %r0 = ptrtoint ptr %r0.p to i64
  %r1.p = getelementptr inbounds [1 x i8], ptr @.str.1, i64 0, i64 0
  %r1 = ptrtoint ptr %r1.p to i64
  %r2 = add i64 0, 0
  %r3 = call i64 @nova_rt_list_create()
  %r4 = call i64 @nova_rt_list_create()
  %r5 = add i64 0, 0
  %r6.ptr = call ptr @nova_rt_struct_alloc(i64 56)
  %r6.thash = getelementptr i64, ptr %r6.ptr, i64 0
  store i64 6384055044, ptr %r6.thash, align 8
  %r6.f0 = getelementptr i64, ptr %r6.ptr, i64 1
  store i64 %r0, ptr %r6.f0, align 8
  %r6.f1 = getelementptr i64, ptr %r6.ptr, i64 2
  store i64 %r1, ptr %r6.f1, align 8
  %r6.f2 = getelementptr i64, ptr %r6.ptr, i64 3
  store i64 %r2, ptr %r6.f2, align 8
  %r6.f3 = getelementptr i64, ptr %r6.ptr, i64 4
  store i64 %r3, ptr %r6.f3, align 8
  %r6.f4 = getelementptr i64, ptr %r6.ptr, i64 5
  store i64 %r4, ptr %r6.f4, align 8
  %r6.f5 = getelementptr i64, ptr %r6.ptr, i64 6
  store i64 %r5, ptr %r6.f5, align 8
  %r6 = ptrtoint ptr %r6.ptr to i64
  ret i64 %r6
}

define i64 @nova_user_main() nounwind {
entry:
  %slot.e = alloca i64, align 8
  store i64 0, ptr %slot.e, align 8
  %slot.tag = alloca i64, align 8
  store i64 0, ptr %slot.tag, align 8
  %slot.value = alloca i64, align 8
  store i64 0, ptr %slot.value, align 8
  %slot.num = alloca i64, align 8
  store i64 0, ptr %slot.num, align 8
  %slot.children = alloca i64, align 8
  store i64 0, ptr %slot.children, align 8
  %slot.fields = alloca i64, align 8
  store i64 0, ptr %slot.fields, align 8
  %slot.eline = alloca i64, align 8
  store i64 0, ptr %slot.eline, align 8
  %slot.ne = alloca i64, align 8
  store i64 0, ptr %slot.ne, align 8
  %slot.s = alloca i64, align 8
  store i64 0, ptr %slot.s, align 8
  %slot.stag = alloca i64, align 8
  store i64 0, ptr %slot.stag, align 8
  %slot.name = alloca i64, align 8
  store i64 0, ptr %slot.name, align 8
  %slot.expr = alloca i64, align 8
  store i64 0, ptr %slot.expr, align 8
  %slot.body = alloca i64, align 8
  store i64 0, ptr %slot.body, align 8
  %slot.params = alloca i64, align 8
  store i64 0, ptr %slot.params, align 8
  %slot.else_body = alloca i64, align 8
  store i64 0, ptr %slot.else_body, align 8
  %slot.annotations = alloca i64, align 8
  store i64 0, ptr %slot.annotations, align 8
  %slot.sline = alloca i64, align 8
  store i64 0, ptr %slot.sline, align 8
  %r0.p = getelementptr inbounds [4 x i8], ptr @.str.2, i64 0, i64 0
  %r0 = ptrtoint ptr %r0.p to i64
  %r1.p = getelementptr inbounds [2 x i8], ptr @.str.3, i64 0, i64 0
  %r1 = ptrtoint ptr %r1.p to i64
  %r2 = add i64 0, 0
  %r3 = call i64 @nova_rt_list_create()
  %r4 = call i64 @nova_rt_list_create()
  %r5 = add i64 42, 0
  %r6.ptr = call ptr @nova_rt_struct_alloc(i64 56)
  %r6.thash = getelementptr i64, ptr %r6.ptr, i64 0
  store i64 6384055044, ptr %r6.thash, align 8
  %r6.f0 = getelementptr i64, ptr %r6.ptr, i64 1
  store i64 %r0, ptr %r6.f0, align 8
  %r6.f1 = getelementptr i64, ptr %r6.ptr, i64 2
  store i64 %r1, ptr %r6.f1, align 8
  %r6.f2 = getelementptr i64, ptr %r6.ptr, i64 3
  store i64 %r2, ptr %r6.f2, align 8
  %r6.f3 = getelementptr i64, ptr %r6.ptr, i64 4
  store i64 %r3, ptr %r6.f3, align 8
  %r6.f4 = getelementptr i64, ptr %r6.ptr, i64 5
  store i64 %r4, ptr %r6.f4, align 8
  %r6.f5 = getelementptr i64, ptr %r6.ptr, i64 6
  store i64 %r5, ptr %r6.f5, align 8
  %r6 = ptrtoint ptr %r6.ptr to i64
  store i64 %r6, ptr %slot.e, align 8
  %r7 = load i64, ptr %slot.e, align 8
  %r8.ptr = inttoptr i64 %r7 to ptr
  %r8.gep = getelementptr i64, ptr %r8.ptr, i64 0
  %r8 = load i64, ptr %r8.gep, align 8
  %r9 = add i64 6384055044, 0
  %r10.cmp = icmp eq i64 %r8, %r9
  %r10 = zext i1 %r10.cmp to i64
  %br_marm_01 = icmp ne i64 %r10, 0
  br i1 %br_marm_01, label %marm_01, label %match_fall2
marm_01:
  %r11.ptr = inttoptr i64 %r7 to ptr
  %r11.gep = getelementptr i64, ptr %r11.ptr, i64 1
  %r11 = load i64, ptr %r11.gep, align 8
  store i64 %r11, ptr %slot.tag, align 8
  %r12.ptr = inttoptr i64 %r7 to ptr
  %r12.gep = getelementptr i64, ptr %r12.ptr, i64 2
  %r12 = load i64, ptr %r12.gep, align 8
  store i64 %r12, ptr %slot.value, align 8
  %r13.ptr = inttoptr i64 %r7 to ptr
  %r13.gep = getelementptr i64, ptr %r13.ptr, i64 3
  %r13 = load i64, ptr %r13.gep, align 8
  store i64 %r13, ptr %slot.num, align 8
  %r14.ptr = inttoptr i64 %r7 to ptr
  %r14.gep = getelementptr i64, ptr %r14.ptr, i64 4
  %r14 = load i64, ptr %r14.gep, align 8
  store i64 %r14, ptr %slot.children, align 8
  %r15.ptr = inttoptr i64 %r7 to ptr
  %r15.gep = getelementptr i64, ptr %r15.ptr, i64 5
  %r15 = load i64, ptr %r15.gep, align 8
  store i64 %r15, ptr %slot.fields, align 8
  %r16.ptr = inttoptr i64 %r7 to ptr
  %r16.gep = getelementptr i64, ptr %r16.ptr, i64 6
  %r16 = load i64, ptr %r16.gep, align 8
  store i64 %r16, ptr %slot.eline, align 8
  %r17.p = getelementptr inbounds [11 x i8], ptr @.str.4, i64 0, i64 0
  %r17 = ptrtoint ptr %r17.p to i64
  %r18 = load i64, ptr %slot.tag, align 8
  %r19 = call i64 @nova_rt_str_concat(i64 %r17, i64 %r18)
  %r20.p = getelementptr inbounds [8 x i8], ptr @.str.5, i64 0, i64 0
  %r20 = ptrtoint ptr %r20.p to i64
  %r21 = call i64 @nova_rt_str_concat(i64 %r19, i64 %r20)
  %r22 = load i64, ptr %slot.eline, align 8
  %r23 = call i64 @nova_rt_int_to_str(i64 %r22)
  %r24 = call i64 @nova_rt_str_concat(i64 %r21, i64 %r23)
  %r25 = call i64 @nova_rt_print_any(i64 %r24)
  br label %match_exit0
match_fall2:
  br label %match_exit0
match_exit0:
  %r26 = call i64 @null_expr()
  store i64 %r26, ptr %slot.ne, align 8
  %r27 = load i64, ptr %slot.ne, align 8
  %r28.ptr = inttoptr i64 %r27 to ptr
  %r28.gep = getelementptr i64, ptr %r28.ptr, i64 0
  %r28 = load i64, ptr %r28.gep, align 8
  %r29 = add i64 6384055044, 0
  %r30.cmp = icmp eq i64 %r28, %r29
  %r30 = zext i1 %r30.cmp to i64
  %br_marm_04 = icmp ne i64 %r30, 0
  br i1 %br_marm_04, label %marm_04, label %match_fall5
marm_04:
  %r31.ptr = inttoptr i64 %r27 to ptr
  %r31.gep = getelementptr i64, ptr %r31.ptr, i64 1
  %r31 = load i64, ptr %r31.gep, align 8
  store i64 %r31, ptr %slot.tag, align 8
  %r32.ptr = inttoptr i64 %r27 to ptr
  %r32.gep = getelementptr i64, ptr %r32.ptr, i64 2
  %r32 = load i64, ptr %r32.gep, align 8
  store i64 %r32, ptr %slot.value, align 8
  %r33.ptr = inttoptr i64 %r27 to ptr
  %r33.gep = getelementptr i64, ptr %r33.ptr, i64 3
  %r33 = load i64, ptr %r33.gep, align 8
  store i64 %r33, ptr %slot.num, align 8
  %r34.ptr = inttoptr i64 %r27 to ptr
  %r34.gep = getelementptr i64, ptr %r34.ptr, i64 4
  %r34 = load i64, ptr %r34.gep, align 8
  store i64 %r34, ptr %slot.children, align 8
  %r35.ptr = inttoptr i64 %r27 to ptr
  %r35.gep = getelementptr i64, ptr %r35.ptr, i64 5
  %r35 = load i64, ptr %r35.gep, align 8
  store i64 %r35, ptr %slot.fields, align 8
  %r36.ptr = inttoptr i64 %r27 to ptr
  %r36.gep = getelementptr i64, ptr %r36.ptr, i64 6
  %r36 = load i64, ptr %r36.gep, align 8
  store i64 %r36, ptr %slot.eline, align 8
  %r37.p = getelementptr inbounds [16 x i8], ptr @.str.6, i64 0, i64 0
  %r37 = ptrtoint ptr %r37.p to i64
  %r38 = load i64, ptr %slot.tag, align 8
  %r39 = call i64 @nova_rt_str_concat(i64 %r37, i64 %r38)
  %r40 = call i64 @nova_rt_print_any(i64 %r39)
  br label %match_exit3
match_fall5:
  br label %match_exit3
match_exit3:
  %r41.p = getelementptr inbounds [4 x i8], ptr @.str.7, i64 0, i64 0
  %r41 = ptrtoint ptr %r41.p to i64
  %r42.p = getelementptr inbounds [2 x i8], ptr @.str.3, i64 0, i64 0
  %r42 = ptrtoint ptr %r42.p to i64
  %r43 = load i64, ptr %slot.e, align 8
  %r44 = call i64 @nova_rt_list_create()
  %r45 = call i64 @nova_rt_list_create()
  %r46 = call i64 @nova_rt_list_create()
  %r47 = call i64 @nova_rt_list_create()
  %r48 = add i64 10, 0
  %r49.ptr = call ptr @nova_rt_struct_alloc(i64 72)
  %r49.thash = getelementptr i64, ptr %r49.ptr, i64 0
  store i64 6384553709, ptr %r49.thash, align 8
  %r49.f0 = getelementptr i64, ptr %r49.ptr, i64 1
  store i64 %r41, ptr %r49.f0, align 8
  %r49.f1 = getelementptr i64, ptr %r49.ptr, i64 2
  store i64 %r42, ptr %r49.f1, align 8
  %r49.f2 = getelementptr i64, ptr %r49.ptr, i64 3
  store i64 %r43, ptr %r49.f2, align 8
  %r49.f3 = getelementptr i64, ptr %r49.ptr, i64 4
  store i64 %r44, ptr %r49.f3, align 8
  %r49.f4 = getelementptr i64, ptr %r49.ptr, i64 5
  store i64 %r45, ptr %r49.f4, align 8
  %r49.f5 = getelementptr i64, ptr %r49.ptr, i64 6
  store i64 %r46, ptr %r49.f5, align 8
  %r49.f6 = getelementptr i64, ptr %r49.ptr, i64 7
  store i64 %r47, ptr %r49.f6, align 8
  %r49.f7 = getelementptr i64, ptr %r49.ptr, i64 8
  store i64 %r48, ptr %r49.f7, align 8
  %r49 = ptrtoint ptr %r49.ptr to i64
  store i64 %r49, ptr %slot.s, align 8
  %r50 = load i64, ptr %slot.s, align 8
  %r51.ptr = inttoptr i64 %r50 to ptr
  %r51.gep = getelementptr i64, ptr %r51.ptr, i64 0
  %r51 = load i64, ptr %r51.gep, align 8
  %r52 = add i64 6384553709, 0
  %r53.cmp = icmp eq i64 %r51, %r52
  %r53 = zext i1 %r53.cmp to i64
  %br_marm_07 = icmp ne i64 %r53, 0
  br i1 %br_marm_07, label %marm_07, label %match_fall8
marm_07:
  %r54.ptr = inttoptr i64 %r50 to ptr
  %r54.gep = getelementptr i64, ptr %r54.ptr, i64 1
  %r54 = load i64, ptr %r54.gep, align 8
  store i64 %r54, ptr %slot.stag, align 8
  %r55.ptr = inttoptr i64 %r50 to ptr
  %r55.gep = getelementptr i64, ptr %r55.ptr, i64 2
  %r55 = load i64, ptr %r55.gep, align 8
  store i64 %r55, ptr %slot.name, align 8
  %r56.ptr = inttoptr i64 %r50 to ptr
  %r56.gep = getelementptr i64, ptr %r56.ptr, i64 3
  %r56 = load i64, ptr %r56.gep, align 8
  store i64 %r56, ptr %slot.expr, align 8
  %r57.ptr = inttoptr i64 %r50 to ptr
  %r57.gep = getelementptr i64, ptr %r57.ptr, i64 4
  %r57 = load i64, ptr %r57.gep, align 8
  store i64 %r57, ptr %slot.body, align 8
  %r58.ptr = inttoptr i64 %r50 to ptr
  %r58.gep = getelementptr i64, ptr %r58.ptr, i64 5
  %r58 = load i64, ptr %r58.gep, align 8
  store i64 %r58, ptr %slot.params, align 8
  %r59.ptr = inttoptr i64 %r50 to ptr
  %r59.gep = getelementptr i64, ptr %r59.ptr, i64 6
  %r59 = load i64, ptr %r59.gep, align 8
  store i64 %r59, ptr %slot.else_body, align 8
  %r60.ptr = inttoptr i64 %r50 to ptr
  %r60.gep = getelementptr i64, ptr %r60.ptr, i64 7
  %r60 = load i64, ptr %r60.gep, align 8
  store i64 %r60, ptr %slot.annotations, align 8
  %r61.ptr = inttoptr i64 %r50 to ptr
  %r61.gep = getelementptr i64, ptr %r61.ptr, i64 8
  %r61 = load i64, ptr %r61.gep, align 8
  store i64 %r61, ptr %slot.sline, align 8
  %r62.p = getelementptr inbounds [11 x i8], ptr @.str.8, i64 0, i64 0
  %r62 = ptrtoint ptr %r62.p to i64
  %r63 = load i64, ptr %slot.stag, align 8
  %r64 = call i64 @nova_rt_str_concat(i64 %r62, i64 %r63)
  %r65.p = getelementptr inbounds [8 x i8], ptr @.str.5, i64 0, i64 0
  %r65 = ptrtoint ptr %r65.p to i64
  %r66 = call i64 @nova_rt_str_concat(i64 %r64, i64 %r65)
  %r67 = load i64, ptr %slot.sline, align 8
  %r68 = call i64 @nova_rt_int_to_str(i64 %r67)
  %r69 = call i64 @nova_rt_str_concat(i64 %r66, i64 %r68)
  %r70 = call i64 @nova_rt_print_any(i64 %r69)
  br label %match_exit6
match_fall8:
  br label %match_exit6
match_exit6:
  %r71.p = getelementptr inbounds [5 x i8], ptr @.str.9, i64 0, i64 0
  %r71 = ptrtoint ptr %r71.p to i64
  %r72 = call i64 @nova_rt_print_any(i64 %r71)
  ret i64 %r72
}

define i64 @nova_main() nounwind {
entry:
  %r0 = call i64 @nova_user_main()
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
@.str.0 = private unnamed_addr constant [5 x i8] c"null\00"
@.str.1 = private unnamed_addr constant [1 x i8] c"\00"
@.str.2 = private unnamed_addr constant [4 x i8] c"var\00"
@.str.3 = private unnamed_addr constant [2 x i8] c"x\00"
@.str.4 = private unnamed_addr constant [11 x i8] c"Expr tag: \00"
@.str.5 = private unnamed_addr constant [8 x i8] c" line: \00"
@.str.6 = private unnamed_addr constant [16 x i8] c"null_expr tag: \00"
@.str.7 = private unnamed_addr constant [4 x i8] c"let\00"
@.str.8 = private unnamed_addr constant [11 x i8] c"Stmt tag: \00"
@.str.9 = private unnamed_addr constant [5 x i8] c"done\00"

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
