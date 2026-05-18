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

define i64 @count_tokens(i64 %p0) nounwind {
entry:
  %slot.source = alloca i64, align 8
  store i64 %p0, ptr %slot.source, align 8
  %slot.count = alloca i64, align 8
  store i64 0, ptr %slot.count, align 8
  %slot.i = alloca i64, align 8
  store i64 0, ptr %slot.i, align 8
  %slot.in_word = alloca i64, align 8
  store i64 0, ptr %slot.in_word, align 8
  %slot.ch = alloca i64, align 8
  store i64 0, ptr %slot.ch, align 8
  %slot.__sc_3 = alloca i64, align 8
  store i64 0, ptr %slot.__sc_3, align 8
  %slot.__sc_6 = alloca i64, align 8
  store i64 0, ptr %slot.__sc_6, align 8
  %r0 = add i64 0, 0
  store i64 %r0, ptr %slot.count, align 8
  %r1 = add i64 0, 0
  store i64 %r1, ptr %slot.i, align 8
  %r2 = add i64 0, 0
  store i64 %r2, ptr %slot.in_word, align 8
  br label %while_hdr0
while_hdr0:
  %r3 = load i64, ptr %slot.i, align 8
  %r4 = load i64, ptr %slot.source, align 8
  %r5 = call i64 @nova_rt_len_any(i64 %r4)
  %r6.cmp = icmp slt i64 %r3, %r5
  %r6 = zext i1 %r6.cmp to i64
  %br_while_body1 = icmp ne i64 %r6, 0
  br i1 %br_while_body1, label %while_body1, label %while_exit2
while_body1:
  %r7 = load i64, ptr %slot.source, align 8
  %r8 = load i64, ptr %slot.i, align 8
  %r9 = call i64 @nova_rt_index_get(i64 %r7, i64 %r8)
  store i64 %r9, ptr %slot.ch, align 8
  %r10 = load i64, ptr %slot.ch, align 8
  %r11.p = getelementptr inbounds [2 x i8], ptr @.str.0, i64 0, i64 0
  %r11 = ptrtoint ptr %r11.p to i64
  %r12 = call i64 @nova_rt_eq(i64 %r10, i64 %r11)
  store i64 %r12, ptr %slot.__sc_3, align 8
  %br_or_merge5 = icmp ne i64 %r12, 0
  br i1 %br_or_merge5, label %or_merge5, label %or_rhs4
or_rhs4:
  %r13 = load i64, ptr %slot.ch, align 8
  %r14.p = getelementptr inbounds [2 x i8], ptr @.str.1, i64 0, i64 0
  %r14 = ptrtoint ptr %r14.p to i64
  %r15 = call i64 @nova_rt_eq(i64 %r13, i64 %r14)
  store i64 %r15, ptr %slot.__sc_3, align 8
  br label %or_merge5
or_merge5:
  %r16 = load i64, ptr %slot.__sc_3, align 8
  store i64 %r16, ptr %slot.__sc_6, align 8
  %br_or_merge8 = icmp ne i64 %r16, 0
  br i1 %br_or_merge8, label %or_merge8, label %or_rhs7
or_rhs7:
  %r17 = load i64, ptr %slot.ch, align 8
  %r18.p = getelementptr inbounds [2 x i8], ptr @.str.2, i64 0, i64 0
  %r18 = ptrtoint ptr %r18.p to i64
  %r19 = call i64 @nova_rt_eq(i64 %r17, i64 %r18)
  store i64 %r19, ptr %slot.__sc_6, align 8
  br label %or_merge8
or_merge8:
  %r20 = load i64, ptr %slot.__sc_6, align 8
  %br_then9 = icmp ne i64 %r20, 0
  br i1 %br_then9, label %then9, label %else10
then9:
  %r21 = load i64, ptr %slot.in_word, align 8
  %br_then12 = icmp ne i64 %r21, 0
  br i1 %br_then12, label %then12, label %else13
then12:
  %r22 = load i64, ptr %slot.count, align 8
  %r23 = add i64 1, 0
  %r24 = add i64 %r22, %r23
  store i64 %r24, ptr %slot.count, align 8
  %r25 = add i64 0, 0
  store i64 %r25, ptr %slot.in_word, align 8
  br label %endif14
else13:
  br label %endif14
endif14:
  br label %endif11
else10:
  %r26 = add i64 1, 0
  store i64 %r26, ptr %slot.in_word, align 8
  br label %endif11
endif11:
  %r27 = load i64, ptr %slot.i, align 8
  %r28 = add i64 1, 0
  %r29 = add i64 %r27, %r28
  store i64 %r29, ptr %slot.i, align 8
  br label %while_hdr0
while_exit2:
  %r30 = load i64, ptr %slot.in_word, align 8
  %br_then15 = icmp ne i64 %r30, 0
  br i1 %br_then15, label %then15, label %else16
then15:
  %r31 = load i64, ptr %slot.count, align 8
  %r32 = add i64 1, 0
  %r33 = add i64 %r31, %r32
  store i64 %r33, ptr %slot.count, align 8
  br label %endif17
else16:
  br label %endif17
endif17:
  %r34 = load i64, ptr %slot.count, align 8
  ret i64 %r34
}

