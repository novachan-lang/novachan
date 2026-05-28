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

define i64 @nova_main() nounwind {
entry:
  %slot.tokens = alloca i64, align 8
  store i64 0, ptr %slot.tokens, align 8
  %slot.current = alloca i64, align 8
  store i64 0, ptr %slot.current, align 8
  %slot.input = alloca i64, align 8
  store i64 0, ptr %slot.input, align 8
  %slot.i = alloca i64, align 8
  store i64 0, ptr %slot.i, align 8
  %slot.ch = alloca i64, align 8
  store i64 0, ptr %slot.ch, align 8
  %slot.kind = alloca i64, align 8
  store i64 0, ptr %slot.kind, align 8
  %slot.value = alloca i64, align 8
  store i64 0, ptr %slot.value, align 8
  %r0 = call i64 @nova_rt_list_create()
  store i64 %r0, ptr %slot.tokens, align 8
  %r1.p = getelementptr inbounds [1 x i8], ptr @.str.0, i64 0, i64 0
  %r1 = ptrtoint ptr %r1.p to i64
  store i64 %r1, ptr %slot.current, align 8
  %r2.p = getelementptr inbounds [6 x i8], ptr @.str.1, i64 0, i64 0
  %r2 = ptrtoint ptr %r2.p to i64
  store i64 %r2, ptr %slot.input, align 8
  %r3 = add i64 0, 0
  store i64 %r3, ptr %slot.i, align 8
  br label %while_hdr0, !llvm.loop !91
while_hdr0:
  %r4 = load i64, ptr %slot.i, align 8
  %r5 = load i64, ptr %slot.input, align 8
  %r6 = call i64 @nova_rt_len_any(i64 %r5)
  %r7.cmp = icmp slt i64 %r4, %r6
  %r7 = zext i1 %r7.cmp to i64
  %br_while_body1 = icmp ne i64 %r7, 0
  br i1 %br_while_body1, label %while_body1, label %while_exit2, !prof !90
while_body1:
  %r8 = load i64, ptr %slot.input, align 8
  %r9 = load i64, ptr %slot.i, align 8
  %r10 = call i64 @nova_rt_index_get(i64 %r8, i64 %r9)
  store i64 %r10, ptr %slot.ch, align 8
  %r11 = load i64, ptr %slot.ch, align 8
  %r12.p = getelementptr inbounds [2 x i8], ptr @.str.2, i64 0, i64 0
  %r12 = ptrtoint ptr %r12.p to i64
  %r13.p0 = inttoptr i64 %r11 to ptr
  %r13.p1 = inttoptr i64 %r12 to ptr
  %r13.sc = call i32 @strcmp(ptr %r13.p0, ptr %r13.p1)
  %r13.cmp = icmp eq i32 %r13.sc, 0
  %r13 = zext i1 %r13.cmp to i64
  %br_then3 = icmp ne i64 %r13, 0
  br i1 %br_then3, label %then3, label %else4
then3:
  %r14 = load i64, ptr %slot.current, align 8
  %r15 = call i64 @nova_rt_len_any(i64 %r14)
  %r16 = add i64 0, 0
  %r17.cmp = icmp sgt i64 %r15, %r16
  %r17 = zext i1 %r17.cmp to i64
  %br_then6 = icmp ne i64 %r17, 0
  br i1 %br_then6, label %then6, label %else7
then6:
  %r18 = load i64, ptr %slot.tokens, align 8
  %r19.p = getelementptr inbounds [5 x i8], ptr @.str.3, i64 0, i64 0
  %r19 = ptrtoint ptr %r19.p to i64
  %r20 = load i64, ptr %slot.current, align 8
  %r21.ptr = call ptr @nova_rt_struct_alloc(i64 24)
  %r21.thash = getelementptr i64, ptr %r21.ptr, i64 0
  store i64 210691276070, ptr %r21.thash, align 8
  %r21.f0 = getelementptr i64, ptr %r21.ptr, i64 1
  store i64 %r19, ptr %r21.f0, align 8
  %r21.f1 = getelementptr i64, ptr %r21.ptr, i64 2
  store i64 %r20, ptr %r21.f1, align 8
  %r21 = ptrtoint ptr %r21.ptr to i64
  %r22 = call i64 @nova_rt_list_append(i64 %r18, i64 %r21)
  %r23.p = getelementptr inbounds [1 x i8], ptr @.str.0, i64 0, i64 0
  %r23 = ptrtoint ptr %r23.p to i64
  store i64 %r23, ptr %slot.current, align 8
  br label %endif8
else7:
  br label %endif8
endif8:
  br label %endif5
else4:
  %r24 = load i64, ptr %slot.current, align 8
  %r25 = load i64, ptr %slot.ch, align 8
  %r26 = call i64 @nova_rt_str_concat(i64 %r24, i64 %r25)
  store i64 %r26, ptr %slot.current, align 8
  br label %endif5
endif5:
  %r27 = load i64, ptr %slot.i, align 8
  %r28 = add i64 1, 0
  %r29 = add i64 %r27, %r28
  store i64 %r29, ptr %slot.i, align 8
  br label %while_hdr0, !llvm.loop !91
while_exit2:
  %r30 = load i64, ptr %slot.current, align 8
  %r31 = call i64 @nova_rt_len_any(i64 %r30)
  %r32 = add i64 0, 0
  %r33.cmp = icmp sgt i64 %r31, %r32
  %r33 = zext i1 %r33.cmp to i64
  %br_then9 = icmp ne i64 %r33, 0
  br i1 %br_then9, label %then9, label %else10
then9:
  %r34 = load i64, ptr %slot.tokens, align 8
  %r35.p = getelementptr inbounds [5 x i8], ptr @.str.3, i64 0, i64 0
  %r35 = ptrtoint ptr %r35.p to i64
  %r36 = load i64, ptr %slot.current, align 8
  %r37.ptr = call ptr @nova_rt_struct_alloc(i64 24)
  %r37.thash = getelementptr i64, ptr %r37.ptr, i64 0
  store i64 210691276070, ptr %r37.thash, align 8
  %r37.f0 = getelementptr i64, ptr %r37.ptr, i64 1
  store i64 %r35, ptr %r37.f0, align 8
  %r37.f1 = getelementptr i64, ptr %r37.ptr, i64 2
  store i64 %r36, ptr %r37.f1, align 8
  %r37 = ptrtoint ptr %r37.ptr to i64
  %r38 = call i64 @nova_rt_list_append(i64 %r34, i64 %r37)
  br label %endif11
else10:
  br label %endif11
endif11:
  %r39.p = getelementptr inbounds [8 x i8], ptr @.str.4, i64 0, i64 0
  %r39 = ptrtoint ptr %r39.p to i64
  %r40 = load i64, ptr %slot.tokens, align 8
  %r41 = call i64 @nova_rt_len_any(i64 %r40)
  %r42 = call i64 @nova_rt_int_to_str(i64 %r41)
  %r43 = call i64 @nova_rt_str_concat(i64 %r39, i64 %r42)
  %r44 = call i64 @nova_rt_print_any(i64 %r43)
  %r45 = load i64, ptr %slot.tokens, align 8
  %r46 = add i64 0, 0
  %r47.lp = inttoptr i64 %r45 to ptr
  %r47.dp = load ptr, ptr %r47.lp, align 8, !tbaa !2
  %r47.ep = getelementptr i64, ptr %r47.dp, i64 %r46
  %r47 = load i64, ptr %r47.ep, align 8, !tbaa !4
  %r48.ptr = inttoptr i64 %r47 to ptr
  %r48.gep = getelementptr i64, ptr %r48.ptr, i64 0
  %r48 = load i64, ptr %r48.gep, align 8
  %r49 = add i64 210691276070, 0
  %r50.cmp = icmp eq i64 %r48, %r49
  %r50 = zext i1 %r50.cmp to i64
  %br_marm_013 = icmp ne i64 %r50, 0
  br i1 %br_marm_013, label %marm_013, label %match_fall14
marm_013:
  %r51.ptr = inttoptr i64 %r47 to ptr
  %r51.gep = getelementptr i64, ptr %r51.ptr, i64 1
  %r51 = load i64, ptr %r51.gep, align 8
  store i64 %r51, ptr %slot.kind, align 8
  %r52.ptr = inttoptr i64 %r47 to ptr
  %r52.gep = getelementptr i64, ptr %r52.ptr, i64 2
  %r52 = load i64, ptr %r52.gep, align 8
  store i64 %r52, ptr %slot.value, align 8
  %r53.p = getelementptr inbounds [5 x i8], ptr @.str.5, i64 0, i64 0
  %r53 = ptrtoint ptr %r53.p to i64
  %r54 = load i64, ptr %slot.kind, align 8
  %r55 = call i64 @nova_rt_str_concat(i64 %r53, i64 %r54)
  %r56.p = getelementptr inbounds [2 x i8], ptr @.str.2, i64 0, i64 0
  %r56 = ptrtoint ptr %r56.p to i64
  %r57 = call i64 @nova_rt_str_concat(i64 %r55, i64 %r56)
  %r58 = load i64, ptr %slot.value, align 8
  %r59 = call i64 @nova_rt_str_concat(i64 %r57, i64 %r58)
  %r60 = call i64 @nova_rt_print_any(i64 %r59)
  br label %match_exit12
match_fall14:
  br label %match_exit12
match_exit12:
  %r61 = load i64, ptr %slot.tokens, align 8
  %r62 = add i64 1, 0
  %r63.lp = inttoptr i64 %r61 to ptr
  %r63.dp = load ptr, ptr %r63.lp, align 8, !tbaa !2
  %r63.ep = getelementptr i64, ptr %r63.dp, i64 %r62
  %r63 = load i64, ptr %r63.ep, align 8, !tbaa !4
  %r64.ptr = inttoptr i64 %r63 to ptr
  %r64.gep = getelementptr i64, ptr %r64.ptr, i64 0
  %r64 = load i64, ptr %r64.gep, align 8
  %r65 = add i64 210691276070, 0
  %r66.cmp = icmp eq i64 %r64, %r65
  %r66 = zext i1 %r66.cmp to i64
  %br_marm_016 = icmp ne i64 %r66, 0
  br i1 %br_marm_016, label %marm_016, label %match_fall17
marm_016:
  %r67.ptr = inttoptr i64 %r63 to ptr
  %r67.gep = getelementptr i64, ptr %r67.ptr, i64 1
  %r67 = load i64, ptr %r67.gep, align 8
  store i64 %r67, ptr %slot.kind, align 8
  %r68.ptr = inttoptr i64 %r63 to ptr
  %r68.gep = getelementptr i64, ptr %r68.ptr, i64 2
  %r68 = load i64, ptr %r68.gep, align 8
  store i64 %r68, ptr %slot.value, align 8
  %r69.p = getelementptr inbounds [5 x i8], ptr @.str.6, i64 0, i64 0
  %r69 = ptrtoint ptr %r69.p to i64
  %r70 = load i64, ptr %slot.kind, align 8
  %r71 = call i64 @nova_rt_str_concat(i64 %r69, i64 %r70)
  %r72.p = getelementptr inbounds [2 x i8], ptr @.str.2, i64 0, i64 0
  %r72 = ptrtoint ptr %r72.p to i64
  %r73 = call i64 @nova_rt_str_concat(i64 %r71, i64 %r72)
  %r74 = load i64, ptr %slot.value, align 8
  %r75 = call i64 @nova_rt_str_concat(i64 %r73, i64 %r74)
  %r76 = call i64 @nova_rt_print_any(i64 %r75)
  br label %match_exit15
match_fall17:
  br label %match_exit15
match_exit15:
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
@.str.1 = private unnamed_addr constant [6 x i8] c"ab cd\00"
@.str.2 = private unnamed_addr constant [2 x i8] c" \00"
@.str.3 = private unnamed_addr constant [5 x i8] c"word\00"
@.str.4 = private unnamed_addr constant [8 x i8] c"count: \00"
@.str.5 = private unnamed_addr constant [5 x i8] c"t0: \00"
@.str.6 = private unnamed_addr constant [5 x i8] c"t1: \00"

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
