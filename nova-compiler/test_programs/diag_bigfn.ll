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
declare i64 @nova_rt_sort(i64) nounwind
declare i64 @nova_rt_dict_keys(i64) nounwind
declare i64 @nova_rt_dict_values(i64) nounwind
declare i64 @nova_rt_dict_items(i64) nounwind
declare i64 @nova_rt_system(i64) nounwind
declare i64 @nova_rt_exec(i64) nounwind
declare i64 @nova_rt_create_string(ptr) nounwind
declare void @nova_rt_init_args(i64, i64) nounwind
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

define i64 @make_type(i64 %p0, i64 %p1) nounwind {
entry:
  %slot.k = alloca i64, align 8
  store i64 %p0, ptr %slot.k, align 8
  %slot.n = alloca i64, align 8
  store i64 %p1, ptr %slot.n, align 8
  %r0 = load i64, ptr %slot.k, align 8
  %r1 = load i64, ptr %slot.n, align 8
  %r2 = add i64 0, 0
  %r3.ptr = call ptr @nova_rt_struct_alloc(i64 32)
  %r3.thash = getelementptr i64, ptr %r3.ptr, i64 0
  store i64 6952549217165, ptr %r3.thash, align 8
  %r3.f0 = getelementptr i64, ptr %r3.ptr, i64 1
  store i64 %r0, ptr %r3.f0, align 8
  %r3.f1 = getelementptr i64, ptr %r3.ptr, i64 2
  store i64 %r1, ptr %r3.f1, align 8
  %r3.f2 = getelementptr i64, ptr %r3.ptr, i64 3
  store i64 %r2, ptr %r3.f2, align 8
  %r3 = ptrtoint ptr %r3.ptr to i64
  ret i64 %r3
}

