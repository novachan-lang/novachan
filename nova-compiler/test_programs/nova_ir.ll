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

define i64 @ir_type_float() nounwind {
entry:
  %r0 = call ptr @nova_rt_struct_alloc(i64 32)
  %r1 = getelementptr inbounds [6 x i8], ptr @.str.2, i64 0, i64 0
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

define i64 @ir_type_bool() nounwind {
entry:
  %r0 = call ptr @nova_rt_struct_alloc(i64 32)
  %r1 = getelementptr inbounds [5 x i8], ptr @.str.3, i64 0, i64 0
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
  %r1 = getelementptr inbounds [4 x i8], ptr @.str.4, i64 0, i64 0
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
  %r1 = getelementptr inbounds [4 x i8], ptr @.str.5, i64 0, i64 0
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
  %r1 = getelementptr inbounds [5 x i8], ptr @.str.6, i64 0, i64 0
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

define i64 @ir_type_list(i64 %p0) nounwind {
entry:
  %slot.elem = alloca i64, align 8
  store i64 %p0, ptr %slot.elem, align 8
  %r0 = call ptr @nova_rt_struct_alloc(i64 32)
  %r1 = getelementptr inbounds [5 x i8], ptr @.str.7, i64 0, i64 0
  %r2 = ptrtoint ptr %r1 to i64
  %t3 = getelementptr i64, ptr %r0, i64 0
  store i64 %r2, ptr %t3, align 8
  %r4 = getelementptr inbounds [1 x i8], ptr @.str.1, i64 0, i64 0
  %r5 = ptrtoint ptr %r4 to i64
  %t6 = getelementptr i64, ptr %r0, i64 1
  store i64 %r5, ptr %t6, align 8
  %r7 = call i64 @nova_rt_list_create()
  %r8 = load i64, ptr %slot.elem, align 8
  %t9 = call i64 @nova_rt_list_append(i64 %r7, i64 %r8)
  %t10 = getelementptr i64, ptr %r0, i64 2
  store i64 %r7, ptr %t10, align 8
  %t11 = getelementptr i64, ptr %r0, i64 3
  store i64 0, ptr %t11, align 8
  %r12 = ptrtoint ptr %r0 to i64
  ret i64 %r12
}

define i64 @ir_type_dict(i64 %p0, i64 %p1) nounwind {
entry:
  %slot.key = alloca i64, align 8
  store i64 %p0, ptr %slot.key, align 8
  %slot.val = alloca i64, align 8
  store i64 %p1, ptr %slot.val, align 8
  %r0 = call ptr @nova_rt_struct_alloc(i64 32)
  %r1 = getelementptr inbounds [5 x i8], ptr @.str.8, i64 0, i64 0
  %r2 = ptrtoint ptr %r1 to i64
  %t3 = getelementptr i64, ptr %r0, i64 0
  store i64 %r2, ptr %t3, align 8
  %r4 = getelementptr inbounds [1 x i8], ptr @.str.1, i64 0, i64 0
  %r5 = ptrtoint ptr %r4 to i64
  %t6 = getelementptr i64, ptr %r0, i64 1
  store i64 %r5, ptr %t6, align 8
  %r7 = call i64 @nova_rt_list_create()
  %r8 = load i64, ptr %slot.key, align 8
  %t9 = call i64 @nova_rt_list_append(i64 %r7, i64 %r8)
  %r10 = load i64, ptr %slot.val, align 8
  %t11 = call i64 @nova_rt_list_append(i64 %r7, i64 %r10)
  %t12 = getelementptr i64, ptr %r0, i64 2
  store i64 %r7, ptr %t12, align 8
  %t13 = getelementptr i64, ptr %r0, i64 3
  store i64 0, ptr %t13, align 8
  %r14 = ptrtoint ptr %r0 to i64
  ret i64 %r14
}

define i64 @ir_type_struct(i64 %p0, i64 %p1) nounwind {
entry:
  %slot.name = alloca i64, align 8
  store i64 %p0, ptr %slot.name, align 8
  %slot.fields = alloca i64, align 8
  store i64 %p1, ptr %slot.fields, align 8
  %r0 = call ptr @nova_rt_struct_alloc(i64 32)
  %r1 = getelementptr inbounds [7 x i8], ptr @.str.9, i64 0, i64 0
  %r2 = ptrtoint ptr %r1 to i64
  %t3 = getelementptr i64, ptr %r0, i64 0
  store i64 %r2, ptr %t3, align 8
  %r4 = load i64, ptr %slot.name, align 8
  %t5 = getelementptr i64, ptr %r0, i64 1
  store i64 %r4, ptr %t5, align 8
  %r6 = load i64, ptr %slot.fields, align 8
  %t7 = getelementptr i64, ptr %r0, i64 2
  store i64 %r6, ptr %t7, align 8
  %t8 = getelementptr i64, ptr %r0, i64 3
  store i64 0, ptr %t8, align 8
  %r9 = ptrtoint ptr %r0 to i64
  ret i64 %r9
}

define i64 @ir_type_fn(i64 %p0, i64 %p1) nounwind {
entry:
  %slot.params = alloca i64, align 8
  store i64 %p0, ptr %slot.params, align 8
  %slot.ret = alloca i64, align 8
  store i64 %p1, ptr %slot.ret, align 8
  %slot.all = alloca i64, align 8
  store i64 0, ptr %slot.all, align 8
  %slot.p = alloca i64, align 8
  store i64 0, ptr %slot.p, align 8
  %r0 = call i64 @nova_rt_list_create()
  store i64 %r0, ptr %slot.all, align 8
  %r1 = load i64, ptr %slot.params, align 8
  %r2 = call i64 @nova_rt_len_any(i64 %r1)
  %slot.__for_idx_0 = alloca i64, align 8
  store i64 0, ptr %slot.__for_idx_0, align 8
  br label %for_hdr0
for_hdr0:
  %r3 = load i64, ptr %slot.__for_idx_0, align 8
  %t4 = icmp slt i64 %r3, %r2
  br i1 %t4, label %for_body1, label %for_exit2
for_body1:
  %r5 = call i64 @nova_rt_index_get(i64 %r1, i64 %r3)
  store i64 %r5, ptr %slot.p, align 8
  %r6 = load i64, ptr %slot.all, align 8
  %r7 = load i64, ptr %slot.p, align 8
  %r8 = call i64 @nova_rt_list_append(i64 %r6, i64 %r7)
  %r10 = load i64, ptr %slot.__for_idx_0, align 8
  %r9 = add i64 %r10, 1
  store i64 %r9, ptr %slot.__for_idx_0, align 8
  br label %for_hdr0
for_exit2:
  %r11 = load i64, ptr %slot.all, align 8
  %r12 = load i64, ptr %slot.ret, align 8
  %r13 = call i64 @nova_rt_list_append(i64 %r11, i64 %r12)
  %r14 = call ptr @nova_rt_struct_alloc(i64 32)
  %r15 = getelementptr inbounds [3 x i8], ptr @.str.10, i64 0, i64 0
  %r16 = ptrtoint ptr %r15 to i64
  %t17 = getelementptr i64, ptr %r14, i64 0
  store i64 %r16, ptr %t17, align 8
  %r18 = getelementptr inbounds [1 x i8], ptr @.str.1, i64 0, i64 0
  %r19 = ptrtoint ptr %r18 to i64
  %t20 = getelementptr i64, ptr %r14, i64 1
  store i64 %r19, ptr %t20, align 8
  %r21 = load i64, ptr %slot.all, align 8
  %t22 = getelementptr i64, ptr %r14, i64 2
  store i64 %r21, ptr %t22, align 8
  %t23 = getelementptr i64, ptr %r14, i64 3
  store i64 0, ptr %t23, align 8
  %r24 = ptrtoint ptr %r14 to i64
  ret i64 %r24
}

define i64 @ir_type_channel(i64 %p0) nounwind {
entry:
  %slot.payload = alloca i64, align 8
  store i64 %p0, ptr %slot.payload, align 8
  %r0 = call ptr @nova_rt_struct_alloc(i64 32)
  %r1 = getelementptr inbounds [8 x i8], ptr @.str.11, i64 0, i64 0
  %r2 = ptrtoint ptr %r1 to i64
  %t3 = getelementptr i64, ptr %r0, i64 0
  store i64 %r2, ptr %t3, align 8
  %r4 = getelementptr inbounds [1 x i8], ptr @.str.1, i64 0, i64 0
  %r5 = ptrtoint ptr %r4 to i64
  %t6 = getelementptr i64, ptr %r0, i64 1
  store i64 %r5, ptr %t6, align 8
  %r7 = call i64 @nova_rt_list_create()
  %r8 = load i64, ptr %slot.payload, align 8
  %t9 = call i64 @nova_rt_list_append(i64 %r7, i64 %r8)
  %t10 = getelementptr i64, ptr %r0, i64 2
  store i64 %r7, ptr %t10, align 8
  %t11 = getelementptr i64, ptr %r0, i64 3
  store i64 0, ptr %t11, align 8
  %r12 = ptrtoint ptr %r0 to i64
  ret i64 %r12
}

define i64 @ir_type_typevar(i64 %p0) nounwind {
entry:
  %slot.id = alloca i64, align 8
  store i64 %p0, ptr %slot.id, align 8
  %r0 = call ptr @nova_rt_struct_alloc(i64 32)
  %r1 = getelementptr inbounds [8 x i8], ptr @.str.12, i64 0, i64 0
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
  %r9 = load i64, ptr %slot.id, align 8
  %t10 = getelementptr i64, ptr %r0, i64 3
  store i64 %r9, ptr %t10, align 8
  %r11 = ptrtoint ptr %r0 to i64
  ret i64 %r11
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
  %r0 = call ptr @nova_rt_struct_alloc(i64 56)
  %r1 = load i64, ptr %slot.op, align 8
  %t2 = getelementptr i64, ptr %r0, i64 0
  store i64 %r1, ptr %t2, align 8
  %r3 = load i64, ptr %slot.dest, align 8
  %t4 = getelementptr i64, ptr %r0, i64 1
  store i64 %r3, ptr %t4, align 8
  %r5 = load i64, ptr %slot.typ, align 8
  %t6 = getelementptr i64, ptr %r0, i64 2
  store i64 %r5, ptr %t6, align 8
  %r7 = load i64, ptr %slot.args, align 8
  %t8 = getelementptr i64, ptr %r0, i64 3
  store i64 %r7, ptr %t8, align 8
  %r9 = load i64, ptr %slot.value, align 8
  %t10 = getelementptr i64, ptr %r0, i64 4
  store i64 %r9, ptr %t10, align 8
  %r11 = load i64, ptr %slot.num, align 8
  %t12 = getelementptr i64, ptr %r0, i64 5
  store i64 %r11, ptr %t12, align 8
  %r13 = getelementptr inbounds [5 x i8], ptr @.str.13, i64 0, i64 0
  %r14 = ptrtoint ptr %r13 to i64
  %t15 = getelementptr i64, ptr %r0, i64 6
  store i64 %r14, ptr %t15, align 8
  %r16 = ptrtoint ptr %r0 to i64
  ret i64 %r16
}

define i64 @ir_inst_effect(i64 %p0, i64 %p1, i64 %p2, i64 %p3, i64 %p4, i64 %p5, i64 %p6) nounwind {
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
  %slot.effect = alloca i64, align 8
  store i64 %p6, ptr %slot.effect, align 8
  %r0 = call ptr @nova_rt_struct_alloc(i64 56)
  %r1 = load i64, ptr %slot.op, align 8
  %t2 = getelementptr i64, ptr %r0, i64 0
  store i64 %r1, ptr %t2, align 8
  %r3 = load i64, ptr %slot.dest, align 8
  %t4 = getelementptr i64, ptr %r0, i64 1
  store i64 %r3, ptr %t4, align 8
  %r5 = load i64, ptr %slot.typ, align 8
  %t6 = getelementptr i64, ptr %r0, i64 2
  store i64 %r5, ptr %t6, align 8
  %r7 = load i64, ptr %slot.args, align 8
  %t8 = getelementptr i64, ptr %r0, i64 3
  store i64 %r7, ptr %t8, align 8
  %r9 = load i64, ptr %slot.value, align 8
  %t10 = getelementptr i64, ptr %r0, i64 4
  store i64 %r9, ptr %t10, align 8
  %r11 = load i64, ptr %slot.num, align 8
  %t12 = getelementptr i64, ptr %r0, i64 5
  store i64 %r11, ptr %t12, align 8
  %r13 = load i64, ptr %slot.effect, align 8
  %t14 = getelementptr i64, ptr %r0, i64 6
  store i64 %r13, ptr %t14, align 8
  %r15 = ptrtoint ptr %r0 to i64
  ret i64 %r15
}

define i64 @new_ir_builder() nounwind {
entry:
  %slot.module = alloca i64, align 8
  store i64 0, ptr %slot.module, align 8
  %slot.entry_block = alloca i64, align 8
  store i64 0, ptr %slot.entry_block, align 8
  %slot.empty_fn = alloca i64, align 8
  store i64 0, ptr %slot.empty_fn, align 8
  %r0 = call ptr @nova_rt_struct_alloc(i64 32)
  %r1 = call i64 @nova_rt_list_create()
  %t2 = getelementptr i64, ptr %r0, i64 0
  store i64 %r1, ptr %t2, align 8
  %r3 = call i64 @nova_rt_list_create()
  %t4 = getelementptr i64, ptr %r0, i64 1
  store i64 %r3, ptr %t4, align 8
  %r5 = call i64 @nova_rt_list_create()
  %t6 = getelementptr i64, ptr %r0, i64 2
  store i64 %r5, ptr %t6, align 8
  %r7 = call i64 @nova_rt_list_create()
  %t8 = getelementptr i64, ptr %r0, i64 3
  store i64 %r7, ptr %t8, align 8
  %r9 = ptrtoint ptr %r0 to i64
  store i64 %r9, ptr %slot.module, align 8
  %r10 = call ptr @nova_rt_struct_alloc(i64 24)
  %r11 = getelementptr inbounds [6 x i8], ptr @.str.14, i64 0, i64 0
  %r12 = ptrtoint ptr %r11 to i64
  %t13 = getelementptr i64, ptr %r10, i64 0
  store i64 %r12, ptr %t13, align 8
  %r14 = call i64 @nova_rt_list_create()
  %t15 = getelementptr i64, ptr %r10, i64 1
  store i64 %r14, ptr %t15, align 8
  %r16 = getelementptr inbounds [7 x i8], ptr @.str.15, i64 0, i64 0
  %r17 = ptrtoint ptr %r16 to i64
  %r18 = getelementptr inbounds [1 x i8], ptr @.str.1, i64 0, i64 0
  %r19 = ptrtoint ptr %r18 to i64
  %r20 = call i64 @ir_type_void()
  %r21 = call i64 @nova_rt_list_create()
  %r22 = getelementptr inbounds [1 x i8], ptr @.str.1, i64 0, i64 0
  %r23 = ptrtoint ptr %r22 to i64
  %r24 = call i64 @ir_inst(i64 %r17, i64 %r19, i64 %r20, i64 %r21, i64 %r23, i64 0)
  %t25 = getelementptr i64, ptr %r10, i64 2
  store i64 %r24, ptr %t25, align 8
  %r26 = ptrtoint ptr %r10 to i64
  store i64 %r26, ptr %slot.entry_block, align 8
  %r27 = call ptr @nova_rt_struct_alloc(i64 48)
  %r28 = getelementptr inbounds [1 x i8], ptr @.str.1, i64 0, i64 0
  %r29 = ptrtoint ptr %r28 to i64
  %t30 = getelementptr i64, ptr %r27, i64 0
  store i64 %r29, ptr %t30, align 8
  %r31 = call i64 @nova_rt_list_create()
  %t32 = getelementptr i64, ptr %r27, i64 1
  store i64 %r31, ptr %t32, align 8
  %r33 = call i64 @ir_type_void()
  %t34 = getelementptr i64, ptr %r27, i64 2
  store i64 %r33, ptr %t34, align 8
  %r35 = call i64 @nova_rt_list_create()
  %t36 = getelementptr i64, ptr %r27, i64 3
  store i64 %r35, ptr %t36, align 8
  %r37 = call i64 @nova_rt_list_create()
  %t38 = getelementptr i64, ptr %r27, i64 4
  store i64 %r37, ptr %t38, align 8
  %t39 = getelementptr i64, ptr %r27, i64 5
  store i64 0, ptr %t39, align 8
  %r40 = ptrtoint ptr %r27 to i64
  store i64 %r40, ptr %slot.empty_fn, align 8
  %r41 = call ptr @nova_rt_struct_alloc(i64 80)
  %r42 = load i64, ptr %slot.module, align 8
  %t43 = getelementptr i64, ptr %r41, i64 0
  store i64 %r42, ptr %t43, align 8
  %r44 = load i64, ptr %slot.empty_fn, align 8
  %t45 = getelementptr i64, ptr %r41, i64 1
  store i64 %r44, ptr %t45, align 8
  %r46 = load i64, ptr %slot.entry_block, align 8
  %t47 = getelementptr i64, ptr %r41, i64 2
  store i64 %r46, ptr %t47, align 8
  %r48 = call i64 @nova_rt_list_create()
  %t49 = getelementptr i64, ptr %r41, i64 3
  store i64 %r48, ptr %t49, align 8
  %t50 = getelementptr i64, ptr %r41, i64 4
  store i64 0, ptr %t50, align 8
  %t51 = getelementptr i64, ptr %r41, i64 5
  store i64 0, ptr %t51, align 8
  %t52 = getelementptr i64, ptr %r41, i64 6
  store i64 0, ptr %t52, align 8
  %r53 = call i64 @nova_rt_dict_create()
  %t54 = getelementptr i64, ptr %r41, i64 7
  store i64 %r53, ptr %t54, align 8
  %r55 = call i64 @nova_rt_dict_create()
  %t56 = getelementptr i64, ptr %r41, i64 8
  store i64 %r55, ptr %t56, align 8
  %r57 = call i64 @nova_rt_dict_create()
  %t58 = getelementptr i64, ptr %r41, i64 9
  store i64 %r57, ptr %t58, align 8
  %r59 = ptrtoint ptr %r41 to i64
  ret i64 %r59
}

define i64 @ir_fresh_reg(i64 %p0) nounwind {
entry:
  %slot.b = alloca i64, align 8
  store i64 %p0, ptr %slot.b, align 8
  %slot.name = alloca i64, align 8
  store i64 0, ptr %slot.name, align 8
  %r0 = getelementptr inbounds [3 x i8], ptr @.str.16, i64 0, i64 0
  %r1 = ptrtoint ptr %r0 to i64
  %r2 = load i64, ptr %slot.b, align 8
  %t4 = inttoptr i64 %r2 to ptr
  %t5 = getelementptr i64, ptr %t4, i64 4
  %r3 = load i64, ptr %t5, align 8
  %r6 = call i64 @nova_rt_int_to_str(i64 %r3)
  %r7 = call i64 @nova_rt_add(i64 %r1, i64 %r6)
  store i64 %r7, ptr %slot.name, align 8
  %r8 = load i64, ptr %slot.b, align 8
  %t10 = inttoptr i64 %r8 to ptr
  %t11 = getelementptr i64, ptr %t10, i64 4
  %r9 = load i64, ptr %t11, align 8
  %r12 = call i64 @nova_rt_add(i64 %r9, i64 1)
  %r13 = load i64, ptr %slot.b, align 8
  %t14 = inttoptr i64 %r13 to ptr
  %t15 = getelementptr i64, ptr %t14, i64 4
  store i64 %r12, ptr %t15, align 8
  %r16 = load i64, ptr %slot.name, align 8
  ret i64 %r16
}

define i64 @ir_fresh_label(i64 %p0, i64 %p1) nounwind {
entry:
  %slot.b = alloca i64, align 8
  store i64 %p0, ptr %slot.b, align 8
  %slot.prefix = alloca i64, align 8
  store i64 %p1, ptr %slot.prefix, align 8
  %slot.name = alloca i64, align 8
  store i64 0, ptr %slot.name, align 8
  %r0 = load i64, ptr %slot.prefix, align 8
  %r1 = load i64, ptr %slot.b, align 8
  %t3 = inttoptr i64 %r1 to ptr
  %t4 = getelementptr i64, ptr %t3, i64 5
  %r2 = load i64, ptr %t4, align 8
  %r5 = call i64 @nova_rt_int_to_str(i64 %r2)
  %r6 = call i64 @nova_rt_add(i64 %r0, i64 %r5)
  store i64 %r6, ptr %slot.name, align 8
  %r7 = load i64, ptr %slot.b, align 8
  %t9 = inttoptr i64 %r7 to ptr
  %t10 = getelementptr i64, ptr %t9, i64 5
  %r8 = load i64, ptr %t10, align 8
  %r11 = call i64 @nova_rt_add(i64 %r8, i64 1)
  %r12 = load i64, ptr %slot.b, align 8
  %t13 = inttoptr i64 %r12 to ptr
  %t14 = getelementptr i64, ptr %t13, i64 5
  store i64 %r11, ptr %t14, align 8
  %r15 = load i64, ptr %slot.name, align 8
  ret i64 %r15
}

define i64 @ir_fresh_typevar(i64 %p0) nounwind {
entry:
  %slot.b = alloca i64, align 8
  store i64 %p0, ptr %slot.b, align 8
  %slot.id = alloca i64, align 8
  store i64 0, ptr %slot.id, align 8
  %r0 = load i64, ptr %slot.b, align 8
  %t2 = inttoptr i64 %r0 to ptr
  %t3 = getelementptr i64, ptr %t2, i64 6
  %r1 = load i64, ptr %t3, align 8
  store i64 %r1, ptr %slot.id, align 8
  %r4 = load i64, ptr %slot.b, align 8
  %t6 = inttoptr i64 %r4 to ptr
  %t7 = getelementptr i64, ptr %t6, i64 6
  %r5 = load i64, ptr %t7, align 8
  %r8 = call i64 @nova_rt_add(i64 %r5, i64 1)
  %r9 = load i64, ptr %slot.b, align 8
  %t10 = inttoptr i64 %r9 to ptr
  %t11 = getelementptr i64, ptr %t10, i64 6
  store i64 %r8, ptr %t11, align 8
  %r12 = load i64, ptr %slot.id, align 8
  %r13 = call i64 @ir_type_typevar(i64 %r12)
  ret i64 %r13
}

define i64 @ir_emit(i64 %p0, i64 %p1) nounwind {
entry:
  %slot.b = alloca i64, align 8
  store i64 %p0, ptr %slot.b, align 8
  %slot.inst = alloca i64, align 8
  store i64 %p1, ptr %slot.inst, align 8
  %r0 = load i64, ptr %slot.b, align 8
  %t2 = inttoptr i64 %r0 to ptr
  %t3 = getelementptr i64, ptr %t2, i64 2
  %r1 = load i64, ptr %t3, align 8
  %t5 = inttoptr i64 %r1 to ptr
  %t6 = getelementptr i64, ptr %t5, i64 1
  %r4 = load i64, ptr %t6, align 8
  %r7 = load i64, ptr %slot.inst, align 8
  %r8 = call i64 @nova_rt_list_append(i64 %r4, i64 %r7)
  ret i64 %r8
}

define i64 @ir_terminate(i64 %p0, i64 %p1) nounwind {
entry:
  %slot.b = alloca i64, align 8
  store i64 %p0, ptr %slot.b, align 8
  %slot.term = alloca i64, align 8
  store i64 %p1, ptr %slot.term, align 8
  %slot.next_label = alloca i64, align 8
  store i64 0, ptr %slot.next_label, align 8
  %r0 = load i64, ptr %slot.term, align 8
  %r1 = load i64, ptr %slot.b, align 8
  %t3 = inttoptr i64 %r1 to ptr
  %t4 = getelementptr i64, ptr %t3, i64 2
  %r2 = load i64, ptr %t4, align 8
  %t5 = inttoptr i64 %r2 to ptr
  %t6 = getelementptr i64, ptr %t5, i64 2
  store i64 %r0, ptr %t6, align 8
  %r7 = load i64, ptr %slot.b, align 8
  %t9 = inttoptr i64 %r7 to ptr
  %t10 = getelementptr i64, ptr %t9, i64 3
  %r8 = load i64, ptr %t10, align 8
  %r11 = load i64, ptr %slot.b, align 8
  %t13 = inttoptr i64 %r11 to ptr
  %t14 = getelementptr i64, ptr %t13, i64 2
  %r12 = load i64, ptr %t14, align 8
  %r15 = call i64 @nova_rt_list_append(i64 %r8, i64 %r12)
  %r16 = load i64, ptr %slot.b, align 8
  %r17 = getelementptr inbounds [3 x i8], ptr @.str.17, i64 0, i64 0
  %r18 = ptrtoint ptr %r17 to i64
  %r19 = call i64 @ir_fresh_label(i64 %r16, i64 %r18)
  store i64 %r19, ptr %slot.next_label, align 8
  %r20 = call ptr @nova_rt_struct_alloc(i64 24)
  %r21 = load i64, ptr %slot.next_label, align 8
  %t22 = getelementptr i64, ptr %r20, i64 0
  store i64 %r21, ptr %t22, align 8
  %r23 = call i64 @nova_rt_list_create()
  %t24 = getelementptr i64, ptr %r20, i64 1
  store i64 %r23, ptr %t24, align 8
  %r25 = getelementptr inbounds [7 x i8], ptr @.str.15, i64 0, i64 0
  %r26 = ptrtoint ptr %r25 to i64
  %r27 = getelementptr inbounds [1 x i8], ptr @.str.1, i64 0, i64 0
  %r28 = ptrtoint ptr %r27 to i64
  %r29 = call i64 @ir_type_void()
  %r30 = call i64 @nova_rt_list_create()
  %r31 = getelementptr inbounds [1 x i8], ptr @.str.1, i64 0, i64 0
  %r32 = ptrtoint ptr %r31 to i64
  %r33 = call i64 @ir_inst(i64 %r26, i64 %r28, i64 %r29, i64 %r30, i64 %r32, i64 0)
  %t34 = getelementptr i64, ptr %r20, i64 2
  store i64 %r33, ptr %t34, align 8
  %r35 = ptrtoint ptr %r20 to i64
  %r36 = load i64, ptr %slot.b, align 8
  %t37 = inttoptr i64 %r36 to ptr
  %t38 = getelementptr i64, ptr %t37, i64 2
  store i64 %r35, ptr %t38, align 8
  ret i64 0
}

define i64 @ir_start_block(i64 %p0, i64 %p1) nounwind {
entry:
  %slot.b = alloca i64, align 8
  store i64 %p0, ptr %slot.b, align 8
  %slot.label = alloca i64, align 8
  store i64 %p1, ptr %slot.label, align 8
  %r0 = call ptr @nova_rt_struct_alloc(i64 24)
  %r1 = load i64, ptr %slot.label, align 8
  %t2 = getelementptr i64, ptr %r0, i64 0
  store i64 %r1, ptr %t2, align 8
  %r3 = call i64 @nova_rt_list_create()
  %t4 = getelementptr i64, ptr %r0, i64 1
  store i64 %r3, ptr %t4, align 8
  %r5 = getelementptr inbounds [7 x i8], ptr @.str.15, i64 0, i64 0
  %r6 = ptrtoint ptr %r5 to i64
  %r7 = getelementptr inbounds [1 x i8], ptr @.str.1, i64 0, i64 0
  %r8 = ptrtoint ptr %r7 to i64
  %r9 = call i64 @ir_type_void()
  %r10 = call i64 @nova_rt_list_create()
  %r11 = getelementptr inbounds [1 x i8], ptr @.str.1, i64 0, i64 0
  %r12 = ptrtoint ptr %r11 to i64
  %r13 = call i64 @ir_inst(i64 %r6, i64 %r8, i64 %r9, i64 %r10, i64 %r12, i64 0)
  %t14 = getelementptr i64, ptr %r0, i64 2
  store i64 %r13, ptr %t14, align 8
  %r15 = ptrtoint ptr %r0 to i64
  %r16 = load i64, ptr %slot.b, align 8
  %t17 = inttoptr i64 %r16 to ptr
  %t18 = getelementptr i64, ptr %t17, i64 2
  store i64 %r15, ptr %t18, align 8
  ret i64 0
}

define i64 @infer_binop_type(i64 %p0, i64 %p1, i64 %p2) nounwind {
entry:
  %slot.op = alloca i64, align 8
  store i64 %p0, ptr %slot.op, align 8
  %slot.left = alloca i64, align 8
  store i64 %p1, ptr %slot.left, align 8
  %slot.right = alloca i64, align 8
  store i64 %p2, ptr %slot.right, align 8
  %r0 = load i64, ptr %slot.op, align 8
  %r1 = getelementptr inbounds [2 x i8], ptr @.str.18, i64 0, i64 0
  %r2 = ptrtoint ptr %r1 to i64
  %t4 = call i64 @nova_rt_eq(i64 %r0, i64 %r2)
  %r3 = and i64 %t4, 1
  %r5 = load i64, ptr %slot.op, align 8
  %r6 = getelementptr inbounds [2 x i8], ptr @.str.19, i64 0, i64 0
  %r7 = ptrtoint ptr %r6 to i64
  %t9 = call i64 @nova_rt_eq(i64 %r5, i64 %r7)
  %r8 = and i64 %t9, 1
  br label %or_entry3
or_entry3:
  %t11 = icmp ne i64 %t4, 0
  br i1 %t11, label %or_end5, label %or_rhs4
or_rhs4:
  %r12 = load i64, ptr %slot.op, align 8
  %r13 = getelementptr inbounds [2 x i8], ptr @.str.19, i64 0, i64 0
  %r14 = ptrtoint ptr %r13 to i64
  %t16 = call i64 @nova_rt_eq(i64 %r12, i64 %r14)
  %r15 = and i64 %t16, 1
  br label %or_done6
or_done6:
  br label %or_end5
or_end5:
  %r10 = phi i64 [%t4, %or_entry3], [%t16, %or_done6]
  %r17 = load i64, ptr %slot.op, align 8
  %r18 = getelementptr inbounds [2 x i8], ptr @.str.20, i64 0, i64 0
  %r19 = ptrtoint ptr %r18 to i64
  %t21 = call i64 @nova_rt_eq(i64 %r17, i64 %r19)
  %r20 = and i64 %t21, 1
  br label %or_entry7
or_entry7:
  %t23 = icmp ne i64 %r10, 0
  br i1 %t23, label %or_end9, label %or_rhs8
or_rhs8:
  %r24 = load i64, ptr %slot.op, align 8
  %r25 = getelementptr inbounds [2 x i8], ptr @.str.20, i64 0, i64 0
  %r26 = ptrtoint ptr %r25 to i64
  %t28 = call i64 @nova_rt_eq(i64 %r24, i64 %r26)
  %r27 = and i64 %t28, 1
  br label %or_done10
or_done10:
  br label %or_end9
or_end9:
  %r22 = phi i64 [%r10, %or_entry7], [%t28, %or_done10]
  %r29 = load i64, ptr %slot.op, align 8
  %r30 = getelementptr inbounds [2 x i8], ptr @.str.21, i64 0, i64 0
  %r31 = ptrtoint ptr %r30 to i64
  %t33 = call i64 @nova_rt_eq(i64 %r29, i64 %r31)
  %r32 = and i64 %t33, 1
  br label %or_entry11
or_entry11:
  %t35 = icmp ne i64 %r22, 0
  br i1 %t35, label %or_end13, label %or_rhs12
or_rhs12:
  %r36 = load i64, ptr %slot.op, align 8
  %r37 = getelementptr inbounds [2 x i8], ptr @.str.21, i64 0, i64 0
  %r38 = ptrtoint ptr %r37 to i64
  %t40 = call i64 @nova_rt_eq(i64 %r36, i64 %r38)
  %r39 = and i64 %t40, 1
  br label %or_done14
or_done14:
  br label %or_end13
or_end13:
  %r34 = phi i64 [%r22, %or_entry11], [%t40, %or_done14]
  %r41 = load i64, ptr %slot.op, align 8
  %r42 = getelementptr inbounds [2 x i8], ptr @.str.22, i64 0, i64 0
  %r43 = ptrtoint ptr %r42 to i64
  %t45 = call i64 @nova_rt_eq(i64 %r41, i64 %r43)
  %r44 = and i64 %t45, 1
  br label %or_entry15
or_entry15:
  %t47 = icmp ne i64 %r34, 0
  br i1 %t47, label %or_end17, label %or_rhs16
or_rhs16:
  %r48 = load i64, ptr %slot.op, align 8
  %r49 = getelementptr inbounds [2 x i8], ptr @.str.22, i64 0, i64 0
  %r50 = ptrtoint ptr %r49 to i64
  %t52 = call i64 @nova_rt_eq(i64 %r48, i64 %r50)
  %r51 = and i64 %t52, 1
  br label %or_done18
or_done18:
  br label %or_end17
or_end17:
  %r46 = phi i64 [%r34, %or_entry15], [%t52, %or_done18]
  %t53 = icmp ne i64 %r46, 0
  br i1 %t53, label %ret_then19, label %ret_else20
ret_then19:
  %r54 = load i64, ptr %slot.left, align 8
  %t56 = inttoptr i64 %r54 to ptr
  %t57 = getelementptr i64, ptr %t56, i64 0
  %r55 = load i64, ptr %t57, align 8
  %r58 = getelementptr inbounds [4 x i8], ptr @.str.4, i64 0, i64 0
  %r59 = ptrtoint ptr %r58 to i64
  %t61 = call i64 @nova_rt_eq(i64 %r55, i64 %r59)
  %r60 = and i64 %t61, 1
  %r62 = load i64, ptr %slot.right, align 8
  %t64 = inttoptr i64 %r62 to ptr
  %t65 = getelementptr i64, ptr %t64, i64 0
  %r63 = load i64, ptr %t65, align 8
  %r66 = getelementptr inbounds [4 x i8], ptr @.str.4, i64 0, i64 0
  %r67 = ptrtoint ptr %r66 to i64
  %t69 = call i64 @nova_rt_eq(i64 %r63, i64 %r67)
  %r68 = and i64 %t69, 1
  br label %or_entry21
or_entry21:
  %t71 = icmp ne i64 %t61, 0
  br i1 %t71, label %or_end23, label %or_rhs22
or_rhs22:
  %r72 = load i64, ptr %slot.right, align 8
  %t74 = inttoptr i64 %r72 to ptr
  %t75 = getelementptr i64, ptr %t74, i64 0
  %r73 = load i64, ptr %t75, align 8
  %r76 = getelementptr inbounds [4 x i8], ptr @.str.4, i64 0, i64 0
  %r77 = ptrtoint ptr %r76 to i64
  %t79 = call i64 @nova_rt_eq(i64 %r73, i64 %r77)
  %r78 = and i64 %t79, 1
  br label %or_done24
or_done24:
  br label %or_end23
or_end23:
  %r70 = phi i64 [%t61, %or_entry21], [%t79, %or_done24]
  %t80 = icmp ne i64 %r70, 0
  br i1 %t80, label %ret_then25, label %ret_else26
ret_then25:
  %r81 = call i64 @ir_type_str()
  ret i64 %r81
ret_else26:
  %r82 = call i64 @ir_type_int()
  ret i64 %r82
ret_else20:
  %r83 = load i64, ptr %slot.op, align 8
  %r84 = getelementptr inbounds [3 x i8], ptr @.str.23, i64 0, i64 0
  %r85 = ptrtoint ptr %r84 to i64
  %t87 = call i64 @nova_rt_eq(i64 %r83, i64 %r85)
  %r86 = and i64 %t87, 1
  %r88 = load i64, ptr %slot.op, align 8
  %r89 = getelementptr inbounds [3 x i8], ptr @.str.24, i64 0, i64 0
  %r90 = ptrtoint ptr %r89 to i64
  %t92 = call i64 @nova_rt_eq(i64 %r88, i64 %r90)
  %r91 = and i64 %t92, 1
  br label %or_entry27
or_entry27:
  %t94 = icmp ne i64 %t87, 0
  br i1 %t94, label %or_end29, label %or_rhs28
or_rhs28:
  %r95 = load i64, ptr %slot.op, align 8
  %r96 = getelementptr inbounds [3 x i8], ptr @.str.24, i64 0, i64 0
  %r97 = ptrtoint ptr %r96 to i64
  %t99 = call i64 @nova_rt_eq(i64 %r95, i64 %r97)
  %r98 = and i64 %t99, 1
  br label %or_done30
or_done30:
  br label %or_end29
or_end29:
  %r93 = phi i64 [%t87, %or_entry27], [%t99, %or_done30]
  %r100 = load i64, ptr %slot.op, align 8
  %r101 = getelementptr inbounds [2 x i8], ptr @.str.25, i64 0, i64 0
  %r102 = ptrtoint ptr %r101 to i64
  %t104 = call i64 @nova_rt_eq(i64 %r100, i64 %r102)
  %r103 = and i64 %t104, 1
  br label %or_entry31
or_entry31:
  %t106 = icmp ne i64 %r93, 0
  br i1 %t106, label %or_end33, label %or_rhs32
or_rhs32:
  %r107 = load i64, ptr %slot.op, align 8
  %r108 = getelementptr inbounds [2 x i8], ptr @.str.25, i64 0, i64 0
  %r109 = ptrtoint ptr %r108 to i64
  %t111 = call i64 @nova_rt_eq(i64 %r107, i64 %r109)
  %r110 = and i64 %t111, 1
  br label %or_done34
or_done34:
  br label %or_end33
or_end33:
  %r105 = phi i64 [%r93, %or_entry31], [%t111, %or_done34]
  %r112 = load i64, ptr %slot.op, align 8
  %r113 = getelementptr inbounds [3 x i8], ptr @.str.26, i64 0, i64 0
  %r114 = ptrtoint ptr %r113 to i64
  %t116 = call i64 @nova_rt_eq(i64 %r112, i64 %r114)
  %r115 = and i64 %t116, 1
  br label %or_entry35
or_entry35:
  %t118 = icmp ne i64 %r105, 0
  br i1 %t118, label %or_end37, label %or_rhs36
or_rhs36:
  %r119 = load i64, ptr %slot.op, align 8
  %r120 = getelementptr inbounds [3 x i8], ptr @.str.26, i64 0, i64 0
  %r121 = ptrtoint ptr %r120 to i64
  %t123 = call i64 @nova_rt_eq(i64 %r119, i64 %r121)
  %r122 = and i64 %t123, 1
  br label %or_done38
or_done38:
  br label %or_end37
or_end37:
  %r117 = phi i64 [%r105, %or_entry35], [%t123, %or_done38]
  %r124 = load i64, ptr %slot.op, align 8
  %r125 = getelementptr inbounds [2 x i8], ptr @.str.27, i64 0, i64 0
  %r126 = ptrtoint ptr %r125 to i64
  %t128 = call i64 @nova_rt_eq(i64 %r124, i64 %r126)
  %r127 = and i64 %t128, 1
  br label %or_entry39
or_entry39:
  %t130 = icmp ne i64 %r117, 0
  br i1 %t130, label %or_end41, label %or_rhs40
or_rhs40:
  %r131 = load i64, ptr %slot.op, align 8
  %r132 = getelementptr inbounds [2 x i8], ptr @.str.27, i64 0, i64 0
  %r133 = ptrtoint ptr %r132 to i64
  %t135 = call i64 @nova_rt_eq(i64 %r131, i64 %r133)
  %r134 = and i64 %t135, 1
  br label %or_done42
or_done42:
  br label %or_end41
or_end41:
  %r129 = phi i64 [%r117, %or_entry39], [%t135, %or_done42]
  %r136 = load i64, ptr %slot.op, align 8
  %r137 = getelementptr inbounds [3 x i8], ptr @.str.28, i64 0, i64 0
  %r138 = ptrtoint ptr %r137 to i64
  %t140 = call i64 @nova_rt_eq(i64 %r136, i64 %r138)
  %r139 = and i64 %t140, 1
  br label %or_entry43
or_entry43:
  %t142 = icmp ne i64 %r129, 0
  br i1 %t142, label %or_end45, label %or_rhs44
or_rhs44:
  %r143 = load i64, ptr %slot.op, align 8
  %r144 = getelementptr inbounds [3 x i8], ptr @.str.28, i64 0, i64 0
  %r145 = ptrtoint ptr %r144 to i64
  %t147 = call i64 @nova_rt_eq(i64 %r143, i64 %r145)
  %r146 = and i64 %t147, 1
  br label %or_done46
or_done46:
  br label %or_end45
or_end45:
  %r141 = phi i64 [%r129, %or_entry43], [%t147, %or_done46]
  %t148 = icmp ne i64 %r141, 0
  br i1 %t148, label %ret_then47, label %ret_else48
ret_then47:
  %r149 = call i64 @ir_type_bool()
  ret i64 %r149
ret_else48:
  %r150 = load i64, ptr %slot.op, align 8
  %r151 = getelementptr inbounds [4 x i8], ptr @.str.29, i64 0, i64 0
  %r152 = ptrtoint ptr %r151 to i64
  %t154 = call i64 @nova_rt_eq(i64 %r150, i64 %r152)
  %r153 = and i64 %t154, 1
  %r155 = load i64, ptr %slot.op, align 8
  %r156 = getelementptr inbounds [3 x i8], ptr @.str.30, i64 0, i64 0
  %r157 = ptrtoint ptr %r156 to i64
  %t159 = call i64 @nova_rt_eq(i64 %r155, i64 %r157)
  %r158 = and i64 %t159, 1
  br label %or_entry49
or_entry49:
  %t161 = icmp ne i64 %t154, 0
  br i1 %t161, label %or_end51, label %or_rhs50
or_rhs50:
  %r162 = load i64, ptr %slot.op, align 8
  %r163 = getelementptr inbounds [3 x i8], ptr @.str.30, i64 0, i64 0
  %r164 = ptrtoint ptr %r163 to i64
  %t166 = call i64 @nova_rt_eq(i64 %r162, i64 %r164)
  %r165 = and i64 %t166, 1
  br label %or_done52
or_done52:
  br label %or_end51
or_end51:
  %r160 = phi i64 [%t154, %or_entry49], [%t166, %or_done52]
  %t167 = icmp ne i64 %r160, 0
  br i1 %t167, label %ret_then53, label %ret_else54
ret_then53:
  %r168 = call i64 @ir_type_bool()
  ret i64 %r168
ret_else54:
  %r169 = call i64 @ir_type_any()
  ret i64 %r169
}

define i64 @ir_build_expr(i64 %p0, i64 %p1) nounwind {
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
  %slot.bval = alloca i64, align 8
  store i64 0, ptr %slot.bval, align 8
  %slot.var_type = alloca i64, align 8
  store i64 0, ptr %slot.var_type, align 8
  %slot.left_r = alloca i64, align 8
  store i64 0, ptr %slot.left_r, align 8
  %slot.right_r = alloca i64, align 8
  store i64 0, ptr %slot.right_r, align 8
  %slot.op = alloca i64, align 8
  store i64 0, ptr %slot.op, align 8
  %slot.ir_op = alloca i64, align 8
  store i64 0, ptr %slot.ir_op, align 8
  %slot.cmp_op = alloca i64, align 8
  store i64 0, ptr %slot.cmp_op, align 8
  %slot.operand_r = alloca i64, align 8
  store i64 0, ptr %slot.operand_r, align 8
  %slot.fn_name = alloca i64, align 8
  store i64 0, ptr %slot.fn_name, align 8
  %slot.ct = alloca i64, align 8
  store i64 0, ptr %slot.ct, align 8
  %slot.cv = alloca i64, align 8
  store i64 0, ptr %slot.cv, align 8
  %slot.cn = alloca i64, align 8
  store i64 0, ptr %slot.cn, align 8
  %slot.cc = alloca i64, align 8
  store i64 0, ptr %slot.cc, align 8
  %slot.cf = alloca i64, align 8
  store i64 0, ptr %slot.cf, align 8
  %slot.call_args = alloca i64, align 8
  store i64 0, ptr %slot.call_args, align 8
  %slot.i = alloca i64, align 8
  store i64 0, ptr %slot.i, align 8
  %slot.arg_r = alloca i64, align 8
  store i64 0, ptr %slot.arg_r, align 8
  %slot.eff = alloca i64, align 8
  store i64 0, ptr %slot.eff, align 8
  %slot.target_r = alloca i64, align 8
  store i64 0, ptr %slot.target_r, align 8
  %slot.idx_r = alloca i64, align 8
  store i64 0, ptr %slot.idx_r, align 8
  %slot.elem_regs = alloca i64, align 8
  store i64 0, ptr %slot.elem_regs, align 8
  %slot.elem = alloca i64, align 8
  store i64 0, ptr %slot.elem, align 8
  %slot.er = alloca i64, align 8
  store i64 0, ptr %slot.er, align 8
  %slot.struct_name = alloca i64, align 8
  store i64 0, ptr %slot.struct_name, align 8
  %slot.field_regs = alloca i64, align 8
  store i64 0, ptr %slot.field_regs, align 8
  %slot.arg = alloca i64, align 8
  store i64 0, ptr %slot.arg, align 8
  %slot.ar = alloca i64, align 8
  store i64 0, ptr %slot.ar, align 8
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
  br i1 %t17, label %ret_then55, label %ret_else56
ret_then55:
  %r18 = load i64, ptr %slot.b, align 8
  %r19 = call i64 @ir_fresh_reg(i64 %r18)
  store i64 %r19, ptr %slot.dest, align 8
  %r20 = load i64, ptr %slot.b, align 8
  %r21 = getelementptr inbounds [10 x i8], ptr @.str.31, i64 0, i64 0
  %r22 = ptrtoint ptr %r21 to i64
  %r23 = load i64, ptr %slot.dest, align 8
  %r24 = call i64 @ir_type_int()
  %r25 = call i64 @nova_rt_list_create()
  %r26 = getelementptr inbounds [1 x i8], ptr @.str.1, i64 0, i64 0
  %r27 = ptrtoint ptr %r26 to i64
  %r28 = load i64, ptr %slot.num, align 8
  %r29 = call i64 @ir_inst(i64 %r22, i64 %r23, i64 %r24, i64 %r25, i64 %r27, i64 %r28)
  %r30 = call i64 @ir_emit(i64 %r20, i64 %r29)
  %r31 = load i64, ptr %slot.dest, align 8
  ret i64 %r31
ret_else56:
  %r32 = load i64, ptr %slot.tag, align 8
  %r33 = getelementptr inbounds [6 x i8], ptr @.str.2, i64 0, i64 0
  %r34 = ptrtoint ptr %r33 to i64
  %t36 = call i64 @nova_rt_eq(i64 %r32, i64 %r34)
  %r35 = and i64 %t36, 1
  %t37 = icmp ne i64 %t36, 0
  br i1 %t37, label %ret_then57, label %ret_else58
ret_then57:
  %r38 = load i64, ptr %slot.b, align 8
  %r39 = call i64 @ir_fresh_reg(i64 %r38)
  store i64 %r39, ptr %slot.dest, align 8
  %r40 = load i64, ptr %slot.b, align 8
  %r41 = getelementptr inbounds [12 x i8], ptr @.str.32, i64 0, i64 0
  %r42 = ptrtoint ptr %r41 to i64
  %r43 = load i64, ptr %slot.dest, align 8
  %r44 = call i64 @ir_type_float()
  %r45 = call i64 @nova_rt_list_create()
  %r46 = load i64, ptr %slot.value, align 8
  %r47 = call i64 @ir_inst(i64 %r42, i64 %r43, i64 %r44, i64 %r45, i64 %r46, i64 0)
  %r48 = call i64 @ir_emit(i64 %r40, i64 %r47)
  %r49 = load i64, ptr %slot.dest, align 8
  ret i64 %r49
ret_else58:
  %r50 = load i64, ptr %slot.tag, align 8
  %r51 = getelementptr inbounds [7 x i8], ptr @.str.33, i64 0, i64 0
  %r52 = ptrtoint ptr %r51 to i64
  %t54 = call i64 @nova_rt_eq(i64 %r50, i64 %r52)
  %r53 = and i64 %t54, 1
  %t55 = icmp ne i64 %t54, 0
  br i1 %t55, label %ret_then59, label %ret_else60
ret_then59:
  %r56 = load i64, ptr %slot.b, align 8
  %r57 = call i64 @ir_fresh_reg(i64 %r56)
  store i64 %r57, ptr %slot.dest, align 8
  %r58 = load i64, ptr %slot.b, align 8
  %r59 = getelementptr inbounds [10 x i8], ptr @.str.34, i64 0, i64 0
  %r60 = ptrtoint ptr %r59 to i64
  %r61 = load i64, ptr %slot.dest, align 8
  %r62 = call i64 @ir_type_str()
  %r63 = call i64 @nova_rt_list_create()
  %r64 = load i64, ptr %slot.value, align 8
  %r65 = call i64 @ir_inst(i64 %r60, i64 %r61, i64 %r62, i64 %r63, i64 %r64, i64 0)
  %r66 = call i64 @ir_emit(i64 %r58, i64 %r65)
  %r67 = load i64, ptr %slot.dest, align 8
  ret i64 %r67
ret_else60:
  %r68 = load i64, ptr %slot.tag, align 8
  %r69 = getelementptr inbounds [5 x i8], ptr @.str.3, i64 0, i64 0
  %r70 = ptrtoint ptr %r69 to i64
  %t72 = call i64 @nova_rt_eq(i64 %r68, i64 %r70)
  %r71 = and i64 %t72, 1
  %t73 = icmp ne i64 %t72, 0
  br i1 %t73, label %ret_then61, label %ret_else62
ret_then61:
  %r74 = load i64, ptr %slot.b, align 8
  %r75 = call i64 @ir_fresh_reg(i64 %r74)
  store i64 %r75, ptr %slot.dest, align 8
  %r76 = load i64, ptr %slot.value, align 8
  %r77 = getelementptr inbounds [5 x i8], ptr @.str.35, i64 0, i64 0
  %r78 = ptrtoint ptr %r77 to i64
  %t80 = call i64 @nova_rt_eq(i64 %r76, i64 %r78)
  %r79 = and i64 %t80, 1
  %t81 = icmp ne i64 %t80, 0
  br i1 %t81, label %if_then63, label %if_else64
if_then63:
  br label %if_then_done66
if_then_done66:
  br label %if_merge65
if_else64:
  br label %if_else_done67
if_else_done67:
  br label %if_merge65
if_merge65:
  %r82 = phi i64 [1, %if_then_done66], [0, %if_else_done67]
  store i64 %r82, ptr %slot.bval, align 8
  %r83 = load i64, ptr %slot.b, align 8
  %r84 = getelementptr inbounds [11 x i8], ptr @.str.36, i64 0, i64 0
  %r85 = ptrtoint ptr %r84 to i64
  %r86 = load i64, ptr %slot.dest, align 8
  %r87 = call i64 @ir_type_bool()
  %r88 = call i64 @nova_rt_list_create()
  %r89 = getelementptr inbounds [1 x i8], ptr @.str.1, i64 0, i64 0
  %r90 = ptrtoint ptr %r89 to i64
  %r91 = load i64, ptr %slot.bval, align 8
  %r92 = call i64 @ir_inst(i64 %r85, i64 %r86, i64 %r87, i64 %r88, i64 %r90, i64 %r91)
  %r93 = call i64 @ir_emit(i64 %r83, i64 %r92)
  %r94 = load i64, ptr %slot.dest, align 8
  ret i64 %r94
ret_else62:
  %r95 = load i64, ptr %slot.tag, align 8
  %r96 = getelementptr inbounds [5 x i8], ptr @.str.37, i64 0, i64 0
  %r97 = ptrtoint ptr %r96 to i64
  %t99 = call i64 @nova_rt_eq(i64 %r95, i64 %r97)
  %r98 = and i64 %t99, 1
  %t100 = icmp ne i64 %t99, 0
  br i1 %t100, label %ret_then68, label %ret_else69
ret_then68:
  %r101 = load i64, ptr %slot.b, align 8
  %r102 = call i64 @ir_fresh_reg(i64 %r101)
  store i64 %r102, ptr %slot.dest, align 8
  %r103 = load i64, ptr %slot.b, align 8
  %r104 = getelementptr inbounds [11 x i8], ptr @.str.38, i64 0, i64 0
  %r105 = ptrtoint ptr %r104 to i64
  %r106 = load i64, ptr %slot.dest, align 8
  %r107 = call i64 @ir_type_any()
  %r108 = call i64 @nova_rt_list_create()
  %r109 = getelementptr inbounds [1 x i8], ptr @.str.1, i64 0, i64 0
  %r110 = ptrtoint ptr %r109 to i64
  %r111 = call i64 @ir_inst(i64 %r105, i64 %r106, i64 %r107, i64 %r108, i64 %r110, i64 0)
  %r112 = call i64 @ir_emit(i64 %r103, i64 %r111)
  %r113 = load i64, ptr %slot.dest, align 8
  ret i64 %r113
ret_else69:
  %r114 = load i64, ptr %slot.tag, align 8
  %r115 = getelementptr inbounds [6 x i8], ptr @.str.39, i64 0, i64 0
  %r116 = ptrtoint ptr %r115 to i64
  %t118 = call i64 @nova_rt_eq(i64 %r114, i64 %r116)
  %r117 = and i64 %t118, 1
  %t119 = icmp ne i64 %t118, 0
  br i1 %t119, label %ret_then70, label %ret_else71
ret_then70:
  %r120 = load i64, ptr %slot.b, align 8
  %r121 = call i64 @ir_fresh_reg(i64 %r120)
  store i64 %r121, ptr %slot.dest, align 8
  %r122 = call i64 @ir_type_any()
  store i64 %r122, ptr %slot.var_type, align 8
  %r123 = load i64, ptr %slot.b, align 8
  %t125 = inttoptr i64 %r123 to ptr
  %t126 = getelementptr i64, ptr %t125, i64 9
  %r124 = load i64, ptr %t126, align 8
  %r127 = load i64, ptr %slot.value, align 8
  %r128 = call i64 @nova_rt_contains(i64 %r124, i64 %r127)
  %t129 = icmp ne i64 %r128, 0
  br i1 %t129, label %then72, label %else73
then72:
  %r130 = load i64, ptr %slot.b, align 8
  %t132 = inttoptr i64 %r130 to ptr
  %t133 = getelementptr i64, ptr %t132, i64 9
  %r131 = load i64, ptr %t133, align 8
  %r134 = load i64, ptr %slot.value, align 8
  %r135 = call i64 @nova_rt_index_get(i64 %r131, i64 %r134)
  store i64 %r135, ptr %slot.var_type, align 8
  br label %merge74
else73:
  br label %merge74
merge74:
  %r136 = load i64, ptr %slot.b, align 8
  %r137 = getelementptr inbounds [10 x i8], ptr @.str.40, i64 0, i64 0
  %r138 = ptrtoint ptr %r137 to i64
  %r139 = load i64, ptr %slot.dest, align 8
  %r140 = load i64, ptr %slot.var_type, align 8
  %r141 = call i64 @nova_rt_list_create()
  %r142 = load i64, ptr %slot.value, align 8
  %r143 = call i64 @ir_inst(i64 %r138, i64 %r139, i64 %r140, i64 %r141, i64 %r142, i64 0)
  %r144 = call i64 @ir_emit(i64 %r136, i64 %r143)
  %r145 = load i64, ptr %slot.dest, align 8
  ret i64 %r145
ret_else71:
  %r146 = load i64, ptr %slot.tag, align 8
  %r147 = getelementptr inbounds [6 x i8], ptr @.str.41, i64 0, i64 0
  %r148 = ptrtoint ptr %r147 to i64
  %t150 = call i64 @nova_rt_eq(i64 %r146, i64 %r148)
  %r149 = and i64 %t150, 1
  %t151 = icmp ne i64 %t150, 0
  br i1 %t151, label %ret_then75, label %ret_else76
ret_then75:
  %r152 = load i64, ptr %slot.b, align 8
  %r153 = load i64, ptr %slot.children, align 8
  %r154 = call i64 @nova_rt_index_get(i64 %r153, i64 0)
  %r155 = call i64 @ir_build_expr(i64 %r152, i64 %r154)
  store i64 %r155, ptr %slot.left_r, align 8
  %r156 = load i64, ptr %slot.b, align 8
  %r157 = load i64, ptr %slot.children, align 8
  %r158 = call i64 @nova_rt_index_get(i64 %r157, i64 1)
  %r159 = call i64 @ir_build_expr(i64 %r156, i64 %r158)
  store i64 %r159, ptr %slot.right_r, align 8
  %r160 = load i64, ptr %slot.b, align 8
  %r161 = call i64 @ir_fresh_reg(i64 %r160)
  store i64 %r161, ptr %slot.dest, align 8
  %r162 = load i64, ptr %slot.value, align 8
  store i64 %r162, ptr %slot.op, align 8
  %r163 = load i64, ptr %slot.op, align 8
  %r164 = getelementptr inbounds [2 x i8], ptr @.str.18, i64 0, i64 0
  %r165 = ptrtoint ptr %r164 to i64
  %t167 = call i64 @nova_rt_eq(i64 %r163, i64 %r165)
  %r166 = and i64 %t167, 1
  %t168 = icmp ne i64 %t167, 0
  br i1 %t168, label %then77, label %else78
then77:
  %r169 = load i64, ptr %slot.b, align 8
  %r170 = getelementptr inbounds [4 x i8], ptr @.str.42, i64 0, i64 0
  %r171 = ptrtoint ptr %r170 to i64
  %r172 = load i64, ptr %slot.dest, align 8
  %r173 = call i64 @ir_type_any()
  %r174 = call i64 @nova_rt_list_create()
  %r175 = load i64, ptr %slot.left_r, align 8
  %t176 = call i64 @nova_rt_list_append(i64 %r174, i64 %r175)
  %r177 = load i64, ptr %slot.right_r, align 8
  %t178 = call i64 @nova_rt_list_append(i64 %r174, i64 %r177)
  %r179 = load i64, ptr %slot.op, align 8
  %r180 = call i64 @ir_inst(i64 %r171, i64 %r172, i64 %r173, i64 %r174, i64 %r179, i64 0)
  %r181 = call i64 @ir_emit(i64 %r169, i64 %r180)
  br label %merge79
else78:
  %r182 = load i64, ptr %slot.op, align 8
  %r183 = getelementptr inbounds [2 x i8], ptr @.str.19, i64 0, i64 0
  %r184 = ptrtoint ptr %r183 to i64
  %t186 = call i64 @nova_rt_eq(i64 %r182, i64 %r184)
  %r185 = and i64 %t186, 1
  %r187 = load i64, ptr %slot.op, align 8
  %r188 = getelementptr inbounds [2 x i8], ptr @.str.20, i64 0, i64 0
  %r189 = ptrtoint ptr %r188 to i64
  %t191 = call i64 @nova_rt_eq(i64 %r187, i64 %r189)
  %r190 = and i64 %t191, 1
  br label %or_entry80
or_entry80:
  %t193 = icmp ne i64 %t186, 0
  br i1 %t193, label %or_end82, label %or_rhs81
or_rhs81:
  %r194 = load i64, ptr %slot.op, align 8
  %r195 = getelementptr inbounds [2 x i8], ptr @.str.20, i64 0, i64 0
  %r196 = ptrtoint ptr %r195 to i64
  %t198 = call i64 @nova_rt_eq(i64 %r194, i64 %r196)
  %r197 = and i64 %t198, 1
  br label %or_done83
or_done83:
  br label %or_end82
or_end82:
  %r192 = phi i64 [%t186, %or_entry80], [%t198, %or_done83]
  %r199 = load i64, ptr %slot.op, align 8
  %r200 = getelementptr inbounds [2 x i8], ptr @.str.21, i64 0, i64 0
  %r201 = ptrtoint ptr %r200 to i64
  %t203 = call i64 @nova_rt_eq(i64 %r199, i64 %r201)
  %r202 = and i64 %t203, 1
  br label %or_entry84
or_entry84:
  %t205 = icmp ne i64 %r192, 0
  br i1 %t205, label %or_end86, label %or_rhs85
or_rhs85:
  %r206 = load i64, ptr %slot.op, align 8
  %r207 = getelementptr inbounds [2 x i8], ptr @.str.21, i64 0, i64 0
  %r208 = ptrtoint ptr %r207 to i64
  %t210 = call i64 @nova_rt_eq(i64 %r206, i64 %r208)
  %r209 = and i64 %t210, 1
  br label %or_done87
or_done87:
  br label %or_end86
or_end86:
  %r204 = phi i64 [%r192, %or_entry84], [%t210, %or_done87]
  %r211 = load i64, ptr %slot.op, align 8
  %r212 = getelementptr inbounds [2 x i8], ptr @.str.22, i64 0, i64 0
  %r213 = ptrtoint ptr %r212 to i64
  %t215 = call i64 @nova_rt_eq(i64 %r211, i64 %r213)
  %r214 = and i64 %t215, 1
  br label %or_entry88
or_entry88:
  %t217 = icmp ne i64 %r204, 0
  br i1 %t217, label %or_end90, label %or_rhs89
or_rhs89:
  %r218 = load i64, ptr %slot.op, align 8
  %r219 = getelementptr inbounds [2 x i8], ptr @.str.22, i64 0, i64 0
  %r220 = ptrtoint ptr %r219 to i64
  %t222 = call i64 @nova_rt_eq(i64 %r218, i64 %r220)
  %r221 = and i64 %t222, 1
  br label %or_done91
or_done91:
  br label %or_end90
or_end90:
  %r216 = phi i64 [%r204, %or_entry88], [%t222, %or_done91]
  %t223 = icmp ne i64 %r216, 0
  br i1 %t223, label %then92, label %else93
then92:
  %r224 = load i64, ptr %slot.op, align 8
  %r225 = getelementptr inbounds [2 x i8], ptr @.str.19, i64 0, i64 0
  %r226 = ptrtoint ptr %r225 to i64
  %t228 = call i64 @nova_rt_eq(i64 %r224, i64 %r226)
  %r227 = and i64 %t228, 1
  %t229 = icmp ne i64 %t228, 0
  br i1 %t229, label %if_then95, label %if_else96
if_then95:
  %r230 = getelementptr inbounds [4 x i8], ptr @.str.43, i64 0, i64 0
  %r231 = ptrtoint ptr %r230 to i64
  br label %if_then_done98
if_then_done98:
  br label %if_merge97
if_else96:
  %r232 = load i64, ptr %slot.op, align 8
  %r233 = getelementptr inbounds [2 x i8], ptr @.str.20, i64 0, i64 0
  %r234 = ptrtoint ptr %r233 to i64
  %t236 = call i64 @nova_rt_eq(i64 %r232, i64 %r234)
  %r235 = and i64 %t236, 1
  %t237 = icmp ne i64 %t236, 0
  br i1 %t237, label %if_then99, label %if_else100
if_then99:
  %r238 = getelementptr inbounds [4 x i8], ptr @.str.44, i64 0, i64 0
  %r239 = ptrtoint ptr %r238 to i64
  br label %if_then_done102
if_then_done102:
  br label %if_merge101
if_else100:
  %r240 = load i64, ptr %slot.op, align 8
  %r241 = getelementptr inbounds [2 x i8], ptr @.str.21, i64 0, i64 0
  %r242 = ptrtoint ptr %r241 to i64
  %t244 = call i64 @nova_rt_eq(i64 %r240, i64 %r242)
  %r243 = and i64 %t244, 1
  %t245 = icmp ne i64 %t244, 0
  br i1 %t245, label %if_then103, label %if_else104
if_then103:
  %r246 = getelementptr inbounds [4 x i8], ptr @.str.45, i64 0, i64 0
  %r247 = ptrtoint ptr %r246 to i64
  br label %if_then_done106
if_then_done106:
  br label %if_merge105
if_else104:
  %r248 = getelementptr inbounds [4 x i8], ptr @.str.46, i64 0, i64 0
  %r249 = ptrtoint ptr %r248 to i64
  br label %if_else_done107
if_else_done107:
  br label %if_merge105
if_merge105:
  %r250 = phi i64 [%r247, %if_then_done106], [%r249, %if_else_done107]
  br label %if_else_done108
if_else_done108:
  br label %if_merge101
if_merge101:
  %r251 = phi i64 [%r239, %if_then_done102], [%r250, %if_else_done108]
  br label %if_else_done109
if_else_done109:
  br label %if_merge97
if_merge97:
  %r252 = phi i64 [%r231, %if_then_done98], [%r251, %if_else_done109]
  store i64 %r252, ptr %slot.ir_op, align 8
  %r253 = load i64, ptr %slot.b, align 8
  %r254 = load i64, ptr %slot.ir_op, align 8
  %r255 = load i64, ptr %slot.dest, align 8
  %r256 = call i64 @ir_type_int()
  %r257 = call i64 @nova_rt_list_create()
  %r258 = load i64, ptr %slot.left_r, align 8
  %t259 = call i64 @nova_rt_list_append(i64 %r257, i64 %r258)
  %r260 = load i64, ptr %slot.right_r, align 8
  %t261 = call i64 @nova_rt_list_append(i64 %r257, i64 %r260)
  %r262 = load i64, ptr %slot.op, align 8
  %r263 = call i64 @ir_inst(i64 %r254, i64 %r255, i64 %r256, i64 %r257, i64 %r262, i64 0)
  %r264 = call i64 @ir_emit(i64 %r253, i64 %r263)
  br label %merge94
else93:
  %r265 = load i64, ptr %slot.op, align 8
  %r266 = getelementptr inbounds [3 x i8], ptr @.str.23, i64 0, i64 0
  %r267 = ptrtoint ptr %r266 to i64
  %t269 = call i64 @nova_rt_eq(i64 %r265, i64 %r267)
  %r268 = and i64 %t269, 1
  %r270 = load i64, ptr %slot.op, align 8
  %r271 = getelementptr inbounds [3 x i8], ptr @.str.24, i64 0, i64 0
  %r272 = ptrtoint ptr %r271 to i64
  %t274 = call i64 @nova_rt_eq(i64 %r270, i64 %r272)
  %r273 = and i64 %t274, 1
  br label %or_entry110
or_entry110:
  %t276 = icmp ne i64 %t269, 0
  br i1 %t276, label %or_end112, label %or_rhs111
or_rhs111:
  %r277 = load i64, ptr %slot.op, align 8
  %r278 = getelementptr inbounds [3 x i8], ptr @.str.24, i64 0, i64 0
  %r279 = ptrtoint ptr %r278 to i64
  %t281 = call i64 @nova_rt_eq(i64 %r277, i64 %r279)
  %r280 = and i64 %t281, 1
  br label %or_done113
or_done113:
  br label %or_end112
or_end112:
  %r275 = phi i64 [%t269, %or_entry110], [%t281, %or_done113]
  %t282 = icmp ne i64 %r275, 0
  br i1 %t282, label %then114, label %else115
then114:
  %r283 = load i64, ptr %slot.op, align 8
  %r284 = getelementptr inbounds [3 x i8], ptr @.str.23, i64 0, i64 0
  %r285 = ptrtoint ptr %r284 to i64
  %t287 = call i64 @nova_rt_eq(i64 %r283, i64 %r285)
  %r286 = and i64 %t287, 1
  %t288 = icmp ne i64 %t287, 0
  br i1 %t288, label %if_then117, label %if_else118
if_then117:
  %r289 = getelementptr inbounds [3 x i8], ptr @.str.47, i64 0, i64 0
  %r290 = ptrtoint ptr %r289 to i64
  br label %if_then_done120
if_then_done120:
  br label %if_merge119
if_else118:
  %r291 = getelementptr inbounds [4 x i8], ptr @.str.48, i64 0, i64 0
  %r292 = ptrtoint ptr %r291 to i64
  br label %if_else_done121
if_else_done121:
  br label %if_merge119
if_merge119:
  %r293 = phi i64 [%r290, %if_then_done120], [%r292, %if_else_done121]
  store i64 %r293, ptr %slot.cmp_op, align 8
  %r294 = load i64, ptr %slot.b, align 8
  %r295 = load i64, ptr %slot.cmp_op, align 8
  %r296 = load i64, ptr %slot.dest, align 8
  %r297 = call i64 @ir_type_bool()
  %r298 = call i64 @nova_rt_list_create()
  %r299 = load i64, ptr %slot.left_r, align 8
  %t300 = call i64 @nova_rt_list_append(i64 %r298, i64 %r299)
  %r301 = load i64, ptr %slot.right_r, align 8
  %t302 = call i64 @nova_rt_list_append(i64 %r298, i64 %r301)
  %r303 = load i64, ptr %slot.op, align 8
  %r304 = call i64 @ir_inst(i64 %r295, i64 %r296, i64 %r297, i64 %r298, i64 %r303, i64 0)
  %r305 = call i64 @ir_emit(i64 %r294, i64 %r304)
  br label %merge116
else115:
  %r306 = load i64, ptr %slot.op, align 8
  %r307 = getelementptr inbounds [2 x i8], ptr @.str.25, i64 0, i64 0
  %r308 = ptrtoint ptr %r307 to i64
  %t310 = call i64 @nova_rt_eq(i64 %r306, i64 %r308)
  %r309 = and i64 %t310, 1
  %r311 = load i64, ptr %slot.op, align 8
  %r312 = getelementptr inbounds [3 x i8], ptr @.str.26, i64 0, i64 0
  %r313 = ptrtoint ptr %r312 to i64
  %t315 = call i64 @nova_rt_eq(i64 %r311, i64 %r313)
  %r314 = and i64 %t315, 1
  br label %or_entry122
or_entry122:
  %t317 = icmp ne i64 %t310, 0
  br i1 %t317, label %or_end124, label %or_rhs123
or_rhs123:
  %r318 = load i64, ptr %slot.op, align 8
  %r319 = getelementptr inbounds [3 x i8], ptr @.str.26, i64 0, i64 0
  %r320 = ptrtoint ptr %r319 to i64
  %t322 = call i64 @nova_rt_eq(i64 %r318, i64 %r320)
  %r321 = and i64 %t322, 1
  br label %or_done125
or_done125:
  br label %or_end124
or_end124:
  %r316 = phi i64 [%t310, %or_entry122], [%t322, %or_done125]
  %r323 = load i64, ptr %slot.op, align 8
  %r324 = getelementptr inbounds [2 x i8], ptr @.str.27, i64 0, i64 0
  %r325 = ptrtoint ptr %r324 to i64
  %t327 = call i64 @nova_rt_eq(i64 %r323, i64 %r325)
  %r326 = and i64 %t327, 1
  br label %or_entry126
or_entry126:
  %t329 = icmp ne i64 %r316, 0
  br i1 %t329, label %or_end128, label %or_rhs127
or_rhs127:
  %r330 = load i64, ptr %slot.op, align 8
  %r331 = getelementptr inbounds [2 x i8], ptr @.str.27, i64 0, i64 0
  %r332 = ptrtoint ptr %r331 to i64
  %t334 = call i64 @nova_rt_eq(i64 %r330, i64 %r332)
  %r333 = and i64 %t334, 1
  br label %or_done129
or_done129:
  br label %or_end128
or_end128:
  %r328 = phi i64 [%r316, %or_entry126], [%t334, %or_done129]
  %r335 = load i64, ptr %slot.op, align 8
  %r336 = getelementptr inbounds [3 x i8], ptr @.str.28, i64 0, i64 0
  %r337 = ptrtoint ptr %r336 to i64
  %t339 = call i64 @nova_rt_eq(i64 %r335, i64 %r337)
  %r338 = and i64 %t339, 1
  br label %or_entry130
or_entry130:
  %t341 = icmp ne i64 %r328, 0
  br i1 %t341, label %or_end132, label %or_rhs131
or_rhs131:
  %r342 = load i64, ptr %slot.op, align 8
  %r343 = getelementptr inbounds [3 x i8], ptr @.str.28, i64 0, i64 0
  %r344 = ptrtoint ptr %r343 to i64
  %t346 = call i64 @nova_rt_eq(i64 %r342, i64 %r344)
  %r345 = and i64 %t346, 1
  br label %or_done133
or_done133:
  br label %or_end132
or_end132:
  %r340 = phi i64 [%r328, %or_entry130], [%t346, %or_done133]
  %t347 = icmp ne i64 %r340, 0
  br i1 %t347, label %then134, label %else135
then134:
  %r348 = load i64, ptr %slot.op, align 8
  %r349 = getelementptr inbounds [2 x i8], ptr @.str.25, i64 0, i64 0
  %r350 = ptrtoint ptr %r349 to i64
  %t352 = call i64 @nova_rt_eq(i64 %r348, i64 %r350)
  %r351 = and i64 %t352, 1
  %t353 = icmp ne i64 %t352, 0
  br i1 %t353, label %if_then137, label %if_else138
if_then137:
  %r354 = getelementptr inbounds [3 x i8], ptr @.str.49, i64 0, i64 0
  %r355 = ptrtoint ptr %r354 to i64
  br label %if_then_done140
if_then_done140:
  br label %if_merge139
if_else138:
  %r356 = load i64, ptr %slot.op, align 8
  %r357 = getelementptr inbounds [3 x i8], ptr @.str.26, i64 0, i64 0
  %r358 = ptrtoint ptr %r357 to i64
  %t360 = call i64 @nova_rt_eq(i64 %r356, i64 %r358)
  %r359 = and i64 %t360, 1
  %t361 = icmp ne i64 %t360, 0
  br i1 %t361, label %if_then141, label %if_else142
if_then141:
  %r362 = getelementptr inbounds [3 x i8], ptr @.str.50, i64 0, i64 0
  %r363 = ptrtoint ptr %r362 to i64
  br label %if_then_done144
if_then_done144:
  br label %if_merge143
if_else142:
  %r364 = load i64, ptr %slot.op, align 8
  %r365 = getelementptr inbounds [2 x i8], ptr @.str.27, i64 0, i64 0
  %r366 = ptrtoint ptr %r365 to i64
  %t368 = call i64 @nova_rt_eq(i64 %r364, i64 %r366)
  %r367 = and i64 %t368, 1
  %t369 = icmp ne i64 %t368, 0
  br i1 %t369, label %if_then145, label %if_else146
if_then145:
  %r370 = getelementptr inbounds [3 x i8], ptr @.str.51, i64 0, i64 0
  %r371 = ptrtoint ptr %r370 to i64
  br label %if_then_done148
if_then_done148:
  br label %if_merge147
if_else146:
  %r372 = getelementptr inbounds [3 x i8], ptr @.str.52, i64 0, i64 0
  %r373 = ptrtoint ptr %r372 to i64
  br label %if_else_done149
if_else_done149:
  br label %if_merge147
if_merge147:
  %r374 = phi i64 [%r371, %if_then_done148], [%r373, %if_else_done149]
  br label %if_else_done150
if_else_done150:
  br label %if_merge143
if_merge143:
  %r375 = phi i64 [%r363, %if_then_done144], [%r374, %if_else_done150]
  br label %if_else_done151
if_else_done151:
  br label %if_merge139
if_merge139:
  %r376 = phi i64 [%r355, %if_then_done140], [%r375, %if_else_done151]
  store i64 %r376, ptr %slot.cmp_op, align 8
  %r377 = load i64, ptr %slot.b, align 8
  %r378 = load i64, ptr %slot.cmp_op, align 8
  %r379 = load i64, ptr %slot.dest, align 8
  %r380 = call i64 @ir_type_bool()
  %r381 = call i64 @nova_rt_list_create()
  %r382 = load i64, ptr %slot.left_r, align 8
  %t383 = call i64 @nova_rt_list_append(i64 %r381, i64 %r382)
  %r384 = load i64, ptr %slot.right_r, align 8
  %t385 = call i64 @nova_rt_list_append(i64 %r381, i64 %r384)
  %r386 = load i64, ptr %slot.op, align 8
  %r387 = call i64 @ir_inst(i64 %r378, i64 %r379, i64 %r380, i64 %r381, i64 %r386, i64 0)
  %r388 = call i64 @ir_emit(i64 %r377, i64 %r387)
  br label %merge136
else135:
  %r389 = load i64, ptr %slot.op, align 8
  %r390 = getelementptr inbounds [4 x i8], ptr @.str.29, i64 0, i64 0
  %r391 = ptrtoint ptr %r390 to i64
  %t393 = call i64 @nova_rt_eq(i64 %r389, i64 %r391)
  %r392 = and i64 %t393, 1
  %t394 = icmp ne i64 %t393, 0
  br i1 %t394, label %then152, label %else153
then152:
  %r395 = load i64, ptr %slot.b, align 8
  %r396 = getelementptr inbounds [4 x i8], ptr @.str.29, i64 0, i64 0
  %r397 = ptrtoint ptr %r396 to i64
  %r398 = load i64, ptr %slot.dest, align 8
  %r399 = call i64 @ir_type_bool()
  %r400 = call i64 @nova_rt_list_create()
  %r401 = load i64, ptr %slot.left_r, align 8
  %t402 = call i64 @nova_rt_list_append(i64 %r400, i64 %r401)
  %r403 = load i64, ptr %slot.right_r, align 8
  %t404 = call i64 @nova_rt_list_append(i64 %r400, i64 %r403)
  %r405 = getelementptr inbounds [1 x i8], ptr @.str.1, i64 0, i64 0
  %r406 = ptrtoint ptr %r405 to i64
  %r407 = call i64 @ir_inst(i64 %r397, i64 %r398, i64 %r399, i64 %r400, i64 %r406, i64 0)
  %r408 = call i64 @ir_emit(i64 %r395, i64 %r407)
  br label %merge154
else153:
  %r409 = load i64, ptr %slot.op, align 8
  %r410 = getelementptr inbounds [3 x i8], ptr @.str.30, i64 0, i64 0
  %r411 = ptrtoint ptr %r410 to i64
  %t413 = call i64 @nova_rt_eq(i64 %r409, i64 %r411)
  %r412 = and i64 %t413, 1
  %t414 = icmp ne i64 %t413, 0
  br i1 %t414, label %then155, label %else156
then155:
  %r415 = load i64, ptr %slot.b, align 8
  %r416 = getelementptr inbounds [3 x i8], ptr @.str.30, i64 0, i64 0
  %r417 = ptrtoint ptr %r416 to i64
  %r418 = load i64, ptr %slot.dest, align 8
  %r419 = call i64 @ir_type_bool()
  %r420 = call i64 @nova_rt_list_create()
  %r421 = load i64, ptr %slot.left_r, align 8
  %t422 = call i64 @nova_rt_list_append(i64 %r420, i64 %r421)
  %r423 = load i64, ptr %slot.right_r, align 8
  %t424 = call i64 @nova_rt_list_append(i64 %r420, i64 %r423)
  %r425 = getelementptr inbounds [1 x i8], ptr @.str.1, i64 0, i64 0
  %r426 = ptrtoint ptr %r425 to i64
  %r427 = call i64 @ir_inst(i64 %r417, i64 %r418, i64 %r419, i64 %r420, i64 %r426, i64 0)
  %r428 = call i64 @ir_emit(i64 %r415, i64 %r427)
  br label %merge157
else156:
  %r429 = load i64, ptr %slot.b, align 8
  %r430 = getelementptr inbounds [5 x i8], ptr @.str.53, i64 0, i64 0
  %r431 = ptrtoint ptr %r430 to i64
  %r432 = load i64, ptr %slot.dest, align 8
  %r433 = call i64 @ir_type_any()
  %r434 = call i64 @nova_rt_list_create()
  %r435 = load i64, ptr %slot.left_r, align 8
  %t436 = call i64 @nova_rt_list_append(i64 %r434, i64 %r435)
  %r437 = load i64, ptr %slot.right_r, align 8
  %t438 = call i64 @nova_rt_list_append(i64 %r434, i64 %r437)
  %r439 = getelementptr inbounds [12 x i8], ptr @.str.54, i64 0, i64 0
  %r440 = ptrtoint ptr %r439 to i64
  %r441 = call i64 @ir_inst(i64 %r431, i64 %r432, i64 %r433, i64 %r434, i64 %r440, i64 0)
  %r442 = call i64 @ir_emit(i64 %r429, i64 %r441)
  br label %merge157
merge157:
  br label %merge154
merge154:
  br label %merge136
merge136:
  br label %merge116
merge116:
  br label %merge94
merge94:
  br label %merge79
merge79:
  %r443 = load i64, ptr %slot.dest, align 8
  ret i64 %r443
ret_else76:
  %r444 = load i64, ptr %slot.tag, align 8
  %r445 = getelementptr inbounds [6 x i8], ptr @.str.55, i64 0, i64 0
  %r446 = ptrtoint ptr %r445 to i64
  %t448 = call i64 @nova_rt_eq(i64 %r444, i64 %r446)
  %r447 = and i64 %t448, 1
  %t449 = icmp ne i64 %t448, 0
  br i1 %t449, label %ret_then158, label %ret_else159
ret_then158:
  %r450 = load i64, ptr %slot.b, align 8
  %r451 = load i64, ptr %slot.children, align 8
  %r452 = call i64 @nova_rt_index_get(i64 %r451, i64 0)
  %r453 = call i64 @ir_build_expr(i64 %r450, i64 %r452)
  store i64 %r453, ptr %slot.operand_r, align 8
  %r454 = load i64, ptr %slot.b, align 8
  %r455 = call i64 @ir_fresh_reg(i64 %r454)
  store i64 %r455, ptr %slot.dest, align 8
  %r456 = load i64, ptr %slot.value, align 8
  %r457 = getelementptr inbounds [2 x i8], ptr @.str.19, i64 0, i64 0
  %r458 = ptrtoint ptr %r457 to i64
  %t460 = call i64 @nova_rt_eq(i64 %r456, i64 %r458)
  %r459 = and i64 %t460, 1
  %t461 = icmp ne i64 %t460, 0
  br i1 %t461, label %then160, label %else161
then160:
  %r462 = load i64, ptr %slot.b, align 8
  %r463 = getelementptr inbounds [4 x i8], ptr @.str.56, i64 0, i64 0
  %r464 = ptrtoint ptr %r463 to i64
  %r465 = load i64, ptr %slot.dest, align 8
  %r466 = call i64 @ir_type_int()
  %r467 = call i64 @nova_rt_list_create()
  %r468 = load i64, ptr %slot.operand_r, align 8
  %t469 = call i64 @nova_rt_list_append(i64 %r467, i64 %r468)
  %r470 = getelementptr inbounds [1 x i8], ptr @.str.1, i64 0, i64 0
  %r471 = ptrtoint ptr %r470 to i64
  %r472 = call i64 @ir_inst(i64 %r464, i64 %r465, i64 %r466, i64 %r467, i64 %r471, i64 0)
  %r473 = call i64 @ir_emit(i64 %r462, i64 %r472)
  br label %merge162
else161:
  %r474 = load i64, ptr %slot.value, align 8
  %r475 = getelementptr inbounds [4 x i8], ptr @.str.57, i64 0, i64 0
  %r476 = ptrtoint ptr %r475 to i64
  %t478 = call i64 @nova_rt_eq(i64 %r474, i64 %r476)
  %r477 = and i64 %t478, 1
  %t479 = icmp ne i64 %t478, 0
  br i1 %t479, label %then163, label %else164
then163:
  %r480 = load i64, ptr %slot.b, align 8
  %r481 = getelementptr inbounds [4 x i8], ptr @.str.57, i64 0, i64 0
  %r482 = ptrtoint ptr %r481 to i64
  %r483 = load i64, ptr %slot.dest, align 8
  %r484 = call i64 @ir_type_bool()
  %r485 = call i64 @nova_rt_list_create()
  %r486 = load i64, ptr %slot.operand_r, align 8
  %t487 = call i64 @nova_rt_list_append(i64 %r485, i64 %r486)
  %r488 = getelementptr inbounds [1 x i8], ptr @.str.1, i64 0, i64 0
  %r489 = ptrtoint ptr %r488 to i64
  %r490 = call i64 @ir_inst(i64 %r482, i64 %r483, i64 %r484, i64 %r485, i64 %r489, i64 0)
  %r491 = call i64 @ir_emit(i64 %r480, i64 %r490)
  br label %merge165
else164:
  %r492 = load i64, ptr %slot.b, align 8
  %r493 = getelementptr inbounds [4 x i8], ptr @.str.56, i64 0, i64 0
  %r494 = ptrtoint ptr %r493 to i64
  %r495 = load i64, ptr %slot.dest, align 8
  %r496 = call i64 @ir_type_any()
  %r497 = call i64 @nova_rt_list_create()
  %r498 = load i64, ptr %slot.operand_r, align 8
  %t499 = call i64 @nova_rt_list_append(i64 %r497, i64 %r498)
  %r500 = load i64, ptr %slot.value, align 8
  %r501 = call i64 @ir_inst(i64 %r494, i64 %r495, i64 %r496, i64 %r497, i64 %r500, i64 0)
  %r502 = call i64 @ir_emit(i64 %r492, i64 %r501)
  br label %merge165
merge165:
  br label %merge162
merge162:
  %r503 = load i64, ptr %slot.dest, align 8
  ret i64 %r503
ret_else159:
  %r504 = load i64, ptr %slot.tag, align 8
  %r505 = getelementptr inbounds [5 x i8], ptr @.str.53, i64 0, i64 0
  %r506 = ptrtoint ptr %r505 to i64
  %t508 = call i64 @nova_rt_eq(i64 %r504, i64 %r506)
  %r507 = and i64 %t508, 1
  %t509 = icmp ne i64 %t508, 0
  br i1 %t509, label %ret_then166, label %ret_else167
ret_then166:
  %r510 = getelementptr inbounds [1 x i8], ptr @.str.1, i64 0, i64 0
  %r511 = ptrtoint ptr %r510 to i64
  store i64 %r511, ptr %slot.fn_name, align 8
  %r512 = load i64, ptr %slot.children, align 8
  %r513 = call i64 @nova_rt_index_get(i64 %r512, i64 0)
  %t514 = inttoptr i64 %r513 to ptr
  %t515 = getelementptr i64, ptr %t514, i64 0
  %r516 = load i64, ptr %t515, align 8
  store i64 %r516, ptr %slot.ct, align 8
  %t517 = getelementptr i64, ptr %t514, i64 1
  %r518 = load i64, ptr %t517, align 8
  store i64 %r518, ptr %slot.cv, align 8
  %t519 = getelementptr i64, ptr %t514, i64 2
  %r520 = load i64, ptr %t519, align 8
  store i64 %r520, ptr %slot.cn, align 8
  %t521 = getelementptr i64, ptr %t514, i64 3
  %r522 = load i64, ptr %t521, align 8
  store i64 %r522, ptr %slot.cc, align 8
  %t523 = getelementptr i64, ptr %t514, i64 4
  %r524 = load i64, ptr %t523, align 8
  store i64 %r524, ptr %slot.cf, align 8
  %r525 = load i64, ptr %slot.cv, align 8
  store i64 %r525, ptr %slot.fn_name, align 8
  %r526 = call i64 @nova_rt_list_create()
  store i64 %r526, ptr %slot.call_args, align 8
  store i64 1, ptr %slot.i, align 8
  br label %while_hdr168
while_hdr168:
  %r527 = load i64, ptr %slot.i, align 8
  %r528 = load i64, ptr %slot.children, align 8
  %r529 = call i64 @nova_rt_len_any(i64 %r528)
  %t531 = icmp slt i64 %r527, %r529
  %r530 = zext i1 %t531 to i64
  %t532 = icmp ne i64 %r530, 0
  br i1 %t532, label %while_body169, label %while_exit170
while_body169:
  %r533 = load i64, ptr %slot.b, align 8
  %r534 = load i64, ptr %slot.children, align 8
  %r535 = load i64, ptr %slot.i, align 8
  %r536 = call i64 @nova_rt_index_get(i64 %r534, i64 %r535)
  %r537 = call i64 @ir_build_expr(i64 %r533, i64 %r536)
  store i64 %r537, ptr %slot.arg_r, align 8
  %r538 = load i64, ptr %slot.call_args, align 8
  %r539 = load i64, ptr %slot.arg_r, align 8
  %r540 = call i64 @nova_rt_list_append(i64 %r538, i64 %r539)
  %r541 = load i64, ptr %slot.i, align 8
  %r542 = call i64 @nova_rt_add(i64 %r541, i64 1)
  store i64 %r542, ptr %slot.i, align 8
  br label %while_hdr168
while_exit170:
  %r543 = load i64, ptr %slot.b, align 8
  %r544 = call i64 @ir_fresh_reg(i64 %r543)
  store i64 %r544, ptr %slot.dest, align 8
  %r545 = getelementptr inbounds [12 x i8], ptr @.str.58, i64 0, i64 0
  %r546 = ptrtoint ptr %r545 to i64
  store i64 %r546, ptr %slot.eff, align 8
  %r547 = load i64, ptr %slot.fn_name, align 8
  %r548 = getelementptr inbounds [4 x i8], ptr @.str.59, i64 0, i64 0
  %r549 = ptrtoint ptr %r548 to i64
  %t551 = call i64 @nova_rt_eq(i64 %r547, i64 %r549)
  %r550 = and i64 %t551, 1
  %r552 = load i64, ptr %slot.fn_name, align 8
  %r553 = getelementptr inbounds [4 x i8], ptr @.str.4, i64 0, i64 0
  %r554 = ptrtoint ptr %r553 to i64
  %t556 = call i64 @nova_rt_eq(i64 %r552, i64 %r554)
  %r555 = and i64 %t556, 1
  br label %or_entry171
or_entry171:
  %t558 = icmp ne i64 %t551, 0
  br i1 %t558, label %or_end173, label %or_rhs172
or_rhs172:
  %r559 = load i64, ptr %slot.fn_name, align 8
  %r560 = getelementptr inbounds [4 x i8], ptr @.str.4, i64 0, i64 0
  %r561 = ptrtoint ptr %r560 to i64
  %t563 = call i64 @nova_rt_eq(i64 %r559, i64 %r561)
  %r562 = and i64 %t563, 1
  br label %or_done174
or_done174:
  br label %or_end173
or_end173:
  %r557 = phi i64 [%t551, %or_entry171], [%t563, %or_done174]
  %r564 = load i64, ptr %slot.fn_name, align 8
  %r565 = getelementptr inbounds [4 x i8], ptr @.str.0, i64 0, i64 0
  %r566 = ptrtoint ptr %r565 to i64
  %t568 = call i64 @nova_rt_eq(i64 %r564, i64 %r566)
  %r567 = and i64 %t568, 1
  br label %or_entry175
or_entry175:
  %t570 = icmp ne i64 %r557, 0
  br i1 %t570, label %or_end177, label %or_rhs176
or_rhs176:
  %r571 = load i64, ptr %slot.fn_name, align 8
  %r572 = getelementptr inbounds [4 x i8], ptr @.str.0, i64 0, i64 0
  %r573 = ptrtoint ptr %r572 to i64
  %t575 = call i64 @nova_rt_eq(i64 %r571, i64 %r573)
  %r574 = and i64 %t575, 1
  br label %or_done178
or_done178:
  br label %or_end177
or_end177:
  %r569 = phi i64 [%r557, %or_entry175], [%t575, %or_done178]
  %r576 = load i64, ptr %slot.fn_name, align 8
  %r577 = getelementptr inbounds [4 x i8], ptr @.str.60, i64 0, i64 0
  %r578 = ptrtoint ptr %r577 to i64
  %t580 = call i64 @nova_rt_eq(i64 %r576, i64 %r578)
  %r579 = and i64 %t580, 1
  br label %or_entry179
or_entry179:
  %t582 = icmp ne i64 %r569, 0
  br i1 %t582, label %or_end181, label %or_rhs180
or_rhs180:
  %r583 = load i64, ptr %slot.fn_name, align 8
  %r584 = getelementptr inbounds [4 x i8], ptr @.str.60, i64 0, i64 0
  %r585 = ptrtoint ptr %r584 to i64
  %t587 = call i64 @nova_rt_eq(i64 %r583, i64 %r585)
  %r586 = and i64 %t587, 1
  br label %or_done182
or_done182:
  br label %or_end181
or_end181:
  %r581 = phi i64 [%r569, %or_entry179], [%t587, %or_done182]
  %r588 = load i64, ptr %slot.fn_name, align 8
  %r589 = getelementptr inbounds [4 x i8], ptr @.str.61, i64 0, i64 0
  %r590 = ptrtoint ptr %r589 to i64
  %t592 = call i64 @nova_rt_eq(i64 %r588, i64 %r590)
  %r591 = and i64 %t592, 1
  br label %or_entry183
or_entry183:
  %t594 = icmp ne i64 %r581, 0
  br i1 %t594, label %or_end185, label %or_rhs184
or_rhs184:
  %r595 = load i64, ptr %slot.fn_name, align 8
  %r596 = getelementptr inbounds [4 x i8], ptr @.str.61, i64 0, i64 0
  %r597 = ptrtoint ptr %r596 to i64
  %t599 = call i64 @nova_rt_eq(i64 %r595, i64 %r597)
  %r598 = and i64 %t599, 1
  br label %or_done186
or_done186:
  br label %or_end185
or_end185:
  %r593 = phi i64 [%r581, %or_entry183], [%t599, %or_done186]
  %t600 = icmp ne i64 %r593, 0
  br i1 %t600, label %then187, label %else188
then187:
  %r601 = getelementptr inbounds [5 x i8], ptr @.str.13, i64 0, i64 0
  %r602 = ptrtoint ptr %r601 to i64
  store i64 %r602, ptr %slot.eff, align 8
  br label %merge189
else188:
  br label %merge189
merge189:
  %r603 = load i64, ptr %slot.b, align 8
  %r604 = getelementptr inbounds [5 x i8], ptr @.str.53, i64 0, i64 0
  %r605 = ptrtoint ptr %r604 to i64
  %r606 = load i64, ptr %slot.dest, align 8
  %r607 = call i64 @ir_type_any()
  %r608 = load i64, ptr %slot.call_args, align 8
  %r609 = load i64, ptr %slot.fn_name, align 8
  %r610 = load i64, ptr %slot.eff, align 8
  %r611 = call i64 @ir_inst_effect(i64 %r605, i64 %r606, i64 %r607, i64 %r608, i64 %r609, i64 0, i64 %r610)
  %r612 = call i64 @ir_emit(i64 %r603, i64 %r611)
  %r613 = load i64, ptr %slot.dest, align 8
  ret i64 %r613
ret_else167:
  %r614 = load i64, ptr %slot.tag, align 8
  %r615 = getelementptr inbounds [6 x i8], ptr @.str.62, i64 0, i64 0
  %r616 = ptrtoint ptr %r615 to i64
  %t618 = call i64 @nova_rt_eq(i64 %r614, i64 %r616)
  %r617 = and i64 %t618, 1
  %t619 = icmp ne i64 %t618, 0
  br i1 %t619, label %ret_then190, label %ret_else191
ret_then190:
  %r620 = load i64, ptr %slot.b, align 8
  %r621 = load i64, ptr %slot.children, align 8
  %r622 = call i64 @nova_rt_index_get(i64 %r621, i64 0)
  %r623 = call i64 @ir_build_expr(i64 %r620, i64 %r622)
  store i64 %r623, ptr %slot.target_r, align 8
  %r624 = load i64, ptr %slot.b, align 8
  %r625 = load i64, ptr %slot.children, align 8
  %r626 = call i64 @nova_rt_index_get(i64 %r625, i64 1)
  %r627 = call i64 @ir_build_expr(i64 %r624, i64 %r626)
  store i64 %r627, ptr %slot.idx_r, align 8
  %r628 = load i64, ptr %slot.b, align 8
  %r629 = call i64 @ir_fresh_reg(i64 %r628)
  store i64 %r629, ptr %slot.dest, align 8
  %r630 = load i64, ptr %slot.b, align 8
  %r631 = getelementptr inbounds [10 x i8], ptr @.str.63, i64 0, i64 0
  %r632 = ptrtoint ptr %r631 to i64
  %r633 = load i64, ptr %slot.dest, align 8
  %r634 = call i64 @ir_type_any()
  %r635 = call i64 @nova_rt_list_create()
  %r636 = load i64, ptr %slot.target_r, align 8
  %t637 = call i64 @nova_rt_list_append(i64 %r635, i64 %r636)
  %r638 = load i64, ptr %slot.idx_r, align 8
  %t639 = call i64 @nova_rt_list_append(i64 %r635, i64 %r638)
  %r640 = getelementptr inbounds [1 x i8], ptr @.str.1, i64 0, i64 0
  %r641 = ptrtoint ptr %r640 to i64
  %r642 = call i64 @ir_inst(i64 %r632, i64 %r633, i64 %r634, i64 %r635, i64 %r641, i64 0)
  %r643 = call i64 @ir_emit(i64 %r630, i64 %r642)
  %r644 = load i64, ptr %slot.dest, align 8
  ret i64 %r644
ret_else191:
  %r645 = load i64, ptr %slot.tag, align 8
  %r646 = getelementptr inbounds [7 x i8], ptr @.str.64, i64 0, i64 0
  %r647 = ptrtoint ptr %r646 to i64
  %t649 = call i64 @nova_rt_eq(i64 %r645, i64 %r647)
  %r648 = and i64 %t649, 1
  %t650 = icmp ne i64 %t649, 0
  br i1 %t650, label %ret_then192, label %ret_else193
ret_then192:
  %r651 = load i64, ptr %slot.b, align 8
  %r652 = load i64, ptr %slot.children, align 8
  %r653 = call i64 @nova_rt_index_get(i64 %r652, i64 0)
  %r654 = call i64 @ir_build_expr(i64 %r651, i64 %r653)
  store i64 %r654, ptr %slot.target_r, align 8
  %r655 = load i64, ptr %slot.b, align 8
  %r656 = call i64 @ir_fresh_reg(i64 %r655)
  store i64 %r656, ptr %slot.dest, align 8
  %r657 = load i64, ptr %slot.b, align 8
  %r658 = getelementptr inbounds [10 x i8], ptr @.str.65, i64 0, i64 0
  %r659 = ptrtoint ptr %r658 to i64
  %r660 = load i64, ptr %slot.dest, align 8
  %r661 = call i64 @ir_type_any()
  %r662 = call i64 @nova_rt_list_create()
  %r663 = load i64, ptr %slot.target_r, align 8
  %t664 = call i64 @nova_rt_list_append(i64 %r662, i64 %r663)
  %r665 = load i64, ptr %slot.value, align 8
  %r666 = load i64, ptr %slot.num, align 8
  %r667 = call i64 @ir_inst(i64 %r659, i64 %r660, i64 %r661, i64 %r662, i64 %r665, i64 %r666)
  %r668 = call i64 @ir_emit(i64 %r657, i64 %r667)
  %r669 = load i64, ptr %slot.dest, align 8
  ret i64 %r669
ret_else193:
  %r670 = load i64, ptr %slot.tag, align 8
  %r671 = getelementptr inbounds [5 x i8], ptr @.str.7, i64 0, i64 0
  %r672 = ptrtoint ptr %r671 to i64
  %t674 = call i64 @nova_rt_eq(i64 %r670, i64 %r672)
  %r673 = and i64 %t674, 1
  %t675 = icmp ne i64 %t674, 0
  br i1 %t675, label %ret_then194, label %ret_else195
ret_then194:
  %r676 = call i64 @nova_rt_list_create()
  store i64 %r676, ptr %slot.elem_regs, align 8
  %r677 = load i64, ptr %slot.children, align 8
  %r678 = call i64 @nova_rt_len_any(i64 %r677)
  %slot.__for_idx_196 = alloca i64, align 8
  store i64 0, ptr %slot.__for_idx_196, align 8
  br label %for_hdr196
for_hdr196:
  %r679 = load i64, ptr %slot.__for_idx_196, align 8
  %t680 = icmp slt i64 %r679, %r678
  br i1 %t680, label %for_body197, label %for_exit198
for_body197:
  %r681 = call i64 @nova_rt_index_get(i64 %r677, i64 %r679)
  store i64 %r681, ptr %slot.elem, align 8
  %r682 = load i64, ptr %slot.b, align 8
  %r683 = load i64, ptr %slot.elem, align 8
  %r684 = call i64 @ir_build_expr(i64 %r682, i64 %r683)
  store i64 %r684, ptr %slot.er, align 8
  %r685 = load i64, ptr %slot.elem_regs, align 8
  %r686 = load i64, ptr %slot.er, align 8
  %r687 = call i64 @nova_rt_list_append(i64 %r685, i64 %r686)
  %r689 = load i64, ptr %slot.__for_idx_196, align 8
  %r688 = add i64 %r689, 1
  store i64 %r688, ptr %slot.__for_idx_196, align 8
  br label %for_hdr196
for_exit198:
  %r690 = load i64, ptr %slot.b, align 8
  %r691 = call i64 @ir_fresh_reg(i64 %r690)
  store i64 %r691, ptr %slot.dest, align 8
  %r692 = load i64, ptr %slot.b, align 8
  %r693 = getelementptr inbounds [10 x i8], ptr @.str.66, i64 0, i64 0
  %r694 = ptrtoint ptr %r693 to i64
  %r695 = load i64, ptr %slot.dest, align 8
  %r696 = call i64 @ir_type_any()
  %r697 = call i64 @ir_type_list(i64 %r696)
  %r698 = load i64, ptr %slot.elem_regs, align 8
  %r699 = getelementptr inbounds [1 x i8], ptr @.str.1, i64 0, i64 0
  %r700 = ptrtoint ptr %r699 to i64
  %r701 = call i64 @ir_inst(i64 %r694, i64 %r695, i64 %r697, i64 %r698, i64 %r700, i64 0)
  %r702 = call i64 @ir_emit(i64 %r692, i64 %r701)
  %r703 = load i64, ptr %slot.dest, align 8
  ret i64 %r703
ret_else195:
  %r704 = load i64, ptr %slot.tag, align 8
  %r705 = getelementptr inbounds [5 x i8], ptr @.str.8, i64 0, i64 0
  %r706 = ptrtoint ptr %r705 to i64
  %t708 = call i64 @nova_rt_eq(i64 %r704, i64 %r706)
  %r707 = and i64 %t708, 1
  %t709 = icmp ne i64 %t708, 0
  br i1 %t709, label %ret_then199, label %ret_else200
ret_then199:
  %r710 = load i64, ptr %slot.b, align 8
  %r711 = call i64 @ir_fresh_reg(i64 %r710)
  store i64 %r711, ptr %slot.dest, align 8
  %r712 = load i64, ptr %slot.b, align 8
  %r713 = getelementptr inbounds [10 x i8], ptr @.str.67, i64 0, i64 0
  %r714 = ptrtoint ptr %r713 to i64
  %r715 = load i64, ptr %slot.dest, align 8
  %r716 = call i64 @ir_type_any()
  %r717 = call i64 @ir_type_any()
  %r718 = call i64 @ir_type_dict(i64 %r716, i64 %r717)
  %r719 = call i64 @nova_rt_list_create()
  %r720 = getelementptr inbounds [1 x i8], ptr @.str.1, i64 0, i64 0
  %r721 = ptrtoint ptr %r720 to i64
  %r722 = call i64 @ir_inst(i64 %r714, i64 %r715, i64 %r718, i64 %r719, i64 %r721, i64 0)
  %r723 = call i64 @ir_emit(i64 %r712, i64 %r722)
  %r724 = load i64, ptr %slot.dest, align 8
  ret i64 %r724
ret_else200:
  %r725 = load i64, ptr %slot.tag, align 8
  %r726 = getelementptr inbounds [5 x i8], ptr @.str.68, i64 0, i64 0
  %r727 = ptrtoint ptr %r726 to i64
  %t729 = call i64 @nova_rt_eq(i64 %r725, i64 %r727)
  %r728 = and i64 %t729, 1
  %t730 = icmp ne i64 %t729, 0
  br i1 %t730, label %ret_then201, label %ret_else202
ret_then201:
  %r731 = load i64, ptr %slot.value, align 8
  store i64 %r731, ptr %slot.struct_name, align 8
  %r732 = call i64 @nova_rt_list_create()
  store i64 %r732, ptr %slot.field_regs, align 8
  %r733 = load i64, ptr %slot.children, align 8
  %r734 = call i64 @nova_rt_len_any(i64 %r733)
  %slot.__for_idx_203 = alloca i64, align 8
  store i64 0, ptr %slot.__for_idx_203, align 8
  br label %for_hdr203
for_hdr203:
  %r735 = load i64, ptr %slot.__for_idx_203, align 8
  %t736 = icmp slt i64 %r735, %r734
  br i1 %t736, label %for_body204, label %for_exit205
for_body204:
  %r737 = call i64 @nova_rt_index_get(i64 %r733, i64 %r735)
  store i64 %r737, ptr %slot.arg, align 8
  %r738 = load i64, ptr %slot.b, align 8
  %r739 = load i64, ptr %slot.arg, align 8
  %r740 = call i64 @ir_build_expr(i64 %r738, i64 %r739)
  store i64 %r740, ptr %slot.ar, align 8
  %r741 = load i64, ptr %slot.field_regs, align 8
  %r742 = load i64, ptr %slot.ar, align 8
  %r743 = call i64 @nova_rt_list_append(i64 %r741, i64 %r742)
  %r745 = load i64, ptr %slot.__for_idx_203, align 8
  %r744 = add i64 %r745, 1
  store i64 %r744, ptr %slot.__for_idx_203, align 8
  br label %for_hdr203
for_exit205:
  %r746 = load i64, ptr %slot.b, align 8
  %r747 = call i64 @ir_fresh_reg(i64 %r746)
  store i64 %r747, ptr %slot.dest, align 8
  %r748 = load i64, ptr %slot.b, align 8
  %r749 = getelementptr inbounds [12 x i8], ptr @.str.69, i64 0, i64 0
  %r750 = ptrtoint ptr %r749 to i64
  %r751 = load i64, ptr %slot.dest, align 8
  %r752 = load i64, ptr %slot.struct_name, align 8
  %r753 = call i64 @nova_rt_list_create()
  %r754 = call i64 @ir_type_struct(i64 %r752, i64 %r753)
  %r755 = load i64, ptr %slot.field_regs, align 8
  %r756 = load i64, ptr %slot.struct_name, align 8
  %r757 = load i64, ptr %slot.children, align 8
  %r758 = call i64 @nova_rt_len_any(i64 %r757)
  %r759 = call i64 @ir_inst(i64 %r750, i64 %r751, i64 %r754, i64 %r755, i64 %r756, i64 %r758)
  %r760 = call i64 @ir_emit(i64 %r748, i64 %r759)
  %r761 = load i64, ptr %slot.dest, align 8
  ret i64 %r761
ret_else202:
  %r762 = load i64, ptr %slot.b, align 8
  %r763 = call i64 @ir_fresh_reg(i64 %r762)
  store i64 %r763, ptr %slot.dest, align 8
  %r764 = load i64, ptr %slot.b, align 8
  %r765 = getelementptr inbounds [10 x i8], ptr @.str.31, i64 0, i64 0
  %r766 = ptrtoint ptr %r765 to i64
  %r767 = load i64, ptr %slot.dest, align 8
  %r768 = call i64 @ir_type_int()
  %r769 = call i64 @nova_rt_list_create()
  %r770 = getelementptr inbounds [1 x i8], ptr @.str.1, i64 0, i64 0
  %r771 = ptrtoint ptr %r770 to i64
  %r772 = call i64 @ir_inst(i64 %r766, i64 %r767, i64 %r768, i64 %r769, i64 %r771, i64 0)
  %r773 = call i64 @ir_emit(i64 %r764, i64 %r772)
  %r774 = load i64, ptr %slot.dest, align 8
  ret i64 %r774
}

define i64 @ir_build_stmt(i64 %p0, i64 %p1) nounwind {
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
  %slot.val_r = alloca i64, align 8
  store i64 0, ptr %slot.val_r, align 8
  %slot.at = alloca i64, align 8
  store i64 0, ptr %slot.at, align 8
  %slot.av = alloca i64, align 8
  store i64 0, ptr %slot.av, align 8
  %slot.an = alloca i64, align 8
  store i64 0, ptr %slot.an, align 8
  %slot.ac = alloca i64, align 8
  store i64 0, ptr %slot.ac, align 8
  %slot.af = alloca i64, align 8
  store i64 0, ptr %slot.af, align 8
  %slot.target_r = alloca i64, align 8
  store i64 0, ptr %slot.target_r, align 8
  %slot.idx_r = alloca i64, align 8
  store i64 0, ptr %slot.idx_r, align 8
  %slot.cond_r = alloca i64, align 8
  store i64 0, ptr %slot.cond_r, align 8
  %slot.then_label = alloca i64, align 8
  store i64 0, ptr %slot.then_label, align 8
  %slot.else_label = alloca i64, align 8
  store i64 0, ptr %slot.else_label, align 8
  %slot.merge_label = alloca i64, align 8
  store i64 0, ptr %slot.merge_label, align 8
  %slot.s = alloca i64, align 8
  store i64 0, ptr %slot.s, align 8
  %slot.hdr_label = alloca i64, align 8
  store i64 0, ptr %slot.hdr_label, align 8
  %slot.body_label = alloca i64, align 8
  store i64 0, ptr %slot.body_label, align 8
  %slot.exit_label = alloca i64, align 8
  store i64 0, ptr %slot.exit_label, align 8
  %slot.iter_r = alloca i64, align 8
  store i64 0, ptr %slot.iter_r, align 8
  %slot.len_dest = alloca i64, align 8
  store i64 0, ptr %slot.len_dest, align 8
  %slot.idx_name = alloca i64, align 8
  store i64 0, ptr %slot.idx_name, align 8
  %slot.cmp_r = alloca i64, align 8
  store i64 0, ptr %slot.cmp_r, align 8
  %slot.elem_r = alloca i64, align 8
  store i64 0, ptr %slot.elem_r, align 8
  %slot.inc_r = alloca i64, align 8
  store i64 0, ptr %slot.inc_r, align 8
  %slot.cur_r = alloca i64, align 8
  store i64 0, ptr %slot.cur_r, align 8
  %slot.new_r = alloca i64, align 8
  store i64 0, ptr %slot.new_r, align 8
  %slot.subject_r = alloca i64, align 8
  store i64 0, ptr %slot.subject_r, align 8
  %slot.arm = alloca i64, align 8
  store i64 0, ptr %slot.arm, align 8
  %slot.pattern = alloca i64, align 8
  store i64 0, ptr %slot.pattern, align 8
  %slot.arm_body = alloca i64, align 8
  store i64 0, ptr %slot.arm_body, align 8
  %slot.ap = alloca i64, align 8
  store i64 0, ptr %slot.ap, align 8
  %slot.ae = alloca i64, align 8
  store i64 0, ptr %slot.ae, align 8
  %slot.aa = alloca i64, align 8
  store i64 0, ptr %slot.aa, align 8
  %slot.pt = alloca i64, align 8
  store i64 0, ptr %slot.pt, align 8
  %slot.pv = alloca i64, align 8
  store i64 0, ptr %slot.pv, align 8
  %slot.pn = alloca i64, align 8
  store i64 0, ptr %slot.pn, align 8
  %slot.pchildren = alloca i64, align 8
  store i64 0, ptr %slot.pchildren, align 8
  %slot.pf = alloca i64, align 8
  store i64 0, ptr %slot.pf, align 8
  %slot.fi = alloca i64, align 8
  store i64 0, ptr %slot.fi, align 8
  %slot.field_pat = alloca i64, align 8
  store i64 0, ptr %slot.field_pat, align 8
  %slot.fpt = alloca i64, align 8
  store i64 0, ptr %slot.fpt, align 8
  %slot.fpv = alloca i64, align 8
  store i64 0, ptr %slot.fpv, align 8
  %slot.fpn = alloca i64, align 8
  store i64 0, ptr %slot.fpn, align 8
  %slot.fpc = alloca i64, align 8
  store i64 0, ptr %slot.fpc, align 8
  %slot.fpf = alloca i64, align 8
  store i64 0, ptr %slot.fpf, align 8
  %slot.field_r = alloca i64, align 8
  store i64 0, ptr %slot.field_r, align 8
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
  %r17 = getelementptr inbounds [7 x i8], ptr @.str.70, i64 0, i64 0
  %r18 = ptrtoint ptr %r17 to i64
  %t20 = call i64 @nova_rt_eq(i64 %r16, i64 %r18)
  %r19 = and i64 %t20, 1
  %r21 = load i64, ptr %slot.name, align 8
  %r22 = getelementptr inbounds [1 x i8], ptr @.str.1, i64 0, i64 0
  %r23 = ptrtoint ptr %r22 to i64
  %t25 = call i64 @nova_rt_neq(i64 %r21, i64 %r23)
  br label %and_entry206
and_entry206:
  %t27 = icmp ne i64 %t20, 0
  br i1 %t27, label %and_rhs207, label %and_end208
and_rhs207:
  %r28 = load i64, ptr %slot.name, align 8
  %r29 = getelementptr inbounds [1 x i8], ptr @.str.1, i64 0, i64 0
  %r30 = ptrtoint ptr %r29 to i64
  %t32 = call i64 @nova_rt_neq(i64 %r28, i64 %r30)
  br label %and_done209
and_done209:
  br label %and_end208
and_end208:
  %r26 = phi i64 [0, %and_entry206], [%t32, %and_done209]
  %t33 = icmp ne i64 %r26, 0
  br i1 %t33, label %ret_then210, label %ret_else211
ret_then210:
  %r34 = load i64, ptr %slot.b, align 8
  %r35 = load i64, ptr %slot.expr, align 8
  %r36 = call i64 @ir_build_expr(i64 %r34, i64 %r35)
  store i64 %r36, ptr %slot.val_r, align 8
  %r37 = load i64, ptr %slot.b, align 8
  %r38 = getelementptr inbounds [11 x i8], ptr @.str.71, i64 0, i64 0
  %r39 = ptrtoint ptr %r38 to i64
  %r40 = getelementptr inbounds [1 x i8], ptr @.str.1, i64 0, i64 0
  %r41 = ptrtoint ptr %r40 to i64
  %r42 = call i64 @ir_type_void()
  %r43 = call i64 @nova_rt_list_create()
  %r44 = load i64, ptr %slot.val_r, align 8
  %t45 = call i64 @nova_rt_list_append(i64 %r43, i64 %r44)
  %r46 = load i64, ptr %slot.name, align 8
  %r47 = call i64 @ir_inst(i64 %r39, i64 %r41, i64 %r42, i64 %r43, i64 %r46, i64 0)
  %r48 = call i64 @ir_emit(i64 %r37, i64 %r47)
  ret i64 %r48
ret_else211:
  %r49 = load i64, ptr %slot.tag, align 8
  %r50 = getelementptr inbounds [7 x i8], ptr @.str.70, i64 0, i64 0
  %r51 = ptrtoint ptr %r50 to i64
  %t53 = call i64 @nova_rt_eq(i64 %r49, i64 %r51)
  %r52 = and i64 %t53, 1
  %r54 = load i64, ptr %slot.annotations, align 8
  %r55 = call i64 @nova_rt_len_any(i64 %r54)
  %t57 = icmp sgt i64 %r55, 0
  %r56 = zext i1 %t57 to i64
  br label %and_entry212
and_entry212:
  %t59 = icmp ne i64 %t53, 0
  br i1 %t59, label %and_rhs213, label %and_end214
and_rhs213:
  %r60 = load i64, ptr %slot.annotations, align 8
  %r61 = call i64 @nova_rt_len_any(i64 %r60)
  %t63 = icmp sgt i64 %r61, 0
  %r62 = zext i1 %t63 to i64
  br label %and_done215
and_done215:
  br label %and_end214
and_end214:
  %r58 = phi i64 [0, %and_entry212], [%r62, %and_done215]
  %t64 = icmp ne i64 %r58, 0
  br i1 %t64, label %ret_then216, label %ret_else217
ret_then216:
  %r65 = load i64, ptr %slot.b, align 8
  %r66 = load i64, ptr %slot.expr, align 8
  %r67 = call i64 @ir_build_expr(i64 %r65, i64 %r66)
  store i64 %r67, ptr %slot.val_r, align 8
  %r68 = load i64, ptr %slot.annotations, align 8
  %r69 = call i64 @nova_rt_index_get(i64 %r68, i64 0)
  %t70 = inttoptr i64 %r69 to ptr
  %t71 = getelementptr i64, ptr %t70, i64 0
  %r72 = load i64, ptr %t71, align 8
  store i64 %r72, ptr %slot.at, align 8
  %t73 = getelementptr i64, ptr %t70, i64 1
  %r74 = load i64, ptr %t73, align 8
  store i64 %r74, ptr %slot.av, align 8
  %t75 = getelementptr i64, ptr %t70, i64 2
  %r76 = load i64, ptr %t75, align 8
  store i64 %r76, ptr %slot.an, align 8
  %t77 = getelementptr i64, ptr %t70, i64 3
  %r78 = load i64, ptr %t77, align 8
  store i64 %r78, ptr %slot.ac, align 8
  %t79 = getelementptr i64, ptr %t70, i64 4
  %r80 = load i64, ptr %t79, align 8
  store i64 %r80, ptr %slot.af, align 8
  %r81 = load i64, ptr %slot.at, align 8
  %r82 = getelementptr inbounds [6 x i8], ptr @.str.62, i64 0, i64 0
  %r83 = ptrtoint ptr %r82 to i64
  %t85 = call i64 @nova_rt_eq(i64 %r81, i64 %r83)
  %r84 = and i64 %t85, 1
  %t86 = icmp ne i64 %t85, 0
  br i1 %t86, label %ret_then218, label %ret_else219
ret_then218:
  %r87 = load i64, ptr %slot.b, align 8
  %r88 = load i64, ptr %slot.ac, align 8
  %r89 = call i64 @nova_rt_index_get(i64 %r88, i64 0)
  %r90 = call i64 @ir_build_expr(i64 %r87, i64 %r89)
  store i64 %r90, ptr %slot.target_r, align 8
  %r91 = load i64, ptr %slot.b, align 8
  %r92 = load i64, ptr %slot.ac, align 8
  %r93 = call i64 @nova_rt_index_get(i64 %r92, i64 1)
  %r94 = call i64 @ir_build_expr(i64 %r91, i64 %r93)
  store i64 %r94, ptr %slot.idx_r, align 8
  %r95 = load i64, ptr %slot.b, align 8
  %r96 = getelementptr inbounds [10 x i8], ptr @.str.72, i64 0, i64 0
  %r97 = ptrtoint ptr %r96 to i64
  %r98 = getelementptr inbounds [1 x i8], ptr @.str.1, i64 0, i64 0
  %r99 = ptrtoint ptr %r98 to i64
  %r100 = call i64 @ir_type_void()
  %r101 = call i64 @nova_rt_list_create()
  %r102 = load i64, ptr %slot.target_r, align 8
  %t103 = call i64 @nova_rt_list_append(i64 %r101, i64 %r102)
  %r104 = load i64, ptr %slot.idx_r, align 8
  %t105 = call i64 @nova_rt_list_append(i64 %r101, i64 %r104)
  %r106 = load i64, ptr %slot.val_r, align 8
  %t107 = call i64 @nova_rt_list_append(i64 %r101, i64 %r106)
  %r108 = getelementptr inbounds [1 x i8], ptr @.str.1, i64 0, i64 0
  %r109 = ptrtoint ptr %r108 to i64
  %r110 = getelementptr inbounds [12 x i8], ptr @.str.58, i64 0, i64 0
  %r111 = ptrtoint ptr %r110 to i64
  %r112 = call i64 @ir_inst_effect(i64 %r97, i64 %r99, i64 %r100, i64 %r101, i64 %r109, i64 0, i64 %r111)
  %r113 = call i64 @ir_emit(i64 %r95, i64 %r112)
  ret i64 %r113
ret_else219:
  %r114 = load i64, ptr %slot.at, align 8
  %r115 = getelementptr inbounds [7 x i8], ptr @.str.64, i64 0, i64 0
  %r116 = ptrtoint ptr %r115 to i64
  %t118 = call i64 @nova_rt_eq(i64 %r114, i64 %r116)
  %r117 = and i64 %t118, 1
  %t119 = icmp ne i64 %t118, 0
  br i1 %t119, label %ret_then220, label %ret_else221
ret_then220:
  %r120 = load i64, ptr %slot.b, align 8
  %r121 = load i64, ptr %slot.ac, align 8
  %r122 = call i64 @nova_rt_index_get(i64 %r121, i64 0)
  %r123 = call i64 @ir_build_expr(i64 %r120, i64 %r122)
  store i64 %r123, ptr %slot.target_r, align 8
  %r124 = load i64, ptr %slot.b, align 8
  %r125 = getelementptr inbounds [10 x i8], ptr @.str.73, i64 0, i64 0
  %r126 = ptrtoint ptr %r125 to i64
  %r127 = getelementptr inbounds [1 x i8], ptr @.str.1, i64 0, i64 0
  %r128 = ptrtoint ptr %r127 to i64
  %r129 = call i64 @ir_type_void()
  %r130 = call i64 @nova_rt_list_create()
  %r131 = load i64, ptr %slot.target_r, align 8
  %t132 = call i64 @nova_rt_list_append(i64 %r130, i64 %r131)
  %r133 = load i64, ptr %slot.val_r, align 8
  %t134 = call i64 @nova_rt_list_append(i64 %r130, i64 %r133)
  %r135 = load i64, ptr %slot.av, align 8
  %r136 = load i64, ptr %slot.an, align 8
  %r137 = getelementptr inbounds [12 x i8], ptr @.str.58, i64 0, i64 0
  %r138 = ptrtoint ptr %r137 to i64
  %r139 = call i64 @ir_inst_effect(i64 %r126, i64 %r128, i64 %r129, i64 %r130, i64 %r135, i64 %r136, i64 %r138)
  %r140 = call i64 @ir_emit(i64 %r124, i64 %r139)
  ret i64 %r140
ret_else221:
  ret i64 0
ret_else217:
  %r141 = load i64, ptr %slot.tag, align 8
  %r142 = getelementptr inbounds [5 x i8], ptr @.str.74, i64 0, i64 0
  %r143 = ptrtoint ptr %r142 to i64
  %t145 = call i64 @nova_rt_eq(i64 %r141, i64 %r143)
  %r144 = and i64 %t145, 1
  %t146 = icmp ne i64 %t145, 0
  br i1 %t146, label %ret_then222, label %ret_else223
ret_then222:
  %r147 = load i64, ptr %slot.b, align 8
  %r148 = load i64, ptr %slot.expr, align 8
  %r149 = call i64 @ir_build_expr(i64 %r147, i64 %r148)
  ret i64 %r149
ret_else223:
  %r150 = load i64, ptr %slot.tag, align 8
  %r151 = getelementptr inbounds [7 x i8], ptr @.str.15, i64 0, i64 0
  %r152 = ptrtoint ptr %r151 to i64
  %t154 = call i64 @nova_rt_eq(i64 %r150, i64 %r152)
  %r153 = and i64 %t154, 1
  %t155 = icmp ne i64 %t154, 0
  br i1 %t155, label %ret_then224, label %ret_else225
ret_then224:
  %r156 = load i64, ptr %slot.b, align 8
  %r157 = load i64, ptr %slot.expr, align 8
  %r158 = call i64 @ir_build_expr(i64 %r156, i64 %r157)
  store i64 %r158, ptr %slot.val_r, align 8
  %r159 = load i64, ptr %slot.b, align 8
  %r160 = getelementptr inbounds [7 x i8], ptr @.str.15, i64 0, i64 0
  %r161 = ptrtoint ptr %r160 to i64
  %r162 = getelementptr inbounds [1 x i8], ptr @.str.1, i64 0, i64 0
  %r163 = ptrtoint ptr %r162 to i64
  %r164 = call i64 @ir_type_void()
  %r165 = call i64 @nova_rt_list_create()
  %r166 = load i64, ptr %slot.val_r, align 8
  %t167 = call i64 @nova_rt_list_append(i64 %r165, i64 %r166)
  %r168 = getelementptr inbounds [1 x i8], ptr @.str.1, i64 0, i64 0
  %r169 = ptrtoint ptr %r168 to i64
  %r170 = call i64 @ir_inst(i64 %r161, i64 %r163, i64 %r164, i64 %r165, i64 %r169, i64 0)
  %r171 = call i64 @ir_terminate(i64 %r159, i64 %r170)
  ret i64 %r171
ret_else225:
  %r172 = load i64, ptr %slot.tag, align 8
  %r173 = getelementptr inbounds [3 x i8], ptr @.str.75, i64 0, i64 0
  %r174 = ptrtoint ptr %r173 to i64
  %t176 = call i64 @nova_rt_eq(i64 %r172, i64 %r174)
  %r175 = and i64 %t176, 1
  %t177 = icmp ne i64 %t176, 0
  br i1 %t177, label %ret_then226, label %ret_else227
ret_then226:
  %r178 = load i64, ptr %slot.b, align 8
  %r179 = load i64, ptr %slot.expr, align 8
  %r180 = call i64 @ir_build_expr(i64 %r178, i64 %r179)
  store i64 %r180, ptr %slot.cond_r, align 8
  %r181 = load i64, ptr %slot.b, align 8
  %r182 = getelementptr inbounds [5 x i8], ptr @.str.76, i64 0, i64 0
  %r183 = ptrtoint ptr %r182 to i64
  %r184 = call i64 @ir_fresh_label(i64 %r181, i64 %r183)
  store i64 %r184, ptr %slot.then_label, align 8
  %r185 = load i64, ptr %slot.b, align 8
  %r186 = getelementptr inbounds [5 x i8], ptr @.str.77, i64 0, i64 0
  %r187 = ptrtoint ptr %r186 to i64
  %r188 = call i64 @ir_fresh_label(i64 %r185, i64 %r187)
  store i64 %r188, ptr %slot.else_label, align 8
  %r189 = load i64, ptr %slot.b, align 8
  %r190 = getelementptr inbounds [6 x i8], ptr @.str.78, i64 0, i64 0
  %r191 = ptrtoint ptr %r190 to i64
  %r192 = call i64 @ir_fresh_label(i64 %r189, i64 %r191)
  store i64 %r192, ptr %slot.merge_label, align 8
  %r193 = load i64, ptr %slot.b, align 8
  %r194 = getelementptr inbounds [7 x i8], ptr @.str.79, i64 0, i64 0
  %r195 = ptrtoint ptr %r194 to i64
  %r196 = getelementptr inbounds [1 x i8], ptr @.str.1, i64 0, i64 0
  %r197 = ptrtoint ptr %r196 to i64
  %r198 = call i64 @ir_type_void()
  %r199 = call i64 @nova_rt_list_create()
  %r200 = load i64, ptr %slot.cond_r, align 8
  %t201 = call i64 @nova_rt_list_append(i64 %r199, i64 %r200)
  %r202 = load i64, ptr %slot.else_label, align 8
  %t203 = call i64 @nova_rt_list_append(i64 %r199, i64 %r202)
  %r204 = load i64, ptr %slot.then_label, align 8
  %r205 = call i64 @ir_inst(i64 %r195, i64 %r197, i64 %r198, i64 %r199, i64 %r204, i64 0)
  %r206 = call i64 @ir_terminate(i64 %r193, i64 %r205)
  %r207 = load i64, ptr %slot.b, align 8
  %r208 = load i64, ptr %slot.then_label, align 8
  %r209 = call i64 @ir_start_block(i64 %r207, i64 %r208)
  %r210 = load i64, ptr %slot.body, align 8
  %r211 = call i64 @nova_rt_len_any(i64 %r210)
  %slot.__for_idx_228 = alloca i64, align 8
  store i64 0, ptr %slot.__for_idx_228, align 8
  br label %for_hdr228
for_hdr228:
  %r212 = load i64, ptr %slot.__for_idx_228, align 8
  %t213 = icmp slt i64 %r212, %r211
  br i1 %t213, label %for_body229, label %for_exit230
for_body229:
  %r214 = call i64 @nova_rt_index_get(i64 %r210, i64 %r212)
  store i64 %r214, ptr %slot.s, align 8
  %r215 = load i64, ptr %slot.b, align 8
  %r216 = load i64, ptr %slot.s, align 8
  %r217 = call i64 @ir_build_stmt(i64 %r215, i64 %r216)
  %r219 = load i64, ptr %slot.__for_idx_228, align 8
  %r218 = add i64 %r219, 1
  store i64 %r218, ptr %slot.__for_idx_228, align 8
  br label %for_hdr228
for_exit230:
  %r220 = load i64, ptr %slot.b, align 8
  %r221 = getelementptr inbounds [5 x i8], ptr @.str.80, i64 0, i64 0
  %r222 = ptrtoint ptr %r221 to i64
  %r223 = getelementptr inbounds [1 x i8], ptr @.str.1, i64 0, i64 0
  %r224 = ptrtoint ptr %r223 to i64
  %r225 = call i64 @ir_type_void()
  %r226 = call i64 @nova_rt_list_create()
  %r227 = load i64, ptr %slot.merge_label, align 8
  %r228 = call i64 @ir_inst(i64 %r222, i64 %r224, i64 %r225, i64 %r226, i64 %r227, i64 0)
  %r229 = call i64 @ir_terminate(i64 %r220, i64 %r228)
  %r230 = load i64, ptr %slot.b, align 8
  %r231 = load i64, ptr %slot.else_label, align 8
  %r232 = call i64 @ir_start_block(i64 %r230, i64 %r231)
  %r233 = load i64, ptr %slot.else_body, align 8
  %r234 = call i64 @nova_rt_len_any(i64 %r233)
  %slot.__for_idx_231 = alloca i64, align 8
  store i64 0, ptr %slot.__for_idx_231, align 8
  br label %for_hdr231
for_hdr231:
  %r235 = load i64, ptr %slot.__for_idx_231, align 8
  %t236 = icmp slt i64 %r235, %r234
  br i1 %t236, label %for_body232, label %for_exit233
for_body232:
  %r237 = call i64 @nova_rt_index_get(i64 %r233, i64 %r235)
  store i64 %r237, ptr %slot.s, align 8
  %r238 = load i64, ptr %slot.b, align 8
  %r239 = load i64, ptr %slot.s, align 8
  %r240 = call i64 @ir_build_stmt(i64 %r238, i64 %r239)
  %r242 = load i64, ptr %slot.__for_idx_231, align 8
  %r241 = add i64 %r242, 1
  store i64 %r241, ptr %slot.__for_idx_231, align 8
  br label %for_hdr231
for_exit233:
  %r243 = load i64, ptr %slot.b, align 8
  %r244 = getelementptr inbounds [5 x i8], ptr @.str.80, i64 0, i64 0
  %r245 = ptrtoint ptr %r244 to i64
  %r246 = getelementptr inbounds [1 x i8], ptr @.str.1, i64 0, i64 0
  %r247 = ptrtoint ptr %r246 to i64
  %r248 = call i64 @ir_type_void()
  %r249 = call i64 @nova_rt_list_create()
  %r250 = load i64, ptr %slot.merge_label, align 8
  %r251 = call i64 @ir_inst(i64 %r245, i64 %r247, i64 %r248, i64 %r249, i64 %r250, i64 0)
  %r252 = call i64 @ir_terminate(i64 %r243, i64 %r251)
  %r253 = load i64, ptr %slot.b, align 8
  %r254 = load i64, ptr %slot.merge_label, align 8
  %r255 = call i64 @ir_start_block(i64 %r253, i64 %r254)
  ret i64 %r255
ret_else227:
  %r256 = load i64, ptr %slot.tag, align 8
  %r257 = getelementptr inbounds [6 x i8], ptr @.str.81, i64 0, i64 0
  %r258 = ptrtoint ptr %r257 to i64
  %t260 = call i64 @nova_rt_eq(i64 %r256, i64 %r258)
  %r259 = and i64 %t260, 1
  %t261 = icmp ne i64 %t260, 0
  br i1 %t261, label %ret_then234, label %ret_else235
ret_then234:
  %r262 = load i64, ptr %slot.b, align 8
  %r263 = getelementptr inbounds [10 x i8], ptr @.str.82, i64 0, i64 0
  %r264 = ptrtoint ptr %r263 to i64
  %r265 = call i64 @ir_fresh_label(i64 %r262, i64 %r264)
  store i64 %r265, ptr %slot.hdr_label, align 8
  %r266 = load i64, ptr %slot.b, align 8
  %r267 = getelementptr inbounds [11 x i8], ptr @.str.83, i64 0, i64 0
  %r268 = ptrtoint ptr %r267 to i64
  %r269 = call i64 @ir_fresh_label(i64 %r266, i64 %r268)
  store i64 %r269, ptr %slot.body_label, align 8
  %r270 = load i64, ptr %slot.b, align 8
  %r271 = getelementptr inbounds [11 x i8], ptr @.str.84, i64 0, i64 0
  %r272 = ptrtoint ptr %r271 to i64
  %r273 = call i64 @ir_fresh_label(i64 %r270, i64 %r272)
  store i64 %r273, ptr %slot.exit_label, align 8
  %r274 = load i64, ptr %slot.b, align 8
  %r275 = getelementptr inbounds [5 x i8], ptr @.str.80, i64 0, i64 0
  %r276 = ptrtoint ptr %r275 to i64
  %r277 = getelementptr inbounds [1 x i8], ptr @.str.1, i64 0, i64 0
  %r278 = ptrtoint ptr %r277 to i64
  %r279 = call i64 @ir_type_void()
  %r280 = call i64 @nova_rt_list_create()
  %r281 = load i64, ptr %slot.hdr_label, align 8
  %r282 = call i64 @ir_inst(i64 %r276, i64 %r278, i64 %r279, i64 %r280, i64 %r281, i64 0)
  %r283 = call i64 @ir_terminate(i64 %r274, i64 %r282)
  %r284 = load i64, ptr %slot.b, align 8
  %r285 = load i64, ptr %slot.hdr_label, align 8
  %r286 = call i64 @ir_start_block(i64 %r284, i64 %r285)
  %r287 = load i64, ptr %slot.b, align 8
  %r288 = load i64, ptr %slot.expr, align 8
  %r289 = call i64 @ir_build_expr(i64 %r287, i64 %r288)
  store i64 %r289, ptr %slot.cond_r, align 8
  %r290 = load i64, ptr %slot.b, align 8
  %r291 = getelementptr inbounds [7 x i8], ptr @.str.79, i64 0, i64 0
  %r292 = ptrtoint ptr %r291 to i64
  %r293 = getelementptr inbounds [1 x i8], ptr @.str.1, i64 0, i64 0
  %r294 = ptrtoint ptr %r293 to i64
  %r295 = call i64 @ir_type_void()
  %r296 = call i64 @nova_rt_list_create()
  %r297 = load i64, ptr %slot.cond_r, align 8
  %t298 = call i64 @nova_rt_list_append(i64 %r296, i64 %r297)
  %r299 = load i64, ptr %slot.exit_label, align 8
  %t300 = call i64 @nova_rt_list_append(i64 %r296, i64 %r299)
  %r301 = load i64, ptr %slot.body_label, align 8
  %r302 = call i64 @ir_inst(i64 %r292, i64 %r294, i64 %r295, i64 %r296, i64 %r301, i64 0)
  %r303 = call i64 @ir_terminate(i64 %r290, i64 %r302)
  %r304 = load i64, ptr %slot.b, align 8
  %r305 = load i64, ptr %slot.body_label, align 8
  %r306 = call i64 @ir_start_block(i64 %r304, i64 %r305)
  %r307 = load i64, ptr %slot.body, align 8
  %r308 = call i64 @nova_rt_len_any(i64 %r307)
  %slot.__for_idx_236 = alloca i64, align 8
  store i64 0, ptr %slot.__for_idx_236, align 8
  br label %for_hdr236
for_hdr236:
  %r309 = load i64, ptr %slot.__for_idx_236, align 8
  %t310 = icmp slt i64 %r309, %r308
  br i1 %t310, label %for_body237, label %for_exit238
for_body237:
  %r311 = call i64 @nova_rt_index_get(i64 %r307, i64 %r309)
  store i64 %r311, ptr %slot.s, align 8
  %r312 = load i64, ptr %slot.b, align 8
  %r313 = load i64, ptr %slot.s, align 8
  %r314 = call i64 @ir_build_stmt(i64 %r312, i64 %r313)
  %r316 = load i64, ptr %slot.__for_idx_236, align 8
  %r315 = add i64 %r316, 1
  store i64 %r315, ptr %slot.__for_idx_236, align 8
  br label %for_hdr236
for_exit238:
  %r317 = load i64, ptr %slot.b, align 8
  %r318 = getelementptr inbounds [5 x i8], ptr @.str.80, i64 0, i64 0
  %r319 = ptrtoint ptr %r318 to i64
  %r320 = getelementptr inbounds [1 x i8], ptr @.str.1, i64 0, i64 0
  %r321 = ptrtoint ptr %r320 to i64
  %r322 = call i64 @ir_type_void()
  %r323 = call i64 @nova_rt_list_create()
  %r324 = load i64, ptr %slot.hdr_label, align 8
  %r325 = call i64 @ir_inst(i64 %r319, i64 %r321, i64 %r322, i64 %r323, i64 %r324, i64 0)
  %r326 = call i64 @ir_terminate(i64 %r317, i64 %r325)
  %r327 = load i64, ptr %slot.b, align 8
  %r328 = load i64, ptr %slot.exit_label, align 8
  %r329 = call i64 @ir_start_block(i64 %r327, i64 %r328)
  ret i64 %r329
ret_else235:
  %r330 = load i64, ptr %slot.tag, align 8
  %r331 = getelementptr inbounds [4 x i8], ptr @.str.85, i64 0, i64 0
  %r332 = ptrtoint ptr %r331 to i64
  %t334 = call i64 @nova_rt_eq(i64 %r330, i64 %r332)
  %r333 = and i64 %t334, 1
  %t335 = icmp ne i64 %t334, 0
  br i1 %t335, label %ret_then239, label %ret_else240
ret_then239:
  %r336 = load i64, ptr %slot.b, align 8
  %r337 = load i64, ptr %slot.expr, align 8
  %r338 = call i64 @ir_build_expr(i64 %r336, i64 %r337)
  store i64 %r338, ptr %slot.iter_r, align 8
  %r339 = load i64, ptr %slot.b, align 8
  %r340 = call i64 @ir_fresh_reg(i64 %r339)
  store i64 %r340, ptr %slot.len_dest, align 8
  %r341 = load i64, ptr %slot.b, align 8
  %r342 = getelementptr inbounds [5 x i8], ptr @.str.53, i64 0, i64 0
  %r343 = ptrtoint ptr %r342 to i64
  %r344 = load i64, ptr %slot.len_dest, align 8
  %r345 = call i64 @ir_type_int()
  %r346 = call i64 @nova_rt_list_create()
  %r347 = load i64, ptr %slot.iter_r, align 8
  %t348 = call i64 @nova_rt_list_append(i64 %r346, i64 %r347)
  %r349 = getelementptr inbounds [4 x i8], ptr @.str.59, i64 0, i64 0
  %r350 = ptrtoint ptr %r349 to i64
  %r351 = call i64 @ir_inst(i64 %r343, i64 %r344, i64 %r345, i64 %r346, i64 %r350, i64 0)
  %r352 = call i64 @ir_emit(i64 %r341, i64 %r351)
  %r353 = getelementptr inbounds [11 x i8], ptr @.str.86, i64 0, i64 0
  %r354 = ptrtoint ptr %r353 to i64
  %r355 = load i64, ptr %slot.b, align 8
  %t357 = inttoptr i64 %r355 to ptr
  %t358 = getelementptr i64, ptr %t357, i64 5
  %r356 = load i64, ptr %t358, align 8
  %r359 = call i64 @nova_rt_int_to_str(i64 %r356)
  %r360 = call i64 @nova_rt_add(i64 %r354, i64 %r359)
  store i64 %r360, ptr %slot.idx_name, align 8
  %r361 = load i64, ptr %slot.b, align 8
  %r362 = getelementptr inbounds [11 x i8], ptr @.str.71, i64 0, i64 0
  %r363 = ptrtoint ptr %r362 to i64
  %r364 = getelementptr inbounds [1 x i8], ptr @.str.1, i64 0, i64 0
  %r365 = ptrtoint ptr %r364 to i64
  %r366 = call i64 @ir_type_void()
  %r367 = call i64 @nova_rt_list_create()
  %r368 = getelementptr inbounds [2 x i8], ptr @.str.87, i64 0, i64 0
  %r369 = ptrtoint ptr %r368 to i64
  %t370 = call i64 @nova_rt_list_append(i64 %r367, i64 %r369)
  %r371 = load i64, ptr %slot.idx_name, align 8
  %r372 = call i64 @ir_inst(i64 %r363, i64 %r365, i64 %r366, i64 %r367, i64 %r371, i64 0)
  %r373 = call i64 @ir_emit(i64 %r361, i64 %r372)
  %r374 = load i64, ptr %slot.b, align 8
  %r375 = getelementptr inbounds [8 x i8], ptr @.str.88, i64 0, i64 0
  %r376 = ptrtoint ptr %r375 to i64
  %r377 = call i64 @ir_fresh_label(i64 %r374, i64 %r376)
  store i64 %r377, ptr %slot.hdr_label, align 8
  %r378 = load i64, ptr %slot.b, align 8
  %r379 = getelementptr inbounds [9 x i8], ptr @.str.89, i64 0, i64 0
  %r380 = ptrtoint ptr %r379 to i64
  %r381 = call i64 @ir_fresh_label(i64 %r378, i64 %r380)
  store i64 %r381, ptr %slot.body_label, align 8
  %r382 = load i64, ptr %slot.b, align 8
  %r383 = getelementptr inbounds [9 x i8], ptr @.str.90, i64 0, i64 0
  %r384 = ptrtoint ptr %r383 to i64
  %r385 = call i64 @ir_fresh_label(i64 %r382, i64 %r384)
  store i64 %r385, ptr %slot.exit_label, align 8
  %r386 = load i64, ptr %slot.b, align 8
  %r387 = getelementptr inbounds [5 x i8], ptr @.str.80, i64 0, i64 0
  %r388 = ptrtoint ptr %r387 to i64
  %r389 = getelementptr inbounds [1 x i8], ptr @.str.1, i64 0, i64 0
  %r390 = ptrtoint ptr %r389 to i64
  %r391 = call i64 @ir_type_void()
  %r392 = call i64 @nova_rt_list_create()
  %r393 = load i64, ptr %slot.hdr_label, align 8
  %r394 = call i64 @ir_inst(i64 %r388, i64 %r390, i64 %r391, i64 %r392, i64 %r393, i64 0)
  %r395 = call i64 @ir_terminate(i64 %r386, i64 %r394)
  %r396 = load i64, ptr %slot.b, align 8
  %r397 = load i64, ptr %slot.hdr_label, align 8
  %r398 = call i64 @ir_start_block(i64 %r396, i64 %r397)
  %r399 = load i64, ptr %slot.b, align 8
  %r400 = call i64 @ir_fresh_reg(i64 %r399)
  store i64 %r400, ptr %slot.idx_r, align 8
  %r401 = load i64, ptr %slot.b, align 8
  %r402 = getelementptr inbounds [10 x i8], ptr @.str.40, i64 0, i64 0
  %r403 = ptrtoint ptr %r402 to i64
  %r404 = load i64, ptr %slot.idx_r, align 8
  %r405 = call i64 @ir_type_int()
  %r406 = call i64 @nova_rt_list_create()
  %r407 = load i64, ptr %slot.idx_name, align 8
  %r408 = call i64 @ir_inst(i64 %r403, i64 %r404, i64 %r405, i64 %r406, i64 %r407, i64 0)
  %r409 = call i64 @ir_emit(i64 %r401, i64 %r408)
  %r410 = load i64, ptr %slot.b, align 8
  %r411 = call i64 @ir_fresh_reg(i64 %r410)
  store i64 %r411, ptr %slot.cmp_r, align 8
  %r412 = load i64, ptr %slot.b, align 8
  %r413 = getelementptr inbounds [3 x i8], ptr @.str.49, i64 0, i64 0
  %r414 = ptrtoint ptr %r413 to i64
  %r415 = load i64, ptr %slot.cmp_r, align 8
  %r416 = call i64 @ir_type_bool()
  %r417 = call i64 @nova_rt_list_create()
  %r418 = load i64, ptr %slot.idx_r, align 8
  %t419 = call i64 @nova_rt_list_append(i64 %r417, i64 %r418)
  %r420 = load i64, ptr %slot.len_dest, align 8
  %t421 = call i64 @nova_rt_list_append(i64 %r417, i64 %r420)
  %r422 = getelementptr inbounds [1 x i8], ptr @.str.1, i64 0, i64 0
  %r423 = ptrtoint ptr %r422 to i64
  %r424 = call i64 @ir_inst(i64 %r414, i64 %r415, i64 %r416, i64 %r417, i64 %r423, i64 0)
  %r425 = call i64 @ir_emit(i64 %r412, i64 %r424)
  %r426 = load i64, ptr %slot.b, align 8
  %r427 = getelementptr inbounds [7 x i8], ptr @.str.79, i64 0, i64 0
  %r428 = ptrtoint ptr %r427 to i64
  %r429 = getelementptr inbounds [1 x i8], ptr @.str.1, i64 0, i64 0
  %r430 = ptrtoint ptr %r429 to i64
  %r431 = call i64 @ir_type_void()
  %r432 = call i64 @nova_rt_list_create()
  %r433 = load i64, ptr %slot.cmp_r, align 8
  %t434 = call i64 @nova_rt_list_append(i64 %r432, i64 %r433)
  %r435 = load i64, ptr %slot.exit_label, align 8
  %t436 = call i64 @nova_rt_list_append(i64 %r432, i64 %r435)
  %r437 = load i64, ptr %slot.body_label, align 8
  %r438 = call i64 @ir_inst(i64 %r428, i64 %r430, i64 %r431, i64 %r432, i64 %r437, i64 0)
  %r439 = call i64 @ir_terminate(i64 %r426, i64 %r438)
  %r440 = load i64, ptr %slot.b, align 8
  %r441 = load i64, ptr %slot.body_label, align 8
  %r442 = call i64 @ir_start_block(i64 %r440, i64 %r441)
  %r443 = load i64, ptr %slot.b, align 8
  %r444 = call i64 @ir_fresh_reg(i64 %r443)
  store i64 %r444, ptr %slot.elem_r, align 8
  %r445 = load i64, ptr %slot.b, align 8
  %r446 = getelementptr inbounds [10 x i8], ptr @.str.63, i64 0, i64 0
  %r447 = ptrtoint ptr %r446 to i64
  %r448 = load i64, ptr %slot.elem_r, align 8
  %r449 = call i64 @ir_type_any()
  %r450 = call i64 @nova_rt_list_create()
  %r451 = load i64, ptr %slot.iter_r, align 8
  %t452 = call i64 @nova_rt_list_append(i64 %r450, i64 %r451)
  %r453 = load i64, ptr %slot.idx_r, align 8
  %t454 = call i64 @nova_rt_list_append(i64 %r450, i64 %r453)
  %r455 = getelementptr inbounds [1 x i8], ptr @.str.1, i64 0, i64 0
  %r456 = ptrtoint ptr %r455 to i64
  %r457 = call i64 @ir_inst(i64 %r447, i64 %r448, i64 %r449, i64 %r450, i64 %r456, i64 0)
  %r458 = call i64 @ir_emit(i64 %r445, i64 %r457)
  %r459 = load i64, ptr %slot.b, align 8
  %r460 = getelementptr inbounds [11 x i8], ptr @.str.71, i64 0, i64 0
  %r461 = ptrtoint ptr %r460 to i64
  %r462 = getelementptr inbounds [1 x i8], ptr @.str.1, i64 0, i64 0
  %r463 = ptrtoint ptr %r462 to i64
  %r464 = call i64 @ir_type_void()
  %r465 = call i64 @nova_rt_list_create()
  %r466 = load i64, ptr %slot.elem_r, align 8
  %t467 = call i64 @nova_rt_list_append(i64 %r465, i64 %r466)
  %r468 = load i64, ptr %slot.name, align 8
  %r469 = call i64 @ir_inst(i64 %r461, i64 %r463, i64 %r464, i64 %r465, i64 %r468, i64 0)
  %r470 = call i64 @ir_emit(i64 %r459, i64 %r469)
  %r471 = load i64, ptr %slot.body, align 8
  %r472 = call i64 @nova_rt_len_any(i64 %r471)
  %slot.__for_idx_241 = alloca i64, align 8
  store i64 0, ptr %slot.__for_idx_241, align 8
  br label %for_hdr241
for_hdr241:
  %r473 = load i64, ptr %slot.__for_idx_241, align 8
  %t474 = icmp slt i64 %r473, %r472
  br i1 %t474, label %for_body242, label %for_exit243
for_body242:
  %r475 = call i64 @nova_rt_index_get(i64 %r471, i64 %r473)
  store i64 %r475, ptr %slot.s, align 8
  %r476 = load i64, ptr %slot.b, align 8
  %r477 = load i64, ptr %slot.s, align 8
  %r478 = call i64 @ir_build_stmt(i64 %r476, i64 %r477)
  %r480 = load i64, ptr %slot.__for_idx_241, align 8
  %r479 = add i64 %r480, 1
  store i64 %r479, ptr %slot.__for_idx_241, align 8
  br label %for_hdr241
for_exit243:
  %r481 = load i64, ptr %slot.b, align 8
  %r482 = call i64 @ir_fresh_reg(i64 %r481)
  store i64 %r482, ptr %slot.inc_r, align 8
  %r483 = load i64, ptr %slot.b, align 8
  %r484 = call i64 @ir_fresh_reg(i64 %r483)
  store i64 %r484, ptr %slot.cur_r, align 8
  %r485 = load i64, ptr %slot.b, align 8
  %r486 = getelementptr inbounds [10 x i8], ptr @.str.40, i64 0, i64 0
  %r487 = ptrtoint ptr %r486 to i64
  %r488 = load i64, ptr %slot.cur_r, align 8
  %r489 = call i64 @ir_type_int()
  %r490 = call i64 @nova_rt_list_create()
  %r491 = load i64, ptr %slot.idx_name, align 8
  %r492 = call i64 @ir_inst(i64 %r487, i64 %r488, i64 %r489, i64 %r490, i64 %r491, i64 0)
  %r493 = call i64 @ir_emit(i64 %r485, i64 %r492)
  %r494 = load i64, ptr %slot.b, align 8
  %r495 = getelementptr inbounds [10 x i8], ptr @.str.31, i64 0, i64 0
  %r496 = ptrtoint ptr %r495 to i64
  %r497 = load i64, ptr %slot.inc_r, align 8
  %r498 = call i64 @ir_type_int()
  %r499 = call i64 @nova_rt_list_create()
  %r500 = getelementptr inbounds [1 x i8], ptr @.str.1, i64 0, i64 0
  %r501 = ptrtoint ptr %r500 to i64
  %r502 = call i64 @ir_inst(i64 %r496, i64 %r497, i64 %r498, i64 %r499, i64 %r501, i64 1)
  %r503 = call i64 @ir_emit(i64 %r494, i64 %r502)
  %r504 = load i64, ptr %slot.b, align 8
  %r505 = call i64 @ir_fresh_reg(i64 %r504)
  store i64 %r505, ptr %slot.new_r, align 8
  %r506 = load i64, ptr %slot.b, align 8
  %r507 = getelementptr inbounds [4 x i8], ptr @.str.42, i64 0, i64 0
  %r508 = ptrtoint ptr %r507 to i64
  %r509 = load i64, ptr %slot.new_r, align 8
  %r510 = call i64 @ir_type_int()
  %r511 = call i64 @nova_rt_list_create()
  %r512 = load i64, ptr %slot.cur_r, align 8
  %t513 = call i64 @nova_rt_list_append(i64 %r511, i64 %r512)
  %r514 = load i64, ptr %slot.inc_r, align 8
  %t515 = call i64 @nova_rt_list_append(i64 %r511, i64 %r514)
  %r516 = getelementptr inbounds [2 x i8], ptr @.str.18, i64 0, i64 0
  %r517 = ptrtoint ptr %r516 to i64
  %r518 = call i64 @ir_inst(i64 %r508, i64 %r509, i64 %r510, i64 %r511, i64 %r517, i64 0)
  %r519 = call i64 @ir_emit(i64 %r506, i64 %r518)
  %r520 = load i64, ptr %slot.b, align 8
  %r521 = getelementptr inbounds [11 x i8], ptr @.str.71, i64 0, i64 0
  %r522 = ptrtoint ptr %r521 to i64
  %r523 = getelementptr inbounds [1 x i8], ptr @.str.1, i64 0, i64 0
  %r524 = ptrtoint ptr %r523 to i64
  %r525 = call i64 @ir_type_void()
  %r526 = call i64 @nova_rt_list_create()
  %r527 = load i64, ptr %slot.new_r, align 8
  %t528 = call i64 @nova_rt_list_append(i64 %r526, i64 %r527)
  %r529 = load i64, ptr %slot.idx_name, align 8
  %r530 = call i64 @ir_inst(i64 %r522, i64 %r524, i64 %r525, i64 %r526, i64 %r529, i64 0)
  %r531 = call i64 @ir_emit(i64 %r520, i64 %r530)
  %r532 = load i64, ptr %slot.b, align 8
  %r533 = getelementptr inbounds [5 x i8], ptr @.str.80, i64 0, i64 0
  %r534 = ptrtoint ptr %r533 to i64
  %r535 = getelementptr inbounds [1 x i8], ptr @.str.1, i64 0, i64 0
  %r536 = ptrtoint ptr %r535 to i64
  %r537 = call i64 @ir_type_void()
  %r538 = call i64 @nova_rt_list_create()
  %r539 = load i64, ptr %slot.hdr_label, align 8
  %r540 = call i64 @ir_inst(i64 %r534, i64 %r536, i64 %r537, i64 %r538, i64 %r539, i64 0)
  %r541 = call i64 @ir_terminate(i64 %r532, i64 %r540)
  %r542 = load i64, ptr %slot.b, align 8
  %r543 = load i64, ptr %slot.exit_label, align 8
  %r544 = call i64 @ir_start_block(i64 %r542, i64 %r543)
  ret i64 %r544
ret_else240:
  %r545 = load i64, ptr %slot.tag, align 8
  %r546 = getelementptr inbounds [6 x i8], ptr @.str.91, i64 0, i64 0
  %r547 = ptrtoint ptr %r546 to i64
  %t549 = call i64 @nova_rt_eq(i64 %r545, i64 %r547)
  %r548 = and i64 %t549, 1
  %t550 = icmp ne i64 %t549, 0
  br i1 %t550, label %ret_then244, label %ret_else245
ret_then244:
  %r551 = load i64, ptr %slot.b, align 8
  %r552 = getelementptr inbounds [5 x i8], ptr @.str.80, i64 0, i64 0
  %r553 = ptrtoint ptr %r552 to i64
  %r554 = getelementptr inbounds [1 x i8], ptr @.str.1, i64 0, i64 0
  %r555 = ptrtoint ptr %r554 to i64
  %r556 = call i64 @ir_type_void()
  %r557 = call i64 @nova_rt_list_create()
  %r558 = getelementptr inbounds [15 x i8], ptr @.str.92, i64 0, i64 0
  %r559 = ptrtoint ptr %r558 to i64
  %r560 = call i64 @ir_inst(i64 %r553, i64 %r555, i64 %r556, i64 %r557, i64 %r559, i64 0)
  %r561 = call i64 @ir_emit(i64 %r551, i64 %r560)
  ret i64 %r561
ret_else245:
  %r562 = load i64, ptr %slot.tag, align 8
  %r563 = getelementptr inbounds [9 x i8], ptr @.str.93, i64 0, i64 0
  %r564 = ptrtoint ptr %r563 to i64
  %t566 = call i64 @nova_rt_eq(i64 %r562, i64 %r564)
  %r565 = and i64 %t566, 1
  %t567 = icmp ne i64 %t566, 0
  br i1 %t567, label %ret_then246, label %ret_else247
ret_then246:
  %r568 = load i64, ptr %slot.b, align 8
  %r569 = getelementptr inbounds [5 x i8], ptr @.str.80, i64 0, i64 0
  %r570 = ptrtoint ptr %r569 to i64
  %r571 = getelementptr inbounds [1 x i8], ptr @.str.1, i64 0, i64 0
  %r572 = ptrtoint ptr %r571 to i64
  %r573 = call i64 @ir_type_void()
  %r574 = call i64 @nova_rt_list_create()
  %r575 = getelementptr inbounds [18 x i8], ptr @.str.94, i64 0, i64 0
  %r576 = ptrtoint ptr %r575 to i64
  %r577 = call i64 @ir_inst(i64 %r570, i64 %r572, i64 %r573, i64 %r574, i64 %r576, i64 0)
  %r578 = call i64 @ir_emit(i64 %r568, i64 %r577)
  ret i64 %r578
ret_else247:
  %r579 = load i64, ptr %slot.tag, align 8
  %r580 = getelementptr inbounds [6 x i8], ptr @.str.95, i64 0, i64 0
  %r581 = ptrtoint ptr %r580 to i64
  %t583 = call i64 @nova_rt_eq(i64 %r579, i64 %r581)
  %r582 = and i64 %t583, 1
  %t584 = icmp ne i64 %t583, 0
  br i1 %t584, label %ret_then248, label %ret_else249
ret_then248:
  %r585 = load i64, ptr %slot.b, align 8
  %r586 = load i64, ptr %slot.expr, align 8
  %r587 = call i64 @ir_build_expr(i64 %r585, i64 %r586)
  store i64 %r587, ptr %slot.subject_r, align 8
  %r588 = load i64, ptr %slot.b, align 8
  %r589 = getelementptr inbounds [12 x i8], ptr @.str.96, i64 0, i64 0
  %r590 = ptrtoint ptr %r589 to i64
  %r591 = call i64 @ir_fresh_label(i64 %r588, i64 %r590)
  store i64 %r591, ptr %slot.merge_label, align 8
  %r592 = load i64, ptr %slot.body, align 8
  %r593 = call i64 @nova_rt_len_any(i64 %r592)
  %slot.__for_idx_250 = alloca i64, align 8
  store i64 0, ptr %slot.__for_idx_250, align 8
  br label %for_hdr250
for_hdr250:
  %r594 = load i64, ptr %slot.__for_idx_250, align 8
  %t595 = icmp slt i64 %r594, %r593
  br i1 %t595, label %for_body251, label %for_exit252
for_body251:
  %r596 = call i64 @nova_rt_index_get(i64 %r592, i64 %r594)
  store i64 %r596, ptr %slot.arm, align 8
  %r597 = load i64, ptr %slot.arm, align 8
  %t598 = inttoptr i64 %r597 to ptr
  %t599 = getelementptr i64, ptr %t598, i64 0
  %r600 = load i64, ptr %t599, align 8
  store i64 %r600, ptr %slot.at, align 8
  %t601 = getelementptr i64, ptr %t598, i64 1
  %r602 = load i64, ptr %t601, align 8
  store i64 %r602, ptr %slot.an, align 8
  %t603 = getelementptr i64, ptr %t598, i64 2
  %r604 = load i64, ptr %t603, align 8
  store i64 %r604, ptr %slot.pattern, align 8
  %t605 = getelementptr i64, ptr %t598, i64 3
  %r606 = load i64, ptr %t605, align 8
  store i64 %r606, ptr %slot.arm_body, align 8
  %t607 = getelementptr i64, ptr %t598, i64 4
  %r608 = load i64, ptr %t607, align 8
  store i64 %r608, ptr %slot.ap, align 8
  %t609 = getelementptr i64, ptr %t598, i64 5
  %r610 = load i64, ptr %t609, align 8
  store i64 %r610, ptr %slot.ae, align 8
  %t611 = getelementptr i64, ptr %t598, i64 6
  %r612 = load i64, ptr %t611, align 8
  store i64 %r612, ptr %slot.aa, align 8
  %r613 = load i64, ptr %slot.pattern, align 8
  %t614 = inttoptr i64 %r613 to ptr
  %t615 = getelementptr i64, ptr %t614, i64 0
  %r616 = load i64, ptr %t615, align 8
  store i64 %r616, ptr %slot.pt, align 8
  %t617 = getelementptr i64, ptr %t614, i64 1
  %r618 = load i64, ptr %t617, align 8
  store i64 %r618, ptr %slot.pv, align 8
  %t619 = getelementptr i64, ptr %t614, i64 2
  %r620 = load i64, ptr %t619, align 8
  store i64 %r620, ptr %slot.pn, align 8
  %t621 = getelementptr i64, ptr %t614, i64 3
  %r622 = load i64, ptr %t621, align 8
  store i64 %r622, ptr %slot.pchildren, align 8
  %t623 = getelementptr i64, ptr %t614, i64 4
  %r624 = load i64, ptr %t623, align 8
  store i64 %r624, ptr %slot.pf, align 8
  %r625 = load i64, ptr %slot.pt, align 8
  %r626 = getelementptr inbounds [9 x i8], ptr @.str.97, i64 0, i64 0
  %r627 = ptrtoint ptr %r626 to i64
  %t629 = call i64 @nova_rt_eq(i64 %r625, i64 %r627)
  %r628 = and i64 %t629, 1
  %t630 = icmp ne i64 %t629, 0
  br i1 %t630, label %then253, label %else254
then253:
  store i64 0, ptr %slot.fi, align 8
  %r631 = load i64, ptr %slot.pchildren, align 8
  %r632 = call i64 @nova_rt_len_any(i64 %r631)
  %slot.__for_idx_256 = alloca i64, align 8
  store i64 0, ptr %slot.__for_idx_256, align 8
  br label %for_hdr256
for_hdr256:
  %r633 = load i64, ptr %slot.__for_idx_256, align 8
  %t634 = icmp slt i64 %r633, %r632
  br i1 %t634, label %for_body257, label %for_exit258
for_body257:
  %r635 = call i64 @nova_rt_index_get(i64 %r631, i64 %r633)
  store i64 %r635, ptr %slot.field_pat, align 8
  %r636 = load i64, ptr %slot.field_pat, align 8
  %t637 = inttoptr i64 %r636 to ptr
  %t638 = getelementptr i64, ptr %t637, i64 0
  %r639 = load i64, ptr %t638, align 8
  store i64 %r639, ptr %slot.fpt, align 8
  %t640 = getelementptr i64, ptr %t637, i64 1
  %r641 = load i64, ptr %t640, align 8
  store i64 %r641, ptr %slot.fpv, align 8
  %t642 = getelementptr i64, ptr %t637, i64 2
  %r643 = load i64, ptr %t642, align 8
  store i64 %r643, ptr %slot.fpn, align 8
  %t644 = getelementptr i64, ptr %t637, i64 3
  %r645 = load i64, ptr %t644, align 8
  store i64 %r645, ptr %slot.fpc, align 8
  %t646 = getelementptr i64, ptr %t637, i64 4
  %r647 = load i64, ptr %t646, align 8
  store i64 %r647, ptr %slot.fpf, align 8
  %r648 = load i64, ptr %slot.fpv, align 8
  %r649 = getelementptr inbounds [2 x i8], ptr @.str.98, i64 0, i64 0
  %r650 = ptrtoint ptr %r649 to i64
  %t652 = call i64 @nova_rt_neq(i64 %r648, i64 %r650)
  %t653 = icmp ne i64 %t652, 0
  br i1 %t653, label %then259, label %else260
then259:
  %r654 = load i64, ptr %slot.b, align 8
  %r655 = call i64 @ir_fresh_reg(i64 %r654)
  store i64 %r655, ptr %slot.field_r, align 8
  %r656 = load i64, ptr %slot.b, align 8
  %r657 = getelementptr inbounds [10 x i8], ptr @.str.65, i64 0, i64 0
  %r658 = ptrtoint ptr %r657 to i64
  %r659 = load i64, ptr %slot.field_r, align 8
  %r660 = call i64 @ir_type_any()
  %r661 = call i64 @nova_rt_list_create()
  %r662 = load i64, ptr %slot.subject_r, align 8
  %t663 = call i64 @nova_rt_list_append(i64 %r661, i64 %r662)
  %r664 = load i64, ptr %slot.fpv, align 8
  %r665 = load i64, ptr %slot.fi, align 8
  %r666 = call i64 @ir_inst(i64 %r658, i64 %r659, i64 %r660, i64 %r661, i64 %r664, i64 %r665)
  %r667 = call i64 @ir_emit(i64 %r656, i64 %r666)
  %r668 = load i64, ptr %slot.b, align 8
  %r669 = getelementptr inbounds [11 x i8], ptr @.str.71, i64 0, i64 0
  %r670 = ptrtoint ptr %r669 to i64
  %r671 = getelementptr inbounds [1 x i8], ptr @.str.1, i64 0, i64 0
  %r672 = ptrtoint ptr %r671 to i64
  %r673 = call i64 @ir_type_void()
  %r674 = call i64 @nova_rt_list_create()
  %r675 = load i64, ptr %slot.field_r, align 8
  %t676 = call i64 @nova_rt_list_append(i64 %r674, i64 %r675)
  %r677 = load i64, ptr %slot.fpv, align 8
  %r678 = call i64 @ir_inst(i64 %r670, i64 %r672, i64 %r673, i64 %r674, i64 %r677, i64 0)
  %r679 = call i64 @ir_emit(i64 %r668, i64 %r678)
  br label %merge261
else260:
  br label %merge261
merge261:
  %r680 = load i64, ptr %slot.fi, align 8
  %r681 = call i64 @nova_rt_add(i64 %r680, i64 1)
  store i64 %r681, ptr %slot.fi, align 8
  %r683 = load i64, ptr %slot.__for_idx_256, align 8
  %r682 = add i64 %r683, 1
  store i64 %r682, ptr %slot.__for_idx_256, align 8
  br label %for_hdr256
for_exit258:
  br label %merge255
else254:
  br label %merge255
merge255:
  %r684 = load i64, ptr %slot.arm_body, align 8
  %r685 = call i64 @nova_rt_len_any(i64 %r684)
  %slot.__for_idx_262 = alloca i64, align 8
  store i64 0, ptr %slot.__for_idx_262, align 8
  br label %for_hdr262
for_hdr262:
  %r686 = load i64, ptr %slot.__for_idx_262, align 8
  %t687 = icmp slt i64 %r686, %r685
  br i1 %t687, label %for_body263, label %for_exit264
for_body263:
  %r688 = call i64 @nova_rt_index_get(i64 %r684, i64 %r686)
  store i64 %r688, ptr %slot.s, align 8
  %r689 = load i64, ptr %slot.b, align 8
  %r690 = load i64, ptr %slot.s, align 8
  %r691 = call i64 @ir_build_stmt(i64 %r689, i64 %r690)
  %r693 = load i64, ptr %slot.__for_idx_262, align 8
  %r692 = add i64 %r693, 1
  store i64 %r692, ptr %slot.__for_idx_262, align 8
  br label %for_hdr262
for_exit264:
  %r695 = load i64, ptr %slot.__for_idx_250, align 8
  %r694 = add i64 %r695, 1
  store i64 %r694, ptr %slot.__for_idx_250, align 8
  br label %for_hdr250
for_exit252:
  %r696 = load i64, ptr %slot.b, align 8
  %r697 = getelementptr inbounds [5 x i8], ptr @.str.80, i64 0, i64 0
  %r698 = ptrtoint ptr %r697 to i64
  %r699 = getelementptr inbounds [1 x i8], ptr @.str.1, i64 0, i64 0
  %r700 = ptrtoint ptr %r699 to i64
  %r701 = call i64 @ir_type_void()
  %r702 = call i64 @nova_rt_list_create()
  %r703 = load i64, ptr %slot.merge_label, align 8
  %r704 = call i64 @ir_inst(i64 %r698, i64 %r700, i64 %r701, i64 %r702, i64 %r703, i64 0)
  %r705 = call i64 @ir_terminate(i64 %r696, i64 %r704)
  %r706 = load i64, ptr %slot.b, align 8
  %r707 = load i64, ptr %slot.merge_label, align 8
  %r708 = call i64 @ir_start_block(i64 %r706, i64 %r707)
  ret i64 %r708
ret_else249:
  ret i64 0
}

define i64 @ir_build_function(i64 %p0, i64 %p1) nounwind {
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
  %slot.entry = alloca i64, align 8
  store i64 0, ptr %slot.entry, align 8
  %slot.body_len = alloca i64, align 8
  store i64 0, ptr %slot.body_len, align 8
  %slot.i = alloca i64, align 8
  store i64 0, ptr %slot.i, align 8
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
  %r16 = load i64, ptr %slot.b, align 8
  %t17 = inttoptr i64 %r16 to ptr
  %t18 = getelementptr i64, ptr %t17, i64 4
  store i64 0, ptr %t18, align 8
  %r19 = call i64 @nova_rt_list_create()
  %r20 = load i64, ptr %slot.b, align 8
  %t21 = inttoptr i64 %r20 to ptr
  %t22 = getelementptr i64, ptr %t21, i64 3
  store i64 %r19, ptr %t22, align 8
  %r23 = call i64 @nova_rt_dict_create()
  %r24 = load i64, ptr %slot.b, align 8
  %t25 = inttoptr i64 %r24 to ptr
  %t26 = getelementptr i64, ptr %t25, i64 9
  store i64 %r23, ptr %t26, align 8
  %r27 = call i64 @nova_rt_list_create()
  store i64 %r27, ptr %slot.ir_params, align 8
  %r28 = load i64, ptr %slot.params, align 8
  %r29 = call i64 @nova_rt_len_any(i64 %r28)
  %slot.__for_idx_265 = alloca i64, align 8
  store i64 0, ptr %slot.__for_idx_265, align 8
  br label %for_hdr265
for_hdr265:
  %r30 = load i64, ptr %slot.__for_idx_265, align 8
  %t31 = icmp slt i64 %r30, %r29
  br i1 %t31, label %for_body266, label %for_exit267
for_body266:
  %r32 = call i64 @nova_rt_index_get(i64 %r28, i64 %r30)
  store i64 %r32, ptr %slot.p, align 8
  %r33 = load i64, ptr %slot.p, align 8
  %t34 = inttoptr i64 %r33 to ptr
  %t35 = getelementptr i64, ptr %t34, i64 0
  %r36 = load i64, ptr %t35, align 8
  store i64 %r36, ptr %slot.pname, align 8
  %t37 = getelementptr i64, ptr %t34, i64 1
  %r38 = load i64, ptr %t37, align 8
  store i64 %r38, ptr %slot.ptype, align 8
  %t39 = getelementptr i64, ptr %t34, i64 2
  %r40 = load i64, ptr %t39, align 8
  store i64 %r40, ptr %slot.pdefault, align 8
  %r41 = load i64, ptr %slot.ir_params, align 8
  %r42 = call ptr @nova_rt_struct_alloc(i64 16)
  %r43 = load i64, ptr %slot.pname, align 8
  %t44 = getelementptr i64, ptr %r42, i64 0
  store i64 %r43, ptr %t44, align 8
  %r45 = call i64 @ir_type_any()
  %t46 = getelementptr i64, ptr %r42, i64 1
  store i64 %r45, ptr %t46, align 8
  %r47 = ptrtoint ptr %r42 to i64
  %r48 = call i64 @nova_rt_list_append(i64 %r41, i64 %r47)
  %r49 = call i64 @ir_type_any()
  %r50 = load i64, ptr %slot.b, align 8
  %t52 = inttoptr i64 %r50 to ptr
  %t53 = getelementptr i64, ptr %t52, i64 9
  %r51 = load i64, ptr %t53, align 8
  %r54 = load i64, ptr %slot.pname, align 8
  %t55 = call i64 @nova_rt_index_set(i64 %r51, i64 %r54, i64 %r49)
  %r57 = load i64, ptr %slot.__for_idx_265, align 8
  %r56 = add i64 %r57, 1
  store i64 %r56, ptr %slot.__for_idx_265, align 8
  br label %for_hdr265
for_exit267:
  %r58 = call ptr @nova_rt_struct_alloc(i64 24)
  %r59 = getelementptr inbounds [6 x i8], ptr @.str.14, i64 0, i64 0
  %r60 = ptrtoint ptr %r59 to i64
  %t61 = getelementptr i64, ptr %r58, i64 0
  store i64 %r60, ptr %t61, align 8
  %r62 = call i64 @nova_rt_list_create()
  %t63 = getelementptr i64, ptr %r58, i64 1
  store i64 %r62, ptr %t63, align 8
  %r64 = getelementptr inbounds [7 x i8], ptr @.str.15, i64 0, i64 0
  %r65 = ptrtoint ptr %r64 to i64
  %r66 = getelementptr inbounds [1 x i8], ptr @.str.1, i64 0, i64 0
  %r67 = ptrtoint ptr %r66 to i64
  %r68 = call i64 @ir_type_void()
  %r69 = call i64 @nova_rt_list_create()
  %r70 = getelementptr inbounds [1 x i8], ptr @.str.1, i64 0, i64 0
  %r71 = ptrtoint ptr %r70 to i64
  %r72 = call i64 @ir_inst(i64 %r65, i64 %r67, i64 %r68, i64 %r69, i64 %r71, i64 0)
  %t73 = getelementptr i64, ptr %r58, i64 2
  store i64 %r72, ptr %t73, align 8
  %r74 = ptrtoint ptr %r58 to i64
  store i64 %r74, ptr %slot.entry, align 8
  %r75 = load i64, ptr %slot.entry, align 8
  %r76 = load i64, ptr %slot.b, align 8
  %t77 = inttoptr i64 %r76 to ptr
  %t78 = getelementptr i64, ptr %t77, i64 2
  store i64 %r75, ptr %t78, align 8
  %r79 = load i64, ptr %slot.body, align 8
  %r80 = call i64 @nova_rt_len_any(i64 %r79)
  store i64 %r80, ptr %slot.body_len, align 8
  store i64 0, ptr %slot.i, align 8
  br label %while_hdr268
while_hdr268:
  %r81 = load i64, ptr %slot.i, align 8
  %r82 = load i64, ptr %slot.body_len, align 8
  %t84 = icmp slt i64 %r81, %r82
  %r83 = zext i1 %t84 to i64
  %t85 = icmp ne i64 %r83, 0
  br i1 %t85, label %while_body269, label %while_exit270
while_body269:
  %r86 = load i64, ptr %slot.b, align 8
  %r87 = load i64, ptr %slot.body, align 8
  %r88 = load i64, ptr %slot.i, align 8
  %r89 = call i64 @nova_rt_index_get(i64 %r87, i64 %r88)
  %r90 = call i64 @ir_build_stmt(i64 %r86, i64 %r89)
  %r91 = load i64, ptr %slot.i, align 8
  %r92 = call i64 @nova_rt_add(i64 %r91, i64 1)
  store i64 %r92, ptr %slot.i, align 8
  br label %while_hdr268
while_exit270:
  %r93 = load i64, ptr %slot.b, align 8
  %t95 = inttoptr i64 %r93 to ptr
  %t96 = getelementptr i64, ptr %t95, i64 3
  %r94 = load i64, ptr %t96, align 8
  %r97 = load i64, ptr %slot.b, align 8
  %t99 = inttoptr i64 %r97 to ptr
  %t100 = getelementptr i64, ptr %t99, i64 2
  %r98 = load i64, ptr %t100, align 8
  %r101 = call i64 @nova_rt_list_append(i64 %r94, i64 %r98)
  %r102 = call ptr @nova_rt_struct_alloc(i64 48)
  %r103 = load i64, ptr %slot.name, align 8
  %t104 = getelementptr i64, ptr %r102, i64 0
  store i64 %r103, ptr %t104, align 8
  %r105 = load i64, ptr %slot.ir_params, align 8
  %t106 = getelementptr i64, ptr %r102, i64 1
  store i64 %r105, ptr %t106, align 8
  %r107 = call i64 @ir_type_any()
  %t108 = getelementptr i64, ptr %r102, i64 2
  store i64 %r107, ptr %t108, align 8
  %r109 = load i64, ptr %slot.b, align 8
  %t111 = inttoptr i64 %r109 to ptr
  %t112 = getelementptr i64, ptr %t111, i64 3
  %r110 = load i64, ptr %t112, align 8
  %t113 = getelementptr i64, ptr %r102, i64 3
  store i64 %r110, ptr %t113, align 8
  %r114 = call i64 @nova_rt_list_create()
  %t115 = getelementptr i64, ptr %r102, i64 4
  store i64 %r114, ptr %t115, align 8
  %t116 = getelementptr i64, ptr %r102, i64 5
  store i64 0, ptr %t116, align 8
  %r117 = ptrtoint ptr %r102 to i64
  ret i64 %r117
}

define i64 @test_ir() nounwind {
entry:
  %slot.b = alloca i64, align 8
  store i64 0, ptr %slot.b, align 8
  %slot.t = alloca i64, align 8
  store i64 0, ptr %slot.t, align 8
  %slot.kind = alloca i64, align 8
  store i64 0, ptr %slot.kind, align 8
  %slot.name = alloca i64, align 8
  store i64 0, ptr %slot.name, align 8
  %slot.params = alloca i64, align 8
  store i64 0, ptr %slot.params, align 8
  %slot.id = alloca i64, align 8
  store i64 0, ptr %slot.id, align 8
  %slot.inst = alloca i64, align 8
  store i64 0, ptr %slot.inst, align 8
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
  %r0 = call i64 @new_ir_builder()
  store i64 %r0, ptr %slot.b, align 8
  %r1 = getelementptr inbounds [18 x i8], ptr @.str.99, i64 0, i64 0
  %r2 = ptrtoint ptr %r1 to i64
  %r3 = call i64 @nova_rt_print_any(i64 %r2)
  %r4 = call i64 @ir_type_int()
  store i64 %r4, ptr %slot.t, align 8
  %r5 = load i64, ptr %slot.t, align 8
  %t6 = inttoptr i64 %r5 to ptr
  %t7 = getelementptr i64, ptr %t6, i64 0
  %r8 = load i64, ptr %t7, align 8
  store i64 %r8, ptr %slot.kind, align 8
  %t9 = getelementptr i64, ptr %t6, i64 1
  %r10 = load i64, ptr %t9, align 8
  store i64 %r10, ptr %slot.name, align 8
  %t11 = getelementptr i64, ptr %t6, i64 2
  %r12 = load i64, ptr %t11, align 8
  store i64 %r12, ptr %slot.params, align 8
  %t13 = getelementptr i64, ptr %t6, i64 3
  %r14 = load i64, ptr %t13, align 8
  store i64 %r14, ptr %slot.id, align 8
  %r15 = getelementptr inbounds [7 x i8], ptr @.str.100, i64 0, i64 0
  %r16 = ptrtoint ptr %r15 to i64
  %r17 = load i64, ptr %slot.kind, align 8
  %r18 = call i64 @nova_rt_add(i64 %r16, i64 %r17)
  %r19 = call i64 @nova_rt_print_any(i64 %r18)
  %r20 = getelementptr inbounds [10 x i8], ptr @.str.31, i64 0, i64 0
  %r21 = ptrtoint ptr %r20 to i64
  %r22 = getelementptr inbounds [4 x i8], ptr @.str.101, i64 0, i64 0
  %r23 = ptrtoint ptr %r22 to i64
  %r24 = call i64 @ir_type_int()
  %r25 = call i64 @nova_rt_list_create()
  %r26 = getelementptr inbounds [1 x i8], ptr @.str.1, i64 0, i64 0
  %r27 = ptrtoint ptr %r26 to i64
  %r28 = call i64 @ir_inst(i64 %r21, i64 %r23, i64 %r24, i64 %r25, i64 %r27, i64 42)
  store i64 %r28, ptr %slot.inst, align 8
  %r29 = load i64, ptr %slot.inst, align 8
  %t30 = inttoptr i64 %r29 to ptr
  %t31 = getelementptr i64, ptr %t30, i64 0
  %r32 = load i64, ptr %t31, align 8
  store i64 %r32, ptr %slot.op, align 8
  %t33 = getelementptr i64, ptr %t30, i64 1
  %r34 = load i64, ptr %t33, align 8
  store i64 %r34, ptr %slot.dest, align 8
  %t35 = getelementptr i64, ptr %t30, i64 2
  %r36 = load i64, ptr %t35, align 8
  store i64 %r36, ptr %slot.typ, align 8
  %t37 = getelementptr i64, ptr %t30, i64 3
  %r38 = load i64, ptr %t37, align 8
  store i64 %r38, ptr %slot.args, align 8
  %t39 = getelementptr i64, ptr %t30, i64 4
  %r40 = load i64, ptr %t39, align 8
  store i64 %r40, ptr %slot.value, align 8
  %t41 = getelementptr i64, ptr %t30, i64 5
  %r42 = load i64, ptr %t41, align 8
  store i64 %r42, ptr %slot.num, align 8
  %t43 = getelementptr i64, ptr %t30, i64 6
  %r44 = load i64, ptr %t43, align 8
  store i64 %r44, ptr %slot.effect, align 8
  %r45 = getelementptr inbounds [7 x i8], ptr @.str.102, i64 0, i64 0
  %r46 = ptrtoint ptr %r45 to i64
  %r47 = load i64, ptr %slot.op, align 8
  %r48 = call i64 @nova_rt_add(i64 %r46, i64 %r47)
  %r49 = getelementptr inbounds [2 x i8], ptr @.str.103, i64 0, i64 0
  %r50 = ptrtoint ptr %r49 to i64
  %r51 = call i64 @nova_rt_add(i64 %r48, i64 %r50)
  %r52 = load i64, ptr %slot.dest, align 8
  %r53 = call i64 @nova_rt_add(i64 %r51, i64 %r52)
  %r54 = getelementptr inbounds [4 x i8], ptr @.str.104, i64 0, i64 0
  %r55 = ptrtoint ptr %r54 to i64
  %r56 = call i64 @nova_rt_add(i64 %r53, i64 %r55)
  %r57 = load i64, ptr %slot.num, align 8
  %r58 = call i64 @nova_rt_int_to_str(i64 %r57)
  %r59 = call i64 @nova_rt_add(i64 %r56, i64 %r58)
  %r60 = call i64 @nova_rt_print_any(i64 %r59)
  %r61 = getelementptr inbounds [15 x i8], ptr @.str.105, i64 0, i64 0
  %r62 = ptrtoint ptr %r61 to i64
  %r63 = call i64 @nova_rt_print_any(i64 %r62)
  ret i64 %r63
}

define i64 @nova_main() nounwind {
entry:
  %r0 = call i64 @test_ir()
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
@.str.2 = private unnamed_addr constant [6 x i8] c"float\00"
@.str.3 = private unnamed_addr constant [5 x i8] c"bool\00"
@.str.4 = private unnamed_addr constant [4 x i8] c"str\00"
@.str.5 = private unnamed_addr constant [4 x i8] c"any\00"
@.str.6 = private unnamed_addr constant [5 x i8] c"void\00"
@.str.7 = private unnamed_addr constant [5 x i8] c"list\00"
@.str.8 = private unnamed_addr constant [5 x i8] c"dict\00"
@.str.9 = private unnamed_addr constant [7 x i8] c"struct\00"
@.str.10 = private unnamed_addr constant [3 x i8] c"fn\00"
@.str.11 = private unnamed_addr constant [8 x i8] c"channel\00"
@.str.12 = private unnamed_addr constant [8 x i8] c"typevar\00"
@.str.13 = private unnamed_addr constant [5 x i8] c"pure\00"
@.str.14 = private unnamed_addr constant [6 x i8] c"entry\00"
@.str.15 = private unnamed_addr constant [7 x i8] c"return\00"
@.str.16 = private unnamed_addr constant [3 x i8] c"%r\00"
@.str.17 = private unnamed_addr constant [3 x i8] c"bb\00"
@.str.18 = private unnamed_addr constant [2 x i8] c"+\00"
@.str.19 = private unnamed_addr constant [2 x i8] c"-\00"
@.str.20 = private unnamed_addr constant [2 x i8] c"*\00"
@.str.21 = private unnamed_addr constant [2 x i8] c"/\00"
@.str.22 = private unnamed_addr constant [2 x i8] c"%\00"
@.str.23 = private unnamed_addr constant [3 x i8] c"==\00"
@.str.24 = private unnamed_addr constant [3 x i8] c"!=\00"
@.str.25 = private unnamed_addr constant [2 x i8] c"<\00"
@.str.26 = private unnamed_addr constant [3 x i8] c"<=\00"
@.str.27 = private unnamed_addr constant [2 x i8] c">\00"
@.str.28 = private unnamed_addr constant [3 x i8] c">=\00"
@.str.29 = private unnamed_addr constant [4 x i8] c"and\00"
@.str.30 = private unnamed_addr constant [3 x i8] c"or\00"
@.str.31 = private unnamed_addr constant [10 x i8] c"const_int\00"
@.str.32 = private unnamed_addr constant [12 x i8] c"const_float\00"
@.str.33 = private unnamed_addr constant [7 x i8] c"string\00"
@.str.34 = private unnamed_addr constant [10 x i8] c"const_str\00"
@.str.35 = private unnamed_addr constant [5 x i8] c"true\00"
@.str.36 = private unnamed_addr constant [11 x i8] c"const_bool\00"
@.str.37 = private unnamed_addr constant [5 x i8] c"null\00"
@.str.38 = private unnamed_addr constant [11 x i8] c"const_null\00"
@.str.39 = private unnamed_addr constant [6 x i8] c"ident\00"
@.str.40 = private unnamed_addr constant [10 x i8] c"slot_load\00"
@.str.41 = private unnamed_addr constant [6 x i8] c"binop\00"
@.str.42 = private unnamed_addr constant [4 x i8] c"add\00"
@.str.43 = private unnamed_addr constant [4 x i8] c"sub\00"
@.str.44 = private unnamed_addr constant [4 x i8] c"mul\00"
@.str.45 = private unnamed_addr constant [4 x i8] c"div\00"
@.str.46 = private unnamed_addr constant [4 x i8] c"mod\00"
@.str.47 = private unnamed_addr constant [3 x i8] c"eq\00"
@.str.48 = private unnamed_addr constant [4 x i8] c"neq\00"
@.str.49 = private unnamed_addr constant [3 x i8] c"lt\00"
@.str.50 = private unnamed_addr constant [3 x i8] c"le\00"
@.str.51 = private unnamed_addr constant [3 x i8] c"gt\00"
@.str.52 = private unnamed_addr constant [3 x i8] c"ge\00"
@.str.53 = private unnamed_addr constant [5 x i8] c"call\00"
@.str.54 = private unnamed_addr constant [12 x i8] c"nova_rt_add\00"
@.str.55 = private unnamed_addr constant [6 x i8] c"unary\00"
@.str.56 = private unnamed_addr constant [4 x i8] c"neg\00"
@.str.57 = private unnamed_addr constant [4 x i8] c"not\00"
@.str.58 = private unnamed_addr constant [12 x i8] c"side_effect\00"
@.str.59 = private unnamed_addr constant [4 x i8] c"len\00"
@.str.60 = private unnamed_addr constant [4 x i8] c"ord\00"
@.str.61 = private unnamed_addr constant [4 x i8] c"chr\00"
@.str.62 = private unnamed_addr constant [6 x i8] c"index\00"
@.str.63 = private unnamed_addr constant [10 x i8] c"index_get\00"
@.str.64 = private unnamed_addr constant [7 x i8] c"member\00"
@.str.65 = private unnamed_addr constant [10 x i8] c"field_get\00"
@.str.66 = private unnamed_addr constant [10 x i8] c"make_list\00"
@.str.67 = private unnamed_addr constant [10 x i8] c"make_dict\00"
@.str.68 = private unnamed_addr constant [5 x i8] c"ctor\00"
@.str.69 = private unnamed_addr constant [12 x i8] c"make_struct\00"
@.str.70 = private unnamed_addr constant [7 x i8] c"assign\00"
@.str.71 = private unnamed_addr constant [11 x i8] c"slot_store\00"
@.str.72 = private unnamed_addr constant [10 x i8] c"index_set\00"
@.str.73 = private unnamed_addr constant [10 x i8] c"field_set\00"
@.str.74 = private unnamed_addr constant [5 x i8] c"expr\00"
@.str.75 = private unnamed_addr constant [3 x i8] c"if\00"
@.str.76 = private unnamed_addr constant [5 x i8] c"then\00"
@.str.77 = private unnamed_addr constant [5 x i8] c"else\00"
@.str.78 = private unnamed_addr constant [6 x i8] c"merge\00"
@.str.79 = private unnamed_addr constant [7 x i8] c"branch\00"
@.str.80 = private unnamed_addr constant [5 x i8] c"goto\00"
@.str.81 = private unnamed_addr constant [6 x i8] c"while\00"
@.str.82 = private unnamed_addr constant [10 x i8] c"while_hdr\00"
@.str.83 = private unnamed_addr constant [11 x i8] c"while_body\00"
@.str.84 = private unnamed_addr constant [11 x i8] c"while_exit\00"
@.str.85 = private unnamed_addr constant [4 x i8] c"for\00"
@.str.86 = private unnamed_addr constant [11 x i8] c"__for_idx_\00"
@.str.87 = private unnamed_addr constant [2 x i8] c"0\00"
@.str.88 = private unnamed_addr constant [8 x i8] c"for_hdr\00"
@.str.89 = private unnamed_addr constant [9 x i8] c"for_body\00"
@.str.90 = private unnamed_addr constant [9 x i8] c"for_exit\00"
@.str.91 = private unnamed_addr constant [6 x i8] c"break\00"
@.str.92 = private unnamed_addr constant [15 x i8] c"__break_target\00"
@.str.93 = private unnamed_addr constant [9 x i8] c"continue\00"
@.str.94 = private unnamed_addr constant [18 x i8] c"__continue_target\00"
@.str.95 = private unnamed_addr constant [6 x i8] c"match\00"
@.str.96 = private unnamed_addr constant [12 x i8] c"match_merge\00"
@.str.97 = private unnamed_addr constant [9 x i8] c"pat_ctor\00"
@.str.98 = private unnamed_addr constant [2 x i8] c"_\00"
@.str.99 = private unnamed_addr constant [18 x i8] c"IR module created\00"
@.str.100 = private unnamed_addr constant [7 x i8] c"type: \00"
@.str.101 = private unnamed_addr constant [4 x i8] c"%r0\00"
@.str.102 = private unnamed_addr constant [7 x i8] c"inst: \00"
@.str.103 = private unnamed_addr constant [2 x i8] c" \00"
@.str.104 = private unnamed_addr constant [4 x i8] c" = \00"
@.str.105 = private unnamed_addr constant [15 x i8] c"IR test passed\00"
