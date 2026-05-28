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

define i64 @nova_main() nounwind {
entry:
  %slot.nums = alloca i64, align 8
  store i64 0, ptr %slot.nums, align 8
  %slot.total = alloca i64, align 8
  store i64 0, ptr %slot.total, align 8
  %slot.i = alloca i64, align 8
  store i64 0, ptr %slot.i, align 8
  %r1 = add i64 1, 0
  %r2 = add i64 2, 0
  %r3 = add i64 3, 0
  %r4 = add i64 4, 0
  %r5 = add i64 5, 0
  %r0 = call i64 @nova_rt_list_create()
  call i64 @nova_rt_list_append(i64 %r0, i64 %r1)
  call i64 @nova_rt_list_append(i64 %r0, i64 %r2)
  call i64 @nova_rt_list_append(i64 %r0, i64 %r3)
  call i64 @nova_rt_list_append(i64 %r0, i64 %r4)
  call i64 @nova_rt_list_append(i64 %r0, i64 %r5)
  store i64 %r0, ptr %slot.nums, align 8
  %r6 = load i64, ptr %slot.nums, align 8
  %r7 = call i64 @nova_rt_len_any(i64 %r6)
  %r8 = call i64 @nova_rt_print_any(i64 %r7)
  %r9 = load i64, ptr %slot.nums, align 8
  %r10 = add i64 0, 0
  %r11 = call i64 @nova_rt_index_get(i64 %r9, i64 %r10)
  %r12 = call i64 @nova_rt_print_any(i64 %r11)
  %r13 = load i64, ptr %slot.nums, align 8
  %r14 = add i64 4, 0
  %r15 = call i64 @nova_rt_index_get(i64 %r13, i64 %r14)
  %r16 = call i64 @nova_rt_print_any(i64 %r15)
  %r17 = add i64 0, 0
  store i64 %r17, ptr %slot.total, align 8
  %r18 = add i64 0, 0
  store i64 %r18, ptr %slot.i, align 8
  br label %while_hdr0
while_hdr0:
  %r19 = load i64, ptr %slot.i, align 8
  %r20 = load i64, ptr %slot.nums, align 8
  %r21 = call i64 @nova_rt_len_any(i64 %r20)
  %r22.cmp = icmp slt i64 %r19, %r21
  %r22 = zext i1 %r22.cmp to i64
  %br_while_body1 = icmp ne i64 %r22, 0
  br i1 %br_while_body1, label %while_body1, label %while_exit2
while_body1:
  %r23 = load i64, ptr %slot.total, align 8
  %r24 = load i64, ptr %slot.nums, align 8
  %r25 = load i64, ptr %slot.i, align 8
  %r26 = call i64 @nova_rt_index_get(i64 %r24, i64 %r25)
  %r27 = call i64 @nova_rt_add(i64 %r23, i64 %r26)
  store i64 %r27, ptr %slot.total, align 8
  %r28 = load i64, ptr %slot.i, align 8
  %r29 = add i64 1, 0
  %r30 = add i64 %r28, %r29
  store i64 %r30, ptr %slot.i, align 8
  br label %while_hdr0
while_exit2:
  %r31 = load i64, ptr %slot.total, align 8
  %r32 = call i64 @nova_rt_print_any(i64 %r31)
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
