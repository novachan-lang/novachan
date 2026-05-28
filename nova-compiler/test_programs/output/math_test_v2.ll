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

define i64 @nova_main() nounwind {
entry:
  %slot.abs = alloca i64, align 8
  store i64 0, ptr %slot.abs, align 8
  %slot.max = alloca i64, align 8
  store i64 0, ptr %slot.max, align 8
  %slot.min = alloca i64, align 8
  store i64 0, ptr %slot.min, align 8
  %slot.sqrt = alloca i64, align 8
  store i64 0, ptr %slot.sqrt, align 8
  %slot.floor = alloca i64, align 8
  store i64 0, ptr %slot.floor, align 8
  %slot.ceil = alloca i64, align 8
  store i64 0, ptr %slot.ceil, align 8
  %slot.x = alloca i64, align 8
  store i64 0, ptr %slot.x, align 8
  %r0 = add i64 42, 0
  %r1 = sub i64 0, %r0
  %r3 = load i64, ptr %slot.abs, align 8
  %r2.rec = inttoptr i64 %r3 to ptr
  %r2.fnraw = load i64, ptr %r2.rec, align 8
  %r2.fnptr = inttoptr i64 %r2.fnraw to ptr
  %r2 = call i64 %r2.fnptr(i64 %r3, i64 %r1)
  %r4 = call i64 @nova_rt_print_any(i64 %r2)
  %r5 = add i64 10, 0
  %r7 = load i64, ptr %slot.abs, align 8
  %r6.rec = inttoptr i64 %r7 to ptr
  %r6.fnraw = load i64, ptr %r6.rec, align 8
  %r6.fnptr = inttoptr i64 %r6.fnraw to ptr
  %r6 = call i64 %r6.fnptr(i64 %r7, i64 %r5)
  %r8 = call i64 @nova_rt_print_any(i64 %r6)
  %r9 = add i64 3, 0
  %r10 = add i64 7, 0
  %r12 = load i64, ptr %slot.max, align 8
  %r11.rec = inttoptr i64 %r12 to ptr
  %r11.fnraw = load i64, ptr %r11.rec, align 8
  %r11.fnptr = inttoptr i64 %r11.fnraw to ptr
  %r11 = call i64 %r11.fnptr(i64 %r12, i64 %r9, i64 %r10)
  %r13 = call i64 @nova_rt_print_any(i64 %r11)
  %r14 = add i64 9, 0
  %r15 = add i64 2, 0
  %r17 = load i64, ptr %slot.max, align 8
  %r16.rec = inttoptr i64 %r17 to ptr
  %r16.fnraw = load i64, ptr %r16.rec, align 8
  %r16.fnptr = inttoptr i64 %r16.fnraw to ptr
  %r16 = call i64 %r16.fnptr(i64 %r17, i64 %r14, i64 %r15)
  %r18 = call i64 @nova_rt_print_any(i64 %r16)
  %r19 = add i64 3, 0
  %r20 = add i64 7, 0
  %r22 = load i64, ptr %slot.min, align 8
  %r21.rec = inttoptr i64 %r22 to ptr
  %r21.fnraw = load i64, ptr %r21.rec, align 8
  %r21.fnptr = inttoptr i64 %r21.fnraw to ptr
  %r21 = call i64 %r21.fnptr(i64 %r22, i64 %r19, i64 %r20)
  %r23 = call i64 @nova_rt_print_any(i64 %r21)
  %r24 = add i64 9, 0
  %r25 = add i64 2, 0
  %r27 = load i64, ptr %slot.min, align 8
  %r26.rec = inttoptr i64 %r27 to ptr
  %r26.fnraw = load i64, ptr %r26.rec, align 8
  %r26.fnptr = inttoptr i64 %r26.fnraw to ptr
  %r26 = call i64 %r26.fnptr(i64 %r27, i64 %r24, i64 %r25)
  %r28 = call i64 @nova_rt_print_any(i64 %r26)
  %r29 = add i64 0, 0
  %r30 = sub i64 0, %r29
  %r32 = load i64, ptr %slot.abs, align 8
  %r31.rec = inttoptr i64 %r32 to ptr
  %r31.fnraw = load i64, ptr %r31.rec, align 8
  %r31.fnptr = inttoptr i64 %r31.fnraw to ptr
  %r31 = call i64 %r31.fnptr(i64 %r32, i64 %r30)
  %r33 = call i64 @nova_rt_print_any(i64 %r31)
  %r34 = add i64 0, 0
  %r35 = add i64 0, 0
  %r37 = load i64, ptr %slot.max, align 8
  %r36.rec = inttoptr i64 %r37 to ptr
  %r36.fnraw = load i64, ptr %r36.rec, align 8
  %r36.fnptr = inttoptr i64 %r36.fnraw to ptr
  %r36 = call i64 %r36.fnptr(i64 %r37, i64 %r34, i64 %r35)
  %r38 = call i64 @nova_rt_print_any(i64 %r36)
  %r39 = add i64 0, 0
  %r40 = add i64 0, 0
  %r42 = load i64, ptr %slot.min, align 8
  %r41.rec = inttoptr i64 %r42 to ptr
  %r41.fnraw = load i64, ptr %r41.rec, align 8
  %r41.fnptr = inttoptr i64 %r41.fnraw to ptr
  %r41 = call i64 %r41.fnptr(i64 %r42, i64 %r39, i64 %r40)
  %r43 = call i64 @nova_rt_print_any(i64 %r41)
  %r44 = add i64 0, 0
  %r46 = load i64, ptr %slot.sqrt, align 8
  %r45.rec = inttoptr i64 %r46 to ptr
  %r45.fnraw = load i64, ptr %r45.rec, align 8
  %r45.fnptr = inttoptr i64 %r45.fnraw to ptr
  %r45 = call i64 %r45.fnptr(i64 %r46, i64 %r44)
  %r47 = call i64 @nova_rt_print_any(i64 %r45)
  %r48 = add i64 0, 0
  %r50 = load i64, ptr %slot.sqrt, align 8
  %r49.rec = inttoptr i64 %r50 to ptr
  %r49.fnraw = load i64, ptr %r49.rec, align 8
  %r49.fnptr = inttoptr i64 %r49.fnraw to ptr
  %r49 = call i64 %r49.fnptr(i64 %r50, i64 %r48)
  %r51 = call i64 @nova_rt_print_any(i64 %r49)
  %r52 = add i64 0, 0
  %r54 = load i64, ptr %slot.floor, align 8
  %r53.rec = inttoptr i64 %r54 to ptr
  %r53.fnraw = load i64, ptr %r53.rec, align 8
  %r53.fnptr = inttoptr i64 %r53.fnraw to ptr
  %r53 = call i64 %r53.fnptr(i64 %r54, i64 %r52)
  %r55 = call i64 @nova_rt_print_any(i64 %r53)
  %r56 = add i64 0, 0
  %r58 = load i64, ptr %slot.ceil, align 8
  %r57.rec = inttoptr i64 %r58 to ptr
  %r57.fnraw = load i64, ptr %r57.rec, align 8
  %r57.fnptr = inttoptr i64 %r57.fnraw to ptr
  %r57 = call i64 %r57.fnptr(i64 %r58, i64 %r56)
  %r59 = call i64 @nova_rt_print_any(i64 %r57)
  %r60 = add i64 10, 0
  %r61 = add i64 3, 0
  %r62 = srem i64 %r60, %r61
  %r63 = call i64 @nova_rt_print_any(i64 %r62)
  %r64 = add i64 17, 0
  %r65 = add i64 5, 0
  %r66 = srem i64 %r64, %r65
  %r67 = call i64 @nova_rt_print_any(i64 %r66)
  %r68 = add i64 7, 0
  %r69 = sub i64 0, %r68
  %r70 = add i64 3, 0
  %r71 = srem i64 %r69, %r70
  %r72 = call i64 @nova_rt_print_any(i64 %r71)
  %r73 = add i64 1, 0
  %r74.cmp = icmp eq i64 %r73, 0
  %r74 = zext i1 %r74.cmp to i64
  %r75 = call i64 @nova_rt_print_any(i64 %r74)
  %r76 = add i64 0, 0
  %r77.cmp = icmp eq i64 %r76, 0
  %r77 = zext i1 %r77.cmp to i64
  %r78 = call i64 @nova_rt_print_any(i64 %r77)
  %r79 = add i64 5, 0
  store i64 %r79, ptr %slot.x, align 8
  %r80 = load i64, ptr %slot.x, align 8
  %r81 = add i64 3, 0
  %r82.cmp = icmp eq i64 %r80, %r81
  %r82 = zext i1 %r82.cmp to i64
  %r83.cmp = icmp eq i64 %r82, 0
  %r83 = zext i1 %r83.cmp to i64
  %r84 = call i64 @nova_rt_print_any(i64 %r83)
  ret i64 0
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
