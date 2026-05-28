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
  %slot.bytes = alloca i64, align 8
  store i64 0, ptr %slot.bytes, align 8
  %slot.buf = alloca i64, align 8
  store i64 0, ptr %slot.buf, align 8
  %slot.bytes_len = alloca i64, align 8
  store i64 0, ptr %slot.bytes_len, align 8
  %slot.bytes_get = alloca i64, align 8
  store i64 0, ptr %slot.bytes_get, align 8
  %slot.bytes_set = alloca i64, align 8
  store i64 0, ptr %slot.bytes_set, align 8
  %slot.bytes_slice = alloca i64, align 8
  store i64 0, ptr %slot.bytes_slice, align 8
  %slot.bytes_to_str = alloca i64, align 8
  store i64 0, ptr %slot.bytes_to_str, align 8
  %slot.text = alloca i64, align 8
  store i64 0, ptr %slot.text, align 8
  %slot.str_to_bytes = alloca i64, align 8
  store i64 0, ptr %slot.str_to_bytes, align 8
  %slot.data = alloca i64, align 8
  store i64 0, ptr %slot.data, align 8
  %slot.sub = alloca i64, align 8
  store i64 0, ptr %slot.sub, align 8
  %r0 = add i64 10, 0
  %r2 = load i64, ptr %slot.bytes, align 8
  %r1.rec = inttoptr i64 %r2 to ptr
  %r1.fnraw = load i64, ptr %r1.rec, align 8
  %r1.fnptr = inttoptr i64 %r1.fnraw to ptr
  %r1 = call i64 %r1.fnptr(i64 %r2, i64 %r0)
  store i64 %r1, ptr %slot.buf, align 8
  %r3 = load i64, ptr %slot.buf, align 8
  %r5 = load i64, ptr %slot.bytes_len, align 8
  %r4.rec = inttoptr i64 %r5 to ptr
  %r4.fnraw = load i64, ptr %r4.rec, align 8
  %r4.fnptr = inttoptr i64 %r4.fnraw to ptr
  %r4 = call i64 %r4.fnptr(i64 %r5, i64 %r3)
  %r6 = add i64 10, 0
  %r7 = call i64 @nova_rt_eq(i64 %r4, i64 %r6)
  %r8.p = getelementptr inbounds [16 x i8], ptr @.str.0, i64 0, i64 0
  %r8 = ptrtoint ptr %r8.p to i64
  %r9 = call i64 @nova_rt_assert(i64 %r7, i64 %r8)
  %r10 = load i64, ptr %slot.buf, align 8
  %r11 = add i64 0, 0
  %r13 = load i64, ptr %slot.bytes_get, align 8
  %r12.rec = inttoptr i64 %r13 to ptr
  %r12.fnraw = load i64, ptr %r12.rec, align 8
  %r12.fnptr = inttoptr i64 %r12.fnraw to ptr
  %r12 = call i64 %r12.fnptr(i64 %r13, i64 %r10, i64 %r11)
  %r14 = add i64 0, 0
  %r15 = call i64 @nova_rt_eq(i64 %r12, i64 %r14)
  %r16.p = getelementptr inbounds [13 x i8], ptr @.str.1, i64 0, i64 0
  %r16 = ptrtoint ptr %r16.p to i64
  %r17 = call i64 @nova_rt_assert(i64 %r15, i64 %r16)
  %r18 = load i64, ptr %slot.buf, align 8
  %r19 = add i64 0, 0
  %r20 = add i64 72, 0
  %r22 = load i64, ptr %slot.bytes_set, align 8
  %r21.rec = inttoptr i64 %r22 to ptr
  %r21.fnraw = load i64, ptr %r21.rec, align 8
  %r21.fnptr = inttoptr i64 %r21.fnraw to ptr
  %r21 = call i64 %r21.fnptr(i64 %r22, i64 %r18, i64 %r19, i64 %r20)
  %r23 = load i64, ptr %slot.buf, align 8
  %r24 = add i64 1, 0
  %r25 = add i64 101, 0
  %r27 = load i64, ptr %slot.bytes_set, align 8
  %r26.rec = inttoptr i64 %r27 to ptr
  %r26.fnraw = load i64, ptr %r26.rec, align 8
  %r26.fnptr = inttoptr i64 %r26.fnraw to ptr
  %r26 = call i64 %r26.fnptr(i64 %r27, i64 %r23, i64 %r24, i64 %r25)
  %r28 = load i64, ptr %slot.buf, align 8
  %r29 = add i64 2, 0
  %r30 = add i64 108, 0
  %r32 = load i64, ptr %slot.bytes_set, align 8
  %r31.rec = inttoptr i64 %r32 to ptr
  %r31.fnraw = load i64, ptr %r31.rec, align 8
  %r31.fnptr = inttoptr i64 %r31.fnraw to ptr
  %r31 = call i64 %r31.fnptr(i64 %r32, i64 %r28, i64 %r29, i64 %r30)
  %r33 = load i64, ptr %slot.buf, align 8
  %r34 = add i64 3, 0
  %r35 = add i64 108, 0
  %r37 = load i64, ptr %slot.bytes_set, align 8
  %r36.rec = inttoptr i64 %r37 to ptr
  %r36.fnraw = load i64, ptr %r36.rec, align 8
  %r36.fnptr = inttoptr i64 %r36.fnraw to ptr
  %r36 = call i64 %r36.fnptr(i64 %r37, i64 %r33, i64 %r34, i64 %r35)
  %r38 = load i64, ptr %slot.buf, align 8
  %r39 = add i64 4, 0
  %r40 = add i64 111, 0
  %r42 = load i64, ptr %slot.bytes_set, align 8
  %r41.rec = inttoptr i64 %r42 to ptr
  %r41.fnraw = load i64, ptr %r41.rec, align 8
  %r41.fnptr = inttoptr i64 %r41.fnraw to ptr
  %r41 = call i64 %r41.fnptr(i64 %r42, i64 %r38, i64 %r39, i64 %r40)
  %r43 = load i64, ptr %slot.buf, align 8
  %r44 = add i64 0, 0
  %r46 = load i64, ptr %slot.bytes_get, align 8
  %r45.rec = inttoptr i64 %r46 to ptr
  %r45.fnraw = load i64, ptr %r45.rec, align 8
  %r45.fnptr = inttoptr i64 %r45.fnraw to ptr
  %r45 = call i64 %r45.fnptr(i64 %r46, i64 %r43, i64 %r44)
  %r47 = add i64 72, 0
  %r48 = call i64 @nova_rt_eq(i64 %r45, i64 %r47)
  %r49.p = getelementptr inbounds [7 x i8], ptr @.str.2, i64 0, i64 0
  %r49 = ptrtoint ptr %r49.p to i64
  %r50 = call i64 @nova_rt_assert(i64 %r48, i64 %r49)
  %r51 = load i64, ptr %slot.buf, align 8
  %r52 = add i64 4, 0
  %r54 = load i64, ptr %slot.bytes_get, align 8
  %r53.rec = inttoptr i64 %r54 to ptr
  %r53.fnraw = load i64, ptr %r53.rec, align 8
  %r53.fnptr = inttoptr i64 %r53.fnraw to ptr
  %r53 = call i64 %r53.fnptr(i64 %r54, i64 %r51, i64 %r52)
  %r55 = add i64 111, 0
  %r56 = call i64 @nova_rt_eq(i64 %r53, i64 %r55)
  %r57.p = getelementptr inbounds [8 x i8], ptr @.str.3, i64 0, i64 0
  %r57 = ptrtoint ptr %r57.p to i64
  %r58 = call i64 @nova_rt_assert(i64 %r56, i64 %r57)
  %r59 = load i64, ptr %slot.buf, align 8
  %r60 = add i64 0, 0
  %r61 = add i64 5, 0
  %r63 = load i64, ptr %slot.bytes_slice, align 8
  %r62.rec = inttoptr i64 %r63 to ptr
  %r62.fnraw = load i64, ptr %r62.rec, align 8
  %r62.fnptr = inttoptr i64 %r62.fnraw to ptr
  %r62 = call i64 %r62.fnptr(i64 %r63, i64 %r59, i64 %r60, i64 %r61)
  %r65 = load i64, ptr %slot.bytes_to_str, align 8
  %r64.rec = inttoptr i64 %r65 to ptr
  %r64.fnraw = load i64, ptr %r64.rec, align 8
  %r64.fnptr = inttoptr i64 %r64.fnraw to ptr
  %r64 = call i64 %r64.fnptr(i64 %r65, i64 %r62)
  store i64 %r64, ptr %slot.text, align 8
  %r66 = load i64, ptr %slot.text, align 8
  %r67.p = getelementptr inbounds [6 x i8], ptr @.str.4, i64 0, i64 0
  %r67 = ptrtoint ptr %r67.p to i64
  %r68.p0 = inttoptr i64 %r66 to ptr
  %r68.p1 = inttoptr i64 %r67 to ptr
  %r68.sc = call i32 @strcmp(ptr %r68.p0, ptr %r68.p1)
  %r68.cmp = icmp eq i32 %r68.sc, 0
  %r68 = zext i1 %r68.cmp to i64
  %r69.p = getelementptr inbounds [13 x i8], ptr @.str.5, i64 0, i64 0
  %r69 = ptrtoint ptr %r69.p to i64
  %r70 = call i64 @nova_rt_assert(i64 %r68, i64 %r69)
  %r71.p = getelementptr inbounds [5 x i8], ptr @.str.6, i64 0, i64 0
  %r71 = ptrtoint ptr %r71.p to i64
  %r73 = load i64, ptr %slot.str_to_bytes, align 8
  %r72.rec = inttoptr i64 %r73 to ptr
  %r72.fnraw = load i64, ptr %r72.rec, align 8
  %r72.fnptr = inttoptr i64 %r72.fnraw to ptr
  %r72 = call i64 %r72.fnptr(i64 %r73, i64 %r71)
  store i64 %r72, ptr %slot.data, align 8
  %r74 = load i64, ptr %slot.data, align 8
  %r76 = load i64, ptr %slot.bytes_len, align 8
  %r75.rec = inttoptr i64 %r76 to ptr
  %r75.fnraw = load i64, ptr %r75.rec, align 8
  %r75.fnptr = inttoptr i64 %r75.fnraw to ptr
  %r75 = call i64 %r75.fnptr(i64 %r76, i64 %r74)
  %r77 = add i64 4, 0
  %r78 = call i64 @nova_rt_eq(i64 %r75, i64 %r77)
  %r79.p = getelementptr inbounds [17 x i8], ptr @.str.7, i64 0, i64 0
  %r79 = ptrtoint ptr %r79.p to i64
  %r80 = call i64 @nova_rt_assert(i64 %r78, i64 %r79)
  %r81 = load i64, ptr %slot.data, align 8
  %r82 = add i64 0, 0
  %r84 = load i64, ptr %slot.bytes_get, align 8
  %r83.rec = inttoptr i64 %r84 to ptr
  %r83.fnraw = load i64, ptr %r83.rec, align 8
  %r83.fnptr = inttoptr i64 %r83.fnraw to ptr
  %r83 = call i64 %r83.fnptr(i64 %r84, i64 %r81, i64 %r82)
  %r85 = add i64 78, 0
  %r86 = call i64 @nova_rt_eq(i64 %r83, i64 %r85)
  %r87.p = getelementptr inbounds [7 x i8], ptr @.str.8, i64 0, i64 0
  %r87 = ptrtoint ptr %r87.p to i64
  %r88 = call i64 @nova_rt_assert(i64 %r86, i64 %r87)
  %r89 = load i64, ptr %slot.data, align 8
  %r90 = add i64 1, 0
  %r92 = load i64, ptr %slot.bytes_get, align 8
  %r91.rec = inttoptr i64 %r92 to ptr
  %r91.fnraw = load i64, ptr %r91.rec, align 8
  %r91.fnptr = inttoptr i64 %r91.fnraw to ptr
  %r91 = call i64 %r91.fnptr(i64 %r92, i64 %r89, i64 %r90)
  %r93 = add i64 79, 0
  %r94 = call i64 @nova_rt_eq(i64 %r91, i64 %r93)
  %r95.p = getelementptr inbounds [7 x i8], ptr @.str.9, i64 0, i64 0
  %r95 = ptrtoint ptr %r95.p to i64
  %r96 = call i64 @nova_rt_assert(i64 %r94, i64 %r95)
  %r97 = load i64, ptr %slot.data, align 8
  %r98 = add i64 2, 0
  %r100 = load i64, ptr %slot.bytes_get, align 8
  %r99.rec = inttoptr i64 %r100 to ptr
  %r99.fnraw = load i64, ptr %r99.rec, align 8
  %r99.fnptr = inttoptr i64 %r99.fnraw to ptr
  %r99 = call i64 %r99.fnptr(i64 %r100, i64 %r97, i64 %r98)
  %r101 = add i64 86, 0
  %r102 = call i64 @nova_rt_eq(i64 %r99, i64 %r101)
  %r103.p = getelementptr inbounds [7 x i8], ptr @.str.10, i64 0, i64 0
  %r103 = ptrtoint ptr %r103.p to i64
  %r104 = call i64 @nova_rt_assert(i64 %r102, i64 %r103)
  %r105 = load i64, ptr %slot.data, align 8
  %r106 = add i64 3, 0
  %r108 = load i64, ptr %slot.bytes_get, align 8
  %r107.rec = inttoptr i64 %r108 to ptr
  %r107.fnraw = load i64, ptr %r107.rec, align 8
  %r107.fnptr = inttoptr i64 %r107.fnraw to ptr
  %r107 = call i64 %r107.fnptr(i64 %r108, i64 %r105, i64 %r106)
  %r109 = add i64 65, 0
  %r110 = call i64 @nova_rt_eq(i64 %r107, i64 %r109)
  %r111.p = getelementptr inbounds [7 x i8], ptr @.str.11, i64 0, i64 0
  %r111 = ptrtoint ptr %r111.p to i64
  %r112 = call i64 @nova_rt_assert(i64 %r110, i64 %r111)
  %r113 = load i64, ptr %slot.data, align 8
  %r114 = add i64 1, 0
  %r115 = add i64 3, 0
  %r117 = load i64, ptr %slot.bytes_slice, align 8
  %r116.rec = inttoptr i64 %r117 to ptr
  %r116.fnraw = load i64, ptr %r116.rec, align 8
  %r116.fnptr = inttoptr i64 %r116.fnraw to ptr
  %r116 = call i64 %r116.fnptr(i64 %r117, i64 %r113, i64 %r114, i64 %r115)
  store i64 %r116, ptr %slot.sub, align 8
  %r118 = load i64, ptr %slot.sub, align 8
  %r120 = load i64, ptr %slot.bytes_len, align 8
  %r119.rec = inttoptr i64 %r120 to ptr
  %r119.fnraw = load i64, ptr %r119.rec, align 8
  %r119.fnptr = inttoptr i64 %r119.fnraw to ptr
  %r119 = call i64 %r119.fnptr(i64 %r120, i64 %r118)
  %r121 = add i64 2, 0
  %r122 = call i64 @nova_rt_eq(i64 %r119, i64 %r121)
  %r123.p = getelementptr inbounds [10 x i8], ptr @.str.12, i64 0, i64 0
  %r123 = ptrtoint ptr %r123.p to i64
  %r124 = call i64 @nova_rt_assert(i64 %r122, i64 %r123)
  %r125 = load i64, ptr %slot.sub, align 8
  %r127 = load i64, ptr %slot.bytes_to_str, align 8
  %r126.rec = inttoptr i64 %r127 to ptr
  %r126.fnraw = load i64, ptr %r126.rec, align 8
  %r126.fnptr = inttoptr i64 %r126.fnraw to ptr
  %r126 = call i64 %r126.fnptr(i64 %r127, i64 %r125)
  %r128.p = getelementptr inbounds [3 x i8], ptr @.str.13, i64 0, i64 0
  %r128 = ptrtoint ptr %r128.p to i64
  %r129.p0 = inttoptr i64 %r126 to ptr
  %r129.p1 = inttoptr i64 %r128 to ptr
  %r129.sc = call i32 @strcmp(ptr %r129.p0, ptr %r129.p1)
  %r129.cmp = icmp eq i32 %r129.sc, 0
  %r129 = zext i1 %r129.cmp to i64
  %r130.p = getelementptr inbounds [14 x i8], ptr @.str.14, i64 0, i64 0
  %r130 = ptrtoint ptr %r130.p to i64
  %r131 = call i64 @nova_rt_assert(i64 %r129, i64 %r130)
  %r132 = load i64, ptr %slot.buf, align 8
  %r133 = add i64 5, 0
  %r134 = add i64 256, 0
  %r136 = load i64, ptr %slot.bytes_set, align 8
  %r135.rec = inttoptr i64 %r136 to ptr
  %r135.fnraw = load i64, ptr %r135.rec, align 8
  %r135.fnptr = inttoptr i64 %r135.fnraw to ptr
  %r135 = call i64 %r135.fnptr(i64 %r136, i64 %r132, i64 %r133, i64 %r134)
  %r137 = load i64, ptr %slot.buf, align 8
  %r138 = add i64 5, 0
  %r140 = load i64, ptr %slot.bytes_get, align 8
  %r139.rec = inttoptr i64 %r140 to ptr
  %r139.fnraw = load i64, ptr %r139.rec, align 8
  %r139.fnptr = inttoptr i64 %r139.fnraw to ptr
  %r139 = call i64 %r139.fnptr(i64 %r140, i64 %r137, i64 %r138)
  %r141 = add i64 0, 0
  %r142 = call i64 @nova_rt_eq(i64 %r139, i64 %r141)
  %r143.p = getelementptr inbounds [20 x i8], ptr @.str.15, i64 0, i64 0
  %r143 = ptrtoint ptr %r143.p to i64
  %r144 = call i64 @nova_rt_assert(i64 %r142, i64 %r143)
  %r145 = load i64, ptr %slot.buf, align 8
  %r146 = add i64 6, 0
  %r147 = add i64 300, 0
  %r149 = load i64, ptr %slot.bytes_set, align 8
  %r148.rec = inttoptr i64 %r149 to ptr
  %r148.fnraw = load i64, ptr %r148.rec, align 8
  %r148.fnptr = inttoptr i64 %r148.fnraw to ptr
  %r148 = call i64 %r148.fnptr(i64 %r149, i64 %r145, i64 %r146, i64 %r147)
  %r150 = load i64, ptr %slot.buf, align 8
  %r151 = add i64 6, 0
  %r153 = load i64, ptr %slot.bytes_get, align 8
  %r152.rec = inttoptr i64 %r153 to ptr
  %r152.fnraw = load i64, ptr %r152.rec, align 8
  %r152.fnptr = inttoptr i64 %r152.fnraw to ptr
  %r152 = call i64 %r152.fnptr(i64 %r153, i64 %r150, i64 %r151)
  %r154 = add i64 44, 0
  %r155 = call i64 @nova_rt_eq(i64 %r152, i64 %r154)
  %r156.p = getelementptr inbounds [16 x i8], ptr @.str.16, i64 0, i64 0
  %r156 = ptrtoint ptr %r156.p to i64
  %r157 = call i64 @nova_rt_assert(i64 %r155, i64 %r156)
  %r158.p = getelementptr inbounds [18 x i8], ptr @.str.17, i64 0, i64 0
  %r158 = ptrtoint ptr %r158.p to i64
  %r159 = call i64 @nova_rt_print_any(i64 %r158)
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
@.str.0 = private unnamed_addr constant [16 x i8] c"initial size 10\00"
@.str.1 = private unnamed_addr constant [13 x i8] c"initial zero\00"
@.str.2 = private unnamed_addr constant [7 x i8] c"H = 72\00"
@.str.3 = private unnamed_addr constant [8 x i8] c"o = 111\00"
@.str.4 = private unnamed_addr constant [6 x i8] c"Hello\00"
@.str.5 = private unnamed_addr constant [13 x i8] c"bytes to str\00"
@.str.6 = private unnamed_addr constant [5 x i8] c"NOVA\00"
@.str.7 = private unnamed_addr constant [17 x i8] c"str_to_bytes len\00"
@.str.8 = private unnamed_addr constant [7 x i8] c"N = 78\00"
@.str.9 = private unnamed_addr constant [7 x i8] c"O = 79\00"
@.str.10 = private unnamed_addr constant [7 x i8] c"V = 86\00"
@.str.11 = private unnamed_addr constant [7 x i8] c"A = 65\00"
@.str.12 = private unnamed_addr constant [10 x i8] c"slice len\00"
@.str.13 = private unnamed_addr constant [3 x i8] c"OV\00"
@.str.14 = private unnamed_addr constant [14 x i8] c"slice content\00"
@.str.15 = private unnamed_addr constant [20 x i8] c"overflow wraps to 0\00"
@.str.16 = private unnamed_addr constant [16 x i8] c"300 & 0xFF = 44\00"
@.str.17 = private unnamed_addr constant [18 x i8] c"BYTES: ALL PASSED\00"

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
