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
declare i64 @nova_rt_dict_keys(i64) nounwind
declare i64 @nova_rt_dict_values(i64) nounwind
declare i64 @nova_rt_dict_items(i64) nounwind
declare i64 @nova_rt_dict_has(i64, i64) nounwind
declare i64 @nova_rt_dict_del(i64, i64) nounwind
declare i64 @nova_rt_system(i64) nounwind
declare i64 @nova_rt_exec(i64) nounwind
declare i64 @nova_rt_create_string(ptr) nounwind
declare void @nova_rt_init_args(i64, i64) nounwind
declare void @nova_rt_wait_all() nounwind
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

define i64 @double(i64 %p0) nounwind {
entry:
  %slot.n = alloca i64, align 8
  store i64 %p0, ptr %slot.n, align 8
  %r0 = load i64, ptr %slot.n, align 8
  %r1 = add i64 2, 0
  %r2 = mul i64 %r0, %r1
  ret i64 %r2
}

define i64 @square(i64 %p0) nounwind {
entry:
  %slot.n = alloca i64, align 8
  store i64 %p0, ptr %slot.n, align 8
  %r0 = load i64, ptr %slot.n, align 8
  %r1 = load i64, ptr %slot.n, align 8
  %r2 = mul i64 %r0, %r1
  ret i64 %r2
}

define i64 @getDoubler() nounwind {
entry:
  %r0.ptr = call ptr @nova_rt_struct_alloc(i64 8)
  %r0.tgep = getelementptr i64, ptr %r0.ptr, i64 0
  %r0.tfn = ptrtoint ptr @__tramp_1 to i64
  store i64 %r0.tfn, ptr %r0.tgep, align 8
  %r0 = ptrtoint ptr %r0.ptr to i64
  ret i64 %r0
}

define i64 @getTripler() nounwind {
entry:
  %r0.ptr = call ptr @nova_rt_struct_alloc(i64 8)
  %r0.tgep = getelementptr i64, ptr %r0.ptr, i64 0
  %r0.tfn = ptrtoint ptr @__tramp_2 to i64
  store i64 %r0.tfn, ptr %r0.tgep, align 8
  %r0 = ptrtoint ptr %r0.ptr to i64
  ret i64 %r0
}

define i64 @compose(i64 %p0, i64 %p1, i64 %p2) nounwind {
entry:
  %slot.f = alloca i64, align 8
  store i64 %p0, ptr %slot.f, align 8
  %slot.g = alloca i64, align 8
  store i64 %p1, ptr %slot.g, align 8
  %slot.x = alloca i64, align 8
  store i64 %p2, ptr %slot.x, align 8
  %r0 = load i64, ptr %slot.x, align 8
  %r2 = load i64, ptr %slot.g, align 8
  %r1.rec = inttoptr i64 %r2 to ptr
  %r1.fnraw = load i64, ptr %r1.rec, align 8
  %r1.fnptr = inttoptr i64 %r1.fnraw to ptr
  %r1 = call i64 %r1.fnptr(i64 %r2, i64 %r0)
  %r4 = load i64, ptr %slot.f, align 8
  %r3.rec = inttoptr i64 %r4 to ptr
  %r3.fnraw = load i64, ptr %r3.rec, align 8
  %r3.fnptr = inttoptr i64 %r3.fnraw to ptr
  %r3 = call i64 %r3.fnptr(i64 %r4, i64 %r1)
  ret i64 %r3
}

define i64 @makeLinear(i64 %p0, i64 %p1) nounwind {
entry:
  %slot.a = alloca i64, align 8
  store i64 %p0, ptr %slot.a, align 8
  %slot.b = alloca i64, align 8
  store i64 %p1, ptr %slot.b, align 8
  %r0 = load i64, ptr %slot.a, align 8
  %r1 = load i64, ptr %slot.b, align 8
  %r2.ptr = call ptr @nova_rt_struct_alloc(i64 24)
  %r2.tgep = getelementptr i64, ptr %r2.ptr, i64 0
  %r2.tfn = ptrtoint ptr @__tramp_3 to i64
  store i64 %r2.tfn, ptr %r2.tgep, align 8
  %r2.c0 = getelementptr i64, ptr %r2.ptr, i64 1
  store i64 %r0, ptr %r2.c0, align 8
  %r2.c1 = getelementptr i64, ptr %r2.ptr, i64 2
  store i64 %r1, ptr %r2.c1, align 8
  %r2 = ptrtoint ptr %r2.ptr to i64
  ret i64 %r2
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
  %r1 = add i64 2, 0
  %r2 = mul i64 %r0, %r1
  ret i64 %r2
}

