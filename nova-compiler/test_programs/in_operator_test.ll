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

define i64 @test_list_in() nounwind {
entry:
  %slot.nums = alloca i64, align 8
  store i64 0, ptr %slot.nums, align 8
  %r1 = add i64 10, 0
  %r2 = add i64 20, 0
  %r3 = add i64 30, 0
  %r4 = add i64 40, 0
  %r5 = add i64 50, 0
  %r0 = call i64 @nova_rt_list_create()
  call i64 @nova_rt_list_append(i64 %r0, i64 %r1)
  call i64 @nova_rt_list_append(i64 %r0, i64 %r2)
  call i64 @nova_rt_list_append(i64 %r0, i64 %r3)
  call i64 @nova_rt_list_append(i64 %r0, i64 %r4)
  call i64 @nova_rt_list_append(i64 %r0, i64 %r5)
  store i64 %r0, ptr %slot.nums, align 8
  %r6 = add i64 10, 0
  %r7 = load i64, ptr %slot.nums, align 8
  %r8 = call i64 @nova_rt_contains(i64 %r7, i64 %r6)
  %r9 = call i64 @nova_rt_print_any(i64 %r8)
  %r10 = add i64 25, 0
  %r11 = load i64, ptr %slot.nums, align 8
  %r12 = call i64 @nova_rt_contains(i64 %r11, i64 %r10)
  %r13 = call i64 @nova_rt_print_any(i64 %r12)
  %r14 = add i64 50, 0
  %r15 = load i64, ptr %slot.nums, align 8
  %r16 = call i64 @nova_rt_contains(i64 %r15, i64 %r14)
  %r17 = call i64 @nova_rt_print_any(i64 %r16)
  ret i64 %r17
}

define i64 @test_dict_in() nounwind {
entry:
  %slot.d = alloca i64, align 8
  store i64 0, ptr %slot.d, align 8
  %r0 = call i64 @nova_rt_dict_create()
  %r1.p = getelementptr inbounds [5 x i8], ptr @.str.0, i64 0, i64 0
  %r1 = ptrtoint ptr %r1.p to i64
  %r2.p = getelementptr inbounds [5 x i8], ptr @.str.1, i64 0, i64 0
  %r2 = ptrtoint ptr %r2.p to i64
  call i64 @nova_rt_dict_set(i64 %r0, i64 %r1, i64 %r2)
  %r3.p = getelementptr inbounds [8 x i8], ptr @.str.2, i64 0, i64 0
  %r3 = ptrtoint ptr %r3.p to i64
  %r4.p = getelementptr inbounds [4 x i8], ptr @.str.3, i64 0, i64 0
  %r4 = ptrtoint ptr %r4.p to i64
  call i64 @nova_rt_dict_set(i64 %r0, i64 %r3, i64 %r4)
  store i64 %r0, ptr %slot.d, align 8
  %r5.p = getelementptr inbounds [5 x i8], ptr @.str.0, i64 0, i64 0
  %r5 = ptrtoint ptr %r5.p to i64
  %r6 = load i64, ptr %slot.d, align 8
  %r7 = call i64 @nova_rt_contains(i64 %r6, i64 %r5)
  %r8 = call i64 @nova_rt_print_any(i64 %r7)
  %r9.p = getelementptr inbounds [4 x i8], ptr @.str.4, i64 0, i64 0
  %r9 = ptrtoint ptr %r9.p to i64
  %r10 = load i64, ptr %slot.d, align 8
  %r11 = call i64 @nova_rt_contains(i64 %r10, i64 %r9)
  %r12 = call i64 @nova_rt_print_any(i64 %r11)
  ret i64 %r12
}

define i64 @test_string_in() nounwind {
entry:
  %slot.s = alloca i64, align 8
  store i64 0, ptr %slot.s, align 8
  %r0.p = getelementptr inbounds [12 x i8], ptr @.str.5, i64 0, i64 0
  %r0 = ptrtoint ptr %r0.p to i64
  store i64 %r0, ptr %slot.s, align 8
  %r1.p = getelementptr inbounds [6 x i8], ptr @.str.6, i64 0, i64 0
  %r1 = ptrtoint ptr %r1.p to i64
  %r2 = load i64, ptr %slot.s, align 8
  %r3 = call i64 @nova_rt_contains(i64 %r2, i64 %r1)
  %r4 = call i64 @nova_rt_print_any(i64 %r3)
  %r5.p = getelementptr inbounds [4 x i8], ptr @.str.7, i64 0, i64 0
  %r5 = ptrtoint ptr %r5.p to i64
  %r6 = load i64, ptr %slot.s, align 8
  %r7 = call i64 @nova_rt_contains(i64 %r6, i64 %r5)
  %r8 = call i64 @nova_rt_print_any(i64 %r7)
  %r9.p = getelementptr inbounds [6 x i8], ptr @.str.8, i64 0, i64 0
  %r9 = ptrtoint ptr %r9.p to i64
  %r10 = load i64, ptr %slot.s, align 8
  %r11 = call i64 @nova_rt_contains(i64 %r10, i64 %r9)
  %r12 = call i64 @nova_rt_print_any(i64 %r11)
  ret i64 %r12
}

