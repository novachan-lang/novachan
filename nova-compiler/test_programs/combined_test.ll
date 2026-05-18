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

define i64 @makeAdder(i64 %p0) nounwind {
entry:
  %slot.n = alloca i64, align 8
  store i64 %p0, ptr %slot.n, align 8
  %r0 = load i64, ptr %slot.n, align 8
  %r1.ptr = call ptr @nova_rt_struct_alloc(i64 16)
  %r1.tgep = getelementptr i64, ptr %r1.ptr, i64 0
  %r1.tfn = ptrtoint ptr @__tramp_0 to i64
  store i64 %r1.tfn, ptr %r1.tgep, align 8
  %r1.c0 = getelementptr i64, ptr %r1.ptr, i64 1
  store i64 %r0, ptr %r1.c0, align 8
  %r1 = ptrtoint ptr %r1.ptr to i64
  ret i64 %r1
}

define i64 @getSquarer() nounwind {
entry:
  %r0.ptr = call ptr @nova_rt_struct_alloc(i64 8)
  %r0.tgep = getelementptr i64, ptr %r0.ptr, i64 0
  %r0.tfn = ptrtoint ptr @__tramp_1 to i64
  store i64 %r0.tfn, ptr %r0.tgep, align 8
  %r0 = ptrtoint ptr %r0.ptr to i64
  ret i64 %r0
}

define i64 @__lambda_0(i64 %p0, i64 %p1) nounwind {
entry:
  %slot.n = alloca i64, align 8
  store i64 %p0, ptr %slot.n, align 8
  %slot.x = alloca i64, align 8
  store i64 %p1, ptr %slot.x, align 8
  %r0 = load i64, ptr %slot.x, align 8
  %r1 = load i64, ptr %slot.n, align 8
  %r2 = call i64 @nova_rt_add(i64 %r0, i64 %r1)
  ret i64 %r2
}

define i64 @__lambda_1(i64 %p0) nounwind {
entry:
  %slot.x = alloca i64, align 8
  store i64 %p0, ptr %slot.x, align 8
  %r0 = load i64, ptr %slot.x, align 8
  %r1 = load i64, ptr %slot.x, align 8
  %r2 = mul i64 %r0, %r1
  ret i64 %r2
}

define i64 @nova_main() nounwind {
entry:
  %slot.nums = alloca i64, align 8
  store i64 0, ptr %slot.nums, align 8
  %slot.add10 = alloca i64, align 8
  store i64 0, ptr %slot.add10, align 8
  %slot.sq = alloca i64, align 8
  store i64 0, ptr %slot.sq, align 8
  %slot.__for_idx_0 = alloca i64, align 8
  store i64 0, ptr %slot.__for_idx_0, align 8
  %slot.n = alloca i64, align 8
  store i64 0, ptr %slot.n, align 8
  %slot.__for_idx_3 = alloca i64, align 8
  store i64 0, ptr %slot.__for_idx_3, align 8
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
  %r6 = add i64 10, 0
  %r7 = call i64 @makeAdder(i64 %r6)
  store i64 %r7, ptr %slot.add10, align 8
  %r8 = call i64 @getSquarer()
  store i64 %r8, ptr %slot.sq, align 8
  %r9 = load i64, ptr %slot.nums, align 8
  %r10 = call i64 @nova_rt_len_any(i64 %r9)
  %r11 = add i64 0, 0
  store i64 %r11, ptr %slot.__for_idx_0, align 8
  br label %for_hdr0
for_hdr0:
  %r12 = load i64, ptr %slot.__for_idx_0, align 8
  %r13.cmp = icmp slt i64 %r12, %r10
  %r13 = zext i1 %r13.cmp to i64
  %br_for_body1 = icmp ne i64 %r13, 0
  br i1 %br_for_body1, label %for_body1, label %for_exit2
for_body1:
  %r14 = call i64 @nova_rt_index_get(i64 %r9, i64 %r12)
  store i64 %r14, ptr %slot.n, align 8
  %r15 = load i64, ptr %slot.n, align 8
  %r17 = load i64, ptr %slot.add10, align 8
  %r16.rec = inttoptr i64 %r17 to ptr
  %r16.fnraw = load i64, ptr %r16.rec, align 8
  %r16.fnptr = inttoptr i64 %r16.fnraw to ptr
  %r16 = call i64 %r16.fnptr(i64 %r17, i64 %r15)
  %r18 = call i64 @nova_rt_print_any(i64 %r16)
  %r19 = load i64, ptr %slot.__for_idx_0, align 8
  %r20 = add i64 1, 0
  %r21 = call i64 @nova_rt_add(i64 %r19, i64 %r20)
  store i64 %r21, ptr %slot.__for_idx_0, align 8
  br label %for_hdr0
for_exit2:
  %r22 = load i64, ptr %slot.nums, align 8
  %r23 = call i64 @nova_rt_len_any(i64 %r22)
  %r24 = add i64 0, 0
  store i64 %r24, ptr %slot.__for_idx_3, align 8
  br label %for_hdr3
for_hdr3:
  %r25 = load i64, ptr %slot.__for_idx_3, align 8
  %r26.cmp = icmp slt i64 %r25, %r23
  %r26 = zext i1 %r26.cmp to i64
  %br_for_body4 = icmp ne i64 %r26, 0
  br i1 %br_for_body4, label %for_body4, label %for_exit5
for_body4:
  %r27 = call i64 @nova_rt_index_get(i64 %r22, i64 %r25)
  store i64 %r27, ptr %slot.n, align 8
  %r28 = load i64, ptr %slot.n, align 8
  %r30 = load i64, ptr %slot.sq, align 8
  %r29.rec = inttoptr i64 %r30 to ptr
  %r29.fnraw = load i64, ptr %r29.rec, align 8
  %r29.fnptr = inttoptr i64 %r29.fnraw to ptr
  %r29 = call i64 %r29.fnptr(i64 %r30, i64 %r28)
  %r31 = call i64 @nova_rt_print_any(i64 %r29)
  %r32 = load i64, ptr %slot.__for_idx_3, align 8
  %r33 = add i64 1, 0
  %r34 = call i64 @nova_rt_add(i64 %r32, i64 %r33)
  store i64 %r34, ptr %slot.__for_idx_3, align 8
  br label %for_hdr3
for_exit5:
  ret i64 0
}

define i64 @__tramp_0(i64 %record, i64 %p0) nounwind {
entry:
  %rec_ptr = inttoptr i64 %record to ptr
  %cap0_ptr = getelementptr i64, ptr %rec_ptr, i64 1
  %cap0 = load i64, ptr %cap0_ptr, align 8
  %result = call i64 @__lambda_0(i64 %cap0, i64 %p0)
  ret i64 %result
}

define i64 @__tramp_1(i64 %record, i64 %p0) nounwind {
entry:
  %result = call i64 @__lambda_1(i64 %p0)
  ret i64 %result
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
