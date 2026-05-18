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
declare i64 @nova_rt_system(i64) nounwind
declare i64 @nova_rt_exec(i64) nounwind
declare i64 @nova_rt_create_string(ptr) nounwind
declare void @nova_rt_init_args(i64, i64) nounwind
declare void @nova_rt_cleanup() nounwind

define i64 @nova_main() nounwind {
entry:
  %slot.ret = alloca i64, align 8
  store i64 0, ptr %slot.ret, align 8
  %slot.output = alloca i64, align 8
  store i64 0, ptr %slot.output, align 8
  %r0.p = getelementptr inbounds [23 x i8], ptr @.str.0, i64 0, i64 0
  %r0 = ptrtoint ptr %r0.p to i64
  %r1 = call i64 @nova_rt_system(i64 %r0)
  store i64 %r1, ptr %slot.ret, align 8
  %r2.p = getelementptr inbounds [20 x i8], ptr @.str.1, i64 0, i64 0
  %r2 = ptrtoint ptr %r2.p to i64
  %r3 = load i64, ptr %slot.ret, align 8
  %r4 = call i64 @nova_rt_int_to_str(i64 %r3)
  %r5 = call i64 @nova_rt_str_concat(i64 %r2, i64 %r4)
  %r6 = call i64 @nova_rt_print_any(i64 %r5)
  %r7.p = getelementptr inbounds [21 x i8], ptr @.str.2, i64 0, i64 0
  %r7 = ptrtoint ptr %r7.p to i64
  %r8 = call i64 @nova_rt_exec(i64 %r7)
  store i64 %r8, ptr %slot.output, align 8
  %r9.p = getelementptr inbounds [18 x i8], ptr @.str.3, i64 0, i64 0
  %r9 = ptrtoint ptr %r9.p to i64
  %r10 = load i64, ptr %slot.output, align 8
  %r11 = call i64 @nova_rt_str_concat(i64 %r9, i64 %r10)
  %r12 = call i64 @nova_rt_print_any(i64 %r11)
  %r13 = load i64, ptr %slot.ret, align 8
  %r14 = add i64 0, 0
  %r15.cmp = icmp eq i64 %r13, %r14
  %r15 = zext i1 %r15.cmp to i64
  %br_then0 = icmp ne i64 %r15, 0
  br i1 %br_then0, label %then0, label %else1
then0:
  %r16.p = getelementptr inbounds [15 x i8], ptr @.str.4, i64 0, i64 0
  %r16 = ptrtoint ptr %r16.p to i64
  %r17 = call i64 @nova_rt_print_any(i64 %r16)
  br label %endif2
else1:
  %r18.p = getelementptr inbounds [25 x i8], ptr @.str.5, i64 0, i64 0
  %r18 = ptrtoint ptr %r18.p to i64
  %r19 = load i64, ptr %slot.ret, align 8
  %r20 = call i64 @nova_rt_int_to_str(i64 %r19)
  %r21 = call i64 @nova_rt_str_concat(i64 %r18, i64 %r20)
  %r22 = call i64 @nova_rt_print_any(i64 %r21)
  br label %endif2
endif2:
  %r23 = load i64, ptr %slot.output, align 8
  %r24.p = getelementptr inbounds [16 x i8], ptr @.str.6, i64 0, i64 0
  %r24 = ptrtoint ptr %r24.p to i64
  %r25 = call i64 @nova_rt_starts_with(i64 %r23, i64 %r24)
  %br_then3 = icmp ne i64 %r25, 0
  br i1 %br_then3, label %then3, label %else4
then3:
  %r26.p = getelementptr inbounds [13 x i8], ptr @.str.7, i64 0, i64 0
  %r26 = ptrtoint ptr %r26.p to i64
  %r27 = call i64 @nova_rt_print_any(i64 %r26)
  br label %endif5
else4:
  %r28.p = getelementptr inbounds [24 x i8], ptr @.str.8, i64 0, i64 0
  %r28 = ptrtoint ptr %r28.p to i64
  %r29 = load i64, ptr %slot.output, align 8
  %r30 = call i64 @nova_rt_str_concat(i64 %r28, i64 %r29)
  %r31.p = getelementptr inbounds [2 x i8], ptr @.str.9, i64 0, i64 0
  %r31 = ptrtoint ptr %r31.p to i64
  %r32 = call i64 @nova_rt_str_concat(i64 %r30, i64 %r31)
  %r33 = call i64 @nova_rt_print_any(i64 %r32)
  br label %endif5
endif5:
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
@.str.0 = private unnamed_addr constant [23 x i8] c"echo hello_from_system\00"
@.str.1 = private unnamed_addr constant [20 x i8] c"system() returned: \00"
@.str.2 = private unnamed_addr constant [21 x i8] c"echo hello_from_exec\00"
@.str.3 = private unnamed_addr constant [18 x i8] c"exec() returned: \00"
@.str.4 = private unnamed_addr constant [15 x i8] c"PASS: system()\00"
@.str.5 = private unnamed_addr constant [25 x i8] c"FAIL: system() returned \00"
@.str.6 = private unnamed_addr constant [16 x i8] c"hello_from_exec\00"
@.str.7 = private unnamed_addr constant [13 x i8] c"PASS: exec()\00"
@.str.8 = private unnamed_addr constant [24 x i8] c"FAIL: exec() returned '\00"
@.str.9 = private unnamed_addr constant [2 x i8] c"'\00"
