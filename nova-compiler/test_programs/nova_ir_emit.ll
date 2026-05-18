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
  %r4 = getelementptr inbounds [3 x i8], ptr @.str.0, i64 0, i64 0
  %r5 = ptrtoint ptr %r4 to i64
  %r6 = load i64, ptr %slot.line, align 8
  %r7 = call i64 @nova_rt_add(i64 %r5, i64 %r6)
  %r8 = call i64 @nova_rt_list_append(i64 %r1, i64 %r7)
  ret i64 %r8
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
  br i1 %t6, label %then0, label %else1
then0:
  %r7 = load i64, ptr %slot.e, align 8
  %t9 = inttoptr i64 %r7 to ptr
  %t10 = getelementptr i64, ptr %t9, i64 2
  %r8 = load i64, ptr %t10, align 8
  %r11 = load i64, ptr %slot.s, align 8
  %r12 = call i64 @nova_rt_index_get(i64 %r8, i64 %r11)
  ret i64 %r12
  br label %merge2
else1:
  br label %merge2
merge2:
  %r13 = load i64, ptr %slot.s, align 8
  %r14 = call i64 @llvm_escape(i64 %r13)
  store i64 %r14, ptr %slot.escaped, align 8
  %r15 = getelementptr inbounds [7 x i8], ptr @.str.1, i64 0, i64 0
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
  %r39 = getelementptr inbounds [35 x i8], ptr @.str.2, i64 0, i64 0
  %r40 = ptrtoint ptr %r39 to i64
  %r41 = call i64 @nova_rt_add(i64 %r38, i64 %r40)
  %r42 = load i64, ptr %slot.byte_len, align 8
  %r43 = call i64 @nova_rt_int_to_str(i64 %r42)
  %r44 = call i64 @nova_rt_add(i64 %r41, i64 %r43)
  %r45 = getelementptr inbounds [10 x i8], ptr @.str.3, i64 0, i64 0
  %r46 = ptrtoint ptr %r45 to i64
  %r47 = call i64 @nova_rt_add(i64 %r44, i64 %r46)
  %r48 = load i64, ptr %slot.escaped, align 8
  %r49 = call i64 @nova_rt_add(i64 %r47, i64 %r48)
  %r50 = getelementptr inbounds [5 x i8], ptr @.str.4, i64 0, i64 0
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
  %r0 = getelementptr inbounds [1 x i8], ptr @.str.5, i64 0, i64 0
  %r1 = ptrtoint ptr %r0 to i64
  store i64 %r1, ptr %slot.result, align 8
  store i64 0, ptr %slot.i, align 8
  br label %while_hdr3
while_hdr3:
  %r2 = load i64, ptr %slot.i, align 8
  %r3 = load i64, ptr %slot.s, align 8
  %r4 = call i64 @nova_rt_len_any(i64 %r3)
  %t6 = icmp slt i64 %r2, %r4
  %r5 = zext i1 %t6 to i64
  %t7 = icmp ne i64 %r5, 0
  br i1 %t7, label %while_body4, label %while_exit5
while_body4:
  %r8 = load i64, ptr %slot.s, align 8
  %r9 = load i64, ptr %slot.i, align 8
  %r10 = call i64 @nova_rt_index_get(i64 %r8, i64 %r9)
  store i64 %r10, ptr %slot.ch, align 8
  %r11 = load i64, ptr %slot.ch, align 8
  %r12 = getelementptr inbounds [2 x i8], ptr @.str.6, i64 0, i64 0
  %r13 = ptrtoint ptr %r12 to i64
  %t15 = call i64 @nova_rt_eq(i64 %r11, i64 %r13)
  %r14 = and i64 %t15, 1
  %t16 = icmp ne i64 %t15, 0
  br i1 %t16, label %then6, label %else7
then6:
  %r17 = load i64, ptr %slot.result, align 8
  %r18 = getelementptr inbounds [4 x i8], ptr @.str.7, i64 0, i64 0
  %r19 = ptrtoint ptr %r18 to i64
  %r20 = call i64 @nova_rt_add(i64 %r17, i64 %r19)
  store i64 %r20, ptr %slot.result, align 8
  br label %merge8
else7:
  %r21 = load i64, ptr %slot.ch, align 8
  %r22 = getelementptr inbounds [2 x i8], ptr @.str.8, i64 0, i64 0
  %r23 = ptrtoint ptr %r22 to i64
  %t25 = call i64 @nova_rt_eq(i64 %r21, i64 %r23)
  %r24 = and i64 %t25, 1
  %t26 = icmp ne i64 %t25, 0
  br i1 %t26, label %then9, label %else10
then9:
  %r27 = load i64, ptr %slot.result, align 8
  %r28 = getelementptr inbounds [4 x i8], ptr @.str.9, i64 0, i64 0
  %r29 = ptrtoint ptr %r28 to i64
  %r30 = call i64 @nova_rt_add(i64 %r27, i64 %r29)
  store i64 %r30, ptr %slot.result, align 8
  br label %merge11
else10:
  %r31 = load i64, ptr %slot.ch, align 8
  %r32 = getelementptr inbounds [2 x i8], ptr @.str.10, i64 0, i64 0
  %r33 = ptrtoint ptr %r32 to i64
  %t35 = call i64 @nova_rt_eq(i64 %r31, i64 %r33)
  %r34 = and i64 %t35, 1
  %t36 = icmp ne i64 %t35, 0
  br i1 %t36, label %then12, label %else13
then12:
  %r37 = load i64, ptr %slot.result, align 8
  %r38 = getelementptr inbounds [4 x i8], ptr @.str.11, i64 0, i64 0
  %r39 = ptrtoint ptr %r38 to i64
  %r40 = call i64 @nova_rt_add(i64 %r37, i64 %r39)
  store i64 %r40, ptr %slot.result, align 8
  br label %merge14
else13:
  %r41 = load i64, ptr %slot.ch, align 8
  %r42 = getelementptr inbounds [1 x i8], ptr @.str.5, i64 0, i64 0
  %r43 = ptrtoint ptr %r42 to i64
  %t45 = call i64 @nova_rt_eq(i64 %r41, i64 %r43)
  %r44 = and i64 %t45, 1
  %t46 = icmp ne i64 %t45, 0
  br i1 %t46, label %then15, label %else16
then15:
  %r47 = load i64, ptr %slot.result, align 8
  %r48 = getelementptr inbounds [4 x i8], ptr @.str.12, i64 0, i64 0
  %r49 = ptrtoint ptr %r48 to i64
  %r50 = call i64 @nova_rt_add(i64 %r47, i64 %r49)
  store i64 %r50, ptr %slot.result, align 8
  br label %merge17
else16:
  %r51 = load i64, ptr %slot.ch, align 8
  %r52 = getelementptr inbounds [2 x i8], ptr @.str.13, i64 0, i64 0
  %r53 = ptrtoint ptr %r52 to i64
  %t55 = call i64 @nova_rt_eq(i64 %r51, i64 %r53)
  %r54 = and i64 %t55, 1
  %t56 = icmp ne i64 %t55, 0
  br i1 %t56, label %then18, label %else19
then18:
  %r57 = load i64, ptr %slot.result, align 8
  %r58 = getelementptr inbounds [3 x i8], ptr @.str.14, i64 0, i64 0
  %r59 = ptrtoint ptr %r58 to i64
  %r60 = call i64 @nova_rt_add(i64 %r57, i64 %r59)
  store i64 %r60, ptr %slot.result, align 8
  br label %merge20
else19:
  %r61 = load i64, ptr %slot.ch, align 8
  %r62 = getelementptr inbounds [2 x i8], ptr @.str.15, i64 0, i64 0
  %r63 = ptrtoint ptr %r62 to i64
  %t65 = call i64 @nova_rt_eq(i64 %r61, i64 %r63)
  %r64 = and i64 %t65, 1
  %t66 = icmp ne i64 %t65, 0
  br i1 %t66, label %then21, label %else22
then21:
  %r67 = load i64, ptr %slot.result, align 8
  %r68 = getelementptr inbounds [4 x i8], ptr @.str.16, i64 0, i64 0
  %r69 = ptrtoint ptr %r68 to i64
  %r70 = call i64 @nova_rt_add(i64 %r67, i64 %r69)
  store i64 %r70, ptr %slot.result, align 8
  br label %merge23
else22:
  %r71 = load i64, ptr %slot.result, align 8
  %r72 = load i64, ptr %slot.ch, align 8
  %r73 = call i64 @nova_rt_add(i64 %r71, i64 %r72)
  store i64 %r73, ptr %slot.result, align 8
  br label %merge23
merge23:
  br label %merge20
merge20:
  br label %merge17
merge17:
  br label %merge14
merge14:
  br label %merge11
merge11:
  br label %merge8
merge8:
  %r74 = load i64, ptr %slot.i, align 8
  %r75 = call i64 @nova_rt_add(i64 %r74, i64 1)
  store i64 %r75, ptr %slot.i, align 8
  br label %while_hdr3
while_exit5:
  %r76 = load i64, ptr %slot.result, align 8
  ret i64 %r76
}

