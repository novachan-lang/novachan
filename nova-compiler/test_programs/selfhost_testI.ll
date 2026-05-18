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

define i64 @fizzbuzz(i64 %p0) nounwind {
entry:
  %slot.n = alloca i64, align 8
  store i64 %p0, ptr %slot.n, align 8
  %slot.i = alloca i64, align 8
  store i64 0, ptr %slot.i, align 8
  %slot.result = alloca i64, align 8
  store i64 0, ptr %slot.result, align 8
  %r0 = add i64 1, 0
  store i64 %r0, ptr %slot.i, align 8
  %r1.p = getelementptr inbounds [1 x i8], ptr @.str.0, i64 0, i64 0
  %r1 = ptrtoint ptr %r1.p to i64
  store i64 %r1, ptr %slot.result, align 8
  br label %while_hdr0
while_hdr0:
  %r2 = load i64, ptr %slot.i, align 8
  %r3 = load i64, ptr %slot.n, align 8
  %r4.cmp = icmp sle i64 %r2, %r3
  %r4 = zext i1 %r4.cmp to i64
  %br_while_body1 = icmp ne i64 %r4, 0
  br i1 %br_while_body1, label %while_body1, label %while_exit2
while_body1:
  %r5 = load i64, ptr %slot.i, align 8
  %r6 = add i64 15, 0
  %r7 = srem i64 %r5, %r6
  %r8 = add i64 0, 0
  %r9 = call i64 @nova_rt_eq(i64 %r7, i64 %r8)
  %br_then3 = icmp ne i64 %r9, 0
  br i1 %br_then3, label %then3, label %else4
then3:
  %r10 = load i64, ptr %slot.result, align 8
  %r11.p = getelementptr inbounds [10 x i8], ptr @.str.1, i64 0, i64 0
  %r11 = ptrtoint ptr %r11.p to i64
  %r12 = call i64 @nova_rt_add(i64 %r10, i64 %r11)
  store i64 %r12, ptr %slot.result, align 8
  br label %endif5
else4:
  %r13 = load i64, ptr %slot.i, align 8
  %r14 = add i64 3, 0
  %r15 = srem i64 %r13, %r14
  %r16 = add i64 0, 0
  %r17 = call i64 @nova_rt_eq(i64 %r15, i64 %r16)
  %br_then6 = icmp ne i64 %r17, 0
  br i1 %br_then6, label %then6, label %else7
then6:
  %r18 = load i64, ptr %slot.result, align 8
  %r19.p = getelementptr inbounds [6 x i8], ptr @.str.2, i64 0, i64 0
  %r19 = ptrtoint ptr %r19.p to i64
  %r20 = call i64 @nova_rt_add(i64 %r18, i64 %r19)
  store i64 %r20, ptr %slot.result, align 8
  br label %endif8
else7:
  %r21 = load i64, ptr %slot.i, align 8
  %r22 = add i64 5, 0
  %r23 = srem i64 %r21, %r22
  %r24 = add i64 0, 0
  %r25 = call i64 @nova_rt_eq(i64 %r23, i64 %r24)
  %br_then9 = icmp ne i64 %r25, 0
  br i1 %br_then9, label %then9, label %else10
then9:
  %r26 = load i64, ptr %slot.result, align 8
  %r27.p = getelementptr inbounds [6 x i8], ptr @.str.3, i64 0, i64 0
  %r27 = ptrtoint ptr %r27.p to i64
  %r28 = call i64 @nova_rt_add(i64 %r26, i64 %r27)
  store i64 %r28, ptr %slot.result, align 8
  br label %endif11
else10:
  %r29 = load i64, ptr %slot.result, align 8
  %r30 = load i64, ptr %slot.i, align 8
  %r31 = call i64 @nova_rt_int_to_str(i64 %r30)
  %r32 = call i64 @nova_rt_add(i64 %r29, i64 %r31)
  %r33.p = getelementptr inbounds [2 x i8], ptr @.str.4, i64 0, i64 0
  %r33 = ptrtoint ptr %r33.p to i64
  %r34 = call i64 @nova_rt_add(i64 %r32, i64 %r33)
  store i64 %r34, ptr %slot.result, align 8
  br label %endif11
endif5:
  %r35 = load i64, ptr %slot.i, align 8
  %r36 = add i64 1, 0
  %r37 = call i64 @nova_rt_add(i64 %r35, i64 %r36)
  store i64 %r37, ptr %slot.i, align 8
  br label %while_hdr0
while_exit2:
  %r38 = load i64, ptr %slot.result, align 8
  ret i64 %r38
while_exit2:
  ret i64 0
}

define i64 @nova_main() nounwind {
entry:
  %slot.out = alloca i64, align 8
  store i64 0, ptr %slot.out, align 8
  %r0 = add i64 15, 0
  %r1 = call i64 @fizzbuzz(i64 %r0)
  store i64 %r1, ptr %slot.out, align 8
  %r2 = load i64, ptr %slot.out, align 8
  %r3 = call i64 @nova_rt_print_any(i64 %r2)
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
