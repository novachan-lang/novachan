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
  %slot.items = alloca i64, align 8
  store i64 0, ptr %slot.items, align 8
  %slot.enumerate = alloca i64, align 8
  store i64 0, ptr %slot.enumerate, align 8
  %slot.pairs = alloca i64, align 8
  store i64 0, ptr %slot.pairs, align 8
  %slot.a = alloca i64, align 8
  store i64 0, ptr %slot.a, align 8
  %slot.b = alloca i64, align 8
  store i64 0, ptr %slot.b, align 8
  %slot.zip = alloca i64, align 8
  store i64 0, ptr %slot.zip, align 8
  %slot.zipped = alloca i64, align 8
  store i64 0, ptr %slot.zipped, align 8
  %slot.nums = alloca i64, align 8
  store i64 0, ptr %slot.nums, align 8
  %slot.sum = alloca i64, align 8
  store i64 0, ptr %slot.sum, align 8
  %slot.total = alloca i64, align 8
  store i64 0, ptr %slot.total, align 8
  %slot.truthy = alloca i64, align 8
  store i64 0, ptr %slot.truthy, align 8
  %slot.all_true = alloca i64, align 8
  store i64 0, ptr %slot.all_true, align 8
  %slot.all_false = alloca i64, align 8
  store i64 0, ptr %slot.all_false, align 8
  %slot.any = alloca i64, align 8
  store i64 0, ptr %slot.any, align 8
  %slot.all = alloca i64, align 8
  store i64 0, ptr %slot.all, align 8
  %slot.vals = alloca i64, align 8
  store i64 0, ptr %slot.vals, align 8
  %slot.list_min = alloca i64, align 8
  store i64 0, ptr %slot.list_min, align 8
  %slot.list_max = alloca i64, align 8
  store i64 0, ptr %slot.list_max, align 8
  %r1 = add i64 10, 0
  %r2 = add i64 20, 0
  %r3 = add i64 30, 0
  %r0 = call i64 @nova_rt_list_create()
  call i64 @nova_rt_list_append(i64 %r0, i64 %r1)
  call i64 @nova_rt_list_append(i64 %r0, i64 %r2)
  call i64 @nova_rt_list_append(i64 %r0, i64 %r3)
  store i64 %r0, ptr %slot.items, align 8
  %r4 = load i64, ptr %slot.items, align 8
  %r6 = load i64, ptr %slot.enumerate, align 8
  %r5.rec = inttoptr i64 %r6 to ptr
  %r5.fnraw = load i64, ptr %r5.rec, align 8
  %r5.fnptr = inttoptr i64 %r5.fnraw to ptr
  %r5 = call i64 %r5.fnptr(i64 %r6, i64 %r4)
  store i64 %r5, ptr %slot.pairs, align 8
  %r7 = load i64, ptr %slot.pairs, align 8
  %r8 = call i64 @nova_rt_len_any(i64 %r7)
  %r9 = add i64 3, 0
  %r10.cmp = icmp eq i64 %r8, %r9
  %r10 = zext i1 %r10.cmp to i64
  %r11.p = getelementptr inbounds [17 x i8], ptr @.str.0, i64 0, i64 0
  %r11 = ptrtoint ptr %r11.p to i64
  %r12 = call i64 @nova_rt_assert(i64 %r10, i64 %r11)
  %r13.p = getelementptr inbounds [12 x i8], ptr @.str.1, i64 0, i64 0
  %r13 = ptrtoint ptr %r13.p to i64
  %r14 = load i64, ptr %slot.pairs, align 8
  %r15 = call i64 @nova_rt_any_to_str(i64 %r14)
  %r16 = call i64 @nova_rt_str_concat(i64 %r13, i64 %r15)
  %r17.p = getelementptr inbounds [1 x i8], ptr @.str.2, i64 0, i64 0
  %r17 = ptrtoint ptr %r17.p to i64
  %r18 = call i64 @nova_rt_str_concat(i64 %r16, i64 %r17)
  %r19 = call i64 @nova_rt_print_any(i64 %r18)
  %r21 = add i64 1, 0
  %r22 = add i64 2, 0
  %r23 = add i64 3, 0
  %r20 = call i64 @nova_rt_list_create()
  call i64 @nova_rt_list_append(i64 %r20, i64 %r21)
  call i64 @nova_rt_list_append(i64 %r20, i64 %r22)
  call i64 @nova_rt_list_append(i64 %r20, i64 %r23)
  store i64 %r20, ptr %slot.a, align 8
  %r25 = add i64 10, 0
  %r26 = add i64 20, 0
  %r27 = add i64 30, 0
  %r24 = call i64 @nova_rt_list_create()
  call i64 @nova_rt_list_append(i64 %r24, i64 %r25)
  call i64 @nova_rt_list_append(i64 %r24, i64 %r26)
  call i64 @nova_rt_list_append(i64 %r24, i64 %r27)
  store i64 %r24, ptr %slot.b, align 8
  %r28 = load i64, ptr %slot.a, align 8
  %r29 = load i64, ptr %slot.b, align 8
  %r31 = load i64, ptr %slot.zip, align 8
  %r30.rec = inttoptr i64 %r31 to ptr
  %r30.fnraw = load i64, ptr %r30.rec, align 8
  %r30.fnptr = inttoptr i64 %r30.fnraw to ptr
  %r30 = call i64 %r30.fnptr(i64 %r31, i64 %r28, i64 %r29)
  store i64 %r30, ptr %slot.zipped, align 8
  %r32 = load i64, ptr %slot.zipped, align 8
  %r33 = call i64 @nova_rt_len_any(i64 %r32)
  %r34 = add i64 3, 0
  %r35.cmp = icmp eq i64 %r33, %r34
  %r35 = zext i1 %r35.cmp to i64
  %r36.p = getelementptr inbounds [11 x i8], ptr @.str.3, i64 0, i64 0
  %r36 = ptrtoint ptr %r36.p to i64
  %r37 = call i64 @nova_rt_assert(i64 %r35, i64 %r36)
  %r38.p = getelementptr inbounds [6 x i8], ptr @.str.4, i64 0, i64 0
  %r38 = ptrtoint ptr %r38.p to i64
  %r39 = load i64, ptr %slot.zipped, align 8
  %r40 = call i64 @nova_rt_any_to_str(i64 %r39)
  %r41 = call i64 @nova_rt_str_concat(i64 %r38, i64 %r40)
  %r42.p = getelementptr inbounds [1 x i8], ptr @.str.2, i64 0, i64 0
  %r42 = ptrtoint ptr %r42.p to i64
  %r43 = call i64 @nova_rt_str_concat(i64 %r41, i64 %r42)
  %r44 = call i64 @nova_rt_print_any(i64 %r43)
  %r46 = add i64 1, 0
  %r47 = add i64 2, 0
  %r48 = add i64 3, 0
  %r49 = add i64 4, 0
  %r50 = add i64 5, 0
  %r45 = call i64 @nova_rt_list_create()
  call i64 @nova_rt_list_append(i64 %r45, i64 %r46)
  call i64 @nova_rt_list_append(i64 %r45, i64 %r47)
  call i64 @nova_rt_list_append(i64 %r45, i64 %r48)
  call i64 @nova_rt_list_append(i64 %r45, i64 %r49)
  call i64 @nova_rt_list_append(i64 %r45, i64 %r50)
  store i64 %r45, ptr %slot.nums, align 8
  %r51 = load i64, ptr %slot.nums, align 8
  %r53 = load i64, ptr %slot.sum, align 8
  %r52.rec = inttoptr i64 %r53 to ptr
  %r52.fnraw = load i64, ptr %r52.rec, align 8
  %r52.fnptr = inttoptr i64 %r52.fnraw to ptr
  %r52 = call i64 %r52.fnptr(i64 %r53, i64 %r51)
  store i64 %r52, ptr %slot.total, align 8
  %r54 = load i64, ptr %slot.total, align 8
  %r55 = add i64 15, 0
  %r56 = call i64 @nova_rt_eq(i64 %r54, i64 %r55)
  %r57.p = getelementptr inbounds [17 x i8], ptr @.str.5, i64 0, i64 0
  %r57 = ptrtoint ptr %r57.p to i64
  %r58 = call i64 @nova_rt_assert(i64 %r56, i64 %r57)
  %r59.p = getelementptr inbounds [6 x i8], ptr @.str.6, i64 0, i64 0
  %r59 = ptrtoint ptr %r59.p to i64
  %r60 = load i64, ptr %slot.total, align 8
  %r61 = call i64 @nova_rt_any_to_str(i64 %r60)
  %r62 = call i64 @nova_rt_str_concat(i64 %r59, i64 %r61)
  %r63.p = getelementptr inbounds [1 x i8], ptr @.str.2, i64 0, i64 0
  %r63 = ptrtoint ptr %r63.p to i64
  %r64 = call i64 @nova_rt_str_concat(i64 %r62, i64 %r63)
  %r65 = call i64 @nova_rt_print_any(i64 %r64)
  %r67 = add i64 1, 0
  %r68 = add i64 0, 0
  %r69 = add i64 1, 0
  %r66 = call i64 @nova_rt_list_create()
  call i64 @nova_rt_list_append(i64 %r66, i64 %r67)
  call i64 @nova_rt_list_append(i64 %r66, i64 %r68)
  call i64 @nova_rt_list_append(i64 %r66, i64 %r69)
  store i64 %r66, ptr %slot.truthy, align 8
  %r71 = add i64 1, 0
  %r72 = add i64 1, 0
  %r73 = add i64 1, 0
  %r70 = call i64 @nova_rt_list_create()
  call i64 @nova_rt_list_append(i64 %r70, i64 %r71)
  call i64 @nova_rt_list_append(i64 %r70, i64 %r72)
  call i64 @nova_rt_list_append(i64 %r70, i64 %r73)
  store i64 %r70, ptr %slot.all_true, align 8
  %r75 = add i64 0, 0
  %r76 = add i64 0, 0
  %r77 = add i64 0, 0
  %r74 = call i64 @nova_rt_list_create()
  call i64 @nova_rt_list_append(i64 %r74, i64 %r75)
  call i64 @nova_rt_list_append(i64 %r74, i64 %r76)
  call i64 @nova_rt_list_append(i64 %r74, i64 %r77)
  store i64 %r74, ptr %slot.all_false, align 8
  %r78 = load i64, ptr %slot.truthy, align 8
  %r80 = load i64, ptr %slot.any, align 8
  %r79.rec = inttoptr i64 %r80 to ptr
  %r79.fnraw = load i64, ptr %r79.rec, align 8
  %r79.fnptr = inttoptr i64 %r79.fnraw to ptr
  %r79 = call i64 %r79.fnptr(i64 %r80, i64 %r78)
  %r81 = add i64 1, 0
  %r82 = call i64 @nova_rt_eq(i64 %r79, i64 %r81)
  %r83.p = getelementptr inbounds [11 x i8], ptr @.str.7, i64 0, i64 0
  %r83 = ptrtoint ptr %r83.p to i64
  %r84 = call i64 @nova_rt_assert(i64 %r82, i64 %r83)
  %r85 = load i64, ptr %slot.all_true, align 8
  %r87 = load i64, ptr %slot.all, align 8
  %r86.rec = inttoptr i64 %r87 to ptr
  %r86.fnraw = load i64, ptr %r86.rec, align 8
  %r86.fnptr = inttoptr i64 %r86.fnraw to ptr
  %r86 = call i64 %r86.fnptr(i64 %r87, i64 %r85)
  %r88 = add i64 1, 0
  %r89 = call i64 @nova_rt_eq(i64 %r86, i64 %r88)
  %r90.p = getelementptr inbounds [9 x i8], ptr @.str.8, i64 0, i64 0
  %r90 = ptrtoint ptr %r90.p to i64
  %r91 = call i64 @nova_rt_assert(i64 %r89, i64 %r90)
  %r92 = load i64, ptr %slot.truthy, align 8
  %r94 = load i64, ptr %slot.all, align 8
  %r93.rec = inttoptr i64 %r94 to ptr
  %r93.fnraw = load i64, ptr %r93.rec, align 8
  %r93.fnptr = inttoptr i64 %r93.fnraw to ptr
  %r93 = call i64 %r93.fnptr(i64 %r94, i64 %r92)
  %r95 = add i64 0, 0
  %r96 = call i64 @nova_rt_eq(i64 %r93, i64 %r95)
  %r97.p = getelementptr inbounds [15 x i8], ptr @.str.9, i64 0, i64 0
  %r97 = ptrtoint ptr %r97.p to i64
  %r98 = call i64 @nova_rt_assert(i64 %r96, i64 %r97)
  %r99 = load i64, ptr %slot.all_false, align 8
  %r101 = load i64, ptr %slot.any, align 8
  %r100.rec = inttoptr i64 %r101 to ptr
  %r100.fnraw = load i64, ptr %r100.rec, align 8
  %r100.fnptr = inttoptr i64 %r100.fnraw to ptr
  %r100 = call i64 %r100.fnptr(i64 %r101, i64 %r99)
  %r102 = add i64 0, 0
  %r103 = call i64 @nova_rt_eq(i64 %r100, i64 %r102)
  %r104.p = getelementptr inbounds [10 x i8], ptr @.str.10, i64 0, i64 0
  %r104 = ptrtoint ptr %r104.p to i64
  %r105 = call i64 @nova_rt_assert(i64 %r103, i64 %r104)
  %r106.p = getelementptr inbounds [15 x i8], ptr @.str.11, i64 0, i64 0
  %r106 = ptrtoint ptr %r106.p to i64
  %r107 = load i64, ptr %slot.truthy, align 8
  %r109 = load i64, ptr %slot.any, align 8
  %r108.rec = inttoptr i64 %r109 to ptr
  %r108.fnraw = load i64, ptr %r108.rec, align 8
  %r108.fnptr = inttoptr i64 %r108.fnraw to ptr
  %r108 = call i64 %r108.fnptr(i64 %r109, i64 %r107)
  %r110 = call i64 @nova_rt_any_to_str(i64 %r108)
  %r111 = call i64 @nova_rt_str_concat(i64 %r106, i64 %r110)
  %r112.p = getelementptr inbounds [1 x i8], ptr @.str.2, i64 0, i64 0
  %r112 = ptrtoint ptr %r112.p to i64
  %r113 = call i64 @nova_rt_str_concat(i64 %r111, i64 %r112)
  %r114 = call i64 @nova_rt_print_any(i64 %r113)
  %r115.p = getelementptr inbounds [15 x i8], ptr @.str.12, i64 0, i64 0
  %r115 = ptrtoint ptr %r115.p to i64
  %r116 = load i64, ptr %slot.all_true, align 8
  %r118 = load i64, ptr %slot.all, align 8
  %r117.rec = inttoptr i64 %r118 to ptr
  %r117.fnraw = load i64, ptr %r117.rec, align 8
  %r117.fnptr = inttoptr i64 %r117.fnraw to ptr
  %r117 = call i64 %r117.fnptr(i64 %r118, i64 %r116)
  %r119 = call i64 @nova_rt_any_to_str(i64 %r117)
  %r120 = call i64 @nova_rt_str_concat(i64 %r115, i64 %r119)
  %r121.p = getelementptr inbounds [1 x i8], ptr @.str.2, i64 0, i64 0
  %r121 = ptrtoint ptr %r121.p to i64
  %r122 = call i64 @nova_rt_str_concat(i64 %r120, i64 %r121)
  %r123 = call i64 @nova_rt_print_any(i64 %r122)
  %r125 = add i64 5, 0
  %r126 = add i64 2, 0
  %r127 = add i64 8, 0
  %r128 = add i64 1, 0
  %r129 = add i64 9, 0
  %r130 = add i64 3, 0
  %r124 = call i64 @nova_rt_list_create()
  call i64 @nova_rt_list_append(i64 %r124, i64 %r125)
  call i64 @nova_rt_list_append(i64 %r124, i64 %r126)
  call i64 @nova_rt_list_append(i64 %r124, i64 %r127)
  call i64 @nova_rt_list_append(i64 %r124, i64 %r128)
  call i64 @nova_rt_list_append(i64 %r124, i64 %r129)
  call i64 @nova_rt_list_append(i64 %r124, i64 %r130)
  store i64 %r124, ptr %slot.vals, align 8
  %r131 = load i64, ptr %slot.vals, align 8
  %r133 = load i64, ptr %slot.list_min, align 8
  %r132.rec = inttoptr i64 %r133 to ptr
  %r132.fnraw = load i64, ptr %r132.rec, align 8
  %r132.fnptr = inttoptr i64 %r132.fnraw to ptr
  %r132 = call i64 %r132.fnptr(i64 %r133, i64 %r131)
  %r134 = add i64 1, 0
  %r135 = call i64 @nova_rt_eq(i64 %r132, i64 %r134)
  %r136.p = getelementptr inbounds [16 x i8], ptr @.str.13, i64 0, i64 0
  %r136 = ptrtoint ptr %r136.p to i64
  %r137 = call i64 @nova_rt_assert(i64 %r135, i64 %r136)
  %r138 = load i64, ptr %slot.vals, align 8
  %r140 = load i64, ptr %slot.list_max, align 8
  %r139.rec = inttoptr i64 %r140 to ptr
  %r139.fnraw = load i64, ptr %r139.rec, align 8
  %r139.fnptr = inttoptr i64 %r139.fnraw to ptr
  %r139 = call i64 %r139.fnptr(i64 %r140, i64 %r138)
  %r141 = add i64 9, 0
  %r142 = call i64 @nova_rt_eq(i64 %r139, i64 %r141)
  %r143.p = getelementptr inbounds [16 x i8], ptr @.str.14, i64 0, i64 0
  %r143 = ptrtoint ptr %r143.p to i64
  %r144 = call i64 @nova_rt_assert(i64 %r142, i64 %r143)
  %r145.p = getelementptr inbounds [6 x i8], ptr @.str.15, i64 0, i64 0
  %r145 = ptrtoint ptr %r145.p to i64
  %r146 = load i64, ptr %slot.vals, align 8
  %r148 = load i64, ptr %slot.list_min, align 8
  %r147.rec = inttoptr i64 %r148 to ptr
  %r147.fnraw = load i64, ptr %r147.rec, align 8
  %r147.fnptr = inttoptr i64 %r147.fnraw to ptr
  %r147 = call i64 %r147.fnptr(i64 %r148, i64 %r146)
  %r149 = call i64 @nova_rt_any_to_str(i64 %r147)
  %r150 = call i64 @nova_rt_str_concat(i64 %r145, i64 %r149)
  %r151.p = getelementptr inbounds [8 x i8], ptr @.str.16, i64 0, i64 0
  %r151 = ptrtoint ptr %r151.p to i64
  %r152 = call i64 @nova_rt_str_concat(i64 %r150, i64 %r151)
  %r153 = load i64, ptr %slot.vals, align 8
  %r155 = load i64, ptr %slot.list_max, align 8
  %r154.rec = inttoptr i64 %r155 to ptr
  %r154.fnraw = load i64, ptr %r154.rec, align 8
  %r154.fnptr = inttoptr i64 %r154.fnraw to ptr
  %r154 = call i64 %r154.fnptr(i64 %r155, i64 %r153)
  %r156 = call i64 @nova_rt_any_to_str(i64 %r154)
  %r157 = call i64 @nova_rt_str_concat(i64 %r152, i64 %r156)
  %r158.p = getelementptr inbounds [1 x i8], ptr @.str.2, i64 0, i64 0
  %r158 = ptrtoint ptr %r158.p to i64
  %r159 = call i64 @nova_rt_str_concat(i64 %r157, i64 %r158)
  %r160 = call i64 @nova_rt_print_any(i64 %r159)
  %r161.p = getelementptr inbounds [28 x i8], ptr @.str.17, i64 0, i64 0
  %r161 = ptrtoint ptr %r161.p to i64
  %r162 = call i64 @nova_rt_print_any(i64 %r161)
  ret i64 %r162
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
@.str.0 = private unnamed_addr constant [17 x i8] c"enumerate length\00"
@.str.1 = private unnamed_addr constant [12 x i8] c"enumerate: \00"
@.str.2 = private unnamed_addr constant [1 x i8] c"\00"
@.str.3 = private unnamed_addr constant [11 x i8] c"zip length\00"
@.str.4 = private unnamed_addr constant [6 x i8] c"zip: \00"
@.str.5 = private unnamed_addr constant [17 x i8] c"sum should be 15\00"
@.str.6 = private unnamed_addr constant [6 x i8] c"sum: \00"
@.str.7 = private unnamed_addr constant [11 x i8] c"any truthy\00"
@.str.8 = private unnamed_addr constant [9 x i8] c"all true\00"
@.str.9 = private unnamed_addr constant [15 x i8] c"not all truthy\00"
@.str.10 = private unnamed_addr constant [10 x i8] c"none true\00"
@.str.11 = private unnamed_addr constant [15 x i8] c"any([1,0,1]): \00"
@.str.12 = private unnamed_addr constant [15 x i8] c"all([1,1,1]): \00"
@.str.13 = private unnamed_addr constant [16 x i8] c"min should be 1\00"
@.str.14 = private unnamed_addr constant [16 x i8] c"max should be 9\00"
@.str.15 = private unnamed_addr constant [6 x i8] c"min: \00"
@.str.16 = private unnamed_addr constant [8 x i8] c", max: \00"
@.str.17 = private unnamed_addr constant [28 x i8] c"all collection tests passed\00"

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
