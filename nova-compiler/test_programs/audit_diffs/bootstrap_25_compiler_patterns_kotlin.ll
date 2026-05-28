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

define i64 @is_keyword(i64 %p0) nounwind {
entry:
  %slot.word = alloca i64, align 8
  store i64 %p0, ptr %slot.word, align 8
  %slot.__sc_0 = alloca i64, align 8
  store i64 0, ptr %slot.__sc_0, align 8
  %slot.__sc_3 = alloca i64, align 8
  store i64 0, ptr %slot.__sc_3, align 8
  %slot.__sc_6 = alloca i64, align 8
  store i64 0, ptr %slot.__sc_6, align 8
  %slot.__sc_9 = alloca i64, align 8
  store i64 0, ptr %slot.__sc_9, align 8
  %slot.__sc_12 = alloca i64, align 8
  store i64 0, ptr %slot.__sc_12, align 8
  %r0 = load i64, ptr %slot.word, align 8
  %r1.p = getelementptr inbounds [3 x i8], ptr @.str.0, i64 0, i64 0
  %r1 = ptrtoint ptr %r1.p to i64
  %r2.p0 = inttoptr i64 %r0 to ptr
  %r2.p1 = inttoptr i64 %r1 to ptr
  %r2.sc = call i32 @strcmp(ptr %r2.p0, ptr %r2.p1)
  %r2.cmp = icmp eq i32 %r2.sc, 0
  %r2 = zext i1 %r2.cmp to i64
  store i64 %r2, ptr %slot.__sc_0, align 8
  %br_or_merge2 = icmp ne i64 %r2, 0
  br i1 %br_or_merge2, label %or_merge2, label %or_rhs1
or_rhs1:
  %r3 = load i64, ptr %slot.word, align 8
  %r4.p = getelementptr inbounds [7 x i8], ptr @.str.1, i64 0, i64 0
  %r4 = ptrtoint ptr %r4.p to i64
  %r5.p0 = inttoptr i64 %r3 to ptr
  %r5.p1 = inttoptr i64 %r4 to ptr
  %r5.sc = call i32 @strcmp(ptr %r5.p0, ptr %r5.p1)
  %r5.cmp = icmp eq i32 %r5.sc, 0
  %r5 = zext i1 %r5.cmp to i64
  store i64 %r5, ptr %slot.__sc_0, align 8
  br label %or_merge2
or_merge2:
  %r6 = load i64, ptr %slot.__sc_0, align 8
  store i64 %r6, ptr %slot.__sc_3, align 8
  %br_or_merge5 = icmp ne i64 %r6, 0
  br i1 %br_or_merge5, label %or_merge5, label %or_rhs4
or_rhs4:
  %r7 = load i64, ptr %slot.word, align 8
  %r8.p = getelementptr inbounds [3 x i8], ptr @.str.2, i64 0, i64 0
  %r8 = ptrtoint ptr %r8.p to i64
  %r9.p0 = inttoptr i64 %r7 to ptr
  %r9.p1 = inttoptr i64 %r8 to ptr
  %r9.sc = call i32 @strcmp(ptr %r9.p0, ptr %r9.p1)
  %r9.cmp = icmp eq i32 %r9.sc, 0
  %r9 = zext i1 %r9.cmp to i64
  store i64 %r9, ptr %slot.__sc_3, align 8
  br label %or_merge5
or_merge5:
  %r10 = load i64, ptr %slot.__sc_3, align 8
  store i64 %r10, ptr %slot.__sc_6, align 8
  %br_or_merge8 = icmp ne i64 %r10, 0
  br i1 %br_or_merge8, label %or_merge8, label %or_rhs7
or_rhs7:
  %r11 = load i64, ptr %slot.word, align 8
  %r12.p = getelementptr inbounds [5 x i8], ptr @.str.3, i64 0, i64 0
  %r12 = ptrtoint ptr %r12.p to i64
  %r13.p0 = inttoptr i64 %r11 to ptr
  %r13.p1 = inttoptr i64 %r12 to ptr
  %r13.sc = call i32 @strcmp(ptr %r13.p0, ptr %r13.p1)
  %r13.cmp = icmp eq i32 %r13.sc, 0
  %r13 = zext i1 %r13.cmp to i64
  store i64 %r13, ptr %slot.__sc_6, align 8
  br label %or_merge8
or_merge8:
  %r14 = load i64, ptr %slot.__sc_6, align 8
  store i64 %r14, ptr %slot.__sc_9, align 8
  %br_or_merge11 = icmp ne i64 %r14, 0
  br i1 %br_or_merge11, label %or_merge11, label %or_rhs10
or_rhs10:
  %r15 = load i64, ptr %slot.word, align 8
  %r16.p = getelementptr inbounds [6 x i8], ptr @.str.4, i64 0, i64 0
  %r16 = ptrtoint ptr %r16.p to i64
  %r17.p0 = inttoptr i64 %r15 to ptr
  %r17.p1 = inttoptr i64 %r16 to ptr
  %r17.sc = call i32 @strcmp(ptr %r17.p0, ptr %r17.p1)
  %r17.cmp = icmp eq i32 %r17.sc, 0
  %r17 = zext i1 %r17.cmp to i64
  store i64 %r17, ptr %slot.__sc_9, align 8
  br label %or_merge11
or_merge11:
  %r18 = load i64, ptr %slot.__sc_9, align 8
  store i64 %r18, ptr %slot.__sc_12, align 8
  %br_or_merge14 = icmp ne i64 %r18, 0
  br i1 %br_or_merge14, label %or_merge14, label %or_rhs13
or_rhs13:
  %r19 = load i64, ptr %slot.word, align 8
  %r20.p = getelementptr inbounds [4 x i8], ptr @.str.5, i64 0, i64 0
  %r20 = ptrtoint ptr %r20.p to i64
  %r21.p0 = inttoptr i64 %r19 to ptr
  %r21.p1 = inttoptr i64 %r20 to ptr
  %r21.sc = call i32 @strcmp(ptr %r21.p0, ptr %r21.p1)
  %r21.cmp = icmp eq i32 %r21.sc, 0
  %r21 = zext i1 %r21.cmp to i64
  store i64 %r21, ptr %slot.__sc_12, align 8
  br label %or_merge14
or_merge14:
  %r22 = load i64, ptr %slot.__sc_12, align 8
  %br_then15 = icmp ne i64 %r22, 0
  br i1 %br_then15, label %then15, label %else16
then15:
  %r23 = add i64 1, 0
  ret i64 %r23
else16:
  br label %endif17
endif17:
  %r24 = add i64 0, 0
  ret i64 %r24
}

