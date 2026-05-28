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
  %slot.a = alloca i64, align 8
  store i64 0, ptr %slot.a, align 8
  %slot.serialize = alloca i64, align 8
  store i64 0, ptr %slot.serialize, align 8
  %slot.sa = alloca i64, align 8
  store i64 0, ptr %slot.sa, align 8
  %slot.deserialize = alloca i64, align 8
  store i64 0, ptr %slot.deserialize, align 8
  %slot.da = alloca i64, align 8
  store i64 0, ptr %slot.da, align 8
  %slot.s = alloca i64, align 8
  store i64 0, ptr %slot.s, align 8
  %slot.ss = alloca i64, align 8
  store i64 0, ptr %slot.ss, align 8
  %slot.ds = alloca i64, align 8
  store i64 0, ptr %slot.ds, align 8
  %slot.lst = alloca i64, align 8
  store i64 0, ptr %slot.lst, align 8
  %slot.sl = alloca i64, align 8
  store i64 0, ptr %slot.sl, align 8
  %slot.dl = alloca i64, align 8
  store i64 0, ptr %slot.dl, align 8
  %slot.d = alloca i64, align 8
  store i64 0, ptr %slot.d, align 8
  %slot.sd = alloca i64, align 8
  store i64 0, ptr %slot.sd, align 8
  %slot.dd = alloca i64, align 8
  store i64 0, ptr %slot.dd, align 8
  %slot.nested = alloca i64, align 8
  store i64 0, ptr %slot.nested, align 8
  %slot.sn = alloca i64, align 8
  store i64 0, ptr %slot.sn, align 8
  %slot.dn = alloca i64, align 8
  store i64 0, ptr %slot.dn, align 8
  %slot.serialize_hex = alloca i64, align 8
  store i64 0, ptr %slot.serialize_hex, align 8
  %slot.hex = alloca i64, align 8
  store i64 0, ptr %slot.hex, align 8
  %slot.hex2 = alloca i64, align 8
  store i64 0, ptr %slot.hex2, align 8
  %slot.z = alloca i64, align 8
  store i64 0, ptr %slot.z, align 8
  %slot.dz = alloca i64, align 8
  store i64 0, ptr %slot.dz, align 8
  %slot.empty_list = alloca i64, align 8
  store i64 0, ptr %slot.empty_list, align 8
  %slot.se = alloca i64, align 8
  store i64 0, ptr %slot.se, align 8
  %slot.de = alloca i64, align 8
  store i64 0, ptr %slot.de, align 8
  %slot.big = alloca i64, align 8
  store i64 0, ptr %slot.big, align 8
  %slot.sb = alloca i64, align 8
  store i64 0, ptr %slot.sb, align 8
  %slot.db = alloca i64, align 8
  store i64 0, ptr %slot.db, align 8
  %r0 = add i64 42, 0
  store i64 %r0, ptr %slot.a, align 8
  %r1 = load i64, ptr %slot.a, align 8
  %r3 = load i64, ptr %slot.serialize, align 8
  %r2.rec = inttoptr i64 %r3 to ptr
  %r2.fnraw = load i64, ptr %r2.rec, align 8
  %r2.fnptr = inttoptr i64 %r2.fnraw to ptr
  %r2 = call i64 %r2.fnptr(i64 %r3, i64 %r1)
  store i64 %r2, ptr %slot.sa, align 8
  %r4 = load i64, ptr %slot.sa, align 8
  %r6 = load i64, ptr %slot.deserialize, align 8
  %r5.rec = inttoptr i64 %r6 to ptr
  %r5.fnraw = load i64, ptr %r5.rec, align 8
  %r5.fnptr = inttoptr i64 %r5.fnraw to ptr
  %r5 = call i64 %r5.fnptr(i64 %r6, i64 %r4)
  store i64 %r5, ptr %slot.da, align 8
  %r7 = load i64, ptr %slot.da, align 8
  %r8 = add i64 42, 0
  %r9 = call i64 @nova_rt_eq(i64 %r7, i64 %r8)
  %r10.p = getelementptr inbounds [22 x i8], ptr @.str.0, i64 0, i64 0
  %r10 = ptrtoint ptr %r10.p to i64
  %r11 = call i64 @nova_rt_assert(i64 %r9, i64 %r10)
  %r12.p = getelementptr inbounds [6 x i8], ptr @.str.1, i64 0, i64 0
  %r12 = ptrtoint ptr %r12.p to i64
  %r13 = load i64, ptr %slot.da, align 8
  %r14 = call i64 @nova_rt_any_to_str(i64 %r13)
  %r15 = call i64 @nova_rt_str_concat(i64 %r12, i64 %r14)
  %r16.p = getelementptr inbounds [1 x i8], ptr @.str.2, i64 0, i64 0
  %r16 = ptrtoint ptr %r16.p to i64
  %r17 = call i64 @nova_rt_str_concat(i64 %r15, i64 %r16)
  %r18 = call i64 @nova_rt_print_any(i64 %r17)
  %r19.p = getelementptr inbounds [23 x i8], ptr @.str.3, i64 0, i64 0
  %r19 = ptrtoint ptr %r19.p to i64
  store i64 %r19, ptr %slot.s, align 8
  %r20 = load i64, ptr %slot.s, align 8
  %r22 = load i64, ptr %slot.serialize, align 8
  %r21.rec = inttoptr i64 %r22 to ptr
  %r21.fnraw = load i64, ptr %r21.rec, align 8
  %r21.fnptr = inttoptr i64 %r21.fnraw to ptr
  %r21 = call i64 %r21.fnptr(i64 %r22, i64 %r20)
  store i64 %r21, ptr %slot.ss, align 8
  %r23 = load i64, ptr %slot.ss, align 8
  %r25 = load i64, ptr %slot.deserialize, align 8
  %r24.rec = inttoptr i64 %r25 to ptr
  %r24.fnraw = load i64, ptr %r24.rec, align 8
  %r24.fnptr = inttoptr i64 %r24.fnraw to ptr
  %r24 = call i64 %r24.fnptr(i64 %r25, i64 %r23)
  store i64 %r24, ptr %slot.ds, align 8
  %r26 = load i64, ptr %slot.ds, align 8
  %r27.p = getelementptr inbounds [23 x i8], ptr @.str.3, i64 0, i64 0
  %r27 = ptrtoint ptr %r27.p to i64
  %r28.p0 = inttoptr i64 %r26 to ptr
  %r28.p1 = inttoptr i64 %r27 to ptr
  %r28.sc = call i32 @strcmp(ptr %r28.p0, ptr %r28.p1)
  %r28.cmp = icmp eq i32 %r28.sc, 0
  %r28 = zext i1 %r28.cmp to i64
  %r29.p = getelementptr inbounds [25 x i8], ptr @.str.4, i64 0, i64 0
  %r29 = ptrtoint ptr %r29.p to i64
  %r30 = call i64 @nova_rt_assert(i64 %r28, i64 %r29)
  %r31.p = getelementptr inbounds [9 x i8], ptr @.str.5, i64 0, i64 0
  %r31 = ptrtoint ptr %r31.p to i64
  %r32 = load i64, ptr %slot.ds, align 8
  %r33 = call i64 @nova_rt_any_to_str(i64 %r32)
  %r34 = call i64 @nova_rt_str_concat(i64 %r31, i64 %r33)
  %r35.p = getelementptr inbounds [1 x i8], ptr @.str.2, i64 0, i64 0
  %r35 = ptrtoint ptr %r35.p to i64
  %r36 = call i64 @nova_rt_str_concat(i64 %r34, i64 %r35)
  %r37 = call i64 @nova_rt_print_any(i64 %r36)
  %r39 = add i64 10, 0
  %r40 = add i64 20, 0
  %r41 = add i64 30, 0
  %r42 = add i64 40, 0
  %r43 = add i64 50, 0
  %r38 = call i64 @nova_rt_list_create()
  call i64 @nova_rt_list_append(i64 %r38, i64 %r39)
  call i64 @nova_rt_list_append(i64 %r38, i64 %r40)
  call i64 @nova_rt_list_append(i64 %r38, i64 %r41)
  call i64 @nova_rt_list_append(i64 %r38, i64 %r42)
  call i64 @nova_rt_list_append(i64 %r38, i64 %r43)
  store i64 %r38, ptr %slot.lst, align 8
  %r44 = load i64, ptr %slot.lst, align 8
  %r46 = load i64, ptr %slot.serialize, align 8
  %r45.rec = inttoptr i64 %r46 to ptr
  %r45.fnraw = load i64, ptr %r45.rec, align 8
  %r45.fnptr = inttoptr i64 %r45.fnraw to ptr
  %r45 = call i64 %r45.fnptr(i64 %r46, i64 %r44)
  store i64 %r45, ptr %slot.sl, align 8
  %r47 = load i64, ptr %slot.sl, align 8
  %r49 = load i64, ptr %slot.deserialize, align 8
  %r48.rec = inttoptr i64 %r49 to ptr
  %r48.fnraw = load i64, ptr %r48.rec, align 8
  %r48.fnptr = inttoptr i64 %r48.fnraw to ptr
  %r48 = call i64 %r48.fnptr(i64 %r49, i64 %r47)
  store i64 %r48, ptr %slot.dl, align 8
  %r50 = load i64, ptr %slot.dl, align 8
  %r51 = call i64 @nova_rt_len_any(i64 %r50)
  %r52 = add i64 5, 0
  %r53.cmp = icmp eq i64 %r51, %r52
  %r53 = zext i1 %r53.cmp to i64
  %r54.p = getelementptr inbounds [21 x i8], ptr @.str.6, i64 0, i64 0
  %r54 = ptrtoint ptr %r54.p to i64
  %r55 = call i64 @nova_rt_assert(i64 %r53, i64 %r54)
  %r56.p = getelementptr inbounds [7 x i8], ptr @.str.7, i64 0, i64 0
  %r56 = ptrtoint ptr %r56.p to i64
  %r57 = load i64, ptr %slot.dl, align 8
  %r58 = call i64 @nova_rt_any_to_str(i64 %r57)
  %r59 = call i64 @nova_rt_str_concat(i64 %r56, i64 %r58)
  %r60.p = getelementptr inbounds [1 x i8], ptr @.str.2, i64 0, i64 0
  %r60 = ptrtoint ptr %r60.p to i64
  %r61 = call i64 @nova_rt_str_concat(i64 %r59, i64 %r60)
  %r62 = call i64 @nova_rt_print_any(i64 %r61)
  %r63 = call i64 @nova_rt_dict_create()
  store i64 %r63, ptr %slot.d, align 8
  %r64.p = getelementptr inbounds [5 x i8], ptr @.str.8, i64 0, i64 0
  %r64 = ptrtoint ptr %r64.p to i64
  %r65 = load i64, ptr %slot.d, align 8
  %r66.p = getelementptr inbounds [5 x i8], ptr @.str.9, i64 0, i64 0
  %r66 = ptrtoint ptr %r66.p to i64
  call i64 @nova_rt_index_set(i64 %r65, i64 %r66, i64 %r64)
  %r67.p = getelementptr inbounds [4 x i8], ptr @.str.10, i64 0, i64 0
  %r67 = ptrtoint ptr %r67.p to i64
  %r68 = load i64, ptr %slot.d, align 8
  %r69.p = getelementptr inbounds [8 x i8], ptr @.str.11, i64 0, i64 0
  %r69 = ptrtoint ptr %r69.p to i64
  call i64 @nova_rt_index_set(i64 %r68, i64 %r69, i64 %r67)
  %r70.p = getelementptr inbounds [10 x i8], ptr @.str.12, i64 0, i64 0
  %r70 = ptrtoint ptr %r70.p to i64
  %r71 = load i64, ptr %slot.d, align 8
  %r72.p = getelementptr inbounds [5 x i8], ptr @.str.13, i64 0, i64 0
  %r72 = ptrtoint ptr %r72.p to i64
  call i64 @nova_rt_index_set(i64 %r71, i64 %r72, i64 %r70)
  %r73 = load i64, ptr %slot.d, align 8
  %r75 = load i64, ptr %slot.serialize, align 8
  %r74.rec = inttoptr i64 %r75 to ptr
  %r74.fnraw = load i64, ptr %r74.rec, align 8
  %r74.fnptr = inttoptr i64 %r74.fnraw to ptr
  %r74 = call i64 %r74.fnptr(i64 %r75, i64 %r73)
  store i64 %r74, ptr %slot.sd, align 8
  %r76 = load i64, ptr %slot.sd, align 8
  %r78 = load i64, ptr %slot.deserialize, align 8
  %r77.rec = inttoptr i64 %r78 to ptr
  %r77.fnraw = load i64, ptr %r77.rec, align 8
  %r77.fnptr = inttoptr i64 %r77.fnraw to ptr
  %r77 = call i64 %r77.fnptr(i64 %r78, i64 %r76)
  store i64 %r77, ptr %slot.dd, align 8
  %r79.p = getelementptr inbounds [12 x i8], ptr @.str.14, i64 0, i64 0
  %r79 = ptrtoint ptr %r79.p to i64
  %r80 = load i64, ptr %slot.dd, align 8
  %r81.p = getelementptr inbounds [5 x i8], ptr @.str.9, i64 0, i64 0
  %r81 = ptrtoint ptr %r81.p to i64
  %r82 = call i64 @nova_rt_index_get(i64 %r80, i64 %r81)
  %r83 = call i64 @nova_rt_any_to_str(i64 %r82)
  %r84 = call i64 @nova_rt_str_concat(i64 %r79, i64 %r83)
  %r85.p = getelementptr inbounds [1 x i8], ptr @.str.2, i64 0, i64 0
  %r85 = ptrtoint ptr %r85.p to i64
  %r86 = call i64 @nova_rt_str_concat(i64 %r84, i64 %r85)
  %r87 = call i64 @nova_rt_print_any(i64 %r86)
  %r88.p = getelementptr inbounds [15 x i8], ptr @.str.15, i64 0, i64 0
  %r88 = ptrtoint ptr %r88.p to i64
  %r89 = load i64, ptr %slot.dd, align 8
  %r90.p = getelementptr inbounds [8 x i8], ptr @.str.11, i64 0, i64 0
  %r90 = ptrtoint ptr %r90.p to i64
  %r91 = call i64 @nova_rt_index_get(i64 %r89, i64 %r90)
  %r92 = call i64 @nova_rt_any_to_str(i64 %r91)
  %r93 = call i64 @nova_rt_str_concat(i64 %r88, i64 %r92)
  %r94.p = getelementptr inbounds [1 x i8], ptr @.str.2, i64 0, i64 0
  %r94 = ptrtoint ptr %r94.p to i64
  %r95 = call i64 @nova_rt_str_concat(i64 %r93, i64 %r94)
  %r96 = call i64 @nova_rt_print_any(i64 %r95)
  %r99 = add i64 1, 0
  %r100 = add i64 2, 0
  %r98 = call i64 @nova_rt_list_create()
  call i64 @nova_rt_list_append(i64 %r98, i64 %r99)
  call i64 @nova_rt_list_append(i64 %r98, i64 %r100)
  %r102 = add i64 3, 0
  %r103 = add i64 4, 0
  %r101 = call i64 @nova_rt_list_create()
  call i64 @nova_rt_list_append(i64 %r101, i64 %r102)
  call i64 @nova_rt_list_append(i64 %r101, i64 %r103)
  %r105 = add i64 5, 0
  %r106 = add i64 6, 0
  %r104 = call i64 @nova_rt_list_create()
  call i64 @nova_rt_list_append(i64 %r104, i64 %r105)
  call i64 @nova_rt_list_append(i64 %r104, i64 %r106)
  %r97 = call i64 @nova_rt_list_create()
  call i64 @nova_rt_list_append(i64 %r97, i64 %r98)
  call i64 @nova_rt_list_append(i64 %r97, i64 %r101)
  call i64 @nova_rt_list_append(i64 %r97, i64 %r104)
  store i64 %r97, ptr %slot.nested, align 8
  %r107 = load i64, ptr %slot.nested, align 8
  %r109 = load i64, ptr %slot.serialize, align 8
  %r108.rec = inttoptr i64 %r109 to ptr
  %r108.fnraw = load i64, ptr %r108.rec, align 8
  %r108.fnptr = inttoptr i64 %r108.fnraw to ptr
  %r108 = call i64 %r108.fnptr(i64 %r109, i64 %r107)
  store i64 %r108, ptr %slot.sn, align 8
  %r110 = load i64, ptr %slot.sn, align 8
  %r112 = load i64, ptr %slot.deserialize, align 8
  %r111.rec = inttoptr i64 %r112 to ptr
  %r111.fnraw = load i64, ptr %r111.rec, align 8
  %r111.fnptr = inttoptr i64 %r111.fnraw to ptr
  %r111 = call i64 %r111.fnptr(i64 %r112, i64 %r110)
  store i64 %r111, ptr %slot.dn, align 8
  %r113.p = getelementptr inbounds [14 x i8], ptr @.str.16, i64 0, i64 0
  %r113 = ptrtoint ptr %r113.p to i64
  %r114 = load i64, ptr %slot.dn, align 8
  %r115 = call i64 @nova_rt_any_to_str(i64 %r114)
  %r116 = call i64 @nova_rt_str_concat(i64 %r113, i64 %r115)
  %r117.p = getelementptr inbounds [1 x i8], ptr @.str.2, i64 0, i64 0
  %r117 = ptrtoint ptr %r117.p to i64
  %r118 = call i64 @nova_rt_str_concat(i64 %r116, i64 %r117)
  %r119 = call i64 @nova_rt_print_any(i64 %r118)
  %r120 = add i64 42, 0
  %r122 = load i64, ptr %slot.serialize_hex, align 8
  %r121.rec = inttoptr i64 %r122 to ptr
  %r121.fnraw = load i64, ptr %r121.rec, align 8
  %r121.fnptr = inttoptr i64 %r121.fnraw to ptr
  %r121 = call i64 %r121.fnptr(i64 %r122, i64 %r120)
  store i64 %r121, ptr %slot.hex, align 8
  %r123.p = getelementptr inbounds [10 x i8], ptr @.str.17, i64 0, i64 0
  %r123 = ptrtoint ptr %r123.p to i64
  %r124 = load i64, ptr %slot.hex, align 8
  %r125 = call i64 @nova_rt_any_to_str(i64 %r124)
  %r126 = call i64 @nova_rt_str_concat(i64 %r123, i64 %r125)
  %r127.p = getelementptr inbounds [1 x i8], ptr @.str.2, i64 0, i64 0
  %r127 = ptrtoint ptr %r127.p to i64
  %r128 = call i64 @nova_rt_str_concat(i64 %r126, i64 %r127)
  %r129 = call i64 @nova_rt_print_any(i64 %r128)
  %r130.p = getelementptr inbounds [6 x i8], ptr @.str.18, i64 0, i64 0
  %r130 = ptrtoint ptr %r130.p to i64
  %r132 = load i64, ptr %slot.serialize_hex, align 8
  %r131.rec = inttoptr i64 %r132 to ptr
  %r131.fnraw = load i64, ptr %r131.rec, align 8
  %r131.fnptr = inttoptr i64 %r131.fnraw to ptr
  %r131 = call i64 %r131.fnptr(i64 %r132, i64 %r130)
  store i64 %r131, ptr %slot.hex2, align 8
  %r133.p = getelementptr inbounds [13 x i8], ptr @.str.19, i64 0, i64 0
  %r133 = ptrtoint ptr %r133.p to i64
  %r134 = load i64, ptr %slot.hex2, align 8
  %r135 = call i64 @nova_rt_any_to_str(i64 %r134)
  %r136 = call i64 @nova_rt_str_concat(i64 %r133, i64 %r135)
  %r137.p = getelementptr inbounds [1 x i8], ptr @.str.2, i64 0, i64 0
  %r137 = ptrtoint ptr %r137.p to i64
  %r138 = call i64 @nova_rt_str_concat(i64 %r136, i64 %r137)
  %r139 = call i64 @nova_rt_print_any(i64 %r138)
  %r140 = add i64 0, 0
  %r142 = load i64, ptr %slot.serialize, align 8
  %r141.rec = inttoptr i64 %r142 to ptr
  %r141.fnraw = load i64, ptr %r141.rec, align 8
  %r141.fnptr = inttoptr i64 %r141.fnraw to ptr
  %r141 = call i64 %r141.fnptr(i64 %r142, i64 %r140)
  store i64 %r141, ptr %slot.z, align 8
  %r143 = load i64, ptr %slot.z, align 8
  %r145 = load i64, ptr %slot.deserialize, align 8
  %r144.rec = inttoptr i64 %r145 to ptr
  %r144.fnraw = load i64, ptr %r144.rec, align 8
  %r144.fnptr = inttoptr i64 %r144.fnraw to ptr
  %r144 = call i64 %r144.fnptr(i64 %r145, i64 %r143)
  store i64 %r144, ptr %slot.dz, align 8
  %r146 = load i64, ptr %slot.dz, align 8
  %r147 = add i64 0, 0
  %r148 = call i64 @nova_rt_eq(i64 %r146, i64 %r147)
  %r149.p = getelementptr inbounds [23 x i8], ptr @.str.20, i64 0, i64 0
  %r149 = ptrtoint ptr %r149.p to i64
  %r150 = call i64 @nova_rt_assert(i64 %r148, i64 %r149)
  %r151.p = getelementptr inbounds [7 x i8], ptr @.str.21, i64 0, i64 0
  %r151 = ptrtoint ptr %r151.p to i64
  %r152 = load i64, ptr %slot.dz, align 8
  %r153 = call i64 @nova_rt_any_to_str(i64 %r152)
  %r154 = call i64 @nova_rt_str_concat(i64 %r151, i64 %r153)
  %r155.p = getelementptr inbounds [1 x i8], ptr @.str.2, i64 0, i64 0
  %r155 = ptrtoint ptr %r155.p to i64
  %r156 = call i64 @nova_rt_str_concat(i64 %r154, i64 %r155)
  %r157 = call i64 @nova_rt_print_any(i64 %r156)
  %r159 = add i64 0, 0
  %r158 = call i64 @nova_rt_list_create()
  call i64 @nova_rt_list_append(i64 %r158, i64 %r159)
  store i64 %r158, ptr %slot.empty_list, align 8
  %r160 = load i64, ptr %slot.empty_list, align 8
  %r162 = load i64, ptr %slot.serialize, align 8
  %r161.rec = inttoptr i64 %r162 to ptr
  %r161.fnraw = load i64, ptr %r161.rec, align 8
  %r161.fnptr = inttoptr i64 %r161.fnraw to ptr
  %r161 = call i64 %r161.fnptr(i64 %r162, i64 %r160)
  store i64 %r161, ptr %slot.se, align 8
  %r163 = load i64, ptr %slot.se, align 8
  %r165 = load i64, ptr %slot.deserialize, align 8
  %r164.rec = inttoptr i64 %r165 to ptr
  %r164.fnraw = load i64, ptr %r164.rec, align 8
  %r164.fnptr = inttoptr i64 %r164.fnraw to ptr
  %r164 = call i64 %r164.fnptr(i64 %r165, i64 %r163)
  store i64 %r164, ptr %slot.de, align 8
  %r166.p = getelementptr inbounds [22 x i8], ptr @.str.22, i64 0, i64 0
  %r166 = ptrtoint ptr %r166.p to i64
  %r167 = load i64, ptr %slot.de, align 8
  %r168 = call i64 @nova_rt_any_to_str(i64 %r167)
  %r169 = call i64 @nova_rt_str_concat(i64 %r166, i64 %r168)
  %r170.p = getelementptr inbounds [1 x i8], ptr @.str.2, i64 0, i64 0
  %r170 = ptrtoint ptr %r170.p to i64
  %r171 = call i64 @nova_rt_str_concat(i64 %r169, i64 %r170)
  %r172 = call i64 @nova_rt_print_any(i64 %r171)
  %r173 = add i64 100, 0
  %r174 = call i64 @nova_rt_range(i64 %r173)
  store i64 %r174, ptr %slot.big, align 8
  %r175 = load i64, ptr %slot.big, align 8
  %r177 = load i64, ptr %slot.serialize, align 8
  %r176.rec = inttoptr i64 %r177 to ptr
  %r176.fnraw = load i64, ptr %r176.rec, align 8
  %r176.fnptr = inttoptr i64 %r176.fnraw to ptr
  %r176 = call i64 %r176.fnptr(i64 %r177, i64 %r175)
  store i64 %r176, ptr %slot.sb, align 8
  %r178 = load i64, ptr %slot.sb, align 8
  %r180 = load i64, ptr %slot.deserialize, align 8
  %r179.rec = inttoptr i64 %r180 to ptr
  %r179.fnraw = load i64, ptr %r179.rec, align 8
  %r179.fnptr = inttoptr i64 %r179.fnraw to ptr
  %r179 = call i64 %r179.fnptr(i64 %r180, i64 %r178)
  store i64 %r179, ptr %slot.db, align 8
  %r181 = load i64, ptr %slot.db, align 8
  %r182 = call i64 @nova_rt_len_any(i64 %r181)
  %r183 = add i64 100, 0
  %r184.cmp = icmp eq i64 %r182, %r183
  %r184 = zext i1 %r184.cmp to i64
  %r185.p = getelementptr inbounds [29 x i8], ptr @.str.23, i64 0, i64 0
  %r185 = ptrtoint ptr %r185.p to i64
  %r186 = call i64 @nova_rt_assert(i64 %r184, i64 %r185)
  %r187.p = getelementptr inbounds [17 x i8], ptr @.str.24, i64 0, i64 0
  %r187 = ptrtoint ptr %r187.p to i64
  %r188 = load i64, ptr %slot.db, align 8
  %r189 = call i64 @nova_rt_len_any(i64 %r188)
  %r190 = call i64 @nova_rt_any_to_str(i64 %r189)
  %r191 = call i64 @nova_rt_str_concat(i64 %r187, i64 %r190)
  %r192.p = getelementptr inbounds [1 x i8], ptr @.str.2, i64 0, i64 0
  %r192 = ptrtoint ptr %r192.p to i64
  %r193 = call i64 @nova_rt_str_concat(i64 %r191, i64 %r192)
  %r194 = call i64 @nova_rt_print_any(i64 %r193)
  %r195.p = getelementptr inbounds [31 x i8], ptr @.str.25, i64 0, i64 0
  %r195 = ptrtoint ptr %r195.p to i64
  %r196 = call i64 @nova_rt_print_any(i64 %r195)
  ret i64 %r196
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
@.str.0 = private unnamed_addr constant [22 x i8] c"int round-trip failed\00"
@.str.1 = private unnamed_addr constant [6 x i8] c"int: \00"
@.str.2 = private unnamed_addr constant [1 x i8] c"\00"
@.str.3 = private unnamed_addr constant [23 x i8] c"hello distributed NOVA\00"
@.str.4 = private unnamed_addr constant [25 x i8] c"string round-trip failed\00"
@.str.5 = private unnamed_addr constant [9 x i8] c"string: \00"
@.str.6 = private unnamed_addr constant [21 x i8] c"list length mismatch\00"
@.str.7 = private unnamed_addr constant [7 x i8] c"list: \00"
@.str.8 = private unnamed_addr constant [5 x i8] c"NOVA\00"
@.str.9 = private unnamed_addr constant [5 x i8] c"name\00"
@.str.10 = private unnamed_addr constant [4 x i8] c"1.0\00"
@.str.11 = private unnamed_addr constant [8 x i8] c"version\00"
@.str.12 = private unnamed_addr constant [10 x i8] c"universal\00"
@.str.13 = private unnamed_addr constant [5 x i8] c"lang\00"
@.str.14 = private unnamed_addr constant [12 x i8] c"dict name: \00"
@.str.15 = private unnamed_addr constant [15 x i8] c"dict version: \00"
@.str.16 = private unnamed_addr constant [14 x i8] c"nested list: \00"
@.str.17 = private unnamed_addr constant [10 x i8] c"hex(42): \00"
@.str.18 = private unnamed_addr constant [6 x i8] c"hello\00"
@.str.19 = private unnamed_addr constant [13 x i8] c"hex(hello): \00"
@.str.20 = private unnamed_addr constant [23 x i8] c"zero round-trip failed\00"
@.str.21 = private unnamed_addr constant [7 x i8] c"zero: \00"
@.str.22 = private unnamed_addr constant [22 x i8] c"single-element list: \00"
@.str.23 = private unnamed_addr constant [29 x i8] c"large list round-trip failed\00"
@.str.24 = private unnamed_addr constant [17 x i8] c"large list len: \00"
@.str.25 = private unnamed_addr constant [31 x i8] c"all serialization tests passed\00"

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
