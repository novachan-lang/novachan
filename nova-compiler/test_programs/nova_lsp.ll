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

define i64 @json_escape(i64 %p0) nounwind {
entry:
  %slot.s = alloca i64, align 8
  store i64 %p0, ptr %slot.s, align 8
  %slot.result = alloca i64, align 8
  store i64 0, ptr %slot.result, align 8
  %slot.i = alloca i64, align 8
  store i64 0, ptr %slot.i, align 8
  %slot.ch = alloca i64, align 8
  store i64 0, ptr %slot.ch, align 8
  %r0.p = getelementptr inbounds [1 x i8], ptr @.str.0, i64 0, i64 0
  %r0 = ptrtoint ptr %r0.p to i64
  store i64 %r0, ptr %slot.result, align 8
  %r1 = add i64 0, 0
  store i64 %r1, ptr %slot.i, align 8
  br label %while_hdr0
while_hdr0:
  %r2 = load i64, ptr %slot.i, align 8
  %r3 = load i64, ptr %slot.s, align 8
  %r4 = call i64 @nova_rt_len_any(i64 %r3)
  %r5.cmp = icmp slt i64 %r2, %r4
  %r5 = zext i1 %r5.cmp to i64
  %br_while_body1 = icmp ne i64 %r5, 0
  br i1 %br_while_body1, label %while_body1, label %while_exit2
while_body1:
  %r6 = load i64, ptr %slot.s, align 8
  %r7 = load i64, ptr %slot.i, align 8
  %r8 = call i64 @nova_rt_index_get(i64 %r6, i64 %r7)
  store i64 %r8, ptr %slot.ch, align 8
  %r9 = load i64, ptr %slot.ch, align 8
  %r10.p = getelementptr inbounds [2 x i8], ptr @.str.1, i64 0, i64 0
  %r10 = ptrtoint ptr %r10.p to i64
  %r11 = call i64 @nova_rt_eq(i64 %r9, i64 %r10)
  %br_then3 = icmp ne i64 %r11, 0
  br i1 %br_then3, label %then3, label %else4
then3:
  %r12 = load i64, ptr %slot.result, align 8
  %r13.p = getelementptr inbounds [3 x i8], ptr @.str.2, i64 0, i64 0
  %r13 = ptrtoint ptr %r13.p to i64
  %r14 = call i64 @nova_rt_add(i64 %r12, i64 %r13)
  store i64 %r14, ptr %slot.result, align 8
  br label %endif5
else4:
  %r15 = load i64, ptr %slot.ch, align 8
  %r16.p = getelementptr inbounds [2 x i8], ptr @.str.3, i64 0, i64 0
  %r16 = ptrtoint ptr %r16.p to i64
  %r17 = call i64 @nova_rt_eq(i64 %r15, i64 %r16)
  %br_then6 = icmp ne i64 %r17, 0
  br i1 %br_then6, label %then6, label %else7
then6:
  %r18 = load i64, ptr %slot.result, align 8
  %r19.p = getelementptr inbounds [3 x i8], ptr @.str.4, i64 0, i64 0
  %r19 = ptrtoint ptr %r19.p to i64
  %r20 = call i64 @nova_rt_add(i64 %r18, i64 %r19)
  store i64 %r20, ptr %slot.result, align 8
  br label %endif8
else7:
  %r21 = load i64, ptr %slot.ch, align 8
  %r22.p = getelementptr inbounds [2 x i8], ptr @.str.5, i64 0, i64 0
  %r22 = ptrtoint ptr %r22.p to i64
  %r23 = call i64 @nova_rt_eq(i64 %r21, i64 %r22)
  %br_then9 = icmp ne i64 %r23, 0
  br i1 %br_then9, label %then9, label %else10
then9:
  %r24 = load i64, ptr %slot.result, align 8
  %r25.p = getelementptr inbounds [3 x i8], ptr @.str.6, i64 0, i64 0
  %r25 = ptrtoint ptr %r25.p to i64
  %r26 = call i64 @nova_rt_add(i64 %r24, i64 %r25)
  store i64 %r26, ptr %slot.result, align 8
  br label %endif11
else10:
  %r27 = load i64, ptr %slot.ch, align 8
  %r28.p = getelementptr inbounds [2 x i8], ptr @.str.7, i64 0, i64 0
  %r28 = ptrtoint ptr %r28.p to i64
  %r29 = call i64 @nova_rt_eq(i64 %r27, i64 %r28)
  %br_then12 = icmp ne i64 %r29, 0
  br i1 %br_then12, label %then12, label %else13
then12:
  %r30 = load i64, ptr %slot.result, align 8
  %r31.p = getelementptr inbounds [3 x i8], ptr @.str.8, i64 0, i64 0
  %r31 = ptrtoint ptr %r31.p to i64
  %r32 = call i64 @nova_rt_add(i64 %r30, i64 %r31)
  store i64 %r32, ptr %slot.result, align 8
  br label %endif14
else13:
  %r33 = load i64, ptr %slot.ch, align 8
  %r34.p = getelementptr inbounds [2 x i8], ptr @.str.9, i64 0, i64 0
  %r34 = ptrtoint ptr %r34.p to i64
  %r35 = call i64 @nova_rt_eq(i64 %r33, i64 %r34)
  %br_then15 = icmp ne i64 %r35, 0
  br i1 %br_then15, label %then15, label %else16
then15:
  %r36 = load i64, ptr %slot.result, align 8
  %r37.p = getelementptr inbounds [3 x i8], ptr @.str.10, i64 0, i64 0
  %r37 = ptrtoint ptr %r37.p to i64
  %r38 = call i64 @nova_rt_add(i64 %r36, i64 %r37)
  store i64 %r38, ptr %slot.result, align 8
  br label %endif17
else16:
  %r39 = load i64, ptr %slot.result, align 8
  %r40 = load i64, ptr %slot.ch, align 8
  %r41 = call i64 @nova_rt_add(i64 %r39, i64 %r40)
  store i64 %r41, ptr %slot.result, align 8
  br label %endif17
endif17:
  br label %endif14
endif14:
  br label %endif11
endif11:
  br label %endif8
endif8:
  br label %endif5
endif5:
  %r42 = load i64, ptr %slot.i, align 8
  %r43 = add i64 1, 0
  %r44 = call i64 @nova_rt_add(i64 %r42, i64 %r43)
  store i64 %r44, ptr %slot.i, align 8
  br label %while_hdr0
while_exit2:
  %r45 = load i64, ptr %slot.result, align 8
  ret i64 %r45
}

define i64 @json_str(i64 %p0, i64 %p1) nounwind {
entry:
  %slot.key = alloca i64, align 8
  store i64 %p0, ptr %slot.key, align 8
  %slot.val = alloca i64, align 8
  store i64 %p1, ptr %slot.val, align 8
  %r0.p = getelementptr inbounds [2 x i8], ptr @.str.1, i64 0, i64 0
  %r0 = ptrtoint ptr %r0.p to i64
  %r1 = load i64, ptr %slot.key, align 8
  %r2 = call i64 @nova_rt_add(i64 %r0, i64 %r1)
  %r3.p = getelementptr inbounds [4 x i8], ptr @.str.11, i64 0, i64 0
  %r3 = ptrtoint ptr %r3.p to i64
  %r4 = call i64 @nova_rt_add(i64 %r2, i64 %r3)
  %r5 = load i64, ptr %slot.val, align 8
  %r6 = call i64 @json_escape(i64 %r5)
  %r7 = call i64 @nova_rt_add(i64 %r4, i64 %r6)
  %r8.p = getelementptr inbounds [2 x i8], ptr @.str.1, i64 0, i64 0
  %r8 = ptrtoint ptr %r8.p to i64
  %r9 = call i64 @nova_rt_add(i64 %r7, i64 %r8)
  ret i64 %r9
}

define i64 @json_int(i64 %p0, i64 %p1) nounwind {
entry:
  %slot.key = alloca i64, align 8
  store i64 %p0, ptr %slot.key, align 8
  %slot.val = alloca i64, align 8
  store i64 %p1, ptr %slot.val, align 8
  %r0.p = getelementptr inbounds [2 x i8], ptr @.str.1, i64 0, i64 0
  %r0 = ptrtoint ptr %r0.p to i64
  %r1 = load i64, ptr %slot.key, align 8
  %r2 = call i64 @nova_rt_add(i64 %r0, i64 %r1)
  %r3.p = getelementptr inbounds [3 x i8], ptr @.str.12, i64 0, i64 0
  %r3 = ptrtoint ptr %r3.p to i64
  %r4 = call i64 @nova_rt_add(i64 %r2, i64 %r3)
  %r5 = load i64, ptr %slot.val, align 8
  %r6 = call i64 @nova_rt_int_to_str(i64 %r5)
  %r7 = call i64 @nova_rt_add(i64 %r4, i64 %r6)
  ret i64 %r7
}

define i64 @json_bool(i64 %p0, i64 %p1) nounwind {
entry:
  %slot.key = alloca i64, align 8
  store i64 %p0, ptr %slot.key, align 8
  %slot.val = alloca i64, align 8
  store i64 %p1, ptr %slot.val, align 8
  %r0 = load i64, ptr %slot.val, align 8
  %r1 = add i64 1, 0
  %r2 = call i64 @nova_rt_eq(i64 %r0, i64 %r1)
  %br_retthen18 = icmp ne i64 %r2, 0
  br i1 %br_retthen18, label %retthen18, label %retelse19
retthen18:
  %r3.p = getelementptr inbounds [2 x i8], ptr @.str.1, i64 0, i64 0
  %r3 = ptrtoint ptr %r3.p to i64
  %r4 = load i64, ptr %slot.key, align 8
  %r5 = call i64 @nova_rt_add(i64 %r3, i64 %r4)
  %r6.p = getelementptr inbounds [7 x i8], ptr @.str.13, i64 0, i64 0
  %r6 = ptrtoint ptr %r6.p to i64
  %r7 = call i64 @nova_rt_add(i64 %r5, i64 %r6)
  ret i64 %r7
retelse19:
  %r8.p = getelementptr inbounds [2 x i8], ptr @.str.1, i64 0, i64 0
  %r8 = ptrtoint ptr %r8.p to i64
  %r9 = load i64, ptr %slot.key, align 8
  %r10 = call i64 @nova_rt_add(i64 %r8, i64 %r9)
  %r11.p = getelementptr inbounds [8 x i8], ptr @.str.14, i64 0, i64 0
  %r11 = ptrtoint ptr %r11.p to i64
  %r12 = call i64 @nova_rt_add(i64 %r10, i64 %r11)
  ret i64 %r12
}

define i64 @json_null(i64 %p0) nounwind {
entry:
  %slot.key = alloca i64, align 8
  store i64 %p0, ptr %slot.key, align 8
  %r0.p = getelementptr inbounds [2 x i8], ptr @.str.1, i64 0, i64 0
  %r0 = ptrtoint ptr %r0.p to i64
  %r1 = load i64, ptr %slot.key, align 8
  %r2 = call i64 @nova_rt_add(i64 %r0, i64 %r1)
  %r3.p = getelementptr inbounds [7 x i8], ptr @.str.15, i64 0, i64 0
  %r3 = ptrtoint ptr %r3.p to i64
  %r4 = call i64 @nova_rt_add(i64 %r2, i64 %r3)
  ret i64 %r4
}

define i64 @json_obj(i64 %p0) nounwind {
entry:
  %slot.pairs = alloca i64, align 8
  store i64 %p0, ptr %slot.pairs, align 8
  %r0.p = getelementptr inbounds [2 x i8], ptr @.str.16, i64 0, i64 0
  %r0 = ptrtoint ptr %r0.p to i64
  %r1 = load i64, ptr %slot.pairs, align 8
  %r2.p = getelementptr inbounds [2 x i8], ptr @.str.17, i64 0, i64 0
  %r2 = ptrtoint ptr %r2.p to i64
  %r3 = call i64 @nova_rt_join(i64 %r1, i64 %r2)
  %r4 = call i64 @nova_rt_add(i64 %r0, i64 %r3)
  %r5.p = getelementptr inbounds [2 x i8], ptr @.str.18, i64 0, i64 0
  %r5 = ptrtoint ptr %r5.p to i64
  %r6 = call i64 @nova_rt_add(i64 %r4, i64 %r5)
  ret i64 %r6
}

define i64 @json_arr(i64 %p0) nounwind {
entry:
  %slot.items = alloca i64, align 8
  store i64 %p0, ptr %slot.items, align 8
  %r0.p = getelementptr inbounds [2 x i8], ptr @.str.19, i64 0, i64 0
  %r0 = ptrtoint ptr %r0.p to i64
  %r1 = load i64, ptr %slot.items, align 8
  %r2.p = getelementptr inbounds [2 x i8], ptr @.str.17, i64 0, i64 0
  %r2 = ptrtoint ptr %r2.p to i64
  %r3 = call i64 @nova_rt_join(i64 %r1, i64 %r2)
  %r4 = call i64 @nova_rt_add(i64 %r0, i64 %r3)
  %r5.p = getelementptr inbounds [2 x i8], ptr @.str.20, i64 0, i64 0
  %r5 = ptrtoint ptr %r5.p to i64
  %r6 = call i64 @nova_rt_add(i64 %r4, i64 %r5)
  ret i64 %r6
}

define i64 @skip_ws(i64 %p0, i64 %p1) nounwind {
entry:
  %slot.s = alloca i64, align 8
  store i64 %p0, ptr %slot.s, align 8
  %slot.pos = alloca i64, align 8
  store i64 %p1, ptr %slot.pos, align 8
  %slot.ch = alloca i64, align 8
  store i64 0, ptr %slot.ch, align 8
  %slot.__sc_23 = alloca i64, align 8
  store i64 0, ptr %slot.__sc_23, align 8
  %slot.__sc_26 = alloca i64, align 8
  store i64 0, ptr %slot.__sc_26, align 8
  %slot.__sc_29 = alloca i64, align 8
  store i64 0, ptr %slot.__sc_29, align 8
  br label %while_hdr20
while_hdr20:
  %r0 = load i64, ptr %slot.pos, align 8
  %r1 = load i64, ptr %slot.s, align 8
  %r2 = call i64 @nova_rt_len_any(i64 %r1)
  %r3.cmp = icmp slt i64 %r0, %r2
  %r3 = zext i1 %r3.cmp to i64
  %br_while_body21 = icmp ne i64 %r3, 0
  br i1 %br_while_body21, label %while_body21, label %while_exit22
while_body21:
  %r4 = load i64, ptr %slot.s, align 8
  %r5 = load i64, ptr %slot.pos, align 8
  %r6 = call i64 @nova_rt_index_get(i64 %r4, i64 %r5)
  store i64 %r6, ptr %slot.ch, align 8
  %r7 = load i64, ptr %slot.ch, align 8
  %r8.p = getelementptr inbounds [2 x i8], ptr @.str.21, i64 0, i64 0
  %r8 = ptrtoint ptr %r8.p to i64
  %r9 = call i64 @nova_rt_neq(i64 %r7, i64 %r8)
  store i64 %r9, ptr %slot.__sc_23, align 8
  %br_and_rhs24 = icmp ne i64 %r9, 0
  br i1 %br_and_rhs24, label %and_rhs24, label %and_merge25
and_rhs24:
  %r10 = load i64, ptr %slot.ch, align 8
  %r11.p = getelementptr inbounds [2 x i8], ptr @.str.9, i64 0, i64 0
  %r11 = ptrtoint ptr %r11.p to i64
  %r12 = call i64 @nova_rt_neq(i64 %r10, i64 %r11)
  store i64 %r12, ptr %slot.__sc_23, align 8
  br label %and_merge25
and_merge25:
  %r13 = load i64, ptr %slot.__sc_23, align 8
  store i64 %r13, ptr %slot.__sc_26, align 8
  %br_and_rhs27 = icmp ne i64 %r13, 0
  br i1 %br_and_rhs27, label %and_rhs27, label %and_merge28
and_rhs27:
  %r14 = load i64, ptr %slot.ch, align 8
  %r15.p = getelementptr inbounds [2 x i8], ptr @.str.5, i64 0, i64 0
  %r15 = ptrtoint ptr %r15.p to i64
  %r16 = call i64 @nova_rt_neq(i64 %r14, i64 %r15)
  store i64 %r16, ptr %slot.__sc_26, align 8
  br label %and_merge28
and_merge28:
  %r17 = load i64, ptr %slot.__sc_26, align 8
  store i64 %r17, ptr %slot.__sc_29, align 8
  %br_and_rhs30 = icmp ne i64 %r17, 0
  br i1 %br_and_rhs30, label %and_rhs30, label %and_merge31
and_rhs30:
  %r18 = load i64, ptr %slot.ch, align 8
  %r19.p = getelementptr inbounds [2 x i8], ptr @.str.7, i64 0, i64 0
  %r19 = ptrtoint ptr %r19.p to i64
  %r20 = call i64 @nova_rt_neq(i64 %r18, i64 %r19)
  store i64 %r20, ptr %slot.__sc_29, align 8
  br label %and_merge31
and_merge31:
  %r21 = load i64, ptr %slot.__sc_29, align 8
  %br_then32 = icmp ne i64 %r21, 0
  br i1 %br_then32, label %then32, label %else33
then32:
  %r22 = load i64, ptr %slot.pos, align 8
  ret i64 %r22
else33:
  br label %endif34
endif34:
  %r23 = load i64, ptr %slot.pos, align 8
  %r24 = add i64 1, 0
  %r25 = call i64 @nova_rt_add(i64 %r23, i64 %r24)
  store i64 %r25, ptr %slot.pos, align 8
  br label %while_hdr20
while_exit22:
  %r26 = load i64, ptr %slot.pos, align 8
  ret i64 %r26
}

define i64 @parse_json_string(i64 %p0, i64 %p1) nounwind {
entry:
  %slot.s = alloca i64, align 8
  store i64 %p0, ptr %slot.s, align 8
  %slot.pos = alloca i64, align 8
  store i64 %p1, ptr %slot.pos, align 8
  %slot.__sc_35 = alloca i64, align 8
  store i64 0, ptr %slot.__sc_35, align 8
  %slot.result = alloca i64, align 8
  store i64 0, ptr %slot.result, align 8
  %slot.ch = alloca i64, align 8
  store i64 0, ptr %slot.ch, align 8
  %slot.esc = alloca i64, align 8
  store i64 0, ptr %slot.esc, align 8
  %r0 = load i64, ptr %slot.pos, align 8
  %r1 = load i64, ptr %slot.s, align 8
  %r2 = call i64 @nova_rt_len_any(i64 %r1)
  %r3.cmp = icmp sge i64 %r0, %r2
  %r3 = zext i1 %r3.cmp to i64
  store i64 %r3, ptr %slot.__sc_35, align 8
  %br_or_merge37 = icmp ne i64 %r3, 0
  br i1 %br_or_merge37, label %or_merge37, label %or_rhs36
or_rhs36:
  %r4 = load i64, ptr %slot.s, align 8
  %r5 = load i64, ptr %slot.pos, align 8
  %r6 = call i64 @nova_rt_index_get(i64 %r4, i64 %r5)
  %r7.p = getelementptr inbounds [2 x i8], ptr @.str.1, i64 0, i64 0
  %r7 = ptrtoint ptr %r7.p to i64
  %r8 = call i64 @nova_rt_neq(i64 %r6, i64 %r7)
  store i64 %r8, ptr %slot.__sc_35, align 8
  br label %or_merge37
or_merge37:
  %r9 = load i64, ptr %slot.__sc_35, align 8
  %br_then38 = icmp ne i64 %r9, 0
  br i1 %br_then38, label %then38, label %else39
then38:
  %r11.p = getelementptr inbounds [1 x i8], ptr @.str.0, i64 0, i64 0
  %r11 = ptrtoint ptr %r11.p to i64
  %r12 = load i64, ptr %slot.pos, align 8
  %r10 = call i64 @nova_rt_list_create()
  call i64 @nova_rt_list_append(i64 %r10, i64 %r11)
  call i64 @nova_rt_list_append(i64 %r10, i64 %r12)
  ret i64 %r10
else39:
  br label %endif40
endif40:
  %r13 = load i64, ptr %slot.pos, align 8
  %r14 = add i64 1, 0
  %r15 = call i64 @nova_rt_add(i64 %r13, i64 %r14)
  store i64 %r15, ptr %slot.pos, align 8
  %r16.p = getelementptr inbounds [1 x i8], ptr @.str.0, i64 0, i64 0
  %r16 = ptrtoint ptr %r16.p to i64
  store i64 %r16, ptr %slot.result, align 8
  br label %while_hdr41
while_hdr41:
  %r17 = load i64, ptr %slot.pos, align 8
  %r18 = load i64, ptr %slot.s, align 8
  %r19 = call i64 @nova_rt_len_any(i64 %r18)
  %r20.cmp = icmp slt i64 %r17, %r19
  %r20 = zext i1 %r20.cmp to i64
  %br_while_body42 = icmp ne i64 %r20, 0
  br i1 %br_while_body42, label %while_body42, label %while_exit43
while_body42:
  %r21 = load i64, ptr %slot.s, align 8
  %r22 = load i64, ptr %slot.pos, align 8
  %r23 = call i64 @nova_rt_index_get(i64 %r21, i64 %r22)
  store i64 %r23, ptr %slot.ch, align 8
  %r24 = load i64, ptr %slot.ch, align 8
  %r25.p = getelementptr inbounds [2 x i8], ptr @.str.1, i64 0, i64 0
  %r25 = ptrtoint ptr %r25.p to i64
  %r26 = call i64 @nova_rt_eq(i64 %r24, i64 %r25)
  %br_then44 = icmp ne i64 %r26, 0
  br i1 %br_then44, label %then44, label %else45
then44:
  %r28 = load i64, ptr %slot.result, align 8
  %r29 = load i64, ptr %slot.pos, align 8
  %r30 = add i64 1, 0
  %r31 = call i64 @nova_rt_add(i64 %r29, i64 %r30)
  %r27 = call i64 @nova_rt_list_create()
  call i64 @nova_rt_list_append(i64 %r27, i64 %r28)
  call i64 @nova_rt_list_append(i64 %r27, i64 %r31)
  ret i64 %r27
else45:
  br label %endif46
endif46:
  %r32 = load i64, ptr %slot.ch, align 8
  %r33.p = getelementptr inbounds [2 x i8], ptr @.str.3, i64 0, i64 0
  %r33 = ptrtoint ptr %r33.p to i64
  %r34 = call i64 @nova_rt_eq(i64 %r32, i64 %r33)
  %br_then47 = icmp ne i64 %r34, 0
  br i1 %br_then47, label %then47, label %else48
then47:
  %r35 = load i64, ptr %slot.pos, align 8
  %r36 = add i64 1, 0
  %r37 = call i64 @nova_rt_add(i64 %r35, i64 %r36)
  store i64 %r37, ptr %slot.pos, align 8
  %r38 = load i64, ptr %slot.pos, align 8
  %r39 = load i64, ptr %slot.s, align 8
  %r40 = call i64 @nova_rt_len_any(i64 %r39)
  %r41.cmp = icmp slt i64 %r38, %r40
  %r41 = zext i1 %r41.cmp to i64
  %br_then50 = icmp ne i64 %r41, 0
  br i1 %br_then50, label %then50, label %else51
then50:
  %r42 = load i64, ptr %slot.s, align 8
  %r43 = load i64, ptr %slot.pos, align 8
  %r44 = call i64 @nova_rt_index_get(i64 %r42, i64 %r43)
  store i64 %r44, ptr %slot.esc, align 8
  %r45 = load i64, ptr %slot.esc, align 8
  %r46.p = getelementptr inbounds [2 x i8], ptr @.str.22, i64 0, i64 0
  %r46 = ptrtoint ptr %r46.p to i64
  %r47 = call i64 @nova_rt_eq(i64 %r45, i64 %r46)
  %br_then53 = icmp ne i64 %r47, 0
  br i1 %br_then53, label %then53, label %else54
then53:
  %r48 = load i64, ptr %slot.result, align 8
  %r49.p = getelementptr inbounds [2 x i8], ptr @.str.5, i64 0, i64 0
  %r49 = ptrtoint ptr %r49.p to i64
  %r50 = call i64 @nova_rt_add(i64 %r48, i64 %r49)
  store i64 %r50, ptr %slot.result, align 8
  br label %endif55
else54:
  %r51 = load i64, ptr %slot.esc, align 8
  %r52.p = getelementptr inbounds [2 x i8], ptr @.str.23, i64 0, i64 0
  %r52 = ptrtoint ptr %r52.p to i64
  %r53 = call i64 @nova_rt_eq(i64 %r51, i64 %r52)
  %br_then56 = icmp ne i64 %r53, 0
  br i1 %br_then56, label %then56, label %else57
then56:
  %r54 = load i64, ptr %slot.result, align 8
  %r55.p = getelementptr inbounds [2 x i8], ptr @.str.7, i64 0, i64 0
  %r55 = ptrtoint ptr %r55.p to i64
  %r56 = call i64 @nova_rt_add(i64 %r54, i64 %r55)
  store i64 %r56, ptr %slot.result, align 8
  br label %endif58
else57:
  %r57 = load i64, ptr %slot.esc, align 8
  %r58.p = getelementptr inbounds [2 x i8], ptr @.str.24, i64 0, i64 0
  %r58 = ptrtoint ptr %r58.p to i64
  %r59 = call i64 @nova_rt_eq(i64 %r57, i64 %r58)
  %br_then59 = icmp ne i64 %r59, 0
  br i1 %br_then59, label %then59, label %else60
then59:
  %r60 = load i64, ptr %slot.result, align 8
  %r61.p = getelementptr inbounds [2 x i8], ptr @.str.9, i64 0, i64 0
  %r61 = ptrtoint ptr %r61.p to i64
  %r62 = call i64 @nova_rt_add(i64 %r60, i64 %r61)
  store i64 %r62, ptr %slot.result, align 8
  br label %endif61
else60:
  %r63 = load i64, ptr %slot.result, align 8
  %r64 = load i64, ptr %slot.esc, align 8
  %r65 = call i64 @nova_rt_add(i64 %r63, i64 %r64)
  store i64 %r65, ptr %slot.result, align 8
  br label %endif61
endif61:
  br label %endif58
endif58:
  br label %endif55
endif55:
  br label %endif52
else51:
  br label %endif52
endif52:
  br label %endif49
else48:
  %r66 = load i64, ptr %slot.result, align 8
  %r67 = load i64, ptr %slot.ch, align 8
  %r68 = call i64 @nova_rt_add(i64 %r66, i64 %r67)
  store i64 %r68, ptr %slot.result, align 8
  br label %endif49
endif49:
  %r69 = load i64, ptr %slot.pos, align 8
  %r70 = add i64 1, 0
  %r71 = call i64 @nova_rt_add(i64 %r69, i64 %r70)
  store i64 %r71, ptr %slot.pos, align 8
  br label %while_hdr41
while_exit43:
  %r73 = load i64, ptr %slot.result, align 8
  %r74 = load i64, ptr %slot.pos, align 8
  %r72 = call i64 @nova_rt_list_create()
  call i64 @nova_rt_list_append(i64 %r72, i64 %r73)
  call i64 @nova_rt_list_append(i64 %r72, i64 %r74)
  ret i64 %r72
}

