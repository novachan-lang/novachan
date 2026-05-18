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
declare i64 @nova_rt_create_string(ptr) nounwind
declare void @nova_rt_init_args(i64, i64) nounwind
declare void @nova_rt_cleanup() nounwind

define i64 @fib(i64 %p0) nounwind {
entry:
  %slot.n = alloca i64, align 8
  store i64 %p0, ptr %slot.n, align 8
  %r0 = load i64, ptr %slot.n, align 8
  %r1 = add i64 1, 0
  %r2.cmp = icmp sle i64 %r0, %r1
  %r2 = zext i1 %r2.cmp to i64
  %br_then0 = icmp ne i64 %r2, 0
  br i1 %br_then0, label %then0, label %else1
then0:
  %r3 = load i64, ptr %slot.n, align 8
  ret i64 %r3
else1:
  br label %endif2
endif2:
  %r4 = load i64, ptr %slot.n, align 8
  %r5 = add i64 1, 0
  %r6 = sub i64 %r4, %r5
  %r7 = call i64 @fib(i64 %r6)
  %r8 = load i64, ptr %slot.n, align 8
  %r9 = add i64 2, 0
  %r10 = sub i64 %r8, %r9
  %r11 = call i64 @fib(i64 %r10)
  %r12 = add i64 %r7, %r11
  ret i64 %r12
}

define i64 @sum_loop(i64 %p0) nounwind {
entry:
  %slot.n = alloca i64, align 8
  store i64 %p0, ptr %slot.n, align 8
  %slot.total = alloca i64, align 8
  store i64 0, ptr %slot.total, align 8
  %slot.i = alloca i64, align 8
  store i64 0, ptr %slot.i, align 8
  %r0 = add i64 0, 0
  store i64 %r0, ptr %slot.total, align 8
  %r1 = add i64 0, 0
  store i64 %r1, ptr %slot.i, align 8
  br label %while_hdr3
while_hdr3:
  %r2 = load i64, ptr %slot.i, align 8
  %r3 = load i64, ptr %slot.n, align 8
  %r4.cmp = icmp slt i64 %r2, %r3
  %r4 = zext i1 %r4.cmp to i64
  %br_while_body4 = icmp ne i64 %r4, 0
  br i1 %br_while_body4, label %while_body4, label %while_exit5
while_body4:
  %r5 = load i64, ptr %slot.total, align 8
  %r6 = load i64, ptr %slot.i, align 8
  %r7 = add i64 %r5, %r6
  store i64 %r7, ptr %slot.total, align 8
  %r8 = load i64, ptr %slot.i, align 8
  %r9 = add i64 1, 0
  %r10 = add i64 %r8, %r9
  store i64 %r10, ptr %slot.i, align 8
  br label %while_hdr3
while_exit5:
  %r11 = load i64, ptr %slot.total, align 8
  ret i64 %r11
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
  %r0 = add i64 0, 0
  store i64 %r0, ptr %slot.count, align 8
  %r1 = add i64 2, 0
  store i64 %r1, ptr %slot.n, align 8
  br label %while_hdr6
while_hdr6:
  %r2 = load i64, ptr %slot.n, align 8
  %r3 = load i64, ptr %slot.limit, align 8
  %r4.cmp = icmp slt i64 %r2, %r3
  %r4 = zext i1 %r4.cmp to i64
  %br_while_body7 = icmp ne i64 %r4, 0
  br i1 %br_while_body7, label %while_body7, label %while_exit8
while_body7:
  %r5 = add i64 1, 0
  store i64 %r5, ptr %slot.is_prime, align 8
  %r6 = add i64 2, 0
  store i64 %r6, ptr %slot.d, align 8
  br label %while_hdr9
while_hdr9:
  %r7 = load i64, ptr %slot.d, align 8
  %r8 = load i64, ptr %slot.d, align 8
  %r9 = mul i64 %r7, %r8
  %r10 = load i64, ptr %slot.n, align 8
  %r11.cmp = icmp sle i64 %r9, %r10
  %r11 = zext i1 %r11.cmp to i64
  %br_while_body10 = icmp ne i64 %r11, 0
  br i1 %br_while_body10, label %while_body10, label %while_exit11
while_body10:
  %r12 = load i64, ptr %slot.n, align 8
  %r13 = load i64, ptr %slot.d, align 8
  %r14 = srem i64 %r12, %r13
  %r15 = add i64 0, 0
  %r16.cmp = icmp eq i64 %r14, %r15
  %r16 = zext i1 %r16.cmp to i64
  %br_then12 = icmp ne i64 %r16, 0
  br i1 %br_then12, label %then12, label %else13
then12:
  %r17 = add i64 0, 0
  store i64 %r17, ptr %slot.is_prime, align 8
  br label %endif14
else13:
  br label %endif14
endif14:
  %r18 = load i64, ptr %slot.d, align 8
  %r19 = add i64 1, 0
  %r20 = add i64 %r18, %r19
  store i64 %r20, ptr %slot.d, align 8
  br label %while_hdr9
while_exit11:
  %r21 = load i64, ptr %slot.is_prime, align 8
  %r22 = add i64 1, 0
  %r23.cmp = icmp eq i64 %r21, %r22
  %r23 = zext i1 %r23.cmp to i64
  %br_then15 = icmp ne i64 %r23, 0
  br i1 %br_then15, label %then15, label %else16
then15:
  %r24 = load i64, ptr %slot.count, align 8
  %r25 = add i64 1, 0
  %r26 = add i64 %r24, %r25
  store i64 %r26, ptr %slot.count, align 8
  br label %endif17
else16:
  br label %endif17
endif17:
  %r27 = load i64, ptr %slot.n, align 8
  %r28 = add i64 1, 0
  %r29 = add i64 %r27, %r28
  store i64 %r29, ptr %slot.n, align 8
  br label %while_hdr6
while_exit8:
  %r30 = load i64, ptr %slot.count, align 8
  ret i64 %r30
}

