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

define i64 @make_player(i64 %p0, i64 %p1) nounwind {
entry:
  %slot.n = alloca i64, align 8
  store i64 %p0, ptr %slot.n, align 8
  %slot.hp = alloca i64, align 8
  store i64 %p1, ptr %slot.hp, align 8
  %slot.Player = alloca i64, align 8
  store i64 0, ptr %slot.Player, align 8
  %slot.name = alloca i64, align 8
  store i64 0, ptr %slot.name, align 8
  %slot.health = alloca i64, align 8
  store i64 0, ptr %slot.health, align 8
  %slot.pos = alloca i64, align 8
  store i64 0, ptr %slot.pos, align 8
  %r0 = load i64, ptr %slot.Player, align 8
  %r1 = call i64 @nova_rt_dict_create()
  %r2 = load i64, ptr %slot.name, align 8
  %r3 = load i64, ptr %slot.n, align 8
  call i64 @nova_rt_dict_set(i64 %r1, i64 %r2, i64 %r3)
  %r4 = load i64, ptr %slot.health, align 8
  %r5 = load i64, ptr %slot.hp, align 8
  call i64 @nova_rt_dict_set(i64 %r1, i64 %r4, i64 %r5)
  %r6 = load i64, ptr %slot.pos, align 8
  %r7 = add i64 0, 0
  call i64 @nova_rt_dict_set(i64 %r1, i64 %r6, i64 %r7)
  ret i64 %r1
}

define i64 @damage(i64 %p0, i64 %p1) nounwind {
entry:
  %slot.p = alloca i64, align 8
  store i64 %p0, ptr %slot.p, align 8
  %slot.amount = alloca i64, align 8
  store i64 %p1, ptr %slot.amount, align 8
  %slot.Player = alloca i64, align 8
  store i64 0, ptr %slot.Player, align 8
  %slot.name = alloca i64, align 8
  store i64 0, ptr %slot.name, align 8
  %slot.health = alloca i64, align 8
  store i64 0, ptr %slot.health, align 8
  %slot.pos = alloca i64, align 8
  store i64 0, ptr %slot.pos, align 8
  %r0 = load i64, ptr %slot.Player, align 8
  %r1 = call i64 @nova_rt_dict_create()
  %r2 = load i64, ptr %slot.name, align 8
  %r3 = load i64, ptr %slot.p, align 8
  %r4.ptr = inttoptr i64 %r3 to ptr
  %r4.gep = getelementptr i64, ptr %r4.ptr, i64 1
  %r4 = load i64, ptr %r4.gep, align 8
  call i64 @nova_rt_dict_set(i64 %r1, i64 %r2, i64 %r4)
  %r5 = load i64, ptr %slot.health, align 8
  %r6 = load i64, ptr %slot.p, align 8
  %r7.ptr = inttoptr i64 %r6 to ptr
  %r7.gep = getelementptr i64, ptr %r7.ptr, i64 2
  %r7 = load i64, ptr %r7.gep, align 8
  %r8 = load i64, ptr %slot.amount, align 8
  %r9 = sub i64 %r7, %r8
  call i64 @nova_rt_dict_set(i64 %r1, i64 %r5, i64 %r9)
  %r10 = load i64, ptr %slot.pos, align 8
  %r11 = load i64, ptr %slot.p, align 8
  %r12.ptr = inttoptr i64 %r11 to ptr
  %r12.gep = getelementptr i64, ptr %r12.ptr, i64 3
  %r12 = load i64, ptr %r12.gep, align 8
  call i64 @nova_rt_dict_set(i64 %r1, i64 %r10, i64 %r12)
  ret i64 %r1
}

define i64 @nova_main() nounwind {
entry:
  %slot.p1 = alloca i64, align 8
  store i64 0, ptr %slot.p1, align 8
  %slot.p2 = alloca i64, align 8
  store i64 0, ptr %slot.p2, align 8
  %slot.Vec2 = alloca i64, align 8
  store i64 0, ptr %slot.Vec2, align 8
  %slot.v = alloca i64, align 8
  store i64 0, ptr %slot.v, align 8
  %slot.x = alloca i64, align 8
  store i64 0, ptr %slot.x, align 8
  %slot.y = alloca i64, align 8
  store i64 0, ptr %slot.y, align 8
  %r0.p = getelementptr inbounds [5 x i8], ptr @.str.0, i64 0, i64 0
  %r0 = ptrtoint ptr %r0.p to i64
  %r1 = add i64 100, 0
  %r2 = call i64 @make_player(i64 %r0, i64 %r1)
  store i64 %r2, ptr %slot.p1, align 8
  %r3 = load i64, ptr %slot.p1, align 8
  %r4.ptr = inttoptr i64 %r3 to ptr
  %r4.gep = getelementptr i64, ptr %r4.ptr, i64 1
  %r4 = load i64, ptr %r4.gep, align 8
  %r5 = call i64 @nova_rt_print_any(i64 %r4)
  %r6 = load i64, ptr %slot.p1, align 8
  %r7.ptr = inttoptr i64 %r6 to ptr
  %r7.gep = getelementptr i64, ptr %r7.ptr, i64 2
  %r7 = load i64, ptr %r7.gep, align 8
  %r8 = call i64 @nova_rt_print_any(i64 %r7)
  %r9 = load i64, ptr %slot.p1, align 8
  %r10 = add i64 25, 0
  %r11 = call i64 @damage(i64 %r9, i64 %r10)
  store i64 %r11, ptr %slot.p2, align 8
  %r12 = load i64, ptr %slot.p2, align 8
  %r13.ptr = inttoptr i64 %r12 to ptr
  %r13.gep = getelementptr i64, ptr %r13.ptr, i64 1
  %r13 = load i64, ptr %r13.gep, align 8
  %r14 = call i64 @nova_rt_print_any(i64 %r13)
  %r15 = load i64, ptr %slot.p2, align 8
  %r16.ptr = inttoptr i64 %r15 to ptr
  %r16.gep = getelementptr i64, ptr %r16.ptr, i64 2
  %r16 = load i64, ptr %r16.gep, align 8
  %r17 = call i64 @nova_rt_print_any(i64 %r16)
  %r18 = load i64, ptr %slot.Vec2, align 8
  store i64 %r18, ptr %slot.v, align 8
  %r19 = call i64 @nova_rt_dict_create()
  %r20 = load i64, ptr %slot.x, align 8
  %r21 = add i64 0, 0
  call i64 @nova_rt_dict_set(i64 %r19, i64 %r20, i64 %r21)
  %r22 = load i64, ptr %slot.y, align 8
  %r23 = add i64 0, 0
  call i64 @nova_rt_dict_set(i64 %r19, i64 %r22, i64 %r23)
  %r24 = load i64, ptr %slot.v, align 8
  %r25.ptr = inttoptr i64 %r24 to ptr
  %r25.gep = getelementptr i64, ptr %r25.ptr, i64 1
  %r25 = load i64, ptr %r25.gep, align 8
  %r26 = call i64 @nova_rt_print_any(i64 %r25)
  %r27 = load i64, ptr %slot.v, align 8
  %r28.ptr = inttoptr i64 %r27 to ptr
  %r28.gep = getelementptr i64, ptr %r28.ptr, i64 2
  %r28 = load i64, ptr %r28.gep, align 8
  %r29 = call i64 @nova_rt_print_any(i64 %r28)
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

; String constants
@.str.0 = private unnamed_addr constant [5 x i8] c"Hero\00"

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
