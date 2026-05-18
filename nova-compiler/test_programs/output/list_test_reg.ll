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
declare i64 @nova_rt_system(i64) nounwind
declare i64 @nova_rt_exec(i64) nounwind
declare i64 @nova_rt_create_string(ptr) nounwind
declare void @nova_rt_init_args(i64, i64) nounwind
declare void @nova_rt_cleanup() nounwind

define i64 @sumList(i64 %p0, i64 %p1) nounwind {
entry:
  %slot.nums = alloca i64, align 8
  store i64 %p0, ptr %slot.nums, align 8
  %slot.n = alloca i64, align 8
  store i64 %p1, ptr %slot.n, align 8
  %slot.total = alloca i64, align 8
  store i64 0, ptr %slot.total, align 8
  %slot.i = alloca i64, align 8
  store i64 0, ptr %slot.i, align 8
  %r0 = add i64 0, 0
  store i64 %r0, ptr %slot.total, align 8
  %r1 = add i64 0, 0
  store i64 %r1, ptr %slot.i, align 8
  br label %while_hdr0
while_hdr0:
  %r2 = load i64, ptr %slot.i, align 8
  %r3 = load i64, ptr %slot.n, align 8
  %r4.cmp = icmp slt i64 %r2, %r3
  %r4 = zext i1 %r4.cmp to i64
  %br_while_body1 = icmp ne i64 %r4, 0
  br i1 %br_while_body1, label %while_body1, label %while_exit2
while_body1:
  br label %while_hdr0
while_exit2:
  %r5 = load i64, ptr %slot.total, align 8
  ret i64 %r5
}

define i64 @maxInList(i64 %p0, i64 %p1) nounwind {
entry:
  %slot.nums = alloca i64, align 8
  store i64 %p0, ptr %slot.nums, align 8
  %slot.n = alloca i64, align 8
  store i64 %p1, ptr %slot.n, align 8
  %slot.best = alloca i64, align 8
  store i64 0, ptr %slot.best, align 8
  %slot.i = alloca i64, align 8
  store i64 0, ptr %slot.i, align 8
  %r0 = load i64, ptr %slot.nums, align 8
  %r1 = add i64 0, 0
  %r2 = call i64 @nova_rt_index_get(i64 %r0, i64 %r1)
  store i64 %r2, ptr %slot.best, align 8
  %r3 = add i64 1, 0
  store i64 %r3, ptr %slot.i, align 8
  br label %while_hdr3
while_hdr3:
  %r4 = load i64, ptr %slot.i, align 8
  %r5 = load i64, ptr %slot.n, align 8
  %r6.cmp = icmp slt i64 %r4, %r5
  %r6 = zext i1 %r6.cmp to i64
  %br_while_body4 = icmp ne i64 %r6, 0
  br i1 %br_while_body4, label %while_body4, label %while_exit5
while_body4:
  %r7 = load i64, ptr %slot.nums, align 8
  %r8 = load i64, ptr %slot.i, align 8
  %r9 = call i64 @nova_rt_index_get(i64 %r7, i64 %r8)
  %r10 = load i64, ptr %slot.best, align 8
  %r11.cmp = icmp sgt i64 %r9, %r10
  %r11 = zext i1 %r11.cmp to i64
  %br_then6 = icmp ne i64 %r11, 0
  br i1 %br_then6, label %then6, label %else7
then6:
  %r12 = load i64, ptr %slot.nums, align 8
  %r13 = load i64, ptr %slot.i, align 8
  %r14 = call i64 @nova_rt_index_get(i64 %r12, i64 %r13)
  store i64 %r14, ptr %slot.best, align 8
  br label %endif8
else7:
  br label %endif8
endif8:
  br label %while_hdr3
while_exit5:
  %r15 = load i64, ptr %slot.best, align 8
  ret i64 %r15
}