define i64 @run() nounwind {
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
  %slot.r3 = alloca i64, align 8
  store i64 0, ptr %slot.r3, align 8
  %slot.t3 = alloca i64, align 8
  store i64 0, ptr %slot.t3, align 8
  %r0 = call i64 @nova_rt_clock_ns()
  store i64 %r0, ptr %slot.t0, align 8
  %r1 = add i64 38, 0
  %r2 = call i64 @fib(i64 %r1)
  store i64 %r2, ptr %slot.r1, align 8
  %r3 = call i64 @nova_rt_clock_ns()
  store i64 %r3, ptr %slot.t1, align 8
  %r4 = add i64 100000000, 0
  %r5 = call i64 @sum_loop(i64 %r4)
  store i64 %r5, ptr %slot.r2, align 8
  %r6 = call i64 @nova_rt_clock_ns()
  store i64 %r6, ptr %slot.t2, align 8
  %r7 = add i64 100000, 0
  %r8 = call i64 @count_primes(i64 %r7)
  store i64 %r8, ptr %slot.r3, align 8
  %r9 = call i64 @nova_rt_clock_ns()
  store i64 %r9, ptr %slot.t3, align 8
  %r10.p = getelementptr inbounds [17 x i8], ptr @.str.0, i64 0, i64 0
  %r10 = ptrtoint ptr %r10.p to i64
  %r11 = load i64, ptr %slot.r1, align 8
  %r12 = call i64 @nova_rt_int_to_str(i64 %r11)
  %r13 = call i64 @nova_rt_str_concat(i64 %r10, i64 %r12)
  %r14.p = getelementptr inbounds [4 x i8], ptr @.str.1, i64 0, i64 0
  %r14 = ptrtoint ptr %r14.p to i64
  %r15 = call i64 @nova_rt_str_concat(i64 %r13, i64 %r14)
  %r16 = load i64, ptr %slot.t1, align 8
  %r17 = load i64, ptr %slot.t0, align 8
  %r18 = sub i64 %r16, %r17
  %r19 = add i64 1000000, 0
  %r20 = sdiv i64 %r18, %r19
  %r21 = call i64 @nova_rt_int_to_str(i64 %r20)
  %r22 = call i64 @nova_rt_str_concat(i64 %r15, i64 %r21)
  %r23.p = getelementptr inbounds [5 x i8], ptr @.str.2, i64 0, i64 0
  %r23 = ptrtoint ptr %r23.p to i64
  %r24 = call i64 @nova_rt_str_concat(i64 %r22, i64 %r23)
  %r25 = call i64 @nova_rt_print_any(i64 %r24)
  %r26.p = getelementptr inbounds [17 x i8], ptr @.str.3, i64 0, i64 0
  %r26 = ptrtoint ptr %r26.p to i64
  %r27 = load i64, ptr %slot.r2, align 8
  %r28 = call i64 @nova_rt_int_to_str(i64 %r27)
  %r29 = call i64 @nova_rt_str_concat(i64 %r26, i64 %r28)
  %r30.p = getelementptr inbounds [4 x i8], ptr @.str.1, i64 0, i64 0
  %r30 = ptrtoint ptr %r30.p to i64
  %r31 = call i64 @nova_rt_str_concat(i64 %r29, i64 %r30)
  %r32 = load i64, ptr %slot.t2, align 8
  %r33 = load i64, ptr %slot.t1, align 8
  %r34 = sub i64 %r32, %r33
  %r35 = add i64 1000000, 0
  %r36 = sdiv i64 %r34, %r35
  %r37 = call i64 @nova_rt_int_to_str(i64 %r36)
  %r38 = call i64 @nova_rt_str_concat(i64 %r31, i64 %r37)
  %r39.p = getelementptr inbounds [5 x i8], ptr @.str.2, i64 0, i64 0
  %r39 = ptrtoint ptr %r39.p to i64
  %r40 = call i64 @nova_rt_str_concat(i64 %r38, i64 %r39)
  %r41 = call i64 @nova_rt_print_any(i64 %r40)
  %r42.p = getelementptr inbounds [17 x i8], ptr @.str.4, i64 0, i64 0
  %r42 = ptrtoint ptr %r42.p to i64
  %r43 = load i64, ptr %slot.r3, align 8
  %r44 = call i64 @nova_rt_int_to_str(i64 %r43)
  %r45 = call i64 @nova_rt_str_concat(i64 %r42, i64 %r44)
  %r46.p = getelementptr inbounds [4 x i8], ptr @.str.1, i64 0, i64 0
  %r46 = ptrtoint ptr %r46.p to i64
  %r47 = call i64 @nova_rt_str_concat(i64 %r45, i64 %r46)
  %r48 = load i64, ptr %slot.t3, align 8
  %r49 = load i64, ptr %slot.t2, align 8
  %r50 = sub i64 %r48, %r49
  %r51 = add i64 1000000, 0
  %r52 = sdiv i64 %r50, %r51
  %r53 = call i64 @nova_rt_int_to_str(i64 %r52)
  %r54 = call i64 @nova_rt_str_concat(i64 %r47, i64 %r53)
  %r55.p = getelementptr inbounds [5 x i8], ptr @.str.2, i64 0, i64 0
  %r55 = ptrtoint ptr %r55.p to i64
  %r56 = call i64 @nova_rt_str_concat(i64 %r54, i64 %r55)
  %r57 = call i64 @nova_rt_print_any(i64 %r56)
  %r58.p = getelementptr inbounds [17 x i8], ptr @.str.5, i64 0, i64 0
  %r58 = ptrtoint ptr %r58.p to i64
  %r59 = load i64, ptr %slot.t3, align 8
  %r60 = load i64, ptr %slot.t0, align 8
  %r61 = sub i64 %r59, %r60
  %r62 = add i64 1000000, 0
  %r63 = sdiv i64 %r61, %r62
  %r64 = call i64 @nova_rt_int_to_str(i64 %r63)
  %r65 = call i64 @nova_rt_str_concat(i64 %r58, i64 %r64)
  %r66.p = getelementptr inbounds [4 x i8], ptr @.str.6, i64 0, i64 0
  %r66 = ptrtoint ptr %r66.p to i64
  %r67 = call i64 @nova_rt_str_concat(i64 %r65, i64 %r66)
  %r68 = call i64 @nova_rt_print_any(i64 %r67)
  ret i64 %r68
}

define i64 @nova_main() nounwind {
entry:
  %r0 = call i64 @run()
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
@.str.0 = private unnamed_addr constant [17 x i8] c"fib(38)       = \00"
@.str.1 = private unnamed_addr constant [4 x i8] c"  (\00"
@.str.2 = private unnamed_addr constant [5 x i8] c" ms)\00"
@.str.3 = private unnamed_addr constant [17 x i8] c"sum(100M)     = \00"
@.str.4 = private unnamed_addr constant [17 x i8] c"primes(100K)  = \00"
@.str.5 = private unnamed_addr constant [17 x i8] c"TOTAL         = \00"
@.str.6 = private unnamed_addr constant [4 x i8] c" ms\00"