define i64 @tk(i64 %p0, i64 %p1) nounwind {
entry:
  %slot.tokens = alloca i64, align 8
  store i64 %p0, ptr %slot.tokens, align 8
  %slot.pos = alloca i64, align 8
  store i64 %p1, ptr %slot.pos, align 8
  %r0 = load i64, ptr %slot.pos, align 8
  %r1 = load i64, ptr %slot.tokens, align 8
  %r2 = call i64 @nova_rt_len_any(i64 %r1)
  %r3.cmp = icmp sge i64 %r0, %r2
  %r3 = zext i1 %r3.cmp to i64
  %br_then18 = icmp ne i64 %r3, 0
  br i1 %br_then18, label %then18, label %else19
then18:
  %r4.p = getelementptr inbounds [4 x i8], ptr @.str.6, i64 0, i64 0
  %r4 = ptrtoint ptr %r4.p to i64
  ret i64 %r4
else19:
  br label %endif20
endif20:
  %r5 = load i64, ptr %slot.tokens, align 8
  %r6 = load i64, ptr %slot.pos, align 8
  %r7 = call i64 @nova_rt_index_get(i64 %r5, i64 %r6)
  ret i64 %r7
}

define i64 @join_items(i64 %p0, i64 %p1) nounwind {
entry:
  %slot.items = alloca i64, align 8
  store i64 %p0, ptr %slot.items, align 8
  %slot.sep = alloca i64, align 8
  store i64 %p1, ptr %slot.sep, align 8
  %slot.result = alloca i64, align 8
  store i64 0, ptr %slot.result, align 8
  %slot.i = alloca i64, align 8
  store i64 0, ptr %slot.i, align 8
  %r0.p = getelementptr inbounds [1 x i8], ptr @.str.7, i64 0, i64 0
  %r0 = ptrtoint ptr %r0.p to i64
  store i64 %r0, ptr %slot.result, align 8
  %r1 = add i64 0, 0
  store i64 %r1, ptr %slot.i, align 8
  br label %while_hdr21
while_hdr21:
  %r2 = load i64, ptr %slot.i, align 8
  %r3 = load i64, ptr %slot.items, align 8
  %r4 = call i64 @nova_rt_len_any(i64 %r3)
  %r5.cmp = icmp slt i64 %r2, %r4
  %r5 = zext i1 %r5.cmp to i64
  %br_while_body22 = icmp ne i64 %r5, 0
  br i1 %br_while_body22, label %while_body22, label %while_exit23
while_body22:
  %r6 = load i64, ptr %slot.i, align 8
  %r7 = add i64 0, 0
  %r8.cmp = icmp sgt i64 %r6, %r7
  %r8 = zext i1 %r8.cmp to i64
  %br_then24 = icmp ne i64 %r8, 0
  br i1 %br_then24, label %then24, label %else25
then24:
  %r9 = load i64, ptr %slot.result, align 8
  %r10 = load i64, ptr %slot.sep, align 8
  %r11 = call i64 @nova_rt_str_concat(i64 %r9, i64 %r10)
  store i64 %r11, ptr %slot.result, align 8
  br label %endif26
else25:
  br label %endif26
endif26:
  %r12 = load i64, ptr %slot.result, align 8
  %r13 = load i64, ptr %slot.items, align 8
  %r14 = load i64, ptr %slot.i, align 8
  %r15 = call i64 @nova_rt_index_get(i64 %r13, i64 %r14)
  %r16 = call i64 @nova_rt_int_to_str(i64 %r15)
  %r17 = call i64 @nova_rt_str_concat(i64 %r12, i64 %r16)
  store i64 %r17, ptr %slot.result, align 8
  %r18 = load i64, ptr %slot.i, align 8
  %r19 = add i64 1, 0
  %r20 = add i64 %r18, %r19
  store i64 %r20, ptr %slot.i, align 8
  br label %while_hdr21
while_exit23:
  %r21 = load i64, ptr %slot.result, align 8
  ret i64 %r21
}