define i64 @nova_main() nounwind {
entry:
  %slot.nums = alloca i64, align 8
  store i64 0, ptr %slot.nums, align 8
  %slot.primes = alloca i64, align 8
  store i64 0, ptr %slot.primes, align 8
  %r1 = add i64 10, 0
  %r2 = add i64 20, 0
  %r3 = add i64 30, 0
  %r4 = add i64 40, 0
  %r5 = add i64 50, 0
  %r0 = call i64 @nova_rt_list_create()
  call i64 @nova_rt_list_append(i64 %r0, i64 %r1)
  call i64 @nova_rt_list_append(i64 %r0, i64 %r2)
  call i64 @nova_rt_list_append(i64 %r0, i64 %r3)
  call i64 @nova_rt_list_append(i64 %r0, i64 %r4)
  call i64 @nova_rt_list_append(i64 %r0, i64 %r5)
  store i64 %r0, ptr %slot.nums, align 8
  %r6 = load i64, ptr %slot.nums, align 8
  %r7 = add i64 0, 0
  %r8 = call i64 @nova_rt_index_get(i64 %r6, i64 %r7)
  %r9 = call i64 @nova_rt_print_any(i64 %r8)
  %r10 = load i64, ptr %slot.nums, align 8
  %r11 = add i64 2, 0
  %r12 = call i64 @nova_rt_index_get(i64 %r10, i64 %r11)
  %r13 = call i64 @nova_rt_print_any(i64 %r12)
  %r14 = load i64, ptr %slot.nums, align 8
  %r15 = add i64 4, 0
  %r16 = call i64 @nova_rt_index_get(i64 %r14, i64 %r15)
  %r17 = call i64 @nova_rt_print_any(i64 %r16)
  %r18 = load i64, ptr %slot.nums, align 8
  %r19 = call i64 @nova_rt_len_any(i64 %r18)
  %r20 = call i64 @nova_rt_print_any(i64 %r19)
  %r21 = load i64, ptr %slot.nums, align 8
  %r22 = add i64 5, 0
  %r23 = call i64 @sumList(i64 %r21, i64 %r22)
  %r24 = call i64 @nova_rt_print_any(i64 %r23)
  %r25 = load i64, ptr %slot.nums, align 8
  %r26 = add i64 5, 0
  %r27 = call i64 @maxInList(i64 %r25, i64 %r26)
  %r28 = call i64 @nova_rt_print_any(i64 %r27)
  %r30 = add i64 2, 0
  %r31 = add i64 3, 0
  %r32 = add i64 5, 0
  %r33 = add i64 7, 0
  %r34 = add i64 11, 0
  %r35 = add i64 13, 0
  %r29 = call i64 @nova_rt_list_create()
  call i64 @nova_rt_list_append(i64 %r29, i64 %r30)
  call i64 @nova_rt_list_append(i64 %r29, i64 %r31)
  call i64 @nova_rt_list_append(i64 %r29, i64 %r32)
  call i64 @nova_rt_list_append(i64 %r29, i64 %r33)
  call i64 @nova_rt_list_append(i64 %r29, i64 %r34)
  call i64 @nova_rt_list_append(i64 %r29, i64 %r35)
  store i64 %r29, ptr %slot.primes, align 8
  %r36 = load i64, ptr %slot.primes, align 8
  %r37 = add i64 0, 0
  %r38 = call i64 @nova_rt_index_get(i64 %r36, i64 %r37)
  %r39 = call i64 @nova_rt_print_any(i64 %r38)
  %r40 = load i64, ptr %slot.primes, align 8
  %r41 = add i64 5, 0
  %r42 = call i64 @nova_rt_index_get(i64 %r40, i64 %r41)
  %r43 = call i64 @nova_rt_print_any(i64 %r42)
  %r44 = load i64, ptr %slot.primes, align 8
  %r45 = call i64 @nova_rt_len_any(i64 %r44)
  %r46 = call i64 @nova_rt_print_any(i64 %r45)
  %r47 = load i64, ptr %slot.primes, align 8
  %r48 = add i64 6, 0
  %r49 = call i64 @sumList(i64 %r47, i64 %r48)
  %r50 = call i64 @nova_rt_print_any(i64 %r49)
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
