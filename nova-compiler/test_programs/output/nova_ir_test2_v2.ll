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

define i64 @ir_type_int() nounwind {
entry:
  %r0.p = getelementptr inbounds [4 x i8], ptr @.str.0, i64 0, i64 0
  %r0 = ptrtoint ptr %r0.p to i64
  %r1.p = getelementptr inbounds [1 x i8], ptr @.str.1, i64 0, i64 0
  %r1 = ptrtoint ptr %r1.p to i64
  %r2 = call i64 @nova_rt_list_create()
  %r3 = add i64 0, 0
  %r4.ptr = call ptr @nova_rt_struct_alloc(i64 40)
  %r4.thash = getelementptr i64, ptr %r4.ptr, i64 0
  store i64 6952384374146, ptr %r4.thash, align 8
  %r4.f0 = getelementptr i64, ptr %r4.ptr, i64 1
  store i64 %r0, ptr %r4.f0, align 8
  %r4.f1 = getelementptr i64, ptr %r4.ptr, i64 2
  store i64 %r1, ptr %r4.f1, align 8
  %r4.f2 = getelementptr i64, ptr %r4.ptr, i64 3
  store i64 %r2, ptr %r4.f2, align 8
  %r4.f3 = getelementptr i64, ptr %r4.ptr, i64 4
  store i64 %r3, ptr %r4.f3, align 8
  %r4 = ptrtoint ptr %r4.ptr to i64
  ret i64 %r4
}

define i64 @ir_type_any() nounwind {
entry:
  %r0.p = getelementptr inbounds [4 x i8], ptr @.str.2, i64 0, i64 0
  %r0 = ptrtoint ptr %r0.p to i64
  %r1.p = getelementptr inbounds [1 x i8], ptr @.str.1, i64 0, i64 0
  %r1 = ptrtoint ptr %r1.p to i64
  %r2 = call i64 @nova_rt_list_create()
  %r3 = add i64 0, 0
  %r4.ptr = call ptr @nova_rt_struct_alloc(i64 40)
  %r4.thash = getelementptr i64, ptr %r4.ptr, i64 0
  store i64 6952384374146, ptr %r4.thash, align 8
  %r4.f0 = getelementptr i64, ptr %r4.ptr, i64 1
  store i64 %r0, ptr %r4.f0, align 8
  %r4.f1 = getelementptr i64, ptr %r4.ptr, i64 2
  store i64 %r1, ptr %r4.f1, align 8
  %r4.f2 = getelementptr i64, ptr %r4.ptr, i64 3
  store i64 %r2, ptr %r4.f2, align 8
  %r4.f3 = getelementptr i64, ptr %r4.ptr, i64 4
  store i64 %r3, ptr %r4.f3, align 8
  %r4 = ptrtoint ptr %r4.ptr to i64
  ret i64 %r4
}

define i64 @ir_type_void() nounwind {
entry:
  %r0.p = getelementptr inbounds [5 x i8], ptr @.str.3, i64 0, i64 0
  %r0 = ptrtoint ptr %r0.p to i64
  %r1.p = getelementptr inbounds [1 x i8], ptr @.str.1, i64 0, i64 0
  %r1 = ptrtoint ptr %r1.p to i64
  %r2 = call i64 @nova_rt_list_create()
  %r3 = add i64 0, 0
  %r4.ptr = call ptr @nova_rt_struct_alloc(i64 40)
  %r4.thash = getelementptr i64, ptr %r4.ptr, i64 0
  store i64 6952384374146, ptr %r4.thash, align 8
  %r4.f0 = getelementptr i64, ptr %r4.ptr, i64 1
  store i64 %r0, ptr %r4.f0, align 8
  %r4.f1 = getelementptr i64, ptr %r4.ptr, i64 2
  store i64 %r1, ptr %r4.f1, align 8
  %r4.f2 = getelementptr i64, ptr %r4.ptr, i64 3
  store i64 %r2, ptr %r4.f2, align 8
  %r4.f3 = getelementptr i64, ptr %r4.ptr, i64 4
  store i64 %r3, ptr %r4.f3, align 8
  %r4 = ptrtoint ptr %r4.ptr to i64
  ret i64 %r4
}

