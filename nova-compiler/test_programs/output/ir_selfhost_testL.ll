; NOVA IR-Pipeline Compiler Output
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
declare i64 @nova_rt_create_string(ptr) nounwind
declare void @nova_rt_init_args(i64, i64) nounwind
declare void @nova_rt_cleanup() nounwind

define i64 @count_chars(i64 %p0) nounwind {
entry:
  %slot.s = alloca i64, align 8
  store i64 %p0, ptr %slot.s, align 8
  %slot.counts = alloca i64, align 8
  store i64 0, ptr %slot.counts, align 8
  %slot.i = alloca i64, align 8
  store i64 0, ptr %slot.i, align 8
  %slot.ch = alloca i64, align 8
  store i64 0, ptr %slot.ch, align 8
  %r0 = call i64 @nova_rt_dict_create()
  store i64 %r0, ptr %slot.counts, align 8
  %r1 = add i64 0, 0
  store i64 %r1, ptr %slot.i, align 8
  br label %while_hdr0
while_hdr0:
  %r2 = load i64, ptr %slot.i, align 8
  %r3 = load i64, ptr %slot.s, align 8
  %r4 = call i64 @nova_rt_len_any(i64 %r3)
  %r5.cmp = icmp slt i64 %r2, %r4
  %r5 = zext i1 %r5.cmp to i64
  %br_while_body1 = icmp ne i64 %r5, 0
  br i1 %br_while_body1, label %while_body1, label %while_exit2
while_body1:
  %r6 = load i64, ptr %slot.s, align 8
  %r7 = load i64, ptr %slot.i, align 8
  %r8 = call i64 @nova_rt_index_get(i64 %r6, i64 %r7)
  store i64 %r8, ptr %slot.ch, align 8
  %r9 = load i64, ptr %slot.counts, align 8
  %r10 = load i64, ptr %slot.ch, align 8
  %r11 = call i64 @nova_rt_contains(i64 %r9, i64 %r10)
  %br_then3 = icmp ne i64 %r11, 0
  br i1 %br_then3, label %then3, label %else4
then3:
  %r12 = load i64, ptr %slot.counts, align 8
  %r13 = load i64, ptr %slot.ch, align 8
  %r14 = call i64 @nova_rt_index_get(i64 %r12, i64 %r13)
  %r15 = add i64 1, 0
  %r16 = call i64 @nova_rt_add(i64 %r14, i64 %r15)
  %r17 = load i64, ptr %slot.counts, align 8
  %r18 = load i64, ptr %slot.ch, align 8
  call i64 @nova_rt_index_set(i64 %r17, i64 %r18, i64 %r16)
  br label %endif5
else4:
  %r19 = add i64 1, 0
  %r20 = load i64, ptr %slot.counts, align 8
  %r21 = load i64, ptr %slot.ch, align 8
  call i64 @nova_rt_index_set(i64 %r20, i64 %r21, i64 %r19)
  br label %endif5
endif5:
  %r22 = load i64, ptr %slot.i, align 8
  %r23 = add i64 1, 0
  %r24 = call i64 @nova_rt_add(i64 %r22, i64 %r23)
  store i64 %r24, ptr %slot.i, align 8
  br label %while_hdr0
while_exit2:
  %r25 = load i64, ptr %slot.counts, align 8
  ret i64 %r25
}

define i64 @nova_main() nounwind {
entry:
  %slot.result = alloca i64, align 8
  store i64 0, ptr %slot.result, align 8
  %r0.p = getelementptr inbounds [12 x i8], ptr @.str.0, i64 0, i64 0
  %r0 = ptrtoint ptr %r0.p to i64
  %r1 = call i64 @count_chars(i64 %r0)
  store i64 %r1, ptr %slot.result, align 8
  %r2 = load i64, ptr %slot.result, align 8
  %r3.p = getelementptr inbounds [2 x i8], ptr @.str.1, i64 0, i64 0
  %r3 = ptrtoint ptr %r3.p to i64
  %r4 = call i64 @nova_rt_index_get(i64 %r2, i64 %r3)
  %r5 = call i64 @nova_rt_print_any(i64 %r4)
  %r6 = load i64, ptr %slot.result, align 8
  %r7.p = getelementptr inbounds [2 x i8], ptr @.str.2, i64 0, i64 0
  %r7 = ptrtoint ptr %r7.p to i64
  %r8 = call i64 @nova_rt_index_get(i64 %r6, i64 %r7)
  %r9 = call i64 @nova_rt_print_any(i64 %r8)
  %r10 = load i64, ptr %slot.result, align 8
  %r11.p = getelementptr inbounds [2 x i8], ptr @.str.3, i64 0, i64 0
  %r11 = ptrtoint ptr %r11.p to i64
  %r12 = call i64 @nova_rt_index_get(i64 %r10, i64 %r11)
  %r13 = call i64 @nova_rt_print_any(i64 %r12)
  %r14 = load i64, ptr %slot.result, align 8
  %r15 = call i64 @nova_rt_len_any(i64 %r14)
  %r16 = call i64 @nova_rt_print_any(i64 %r15)
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
@.str.0 = private unnamed_addr constant [12 x i8] c"hello world\00"
@.str.1 = private unnamed_addr constant [2 x i8] c"l\00"
@.str.2 = private unnamed_addr constant [2 x i8] c"o\00"
@.str.3 = private unnamed_addr constant [2 x i8] c"h\00"