define i64 @parse_json_number(i64 %p0, i64 %p1) nounwind {
entry:
  %slot.s = alloca i64, align 8
  store i64 %p0, ptr %slot.s, align 8
  %slot.pos = alloca i64, align 8
  store i64 %p1, ptr %slot.pos, align 8
  %slot.start = alloca i64, align 8
  store i64 0, ptr %slot.start, align 8
  %slot.__sc_62 = alloca i64, align 8
  store i64 0, ptr %slot.__sc_62, align 8
  %slot.ch = alloca i64, align 8
  store i64 0, ptr %slot.ch, align 8
  %slot.__sc_71 = alloca i64, align 8
  store i64 0, ptr %slot.__sc_71, align 8
  %r0 = load i64, ptr %slot.pos, align 8
  store i64 %r0, ptr %slot.start, align 8
  %r1 = load i64, ptr %slot.pos, align 8
  %r2 = load i64, ptr %slot.s, align 8
  %r3 = call i64 @nova_rt_len_any(i64 %r2)
  %r4.cmp = icmp slt i64 %r1, %r3
  %r4 = zext i1 %r4.cmp to i64
  store i64 %r4, ptr %slot.__sc_62, align 8
  %br_and_rhs63 = icmp ne i64 %r4, 0
  br i1 %br_and_rhs63, label %and_rhs63, label %and_merge64
and_rhs63:
  %r5 = load i64, ptr %slot.s, align 8
  %r6 = load i64, ptr %slot.pos, align 8
  %r7 = call i64 @nova_rt_index_get(i64 %r5, i64 %r6)
  %r8.p = getelementptr inbounds [2 x i8], ptr @.str.25, i64 0, i64 0
  %r8 = ptrtoint ptr %r8.p to i64
  %r9 = call i64 @nova_rt_eq(i64 %r7, i64 %r8)
  store i64 %r9, ptr %slot.__sc_62, align 8
  br label %and_merge64
and_merge64:
  %r10 = load i64, ptr %slot.__sc_62, align 8
  %br_then65 = icmp ne i64 %r10, 0
  br i1 %br_then65, label %then65, label %else66
then65:
  %r11 = load i64, ptr %slot.pos, align 8
  %r12 = add i64 1, 0
  %r13 = call i64 @nova_rt_add(i64 %r11, i64 %r12)
  store i64 %r13, ptr %slot.pos, align 8
  br label %endif67
else66:
  br label %endif67
endif67:
  br label %while_hdr68
while_hdr68:
  %r14 = load i64, ptr %slot.pos, align 8
  %r15 = load i64, ptr %slot.s, align 8
  %r16 = call i64 @nova_rt_len_any(i64 %r15)
  %r17.cmp = icmp slt i64 %r14, %r16
  %r17 = zext i1 %r17.cmp to i64
  %br_while_body69 = icmp ne i64 %r17, 0
  br i1 %br_while_body69, label %while_body69, label %while_exit70
while_body69:
  %r18 = load i64, ptr %slot.s, align 8
  %r19 = load i64, ptr %slot.pos, align 8
  %r20 = call i64 @nova_rt_index_get(i64 %r18, i64 %r19)
  store i64 %r20, ptr %slot.ch, align 8
  %r21 = load i64, ptr %slot.ch, align 8
  %r22.p = getelementptr inbounds [2 x i8], ptr @.str.26, i64 0, i64 0
  %r22 = ptrtoint ptr %r22.p to i64
  %r23.cmp = icmp sge i64 %r21, %r22
  %r23 = zext i1 %r23.cmp to i64
  store i64 %r23, ptr %slot.__sc_71, align 8
  %br_and_rhs72 = icmp ne i64 %r23, 0
  br i1 %br_and_rhs72, label %and_rhs72, label %and_merge73
and_rhs72:
  %r24 = load i64, ptr %slot.ch, align 8
  %r25.p = getelementptr inbounds [2 x i8], ptr @.str.27, i64 0, i64 0
  %r25 = ptrtoint ptr %r25.p to i64
  %r26.cmp = icmp sle i64 %r24, %r25
  %r26 = zext i1 %r26.cmp to i64
  store i64 %r26, ptr %slot.__sc_71, align 8
  br label %and_merge73
and_merge73:
  %r27 = load i64, ptr %slot.__sc_71, align 8
  %br_then74 = icmp ne i64 %r27, 0
  br i1 %br_then74, label %then74, label %else75
then74:
  %r28 = load i64, ptr %slot.pos, align 8
  %r29 = add i64 1, 0
  %r30 = call i64 @nova_rt_add(i64 %r28, i64 %r29)
  store i64 %r30, ptr %slot.pos, align 8
  br label %endif76
else75:
  br label %while_exit70
endif76:
  br label %while_hdr68
while_exit70:
  %r32 = load i64, ptr %slot.s, align 8
  %r33 = load i64, ptr %slot.start, align 8
  %r34 = load i64, ptr %slot.pos, align 8
  %r35 = call i64 @nova_rt_slice(i64 %r32, i64 %r33, i64 %r34)
  %r36 = load i64, ptr %slot.pos, align 8
  %r31 = call i64 @nova_rt_list_create()
  call i64 @nova_rt_list_append(i64 %r31, i64 %r35)
  call i64 @nova_rt_list_append(i64 %r31, i64 %r36)
  ret i64 %r31
}

define i64 @extract_json_field(i64 %p0, i64 %p1) nounwind {
entry:
  %slot.json = alloca i64, align 8
  store i64 %p0, ptr %slot.json, align 8
  %slot.field = alloca i64, align 8
  store i64 %p1, ptr %slot.field, align 8
  %slot.key = alloca i64, align 8
  store i64 0, ptr %slot.key, align 8
  %slot.idx = alloca i64, align 8
  store i64 0, ptr %slot.idx, align 8
  %slot.pos = alloca i64, align 8
  store i64 0, ptr %slot.pos, align 8
  %slot.__sc_80 = alloca i64, align 8
  store i64 0, ptr %slot.__sc_80, align 8
  %slot.ch = alloca i64, align 8
  store i64 0, ptr %slot.ch, align 8
  %slot.res = alloca i64, align 8
  store i64 0, ptr %slot.res, align 8
  %slot.__sc_92 = alloca i64, align 8
  store i64 0, ptr %slot.__sc_92, align 8
  %slot.depth = alloca i64, align 8
  store i64 0, ptr %slot.depth, align 8
  %slot.start = alloca i64, align 8
  store i64 0, ptr %slot.start, align 8
  %slot.c = alloca i64, align 8
  store i64 0, ptr %slot.c, align 8
  %slot.__sc_101 = alloca i64, align 8
  store i64 0, ptr %slot.__sc_101, align 8
  %slot.__sc_107 = alloca i64, align 8
  store i64 0, ptr %slot.__sc_107, align 8
  %slot.nr = alloca i64, align 8
  store i64 0, ptr %slot.nr, align 8
  %r0.p = getelementptr inbounds [2 x i8], ptr @.str.1, i64 0, i64 0
  %r0 = ptrtoint ptr %r0.p to i64
  %r1 = load i64, ptr %slot.field, align 8
  %r2 = call i64 @nova_rt_add(i64 %r0, i64 %r1)
  %r3.p = getelementptr inbounds [2 x i8], ptr @.str.1, i64 0, i64 0
  %r3 = ptrtoint ptr %r3.p to i64
  %r4 = call i64 @nova_rt_add(i64 %r2, i64 %r3)
  store i64 %r4, ptr %slot.key, align 8
  %r5 = load i64, ptr %slot.json, align 8
  %r6 = load i64, ptr %slot.key, align 8
  %r7 = call i64 @nova_rt_find(i64 %r5, i64 %r6)
  store i64 %r7, ptr %slot.idx, align 8
  %r8 = load i64, ptr %slot.idx, align 8
  %r9 = add i64 0, 0
  %r10.cmp = icmp slt i64 %r8, %r9
  %r10 = zext i1 %r10.cmp to i64
  %br_then77 = icmp ne i64 %r10, 0
  br i1 %br_then77, label %then77, label %else78
then77:
  %r11.p = getelementptr inbounds [1 x i8], ptr @.str.0, i64 0, i64 0
  %r11 = ptrtoint ptr %r11.p to i64
  ret i64 %r11
else78:
  br label %endif79
endif79:
  %r12 = load i64, ptr %slot.idx, align 8
  %r13 = load i64, ptr %slot.key, align 8
  %r14 = call i64 @nova_rt_len_any(i64 %r13)
  %r15 = call i64 @nova_rt_add(i64 %r12, i64 %r14)
  store i64 %r15, ptr %slot.pos, align 8
  %r16 = load i64, ptr %slot.json, align 8
  %r17 = load i64, ptr %slot.pos, align 8
  %r18 = call i64 @skip_ws(i64 %r16, i64 %r17)
  store i64 %r18, ptr %slot.pos, align 8
  %r19 = load i64, ptr %slot.pos, align 8
  %r20 = load i64, ptr %slot.json, align 8
  %r21 = call i64 @nova_rt_len_any(i64 %r20)
  %r22.cmp = icmp sge i64 %r19, %r21
  %r22 = zext i1 %r22.cmp to i64
  store i64 %r22, ptr %slot.__sc_80, align 8
  %br_or_merge82 = icmp ne i64 %r22, 0
  br i1 %br_or_merge82, label %or_merge82, label %or_rhs81
or_rhs81:
  %r23 = load i64, ptr %slot.json, align 8
  %r24 = load i64, ptr %slot.pos, align 8
  %r25 = call i64 @nova_rt_index_get(i64 %r23, i64 %r24)
  %r26.p = getelementptr inbounds [2 x i8], ptr @.str.28, i64 0, i64 0
  %r26 = ptrtoint ptr %r26.p to i64
  %r27 = call i64 @nova_rt_neq(i64 %r25, i64 %r26)
  store i64 %r27, ptr %slot.__sc_80, align 8
  br label %or_merge82
or_merge82:
  %r28 = load i64, ptr %slot.__sc_80, align 8
  %br_then83 = icmp ne i64 %r28, 0
  br i1 %br_then83, label %then83, label %else84
then83:
  %r29.p = getelementptr inbounds [1 x i8], ptr @.str.0, i64 0, i64 0
  %r29 = ptrtoint ptr %r29.p to i64
  ret i64 %r29
else84:
  br label %endif85
endif85:
  %r30 = load i64, ptr %slot.json, align 8
  %r31 = load i64, ptr %slot.pos, align 8
  %r32 = add i64 1, 0
  %r33 = call i64 @nova_rt_add(i64 %r31, i64 %r32)
  %r34 = call i64 @skip_ws(i64 %r30, i64 %r33)
  store i64 %r34, ptr %slot.pos, align 8
  %r35 = load i64, ptr %slot.pos, align 8
  %r36 = load i64, ptr %slot.json, align 8
  %r37 = call i64 @nova_rt_len_any(i64 %r36)
  %r38.cmp = icmp sge i64 %r35, %r37
  %r38 = zext i1 %r38.cmp to i64
  %br_then86 = icmp ne i64 %r38, 0
  br i1 %br_then86, label %then86, label %else87
then86:
  %r39.p = getelementptr inbounds [1 x i8], ptr @.str.0, i64 0, i64 0
  %r39 = ptrtoint ptr %r39.p to i64
  ret i64 %r39
else87:
  br label %endif88
endif88:
  %r40 = load i64, ptr %slot.json, align 8
  %r41 = load i64, ptr %slot.pos, align 8
  %r42 = call i64 @nova_rt_index_get(i64 %r40, i64 %r41)
  store i64 %r42, ptr %slot.ch, align 8
  %r43 = load i64, ptr %slot.ch, align 8
  %r44.p = getelementptr inbounds [2 x i8], ptr @.str.1, i64 0, i64 0
  %r44 = ptrtoint ptr %r44.p to i64
  %r45 = call i64 @nova_rt_eq(i64 %r43, i64 %r44)
  %br_then89 = icmp ne i64 %r45, 0
  br i1 %br_then89, label %then89, label %else90
then89:
  %r46 = load i64, ptr %slot.json, align 8
  %r47 = load i64, ptr %slot.pos, align 8
  %r48 = call i64 @parse_json_string(i64 %r46, i64 %r47)
  store i64 %r48, ptr %slot.res, align 8
  %r49 = load i64, ptr %slot.res, align 8
  %r50 = add i64 0, 0
  %r51 = call i64 @nova_rt_index_get(i64 %r49, i64 %r50)
  ret i64 %r51
else90:
  br label %endif91
endif91:
  %r52 = load i64, ptr %slot.ch, align 8
  %r53.p = getelementptr inbounds [2 x i8], ptr @.str.16, i64 0, i64 0
  %r53 = ptrtoint ptr %r53.p to i64
  %r54 = call i64 @nova_rt_eq(i64 %r52, i64 %r53)
  store i64 %r54, ptr %slot.__sc_92, align 8
  %br_or_merge94 = icmp ne i64 %r54, 0
  br i1 %br_or_merge94, label %or_merge94, label %or_rhs93
or_rhs93:
  %r55 = load i64, ptr %slot.ch, align 8
  %r56.p = getelementptr inbounds [2 x i8], ptr @.str.19, i64 0, i64 0
  %r56 = ptrtoint ptr %r56.p to i64
  %r57 = call i64 @nova_rt_eq(i64 %r55, i64 %r56)
  store i64 %r57, ptr %slot.__sc_92, align 8
  br label %or_merge94
or_merge94:
  %r58 = load i64, ptr %slot.__sc_92, align 8
  %br_then95 = icmp ne i64 %r58, 0
  br i1 %br_then95, label %then95, label %else96
then95:
  %r59 = add i64 0, 0
  store i64 %r59, ptr %slot.depth, align 8
  %r60 = load i64, ptr %slot.pos, align 8
  store i64 %r60, ptr %slot.start, align 8
  br label %while_hdr98
while_hdr98:
  %r61 = load i64, ptr %slot.pos, align 8
  %r62 = load i64, ptr %slot.json, align 8
  %r63 = call i64 @nova_rt_len_any(i64 %r62)
  %r64.cmp = icmp slt i64 %r61, %r63
  %r64 = zext i1 %r64.cmp to i64
  %br_while_body99 = icmp ne i64 %r64, 0
  br i1 %br_while_body99, label %while_body99, label %while_exit100
while_body99:
  %r65 = load i64, ptr %slot.json, align 8
  %r66 = load i64, ptr %slot.pos, align 8
  %r67 = call i64 @nova_rt_index_get(i64 %r65, i64 %r66)
  store i64 %r67, ptr %slot.c, align 8
  %r68 = load i64, ptr %slot.c, align 8
  %r69.p = getelementptr inbounds [2 x i8], ptr @.str.16, i64 0, i64 0
  %r69 = ptrtoint ptr %r69.p to i64
  %r70 = call i64 @nova_rt_eq(i64 %r68, i64 %r69)
  store i64 %r70, ptr %slot.__sc_101, align 8
  %br_or_merge103 = icmp ne i64 %r70, 0
  br i1 %br_or_merge103, label %or_merge103, label %or_rhs102
or_rhs102:
  %r71 = load i64, ptr %slot.c, align 8
  %r72.p = getelementptr inbounds [2 x i8], ptr @.str.19, i64 0, i64 0
  %r72 = ptrtoint ptr %r72.p to i64
  %r73 = call i64 @nova_rt_eq(i64 %r71, i64 %r72)
  store i64 %r73, ptr %slot.__sc_101, align 8
  br label %or_merge103
or_merge103:
  %r74 = load i64, ptr %slot.__sc_101, align 8
  %br_then104 = icmp ne i64 %r74, 0
  br i1 %br_then104, label %then104, label %else105
then104:
  %r75 = load i64, ptr %slot.depth, align 8
  %r76 = add i64 1, 0
  %r77 = call i64 @nova_rt_add(i64 %r75, i64 %r76)
  store i64 %r77, ptr %slot.depth, align 8
  br label %endif106
else105:
  %r78 = load i64, ptr %slot.c, align 8
  %r79.p = getelementptr inbounds [2 x i8], ptr @.str.18, i64 0, i64 0
  %r79 = ptrtoint ptr %r79.p to i64
  %r80 = call i64 @nova_rt_eq(i64 %r78, i64 %r79)
  store i64 %r80, ptr %slot.__sc_107, align 8
  %br_or_merge109 = icmp ne i64 %r80, 0
  br i1 %br_or_merge109, label %or_merge109, label %or_rhs108
or_rhs108:
  %r81 = load i64, ptr %slot.c, align 8
  %r82.p = getelementptr inbounds [2 x i8], ptr @.str.20, i64 0, i64 0
  %r82 = ptrtoint ptr %r82.p to i64
  %r83 = call i64 @nova_rt_eq(i64 %r81, i64 %r82)
  store i64 %r83, ptr %slot.__sc_107, align 8
  br label %or_merge109
or_merge109:
  %r84 = load i64, ptr %slot.__sc_107, align 8
  %br_then110 = icmp ne i64 %r84, 0
  br i1 %br_then110, label %then110, label %else111
then110:
  %r85 = load i64, ptr %slot.depth, align 8
  %r86 = add i64 1, 0
  %r87 = sub i64 %r85, %r86
  store i64 %r87, ptr %slot.depth, align 8
  %r88 = load i64, ptr %slot.depth, align 8
  %r89 = add i64 0, 0
  %r90 = call i64 @nova_rt_eq(i64 %r88, i64 %r89)
  %br_then113 = icmp ne i64 %r90, 0
  br i1 %br_then113, label %then113, label %else114
then113:
  %r91 = load i64, ptr %slot.json, align 8
  %r92 = load i64, ptr %slot.start, align 8
  %r93 = load i64, ptr %slot.pos, align 8
  %r94 = add i64 1, 0
  %r95 = call i64 @nova_rt_add(i64 %r93, i64 %r94)
  %r96 = call i64 @nova_rt_slice(i64 %r91, i64 %r92, i64 %r95)
  ret i64 %r96
else114:
  br label %endif115
endif115:
  br label %endif112
else111:
  br label %endif112
endif112:
  br label %endif106
endif106:
  %r97 = load i64, ptr %slot.pos, align 8
  %r98 = add i64 1, 0
  %r99 = call i64 @nova_rt_add(i64 %r97, i64 %r98)
  store i64 %r99, ptr %slot.pos, align 8
  br label %while_hdr98
while_exit100:
  %r100 = load i64, ptr %slot.json, align 8
  %r101 = load i64, ptr %slot.start, align 8
  %r102 = load i64, ptr %slot.pos, align 8
  %r103 = call i64 @nova_rt_slice(i64 %r100, i64 %r101, i64 %r102)
  ret i64 %r103
else96:
  br label %endif97
endif97:
  %r104 = load i64, ptr %slot.ch, align 8
  %r105.p = getelementptr inbounds [2 x i8], ptr @.str.24, i64 0, i64 0
  %r105 = ptrtoint ptr %r105.p to i64
  %r106 = call i64 @nova_rt_eq(i64 %r104, i64 %r105)
  %br_then116 = icmp ne i64 %r106, 0
  br i1 %br_then116, label %then116, label %else117
then116:
  %r107.p = getelementptr inbounds [5 x i8], ptr @.str.29, i64 0, i64 0
  %r107 = ptrtoint ptr %r107.p to i64
  ret i64 %r107
else117:
  br label %endif118
endif118:
  %r108 = load i64, ptr %slot.ch, align 8
  %r109.p = getelementptr inbounds [2 x i8], ptr @.str.30, i64 0, i64 0
  %r109 = ptrtoint ptr %r109.p to i64
  %r110 = call i64 @nova_rt_eq(i64 %r108, i64 %r109)
  %br_then119 = icmp ne i64 %r110, 0
  br i1 %br_then119, label %then119, label %else120
then119:
  %r111.p = getelementptr inbounds [6 x i8], ptr @.str.31, i64 0, i64 0
  %r111 = ptrtoint ptr %r111.p to i64
  ret i64 %r111
else120:
  br label %endif121
endif121:
  %r112 = load i64, ptr %slot.ch, align 8
  %r113.p = getelementptr inbounds [2 x i8], ptr @.str.22, i64 0, i64 0
  %r113 = ptrtoint ptr %r113.p to i64
  %r114 = call i64 @nova_rt_eq(i64 %r112, i64 %r113)
  %br_then122 = icmp ne i64 %r114, 0
  br i1 %br_then122, label %then122, label %else123
then122:
  %r115.p = getelementptr inbounds [5 x i8], ptr @.str.32, i64 0, i64 0
  %r115 = ptrtoint ptr %r115.p to i64
  ret i64 %r115
else123:
  br label %endif124
endif124:
  %r116 = load i64, ptr %slot.json, align 8
  %r117 = load i64, ptr %slot.pos, align 8
  %r118 = call i64 @parse_json_number(i64 %r116, i64 %r117)
  store i64 %r118, ptr %slot.nr, align 8
  %r119 = load i64, ptr %slot.nr, align 8
  %r120 = add i64 0, 0
  %r121 = call i64 @nova_rt_index_get(i64 %r119, i64 %r120)
  ret i64 %r121
}

define i64 @extract_json_int(i64 %p0, i64 %p1) nounwind {
entry:
  %slot.json = alloca i64, align 8
  store i64 %p0, ptr %slot.json, align 8
  %slot.field = alloca i64, align 8
  store i64 %p1, ptr %slot.field, align 8
  %slot.val = alloca i64, align 8
  store i64 0, ptr %slot.val, align 8
  %r0 = load i64, ptr %slot.json, align 8
  %r1 = load i64, ptr %slot.field, align 8
  %r2 = call i64 @extract_json_field(i64 %r0, i64 %r1)
  store i64 %r2, ptr %slot.val, align 8
  %r3 = load i64, ptr %slot.val, align 8
  %r4 = call i64 @nova_rt_len_any(i64 %r3)
  %r5 = add i64 0, 0
  %r6.cmp = icmp sgt i64 %r4, %r5
  %r6 = zext i1 %r6.cmp to i64
  %br_then125 = icmp ne i64 %r6, 0
  br i1 %br_then125, label %then125, label %else126
then125:
  %r7 = load i64, ptr %slot.val, align 8
  %r8 = call i64 @nova_rt_parse_int(i64 %r7)
  ret i64 %r8
else126:
  br label %endif127
endif127:
  %r9 = add i64 0, 0
  ret i64 %r9
}

define i64 @lsp_send(i64 %p0) nounwind {
entry:
  %slot.msg = alloca i64, align 8
  store i64 %p0, ptr %slot.msg, align 8
  %slot.content = alloca i64, align 8
  store i64 0, ptr %slot.content, align 8
  %slot.header = alloca i64, align 8
  store i64 0, ptr %slot.header, align 8
  %r0 = load i64, ptr %slot.msg, align 8
  store i64 %r0, ptr %slot.content, align 8
  %r1.p = getelementptr inbounds [17 x i8], ptr @.str.33, i64 0, i64 0
  %r1 = ptrtoint ptr %r1.p to i64
  %r2 = load i64, ptr %slot.content, align 8
  %r3 = call i64 @nova_rt_len_any(i64 %r2)
  %r4 = call i64 @nova_rt_int_to_str(i64 %r3)
  %r5 = call i64 @nova_rt_add(i64 %r1, i64 %r4)
  %r6.p = getelementptr inbounds [5 x i8], ptr @.str.34, i64 0, i64 0
  %r6 = ptrtoint ptr %r6.p to i64
  %r7 = call i64 @nova_rt_add(i64 %r5, i64 %r6)
  store i64 %r7, ptr %slot.header, align 8
  %r8.p = getelementptr inbounds [14 x i8], ptr @.str.35, i64 0, i64 0
  %r8 = ptrtoint ptr %r8.p to i64
  %r9 = load i64, ptr %slot.header, align 8
  %r10 = call i64 @nova_rt_add(i64 %r8, i64 %r9)
  %r11 = load i64, ptr %slot.content, align 8
  %r12 = call i64 @nova_rt_add(i64 %r10, i64 %r11)
  %r13.p = getelementptr inbounds [2 x i8], ptr @.str.1, i64 0, i64 0
  %r13 = ptrtoint ptr %r13.p to i64
  %r14 = call i64 @nova_rt_add(i64 %r12, i64 %r13)
  %r15 = call i64 @nova_rt_system(i64 %r14)
  ret i64 %r15
}

