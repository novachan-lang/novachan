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
declare i64 @nova_rt_print_bool(i64) nounwind
declare i64 @nova_rt_float_bits(i64) nounwind
declare ptr @nova_rt_struct_alloc(i64) nounwind
declare i64 @nova_rt_slice(i64, i64, i64) nounwind
declare i64 @nova_rt_repeat(i64, i64) nounwind
declare i64 @nova_rt_chars(i64) nounwind
declare i64 @nova_rt_time_ms() nounwind
declare i64 @nova_rt_sleep_ms(i64) nounwind
declare i64 @nova_rt_clock_ns() nounwind
declare i64 @nova_rt_type_of(i64) nounwind
declare i64 @nova_rt_range(i64) nounwind
declare i64 @nova_rt_range_from_to(i64, i64) nounwind
declare i64 @nova_rt_dict_keys(i64) nounwind
declare i64 @nova_rt_dict_values(i64) nounwind
declare i64 @nova_rt_dict_items(i64) nounwind
declare i64 @nova_rt_dict_has(i64, i64) nounwind
declare i64 @nova_rt_dict_del(i64, i64) nounwind
declare i64 @nova_rt_system(i64) nounwind
declare i64 @nova_rt_exec(i64) nounwind
declare i64 @nova_rt_create_string(ptr) nounwind
declare void @nova_rt_init_args(i64, i64) nounwind
declare void @nova_rt_wait_all() nounwind
declare void @nova_rt_cleanup() nounwind
declare i64 @nova_rt_parse_float(i64) nounwind
declare i64 @nova_rt_read_line() nounwind
declare i64 @nova_rt_append_file(i64, i64) nounwind
declare i64 @nova_rt_file_exists(i64) nounwind
declare i64 @nova_rt_find(i64, i64) nounwind
declare i64 @nova_rt_list_concat(i64, i64) nounwind
declare i64 @nova_rt_list_reverse(i64) nounwind
declare i64 @nova_rt_list_sort(i64) nounwind
declare i64 @nova_rt_list_slice(i64, i64, i64) nounwind
declare i64 @nova_rt_http_get(i64) nounwind
declare i64 @nova_rt_http_post(i64, i64, i64) nounwind
declare i64 @nova_rt_mkdir(i64) nounwind
declare i64 @nova_rt_mkdir_p(i64) nounwind
declare i64 @nova_rt_path_join(i64, i64) nounwind
declare i64 @nova_rt_path_exists(i64) nounwind
declare i64 @nova_rt_path_parent(i64) nounwind
declare i64 @nova_rt_path_name(i64) nounwind
declare i64 @nova_rt_read_bytes(i64) nounwind
declare i64 @nova_rt_write_raw(i64) nounwind

define i64 @getDoubler() nounwind {
entry:
  %r0.ptr = call ptr @nova_rt_struct_alloc(i64 8)
  %r0.tgep = getelementptr i64, ptr %r0.ptr, i64 0
  %r0.tfn = ptrtoint ptr @__tramp_0 to i64
  store i64 %r0.tfn, ptr %r0.tgep, align 8
  %r0 = ptrtoint ptr %r0.ptr to i64
  ret i64 %r0
}

define i64 @getTripler() nounwind {
entry:
  %r0.ptr = call ptr @nova_rt_struct_alloc(i64 8)
  %r0.tgep = getelementptr i64, ptr %r0.ptr, i64 0
  %r0.tfn = ptrtoint ptr @__tramp_1 to i64
  store i64 %r0.tfn, ptr %r0.tgep, align 8
  %r0 = ptrtoint ptr %r0.ptr to i64
  ret i64 %r0
}

define i64 @__lambda_0(i64 %p0) nounwind {
entry:
  %slot.x = alloca i64, align 8
  store i64 %p0, ptr %slot.x, align 8
  %r0 = load i64, ptr %slot.x, align 8
  %r1 = add i64 2, 0
  %r2 = mul i64 %r0, %r1
  ret i64 %r2
}