define i64 @ir_inst(i64 %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4, i64 %p5) nounwind {
entry:
  %slot.op = alloca i64, align 8
  store i64 %p0, ptr %slot.op, align 8
  %slot.dest = alloca i64, align 8
  store i64 %p1, ptr %slot.dest, align 8
  %slot.typ = alloca i64, align 8
  store i64 %p2, ptr %slot.typ, align 8
  %slot.args = alloca i64, align 8
  store i64 %p3, ptr %slot.args, align 8
  %slot.value = alloca i64, align 8
  store i64 %p4, ptr %slot.value, align 8
  %slot.num = alloca i64, align 8
  store i64 %p5, ptr %slot.num, align 8
  %r0 = load i64, ptr %slot.op, align 8
  %r1 = load i64, ptr %slot.dest, align 8
  %r2 = load i64, ptr %slot.typ, align 8
  %r3 = load i64, ptr %slot.args, align 8
  %r4 = load i64, ptr %slot.value, align 8
  %r5 = load i64, ptr %slot.num, align 8
  %r6.p = getelementptr inbounds [5 x i8], ptr @.str.4, i64 0, i64 0
  %r6 = ptrtoint ptr %r6.p to i64
  %r7.ptr = call ptr @nova_rt_struct_alloc(i64 64)
  %r7.thash = getelementptr i64, ptr %r7.ptr, i64 0
  store i64 6952383966974, ptr %r7.thash, align 8
  %r7.f0 = getelementptr i64, ptr %r7.ptr, i64 1
  store i64 %r0, ptr %r7.f0, align 8
  %r7.f1 = getelementptr i64, ptr %r7.ptr, i64 2
  store i64 %r1, ptr %r7.f1, align 8
  %r7.f2 = getelementptr i64, ptr %r7.ptr, i64 3
  store i64 %r2, ptr %r7.f2, align 8
  %r7.f3 = getelementptr i64, ptr %r7.ptr, i64 4
  store i64 %r3, ptr %r7.f3, align 8
  %r7.f4 = getelementptr i64, ptr %r7.ptr, i64 5
  store i64 %r4, ptr %r7.f4, align 8
  %r7.f5 = getelementptr i64, ptr %r7.ptr, i64 6
  store i64 %r5, ptr %r7.f5, align 8
  %r7.f6 = getelementptr i64, ptr %r7.ptr, i64 7
  store i64 %r6, ptr %r7.f6, align 8
  %r7 = ptrtoint ptr %r7.ptr to i64
  ret i64 %r7
}