define i64 @lsp_log(i64 %p0) nounwind {
entry:
  %slot.msg = alloca i64, align 8
  store i64 %p0, ptr %slot.msg, align 8
  %r0 = add i64 0, 0
  ret i64 %r0
}

define i64 @lsp_tokenize(i64 %p0) nounwind {
entry:
  %slot.source = alloca i64, align 8
  store i64 %p0, ptr %slot.source, align 8
  %slot.tokens = alloca i64, align 8
  store i64 0, ptr %slot.tokens, align 8
  %slot.pos = alloca i64, align 8
  store i64 0, ptr %slot.pos, align 8
  %slot.line = alloca i64, align 8
  store i64 0, ptr %slot.line, align 8
  %slot.col = alloca i64, align 8
  store i64 0, ptr %slot.col, align 8
  %slot.ch = alloca i64, align 8
  store i64 0, ptr %slot.ch, align 8
  %slot.__sc_131 = alloca i64, align 8
  store i64 0, ptr %slot.__sc_131, align 8
  %slot.__sc_143 = alloca i64, align 8
  store i64 0, ptr %slot.__sc_143, align 8
  %slot.__sc_146 = alloca i64, align 8
  store i64 0, ptr %slot.__sc_146, align 8
  %slot.__sc_155 = alloca i64, align 8
  store i64 0, ptr %slot.__sc_155, align 8
  %slot.start_col = alloca i64, align 8
  store i64 0, ptr %slot.start_col, align 8
  %slot.__sc_164 = alloca i64, align 8
  store i64 0, ptr %slot.__sc_164, align 8
  %slot.__sc_173 = alloca i64, align 8
  store i64 0, ptr %slot.__sc_173, align 8
  %slot.__sc_176 = alloca i64, align 8
  store i64 0, ptr %slot.__sc_176, align 8
  %slot.__sc_179 = alloca i64, align 8
  store i64 0, ptr %slot.__sc_179, align 8
  %slot.__sc_182 = alloca i64, align 8
  store i64 0, ptr %slot.__sc_182, align 8
  %slot.word = alloca i64, align 8
  store i64 0, ptr %slot.word, align 8
  %slot.wc = alloca i64, align 8
  store i64 0, ptr %slot.wc, align 8
  %slot.__sc_191 = alloca i64, align 8
  store i64 0, ptr %slot.__sc_191, align 8
  %slot.__sc_194 = alloca i64, align 8
  store i64 0, ptr %slot.__sc_194, align 8
  %slot.__sc_197 = alloca i64, align 8
  store i64 0, ptr %slot.__sc_197, align 8
  %slot.__sc_200 = alloca i64, align 8
  store i64 0, ptr %slot.__sc_200, align 8
  %slot.__sc_203 = alloca i64, align 8
  store i64 0, ptr %slot.__sc_203, align 8
  %slot.__sc_206 = alloca i64, align 8
  store i64 0, ptr %slot.__sc_206, align 8
  %slot.__sc_212 = alloca i64, align 8
  store i64 0, ptr %slot.__sc_212, align 8
  %slot.__sc_221 = alloca i64, align 8
  store i64 0, ptr %slot.__sc_221, align 8
  %slot.__sc_224 = alloca i64, align 8
  store i64 0, ptr %slot.__sc_224, align 8
  %r0 = call i64 @nova_rt_list_create()
  store i64 %r0, ptr %slot.tokens, align 8
  %r1 = add i64 0, 0
  store i64 %r1, ptr %slot.pos, align 8
  %r2 = add i64 0, 0
  store i64 %r2, ptr %slot.line, align 8
  %r3 = add i64 0, 0
  store i64 %r3, ptr %slot.col, align 8
  br label %while_hdr128
while_hdr128:
  %r4 = load i64, ptr %slot.pos, align 8
  %r5 = load i64, ptr %slot.source, align 8
  %r6 = call i64 @nova_rt_len_any(i64 %r5)
  %r7.cmp = icmp slt i64 %r4, %r6
  %r7 = zext i1 %r7.cmp to i64
  %br_while_body129 = icmp ne i64 %r7, 0
  br i1 %br_while_body129, label %while_body129, label %while_exit130
while_body129:
  %r8 = load i64, ptr %slot.source, align 8
  %r9 = load i64, ptr %slot.pos, align 8
  %r10 = call i64 @nova_rt_index_get(i64 %r8, i64 %r9)
  store i64 %r10, ptr %slot.ch, align 8
  %r11 = load i64, ptr %slot.ch, align 8
  %r12.p = getelementptr inbounds [2 x i8], ptr @.str.21, i64 0, i64 0
  %r12 = ptrtoint ptr %r12.p to i64
  %r13 = call i64 @nova_rt_eq(i64 %r11, i64 %r12)
  store i64 %r13, ptr %slot.__sc_131, align 8
  %br_or_merge133 = icmp ne i64 %r13, 0
  br i1 %br_or_merge133, label %or_merge133, label %or_rhs132
or_rhs132:
  %r14 = load i64, ptr %slot.ch, align 8
  %r15.p = getelementptr inbounds [2 x i8], ptr @.str.9, i64 0, i64 0
  %r15 = ptrtoint ptr %r15.p to i64
  %r16 = call i64 @nova_rt_eq(i64 %r14, i64 %r15)
  store i64 %r16, ptr %slot.__sc_131, align 8
  br label %or_merge133
or_merge133:
  %r17 = load i64, ptr %slot.__sc_131, align 8
  %br_then134 = icmp ne i64 %r17, 0
  br i1 %br_then134, label %then134, label %else135
then134:
  %r18 = load i64, ptr %slot.pos, align 8
  %r19 = add i64 1, 0
  %r20 = call i64 @nova_rt_add(i64 %r18, i64 %r19)
  store i64 %r20, ptr %slot.pos, align 8
  %r21 = load i64, ptr %slot.col, align 8
  %r22 = add i64 1, 0
  %r23 = call i64 @nova_rt_add(i64 %r21, i64 %r22)
  store i64 %r23, ptr %slot.col, align 8
  br label %while_hdr128
else135:
  br label %endif136
endif136:
  %r24 = load i64, ptr %slot.ch, align 8
  %r25.p = getelementptr inbounds [2 x i8], ptr @.str.5, i64 0, i64 0
  %r25 = ptrtoint ptr %r25.p to i64
  %r26 = call i64 @nova_rt_eq(i64 %r24, i64 %r25)
  %br_then137 = icmp ne i64 %r26, 0
  br i1 %br_then137, label %then137, label %else138
then137:
  %r27 = load i64, ptr %slot.pos, align 8
  %r28 = add i64 1, 0
  %r29 = call i64 @nova_rt_add(i64 %r27, i64 %r28)
  store i64 %r29, ptr %slot.pos, align 8
  %r30 = load i64, ptr %slot.line, align 8
  %r31 = add i64 1, 0
  %r32 = call i64 @nova_rt_add(i64 %r30, i64 %r31)
  store i64 %r32, ptr %slot.line, align 8
  %r33 = add i64 0, 0
  store i64 %r33, ptr %slot.col, align 8
  br label %while_hdr128
else138:
  br label %endif139
endif139:
  %r34 = load i64, ptr %slot.ch, align 8
  %r35.p = getelementptr inbounds [2 x i8], ptr @.str.7, i64 0, i64 0
  %r35 = ptrtoint ptr %r35.p to i64
  %r36 = call i64 @nova_rt_eq(i64 %r34, i64 %r35)
  %br_then140 = icmp ne i64 %r36, 0
  br i1 %br_then140, label %then140, label %else141
then140:
  %r37 = load i64, ptr %slot.pos, align 8
  %r38 = add i64 1, 0
  %r39 = call i64 @nova_rt_add(i64 %r37, i64 %r38)
  store i64 %r39, ptr %slot.pos, align 8
  br label %while_hdr128
else141:
  br label %endif142
endif142:
  %r40 = load i64, ptr %slot.ch, align 8
  %r41.p = getelementptr inbounds [2 x i8], ptr @.str.36, i64 0, i64 0
  %r41 = ptrtoint ptr %r41.p to i64
  %r42 = call i64 @nova_rt_eq(i64 %r40, i64 %r41)
  store i64 %r42, ptr %slot.__sc_143, align 8
  %br_and_rhs144 = icmp ne i64 %r42, 0
  br i1 %br_and_rhs144, label %and_rhs144, label %and_merge145
and_rhs144:
  %r43 = load i64, ptr %slot.pos, align 8
  %r44 = add i64 1, 0
  %r45 = call i64 @nova_rt_add(i64 %r43, i64 %r44)
  %r46 = load i64, ptr %slot.source, align 8
  %r47 = call i64 @nova_rt_len_any(i64 %r46)
  %r48.cmp = icmp slt i64 %r45, %r47
  %r48 = zext i1 %r48.cmp to i64
  store i64 %r48, ptr %slot.__sc_143, align 8
  br label %and_merge145
and_merge145:
  %r49 = load i64, ptr %slot.__sc_143, align 8
  store i64 %r49, ptr %slot.__sc_146, align 8
  %br_and_rhs147 = icmp ne i64 %r49, 0
  br i1 %br_and_rhs147, label %and_rhs147, label %and_merge148
and_rhs147:
  %r50 = load i64, ptr %slot.source, align 8
  %r51 = load i64, ptr %slot.pos, align 8
  %r52 = add i64 1, 0
  %r53 = call i64 @nova_rt_add(i64 %r51, i64 %r52)
  %r54 = call i64 @nova_rt_index_get(i64 %r50, i64 %r53)
  %r55.p = getelementptr inbounds [2 x i8], ptr @.str.36, i64 0, i64 0
  %r55 = ptrtoint ptr %r55.p to i64
  %r56 = call i64 @nova_rt_eq(i64 %r54, i64 %r55)
  store i64 %r56, ptr %slot.__sc_146, align 8
  br label %and_merge148
and_merge148:
  %r57 = load i64, ptr %slot.__sc_146, align 8
  %br_then149 = icmp ne i64 %r57, 0
  br i1 %br_then149, label %then149, label %else150
then149:
  br label %while_hdr152
while_hdr152:
  %r58 = load i64, ptr %slot.pos, align 8
  %r59 = load i64, ptr %slot.source, align 8
  %r60 = call i64 @nova_rt_len_any(i64 %r59)
  %r61.cmp = icmp slt i64 %r58, %r60
  %r61 = zext i1 %r61.cmp to i64
  store i64 %r61, ptr %slot.__sc_155, align 8
  %br_and_rhs156 = icmp ne i64 %r61, 0
  br i1 %br_and_rhs156, label %and_rhs156, label %and_merge157
and_rhs156:
  %r62 = load i64, ptr %slot.source, align 8
  %r63 = load i64, ptr %slot.pos, align 8
  %r64 = call i64 @nova_rt_index_get(i64 %r62, i64 %r63)
  %r65.p = getelementptr inbounds [2 x i8], ptr @.str.5, i64 0, i64 0
  %r65 = ptrtoint ptr %r65.p to i64
  %r66 = call i64 @nova_rt_neq(i64 %r64, i64 %r65)
  store i64 %r66, ptr %slot.__sc_155, align 8
  br label %and_merge157
and_merge157:
  %r67 = load i64, ptr %slot.__sc_155, align 8
  %br_while_body153 = icmp ne i64 %r67, 0
  br i1 %br_while_body153, label %while_body153, label %while_exit154
while_body153:
  %r68 = load i64, ptr %slot.pos, align 8
  %r69 = add i64 1, 0
  %r70 = call i64 @nova_rt_add(i64 %r68, i64 %r69)
  store i64 %r70, ptr %slot.pos, align 8
  br label %while_hdr152
while_exit154:
  br label %while_hdr128
else150:
  br label %endif151
endif151:
  %r71 = load i64, ptr %slot.ch, align 8
  %r72.p = getelementptr inbounds [2 x i8], ptr @.str.1, i64 0, i64 0
  %r72 = ptrtoint ptr %r72.p to i64
  %r73 = call i64 @nova_rt_eq(i64 %r71, i64 %r72)
  %br_then158 = icmp ne i64 %r73, 0
  br i1 %br_then158, label %then158, label %else159
then158:
  %r74 = load i64, ptr %slot.col, align 8
  store i64 %r74, ptr %slot.start_col, align 8
  %r75 = load i64, ptr %slot.pos, align 8
  %r76 = add i64 1, 0
  %r77 = call i64 @nova_rt_add(i64 %r75, i64 %r76)
  store i64 %r77, ptr %slot.pos, align 8
  %r78 = load i64, ptr %slot.col, align 8
  %r79 = add i64 1, 0
  %r80 = call i64 @nova_rt_add(i64 %r78, i64 %r79)
  store i64 %r80, ptr %slot.col, align 8
  br label %while_hdr161
while_hdr161:
  %r81 = load i64, ptr %slot.pos, align 8
  %r82 = load i64, ptr %slot.source, align 8
  %r83 = call i64 @nova_rt_len_any(i64 %r82)
  %r84.cmp = icmp slt i64 %r81, %r83
  %r84 = zext i1 %r84.cmp to i64
  store i64 %r84, ptr %slot.__sc_164, align 8
  %br_and_rhs165 = icmp ne i64 %r84, 0
  br i1 %br_and_rhs165, label %and_rhs165, label %and_merge166
and_rhs165:
  %r85 = load i64, ptr %slot.source, align 8
  %r86 = load i64, ptr %slot.pos, align 8
  %r87 = call i64 @nova_rt_index_get(i64 %r85, i64 %r86)
  %r88.p = getelementptr inbounds [2 x i8], ptr @.str.1, i64 0, i64 0
  %r88 = ptrtoint ptr %r88.p to i64
  %r89 = call i64 @nova_rt_neq(i64 %r87, i64 %r88)
  store i64 %r89, ptr %slot.__sc_164, align 8
  br label %and_merge166
and_merge166:
  %r90 = load i64, ptr %slot.__sc_164, align 8
  %br_while_body162 = icmp ne i64 %r90, 0
  br i1 %br_while_body162, label %while_body162, label %while_exit163
while_body162:
  %r91 = load i64, ptr %slot.source, align 8
  %r92 = load i64, ptr %slot.pos, align 8
  %r93 = call i64 @nova_rt_index_get(i64 %r91, i64 %r92)
  %r94.p = getelementptr inbounds [2 x i8], ptr @.str.3, i64 0, i64 0
  %r94 = ptrtoint ptr %r94.p to i64
  %r95 = call i64 @nova_rt_eq(i64 %r93, i64 %r94)
  %br_then167 = icmp ne i64 %r95, 0
  br i1 %br_then167, label %then167, label %else168
then167:
  %r96 = load i64, ptr %slot.pos, align 8
  %r97 = add i64 1, 0
  %r98 = call i64 @nova_rt_add(i64 %r96, i64 %r97)
  store i64 %r98, ptr %slot.pos, align 8
  %r99 = load i64, ptr %slot.col, align 8
  %r100 = add i64 1, 0
  %r101 = call i64 @nova_rt_add(i64 %r99, i64 %r100)
  store i64 %r101, ptr %slot.col, align 8
  br label %endif169
else168:
  br label %endif169
endif169:
  %r102 = load i64, ptr %slot.pos, align 8
  %r103 = add i64 1, 0
  %r104 = call i64 @nova_rt_add(i64 %r102, i64 %r103)
  store i64 %r104, ptr %slot.pos, align 8
  %r105 = load i64, ptr %slot.col, align 8
  %r106 = add i64 1, 0
  %r107 = call i64 @nova_rt_add(i64 %r105, i64 %r106)
  store i64 %r107, ptr %slot.col, align 8
  br label %while_hdr161
while_exit163:
  %r108 = load i64, ptr %slot.pos, align 8
  %r109 = load i64, ptr %slot.source, align 8
  %r110 = call i64 @nova_rt_len_any(i64 %r109)
  %r111.cmp = icmp slt i64 %r108, %r110
  %r111 = zext i1 %r111.cmp to i64
  %br_then170 = icmp ne i64 %r111, 0
  br i1 %br_then170, label %then170, label %else171
then170:
  %r112 = load i64, ptr %slot.pos, align 8
  %r113 = add i64 1, 0
  %r114 = call i64 @nova_rt_add(i64 %r112, i64 %r113)
  store i64 %r114, ptr %slot.pos, align 8
  %r115 = load i64, ptr %slot.col, align 8
  %r116 = add i64 1, 0
  %r117 = call i64 @nova_rt_add(i64 %r115, i64 %r116)
  store i64 %r117, ptr %slot.col, align 8
  br label %endif172
else171:
  br label %endif172
endif172:
  %r118 = load i64, ptr %slot.tokens, align 8
  %r120 = load i64, ptr %slot.line, align 8
  %r121 = load i64, ptr %slot.start_col, align 8
  %r122.p = getelementptr inbounds [7 x i8], ptr @.str.37, i64 0, i64 0
  %r122 = ptrtoint ptr %r122.p to i64
  %r119 = call i64 @nova_rt_list_create()
  call i64 @nova_rt_list_append(i64 %r119, i64 %r120)
  call i64 @nova_rt_list_append(i64 %r119, i64 %r121)
  call i64 @nova_rt_list_append(i64 %r119, i64 %r122)
  %r123 = call i64 @nova_rt_list_append(i64 %r118, i64 %r119)
  br label %while_hdr128
else159:
  br label %endif160
endif160:
  %r124 = load i64, ptr %slot.ch, align 8
  %r125.p = getelementptr inbounds [2 x i8], ptr @.str.38, i64 0, i64 0
  %r125 = ptrtoint ptr %r125.p to i64
  %r126.cmp = icmp sge i64 %r124, %r125
  %r126 = zext i1 %r126.cmp to i64
  store i64 %r126, ptr %slot.__sc_173, align 8
  %br_and_rhs174 = icmp ne i64 %r126, 0
  br i1 %br_and_rhs174, label %and_rhs174, label %and_merge175
and_rhs174:
  %r127 = load i64, ptr %slot.ch, align 8
  %r128.p = getelementptr inbounds [2 x i8], ptr @.str.39, i64 0, i64 0
  %r128 = ptrtoint ptr %r128.p to i64
  %r129.cmp = icmp sle i64 %r127, %r128
  %r129 = zext i1 %r129.cmp to i64
  store i64 %r129, ptr %slot.__sc_173, align 8
  br label %and_merge175
and_merge175:
  %r130 = load i64, ptr %slot.__sc_173, align 8
  store i64 %r130, ptr %slot.__sc_176, align 8
  %br_or_merge178 = icmp ne i64 %r130, 0
  br i1 %br_or_merge178, label %or_merge178, label %or_rhs177
or_rhs177:
  %r131 = load i64, ptr %slot.ch, align 8
  %r132.p = getelementptr inbounds [2 x i8], ptr @.str.40, i64 0, i64 0
  %r132 = ptrtoint ptr %r132.p to i64
  %r133.cmp = icmp sge i64 %r131, %r132
  %r133 = zext i1 %r133.cmp to i64
  store i64 %r133, ptr %slot.__sc_179, align 8
  %br_and_rhs180 = icmp ne i64 %r133, 0
  br i1 %br_and_rhs180, label %and_rhs180, label %and_merge181
and_rhs180:
  %r134 = load i64, ptr %slot.ch, align 8
  %r135.p = getelementptr inbounds [2 x i8], ptr @.str.41, i64 0, i64 0
  %r135 = ptrtoint ptr %r135.p to i64
  %r136.cmp = icmp sle i64 %r134, %r135
  %r136 = zext i1 %r136.cmp to i64
  store i64 %r136, ptr %slot.__sc_179, align 8
  br label %and_merge181
and_merge181:
  %r137 = load i64, ptr %slot.__sc_179, align 8
  store i64 %r137, ptr %slot.__sc_176, align 8
  br label %or_merge178
or_merge178:
  %r138 = load i64, ptr %slot.__sc_176, align 8
  store i64 %r138, ptr %slot.__sc_182, align 8
  %br_or_merge184 = icmp ne i64 %r138, 0
  br i1 %br_or_merge184, label %or_merge184, label %or_rhs183
or_rhs183:
  %r139 = load i64, ptr %slot.ch, align 8
  %r140.p = getelementptr inbounds [2 x i8], ptr @.str.42, i64 0, i64 0
  %r140 = ptrtoint ptr %r140.p to i64
  %r141 = call i64 @nova_rt_eq(i64 %r139, i64 %r140)
  store i64 %r141, ptr %slot.__sc_182, align 8
  br label %or_merge184
or_merge184:
  %r142 = load i64, ptr %slot.__sc_182, align 8
  %br_then185 = icmp ne i64 %r142, 0
  br i1 %br_then185, label %then185, label %else186
then185:
  %r143 = load i64, ptr %slot.col, align 8
  store i64 %r143, ptr %slot.start_col, align 8
  %r144.p = getelementptr inbounds [1 x i8], ptr @.str.0, i64 0, i64 0
  %r144 = ptrtoint ptr %r144.p to i64
  store i64 %r144, ptr %slot.word, align 8
  br label %while_hdr188
while_hdr188:
  %r145 = load i64, ptr %slot.pos, align 8
  %r146 = load i64, ptr %slot.source, align 8
  %r147 = call i64 @nova_rt_len_any(i64 %r146)
  %r148.cmp = icmp slt i64 %r145, %r147
  %r148 = zext i1 %r148.cmp to i64
  %br_while_body189 = icmp ne i64 %r148, 0
  br i1 %br_while_body189, label %while_body189, label %while_exit190
while_body189:
  %r149 = load i64, ptr %slot.source, align 8
  %r150 = load i64, ptr %slot.pos, align 8
  %r151 = call i64 @nova_rt_index_get(i64 %r149, i64 %r150)
  store i64 %r151, ptr %slot.wc, align 8
  %r152 = load i64, ptr %slot.wc, align 8
  %r153.p = getelementptr inbounds [2 x i8], ptr @.str.38, i64 0, i64 0
  %r153 = ptrtoint ptr %r153.p to i64
  %r154.cmp = icmp sge i64 %r152, %r153
  %r154 = zext i1 %r154.cmp to i64
  store i64 %r154, ptr %slot.__sc_191, align 8
  %br_and_rhs192 = icmp ne i64 %r154, 0
  br i1 %br_and_rhs192, label %and_rhs192, label %and_merge193
and_rhs192:
  %r155 = load i64, ptr %slot.wc, align 8
  %r156.p = getelementptr inbounds [2 x i8], ptr @.str.39, i64 0, i64 0
  %r156 = ptrtoint ptr %r156.p to i64
  %r157.cmp = icmp sle i64 %r155, %r156
  %r157 = zext i1 %r157.cmp to i64
  store i64 %r157, ptr %slot.__sc_191, align 8
  br label %and_merge193
and_merge193:
  %r158 = load i64, ptr %slot.__sc_191, align 8
  store i64 %r158, ptr %slot.__sc_194, align 8
  %br_or_merge196 = icmp ne i64 %r158, 0
  br i1 %br_or_merge196, label %or_merge196, label %or_rhs195
or_rhs195:
  %r159 = load i64, ptr %slot.wc, align 8
  %r160.p = getelementptr inbounds [2 x i8], ptr @.str.40, i64 0, i64 0
  %r160 = ptrtoint ptr %r160.p to i64
  %r161.cmp = icmp sge i64 %r159, %r160
  %r161 = zext i1 %r161.cmp to i64
  store i64 %r161, ptr %slot.__sc_197, align 8
  %br_and_rhs198 = icmp ne i64 %r161, 0
  br i1 %br_and_rhs198, label %and_rhs198, label %and_merge199
and_rhs198:
  %r162 = load i64, ptr %slot.wc, align 8
  %r163.p = getelementptr inbounds [2 x i8], ptr @.str.41, i64 0, i64 0
  %r163 = ptrtoint ptr %r163.p to i64
  %r164.cmp = icmp sle i64 %r162, %r163
  %r164 = zext i1 %r164.cmp to i64
  store i64 %r164, ptr %slot.__sc_197, align 8
  br label %and_merge199
and_merge199:
  %r165 = load i64, ptr %slot.__sc_197, align 8
  store i64 %r165, ptr %slot.__sc_194, align 8
  br label %or_merge196
or_merge196:
  %r166 = load i64, ptr %slot.__sc_194, align 8
  store i64 %r166, ptr %slot.__sc_200, align 8
  %br_or_merge202 = icmp ne i64 %r166, 0
  br i1 %br_or_merge202, label %or_merge202, label %or_rhs201
or_rhs201:
  %r167 = load i64, ptr %slot.wc, align 8
  %r168.p = getelementptr inbounds [2 x i8], ptr @.str.26, i64 0, i64 0
  %r168 = ptrtoint ptr %r168.p to i64
  %r169.cmp = icmp sge i64 %r167, %r168
  %r169 = zext i1 %r169.cmp to i64
  store i64 %r169, ptr %slot.__sc_203, align 8
  %br_and_rhs204 = icmp ne i64 %r169, 0
  br i1 %br_and_rhs204, label %and_rhs204, label %and_merge205
and_rhs204:
  %r170 = load i64, ptr %slot.wc, align 8
  %r171.p = getelementptr inbounds [2 x i8], ptr @.str.27, i64 0, i64 0
  %r171 = ptrtoint ptr %r171.p to i64
  %r172.cmp = icmp sle i64 %r170, %r171
  %r172 = zext i1 %r172.cmp to i64
  store i64 %r172, ptr %slot.__sc_203, align 8
  br label %and_merge205
and_merge205:
  %r173 = load i64, ptr %slot.__sc_203, align 8
  store i64 %r173, ptr %slot.__sc_200, align 8
  br label %or_merge202
or_merge202:
  %r174 = load i64, ptr %slot.__sc_200, align 8
  store i64 %r174, ptr %slot.__sc_206, align 8
  %br_or_merge208 = icmp ne i64 %r174, 0
  br i1 %br_or_merge208, label %or_merge208, label %or_rhs207
or_rhs207:
  %r175 = load i64, ptr %slot.wc, align 8
  %r176.p = getelementptr inbounds [2 x i8], ptr @.str.42, i64 0, i64 0
  %r176 = ptrtoint ptr %r176.p to i64
  %r177 = call i64 @nova_rt_eq(i64 %r175, i64 %r176)
  store i64 %r177, ptr %slot.__sc_206, align 8
  br label %or_merge208
or_merge208:
  %r178 = load i64, ptr %slot.__sc_206, align 8
  %br_then209 = icmp ne i64 %r178, 0
  br i1 %br_then209, label %then209, label %else210
then209:
  %r179 = load i64, ptr %slot.word, align 8
  %r180 = load i64, ptr %slot.wc, align 8
  %r181 = call i64 @nova_rt_add(i64 %r179, i64 %r180)
  store i64 %r181, ptr %slot.word, align 8
  %r182 = load i64, ptr %slot.pos, align 8
  %r183 = add i64 1, 0
  %r184 = call i64 @nova_rt_add(i64 %r182, i64 %r183)
  store i64 %r184, ptr %slot.pos, align 8
  %r185 = load i64, ptr %slot.col, align 8
  %r186 = add i64 1, 0
  %r187 = call i64 @nova_rt_add(i64 %r185, i64 %r186)
  store i64 %r187, ptr %slot.col, align 8
  br label %endif211
else210:
  br label %while_exit190
endif211:
  br label %while_hdr188
while_exit190:
  %r188 = load i64, ptr %slot.tokens, align 8
  %r190 = load i64, ptr %slot.line, align 8
  %r191 = load i64, ptr %slot.start_col, align 8
  %r192 = load i64, ptr %slot.word, align 8
  %r189 = call i64 @nova_rt_list_create()
  call i64 @nova_rt_list_append(i64 %r189, i64 %r190)
  call i64 @nova_rt_list_append(i64 %r189, i64 %r191)
  call i64 @nova_rt_list_append(i64 %r189, i64 %r192)
  %r193 = call i64 @nova_rt_list_append(i64 %r188, i64 %r189)
  br label %while_hdr128
else186:
  br label %endif187
endif187:
  %r194 = load i64, ptr %slot.ch, align 8
  %r195.p = getelementptr inbounds [2 x i8], ptr @.str.26, i64 0, i64 0
  %r195 = ptrtoint ptr %r195.p to i64
  %r196.cmp = icmp sge i64 %r194, %r195
  %r196 = zext i1 %r196.cmp to i64
  store i64 %r196, ptr %slot.__sc_212, align 8
  %br_and_rhs213 = icmp ne i64 %r196, 0
  br i1 %br_and_rhs213, label %and_rhs213, label %and_merge214
and_rhs213:
  %r197 = load i64, ptr %slot.ch, align 8
  %r198.p = getelementptr inbounds [2 x i8], ptr @.str.27, i64 0, i64 0
  %r198 = ptrtoint ptr %r198.p to i64
  %r199.cmp = icmp sle i64 %r197, %r198
  %r199 = zext i1 %r199.cmp to i64
  store i64 %r199, ptr %slot.__sc_212, align 8
  br label %and_merge214
and_merge214:
  %r200 = load i64, ptr %slot.__sc_212, align 8
  %br_then215 = icmp ne i64 %r200, 0
  br i1 %br_then215, label %then215, label %else216
then215:
  %r201 = load i64, ptr %slot.col, align 8
  store i64 %r201, ptr %slot.start_col, align 8
  br label %while_hdr218
while_hdr218:
  %r202 = load i64, ptr %slot.pos, align 8
  %r203 = load i64, ptr %slot.source, align 8
  %r204 = call i64 @nova_rt_len_any(i64 %r203)
  %r205.cmp = icmp slt i64 %r202, %r204
  %r205 = zext i1 %r205.cmp to i64
  store i64 %r205, ptr %slot.__sc_221, align 8
  %br_and_rhs222 = icmp ne i64 %r205, 0
  br i1 %br_and_rhs222, label %and_rhs222, label %and_merge223
and_rhs222:
  %r206 = load i64, ptr %slot.source, align 8
  %r207 = load i64, ptr %slot.pos, align 8
  %r208 = call i64 @nova_rt_index_get(i64 %r206, i64 %r207)
  %r209.p = getelementptr inbounds [2 x i8], ptr @.str.26, i64 0, i64 0
  %r209 = ptrtoint ptr %r209.p to i64
  %r210.cmp = icmp sge i64 %r208, %r209
  %r210 = zext i1 %r210.cmp to i64
  store i64 %r210, ptr %slot.__sc_221, align 8
  br label %and_merge223
and_merge223:
  %r211 = load i64, ptr %slot.__sc_221, align 8
  store i64 %r211, ptr %slot.__sc_224, align 8
  %br_and_rhs225 = icmp ne i64 %r211, 0
  br i1 %br_and_rhs225, label %and_rhs225, label %and_merge226
and_rhs225:
  %r212 = load i64, ptr %slot.source, align 8
  %r213 = load i64, ptr %slot.pos, align 8
  %r214 = call i64 @nova_rt_index_get(i64 %r212, i64 %r213)
  %r215.p = getelementptr inbounds [2 x i8], ptr @.str.27, i64 0, i64 0
  %r215 = ptrtoint ptr %r215.p to i64
  %r216.cmp = icmp sle i64 %r214, %r215
  %r216 = zext i1 %r216.cmp to i64
  store i64 %r216, ptr %slot.__sc_224, align 8
  br label %and_merge226
and_merge226:
  %r217 = load i64, ptr %slot.__sc_224, align 8
  %br_while_body219 = icmp ne i64 %r217, 0
  br i1 %br_while_body219, label %while_body219, label %while_exit220
while_body219:
  %r218 = load i64, ptr %slot.pos, align 8
  %r219 = add i64 1, 0
  %r220 = call i64 @nova_rt_add(i64 %r218, i64 %r219)
  store i64 %r220, ptr %slot.pos, align 8
  %r221 = load i64, ptr %slot.col, align 8
  %r222 = add i64 1, 0
  %r223 = call i64 @nova_rt_add(i64 %r221, i64 %r222)
  store i64 %r223, ptr %slot.col, align 8
  br label %while_hdr218
while_exit220:
  %r224 = load i64, ptr %slot.tokens, align 8
  %r226 = load i64, ptr %slot.line, align 8
  %r227 = load i64, ptr %slot.start_col, align 8
  %r228.p = getelementptr inbounds [7 x i8], ptr @.str.43, i64 0, i64 0
  %r228 = ptrtoint ptr %r228.p to i64
  %r225 = call i64 @nova_rt_list_create()
  call i64 @nova_rt_list_append(i64 %r225, i64 %r226)
  call i64 @nova_rt_list_append(i64 %r225, i64 %r227)
  call i64 @nova_rt_list_append(i64 %r225, i64 %r228)
  %r229 = call i64 @nova_rt_list_append(i64 %r224, i64 %r225)
  br label %while_hdr128
else216:
  br label %endif217
endif217:
  %r230 = load i64, ptr %slot.pos, align 8
  %r231 = add i64 1, 0
  %r232 = call i64 @nova_rt_add(i64 %r230, i64 %r231)
  store i64 %r232, ptr %slot.pos, align 8
  %r233 = load i64, ptr %slot.col, align 8
  %r234 = add i64 1, 0
  %r235 = call i64 @nova_rt_add(i64 %r233, i64 %r234)
  store i64 %r235, ptr %slot.col, align 8
  br label %while_hdr128
while_exit130:
  %r236 = load i64, ptr %slot.tokens, align 8
  ret i64 %r236
}

