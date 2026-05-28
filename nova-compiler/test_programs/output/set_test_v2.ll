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

define i64 @nova_user_main() nounwind {
entry:
  %slot.set_create = alloca i64, align 8
  store i64 0, ptr %slot.set_create, align 8
  %slot.s = alloca i64, align 8
  store i64 0, ptr %slot.s, align 8
  %slot.set_add = alloca i64, align 8
  store i64 0, ptr %slot.set_add, align 8
  %slot.set_len = alloca i64, align 8
  store i64 0, ptr %slot.set_len, align 8
  %slot.set_has = alloca i64, align 8
  store i64 0, ptr %slot.set_has, align 8
  %slot.set_remove = alloca i64, align 8
  store i64 0, ptr %slot.set_remove, align 8
  %slot.set_to_list = alloca i64, align 8
  store i64 0, ptr %slot.set_to_list, align 8
  %slot.lst = alloca i64, align 8
  store i64 0, ptr %slot.lst, align 8
  %slot.big = alloca i64, align 8
  store i64 0, ptr %slot.big, align 8
  %slot.i = alloca i64, align 8
  store i64 0, ptr %slot.i, align 8
  %r1 = load i64, ptr %slot.set_create, align 8
  %r0.rec = inttoptr i64 %r1 to ptr
  %r0.fnraw = load i64, ptr %r0.rec, align 8
  %r0.fnptr = inttoptr i64 %r0.fnraw to ptr
  %r0 = call i64 %r0.fnptr(i64 %r1)
  store i64 %r0, ptr %slot.s, align 8
  %r2 = load i64, ptr %slot.s, align 8
  %r3 = add i64 10, 0
  %r5 = load i64, ptr %slot.set_add, align 8
  %r4.rec = inttoptr i64 %r5 to ptr
  %r4.fnraw = load i64, ptr %r4.rec, align 8
  %r4.fnptr = inttoptr i64 %r4.fnraw to ptr
  %r4 = call i64 %r4.fnptr(i64 %r5, i64 %r2, i64 %r3)
  %r6 = load i64, ptr %slot.s, align 8
  %r7 = add i64 20, 0
  %r9 = load i64, ptr %slot.set_add, align 8
  %r8.rec = inttoptr i64 %r9 to ptr
  %r8.fnraw = load i64, ptr %r8.rec, align 8
  %r8.fnptr = inttoptr i64 %r8.fnraw to ptr
  %r8 = call i64 %r8.fnptr(i64 %r9, i64 %r6, i64 %r7)
  %r10 = load i64, ptr %slot.s, align 8
  %r11 = add i64 30, 0
  %r13 = load i64, ptr %slot.set_add, align 8
  %r12.rec = inttoptr i64 %r13 to ptr
  %r12.fnraw = load i64, ptr %r12.rec, align 8
  %r12.fnptr = inttoptr i64 %r12.fnraw to ptr
  %r12 = call i64 %r12.fnptr(i64 %r13, i64 %r10, i64 %r11)
  %r14 = load i64, ptr %slot.s, align 8
  %r16 = load i64, ptr %slot.set_len, align 8
  %r15.rec = inttoptr i64 %r16 to ptr
  %r15.fnraw = load i64, ptr %r15.rec, align 8
  %r15.fnptr = inttoptr i64 %r15.fnraw to ptr
  %r15 = call i64 %r15.fnptr(i64 %r16, i64 %r14)
  %r17 = add i64 3, 0
  %r18 = call i64 @nova_rt_eq(i64 %r15, i64 %r17)
  %r19.p = getelementptr inbounds [27 x i8], ptr @.str.0, i64 0, i64 0
  %r19 = ptrtoint ptr %r19.p to i64
  %r20 = call i64 @nova_rt_assert(i64 %r18, i64 %r19)
  %r21 = load i64, ptr %slot.s, align 8
  %r22 = add i64 20, 0
  %r24 = load i64, ptr %slot.set_add, align 8
  %r23.rec = inttoptr i64 %r24 to ptr
  %r23.fnraw = load i64, ptr %r23.rec, align 8
  %r23.fnptr = inttoptr i64 %r23.fnraw to ptr
  %r23 = call i64 %r23.fnptr(i64 %r24, i64 %r21, i64 %r22)
  %r25 = load i64, ptr %slot.s, align 8
  %r27 = load i64, ptr %slot.set_len, align 8
  %r26.rec = inttoptr i64 %r27 to ptr
  %r26.fnraw = load i64, ptr %r26.rec, align 8
  %r26.fnptr = inttoptr i64 %r26.fnraw to ptr
  %r26 = call i64 %r26.fnptr(i64 %r27, i64 %r25)
  %r28 = add i64 3, 0
  %r29 = call i64 @nova_rt_eq(i64 %r26, i64 %r28)
  %r30.p = getelementptr inbounds [47 x i8], ptr @.str.1, i64 0, i64 0
  %r30 = ptrtoint ptr %r30.p to i64
  %r31 = call i64 @nova_rt_assert(i64 %r29, i64 %r30)
  %r32 = load i64, ptr %slot.s, align 8
  %r33 = add i64 10, 0
  %r35 = load i64, ptr %slot.set_has, align 8
  %r34.rec = inttoptr i64 %r35 to ptr
  %r34.fnraw = load i64, ptr %r34.rec, align 8
  %r34.fnptr = inttoptr i64 %r34.fnraw to ptr
  %r34 = call i64 %r34.fnptr(i64 %r35, i64 %r32, i64 %r33)
  %r36 = add i64 1, 0
  %r37 = call i64 @nova_rt_eq(i64 %r34, i64 %r36)
  %r38.p = getelementptr inbounds [22 x i8], ptr @.str.2, i64 0, i64 0
  %r38 = ptrtoint ptr %r38.p to i64
  %r39 = call i64 @nova_rt_assert(i64 %r37, i64 %r38)
  %r40 = load i64, ptr %slot.s, align 8
  %r41 = add i64 20, 0
  %r43 = load i64, ptr %slot.set_has, align 8
  %r42.rec = inttoptr i64 %r43 to ptr
  %r42.fnraw = load i64, ptr %r42.rec, align 8
  %r42.fnptr = inttoptr i64 %r42.fnraw to ptr
  %r42 = call i64 %r42.fnptr(i64 %r43, i64 %r40, i64 %r41)
  %r44 = add i64 1, 0
  %r45 = call i64 @nova_rt_eq(i64 %r42, i64 %r44)
  %r46.p = getelementptr inbounds [22 x i8], ptr @.str.3, i64 0, i64 0
  %r46 = ptrtoint ptr %r46.p to i64
  %r47 = call i64 @nova_rt_assert(i64 %r45, i64 %r46)
  %r48 = load i64, ptr %slot.s, align 8
  %r49 = add i64 99, 0
  %r51 = load i64, ptr %slot.set_has, align 8
  %r50.rec = inttoptr i64 %r51 to ptr
  %r50.fnraw = load i64, ptr %r50.rec, align 8
  %r50.fnptr = inttoptr i64 %r50.fnraw to ptr
  %r50 = call i64 %r50.fnptr(i64 %r51, i64 %r48, i64 %r49)
  %r52 = add i64 0, 0
  %r53 = call i64 @nova_rt_eq(i64 %r50, i64 %r52)
  %r54.p = getelementptr inbounds [26 x i8], ptr @.str.4, i64 0, i64 0
  %r54 = ptrtoint ptr %r54.p to i64
  %r55 = call i64 @nova_rt_assert(i64 %r53, i64 %r54)
  %r56 = load i64, ptr %slot.s, align 8
  %r57 = add i64 20, 0
  %r59 = load i64, ptr %slot.set_remove, align 8
  %r58.rec = inttoptr i64 %r59 to ptr
  %r58.fnraw = load i64, ptr %r58.rec, align 8
  %r58.fnptr = inttoptr i64 %r58.fnraw to ptr
  %r58 = call i64 %r58.fnptr(i64 %r59, i64 %r56, i64 %r57)
  %r60 = load i64, ptr %slot.s, align 8
  %r62 = load i64, ptr %slot.set_len, align 8
  %r61.rec = inttoptr i64 %r62 to ptr
  %r61.fnraw = load i64, ptr %r61.rec, align 8
  %r61.fnptr = inttoptr i64 %r61.fnraw to ptr
  %r61 = call i64 %r61.fnptr(i64 %r62, i64 %r60)
  %r63 = add i64 2, 0
  %r64 = call i64 @nova_rt_eq(i64 %r61, i64 %r63)
  %r65.p = getelementptr inbounds [31 x i8], ptr @.str.5, i64 0, i64 0
  %r65 = ptrtoint ptr %r65.p to i64
  %r66 = call i64 @nova_rt_assert(i64 %r64, i64 %r65)
  %r67 = load i64, ptr %slot.s, align 8
  %r68 = add i64 20, 0
  %r70 = load i64, ptr %slot.set_has, align 8
  %r69.rec = inttoptr i64 %r70 to ptr
  %r69.fnraw = load i64, ptr %r69.rec, align 8
  %r69.fnptr = inttoptr i64 %r69.fnraw to ptr
  %r69 = call i64 %r69.fnptr(i64 %r70, i64 %r67, i64 %r68)
  %r71 = add i64 0, 0
  %r72 = call i64 @nova_rt_eq(i64 %r69, i64 %r71)
  %r73.p = getelementptr inbounds [21 x i8], ptr @.str.6, i64 0, i64 0
  %r73 = ptrtoint ptr %r73.p to i64
  %r74 = call i64 @nova_rt_assert(i64 %r72, i64 %r73)
  %r75 = load i64, ptr %slot.s, align 8
  %r77 = load i64, ptr %slot.set_to_list, align 8
  %r76.rec = inttoptr i64 %r77 to ptr
  %r76.fnraw = load i64, ptr %r76.rec, align 8
  %r76.fnptr = inttoptr i64 %r76.fnraw to ptr
  %r76 = call i64 %r76.fnptr(i64 %r77, i64 %r75)
  store i64 %r76, ptr %slot.lst, align 8
  %r78 = load i64, ptr %slot.lst, align 8
  %r79 = call i64 @nova_rt_len_any(i64 %r78)
  %r80 = add i64 2, 0
  %r81.cmp = icmp eq i64 %r79, %r80
  %r81 = zext i1 %r81.cmp to i64
  %r82.p = getelementptr inbounds [37 x i8], ptr @.str.7, i64 0, i64 0
  %r82 = ptrtoint ptr %r82.p to i64
  %r83 = call i64 @nova_rt_assert(i64 %r81, i64 %r82)
  %r84.p = getelementptr inbounds [14 x i8], ptr @.str.8, i64 0, i64 0
  %r84 = ptrtoint ptr %r84.p to i64
  %r85 = load i64, ptr %slot.lst, align 8
  %r86 = call i64 @nova_rt_any_to_str(i64 %r85)
  %r87 = call i64 @nova_rt_str_concat(i64 %r84, i64 %r86)
  %r88.p = getelementptr inbounds [1 x i8], ptr @.str.9, i64 0, i64 0
  %r88 = ptrtoint ptr %r88.p to i64
  %r89 = call i64 @nova_rt_str_concat(i64 %r87, i64 %r88)
  %r90 = call i64 @nova_rt_print_any(i64 %r89)
  %r92 = load i64, ptr %slot.set_create, align 8
  %r91.rec = inttoptr i64 %r92 to ptr
  %r91.fnraw = load i64, ptr %r91.rec, align 8
  %r91.fnptr = inttoptr i64 %r91.fnraw to ptr
  %r91 = call i64 %r91.fnptr(i64 %r92)
  store i64 %r91, ptr %slot.big, align 8
  %r93 = add i64 0, 0
  store i64 %r93, ptr %slot.i, align 8
  br label %while_hdr0, !llvm.loop !91
while_hdr0:
  %r94 = load i64, ptr %slot.i, align 8
  %r95 = add i64 100, 0
  %r96.cmp = icmp slt i64 %r94, %r95
  %r96 = zext i1 %r96.cmp to i64
  %br_while_body1 = icmp ne i64 %r96, 0
  br i1 %br_while_body1, label %while_body1, label %while_exit2, !prof !90
while_body1:
  %r97 = load i64, ptr %slot.big, align 8
  %r98 = load i64, ptr %slot.i, align 8
  %r100 = load i64, ptr %slot.set_add, align 8
  %r99.rec = inttoptr i64 %r100 to ptr
  %r99.fnraw = load i64, ptr %r99.rec, align 8
  %r99.fnptr = inttoptr i64 %r99.fnraw to ptr
  %r99 = call i64 %r99.fnptr(i64 %r100, i64 %r97, i64 %r98)
  %r101 = load i64, ptr %slot.i, align 8
  %r102 = add i64 1, 0
  %r103 = add i64 %r101, %r102
  store i64 %r103, ptr %slot.i, align 8
  br label %while_hdr0, !llvm.loop !91
while_exit2:
  %r104 = load i64, ptr %slot.big, align 8
  %r106 = load i64, ptr %slot.set_len, align 8
  %r105.rec = inttoptr i64 %r106 to ptr
  %r105.fnraw = load i64, ptr %r105.rec, align 8
  %r105.fnptr = inttoptr i64 %r105.fnraw to ptr
  %r105 = call i64 %r105.fnptr(i64 %r106, i64 %r104)
  %r107 = add i64 100, 0
  %r108 = call i64 @nova_rt_eq(i64 %r105, i64 %r107)
  %r109.p = getelementptr inbounds [33 x i8], ptr @.str.10, i64 0, i64 0
  %r109 = ptrtoint ptr %r109.p to i64
  %r110 = call i64 @nova_rt_assert(i64 %r108, i64 %r109)
  %r111.p = getelementptr inbounds [21 x i8], ptr @.str.11, i64 0, i64 0
  %r111 = ptrtoint ptr %r111.p to i64
  %r112 = call i64 @nova_rt_print_any(i64 %r111)
  ret i64 %r112
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
@.str.0 = private unnamed_addr constant [27 x i8] c"set should have 3 elements\00"
@.str.1 = private unnamed_addr constant [47 x i8] c"set should still have 3 elements after dup add\00"
@.str.2 = private unnamed_addr constant [22 x i8] c"set should contain 10\00"
@.str.3 = private unnamed_addr constant [22 x i8] c"set should contain 20\00"
@.str.4 = private unnamed_addr constant [26 x i8] c"set should not contain 99\00"
@.str.5 = private unnamed_addr constant [31 x i8] c"set should have 2 after remove\00"
@.str.6 = private unnamed_addr constant [21 x i8] c"20 should be removed\00"
@.str.7 = private unnamed_addr constant [37 x i8] c"list from set should have 2 elements\00"
@.str.8 = private unnamed_addr constant [14 x i8] c"set as list: \00"
@.str.9 = private unnamed_addr constant [1 x i8] c"\00"
@.str.10 = private unnamed_addr constant [33 x i8] c"big set should have 100 elements\00"
@.str.11 = private unnamed_addr constant [21 x i8] c"all set tests passed\00"

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
