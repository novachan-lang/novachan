; NOVA IR-Pipeline Compiler Output
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"

@__nova_error_flag = thread_local global i64 0
@__nova_error_msg = thread_local global i64 0

; Runtime declarations
declare i32 @puts(ptr) nounwind
declare i32 @printf(ptr, ...) nounwind
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
declare i64 @nova_rt_create_string(ptr) nounwind
declare void @nova_rt_init_args(i64, i64) nounwind
declare void @nova_rt_cleanup() nounwind

define i64 @make_point(i64 %p0, i64 %p1) nounwind {
entry:
  %slot.x = alloca i64, align 8
  store i64 %p0, ptr %slot.x, align 8
  %slot.y = alloca i64, align 8
  store i64 %p1, ptr %slot.y, align 8
  %r0 = load i64, ptr %slot.x, align 8
  %r1 = load i64, ptr %slot.y, align 8
  %r2.ptr = call ptr @nova_rt_struct_alloc(i64 16)
  %r2.f0 = getelementptr i64, ptr %r2.ptr, i64 0
  store i64 %r0, ptr %r2.f0, align 8
  %r2.f1 = getelementptr i64, ptr %r2.ptr, i64 1
  store i64 %r1, ptr %r2.f1, align 8
  %r2 = ptrtoint ptr %r2.ptr to i64
  ret i64 %r2
}

define i64 @point_sum(i64 %p0) nounwind {
entry:
  %slot.p = alloca i64, align 8
  store i64 %p0, ptr %slot.p, align 8
  %slot.x = alloca i64, align 8
  store i64 0, ptr %slot.x, align 8
  %slot.y = alloca i64, align 8
  store i64 0, ptr %slot.y, align 8
  %r0 = load i64, ptr %slot.p, align 8
  %r1.ptr = inttoptr i64 %r0 to ptr
  %r1.gep = getelementptr i64, ptr %r1.ptr, i64 0
  %r1 = load i64, ptr %r1.gep, align 8
  store i64 %r1, ptr %slot.x, align 8
  %r2.ptr = inttoptr i64 %r0 to ptr
  %r2.gep = getelementptr i64, ptr %r2.ptr, i64 1
  %r2 = load i64, ptr %r2.gep, align 8
  store i64 %r2, ptr %slot.y, align 8
  %r3 = load i64, ptr %slot.x, align 8
  %r4 = load i64, ptr %slot.y, align 8
  %r5 = call i64 @nova_rt_add(i64 %r3, i64 %r4)
  ret i64 %r5
}

define i64 @find_first_negative(i64 %p0) nounwind {
entry:
  %slot.items = alloca i64, align 8
  store i64 %p0, ptr %slot.items, align 8
  %slot.i = alloca i64, align 8
  store i64 0, ptr %slot.i, align 8
  %r0 = add i64 0, 0
  store i64 %r0, ptr %slot.i, align 8
  br label %while_hdr0
while_hdr0:
  %r1 = load i64, ptr %slot.i, align 8
  %r2 = load i64, ptr %slot.items, align 8
  %r3 = call i64 @nova_rt_len_any(i64 %r2)
  %r4.cmp = icmp slt i64 %r1, %r3
  %r4 = zext i1 %r4.cmp to i64
  %br_while_body1 = icmp ne i64 %r4, 0
  br i1 %br_while_body1, label %while_body1, label %while_exit2
while_body1:
  %r5 = load i64, ptr %slot.items, align 8
  %r6 = load i64, ptr %slot.i, align 8
  %r7 = call i64 @nova_rt_index_get(i64 %r5, i64 %r6)
  %r8 = add i64 0, 0
  %r9.cmp = icmp slt i64 %r7, %r8
  %r9 = zext i1 %r9.cmp to i64
  %br_then3 = icmp ne i64 %r9, 0
  br i1 %br_then3, label %then3, label %else4
then3:
  %r10 = load i64, ptr %slot.items, align 8
  %r11 = load i64, ptr %slot.i, align 8
  %r12 = call i64 @nova_rt_index_get(i64 %r10, i64 %r11)
  ret i64 %r12
else4:
  br label %endif5
endif5:
  %r13 = load i64, ptr %slot.i, align 8
  %r14 = add i64 1, 0
  %r15 = add i64 %r13, %r14
  store i64 %r15, ptr %slot.i, align 8
  br label %while_hdr0
while_exit2:
  %r16 = add i64 0, 0
  ret i64 %r16
}

