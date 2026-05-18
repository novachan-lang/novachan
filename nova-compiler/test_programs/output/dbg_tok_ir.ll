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

define i64 @mini_tokenize(i64 %p0) nounwind {
entry:
  %slot.source = alloca i64, align 8
  store i64 %p0, ptr %slot.source, align 8
  %slot.tokens = alloca i64, align 8
  store i64 0, ptr %slot.tokens, align 8
  %slot.i = alloca i64, align 8
  store i64 0, ptr %slot.i, align 8
  %slot.n = alloca i64, align 8
  store i64 0, ptr %slot.n, align 8
  %slot.ch = alloca i64, align 8
  store i64 0, ptr %slot.ch, align 8
  %slot.start = alloca i64, align 8
  store i64 0, ptr %slot.start, align 8
  %slot.word = alloca i64, align 8
  store i64 0, ptr %slot.word, align 8
  %r0 = call i64 @nova_rt_list_create()
  store i64 %r0, ptr %slot.tokens, align 8
  %r1 = add i64 0, 0
  store i64 %r1, ptr %slot.i, align 8
  %r2 = load i64, ptr %slot.source, align 8
  %r3 = call i64 @nova_rt_len_any(i64 %r2)
  store i64 %r3, ptr %slot.n, align 8
  br label %while_hdr0
while_hdr0:
  %r4 = load i64, ptr %slot.i, align 8
  %r5 = load i64, ptr %slot.n, align 8
  %r6.cmp = icmp slt i64 %r4, %r5
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
  %r13 = load i64, ptr %slot.ch, align 8
  %r14.p = getelementptr inbounds [2 x i8], ptr @.str.1, i64 0, i64 0
  %r14 = ptrtoint ptr %r14.p to i64
  %r15 = call i64 @nova_rt_eq(i64 %r13, i64 %r14)
  %r16.cmp = icmp ne i64 %r12, 0
  %r16.cmp2 = icmp ne i64 %r15, 0
  %r16.or = or i1 %r16.cmp, %r16.cmp2
  %r16 = zext i1 %r16.or to i64
  %br_then3 = icmp ne i64 %r16, 0
  br i1 %br_then3, label %then3, label %else4
then3:
  %r17 = load i64, ptr %slot.i, align 8
  %r18 = add i64 1, 0
  %r19 = add i64 %r17, %r18
  store i64 %r19, ptr %slot.i, align 8
  br label %endif5
else4:
  %r20 = load i64, ptr %slot.ch, align 8
  %r21.p = getelementptr inbounds [2 x i8], ptr @.str.2, i64 0, i64 0
  %r21 = ptrtoint ptr %r21.p to i64
  %r22 = call i64 @nova_rt_eq(i64 %r20, i64 %r21)
  %br_then6 = icmp ne i64 %r22, 0
  br i1 %br_then6, label %then6, label %else7
then6:
  %r23 = load i64, ptr %slot.tokens, align 8
  %r24.p = getelementptr inbounds [2 x i8], ptr @.str.2, i64 0, i64 0
  %r24 = ptrtoint ptr %r24.p to i64
  %r25 = call i64 @nova_rt_list_append(i64 %r23, i64 %r24)
  %r26 = load i64, ptr %slot.i, align 8
  %r27 = add i64 1, 0
  %r28 = add i64 %r26, %r27
  store i64 %r28, ptr %slot.i, align 8
  br label %endif8
else7:
  %r29 = load i64, ptr %slot.ch, align 8
  %r30.p = getelementptr inbounds [2 x i8], ptr @.str.3, i64 0, i64 0
  %r30 = ptrtoint ptr %r30.p to i64
  %r31 = call i64 @nova_rt_eq(i64 %r29, i64 %r30)
  %br_then9 = icmp ne i64 %r31, 0
  br i1 %br_then9, label %then9, label %else10
then9:
  %r32 = load i64, ptr %slot.tokens, align 8
  %r33.p = getelementptr inbounds [2 x i8], ptr @.str.3, i64 0, i64 0
  %r33 = ptrtoint ptr %r33.p to i64
  %r34 = call i64 @nova_rt_list_append(i64 %r32, i64 %r33)
  %r35 = load i64, ptr %slot.i, align 8
  %r36 = add i64 1, 0
  %r37 = add i64 %r35, %r36
  store i64 %r37, ptr %slot.i, align 8
  br label %endif11
else10:
  %r38 = load i64, ptr %slot.i, align 8
  store i64 %r38, ptr %slot.start, align 8
  %r39.p = getelementptr inbounds [1 x i8], ptr @.str.4, i64 0, i64 0
  %r39 = ptrtoint ptr %r39.p to i64
  store i64 %r39, ptr %slot.word, align 8
  br label %while_hdr12
while_hdr12:
  %r40 = load i64, ptr %slot.i, align 8
  %r41 = load i64, ptr %slot.n, align 8
  %r42.cmp = icmp slt i64 %r40, %r41
  %r42 = zext i1 %r42.cmp to i64
  %r43 = load i64, ptr %slot.source, align 8
  %r44 = load i64, ptr %slot.i, align 8
  %r45 = call i64 @nova_rt_index_get(i64 %r43, i64 %r44)
  %r46.p = getelementptr inbounds [2 x i8], ptr @.str.0, i64 0, i64 0
  %r46 = ptrtoint ptr %r46.p to i64
  %r47 = call i64 @nova_rt_neq(i64 %r45, i64 %r46)
  %r48.cmp = icmp ne i64 %r42, 0
  %r48.cmp2 = icmp ne i64 %r47, 0
  %r48.and = and i1 %r48.cmp, %r48.cmp2
  %r48 = zext i1 %r48.and to i64
  %r49 = load i64, ptr %slot.source, align 8
  %r50 = load i64, ptr %slot.i, align 8
  %r51 = call i64 @nova_rt_index_get(i64 %r49, i64 %r50)
  %r52.p = getelementptr inbounds [2 x i8], ptr @.str.1, i64 0, i64 0
  %r52 = ptrtoint ptr %r52.p to i64
  %r53 = call i64 @nova_rt_neq(i64 %r51, i64 %r52)
  %r54.cmp = icmp ne i64 %r48, 0
  %r54.cmp2 = icmp ne i64 %r53, 0
  %r54.and = and i1 %r54.cmp, %r54.cmp2
  %r54 = zext i1 %r54.and to i64
  %r55 = load i64, ptr %slot.source, align 8
  %r56 = load i64, ptr %slot.i, align 8
  %r57 = call i64 @nova_rt_index_get(i64 %r55, i64 %r56)
  %r58.p = getelementptr inbounds [2 x i8], ptr @.str.2, i64 0, i64 0
  %r58 = ptrtoint ptr %r58.p to i64
  %r59 = call i64 @nova_rt_neq(i64 %r57, i64 %r58)
  %r60.cmp = icmp ne i64 %r54, 0
  %r60.cmp2 = icmp ne i64 %r59, 0
  %r60.and = and i1 %r60.cmp, %r60.cmp2
  %r60 = zext i1 %r60.and to i64
  %r61 = load i64, ptr %slot.source, align 8
  %r62 = load i64, ptr %slot.i, align 8
  %r63 = call i64 @nova_rt_index_get(i64 %r61, i64 %r62)
  %r64.p = getelementptr inbounds [2 x i8], ptr @.str.3, i64 0, i64 0
  %r64 = ptrtoint ptr %r64.p to i64
  %r65 = call i64 @nova_rt_neq(i64 %r63, i64 %r64)
  %r66.cmp = icmp ne i64 %r60, 0
  %r66.cmp2 = icmp ne i64 %r65, 0
  %r66.and = and i1 %r66.cmp, %r66.cmp2
  %r66 = zext i1 %r66.and to i64
  %br_while_body13 = icmp ne i64 %r66, 0
  br i1 %br_while_body13, label %while_body13, label %while_exit14
while_body13:
  %r67 = load i64, ptr %slot.word, align 8
  %r68 = load i64, ptr %slot.source, align 8
  %r69 = load i64, ptr %slot.i, align 8
  %r70 = call i64 @nova_rt_index_get(i64 %r68, i64 %r69)
  %r71 = call i64 @nova_rt_str_concat(i64 %r67, i64 %r70)
  store i64 %r71, ptr %slot.word, align 8
  %r72 = load i64, ptr %slot.i, align 8
  %r73 = add i64 1, 0
  %r74 = add i64 %r72, %r73
  store i64 %r74, ptr %slot.i, align 8
  br label %while_hdr12
while_exit14:
  %r75 = load i64, ptr %slot.tokens, align 8
  %r76 = load i64, ptr %slot.word, align 8
  %r77 = call i64 @nova_rt_list_append(i64 %r75, i64 %r76)
  br label %endif11
endif11:
  br label %endif8
endif8:
  br label %endif5
endif5:
  br label %while_hdr0
while_exit2:
  %r78 = load i64, ptr %slot.tokens, align 8
  ret i64 %r78
}

