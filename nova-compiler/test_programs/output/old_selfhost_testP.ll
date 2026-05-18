; NOVA Self-Hosted Compiler Output
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
  store i64 0, ptr %slot.count, align 8
  store i64 0, ptr %slot.i, align 8
  store i64 0, ptr %slot.in_word, align 8
  br label %while_hdr0
while_hdr0:
  %r0 = load i64, ptr %slot.i, align 8
  %r1 = load i64, ptr %slot.source, align 8
  %r2 = call i64 @nova_rt_len_any(i64 %r1)
  %t4 = icmp slt i64 %r0, %r2
  %r3 = zext i1 %t4 to i64
  %t5 = icmp ne i64 %r3, 0
  br i1 %t5, label %while_body1, label %while_exit2
while_body1:
  %r6 = load i64, ptr %slot.source, align 8
  %r7 = load i64, ptr %slot.i, align 8
  %r8 = call i64 @nova_rt_index_get(i64 %r6, i64 %r7)
  store i64 %r8, ptr %slot.ch, align 8
  %r9 = load i64, ptr %slot.ch, align 8
  %r10 = getelementptr inbounds [2 x i8], ptr @.str.0, i64 0, i64 0
  %r11 = ptrtoint ptr %r10 to i64
  %t13 = call i64 @nova_rt_eq(i64 %r9, i64 %r11)
  %r12 = and i64 %t13, 1
  %r14 = load i64, ptr %slot.ch, align 8
  %r15 = getelementptr inbounds [2 x i8], ptr @.str.1, i64 0, i64 0
  %r16 = ptrtoint ptr %r15 to i64
  %t18 = call i64 @nova_rt_eq(i64 %r14, i64 %r16)
  %r17 = and i64 %t18, 1
  br label %or_entry3
or_entry3:
  %t20 = icmp ne i64 %t13, 0
  br i1 %t20, label %or_end5, label %or_rhs4
or_rhs4:
  %r21 = load i64, ptr %slot.ch, align 8
  %r22 = getelementptr inbounds [2 x i8], ptr @.str.1, i64 0, i64 0
  %r23 = ptrtoint ptr %r22 to i64
  %t25 = call i64 @nova_rt_eq(i64 %r21, i64 %r23)
  %r24 = and i64 %t25, 1
  br label %or_done6
or_done6:
  br label %or_end5
or_end5:
  %r19 = phi i64 [%t13, %or_entry3], [%t25, %or_done6]
  %r26 = load i64, ptr %slot.ch, align 8
  %r27 = getelementptr inbounds [2 x i8], ptr @.str.2, i64 0, i64 0
  %r28 = ptrtoint ptr %r27 to i64
  %t30 = call i64 @nova_rt_eq(i64 %r26, i64 %r28)
  %r29 = and i64 %t30, 1
  br label %or_entry7
or_entry7:
  %t32 = icmp ne i64 %r19, 0
  br i1 %t32, label %or_end9, label %or_rhs8
or_rhs8:
  %r33 = load i64, ptr %slot.ch, align 8
  %r34 = getelementptr inbounds [2 x i8], ptr @.str.2, i64 0, i64 0
  %r35 = ptrtoint ptr %r34 to i64
  %t37 = call i64 @nova_rt_eq(i64 %r33, i64 %r35)
  %r36 = and i64 %t37, 1
  br label %or_done10
or_done10:
  br label %or_end9
or_end9:
  %r31 = phi i64 [%r19, %or_entry7], [%t37, %or_done10]
  %t38 = icmp ne i64 %r31, 0
  br i1 %t38, label %then11, label %else12
then11:
  %r39 = load i64, ptr %slot.in_word, align 8
  %t40 = icmp ne i64 %r39, 0
  br i1 %t40, label %then14, label %else15
then14:
  %r41 = load i64, ptr %slot.count, align 8
  %r42 = call i64 @nova_rt_add(i64 %r41, i64 1)
  store i64 %r42, ptr %slot.count, align 8
  store i64 0, ptr %slot.in_word, align 8
  br label %merge16