define i64 @emit_inst(i64 %p0, i64 %p1) nounwind {
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
  %slot.dest2 = alloca i64, align 8
  store i64 0, ptr %slot.dest2, align 8
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
  %slot.size = alloca i64, align 8
  store i64 0, ptr %slot.size, align 8
  %slot.fi = alloca i64, align 8
  store i64 0, ptr %slot.fi, align 8
  %slot.gep = alloca i64, align 8
  store i64 0, ptr %slot.gep, align 8
  %slot.ptr_name = alloca i64, align 8
  store i64 0, ptr %slot.ptr_name, align 8
  %slot.ptr_name2 = alloca i64, align 8
  store i64 0, ptr %slot.ptr_name2, align 8
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
  %r17 = getelementptr inbounds [10 x i8], ptr @.str.17, i64 0, i64 0
  %r18 = ptrtoint ptr %r17 to i64
  %t20 = call i64 @nova_rt_eq(i64 %r16, i64 %r18)
  %r19 = and i64 %t20, 1
  %t21 = icmp ne i64 %t20, 0
  br i1 %t21, label %ret_then24, label %ret_else25
ret_then24:
  %r22 = load i64, ptr %slot.e, align 8
  %r23 = getelementptr inbounds [3 x i8], ptr @.str.18, i64 0, i64 0
  %r24 = ptrtoint ptr %r23 to i64
  %r25 = load i64, ptr %slot.dest, align 8
  %r26 = call i64 @nova_rt_add(i64 %r24, i64 %r25)
  %r27 = getelementptr inbounds [4 x i8], ptr @.str.19, i64 0, i64 0
  %r28 = ptrtoint ptr %r27 to i64
  %r29 = call i64 @nova_rt_add(i64 %r26, i64 %r28)
  %r30 = load i64, ptr %slot.num, align 8
  %r31 = call i64 @nova_rt_int_to_str(i64 %r30)
  %r32 = call i64 @nova_rt_add(i64 %r29, i64 %r31)
  %r33 = call i64 @emit_indent_line(i64 %r22, i64 %r32)
  ret i64 %r33
ret_else25:
  %r34 = load i64, ptr %slot.op, align 8
  %r35 = getelementptr inbounds [10 x i8], ptr @.str.20, i64 0, i64 0
  %r36 = ptrtoint ptr %r35 to i64
  %t38 = call i64 @nova_rt_eq(i64 %r34, i64 %r36)
  %r37 = and i64 %t38, 1
  %t39 = icmp ne i64 %t38, 0
  br i1 %t39, label %ret_then26, label %ret_else27
ret_then26:
  %r40 = load i64, ptr %slot.e, align 8
  %r41 = load i64, ptr %slot.value, align 8
  %r42 = call i64 @intern_string_lit(i64 %r40, i64 %r41)
  store i64 %r42, ptr %slot.str_name, align 8
  %r43 = load i64, ptr %slot.value, align 8
  %r44 = call i64 @nova_rt_len_any(i64 %r43)
  %r45 = call i64 @nova_rt_add(i64 %r44, i64 1)
  store i64 %r45, ptr %slot.byte_len, align 8
  %r46 = load i64, ptr %slot.e, align 8
  %r47 = load i64, ptr %slot.dest, align 8
  %r48 = getelementptr inbounds [28 x i8], ptr @.str.21, i64 0, i64 0
  %r49 = ptrtoint ptr %r48 to i64
  %r50 = call i64 @nova_rt_add(i64 %r47, i64 %r49)
  %r51 = load i64, ptr %slot.byte_len, align 8
  %r52 = call i64 @nova_rt_int_to_str(i64 %r51)
  %r53 = call i64 @nova_rt_add(i64 %r50, i64 %r52)
  %r54 = getelementptr inbounds [13 x i8], ptr @.str.22, i64 0, i64 0
  %r55 = ptrtoint ptr %r54 to i64
  %r56 = call i64 @nova_rt_add(i64 %r53, i64 %r55)
  %r57 = load i64, ptr %slot.str_name, align 8
  %r58 = call i64 @nova_rt_add(i64 %r56, i64 %r57)
  %r59 = getelementptr inbounds [15 x i8], ptr @.str.23, i64 0, i64 0
  %r60 = ptrtoint ptr %r59 to i64
  %r61 = call i64 @nova_rt_add(i64 %r58, i64 %r60)
  %r62 = call i64 @emit_indent_line(i64 %r46, i64 %r61)
  %r63 = load i64, ptr %slot.dest, align 8
  %r64 = getelementptr inbounds [3 x i8], ptr @.str.24, i64 0, i64 0
  %r65 = ptrtoint ptr %r64 to i64
  %r66 = call i64 @nova_rt_add(i64 %r63, i64 %r65)
  store i64 %r66, ptr %slot.dest2, align 8
  %r67 = load i64, ptr %slot.e, align 8
  %r68 = load i64, ptr %slot.dest2, align 8
  %r69 = getelementptr inbounds [17 x i8], ptr @.str.25, i64 0, i64 0
  %r70 = ptrtoint ptr %r69 to i64
  %r71 = call i64 @nova_rt_add(i64 %r68, i64 %r70)
  %r72 = load i64, ptr %slot.dest, align 8
  %r73 = call i64 @nova_rt_add(i64 %r71, i64 %r72)
  %r74 = getelementptr inbounds [8 x i8], ptr @.str.26, i64 0, i64 0
  %r75 = ptrtoint ptr %r74 to i64
  %r76 = call i64 @nova_rt_add(i64 %r73, i64 %r75)
  %r77 = call i64 @emit_indent_line(i64 %r67, i64 %r76)
  ret i64 %r77
ret_else27:
  %r78 = load i64, ptr %slot.op, align 8
  %r79 = getelementptr inbounds [4 x i8], ptr @.str.27, i64 0, i64 0
  %r80 = ptrtoint ptr %r79 to i64
  %t82 = call i64 @nova_rt_eq(i64 %r78, i64 %r80)
  %r81 = and i64 %t82, 1
  %t83 = icmp ne i64 %t82, 0
  br i1 %t83, label %ret_then28, label %ret_else29
ret_then28:
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
  %r95 = getelementptr inbounds [4 x i8], ptr @.str.28, i64 0, i64 0
  %r96 = ptrtoint ptr %r95 to i64
  %t98 = call i64 @nova_rt_eq(i64 %r94, i64 %r96)
  %r97 = and i64 %t98, 1
  %t99 = icmp ne i64 %t98, 0
  br i1 %t99, label %ret_then30, label %ret_else31
ret_then30:
  %r100 = load i64, ptr %slot.e, align 8
  %r101 = load i64, ptr %slot.dest, align 8
  %r102 = getelementptr inbounds [12 x i8], ptr @.str.29, i64 0, i64 0
  %r103 = ptrtoint ptr %r102 to i64
  %r104 = call i64 @nova_rt_add(i64 %r101, i64 %r103)
  %r105 = load i64, ptr %slot.args, align 8
  %r106 = call i64 @nova_rt_index_get(i64 %r105, i64 0)
  %r107 = call i64 @nova_rt_add(i64 %r104, i64 %r106)
  %r108 = getelementptr inbounds [3 x i8], ptr @.str.30, i64 0, i64 0
  %r109 = ptrtoint ptr %r108 to i64
  %r110 = call i64 @nova_rt_add(i64 %r107, i64 %r109)
  %r111 = load i64, ptr %slot.args, align 8
  %r112 = call i64 @nova_rt_index_get(i64 %r111, i64 1)
  %r113 = call i64 @nova_rt_add(i64 %r110, i64 %r112)
  %r114 = call i64 @emit_indent_line(i64 %r100, i64 %r113)
  ret i64 %r114
ret_else31:
  %r115 = load i64, ptr %slot.tk, align 8
  %r116 = getelementptr inbounds [4 x i8], ptr @.str.31, i64 0, i64 0
  %r117 = ptrtoint ptr %r116 to i64
  %t119 = call i64 @nova_rt_eq(i64 %r115, i64 %r117)
  %r118 = and i64 %t119, 1
  %t120 = icmp ne i64 %t119, 0
  br i1 %t120, label %ret_then32, label %ret_else33
ret_then32:
  %r121 = load i64, ptr %slot.e, align 8
  %r122 = load i64, ptr %slot.dest, align 8
  %r123 = getelementptr inbounds [37 x i8], ptr @.str.32, i64 0, i64 0
  %r124 = ptrtoint ptr %r123 to i64
  %r125 = call i64 @nova_rt_add(i64 %r122, i64 %r124)
  %r126 = load i64, ptr %slot.args, align 8
  %r127 = call i64 @nova_rt_index_get(i64 %r126, i64 0)
  %r128 = call i64 @nova_rt_add(i64 %r125, i64 %r127)
  %r129 = getelementptr inbounds [7 x i8], ptr @.str.33, i64 0, i64 0
  %r130 = ptrtoint ptr %r129 to i64
  %r131 = call i64 @nova_rt_add(i64 %r128, i64 %r130)
  %r132 = load i64, ptr %slot.args, align 8
  %r133 = call i64 @nova_rt_index_get(i64 %r132, i64 1)
  %r134 = call i64 @nova_rt_add(i64 %r131, i64 %r133)
  %r135 = getelementptr inbounds [2 x i8], ptr @.str.34, i64 0, i64 0
  %r136 = ptrtoint ptr %r135 to i64
  %r137 = call i64 @nova_rt_add(i64 %r134, i64 %r136)
  %r138 = call i64 @emit_indent_line(i64 %r121, i64 %r137)
  ret i64 %r138
ret_else33:
  %r139 = load i64, ptr %slot.e, align 8
  %r140 = load i64, ptr %slot.dest, align 8
  %r141 = getelementptr inbounds [30 x i8], ptr @.str.35, i64 0, i64 0
  %r142 = ptrtoint ptr %r141 to i64
  %r143 = call i64 @nova_rt_add(i64 %r140, i64 %r142)
  %r144 = load i64, ptr %slot.args, align 8
  %r145 = call i64 @nova_rt_index_get(i64 %r144, i64 0)
  %r146 = call i64 @nova_rt_add(i64 %r143, i64 %r145)
  %r147 = getelementptr inbounds [7 x i8], ptr @.str.33, i64 0, i64 0
  %r148 = ptrtoint ptr %r147 to i64
  %r149 = call i64 @nova_rt_add(i64 %r146, i64 %r148)
  %r150 = load i64, ptr %slot.args, align 8
  %r151 = call i64 @nova_rt_index_get(i64 %r150, i64 1)
  %r152 = call i64 @nova_rt_add(i64 %r149, i64 %r151)
  %r153 = getelementptr inbounds [2 x i8], ptr @.str.34, i64 0, i64 0
  %r154 = ptrtoint ptr %r153 to i64
  %r155 = call i64 @nova_rt_add(i64 %r152, i64 %r154)
  %r156 = call i64 @emit_indent_line(i64 %r139, i64 %r155)
  ret i64 %r156
ret_else29:
  %r157 = load i64, ptr %slot.op, align 8
  %r158 = getelementptr inbounds [4 x i8], ptr @.str.36, i64 0, i64 0
  %r159 = ptrtoint ptr %r158 to i64
  %t161 = call i64 @nova_rt_eq(i64 %r157, i64 %r159)
  %r160 = and i64 %t161, 1
  %t162 = icmp ne i64 %t161, 0
  br i1 %t162, label %ret_then34, label %ret_else35
ret_then34:
  %r163 = load i64, ptr %slot.e, align 8
  %r164 = load i64, ptr %slot.dest, align 8
  %r165 = getelementptr inbounds [12 x i8], ptr @.str.37, i64 0, i64 0
  %r166 = ptrtoint ptr %r165 to i64
  %r167 = call i64 @nova_rt_add(i64 %r164, i64 %r166)
  %r168 = load i64, ptr %slot.args, align 8
  %r169 = call i64 @nova_rt_index_get(i64 %r168, i64 0)
  %r170 = call i64 @nova_rt_add(i64 %r167, i64 %r169)
  %r171 = getelementptr inbounds [3 x i8], ptr @.str.30, i64 0, i64 0
  %r172 = ptrtoint ptr %r171 to i64
  %r173 = call i64 @nova_rt_add(i64 %r170, i64 %r172)
  %r174 = load i64, ptr %slot.args, align 8
  %r175 = call i64 @nova_rt_index_get(i64 %r174, i64 1)
  %r176 = call i64 @nova_rt_add(i64 %r173, i64 %r175)
  %r177 = call i64 @emit_indent_line(i64 %r163, i64 %r176)
  ret i64 %r177
ret_else35:
  %r178 = load i64, ptr %slot.op, align 8
  %r179 = getelementptr inbounds [4 x i8], ptr @.str.38, i64 0, i64 0
  %r180 = ptrtoint ptr %r179 to i64
  %t182 = call i64 @nova_rt_eq(i64 %r178, i64 %r180)
  %r181 = and i64 %t182, 1
  %t183 = icmp ne i64 %t182, 0
  br i1 %t183, label %ret_then36, label %ret_else37
ret_then36:
  %r184 = load i64, ptr %slot.e, align 8
  %r185 = load i64, ptr %slot.dest, align 8
  %r186 = getelementptr inbounds [12 x i8], ptr @.str.39, i64 0, i64 0
  %r187 = ptrtoint ptr %r186 to i64
  %r188 = call i64 @nova_rt_add(i64 %r185, i64 %r187)
  %r189 = load i64, ptr %slot.args, align 8
  %r190 = call i64 @nova_rt_index_get(i64 %r189, i64 0)
  %r191 = call i64 @nova_rt_add(i64 %r188, i64 %r190)
  %r192 = getelementptr inbounds [3 x i8], ptr @.str.30, i64 0, i64 0
  %r193 = ptrtoint ptr %r192 to i64
  %r194 = call i64 @nova_rt_add(i64 %r191, i64 %r193)
  %r195 = load i64, ptr %slot.args, align 8
  %r196 = call i64 @nova_rt_index_get(i64 %r195, i64 1)
  %r197 = call i64 @nova_rt_add(i64 %r194, i64 %r196)
  %r198 = call i64 @emit_indent_line(i64 %r184, i64 %r197)
  ret i64 %r198
ret_else37:
  %r199 = load i64, ptr %slot.op, align 8
  %r200 = getelementptr inbounds [4 x i8], ptr @.str.40, i64 0, i64 0
  %r201 = ptrtoint ptr %r200 to i64
  %t203 = call i64 @nova_rt_eq(i64 %r199, i64 %r201)
  %r202 = and i64 %t203, 1
  %t204 = icmp ne i64 %t203, 0
  br i1 %t204, label %ret_then38, label %ret_else39
ret_then38:
  %r205 = load i64, ptr %slot.e, align 8
  %r206 = load i64, ptr %slot.dest, align 8
  %r207 = getelementptr inbounds [13 x i8], ptr @.str.41, i64 0, i64 0
  %r208 = ptrtoint ptr %r207 to i64
  %r209 = call i64 @nova_rt_add(i64 %r206, i64 %r208)
  %r210 = load i64, ptr %slot.args, align 8
  %r211 = call i64 @nova_rt_index_get(i64 %r210, i64 0)
  %r212 = call i64 @nova_rt_add(i64 %r209, i64 %r211)
  %r213 = getelementptr inbounds [3 x i8], ptr @.str.30, i64 0, i64 0
  %r214 = ptrtoint ptr %r213 to i64
  %r215 = call i64 @nova_rt_add(i64 %r212, i64 %r214)
  %r216 = load i64, ptr %slot.args, align 8
  %r217 = call i64 @nova_rt_index_get(i64 %r216, i64 1)
  %r218 = call i64 @nova_rt_add(i64 %r215, i64 %r217)
  %r219 = call i64 @emit_indent_line(i64 %r205, i64 %r218)
  ret i64 %r219
ret_else39:
  %r220 = load i64, ptr %slot.op, align 8
  %r221 = getelementptr inbounds [4 x i8], ptr @.str.42, i64 0, i64 0
  %r222 = ptrtoint ptr %r221 to i64
  %t224 = call i64 @nova_rt_eq(i64 %r220, i64 %r222)
  %r223 = and i64 %t224, 1
  %t225 = icmp ne i64 %t224, 0
  br i1 %t225, label %ret_then40, label %ret_else41
ret_then40:
  %r226 = load i64, ptr %slot.e, align 8
  %r227 = load i64, ptr %slot.dest, align 8
  %r228 = getelementptr inbounds [13 x i8], ptr @.str.43, i64 0, i64 0
  %r229 = ptrtoint ptr %r228 to i64
  %r230 = call i64 @nova_rt_add(i64 %r227, i64 %r229)
  %r231 = load i64, ptr %slot.args, align 8
  %r232 = call i64 @nova_rt_index_get(i64 %r231, i64 0)
  %r233 = call i64 @nova_rt_add(i64 %r230, i64 %r232)
  %r234 = getelementptr inbounds [3 x i8], ptr @.str.30, i64 0, i64 0
  %r235 = ptrtoint ptr %r234 to i64
  %r236 = call i64 @nova_rt_add(i64 %r233, i64 %r235)
  %r237 = load i64, ptr %slot.args, align 8
  %r238 = call i64 @nova_rt_index_get(i64 %r237, i64 1)
  %r239 = call i64 @nova_rt_add(i64 %r236, i64 %r238)
  %r240 = call i64 @emit_indent_line(i64 %r226, i64 %r239)
  ret i64 %r240
ret_else41:
  %r241 = load i64, ptr %slot.op, align 8
  %r242 = getelementptr inbounds [4 x i8], ptr @.str.44, i64 0, i64 0
  %r243 = ptrtoint ptr %r242 to i64
  %t245 = call i64 @nova_rt_eq(i64 %r241, i64 %r243)
  %r244 = and i64 %t245, 1
  %t246 = icmp ne i64 %t245, 0
  br i1 %t246, label %ret_then42, label %ret_else43
ret_then42:
  %r247 = load i64, ptr %slot.e, align 8
  %r248 = load i64, ptr %slot.dest, align 8
  %r249 = getelementptr inbounds [15 x i8], ptr @.str.45, i64 0, i64 0
  %r250 = ptrtoint ptr %r249 to i64
  %r251 = call i64 @nova_rt_add(i64 %r248, i64 %r250)
  %r252 = load i64, ptr %slot.args, align 8
  %r253 = call i64 @nova_rt_index_get(i64 %r252, i64 0)
  %r254 = call i64 @nova_rt_add(i64 %r251, i64 %r253)
  %r255 = call i64 @emit_indent_line(i64 %r247, i64 %r254)
  ret i64 %r255
ret_else43:
  %r256 = load i64, ptr %slot.op, align 8
  %r257 = getelementptr inbounds [3 x i8], ptr @.str.46, i64 0, i64 0
  %r258 = ptrtoint ptr %r257 to i64
  %t260 = call i64 @nova_rt_eq(i64 %r256, i64 %r258)
  %r259 = and i64 %t260, 1
  %t261 = icmp ne i64 %t260, 0
  br i1 %t261, label %ret_then44, label %ret_else45
ret_then44:
  %r262 = load i64, ptr %slot.dest, align 8
  %r263 = getelementptr inbounds [5 x i8], ptr @.str.47, i64 0, i64 0
  %r264 = ptrtoint ptr %r263 to i64
  %r265 = call i64 @nova_rt_add(i64 %r262, i64 %r264)
  store i64 %r265, ptr %slot.tmp, align 8
  %r266 = load i64, ptr %slot.e, align 8
  %r267 = load i64, ptr %slot.tmp, align 8
  %r268 = getelementptr inbounds [16 x i8], ptr @.str.48, i64 0, i64 0
  %r269 = ptrtoint ptr %r268 to i64
  %r270 = call i64 @nova_rt_add(i64 %r267, i64 %r269)
  %r271 = load i64, ptr %slot.args, align 8
  %r272 = call i64 @nova_rt_index_get(i64 %r271, i64 0)
  %r273 = call i64 @nova_rt_add(i64 %r270, i64 %r272)
  %r274 = getelementptr inbounds [3 x i8], ptr @.str.30, i64 0, i64 0
  %r275 = ptrtoint ptr %r274 to i64
  %r276 = call i64 @nova_rt_add(i64 %r273, i64 %r275)
  %r277 = load i64, ptr %slot.args, align 8
  %r278 = call i64 @nova_rt_index_get(i64 %r277, i64 1)
  %r279 = call i64 @nova_rt_add(i64 %r276, i64 %r278)
  %r280 = call i64 @emit_indent_line(i64 %r266, i64 %r279)
  %r281 = load i64, ptr %slot.e, align 8
  %r282 = load i64, ptr %slot.dest, align 8
  %r283 = getelementptr inbounds [12 x i8], ptr @.str.49, i64 0, i64 0
  %r284 = ptrtoint ptr %r283 to i64
  %r285 = call i64 @nova_rt_add(i64 %r282, i64 %r284)
  %r286 = load i64, ptr %slot.tmp, align 8
  %r287 = call i64 @nova_rt_add(i64 %r285, i64 %r286)
  %r288 = getelementptr inbounds [8 x i8], ptr @.str.26, i64 0, i64 0
  %r289 = ptrtoint ptr %r288 to i64
  %r290 = call i64 @nova_rt_add(i64 %r287, i64 %r289)
  %r291 = call i64 @emit_indent_line(i64 %r281, i64 %r290)
  ret i64 %r291
ret_else45:
  %r292 = load i64, ptr %slot.op, align 8
  %r293 = getelementptr inbounds [4 x i8], ptr @.str.50, i64 0, i64 0
  %r294 = ptrtoint ptr %r293 to i64
  %t296 = call i64 @nova_rt_eq(i64 %r292, i64 %r294)
  %r295 = and i64 %t296, 1
  %t297 = icmp ne i64 %t296, 0
  br i1 %t297, label %ret_then46, label %ret_else47
ret_then46:
  %r298 = load i64, ptr %slot.dest, align 8
  %r299 = getelementptr inbounds [5 x i8], ptr @.str.47, i64 0, i64 0
  %r300 = ptrtoint ptr %r299 to i64
  %r301 = call i64 @nova_rt_add(i64 %r298, i64 %r300)
  store i64 %r301, ptr %slot.tmp, align 8
  %r302 = load i64, ptr %slot.e, align 8
  %r303 = load i64, ptr %slot.tmp, align 8
  %r304 = getelementptr inbounds [16 x i8], ptr @.str.51, i64 0, i64 0
  %r305 = ptrtoint ptr %r304 to i64
  %r306 = call i64 @nova_rt_add(i64 %r303, i64 %r305)
  %r307 = load i64, ptr %slot.args, align 8
  %r308 = call i64 @nova_rt_index_get(i64 %r307, i64 0)
  %r309 = call i64 @nova_rt_add(i64 %r306, i64 %r308)
  %r310 = getelementptr inbounds [3 x i8], ptr @.str.30, i64 0, i64 0
  %r311 = ptrtoint ptr %r310 to i64
  %r312 = call i64 @nova_rt_add(i64 %r309, i64 %r311)
  %r313 = load i64, ptr %slot.args, align 8
  %r314 = call i64 @nova_rt_index_get(i64 %r313, i64 1)
  %r315 = call i64 @nova_rt_add(i64 %r312, i64 %r314)
  %r316 = call i64 @emit_indent_line(i64 %r302, i64 %r315)
  %r317 = load i64, ptr %slot.e, align 8
  %r318 = load i64, ptr %slot.dest, align 8
  %r319 = getelementptr inbounds [12 x i8], ptr @.str.49, i64 0, i64 0
  %r320 = ptrtoint ptr %r319 to i64
  %r321 = call i64 @nova_rt_add(i64 %r318, i64 %r320)
  %r322 = load i64, ptr %slot.tmp, align 8
  %r323 = call i64 @nova_rt_add(i64 %r321, i64 %r322)
  %r324 = getelementptr inbounds [8 x i8], ptr @.str.26, i64 0, i64 0
  %r325 = ptrtoint ptr %r324 to i64
  %r326 = call i64 @nova_rt_add(i64 %r323, i64 %r325)
  %r327 = call i64 @emit_indent_line(i64 %r317, i64 %r326)
  ret i64 %r327
ret_else47:
  %r328 = load i64, ptr %slot.op, align 8
  %r329 = getelementptr inbounds [3 x i8], ptr @.str.52, i64 0, i64 0
  %r330 = ptrtoint ptr %r329 to i64
  %t332 = call i64 @nova_rt_eq(i64 %r328, i64 %r330)
  %r331 = and i64 %t332, 1
  %t333 = icmp ne i64 %t332, 0
  br i1 %t333, label %ret_then48, label %ret_else49
ret_then48:
  %r334 = load i64, ptr %slot.dest, align 8
  %r335 = getelementptr inbounds [5 x i8], ptr @.str.47, i64 0, i64 0
  %r336 = ptrtoint ptr %r335 to i64
  %r337 = call i64 @nova_rt_add(i64 %r334, i64 %r336)
  store i64 %r337, ptr %slot.tmp, align 8
  %r338 = load i64, ptr %slot.e, align 8
  %r339 = load i64, ptr %slot.tmp, align 8
  %r340 = getelementptr inbounds [17 x i8], ptr @.str.53, i64 0, i64 0
  %r341 = ptrtoint ptr %r340 to i64
  %r342 = call i64 @nova_rt_add(i64 %r339, i64 %r341)
  %r343 = load i64, ptr %slot.args, align 8
  %r344 = call i64 @nova_rt_index_get(i64 %r343, i64 0)
  %r345 = call i64 @nova_rt_add(i64 %r342, i64 %r344)
  %r346 = getelementptr inbounds [3 x i8], ptr @.str.30, i64 0, i64 0
  %r347 = ptrtoint ptr %r346 to i64
  %r348 = call i64 @nova_rt_add(i64 %r345, i64 %r347)
  %r349 = load i64, ptr %slot.args, align 8
  %r350 = call i64 @nova_rt_index_get(i64 %r349, i64 1)
  %r351 = call i64 @nova_rt_add(i64 %r348, i64 %r350)
  %r352 = call i64 @emit_indent_line(i64 %r338, i64 %r351)
  %r353 = load i64, ptr %slot.e, align 8
  %r354 = load i64, ptr %slot.dest, align 8
  %r355 = getelementptr inbounds [12 x i8], ptr @.str.49, i64 0, i64 0
  %r356 = ptrtoint ptr %r355 to i64
  %r357 = call i64 @nova_rt_add(i64 %r354, i64 %r356)
  %r358 = load i64, ptr %slot.tmp, align 8
  %r359 = call i64 @nova_rt_add(i64 %r357, i64 %r358)
  %r360 = getelementptr inbounds [8 x i8], ptr @.str.26, i64 0, i64 0
  %r361 = ptrtoint ptr %r360 to i64
  %r362 = call i64 @nova_rt_add(i64 %r359, i64 %r361)
  %r363 = call i64 @emit_indent_line(i64 %r353, i64 %r362)
  ret i64 %r363
ret_else49:
  %r364 = load i64, ptr %slot.op, align 8
  %r365 = getelementptr inbounds [3 x i8], ptr @.str.54, i64 0, i64 0
  %r366 = ptrtoint ptr %r365 to i64
  %t368 = call i64 @nova_rt_eq(i64 %r364, i64 %r366)
  %r367 = and i64 %t368, 1
  %t369 = icmp ne i64 %t368, 0
  br i1 %t369, label %ret_then50, label %ret_else51
ret_then50:
  %r370 = load i64, ptr %slot.dest, align 8
  %r371 = getelementptr inbounds [5 x i8], ptr @.str.47, i64 0, i64 0
  %r372 = ptrtoint ptr %r371 to i64
  %r373 = call i64 @nova_rt_add(i64 %r370, i64 %r372)
  store i64 %r373, ptr %slot.tmp, align 8
  %r374 = load i64, ptr %slot.e, align 8
  %r375 = load i64, ptr %slot.tmp, align 8
  %r376 = getelementptr inbounds [17 x i8], ptr @.str.55, i64 0, i64 0
  %r377 = ptrtoint ptr %r376 to i64
  %r378 = call i64 @nova_rt_add(i64 %r375, i64 %r377)
  %r379 = load i64, ptr %slot.args, align 8
  %r380 = call i64 @nova_rt_index_get(i64 %r379, i64 0)
  %r381 = call i64 @nova_rt_add(i64 %r378, i64 %r380)
  %r382 = getelementptr inbounds [3 x i8], ptr @.str.30, i64 0, i64 0
  %r383 = ptrtoint ptr %r382 to i64
  %r384 = call i64 @nova_rt_add(i64 %r381, i64 %r383)
  %r385 = load i64, ptr %slot.args, align 8
  %r386 = call i64 @nova_rt_index_get(i64 %r385, i64 1)
  %r387 = call i64 @nova_rt_add(i64 %r384, i64 %r386)
  %r388 = call i64 @emit_indent_line(i64 %r374, i64 %r387)
  %r389 = load i64, ptr %slot.e, align 8
  %r390 = load i64, ptr %slot.dest, align 8
  %r391 = getelementptr inbounds [12 x i8], ptr @.str.49, i64 0, i64 0
  %r392 = ptrtoint ptr %r391 to i64
  %r393 = call i64 @nova_rt_add(i64 %r390, i64 %r392)
  %r394 = load i64, ptr %slot.tmp, align 8
  %r395 = call i64 @nova_rt_add(i64 %r393, i64 %r394)
  %r396 = getelementptr inbounds [8 x i8], ptr @.str.26, i64 0, i64 0
  %r397 = ptrtoint ptr %r396 to i64
  %r398 = call i64 @nova_rt_add(i64 %r395, i64 %r397)
  %r399 = call i64 @emit_indent_line(i64 %r389, i64 %r398)
  ret i64 %r399
ret_else51:
  %r400 = load i64, ptr %slot.op, align 8
  %r401 = getelementptr inbounds [3 x i8], ptr @.str.56, i64 0, i64 0
  %r402 = ptrtoint ptr %r401 to i64
  %t404 = call i64 @nova_rt_eq(i64 %r400, i64 %r402)
  %r403 = and i64 %t404, 1
  %t405 = icmp ne i64 %t404, 0
  br i1 %t405, label %ret_then52, label %ret_else53
ret_then52:
  %r406 = load i64, ptr %slot.dest, align 8
  %r407 = getelementptr inbounds [5 x i8], ptr @.str.47, i64 0, i64 0
  %r408 = ptrtoint ptr %r407 to i64
  %r409 = call i64 @nova_rt_add(i64 %r406, i64 %r408)
  store i64 %r409, ptr %slot.tmp, align 8
  %r410 = load i64, ptr %slot.e, align 8
  %r411 = load i64, ptr %slot.tmp, align 8
  %r412 = getelementptr inbounds [17 x i8], ptr @.str.57, i64 0, i64 0
  %r413 = ptrtoint ptr %r412 to i64
  %r414 = call i64 @nova_rt_add(i64 %r411, i64 %r413)
  %r415 = load i64, ptr %slot.args, align 8
  %r416 = call i64 @nova_rt_index_get(i64 %r415, i64 0)
  %r417 = call i64 @nova_rt_add(i64 %r414, i64 %r416)
  %r418 = getelementptr inbounds [3 x i8], ptr @.str.30, i64 0, i64 0
  %r419 = ptrtoint ptr %r418 to i64
  %r420 = call i64 @nova_rt_add(i64 %r417, i64 %r419)
  %r421 = load i64, ptr %slot.args, align 8
  %r422 = call i64 @nova_rt_index_get(i64 %r421, i64 1)
  %r423 = call i64 @nova_rt_add(i64 %r420, i64 %r422)
  %r424 = call i64 @emit_indent_line(i64 %r410, i64 %r423)
  %r425 = load i64, ptr %slot.e, align 8
  %r426 = load i64, ptr %slot.dest, align 8
  %r427 = getelementptr inbounds [12 x i8], ptr @.str.49, i64 0, i64 0
  %r428 = ptrtoint ptr %r427 to i64
  %r429 = call i64 @nova_rt_add(i64 %r426, i64 %r428)
  %r430 = load i64, ptr %slot.tmp, align 8
  %r431 = call i64 @nova_rt_add(i64 %r429, i64 %r430)
  %r432 = getelementptr inbounds [8 x i8], ptr @.str.26, i64 0, i64 0
  %r433 = ptrtoint ptr %r432 to i64
  %r434 = call i64 @nova_rt_add(i64 %r431, i64 %r433)
  %r435 = call i64 @emit_indent_line(i64 %r425, i64 %r434)
  ret i64 %r435
ret_else53:
  %r436 = load i64, ptr %slot.op, align 8
  %r437 = getelementptr inbounds [3 x i8], ptr @.str.58, i64 0, i64 0
  %r438 = ptrtoint ptr %r437 to i64
  %t440 = call i64 @nova_rt_eq(i64 %r436, i64 %r438)
  %r439 = and i64 %t440, 1
  %t441 = icmp ne i64 %t440, 0
  br i1 %t441, label %ret_then54, label %ret_else55
ret_then54:
  %r442 = load i64, ptr %slot.dest, align 8
  %r443 = getelementptr inbounds [5 x i8], ptr @.str.47, i64 0, i64 0
  %r444 = ptrtoint ptr %r443 to i64
  %r445 = call i64 @nova_rt_add(i64 %r442, i64 %r444)
  store i64 %r445, ptr %slot.tmp, align 8
  %r446 = load i64, ptr %slot.e, align 8
  %r447 = load i64, ptr %slot.tmp, align 8
  %r448 = getelementptr inbounds [17 x i8], ptr @.str.59, i64 0, i64 0
  %r449 = ptrtoint ptr %r448 to i64
  %r450 = call i64 @nova_rt_add(i64 %r447, i64 %r449)
  %r451 = load i64, ptr %slot.args, align 8
  %r452 = call i64 @nova_rt_index_get(i64 %r451, i64 0)
  %r453 = call i64 @nova_rt_add(i64 %r450, i64 %r452)
  %r454 = getelementptr inbounds [3 x i8], ptr @.str.30, i64 0, i64 0
  %r455 = ptrtoint ptr %r454 to i64
  %r456 = call i64 @nova_rt_add(i64 %r453, i64 %r455)
  %r457 = load i64, ptr %slot.args, align 8
  %r458 = call i64 @nova_rt_index_get(i64 %r457, i64 1)
  %r459 = call i64 @nova_rt_add(i64 %r456, i64 %r458)
  %r460 = call i64 @emit_indent_line(i64 %r446, i64 %r459)
  %r461 = load i64, ptr %slot.e, align 8
  %r462 = load i64, ptr %slot.dest, align 8
  %r463 = getelementptr inbounds [12 x i8], ptr @.str.49, i64 0, i64 0
  %r464 = ptrtoint ptr %r463 to i64
  %r465 = call i64 @nova_rt_add(i64 %r462, i64 %r464)
  %r466 = load i64, ptr %slot.tmp, align 8
  %r467 = call i64 @nova_rt_add(i64 %r465, i64 %r466)
  %r468 = getelementptr inbounds [8 x i8], ptr @.str.26, i64 0, i64 0
  %r469 = ptrtoint ptr %r468 to i64
  %r470 = call i64 @nova_rt_add(i64 %r467, i64 %r469)
  %r471 = call i64 @emit_indent_line(i64 %r461, i64 %r470)
  ret i64 %r471
ret_else55:
  %r472 = load i64, ptr %slot.op, align 8
  %r473 = getelementptr inbounds [4 x i8], ptr @.str.60, i64 0, i64 0
  %r474 = ptrtoint ptr %r473 to i64
  %t476 = call i64 @nova_rt_eq(i64 %r472, i64 %r474)
  %r475 = and i64 %t476, 1
  %t477 = icmp ne i64 %t476, 0
  br i1 %t477, label %ret_then56, label %ret_else57
ret_then56:
  %r478 = load i64, ptr %slot.dest, align 8
  %r479 = getelementptr inbounds [5 x i8], ptr @.str.47, i64 0, i64 0
  %r480 = ptrtoint ptr %r479 to i64
  %r481 = call i64 @nova_rt_add(i64 %r478, i64 %r480)
  store i64 %r481, ptr %slot.tmp, align 8
  %r482 = load i64, ptr %slot.e, align 8
  %r483 = load i64, ptr %slot.tmp, align 8
  %r484 = getelementptr inbounds [16 x i8], ptr @.str.48, i64 0, i64 0
  %r485 = ptrtoint ptr %r484 to i64
  %r486 = call i64 @nova_rt_add(i64 %r483, i64 %r485)
  %r487 = load i64, ptr %slot.args, align 8
  %r488 = call i64 @nova_rt_index_get(i64 %r487, i64 0)
  %r489 = call i64 @nova_rt_add(i64 %r486, i64 %r488)
  %r490 = getelementptr inbounds [4 x i8], ptr @.str.61, i64 0, i64 0
  %r491 = ptrtoint ptr %r490 to i64
  %r492 = call i64 @nova_rt_add(i64 %r489, i64 %r491)
  %r493 = call i64 @emit_indent_line(i64 %r482, i64 %r492)
  %r494 = load i64, ptr %slot.e, align 8
  %r495 = load i64, ptr %slot.dest, align 8
  %r496 = getelementptr inbounds [12 x i8], ptr @.str.49, i64 0, i64 0
  %r497 = ptrtoint ptr %r496 to i64
  %r498 = call i64 @nova_rt_add(i64 %r495, i64 %r497)
  %r499 = load i64, ptr %slot.tmp, align 8
  %r500 = call i64 @nova_rt_add(i64 %r498, i64 %r499)
  %r501 = getelementptr inbounds [8 x i8], ptr @.str.26, i64 0, i64 0
  %r502 = ptrtoint ptr %r501 to i64
  %r503 = call i64 @nova_rt_add(i64 %r500, i64 %r502)
  %r504 = call i64 @emit_indent_line(i64 %r494, i64 %r503)
  ret i64 %r504
ret_else57:
  %r505 = load i64, ptr %slot.op, align 8
  %r506 = getelementptr inbounds [10 x i8], ptr @.str.62, i64 0, i64 0
  %r507 = ptrtoint ptr %r506 to i64
  %t509 = call i64 @nova_rt_eq(i64 %r505, i64 %r507)
  %r508 = and i64 %t509, 1
  %t510 = icmp ne i64 %t509, 0
  br i1 %t510, label %ret_then58, label %ret_else59
ret_then58:
  %r511 = load i64, ptr %slot.e, align 8
  %r512 = load i64, ptr %slot.dest, align 8
  %r513 = getelementptr inbounds [24 x i8], ptr @.str.63, i64 0, i64 0
  %r514 = ptrtoint ptr %r513 to i64
  %r515 = call i64 @nova_rt_add(i64 %r512, i64 %r514)
  %r516 = load i64, ptr %slot.value, align 8
  %r517 = call i64 @nova_rt_add(i64 %r515, i64 %r516)
  %r518 = getelementptr inbounds [10 x i8], ptr @.str.64, i64 0, i64 0
  %r519 = ptrtoint ptr %r518 to i64
  %r520 = call i64 @nova_rt_add(i64 %r517, i64 %r519)
  %r521 = call i64 @emit_indent_line(i64 %r511, i64 %r520)
  ret i64 %r521
ret_else59:
  %r522 = load i64, ptr %slot.op, align 8
  %r523 = getelementptr inbounds [11 x i8], ptr @.str.65, i64 0, i64 0
  %r524 = ptrtoint ptr %r523 to i64
  %t526 = call i64 @nova_rt_eq(i64 %r522, i64 %r524)
  %r525 = and i64 %t526, 1
  %t527 = icmp ne i64 %t526, 0
  br i1 %t527, label %ret_then60, label %ret_else61
ret_then60:
  %r528 = load i64, ptr %slot.e, align 8
  %r529 = getelementptr inbounds [11 x i8], ptr @.str.66, i64 0, i64 0
  %r530 = ptrtoint ptr %r529 to i64
  %r531 = load i64, ptr %slot.args, align 8
  %r532 = call i64 @nova_rt_index_get(i64 %r531, i64 0)
  %r533 = call i64 @nova_rt_add(i64 %r530, i64 %r532)
  %r534 = getelementptr inbounds [13 x i8], ptr @.str.67, i64 0, i64 0
  %r535 = ptrtoint ptr %r534 to i64
  %r536 = call i64 @nova_rt_add(i64 %r533, i64 %r535)
  %r537 = load i64, ptr %slot.value, align 8
  %r538 = call i64 @nova_rt_add(i64 %r536, i64 %r537)
  %r539 = getelementptr inbounds [10 x i8], ptr @.str.64, i64 0, i64 0
  %r540 = ptrtoint ptr %r539 to i64
  %r541 = call i64 @nova_rt_add(i64 %r538, i64 %r540)
  %r542 = call i64 @emit_indent_line(i64 %r528, i64 %r541)
  ret i64 %r542
ret_else61:
  %r543 = load i64, ptr %slot.op, align 8
  %r544 = getelementptr inbounds [5 x i8], ptr @.str.68, i64 0, i64 0
  %r545 = ptrtoint ptr %r544 to i64
  %t547 = call i64 @nova_rt_eq(i64 %r543, i64 %r545)
  %r546 = and i64 %t547, 1
  %t548 = icmp ne i64 %t547, 0
  br i1 %t548, label %ret_then62, label %ret_else63
ret_then62:
  %r549 = getelementptr inbounds [11 x i8], ptr @.str.69, i64 0, i64 0
  %r550 = ptrtoint ptr %r549 to i64
  %r551 = load i64, ptr %slot.value, align 8
  %r552 = call i64 @nova_rt_add(i64 %r550, i64 %r551)
  %r553 = getelementptr inbounds [2 x i8], ptr @.str.70, i64 0, i64 0
  %r554 = ptrtoint ptr %r553 to i64
  %r555 = call i64 @nova_rt_add(i64 %r552, i64 %r554)
  store i64 %r555, ptr %slot.call_str, align 8
  store i64 0, ptr %slot.i, align 8
  br label %while_hdr64
while_hdr64:
  %r556 = load i64, ptr %slot.i, align 8
  %r557 = load i64, ptr %slot.args, align 8
  %r558 = call i64 @nova_rt_len_any(i64 %r557)
  %t560 = icmp slt i64 %r556, %r558
  %r559 = zext i1 %t560 to i64
  %t561 = icmp ne i64 %r559, 0
  br i1 %t561, label %while_body65, label %while_exit66
while_body65:
  %r562 = load i64, ptr %slot.i, align 8
  %t564 = icmp sgt i64 %r562, 0
  %r563 = zext i1 %t564 to i64
  %t565 = icmp ne i64 %r563, 0
  br i1 %t565, label %then67, label %else68
then67:
  %r566 = load i64, ptr %slot.call_str, align 8
  %r567 = getelementptr inbounds [3 x i8], ptr @.str.30, i64 0, i64 0
  %r568 = ptrtoint ptr %r567 to i64
  %r569 = call i64 @nova_rt_add(i64 %r566, i64 %r568)
  store i64 %r569, ptr %slot.call_str, align 8
  br label %merge69
else68:
  br label %merge69
merge69:
  %r570 = load i64, ptr %slot.call_str, align 8
  %r571 = getelementptr inbounds [5 x i8], ptr @.str.71, i64 0, i64 0
  %r572 = ptrtoint ptr %r571 to i64
  %r573 = call i64 @nova_rt_add(i64 %r570, i64 %r572)
  %r574 = load i64, ptr %slot.args, align 8
  %r575 = load i64, ptr %slot.i, align 8
  %r576 = call i64 @nova_rt_index_get(i64 %r574, i64 %r575)
  %r577 = call i64 @nova_rt_add(i64 %r573, i64 %r576)
  store i64 %r577, ptr %slot.call_str, align 8
  %r578 = load i64, ptr %slot.i, align 8
  %r579 = call i64 @nova_rt_add(i64 %r578, i64 1)
  store i64 %r579, ptr %slot.i, align 8
  br label %while_hdr64
while_exit66:
  %r580 = load i64, ptr %slot.call_str, align 8
  %r581 = getelementptr inbounds [2 x i8], ptr @.str.34, i64 0, i64 0
  %r582 = ptrtoint ptr %r581 to i64
  %r583 = call i64 @nova_rt_add(i64 %r580, i64 %r582)
  store i64 %r583, ptr %slot.call_str, align 8
  %r584 = load i64, ptr %slot.dest, align 8
  %r585 = getelementptr inbounds [1 x i8], ptr @.str.5, i64 0, i64 0
  %r586 = ptrtoint ptr %r585 to i64
  %t588 = call i64 @nova_rt_neq(i64 %r584, i64 %r586)
  %t589 = icmp ne i64 %t588, 0
  br i1 %t589, label %ret_then70, label %ret_else71
ret_then70:
  %r590 = load i64, ptr %slot.e, align 8
  %r591 = load i64, ptr %slot.dest, align 8
  %r592 = getelementptr inbounds [4 x i8], ptr @.str.19, i64 0, i64 0
  %r593 = ptrtoint ptr %r592 to i64
  %r594 = call i64 @nova_rt_add(i64 %r591, i64 %r593)
  %r595 = load i64, ptr %slot.call_str, align 8
  %r596 = call i64 @nova_rt_add(i64 %r594, i64 %r595)
  %r597 = call i64 @emit_indent_line(i64 %r590, i64 %r596)
  ret i64 %r597
ret_else71:
  %r598 = load i64, ptr %slot.e, align 8
  %r599 = load i64, ptr %slot.call_str, align 8
  %r600 = call i64 @emit_indent_line(i64 %r598, i64 %r599)
  ret i64 %r600
ret_else63:
  %r601 = load i64, ptr %slot.op, align 8
  %r602 = getelementptr inbounds [12 x i8], ptr @.str.72, i64 0, i64 0
  %r603 = ptrtoint ptr %r602 to i64
  %t605 = call i64 @nova_rt_eq(i64 %r601, i64 %r603)
  %r604 = and i64 %t605, 1
  %t606 = icmp ne i64 %t605, 0
  br i1 %t606, label %ret_then72, label %ret_else73
ret_then72:
  %r607 = getelementptr inbounds [11 x i8], ptr @.str.69, i64 0, i64 0
  %r608 = ptrtoint ptr %r607 to i64
  %r609 = load i64, ptr %slot.value, align 8
  %r610 = call i64 @nova_rt_add(i64 %r608, i64 %r609)
  %r611 = getelementptr inbounds [2 x i8], ptr @.str.70, i64 0, i64 0
  %r612 = ptrtoint ptr %r611 to i64
  %r613 = call i64 @nova_rt_add(i64 %r610, i64 %r612)
  store i64 %r613, ptr %slot.call_str, align 8
  store i64 0, ptr %slot.i, align 8
  br label %while_hdr74
while_hdr74:
  %r614 = load i64, ptr %slot.i, align 8
  %r615 = load i64, ptr %slot.args, align 8
  %r616 = call i64 @nova_rt_len_any(i64 %r615)
  %t618 = icmp slt i64 %r614, %r616
  %r617 = zext i1 %t618 to i64
  %t619 = icmp ne i64 %r617, 0
  br i1 %t619, label %while_body75, label %while_exit76
while_body75:
  %r620 = load i64, ptr %slot.i, align 8
  %t622 = icmp sgt i64 %r620, 0
  %r621 = zext i1 %t622 to i64
  %t623 = icmp ne i64 %r621, 0
  br i1 %t623, label %then77, label %else78
then77:
  %r624 = load i64, ptr %slot.call_str, align 8
  %r625 = getelementptr inbounds [3 x i8], ptr @.str.30, i64 0, i64 0
  %r626 = ptrtoint ptr %r625 to i64
  %r627 = call i64 @nova_rt_add(i64 %r624, i64 %r626)
  store i64 %r627, ptr %slot.call_str, align 8
  br label %merge79
else78:
  br label %merge79
merge79:
  %r628 = load i64, ptr %slot.call_str, align 8
  %r629 = getelementptr inbounds [5 x i8], ptr @.str.71, i64 0, i64 0
  %r630 = ptrtoint ptr %r629 to i64
  %r631 = call i64 @nova_rt_add(i64 %r628, i64 %r630)
  %r632 = load i64, ptr %slot.args, align 8
  %r633 = load i64, ptr %slot.i, align 8
  %r634 = call i64 @nova_rt_index_get(i64 %r632, i64 %r633)
  %r635 = call i64 @nova_rt_add(i64 %r631, i64 %r634)
  store i64 %r635, ptr %slot.call_str, align 8
  %r636 = load i64, ptr %slot.i, align 8
  %r637 = call i64 @nova_rt_add(i64 %r636, i64 1)
  store i64 %r637, ptr %slot.i, align 8
  br label %while_hdr74
while_exit76:
  %r638 = load i64, ptr %slot.call_str, align 8
  %r639 = getelementptr inbounds [11 x i8], ptr @.str.73, i64 0, i64 0
  %r640 = ptrtoint ptr %r639 to i64
  %r641 = call i64 @nova_rt_add(i64 %r638, i64 %r640)
  store i64 %r641, ptr %slot.call_str, align 8
  %r642 = load i64, ptr %slot.dest, align 8
  %r643 = getelementptr inbounds [1 x i8], ptr @.str.5, i64 0, i64 0
  %r644 = ptrtoint ptr %r643 to i64
  %t646 = call i64 @nova_rt_neq(i64 %r642, i64 %r644)
  %t647 = icmp ne i64 %t646, 0
  br i1 %t647, label %ret_then80, label %ret_else81
ret_then80:
  %r648 = load i64, ptr %slot.e, align 8
  %r649 = load i64, ptr %slot.dest, align 8
  %r650 = getelementptr inbounds [4 x i8], ptr @.str.19, i64 0, i64 0
  %r651 = ptrtoint ptr %r650 to i64
  %r652 = call i64 @nova_rt_add(i64 %r649, i64 %r651)
  %r653 = load i64, ptr %slot.call_str, align 8
  %r654 = call i64 @nova_rt_add(i64 %r652, i64 %r653)
  %r655 = call i64 @emit_indent_line(i64 %r648, i64 %r654)
  ret i64 %r655
ret_else81:
  %r656 = load i64, ptr %slot.e, align 8
  %r657 = load i64, ptr %slot.call_str, align 8
  %r658 = call i64 @emit_indent_line(i64 %r656, i64 %r657)
  ret i64 %r658
ret_else73:
  %r659 = load i64, ptr %slot.op, align 8
  %r660 = getelementptr inbounds [12 x i8], ptr @.str.74, i64 0, i64 0
  %r661 = ptrtoint ptr %r660 to i64
  %t663 = call i64 @nova_rt_eq(i64 %r659, i64 %r661)
  %r662 = and i64 %t663, 1
  %t664 = icmp ne i64 %t663, 0
  br i1 %t664, label %ret_then82, label %ret_else83
ret_then82:
  %r665 = load i64, ptr %slot.num, align 8
  %r666 = mul i64 %r665, 8
  store i64 %r666, ptr %slot.size, align 8
  %r667 = load i64, ptr %slot.e, align 8
  %r668 = load i64, ptr %slot.dest, align 8
  %r669 = getelementptr inbounds [43 x i8], ptr @.str.75, i64 0, i64 0
  %r670 = ptrtoint ptr %r669 to i64
  %r671 = call i64 @nova_rt_add(i64 %r668, i64 %r670)
  %r672 = load i64, ptr %slot.size, align 8
  %r673 = call i64 @nova_rt_int_to_str(i64 %r672)
  %r674 = call i64 @nova_rt_add(i64 %r671, i64 %r673)
  %r675 = getelementptr inbounds [2 x i8], ptr @.str.34, i64 0, i64 0
  %r676 = ptrtoint ptr %r675 to i64
  %r677 = call i64 @nova_rt_add(i64 %r674, i64 %r676)
  %r678 = call i64 @emit_indent_line(i64 %r667, i64 %r677)
  store i64 0, ptr %slot.fi, align 8
  br label %while_hdr84
while_hdr84:
  %r679 = load i64, ptr %slot.fi, align 8
  %r680 = load i64, ptr %slot.args, align 8
  %r681 = call i64 @nova_rt_len_any(i64 %r680)
  %t683 = icmp slt i64 %r679, %r681
  %r682 = zext i1 %t683 to i64
  %t684 = icmp ne i64 %r682, 0
  br i1 %t684, label %while_body85, label %while_exit86
while_body85:
  %r685 = load i64, ptr %slot.dest, align 8
  %r686 = getelementptr inbounds [3 x i8], ptr @.str.76, i64 0, i64 0
  %r687 = ptrtoint ptr %r686 to i64
  %r688 = call i64 @nova_rt_add(i64 %r685, i64 %r687)
  %r689 = load i64, ptr %slot.fi, align 8
  %r690 = call i64 @nova_rt_int_to_str(i64 %r689)
  %r691 = call i64 @nova_rt_add(i64 %r688, i64 %r690)
  store i64 %r691, ptr %slot.gep, align 8
  %r692 = load i64, ptr %slot.e, align 8
  %r693 = load i64, ptr %slot.gep, align 8
  %r694 = getelementptr inbounds [27 x i8], ptr @.str.77, i64 0, i64 0
  %r695 = ptrtoint ptr %r694 to i64
  %r696 = call i64 @nova_rt_add(i64 %r693, i64 %r695)
  %r697 = load i64, ptr %slot.dest, align 8
  %r698 = call i64 @nova_rt_add(i64 %r696, i64 %r697)
  %r699 = getelementptr inbounds [11 x i8], ptr @.str.78, i64 0, i64 0
  %r700 = ptrtoint ptr %r699 to i64
  %r701 = call i64 @nova_rt_add(i64 %r698, i64 %r700)
  %r702 = load i64, ptr %slot.fi, align 8
  %r703 = call i64 @nova_rt_int_to_str(i64 %r702)
  %r704 = call i64 @nova_rt_add(i64 %r701, i64 %r703)
  %r705 = call i64 @emit_indent_line(i64 %r692, i64 %r704)
  %r706 = load i64, ptr %slot.e, align 8
  %r707 = getelementptr inbounds [11 x i8], ptr @.str.66, i64 0, i64 0
  %r708 = ptrtoint ptr %r707 to i64
  %r709 = load i64, ptr %slot.args, align 8
  %r710 = load i64, ptr %slot.fi, align 8
  %r711 = call i64 @nova_rt_index_get(i64 %r709, i64 %r710)
  %r712 = call i64 @nova_rt_add(i64 %r708, i64 %r711)
  %r713 = getelementptr inbounds [7 x i8], ptr @.str.79, i64 0, i64 0
  %r714 = ptrtoint ptr %r713 to i64
  %r715 = call i64 @nova_rt_add(i64 %r712, i64 %r714)
  %r716 = load i64, ptr %slot.gep, align 8
  %r717 = call i64 @nova_rt_add(i64 %r715, i64 %r716)
  %r718 = getelementptr inbounds [10 x i8], ptr @.str.64, i64 0, i64 0
  %r719 = ptrtoint ptr %r718 to i64
  %r720 = call i64 @nova_rt_add(i64 %r717, i64 %r719)
  %r721 = call i64 @emit_indent_line(i64 %r706, i64 %r720)
  %r722 = load i64, ptr %slot.fi, align 8
  %r723 = call i64 @nova_rt_add(i64 %r722, i64 1)
  store i64 %r723, ptr %slot.fi, align 8
  br label %while_hdr84
while_exit86:
  %r724 = load i64, ptr %slot.e, align 8
  %r725 = load i64, ptr %slot.dest, align 8
  %r726 = getelementptr inbounds [17 x i8], ptr @.str.25, i64 0, i64 0
  %r727 = ptrtoint ptr %r726 to i64
  %r728 = call i64 @nova_rt_add(i64 %r725, i64 %r727)
  %r729 = load i64, ptr %slot.dest, align 8
  %r730 = call i64 @nova_rt_add(i64 %r728, i64 %r729)
  %r731 = getelementptr inbounds [12 x i8], ptr @.str.80, i64 0, i64 0
  %r732 = ptrtoint ptr %r731 to i64
  %r733 = call i64 @nova_rt_add(i64 %r730, i64 %r732)
  %r734 = call i64 @emit_indent_line(i64 %r724, i64 %r733)
  ret i64 %r734
ret_else83:
  %r735 = load i64, ptr %slot.op, align 8
  %r736 = getelementptr inbounds [10 x i8], ptr @.str.81, i64 0, i64 0
  %r737 = ptrtoint ptr %r736 to i64
  %t739 = call i64 @nova_rt_eq(i64 %r735, i64 %r737)
  %r738 = and i64 %t739, 1
  %t740 = icmp ne i64 %t739, 0
  br i1 %t740, label %ret_then87, label %ret_else88
ret_then87:
  %r741 = load i64, ptr %slot.dest, align 8
  %r742 = getelementptr inbounds [5 x i8], ptr @.str.82, i64 0, i64 0
  %r743 = ptrtoint ptr %r742 to i64
  %r744 = call i64 @nova_rt_add(i64 %r741, i64 %r743)
  store i64 %r744, ptr %slot.ptr_name, align 8
  %r745 = load i64, ptr %slot.e, align 8
  %r746 = load i64, ptr %slot.ptr_name, align 8
  %r747 = getelementptr inbounds [17 x i8], ptr @.str.83, i64 0, i64 0
  %r748 = ptrtoint ptr %r747 to i64
  %r749 = call i64 @nova_rt_add(i64 %r746, i64 %r748)
  %r750 = load i64, ptr %slot.args, align 8
  %r751 = call i64 @nova_rt_index_get(i64 %r750, i64 0)
  %r752 = call i64 @nova_rt_add(i64 %r749, i64 %r751)
  %r753 = getelementptr inbounds [8 x i8], ptr @.str.84, i64 0, i64 0
  %r754 = ptrtoint ptr %r753 to i64
  %r755 = call i64 @nova_rt_add(i64 %r752, i64 %r754)
  %r756 = call i64 @emit_indent_line(i64 %r745, i64 %r755)
  %r757 = load i64, ptr %slot.dest, align 8
  %r758 = getelementptr inbounds [5 x i8], ptr @.str.85, i64 0, i64 0
  %r759 = ptrtoint ptr %r758 to i64
  %r760 = call i64 @nova_rt_add(i64 %r757, i64 %r759)
  store i64 %r760, ptr %slot.gep, align 8
  %r761 = load i64, ptr %slot.e, align 8
  %r762 = load i64, ptr %slot.gep, align 8
  %r763 = getelementptr inbounds [27 x i8], ptr @.str.77, i64 0, i64 0
  %r764 = ptrtoint ptr %r763 to i64
  %r765 = call i64 @nova_rt_add(i64 %r762, i64 %r764)
  %r766 = load i64, ptr %slot.ptr_name, align 8
  %r767 = call i64 @nova_rt_add(i64 %r765, i64 %r766)
  %r768 = getelementptr inbounds [7 x i8], ptr @.str.33, i64 0, i64 0
  %r769 = ptrtoint ptr %r768 to i64
  %r770 = call i64 @nova_rt_add(i64 %r767, i64 %r769)
  %r771 = load i64, ptr %slot.num, align 8
  %r772 = call i64 @nova_rt_int_to_str(i64 %r771)
  %r773 = call i64 @nova_rt_add(i64 %r770, i64 %r772)
  %r774 = call i64 @emit_indent_line(i64 %r761, i64 %r773)
  %r775 = load i64, ptr %slot.e, align 8
  %r776 = load i64, ptr %slot.dest, align 8
  %r777 = getelementptr inbounds [18 x i8], ptr @.str.86, i64 0, i64 0
  %r778 = ptrtoint ptr %r777 to i64
  %r779 = call i64 @nova_rt_add(i64 %r776, i64 %r778)
  %r780 = load i64, ptr %slot.gep, align 8
  %r781 = call i64 @nova_rt_add(i64 %r779, i64 %r780)
  %r782 = getelementptr inbounds [10 x i8], ptr @.str.64, i64 0, i64 0
  %r783 = ptrtoint ptr %r782 to i64
  %r784 = call i64 @nova_rt_add(i64 %r781, i64 %r783)
  %r785 = call i64 @emit_indent_line(i64 %r775, i64 %r784)
  ret i64 %r785
ret_else88:
  %r786 = load i64, ptr %slot.op, align 8
  %r787 = getelementptr inbounds [10 x i8], ptr @.str.87, i64 0, i64 0
  %r788 = ptrtoint ptr %r787 to i64
  %t790 = call i64 @nova_rt_eq(i64 %r786, i64 %r788)
  %r789 = and i64 %t790, 1
  %t791 = icmp ne i64 %t790, 0
  br i1 %t791, label %ret_then89, label %ret_else90
ret_then89:
  %r792 = load i64, ptr %slot.dest, align 8
  %r793 = getelementptr inbounds [5 x i8], ptr @.str.82, i64 0, i64 0
  %r794 = ptrtoint ptr %r793 to i64
  %r795 = call i64 @nova_rt_add(i64 %r792, i64 %r794)
  store i64 %r795, ptr %slot.ptr_name, align 8
  %r796 = load i64, ptr %slot.dest, align 8
  %r797 = getelementptr inbounds [1 x i8], ptr @.str.5, i64 0, i64 0
  %r798 = ptrtoint ptr %r797 to i64
  %t800 = call i64 @nova_rt_eq(i64 %r796, i64 %r798)
  %r799 = and i64 %t800, 1
  %t801 = icmp ne i64 %t800, 0
  br i1 %t801, label %ret_then91, label %ret_else92
ret_then91:
  %r802 = getelementptr inbounds [8 x i8], ptr @.str.88, i64 0, i64 0
  %r803 = ptrtoint ptr %r802 to i64
  store i64 %r803, ptr %slot.ptr_name2, align 8
  %r804 = load i64, ptr %slot.e, align 8
  %r805 = load i64, ptr %slot.ptr_name2, align 8
  %r806 = getelementptr inbounds [17 x i8], ptr @.str.83, i64 0, i64 0
  %r807 = ptrtoint ptr %r806 to i64
  %r808 = call i64 @nova_rt_add(i64 %r805, i64 %r807)
  %r809 = load i64, ptr %slot.args, align 8
  %r810 = call i64 @nova_rt_index_get(i64 %r809, i64 0)
  %r811 = call i64 @nova_rt_add(i64 %r808, i64 %r810)
  %r812 = getelementptr inbounds [8 x i8], ptr @.str.84, i64 0, i64 0
  %r813 = ptrtoint ptr %r812 to i64
  %r814 = call i64 @nova_rt_add(i64 %r811, i64 %r813)
  %r815 = call i64 @emit_indent_line(i64 %r804, i64 %r814)
  %r816 = getelementptr inbounds [8 x i8], ptr @.str.89, i64 0, i64 0
  %r817 = ptrtoint ptr %r816 to i64
  store i64 %r817, ptr %slot.gep, align 8
  %r818 = load i64, ptr %slot.e, align 8
  %r819 = load i64, ptr %slot.gep, align 8
  %r820 = getelementptr inbounds [27 x i8], ptr @.str.77, i64 0, i64 0
  %r821 = ptrtoint ptr %r820 to i64
  %r822 = call i64 @nova_rt_add(i64 %r819, i64 %r821)
  %r823 = load i64, ptr %slot.ptr_name2, align 8
  %r824 = call i64 @nova_rt_add(i64 %r822, i64 %r823)
  %r825 = getelementptr inbounds [7 x i8], ptr @.str.33, i64 0, i64 0
  %r826 = ptrtoint ptr %r825 to i64
  %r827 = call i64 @nova_rt_add(i64 %r824, i64 %r826)
  %r828 = load i64, ptr %slot.num, align 8
  %r829 = call i64 @nova_rt_int_to_str(i64 %r828)
  %r830 = call i64 @nova_rt_add(i64 %r827, i64 %r829)
  %r831 = call i64 @emit_indent_line(i64 %r818, i64 %r830)
  %r832 = load i64, ptr %slot.e, align 8
  %r833 = getelementptr inbounds [11 x i8], ptr @.str.66, i64 0, i64 0
  %r834 = ptrtoint ptr %r833 to i64
  %r835 = load i64, ptr %slot.args, align 8
  %r836 = call i64 @nova_rt_index_get(i64 %r835, i64 1)
  %r837 = call i64 @nova_rt_add(i64 %r834, i64 %r836)
  %r838 = getelementptr inbounds [7 x i8], ptr @.str.79, i64 0, i64 0
  %r839 = ptrtoint ptr %r838 to i64
  %r840 = call i64 @nova_rt_add(i64 %r837, i64 %r839)
  %r841 = load i64, ptr %slot.gep, align 8
  %r842 = call i64 @nova_rt_add(i64 %r840, i64 %r841)
  %r843 = getelementptr inbounds [10 x i8], ptr @.str.64, i64 0, i64 0
  %r844 = ptrtoint ptr %r843 to i64
  %r845 = call i64 @nova_rt_add(i64 %r842, i64 %r844)
  %r846 = call i64 @emit_indent_line(i64 %r832, i64 %r845)
  ret i64 %r846
ret_else92:
  ret i64 0
ret_else90:
  %r847 = load i64, ptr %slot.op, align 8
  %r848 = getelementptr inbounds [10 x i8], ptr @.str.90, i64 0, i64 0
  %r849 = ptrtoint ptr %r848 to i64
  %t851 = call i64 @nova_rt_eq(i64 %r847, i64 %r849)
  %r850 = and i64 %t851, 1
  %t852 = icmp ne i64 %t851, 0
  br i1 %t852, label %ret_then93, label %ret_else94
ret_then93:
  %r853 = load i64, ptr %slot.e, align 8
  %r854 = load i64, ptr %slot.dest, align 8
  %r855 = getelementptr inbounds [36 x i8], ptr @.str.91, i64 0, i64 0
  %r856 = ptrtoint ptr %r855 to i64
  %r857 = call i64 @nova_rt_add(i64 %r854, i64 %r856)
  %r858 = load i64, ptr %slot.args, align 8
  %r859 = call i64 @nova_rt_index_get(i64 %r858, i64 0)
  %r860 = call i64 @nova_rt_add(i64 %r857, i64 %r859)
  %r861 = getelementptr inbounds [7 x i8], ptr @.str.33, i64 0, i64 0
  %r862 = ptrtoint ptr %r861 to i64
  %r863 = call i64 @nova_rt_add(i64 %r860, i64 %r862)
  %r864 = load i64, ptr %slot.args, align 8
  %r865 = call i64 @nova_rt_index_get(i64 %r864, i64 1)
  %r866 = call i64 @nova_rt_add(i64 %r863, i64 %r865)
  %r867 = getelementptr inbounds [2 x i8], ptr @.str.34, i64 0, i64 0
  %r868 = ptrtoint ptr %r867 to i64
  %r869 = call i64 @nova_rt_add(i64 %r866, i64 %r868)
  %r870 = call i64 @emit_indent_line(i64 %r853, i64 %r869)
  ret i64 %r870
ret_else94:
  %r871 = load i64, ptr %slot.op, align 8
  %r872 = getelementptr inbounds [10 x i8], ptr @.str.92, i64 0, i64 0
  %r873 = ptrtoint ptr %r872 to i64
  %t875 = call i64 @nova_rt_eq(i64 %r871, i64 %r873)
  %r874 = and i64 %t875, 1
  %t876 = icmp ne i64 %t875, 0
  br i1 %t876, label %ret_then95, label %ret_else96
ret_then95:
  %r877 = load i64, ptr %slot.e, align 8
  %r878 = getelementptr inbounds [33 x i8], ptr @.str.93, i64 0, i64 0
  %r879 = ptrtoint ptr %r878 to i64
  %r880 = load i64, ptr %slot.args, align 8
  %r881 = call i64 @nova_rt_index_get(i64 %r880, i64 0)
  %r882 = call i64 @nova_rt_add(i64 %r879, i64 %r881)
  %r883 = getelementptr inbounds [7 x i8], ptr @.str.33, i64 0, i64 0
  %r884 = ptrtoint ptr %r883 to i64
  %r885 = call i64 @nova_rt_add(i64 %r882, i64 %r884)
  %r886 = load i64, ptr %slot.args, align 8
  %r887 = call i64 @nova_rt_index_get(i64 %r886, i64 1)
  %r888 = call i64 @nova_rt_add(i64 %r885, i64 %r887)
  %r889 = getelementptr inbounds [7 x i8], ptr @.str.33, i64 0, i64 0
  %r890 = ptrtoint ptr %r889 to i64
  %r891 = call i64 @nova_rt_add(i64 %r888, i64 %r890)
  %r892 = load i64, ptr %slot.args, align 8
  %r893 = call i64 @nova_rt_index_get(i64 %r892, i64 2)
  %r894 = call i64 @nova_rt_add(i64 %r891, i64 %r893)
  %r895 = getelementptr inbounds [2 x i8], ptr @.str.34, i64 0, i64 0
  %r896 = ptrtoint ptr %r895 to i64
  %r897 = call i64 @nova_rt_add(i64 %r894, i64 %r896)
  %r898 = call i64 @emit_indent_line(i64 %r877, i64 %r897)
  ret i64 %r898
ret_else96:
  %r899 = load i64, ptr %slot.op, align 8
  %r900 = getelementptr inbounds [10 x i8], ptr @.str.94, i64 0, i64 0
  %r901 = ptrtoint ptr %r900 to i64
  %t903 = call i64 @nova_rt_eq(i64 %r899, i64 %r901)
  %r902 = and i64 %t903, 1
  %t904 = icmp ne i64 %t903, 0
  br i1 %t904, label %ret_then97, label %ret_else98
ret_then97:
  %r905 = load i64, ptr %slot.e, align 8
  %r906 = load i64, ptr %slot.dest, align 8
  %r907 = getelementptr inbounds [35 x i8], ptr @.str.95, i64 0, i64 0
  %r908 = ptrtoint ptr %r907 to i64
  %r909 = call i64 @nova_rt_add(i64 %r906, i64 %r908)
  %r910 = call i64 @emit_indent_line(i64 %r905, i64 %r909)
  store i64 0, ptr %slot.i, align 8
  br label %while_hdr99
while_hdr99:
  %r911 = load i64, ptr %slot.i, align 8
  %r912 = load i64, ptr %slot.args, align 8
  %r913 = call i64 @nova_rt_len_any(i64 %r912)
  %t915 = icmp slt i64 %r911, %r913
  %r914 = zext i1 %t915 to i64
  %t916 = icmp ne i64 %r914, 0
  br i1 %t916, label %while_body100, label %while_exit101
while_body100:
  %r917 = load i64, ptr %slot.e, align 8
  %r918 = getelementptr inbounds [35 x i8], ptr @.str.96, i64 0, i64 0
  %r919 = ptrtoint ptr %r918 to i64
  %r920 = load i64, ptr %slot.dest, align 8
  %r921 = call i64 @nova_rt_add(i64 %r919, i64 %r920)
  %r922 = getelementptr inbounds [7 x i8], ptr @.str.33, i64 0, i64 0
  %r923 = ptrtoint ptr %r922 to i64
  %r924 = call i64 @nova_rt_add(i64 %r921, i64 %r923)
  %r925 = load i64, ptr %slot.args, align 8
  %r926 = load i64, ptr %slot.i, align 8
  %r927 = call i64 @nova_rt_index_get(i64 %r925, i64 %r926)
  %r928 = call i64 @nova_rt_add(i64 %r924, i64 %r927)
  %r929 = getelementptr inbounds [2 x i8], ptr @.str.34, i64 0, i64 0
  %r930 = ptrtoint ptr %r929 to i64
  %r931 = call i64 @nova_rt_add(i64 %r928, i64 %r930)
  %r932 = call i64 @emit_indent_line(i64 %r917, i64 %r931)
  %r933 = load i64, ptr %slot.i, align 8
  %r934 = call i64 @nova_rt_add(i64 %r933, i64 1)
  store i64 %r934, ptr %slot.i, align 8
  br label %while_hdr99
while_exit101:
  ret i64 0
ret_else98:
  %r935 = load i64, ptr %slot.op, align 8
  %r936 = getelementptr inbounds [10 x i8], ptr @.str.97, i64 0, i64 0
  %r937 = ptrtoint ptr %r936 to i64
  %t939 = call i64 @nova_rt_eq(i64 %r935, i64 %r937)
  %r938 = and i64 %t939, 1
  %t940 = icmp ne i64 %t939, 0
  br i1 %t940, label %ret_then102, label %ret_else103
ret_then102:
  %r941 = load i64, ptr %slot.e, align 8
  %r942 = load i64, ptr %slot.dest, align 8
  %r943 = getelementptr inbounds [35 x i8], ptr @.str.98, i64 0, i64 0
  %r944 = ptrtoint ptr %r943 to i64
  %r945 = call i64 @nova_rt_add(i64 %r942, i64 %r944)
  %r946 = call i64 @emit_indent_line(i64 %r941, i64 %r945)
  ret i64 %r946
ret_else103:
  %r947 = load i64, ptr %slot.op, align 8
  %r948 = getelementptr inbounds [7 x i8], ptr @.str.99, i64 0, i64 0
  %r949 = ptrtoint ptr %r948 to i64
  %t951 = call i64 @nova_rt_eq(i64 %r947, i64 %r949)
  %r950 = and i64 %t951, 1
  %t952 = icmp ne i64 %t951, 0
  br i1 %t952, label %ret_then104, label %ret_else105
ret_then104:
  %r953 = load i64, ptr %slot.e, align 8
  %r954 = getelementptr inbounds [28 x i8], ptr @.str.100, i64 0, i64 0
  %r955 = ptrtoint ptr %r954 to i64
  %r956 = load i64, ptr %slot.args, align 8
  %r957 = call i64 @nova_rt_index_get(i64 %r956, i64 0)
  %r958 = call i64 @nova_rt_add(i64 %r955, i64 %r957)
  %r959 = getelementptr inbounds [2 x i8], ptr @.str.34, i64 0, i64 0
  %r960 = ptrtoint ptr %r959 to i64
  %r961 = call i64 @nova_rt_add(i64 %r958, i64 %r960)
  %r962 = call i64 @emit_indent_line(i64 %r953, i64 %r961)
  ret i64 %r962
ret_else105:
  %r963 = load i64, ptr %slot.op, align 8
  %r964 = getelementptr inbounds [7 x i8], ptr @.str.101, i64 0, i64 0
  %r965 = ptrtoint ptr %r964 to i64
  %t967 = call i64 @nova_rt_eq(i64 %r963, i64 %r965)
  %r966 = and i64 %t967, 1
  %t968 = icmp ne i64 %t967, 0
  br i1 %t968, label %ret_then106, label %ret_else107
ret_then106:
  %r969 = load i64, ptr %slot.e, align 8
  %r970 = getelementptr inbounds [28 x i8], ptr @.str.102, i64 0, i64 0
  %r971 = ptrtoint ptr %r970 to i64
  %r972 = load i64, ptr %slot.args, align 8
  %r973 = call i64 @nova_rt_index_get(i64 %r972, i64 0)
  %r974 = call i64 @nova_rt_add(i64 %r971, i64 %r973)
  %r975 = getelementptr inbounds [2 x i8], ptr @.str.34, i64 0, i64 0
  %r976 = ptrtoint ptr %r975 to i64
  %r977 = call i64 @nova_rt_add(i64 %r974, i64 %r976)
  %r978 = call i64 @emit_indent_line(i64 %r969, i64 %r977)
  ret i64 %r978
ret_else107:
  %r979 = load i64, ptr %slot.op, align 8
  %r980 = getelementptr inbounds [6 x i8], ptr @.str.103, i64 0, i64 0
  %r981 = ptrtoint ptr %r980 to i64
  %t983 = call i64 @nova_rt_eq(i64 %r979, i64 %r981)
  %r982 = and i64 %t983, 1
  %t984 = icmp ne i64 %t983, 0
  br i1 %t984, label %ret_then108, label %ret_else109
ret_then108:
  %r985 = load i64, ptr %slot.e, align 8
  %r986 = load i64, ptr %slot.dest, align 8
  %r987 = getelementptr inbounds [32 x i8], ptr @.str.104, i64 0, i64 0
  %r988 = ptrtoint ptr %r987 to i64
  %r989 = call i64 @nova_rt_add(i64 %r986, i64 %r988)
  %r990 = load i64, ptr %slot.args, align 8
  %r991 = call i64 @nova_rt_index_get(i64 %r990, i64 0)
  %r992 = call i64 @nova_rt_add(i64 %r989, i64 %r991)
  %r993 = getelementptr inbounds [2 x i8], ptr @.str.34, i64 0, i64 0
  %r994 = ptrtoint ptr %r993 to i64
  %r995 = call i64 @nova_rt_add(i64 %r992, i64 %r994)
  %r996 = call i64 @emit_indent_line(i64 %r985, i64 %r995)
  ret i64 %r996
ret_else109:
  %r997 = load i64, ptr %slot.op, align 8
  %r998 = getelementptr inbounds [12 x i8], ptr @.str.105, i64 0, i64 0
  %r999 = ptrtoint ptr %r998 to i64
  %t1001 = call i64 @nova_rt_eq(i64 %r997, i64 %r999)
  %r1000 = and i64 %t1001, 1
  %t1002 = icmp ne i64 %t1001, 0
  br i1 %t1002, label %ret_then110, label %ret_else111
ret_then110:
  %r1003 = load i64, ptr %slot.e, align 8
  %r1004 = load i64, ptr %slot.dest, align 8
  %r1005 = getelementptr inbounds [38 x i8], ptr @.str.106, i64 0, i64 0
  %r1006 = ptrtoint ptr %r1005 to i64
  %r1007 = call i64 @nova_rt_add(i64 %r1004, i64 %r1006)
  %r1008 = call i64 @emit_indent_line(i64 %r1003, i64 %r1007)
  ret i64 %r1008
ret_else111:
  %r1009 = load i64, ptr %slot.op, align 8
  %r1010 = getelementptr inbounds [10 x i8], ptr @.str.107, i64 0, i64 0
  %r1011 = ptrtoint ptr %r1010 to i64
  %t1013 = call i64 @nova_rt_eq(i64 %r1009, i64 %r1011)
  %r1012 = and i64 %t1013, 1
  %t1014 = icmp ne i64 %t1013, 0
  br i1 %t1014, label %ret_then112, label %ret_else113
ret_then112:
  %r1015 = load i64, ptr %slot.e, align 8
  %r1016 = getelementptr inbounds [37 x i8], ptr @.str.108, i64 0, i64 0
  %r1017 = ptrtoint ptr %r1016 to i64
  %r1018 = load i64, ptr %slot.args, align 8
  %r1019 = call i64 @nova_rt_index_get(i64 %r1018, i64 0)
  %r1020 = call i64 @nova_rt_add(i64 %r1017, i64 %r1019)
  %r1021 = getelementptr inbounds [7 x i8], ptr @.str.33, i64 0, i64 0
  %r1022 = ptrtoint ptr %r1021 to i64
  %r1023 = call i64 @nova_rt_add(i64 %r1020, i64 %r1022)
  %r1024 = load i64, ptr %slot.args, align 8
  %r1025 = call i64 @nova_rt_index_get(i64 %r1024, i64 1)
  %r1026 = call i64 @nova_rt_add(i64 %r1023, i64 %r1025)
  %r1027 = getelementptr inbounds [2 x i8], ptr @.str.34, i64 0, i64 0
  %r1028 = ptrtoint ptr %r1027 to i64
  %r1029 = call i64 @nova_rt_add(i64 %r1026, i64 %r1028)
  %r1030 = call i64 @emit_indent_line(i64 %r1015, i64 %r1029)
  ret i64 %r1030
ret_else113:
  %r1031 = load i64, ptr %slot.op, align 8
  %r1032 = getelementptr inbounds [10 x i8], ptr @.str.109, i64 0, i64 0
  %r1033 = ptrtoint ptr %r1032 to i64
  %t1035 = call i64 @nova_rt_eq(i64 %r1031, i64 %r1033)
  %r1034 = and i64 %t1035, 1
  %t1036 = icmp ne i64 %t1035, 0
  br i1 %t1036, label %ret_then114, label %ret_else115
ret_then114:
  %r1037 = load i64, ptr %slot.e, align 8
  %r1038 = load i64, ptr %slot.dest, align 8
  %r1039 = getelementptr inbounds [42 x i8], ptr @.str.110, i64 0, i64 0
  %r1040 = ptrtoint ptr %r1039 to i64
  %r1041 = call i64 @nova_rt_add(i64 %r1038, i64 %r1040)
  %r1042 = load i64, ptr %slot.args, align 8
  %r1043 = call i64 @nova_rt_index_get(i64 %r1042, i64 0)
  %r1044 = call i64 @nova_rt_add(i64 %r1041, i64 %r1043)
  %r1045 = getelementptr inbounds [2 x i8], ptr @.str.34, i64 0, i64 0
  %r1046 = ptrtoint ptr %r1045 to i64
  %r1047 = call i64 @nova_rt_add(i64 %r1044, i64 %r1046)
  %r1048 = call i64 @emit_indent_line(i64 %r1037, i64 %r1047)
  ret i64 %r1048
ret_else115:
  ret i64 0
}