define i64 @nova_main() nounwind {
entry:
  %slot.result = alloca i64, align 8
  store i64 0, ptr %slot.result, align 8
  %slot.__for_idx_15 = alloca i64, align 8
  store i64 0, ptr %slot.__for_idx_15, align 8
  %slot.t = alloca i64, align 8
  store i64 0, ptr %slot.t, align 8
  %r0.p = getelementptr inbounds [15 x i8], ptr @.str.5, i64 0, i64 0
  %r0 = ptrtoint ptr %r0.p to i64
  %r1 = call i64 @mini_tokenize(i64 %r0)
  store i64 %r1, ptr %slot.result, align 8
  %r2.p = getelementptr inbounds [14 x i8], ptr @.str.6, i64 0, i64 0
  %r2 = ptrtoint ptr %r2.p to i64
  %r3 = load i64, ptr %slot.result, align 8
  %r4 = call i64 @nova_rt_len_any(i64 %r3)
  %r5 = call i64 @nova_rt_int_to_str(i64 %r4)
  %r6 = call i64 @nova_rt_str_concat(i64 %r2, i64 %r5)
  %r7 = call i64 @nova_rt_print_any(i64 %r6)
  %r8 = load i64, ptr %slot.result, align 8
  %r9 = call i64 @nova_rt_len_any(i64 %r8)
  %r10 = add i64 0, 0
  store i64 %r10, ptr %slot.__for_idx_15, align 8
  br label %for_hdr15
for_hdr15:
  %r11 = load i64, ptr %slot.__for_idx_15, align 8
  %r12.cmp = icmp slt i64 %r11, %r9
  %r12 = zext i1 %r12.cmp to i64
  %br_for_body16 = icmp ne i64 %r12, 0
  br i1 %br_for_body16, label %for_body16, label %for_exit17
for_body16:
  %r13 = call i64 @nova_rt_index_get(i64 %r8, i64 %r11)
  store i64 %r13, ptr %slot.t, align 8
  %r14.p = getelementptr inbounds [3 x i8], ptr @.str.7, i64 0, i64 0
  %r14 = ptrtoint ptr %r14.p to i64
  %r15 = load i64, ptr %slot.t, align 8
  %r16 = call i64 @nova_rt_str_concat(i64 %r14, i64 %r15)
  %r17 = call i64 @nova_rt_print_any(i64 %r16)
  %r18 = load i64, ptr %slot.__for_idx_15, align 8
  %r19 = add i64 1, 0
  %r20 = add i64 %r18, %r19
  store i64 %r20, ptr %slot.__for_idx_15, align 8
  br label %for_hdr15
for_exit17:
  %r21 = load i64, ptr %slot.result, align 8
  %r22 = call i64 @nova_rt_len_any(i64 %r21)
  %r23 = add i64 6, 0
  %r24.cmp = icmp eq i64 %r22, %r23
  %r24 = zext i1 %r24.cmp to i64
  %br_then18 = icmp ne i64 %r24, 0
  br i1 %br_then18, label %then18, label %else19
then18:
  %r25.p = getelementptr inbounds [5 x i8], ptr @.str.8, i64 0, i64 0
  %r25 = ptrtoint ptr %r25.p to i64
  %r26 = call i64 @nova_rt_print_any(i64 %r25)
  br label %endif20
else19:
  %r27.p = getelementptr inbounds [24 x i8], ptr @.str.9, i64 0, i64 0
  %r27 = ptrtoint ptr %r27.p to i64
  %r28 = call i64 @nova_rt_print_any(i64 %r27)
  br label %endif20
endif20:
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
@.str.2 = private unnamed_addr constant [2 x i8] c"+\00"
@.str.3 = private unnamed_addr constant [2 x i8] c"=\00"
@.str.4 = private unnamed_addr constant [1 x i8] c"\00"
@.str.5 = private unnamed_addr constant [15 x i8] c"let x = 42 + 3\00"
@.str.6 = private unnamed_addr constant [14 x i8] c"Token count: \00"
@.str.7 = private unnamed_addr constant [3 x i8] c"  \00"
@.str.8 = private unnamed_addr constant [5 x i8] c"PASS\00"
@.str.9 = private unnamed_addr constant [24 x i8] c"FAIL: expected 6 tokens\00"
