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

define i64 @sum_list(i64 %p0) nounwind {
entry:
  %slot.items = alloca i64, align 8
  store i64 %p0, ptr %slot.items, align 8
  %slot.total = alloca i64, align 8
  store i64 0, ptr %slot.total, align 8
  %slot.x = alloca i64, align 8
  store i64 0, ptr %slot.x, align 8
  store i64 0, ptr %slot.total, align 8
  %r0 = load i64, ptr %slot.items, align 8
  %r1 = call i64 @nova_rt_len_any(i64 %r0)
  %slot.__for_idx_0 = alloca i64, align 8
  store i64 0, ptr %slot.__for_idx_0, align 8
  br label %for_hdr0
for_hdr0:
  %r2 = load i64, ptr %slot.__for_idx_0, align 8
  %t3 = icmp slt i64 %r2, %r1
  br i1 %t3, label %for_body1, label %for_exit2
for_body1:
  %r4 = call i64 @nova_rt_index_get(i64 %r0, i64 %r2)
  store i64 %r4, ptr %slot.x, align 8
  %r5 = load i64, ptr %slot.total, align 8
  %r6 = load i64, ptr %slot.x, align 8
  %r7 = call i64 @nova_rt_add(i64 %r5, i64 %r6)
  store i64 %r7, ptr %slot.total, align 8
  %r9 = load i64, ptr %slot.__for_idx_0, align 8
  %r8 = add i64 %r9, 1
  store i64 %r8, ptr %slot.__for_idx_0, align 8
  br label %for_hdr0
for_exit2:
  %r10 = load i64, ptr %slot.total, align 8
  ret i64 %r10
}

define i64 @make_range(i64 %p0) nounwind {
entry:
  %slot.n = alloca i64, align 8
  store i64 %p0, ptr %slot.n, align 8
  %slot.result = alloca i64, align 8
  store i64 0, ptr %slot.result, align 8
  %slot.i = alloca i64, align 8
  store i64 0, ptr %slot.i, align 8
  %r0 = call i64 @nova_rt_list_create()
  store i64 %r0, ptr %slot.result, align 8
  store i64 0, ptr %slot.i, align 8
  br label %while_hdr3
while_hdr3:
  %r1 = load i64, ptr %slot.i, align 8
  %r2 = load i64, ptr %slot.n, align 8
  %t4 = icmp slt i64 %r1, %r2
  %r3 = zext i1 %t4 to i64
  %t5 = icmp ne i64 %r3, 0
  br i1 %t5, label %while_body4, label %while_exit5
while_body4:
  %r6 = load i64, ptr %slot.result, align 8
  %r7 = load i64, ptr %slot.i, align 8
  %r8 = call i64 @nova_rt_list_append(i64 %r6, i64 %r7)
  %r9 = load i64, ptr %slot.i, align 8
  %r10 = call i64 @nova_rt_add(i64 %r9, i64 1)
  store i64 %r10, ptr %slot.i, align 8
  br label %while_hdr3
while_exit5:
  %r11 = load i64, ptr %slot.result, align 8
  ret i64 %r11
}

define i64 @nova_main() nounwind {
entry:
  %slot.nums = alloca i64, align 8
  store i64 0, ptr %slot.nums, align 8
  %slot.words = alloca i64, align 8
  store i64 0, ptr %slot.words, align 8
  %slot.w = alloca i64, align 8
  store i64 0, ptr %slot.w, align 8
  %r0 = call i64 @make_range(i64 10)
  store i64 %r0, ptr %slot.nums, align 8
  %r1 = load i64, ptr %slot.nums, align 8
  %r2 = call i64 @nova_rt_len_any(i64 %r1)
  %r3 = call i64 @nova_rt_print_any(i64 %r2)
  %r4 = load i64, ptr %slot.nums, align 8
  %r5 = call i64 @sum_list(i64 %r4)
  %r6 = call i64 @nova_rt_print_any(i64 %r5)
  %r7 = call i64 @nova_rt_list_create()
  %r8 = getelementptr inbounds [6 x i8], ptr @.str.0, i64 0, i64 0
  %r9 = ptrtoint ptr %r8 to i64
  %t10 = call i64 @nova_rt_list_append(i64 %r7, i64 %r9)
  %r11 = getelementptr inbounds [6 x i8], ptr @.str.1, i64 0, i64 0
  %r12 = ptrtoint ptr %r11 to i64
  %t13 = call i64 @nova_rt_list_append(i64 %r7, i64 %r12)
  %r14 = getelementptr inbounds [5 x i8], ptr @.str.2, i64 0, i64 0
  %r15 = ptrtoint ptr %r14 to i64
  %t16 = call i64 @nova_rt_list_append(i64 %r7, i64 %r15)
  store i64 %r7, ptr %slot.words, align 8
  %r17 = load i64, ptr %slot.words, align 8
  %r18 = call i64 @nova_rt_len_any(i64 %r17)
  %slot.__for_idx_6 = alloca i64, align 8
  store i64 0, ptr %slot.__for_idx_6, align 8
  br label %for_hdr6
for_hdr6:
  %r19 = load i64, ptr %slot.__for_idx_6, align 8
  %t20 = icmp slt i64 %r19, %r18
  br i1 %t20, label %for_body7, label %for_exit8
for_body7:
  %r21 = call i64 @nova_rt_index_get(i64 %r17, i64 %r19)
  store i64 %r21, ptr %slot.w, align 8
  %r22 = load i64, ptr %slot.w, align 8
  %r23 = call i64 @nova_rt_print_any(i64 %r22)
  %r25 = load i64, ptr %slot.__for_idx_6, align 8
  %r24 = add i64 %r25, 1
  store i64 %r24, ptr %slot.__for_idx_6, align 8
  br label %for_hdr6
for_exit8:
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
@.str.0 = private unnamed_addr constant [6 x i8] c"hello\00"
@.str.1 = private unnamed_addr constant [6 x i8] c"world\00"
@.str.2 = private unnamed_addr constant [5 x i8] c"nova\00"
