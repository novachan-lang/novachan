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
  %slot.s = alloca i64, align 8
  store i64 0, ptr %slot.s, align 8
  %slot.up = alloca i64, align 8
  store i64 0, ptr %slot.up, align 8
  %slot.lo = alloca i64, align 8
  store i64 0, ptr %slot.lo, align 8
  %slot.trimmed = alloca i64, align 8
  store i64 0, ptr %slot.trimmed, align 8
  %slot.rep = alloca i64, align 8
  store i64 0, ptr %slot.rep, align 8
  %slot.indent = alloca i64, align 8
  store i64 0, ptr %slot.indent, align 8
  %slot.count = alloca i64, align 8
  store i64 0, ptr %slot.count, align 8
  %slot.__for_idx_0 = alloca i64, align 8
  store i64 0, ptr %slot.__for_idx_0, align 8
  %slot.c = alloca i64, align 8
  store i64 0, ptr %slot.c, align 8
  %slot.reversed = alloca i64, align 8
  store i64 0, ptr %slot.reversed, align 8
  %slot.__for_idx_3 = alloca i64, align 8
  store i64 0, ptr %slot.__for_idx_3, align 8
  %slot.sub = alloca i64, align 8
  store i64 0, ptr %slot.sub, align 8
  %slot.idx = alloca i64, align 8
  store i64 0, ptr %slot.idx, align 8
  %slot.replaced = alloca i64, align 8
  store i64 0, ptr %slot.replaced, align 8
  %slot.parts = alloca i64, align 8
  store i64 0, ptr %slot.parts, align 8
  %slot.joined = alloca i64, align 8
  store i64 0, ptr %slot.joined, align 8
  %r0.p = getelementptr inbounds [14 x i8], ptr @.str.0, i64 0, i64 0
  %r0 = ptrtoint ptr %r0.p to i64
  store i64 %r0, ptr %slot.s, align 8
  %r1 = load i64, ptr %slot.s, align 8
  %r2 = add i64 0, 0
  %r3 = call i64 @nova_rt_index_get(i64 %r1, i64 %r2)
  %r4.p = getelementptr inbounds [2 x i8], ptr @.str.1, i64 0, i64 0
  %r4 = ptrtoint ptr %r4.p to i64
  %r5.p0 = inttoptr i64 %r3 to ptr
  %r5.p1 = inttoptr i64 %r4 to ptr
  %r5.sc = call i32 @strcmp(ptr %r5.p0, ptr %r5.p1)
  %r5.cmp = icmp eq i32 %r5.sc, 0
  %r5 = zext i1 %r5.cmp to i64
  %r6.p = getelementptr inbounds [11 x i8], ptr @.str.2, i64 0, i64 0
  %r6 = ptrtoint ptr %r6.p to i64
  %r7 = call i64 @nova_rt_assert(i64 %r5, i64 %r6)
  %r8 = load i64, ptr %slot.s, align 8
  %r9 = add i64 1, 0
  %r10 = sub i64 0, %r9
  %r11 = call i64 @nova_rt_index_get(i64 %r8, i64 %r10)
  %r12.p = getelementptr inbounds [2 x i8], ptr @.str.3, i64 0, i64 0
  %r12 = ptrtoint ptr %r12.p to i64
  %r13.p0 = inttoptr i64 %r11 to ptr
  %r13.p1 = inttoptr i64 %r12 to ptr
  %r13.sc = call i32 @strcmp(ptr %r13.p0, ptr %r13.p1)
  %r13.cmp = icmp eq i32 %r13.sc, 0
  %r13 = zext i1 %r13.cmp to i64
  %r14.p = getelementptr inbounds [10 x i8], ptr @.str.4, i64 0, i64 0
  %r14 = ptrtoint ptr %r14.p to i64
  %r15 = call i64 @nova_rt_assert(i64 %r13, i64 %r14)
  %r16 = load i64, ptr %slot.s, align 8
  %r17 = call i64 @nova_rt_len_any(i64 %r16)
  %r18 = add i64 13, 0
  %r19.cmp = icmp eq i64 %r17, %r18
  %r19 = zext i1 %r19.cmp to i64
  %r20.p = getelementptr inbounds [7 x i8], ptr @.str.5, i64 0, i64 0
  %r20 = ptrtoint ptr %r20.p to i64
  %r21 = call i64 @nova_rt_assert(i64 %r19, i64 %r20)
  %r22 = load i64, ptr %slot.s, align 8
  %r23 = call i64 @nova_rt_upper(i64 %r22)
  store i64 %r23, ptr %slot.up, align 8
  %r24 = load i64, ptr %slot.up, align 8
  %r25.p = getelementptr inbounds [14 x i8], ptr @.str.6, i64 0, i64 0
  %r25 = ptrtoint ptr %r25.p to i64
  %r26.p0 = inttoptr i64 %r24 to ptr
  %r26.p1 = inttoptr i64 %r25 to ptr
  %r26.sc = call i32 @strcmp(ptr %r26.p0, ptr %r26.p1)
  %r26.cmp = icmp eq i32 %r26.sc, 0
  %r26 = zext i1 %r26.cmp to i64
  %r27.p = getelementptr inbounds [6 x i8], ptr @.str.7, i64 0, i64 0
  %r27 = ptrtoint ptr %r27.p to i64
  %r28 = call i64 @nova_rt_assert(i64 %r26, i64 %r27)
  %r29 = load i64, ptr %slot.s, align 8
  %r30 = call i64 @nova_rt_lower(i64 %r29)
  store i64 %r30, ptr %slot.lo, align 8
  %r31 = load i64, ptr %slot.lo, align 8
  %r32.p = getelementptr inbounds [14 x i8], ptr @.str.8, i64 0, i64 0
  %r32 = ptrtoint ptr %r32.p to i64
  %r33.p0 = inttoptr i64 %r31 to ptr
  %r33.p1 = inttoptr i64 %r32 to ptr
  %r33.sc = call i32 @strcmp(ptr %r33.p0, ptr %r33.p1)
  %r33.cmp = icmp eq i32 %r33.sc, 0
  %r33 = zext i1 %r33.cmp to i64
  %r34.p = getelementptr inbounds [6 x i8], ptr @.str.9, i64 0, i64 0
  %r34 = ptrtoint ptr %r34.p to i64
  %r35 = call i64 @nova_rt_assert(i64 %r33, i64 %r34)
  %r36.p = getelementptr inbounds [7 x i8], ptr @.str.10, i64 0, i64 0
  %r36 = ptrtoint ptr %r36.p to i64
  %r37 = call i64 @nova_rt_trim(i64 %r36)
  store i64 %r37, ptr %slot.trimmed, align 8
  %r38 = load i64, ptr %slot.trimmed, align 8
  %r39.p = getelementptr inbounds [3 x i8], ptr @.str.11, i64 0, i64 0
  %r39 = ptrtoint ptr %r39.p to i64
  %r40.p0 = inttoptr i64 %r38 to ptr
  %r40.p1 = inttoptr i64 %r39 to ptr
  %r40.sc = call i32 @strcmp(ptr %r40.p0, ptr %r40.p1)
  %r40.cmp = icmp eq i32 %r40.sc, 0
  %r40 = zext i1 %r40.cmp to i64
  %r41.p = getelementptr inbounds [5 x i8], ptr @.str.12, i64 0, i64 0
  %r41 = ptrtoint ptr %r41.p to i64
  %r42 = call i64 @nova_rt_assert(i64 %r40, i64 %r41)
  %r43.p = getelementptr inbounds [3 x i8], ptr @.str.13, i64 0, i64 0
  %r43 = ptrtoint ptr %r43.p to i64
  %r44 = add i64 3, 0
  %r45 = call i64 @nova_rt_repeat(i64 %r43, i64 %r44)
  store i64 %r45, ptr %slot.rep, align 8
  %r46 = load i64, ptr %slot.rep, align 8
  %r47.p = getelementptr inbounds [7 x i8], ptr @.str.14, i64 0, i64 0
  %r47 = ptrtoint ptr %r47.p to i64
  %r48.p0 = inttoptr i64 %r46 to ptr
  %r48.p1 = inttoptr i64 %r47 to ptr
  %r48.sc = call i32 @strcmp(ptr %r48.p0, ptr %r48.p1)
  %r48.cmp = icmp eq i32 %r48.sc, 0
  %r48 = zext i1 %r48.cmp to i64
  %r49.p = getelementptr inbounds [7 x i8], ptr @.str.15, i64 0, i64 0
  %r49 = ptrtoint ptr %r49.p to i64
  %r50 = call i64 @nova_rt_assert(i64 %r48, i64 %r49)
  %r51.p = getelementptr inbounds [3 x i8], ptr @.str.16, i64 0, i64 0
  %r51 = ptrtoint ptr %r51.p to i64
  %r52 = add i64 4, 0
  %r53 = call i64 @nova_rt_repeat(i64 %r51, i64 %r52)
  store i64 %r53, ptr %slot.indent, align 8
  %r54 = load i64, ptr %slot.indent, align 8
  %r55.p = getelementptr inbounds [9 x i8], ptr @.str.17, i64 0, i64 0
  %r55 = ptrtoint ptr %r55.p to i64
  %r56.p0 = inttoptr i64 %r54 to ptr
  %r56.p1 = inttoptr i64 %r55 to ptr
  %r56.sc = call i32 @strcmp(ptr %r56.p0, ptr %r56.p1)
  %r56.cmp = icmp eq i32 %r56.sc, 0
  %r56 = zext i1 %r56.cmp to i64
  %r57.p = getelementptr inbounds [14 x i8], ptr @.str.18, i64 0, i64 0
  %r57 = ptrtoint ptr %r57.p to i64
  %r58 = call i64 @nova_rt_assert(i64 %r56, i64 %r57)
  %r59 = add i64 0, 0
  store i64 %r59, ptr %slot.count, align 8
  %r60 = load i64, ptr %slot.s, align 8
  %r61 = call i64 @nova_rt_len_any(i64 %r60)
  %r62 = add i64 0, 0
  store i64 %r62, ptr %slot.__for_idx_0, align 8
  br label %for_hdr0, !llvm.loop !91
