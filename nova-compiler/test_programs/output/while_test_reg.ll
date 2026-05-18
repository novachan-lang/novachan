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

define i64 @sumTo(i64 %p0) nounwind {
entry:
  %slot.n = alloca i64, align 8
  store i64 %p0, ptr %slot.n, align 8
  %slot.total = alloca i64, align 8
  store i64 0, ptr %slot.total, align 8
  %slot.i = alloca i64, align 8
  store i64 0, ptr %slot.i, align 8
  %r0 = add i64 0, 0
  store i64 %r0, ptr %slot.total, align 8
  %r1 = add i64 1, 0
  store i64 %r1, ptr %slot.i, align 8
  br label %while_hdr0
while_hdr0:
  %r2 = load i64, ptr %slot.i, align 8
  %r3 = load i64, ptr %slot.n, align 8
  %r4.cmp = icmp sle i64 %r2, %r3
  %r4 = zext i1 %r4.cmp to i64
  %br_while_body1 = icmp ne i64 %r4, 0
  br i1 %br_while_body1, label %while_body1, label %while_exit2
while_body1:
  br label %while_hdr0
while_exit2:
  %r5 = load i64, ptr %slot.total, align 8
  ret i64 %r5
}

define i64 @countdown(i64 %p0) nounwind {
entry:
  %slot.n = alloca i64, align 8
  store i64 %p0, ptr %slot.n, align 8
  br label %while_hdr3
while_hdr3:
  %r0 = load i64, ptr %slot.n, align 8
  %r1 = add i64 0, 0
  %r2.cmp = icmp sgt i64 %r0, %r1
  %r2 = zext i1 %r2.cmp to i64
  %br_while_body4 = icmp ne i64 %r2, 0
  br i1 %br_while_body4, label %while_body4, label %while_exit5
while_body4:
  %r3 = load i64, ptr %slot.n, align 8
  %r4 = call i64 @nova_rt_print_any(i64 %r3)
  br label %while_hdr3
while_exit5:
  %r5 = add i64 0, 0
  %r6 = call i64 @nova_rt_print_any(i64 %r5)
  ret i64 %r6
}

define i64 @collatzSteps(i64 %p0) nounwind {
entry:
  %slot.n = alloca i64, align 8
  store i64 %p0, ptr %slot.n, align 8
  %slot.steps = alloca i64, align 8
  store i64 0, ptr %slot.steps, align 8
  %r0 = add i64 0, 0
  store i64 %r0, ptr %slot.steps, align 8
  br label %while_hdr6
while_hdr6:
  %r1 = load i64, ptr %slot.n, align 8
  %r2 = add i64 1, 0
  %r3 = call i64 @nova_rt_neq(i64 %r1, i64 %r2)
  %br_while_body7 = icmp ne i64 %r3, 0
  br i1 %br_while_body7, label %while_body7, label %while_exit8
while_body7:
  %r4 = load i64, ptr %slot.n, align 8
  %r5 = add i64 2, 0
  %r6 = srem i64 %r4, %r5
  %r7 = add i64 0, 0
  %r8 = call i64 @nova_rt_eq(i64 %r6, i64 %r7)
  %br_then9 = icmp ne i64 %r8, 0
  br i1 %br_then9, label %then9, label %else10
then9:
  %r9 = load i64, ptr %slot.n, align 8
  %r10 = add i64 2, 0
  %r11 = sdiv i64 %r9, %r10
  store i64 %r11, ptr %slot.n, align 8
  br label %endif11
else10:
  %r12 = load i64, ptr %slot.n, align 8
  %r13 = add i64 3, 0
  %r14 = mul i64 %r12, %r13
  %r15 = add i64 1, 0
  %r16 = call i64 @nova_rt_add(i64 %r14, i64 %r15)
  store i64 %r16, ptr %slot.n, align 8
  br label %endif11
endif11:
  br label %while_hdr6
while_exit8:
  %r17 = load i64, ptr %slot.steps, align 8
  ret i64 %r17
}

define i64 @nova_main() nounwind {
entry:
  %r0 = add i64 100, 0
  %r1 = call i64 @sumTo(i64 %r0)
  %r2 = call i64 @nova_rt_print_any(i64 %r1)
  %r3 = add i64 5, 0
  %r4 = call i64 @countdown(i64 %r3)
  %r5 = add i64 27, 0
  %r6 = call i64 @collatzSteps(i64 %r5)
  %r7 = call i64 @nova_rt_print_any(i64 %r6)
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