else15:
  br label %merge16
merge16:
  br label %merge13
else12:
  store i64 1, ptr %slot.in_word, align 8
  br label %merge13
merge13:
  %r43 = load i64, ptr %slot.i, align 8
  %r44 = call i64 @nova_rt_add(i64 %r43, i64 1)
  store i64 %r44, ptr %slot.i, align 8
  br label %while_hdr0
while_exit2:
  %r45 = load i64, ptr %slot.in_word, align 8
  %t46 = icmp ne i64 %r45, 0
  br i1 %t46, label %then17, label %else18
then17:
  %r47 = load i64, ptr %slot.count, align 8
  %r48 = call i64 @nova_rt_add(i64 %r47, i64 1)
  store i64 %r48, ptr %slot.count, align 8
  br label %merge19
else18:
  br label %merge19
merge19:
  %r49 = load i64, ptr %slot.count, align 8
  ret i64 %r49
}

define i64 @nova_main() nounwind {
entry:
  %slot.code = alloca i64, align 8
  store i64 0, ptr %slot.code, align 8
  %slot.words = alloca i64, align 8
  store i64 0, ptr %slot.words, align 8
  %slot.parts = alloca i64, align 8
  store i64 0, ptr %slot.parts, align 8
  %slot.line = alloca i64, align 8
  store i64 0, ptr %slot.line, align 8
  %r0 = getelementptr inbounds [57 x i8], ptr @.str.3, i64 0, i64 0
  %r1 = ptrtoint ptr %r0 to i64
  store i64 %r1, ptr %slot.code, align 8
  %r2 = load i64, ptr %slot.code, align 8
  %r3 = call i64 @count_tokens(i64 %r2)
  store i64 %r3, ptr %slot.words, align 8
  %r4 = load i64, ptr %slot.words, align 8
  %r5 = call i64 @nova_rt_print_any(i64 %r4)
  %r6 = load i64, ptr %slot.code, align 8
  %r7 = getelementptr inbounds [2 x i8], ptr @.str.1, i64 0, i64 0
  %r8 = ptrtoint ptr %r7 to i64
  %r9 = call i64 @nova_rt_split(i64 %r6, i64 %r8)
  store i64 %r9, ptr %slot.parts, align 8
  %r10 = load i64, ptr %slot.parts, align 8
  %r11 = call i64 @nova_rt_len_any(i64 %r10)
  %r12 = call i64 @nova_rt_print_any(i64 %r11)
  %r13 = load i64, ptr %slot.parts, align 8
  %r14 = call i64 @nova_rt_len_any(i64 %r13)
  %slot.__for_idx_20 = alloca i64, align 8
  store i64 0, ptr %slot.__for_idx_20, align 8
  br label %for_hdr20
for_hdr20:
  %r15 = load i64, ptr %slot.__for_idx_20, align 8
  %t16 = icmp slt i64 %r15, %r14
  br i1 %t16, label %for_body21, label %for_exit22
for_body21:
  %r17 = call i64 @nova_rt_index_get(i64 %r13, i64 %r15)
  store i64 %r17, ptr %slot.line, align 8
  %r18 = load i64, ptr %slot.line, align 8
  %r19 = call i64 @nova_rt_len_any(i64 %r18)
  %t21 = icmp sgt i64 %r19, 0
  %r20 = zext i1 %t21 to i64
  %t22 = icmp ne i64 %r20, 0
  br i1 %t22, label %then23, label %else24
then23:
  %r23 = load i64, ptr %slot.line, align 8
  %r24 = call i64 @nova_rt_print_any(i64 %r23)
  br label %merge25
else24:
  br label %merge25
merge25:
  %r26 = load i64, ptr %slot.__for_idx_20, align 8
  %r25 = add i64 %r26, 1
  store i64 %r25, ptr %slot.__for_idx_20, align 8
  br label %for_hdr20
for_exit22:
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