define i64 @build_registry() nounwind {
entry:
  %slot.reg = alloca i64, align 8
  store i64 0, ptr %slot.reg, align 8
  %r0 = call i64 @nova_rt_dict_create()
  store i64 %r0, ptr %slot.reg, align 8
  %r1.p = getelementptr inbounds [3 x i8], ptr @.str.0, i64 0, i64 0
  %r1 = ptrtoint ptr %r1.p to i64
  %r2.p = getelementptr inbounds [3 x i8], ptr @.str.1, i64 0, i64 0
  %r2 = ptrtoint ptr %r2.p to i64
  %r3 = call i64 @make_type(i64 %r1, i64 %r2)
  %r4 = load i64, ptr %slot.reg, align 8
  %r5.p = getelementptr inbounds [3 x i8], ptr @.str.1, i64 0, i64 0
  %r5 = ptrtoint ptr %r5.p to i64
  call i64 @nova_rt_index_set(i64 %r4, i64 %r5, i64 %r3)
  %r6.p = getelementptr inbounds [3 x i8], ptr @.str.0, i64 0, i64 0
  %r6 = ptrtoint ptr %r6.p to i64
  %r7.p = getelementptr inbounds [3 x i8], ptr @.str.2, i64 0, i64 0
  %r7 = ptrtoint ptr %r7.p to i64
  %r8 = call i64 @make_type(i64 %r6, i64 %r7)
  %r9 = load i64, ptr %slot.reg, align 8
  %r10.p = getelementptr inbounds [3 x i8], ptr @.str.2, i64 0, i64 0
  %r10 = ptrtoint ptr %r10.p to i64
  call i64 @nova_rt_index_set(i64 %r9, i64 %r10, i64 %r8)
  %r11.p = getelementptr inbounds [3 x i8], ptr @.str.0, i64 0, i64 0
  %r11 = ptrtoint ptr %r11.p to i64
  %r12.p = getelementptr inbounds [3 x i8], ptr @.str.3, i64 0, i64 0
  %r12 = ptrtoint ptr %r12.p to i64
  %r13 = call i64 @make_type(i64 %r11, i64 %r12)
  %r14 = load i64, ptr %slot.reg, align 8
  %r15.p = getelementptr inbounds [3 x i8], ptr @.str.3, i64 0, i64 0
  %r15 = ptrtoint ptr %r15.p to i64
  call i64 @nova_rt_index_set(i64 %r14, i64 %r15, i64 %r13)
  %r16.p = getelementptr inbounds [3 x i8], ptr @.str.0, i64 0, i64 0
  %r16 = ptrtoint ptr %r16.p to i64
  %r17.p = getelementptr inbounds [3 x i8], ptr @.str.4, i64 0, i64 0
  %r17 = ptrtoint ptr %r17.p to i64
  %r18 = call i64 @make_type(i64 %r16, i64 %r17)
  %r19 = load i64, ptr %slot.reg, align 8
  %r20.p = getelementptr inbounds [3 x i8], ptr @.str.4, i64 0, i64 0
  %r20 = ptrtoint ptr %r20.p to i64
  call i64 @nova_rt_index_set(i64 %r19, i64 %r20, i64 %r18)
  %r21.p = getelementptr inbounds [3 x i8], ptr @.str.0, i64 0, i64 0
  %r21 = ptrtoint ptr %r21.p to i64
  %r22.p = getelementptr inbounds [3 x i8], ptr @.str.5, i64 0, i64 0
  %r22 = ptrtoint ptr %r22.p to i64
  %r23 = call i64 @make_type(i64 %r21, i64 %r22)
  %r24 = load i64, ptr %slot.reg, align 8
  %r25.p = getelementptr inbounds [3 x i8], ptr @.str.5, i64 0, i64 0
  %r25 = ptrtoint ptr %r25.p to i64
  call i64 @nova_rt_index_set(i64 %r24, i64 %r25, i64 %r23)
  %r26.p = getelementptr inbounds [3 x i8], ptr @.str.0, i64 0, i64 0
  %r26 = ptrtoint ptr %r26.p to i64
  %r27.p = getelementptr inbounds [3 x i8], ptr @.str.6, i64 0, i64 0
  %r27 = ptrtoint ptr %r27.p to i64
  %r28 = call i64 @make_type(i64 %r26, i64 %r27)
  %r29 = load i64, ptr %slot.reg, align 8
  %r30.p = getelementptr inbounds [3 x i8], ptr @.str.6, i64 0, i64 0
  %r30 = ptrtoint ptr %r30.p to i64
  call i64 @nova_rt_index_set(i64 %r29, i64 %r30, i64 %r28)
  %r31.p = getelementptr inbounds [3 x i8], ptr @.str.0, i64 0, i64 0
  %r31 = ptrtoint ptr %r31.p to i64
  %r32.p = getelementptr inbounds [3 x i8], ptr @.str.7, i64 0, i64 0
  %r32 = ptrtoint ptr %r32.p to i64
  %r33 = call i64 @make_type(i64 %r31, i64 %r32)
  %r34 = load i64, ptr %slot.reg, align 8
  %r35.p = getelementptr inbounds [3 x i8], ptr @.str.7, i64 0, i64 0
  %r35 = ptrtoint ptr %r35.p to i64
  call i64 @nova_rt_index_set(i64 %r34, i64 %r35, i64 %r33)
  %r36.p = getelementptr inbounds [3 x i8], ptr @.str.0, i64 0, i64 0
  %r36 = ptrtoint ptr %r36.p to i64
  %r37.p = getelementptr inbounds [3 x i8], ptr @.str.8, i64 0, i64 0
  %r37 = ptrtoint ptr %r37.p to i64
  %r38 = call i64 @make_type(i64 %r36, i64 %r37)
  %r39 = load i64, ptr %slot.reg, align 8
  %r40.p = getelementptr inbounds [3 x i8], ptr @.str.8, i64 0, i64 0
  %r40 = ptrtoint ptr %r40.p to i64
  call i64 @nova_rt_index_set(i64 %r39, i64 %r40, i64 %r38)
  %r41.p = getelementptr inbounds [3 x i8], ptr @.str.0, i64 0, i64 0
  %r41 = ptrtoint ptr %r41.p to i64
  %r42.p = getelementptr inbounds [3 x i8], ptr @.str.9, i64 0, i64 0
  %r42 = ptrtoint ptr %r42.p to i64
  %r43 = call i64 @make_type(i64 %r41, i64 %r42)
  %r44 = load i64, ptr %slot.reg, align 8
  %r45.p = getelementptr inbounds [3 x i8], ptr @.str.9, i64 0, i64 0
  %r45 = ptrtoint ptr %r45.p to i64
  call i64 @nova_rt_index_set(i64 %r44, i64 %r45, i64 %r43)
  %r46.p = getelementptr inbounds [3 x i8], ptr @.str.0, i64 0, i64 0
  %r46 = ptrtoint ptr %r46.p to i64
  %r47.p = getelementptr inbounds [4 x i8], ptr @.str.10, i64 0, i64 0
  %r47 = ptrtoint ptr %r47.p to i64
  %r48 = call i64 @make_type(i64 %r46, i64 %r47)
  %r49 = load i64, ptr %slot.reg, align 8
  %r50.p = getelementptr inbounds [4 x i8], ptr @.str.10, i64 0, i64 0
  %r50 = ptrtoint ptr %r50.p to i64
  call i64 @nova_rt_index_set(i64 %r49, i64 %r50, i64 %r48)
  %r51.p = getelementptr inbounds [3 x i8], ptr @.str.0, i64 0, i64 0
  %r51 = ptrtoint ptr %r51.p to i64
  %r52.p = getelementptr inbounds [4 x i8], ptr @.str.11, i64 0, i64 0
  %r52 = ptrtoint ptr %r52.p to i64
  %r53 = call i64 @make_type(i64 %r51, i64 %r52)
  %r54 = load i64, ptr %slot.reg, align 8
  %r55.p = getelementptr inbounds [4 x i8], ptr @.str.11, i64 0, i64 0
  %r55 = ptrtoint ptr %r55.p to i64
  call i64 @nova_rt_index_set(i64 %r54, i64 %r55, i64 %r53)
  %r56.p = getelementptr inbounds [3 x i8], ptr @.str.0, i64 0, i64 0
  %r56 = ptrtoint ptr %r56.p to i64
  %r57.p = getelementptr inbounds [4 x i8], ptr @.str.12, i64 0, i64 0
  %r57 = ptrtoint ptr %r57.p to i64
  %r58 = call i64 @make_type(i64 %r56, i64 %r57)
  %r59 = load i64, ptr %slot.reg, align 8
  %r60.p = getelementptr inbounds [4 x i8], ptr @.str.12, i64 0, i64 0
  %r60 = ptrtoint ptr %r60.p to i64
  call i64 @nova_rt_index_set(i64 %r59, i64 %r60, i64 %r58)
  %r61.p = getelementptr inbounds [3 x i8], ptr @.str.0, i64 0, i64 0
  %r61 = ptrtoint ptr %r61.p to i64
  %r62.p = getelementptr inbounds [4 x i8], ptr @.str.13, i64 0, i64 0
  %r62 = ptrtoint ptr %r62.p to i64
  %r63 = call i64 @make_type(i64 %r61, i64 %r62)
  %r64 = load i64, ptr %slot.reg, align 8
  %r65.p = getelementptr inbounds [4 x i8], ptr @.str.13, i64 0, i64 0
  %r65 = ptrtoint ptr %r65.p to i64
  call i64 @nova_rt_index_set(i64 %r64, i64 %r65, i64 %r63)
  %r66.p = getelementptr inbounds [3 x i8], ptr @.str.0, i64 0, i64 0
  %r66 = ptrtoint ptr %r66.p to i64
  %r67.p = getelementptr inbounds [4 x i8], ptr @.str.14, i64 0, i64 0
  %r67 = ptrtoint ptr %r67.p to i64
  %r68 = call i64 @make_type(i64 %r66, i64 %r67)
  %r69 = load i64, ptr %slot.reg, align 8
  %r70.p = getelementptr inbounds [4 x i8], ptr @.str.14, i64 0, i64 0
  %r70 = ptrtoint ptr %r70.p to i64
  call i64 @nova_rt_index_set(i64 %r69, i64 %r70, i64 %r68)
  %r71.p = getelementptr inbounds [3 x i8], ptr @.str.0, i64 0, i64 0
  %r71 = ptrtoint ptr %r71.p to i64
  %r72.p = getelementptr inbounds [4 x i8], ptr @.str.15, i64 0, i64 0
  %r72 = ptrtoint ptr %r72.p to i64
  %r73 = call i64 @make_type(i64 %r71, i64 %r72)
  %r74 = load i64, ptr %slot.reg, align 8
  %r75.p = getelementptr inbounds [4 x i8], ptr @.str.15, i64 0, i64 0
  %r75 = ptrtoint ptr %r75.p to i64
  call i64 @nova_rt_index_set(i64 %r74, i64 %r75, i64 %r73)
  %r76.p = getelementptr inbounds [3 x i8], ptr @.str.0, i64 0, i64 0
  %r76 = ptrtoint ptr %r76.p to i64
  %r77.p = getelementptr inbounds [4 x i8], ptr @.str.16, i64 0, i64 0
  %r77 = ptrtoint ptr %r77.p to i64
  %r78 = call i64 @make_type(i64 %r76, i64 %r77)
  %r79 = load i64, ptr %slot.reg, align 8
  %r80.p = getelementptr inbounds [4 x i8], ptr @.str.16, i64 0, i64 0
  %r80 = ptrtoint ptr %r80.p to i64
  call i64 @nova_rt_index_set(i64 %r79, i64 %r80, i64 %r78)
  %r81.p = getelementptr inbounds [3 x i8], ptr @.str.0, i64 0, i64 0
  %r81 = ptrtoint ptr %r81.p to i64
  %r82.p = getelementptr inbounds [4 x i8], ptr @.str.17, i64 0, i64 0
  %r82 = ptrtoint ptr %r82.p to i64
  %r83 = call i64 @make_type(i64 %r81, i64 %r82)
  %r84 = load i64, ptr %slot.reg, align 8
  %r85.p = getelementptr inbounds [4 x i8], ptr @.str.17, i64 0, i64 0
  %r85 = ptrtoint ptr %r85.p to i64
  call i64 @nova_rt_index_set(i64 %r84, i64 %r85, i64 %r83)
  %r86.p = getelementptr inbounds [3 x i8], ptr @.str.0, i64 0, i64 0
  %r86 = ptrtoint ptr %r86.p to i64
  %r87.p = getelementptr inbounds [4 x i8], ptr @.str.18, i64 0, i64 0
  %r87 = ptrtoint ptr %r87.p to i64
  %r88 = call i64 @make_type(i64 %r86, i64 %r87)
  %r89 = load i64, ptr %slot.reg, align 8
  %r90.p = getelementptr inbounds [4 x i8], ptr @.str.18, i64 0, i64 0
  %r90 = ptrtoint ptr %r90.p to i64
  call i64 @nova_rt_index_set(i64 %r89, i64 %r90, i64 %r88)
  %r91.p = getelementptr inbounds [3 x i8], ptr @.str.0, i64 0, i64 0
  %r91 = ptrtoint ptr %r91.p to i64
  %r92.p = getelementptr inbounds [4 x i8], ptr @.str.19, i64 0, i64 0
  %r92 = ptrtoint ptr %r92.p to i64
  %r93 = call i64 @make_type(i64 %r91, i64 %r92)
  %r94 = load i64, ptr %slot.reg, align 8
  %r95.p = getelementptr inbounds [4 x i8], ptr @.str.19, i64 0, i64 0
  %r95 = ptrtoint ptr %r95.p to i64
  call i64 @nova_rt_index_set(i64 %r94, i64 %r95, i64 %r93)
  %r96.p = getelementptr inbounds [3 x i8], ptr @.str.0, i64 0, i64 0
  %r96 = ptrtoint ptr %r96.p to i64
  %r97.p = getelementptr inbounds [4 x i8], ptr @.str.20, i64 0, i64 0
  %r97 = ptrtoint ptr %r97.p to i64
  %r98 = call i64 @make_type(i64 %r96, i64 %r97)
  %r99 = load i64, ptr %slot.reg, align 8
  %r100.p = getelementptr inbounds [4 x i8], ptr @.str.20, i64 0, i64 0
  %r100 = ptrtoint ptr %r100.p to i64
  call i64 @nova_rt_index_set(i64 %r99, i64 %r100, i64 %r98)
  %r101.p = getelementptr inbounds [3 x i8], ptr @.str.0, i64 0, i64 0
  %r101 = ptrtoint ptr %r101.p to i64
  %r102.p = getelementptr inbounds [4 x i8], ptr @.str.21, i64 0, i64 0
  %r102 = ptrtoint ptr %r102.p to i64
  %r103 = call i64 @make_type(i64 %r101, i64 %r102)
  %r104 = load i64, ptr %slot.reg, align 8
  %r105.p = getelementptr inbounds [4 x i8], ptr @.str.21, i64 0, i64 0
  %r105 = ptrtoint ptr %r105.p to i64
  call i64 @nova_rt_index_set(i64 %r104, i64 %r105, i64 %r103)
  %r106.p = getelementptr inbounds [3 x i8], ptr @.str.0, i64 0, i64 0
  %r106 = ptrtoint ptr %r106.p to i64
  %r107.p = getelementptr inbounds [4 x i8], ptr @.str.22, i64 0, i64 0
  %r107 = ptrtoint ptr %r107.p to i64
  %r108 = call i64 @make_type(i64 %r106, i64 %r107)
  %r109 = load i64, ptr %slot.reg, align 8
  %r110.p = getelementptr inbounds [4 x i8], ptr @.str.22, i64 0, i64 0
  %r110 = ptrtoint ptr %r110.p to i64
  call i64 @nova_rt_index_set(i64 %r109, i64 %r110, i64 %r108)
  %r111.p = getelementptr inbounds [3 x i8], ptr @.str.0, i64 0, i64 0
  %r111 = ptrtoint ptr %r111.p to i64
  %r112.p = getelementptr inbounds [4 x i8], ptr @.str.23, i64 0, i64 0
  %r112 = ptrtoint ptr %r112.p to i64
  %r113 = call i64 @make_type(i64 %r111, i64 %r112)
  %r114 = load i64, ptr %slot.reg, align 8
  %r115.p = getelementptr inbounds [4 x i8], ptr @.str.23, i64 0, i64 0
  %r115 = ptrtoint ptr %r115.p to i64
  call i64 @nova_rt_index_set(i64 %r114, i64 %r115, i64 %r113)
  %r116.p = getelementptr inbounds [3 x i8], ptr @.str.0, i64 0, i64 0
  %r116 = ptrtoint ptr %r116.p to i64
  %r117.p = getelementptr inbounds [4 x i8], ptr @.str.24, i64 0, i64 0
  %r117 = ptrtoint ptr %r117.p to i64
  %r118 = call i64 @make_type(i64 %r116, i64 %r117)
  %r119 = load i64, ptr %slot.reg, align 8
  %r120.p = getelementptr inbounds [4 x i8], ptr @.str.24, i64 0, i64 0
  %r120 = ptrtoint ptr %r120.p to i64
  call i64 @nova_rt_index_set(i64 %r119, i64 %r120, i64 %r118)
  %r121.p = getelementptr inbounds [3 x i8], ptr @.str.0, i64 0, i64 0
  %r121 = ptrtoint ptr %r121.p to i64
  %r122.p = getelementptr inbounds [4 x i8], ptr @.str.25, i64 0, i64 0
  %r122 = ptrtoint ptr %r122.p to i64
  %r123 = call i64 @make_type(i64 %r121, i64 %r122)
  %r124 = load i64, ptr %slot.reg, align 8
  %r125.p = getelementptr inbounds [4 x i8], ptr @.str.25, i64 0, i64 0
  %r125 = ptrtoint ptr %r125.p to i64
  call i64 @nova_rt_index_set(i64 %r124, i64 %r125, i64 %r123)
  %r126.p = getelementptr inbounds [3 x i8], ptr @.str.0, i64 0, i64 0
  %r126 = ptrtoint ptr %r126.p to i64
  %r127.p = getelementptr inbounds [4 x i8], ptr @.str.26, i64 0, i64 0
  %r127 = ptrtoint ptr %r127.p to i64
  %r128 = call i64 @make_type(i64 %r126, i64 %r127)
  %r129 = load i64, ptr %slot.reg, align 8
  %r130.p = getelementptr inbounds [4 x i8], ptr @.str.26, i64 0, i64 0
  %r130 = ptrtoint ptr %r130.p to i64
  call i64 @nova_rt_index_set(i64 %r129, i64 %r130, i64 %r128)
  %r131.p = getelementptr inbounds [3 x i8], ptr @.str.0, i64 0, i64 0
  %r131 = ptrtoint ptr %r131.p to i64
  %r132.p = getelementptr inbounds [4 x i8], ptr @.str.27, i64 0, i64 0
  %r132 = ptrtoint ptr %r132.p to i64
  %r133 = call i64 @make_type(i64 %r131, i64 %r132)
  %r134 = load i64, ptr %slot.reg, align 8
  %r135.p = getelementptr inbounds [4 x i8], ptr @.str.27, i64 0, i64 0
  %r135 = ptrtoint ptr %r135.p to i64
  call i64 @nova_rt_index_set(i64 %r134, i64 %r135, i64 %r133)
  %r136.p = getelementptr inbounds [3 x i8], ptr @.str.0, i64 0, i64 0
  %r136 = ptrtoint ptr %r136.p to i64
  %r137.p = getelementptr inbounds [4 x i8], ptr @.str.28, i64 0, i64 0
  %r137 = ptrtoint ptr %r137.p to i64
  %r138 = call i64 @make_type(i64 %r136, i64 %r137)
  %r139 = load i64, ptr %slot.reg, align 8
  %r140.p = getelementptr inbounds [4 x i8], ptr @.str.28, i64 0, i64 0
  %r140 = ptrtoint ptr %r140.p to i64
  call i64 @nova_rt_index_set(i64 %r139, i64 %r140, i64 %r138)
  %r141.p = getelementptr inbounds [3 x i8], ptr @.str.0, i64 0, i64 0
  %r141 = ptrtoint ptr %r141.p to i64
  %r142.p = getelementptr inbounds [4 x i8], ptr @.str.29, i64 0, i64 0
  %r142 = ptrtoint ptr %r142.p to i64
  %r143 = call i64 @make_type(i64 %r141, i64 %r142)
  %r144 = load i64, ptr %slot.reg, align 8
  %r145.p = getelementptr inbounds [4 x i8], ptr @.str.29, i64 0, i64 0
  %r145 = ptrtoint ptr %r145.p to i64
  call i64 @nova_rt_index_set(i64 %r144, i64 %r145, i64 %r143)
  %r146.p = getelementptr inbounds [3 x i8], ptr @.str.0, i64 0, i64 0
  %r146 = ptrtoint ptr %r146.p to i64
  %r147.p = getelementptr inbounds [4 x i8], ptr @.str.30, i64 0, i64 0
  %r147 = ptrtoint ptr %r147.p to i64
  %r148 = call i64 @make_type(i64 %r146, i64 %r147)
  %r149 = load i64, ptr %slot.reg, align 8
  %r150.p = getelementptr inbounds [4 x i8], ptr @.str.30, i64 0, i64 0
  %r150 = ptrtoint ptr %r150.p to i64
  call i64 @nova_rt_index_set(i64 %r149, i64 %r150, i64 %r148)
  %r151.p = getelementptr inbounds [3 x i8], ptr @.str.0, i64 0, i64 0
  %r151 = ptrtoint ptr %r151.p to i64
  %r152.p = getelementptr inbounds [4 x i8], ptr @.str.31, i64 0, i64 0
  %r152 = ptrtoint ptr %r152.p to i64
  %r153 = call i64 @make_type(i64 %r151, i64 %r152)
  %r154 = load i64, ptr %slot.reg, align 8
  %r155.p = getelementptr inbounds [4 x i8], ptr @.str.31, i64 0, i64 0
  %r155 = ptrtoint ptr %r155.p to i64
  call i64 @nova_rt_index_set(i64 %r154, i64 %r155, i64 %r153)
  %r156.p = getelementptr inbounds [3 x i8], ptr @.str.0, i64 0, i64 0
  %r156 = ptrtoint ptr %r156.p to i64
  %r157.p = getelementptr inbounds [4 x i8], ptr @.str.32, i64 0, i64 0
  %r157 = ptrtoint ptr %r157.p to i64
  %r158 = call i64 @make_type(i64 %r156, i64 %r157)
  %r159 = load i64, ptr %slot.reg, align 8
  %r160.p = getelementptr inbounds [4 x i8], ptr @.str.32, i64 0, i64 0
  %r160 = ptrtoint ptr %r160.p to i64
  call i64 @nova_rt_index_set(i64 %r159, i64 %r160, i64 %r158)
  %r161.p = getelementptr inbounds [3 x i8], ptr @.str.0, i64 0, i64 0
  %r161 = ptrtoint ptr %r161.p to i64
  %r162.p = getelementptr inbounds [4 x i8], ptr @.str.33, i64 0, i64 0
  %r162 = ptrtoint ptr %r162.p to i64
  %r163 = call i64 @make_type(i64 %r161, i64 %r162)
  %r164 = load i64, ptr %slot.reg, align 8
  %r165.p = getelementptr inbounds [4 x i8], ptr @.str.33, i64 0, i64 0
  %r165 = ptrtoint ptr %r165.p to i64
  call i64 @nova_rt_index_set(i64 %r164, i64 %r165, i64 %r163)
  %r166.p = getelementptr inbounds [3 x i8], ptr @.str.0, i64 0, i64 0
  %r166 = ptrtoint ptr %r166.p to i64
  %r167.p = getelementptr inbounds [4 x i8], ptr @.str.34, i64 0, i64 0
  %r167 = ptrtoint ptr %r167.p to i64
  %r168 = call i64 @make_type(i64 %r166, i64 %r167)
  %r169 = load i64, ptr %slot.reg, align 8
  %r170.p = getelementptr inbounds [4 x i8], ptr @.str.34, i64 0, i64 0
  %r170 = ptrtoint ptr %r170.p to i64
  call i64 @nova_rt_index_set(i64 %r169, i64 %r170, i64 %r168)
  %r171.p = getelementptr inbounds [3 x i8], ptr @.str.0, i64 0, i64 0
  %r171 = ptrtoint ptr %r171.p to i64
  %r172.p = getelementptr inbounds [4 x i8], ptr @.str.35, i64 0, i64 0
  %r172 = ptrtoint ptr %r172.p to i64
  %r173 = call i64 @make_type(i64 %r171, i64 %r172)
  %r174 = load i64, ptr %slot.reg, align 8
  %r175.p = getelementptr inbounds [4 x i8], ptr @.str.35, i64 0, i64 0
  %r175 = ptrtoint ptr %r175.p to i64
  call i64 @nova_rt_index_set(i64 %r174, i64 %r175, i64 %r173)
  %r176.p = getelementptr inbounds [3 x i8], ptr @.str.0, i64 0, i64 0
  %r176 = ptrtoint ptr %r176.p to i64
  %r177.p = getelementptr inbounds [4 x i8], ptr @.str.36, i64 0, i64 0
  %r177 = ptrtoint ptr %r177.p to i64
  %r178 = call i64 @make_type(i64 %r176, i64 %r177)
  %r179 = load i64, ptr %slot.reg, align 8
  %r180.p = getelementptr inbounds [4 x i8], ptr @.str.36, i64 0, i64 0
  %r180 = ptrtoint ptr %r180.p to i64
  call i64 @nova_rt_index_set(i64 %r179, i64 %r180, i64 %r178)
  %r181.p = getelementptr inbounds [3 x i8], ptr @.str.0, i64 0, i64 0
  %r181 = ptrtoint ptr %r181.p to i64
  %r182.p = getelementptr inbounds [4 x i8], ptr @.str.37, i64 0, i64 0
  %r182 = ptrtoint ptr %r182.p to i64
  %r183 = call i64 @make_type(i64 %r181, i64 %r182)
  %r184 = load i64, ptr %slot.reg, align 8
  %r185.p = getelementptr inbounds [4 x i8], ptr @.str.37, i64 0, i64 0
  %r185 = ptrtoint ptr %r185.p to i64
  call i64 @nova_rt_index_set(i64 %r184, i64 %r185, i64 %r183)
  %r186.p = getelementptr inbounds [3 x i8], ptr @.str.0, i64 0, i64 0
  %r186 = ptrtoint ptr %r186.p to i64
  %r187.p = getelementptr inbounds [4 x i8], ptr @.str.38, i64 0, i64 0
  %r187 = ptrtoint ptr %r187.p to i64
  %r188 = call i64 @make_type(i64 %r186, i64 %r187)
  %r189 = load i64, ptr %slot.reg, align 8
  %r190.p = getelementptr inbounds [4 x i8], ptr @.str.38, i64 0, i64 0
  %r190 = ptrtoint ptr %r190.p to i64
  call i64 @nova_rt_index_set(i64 %r189, i64 %r190, i64 %r188)
  %r191.p = getelementptr inbounds [3 x i8], ptr @.str.0, i64 0, i64 0
  %r191 = ptrtoint ptr %r191.p to i64
  %r192.p = getelementptr inbounds [4 x i8], ptr @.str.39, i64 0, i64 0
  %r192 = ptrtoint ptr %r192.p to i64
  %r193 = call i64 @make_type(i64 %r191, i64 %r192)
  %r194 = load i64, ptr %slot.reg, align 8
  %r195.p = getelementptr inbounds [4 x i8], ptr @.str.39, i64 0, i64 0
  %r195 = ptrtoint ptr %r195.p to i64
  call i64 @nova_rt_index_set(i64 %r194, i64 %r195, i64 %r193)
  %r196.p = getelementptr inbounds [3 x i8], ptr @.str.0, i64 0, i64 0
  %r196 = ptrtoint ptr %r196.p to i64
  %r197.p = getelementptr inbounds [4 x i8], ptr @.str.40, i64 0, i64 0
  %r197 = ptrtoint ptr %r197.p to i64
  %r198 = call i64 @make_type(i64 %r196, i64 %r197)
  %r199 = load i64, ptr %slot.reg, align 8
  %r200.p = getelementptr inbounds [4 x i8], ptr @.str.40, i64 0, i64 0
  %r200 = ptrtoint ptr %r200.p to i64
  call i64 @nova_rt_index_set(i64 %r199, i64 %r200, i64 %r198)
  %r201.p = getelementptr inbounds [3 x i8], ptr @.str.0, i64 0, i64 0
  %r201 = ptrtoint ptr %r201.p to i64
  %r202.p = getelementptr inbounds [4 x i8], ptr @.str.41, i64 0, i64 0
  %r202 = ptrtoint ptr %r202.p to i64
  %r203 = call i64 @make_type(i64 %r201, i64 %r202)
  %r204 = load i64, ptr %slot.reg, align 8
  %r205.p = getelementptr inbounds [4 x i8], ptr @.str.41, i64 0, i64 0
  %r205 = ptrtoint ptr %r205.p to i64
  call i64 @nova_rt_index_set(i64 %r204, i64 %r205, i64 %r203)
  %r206.p = getelementptr inbounds [3 x i8], ptr @.str.0, i64 0, i64 0
  %r206 = ptrtoint ptr %r206.p to i64
  %r207.p = getelementptr inbounds [4 x i8], ptr @.str.42, i64 0, i64 0
  %r207 = ptrtoint ptr %r207.p to i64
  %r208 = call i64 @make_type(i64 %r206, i64 %r207)
  %r209 = load i64, ptr %slot.reg, align 8
  %r210.p = getelementptr inbounds [4 x i8], ptr @.str.42, i64 0, i64 0
  %r210 = ptrtoint ptr %r210.p to i64
  call i64 @nova_rt_index_set(i64 %r209, i64 %r210, i64 %r208)
  %r211.p = getelementptr inbounds [3 x i8], ptr @.str.0, i64 0, i64 0
  %r211 = ptrtoint ptr %r211.p to i64
  %r212.p = getelementptr inbounds [4 x i8], ptr @.str.43, i64 0, i64 0
  %r212 = ptrtoint ptr %r212.p to i64
  %r213 = call i64 @make_type(i64 %r211, i64 %r212)
  %r214 = load i64, ptr %slot.reg, align 8
  %r215.p = getelementptr inbounds [4 x i8], ptr @.str.43, i64 0, i64 0
  %r215 = ptrtoint ptr %r215.p to i64
  call i64 @nova_rt_index_set(i64 %r214, i64 %r215, i64 %r213)
  %r216.p = getelementptr inbounds [3 x i8], ptr @.str.0, i64 0, i64 0
  %r216 = ptrtoint ptr %r216.p to i64
  %r217.p = getelementptr inbounds [4 x i8], ptr @.str.44, i64 0, i64 0
  %r217 = ptrtoint ptr %r217.p to i64
  %r218 = call i64 @make_type(i64 %r216, i64 %r217)
  %r219 = load i64, ptr %slot.reg, align 8
  %r220.p = getelementptr inbounds [4 x i8], ptr @.str.44, i64 0, i64 0
  %r220 = ptrtoint ptr %r220.p to i64
  call i64 @nova_rt_index_set(i64 %r219, i64 %r220, i64 %r218)
  %r221.p = getelementptr inbounds [3 x i8], ptr @.str.0, i64 0, i64 0
  %r221 = ptrtoint ptr %r221.p to i64
  %r222.p = getelementptr inbounds [4 x i8], ptr @.str.45, i64 0, i64 0
  %r222 = ptrtoint ptr %r222.p to i64
  %r223 = call i64 @make_type(i64 %r221, i64 %r222)
  %r224 = load i64, ptr %slot.reg, align 8
  %r225.p = getelementptr inbounds [4 x i8], ptr @.str.45, i64 0, i64 0
  %r225 = ptrtoint ptr %r225.p to i64
  call i64 @nova_rt_index_set(i64 %r224, i64 %r225, i64 %r223)
  %r226.p = getelementptr inbounds [3 x i8], ptr @.str.0, i64 0, i64 0
  %r226 = ptrtoint ptr %r226.p to i64
  %r227.p = getelementptr inbounds [4 x i8], ptr @.str.46, i64 0, i64 0
  %r227 = ptrtoint ptr %r227.p to i64
  %r228 = call i64 @make_type(i64 %r226, i64 %r227)
  %r229 = load i64, ptr %slot.reg, align 8
  %r230.p = getelementptr inbounds [4 x i8], ptr @.str.46, i64 0, i64 0
  %r230 = ptrtoint ptr %r230.p to i64
  call i64 @nova_rt_index_set(i64 %r229, i64 %r230, i64 %r228)
  %r231.p = getelementptr inbounds [3 x i8], ptr @.str.0, i64 0, i64 0
  %r231 = ptrtoint ptr %r231.p to i64
  %r232.p = getelementptr inbounds [4 x i8], ptr @.str.47, i64 0, i64 0
  %r232 = ptrtoint ptr %r232.p to i64
  %r233 = call i64 @make_type(i64 %r231, i64 %r232)
  %r234 = load i64, ptr %slot.reg, align 8
  %r235.p = getelementptr inbounds [4 x i8], ptr @.str.47, i64 0, i64 0
  %r235 = ptrtoint ptr %r235.p to i64
  call i64 @nova_rt_index_set(i64 %r234, i64 %r235, i64 %r233)
  %r236.p = getelementptr inbounds [3 x i8], ptr @.str.0, i64 0, i64 0
  %r236 = ptrtoint ptr %r236.p to i64
  %r237.p = getelementptr inbounds [4 x i8], ptr @.str.48, i64 0, i64 0
  %r237 = ptrtoint ptr %r237.p to i64
  %r238 = call i64 @make_type(i64 %r236, i64 %r237)
  %r239 = load i64, ptr %slot.reg, align 8
  %r240.p = getelementptr inbounds [4 x i8], ptr @.str.48, i64 0, i64 0
  %r240 = ptrtoint ptr %r240.p to i64
  call i64 @nova_rt_index_set(i64 %r239, i64 %r240, i64 %r238)
  %r241.p = getelementptr inbounds [3 x i8], ptr @.str.0, i64 0, i64 0
  %r241 = ptrtoint ptr %r241.p to i64
  %r242.p = getelementptr inbounds [4 x i8], ptr @.str.49, i64 0, i64 0
  %r242 = ptrtoint ptr %r242.p to i64
  %r243 = call i64 @make_type(i64 %r241, i64 %r242)
  %r244 = load i64, ptr %slot.reg, align 8
  %r245.p = getelementptr inbounds [4 x i8], ptr @.str.49, i64 0, i64 0
  %r245 = ptrtoint ptr %r245.p to i64
  call i64 @nova_rt_index_set(i64 %r244, i64 %r245, i64 %r243)
  %r246.p = getelementptr inbounds [3 x i8], ptr @.str.0, i64 0, i64 0
  %r246 = ptrtoint ptr %r246.p to i64
  %r247.p = getelementptr inbounds [4 x i8], ptr @.str.50, i64 0, i64 0
  %r247 = ptrtoint ptr %r247.p to i64
  %r248 = call i64 @make_type(i64 %r246, i64 %r247)
  %r249 = load i64, ptr %slot.reg, align 8
  %r250.p = getelementptr inbounds [4 x i8], ptr @.str.50, i64 0, i64 0
  %r250 = ptrtoint ptr %r250.p to i64
  call i64 @nova_rt_index_set(i64 %r249, i64 %r250, i64 %r248)
  %r251.p = getelementptr inbounds [3 x i8], ptr @.str.0, i64 0, i64 0
  %r251 = ptrtoint ptr %r251.p to i64
  %r252.p = getelementptr inbounds [4 x i8], ptr @.str.51, i64 0, i64 0
  %r252 = ptrtoint ptr %r252.p to i64
  %r253 = call i64 @make_type(i64 %r251, i64 %r252)
  %r254 = load i64, ptr %slot.reg, align 8
  %r255.p = getelementptr inbounds [4 x i8], ptr @.str.51, i64 0, i64 0
  %r255 = ptrtoint ptr %r255.p to i64
  call i64 @nova_rt_index_set(i64 %r254, i64 %r255, i64 %r253)
  %r256.p = getelementptr inbounds [3 x i8], ptr @.str.0, i64 0, i64 0
  %r256 = ptrtoint ptr %r256.p to i64
  %r257.p = getelementptr inbounds [4 x i8], ptr @.str.52, i64 0, i64 0
  %r257 = ptrtoint ptr %r257.p to i64
  %r258 = call i64 @make_type(i64 %r256, i64 %r257)
  %r259 = load i64, ptr %slot.reg, align 8
  %r260.p = getelementptr inbounds [4 x i8], ptr @.str.52, i64 0, i64 0
  %r260 = ptrtoint ptr %r260.p to i64
  call i64 @nova_rt_index_set(i64 %r259, i64 %r260, i64 %r258)
  %r261.p = getelementptr inbounds [3 x i8], ptr @.str.0, i64 0, i64 0
  %r261 = ptrtoint ptr %r261.p to i64
  %r262.p = getelementptr inbounds [4 x i8], ptr @.str.53, i64 0, i64 0
  %r262 = ptrtoint ptr %r262.p to i64
  %r263 = call i64 @make_type(i64 %r261, i64 %r262)
  %r264 = load i64, ptr %slot.reg, align 8
  %r265.p = getelementptr inbounds [4 x i8], ptr @.str.53, i64 0, i64 0
  %r265 = ptrtoint ptr %r265.p to i64
  call i64 @nova_rt_index_set(i64 %r264, i64 %r265, i64 %r263)
  %r266.p = getelementptr inbounds [3 x i8], ptr @.str.0, i64 0, i64 0
  %r266 = ptrtoint ptr %r266.p to i64
  %r267.p = getelementptr inbounds [4 x i8], ptr @.str.54, i64 0, i64 0
  %r267 = ptrtoint ptr %r267.p to i64
  %r268 = call i64 @make_type(i64 %r266, i64 %r267)
  %r269 = load i64, ptr %slot.reg, align 8
  %r270.p = getelementptr inbounds [4 x i8], ptr @.str.54, i64 0, i64 0
  %r270 = ptrtoint ptr %r270.p to i64
  call i64 @nova_rt_index_set(i64 %r269, i64 %r270, i64 %r268)
  %r271.p = getelementptr inbounds [3 x i8], ptr @.str.0, i64 0, i64 0
  %r271 = ptrtoint ptr %r271.p to i64
  %r272.p = getelementptr inbounds [4 x i8], ptr @.str.55, i64 0, i64 0
  %r272 = ptrtoint ptr %r272.p to i64
  %r273 = call i64 @make_type(i64 %r271, i64 %r272)
  %r274 = load i64, ptr %slot.reg, align 8
  %r275.p = getelementptr inbounds [4 x i8], ptr @.str.55, i64 0, i64 0
  %r275 = ptrtoint ptr %r275.p to i64
  call i64 @nova_rt_index_set(i64 %r274, i64 %r275, i64 %r273)
  %r276.p = getelementptr inbounds [3 x i8], ptr @.str.0, i64 0, i64 0
  %r276 = ptrtoint ptr %r276.p to i64
  %r277.p = getelementptr inbounds [4 x i8], ptr @.str.56, i64 0, i64 0
  %r277 = ptrtoint ptr %r277.p to i64
  %r278 = call i64 @make_type(i64 %r276, i64 %r277)
  %r279 = load i64, ptr %slot.reg, align 8
  %r280.p = getelementptr inbounds [4 x i8], ptr @.str.56, i64 0, i64 0
  %r280 = ptrtoint ptr %r280.p to i64
  call i64 @nova_rt_index_set(i64 %r279, i64 %r280, i64 %r278)
  %r281.p = getelementptr inbounds [3 x i8], ptr @.str.0, i64 0, i64 0
  %r281 = ptrtoint ptr %r281.p to i64
  %r282.p = getelementptr inbounds [4 x i8], ptr @.str.57, i64 0, i64 0
  %r282 = ptrtoint ptr %r282.p to i64
  %r283 = call i64 @make_type(i64 %r281, i64 %r282)
  %r284 = load i64, ptr %slot.reg, align 8
  %r285.p = getelementptr inbounds [4 x i8], ptr @.str.57, i64 0, i64 0
  %r285 = ptrtoint ptr %r285.p to i64
  call i64 @nova_rt_index_set(i64 %r284, i64 %r285, i64 %r283)
  %r286.p = getelementptr inbounds [3 x i8], ptr @.str.0, i64 0, i64 0
  %r286 = ptrtoint ptr %r286.p to i64
  %r287.p = getelementptr inbounds [4 x i8], ptr @.str.58, i64 0, i64 0
  %r287 = ptrtoint ptr %r287.p to i64
  %r288 = call i64 @make_type(i64 %r286, i64 %r287)
  %r289 = load i64, ptr %slot.reg, align 8
  %r290.p = getelementptr inbounds [4 x i8], ptr @.str.58, i64 0, i64 0
  %r290 = ptrtoint ptr %r290.p to i64
  call i64 @nova_rt_index_set(i64 %r289, i64 %r290, i64 %r288)
  %r291.p = getelementptr inbounds [3 x i8], ptr @.str.0, i64 0, i64 0
  %r291 = ptrtoint ptr %r291.p to i64
  %r292.p = getelementptr inbounds [4 x i8], ptr @.str.59, i64 0, i64 0
  %r292 = ptrtoint ptr %r292.p to i64
  %r293 = call i64 @make_type(i64 %r291, i64 %r292)
  %r294 = load i64, ptr %slot.reg, align 8
  %r295.p = getelementptr inbounds [4 x i8], ptr @.str.59, i64 0, i64 0
  %r295 = ptrtoint ptr %r295.p to i64
  call i64 @nova_rt_index_set(i64 %r294, i64 %r295, i64 %r293)
  %r296.p = getelementptr inbounds [3 x i8], ptr @.str.0, i64 0, i64 0
  %r296 = ptrtoint ptr %r296.p to i64
  %r297.p = getelementptr inbounds [4 x i8], ptr @.str.60, i64 0, i64 0
  %r297 = ptrtoint ptr %r297.p to i64
  %r298 = call i64 @make_type(i64 %r296, i64 %r297)
  %r299 = load i64, ptr %slot.reg, align 8
  %r300.p = getelementptr inbounds [4 x i8], ptr @.str.60, i64 0, i64 0
  %r300 = ptrtoint ptr %r300.p to i64
  call i64 @nova_rt_index_set(i64 %r299, i64 %r300, i64 %r298)
  %r301.p = getelementptr inbounds [3 x i8], ptr @.str.0, i64 0, i64 0
  %r301 = ptrtoint ptr %r301.p to i64
  %r302.p = getelementptr inbounds [4 x i8], ptr @.str.61, i64 0, i64 0
  %r302 = ptrtoint ptr %r302.p to i64
  %r303 = call i64 @make_type(i64 %r301, i64 %r302)
  %r304 = load i64, ptr %slot.reg, align 8
  %r305.p = getelementptr inbounds [4 x i8], ptr @.str.61, i64 0, i64 0
  %r305 = ptrtoint ptr %r305.p to i64
  call i64 @nova_rt_index_set(i64 %r304, i64 %r305, i64 %r303)
  %r306.p = getelementptr inbounds [3 x i8], ptr @.str.0, i64 0, i64 0
  %r306 = ptrtoint ptr %r306.p to i64
  %r307.p = getelementptr inbounds [4 x i8], ptr @.str.62, i64 0, i64 0
  %r307 = ptrtoint ptr %r307.p to i64
  %r308 = call i64 @make_type(i64 %r306, i64 %r307)
  %r309 = load i64, ptr %slot.reg, align 8
  %r310.p = getelementptr inbounds [4 x i8], ptr @.str.62, i64 0, i64 0
  %r310 = ptrtoint ptr %r310.p to i64
  call i64 @nova_rt_index_set(i64 %r309, i64 %r310, i64 %r308)
  %r311.p = getelementptr inbounds [3 x i8], ptr @.str.0, i64 0, i64 0
  %r311 = ptrtoint ptr %r311.p to i64
  %r312.p = getelementptr inbounds [4 x i8], ptr @.str.63, i64 0, i64 0
  %r312 = ptrtoint ptr %r312.p to i64
  %r313 = call i64 @make_type(i64 %r311, i64 %r312)
  %r314 = load i64, ptr %slot.reg, align 8
  %r315.p = getelementptr inbounds [4 x i8], ptr @.str.63, i64 0, i64 0
  %r315 = ptrtoint ptr %r315.p to i64
  call i64 @nova_rt_index_set(i64 %r314, i64 %r315, i64 %r313)
  %r316.p = getelementptr inbounds [3 x i8], ptr @.str.0, i64 0, i64 0
  %r316 = ptrtoint ptr %r316.p to i64
  %r317.p = getelementptr inbounds [4 x i8], ptr @.str.64, i64 0, i64 0
  %r317 = ptrtoint ptr %r317.p to i64
  %r318 = call i64 @make_type(i64 %r316, i64 %r317)
  %r319 = load i64, ptr %slot.reg, align 8
  %r320.p = getelementptr inbounds [4 x i8], ptr @.str.64, i64 0, i64 0
  %r320 = ptrtoint ptr %r320.p to i64
  call i64 @nova_rt_index_set(i64 %r319, i64 %r320, i64 %r318)
  %r321.p = getelementptr inbounds [3 x i8], ptr @.str.0, i64 0, i64 0
  %r321 = ptrtoint ptr %r321.p to i64
  %r322.p = getelementptr inbounds [4 x i8], ptr @.str.65, i64 0, i64 0
  %r322 = ptrtoint ptr %r322.p to i64
  %r323 = call i64 @make_type(i64 %r321, i64 %r322)
  %r324 = load i64, ptr %slot.reg, align 8
  %r325.p = getelementptr inbounds [4 x i8], ptr @.str.65, i64 0, i64 0
  %r325 = ptrtoint ptr %r325.p to i64
  call i64 @nova_rt_index_set(i64 %r324, i64 %r325, i64 %r323)
  %r326.p = getelementptr inbounds [3 x i8], ptr @.str.0, i64 0, i64 0
  %r326 = ptrtoint ptr %r326.p to i64
  %r327.p = getelementptr inbounds [4 x i8], ptr @.str.66, i64 0, i64 0
  %r327 = ptrtoint ptr %r327.p to i64
  %r328 = call i64 @make_type(i64 %r326, i64 %r327)
  %r329 = load i64, ptr %slot.reg, align 8
  %r330.p = getelementptr inbounds [4 x i8], ptr @.str.66, i64 0, i64 0
  %r330 = ptrtoint ptr %r330.p to i64
  call i64 @nova_rt_index_set(i64 %r329, i64 %r330, i64 %r328)
  %r331.p = getelementptr inbounds [3 x i8], ptr @.str.0, i64 0, i64 0
  %r331 = ptrtoint ptr %r331.p to i64
  %r332.p = getelementptr inbounds [4 x i8], ptr @.str.67, i64 0, i64 0
  %r332 = ptrtoint ptr %r332.p to i64
  %r333 = call i64 @make_type(i64 %r331, i64 %r332)
  %r334 = load i64, ptr %slot.reg, align 8
  %r335.p = getelementptr inbounds [4 x i8], ptr @.str.67, i64 0, i64 0
  %r335 = ptrtoint ptr %r335.p to i64
  call i64 @nova_rt_index_set(i64 %r334, i64 %r335, i64 %r333)
  %r336.p = getelementptr inbounds [3 x i8], ptr @.str.0, i64 0, i64 0
  %r336 = ptrtoint ptr %r336.p to i64
  %r337.p = getelementptr inbounds [4 x i8], ptr @.str.68, i64 0, i64 0
  %r337 = ptrtoint ptr %r337.p to i64
  %r338 = call i64 @make_type(i64 %r336, i64 %r337)
  %r339 = load i64, ptr %slot.reg, align 8
  %r340.p = getelementptr inbounds [4 x i8], ptr @.str.68, i64 0, i64 0
  %r340 = ptrtoint ptr %r340.p to i64
  call i64 @nova_rt_index_set(i64 %r339, i64 %r340, i64 %r338)
  %r341.p = getelementptr inbounds [3 x i8], ptr @.str.0, i64 0, i64 0
  %r341 = ptrtoint ptr %r341.p to i64
  %r342.p = getelementptr inbounds [4 x i8], ptr @.str.69, i64 0, i64 0
  %r342 = ptrtoint ptr %r342.p to i64
  %r343 = call i64 @make_type(i64 %r341, i64 %r342)
  %r344 = load i64, ptr %slot.reg, align 8
  %r345.p = getelementptr inbounds [4 x i8], ptr @.str.69, i64 0, i64 0
  %r345 = ptrtoint ptr %r345.p to i64
  call i64 @nova_rt_index_set(i64 %r344, i64 %r345, i64 %r343)
  %r346.p = getelementptr inbounds [3 x i8], ptr @.str.0, i64 0, i64 0
  %r346 = ptrtoint ptr %r346.p to i64
  %r347.p = getelementptr inbounds [4 x i8], ptr @.str.70, i64 0, i64 0
  %r347 = ptrtoint ptr %r347.p to i64
  %r348 = call i64 @make_type(i64 %r346, i64 %r347)
  %r349 = load i64, ptr %slot.reg, align 8
  %r350.p = getelementptr inbounds [4 x i8], ptr @.str.70, i64 0, i64 0
  %r350 = ptrtoint ptr %r350.p to i64
  call i64 @nova_rt_index_set(i64 %r349, i64 %r350, i64 %r348)
  %r351.p = getelementptr inbounds [3 x i8], ptr @.str.0, i64 0, i64 0
  %r351 = ptrtoint ptr %r351.p to i64
  %r352.p = getelementptr inbounds [4 x i8], ptr @.str.71, i64 0, i64 0
  %r352 = ptrtoint ptr %r352.p to i64
  %r353 = call i64 @make_type(i64 %r351, i64 %r352)
  %r354 = load i64, ptr %slot.reg, align 8
  %r355.p = getelementptr inbounds [4 x i8], ptr @.str.71, i64 0, i64 0
  %r355 = ptrtoint ptr %r355.p to i64
  call i64 @nova_rt_index_set(i64 %r354, i64 %r355, i64 %r353)
  %r356.p = getelementptr inbounds [3 x i8], ptr @.str.0, i64 0, i64 0
  %r356 = ptrtoint ptr %r356.p to i64
  %r357.p = getelementptr inbounds [4 x i8], ptr @.str.72, i64 0, i64 0
  %r357 = ptrtoint ptr %r357.p to i64
  %r358 = call i64 @make_type(i64 %r356, i64 %r357)
  %r359 = load i64, ptr %slot.reg, align 8
  %r360.p = getelementptr inbounds [4 x i8], ptr @.str.72, i64 0, i64 0
  %r360 = ptrtoint ptr %r360.p to i64
  call i64 @nova_rt_index_set(i64 %r359, i64 %r360, i64 %r358)
  %r361.p = getelementptr inbounds [3 x i8], ptr @.str.0, i64 0, i64 0
  %r361 = ptrtoint ptr %r361.p to i64
  %r362.p = getelementptr inbounds [4 x i8], ptr @.str.73, i64 0, i64 0
  %r362 = ptrtoint ptr %r362.p to i64
  %r363 = call i64 @make_type(i64 %r361, i64 %r362)
  %r364 = load i64, ptr %slot.reg, align 8
  %r365.p = getelementptr inbounds [4 x i8], ptr @.str.73, i64 0, i64 0
  %r365 = ptrtoint ptr %r365.p to i64
  call i64 @nova_rt_index_set(i64 %r364, i64 %r365, i64 %r363)
  %r366.p = getelementptr inbounds [3 x i8], ptr @.str.0, i64 0, i64 0
  %r366 = ptrtoint ptr %r366.p to i64
  %r367.p = getelementptr inbounds [4 x i8], ptr @.str.74, i64 0, i64 0
  %r367 = ptrtoint ptr %r367.p to i64
  %r368 = call i64 @make_type(i64 %r366, i64 %r367)
  %r369 = load i64, ptr %slot.reg, align 8
  %r370.p = getelementptr inbounds [4 x i8], ptr @.str.74, i64 0, i64 0
  %r370 = ptrtoint ptr %r370.p to i64
  call i64 @nova_rt_index_set(i64 %r369, i64 %r370, i64 %r368)
  %r371.p = getelementptr inbounds [3 x i8], ptr @.str.0, i64 0, i64 0
  %r371 = ptrtoint ptr %r371.p to i64
  %r372.p = getelementptr inbounds [4 x i8], ptr @.str.75, i64 0, i64 0
  %r372 = ptrtoint ptr %r372.p to i64
  %r373 = call i64 @make_type(i64 %r371, i64 %r372)
  %r374 = load i64, ptr %slot.reg, align 8
  %r375.p = getelementptr inbounds [4 x i8], ptr @.str.75, i64 0, i64 0
  %r375 = ptrtoint ptr %r375.p to i64
  call i64 @nova_rt_index_set(i64 %r374, i64 %r375, i64 %r373)
  %r376.p = getelementptr inbounds [3 x i8], ptr @.str.0, i64 0, i64 0
  %r376 = ptrtoint ptr %r376.p to i64
  %r377.p = getelementptr inbounds [4 x i8], ptr @.str.76, i64 0, i64 0
  %r377 = ptrtoint ptr %r377.p to i64
  %r378 = call i64 @make_type(i64 %r376, i64 %r377)
  %r379 = load i64, ptr %slot.reg, align 8
  %r380.p = getelementptr inbounds [4 x i8], ptr @.str.76, i64 0, i64 0
  %r380 = ptrtoint ptr %r380.p to i64
  call i64 @nova_rt_index_set(i64 %r379, i64 %r380, i64 %r378)
  %r381.p = getelementptr inbounds [3 x i8], ptr @.str.0, i64 0, i64 0
  %r381 = ptrtoint ptr %r381.p to i64
  %r382.p = getelementptr inbounds [4 x i8], ptr @.str.77, i64 0, i64 0
  %r382 = ptrtoint ptr %r382.p to i64
  %r383 = call i64 @make_type(i64 %r381, i64 %r382)
  %r384 = load i64, ptr %slot.reg, align 8
  %r385.p = getelementptr inbounds [4 x i8], ptr @.str.77, i64 0, i64 0
  %r385 = ptrtoint ptr %r385.p to i64
  call i64 @nova_rt_index_set(i64 %r384, i64 %r385, i64 %r383)
  %r386.p = getelementptr inbounds [3 x i8], ptr @.str.0, i64 0, i64 0
  %r386 = ptrtoint ptr %r386.p to i64
  %r387.p = getelementptr inbounds [4 x i8], ptr @.str.78, i64 0, i64 0
  %r387 = ptrtoint ptr %r387.p to i64
  %r388 = call i64 @make_type(i64 %r386, i64 %r387)
  %r389 = load i64, ptr %slot.reg, align 8
  %r390.p = getelementptr inbounds [4 x i8], ptr @.str.78, i64 0, i64 0
  %r390 = ptrtoint ptr %r390.p to i64
  call i64 @nova_rt_index_set(i64 %r389, i64 %r390, i64 %r388)
  %r391.p = getelementptr inbounds [3 x i8], ptr @.str.0, i64 0, i64 0
  %r391 = ptrtoint ptr %r391.p to i64
  %r392.p = getelementptr inbounds [4 x i8], ptr @.str.79, i64 0, i64 0
  %r392 = ptrtoint ptr %r392.p to i64
  %r393 = call i64 @make_type(i64 %r391, i64 %r392)
  %r394 = load i64, ptr %slot.reg, align 8
  %r395.p = getelementptr inbounds [4 x i8], ptr @.str.79, i64 0, i64 0
  %r395 = ptrtoint ptr %r395.p to i64
  call i64 @nova_rt_index_set(i64 %r394, i64 %r395, i64 %r393)
  %r396.p = getelementptr inbounds [3 x i8], ptr @.str.0, i64 0, i64 0
  %r396 = ptrtoint ptr %r396.p to i64
  %r397.p = getelementptr inbounds [4 x i8], ptr @.str.80, i64 0, i64 0
  %r397 = ptrtoint ptr %r397.p to i64
  %r398 = call i64 @make_type(i64 %r396, i64 %r397)
  %r399 = load i64, ptr %slot.reg, align 8
  %r400.p = getelementptr inbounds [4 x i8], ptr @.str.80, i64 0, i64 0
  %r400 = ptrtoint ptr %r400.p to i64
  call i64 @nova_rt_index_set(i64 %r399, i64 %r400, i64 %r398)
  %r401 = load i64, ptr %slot.reg, align 8
  ret i64 %r401
}

