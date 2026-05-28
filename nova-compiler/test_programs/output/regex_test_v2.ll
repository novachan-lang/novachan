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
  %slot.regex_find = alloca i64, align 8
  store i64 0, ptr %slot.regex_find, align 8
  %slot.result = alloca i64, align 8
  store i64 0, ptr %slot.result, align 8
  %slot.empty = alloca i64, align 8
  store i64 0, ptr %slot.empty, align 8
  %slot.regex_replace = alloca i64, align 8
  store i64 0, ptr %slot.regex_replace, align 8
  %slot.replaced = alloca i64, align 8
  store i64 0, ptr %slot.replaced, align 8
  %slot.replaced2 = alloca i64, align 8
  store i64 0, ptr %slot.replaced2, align 8
  %slot.regex_split = alloca i64, align 8
  store i64 0, ptr %slot.regex_split, align 8
  %slot.parts = alloca i64, align 8
  store i64 0, ptr %slot.parts, align 8
  %slot.parts2 = alloca i64, align 8
  store i64 0, ptr %slot.parts2, align 8
  %r0.p = getelementptr inbounds [9 x i8], ptr @.str.0, i64 0, i64 0
  %r0 = ptrtoint ptr %r0.p to i64
  %r1.p = getelementptr inbounds [4 x i8], ptr @.str.1, i64 0, i64 0
  %r1 = ptrtoint ptr %r1.p to i64
  %r3.p = getelementptr inbounds [17 x i8], ptr @.str.2, i64 0, i64 0
  %r3 = ptrtoint ptr %r3.p to i64
  %r4 = call i64 @nova_rt_assert(i64 %r2, i64 %r3)
  %r5.p = getelementptr inbounds [12 x i8], ptr @.str.3, i64 0, i64 0
  %r5 = ptrtoint ptr %r5.p to i64
  %r6.p = getelementptr inbounds [6 x i8], ptr @.str.4, i64 0, i64 0
  %r6 = ptrtoint ptr %r6.p to i64
  %r8.p = getelementptr inbounds [14 x i8], ptr @.str.5, i64 0, i64 0
  %r8 = ptrtoint ptr %r8.p to i64
  %r9 = call i64 @nova_rt_assert(i64 %r7, i64 %r8)
  %r10.p = getelementptr inbounds [6 x i8], ptr @.str.6, i64 0, i64 0
  %r10 = ptrtoint ptr %r10.p to i64
  %r11.p = getelementptr inbounds [4 x i8], ptr @.str.1, i64 0, i64 0
  %r11 = ptrtoint ptr %r11.p to i64
  %r13.cmp = icmp eq i64 %r12, 0
  %r13 = zext i1 %r13.cmp to i64
  %r14.p = getelementptr inbounds [10 x i8], ptr @.str.7, i64 0, i64 0
  %r14 = ptrtoint ptr %r14.p to i64
  %r15 = call i64 @nova_rt_assert(i64 %r13, i64 %r14)
  %r16.p = getelementptr inbounds [4 x i8], ptr @.str.8, i64 0, i64 0
  %r16 = ptrtoint ptr %r16.p to i64
  %r17.p = getelementptr inbounds [8 x i8], ptr @.str.9, i64 0, i64 0
  %r17 = ptrtoint ptr %r17.p to i64
  %r19.p = getelementptr inbounds [11 x i8], ptr @.str.10, i64 0, i64 0
  %r19 = ptrtoint ptr %r19.p to i64
  %r20 = call i64 @nova_rt_assert(i64 %r18, i64 %r19)
  %r21.p = getelementptr inbounds [5 x i8], ptr @.str.11, i64 0, i64 0
  %r21 = ptrtoint ptr %r21.p to i64
  %r22.p = getelementptr inbounds [6 x i8], ptr @.str.12, i64 0, i64 0
  %r22 = ptrtoint ptr %r22.p to i64
  %r24.p = getelementptr inbounds [20 x i8], ptr @.str.13, i64 0, i64 0
  %r24 = ptrtoint ptr %r24.p to i64
  %r25 = call i64 @nova_rt_assert(i64 %r23, i64 %r24)
  %r26.p = getelementptr inbounds [6 x i8], ptr @.str.6, i64 0, i64 0
  %r26 = ptrtoint ptr %r26.p to i64
  %r27.p = getelementptr inbounds [6 x i8], ptr @.str.12, i64 0, i64 0
  %r27 = ptrtoint ptr %r27.p to i64
  %r29.cmp = icmp eq i64 %r28, 0
  %r29 = zext i1 %r29.cmp to i64
  %r30.p = getelementptr inbounds [15 x i8], ptr @.str.14, i64 0, i64 0
  %r30 = ptrtoint ptr %r30.p to i64
  %r31 = call i64 @nova_rt_assert(i64 %r29, i64 %r30)
  %r32.p = getelementptr inbounds [4 x i8], ptr @.str.15, i64 0, i64 0
  %r32 = ptrtoint ptr %r32.p to i64
  %r33.p = getelementptr inbounds [4 x i8], ptr @.str.16, i64 0, i64 0
  %r33 = ptrtoint ptr %r33.p to i64
  %r35.p = getelementptr inbounds [13 x i8], ptr @.str.17, i64 0, i64 0
  %r35 = ptrtoint ptr %r35.p to i64
  %r36 = call i64 @nova_rt_assert(i64 %r34, i64 %r35)
  %r37.p = getelementptr inbounds [4 x i8], ptr @.str.18, i64 0, i64 0
  %r37 = ptrtoint ptr %r37.p to i64
  %r38.p = getelementptr inbounds [4 x i8], ptr @.str.16, i64 0, i64 0
  %r38 = ptrtoint ptr %r38.p to i64
  %r40.p = getelementptr inbounds [16 x i8], ptr @.str.19, i64 0, i64 0
  %r40 = ptrtoint ptr %r40.p to i64
  %r41 = call i64 @nova_rt_assert(i64 %r39, i64 %r40)
  %r42.p = getelementptr inbounds [3 x i8], ptr @.str.20, i64 0, i64 0
  %r42 = ptrtoint ptr %r42.p to i64
  %r43.p = getelementptr inbounds [5 x i8], ptr @.str.21, i64 0, i64 0
  %r43 = ptrtoint ptr %r43.p to i64
  %r45.p = getelementptr inbounds [11 x i8], ptr @.str.22, i64 0, i64 0
  %r45 = ptrtoint ptr %r45.p to i64
  %r46 = call i64 @nova_rt_assert(i64 %r44, i64 %r45)
  %r47.p = getelementptr inbounds [4 x i8], ptr @.str.15, i64 0, i64 0
  %r47 = ptrtoint ptr %r47.p to i64
  %r48.p = getelementptr inbounds [5 x i8], ptr @.str.21, i64 0, i64 0
  %r48 = ptrtoint ptr %r48.p to i64
  %r50.p = getelementptr inbounds [19 x i8], ptr @.str.23, i64 0, i64 0
  %r50 = ptrtoint ptr %r50.p to i64
  %r51 = call i64 @nova_rt_assert(i64 %r49, i64 %r50)
  %r52.p = getelementptr inbounds [6 x i8], ptr @.str.24, i64 0, i64 0
  %r52 = ptrtoint ptr %r52.p to i64
  %r53.p = getelementptr inbounds [5 x i8], ptr @.str.25, i64 0, i64 0
  %r53 = ptrtoint ptr %r53.p to i64
  %r55.p = getelementptr inbounds [12 x i8], ptr @.str.26, i64 0, i64 0
  %r55 = ptrtoint ptr %r55.p to i64
  %r56 = call i64 @nova_rt_assert(i64 %r54, i64 %r55)
  %r57.p = getelementptr inbounds [3 x i8], ptr @.str.27, i64 0, i64 0
  %r57 = ptrtoint ptr %r57.p to i64
  %r58.p = getelementptr inbounds [5 x i8], ptr @.str.28, i64 0, i64 0
  %r58 = ptrtoint ptr %r58.p to i64
  %r60.p = getelementptr inbounds [13 x i8], ptr @.str.29, i64 0, i64 0
  %r60 = ptrtoint ptr %r60.p to i64
  %r61 = call i64 @nova_rt_assert(i64 %r59, i64 %r60)
  %r62.p = getelementptr inbounds [12 x i8], ptr @.str.3, i64 0, i64 0
  %r62 = ptrtoint ptr %r62.p to i64
  %r63.p = getelementptr inbounds [9 x i8], ptr @.str.30, i64 0, i64 0
  %r63 = ptrtoint ptr %r63.p to i64
  %r65.p = getelementptr inbounds [16 x i8], ptr @.str.31, i64 0, i64 0
  %r65 = ptrtoint ptr %r65.p to i64
  %r66 = call i64 @nova_rt_assert(i64 %r64, i64 %r65)
  %r67.p = getelementptr inbounds [6 x i8], ptr @.str.6, i64 0, i64 0
  %r67 = ptrtoint ptr %r67.p to i64
  %r68.p = getelementptr inbounds [3 x i8], ptr @.str.32, i64 0, i64 0
  %r68 = ptrtoint ptr %r68.p to i64
  %r70.cmp = icmp eq i64 %r69, 0
  %r70 = zext i1 %r70.cmp to i64
  %r71.p = getelementptr inbounds [14 x i8], ptr @.str.33, i64 0, i64 0
  %r71 = ptrtoint ptr %r71.p to i64
  %r72 = call i64 @nova_rt_assert(i64 %r70, i64 %r71)
  %r73.p = getelementptr inbounds [20 x i8], ptr @.str.34, i64 0, i64 0
  %r73 = ptrtoint ptr %r73.p to i64
  %r74.p = getelementptr inbounds [4 x i8], ptr @.str.1, i64 0, i64 0
  %r74 = ptrtoint ptr %r74.p to i64
  %r76 = load i64, ptr %slot.regex_find, align 8
  %r75.rec = inttoptr i64 %r76 to ptr
  %r75.fnraw = load i64, ptr %r75.rec, align 8
  %r75.fnptr = inttoptr i64 %r75.fnraw to ptr
  %r75 = call i64 %r75.fnptr(i64 %r76, i64 %r73, i64 %r74)
  store i64 %r75, ptr %slot.result, align 8
  %r77 = load i64, ptr %slot.result, align 8
  %r78.p = getelementptr inbounds [3 x i8], ptr @.str.35, i64 0, i64 0
  %r78 = ptrtoint ptr %r78.p to i64
  %r79.p0 = inttoptr i64 %r77 to ptr
  %r79.p1 = inttoptr i64 %r78 to ptr
  %r79.sc = call i32 @strcmp(ptr %r79.p0, ptr %r79.p1)
  %r79.cmp = icmp eq i32 %r79.sc, 0
  %r79 = zext i1 %r79.cmp to i64
  %r80.p = getelementptr inbounds [12 x i8], ptr @.str.36, i64 0, i64 0
  %r80 = ptrtoint ptr %r80.p to i64
  %r81 = call i64 @nova_rt_assert(i64 %r79, i64 %r80)
  %r82.p = getelementptr inbounds [16 x i8], ptr @.str.37, i64 0, i64 0
  %r82 = ptrtoint ptr %r82.p to i64
  %r83.p = getelementptr inbounds [4 x i8], ptr @.str.1, i64 0, i64 0
  %r83 = ptrtoint ptr %r83.p to i64
  %r85 = load i64, ptr %slot.regex_find, align 8
  %r84.rec = inttoptr i64 %r85 to ptr
  %r84.fnraw = load i64, ptr %r84.rec, align 8
  %r84.fnptr = inttoptr i64 %r84.fnraw to ptr
  %r84 = call i64 %r84.fnptr(i64 %r85, i64 %r82, i64 %r83)
  store i64 %r84, ptr %slot.empty, align 8
  %r86 = load i64, ptr %slot.empty, align 8
  %r87.p = getelementptr inbounds [1 x i8], ptr @.str.38, i64 0, i64 0
  %r87 = ptrtoint ptr %r87.p to i64
  %r88.p0 = inttoptr i64 %r86 to ptr
  %r88.p1 = inttoptr i64 %r87 to ptr
  %r88.sc = call i32 @strcmp(ptr %r88.p0, ptr %r88.p1)
  %r88.cmp = icmp eq i32 %r88.sc, 0
  %r88 = zext i1 %r88.cmp to i64
  %r89.p = getelementptr inbounds [28 x i8], ptr @.str.39, i64 0, i64 0
  %r89 = ptrtoint ptr %r89.p to i64
  %r90 = call i64 @nova_rt_assert(i64 %r88, i64 %r89)
  %r91.p = getelementptr inbounds [12 x i8], ptr @.str.3, i64 0, i64 0
  %r91 = ptrtoint ptr %r91.p to i64
  %r92.p = getelementptr inbounds [6 x i8], ptr @.str.4, i64 0, i64 0
  %r92 = ptrtoint ptr %r92.p to i64
  %r93.p = getelementptr inbounds [5 x i8], ptr @.str.40, i64 0, i64 0
  %r93 = ptrtoint ptr %r93.p to i64
  %r95 = load i64, ptr %slot.regex_replace, align 8
  %r94.rec = inttoptr i64 %r95 to ptr
  %r94.fnraw = load i64, ptr %r94.rec, align 8
  %r94.fnptr = inttoptr i64 %r94.fnraw to ptr
  %r94 = call i64 %r94.fnptr(i64 %r95, i64 %r91, i64 %r92, i64 %r93)
  store i64 %r94, ptr %slot.replaced, align 8
  %r96 = load i64, ptr %slot.replaced, align 8
  %r97.p = getelementptr inbounds [11 x i8], ptr @.str.41, i64 0, i64 0
  %r97 = ptrtoint ptr %r97.p to i64
  %r98.p0 = inttoptr i64 %r96 to ptr
  %r98.p1 = inttoptr i64 %r97 to ptr
  %r98.sc = call i32 @strcmp(ptr %r98.p0, ptr %r98.p1)
  %r98.cmp = icmp eq i32 %r98.sc, 0
  %r98 = zext i1 %r98.cmp to i64
  %r99.p = getelementptr inbounds [15 x i8], ptr @.str.42, i64 0, i64 0
  %r99 = ptrtoint ptr %r99.p to i64
  %r100 = call i64 @nova_rt_assert(i64 %r98, i64 %r99)
  %r101.p = getelementptr inbounds [10 x i8], ptr @.str.43, i64 0, i64 0
  %r101 = ptrtoint ptr %r101.p to i64
  %r102.p = getelementptr inbounds [4 x i8], ptr @.str.1, i64 0, i64 0
  %r102 = ptrtoint ptr %r102.p to i64
  %r103.p = getelementptr inbounds [4 x i8], ptr @.str.44, i64 0, i64 0
  %r103 = ptrtoint ptr %r103.p to i64
  %r105 = load i64, ptr %slot.regex_replace, align 8
  %r104.rec = inttoptr i64 %r105 to ptr
  %r104.fnraw = load i64, ptr %r104.rec, align 8
  %r104.fnptr = inttoptr i64 %r104.fnraw to ptr
  %r104 = call i64 %r104.fnptr(i64 %r105, i64 %r101, i64 %r102, i64 %r103)
  store i64 %r104, ptr %slot.replaced2, align 8
  %r106 = load i64, ptr %slot.replaced2, align 8
  %r107.p = getelementptr inbounds [10 x i8], ptr @.str.45, i64 0, i64 0
  %r107 = ptrtoint ptr %r107.p to i64
  %r108.p0 = inttoptr i64 %r106 to ptr
  %r108.p1 = inttoptr i64 %r107 to ptr
  %r108.sc = call i32 @strcmp(ptr %r108.p0, ptr %r108.p1)
  %r108.cmp = icmp eq i32 %r108.sc, 0
  %r108 = zext i1 %r108.cmp to i64
  %r109.p = getelementptr inbounds [21 x i8], ptr @.str.46, i64 0, i64 0
  %r109 = ptrtoint ptr %r109.p to i64
  %r110 = call i64 @nova_rt_assert(i64 %r108, i64 %r109)
  %r111.p = getelementptr inbounds [14 x i8], ptr @.str.47, i64 0, i64 0
  %r111 = ptrtoint ptr %r111.p to i64
  %r112.p = getelementptr inbounds [2 x i8], ptr @.str.48, i64 0, i64 0
  %r112 = ptrtoint ptr %r112.p to i64
  %r114 = load i64, ptr %slot.regex_split, align 8
  %r113.rec = inttoptr i64 %r114 to ptr
  %r113.fnraw = load i64, ptr %r113.rec, align 8
  %r113.fnptr = inttoptr i64 %r113.fnraw to ptr
  %r113 = call i64 %r113.fnptr(i64 %r114, i64 %r111, i64 %r112)
  store i64 %r113, ptr %slot.parts, align 8
  %r115 = load i64, ptr %slot.parts, align 8
  %r116 = call i64 @nova_rt_len_any(i64 %r115)
  %r117 = add i64 3, 0
  %r118.cmp = icmp eq i64 %r116, %r117
  %r118 = zext i1 %r118.cmp to i64
  %r119.p = getelementptr inbounds [12 x i8], ptr @.str.49, i64 0, i64 0
  %r119 = ptrtoint ptr %r119.p to i64
  %r120 = call i64 @nova_rt_assert(i64 %r118, i64 %r119)
  %r121 = load i64, ptr %slot.parts, align 8
  %r122 = add i64 0, 0
  %r123 = call i64 @nova_rt_index_get(i64 %r121, i64 %r122)
  %r124.p = getelementptr inbounds [4 x i8], ptr @.str.50, i64 0, i64 0
  %r124 = ptrtoint ptr %r124.p to i64
  %r125.p0 = inttoptr i64 %r123 to ptr
  %r125.p1 = inttoptr i64 %r124 to ptr
  %r125.sc = call i32 @strcmp(ptr %r125.p0, ptr %r125.p1)
  %r125.cmp = icmp eq i32 %r125.sc, 0
  %r125 = zext i1 %r125.cmp to i64
  %r126.p = getelementptr inbounds [12 x i8], ptr @.str.51, i64 0, i64 0
  %r126 = ptrtoint ptr %r126.p to i64
  %r127 = call i64 @nova_rt_assert(i64 %r125, i64 %r126)
  %r128 = load i64, ptr %slot.parts, align 8
  %r129 = add i64 1, 0
  %r130 = call i64 @nova_rt_index_get(i64 %r128, i64 %r129)
  %r131.p = getelementptr inbounds [4 x i8], ptr @.str.52, i64 0, i64 0
  %r131 = ptrtoint ptr %r131.p to i64
  %r132.p0 = inttoptr i64 %r130 to ptr
  %r132.p1 = inttoptr i64 %r131 to ptr
  %r132.sc = call i32 @strcmp(ptr %r132.p0, ptr %r132.p1)
  %r132.cmp = icmp eq i32 %r132.sc, 0
  %r132 = zext i1 %r132.cmp to i64
  %r133.p = getelementptr inbounds [13 x i8], ptr @.str.53, i64 0, i64 0
  %r133 = ptrtoint ptr %r133.p to i64
  %r134 = call i64 @nova_rt_assert(i64 %r132, i64 %r133)
  %r135 = load i64, ptr %slot.parts, align 8
  %r136 = add i64 2, 0
  %r137 = call i64 @nova_rt_index_get(i64 %r135, i64 %r136)
  %r138.p = getelementptr inbounds [6 x i8], ptr @.str.54, i64 0, i64 0
  %r138 = ptrtoint ptr %r138.p to i64
  %r139.p0 = inttoptr i64 %r137 to ptr
  %r139.p1 = inttoptr i64 %r138 to ptr
  %r139.sc = call i32 @strcmp(ptr %r139.p0, ptr %r139.p1)
  %r139.cmp = icmp eq i32 %r139.sc, 0
  %r139 = zext i1 %r139.cmp to i64
  %r140.p = getelementptr inbounds [12 x i8], ptr @.str.55, i64 0, i64 0
  %r140 = ptrtoint ptr %r140.p to i64
  %r141 = call i64 @nova_rt_assert(i64 %r139, i64 %r140)
  %r142.p = getelementptr inbounds [8 x i8], ptr @.str.56, i64 0, i64 0
  %r142 = ptrtoint ptr %r142.p to i64
  %r143.p = getelementptr inbounds [3 x i8], ptr @.str.57, i64 0, i64 0
  %r143 = ptrtoint ptr %r143.p to i64
  %r145 = load i64, ptr %slot.regex_split, align 8
  %r144.rec = inttoptr i64 %r145 to ptr
  %r144.fnraw = load i64, ptr %r144.rec, align 8
  %r144.fnptr = inttoptr i64 %r144.fnraw to ptr
  %r144 = call i64 %r144.fnptr(i64 %r145, i64 %r142, i64 %r143)
  store i64 %r144, ptr %slot.parts2, align 8
  %r146 = load i64, ptr %slot.parts2, align 8
  %r147 = call i64 @nova_rt_len_any(i64 %r146)
  %r148 = add i64 4, 0
  %r149.cmp = icmp eq i64 %r147, %r148
  %r149 = zext i1 %r149.cmp to i64
  %r150.p = getelementptr inbounds [18 x i8], ptr @.str.58, i64 0, i64 0
  %r150 = ptrtoint ptr %r150.p to i64
  %r151 = call i64 @nova_rt_assert(i64 %r149, i64 %r150)
  %r152 = load i64, ptr %slot.parts2, align 8
  %r153 = add i64 0, 0
  %r154 = call i64 @nova_rt_index_get(i64 %r152, i64 %r153)
  %r155.p = getelementptr inbounds [2 x i8], ptr @.str.59, i64 0, i64 0
  %r155 = ptrtoint ptr %r155.p to i64
  %r156.p0 = inttoptr i64 %r154 to ptr
  %r156.p1 = inttoptr i64 %r155 to ptr
  %r156.sc = call i32 @strcmp(ptr %r156.p0, ptr %r156.p1)
  %r156.cmp = icmp eq i32 %r156.sc, 0
  %r156 = zext i1 %r156.cmp to i64
  %r157.p = getelementptr inbounds [14 x i8], ptr @.str.60, i64 0, i64 0
  %r157 = ptrtoint ptr %r157.p to i64
  %r158 = call i64 @nova_rt_assert(i64 %r156, i64 %r157)
  %r159 = load i64, ptr %slot.parts2, align 8
  %r160 = add i64 1, 0
  %r161 = call i64 @nova_rt_index_get(i64 %r159, i64 %r160)
  %r162.p = getelementptr inbounds [2 x i8], ptr @.str.61, i64 0, i64 0
  %r162 = ptrtoint ptr %r162.p to i64
  %r163.p0 = inttoptr i64 %r161 to ptr
  %r163.p1 = inttoptr i64 %r162 to ptr
  %r163.sc = call i32 @strcmp(ptr %r163.p0, ptr %r163.p1)
  %r163.cmp = icmp eq i32 %r163.sc, 0
  %r163 = zext i1 %r163.cmp to i64
  %r164.p = getelementptr inbounds [14 x i8], ptr @.str.62, i64 0, i64 0
  %r164 = ptrtoint ptr %r164.p to i64
  %r165 = call i64 @nova_rt_assert(i64 %r163, i64 %r164)
  %r166 = load i64, ptr %slot.parts2, align 8
  %r167 = add i64 2, 0
  %r168 = call i64 @nova_rt_index_get(i64 %r166, i64 %r167)
  %r169.p = getelementptr inbounds [2 x i8], ptr @.str.63, i64 0, i64 0
  %r169 = ptrtoint ptr %r169.p to i64
  %r170.p0 = inttoptr i64 %r168 to ptr
  %r170.p1 = inttoptr i64 %r169 to ptr
  %r170.sc = call i32 @strcmp(ptr %r170.p0, ptr %r170.p1)
  %r170.cmp = icmp eq i32 %r170.sc, 0
  %r170 = zext i1 %r170.cmp to i64
  %r171.p = getelementptr inbounds [14 x i8], ptr @.str.64, i64 0, i64 0
  %r171 = ptrtoint ptr %r171.p to i64
  %r172 = call i64 @nova_rt_assert(i64 %r170, i64 %r171)
  %r173 = load i64, ptr %slot.parts2, align 8
  %r174 = add i64 3, 0
  %r175 = call i64 @nova_rt_index_get(i64 %r173, i64 %r174)
  %r176.p = getelementptr inbounds [2 x i8], ptr @.str.65, i64 0, i64 0
  %r176 = ptrtoint ptr %r176.p to i64
  %r177.p0 = inttoptr i64 %r175 to ptr
  %r177.p1 = inttoptr i64 %r176 to ptr
  %r177.sc = call i32 @strcmp(ptr %r177.p0, ptr %r177.p1)
  %r177.cmp = icmp eq i32 %r177.sc, 0
  %r177 = zext i1 %r177.cmp to i64
  %r178.p = getelementptr inbounds [14 x i8], ptr @.str.66, i64 0, i64 0
  %r178 = ptrtoint ptr %r178.p to i64
  %r179 = call i64 @nova_rt_assert(i64 %r177, i64 %r178)
  %r180.p = getelementptr inbounds [18 x i8], ptr @.str.67, i64 0, i64 0
  %r180 = ptrtoint ptr %r180.p to i64
  %r181 = call i64 @nova_rt_print_any(i64 %r180)
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
@.str.0 = private unnamed_addr constant [9 x i8] c"hello123\00"
@.str.1 = private unnamed_addr constant [4 x i8] c"\\d+\00"
@.str.2 = private unnamed_addr constant [17 x i8] c"digits in string\00"
@.str.3 = private unnamed_addr constant [12 x i8] c"hello world\00"
@.str.4 = private unnamed_addr constant [6 x i8] c"world\00"
@.str.5 = private unnamed_addr constant [14 x i8] c"literal match\00"
@.str.6 = private unnamed_addr constant [6 x i8] c"hello\00"
@.str.7 = private unnamed_addr constant [10 x i8] c"no digits\00"
@.str.8 = private unnamed_addr constant [4 x i8] c"cat\00"
@.str.9 = private unnamed_addr constant [8 x i8] c"[abc]at\00"
@.str.10 = private unnamed_addr constant [11 x i8] c"char class\00"
@.str.11 = private unnamed_addr constant [5 x i8] c"2024\00"
@.str.12 = private unnamed_addr constant [6 x i8] c"^\\d+$\00"
@.str.13 = private unnamed_addr constant [20 x i8] c"all digits anchored\00"
@.str.14 = private unnamed_addr constant [15 x i8] c"not all digits\00"
@.str.15 = private unnamed_addr constant [4 x i8] c"abc\00"
@.str.16 = private unnamed_addr constant [4 x i8] c"a.c\00"
@.str.17 = private unnamed_addr constant [13 x i8] c"dot wildcard\00"
@.str.18 = private unnamed_addr constant [4 x i8] c"aXc\00"
@.str.19 = private unnamed_addr constant [16 x i8] c"dot matches any\00"
@.str.20 = private unnamed_addr constant [3 x i8] c"ac\00"
@.str.21 = private unnamed_addr constant [5 x i8] c"ab?c\00"
@.str.22 = private unnamed_addr constant [11 x i8] c"optional b\00"
@.str.23 = private unnamed_addr constant [19 x i8] c"optional b present\00"
@.str.24 = private unnamed_addr constant [6 x i8] c"aXXXb\00"
@.str.25 = private unnamed_addr constant [5 x i8] c"a.+b\00"
@.str.26 = private unnamed_addr constant [12 x i8] c"one or more\00"
@.str.27 = private unnamed_addr constant [3 x i8] c"ab\00"
@.str.28 = private unnamed_addr constant [5 x i8] c"a.*b\00"
@.str.29 = private unnamed_addr constant [13 x i8] c"zero or more\00"
@.str.30 = private unnamed_addr constant [9 x i8] c"\\w+\\s\\w+\00"
@.str.31 = private unnamed_addr constant [16 x i8] c"word space word\00"
@.str.32 = private unnamed_addr constant [3 x i8] c"\\s\00"
@.str.33 = private unnamed_addr constant [14 x i8] c"no whitespace\00"
@.str.34 = private unnamed_addr constant [20 x i8] c"price is 42 dollars\00"
@.str.35 = private unnamed_addr constant [3 x i8] c"42\00"
@.str.36 = private unnamed_addr constant [12 x i8] c"find digits\00"
@.str.37 = private unnamed_addr constant [16 x i8] c"no numbers here\00"
@.str.38 = private unnamed_addr constant [1 x i8] c"\00"
@.str.39 = private unnamed_addr constant [28 x i8] c"find no match returns empty\00"
@.str.40 = private unnamed_addr constant [5 x i8] c"NOVA\00"
@.str.41 = private unnamed_addr constant [11 x i8] c"hello NOVA\00"
@.str.42 = private unnamed_addr constant [15 x i8] c"simple replace\00"
@.str.43 = private unnamed_addr constant [10 x i8] c"foo123bar\00"
@.str.44 = private unnamed_addr constant [4 x i8] c"NUM\00"
@.str.45 = private unnamed_addr constant [10 x i8] c"fooNUMbar\00"
@.str.46 = private unnamed_addr constant [21 x i8] c"regex replace digits\00"
@.str.47 = private unnamed_addr constant [14 x i8] c"one:two:three\00"
@.str.48 = private unnamed_addr constant [2 x i8] c":\00"
@.str.49 = private unnamed_addr constant [12 x i8] c"split count\00"
@.str.50 = private unnamed_addr constant [4 x i8] c"one\00"
@.str.51 = private unnamed_addr constant [12 x i8] c"split first\00"
@.str.52 = private unnamed_addr constant [4 x i8] c"two\00"
@.str.53 = private unnamed_addr constant [13 x i8] c"split second\00"
@.str.54 = private unnamed_addr constant [6 x i8] c"three\00"
@.str.55 = private unnamed_addr constant [12 x i8] c"split third\00"
@.str.56 = private unnamed_addr constant [8 x i8] c"a1b2c3d\00"
@.str.57 = private unnamed_addr constant [3 x i8] c"\\d\00"
@.str.58 = private unnamed_addr constant [18 x i8] c"digit split count\00"
@.str.59 = private unnamed_addr constant [2 x i8] c"a\00"
@.str.60 = private unnamed_addr constant [14 x i8] c"digit split a\00"
@.str.61 = private unnamed_addr constant [2 x i8] c"b\00"
@.str.62 = private unnamed_addr constant [14 x i8] c"digit split b\00"
@.str.63 = private unnamed_addr constant [2 x i8] c"c\00"
@.str.64 = private unnamed_addr constant [14 x i8] c"digit split c\00"
@.str.65 = private unnamed_addr constant [2 x i8] c"d\00"
@.str.66 = private unnamed_addr constant [14 x i8] c"digit split d\00"
@.str.67 = private unnamed_addr constant [18 x i8] c"REGEX: ALL PASSED\00"

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
