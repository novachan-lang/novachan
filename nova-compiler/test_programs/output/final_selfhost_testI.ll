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

define i64 @fizzbuzz(i64 %p0) nounwind {
entry:
  %slot.n = alloca i64, align 8
  store i64 %p0, ptr %slot.n, align 8
  %slot.i = alloca i64, align 8
  store i64 0, ptr %slot.i, align 8
  %slot.result = alloca i64, align 8
  store i64 0, ptr %slot.result, align 8
  store i64 1, ptr %slot.i, align 8
  %r0 = getelementptr inbounds [1 x i8], ptr @.str.0, i64 0, i64 0
  %r1 = ptrtoint ptr %r0 to i64
  store i64 %r1, ptr %slot.result, align 8
  br label %while_hdr0
while_hdr0:
  %r2 = load i64, ptr %slot.i, align 8
  %r3 = load i64, ptr %slot.n, align 8
  %t5 = icmp sle i64 %r2, %r3
  %r4 = zext i1 %t5 to i64
  %t6 = icmp ne i64 %r4, 0
  br i1 %t6, label %while_body1, label %while_exit2
while_body1:
  %r7 = load i64, ptr %slot.i, align 8
  %r8 = srem i64 %r7, 15
  %t10 = call i64 @nova_rt_eq(i64 %r8, i64 0)
  %r9 = and i64 %t10, 1
  %t11 = icmp ne i64 %t10, 0
  br i1 %t11, label %then3, label %else4
then3:
  %r12 = load i64, ptr %slot.result, align 8
  %r13 = getelementptr inbounds [10 x i8], ptr @.str.1, i64 0, i64 0
  %r14 = ptrtoint ptr %r13 to i64
  %r15 = call i64 @nova_rt_add(i64 %r12, i64 %r14)
  store i64 %r15, ptr %slot.result, align 8
  br label %merge5
else4:
  %r16 = load i64, ptr %slot.i, align 8
  %r17 = srem i64 %r16, 3
  %t19 = call i64 @nova_rt_eq(i64 %r17, i64 0)
  %r18 = and i64 %t19, 1
  %t20 = icmp ne i64 %t19, 0
  br i1 %t20, label %then6, label %else7
then6:
  %r21 = load i64, ptr %slot.result, align 8
  %r22 = getelementptr inbounds [6 x i8], ptr @.str.2, i64 0, i64 0
  %r23 = ptrtoint ptr %r22 to i64
  %r24 = call i64 @nova_rt_add(i64 %r21, i64 %r23)
  store i64 %r24, ptr %slot.result, align 8
  br label %merge8
else7:
  %r25 = load i64, ptr %slot.i, align 8
  %r26 = srem i64 %r25, 5
  %t28 = call i64 @nova_rt_eq(i64 %r26, i64 0)
  %r27 = and i64 %t28, 1
  %t29 = icmp ne i64 %t28, 0
  br i1 %t29, label %then9, label %else10
then9:
  %r30 = load i64, ptr %slot.result, align 8
  %r31 = getelementptr inbounds [6 x i8], ptr @.str.3, i64 0, i64 0
  %r32 = ptrtoint ptr %r31 to i64
  %r33 = call i64 @nova_rt_add(i64 %r30, i64 %r32)
  store i64 %r33, ptr %slot.result, align 8
  br label %merge11
else10:
  %r34 = load i64, ptr %slot.result, align 8
  %r35 = load i64, ptr %slot.i, align 8
  %r36 = call i64 @nova_rt_int_to_str(i64 %r35)
  %r37 = call i64 @nova_rt_add(i64 %r34, i64 %r36)
  %r38 = getelementptr inbounds [2 x i8], ptr @.str.4, i64 0, i64 0
  %r39 = ptrtoint ptr %r38 to i64
  %r40 = call i64 @nova_rt_add(i64 %r37, i64 %r39)
  store i64 %r40, ptr %slot.result, align 8
  br label %merge11
merge11:
  br label %merge8
merge8:
  br label %merge5
merge5:
  %r41 = load i64, ptr %slot.i, align 8
  %r42 = call i64 @nova_rt_add(i64 %r41, i64 1)
  store i64 %r42, ptr %slot.i, align 8
  br label %while_hdr0
while_exit2:
  %r43 = load i64, ptr %slot.result, align 8
  ret i64 %r43
}

define i64 @nova_main() nounwind {
entry:
  %slot.out = alloca i64, align 8
  store i64 0, ptr %slot.out, align 8
  %r0 = call i64 @fizzbuzz(i64 15)
  store i64 %r0, ptr %slot.out, align 8
  %r1 = load i64, ptr %slot.out, align 8
  %r2 = call i64 @nova_rt_print_any(i64 %r1)
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
@.str.1 = private unnamed_addr constant [10 x i8] c"FizzBuzz \00"
@.str.2 = private unnamed_addr constant [6 x i8] c"Fizz \00"
@.str.3 = private unnamed_addr constant [6 x i8] c"Buzz \00"
@.str.4 = private unnamed_addr constant [2 x i8] c" \00"