define i64 @nova_main() nounwind {
entry:
  %slot.code = alloca i64, align 8
  store i64 0, ptr %slot.code, align 8
  %slot.words = alloca i64, align 8
  store i64 0, ptr %slot.words, align 8
  %slot.parts = alloca i64, align 8
  store i64 0, ptr %slot.parts, align 8
  %slot.__for_idx_18 = alloca i64, align 8
  store i64 0, ptr %slot.__for_idx_18, align 8
  %slot.line = alloca i64, align 8
  store i64 0, ptr %slot.line, align 8
  %r0.p = getelementptr inbounds [57 x i8], ptr @.str.3, i64 0, i64 0
  %r0 = ptrtoint ptr %r0.p to i64
  store i64 %r0, ptr %slot.code, align 8
  %r1 = load i64, ptr %slot.code, align 8
  %r2 = call i64 @count_tokens(i64 %r1)
  store i64 %r2, ptr %slot.words, align 8
  %r3 = load i64, ptr %slot.words, align 8
  %r4 = call i64 @nova_rt_print_any(i64 %r3)
  %r5 = load i64, ptr %slot.code, align 8
  %r6.p = getelementptr inbounds [2 x i8], ptr @.str.1, i64 0, i64 0
  %r6 = ptrtoint ptr %r6.p to i64
  %r7 = call i64 @nova_rt_split(i64 %r5, i64 %r6)
  store i64 %r7, ptr %slot.parts, align 8
  %r8 = load i64, ptr %slot.parts, align 8
  %r9 = call i64 @nova_rt_len_any(i64 %r8)
  %r10 = call i64 @nova_rt_print_any(i64 %r9)
  %r11 = load i64, ptr %slot.parts, align 8
  %r12 = call i64 @nova_rt_len_any(i64 %r11)
  %r13 = add i64 0, 0
  store i64 %r13, ptr %slot.__for_idx_18, align 8
  br label %for_hdr18
for_hdr18:
  %r14 = load i64, ptr %slot.__for_idx_18, align 8
  %r15.cmp = icmp slt i64 %r14, %r12
  %r15 = zext i1 %r15.cmp to i64
  %br_for_body19 = icmp ne i64 %r15, 0
  br i1 %br_for_body19, label %for_body19, label %for_exit20
for_body19:
  %r16 = call i64 @nova_rt_index_get(i64 %r11, i64 %r14)
  store i64 %r16, ptr %slot.line, align 8
  %r17 = load i64, ptr %slot.line, align 8
  %r18 = call i64 @nova_rt_len_any(i64 %r17)
  %r19 = add i64 0, 0
  %r20.cmp = icmp sgt i64 %r18, %r19
  %r20 = zext i1 %r20.cmp to i64
  %br_then21 = icmp ne i64 %r20, 0
  br i1 %br_then21, label %then21, label %else22
then21:
  %r21 = load i64, ptr %slot.line, align 8
  %r22 = call i64 @nova_rt_print_any(i64 %r21)
  br label %endif23
else22:
  br label %endif23
endif23:
  %r23 = load i64, ptr %slot.__for_idx_18, align 8
  %r24 = add i64 1, 0
  %r25 = add i64 %r23, %r24
  store i64 %r25, ptr %slot.__for_idx_18, align 8
  br label %for_hdr18
for_exit20:
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
@.str.0 = private unnamed_addr constant [2 x i8] c" \00"
@.str.1 = private unnamed_addr constant [2 x i8] c"\0A\00"
@.str.2 = private unnamed_addr constant [2 x i8] c"\09\00"
@.str.3 = private unnamed_addr constant [57 x i8] c"fn hello(x)\0A    return x + 1\0A\0Alet y = hello(42)\0Aprint(y)\00"
