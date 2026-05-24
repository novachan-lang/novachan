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

define i64 @nova_parse_toml_deps(i64 %p0) nounwind {
entry:
  %slot.content = alloca i64, align 8
  store i64 %p0, ptr %slot.content, align 8
  %slot.deps = alloca i64, align 8
  store i64 0, ptr %slot.deps, align 8
  %r0 = call i64 @nova_rt_dict_create()
  store i64 %r0, ptr %slot.deps, align 8
  %r1 = load i64, ptr %slot.deps, align 8
  ret i64 %r1
}

define i64 @nova_pkg_get(i64 %p0) nounwind {
entry:
  %slot.pkg_spec = alloca i64, align 8
  store i64 %p0, ptr %slot.pkg_spec, align 8
  %slot.pkg_name = alloca i64, align 8
  store i64 0, ptr %slot.pkg_name, align 8
  %slot.pkg_version = alloca i64, align 8
  store i64 0, ptr %slot.pkg_version, align 8
  %slot.at_pos = alloca i64, align 8
  store i64 0, ptr %slot.at_pos, align 8
  %slot.toml = alloca i64, align 8
  store i64 0, ptr %slot.toml, align 8
  %slot.deps = alloca i64, align 8
  store i64 0, ptr %slot.deps, align 8
  %slot.existing_ver = alloca i64, align 8
  store i64 0, ptr %slot.existing_ver, align 8
  %slot.dep_line = alloca i64, align 8
  store i64 0, ptr %slot.dep_line, align 8
  %r0 = load i64, ptr %slot.pkg_spec, align 8
  store i64 %r0, ptr %slot.pkg_name, align 8
  %r1.p = getelementptr inbounds [2 x i8], ptr @.str.0, i64 0, i64 0
  %r1 = ptrtoint ptr %r1.p to i64
  store i64 %r1, ptr %slot.pkg_version, align 8
  %r2 = load i64, ptr %slot.pkg_spec, align 8
  %r3.p = getelementptr inbounds [2 x i8], ptr @.str.1, i64 0, i64 0
  %r3 = ptrtoint ptr %r3.p to i64
  %r4 = call i64 @nova_rt_find(i64 %r2, i64 %r3)
  store i64 %r4, ptr %slot.at_pos, align 8
  %r5 = load i64, ptr %slot.at_pos, align 8
  %r6 = add i64 0, 0
  %r7.cmp = icmp sge i64 %r5, %r6
  %r7 = zext i1 %r7.cmp to i64
  %br_then0 = icmp ne i64 %r7, 0
  br i1 %br_then0, label %then0, label %else1
then0:
  %r8 = load i64, ptr %slot.pkg_spec, align 8
  %r9 = add i64 0, 0
  %r10 = load i64, ptr %slot.at_pos, align 8
  %r11 = call i64 @nova_rt_slice(i64 %r8, i64 %r9, i64 %r10)
  store i64 %r11, ptr %slot.pkg_name, align 8
  %r12 = load i64, ptr %slot.pkg_spec, align 8
  %r13 = load i64, ptr %slot.at_pos, align 8
  %r14 = add i64 1, 0
  %r15 = call i64 @nova_rt_add(i64 %r13, i64 %r14)
  %r16 = load i64, ptr %slot.pkg_spec, align 8
  %r17 = call i64 @nova_rt_len_any(i64 %r16)
  %r18 = call i64 @nova_rt_slice(i64 %r12, i64 %r15, i64 %r17)
  store i64 %r18, ptr %slot.pkg_version, align 8
  br label %endif2
else1:
  br label %endif2
endif2:
  %r19.p = getelementptr inbounds [10 x i8], ptr @.str.2, i64 0, i64 0
  %r19 = ptrtoint ptr %r19.p to i64
  %r20 = call i64 @nova_rt_read_file(i64 %r19)
  store i64 %r20, ptr %slot.toml, align 8
  %r21 = load i64, ptr %slot.toml, align 8
  %r22 = call i64 @nova_rt_len_any(i64 %r21)
  %r23 = add i64 0, 0
  %r24.cmp = icmp eq i64 %r22, %r23
  %r24 = zext i1 %r24.cmp to i64
  %br_then3 = icmp ne i64 %r24, 0
  br i1 %br_then3, label %then3, label %else4
then3:
  %r25.p = getelementptr inbounds [26 x i8], ptr @.str.3, i64 0, i64 0
  %r25 = ptrtoint ptr %r25.p to i64
  %r26 = call i64 @nova_rt_print_any(i64 %r25)
  %r27 = add i64 1, 0
  %r28 = call i64 @nova_rt_exit(i64 %r27)
  br label %endif5
else4:
  br label %endif5
endif5:
  %r29 = load i64, ptr %slot.toml, align 8
  %r30 = call i64 @nova_parse_toml_deps(i64 %r29)
  store i64 %r30, ptr %slot.deps, align 8
  %r31 = load i64, ptr %slot.deps, align 8
  %r32 = load i64, ptr %slot.pkg_name, align 8
  %r33 = call i64 @nova_rt_contains(i64 %r31, i64 %r32)
  %br_then6 = icmp ne i64 %r33, 0
  br i1 %br_then6, label %then6, label %else7
then6:
  %r34 = load i64, ptr %slot.deps, align 8
  %r35 = load i64, ptr %slot.pkg_name, align 8
  %r36 = call i64 @nova_rt_index_get(i64 %r34, i64 %r35)
  store i64 %r36, ptr %slot.existing_ver, align 8
  %r37.p = getelementptr inbounds [10 x i8], ptr @.str.4, i64 0, i64 0
  %r37 = ptrtoint ptr %r37.p to i64
  %r38 = load i64, ptr %slot.pkg_name, align 8
  %r39 = call i64 @nova_rt_any_to_str(i64 %r38)
  %r40 = call i64 @nova_rt_str_concat(i64 %r37, i64 %r39)
  %r41.p = getelementptr inbounds [28 x i8], ptr @.str.5, i64 0, i64 0
  %r41 = ptrtoint ptr %r41.p to i64
  %r42 = call i64 @nova_rt_str_concat(i64 %r40, i64 %r41)
  %r43 = load i64, ptr %slot.existing_ver, align 8
  %r44 = call i64 @nova_rt_any_to_str(i64 %r43)
  %r45 = call i64 @nova_rt_str_concat(i64 %r42, i64 %r44)
  %r46.p = getelementptr inbounds [2 x i8], ptr @.str.6, i64 0, i64 0
  %r46 = ptrtoint ptr %r46.p to i64
  %r47 = call i64 @nova_rt_str_concat(i64 %r45, i64 %r46)
  %r48 = call i64 @nova_rt_print_any(i64 %r47)
  %r49 = add i64 0, 0
  ret i64 %r49
else7:
  br label %endif8
endif8:
  %r50 = load i64, ptr %slot.pkg_name, align 8
  %r51.p = getelementptr inbounds [5 x i8], ptr @.str.7, i64 0, i64 0
  %r51 = ptrtoint ptr %r51.p to i64
  %r52 = call i64 @nova_rt_str_concat(i64 %r50, i64 %r51)
  %r53 = load i64, ptr %slot.pkg_version, align 8
  %r54 = call i64 @nova_rt_str_concat(i64 %r52, i64 %r53)
  %r55.p = getelementptr inbounds [3 x i8], ptr @.str.8, i64 0, i64 0
  %r55 = ptrtoint ptr %r55.p to i64
  %r56 = call i64 @nova_rt_str_concat(i64 %r54, i64 %r55)
  store i64 %r56, ptr %slot.dep_line, align 8
  %r57 = load i64, ptr %slot.dep_line, align 8
  %r58 = call i64 @nova_rt_print_any(i64 %r57)
  ret i64 %r58
}

define i64 @nova_user_main() nounwind {
entry:
  %r0.p = getelementptr inbounds [10 x i8], ptr @.str.9, i64 0, i64 0
  %r0 = ptrtoint ptr %r0.p to i64
  %r1 = call i64 @nova_rt_print_any(i64 %r0)
  ret i64 %r1
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
@.str.0 = private unnamed_addr constant [2 x i8] c"*\00"
@.str.1 = private unnamed_addr constant [2 x i8] c"@\00"
@.str.2 = private unnamed_addr constant [10 x i8] c"nova.toml\00"
@.str.3 = private unnamed_addr constant [26 x i8] c"error: no nova.toml found\00"
@.str.4 = private unnamed_addr constant [10 x i8] c"Package '\00"
@.str.5 = private unnamed_addr constant [28 x i8] c"' already in deps (version \00"
@.str.6 = private unnamed_addr constant [2 x i8] c")\00"
@.str.7 = private unnamed_addr constant [5 x i8] c" = \22\00"
@.str.8 = private unnamed_addr constant [3 x i8] c"\22\0A\00"
@.str.9 = private unnamed_addr constant [10 x i8] c"test done\00"

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
