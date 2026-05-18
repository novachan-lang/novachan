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

define i64 @sum_loop(i64 %p0) nounwind {
entry:
  %slot.n = alloca i64, align 8
  store i64 %p0, ptr %slot.n, align 8
  %slot.total = alloca i64, align 8
  store i64 0, ptr %slot.total, align 8
  %slot.i = alloca i64, align 8
  store i64 0, ptr %slot.i, align 8
  store i64 0, ptr %slot.total, align 8
  store i64 0, ptr %slot.i, align 8
  br label %while_hdr0
while_hdr0:
  %r0 = load i64, ptr %slot.i, align 8
  %r1 = load i64, ptr %slot.n, align 8
  %t3 = icmp slt i64 %r0, %r1
  %r2 = zext i1 %t3 to i64
  %t4 = icmp ne i64 %r2, 0
  br i1 %t4, label %while_body1, label %while_exit2
while_body1:
  %r5 = load i64, ptr %slot.total, align 8
  %r6 = load i64, ptr %slot.i, align 8
  %r7 = call i64 @nova_rt_add(i64 %r5, i64 %r6)
  store i64 %r7, ptr %slot.total, align 8
  %r8 = load i64, ptr %slot.i, align 8
  %r9 = call i64 @nova_rt_add(i64 %r8, i64 1)
  store i64 %r9, ptr %slot.i, align 8
  br label %while_hdr0
while_exit2:
  %r10 = load i64, ptr %slot.total, align 8
  ret i64 %r10
}

define i64 @count_primes(i64 %p0) nounwind {
entry:
  %slot.limit = alloca i64, align 8
  store i64 %p0, ptr %slot.limit, align 8
  %slot.count = alloca i64, align 8
  store i64 0, ptr %slot.count, align 8
  %slot.n = alloca i64, align 8
  store i64 0, ptr %slot.n, align 8
  %slot.is_prime = alloca i64, align 8
  store i64 0, ptr %slot.is_prime, align 8
  %slot.d = alloca i64, align 8
  store i64 0, ptr %slot.d, align 8
  store i64 0, ptr %slot.count, align 8
  store i64 2, ptr %slot.n, align 8
  br label %while_hdr3
while_hdr3:
  %r0 = load i64, ptr %slot.n, align 8
  %r1 = load i64, ptr %slot.limit, align 8
  %t3 = icmp slt i64 %r0, %r1
  %r2 = zext i1 %t3 to i64
  %t4 = icmp ne i64 %r2, 0
  br i1 %t4, label %while_body4, label %while_exit5
while_body4:
  store i64 1, ptr %slot.is_prime, align 8
  store i64 2, ptr %slot.d, align 8
  br label %while_hdr6
while_hdr6:
  %r5 = load i64, ptr %slot.d, align 8
  %r6 = load i64, ptr %slot.d, align 8
  %r7 = mul i64 %r5, %r6
  %r8 = load i64, ptr %slot.n, align 8
  %t10 = icmp sle i64 %r7, %r8
  %r9 = zext i1 %t10 to i64
  %t11 = icmp ne i64 %r9, 0
  br i1 %t11, label %while_body7, label %while_exit8
while_body7:
  %r12 = load i64, ptr %slot.n, align 8
  %r13 = load i64, ptr %slot.d, align 8
  %r14 = srem i64 %r12, %r13
  %t16 = call i64 @nova_rt_eq(i64 %r14, i64 0)
  %r15 = and i64 %t16, 1
  %t17 = icmp ne i64 %t16, 0
  br i1 %t17, label %then9, label %else10
then9:
  store i64 0, ptr %slot.is_prime, align 8
  br label %merge11
else10:
  br label %merge11
merge11:
  %r18 = load i64, ptr %slot.d, align 8
  %r19 = call i64 @nova_rt_add(i64 %r18, i64 1)
  store i64 %r19, ptr %slot.d, align 8
  br label %while_hdr6
while_exit8:
  %r20 = load i64, ptr %slot.is_prime, align 8
  %t21 = icmp ne i64 %r20, 0
  br i1 %t21, label %then12, label %else13
then12:
  %r22 = load i64, ptr %slot.count, align 8
  %r23 = call i64 @nova_rt_add(i64 %r22, i64 1)
  store i64 %r23, ptr %slot.count, align 8
  br label %merge14
else13:
  br label %merge14
merge14:
  %r24 = load i64, ptr %slot.n, align 8
  %r25 = call i64 @nova_rt_add(i64 %r24, i64 1)
  store i64 %r25, ptr %slot.n, align 8
  br label %while_hdr3
while_exit5:
  %r26 = load i64, ptr %slot.count, align 8
  ret i64 %r26
}