define i64 @count_positives(i64 %p0) nounwind {
entry:
  %slot.items = alloca i64, align 8
  store i64 %p0, ptr %slot.items, align 8
  %slot.count = alloca i64, align 8
  store i64 0, ptr %slot.count, align 8
  %slot.__for_idx_6 = alloca i64, align 8
  store i64 0, ptr %slot.__for_idx_6, align 8
  %slot.item = alloca i64, align 8
  store i64 0, ptr %slot.item, align 8
  %r0 = add i64 0, 0
  store i64 %r0, ptr %slot.count, align 8
  %r1 = load i64, ptr %slot.items, align 8
  %r2 = call i64 @nova_rt_len_any(i64 %r1)
  %r3 = add i64 0, 0
  store i64 %r3, ptr %slot.__for_idx_6, align 8
  br label %for_hdr6
for_hdr6:
  %r4 = load i64, ptr %slot.__for_idx_6, align 8
  %r5.cmp = icmp slt i64 %r4, %r2
  %r5 = zext i1 %r5.cmp to i64
  %br_for_body7 = icmp ne i64 %r5, 0
  br i1 %br_for_body7, label %for_body7, label %for_exit8
for_body7:
  %r6 = call i64 @nova_rt_index_get(i64 %r1, i64 %r4)
  store i64 %r6, ptr %slot.item, align 8
  %r7 = load i64, ptr %slot.item, align 8
  %r8 = add i64 0, 0
  %r9.cmp = icmp sgt i64 %r7, %r8
  %r9 = zext i1 %r9.cmp to i64
  %br_then9 = icmp ne i64 %r9, 0
  br i1 %br_then9, label %then9, label %else10
then9:
  %r10 = load i64, ptr %slot.count, align 8
  %r11 = add i64 1, 0
  %r12 = add i64 %r10, %r11
  store i64 %r12, ptr %slot.count, align 8
  br label %endif11
else10:
  br label %endif11
endif11:
  %r13 = load i64, ptr %slot.__for_idx_6, align 8
  %r14 = add i64 1, 0
  %r15 = add i64 %r13, %r14
  store i64 %r15, ptr %slot.__for_idx_6, align 8
  br label %for_hdr6
for_exit8:
  %r16 = load i64, ptr %slot.count, align 8
  ret i64 %r16
}

