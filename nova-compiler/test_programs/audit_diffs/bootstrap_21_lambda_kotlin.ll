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

define i64 @apply(i64 %p0, i64 %p1) nounwind {
entry:
  %slot.f = alloca i64, align 8
  store i64 %p0, ptr %slot.f, align 8
  %slot.x = alloca i64, align 8
  store i64 %p1, ptr %slot.x, align 8
  %r0 = load i64, ptr %slot.x, align 8
  %r2 = load i64, ptr %slot.f, align 8
  %r1.rec = inttoptr i64 %r2 to ptr
  %r1.fnraw = load i64, ptr %r1.rec, align 8
  %r1.fnptr = inttoptr i64 %r1.fnraw to ptr
  %r1 = call i64 %r1.fnptr(i64 %r2, i64 %r0)
  ret i64 %r1
}

define i64 @map_list(i64 %p0, i64 %p1) nounwind {
entry:
  %slot.items = alloca i64, align 8
  store i64 %p0, ptr %slot.items, align 8
  %slot.f = alloca i64, align 8
  store i64 %p1, ptr %slot.f, align 8
  %slot.result = alloca i64, align 8
  store i64 0, ptr %slot.result, align 8
  %slot.__for_idx_0 = alloca i64, align 8
  store i64 0, ptr %slot.__for_idx_0, align 8
  %slot.item = alloca i64, align 8
  store i64 0, ptr %slot.item, align 8
  %r0 = call i64 @nova_rt_list_create()
  store i64 %r0, ptr %slot.result, align 8
  %r1 = load i64, ptr %slot.items, align 8
  %r2 = call i64 @nova_rt_len_any(i64 %r1)
  %r3 = add i64 0, 0
  store i64 %r3, ptr %slot.__for_idx_0, align 8
  br label %for_hdr0
for_hdr0:
  %r4 = load i64, ptr %slot.__for_idx_0, align 8
  %r5.cmp = icmp slt i64 %r4, %r2
  %r5 = zext i1 %r5.cmp to i64
  %br_for_body1 = icmp ne i64 %r5, 0
  br i1 %br_for_body1, label %for_body1, label %for_exit2
for_body1:
  %r6 = call i64 @nova_rt_index_get(i64 %r1, i64 %r4)
  store i64 %r6, ptr %slot.item, align 8
  %r7 = load i64, ptr %slot.result, align 8
  %r8 = load i64, ptr %slot.item, align 8
  %r10 = load i64, ptr %slot.f, align 8
  %r9.rec = inttoptr i64 %r10 to ptr
  %r9.fnraw = load i64, ptr %r9.rec, align 8
  %r9.fnptr = inttoptr i64 %r9.fnraw to ptr
  %r9 = call i64 %r9.fnptr(i64 %r10, i64 %r8)
  %r11 = call i64 @nova_rt_list_append(i64 %r7, i64 %r9)
  %r12 = load i64, ptr %slot.__for_idx_0, align 8
  %r13 = add i64 1, 0
  %r14 = add i64 %r12, %r13
  store i64 %r14, ptr %slot.__for_idx_0, align 8
  br label %for_hdr0
for_exit2:
  %r15 = load i64, ptr %slot.result, align 8
  ret i64 %r15
}