define i64 @count_nested(i64 %p0) nounwind {
entry:
  %slot.items = alloca i64, align 8
  store i64 %p0, ptr %slot.items, align 8
  %slot.total = alloca i64, align 8
  store i64 0, ptr %slot.total, align 8
  %slot.__for_idx_27 = alloca i64, align 8
  store i64 0, ptr %slot.__for_idx_27, align 8
  %slot.item = alloca i64, align 8
  store i64 0, ptr %slot.item, align 8
  %r0 = add i64 0, 0
  store i64 %r0, ptr %slot.total, align 8
  %r1 = load i64, ptr %slot.items, align 8
  %r2 = call i64 @nova_rt_len_any(i64 %r1)
  %r3 = add i64 0, 0
  store i64 %r3, ptr %slot.__for_idx_27, align 8
  br label %for_hdr27
for_hdr27:
  %r4 = load i64, ptr %slot.__for_idx_27, align 8
  %r5.cmp = icmp slt i64 %r4, %r2
  %r5 = zext i1 %r5.cmp to i64
  %br_for_body28 = icmp ne i64 %r5, 0
  br i1 %br_for_body28, label %for_body28, label %for_exit29
for_body28:
  %r6 = call i64 @nova_rt_index_get(i64 %r1, i64 %r4)
  store i64 %r6, ptr %slot.item, align 8
  %r7 = load i64, ptr %slot.total, align 8
  %r8 = add i64 1, 0
  %r9 = add i64 %r7, %r8
  store i64 %r9, ptr %slot.total, align 8
  %r10 = load i64, ptr %slot.__for_idx_27, align 8
  %r11 = add i64 1, 0
  %r12 = add i64 %r10, %r11
  store i64 %r12, ptr %slot.__for_idx_27, align 8
  br label %for_hdr27
for_exit29:
  %r13 = load i64, ptr %slot.total, align 8
  ret i64 %r13
}