for_hdr0:
  %r63 = load i64, ptr %slot.__for_idx_0, align 8
  %r64.cmp = icmp slt i64 %r63, %r61
  %r64 = zext i1 %r64.cmp to i64
  %br_for_body1 = icmp ne i64 %r64, 0
  br i1 %br_for_body1, label %for_body1, label %for_exit2, !prof !90
for_body1:
  %r65 = call i64 @nova_rt_index_get(i64 %r60, i64 %r63)
  store i64 %r65, ptr %slot.c, align 8
  %r66 = load i64, ptr %slot.count, align 8
  %r67 = add i64 1, 0
  %r68 = add i64 %r66, %r67
  store i64 %r68, ptr %slot.count, align 8
  %r69 = load i64, ptr %slot.__for_idx_0, align 8
  %r70 = add i64 1, 0
  %r71 = add i64 %r69, %r70
  store i64 %r71, ptr %slot.__for_idx_0, align 8
  br label %for_hdr0, !llvm.loop !91
for_exit2:
  %r72 = load i64, ptr %slot.count, align 8
  %r73 = add i64 13, 0
  %r74.cmp = icmp eq i64 %r72, %r73
  %r74 = zext i1 %r74.cmp to i64
  %r75.p = getelementptr inbounds [23 x i8], ptr @.str.19, i64 0, i64 0
  %r75 = ptrtoint ptr %r75.p to i64
  %r76 = call i64 @nova_rt_assert(i64 %r74, i64 %r75)
  %r77.p = getelementptr inbounds [1 x i8], ptr @.str.20, i64 0, i64 0
  %r77 = ptrtoint ptr %r77.p to i64
  store i64 %r77, ptr %slot.reversed, align 8
  %r78.p = getelementptr inbounds [5 x i8], ptr @.str.21, i64 0, i64 0
  %r78 = ptrtoint ptr %r78.p to i64
  %r79 = call i64 @nova_rt_len_any(i64 %r78)
  %r80 = add i64 0, 0
  store i64 %r80, ptr %slot.__for_idx_3, align 8
  br label %for_hdr3, !llvm.loop !91