define i64 @lsp_check_source(i64 %p0) nounwind {
entry:
  %slot.source = alloca i64, align 8
  store i64 %p0, ptr %slot.source, align 8
  %slot.diags = alloca i64, align 8
  store i64 0, ptr %slot.diags, align 8
  %slot.lines = alloca i64, align 8
  store i64 0, ptr %slot.lines, align 8
  %slot.indent_stack = alloca i64, align 8
  store i64 0, ptr %slot.indent_stack, align 8
  %slot.line_num = alloca i64, align 8
  store i64 0, ptr %slot.line_num, align 8
  %slot.__for_idx_227 = alloca i64, align 8
  store i64 0, ptr %slot.__for_idx_227, align 8
  %slot.line = alloca i64, align 8
  store i64 0, ptr %slot.line, align 8
  %slot.trimmed = alloca i64, align 8
  store i64 0, ptr %slot.trimmed, align 8
  %slot.__sc_230 = alloca i64, align 8
  store i64 0, ptr %slot.__sc_230, align 8
  %slot.__sc_233 = alloca i64, align 8
  store i64 0, ptr %slot.__sc_233, align 8
  %slot.fn_name = alloca i64, align 8
  store i64 0, ptr %slot.fn_name, align 8
  %slot.__sc_239 = alloca i64, align 8
  store i64 0, ptr %slot.__sc_239, align 8
  %slot.in_str = alloca i64, align 8
  store i64 0, ptr %slot.in_str, align 8
  %slot.ci = alloca i64, align 8
  store i64 0, ptr %slot.ci, align 8
  %slot.c = alloca i64, align 8
  store i64 0, ptr %slot.c, align 8
  %slot.__sc_248 = alloca i64, align 8
  store i64 0, ptr %slot.__sc_248, align 8
  %slot.__sc_251 = alloca i64, align 8
  store i64 0, ptr %slot.__sc_251, align 8
  %slot.__sc_257 = alloca i64, align 8
  store i64 0, ptr %slot.__sc_257, align 8
  %slot.__sc_263 = alloca i64, align 8
  store i64 0, ptr %slot.__sc_263, align 8
  %slot.cond_part = alloca i64, align 8
  store i64 0, ptr %slot.cond_part, align 8
  %slot.__sc_272 = alloca i64, align 8
  store i64 0, ptr %slot.__sc_272, align 8
  %slot.__sc_275 = alloca i64, align 8
  store i64 0, ptr %slot.__sc_275, align 8
  %slot.__sc_278 = alloca i64, align 8
  store i64 0, ptr %slot.__sc_278, align 8
  %slot.__sc_281 = alloca i64, align 8
  store i64 0, ptr %slot.__sc_281, align 8
  %r0 = call i64 @nova_rt_list_create()
  store i64 %r0, ptr %slot.diags, align 8
  %r1 = load i64, ptr %slot.source, align 8
  %r2.p = getelementptr inbounds [2 x i8], ptr @.str.5, i64 0, i64 0
  %r2 = ptrtoint ptr %r2.p to i64
  %r3 = call i64 @nova_rt_split(i64 %r1, i64 %r2)
  store i64 %r3, ptr %slot.lines, align 8
  %r5 = add i64 0, 0
  %r4 = call i64 @nova_rt_list_create()
  call i64 @nova_rt_list_append(i64 %r4, i64 %r5)
  store i64 %r4, ptr %slot.indent_stack, align 8
  %r6 = add i64 0, 0
  store i64 %r6, ptr %slot.line_num, align 8
  %r7 = load i64, ptr %slot.lines, align 8
  %r8 = call i64 @nova_rt_len_any(i64 %r7)
  %r9 = add i64 0, 0
  store i64 %r9, ptr %slot.__for_idx_227, align 8
  br label %for_hdr227
for_hdr227:
  %r10 = load i64, ptr %slot.__for_idx_227, align 8
  %r11.cmp = icmp slt i64 %r10, %r8
  %r11 = zext i1 %r11.cmp to i64
  %br_for_body228 = icmp ne i64 %r11, 0
  br i1 %br_for_body228, label %for_body228, label %for_exit229
for_body228:
  %r12 = call i64 @nova_rt_index_get(i64 %r7, i64 %r10)
  store i64 %r12, ptr %slot.line, align 8
  %r13 = load i64, ptr %slot.line, align 8
  %r14 = call i64 @nova_rt_trim(i64 %r13)
  store i64 %r14, ptr %slot.trimmed, align 8
  %r15 = load i64, ptr %slot.trimmed, align 8
  %r16.p = getelementptr inbounds [4 x i8], ptr @.str.44, i64 0, i64 0
  %r16 = ptrtoint ptr %r16.p to i64
  %r17 = call i64 @nova_rt_starts_with(i64 %r15, i64 %r16)
  store i64 %r17, ptr %slot.__sc_230, align 8
  %br_and_rhs231 = icmp ne i64 %r17, 0
  br i1 %br_and_rhs231, label %and_rhs231, label %and_merge232
and_rhs231:
  %r18 = load i64, ptr %slot.trimmed, align 8
  %r19.p = getelementptr inbounds [2 x i8], ptr @.str.45, i64 0, i64 0
  %r19 = ptrtoint ptr %r19.p to i64
  %r20 = call i64 @nova_rt_find(i64 %r18, i64 %r19)
  %r21 = add i64 0, 0
  %r22.cmp = icmp slt i64 %r20, %r21
  %r22 = zext i1 %r22.cmp to i64
  store i64 %r22, ptr %slot.__sc_230, align 8
  br label %and_merge232
and_merge232:
  %r23 = load i64, ptr %slot.__sc_230, align 8
  store i64 %r23, ptr %slot.__sc_233, align 8
  %br_and_rhs234 = icmp ne i64 %r23, 0
  br i1 %br_and_rhs234, label %and_rhs234, label %and_merge235
and_rhs234:
  %r24 = load i64, ptr %slot.trimmed, align 8
  %r25 = call i64 @nova_rt_len_any(i64 %r24)
  %r26 = add i64 3, 0
  %r27.cmp = icmp sgt i64 %r25, %r26
  %r27 = zext i1 %r27.cmp to i64
  store i64 %r27, ptr %slot.__sc_233, align 8
  br label %and_merge235
and_merge235:
  %r28 = load i64, ptr %slot.__sc_233, align 8
  %br_then236 = icmp ne i64 %r28, 0
  br i1 %br_then236, label %then236, label %else237
then236:
  %r29 = load i64, ptr %slot.trimmed, align 8
  %r30 = add i64 3, 0
  %r31 = load i64, ptr %slot.trimmed, align 8
  %r32 = call i64 @nova_rt_len_any(i64 %r31)
  %r33 = call i64 @nova_rt_slice(i64 %r29, i64 %r30, i64 %r32)
  %r34 = call i64 @nova_rt_trim(i64 %r33)
  store i64 %r34, ptr %slot.fn_name, align 8
  %r35 = load i64, ptr %slot.fn_name, align 8
  %r36 = call i64 @nova_rt_len_any(i64 %r35)
  %r37 = add i64 0, 0
  %r38.cmp = icmp sgt i64 %r36, %r37
  %r38 = zext i1 %r38.cmp to i64
  store i64 %r38, ptr %slot.__sc_239, align 8
  %br_and_rhs240 = icmp ne i64 %r38, 0
  br i1 %br_and_rhs240, label %and_rhs240, label %and_merge241
and_rhs240:
  %r39 = load i64, ptr %slot.fn_name, align 8
  %r40.p = getelementptr inbounds [2 x i8], ptr @.str.21, i64 0, i64 0
  %r40 = ptrtoint ptr %r40.p to i64
  %r41 = call i64 @nova_rt_find(i64 %r39, i64 %r40)
  %r42 = add i64 0, 0
  %r43.cmp = icmp slt i64 %r41, %r42
  %r43 = zext i1 %r43.cmp to i64
  store i64 %r43, ptr %slot.__sc_239, align 8
  br label %and_merge241
and_merge241:
  %r44 = load i64, ptr %slot.__sc_239, align 8
  %br_then242 = icmp ne i64 %r44, 0
  br i1 %br_then242, label %then242, label %else243
then242:
  %r45 = load i64, ptr %slot.diags, align 8
  %r47 = load i64, ptr %slot.line_num, align 8
  %r48 = add i64 0, 0
  %r49.p = getelementptr inbounds [11 x i8], ptr @.str.46, i64 0, i64 0
  %r49 = ptrtoint ptr %r49.p to i64
  %r50 = load i64, ptr %slot.fn_name, align 8
  %r51 = call i64 @nova_rt_add(i64 %r49, i64 %r50)
  %r52.p = getelementptr inbounds [36 x i8], ptr @.str.47, i64 0, i64 0
  %r52 = ptrtoint ptr %r52.p to i64
  %r53 = call i64 @nova_rt_add(i64 %r51, i64 %r52)
  %r46 = call i64 @nova_rt_list_create()
  call i64 @nova_rt_list_append(i64 %r46, i64 %r47)
  call i64 @nova_rt_list_append(i64 %r46, i64 %r48)
  call i64 @nova_rt_list_append(i64 %r46, i64 %r53)
  %r54 = call i64 @nova_rt_list_append(i64 %r45, i64 %r46)
  br label %endif244
else243:
  br label %endif244
endif244:
  br label %endif238
else237:
  br label %endif238
endif238:
  %r55 = add i64 0, 0
  store i64 %r55, ptr %slot.in_str, align 8
  %r56 = add i64 0, 0
  store i64 %r56, ptr %slot.ci, align 8
  br label %while_hdr245
while_hdr245:
  %r57 = load i64, ptr %slot.ci, align 8
  %r58 = load i64, ptr %slot.trimmed, align 8
  %r59 = call i64 @nova_rt_len_any(i64 %r58)
  %r60.cmp = icmp slt i64 %r57, %r59
  %r60 = zext i1 %r60.cmp to i64
  %br_while_body246 = icmp ne i64 %r60, 0
  br i1 %br_while_body246, label %while_body246, label %while_exit247
while_body246:
  %r61 = load i64, ptr %slot.trimmed, align 8
  %r62 = load i64, ptr %slot.ci, align 8
  %r63 = call i64 @nova_rt_index_get(i64 %r61, i64 %r62)
  store i64 %r63, ptr %slot.c, align 8
  %r64 = load i64, ptr %slot.c, align 8
  %r65.p = getelementptr inbounds [2 x i8], ptr @.str.1, i64 0, i64 0
  %r65 = ptrtoint ptr %r65.p to i64
  %r66 = call i64 @nova_rt_eq(i64 %r64, i64 %r65)
  store i64 %r66, ptr %slot.__sc_248, align 8
  %br_and_rhs249 = icmp ne i64 %r66, 0
  br i1 %br_and_rhs249, label %and_rhs249, label %and_merge250
and_rhs249:
  %r67 = load i64, ptr %slot.ci, align 8
  %r68 = add i64 0, 0
  %r69 = call i64 @nova_rt_eq(i64 %r67, i64 %r68)
  store i64 %r69, ptr %slot.__sc_251, align 8
  %br_or_merge253 = icmp ne i64 %r69, 0
  br i1 %br_or_merge253, label %or_merge253, label %or_rhs252
or_rhs252:
  %r70 = load i64, ptr %slot.trimmed, align 8
  %r71 = load i64, ptr %slot.ci, align 8
  %r72 = add i64 1, 0
  %r73 = sub i64 %r71, %r72
  %r74 = call i64 @nova_rt_index_get(i64 %r70, i64 %r73)
  %r75.p = getelementptr inbounds [2 x i8], ptr @.str.3, i64 0, i64 0
  %r75 = ptrtoint ptr %r75.p to i64
  %r76 = call i64 @nova_rt_neq(i64 %r74, i64 %r75)
  store i64 %r76, ptr %slot.__sc_251, align 8
  br label %or_merge253
or_merge253:
  %r77 = load i64, ptr %slot.__sc_251, align 8
  store i64 %r77, ptr %slot.__sc_248, align 8
  br label %and_merge250
and_merge250:
  %r78 = load i64, ptr %slot.__sc_248, align 8
  %br_then254 = icmp ne i64 %r78, 0
  br i1 %br_then254, label %then254, label %else255
then254:
  %r79 = add i64 1, 0
  %r80 = load i64, ptr %slot.in_str, align 8
  %r81 = sub i64 %r79, %r80
  store i64 %r81, ptr %slot.in_str, align 8
  br label %endif256
else255:
  br label %endif256
endif256:
  %r82 = load i64, ptr %slot.ci, align 8
  %r83 = add i64 1, 0
  %r84 = call i64 @nova_rt_add(i64 %r82, i64 %r83)
  store i64 %r84, ptr %slot.ci, align 8
  br label %while_hdr245
while_exit247:
  %r85 = load i64, ptr %slot.in_str, align 8
  %r86 = add i64 1, 0
  %r87 = call i64 @nova_rt_eq(i64 %r85, i64 %r86)
  store i64 %r87, ptr %slot.__sc_257, align 8
  %br_and_rhs258 = icmp ne i64 %r87, 0
  br i1 %br_and_rhs258, label %and_rhs258, label %and_merge259
and_rhs258:
  %r88 = load i64, ptr %slot.trimmed, align 8
  %r89.p = getelementptr inbounds [3 x i8], ptr @.str.48, i64 0, i64 0
  %r89 = ptrtoint ptr %r89.p to i64
  %r90 = call i64 @nova_rt_starts_with(i64 %r88, i64 %r89)
  %r91.cmp = icmp eq i64 %r90, 0
  %r91 = zext i1 %r91.cmp to i64
  store i64 %r91, ptr %slot.__sc_257, align 8
  br label %and_merge259
and_merge259:
  %r92 = load i64, ptr %slot.__sc_257, align 8
  %br_then260 = icmp ne i64 %r92, 0
  br i1 %br_then260, label %then260, label %else261
then260:
  %r93 = load i64, ptr %slot.diags, align 8
  %r95 = load i64, ptr %slot.line_num, align 8
  %r96 = add i64 0, 0
  %r97.p = getelementptr inbounds [24 x i8], ptr @.str.49, i64 0, i64 0
  %r97 = ptrtoint ptr %r97.p to i64
  %r94 = call i64 @nova_rt_list_create()
  call i64 @nova_rt_list_append(i64 %r94, i64 %r95)
  call i64 @nova_rt_list_append(i64 %r94, i64 %r96)
  call i64 @nova_rt_list_append(i64 %r94, i64 %r97)
  %r98 = call i64 @nova_rt_list_append(i64 %r93, i64 %r94)
  br label %endif262
else261:
  br label %endif262
endif262:
  %r99 = load i64, ptr %slot.trimmed, align 8
  %r100.p = getelementptr inbounds [4 x i8], ptr @.str.50, i64 0, i64 0
  %r100 = ptrtoint ptr %r100.p to i64
  %r101 = call i64 @nova_rt_starts_with(i64 %r99, i64 %r100)
  store i64 %r101, ptr %slot.__sc_263, align 8
  %br_or_merge265 = icmp ne i64 %r101, 0
  br i1 %br_or_merge265, label %or_merge265, label %or_rhs264
or_rhs264:
  %r102 = load i64, ptr %slot.trimmed, align 8
  %r103.p = getelementptr inbounds [7 x i8], ptr @.str.51, i64 0, i64 0
  %r103 = ptrtoint ptr %r103.p to i64
  %r104 = call i64 @nova_rt_starts_with(i64 %r102, i64 %r103)
  store i64 %r104, ptr %slot.__sc_263, align 8
  br label %or_merge265
or_merge265:
  %r105 = load i64, ptr %slot.__sc_263, align 8
  %br_then266 = icmp ne i64 %r105, 0
  br i1 %br_then266, label %then266, label %else267
then266:
  %r106.p = getelementptr inbounds [1 x i8], ptr @.str.0, i64 0, i64 0
  %r106 = ptrtoint ptr %r106.p to i64
  store i64 %r106, ptr %slot.cond_part, align 8
  %r107 = load i64, ptr %slot.trimmed, align 8
  %r108.p = getelementptr inbounds [4 x i8], ptr @.str.50, i64 0, i64 0
  %r108 = ptrtoint ptr %r108.p to i64
  %r109 = call i64 @nova_rt_starts_with(i64 %r107, i64 %r108)
  %br_then269 = icmp ne i64 %r109, 0
  br i1 %br_then269, label %then269, label %else270
then269:
  %r110 = load i64, ptr %slot.trimmed, align 8
  %r111 = add i64 3, 0
  %r112 = load i64, ptr %slot.trimmed, align 8
  %r113 = call i64 @nova_rt_len_any(i64 %r112)
  %r114 = call i64 @nova_rt_slice(i64 %r110, i64 %r111, i64 %r113)
  store i64 %r114, ptr %slot.cond_part, align 8
  br label %endif271
else270:
  %r115 = load i64, ptr %slot.trimmed, align 8
  %r116 = add i64 6, 0
  %r117 = load i64, ptr %slot.trimmed, align 8
  %r118 = call i64 @nova_rt_len_any(i64 %r117)
  %r119 = call i64 @nova_rt_slice(i64 %r115, i64 %r116, i64 %r118)
  store i64 %r119, ptr %slot.cond_part, align 8
  br label %endif271
endif271:
  %r120 = load i64, ptr %slot.cond_part, align 8
  %r121.p = getelementptr inbounds [4 x i8], ptr @.str.52, i64 0, i64 0
  %r121 = ptrtoint ptr %r121.p to i64
  %r122 = call i64 @nova_rt_find(i64 %r120, i64 %r121)
  %r123 = add i64 0, 0
  %r124.cmp = icmp sge i64 %r122, %r123
  %r124 = zext i1 %r124.cmp to i64
  store i64 %r124, ptr %slot.__sc_272, align 8
  %br_and_rhs273 = icmp ne i64 %r124, 0
  br i1 %br_and_rhs273, label %and_rhs273, label %and_merge274
and_rhs273:
  %r125 = load i64, ptr %slot.cond_part, align 8
  %r126.p = getelementptr inbounds [5 x i8], ptr @.str.53, i64 0, i64 0
  %r126 = ptrtoint ptr %r126.p to i64
  %r127 = call i64 @nova_rt_find(i64 %r125, i64 %r126)
  %r128 = add i64 0, 0
  %r129.cmp = icmp slt i64 %r127, %r128
  %r129 = zext i1 %r129.cmp to i64
  store i64 %r129, ptr %slot.__sc_272, align 8
  br label %and_merge274
and_merge274:
  %r130 = load i64, ptr %slot.__sc_272, align 8
  store i64 %r130, ptr %slot.__sc_275, align 8
  %br_and_rhs276 = icmp ne i64 %r130, 0
  br i1 %br_and_rhs276, label %and_rhs276, label %and_merge277
and_rhs276:
  %r131 = load i64, ptr %slot.cond_part, align 8
  %r132.p = getelementptr inbounds [5 x i8], ptr @.str.54, i64 0, i64 0
  %r132 = ptrtoint ptr %r132.p to i64
  %r133 = call i64 @nova_rt_find(i64 %r131, i64 %r132)
  %r134 = add i64 0, 0
  %r135.cmp = icmp slt i64 %r133, %r134
  %r135 = zext i1 %r135.cmp to i64
  store i64 %r135, ptr %slot.__sc_275, align 8
  br label %and_merge277
and_merge277:
  %r136 = load i64, ptr %slot.__sc_275, align 8
  store i64 %r136, ptr %slot.__sc_278, align 8
  %br_and_rhs279 = icmp ne i64 %r136, 0
  br i1 %br_and_rhs279, label %and_rhs279, label %and_merge280
and_rhs279:
  %r137 = load i64, ptr %slot.cond_part, align 8
  %r138.p = getelementptr inbounds [5 x i8], ptr @.str.55, i64 0, i64 0
  %r138 = ptrtoint ptr %r138.p to i64
  %r139 = call i64 @nova_rt_find(i64 %r137, i64 %r138)
  %r140 = add i64 0, 0
  %r141.cmp = icmp slt i64 %r139, %r140
  %r141 = zext i1 %r141.cmp to i64
  store i64 %r141, ptr %slot.__sc_278, align 8
  br label %and_merge280
and_merge280:
  %r142 = load i64, ptr %slot.__sc_278, align 8
  store i64 %r142, ptr %slot.__sc_281, align 8
  %br_and_rhs282 = icmp ne i64 %r142, 0
  br i1 %br_and_rhs282, label %and_rhs282, label %and_merge283
and_rhs282:
  %r143 = load i64, ptr %slot.cond_part, align 8
  %r144.p = getelementptr inbounds [5 x i8], ptr @.str.56, i64 0, i64 0
  %r144 = ptrtoint ptr %r144.p to i64
  %r145 = call i64 @nova_rt_find(i64 %r143, i64 %r144)
  %r146 = add i64 0, 0
  %r147.cmp = icmp slt i64 %r145, %r146
  %r147 = zext i1 %r147.cmp to i64
  store i64 %r147, ptr %slot.__sc_281, align 8
  br label %and_merge283
and_merge283:
  %r148 = load i64, ptr %slot.__sc_281, align 8
  %br_then284 = icmp ne i64 %r148, 0
  br i1 %br_then284, label %then284, label %else285
then284:
  %r149 = load i64, ptr %slot.diags, align 8
  %r151 = load i64, ptr %slot.line_num, align 8
  %r152 = add i64 0, 0
  %r153.p = getelementptr inbounds [56 x i8], ptr @.str.57, i64 0, i64 0
  %r153 = ptrtoint ptr %r153.p to i64
  %r150 = call i64 @nova_rt_list_create()
  call i64 @nova_rt_list_append(i64 %r150, i64 %r151)
  call i64 @nova_rt_list_append(i64 %r150, i64 %r152)
  call i64 @nova_rt_list_append(i64 %r150, i64 %r153)
  %r154 = call i64 @nova_rt_list_append(i64 %r149, i64 %r150)
  br label %endif286
else285:
  br label %endif286
endif286:
  br label %endif268
else267:
  br label %endif268
endif268:
  %r155 = load i64, ptr %slot.line_num, align 8
  %r156 = add i64 1, 0
  %r157 = call i64 @nova_rt_add(i64 %r155, i64 %r156)
  store i64 %r157, ptr %slot.line_num, align 8
  %r158 = load i64, ptr %slot.__for_idx_227, align 8
  %r159 = add i64 1, 0
  %r160 = call i64 @nova_rt_add(i64 %r158, i64 %r159)
  store i64 %r160, ptr %slot.__for_idx_227, align 8
  br label %for_hdr227
for_exit229:
  %r161 = load i64, ptr %slot.diags, align 8
  ret i64 %r161
}