define i64 @resolve(i64 %p0) nounwind {
entry:
  %slot.op = alloca i64, align 8
  store i64 %p0, ptr %slot.op, align 8
  %slot.handlers = alloca i64, align 8
  store i64 0, ptr %slot.handlers, align 8
  %r0 = load i64, ptr %slot.handlers, align 8
  %r1 = load i64, ptr %slot.op, align 8
  %r2 = call i64 @nova_rt_contains(i64 %r0, i64 %r1)
  %br_then30 = icmp ne i64 %r2, 0
  br i1 %br_then30, label %then30, label %else31
then30:
  %r3 = load i64, ptr %slot.handlers, align 8
  %r4 = load i64, ptr %slot.op, align 8
  %r5 = call i64 @nova_rt_index_get(i64 %r3, i64 %r4)
  ret i64 %r5
else31:
  br label %endif32
endif32:
  %r6 = load i64, ptr %slot.op, align 8
  ret i64 %r6
}

define i64 @process(i64 %p0, i64 %p1) nounwind {
entry:
  %slot.tag = alloca i64, align 8
  store i64 %p0, ptr %slot.tag, align 8
  %slot.value = alloca i64, align 8
  store i64 %p1, ptr %slot.value, align 8
  %r0 = load i64, ptr %slot.tag, align 8
  %r1.p = getelementptr inbounds [4 x i8], ptr @.str.8, i64 0, i64 0
  %r1 = ptrtoint ptr %r1.p to i64
  %r2.p0 = inttoptr i64 %r0 to ptr
  %r2.p1 = inttoptr i64 %r1 to ptr
  %r2.sc = call i32 @strcmp(ptr %r2.p0, ptr %r2.p1)
  %r2.cmp = icmp eq i32 %r2.sc, 0
  %r2 = zext i1 %r2.cmp to i64
  %br_then33 = icmp ne i64 %r2, 0
  br i1 %br_then33, label %then33, label %else34
then33:
  %r3.p = getelementptr inbounds [10 x i8], ptr @.str.9, i64 0, i64 0
  %r3 = ptrtoint ptr %r3.p to i64
  %r4 = load i64, ptr %slot.value, align 8
  %r5 = call i64 @nova_rt_str_concat(i64 %r3, i64 %r4)
  ret i64 %r5
else34:
  %r6 = load i64, ptr %slot.tag, align 8
  %r7.p = getelementptr inbounds [4 x i8], ptr @.str.10, i64 0, i64 0
  %r7 = ptrtoint ptr %r7.p to i64
  %r8.p0 = inttoptr i64 %r6 to ptr
  %r8.p1 = inttoptr i64 %r7 to ptr
  %r8.sc = call i32 @strcmp(ptr %r8.p0, ptr %r8.p1)
  %r8.cmp = icmp eq i32 %r8.sc, 0
  %r8 = zext i1 %r8.cmp to i64
  %br_then36 = icmp ne i64 %r8, 0
  br i1 %br_then36, label %then36, label %else37
then36:
  %r9.p = getelementptr inbounds [9 x i8], ptr @.str.11, i64 0, i64 0
  %r9 = ptrtoint ptr %r9.p to i64
  %r10 = load i64, ptr %slot.value, align 8
  %r11 = call i64 @nova_rt_str_concat(i64 %r9, i64 %r10)
  ret i64 %r11
else37:
  %r12 = load i64, ptr %slot.tag, align 8
  %r13.p = getelementptr inbounds [5 x i8], ptr @.str.12, i64 0, i64 0
  %r13 = ptrtoint ptr %r13.p to i64
  %r14.p0 = inttoptr i64 %r12 to ptr
  %r14.p1 = inttoptr i64 %r13 to ptr
  %r14.sc = call i32 @strcmp(ptr %r14.p0, ptr %r14.p1)
  %r14.cmp = icmp eq i32 %r14.sc, 0
  %r14 = zext i1 %r14.cmp to i64
  %br_then39 = icmp ne i64 %r14, 0
  br i1 %br_then39, label %then39, label %else40
then39:
  %r15 = load i64, ptr %slot.value, align 8
  %r16.p = getelementptr inbounds [5 x i8], ptr @.str.13, i64 0, i64 0
  %r16 = ptrtoint ptr %r16.p to i64
  %r17.p0 = inttoptr i64 %r15 to ptr
  %r17.p1 = inttoptr i64 %r16 to ptr
  %r17.sc = call i32 @strcmp(ptr %r17.p0, ptr %r17.p1)
  %r17.cmp = icmp eq i32 %r17.sc, 0
  %r17 = zext i1 %r17.cmp to i64
  %br_then42 = icmp ne i64 %r17, 0
  br i1 %br_then42, label %then42, label %else43
then42:
  %r18.p = getelementptr inbounds [13 x i8], ptr @.str.14, i64 0, i64 0
  %r18 = ptrtoint ptr %r18.p to i64
  ret i64 %r18
else43:
  %r19.p = getelementptr inbounds [12 x i8], ptr @.str.15, i64 0, i64 0
  %r19 = ptrtoint ptr %r19.p to i64
  ret i64 %r19
endif44:
  br label %endif41
else40:
  br label %endif41
endif41:
  br label %endif38
endif38:
  br label %endif35
endif35:
  %r20.p = getelementptr inbounds [8 x i8], ptr @.str.16, i64 0, i64 0
  %r20 = ptrtoint ptr %r20.p to i64
  %r21 = load i64, ptr %slot.tag, align 8
  %r22 = call i64 @nova_rt_str_concat(i64 %r20, i64 %r21)
  ret i64 %r22
}

