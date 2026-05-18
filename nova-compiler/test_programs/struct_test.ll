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
  %slot.Point = alloca i64, align 8
  store i64 0, ptr %slot.Point, align 8
  %slot.p = alloca i64, align 8
  store i64 0, ptr %slot.p, align 8
  %slot.x = alloca i64, align 8
  store i64 0, ptr %slot.x, align 8
  %slot.y = alloca i64, align 8
  store i64 0, ptr %slot.y, align 8
  %slot.Person = alloca i64, align 8
  store i64 0, ptr %slot.Person, align 8
  %slot.alice = alloca i64, align 8
  store i64 0, ptr %slot.alice, align 8
  %slot.name = alloca i64, align 8
  store i64 0, ptr %slot.name, align 8
  %slot.age = alloca i64, align 8
  store i64 0, ptr %slot.age, align 8
  %r0 = load i64, ptr %slot.Point, align 8
  store i64 %r0, ptr %slot.p, align 8
  %r1 = call i64 @nova_rt_dict_create()
  %r2 = load i64, ptr %slot.x, align 8
  %r3 = add i64 10, 0
  call i64 @nova_rt_dict_set(i64 %r1, i64 %r2, i64 %r3)
  %r4 = load i64, ptr %slot.y, align 8
  %r5 = add i64 20, 0
  call i64 @nova_rt_dict_set(i64 %r1, i64 %r4, i64 %r5)
  %r6 = load i64, ptr %slot.p, align 8
  %r7.ptr = inttoptr i64 %r6 to ptr
  %r7.gep = getelementptr i64, ptr %r7.ptr, i64 0
  %r7 = load i64, ptr %r7.gep, align 8
  %r8 = call i64 @nova_rt_print_any(i64 %r7)
  %r9 = load i64, ptr %slot.p, align 8
  %r10.ptr = inttoptr i64 %r9 to ptr
  %r10.gep = getelementptr i64, ptr %r10.ptr, i64 1
  %r10 = load i64, ptr %r10.gep, align 8
  %r11 = call i64 @nova_rt_print_any(i64 %r10)
  %r12 = load i64, ptr %slot.Person, align 8
  store i64 %r12, ptr %slot.alice, align 8
  %r13 = call i64 @nova_rt_dict_create()
  %r14 = load i64, ptr %slot.name, align 8
  %r15.p = getelementptr inbounds [6 x i8], ptr @.str.0, i64 0, i64 0
  %r15 = ptrtoint ptr %r15.p to i64
  call i64 @nova_rt_dict_set(i64 %r13, i64 %r14, i64 %r15)
  %r16 = load i64, ptr %slot.age, align 8
  %r17 = add i64 30, 0
  call i64 @nova_rt_dict_set(i64 %r13, i64 %r16, i64 %r17)
  %r18 = load i64, ptr %slot.alice, align 8
  %r19.ptr = inttoptr i64 %r18 to ptr
  %r19.gep = getelementptr i64, ptr %r19.ptr, i64 0
  %r19 = load i64, ptr %r19.gep, align 8
  %r20 = call i64 @nova_rt_print_any(i64 %r19)
  %r21 = load i64, ptr %slot.alice, align 8
  %r22.ptr = inttoptr i64 %r21 to ptr
  %r22.gep = getelementptr i64, ptr %r22.ptr, i64 1
  %r22 = load i64, ptr %r22.gep, align 8
  %r23 = call i64 @nova_rt_print_any(i64 %r22)
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
@.str.0 = private unnamed_addr constant [6 x i8] c"Alice\00"