define i64 @nova_keywords() nounwind {
entry:
  %slot.kws = alloca i64, align 8
  store i64 0, ptr %slot.kws, align 8
  %r0.p = getelementptr inbounds [158 x i8], ptr @.str.58, i64 0, i64 0
  %r0 = ptrtoint ptr %r0.p to i64
  %r1.p = getelementptr inbounds [2 x i8], ptr @.str.17, i64 0, i64 0
  %r1 = ptrtoint ptr %r1.p to i64
  %r2 = call i64 @nova_rt_split(i64 %r0, i64 %r1)
  store i64 %r2, ptr %slot.kws, align 8
  %r3 = load i64, ptr %slot.kws, align 8
  ret i64 %r3
}

define i64 @nova_builtins() nounwind {
entry:
  %slot.bis = alloca i64, align 8
  store i64 0, ptr %slot.bis, align 8
  %r0.p = getelementptr inbounds [329 x i8], ptr @.str.59, i64 0, i64 0
  %r0 = ptrtoint ptr %r0.p to i64
  %r1.p = getelementptr inbounds [2 x i8], ptr @.str.17, i64 0, i64 0
  %r1 = ptrtoint ptr %r1.p to i64
  %r2 = call i64 @nova_rt_split(i64 %r0, i64 %r1)
  store i64 %r2, ptr %slot.bis, align 8
  %r3 = load i64, ptr %slot.bis, align 8
  ret i64 %r3
}

define i64 @nova_types() nounwind {
entry:
  %slot.tys = alloca i64, align 8
  store i64 0, ptr %slot.tys, align 8
  %r0.p = getelementptr inbounds [41 x i8], ptr @.str.60, i64 0, i64 0
  %r0 = ptrtoint ptr %r0.p to i64
  %r1.p = getelementptr inbounds [2 x i8], ptr @.str.17, i64 0, i64 0
  %r1 = ptrtoint ptr %r1.p to i64
  %r2 = call i64 @nova_rt_split(i64 %r0, i64 %r1)
  store i64 %r2, ptr %slot.tys, align 8
  %r3 = load i64, ptr %slot.tys, align 8
  ret i64 %r3
}

define i64 @build_completion_items() nounwind {
entry:
  %slot.items = alloca i64, align 8
  store i64 0, ptr %slot.items, align 8
  %slot.__for_idx_287 = alloca i64, align 8
  store i64 0, ptr %slot.__for_idx_287, align 8
  %slot.kw = alloca i64, align 8
  store i64 0, ptr %slot.kw, align 8
  %slot.item = alloca i64, align 8
  store i64 0, ptr %slot.item, align 8
  %slot.__for_idx_290 = alloca i64, align 8
  store i64 0, ptr %slot.__for_idx_290, align 8
  %slot.bi = alloca i64, align 8
  store i64 0, ptr %slot.bi, align 8
  %slot.__for_idx_293 = alloca i64, align 8
  store i64 0, ptr %slot.__for_idx_293, align 8
  %slot.ty = alloca i64, align 8
  store i64 0, ptr %slot.ty, align 8
  %slot.fn_snip = alloca i64, align 8
  store i64 0, ptr %slot.fn_snip, align 8
  %slot.for_snip = alloca i64, align 8
  store i64 0, ptr %slot.for_snip, align 8
  %slot.if_snip = alloca i64, align 8
  store i64 0, ptr %slot.if_snip, align 8
  %r0 = call i64 @nova_rt_list_create()
  store i64 %r0, ptr %slot.items, align 8
  %r1 = call i64 @nova_keywords()
  %r2 = call i64 @nova_rt_len_any(i64 %r1)
  %r3 = add i64 0, 0
  store i64 %r3, ptr %slot.__for_idx_287, align 8
  br label %for_hdr287
for_hdr287:
  %r4 = load i64, ptr %slot.__for_idx_287, align 8
  %r5.cmp = icmp slt i64 %r4, %r2
  %r5 = zext i1 %r5.cmp to i64
  %br_for_body288 = icmp ne i64 %r5, 0
  br i1 %br_for_body288, label %for_body288, label %for_exit289
for_body288:
  %r6 = call i64 @nova_rt_index_get(i64 %r1, i64 %r4)
  store i64 %r6, ptr %slot.kw, align 8
  %r8.p = getelementptr inbounds [6 x i8], ptr @.str.61, i64 0, i64 0
  %r8 = ptrtoint ptr %r8.p to i64
  %r9 = load i64, ptr %slot.kw, align 8
  %r10 = call i64 @json_str(i64 %r8, i64 %r9)
  %r11.p = getelementptr inbounds [5 x i8], ptr @.str.62, i64 0, i64 0
  %r11 = ptrtoint ptr %r11.p to i64
  %r12 = add i64 14, 0
  %r13 = call i64 @json_int(i64 %r11, i64 %r12)
  %r14.p = getelementptr inbounds [7 x i8], ptr @.str.63, i64 0, i64 0
  %r14 = ptrtoint ptr %r14.p to i64
  %r15.p = getelementptr inbounds [8 x i8], ptr @.str.64, i64 0, i64 0
  %r15 = ptrtoint ptr %r15.p to i64
  %r16 = call i64 @json_str(i64 %r14, i64 %r15)
  %r7 = call i64 @nova_rt_list_create()
  call i64 @nova_rt_list_append(i64 %r7, i64 %r10)
  call i64 @nova_rt_list_append(i64 %r7, i64 %r13)
  call i64 @nova_rt_list_append(i64 %r7, i64 %r16)
  %r17 = call i64 @json_obj(i64 %r7)
  store i64 %r17, ptr %slot.item, align 8
  %r18 = load i64, ptr %slot.items, align 8
  %r19 = load i64, ptr %slot.item, align 8
  %r20 = call i64 @nova_rt_list_append(i64 %r18, i64 %r19)
  %r21 = load i64, ptr %slot.__for_idx_287, align 8
  %r22 = add i64 1, 0
  %r23 = call i64 @nova_rt_add(i64 %r21, i64 %r22)
  store i64 %r23, ptr %slot.__for_idx_287, align 8
  br label %for_hdr287
for_exit289:
  %r24 = call i64 @nova_builtins()
  %r25 = call i64 @nova_rt_len_any(i64 %r24)
  %r26 = add i64 0, 0
  store i64 %r26, ptr %slot.__for_idx_290, align 8
  br label %for_hdr290
for_hdr290:
  %r27 = load i64, ptr %slot.__for_idx_290, align 8
  %r28.cmp = icmp slt i64 %r27, %r25
  %r28 = zext i1 %r28.cmp to i64
  %br_for_body291 = icmp ne i64 %r28, 0
  br i1 %br_for_body291, label %for_body291, label %for_exit292
for_body291:
  %r29 = call i64 @nova_rt_index_get(i64 %r24, i64 %r27)
  store i64 %r29, ptr %slot.bi, align 8
  %r31.p = getelementptr inbounds [6 x i8], ptr @.str.61, i64 0, i64 0
  %r31 = ptrtoint ptr %r31.p to i64
  %r32 = load i64, ptr %slot.bi, align 8
  %r33 = call i64 @json_str(i64 %r31, i64 %r32)
  %r34.p = getelementptr inbounds [5 x i8], ptr @.str.62, i64 0, i64 0
  %r34 = ptrtoint ptr %r34.p to i64
  %r35 = add i64 3, 0
  %r36 = call i64 @json_int(i64 %r34, i64 %r35)
  %r37.p = getelementptr inbounds [7 x i8], ptr @.str.63, i64 0, i64 0
  %r37 = ptrtoint ptr %r37.p to i64
  %r38.p = getelementptr inbounds [17 x i8], ptr @.str.65, i64 0, i64 0
  %r38 = ptrtoint ptr %r38.p to i64
  %r39 = call i64 @json_str(i64 %r37, i64 %r38)
  %r30 = call i64 @nova_rt_list_create()
  call i64 @nova_rt_list_append(i64 %r30, i64 %r33)
  call i64 @nova_rt_list_append(i64 %r30, i64 %r36)
  call i64 @nova_rt_list_append(i64 %r30, i64 %r39)
  %r40 = call i64 @json_obj(i64 %r30)
  store i64 %r40, ptr %slot.item, align 8
  %r41 = load i64, ptr %slot.items, align 8
  %r42 = load i64, ptr %slot.item, align 8
  %r43 = call i64 @nova_rt_list_append(i64 %r41, i64 %r42)
  %r44 = load i64, ptr %slot.__for_idx_290, align 8
  %r45 = add i64 1, 0
  %r46 = call i64 @nova_rt_add(i64 %r44, i64 %r45)
  store i64 %r46, ptr %slot.__for_idx_290, align 8
  br label %for_hdr290
for_exit292:
  %r47 = call i64 @nova_types()
  %r48 = call i64 @nova_rt_len_any(i64 %r47)
  %r49 = add i64 0, 0
  store i64 %r49, ptr %slot.__for_idx_293, align 8
  br label %for_hdr293
for_hdr293:
  %r50 = load i64, ptr %slot.__for_idx_293, align 8
  %r51.cmp = icmp slt i64 %r50, %r48
  %r51 = zext i1 %r51.cmp to i64
  %br_for_body294 = icmp ne i64 %r51, 0
  br i1 %br_for_body294, label %for_body294, label %for_exit295
for_body294:
  %r52 = call i64 @nova_rt_index_get(i64 %r47, i64 %r50)
  store i64 %r52, ptr %slot.ty, align 8
  %r54.p = getelementptr inbounds [6 x i8], ptr @.str.61, i64 0, i64 0
  %r54 = ptrtoint ptr %r54.p to i64
  %r55 = load i64, ptr %slot.ty, align 8
  %r56 = call i64 @json_str(i64 %r54, i64 %r55)
  %r57.p = getelementptr inbounds [5 x i8], ptr @.str.62, i64 0, i64 0
  %r57 = ptrtoint ptr %r57.p to i64
  %r58 = add i64 25, 0
  %r59 = call i64 @json_int(i64 %r57, i64 %r58)
  %r60.p = getelementptr inbounds [7 x i8], ptr @.str.63, i64 0, i64 0
  %r60 = ptrtoint ptr %r60.p to i64
  %r61.p = getelementptr inbounds [5 x i8], ptr @.str.66, i64 0, i64 0
  %r61 = ptrtoint ptr %r61.p to i64
  %r62 = call i64 @json_str(i64 %r60, i64 %r61)
  %r53 = call i64 @nova_rt_list_create()
  call i64 @nova_rt_list_append(i64 %r53, i64 %r56)
  call i64 @nova_rt_list_append(i64 %r53, i64 %r59)
  call i64 @nova_rt_list_append(i64 %r53, i64 %r62)
  %r63 = call i64 @json_obj(i64 %r53)
  store i64 %r63, ptr %slot.item, align 8
  %r64 = load i64, ptr %slot.items, align 8
  %r65 = load i64, ptr %slot.item, align 8
  %r66 = call i64 @nova_rt_list_append(i64 %r64, i64 %r65)
  %r67 = load i64, ptr %slot.__for_idx_293, align 8
  %r68 = add i64 1, 0
  %r69 = call i64 @nova_rt_add(i64 %r67, i64 %r68)
  store i64 %r69, ptr %slot.__for_idx_293, align 8
  br label %for_hdr293
for_exit295:
  %r71.p = getelementptr inbounds [6 x i8], ptr @.str.61, i64 0, i64 0
  %r71 = ptrtoint ptr %r71.p to i64
  %r72.p = getelementptr inbounds [3 x i8], ptr @.str.67, i64 0, i64 0
  %r72 = ptrtoint ptr %r72.p to i64
  %r73 = call i64 @json_str(i64 %r71, i64 %r72)
  %r74.p = getelementptr inbounds [5 x i8], ptr @.str.62, i64 0, i64 0
  %r74 = ptrtoint ptr %r74.p to i64
  %r75 = add i64 15, 0
  %r76 = call i64 @json_int(i64 %r74, i64 %r75)
  %r77.p = getelementptr inbounds [7 x i8], ptr @.str.63, i64 0, i64 0
  %r77 = ptrtoint ptr %r77.p to i64
  %r78.p = getelementptr inbounds [20 x i8], ptr @.str.68, i64 0, i64 0
  %r78 = ptrtoint ptr %r78.p to i64
  %r79 = call i64 @json_str(i64 %r77, i64 %r78)
  %r80.p = getelementptr inbounds [11 x i8], ptr @.str.69, i64 0, i64 0
  %r80 = ptrtoint ptr %r80.p to i64
  %r81.p = getelementptr inbounds [35 x i8], ptr @.str.70, i64 0, i64 0
  %r81 = ptrtoint ptr %r81.p to i64
  %r82 = call i64 @json_str(i64 %r80, i64 %r81)
  %r83.p = getelementptr inbounds [17 x i8], ptr @.str.71, i64 0, i64 0
  %r83 = ptrtoint ptr %r83.p to i64
  %r84 = add i64 2, 0
  %r85 = call i64 @json_int(i64 %r83, i64 %r84)
  %r70 = call i64 @nova_rt_list_create()
  call i64 @nova_rt_list_append(i64 %r70, i64 %r73)
  call i64 @nova_rt_list_append(i64 %r70, i64 %r76)
  call i64 @nova_rt_list_append(i64 %r70, i64 %r79)
  call i64 @nova_rt_list_append(i64 %r70, i64 %r82)
  call i64 @nova_rt_list_append(i64 %r70, i64 %r85)
  %r86 = call i64 @json_obj(i64 %r70)
  store i64 %r86, ptr %slot.fn_snip, align 8
  %r87 = load i64, ptr %slot.items, align 8
  %r88 = load i64, ptr %slot.fn_snip, align 8
  %r89 = call i64 @nova_rt_list_append(i64 %r87, i64 %r88)
  %r91.p = getelementptr inbounds [6 x i8], ptr @.str.61, i64 0, i64 0
  %r91 = ptrtoint ptr %r91.p to i64
  %r92.p = getelementptr inbounds [4 x i8], ptr @.str.72, i64 0, i64 0
  %r92 = ptrtoint ptr %r92.p to i64
  %r93 = call i64 @json_str(i64 %r91, i64 %r92)
  %r94.p = getelementptr inbounds [5 x i8], ptr @.str.62, i64 0, i64 0
  %r94 = ptrtoint ptr %r94.p to i64
  %r95 = add i64 15, 0
  %r96 = call i64 @json_int(i64 %r94, i64 %r95)
  %r97.p = getelementptr inbounds [7 x i8], ptr @.str.63, i64 0, i64 0
  %r97 = ptrtoint ptr %r97.p to i64
  %r98.p = getelementptr inbounds [9 x i8], ptr @.str.73, i64 0, i64 0
  %r98 = ptrtoint ptr %r98.p to i64
  %r99 = call i64 @json_str(i64 %r97, i64 %r98)
  %r100.p = getelementptr inbounds [11 x i8], ptr @.str.69, i64 0, i64 0
  %r100 = ptrtoint ptr %r100.p to i64
  %r101.p = getelementptr inbounds [36 x i8], ptr @.str.74, i64 0, i64 0
  %r101 = ptrtoint ptr %r101.p to i64
  %r102 = call i64 @json_str(i64 %r100, i64 %r101)
  %r103.p = getelementptr inbounds [17 x i8], ptr @.str.71, i64 0, i64 0
  %r103 = ptrtoint ptr %r103.p to i64
  %r104 = add i64 2, 0
  %r105 = call i64 @json_int(i64 %r103, i64 %r104)
  %r90 = call i64 @nova_rt_list_create()
  call i64 @nova_rt_list_append(i64 %r90, i64 %r93)
  call i64 @nova_rt_list_append(i64 %r90, i64 %r96)
  call i64 @nova_rt_list_append(i64 %r90, i64 %r99)
  call i64 @nova_rt_list_append(i64 %r90, i64 %r102)
  call i64 @nova_rt_list_append(i64 %r90, i64 %r105)
  %r106 = call i64 @json_obj(i64 %r90)
  store i64 %r106, ptr %slot.for_snip, align 8
  %r107 = load i64, ptr %slot.items, align 8
  %r108 = load i64, ptr %slot.for_snip, align 8
  %r109 = call i64 @nova_rt_list_append(i64 %r107, i64 %r108)
  %r111.p = getelementptr inbounds [6 x i8], ptr @.str.61, i64 0, i64 0
  %r111 = ptrtoint ptr %r111.p to i64
  %r112.p = getelementptr inbounds [3 x i8], ptr @.str.75, i64 0, i64 0
  %r112 = ptrtoint ptr %r112.p to i64
  %r113 = call i64 @json_str(i64 %r111, i64 %r112)
  %r114.p = getelementptr inbounds [5 x i8], ptr @.str.62, i64 0, i64 0
  %r114 = ptrtoint ptr %r114.p to i64
  %r115 = add i64 15, 0
  %r116 = call i64 @json_int(i64 %r114, i64 %r115)
  %r117.p = getelementptr inbounds [7 x i8], ptr @.str.63, i64 0, i64 0
  %r117 = ptrtoint ptr %r117.p to i64
  %r118.p = getelementptr inbounds [13 x i8], ptr @.str.76, i64 0, i64 0
  %r118 = ptrtoint ptr %r118.p to i64
  %r119 = call i64 @json_str(i64 %r117, i64 %r118)
  %r120.p = getelementptr inbounds [11 x i8], ptr @.str.69, i64 0, i64 0
  %r120 = ptrtoint ptr %r120.p to i64
  %r121.p = getelementptr inbounds [27 x i8], ptr @.str.77, i64 0, i64 0
  %r121 = ptrtoint ptr %r121.p to i64
  %r122 = call i64 @json_str(i64 %r120, i64 %r121)
  %r123.p = getelementptr inbounds [17 x i8], ptr @.str.71, i64 0, i64 0
  %r123 = ptrtoint ptr %r123.p to i64
  %r124 = add i64 2, 0
  %r125 = call i64 @json_int(i64 %r123, i64 %r124)
  %r110 = call i64 @nova_rt_list_create()
  call i64 @nova_rt_list_append(i64 %r110, i64 %r113)
  call i64 @nova_rt_list_append(i64 %r110, i64 %r116)
  call i64 @nova_rt_list_append(i64 %r110, i64 %r119)
  call i64 @nova_rt_list_append(i64 %r110, i64 %r122)
  call i64 @nova_rt_list_append(i64 %r110, i64 %r125)
  %r126 = call i64 @json_obj(i64 %r110)
  store i64 %r126, ptr %slot.if_snip, align 8
  %r127 = load i64, ptr %slot.items, align 8
  %r128 = load i64, ptr %slot.if_snip, align 8
  %r129 = call i64 @nova_rt_list_append(i64 %r127, i64 %r128)
  %r130 = load i64, ptr %slot.items, align 8
  %r131 = call i64 @json_arr(i64 %r130)
  ret i64 %r131
}