define i64 @__lambda_2(i64 %p0) nounwind {
entry:
  %slot.x = alloca i64, align 8
  store i64 %p0, ptr %slot.x, align 8
  %r0 = load i64, ptr %slot.x, align 8
  %r1 = add i64 3, 0
  %r2 = mul i64 %r0, %r1
  ret i64 %r2
}

define i64 @__lambda_3(i64 %p0, i64 %p1, i64 %p2) nounwind {
entry:
  %slot.a = alloca i64, align 8
  store i64 %p0, ptr %slot.a, align 8
  %slot.b = alloca i64, align 8
  store i64 %p1, ptr %slot.b, align 8
  %slot.x = alloca i64, align 8
  store i64 %p2, ptr %slot.x, align 8
  %r0 = load i64, ptr %slot.a, align 8
  %r1 = load i64, ptr %slot.x, align 8
  %r2 = mul i64 %r0, %r1
  %r3 = load i64, ptr %slot.b, align 8
  %r4 = call i64 @nova_rt_add(i64 %r2, i64 %r3)
  ret i64 %r4
}

define i64 @nova_main() nounwind {
entry:
  %slot.add5 = alloca i64, align 8
  store i64 0, ptr %slot.add5, align 8
  %slot.add10 = alloca i64, align 8
  store i64 0, ptr %slot.add10, align 8
  %slot.add3 = alloca i64, align 8
  store i64 0, ptr %slot.add3, align 8
  %slot.multiplier = alloca i64, align 8
  store i64 0, ptr %slot.multiplier, align 8
  %slot.times5 = alloca i64, align 8
  store i64 0, ptr %slot.times5, align 8
  %slot.d = alloca i64, align 8
  store i64 0, ptr %slot.d, align 8
  %slot.t = alloca i64, align 8
  store i64 0, ptr %slot.t, align 8
  %slot.add20 = alloca i64, align 8
  store i64 0, ptr %slot.add20, align 8
  %slot.f1 = alloca i64, align 8
  store i64 0, ptr %slot.f1, align 8
  %slot.f2 = alloca i64, align 8
  store i64 0, ptr %slot.f2, align 8
  %r0 = add i64 5, 0
  %r1 = call i64 @makeAdder(i64 %r0)
  store i64 %r1, ptr %slot.add5, align 8
  %r2 = add i64 10, 0
  %r3 = call i64 @makeAdder(i64 %r2)
  store i64 %r3, ptr %slot.add10, align 8
  %r4 = add i64 3, 0
  %r6 = load i64, ptr %slot.add5, align 8
  %r5.rec = inttoptr i64 %r6 to ptr
  %r5.fnraw = load i64, ptr %r5.rec, align 8
  %r5.fnptr = inttoptr i64 %r5.fnraw to ptr
  %r5 = call i64 %r5.fnptr(i64 %r6, i64 %r4)
  %r7 = call i64 @nova_rt_print_any(i64 %r5)
  %r8 = add i64 3, 0
  %r10 = load i64, ptr %slot.add10, align 8
  %r9.rec = inttoptr i64 %r10 to ptr
  %r9.fnraw = load i64, ptr %r9.rec, align 8
  %r9.fnptr = inttoptr i64 %r9.fnraw to ptr
  %r9 = call i64 %r9.fnptr(i64 %r10, i64 %r8)
  %r11 = call i64 @nova_rt_print_any(i64 %r9)
  %r12 = add i64 1, 0
  %r14 = load i64, ptr %slot.add10, align 8
  %r13.rec = inttoptr i64 %r14 to ptr
  %r13.fnraw = load i64, ptr %r13.rec, align 8
  %r13.fnptr = inttoptr i64 %r13.fnraw to ptr
  %r13 = call i64 %r13.fnptr(i64 %r14, i64 %r12)
  %r16 = load i64, ptr %slot.add5, align 8
  %r15.rec = inttoptr i64 %r16 to ptr
  %r15.fnraw = load i64, ptr %r15.rec, align 8
  %r15.fnptr = inttoptr i64 %r15.fnraw to ptr
  %r15 = call i64 %r15.fnptr(i64 %r16, i64 %r13)
  %r17 = call i64 @nova_rt_print_any(i64 %r15)
  %r18.ptr = call ptr @nova_rt_struct_alloc(i64 8)
  %r18.tgep = getelementptr i64, ptr %r18.ptr, i64 0
  %r18.tfn = ptrtoint ptr @__fnref_double to i64
  store i64 %r18.tfn, ptr %r18.tgep, align 8
  %r18 = ptrtoint ptr %r18.ptr to i64
  %r19 = add i64 5, 0
  %r20 = call i64 @apply(i64 %r18, i64 %r19)
  %r21 = call i64 @nova_rt_print_any(i64 %r20)
  %r22.ptr = call ptr @nova_rt_struct_alloc(i64 8)
  %r22.tgep = getelementptr i64, ptr %r22.ptr, i64 0
  %r22.tfn = ptrtoint ptr @__fnref_square to i64
  store i64 %r22.tfn, ptr %r22.tgep, align 8
  %r22 = ptrtoint ptr %r22.ptr to i64
  %r23 = add i64 4, 0
  %r24 = call i64 @apply(i64 %r22, i64 %r23)
  %r25 = call i64 @nova_rt_print_any(i64 %r24)
  %r26.ptr = call ptr @nova_rt_struct_alloc(i64 8)
  %r26.tgep = getelementptr i64, ptr %r26.ptr, i64 0
  %r26.tfn = ptrtoint ptr @__fnref_double to i64
  store i64 %r26.tfn, ptr %r26.tgep, align 8
  %r26 = ptrtoint ptr %r26.ptr to i64
  %r27 = add i64 0, 0
  %r28 = call i64 @apply(i64 %r26, i64 %r27)
  %r29 = call i64 @nova_rt_print_any(i64 %r28)
  %r30.ptr = call ptr @nova_rt_struct_alloc(i64 8)
  %r30.tgep = getelementptr i64, ptr %r30.ptr, i64 0
  %r30.tfn = ptrtoint ptr @__tramp_4 to i64
  store i64 %r30.tfn, ptr %r30.tgep, align 8
  %r30 = ptrtoint ptr %r30.ptr to i64
  store i64 %r30, ptr %slot.add3, align 8
  %r31 = load i64, ptr %slot.add3, align 8
  %r32 = add i64 10, 0
  %r33 = call i64 @apply(i64 %r31, i64 %r32)
  %r34 = call i64 @nova_rt_print_any(i64 %r33)
  %r35 = add i64 5, 0
  store i64 %r35, ptr %slot.multiplier, align 8
  %r36 = load i64, ptr %slot.multiplier, align 8
  %r37.ptr = call ptr @nova_rt_struct_alloc(i64 16)
  %r37.tgep = getelementptr i64, ptr %r37.ptr, i64 0
  %r37.tfn = ptrtoint ptr @__tramp_5 to i64
  store i64 %r37.tfn, ptr %r37.tgep, align 8
  %r37.c0 = getelementptr i64, ptr %r37.ptr, i64 1
  store i64 %r36, ptr %r37.c0, align 8
  %r37 = ptrtoint ptr %r37.ptr to i64
  store i64 %r37, ptr %slot.times5, align 8
  %r38 = load i64, ptr %slot.times5, align 8
  %r39 = add i64 7, 0
  %r40 = call i64 @apply(i64 %r38, i64 %r39)
  %r41 = call i64 @nova_rt_print_any(i64 %r40)
  %r42 = call i64 @getDoubler()
  store i64 %r42, ptr %slot.d, align 8
  %r43 = call i64 @getTripler()
  store i64 %r43, ptr %slot.t, align 8
  %r44 = add i64 5, 0
  %r46 = load i64, ptr %slot.d, align 8
  %r45.rec = inttoptr i64 %r46 to ptr
  %r45.fnraw = load i64, ptr %r45.rec, align 8
  %r45.fnptr = inttoptr i64 %r45.fnraw to ptr
  %r45 = call i64 %r45.fnptr(i64 %r46, i64 %r44)
  %r47 = call i64 @nova_rt_print_any(i64 %r45)
  %r48 = add i64 5, 0
  %r50 = load i64, ptr %slot.t, align 8
  %r49.rec = inttoptr i64 %r50 to ptr
  %r49.fnraw = load i64, ptr %r49.rec, align 8
  %r49.fnptr = inttoptr i64 %r49.fnraw to ptr
  %r49 = call i64 %r49.fnptr(i64 %r50, i64 %r48)
  %r51 = call i64 @nova_rt_print_any(i64 %r49)
  %r52 = add i64 4, 0
  %r54 = load i64, ptr %slot.t, align 8
  %r53.rec = inttoptr i64 %r54 to ptr
  %r53.fnraw = load i64, ptr %r53.rec, align 8
  %r53.fnptr = inttoptr i64 %r53.fnraw to ptr
  %r53 = call i64 %r53.fnptr(i64 %r54, i64 %r52)
  %r56 = load i64, ptr %slot.d, align 8
  %r55.rec = inttoptr i64 %r56 to ptr
  %r55.fnraw = load i64, ptr %r55.rec, align 8
  %r55.fnptr = inttoptr i64 %r55.fnraw to ptr
  %r55 = call i64 %r55.fnptr(i64 %r56, i64 %r53)
  %r57 = call i64 @nova_rt_print_any(i64 %r55)
  %r58.ptr = call ptr @nova_rt_struct_alloc(i64 8)
  %r58.tgep = getelementptr i64, ptr %r58.ptr, i64 0
  %r58.tfn = ptrtoint ptr @__fnref_double to i64
  store i64 %r58.tfn, ptr %r58.tgep, align 8
  %r58 = ptrtoint ptr %r58.ptr to i64
  %r59.ptr = call ptr @nova_rt_struct_alloc(i64 8)
  %r59.tgep = getelementptr i64, ptr %r59.ptr, i64 0
  %r59.tfn = ptrtoint ptr @__fnref_square to i64
  store i64 %r59.tfn, ptr %r59.tgep, align 8
  %r59 = ptrtoint ptr %r59.ptr to i64
  %r60 = add i64 3, 0
  %r61 = call i64 @compose(i64 %r58, i64 %r59, i64 %r60)
  %r62 = call i64 @nova_rt_print_any(i64 %r61)
  %r63.ptr = call ptr @nova_rt_struct_alloc(i64 8)
  %r63.tgep = getelementptr i64, ptr %r63.ptr, i64 0
  %r63.tfn = ptrtoint ptr @__fnref_square to i64
  store i64 %r63.tfn, ptr %r63.tgep, align 8
  %r63 = ptrtoint ptr %r63.ptr to i64
  %r64.ptr = call ptr @nova_rt_struct_alloc(i64 8)
  %r64.tgep = getelementptr i64, ptr %r64.ptr, i64 0
  %r64.tfn = ptrtoint ptr @__fnref_double to i64
  store i64 %r64.tfn, ptr %r64.tgep, align 8
  %r64 = ptrtoint ptr %r64.ptr to i64
  %r65 = add i64 3, 0
  %r66 = call i64 @compose(i64 %r63, i64 %r64, i64 %r65)
  %r67 = call i64 @nova_rt_print_any(i64 %r66)
  %r68 = add i64 20, 0
  %r69 = call i64 @makeAdder(i64 %r68)
  store i64 %r69, ptr %slot.add20, align 8
  %r70 = load i64, ptr %slot.add20, align 8
  %r71 = add i64 100, 0
  %r72 = call i64 @apply(i64 %r70, i64 %r71)
  %r73 = call i64 @nova_rt_print_any(i64 %r72)
  %r74 = add i64 2, 0
  %r75 = add i64 3, 0
  %r76 = call i64 @makeLinear(i64 %r74, i64 %r75)
  store i64 %r76, ptr %slot.f1, align 8
  %r77 = add i64 5, 0
  %r78 = add i64 1, 0
  %r79 = call i64 @makeLinear(i64 %r77, i64 %r78)
  store i64 %r79, ptr %slot.f2, align 8
  %r80 = add i64 10, 0
  %r82 = load i64, ptr %slot.f1, align 8
  %r81.rec = inttoptr i64 %r82 to ptr
  %r81.fnraw = load i64, ptr %r81.rec, align 8
  %r81.fnptr = inttoptr i64 %r81.fnraw to ptr
  %r81 = call i64 %r81.fnptr(i64 %r82, i64 %r80)
  %r83 = call i64 @nova_rt_print_any(i64 %r81)
  %r84 = add i64 10, 0
  %r86 = load i64, ptr %slot.f2, align 8
  %r85.rec = inttoptr i64 %r86 to ptr
  %r85.fnraw = load i64, ptr %r85.rec, align 8
  %r85.fnptr = inttoptr i64 %r85.fnraw to ptr
  %r85 = call i64 %r85.fnptr(i64 %r86, i64 %r84)
  %r87 = call i64 @nova_rt_print_any(i64 %r85)
  ret i64 0
}