define i64 @nova_main() nounwind {
entry:
  %slot.r = alloca i64, align 8
  store i64 0, ptr %slot.r, align 8
  %r0 = call i64 @build_registry()
  store i64 %r0, ptr %slot.r, align 8
  %r1 = load i64, ptr %slot.r, align 8
  %r2 = call i64 @nova_rt_dict_keys(i64 %r1)
  %r3 = call i64 @nova_rt_len_any(i64 %r2)
  %r4 = call i64 @nova_rt_print_any(i64 %r3)
  ret i64 0
}

define i32 @main(i32 %argc, ptr %argv) nounwind {
entry:
  %argc64 = sext i32 %argc to i64
  %argv64 = ptrtoint ptr %argv to i64
  call void @nova_rt_init_args(i64 %argc64, i64 %argv64)
  call i64 @nova_main()
  call void @nova_rt_cleanup()
  ret i32 0
}

; String constants
@.str.0 = private unnamed_addr constant [3 x i8] c"fn\00"
@.str.1 = private unnamed_addr constant [3 x i8] c"a1\00"
@.str.2 = private unnamed_addr constant [3 x i8] c"a2\00"
@.str.3 = private unnamed_addr constant [3 x i8] c"a3\00"
@.str.4 = private unnamed_addr constant [3 x i8] c"a4\00"
@.str.5 = private unnamed_addr constant [3 x i8] c"a5\00"
@.str.6 = private unnamed_addr constant [3 x i8] c"a6\00"
@.str.7 = private unnamed_addr constant [3 x i8] c"a7\00"
@.str.8 = private unnamed_addr constant [3 x i8] c"a8\00"
@.str.9 = private unnamed_addr constant [3 x i8] c"a9\00"
@.str.10 = private unnamed_addr constant [4 x i8] c"a10\00"
@.str.11 = private unnamed_addr constant [4 x i8] c"a11\00"
@.str.12 = private unnamed_addr constant [4 x i8] c"a12\00"
@.str.13 = private unnamed_addr constant [4 x i8] c"a13\00"
@.str.14 = private unnamed_addr constant [4 x i8] c"a14\00"
@.str.15 = private unnamed_addr constant [4 x i8] c"a15\00"
@.str.16 = private unnamed_addr constant [4 x i8] c"a16\00"
@.str.17 = private unnamed_addr constant [4 x i8] c"a17\00"
@.str.18 = private unnamed_addr constant [4 x i8] c"a18\00"
@.str.19 = private unnamed_addr constant [4 x i8] c"a19\00"
@.str.20 = private unnamed_addr constant [4 x i8] c"a20\00"
@.str.21 = private unnamed_addr constant [4 x i8] c"a21\00"
@.str.22 = private unnamed_addr constant [4 x i8] c"a22\00"
@.str.23 = private unnamed_addr constant [4 x i8] c"a23\00"
@.str.24 = private unnamed_addr constant [4 x i8] c"a24\00"
@.str.25 = private unnamed_addr constant [4 x i8] c"a25\00"
@.str.26 = private unnamed_addr constant [4 x i8] c"a26\00"
@.str.27 = private unnamed_addr constant [4 x i8] c"a27\00"
@.str.28 = private unnamed_addr constant [4 x i8] c"a28\00"
@.str.29 = private unnamed_addr constant [4 x i8] c"a29\00"
@.str.30 = private unnamed_addr constant [4 x i8] c"a30\00"
@.str.31 = private unnamed_addr constant [4 x i8] c"a31\00"
@.str.32 = private unnamed_addr constant [4 x i8] c"a32\00"
@.str.33 = private unnamed_addr constant [4 x i8] c"a33\00"
@.str.34 = private unnamed_addr constant [4 x i8] c"a34\00"
@.str.35 = private unnamed_addr constant [4 x i8] c"a35\00"
@.str.36 = private unnamed_addr constant [4 x i8] c"a36\00"
@.str.37 = private unnamed_addr constant [4 x i8] c"a37\00"
@.str.38 = private unnamed_addr constant [4 x i8] c"a38\00"
@.str.39 = private unnamed_addr constant [4 x i8] c"a39\00"
@.str.40 = private unnamed_addr constant [4 x i8] c"a40\00"
@.str.41 = private unnamed_addr constant [4 x i8] c"a41\00"
@.str.42 = private unnamed_addr constant [4 x i8] c"a42\00"
@.str.43 = private unnamed_addr constant [4 x i8] c"a43\00"
@.str.44 = private unnamed_addr constant [4 x i8] c"a44\00"
@.str.45 = private unnamed_addr constant [4 x i8] c"a45\00"
@.str.46 = private unnamed_addr constant [4 x i8] c"a46\00"
@.str.47 = private unnamed_addr constant [4 x i8] c"a47\00"
@.str.48 = private unnamed_addr constant [4 x i8] c"a48\00"
@.str.49 = private unnamed_addr constant [4 x i8] c"a49\00"
@.str.50 = private unnamed_addr constant [4 x i8] c"a50\00"
@.str.51 = private unnamed_addr constant [4 x i8] c"a51\00"
@.str.52 = private unnamed_addr constant [4 x i8] c"a52\00"
@.str.53 = private unnamed_addr constant [4 x i8] c"a53\00"
@.str.54 = private unnamed_addr constant [4 x i8] c"a54\00"
@.str.55 = private unnamed_addr constant [4 x i8] c"a55\00"
@.str.56 = private unnamed_addr constant [4 x i8] c"a56\00"
@.str.57 = private unnamed_addr constant [4 x i8] c"a57\00"
@.str.58 = private unnamed_addr constant [4 x i8] c"a58\00"
@.str.59 = private unnamed_addr constant [4 x i8] c"a59\00"
@.str.60 = private unnamed_addr constant [4 x i8] c"a60\00"
@.str.61 = private unnamed_addr constant [4 x i8] c"a61\00"
@.str.62 = private unnamed_addr constant [4 x i8] c"a62\00"
@.str.63 = private unnamed_addr constant [4 x i8] c"a63\00"
@.str.64 = private unnamed_addr constant [4 x i8] c"a64\00"
@.str.65 = private unnamed_addr constant [4 x i8] c"a65\00"
@.str.66 = private unnamed_addr constant [4 x i8] c"a66\00"
@.str.67 = private unnamed_addr constant [4 x i8] c"a67\00"
@.str.68 = private unnamed_addr constant [4 x i8] c"a68\00"
@.str.69 = private unnamed_addr constant [4 x i8] c"a69\00"
@.str.70 = private unnamed_addr constant [4 x i8] c"a70\00"
@.str.71 = private unnamed_addr constant [4 x i8] c"a71\00"
@.str.72 = private unnamed_addr constant [4 x i8] c"a72\00"
@.str.73 = private unnamed_addr constant [4 x i8] c"a73\00"
@.str.74 = private unnamed_addr constant [4 x i8] c"a74\00"
@.str.75 = private unnamed_addr constant [4 x i8] c"a75\00"
@.str.76 = private unnamed_addr constant [4 x i8] c"a76\00"
@.str.77 = private unnamed_addr constant [4 x i8] c"a77\00"
@.str.78 = private unnamed_addr constant [4 x i8] c"a78\00"
@.str.79 = private unnamed_addr constant [4 x i8] c"a79\00"
@.str.80 = private unnamed_addr constant [4 x i8] c"a80\00"
