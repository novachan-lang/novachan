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

define i64 @ir_type_int() nounwind {
entry:
  %r0 = call ptr @nova_rt_struct_alloc(i64 32)
  %r1 = getelementptr inbounds [4 x i8], ptr @.str.0, i64 0, i64 0
  %r2 = ptrtoint ptr %r1 to i64
  %t3 = getelementptr i64, ptr %r0, i64 0
  store i64 %r2, ptr %t3, align 8
  %r4 = getelementptr inbounds [1 x i8], ptr @.str.1, i64 0, i64 0
  %r5 = ptrtoint ptr %r4 to i64
  %t6 = getelementptr i64, ptr %r0, i64 1
  store i64 %r5, ptr %t6, align 8
  %r7 = call i64 @nova_rt_list_create()
  %t8 = getelementptr i64, ptr %r0, i64 2
  store i64 %r7, ptr %t8, align 8
  %t9 = getelementptr i64, ptr %r0, i64 3
  store i64 0, ptr %t9, align 8
  %r10 = ptrtoint ptr %r0 to i64
  ret i64 %r10
}

define i64 @ir_type_str() nounwind {
entry:
  %r0 = call ptr @nova_rt_struct_alloc(i64 32)
  %r1 = getelementptr inbounds [4 x i8], ptr @.str.2, i64 0, i64 0
  %r2 = ptrtoint ptr %r1 to i64
  %t3 = getelementptr i64, ptr %r0, i64 0
  store i64 %r2, ptr %t3, align 8
  %r4 = getelementptr inbounds [1 x i8], ptr @.str.1, i64 0, i64 0
  %r5 = ptrtoint ptr %r4 to i64
  %t6 = getelementptr i64, ptr %r0, i64 1
  store i64 %r5, ptr %t6, align 8
  %r7 = call i64 @nova_rt_list_create()
  %t8 = getelementptr i64, ptr %r0, i64 2
  store i64 %r7, ptr %t8, align 8
  %t9 = getelementptr i64, ptr %r0, i64 3
  store i64 0, ptr %t9, align 8
  %r10 = ptrtoint ptr %r0 to i64
  ret i64 %r10
}

define i64 @ir_type_any() nounwind {
entry:
  %r0 = call ptr @nova_rt_struct_alloc(i64 32)
  %r1 = getelementptr inbounds [4 x i8], ptr @.str.3, i64 0, i64 0
  %r2 = ptrtoint ptr %r1 to i64
  %t3 = getelementptr i64, ptr %r0, i64 0
  store i64 %r2, ptr %t3, align 8
  %r4 = getelementptr inbounds [1 x i8], ptr @.str.1, i64 0, i64 0
  %r5 = ptrtoint ptr %r4 to i64
  %t6 = getelementptr i64, ptr %r0, i64 1
  store i64 %r5, ptr %t6, align 8
  %r7 = call i64 @nova_rt_list_create()
  %t8 = getelementptr i64, ptr %r0, i64 2
  store i64 %r7, ptr %t8, align 8
  %t9 = getelementptr i64, ptr %r0, i64 3
  store i64 0, ptr %t9, align 8
  %r10 = ptrtoint ptr %r0 to i64
  ret i64 %r10
}

define i64 @ir_type_void() nounwind {
entry:
  %r0 = call ptr @nova_rt_struct_alloc(i64 32)
  %r1 = getelementptr inbounds [5 x i8], ptr @.str.4, i64 0, i64 0
  %r2 = ptrtoint ptr %r1 to i64
  %t3 = getelementptr i64, ptr %r0, i64 0
  store i64 %r2, ptr %t3, align 8
  %r4 = getelementptr inbounds [1 x i8], ptr @.str.1, i64 0, i64 0
  %r5 = ptrtoint ptr %r4 to i64
  %t6 = getelementptr i64, ptr %r0, i64 1
  store i64 %r5, ptr %t6, align 8
  %r7 = call i64 @nova_rt_list_create()
  %t8 = getelementptr i64, ptr %r0, i64 2
  store i64 %r7, ptr %t8, align 8
  %t9 = getelementptr i64, ptr %r0, i64 3
  store i64 0, ptr %t9, align 8
  %r10 = ptrtoint ptr %r0 to i64
  ret i64 %r10
}

define i64 @new_ir_builder() nounwind {
entry:
  %r0 = call ptr @nova_rt_struct_alloc(i64 56)
  %r1 = call i64 @nova_rt_list_create()
  %t2 = getelementptr i64, ptr %r0, i64 0
  store i64 %r1, ptr %t2, align 8
  %t3 = getelementptr i64, ptr %r0, i64 1
  store i64 0, ptr %t3, align 8
  %r4 = call i64 @nova_rt_list_create()
  %t5 = getelementptr i64, ptr %r0, i64 2
  store i64 %r4, ptr %t5, align 8
  %r6 = getelementptr inbounds [6 x i8], ptr @.str.5, i64 0, i64 0
  %r7 = ptrtoint ptr %r6 to i64
  %t8 = getelementptr i64, ptr %r0, i64 3
  store i64 %r7, ptr %t8, align 8
  %r9 = call i64 @nova_rt_dict_create()
  %t10 = getelementptr i64, ptr %r0, i64 4
  store i64 %r9, ptr %t10, align 8
  %r11 = call i64 @nova_rt_list_create()
  %t12 = getelementptr i64, ptr %r0, i64 5
  store i64 %r11, ptr %t12, align 8
  %r13 = call i64 @nova_rt_dict_create()
  %t14 = getelementptr i64, ptr %r0, i64 6
  store i64 %r13, ptr %t14, align 8
  %r15 = ptrtoint ptr %r0 to i64
  ret i64 %r15
}

define i64 @ir_fresh_reg(i64 %p0) nounwind {
entry:
  %slot.b = alloca i64, align 8
  store i64 %p0, ptr %slot.b, align 8
  %slot.r = alloca i64, align 8
  store i64 0, ptr %slot.r, align 8
  %r0 = getelementptr inbounds [3 x i8], ptr @.str.6, i64 0, i64 0
  %r1 = ptrtoint ptr %r0 to i64
  %r2 = load i64, ptr %slot.b, align 8
  %t4 = inttoptr i64 %r2 to ptr
  %t5 = getelementptr i64, ptr %t4, i64 1
  %r3 = load i64, ptr %t5, align 8
  %r6 = call i64 @nova_rt_int_to_str(i64 %r3)
  %r7 = call i64 @nova_rt_add(i64 %r1, i64 %r6)
  store i64 %r7, ptr %slot.r, align 8
  %r8 = load i64, ptr %slot.b, align 8
  %t10 = inttoptr i64 %r8 to ptr
  %t11 = getelementptr i64, ptr %t10, i64 1
  %r9 = load i64, ptr %t11, align 8
  %r12 = call i64 @nova_rt_add(i64 %r9, i64 1)
  %r13 = load i64, ptr %slot.b, align 8
  %t14 = inttoptr i64 %r13 to ptr
  %t15 = getelementptr i64, ptr %t14, i64 1
  store i64 %r12, ptr %t15, align 8
  %r16 = load i64, ptr %slot.r, align 8
  ret i64 %r16
}

define i64 @ir_emit(i64 %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4, i64 %p5, i64 %p6) nounwind {
entry:
  %slot.b = alloca i64, align 8
  store i64 %p0, ptr %slot.b, align 8
  %slot.op = alloca i64, align 8
  store i64 %p1, ptr %slot.op, align 8
  %slot.dest = alloca i64, align 8
  store i64 %p2, ptr %slot.dest, align 8
  %slot.typ = alloca i64, align 8
  store i64 %p3, ptr %slot.typ, align 8
  %slot.args = alloca i64, align 8
  store i64 %p4, ptr %slot.args, align 8
  %slot.value = alloca i64, align 8
  store i64 %p5, ptr %slot.value, align 8
  %slot.num = alloca i64, align 8
  store i64 %p6, ptr %slot.num, align 8
  %r0 = load i64, ptr %slot.b, align 8
  %t2 = inttoptr i64 %r0 to ptr
  %t3 = getelementptr i64, ptr %t2, i64 0
  %r1 = load i64, ptr %t3, align 8
  %r4 = call ptr @nova_rt_struct_alloc(i64 56)
  %r5 = load i64, ptr %slot.op, align 8
  %t6 = getelementptr i64, ptr %r4, i64 0
  store i64 %r5, ptr %t6, align 8
  %r7 = load i64, ptr %slot.dest, align 8
  %t8 = getelementptr i64, ptr %r4, i64 1
  store i64 %r7, ptr %t8, align 8
  %r9 = load i64, ptr %slot.typ, align 8
  %t10 = getelementptr i64, ptr %r4, i64 2
  store i64 %r9, ptr %t10, align 8
  %r11 = load i64, ptr %slot.args, align 8
  %t12 = getelementptr i64, ptr %r4, i64 3
  store i64 %r11, ptr %t12, align 8
  %r13 = load i64, ptr %slot.value, align 8
  %t14 = getelementptr i64, ptr %r4, i64 4
  store i64 %r13, ptr %t14, align 8
  %r15 = load i64, ptr %slot.num, align 8
  %t16 = getelementptr i64, ptr %r4, i64 5
  store i64 %r15, ptr %t16, align 8
  %r17 = getelementptr inbounds [5 x i8], ptr @.str.7, i64 0, i64 0
  %r18 = ptrtoint ptr %r17 to i64
  %t19 = getelementptr i64, ptr %r4, i64 6
  store i64 %r18, ptr %t19, align 8
  %r20 = ptrtoint ptr %r4 to i64
  %r21 = call i64 @nova_rt_list_append(i64 %r1, i64 %r20)
  ret i64 %r21
}

define i64 @ir_emit_effect(i64 %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4, i64 %p5, i64 %p6) nounwind {
entry:
  %slot.b = alloca i64, align 8
  store i64 %p0, ptr %slot.b, align 8
  %slot.op = alloca i64, align 8
  store i64 %p1, ptr %slot.op, align 8
  %slot.dest = alloca i64, align 8
  store i64 %p2, ptr %slot.dest, align 8
  %slot.typ = alloca i64, align 8
  store i64 %p3, ptr %slot.typ, align 8
  %slot.args = alloca i64, align 8
  store i64 %p4, ptr %slot.args, align 8
  %slot.value = alloca i64, align 8
  store i64 %p5, ptr %slot.value, align 8
  %slot.num = alloca i64, align 8
  store i64 %p6, ptr %slot.num, align 8
  %r0 = load i64, ptr %slot.b, align 8
  %t2 = inttoptr i64 %r0 to ptr
  %t3 = getelementptr i64, ptr %t2, i64 0
  %r1 = load i64, ptr %t3, align 8
  %r4 = call ptr @nova_rt_struct_alloc(i64 56)
  %r5 = load i64, ptr %slot.op, align 8
  %t6 = getelementptr i64, ptr %r4, i64 0
  store i64 %r5, ptr %t6, align 8
  %r7 = load i64, ptr %slot.dest, align 8
  %t8 = getelementptr i64, ptr %r4, i64 1
  store i64 %r7, ptr %t8, align 8
  %r9 = load i64, ptr %slot.typ, align 8
  %t10 = getelementptr i64, ptr %r4, i64 2
  store i64 %r9, ptr %t10, align 8
  %r11 = load i64, ptr %slot.args, align 8
  %t12 = getelementptr i64, ptr %r4, i64 3
  store i64 %r11, ptr %t12, align 8
  %r13 = load i64, ptr %slot.value, align 8
  %t14 = getelementptr i64, ptr %r4, i64 4
  store i64 %r13, ptr %t14, align 8
  %r15 = load i64, ptr %slot.num, align 8
  %t16 = getelementptr i64, ptr %r4, i64 5
  store i64 %r15, ptr %t16, align 8
  %r17 = getelementptr inbounds [12 x i8], ptr @.str.8, i64 0, i64 0
  %r18 = ptrtoint ptr %r17 to i64
  %t19 = getelementptr i64, ptr %r4, i64 6
  store i64 %r18, ptr %t19, align 8
  %r20 = ptrtoint ptr %r4 to i64
  %r21 = call i64 @nova_rt_list_append(i64 %r1, i64 %r20)
  ret i64 %r21
}

define i64 @ir_finish_block(i64 %p0, i64 %p1) nounwind {
entry:
  %slot.b = alloca i64, align 8
  store i64 %p0, ptr %slot.b, align 8
  %slot.terminator = alloca i64, align 8
  store i64 %p1, ptr %slot.terminator, align 8
  %slot.block = alloca i64, align 8
  store i64 0, ptr %slot.block, align 8
  %r0 = call ptr @nova_rt_struct_alloc(i64 24)
  %r1 = load i64, ptr %slot.b, align 8
  %t3 = inttoptr i64 %r1 to ptr
  %t4 = getelementptr i64, ptr %t3, i64 3
  %r2 = load i64, ptr %t4, align 8
  %t5 = getelementptr i64, ptr %r0, i64 0
  store i64 %r2, ptr %t5, align 8
  %r6 = load i64, ptr %slot.b, align 8
  %t8 = inttoptr i64 %r6 to ptr
  %t9 = getelementptr i64, ptr %t8, i64 0
  %r7 = load i64, ptr %t9, align 8
  %t10 = getelementptr i64, ptr %r0, i64 1
  store i64 %r7, ptr %t10, align 8
  %r11 = load i64, ptr %slot.terminator, align 8
  %t12 = getelementptr i64, ptr %r0, i64 2
  store i64 %r11, ptr %t12, align 8
  %r13 = ptrtoint ptr %r0 to i64
  store i64 %r13, ptr %slot.block, align 8
  %r14 = load i64, ptr %slot.b, align 8
  %t16 = inttoptr i64 %r14 to ptr
  %t17 = getelementptr i64, ptr %t16, i64 2
  %r15 = load i64, ptr %t17, align 8
  %r18 = load i64, ptr %slot.block, align 8
  %r19 = call i64 @nova_rt_list_append(i64 %r15, i64 %r18)
  %r20 = call i64 @nova_rt_list_create()
  %r21 = load i64, ptr %slot.b, align 8
  %t22 = inttoptr i64 %r21 to ptr
  %t23 = getelementptr i64, ptr %t22, i64 0
  store i64 %r20, ptr %t23, align 8
  ret i64 0
}

define i64 @ir_start_block(i64 %p0, i64 %p1) nounwind {
entry:
  %slot.b = alloca i64, align 8
  store i64 %p0, ptr %slot.b, align 8
  %slot.label = alloca i64, align 8
  store i64 %p1, ptr %slot.label, align 8
  %r0 = load i64, ptr %slot.label, align 8
  %r1 = load i64, ptr %slot.b, align 8
  %t2 = inttoptr i64 %r1 to ptr
  %t3 = getelementptr i64, ptr %t2, i64 3
  store i64 %r0, ptr %t3, align 8
  ret i64 0
}

define i64 @ir_lower_expr(i64 %p0, i64 %p1) nounwind {
entry:
  %slot.b = alloca i64, align 8
  store i64 %p0, ptr %slot.b, align 8
  %slot.expr = alloca i64, align 8
  store i64 %p1, ptr %slot.expr, align 8
  %slot.tag = alloca i64, align 8
  store i64 0, ptr %slot.tag, align 8
  %slot.value = alloca i64, align 8
  store i64 0, ptr %slot.value, align 8
  %slot.num = alloca i64, align 8
  store i64 0, ptr %slot.num, align 8
  %slot.children = alloca i64, align 8
  store i64 0, ptr %slot.children, align 8
  %slot.fields = alloca i64, align 8
  store i64 0, ptr %slot.fields, align 8
  %slot.dest = alloca i64, align 8
  store i64 0, ptr %slot.dest, align 8
  %slot.left = alloca i64, align 8
  store i64 0, ptr %slot.left, align 8
  %slot.right = alloca i64, align 8
  store i64 0, ptr %slot.right, align 8
  %slot.operand = alloca i64, align 8
  store i64 0, ptr %slot.operand, align 8
  %slot.fn_name = alloca i64, align 8
  store i64 0, ptr %slot.fn_name, align 8
  %slot.arg_regs = alloca i64, align 8
  store i64 0, ptr %slot.arg_regs, align 8
  %slot.child = alloca i64, align 8
  store i64 0, ptr %slot.child, align 8
  %slot.elem_regs = alloca i64, align 8
  store i64 0, ptr %slot.elem_regs, align 8
  %slot.obj = alloca i64, align 8
  store i64 0, ptr %slot.obj, align 8
  %slot.idx = alloca i64, align 8
  store i64 0, ptr %slot.idx, align 8
  %r0 = load i64, ptr %slot.expr, align 8
  %t1 = inttoptr i64 %r0 to ptr
  %t2 = getelementptr i64, ptr %t1, i64 0
  %r3 = load i64, ptr %t2, align 8
  store i64 %r3, ptr %slot.tag, align 8
  %t4 = getelementptr i64, ptr %t1, i64 1
  %r5 = load i64, ptr %t4, align 8
  store i64 %r5, ptr %slot.value, align 8
  %t6 = getelementptr i64, ptr %t1, i64 2
  %r7 = load i64, ptr %t6, align 8
  store i64 %r7, ptr %slot.num, align 8
  %t8 = getelementptr i64, ptr %t1, i64 3
  %r9 = load i64, ptr %t8, align 8
  store i64 %r9, ptr %slot.children, align 8
  %t10 = getelementptr i64, ptr %t1, i64 4
  %r11 = load i64, ptr %t10, align 8
  store i64 %r11, ptr %slot.fields, align 8
  %r12 = load i64, ptr %slot.tag, align 8
  %r13 = getelementptr inbounds [4 x i8], ptr @.str.0, i64 0, i64 0
  %r14 = ptrtoint ptr %r13 to i64
  %t16 = call i64 @nova_rt_eq(i64 %r12, i64 %r14)
  %r15 = and i64 %t16, 1
  %t17 = icmp ne i64 %t16, 0
  br i1 %t17, label %then0, label %else1
then0:
  %r18 = load i64, ptr %slot.b, align 8
  %r19 = call i64 @ir_fresh_reg(i64 %r18)
  store i64 %r19, ptr %slot.dest, align 8
  %r20 = load i64, ptr %slot.b, align 8
  %r21 = getelementptr inbounds [10 x i8], ptr @.str.9, i64 0, i64 0
  %r22 = ptrtoint ptr %r21 to i64
  %r23 = load i64, ptr %slot.dest, align 8
  %r24 = call i64 @ir_type_int()
  %r25 = call i64 @nova_rt_list_create()
  %r26 = load i64, ptr %slot.num, align 8
  %r27 = call i64 @nova_rt_int_to_str(i64 %r26)
  %r28 = load i64, ptr %slot.num, align 8
  %r29 = call i64 @ir_emit(i64 %r20, i64 %r22, i64 %r23, i64 %r24, i64 %r25, i64 %r27, i64 %r28)
  %r30 = load i64, ptr %slot.dest, align 8
  ret i64 %r30
  br label %merge2
else1:
  %r31 = load i64, ptr %slot.tag, align 8
  %r32 = getelementptr inbounds [4 x i8], ptr @.str.2, i64 0, i64 0
  %r33 = ptrtoint ptr %r32 to i64
  %t35 = call i64 @nova_rt_eq(i64 %r31, i64 %r33)
  %r34 = and i64 %t35, 1
  %t36 = icmp ne i64 %t35, 0
  br i1 %t36, label %then3, label %else4
then3:
  %r37 = load i64, ptr %slot.b, align 8
  %r38 = call i64 @ir_fresh_reg(i64 %r37)
  store i64 %r38, ptr %slot.dest, align 8
  %r39 = load i64, ptr %slot.b, align 8
  %t41 = inttoptr i64 %r39 to ptr
  %t42 = getelementptr i64, ptr %t41, i64 2
  %r40 = load i64, ptr %t42, align 8
  %r43 = load i64, ptr %slot.value, align 8
  %r44 = call i64 @nova_rt_contains(i64 %r40, i64 %r43)
  %t46 = icmp eq i64 %r44, 0
  %r45 = zext i1 %t46 to i64
  %t47 = icmp ne i64 %r45, 0
  br i1 %t47, label %then6, label %else7
then6:
  %r48 = load i64, ptr %slot.b, align 8
  %t50 = inttoptr i64 %r48 to ptr
  %t51 = getelementptr i64, ptr %t50, i64 5
  %r49 = load i64, ptr %t51, align 8
  %r52 = load i64, ptr %slot.value, align 8
  %r53 = call i64 @nova_rt_list_append(i64 %r49, i64 %r52)
  %r54 = load i64, ptr %slot.b, align 8
  %t56 = inttoptr i64 %r54 to ptr
  %t57 = getelementptr i64, ptr %t56, i64 5
  %r55 = load i64, ptr %t57, align 8
  %r58 = call i64 @nova_rt_len_any(i64 %r55)
  %r59 = sub i64 %r58, 1
  %r60 = load i64, ptr %slot.b, align 8
  %t62 = inttoptr i64 %r60 to ptr
  %t63 = getelementptr i64, ptr %t62, i64 2
  %r61 = load i64, ptr %t63, align 8
  %r64 = load i64, ptr %slot.value, align 8
  %t65 = call i64 @nova_rt_index_set(i64 %r61, i64 %r64, i64 %r59)
  br label %merge8
else7:
  br label %merge8
merge8:
  %r66 = load i64, ptr %slot.b, align 8
  %r67 = getelementptr inbounds [10 x i8], ptr @.str.10, i64 0, i64 0
  %r68 = ptrtoint ptr %r67 to i64
  %r69 = load i64, ptr %slot.dest, align 8
  %r70 = call i64 @ir_type_str()
  %r71 = call i64 @nova_rt_list_create()
  %r72 = load i64, ptr %slot.value, align 8
  %r73 = call i64 @ir_emit(i64 %r66, i64 %r68, i64 %r69, i64 %r70, i64 %r71, i64 %r72, i64 0)
  %r74 = load i64, ptr %slot.dest, align 8
  ret i64 %r74
  br label %merge5
else4:
  %r75 = load i64, ptr %slot.tag, align 8
  %r76 = getelementptr inbounds [6 x i8], ptr @.str.11, i64 0, i64 0
  %r77 = ptrtoint ptr %r76 to i64
  %t79 = call i64 @nova_rt_eq(i64 %r75, i64 %r77)
  %r78 = and i64 %t79, 1
  %t80 = icmp ne i64 %t79, 0
  br i1 %t80, label %then9, label %else10
then9:
  %r81 = load i64, ptr %slot.b, align 8
  %r82 = call i64 @ir_fresh_reg(i64 %r81)
  store i64 %r82, ptr %slot.dest, align 8
  %r83 = load i64, ptr %slot.b, align 8
  %r84 = getelementptr inbounds [10 x i8], ptr @.str.12, i64 0, i64 0
  %r85 = ptrtoint ptr %r84 to i64
  %r86 = load i64, ptr %slot.dest, align 8
  %r87 = call i64 @ir_type_any()
  %r88 = call i64 @nova_rt_list_create()
  %r89 = load i64, ptr %slot.value, align 8
  %r90 = call i64 @ir_emit(i64 %r83, i64 %r85, i64 %r86, i64 %r87, i64 %r88, i64 %r89, i64 0)
  %r91 = load i64, ptr %slot.dest, align 8
  ret i64 %r91
  br label %merge11
else10:
  %r92 = load i64, ptr %slot.tag, align 8
  %r93 = getelementptr inbounds [6 x i8], ptr @.str.13, i64 0, i64 0
  %r94 = ptrtoint ptr %r93 to i64
  %t96 = call i64 @nova_rt_eq(i64 %r92, i64 %r94)
  %r95 = and i64 %t96, 1
  %t97 = icmp ne i64 %t96, 0
  br i1 %t97, label %then12, label %else13
then12:
  %r98 = load i64, ptr %slot.b, align 8
  %r99 = load i64, ptr %slot.children, align 8
  %r100 = call i64 @nova_rt_index_get(i64 %r99, i64 0)
  %r101 = call i64 @ir_lower_expr(i64 %r98, i64 %r100)
  store i64 %r101, ptr %slot.left, align 8
  %r102 = load i64, ptr %slot.b, align 8
  %r103 = load i64, ptr %slot.children, align 8
  %r104 = call i64 @nova_rt_index_get(i64 %r103, i64 1)
  %r105 = call i64 @ir_lower_expr(i64 %r102, i64 %r104)
  store i64 %r105, ptr %slot.right, align 8
  %r106 = load i64, ptr %slot.b, align 8
  %r107 = call i64 @ir_fresh_reg(i64 %r106)
  store i64 %r107, ptr %slot.dest, align 8
  %r108 = load i64, ptr %slot.value, align 8
  %r109 = getelementptr inbounds [2 x i8], ptr @.str.14, i64 0, i64 0
  %r110 = ptrtoint ptr %r109 to i64
  %t112 = call i64 @nova_rt_eq(i64 %r108, i64 %r110)
  %r111 = and i64 %t112, 1
  %t113 = icmp ne i64 %t112, 0
  br i1 %t113, label %then15, label %else16
then15:
  %r114 = load i64, ptr %slot.b, align 8
  %r115 = getelementptr inbounds [4 x i8], ptr @.str.15, i64 0, i64 0
  %r116 = ptrtoint ptr %r115 to i64
  %r117 = load i64, ptr %slot.dest, align 8
  %r118 = call i64 @ir_type_any()
  %r119 = call i64 @nova_rt_list_create()
  %r120 = load i64, ptr %slot.left, align 8
  %t121 = call i64 @nova_rt_list_append(i64 %r119, i64 %r120)
  %r122 = load i64, ptr %slot.right, align 8
  %t123 = call i64 @nova_rt_list_append(i64 %r119, i64 %r122)
  %r124 = getelementptr inbounds [2 x i8], ptr @.str.14, i64 0, i64 0
  %r125 = ptrtoint ptr %r124 to i64
  %r126 = call i64 @ir_emit(i64 %r114, i64 %r116, i64 %r117, i64 %r118, i64 %r119, i64 %r125, i64 0)
  br label %merge17
else16:
  %r127 = load i64, ptr %slot.value, align 8
  %r128 = getelementptr inbounds [2 x i8], ptr @.str.16, i64 0, i64 0
  %r129 = ptrtoint ptr %r128 to i64
  %t131 = call i64 @nova_rt_eq(i64 %r127, i64 %r129)
  %r130 = and i64 %t131, 1
  %t132 = icmp ne i64 %t131, 0
  br i1 %t132, label %then18, label %else19
then18:
  %r133 = load i64, ptr %slot.b, align 8
  %r134 = getelementptr inbounds [4 x i8], ptr @.str.17, i64 0, i64 0
  %r135 = ptrtoint ptr %r134 to i64
  %r136 = load i64, ptr %slot.dest, align 8
  %r137 = call i64 @ir_type_any()
  %r138 = call i64 @nova_rt_list_create()
  %r139 = load i64, ptr %slot.left, align 8
  %t140 = call i64 @nova_rt_list_append(i64 %r138, i64 %r139)
  %r141 = load i64, ptr %slot.right, align 8
  %t142 = call i64 @nova_rt_list_append(i64 %r138, i64 %r141)
  %r143 = getelementptr inbounds [2 x i8], ptr @.str.16, i64 0, i64 0
  %r144 = ptrtoint ptr %r143 to i64
  %r145 = call i64 @ir_emit(i64 %r133, i64 %r135, i64 %r136, i64 %r137, i64 %r138, i64 %r144, i64 0)
  br label %merge20
else19:
  %r146 = load i64, ptr %slot.value, align 8
  %r147 = getelementptr inbounds [2 x i8], ptr @.str.18, i64 0, i64 0
  %r148 = ptrtoint ptr %r147 to i64
  %t150 = call i64 @nova_rt_eq(i64 %r146, i64 %r148)
  %r149 = and i64 %t150, 1
  %t151 = icmp ne i64 %t150, 0
  br i1 %t151, label %then21, label %else22
then21:
  %r152 = load i64, ptr %slot.b, align 8
  %r153 = getelementptr inbounds [4 x i8], ptr @.str.19, i64 0, i64 0
  %r154 = ptrtoint ptr %r153 to i64
  %r155 = load i64, ptr %slot.dest, align 8
  %r156 = call i64 @ir_type_any()
  %r157 = call i64 @nova_rt_list_create()
  %r158 = load i64, ptr %slot.left, align 8
  %t159 = call i64 @nova_rt_list_append(i64 %r157, i64 %r158)
  %r160 = load i64, ptr %slot.right, align 8
  %t161 = call i64 @nova_rt_list_append(i64 %r157, i64 %r160)
  %r162 = getelementptr inbounds [2 x i8], ptr @.str.18, i64 0, i64 0
  %r163 = ptrtoint ptr %r162 to i64
  %r164 = call i64 @ir_emit(i64 %r152, i64 %r154, i64 %r155, i64 %r156, i64 %r157, i64 %r163, i64 0)
  br label %merge23
else22:
  %r165 = load i64, ptr %slot.value, align 8
  %r166 = getelementptr inbounds [2 x i8], ptr @.str.20, i64 0, i64 0
  %r167 = ptrtoint ptr %r166 to i64
  %t169 = call i64 @nova_rt_eq(i64 %r165, i64 %r167)
  %r168 = and i64 %t169, 1
  %t170 = icmp ne i64 %t169, 0
  br i1 %t170, label %then24, label %else25
then24:
  %r171 = load i64, ptr %slot.b, align 8
  %r172 = getelementptr inbounds [4 x i8], ptr @.str.21, i64 0, i64 0
  %r173 = ptrtoint ptr %r172 to i64
  %r174 = load i64, ptr %slot.dest, align 8
  %r175 = call i64 @ir_type_any()
  %r176 = call i64 @nova_rt_list_create()
  %r177 = load i64, ptr %slot.left, align 8
  %t178 = call i64 @nova_rt_list_append(i64 %r176, i64 %r177)
  %r179 = load i64, ptr %slot.right, align 8
  %t180 = call i64 @nova_rt_list_append(i64 %r176, i64 %r179)
  %r181 = getelementptr inbounds [2 x i8], ptr @.str.20, i64 0, i64 0
  %r182 = ptrtoint ptr %r181 to i64
  %r183 = call i64 @ir_emit(i64 %r171, i64 %r173, i64 %r174, i64 %r175, i64 %r176, i64 %r182, i64 0)
  br label %merge26
else25:
  %r184 = load i64, ptr %slot.value, align 8
  %r185 = getelementptr inbounds [2 x i8], ptr @.str.22, i64 0, i64 0
  %r186 = ptrtoint ptr %r185 to i64
  %t188 = call i64 @nova_rt_eq(i64 %r184, i64 %r186)
  %r187 = and i64 %t188, 1
  %t189 = icmp ne i64 %t188, 0
  br i1 %t189, label %then27, label %else28
then27:
  %r190 = load i64, ptr %slot.b, align 8
  %r191 = getelementptr inbounds [4 x i8], ptr @.str.23, i64 0, i64 0
  %r192 = ptrtoint ptr %r191 to i64
  %r193 = load i64, ptr %slot.dest, align 8
  %r194 = call i64 @ir_type_any()
  %r195 = call i64 @nova_rt_list_create()
  %r196 = load i64, ptr %slot.left, align 8
  %t197 = call i64 @nova_rt_list_append(i64 %r195, i64 %r196)
  %r198 = load i64, ptr %slot.right, align 8
  %t199 = call i64 @nova_rt_list_append(i64 %r195, i64 %r198)
  %r200 = getelementptr inbounds [2 x i8], ptr @.str.22, i64 0, i64 0
  %r201 = ptrtoint ptr %r200 to i64
  %r202 = call i64 @ir_emit(i64 %r190, i64 %r192, i64 %r193, i64 %r194, i64 %r195, i64 %r201, i64 0)
  br label %merge29
else28:
  %r203 = load i64, ptr %slot.value, align 8
  %r204 = getelementptr inbounds [3 x i8], ptr @.str.24, i64 0, i64 0
  %r205 = ptrtoint ptr %r204 to i64
  %t207 = call i64 @nova_rt_eq(i64 %r203, i64 %r205)
  %r206 = and i64 %t207, 1
  %t208 = icmp ne i64 %t207, 0
  br i1 %t208, label %then30, label %else31
then30:
  %r209 = load i64, ptr %slot.b, align 8
  %r210 = getelementptr inbounds [3 x i8], ptr @.str.25, i64 0, i64 0
  %r211 = ptrtoint ptr %r210 to i64
  %r212 = load i64, ptr %slot.dest, align 8
  %r213 = call i64 @ir_type_any()
  %r214 = call i64 @nova_rt_list_create()
  %r215 = load i64, ptr %slot.left, align 8
  %t216 = call i64 @nova_rt_list_append(i64 %r214, i64 %r215)
  %r217 = load i64, ptr %slot.right, align 8
  %t218 = call i64 @nova_rt_list_append(i64 %r214, i64 %r217)
  %r219 = getelementptr inbounds [3 x i8], ptr @.str.24, i64 0, i64 0
  %r220 = ptrtoint ptr %r219 to i64
  %r221 = call i64 @ir_emit(i64 %r209, i64 %r211, i64 %r212, i64 %r213, i64 %r214, i64 %r220, i64 0)
  br label %merge32
else31:
  %r222 = load i64, ptr %slot.value, align 8
  %r223 = getelementptr inbounds [3 x i8], ptr @.str.26, i64 0, i64 0
  %r224 = ptrtoint ptr %r223 to i64
  %t226 = call i64 @nova_rt_eq(i64 %r222, i64 %r224)
  %r225 = and i64 %t226, 1
  %t227 = icmp ne i64 %t226, 0
  br i1 %t227, label %then33, label %else34
then33:
  %r228 = load i64, ptr %slot.b, align 8
  %r229 = getelementptr inbounds [4 x i8], ptr @.str.27, i64 0, i64 0
  %r230 = ptrtoint ptr %r229 to i64
  %r231 = load i64, ptr %slot.dest, align 8
  %r232 = call i64 @ir_type_any()
  %r233 = call i64 @nova_rt_list_create()
  %r234 = load i64, ptr %slot.left, align 8
  %t235 = call i64 @nova_rt_list_append(i64 %r233, i64 %r234)
  %r236 = load i64, ptr %slot.right, align 8
  %t237 = call i64 @nova_rt_list_append(i64 %r233, i64 %r236)
  %r238 = getelementptr inbounds [3 x i8], ptr @.str.26, i64 0, i64 0
  %r239 = ptrtoint ptr %r238 to i64
  %r240 = call i64 @ir_emit(i64 %r228, i64 %r230, i64 %r231, i64 %r232, i64 %r233, i64 %r239, i64 0)
  br label %merge35
else34:
  %r241 = load i64, ptr %slot.value, align 8
  %r242 = getelementptr inbounds [2 x i8], ptr @.str.28, i64 0, i64 0
  %r243 = ptrtoint ptr %r242 to i64
  %t245 = call i64 @nova_rt_eq(i64 %r241, i64 %r243)
  %r244 = and i64 %t245, 1
  %t246 = icmp ne i64 %t245, 0
  br i1 %t246, label %then36, label %else37
then36:
  %r247 = load i64, ptr %slot.b, align 8
  %r248 = getelementptr inbounds [3 x i8], ptr @.str.29, i64 0, i64 0
  %r249 = ptrtoint ptr %r248 to i64
  %r250 = load i64, ptr %slot.dest, align 8
  %r251 = call i64 @ir_type_any()
  %r252 = call i64 @nova_rt_list_create()
  %r253 = load i64, ptr %slot.left, align 8
  %t254 = call i64 @nova_rt_list_append(i64 %r252, i64 %r253)
  %r255 = load i64, ptr %slot.right, align 8
  %t256 = call i64 @nova_rt_list_append(i64 %r252, i64 %r255)
  %r257 = getelementptr inbounds [2 x i8], ptr @.str.28, i64 0, i64 0
  %r258 = ptrtoint ptr %r257 to i64
  %r259 = call i64 @ir_emit(i64 %r247, i64 %r249, i64 %r250, i64 %r251, i64 %r252, i64 %r258, i64 0)
  br label %merge38
else37:
  %r260 = load i64, ptr %slot.value, align 8
  %r261 = getelementptr inbounds [3 x i8], ptr @.str.30, i64 0, i64 0
  %r262 = ptrtoint ptr %r261 to i64
  %t264 = call i64 @nova_rt_eq(i64 %r260, i64 %r262)
  %r263 = and i64 %t264, 1
  %t265 = icmp ne i64 %t264, 0
  br i1 %t265, label %then39, label %else40
then39:
  %r266 = load i64, ptr %slot.b, align 8
  %r267 = getelementptr inbounds [3 x i8], ptr @.str.31, i64 0, i64 0
  %r268 = ptrtoint ptr %r267 to i64
  %r269 = load i64, ptr %slot.dest, align 8
  %r270 = call i64 @ir_type_any()
  %r271 = call i64 @nova_rt_list_create()
  %r272 = load i64, ptr %slot.left, align 8
  %t273 = call i64 @nova_rt_list_append(i64 %r271, i64 %r272)
  %r274 = load i64, ptr %slot.right, align 8
  %t275 = call i64 @nova_rt_list_append(i64 %r271, i64 %r274)
  %r276 = getelementptr inbounds [3 x i8], ptr @.str.30, i64 0, i64 0
  %r277 = ptrtoint ptr %r276 to i64
  %r278 = call i64 @ir_emit(i64 %r266, i64 %r268, i64 %r269, i64 %r270, i64 %r271, i64 %r277, i64 0)
  br label %merge41
else40:
  %r279 = load i64, ptr %slot.value, align 8
  %r280 = getelementptr inbounds [2 x i8], ptr @.str.32, i64 0, i64 0
  %r281 = ptrtoint ptr %r280 to i64
  %t283 = call i64 @nova_rt_eq(i64 %r279, i64 %r281)
  %r282 = and i64 %t283, 1
  %t284 = icmp ne i64 %t283, 0
  br i1 %t284, label %then42, label %else43
then42:
  %r285 = load i64, ptr %slot.b, align 8
  %r286 = getelementptr inbounds [3 x i8], ptr @.str.33, i64 0, i64 0
  %r287 = ptrtoint ptr %r286 to i64
  %r288 = load i64, ptr %slot.dest, align 8
  %r289 = call i64 @ir_type_any()
  %r290 = call i64 @nova_rt_list_create()
  %r291 = load i64, ptr %slot.left, align 8
  %t292 = call i64 @nova_rt_list_append(i64 %r290, i64 %r291)
  %r293 = load i64, ptr %slot.right, align 8
  %t294 = call i64 @nova_rt_list_append(i64 %r290, i64 %r293)
  %r295 = getelementptr inbounds [2 x i8], ptr @.str.32, i64 0, i64 0
  %r296 = ptrtoint ptr %r295 to i64
  %r297 = call i64 @ir_emit(i64 %r285, i64 %r287, i64 %r288, i64 %r289, i64 %r290, i64 %r296, i64 0)
  br label %merge44
else43:
  %r298 = load i64, ptr %slot.value, align 8
  %r299 = getelementptr inbounds [3 x i8], ptr @.str.34, i64 0, i64 0
  %r300 = ptrtoint ptr %r299 to i64
  %t302 = call i64 @nova_rt_eq(i64 %r298, i64 %r300)
  %r301 = and i64 %t302, 1
  %t303 = icmp ne i64 %t302, 0
  br i1 %t303, label %then45, label %else46
then45:
  %r304 = load i64, ptr %slot.b, align 8
  %r305 = getelementptr inbounds [3 x i8], ptr @.str.35, i64 0, i64 0
  %r306 = ptrtoint ptr %r305 to i64
  %r307 = load i64, ptr %slot.dest, align 8
  %r308 = call i64 @ir_type_any()
  %r309 = call i64 @nova_rt_list_create()
  %r310 = load i64, ptr %slot.left, align 8
  %t311 = call i64 @nova_rt_list_append(i64 %r309, i64 %r310)
  %r312 = load i64, ptr %slot.right, align 8
  %t313 = call i64 @nova_rt_list_append(i64 %r309, i64 %r312)
  %r314 = getelementptr inbounds [3 x i8], ptr @.str.34, i64 0, i64 0
  %r315 = ptrtoint ptr %r314 to i64
  %r316 = call i64 @ir_emit(i64 %r304, i64 %r306, i64 %r307, i64 %r308, i64 %r309, i64 %r315, i64 0)
  br label %merge47
else46:
  %r317 = load i64, ptr %slot.b, align 8
  %r318 = getelementptr inbounds [5 x i8], ptr @.str.36, i64 0, i64 0
  %r319 = ptrtoint ptr %r318 to i64
  %r320 = load i64, ptr %slot.dest, align 8
  %r321 = call i64 @ir_type_any()
  %r322 = call i64 @nova_rt_list_create()
  %r323 = load i64, ptr %slot.left, align 8
  %t324 = call i64 @nova_rt_list_append(i64 %r322, i64 %r323)
  %r325 = load i64, ptr %slot.right, align 8
  %t326 = call i64 @nova_rt_list_append(i64 %r322, i64 %r325)
  %r327 = getelementptr inbounds [14 x i8], ptr @.str.37, i64 0, i64 0
  %r328 = ptrtoint ptr %r327 to i64
  %r329 = call i64 @ir_emit(i64 %r317, i64 %r319, i64 %r320, i64 %r321, i64 %r322, i64 %r328, i64 0)
  br label %merge47
merge47:
  br label %merge44
merge44:
  br label %merge41
merge41:
  br label %merge38
merge38:
  br label %merge35
merge35:
  br label %merge32
merge32:
  br label %merge29
merge29:
  br label %merge26
merge26:
  br label %merge23
merge23:
  br label %merge20
merge20:
  br label %merge17
merge17:
  %r330 = load i64, ptr %slot.dest, align 8
  ret i64 %r330
  br label %merge14
else13:
  %r331 = load i64, ptr %slot.tag, align 8
  %r332 = getelementptr inbounds [6 x i8], ptr @.str.38, i64 0, i64 0
  %r333 = ptrtoint ptr %r332 to i64
  %t335 = call i64 @nova_rt_eq(i64 %r331, i64 %r333)
  %r334 = and i64 %t335, 1
  %t336 = icmp ne i64 %t335, 0
  br i1 %t336, label %then48, label %else49
then48:
  %r337 = load i64, ptr %slot.b, align 8
  %r338 = load i64, ptr %slot.children, align 8
  %r339 = call i64 @nova_rt_index_get(i64 %r338, i64 0)
  %r340 = call i64 @ir_lower_expr(i64 %r337, i64 %r339)
  store i64 %r340, ptr %slot.operand, align 8
  %r341 = load i64, ptr %slot.b, align 8
  %r342 = call i64 @ir_fresh_reg(i64 %r341)
  store i64 %r342, ptr %slot.dest, align 8
  %r343 = load i64, ptr %slot.value, align 8
  %r344 = getelementptr inbounds [2 x i8], ptr @.str.16, i64 0, i64 0
  %r345 = ptrtoint ptr %r344 to i64
  %t347 = call i64 @nova_rt_eq(i64 %r343, i64 %r345)
  %r346 = and i64 %t347, 1
  %t348 = icmp ne i64 %t347, 0
  br i1 %t348, label %then51, label %else52
then51:
  %r349 = load i64, ptr %slot.b, align 8
  %r350 = getelementptr inbounds [4 x i8], ptr @.str.39, i64 0, i64 0
  %r351 = ptrtoint ptr %r350 to i64
  %r352 = load i64, ptr %slot.dest, align 8
  %r353 = call i64 @ir_type_any()
  %r354 = call i64 @nova_rt_list_create()
  %r355 = load i64, ptr %slot.operand, align 8
  %t356 = call i64 @nova_rt_list_append(i64 %r354, i64 %r355)
  %r357 = getelementptr inbounds [2 x i8], ptr @.str.16, i64 0, i64 0
  %r358 = ptrtoint ptr %r357 to i64
  %r359 = call i64 @ir_emit(i64 %r349, i64 %r351, i64 %r352, i64 %r353, i64 %r354, i64 %r358, i64 0)
  br label %merge53
else52:
  %r360 = load i64, ptr %slot.value, align 8
  %r361 = getelementptr inbounds [4 x i8], ptr @.str.40, i64 0, i64 0
  %r362 = ptrtoint ptr %r361 to i64
  %t364 = call i64 @nova_rt_eq(i64 %r360, i64 %r362)
  %r363 = and i64 %t364, 1
  %t365 = icmp ne i64 %t364, 0
  br i1 %t365, label %then54, label %else55
then54:
  %r366 = load i64, ptr %slot.b, align 8
  %r367 = getelementptr inbounds [4 x i8], ptr @.str.40, i64 0, i64 0
  %r368 = ptrtoint ptr %r367 to i64
  %r369 = load i64, ptr %slot.dest, align 8
  %r370 = call i64 @ir_type_any()
  %r371 = call i64 @nova_rt_list_create()
  %r372 = load i64, ptr %slot.operand, align 8
  %t373 = call i64 @nova_rt_list_append(i64 %r371, i64 %r372)
  %r374 = getelementptr inbounds [4 x i8], ptr @.str.40, i64 0, i64 0
  %r375 = ptrtoint ptr %r374 to i64
  %r376 = call i64 @ir_emit(i64 %r366, i64 %r368, i64 %r369, i64 %r370, i64 %r371, i64 %r375, i64 0)
  br label %merge56
else55:
  br label %merge56
merge56:
  br label %merge53
merge53:
  %r377 = load i64, ptr %slot.dest, align 8
  ret i64 %r377
  br label %merge50
else49:
  %r378 = load i64, ptr %slot.tag, align 8
  %r379 = getelementptr inbounds [5 x i8], ptr @.str.36, i64 0, i64 0
  %r380 = ptrtoint ptr %r379 to i64
  %t382 = call i64 @nova_rt_eq(i64 %r378, i64 %r380)
  %r381 = and i64 %t382, 1
  %t383 = icmp ne i64 %t382, 0
  br i1 %t383, label %then57, label %else58
then57:
  %r384 = load i64, ptr %slot.value, align 8
  store i64 %r384, ptr %slot.fn_name, align 8
  %r385 = call i64 @nova_rt_list_create()
  store i64 %r385, ptr %slot.arg_regs, align 8
  %r386 = load i64, ptr %slot.children, align 8
  %r387 = call i64 @nova_rt_len_any(i64 %r386)
  %slot.__for_idx_60 = alloca i64, align 8
  store i64 0, ptr %slot.__for_idx_60, align 8
  br label %for_hdr60
for_hdr60:
  %r388 = load i64, ptr %slot.__for_idx_60, align 8
  %t389 = icmp slt i64 %r388, %r387
  br i1 %t389, label %for_body61, label %for_exit62
for_body61:
  %r390 = call i64 @nova_rt_index_get(i64 %r386, i64 %r388)
  store i64 %r390, ptr %slot.child, align 8
  %r391 = load i64, ptr %slot.arg_regs, align 8
  %r392 = load i64, ptr %slot.b, align 8
  %r393 = load i64, ptr %slot.child, align 8
  %r394 = call i64 @ir_lower_expr(i64 %r392, i64 %r393)
  %r395 = call i64 @nova_rt_list_append(i64 %r391, i64 %r394)
  %r397 = load i64, ptr %slot.__for_idx_60, align 8
  %r396 = add i64 %r397, 1
  store i64 %r396, ptr %slot.__for_idx_60, align 8
  br label %for_hdr60
for_exit62:
  %r398 = load i64, ptr %slot.b, align 8
  %r399 = call i64 @ir_fresh_reg(i64 %r398)
  store i64 %r399, ptr %slot.dest, align 8
  %r400 = load i64, ptr %slot.b, align 8
  %r401 = getelementptr inbounds [5 x i8], ptr @.str.36, i64 0, i64 0
  %r402 = ptrtoint ptr %r401 to i64
  %r403 = load i64, ptr %slot.dest, align 8
  %r404 = call i64 @ir_type_any()
  %r405 = load i64, ptr %slot.arg_regs, align 8
  %r406 = load i64, ptr %slot.fn_name, align 8
  %r407 = call i64 @ir_emit_effect(i64 %r400, i64 %r402, i64 %r403, i64 %r404, i64 %r405, i64 %r406, i64 0)
  %r408 = load i64, ptr %slot.dest, align 8
  ret i64 %r408
  br label %merge59
else58:
  %r409 = load i64, ptr %slot.tag, align 8
  %r410 = getelementptr inbounds [5 x i8], ptr @.str.41, i64 0, i64 0
  %r411 = ptrtoint ptr %r410 to i64
  %t413 = call i64 @nova_rt_eq(i64 %r409, i64 %r411)
  %r412 = and i64 %t413, 1
  %t414 = icmp ne i64 %t413, 0
  br i1 %t414, label %then63, label %else64
then63:
  %r415 = load i64, ptr %slot.b, align 8
  %r416 = call i64 @ir_fresh_reg(i64 %r415)
  store i64 %r416, ptr %slot.dest, align 8
  %r417 = call i64 @nova_rt_list_create()
  store i64 %r417, ptr %slot.elem_regs, align 8
  %r418 = load i64, ptr %slot.children, align 8
  %r419 = call i64 @nova_rt_len_any(i64 %r418)
  %slot.__for_idx_66 = alloca i64, align 8
  store i64 0, ptr %slot.__for_idx_66, align 8
  br label %for_hdr66
for_hdr66:
  %r420 = load i64, ptr %slot.__for_idx_66, align 8
  %t421 = icmp slt i64 %r420, %r419
  br i1 %t421, label %for_body67, label %for_exit68
for_body67:
  %r422 = call i64 @nova_rt_index_get(i64 %r418, i64 %r420)
  store i64 %r422, ptr %slot.child, align 8
  %r423 = load i64, ptr %slot.elem_regs, align 8
  %r424 = load i64, ptr %slot.b, align 8
  %r425 = load i64, ptr %slot.child, align 8
  %r426 = call i64 @ir_lower_expr(i64 %r424, i64 %r425)
  %r427 = call i64 @nova_rt_list_append(i64 %r423, i64 %r426)
  %r429 = load i64, ptr %slot.__for_idx_66, align 8
  %r428 = add i64 %r429, 1
  store i64 %r428, ptr %slot.__for_idx_66, align 8
  br label %for_hdr66
for_exit68:
  %r430 = load i64, ptr %slot.b, align 8
  %r431 = getelementptr inbounds [10 x i8], ptr @.str.42, i64 0, i64 0
  %r432 = ptrtoint ptr %r431 to i64
  %r433 = load i64, ptr %slot.dest, align 8
  %r434 = call i64 @ir_type_any()
  %r435 = load i64, ptr %slot.elem_regs, align 8
  %r436 = getelementptr inbounds [1 x i8], ptr @.str.1, i64 0, i64 0
  %r437 = ptrtoint ptr %r436 to i64
  %r438 = load i64, ptr %slot.children, align 8
  %r439 = call i64 @nova_rt_len_any(i64 %r438)
  %r440 = call i64 @ir_emit(i64 %r430, i64 %r432, i64 %r433, i64 %r434, i64 %r435, i64 %r437, i64 %r439)
  %r441 = load i64, ptr %slot.dest, align 8
  ret i64 %r441
  br label %merge65
else64:
  %r442 = load i64, ptr %slot.tag, align 8
  %r443 = getelementptr inbounds [6 x i8], ptr @.str.43, i64 0, i64 0
  %r444 = ptrtoint ptr %r443 to i64
  %t446 = call i64 @nova_rt_eq(i64 %r442, i64 %r444)
  %r445 = and i64 %t446, 1
  %t447 = icmp ne i64 %t446, 0
  br i1 %t447, label %then69, label %else70
then69:
  %r448 = load i64, ptr %slot.b, align 8
  %r449 = load i64, ptr %slot.children, align 8
  %r450 = call i64 @nova_rt_index_get(i64 %r449, i64 0)
  %r451 = call i64 @ir_lower_expr(i64 %r448, i64 %r450)
  store i64 %r451, ptr %slot.obj, align 8
  %r452 = load i64, ptr %slot.b, align 8
  %r453 = load i64, ptr %slot.children, align 8
  %r454 = call i64 @nova_rt_index_get(i64 %r453, i64 1)
  %r455 = call i64 @ir_lower_expr(i64 %r452, i64 %r454)
  store i64 %r455, ptr %slot.idx, align 8
  %r456 = load i64, ptr %slot.b, align 8
  %r457 = call i64 @ir_fresh_reg(i64 %r456)
  store i64 %r457, ptr %slot.dest, align 8
  %r458 = load i64, ptr %slot.b, align 8
  %r459 = getelementptr inbounds [10 x i8], ptr @.str.44, i64 0, i64 0
  %r460 = ptrtoint ptr %r459 to i64
  %r461 = load i64, ptr %slot.dest, align 8
  %r462 = call i64 @ir_type_any()
  %r463 = call i64 @nova_rt_list_create()
  %r464 = load i64, ptr %slot.obj, align 8
  %t465 = call i64 @nova_rt_list_append(i64 %r463, i64 %r464)
  %r466 = load i64, ptr %slot.idx, align 8
  %t467 = call i64 @nova_rt_list_append(i64 %r463, i64 %r466)
  %r468 = getelementptr inbounds [1 x i8], ptr @.str.1, i64 0, i64 0
  %r469 = ptrtoint ptr %r468 to i64
  %r470 = call i64 @ir_emit(i64 %r458, i64 %r460, i64 %r461, i64 %r462, i64 %r463, i64 %r469, i64 0)
  %r471 = load i64, ptr %slot.dest, align 8
  ret i64 %r471
  br label %merge71
else70:
  %r472 = load i64, ptr %slot.tag, align 8
  %r473 = getelementptr inbounds [6 x i8], ptr @.str.45, i64 0, i64 0
  %r474 = ptrtoint ptr %r473 to i64
  %t476 = call i64 @nova_rt_eq(i64 %r472, i64 %r474)
  %r475 = and i64 %t476, 1
  %t477 = icmp ne i64 %t476, 0
  br i1 %t477, label %then72, label %else73
then72:
  %r478 = load i64, ptr %slot.b, align 8
  %r479 = load i64, ptr %slot.children, align 8
  %r480 = call i64 @nova_rt_index_get(i64 %r479, i64 0)
  %r481 = call i64 @ir_lower_expr(i64 %r478, i64 %r480)
  store i64 %r481, ptr %slot.obj, align 8
  %r482 = load i64, ptr %slot.b, align 8
  %r483 = call i64 @ir_fresh_reg(i64 %r482)
  store i64 %r483, ptr %slot.dest, align 8
  %r484 = load i64, ptr %slot.b, align 8
  %r485 = getelementptr inbounds [10 x i8], ptr @.str.46, i64 0, i64 0
  %r486 = ptrtoint ptr %r485 to i64
  %r487 = load i64, ptr %slot.dest, align 8
  %r488 = call i64 @ir_type_any()
  %r489 = call i64 @nova_rt_list_create()
  %r490 = load i64, ptr %slot.obj, align 8
  %t491 = call i64 @nova_rt_list_append(i64 %r489, i64 %r490)
  %r492 = load i64, ptr %slot.value, align 8
  %r493 = call i64 @ir_emit(i64 %r484, i64 %r486, i64 %r487, i64 %r488, i64 %r489, i64 %r492, i64 0)
  %r494 = load i64, ptr %slot.dest, align 8
  ret i64 %r494
  br label %merge74
else73:
  br label %merge74
merge74:
  br label %merge71
merge71:
  br label %merge65
merge65:
  br label %merge59
merge59:
  br label %merge50
merge50:
  br label %merge14
merge14:
  br label %merge11
merge11:
  br label %merge5
merge5:
  br label %merge2
merge2:
  %r495 = load i64, ptr %slot.b, align 8
  %r496 = call i64 @ir_fresh_reg(i64 %r495)
  store i64 %r496, ptr %slot.dest, align 8
  %r497 = load i64, ptr %slot.b, align 8
  %r498 = getelementptr inbounds [10 x i8], ptr @.str.9, i64 0, i64 0
  %r499 = ptrtoint ptr %r498 to i64
  %r500 = load i64, ptr %slot.dest, align 8
  %r501 = call i64 @ir_type_any()
  %r502 = call i64 @nova_rt_list_create()
  %r503 = getelementptr inbounds [2 x i8], ptr @.str.47, i64 0, i64 0
  %r504 = ptrtoint ptr %r503 to i64
  %r505 = call i64 @ir_emit(i64 %r497, i64 %r499, i64 %r500, i64 %r501, i64 %r502, i64 %r504, i64 0)
  %r506 = load i64, ptr %slot.dest, align 8
  ret i64 %r506
}

define i64 @ir_lower_stmt(i64 %p0, i64 %p1) nounwind {
entry:
  %slot.b = alloca i64, align 8
  store i64 %p0, ptr %slot.b, align 8
  %slot.stmt = alloca i64, align 8
  store i64 %p1, ptr %slot.stmt, align 8
  %slot.tag = alloca i64, align 8
  store i64 0, ptr %slot.tag, align 8
  %slot.name = alloca i64, align 8
  store i64 0, ptr %slot.name, align 8
  %slot.expr = alloca i64, align 8
  store i64 0, ptr %slot.expr, align 8
  %slot.body = alloca i64, align 8
  store i64 0, ptr %slot.body, align 8
  %slot.params = alloca i64, align 8
  store i64 0, ptr %slot.params, align 8
  %slot.else_body = alloca i64, align 8
  store i64 0, ptr %slot.else_body, align 8
  %slot.annotations = alloca i64, align 8
  store i64 0, ptr %slot.annotations, align 8
  %slot.val = alloca i64, align 8
  store i64 0, ptr %slot.val, align 8
  %r0 = load i64, ptr %slot.stmt, align 8
  %t1 = inttoptr i64 %r0 to ptr
  %t2 = getelementptr i64, ptr %t1, i64 0
  %r3 = load i64, ptr %t2, align 8
  store i64 %r3, ptr %slot.tag, align 8
  %t4 = getelementptr i64, ptr %t1, i64 1
  %r5 = load i64, ptr %t4, align 8
  store i64 %r5, ptr %slot.name, align 8
  %t6 = getelementptr i64, ptr %t1, i64 2
  %r7 = load i64, ptr %t6, align 8
  store i64 %r7, ptr %slot.expr, align 8
  %t8 = getelementptr i64, ptr %t1, i64 3
  %r9 = load i64, ptr %t8, align 8
  store i64 %r9, ptr %slot.body, align 8
  %t10 = getelementptr i64, ptr %t1, i64 4
  %r11 = load i64, ptr %t10, align 8
  store i64 %r11, ptr %slot.params, align 8
  %t12 = getelementptr i64, ptr %t1, i64 5
  %r13 = load i64, ptr %t12, align 8
  store i64 %r13, ptr %slot.else_body, align 8
  %t14 = getelementptr i64, ptr %t1, i64 6
  %r15 = load i64, ptr %t14, align 8
  store i64 %r15, ptr %slot.annotations, align 8
  %r16 = load i64, ptr %slot.tag, align 8
  %r17 = getelementptr inbounds [5 x i8], ptr @.str.48, i64 0, i64 0
  %r18 = ptrtoint ptr %r17 to i64
  %t20 = call i64 @nova_rt_eq(i64 %r16, i64 %r18)
  %r19 = and i64 %t20, 1
  %t21 = icmp ne i64 %t20, 0
  br i1 %t21, label %ret_then75, label %ret_else76
ret_then75:
  %r22 = load i64, ptr %slot.b, align 8
  %r23 = load i64, ptr %slot.expr, align 8
  %r24 = call i64 @ir_lower_expr(i64 %r22, i64 %r23)
  ret i64 %r24
ret_else76:
  %r25 = load i64, ptr %slot.tag, align 8
  %r26 = getelementptr inbounds [4 x i8], ptr @.str.49, i64 0, i64 0
  %r27 = ptrtoint ptr %r26 to i64
  %t29 = call i64 @nova_rt_eq(i64 %r25, i64 %r27)
  %r28 = and i64 %t29, 1
  %r30 = load i64, ptr %slot.tag, align 8
  %r31 = getelementptr inbounds [7 x i8], ptr @.str.50, i64 0, i64 0
  %r32 = ptrtoint ptr %r31 to i64
  %t34 = call i64 @nova_rt_eq(i64 %r30, i64 %r32)
  %r33 = and i64 %t34, 1
  br label %or_entry77
or_entry77:
  %t36 = icmp ne i64 %t29, 0
  br i1 %t36, label %or_end79, label %or_rhs78
or_rhs78:
  %r37 = load i64, ptr %slot.tag, align 8
  %r38 = getelementptr inbounds [7 x i8], ptr @.str.50, i64 0, i64 0
  %r39 = ptrtoint ptr %r38 to i64
  %t41 = call i64 @nova_rt_eq(i64 %r37, i64 %r39)
  %r40 = and i64 %t41, 1
  br label %or_done80
or_done80:
  br label %or_end79
or_end79:
  %r35 = phi i64 [%t29, %or_entry77], [%t41, %or_done80]
  %t42 = icmp ne i64 %r35, 0
  br i1 %t42, label %ret_then81, label %ret_else82
ret_then81:
  %r43 = load i64, ptr %slot.b, align 8
  %r44 = load i64, ptr %slot.expr, align 8
  %r45 = call i64 @ir_lower_expr(i64 %r43, i64 %r44)
  store i64 %r45, ptr %slot.val, align 8
  %r46 = load i64, ptr %slot.b, align 8
  %r47 = getelementptr inbounds [11 x i8], ptr @.str.51, i64 0, i64 0
  %r48 = ptrtoint ptr %r47 to i64
  %r49 = getelementptr inbounds [1 x i8], ptr @.str.1, i64 0, i64 0
  %r50 = ptrtoint ptr %r49 to i64
  %r51 = call i64 @ir_type_void()
  %r52 = call i64 @nova_rt_list_create()
  %r53 = load i64, ptr %slot.val, align 8
  %t54 = call i64 @nova_rt_list_append(i64 %r52, i64 %r53)
  %r55 = load i64, ptr %slot.name, align 8
  %r56 = call i64 @ir_emit(i64 %r46, i64 %r48, i64 %r50, i64 %r51, i64 %r52, i64 %r55, i64 0)
  ret i64 %r56
ret_else82:
  %r57 = load i64, ptr %slot.tag, align 8
  %r58 = getelementptr inbounds [7 x i8], ptr @.str.52, i64 0, i64 0
  %r59 = ptrtoint ptr %r58 to i64
  %t61 = call i64 @nova_rt_eq(i64 %r57, i64 %r59)
  %r60 = and i64 %t61, 1
  %t62 = icmp ne i64 %t61, 0
  br i1 %t62, label %ret_then83, label %ret_else84
ret_then83:
  %r63 = load i64, ptr %slot.b, align 8
  %r64 = load i64, ptr %slot.expr, align 8
  %r65 = call i64 @ir_lower_expr(i64 %r63, i64 %r64)
  store i64 %r65, ptr %slot.val, align 8
  %r66 = load i64, ptr %slot.b, align 8
  %r67 = call ptr @nova_rt_struct_alloc(i64 56)
  %r68 = getelementptr inbounds [7 x i8], ptr @.str.52, i64 0, i64 0
  %r69 = ptrtoint ptr %r68 to i64
  %t70 = getelementptr i64, ptr %r67, i64 0
  store i64 %r69, ptr %t70, align 8
  %r71 = getelementptr inbounds [1 x i8], ptr @.str.1, i64 0, i64 0
  %r72 = ptrtoint ptr %r71 to i64
  %t73 = getelementptr i64, ptr %r67, i64 1
  store i64 %r72, ptr %t73, align 8
  %r74 = call i64 @ir_type_void()
  %t75 = getelementptr i64, ptr %r67, i64 2
  store i64 %r74, ptr %t75, align 8
  %r76 = call i64 @nova_rt_list_create()
  %r77 = load i64, ptr %slot.val, align 8
  %t78 = call i64 @nova_rt_list_append(i64 %r76, i64 %r77)
  %t79 = getelementptr i64, ptr %r67, i64 3
  store i64 %r76, ptr %t79, align 8
  %r80 = getelementptr inbounds [1 x i8], ptr @.str.1, i64 0, i64 0
  %r81 = ptrtoint ptr %r80 to i64
  %t82 = getelementptr i64, ptr %r67, i64 4
  store i64 %r81, ptr %t82, align 8
  %t83 = getelementptr i64, ptr %r67, i64 5
  store i64 0, ptr %t83, align 8
  %r84 = getelementptr inbounds [5 x i8], ptr @.str.7, i64 0, i64 0
  %r85 = ptrtoint ptr %r84 to i64
  %t86 = getelementptr i64, ptr %r67, i64 6
  store i64 %r85, ptr %t86, align 8
  %r87 = ptrtoint ptr %r67 to i64
  %r88 = call i64 @ir_finish_block(i64 %r66, i64 %r87)
  ret i64 %r88
ret_else84:
  %r89 = load i64, ptr %slot.tag, align 8
  %r90 = getelementptr inbounds [6 x i8], ptr @.str.53, i64 0, i64 0
  %r91 = ptrtoint ptr %r90 to i64
  %t93 = call i64 @nova_rt_eq(i64 %r89, i64 %r91)
  %r92 = and i64 %t93, 1
  %t94 = icmp ne i64 %t93, 0
  br i1 %t94, label %ret_then85, label %ret_else86
ret_then85:
  %r95 = load i64, ptr %slot.b, align 8
  %r96 = load i64, ptr %slot.expr, align 8
  %r97 = call i64 @ir_lower_expr(i64 %r95, i64 %r96)
  store i64 %r97, ptr %slot.val, align 8
  %r98 = load i64, ptr %slot.b, align 8
  %r99 = getelementptr inbounds [5 x i8], ptr @.str.36, i64 0, i64 0
  %r100 = ptrtoint ptr %r99 to i64
  %r101 = getelementptr inbounds [1 x i8], ptr @.str.1, i64 0, i64 0
  %r102 = ptrtoint ptr %r101 to i64
  %r103 = call i64 @ir_type_void()
  %r104 = call i64 @nova_rt_list_create()
  %r105 = load i64, ptr %slot.val, align 8
  %t106 = call i64 @nova_rt_list_append(i64 %r104, i64 %r105)
  %r107 = getelementptr inbounds [18 x i8], ptr @.str.54, i64 0, i64 0
  %r108 = ptrtoint ptr %r107 to i64
  %r109 = call i64 @ir_emit_effect(i64 %r98, i64 %r100, i64 %r102, i64 %r103, i64 %r104, i64 %r108, i64 0)
  ret i64 %r109
ret_else86:
  ret i64 0
}

define i64 @ir_lower_function(i64 %p0, i64 %p1) nounwind {
entry:
  %slot.b = alloca i64, align 8
  store i64 %p0, ptr %slot.b, align 8
  %slot.stmt = alloca i64, align 8
  store i64 %p1, ptr %slot.stmt, align 8
  %slot.tag = alloca i64, align 8
  store i64 0, ptr %slot.tag, align 8
  %slot.name = alloca i64, align 8
  store i64 0, ptr %slot.name, align 8
  %slot.expr = alloca i64, align 8
  store i64 0, ptr %slot.expr, align 8
  %slot.body = alloca i64, align 8
  store i64 0, ptr %slot.body, align 8
  %slot.params = alloca i64, align 8
  store i64 0, ptr %slot.params, align 8
  %slot.else_body = alloca i64, align 8
  store i64 0, ptr %slot.else_body, align 8
  %slot.annotations = alloca i64, align 8
  store i64 0, ptr %slot.annotations, align 8
  %slot.ir_params = alloca i64, align 8
  store i64 0, ptr %slot.ir_params, align 8
  %slot.p = alloca i64, align 8
  store i64 0, ptr %slot.p, align 8
  %slot.pname = alloca i64, align 8
  store i64 0, ptr %slot.pname, align 8
  %slot.ptype = alloca i64, align 8
  store i64 0, ptr %slot.ptype, align 8
  %slot.pdefault = alloca i64, align 8
  store i64 0, ptr %slot.pdefault, align 8
  %slot.s = alloca i64, align 8
  store i64 0, ptr %slot.s, align 8
  %r0 = load i64, ptr %slot.stmt, align 8
  %t1 = inttoptr i64 %r0 to ptr
  %t2 = getelementptr i64, ptr %t1, i64 0
  %r3 = load i64, ptr %t2, align 8
  store i64 %r3, ptr %slot.tag, align 8
  %t4 = getelementptr i64, ptr %t1, i64 1
  %r5 = load i64, ptr %t4, align 8
  store i64 %r5, ptr %slot.name, align 8
  %t6 = getelementptr i64, ptr %t1, i64 2
  %r7 = load i64, ptr %t6, align 8
  store i64 %r7, ptr %slot.expr, align 8
  %t8 = getelementptr i64, ptr %t1, i64 3
  %r9 = load i64, ptr %t8, align 8
  store i64 %r9, ptr %slot.body, align 8
  %t10 = getelementptr i64, ptr %t1, i64 4
  %r11 = load i64, ptr %t10, align 8
  store i64 %r11, ptr %slot.params, align 8
  %t12 = getelementptr i64, ptr %t1, i64 5
  %r13 = load i64, ptr %t12, align 8
  store i64 %r13, ptr %slot.else_body, align 8
  %t14 = getelementptr i64, ptr %t1, i64 6
  %r15 = load i64, ptr %t14, align 8
  store i64 %r15, ptr %slot.annotations, align 8
  %r16 = call i64 @nova_rt_list_create()
  store i64 %r16, ptr %slot.ir_params, align 8
  %r17 = load i64, ptr %slot.params, align 8
  %r18 = call i64 @nova_rt_len_any(i64 %r17)
  %slot.__for_idx_87 = alloca i64, align 8
  store i64 0, ptr %slot.__for_idx_87, align 8
  br label %for_hdr87
for_hdr87:
  %r19 = load i64, ptr %slot.__for_idx_87, align 8
  %t20 = icmp slt i64 %r19, %r18
  br i1 %t20, label %for_body88, label %for_exit89
for_body88:
  %r21 = call i64 @nova_rt_index_get(i64 %r17, i64 %r19)
  store i64 %r21, ptr %slot.p, align 8
  %r22 = load i64, ptr %slot.p, align 8
  %t23 = inttoptr i64 %r22 to ptr
  %t24 = getelementptr i64, ptr %t23, i64 0
  %r25 = load i64, ptr %t24, align 8
  store i64 %r25, ptr %slot.pname, align 8
  %t26 = getelementptr i64, ptr %t23, i64 1
  %r27 = load i64, ptr %t26, align 8
  store i64 %r27, ptr %slot.ptype, align 8
  %t28 = getelementptr i64, ptr %t23, i64 2
  %r29 = load i64, ptr %t28, align 8
  store i64 %r29, ptr %slot.pdefault, align 8
  %r30 = load i64, ptr %slot.ir_params, align 8
  %r31 = call ptr @nova_rt_struct_alloc(i64 16)
  %r32 = load i64, ptr %slot.pname, align 8
  %t33 = getelementptr i64, ptr %r31, i64 0
  store i64 %r32, ptr %t33, align 8
  %r34 = call i64 @ir_type_any()
  %t35 = getelementptr i64, ptr %r31, i64 1
  store i64 %r34, ptr %t35, align 8
  %r36 = ptrtoint ptr %r31 to i64
  %r37 = call i64 @nova_rt_list_append(i64 %r30, i64 %r36)
  %r39 = load i64, ptr %slot.__for_idx_87, align 8
  %r38 = add i64 %r39, 1
  store i64 %r38, ptr %slot.__for_idx_87, align 8
  br label %for_hdr87
for_exit89:
  %r40 = call i64 @nova_rt_list_create()
  %r41 = load i64, ptr %slot.b, align 8
  %t42 = inttoptr i64 %r41 to ptr
  %t43 = getelementptr i64, ptr %t42, i64 0
  store i64 %r40, ptr %t43, align 8
  %r44 = call i64 @nova_rt_list_create()
  %r45 = load i64, ptr %slot.b, align 8
  %t46 = inttoptr i64 %r45 to ptr
  %t47 = getelementptr i64, ptr %t46, i64 2
  store i64 %r44, ptr %t47, align 8
  %r48 = getelementptr inbounds [6 x i8], ptr @.str.5, i64 0, i64 0
  %r49 = ptrtoint ptr %r48 to i64
  %r50 = load i64, ptr %slot.b, align 8
  %t51 = inttoptr i64 %r50 to ptr
  %t52 = getelementptr i64, ptr %t51, i64 3
  store i64 %r49, ptr %t52, align 8
  %r53 = load i64, ptr %slot.b, align 8
  %t54 = inttoptr i64 %r53 to ptr
  %t55 = getelementptr i64, ptr %t54, i64 1
  store i64 0, ptr %t55, align 8
  %r56 = call i64 @nova_rt_dict_create()
  %r57 = load i64, ptr %slot.b, align 8
  %t58 = inttoptr i64 %r57 to ptr
  %t59 = getelementptr i64, ptr %t58, i64 4
  store i64 %r56, ptr %t59, align 8
  %r60 = load i64, ptr %slot.body, align 8
  %r61 = call i64 @nova_rt_len_any(i64 %r60)
  %slot.__for_idx_90 = alloca i64, align 8
  store i64 0, ptr %slot.__for_idx_90, align 8
  br label %for_hdr90
for_hdr90:
  %r62 = load i64, ptr %slot.__for_idx_90, align 8
  %t63 = icmp slt i64 %r62, %r61
  br i1 %t63, label %for_body91, label %for_exit92
for_body91:
  %r64 = call i64 @nova_rt_index_get(i64 %r60, i64 %r62)
  store i64 %r64, ptr %slot.s, align 8
  %r65 = load i64, ptr %slot.b, align 8
  %r66 = load i64, ptr %slot.s, align 8
  %r67 = call i64 @ir_lower_stmt(i64 %r65, i64 %r66)
  %r69 = load i64, ptr %slot.__for_idx_90, align 8
  %r68 = add i64 %r69, 1
  store i64 %r68, ptr %slot.__for_idx_90, align 8
  br label %for_hdr90
for_exit92:
  %r70 = load i64, ptr %slot.b, align 8
  %t72 = inttoptr i64 %r70 to ptr
  %t73 = getelementptr i64, ptr %t72, i64 0
  %r71 = load i64, ptr %t73, align 8
  %r74 = call i64 @nova_rt_len_any(i64 %r71)
  %t76 = icmp sgt i64 %r74, 0
  %r75 = zext i1 %t76 to i64
  %t77 = icmp ne i64 %r75, 0
  br i1 %t77, label %then93, label %else94
then93:
  %r78 = load i64, ptr %slot.b, align 8
  %r79 = call ptr @nova_rt_struct_alloc(i64 56)
  %r80 = getelementptr inbounds [7 x i8], ptr @.str.52, i64 0, i64 0
  %r81 = ptrtoint ptr %r80 to i64
  %t82 = getelementptr i64, ptr %r79, i64 0
  store i64 %r81, ptr %t82, align 8
  %r83 = getelementptr inbounds [1 x i8], ptr @.str.1, i64 0, i64 0
  %r84 = ptrtoint ptr %r83 to i64
  %t85 = getelementptr i64, ptr %r79, i64 1
  store i64 %r84, ptr %t85, align 8
  %r86 = call i64 @ir_type_void()
  %t87 = getelementptr i64, ptr %r79, i64 2
  store i64 %r86, ptr %t87, align 8
  %r88 = call i64 @nova_rt_list_create()
  %r89 = getelementptr inbounds [2 x i8], ptr @.str.47, i64 0, i64 0
  %r90 = ptrtoint ptr %r89 to i64
  %t91 = call i64 @nova_rt_list_append(i64 %r88, i64 %r90)
  %t92 = getelementptr i64, ptr %r79, i64 3
  store i64 %r88, ptr %t92, align 8
  %r93 = getelementptr inbounds [1 x i8], ptr @.str.1, i64 0, i64 0
  %r94 = ptrtoint ptr %r93 to i64
  %t95 = getelementptr i64, ptr %r79, i64 4
  store i64 %r94, ptr %t95, align 8
  %t96 = getelementptr i64, ptr %r79, i64 5
  store i64 0, ptr %t96, align 8
  %r97 = getelementptr inbounds [5 x i8], ptr @.str.7, i64 0, i64 0
  %r98 = ptrtoint ptr %r97 to i64
  %t99 = getelementptr i64, ptr %r79, i64 6
  store i64 %r98, ptr %t99, align 8
  %r100 = ptrtoint ptr %r79 to i64
  %r101 = call i64 @ir_finish_block(i64 %r78, i64 %r100)
  br label %merge95
else94:
  %r102 = load i64, ptr %slot.b, align 8
  %t104 = inttoptr i64 %r102 to ptr
  %t105 = getelementptr i64, ptr %t104, i64 2
  %r103 = load i64, ptr %t105, align 8
  %r106 = call i64 @nova_rt_len_any(i64 %r103)
  %t108 = call i64 @nova_rt_eq(i64 %r106, i64 0)
  %r107 = and i64 %t108, 1
  %t109 = icmp ne i64 %t108, 0
  br i1 %t109, label %then96, label %else97
then96:
  %r110 = load i64, ptr %slot.b, align 8
  %r111 = call ptr @nova_rt_struct_alloc(i64 56)
  %r112 = getelementptr inbounds [7 x i8], ptr @.str.52, i64 0, i64 0
  %r113 = ptrtoint ptr %r112 to i64
  %t114 = getelementptr i64, ptr %r111, i64 0
  store i64 %r113, ptr %t114, align 8
  %r115 = getelementptr inbounds [1 x i8], ptr @.str.1, i64 0, i64 0
  %r116 = ptrtoint ptr %r115 to i64
  %t117 = getelementptr i64, ptr %r111, i64 1
  store i64 %r116, ptr %t117, align 8
  %r118 = call i64 @ir_type_void()
  %t119 = getelementptr i64, ptr %r111, i64 2
  store i64 %r118, ptr %t119, align 8
  %r120 = call i64 @nova_rt_list_create()
  %r121 = getelementptr inbounds [2 x i8], ptr @.str.47, i64 0, i64 0
  %r122 = ptrtoint ptr %r121 to i64
  %t123 = call i64 @nova_rt_list_append(i64 %r120, i64 %r122)
  %t124 = getelementptr i64, ptr %r111, i64 3
  store i64 %r120, ptr %t124, align 8
  %r125 = getelementptr inbounds [1 x i8], ptr @.str.1, i64 0, i64 0
  %r126 = ptrtoint ptr %r125 to i64
  %t127 = getelementptr i64, ptr %r111, i64 4
  store i64 %r126, ptr %t127, align 8
  %t128 = getelementptr i64, ptr %r111, i64 5
  store i64 0, ptr %t128, align 8
  %r129 = getelementptr inbounds [5 x i8], ptr @.str.7, i64 0, i64 0
  %r130 = ptrtoint ptr %r129 to i64
  %t131 = getelementptr i64, ptr %r111, i64 6
  store i64 %r130, ptr %t131, align 8
  %r132 = ptrtoint ptr %r111 to i64
  %r133 = call i64 @ir_finish_block(i64 %r110, i64 %r132)
  br label %merge98
else97:
  br label %merge98
merge98:
  br label %merge95
merge95:
  %r134 = call ptr @nova_rt_struct_alloc(i64 48)
  %r135 = load i64, ptr %slot.name, align 8
  %t136 = getelementptr i64, ptr %r134, i64 0
  store i64 %r135, ptr %t136, align 8
  %r137 = load i64, ptr %slot.ir_params, align 8
  %t138 = getelementptr i64, ptr %r134, i64 1
  store i64 %r137, ptr %t138, align 8
  %r139 = call i64 @ir_type_any()
  %t140 = getelementptr i64, ptr %r134, i64 2
  store i64 %r139, ptr %t140, align 8
  %r141 = load i64, ptr %slot.b, align 8
  %t143 = inttoptr i64 %r141 to ptr
  %t144 = getelementptr i64, ptr %t143, i64 2
  %r142 = load i64, ptr %t144, align 8
  %t145 = getelementptr i64, ptr %r134, i64 3
  store i64 %r142, ptr %t145, align 8
  %r146 = call i64 @nova_rt_list_create()
  %t147 = getelementptr i64, ptr %r134, i64 4
  store i64 %r146, ptr %t147, align 8
  %t148 = getelementptr i64, ptr %r134, i64 5
  store i64 0, ptr %t148, align 8
  %r149 = ptrtoint ptr %r134 to i64
  ret i64 %r149
}

define i64 @new_emitter() nounwind {
entry:
  %r0 = call ptr @nova_rt_struct_alloc(i64 32)
  %r1 = call i64 @nova_rt_list_create()
  %t2 = getelementptr i64, ptr %r0, i64 0
  store i64 %r1, ptr %t2, align 8
  %r3 = call i64 @nova_rt_list_create()
  %t4 = getelementptr i64, ptr %r0, i64 1
  store i64 %r3, ptr %t4, align 8
  %r5 = call i64 @nova_rt_dict_create()
  %t6 = getelementptr i64, ptr %r0, i64 2
  store i64 %r5, ptr %t6, align 8
  %t7 = getelementptr i64, ptr %r0, i64 3
  store i64 0, ptr %t7, align 8
  %r8 = ptrtoint ptr %r0 to i64
  ret i64 %r8
}

define i64 @emit_line(i64 %p0, i64 %p1) nounwind {
entry:
  %slot.e = alloca i64, align 8
  store i64 %p0, ptr %slot.e, align 8
  %slot.line = alloca i64, align 8
  store i64 %p1, ptr %slot.line, align 8
  %r0 = load i64, ptr %slot.e, align 8
  %t2 = inttoptr i64 %r0 to ptr
  %t3 = getelementptr i64, ptr %t2, i64 0
  %r1 = load i64, ptr %t3, align 8
  %r4 = load i64, ptr %slot.line, align 8
  %r5 = call i64 @nova_rt_list_append(i64 %r1, i64 %r4)
  ret i64 %r5
}

define i64 @emit_indent_line(i64 %p0, i64 %p1) nounwind {
entry:
  %slot.e = alloca i64, align 8
  store i64 %p0, ptr %slot.e, align 8
  %slot.line = alloca i64, align 8
  store i64 %p1, ptr %slot.line, align 8
  %r0 = load i64, ptr %slot.e, align 8
  %t2 = inttoptr i64 %r0 to ptr
  %t3 = getelementptr i64, ptr %t2, i64 0
  %r1 = load i64, ptr %t3, align 8
  %r4 = getelementptr inbounds [3 x i8], ptr @.str.55, i64 0, i64 0
  %r5 = ptrtoint ptr %r4 to i64
  %r6 = load i64, ptr %slot.line, align 8
  %r7 = call i64 @nova_rt_add(i64 %r5, i64 %r6)
  %r8 = call i64 @nova_rt_list_append(i64 %r1, i64 %r7)
  ret i64 %r8
}

define i64 @llvm_escape(i64 %p0) nounwind {
entry:
  %slot.s = alloca i64, align 8
  store i64 %p0, ptr %slot.s, align 8
  %slot.result = alloca i64, align 8
  store i64 0, ptr %slot.result, align 8
  %slot.i = alloca i64, align 8
  store i64 0, ptr %slot.i, align 8
  %slot.ch = alloca i64, align 8
  store i64 0, ptr %slot.ch, align 8
  %r0 = getelementptr inbounds [1 x i8], ptr @.str.1, i64 0, i64 0
  %r1 = ptrtoint ptr %r0 to i64
  store i64 %r1, ptr %slot.result, align 8
  store i64 0, ptr %slot.i, align 8
  br label %while_hdr99
while_hdr99:
  %r2 = load i64, ptr %slot.i, align 8
  %r3 = load i64, ptr %slot.s, align 8
  %r4 = call i64 @nova_rt_len_any(i64 %r3)
  %t6 = icmp slt i64 %r2, %r4
  %r5 = zext i1 %t6 to i64
  %t7 = icmp ne i64 %r5, 0
  br i1 %t7, label %while_body100, label %while_exit101
while_body100:
  %r8 = load i64, ptr %slot.s, align 8
  %r9 = load i64, ptr %slot.i, align 8
  %r10 = call i64 @nova_rt_index_get(i64 %r8, i64 %r9)
  store i64 %r10, ptr %slot.ch, align 8
  %r11 = load i64, ptr %slot.ch, align 8
  %r12 = getelementptr inbounds [2 x i8], ptr @.str.56, i64 0, i64 0
  %r13 = ptrtoint ptr %r12 to i64
  %t15 = call i64 @nova_rt_eq(i64 %r11, i64 %r13)
  %r14 = and i64 %t15, 1
  %t16 = icmp ne i64 %t15, 0
  br i1 %t16, label %then102, label %else103
then102:
  %r17 = load i64, ptr %slot.result, align 8
  %r18 = getelementptr inbounds [4 x i8], ptr @.str.57, i64 0, i64 0
  %r19 = ptrtoint ptr %r18 to i64
  %r20 = call i64 @nova_rt_add(i64 %r17, i64 %r19)
  store i64 %r20, ptr %slot.result, align 8
  br label %merge104
else103:
  %r21 = load i64, ptr %slot.ch, align 8
  %r22 = getelementptr inbounds [2 x i8], ptr @.str.58, i64 0, i64 0
  %r23 = ptrtoint ptr %r22 to i64
  %t25 = call i64 @nova_rt_eq(i64 %r21, i64 %r23)
  %r24 = and i64 %t25, 1
  %t26 = icmp ne i64 %t25, 0
  br i1 %t26, label %then105, label %else106
then105:
  %r27 = load i64, ptr %slot.result, align 8
  %r28 = getelementptr inbounds [4 x i8], ptr @.str.59, i64 0, i64 0
  %r29 = ptrtoint ptr %r28 to i64
  %r30 = call i64 @nova_rt_add(i64 %r27, i64 %r29)
  store i64 %r30, ptr %slot.result, align 8
  br label %merge107
else106:
  %r31 = load i64, ptr %slot.ch, align 8
  %r32 = getelementptr inbounds [2 x i8], ptr @.str.60, i64 0, i64 0
  %r33 = ptrtoint ptr %r32 to i64
  %t35 = call i64 @nova_rt_eq(i64 %r31, i64 %r33)
  %r34 = and i64 %t35, 1
  %t36 = icmp ne i64 %t35, 0
  br i1 %t36, label %then108, label %else109
then108:
  %r37 = load i64, ptr %slot.result, align 8
  %r38 = getelementptr inbounds [4 x i8], ptr @.str.61, i64 0, i64 0
  %r39 = ptrtoint ptr %r38 to i64
  %r40 = call i64 @nova_rt_add(i64 %r37, i64 %r39)
  store i64 %r40, ptr %slot.result, align 8
  br label %merge110
else109:
  %r41 = load i64, ptr %slot.ch, align 8
  %r42 = getelementptr inbounds [1 x i8], ptr @.str.1, i64 0, i64 0
  %r43 = ptrtoint ptr %r42 to i64
  %t45 = call i64 @nova_rt_eq(i64 %r41, i64 %r43)
  %r44 = and i64 %t45, 1
  %t46 = icmp ne i64 %t45, 0
  br i1 %t46, label %then111, label %else112
then111:
  %r47 = load i64, ptr %slot.result, align 8
  %r48 = getelementptr inbounds [4 x i8], ptr @.str.62, i64 0, i64 0
  %r49 = ptrtoint ptr %r48 to i64
  %r50 = call i64 @nova_rt_add(i64 %r47, i64 %r49)
  store i64 %r50, ptr %slot.result, align 8
  br label %merge113
else112:
  %r51 = load i64, ptr %slot.ch, align 8
  %r52 = getelementptr inbounds [2 x i8], ptr @.str.63, i64 0, i64 0
  %r53 = ptrtoint ptr %r52 to i64
  %t55 = call i64 @nova_rt_eq(i64 %r51, i64 %r53)
  %r54 = and i64 %t55, 1
  %t56 = icmp ne i64 %t55, 0
  br i1 %t56, label %then114, label %else115
then114:
  %r57 = load i64, ptr %slot.result, align 8
  %r58 = getelementptr inbounds [3 x i8], ptr @.str.64, i64 0, i64 0
  %r59 = ptrtoint ptr %r58 to i64
  %r60 = call i64 @nova_rt_add(i64 %r57, i64 %r59)
  store i64 %r60, ptr %slot.result, align 8
  br label %merge116
else115:
  %r61 = load i64, ptr %slot.ch, align 8
  %r62 = getelementptr inbounds [2 x i8], ptr @.str.65, i64 0, i64 0
  %r63 = ptrtoint ptr %r62 to i64
  %t65 = call i64 @nova_rt_eq(i64 %r61, i64 %r63)
  %r64 = and i64 %t65, 1
  %t66 = icmp ne i64 %t65, 0
  br i1 %t66, label %then117, label %else118
then117:
  %r67 = load i64, ptr %slot.result, align 8
  %r68 = getelementptr inbounds [4 x i8], ptr @.str.66, i64 0, i64 0
  %r69 = ptrtoint ptr %r68 to i64
  %r70 = call i64 @nova_rt_add(i64 %r67, i64 %r69)
  store i64 %r70, ptr %slot.result, align 8
  br label %merge119
else118:
  %r71 = load i64, ptr %slot.result, align 8
  %r72 = load i64, ptr %slot.ch, align 8
  %r73 = call i64 @nova_rt_add(i64 %r71, i64 %r72)
  store i64 %r73, ptr %slot.result, align 8
  br label %merge119
merge119:
  br label %merge116
merge116:
  br label %merge113
merge113:
  br label %merge110
merge110:
  br label %merge107
merge107:
  br label %merge104
merge104:
  %r74 = load i64, ptr %slot.i, align 8
  %r75 = call i64 @nova_rt_add(i64 %r74, i64 1)
  store i64 %r75, ptr %slot.i, align 8
  br label %while_hdr99
while_exit101:
  %r76 = load i64, ptr %slot.result, align 8
  ret i64 %r76
}

define i64 @intern_string_lit(i64 %p0, i64 %p1) nounwind {
entry:
  %slot.e = alloca i64, align 8
  store i64 %p0, ptr %slot.e, align 8
  %slot.s = alloca i64, align 8
  store i64 %p1, ptr %slot.s, align 8
  %slot.escaped = alloca i64, align 8
  store i64 0, ptr %slot.escaped, align 8
  %slot.name = alloca i64, align 8
  store i64 0, ptr %slot.name, align 8
  %slot.byte_len = alloca i64, align 8
  store i64 0, ptr %slot.byte_len, align 8
  %r0 = load i64, ptr %slot.e, align 8
  %t2 = inttoptr i64 %r0 to ptr
  %t3 = getelementptr i64, ptr %t2, i64 2
  %r1 = load i64, ptr %t3, align 8
  %r4 = load i64, ptr %slot.s, align 8
  %r5 = call i64 @nova_rt_contains(i64 %r1, i64 %r4)
  %t6 = icmp ne i64 %r5, 0
  br i1 %t6, label %then120, label %else121
then120:
  %r7 = load i64, ptr %slot.e, align 8
  %t9 = inttoptr i64 %r7 to ptr
  %t10 = getelementptr i64, ptr %t9, i64 2
  %r8 = load i64, ptr %t10, align 8
  %r11 = load i64, ptr %slot.s, align 8
  %r12 = call i64 @nova_rt_index_get(i64 %r8, i64 %r11)
  ret i64 %r12
  br label %merge122
else121:
  br label %merge122
merge122:
  %r13 = load i64, ptr %slot.s, align 8
  %r14 = call i64 @llvm_escape(i64 %r13)
  store i64 %r14, ptr %slot.escaped, align 8
  %r15 = getelementptr inbounds [7 x i8], ptr @.str.67, i64 0, i64 0
  %r16 = ptrtoint ptr %r15 to i64
  %r17 = load i64, ptr %slot.e, align 8
  %t19 = inttoptr i64 %r17 to ptr
  %t20 = getelementptr i64, ptr %t19, i64 3
  %r18 = load i64, ptr %t20, align 8
  %r21 = call i64 @nova_rt_int_to_str(i64 %r18)
  %r22 = call i64 @nova_rt_add(i64 %r16, i64 %r21)
  store i64 %r22, ptr %slot.name, align 8
  %r23 = load i64, ptr %slot.e, align 8
  %t25 = inttoptr i64 %r23 to ptr
  %t26 = getelementptr i64, ptr %t25, i64 3
  %r24 = load i64, ptr %t26, align 8
  %r27 = call i64 @nova_rt_add(i64 %r24, i64 1)
  %r28 = load i64, ptr %slot.e, align 8
  %t29 = inttoptr i64 %r28 to ptr
  %t30 = getelementptr i64, ptr %t29, i64 3
  store i64 %r27, ptr %t30, align 8
  %r31 = load i64, ptr %slot.s, align 8
  %r32 = call i64 @nova_rt_len_any(i64 %r31)
  %r33 = call i64 @nova_rt_add(i64 %r32, i64 1)
  store i64 %r33, ptr %slot.byte_len, align 8
  %r34 = load i64, ptr %slot.e, align 8
  %t36 = inttoptr i64 %r34 to ptr
  %t37 = getelementptr i64, ptr %t36, i64 1
  %r35 = load i64, ptr %t37, align 8
  %r38 = load i64, ptr %slot.name, align 8
  %r39 = getelementptr inbounds [35 x i8], ptr @.str.68, i64 0, i64 0
  %r40 = ptrtoint ptr %r39 to i64
  %r41 = call i64 @nova_rt_add(i64 %r38, i64 %r40)
  %r42 = load i64, ptr %slot.byte_len, align 8
  %r43 = call i64 @nova_rt_int_to_str(i64 %r42)
  %r44 = call i64 @nova_rt_add(i64 %r41, i64 %r43)
  %r45 = getelementptr inbounds [10 x i8], ptr @.str.69, i64 0, i64 0
  %r46 = ptrtoint ptr %r45 to i64
  %r47 = call i64 @nova_rt_add(i64 %r44, i64 %r46)
  %r48 = load i64, ptr %slot.escaped, align 8
  %r49 = call i64 @nova_rt_add(i64 %r47, i64 %r48)
  %r50 = getelementptr inbounds [5 x i8], ptr @.str.70, i64 0, i64 0
  %r51 = ptrtoint ptr %r50 to i64
  %r52 = call i64 @nova_rt_add(i64 %r49, i64 %r51)
  %r53 = call i64 @nova_rt_list_append(i64 %r35, i64 %r52)
  %r54 = load i64, ptr %slot.name, align 8
  %r55 = load i64, ptr %slot.e, align 8
  %t57 = inttoptr i64 %r55 to ptr
  %t58 = getelementptr i64, ptr %t57, i64 2
  %r56 = load i64, ptr %t58, align 8
  %r59 = load i64, ptr %slot.s, align 8
  %t60 = call i64 @nova_rt_index_set(i64 %r56, i64 %r59, i64 %r54)
  %r61 = load i64, ptr %slot.name, align 8
  ret i64 %r61
}

define i64 @emit_ir_inst(i64 %p0, i64 %p1) nounwind {
entry:
  %slot.e = alloca i64, align 8
  store i64 %p0, ptr %slot.e, align 8
  %slot.inst = alloca i64, align 8
  store i64 %p1, ptr %slot.inst, align 8
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
  %slot.str_name = alloca i64, align 8
  store i64 0, ptr %slot.str_name, align 8
  %slot.byte_len = alloca i64, align 8
  store i64 0, ptr %slot.byte_len, align 8
  %slot.ptr_reg = alloca i64, align 8
  store i64 0, ptr %slot.ptr_reg, align 8
  %slot.tk = alloca i64, align 8
  store i64 0, ptr %slot.tk, align 8
  %slot.tn = alloca i64, align 8
  store i64 0, ptr %slot.tn, align 8
  %slot.tp = alloca i64, align 8
  store i64 0, ptr %slot.tp, align 8
  %slot.tid = alloca i64, align 8
  store i64 0, ptr %slot.tid, align 8
  %slot.tmp = alloca i64, align 8
  store i64 0, ptr %slot.tmp, align 8
  %slot.call_str = alloca i64, align 8
  store i64 0, ptr %slot.call_str, align 8
  %slot.i = alloca i64, align 8
  store i64 0, ptr %slot.i, align 8
  %r0 = load i64, ptr %slot.inst, align 8
  %t1 = inttoptr i64 %r0 to ptr
  %t2 = getelementptr i64, ptr %t1, i64 0
  %r3 = load i64, ptr %t2, align 8
  store i64 %r3, ptr %slot.op, align 8
  %t4 = getelementptr i64, ptr %t1, i64 1
  %r5 = load i64, ptr %t4, align 8
  store i64 %r5, ptr %slot.dest, align 8
  %t6 = getelementptr i64, ptr %t1, i64 2
  %r7 = load i64, ptr %t6, align 8
  store i64 %r7, ptr %slot.typ, align 8
  %t8 = getelementptr i64, ptr %t1, i64 3
  %r9 = load i64, ptr %t8, align 8
  store i64 %r9, ptr %slot.args, align 8
  %t10 = getelementptr i64, ptr %t1, i64 4
  %r11 = load i64, ptr %t10, align 8
  store i64 %r11, ptr %slot.value, align 8
  %t12 = getelementptr i64, ptr %t1, i64 5
  %r13 = load i64, ptr %t12, align 8
  store i64 %r13, ptr %slot.num, align 8
  %t14 = getelementptr i64, ptr %t1, i64 6
  %r15 = load i64, ptr %t14, align 8
  store i64 %r15, ptr %slot.effect, align 8
  %r16 = load i64, ptr %slot.op, align 8
  %r17 = getelementptr inbounds [10 x i8], ptr @.str.9, i64 0, i64 0
  %r18 = ptrtoint ptr %r17 to i64
  %t20 = call i64 @nova_rt_eq(i64 %r16, i64 %r18)
  %r19 = and i64 %t20, 1
  %t21 = icmp ne i64 %t20, 0
  br i1 %t21, label %ret_then123, label %ret_else124
ret_then123:
  %r22 = load i64, ptr %slot.e, align 8
  %r23 = load i64, ptr %slot.dest, align 8
  %r24 = getelementptr inbounds [12 x i8], ptr @.str.71, i64 0, i64 0
  %r25 = ptrtoint ptr %r24 to i64
  %r26 = call i64 @nova_rt_add(i64 %r23, i64 %r25)
  %r27 = load i64, ptr %slot.num, align 8
  %r28 = call i64 @nova_rt_int_to_str(i64 %r27)
  %r29 = call i64 @nova_rt_add(i64 %r26, i64 %r28)
  %r30 = getelementptr inbounds [4 x i8], ptr @.str.72, i64 0, i64 0
  %r31 = ptrtoint ptr %r30 to i64
  %r32 = call i64 @nova_rt_add(i64 %r29, i64 %r31)
  %r33 = call i64 @emit_indent_line(i64 %r22, i64 %r32)
  ret i64 %r33
ret_else124:
  %r34 = load i64, ptr %slot.op, align 8
  %r35 = getelementptr inbounds [10 x i8], ptr @.str.10, i64 0, i64 0
  %r36 = ptrtoint ptr %r35 to i64
  %t38 = call i64 @nova_rt_eq(i64 %r34, i64 %r36)
  %r37 = and i64 %t38, 1
  %t39 = icmp ne i64 %t38, 0
  br i1 %t39, label %ret_then125, label %ret_else126
ret_then125:
  %r40 = load i64, ptr %slot.e, align 8
  %r41 = load i64, ptr %slot.value, align 8
  %r42 = call i64 @intern_string_lit(i64 %r40, i64 %r41)
  store i64 %r42, ptr %slot.str_name, align 8
  %r43 = load i64, ptr %slot.value, align 8
  %r44 = call i64 @nova_rt_len_any(i64 %r43)
  %r45 = call i64 @nova_rt_add(i64 %r44, i64 1)
  store i64 %r45, ptr %slot.byte_len, align 8
  %r46 = load i64, ptr %slot.dest, align 8
  %r47 = getelementptr inbounds [3 x i8], ptr @.str.73, i64 0, i64 0
  %r48 = ptrtoint ptr %r47 to i64
  %r49 = call i64 @nova_rt_add(i64 %r46, i64 %r48)
  store i64 %r49, ptr %slot.ptr_reg, align 8
  %r50 = load i64, ptr %slot.e, align 8
  %r51 = load i64, ptr %slot.ptr_reg, align 8
  %r52 = getelementptr inbounds [28 x i8], ptr @.str.74, i64 0, i64 0
  %r53 = ptrtoint ptr %r52 to i64
  %r54 = call i64 @nova_rt_add(i64 %r51, i64 %r53)
  %r55 = load i64, ptr %slot.byte_len, align 8
  %r56 = call i64 @nova_rt_int_to_str(i64 %r55)
  %r57 = call i64 @nova_rt_add(i64 %r54, i64 %r56)
  %r58 = getelementptr inbounds [13 x i8], ptr @.str.75, i64 0, i64 0
  %r59 = ptrtoint ptr %r58 to i64
  %r60 = call i64 @nova_rt_add(i64 %r57, i64 %r59)
  %r61 = load i64, ptr %slot.str_name, align 8
  %r62 = call i64 @nova_rt_add(i64 %r60, i64 %r61)
  %r63 = getelementptr inbounds [15 x i8], ptr @.str.76, i64 0, i64 0
  %r64 = ptrtoint ptr %r63 to i64
  %r65 = call i64 @nova_rt_add(i64 %r62, i64 %r64)
  %r66 = call i64 @emit_indent_line(i64 %r50, i64 %r65)
  %r67 = load i64, ptr %slot.e, align 8
  %r68 = load i64, ptr %slot.dest, align 8
  %r69 = getelementptr inbounds [40 x i8], ptr @.str.77, i64 0, i64 0
  %r70 = ptrtoint ptr %r69 to i64
  %r71 = call i64 @nova_rt_add(i64 %r68, i64 %r70)
  %r72 = load i64, ptr %slot.ptr_reg, align 8
  %r73 = call i64 @nova_rt_add(i64 %r71, i64 %r72)
  %r74 = getelementptr inbounds [2 x i8], ptr @.str.78, i64 0, i64 0
  %r75 = ptrtoint ptr %r74 to i64
  %r76 = call i64 @nova_rt_add(i64 %r73, i64 %r75)
  %r77 = call i64 @emit_indent_line(i64 %r67, i64 %r76)
  ret i64 %r77
ret_else126:
  %r78 = load i64, ptr %slot.op, align 8
  %r79 = getelementptr inbounds [4 x i8], ptr @.str.15, i64 0, i64 0
  %r80 = ptrtoint ptr %r79 to i64
  %t82 = call i64 @nova_rt_eq(i64 %r78, i64 %r80)
  %r81 = and i64 %t82, 1
  %t83 = icmp ne i64 %t82, 0
  br i1 %t83, label %ret_then127, label %ret_else128
ret_then127:
  %r84 = load i64, ptr %slot.typ, align 8
  %t85 = inttoptr i64 %r84 to ptr
  %t86 = getelementptr i64, ptr %t85, i64 0
  %r87 = load i64, ptr %t86, align 8
  store i64 %r87, ptr %slot.tk, align 8
  %t88 = getelementptr i64, ptr %t85, i64 1
  %r89 = load i64, ptr %t88, align 8
  store i64 %r89, ptr %slot.tn, align 8
  %t90 = getelementptr i64, ptr %t85, i64 2
  %r91 = load i64, ptr %t90, align 8
  store i64 %r91, ptr %slot.tp, align 8
  %t92 = getelementptr i64, ptr %t85, i64 3
  %r93 = load i64, ptr %t92, align 8
  store i64 %r93, ptr %slot.tid, align 8
  %r94 = load i64, ptr %slot.tk, align 8
  %r95 = getelementptr inbounds [4 x i8], ptr @.str.0, i64 0, i64 0
  %r96 = ptrtoint ptr %r95 to i64
  %t98 = call i64 @nova_rt_eq(i64 %r94, i64 %r96)
  %r97 = and i64 %t98, 1
  %t99 = icmp ne i64 %t98, 0
  br i1 %t99, label %ret_then129, label %ret_else130
ret_then129:
  %r100 = load i64, ptr %slot.e, align 8
  %r101 = load i64, ptr %slot.dest, align 8
  %r102 = getelementptr inbounds [12 x i8], ptr @.str.71, i64 0, i64 0
  %r103 = ptrtoint ptr %r102 to i64
  %r104 = call i64 @nova_rt_add(i64 %r101, i64 %r103)
  %r105 = load i64, ptr %slot.args, align 8
  %r106 = call i64 @nova_rt_index_get(i64 %r105, i64 0)
  %r107 = call i64 @nova_rt_add(i64 %r104, i64 %r106)
  %r108 = getelementptr inbounds [3 x i8], ptr @.str.79, i64 0, i64 0
  %r109 = ptrtoint ptr %r108 to i64
  %r110 = call i64 @nova_rt_add(i64 %r107, i64 %r109)
  %r111 = load i64, ptr %slot.args, align 8
  %r112 = call i64 @nova_rt_index_get(i64 %r111, i64 1)
  %r113 = call i64 @nova_rt_add(i64 %r110, i64 %r112)
  %r114 = call i64 @emit_indent_line(i64 %r100, i64 %r113)
  ret i64 %r114
ret_else130:
  %r115 = load i64, ptr %slot.tk, align 8
  %r116 = getelementptr inbounds [4 x i8], ptr @.str.2, i64 0, i64 0
  %r117 = ptrtoint ptr %r116 to i64
  %t119 = call i64 @nova_rt_eq(i64 %r115, i64 %r117)
  %r118 = and i64 %t119, 1
  %t120 = icmp ne i64 %t119, 0
  br i1 %t120, label %ret_then131, label %ret_else132
ret_then131:
  %r121 = load i64, ptr %slot.e, align 8
  %r122 = load i64, ptr %slot.dest, align 8
  %r123 = getelementptr inbounds [37 x i8], ptr @.str.80, i64 0, i64 0
  %r124 = ptrtoint ptr %r123 to i64
  %r125 = call i64 @nova_rt_add(i64 %r122, i64 %r124)
  %r126 = load i64, ptr %slot.args, align 8
  %r127 = call i64 @nova_rt_index_get(i64 %r126, i64 0)
  %r128 = call i64 @nova_rt_add(i64 %r125, i64 %r127)
  %r129 = getelementptr inbounds [7 x i8], ptr @.str.81, i64 0, i64 0
  %r130 = ptrtoint ptr %r129 to i64
  %r131 = call i64 @nova_rt_add(i64 %r128, i64 %r130)
  %r132 = load i64, ptr %slot.args, align 8
  %r133 = call i64 @nova_rt_index_get(i64 %r132, i64 1)
  %r134 = call i64 @nova_rt_add(i64 %r131, i64 %r133)
  %r135 = getelementptr inbounds [2 x i8], ptr @.str.78, i64 0, i64 0
  %r136 = ptrtoint ptr %r135 to i64
  %r137 = call i64 @nova_rt_add(i64 %r134, i64 %r136)
  %r138 = call i64 @emit_indent_line(i64 %r121, i64 %r137)
  ret i64 %r138
ret_else132:
  %r139 = load i64, ptr %slot.e, align 8
  %r140 = load i64, ptr %slot.dest, align 8
  %r141 = getelementptr inbounds [30 x i8], ptr @.str.82, i64 0, i64 0
  %r142 = ptrtoint ptr %r141 to i64
  %r143 = call i64 @nova_rt_add(i64 %r140, i64 %r142)
  %r144 = load i64, ptr %slot.args, align 8
  %r145 = call i64 @nova_rt_index_get(i64 %r144, i64 0)
  %r146 = call i64 @nova_rt_add(i64 %r143, i64 %r145)
  %r147 = getelementptr inbounds [7 x i8], ptr @.str.81, i64 0, i64 0
  %r148 = ptrtoint ptr %r147 to i64
  %r149 = call i64 @nova_rt_add(i64 %r146, i64 %r148)
  %r150 = load i64, ptr %slot.args, align 8
  %r151 = call i64 @nova_rt_index_get(i64 %r150, i64 1)
  %r152 = call i64 @nova_rt_add(i64 %r149, i64 %r151)
  %r153 = getelementptr inbounds [2 x i8], ptr @.str.78, i64 0, i64 0
  %r154 = ptrtoint ptr %r153 to i64
  %r155 = call i64 @nova_rt_add(i64 %r152, i64 %r154)
  %r156 = call i64 @emit_indent_line(i64 %r139, i64 %r155)
  ret i64 %r156
ret_else128:
  %r157 = load i64, ptr %slot.op, align 8
  %r158 = getelementptr inbounds [4 x i8], ptr @.str.17, i64 0, i64 0
  %r159 = ptrtoint ptr %r158 to i64
  %t161 = call i64 @nova_rt_eq(i64 %r157, i64 %r159)
  %r160 = and i64 %t161, 1
  %t162 = icmp ne i64 %t161, 0
  br i1 %t162, label %ret_then133, label %ret_else134
ret_then133:
  %r163 = load i64, ptr %slot.typ, align 8
  %t164 = inttoptr i64 %r163 to ptr
  %t165 = getelementptr i64, ptr %t164, i64 0
  %r166 = load i64, ptr %t165, align 8
  store i64 %r166, ptr %slot.tk, align 8
  %t167 = getelementptr i64, ptr %t164, i64 1
  %r168 = load i64, ptr %t167, align 8
  store i64 %r168, ptr %slot.tn, align 8
  %t169 = getelementptr i64, ptr %t164, i64 2
  %r170 = load i64, ptr %t169, align 8
  store i64 %r170, ptr %slot.tp, align 8
  %t171 = getelementptr i64, ptr %t164, i64 3
  %r172 = load i64, ptr %t171, align 8
  store i64 %r172, ptr %slot.tid, align 8
  %r173 = load i64, ptr %slot.tk, align 8
  %r174 = getelementptr inbounds [4 x i8], ptr @.str.0, i64 0, i64 0
  %r175 = ptrtoint ptr %r174 to i64
  %t177 = call i64 @nova_rt_eq(i64 %r173, i64 %r175)
  %r176 = and i64 %t177, 1
  %t178 = icmp ne i64 %t177, 0
  br i1 %t178, label %ret_then135, label %ret_else136
ret_then135:
  %r179 = load i64, ptr %slot.e, align 8
  %r180 = load i64, ptr %slot.dest, align 8
  %r181 = getelementptr inbounds [12 x i8], ptr @.str.83, i64 0, i64 0
  %r182 = ptrtoint ptr %r181 to i64
  %r183 = call i64 @nova_rt_add(i64 %r180, i64 %r182)
  %r184 = load i64, ptr %slot.args, align 8
  %r185 = call i64 @nova_rt_index_get(i64 %r184, i64 0)
  %r186 = call i64 @nova_rt_add(i64 %r183, i64 %r185)
  %r187 = getelementptr inbounds [3 x i8], ptr @.str.79, i64 0, i64 0
  %r188 = ptrtoint ptr %r187 to i64
  %r189 = call i64 @nova_rt_add(i64 %r186, i64 %r188)
  %r190 = load i64, ptr %slot.args, align 8
  %r191 = call i64 @nova_rt_index_get(i64 %r190, i64 1)
  %r192 = call i64 @nova_rt_add(i64 %r189, i64 %r191)
  %r193 = call i64 @emit_indent_line(i64 %r179, i64 %r192)
  ret i64 %r193
ret_else136:
  %r194 = load i64, ptr %slot.e, align 8
  %r195 = load i64, ptr %slot.dest, align 8
  %r196 = getelementptr inbounds [30 x i8], ptr @.str.84, i64 0, i64 0
  %r197 = ptrtoint ptr %r196 to i64
  %r198 = call i64 @nova_rt_add(i64 %r195, i64 %r197)
  %r199 = load i64, ptr %slot.args, align 8
  %r200 = call i64 @nova_rt_index_get(i64 %r199, i64 0)
  %r201 = call i64 @nova_rt_add(i64 %r198, i64 %r200)
  %r202 = getelementptr inbounds [7 x i8], ptr @.str.81, i64 0, i64 0
  %r203 = ptrtoint ptr %r202 to i64
  %r204 = call i64 @nova_rt_add(i64 %r201, i64 %r203)
  %r205 = load i64, ptr %slot.args, align 8
  %r206 = call i64 @nova_rt_index_get(i64 %r205, i64 1)
  %r207 = call i64 @nova_rt_add(i64 %r204, i64 %r206)
  %r208 = getelementptr inbounds [2 x i8], ptr @.str.78, i64 0, i64 0
  %r209 = ptrtoint ptr %r208 to i64
  %r210 = call i64 @nova_rt_add(i64 %r207, i64 %r209)
  %r211 = call i64 @emit_indent_line(i64 %r194, i64 %r210)
  ret i64 %r211
ret_else134:
  %r212 = load i64, ptr %slot.op, align 8
  %r213 = getelementptr inbounds [4 x i8], ptr @.str.19, i64 0, i64 0
  %r214 = ptrtoint ptr %r213 to i64
  %t216 = call i64 @nova_rt_eq(i64 %r212, i64 %r214)
  %r215 = and i64 %t216, 1
  %t217 = icmp ne i64 %t216, 0
  br i1 %t217, label %ret_then137, label %ret_else138
ret_then137:
  %r218 = load i64, ptr %slot.typ, align 8
  %t219 = inttoptr i64 %r218 to ptr
  %t220 = getelementptr i64, ptr %t219, i64 0
  %r221 = load i64, ptr %t220, align 8
  store i64 %r221, ptr %slot.tk, align 8
  %t222 = getelementptr i64, ptr %t219, i64 1
  %r223 = load i64, ptr %t222, align 8
  store i64 %r223, ptr %slot.tn, align 8
  %t224 = getelementptr i64, ptr %t219, i64 2
  %r225 = load i64, ptr %t224, align 8
  store i64 %r225, ptr %slot.tp, align 8
  %t226 = getelementptr i64, ptr %t219, i64 3
  %r227 = load i64, ptr %t226, align 8
  store i64 %r227, ptr %slot.tid, align 8
  %r228 = load i64, ptr %slot.tk, align 8
  %r229 = getelementptr inbounds [4 x i8], ptr @.str.0, i64 0, i64 0
  %r230 = ptrtoint ptr %r229 to i64
  %t232 = call i64 @nova_rt_eq(i64 %r228, i64 %r230)
  %r231 = and i64 %t232, 1
  %t233 = icmp ne i64 %t232, 0
  br i1 %t233, label %ret_then139, label %ret_else140
ret_then139:
  %r234 = load i64, ptr %slot.e, align 8
  %r235 = load i64, ptr %slot.dest, align 8
  %r236 = getelementptr inbounds [12 x i8], ptr @.str.85, i64 0, i64 0
  %r237 = ptrtoint ptr %r236 to i64
  %r238 = call i64 @nova_rt_add(i64 %r235, i64 %r237)
  %r239 = load i64, ptr %slot.args, align 8
  %r240 = call i64 @nova_rt_index_get(i64 %r239, i64 0)
  %r241 = call i64 @nova_rt_add(i64 %r238, i64 %r240)
  %r242 = getelementptr inbounds [3 x i8], ptr @.str.79, i64 0, i64 0
  %r243 = ptrtoint ptr %r242 to i64
  %r244 = call i64 @nova_rt_add(i64 %r241, i64 %r243)
  %r245 = load i64, ptr %slot.args, align 8
  %r246 = call i64 @nova_rt_index_get(i64 %r245, i64 1)
  %r247 = call i64 @nova_rt_add(i64 %r244, i64 %r246)
  %r248 = call i64 @emit_indent_line(i64 %r234, i64 %r247)
  ret i64 %r248
ret_else140:
  %r249 = load i64, ptr %slot.e, align 8
  %r250 = load i64, ptr %slot.dest, align 8
  %r251 = getelementptr inbounds [30 x i8], ptr @.str.86, i64 0, i64 0
  %r252 = ptrtoint ptr %r251 to i64
  %r253 = call i64 @nova_rt_add(i64 %r250, i64 %r252)
  %r254 = load i64, ptr %slot.args, align 8
  %r255 = call i64 @nova_rt_index_get(i64 %r254, i64 0)
  %r256 = call i64 @nova_rt_add(i64 %r253, i64 %r255)
  %r257 = getelementptr inbounds [7 x i8], ptr @.str.81, i64 0, i64 0
  %r258 = ptrtoint ptr %r257 to i64
  %r259 = call i64 @nova_rt_add(i64 %r256, i64 %r258)
  %r260 = load i64, ptr %slot.args, align 8
  %r261 = call i64 @nova_rt_index_get(i64 %r260, i64 1)
  %r262 = call i64 @nova_rt_add(i64 %r259, i64 %r261)
  %r263 = getelementptr inbounds [2 x i8], ptr @.str.78, i64 0, i64 0
  %r264 = ptrtoint ptr %r263 to i64
  %r265 = call i64 @nova_rt_add(i64 %r262, i64 %r264)
  %r266 = call i64 @emit_indent_line(i64 %r249, i64 %r265)
  ret i64 %r266
ret_else138:
  %r267 = load i64, ptr %slot.op, align 8
  %r268 = getelementptr inbounds [4 x i8], ptr @.str.21, i64 0, i64 0
  %r269 = ptrtoint ptr %r268 to i64
  %t271 = call i64 @nova_rt_eq(i64 %r267, i64 %r269)
  %r270 = and i64 %t271, 1
  %t272 = icmp ne i64 %t271, 0
  br i1 %t272, label %ret_then141, label %ret_else142
ret_then141:
  %r273 = load i64, ptr %slot.typ, align 8
  %t274 = inttoptr i64 %r273 to ptr
  %t275 = getelementptr i64, ptr %t274, i64 0
  %r276 = load i64, ptr %t275, align 8
  store i64 %r276, ptr %slot.tk, align 8
  %t277 = getelementptr i64, ptr %t274, i64 1
  %r278 = load i64, ptr %t277, align 8
  store i64 %r278, ptr %slot.tn, align 8
  %t279 = getelementptr i64, ptr %t274, i64 2
  %r280 = load i64, ptr %t279, align 8
  store i64 %r280, ptr %slot.tp, align 8
  %t281 = getelementptr i64, ptr %t274, i64 3
  %r282 = load i64, ptr %t281, align 8
  store i64 %r282, ptr %slot.tid, align 8
  %r283 = load i64, ptr %slot.tk, align 8
  %r284 = getelementptr inbounds [4 x i8], ptr @.str.0, i64 0, i64 0
  %r285 = ptrtoint ptr %r284 to i64
  %t287 = call i64 @nova_rt_eq(i64 %r283, i64 %r285)
  %r286 = and i64 %t287, 1
  %t288 = icmp ne i64 %t287, 0
  br i1 %t288, label %ret_then143, label %ret_else144
ret_then143:
  %r289 = load i64, ptr %slot.e, align 8
  %r290 = load i64, ptr %slot.dest, align 8
  %r291 = getelementptr inbounds [13 x i8], ptr @.str.87, i64 0, i64 0
  %r292 = ptrtoint ptr %r291 to i64
  %r293 = call i64 @nova_rt_add(i64 %r290, i64 %r292)
  %r294 = load i64, ptr %slot.args, align 8
  %r295 = call i64 @nova_rt_index_get(i64 %r294, i64 0)
  %r296 = call i64 @nova_rt_add(i64 %r293, i64 %r295)
  %r297 = getelementptr inbounds [3 x i8], ptr @.str.79, i64 0, i64 0
  %r298 = ptrtoint ptr %r297 to i64
  %r299 = call i64 @nova_rt_add(i64 %r296, i64 %r298)
  %r300 = load i64, ptr %slot.args, align 8
  %r301 = call i64 @nova_rt_index_get(i64 %r300, i64 1)
  %r302 = call i64 @nova_rt_add(i64 %r299, i64 %r301)
  %r303 = call i64 @emit_indent_line(i64 %r289, i64 %r302)
  ret i64 %r303
ret_else144:
  %r304 = load i64, ptr %slot.e, align 8
  %r305 = load i64, ptr %slot.dest, align 8
  %r306 = getelementptr inbounds [30 x i8], ptr @.str.88, i64 0, i64 0
  %r307 = ptrtoint ptr %r306 to i64
  %r308 = call i64 @nova_rt_add(i64 %r305, i64 %r307)
  %r309 = load i64, ptr %slot.args, align 8
  %r310 = call i64 @nova_rt_index_get(i64 %r309, i64 0)
  %r311 = call i64 @nova_rt_add(i64 %r308, i64 %r310)
  %r312 = getelementptr inbounds [7 x i8], ptr @.str.81, i64 0, i64 0
  %r313 = ptrtoint ptr %r312 to i64
  %r314 = call i64 @nova_rt_add(i64 %r311, i64 %r313)
  %r315 = load i64, ptr %slot.args, align 8
  %r316 = call i64 @nova_rt_index_get(i64 %r315, i64 1)
  %r317 = call i64 @nova_rt_add(i64 %r314, i64 %r316)
  %r318 = getelementptr inbounds [2 x i8], ptr @.str.78, i64 0, i64 0
  %r319 = ptrtoint ptr %r318 to i64
  %r320 = call i64 @nova_rt_add(i64 %r317, i64 %r319)
  %r321 = call i64 @emit_indent_line(i64 %r304, i64 %r320)
  ret i64 %r321
ret_else142:
  %r322 = load i64, ptr %slot.op, align 8
  %r323 = getelementptr inbounds [4 x i8], ptr @.str.23, i64 0, i64 0
  %r324 = ptrtoint ptr %r323 to i64
  %t326 = call i64 @nova_rt_eq(i64 %r322, i64 %r324)
  %r325 = and i64 %t326, 1
  %t327 = icmp ne i64 %t326, 0
  br i1 %t327, label %ret_then145, label %ret_else146
ret_then145:
  %r328 = load i64, ptr %slot.e, align 8
  %r329 = load i64, ptr %slot.dest, align 8
  %r330 = getelementptr inbounds [13 x i8], ptr @.str.89, i64 0, i64 0
  %r331 = ptrtoint ptr %r330 to i64
  %r332 = call i64 @nova_rt_add(i64 %r329, i64 %r331)
  %r333 = load i64, ptr %slot.args, align 8
  %r334 = call i64 @nova_rt_index_get(i64 %r333, i64 0)
  %r335 = call i64 @nova_rt_add(i64 %r332, i64 %r334)
  %r336 = getelementptr inbounds [3 x i8], ptr @.str.79, i64 0, i64 0
  %r337 = ptrtoint ptr %r336 to i64
  %r338 = call i64 @nova_rt_add(i64 %r335, i64 %r337)
  %r339 = load i64, ptr %slot.args, align 8
  %r340 = call i64 @nova_rt_index_get(i64 %r339, i64 1)
  %r341 = call i64 @nova_rt_add(i64 %r338, i64 %r340)
  %r342 = call i64 @emit_indent_line(i64 %r328, i64 %r341)
  ret i64 %r342
ret_else146:
  %r343 = load i64, ptr %slot.op, align 8
  %r344 = getelementptr inbounds [4 x i8], ptr @.str.39, i64 0, i64 0
  %r345 = ptrtoint ptr %r344 to i64
  %t347 = call i64 @nova_rt_eq(i64 %r343, i64 %r345)
  %r346 = and i64 %t347, 1
  %t348 = icmp ne i64 %t347, 0
  br i1 %t348, label %ret_then147, label %ret_else148
ret_then147:
  %r349 = load i64, ptr %slot.e, align 8
  %r350 = load i64, ptr %slot.dest, align 8
  %r351 = getelementptr inbounds [15 x i8], ptr @.str.90, i64 0, i64 0
  %r352 = ptrtoint ptr %r351 to i64
  %r353 = call i64 @nova_rt_add(i64 %r350, i64 %r352)
  %r354 = load i64, ptr %slot.args, align 8
  %r355 = call i64 @nova_rt_index_get(i64 %r354, i64 0)
  %r356 = call i64 @nova_rt_add(i64 %r353, i64 %r355)
  %r357 = call i64 @emit_indent_line(i64 %r349, i64 %r356)
  ret i64 %r357
ret_else148:
  %r358 = load i64, ptr %slot.op, align 8
  %r359 = getelementptr inbounds [3 x i8], ptr @.str.25, i64 0, i64 0
  %r360 = ptrtoint ptr %r359 to i64
  %t362 = call i64 @nova_rt_eq(i64 %r358, i64 %r360)
  %r361 = and i64 %t362, 1
  %t363 = icmp ne i64 %t362, 0
  br i1 %t363, label %ret_then149, label %ret_else150
ret_then149:
  %r364 = load i64, ptr %slot.dest, align 8
  %r365 = getelementptr inbounds [5 x i8], ptr @.str.91, i64 0, i64 0
  %r366 = ptrtoint ptr %r365 to i64
  %r367 = call i64 @nova_rt_add(i64 %r364, i64 %r366)
  store i64 %r367, ptr %slot.tmp, align 8
  %r368 = load i64, ptr %slot.e, align 8
  %r369 = load i64, ptr %slot.tmp, align 8
  %r370 = getelementptr inbounds [16 x i8], ptr @.str.92, i64 0, i64 0
  %r371 = ptrtoint ptr %r370 to i64
  %r372 = call i64 @nova_rt_add(i64 %r369, i64 %r371)
  %r373 = load i64, ptr %slot.args, align 8
  %r374 = call i64 @nova_rt_index_get(i64 %r373, i64 0)
  %r375 = call i64 @nova_rt_add(i64 %r372, i64 %r374)
  %r376 = getelementptr inbounds [3 x i8], ptr @.str.79, i64 0, i64 0
  %r377 = ptrtoint ptr %r376 to i64
  %r378 = call i64 @nova_rt_add(i64 %r375, i64 %r377)
  %r379 = load i64, ptr %slot.args, align 8
  %r380 = call i64 @nova_rt_index_get(i64 %r379, i64 1)
  %r381 = call i64 @nova_rt_add(i64 %r378, i64 %r380)
  %r382 = call i64 @emit_indent_line(i64 %r368, i64 %r381)
  %r383 = load i64, ptr %slot.e, align 8
  %r384 = load i64, ptr %slot.dest, align 8
  %r385 = getelementptr inbounds [12 x i8], ptr @.str.93, i64 0, i64 0
  %r386 = ptrtoint ptr %r385 to i64
  %r387 = call i64 @nova_rt_add(i64 %r384, i64 %r386)
  %r388 = load i64, ptr %slot.tmp, align 8
  %r389 = call i64 @nova_rt_add(i64 %r387, i64 %r388)
  %r390 = getelementptr inbounds [8 x i8], ptr @.str.94, i64 0, i64 0
  %r391 = ptrtoint ptr %r390 to i64
  %r392 = call i64 @nova_rt_add(i64 %r389, i64 %r391)
  %r393 = call i64 @emit_indent_line(i64 %r383, i64 %r392)
  ret i64 %r393
ret_else150:
  %r394 = load i64, ptr %slot.op, align 8
  %r395 = getelementptr inbounds [4 x i8], ptr @.str.27, i64 0, i64 0
  %r396 = ptrtoint ptr %r395 to i64
  %t398 = call i64 @nova_rt_eq(i64 %r394, i64 %r396)
  %r397 = and i64 %t398, 1
  %t399 = icmp ne i64 %t398, 0
  br i1 %t399, label %ret_then151, label %ret_else152
ret_then151:
  %r400 = load i64, ptr %slot.dest, align 8
  %r401 = getelementptr inbounds [5 x i8], ptr @.str.91, i64 0, i64 0
  %r402 = ptrtoint ptr %r401 to i64
  %r403 = call i64 @nova_rt_add(i64 %r400, i64 %r402)
  store i64 %r403, ptr %slot.tmp, align 8
  %r404 = load i64, ptr %slot.e, align 8
  %r405 = load i64, ptr %slot.tmp, align 8
  %r406 = getelementptr inbounds [16 x i8], ptr @.str.95, i64 0, i64 0
  %r407 = ptrtoint ptr %r406 to i64
  %r408 = call i64 @nova_rt_add(i64 %r405, i64 %r407)
  %r409 = load i64, ptr %slot.args, align 8
  %r410 = call i64 @nova_rt_index_get(i64 %r409, i64 0)
  %r411 = call i64 @nova_rt_add(i64 %r408, i64 %r410)
  %r412 = getelementptr inbounds [3 x i8], ptr @.str.79, i64 0, i64 0
  %r413 = ptrtoint ptr %r412 to i64
  %r414 = call i64 @nova_rt_add(i64 %r411, i64 %r413)
  %r415 = load i64, ptr %slot.args, align 8
  %r416 = call i64 @nova_rt_index_get(i64 %r415, i64 1)
  %r417 = call i64 @nova_rt_add(i64 %r414, i64 %r416)
  %r418 = call i64 @emit_indent_line(i64 %r404, i64 %r417)
  %r419 = load i64, ptr %slot.e, align 8
  %r420 = load i64, ptr %slot.dest, align 8
  %r421 = getelementptr inbounds [12 x i8], ptr @.str.93, i64 0, i64 0
  %r422 = ptrtoint ptr %r421 to i64
  %r423 = call i64 @nova_rt_add(i64 %r420, i64 %r422)
  %r424 = load i64, ptr %slot.tmp, align 8
  %r425 = call i64 @nova_rt_add(i64 %r423, i64 %r424)
  %r426 = getelementptr inbounds [8 x i8], ptr @.str.94, i64 0, i64 0
  %r427 = ptrtoint ptr %r426 to i64
  %r428 = call i64 @nova_rt_add(i64 %r425, i64 %r427)
  %r429 = call i64 @emit_indent_line(i64 %r419, i64 %r428)
  ret i64 %r429
ret_else152:
  %r430 = load i64, ptr %slot.op, align 8
  %r431 = getelementptr inbounds [3 x i8], ptr @.str.29, i64 0, i64 0
  %r432 = ptrtoint ptr %r431 to i64
  %t434 = call i64 @nova_rt_eq(i64 %r430, i64 %r432)
  %r433 = and i64 %t434, 1
  %t435 = icmp ne i64 %t434, 0
  br i1 %t435, label %ret_then153, label %ret_else154
ret_then153:
  %r436 = load i64, ptr %slot.dest, align 8
  %r437 = getelementptr inbounds [5 x i8], ptr @.str.91, i64 0, i64 0
  %r438 = ptrtoint ptr %r437 to i64
  %r439 = call i64 @nova_rt_add(i64 %r436, i64 %r438)
  store i64 %r439, ptr %slot.tmp, align 8
  %r440 = load i64, ptr %slot.e, align 8
  %r441 = load i64, ptr %slot.tmp, align 8
  %r442 = getelementptr inbounds [17 x i8], ptr @.str.96, i64 0, i64 0
  %r443 = ptrtoint ptr %r442 to i64
  %r444 = call i64 @nova_rt_add(i64 %r441, i64 %r443)
  %r445 = load i64, ptr %slot.args, align 8
  %r446 = call i64 @nova_rt_index_get(i64 %r445, i64 0)
  %r447 = call i64 @nova_rt_add(i64 %r444, i64 %r446)
  %r448 = getelementptr inbounds [3 x i8], ptr @.str.79, i64 0, i64 0
  %r449 = ptrtoint ptr %r448 to i64
  %r450 = call i64 @nova_rt_add(i64 %r447, i64 %r449)
  %r451 = load i64, ptr %slot.args, align 8
  %r452 = call i64 @nova_rt_index_get(i64 %r451, i64 1)
  %r453 = call i64 @nova_rt_add(i64 %r450, i64 %r452)
  %r454 = call i64 @emit_indent_line(i64 %r440, i64 %r453)
  %r455 = load i64, ptr %slot.e, align 8
  %r456 = load i64, ptr %slot.dest, align 8
  %r457 = getelementptr inbounds [12 x i8], ptr @.str.93, i64 0, i64 0
  %r458 = ptrtoint ptr %r457 to i64
  %r459 = call i64 @nova_rt_add(i64 %r456, i64 %r458)
  %r460 = load i64, ptr %slot.tmp, align 8
  %r461 = call i64 @nova_rt_add(i64 %r459, i64 %r460)
  %r462 = getelementptr inbounds [8 x i8], ptr @.str.94, i64 0, i64 0
  %r463 = ptrtoint ptr %r462 to i64
  %r464 = call i64 @nova_rt_add(i64 %r461, i64 %r463)
  %r465 = call i64 @emit_indent_line(i64 %r455, i64 %r464)
  ret i64 %r465
ret_else154:
  %r466 = load i64, ptr %slot.op, align 8
  %r467 = getelementptr inbounds [3 x i8], ptr @.str.31, i64 0, i64 0
  %r468 = ptrtoint ptr %r467 to i64
  %t470 = call i64 @nova_rt_eq(i64 %r466, i64 %r468)
  %r469 = and i64 %t470, 1
  %t471 = icmp ne i64 %t470, 0
  br i1 %t471, label %ret_then155, label %ret_else156
ret_then155:
  %r472 = load i64, ptr %slot.dest, align 8
  %r473 = getelementptr inbounds [5 x i8], ptr @.str.91, i64 0, i64 0
  %r474 = ptrtoint ptr %r473 to i64
  %r475 = call i64 @nova_rt_add(i64 %r472, i64 %r474)
  store i64 %r475, ptr %slot.tmp, align 8
  %r476 = load i64, ptr %slot.e, align 8
  %r477 = load i64, ptr %slot.tmp, align 8
  %r478 = getelementptr inbounds [17 x i8], ptr @.str.97, i64 0, i64 0
  %r479 = ptrtoint ptr %r478 to i64
  %r480 = call i64 @nova_rt_add(i64 %r477, i64 %r479)
  %r481 = load i64, ptr %slot.args, align 8
  %r482 = call i64 @nova_rt_index_get(i64 %r481, i64 0)
  %r483 = call i64 @nova_rt_add(i64 %r480, i64 %r482)
  %r484 = getelementptr inbounds [3 x i8], ptr @.str.79, i64 0, i64 0
  %r485 = ptrtoint ptr %r484 to i64
  %r486 = call i64 @nova_rt_add(i64 %r483, i64 %r485)
  %r487 = load i64, ptr %slot.args, align 8
  %r488 = call i64 @nova_rt_index_get(i64 %r487, i64 1)
  %r489 = call i64 @nova_rt_add(i64 %r486, i64 %r488)
  %r490 = call i64 @emit_indent_line(i64 %r476, i64 %r489)
  %r491 = load i64, ptr %slot.e, align 8
  %r492 = load i64, ptr %slot.dest, align 8
  %r493 = getelementptr inbounds [12 x i8], ptr @.str.93, i64 0, i64 0
  %r494 = ptrtoint ptr %r493 to i64
  %r495 = call i64 @nova_rt_add(i64 %r492, i64 %r494)
  %r496 = load i64, ptr %slot.tmp, align 8
  %r497 = call i64 @nova_rt_add(i64 %r495, i64 %r496)
  %r498 = getelementptr inbounds [8 x i8], ptr @.str.94, i64 0, i64 0
  %r499 = ptrtoint ptr %r498 to i64
  %r500 = call i64 @nova_rt_add(i64 %r497, i64 %r499)
  %r501 = call i64 @emit_indent_line(i64 %r491, i64 %r500)
  ret i64 %r501
ret_else156:
  %r502 = load i64, ptr %slot.op, align 8
  %r503 = getelementptr inbounds [3 x i8], ptr @.str.33, i64 0, i64 0
  %r504 = ptrtoint ptr %r503 to i64
  %t506 = call i64 @nova_rt_eq(i64 %r502, i64 %r504)
  %r505 = and i64 %t506, 1
  %t507 = icmp ne i64 %t506, 0
  br i1 %t507, label %ret_then157, label %ret_else158
ret_then157:
  %r508 = load i64, ptr %slot.dest, align 8
  %r509 = getelementptr inbounds [5 x i8], ptr @.str.91, i64 0, i64 0
  %r510 = ptrtoint ptr %r509 to i64
  %r511 = call i64 @nova_rt_add(i64 %r508, i64 %r510)
  store i64 %r511, ptr %slot.tmp, align 8
  %r512 = load i64, ptr %slot.e, align 8
  %r513 = load i64, ptr %slot.tmp, align 8
  %r514 = getelementptr inbounds [17 x i8], ptr @.str.98, i64 0, i64 0
  %r515 = ptrtoint ptr %r514 to i64
  %r516 = call i64 @nova_rt_add(i64 %r513, i64 %r515)
  %r517 = load i64, ptr %slot.args, align 8
  %r518 = call i64 @nova_rt_index_get(i64 %r517, i64 0)
  %r519 = call i64 @nova_rt_add(i64 %r516, i64 %r518)
  %r520 = getelementptr inbounds [3 x i8], ptr @.str.79, i64 0, i64 0
  %r521 = ptrtoint ptr %r520 to i64
  %r522 = call i64 @nova_rt_add(i64 %r519, i64 %r521)
  %r523 = load i64, ptr %slot.args, align 8
  %r524 = call i64 @nova_rt_index_get(i64 %r523, i64 1)
  %r525 = call i64 @nova_rt_add(i64 %r522, i64 %r524)
  %r526 = call i64 @emit_indent_line(i64 %r512, i64 %r525)
  %r527 = load i64, ptr %slot.e, align 8
  %r528 = load i64, ptr %slot.dest, align 8
  %r529 = getelementptr inbounds [12 x i8], ptr @.str.93, i64 0, i64 0
  %r530 = ptrtoint ptr %r529 to i64
  %r531 = call i64 @nova_rt_add(i64 %r528, i64 %r530)
  %r532 = load i64, ptr %slot.tmp, align 8
  %r533 = call i64 @nova_rt_add(i64 %r531, i64 %r532)
  %r534 = getelementptr inbounds [8 x i8], ptr @.str.94, i64 0, i64 0
  %r535 = ptrtoint ptr %r534 to i64
  %r536 = call i64 @nova_rt_add(i64 %r533, i64 %r535)
  %r537 = call i64 @emit_indent_line(i64 %r527, i64 %r536)
  ret i64 %r537
ret_else158:
  %r538 = load i64, ptr %slot.op, align 8
  %r539 = getelementptr inbounds [3 x i8], ptr @.str.35, i64 0, i64 0
  %r540 = ptrtoint ptr %r539 to i64
  %t542 = call i64 @nova_rt_eq(i64 %r538, i64 %r540)
  %r541 = and i64 %t542, 1
  %t543 = icmp ne i64 %t542, 0
  br i1 %t543, label %ret_then159, label %ret_else160
ret_then159:
  %r544 = load i64, ptr %slot.dest, align 8
  %r545 = getelementptr inbounds [5 x i8], ptr @.str.91, i64 0, i64 0
  %r546 = ptrtoint ptr %r545 to i64
  %r547 = call i64 @nova_rt_add(i64 %r544, i64 %r546)
  store i64 %r547, ptr %slot.tmp, align 8
  %r548 = load i64, ptr %slot.e, align 8
  %r549 = load i64, ptr %slot.tmp, align 8
  %r550 = getelementptr inbounds [17 x i8], ptr @.str.99, i64 0, i64 0
  %r551 = ptrtoint ptr %r550 to i64
  %r552 = call i64 @nova_rt_add(i64 %r549, i64 %r551)
  %r553 = load i64, ptr %slot.args, align 8
  %r554 = call i64 @nova_rt_index_get(i64 %r553, i64 0)
  %r555 = call i64 @nova_rt_add(i64 %r552, i64 %r554)
  %r556 = getelementptr inbounds [3 x i8], ptr @.str.79, i64 0, i64 0
  %r557 = ptrtoint ptr %r556 to i64
  %r558 = call i64 @nova_rt_add(i64 %r555, i64 %r557)
  %r559 = load i64, ptr %slot.args, align 8
  %r560 = call i64 @nova_rt_index_get(i64 %r559, i64 1)
  %r561 = call i64 @nova_rt_add(i64 %r558, i64 %r560)
  %r562 = call i64 @emit_indent_line(i64 %r548, i64 %r561)
  %r563 = load i64, ptr %slot.e, align 8
  %r564 = load i64, ptr %slot.dest, align 8
  %r565 = getelementptr inbounds [12 x i8], ptr @.str.93, i64 0, i64 0
  %r566 = ptrtoint ptr %r565 to i64
  %r567 = call i64 @nova_rt_add(i64 %r564, i64 %r566)
  %r568 = load i64, ptr %slot.tmp, align 8
  %r569 = call i64 @nova_rt_add(i64 %r567, i64 %r568)
  %r570 = getelementptr inbounds [8 x i8], ptr @.str.94, i64 0, i64 0
  %r571 = ptrtoint ptr %r570 to i64
  %r572 = call i64 @nova_rt_add(i64 %r569, i64 %r571)
  %r573 = call i64 @emit_indent_line(i64 %r563, i64 %r572)
  ret i64 %r573
ret_else160:
  %r574 = load i64, ptr %slot.op, align 8
  %r575 = getelementptr inbounds [4 x i8], ptr @.str.40, i64 0, i64 0
  %r576 = ptrtoint ptr %r575 to i64
  %t578 = call i64 @nova_rt_eq(i64 %r574, i64 %r576)
  %r577 = and i64 %t578, 1
  %t579 = icmp ne i64 %t578, 0
  br i1 %t579, label %ret_then161, label %ret_else162
ret_then161:
  %r580 = load i64, ptr %slot.dest, align 8
  %r581 = getelementptr inbounds [5 x i8], ptr @.str.91, i64 0, i64 0
  %r582 = ptrtoint ptr %r581 to i64
  %r583 = call i64 @nova_rt_add(i64 %r580, i64 %r582)
  store i64 %r583, ptr %slot.tmp, align 8
  %r584 = load i64, ptr %slot.e, align 8
  %r585 = load i64, ptr %slot.tmp, align 8
  %r586 = getelementptr inbounds [16 x i8], ptr @.str.92, i64 0, i64 0
  %r587 = ptrtoint ptr %r586 to i64
  %r588 = call i64 @nova_rt_add(i64 %r585, i64 %r587)
  %r589 = load i64, ptr %slot.args, align 8
  %r590 = call i64 @nova_rt_index_get(i64 %r589, i64 0)
  %r591 = call i64 @nova_rt_add(i64 %r588, i64 %r590)
  %r592 = getelementptr inbounds [4 x i8], ptr @.str.72, i64 0, i64 0
  %r593 = ptrtoint ptr %r592 to i64
  %r594 = call i64 @nova_rt_add(i64 %r591, i64 %r593)
  %r595 = call i64 @emit_indent_line(i64 %r584, i64 %r594)
  %r596 = load i64, ptr %slot.e, align 8
  %r597 = load i64, ptr %slot.dest, align 8
  %r598 = getelementptr inbounds [12 x i8], ptr @.str.93, i64 0, i64 0
  %r599 = ptrtoint ptr %r598 to i64
  %r600 = call i64 @nova_rt_add(i64 %r597, i64 %r599)
  %r601 = load i64, ptr %slot.tmp, align 8
  %r602 = call i64 @nova_rt_add(i64 %r600, i64 %r601)
  %r603 = getelementptr inbounds [8 x i8], ptr @.str.94, i64 0, i64 0
  %r604 = ptrtoint ptr %r603 to i64
  %r605 = call i64 @nova_rt_add(i64 %r602, i64 %r604)
  %r606 = call i64 @emit_indent_line(i64 %r596, i64 %r605)
  ret i64 %r606
ret_else162:
  %r607 = load i64, ptr %slot.op, align 8
  %r608 = getelementptr inbounds [10 x i8], ptr @.str.12, i64 0, i64 0
  %r609 = ptrtoint ptr %r608 to i64
  %t611 = call i64 @nova_rt_eq(i64 %r607, i64 %r609)
  %r610 = and i64 %t611, 1
  %t612 = icmp ne i64 %t611, 0
  br i1 %t612, label %ret_then163, label %ret_else164
ret_then163:
  %r613 = load i64, ptr %slot.e, align 8
  %r614 = load i64, ptr %slot.dest, align 8
  %r615 = getelementptr inbounds [24 x i8], ptr @.str.100, i64 0, i64 0
  %r616 = ptrtoint ptr %r615 to i64
  %r617 = call i64 @nova_rt_add(i64 %r614, i64 %r616)
  %r618 = load i64, ptr %slot.value, align 8
  %r619 = call i64 @nova_rt_add(i64 %r617, i64 %r618)
  %r620 = getelementptr inbounds [10 x i8], ptr @.str.101, i64 0, i64 0
  %r621 = ptrtoint ptr %r620 to i64
  %r622 = call i64 @nova_rt_add(i64 %r619, i64 %r621)
  %r623 = call i64 @emit_indent_line(i64 %r613, i64 %r622)
  ret i64 %r623
ret_else164:
  %r624 = load i64, ptr %slot.op, align 8
  %r625 = getelementptr inbounds [11 x i8], ptr @.str.51, i64 0, i64 0
  %r626 = ptrtoint ptr %r625 to i64
  %t628 = call i64 @nova_rt_eq(i64 %r624, i64 %r626)
  %r627 = and i64 %t628, 1
  %t629 = icmp ne i64 %t628, 0
  br i1 %t629, label %ret_then165, label %ret_else166
ret_then165:
  %r630 = load i64, ptr %slot.e, align 8
  %r631 = getelementptr inbounds [11 x i8], ptr @.str.102, i64 0, i64 0
  %r632 = ptrtoint ptr %r631 to i64
  %r633 = load i64, ptr %slot.args, align 8
  %r634 = call i64 @nova_rt_index_get(i64 %r633, i64 0)
  %r635 = call i64 @nova_rt_add(i64 %r632, i64 %r634)
  %r636 = getelementptr inbounds [13 x i8], ptr @.str.103, i64 0, i64 0
  %r637 = ptrtoint ptr %r636 to i64
  %r638 = call i64 @nova_rt_add(i64 %r635, i64 %r637)
  %r639 = load i64, ptr %slot.value, align 8
  %r640 = call i64 @nova_rt_add(i64 %r638, i64 %r639)
  %r641 = getelementptr inbounds [10 x i8], ptr @.str.101, i64 0, i64 0
  %r642 = ptrtoint ptr %r641 to i64
  %r643 = call i64 @nova_rt_add(i64 %r640, i64 %r642)
  %r644 = call i64 @emit_indent_line(i64 %r630, i64 %r643)
  ret i64 %r644
ret_else166:
  %r645 = load i64, ptr %slot.op, align 8
  %r646 = getelementptr inbounds [5 x i8], ptr @.str.36, i64 0, i64 0
  %r647 = ptrtoint ptr %r646 to i64
  %t649 = call i64 @nova_rt_eq(i64 %r645, i64 %r647)
  %r648 = and i64 %t649, 1
  %t650 = icmp ne i64 %t649, 0
  br i1 %t650, label %ret_then167, label %ret_else168
ret_then167:
  %r651 = getelementptr inbounds [11 x i8], ptr @.str.104, i64 0, i64 0
  %r652 = ptrtoint ptr %r651 to i64
  %r653 = load i64, ptr %slot.value, align 8
  %r654 = call i64 @nova_rt_add(i64 %r652, i64 %r653)
  %r655 = getelementptr inbounds [2 x i8], ptr @.str.105, i64 0, i64 0
  %r656 = ptrtoint ptr %r655 to i64
  %r657 = call i64 @nova_rt_add(i64 %r654, i64 %r656)
  store i64 %r657, ptr %slot.call_str, align 8
  store i64 0, ptr %slot.i, align 8
  br label %while_hdr169
while_hdr169:
  %r658 = load i64, ptr %slot.i, align 8
  %r659 = load i64, ptr %slot.args, align 8
  %r660 = call i64 @nova_rt_len_any(i64 %r659)
  %t662 = icmp slt i64 %r658, %r660
  %r661 = zext i1 %t662 to i64
  %t663 = icmp ne i64 %r661, 0
  br i1 %t663, label %while_body170, label %while_exit171
while_body170:
  %r664 = load i64, ptr %slot.i, align 8
  %t666 = icmp sgt i64 %r664, 0
  %r665 = zext i1 %t666 to i64
  %t667 = icmp ne i64 %r665, 0
  br i1 %t667, label %then172, label %else173
then172:
  %r668 = load i64, ptr %slot.call_str, align 8
  %r669 = getelementptr inbounds [3 x i8], ptr @.str.79, i64 0, i64 0
  %r670 = ptrtoint ptr %r669 to i64
  %r671 = call i64 @nova_rt_add(i64 %r668, i64 %r670)
  store i64 %r671, ptr %slot.call_str, align 8
  br label %merge174
else173:
  br label %merge174
merge174:
  %r672 = load i64, ptr %slot.call_str, align 8
  %r673 = getelementptr inbounds [5 x i8], ptr @.str.106, i64 0, i64 0
  %r674 = ptrtoint ptr %r673 to i64
  %r675 = call i64 @nova_rt_add(i64 %r672, i64 %r674)
  %r676 = load i64, ptr %slot.args, align 8
  %r677 = load i64, ptr %slot.i, align 8
  %r678 = call i64 @nova_rt_index_get(i64 %r676, i64 %r677)
  %r679 = call i64 @nova_rt_add(i64 %r675, i64 %r678)
  store i64 %r679, ptr %slot.call_str, align 8
  %r680 = load i64, ptr %slot.i, align 8
  %r681 = call i64 @nova_rt_add(i64 %r680, i64 1)
  store i64 %r681, ptr %slot.i, align 8
  br label %while_hdr169
while_exit171:
  %r682 = load i64, ptr %slot.call_str, align 8
  %r683 = getelementptr inbounds [2 x i8], ptr @.str.78, i64 0, i64 0
  %r684 = ptrtoint ptr %r683 to i64
  %r685 = call i64 @nova_rt_add(i64 %r682, i64 %r684)
  store i64 %r685, ptr %slot.call_str, align 8
  %r686 = load i64, ptr %slot.dest, align 8
  %r687 = getelementptr inbounds [1 x i8], ptr @.str.1, i64 0, i64 0
  %r688 = ptrtoint ptr %r687 to i64
  %t690 = call i64 @nova_rt_neq(i64 %r686, i64 %r688)
  %t691 = icmp ne i64 %t690, 0
  br i1 %t691, label %ret_then175, label %ret_else176
ret_then175:
  %r692 = load i64, ptr %slot.e, align 8
  %r693 = load i64, ptr %slot.dest, align 8
  %r694 = getelementptr inbounds [4 x i8], ptr @.str.107, i64 0, i64 0
  %r695 = ptrtoint ptr %r694 to i64
  %r696 = call i64 @nova_rt_add(i64 %r693, i64 %r695)
  %r697 = load i64, ptr %slot.call_str, align 8
  %r698 = call i64 @nova_rt_add(i64 %r696, i64 %r697)
  %r699 = call i64 @emit_indent_line(i64 %r692, i64 %r698)
  ret i64 %r699
ret_else176:
  %r700 = load i64, ptr %slot.e, align 8
  %r701 = load i64, ptr %slot.call_str, align 8
  %r702 = call i64 @emit_indent_line(i64 %r700, i64 %r701)
  ret i64 %r702
ret_else168:
  %r703 = load i64, ptr %slot.op, align 8
  %r704 = getelementptr inbounds [10 x i8], ptr @.str.42, i64 0, i64 0
  %r705 = ptrtoint ptr %r704 to i64
  %t707 = call i64 @nova_rt_eq(i64 %r703, i64 %r705)
  %r706 = and i64 %t707, 1
  %t708 = icmp ne i64 %t707, 0
  br i1 %t708, label %ret_then177, label %ret_else178
ret_then177:
  %r709 = load i64, ptr %slot.e, align 8
  %r710 = load i64, ptr %slot.dest, align 8
  %r711 = getelementptr inbounds [35 x i8], ptr @.str.108, i64 0, i64 0
  %r712 = ptrtoint ptr %r711 to i64
  %r713 = call i64 @nova_rt_add(i64 %r710, i64 %r712)
  %r714 = call i64 @emit_indent_line(i64 %r709, i64 %r713)
  store i64 0, ptr %slot.i, align 8
  br label %while_hdr179
while_hdr179:
  %r715 = load i64, ptr %slot.i, align 8
  %r716 = load i64, ptr %slot.args, align 8
  %r717 = call i64 @nova_rt_len_any(i64 %r716)
  %t719 = icmp slt i64 %r715, %r717
  %r718 = zext i1 %t719 to i64
  %t720 = icmp ne i64 %r718, 0
  br i1 %t720, label %while_body180, label %while_exit181
while_body180:
  %r721 = load i64, ptr %slot.e, align 8
  %r722 = getelementptr inbounds [35 x i8], ptr @.str.109, i64 0, i64 0
  %r723 = ptrtoint ptr %r722 to i64
  %r724 = load i64, ptr %slot.dest, align 8
  %r725 = call i64 @nova_rt_add(i64 %r723, i64 %r724)
  %r726 = getelementptr inbounds [7 x i8], ptr @.str.81, i64 0, i64 0
  %r727 = ptrtoint ptr %r726 to i64
  %r728 = call i64 @nova_rt_add(i64 %r725, i64 %r727)
  %r729 = load i64, ptr %slot.args, align 8
  %r730 = load i64, ptr %slot.i, align 8
  %r731 = call i64 @nova_rt_index_get(i64 %r729, i64 %r730)
  %r732 = call i64 @nova_rt_add(i64 %r728, i64 %r731)
  %r733 = getelementptr inbounds [2 x i8], ptr @.str.78, i64 0, i64 0
  %r734 = ptrtoint ptr %r733 to i64
  %r735 = call i64 @nova_rt_add(i64 %r732, i64 %r734)
  %r736 = call i64 @emit_indent_line(i64 %r721, i64 %r735)
  %r737 = load i64, ptr %slot.i, align 8
  %r738 = call i64 @nova_rt_add(i64 %r737, i64 1)
  store i64 %r738, ptr %slot.i, align 8
  br label %while_hdr179
while_exit181:
  ret i64 0
ret_else178:
  %r739 = load i64, ptr %slot.op, align 8
  %r740 = getelementptr inbounds [10 x i8], ptr @.str.44, i64 0, i64 0
  %r741 = ptrtoint ptr %r740 to i64
  %t743 = call i64 @nova_rt_eq(i64 %r739, i64 %r741)
  %r742 = and i64 %t743, 1
  %t744 = icmp ne i64 %t743, 0
  br i1 %t744, label %ret_then182, label %ret_else183
ret_then182:
  %r745 = load i64, ptr %slot.e, align 8
  %r746 = load i64, ptr %slot.dest, align 8
  %r747 = getelementptr inbounds [36 x i8], ptr @.str.110, i64 0, i64 0
  %r748 = ptrtoint ptr %r747 to i64
  %r749 = call i64 @nova_rt_add(i64 %r746, i64 %r748)
  %r750 = load i64, ptr %slot.args, align 8
  %r751 = call i64 @nova_rt_index_get(i64 %r750, i64 0)
  %r752 = call i64 @nova_rt_add(i64 %r749, i64 %r751)
  %r753 = getelementptr inbounds [7 x i8], ptr @.str.81, i64 0, i64 0
  %r754 = ptrtoint ptr %r753 to i64
  %r755 = call i64 @nova_rt_add(i64 %r752, i64 %r754)
  %r756 = load i64, ptr %slot.args, align 8
  %r757 = call i64 @nova_rt_index_get(i64 %r756, i64 1)
  %r758 = call i64 @nova_rt_add(i64 %r755, i64 %r757)
  %r759 = getelementptr inbounds [2 x i8], ptr @.str.78, i64 0, i64 0
  %r760 = ptrtoint ptr %r759 to i64
  %r761 = call i64 @nova_rt_add(i64 %r758, i64 %r760)
  %r762 = call i64 @emit_indent_line(i64 %r745, i64 %r761)
  ret i64 %r762
ret_else183:
  %r763 = load i64, ptr %slot.op, align 8
  %r764 = getelementptr inbounds [10 x i8], ptr @.str.46, i64 0, i64 0
  %r765 = ptrtoint ptr %r764 to i64
  %t767 = call i64 @nova_rt_eq(i64 %r763, i64 %r765)
  %r766 = and i64 %t767, 1
  %t768 = icmp ne i64 %t767, 0
  br i1 %t768, label %ret_then184, label %ret_else185
ret_then184:
  %r769 = load i64, ptr %slot.e, align 8
  %r770 = load i64, ptr %slot.dest, align 8
  %r771 = getelementptr inbounds [36 x i8], ptr @.str.111, i64 0, i64 0
  %r772 = ptrtoint ptr %r771 to i64
  %r773 = call i64 @nova_rt_add(i64 %r770, i64 %r772)
  %r774 = load i64, ptr %slot.args, align 8
  %r775 = call i64 @nova_rt_index_get(i64 %r774, i64 0)
  %r776 = call i64 @nova_rt_add(i64 %r773, i64 %r775)
  %r777 = getelementptr inbounds [7 x i8], ptr @.str.81, i64 0, i64 0
  %r778 = ptrtoint ptr %r777 to i64
  %r779 = call i64 @nova_rt_add(i64 %r776, i64 %r778)
  %r780 = load i64, ptr %slot.value, align 8
  %r781 = call i64 @nova_rt_add(i64 %r779, i64 %r780)
  %r782 = getelementptr inbounds [2 x i8], ptr @.str.78, i64 0, i64 0
  %r783 = ptrtoint ptr %r782 to i64
  %r784 = call i64 @nova_rt_add(i64 %r781, i64 %r783)
  %r785 = call i64 @emit_indent_line(i64 %r769, i64 %r784)
  ret i64 %r785
ret_else185:
  ret i64 0
}

define i64 @emit_ir_terminator(i64 %p0, i64 %p1) nounwind {
entry:
  %slot.e = alloca i64, align 8
  store i64 %p0, ptr %slot.e, align 8
  %slot.term = alloca i64, align 8
  store i64 %p1, ptr %slot.term, align 8
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
  %slot.cond_cmp = alloca i64, align 8
  store i64 0, ptr %slot.cond_cmp, align 8
  %r0 = load i64, ptr %slot.term, align 8
  %t1 = inttoptr i64 %r0 to ptr
  %t2 = getelementptr i64, ptr %t1, i64 0
  %r3 = load i64, ptr %t2, align 8
  store i64 %r3, ptr %slot.op, align 8
  %t4 = getelementptr i64, ptr %t1, i64 1
  %r5 = load i64, ptr %t4, align 8
  store i64 %r5, ptr %slot.dest, align 8
  %t6 = getelementptr i64, ptr %t1, i64 2
  %r7 = load i64, ptr %t6, align 8
  store i64 %r7, ptr %slot.typ, align 8
  %t8 = getelementptr i64, ptr %t1, i64 3
  %r9 = load i64, ptr %t8, align 8
  store i64 %r9, ptr %slot.args, align 8
  %t10 = getelementptr i64, ptr %t1, i64 4
  %r11 = load i64, ptr %t10, align 8
  store i64 %r11, ptr %slot.value, align 8
  %t12 = getelementptr i64, ptr %t1, i64 5
  %r13 = load i64, ptr %t12, align 8
  store i64 %r13, ptr %slot.num, align 8
  %t14 = getelementptr i64, ptr %t1, i64 6
  %r15 = load i64, ptr %t14, align 8
  store i64 %r15, ptr %slot.effect, align 8
  %r16 = load i64, ptr %slot.op, align 8
  %r17 = getelementptr inbounds [7 x i8], ptr @.str.52, i64 0, i64 0
  %r18 = ptrtoint ptr %r17 to i64
  %t20 = call i64 @nova_rt_eq(i64 %r16, i64 %r18)
  %r19 = and i64 %t20, 1
  %t21 = icmp ne i64 %t20, 0
  br i1 %t21, label %ret_then186, label %ret_else187
ret_then186:
  %r22 = load i64, ptr %slot.args, align 8
  %r23 = call i64 @nova_rt_len_any(i64 %r22)
  %t25 = icmp sgt i64 %r23, 0
  %r24 = zext i1 %t25 to i64
  %t26 = icmp ne i64 %r24, 0
  br i1 %t26, label %ret_then188, label %ret_else189
ret_then188:
  %r27 = load i64, ptr %slot.e, align 8
  %r28 = getelementptr inbounds [9 x i8], ptr @.str.112, i64 0, i64 0
  %r29 = ptrtoint ptr %r28 to i64
  %r30 = load i64, ptr %slot.args, align 8
  %r31 = call i64 @nova_rt_index_get(i64 %r30, i64 0)
  %r32 = call i64 @nova_rt_add(i64 %r29, i64 %r31)
  %r33 = call i64 @emit_indent_line(i64 %r27, i64 %r32)
  ret i64 %r33
ret_else189:
  %r34 = load i64, ptr %slot.e, align 8
  %r35 = getelementptr inbounds [10 x i8], ptr @.str.113, i64 0, i64 0
  %r36 = ptrtoint ptr %r35 to i64
  %r37 = call i64 @emit_indent_line(i64 %r34, i64 %r36)
  ret i64 %r37
ret_else187:
  %r38 = load i64, ptr %slot.op, align 8
  %r39 = getelementptr inbounds [5 x i8], ptr @.str.114, i64 0, i64 0
  %r40 = ptrtoint ptr %r39 to i64
  %t42 = call i64 @nova_rt_eq(i64 %r38, i64 %r40)
  %r41 = and i64 %t42, 1
  %t43 = icmp ne i64 %t42, 0
  br i1 %t43, label %ret_then190, label %ret_else191
ret_then190:
  %r44 = load i64, ptr %slot.e, align 8
  %r45 = getelementptr inbounds [11 x i8], ptr @.str.115, i64 0, i64 0
  %r46 = ptrtoint ptr %r45 to i64
  %r47 = load i64, ptr %slot.value, align 8
  %r48 = call i64 @nova_rt_add(i64 %r46, i64 %r47)
  %r49 = call i64 @emit_indent_line(i64 %r44, i64 %r48)
  ret i64 %r49
ret_else191:
  %r50 = load i64, ptr %slot.op, align 8
  %r51 = getelementptr inbounds [7 x i8], ptr @.str.116, i64 0, i64 0
  %r52 = ptrtoint ptr %r51 to i64
  %t54 = call i64 @nova_rt_eq(i64 %r50, i64 %r52)
  %r53 = and i64 %t54, 1
  %t55 = icmp ne i64 %t54, 0
  br i1 %t55, label %ret_then192, label %ret_else193
ret_then192:
  %r56 = load i64, ptr %slot.dest, align 8
  %r57 = getelementptr inbounds [4 x i8], ptr @.str.117, i64 0, i64 0
  %r58 = ptrtoint ptr %r57 to i64
  %r59 = call i64 @nova_rt_add(i64 %r56, i64 %r58)
  store i64 %r59, ptr %slot.cond_cmp, align 8
  %r60 = load i64, ptr %slot.e, align 8
  %r61 = load i64, ptr %slot.cond_cmp, align 8
  %r62 = getelementptr inbounds [16 x i8], ptr @.str.95, i64 0, i64 0
  %r63 = ptrtoint ptr %r62 to i64
  %r64 = call i64 @nova_rt_add(i64 %r61, i64 %r63)
  %r65 = load i64, ptr %slot.args, align 8
  %r66 = call i64 @nova_rt_index_get(i64 %r65, i64 0)
  %r67 = call i64 @nova_rt_add(i64 %r64, i64 %r66)
  %r68 = getelementptr inbounds [4 x i8], ptr @.str.72, i64 0, i64 0
  %r69 = ptrtoint ptr %r68 to i64
  %r70 = call i64 @nova_rt_add(i64 %r67, i64 %r69)
  %r71 = call i64 @emit_indent_line(i64 %r60, i64 %r70)
  %r72 = load i64, ptr %slot.e, align 8
  %r73 = getelementptr inbounds [7 x i8], ptr @.str.118, i64 0, i64 0
  %r74 = ptrtoint ptr %r73 to i64
  %r75 = load i64, ptr %slot.cond_cmp, align 8
  %r76 = call i64 @nova_rt_add(i64 %r74, i64 %r75)
  %r77 = getelementptr inbounds [10 x i8], ptr @.str.119, i64 0, i64 0
  %r78 = ptrtoint ptr %r77 to i64
  %r79 = call i64 @nova_rt_add(i64 %r76, i64 %r78)
  %r80 = load i64, ptr %slot.value, align 8
  %r81 = call i64 @nova_rt_add(i64 %r79, i64 %r80)
  %r82 = getelementptr inbounds [10 x i8], ptr @.str.119, i64 0, i64 0
  %r83 = ptrtoint ptr %r82 to i64
  %r84 = call i64 @nova_rt_add(i64 %r81, i64 %r83)
  %r85 = load i64, ptr %slot.args, align 8
  %r86 = call i64 @nova_rt_index_get(i64 %r85, i64 1)
  %r87 = call i64 @nova_rt_add(i64 %r84, i64 %r86)
  %r88 = call i64 @emit_indent_line(i64 %r72, i64 %r87)
  ret i64 %r88
ret_else193:
  ret i64 0
}

define i64 @emit_ir_function(i64 %p0, i64 %p1) nounwind {
entry:
  %slot.e = alloca i64, align 8
  store i64 %p0, ptr %slot.e, align 8
  %slot.func = alloca i64, align 8
  store i64 %p1, ptr %slot.func, align 8
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
  %slot.decl = alloca i64, align 8
  store i64 0, ptr %slot.decl, align 8
  %slot.i = alloca i64, align 8
  store i64 0, ptr %slot.i, align 8
  %slot.header = alloca i64, align 8
  store i64 0, ptr %slot.header, align 8
  %slot.block = alloca i64, align 8
  store i64 0, ptr %slot.block, align 8
  %slot.label = alloca i64, align 8
  store i64 0, ptr %slot.label, align 8
  %slot.insts = alloca i64, align 8
  store i64 0, ptr %slot.insts, align 8
  %slot.terminator = alloca i64, align 8
  store i64 0, ptr %slot.terminator, align 8
  %slot.pi = alloca i64, align 8
  store i64 0, ptr %slot.pi, align 8
  %slot.pname = alloca i64, align 8
  store i64 0, ptr %slot.pname, align 8
  %slot.ptype = alloca i64, align 8
  store i64 0, ptr %slot.ptype, align 8
  %slot.inst = alloca i64, align 8
  store i64 0, ptr %slot.inst, align 8
  %r0 = load i64, ptr %slot.func, align 8
  %t1 = inttoptr i64 %r0 to ptr
  %t2 = getelementptr i64, ptr %t1, i64 0
  %r3 = load i64, ptr %t2, align 8
  store i64 %r3, ptr %slot.name, align 8
  %t4 = getelementptr i64, ptr %t1, i64 1
  %r5 = load i64, ptr %t4, align 8
  store i64 %r5, ptr %slot.params, align 8
  %t6 = getelementptr i64, ptr %t1, i64 2
  %r7 = load i64, ptr %t6, align 8
  store i64 %r7, ptr %slot.ret_type, align 8
  %t8 = getelementptr i64, ptr %t1, i64 3
  %r9 = load i64, ptr %t8, align 8
  store i64 %r9, ptr %slot.blocks, align 8
  %t10 = getelementptr i64, ptr %t1, i64 4
  %r11 = load i64, ptr %t10, align 8
  store i64 %r11, ptr %slot.type_params, align 8
  %t12 = getelementptr i64, ptr %t1, i64 5
  %r13 = load i64, ptr %t12, align 8
  store i64 %r13, ptr %slot.is_extern, align 8
  %r14 = load i64, ptr %slot.is_extern, align 8
  %t16 = call i64 @nova_rt_eq(i64 %r14, i64 1)
  %r15 = and i64 %t16, 1
  %t17 = icmp ne i64 %t16, 0
  br i1 %t17, label %then194, label %else195
then194:
  %r18 = getelementptr inbounds [14 x i8], ptr @.str.120, i64 0, i64 0
  %r19 = ptrtoint ptr %r18 to i64
  %r20 = load i64, ptr %slot.name, align 8
  %r21 = call i64 @nova_rt_add(i64 %r19, i64 %r20)
  %r22 = getelementptr inbounds [2 x i8], ptr @.str.105, i64 0, i64 0
  %r23 = ptrtoint ptr %r22 to i64
  %r24 = call i64 @nova_rt_add(i64 %r21, i64 %r23)
  store i64 %r24, ptr %slot.decl, align 8
  store i64 0, ptr %slot.i, align 8
  br label %while_hdr197
while_hdr197:
  %r25 = load i64, ptr %slot.i, align 8
  %r26 = load i64, ptr %slot.params, align 8
  %r27 = call i64 @nova_rt_len_any(i64 %r26)
  %t29 = icmp slt i64 %r25, %r27
  %r28 = zext i1 %t29 to i64
  %t30 = icmp ne i64 %r28, 0
  br i1 %t30, label %while_body198, label %while_exit199
while_body198:
  %r31 = load i64, ptr %slot.i, align 8
  %t33 = icmp sgt i64 %r31, 0
  %r32 = zext i1 %t33 to i64
  %t34 = icmp ne i64 %r32, 0
  br i1 %t34, label %then200, label %else201
then200:
  %r35 = load i64, ptr %slot.decl, align 8
  %r36 = getelementptr inbounds [3 x i8], ptr @.str.79, i64 0, i64 0
  %r37 = ptrtoint ptr %r36 to i64
  %r38 = call i64 @nova_rt_add(i64 %r35, i64 %r37)
  store i64 %r38, ptr %slot.decl, align 8
  br label %merge202
else201:
  br label %merge202
merge202:
  %r39 = load i64, ptr %slot.decl, align 8
  %r40 = getelementptr inbounds [4 x i8], ptr @.str.121, i64 0, i64 0
  %r41 = ptrtoint ptr %r40 to i64
  %r42 = call i64 @nova_rt_add(i64 %r39, i64 %r41)
  store i64 %r42, ptr %slot.decl, align 8
  %r43 = load i64, ptr %slot.i, align 8
  %r44 = call i64 @nova_rt_add(i64 %r43, i64 1)
  store i64 %r44, ptr %slot.i, align 8
  br label %while_hdr197
while_exit199:
  %r45 = load i64, ptr %slot.decl, align 8
  %r46 = getelementptr inbounds [11 x i8], ptr @.str.122, i64 0, i64 0
  %r47 = ptrtoint ptr %r46 to i64
  %r48 = call i64 @nova_rt_add(i64 %r45, i64 %r47)
  store i64 %r48, ptr %slot.decl, align 8
  %r49 = load i64, ptr %slot.e, align 8
  %r50 = load i64, ptr %slot.decl, align 8
  %r51 = call i64 @emit_line(i64 %r49, i64 %r50)
  ret i64 0
  br label %merge196
else195:
  br label %merge196
merge196:
  %r52 = getelementptr inbounds [13 x i8], ptr @.str.123, i64 0, i64 0
  %r53 = ptrtoint ptr %r52 to i64
  %r54 = load i64, ptr %slot.name, align 8
  %r55 = call i64 @nova_rt_add(i64 %r53, i64 %r54)
  %r56 = getelementptr inbounds [2 x i8], ptr @.str.105, i64 0, i64 0
  %r57 = ptrtoint ptr %r56 to i64
  %r58 = call i64 @nova_rt_add(i64 %r55, i64 %r57)
  store i64 %r58, ptr %slot.header, align 8
  store i64 0, ptr %slot.i, align 8
  br label %while_hdr203
while_hdr203:
  %r59 = load i64, ptr %slot.i, align 8
  %r60 = load i64, ptr %slot.params, align 8
  %r61 = call i64 @nova_rt_len_any(i64 %r60)
  %t63 = icmp slt i64 %r59, %r61
  %r62 = zext i1 %t63 to i64
  %t64 = icmp ne i64 %r62, 0
  br i1 %t64, label %while_body204, label %while_exit205
while_body204:
  %r65 = load i64, ptr %slot.i, align 8
  %t67 = icmp sgt i64 %r65, 0
  %r66 = zext i1 %t67 to i64
  %t68 = icmp ne i64 %r66, 0
  br i1 %t68, label %then206, label %else207
then206:
  %r69 = load i64, ptr %slot.header, align 8
  %r70 = getelementptr inbounds [3 x i8], ptr @.str.79, i64 0, i64 0
  %r71 = ptrtoint ptr %r70 to i64
  %r72 = call i64 @nova_rt_add(i64 %r69, i64 %r71)
  store i64 %r72, ptr %slot.header, align 8
  br label %merge208
else207:
  br label %merge208
merge208:
  %r73 = load i64, ptr %slot.header, align 8
  %r74 = getelementptr inbounds [7 x i8], ptr @.str.124, i64 0, i64 0
  %r75 = ptrtoint ptr %r74 to i64
  %r76 = call i64 @nova_rt_add(i64 %r73, i64 %r75)
  %r77 = load i64, ptr %slot.i, align 8
  %r78 = call i64 @nova_rt_int_to_str(i64 %r77)
  %r79 = call i64 @nova_rt_add(i64 %r76, i64 %r78)
  store i64 %r79, ptr %slot.header, align 8
  %r80 = load i64, ptr %slot.i, align 8
  %r81 = call i64 @nova_rt_add(i64 %r80, i64 1)
  store i64 %r81, ptr %slot.i, align 8
  br label %while_hdr203
while_exit205:
  %r82 = load i64, ptr %slot.header, align 8
  %r83 = getelementptr inbounds [13 x i8], ptr @.str.125, i64 0, i64 0
  %r84 = ptrtoint ptr %r83 to i64
  %r85 = call i64 @nova_rt_add(i64 %r82, i64 %r84)
  store i64 %r85, ptr %slot.header, align 8
  %r86 = load i64, ptr %slot.e, align 8
  %r87 = load i64, ptr %slot.header, align 8
  %r88 = call i64 @emit_line(i64 %r86, i64 %r87)
  %r89 = load i64, ptr %slot.blocks, align 8
  %r90 = call i64 @nova_rt_len_any(i64 %r89)
  %slot.__for_idx_209 = alloca i64, align 8
  store i64 0, ptr %slot.__for_idx_209, align 8
  br label %for_hdr209
for_hdr209:
  %r91 = load i64, ptr %slot.__for_idx_209, align 8
  %t92 = icmp slt i64 %r91, %r90
  br i1 %t92, label %for_body210, label %for_exit211
for_body210:
  %r93 = call i64 @nova_rt_index_get(i64 %r89, i64 %r91)
  store i64 %r93, ptr %slot.block, align 8
  %r94 = load i64, ptr %slot.block, align 8
  %t95 = inttoptr i64 %r94 to ptr
  %t96 = getelementptr i64, ptr %t95, i64 0
  %r97 = load i64, ptr %t96, align 8
  store i64 %r97, ptr %slot.label, align 8
  %t98 = getelementptr i64, ptr %t95, i64 1
  %r99 = load i64, ptr %t98, align 8
  store i64 %r99, ptr %slot.insts, align 8
  %t100 = getelementptr i64, ptr %t95, i64 2
  %r101 = load i64, ptr %t100, align 8
  store i64 %r101, ptr %slot.terminator, align 8
  %r102 = load i64, ptr %slot.e, align 8
  %r103 = load i64, ptr %slot.label, align 8
  %r104 = getelementptr inbounds [2 x i8], ptr @.str.126, i64 0, i64 0
  %r105 = ptrtoint ptr %r104 to i64
  %r106 = call i64 @nova_rt_add(i64 %r103, i64 %r105)
  %r107 = call i64 @emit_line(i64 %r102, i64 %r106)
  %r108 = load i64, ptr %slot.label, align 8
  %r109 = getelementptr inbounds [6 x i8], ptr @.str.5, i64 0, i64 0
  %r110 = ptrtoint ptr %r109 to i64
  %t112 = call i64 @nova_rt_eq(i64 %r108, i64 %r110)
  %r111 = and i64 %t112, 1
  %t113 = icmp ne i64 %t112, 0
  br i1 %t113, label %then212, label %else213
then212:
  store i64 0, ptr %slot.pi, align 8
  br label %while_hdr215
while_hdr215:
  %r114 = load i64, ptr %slot.pi, align 8
  %r115 = load i64, ptr %slot.params, align 8
  %r116 = call i64 @nova_rt_len_any(i64 %r115)
  %t118 = icmp slt i64 %r114, %r116
  %r117 = zext i1 %t118 to i64
  %t119 = icmp ne i64 %r117, 0
  br i1 %t119, label %while_body216, label %while_exit217
while_body216:
  %r120 = load i64, ptr %slot.params, align 8
  %r121 = load i64, ptr %slot.pi, align 8
  %r122 = call i64 @nova_rt_index_get(i64 %r120, i64 %r121)
  %t123 = inttoptr i64 %r122 to ptr
  %t124 = getelementptr i64, ptr %t123, i64 0
  %r125 = load i64, ptr %t124, align 8
  store i64 %r125, ptr %slot.pname, align 8
  %t126 = getelementptr i64, ptr %t123, i64 1
  %r127 = load i64, ptr %t126, align 8
  store i64 %r127, ptr %slot.ptype, align 8
  %r128 = load i64, ptr %slot.e, align 8
  %r129 = getelementptr inbounds [7 x i8], ptr @.str.127, i64 0, i64 0
  %r130 = ptrtoint ptr %r129 to i64
  %r131 = load i64, ptr %slot.pname, align 8
  %r132 = call i64 @nova_rt_add(i64 %r130, i64 %r131)
  %r133 = getelementptr inbounds [23 x i8], ptr @.str.128, i64 0, i64 0
  %r134 = ptrtoint ptr %r133 to i64
  %r135 = call i64 @nova_rt_add(i64 %r132, i64 %r134)
  %r136 = call i64 @emit_indent_line(i64 %r128, i64 %r135)
  %r137 = load i64, ptr %slot.e, align 8
  %r138 = getelementptr inbounds [13 x i8], ptr @.str.129, i64 0, i64 0
  %r139 = ptrtoint ptr %r138 to i64
  %r140 = load i64, ptr %slot.pi, align 8
  %r141 = call i64 @nova_rt_int_to_str(i64 %r140)
  %r142 = call i64 @nova_rt_add(i64 %r139, i64 %r141)
  %r143 = getelementptr inbounds [13 x i8], ptr @.str.103, i64 0, i64 0
  %r144 = ptrtoint ptr %r143 to i64
  %r145 = call i64 @nova_rt_add(i64 %r142, i64 %r144)
  %r146 = load i64, ptr %slot.pname, align 8
  %r147 = call i64 @nova_rt_add(i64 %r145, i64 %r146)
  %r148 = getelementptr inbounds [10 x i8], ptr @.str.101, i64 0, i64 0
  %r149 = ptrtoint ptr %r148 to i64
  %r150 = call i64 @nova_rt_add(i64 %r147, i64 %r149)
  %r151 = call i64 @emit_indent_line(i64 %r137, i64 %r150)
  %r152 = load i64, ptr %slot.pi, align 8
  %r153 = call i64 @nova_rt_add(i64 %r152, i64 1)
  store i64 %r153, ptr %slot.pi, align 8
  br label %while_hdr215
while_exit217:
  br label %merge214
else213:
  br label %merge214
merge214:
  %r154 = load i64, ptr %slot.insts, align 8
  %r155 = call i64 @nova_rt_len_any(i64 %r154)
  %slot.__for_idx_218 = alloca i64, align 8
  store i64 0, ptr %slot.__for_idx_218, align 8
  br label %for_hdr218
for_hdr218:
  %r156 = load i64, ptr %slot.__for_idx_218, align 8
  %t157 = icmp slt i64 %r156, %r155
  br i1 %t157, label %for_body219, label %for_exit220
for_body219:
  %r158 = call i64 @nova_rt_index_get(i64 %r154, i64 %r156)
  store i64 %r158, ptr %slot.inst, align 8
  %r159 = load i64, ptr %slot.e, align 8
  %r160 = load i64, ptr %slot.inst, align 8
  %r161 = call i64 @emit_ir_inst(i64 %r159, i64 %r160)
  %r163 = load i64, ptr %slot.__for_idx_218, align 8
  %r162 = add i64 %r163, 1
  store i64 %r162, ptr %slot.__for_idx_218, align 8
  br label %for_hdr218
for_exit220:
  %r164 = load i64, ptr %slot.e, align 8
  %r165 = load i64, ptr %slot.terminator, align 8
  %r166 = call i64 @emit_ir_terminator(i64 %r164, i64 %r165)
  %r168 = load i64, ptr %slot.__for_idx_209, align 8
  %r167 = add i64 %r168, 1
  store i64 %r167, ptr %slot.__for_idx_209, align 8
  br label %for_hdr209
for_exit211:
  %r169 = load i64, ptr %slot.e, align 8
  %r170 = getelementptr inbounds [2 x i8], ptr @.str.130, i64 0, i64 0
  %r171 = ptrtoint ptr %r170 to i64
  %r172 = call i64 @emit_line(i64 %r169, i64 %r171)
  %r173 = load i64, ptr %slot.e, align 8
  %r174 = getelementptr inbounds [1 x i8], ptr @.str.1, i64 0, i64 0
  %r175 = ptrtoint ptr %r174 to i64
  %r176 = call i64 @emit_line(i64 %r173, i64 %r175)
  ret i64 %r176
}

define i64 @is_alpha(i64 %p0) nounwind {
entry:
  %slot.ch = alloca i64, align 8
  store i64 %p0, ptr %slot.ch, align 8
  %slot.c = alloca i64, align 8
  store i64 0, ptr %slot.c, align 8
  %r0 = load i64, ptr %slot.ch, align 8
  %r1 = call i64 @nova_rt_ord(i64 %r0)
  store i64 %r1, ptr %slot.c, align 8
  %r2 = load i64, ptr %slot.c, align 8
  %t4 = icmp sge i64 %r2, 65
  %r3 = zext i1 %t4 to i64
  %r5 = load i64, ptr %slot.c, align 8
  %t7 = icmp sle i64 %r5, 90
  %r6 = zext i1 %t7 to i64
  br label %and_entry221
and_entry221:
  %t9 = icmp ne i64 %r3, 0
  br i1 %t9, label %and_rhs222, label %and_end223
and_rhs222:
  %r10 = load i64, ptr %slot.c, align 8
  %t12 = icmp sle i64 %r10, 90
  %r11 = zext i1 %t12 to i64
  br label %and_done224
and_done224:
  br label %and_end223
and_end223:
  %r8 = phi i64 [0, %and_entry221], [%r11, %and_done224]
  %r13 = load i64, ptr %slot.c, align 8
  %t15 = icmp sge i64 %r13, 97
  %r14 = zext i1 %t15 to i64
  %r16 = load i64, ptr %slot.c, align 8
  %t18 = icmp sle i64 %r16, 122
  %r17 = zext i1 %t18 to i64
  br label %and_entry225
and_entry225:
  %t20 = icmp ne i64 %r14, 0
  br i1 %t20, label %and_rhs226, label %and_end227
and_rhs226:
  %r21 = load i64, ptr %slot.c, align 8
  %t23 = icmp sle i64 %r21, 122
  %r22 = zext i1 %t23 to i64
  br label %and_done228
and_done228:
  br label %and_end227
and_end227:
  %r19 = phi i64 [0, %and_entry225], [%r22, %and_done228]
  br label %or_entry229
or_entry229:
  %t25 = icmp ne i64 %r8, 0
  br i1 %t25, label %or_end231, label %or_rhs230
or_rhs230:
  %r26 = load i64, ptr %slot.c, align 8
  %t28 = icmp sge i64 %r26, 97
  %r27 = zext i1 %t28 to i64
  %r29 = load i64, ptr %slot.c, align 8
  %t31 = icmp sle i64 %r29, 122
  %r30 = zext i1 %t31 to i64
  br label %and_entry232
and_entry232:
  %t33 = icmp ne i64 %r27, 0
  br i1 %t33, label %and_rhs233, label %and_end234
and_rhs233:
  %r34 = load i64, ptr %slot.c, align 8
  %t36 = icmp sle i64 %r34, 122
  %r35 = zext i1 %t36 to i64
  br label %and_done235
and_done235:
  br label %and_end234
and_end234:
  %r32 = phi i64 [0, %and_entry232], [%r35, %and_done235]
  br label %or_done236
or_done236:
  br label %or_end231
or_end231:
  %r24 = phi i64 [%r8, %or_entry229], [%r32, %or_done236]
  %r37 = load i64, ptr %slot.ch, align 8
  %r38 = getelementptr inbounds [2 x i8], ptr @.str.131, i64 0, i64 0
  %r39 = ptrtoint ptr %r38 to i64
  %t41 = call i64 @nova_rt_eq(i64 %r37, i64 %r39)
  %r40 = and i64 %t41, 1
  br label %or_entry237
or_entry237:
  %t43 = icmp ne i64 %r24, 0
  br i1 %t43, label %or_end239, label %or_rhs238
or_rhs238:
  %r44 = load i64, ptr %slot.ch, align 8
  %r45 = getelementptr inbounds [2 x i8], ptr @.str.131, i64 0, i64 0
  %r46 = ptrtoint ptr %r45 to i64
  %t48 = call i64 @nova_rt_eq(i64 %r44, i64 %r46)
  %r47 = and i64 %t48, 1
  br label %or_done240
or_done240:
  br label %or_end239
or_end239:
  %r42 = phi i64 [%r24, %or_entry237], [%t48, %or_done240]
  ret i64 %r42
}

define i64 @is_digit(i64 %p0) nounwind {
entry:
  %slot.ch = alloca i64, align 8
  store i64 %p0, ptr %slot.ch, align 8
  %slot.c = alloca i64, align 8
  store i64 0, ptr %slot.c, align 8
  %r0 = load i64, ptr %slot.ch, align 8
  %r1 = call i64 @nova_rt_ord(i64 %r0)
  store i64 %r1, ptr %slot.c, align 8
  %r2 = load i64, ptr %slot.c, align 8
  %t4 = icmp sge i64 %r2, 48
  %r3 = zext i1 %t4 to i64
  %r5 = load i64, ptr %slot.c, align 8
  %t7 = icmp sle i64 %r5, 57
  %r6 = zext i1 %t7 to i64
  br label %and_entry241
and_entry241:
  %t9 = icmp ne i64 %r3, 0
  br i1 %t9, label %and_rhs242, label %and_end243
and_rhs242:
  %r10 = load i64, ptr %slot.c, align 8
  %t12 = icmp sle i64 %r10, 57
  %r11 = zext i1 %t12 to i64
  br label %and_done244
and_done244:
  br label %and_end243
and_end243:
  %r8 = phi i64 [0, %and_entry241], [%r11, %and_done244]
  ret i64 %r8
}

define i64 @is_alnum(i64 %p0) nounwind {
entry:
  %slot.ch = alloca i64, align 8
  store i64 %p0, ptr %slot.ch, align 8
  %r0 = load i64, ptr %slot.ch, align 8
  %r1 = call i64 @is_alpha(i64 %r0)
  %r2 = load i64, ptr %slot.ch, align 8
  %r3 = call i64 @is_digit(i64 %r2)
  br label %or_entry245
or_entry245:
  %t5 = icmp ne i64 %r1, 0
  br i1 %t5, label %or_end247, label %or_rhs246
or_rhs246:
  %r6 = load i64, ptr %slot.ch, align 8
  %r7 = call i64 @is_digit(i64 %r6)
  br label %or_done248
or_done248:
  br label %or_end247
or_end247:
  %r4 = phi i64 [%r1, %or_entry245], [%r7, %or_done248]
  ret i64 %r4
}

define i64 @tokenize_mini(i64 %p0) nounwind {
entry:
  %slot.source = alloca i64, align 8
  store i64 %p0, ptr %slot.source, align 8
  %slot.tokens = alloca i64, align 8
  store i64 0, ptr %slot.tokens, align 8
  %slot.i = alloca i64, align 8
  store i64 0, ptr %slot.i, align 8
  %slot.line = alloca i64, align 8
  store i64 0, ptr %slot.line, align 8
  %slot.ch = alloca i64, align 8
  store i64 0, ptr %slot.ch, align 8
  %slot.start = alloca i64, align 8
  store i64 0, ptr %slot.start, align 8
  %slot.s = alloca i64, align 8
  store i64 0, ptr %slot.s, align 8
  %slot.esc = alloca i64, align 8
  store i64 0, ptr %slot.esc, align 8
  %slot.word = alloca i64, align 8
  store i64 0, ptr %slot.word, align 8
  %r0 = call i64 @nova_rt_list_create()
  store i64 %r0, ptr %slot.tokens, align 8
  store i64 0, ptr %slot.i, align 8
  store i64 1, ptr %slot.line, align 8
  br label %while_hdr249
while_hdr249:
  %r1 = load i64, ptr %slot.i, align 8
  %r2 = load i64, ptr %slot.source, align 8
  %r3 = call i64 @nova_rt_len_any(i64 %r2)
  %t5 = icmp slt i64 %r1, %r3
  %r4 = zext i1 %t5 to i64
  %t6 = icmp ne i64 %r4, 0
  br i1 %t6, label %while_body250, label %while_exit251
while_body250:
  %r7 = load i64, ptr %slot.source, align 8
  %r8 = load i64, ptr %slot.i, align 8
  %r9 = call i64 @nova_rt_index_get(i64 %r7, i64 %r8)
  store i64 %r9, ptr %slot.ch, align 8
  %r10 = load i64, ptr %slot.ch, align 8
  %r11 = getelementptr inbounds [2 x i8], ptr @.str.132, i64 0, i64 0
  %r12 = ptrtoint ptr %r11 to i64
  %t14 = call i64 @nova_rt_eq(i64 %r10, i64 %r12)
  %r13 = and i64 %t14, 1
  %r15 = load i64, ptr %slot.ch, align 8
  %r16 = getelementptr inbounds [2 x i8], ptr @.str.60, i64 0, i64 0
  %r17 = ptrtoint ptr %r16 to i64
  %t19 = call i64 @nova_rt_eq(i64 %r15, i64 %r17)
  %r18 = and i64 %t19, 1
  br label %or_entry252
or_entry252:
  %t21 = icmp ne i64 %t14, 0
  br i1 %t21, label %or_end254, label %or_rhs253
or_rhs253:
  %r22 = load i64, ptr %slot.ch, align 8
  %r23 = getelementptr inbounds [2 x i8], ptr @.str.60, i64 0, i64 0
  %r24 = ptrtoint ptr %r23 to i64
  %t26 = call i64 @nova_rt_eq(i64 %r22, i64 %r24)
  %r25 = and i64 %t26, 1
  br label %or_done255
or_done255:
  br label %or_end254
or_end254:
  %r20 = phi i64 [%t14, %or_entry252], [%t26, %or_done255]
  %r27 = load i64, ptr %slot.ch, align 8
  %r28 = getelementptr inbounds [2 x i8], ptr @.str.58, i64 0, i64 0
  %r29 = ptrtoint ptr %r28 to i64
  %t31 = call i64 @nova_rt_eq(i64 %r27, i64 %r29)
  %r30 = and i64 %t31, 1
  br label %or_entry256
or_entry256:
  %t33 = icmp ne i64 %r20, 0
  br i1 %t33, label %or_end258, label %or_rhs257
or_rhs257:
  %r34 = load i64, ptr %slot.ch, align 8
  %r35 = getelementptr inbounds [2 x i8], ptr @.str.58, i64 0, i64 0
  %r36 = ptrtoint ptr %r35 to i64
  %t38 = call i64 @nova_rt_eq(i64 %r34, i64 %r36)
  %r37 = and i64 %t38, 1
  br label %or_done259
or_done259:
  br label %or_end258
or_end258:
  %r32 = phi i64 [%r20, %or_entry256], [%t38, %or_done259]
  %t39 = icmp ne i64 %r32, 0
  br i1 %t39, label %then260, label %else261
then260:
  %r40 = load i64, ptr %slot.i, align 8
  %r41 = call i64 @nova_rt_add(i64 %r40, i64 1)
  store i64 %r41, ptr %slot.i, align 8
  br label %merge262
else261:
  %r42 = load i64, ptr %slot.ch, align 8
  %r43 = getelementptr inbounds [2 x i8], ptr @.str.56, i64 0, i64 0
  %r44 = ptrtoint ptr %r43 to i64
  %t46 = call i64 @nova_rt_eq(i64 %r42, i64 %r44)
  %r45 = and i64 %t46, 1
  %t47 = icmp ne i64 %t46, 0
  br i1 %t47, label %then263, label %else264
then263:
  %r48 = load i64, ptr %slot.tokens, align 8
  %r49 = call ptr @nova_rt_struct_alloc(i64 32)
  %r50 = getelementptr inbounds [8 x i8], ptr @.str.133, i64 0, i64 0
  %r51 = ptrtoint ptr %r50 to i64
  %t52 = getelementptr i64, ptr %r49, i64 0
  store i64 %r51, ptr %t52, align 8
  %r53 = getelementptr inbounds [2 x i8], ptr @.str.56, i64 0, i64 0
  %r54 = ptrtoint ptr %r53 to i64
  %t55 = getelementptr i64, ptr %r49, i64 1
  store i64 %r54, ptr %t55, align 8
  %r56 = load i64, ptr %slot.line, align 8
  %t57 = getelementptr i64, ptr %r49, i64 2
  store i64 %r56, ptr %t57, align 8
  %t58 = getelementptr i64, ptr %r49, i64 3
  store i64 0, ptr %t58, align 8
  %r59 = ptrtoint ptr %r49 to i64
  %r60 = call i64 @nova_rt_list_append(i64 %r48, i64 %r59)
  %r61 = load i64, ptr %slot.line, align 8
  %r62 = call i64 @nova_rt_add(i64 %r61, i64 1)
  store i64 %r62, ptr %slot.line, align 8
  %r63 = load i64, ptr %slot.i, align 8
  %r64 = call i64 @nova_rt_add(i64 %r63, i64 1)
  store i64 %r64, ptr %slot.i, align 8
  br label %merge265
else264:
  %r65 = load i64, ptr %slot.ch, align 8
  %r66 = getelementptr inbounds [2 x i8], ptr @.str.134, i64 0, i64 0
  %r67 = ptrtoint ptr %r66 to i64
  %t69 = call i64 @nova_rt_eq(i64 %r65, i64 %r67)
  %r68 = and i64 %t69, 1
  %t70 = icmp ne i64 %t69, 0
  br i1 %t70, label %then266, label %else267
then266:
  br label %while_hdr269
while_hdr269:
  %r71 = load i64, ptr %slot.i, align 8
  %r72 = load i64, ptr %slot.source, align 8
  %r73 = call i64 @nova_rt_len_any(i64 %r72)
  %t75 = icmp slt i64 %r71, %r73
  %r74 = zext i1 %t75 to i64
  %r76 = load i64, ptr %slot.source, align 8
  %r77 = load i64, ptr %slot.i, align 8
  %r78 = call i64 @nova_rt_index_get(i64 %r76, i64 %r77)
  %r79 = getelementptr inbounds [2 x i8], ptr @.str.56, i64 0, i64 0
  %r80 = ptrtoint ptr %r79 to i64
  %t82 = call i64 @nova_rt_neq(i64 %r78, i64 %r80)
  br label %and_entry272
and_entry272:
  %t84 = icmp ne i64 %r74, 0
  br i1 %t84, label %and_rhs273, label %and_end274
and_rhs273:
  %r85 = load i64, ptr %slot.source, align 8
  %r86 = load i64, ptr %slot.i, align 8
  %r87 = call i64 @nova_rt_index_get(i64 %r85, i64 %r86)
  %r88 = getelementptr inbounds [2 x i8], ptr @.str.56, i64 0, i64 0
  %r89 = ptrtoint ptr %r88 to i64
  %t91 = call i64 @nova_rt_neq(i64 %r87, i64 %r89)
  br label %and_done275
and_done275:
  br label %and_end274
and_end274:
  %r83 = phi i64 [0, %and_entry272], [%t91, %and_done275]
  %t92 = icmp ne i64 %r83, 0
  br i1 %t92, label %while_body270, label %while_exit271
while_body270:
  %r93 = load i64, ptr %slot.i, align 8
  %r94 = call i64 @nova_rt_add(i64 %r93, i64 1)
  store i64 %r94, ptr %slot.i, align 8
  br label %while_hdr269
while_exit271:
  br label %merge268
else267:
  %r95 = load i64, ptr %slot.ch, align 8
  %r96 = call i64 @is_digit(i64 %r95)
  %t97 = icmp ne i64 %r96, 0
  br i1 %t97, label %then276, label %else277
then276:
  %r98 = load i64, ptr %slot.i, align 8
  store i64 %r98, ptr %slot.start, align 8
  br label %while_hdr279
while_hdr279:
  %r99 = load i64, ptr %slot.i, align 8
  %r100 = load i64, ptr %slot.source, align 8
  %r101 = call i64 @nova_rt_len_any(i64 %r100)
  %t103 = icmp slt i64 %r99, %r101
  %r102 = zext i1 %t103 to i64
  %r104 = load i64, ptr %slot.source, align 8
  %r105 = load i64, ptr %slot.i, align 8
  %r106 = call i64 @nova_rt_index_get(i64 %r104, i64 %r105)
  %r107 = call i64 @is_digit(i64 %r106)
  br label %and_entry282
and_entry282:
  %t109 = icmp ne i64 %r102, 0
  br i1 %t109, label %and_rhs283, label %and_end284
and_rhs283:
  %r110 = load i64, ptr %slot.source, align 8
  %r111 = load i64, ptr %slot.i, align 8
  %r112 = call i64 @nova_rt_index_get(i64 %r110, i64 %r111)
  %r113 = call i64 @is_digit(i64 %r112)
  br label %and_done285
and_done285:
  br label %and_end284
and_end284:
  %r108 = phi i64 [0, %and_entry282], [%r113, %and_done285]
  %t114 = icmp ne i64 %r108, 0
  br i1 %t114, label %while_body280, label %while_exit281
while_body280:
  %r115 = load i64, ptr %slot.i, align 8
  %r116 = call i64 @nova_rt_add(i64 %r115, i64 1)
  store i64 %r116, ptr %slot.i, align 8
  br label %while_hdr279
while_exit281:
  %r117 = load i64, ptr %slot.tokens, align 8
  %r118 = call ptr @nova_rt_struct_alloc(i64 32)
  %r119 = getelementptr inbounds [4 x i8], ptr @.str.135, i64 0, i64 0
  %r120 = ptrtoint ptr %r119 to i64
  %t121 = getelementptr i64, ptr %r118, i64 0
  store i64 %r120, ptr %t121, align 8
  %r122 = load i64, ptr %slot.source, align 8
  %r123 = load i64, ptr %slot.start, align 8
  %r124 = load i64, ptr %slot.i, align 8
  %r125 = call i64 @nova_rt_slice(i64 %r122, i64 %r123, i64 %r124)
  %t126 = getelementptr i64, ptr %r118, i64 1
  store i64 %r125, ptr %t126, align 8
  %r127 = load i64, ptr %slot.line, align 8
  %t128 = getelementptr i64, ptr %r118, i64 2
  store i64 %r127, ptr %t128, align 8
  %r129 = load i64, ptr %slot.start, align 8
  %t130 = getelementptr i64, ptr %r118, i64 3
  store i64 %r129, ptr %t130, align 8
  %r131 = ptrtoint ptr %r118 to i64
  %r132 = call i64 @nova_rt_list_append(i64 %r117, i64 %r131)
  br label %merge278
else277:
  %r133 = load i64, ptr %slot.ch, align 8
  %r134 = getelementptr inbounds [2 x i8], ptr @.str.65, i64 0, i64 0
  %r135 = ptrtoint ptr %r134 to i64
  %t137 = call i64 @nova_rt_eq(i64 %r133, i64 %r135)
  %r136 = and i64 %t137, 1
  %t138 = icmp ne i64 %t137, 0
  br i1 %t138, label %then286, label %else287
then286:
  %r139 = load i64, ptr %slot.i, align 8
  %r140 = call i64 @nova_rt_add(i64 %r139, i64 1)
  store i64 %r140, ptr %slot.i, align 8
  %r141 = getelementptr inbounds [1 x i8], ptr @.str.1, i64 0, i64 0
  %r142 = ptrtoint ptr %r141 to i64
  store i64 %r142, ptr %slot.s, align 8
  br label %while_hdr289
while_hdr289:
  %r143 = load i64, ptr %slot.i, align 8
  %r144 = load i64, ptr %slot.source, align 8
  %r145 = call i64 @nova_rt_len_any(i64 %r144)
  %t147 = icmp slt i64 %r143, %r145
  %r146 = zext i1 %t147 to i64
  %r148 = load i64, ptr %slot.source, align 8
  %r149 = load i64, ptr %slot.i, align 8
  %r150 = call i64 @nova_rt_index_get(i64 %r148, i64 %r149)
  %r151 = getelementptr inbounds [2 x i8], ptr @.str.65, i64 0, i64 0
  %r152 = ptrtoint ptr %r151 to i64
  %t154 = call i64 @nova_rt_neq(i64 %r150, i64 %r152)
  br label %and_entry292
and_entry292:
  %t156 = icmp ne i64 %r146, 0
  br i1 %t156, label %and_rhs293, label %and_end294
and_rhs293:
  %r157 = load i64, ptr %slot.source, align 8
  %r158 = load i64, ptr %slot.i, align 8
  %r159 = call i64 @nova_rt_index_get(i64 %r157, i64 %r158)
  %r160 = getelementptr inbounds [2 x i8], ptr @.str.65, i64 0, i64 0
  %r161 = ptrtoint ptr %r160 to i64
  %t163 = call i64 @nova_rt_neq(i64 %r159, i64 %r161)
  br label %and_done295
and_done295:
  br label %and_end294
and_end294:
  %r155 = phi i64 [0, %and_entry292], [%t163, %and_done295]
  %t164 = icmp ne i64 %r155, 0
  br i1 %t164, label %while_body290, label %while_exit291
while_body290:
  %r165 = load i64, ptr %slot.source, align 8
  %r166 = load i64, ptr %slot.i, align 8
  %r167 = call i64 @nova_rt_index_get(i64 %r165, i64 %r166)
  %r168 = getelementptr inbounds [2 x i8], ptr @.str.63, i64 0, i64 0
  %r169 = ptrtoint ptr %r168 to i64
  %t171 = call i64 @nova_rt_eq(i64 %r167, i64 %r169)
  %r170 = and i64 %t171, 1
  %t172 = icmp ne i64 %t171, 0
  br i1 %t172, label %then296, label %else297
then296:
  %r173 = load i64, ptr %slot.i, align 8
  %r174 = call i64 @nova_rt_add(i64 %r173, i64 1)
  store i64 %r174, ptr %slot.i, align 8
  %r175 = load i64, ptr %slot.i, align 8
  %r176 = load i64, ptr %slot.source, align 8
  %r177 = call i64 @nova_rt_len_any(i64 %r176)
  %t179 = icmp slt i64 %r175, %r177
  %r178 = zext i1 %t179 to i64
  %t180 = icmp ne i64 %r178, 0
  br i1 %t180, label %then299, label %else300
then299:
  %r181 = load i64, ptr %slot.source, align 8
  %r182 = load i64, ptr %slot.i, align 8
  %r183 = call i64 @nova_rt_index_get(i64 %r181, i64 %r182)
  store i64 %r183, ptr %slot.esc, align 8
  %r184 = load i64, ptr %slot.esc, align 8
  %r185 = getelementptr inbounds [2 x i8], ptr @.str.136, i64 0, i64 0
  %r186 = ptrtoint ptr %r185 to i64
  %t188 = call i64 @nova_rt_eq(i64 %r184, i64 %r186)
  %r187 = and i64 %t188, 1
  %t189 = icmp ne i64 %t188, 0
  br i1 %t189, label %then302, label %else303
then302:
  %r190 = load i64, ptr %slot.s, align 8
  %r191 = getelementptr inbounds [2 x i8], ptr @.str.56, i64 0, i64 0
  %r192 = ptrtoint ptr %r191 to i64
  %r193 = call i64 @nova_rt_add(i64 %r190, i64 %r192)
  store i64 %r193, ptr %slot.s, align 8
  br label %merge304
else303:
  %r194 = load i64, ptr %slot.esc, align 8
  %r195 = getelementptr inbounds [2 x i8], ptr @.str.137, i64 0, i64 0
  %r196 = ptrtoint ptr %r195 to i64
  %t198 = call i64 @nova_rt_eq(i64 %r194, i64 %r196)
  %r197 = and i64 %t198, 1
  %t199 = icmp ne i64 %t198, 0
  br i1 %t199, label %then305, label %else306
then305:
  %r200 = load i64, ptr %slot.s, align 8
  %r201 = getelementptr inbounds [2 x i8], ptr @.str.60, i64 0, i64 0
  %r202 = ptrtoint ptr %r201 to i64
  %r203 = call i64 @nova_rt_add(i64 %r200, i64 %r202)
  store i64 %r203, ptr %slot.s, align 8
  br label %merge307
else306:
  %r204 = load i64, ptr %slot.esc, align 8
  %r205 = getelementptr inbounds [2 x i8], ptr @.str.63, i64 0, i64 0
  %r206 = ptrtoint ptr %r205 to i64
  %t208 = call i64 @nova_rt_eq(i64 %r204, i64 %r206)
  %r207 = and i64 %t208, 1
  %t209 = icmp ne i64 %t208, 0
  br i1 %t209, label %then308, label %else309
then308:
  %r210 = load i64, ptr %slot.s, align 8
  %r211 = getelementptr inbounds [2 x i8], ptr @.str.63, i64 0, i64 0
  %r212 = ptrtoint ptr %r211 to i64
  %r213 = call i64 @nova_rt_add(i64 %r210, i64 %r212)
  store i64 %r213, ptr %slot.s, align 8
  br label %merge310
else309:
  %r214 = load i64, ptr %slot.esc, align 8
  %r215 = getelementptr inbounds [2 x i8], ptr @.str.65, i64 0, i64 0
  %r216 = ptrtoint ptr %r215 to i64
  %t218 = call i64 @nova_rt_eq(i64 %r214, i64 %r216)
  %r217 = and i64 %t218, 1
  %t219 = icmp ne i64 %t218, 0
  br i1 %t219, label %then311, label %else312
then311:
  %r220 = load i64, ptr %slot.s, align 8
  %r221 = getelementptr inbounds [2 x i8], ptr @.str.65, i64 0, i64 0
  %r222 = ptrtoint ptr %r221 to i64
  %r223 = call i64 @nova_rt_add(i64 %r220, i64 %r222)
  store i64 %r223, ptr %slot.s, align 8
  br label %merge313
else312:
  %r224 = load i64, ptr %slot.s, align 8
  %r225 = load i64, ptr %slot.esc, align 8
  %r226 = call i64 @nova_rt_add(i64 %r224, i64 %r225)
  store i64 %r226, ptr %slot.s, align 8
  br label %merge313
merge313:
  br label %merge310
merge310:
  br label %merge307
merge307:
  br label %merge304
merge304:
  br label %merge301
else300:
  br label %merge301
merge301:
  br label %merge298
else297:
  %r227 = load i64, ptr %slot.s, align 8
  %r228 = load i64, ptr %slot.source, align 8
  %r229 = load i64, ptr %slot.i, align 8
  %r230 = call i64 @nova_rt_index_get(i64 %r228, i64 %r229)
  %r231 = call i64 @nova_rt_add(i64 %r227, i64 %r230)
  store i64 %r231, ptr %slot.s, align 8
  br label %merge298
merge298:
  %r232 = load i64, ptr %slot.i, align 8
  %r233 = call i64 @nova_rt_add(i64 %r232, i64 1)
  store i64 %r233, ptr %slot.i, align 8
  br label %while_hdr289
while_exit291:
  %r234 = load i64, ptr %slot.i, align 8
  %r235 = call i64 @nova_rt_add(i64 %r234, i64 1)
  store i64 %r235, ptr %slot.i, align 8
  %r236 = load i64, ptr %slot.tokens, align 8
  %r237 = call ptr @nova_rt_struct_alloc(i64 32)
  %r238 = getelementptr inbounds [4 x i8], ptr @.str.138, i64 0, i64 0
  %r239 = ptrtoint ptr %r238 to i64
  %t240 = getelementptr i64, ptr %r237, i64 0
  store i64 %r239, ptr %t240, align 8
  %r241 = load i64, ptr %slot.s, align 8
  %t242 = getelementptr i64, ptr %r237, i64 1
  store i64 %r241, ptr %t242, align 8
  %r243 = load i64, ptr %slot.line, align 8
  %t244 = getelementptr i64, ptr %r237, i64 2
  store i64 %r243, ptr %t244, align 8
  %t245 = getelementptr i64, ptr %r237, i64 3
  store i64 0, ptr %t245, align 8
  %r246 = ptrtoint ptr %r237 to i64
  %r247 = call i64 @nova_rt_list_append(i64 %r236, i64 %r246)
  br label %merge288
else287:
  %r248 = load i64, ptr %slot.ch, align 8
  %r249 = call i64 @is_alpha(i64 %r248)
  %t250 = icmp ne i64 %r249, 0
  br i1 %t250, label %then314, label %else315
then314:
  %r251 = load i64, ptr %slot.i, align 8
  store i64 %r251, ptr %slot.start, align 8
  br label %while_hdr317
while_hdr317:
  %r252 = load i64, ptr %slot.i, align 8
  %r253 = load i64, ptr %slot.source, align 8
  %r254 = call i64 @nova_rt_len_any(i64 %r253)
  %t256 = icmp slt i64 %r252, %r254
  %r255 = zext i1 %t256 to i64
  %r257 = load i64, ptr %slot.source, align 8
  %r258 = load i64, ptr %slot.i, align 8
  %r259 = call i64 @nova_rt_index_get(i64 %r257, i64 %r258)
  %r260 = call i64 @is_alnum(i64 %r259)
  br label %and_entry320
and_entry320:
  %t262 = icmp ne i64 %r255, 0
  br i1 %t262, label %and_rhs321, label %and_end322
and_rhs321:
  %r263 = load i64, ptr %slot.source, align 8
  %r264 = load i64, ptr %slot.i, align 8
  %r265 = call i64 @nova_rt_index_get(i64 %r263, i64 %r264)
  %r266 = call i64 @is_alnum(i64 %r265)
  br label %and_done323
and_done323:
  br label %and_end322
and_end322:
  %r261 = phi i64 [0, %and_entry320], [%r266, %and_done323]
  %t267 = icmp ne i64 %r261, 0
  br i1 %t267, label %while_body318, label %while_exit319
while_body318:
  %r268 = load i64, ptr %slot.i, align 8
  %r269 = call i64 @nova_rt_add(i64 %r268, i64 1)
  store i64 %r269, ptr %slot.i, align 8
  br label %while_hdr317
while_exit319:
  %r270 = load i64, ptr %slot.source, align 8
  %r271 = load i64, ptr %slot.start, align 8
  %r272 = load i64, ptr %slot.i, align 8
  %r273 = call i64 @nova_rt_slice(i64 %r270, i64 %r271, i64 %r272)
  store i64 %r273, ptr %slot.word, align 8
  %r274 = load i64, ptr %slot.word, align 8
  %r275 = getelementptr inbounds [3 x i8], ptr @.str.139, i64 0, i64 0
  %r276 = ptrtoint ptr %r275 to i64
  %t278 = call i64 @nova_rt_eq(i64 %r274, i64 %r276)
  %r277 = and i64 %t278, 1
  %r279 = load i64, ptr %slot.word, align 8
  %r280 = getelementptr inbounds [4 x i8], ptr @.str.49, i64 0, i64 0
  %r281 = ptrtoint ptr %r280 to i64
  %t283 = call i64 @nova_rt_eq(i64 %r279, i64 %r281)
  %r282 = and i64 %t283, 1
  br label %or_entry324
or_entry324:
  %t285 = icmp ne i64 %t278, 0
  br i1 %t285, label %or_end326, label %or_rhs325
or_rhs325:
  %r286 = load i64, ptr %slot.word, align 8
  %r287 = getelementptr inbounds [4 x i8], ptr @.str.49, i64 0, i64 0
  %r288 = ptrtoint ptr %r287 to i64
  %t290 = call i64 @nova_rt_eq(i64 %r286, i64 %r288)
  %r289 = and i64 %t290, 1
  br label %or_done327
or_done327:
  br label %or_end326
or_end326:
  %r284 = phi i64 [%t278, %or_entry324], [%t290, %or_done327]
  %r291 = load i64, ptr %slot.word, align 8
  %r292 = getelementptr inbounds [7 x i8], ptr @.str.52, i64 0, i64 0
  %r293 = ptrtoint ptr %r292 to i64
  %t295 = call i64 @nova_rt_eq(i64 %r291, i64 %r293)
  %r294 = and i64 %t295, 1
  br label %or_entry328
or_entry328:
  %t297 = icmp ne i64 %r284, 0
  br i1 %t297, label %or_end330, label %or_rhs329
or_rhs329:
  %r298 = load i64, ptr %slot.word, align 8
  %r299 = getelementptr inbounds [7 x i8], ptr @.str.52, i64 0, i64 0
  %r300 = ptrtoint ptr %r299 to i64
  %t302 = call i64 @nova_rt_eq(i64 %r298, i64 %r300)
  %r301 = and i64 %t302, 1
  br label %or_done331
or_done331:
  br label %or_end330
or_end330:
  %r296 = phi i64 [%r284, %or_entry328], [%t302, %or_done331]
  %r303 = load i64, ptr %slot.word, align 8
  %r304 = getelementptr inbounds [3 x i8], ptr @.str.140, i64 0, i64 0
  %r305 = ptrtoint ptr %r304 to i64
  %t307 = call i64 @nova_rt_eq(i64 %r303, i64 %r305)
  %r306 = and i64 %t307, 1
  br label %or_entry332
or_entry332:
  %t309 = icmp ne i64 %r296, 0
  br i1 %t309, label %or_end334, label %or_rhs333
or_rhs333:
  %r310 = load i64, ptr %slot.word, align 8
  %r311 = getelementptr inbounds [3 x i8], ptr @.str.140, i64 0, i64 0
  %r312 = ptrtoint ptr %r311 to i64
  %t314 = call i64 @nova_rt_eq(i64 %r310, i64 %r312)
  %r313 = and i64 %t314, 1
  br label %or_done335
or_done335:
  br label %or_end334
or_end334:
  %r308 = phi i64 [%r296, %or_entry332], [%t314, %or_done335]
  %r315 = load i64, ptr %slot.word, align 8
  %r316 = getelementptr inbounds [5 x i8], ptr @.str.141, i64 0, i64 0
  %r317 = ptrtoint ptr %r316 to i64
  %t319 = call i64 @nova_rt_eq(i64 %r315, i64 %r317)
  %r318 = and i64 %t319, 1
  br label %or_entry336
or_entry336:
  %t321 = icmp ne i64 %r308, 0
  br i1 %t321, label %or_end338, label %or_rhs337
or_rhs337:
  %r322 = load i64, ptr %slot.word, align 8
  %r323 = getelementptr inbounds [5 x i8], ptr @.str.141, i64 0, i64 0
  %r324 = ptrtoint ptr %r323 to i64
  %t326 = call i64 @nova_rt_eq(i64 %r322, i64 %r324)
  %r325 = and i64 %t326, 1
  br label %or_done339
or_done339:
  br label %or_end338
or_end338:
  %r320 = phi i64 [%r308, %or_entry336], [%t326, %or_done339]
  %r327 = load i64, ptr %slot.word, align 8
  %r328 = getelementptr inbounds [6 x i8], ptr @.str.142, i64 0, i64 0
  %r329 = ptrtoint ptr %r328 to i64
  %t331 = call i64 @nova_rt_eq(i64 %r327, i64 %r329)
  %r330 = and i64 %t331, 1
  br label %or_entry340
or_entry340:
  %t333 = icmp ne i64 %r320, 0
  br i1 %t333, label %or_end342, label %or_rhs341
or_rhs341:
  %r334 = load i64, ptr %slot.word, align 8
  %r335 = getelementptr inbounds [6 x i8], ptr @.str.142, i64 0, i64 0
  %r336 = ptrtoint ptr %r335 to i64
  %t338 = call i64 @nova_rt_eq(i64 %r334, i64 %r336)
  %r337 = and i64 %t338, 1
  br label %or_done343
or_done343:
  br label %or_end342
or_end342:
  %r332 = phi i64 [%r320, %or_entry340], [%t338, %or_done343]
  %r339 = load i64, ptr %slot.word, align 8
  %r340 = getelementptr inbounds [4 x i8], ptr @.str.143, i64 0, i64 0
  %r341 = ptrtoint ptr %r340 to i64
  %t343 = call i64 @nova_rt_eq(i64 %r339, i64 %r341)
  %r342 = and i64 %t343, 1
  br label %or_entry344
or_entry344:
  %t345 = icmp ne i64 %r332, 0
  br i1 %t345, label %or_end346, label %or_rhs345
or_rhs345:
  %r346 = load i64, ptr %slot.word, align 8
  %r347 = getelementptr inbounds [4 x i8], ptr @.str.143, i64 0, i64 0
  %r348 = ptrtoint ptr %r347 to i64
  %t350 = call i64 @nova_rt_eq(i64 %r346, i64 %r348)
  %r349 = and i64 %t350, 1
  br label %or_done347
or_done347:
  br label %or_end346
or_end346:
  %r344 = phi i64 [%r332, %or_entry344], [%t350, %or_done347]
  %r351 = load i64, ptr %slot.word, align 8
  %r352 = getelementptr inbounds [3 x i8], ptr @.str.144, i64 0, i64 0
  %r353 = ptrtoint ptr %r352 to i64
  %t355 = call i64 @nova_rt_eq(i64 %r351, i64 %r353)
  %r354 = and i64 %t355, 1
  br label %or_entry348
or_entry348:
  %t357 = icmp ne i64 %r344, 0
  br i1 %t357, label %or_end350, label %or_rhs349
or_rhs349:
  %r358 = load i64, ptr %slot.word, align 8
  %r359 = getelementptr inbounds [3 x i8], ptr @.str.144, i64 0, i64 0
  %r360 = ptrtoint ptr %r359 to i64
  %t362 = call i64 @nova_rt_eq(i64 %r358, i64 %r360)
  %r361 = and i64 %t362, 1
  br label %or_done351
or_done351:
  br label %or_end350
or_end350:
  %r356 = phi i64 [%r344, %or_entry348], [%t362, %or_done351]
  %r363 = load i64, ptr %slot.word, align 8
  %r364 = getelementptr inbounds [4 x i8], ptr @.str.145, i64 0, i64 0
  %r365 = ptrtoint ptr %r364 to i64
  %t367 = call i64 @nova_rt_eq(i64 %r363, i64 %r365)
  %r366 = and i64 %t367, 1
  br label %or_entry352
or_entry352:
  %t369 = icmp ne i64 %r356, 0
  br i1 %t369, label %or_end354, label %or_rhs353
or_rhs353:
  %r370 = load i64, ptr %slot.word, align 8
  %r371 = getelementptr inbounds [4 x i8], ptr @.str.145, i64 0, i64 0
  %r372 = ptrtoint ptr %r371 to i64
  %t374 = call i64 @nova_rt_eq(i64 %r370, i64 %r372)
  %r373 = and i64 %t374, 1
  br label %or_done355
or_done355:
  br label %or_end354
or_end354:
  %r368 = phi i64 [%r356, %or_entry352], [%t374, %or_done355]
  %r375 = load i64, ptr %slot.word, align 8
  %r376 = getelementptr inbounds [3 x i8], ptr @.str.146, i64 0, i64 0
  %r377 = ptrtoint ptr %r376 to i64
  %t379 = call i64 @nova_rt_eq(i64 %r375, i64 %r377)
  %r378 = and i64 %t379, 1
  br label %or_entry356
or_entry356:
  %t381 = icmp ne i64 %r368, 0
  br i1 %t381, label %or_end358, label %or_rhs357
or_rhs357:
  %r382 = load i64, ptr %slot.word, align 8
  %r383 = getelementptr inbounds [3 x i8], ptr @.str.146, i64 0, i64 0
  %r384 = ptrtoint ptr %r383 to i64
  %t386 = call i64 @nova_rt_eq(i64 %r382, i64 %r384)
  %r385 = and i64 %t386, 1
  br label %or_done359
or_done359:
  br label %or_end358
or_end358:
  %r380 = phi i64 [%r368, %or_entry356], [%t386, %or_done359]
  %r387 = load i64, ptr %slot.word, align 8
  %r388 = getelementptr inbounds [4 x i8], ptr @.str.40, i64 0, i64 0
  %r389 = ptrtoint ptr %r388 to i64
  %t391 = call i64 @nova_rt_eq(i64 %r387, i64 %r389)
  %r390 = and i64 %t391, 1
  br label %or_entry360
or_entry360:
  %t393 = icmp ne i64 %r380, 0
  br i1 %t393, label %or_end362, label %or_rhs361
or_rhs361:
  %r394 = load i64, ptr %slot.word, align 8
  %r395 = getelementptr inbounds [4 x i8], ptr @.str.40, i64 0, i64 0
  %r396 = ptrtoint ptr %r395 to i64
  %t398 = call i64 @nova_rt_eq(i64 %r394, i64 %r396)
  %r397 = and i64 %t398, 1
  br label %or_done363
or_done363:
  br label %or_end362
or_end362:
  %r392 = phi i64 [%r380, %or_entry360], [%t398, %or_done363]
  %r399 = load i64, ptr %slot.word, align 8
  %r400 = getelementptr inbounds [5 x i8], ptr @.str.147, i64 0, i64 0
  %r401 = ptrtoint ptr %r400 to i64
  %t403 = call i64 @nova_rt_eq(i64 %r399, i64 %r401)
  %r402 = and i64 %t403, 1
  br label %or_entry364
or_entry364:
  %t405 = icmp ne i64 %r392, 0
  br i1 %t405, label %or_end366, label %or_rhs365
or_rhs365:
  %r406 = load i64, ptr %slot.word, align 8
  %r407 = getelementptr inbounds [5 x i8], ptr @.str.147, i64 0, i64 0
  %r408 = ptrtoint ptr %r407 to i64
  %t410 = call i64 @nova_rt_eq(i64 %r406, i64 %r408)
  %r409 = and i64 %t410, 1
  br label %or_done367
or_done367:
  br label %or_end366
or_end366:
  %r404 = phi i64 [%r392, %or_entry364], [%t410, %or_done367]
  %r411 = load i64, ptr %slot.word, align 8
  %r412 = getelementptr inbounds [6 x i8], ptr @.str.148, i64 0, i64 0
  %r413 = ptrtoint ptr %r412 to i64
  %t415 = call i64 @nova_rt_eq(i64 %r411, i64 %r413)
  %r414 = and i64 %t415, 1
  br label %or_entry368
or_entry368:
  %t417 = icmp ne i64 %r404, 0
  br i1 %t417, label %or_end370, label %or_rhs369
or_rhs369:
  %r418 = load i64, ptr %slot.word, align 8
  %r419 = getelementptr inbounds [6 x i8], ptr @.str.148, i64 0, i64 0
  %r420 = ptrtoint ptr %r419 to i64
  %t422 = call i64 @nova_rt_eq(i64 %r418, i64 %r420)
  %r421 = and i64 %t422, 1
  br label %or_done371
or_done371:
  br label %or_end370
or_end370:
  %r416 = phi i64 [%r404, %or_entry368], [%t422, %or_done371]
  %t423 = icmp ne i64 %r416, 0
  br i1 %t423, label %then372, label %else373
then372:
  %r424 = load i64, ptr %slot.tokens, align 8
  %r425 = call ptr @nova_rt_struct_alloc(i64 32)
  %r426 = getelementptr inbounds [3 x i8], ptr @.str.149, i64 0, i64 0
  %r427 = ptrtoint ptr %r426 to i64
  %t428 = getelementptr i64, ptr %r425, i64 0
  store i64 %r427, ptr %t428, align 8
  %r429 = load i64, ptr %slot.word, align 8
  %t430 = getelementptr i64, ptr %r425, i64 1
  store i64 %r429, ptr %t430, align 8
  %r431 = load i64, ptr %slot.line, align 8
  %t432 = getelementptr i64, ptr %r425, i64 2
  store i64 %r431, ptr %t432, align 8
  %r433 = load i64, ptr %slot.start, align 8
  %t434 = getelementptr i64, ptr %r425, i64 3
  store i64 %r433, ptr %t434, align 8
  %r435 = ptrtoint ptr %r425 to i64
  %r436 = call i64 @nova_rt_list_append(i64 %r424, i64 %r435)
  br label %merge374
else373:
  %r437 = load i64, ptr %slot.tokens, align 8
  %r438 = call ptr @nova_rt_struct_alloc(i64 32)
  %r439 = getelementptr inbounds [6 x i8], ptr @.str.150, i64 0, i64 0
  %r440 = ptrtoint ptr %r439 to i64
  %t441 = getelementptr i64, ptr %r438, i64 0
  store i64 %r440, ptr %t441, align 8
  %r442 = load i64, ptr %slot.word, align 8
  %t443 = getelementptr i64, ptr %r438, i64 1
  store i64 %r442, ptr %t443, align 8
  %r444 = load i64, ptr %slot.line, align 8
  %t445 = getelementptr i64, ptr %r438, i64 2
  store i64 %r444, ptr %t445, align 8
  %r446 = load i64, ptr %slot.start, align 8
  %t447 = getelementptr i64, ptr %r438, i64 3
  store i64 %r446, ptr %t447, align 8
  %r448 = ptrtoint ptr %r438 to i64
  %r449 = call i64 @nova_rt_list_append(i64 %r437, i64 %r448)
  br label %merge374
merge374:
  br label %merge316
else315:
  %r450 = load i64, ptr %slot.ch, align 8
  %r451 = getelementptr inbounds [2 x i8], ptr @.str.14, i64 0, i64 0
  %r452 = ptrtoint ptr %r451 to i64
  %t454 = call i64 @nova_rt_eq(i64 %r450, i64 %r452)
  %r453 = and i64 %t454, 1
  %r455 = load i64, ptr %slot.ch, align 8
  %r456 = getelementptr inbounds [2 x i8], ptr @.str.16, i64 0, i64 0
  %r457 = ptrtoint ptr %r456 to i64
  %t459 = call i64 @nova_rt_eq(i64 %r455, i64 %r457)
  %r458 = and i64 %t459, 1
  br label %or_entry375
or_entry375:
  %t461 = icmp ne i64 %t454, 0
  br i1 %t461, label %or_end377, label %or_rhs376
or_rhs376:
  %r462 = load i64, ptr %slot.ch, align 8
  %r463 = getelementptr inbounds [2 x i8], ptr @.str.16, i64 0, i64 0
  %r464 = ptrtoint ptr %r463 to i64
  %t466 = call i64 @nova_rt_eq(i64 %r462, i64 %r464)
  %r465 = and i64 %t466, 1
  br label %or_done378
or_done378:
  br label %or_end377
or_end377:
  %r460 = phi i64 [%t454, %or_entry375], [%t466, %or_done378]
  %r467 = load i64, ptr %slot.ch, align 8
  %r468 = getelementptr inbounds [2 x i8], ptr @.str.18, i64 0, i64 0
  %r469 = ptrtoint ptr %r468 to i64
  %t471 = call i64 @nova_rt_eq(i64 %r467, i64 %r469)
  %r470 = and i64 %t471, 1
  br label %or_entry379
or_entry379:
  %t473 = icmp ne i64 %r460, 0
  br i1 %t473, label %or_end381, label %or_rhs380
or_rhs380:
  %r474 = load i64, ptr %slot.ch, align 8
  %r475 = getelementptr inbounds [2 x i8], ptr @.str.18, i64 0, i64 0
  %r476 = ptrtoint ptr %r475 to i64
  %t478 = call i64 @nova_rt_eq(i64 %r474, i64 %r476)
  %r477 = and i64 %t478, 1
  br label %or_done382
or_done382:
  br label %or_end381
or_end381:
  %r472 = phi i64 [%r460, %or_entry379], [%t478, %or_done382]
  %r479 = load i64, ptr %slot.ch, align 8
  %r480 = getelementptr inbounds [2 x i8], ptr @.str.20, i64 0, i64 0
  %r481 = ptrtoint ptr %r480 to i64
  %t483 = call i64 @nova_rt_eq(i64 %r479, i64 %r481)
  %r482 = and i64 %t483, 1
  br label %or_entry383
or_entry383:
  %t485 = icmp ne i64 %r472, 0
  br i1 %t485, label %or_end385, label %or_rhs384
or_rhs384:
  %r486 = load i64, ptr %slot.ch, align 8
  %r487 = getelementptr inbounds [2 x i8], ptr @.str.20, i64 0, i64 0
  %r488 = ptrtoint ptr %r487 to i64
  %t490 = call i64 @nova_rt_eq(i64 %r486, i64 %r488)
  %r489 = and i64 %t490, 1
  br label %or_done386
or_done386:
  br label %or_end385
or_end385:
  %r484 = phi i64 [%r472, %or_entry383], [%t490, %or_done386]
  %r491 = load i64, ptr %slot.ch, align 8
  %r492 = getelementptr inbounds [2 x i8], ptr @.str.22, i64 0, i64 0
  %r493 = ptrtoint ptr %r492 to i64
  %t495 = call i64 @nova_rt_eq(i64 %r491, i64 %r493)
  %r494 = and i64 %t495, 1
  br label %or_entry387
or_entry387:
  %t497 = icmp ne i64 %r484, 0
  br i1 %t497, label %or_end389, label %or_rhs388
or_rhs388:
  %r498 = load i64, ptr %slot.ch, align 8
  %r499 = getelementptr inbounds [2 x i8], ptr @.str.22, i64 0, i64 0
  %r500 = ptrtoint ptr %r499 to i64
  %t502 = call i64 @nova_rt_eq(i64 %r498, i64 %r500)
  %r501 = and i64 %t502, 1
  br label %or_done390
or_done390:
  br label %or_end389
or_end389:
  %r496 = phi i64 [%r484, %or_entry387], [%t502, %or_done390]
  %t503 = icmp ne i64 %r496, 0
  br i1 %t503, label %then391, label %else392
then391:
  %r504 = load i64, ptr %slot.tokens, align 8
  %r505 = call ptr @nova_rt_struct_alloc(i64 32)
  %r506 = getelementptr inbounds [3 x i8], ptr @.str.151, i64 0, i64 0
  %r507 = ptrtoint ptr %r506 to i64
  %t508 = getelementptr i64, ptr %r505, i64 0
  store i64 %r507, ptr %t508, align 8
  %r509 = load i64, ptr %slot.ch, align 8
  %t510 = getelementptr i64, ptr %r505, i64 1
  store i64 %r509, ptr %t510, align 8
  %r511 = load i64, ptr %slot.line, align 8
  %t512 = getelementptr i64, ptr %r505, i64 2
  store i64 %r511, ptr %t512, align 8
  %r513 = load i64, ptr %slot.i, align 8
  %t514 = getelementptr i64, ptr %r505, i64 3
  store i64 %r513, ptr %t514, align 8
  %r515 = ptrtoint ptr %r505 to i64
  %r516 = call i64 @nova_rt_list_append(i64 %r504, i64 %r515)
  %r517 = load i64, ptr %slot.i, align 8
  %r518 = call i64 @nova_rt_add(i64 %r517, i64 1)
  store i64 %r518, ptr %slot.i, align 8
  br label %merge393
else392:
  %r519 = load i64, ptr %slot.ch, align 8
  %r520 = getelementptr inbounds [2 x i8], ptr @.str.152, i64 0, i64 0
  %r521 = ptrtoint ptr %r520 to i64
  %t523 = call i64 @nova_rt_eq(i64 %r519, i64 %r521)
  %r522 = and i64 %t523, 1
  %r524 = load i64, ptr %slot.i, align 8
  %r525 = call i64 @nova_rt_add(i64 %r524, i64 1)
  %r526 = load i64, ptr %slot.source, align 8
  %r527 = call i64 @nova_rt_len_any(i64 %r526)
  %t529 = icmp slt i64 %r525, %r527
  %r528 = zext i1 %t529 to i64
  br label %and_entry394
and_entry394:
  %t531 = icmp ne i64 %t523, 0
  br i1 %t531, label %and_rhs395, label %and_end396
and_rhs395:
  %r532 = load i64, ptr %slot.i, align 8
  %r533 = call i64 @nova_rt_add(i64 %r532, i64 1)
  %r534 = load i64, ptr %slot.source, align 8
  %r535 = call i64 @nova_rt_len_any(i64 %r534)
  %t537 = icmp slt i64 %r533, %r535
  %r536 = zext i1 %t537 to i64
  br label %and_done397
and_done397:
  br label %and_end396
and_end396:
  %r530 = phi i64 [0, %and_entry394], [%r536, %and_done397]
  %r538 = load i64, ptr %slot.source, align 8
  %r539 = load i64, ptr %slot.i, align 8
  %r540 = call i64 @nova_rt_add(i64 %r539, i64 1)
  %r541 = call i64 @nova_rt_index_get(i64 %r538, i64 %r540)
  %r542 = getelementptr inbounds [2 x i8], ptr @.str.152, i64 0, i64 0
  %r543 = ptrtoint ptr %r542 to i64
  %t545 = call i64 @nova_rt_eq(i64 %r541, i64 %r543)
  %r544 = and i64 %t545, 1
  br label %and_entry398
and_entry398:
  %t547 = icmp ne i64 %r530, 0
  br i1 %t547, label %and_rhs399, label %and_end400
and_rhs399:
  %r548 = load i64, ptr %slot.source, align 8
  %r549 = load i64, ptr %slot.i, align 8
  %r550 = call i64 @nova_rt_add(i64 %r549, i64 1)
  %r551 = call i64 @nova_rt_index_get(i64 %r548, i64 %r550)
  %r552 = getelementptr inbounds [2 x i8], ptr @.str.152, i64 0, i64 0
  %r553 = ptrtoint ptr %r552 to i64
  %t555 = call i64 @nova_rt_eq(i64 %r551, i64 %r553)
  %r554 = and i64 %t555, 1
  br label %and_done401
and_done401:
  br label %and_end400
and_end400:
  %r546 = phi i64 [0, %and_entry398], [%t555, %and_done401]
  %t556 = icmp ne i64 %r546, 0
  br i1 %t556, label %then402, label %else403
then402:
  %r557 = load i64, ptr %slot.tokens, align 8
  %r558 = call ptr @nova_rt_struct_alloc(i64 32)
  %r559 = getelementptr inbounds [3 x i8], ptr @.str.151, i64 0, i64 0
  %r560 = ptrtoint ptr %r559 to i64
  %t561 = getelementptr i64, ptr %r558, i64 0
  store i64 %r560, ptr %t561, align 8
  %r562 = getelementptr inbounds [3 x i8], ptr @.str.24, i64 0, i64 0
  %r563 = ptrtoint ptr %r562 to i64
  %t564 = getelementptr i64, ptr %r558, i64 1
  store i64 %r563, ptr %t564, align 8
  %r565 = load i64, ptr %slot.line, align 8
  %t566 = getelementptr i64, ptr %r558, i64 2
  store i64 %r565, ptr %t566, align 8
  %r567 = load i64, ptr %slot.i, align 8
  %t568 = getelementptr i64, ptr %r558, i64 3
  store i64 %r567, ptr %t568, align 8
  %r569 = ptrtoint ptr %r558 to i64
  %r570 = call i64 @nova_rt_list_append(i64 %r557, i64 %r569)
  %r571 = load i64, ptr %slot.i, align 8
  %r572 = call i64 @nova_rt_add(i64 %r571, i64 2)
  store i64 %r572, ptr %slot.i, align 8
  br label %merge404
else403:
  %r573 = load i64, ptr %slot.ch, align 8
  %r574 = getelementptr inbounds [2 x i8], ptr @.str.153, i64 0, i64 0
  %r575 = ptrtoint ptr %r574 to i64
  %t577 = call i64 @nova_rt_eq(i64 %r573, i64 %r575)
  %r576 = and i64 %t577, 1
  %r578 = load i64, ptr %slot.i, align 8
  %r579 = call i64 @nova_rt_add(i64 %r578, i64 1)
  %r580 = load i64, ptr %slot.source, align 8
  %r581 = call i64 @nova_rt_len_any(i64 %r580)
  %t583 = icmp slt i64 %r579, %r581
  %r582 = zext i1 %t583 to i64
  br label %and_entry405
and_entry405:
  %t585 = icmp ne i64 %t577, 0
  br i1 %t585, label %and_rhs406, label %and_end407
and_rhs406:
  %r586 = load i64, ptr %slot.i, align 8
  %r587 = call i64 @nova_rt_add(i64 %r586, i64 1)
  %r588 = load i64, ptr %slot.source, align 8
  %r589 = call i64 @nova_rt_len_any(i64 %r588)
  %t591 = icmp slt i64 %r587, %r589
  %r590 = zext i1 %t591 to i64
  br label %and_done408
and_done408:
  br label %and_end407
and_end407:
  %r584 = phi i64 [0, %and_entry405], [%r590, %and_done408]
  %r592 = load i64, ptr %slot.source, align 8
  %r593 = load i64, ptr %slot.i, align 8
  %r594 = call i64 @nova_rt_add(i64 %r593, i64 1)
  %r595 = call i64 @nova_rt_index_get(i64 %r592, i64 %r594)
  %r596 = getelementptr inbounds [2 x i8], ptr @.str.152, i64 0, i64 0
  %r597 = ptrtoint ptr %r596 to i64
  %t599 = call i64 @nova_rt_eq(i64 %r595, i64 %r597)
  %r598 = and i64 %t599, 1
  br label %and_entry409
and_entry409:
  %t601 = icmp ne i64 %r584, 0
  br i1 %t601, label %and_rhs410, label %and_end411
and_rhs410:
  %r602 = load i64, ptr %slot.source, align 8
  %r603 = load i64, ptr %slot.i, align 8
  %r604 = call i64 @nova_rt_add(i64 %r603, i64 1)
  %r605 = call i64 @nova_rt_index_get(i64 %r602, i64 %r604)
  %r606 = getelementptr inbounds [2 x i8], ptr @.str.152, i64 0, i64 0
  %r607 = ptrtoint ptr %r606 to i64
  %t609 = call i64 @nova_rt_eq(i64 %r605, i64 %r607)
  %r608 = and i64 %t609, 1
  br label %and_done412
and_done412:
  br label %and_end411
and_end411:
  %r600 = phi i64 [0, %and_entry409], [%t609, %and_done412]
  %t610 = icmp ne i64 %r600, 0
  br i1 %t610, label %then413, label %else414
then413:
  %r611 = load i64, ptr %slot.tokens, align 8
  %r612 = call ptr @nova_rt_struct_alloc(i64 32)
  %r613 = getelementptr inbounds [3 x i8], ptr @.str.151, i64 0, i64 0
  %r614 = ptrtoint ptr %r613 to i64
  %t615 = getelementptr i64, ptr %r612, i64 0
  store i64 %r614, ptr %t615, align 8
  %r616 = getelementptr inbounds [3 x i8], ptr @.str.26, i64 0, i64 0
  %r617 = ptrtoint ptr %r616 to i64
  %t618 = getelementptr i64, ptr %r612, i64 1
  store i64 %r617, ptr %t618, align 8
  %r619 = load i64, ptr %slot.line, align 8
  %t620 = getelementptr i64, ptr %r612, i64 2
  store i64 %r619, ptr %t620, align 8
  %r621 = load i64, ptr %slot.i, align 8
  %t622 = getelementptr i64, ptr %r612, i64 3
  store i64 %r621, ptr %t622, align 8
  %r623 = ptrtoint ptr %r612 to i64
  %r624 = call i64 @nova_rt_list_append(i64 %r611, i64 %r623)
  %r625 = load i64, ptr %slot.i, align 8
  %r626 = call i64 @nova_rt_add(i64 %r625, i64 2)
  store i64 %r626, ptr %slot.i, align 8
  br label %merge415
else414:
  %r627 = load i64, ptr %slot.ch, align 8
  %r628 = getelementptr inbounds [2 x i8], ptr @.str.28, i64 0, i64 0
  %r629 = ptrtoint ptr %r628 to i64
  %t631 = call i64 @nova_rt_eq(i64 %r627, i64 %r629)
  %r630 = and i64 %t631, 1
  %r632 = load i64, ptr %slot.i, align 8
  %r633 = call i64 @nova_rt_add(i64 %r632, i64 1)
  %r634 = load i64, ptr %slot.source, align 8
  %r635 = call i64 @nova_rt_len_any(i64 %r634)
  %t637 = icmp slt i64 %r633, %r635
  %r636 = zext i1 %t637 to i64
  br label %and_entry416
and_entry416:
  %t639 = icmp ne i64 %t631, 0
  br i1 %t639, label %and_rhs417, label %and_end418
and_rhs417:
  %r640 = load i64, ptr %slot.i, align 8
  %r641 = call i64 @nova_rt_add(i64 %r640, i64 1)
  %r642 = load i64, ptr %slot.source, align 8
  %r643 = call i64 @nova_rt_len_any(i64 %r642)
  %t645 = icmp slt i64 %r641, %r643
  %r644 = zext i1 %t645 to i64
  br label %and_done419
and_done419:
  br label %and_end418
and_end418:
  %r638 = phi i64 [0, %and_entry416], [%r644, %and_done419]
  %r646 = load i64, ptr %slot.source, align 8
  %r647 = load i64, ptr %slot.i, align 8
  %r648 = call i64 @nova_rt_add(i64 %r647, i64 1)
  %r649 = call i64 @nova_rt_index_get(i64 %r646, i64 %r648)
  %r650 = getelementptr inbounds [2 x i8], ptr @.str.152, i64 0, i64 0
  %r651 = ptrtoint ptr %r650 to i64
  %t653 = call i64 @nova_rt_eq(i64 %r649, i64 %r651)
  %r652 = and i64 %t653, 1
  br label %and_entry420
and_entry420:
  %t655 = icmp ne i64 %r638, 0
  br i1 %t655, label %and_rhs421, label %and_end422
and_rhs421:
  %r656 = load i64, ptr %slot.source, align 8
  %r657 = load i64, ptr %slot.i, align 8
  %r658 = call i64 @nova_rt_add(i64 %r657, i64 1)
  %r659 = call i64 @nova_rt_index_get(i64 %r656, i64 %r658)
  %r660 = getelementptr inbounds [2 x i8], ptr @.str.152, i64 0, i64 0
  %r661 = ptrtoint ptr %r660 to i64
  %t663 = call i64 @nova_rt_eq(i64 %r659, i64 %r661)
  %r662 = and i64 %t663, 1
  br label %and_done423
and_done423:
  br label %and_end422
and_end422:
  %r654 = phi i64 [0, %and_entry420], [%t663, %and_done423]
  %t664 = icmp ne i64 %r654, 0
  br i1 %t664, label %then424, label %else425
then424:
  %r665 = load i64, ptr %slot.tokens, align 8
  %r666 = call ptr @nova_rt_struct_alloc(i64 32)
  %r667 = getelementptr inbounds [3 x i8], ptr @.str.151, i64 0, i64 0
  %r668 = ptrtoint ptr %r667 to i64
  %t669 = getelementptr i64, ptr %r666, i64 0
  store i64 %r668, ptr %t669, align 8
  %r670 = getelementptr inbounds [3 x i8], ptr @.str.30, i64 0, i64 0
  %r671 = ptrtoint ptr %r670 to i64
  %t672 = getelementptr i64, ptr %r666, i64 1
  store i64 %r671, ptr %t672, align 8
  %r673 = load i64, ptr %slot.line, align 8
  %t674 = getelementptr i64, ptr %r666, i64 2
  store i64 %r673, ptr %t674, align 8
  %r675 = load i64, ptr %slot.i, align 8
  %t676 = getelementptr i64, ptr %r666, i64 3
  store i64 %r675, ptr %t676, align 8
  %r677 = ptrtoint ptr %r666 to i64
  %r678 = call i64 @nova_rt_list_append(i64 %r665, i64 %r677)
  %r679 = load i64, ptr %slot.i, align 8
  %r680 = call i64 @nova_rt_add(i64 %r679, i64 2)
  store i64 %r680, ptr %slot.i, align 8
  br label %merge426
else425:
  %r681 = load i64, ptr %slot.ch, align 8
  %r682 = getelementptr inbounds [2 x i8], ptr @.str.32, i64 0, i64 0
  %r683 = ptrtoint ptr %r682 to i64
  %t685 = call i64 @nova_rt_eq(i64 %r681, i64 %r683)
  %r684 = and i64 %t685, 1
  %r686 = load i64, ptr %slot.i, align 8
  %r687 = call i64 @nova_rt_add(i64 %r686, i64 1)
  %r688 = load i64, ptr %slot.source, align 8
  %r689 = call i64 @nova_rt_len_any(i64 %r688)
  %t691 = icmp slt i64 %r687, %r689
  %r690 = zext i1 %t691 to i64
  br label %and_entry427
and_entry427:
  %t693 = icmp ne i64 %t685, 0
  br i1 %t693, label %and_rhs428, label %and_end429
and_rhs428:
  %r694 = load i64, ptr %slot.i, align 8
  %r695 = call i64 @nova_rt_add(i64 %r694, i64 1)
  %r696 = load i64, ptr %slot.source, align 8
  %r697 = call i64 @nova_rt_len_any(i64 %r696)
  %t699 = icmp slt i64 %r695, %r697
  %r698 = zext i1 %t699 to i64
  br label %and_done430
and_done430:
  br label %and_end429
and_end429:
  %r692 = phi i64 [0, %and_entry427], [%r698, %and_done430]
  %r700 = load i64, ptr %slot.source, align 8
  %r701 = load i64, ptr %slot.i, align 8
  %r702 = call i64 @nova_rt_add(i64 %r701, i64 1)
  %r703 = call i64 @nova_rt_index_get(i64 %r700, i64 %r702)
  %r704 = getelementptr inbounds [2 x i8], ptr @.str.152, i64 0, i64 0
  %r705 = ptrtoint ptr %r704 to i64
  %t707 = call i64 @nova_rt_eq(i64 %r703, i64 %r705)
  %r706 = and i64 %t707, 1
  br label %and_entry431
and_entry431:
  %t709 = icmp ne i64 %r692, 0
  br i1 %t709, label %and_rhs432, label %and_end433
and_rhs432:
  %r710 = load i64, ptr %slot.source, align 8
  %r711 = load i64, ptr %slot.i, align 8
  %r712 = call i64 @nova_rt_add(i64 %r711, i64 1)
  %r713 = call i64 @nova_rt_index_get(i64 %r710, i64 %r712)
  %r714 = getelementptr inbounds [2 x i8], ptr @.str.152, i64 0, i64 0
  %r715 = ptrtoint ptr %r714 to i64
  %t717 = call i64 @nova_rt_eq(i64 %r713, i64 %r715)
  %r716 = and i64 %t717, 1
  br label %and_done434
and_done434:
  br label %and_end433
and_end433:
  %r708 = phi i64 [0, %and_entry431], [%t717, %and_done434]
  %t718 = icmp ne i64 %r708, 0
  br i1 %t718, label %then435, label %else436
then435:
  %r719 = load i64, ptr %slot.tokens, align 8
  %r720 = call ptr @nova_rt_struct_alloc(i64 32)
  %r721 = getelementptr inbounds [3 x i8], ptr @.str.151, i64 0, i64 0
  %r722 = ptrtoint ptr %r721 to i64
  %t723 = getelementptr i64, ptr %r720, i64 0
  store i64 %r722, ptr %t723, align 8
  %r724 = getelementptr inbounds [3 x i8], ptr @.str.34, i64 0, i64 0
  %r725 = ptrtoint ptr %r724 to i64
  %t726 = getelementptr i64, ptr %r720, i64 1
  store i64 %r725, ptr %t726, align 8
  %r727 = load i64, ptr %slot.line, align 8
  %t728 = getelementptr i64, ptr %r720, i64 2
  store i64 %r727, ptr %t728, align 8
  %r729 = load i64, ptr %slot.i, align 8
  %t730 = getelementptr i64, ptr %r720, i64 3
  store i64 %r729, ptr %t730, align 8
  %r731 = ptrtoint ptr %r720 to i64
  %r732 = call i64 @nova_rt_list_append(i64 %r719, i64 %r731)
  %r733 = load i64, ptr %slot.i, align 8
  %r734 = call i64 @nova_rt_add(i64 %r733, i64 2)
  store i64 %r734, ptr %slot.i, align 8
  br label %merge437
else436:
  %r735 = load i64, ptr %slot.ch, align 8
  %r736 = getelementptr inbounds [2 x i8], ptr @.str.28, i64 0, i64 0
  %r737 = ptrtoint ptr %r736 to i64
  %t739 = call i64 @nova_rt_eq(i64 %r735, i64 %r737)
  %r738 = and i64 %t739, 1
  %t740 = icmp ne i64 %t739, 0
  br i1 %t740, label %then438, label %else439
then438:
  %r741 = load i64, ptr %slot.tokens, align 8
  %r742 = call ptr @nova_rt_struct_alloc(i64 32)
  %r743 = getelementptr inbounds [3 x i8], ptr @.str.151, i64 0, i64 0
  %r744 = ptrtoint ptr %r743 to i64
  %t745 = getelementptr i64, ptr %r742, i64 0
  store i64 %r744, ptr %t745, align 8
  %r746 = getelementptr inbounds [2 x i8], ptr @.str.28, i64 0, i64 0
  %r747 = ptrtoint ptr %r746 to i64
  %t748 = getelementptr i64, ptr %r742, i64 1
  store i64 %r747, ptr %t748, align 8
  %r749 = load i64, ptr %slot.line, align 8
  %t750 = getelementptr i64, ptr %r742, i64 2
  store i64 %r749, ptr %t750, align 8
  %r751 = load i64, ptr %slot.i, align 8
  %t752 = getelementptr i64, ptr %r742, i64 3
  store i64 %r751, ptr %t752, align 8
  %r753 = ptrtoint ptr %r742 to i64
  %r754 = call i64 @nova_rt_list_append(i64 %r741, i64 %r753)
  %r755 = load i64, ptr %slot.i, align 8
  %r756 = call i64 @nova_rt_add(i64 %r755, i64 1)
  store i64 %r756, ptr %slot.i, align 8
  br label %merge440
else439:
  %r757 = load i64, ptr %slot.ch, align 8
  %r758 = getelementptr inbounds [2 x i8], ptr @.str.32, i64 0, i64 0
  %r759 = ptrtoint ptr %r758 to i64
  %t761 = call i64 @nova_rt_eq(i64 %r757, i64 %r759)
  %r760 = and i64 %t761, 1
  %t762 = icmp ne i64 %t761, 0
  br i1 %t762, label %then441, label %else442
then441:
  %r763 = load i64, ptr %slot.tokens, align 8
  %r764 = call ptr @nova_rt_struct_alloc(i64 32)
  %r765 = getelementptr inbounds [3 x i8], ptr @.str.151, i64 0, i64 0
  %r766 = ptrtoint ptr %r765 to i64
  %t767 = getelementptr i64, ptr %r764, i64 0
  store i64 %r766, ptr %t767, align 8
  %r768 = getelementptr inbounds [2 x i8], ptr @.str.32, i64 0, i64 0
  %r769 = ptrtoint ptr %r768 to i64
  %t770 = getelementptr i64, ptr %r764, i64 1
  store i64 %r769, ptr %t770, align 8
  %r771 = load i64, ptr %slot.line, align 8
  %t772 = getelementptr i64, ptr %r764, i64 2
  store i64 %r771, ptr %t772, align 8
  %r773 = load i64, ptr %slot.i, align 8
  %t774 = getelementptr i64, ptr %r764, i64 3
  store i64 %r773, ptr %t774, align 8
  %r775 = ptrtoint ptr %r764 to i64
  %r776 = call i64 @nova_rt_list_append(i64 %r763, i64 %r775)
  %r777 = load i64, ptr %slot.i, align 8
  %r778 = call i64 @nova_rt_add(i64 %r777, i64 1)
  store i64 %r778, ptr %slot.i, align 8
  br label %merge443
else442:
  %r779 = load i64, ptr %slot.ch, align 8
  %r780 = getelementptr inbounds [2 x i8], ptr @.str.152, i64 0, i64 0
  %r781 = ptrtoint ptr %r780 to i64
  %t783 = call i64 @nova_rt_eq(i64 %r779, i64 %r781)
  %r782 = and i64 %t783, 1
  %t784 = icmp ne i64 %t783, 0
  br i1 %t784, label %then444, label %else445
then444:
  %r785 = load i64, ptr %slot.tokens, align 8
  %r786 = call ptr @nova_rt_struct_alloc(i64 32)
  %r787 = getelementptr inbounds [7 x i8], ptr @.str.154, i64 0, i64 0
  %r788 = ptrtoint ptr %r787 to i64
  %t789 = getelementptr i64, ptr %r786, i64 0
  store i64 %r788, ptr %t789, align 8
  %r790 = getelementptr inbounds [2 x i8], ptr @.str.152, i64 0, i64 0
  %r791 = ptrtoint ptr %r790 to i64
  %t792 = getelementptr i64, ptr %r786, i64 1
  store i64 %r791, ptr %t792, align 8
  %r793 = load i64, ptr %slot.line, align 8
  %t794 = getelementptr i64, ptr %r786, i64 2
  store i64 %r793, ptr %t794, align 8
  %r795 = load i64, ptr %slot.i, align 8
  %t796 = getelementptr i64, ptr %r786, i64 3
  store i64 %r795, ptr %t796, align 8
  %r797 = ptrtoint ptr %r786 to i64
  %r798 = call i64 @nova_rt_list_append(i64 %r785, i64 %r797)
  %r799 = load i64, ptr %slot.i, align 8
  %r800 = call i64 @nova_rt_add(i64 %r799, i64 1)
  store i64 %r800, ptr %slot.i, align 8
  br label %merge446
else445:
  %r801 = load i64, ptr %slot.ch, align 8
  %r802 = getelementptr inbounds [2 x i8], ptr @.str.105, i64 0, i64 0
  %r803 = ptrtoint ptr %r802 to i64
  %t805 = call i64 @nova_rt_eq(i64 %r801, i64 %r803)
  %r804 = and i64 %t805, 1
  %t806 = icmp ne i64 %t805, 0
  br i1 %t806, label %then447, label %else448
then447:
  %r807 = load i64, ptr %slot.tokens, align 8
  %r808 = call ptr @nova_rt_struct_alloc(i64 32)
  %r809 = getelementptr inbounds [7 x i8], ptr @.str.155, i64 0, i64 0
  %r810 = ptrtoint ptr %r809 to i64
  %t811 = getelementptr i64, ptr %r808, i64 0
  store i64 %r810, ptr %t811, align 8
  %r812 = getelementptr inbounds [2 x i8], ptr @.str.105, i64 0, i64 0
  %r813 = ptrtoint ptr %r812 to i64
  %t814 = getelementptr i64, ptr %r808, i64 1
  store i64 %r813, ptr %t814, align 8
  %r815 = load i64, ptr %slot.line, align 8
  %t816 = getelementptr i64, ptr %r808, i64 2
  store i64 %r815, ptr %t816, align 8
  %r817 = load i64, ptr %slot.i, align 8
  %t818 = getelementptr i64, ptr %r808, i64 3
  store i64 %r817, ptr %t818, align 8
  %r819 = ptrtoint ptr %r808 to i64
  %r820 = call i64 @nova_rt_list_append(i64 %r807, i64 %r819)
  %r821 = load i64, ptr %slot.i, align 8
  %r822 = call i64 @nova_rt_add(i64 %r821, i64 1)
  store i64 %r822, ptr %slot.i, align 8
  br label %merge449
else448:
  %r823 = load i64, ptr %slot.ch, align 8
  %r824 = getelementptr inbounds [2 x i8], ptr @.str.78, i64 0, i64 0
  %r825 = ptrtoint ptr %r824 to i64
  %t827 = call i64 @nova_rt_eq(i64 %r823, i64 %r825)
  %r826 = and i64 %t827, 1
  %t828 = icmp ne i64 %t827, 0
  br i1 %t828, label %then450, label %else451
then450:
  %r829 = load i64, ptr %slot.tokens, align 8
  %r830 = call ptr @nova_rt_struct_alloc(i64 32)
  %r831 = getelementptr inbounds [7 x i8], ptr @.str.156, i64 0, i64 0
  %r832 = ptrtoint ptr %r831 to i64
  %t833 = getelementptr i64, ptr %r830, i64 0
  store i64 %r832, ptr %t833, align 8
  %r834 = getelementptr inbounds [2 x i8], ptr @.str.78, i64 0, i64 0
  %r835 = ptrtoint ptr %r834 to i64
  %t836 = getelementptr i64, ptr %r830, i64 1
  store i64 %r835, ptr %t836, align 8
  %r837 = load i64, ptr %slot.line, align 8
  %t838 = getelementptr i64, ptr %r830, i64 2
  store i64 %r837, ptr %t838, align 8
  %r839 = load i64, ptr %slot.i, align 8
  %t840 = getelementptr i64, ptr %r830, i64 3
  store i64 %r839, ptr %t840, align 8
  %r841 = ptrtoint ptr %r830 to i64
  %r842 = call i64 @nova_rt_list_append(i64 %r829, i64 %r841)
  %r843 = load i64, ptr %slot.i, align 8
  %r844 = call i64 @nova_rt_add(i64 %r843, i64 1)
  store i64 %r844, ptr %slot.i, align 8
  br label %merge452
else451:
  %r845 = load i64, ptr %slot.ch, align 8
  %r846 = getelementptr inbounds [2 x i8], ptr @.str.157, i64 0, i64 0
  %r847 = ptrtoint ptr %r846 to i64
  %t849 = call i64 @nova_rt_eq(i64 %r845, i64 %r847)
  %r848 = and i64 %t849, 1
  %t850 = icmp ne i64 %t849, 0
  br i1 %t850, label %then453, label %else454
then453:
  %r851 = load i64, ptr %slot.tokens, align 8
  %r852 = call ptr @nova_rt_struct_alloc(i64 32)
  %r853 = getelementptr inbounds [6 x i8], ptr @.str.158, i64 0, i64 0
  %r854 = ptrtoint ptr %r853 to i64
  %t855 = getelementptr i64, ptr %r852, i64 0
  store i64 %r854, ptr %t855, align 8
  %r856 = getelementptr inbounds [2 x i8], ptr @.str.157, i64 0, i64 0
  %r857 = ptrtoint ptr %r856 to i64
  %t858 = getelementptr i64, ptr %r852, i64 1
  store i64 %r857, ptr %t858, align 8
  %r859 = load i64, ptr %slot.line, align 8
  %t860 = getelementptr i64, ptr %r852, i64 2
  store i64 %r859, ptr %t860, align 8
  %r861 = load i64, ptr %slot.i, align 8
  %t862 = getelementptr i64, ptr %r852, i64 3
  store i64 %r861, ptr %t862, align 8
  %r863 = ptrtoint ptr %r852 to i64
  %r864 = call i64 @nova_rt_list_append(i64 %r851, i64 %r863)
  %r865 = load i64, ptr %slot.i, align 8
  %r866 = call i64 @nova_rt_add(i64 %r865, i64 1)
  store i64 %r866, ptr %slot.i, align 8
  br label %merge455
else454:
  %r867 = load i64, ptr %slot.ch, align 8
  %r868 = getelementptr inbounds [2 x i8], ptr @.str.126, i64 0, i64 0
  %r869 = ptrtoint ptr %r868 to i64
  %t871 = call i64 @nova_rt_eq(i64 %r867, i64 %r869)
  %r870 = and i64 %t871, 1
  %t872 = icmp ne i64 %t871, 0
  br i1 %t872, label %then456, label %else457
then456:
  %r873 = load i64, ptr %slot.tokens, align 8
  %r874 = call ptr @nova_rt_struct_alloc(i64 32)
  %r875 = getelementptr inbounds [6 x i8], ptr @.str.159, i64 0, i64 0
  %r876 = ptrtoint ptr %r875 to i64
  %t877 = getelementptr i64, ptr %r874, i64 0
  store i64 %r876, ptr %t877, align 8
  %r878 = getelementptr inbounds [2 x i8], ptr @.str.126, i64 0, i64 0
  %r879 = ptrtoint ptr %r878 to i64
  %t880 = getelementptr i64, ptr %r874, i64 1
  store i64 %r879, ptr %t880, align 8
  %r881 = load i64, ptr %slot.line, align 8
  %t882 = getelementptr i64, ptr %r874, i64 2
  store i64 %r881, ptr %t882, align 8
  %r883 = load i64, ptr %slot.i, align 8
  %t884 = getelementptr i64, ptr %r874, i64 3
  store i64 %r883, ptr %t884, align 8
  %r885 = ptrtoint ptr %r874 to i64
  %r886 = call i64 @nova_rt_list_append(i64 %r873, i64 %r885)
  %r887 = load i64, ptr %slot.i, align 8
  %r888 = call i64 @nova_rt_add(i64 %r887, i64 1)
  store i64 %r888, ptr %slot.i, align 8
  br label %merge458
else457:
  %r889 = load i64, ptr %slot.ch, align 8
  %r890 = getelementptr inbounds [2 x i8], ptr @.str.160, i64 0, i64 0
  %r891 = ptrtoint ptr %r890 to i64
  %t893 = call i64 @nova_rt_eq(i64 %r889, i64 %r891)
  %r892 = and i64 %t893, 1
  %t894 = icmp ne i64 %t893, 0
  br i1 %t894, label %then459, label %else460
then459:
  %r895 = load i64, ptr %slot.tokens, align 8
  %r896 = call ptr @nova_rt_struct_alloc(i64 32)
  %r897 = getelementptr inbounds [9 x i8], ptr @.str.161, i64 0, i64 0
  %r898 = ptrtoint ptr %r897 to i64
  %t899 = getelementptr i64, ptr %r896, i64 0
  store i64 %r898, ptr %t899, align 8
  %r900 = getelementptr inbounds [2 x i8], ptr @.str.160, i64 0, i64 0
  %r901 = ptrtoint ptr %r900 to i64
  %t902 = getelementptr i64, ptr %r896, i64 1
  store i64 %r901, ptr %t902, align 8
  %r903 = load i64, ptr %slot.line, align 8
  %t904 = getelementptr i64, ptr %r896, i64 2
  store i64 %r903, ptr %t904, align 8
  %r905 = load i64, ptr %slot.i, align 8
  %t906 = getelementptr i64, ptr %r896, i64 3
  store i64 %r905, ptr %t906, align 8
  %r907 = ptrtoint ptr %r896 to i64
  %r908 = call i64 @nova_rt_list_append(i64 %r895, i64 %r907)
  %r909 = load i64, ptr %slot.i, align 8
  %r910 = call i64 @nova_rt_add(i64 %r909, i64 1)
  store i64 %r910, ptr %slot.i, align 8
  br label %merge461
else460:
  %r911 = load i64, ptr %slot.ch, align 8
  %r912 = getelementptr inbounds [2 x i8], ptr @.str.162, i64 0, i64 0
  %r913 = ptrtoint ptr %r912 to i64
  %t915 = call i64 @nova_rt_eq(i64 %r911, i64 %r913)
  %r914 = and i64 %t915, 1
  %t916 = icmp ne i64 %t915, 0
  br i1 %t916, label %then462, label %else463
then462:
  %r917 = load i64, ptr %slot.tokens, align 8
  %r918 = call ptr @nova_rt_struct_alloc(i64 32)
  %r919 = getelementptr inbounds [9 x i8], ptr @.str.163, i64 0, i64 0
  %r920 = ptrtoint ptr %r919 to i64
  %t921 = getelementptr i64, ptr %r918, i64 0
  store i64 %r920, ptr %t921, align 8
  %r922 = getelementptr inbounds [2 x i8], ptr @.str.162, i64 0, i64 0
  %r923 = ptrtoint ptr %r922 to i64
  %t924 = getelementptr i64, ptr %r918, i64 1
  store i64 %r923, ptr %t924, align 8
  %r925 = load i64, ptr %slot.line, align 8
  %t926 = getelementptr i64, ptr %r918, i64 2
  store i64 %r925, ptr %t926, align 8
  %r927 = load i64, ptr %slot.i, align 8
  %t928 = getelementptr i64, ptr %r918, i64 3
  store i64 %r927, ptr %t928, align 8
  %r929 = ptrtoint ptr %r918 to i64
  %r930 = call i64 @nova_rt_list_append(i64 %r917, i64 %r929)
  %r931 = load i64, ptr %slot.i, align 8
  %r932 = call i64 @nova_rt_add(i64 %r931, i64 1)
  store i64 %r932, ptr %slot.i, align 8
  br label %merge464
else463:
  %r933 = load i64, ptr %slot.i, align 8
  %r934 = call i64 @nova_rt_add(i64 %r933, i64 1)
  store i64 %r934, ptr %slot.i, align 8
  br label %merge464
merge464:
  br label %merge461
merge461:
  br label %merge458
merge458:
  br label %merge455
merge455:
  br label %merge452
merge452:
  br label %merge449
merge449:
  br label %merge446
merge446:
  br label %merge443
merge443:
  br label %merge440
merge440:
  br label %merge437
merge437:
  br label %merge426
merge426:
  br label %merge415
merge415:
  br label %merge404
merge404:
  br label %merge393
merge393:
  br label %merge316
merge316:
  br label %merge288
merge288:
  br label %merge278
merge278:
  br label %merge268
merge268:
  br label %merge265
merge265:
  br label %merge262
merge262:
  br label %while_hdr249
while_exit251:
  %r935 = load i64, ptr %slot.tokens, align 8
  %r936 = call ptr @nova_rt_struct_alloc(i64 32)
  %r937 = getelementptr inbounds [4 x i8], ptr @.str.164, i64 0, i64 0
  %r938 = ptrtoint ptr %r937 to i64
  %t939 = getelementptr i64, ptr %r936, i64 0
  store i64 %r938, ptr %t939, align 8
  %r940 = getelementptr inbounds [1 x i8], ptr @.str.1, i64 0, i64 0
  %r941 = ptrtoint ptr %r940 to i64
  %t942 = getelementptr i64, ptr %r936, i64 1
  store i64 %r941, ptr %t942, align 8
  %r943 = load i64, ptr %slot.line, align 8
  %t944 = getelementptr i64, ptr %r936, i64 2
  store i64 %r943, ptr %t944, align 8
  %r945 = load i64, ptr %slot.i, align 8
  %t946 = getelementptr i64, ptr %r936, i64 3
  store i64 %r945, ptr %t946, align 8
  %r947 = ptrtoint ptr %r936 to i64
  %r948 = call i64 @nova_rt_list_append(i64 %r935, i64 %r947)
  %r949 = load i64, ptr %slot.tokens, align 8
  ret i64 %r949
}

define i64 @skip_nl_mini(i64 %p0, i64 %p1) nounwind {
entry:
  %slot.tokens = alloca i64, align 8
  store i64 %p0, ptr %slot.tokens, align 8
  %slot.pos = alloca i64, align 8
  store i64 %p1, ptr %slot.pos, align 8
  %slot.k = alloca i64, align 8
  store i64 0, ptr %slot.k, align 8
  %slot.v = alloca i64, align 8
  store i64 0, ptr %slot.v, align 8
  %slot.l = alloca i64, align 8
  store i64 0, ptr %slot.l, align 8
  %slot.c = alloca i64, align 8
  store i64 0, ptr %slot.c, align 8
  br label %while_hdr465
while_hdr465:
  %r0 = load i64, ptr %slot.pos, align 8
  %r1 = load i64, ptr %slot.tokens, align 8
  %r2 = call i64 @nova_rt_len_any(i64 %r1)
  %t4 = icmp slt i64 %r0, %r2
  %r3 = zext i1 %t4 to i64
  %t5 = icmp ne i64 %r3, 0
  br i1 %t5, label %while_body466, label %while_exit467
while_body466:
  %r6 = load i64, ptr %slot.tokens, align 8
  %r7 = load i64, ptr %slot.pos, align 8
  %r8 = call i64 @nova_rt_index_get(i64 %r6, i64 %r7)
  %t9 = inttoptr i64 %r8 to ptr
  %t10 = getelementptr i64, ptr %t9, i64 0
  %r11 = load i64, ptr %t10, align 8
  store i64 %r11, ptr %slot.k, align 8
  %t12 = getelementptr i64, ptr %t9, i64 1
  %r13 = load i64, ptr %t12, align 8
  store i64 %r13, ptr %slot.v, align 8
  %t14 = getelementptr i64, ptr %t9, i64 2
  %r15 = load i64, ptr %t14, align 8
  store i64 %r15, ptr %slot.l, align 8
  %t16 = getelementptr i64, ptr %t9, i64 3
  %r17 = load i64, ptr %t16, align 8
  store i64 %r17, ptr %slot.c, align 8
  %r18 = load i64, ptr %slot.k, align 8
  %r19 = getelementptr inbounds [8 x i8], ptr @.str.133, i64 0, i64 0
  %r20 = ptrtoint ptr %r19 to i64
  %t22 = call i64 @nova_rt_neq(i64 %r18, i64 %r20)
  %t23 = icmp ne i64 %t22, 0
  br i1 %t23, label %then468, label %else469
then468:
  %r24 = load i64, ptr %slot.pos, align 8
  ret i64 %r24
  br label %merge470
else469:
  br label %merge470
merge470:
  %r25 = load i64, ptr %slot.pos, align 8
  %r26 = call i64 @nova_rt_add(i64 %r25, i64 1)
  store i64 %r26, ptr %slot.pos, align 8
  br label %while_hdr465
while_exit467:
  %r27 = load i64, ptr %slot.pos, align 8
  ret i64 %r27
}

define i64 @parse_expr_mini(i64 %p0, i64 %p1) nounwind {
entry:
  %slot.tokens = alloca i64, align 8
  store i64 %p0, ptr %slot.tokens, align 8
  %slot.pos = alloca i64, align 8
  store i64 %p1, ptr %slot.pos, align 8
  %slot.left = alloca i64, align 8
  store i64 0, ptr %slot.left, align 8
  %slot.lpos = alloca i64, align 8
  store i64 0, ptr %slot.lpos, align 8
  %slot.k = alloca i64, align 8
  store i64 0, ptr %slot.k, align 8
  %slot.v = alloca i64, align 8
  store i64 0, ptr %slot.v, align 8
  %slot.l = alloca i64, align 8
  store i64 0, ptr %slot.l, align 8
  %slot.c = alloca i64, align 8
  store i64 0, ptr %slot.c, align 8
  %slot.right = alloca i64, align 8
  store i64 0, ptr %slot.right, align 8
  %r0 = load i64, ptr %slot.tokens, align 8
  %r1 = load i64, ptr %slot.pos, align 8
  %r2 = call i64 @parse_atom_mini(i64 %r0, i64 %r1)
  store i64 %r2, ptr %slot.left, align 8
  %r3 = load i64, ptr %slot.left, align 8
  %t5 = inttoptr i64 %r3 to ptr
  %t6 = getelementptr i64, ptr %t5, i64 1
  %r4 = load i64, ptr %t6, align 8
  store i64 %r4, ptr %slot.lpos, align 8
  %r7 = load i64, ptr %slot.lpos, align 8
  %r8 = load i64, ptr %slot.tokens, align 8
  %r9 = call i64 @nova_rt_len_any(i64 %r8)
  %t11 = icmp slt i64 %r7, %r9
  %r10 = zext i1 %t11 to i64
  %t12 = icmp ne i64 %r10, 0
  br i1 %t12, label %then471, label %else472
then471:
  %r13 = load i64, ptr %slot.tokens, align 8
  %r14 = load i64, ptr %slot.lpos, align 8
  %r15 = call i64 @nova_rt_index_get(i64 %r13, i64 %r14)
  %t16 = inttoptr i64 %r15 to ptr
  %t17 = getelementptr i64, ptr %t16, i64 0
  %r18 = load i64, ptr %t17, align 8
  store i64 %r18, ptr %slot.k, align 8
  %t19 = getelementptr i64, ptr %t16, i64 1
  %r20 = load i64, ptr %t19, align 8
  store i64 %r20, ptr %slot.v, align 8
  %t21 = getelementptr i64, ptr %t16, i64 2
  %r22 = load i64, ptr %t21, align 8
  store i64 %r22, ptr %slot.l, align 8
  %t23 = getelementptr i64, ptr %t16, i64 3
  %r24 = load i64, ptr %t23, align 8
  store i64 %r24, ptr %slot.c, align 8
  %r25 = load i64, ptr %slot.k, align 8
  %r26 = getelementptr inbounds [3 x i8], ptr @.str.151, i64 0, i64 0
  %r27 = ptrtoint ptr %r26 to i64
  %t29 = call i64 @nova_rt_eq(i64 %r25, i64 %r27)
  %r28 = and i64 %t29, 1
  %t30 = icmp ne i64 %t29, 0
  br i1 %t30, label %then474, label %else475
then474:
  %r31 = load i64, ptr %slot.tokens, align 8
  %r32 = load i64, ptr %slot.lpos, align 8
  %r33 = call i64 @nova_rt_add(i64 %r32, i64 1)
  %r34 = call i64 @parse_atom_mini(i64 %r31, i64 %r33)
  store i64 %r34, ptr %slot.right, align 8
  %r35 = call ptr @nova_rt_struct_alloc(i64 16)
  %r36 = call ptr @nova_rt_struct_alloc(i64 40)
  %r37 = getelementptr inbounds [6 x i8], ptr @.str.13, i64 0, i64 0
  %r38 = ptrtoint ptr %r37 to i64
  %t39 = getelementptr i64, ptr %r36, i64 0
  store i64 %r38, ptr %t39, align 8
  %r40 = load i64, ptr %slot.v, align 8
  %t41 = getelementptr i64, ptr %r36, i64 1
  store i64 %r40, ptr %t41, align 8
  %t42 = getelementptr i64, ptr %r36, i64 2
  store i64 0, ptr %t42, align 8
  %r43 = call i64 @nova_rt_list_create()
  %r44 = load i64, ptr %slot.left, align 8
  %t46 = inttoptr i64 %r44 to ptr
  %t47 = getelementptr i64, ptr %t46, i64 0
  %r45 = load i64, ptr %t47, align 8
  %t48 = call i64 @nova_rt_list_append(i64 %r43, i64 %r45)
  %r49 = load i64, ptr %slot.right, align 8
  %t51 = inttoptr i64 %r49 to ptr
  %t52 = getelementptr i64, ptr %t51, i64 0
  %r50 = load i64, ptr %t52, align 8
  %t53 = call i64 @nova_rt_list_append(i64 %r43, i64 %r50)
  %t54 = getelementptr i64, ptr %r36, i64 3
  store i64 %r43, ptr %t54, align 8
  %r55 = call i64 @nova_rt_list_create()
  %t56 = getelementptr i64, ptr %r36, i64 4
  store i64 %r55, ptr %t56, align 8
  %r57 = ptrtoint ptr %r36 to i64
  %t58 = getelementptr i64, ptr %r35, i64 0
  store i64 %r57, ptr %t58, align 8
  %r59 = load i64, ptr %slot.right, align 8
  %t61 = inttoptr i64 %r59 to ptr
  %t62 = getelementptr i64, ptr %t61, i64 1
  %r60 = load i64, ptr %t62, align 8
  %t63 = getelementptr i64, ptr %r35, i64 1
  store i64 %r60, ptr %t63, align 8
  %r64 = ptrtoint ptr %r35 to i64
  ret i64 %r64
  br label %merge476
else475:
  br label %merge476
merge476:
  br label %merge473
else472:
  br label %merge473
merge473:
  %r65 = load i64, ptr %slot.left, align 8
  ret i64 %r65
}

define i64 @parse_atom_mini(i64 %p0, i64 %p1) nounwind {
entry:
  %slot.tokens = alloca i64, align 8
  store i64 %p0, ptr %slot.tokens, align 8
  %slot.pos = alloca i64, align 8
  store i64 %p1, ptr %slot.pos, align 8
  %slot.k = alloca i64, align 8
  store i64 0, ptr %slot.k, align 8
  %slot.v = alloca i64, align 8
  store i64 0, ptr %slot.v, align 8
  %slot.l = alloca i64, align 8
  store i64 0, ptr %slot.l, align 8
  %slot.c = alloca i64, align 8
  store i64 0, ptr %slot.c, align 8
  %slot.k2 = alloca i64, align 8
  store i64 0, ptr %slot.k2, align 8
  %slot.v2 = alloca i64, align 8
  store i64 0, ptr %slot.v2, align 8
  %slot.l2 = alloca i64, align 8
  store i64 0, ptr %slot.l2, align 8
  %slot.c2 = alloca i64, align 8
  store i64 0, ptr %slot.c2, align 8
  %slot.args = alloca i64, align 8
  store i64 0, ptr %slot.args, align 8
  %slot.ap = alloca i64, align 8
  store i64 0, ptr %slot.ap, align 8
  %slot.ka = alloca i64, align 8
  store i64 0, ptr %slot.ka, align 8
  %slot.va = alloca i64, align 8
  store i64 0, ptr %slot.va, align 8
  %slot.la = alloca i64, align 8
  store i64 0, ptr %slot.la, align 8
  %slot.ca = alloca i64, align 8
  store i64 0, ptr %slot.ca, align 8
  %slot.arg = alloca i64, align 8
  store i64 0, ptr %slot.arg, align 8
  %slot.ka2 = alloca i64, align 8
  store i64 0, ptr %slot.ka2, align 8
  %slot.va2 = alloca i64, align 8
  store i64 0, ptr %slot.va2, align 8
  %slot.la2 = alloca i64, align 8
  store i64 0, ptr %slot.la2, align 8
  %slot.ca2 = alloca i64, align 8
  store i64 0, ptr %slot.ca2, align 8
  %slot.bval = alloca i64, align 8
  store i64 0, ptr %slot.bval, align 8
  %r0 = load i64, ptr %slot.tokens, align 8
  %r1 = load i64, ptr %slot.pos, align 8
  %r2 = call i64 @nova_rt_index_get(i64 %r0, i64 %r1)
  %t3 = inttoptr i64 %r2 to ptr
  %t4 = getelementptr i64, ptr %t3, i64 0
  %r5 = load i64, ptr %t4, align 8
  store i64 %r5, ptr %slot.k, align 8
  %t6 = getelementptr i64, ptr %t3, i64 1
  %r7 = load i64, ptr %t6, align 8
  store i64 %r7, ptr %slot.v, align 8
  %t8 = getelementptr i64, ptr %t3, i64 2
  %r9 = load i64, ptr %t8, align 8
  store i64 %r9, ptr %slot.l, align 8
  %t10 = getelementptr i64, ptr %t3, i64 3
  %r11 = load i64, ptr %t10, align 8
  store i64 %r11, ptr %slot.c, align 8
  %r12 = load i64, ptr %slot.k, align 8
  %r13 = getelementptr inbounds [4 x i8], ptr @.str.135, i64 0, i64 0
  %r14 = ptrtoint ptr %r13 to i64
  %t16 = call i64 @nova_rt_eq(i64 %r12, i64 %r14)
  %r15 = and i64 %t16, 1
  %t17 = icmp ne i64 %t16, 0
  br i1 %t17, label %then477, label %else478
then477:
  %r18 = call ptr @nova_rt_struct_alloc(i64 16)
  %r19 = call ptr @nova_rt_struct_alloc(i64 40)
  %r20 = getelementptr inbounds [4 x i8], ptr @.str.0, i64 0, i64 0
  %r21 = ptrtoint ptr %r20 to i64
  %t22 = getelementptr i64, ptr %r19, i64 0
  store i64 %r21, ptr %t22, align 8
  %r23 = load i64, ptr %slot.v, align 8
  %t24 = getelementptr i64, ptr %r19, i64 1
  store i64 %r23, ptr %t24, align 8
  %r25 = load i64, ptr %slot.v, align 8
  %r26 = call i64 @nova_rt_parse_int(i64 %r25)
  %t27 = getelementptr i64, ptr %r19, i64 2
  store i64 %r26, ptr %t27, align 8
  %r28 = call i64 @nova_rt_list_create()
  %t29 = getelementptr i64, ptr %r19, i64 3
  store i64 %r28, ptr %t29, align 8
  %r30 = call i64 @nova_rt_list_create()
  %t31 = getelementptr i64, ptr %r19, i64 4
  store i64 %r30, ptr %t31, align 8
  %r32 = ptrtoint ptr %r19 to i64
  %t33 = getelementptr i64, ptr %r18, i64 0
  store i64 %r32, ptr %t33, align 8
  %r34 = load i64, ptr %slot.pos, align 8
  %r35 = call i64 @nova_rt_add(i64 %r34, i64 1)
  %t36 = getelementptr i64, ptr %r18, i64 1
  store i64 %r35, ptr %t36, align 8
  %r37 = ptrtoint ptr %r18 to i64
  ret i64 %r37
  br label %merge479
else478:
  %r38 = load i64, ptr %slot.k, align 8
  %r39 = getelementptr inbounds [4 x i8], ptr @.str.138, i64 0, i64 0
  %r40 = ptrtoint ptr %r39 to i64
  %t42 = call i64 @nova_rt_eq(i64 %r38, i64 %r40)
  %r41 = and i64 %t42, 1
  %t43 = icmp ne i64 %t42, 0
  br i1 %t43, label %then480, label %else481
then480:
  %r44 = call ptr @nova_rt_struct_alloc(i64 16)
  %r45 = call ptr @nova_rt_struct_alloc(i64 40)
  %r46 = getelementptr inbounds [4 x i8], ptr @.str.2, i64 0, i64 0
  %r47 = ptrtoint ptr %r46 to i64
  %t48 = getelementptr i64, ptr %r45, i64 0
  store i64 %r47, ptr %t48, align 8
  %r49 = load i64, ptr %slot.v, align 8
  %t50 = getelementptr i64, ptr %r45, i64 1
  store i64 %r49, ptr %t50, align 8
  %t51 = getelementptr i64, ptr %r45, i64 2
  store i64 0, ptr %t51, align 8
  %r52 = call i64 @nova_rt_list_create()
  %t53 = getelementptr i64, ptr %r45, i64 3
  store i64 %r52, ptr %t53, align 8
  %r54 = call i64 @nova_rt_list_create()
  %t55 = getelementptr i64, ptr %r45, i64 4
  store i64 %r54, ptr %t55, align 8
  %r56 = ptrtoint ptr %r45 to i64
  %t57 = getelementptr i64, ptr %r44, i64 0
  store i64 %r56, ptr %t57, align 8
  %r58 = load i64, ptr %slot.pos, align 8
  %r59 = call i64 @nova_rt_add(i64 %r58, i64 1)
  %t60 = getelementptr i64, ptr %r44, i64 1
  store i64 %r59, ptr %t60, align 8
  %r61 = ptrtoint ptr %r44 to i64
  ret i64 %r61
  br label %merge482
else481:
  %r62 = load i64, ptr %slot.k, align 8
  %r63 = getelementptr inbounds [6 x i8], ptr @.str.150, i64 0, i64 0
  %r64 = ptrtoint ptr %r63 to i64
  %t66 = call i64 @nova_rt_eq(i64 %r62, i64 %r64)
  %r65 = and i64 %t66, 1
  %t67 = icmp ne i64 %t66, 0
  br i1 %t67, label %then483, label %else484
then483:
  %r68 = load i64, ptr %slot.pos, align 8
  %r69 = call i64 @nova_rt_add(i64 %r68, i64 1)
  %r70 = load i64, ptr %slot.tokens, align 8
  %r71 = call i64 @nova_rt_len_any(i64 %r70)
  %t73 = icmp slt i64 %r69, %r71
  %r72 = zext i1 %t73 to i64
  %t74 = icmp ne i64 %r72, 0
  br i1 %t74, label %then486, label %else487
then486:
  %r75 = load i64, ptr %slot.tokens, align 8
  %r76 = load i64, ptr %slot.pos, align 8
  %r77 = call i64 @nova_rt_add(i64 %r76, i64 1)
  %r78 = call i64 @nova_rt_index_get(i64 %r75, i64 %r77)
  %t79 = inttoptr i64 %r78 to ptr
  %t80 = getelementptr i64, ptr %t79, i64 0
  %r81 = load i64, ptr %t80, align 8
  store i64 %r81, ptr %slot.k2, align 8
  %t82 = getelementptr i64, ptr %t79, i64 1
  %r83 = load i64, ptr %t82, align 8
  store i64 %r83, ptr %slot.v2, align 8
  %t84 = getelementptr i64, ptr %t79, i64 2
  %r85 = load i64, ptr %t84, align 8
  store i64 %r85, ptr %slot.l2, align 8
  %t86 = getelementptr i64, ptr %t79, i64 3
  %r87 = load i64, ptr %t86, align 8
  store i64 %r87, ptr %slot.c2, align 8
  %r88 = load i64, ptr %slot.k2, align 8
  %r89 = getelementptr inbounds [7 x i8], ptr @.str.155, i64 0, i64 0
  %r90 = ptrtoint ptr %r89 to i64
  %t92 = call i64 @nova_rt_eq(i64 %r88, i64 %r90)
  %r91 = and i64 %t92, 1
  %t93 = icmp ne i64 %t92, 0
  br i1 %t93, label %then489, label %else490
then489:
  %r94 = call i64 @nova_rt_list_create()
  store i64 %r94, ptr %slot.args, align 8
  %r95 = load i64, ptr %slot.pos, align 8
  %r96 = call i64 @nova_rt_add(i64 %r95, i64 2)
  store i64 %r96, ptr %slot.ap, align 8
  br label %while_hdr492
while_hdr492:
  %r97 = load i64, ptr %slot.ap, align 8
  %r98 = load i64, ptr %slot.tokens, align 8
  %r99 = call i64 @nova_rt_len_any(i64 %r98)
  %t101 = icmp slt i64 %r97, %r99
  %r100 = zext i1 %t101 to i64
  %t102 = icmp ne i64 %r100, 0
  br i1 %t102, label %while_body493, label %while_exit494
while_body493:
  %r103 = load i64, ptr %slot.tokens, align 8
  %r104 = load i64, ptr %slot.ap, align 8
  %r105 = call i64 @nova_rt_index_get(i64 %r103, i64 %r104)
  %t106 = inttoptr i64 %r105 to ptr
  %t107 = getelementptr i64, ptr %t106, i64 0
  %r108 = load i64, ptr %t107, align 8
  store i64 %r108, ptr %slot.ka, align 8
  %t109 = getelementptr i64, ptr %t106, i64 1
  %r110 = load i64, ptr %t109, align 8
  store i64 %r110, ptr %slot.va, align 8
  %t111 = getelementptr i64, ptr %t106, i64 2
  %r112 = load i64, ptr %t111, align 8
  store i64 %r112, ptr %slot.la, align 8
  %t113 = getelementptr i64, ptr %t106, i64 3
  %r114 = load i64, ptr %t113, align 8
  store i64 %r114, ptr %slot.ca, align 8
  %r115 = load i64, ptr %slot.ka, align 8
  %r116 = getelementptr inbounds [7 x i8], ptr @.str.156, i64 0, i64 0
  %r117 = ptrtoint ptr %r116 to i64
  %t119 = call i64 @nova_rt_eq(i64 %r115, i64 %r117)
  %r118 = and i64 %t119, 1
  %t120 = icmp ne i64 %t119, 0
  br i1 %t120, label %then495, label %else496
then495:
  %r121 = call ptr @nova_rt_struct_alloc(i64 16)
  %r122 = call ptr @nova_rt_struct_alloc(i64 40)
  %r123 = getelementptr inbounds [5 x i8], ptr @.str.36, i64 0, i64 0
  %r124 = ptrtoint ptr %r123 to i64
  %t125 = getelementptr i64, ptr %r122, i64 0
  store i64 %r124, ptr %t125, align 8
  %r126 = load i64, ptr %slot.v, align 8
  %t127 = getelementptr i64, ptr %r122, i64 1
  store i64 %r126, ptr %t127, align 8
  %t128 = getelementptr i64, ptr %r122, i64 2
  store i64 0, ptr %t128, align 8
  %r129 = load i64, ptr %slot.args, align 8
  %t130 = getelementptr i64, ptr %r122, i64 3
  store i64 %r129, ptr %t130, align 8
  %r131 = call i64 @nova_rt_list_create()
  %t132 = getelementptr i64, ptr %r122, i64 4
  store i64 %r131, ptr %t132, align 8
  %r133 = ptrtoint ptr %r122 to i64
  %t134 = getelementptr i64, ptr %r121, i64 0
  store i64 %r133, ptr %t134, align 8
  %r135 = load i64, ptr %slot.ap, align 8
  %r136 = call i64 @nova_rt_add(i64 %r135, i64 1)
  %t137 = getelementptr i64, ptr %r121, i64 1
  store i64 %r136, ptr %t137, align 8
  %r138 = ptrtoint ptr %r121 to i64
  ret i64 %r138
  br label %merge497
else496:
  br label %merge497
merge497:
  %r139 = load i64, ptr %slot.tokens, align 8
  %r140 = load i64, ptr %slot.ap, align 8
  %r141 = call i64 @parse_expr_mini(i64 %r139, i64 %r140)
  store i64 %r141, ptr %slot.arg, align 8
  %r142 = load i64, ptr %slot.args, align 8
  %r143 = load i64, ptr %slot.arg, align 8
  %t145 = inttoptr i64 %r143 to ptr
  %t146 = getelementptr i64, ptr %t145, i64 0
  %r144 = load i64, ptr %t146, align 8
  %r147 = call i64 @nova_rt_list_append(i64 %r142, i64 %r144)
  %r148 = load i64, ptr %slot.arg, align 8
  %t150 = inttoptr i64 %r148 to ptr
  %t151 = getelementptr i64, ptr %t150, i64 1
  %r149 = load i64, ptr %t151, align 8
  store i64 %r149, ptr %slot.ap, align 8
  %r152 = load i64, ptr %slot.ap, align 8
  %r153 = load i64, ptr %slot.tokens, align 8
  %r154 = call i64 @nova_rt_len_any(i64 %r153)
  %t156 = icmp slt i64 %r152, %r154
  %r155 = zext i1 %t156 to i64
  %t157 = icmp ne i64 %r155, 0
  br i1 %t157, label %then498, label %else499
then498:
  %r158 = load i64, ptr %slot.tokens, align 8
  %r159 = load i64, ptr %slot.ap, align 8
  %r160 = call i64 @nova_rt_index_get(i64 %r158, i64 %r159)
  %t161 = inttoptr i64 %r160 to ptr
  %t162 = getelementptr i64, ptr %t161, i64 0
  %r163 = load i64, ptr %t162, align 8
  store i64 %r163, ptr %slot.ka2, align 8
  %t164 = getelementptr i64, ptr %t161, i64 1
  %r165 = load i64, ptr %t164, align 8
  store i64 %r165, ptr %slot.va2, align 8
  %t166 = getelementptr i64, ptr %t161, i64 2
  %r167 = load i64, ptr %t166, align 8
  store i64 %r167, ptr %slot.la2, align 8
  %t168 = getelementptr i64, ptr %t161, i64 3
  %r169 = load i64, ptr %t168, align 8
  store i64 %r169, ptr %slot.ca2, align 8
  %r170 = load i64, ptr %slot.ka2, align 8
  %r171 = getelementptr inbounds [6 x i8], ptr @.str.158, i64 0, i64 0
  %r172 = ptrtoint ptr %r171 to i64
  %t174 = call i64 @nova_rt_eq(i64 %r170, i64 %r172)
  %r173 = and i64 %t174, 1
  %t175 = icmp ne i64 %t174, 0
  br i1 %t175, label %then501, label %else502
then501:
  %r176 = load i64, ptr %slot.ap, align 8
  %r177 = call i64 @nova_rt_add(i64 %r176, i64 1)
  store i64 %r177, ptr %slot.ap, align 8
  br label %merge503
else502:
  br label %merge503
merge503:
  br label %merge500
else499:
  br label %merge500
merge500:
  br label %while_hdr492
while_exit494:
  %r178 = call ptr @nova_rt_struct_alloc(i64 16)
  %r179 = call ptr @nova_rt_struct_alloc(i64 40)
  %r180 = getelementptr inbounds [5 x i8], ptr @.str.36, i64 0, i64 0
  %r181 = ptrtoint ptr %r180 to i64
  %t182 = getelementptr i64, ptr %r179, i64 0
  store i64 %r181, ptr %t182, align 8
  %r183 = load i64, ptr %slot.v, align 8
  %t184 = getelementptr i64, ptr %r179, i64 1
  store i64 %r183, ptr %t184, align 8
  %t185 = getelementptr i64, ptr %r179, i64 2
  store i64 0, ptr %t185, align 8
  %r186 = load i64, ptr %slot.args, align 8
  %t187 = getelementptr i64, ptr %r179, i64 3
  store i64 %r186, ptr %t187, align 8
  %r188 = call i64 @nova_rt_list_create()
  %t189 = getelementptr i64, ptr %r179, i64 4
  store i64 %r188, ptr %t189, align 8
  %r190 = ptrtoint ptr %r179 to i64
  %t191 = getelementptr i64, ptr %r178, i64 0
  store i64 %r190, ptr %t191, align 8
  %r192 = load i64, ptr %slot.ap, align 8
  %r193 = call i64 @nova_rt_add(i64 %r192, i64 1)
  %t194 = getelementptr i64, ptr %r178, i64 1
  store i64 %r193, ptr %t194, align 8
  %r195 = ptrtoint ptr %r178 to i64
  ret i64 %r195
  br label %merge491
else490:
  br label %merge491
merge491:
  br label %merge488
else487:
  br label %merge488
merge488:
  %r196 = call ptr @nova_rt_struct_alloc(i64 16)
  %r197 = call ptr @nova_rt_struct_alloc(i64 40)
  %r198 = getelementptr inbounds [6 x i8], ptr @.str.11, i64 0, i64 0
  %r199 = ptrtoint ptr %r198 to i64
  %t200 = getelementptr i64, ptr %r197, i64 0
  store i64 %r199, ptr %t200, align 8
  %r201 = load i64, ptr %slot.v, align 8
  %t202 = getelementptr i64, ptr %r197, i64 1
  store i64 %r201, ptr %t202, align 8
  %t203 = getelementptr i64, ptr %r197, i64 2
  store i64 0, ptr %t203, align 8
  %r204 = call i64 @nova_rt_list_create()
  %t205 = getelementptr i64, ptr %r197, i64 3
  store i64 %r204, ptr %t205, align 8
  %r206 = call i64 @nova_rt_list_create()
  %t207 = getelementptr i64, ptr %r197, i64 4
  store i64 %r206, ptr %t207, align 8
  %r208 = ptrtoint ptr %r197 to i64
  %t209 = getelementptr i64, ptr %r196, i64 0
  store i64 %r208, ptr %t209, align 8
  %r210 = load i64, ptr %slot.pos, align 8
  %r211 = call i64 @nova_rt_add(i64 %r210, i64 1)
  %t212 = getelementptr i64, ptr %r196, i64 1
  store i64 %r211, ptr %t212, align 8
  %r213 = ptrtoint ptr %r196 to i64
  ret i64 %r213
  br label %merge485
else484:
  %r214 = load i64, ptr %slot.k, align 8
  %r215 = getelementptr inbounds [3 x i8], ptr @.str.149, i64 0, i64 0
  %r216 = ptrtoint ptr %r215 to i64
  %t218 = call i64 @nova_rt_eq(i64 %r214, i64 %r216)
  %r217 = and i64 %t218, 1
  %r219 = load i64, ptr %slot.v, align 8
  %r220 = getelementptr inbounds [5 x i8], ptr @.str.147, i64 0, i64 0
  %r221 = ptrtoint ptr %r220 to i64
  %t223 = call i64 @nova_rt_eq(i64 %r219, i64 %r221)
  %r222 = and i64 %t223, 1
  %r224 = load i64, ptr %slot.v, align 8
  %r225 = getelementptr inbounds [6 x i8], ptr @.str.148, i64 0, i64 0
  %r226 = ptrtoint ptr %r225 to i64
  %t228 = call i64 @nova_rt_eq(i64 %r224, i64 %r226)
  %r227 = and i64 %t228, 1
  br label %or_entry504
or_entry504:
  %t230 = icmp ne i64 %t223, 0
  br i1 %t230, label %or_end506, label %or_rhs505
or_rhs505:
  %r231 = load i64, ptr %slot.v, align 8
  %r232 = getelementptr inbounds [6 x i8], ptr @.str.148, i64 0, i64 0
  %r233 = ptrtoint ptr %r232 to i64
  %t235 = call i64 @nova_rt_eq(i64 %r231, i64 %r233)
  %r234 = and i64 %t235, 1
  br label %or_done507
or_done507:
  br label %or_end506
or_end506:
  %r229 = phi i64 [%t223, %or_entry504], [%t235, %or_done507]
  br label %and_entry508
and_entry508:
  %t237 = icmp ne i64 %t218, 0
  br i1 %t237, label %and_rhs509, label %and_end510
and_rhs509:
  %r238 = load i64, ptr %slot.v, align 8
  %r239 = getelementptr inbounds [5 x i8], ptr @.str.147, i64 0, i64 0
  %r240 = ptrtoint ptr %r239 to i64
  %t242 = call i64 @nova_rt_eq(i64 %r238, i64 %r240)
  %r241 = and i64 %t242, 1
  %r243 = load i64, ptr %slot.v, align 8
  %r244 = getelementptr inbounds [6 x i8], ptr @.str.148, i64 0, i64 0
  %r245 = ptrtoint ptr %r244 to i64
  %t247 = call i64 @nova_rt_eq(i64 %r243, i64 %r245)
  %r246 = and i64 %t247, 1
  br label %or_entry511
or_entry511:
  %t249 = icmp ne i64 %t242, 0
  br i1 %t249, label %or_end513, label %or_rhs512
or_rhs512:
  %r250 = load i64, ptr %slot.v, align 8
  %r251 = getelementptr inbounds [6 x i8], ptr @.str.148, i64 0, i64 0
  %r252 = ptrtoint ptr %r251 to i64
  %t254 = call i64 @nova_rt_eq(i64 %r250, i64 %r252)
  %r253 = and i64 %t254, 1
  br label %or_done514
or_done514:
  br label %or_end513
or_end513:
  %r248 = phi i64 [%t242, %or_entry511], [%t254, %or_done514]
  br label %and_done515
and_done515:
  br label %and_end510
and_end510:
  %r236 = phi i64 [0, %and_entry508], [%r248, %and_done515]
  %t255 = icmp ne i64 %r236, 0
  br i1 %t255, label %then516, label %else517
then516:
  %r256 = load i64, ptr %slot.v, align 8
  %r257 = getelementptr inbounds [5 x i8], ptr @.str.147, i64 0, i64 0
  %r258 = ptrtoint ptr %r257 to i64
  %t260 = call i64 @nova_rt_eq(i64 %r256, i64 %r258)
  %r259 = and i64 %t260, 1
  %t261 = icmp ne i64 %t260, 0
  br i1 %t261, label %if_then519, label %if_else520
if_then519:
  br label %if_then_done522
if_then_done522:
  br label %if_merge521
if_else520:
  br label %if_else_done523
if_else_done523:
  br label %if_merge521
if_merge521:
  %r262 = phi i64 [1, %if_then_done522], [0, %if_else_done523]
  store i64 %r262, ptr %slot.bval, align 8
  %r263 = call ptr @nova_rt_struct_alloc(i64 16)
  %r264 = call ptr @nova_rt_struct_alloc(i64 40)
  %r265 = getelementptr inbounds [4 x i8], ptr @.str.0, i64 0, i64 0
  %r266 = ptrtoint ptr %r265 to i64
  %t267 = getelementptr i64, ptr %r264, i64 0
  store i64 %r266, ptr %t267, align 8
  %r268 = load i64, ptr %slot.v, align 8
  %t269 = getelementptr i64, ptr %r264, i64 1
  store i64 %r268, ptr %t269, align 8
  %r270 = load i64, ptr %slot.bval, align 8
  %t271 = getelementptr i64, ptr %r264, i64 2
  store i64 %r270, ptr %t271, align 8
  %r272 = call i64 @nova_rt_list_create()
  %t273 = getelementptr i64, ptr %r264, i64 3
  store i64 %r272, ptr %t273, align 8
  %r274 = call i64 @nova_rt_list_create()
  %t275 = getelementptr i64, ptr %r264, i64 4
  store i64 %r274, ptr %t275, align 8
  %r276 = ptrtoint ptr %r264 to i64
  %t277 = getelementptr i64, ptr %r263, i64 0
  store i64 %r276, ptr %t277, align 8
  %r278 = load i64, ptr %slot.pos, align 8
  %r279 = call i64 @nova_rt_add(i64 %r278, i64 1)
  %t280 = getelementptr i64, ptr %r263, i64 1
  store i64 %r279, ptr %t280, align 8
  %r281 = ptrtoint ptr %r263 to i64
  ret i64 %r281
  br label %merge518
else517:
  br label %merge518
merge518:
  br label %merge485
merge485:
  br label %merge482
merge482:
  br label %merge479
merge479:
  %r282 = call ptr @nova_rt_struct_alloc(i64 16)
  %r283 = call ptr @nova_rt_struct_alloc(i64 40)
  %r284 = getelementptr inbounds [4 x i8], ptr @.str.0, i64 0, i64 0
  %r285 = ptrtoint ptr %r284 to i64
  %t286 = getelementptr i64, ptr %r283, i64 0
  store i64 %r285, ptr %t286, align 8
  %r287 = getelementptr inbounds [2 x i8], ptr @.str.47, i64 0, i64 0
  %r288 = ptrtoint ptr %r287 to i64
  %t289 = getelementptr i64, ptr %r283, i64 1
  store i64 %r288, ptr %t289, align 8
  %t290 = getelementptr i64, ptr %r283, i64 2
  store i64 0, ptr %t290, align 8
  %r291 = call i64 @nova_rt_list_create()
  %t292 = getelementptr i64, ptr %r283, i64 3
  store i64 %r291, ptr %t292, align 8
  %r293 = call i64 @nova_rt_list_create()
  %t294 = getelementptr i64, ptr %r283, i64 4
  store i64 %r293, ptr %t294, align 8
  %r295 = ptrtoint ptr %r283 to i64
  %t296 = getelementptr i64, ptr %r282, i64 0
  store i64 %r295, ptr %t296, align 8
  %r297 = load i64, ptr %slot.pos, align 8
  %r298 = call i64 @nova_rt_add(i64 %r297, i64 1)
  %t299 = getelementptr i64, ptr %r282, i64 1
  store i64 %r298, ptr %t299, align 8
  %r300 = ptrtoint ptr %r282 to i64
  ret i64 %r300
}

define i64 @parse_stmt_mini(i64 %p0, i64 %p1) nounwind {
entry:
  %slot.tokens = alloca i64, align 8
  store i64 %p0, ptr %slot.tokens, align 8
  %slot.pos = alloca i64, align 8
  store i64 %p1, ptr %slot.pos, align 8
  %slot.k = alloca i64, align 8
  store i64 0, ptr %slot.k, align 8
  %slot.v = alloca i64, align 8
  store i64 0, ptr %slot.v, align 8
  %slot.l = alloca i64, align 8
  store i64 0, ptr %slot.l, align 8
  %slot.c = alloca i64, align 8
  store i64 0, ptr %slot.c, align 8
  %slot.k2 = alloca i64, align 8
  store i64 0, ptr %slot.k2, align 8
  %slot.name = alloca i64, align 8
  store i64 0, ptr %slot.name, align 8
  %slot.l2 = alloca i64, align 8
  store i64 0, ptr %slot.l2, align 8
  %slot.c2 = alloca i64, align 8
  store i64 0, ptr %slot.c2, align 8
  %slot.ep = alloca i64, align 8
  store i64 0, ptr %slot.ep, align 8
  %slot.v2 = alloca i64, align 8
  store i64 0, ptr %slot.v2, align 8
  %r0 = load i64, ptr %slot.tokens, align 8
  %r1 = load i64, ptr %slot.pos, align 8
  %r2 = call i64 @nova_rt_index_get(i64 %r0, i64 %r1)
  %t3 = inttoptr i64 %r2 to ptr
  %t4 = getelementptr i64, ptr %t3, i64 0
  %r5 = load i64, ptr %t4, align 8
  store i64 %r5, ptr %slot.k, align 8
  %t6 = getelementptr i64, ptr %t3, i64 1
  %r7 = load i64, ptr %t6, align 8
  store i64 %r7, ptr %slot.v, align 8
  %t8 = getelementptr i64, ptr %t3, i64 2
  %r9 = load i64, ptr %t8, align 8
  store i64 %r9, ptr %slot.l, align 8
  %t10 = getelementptr i64, ptr %t3, i64 3
  %r11 = load i64, ptr %t10, align 8
  store i64 %r11, ptr %slot.c, align 8
  %r12 = load i64, ptr %slot.k, align 8
  %r13 = getelementptr inbounds [3 x i8], ptr @.str.149, i64 0, i64 0
  %r14 = ptrtoint ptr %r13 to i64
  %t16 = call i64 @nova_rt_eq(i64 %r12, i64 %r14)
  %r15 = and i64 %t16, 1
  %r17 = load i64, ptr %slot.v, align 8
  %r18 = getelementptr inbounds [4 x i8], ptr @.str.49, i64 0, i64 0
  %r19 = ptrtoint ptr %r18 to i64
  %t21 = call i64 @nova_rt_eq(i64 %r17, i64 %r19)
  %r20 = and i64 %t21, 1
  br label %and_entry524
and_entry524:
  %t23 = icmp ne i64 %t16, 0
  br i1 %t23, label %and_rhs525, label %and_end526
and_rhs525:
  %r24 = load i64, ptr %slot.v, align 8
  %r25 = getelementptr inbounds [4 x i8], ptr @.str.49, i64 0, i64 0
  %r26 = ptrtoint ptr %r25 to i64
  %t28 = call i64 @nova_rt_eq(i64 %r24, i64 %r26)
  %r27 = and i64 %t28, 1
  br label %and_done527
and_done527:
  br label %and_end526
and_end526:
  %r22 = phi i64 [0, %and_entry524], [%t28, %and_done527]
  %t29 = icmp ne i64 %r22, 0
  br i1 %t29, label %then528, label %else529
then528:
  %r30 = load i64, ptr %slot.tokens, align 8
  %r31 = load i64, ptr %slot.pos, align 8
  %r32 = call i64 @nova_rt_add(i64 %r31, i64 1)
  %r33 = call i64 @nova_rt_index_get(i64 %r30, i64 %r32)
  %t34 = inttoptr i64 %r33 to ptr
  %t35 = getelementptr i64, ptr %t34, i64 0
  %r36 = load i64, ptr %t35, align 8
  store i64 %r36, ptr %slot.k2, align 8
  %t37 = getelementptr i64, ptr %t34, i64 1
  %r38 = load i64, ptr %t37, align 8
  store i64 %r38, ptr %slot.name, align 8
  %t39 = getelementptr i64, ptr %t34, i64 2
  %r40 = load i64, ptr %t39, align 8
  store i64 %r40, ptr %slot.l2, align 8
  %t41 = getelementptr i64, ptr %t34, i64 3
  %r42 = load i64, ptr %t41, align 8
  store i64 %r42, ptr %slot.c2, align 8
  %r43 = load i64, ptr %slot.tokens, align 8
  %r44 = load i64, ptr %slot.pos, align 8
  %r45 = call i64 @nova_rt_add(i64 %r44, i64 3)
  %r46 = call i64 @parse_expr_mini(i64 %r43, i64 %r45)
  store i64 %r46, ptr %slot.ep, align 8
  %r47 = call ptr @nova_rt_struct_alloc(i64 16)
  %r48 = call ptr @nova_rt_struct_alloc(i64 56)
  %r49 = getelementptr inbounds [4 x i8], ptr @.str.49, i64 0, i64 0
  %r50 = ptrtoint ptr %r49 to i64
  %t51 = getelementptr i64, ptr %r48, i64 0
  store i64 %r50, ptr %t51, align 8
  %r52 = load i64, ptr %slot.name, align 8
  %t53 = getelementptr i64, ptr %r48, i64 1
  store i64 %r52, ptr %t53, align 8
  %r54 = load i64, ptr %slot.ep, align 8
  %t56 = inttoptr i64 %r54 to ptr
  %t57 = getelementptr i64, ptr %t56, i64 0
  %r55 = load i64, ptr %t57, align 8
  %t58 = getelementptr i64, ptr %r48, i64 2
  store i64 %r55, ptr %t58, align 8
  %r59 = call i64 @nova_rt_list_create()
  %t60 = getelementptr i64, ptr %r48, i64 3
  store i64 %r59, ptr %t60, align 8
  %r61 = call i64 @nova_rt_list_create()
  %t62 = getelementptr i64, ptr %r48, i64 4
  store i64 %r61, ptr %t62, align 8
  %r63 = call i64 @nova_rt_list_create()
  %t64 = getelementptr i64, ptr %r48, i64 5
  store i64 %r63, ptr %t64, align 8
  %r65 = call i64 @nova_rt_list_create()
  %t66 = getelementptr i64, ptr %r48, i64 6
  store i64 %r65, ptr %t66, align 8
  %r67 = ptrtoint ptr %r48 to i64
  %t68 = getelementptr i64, ptr %r47, i64 0
  store i64 %r67, ptr %t68, align 8
  %r69 = load i64, ptr %slot.ep, align 8
  %t71 = inttoptr i64 %r69 to ptr
  %t72 = getelementptr i64, ptr %t71, i64 1
  %r70 = load i64, ptr %t72, align 8
  %t73 = getelementptr i64, ptr %r47, i64 1
  store i64 %r70, ptr %t73, align 8
  %r74 = ptrtoint ptr %r47 to i64
  ret i64 %r74
  br label %merge530
else529:
  %r75 = load i64, ptr %slot.k, align 8
  %r76 = getelementptr inbounds [3 x i8], ptr @.str.149, i64 0, i64 0
  %r77 = ptrtoint ptr %r76 to i64
  %t79 = call i64 @nova_rt_eq(i64 %r75, i64 %r77)
  %r78 = and i64 %t79, 1
  %r80 = load i64, ptr %slot.v, align 8
  %r81 = getelementptr inbounds [7 x i8], ptr @.str.52, i64 0, i64 0
  %r82 = ptrtoint ptr %r81 to i64
  %t84 = call i64 @nova_rt_eq(i64 %r80, i64 %r82)
  %r83 = and i64 %t84, 1
  br label %and_entry531
and_entry531:
  %t86 = icmp ne i64 %t79, 0
  br i1 %t86, label %and_rhs532, label %and_end533
and_rhs532:
  %r87 = load i64, ptr %slot.v, align 8
  %r88 = getelementptr inbounds [7 x i8], ptr @.str.52, i64 0, i64 0
  %r89 = ptrtoint ptr %r88 to i64
  %t91 = call i64 @nova_rt_eq(i64 %r87, i64 %r89)
  %r90 = and i64 %t91, 1
  br label %and_done534
and_done534:
  br label %and_end533
and_end533:
  %r85 = phi i64 [0, %and_entry531], [%t91, %and_done534]
  %t92 = icmp ne i64 %r85, 0
  br i1 %t92, label %then535, label %else536
then535:
  %r93 = load i64, ptr %slot.tokens, align 8
  %r94 = load i64, ptr %slot.pos, align 8
  %r95 = call i64 @nova_rt_add(i64 %r94, i64 1)
  %r96 = call i64 @parse_expr_mini(i64 %r93, i64 %r95)
  store i64 %r96, ptr %slot.ep, align 8
  %r97 = call ptr @nova_rt_struct_alloc(i64 16)
  %r98 = call ptr @nova_rt_struct_alloc(i64 56)
  %r99 = getelementptr inbounds [7 x i8], ptr @.str.52, i64 0, i64 0
  %r100 = ptrtoint ptr %r99 to i64
  %t101 = getelementptr i64, ptr %r98, i64 0
  store i64 %r100, ptr %t101, align 8
  %r102 = getelementptr inbounds [1 x i8], ptr @.str.1, i64 0, i64 0
  %r103 = ptrtoint ptr %r102 to i64
  %t104 = getelementptr i64, ptr %r98, i64 1
  store i64 %r103, ptr %t104, align 8
  %r105 = load i64, ptr %slot.ep, align 8
  %t107 = inttoptr i64 %r105 to ptr
  %t108 = getelementptr i64, ptr %t107, i64 0
  %r106 = load i64, ptr %t108, align 8
  %t109 = getelementptr i64, ptr %r98, i64 2
  store i64 %r106, ptr %t109, align 8
  %r110 = call i64 @nova_rt_list_create()
  %t111 = getelementptr i64, ptr %r98, i64 3
  store i64 %r110, ptr %t111, align 8
  %r112 = call i64 @nova_rt_list_create()
  %t113 = getelementptr i64, ptr %r98, i64 4
  store i64 %r112, ptr %t113, align 8
  %r114 = call i64 @nova_rt_list_create()
  %t115 = getelementptr i64, ptr %r98, i64 5
  store i64 %r114, ptr %t115, align 8
  %r116 = call i64 @nova_rt_list_create()
  %t117 = getelementptr i64, ptr %r98, i64 6
  store i64 %r116, ptr %t117, align 8
  %r118 = ptrtoint ptr %r98 to i64
  %t119 = getelementptr i64, ptr %r97, i64 0
  store i64 %r118, ptr %t119, align 8
  %r120 = load i64, ptr %slot.ep, align 8
  %t122 = inttoptr i64 %r120 to ptr
  %t123 = getelementptr i64, ptr %t122, i64 1
  %r121 = load i64, ptr %t123, align 8
  %t124 = getelementptr i64, ptr %r97, i64 1
  store i64 %r121, ptr %t124, align 8
  %r125 = ptrtoint ptr %r97 to i64
  ret i64 %r125
  br label %merge537
else536:
  %r126 = load i64, ptr %slot.k, align 8
  %r127 = getelementptr inbounds [6 x i8], ptr @.str.150, i64 0, i64 0
  %r128 = ptrtoint ptr %r127 to i64
  %t130 = call i64 @nova_rt_eq(i64 %r126, i64 %r128)
  %r129 = and i64 %t130, 1
  %t131 = icmp ne i64 %t130, 0
  br i1 %t131, label %then538, label %else539
then538:
  %r132 = load i64, ptr %slot.pos, align 8
  %r133 = call i64 @nova_rt_add(i64 %r132, i64 1)
  %r134 = load i64, ptr %slot.tokens, align 8
  %r135 = call i64 @nova_rt_len_any(i64 %r134)
  %t137 = icmp slt i64 %r133, %r135
  %r136 = zext i1 %t137 to i64
  %t138 = icmp ne i64 %r136, 0
  br i1 %t138, label %then541, label %else542
then541:
  %r139 = load i64, ptr %slot.tokens, align 8
  %r140 = load i64, ptr %slot.pos, align 8
  %r141 = call i64 @nova_rt_add(i64 %r140, i64 1)
  %r142 = call i64 @nova_rt_index_get(i64 %r139, i64 %r141)
  %t143 = inttoptr i64 %r142 to ptr
  %t144 = getelementptr i64, ptr %t143, i64 0
  %r145 = load i64, ptr %t144, align 8
  store i64 %r145, ptr %slot.k2, align 8
  %t146 = getelementptr i64, ptr %t143, i64 1
  %r147 = load i64, ptr %t146, align 8
  store i64 %r147, ptr %slot.v2, align 8
  %t148 = getelementptr i64, ptr %t143, i64 2
  %r149 = load i64, ptr %t148, align 8
  store i64 %r149, ptr %slot.l2, align 8
  %t150 = getelementptr i64, ptr %t143, i64 3
  %r151 = load i64, ptr %t150, align 8
  store i64 %r151, ptr %slot.c2, align 8
  %r152 = load i64, ptr %slot.k2, align 8
  %r153 = getelementptr inbounds [7 x i8], ptr @.str.154, i64 0, i64 0
  %r154 = ptrtoint ptr %r153 to i64
  %t156 = call i64 @nova_rt_eq(i64 %r152, i64 %r154)
  %r155 = and i64 %t156, 1
  %t157 = icmp ne i64 %t156, 0
  br i1 %t157, label %then544, label %else545
then544:
  %r158 = load i64, ptr %slot.tokens, align 8
  %r159 = load i64, ptr %slot.pos, align 8
  %r160 = call i64 @nova_rt_add(i64 %r159, i64 2)
  %r161 = call i64 @parse_expr_mini(i64 %r158, i64 %r160)
  store i64 %r161, ptr %slot.ep, align 8
  %r162 = call ptr @nova_rt_struct_alloc(i64 16)
  %r163 = call ptr @nova_rt_struct_alloc(i64 56)
  %r164 = getelementptr inbounds [7 x i8], ptr @.str.50, i64 0, i64 0
  %r165 = ptrtoint ptr %r164 to i64
  %t166 = getelementptr i64, ptr %r163, i64 0
  store i64 %r165, ptr %t166, align 8
  %r167 = load i64, ptr %slot.v, align 8
  %t168 = getelementptr i64, ptr %r163, i64 1
  store i64 %r167, ptr %t168, align 8
  %r169 = load i64, ptr %slot.ep, align 8
  %t171 = inttoptr i64 %r169 to ptr
  %t172 = getelementptr i64, ptr %t171, i64 0
  %r170 = load i64, ptr %t172, align 8
  %t173 = getelementptr i64, ptr %r163, i64 2
  store i64 %r170, ptr %t173, align 8
  %r174 = call i64 @nova_rt_list_create()
  %t175 = getelementptr i64, ptr %r163, i64 3
  store i64 %r174, ptr %t175, align 8
  %r176 = call i64 @nova_rt_list_create()
  %t177 = getelementptr i64, ptr %r163, i64 4
  store i64 %r176, ptr %t177, align 8
  %r178 = call i64 @nova_rt_list_create()
  %t179 = getelementptr i64, ptr %r163, i64 5
  store i64 %r178, ptr %t179, align 8
  %r180 = call i64 @nova_rt_list_create()
  %t181 = getelementptr i64, ptr %r163, i64 6
  store i64 %r180, ptr %t181, align 8
  %r182 = ptrtoint ptr %r163 to i64
  %t183 = getelementptr i64, ptr %r162, i64 0
  store i64 %r182, ptr %t183, align 8
  %r184 = load i64, ptr %slot.ep, align 8
  %t186 = inttoptr i64 %r184 to ptr
  %t187 = getelementptr i64, ptr %t186, i64 1
  %r185 = load i64, ptr %t187, align 8
  %t188 = getelementptr i64, ptr %r162, i64 1
  store i64 %r185, ptr %t188, align 8
  %r189 = ptrtoint ptr %r162 to i64
  ret i64 %r189
  br label %merge546
else545:
  br label %merge546
merge546:
  br label %merge543
else542:
  br label %merge543
merge543:
  %r190 = load i64, ptr %slot.tokens, align 8
  %r191 = load i64, ptr %slot.pos, align 8
  %r192 = call i64 @parse_expr_mini(i64 %r190, i64 %r191)
  store i64 %r192, ptr %slot.ep, align 8
  %r193 = call ptr @nova_rt_struct_alloc(i64 16)
  %r194 = call ptr @nova_rt_struct_alloc(i64 56)
  %r195 = getelementptr inbounds [5 x i8], ptr @.str.48, i64 0, i64 0
  %r196 = ptrtoint ptr %r195 to i64
  %t197 = getelementptr i64, ptr %r194, i64 0
  store i64 %r196, ptr %t197, align 8
  %r198 = getelementptr inbounds [1 x i8], ptr @.str.1, i64 0, i64 0
  %r199 = ptrtoint ptr %r198 to i64
  %t200 = getelementptr i64, ptr %r194, i64 1
  store i64 %r199, ptr %t200, align 8
  %r201 = load i64, ptr %slot.ep, align 8
  %t203 = inttoptr i64 %r201 to ptr
  %t204 = getelementptr i64, ptr %t203, i64 0
  %r202 = load i64, ptr %t204, align 8
  %t205 = getelementptr i64, ptr %r194, i64 2
  store i64 %r202, ptr %t205, align 8
  %r206 = call i64 @nova_rt_list_create()
  %t207 = getelementptr i64, ptr %r194, i64 3
  store i64 %r206, ptr %t207, align 8
  %r208 = call i64 @nova_rt_list_create()
  %t209 = getelementptr i64, ptr %r194, i64 4
  store i64 %r208, ptr %t209, align 8
  %r210 = call i64 @nova_rt_list_create()
  %t211 = getelementptr i64, ptr %r194, i64 5
  store i64 %r210, ptr %t211, align 8
  %r212 = call i64 @nova_rt_list_create()
  %t213 = getelementptr i64, ptr %r194, i64 6
  store i64 %r212, ptr %t213, align 8
  %r214 = ptrtoint ptr %r194 to i64
  %t215 = getelementptr i64, ptr %r193, i64 0
  store i64 %r214, ptr %t215, align 8
  %r216 = load i64, ptr %slot.ep, align 8
  %t218 = inttoptr i64 %r216 to ptr
  %t219 = getelementptr i64, ptr %t218, i64 1
  %r217 = load i64, ptr %t219, align 8
  %t220 = getelementptr i64, ptr %r193, i64 1
  store i64 %r217, ptr %t220, align 8
  %r221 = ptrtoint ptr %r193 to i64
  ret i64 %r221
  br label %merge540
else539:
  br label %merge540
merge540:
  br label %merge537
merge537:
  br label %merge530
merge530:
  %r222 = call ptr @nova_rt_struct_alloc(i64 16)
  %r223 = call ptr @nova_rt_struct_alloc(i64 56)
  %r224 = getelementptr inbounds [5 x i8], ptr @.str.48, i64 0, i64 0
  %r225 = ptrtoint ptr %r224 to i64
  %t226 = getelementptr i64, ptr %r223, i64 0
  store i64 %r225, ptr %t226, align 8
  %r227 = getelementptr inbounds [1 x i8], ptr @.str.1, i64 0, i64 0
  %r228 = ptrtoint ptr %r227 to i64
  %t229 = getelementptr i64, ptr %r223, i64 1
  store i64 %r228, ptr %t229, align 8
  %r230 = call ptr @nova_rt_struct_alloc(i64 40)
  %r231 = getelementptr inbounds [4 x i8], ptr @.str.0, i64 0, i64 0
  %r232 = ptrtoint ptr %r231 to i64
  %t233 = getelementptr i64, ptr %r230, i64 0
  store i64 %r232, ptr %t233, align 8
  %r234 = getelementptr inbounds [2 x i8], ptr @.str.47, i64 0, i64 0
  %r235 = ptrtoint ptr %r234 to i64
  %t236 = getelementptr i64, ptr %r230, i64 1
  store i64 %r235, ptr %t236, align 8
  %t237 = getelementptr i64, ptr %r230, i64 2
  store i64 0, ptr %t237, align 8
  %r238 = call i64 @nova_rt_list_create()
  %t239 = getelementptr i64, ptr %r230, i64 3
  store i64 %r238, ptr %t239, align 8
  %r240 = call i64 @nova_rt_list_create()
  %t241 = getelementptr i64, ptr %r230, i64 4
  store i64 %r240, ptr %t241, align 8
  %r242 = ptrtoint ptr %r230 to i64
  %t243 = getelementptr i64, ptr %r223, i64 2
  store i64 %r242, ptr %t243, align 8
  %r244 = call i64 @nova_rt_list_create()
  %t245 = getelementptr i64, ptr %r223, i64 3
  store i64 %r244, ptr %t245, align 8
  %r246 = call i64 @nova_rt_list_create()
  %t247 = getelementptr i64, ptr %r223, i64 4
  store i64 %r246, ptr %t247, align 8
  %r248 = call i64 @nova_rt_list_create()
  %t249 = getelementptr i64, ptr %r223, i64 5
  store i64 %r248, ptr %t249, align 8
  %r250 = call i64 @nova_rt_list_create()
  %t251 = getelementptr i64, ptr %r223, i64 6
  store i64 %r250, ptr %t251, align 8
  %r252 = ptrtoint ptr %r223 to i64
  %t253 = getelementptr i64, ptr %r222, i64 0
  store i64 %r252, ptr %t253, align 8
  %r254 = load i64, ptr %slot.pos, align 8
  %r255 = call i64 @nova_rt_add(i64 %r254, i64 1)
  %t256 = getelementptr i64, ptr %r222, i64 1
  store i64 %r255, ptr %t256, align 8
  %r257 = ptrtoint ptr %r222 to i64
  ret i64 %r257
}

define i64 @parse_fn_mini(i64 %p0, i64 %p1) nounwind {
entry:
  %slot.tokens = alloca i64, align 8
  store i64 %p0, ptr %slot.tokens, align 8
  %slot.pos = alloca i64, align 8
  store i64 %p1, ptr %slot.pos, align 8
  %slot.k = alloca i64, align 8
  store i64 0, ptr %slot.k, align 8
  %slot.name = alloca i64, align 8
  store i64 0, ptr %slot.name, align 8
  %slot.l = alloca i64, align 8
  store i64 0, ptr %slot.l, align 8
  %slot.c = alloca i64, align 8
  store i64 0, ptr %slot.c, align 8
  %slot.pp = alloca i64, align 8
  store i64 0, ptr %slot.pp, align 8
  %slot.params = alloca i64, align 8
  store i64 0, ptr %slot.params, align 8
  %slot.k2 = alloca i64, align 8
  store i64 0, ptr %slot.k2, align 8
  %slot.v2 = alloca i64, align 8
  store i64 0, ptr %slot.v2, align 8
  %slot.l2 = alloca i64, align 8
  store i64 0, ptr %slot.l2, align 8
  %slot.c2 = alloca i64, align 8
  store i64 0, ptr %slot.c2, align 8
  %slot.body = alloca i64, align 8
  store i64 0, ptr %slot.body, align 8
  %slot.kb = alloca i64, align 8
  store i64 0, ptr %slot.kb, align 8
  %slot.vb = alloca i64, align 8
  store i64 0, ptr %slot.vb, align 8
  %slot.lb = alloca i64, align 8
  store i64 0, ptr %slot.lb, align 8
  %slot.cb = alloca i64, align 8
  store i64 0, ptr %slot.cb, align 8
  %slot.sr = alloca i64, align 8
  store i64 0, ptr %slot.sr, align 8
  %slot.k3 = alloca i64, align 8
  store i64 0, ptr %slot.k3, align 8
  %slot.v3 = alloca i64, align 8
  store i64 0, ptr %slot.v3, align 8
  %slot.l3 = alloca i64, align 8
  store i64 0, ptr %slot.l3, align 8
  %slot.c3 = alloca i64, align 8
  store i64 0, ptr %slot.c3, align 8
  %r0 = load i64, ptr %slot.tokens, align 8
  %r1 = load i64, ptr %slot.pos, align 8
  %r2 = call i64 @nova_rt_add(i64 %r1, i64 1)
  %r3 = call i64 @nova_rt_index_get(i64 %r0, i64 %r2)
  %t4 = inttoptr i64 %r3 to ptr
  %t5 = getelementptr i64, ptr %t4, i64 0
  %r6 = load i64, ptr %t5, align 8
  store i64 %r6, ptr %slot.k, align 8
  %t7 = getelementptr i64, ptr %t4, i64 1
  %r8 = load i64, ptr %t7, align 8
  store i64 %r8, ptr %slot.name, align 8
  %t9 = getelementptr i64, ptr %t4, i64 2
  %r10 = load i64, ptr %t9, align 8
  store i64 %r10, ptr %slot.l, align 8
  %t11 = getelementptr i64, ptr %t4, i64 3
  %r12 = load i64, ptr %t11, align 8
  store i64 %r12, ptr %slot.c, align 8
  %r13 = load i64, ptr %slot.pos, align 8
  %r14 = call i64 @nova_rt_add(i64 %r13, i64 3)
  store i64 %r14, ptr %slot.pp, align 8
  %r15 = call i64 @nova_rt_list_create()
  store i64 %r15, ptr %slot.params, align 8
  br label %while_hdr547
while_hdr547:
  %r16 = load i64, ptr %slot.pp, align 8
  %r17 = load i64, ptr %slot.tokens, align 8
  %r18 = call i64 @nova_rt_len_any(i64 %r17)
  %t20 = icmp slt i64 %r16, %r18
  %r19 = zext i1 %t20 to i64
  %t21 = icmp ne i64 %r19, 0
  br i1 %t21, label %while_body548, label %while_exit549
while_body548:
  %r22 = load i64, ptr %slot.tokens, align 8
  %r23 = load i64, ptr %slot.pp, align 8
  %r24 = call i64 @nova_rt_index_get(i64 %r22, i64 %r23)
  %t25 = inttoptr i64 %r24 to ptr
  %t26 = getelementptr i64, ptr %t25, i64 0
  %r27 = load i64, ptr %t26, align 8
  store i64 %r27, ptr %slot.k2, align 8
  %t28 = getelementptr i64, ptr %t25, i64 1
  %r29 = load i64, ptr %t28, align 8
  store i64 %r29, ptr %slot.v2, align 8
  %t30 = getelementptr i64, ptr %t25, i64 2
  %r31 = load i64, ptr %t30, align 8
  store i64 %r31, ptr %slot.l2, align 8
  %t32 = getelementptr i64, ptr %t25, i64 3
  %r33 = load i64, ptr %t32, align 8
  store i64 %r33, ptr %slot.c2, align 8
  %r34 = load i64, ptr %slot.k2, align 8
  %r35 = getelementptr inbounds [7 x i8], ptr @.str.156, i64 0, i64 0
  %r36 = ptrtoint ptr %r35 to i64
  %t38 = call i64 @nova_rt_eq(i64 %r34, i64 %r36)
  %r37 = and i64 %t38, 1
  %t39 = icmp ne i64 %t38, 0
  br i1 %t39, label %then550, label %else551
then550:
  %r40 = load i64, ptr %slot.pp, align 8
  %r41 = call i64 @nova_rt_add(i64 %r40, i64 1)
  store i64 %r41, ptr %slot.pp, align 8
  %r42 = load i64, ptr %slot.tokens, align 8
  %r43 = load i64, ptr %slot.pp, align 8
  %r44 = call i64 @skip_nl_mini(i64 %r42, i64 %r43)
  store i64 %r44, ptr %slot.pp, align 8
  %r45 = call i64 @nova_rt_list_create()
  store i64 %r45, ptr %slot.body, align 8
  br label %while_hdr553
while_hdr553:
  %r46 = load i64, ptr %slot.pp, align 8
  %r47 = load i64, ptr %slot.tokens, align 8
  %r48 = call i64 @nova_rt_len_any(i64 %r47)
  %t50 = icmp slt i64 %r46, %r48
  %r49 = zext i1 %t50 to i64
  %t51 = icmp ne i64 %r49, 0
  br i1 %t51, label %while_body554, label %while_exit555
while_body554:
  %r52 = load i64, ptr %slot.tokens, align 8
  %r53 = load i64, ptr %slot.pp, align 8
  %r54 = call i64 @nova_rt_index_get(i64 %r52, i64 %r53)
  %t55 = inttoptr i64 %r54 to ptr
  %t56 = getelementptr i64, ptr %t55, i64 0
  %r57 = load i64, ptr %t56, align 8
  store i64 %r57, ptr %slot.kb, align 8
  %t58 = getelementptr i64, ptr %t55, i64 1
  %r59 = load i64, ptr %t58, align 8
  store i64 %r59, ptr %slot.vb, align 8
  %t60 = getelementptr i64, ptr %t55, i64 2
  %r61 = load i64, ptr %t60, align 8
  store i64 %r61, ptr %slot.lb, align 8
  %t62 = getelementptr i64, ptr %t55, i64 3
  %r63 = load i64, ptr %t62, align 8
  store i64 %r63, ptr %slot.cb, align 8
  %r64 = load i64, ptr %slot.kb, align 8
  %r65 = getelementptr inbounds [4 x i8], ptr @.str.164, i64 0, i64 0
  %r66 = ptrtoint ptr %r65 to i64
  %t68 = call i64 @nova_rt_eq(i64 %r64, i64 %r66)
  %r67 = and i64 %t68, 1
  %r69 = load i64, ptr %slot.kb, align 8
  %r70 = getelementptr inbounds [3 x i8], ptr @.str.149, i64 0, i64 0
  %r71 = ptrtoint ptr %r70 to i64
  %t73 = call i64 @nova_rt_eq(i64 %r69, i64 %r71)
  %r72 = and i64 %t73, 1
  %r74 = load i64, ptr %slot.vb, align 8
  %r75 = getelementptr inbounds [3 x i8], ptr @.str.139, i64 0, i64 0
  %r76 = ptrtoint ptr %r75 to i64
  %t78 = call i64 @nova_rt_eq(i64 %r74, i64 %r76)
  %r77 = and i64 %t78, 1
  br label %and_entry556
and_entry556:
  %t80 = icmp ne i64 %t73, 0
  br i1 %t80, label %and_rhs557, label %and_end558
and_rhs557:
  %r81 = load i64, ptr %slot.vb, align 8
  %r82 = getelementptr inbounds [3 x i8], ptr @.str.139, i64 0, i64 0
  %r83 = ptrtoint ptr %r82 to i64
  %t85 = call i64 @nova_rt_eq(i64 %r81, i64 %r83)
  %r84 = and i64 %t85, 1
  br label %and_done559
and_done559:
  br label %and_end558
and_end558:
  %r79 = phi i64 [0, %and_entry556], [%t85, %and_done559]
  br label %or_entry560
or_entry560:
  %t87 = icmp ne i64 %t68, 0
  br i1 %t87, label %or_end562, label %or_rhs561
or_rhs561:
  %r88 = load i64, ptr %slot.kb, align 8
  %r89 = getelementptr inbounds [3 x i8], ptr @.str.149, i64 0, i64 0
  %r90 = ptrtoint ptr %r89 to i64
  %t92 = call i64 @nova_rt_eq(i64 %r88, i64 %r90)
  %r91 = and i64 %t92, 1
  %r93 = load i64, ptr %slot.vb, align 8
  %r94 = getelementptr inbounds [3 x i8], ptr @.str.139, i64 0, i64 0
  %r95 = ptrtoint ptr %r94 to i64
  %t97 = call i64 @nova_rt_eq(i64 %r93, i64 %r95)
  %r96 = and i64 %t97, 1
  br label %and_entry563
and_entry563:
  %t99 = icmp ne i64 %t92, 0
  br i1 %t99, label %and_rhs564, label %and_end565
and_rhs564:
  %r100 = load i64, ptr %slot.vb, align 8
  %r101 = getelementptr inbounds [3 x i8], ptr @.str.139, i64 0, i64 0
  %r102 = ptrtoint ptr %r101 to i64
  %t104 = call i64 @nova_rt_eq(i64 %r100, i64 %r102)
  %r103 = and i64 %t104, 1
  br label %and_done566
and_done566:
  br label %and_end565
and_end565:
  %r98 = phi i64 [0, %and_entry563], [%t104, %and_done566]
  br label %or_done567
or_done567:
  br label %or_end562
or_end562:
  %r86 = phi i64 [%t68, %or_entry560], [%r98, %or_done567]
  %t105 = icmp ne i64 %r86, 0
  br i1 %t105, label %then568, label %else569
then568:
  %r106 = call ptr @nova_rt_struct_alloc(i64 16)
  %r107 = call ptr @nova_rt_struct_alloc(i64 56)
  %r108 = getelementptr inbounds [3 x i8], ptr @.str.139, i64 0, i64 0
  %r109 = ptrtoint ptr %r108 to i64
  %t110 = getelementptr i64, ptr %r107, i64 0
  store i64 %r109, ptr %t110, align 8
  %r111 = load i64, ptr %slot.name, align 8
  %t112 = getelementptr i64, ptr %r107, i64 1
  store i64 %r111, ptr %t112, align 8
  %r113 = call ptr @nova_rt_struct_alloc(i64 40)
  %r114 = getelementptr inbounds [4 x i8], ptr @.str.0, i64 0, i64 0
  %r115 = ptrtoint ptr %r114 to i64
  %t116 = getelementptr i64, ptr %r113, i64 0
  store i64 %r115, ptr %t116, align 8
  %r117 = getelementptr inbounds [2 x i8], ptr @.str.47, i64 0, i64 0
  %r118 = ptrtoint ptr %r117 to i64
  %t119 = getelementptr i64, ptr %r113, i64 1
  store i64 %r118, ptr %t119, align 8
  %t120 = getelementptr i64, ptr %r113, i64 2
  store i64 0, ptr %t120, align 8
  %r121 = call i64 @nova_rt_list_create()
  %t122 = getelementptr i64, ptr %r113, i64 3
  store i64 %r121, ptr %t122, align 8
  %r123 = call i64 @nova_rt_list_create()
  %t124 = getelementptr i64, ptr %r113, i64 4
  store i64 %r123, ptr %t124, align 8
  %r125 = ptrtoint ptr %r113 to i64
  %t126 = getelementptr i64, ptr %r107, i64 2
  store i64 %r125, ptr %t126, align 8
  %r127 = load i64, ptr %slot.body, align 8
  %t128 = getelementptr i64, ptr %r107, i64 3
  store i64 %r127, ptr %t128, align 8
  %r129 = load i64, ptr %slot.params, align 8
  %t130 = getelementptr i64, ptr %r107, i64 4
  store i64 %r129, ptr %t130, align 8
  %r131 = call i64 @nova_rt_list_create()
  %t132 = getelementptr i64, ptr %r107, i64 5
  store i64 %r131, ptr %t132, align 8
  %r133 = call i64 @nova_rt_list_create()
  %t134 = getelementptr i64, ptr %r107, i64 6
  store i64 %r133, ptr %t134, align 8
  %r135 = ptrtoint ptr %r107 to i64
  %t136 = getelementptr i64, ptr %r106, i64 0
  store i64 %r135, ptr %t136, align 8
  %r137 = load i64, ptr %slot.pp, align 8
  %t138 = getelementptr i64, ptr %r106, i64 1
  store i64 %r137, ptr %t138, align 8
  %r139 = ptrtoint ptr %r106 to i64
  ret i64 %r139
  br label %merge570
else569:
  br label %merge570
merge570:
  %r140 = load i64, ptr %slot.kb, align 8
  %r141 = getelementptr inbounds [8 x i8], ptr @.str.133, i64 0, i64 0
  %r142 = ptrtoint ptr %r141 to i64
  %t144 = call i64 @nova_rt_eq(i64 %r140, i64 %r142)
  %r143 = and i64 %t144, 1
  %t145 = icmp ne i64 %t144, 0
  br i1 %t145, label %then571, label %else572
then571:
  %r146 = load i64, ptr %slot.pp, align 8
  %r147 = call i64 @nova_rt_add(i64 %r146, i64 1)
  store i64 %r147, ptr %slot.pp, align 8
  br label %merge573
else572:
  %r148 = load i64, ptr %slot.tokens, align 8
  %r149 = load i64, ptr %slot.pp, align 8
  %r150 = call i64 @parse_stmt_mini(i64 %r148, i64 %r149)
  store i64 %r150, ptr %slot.sr, align 8
  %r151 = load i64, ptr %slot.body, align 8
  %r152 = load i64, ptr %slot.sr, align 8
  %t154 = inttoptr i64 %r152 to ptr
  %t155 = getelementptr i64, ptr %t154, i64 0
  %r153 = load i64, ptr %t155, align 8
  %r156 = call i64 @nova_rt_list_append(i64 %r151, i64 %r153)
  %r157 = load i64, ptr %slot.tokens, align 8
  %r158 = load i64, ptr %slot.sr, align 8
  %t160 = inttoptr i64 %r158 to ptr
  %t161 = getelementptr i64, ptr %t160, i64 1
  %r159 = load i64, ptr %t161, align 8
  %r162 = call i64 @skip_nl_mini(i64 %r157, i64 %r159)
  store i64 %r162, ptr %slot.pp, align 8
  br label %merge573
merge573:
  br label %while_hdr553
while_exit555:
  %r163 = call ptr @nova_rt_struct_alloc(i64 16)
  %r164 = call ptr @nova_rt_struct_alloc(i64 56)
  %r165 = getelementptr inbounds [3 x i8], ptr @.str.139, i64 0, i64 0
  %r166 = ptrtoint ptr %r165 to i64
  %t167 = getelementptr i64, ptr %r164, i64 0
  store i64 %r166, ptr %t167, align 8
  %r168 = load i64, ptr %slot.name, align 8
  %t169 = getelementptr i64, ptr %r164, i64 1
  store i64 %r168, ptr %t169, align 8
  %r170 = call ptr @nova_rt_struct_alloc(i64 40)
  %r171 = getelementptr inbounds [4 x i8], ptr @.str.0, i64 0, i64 0
  %r172 = ptrtoint ptr %r171 to i64
  %t173 = getelementptr i64, ptr %r170, i64 0
  store i64 %r172, ptr %t173, align 8
  %r174 = getelementptr inbounds [2 x i8], ptr @.str.47, i64 0, i64 0
  %r175 = ptrtoint ptr %r174 to i64
  %t176 = getelementptr i64, ptr %r170, i64 1
  store i64 %r175, ptr %t176, align 8
  %t177 = getelementptr i64, ptr %r170, i64 2
  store i64 0, ptr %t177, align 8
  %r178 = call i64 @nova_rt_list_create()
  %t179 = getelementptr i64, ptr %r170, i64 3
  store i64 %r178, ptr %t179, align 8
  %r180 = call i64 @nova_rt_list_create()
  %t181 = getelementptr i64, ptr %r170, i64 4
  store i64 %r180, ptr %t181, align 8
  %r182 = ptrtoint ptr %r170 to i64
  %t183 = getelementptr i64, ptr %r164, i64 2
  store i64 %r182, ptr %t183, align 8
  %r184 = load i64, ptr %slot.body, align 8
  %t185 = getelementptr i64, ptr %r164, i64 3
  store i64 %r184, ptr %t185, align 8
  %r186 = load i64, ptr %slot.params, align 8
  %t187 = getelementptr i64, ptr %r164, i64 4
  store i64 %r186, ptr %t187, align 8
  %r188 = call i64 @nova_rt_list_create()
  %t189 = getelementptr i64, ptr %r164, i64 5
  store i64 %r188, ptr %t189, align 8
  %r190 = call i64 @nova_rt_list_create()
  %t191 = getelementptr i64, ptr %r164, i64 6
  store i64 %r190, ptr %t191, align 8
  %r192 = ptrtoint ptr %r164 to i64
  %t193 = getelementptr i64, ptr %r163, i64 0
  store i64 %r192, ptr %t193, align 8
  %r194 = load i64, ptr %slot.pp, align 8
  %t195 = getelementptr i64, ptr %r163, i64 1
  store i64 %r194, ptr %t195, align 8
  %r196 = ptrtoint ptr %r163 to i64
  ret i64 %r196
  br label %merge552
else551:
  %r197 = load i64, ptr %slot.k2, align 8
  %r198 = getelementptr inbounds [6 x i8], ptr @.str.158, i64 0, i64 0
  %r199 = ptrtoint ptr %r198 to i64
  %t201 = call i64 @nova_rt_eq(i64 %r197, i64 %r199)
  %r200 = and i64 %t201, 1
  %t202 = icmp ne i64 %t201, 0
  br i1 %t202, label %then574, label %else575
then574:
  %r203 = load i64, ptr %slot.pp, align 8
  %r204 = call i64 @nova_rt_add(i64 %r203, i64 1)
  store i64 %r204, ptr %slot.pp, align 8
  br label %merge576
else575:
  %r205 = load i64, ptr %slot.k2, align 8
  %r206 = getelementptr inbounds [6 x i8], ptr @.str.150, i64 0, i64 0
  %r207 = ptrtoint ptr %r206 to i64
  %t209 = call i64 @nova_rt_eq(i64 %r205, i64 %r207)
  %r208 = and i64 %t209, 1
  %t210 = icmp ne i64 %t209, 0
  br i1 %t210, label %then577, label %else578
then577:
  %r211 = load i64, ptr %slot.params, align 8
  %r212 = call ptr @nova_rt_struct_alloc(i64 24)
  %r213 = load i64, ptr %slot.v2, align 8
  %t214 = getelementptr i64, ptr %r212, i64 0
  store i64 %r213, ptr %t214, align 8
  %r215 = getelementptr inbounds [1 x i8], ptr @.str.1, i64 0, i64 0
  %r216 = ptrtoint ptr %r215 to i64
  %t217 = getelementptr i64, ptr %r212, i64 1
  store i64 %r216, ptr %t217, align 8
  %r218 = call ptr @nova_rt_struct_alloc(i64 40)
  %r219 = getelementptr inbounds [4 x i8], ptr @.str.0, i64 0, i64 0
  %r220 = ptrtoint ptr %r219 to i64
  %t221 = getelementptr i64, ptr %r218, i64 0
  store i64 %r220, ptr %t221, align 8
  %r222 = getelementptr inbounds [2 x i8], ptr @.str.47, i64 0, i64 0
  %r223 = ptrtoint ptr %r222 to i64
  %t224 = getelementptr i64, ptr %r218, i64 1
  store i64 %r223, ptr %t224, align 8
  %t225 = getelementptr i64, ptr %r218, i64 2
  store i64 0, ptr %t225, align 8
  %r226 = call i64 @nova_rt_list_create()
  %t227 = getelementptr i64, ptr %r218, i64 3
  store i64 %r226, ptr %t227, align 8
  %r228 = call i64 @nova_rt_list_create()
  %t229 = getelementptr i64, ptr %r218, i64 4
  store i64 %r228, ptr %t229, align 8
  %r230 = ptrtoint ptr %r218 to i64
  %t231 = getelementptr i64, ptr %r212, i64 2
  store i64 %r230, ptr %t231, align 8
  %r232 = ptrtoint ptr %r212 to i64
  %r233 = call i64 @nova_rt_list_append(i64 %r211, i64 %r232)
  %r234 = load i64, ptr %slot.pp, align 8
  %r235 = call i64 @nova_rt_add(i64 %r234, i64 1)
  store i64 %r235, ptr %slot.pp, align 8
  %r236 = load i64, ptr %slot.pp, align 8
  %r237 = load i64, ptr %slot.tokens, align 8
  %r238 = call i64 @nova_rt_len_any(i64 %r237)
  %t240 = icmp slt i64 %r236, %r238
  %r239 = zext i1 %t240 to i64
  %t241 = icmp ne i64 %r239, 0
  br i1 %t241, label %then580, label %else581
then580:
  %r242 = load i64, ptr %slot.tokens, align 8
  %r243 = load i64, ptr %slot.pp, align 8
  %r244 = call i64 @nova_rt_index_get(i64 %r242, i64 %r243)
  %t245 = inttoptr i64 %r244 to ptr
  %t246 = getelementptr i64, ptr %t245, i64 0
  %r247 = load i64, ptr %t246, align 8
  store i64 %r247, ptr %slot.k3, align 8
  %t248 = getelementptr i64, ptr %t245, i64 1
  %r249 = load i64, ptr %t248, align 8
  store i64 %r249, ptr %slot.v3, align 8
  %t250 = getelementptr i64, ptr %t245, i64 2
  %r251 = load i64, ptr %t250, align 8
  store i64 %r251, ptr %slot.l3, align 8
  %t252 = getelementptr i64, ptr %t245, i64 3
  %r253 = load i64, ptr %t252, align 8
  store i64 %r253, ptr %slot.c3, align 8
  %r254 = load i64, ptr %slot.k3, align 8
  %r255 = getelementptr inbounds [6 x i8], ptr @.str.159, i64 0, i64 0
  %r256 = ptrtoint ptr %r255 to i64
  %t258 = call i64 @nova_rt_eq(i64 %r254, i64 %r256)
  %r257 = and i64 %t258, 1
  %t259 = icmp ne i64 %t258, 0
  br i1 %t259, label %then583, label %else584
then583:
  %r260 = load i64, ptr %slot.pp, align 8
  %r261 = call i64 @nova_rt_add(i64 %r260, i64 1)
  store i64 %r261, ptr %slot.pp, align 8
  %r262 = load i64, ptr %slot.pp, align 8
  %r263 = call i64 @nova_rt_add(i64 %r262, i64 1)
  store i64 %r263, ptr %slot.pp, align 8
  br label %merge585
else584:
  br label %merge585
merge585:
  br label %merge582
else581:
  br label %merge582
merge582:
  br label %merge579
else578:
  %r264 = load i64, ptr %slot.pp, align 8
  %r265 = call i64 @nova_rt_add(i64 %r264, i64 1)
  store i64 %r265, ptr %slot.pp, align 8
  br label %merge579
merge579:
  br label %merge576
merge576:
  br label %merge552
merge552:
  br label %while_hdr547
while_exit549:
  %r266 = call ptr @nova_rt_struct_alloc(i64 16)
  %r267 = call ptr @nova_rt_struct_alloc(i64 56)
  %r268 = getelementptr inbounds [3 x i8], ptr @.str.139, i64 0, i64 0
  %r269 = ptrtoint ptr %r268 to i64
  %t270 = getelementptr i64, ptr %r267, i64 0
  store i64 %r269, ptr %t270, align 8
  %r271 = getelementptr inbounds [1 x i8], ptr @.str.1, i64 0, i64 0
  %r272 = ptrtoint ptr %r271 to i64
  %t273 = getelementptr i64, ptr %r267, i64 1
  store i64 %r272, ptr %t273, align 8
  %r274 = call ptr @nova_rt_struct_alloc(i64 40)
  %r275 = getelementptr inbounds [4 x i8], ptr @.str.0, i64 0, i64 0
  %r276 = ptrtoint ptr %r275 to i64
  %t277 = getelementptr i64, ptr %r274, i64 0
  store i64 %r276, ptr %t277, align 8
  %r278 = getelementptr inbounds [2 x i8], ptr @.str.47, i64 0, i64 0
  %r279 = ptrtoint ptr %r278 to i64
  %t280 = getelementptr i64, ptr %r274, i64 1
  store i64 %r279, ptr %t280, align 8
  %t281 = getelementptr i64, ptr %r274, i64 2
  store i64 0, ptr %t281, align 8
  %r282 = call i64 @nova_rt_list_create()
  %t283 = getelementptr i64, ptr %r274, i64 3
  store i64 %r282, ptr %t283, align 8
  %r284 = call i64 @nova_rt_list_create()
  %t285 = getelementptr i64, ptr %r274, i64 4
  store i64 %r284, ptr %t285, align 8
  %r286 = ptrtoint ptr %r274 to i64
  %t287 = getelementptr i64, ptr %r267, i64 2
  store i64 %r286, ptr %t287, align 8
  %r288 = call i64 @nova_rt_list_create()
  %t289 = getelementptr i64, ptr %r267, i64 3
  store i64 %r288, ptr %t289, align 8
  %r290 = call i64 @nova_rt_list_create()
  %t291 = getelementptr i64, ptr %r267, i64 4
  store i64 %r290, ptr %t291, align 8
  %r292 = call i64 @nova_rt_list_create()
  %t293 = getelementptr i64, ptr %r267, i64 5
  store i64 %r292, ptr %t293, align 8
  %r294 = call i64 @nova_rt_list_create()
  %t295 = getelementptr i64, ptr %r267, i64 6
  store i64 %r294, ptr %t295, align 8
  %r296 = ptrtoint ptr %r267 to i64
  %t297 = getelementptr i64, ptr %r266, i64 0
  store i64 %r296, ptr %t297, align 8
  %r298 = load i64, ptr %slot.pos, align 8
  %t299 = getelementptr i64, ptr %r266, i64 1
  store i64 %r298, ptr %t299, align 8
  %r300 = ptrtoint ptr %r266 to i64
  ret i64 %r300
}

define i64 @test_pipeline() nounwind {
entry:
  %slot.b = alloca i64, align 8
  store i64 0, ptr %slot.b, align 8
  %slot.params = alloca i64, align 8
  store i64 0, ptr %slot.params, align 8
  %slot.body = alloca i64, align 8
  store i64 0, ptr %slot.body, align 8
  %slot.fn_stmt = alloca i64, align 8
  store i64 0, ptr %slot.fn_stmt, align 8
  %slot.ir_fn = alloca i64, align 8
  store i64 0, ptr %slot.ir_fn, align 8
  %slot.e = alloca i64, align 8
  store i64 0, ptr %slot.e, align 8
  %slot.line = alloca i64, align 8
  store i64 0, ptr %slot.line, align 8
  %slot.has_call_add = alloca i64, align 8
  store i64 0, ptr %slot.has_call_add, align 8
  %slot.has_ret = alloca i64, align 8
  store i64 0, ptr %slot.has_ret, align 8
  %slot.b2 = alloca i64, align 8
  store i64 0, ptr %slot.b2, align 8
  %slot.typed_fn = alloca i64, align 8
  store i64 0, ptr %slot.typed_fn, align 8
  %slot.e2 = alloca i64, align 8
  store i64 0, ptr %slot.e2, align 8
  %slot.has_direct_add = alloca i64, align 8
  store i64 0, ptr %slot.has_direct_add, align 8
  %slot.has_no_rt_call = alloca i64, align 8
  store i64 0, ptr %slot.has_no_rt_call, align 8
  %slot.source = alloca i64, align 8
  store i64 0, ptr %slot.source, align 8
  %slot.tokens = alloca i64, align 8
  store i64 0, ptr %slot.tokens, align 8
  %slot.pos = alloca i64, align 8
  store i64 0, ptr %slot.pos, align 8
  %slot.k = alloca i64, align 8
  store i64 0, ptr %slot.k, align 8
  %slot.v = alloca i64, align 8
  store i64 0, ptr %slot.v, align 8
  %slot.l = alloca i64, align 8
  store i64 0, ptr %slot.l, align 8
  %slot.c = alloca i64, align 8
  store i64 0, ptr %slot.c, align 8
  %slot.sr = alloca i64, align 8
  store i64 0, ptr %slot.sr, align 8
  %slot.b3 = alloca i64, align 8
  store i64 0, ptr %slot.b3, align 8
  %slot.ir_fn3 = alloca i64, align 8
  store i64 0, ptr %slot.ir_fn3, align 8
  %slot.e3 = alloca i64, align 8
  store i64 0, ptr %slot.e3, align 8
  %slot.has_define = alloca i64, align 8
  store i64 0, ptr %slot.has_define, align 8
  %slot.has_entry = alloca i64, align 8
  store i64 0, ptr %slot.has_entry, align 8
  %r0 = getelementptr inbounds [28 x i8], ptr @.str.165, i64 0, i64 0
  %r1 = ptrtoint ptr %r0 to i64
  %r2 = call i64 @nova_rt_print_any(i64 %r1)
  %r3 = getelementptr inbounds [1 x i8], ptr @.str.1, i64 0, i64 0
  %r4 = ptrtoint ptr %r3 to i64
  %r5 = call i64 @nova_rt_print_any(i64 %r4)
  %r6 = getelementptr inbounds [30 x i8], ptr @.str.166, i64 0, i64 0
  %r7 = ptrtoint ptr %r6 to i64
  %r8 = call i64 @nova_rt_print_any(i64 %r7)
  %r9 = call i64 @new_ir_builder()
  store i64 %r9, ptr %slot.b, align 8
  %r10 = call i64 @nova_rt_list_create()
  %r11 = call ptr @nova_rt_struct_alloc(i64 24)
  %r12 = getelementptr inbounds [2 x i8], ptr @.str.167, i64 0, i64 0
  %r13 = ptrtoint ptr %r12 to i64
  %t14 = getelementptr i64, ptr %r11, i64 0
  store i64 %r13, ptr %t14, align 8
  %r15 = getelementptr inbounds [1 x i8], ptr @.str.1, i64 0, i64 0
  %r16 = ptrtoint ptr %r15 to i64
  %t17 = getelementptr i64, ptr %r11, i64 1
  store i64 %r16, ptr %t17, align 8
  %r18 = call ptr @nova_rt_struct_alloc(i64 40)
  %r19 = getelementptr inbounds [4 x i8], ptr @.str.0, i64 0, i64 0
  %r20 = ptrtoint ptr %r19 to i64
  %t21 = getelementptr i64, ptr %r18, i64 0
  store i64 %r20, ptr %t21, align 8
  %r22 = getelementptr inbounds [2 x i8], ptr @.str.47, i64 0, i64 0
  %r23 = ptrtoint ptr %r22 to i64
  %t24 = getelementptr i64, ptr %r18, i64 1
  store i64 %r23, ptr %t24, align 8
  %t25 = getelementptr i64, ptr %r18, i64 2
  store i64 0, ptr %t25, align 8
  %r26 = call i64 @nova_rt_list_create()
  %t27 = getelementptr i64, ptr %r18, i64 3
  store i64 %r26, ptr %t27, align 8
  %r28 = call i64 @nova_rt_list_create()
  %t29 = getelementptr i64, ptr %r18, i64 4
  store i64 %r28, ptr %t29, align 8
  %r30 = ptrtoint ptr %r18 to i64
  %t31 = getelementptr i64, ptr %r11, i64 2
  store i64 %r30, ptr %t31, align 8
  %r32 = ptrtoint ptr %r11 to i64
  %t33 = call i64 @nova_rt_list_append(i64 %r10, i64 %r32)
  %r34 = call ptr @nova_rt_struct_alloc(i64 24)
  %r35 = getelementptr inbounds [2 x i8], ptr @.str.168, i64 0, i64 0
  %r36 = ptrtoint ptr %r35 to i64
  %t37 = getelementptr i64, ptr %r34, i64 0
  store i64 %r36, ptr %t37, align 8
  %r38 = getelementptr inbounds [1 x i8], ptr @.str.1, i64 0, i64 0
  %r39 = ptrtoint ptr %r38 to i64
  %t40 = getelementptr i64, ptr %r34, i64 1
  store i64 %r39, ptr %t40, align 8
  %r41 = call ptr @nova_rt_struct_alloc(i64 40)
  %r42 = getelementptr inbounds [4 x i8], ptr @.str.0, i64 0, i64 0
  %r43 = ptrtoint ptr %r42 to i64
  %t44 = getelementptr i64, ptr %r41, i64 0
  store i64 %r43, ptr %t44, align 8
  %r45 = getelementptr inbounds [2 x i8], ptr @.str.47, i64 0, i64 0
  %r46 = ptrtoint ptr %r45 to i64
  %t47 = getelementptr i64, ptr %r41, i64 1
  store i64 %r46, ptr %t47, align 8
  %t48 = getelementptr i64, ptr %r41, i64 2
  store i64 0, ptr %t48, align 8
  %r49 = call i64 @nova_rt_list_create()
  %t50 = getelementptr i64, ptr %r41, i64 3
  store i64 %r49, ptr %t50, align 8
  %r51 = call i64 @nova_rt_list_create()
  %t52 = getelementptr i64, ptr %r41, i64 4
  store i64 %r51, ptr %t52, align 8
  %r53 = ptrtoint ptr %r41 to i64
  %t54 = getelementptr i64, ptr %r34, i64 2
  store i64 %r53, ptr %t54, align 8
  %r55 = ptrtoint ptr %r34 to i64
  %t56 = call i64 @nova_rt_list_append(i64 %r10, i64 %r55)
  store i64 %r10, ptr %slot.params, align 8
  %r57 = call i64 @nova_rt_list_create()
  %r58 = call ptr @nova_rt_struct_alloc(i64 56)
  %r59 = getelementptr inbounds [7 x i8], ptr @.str.52, i64 0, i64 0
  %r60 = ptrtoint ptr %r59 to i64
  %t61 = getelementptr i64, ptr %r58, i64 0
  store i64 %r60, ptr %t61, align 8
  %r62 = getelementptr inbounds [1 x i8], ptr @.str.1, i64 0, i64 0
  %r63 = ptrtoint ptr %r62 to i64
  %t64 = getelementptr i64, ptr %r58, i64 1
  store i64 %r63, ptr %t64, align 8
  %r65 = call ptr @nova_rt_struct_alloc(i64 40)
  %r66 = getelementptr inbounds [6 x i8], ptr @.str.13, i64 0, i64 0
  %r67 = ptrtoint ptr %r66 to i64
  %t68 = getelementptr i64, ptr %r65, i64 0
  store i64 %r67, ptr %t68, align 8
  %r69 = getelementptr inbounds [2 x i8], ptr @.str.14, i64 0, i64 0
  %r70 = ptrtoint ptr %r69 to i64
  %t71 = getelementptr i64, ptr %r65, i64 1
  store i64 %r70, ptr %t71, align 8
  %t72 = getelementptr i64, ptr %r65, i64 2
  store i64 0, ptr %t72, align 8
  %r73 = call i64 @nova_rt_list_create()
  %r74 = call ptr @nova_rt_struct_alloc(i64 40)
  %r75 = getelementptr inbounds [6 x i8], ptr @.str.11, i64 0, i64 0
  %r76 = ptrtoint ptr %r75 to i64
  %t77 = getelementptr i64, ptr %r74, i64 0
  store i64 %r76, ptr %t77, align 8
  %r78 = getelementptr inbounds [2 x i8], ptr @.str.167, i64 0, i64 0
  %r79 = ptrtoint ptr %r78 to i64
  %t80 = getelementptr i64, ptr %r74, i64 1
  store i64 %r79, ptr %t80, align 8
  %t81 = getelementptr i64, ptr %r74, i64 2
  store i64 0, ptr %t81, align 8
  %r82 = call i64 @nova_rt_list_create()
  %t83 = getelementptr i64, ptr %r74, i64 3
  store i64 %r82, ptr %t83, align 8
  %r84 = call i64 @nova_rt_list_create()
  %t85 = getelementptr i64, ptr %r74, i64 4
  store i64 %r84, ptr %t85, align 8
  %r86 = ptrtoint ptr %r74 to i64
  %t87 = call i64 @nova_rt_list_append(i64 %r73, i64 %r86)
  %r88 = call ptr @nova_rt_struct_alloc(i64 40)
  %r89 = getelementptr inbounds [6 x i8], ptr @.str.11, i64 0, i64 0
  %r90 = ptrtoint ptr %r89 to i64
  %t91 = getelementptr i64, ptr %r88, i64 0
  store i64 %r90, ptr %t91, align 8
  %r92 = getelementptr inbounds [2 x i8], ptr @.str.168, i64 0, i64 0
  %r93 = ptrtoint ptr %r92 to i64
  %t94 = getelementptr i64, ptr %r88, i64 1
  store i64 %r93, ptr %t94, align 8
  %t95 = getelementptr i64, ptr %r88, i64 2
  store i64 0, ptr %t95, align 8
  %r96 = call i64 @nova_rt_list_create()
  %t97 = getelementptr i64, ptr %r88, i64 3
  store i64 %r96, ptr %t97, align 8
  %r98 = call i64 @nova_rt_list_create()
  %t99 = getelementptr i64, ptr %r88, i64 4
  store i64 %r98, ptr %t99, align 8
  %r100 = ptrtoint ptr %r88 to i64
  %t101 = call i64 @nova_rt_list_append(i64 %r73, i64 %r100)
  %t102 = getelementptr i64, ptr %r65, i64 3
  store i64 %r73, ptr %t102, align 8
  %r103 = call i64 @nova_rt_list_create()
  %t104 = getelementptr i64, ptr %r65, i64 4
  store i64 %r103, ptr %t104, align 8
  %r105 = ptrtoint ptr %r65 to i64
  %t106 = getelementptr i64, ptr %r58, i64 2
  store i64 %r105, ptr %t106, align 8
  %r107 = call i64 @nova_rt_list_create()
  %t108 = getelementptr i64, ptr %r58, i64 3
  store i64 %r107, ptr %t108, align 8
  %r109 = call i64 @nova_rt_list_create()
  %t110 = getelementptr i64, ptr %r58, i64 4
  store i64 %r109, ptr %t110, align 8
  %r111 = call i64 @nova_rt_list_create()
  %t112 = getelementptr i64, ptr %r58, i64 5
  store i64 %r111, ptr %t112, align 8
  %r113 = call i64 @nova_rt_list_create()
  %t114 = getelementptr i64, ptr %r58, i64 6
  store i64 %r113, ptr %t114, align 8
  %r115 = ptrtoint ptr %r58 to i64
  %t116 = call i64 @nova_rt_list_append(i64 %r57, i64 %r115)
  store i64 %r57, ptr %slot.body, align 8
  %r117 = call ptr @nova_rt_struct_alloc(i64 56)
  %r118 = getelementptr inbounds [3 x i8], ptr @.str.139, i64 0, i64 0
  %r119 = ptrtoint ptr %r118 to i64
  %t120 = getelementptr i64, ptr %r117, i64 0
  store i64 %r119, ptr %t120, align 8
  %r121 = getelementptr inbounds [4 x i8], ptr @.str.15, i64 0, i64 0
  %r122 = ptrtoint ptr %r121 to i64
  %t123 = getelementptr i64, ptr %r117, i64 1
  store i64 %r122, ptr %t123, align 8
  %r124 = call ptr @nova_rt_struct_alloc(i64 40)
  %r125 = getelementptr inbounds [4 x i8], ptr @.str.0, i64 0, i64 0
  %r126 = ptrtoint ptr %r125 to i64
  %t127 = getelementptr i64, ptr %r124, i64 0
  store i64 %r126, ptr %t127, align 8
  %r128 = getelementptr inbounds [2 x i8], ptr @.str.47, i64 0, i64 0
  %r129 = ptrtoint ptr %r128 to i64
  %t130 = getelementptr i64, ptr %r124, i64 1
  store i64 %r129, ptr %t130, align 8
  %t131 = getelementptr i64, ptr %r124, i64 2
  store i64 0, ptr %t131, align 8
  %r132 = call i64 @nova_rt_list_create()
  %t133 = getelementptr i64, ptr %r124, i64 3
  store i64 %r132, ptr %t133, align 8
  %r134 = call i64 @nova_rt_list_create()
  %t135 = getelementptr i64, ptr %r124, i64 4
  store i64 %r134, ptr %t135, align 8
  %r136 = ptrtoint ptr %r124 to i64
  %t137 = getelementptr i64, ptr %r117, i64 2
  store i64 %r136, ptr %t137, align 8
  %r138 = load i64, ptr %slot.body, align 8
  %t139 = getelementptr i64, ptr %r117, i64 3
  store i64 %r138, ptr %t139, align 8
  %r140 = load i64, ptr %slot.params, align 8
  %t141 = getelementptr i64, ptr %r117, i64 4
  store i64 %r140, ptr %t141, align 8
  %r142 = call i64 @nova_rt_list_create()
  %t143 = getelementptr i64, ptr %r117, i64 5
  store i64 %r142, ptr %t143, align 8
  %r144 = call i64 @nova_rt_list_create()
  %t145 = getelementptr i64, ptr %r117, i64 6
  store i64 %r144, ptr %t145, align 8
  %r146 = ptrtoint ptr %r117 to i64
  store i64 %r146, ptr %slot.fn_stmt, align 8
  %r147 = load i64, ptr %slot.b, align 8
  %r148 = load i64, ptr %slot.fn_stmt, align 8
  %r149 = call i64 @ir_lower_function(i64 %r147, i64 %r148)
  store i64 %r149, ptr %slot.ir_fn, align 8
  %r150 = call i64 @new_emitter()
  store i64 %r150, ptr %slot.e, align 8
  %r151 = load i64, ptr %slot.e, align 8
  %r152 = load i64, ptr %slot.ir_fn, align 8
  %r153 = call i64 @emit_ir_function(i64 %r151, i64 %r152)
  %r154 = load i64, ptr %slot.e, align 8
  %t156 = inttoptr i64 %r154 to ptr
  %t157 = getelementptr i64, ptr %t156, i64 0
  %r155 = load i64, ptr %t157, align 8
  %r158 = call i64 @nova_rt_len_any(i64 %r155)
  %slot.__for_idx_586 = alloca i64, align 8
  store i64 0, ptr %slot.__for_idx_586, align 8
  br label %for_hdr586
for_hdr586:
  %r159 = load i64, ptr %slot.__for_idx_586, align 8
  %t160 = icmp slt i64 %r159, %r158
  br i1 %t160, label %for_body587, label %for_exit588
for_body587:
  %r161 = call i64 @nova_rt_index_get(i64 %r155, i64 %r159)
  store i64 %r161, ptr %slot.line, align 8
  %r162 = load i64, ptr %slot.line, align 8
  %r163 = call i64 @nova_rt_print_any(i64 %r162)
  %r165 = load i64, ptr %slot.__for_idx_586, align 8
  %r164 = add i64 %r165, 1
  store i64 %r164, ptr %slot.__for_idx_586, align 8
  br label %for_hdr586
for_exit588:
  store i64 0, ptr %slot.has_call_add, align 8
  store i64 0, ptr %slot.has_ret, align 8
  %r166 = load i64, ptr %slot.e, align 8
  %t168 = inttoptr i64 %r166 to ptr
  %t169 = getelementptr i64, ptr %t168, i64 0
  %r167 = load i64, ptr %t169, align 8
  %r170 = call i64 @nova_rt_len_any(i64 %r167)
  %slot.__for_idx_589 = alloca i64, align 8
  store i64 0, ptr %slot.__for_idx_589, align 8
  br label %for_hdr589
for_hdr589:
  %r171 = load i64, ptr %slot.__for_idx_589, align 8
  %t172 = icmp slt i64 %r171, %r170
  br i1 %t172, label %for_body590, label %for_exit591
for_body590:
  %r173 = call i64 @nova_rt_index_get(i64 %r167, i64 %r171)
  store i64 %r173, ptr %slot.line, align 8
  %r174 = load i64, ptr %slot.line, align 8
  %r175 = getelementptr inbounds [12 x i8], ptr @.str.169, i64 0, i64 0
  %r176 = ptrtoint ptr %r175 to i64
  %r177 = call i64 @nova_rt_contains(i64 %r174, i64 %r176)
  %t178 = icmp ne i64 %r177, 0
  br i1 %t178, label %then592, label %else593
then592:
  store i64 1, ptr %slot.has_call_add, align 8
  br label %merge594
else593:
  br label %merge594
merge594:
  %r179 = load i64, ptr %slot.line, align 8
  %r180 = getelementptr inbounds [8 x i8], ptr @.str.170, i64 0, i64 0
  %r181 = ptrtoint ptr %r180 to i64
  %r182 = call i64 @nova_rt_contains(i64 %r179, i64 %r181)
  %t183 = icmp ne i64 %r182, 0
  br i1 %t183, label %then595, label %else596
then595:
  store i64 1, ptr %slot.has_ret, align 8
  br label %merge597
else596:
  br label %merge597
merge597:
  %r185 = load i64, ptr %slot.__for_idx_589, align 8
  %r184 = add i64 %r185, 1
  store i64 %r184, ptr %slot.__for_idx_589, align 8
  br label %for_hdr589
for_exit591:
  %r186 = load i64, ptr %slot.has_call_add, align 8
  %r187 = load i64, ptr %slot.has_ret, align 8
  br label %and_entry598
and_entry598:
  %t189 = icmp ne i64 %r186, 0
  br i1 %t189, label %and_rhs599, label %and_end600
and_rhs599:
  %r190 = load i64, ptr %slot.has_ret, align 8
  br label %and_done601
and_done601:
  br label %and_end600
and_end600:
  %r188 = phi i64 [0, %and_entry598], [%r190, %and_done601]
  %t191 = icmp ne i64 %r188, 0
  br i1 %t191, label %then602, label %else603
then602:
  %r192 = getelementptr inbounds [54 x i8], ptr @.str.171, i64 0, i64 0
  %r193 = ptrtoint ptr %r192 to i64
  %r194 = call i64 @nova_rt_print_any(i64 %r193)
  br label %merge604
else603:
  %r195 = getelementptr inbounds [30 x i8], ptr @.str.172, i64 0, i64 0
  %r196 = ptrtoint ptr %r195 to i64
  %r197 = call i64 @nova_rt_print_any(i64 %r196)
  br label %merge604
merge604:
  %r198 = getelementptr inbounds [1 x i8], ptr @.str.1, i64 0, i64 0
  %r199 = ptrtoint ptr %r198 to i64
  %r200 = call i64 @nova_rt_print_any(i64 %r199)
  %r201 = getelementptr inbounds [59 x i8], ptr @.str.173, i64 0, i64 0
  %r202 = ptrtoint ptr %r201 to i64
  %r203 = call i64 @nova_rt_print_any(i64 %r202)
  %r204 = call i64 @new_ir_builder()
  store i64 %r204, ptr %slot.b2, align 8
  %r205 = call i64 @nova_rt_list_create()
  %r206 = load i64, ptr %slot.b2, align 8
  %t207 = inttoptr i64 %r206 to ptr
  %t208 = getelementptr i64, ptr %t207, i64 0
  store i64 %r205, ptr %t208, align 8
  %r209 = call i64 @nova_rt_list_create()
  %r210 = load i64, ptr %slot.b2, align 8
  %t211 = inttoptr i64 %r210 to ptr
  %t212 = getelementptr i64, ptr %t211, i64 2
  store i64 %r209, ptr %t212, align 8
  %r213 = getelementptr inbounds [6 x i8], ptr @.str.5, i64 0, i64 0
  %r214 = ptrtoint ptr %r213 to i64
  %r215 = load i64, ptr %slot.b2, align 8
  %t216 = inttoptr i64 %r215 to ptr
  %t217 = getelementptr i64, ptr %t216, i64 3
  store i64 %r214, ptr %t217, align 8
  %r218 = load i64, ptr %slot.b2, align 8
  %t219 = inttoptr i64 %r218 to ptr
  %t220 = getelementptr i64, ptr %t219, i64 1
  store i64 0, ptr %t220, align 8
  %r221 = load i64, ptr %slot.b2, align 8
  %r222 = getelementptr inbounds [10 x i8], ptr @.str.12, i64 0, i64 0
  %r223 = ptrtoint ptr %r222 to i64
  %r224 = getelementptr inbounds [4 x i8], ptr @.str.174, i64 0, i64 0
  %r225 = ptrtoint ptr %r224 to i64
  %r226 = call i64 @ir_type_int()
  %r227 = call i64 @nova_rt_list_create()
  %r228 = getelementptr inbounds [2 x i8], ptr @.str.167, i64 0, i64 0
  %r229 = ptrtoint ptr %r228 to i64
  %r230 = call i64 @ir_emit(i64 %r221, i64 %r223, i64 %r225, i64 %r226, i64 %r227, i64 %r229, i64 0)
  %r231 = load i64, ptr %slot.b2, align 8
  %r232 = getelementptr inbounds [10 x i8], ptr @.str.12, i64 0, i64 0
  %r233 = ptrtoint ptr %r232 to i64
  %r234 = getelementptr inbounds [4 x i8], ptr @.str.175, i64 0, i64 0
  %r235 = ptrtoint ptr %r234 to i64
  %r236 = call i64 @ir_type_int()
  %r237 = call i64 @nova_rt_list_create()
  %r238 = getelementptr inbounds [2 x i8], ptr @.str.168, i64 0, i64 0
  %r239 = ptrtoint ptr %r238 to i64
  %r240 = call i64 @ir_emit(i64 %r231, i64 %r233, i64 %r235, i64 %r236, i64 %r237, i64 %r239, i64 0)
  %r241 = load i64, ptr %slot.b2, align 8
  %r242 = getelementptr inbounds [4 x i8], ptr @.str.15, i64 0, i64 0
  %r243 = ptrtoint ptr %r242 to i64
  %r244 = getelementptr inbounds [4 x i8], ptr @.str.176, i64 0, i64 0
  %r245 = ptrtoint ptr %r244 to i64
  %r246 = call i64 @ir_type_int()
  %r247 = call i64 @nova_rt_list_create()
  %r248 = getelementptr inbounds [4 x i8], ptr @.str.174, i64 0, i64 0
  %r249 = ptrtoint ptr %r248 to i64
  %t250 = call i64 @nova_rt_list_append(i64 %r247, i64 %r249)
  %r251 = getelementptr inbounds [4 x i8], ptr @.str.175, i64 0, i64 0
  %r252 = ptrtoint ptr %r251 to i64
  %t253 = call i64 @nova_rt_list_append(i64 %r247, i64 %r252)
  %r254 = getelementptr inbounds [2 x i8], ptr @.str.14, i64 0, i64 0
  %r255 = ptrtoint ptr %r254 to i64
  %r256 = call i64 @ir_emit(i64 %r241, i64 %r243, i64 %r245, i64 %r246, i64 %r247, i64 %r255, i64 0)
  %r257 = load i64, ptr %slot.b2, align 8
  %r258 = call ptr @nova_rt_struct_alloc(i64 56)
  %r259 = getelementptr inbounds [7 x i8], ptr @.str.52, i64 0, i64 0
  %r260 = ptrtoint ptr %r259 to i64
  %t261 = getelementptr i64, ptr %r258, i64 0
  store i64 %r260, ptr %t261, align 8
  %r262 = getelementptr inbounds [1 x i8], ptr @.str.1, i64 0, i64 0
  %r263 = ptrtoint ptr %r262 to i64
  %t264 = getelementptr i64, ptr %r258, i64 1
  store i64 %r263, ptr %t264, align 8
  %r265 = call i64 @ir_type_void()
  %t266 = getelementptr i64, ptr %r258, i64 2
  store i64 %r265, ptr %t266, align 8
  %r267 = call i64 @nova_rt_list_create()
  %r268 = getelementptr inbounds [4 x i8], ptr @.str.176, i64 0, i64 0
  %r269 = ptrtoint ptr %r268 to i64
  %t270 = call i64 @nova_rt_list_append(i64 %r267, i64 %r269)
  %t271 = getelementptr i64, ptr %r258, i64 3
  store i64 %r267, ptr %t271, align 8
  %r272 = getelementptr inbounds [1 x i8], ptr @.str.1, i64 0, i64 0
  %r273 = ptrtoint ptr %r272 to i64
  %t274 = getelementptr i64, ptr %r258, i64 4
  store i64 %r273, ptr %t274, align 8
  %t275 = getelementptr i64, ptr %r258, i64 5
  store i64 0, ptr %t275, align 8
  %r276 = getelementptr inbounds [5 x i8], ptr @.str.7, i64 0, i64 0
  %r277 = ptrtoint ptr %r276 to i64
  %t278 = getelementptr i64, ptr %r258, i64 6
  store i64 %r277, ptr %t278, align 8
  %r279 = ptrtoint ptr %r258 to i64
  %r280 = call i64 @ir_finish_block(i64 %r257, i64 %r279)
  %r281 = call ptr @nova_rt_struct_alloc(i64 48)
  %r282 = getelementptr inbounds [8 x i8], ptr @.str.177, i64 0, i64 0
  %r283 = ptrtoint ptr %r282 to i64
  %t284 = getelementptr i64, ptr %r281, i64 0
  store i64 %r283, ptr %t284, align 8
  %r285 = call i64 @nova_rt_list_create()
  %r286 = call ptr @nova_rt_struct_alloc(i64 16)
  %r287 = getelementptr inbounds [2 x i8], ptr @.str.167, i64 0, i64 0
  %r288 = ptrtoint ptr %r287 to i64
  %t289 = getelementptr i64, ptr %r286, i64 0
  store i64 %r288, ptr %t289, align 8
  %r290 = call i64 @ir_type_int()
  %t291 = getelementptr i64, ptr %r286, i64 1
  store i64 %r290, ptr %t291, align 8
  %r292 = ptrtoint ptr %r286 to i64
  %t293 = call i64 @nova_rt_list_append(i64 %r285, i64 %r292)
  %r294 = call ptr @nova_rt_struct_alloc(i64 16)
  %r295 = getelementptr inbounds [2 x i8], ptr @.str.168, i64 0, i64 0
  %r296 = ptrtoint ptr %r295 to i64
  %t297 = getelementptr i64, ptr %r294, i64 0
  store i64 %r296, ptr %t297, align 8
  %r298 = call i64 @ir_type_int()
  %t299 = getelementptr i64, ptr %r294, i64 1
  store i64 %r298, ptr %t299, align 8
  %r300 = ptrtoint ptr %r294 to i64
  %t301 = call i64 @nova_rt_list_append(i64 %r285, i64 %r300)
  %t302 = getelementptr i64, ptr %r281, i64 1
  store i64 %r285, ptr %t302, align 8
  %r303 = call i64 @ir_type_int()
  %t304 = getelementptr i64, ptr %r281, i64 2
  store i64 %r303, ptr %t304, align 8
  %r305 = load i64, ptr %slot.b2, align 8
  %t307 = inttoptr i64 %r305 to ptr
  %t308 = getelementptr i64, ptr %t307, i64 2
  %r306 = load i64, ptr %t308, align 8
  %t309 = getelementptr i64, ptr %r281, i64 3
  store i64 %r306, ptr %t309, align 8
  %r310 = call i64 @nova_rt_list_create()
  %t311 = getelementptr i64, ptr %r281, i64 4
  store i64 %r310, ptr %t311, align 8
  %t312 = getelementptr i64, ptr %r281, i64 5
  store i64 0, ptr %t312, align 8
  %r313 = ptrtoint ptr %r281 to i64
  store i64 %r313, ptr %slot.typed_fn, align 8
  %r314 = call i64 @new_emitter()
  store i64 %r314, ptr %slot.e2, align 8
  %r315 = load i64, ptr %slot.e2, align 8
  %r316 = load i64, ptr %slot.typed_fn, align 8
  %r317 = call i64 @emit_ir_function(i64 %r315, i64 %r316)
  %r318 = load i64, ptr %slot.e2, align 8
  %t320 = inttoptr i64 %r318 to ptr
  %t321 = getelementptr i64, ptr %t320, i64 0
  %r319 = load i64, ptr %t321, align 8
  %r322 = call i64 @nova_rt_len_any(i64 %r319)
  %slot.__for_idx_605 = alloca i64, align 8
  store i64 0, ptr %slot.__for_idx_605, align 8
  br label %for_hdr605
for_hdr605:
  %r323 = load i64, ptr %slot.__for_idx_605, align 8
  %t324 = icmp slt i64 %r323, %r322
  br i1 %t324, label %for_body606, label %for_exit607
for_body606:
  %r325 = call i64 @nova_rt_index_get(i64 %r319, i64 %r323)
  store i64 %r325, ptr %slot.line, align 8
  %r326 = load i64, ptr %slot.line, align 8
  %r327 = call i64 @nova_rt_print_any(i64 %r326)
  %r329 = load i64, ptr %slot.__for_idx_605, align 8
  %r328 = add i64 %r329, 1
  store i64 %r328, ptr %slot.__for_idx_605, align 8
  br label %for_hdr605
for_exit607:
  store i64 0, ptr %slot.has_direct_add, align 8
  store i64 1, ptr %slot.has_no_rt_call, align 8
  %r330 = load i64, ptr %slot.e2, align 8
  %t332 = inttoptr i64 %r330 to ptr
  %t333 = getelementptr i64, ptr %t332, i64 0
  %r331 = load i64, ptr %t333, align 8
  %r334 = call i64 @nova_rt_len_any(i64 %r331)
  %slot.__for_idx_608 = alloca i64, align 8
  store i64 0, ptr %slot.__for_idx_608, align 8
  br label %for_hdr608
for_hdr608:
  %r335 = load i64, ptr %slot.__for_idx_608, align 8
  %t336 = icmp slt i64 %r335, %r334
  br i1 %t336, label %for_body609, label %for_exit610
for_body609:
  %r337 = call i64 @nova_rt_index_get(i64 %r331, i64 %r335)
  store i64 %r337, ptr %slot.line, align 8
  %r338 = load i64, ptr %slot.line, align 8
  %r339 = getelementptr inbounds [17 x i8], ptr @.str.178, i64 0, i64 0
  %r340 = ptrtoint ptr %r339 to i64
  %r341 = call i64 @nova_rt_contains(i64 %r338, i64 %r340)
  %t342 = icmp ne i64 %r341, 0
  br i1 %t342, label %then611, label %else612
then611:
  store i64 1, ptr %slot.has_direct_add, align 8
  br label %merge613
else612:
  br label %merge613
merge613:
  %r343 = load i64, ptr %slot.line, align 8
  %r344 = getelementptr inbounds [12 x i8], ptr @.str.169, i64 0, i64 0
  %r345 = ptrtoint ptr %r344 to i64
  %r346 = call i64 @nova_rt_contains(i64 %r343, i64 %r345)
  %t347 = icmp ne i64 %r346, 0
  br i1 %t347, label %then614, label %else615
then614:
  store i64 0, ptr %slot.has_no_rt_call, align 8
  br label %merge616
else615:
  br label %merge616
merge616:
  %r349 = load i64, ptr %slot.__for_idx_608, align 8
  %r348 = add i64 %r349, 1
  store i64 %r348, ptr %slot.__for_idx_608, align 8
  br label %for_hdr608
for_exit610:
  %r350 = load i64, ptr %slot.has_direct_add, align 8
  %r351 = load i64, ptr %slot.has_no_rt_call, align 8
  br label %and_entry617
and_entry617:
  %t353 = icmp ne i64 %r350, 0
  br i1 %t353, label %and_rhs618, label %and_end619
and_rhs618:
  %r354 = load i64, ptr %slot.has_no_rt_call, align 8
  br label %and_done620
and_done620:
  br label %and_end619
and_end619:
  %r352 = phi i64 [0, %and_entry617], [%r354, %and_done620]
  %t355 = icmp ne i64 %r352, 0
  br i1 %t355, label %then621, label %else622
then621:
  %r356 = getelementptr inbounds [57 x i8], ptr @.str.179, i64 0, i64 0
  %r357 = ptrtoint ptr %r356 to i64
  %r358 = call i64 @nova_rt_print_any(i64 %r357)
  br label %merge623
else622:
  %r359 = getelementptr inbounds [55 x i8], ptr @.str.180, i64 0, i64 0
  %r360 = ptrtoint ptr %r359 to i64
  %r361 = call i64 @nova_rt_print_any(i64 %r360)
  br label %merge623
merge623:
  %r362 = getelementptr inbounds [1 x i8], ptr @.str.1, i64 0, i64 0
  %r363 = ptrtoint ptr %r362 to i64
  %r364 = call i64 @nova_rt_print_any(i64 %r363)
  %r365 = getelementptr inbounds [65 x i8], ptr @.str.181, i64 0, i64 0
  %r366 = ptrtoint ptr %r365 to i64
  %r367 = call i64 @nova_rt_print_any(i64 %r366)
  %r368 = getelementptr inbounds [31 x i8], ptr @.str.182, i64 0, i64 0
  %r369 = ptrtoint ptr %r368 to i64
  store i64 %r369, ptr %slot.source, align 8
  %r370 = load i64, ptr %slot.source, align 8
  %r371 = call i64 @tokenize_mini(i64 %r370)
  store i64 %r371, ptr %slot.tokens, align 8
  store i64 0, ptr %slot.pos, align 8
  br label %while_hdr624
while_hdr624:
  %r372 = load i64, ptr %slot.pos, align 8
  %r373 = load i64, ptr %slot.tokens, align 8
  %r374 = call i64 @nova_rt_len_any(i64 %r373)
  %t376 = icmp slt i64 %r372, %r374
  %r375 = zext i1 %t376 to i64
  %t377 = icmp ne i64 %r375, 0
  br i1 %t377, label %while_body625, label %while_exit626
while_body625:
  %r378 = load i64, ptr %slot.tokens, align 8
  %r379 = load i64, ptr %slot.pos, align 8
  %r380 = call i64 @nova_rt_index_get(i64 %r378, i64 %r379)
  %t381 = inttoptr i64 %r380 to ptr
  %t382 = getelementptr i64, ptr %t381, i64 0
  %r383 = load i64, ptr %t382, align 8
  store i64 %r383, ptr %slot.k, align 8
  %t384 = getelementptr i64, ptr %t381, i64 1
  %r385 = load i64, ptr %t384, align 8
  store i64 %r385, ptr %slot.v, align 8
  %t386 = getelementptr i64, ptr %t381, i64 2
  %r387 = load i64, ptr %t386, align 8
  store i64 %r387, ptr %slot.l, align 8
  %t388 = getelementptr i64, ptr %t381, i64 3
  %r389 = load i64, ptr %t388, align 8
  store i64 %r389, ptr %slot.c, align 8
  %r390 = load i64, ptr %slot.k, align 8
  %r391 = getelementptr inbounds [3 x i8], ptr @.str.149, i64 0, i64 0
  %r392 = ptrtoint ptr %r391 to i64
  %t394 = call i64 @nova_rt_eq(i64 %r390, i64 %r392)
  %r393 = and i64 %t394, 1
  %r395 = load i64, ptr %slot.v, align 8
  %r396 = getelementptr inbounds [3 x i8], ptr @.str.139, i64 0, i64 0
  %r397 = ptrtoint ptr %r396 to i64
  %t399 = call i64 @nova_rt_eq(i64 %r395, i64 %r397)
  %r398 = and i64 %t399, 1
  br label %and_entry627
and_entry627:
  %t401 = icmp ne i64 %t394, 0
  br i1 %t401, label %and_rhs628, label %and_end629
and_rhs628:
  %r402 = load i64, ptr %slot.v, align 8
  %r403 = getelementptr inbounds [3 x i8], ptr @.str.139, i64 0, i64 0
  %r404 = ptrtoint ptr %r403 to i64
  %t406 = call i64 @nova_rt_eq(i64 %r402, i64 %r404)
  %r405 = and i64 %t406, 1
  br label %and_done630
and_done630:
  br label %and_end629
and_end629:
  %r400 = phi i64 [0, %and_entry627], [%t406, %and_done630]
  %t407 = icmp ne i64 %r400, 0
  br i1 %t407, label %then631, label %else632
then631:
  %r408 = load i64, ptr %slot.tokens, align 8
  %r409 = load i64, ptr %slot.pos, align 8
  %r410 = call i64 @parse_fn_mini(i64 %r408, i64 %r409)
  store i64 %r410, ptr %slot.sr, align 8
  %r411 = call i64 @new_ir_builder()
  store i64 %r411, ptr %slot.b3, align 8
  %r412 = load i64, ptr %slot.b3, align 8
  %r413 = load i64, ptr %slot.sr, align 8
  %t415 = inttoptr i64 %r413 to ptr
  %t416 = getelementptr i64, ptr %t415, i64 0
  %r414 = load i64, ptr %t416, align 8
  %r417 = call i64 @ir_lower_function(i64 %r412, i64 %r414)
  store i64 %r417, ptr %slot.ir_fn3, align 8
  %r418 = call i64 @new_emitter()
  store i64 %r418, ptr %slot.e3, align 8
  %r419 = load i64, ptr %slot.e3, align 8
  %r420 = load i64, ptr %slot.ir_fn3, align 8
  %r421 = call i64 @emit_ir_function(i64 %r419, i64 %r420)
  %r422 = load i64, ptr %slot.e3, align 8
  %t424 = inttoptr i64 %r422 to ptr
  %t425 = getelementptr i64, ptr %t424, i64 0
  %r423 = load i64, ptr %t425, align 8
  %r426 = call i64 @nova_rt_len_any(i64 %r423)
  %slot.__for_idx_634 = alloca i64, align 8
  store i64 0, ptr %slot.__for_idx_634, align 8
  br label %for_hdr634
for_hdr634:
  %r427 = load i64, ptr %slot.__for_idx_634, align 8
  %t428 = icmp slt i64 %r427, %r426
  br i1 %t428, label %for_body635, label %for_exit636
for_body635:
  %r429 = call i64 @nova_rt_index_get(i64 %r423, i64 %r427)
  store i64 %r429, ptr %slot.line, align 8
  %r430 = load i64, ptr %slot.line, align 8
  %r431 = call i64 @nova_rt_print_any(i64 %r430)
  %r433 = load i64, ptr %slot.__for_idx_634, align 8
  %r432 = add i64 %r433, 1
  store i64 %r432, ptr %slot.__for_idx_634, align 8
  br label %for_hdr634
for_exit636:
  store i64 0, ptr %slot.has_define, align 8
  store i64 0, ptr %slot.has_entry, align 8
  %r434 = load i64, ptr %slot.e3, align 8
  %t436 = inttoptr i64 %r434 to ptr
  %t437 = getelementptr i64, ptr %t436, i64 0
  %r435 = load i64, ptr %t437, align 8
  %r438 = call i64 @nova_rt_len_any(i64 %r435)
  %slot.__for_idx_637 = alloca i64, align 8
  store i64 0, ptr %slot.__for_idx_637, align 8
  br label %for_hdr637
for_hdr637:
  %r439 = load i64, ptr %slot.__for_idx_637, align 8
  %t440 = icmp slt i64 %r439, %r438
  br i1 %t440, label %for_body638, label %for_exit639
for_body638:
  %r441 = call i64 @nova_rt_index_get(i64 %r435, i64 %r439)
  store i64 %r441, ptr %slot.line, align 8
  %r442 = load i64, ptr %slot.line, align 8
  %r443 = getelementptr inbounds [19 x i8], ptr @.str.183, i64 0, i64 0
  %r444 = ptrtoint ptr %r443 to i64
  %r445 = call i64 @nova_rt_contains(i64 %r442, i64 %r444)
  %t446 = icmp ne i64 %r445, 0
  br i1 %t446, label %then640, label %else641
then640:
  store i64 1, ptr %slot.has_define, align 8
  br label %merge642
else641:
  br label %merge642
merge642:
  %r447 = load i64, ptr %slot.line, align 8
  %r448 = getelementptr inbounds [7 x i8], ptr @.str.184, i64 0, i64 0
  %r449 = ptrtoint ptr %r448 to i64
  %r450 = call i64 @nova_rt_contains(i64 %r447, i64 %r449)
  %t451 = icmp ne i64 %r450, 0
  br i1 %t451, label %then643, label %else644
then643:
  store i64 1, ptr %slot.has_entry, align 8
  br label %merge645
else644:
  br label %merge645
merge645:
  %r453 = load i64, ptr %slot.__for_idx_637, align 8
  %r452 = add i64 %r453, 1
  store i64 %r452, ptr %slot.__for_idx_637, align 8
  br label %for_hdr637
for_exit639:
  %r454 = load i64, ptr %slot.has_define, align 8
  %r455 = load i64, ptr %slot.has_entry, align 8
  br label %and_entry646
and_entry646:
  %t457 = icmp ne i64 %r454, 0
  br i1 %t457, label %and_rhs647, label %and_end648
and_rhs647:
  %r458 = load i64, ptr %slot.has_entry, align 8
  br label %and_done649
and_done649:
  br label %and_end648
and_end648:
  %r456 = phi i64 [0, %and_entry646], [%r458, %and_done649]
  %t459 = icmp ne i64 %r456, 0
  br i1 %t459, label %then650, label %else651
then650:
  %r460 = getelementptr inbounds [49 x i8], ptr @.str.185, i64 0, i64 0
  %r461 = ptrtoint ptr %r460 to i64
  %r462 = call i64 @nova_rt_print_any(i64 %r461)
  br label %merge652
else651:
  %r463 = getelementptr inbounds [32 x i8], ptr @.str.186, i64 0, i64 0
  %r464 = ptrtoint ptr %r463 to i64
  %r465 = call i64 @nova_rt_print_any(i64 %r464)
  br label %merge652
merge652:
  %r466 = load i64, ptr %slot.tokens, align 8
  %r467 = call i64 @nova_rt_len_any(i64 %r466)
  store i64 %r467, ptr %slot.pos, align 8
  br label %merge633
else632:
  %r468 = load i64, ptr %slot.pos, align 8
  %r469 = call i64 @nova_rt_add(i64 %r468, i64 1)
  store i64 %r469, ptr %slot.pos, align 8
  br label %merge633
merge633:
  %r470 = load i64, ptr %slot.pos, align 8
  %r471 = call i64 @nova_rt_add(i64 %r470, i64 1)
  store i64 %r471, ptr %slot.pos, align 8
  br label %while_hdr624
while_exit626:
  %r472 = getelementptr inbounds [1 x i8], ptr @.str.1, i64 0, i64 0
  %r473 = ptrtoint ptr %r472 to i64
  %r474 = call i64 @nova_rt_print_any(i64 %r473)
  %r475 = getelementptr inbounds [42 x i8], ptr @.str.187, i64 0, i64 0
  %r476 = ptrtoint ptr %r475 to i64
  %r477 = call i64 @nova_rt_print_any(i64 %r476)
  ret i64 %r477
}

define i64 @nova_main() nounwind {
entry:
  %r0 = call i64 @test_pipeline()
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
@.str.0 = private unnamed_addr constant [4 x i8] c"int\00"
@.str.1 = private unnamed_addr constant [1 x i8] c"\00"
@.str.2 = private unnamed_addr constant [4 x i8] c"str\00"
@.str.3 = private unnamed_addr constant [4 x i8] c"any\00"
@.str.4 = private unnamed_addr constant [5 x i8] c"void\00"
@.str.5 = private unnamed_addr constant [6 x i8] c"entry\00"
@.str.6 = private unnamed_addr constant [3 x i8] c"%r\00"
@.str.7 = private unnamed_addr constant [5 x i8] c"pure\00"
@.str.8 = private unnamed_addr constant [12 x i8] c"side_effect\00"
@.str.9 = private unnamed_addr constant [10 x i8] c"const_int\00"
@.str.10 = private unnamed_addr constant [10 x i8] c"const_str\00"
@.str.11 = private unnamed_addr constant [6 x i8] c"ident\00"
@.str.12 = private unnamed_addr constant [10 x i8] c"slot_load\00"
@.str.13 = private unnamed_addr constant [6 x i8] c"binop\00"
@.str.14 = private unnamed_addr constant [2 x i8] c"+\00"
@.str.15 = private unnamed_addr constant [4 x i8] c"add\00"
@.str.16 = private unnamed_addr constant [2 x i8] c"-\00"
@.str.17 = private unnamed_addr constant [4 x i8] c"sub\00"
@.str.18 = private unnamed_addr constant [2 x i8] c"*\00"
@.str.19 = private unnamed_addr constant [4 x i8] c"mul\00"
@.str.20 = private unnamed_addr constant [2 x i8] c"/\00"
@.str.21 = private unnamed_addr constant [4 x i8] c"div\00"
@.str.22 = private unnamed_addr constant [2 x i8] c"%\00"
@.str.23 = private unnamed_addr constant [4 x i8] c"mod\00"
@.str.24 = private unnamed_addr constant [3 x i8] c"==\00"
@.str.25 = private unnamed_addr constant [3 x i8] c"eq\00"
@.str.26 = private unnamed_addr constant [3 x i8] c"!=\00"
@.str.27 = private unnamed_addr constant [4 x i8] c"neq\00"
@.str.28 = private unnamed_addr constant [2 x i8] c"<\00"
@.str.29 = private unnamed_addr constant [3 x i8] c"lt\00"
@.str.30 = private unnamed_addr constant [3 x i8] c"<=\00"
@.str.31 = private unnamed_addr constant [3 x i8] c"le\00"
@.str.32 = private unnamed_addr constant [2 x i8] c">\00"
@.str.33 = private unnamed_addr constant [3 x i8] c"gt\00"
@.str.34 = private unnamed_addr constant [3 x i8] c">=\00"
@.str.35 = private unnamed_addr constant [3 x i8] c"ge\00"
@.str.36 = private unnamed_addr constant [5 x i8] c"call\00"
@.str.37 = private unnamed_addr constant [14 x i8] c"nova_rt_binop\00"
@.str.38 = private unnamed_addr constant [6 x i8] c"unary\00"
@.str.39 = private unnamed_addr constant [4 x i8] c"neg\00"
@.str.40 = private unnamed_addr constant [4 x i8] c"not\00"
@.str.41 = private unnamed_addr constant [5 x i8] c"list\00"
@.str.42 = private unnamed_addr constant [10 x i8] c"make_list\00"
@.str.43 = private unnamed_addr constant [6 x i8] c"index\00"
@.str.44 = private unnamed_addr constant [10 x i8] c"index_get\00"
@.str.45 = private unnamed_addr constant [6 x i8] c"field\00"
@.str.46 = private unnamed_addr constant [10 x i8] c"field_get\00"
@.str.47 = private unnamed_addr constant [2 x i8] c"0\00"
@.str.48 = private unnamed_addr constant [5 x i8] c"expr\00"
@.str.49 = private unnamed_addr constant [4 x i8] c"let\00"
@.str.50 = private unnamed_addr constant [7 x i8] c"assign\00"
@.str.51 = private unnamed_addr constant [11 x i8] c"slot_store\00"
@.str.52 = private unnamed_addr constant [7 x i8] c"return\00"
@.str.53 = private unnamed_addr constant [6 x i8] c"print\00"
@.str.54 = private unnamed_addr constant [18 x i8] c"nova_rt_print_any\00"
@.str.55 = private unnamed_addr constant [3 x i8] c"  \00"
@.str.56 = private unnamed_addr constant [2 x i8] c"\0A\00"
@.str.57 = private unnamed_addr constant [4 x i8] c"\\0A\00"
@.str.58 = private unnamed_addr constant [2 x i8] c"\0D\00"
@.str.59 = private unnamed_addr constant [4 x i8] c"\\0D\00"
@.str.60 = private unnamed_addr constant [2 x i8] c"\09\00"
@.str.61 = private unnamed_addr constant [4 x i8] c"\\09\00"
@.str.62 = private unnamed_addr constant [4 x i8] c"\\00\00"
@.str.63 = private unnamed_addr constant [2 x i8] c"\\\00"
@.str.64 = private unnamed_addr constant [3 x i8] c"\\\\\00"
@.str.65 = private unnamed_addr constant [2 x i8] c"\22\00"
@.str.66 = private unnamed_addr constant [4 x i8] c"\\22\00"
@.str.67 = private unnamed_addr constant [7 x i8] c"@.str.\00"
@.str.68 = private unnamed_addr constant [35 x i8] c" = private unnamed_addr constant [\00"
@.str.69 = private unnamed_addr constant [10 x i8] c" x i8] c\22\00"
@.str.70 = private unnamed_addr constant [5 x i8] c"\\00\22\00"
@.str.71 = private unnamed_addr constant [12 x i8] c" = add i64 \00"
@.str.72 = private unnamed_addr constant [4 x i8] c", 0\00"
@.str.73 = private unnamed_addr constant [3 x i8] c".p\00"
@.str.74 = private unnamed_addr constant [28 x i8] c" = getelementptr inbounds [\00"
@.str.75 = private unnamed_addr constant [13 x i8] c" x i8], ptr \00"
@.str.76 = private unnamed_addr constant [15 x i8] c", i64 0, i64 0\00"
@.str.77 = private unnamed_addr constant [40 x i8] c" = call i64 @nova_rt_create_string(ptr \00"
@.str.78 = private unnamed_addr constant [2 x i8] c")\00"
@.str.79 = private unnamed_addr constant [3 x i8] c", \00"
@.str.80 = private unnamed_addr constant [37 x i8] c" = call i64 @nova_rt_str_concat(i64 \00"
@.str.81 = private unnamed_addr constant [7 x i8] c", i64 \00"
@.str.82 = private unnamed_addr constant [30 x i8] c" = call i64 @nova_rt_add(i64 \00"
@.str.83 = private unnamed_addr constant [12 x i8] c" = sub i64 \00"
@.str.84 = private unnamed_addr constant [30 x i8] c" = call i64 @nova_rt_sub(i64 \00"
@.str.85 = private unnamed_addr constant [12 x i8] c" = mul i64 \00"
@.str.86 = private unnamed_addr constant [30 x i8] c" = call i64 @nova_rt_mul(i64 \00"
@.str.87 = private unnamed_addr constant [13 x i8] c" = sdiv i64 \00"
@.str.88 = private unnamed_addr constant [30 x i8] c" = call i64 @nova_rt_div(i64 \00"
@.str.89 = private unnamed_addr constant [13 x i8] c" = srem i64 \00"
@.str.90 = private unnamed_addr constant [15 x i8] c" = sub i64 0, \00"
@.str.91 = private unnamed_addr constant [5 x i8] c".cmp\00"
@.str.92 = private unnamed_addr constant [16 x i8] c" = icmp eq i64 \00"
@.str.93 = private unnamed_addr constant [12 x i8] c" = zext i1 \00"
@.str.94 = private unnamed_addr constant [8 x i8] c" to i64\00"
@.str.95 = private unnamed_addr constant [16 x i8] c" = icmp ne i64 \00"
@.str.96 = private unnamed_addr constant [17 x i8] c" = icmp slt i64 \00"
@.str.97 = private unnamed_addr constant [17 x i8] c" = icmp sle i64 \00"
@.str.98 = private unnamed_addr constant [17 x i8] c" = icmp sgt i64 \00"
@.str.99 = private unnamed_addr constant [17 x i8] c" = icmp sge i64 \00"
@.str.100 = private unnamed_addr constant [24 x i8] c" = load i64, ptr %slot.\00"
@.str.101 = private unnamed_addr constant [10 x i8] c", align 8\00"
@.str.102 = private unnamed_addr constant [11 x i8] c"store i64 \00"
@.str.103 = private unnamed_addr constant [13 x i8] c", ptr %slot.\00"
@.str.104 = private unnamed_addr constant [11 x i8] c"call i64 @\00"
@.str.105 = private unnamed_addr constant [2 x i8] c"(\00"
@.str.106 = private unnamed_addr constant [5 x i8] c"i64 \00"
@.str.107 = private unnamed_addr constant [4 x i8] c" = \00"
@.str.108 = private unnamed_addr constant [35 x i8] c" = call i64 @nova_rt_list_create()\00"
@.str.109 = private unnamed_addr constant [35 x i8] c"call i64 @nova_rt_list_append(i64 \00"
@.str.110 = private unnamed_addr constant [36 x i8] c" = call i64 @nova_rt_index_get(i64 \00"
@.str.111 = private unnamed_addr constant [36 x i8] c" = call i64 @nova_rt_field_get(i64 \00"
@.str.112 = private unnamed_addr constant [9 x i8] c"ret i64 \00"
@.str.113 = private unnamed_addr constant [10 x i8] c"ret i64 0\00"
@.str.114 = private unnamed_addr constant [5 x i8] c"goto\00"
@.str.115 = private unnamed_addr constant [11 x i8] c"br label %\00"
@.str.116 = private unnamed_addr constant [7 x i8] c"branch\00"
@.str.117 = private unnamed_addr constant [4 x i8] c".br\00"
@.str.118 = private unnamed_addr constant [7 x i8] c"br i1 \00"
@.str.119 = private unnamed_addr constant [10 x i8] c", label %\00"
@.str.120 = private unnamed_addr constant [14 x i8] c"declare i64 @\00"
@.str.121 = private unnamed_addr constant [4 x i8] c"i64\00"
@.str.122 = private unnamed_addr constant [11 x i8] c") nounwind\00"
@.str.123 = private unnamed_addr constant [13 x i8] c"define i64 @\00"
@.str.124 = private unnamed_addr constant [7 x i8] c"i64 %p\00"
@.str.125 = private unnamed_addr constant [13 x i8] c") nounwind {\00"
@.str.126 = private unnamed_addr constant [2 x i8] c":\00"
@.str.127 = private unnamed_addr constant [7 x i8] c"%slot.\00"
@.str.128 = private unnamed_addr constant [23 x i8] c" = alloca i64, align 8\00"
@.str.129 = private unnamed_addr constant [13 x i8] c"store i64 %p\00"
@.str.130 = private unnamed_addr constant [2 x i8] c"}\00"
@.str.131 = private unnamed_addr constant [2 x i8] c"_\00"
@.str.132 = private unnamed_addr constant [2 x i8] c" \00"
@.str.133 = private unnamed_addr constant [8 x i8] c"NEWLINE\00"
@.str.134 = private unnamed_addr constant [2 x i8] c"#\00"
@.str.135 = private unnamed_addr constant [4 x i8] c"INT\00"
@.str.136 = private unnamed_addr constant [2 x i8] c"n\00"
@.str.137 = private unnamed_addr constant [2 x i8] c"t\00"
@.str.138 = private unnamed_addr constant [4 x i8] c"STR\00"
@.str.139 = private unnamed_addr constant [3 x i8] c"fn\00"
@.str.140 = private unnamed_addr constant [3 x i8] c"if\00"
@.str.141 = private unnamed_addr constant [5 x i8] c"else\00"
@.str.142 = private unnamed_addr constant [6 x i8] c"while\00"
@.str.143 = private unnamed_addr constant [4 x i8] c"for\00"
@.str.144 = private unnamed_addr constant [3 x i8] c"in\00"
@.str.145 = private unnamed_addr constant [4 x i8] c"and\00"
@.str.146 = private unnamed_addr constant [3 x i8] c"or\00"
@.str.147 = private unnamed_addr constant [5 x i8] c"true\00"
@.str.148 = private unnamed_addr constant [6 x i8] c"false\00"
@.str.149 = private unnamed_addr constant [3 x i8] c"KW\00"
@.str.150 = private unnamed_addr constant [6 x i8] c"IDENT\00"
@.str.151 = private unnamed_addr constant [3 x i8] c"OP\00"
@.str.152 = private unnamed_addr constant [2 x i8] c"=\00"
@.str.153 = private unnamed_addr constant [2 x i8] c"!\00"
@.str.154 = private unnamed_addr constant [7 x i8] c"ASSIGN\00"
@.str.155 = private unnamed_addr constant [7 x i8] c"LPAREN\00"
@.str.156 = private unnamed_addr constant [7 x i8] c"RPAREN\00"
@.str.157 = private unnamed_addr constant [2 x i8] c",\00"
@.str.158 = private unnamed_addr constant [6 x i8] c"COMMA\00"
@.str.159 = private unnamed_addr constant [6 x i8] c"COLON\00"
@.str.160 = private unnamed_addr constant [2 x i8] c"[\00"
@.str.161 = private unnamed_addr constant [9 x i8] c"LBRACKET\00"
@.str.162 = private unnamed_addr constant [2 x i8] c"]\00"
@.str.163 = private unnamed_addr constant [9 x i8] c"RBRACKET\00"
@.str.164 = private unnamed_addr constant [4 x i8] c"EOF\00"
@.str.165 = private unnamed_addr constant [28 x i8] c"=== IR Integration Test ===\00"
@.str.166 = private unnamed_addr constant [30 x i8] c"Test 1: fn add(a, b) -> a + b\00"
@.str.167 = private unnamed_addr constant [2 x i8] c"a\00"
@.str.168 = private unnamed_addr constant [2 x i8] c"b\00"
@.str.169 = private unnamed_addr constant [12 x i8] c"nova_rt_add\00"
@.str.170 = private unnamed_addr constant [8 x i8] c"ret i64\00"
@.str.171 = private unnamed_addr constant [54 x i8] c"PASS: Generic add generates runtime call (type = any)\00"
@.str.172 = private unnamed_addr constant [30 x i8] c"FAIL: Missing expected output\00"
@.str.173 = private unnamed_addr constant [59 x i8] c"Test 2: Manually typed int add (simulating type inference)\00"
@.str.174 = private unnamed_addr constant [4 x i8] c"%r0\00"
@.str.175 = private unnamed_addr constant [4 x i8] c"%r1\00"
@.str.176 = private unnamed_addr constant [4 x i8] c"%r2\00"
@.str.177 = private unnamed_addr constant [8 x i8] c"add_int\00"
@.str.178 = private unnamed_addr constant [17 x i8] c"add i64 %r0, %r1\00"
@.str.179 = private unnamed_addr constant [57 x i8] c"PASS: Typed int add → direct 'add i64' (ZERO overhead)\00"
@.str.180 = private unnamed_addr constant [55 x i8] c"FAIL: Type-directed emission didn't produce direct add\00"
@.str.181 = private unnamed_addr constant [65 x i8] c"Test 3: Full pipeline - source → lex → parse → IR → LLVM\00"
@.str.182 = private unnamed_addr constant [31 x i8] c"fn double(x)\0A    return x + x\0A\00"
@.str.183 = private unnamed_addr constant [19 x i8] c"define i64 @double\00"
@.str.184 = private unnamed_addr constant [7 x i8] c"entry:\00"
@.str.185 = private unnamed_addr constant [49 x i8] c"PASS: Full pipeline produced valid LLVM function\00"
@.str.186 = private unnamed_addr constant [32 x i8] c"FAIL: Pipeline output malformed\00"
@.str.187 = private unnamed_addr constant [42 x i8] c"=== All IR Integration Tests Complete ===\00"