define i64 @__lambda_1(i64 %p0) nounwind {
entry:
  %slot.x = alloca i64, align 8
  store i64 %p0, ptr %slot.x, align 8
  %r0 = load i64, ptr %slot.x, align 8
  %r1 = add i64 3, 0
  %r2 = mul i64 %r0, %r1
  ret i64 %r2
}

define i64 @nova_main() nounwind {
entry:
  %slot.d = alloca i64, align 8
  store i64 0, ptr %slot.d, align 8
  %slot.t = alloca i64, align 8
  store i64 0, ptr %slot.t, align 8
  %r0 = call i64 @getDoubler()
  store i64 %r0, ptr %slot.d, align 8
  %r1 = call i64 @getTripler()
  store i64 %r1, ptr %slot.t, align 8
  %r2 = add i64 5, 0
  %r4 = load i64, ptr %slot.d, align 8
  %r3.rec = inttoptr i64 %r4 to ptr
  %r3.fnraw = load i64, ptr %r3.rec, align 8
  %r3.fnptr = inttoptr i64 %r3.fnraw to ptr
  %r3 = call i64 %r3.fnptr(i64 %r4, i64 %r2)
  %r5 = call i64 @nova_rt_print_any(i64 %r3)
  %r6 = add i64 5, 0
  %r8 = load i64, ptr %slot.t, align 8
  %r7.rec = inttoptr i64 %r8 to ptr
  %r7.fnraw = load i64, ptr %r7.rec, align 8
  %r7.fnptr = inttoptr i64 %r7.fnraw to ptr
  %r7 = call i64 %r7.fnptr(i64 %r8, i64 %r6)
  %r9 = call i64 @nova_rt_print_any(i64 %r7)
  %r10 = add i64 4, 0
  %r12 = load i64, ptr %slot.t, align 8
  %r11.rec = inttoptr i64 %r12 to ptr
  %r11.fnraw = load i64, ptr %r11.rec, align 8
  %r11.fnptr = inttoptr i64 %r11.fnraw to ptr
  %r11 = call i64 %r11.fnptr(i64 %r12, i64 %r10)
  %r14 = load i64, ptr %slot.d, align 8
  %r13.rec = inttoptr i64 %r14 to ptr
  %r13.fnraw = load i64, ptr %r13.rec, align 8
  %r13.fnptr = inttoptr i64 %r13.fnraw to ptr
  %r13 = call i64 %r13.fnptr(i64 %r14, i64 %r11)
  %r15 = call i64 @nova_rt_print_any(i64 %r13)
  ret i64 0
}

define i64 @__tramp_0(i64 %record, i64 %p0) nounwind {
entry:
  %result = call i64 @__lambda_0(i64 %p0)
  ret i64 %result
}

define i64 @__tramp_1(i64 %record, i64 %p0) nounwind {
entry:
  %result = call i64 @__lambda_1(i64 %p0)
  ret i64 %result
}

define i32 @main(i32 %argc, ptr %argv) nounwind {
entry:
  %argc64 = sext i32 %argc to i64
  %argv64 = ptrtoint ptr %argv to i64
  call void @nova_rt_init_args(i64 %argc64, i64 %argv64)
  call i64 @nova_main()
  call void @nova_rt_wait_all()
  call void @nova_rt_cleanup()
  ret i32 0
}

; TBAA metadata
!0 = !{!"NOVA TBAA"}
!1 = !{!"list_data_ptr", !0}
!2 = !{!1, !1, i64 0}
!3 = !{!"list_elem", !0}
!4 = !{!3, !3, i64 0}
!5 = !{!"list_size", !0}
!6 = !{!5, !5, i64 0}
!90 = !{!"branch_weights", i32 2000, i32 1}
!91 = distinct !{!91, !92, !93}
!92 = !{!"llvm.loop.unroll.enable"}
!93 = !{!"llvm.loop.vectorize.enable", i1 true}