define i64 @__lambda_4(i64 %p0) nounwind {
entry:
  %slot.x = alloca i64, align 8
  store i64 %p0, ptr %slot.x, align 8
  %r0 = load i64, ptr %slot.x, align 8
  %r1 = add i64 3, 0
  %r2 = call i64 @nova_rt_add(i64 %r0, i64 %r1)
  ret i64 %r2
}

define i64 @__lambda_5(i64 %p0, i64 %p1) nounwind {
entry:
  %slot.multiplier = alloca i64, align 8
  store i64 %p0, ptr %slot.multiplier, align 8
  %slot.x = alloca i64, align 8
  store i64 %p1, ptr %slot.x, align 8
  %r0 = load i64, ptr %slot.x, align 8
  %r1 = load i64, ptr %slot.multiplier, align 8
  %r2 = mul i64 %r0, %r1
  ret i64 %r2
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

define i64 @__tramp_2(i64 %record, i64 %p0) nounwind {
entry:
  %result = call i64 @__lambda_2(i64 %p0)
  ret i64 %result
}

define i64 @__tramp_3(i64 %record, i64 %p0) nounwind {
entry:
  %rec_ptr = inttoptr i64 %record to ptr
  %cap0_ptr = getelementptr i64, ptr %rec_ptr, i64 1
  %cap0 = load i64, ptr %cap0_ptr, align 8
  %cap1_ptr = getelementptr i64, ptr %rec_ptr, i64 2
  %cap1 = load i64, ptr %cap1_ptr, align 8
  %result = call i64 @__lambda_3(i64 %cap0, i64 %cap1, i64 %p0)
  ret i64 %result
}

define i64 @__fnref_double(i64 %record, i64 %p0) nounwind {
entry:
  %result = call i64 @double(i64 %p0)
  ret i64 %result
}

define i64 @__fnref_square(i64 %record, i64 %p0) nounwind {
entry:
  %result = call i64 @square(i64 %p0)
  ret i64 %result
}

define i64 @__tramp_4(i64 %record, i64 %p0) nounwind {
entry:
  %result = call i64 @__lambda_4(i64 %p0)
  ret i64 %result
}

define i64 @__tramp_5(i64 %record, i64 %p0) nounwind {
entry:
  %rec_ptr = inttoptr i64 %record to ptr
  %cap0_ptr = getelementptr i64, ptr %rec_ptr, i64 1
  %cap0 = load i64, ptr %cap0_ptr, align 8
  %result = call i64 @__lambda_5(i64 %cap0, i64 %p0)
  ret i64 %result
}

define i32 @main(i32 %argc, ptr %argv) nounwind {
entry:
  %argc64 = sext i32 %argc to i64
  %argv64 = ptrtoint ptr %argv to i64
  call void @nova_rt_init_args(i64 %argc64, i64 %argv64)
  call i64 @nova_main()
  call void @nova_rt_wait_all()
  call void @nova_rt_cleanup()
  ret i32 0
}

; TBAA metadata
!0 = !{!"NOVA TBAA"}
!1 = !{!"list_data_ptr", !0}
!2 = !{!1, !1, i64 0}
!3 = !{!"list_elem", !0}
!4 = !{!3, !3, i64 0}
!5 = !{!"list_size", !0}
!6 = !{!5, !5, i64 0}
!90 = !{!"branch_weights", i32 2000, i32 1}
!91 = distinct !{!91, !92, !93}
!92 = !{!"llvm.loop.unroll.enable"}
!93 = !{!"llvm.loop.vectorize.enable", i1 true}