define i64 @nova_main() nounwind {
entry:
  %slot.double = alloca i64, align 8
  store i64 0, ptr %slot.double, align 8
  %slot.offset = alloca i64, align 8
  store i64 0, ptr %slot.offset, align 8
  %slot.add_offset = alloca i64, align 8
  store i64 0, ptr %slot.add_offset, align 8
  %slot.nums = alloca i64, align 8
  store i64 0, ptr %slot.nums, align 8
  %slot.doubled = alloca i64, align 8
  store i64 0, ptr %slot.doubled, align 8
  %slot.greet = alloca i64, align 8
  store i64 0, ptr %slot.greet, align 8
  %r0.ptr = call ptr @nova_rt_struct_alloc(i64 8)
  %r0.tgep = getelementptr i64, ptr %r0.ptr, i64 0
  %r0.tfn = ptrtoint ptr @__tramp_0 to i64
  store i64 %r0.tfn, ptr %r0.tgep, align 8
  %r0 = ptrtoint ptr %r0.ptr to i64
  store i64 %r0, ptr %slot.double, align 8
  %r1 = load i64, ptr %slot.double, align 8
  %r2 = add i64 7, 0
  %r3 = call i64 @apply(i64 %r1, i64 %r2)
  %r4 = call i64 @nova_rt_print_any(i64 %r3)
  %r5 = add i64 100, 0
  store i64 %r5, ptr %slot.offset, align 8
  %r6 = load i64, ptr %slot.offset, align 8
  %r7.ptr = call ptr @nova_rt_struct_alloc(i64 16)
  %r7.tgep = getelementptr i64, ptr %r7.ptr, i64 0
  %r7.tfn = ptrtoint ptr @__tramp_1 to i64
  store i64 %r7.tfn, ptr %r7.tgep, align 8
  %r7.c0 = getelementptr i64, ptr %r7.ptr, i64 1
  store i64 %r6, ptr %r7.c0, align 8
  %r7 = ptrtoint ptr %r7.ptr to i64
  store i64 %r7, ptr %slot.add_offset, align 8
  %r8 = load i64, ptr %slot.add_offset, align 8
  %r9 = add i64 5, 0
  %r10 = call i64 @apply(i64 %r8, i64 %r9)
  %r11 = call i64 @nova_rt_print_any(i64 %r10)
  %r12.ptr = call ptr @nova_rt_struct_alloc(i64 8)
  %r12.tgep = getelementptr i64, ptr %r12.ptr, i64 0
  %r12.tfn = ptrtoint ptr @__tramp_2 to i64
  store i64 %r12.tfn, ptr %r12.tgep, align 8
  %r12 = ptrtoint ptr %r12.ptr to i64
  %r13 = add i64 10, 0
  %r14 = call i64 @apply(i64 %r12, i64 %r13)
  %r15 = call i64 @nova_rt_print_any(i64 %r14)
  %r17 = add i64 1, 0
  %r18 = add i64 2, 0
  %r19 = add i64 3, 0
  %r20 = add i64 4, 0
  %r21 = add i64 5, 0
  %r16 = call i64 @nova_rt_list_create()
  call i64 @nova_rt_list_append(i64 %r16, i64 %r17)
  call i64 @nova_rt_list_append(i64 %r16, i64 %r18)
  call i64 @nova_rt_list_append(i64 %r16, i64 %r19)
  call i64 @nova_rt_list_append(i64 %r16, i64 %r20)
  call i64 @nova_rt_list_append(i64 %r16, i64 %r21)
  store i64 %r16, ptr %slot.nums, align 8
  %r22 = load i64, ptr %slot.nums, align 8
  %r23.ptr = call ptr @nova_rt_struct_alloc(i64 8)
  %r23.tgep = getelementptr i64, ptr %r23.ptr, i64 0
  %r23.tfn = ptrtoint ptr @__tramp_3 to i64
  store i64 %r23.tfn, ptr %r23.tgep, align 8
  %r23 = ptrtoint ptr %r23.ptr to i64
  %r24 = call i64 @map_list(i64 %r22, i64 %r23)
  store i64 %r24, ptr %slot.doubled, align 8
  %r25 = load i64, ptr %slot.doubled, align 8
  %r26 = add i64 0, 0
  %r27 = call i64 @nova_rt_index_get(i64 %r25, i64 %r26)
  %r28 = call i64 @nova_rt_print_any(i64 %r27)
  %r29 = load i64, ptr %slot.doubled, align 8
  %r30 = add i64 4, 0
  %r31 = call i64 @nova_rt_index_get(i64 %r29, i64 %r30)
  %r32 = call i64 @nova_rt_print_any(i64 %r31)
  %r33.ptr = call ptr @nova_rt_struct_alloc(i64 8)
  %r33.tgep = getelementptr i64, ptr %r33.ptr, i64 0
  %r33.tfn = ptrtoint ptr @__tramp_4 to i64
  store i64 %r33.tfn, ptr %r33.tgep, align 8
  %r33 = ptrtoint ptr %r33.ptr to i64
  store i64 %r33, ptr %slot.greet, align 8
  %r34.p = getelementptr inbounds [5 x i8], ptr @.str.0, i64 0, i64 0
  %r34 = ptrtoint ptr %r34.p to i64
  %r36 = load i64, ptr %slot.greet, align 8
  %r35.rec = inttoptr i64 %r36 to ptr
  %r35.fnraw = load i64, ptr %r35.rec, align 8
  %r35.fnptr = inttoptr i64 %r35.fnraw to ptr
  %r35 = call i64 %r35.fnptr(i64 %r36, i64 %r34)
  %r37 = call i64 @nova_rt_print_any(i64 %r35)
  ret i64 0
}

