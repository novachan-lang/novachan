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
  %slot.now = alloca i64, align 8
  store i64 0, ptr %slot.now, align 8
  %slot.datetime_now = alloca i64, align 8
  store i64 0, ptr %slot.datetime_now, align 8
  %slot.dt = alloca i64, align 8
  store i64 0, ptr %slot.dt, align 8
  %slot.datetime_year = alloca i64, align 8
  store i64 0, ptr %slot.datetime_year, align 8
  %slot.year = alloca i64, align 8
  store i64 0, ptr %slot.year, align 8
  %slot.datetime_month = alloca i64, align 8
  store i64 0, ptr %slot.datetime_month, align 8
  %slot.month = alloca i64, align 8
  store i64 0, ptr %slot.month, align 8
  %slot.datetime_day = alloca i64, align 8
  store i64 0, ptr %slot.datetime_day, align 8
  %slot.day = alloca i64, align 8
  store i64 0, ptr %slot.day, align 8
  %slot.datetime_hour = alloca i64, align 8
  store i64 0, ptr %slot.datetime_hour, align 8
  %slot.hour = alloca i64, align 8
  store i64 0, ptr %slot.hour, align 8
  %slot.datetime_minute = alloca i64, align 8
  store i64 0, ptr %slot.datetime_minute, align 8
  %slot.minute = alloca i64, align 8
  store i64 0, ptr %slot.minute, align 8
  %slot.datetime_second = alloca i64, align 8
  store i64 0, ptr %slot.datetime_second, align 8
  %slot.second = alloca i64, align 8
  store i64 0, ptr %slot.second, align 8
  %slot.datetime_format = alloca i64, align 8
  store i64 0, ptr %slot.datetime_format, align 8
  %slot.formatted = alloca i64, align 8
  store i64 0, ptr %slot.formatted, align 8
  %r0 = call i64 @nova_rt_time_ms()
  store i64 %r0, ptr %slot.now, align 8
  %r1 = load i64, ptr %slot.now, align 8
  %r2 = add i64 0, 0
  %r3.cmp = icmp sgt i64 %r1, %r2
  %r3 = zext i1 %r3.cmp to i64
  %r4.p = getelementptr inbounds [27 x i8], ptr @.str.0, i64 0, i64 0
  %r4 = ptrtoint ptr %r4.p to i64
  %r5 = call i64 @nova_rt_assert(i64 %r3, i64 %r4)
  %r7 = load i64, ptr %slot.datetime_now, align 8
  %r6.rec = inttoptr i64 %r7 to ptr
  %r6.fnraw = load i64, ptr %r6.rec, align 8
  %r6.fnptr = inttoptr i64 %r6.fnraw to ptr
  %r6 = call i64 %r6.fnptr(i64 %r7)
  store i64 %r6, ptr %slot.dt, align 8
  %r8.p = getelementptr inbounds [15 x i8], ptr @.str.1, i64 0, i64 0
  %r8 = ptrtoint ptr %r8.p to i64
  %r9 = load i64, ptr %slot.dt, align 8
  %r10 = call i64 @nova_rt_any_to_str(i64 %r9)
  %r11 = call i64 @nova_rt_str_concat(i64 %r8, i64 %r10)
  %r12.p = getelementptr inbounds [1 x i8], ptr @.str.2, i64 0, i64 0
  %r12 = ptrtoint ptr %r12.p to i64
  %r13 = call i64 @nova_rt_str_concat(i64 %r11, i64 %r12)
  %r14 = call i64 @nova_rt_print_any(i64 %r13)
  %r15 = load i64, ptr %slot.dt, align 8
  %r16 = call i64 @nova_rt_len_any(i64 %r15)
  %r17 = add i64 10, 0
  %r18.cmp = icmp sgt i64 %r16, %r17
  %r18 = zext i1 %r18.cmp to i64
  %r19.p = getelementptr inbounds [33 x i8], ptr @.str.3, i64 0, i64 0
  %r19 = ptrtoint ptr %r19.p to i64
  %r20 = call i64 @nova_rt_assert(i64 %r18, i64 %r19)
  %r21 = load i64, ptr %slot.now, align 8
  %r23 = load i64, ptr %slot.datetime_year, align 8
  %r22.rec = inttoptr i64 %r23 to ptr
  %r22.fnraw = load i64, ptr %r22.rec, align 8
  %r22.fnptr = inttoptr i64 %r22.fnraw to ptr
  %r22 = call i64 %r22.fnptr(i64 %r23, i64 %r21)
  store i64 %r22, ptr %slot.year, align 8
  %r24 = load i64, ptr %slot.now, align 8
  %r26 = load i64, ptr %slot.datetime_month, align 8
  %r25.rec = inttoptr i64 %r26 to ptr
  %r25.fnraw = load i64, ptr %r25.rec, align 8
  %r25.fnptr = inttoptr i64 %r25.fnraw to ptr
  %r25 = call i64 %r25.fnptr(i64 %r26, i64 %r24)
  store i64 %r25, ptr %slot.month, align 8
  %r27 = load i64, ptr %slot.now, align 8
  %r29 = load i64, ptr %slot.datetime_day, align 8
  %r28.rec = inttoptr i64 %r29 to ptr
  %r28.fnraw = load i64, ptr %r28.rec, align 8
  %r28.fnptr = inttoptr i64 %r28.fnraw to ptr
  %r28 = call i64 %r28.fnptr(i64 %r29, i64 %r27)
  store i64 %r28, ptr %slot.day, align 8
  %r30 = load i64, ptr %slot.now, align 8
  %r32 = load i64, ptr %slot.datetime_hour, align 8
  %r31.rec = inttoptr i64 %r32 to ptr
  %r31.fnraw = load i64, ptr %r31.rec, align 8
  %r31.fnptr = inttoptr i64 %r31.fnraw to ptr
  %r31 = call i64 %r31.fnptr(i64 %r32, i64 %r30)
  store i64 %r31, ptr %slot.hour, align 8
  %r33 = load i64, ptr %slot.now, align 8
  %r35 = load i64, ptr %slot.datetime_minute, align 8
  %r34.rec = inttoptr i64 %r35 to ptr
  %r34.fnraw = load i64, ptr %r34.rec, align 8
  %r34.fnptr = inttoptr i64 %r34.fnraw to ptr
  %r34 = call i64 %r34.fnptr(i64 %r35, i64 %r33)
  store i64 %r34, ptr %slot.minute, align 8
  %r36 = load i64, ptr %slot.now, align 8
  %r38 = load i64, ptr %slot.datetime_second, align 8
  %r37.rec = inttoptr i64 %r38 to ptr
  %r37.fnraw = load i64, ptr %r37.rec, align 8
  %r37.fnptr = inttoptr i64 %r37.fnraw to ptr
  %r37 = call i64 %r37.fnptr(i64 %r38, i64 %r36)
  store i64 %r37, ptr %slot.second, align 8
  %r39.p = getelementptr inbounds [7 x i8], ptr @.str.4, i64 0, i64 0
  %r39 = ptrtoint ptr %r39.p to i64
  %r40 = load i64, ptr %slot.year, align 8
  %r41 = call i64 @nova_rt_any_to_str(i64 %r40)
  %r42 = call i64 @nova_rt_str_concat(i64 %r39, i64 %r41)
  %r43.p = getelementptr inbounds [1 x i8], ptr @.str.2, i64 0, i64 0
  %r43 = ptrtoint ptr %r43.p to i64
  %r44 = call i64 @nova_rt_str_concat(i64 %r42, i64 %r43)
  %r45 = call i64 @nova_rt_print_any(i64 %r44)
  %r46.p = getelementptr inbounds [8 x i8], ptr @.str.5, i64 0, i64 0
  %r46 = ptrtoint ptr %r46.p to i64
  %r47 = load i64, ptr %slot.month, align 8
  %r48 = call i64 @nova_rt_any_to_str(i64 %r47)
  %r49 = call i64 @nova_rt_str_concat(i64 %r46, i64 %r48)
  %r50.p = getelementptr inbounds [1 x i8], ptr @.str.2, i64 0, i64 0
  %r50 = ptrtoint ptr %r50.p to i64
  %r51 = call i64 @nova_rt_str_concat(i64 %r49, i64 %r50)
  %r52 = call i64 @nova_rt_print_any(i64 %r51)
  %r53.p = getelementptr inbounds [6 x i8], ptr @.str.6, i64 0, i64 0
  %r53 = ptrtoint ptr %r53.p to i64
  %r54 = load i64, ptr %slot.day, align 8
  %r55 = call i64 @nova_rt_any_to_str(i64 %r54)
  %r56 = call i64 @nova_rt_str_concat(i64 %r53, i64 %r55)
  %r57.p = getelementptr inbounds [1 x i8], ptr @.str.2, i64 0, i64 0
  %r57 = ptrtoint ptr %r57.p to i64
  %r58 = call i64 @nova_rt_str_concat(i64 %r56, i64 %r57)
  %r59 = call i64 @nova_rt_print_any(i64 %r58)
  %r60.p = getelementptr inbounds [7 x i8], ptr @.str.7, i64 0, i64 0
  %r60 = ptrtoint ptr %r60.p to i64
  %r61 = load i64, ptr %slot.hour, align 8
  %r62 = call i64 @nova_rt_any_to_str(i64 %r61)
  %r63 = call i64 @nova_rt_str_concat(i64 %r60, i64 %r62)
  %r64.p = getelementptr inbounds [1 x i8], ptr @.str.2, i64 0, i64 0
  %r64 = ptrtoint ptr %r64.p to i64
  %r65 = call i64 @nova_rt_str_concat(i64 %r63, i64 %r64)
  %r66 = call i64 @nova_rt_print_any(i64 %r65)
  %r67.p = getelementptr inbounds [9 x i8], ptr @.str.8, i64 0, i64 0
  %r67 = ptrtoint ptr %r67.p to i64
  %r68 = load i64, ptr %slot.minute, align 8
  %r69 = call i64 @nova_rt_any_to_str(i64 %r68)
  %r70 = call i64 @nova_rt_str_concat(i64 %r67, i64 %r69)
  %r71.p = getelementptr inbounds [1 x i8], ptr @.str.2, i64 0, i64 0
  %r71 = ptrtoint ptr %r71.p to i64
  %r72 = call i64 @nova_rt_str_concat(i64 %r70, i64 %r71)
  %r73 = call i64 @nova_rt_print_any(i64 %r72)
  %r74.p = getelementptr inbounds [9 x i8], ptr @.str.9, i64 0, i64 0
  %r74 = ptrtoint ptr %r74.p to i64
  %r75 = load i64, ptr %slot.second, align 8
  %r76 = call i64 @nova_rt_any_to_str(i64 %r75)
  %r77 = call i64 @nova_rt_str_concat(i64 %r74, i64 %r76)
  %r78.p = getelementptr inbounds [1 x i8], ptr @.str.2, i64 0, i64 0
  %r78 = ptrtoint ptr %r78.p to i64
  %r79 = call i64 @nova_rt_str_concat(i64 %r77, i64 %r78)
  %r80 = call i64 @nova_rt_print_any(i64 %r79)
  %r81 = load i64, ptr %slot.year, align 8
  %r82 = add i64 2026, 0
  %r83.cmp = icmp sge i64 %r81, %r82
  %r83 = zext i1 %r83.cmp to i64
  %r84.p = getelementptr inbounds [23 x i8], ptr @.str.10, i64 0, i64 0
  %r84 = ptrtoint ptr %r84.p to i64
  %r85 = call i64 @nova_rt_assert(i64 %r83, i64 %r84)
  %r86 = load i64, ptr %slot.month, align 8
  %r87 = add i64 1, 0
  %r88.cmp = icmp sge i64 %r86, %r87
  %r88 = zext i1 %r88.cmp to i64
  %r89.p = getelementptr inbounds [11 x i8], ptr @.str.11, i64 0, i64 0
  %r89 = ptrtoint ptr %r89.p to i64
  %r90 = call i64 @nova_rt_assert(i64 %r88, i64 %r89)
  %r91 = load i64, ptr %slot.month, align 8
  %r92 = add i64 12, 0
  %r93.cmp = icmp sle i64 %r91, %r92
  %r93 = zext i1 %r93.cmp to i64
  %r94.p = getelementptr inbounds [12 x i8], ptr @.str.12, i64 0, i64 0
  %r94 = ptrtoint ptr %r94.p to i64
  %r95 = call i64 @nova_rt_assert(i64 %r93, i64 %r94)
  %r96 = load i64, ptr %slot.day, align 8
  %r97 = add i64 1, 0
  %r98.cmp = icmp sge i64 %r96, %r97
  %r98 = zext i1 %r98.cmp to i64
  %r99.p = getelementptr inbounds [9 x i8], ptr @.str.13, i64 0, i64 0
  %r99 = ptrtoint ptr %r99.p to i64
  %r100 = call i64 @nova_rt_assert(i64 %r98, i64 %r99)
  %r101 = load i64, ptr %slot.day, align 8
  %r102 = add i64 31, 0
  %r103.cmp = icmp sle i64 %r101, %r102
  %r103 = zext i1 %r103.cmp to i64
  %r104.p = getelementptr inbounds [10 x i8], ptr @.str.14, i64 0, i64 0
  %r104 = ptrtoint ptr %r104.p to i64
  %r105 = call i64 @nova_rt_assert(i64 %r103, i64 %r104)
  %r106 = load i64, ptr %slot.hour, align 8
  %r107 = add i64 0, 0
  %r108.cmp = icmp sge i64 %r106, %r107
  %r108 = zext i1 %r108.cmp to i64
  %r109.p = getelementptr inbounds [10 x i8], ptr @.str.15, i64 0, i64 0
  %r109 = ptrtoint ptr %r109.p to i64
  %r110 = call i64 @nova_rt_assert(i64 %r108, i64 %r109)
  %r111 = load i64, ptr %slot.hour, align 8
  %r112 = add i64 23, 0
  %r113.cmp = icmp sle i64 %r111, %r112
  %r113 = zext i1 %r113.cmp to i64
  %r114.p = getelementptr inbounds [11 x i8], ptr @.str.16, i64 0, i64 0
  %r114 = ptrtoint ptr %r114.p to i64
  %r115 = call i64 @nova_rt_assert(i64 %r113, i64 %r114)
  %r116 = load i64, ptr %slot.now, align 8
  %r117.p = getelementptr inbounds [9 x i8], ptr @.str.17, i64 0, i64 0
  %r117 = ptrtoint ptr %r117.p to i64
  %r119 = load i64, ptr %slot.datetime_format, align 8
  %r118.rec = inttoptr i64 %r119 to ptr
  %r118.fnraw = load i64, ptr %r118.rec, align 8
  %r118.fnptr = inttoptr i64 %r118.fnraw to ptr
  %r118 = call i64 %r118.fnptr(i64 %r119, i64 %r116, i64 %r117)
  store i64 %r118, ptr %slot.formatted, align 8
  %r120.p = getelementptr inbounds [12 x i8], ptr @.str.18, i64 0, i64 0
  %r120 = ptrtoint ptr %r120.p to i64
  %r121 = load i64, ptr %slot.formatted, align 8
  %r122 = call i64 @nova_rt_any_to_str(i64 %r121)
  %r123 = call i64 @nova_rt_str_concat(i64 %r120, i64 %r122)
  %r124.p = getelementptr inbounds [1 x i8], ptr @.str.2, i64 0, i64 0
  %r124 = ptrtoint ptr %r124.p to i64
  %r125 = call i64 @nova_rt_str_concat(i64 %r123, i64 %r124)
  %r126 = call i64 @nova_rt_print_any(i64 %r125)
  %r127 = load i64, ptr %slot.formatted, align 8
  %r128 = call i64 @nova_rt_len_any(i64 %r127)
  %r129 = add i64 10, 0
  %r130.cmp = icmp eq i64 %r128, %r129
  %r130 = zext i1 %r130.cmp to i64
  %r131.p = getelementptr inbounds [34 x i8], ptr @.str.19, i64 0, i64 0
  %r131 = ptrtoint ptr %r131.p to i64
  %r132 = call i64 @nova_rt_assert(i64 %r130, i64 %r131)
  %r133.p = getelementptr inbounds [26 x i8], ptr @.str.20, i64 0, i64 0
  %r133 = ptrtoint ptr %r133.p to i64
  %r134 = call i64 @nova_rt_print_any(i64 %r133)
  ret i64 %r134
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
@.str.0 = private unnamed_addr constant [27 x i8] c"time_ms should be positive\00"
@.str.1 = private unnamed_addr constant [15 x i8] c"datetime_now: \00"
@.str.2 = private unnamed_addr constant [1 x i8] c"\00"
@.str.3 = private unnamed_addr constant [33 x i8] c"datetime should be a real string\00"
@.str.4 = private unnamed_addr constant [7 x i8] c"year: \00"
@.str.5 = private unnamed_addr constant [8 x i8] c"month: \00"
@.str.6 = private unnamed_addr constant [6 x i8] c"day: \00"
@.str.7 = private unnamed_addr constant [7 x i8] c"hour: \00"
@.str.8 = private unnamed_addr constant [9 x i8] c"minute: \00"
@.str.9 = private unnamed_addr constant [9 x i8] c"second: \00"
@.str.10 = private unnamed_addr constant [23 x i8] c"year should be >= 2026\00"
@.str.11 = private unnamed_addr constant [11 x i8] c"month >= 1\00"
@.str.12 = private unnamed_addr constant [12 x i8] c"month <= 12\00"
@.str.13 = private unnamed_addr constant [9 x i8] c"day >= 1\00"
@.str.14 = private unnamed_addr constant [10 x i8] c"day <= 31\00"
@.str.15 = private unnamed_addr constant [10 x i8] c"hour >= 0\00"
@.str.16 = private unnamed_addr constant [11 x i8] c"hour <= 23\00"
@.str.17 = private unnamed_addr constant [9 x i8] c"%Y/%m/%d\00"
@.str.18 = private unnamed_addr constant [12 x i8] c"formatted: \00"
@.str.19 = private unnamed_addr constant [34 x i8] c"formatted date should be 10 chars\00"
@.str.20 = private unnamed_addr constant [26 x i8] c"all datetime tests passed\00"

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
