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

define i64 @makeAdder(i64 %p0) nounwind {
entry:
  %slot.n = alloca i64, align 8
  store i64 %p0, ptr %slot.n, align 8
  %r0 = load i64, ptr %slot.n, align 8
  %r1.ptr = call ptr @nova_rt_struct_alloc(i64 16)
  %r1.tgep = getelementptr i64, ptr %r1.ptr, i64 0
  %r1.tfn = ptrtoint ptr @__tramp_0 to i64
  store i64 %r1.tfn, ptr %r1.tgep, align 8
  %r1.c0 = getelementptr i64, ptr %r1.ptr, i64 1
  store i64 %r0, ptr %r1.c0, align 8
  %r1 = ptrtoint ptr %r1.ptr to i64
  ret i64 %r1
}

define i64 @__lambda_0(i64 %p0, i64 %p1) nounwind {
entry:
  %slot.n = alloca i64, align 8
  store i64 %p0, ptr %slot.n, align 8
  %slot.x = alloca i64, align 8
  store i64 %p1, ptr %slot.x, align 8
  %r0 = load i64, ptr %slot.x, align 8
  %r1 = load i64, ptr %slot.n, align 8
  %r2 = call i64 @nova_rt_add(i64 %r0, i64 %r1)
  ret i64 %r2
}

define i64 @nova_main() nounwind {
entry:
  %slot.add5 = alloca i64, align 8
  store i64 0, ptr %slot.add5, align 8
  %slot.add10 = alloca i64, align 8
  store i64 0, ptr %slot.add10, align 8
  %r0 = add i64 5, 0
  %r1 = call i64 @makeAdder(i64 %r0)
  store i64 %r1, ptr %slot.add5, align 8
  %r2 = add i64 10, 0
  %r3 = call i64 @makeAdder(i64 %r2)
  store i64 %r3, ptr %slot.add10, align 8
  %r4 = add i64 3, 0
  %r6 = load i64, ptr %slot.add5, align 8
  %r5.rec = inttoptr i64 %r6 to ptr
  %r5.fnraw = load i64, ptr %r5.rec, align 8
  %r5.fnptr = inttoptr i64 %r5.fnraw to ptr
  %r5 = call i64 %r5.fnptr(i64 %r6, i64 %r4)
  %r7 = call i64 @nova_rt_print_any(i64 %r5)
  %r8 = add i64 3, 0
  %r10 = load i64, ptr %slot.add10, align 8
  %r9.rec = inttoptr i64 %r10 to ptr
  %r9.fnraw = load i64, ptr %r9.rec, align 8
  %r9.fnptr = inttoptr i64 %r9.fnraw to ptr
  %r9 = call i64 %r9.fnptr(i64 %r10, i64 %r8)
  %r11 = call i64 @nova_rt_print_any(i64 %r9)
  %r12 = add i64 1, 0
  %r14 = load i64, ptr %slot.add10, align 8
  %r13.rec = inttoptr i64 %r14 to ptr
  %r13.fnraw = load i64, ptr %r13.rec, align 8
  %r13.fnptr = inttoptr i64 %r13.fnraw to ptr
  %r13 = call i64 %r13.fnptr(i64 %r14, i64 %r12)
  %r16 = load i64, ptr %slot.add5, align 8
  %r15.rec = inttoptr i64 %r16 to ptr
  %r15.fnraw = load i64, ptr %r15.rec, align 8
  %r15.fnptr = inttoptr i64 %r15.fnraw to ptr
  %r15 = call i64 %r15.fnptr(i64 %r16, i64 %r13)
  %r17 = call i64 @nova_rt_print_any(i64 %r15)
  ret i64 0
}

define i64 @__tramp_0(i64 %record, i64 %p0) nounwind {
entry:
  %rec_ptr = inttoptr i64 %record to ptr
  %cap0_ptr = getelementptr i64, ptr %rec_ptr, i64 1
  %cap0 = load i64, ptr %cap0_ptr, align 8
  %result = call i64 @__lambda_0(i64 %cap0, i64 %p0)
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