define i64 @emit_terminator(i64 %p0, i64 %p1) nounwind {
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
  %r17 = getelementptr inbounds [7 x i8], ptr @.str.111, i64 0, i64 0
  %r18 = ptrtoint ptr %r17 to i64
  %t20 = call i64 @nova_rt_eq(i64 %r16, i64 %r18)
  %r19 = and i64 %t20, 1
  %t21 = icmp ne i64 %t20, 0
  br i1 %t21, label %ret_then116, label %ret_else117
ret_then116:
  %r22 = load i64, ptr %slot.args, align 8
  %r23 = call i64 @nova_rt_len_any(i64 %r22)
  %t25 = icmp sgt i64 %r23, 0
  %r24 = zext i1 %t25 to i64
  %t26 = icmp ne i64 %r24, 0
  br i1 %t26, label %ret_then118, label %ret_else119
ret_then118:
  %r27 = load i64, ptr %slot.e, align 8
  %r28 = getelementptr inbounds [9 x i8], ptr @.str.112, i64 0, i64 0
  %r29 = ptrtoint ptr %r28 to i64
  %r30 = load i64, ptr %slot.args, align 8
  %r31 = call i64 @nova_rt_index_get(i64 %r30, i64 0)
  %r32 = call i64 @nova_rt_add(i64 %r29, i64 %r31)
  %r33 = call i64 @emit_indent_line(i64 %r27, i64 %r32)
  ret i64 %r33
ret_else119:
  %r34 = load i64, ptr %slot.e, align 8
  %r35 = getelementptr inbounds [10 x i8], ptr @.str.113, i64 0, i64 0
  %r36 = ptrtoint ptr %r35 to i64
  %r37 = call i64 @emit_indent_line(i64 %r34, i64 %r36)
  ret i64 %r37
ret_else117:
  %r38 = load i64, ptr %slot.op, align 8
  %r39 = getelementptr inbounds [5 x i8], ptr @.str.114, i64 0, i64 0
  %r40 = ptrtoint ptr %r39 to i64
  %t42 = call i64 @nova_rt_eq(i64 %r38, i64 %r40)
  %r41 = and i64 %t42, 1
  %t43 = icmp ne i64 %t42, 0
  br i1 %t43, label %ret_then120, label %ret_else121
ret_then120:
  %r44 = load i64, ptr %slot.e, align 8
  %r45 = getelementptr inbounds [11 x i8], ptr @.str.115, i64 0, i64 0
  %r46 = ptrtoint ptr %r45 to i64
  %r47 = load i64, ptr %slot.value, align 8
  %r48 = call i64 @nova_rt_add(i64 %r46, i64 %r47)
  %r49 = call i64 @emit_indent_line(i64 %r44, i64 %r48)
  ret i64 %r49
ret_else121:
  %r50 = load i64, ptr %slot.op, align 8
  %r51 = getelementptr inbounds [7 x i8], ptr @.str.116, i64 0, i64 0
  %r52 = ptrtoint ptr %r51 to i64
  %t54 = call i64 @nova_rt_eq(i64 %r50, i64 %r52)
  %r53 = and i64 %t54, 1
  %t55 = icmp ne i64 %t54, 0
  br i1 %t55, label %ret_then122, label %ret_else123
ret_then122:
  %r56 = load i64, ptr %slot.value, align 8
  %r57 = getelementptr inbounds [4 x i8], ptr @.str.117, i64 0, i64 0
  %r58 = ptrtoint ptr %r57 to i64
  %r59 = call i64 @nova_rt_add(i64 %r56, i64 %r58)
  store i64 %r59, ptr %slot.cond_cmp, align 8
  %r60 = load i64, ptr %slot.e, align 8
  %r61 = load i64, ptr %slot.cond_cmp, align 8
  %r62 = getelementptr inbounds [16 x i8], ptr @.str.51, i64 0, i64 0
  %r63 = ptrtoint ptr %r62 to i64
  %r64 = call i64 @nova_rt_add(i64 %r61, i64 %r63)
  %r65 = load i64, ptr %slot.args, align 8
  %r66 = call i64 @nova_rt_index_get(i64 %r65, i64 0)
  %r67 = call i64 @nova_rt_add(i64 %r64, i64 %r66)
  %r68 = getelementptr inbounds [4 x i8], ptr @.str.61, i64 0, i64 0
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
ret_else123:
  ret i64 0
}