define i64 @is_alpha(i64 %p0) nounwind {
entry:
  %slot.ch = alloca i64, align 8
  store i64 %p0, ptr %slot.ch, align 8
  %slot.c = alloca i64, align 8
  store i64 0, ptr %slot.c, align 8
  %slot.__sc_12 = alloca i64, align 8
  store i64 0, ptr %slot.__sc_12, align 8
  %slot.__sc_15 = alloca i64, align 8
  store i64 0, ptr %slot.__sc_15, align 8
  %slot.__sc_18 = alloca i64, align 8
  store i64 0, ptr %slot.__sc_18, align 8
  %slot.__sc_21 = alloca i64, align 8
  store i64 0, ptr %slot.__sc_21, align 8
  %r0 = load i64, ptr %slot.ch, align 8
  %r1 = call i64 @nova_rt_ord(i64 %r0)
  store i64 %r1, ptr %slot.c, align 8
  %r2 = load i64, ptr %slot.c, align 8
  %r3 = add i64 65, 0
  %r4.cmp = icmp sge i64 %r2, %r3
  %r4 = zext i1 %r4.cmp to i64
  store i64 %r4, ptr %slot.__sc_12, align 8
  %br_and_rhs13 = icmp ne i64 %r4, 0
  br i1 %br_and_rhs13, label %and_rhs13, label %and_merge14
and_rhs13:
  %r5 = load i64, ptr %slot.c, align 8
  %r6 = add i64 90, 0
  %r7.cmp = icmp sle i64 %r5, %r6
  %r7 = zext i1 %r7.cmp to i64
  store i64 %r7, ptr %slot.__sc_12, align 8
  br label %and_merge14
and_merge14:
  %r8 = load i64, ptr %slot.__sc_12, align 8
  store i64 %r8, ptr %slot.__sc_15, align 8
  %br_or_merge17 = icmp ne i64 %r8, 0
  br i1 %br_or_merge17, label %or_merge17, label %or_rhs16
or_rhs16:
  %r9 = load i64, ptr %slot.c, align 8
  %r10 = add i64 97, 0
  %r11.cmp = icmp sge i64 %r9, %r10
  %r11 = zext i1 %r11.cmp to i64
  store i64 %r11, ptr %slot.__sc_18, align 8
  %br_and_rhs19 = icmp ne i64 %r11, 0
  br i1 %br_and_rhs19, label %and_rhs19, label %and_merge20
and_rhs19:
  %r12 = load i64, ptr %slot.c, align 8
  %r13 = add i64 122, 0
  %r14.cmp = icmp sle i64 %r12, %r13
  %r14 = zext i1 %r14.cmp to i64
  store i64 %r14, ptr %slot.__sc_18, align 8
  br label %and_merge20
and_merge20:
  %r15 = load i64, ptr %slot.__sc_18, align 8
  store i64 %r15, ptr %slot.__sc_15, align 8
  br label %or_merge17
or_merge17:
  %r16 = load i64, ptr %slot.__sc_15, align 8
  store i64 %r16, ptr %slot.__sc_21, align 8
  %br_or_merge23 = icmp ne i64 %r16, 0
  br i1 %br_or_merge23, label %or_merge23, label %or_rhs22
or_rhs22:
  %r17 = load i64, ptr %slot.ch, align 8
  %r18.p = getelementptr inbounds [2 x i8], ptr @.str.0, i64 0, i64 0
  %r18 = ptrtoint ptr %r18.p to i64
  %r19 = call i64 @nova_rt_eq(i64 %r17, i64 %r18)
  store i64 %r19, ptr %slot.__sc_21, align 8
  br label %or_merge23
or_merge23:
  %r20 = load i64, ptr %slot.__sc_21, align 8
  ret i64 %r20
}

define i64 @tokenize_word(i64 %p0, i64 %p1) nounwind {
entry:
  %slot.s = alloca i64, align 8
  store i64 %p0, ptr %slot.s, align 8
  %slot.pos = alloca i64, align 8
  store i64 %p1, ptr %slot.pos, align 8
  %slot.word = alloca i64, align 8
  store i64 0, ptr %slot.word, align 8
  %slot.__sc_27 = alloca i64, align 8
  store i64 0, ptr %slot.__sc_27, align 8
  %r0.p = getelementptr inbounds [1 x i8], ptr @.str.1, i64 0, i64 0
  %r0 = ptrtoint ptr %r0.p to i64
  store i64 %r0, ptr %slot.word, align 8
  br label %while_hdr24
while_hdr24:
  %r1 = load i64, ptr %slot.pos, align 8
  %r2 = load i64, ptr %slot.s, align 8
  %r3 = call i64 @nova_rt_len_any(i64 %r2)
  %r4.cmp = icmp slt i64 %r1, %r3
  %r4 = zext i1 %r4.cmp to i64
  store i64 %r4, ptr %slot.__sc_27, align 8
  %br_and_rhs28 = icmp ne i64 %r4, 0
  br i1 %br_and_rhs28, label %and_rhs28, label %and_merge29
and_rhs28:
  %r5 = load i64, ptr %slot.s, align 8
  %r6 = load i64, ptr %slot.pos, align 8
  %r7 = call i64 @nova_rt_index_get(i64 %r5, i64 %r6)
  %r8 = call i64 @is_alpha(i64 %r7)
  store i64 %r8, ptr %slot.__sc_27, align 8
  br label %and_merge29
and_merge29:
  %r9 = load i64, ptr %slot.__sc_27, align 8
  %br_while_body25 = icmp ne i64 %r9, 0
  br i1 %br_while_body25, label %while_body25, label %while_exit26
while_body25:
  %r10 = load i64, ptr %slot.word, align 8
  %r11 = load i64, ptr %slot.s, align 8
  %r12 = load i64, ptr %slot.pos, align 8
  %r13 = call i64 @nova_rt_index_get(i64 %r11, i64 %r12)
  %r14 = call i64 @nova_rt_str_concat(i64 %r10, i64 %r13)
  store i64 %r14, ptr %slot.word, align 8
  %r15 = load i64, ptr %slot.pos, align 8
  %r16 = add i64 1, 0
  %r17 = call i64 @nova_rt_add(i64 %r15, i64 %r16)
  store i64 %r17, ptr %slot.pos, align 8
  br label %while_hdr24
while_exit26:
  %r18 = load i64, ptr %slot.word, align 8
  ret i64 %r18
}