define i64 @build_add_fn() nounwind {
entry:
  %slot.params = alloca i64, align 8
  store i64 0, ptr %slot.params, align 8
  %slot.insts = alloca i64, align 8
  store i64 0, ptr %slot.insts, align 8
  %slot.term = alloca i64, align 8
  store i64 0, ptr %slot.term, align 8
  %slot.entry = alloca i64, align 8
  store i64 0, ptr %slot.entry, align 8
  %r1.p = getelementptr inbounds [2 x i8], ptr @.str.5, i64 0, i64 0
  %r1 = ptrtoint ptr %r1.p to i64
  %r2 = call i64 @ir_type_int()
  %r3.ptr = call ptr @nova_rt_struct_alloc(i64 24)
  %r3.thash = getelementptr i64, ptr %r3.ptr, i64 0
  store i64 229428678742801, ptr %r3.thash, align 8
  %r3.f0 = getelementptr i64, ptr %r3.ptr, i64 1
  store i64 %r1, ptr %r3.f0, align 8
  %r3.f1 = getelementptr i64, ptr %r3.ptr, i64 2
  store i64 %r2, ptr %r3.f1, align 8
  %r3 = ptrtoint ptr %r3.ptr to i64
  %r4.p = getelementptr inbounds [2 x i8], ptr @.str.6, i64 0, i64 0
  %r4 = ptrtoint ptr %r4.p to i64
  %r5 = call i64 @ir_type_int()
  %r6.ptr = call ptr @nova_rt_struct_alloc(i64 24)
  %r6.thash = getelementptr i64, ptr %r6.ptr, i64 0
  store i64 229428678742801, ptr %r6.thash, align 8
  %r6.f0 = getelementptr i64, ptr %r6.ptr, i64 1
  store i64 %r4, ptr %r6.f0, align 8
  %r6.f1 = getelementptr i64, ptr %r6.ptr, i64 2
  store i64 %r5, ptr %r6.f1, align 8
  %r6 = ptrtoint ptr %r6.ptr to i64
  %r0 = call i64 @nova_rt_list_create()
  call i64 @nova_rt_list_append(i64 %r0, i64 %r3)
  call i64 @nova_rt_list_append(i64 %r0, i64 %r6)
  store i64 %r0, ptr %slot.params, align 8
  %r7 = call i64 @nova_rt_list_create()
  store i64 %r7, ptr %slot.insts, align 8
  %r8 = load i64, ptr %slot.insts, align 8
  %r9.p = getelementptr inbounds [10 x i8], ptr @.str.7, i64 0, i64 0
  %r9 = ptrtoint ptr %r9.p to i64
  %r10.p = getelementptr inbounds [4 x i8], ptr @.str.8, i64 0, i64 0
  %r10 = ptrtoint ptr %r10.p to i64
  %r11 = call i64 @ir_type_int()
  %r12 = call i64 @nova_rt_list_create()
  %r13.p = getelementptr inbounds [2 x i8], ptr @.str.5, i64 0, i64 0
  %r13 = ptrtoint ptr %r13.p to i64
  %r14 = add i64 0, 0
  %r15 = call i64 @ir_inst(i64 %r9, i64 %r10, i64 %r11, i64 %r12, i64 %r13, i64 %r14)
  %r16 = call i64 @nova_rt_list_append(i64 %r8, i64 %r15)
  %r17 = load i64, ptr %slot.insts, align 8
  %r18.p = getelementptr inbounds [10 x i8], ptr @.str.7, i64 0, i64 0
  %r18 = ptrtoint ptr %r18.p to i64
  %r19.p = getelementptr inbounds [4 x i8], ptr @.str.9, i64 0, i64 0
  %r19 = ptrtoint ptr %r19.p to i64
  %r20 = call i64 @ir_type_int()
  %r21 = call i64 @nova_rt_list_create()
  %r22.p = getelementptr inbounds [2 x i8], ptr @.str.6, i64 0, i64 0
  %r22 = ptrtoint ptr %r22.p to i64
  %r23 = add i64 0, 0
  %r24 = call i64 @ir_inst(i64 %r18, i64 %r19, i64 %r20, i64 %r21, i64 %r22, i64 %r23)
  %r25 = call i64 @nova_rt_list_append(i64 %r17, i64 %r24)
  %r26 = load i64, ptr %slot.insts, align 8
  %r27.p = getelementptr inbounds [4 x i8], ptr @.str.10, i64 0, i64 0
  %r27 = ptrtoint ptr %r27.p to i64
  %r28.p = getelementptr inbounds [4 x i8], ptr @.str.11, i64 0, i64 0
  %r28 = ptrtoint ptr %r28.p to i64
  %r29 = call i64 @ir_type_int()
  %r31.p = getelementptr inbounds [4 x i8], ptr @.str.8, i64 0, i64 0
  %r31 = ptrtoint ptr %r31.p to i64
  %r32.p = getelementptr inbounds [4 x i8], ptr @.str.9, i64 0, i64 0
  %r32 = ptrtoint ptr %r32.p to i64
  %r30 = call i64 @nova_rt_list_create()
  call i64 @nova_rt_list_append(i64 %r30, i64 %r31)
  call i64 @nova_rt_list_append(i64 %r30, i64 %r32)
  %r33.p = getelementptr inbounds [2 x i8], ptr @.str.12, i64 0, i64 0
  %r33 = ptrtoint ptr %r33.p to i64
  %r34 = add i64 0, 0
  %r35 = call i64 @ir_inst(i64 %r27, i64 %r28, i64 %r29, i64 %r30, i64 %r33, i64 %r34)
  %r36 = call i64 @nova_rt_list_append(i64 %r26, i64 %r35)
  %r37.p = getelementptr inbounds [7 x i8], ptr @.str.13, i64 0, i64 0
  %r37 = ptrtoint ptr %r37.p to i64
  %r38.p = getelementptr inbounds [1 x i8], ptr @.str.1, i64 0, i64 0
  %r38 = ptrtoint ptr %r38.p to i64
  %r39 = call i64 @ir_type_void()
  %r41.p = getelementptr inbounds [4 x i8], ptr @.str.11, i64 0, i64 0
  %r41 = ptrtoint ptr %r41.p to i64
  %r40 = call i64 @nova_rt_list_create()
  call i64 @nova_rt_list_append(i64 %r40, i64 %r41)
  %r42.p = getelementptr inbounds [1 x i8], ptr @.str.1, i64 0, i64 0
  %r42 = ptrtoint ptr %r42.p to i64
  %r43 = add i64 0, 0
  %r44 = call i64 @ir_inst(i64 %r37, i64 %r38, i64 %r39, i64 %r40, i64 %r42, i64 %r43)
  store i64 %r44, ptr %slot.term, align 8
  %r45.p = getelementptr inbounds [6 x i8], ptr @.str.14, i64 0, i64 0
  %r45 = ptrtoint ptr %r45.p to i64
  %r46 = load i64, ptr %slot.insts, align 8
  %r47 = load i64, ptr %slot.term, align 8
  %r48.ptr = call ptr @nova_rt_struct_alloc(i64 32)
  %r48.thash = getelementptr i64, ptr %r48.ptr, i64 0
  store i64 229428662532011, ptr %r48.thash, align 8
  %r48.f0 = getelementptr i64, ptr %r48.ptr, i64 1
  store i64 %r45, ptr %r48.f0, align 8
  %r48.f1 = getelementptr i64, ptr %r48.ptr, i64 2
  store i64 %r46, ptr %r48.f1, align 8
  %r48.f2 = getelementptr i64, ptr %r48.ptr, i64 3
  store i64 %r47, ptr %r48.f2, align 8
  %r48 = ptrtoint ptr %r48.ptr to i64
  store i64 %r48, ptr %slot.entry, align 8
  %r49.p = getelementptr inbounds [4 x i8], ptr @.str.10, i64 0, i64 0
  %r49 = ptrtoint ptr %r49.p to i64
  %r50 = load i64, ptr %slot.params, align 8
  %r51 = call i64 @ir_type_int()
  %r53 = load i64, ptr %slot.entry, align 8
  %r52 = call i64 @nova_rt_list_create()
  call i64 @nova_rt_list_append(i64 %r52, i64 %r53)
  %r54 = call i64 @nova_rt_list_create()
  %r55 = add i64 0, 0
  %r56.ptr = call ptr @nova_rt_struct_alloc(i64 56)
  %r56.thash = getelementptr i64, ptr %r56.ptr, i64 0
  store i64 8244978027471169094, ptr %r56.thash, align 8
  %r56.f0 = getelementptr i64, ptr %r56.ptr, i64 1
  store i64 %r49, ptr %r56.f0, align 8
  %r56.f1 = getelementptr i64, ptr %r56.ptr, i64 2
  store i64 %r50, ptr %r56.f1, align 8
  %r56.f2 = getelementptr i64, ptr %r56.ptr, i64 3
  store i64 %r51, ptr %r56.f2, align 8
  %r56.f3 = getelementptr i64, ptr %r56.ptr, i64 4
  store i64 %r52, ptr %r56.f3, align 8
  %r56.f4 = getelementptr i64, ptr %r56.ptr, i64 5
  store i64 %r54, ptr %r56.f4, align 8
  %r56.f5 = getelementptr i64, ptr %r56.ptr, i64 6
  store i64 %r55, ptr %r56.f5, align 8
  %r56 = ptrtoint ptr %r56.ptr to i64
  ret i64 %r56
}

