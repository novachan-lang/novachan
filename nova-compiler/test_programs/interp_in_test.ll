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
declare i64 @nova_rt_range(i64, i64) nounwind
declare i64 @nova_rt_sort(i64) nounwind
declare i64 @nova_rt_dict_keys(i64) nounwind
declare i64 @nova_rt_dict_values(i64) nounwind
declare i64 @nova_rt_system(i64) nounwind
declare i64 @nova_rt_exec(i64) nounwind
declare i64 @nova_rt_create_string(ptr) nounwind
declare void @nova_rt_init_args(i64, i64) nounwind
declare void @nova_rt_cleanup() nounwind

define i64 @nova_main() nounwind {
entry:
  %slot.nums = alloca i64, align 8
  store i64 0, ptr %slot.nums, align 8
  %slot.d = alloca i64, align 8
  store i64 0, ptr %slot.d, align 8
  %slot.name = alloca i64, align 8
  store i64 0, ptr %slot.name, align 8
  %slot.version = alloca i64, align 8
  store i64 0, ptr %slot.version, align 8
  %slot.a = alloca i64, align 8
  store i64 0, ptr %slot.a, align 8
  %slot.b = alloca i64, align 8
  store i64 0, ptr %slot.b, align 8
  %slot.items = alloca i64, align 8
  store i64 0, ptr %slot.items, align 8
  %slot.x = alloca i64, align 8
  store i64 0, ptr %slot.x, align 8
  %slot.y = alloca i64, align 8
  store i64 0, ptr %slot.y, align 8
  %r1 = add i64 10, 0
  %r2 = add i64 20, 0
  %r3 = add i64 30, 0
  %r4 = add i64 40, 0
  %r5 = add i64 50, 0
  %r0 = call i64 @nova_rt_list_create()
  call i64 @nova_rt_list_append(i64 %r0, i64 %r1)
  call i64 @nova_rt_list_append(i64 %r0, i64 %r2)
  call i64 @nova_rt_list_append(i64 %r0, i64 %r3)
  call i64 @nova_rt_list_append(i64 %r0, i64 %r4)
  call i64 @nova_rt_list_append(i64 %r0, i64 %r5)
  store i64 %r0, ptr %slot.nums, align 8
  %r6 = add i64 20, 0
  %r7 = load i64, ptr %slot.nums, align 8
  %r8 = call i64 @nova_rt_contains(i64 %r7, i64 %r6)
  %br_then0 = icmp ne i64 %r8, 0
  br i1 %br_then0, label %then0, label %else1
then0:
  %r9.p = getelementptr inbounds [17 x i8], ptr @.str.0, i64 0, i64 0
  %r9 = ptrtoint ptr %r9.p to i64
  %r10 = call i64 @nova_rt_print_any(i64 %r9)
  br label %endif2
else1:
  %r11.p = getelementptr inbounds [17 x i8], ptr @.str.1, i64 0, i64 0
  %r11 = ptrtoint ptr %r11.p to i64
  %r12 = call i64 @nova_rt_print_any(i64 %r11)
  br label %endif2
endif2:
  %r13 = add i64 99, 0
  %r14 = load i64, ptr %slot.nums, align 8
  %r15 = call i64 @nova_rt_contains(i64 %r14, i64 %r13)
  %br_then3 = icmp ne i64 %r15, 0
  br i1 %br_then3, label %then3, label %else4
then3:
  %r16.p = getelementptr inbounds [21 x i8], ptr @.str.2, i64 0, i64 0
  %r16 = ptrtoint ptr %r16.p to i64
  %r17 = call i64 @nova_rt_print_any(i64 %r16)
  br label %endif5
else4:
  %r18.p = getelementptr inbounds [21 x i8], ptr @.str.3, i64 0, i64 0
  %r18 = ptrtoint ptr %r18.p to i64
  %r19 = call i64 @nova_rt_print_any(i64 %r18)
  br label %endif5
endif5:
  %r20 = call i64 @nova_rt_dict_create()
  %r21.p = getelementptr inbounds [2 x i8], ptr @.str.4, i64 0, i64 0
  %r21 = ptrtoint ptr %r21.p to i64
  %r22 = add i64 1, 0
  call i64 @nova_rt_dict_set(i64 %r20, i64 %r21, i64 %r22)
  %r23.p = getelementptr inbounds [2 x i8], ptr @.str.5, i64 0, i64 0
  %r23 = ptrtoint ptr %r23.p to i64
  %r24 = add i64 2, 0
  call i64 @nova_rt_dict_set(i64 %r20, i64 %r23, i64 %r24)
  %r25.p = getelementptr inbounds [2 x i8], ptr @.str.6, i64 0, i64 0
  %r25 = ptrtoint ptr %r25.p to i64
  %r26 = add i64 3, 0
  call i64 @nova_rt_dict_set(i64 %r20, i64 %r25, i64 %r26)
  store i64 %r20, ptr %slot.d, align 8
  %r27.p = getelementptr inbounds [2 x i8], ptr @.str.5, i64 0, i64 0
  %r27 = ptrtoint ptr %r27.p to i64
  %r28 = load i64, ptr %slot.d, align 8
  %r29 = call i64 @nova_rt_contains(i64 %r28, i64 %r27)
  %br_then6 = icmp ne i64 %r29, 0
  br i1 %br_then6, label %then6, label %else7
then6:
  %r30.p = getelementptr inbounds [16 x i8], ptr @.str.7, i64 0, i64 0
  %r30 = ptrtoint ptr %r30.p to i64
  %r31 = call i64 @nova_rt_print_any(i64 %r30)
  br label %endif8
else7:
  %r32.p = getelementptr inbounds [16 x i8], ptr @.str.8, i64 0, i64 0
  %r32 = ptrtoint ptr %r32.p to i64
  %r33 = call i64 @nova_rt_print_any(i64 %r32)
  br label %endif8
endif8:
  %r34.p = getelementptr inbounds [2 x i8], ptr @.str.9, i64 0, i64 0
  %r34 = ptrtoint ptr %r34.p to i64
  %r35 = load i64, ptr %slot.d, align 8
  %r36 = call i64 @nova_rt_contains(i64 %r35, i64 %r34)
  %br_then9 = icmp ne i64 %r36, 0
  br i1 %br_then9, label %then9, label %else10
then9:
  %r37.p = getelementptr inbounds [20 x i8], ptr @.str.10, i64 0, i64 0
  %r37 = ptrtoint ptr %r37.p to i64
  %r38 = call i64 @nova_rt_print_any(i64 %r37)
  br label %endif11
else10:
  %r39.p = getelementptr inbounds [20 x i8], ptr @.str.11, i64 0, i64 0
  %r39 = ptrtoint ptr %r39.p to i64
  %r40 = call i64 @nova_rt_print_any(i64 %r39)
  br label %endif11
endif11:
  %r41.p = getelementptr inbounds [5 x i8], ptr @.str.12, i64 0, i64 0
  %r41 = ptrtoint ptr %r41.p to i64
  store i64 %r41, ptr %slot.name, align 8
  %r42 = add i64 1, 0
  store i64 %r42, ptr %slot.version, align 8
  %r43.p = getelementptr inbounds [8 x i8], ptr @.str.13, i64 0, i64 0
  %r43 = ptrtoint ptr %r43.p to i64
  %r44 = load i64, ptr %slot.name, align 8
  %r45 = call i64 @nova_rt_any_to_str(i64 %r44)
  %r46 = call i64 @nova_rt_str_concat(i64 %r43, i64 %r45)
  %r47.p = getelementptr inbounds [2 x i8], ptr @.str.14, i64 0, i64 0
  %r47 = ptrtoint ptr %r47.p to i64
  %r48 = call i64 @nova_rt_str_concat(i64 %r46, i64 %r47)
  %r49 = call i64 @nova_rt_print_any(i64 %r48)
  %r50.p = getelementptr inbounds [10 x i8], ptr @.str.15, i64 0, i64 0
  %r50 = ptrtoint ptr %r50.p to i64
  %r51 = load i64, ptr %slot.version, align 8
  %r52 = call i64 @nova_rt_any_to_str(i64 %r51)
  %r53 = call i64 @nova_rt_str_concat(i64 %r50, i64 %r52)
  %r54.p = getelementptr inbounds [1 x i8], ptr @.str.16, i64 0, i64 0
  %r54 = ptrtoint ptr %r54.p to i64
  %r55 = call i64 @nova_rt_str_concat(i64 %r53, i64 %r54)
  %r56 = call i64 @nova_rt_print_any(i64 %r55)
  %r57 = add i64 10, 0
  store i64 %r57, ptr %slot.a, align 8
  %r58 = add i64 20, 0
  store i64 %r58, ptr %slot.b, align 8
  %r59.p = getelementptr inbounds [1 x i8], ptr @.str.16, i64 0, i64 0
  %r59 = ptrtoint ptr %r59.p to i64
  %r60 = load i64, ptr %slot.a, align 8
  %r61 = call i64 @nova_rt_any_to_str(i64 %r60)
  %r62 = call i64 @nova_rt_str_concat(i64 %r59, i64 %r61)
  %r63.p = getelementptr inbounds [1 x i8], ptr @.str.16, i64 0, i64 0
  %r63 = ptrtoint ptr %r63.p to i64
  %r64 = call i64 @nova_rt_str_concat(i64 %r62, i64 %r63)
  %r65.p = getelementptr inbounds [4 x i8], ptr @.str.17, i64 0, i64 0
  %r65 = ptrtoint ptr %r65.p to i64
  %r66 = load i64, ptr %slot.b, align 8
  %r67 = call i64 @nova_rt_any_to_str(i64 %r66)
  %r68 = call i64 @nova_rt_str_concat(i64 %r65, i64 %r67)
  %r69.p = getelementptr inbounds [1 x i8], ptr @.str.16, i64 0, i64 0
  %r69 = ptrtoint ptr %r69.p to i64
  %r70 = call i64 @nova_rt_str_concat(i64 %r68, i64 %r69)
  %r71.p = getelementptr inbounds [4 x i8], ptr @.str.18, i64 0, i64 0
  %r71 = ptrtoint ptr %r71.p to i64
  %r72 = load i64, ptr %slot.a, align 8
  %r73 = load i64, ptr %slot.b, align 8
  %r74 = call i64 @nova_rt_add(i64 %r72, i64 %r73)
  %r75 = call i64 @nova_rt_any_to_str(i64 %r74)
  %r76 = call i64 @nova_rt_str_concat(i64 %r71, i64 %r75)
  %r77.p = getelementptr inbounds [1 x i8], ptr @.str.16, i64 0, i64 0
  %r77 = ptrtoint ptr %r77.p to i64
  %r78 = call i64 @nova_rt_str_concat(i64 %r76, i64 %r77)
  %r79 = call i64 @nova_rt_any_to_str(i64 %r78)
  %r80 = call i64 @nova_rt_str_concat(i64 %r70, i64 %r79)
  %r81 = call i64 @nova_rt_any_to_str(i64 %r80)
  %r82 = call i64 @nova_rt_str_concat(i64 %r64, i64 %r81)
  %r83 = call i64 @nova_rt_print_any(i64 %r82)
  %r84.p = getelementptr inbounds [9 x i8], ptr @.str.19, i64 0, i64 0
  %r84 = ptrtoint ptr %r84.p to i64
  %r85 = load i64, ptr %slot.name, align 8
  %r86 = call i64 @nova_rt_any_to_str(i64 %r85)
  %r87 = call i64 @nova_rt_str_concat(i64 %r84, i64 %r86)
  %r88.p = getelementptr inbounds [1 x i8], ptr @.str.16, i64 0, i64 0
  %r88 = ptrtoint ptr %r88.p to i64
  %r89 = call i64 @nova_rt_str_concat(i64 %r87, i64 %r88)
  %r90.p = getelementptr inbounds [10 x i8], ptr @.str.20, i64 0, i64 0
  %r90 = ptrtoint ptr %r90.p to i64
  %r91 = load i64, ptr %slot.name, align 8
  %r92 = call i64 @nova_rt_len_any(i64 %r91)
  %r93 = call i64 @nova_rt_any_to_str(i64 %r92)
  %r94 = call i64 @nova_rt_str_concat(i64 %r90, i64 %r93)
  %r95.p = getelementptr inbounds [1 x i8], ptr @.str.16, i64 0, i64 0
  %r95 = ptrtoint ptr %r95.p to i64
  %r96 = call i64 @nova_rt_str_concat(i64 %r94, i64 %r95)
  %r97 = call i64 @nova_rt_any_to_str(i64 %r96)
  %r98 = call i64 @nova_rt_str_concat(i64 %r89, i64 %r97)
  %r99 = call i64 @nova_rt_print_any(i64 %r98)
  %r101 = add i64 1, 0
  %r102 = add i64 2, 0
  %r103 = add i64 3, 0
  %r100 = call i64 @nova_rt_list_create()
  call i64 @nova_rt_list_append(i64 %r100, i64 %r101)
  call i64 @nova_rt_list_append(i64 %r100, i64 %r102)
  call i64 @nova_rt_list_append(i64 %r100, i64 %r103)
  store i64 %r100, ptr %slot.items, align 8
  %r104.p = getelementptr inbounds [8 x i8], ptr @.str.21, i64 0, i64 0
  %r104 = ptrtoint ptr %r104.p to i64
  %r105 = load i64, ptr %slot.items, align 8
  %r106 = call i64 @nova_rt_len_any(i64 %r105)
  %r107 = call i64 @nova_rt_any_to_str(i64 %r106)
  %r108 = call i64 @nova_rt_str_concat(i64 %r104, i64 %r107)
  %r109.p = getelementptr inbounds [1 x i8], ptr @.str.16, i64 0, i64 0
  %r109 = ptrtoint ptr %r109.p to i64
  %r110 = call i64 @nova_rt_str_concat(i64 %r108, i64 %r109)
  %r111 = call i64 @nova_rt_print_any(i64 %r110)
  %r112.p = getelementptr inbounds [13 x i8], ptr @.str.22, i64 0, i64 0
  %r112 = ptrtoint ptr %r112.p to i64
  %r113 = call i64 @nova_rt_print_any(i64 %r112)
  %r114.p = getelementptr inbounds [1 x i8], ptr @.str.16, i64 0, i64 0
  %r114 = ptrtoint ptr %r114.p to i64
  %r115 = add i64 42, 0
  %r116 = call i64 @nova_rt_any_to_str(i64 %r115)
  %r117 = call i64 @nova_rt_str_concat(i64 %r114, i64 %r116)
  %r118.p = getelementptr inbounds [1 x i8], ptr @.str.16, i64 0, i64 0
  %r118 = ptrtoint ptr %r118.p to i64
  %r119 = call i64 @nova_rt_str_concat(i64 %r117, i64 %r118)
  %r120 = call i64 @nova_rt_print_any(i64 %r119)
  %r121.p = getelementptr inbounds [2 x i8], ptr @.str.23, i64 0, i64 0
  %r121 = ptrtoint ptr %r121.p to i64
  store i64 %r121, ptr %slot.x, align 8
  %r122.p = getelementptr inbounds [2 x i8], ptr @.str.24, i64 0, i64 0
  %r122 = ptrtoint ptr %r122.p to i64
  store i64 %r122, ptr %slot.y, align 8
  %r123.p = getelementptr inbounds [1 x i8], ptr @.str.16, i64 0, i64 0
  %r123 = ptrtoint ptr %r123.p to i64
  %r124 = load i64, ptr %slot.x, align 8
  %r125 = call i64 @nova_rt_any_to_str(i64 %r124)
  %r126 = call i64 @nova_rt_str_concat(i64 %r123, i64 %r125)
  %r127.p = getelementptr inbounds [1 x i8], ptr @.str.16, i64 0, i64 0
  %r127 = ptrtoint ptr %r127.p to i64
  %r128 = call i64 @nova_rt_str_concat(i64 %r126, i64 %r127)
  %r129.p = getelementptr inbounds [1 x i8], ptr @.str.16, i64 0, i64 0
  %r129 = ptrtoint ptr %r129.p to i64
  %r130 = load i64, ptr %slot.y, align 8
  %r131 = call i64 @nova_rt_any_to_str(i64 %r130)
  %r132 = call i64 @nova_rt_str_concat(i64 %r129, i64 %r131)
  %r133.p = getelementptr inbounds [1 x i8], ptr @.str.16, i64 0, i64 0
  %r133 = ptrtoint ptr %r133.p to i64
  %r134 = call i64 @nova_rt_str_concat(i64 %r132, i64 %r133)
  %r135 = call i64 @nova_rt_any_to_str(i64 %r134)
  %r136 = call i64 @nova_rt_str_concat(i64 %r128, i64 %r135)
  %r137 = call i64 @nova_rt_print_any(i64 %r136)
  %r138.p = getelementptr inbounds [8 x i8], ptr @.str.25, i64 0, i64 0
  %r138 = ptrtoint ptr %r138.p to i64
  %r139 = load i64, ptr %slot.name, align 8
  %r140 = call i64 @nova_rt_upper(i64 %r139)
  %r141 = call i64 @nova_rt_any_to_str(i64 %r140)
  %r142 = call i64 @nova_rt_str_concat(i64 %r138, i64 %r141)
  %r143.p = getelementptr inbounds [1 x i8], ptr @.str.16, i64 0, i64 0
  %r143 = ptrtoint ptr %r143.p to i64
  %r144 = call i64 @nova_rt_str_concat(i64 %r142, i64 %r143)
  %r145 = call i64 @nova_rt_print_any(i64 %r144)
  %r146 = add i64 10, 0
  %r147 = load i64, ptr %slot.nums, align 8
  %r148 = call i64 @nova_rt_contains(i64 %r147, i64 %r146)
  %br_then12 = icmp ne i64 %r148, 0
  br i1 %br_then12, label %then12, label %else13
then12:
  %r149.p = getelementptr inbounds [21 x i8], ptr @.str.26, i64 0, i64 0
  %r149 = ptrtoint ptr %r149.p to i64
  %r150 = load i64, ptr %slot.nums, align 8
  %r151 = call i64 @nova_rt_len_any(i64 %r150)
  %r152 = call i64 @nova_rt_any_to_str(i64 %r151)
  %r153 = call i64 @nova_rt_str_concat(i64 %r149, i64 %r152)
  %r154.p = getelementptr inbounds [7 x i8], ptr @.str.27, i64 0, i64 0
  %r154 = ptrtoint ptr %r154.p to i64
  %r155 = call i64 @nova_rt_str_concat(i64 %r153, i64 %r154)
  %r156 = call i64 @nova_rt_print_any(i64 %r155)
  br label %endif14
else13:
  br label %endif14
endif14:
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
@.str.0 = private unnamed_addr constant [17 x i8] c"PASS: 20 in nums\00"
@.str.1 = private unnamed_addr constant [17 x i8] c"FAIL: 20 in nums\00"
@.str.2 = private unnamed_addr constant [21 x i8] c"FAIL: 99 not in nums\00"
@.str.3 = private unnamed_addr constant [21 x i8] c"PASS: 99 not in nums\00"
@.str.4 = private unnamed_addr constant [2 x i8] c"a\00"
@.str.5 = private unnamed_addr constant [2 x i8] c"b\00"
@.str.6 = private unnamed_addr constant [2 x i8] c"c\00"
@.str.7 = private unnamed_addr constant [16 x i8] c"PASS: b in dict\00"
@.str.8 = private unnamed_addr constant [16 x i8] c"FAIL: b in dict\00"
@.str.9 = private unnamed_addr constant [2 x i8] c"z\00"
@.str.10 = private unnamed_addr constant [20 x i8] c"FAIL: z not in dict\00"
@.str.11 = private unnamed_addr constant [20 x i8] c"PASS: z not in dict\00"
@.str.12 = private unnamed_addr constant [5 x i8] c"NOVA\00"
@.str.13 = private unnamed_addr constant [8 x i8] c"Hello, \00"
@.str.14 = private unnamed_addr constant [2 x i8] c"!\00"
@.str.15 = private unnamed_addr constant [10 x i8] c"Version: \00"
@.str.16 = private unnamed_addr constant [1 x i8] c"\00"
@.str.17 = private unnamed_addr constant [4 x i8] c" + \00"
@.str.18 = private unnamed_addr constant [4 x i8] c" = \00"
@.str.19 = private unnamed_addr constant [9 x i8] c"name is \00"
@.str.20 = private unnamed_addr constant [10 x i8] c", len is \00"
@.str.21 = private unnamed_addr constant [8 x i8] c"count: \00"
@.str.22 = private unnamed_addr constant [13 x i8] c"plain string\00"
@.str.23 = private unnamed_addr constant [2 x i8] c"A\00"
@.str.24 = private unnamed_addr constant [2 x i8] c"B\00"
@.str.25 = private unnamed_addr constant [8 x i8] c"upper: \00"
@.str.26 = private unnamed_addr constant [21 x i8] c"found 10 in list of \00"
@.str.27 = private unnamed_addr constant [7 x i8] c" items\00"
