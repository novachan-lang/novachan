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

define i64 @make_tok(i64 %p0, i64 %p1, i64 %p2, i64 %p3) nounwind {
entry:
  %slot.kind = alloca i64, align 8
  store i64 %p0, ptr %slot.kind, align 8
  %slot.val = alloca i64, align 8
  store i64 %p1, ptr %slot.val, align 8
  %slot.line = alloca i64, align 8
  store i64 %p2, ptr %slot.line, align 8
  %slot.col = alloca i64, align 8
  store i64 %p3, ptr %slot.col, align 8
  %r0 = call ptr @nova_rt_struct_alloc(i64 32)
  %r1 = load i64, ptr %slot.kind, align 8
  %t2 = getelementptr i64, ptr %r0, i64 0
  store i64 %r1, ptr %t2, align 8
  %r3 = load i64, ptr %slot.val, align 8
  %t4 = getelementptr i64, ptr %r0, i64 1
  store i64 %r3, ptr %t4, align 8
  %r5 = load i64, ptr %slot.line, align 8
  %t6 = getelementptr i64, ptr %r0, i64 2
  store i64 %r5, ptr %t6, align 8
  %r7 = load i64, ptr %slot.col, align 8
  %t8 = getelementptr i64, ptr %r0, i64 3
  store i64 %r7, ptr %t8, align 8
  %r9 = ptrtoint ptr %r0 to i64
  ret i64 %r9
}

define i64 @nova_main() nounwind {
entry:
  %slot.t1 = alloca i64, align 8
  store i64 0, ptr %slot.t1, align 8
  %slot.k = alloca i64, align 8
  store i64 0, ptr %slot.k, align 8
  %slot.v = alloca i64, align 8
  store i64 0, ptr %slot.v, align 8
  %slot.ln = alloca i64, align 8
  store i64 0, ptr %slot.ln, align 8
  %slot.co = alloca i64, align 8
  store i64 0, ptr %slot.co, align 8
  %r0 = getelementptr inbounds [3 x i8], ptr @.str.0, i64 0, i64 0
  %r1 = ptrtoint ptr %r0 to i64
  %r2 = getelementptr inbounds [4 x i8], ptr @.str.1, i64 0, i64 0
  %r3 = ptrtoint ptr %r2 to i64
  %r4 = call i64 @make_tok(i64 %r1, i64 %r3, i64 3, i64 1)
  store i64 %r4, ptr %slot.t1, align 8
  %r5 = load i64, ptr %slot.t1, align 8
  %t6 = inttoptr i64 %r5 to ptr
  %t7 = getelementptr i64, ptr %t6, i64 0
  %r8 = load i64, ptr %t7, align 8
  store i64 %r8, ptr %slot.k, align 8
  %t9 = getelementptr i64, ptr %t6, i64 1
  %r10 = load i64, ptr %t9, align 8
  store i64 %r10, ptr %slot.v, align 8
  %t11 = getelementptr i64, ptr %t6, i64 2
  %r12 = load i64, ptr %t11, align 8
  store i64 %r12, ptr %slot.ln, align 8
  %t13 = getelementptr i64, ptr %t6, i64 3
  %r14 = load i64, ptr %t13, align 8
  store i64 %r14, ptr %slot.co, align 8
  %r15 = load i64, ptr %slot.k, align 8
  %r16 = call i64 @nova_rt_print_any(i64 %r15)
  %r17 = load i64, ptr %slot.v, align 8
  %r18 = call i64 @nova_rt_print_any(i64 %r17)
  %r19 = load i64, ptr %slot.co, align 8
  %r20 = call i64 @nova_rt_print_any(i64 %r19)
  %r21 = load i64, ptr %slot.co, align 8
  %t23 = icmp sle i64 %r21, 1
  %r22 = zext i1 %t23 to i64
  %t24 = icmp ne i64 %r22, 0
  br i1 %t24, label %then0, label %else1
then0:
  %r25 = getelementptr inbounds [12 x i8], ptr @.str.2, i64 0, i64 0
  %r26 = ptrtoint ptr %r25 to i64
  %r27 = call i64 @nova_rt_print_any(i64 %r26)
  br label %merge2
else1:
  %r28 = getelementptr inbounds [13 x i8], ptr @.str.3, i64 0, i64 0
  %r29 = ptrtoint ptr %r28 to i64
  %r30 = call i64 @nova_rt_print_any(i64 %r29)
  br label %merge2
merge2:
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
@.str.0 = private unnamed_addr constant [3 x i8] c"KW\00"
@.str.1 = private unnamed_addr constant [4 x i8] c"let\00"
@.str.2 = private unnamed_addr constant [12 x i8] c"col<=1 TRUE\00"
@.str.3 = private unnamed_addr constant [13 x i8] c"col<=1 FALSE\00"