define i64 @__lambda_0(i64 %p0) nounwind {
entry:
  %slot.x = alloca i64, align 8
  store i64 %p0, ptr %slot.x, align 8
  %r0 = load i64, ptr %slot.x, align 8
  %r1 = add i64 2, 0
  %r2 = mul i64 %r0, %r1
  ret i64 %r2
}

define i64 @__lambda_1(i64 %p0, i64 %p1) nounwind {
entry:
  %slot.offset = alloca i64, align 8
  store i64 %p0, ptr %slot.offset, align 8
  %slot.x = alloca i64, align 8
  store i64 %p1, ptr %slot.x, align 8
  %r0 = load i64, ptr %slot.x, align 8
  %r1 = load i64, ptr %slot.offset, align 8
  %r2 = call i64 @nova_rt_add(i64 %r0, i64 %r1)
  ret i64 %r2
}

define i64 @__lambda_2(i64 %p0) nounwind {
entry:
  %slot.x = alloca i64, align 8
  store i64 %p0, ptr %slot.x, align 8
  %r0 = load i64, ptr %slot.x, align 8
  %r1 = add i64 1, 0
  %r2 = call i64 @nova_rt_add(i64 %r0, i64 %r1)
  ret i64 %r2
}

define i64 @__lambda_3(i64 %p0) nounwind {
entry:
  %slot.x = alloca i64, align 8
  store i64 %p0, ptr %slot.x, align 8
  %r0 = load i64, ptr %slot.x, align 8
  %r1 = add i64 2, 0
  %r2 = mul i64 %r0, %r1
  ret i64 %r2
}

define i64 @__lambda_4(i64 %p0) nounwind {
entry:
  %slot.name = alloca i64, align 8
  store i64 %p0, ptr %slot.name, align 8
  %r0.p = getelementptr inbounds [4 x i8], ptr @.str.1, i64 0, i64 0
  %r0 = ptrtoint ptr %r0.p to i64
  %r1 = load i64, ptr %slot.name, align 8
  %r2 = call i64 @nova_rt_str_concat(i64 %r0, i64 %r1)
  ret i64 %r2
}

define i64 @__tramp_0(i64 %record, i64 %p0) nounwind {
entry:
  %result = call i64 @__lambda_0(i64 %p0)
  ret i64 %result
}

define i64 @__tramp_1(i64 %record, i64 %p0) nounwind {
entry:
  %rec_ptr = inttoptr i64 %record to ptr
  %cap0_ptr = getelementptr i64, ptr %rec_ptr, i64 1
  %cap0 = load i64, ptr %cap0_ptr, align 8
  %result = call i64 @__lambda_1(i64 %cap0, i64 %p0)
  ret i64 %result
}

define i64 @__tramp_2(i64 %record, i64 %p0) nounwind {
entry:
  %result = call i64 @__lambda_2(i64 %p0)
  ret i64 %result
}

define i64 @__tramp_3(i64 %record, i64 %p0) nounwind {
entry:
  %result = call i64 @__lambda_3(i64 %p0)
  ret i64 %result
}

define i64 @__tramp_4(i64 %record, i64 %p0) nounwind {
entry:
  %result = call i64 @__lambda_4(i64 %p0)
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

; String constants
@.str.0 = private unnamed_addr constant [5 x i8] c"nova\00"
@.str.1 = private unnamed_addr constant [4 x i8] c"hi \00"