define i64 @hover_info(i64 %p0) nounwind {
entry:
  %slot.word = alloca i64, align 8
  store i64 %p0, ptr %slot.word, align 8
  %r0 = load i64, ptr %slot.word, align 8
  %r1.p = getelementptr inbounds [3 x i8], ptr @.str.67, i64 0, i64 0
  %r1 = ptrtoint ptr %r1.p to i64
  %r2 = call i64 @nova_rt_eq(i64 %r0, i64 %r1)
  %br_then296 = icmp ne i64 %r2, 0
  br i1 %br_then296, label %then296, label %else297
then296:
  %r3.p = getelementptr inbounds [79 x i8], ptr @.str.78, i64 0, i64 0
  %r3 = ptrtoint ptr %r3.p to i64
  ret i64 %r3
else297:
  br label %endif298
endif298:
  %r4 = load i64, ptr %slot.word, align 8
  %r5.p = getelementptr inbounds [4 x i8], ptr @.str.79, i64 0, i64 0
  %r5 = ptrtoint ptr %r5.p to i64
  %r6 = call i64 @nova_rt_eq(i64 %r4, i64 %r5)
  %br_then299 = icmp ne i64 %r6, 0
  br i1 %br_then299, label %then299, label %else300
then299:
  %r7.p = getelementptr inbounds [72 x i8], ptr @.str.80, i64 0, i64 0
  %r7 = ptrtoint ptr %r7.p to i64
  ret i64 %r7
else300:
  br label %endif301
endif301:
  %r8 = load i64, ptr %slot.word, align 8
  %r9.p = getelementptr inbounds [6 x i8], ptr @.str.81, i64 0, i64 0
  %r9 = ptrtoint ptr %r9.p to i64
  %r10 = call i64 @nova_rt_eq(i64 %r8, i64 %r9)
  %br_then302 = icmp ne i64 %r10, 0
  br i1 %br_then302, label %then302, label %else303
then302:
  %r11.p = getelementptr inbounds [62 x i8], ptr @.str.82, i64 0, i64 0
  %r11 = ptrtoint ptr %r11.p to i64
  ret i64 %r11
else303:
  br label %endif304
endif304:
  %r12 = load i64, ptr %slot.word, align 8
  %r13.p = getelementptr inbounds [4 x i8], ptr @.str.83, i64 0, i64 0
  %r13 = ptrtoint ptr %r13.p to i64
  %r14 = call i64 @nova_rt_eq(i64 %r12, i64 %r13)
  %br_then305 = icmp ne i64 %r14, 0
  br i1 %br_then305, label %then305, label %else306
then305:
  %r15.p = getelementptr inbounds [56 x i8], ptr @.str.84, i64 0, i64 0
  %r15 = ptrtoint ptr %r15.p to i64
  ret i64 %r15
else306:
  br label %endif307
endif307:
  %r16 = load i64, ptr %slot.word, align 8
  %r17.p = getelementptr inbounds [5 x i8], ptr @.str.85, i64 0, i64 0
  %r17 = ptrtoint ptr %r17.p to i64
  %r18 = call i64 @nova_rt_eq(i64 %r16, i64 %r17)
  %br_then308 = icmp ne i64 %r18, 0
  br i1 %br_then308, label %then308, label %else309
then308:
  %r19.p = getelementptr inbounds [49 x i8], ptr @.str.86, i64 0, i64 0
  %r19 = ptrtoint ptr %r19.p to i64
  ret i64 %r19
else309:
  br label %endif310
endif310:
  %r20 = load i64, ptr %slot.word, align 8
  %r21.p = getelementptr inbounds [6 x i8], ptr @.str.87, i64 0, i64 0
  %r21 = ptrtoint ptr %r21.p to i64
  %r22 = call i64 @nova_rt_eq(i64 %r20, i64 %r21)
  %br_then311 = icmp ne i64 %r22, 0
  br i1 %br_then311, label %then311, label %else312
then311:
  %r23.p = getelementptr inbounds [56 x i8], ptr @.str.88, i64 0, i64 0
  %r23 = ptrtoint ptr %r23.p to i64
  ret i64 %r23
else312:
  br label %endif313
endif313:
  %r24 = load i64, ptr %slot.word, align 8
  %r25.p = getelementptr inbounds [5 x i8], ptr @.str.89, i64 0, i64 0
  %r25 = ptrtoint ptr %r25.p to i64
  %r26 = call i64 @nova_rt_eq(i64 %r24, i64 %r25)
  %br_then314 = icmp ne i64 %r26, 0
  br i1 %br_then314, label %then314, label %else315
then314:
  %r27.p = getelementptr inbounds [66 x i8], ptr @.str.90, i64 0, i64 0
  %r27 = ptrtoint ptr %r27.p to i64
  ret i64 %r27
else315:
  br label %endif316
endif316:
  %r28 = load i64, ptr %slot.word, align 8
  %r29.p = getelementptr inbounds [5 x i8], ptr @.str.91, i64 0, i64 0
  %r29 = ptrtoint ptr %r29.p to i64
  %r30 = call i64 @nova_rt_eq(i64 %r28, i64 %r29)
  %br_then317 = icmp ne i64 %r30, 0
  br i1 %br_then317, label %then317, label %else318
then317:
  %r31.p = getelementptr inbounds [61 x i8], ptr @.str.92, i64 0, i64 0
  %r31 = ptrtoint ptr %r31.p to i64
  ret i64 %r31
else318:
  br label %endif319
endif319:
  %r32 = load i64, ptr %slot.word, align 8
  %r33.p = getelementptr inbounds [6 x i8], ptr @.str.93, i64 0, i64 0
  %r33 = ptrtoint ptr %r33.p to i64
  %r34 = call i64 @nova_rt_eq(i64 %r32, i64 %r33)
  %br_then320 = icmp ne i64 %r34, 0
  br i1 %br_then320, label %then320, label %else321
then320:
  %r35.p = getelementptr inbounds [53 x i8], ptr @.str.94, i64 0, i64 0
  %r35 = ptrtoint ptr %r35.p to i64
  ret i64 %r35
else321:
  br label %endif322
endif322:
  %r36 = load i64, ptr %slot.word, align 8
  %r37.p = getelementptr inbounds [9 x i8], ptr @.str.95, i64 0, i64 0
  %r37 = ptrtoint ptr %r37.p to i64
  %r38 = call i64 @nova_rt_eq(i64 %r36, i64 %r37)
  %br_then323 = icmp ne i64 %r38, 0
  br i1 %br_then323, label %then323, label %else324
then323:
  %r39.p = getelementptr inbounds [47 x i8], ptr @.str.96, i64 0, i64 0
  %r39 = ptrtoint ptr %r39.p to i64
  ret i64 %r39
else324:
  br label %endif325
endif325:
  %r40 = load i64, ptr %slot.word, align 8
  %r41.p = getelementptr inbounds [6 x i8], ptr @.str.97, i64 0, i64 0
  %r41 = ptrtoint ptr %r41.p to i64
  %r42 = call i64 @nova_rt_eq(i64 %r40, i64 %r41)
  %br_then326 = icmp ne i64 %r42, 0
  br i1 %br_then326, label %then326, label %else327
then326:
  %r43.p = getelementptr inbounds [76 x i8], ptr @.str.98, i64 0, i64 0
  %r43 = ptrtoint ptr %r43.p to i64
  ret i64 %r43
else327:
  br label %endif328
endif328:
  %r44 = load i64, ptr %slot.word, align 8
  %r45.p = getelementptr inbounds [8 x i8], ptr @.str.99, i64 0, i64 0
  %r45 = ptrtoint ptr %r45.p to i64
  %r46 = call i64 @nova_rt_eq(i64 %r44, i64 %r45)
  %br_then329 = icmp ne i64 %r46, 0
  br i1 %br_then329, label %then329, label %else330
then329:
  %r47.p = getelementptr inbounds [58 x i8], ptr @.str.100, i64 0, i64 0
  %r47 = ptrtoint ptr %r47.p to i64
  ret i64 %r47
else330:
  br label %endif331
endif331:
  %r48 = load i64, ptr %slot.word, align 8
  %r49.p = getelementptr inbounds [5 x i8], ptr @.str.101, i64 0, i64 0
  %r49 = ptrtoint ptr %r49.p to i64
  %r50 = call i64 @nova_rt_eq(i64 %r48, i64 %r49)
  %br_then332 = icmp ne i64 %r50, 0
  br i1 %br_then332, label %then332, label %else333
then332:
  %r51.p = getelementptr inbounds [48 x i8], ptr @.str.102, i64 0, i64 0
  %r51 = ptrtoint ptr %r51.p to i64
  ret i64 %r51
else333:
  br label %endif334
endif334:
  %r52 = load i64, ptr %slot.word, align 8
  %r53.p = getelementptr inbounds [8 x i8], ptr @.str.103, i64 0, i64 0
  %r53 = ptrtoint ptr %r53.p to i64
  %r54 = call i64 @nova_rt_eq(i64 %r52, i64 %r53)
  %br_then335 = icmp ne i64 %r54, 0
  br i1 %br_then335, label %then335, label %else336
then335:
  %r55.p = getelementptr inbounds [58 x i8], ptr @.str.104, i64 0, i64 0
  %r55 = ptrtoint ptr %r55.p to i64
  ret i64 %r55
else336:
  br label %endif337
endif337:
  %r56 = load i64, ptr %slot.word, align 8
  %r57.p = getelementptr inbounds [6 x i8], ptr @.str.105, i64 0, i64 0
  %r57 = ptrtoint ptr %r57.p to i64
  %r58 = call i64 @nova_rt_eq(i64 %r56, i64 %r57)
  %br_then338 = icmp ne i64 %r58, 0
  br i1 %br_then338, label %then338, label %else339
then338:
  %r59.p = getelementptr inbounds [102 x i8], ptr @.str.106, i64 0, i64 0
  %r59 = ptrtoint ptr %r59.p to i64
  ret i64 %r59
else339:
  br label %endif340
endif340:
  %r60 = load i64, ptr %slot.word, align 8
  %r61.p = getelementptr inbounds [4 x i8], ptr @.str.107, i64 0, i64 0
  %r61 = ptrtoint ptr %r61.p to i64
  %r62 = call i64 @nova_rt_eq(i64 %r60, i64 %r61)
  %br_then341 = icmp ne i64 %r62, 0
  br i1 %br_then341, label %then341, label %else342
then341:
  %r63.p = getelementptr inbounds [41 x i8], ptr @.str.108, i64 0, i64 0
  %r63 = ptrtoint ptr %r63.p to i64
  ret i64 %r63
else342:
  br label %endif343
endif343:
  %r64 = load i64, ptr %slot.word, align 8
  %r65.p = getelementptr inbounds [6 x i8], ptr @.str.109, i64 0, i64 0
  %r65 = ptrtoint ptr %r65.p to i64
  %r66 = call i64 @nova_rt_eq(i64 %r64, i64 %r65)
  %br_then344 = icmp ne i64 %r66, 0
  br i1 %br_then344, label %then344, label %else345
then344:
  %r67.p = getelementptr inbounds [43 x i8], ptr @.str.110, i64 0, i64 0
  %r67 = ptrtoint ptr %r67.p to i64
  ret i64 %r67
else345:
  br label %endif346
endif346:
  %r68 = load i64, ptr %slot.word, align 8
  %r69.p = getelementptr inbounds [7 x i8], ptr @.str.111, i64 0, i64 0
  %r69 = ptrtoint ptr %r69.p to i64
  %r70 = call i64 @nova_rt_eq(i64 %r68, i64 %r69)
  %br_then347 = icmp ne i64 %r70, 0
  br i1 %br_then347, label %then347, label %else348
then347:
  %r71.p = getelementptr inbounds [73 x i8], ptr @.str.112, i64 0, i64 0
  %r71 = ptrtoint ptr %r71.p to i64
  ret i64 %r71
else348:
  br label %endif349
endif349:
  %r72 = load i64, ptr %slot.word, align 8
  %r73.p = getelementptr inbounds [5 x i8], ptr @.str.66, i64 0, i64 0
  %r73 = ptrtoint ptr %r73.p to i64
  %r74 = call i64 @nova_rt_eq(i64 %r72, i64 %r73)
  %br_then350 = icmp ne i64 %r74, 0
  br i1 %br_then350, label %then350, label %else351
then350:
  %r75.p = getelementptr inbounds [67 x i8], ptr @.str.113, i64 0, i64 0
  %r75 = ptrtoint ptr %r75.p to i64
  ret i64 %r75
else351:
  br label %endif352
endif352:
  %r76 = load i64, ptr %slot.word, align 8
  %r77.p = getelementptr inbounds [4 x i8], ptr @.str.72, i64 0, i64 0
  %r77 = ptrtoint ptr %r77.p to i64
  %r78 = call i64 @nova_rt_eq(i64 %r76, i64 %r77)
  %br_then353 = icmp ne i64 %r78, 0
  br i1 %br_then353, label %then353, label %else354
then353:
  %r79.p = getelementptr inbounds [84 x i8], ptr @.str.114, i64 0, i64 0
  %r79 = ptrtoint ptr %r79.p to i64
  ret i64 %r79
else354:
  br label %endif355
endif355:
  %r80 = load i64, ptr %slot.word, align 8
  %r81.p = getelementptr inbounds [6 x i8], ptr @.str.115, i64 0, i64 0
  %r81 = ptrtoint ptr %r81.p to i64
  %r82 = call i64 @nova_rt_eq(i64 %r80, i64 %r81)
  %br_then356 = icmp ne i64 %r82, 0
  br i1 %br_then356, label %then356, label %else357
then356:
  %r83.p = getelementptr inbounds [80 x i8], ptr @.str.116, i64 0, i64 0
  %r83 = ptrtoint ptr %r83.p to i64
  ret i64 %r83
else357:
  br label %endif358
endif358:
  %r84 = load i64, ptr %slot.word, align 8
  %r85.p = getelementptr inbounds [10 x i8], ptr @.str.117, i64 0, i64 0
  %r85 = ptrtoint ptr %r85.p to i64
  %r86 = call i64 @nova_rt_eq(i64 %r84, i64 %r85)
  %br_then359 = icmp ne i64 %r86, 0
  br i1 %br_then359, label %then359, label %else360
then359:
  %r87.p = getelementptr inbounds [51 x i8], ptr @.str.118, i64 0, i64 0
  %r87 = ptrtoint ptr %r87.p to i64
  ret i64 %r87
else360:
  br label %endif361
endif361:
  %r88 = load i64, ptr %slot.word, align 8
  %r89.p = getelementptr inbounds [11 x i8], ptr @.str.119, i64 0, i64 0
  %r89 = ptrtoint ptr %r89.p to i64
  %r90 = call i64 @nova_rt_eq(i64 %r88, i64 %r89)
  %br_then362 = icmp ne i64 %r90, 0
  br i1 %br_then362, label %then362, label %else363
then362:
  %r91.p = getelementptr inbounds [53 x i8], ptr @.str.120, i64 0, i64 0
  %r91 = ptrtoint ptr %r91.p to i64
  ret i64 %r91
else363:
  br label %endif364
endif364:
  %r92 = load i64, ptr %slot.word, align 8
  %r93.p = getelementptr inbounds [6 x i8], ptr @.str.121, i64 0, i64 0
  %r93 = ptrtoint ptr %r93.p to i64
  %r94 = call i64 @nova_rt_eq(i64 %r92, i64 %r93)
  %br_then365 = icmp ne i64 %r94, 0
  br i1 %br_then365, label %then365, label %else366
then365:
  %r95.p = getelementptr inbounds [57 x i8], ptr @.str.122, i64 0, i64 0
  %r95 = ptrtoint ptr %r95.p to i64
  ret i64 %r95
else366:
  br label %endif367
endif367:
  %r96 = load i64, ptr %slot.word, align 8
  %r97.p = getelementptr inbounds [10 x i8], ptr @.str.123, i64 0, i64 0
  %r97 = ptrtoint ptr %r97.p to i64
  %r98 = call i64 @nova_rt_eq(i64 %r96, i64 %r97)
  %br_then368 = icmp ne i64 %r98, 0
  br i1 %br_then368, label %then368, label %else369
then368:
  %r99.p = getelementptr inbounds [60 x i8], ptr @.str.124, i64 0, i64 0
  %r99 = ptrtoint ptr %r99.p to i64
  ret i64 %r99
else369:
  br label %endif370
endif370:
  %r100.p = getelementptr inbounds [1 x i8], ptr @.str.0, i64 0, i64 0
  %r100 = ptrtoint ptr %r100.p to i64
  ret i64 %r100
}

define i64 @handle_initialize(i64 %p0) nounwind {
entry:
  %slot.id = alloca i64, align 8
  store i64 %p0, ptr %slot.id, align 8
  %slot.sync = alloca i64, align 8
  store i64 0, ptr %slot.sync, align 8
  %slot.caps_parts = alloca i64, align 8
  store i64 0, ptr %slot.caps_parts, align 8
  %slot.caps = alloca i64, align 8
  store i64 0, ptr %slot.caps, align 8
  %slot.sinfo = alloca i64, align 8
  store i64 0, ptr %slot.sinfo, align 8
  %slot.result = alloca i64, align 8
  store i64 0, ptr %slot.result, align 8
  %r1.p = getelementptr inbounds [10 x i8], ptr @.str.125, i64 0, i64 0
  %r1 = ptrtoint ptr %r1.p to i64
  %r2 = add i64 1, 0
  %r3 = call i64 @json_int(i64 %r1, i64 %r2)
  %r4.p = getelementptr inbounds [7 x i8], ptr @.str.126, i64 0, i64 0
  %r4 = ptrtoint ptr %r4.p to i64
  %r5 = add i64 1, 0
  %r6 = call i64 @json_int(i64 %r4, i64 %r5)
  %r0 = call i64 @nova_rt_list_create()
  call i64 @nova_rt_list_append(i64 %r0, i64 %r3)
  call i64 @nova_rt_list_append(i64 %r0, i64 %r6)
  %r7 = call i64 @json_obj(i64 %r0)
  store i64 %r7, ptr %slot.sync, align 8
  %r9.p = getelementptr inbounds [20 x i8], ptr @.str.127, i64 0, i64 0
  %r9 = ptrtoint ptr %r9.p to i64
  %r10 = load i64, ptr %slot.sync, align 8
  %r11 = call i64 @nova_rt_add(i64 %r9, i64 %r10)
  %r12.p = getelementptr inbounds [19 x i8], ptr @.str.128, i64 0, i64 0
  %r12 = ptrtoint ptr %r12.p to i64
  %r13 = add i64 1, 0
  %r14 = call i64 @json_bool(i64 %r12, i64 %r13)
  %r15.p = getelementptr inbounds [14 x i8], ptr @.str.129, i64 0, i64 0
  %r15 = ptrtoint ptr %r15.p to i64
  %r16 = add i64 1, 0
  %r17 = call i64 @json_bool(i64 %r15, i64 %r16)
  %r8 = call i64 @nova_rt_list_create()
  call i64 @nova_rt_list_append(i64 %r8, i64 %r11)
  call i64 @nova_rt_list_append(i64 %r8, i64 %r14)
  call i64 @nova_rt_list_append(i64 %r8, i64 %r17)
  store i64 %r8, ptr %slot.caps_parts, align 8
  %r18 = load i64, ptr %slot.caps_parts, align 8
  %r19 = call i64 @json_obj(i64 %r18)
  store i64 %r19, ptr %slot.caps, align 8
  %r21.p = getelementptr inbounds [5 x i8], ptr @.str.130, i64 0, i64 0
  %r21 = ptrtoint ptr %r21.p to i64
  %r22.p = getelementptr inbounds [9 x i8], ptr @.str.131, i64 0, i64 0
  %r22 = ptrtoint ptr %r22.p to i64
  %r23 = call i64 @json_str(i64 %r21, i64 %r22)
  %r24.p = getelementptr inbounds [8 x i8], ptr @.str.132, i64 0, i64 0
  %r24 = ptrtoint ptr %r24.p to i64
  %r25.p = getelementptr inbounds [6 x i8], ptr @.str.133, i64 0, i64 0
  %r25 = ptrtoint ptr %r25.p to i64
  %r26 = call i64 @json_str(i64 %r24, i64 %r25)
  %r20 = call i64 @nova_rt_list_create()
  call i64 @nova_rt_list_append(i64 %r20, i64 %r23)
  call i64 @nova_rt_list_append(i64 %r20, i64 %r26)
  %r27 = call i64 @json_obj(i64 %r20)
  store i64 %r27, ptr %slot.sinfo, align 8
  %r29.p = getelementptr inbounds [16 x i8], ptr @.str.134, i64 0, i64 0
  %r29 = ptrtoint ptr %r29.p to i64
  %r30 = load i64, ptr %slot.caps, align 8
  %r31 = call i64 @nova_rt_add(i64 %r29, i64 %r30)
  %r32.p = getelementptr inbounds [14 x i8], ptr @.str.135, i64 0, i64 0
  %r32 = ptrtoint ptr %r32.p to i64
  %r33 = load i64, ptr %slot.sinfo, align 8
  %r34 = call i64 @nova_rt_add(i64 %r32, i64 %r33)
  %r28 = call i64 @nova_rt_list_create()
  call i64 @nova_rt_list_append(i64 %r28, i64 %r31)
  call i64 @nova_rt_list_append(i64 %r28, i64 %r34)
  %r35 = call i64 @json_obj(i64 %r28)
  store i64 %r35, ptr %slot.result, align 8
  %r37.p = getelementptr inbounds [8 x i8], ptr @.str.136, i64 0, i64 0
  %r37 = ptrtoint ptr %r37.p to i64
  %r38.p = getelementptr inbounds [4 x i8], ptr @.str.137, i64 0, i64 0
  %r38 = ptrtoint ptr %r38.p to i64
  %r39 = call i64 @json_str(i64 %r37, i64 %r38)
  %r40.p = getelementptr inbounds [6 x i8], ptr @.str.138, i64 0, i64 0
  %r40 = ptrtoint ptr %r40.p to i64
  %r41 = load i64, ptr %slot.id, align 8
  %r42 = call i64 @nova_rt_add(i64 %r40, i64 %r41)
  %r43.p = getelementptr inbounds [10 x i8], ptr @.str.139, i64 0, i64 0
  %r43 = ptrtoint ptr %r43.p to i64
  %r44 = load i64, ptr %slot.result, align 8
  %r45 = call i64 @nova_rt_add(i64 %r43, i64 %r44)
  %r36 = call i64 @nova_rt_list_create()
  call i64 @nova_rt_list_append(i64 %r36, i64 %r39)
  call i64 @nova_rt_list_append(i64 %r36, i64 %r42)
  call i64 @nova_rt_list_append(i64 %r36, i64 %r45)
  %r46 = call i64 @json_obj(i64 %r36)
  ret i64 %r46
}

define i64 @handle_completion(i64 %p0) nounwind {
entry:
  %slot.id = alloca i64, align 8
  store i64 %p0, ptr %slot.id, align 8
  %slot.items = alloca i64, align 8
  store i64 0, ptr %slot.items, align 8
  %r0 = call i64 @build_completion_items()
  store i64 %r0, ptr %slot.items, align 8
  %r2.p = getelementptr inbounds [8 x i8], ptr @.str.136, i64 0, i64 0
  %r2 = ptrtoint ptr %r2.p to i64
  %r3.p = getelementptr inbounds [4 x i8], ptr @.str.137, i64 0, i64 0
  %r3 = ptrtoint ptr %r3.p to i64
  %r4 = call i64 @json_str(i64 %r2, i64 %r3)
  %r5.p = getelementptr inbounds [6 x i8], ptr @.str.138, i64 0, i64 0
  %r5 = ptrtoint ptr %r5.p to i64
  %r6 = load i64, ptr %slot.id, align 8
  %r7 = call i64 @nova_rt_add(i64 %r5, i64 %r6)
  %r8.p = getelementptr inbounds [10 x i8], ptr @.str.139, i64 0, i64 0
  %r8 = ptrtoint ptr %r8.p to i64
  %r9 = load i64, ptr %slot.items, align 8
  %r10 = call i64 @nova_rt_add(i64 %r8, i64 %r9)
  %r1 = call i64 @nova_rt_list_create()
  call i64 @nova_rt_list_append(i64 %r1, i64 %r4)
  call i64 @nova_rt_list_append(i64 %r1, i64 %r7)
  call i64 @nova_rt_list_append(i64 %r1, i64 %r10)
  %r11 = call i64 @json_obj(i64 %r1)
  ret i64 %r11
}

