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

define i64 @nova_main() nounwind {
entry:
  %slot.src = alloca i64, align 8
  store i64 0, ptr %slot.src, align 8
  %slot.i = alloca i64, align 8
  store i64 0, ptr %slot.i, align 8
  %slot.col = alloca i64, align 8
  store i64 0, ptr %slot.col, align 8
  %slot.line = alloca i64, align 8
  store i64 0, ptr %slot.line, align 8
  %slot.ch = alloca i64, align 8
  store i64 0, ptr %slot.ch, align 8
  %r0 = getelementptr inbounds [12 x i8], ptr @.str.0, i64 0, i64 0
  %r1 = ptrtoint ptr %r0 to i64
  store i64 %r1, ptr %slot.src, align 8
  store i64 0, ptr %slot.i, align 8
  store i64 1, ptr %slot.col, align 8
  store i64 1, ptr %slot.line, align 8
  br label %while_hdr0
while_hdr0:
  %r2 = load i64, ptr %slot.i, align 8
  %r3 = load i64, ptr %slot.src, align 8
  %r4 = call i64 @nova_rt_len_any(i64 %r3)
  %t6 = icmp slt i64 %r2, %r4
  %r5 = zext i1 %t6 to i64
  %t7 = icmp ne i64 %r5, 0
  br i1 %t7, label %while_body1, label %while_exit2
while_body1:
  %r8 = load i64, ptr %slot.src, align 8
  %r9 = load i64, ptr %slot.i, align 8
  %r10 = call i64 @nova_rt_index_get(i64 %r8, i64 %r9)
  store i64 %r10, ptr %slot.ch, align 8
  %r11 = load i64, ptr %slot.ch, align 8
  %r12 = getelementptr inbounds [2 x i8], ptr @.str.1, i64 0, i64 0
  %r13 = ptrtoint ptr %r12 to i64
  %t15 = call i64 @nova_rt_eq(i64 %r11, i64 %r13)
  %r14 = and i64 %t15, 1
  %t16 = icmp ne i64 %t15, 0
  br i1 %t16, label %then3, label %else4
then3:
  %r17 = load i64, ptr %slot.line, align 8
  %r18 = call i64 @nova_rt_add(i64 %r17, i64 1)
  store i64 %r18, ptr %slot.line, align 8
  store i64 1, ptr %slot.col, align 8
  %r19 = load i64, ptr %slot.i, align 8
  %r20 = call i64 @nova_rt_add(i64 %r19, i64 1)
  store i64 %r20, ptr %slot.i, align 8
  br label %merge5
else4:
  %r21 = load i64, ptr %slot.col, align 8
  %r22 = call i64 @nova_rt_add(i64 %r21, i64 1)
  store i64 %r22, ptr %slot.col, align 8
  %r23 = load i64, ptr %slot.i, align 8
  %r24 = call i64 @nova_rt_add(i64 %r23, i64 1)
  store i64 %r24, ptr %slot.i, align 8
  br label %merge5
merge5:
  br label %while_hdr0
while_exit2:
  %r25 = load i64, ptr %slot.col, align 8
  %r26 = call i64 @nova_rt_print_any(i64 %r25)
  %r27 = load i64, ptr %slot.line, align 8
  %r28 = call i64 @nova_rt_print_any(i64 %r27)
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
@.str.0 = private unnamed_addr constant [12 x i8] c"abc\0Adef\0Aghi\00"
@.str.1 = private unnamed_addr constant [2 x i8] c"\0A\00"
