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

define i64 @check(i64 %p0) nounwind {
entry:
  %slot.ch = alloca i64, align 8
  store i64 %p0, ptr %slot.ch, align 8
  %r0 = load i64, ptr %slot.ch, align 8
  %r1 = getelementptr inbounds [2 x i8], ptr @.str.0, i64 0, i64 0
  %r2 = ptrtoint ptr %r1 to i64
  %t4 = call i64 @nova_rt_eq(i64 %r0, i64 %r2)
  %r3 = and i64 %t4, 1
  %r5 = load i64, ptr %slot.ch, align 8
  %r6 = getelementptr inbounds [2 x i8], ptr @.str.1, i64 0, i64 0
  %r7 = ptrtoint ptr %r6 to i64
  %t9 = call i64 @nova_rt_eq(i64 %r5, i64 %r7)
  %r8 = and i64 %t9, 1
  br label %or_entry0
or_entry0:
  %t11 = icmp ne i64 %t4, 0
  br i1 %t11, label %or_end2, label %or_rhs1
or_rhs1:
  %r12 = load i64, ptr %slot.ch, align 8
  %r13 = getelementptr inbounds [2 x i8], ptr @.str.1, i64 0, i64 0
  %r14 = ptrtoint ptr %r13 to i64
  %t16 = call i64 @nova_rt_eq(i64 %r12, i64 %r14)
  %r15 = and i64 %t16, 1
  br label %or_done3
or_done3:
  br label %or_end2
or_end2:
  %r10 = phi i64 [%t4, %or_entry0], [%t16, %or_done3]
  %t17 = icmp ne i64 %r10, 0
  br i1 %t17, label %then4, label %else5
then4:
  ret i64 1
  br label %merge6
else5:
  br label %merge6
merge6:
  ret i64 0
}

define i64 @nova_main() nounwind {
entry:
  %slot.x = alloca i64, align 8
  store i64 0, ptr %slot.x, align 8
  %slot.y = alloca i64, align 8
  store i64 0, ptr %slot.y, align 8
  %r0 = getelementptr inbounds [2 x i8], ptr @.str.2, i64 0, i64 0
  %r1 = ptrtoint ptr %r0 to i64
  %r2 = call i64 @check(i64 %r1)
  store i64 %r2, ptr %slot.x, align 8
  %r3 = load i64, ptr %slot.x, align 8
  %r4 = call i64 @nova_rt_print_any(i64 %r3)
  %r5 = getelementptr inbounds [2 x i8], ptr @.str.1, i64 0, i64 0
  %r6 = ptrtoint ptr %r5 to i64
  %r7 = call i64 @check(i64 %r6)
  store i64 %r7, ptr %slot.y, align 8
  %r8 = load i64, ptr %slot.y, align 8
  %r9 = call i64 @nova_rt_print_any(i64 %r8)
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
@.str.0 = private unnamed_addr constant [2 x i8] c" \00"
@.str.1 = private unnamed_addr constant [2 x i8] c"\0A\00"
@.str.2 = private unnamed_addr constant [2 x i8] c"a\00"