define i64 @handle_hover(i64 %p0, i64 %p1) nounwind {
entry:
  %slot.id = alloca i64, align 8
  store i64 %p0, ptr %slot.id, align 8
  %slot.params = alloca i64, align 8
  store i64 %p1, ptr %slot.params, align 8
  %slot.text_doc = alloca i64, align 8
  store i64 0, ptr %slot.text_doc, align 8
  %slot.position = alloca i64, align 8
  store i64 0, ptr %slot.position, align 8
  %r0 = load i64, ptr %slot.params, align 8
  %r1.p = getelementptr inbounds [13 x i8], ptr @.str.140, i64 0, i64 0
  %r1 = ptrtoint ptr %r1.p to i64
  %r2 = call i64 @extract_json_field(i64 %r0, i64 %r1)
  store i64 %r2, ptr %slot.text_doc, align 8
  %r3 = load i64, ptr %slot.params, align 8
  %r4.p = getelementptr inbounds [9 x i8], ptr @.str.141, i64 0, i64 0
  %r4 = ptrtoint ptr %r4.p to i64
  %r5 = call i64 @extract_json_field(i64 %r3, i64 %r4)
  store i64 %r5, ptr %slot.position, align 8
  %r7.p = getelementptr inbounds [8 x i8], ptr @.str.136, i64 0, i64 0
  %r7 = ptrtoint ptr %r7.p to i64
  %r8.p = getelementptr inbounds [4 x i8], ptr @.str.137, i64 0, i64 0
  %r8 = ptrtoint ptr %r8.p to i64
  %r9 = call i64 @json_str(i64 %r7, i64 %r8)
  %r10.p = getelementptr inbounds [6 x i8], ptr @.str.138, i64 0, i64 0
  %r10 = ptrtoint ptr %r10.p to i64
  %r11 = load i64, ptr %slot.id, align 8
  %r12 = call i64 @nova_rt_add(i64 %r10, i64 %r11)
  %r13.p = getelementptr inbounds [7 x i8], ptr @.str.142, i64 0, i64 0
  %r13 = ptrtoint ptr %r13.p to i64
  %r14 = call i64 @json_null(i64 %r13)
  %r6 = call i64 @nova_rt_list_create()
  call i64 @nova_rt_list_append(i64 %r6, i64 %r9)
  call i64 @nova_rt_list_append(i64 %r6, i64 %r12)
  call i64 @nova_rt_list_append(i64 %r6, i64 %r14)
  %r15 = call i64 @json_obj(i64 %r6)
  ret i64 %r15
}

define i64 @build_diagnostics_notification(i64 %p0, i64 %p1) nounwind {
entry:
  %slot.uri = alloca i64, align 8
  store i64 %p0, ptr %slot.uri, align 8
  %slot.diags = alloca i64, align 8
  store i64 %p1, ptr %slot.diags, align 8
  %slot.diag_items = alloca i64, align 8
  store i64 0, ptr %slot.diag_items, align 8
  %slot.__for_idx_371 = alloca i64, align 8
  store i64 0, ptr %slot.__for_idx_371, align 8
  %slot.d = alloca i64, align 8
  store i64 0, ptr %slot.d, align 8
  %slot.line = alloca i64, align 8
  store i64 0, ptr %slot.line, align 8
  %slot.col = alloca i64, align 8
  store i64 0, ptr %slot.col, align 8
  %slot.msg = alloca i64, align 8
  store i64 0, ptr %slot.msg, align 8
  %slot.start_pos = alloca i64, align 8
  store i64 0, ptr %slot.start_pos, align 8
  %slot.end_pos = alloca i64, align 8
  store i64 0, ptr %slot.end_pos, align 8
  %slot.range_obj = alloca i64, align 8
  store i64 0, ptr %slot.range_obj, align 8
  %slot.diag = alloca i64, align 8
  store i64 0, ptr %slot.diag, align 8
  %slot.params = alloca i64, align 8
  store i64 0, ptr %slot.params, align 8
  %r0 = call i64 @nova_rt_list_create()
  store i64 %r0, ptr %slot.diag_items, align 8
  %r1 = load i64, ptr %slot.diags, align 8
  %r2 = call i64 @nova_rt_len_any(i64 %r1)
  %r3 = add i64 0, 0
  store i64 %r3, ptr %slot.__for_idx_371, align 8
  br label %for_hdr371
for_hdr371:
  %r4 = load i64, ptr %slot.__for_idx_371, align 8
  %r5.cmp = icmp slt i64 %r4, %r2
  %r5 = zext i1 %r5.cmp to i64
  %br_for_body372 = icmp ne i64 %r5, 0
  br i1 %br_for_body372, label %for_body372, label %for_exit373
for_body372:
  %r6 = call i64 @nova_rt_index_get(i64 %r1, i64 %r4)
  store i64 %r6, ptr %slot.d, align 8
  %r7 = load i64, ptr %slot.d, align 8
  %r8 = add i64 0, 0
  %r9 = call i64 @nova_rt_index_get(i64 %r7, i64 %r8)
  store i64 %r9, ptr %slot.line, align 8
  %r10 = load i64, ptr %slot.d, align 8
  %r11 = add i64 1, 0
  %r12 = call i64 @nova_rt_index_get(i64 %r10, i64 %r11)
  store i64 %r12, ptr %slot.col, align 8
  %r13 = load i64, ptr %slot.d, align 8
  %r14 = add i64 2, 0
  %r15 = call i64 @nova_rt_index_get(i64 %r13, i64 %r14)
  store i64 %r15, ptr %slot.msg, align 8
  %r17.p = getelementptr inbounds [5 x i8], ptr @.str.143, i64 0, i64 0
  %r17 = ptrtoint ptr %r17.p to i64
  %r18 = load i64, ptr %slot.line, align 8
  %r19 = call i64 @json_int(i64 %r17, i64 %r18)
  %r20.p = getelementptr inbounds [10 x i8], ptr @.str.144, i64 0, i64 0
  %r20 = ptrtoint ptr %r20.p to i64
  %r21 = load i64, ptr %slot.col, align 8
  %r22 = call i64 @json_int(i64 %r20, i64 %r21)
  %r16 = call i64 @nova_rt_list_create()
  call i64 @nova_rt_list_append(i64 %r16, i64 %r19)
  call i64 @nova_rt_list_append(i64 %r16, i64 %r22)
  %r23 = call i64 @json_obj(i64 %r16)
  store i64 %r23, ptr %slot.start_pos, align 8
  %r25.p = getelementptr inbounds [5 x i8], ptr @.str.143, i64 0, i64 0
  %r25 = ptrtoint ptr %r25.p to i64
  %r26 = load i64, ptr %slot.line, align 8
  %r27 = call i64 @json_int(i64 %r25, i64 %r26)
  %r28.p = getelementptr inbounds [10 x i8], ptr @.str.144, i64 0, i64 0
  %r28 = ptrtoint ptr %r28.p to i64
  %r29 = load i64, ptr %slot.col, align 8
  %r30 = add i64 1, 0
  %r31 = call i64 @nova_rt_add(i64 %r29, i64 %r30)
  %r32 = call i64 @json_int(i64 %r28, i64 %r31)
  %r24 = call i64 @nova_rt_list_create()
  call i64 @nova_rt_list_append(i64 %r24, i64 %r27)
  call i64 @nova_rt_list_append(i64 %r24, i64 %r32)
  %r33 = call i64 @json_obj(i64 %r24)
  store i64 %r33, ptr %slot.end_pos, align 8
  %r35.p = getelementptr inbounds [9 x i8], ptr @.str.145, i64 0, i64 0
  %r35 = ptrtoint ptr %r35.p to i64
  %r36 = load i64, ptr %slot.start_pos, align 8
  %r37 = call i64 @nova_rt_add(i64 %r35, i64 %r36)
  %r38.p = getelementptr inbounds [7 x i8], ptr @.str.146, i64 0, i64 0
  %r38 = ptrtoint ptr %r38.p to i64
  %r39 = load i64, ptr %slot.end_pos, align 8
  %r40 = call i64 @nova_rt_add(i64 %r38, i64 %r39)
  %r34 = call i64 @nova_rt_list_create()
  call i64 @nova_rt_list_append(i64 %r34, i64 %r37)
  call i64 @nova_rt_list_append(i64 %r34, i64 %r40)
  %r41 = call i64 @json_obj(i64 %r34)
  store i64 %r41, ptr %slot.range_obj, align 8
  %r43.p = getelementptr inbounds [9 x i8], ptr @.str.147, i64 0, i64 0
  %r43 = ptrtoint ptr %r43.p to i64
  %r44 = load i64, ptr %slot.range_obj, align 8
  %r45 = call i64 @nova_rt_add(i64 %r43, i64 %r44)
  %r46.p = getelementptr inbounds [9 x i8], ptr @.str.148, i64 0, i64 0
  %r46 = ptrtoint ptr %r46.p to i64
  %r47 = add i64 2, 0
  %r48 = call i64 @json_int(i64 %r46, i64 %r47)
  %r49.p = getelementptr inbounds [7 x i8], ptr @.str.149, i64 0, i64 0
  %r49 = ptrtoint ptr %r49.p to i64
  %r50.p = getelementptr inbounds [5 x i8], ptr @.str.150, i64 0, i64 0
  %r50 = ptrtoint ptr %r50.p to i64
  %r51 = call i64 @json_str(i64 %r49, i64 %r50)
  %r52.p = getelementptr inbounds [8 x i8], ptr @.str.151, i64 0, i64 0
  %r52 = ptrtoint ptr %r52.p to i64
  %r53 = load i64, ptr %slot.msg, align 8
  %r54 = call i64 @json_str(i64 %r52, i64 %r53)
  %r42 = call i64 @nova_rt_list_create()
  call i64 @nova_rt_list_append(i64 %r42, i64 %r45)
  call i64 @nova_rt_list_append(i64 %r42, i64 %r48)
  call i64 @nova_rt_list_append(i64 %r42, i64 %r51)
  call i64 @nova_rt_list_append(i64 %r42, i64 %r54)
  %r55 = call i64 @json_obj(i64 %r42)
  store i64 %r55, ptr %slot.diag, align 8
  %r56 = load i64, ptr %slot.diag_items, align 8
  %r57 = load i64, ptr %slot.diag, align 8
  %r58 = call i64 @nova_rt_list_append(i64 %r56, i64 %r57)
  %r59 = load i64, ptr %slot.__for_idx_371, align 8
  %r60 = add i64 1, 0
  %r61 = call i64 @nova_rt_add(i64 %r59, i64 %r60)
  store i64 %r61, ptr %slot.__for_idx_371, align 8
  br label %for_hdr371
for_exit373:
  %r63.p = getelementptr inbounds [4 x i8], ptr @.str.152, i64 0, i64 0
  %r63 = ptrtoint ptr %r63.p to i64
  %r64 = load i64, ptr %slot.uri, align 8
  %r65 = call i64 @json_str(i64 %r63, i64 %r64)
  %r66.p = getelementptr inbounds [15 x i8], ptr @.str.153, i64 0, i64 0
  %r66 = ptrtoint ptr %r66.p to i64
  %r67 = load i64, ptr %slot.diag_items, align 8
  %r68 = call i64 @json_arr(i64 %r67)
  %r69 = call i64 @nova_rt_add(i64 %r66, i64 %r68)
  %r62 = call i64 @nova_rt_list_create()
  call i64 @nova_rt_list_append(i64 %r62, i64 %r65)
  call i64 @nova_rt_list_append(i64 %r62, i64 %r69)
  %r70 = call i64 @json_obj(i64 %r62)
  store i64 %r70, ptr %slot.params, align 8
  %r72.p = getelementptr inbounds [8 x i8], ptr @.str.136, i64 0, i64 0
  %r72 = ptrtoint ptr %r72.p to i64
  %r73.p = getelementptr inbounds [4 x i8], ptr @.str.137, i64 0, i64 0
  %r73 = ptrtoint ptr %r73.p to i64
  %r74 = call i64 @json_str(i64 %r72, i64 %r73)
  %r75.p = getelementptr inbounds [7 x i8], ptr @.str.154, i64 0, i64 0
  %r75 = ptrtoint ptr %r75.p to i64
  %r76.p = getelementptr inbounds [32 x i8], ptr @.str.155, i64 0, i64 0
  %r76 = ptrtoint ptr %r76.p to i64
  %r77 = call i64 @json_str(i64 %r75, i64 %r76)
  %r78.p = getelementptr inbounds [10 x i8], ptr @.str.156, i64 0, i64 0
  %r78 = ptrtoint ptr %r78.p to i64
  %r79 = load i64, ptr %slot.params, align 8
  %r80 = call i64 @nova_rt_add(i64 %r78, i64 %r79)
  %r71 = call i64 @nova_rt_list_create()
  call i64 @nova_rt_list_append(i64 %r71, i64 %r74)
  call i64 @nova_rt_list_append(i64 %r71, i64 %r77)
  call i64 @nova_rt_list_append(i64 %r71, i64 %r80)
  %r81 = call i64 @json_obj(i64 %r71)
  ret i64 %r81
}

define i64 @on_did_open(i64 %p0) nounwind {
entry:
  %slot.params = alloca i64, align 8
  store i64 %p0, ptr %slot.params, align 8
  %slot.text_doc = alloca i64, align 8
  store i64 0, ptr %slot.text_doc, align 8
  %slot.uri = alloca i64, align 8
  store i64 0, ptr %slot.uri, align 8
  %slot.text = alloca i64, align 8
  store i64 0, ptr %slot.text, align 8
  %slot.documents = alloca i64, align 8
  store i64 0, ptr %slot.documents, align 8
  %slot.diags = alloca i64, align 8
  store i64 0, ptr %slot.diags, align 8
  %slot.notif = alloca i64, align 8
  store i64 0, ptr %slot.notif, align 8
  %r0 = load i64, ptr %slot.params, align 8
  %r1.p = getelementptr inbounds [13 x i8], ptr @.str.140, i64 0, i64 0
  %r1 = ptrtoint ptr %r1.p to i64
  %r2 = call i64 @extract_json_field(i64 %r0, i64 %r1)
  store i64 %r2, ptr %slot.text_doc, align 8
  %r3 = load i64, ptr %slot.text_doc, align 8
  %r4.p = getelementptr inbounds [4 x i8], ptr @.str.152, i64 0, i64 0
  %r4 = ptrtoint ptr %r4.p to i64
  %r5 = call i64 @extract_json_field(i64 %r3, i64 %r4)
  store i64 %r5, ptr %slot.uri, align 8
  %r6 = load i64, ptr %slot.text_doc, align 8
  %r7.p = getelementptr inbounds [5 x i8], ptr @.str.157, i64 0, i64 0
  %r7 = ptrtoint ptr %r7.p to i64
  %r8 = call i64 @extract_json_field(i64 %r6, i64 %r7)
  store i64 %r8, ptr %slot.text, align 8
  %r9 = load i64, ptr %slot.text, align 8
  %r10 = load i64, ptr %slot.documents, align 8
  %r11 = load i64, ptr %slot.uri, align 8
  call i64 @nova_rt_index_set(i64 %r10, i64 %r11, i64 %r9)
  %r12 = load i64, ptr %slot.text, align 8
  %r13 = call i64 @lsp_check_source(i64 %r12)
  store i64 %r13, ptr %slot.diags, align 8
  %r14 = load i64, ptr %slot.uri, align 8
  %r15 = load i64, ptr %slot.diags, align 8
  %r16 = call i64 @build_diagnostics_notification(i64 %r14, i64 %r15)
  store i64 %r16, ptr %slot.notif, align 8
  %r17 = load i64, ptr %slot.notif, align 8
  %r18 = call i64 @lsp_send(i64 %r17)
  ret i64 %r18
}

define i64 @on_did_change(i64 %p0) nounwind {
entry:
  %slot.params = alloca i64, align 8
  store i64 %p0, ptr %slot.params, align 8
  %slot.text_doc = alloca i64, align 8
  store i64 0, ptr %slot.text_doc, align 8
  %slot.uri = alloca i64, align 8
  store i64 0, ptr %slot.uri, align 8
  %slot.changes = alloca i64, align 8
  store i64 0, ptr %slot.changes, align 8
  %slot.text = alloca i64, align 8
  store i64 0, ptr %slot.text, align 8
  %slot.documents = alloca i64, align 8
  store i64 0, ptr %slot.documents, align 8
  %slot.diags = alloca i64, align 8
  store i64 0, ptr %slot.diags, align 8
  %slot.notif = alloca i64, align 8
  store i64 0, ptr %slot.notif, align 8
  %r0 = load i64, ptr %slot.params, align 8
  %r1.p = getelementptr inbounds [13 x i8], ptr @.str.140, i64 0, i64 0
  %r1 = ptrtoint ptr %r1.p to i64
  %r2 = call i64 @extract_json_field(i64 %r0, i64 %r1)
  store i64 %r2, ptr %slot.text_doc, align 8
  %r3 = load i64, ptr %slot.text_doc, align 8
  %r4.p = getelementptr inbounds [4 x i8], ptr @.str.152, i64 0, i64 0
  %r4 = ptrtoint ptr %r4.p to i64
  %r5 = call i64 @extract_json_field(i64 %r3, i64 %r4)
  store i64 %r5, ptr %slot.uri, align 8
  %r6 = load i64, ptr %slot.params, align 8
  %r7.p = getelementptr inbounds [15 x i8], ptr @.str.158, i64 0, i64 0
  %r7 = ptrtoint ptr %r7.p to i64
  %r8 = call i64 @extract_json_field(i64 %r6, i64 %r7)
  store i64 %r8, ptr %slot.changes, align 8
  %r9 = load i64, ptr %slot.changes, align 8
  %r10.p = getelementptr inbounds [5 x i8], ptr @.str.157, i64 0, i64 0
  %r10 = ptrtoint ptr %r10.p to i64
  %r11 = call i64 @extract_json_field(i64 %r9, i64 %r10)
  store i64 %r11, ptr %slot.text, align 8
  %r12 = load i64, ptr %slot.text, align 8
  %r13 = call i64 @nova_rt_len_any(i64 %r12)
  %r14 = add i64 0, 0
  %r15.cmp = icmp sgt i64 %r13, %r14
  %r15 = zext i1 %r15.cmp to i64
  %br_retthen374 = icmp ne i64 %r15, 0
  br i1 %br_retthen374, label %retthen374, label %retelse375
retthen374:
  %r16 = load i64, ptr %slot.text, align 8
  %r17 = load i64, ptr %slot.documents, align 8
  %r18 = load i64, ptr %slot.uri, align 8
  call i64 @nova_rt_index_set(i64 %r17, i64 %r18, i64 %r16)
  %r19 = load i64, ptr %slot.text, align 8
  %r20 = call i64 @lsp_check_source(i64 %r19)
  store i64 %r20, ptr %slot.diags, align 8
  %r21 = load i64, ptr %slot.uri, align 8
  %r22 = load i64, ptr %slot.diags, align 8
  %r23 = call i64 @build_diagnostics_notification(i64 %r21, i64 %r22)
  store i64 %r23, ptr %slot.notif, align 8
  %r24 = load i64, ptr %slot.notif, align 8
  %r25 = call i64 @lsp_send(i64 %r24)
  ret i64 %r25
retelse375:
  ret i64 0
}

define i64 @on_did_close(i64 %p0) nounwind {
entry:
  %slot.params = alloca i64, align 8
  store i64 %p0, ptr %slot.params, align 8
  %slot.text_doc = alloca i64, align 8
  store i64 0, ptr %slot.text_doc, align 8
  %slot.uri = alloca i64, align 8
  store i64 0, ptr %slot.uri, align 8
  %slot.empty_diags = alloca i64, align 8
  store i64 0, ptr %slot.empty_diags, align 8
  %r0 = load i64, ptr %slot.params, align 8
  %r1.p = getelementptr inbounds [13 x i8], ptr @.str.140, i64 0, i64 0
  %r1 = ptrtoint ptr %r1.p to i64
  %r2 = call i64 @extract_json_field(i64 %r0, i64 %r1)
  store i64 %r2, ptr %slot.text_doc, align 8
  %r3 = load i64, ptr %slot.text_doc, align 8
  %r4.p = getelementptr inbounds [4 x i8], ptr @.str.152, i64 0, i64 0
  %r4 = ptrtoint ptr %r4.p to i64
  %r5 = call i64 @extract_json_field(i64 %r3, i64 %r4)
  store i64 %r5, ptr %slot.uri, align 8
  %r6 = load i64, ptr %slot.uri, align 8
  %r7 = call i64 @nova_rt_list_create()
  %r8 = call i64 @build_diagnostics_notification(i64 %r6, i64 %r7)
  store i64 %r8, ptr %slot.empty_diags, align 8
  %r9 = load i64, ptr %slot.empty_diags, align 8
  %r10 = call i64 @lsp_send(i64 %r9)
  ret i64 %r10
}