define i64 @emit_function(i64 %p0, i64 %p1) nounwind {
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
  br i1 %t17, label %then124, label %else125
then124:
  %r18 = getelementptr inbounds [14 x i8], ptr @.str.120, i64 0, i64 0
  %r19 = ptrtoint ptr %r18 to i64
  %r20 = load i64, ptr %slot.name, align 8
  %r21 = call i64 @nova_rt_add(i64 %r19, i64 %r20)
  %r22 = getelementptr inbounds [2 x i8], ptr @.str.70, i64 0, i64 0
  %r23 = ptrtoint ptr %r22 to i64
  %r24 = call i64 @nova_rt_add(i64 %r21, i64 %r23)
  store i64 %r24, ptr %slot.decl, align 8
  store i64 0, ptr %slot.i, align 8
  br label %while_hdr127
while_hdr127:
  %r25 = load i64, ptr %slot.i, align 8
  %r26 = load i64, ptr %slot.params, align 8
  %r27 = call i64 @nova_rt_len_any(i64 %r26)
  %t29 = icmp slt i64 %r25, %r27
  %r28 = zext i1 %t29 to i64
  %t30 = icmp ne i64 %r28, 0
  br i1 %t30, label %while_body128, label %while_exit129
while_body128:
  %r31 = load i64, ptr %slot.i, align 8
  %t33 = icmp sgt i64 %r31, 0
  %r32 = zext i1 %t33 to i64
  %t34 = icmp ne i64 %r32, 0
  br i1 %t34, label %then130, label %else131
then130:
  %r35 = load i64, ptr %slot.decl, align 8
  %r36 = getelementptr inbounds [3 x i8], ptr @.str.30, i64 0, i64 0
  %r37 = ptrtoint ptr %r36 to i64
  %r38 = call i64 @nova_rt_add(i64 %r35, i64 %r37)
  store i64 %r38, ptr %slot.decl, align 8
  br label %merge132
else131:
  br label %merge132
merge132:
  %r39 = load i64, ptr %slot.decl, align 8
  %r40 = getelementptr inbounds [4 x i8], ptr @.str.121, i64 0, i64 0
  %r41 = ptrtoint ptr %r40 to i64
  %r42 = call i64 @nova_rt_add(i64 %r39, i64 %r41)
  store i64 %r42, ptr %slot.decl, align 8
  %r43 = load i64, ptr %slot.i, align 8
  %r44 = call i64 @nova_rt_add(i64 %r43, i64 1)
  store i64 %r44, ptr %slot.i, align 8
  br label %while_hdr127
while_exit129:
  %r45 = load i64, ptr %slot.decl, align 8
  %r46 = getelementptr inbounds [11 x i8], ptr @.str.73, i64 0, i64 0
  %r47 = ptrtoint ptr %r46 to i64
  %r48 = call i64 @nova_rt_add(i64 %r45, i64 %r47)
  store i64 %r48, ptr %slot.decl, align 8
  %r49 = load i64, ptr %slot.e, align 8
  %r50 = load i64, ptr %slot.decl, align 8
  %r51 = call i64 @emit_line(i64 %r49, i64 %r50)
  ret i64 0
  br label %merge126
else125:
  br label %merge126
merge126:
  %r52 = getelementptr inbounds [13 x i8], ptr @.str.122, i64 0, i64 0
  %r53 = ptrtoint ptr %r52 to i64
  %r54 = load i64, ptr %slot.name, align 8
  %r55 = call i64 @nova_rt_add(i64 %r53, i64 %r54)
  %r56 = getelementptr inbounds [2 x i8], ptr @.str.70, i64 0, i64 0
  %r57 = ptrtoint ptr %r56 to i64
  %r58 = call i64 @nova_rt_add(i64 %r55, i64 %r57)
  store i64 %r58, ptr %slot.header, align 8
  store i64 0, ptr %slot.i, align 8
  br label %while_hdr133
while_hdr133:
  %r59 = load i64, ptr %slot.i, align 8
  %r60 = load i64, ptr %slot.params, align 8
  %r61 = call i64 @nova_rt_len_any(i64 %r60)
  %t63 = icmp slt i64 %r59, %r61
  %r62 = zext i1 %t63 to i64
  %t64 = icmp ne i64 %r62, 0
  br i1 %t64, label %while_body134, label %while_exit135
while_body134:
  %r65 = load i64, ptr %slot.i, align 8
  %t67 = icmp sgt i64 %r65, 0
  %r66 = zext i1 %t67 to i64
  %t68 = icmp ne i64 %r66, 0
  br i1 %t68, label %then136, label %else137
then136:
  %r69 = load i64, ptr %slot.header, align 8
  %r70 = getelementptr inbounds [3 x i8], ptr @.str.30, i64 0, i64 0
  %r71 = ptrtoint ptr %r70 to i64
  %r72 = call i64 @nova_rt_add(i64 %r69, i64 %r71)
  store i64 %r72, ptr %slot.header, align 8
  br label %merge138
else137:
  br label %merge138
merge138:
  %r73 = load i64, ptr %slot.header, align 8
  %r74 = getelementptr inbounds [7 x i8], ptr @.str.123, i64 0, i64 0
  %r75 = ptrtoint ptr %r74 to i64
  %r76 = call i64 @nova_rt_add(i64 %r73, i64 %r75)
  %r77 = load i64, ptr %slot.i, align 8
  %r78 = call i64 @nova_rt_int_to_str(i64 %r77)
  %r79 = call i64 @nova_rt_add(i64 %r76, i64 %r78)
  store i64 %r79, ptr %slot.header, align 8
  %r80 = load i64, ptr %slot.i, align 8
  %r81 = call i64 @nova_rt_add(i64 %r80, i64 1)
  store i64 %r81, ptr %slot.i, align 8
  br label %while_hdr133
while_exit135:
  %r82 = load i64, ptr %slot.header, align 8
  %r83 = getelementptr inbounds [13 x i8], ptr @.str.124, i64 0, i64 0
  %r84 = ptrtoint ptr %r83 to i64
  %r85 = call i64 @nova_rt_add(i64 %r82, i64 %r84)
  store i64 %r85, ptr %slot.header, align 8
  %r86 = load i64, ptr %slot.e, align 8
  %r87 = load i64, ptr %slot.header, align 8
  %r88 = call i64 @emit_line(i64 %r86, i64 %r87)
  %r89 = load i64, ptr %slot.blocks, align 8
  %r90 = call i64 @nova_rt_len_any(i64 %r89)
  %slot.__for_idx_139 = alloca i64, align 8
  store i64 0, ptr %slot.__for_idx_139, align 8
  br label %for_hdr139
for_hdr139:
  %r91 = load i64, ptr %slot.__for_idx_139, align 8
  %t92 = icmp slt i64 %r91, %r90
  br i1 %t92, label %for_body140, label %for_exit141
for_body140:
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
  %r104 = getelementptr inbounds [2 x i8], ptr @.str.125, i64 0, i64 0
  %r105 = ptrtoint ptr %r104 to i64
  %r106 = call i64 @nova_rt_add(i64 %r103, i64 %r105)
  %r107 = call i64 @emit_line(i64 %r102, i64 %r106)
  %r108 = load i64, ptr %slot.label, align 8
  %r109 = getelementptr inbounds [6 x i8], ptr @.str.126, i64 0, i64 0
  %r110 = ptrtoint ptr %r109 to i64
  %t112 = call i64 @nova_rt_eq(i64 %r108, i64 %r110)
  %r111 = and i64 %t112, 1
  %t113 = icmp ne i64 %t112, 0
  br i1 %t113, label %then142, label %else143
then142:
  store i64 0, ptr %slot.pi, align 8
  br label %while_hdr145
while_hdr145:
  %r114 = load i64, ptr %slot.pi, align 8
  %r115 = load i64, ptr %slot.params, align 8
  %r116 = call i64 @nova_rt_len_any(i64 %r115)
  %t118 = icmp slt i64 %r114, %r116
  %r117 = zext i1 %t118 to i64
  %t119 = icmp ne i64 %r117, 0
  br i1 %t119, label %while_body146, label %while_exit147
while_body146:
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
  %r143 = getelementptr inbounds [13 x i8], ptr @.str.67, i64 0, i64 0
  %r144 = ptrtoint ptr %r143 to i64
  %r145 = call i64 @nova_rt_add(i64 %r142, i64 %r144)
  %r146 = load i64, ptr %slot.pname, align 8
  %r147 = call i64 @nova_rt_add(i64 %r145, i64 %r146)
  %r148 = getelementptr inbounds [10 x i8], ptr @.str.64, i64 0, i64 0
  %r149 = ptrtoint ptr %r148 to i64
  %r150 = call i64 @nova_rt_add(i64 %r147, i64 %r149)
  %r151 = call i64 @emit_indent_line(i64 %r137, i64 %r150)
  %r152 = load i64, ptr %slot.pi, align 8
  %r153 = call i64 @nova_rt_add(i64 %r152, i64 1)
  store i64 %r153, ptr %slot.pi, align 8
  br label %while_hdr145
while_exit147:
  br label %merge144
else143:
  br label %merge144
merge144:
  %r154 = load i64, ptr %slot.insts, align 8
  %r155 = call i64 @nova_rt_len_any(i64 %r154)
  %slot.__for_idx_148 = alloca i64, align 8
  store i64 0, ptr %slot.__for_idx_148, align 8
  br label %for_hdr148
for_hdr148:
  %r156 = load i64, ptr %slot.__for_idx_148, align 8
  %t157 = icmp slt i64 %r156, %r155
  br i1 %t157, label %for_body149, label %for_exit150
for_body149:
  %r158 = call i64 @nova_rt_index_get(i64 %r154, i64 %r156)
  store i64 %r158, ptr %slot.inst, align 8
  %r159 = load i64, ptr %slot.e, align 8
  %r160 = load i64, ptr %slot.inst, align 8
  %r161 = call i64 @emit_inst(i64 %r159, i64 %r160)
  %r163 = load i64, ptr %slot.__for_idx_148, align 8
  %r162 = add i64 %r163, 1
  store i64 %r162, ptr %slot.__for_idx_148, align 8
  br label %for_hdr148
for_exit150:
  %r164 = load i64, ptr %slot.e, align 8
  %r165 = load i64, ptr %slot.terminator, align 8
  %r166 = call i64 @emit_terminator(i64 %r164, i64 %r165)
  %r168 = load i64, ptr %slot.__for_idx_139, align 8
  %r167 = add i64 %r168, 1
  store i64 %r167, ptr %slot.__for_idx_139, align 8
  br label %for_hdr139
for_exit141:
  %r169 = load i64, ptr %slot.e, align 8
  %r170 = getelementptr inbounds [2 x i8], ptr @.str.130, i64 0, i64 0
  %r171 = ptrtoint ptr %r170 to i64
  %r172 = call i64 @emit_line(i64 %r169, i64 %r171)
  %r173 = load i64, ptr %slot.e, align 8
  %r174 = getelementptr inbounds [1 x i8], ptr @.str.5, i64 0, i64 0
  %r175 = ptrtoint ptr %r174 to i64
  %r176 = call i64 @emit_line(i64 %r173, i64 %r175)
  ret i64 %r176
}