define i64 @nova_main() nounwind {
entry:
  %slot.p = alloca i64, align 8
  store i64 0, ptr %slot.p, align 8
  %slot.nums = alloca i64, align 8
  store i64 0, ptr %slot.nums, align 8
  %slot.points = alloca i64, align 8
  store i64 0, ptr %slot.points, align 8
  %slot.total = alloca i64, align 8
  store i64 0, ptr %slot.total, align 8
  %slot.__for_idx_30 = alloca i64, align 8
  store i64 0, ptr %slot.__for_idx_30, align 8
  %slot.pt = alloca i64, align 8
  store i64 0, ptr %slot.pt, align 8
  %slot.x = alloca i64, align 8
  store i64 0, ptr %slot.x, align 8
  %slot.y = alloca i64, align 8
  store i64 0, ptr %slot.y, align 8
  %slot.found = alloca i64, align 8
  store i64 0, ptr %slot.found, align 8
  %slot.j = alloca i64, align 8
  store i64 0, ptr %slot.j, align 8
  %r0 = add i64 3, 0
  %r1 = add i64 7, 0
  %r2 = call i64 @make_point(i64 %r0, i64 %r1)
  store i64 %r2, ptr %slot.p, align 8
  %r3.p = getelementptr inbounds [12 x i8], ptr @.str.2, i64 0, i64 0
  %r3 = ptrtoint ptr %r3.p to i64
  %r4 = load i64, ptr %slot.p, align 8
  %r5 = call i64 @point_sum(i64 %r4)
  %r6 = call i64 @nova_rt_int_to_str(i64 %r5)
  %r7 = call i64 @nova_rt_str_concat(i64 %r3, i64 %r6)
  %r8 = call i64 @nova_rt_print_any(i64 %r7)
  %r10 = add i64 5, 0
  %r11 = add i64 3, 0
  %r12 = add i64 2, 0
  %r13 = sub i64 0, %r12
  %r14 = add i64 8, 0
  %r15 = add i64 1, 0
  %r16 = sub i64 0, %r15
  %r9 = call i64 @nova_rt_list_create()
  call i64 @nova_rt_list_append(i64 %r9, i64 %r10)
  call i64 @nova_rt_list_append(i64 %r9, i64 %r11)
  call i64 @nova_rt_list_append(i64 %r9, i64 %r13)
  call i64 @nova_rt_list_append(i64 %r9, i64 %r14)
  call i64 @nova_rt_list_append(i64 %r9, i64 %r16)
  store i64 %r9, ptr %slot.nums, align 8
  %r17.p = getelementptr inbounds [12 x i8], ptr @.str.3, i64 0, i64 0
  %r17 = ptrtoint ptr %r17.p to i64
  %r18 = load i64, ptr %slot.nums, align 8
  %r19 = call i64 @find_first_negative(i64 %r18)
  %r20 = call i64 @nova_rt_int_to_str(i64 %r19)
  %r21 = call i64 @nova_rt_str_concat(i64 %r17, i64 %r20)
  %r22 = call i64 @nova_rt_print_any(i64 %r21)
  %r23.p = getelementptr inbounds [12 x i8], ptr @.str.4, i64 0, i64 0
  %r23 = ptrtoint ptr %r23.p to i64
  %r24 = load i64, ptr %slot.nums, align 8
  %r25 = call i64 @count_positives(i64 %r24)
  %r26 = call i64 @nova_rt_int_to_str(i64 %r25)
  %r27 = call i64 @nova_rt_str_concat(i64 %r23, i64 %r26)
  %r28 = call i64 @nova_rt_print_any(i64 %r27)
  %r29.p = getelementptr inbounds [14 x i8], ptr @.str.5, i64 0, i64 0
  %r29 = ptrtoint ptr %r29.p to i64
  %r30.p = getelementptr inbounds [2 x i8], ptr @.str.6, i64 0, i64 0
  %r30 = ptrtoint ptr %r30.p to i64
  %r31 = call i64 @is_alpha(i64 %r30)
  %r32 = call i64 @nova_rt_int_to_str(i64 %r31)
  %r33 = call i64 @nova_rt_str_concat(i64 %r29, i64 %r32)
  %r34 = call i64 @nova_rt_print_any(i64 %r33)
  %r35.p = getelementptr inbounds [14 x i8], ptr @.str.7, i64 0, i64 0
  %r35 = ptrtoint ptr %r35.p to i64
  %r36.p = getelementptr inbounds [2 x i8], ptr @.str.8, i64 0, i64 0
  %r36 = ptrtoint ptr %r36.p to i64
  %r37 = call i64 @is_alpha(i64 %r36)
  %r38 = call i64 @nova_rt_int_to_str(i64 %r37)
  %r39 = call i64 @nova_rt_str_concat(i64 %r35, i64 %r38)
  %r40 = call i64 @nova_rt_print_any(i64 %r39)
  %r41.p = getelementptr inbounds [7 x i8], ptr @.str.9, i64 0, i64 0
  %r41 = ptrtoint ptr %r41.p to i64
  %r42.p = getelementptr inbounds [12 x i8], ptr @.str.10, i64 0, i64 0
  %r42 = ptrtoint ptr %r42.p to i64
  %r43 = add i64 0, 0
  %r44 = call i64 @tokenize_word(i64 %r42, i64 %r43)
  %r45 = call i64 @nova_rt_str_concat(i64 %r41, i64 %r44)
  %r46 = call i64 @nova_rt_print_any(i64 %r45)
  %r48 = add i64 1, 0
  %r49 = add i64 2, 0
  %r50 = call i64 @make_point(i64 %r48, i64 %r49)
  %r51 = add i64 3, 0
  %r52 = add i64 4, 0
  %r53 = call i64 @make_point(i64 %r51, i64 %r52)
  %r54 = add i64 5, 0
  %r55 = add i64 6, 0
  %r56 = call i64 @make_point(i64 %r54, i64 %r55)
  %r47 = call i64 @nova_rt_list_create()
  call i64 @nova_rt_list_append(i64 %r47, i64 %r50)
  call i64 @nova_rt_list_append(i64 %r47, i64 %r53)
  call i64 @nova_rt_list_append(i64 %r47, i64 %r56)
  store i64 %r47, ptr %slot.points, align 8
  %r57 = add i64 0, 0
  store i64 %r57, ptr %slot.total, align 8
  %r58 = load i64, ptr %slot.points, align 8
  %r59 = call i64 @nova_rt_len_any(i64 %r58)
  %r60 = add i64 0, 0
  store i64 %r60, ptr %slot.__for_idx_30, align 8
  br label %for_hdr30
for_hdr30:
  %r61 = load i64, ptr %slot.__for_idx_30, align 8
  %r62.cmp = icmp slt i64 %r61, %r59
  %r62 = zext i1 %r62.cmp to i64
  %br_for_body31 = icmp ne i64 %r62, 0
  br i1 %br_for_body31, label %for_body31, label %for_exit32
for_body31:
  %r63 = call i64 @nova_rt_index_get(i64 %r58, i64 %r61)
  store i64 %r63, ptr %slot.pt, align 8
  %r64 = load i64, ptr %slot.pt, align 8
  %r65.ptr = inttoptr i64 %r64 to ptr
  %r65.gep = getelementptr i64, ptr %r65.ptr, i64 0
  %r65 = load i64, ptr %r65.gep, align 8
  store i64 %r65, ptr %slot.x, align 8
  %r66.ptr = inttoptr i64 %r64 to ptr
  %r66.gep = getelementptr i64, ptr %r66.ptr, i64 1
  %r66 = load i64, ptr %r66.gep, align 8
  store i64 %r66, ptr %slot.y, align 8
  %r67 = load i64, ptr %slot.total, align 8
  %r68 = load i64, ptr %slot.x, align 8
  %r69 = call i64 @nova_rt_add(i64 %r67, i64 %r68)
  %r70 = load i64, ptr %slot.y, align 8
  %r71 = call i64 @nova_rt_add(i64 %r69, i64 %r70)
  store i64 %r71, ptr %slot.total, align 8
  %r72 = load i64, ptr %slot.__for_idx_30, align 8
  %r73 = add i64 1, 0
  %r74 = add i64 %r72, %r73
  store i64 %r74, ptr %slot.__for_idx_30, align 8
  br label %for_hdr30
for_exit32:
  %r75.p = getelementptr inbounds [8 x i8], ptr @.str.11, i64 0, i64 0
  %r75 = ptrtoint ptr %r75.p to i64
  %r76 = load i64, ptr %slot.total, align 8
  %r77 = call i64 @nova_rt_int_to_str(i64 %r76)
  %r78 = call i64 @nova_rt_str_concat(i64 %r75, i64 %r77)
  %r79 = call i64 @nova_rt_print_any(i64 %r78)
  %r80 = add i64 1, 0
  %r81 = sub i64 0, %r80
  store i64 %r81, ptr %slot.found, align 8
  %r82 = add i64 0, 0
  store i64 %r82, ptr %slot.j, align 8
  br label %while_hdr33
while_hdr33:
  %r83 = load i64, ptr %slot.j, align 8
  %r84 = load i64, ptr %slot.nums, align 8
  %r85 = call i64 @nova_rt_len_any(i64 %r84)
  %r86.cmp = icmp slt i64 %r83, %r85
  %r86 = zext i1 %r86.cmp to i64
  %br_while_body34 = icmp ne i64 %r86, 0
  br i1 %br_while_body34, label %while_body34, label %while_exit35
while_body34:
  %r87 = load i64, ptr %slot.nums, align 8
  %r88 = load i64, ptr %slot.j, align 8
  %r89 = call i64 @nova_rt_index_get(i64 %r87, i64 %r88)
  %r90 = add i64 0, 0
  %r91.cmp = icmp slt i64 %r89, %r90
  %r91 = zext i1 %r91.cmp to i64
  %br_then36 = icmp ne i64 %r91, 0
  br i1 %br_then36, label %then36, label %else37
then36:
  %r92 = load i64, ptr %slot.nums, align 8
  %r93 = load i64, ptr %slot.j, align 8
  %r94 = call i64 @nova_rt_index_get(i64 %r92, i64 %r93)
  store i64 %r94, ptr %slot.found, align 8
  br label %while_exit35
else37:
  br label %endif38
endif38:
  %r95 = load i64, ptr %slot.j, align 8
  %r96 = add i64 1, 0
  %r97 = add i64 %r95, %r96
  store i64 %r97, ptr %slot.j, align 8
  br label %while_hdr33
while_exit35:
  %r98.p = getelementptr inbounds [8 x i8], ptr @.str.12, i64 0, i64 0
  %r98 = ptrtoint ptr %r98.p to i64
  %r99 = load i64, ptr %slot.found, align 8
  %r100 = call i64 @nova_rt_int_to_str(i64 %r99)
  %r101 = call i64 @nova_rt_str_concat(i64 %r98, i64 %r100)
  %r102 = call i64 @nova_rt_print_any(i64 %r101)
  %r103.p = getelementptr inbounds [5 x i8], ptr @.str.13, i64 0, i64 0
  %r103 = ptrtoint ptr %r103.p to i64
  %r104 = call i64 @nova_rt_print_any(i64 %r103)
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
@.str.0 = private unnamed_addr constant [2 x i8] c"_\00"
@.str.1 = private unnamed_addr constant [1 x i8] c"\00"
@.str.2 = private unnamed_addr constant [12 x i8] c"point_sum: \00"
@.str.3 = private unnamed_addr constant [12 x i8] c"first neg: \00"
@.str.4 = private unnamed_addr constant [12 x i8] c"positives: \00"
@.str.5 = private unnamed_addr constant [14 x i8] c"is_alpha(a): \00"
@.str.6 = private unnamed_addr constant [2 x i8] c"a\00"
@.str.7 = private unnamed_addr constant [14 x i8] c"is_alpha(1): \00"
@.str.8 = private unnamed_addr constant [2 x i8] c"1\00"
@.str.9 = private unnamed_addr constant [7 x i8] c"word: \00"
@.str.10 = private unnamed_addr constant [12 x i8] c"hello world\00"
@.str.11 = private unnamed_addr constant [8 x i8] c"total: \00"
@.str.12 = private unnamed_addr constant [8 x i8] c"found: \00"
@.str.13 = private unnamed_addr constant [5 x i8] c"PASS\00"