define i64 @collect_names(i64 %p0) nounwind {
entry:
  %slot.items = alloca i64, align 8
  store i64 %p0, ptr %slot.items, align 8
  %slot.names = alloca i64, align 8
  store i64 0, ptr %slot.names, align 8
  %slot.__for_idx_45 = alloca i64, align 8
  store i64 0, ptr %slot.__for_idx_45, align 8
  %slot.item = alloca i64, align 8
  store i64 0, ptr %slot.item, align 8
  %r0 = call i64 @nova_rt_list_create()
  store i64 %r0, ptr %slot.names, align 8
  %r1 = load i64, ptr %slot.items, align 8
  %r2 = call i64 @nova_rt_len_any(i64 %r1)
  %r3 = add i64 0, 0
  store i64 %r3, ptr %slot.__for_idx_45, align 8
  br label %for_hdr45
for_hdr45:
  %r4 = load i64, ptr %slot.__for_idx_45, align 8
  %r5.cmp = icmp slt i64 %r4, %r2
  %r5 = zext i1 %r5.cmp to i64
  %br_for_body46 = icmp ne i64 %r5, 0
  br i1 %br_for_body46, label %for_body46, label %for_exit47
for_body46:
  %r6 = call i64 @nova_rt_index_get(i64 %r1, i64 %r4)
  store i64 %r6, ptr %slot.item, align 8
  %r7 = load i64, ptr %slot.item, align 8
  %r8 = call i64 @nova_rt_len_any(i64 %r7)
  %r9 = add i64 3, 0
  %r10.cmp = icmp sgt i64 %r8, %r9
  %r10 = zext i1 %r10.cmp to i64
  %br_then48 = icmp ne i64 %r10, 0
  br i1 %br_then48, label %then48, label %else49
then48:
  %r11 = load i64, ptr %slot.names, align 8
  %r12 = load i64, ptr %slot.item, align 8
  %r13 = call i64 @nova_rt_list_append(i64 %r11, i64 %r12)
  br label %endif50
else49:
  br label %endif50
endif50:
  %r14 = load i64, ptr %slot.__for_idx_45, align 8
  %r15 = add i64 1, 0
  %r16 = add i64 %r14, %r15
  store i64 %r16, ptr %slot.__for_idx_45, align 8
  br label %for_hdr45
for_exit47:
  %r17 = load i64, ptr %slot.names, align 8
  ret i64 %r17
}

