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

define i64 @make_token(i64 %p0, i64 %p1) nounwind {
entry:
  %slot.k = alloca i64, align 8
  store i64 %p0, ptr %slot.k, align 8
  %slot.v = alloca i64, align 8
  store i64 %p1, ptr %slot.v, align 8
  %r0 = call ptr @nova_rt_struct_alloc(i64 16)
  %r1 = load i64, ptr %slot.k, align 8
  %t2 = getelementptr i64, ptr %r0, i64 0
  store i64 %r1, ptr %t2, align 8
  %r3 = load i64, ptr %slot.v, align 8
  %t4 = getelementptr i64, ptr %r0, i64 1
  store i64 %r3, ptr %t4, align 8
  %r5 = ptrtoint ptr %r0 to i64
  ret i64 %r5
}

define i64 @is_keyword(i64 %p0) nounwind {
entry:
  %slot.t = alloca i64, align 8
  store i64 %p0, ptr %slot.t, align 8
  %slot.kind = alloca i64, align 8
  store i64 0, ptr %slot.kind, align 8
  %slot.value = alloca i64, align 8
  store i64 0, ptr %slot.value, align 8
  %r0 = load i64, ptr %slot.t, align 8
  %t1 = inttoptr i64 %r0 to ptr
  %t2 = getelementptr i64, ptr %t1, i64 0
  %r3 = load i64, ptr %t2, align 8
  store i64 %r3, ptr %slot.kind, align 8
  %t4 = getelementptr i64, ptr %t1, i64 1
  %r5 = load i64, ptr %t4, align 8
  store i64 %r5, ptr %slot.value, align 8
  %r6 = load i64, ptr %slot.kind, align 8
  %r7 = getelementptr inbounds [3 x i8], ptr @.str.0, i64 0, i64 0
  %r8 = ptrtoint ptr %r7 to i64
  %t10 = call i64 @nova_rt_eq(i64 %r6, i64 %r8)
  %r9 = and i64 %t10, 1
  %t11 = icmp ne i64 %t10, 0
  br i1 %t11, label %then0, label %else1
then0:
  ret i64 1
  br label %merge2
else1:
  br label %merge2
merge2:
  ret i64 0
}

define i64 @token_str(i64 %p0) nounwind {
entry:
  %slot.t = alloca i64, align 8
  store i64 %p0, ptr %slot.t, align 8
  %slot.kind = alloca i64, align 8
  store i64 0, ptr %slot.kind, align 8
  %slot.value = alloca i64, align 8
  store i64 0, ptr %slot.value, align 8
  %r0 = load i64, ptr %slot.t, align 8
  %t1 = inttoptr i64 %r0 to ptr
  %t2 = getelementptr i64, ptr %t1, i64 0
  %r3 = load i64, ptr %t2, align 8
  store i64 %r3, ptr %slot.kind, align 8
  %t4 = getelementptr i64, ptr %t1, i64 1
  %r5 = load i64, ptr %t4, align 8
  store i64 %r5, ptr %slot.value, align 8
  %r6 = load i64, ptr %slot.kind, align 8
  %r7 = getelementptr inbounds [2 x i8], ptr @.str.1, i64 0, i64 0
  %r8 = ptrtoint ptr %r7 to i64
  %r9 = call i64 @nova_rt_add(i64 %r6, i64 %r8)
  %r10 = load i64, ptr %slot.value, align 8
  %r11 = call i64 @nova_rt_add(i64 %r9, i64 %r10)
  ret i64 %r11
  %r12 = getelementptr inbounds [1 x i8], ptr @.str.2, i64 0, i64 0
  %r13 = ptrtoint ptr %r12 to i64
  ret i64 %r13
}

define i64 @nova_main() nounwind {
entry:
  %slot.t1 = alloca i64, align 8
  store i64 0, ptr %slot.t1, align 8
  %slot.t2 = alloca i64, align 8
  store i64 0, ptr %slot.t2, align 8
  %slot.t3 = alloca i64, align 8
  store i64 0, ptr %slot.t3, align 8
  %r0 = getelementptr inbounds [3 x i8], ptr @.str.0, i64 0, i64 0
  %r1 = ptrtoint ptr %r0 to i64
  %r2 = getelementptr inbounds [3 x i8], ptr @.str.3, i64 0, i64 0
  %r3 = ptrtoint ptr %r2 to i64
  %r4 = call i64 @make_token(i64 %r1, i64 %r3)
  store i64 %r4, ptr %slot.t1, align 8
  %r5 = getelementptr inbounds [6 x i8], ptr @.str.4, i64 0, i64 0
  %r6 = ptrtoint ptr %r5 to i64
  %r7 = getelementptr inbounds [6 x i8], ptr @.str.5, i64 0, i64 0
  %r8 = ptrtoint ptr %r7 to i64
  %r9 = call i64 @make_token(i64 %r6, i64 %r8)
  store i64 %r9, ptr %slot.t2, align 8
  %r10 = getelementptr inbounds [4 x i8], ptr @.str.6, i64 0, i64 0
  %r11 = ptrtoint ptr %r10 to i64
  %r12 = getelementptr inbounds [3 x i8], ptr @.str.7, i64 0, i64 0
  %r13 = ptrtoint ptr %r12 to i64
  %r14 = call i64 @make_token(i64 %r11, i64 %r13)
  store i64 %r14, ptr %slot.t3, align 8
  %r15 = load i64, ptr %slot.t1, align 8
  %r16 = call i64 @is_keyword(i64 %r15)
  %r17 = call i64 @nova_rt_print_any(i64 %r16)
  %r18 = load i64, ptr %slot.t2, align 8
  %r19 = call i64 @is_keyword(i64 %r18)
  %r20 = call i64 @nova_rt_print_any(i64 %r19)
  %r21 = load i64, ptr %slot.t1, align 8
  %r22 = call i64 @token_str(i64 %r21)
  %r23 = call i64 @nova_rt_print_any(i64 %r22)
  %r24 = load i64, ptr %slot.t2, align 8
  %r25 = call i64 @token_str(i64 %r24)
  %r26 = call i64 @nova_rt_print_any(i64 %r25)
  %r27 = load i64, ptr %slot.t3, align 8
  %r28 = call i64 @token_str(i64 %r27)
  %r29 = call i64 @nova_rt_print_any(i64 %r28)
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
@.str.0 = private unnamed_addr constant [3 x i8] c"KW\00"
@.str.1 = private unnamed_addr constant [2 x i8] c":\00"
@.str.2 = private unnamed_addr constant [1 x i8] c"\00"
@.str.3 = private unnamed_addr constant [3 x i8] c"fn\00"
@.str.4 = private unnamed_addr constant [6 x i8] c"IDENT\00"
@.str.5 = private unnamed_addr constant [6 x i8] c"hello\00"
@.str.6 = private unnamed_addr constant [4 x i8] c"NUM\00"
@.str.7 = private unnamed_addr constant [3 x i8] c"42\00"