define i64 @nova_user_main() nounwind {
entry:
  %slot.running = alloca i64, align 8
  store i64 0, ptr %slot.running, align 8
  %slot.header = alloca i64, align 8
  store i64 0, ptr %slot.header, align 8
  %slot.content_length = alloca i64, align 8
  store i64 0, ptr %slot.content_length, align 8
  %slot.len_str = alloca i64, align 8
  store i64 0, ptr %slot.len_str, align 8
  %slot.h = alloca i64, align 8
  store i64 0, ptr %slot.h, align 8
  %slot.body = alloca i64, align 8
  store i64 0, ptr %slot.body, align 8
  %slot.method = alloca i64, align 8
  store i64 0, ptr %slot.method, align 8
  %slot.id = alloca i64, align 8
  store i64 0, ptr %slot.id, align 8
  %slot.params = alloca i64, align 8
  store i64 0, ptr %slot.params, align 8
  %slot.resp = alloca i64, align 8
  store i64 0, ptr %slot.resp, align 8
  %r0 = add i64 1, 0
  store i64 %r0, ptr %slot.running, align 8
  br label %while_hdr376
while_hdr376:
  %r1 = load i64, ptr %slot.running, align 8
  %r2 = add i64 1, 0
  %r3 = call i64 @nova_rt_eq(i64 %r1, i64 %r2)
  %br_while_body377 = icmp ne i64 %r3, 0
  br i1 %br_while_body377, label %while_body377, label %while_exit378
while_body377:
  %r4 = call i64 @nova_rt_read_line()
  store i64 %r4, ptr %slot.header, align 8
  %r5 = load i64, ptr %slot.header, align 8
  %r6 = call i64 @nova_rt_len_any(i64 %r5)
  %r7 = add i64 0, 0
  %r8 = call i64 @nova_rt_eq(i64 %r6, i64 %r7)
  %br_then379 = icmp ne i64 %r8, 0
  br i1 %br_then379, label %then379, label %else380
then379:
  %r9 = add i64 0, 0
  store i64 %r9, ptr %slot.running, align 8
  br label %while_hdr376
else380:
  br label %endif381
endif381:
  %r10 = add i64 0, 0
  store i64 %r10, ptr %slot.content_length, align 8
  %r11 = load i64, ptr %slot.header, align 8
  %r12.p = getelementptr inbounds [16 x i8], ptr @.str.159, i64 0, i64 0
  %r12 = ptrtoint ptr %r12.p to i64
  %r13 = call i64 @nova_rt_starts_with(i64 %r11, i64 %r12)
  %br_then382 = icmp ne i64 %r13, 0
  br i1 %br_then382, label %then382, label %else383
then382:
  %r14 = load i64, ptr %slot.header, align 8
  %r15 = add i64 16, 0
  %r16 = load i64, ptr %slot.header, align 8
  %r17 = call i64 @nova_rt_len_any(i64 %r16)
  %r18 = call i64 @nova_rt_slice(i64 %r14, i64 %r15, i64 %r17)
  %r19 = call i64 @nova_rt_trim(i64 %r18)
  store i64 %r19, ptr %slot.len_str, align 8
  %r20 = load i64, ptr %slot.len_str, align 8
  %r21 = call i64 @nova_rt_parse_int(i64 %r20)
  store i64 %r21, ptr %slot.content_length, align 8
  br label %endif384
else383:
  br label %endif384
endif384:
  %r22 = call i64 @nova_rt_read_line()
  store i64 %r22, ptr %slot.h, align 8
  br label %while_hdr385
while_hdr385:
  %r23 = load i64, ptr %slot.h, align 8
  %r24 = call i64 @nova_rt_trim(i64 %r23)
  %r25 = call i64 @nova_rt_len_any(i64 %r24)
  %r26 = add i64 0, 0
  %r27.cmp = icmp sgt i64 %r25, %r26
  %r27 = zext i1 %r27.cmp to i64
  %br_while_body386 = icmp ne i64 %r27, 0
  br i1 %br_while_body386, label %while_body386, label %while_exit387
while_body386:
  %r28 = call i64 @nova_rt_read_line()
  store i64 %r28, ptr %slot.h, align 8
  br label %while_hdr385
while_exit387:
  %r29 = call i64 @nova_rt_read_line()
  store i64 %r29, ptr %slot.body, align 8
  %r30 = load i64, ptr %slot.body, align 8
  %r31 = call i64 @nova_rt_len_any(i64 %r30)
  %r32 = add i64 0, 0
  %r33 = call i64 @nova_rt_eq(i64 %r31, i64 %r32)
  %br_then388 = icmp ne i64 %r33, 0
  br i1 %br_then388, label %then388, label %else389
then388:
  br label %while_hdr376
else389:
  br label %endif390
endif390:
  %r34 = load i64, ptr %slot.body, align 8
  %r35.p = getelementptr inbounds [7 x i8], ptr @.str.154, i64 0, i64 0
  %r35 = ptrtoint ptr %r35.p to i64
  %r36 = call i64 @extract_json_field(i64 %r34, i64 %r35)
  store i64 %r36, ptr %slot.method, align 8
  %r37 = load i64, ptr %slot.body, align 8
  %r38.p = getelementptr inbounds [3 x i8], ptr @.str.160, i64 0, i64 0
  %r38 = ptrtoint ptr %r38.p to i64
  %r39 = call i64 @extract_json_field(i64 %r37, i64 %r38)
  store i64 %r39, ptr %slot.id, align 8
  %r40 = load i64, ptr %slot.body, align 8
  %r41.p = getelementptr inbounds [7 x i8], ptr @.str.161, i64 0, i64 0
  %r41 = ptrtoint ptr %r41.p to i64
  %r42 = call i64 @extract_json_field(i64 %r40, i64 %r41)
  store i64 %r42, ptr %slot.params, align 8
  %r43 = load i64, ptr %slot.method, align 8
  %r44.p = getelementptr inbounds [11 x i8], ptr @.str.162, i64 0, i64 0
  %r44 = ptrtoint ptr %r44.p to i64
  %r45 = call i64 @nova_rt_eq(i64 %r43, i64 %r44)
  %br_then391 = icmp ne i64 %r45, 0
  br i1 %br_then391, label %then391, label %else392
then391:
  %r46 = load i64, ptr %slot.id, align 8
  %r47 = call i64 @handle_initialize(i64 %r46)
  store i64 %r47, ptr %slot.resp, align 8
  %r48 = load i64, ptr %slot.resp, align 8
  %r49 = call i64 @lsp_send(i64 %r48)
  br label %endif393
else392:
  %r50 = load i64, ptr %slot.method, align 8
  %r51.p = getelementptr inbounds [12 x i8], ptr @.str.163, i64 0, i64 0
  %r51 = ptrtoint ptr %r51.p to i64
  %r52 = call i64 @nova_rt_eq(i64 %r50, i64 %r51)
  %br_then394 = icmp ne i64 %r52, 0
  br i1 %br_then394, label %then394, label %else395
then394:
  %r53 = add i64 0, 0
  br label %endif396
else395:
  %r54 = load i64, ptr %slot.method, align 8
  %r55.p = getelementptr inbounds [9 x i8], ptr @.str.164, i64 0, i64 0
  %r55 = ptrtoint ptr %r55.p to i64
  %r56 = call i64 @nova_rt_eq(i64 %r54, i64 %r55)
  %br_then397 = icmp ne i64 %r56, 0
  br i1 %br_then397, label %then397, label %else398
then397:
  %r58.p = getelementptr inbounds [8 x i8], ptr @.str.136, i64 0, i64 0
  %r58 = ptrtoint ptr %r58.p to i64
  %r59.p = getelementptr inbounds [4 x i8], ptr @.str.137, i64 0, i64 0
  %r59 = ptrtoint ptr %r59.p to i64
  %r60 = call i64 @json_str(i64 %r58, i64 %r59)
  %r61.p = getelementptr inbounds [6 x i8], ptr @.str.138, i64 0, i64 0
  %r61 = ptrtoint ptr %r61.p to i64
  %r62 = load i64, ptr %slot.id, align 8
  %r63 = call i64 @nova_rt_add(i64 %r61, i64 %r62)
  %r64.p = getelementptr inbounds [7 x i8], ptr @.str.142, i64 0, i64 0
  %r64 = ptrtoint ptr %r64.p to i64
  %r65 = call i64 @json_null(i64 %r64)
  %r57 = call i64 @nova_rt_list_create()
  call i64 @nova_rt_list_append(i64 %r57, i64 %r60)
  call i64 @nova_rt_list_append(i64 %r57, i64 %r63)
  call i64 @nova_rt_list_append(i64 %r57, i64 %r65)
  %r66 = call i64 @json_obj(i64 %r57)
  store i64 %r66, ptr %slot.resp, align 8
  %r67 = load i64, ptr %slot.resp, align 8
  %r68 = call i64 @lsp_send(i64 %r67)
  br label %endif399
else398:
  %r69 = load i64, ptr %slot.method, align 8
  %r70.p = getelementptr inbounds [5 x i8], ptr @.str.165, i64 0, i64 0
  %r70 = ptrtoint ptr %r70.p to i64
  %r71 = call i64 @nova_rt_eq(i64 %r69, i64 %r70)
  %br_then400 = icmp ne i64 %r71, 0
  br i1 %br_then400, label %then400, label %else401
then400:
  %r72 = add i64 0, 0
  store i64 %r72, ptr %slot.running, align 8
  br label %endif402
else401:
  %r73 = load i64, ptr %slot.method, align 8
  %r74.p = getelementptr inbounds [21 x i8], ptr @.str.166, i64 0, i64 0
  %r74 = ptrtoint ptr %r74.p to i64
  %r75 = call i64 @nova_rt_eq(i64 %r73, i64 %r74)
  %br_then403 = icmp ne i64 %r75, 0
  br i1 %br_then403, label %then403, label %else404
then403:
  %r76 = load i64, ptr %slot.params, align 8
  %r77 = call i64 @on_did_open(i64 %r76)
  br label %endif405
else404:
  %r78 = load i64, ptr %slot.method, align 8
  %r79.p = getelementptr inbounds [23 x i8], ptr @.str.167, i64 0, i64 0
  %r79 = ptrtoint ptr %r79.p to i64
  %r80 = call i64 @nova_rt_eq(i64 %r78, i64 %r79)
  %br_then406 = icmp ne i64 %r80, 0
  br i1 %br_then406, label %then406, label %else407
then406:
  %r81 = load i64, ptr %slot.params, align 8
  %r82 = call i64 @on_did_change(i64 %r81)
  br label %endif408
else407:
  %r83 = load i64, ptr %slot.method, align 8
  %r84.p = getelementptr inbounds [22 x i8], ptr @.str.168, i64 0, i64 0
  %r84 = ptrtoint ptr %r84.p to i64
  %r85 = call i64 @nova_rt_eq(i64 %r83, i64 %r84)
  %br_then409 = icmp ne i64 %r85, 0
  br i1 %br_then409, label %then409, label %else410
then409:
  %r86 = load i64, ptr %slot.params, align 8
  %r87 = call i64 @on_did_close(i64 %r86)
  br label %endif411
else410:
  %r88 = load i64, ptr %slot.method, align 8
  %r89.p = getelementptr inbounds [24 x i8], ptr @.str.169, i64 0, i64 0
  %r89 = ptrtoint ptr %r89.p to i64
  %r90 = call i64 @nova_rt_eq(i64 %r88, i64 %r89)
  %br_then412 = icmp ne i64 %r90, 0
  br i1 %br_then412, label %then412, label %else413
then412:
  %r91 = load i64, ptr %slot.id, align 8
  %r92 = call i64 @handle_completion(i64 %r91)
  store i64 %r92, ptr %slot.resp, align 8
  %r93 = load i64, ptr %slot.resp, align 8
  %r94 = call i64 @lsp_send(i64 %r93)
  br label %endif414
else413:
  %r95 = load i64, ptr %slot.method, align 8
  %r96.p = getelementptr inbounds [19 x i8], ptr @.str.170, i64 0, i64 0
  %r96 = ptrtoint ptr %r96.p to i64
  %r97 = call i64 @nova_rt_eq(i64 %r95, i64 %r96)
  %br_then415 = icmp ne i64 %r97, 0
  br i1 %br_then415, label %then415, label %else416
then415:
  %r98 = load i64, ptr %slot.id, align 8
  %r99 = load i64, ptr %slot.params, align 8
  %r100 = call i64 @handle_hover(i64 %r98, i64 %r99)
  store i64 %r100, ptr %slot.resp, align 8
  %r101 = load i64, ptr %slot.resp, align 8
  %r102 = call i64 @lsp_send(i64 %r101)
  br label %endif417
else416:
  %r103 = load i64, ptr %slot.id, align 8
  %r104 = call i64 @nova_rt_len_any(i64 %r103)
  %r105 = add i64 0, 0
  %r106.cmp = icmp sgt i64 %r104, %r105
  %r106 = zext i1 %r106.cmp to i64
  %br_then418 = icmp ne i64 %r106, 0
  br i1 %br_then418, label %then418, label %else419
then418:
  %r108.p = getelementptr inbounds [8 x i8], ptr @.str.136, i64 0, i64 0
  %r108 = ptrtoint ptr %r108.p to i64
  %r109.p = getelementptr inbounds [4 x i8], ptr @.str.137, i64 0, i64 0
  %r109 = ptrtoint ptr %r109.p to i64
  %r110 = call i64 @json_str(i64 %r108, i64 %r109)
  %r111.p = getelementptr inbounds [6 x i8], ptr @.str.138, i64 0, i64 0
  %r111 = ptrtoint ptr %r111.p to i64
  %r112 = load i64, ptr %slot.id, align 8
  %r113 = call i64 @nova_rt_add(i64 %r111, i64 %r112)
  %r114.p = getelementptr inbounds [7 x i8], ptr @.str.142, i64 0, i64 0
  %r114 = ptrtoint ptr %r114.p to i64
  %r115 = call i64 @json_null(i64 %r114)
  %r107 = call i64 @nova_rt_list_create()
  call i64 @nova_rt_list_append(i64 %r107, i64 %r110)
  call i64 @nova_rt_list_append(i64 %r107, i64 %r113)
  call i64 @nova_rt_list_append(i64 %r107, i64 %r115)
  %r116 = call i64 @json_obj(i64 %r107)
  store i64 %r116, ptr %slot.resp, align 8
  %r117 = load i64, ptr %slot.resp, align 8
  %r118 = call i64 @lsp_send(i64 %r117)
  br label %endif420
else419:
  br label %endif420
endif420:
  br label %endif417
endif417:
  br label %endif414
endif414:
  br label %endif411
endif411:
  br label %endif408
endif408:
  br label %endif405
endif405:
  br label %endif402
endif402:
  br label %endif399
endif399:
  br label %endif396
endif396:
  br label %endif393
endif393:
  br label %while_hdr376
while_exit378:
  ret i64 0
}

define i64 @nova_main() nounwind {
entry:
  %slot.documents = alloca i64, align 8
  store i64 0, ptr %slot.documents, align 8
  %r0 = call i64 @nova_rt_dict_create()
  store i64 %r0, ptr %slot.documents, align 8
  %r1 = call i64 @nova_user_main()
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
@.str.0 = private unnamed_addr constant [1 x i8] c"\00"
@.str.1 = private unnamed_addr constant [2 x i8] c"\22\00"
@.str.2 = private unnamed_addr constant [3 x i8] c"\\\22\00"
@.str.3 = private unnamed_addr constant [2 x i8] c"\\\00"
@.str.4 = private unnamed_addr constant [3 x i8] c"\\\\\00"
@.str.5 = private unnamed_addr constant [2 x i8] c"\0A\00"
@.str.6 = private unnamed_addr constant [3 x i8] c"\\n\00"
@.str.7 = private unnamed_addr constant [2 x i8] c"\0D\00"
@.str.8 = private unnamed_addr constant [3 x i8] c"\\r\00"
@.str.9 = private unnamed_addr constant [2 x i8] c"\09\00"
@.str.10 = private unnamed_addr constant [3 x i8] c"\\t\00"
@.str.11 = private unnamed_addr constant [4 x i8] c"\22:\22\00"
@.str.12 = private unnamed_addr constant [3 x i8] c"\22:\00"
@.str.13 = private unnamed_addr constant [7 x i8] c"\22:true\00"
@.str.14 = private unnamed_addr constant [8 x i8] c"\22:false\00"
@.str.15 = private unnamed_addr constant [7 x i8] c"\22:null\00"
@.str.16 = private unnamed_addr constant [2 x i8] c"{\00"
@.str.17 = private unnamed_addr constant [2 x i8] c",\00"
@.str.18 = private unnamed_addr constant [2 x i8] c"}\00"
@.str.19 = private unnamed_addr constant [2 x i8] c"[\00"
@.str.20 = private unnamed_addr constant [2 x i8] c"]\00"
@.str.21 = private unnamed_addr constant [2 x i8] c" \00"
@.str.22 = private unnamed_addr constant [2 x i8] c"n\00"
@.str.23 = private unnamed_addr constant [2 x i8] c"r\00"
@.str.24 = private unnamed_addr constant [2 x i8] c"t\00"
@.str.25 = private unnamed_addr constant [2 x i8] c"-\00"
@.str.26 = private unnamed_addr constant [2 x i8] c"0\00"
@.str.27 = private unnamed_addr constant [2 x i8] c"9\00"
@.str.28 = private unnamed_addr constant [2 x i8] c":\00"
@.str.29 = private unnamed_addr constant [5 x i8] c"true\00"
@.str.30 = private unnamed_addr constant [2 x i8] c"f\00"
@.str.31 = private unnamed_addr constant [6 x i8] c"false\00"
@.str.32 = private unnamed_addr constant [5 x i8] c"null\00"
@.str.33 = private unnamed_addr constant [17 x i8] c"Content-Length: \00"
@.str.34 = private unnamed_addr constant [5 x i8] c"\0D\0A\0D\0A\00"
@.str.35 = private unnamed_addr constant [14 x i8] c"echo|set /p=\22\00"
@.str.36 = private unnamed_addr constant [2 x i8] c"/\00"
@.str.37 = private unnamed_addr constant [7 x i8] c"string\00"
@.str.38 = private unnamed_addr constant [2 x i8] c"a\00"
@.str.39 = private unnamed_addr constant [2 x i8] c"z\00"
@.str.40 = private unnamed_addr constant [2 x i8] c"A\00"
@.str.41 = private unnamed_addr constant [2 x i8] c"Z\00"
@.str.42 = private unnamed_addr constant [2 x i8] c"_\00"
@.str.43 = private unnamed_addr constant [7 x i8] c"number\00"
@.str.44 = private unnamed_addr constant [4 x i8] c"fn \00"
@.str.45 = private unnamed_addr constant [2 x i8] c"(\00"
@.str.46 = private unnamed_addr constant [11 x i8] c"Function '\00"
@.str.47 = private unnamed_addr constant [36 x i8] c"' missing parameter list — add ()\00"
@.str.48 = private unnamed_addr constant [3 x i8] c"//\00"
@.str.49 = private unnamed_addr constant [24 x i8] c"Unclosed string literal\00"
@.str.50 = private unnamed_addr constant [4 x i8] c"if \00"
@.str.51 = private unnamed_addr constant [7 x i8] c"while \00"
@.str.52 = private unnamed_addr constant [4 x i8] c" = \00"
@.str.53 = private unnamed_addr constant [5 x i8] c" == \00"
@.str.54 = private unnamed_addr constant [5 x i8] c" != \00"
@.str.55 = private unnamed_addr constant [5 x i8] c" >= \00"
@.str.56 = private unnamed_addr constant [5 x i8] c" <= \00"
@.str.57 = private unnamed_addr constant [56 x i8] c"Possible assignment in condition — did you mean '=='?\00"
@.str.58 = private unnamed_addr constant [158 x i8] c"fn,let,if,else,for,while,match,return,break,continue,type,enum,trait,import,as,try,catch,spawn,send,receive,channel,select,in,and,or,not,true,false,null,copy\00"
@.str.59 = private unnamed_addr constant [329 x i8] c"print,len,str,int,push,ord,chr,assert,contains,read_file,write_file,args,exit,split,join,upper,lower,trim,replace,starts_with,ends_with,slice,repeat,chars,time_ms,sleep,clock_ns,type_of,range,sort,keys,values,system,exec,http_get,http_post,mkdir,path_join,path_exists,parse_int,parse_float,file_exists,find,append_file,read_line\00"
@.str.60 = private unnamed_addr constant [41 x i8] c"int,string,float,bool,list,dict,any,void\00"
@.str.61 = private unnamed_addr constant [6 x i8] c"label\00"
@.str.62 = private unnamed_addr constant [5 x i8] c"kind\00"
@.str.63 = private unnamed_addr constant [7 x i8] c"detail\00"
@.str.64 = private unnamed_addr constant [8 x i8] c"keyword\00"
@.str.65 = private unnamed_addr constant [17 x i8] c"builtin function\00"
@.str.66 = private unnamed_addr constant [5 x i8] c"type\00"
@.str.67 = private unnamed_addr constant [3 x i8] c"fn\00"
@.str.68 = private unnamed_addr constant [20 x i8] c"function definition\00"
@.str.69 = private unnamed_addr constant [11 x i8] c"insertText\00"
@.str.70 = private unnamed_addr constant [35 x i8] c"fn ${1:name}(${2:params})\0A    ${0}\00"
@.str.71 = private unnamed_addr constant [17 x i8] c"insertTextFormat\00"
@.str.72 = private unnamed_addr constant [4 x i8] c"for\00"
@.str.73 = private unnamed_addr constant [9 x i8] c"for loop\00"
@.str.74 = private unnamed_addr constant [36 x i8] c"for ${1:item} in ${2:list}\0A    ${0}\00"
@.str.75 = private unnamed_addr constant [3 x i8] c"if\00"
@.str.76 = private unnamed_addr constant [13 x i8] c"if statement\00"
@.str.77 = private unnamed_addr constant [27 x i8] c"if ${1:condition}\0A    ${0}\00"
@.str.78 = private unnamed_addr constant [79 x i8] c"**fn** - Define a function\0A\0A```nova\0Afn name(params) -> ReturnType\0A    body\0A```\00"
@.str.79 = private unnamed_addr constant [4 x i8] c"let\00"
@.str.80 = private unnamed_addr constant [72 x i8] c"**let** - Declare a variable\0A\0A```nova\0Alet x = 42\0Alet name = \22hello\22\0A```\00"
@.str.81 = private unnamed_addr constant [6 x i8] c"print\00"
@.str.82 = private unnamed_addr constant [62 x i8] c"**print(value)** - Print a value to stdout\0A\0AAccepts any type.\00"
@.str.83 = private unnamed_addr constant [4 x i8] c"len\00"
@.str.84 = private unnamed_addr constant [56 x i8] c"**len(x)** -> int - Get length of string, list, or dict\00"
@.str.85 = private unnamed_addr constant [5 x i8] c"push\00"
@.str.86 = private unnamed_addr constant [49 x i8] c"**push(list, value)** - Append a value to a list\00"
@.str.87 = private unnamed_addr constant [6 x i8] c"split\00"
@.str.88 = private unnamed_addr constant [56 x i8] c"**split(str, sep)** -> list - Split string by separator\00"
@.str.89 = private unnamed_addr constant [5 x i8] c"join\00"
@.str.90 = private unnamed_addr constant [66 x i8] c"**join(list, sep)** -> string - Join list elements with separator\00"
@.str.91 = private unnamed_addr constant [5 x i8] c"trim\00"
@.str.92 = private unnamed_addr constant [61 x i8] c"**trim(str)** -> string - Remove leading/trailing whitespace\00"
@.str.93 = private unnamed_addr constant [6 x i8] c"slice\00"
@.str.94 = private unnamed_addr constant [53 x i8] c"**slice(str, start, end)** -> string - Get substring\00"
@.str.95 = private unnamed_addr constant [9 x i8] c"http_get\00"
@.str.96 = private unnamed_addr constant [47 x i8] c"**http_get(url)** -> string - HTTP GET request\00"
@.str.97 = private unnamed_addr constant [6 x i8] c"spawn\00"
@.str.98 = private unnamed_addr constant [76 x i8] c"**spawn** - Create a concurrent process\0A\0A```nova\0Alet p = spawn worker()\0A```\00"
@.str.99 = private unnamed_addr constant [8 x i8] c"channel\00"
@.str.100 = private unnamed_addr constant [58 x i8] c"**channel()** -> Channel - Create a communication channel\00"
@.str.101 = private unnamed_addr constant [5 x i8] c"send\00"
@.str.102 = private unnamed_addr constant [48 x i8] c"**send(ch, value)** - Send a value on a channel\00"
@.str.103 = private unnamed_addr constant [8 x i8] c"receive\00"
@.str.104 = private unnamed_addr constant [58 x i8] c"**receive(ch)** -> value - Receive a value from a channel\00"
@.str.105 = private unnamed_addr constant [6 x i8] c"match\00"
@.str.106 = private unnamed_addr constant [102 x i8] c"**match** - Pattern matching\0A\0A```nova\0Amatch value\0A    Pattern1 => result1\0A    Pattern2 => result2\0A```\00"
@.str.107 = private unnamed_addr constant [4 x i8] c"try\00"
@.str.108 = private unnamed_addr constant [41 x i8] c"**try expr** - Propagate error to caller\00"
@.str.109 = private unnamed_addr constant [6 x i8] c"catch\00"
@.str.110 = private unnamed_addr constant [43 x i8] c"**expr catch e => handler** - Handle error\00"
@.str.111 = private unnamed_addr constant [7 x i8] c"import\00"
@.str.112 = private unnamed_addr constant [73 x i8] c"**import** - Import a module\0A\0A```nova\0Aimport math\0Aimport mylib as ml\0A```\00"
@.str.113 = private unnamed_addr constant [67 x i8] c"**type** - Define a struct\0A\0A```nova\0Atype Point(x: int, y: int)\0A```\00"
@.str.114 = private unnamed_addr constant [84 x i8] c"**for** - Iterate over a collection\0A\0A```nova\0Afor item in list\0A    process(item)\0A```\00"
@.str.115 = private unnamed_addr constant [6 x i8] c"while\00"
@.str.116 = private unnamed_addr constant [80 x i8] c"**while** - Loop while condition is true\0A\0A```nova\0Awhile x > 0\0A    x = x - 1\0A```\00"
@.str.117 = private unnamed_addr constant [10 x i8] c"read_file\00"
@.str.118 = private unnamed_addr constant [51 x i8] c"**read_file(path)** -> string - Read file contents\00"
@.str.119 = private unnamed_addr constant [11 x i8] c"write_file\00"
@.str.120 = private unnamed_addr constant [53 x i8] c"**write_file(path, content)** - Write string to file\00"
@.str.121 = private unnamed_addr constant [6 x i8] c"mkdir\00"
@.str.122 = private unnamed_addr constant [57 x i8] c"**mkdir(path)** -> int - Create directory (1=ok, 0=fail)\00"
@.str.123 = private unnamed_addr constant [10 x i8] c"path_join\00"
@.str.124 = private unnamed_addr constant [60 x i8] c"**path_join(base, child)** -> string - Join path components\00"
@.str.125 = private unnamed_addr constant [10 x i8] c"openClose\00"
@.str.126 = private unnamed_addr constant [7 x i8] c"change\00"
@.str.127 = private unnamed_addr constant [20 x i8] c"\22textDocumentSync\22:\00"
@.str.128 = private unnamed_addr constant [19 x i8] c"completionProvider\00"
@.str.129 = private unnamed_addr constant [14 x i8] c"hoverProvider\00"
@.str.130 = private unnamed_addr constant [5 x i8] c"name\00"
@.str.131 = private unnamed_addr constant [9 x i8] c"nova-lsp\00"
@.str.132 = private unnamed_addr constant [8 x i8] c"version\00"
@.str.133 = private unnamed_addr constant [6 x i8] c"0.1.0\00"
@.str.134 = private unnamed_addr constant [16 x i8] c"\22capabilities\22:\00"
@.str.135 = private unnamed_addr constant [14 x i8] c"\22serverInfo\22:\00"
@.str.136 = private unnamed_addr constant [8 x i8] c"jsonrpc\00"
@.str.137 = private unnamed_addr constant [4 x i8] c"2.0\00"
@.str.138 = private unnamed_addr constant [6 x i8] c"\22id\22:\00"
@.str.139 = private unnamed_addr constant [10 x i8] c"\22result\22:\00"
@.str.140 = private unnamed_addr constant [13 x i8] c"textDocument\00"
@.str.141 = private unnamed_addr constant [9 x i8] c"position\00"
@.str.142 = private unnamed_addr constant [7 x i8] c"result\00"
@.str.143 = private unnamed_addr constant [5 x i8] c"line\00"
@.str.144 = private unnamed_addr constant [10 x i8] c"character\00"
@.str.145 = private unnamed_addr constant [9 x i8] c"\22start\22:\00"
@.str.146 = private unnamed_addr constant [7 x i8] c"\22end\22:\00"
@.str.147 = private unnamed_addr constant [9 x i8] c"\22range\22:\00"
@.str.148 = private unnamed_addr constant [9 x i8] c"severity\00"
@.str.149 = private unnamed_addr constant [7 x i8] c"source\00"
@.str.150 = private unnamed_addr constant [5 x i8] c"nova\00"
@.str.151 = private unnamed_addr constant [8 x i8] c"message\00"
@.str.152 = private unnamed_addr constant [4 x i8] c"uri\00"
@.str.153 = private unnamed_addr constant [15 x i8] c"\22diagnostics\22:\00"
@.str.154 = private unnamed_addr constant [7 x i8] c"method\00"
@.str.155 = private unnamed_addr constant [32 x i8] c"textDocument/publishDiagnostics\00"
@.str.156 = private unnamed_addr constant [10 x i8] c"\22params\22:\00"
@.str.157 = private unnamed_addr constant [5 x i8] c"text\00"
@.str.158 = private unnamed_addr constant [15 x i8] c"contentChanges\00"
@.str.159 = private unnamed_addr constant [16 x i8] c"Content-Length:\00"
@.str.160 = private unnamed_addr constant [3 x i8] c"id\00"
@.str.161 = private unnamed_addr constant [7 x i8] c"params\00"
@.str.162 = private unnamed_addr constant [11 x i8] c"initialize\00"
@.str.163 = private unnamed_addr constant [12 x i8] c"initialized\00"
@.str.164 = private unnamed_addr constant [9 x i8] c"shutdown\00"
@.str.165 = private unnamed_addr constant [5 x i8] c"exit\00"
@.str.166 = private unnamed_addr constant [21 x i8] c"textDocument/didOpen\00"
@.str.167 = private unnamed_addr constant [23 x i8] c"textDocument/didChange\00"
@.str.168 = private unnamed_addr constant [22 x i8] c"textDocument/didClose\00"
@.str.169 = private unnamed_addr constant [24 x i8] c"textDocument/completion\00"
@.str.170 = private unnamed_addr constant [19 x i8] c"textDocument/hover\00"