define i64 @nova_main() nounwind {
entry:
  %slot.toks = alloca i64, align 8
  store i64 0, ptr %slot.toks, align 8
  %slot.handlers = alloca i64, align 8
  store i64 0, ptr %slot.handlers, align 8
  %slot.result = alloca i64, align 8
  store i64 0, ptr %slot.result, align 8
  %r0.p = getelementptr inbounds [3 x i8], ptr @.str.0, i64 0, i64 0
  %r0 = ptrtoint ptr %r0.p to i64
  %r1 = call i64 @is_keyword(i64 %r0)
  %r2 = call i64 @nova_rt_print_any(i64 %r1)
  %r3.p = getelementptr inbounds [6 x i8], ptr @.str.17, i64 0, i64 0
  %r3 = ptrtoint ptr %r3.p to i64
  %r4 = call i64 @is_keyword(i64 %r3)
  %r5 = call i64 @nova_rt_print_any(i64 %r4)
  %r7.p = getelementptr inbounds [3 x i8], ptr @.str.0, i64 0, i64 0
  %r7 = ptrtoint ptr %r7.p to i64
  %r8.p = getelementptr inbounds [5 x i8], ptr @.str.18, i64 0, i64 0
  %r8 = ptrtoint ptr %r8.p to i64
  %r9.p = getelementptr inbounds [2 x i8], ptr @.str.19, i64 0, i64 0
  %r9 = ptrtoint ptr %r9.p to i64
  %r10.p = getelementptr inbounds [2 x i8], ptr @.str.20, i64 0, i64 0
  %r10 = ptrtoint ptr %r10.p to i64
  %r11.p = getelementptr inbounds [7 x i8], ptr @.str.1, i64 0, i64 0
  %r11 = ptrtoint ptr %r11.p to i64
  %r12.p = getelementptr inbounds [2 x i8], ptr @.str.21, i64 0, i64 0
  %r12 = ptrtoint ptr %r12.p to i64
  %r6 = call i64 @nova_rt_list_create()
  call i64 @nova_rt_list_append(i64 %r6, i64 %r7)
  call i64 @nova_rt_list_append(i64 %r6, i64 %r8)
  call i64 @nova_rt_list_append(i64 %r6, i64 %r9)
  call i64 @nova_rt_list_append(i64 %r6, i64 %r10)
  call i64 @nova_rt_list_append(i64 %r6, i64 %r11)
  call i64 @nova_rt_list_append(i64 %r6, i64 %r12)
  store i64 %r6, ptr %slot.toks, align 8
  %r13 = load i64, ptr %slot.toks, align 8
  %r14 = add i64 0, 0
  %r15 = call i64 @tk(i64 %r13, i64 %r14)
  %r16 = call i64 @nova_rt_print_any(i64 %r15)
  %r17 = load i64, ptr %slot.toks, align 8
  %r18 = add i64 100, 0
  %r19 = call i64 @tk(i64 %r17, i64 %r18)
  %r20 = call i64 @nova_rt_print_any(i64 %r19)
  %r22 = add i64 1, 0
  %r23 = add i64 2, 0
  %r24 = add i64 3, 0
  %r21 = call i64 @nova_rt_list_create()
  call i64 @nova_rt_list_append(i64 %r21, i64 %r22)
  call i64 @nova_rt_list_append(i64 %r21, i64 %r23)
  call i64 @nova_rt_list_append(i64 %r21, i64 %r24)
  %r25.p = getelementptr inbounds [3 x i8], ptr @.str.22, i64 0, i64 0
  %r25 = ptrtoint ptr %r25.p to i64
  %r26 = call i64 @join_items(i64 %r21, i64 %r25)
  %r27 = call i64 @nova_rt_print_any(i64 %r26)
  %r29 = add i64 10, 0
  %r30 = add i64 20, 0
  %r31 = add i64 30, 0
  %r32 = add i64 40, 0
  %r28 = call i64 @nova_rt_list_create()
  call i64 @nova_rt_list_append(i64 %r28, i64 %r29)
  call i64 @nova_rt_list_append(i64 %r28, i64 %r30)
  call i64 @nova_rt_list_append(i64 %r28, i64 %r31)
  call i64 @nova_rt_list_append(i64 %r28, i64 %r32)
  %r33 = call i64 @count_nested(i64 %r28)
  %r34 = call i64 @nova_rt_print_any(i64 %r33)
  %r35 = call i64 @nova_rt_dict_create()
  store i64 %r35, ptr %slot.handlers, align 8
  %r36.p = getelementptr inbounds [12 x i8], ptr @.str.23, i64 0, i64 0
  %r36 = ptrtoint ptr %r36.p to i64
  %r37 = load i64, ptr %slot.handlers, align 8
  %r38.p = getelementptr inbounds [4 x i8], ptr @.str.24, i64 0, i64 0
  %r38 = ptrtoint ptr %r38.p to i64
  call i64 @nova_rt_index_set(i64 %r37, i64 %r38, i64 %r36)
  %r39.p = getelementptr inbounds [12 x i8], ptr @.str.25, i64 0, i64 0
  %r39 = ptrtoint ptr %r39.p to i64
  %r40 = load i64, ptr %slot.handlers, align 8
  %r41.p = getelementptr inbounds [4 x i8], ptr @.str.26, i64 0, i64 0
  %r41 = ptrtoint ptr %r41.p to i64
  call i64 @nova_rt_index_set(i64 %r40, i64 %r41, i64 %r39)
  %r42.p = getelementptr inbounds [12 x i8], ptr @.str.27, i64 0, i64 0
  %r42 = ptrtoint ptr %r42.p to i64
  %r43 = load i64, ptr %slot.handlers, align 8
  %r44.p = getelementptr inbounds [4 x i8], ptr @.str.28, i64 0, i64 0
  %r44 = ptrtoint ptr %r44.p to i64
  call i64 @nova_rt_index_set(i64 %r43, i64 %r44, i64 %r42)
  %r45.p = getelementptr inbounds [4 x i8], ptr @.str.24, i64 0, i64 0
  %r45 = ptrtoint ptr %r45.p to i64
  %r46 = call i64 @resolve(i64 %r45)
  %r47 = call i64 @nova_rt_print_any(i64 %r46)
  %r48.p = getelementptr inbounds [8 x i8], ptr @.str.29, i64 0, i64 0
  %r48 = ptrtoint ptr %r48.p to i64
  %r49 = call i64 @resolve(i64 %r48)
  %r50 = call i64 @nova_rt_print_any(i64 %r49)
  %r51.p = getelementptr inbounds [4 x i8], ptr @.str.8, i64 0, i64 0
  %r51 = ptrtoint ptr %r51.p to i64
  %r52.p = getelementptr inbounds [3 x i8], ptr @.str.30, i64 0, i64 0
  %r52 = ptrtoint ptr %r52.p to i64
  %r53 = call i64 @process(i64 %r51, i64 %r52)
  %r54 = call i64 @nova_rt_print_any(i64 %r53)
  %r55.p = getelementptr inbounds [4 x i8], ptr @.str.10, i64 0, i64 0
  %r55 = ptrtoint ptr %r55.p to i64
  %r56.p = getelementptr inbounds [6 x i8], ptr @.str.17, i64 0, i64 0
  %r56 = ptrtoint ptr %r56.p to i64
  %r57 = call i64 @process(i64 %r55, i64 %r56)
  %r58 = call i64 @nova_rt_print_any(i64 %r57)
  %r59.p = getelementptr inbounds [5 x i8], ptr @.str.12, i64 0, i64 0
  %r59 = ptrtoint ptr %r59.p to i64
  %r60.p = getelementptr inbounds [5 x i8], ptr @.str.13, i64 0, i64 0
  %r60 = ptrtoint ptr %r60.p to i64
  %r61 = call i64 @process(i64 %r59, i64 %r60)
  %r62 = call i64 @nova_rt_print_any(i64 %r61)
  %r63.p = getelementptr inbounds [8 x i8], ptr @.str.29, i64 0, i64 0
  %r63 = ptrtoint ptr %r63.p to i64
  %r64.p = getelementptr inbounds [1 x i8], ptr @.str.7, i64 0, i64 0
  %r64 = ptrtoint ptr %r64.p to i64
  %r65 = call i64 @process(i64 %r63, i64 %r64)
  %r66 = call i64 @nova_rt_print_any(i64 %r65)
  %r68.p = getelementptr inbounds [3 x i8], ptr @.str.0, i64 0, i64 0
  %r68 = ptrtoint ptr %r68.p to i64
  %r69.p = getelementptr inbounds [5 x i8], ptr @.str.18, i64 0, i64 0
  %r69 = ptrtoint ptr %r69.p to i64
  %r70.p = getelementptr inbounds [7 x i8], ptr @.str.1, i64 0, i64 0
  %r70 = ptrtoint ptr %r70.p to i64
  %r71.p = getelementptr inbounds [3 x i8], ptr @.str.2, i64 0, i64 0
  %r71 = ptrtoint ptr %r71.p to i64
  %r72.p = getelementptr inbounds [6 x i8], ptr @.str.4, i64 0, i64 0
  %r72 = ptrtoint ptr %r72.p to i64
  %r67 = call i64 @nova_rt_list_create()
  call i64 @nova_rt_list_append(i64 %r67, i64 %r68)
  call i64 @nova_rt_list_append(i64 %r67, i64 %r69)
  call i64 @nova_rt_list_append(i64 %r67, i64 %r70)
  call i64 @nova_rt_list_append(i64 %r67, i64 %r71)
  call i64 @nova_rt_list_append(i64 %r67, i64 %r72)
  %r73 = call i64 @collect_names(i64 %r67)
  store i64 %r73, ptr %slot.result, align 8
  %r74 = load i64, ptr %slot.result, align 8
  %r75 = call i64 @nova_rt_len_any(i64 %r74)
  %r76 = call i64 @nova_rt_print_any(i64 %r75)
  %r77 = load i64, ptr %slot.result, align 8
  %r78 = add i64 0, 0
  %r79 = call i64 @nova_rt_index_get(i64 %r77, i64 %r78)
  %r80 = call i64 @nova_rt_print_any(i64 %r79)
  %r81 = load i64, ptr %slot.result, align 8
  %r82 = add i64 1, 0
  %r83 = call i64 @nova_rt_index_get(i64 %r81, i64 %r82)
  %r84 = call i64 @nova_rt_print_any(i64 %r83)
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
@.str.1 = private unnamed_addr constant [7 x i8] c"return\00"
@.str.2 = private unnamed_addr constant [3 x i8] c"if\00"
@.str.3 = private unnamed_addr constant [5 x i8] c"else\00"
@.str.4 = private unnamed_addr constant [6 x i8] c"while\00"
@.str.5 = private unnamed_addr constant [4 x i8] c"for\00"
@.str.6 = private unnamed_addr constant [4 x i8] c"EOF\00"
@.str.7 = private unnamed_addr constant [1 x i8] c"\00"
@.str.8 = private unnamed_addr constant [4 x i8] c"int\00"
@.str.9 = private unnamed_addr constant [10 x i8] c"integer: \00"
@.str.10 = private unnamed_addr constant [4 x i8] c"str\00"
@.str.11 = private unnamed_addr constant [9 x i8] c"string: \00"
@.str.12 = private unnamed_addr constant [5 x i8] c"bool\00"
@.str.13 = private unnamed_addr constant [5 x i8] c"true\00"
@.str.14 = private unnamed_addr constant [13 x i8] c"boolean: yes\00"
@.str.15 = private unnamed_addr constant [12 x i8] c"boolean: no\00"
@.str.16 = private unnamed_addr constant [8 x i8] c"other: \00"
@.str.17 = private unnamed_addr constant [6 x i8] c"hello\00"
@.str.18 = private unnamed_addr constant [5 x i8] c"main\00"
@.str.19 = private unnamed_addr constant [2 x i8] c"(\00"
@.str.20 = private unnamed_addr constant [2 x i8] c")\00"
@.str.21 = private unnamed_addr constant [2 x i8] c"0\00"
@.str.22 = private unnamed_addr constant [3 x i8] c", \00"
@.str.23 = private unnamed_addr constant [12 x i8] c"nova_rt_add\00"
@.str.24 = private unnamed_addr constant [4 x i8] c"add\00"
@.str.25 = private unnamed_addr constant [12 x i8] c"nova_rt_sub\00"
@.str.26 = private unnamed_addr constant [4 x i8] c"sub\00"
@.str.27 = private unnamed_addr constant [12 x i8] c"nova_rt_mul\00"
@.str.28 = private unnamed_addr constant [4 x i8] c"mul\00"
@.str.29 = private unnamed_addr constant [8 x i8] c"unknown\00"
@.str.30 = private unnamed_addr constant [3 x i8] c"42\00"