define i64 @nova_main() nounwind {
entry:
  %slot.add_fn = alloca i64, align 8
  store i64 0, ptr %slot.add_fn, align 8
  %slot.name = alloca i64, align 8
  store i64 0, ptr %slot.name, align 8
  %slot.params = alloca i64, align 8
  store i64 0, ptr %slot.params, align 8
  %slot.ret_type = alloca i64, align 8
  store i64 0, ptr %slot.ret_type, align 8
  %slot.blocks = alloca i64, align 8
  store i64 0, ptr %slot.blocks, align 8
  %slot.type_params = alloca i64, align 8
  store i64 0, ptr %slot.type_params, align 8
  %slot.is_extern = alloca i64, align 8
  store i64 0, ptr %slot.is_extern, align 8
  %slot.kind = alloca i64, align 8
  store i64 0, ptr %slot.kind, align 8
  %slot.n = alloca i64, align 8
  store i64 0, ptr %slot.n, align 8
  %slot.p = alloca i64, align 8
  store i64 0, ptr %slot.p, align 8
  %slot.id = alloca i64, align 8
  store i64 0, ptr %slot.id, align 8
  %slot.label = alloca i64, align 8
  store i64 0, ptr %slot.label, align 8
  %slot.insts = alloca i64, align 8
  store i64 0, ptr %slot.insts, align 8
  %slot.term = alloca i64, align 8
  store i64 0, ptr %slot.term, align 8
  %slot.op = alloca i64, align 8
  store i64 0, ptr %slot.op, align 8
  %slot.dest = alloca i64, align 8
  store i64 0, ptr %slot.dest, align 8
  %slot.typ = alloca i64, align 8
  store i64 0, ptr %slot.typ, align 8
  %slot.args = alloca i64, align 8
  store i64 0, ptr %slot.args, align 8
  %slot.value = alloca i64, align 8
  store i64 0, ptr %slot.value, align 8
  %slot.num = alloca i64, align 8
  store i64 0, ptr %slot.num, align 8
  %slot.effect = alloca i64, align 8
  store i64 0, ptr %slot.effect, align 8
  %slot.tk = alloca i64, align 8
  store i64 0, ptr %slot.tk, align 8
  %slot.tn = alloca i64, align 8
  store i64 0, ptr %slot.tn, align 8
  %slot.tp = alloca i64, align 8
  store i64 0, ptr %slot.tp, align 8
  %slot.tid = alloca i64, align 8
  store i64 0, ptr %slot.tid, align 8
  %slot.__sc_15 = alloca i64, align 8
  store i64 0, ptr %slot.__sc_15, align 8
  %slot.__sc_18 = alloca i64, align 8
  store i64 0, ptr %slot.__sc_18, align 8
  %r0 = call i64 @build_add_fn()
  store i64 %r0, ptr %slot.add_fn, align 8
  %r1 = load i64, ptr %slot.add_fn, align 8
  %r2.ptr = inttoptr i64 %r1 to ptr
  %r2.gep = getelementptr i64, ptr %r2.ptr, i64 0
  %r2 = load i64, ptr %r2.gep, align 8
  %r3 = add i64 8244978027471169094, 0
  %r4.cmp = icmp eq i64 %r2, %r3
  %r4 = zext i1 %r4.cmp to i64
  %br_marm_01 = icmp ne i64 %r4, 0
  br i1 %br_marm_01, label %marm_01, label %match_fall2
marm_01:
  %r5.ptr = inttoptr i64 %r1 to ptr
  %r5.gep = getelementptr i64, ptr %r5.ptr, i64 1
  %r5 = load i64, ptr %r5.gep, align 8
  store i64 %r5, ptr %slot.name, align 8
  %r6.ptr = inttoptr i64 %r1 to ptr
  %r6.gep = getelementptr i64, ptr %r6.ptr, i64 2
  %r6 = load i64, ptr %r6.gep, align 8
  store i64 %r6, ptr %slot.params, align 8
  %r7.ptr = inttoptr i64 %r1 to ptr
  %r7.gep = getelementptr i64, ptr %r7.ptr, i64 3
  %r7 = load i64, ptr %r7.gep, align 8
  store i64 %r7, ptr %slot.ret_type, align 8
  %r8.ptr = inttoptr i64 %r1 to ptr
  %r8.gep = getelementptr i64, ptr %r8.ptr, i64 4
  %r8 = load i64, ptr %r8.gep, align 8
  store i64 %r8, ptr %slot.blocks, align 8
  %r9.ptr = inttoptr i64 %r1 to ptr
  %r9.gep = getelementptr i64, ptr %r9.ptr, i64 5
  %r9 = load i64, ptr %r9.gep, align 8
  store i64 %r9, ptr %slot.type_params, align 8
  %r10.ptr = inttoptr i64 %r1 to ptr
  %r10.gep = getelementptr i64, ptr %r10.ptr, i64 6
  %r10 = load i64, ptr %r10.gep, align 8
  store i64 %r10, ptr %slot.is_extern, align 8
  %r11.p = getelementptr inbounds [5 x i8], ptr @.str.15, i64 0, i64 0
  %r11 = ptrtoint ptr %r11.p to i64
  %r12 = load i64, ptr %slot.name, align 8
  %r13 = call i64 @nova_rt_str_concat(i64 %r11, i64 %r12)
  %r14 = call i64 @nova_rt_print_any(i64 %r13)
  %r15.p = getelementptr inbounds [9 x i8], ptr @.str.16, i64 0, i64 0
  %r15 = ptrtoint ptr %r15.p to i64
  %r16 = load i64, ptr %slot.params, align 8
  %r17 = call i64 @nova_rt_len_any(i64 %r16)
  %r18 = call i64 @nova_rt_int_to_str(i64 %r17)
  %r19 = call i64 @nova_rt_str_concat(i64 %r15, i64 %r18)
  %r20 = call i64 @nova_rt_print_any(i64 %r19)
  %r21 = load i64, ptr %slot.ret_type, align 8
  %r22.ptr = inttoptr i64 %r21 to ptr
  %r22.gep = getelementptr i64, ptr %r22.ptr, i64 0
  %r22 = load i64, ptr %r22.gep, align 8
  %r23 = add i64 6952384374146, 0
  %r24.cmp = icmp eq i64 %r22, %r23
  %r24 = zext i1 %r24.cmp to i64
  %br_marm_04 = icmp ne i64 %r24, 0
  br i1 %br_marm_04, label %marm_04, label %match_fall5
marm_04:
  %r25.ptr = inttoptr i64 %r21 to ptr
  %r25.gep = getelementptr i64, ptr %r25.ptr, i64 1
  %r25 = load i64, ptr %r25.gep, align 8
  store i64 %r25, ptr %slot.kind, align 8
  %r26.ptr = inttoptr i64 %r21 to ptr
  %r26.gep = getelementptr i64, ptr %r26.ptr, i64 2
  %r26 = load i64, ptr %r26.gep, align 8
  store i64 %r26, ptr %slot.n, align 8
  %r27.ptr = inttoptr i64 %r21 to ptr
  %r27.gep = getelementptr i64, ptr %r27.ptr, i64 3
  %r27 = load i64, ptr %r27.gep, align 8
  store i64 %r27, ptr %slot.p, align 8
  %r28.ptr = inttoptr i64 %r21 to ptr
  %r28.gep = getelementptr i64, ptr %r28.ptr, i64 4
  %r28 = load i64, ptr %r28.gep, align 8
  store i64 %r28, ptr %slot.id, align 8
  %r29.p = getelementptr inbounds [10 x i8], ptr @.str.17, i64 0, i64 0
  %r29 = ptrtoint ptr %r29.p to i64
  %r30 = load i64, ptr %slot.kind, align 8
  %r31 = call i64 @nova_rt_str_concat(i64 %r29, i64 %r30)
  %r32 = call i64 @nova_rt_print_any(i64 %r31)
  br label %match_exit3
match_fall5:
  br label %match_exit3
match_exit3:
  %r33.p = getelementptr inbounds [9 x i8], ptr @.str.18, i64 0, i64 0
  %r33 = ptrtoint ptr %r33.p to i64
  %r34 = load i64, ptr %slot.blocks, align 8
  %r35 = call i64 @nova_rt_len_any(i64 %r34)
  %r36 = call i64 @nova_rt_int_to_str(i64 %r35)
  %r37 = call i64 @nova_rt_str_concat(i64 %r33, i64 %r36)
  %r38 = call i64 @nova_rt_print_any(i64 %r37)
  %r39 = load i64, ptr %slot.blocks, align 8
  %r40 = add i64 0, 0
  %r41 = call i64 @nova_rt_index_get(i64 %r39, i64 %r40)
  %r42.ptr = inttoptr i64 %r41 to ptr
  %r42.gep = getelementptr i64, ptr %r42.ptr, i64 0
  %r42 = load i64, ptr %r42.gep, align 8
  %r43 = add i64 229428662532011, 0
  %r44.cmp = icmp eq i64 %r42, %r43
  %r44 = zext i1 %r44.cmp to i64
  %br_marm_07 = icmp ne i64 %r44, 0
  br i1 %br_marm_07, label %marm_07, label %match_fall8
marm_07:
  %r45.ptr = inttoptr i64 %r41 to ptr
  %r45.gep = getelementptr i64, ptr %r45.ptr, i64 1
  %r45 = load i64, ptr %r45.gep, align 8
  store i64 %r45, ptr %slot.label, align 8
  %r46.ptr = inttoptr i64 %r41 to ptr
  %r46.gep = getelementptr i64, ptr %r46.ptr, i64 2
  %r46 = load i64, ptr %r46.gep, align 8
  store i64 %r46, ptr %slot.insts, align 8
  %r47.ptr = inttoptr i64 %r41 to ptr
  %r47.gep = getelementptr i64, ptr %r47.ptr, i64 3
  %r47 = load i64, ptr %r47.gep, align 8
  store i64 %r47, ptr %slot.term, align 8
  %r48.p = getelementptr inbounds [8 x i8], ptr @.str.19, i64 0, i64 0
  %r48 = ptrtoint ptr %r48.p to i64
  %r49 = load i64, ptr %slot.label, align 8
  %r50 = call i64 @nova_rt_str_concat(i64 %r48, i64 %r49)
  %r51 = call i64 @nova_rt_print_any(i64 %r50)
  %r52.p = getelementptr inbounds [8 x i8], ptr @.str.20, i64 0, i64 0
  %r52 = ptrtoint ptr %r52.p to i64
  %r53 = load i64, ptr %slot.insts, align 8
  %r54 = call i64 @nova_rt_len_any(i64 %r53)
  %r55 = call i64 @nova_rt_int_to_str(i64 %r54)
  %r56 = call i64 @nova_rt_str_concat(i64 %r52, i64 %r55)
  %r57 = call i64 @nova_rt_print_any(i64 %r56)
  %r58 = load i64, ptr %slot.insts, align 8
  %r59 = add i64 2, 0
  %r60 = call i64 @nova_rt_index_get(i64 %r58, i64 %r59)
  %r61.ptr = inttoptr i64 %r60 to ptr
  %r61.gep = getelementptr i64, ptr %r61.ptr, i64 0
  %r61 = load i64, ptr %r61.gep, align 8
  %r62 = add i64 6952383966974, 0
  %r63.cmp = icmp eq i64 %r61, %r62
  %r63 = zext i1 %r63.cmp to i64
  %br_marm_010 = icmp ne i64 %r63, 0
  br i1 %br_marm_010, label %marm_010, label %match_fall11
marm_010:
  %r64.ptr = inttoptr i64 %r60 to ptr
  %r64.gep = getelementptr i64, ptr %r64.ptr, i64 1
  %r64 = load i64, ptr %r64.gep, align 8
  store i64 %r64, ptr %slot.op, align 8
  %r65.ptr = inttoptr i64 %r60 to ptr
  %r65.gep = getelementptr i64, ptr %r65.ptr, i64 2
  %r65 = load i64, ptr %r65.gep, align 8
  store i64 %r65, ptr %slot.dest, align 8
  %r66.ptr = inttoptr i64 %r60 to ptr
  %r66.gep = getelementptr i64, ptr %r66.ptr, i64 3
  %r66 = load i64, ptr %r66.gep, align 8
  store i64 %r66, ptr %slot.typ, align 8
  %r67.ptr = inttoptr i64 %r60 to ptr
  %r67.gep = getelementptr i64, ptr %r67.ptr, i64 4
  %r67 = load i64, ptr %r67.gep, align 8
  store i64 %r67, ptr %slot.args, align 8
  %r68.ptr = inttoptr i64 %r60 to ptr
  %r68.gep = getelementptr i64, ptr %r68.ptr, i64 5
  %r68 = load i64, ptr %r68.gep, align 8
  store i64 %r68, ptr %slot.value, align 8
  %r69.ptr = inttoptr i64 %r60 to ptr
  %r69.gep = getelementptr i64, ptr %r69.ptr, i64 6
  %r69 = load i64, ptr %r69.gep, align 8
  store i64 %r69, ptr %slot.num, align 8
  %r70.ptr = inttoptr i64 %r60 to ptr
  %r70.gep = getelementptr i64, ptr %r70.ptr, i64 7
  %r70 = load i64, ptr %r70.gep, align 8
  store i64 %r70, ptr %slot.effect, align 8
  %r71.p = getelementptr inbounds [9 x i8], ptr @.str.21, i64 0, i64 0
  %r71 = ptrtoint ptr %r71.p to i64
  %r72 = load i64, ptr %slot.op, align 8
  %r73 = call i64 @nova_rt_str_concat(i64 %r71, i64 %r72)
  %r74 = call i64 @nova_rt_print_any(i64 %r73)
  %r75 = load i64, ptr %slot.typ, align 8
  %r76.ptr = inttoptr i64 %r75 to ptr
  %r76.gep = getelementptr i64, ptr %r76.ptr, i64 0
  %r76 = load i64, ptr %r76.gep, align 8
  %r77 = add i64 6952384374146, 0
  %r78.cmp = icmp eq i64 %r76, %r77
  %r78 = zext i1 %r78.cmp to i64
  %br_marm_013 = icmp ne i64 %r78, 0
  br i1 %br_marm_013, label %marm_013, label %match_fall14
marm_013:
  %r79.ptr = inttoptr i64 %r75 to ptr
  %r79.gep = getelementptr i64, ptr %r79.ptr, i64 1
  %r79 = load i64, ptr %r79.gep, align 8
  store i64 %r79, ptr %slot.tk, align 8
  %r80.ptr = inttoptr i64 %r75 to ptr
  %r80.gep = getelementptr i64, ptr %r80.ptr, i64 2
  %r80 = load i64, ptr %r80.gep, align 8
  store i64 %r80, ptr %slot.tn, align 8
  %r81.ptr = inttoptr i64 %r75 to ptr
  %r81.gep = getelementptr i64, ptr %r81.ptr, i64 3
  %r81 = load i64, ptr %r81.gep, align 8
  store i64 %r81, ptr %slot.tp, align 8
  %r82.ptr = inttoptr i64 %r75 to ptr
  %r82.gep = getelementptr i64, ptr %r82.ptr, i64 4
  %r82 = load i64, ptr %r82.gep, align 8
  store i64 %r82, ptr %slot.tid, align 8
  %r83.p = getelementptr inbounds [11 x i8], ptr @.str.22, i64 0, i64 0
  %r83 = ptrtoint ptr %r83.p to i64
  %r84 = load i64, ptr %slot.tk, align 8
  %r85 = call i64 @nova_rt_str_concat(i64 %r83, i64 %r84)
  %r86 = call i64 @nova_rt_print_any(i64 %r85)
  br label %match_exit12
match_fall14:
  br label %match_exit12
match_exit12:
  %r87.p = getelementptr inbounds [13 x i8], ptr @.str.23, i64 0, i64 0
  %r87 = ptrtoint ptr %r87.p to i64
  %r88 = load i64, ptr %slot.effect, align 8
  %r89 = call i64 @nova_rt_str_concat(i64 %r87, i64 %r88)
  %r90 = call i64 @nova_rt_print_any(i64 %r89)
  %r91 = load i64, ptr %slot.op, align 8
  %r92.p = getelementptr inbounds [4 x i8], ptr @.str.10, i64 0, i64 0
  %r92 = ptrtoint ptr %r92.p to i64
  %r93.p0 = inttoptr i64 %r91 to ptr
  %r93.p1 = inttoptr i64 %r92 to ptr
  %r93.sc = call i32 @strcmp(ptr %r93.p0, ptr %r93.p1)
  %r93.cmp = icmp eq i32 %r93.sc, 0
  %r93 = zext i1 %r93.cmp to i64
  store i64 %r93, ptr %slot.__sc_15, align 8
  %br_and_rhs16 = icmp ne i64 %r93, 0
  br i1 %br_and_rhs16, label %and_rhs16, label %and_merge17
and_rhs16:
  %r94 = load i64, ptr %slot.tk, align 8
  %r95.p = getelementptr inbounds [4 x i8], ptr @.str.0, i64 0, i64 0
  %r95 = ptrtoint ptr %r95.p to i64
  %r96.p0 = inttoptr i64 %r94 to ptr
  %r96.p1 = inttoptr i64 %r95 to ptr
  %r96.sc = call i32 @strcmp(ptr %r96.p0, ptr %r96.p1)
  %r96.cmp = icmp eq i32 %r96.sc, 0
  %r96 = zext i1 %r96.cmp to i64
  store i64 %r96, ptr %slot.__sc_15, align 8
  br label %and_merge17
and_merge17:
  %r97 = load i64, ptr %slot.__sc_15, align 8
  store i64 %r97, ptr %slot.__sc_18, align 8
  %br_and_rhs19 = icmp ne i64 %r97, 0
  br i1 %br_and_rhs19, label %and_rhs19, label %and_merge20
and_rhs19:
  %r98 = load i64, ptr %slot.effect, align 8
  %r99.p = getelementptr inbounds [5 x i8], ptr @.str.4, i64 0, i64 0
  %r99 = ptrtoint ptr %r99.p to i64
  %r100.p0 = inttoptr i64 %r98 to ptr
  %r100.p1 = inttoptr i64 %r99 to ptr
  %r100.sc = call i32 @strcmp(ptr %r100.p0, ptr %r100.p1)
  %r100.cmp = icmp eq i32 %r100.sc, 0
  %r100 = zext i1 %r100.cmp to i64
  store i64 %r100, ptr %slot.__sc_18, align 8
  br label %and_merge20
and_merge20:
  %r101 = load i64, ptr %slot.__sc_18, align 8
  %br_then21 = icmp ne i64 %r101, 0
  br i1 %br_then21, label %then21, label %else22
then21:
  %r102.p = getelementptr inbounds [41 x i8], ptr @.str.24, i64 0, i64 0
  %r102 = ptrtoint ptr %r102.p to i64
  %r103 = call i64 @nova_rt_print_any(i64 %r102)
  br label %endif23
else22:
  %r104.p = getelementptr inbounds [30 x i8], ptr @.str.25, i64 0, i64 0
  %r104 = ptrtoint ptr %r104.p to i64
  %r105 = call i64 @nova_rt_print_any(i64 %r104)
  br label %endif23
endif23:
  br label %match_exit9
match_fall11:
  br label %match_exit9
match_exit9:
  %r106 = load i64, ptr %slot.term, align 8
  %r107.ptr = inttoptr i64 %r106 to ptr
  %r107.gep = getelementptr i64, ptr %r107.ptr, i64 0
  %r107 = load i64, ptr %r107.gep, align 8
  %r108 = add i64 6952383966974, 0
  %r109.cmp = icmp eq i64 %r107, %r108
  %r109 = zext i1 %r109.cmp to i64
  %br_marm_025 = icmp ne i64 %r109, 0
  br i1 %br_marm_025, label %marm_025, label %match_fall26
marm_025:
  %r110.ptr = inttoptr i64 %r106 to ptr
  %r110.gep = getelementptr i64, ptr %r110.ptr, i64 1
  %r110 = load i64, ptr %r110.gep, align 8
  store i64 %r110, ptr %slot.op, align 8
  %r111.ptr = inttoptr i64 %r106 to ptr
  %r111.gep = getelementptr i64, ptr %r111.ptr, i64 2
  %r111 = load i64, ptr %r111.gep, align 8
  store i64 %r111, ptr %slot.dest, align 8
  %r112.ptr = inttoptr i64 %r106 to ptr
  %r112.gep = getelementptr i64, ptr %r112.ptr, i64 3
  %r112 = load i64, ptr %r112.gep, align 8
  store i64 %r112, ptr %slot.typ, align 8
  %r113.ptr = inttoptr i64 %r106 to ptr
  %r113.gep = getelementptr i64, ptr %r113.ptr, i64 4
  %r113 = load i64, ptr %r113.gep, align 8
  store i64 %r113, ptr %slot.args, align 8
  %r114.ptr = inttoptr i64 %r106 to ptr
  %r114.gep = getelementptr i64, ptr %r114.ptr, i64 5
  %r114 = load i64, ptr %r114.gep, align 8
  store i64 %r114, ptr %slot.value, align 8
  %r115.ptr = inttoptr i64 %r106 to ptr
  %r115.gep = getelementptr i64, ptr %r115.ptr, i64 6
  %r115 = load i64, ptr %r115.gep, align 8
  store i64 %r115, ptr %slot.num, align 8
  %r116.ptr = inttoptr i64 %r106 to ptr
  %r116.gep = getelementptr i64, ptr %r116.ptr, i64 7
  %r116 = load i64, ptr %r116.gep, align 8
  store i64 %r116, ptr %slot.effect, align 8
  %r117.p = getelementptr inbounds [13 x i8], ptr @.str.26, i64 0, i64 0
  %r117 = ptrtoint ptr %r117.p to i64
  %r118 = load i64, ptr %slot.op, align 8
  %r119 = call i64 @nova_rt_str_concat(i64 %r117, i64 %r118)
  %r120 = call i64 @nova_rt_print_any(i64 %r119)
  %r121 = load i64, ptr %slot.op, align 8
  %r122.p = getelementptr inbounds [7 x i8], ptr @.str.13, i64 0, i64 0
  %r122 = ptrtoint ptr %r122.p to i64
  %r123.p0 = inttoptr i64 %r121 to ptr
  %r123.p1 = inttoptr i64 %r122 to ptr
  %r123.sc = call i32 @strcmp(ptr %r123.p0, ptr %r123.p1)
  %r123.cmp = icmp eq i32 %r123.sc, 0
  %r123 = zext i1 %r123.cmp to i64
  %br_then27 = icmp ne i64 %r123, 0
  br i1 %br_then27, label %then27, label %else28
then27:
  %r124.p = getelementptr inbounds [33 x i8], ptr @.str.27, i64 0, i64 0
  %r124 = ptrtoint ptr %r124.p to i64
  %r125 = call i64 @nova_rt_print_any(i64 %r124)
  br label %endif29
else28:
  br label %endif29
endif29:
  br label %match_exit24
match_fall26:
  br label %match_exit24
match_exit24:
  br label %match_exit6
match_fall8:
  br label %match_exit6
match_exit6:
  br label %match_exit0
match_fall2:
  br label %match_exit0
match_exit0:
  ret i64 0
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

; String constants
@.str.0 = private unnamed_addr constant [4 x i8] c"int\00"
@.str.1 = private unnamed_addr constant [1 x i8] c"\00"
@.str.2 = private unnamed_addr constant [4 x i8] c"any\00"
@.str.3 = private unnamed_addr constant [5 x i8] c"void\00"
@.str.4 = private unnamed_addr constant [5 x i8] c"pure\00"
@.str.5 = private unnamed_addr constant [2 x i8] c"a\00"
@.str.6 = private unnamed_addr constant [2 x i8] c"b\00"
@.str.7 = private unnamed_addr constant [10 x i8] c"slot_load\00"
@.str.8 = private unnamed_addr constant [4 x i8] c"%r0\00"
@.str.9 = private unnamed_addr constant [4 x i8] c"%r1\00"
@.str.10 = private unnamed_addr constant [4 x i8] c"add\00"
@.str.11 = private unnamed_addr constant [4 x i8] c"%r2\00"
@.str.12 = private unnamed_addr constant [2 x i8] c"+\00"
@.str.13 = private unnamed_addr constant [7 x i8] c"return\00"
@.str.14 = private unnamed_addr constant [6 x i8] c"entry\00"
@.str.15 = private unnamed_addr constant [5 x i8] c"fn: \00"
@.str.16 = private unnamed_addr constant [9 x i8] c"params: \00"
@.str.17 = private unnamed_addr constant [10 x i8] c"returns: \00"
@.str.18 = private unnamed_addr constant [9 x i8] c"blocks: \00"
@.str.19 = private unnamed_addr constant [8 x i8] c"block: \00"
@.str.20 = private unnamed_addr constant [8 x i8] c"insts: \00"
@.str.21 = private unnamed_addr constant [9 x i8] c"add op: \00"
@.str.22 = private unnamed_addr constant [11 x i8] c"add type: \00"
@.str.23 = private unnamed_addr constant [13 x i8] c"add effect: \00"
@.str.24 = private unnamed_addr constant [41 x i8] c"PASS: Direct integer add (zero overhead)\00"
@.str.25 = private unnamed_addr constant [30 x i8] c"FAIL: Expected direct int add\00"
@.str.26 = private unnamed_addr constant [13 x i8] c"terminator: \00"
@.str.27 = private unnamed_addr constant [33 x i8] c"PASS: Function returns correctly\00"

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