define i64 @ir_type_int() nounwind {
entry:
  %r0 = call ptr @nova_rt_struct_alloc(i64 32)
  %r1 = getelementptr inbounds [4 x i8], ptr @.str.28, i64 0, i64 0
  %r2 = ptrtoint ptr %r1 to i64
  %t3 = getelementptr i64, ptr %r0, i64 0
  store i64 %r2, ptr %t3, align 8
  %r4 = getelementptr inbounds [1 x i8], ptr @.str.5, i64 0, i64 0
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
  %r1 = getelementptr inbounds [5 x i8], ptr @.str.131, i64 0, i64 0
  %r2 = ptrtoint ptr %r1 to i64
  %t3 = getelementptr i64, ptr %r0, i64 0
  store i64 %r2, ptr %t3, align 8
  %r4 = getelementptr inbounds [1 x i8], ptr @.str.5, i64 0, i64 0
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
  %r1 = getelementptr inbounds [4 x i8], ptr @.str.132, i64 0, i64 0
  %r2 = ptrtoint ptr %r1 to i64
  %t3 = getelementptr i64, ptr %r0, i64 0
  store i64 %r2, ptr %t3, align 8
  %r4 = getelementptr inbounds [1 x i8], ptr @.str.5, i64 0, i64 0
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
  %r13 = getelementptr inbounds [5 x i8], ptr @.str.133, i64 0, i64 0
  %r14 = ptrtoint ptr %r13 to i64
  %t15 = getelementptr i64, ptr %r0, i64 6
  store i64 %r14, ptr %t15, align 8
  %r16 = ptrtoint ptr %r0 to i64
  ret i64 %r16
}