for_hdr3:
  %r81 = load i64, ptr %slot.__for_idx_3, align 8
  %r82.cmp = icmp slt i64 %r81, %r79
  %r82 = zext i1 %r82.cmp to i64
  %br_for_body4 = icmp ne i64 %r82, 0
  br i1 %br_for_body4, label %for_body4, label %for_exit5, !prof !90
for_body4:
  %r83 = call i64 @nova_rt_index_get(i64 %r78, i64 %r81)
  store i64 %r83, ptr %slot.c, align 8
  %r84 = load i64, ptr %slot.c, align 8
  %r85 = load i64, ptr %slot.reversed, align 8
  %r86 = call i64 @nova_rt_str_concat(i64 %r84, i64 %r85)
  store i64 %r86, ptr %slot.reversed, align 8
  %r87 = load i64, ptr %slot.__for_idx_3, align 8
  %r88 = add i64 1, 0
  %r89 = add i64 %r87, %r88
  store i64 %r89, ptr %slot.__for_idx_3, align 8
  br label %for_hdr3, !llvm.loop !91
for_exit5:
  %r90 = load i64, ptr %slot.reversed, align 8
  %r91.p = getelementptr inbounds [5 x i8], ptr @.str.22, i64 0, i64 0
  %r91 = ptrtoint ptr %r91.p to i64
  %r92.p0 = inttoptr i64 %r90 to ptr
  %r92.p1 = inttoptr i64 %r91 to ptr
  %r92.sc = call i32 @strcmp(ptr %r92.p0, ptr %r92.p1)
  %r92.cmp = icmp eq i32 %r92.sc, 0
  %r92 = zext i1 %r92.cmp to i64
  %r93.p = getelementptr inbounds [22 x i8], ptr @.str.23, i64 0, i64 0
  %r93 = ptrtoint ptr %r93.p to i64
  %r94 = call i64 @nova_rt_assert(i64 %r92, i64 %r93)
  %r95 = load i64, ptr %slot.s, align 8
  %r96 = add i64 0, 0
  %r97 = add i64 5, 0
  %r98 = call i64 @nova_rt_slice(i64 %r95, i64 %r96, i64 %r97)
  store i64 %r98, ptr %slot.sub, align 8
  %r99 = load i64, ptr %slot.sub, align 8
  %r100.p = getelementptr inbounds [6 x i8], ptr @.str.24, i64 0, i64 0
  %r100 = ptrtoint ptr %r100.p to i64
  %r101.p0 = inttoptr i64 %r99 to ptr
  %r101.p1 = inttoptr i64 %r100 to ptr
  %r101.sc = call i32 @strcmp(ptr %r101.p0, ptr %r101.p1)
  %r101.cmp = icmp eq i32 %r101.sc, 0
  %r101 = zext i1 %r101.cmp to i64
  %r102.p = getelementptr inbounds [6 x i8], ptr @.str.25, i64 0, i64 0
  %r102 = ptrtoint ptr %r102.p to i64
  %r103 = call i64 @nova_rt_assert(i64 %r101, i64 %r102)
  %r104 = load i64, ptr %slot.s, align 8
  %r105.p = getelementptr inbounds [6 x i8], ptr @.str.24, i64 0, i64 0
  %r105 = ptrtoint ptr %r105.p to i64
  %r106 = call i64 @nova_rt_starts_with(i64 %r104, i64 %r105)
  %r107.p = getelementptr inbounds [12 x i8], ptr @.str.26, i64 0, i64 0
  %r107 = ptrtoint ptr %r107.p to i64
  %r108 = call i64 @nova_rt_assert(i64 %r106, i64 %r107)
  %r109 = load i64, ptr %slot.s, align 8
  %r110.p = getelementptr inbounds [7 x i8], ptr @.str.27, i64 0, i64 0
  %r110 = ptrtoint ptr %r110.p to i64
  %r111 = call i64 @nova_rt_ends_with(i64 %r109, i64 %r110)
  %r112.p = getelementptr inbounds [10 x i8], ptr @.str.28, i64 0, i64 0
  %r112 = ptrtoint ptr %r112.p to i64
  %r113 = call i64 @nova_rt_assert(i64 %r111, i64 %r112)
  %r114 = load i64, ptr %slot.s, align 8
  %r115.p = getelementptr inbounds [6 x i8], ptr @.str.29, i64 0, i64 0
  %r115 = ptrtoint ptr %r115.p to i64
  %r116 = call i64 @nova_rt_contains(i64 %r114, i64 %r115)
  %r117.p = getelementptr inbounds [9 x i8], ptr @.str.30, i64 0, i64 0
  %r117 = ptrtoint ptr %r117.p to i64
  %r118 = call i64 @nova_rt_assert(i64 %r116, i64 %r117)
  %r119 = load i64, ptr %slot.s, align 8
  %r120.p = getelementptr inbounds [6 x i8], ptr @.str.29, i64 0, i64 0
  %r120 = ptrtoint ptr %r120.p to i64
  %r121 = call i64 @nova_rt_find(i64 %r119, i64 %r120)
  store i64 %r121, ptr %slot.idx, align 8
  %r122 = load i64, ptr %slot.idx, align 8
  %r123 = add i64 7, 0
  %r124 = call i64 @nova_rt_eq(i64 %r122, i64 %r123)
  %r125.p = getelementptr inbounds [5 x i8], ptr @.str.31, i64 0, i64 0
  %r125 = ptrtoint ptr %r125.p to i64
  %r126 = call i64 @nova_rt_assert(i64 %r124, i64 %r125)
  %r127 = load i64, ptr %slot.s, align 8
  %r128.p = getelementptr inbounds [6 x i8], ptr @.str.29, i64 0, i64 0
  %r128 = ptrtoint ptr %r128.p to i64
  %r129.p = getelementptr inbounds [5 x i8], ptr @.str.32, i64 0, i64 0
  %r129 = ptrtoint ptr %r129.p to i64
  %r130 = call i64 @nova_rt_replace(i64 %r127, i64 %r128, i64 %r129)
  store i64 %r130, ptr %slot.replaced, align 8
  %r131 = load i64, ptr %slot.replaced, align 8
  %r132.p = getelementptr inbounds [13 x i8], ptr @.str.33, i64 0, i64 0
  %r132 = ptrtoint ptr %r132.p to i64
  %r133.p0 = inttoptr i64 %r131 to ptr
  %r133.p1 = inttoptr i64 %r132 to ptr
  %r133.sc = call i32 @strcmp(ptr %r133.p0, ptr %r133.p1)
  %r133.cmp = icmp eq i32 %r133.sc, 0
  %r133 = zext i1 %r133.cmp to i64
  %r134.p = getelementptr inbounds [8 x i8], ptr @.str.34, i64 0, i64 0
  %r134 = ptrtoint ptr %r134.p to i64
  %r135 = call i64 @nova_rt_assert(i64 %r133, i64 %r134)
  %r136.p = getelementptr inbounds [6 x i8], ptr @.str.35, i64 0, i64 0
  %r136 = ptrtoint ptr %r136.p to i64
  %r137.p = getelementptr inbounds [2 x i8], ptr @.str.36, i64 0, i64 0
  %r137 = ptrtoint ptr %r137.p to i64
  %r138 = call i64 @nova_rt_split(i64 %r136, i64 %r137)
  store i64 %r138, ptr %slot.parts, align 8
  %r139 = load i64, ptr %slot.parts, align 8
  %r140 = call i64 @nova_rt_len_any(i64 %r139)
  %r141 = add i64 3, 0
  %r142.cmp = icmp eq i64 %r140, %r141
  %r142 = zext i1 %r142.cmp to i64
  %r143.p = getelementptr inbounds [13 x i8], ptr @.str.37, i64 0, i64 0
  %r143 = ptrtoint ptr %r143.p to i64
  %r144 = call i64 @nova_rt_assert(i64 %r142, i64 %r143)
  %r145 = load i64, ptr %slot.parts, align 8
  %r146 = add i64 0, 0
  %r147 = call i64 @nova_rt_index_get(i64 %r145, i64 %r146)
  %r148.p = getelementptr inbounds [2 x i8], ptr @.str.38, i64 0, i64 0
  %r148 = ptrtoint ptr %r148.p to i64
  %r149.p0 = inttoptr i64 %r147 to ptr
  %r149.p1 = inttoptr i64 %r148 to ptr
  %r149.sc = call i32 @strcmp(ptr %r149.p0, ptr %r149.p1)
  %r149.cmp = icmp eq i32 %r149.sc, 0
  %r149 = zext i1 %r149.cmp to i64
  %r150.p = getelementptr inbounds [9 x i8], ptr @.str.39, i64 0, i64 0
  %r150 = ptrtoint ptr %r150.p to i64
  %r151 = call i64 @nova_rt_assert(i64 %r149, i64 %r150)
  %r152 = load i64, ptr %slot.parts, align 8
  %r153 = add i64 2, 0
  %r154 = call i64 @nova_rt_index_get(i64 %r152, i64 %r153)
  %r155.p = getelementptr inbounds [2 x i8], ptr @.str.40, i64 0, i64 0
  %r155 = ptrtoint ptr %r155.p to i64
  %r156.p0 = inttoptr i64 %r154 to ptr
  %r156.p1 = inttoptr i64 %r155 to ptr
  %r156.sc = call i32 @strcmp(ptr %r156.p0, ptr %r156.p1)
  %r156.cmp = icmp eq i32 %r156.sc, 0
  %r156 = zext i1 %r156.cmp to i64
  %r157.p = getelementptr inbounds [9 x i8], ptr @.str.41, i64 0, i64 0
  %r157 = ptrtoint ptr %r157.p to i64
  %r158 = call i64 @nova_rt_assert(i64 %r156, i64 %r157)
  %r159 = load i64, ptr %slot.parts, align 8
  %r160.p = getelementptr inbounds [2 x i8], ptr @.str.42, i64 0, i64 0
  %r160 = ptrtoint ptr %r160.p to i64
  %r161 = call i64 @nova_rt_join(i64 %r159, i64 %r160)
  store i64 %r161, ptr %slot.joined, align 8
  %r162 = load i64, ptr %slot.joined, align 8
  %r163.p = getelementptr inbounds [6 x i8], ptr @.str.43, i64 0, i64 0
  %r163 = ptrtoint ptr %r163.p to i64
  %r164.p0 = inttoptr i64 %r162 to ptr
  %r164.p1 = inttoptr i64 %r163 to ptr
  %r164.sc = call i32 @strcmp(ptr %r164.p0, ptr %r164.p1)
  %r164.cmp = icmp eq i32 %r164.sc, 0
  %r164 = zext i1 %r164.cmp to i64
  %r165.p = getelementptr inbounds [5 x i8], ptr @.str.44, i64 0, i64 0
  %r165 = ptrtoint ptr %r165.p to i64
  %r166 = call i64 @nova_rt_assert(i64 %r164, i64 %r165)
  %r167.p = getelementptr inbounds [30 x i8], ptr @.str.45, i64 0, i64 0
  %r167 = ptrtoint ptr %r167.p to i64
  %r168 = call i64 @nova_rt_print_any(i64 %r167)
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
@.str.0 = private unnamed_addr constant [14 x i8] c"Hello, World!\00"
@.str.1 = private unnamed_addr constant [2 x i8] c"H\00"
@.str.2 = private unnamed_addr constant [11 x i8] c"first char\00"
@.str.3 = private unnamed_addr constant [2 x i8] c"!\00"
@.str.4 = private unnamed_addr constant [10 x i8] c"last char\00"
@.str.5 = private unnamed_addr constant [7 x i8] c"length\00"
@.str.6 = private unnamed_addr constant [14 x i8] c"HELLO, WORLD!\00"
@.str.7 = private unnamed_addr constant [6 x i8] c"upper\00"
@.str.8 = private unnamed_addr constant [14 x i8] c"hello, world!\00"
@.str.9 = private unnamed_addr constant [6 x i8] c"lower\00"
@.str.10 = private unnamed_addr constant [7 x i8] c"  hi  \00"
@.str.11 = private unnamed_addr constant [3 x i8] c"hi\00"
@.str.12 = private unnamed_addr constant [5 x i8] c"trim\00"
@.str.13 = private unnamed_addr constant [3 x i8] c"ab\00"
@.str.14 = private unnamed_addr constant [7 x i8] c"ababab\00"
@.str.15 = private unnamed_addr constant [7 x i8] c"repeat\00"
@.str.16 = private unnamed_addr constant [3 x i8] c"  \00"
@.str.17 = private unnamed_addr constant [9 x i8] c"        \00"
@.str.18 = private unnamed_addr constant [14 x i8] c"indent repeat\00"
@.str.19 = private unnamed_addr constant [23 x i8] c"string iteration count\00"
@.str.20 = private unnamed_addr constant [1 x i8] c"\00"
@.str.21 = private unnamed_addr constant [5 x i8] c"nova\00"
@.str.22 = private unnamed_addr constant [5 x i8] c"avon\00"
@.str.23 = private unnamed_addr constant [22 x i8] c"reverse via iteration\00"
@.str.24 = private unnamed_addr constant [6 x i8] c"Hello\00"
@.str.25 = private unnamed_addr constant [6 x i8] c"slice\00"
@.str.26 = private unnamed_addr constant [12 x i8] c"starts_with\00"
@.str.27 = private unnamed_addr constant [7 x i8] c"World!\00"
@.str.28 = private unnamed_addr constant [10 x i8] c"ends_with\00"
@.str.29 = private unnamed_addr constant [6 x i8] c"World\00"
@.str.30 = private unnamed_addr constant [9 x i8] c"contains\00"
@.str.31 = private unnamed_addr constant [5 x i8] c"find\00"
@.str.32 = private unnamed_addr constant [5 x i8] c"NOVA\00"
@.str.33 = private unnamed_addr constant [13 x i8] c"Hello, NOVA!\00"
@.str.34 = private unnamed_addr constant [8 x i8] c"replace\00"
@.str.35 = private unnamed_addr constant [6 x i8] c"a,b,c\00"
@.str.36 = private unnamed_addr constant [2 x i8] c",\00"
@.str.37 = private unnamed_addr constant [13 x i8] c"split length\00"
@.str.38 = private unnamed_addr constant [2 x i8] c"a\00"
@.str.39 = private unnamed_addr constant [9 x i8] c"split[0]\00"
@.str.40 = private unnamed_addr constant [2 x i8] c"c\00"
@.str.41 = private unnamed_addr constant [9 x i8] c"split[2]\00"
@.str.42 = private unnamed_addr constant [2 x i8] c"-\00"
@.str.43 = private unnamed_addr constant [6 x i8] c"a-b-c\00"
@.str.44 = private unnamed_addr constant [5 x i8] c"join\00"
@.str.45 = private unnamed_addr constant [30 x i8] c"All string operations passed!\00"

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
