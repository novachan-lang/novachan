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

define i64 @is_prime(i64 %p0) nounwind {
entry:
  %slot.n = alloca i64, align 8
  store i64 %p0, ptr %slot.n, align 8
  %slot.d = alloca i64, align 8
  store i64 0, ptr %slot.d, align 8
  %r0 = load i64, ptr %slot.n, align 8
  %r1 = add i64 2, 0
  %r2.cmp = icmp slt i64 %r0, %r1
  %r2 = zext i1 %r2.cmp to i64
  %br_then0 = icmp ne i64 %r2, 0
  br i1 %br_then0, label %then0, label %else1
then0:
  %r3 = add i64 0, 0
  ret i64 %r3
else1:
  br label %endif2
endif2:
  %r4 = load i64, ptr %slot.n, align 8
  %r5 = add i64 2, 0
  %r6 = call i64 @nova_rt_eq(i64 %r4, i64 %r5)
  %br_then3 = icmp ne i64 %r6, 0
  br i1 %br_then3, label %then3, label %else4
then3:
  %r7 = add i64 1, 0
  ret i64 %r7
else4:
  br label %endif5
endif5:
  %r8 = load i64, ptr %slot.n, align 8
  %r9 = add i64 2, 0
  %r10 = srem i64 %r8, %r9
  %r11 = add i64 0, 0
  %r12.cmp = icmp eq i64 %r10, %r11
  %r12 = zext i1 %r12.cmp to i64
  %br_then6 = icmp ne i64 %r12, 0
  br i1 %br_then6, label %then6, label %else7
then6:
  %r13 = add i64 0, 0
  ret i64 %r13
else7:
  br label %endif8
endif8:
  %r14 = add i64 3, 0
  store i64 %r14, ptr %slot.d, align 8
  br label %while_hdr9
while_hdr9:
  %r15 = load i64, ptr %slot.d, align 8
  %r16 = load i64, ptr %slot.d, align 8
  %r17 = mul i64 %r15, %r16
  %r18 = load i64, ptr %slot.n, align 8
  %r19.cmp = icmp sle i64 %r17, %r18
  %r19 = zext i1 %r19.cmp to i64
  %br_while_body10 = icmp ne i64 %r19, 0
  br i1 %br_while_body10, label %while_body10, label %while_exit11
while_body10:
  %r20 = load i64, ptr %slot.n, align 8
  %r21 = load i64, ptr %slot.d, align 8
  %r22 = srem i64 %r20, %r21
  %r23 = add i64 0, 0
  %r24.cmp = icmp eq i64 %r22, %r23
  %r24 = zext i1 %r24.cmp to i64
  %br_then12 = icmp ne i64 %r24, 0
  br i1 %br_then12, label %then12, label %else13
then12:
  %r25 = add i64 0, 0
  ret i64 %r25
else13:
  br label %endif14
endif14:
  %r26 = load i64, ptr %slot.d, align 8
  %r27 = add i64 2, 0
  %r28 = add i64 %r26, %r27
  store i64 %r28, ptr %slot.d, align 8
  br label %while_hdr9
while_exit11:
  %r29 = add i64 1, 0
  ret i64 %r29
}

define i64 @nova_main() nounwind {
entry:
  %slot.count = alloca i64, align 8
  store i64 0, ptr %slot.count, align 8
  %slot.n = alloca i64, align 8
  store i64 0, ptr %slot.n, align 8
  %r0 = add i64 0, 0
  store i64 %r0, ptr %slot.count, align 8
  %r1 = add i64 2, 0
  store i64 %r1, ptr %slot.n, align 8
  br label %while_hdr15
while_hdr15:
  %r2 = load i64, ptr %slot.n, align 8
  %r3 = add i64 1000000, 0
  %r4.cmp = icmp sle i64 %r2, %r3
  %r4 = zext i1 %r4.cmp to i64
  %br_while_body16 = icmp ne i64 %r4, 0
  br i1 %br_while_body16, label %while_body16, label %while_exit17
while_body16:
  %r5 = load i64, ptr %slot.n, align 8
  %r6 = call i64 @is_prime(i64 %r5)
  %br_then18 = icmp ne i64 %r6, 0
  br i1 %br_then18, label %then18, label %else19
then18:
  %r7 = load i64, ptr %slot.count, align 8
  %r8 = add i64 1, 0
  %r9 = add i64 %r7, %r8
  store i64 %r9, ptr %slot.count, align 8
  br label %endif20
else19:
  br label %endif20
endif20:
  %r10 = load i64, ptr %slot.n, align 8
  %r11 = add i64 1, 0
  %r12 = add i64 %r10, %r11
  store i64 %r12, ptr %slot.n, align 8
  br label %while_hdr15
while_exit17:
  %r13.p = getelementptr inbounds [25 x i8], ptr @.str.0, i64 0, i64 0
  %r13 = ptrtoint ptr %r13.p to i64
  %r14 = load i64, ptr %slot.count, align 8
  %r15 = call i64 @nova_rt_int_to_str(i64 %r14)
  %r16 = call i64 @nova_rt_str_concat(i64 %r13, i64 %r15)
  %r17 = call i64 @nova_rt_print_any(i64 %r16)
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
@.str.0 = private unnamed_addr constant [25 x i8] c"Primes 1-1000000 (seq): \00"