define i64 @test_emit() nounwind {
entry:
  %slot.e = alloca i64, align 8
  store i64 0, ptr %slot.e, align 8
  %slot.insts = alloca i64, align 8
  store i64 0, ptr %slot.insts, align 8
  %slot.term = alloca i64, align 8
  store i64 0, ptr %slot.term, align 8
  %slot.entry = alloca i64, align 8
  store i64 0, ptr %slot.entry, align 8
  %slot.params = alloca i64, align 8
  store i64 0, ptr %slot.params, align 8
  %slot.add_fn = alloca i64, align 8
  store i64 0, ptr %slot.add_fn, align 8
  %slot.line = alloca i64, align 8
  store i64 0, ptr %slot.line, align 8
  %slot.found_direct_add = alloca i64, align 8
  store i64 0, ptr %slot.found_direct_add, align 8
  %r0 = call i64 @new_emitter()
  store i64 %r0, ptr %slot.e, align 8
  %r1 = call i64 @nova_rt_list_create()
  store i64 %r1, ptr %slot.insts, align 8
  %r2 = load i64, ptr %slot.insts, align 8
  %r3 = getelementptr inbounds [10 x i8], ptr @.str.62, i64 0, i64 0
  %r4 = ptrtoint ptr %r3 to i64
  %r5 = getelementptr inbounds [4 x i8], ptr @.str.134, i64 0, i64 0
  %r6 = ptrtoint ptr %r5 to i64
  %r7 = call i64 @ir_type_int()
  %r8 = call i64 @nova_rt_list_create()
  %r9 = getelementptr inbounds [2 x i8], ptr @.str.135, i64 0, i64 0
  %r10 = ptrtoint ptr %r9 to i64
  %r11 = call i64 @ir_inst(i64 %r4, i64 %r6, i64 %r7, i64 %r8, i64 %r10, i64 0)
  %r12 = call i64 @nova_rt_list_append(i64 %r2, i64 %r11)
  %r13 = load i64, ptr %slot.insts, align 8
  %r14 = getelementptr inbounds [10 x i8], ptr @.str.62, i64 0, i64 0
  %r15 = ptrtoint ptr %r14 to i64
  %r16 = getelementptr inbounds [4 x i8], ptr @.str.136, i64 0, i64 0
  %r17 = ptrtoint ptr %r16 to i64
  %r18 = call i64 @ir_type_int()
  %r19 = call i64 @nova_rt_list_create()
  %r20 = getelementptr inbounds [2 x i8], ptr @.str.137, i64 0, i64 0
  %r21 = ptrtoint ptr %r20 to i64
  %r22 = call i64 @ir_inst(i64 %r15, i64 %r17, i64 %r18, i64 %r19, i64 %r21, i64 0)
  %r23 = call i64 @nova_rt_list_append(i64 %r13, i64 %r22)
  %r24 = load i64, ptr %slot.insts, align 8
  %r25 = getelementptr inbounds [4 x i8], ptr @.str.27, i64 0, i64 0
  %r26 = ptrtoint ptr %r25 to i64
  %r27 = getelementptr inbounds [4 x i8], ptr @.str.138, i64 0, i64 0
  %r28 = ptrtoint ptr %r27 to i64
  %r29 = call i64 @ir_type_int()
  %r30 = call i64 @nova_rt_list_create()
  %r31 = getelementptr inbounds [4 x i8], ptr @.str.134, i64 0, i64 0
  %r32 = ptrtoint ptr %r31 to i64
  %t33 = call i64 @nova_rt_list_append(i64 %r30, i64 %r32)
  %r34 = getelementptr inbounds [4 x i8], ptr @.str.136, i64 0, i64 0
  %r35 = ptrtoint ptr %r34 to i64
  %t36 = call i64 @nova_rt_list_append(i64 %r30, i64 %r35)
  %r37 = getelementptr inbounds [2 x i8], ptr @.str.139, i64 0, i64 0
  %r38 = ptrtoint ptr %r37 to i64
  %r39 = call i64 @ir_inst(i64 %r26, i64 %r28, i64 %r29, i64 %r30, i64 %r38, i64 0)
  %r40 = call i64 @nova_rt_list_append(i64 %r24, i64 %r39)
  %r41 = getelementptr inbounds [7 x i8], ptr @.str.111, i64 0, i64 0
  %r42 = ptrtoint ptr %r41 to i64
  %r43 = getelementptr inbounds [1 x i8], ptr @.str.5, i64 0, i64 0
  %r44 = ptrtoint ptr %r43 to i64
  %r45 = call i64 @ir_type_void()
  %r46 = call i64 @nova_rt_list_create()
  %r47 = getelementptr inbounds [4 x i8], ptr @.str.138, i64 0, i64 0
  %r48 = ptrtoint ptr %r47 to i64
  %t49 = call i64 @nova_rt_list_append(i64 %r46, i64 %r48)
  %r50 = getelementptr inbounds [1 x i8], ptr @.str.5, i64 0, i64 0
  %r51 = ptrtoint ptr %r50 to i64
  %r52 = call i64 @ir_inst(i64 %r42, i64 %r44, i64 %r45, i64 %r46, i64 %r51, i64 0)
  store i64 %r52, ptr %slot.term, align 8
  %r53 = call ptr @nova_rt_struct_alloc(i64 24)
  %r54 = getelementptr inbounds [6 x i8], ptr @.str.126, i64 0, i64 0
  %r55 = ptrtoint ptr %r54 to i64
  %t56 = getelementptr i64, ptr %r53, i64 0
  store i64 %r55, ptr %t56, align 8
  %r57 = load i64, ptr %slot.insts, align 8
  %t58 = getelementptr i64, ptr %r53, i64 1
  store i64 %r57, ptr %t58, align 8
  %r59 = load i64, ptr %slot.term, align 8
  %t60 = getelementptr i64, ptr %r53, i64 2
  store i64 %r59, ptr %t60, align 8
  %r61 = ptrtoint ptr %r53 to i64
  store i64 %r61, ptr %slot.entry, align 8
  %r62 = call i64 @nova_rt_list_create()
  %r63 = call ptr @nova_rt_struct_alloc(i64 16)
  %r64 = getelementptr inbounds [2 x i8], ptr @.str.135, i64 0, i64 0
  %r65 = ptrtoint ptr %r64 to i64
  %t66 = getelementptr i64, ptr %r63, i64 0
  store i64 %r65, ptr %t66, align 8
  %r67 = call i64 @ir_type_int()
  %t68 = getelementptr i64, ptr %r63, i64 1
  store i64 %r67, ptr %t68, align 8
  %r69 = ptrtoint ptr %r63 to i64
  %t70 = call i64 @nova_rt_list_append(i64 %r62, i64 %r69)
  %r71 = call ptr @nova_rt_struct_alloc(i64 16)
  %r72 = getelementptr inbounds [2 x i8], ptr @.str.137, i64 0, i64 0
  %r73 = ptrtoint ptr %r72 to i64
  %t74 = getelementptr i64, ptr %r71, i64 0
  store i64 %r73, ptr %t74, align 8
  %r75 = call i64 @ir_type_int()
  %t76 = getelementptr i64, ptr %r71, i64 1
  store i64 %r75, ptr %t76, align 8
  %r77 = ptrtoint ptr %r71 to i64
  %t78 = call i64 @nova_rt_list_append(i64 %r62, i64 %r77)
  store i64 %r62, ptr %slot.params, align 8
  %r79 = call ptr @nova_rt_struct_alloc(i64 48)
  %r80 = getelementptr inbounds [4 x i8], ptr @.str.27, i64 0, i64 0
  %r81 = ptrtoint ptr %r80 to i64
  %t82 = getelementptr i64, ptr %r79, i64 0
  store i64 %r81, ptr %t82, align 8
  %r83 = load i64, ptr %slot.params, align 8
  %t84 = getelementptr i64, ptr %r79, i64 1
  store i64 %r83, ptr %t84, align 8
  %r85 = call i64 @ir_type_int()
  %t86 = getelementptr i64, ptr %r79, i64 2
  store i64 %r85, ptr %t86, align 8
  %r87 = call i64 @nova_rt_list_create()
  %r88 = load i64, ptr %slot.entry, align 8
  %t89 = call i64 @nova_rt_list_append(i64 %r87, i64 %r88)
  %t90 = getelementptr i64, ptr %r79, i64 3
  store i64 %r87, ptr %t90, align 8
  %r91 = call i64 @nova_rt_list_create()
  %t92 = getelementptr i64, ptr %r79, i64 4
  store i64 %r91, ptr %t92, align 8
  %t93 = getelementptr i64, ptr %r79, i64 5
  store i64 0, ptr %t93, align 8
  %r94 = ptrtoint ptr %r79 to i64
  store i64 %r94, ptr %slot.add_fn, align 8
  %r95 = load i64, ptr %slot.e, align 8
  %r96 = load i64, ptr %slot.add_fn, align 8
  %r97 = call i64 @emit_function(i64 %r95, i64 %r96)
  %r98 = load i64, ptr %slot.e, align 8
  %t100 = inttoptr i64 %r98 to ptr
  %t101 = getelementptr i64, ptr %t100, i64 0
  %r99 = load i64, ptr %t101, align 8
  %r102 = call i64 @nova_rt_len_any(i64 %r99)
  %slot.__for_idx_151 = alloca i64, align 8
  store i64 0, ptr %slot.__for_idx_151, align 8
  br label %for_hdr151
for_hdr151:
  %r103 = load i64, ptr %slot.__for_idx_151, align 8
  %t104 = icmp slt i64 %r103, %r102
  br i1 %t104, label %for_body152, label %for_exit153
for_body152:
  %r105 = call i64 @nova_rt_index_get(i64 %r99, i64 %r103)
  store i64 %r105, ptr %slot.line, align 8
  %r106 = load i64, ptr %slot.line, align 8
  %r107 = call i64 @nova_rt_print_any(i64 %r106)
  %r109 = load i64, ptr %slot.__for_idx_151, align 8
  %r108 = add i64 %r109, 1
  store i64 %r108, ptr %slot.__for_idx_151, align 8
  br label %for_hdr151
for_exit153:
  store i64 0, ptr %slot.found_direct_add, align 8
  %r110 = load i64, ptr %slot.e, align 8
  %t112 = inttoptr i64 %r110 to ptr
  %t113 = getelementptr i64, ptr %t112, i64 0
  %r111 = load i64, ptr %t113, align 8
  %r114 = call i64 @nova_rt_len_any(i64 %r111)
  %slot.__for_idx_154 = alloca i64, align 8
  store i64 0, ptr %slot.__for_idx_154, align 8
  br label %for_hdr154
for_hdr154:
  %r115 = load i64, ptr %slot.__for_idx_154, align 8
  %t116 = icmp slt i64 %r115, %r114
  br i1 %t116, label %for_body155, label %for_exit156
for_body155:
  %r117 = call i64 @nova_rt_index_get(i64 %r111, i64 %r115)
  store i64 %r117, ptr %slot.line, align 8
  %r118 = load i64, ptr %slot.line, align 8
  %r119 = getelementptr inbounds [8 x i8], ptr @.str.140, i64 0, i64 0
  %r120 = ptrtoint ptr %r119 to i64
  %r121 = call i64 @nova_rt_contains(i64 %r118, i64 %r120)
  %t122 = icmp ne i64 %r121, 0
  br i1 %t122, label %then157, label %else158
then157:
  store i64 1, ptr %slot.found_direct_add, align 8
  br label %merge159
else158:
  br label %merge159
merge159:
  %r124 = load i64, ptr %slot.__for_idx_154, align 8
  %r123 = add i64 %r124, 1
  store i64 %r123, ptr %slot.__for_idx_154, align 8
  br label %for_hdr154
for_exit156:
  %r125 = load i64, ptr %slot.found_direct_add, align 8
  %t126 = icmp ne i64 %r125, 0
  br i1 %t126, label %ret_then160, label %ret_else161
ret_then160:
  %r127 = getelementptr inbounds [54 x i8], ptr @.str.141, i64 0, i64 0
  %r128 = ptrtoint ptr %r127 to i64
  %r129 = call i64 @nova_rt_print_any(i64 %r128)
  ret i64 %r129
ret_else161:
  %r130 = getelementptr inbounds [30 x i8], ptr @.str.142, i64 0, i64 0
  %r131 = ptrtoint ptr %r130 to i64
  %r132 = call i64 @nova_rt_print_any(i64 %r131)
  ret i64 %r132
}