define i64 @nova_main() nounwind {
entry:
  %slot.t0 = alloca i64, align 8
  store i64 0, ptr %slot.t0, align 8
  %slot.r1 = alloca i64, align 8
  store i64 0, ptr %slot.r1, align 8
  %slot.t1 = alloca i64, align 8
  store i64 0, ptr %slot.t1, align 8
  %slot.r2 = alloca i64, align 8
  store i64 0, ptr %slot.r2, align 8
  %slot.t2 = alloca i64, align 8
  store i64 0, ptr %slot.t2, align 8
  %r0 = call i64 @nova_rt_clock_ns()
  store i64 %r0, ptr %slot.t0, align 8
  %r1 = call i64 @sum_loop(i64 10000000)
  store i64 %r1, ptr %slot.r1, align 8
  %r2 = call i64 @nova_rt_clock_ns()
  store i64 %r2, ptr %slot.t1, align 8
  %r3 = call i64 @count_primes(i64 50000)
  store i64 %r3, ptr %slot.r2, align 8
  %r4 = call i64 @nova_rt_clock_ns()
  store i64 %r4, ptr %slot.t2, align 8
  %r5 = getelementptr inbounds [17 x i8], ptr @.str.0, i64 0, i64 0
  %r6 = ptrtoint ptr %r5 to i64
  %r7 = load i64, ptr %slot.r1, align 8
  %r8 = call i64 @nova_rt_int_to_str(i64 %r7)
  %r9 = call i64 @nova_rt_add(i64 %r6, i64 %r8)
  %r10 = getelementptr inbounds [5 x i8], ptr @.str.1, i64 0, i64 0
  %r11 = ptrtoint ptr %r10 to i64
  %r12 = call i64 @nova_rt_add(i64 %r9, i64 %r11)
  %r13 = load i64, ptr %slot.t1, align 8
  %r14 = load i64, ptr %slot.t0, align 8
  %r15 = sub i64 %r13, %r14
  %r16 = sdiv i64 %r15, 1000000
  %r17 = call i64 @nova_rt_int_to_str(i64 %r16)
  %r18 = call i64 @nova_rt_add(i64 %r12, i64 %r17)
  %r19 = getelementptr inbounds [4 x i8], ptr @.str.2, i64 0, i64 0
  %r20 = ptrtoint ptr %r19 to i64
  %r21 = call i64 @nova_rt_add(i64 %r18, i64 %r20)
  %r22 = call i64 @nova_rt_print_any(i64 %r21)
  %r23 = getelementptr inbounds [17 x i8], ptr @.str.3, i64 0, i64 0
  %r24 = ptrtoint ptr %r23 to i64
  %r25 = load i64, ptr %slot.r2, align 8
  %r26 = call i64 @nova_rt_int_to_str(i64 %r25)
  %r27 = call i64 @nova_rt_add(i64 %r24, i64 %r26)
  %r28 = getelementptr inbounds [5 x i8], ptr @.str.1, i64 0, i64 0
  %r29 = ptrtoint ptr %r28 to i64
  %r30 = call i64 @nova_rt_add(i64 %r27, i64 %r29)
  %r31 = load i64, ptr %slot.t2, align 8
  %r32 = load i64, ptr %slot.t1, align 8
  %r33 = sub i64 %r31, %r32
  %r34 = sdiv i64 %r33, 1000000
  %r35 = call i64 @nova_rt_int_to_str(i64 %r34)
  %r36 = call i64 @nova_rt_add(i64 %r30, i64 %r35)
  %r37 = getelementptr inbounds [4 x i8], ptr @.str.2, i64 0, i64 0
  %r38 = ptrtoint ptr %r37 to i64
  %r39 = call i64 @nova_rt_add(i64 %r36, i64 %r38)
  %r40 = call i64 @nova_rt_print_any(i64 %r39)
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
@.str.0 = private unnamed_addr constant [17 x i8] c"sum(10M)      = \00"
@.str.1 = private unnamed_addr constant [5 x i8] c" in \00"
@.str.2 = private unnamed_addr constant [4 x i8] c" ms\00"
@.str.3 = private unnamed_addr constant [17 x i8] c"primes(50K)   = \00"
