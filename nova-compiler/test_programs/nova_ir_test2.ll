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

define i64 @ir_type_any() nounwind {
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

define i64 @ir_type_void() nounwind {
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
  %r13 = getelementptr inbounds [5 x i8], ptr @.str.4, i64 0, i64 0
  %r14 = ptrtoint ptr %r13 to i64
  %t15 = getelementptr i64, ptr %r0, i64 6
  store i64 %r14, ptr %t15, align 8
  %r16 = ptrtoint ptr %r0 to i64
  ret i64 %r16
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
  %r0 = call i64 @nova_rt_list_create()
  %r1 = call ptr @nova_rt_struct_alloc(i64 16)
  %r2 = getelementptr inbounds [2 x i8], ptr @.str.5, i64 0, i64 0
  %r3 = ptrtoint ptr %r2 to i64
  %t4 = getelementptr i64, ptr %r1, i64 0
  store i64 %r3, ptr %t4, align 8
  %r5 = call i64 @ir_type_int()
  %t6 = getelementptr i64, ptr %r1, i64 1
  store i64 %r5, ptr %t6, align 8
  %r7 = ptrtoint ptr %r1 to i64
  %t8 = call i64 @nova_rt_list_append(i64 %r0, i64 %r7)
  %r9 = call ptr @nova_rt_struct_alloc(i64 16)
  %r10 = getelementptr inbounds [2 x i8], ptr @.str.6, i64 0, i64 0
  %r11 = ptrtoint ptr %r10 to i64
  %t12 = getelementptr i64, ptr %r9, i64 0
  store i64 %r11, ptr %t12, align 8
  %r13 = call i64 @ir_type_int()
  %t14 = getelementptr i64, ptr %r9, i64 1
  store i64 %r13, ptr %t14, align 8
  %r15 = ptrtoint ptr %r9 to i64
  %t16 = call i64 @nova_rt_list_append(i64 %r0, i64 %r15)
  store i64 %r0, ptr %slot.params, align 8
  %r17 = call i64 @nova_rt_list_create()
  store i64 %r17, ptr %slot.insts, align 8
  %r18 = load i64, ptr %slot.insts, align 8
  %r19 = getelementptr inbounds [10 x i8], ptr @.str.7, i64 0, i64 0
  %r20 = ptrtoint ptr %r19 to i64
  %r21 = getelementptr inbounds [4 x i8], ptr @.str.8, i64 0, i64 0
  %r22 = ptrtoint ptr %r21 to i64
  %r23 = call i64 @ir_type_int()
  %r24 = call i64 @nova_rt_list_create()
  %r25 = getelementptr inbounds [2 x i8], ptr @.str.5, i64 0, i64 0
  %r26 = ptrtoint ptr %r25 to i64
  %r27 = call i64 @ir_inst(i64 %r20, i64 %r22, i64 %r23, i64 %r24, i64 %r26, i64 0)
  %r28 = call i64 @nova_rt_list_append(i64 %r18, i64 %r27)
  %r29 = load i64, ptr %slot.insts, align 8
  %r30 = getelementptr inbounds [10 x i8], ptr @.str.7, i64 0, i64 0
  %r31 = ptrtoint ptr %r30 to i64
  %r32 = getelementptr inbounds [4 x i8], ptr @.str.9, i64 0, i64 0
  %r33 = ptrtoint ptr %r32 to i64
  %r34 = call i64 @ir_type_int()
  %r35 = call i64 @nova_rt_list_create()
  %r36 = getelementptr inbounds [2 x i8], ptr @.str.6, i64 0, i64 0
  %r37 = ptrtoint ptr %r36 to i64
  %r38 = call i64 @ir_inst(i64 %r31, i64 %r33, i64 %r34, i64 %r35, i64 %r37, i64 0)
  %r39 = call i64 @nova_rt_list_append(i64 %r29, i64 %r38)
  %r40 = load i64, ptr %slot.insts, align 8
  %r41 = getelementptr inbounds [4 x i8], ptr @.str.10, i64 0, i64 0
  %r42 = ptrtoint ptr %r41 to i64
  %r43 = getelementptr inbounds [4 x i8], ptr @.str.11, i64 0, i64 0
  %r44 = ptrtoint ptr %r43 to i64
  %r45 = call i64 @ir_type_int()
  %r46 = call i64 @nova_rt_list_create()
  %r47 = getelementptr inbounds [4 x i8], ptr @.str.8, i64 0, i64 0
  %r48 = ptrtoint ptr %r47 to i64
  %t49 = call i64 @nova_rt_list_append(i64 %r46, i64 %r48)
  %r50 = getelementptr inbounds [4 x i8], ptr @.str.9, i64 0, i64 0
  %r51 = ptrtoint ptr %r50 to i64
  %t52 = call i64 @nova_rt_list_append(i64 %r46, i64 %r51)
  %r53 = getelementptr inbounds [2 x i8], ptr @.str.12, i64 0, i64 0
  %r54 = ptrtoint ptr %r53 to i64
  %r55 = call i64 @ir_inst(i64 %r42, i64 %r44, i64 %r45, i64 %r46, i64 %r54, i64 0)
  %r56 = call i64 @nova_rt_list_append(i64 %r40, i64 %r55)
  %r57 = getelementptr inbounds [7 x i8], ptr @.str.13, i64 0, i64 0
  %r58 = ptrtoint ptr %r57 to i64
  %r59 = getelementptr inbounds [1 x i8], ptr @.str.1, i64 0, i64 0
  %r60 = ptrtoint ptr %r59 to i64
  %r61 = call i64 @ir_type_void()
  %r62 = call i64 @nova_rt_list_create()
  %r63 = getelementptr inbounds [4 x i8], ptr @.str.11, i64 0, i64 0
  %r64 = ptrtoint ptr %r63 to i64
  %t65 = call i64 @nova_rt_list_append(i64 %r62, i64 %r64)
  %r66 = getelementptr inbounds [1 x i8], ptr @.str.1, i64 0, i64 0
  %r67 = ptrtoint ptr %r66 to i64
  %r68 = call i64 @ir_inst(i64 %r58, i64 %r60, i64 %r61, i64 %r62, i64 %r67, i64 0)
  store i64 %r68, ptr %slot.term, align 8
  %r69 = call ptr @nova_rt_struct_alloc(i64 24)
  %r70 = getelementptr inbounds [6 x i8], ptr @.str.14, i64 0, i64 0
  %r71 = ptrtoint ptr %r70 to i64
  %t72 = getelementptr i64, ptr %r69, i64 0
  store i64 %r71, ptr %t72, align 8
  %r73 = load i64, ptr %slot.insts, align 8
  %t74 = getelementptr i64, ptr %r69, i64 1
  store i64 %r73, ptr %t74, align 8
  %r75 = load i64, ptr %slot.term, align 8
  %t76 = getelementptr i64, ptr %r69, i64 2
  store i64 %r75, ptr %t76, align 8
  %r77 = ptrtoint ptr %r69 to i64
  store i64 %r77, ptr %slot.entry, align 8
  %r78 = call ptr @nova_rt_struct_alloc(i64 48)
  %r79 = getelementptr inbounds [4 x i8], ptr @.str.10, i64 0, i64 0
  %r80 = ptrtoint ptr %r79 to i64
  %t81 = getelementptr i64, ptr %r78, i64 0
  store i64 %r80, ptr %t81, align 8
  %r82 = load i64, ptr %slot.params, align 8
  %t83 = getelementptr i64, ptr %r78, i64 1
  store i64 %r82, ptr %t83, align 8
  %r84 = call i64 @ir_type_int()
  %t85 = getelementptr i64, ptr %r78, i64 2
  store i64 %r84, ptr %t85, align 8
  %r86 = call i64 @nova_rt_list_create()
  %r87 = load i64, ptr %slot.entry, align 8
  %t88 = call i64 @nova_rt_list_append(i64 %r86, i64 %r87)
  %t89 = getelementptr i64, ptr %r78, i64 3
  store i64 %r86, ptr %t89, align 8
  %r90 = call i64 @nova_rt_list_create()
  %t91 = getelementptr i64, ptr %r78, i64 4
  store i64 %r90, ptr %t91, align 8
  %t92 = getelementptr i64, ptr %r78, i64 5
  store i64 0, ptr %t92, align 8
  %r93 = ptrtoint ptr %r78 to i64
  ret i64 %r93
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
  %r0 = call i64 @build_add_fn()
  store i64 %r0, ptr %slot.add_fn, align 8
  %r1 = load i64, ptr %slot.add_fn, align 8
  %t2 = inttoptr i64 %r1 to ptr
  %t3 = getelementptr i64, ptr %t2, i64 0
  %r4 = load i64, ptr %t3, align 8
  store i64 %r4, ptr %slot.name, align 8
  %t5 = getelementptr i64, ptr %t2, i64 1
  %r6 = load i64, ptr %t5, align 8
  store i64 %r6, ptr %slot.params, align 8
  %t7 = getelementptr i64, ptr %t2, i64 2
  %r8 = load i64, ptr %t7, align 8
  store i64 %r8, ptr %slot.ret_type, align 8
  %t9 = getelementptr i64, ptr %t2, i64 3
  %r10 = load i64, ptr %t9, align 8
  store i64 %r10, ptr %slot.blocks, align 8
  %t11 = getelementptr i64, ptr %t2, i64 4
  %r12 = load i64, ptr %t11, align 8
  store i64 %r12, ptr %slot.type_params, align 8
  %t13 = getelementptr i64, ptr %t2, i64 5
  %r14 = load i64, ptr %t13, align 8
  store i64 %r14, ptr %slot.is_extern, align 8
  %r15 = getelementptr inbounds [5 x i8], ptr @.str.15, i64 0, i64 0
  %r16 = ptrtoint ptr %r15 to i64
  %r17 = load i64, ptr %slot.name, align 8
  %r18 = call i64 @nova_rt_add(i64 %r16, i64 %r17)
  %r19 = call i64 @nova_rt_print_any(i64 %r18)
  %r20 = getelementptr inbounds [9 x i8], ptr @.str.16, i64 0, i64 0
  %r21 = ptrtoint ptr %r20 to i64
  %r22 = load i64, ptr %slot.params, align 8
  %r23 = call i64 @nova_rt_len_any(i64 %r22)
  %r24 = call i64 @nova_rt_int_to_str(i64 %r23)
  %r25 = call i64 @nova_rt_add(i64 %r21, i64 %r24)
  %r26 = call i64 @nova_rt_print_any(i64 %r25)
  %r27 = load i64, ptr %slot.ret_type, align 8
  %t28 = inttoptr i64 %r27 to ptr
  %t29 = getelementptr i64, ptr %t28, i64 0
  %r30 = load i64, ptr %t29, align 8
  store i64 %r30, ptr %slot.kind, align 8
  %t31 = getelementptr i64, ptr %t28, i64 1
  %r32 = load i64, ptr %t31, align 8
  store i64 %r32, ptr %slot.n, align 8
  %t33 = getelementptr i64, ptr %t28, i64 2
  %r34 = load i64, ptr %t33, align 8
  store i64 %r34, ptr %slot.p, align 8
  %t35 = getelementptr i64, ptr %t28, i64 3
  %r36 = load i64, ptr %t35, align 8
  store i64 %r36, ptr %slot.id, align 8
  %r37 = getelementptr inbounds [10 x i8], ptr @.str.17, i64 0, i64 0
  %r38 = ptrtoint ptr %r37 to i64
  %r39 = load i64, ptr %slot.kind, align 8
  %r40 = call i64 @nova_rt_add(i64 %r38, i64 %r39)
  %r41 = call i64 @nova_rt_print_any(i64 %r40)
  %r42 = getelementptr inbounds [9 x i8], ptr @.str.18, i64 0, i64 0
  %r43 = ptrtoint ptr %r42 to i64
  %r44 = load i64, ptr %slot.blocks, align 8
  %r45 = call i64 @nova_rt_len_any(i64 %r44)
  %r46 = call i64 @nova_rt_int_to_str(i64 %r45)
  %r47 = call i64 @nova_rt_add(i64 %r43, i64 %r46)
  %r48 = call i64 @nova_rt_print_any(i64 %r47)
  %r49 = load i64, ptr %slot.blocks, align 8
  %r50 = call i64 @nova_rt_index_get(i64 %r49, i64 0)
  %t51 = inttoptr i64 %r50 to ptr
  %t52 = getelementptr i64, ptr %t51, i64 0
  %r53 = load i64, ptr %t52, align 8
  store i64 %r53, ptr %slot.label, align 8
  %t54 = getelementptr i64, ptr %t51, i64 1
  %r55 = load i64, ptr %t54, align 8
  store i64 %r55, ptr %slot.insts, align 8
  %t56 = getelementptr i64, ptr %t51, i64 2
  %r57 = load i64, ptr %t56, align 8
  store i64 %r57, ptr %slot.term, align 8
  %r58 = getelementptr inbounds [8 x i8], ptr @.str.19, i64 0, i64 0
  %r59 = ptrtoint ptr %r58 to i64
  %r60 = load i64, ptr %slot.label, align 8
  %r61 = call i64 @nova_rt_add(i64 %r59, i64 %r60)
  %r62 = call i64 @nova_rt_print_any(i64 %r61)
  %r63 = getelementptr inbounds [8 x i8], ptr @.str.20, i64 0, i64 0
  %r64 = ptrtoint ptr %r63 to i64
  %r65 = load i64, ptr %slot.insts, align 8
  %r66 = call i64 @nova_rt_len_any(i64 %r65)
  %r67 = call i64 @nova_rt_int_to_str(i64 %r66)
  %r68 = call i64 @nova_rt_add(i64 %r64, i64 %r67)
  %r69 = call i64 @nova_rt_print_any(i64 %r68)
  %r70 = load i64, ptr %slot.insts, align 8
  %r71 = call i64 @nova_rt_index_get(i64 %r70, i64 2)
  %t72 = inttoptr i64 %r71 to ptr
  %t73 = getelementptr i64, ptr %t72, i64 0
  %r74 = load i64, ptr %t73, align 8
  store i64 %r74, ptr %slot.op, align 8
  %t75 = getelementptr i64, ptr %t72, i64 1
  %r76 = load i64, ptr %t75, align 8
  store i64 %r76, ptr %slot.dest, align 8
  %t77 = getelementptr i64, ptr %t72, i64 2
  %r78 = load i64, ptr %t77, align 8
  store i64 %r78, ptr %slot.typ, align 8
  %t79 = getelementptr i64, ptr %t72, i64 3
  %r80 = load i64, ptr %t79, align 8
  store i64 %r80, ptr %slot.args, align 8
  %t81 = getelementptr i64, ptr %t72, i64 4
  %r82 = load i64, ptr %t81, align 8
  store i64 %r82, ptr %slot.value, align 8
  %t83 = getelementptr i64, ptr %t72, i64 5
  %r84 = load i64, ptr %t83, align 8
  store i64 %r84, ptr %slot.num, align 8
  %t85 = getelementptr i64, ptr %t72, i64 6
  %r86 = load i64, ptr %t85, align 8
  store i64 %r86, ptr %slot.effect, align 8
  %r87 = getelementptr inbounds [9 x i8], ptr @.str.21, i64 0, i64 0
  %r88 = ptrtoint ptr %r87 to i64
  %r89 = load i64, ptr %slot.op, align 8
  %r90 = call i64 @nova_rt_add(i64 %r88, i64 %r89)
  %r91 = call i64 @nova_rt_print_any(i64 %r90)
  %r92 = load i64, ptr %slot.typ, align 8
  %t93 = inttoptr i64 %r92 to ptr
  %t94 = getelementptr i64, ptr %t93, i64 0
  %r95 = load i64, ptr %t94, align 8
  store i64 %r95, ptr %slot.tk, align 8
  %t96 = getelementptr i64, ptr %t93, i64 1
  %r97 = load i64, ptr %t96, align 8
  store i64 %r97, ptr %slot.tn, align 8
  %t98 = getelementptr i64, ptr %t93, i64 2
  %r99 = load i64, ptr %t98, align 8
  store i64 %r99, ptr %slot.tp, align 8
  %t100 = getelementptr i64, ptr %t93, i64 3
  %r101 = load i64, ptr %t100, align 8
  store i64 %r101, ptr %slot.tid, align 8
  %r102 = getelementptr inbounds [11 x i8], ptr @.str.22, i64 0, i64 0
  %r103 = ptrtoint ptr %r102 to i64
  %r104 = load i64, ptr %slot.tk, align 8
  %r105 = call i64 @nova_rt_add(i64 %r103, i64 %r104)
  %r106 = call i64 @nova_rt_print_any(i64 %r105)
  %r107 = getelementptr inbounds [13 x i8], ptr @.str.23, i64 0, i64 0
  %r108 = ptrtoint ptr %r107 to i64
  %r109 = load i64, ptr %slot.effect, align 8
  %r110 = call i64 @nova_rt_add(i64 %r108, i64 %r109)
  %r111 = call i64 @nova_rt_print_any(i64 %r110)
  %r112 = load i64, ptr %slot.op, align 8
  %r113 = getelementptr inbounds [4 x i8], ptr @.str.10, i64 0, i64 0
  %r114 = ptrtoint ptr %r113 to i64
  %t116 = call i64 @nova_rt_eq(i64 %r112, i64 %r114)
  %r115 = and i64 %t116, 1
  %r117 = load i64, ptr %slot.tk, align 8
  %r118 = getelementptr inbounds [4 x i8], ptr @.str.0, i64 0, i64 0
  %r119 = ptrtoint ptr %r118 to i64
  %t121 = call i64 @nova_rt_eq(i64 %r117, i64 %r119)
  %r120 = and i64 %t121, 1
  br label %and_entry0
and_entry0:
  %t123 = icmp ne i64 %t116, 0
  br i1 %t123, label %and_rhs1, label %and_end2
and_rhs1:
  %r124 = load i64, ptr %slot.tk, align 8
  %r125 = getelementptr inbounds [4 x i8], ptr @.str.0, i64 0, i64 0
  %r126 = ptrtoint ptr %r125 to i64
  %t128 = call i64 @nova_rt_eq(i64 %r124, i64 %r126)
  %r127 = and i64 %t128, 1
  br label %and_done3
and_done3:
  br label %and_end2
and_end2:
  %r122 = phi i64 [0, %and_entry0], [%t128, %and_done3]
  %r129 = load i64, ptr %slot.effect, align 8
  %r130 = getelementptr inbounds [5 x i8], ptr @.str.4, i64 0, i64 0
  %r131 = ptrtoint ptr %r130 to i64
  %t133 = call i64 @nova_rt_eq(i64 %r129, i64 %r131)
  %r132 = and i64 %t133, 1
  br label %and_entry4
and_entry4:
  %t135 = icmp ne i64 %r122, 0
  br i1 %t135, label %and_rhs5, label %and_end6
and_rhs5:
  %r136 = load i64, ptr %slot.effect, align 8
  %r137 = getelementptr inbounds [5 x i8], ptr @.str.4, i64 0, i64 0
  %r138 = ptrtoint ptr %r137 to i64
  %t140 = call i64 @nova_rt_eq(i64 %r136, i64 %r138)
  %r139 = and i64 %t140, 1
  br label %and_done7
and_done7:
  br label %and_end6
and_end6:
  %r134 = phi i64 [0, %and_entry4], [%t140, %and_done7]
  %t141 = icmp ne i64 %r134, 0
  br i1 %t141, label %then8, label %else9
then8:
  %r142 = getelementptr inbounds [41 x i8], ptr @.str.24, i64 0, i64 0
  %r143 = ptrtoint ptr %r142 to i64
  %r144 = call i64 @nova_rt_print_any(i64 %r143)
  br label %merge10
else9:
  %r145 = getelementptr inbounds [30 x i8], ptr @.str.25, i64 0, i64 0
  %r146 = ptrtoint ptr %r145 to i64
  %r147 = call i64 @nova_rt_print_any(i64 %r146)
  br label %merge10
merge10:
  %r148 = load i64, ptr %slot.term, align 8
  %t149 = inttoptr i64 %r148 to ptr
  %t150 = getelementptr i64, ptr %t149, i64 0
  %r151 = load i64, ptr %t150, align 8
  store i64 %r151, ptr %slot.op, align 8
  %t152 = getelementptr i64, ptr %t149, i64 1
  %r153 = load i64, ptr %t152, align 8
  store i64 %r153, ptr %slot.dest, align 8
  %t154 = getelementptr i64, ptr %t149, i64 2
  %r155 = load i64, ptr %t154, align 8
  store i64 %r155, ptr %slot.typ, align 8
  %t156 = getelementptr i64, ptr %t149, i64 3
  %r157 = load i64, ptr %t156, align 8
  store i64 %r157, ptr %slot.args, align 8
  %t158 = getelementptr i64, ptr %t149, i64 4
  %r159 = load i64, ptr %t158, align 8
  store i64 %r159, ptr %slot.value, align 8
  %t160 = getelementptr i64, ptr %t149, i64 5
  %r161 = load i64, ptr %t160, align 8
  store i64 %r161, ptr %slot.num, align 8
  %t162 = getelementptr i64, ptr %t149, i64 6
  %r163 = load i64, ptr %t162, align 8
  store i64 %r163, ptr %slot.effect, align 8
  %r164 = getelementptr inbounds [13 x i8], ptr @.str.26, i64 0, i64 0
  %r165 = ptrtoint ptr %r164 to i64
  %r166 = load i64, ptr %slot.op, align 8
  %r167 = call i64 @nova_rt_add(i64 %r165, i64 %r166)
  %r168 = call i64 @nova_rt_print_any(i64 %r167)
  %r169 = load i64, ptr %slot.op, align 8
  %r170 = getelementptr inbounds [7 x i8], ptr @.str.13, i64 0, i64 0
  %r171 = ptrtoint ptr %r170 to i64
  %t173 = call i64 @nova_rt_eq(i64 %r169, i64 %r171)
  %r172 = and i64 %t173, 1
  %t174 = icmp ne i64 %t173, 0
  br i1 %t174, label %then11, label %else12
then11:
  %r175 = getelementptr inbounds [33 x i8], ptr @.str.27, i64 0, i64 0
  %r176 = ptrtoint ptr %r175 to i64
  %r177 = call i64 @nova_rt_print_any(i64 %r176)
  br label %merge13
else12:
  br label %merge13
merge13:
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