define i64 @nova_main() nounwind {
entry:
  %r0 = call i64 @test_emit()
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
@.str.0 = private unnamed_addr constant [3 x i8] c"  \00"
@.str.1 = private unnamed_addr constant [7 x i8] c"@.str.\00"
@.str.2 = private unnamed_addr constant [35 x i8] c" = private unnamed_addr constant [\00"
@.str.3 = private unnamed_addr constant [10 x i8] c" x i8] c\22\00"
@.str.4 = private unnamed_addr constant [5 x i8] c"\\00\22\00"
@.str.5 = private unnamed_addr constant [1 x i8] c"\00"
@.str.6 = private unnamed_addr constant [2 x i8] c"\0A\00"
@.str.7 = private unnamed_addr constant [4 x i8] c"\\0A\00"
@.str.8 = private unnamed_addr constant [2 x i8] c"\0D\00"
@.str.9 = private unnamed_addr constant [4 x i8] c"\\0D\00"
@.str.10 = private unnamed_addr constant [2 x i8] c"\09\00"
@.str.11 = private unnamed_addr constant [4 x i8] c"\\09\00"
@.str.12 = private unnamed_addr constant [4 x i8] c"\\00\00"
@.str.13 = private unnamed_addr constant [2 x i8] c"\\\00"
@.str.14 = private unnamed_addr constant [3 x i8] c"\\\\\00"
@.str.15 = private unnamed_addr constant [2 x i8] c"\22\00"
@.str.16 = private unnamed_addr constant [4 x i8] c"\\22\00"
@.str.17 = private unnamed_addr constant [10 x i8] c"const_int\00"
@.str.18 = private unnamed_addr constant [3 x i8] c"; \00"
@.str.19 = private unnamed_addr constant [4 x i8] c" = \00"
@.str.20 = private unnamed_addr constant [10 x i8] c"const_str\00"
@.str.21 = private unnamed_addr constant [28 x i8] c" = getelementptr inbounds [\00"
@.str.22 = private unnamed_addr constant [13 x i8] c" x i8], ptr \00"
@.str.23 = private unnamed_addr constant [15 x i8] c", i64 0, i64 0\00"
@.str.24 = private unnamed_addr constant [3 x i8] c".i\00"
@.str.25 = private unnamed_addr constant [17 x i8] c" = ptrtoint ptr \00"
@.str.26 = private unnamed_addr constant [8 x i8] c" to i64\00"
@.str.27 = private unnamed_addr constant [4 x i8] c"add\00"
@.str.28 = private unnamed_addr constant [4 x i8] c"int\00"
@.str.29 = private unnamed_addr constant [12 x i8] c" = add i64 \00"
@.str.30 = private unnamed_addr constant [3 x i8] c", \00"
@.str.31 = private unnamed_addr constant [4 x i8] c"str\00"
@.str.32 = private unnamed_addr constant [37 x i8] c" = call i64 @nova_rt_str_concat(i64 \00"
@.str.33 = private unnamed_addr constant [7 x i8] c", i64 \00"
@.str.34 = private unnamed_addr constant [2 x i8] c")\00"
@.str.35 = private unnamed_addr constant [30 x i8] c" = call i64 @nova_rt_add(i64 \00"
@.str.36 = private unnamed_addr constant [4 x i8] c"sub\00"
@.str.37 = private unnamed_addr constant [12 x i8] c" = sub i64 \00"
@.str.38 = private unnamed_addr constant [4 x i8] c"mul\00"
@.str.39 = private unnamed_addr constant [12 x i8] c" = mul i64 \00"
@.str.40 = private unnamed_addr constant [4 x i8] c"div\00"
@.str.41 = private unnamed_addr constant [13 x i8] c" = sdiv i64 \00"
@.str.42 = private unnamed_addr constant [4 x i8] c"mod\00"
@.str.43 = private unnamed_addr constant [13 x i8] c" = srem i64 \00"
@.str.44 = private unnamed_addr constant [4 x i8] c"neg\00"
@.str.45 = private unnamed_addr constant [15 x i8] c" = sub i64 0, \00"
@.str.46 = private unnamed_addr constant [3 x i8] c"eq\00"
@.str.47 = private unnamed_addr constant [5 x i8] c".cmp\00"
@.str.48 = private unnamed_addr constant [16 x i8] c" = icmp eq i64 \00"
@.str.49 = private unnamed_addr constant [12 x i8] c" = zext i1 \00"
@.str.50 = private unnamed_addr constant [4 x i8] c"neq\00"
@.str.51 = private unnamed_addr constant [16 x i8] c" = icmp ne i64 \00"
@.str.52 = private unnamed_addr constant [3 x i8] c"lt\00"
@.str.53 = private unnamed_addr constant [17 x i8] c" = icmp slt i64 \00"
@.str.54 = private unnamed_addr constant [3 x i8] c"le\00"
@.str.55 = private unnamed_addr constant [17 x i8] c" = icmp sle i64 \00"
@.str.56 = private unnamed_addr constant [3 x i8] c"gt\00"
@.str.57 = private unnamed_addr constant [17 x i8] c" = icmp sgt i64 \00"
@.str.58 = private unnamed_addr constant [3 x i8] c"ge\00"
@.str.59 = private unnamed_addr constant [17 x i8] c" = icmp sge i64 \00"
@.str.60 = private unnamed_addr constant [4 x i8] c"not\00"
@.str.61 = private unnamed_addr constant [4 x i8] c", 0\00"
@.str.62 = private unnamed_addr constant [10 x i8] c"slot_load\00"
@.str.63 = private unnamed_addr constant [24 x i8] c" = load i64, ptr %slot.\00"
@.str.64 = private unnamed_addr constant [10 x i8] c", align 8\00"
@.str.65 = private unnamed_addr constant [11 x i8] c"slot_store\00"
@.str.66 = private unnamed_addr constant [11 x i8] c"store i64 \00"
@.str.67 = private unnamed_addr constant [13 x i8] c", ptr %slot.\00"
@.str.68 = private unnamed_addr constant [5 x i8] c"call\00"
@.str.69 = private unnamed_addr constant [11 x i8] c"call i64 @\00"
@.str.70 = private unnamed_addr constant [2 x i8] c"(\00"
@.str.71 = private unnamed_addr constant [5 x i8] c"i64 \00"
@.str.72 = private unnamed_addr constant [12 x i8] c"call_direct\00"
@.str.73 = private unnamed_addr constant [11 x i8] c") nounwind\00"
@.str.74 = private unnamed_addr constant [12 x i8] c"make_struct\00"
@.str.75 = private unnamed_addr constant [43 x i8] c".ptr = call ptr @nova_rt_struct_alloc(i64 \00"
@.str.76 = private unnamed_addr constant [3 x i8] c".f\00"
@.str.77 = private unnamed_addr constant [27 x i8] c" = getelementptr i64, ptr \00"
@.str.78 = private unnamed_addr constant [11 x i8] c".ptr, i64 \00"
@.str.79 = private unnamed_addr constant [7 x i8] c", ptr \00"
@.str.80 = private unnamed_addr constant [12 x i8] c".ptr to i64\00"
@.str.81 = private unnamed_addr constant [10 x i8] c"field_get\00"
@.str.82 = private unnamed_addr constant [5 x i8] c".ptr\00"
@.str.83 = private unnamed_addr constant [17 x i8] c" = inttoptr i64 \00"
@.str.84 = private unnamed_addr constant [8 x i8] c" to ptr\00"
@.str.85 = private unnamed_addr constant [5 x i8] c".gep\00"
@.str.86 = private unnamed_addr constant [18 x i8] c" = load i64, ptr \00"
@.str.87 = private unnamed_addr constant [10 x i8] c"field_set\00"
@.str.88 = private unnamed_addr constant [8 x i8] c"%fs_ptr\00"
@.str.89 = private unnamed_addr constant [8 x i8] c"%fs_gep\00"
@.str.90 = private unnamed_addr constant [10 x i8] c"index_get\00"
@.str.91 = private unnamed_addr constant [36 x i8] c" = call i64 @nova_rt_index_get(i64 \00"
@.str.92 = private unnamed_addr constant [10 x i8] c"index_set\00"
@.str.93 = private unnamed_addr constant [33 x i8] c"call i64 @nova_rt_index_set(i64 \00"
@.str.94 = private unnamed_addr constant [10 x i8] c"make_list\00"
@.str.95 = private unnamed_addr constant [35 x i8] c" = call i64 @nova_rt_list_create()\00"
@.str.96 = private unnamed_addr constant [35 x i8] c"call i64 @nova_rt_list_append(i64 \00"
@.str.97 = private unnamed_addr constant [10 x i8] c"make_dict\00"
@.str.98 = private unnamed_addr constant [35 x i8] c" = call i64 @nova_rt_dict_create()\00"
@.str.99 = private unnamed_addr constant [7 x i8] c"rc_inc\00"
@.str.100 = private unnamed_addr constant [28 x i8] c"call void @nova_rc_inc(i64 \00"
@.str.101 = private unnamed_addr constant [7 x i8] c"rc_dec\00"
@.str.102 = private unnamed_addr constant [28 x i8] c"call void @nova_rc_dec(i64 \00"
@.str.103 = private unnamed_addr constant [6 x i8] c"spawn\00"
@.str.104 = private unnamed_addr constant [32 x i8] c" = call i64 @nova_rt_spawn(i64 \00"
@.str.105 = private unnamed_addr constant [12 x i8] c"chan_create\00"
@.str.106 = private unnamed_addr constant [38 x i8] c" = call i64 @nova_rt_channel_create()\00"
@.str.107 = private unnamed_addr constant [10 x i8] c"chan_send\00"
@.str.108 = private unnamed_addr constant [37 x i8] c"call void @nova_rt_channel_send(i64 \00"
@.str.109 = private unnamed_addr constant [10 x i8] c"chan_recv\00"
@.str.110 = private unnamed_addr constant [42 x i8] c" = call i64 @nova_rt_channel_receive(i64 \00"
@.str.111 = private unnamed_addr constant [7 x i8] c"return\00"
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
@.str.122 = private unnamed_addr constant [13 x i8] c"define i64 @\00"
@.str.123 = private unnamed_addr constant [7 x i8] c"i64 %p\00"
@.str.124 = private unnamed_addr constant [13 x i8] c") nounwind {\00"
@.str.125 = private unnamed_addr constant [2 x i8] c":\00"
@.str.126 = private unnamed_addr constant [6 x i8] c"entry\00"
@.str.127 = private unnamed_addr constant [7 x i8] c"%slot.\00"
@.str.128 = private unnamed_addr constant [23 x i8] c" = alloca i64, align 8\00"
@.str.129 = private unnamed_addr constant [13 x i8] c"store i64 %p\00"
@.str.130 = private unnamed_addr constant [2 x i8] c"}\00"
@.str.131 = private unnamed_addr constant [5 x i8] c"void\00"
@.str.132 = private unnamed_addr constant [4 x i8] c"any\00"
@.str.133 = private unnamed_addr constant [5 x i8] c"pure\00"
@.str.134 = private unnamed_addr constant [4 x i8] c"%r0\00"
@.str.135 = private unnamed_addr constant [2 x i8] c"a\00"
@.str.136 = private unnamed_addr constant [4 x i8] c"%r1\00"
@.str.137 = private unnamed_addr constant [2 x i8] c"b\00"
@.str.138 = private unnamed_addr constant [4 x i8] c"%r2\00"
@.str.139 = private unnamed_addr constant [2 x i8] c"+\00"
@.str.140 = private unnamed_addr constant [8 x i8] c"add i64\00"
@.str.141 = private unnamed_addr constant [54 x i8] c"PASS: Emitted direct 'add i64' (zero-cost arithmetic)\00"
@.str.142 = private unnamed_addr constant [30 x i8] c"FAIL: Did not emit direct add\00"