define i64 @test_in_conditions() nounwind {
entry:
  %slot.fruits = alloca i64, align 8
  store i64 0, ptr %slot.fruits, align 8
  %r1.p = getelementptr inbounds [6 x i8], ptr @.str.9, i64 0, i64 0
  %r1 = ptrtoint ptr %r1.p to i64
  %r2.p = getelementptr inbounds [7 x i8], ptr @.str.10, i64 0, i64 0
  %r2 = ptrtoint ptr %r2.p to i64
  %r3.p = getelementptr inbounds [7 x i8], ptr @.str.11, i64 0, i64 0
  %r3 = ptrtoint ptr %r3.p to i64
  %r0 = call i64 @nova_rt_list_create()
  call i64 @nova_rt_list_append(i64 %r0, i64 %r1)
  call i64 @nova_rt_list_append(i64 %r0, i64 %r2)
  call i64 @nova_rt_list_append(i64 %r0, i64 %r3)
  store i64 %r0, ptr %slot.fruits, align 8
  %r4.p = getelementptr inbounds [7 x i8], ptr @.str.10, i64 0, i64 0
  %r4 = ptrtoint ptr %r4.p to i64
  %r5 = load i64, ptr %slot.fruits, align 8
  %r6 = call i64 @nova_rt_contains(i64 %r5, i64 %r4)
  %br_then0 = icmp ne i64 %r6, 0
  br i1 %br_then0, label %then0, label %else1
then0:
  %r7.p = getelementptr inbounds [13 x i8], ptr @.str.12, i64 0, i64 0
  %r7 = ptrtoint ptr %r7.p to i64
  %r8 = call i64 @nova_rt_print_any(i64 %r7)
  br label %endif2
else1:
  br label %endif2
endif2:
  %r9.p = getelementptr inbounds [6 x i8], ptr @.str.13, i64 0, i64 0
  %r9 = ptrtoint ptr %r9.p to i64
  %r10 = load i64, ptr %slot.fruits, align 8
  %r11 = call i64 @nova_rt_contains(i64 %r10, i64 %r9)
  %br_retthen3 = icmp ne i64 %r11, 0
  br i1 %br_retthen3, label %retthen3, label %retelse4
retthen3:
  %r12.p = getelementptr inbounds [12 x i8], ptr @.str.14, i64 0, i64 0
  %r12 = ptrtoint ptr %r12.p to i64
  %r13 = call i64 @nova_rt_print_any(i64 %r12)
  ret i64 %r13
retelse4:
  %r14.p = getelementptr inbounds [9 x i8], ptr @.str.15, i64 0, i64 0
  %r14 = ptrtoint ptr %r14.p to i64
  %r15 = call i64 @nova_rt_print_any(i64 %r14)
  ret i64 %r15
}

define i64 @nova_main() nounwind {
entry:
  %r0 = call i64 @test_list_in()
  %r1.p = getelementptr inbounds [4 x i8], ptr @.str.16, i64 0, i64 0
  %r1 = ptrtoint ptr %r1.p to i64
  %r2 = call i64 @nova_rt_print_any(i64 %r1)
  %r3 = call i64 @test_dict_in()
  %r4.p = getelementptr inbounds [4 x i8], ptr @.str.16, i64 0, i64 0
  %r4 = ptrtoint ptr %r4.p to i64
  %r5 = call i64 @nova_rt_print_any(i64 %r4)
  %r6 = call i64 @test_string_in()
  %r7.p = getelementptr inbounds [4 x i8], ptr @.str.16, i64 0, i64 0
  %r7 = ptrtoint ptr %r7.p to i64
  %r8 = call i64 @nova_rt_print_any(i64 %r7)
  %r9 = call i64 @test_in_conditions()
  %r10.p = getelementptr inbounds [5 x i8], ptr @.str.17, i64 0, i64 0
  %r10 = ptrtoint ptr %r10.p to i64
  %r11 = call i64 @nova_rt_print_any(i64 %r10)
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
@.str.0 = private unnamed_addr constant [5 x i8] c"name\00"
@.str.1 = private unnamed_addr constant [5 x i8] c"nova\00"
@.str.2 = private unnamed_addr constant [8 x i8] c"version\00"
@.str.3 = private unnamed_addr constant [4 x i8] c"1.0\00"
@.str.4 = private unnamed_addr constant [4 x i8] c"age\00"
@.str.5 = private unnamed_addr constant [12 x i8] c"hello world\00"
@.str.6 = private unnamed_addr constant [6 x i8] c"hello\00"
@.str.7 = private unnamed_addr constant [4 x i8] c"xyz\00"
@.str.8 = private unnamed_addr constant [6 x i8] c"world\00"
@.str.9 = private unnamed_addr constant [6 x i8] c"apple\00"
@.str.10 = private unnamed_addr constant [7 x i8] c"banana\00"
@.str.11 = private unnamed_addr constant [7 x i8] c"cherry\00"
@.str.12 = private unnamed_addr constant [13 x i8] c"found banana\00"
@.str.13 = private unnamed_addr constant [6 x i8] c"grape\00"
@.str.14 = private unnamed_addr constant [12 x i8] c"found grape\00"
@.str.15 = private unnamed_addr constant [9 x i8] c"no grape\00"
@.str.16 = private unnamed_addr constant [4 x i8] c"---\00"
@.str.17 = private unnamed_addr constant [5 x i8] c"done\00"
