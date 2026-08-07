; NOVA IR-Pipeline Compiler Output
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

declare void @nova_rt_raise_error() nounwind
declare i64 @nova_rt_wrap_error_context(i64, i64, i64) nounwind
declare void @nova_rt_set_error_flag(i64) nounwind
declare i64 @nova_rt_take_error_flag() nounwind
declare i64 @nova_rt_take_error_msg() nounwind

; Runtime declarations
declare i32 @puts(ptr) nounwind
declare i32 @printf(ptr, ...) nounwind
declare i32 @strcmp(ptr, ptr) nounwind readonly
declare i64 @nova_rt_list_create() nounwind
declare i64 @nova_rt_deep_copy(i64) nounwind
declare i64 @nova_rt_list_create_filled(i64, i64) nounwind
declare i64 @nova_rt_list_append(i64, i64) nounwind
declare i64 @nova_rt_list_append_no_rc(i64, i64) nounwind
declare i64 @nova_rt_dict_set_no_rc(i64, i64, i64) nounwind
declare i64 @nova_rt_list_append_fbox(i64, i64) nounwind
declare i64 @nova_rt_list_append_fraw(i64, i64) nounwind
declare i64 @nova_rt_list_get_f(i64, i64) nounwind
declare i64 @nova_rt_list_append_bbox(i64, i64) nounwind
declare i64 @nova_rt_list_pop(i64) nounwind
declare i64 @nova_rt_list_insert(i64, i64, i64) nounwind
declare i64 @nova_rt_list_remove(i64, i64) nounwind
declare i64 @nova_rt_dict_get_default(i64, i64, i64) nounwind
declare i64 @nova_rt_box_bool(i64) nounwind
declare i64 @nova_rt_unbox(i64) nounwind
declare i64 @nova_rt_unbox_elem(i64) nounwind
declare i64 @nova_rt_lt(i64, i64) nounwind
declare i64 @nova_rt_le(i64, i64) nounwind
declare i64 @nova_rt_gt(i64, i64) nounwind
declare i64 @nova_rt_ge(i64, i64) nounwind
declare i64 @nova_rt_list_get(i64, i64) nounwind readonly
declare i64 @nova_rt_list_len(i64) nounwind readonly
declare i64 @nova_rt_dict_create() nounwind
declare i64 @nova_rt_dict_set(i64, i64, i64) nounwind
declare i64 @nova_rt_dict_set_fbox(i64, i64, i64) nounwind
declare i64 @nova_rt_dict_set_bbox(i64, i64, i64) nounwind
declare i64 @nova_rt_box_float(i64) nounwind
declare i64 @nova_rt_dict_get(i64, i64) nounwind readonly
declare i64 @nova_rt_str_concat(i64, i64) nounwind
declare i64 @nova_rt_int_to_str(i64) nounwind
declare i64 @nova_rt_bool_to_str(i64) nounwind
declare i64 @nova_rt_parse_int(i64) nounwind readonly
declare i64 @nova_rt_len(i64) nounwind readonly
declare i64 @nova_rt_len_any(i64) nounwind readonly
declare i64 @nova_rt_ord(i64) nounwind readonly
declare i64 @nova_rt_chr(i64) nounwind
declare i64 @nova_rt_is_space(i64) nounwind readonly
declare i64 @nova_rt_is_upper(i64) nounwind readonly
declare i64 @nova_rt_is_lower(i64) nounwind readonly
declare i64 @nova_rt_is_digit(i64) nounwind readonly
declare i64 @nova_rt_is_alpha(i64) nounwind readonly
declare i64 @nova_rt_is_alnum(i64) nounwind readonly
declare i64 @nova_rt_ushr(i64, i64) nounwind readnone
declare i64 @nova_rt_udiv(i64, i64) nounwind readnone
declare i64 @nova_rt_urem(i64, i64) nounwind readnone
declare i64 @nova_rt_ult(i64, i64) nounwind readnone
declare i64 @nova_rt_ugt(i64, i64) nounwind readnone
declare i64 @nova_rt_ule(i64, i64) nounwind readnone
declare i64 @nova_rt_uge(i64, i64) nounwind readnone
declare i64 @nova_rt_contains(i64, i64) nounwind readonly
declare i64 @nova_rt_index_get(i64, i64) nounwind readonly
declare i64 @nova_rt_index_set(i64, i64, i64) nounwind
declare i64 @nova_rt_add(i64, i64) nounwind
declare i64 @nova_rt_sub(i64, i64) nounwind
declare i64 @nova_rt_mul(i64, i64) nounwind
declare i64 @nova_rt_div(i64, i64) nounwind
declare i64 @nova_rt_mod(i64, i64) nounwind
declare i64 @nova_rt_neg(i64) nounwind
declare i64 @nova_rt_truthy(i64) nounwind readonly
declare i64 @nova_rt_eq(i64, i64) nounwind readonly
declare i64 @nova_rt_neq(i64, i64) nounwind readonly
declare i64 @nova_rt_any_to_str(i64) nounwind
declare void @nova_rt_assert(i64, i64) nounwind
declare i64 @nova_rt_read_file(i64) nounwind
declare i64 @nova_rt_write_file(i64, i64) nounwind
declare i64 @nova_rt_remove_file(i64) nounwind
declare i64 @nova_rt_remove_dir(i64) nounwind
declare i64 @nova_rt_rename_path(i64, i64) nounwind
declare i64 @nova_rt_chmod(i64, i64) nounwind
declare i64 @nova_rt_umask(i64) nounwind
declare i64 @nova_rt_symlink(i64, i64) nounwind
declare i64 @nova_rt_readlink(i64) nounwind
declare i64 @nova_rt_copy_file(i64, i64) nounwind
declare i64 @nova_rt_file_size(i64) nounwind
declare i64 @nova_rt_file_mtime(i64) nounwind
declare i64 @nova_rt_rc_drop_reassign(i64, i64) nounwind
declare i64 @nova_rt_rc_drop_temp(i64) nounwind
declare i64 @nova_rt_is_dir(i64) nounwind
declare i64 @nova_rt_make_dir(i64) nounwind
declare i64 @nova_rt_file_chmod(i64, i64) nounwind
declare i64 @nova_rt_is_file(i64) nounwind
declare i64 @nova_rt_write_bytes(i64, i64) nounwind
declare i64 @nova_rt_read_lines(i64) nounwind
declare i64 @nova_rt_file_open(i64, i64) nounwind
declare i64 @nova_rt_file_read_line(i64) nounwind
declare i64 @nova_rt_file_write(i64, i64) nounwind
declare i64 @nova_rt_file_eof(i64) nounwind
declare i64 @nova_rt_file_seek(i64, i64) nounwind
declare i64 @nova_rt_file_tell(i64) nounwind
declare i64 @nova_rt_file_flush(i64) nounwind
declare i64 @nova_rt_file_close(i64) nounwind
declare i64 @nova_rt_temp_dir() nounwind
declare i64 @nova_rt_args() nounwind
declare void @nova_rt_exit(i64) nounwind
declare i64 @nova_rt_split(i64, i64) nounwind
declare i64 @nova_rt_join(i64, i64) nounwind
declare i64 @nova_rt_splitlines(i64) nounwind
declare i64 @nova_rt_partition(i64, i64) nounwind
declare i64 @nova_rt_rpartition(i64, i64) nounwind
declare i64 @nova_rt_rsplit(i64, i64) nounwind
declare i64 @nova_rt_upper(i64) nounwind
declare i64 @nova_rt_lower(i64) nounwind
declare i64 @nova_rt_normalize_nfc(i64) nounwind
declare i64 @nova_rt_normalize_nfd(i64) nounwind
declare i64 @nova_rt_trim(i64) nounwind
declare i64 @nova_rt_trim_left(i64) nounwind
declare i64 @nova_rt_trim_right(i64) nounwind
declare i64 @nova_rt_str_capitalize(i64) nounwind
declare i64 @nova_rt_str_title(i64) nounwind
declare i64 @nova_rt_str_is_digit(i64) nounwind
declare i64 @nova_rt_str_is_alpha(i64) nounwind
declare i64 @nova_rt_str_is_alnum(i64) nounwind
declare i64 @nova_rt_str_is_space(i64) nounwind
declare i64 @nova_rt_str_is_upper(i64) nounwind
declare i64 @nova_rt_str_is_lower(i64) nounwind
declare i64 @nova_rt_replace(i64, i64, i64) nounwind
declare i64 @nova_rt_starts_with(i64, i64) nounwind readonly
declare i64 @nova_rt_ends_with(i64, i64) nounwind readonly
declare i64 @nova_rt_print_intlist(i64) nounwind
declare i64 @nova_rt_intlist_to_str(i64) nounwind
declare i64 @nova_rt_print_any(i64) nounwind
declare i64 @nova_rt_print_bool(i64) nounwind
declare i64 @nova_rt_print_float(i64) nounwind
declare i64 @nova_rt_print_int(i64) nounwind
declare i64 @nova_rt_print_str(i64) nounwind
declare i64 @nova_rt_float_bits(i64) nounwind
declare i64 @nova_rt_float_from_bits(i64) nounwind
declare i64 @nova_rt_float_to_bits(i64) nounwind
declare i64 @nova_rt_f32_from_bits(i64) nounwind
declare i64 @nova_rt_float_to_str(i64) nounwind
declare ptr @nova_rt_struct_alloc(i64) nounwind
declare ptr @nova_rt_hashed_struct_alloc(i64) nounwind
declare void @nova_rc_inc(i64) nounwind
declare i64 @nova_rt_field_set(i64, i64, i64, i64) nounwind
declare void @nova_rt_register_struct_bitmap(i64, i64) nounwind
declare void @nova_rt_register_struct_redact(i64, i64) nounwind
declare void @nova_rt_register_struct_drop(i64, i64) nounwind
declare double @llvm.sqrt.f64(double)
declare double @llvm.sin.f64(double)
declare double @llvm.cos.f64(double)
declare double @llvm.exp.f64(double)
declare double @llvm.log.f64(double)
declare double @llvm.log2.f64(double)
declare double @llvm.log10.f64(double)
declare double @llvm.fabs.f64(double)
declare double @llvm.floor.f64(double)
declare double @llvm.ceil.f64(double)
declare ptr @nova_rt_aligned_struct_alloc(i64, i64) nounwind
declare i64 @nova_rt_slice(i64, i64, i64) nounwind
declare i64 @nova_rt_slice_any(i64, i64, i64) nounwind
declare i64 @nova_rt_repeat(i64, i64) nounwind
declare i64 @nova_rt_list_filled(i64, i64) nounwind
declare i64 @nova_rt_chars(i64) nounwind
declare i64 @nova_rt_time_ms() nounwind
declare i64 @nova_rt_sleep_ms(i64) nounwind
declare i64 @nova_rt_clock_ns() nounwind
declare i64 @nova_rt_type_of(i64) nounwind
declare i64 @nova_rt_type_pred(i64, i64) nounwind
declare i64 @nova_rt_type_hash(i64) nounwind
declare i64 @nova_rt_range(i64) nounwind
declare i64 @nova_rt_range_from_to(i64, i64) nounwind
declare i64 @nova_rt_dict_keys(i64) nounwind readonly
declare i64 @nova_rt_dict_values(i64) nounwind readonly
declare i64 @nova_rt_dict_items(i64) nounwind readonly
declare i64 @nova_rt_for_iter_init(i64) nounwind
declare i64 @nova_rt_for_destr_init(i64) nounwind
declare i64 @nova_rt_for_kv_init(i64) nounwind
declare i64 @nova_rt_dict_has(i64, i64) nounwind readonly
declare i64 @nova_rt_memo_cache(i64) nounwind
declare i64 @nova_rt_memo_lock() nounwind
declare i64 @nova_rt_memo_unlock() nounwind
declare i64 @nova_rt_dict_del(i64, i64) nounwind
declare i64 @nova_rt_system(i64) nounwind
declare i64 @nova_rt_exec(i64) nounwind
declare i64 @nova_rt_proc_open(i64) nounwind
declare i64 @nova_rt_proc_write_stdin(i64, i64) nounwind
declare i64 @nova_rt_proc_read_stdout(i64) nounwind
declare i64 @nova_rt_proc_close_stdin(i64) nounwind
declare i64 @nova_rt_proc_wait(i64) nounwind
declare i64 @nova_rt_shell(i64) nounwind
declare void @nova_rt_register_struct_name(i64, i64) nounwind
declare void @nova_rt_register_struct_meta(i64, i64, i64) nounwind
declare void @nova_rt_register_struct_field(i64, i64, i64, i64) nounwind
declare i64 @nova_rt_field_names(i64) nounwind
declare i64 @nova_rt_field_types(i64) nounwind
declare i64 @nova_rt_field_get(i64, i64) nounwind
declare i64 @nova_rt_create_string(ptr) nounwind
declare void @nova_rt_init_args(i64, i64) nounwind
declare void @nova_rt_ensure_init() nounwind
declare void @nova_rt_wait_all() nounwind
declare void @nova_rt_main_dispatch(i64) nounwind
declare void @nova_rt_cleanup() nounwind
declare i64 @nova_rt_channel_create() nounwind
declare i64 @nova_rt_channel_bounded(i64) nounwind
declare i64 @nova_rt_channel_send(i64, i64) nounwind
declare i64 @nova_rt_channel_send_move(i64, i64) nounwind
declare i64 @nova_rt_channel_recv(i64) nounwind
declare i64 @nova_rt_channel_close(i64) nounwind
declare i64 @nova_rt_channel_select(i64, i64) nounwind
declare i64 @nova_rt_select(i64) nounwind
declare i64 @nova_rt_select_timeout(i64, i64) nounwind
declare i64 @nova_rt_channel_recv_timeout(i64, i64) nounwind
declare i64 @nova_rt_try_recv(i64) nounwind
declare i64 @nova_rt_try_send(i64, i64) nounwind
declare i64 @nova_rt_self() nounwind
declare i64 @nova_rt_mailbox_of(i64) nounwind
declare i64 @nova_rt_pid_send(i64, i64) nounwind
declare i64 @nova_rt_receive() nounwind
declare i64 @nova_rt_mailbox_len(i64) nounwind
declare i64 @nova_rt_try_receive() nounwind
declare i64 @nova_rt_recv_begin() nounwind
declare i64 @nova_rt_recv_next() nounwind
declare i64 @nova_rt_recv_commit() nounwind
declare i64 @nova_rt_recv_defer() nounwind
declare i64 @nova_rt_recv_begin_timed(i64) nounwind
declare i64 @nova_rt_recv_next_timed() nounwind
declare i64 @nova_rt_recv_timed_out() nounwind
declare i64 @nova_rt_list_remove_at(i64, i64) nounwind
declare i64 @nova_rt_spawn(i64, i64) nounwind
declare i64 @nova_rt_monitor(i64) nounwind
declare i64 @nova_rt_exit_reason(i64) nounwind
declare i64 @nova_rt_parse_float(i64) nounwind
declare i64 @nova_rt_read_line() nounwind
declare i64 @nova_rt_append_file(i64, i64) nounwind
declare i64 @nova_rt_file_exists(i64) nounwind
declare i64 @nova_rt_find(i64, i64) nounwind readonly
declare i64 @nova_rt_list_concat(i64, i64) nounwind
declare i64 @nova_rt_list_reverse(i64) nounwind
declare i64 @nova_rt_list_sort(i64) nounwind
declare i64 @nova_rt_list_slice(i64, i64, i64) nounwind
declare i64 @nova_rt_list_map(i64, i64) nounwind
declare i64 @nova_rt_list_map_fbox(i64, i64) nounwind
declare i64 @nova_rt_list_filter(i64, i64) nounwind
declare i64 @nova_rt_list_flatten(i64) nounwind
declare i64 @nova_rt_list_any(i64, i64) nounwind
declare i64 @nova_rt_list_all(i64, i64) nounwind
declare i64 @nova_rt_list_find(i64, i64) nounwind
declare i64 @nova_rt_list_count(i64, i64) nounwind
declare i64 @nova_rt_list_unique(i64) nounwind
declare i64 @nova_rt_list_group_by(i64, i64) nounwind
declare i64 @nova_rt_list_windows(i64, i64) nounwind
declare i64 @nova_rt_list_partition(i64, i64) nounwind
declare i64 @nova_rt_list_flat_map(i64, i64) nounwind
declare i64 @nova_rt_list_reduce(i64, i64, i64) nounwind
declare i64 @nova_rt_list_take(i64, i64) nounwind
declare i64 @nova_rt_list_drop(i64, i64) nounwind
declare i64 @nova_rt_list_chunk(i64, i64) nounwind
declare i64 @nova_rt_list_zip(i64, i64) nounwind
declare i64 @nova_rt_list_enumerate(i64) nounwind
declare i64 @nova_rt_dict_from_list(i64) nounwind
declare i64 @nova_rt_list_for_each(i64, i64) nounwind
declare i64 @nova_rt_list_map_indexed(i64, i64) nounwind
declare i64 @nova_rt_dict_update(i64, i64) nounwind
declare i64 @nova_rt_dict_filter(i64, i64) nounwind
declare i64 @nova_rt_dict_map_values(i64, i64) nounwind
declare i64 @nova_rt_str_zfill(i64, i64) nounwind
declare i64 @nova_rt_url_encode(i64) nounwind
declare i64 @nova_rt_url_decode(i64) nounwind
declare i64 @nova_rt_str_ljust(i64, i64) nounwind
declare i64 @nova_rt_str_rjust(i64, i64) nounwind
declare i64 @nova_rt_str_swapcase(i64) nounwind
declare i64 @nova_rt_str_word_count(i64) nounwind
declare i64 @nova_rt_str_words(i64) nounwind
declare i64 @nova_rt_list_clear(i64) nounwind
declare i64 @nova_rt_dict_clear(i64) nounwind
declare i64 @nova_rt_list_extend(i64, i64) nounwind
declare i64 @nova_rt_str_split_n(i64, i64, i64) nounwind
declare i64 @nova_rt_dict_invert(i64) nounwind
declare i64 @nova_rt_list_flatten_deep(i64) nounwind
declare i64 @nova_rt_str_truncate(i64, i64) nounwind
declare i64 @nova_rt_list_interpose(i64, i64) nounwind
declare i64 @nova_rt_list_compact(i64) nounwind
declare i64 @nova_rt_list_zip_with(i64, i64, i64) nounwind
declare i64 @nova_rt_list_scan(i64, i64, i64) nounwind
declare i64 @nova_rt_html_escape(i64) nounwind
declare i64 @nova_rt_html_unescape(i64) nounwind
declare i64 @nova_rt_list_min_by(i64, i64) nounwind
declare i64 @nova_rt_list_max_by(i64, i64) nounwind
declare i64 @nova_rt_list_sum_by(i64, i64) nounwind
declare i64 @nova_rt_math_sign(i64) nounwind
declare i64 @nova_rt_list_rotate(i64, i64) nounwind
declare i64 @nova_rt_list_frequency(i64) nounwind
declare i64 @nova_rt_str_is_numeric(i64) nounwind
declare i64 @nova_rt_list_reject(i64, i64) nounwind
declare i64 @nova_rt_dict_select_keys(i64, i64) nounwind
declare i64 @nova_rt_dict_reject_keys(i64, i64) nounwind
declare i64 @nova_rt_str_is_blank(i64) nounwind
declare i64 @nova_rt_str_remove_all(i64, i64) nounwind
declare i64 @nova_rt_str_count_lines(i64) nounwind
declare i64 @nova_rt_list_sorted_by(i64, i64) nounwind
declare i64 @nova_rt_list_transpose(i64) nounwind
declare i64 @nova_rt_dict_map_keys(i64, i64) nounwind
declare i64 @nova_rt_list_sum_float(i64) nounwind
declare i64 @nova_rt_list_average(i64) nounwind
declare i64 @nova_rt_list_each_cons(i64, i64) nounwind
declare i64 @nova_rt_list_to_dict(i64) nounwind
declare i64 @nova_rt_to_hex(i64) nounwind
declare i64 @nova_rt_from_hex(i64) nounwind
declare i64 @nova_rt_str_between(i64, i64, i64) nounwind
declare i64 @nova_rt_list_without(i64, i64) nounwind
declare i64 @nova_rt_list_product(i64) nounwind
declare i64 @nova_rt_clamp_float(i64, i64, i64) nounwind
declare i64 @nova_rt_lerp_float(i64, i64, i64) nounwind
declare i64 @nova_rt_list_shuffle(i64) nounwind
declare i64 @nova_rt_timestamp_ms() nounwind
declare i64 @nova_rt_str_hash(i64) nounwind
declare i64 @nova_rt_dict_count(i64, i64) nounwind
declare i64 @nova_rt_list_dedup(i64) nounwind
declare i64 @nova_rt_list_nth(i64, i64, i64) nounwind
declare i64 @nova_rt_list_zip_longest(i64, i64, i64) nounwind
declare i64 @nova_rt_list_take_while(i64, i64) nounwind
declare i64 @nova_rt_list_drop_while(i64, i64) nounwind
declare i64 @nova_rt_list_slice_from(i64, i64) nounwind
declare i64 @nova_rt_dict_zip(i64, i64) nounwind
declare i64 @nova_rt_str_escape(i64) nounwind
declare i64 @nova_rt_range_step(i64, i64, i64) nounwind
declare i64 @nova_rt_list_insert_at(i64, i64, i64) nounwind
declare i64 @nova_rt_dict_to_list(i64) nounwind
declare i64 @nova_rt_list_count_val(i64, i64) nounwind
declare i64 @nova_rt_list_replace_at(i64, i64, i64) nounwind
declare i64 @nova_rt_list_swap(i64, i64, i64) nounwind
declare i64 @nova_rt_to_float(i64) nounwind
declare i64 @nova_rt_result_and_then(i64, i64) nounwind
declare i64 @nova_rt_result_or_else(i64, i64) nounwind
declare i64 @nova_rt_str_contains_any(i64, i64) nounwind
declare i64 @nova_rt_str_to_slug(i64) nounwind
declare i64 @nova_rt_str_split_at(i64, i64) nounwind
declare i64 @nova_rt_str_starts_with_any(i64, i64) nounwind
declare i64 @nova_rt_str_ends_with_any(i64, i64) nounwind
declare i64 @nova_rt_str_remove_chars(i64, i64) nounwind
declare i64 @nova_rt_list_flatten_one(i64) nounwind
declare i64 @nova_rt_dict_reject(i64, i64) nounwind
declare i64 @nova_rt_list_each_index(i64, i64) nounwind
declare i64 @nova_rt_dict_to_pairs(i64) nounwind
declare i64 @nova_rt_str_replace_first(i64, i64, i64) nounwind
declare i64 @nova_rt_list_max_by_key(i64, i64) nounwind
declare i64 @nova_rt_list_min_by_key(i64, i64) nounwind
declare i64 @nova_rt_list_take_last(i64, i64) nounwind
declare i64 @nova_rt_list_drop_last(i64, i64) nounwind
declare i64 @nova_rt_str_repeat_char(i64, i64) nounwind
declare i64 @nova_rt_str_tab_to_spaces(i64, i64) nounwind
declare i64 @nova_rt_str_equals_ignore_case(i64, i64) nounwind
declare i64 @nova_rt_str_is_int(i64) nounwind
declare i64 @nova_rt_str_is_float(i64) nounwind
declare i64 @nova_rt_str_take(i64, i64) nounwind
declare i64 @nova_rt_str_drop(i64, i64) nounwind
declare i64 @nova_rt_dict_any(i64, i64) nounwind
declare i64 @nova_rt_dict_all(i64, i64) nounwind
declare i64 @nova_rt_list_init(i64) nounwind
declare i64 @nova_rt_dict_min_val(i64) nounwind
declare i64 @nova_rt_dict_max_val(i64) nounwind
declare i64 @nova_rt_list_sum_where(i64, i64) nounwind
declare i64 @nova_rt_str_before(i64, i64) nounwind
declare i64 @nova_rt_str_after(i64, i64) nounwind
declare i64 @nova_rt_list_rotate_left(i64, i64) nounwind
declare i64 @nova_rt_str_is_whitespace(i64) nounwind
declare i64 @nova_rt_list_index_of_val(i64, i64) nounwind
declare i64 @nova_rt_list_min_index(i64) nounwind
declare i64 @nova_rt_list_max_index(i64) nounwind
declare i64 @nova_rt_dict_from_lists(i64, i64) nounwind
declare i64 @nova_rt_dict_count_values(i64, i64) nounwind
declare i64 @nova_rt_list_last_index_of(i64, i64) nounwind
declare i64 @nova_rt_str_normalize_whitespace(i64) nounwind
declare i64 @nova_rt_dict_values_list(i64) nounwind
declare i64 @nova_rt_list_has_duplicates(i64) nounwind
declare i64 @nova_rt_str_reverse_words(i64) nounwind
declare i64 @nova_rt_str_char_count(i64, i64) nounwind
declare i64 @nova_rt_list_second(i64) nounwind
declare i64 @nova_rt_list_third(i64) nounwind
declare i64 @nova_rt_str_is_url(i64) nounwind
declare i64 @nova_rt_str_is_email(i64) nounwind
declare i64 @nova_rt_list_median(i64) nounwind
declare i64 @nova_rt_str_escape_html(i64) nounwind
declare i64 @nova_rt_str_unescape_html(i64) nounwind
declare i64 @nova_rt_dict_swap(i64, i64, i64) nounwind
declare i64 @nova_rt_list_cycle(i64, i64) nounwind
declare i64 @nova_rt_str_surround(i64, i64, i64) nounwind
declare i64 @nova_rt_list_pairwise(i64) nounwind
declare i64 @nova_rt_str_chop(i64, i64) nounwind
declare i64 @nova_rt_list_tally(i64) nounwind
declare i64 @nova_rt_str_excerpt(i64, i64) nounwind
declare i64 @nova_rt_list_span(i64, i64) nounwind
declare i64 @nova_rt_str_mask(i64, i64, i64) nounwind
declare i64 @nova_rt_list_frequencies(i64) nounwind
declare i64 @nova_rt_str_mul(i64, i64) nounwind
declare i64 @nova_rt_dict_keys_sorted(i64) nounwind
declare i64 @nova_rt_list_scan_left(i64, i64, i64) nounwind
declare i64 @nova_rt_str_wrap(i64, i64) nounwind
declare i64 @nova_rt_list_sliding_window(i64, i64) nounwind
declare i64 @nova_rt_dict_filter_keys(i64, i64) nounwind
declare i64 @nova_rt_str_encode_uri(i64) nounwind
declare i64 @nova_rt_str_decode_uri(i64) nounwind
declare i64 @nova_rt_list_intersperse(i64, i64) nounwind
declare i64 @nova_rt_str_to_char_codes(i64) nounwind
declare i64 @nova_rt_str_common_prefix(i64, i64) nounwind
declare i64 @nova_rt_str_common_suffix(i64, i64) nounwind
declare i64 @nova_rt_list_all_equal(i64) nounwind
declare i64 @nova_rt_str_to_int_or(i64, i64) nounwind
declare i64 @nova_rt_str_to_float_or(i64, i64) nounwind
declare i64 @nova_rt_list_zip_index(i64) nounwind
declare i64 @nova_rt_str_is_title(i64) nounwind
declare i64 @nova_rt_list_prepend(i64, i64) nounwind
declare i64 @nova_rt_list_find_last(i64, i64) nounwind
declare i64 @nova_rt_str_insert_at(i64, i64, i64) nounwind
declare i64 @nova_rt_list_avg(i64) nounwind
declare i64 @nova_rt_list_unzip(i64) nounwind
declare i64 @nova_rt_str_count_substr(i64, i64) nounwind
declare i64 @nova_rt_list_reduce_right(i64, i64, i64) nounwind
declare i64 @nova_rt_str_left(i64, i64) nounwind
declare i64 @nova_rt_str_right(i64, i64) nounwind
declare i64 @nova_rt_list_none(i64, i64) nounwind
declare i64 @nova_rt_list_count_if(i64, i64) nounwind
declare i64 @nova_rt_bytes_to_hex(i64) nounwind
declare i64 @nova_rt_hex_to_bytes(i64) nounwind
declare i64 @nova_rt_str_common_prefix_n(i64) nounwind
declare i64 @nova_rt_list_span_while(i64, i64) nounwind
declare i64 @nova_rt_str_pad_both(i64, i64, i64) nounwind
declare i64 @nova_rt_list_map_pairs(i64, i64) nounwind
declare i64 @nova_rt_dict_count_if(i64, i64) nounwind
declare i64 @nova_rt_str_similarity(i64, i64) nounwind
declare i64 @nova_rt_list_sample(i64, i64) nounwind
declare i64 @nova_rt_int_to_binary(i64) nounwind
declare i64 @nova_rt_int_to_octal(i64) nounwind
declare i64 @nova_rt_str_match_count(i64, i64) nounwind
declare i64 @nova_rt_list_count_by(i64, i64) nounwind
declare i64 @nova_rt_str_is_identifier(i64) nounwind
declare i64 @nova_rt_list_interleave_all(i64) nounwind
declare i64 @nova_rt_dict_invert_multi(i64) nounwind
declare i64 @nova_rt_list_product_int(i64) nounwind
declare i64 @nova_rt_list_flatten_depth(i64, i64) nounwind
declare i64 @nova_rt_list_repeat(i64, i64) nounwind
declare i64 @nova_rt_list_combinations(i64, i64) nounwind
declare i64 @nova_rt_list_permutations(i64) nounwind
declare i64 @nova_rt_str_count_words(i64) nounwind
declare i64 @nova_rt_list_group_runs(i64) nounwind
declare i64 @nova_rt_dict_for_each(i64, i64) nounwind
declare i64 @nova_rt_list_min_max(i64) nounwind
declare i64 @nova_rt_str_split_lines(i64) nounwind
declare i64 @nova_rt_str_join_with(i64, i64) nounwind
declare i64 @nova_rt_str_levenshtein(i64, i64) nounwind
declare i64 @nova_rt_str_char_frequency(i64) nounwind
declare i64 @nova_rt_list_is_sorted(i64) nounwind
declare i64 @nova_rt_list_cross_product(i64, i64) nounwind
declare i64 @nova_rt_list_running_sum(i64) nounwind
declare i64 @nova_rt_list_cumulative_max(i64) nounwind
declare i64 @nova_rt_list_sliding_pairs(i64) nounwind
declare i64 @nova_rt_dict_reduce(i64, i64, i64) nounwind
declare i64 @nova_rt_dict_map_entries(i64, i64) nounwind
declare i64 @nova_rt_dict_min_by(i64, i64) nounwind
declare i64 @nova_rt_dict_max_by(i64, i64) nounwind
declare i64 @nova_rt_dict_to_sorted_list(i64) nounwind
declare i64 @nova_rt_str_format_int(i64, i64) nounwind
declare i64 @nova_rt_list_enumerate_from(i64, i64) nounwind
declare i64 @nova_rt_list_chunk_by(i64, i64) nounwind
declare i64 @nova_rt_dict_group_by(i64, i64) nounwind
declare i64 @nova_rt_list_range(i64, i64, i64) nounwind
declare i64 @nova_rt_list_mode(i64) nounwind
declare i64 @nova_rt_dict_keys_where(i64, i64) nounwind
declare i64 @nova_rt_dict_values_where(i64, i64) nounwind
declare i64 @nova_rt_list_first_where(i64, i64) nounwind
declare i64 @nova_rt_list_last_where(i64, i64) nounwind
declare i64 @nova_rt_bytes_size(i64) nounwind
declare i64 @nova_rt_str_hex_encode(i64) nounwind
declare i64 @nova_rt_str_hex_decode(i64) nounwind
declare i64 @nova_rt_list_zip3(i64, i64, i64) nounwind
declare i64 @nova_rt_dict_merge_with(i64, i64, i64) nounwind
declare i64 @nova_rt_os_random(i64) nounwind
declare i64 @nova_rt_pbkdf2_sha256(i64, i64, i64, i64) nounwind
declare i64 @nova_rt_list_to_str(i64) nounwind
declare i64 @nova_rt_list_print(i64) nounwind
declare i64 @nova_rt_sched_slot_count() nounwind
declare i64 @nova_rt_math_gcd(i64, i64) nounwind
declare i64 @nova_rt_math_lcm(i64, i64) nounwind
declare i64 @nova_rt_math_factorial(i64) nounwind
declare i64 @nova_rt_math_is_prime(i64) nounwind
declare i64 @nova_rt_math_fibonacci(i64) nounwind
declare i64 @nova_rt_math_pow_int(i64, i64) nounwind
declare i64 @nova_rt_list_distinct(i64) nounwind
declare i64 @nova_rt_list_intersection(i64, i64) nounwind
declare i64 @nova_rt_list_union(i64, i64) nounwind
declare i64 @nova_rt_list_difference(i64, i64) nounwind
declare i64 @nova_rt_list_symmetric_difference(i64, i64) nounwind
declare i64 @nova_rt_list_is_subset(i64, i64) nounwind
declare i64 @nova_rt_list_is_superset(i64, i64) nounwind
declare i64 @nova_rt_list_copy(i64) nounwind
declare i64 @nova_rt_list_sort_by(i64, i64) nounwind
declare i64 @nova_rt_dict_copy(i64) nounwind
declare i64 @nova_rt_str_compare(i64, i64) nounwind
declare i64 @nova_rt_str_to_upper(i64) nounwind
declare i64 @nova_rt_str_to_lower(i64) nounwind
declare i64 @nova_rt_str_byte_length(i64) nounwind
declare i64 @nova_rt_str_byte_len(i64) nounwind
declare i64 @nova_rt_str_byte_at(i64, i64) nounwind
declare i64 @nova_rt_str_chars_list(i64) nounwind
declare i64 @nova_rt_str_remove_char(i64, i64) nounwind
declare i64 @nova_rt_list_cumsum(i64) nounwind
declare i64 @nova_rt_list_reverse_copy(i64) nounwind
declare i64 @nova_rt_list_repeat_val(i64, i64) nounwind
declare i64 @nova_rt_list_of_range(i64, i64) nounwind
declare i64 @nova_rt_list_adjacent_pairs(i64) nounwind
declare i64 @nova_rt_dict_sorted_by_value(i64) nounwind
declare i64 @nova_rt_math_abs_float(i64) nounwind
declare i64 @nova_rt_list_product_float(i64) nounwind
declare i64 @nova_rt_dict_keys_count(i64) nounwind
declare i64 @nova_rt_str_is_printable(i64) nounwind
declare i64 @nova_rt_list_to_string(i64, i64) nounwind
declare i64 @nova_rt_str_char_code(i64) nounwind
declare i64 @nova_rt_list_flatten_n(i64, i64) nounwind
declare i64 @nova_rt_str_from_char_code(i64) nounwind
declare i64 @nova_rt_str_replace_n(i64, i64, i64, i64) nounwind
declare i64 @nova_rt_str_index_of_last(i64, i64) nounwind
declare i64 @nova_rt_list_split_at(i64, i64) nounwind
declare i64 @nova_rt_math_round_to(i64, i64) nounwind
declare i64 @nova_rt_str_remove_prefix_all(i64, i64) nounwind
declare i64 @nova_rt_list_group_consecutive(i64) nounwind
declare i64 @nova_rt_dict_min_by_value(i64) nounwind
declare i64 @nova_rt_dict_max_by_value(i64) nounwind
declare i64 @nova_rt_str_pad_left_char(i64, i64, i64) nounwind
declare i64 @nova_rt_str_pad_right_char(i64, i64, i64) nounwind
declare i64 @nova_rt_math_fib(i64) nounwind
declare i64 @nova_rt_list_index_of_max(i64) nounwind
declare i64 @nova_rt_list_index_of_min(i64) nounwind
declare i64 @nova_rt_list_is_sorted_desc(i64) nounwind
declare i64 @nova_rt_dict_key_of_value(i64, i64) nounwind
declare i64 @nova_rt_list_every_nth(i64, i64) nounwind
declare i64 @nova_rt_dict_values_sorted(i64) nounwind
declare i64 @nova_rt_list_running_max(i64) nounwind
declare i64 @nova_rt_list_running_min(i64) nounwind
declare i64 @nova_rt_str_repeat_n(i64, i64) nounwind
declare i64 @nova_rt_list_pairs_to_dict(i64) nounwind
declare i64 @nova_rt_list_uncons(i64) nounwind
declare i64 @nova_rt_list_tails(i64) nounwind
declare i64 @nova_rt_str_split_chars(i64, i64) nounwind
declare i64 @nova_rt_list_prefixes(i64) nounwind
declare i64 @nova_rt_list_suffixes(i64) nounwind
declare i64 @nova_rt_list_zip_pairs(i64, i64) nounwind
declare i64 @nova_rt_list_without_index(i64, i64) nounwind
declare i64 @nova_rt_str_remove_whitespace(i64) nounwind
declare i64 @nova_rt_list_count_eq(i64, i64) nounwind
declare i64 @nova_rt_list_windowed(i64, i64) nounwind
declare i64 @nova_rt_str_center_with(i64, i64, i64) nounwind
declare i64 @nova_rt_dict_keys_list(i64) nounwind
declare i64 @nova_rt_str_extract_between(i64, i64, i64) nounwind
declare i64 @nova_rt_list_to_set_list(i64) nounwind
declare i64 @nova_rt_dict_values_count(i64) nounwind
declare i64 @nova_rt_str_remove_suffix_all(i64, i64) nounwind
declare i64 @nova_rt_list_zip_with_index(i64) nounwind
declare i64 @nova_rt_list_flatten_all(i64) nounwind
declare i64 @nova_rt_str_capitalize_words(i64) nounwind
declare i64 @nova_rt_list_partition_at(i64, i64) nounwind
declare i64 @nova_rt_str_word_at(i64, i64) nounwind
declare i64 @nova_rt_str_remove_all_chars(i64, i64) nounwind
declare i64 @nova_rt_dict_has_value(i64, i64) nounwind
declare i64 @nova_rt_list_pairs(i64) nounwind
declare i64 @nova_rt_list_group_by_size(i64, i64) nounwind
declare i64 @nova_rt_list_windows_with_step(i64, i64, i64) nounwind
declare i64 @nova_rt_dict_merge_all(i64) nounwind
declare i64 @nova_rt_list_rotate_n(i64, i64) nounwind
declare i64 @nova_rt_str_pad_center(i64, i64, i64) nounwind
declare i64 @nova_rt_str_trim_chars(i64, i64) nounwind
declare i64 @nova_rt_list_unique_count(i64) nounwind
declare i64 @nova_rt_list_head(i64, i64) nounwind
declare i64 @nova_rt_list_tail_n(i64, i64) nounwind
declare i64 @nova_rt_list_max_consecutive(i64) nounwind
declare i64 @nova_rt_str_remove_consecutive(i64) nounwind
declare i64 @nova_rt_str_overlay(i64, i64, i64) nounwind
declare i64 @nova_rt_str_reverse_chars(i64) nounwind
declare i64 @nova_rt_list_take_right(i64, i64) nounwind
declare i64 @nova_rt_list_drop_right(i64, i64) nounwind
declare i64 @nova_rt_dict_keys_sorted_desc(i64) nounwind
declare i64 @nova_rt_str_is_balanced(i64) nounwind
declare i64 @nova_rt_list_argmin(i64) nounwind
declare i64 @nova_rt_list_argmax(i64) nounwind
declare i64 @nova_rt_list_diff(i64, i64) nounwind
declare i64 @nova_rt_str_lines_count(i64) nounwind
declare i64 @nova_rt_str_between_last(i64, i64, i64) nounwind
declare i64 @nova_rt_list_cartesian(i64, i64) nounwind
declare i64 @nova_rt_str_count_occurrences(i64, i64) nounwind
declare i64 @nova_rt_list_cumulative_min(i64) nounwind
declare i64 @nova_rt_dict_filter_values(i64, i64) nounwind
declare i64 @nova_rt_list_flatten_once(i64) nounwind
declare i64 @nova_rt_list_range_step(i64, i64, i64) nounwind
declare i64 @nova_rt_str_truncate_ellipsis(i64, i64) nounwind
declare i64 @nova_rt_dict_update_value(i64, i64, i64) nounwind
declare i64 @nova_rt_str_replace_chars(i64, i64, i64) nounwind
declare i64 @nova_rt_list_nth_or(i64, i64, i64) nounwind
declare i64 @nova_rt_list_sliding_max(i64, i64) nounwind
declare i64 @nova_rt_list_sliding_min(i64, i64) nounwind
declare i64 @nova_rt_list_group_equal(i64) nounwind
declare i64 @nova_rt_list_alternate(i64, i64) nounwind
declare i64 @nova_rt_str_is_vowel(i64) nounwind
declare i64 @nova_rt_list_majority_element(i64) nounwind
declare i64 @nova_rt_dict_filter_by_key_prefix(i64, i64) nounwind
declare i64 @nova_rt_list_count_distinct(i64) nounwind
declare i64 @nova_rt_str_split_every(i64, i64) nounwind
declare i64 @nova_rt_str_hamming_distance(i64, i64) nounwind
declare i64 @nova_rt_list_dot_product(i64, i64) nounwind
declare i64 @nova_rt_dict_symmetric_diff(i64, i64) nounwind
declare i64 @nova_rt_str_is_consonant(i64) nounwind
declare i64 @nova_rt_list_mismatch(i64, i64) nounwind
declare i64 @nova_rt_str_remove_digits(i64) nounwind
declare i64 @nova_rt_dict_values_sum(i64) nounwind
declare i64 @nova_rt_list_weighted_sum(i64, i64) nounwind
declare i64 @nova_rt_list_mean(i64) nounwind
declare i64 @nova_rt_str_remove_letters(i64) nounwind
declare i64 @nova_rt_list_accumulate(i64) nounwind
declare i64 @nova_rt_str_is_sentence(i64) nounwind
declare i64 @nova_rt_dict_values_max(i64) nounwind
declare i64 @nova_rt_list_span_indices(i64, i64) nounwind
declare i64 @nova_rt_str_squeeze_char(i64, i64) nounwind
declare i64 @nova_rt_list_min_by_abs(i64) nounwind
declare i64 @nova_rt_dict_invert_unique(i64) nounwind
declare i64 @nova_rt_list_scan_product(i64) nounwind
declare i64 @nova_rt_dict_keys_matching(i64, i64) nounwind
declare i64 @nova_rt_str_mask_middle(i64, i64) nounwind
declare i64 @nova_rt_list_chunk_by_sum(i64, i64) nounwind
declare i64 @nova_rt_str_camel_to_snake(i64) nounwind
declare i64 @nova_rt_list_uniq_adjacent(i64) nounwind
declare i64 @nova_rt_str_snake_to_camel(i64) nounwind
declare i64 @nova_rt_dict_values_min(i64) nounwind
declare i64 @nova_rt_str_is_title_case(i64) nounwind
declare i64 @nova_rt_str_repeat_each(i64, i64) nounwind
declare i64 @nova_rt_list_skip_while(i64, i64) nounwind
declare i64 @nova_rt_str_wrap_at(i64, i64) nounwind
declare i64 @nova_rt_list_take_every(i64, i64) nounwind
declare i64 @nova_rt_str_rot13(i64) nounwind
declare i64 @nova_rt_str_atoi(i64) nounwind
declare i64 @nova_rt_str_caesar_cipher(i64, i64) nounwind
declare i64 @nova_rt_list_pairwise_diff(i64) nounwind
declare i64 @nova_rt_str_slug(i64) nounwind
declare i64 @nova_rt_dict_group_by_value_len(i64) nounwind
declare i64 @nova_rt_str_is_anagram(i64, i64) nounwind
declare i64 @nova_rt_dict_remove_keys(i64, i64) nounwind
declare i64 @nova_rt_list_sample_indices(i64, i64) nounwind
declare i64 @nova_rt_list_prefix_match(i64, i64) nounwind
declare i64 @nova_rt_dict_zip_lists(i64, i64) nounwind
declare i64 @nova_rt_str_to_char_list(i64) nounwind
declare i64 @nova_rt_list_cycle_n(i64, i64) nounwind
declare i64 @nova_rt_dict_values_sorted_asc(i64) nounwind
declare i64 @nova_rt_list_dedup_stable(i64) nounwind
declare i64 @nova_rt_list_indices_where_gt(i64, i64) nounwind
declare i64 @nova_rt_str_is_pangram(i64) nounwind
declare i64 @nova_rt_str_count_upper(i64) nounwind
declare i64 @nova_rt_str_count_lower(i64) nounwind
declare i64 @nova_rt_dict_keys_with_value(i64, i64) nounwind
declare i64 @nova_rt_str_encode_hex(i64) nounwind
declare i64 @nova_rt_dict_rename_key(i64, i64, i64) nounwind
declare i64 @nova_rt_list_swap_at(i64, i64, i64) nounwind
declare i64 @nova_rt_str_decode_hex(i64) nounwind
declare i64 @nova_rt_list_split_when(i64, i64) nounwind
declare i64 @nova_rt_dict_values_to_strings(i64) nounwind
declare i64 @nova_rt_str_is_ipv4(i64) nounwind
declare i64 @nova_rt_list_nth_last(i64, i64) nounwind
declare i64 @nova_rt_str_pad_right_with(i64, i64, i64) nounwind
declare i64 @nova_rt_str_is_numeric_strict(i64) nounwind
declare i64 @nova_rt_list_chunk_pairs(i64) nounwind
declare i64 @nova_rt_str_remove_prefix_if(i64, i64) nounwind
declare i64 @nova_rt_list_count_where_gt(i64, i64) nounwind
declare i64 @nova_rt_str_remove_vowels(i64) nounwind
declare i64 @nova_rt_str_title_to_slug(i64) nounwind
declare i64 @nova_rt_list_windows_sum(i64, i64) nounwind
declare i64 @nova_rt_dict_values_unique(i64) nounwind
declare i64 @nova_rt_dict_has_all_keys(i64, i64) nounwind
declare i64 @nova_rt_list_is_palindrome(i64) nounwind
declare i64 @nova_rt_str_to_words(i64) nounwind
declare i64 @nova_rt_list_replace_all(i64, i64, i64) nounwind
declare i64 @nova_rt_dict_merge_left(i64, i64) nounwind
declare i64 @nova_rt_str_lstrip(i64) nounwind
declare i64 @nova_rt_list_sum_pairs(i64) nounwind
declare i64 @nova_rt_dict_flip_kv(i64) nounwind
declare i64 @nova_rt_list_range_inclusive(i64, i64) nounwind
declare i64 @nova_rt_str_rstrip(i64) nounwind
declare i64 @nova_rt_list_sum_by_sign(i64) nounwind
declare i64 @nova_rt_str_first_word(i64) nounwind
declare i64 @nova_rt_str_last_word(i64) nounwind
declare i64 @nova_rt_list_find_all_indices(i64, i64) nounwind
declare i64 @nova_rt_list_count_where_lt(i64, i64) nounwind
declare i64 @nova_rt_str_is_palindrome_ignore_case(i64) nounwind
declare i64 @nova_rt_dict_keys_longest(i64) nounwind
declare i64 @nova_rt_list_remove_at_index(i64, i64) nounwind
declare i64 @nova_rt_str_delete_at(i64, i64) nounwind
declare i64 @nova_rt_list_insert_at_index(i64, i64, i64) nounwind
declare i64 @nova_rt_list_zip_with_default(i64, i64, i64, i64) nounwind
declare i64 @nova_rt_dict_entries_sorted(i64) nounwind
declare i64 @nova_rt_str_center_pad_with(i64, i64, i64) nounwind
declare i64 @nova_rt_list_max_by_abs(i64) nounwind
declare i64 @nova_rt_str_is_alpha_only(i64) nounwind
declare i64 @nova_rt_dict_values_avg(i64) nounwind
declare i64 @nova_rt_list_to_string_join(i64, i64) nounwind
declare i64 @nova_rt_list_max_n(i64, i64) nounwind
declare i64 @nova_rt_list_min_n(i64, i64) nounwind
declare i64 @nova_rt_str_is_lower_only(i64) nounwind
declare i64 @nova_rt_list_consecutive_pairs(i64) nounwind
declare i64 @nova_rt_dict_size_of(i64) nounwind
declare i64 @nova_rt_str_to_upper_first(i64) nounwind
declare i64 @nova_rt_list_flatten_map(i64) nounwind
declare i64 @nova_rt_list_every_pair(i64) nounwind
declare i64 @nova_rt_dict_to_query_string(i64) nounwind
declare i64 @nova_rt_str_remove_suffix_if(i64, i64) nounwind
declare i64 @nova_rt_list_group_by_mod(i64, i64) nounwind
declare i64 @nova_rt_dict_keys_shortest(i64) nounwind
declare i64 @nova_rt_str_is_upper_only(i64) nounwind
declare i64 @nova_rt_list_running_avg(i64) nounwind
declare i64 @nova_rt_dict_values_flat(i64) nounwind
declare i64 @nova_rt_str_byte_count(i64) nounwind
declare i64 @nova_rt_list_zip_map(i64, i64) nounwind
declare i64 @nova_rt_list_second_max(i64) nounwind
declare i64 @nova_rt_list_second_min(i64) nounwind
declare i64 @nova_rt_str_count_vowels(i64) nounwind
declare i64 @nova_rt_str_count_consonants(i64) nounwind
declare i64 @nova_rt_dict_min_key(i64) nounwind
declare i64 @nova_rt_dict_max_key(i64) nounwind
declare i64 @nova_rt_str_swap_case(i64) nounwind
declare i64 @nova_rt_list_partition_even_odd(i64) nounwind
declare i64 @nova_rt_str_codepoint_at(i64, i64) nounwind
declare i64 @nova_rt_bytes_equal(i64, i64) nounwind
declare i64 @nova_rt_bytes_from_list(i64) nounwind
declare i64 @nova_rt_bytes_to_list(i64) nounwind
declare i64 @nova_rt_list_index_where(i64, i64) nounwind
declare i64 @nova_rt_list_last(i64) nounwind
declare i64 @nova_rt_list_first(i64) nounwind
declare i64 @nova_rt_list_contains(i64, i64) nounwind
declare i64 @nova_rt_dict_get_or(i64, i64, i64) nounwind
declare i64 @nova_rt_dict_has_key(i64, i64) nounwind
declare i64 @nova_rt_math_clamp(i64, i64, i64) nounwind
declare i64 @nova_rt_math_lerp(i64, i64, i64) nounwind
declare i64 @nova_rt_http_get(i64) nounwind
declare i64 @nova_rt_http_post(i64, i64, i64) nounwind
declare i64 @nova_rt_mkdir(i64) nounwind
declare i64 @nova_rt_mkdir_p(i64) nounwind
declare i64 @nova_rt_path_join(i64, i64) nounwind
declare i64 @nova_rt_path_exists(i64) nounwind readonly
declare i64 @nova_rt_path_parent(i64) nounwind readonly
declare i64 @nova_rt_path_name(i64) nounwind readonly
declare i64 @nova_rt_read_bytes(i64) nounwind
declare i64 @nova_rt_file_read_bytes(i64, i64) nounwind
declare i64 @nova_rt_gpu_available() nounwind
declare i64 @nova_rt_gpu_vadd_floats(i64, i64) nounwind
declare i64 @nova_rt_prof_enter(i64) nounwind
declare i64 @nova_rt_prof_exit(i64) nounwind
declare void @nova_rt_prof_dump() nounwind
declare i64 @nova_rt_cov_hit(i64, i64) nounwind
declare i64 @nova_rt_cov_register(i64, i64) nounwind
declare void @nova_rt_cov_dump() nounwind
declare i64 @nova_rt_write_raw(i64) nounwind
declare i64 @nova_rt_abs(i64) nounwind readnone
declare i64 @nova_rt_max(i64, i64) nounwind readnone
declare i64 @nova_rt_min(i64, i64) nounwind readnone
declare i64 @nova_rt_sqrt(i64) nounwind readnone
declare i64 @nova_rt_sinh(i64) nounwind
declare i64 @nova_rt_cosh(i64) nounwind
declare i64 @nova_rt_tanh(i64) nounwind
declare i64 @nova_rt_cbrt(i64) nounwind
declare i64 @nova_rt_hypot(i64, i64) nounwind
declare i64 @nova_rt_isnan(i64) nounwind readnone
declare i64 @nova_rt_isinf(i64) nounwind readnone
declare i64 @nova_rt_clamp(i64, i64, i64) nounwind readnone
declare i64 @nova_rt_copysign(i64, i64) nounwind readnone
declare i64 @nova_rt_fma(i64, i64, i64) nounwind readnone
declare i64 @nova_rt_nextafter(i64, i64) nounwind readnone
declare i64 @nova_rt_lgamma(i64) nounwind readnone
declare i64 @nova_rt_erf(i64) nounwind readnone
declare i64 @nova_rt_rng_new(i64) nounwind
declare i64 @nova_rt_rng_next(i64) nounwind
declare i64 @nova_rt_rng_int(i64, i64) nounwind
declare i64 @nova_rt_rng_float(i64) nounwind
declare i64 @nova_rt_gcd(i64, i64) nounwind
declare i64 @nova_rt_lcm(i64, i64) nounwind
declare i64 @nova_rt_popcount(i64) nounwind
declare i64 @nova_rt_clz(i64) nounwind
declare i64 @nova_rt_ctz(i64) nounwind
declare i64 @nova_rt_rotl(i64, i64) nounwind
declare i64 @nova_rt_rotr(i64, i64) nounwind
declare i64 @nova_rt_htons(i64) nounwind
declare i64 @nova_rt_ntohs(i64) nounwind
declare i64 @nova_rt_htonl(i64) nounwind
declare i64 @nova_rt_ntohl(i64) nounwind
declare i64 @nova_rt_pi() nounwind
declare i64 @nova_rt_e() nounwind
declare i64 @nova_rt_char_count(i64) nounwind
declare i64 @nova_rt_char_at(i64, i64) nounwind
declare i64 @nova_rt_code_points(i64) nounwind
declare i64 @nova_rt_from_codepoint(i64) nounwind
declare i64 @nova_rt_is_valid_utf8(i64) nounwind
declare i64 @nova_rt_floor(i64) nounwind readnone
declare i64 @nova_rt_ceil(i64) nounwind readnone
declare i64 @nova_rt_pow(i64, i64) nounwind readnone
declare i64 @nova_rt_round(i64) nounwind readnone
declare i64 @nova_rt_sin(i64) nounwind readnone
declare i64 @nova_rt_cos(i64) nounwind readnone
declare i64 @nova_rt_tan(i64) nounwind readnone
declare i64 @nova_rt_log(i64) nounwind readnone
declare i64 @nova_rt_log2(i64) nounwind readnone
declare i64 @nova_rt_log10(i64) nounwind readnone
declare i64 @nova_rt_exp(i64) nounwind readnone
declare i64 @nova_rt_fabs(i64) nounwind readnone
declare i64 @nova_rt_fmax(i64, i64) nounwind readnone
declare i64 @nova_rt_fmin(i64, i64) nounwind readnone
declare i64 @nova_rt_fmax_ri(i64, i64) nounwind readnone
declare i64 @nova_rt_fmax_li(i64, i64) nounwind readnone
declare i64 @nova_rt_fmin_ri(i64, i64) nounwind readnone
declare i64 @nova_rt_fmin_li(i64, i64) nounwind readnone
declare i64 @nova_rt_fmod(i64, i64) nounwind readnone
declare i64 @nova_rt_float_to_int(i64) nounwind readnone
declare i64 @nova_rt_int_to_float(i64) nounwind readnone
declare i64 @nova_rt_to_int(i64) nounwind readnone
declare void @llvm.memcpy.p0.p0.i64(ptr nocapture writeonly, ptr nocapture readonly, i64, i1) nounwind
declare i64 @nova_rt_tarray_new(i64, i64) nounwind
declare i64 @nova_rt_tarray_of_list(i64, i64) nounwind
declare i64 @nova_rt_tarray_get(i64, i64) nounwind
declare i64 @nova_rt_tarray_getf(i64, i64) nounwind
declare i64 @nova_rt_tarray_setf(i64, i64, i64) nounwind
declare i64 @nova_rt_tarray_pushf(i64, i64) nounwind
declare i64 @nova_rt_tarray_set(i64, i64, i64) nounwind
declare i64 @nova_rt_tarray_push(i64, i64) nounwind
declare i64 @nova_rt_tarray_len(i64) nounwind
declare i64 @nova_rt_tarray_kind(i64) nounwind
declare i64 @nova_rt_tarray_fill(i64, i64) nounwind
declare i64 @nova_rt_tarray_bytes(i64) nounwind
declare i64 @nova_rt_task_on_exit_send(i64, i64) nounwind
declare i64 @nova_rt_task_cancel_exit(i64) nounwind
declare i64 @nova_rt_task_cancel_exit_val(i64, i64) nounwind
declare i64 @nova_rt_to_f32(i64) nounwind readnone
declare i64 @nova_rt_to_f64(i64) nounwind readnone
declare i64 @nova_rt_to_u8(i64) nounwind readnone
declare i64 @nova_rt_to_u16(i64) nounwind readnone
declare i64 @nova_rt_to_u32(i64) nounwind readnone
declare i64 @nova_rt_to_u64(i64) nounwind readnone
declare i64 @nova_rt_to_i8(i64) nounwind readnone
declare i64 @nova_rt_to_i16(i64) nounwind readnone
declare i64 @nova_rt_to_i32(i64) nounwind readnone
declare i64 @nova_rt_to_i64(i64) nounwind readnone
declare i64 @nova_rt_env(i64) nounwind
declare i64 @nova_rt_set_env(i64, i64) nounwind
declare i64 @nova_rt_cstr_to_string(i64) nounwind
declare void @nova_rt_rc_stats_dump() nounwind
declare i64 @nova_rt_list_free_local(i64) nounwind
declare i64 @nova_rt_dict_free_local(i64) nounwind
declare i64 @nova_rt_random_int(i64, i64) nounwind
declare i64 @nova_rt_random_float() nounwind
declare i64 @nova_rt_json_parse(i64) nounwind
declare i64 @nova_rt_json_stringify(i64) nounwind
declare i64 @nova_rt_json_stringify_pretty(i64) nounwind
declare i64 @nova_rt_regex_match(i64, i64) nounwind
declare i64 @nova_rt_regex_find(i64, i64) nounwind
declare i64 @nova_rt_regex_replace(i64, i64, i64) nounwind
declare i64 @nova_rt_regex_split(i64, i64) nounwind
declare i64 @nova_rt_regex_find_all(i64, i64) nounwind
declare i64 @nova_rt_regex_captures(i64, i64) nounwind
declare i64 @nova_rt_regex_named_captures(i64, i64) nounwind
declare i64 @nova_rt_regex_replace_all(i64, i64, i64) nounwind
declare i64 @nova_rt_path_ext(i64) nounwind
declare i64 @nova_rt_tcp_connect(i64, i64) nounwind
declare i64 @nova_rt_tcp_listen(i64) nounwind
declare i64 @nova_rt_tcp_accept(i64) nounwind
declare i64 @nova_rt_tcp_peer_addr(i64) nounwind
declare i64 @nova_rt_tcp_peer_port(i64) nounwind
declare i64 @nova_rt_tcp_send(i64, i64) nounwind
declare i64 @nova_rt_tcp_send_bytes(i64, i64) nounwind
declare i64 @nova_rt_tcp_recv(i64) nounwind
declare i64 @nova_rt_tcp_recv_bytes(i64) nounwind
declare i64 @nova_rt_tcp_wait_readable(i64, i64) nounwind
declare i64 @nova_rt_udp_bind(i64) nounwind
declare i64 @nova_rt_udp_send(i64, i64, i64, i64) nounwind
declare i64 @nova_rt_udp_recv(i64) nounwind
declare i64 @nova_rt_udp_recv_from(i64) nounwind
declare i64 @nova_rt_socket_option(i64, i64, i64) nounwind
declare void @nova_rt_tcp_close(i64) nounwind
declare i64 @nova_rt_remote_connect(i64, i64) nounwind
declare i64 @nova_rt_remote_listen(i64) nounwind
declare i64 @nova_rt_remote_bind(i64) nounwind
declare i64 @nova_rt_remote_accept(i64) nounwind
declare i64 @nova_rt_remote_send(i64, i64) nounwind
declare i64 @nova_rt_remote_recv(i64) nounwind
declare i64 @nova_rt_remote_close(i64) nounwind
declare i64 @nova_rt_remote_spawn(i64, i64, i64) nounwind
declare i64 @nova_rt_call_by_name(i64, i64) nounwind
declare void @nova_rt_register_fn(i64, i64, i64) nounwind
declare i64 @nova_rt_const_set(i64, i64) nounwind
declare i64 @nova_rt_const_get(i64) nounwind readonly
declare i64 @nova_rt_bytes_create(i64) nounwind
declare i64 @nova_rt_bytes_get(i64, i64) nounwind
declare void @nova_rt_bytes_set(i64, i64, i64) nounwind
declare i64 @nova_rt_bytes_len(i64) nounwind
declare i64 @nova_rt_bytes_slice(i64, i64, i64) nounwind
declare i64 @nova_rt_bytes_concat(i64, i64) nounwind
declare i64 @nova_rt_bytes_append(i64, i64) nounwind
declare i64 @nova_rt_bytes_append_str(i64, i64) nounwind
declare i64 @nova_rt_bytes_to_str(i64) nounwind
declare i64 @nova_rt_str_to_bytes(i64) nounwind
declare i64 @nova_rt_decode_utf8(i64) nounwind
declare i64 @nova_rt_decode_utf8_lossy(i64) nounwind
declare i64 @nova_rt_asin(i64) nounwind readnone
declare i64 @nova_rt_acos(i64) nounwind readnone
declare i64 @nova_rt_atan(i64) nounwind readnone
declare i64 @nova_rt_atan2(i64, i64) nounwind readnone
declare i64 @nova_rt_int_pow(i64, i64) nounwind readnone
declare i64 @nova_rt_alloc_count() nounwind
declare i64 @nova_rt_live_count() nounwind
declare i64 @nova_rt_enumerate(i64) nounwind
declare i64 @nova_rt_zip(i64, i64) nounwind
declare i64 @nova_rt_reduce(i64, i64, i64) nounwind
declare i64 @nova_rt_any_match(i64, i64) nounwind
declare i64 @nova_rt_all_match(i64, i64) nounwind
declare i64 @nova_rt_any_truthy(i64) nounwind readonly
declare i64 @nova_rt_all_truthy(i64) nounwind readonly
declare i64 @nova_rt_list_min(i64) nounwind readonly
declare i64 @nova_rt_list_max(i64) nounwind readonly
declare i64 @nova_rt_sum_f(i64) nounwind readonly
declare i64 @nova_rt_sum_any(i64) nounwind
declare i64 @nova_rt_list_min_any(i64) nounwind
declare i64 @nova_rt_list_max_any(i64) nounwind
declare i64 @nova_rt_list_min_f(i64) nounwind readonly
declare i64 @nova_rt_list_max_f(i64) nounwind readonly
declare i64 @nova_rt_set_create() nounwind
declare i64 @nova_rt_set_add(i64, i64) nounwind
declare i64 @nova_rt_set_has(i64, i64) nounwind readonly
declare i64 @nova_rt_set_remove(i64, i64) nounwind
declare i64 @nova_rt_set_len(i64) nounwind readonly
declare i64 @nova_rt_set_to_list(i64) nounwind
declare i64 @nova_rt_set_from_list(i64) nounwind
declare i64 @nova_rt_sum(i64) nounwind readonly
declare i64 @nova_rt_index_of(i64, i64) nounwind readonly
declare i64 @nova_rt_sort_by(i64, i64) nounwind
declare i64 @nova_rt_dict_merge(i64, i64) nounwind
declare i64 @nova_rt_dict_delete(i64, i64) nounwind
declare i64 @nova_rt_dict_size(i64) nounwind
declare i64 @nova_rt_str_count(i64, i64) nounwind readonly
declare i64 @nova_rt_lstrip(i64) nounwind
declare i64 @nova_rt_rstrip(i64) nounwind
declare i64 @nova_rt_pad_left(i64, i64, i64) nounwind
declare i64 @nova_rt_pad_right(i64, i64, i64) nounwind
declare i64 @nova_rt_cwd() nounwind
declare i64 @nova_rt_self_exe_path() nounwind
declare i64 @nova_rt_chdir(i64) nounwind
declare i64 @nova_rt_getpid() nounwind
declare i64 @nova_rt_which(i64) nounwind
declare i64 @nova_rt_dns_resolve(i64) nounwind
declare i64 @nova_rt_dns_resolve_all(i64) nounwind
declare i64 @nova_rt_reverse_dns(i64) nounwind
declare i64 @nova_rt_hostname() nounwind
declare i64 @nova_rt_list_dir(i64) nounwind
declare i64 @nova_rt_hash(i64) nounwind readonly
declare i64 @nova_rt_sha256(i64) nounwind
declare i64 @nova_rt_sha256_of_bytes(i64) nounwind
declare i64 @nova_rt_sha256_bytes(i64, i64) nounwind
declare i64 @nova_rt_hmac_sha256(i64, i64) nounwind
declare i64 @nova_rt_hex_encode(i64) nounwind
declare i64 @nova_rt_hex_decode(i64) nounwind
declare i64 @nova_rt_base64_encode(i64) nounwind
declare i64 @nova_rt_base64_decode(i64) nounwind
declare i64 @nova_rt_uuid4() nounwind
declare i64 @nova_rt_random_bytes(i64) nounwind
declare i64 @nova_rt_secure_bytes(i64) nounwind
declare i64 @nova_rt_secure_zero(i64) nounwind
declare i64 @nova_rt_ct_eq(i64, i64) nounwind
declare i64 @nova_rt_mmap_open(i64) nounwind
declare i64 @nova_rt_mmap_len(i64) nounwind
declare i64 @nova_rt_mmap_byte(i64, i64) nounwind
declare i64 @nova_rt_mmap_close(i64) nounwind
declare i64 @nova_rt_offheap_create(i64) nounwind
declare i64 @nova_rt_offheap_len(i64) nounwind
declare i64 @nova_rt_offheap_get(i64, i64) nounwind
declare i64 @nova_rt_offheap_set(i64, i64, i64) nounwind
declare i64 @nova_rt_offheap_free(i64) nounwind
declare i64 @nova_rt_atomic_new(i64) nounwind
declare i64 @nova_rt_atomic_get(i64) nounwind
declare i64 @nova_rt_atomic_set(i64, i64) nounwind
declare i64 @nova_rt_atomic_add(i64, i64) nounwind
declare i64 @nova_rt_atomic_cas(i64, i64, i64) nounwind
declare i64 @nova_rt_os_name() nounwind
declare i64 @nova_rt_arch_name() nounwind
declare i64 @nova_rt_type_name(i64) nounwind
declare i64 @nova_rt_panic(i64) nounwind
declare i64 @nova_rt_fiber_create(i64) nounwind
declare i64 @nova_rt_fiber_resume(i64) nounwind
declare i64 @nova_rt_fiber_yield() nounwind
declare i64 @nova_rt_reschedule() nounwind
declare i64 @nova_rt_simd_add(i64, i64) nounwind
declare i64 @nova_rt_simd_sub(i64, i64) nounwind
declare i64 @nova_rt_simd_mul(i64, i64) nounwind
declare i64 @nova_rt_simd_scale(i64, i64) nounwind
declare i64 @nova_rt_simd_dot(i64, i64) nounwind
declare i64 @nova_rt_simd_sum(i64) nounwind
declare i64 @nova_rt_simd_ready(i64) nounwind
declare i64 @nova_rt_kill(i64) nounwind
declare i64 @nova_rt_kill_pending() nounwind
declare i64 @nova_rt_fiber_is_done(i64) nounwind
declare i64 @nova_rt_gen_yield(i64) nounwind
declare i64 @nova_rt_gen_next(i64) nounwind
declare i64 @nova_rt_gen_value(i64) nounwind
declare i64 @nova_rt_gen_collect(i64) nounwind
declare i64 @nova_rt_term_encode(i64) nounwind
declare i64 @nova_rt_term_decode(i64) nounwind
declare i64 @nova_rt_sched_spawn(i64) nounwind
declare i64 @nova_rt_sched_spawn_on(i64, i64) nounwind
declare i64 @nova_rt_sched_carrier_count() nounwind
declare i64 @nova_rt_sched_run() nounwind
declare i64 @nova_rt_dbg_set_bp(i64, i64) nounwind
declare i64 @nova_rt_dbg_remove_bp(i64) nounwind
declare i64 @nova_rt_dbg_list_bps() nounwind
declare i64 @nova_rt_dbg_push_frame(i64, i64, i64, i64) nounwind
declare i64 @nova_rt_dbg_pop_frame() nounwind
declare i64 @nova_rt_dbg_backtrace() nounwind
declare i64 @nova_rt_dbg_hook(i64, i64, i64) nounwind
declare i64 @nova_rt_dbg_enable() nounwind
declare i64 @nova_rt_dbg_disable() nounwind
declare i64 @nova_rt_at_exit(i64) nounwind
declare i64 @nova_rt_dir_walk(i64) nounwind
declare i64 @nova_rt_flatten(i64) nounwind
declare i64 @nova_rt_dict_from_pairs(i64) nounwind
declare i64 @nova_rt_pmap(i64, i64) nounwind
declare i64 @nova_rt_pfilter(i64, i64) nounwind
declare i64 @nova_rt_pfor(i64, i64, i64) nounwind
declare i64 @nova_rt_cpu_count() nounwind
declare i64 @nova_rt_http_listen(i64) nounwind
declare i64 @nova_rt_http_accept_raw(i64) nounwind
declare i64 @nova_rt_http_read_request(i64) nounwind
declare void @nova_rt_http_send_raw(i64, i64) nounwind
declare i64 @nova_rt_stdin_read_n(i64) nounwind
declare void @nova_rt_stdout_write(i64) nounwind
declare i64 @nova_rt_list_is_kind2(i64) nounwind readonly
declare i64 @nova_rt_floatlist_view(i64) nounwind readnone
declare i64 @nova_rt_tensor_zeros(i64) nounwind
declare i64 @nova_rt_tensor_from_list(i64, i64) nounwind
declare i64 @nova_rt_tensor_shape(i64) nounwind
declare i64 @nova_rt_tensor_size(i64) nounwind
declare i64 @nova_rt_tensor_rank(i64) nounwind
declare i64 @nova_rt_tensor_get(i64, i64) nounwind
declare void @nova_rt_tensor_set(i64, i64, i64) nounwind
declare i64 @nova_rt_tensor_add(i64, i64) nounwind
declare i64 @nova_rt_tensor_mul(i64, i64) nounwind
declare i64 @nova_rt_tensor_scale(i64, i64) nounwind
declare i64 @nova_rt_tensor_matmul(i64, i64) nounwind
declare i64 @nova_rt_tensor_sum(i64) nounwind
declare i64 @nova_rt_tensor_relu(i64) nounwind
declare i64 @nova_rt_tensor_exp(i64) nounwind
declare i64 @nova_rt_tensor_softmax(i64) nounwind
declare i64 @nova_rt_tensor_transpose(i64) nounwind
declare i64 @nova_rt_tensor_reshape(i64, i64) nounwind
declare i64 @nova_rt_tensor_sigmoid(i64) nounwind
declare i64 @nova_rt_tensor_tanh(i64) nounwind
declare i64 @nova_rt_tensor_log(i64) nounwind
declare i64 @nova_rt_tensor_argmax(i64) nounwind
declare i64 @nova_rt_tensor_sub(i64, i64) nounwind
declare i64 @nova_rt_tensor_div(i64, i64) nounwind
declare i64 @nova_rt_tensor_add_bias(i64, i64) nounwind
declare i64 @nova_rt_tensor_to_list(i64) nounwind
declare i64 @nova_rt_ok(i64) nounwind
declare i64 @nova_rt_parse_int_safe(i64) nounwind
declare i64 @nova_rt_parse_float_safe(i64) nounwind
declare i64 @nova_rt_err(i64) nounwind
declare i64 @nova_rt_some(i64) nounwind
declare i64 @nova_rt_none() nounwind
declare i64 @nova_rt_is_ok(i64) nounwind readonly
declare i64 @nova_rt_is_err(i64) nounwind readonly
declare i64 @nova_rt_is_some(i64) nounwind readonly
declare i64 @nova_rt_is_none(i64) nounwind readonly
declare i64 @nova_rt_unwrap(i64) nounwind
declare i64 @nova_rt_unwrap_err(i64) nounwind
declare i64 @nova_rt_unwrap_or(i64, i64) nounwind
declare i64 @nova_rt_result_tag(i64) nounwind
declare void @nova_rt_clear_is_result() nounwind
declare i64 @nova_rt_try_unwrap_value(i64) nounwind
declare i64 @nova_rt_result_map(i64, i64) nounwind
declare i64 @nova_rt_result_map_err(i64, i64) nounwind
declare i64 @nova_rt_str_char_at(i64, i64) nounwind
declare i64 @nova_rt_str_index_of(i64, i64) nounwind
declare i64 @nova_rt_str_last_index_of(i64, i64) nounwind
declare i64 @nova_rt_dict_entries(i64) nounwind
declare i64 @nova_rt_list_sort_desc(i64) nounwind
declare i64 @nova_rt_str_is_palindrome(i64) nounwind
declare i64 @nova_rt_list_rotate_right(i64, i64) nounwind
declare i64 @nova_rt_str_is_ascii(i64) nounwind
declare i64 @nova_rt_str_is_hex(i64) nounwind
declare i64 @nova_rt_list_sum_int(i64) nounwind
declare i64 @nova_rt_list_min_val(i64) nounwind
declare i64 @nova_rt_list_max_val(i64) nounwind
declare i64 @nova_rt_dict_is_empty(i64) nounwind
declare i64 @nova_rt_list_is_empty(i64) nounwind
declare i64 @nova_rt_str_is_empty(i64) nounwind
declare i64 @nova_rt_str_center_pad(i64, i64, i64) nounwind
declare i64 @nova_rt_str_squeeze(i64) nounwind
declare i64 @nova_rt_str_lines(i64) nounwind
declare i64 @nova_rt_str_title_case(i64) nounwind
declare i64 @nova_rt_str_camel_case(i64) nounwind
declare i64 @nova_rt_str_snake_case(i64) nounwind
declare i64 @nova_rt_str_kebab_case(i64) nounwind
declare i64 @nova_rt_list_interleave(i64, i64) nounwind
declare i64 @nova_rt_str_indent(i64, i64) nounwind
declare i64 @nova_rt_path_within(i64, i64) nounwind
declare i64 @nova_rt_tls_send_bytes(i64, i64) nounwind
declare i64 @nova_rt_tls_recv_bytes(i64) nounwind
declare i64 @nova_rt_tls_upgrade(i64, i64, i64) nounwind
declare i64 @nova_rt_ws_accept_key(i64) nounwind
declare i64 @nova_rt_format(i64, i64) nounwind
declare i64 @nova_rt_format_one(i64, i64) nounwind
declare i64 @nova_rt_center(i64, i64, i64) nounwind
declare i64 @nova_rt_hex(i64) nounwind
declare i64 @nova_rt_oct(i64) nounwind
declare i64 @nova_rt_bin(i64) nounwind
declare i64 @nova_rt_iter(i64) nounwind
declare i64 @nova_rt_iter_range(i64, i64) nounwind
declare i64 @nova_rt_iter_range_step(i64, i64, i64) nounwind
declare i64 @nova_rt_iter_map(i64, i64) nounwind
declare i64 @nova_rt_iter_filter(i64, i64) nounwind
declare i64 @nova_rt_iter_take(i64, i64) nounwind
declare i64 @nova_rt_iter_skip(i64, i64) nounwind
declare i64 @nova_rt_iter_zip(i64, i64) nounwind
declare i64 @nova_rt_iter_chain(i64, i64) nounwind
declare i64 @nova_rt_iter_enumerate(i64) nounwind
declare i64 @nova_rt_iter_flat_map(i64, i64) nounwind
declare i64 @nova_rt_iter_next(i64) nounwind
declare i64 @nova_rt_iter_collect(i64) nounwind
declare i64 @nova_rt_iter_reduce(i64, i64, i64) nounwind
declare i64 @nova_rt_iter_for_each(i64, i64) nounwind
declare i64 @nova_rt_iter_count(i64) nounwind
declare i64 @nova_rt_iter_sum(i64) nounwind
declare i64 @nova_rt_iter_any(i64, i64) nounwind
declare i64 @nova_rt_iter_all(i64, i64) nounwind
declare i64 @nova_rt_iter_find(i64, i64) nounwind
declare i64 @nova_rt_async(i64) nounwind
declare i64 @nova_rt_await(i64) nounwind
declare i64 @nova_rt_await_all(i64) nounwind
declare i64 @nova_rt_buffer_create() nounwind
declare i64 @nova_rt_buffer_create_cap(i64) nounwind
declare void @nova_rt_buffer_append(i64, i64) nounwind
declare void @nova_rt_buffer_append_char(i64, i64) nounwind
declare void @nova_rt_buffer_append_int(i64, i64) nounwind
declare void @nova_rt_buffer_append_float(i64, i64) nounwind
declare i64 @nova_rt_buffer_to_str(i64) nounwind
declare i64 @nova_rt_buffer_len(i64) nounwind readonly
declare void @nova_rt_buffer_clear(i64) nounwind
declare i64 @nova_rt_buffer_str(i64) nounwind
declare void @nova_rt_set_arena_mode(i64) nounwind
declare i64 @nova_rt_is_arena_mode() nounwind
declare i64 @nova_rt_arena_scope_enter() nounwind
declare i64 @nova_rt_arena_scope_exit(i64) nounwind
declare i64 @nova_rt_semver_parse(i64) nounwind
declare i64 @nova_rt_semver_compare(i64, i64) nounwind readonly
declare i64 @nova_rt_semver_satisfies(i64, i64) nounwind readonly
declare i64 @nova_rt_semver_format(i64) nounwind
declare i64 @nova_rt_lockfile_read(i64) nounwind
declare i64 @nova_rt_lockfile_write(i64, i64) nounwind
declare i64 @nova_rt_pkg_resolve(i64, i64) nounwind
declare i64 @nova_rt_await_any(i64) nounwind
declare i64 @nova_rt_assert_eq(i64, i64) nounwind
declare i64 @nova_rt_assert_ne(i64, i64) nounwind
declare i64 @nova_rt_assert_true(i64) nounwind
declare i64 @nova_rt_assert_false(i64) nounwind
declare i64 @nova_rt_assert_near(i64, i64, i64) nounwind
declare i64 @nova_rt_test_run(i64, i64) nounwind
declare i64 @nova_rt_test_summary() nounwind
declare i64 @nova_rt_test_reset() nounwind
declare i64 @nova_rt_datetime_now() nounwind
declare i64 @nova_rt_datetime_timestamp() nounwind
declare i64 @nova_rt_datetime_year(i64) nounwind
declare i64 @nova_rt_datetime_month(i64) nounwind
declare i64 @nova_rt_datetime_day(i64) nounwind
declare i64 @nova_rt_datetime_hour(i64) nounwind
declare i64 @nova_rt_datetime_minute(i64) nounwind
declare i64 @nova_rt_datetime_second(i64) nounwind
declare i64 @nova_rt_datetime_weekday(i64) nounwind
declare i64 @nova_rt_datetime_format(i64, i64) nounwind
declare i64 @nova_rt_datetime_parse(i64, i64) nounwind
declare i64 @nova_rt_datetime_diff(i64, i64) nounwind
declare i64 @nova_rt_datetime_add_days(i64, i64) nounwind
declare i64 @nova_rt_datetime_add_hours(i64, i64) nounwind
declare i64 @nova_rt_pq_create() nounwind
declare void @nova_rt_pq_push(i64, i64, i64) nounwind
declare i64 @nova_rt_pq_pop(i64) nounwind
declare i64 @nova_rt_pq_peek(i64) nounwind
declare i64 @nova_rt_pq_peek_priority(i64) nounwind
declare i64 @nova_rt_pq_len(i64) nounwind
declare i64 @nova_rt_pq_is_empty(i64) nounwind
declare i64 @nova_rt_deque_create() nounwind
declare void @nova_rt_deque_push_back(i64, i64) nounwind
declare void @nova_rt_deque_push_front(i64, i64) nounwind
declare i64 @nova_rt_deque_pop_front(i64) nounwind
declare i64 @nova_rt_deque_pop_back(i64) nounwind
declare i64 @nova_rt_deque_front(i64) nounwind
declare i64 @nova_rt_deque_back(i64) nounwind
declare i64 @nova_rt_deque_get(i64, i64) nounwind
declare i64 @nova_rt_deque_len(i64) nounwind
declare i64 @nova_rt_deque_is_empty(i64) nounwind
declare i64 @nova_rt_deque_to_list(i64) nounwind
declare i64 @nova_rt_smap_create() nounwind
declare void @nova_rt_smap_set(i64, i64, i64) nounwind
declare i64 @nova_rt_smap_get(i64, i64) nounwind
declare i64 @nova_rt_smap_has(i64, i64) nounwind
declare void @nova_rt_smap_del(i64, i64) nounwind
declare i64 @nova_rt_smap_len(i64) nounwind
declare i64 @nova_rt_smap_keys(i64) nounwind
declare i64 @nova_rt_smap_values(i64) nounwind
declare i64 @nova_rt_smap_range(i64, i64, i64) nounwind
declare i64 @nova_rt_lru_create(i64) nounwind
declare i64 @nova_rt_lru_get(i64, i64) nounwind
declare i64 @nova_rt_lru_has(i64, i64) nounwind
declare void @nova_rt_lru_put(i64, i64, i64) nounwind
declare i64 @nova_rt_lru_len(i64) nounwind
declare i64 @nova_rt_lru_hits(i64) nounwind
declare i64 @nova_rt_lru_misses(i64) nounwind
declare i64 @nova_rt_lru_cap(i64) nounwind
declare i64 @nova_rt_counter_create() nounwind
declare void @nova_rt_counter_inc(i64, i64) nounwind
declare void @nova_rt_counter_add(i64, i64, i64) nounwind
declare i64 @nova_rt_counter_get(i64, i64) nounwind
declare i64 @nova_rt_counter_total(i64) nounwind
declare i64 @nova_rt_counter_most_common(i64, i64) nounwind
declare i64 @nova_rt_ringbuf_create(i64) nounwind
declare void @nova_rt_ringbuf_push(i64, i64) nounwind
declare i64 @nova_rt_ringbuf_pop(i64) nounwind
declare i64 @nova_rt_ringbuf_len(i64) nounwind
declare i64 @nova_rt_ringbuf_cap(i64) nounwind
declare i64 @nova_rt_ringbuf_is_full(i64) nounwind
declare void @nova_rt_log_trace(i64, i64) nounwind
declare void @nova_rt_log_debug(i64, i64) nounwind
declare void @nova_rt_log_info(i64, i64) nounwind
declare void @nova_rt_log_warn(i64, i64) nounwind
declare void @nova_rt_log_error(i64, i64) nounwind
declare void @nova_rt_log_fatal(i64, i64) nounwind
declare void @nova_rt_log_set_level(i64) nounwind
declare i64 @nova_rt_log_get_level() nounwind
declare void @nova_rt_log_set_json(i64) nounwind
declare i64 @nova_rt_assert_contains(i64, i64) nounwind
declare i64 @nova_rt_assert_approx(i64, i64, i64) nounwind
declare i64 @nova_rt_assert_throws(i64, i64) nounwind
declare i64 @nova_rt_test_run_tap(i64, i64, i64) nounwind
declare i64 @nova_rt_crc32(i64) nounwind
declare i64 @nova_rt_fnv1a(i64) nounwind
declare i64 @nova_rt_murmur3(i64, i64) nounwind
declare i64 @nova_rt_arena_create() nounwind
declare i64 @nova_rt_arena_alloc(i64, i64) nounwind
declare void @nova_rt_arena_reset(i64) nounwind
declare void @nova_rt_arena_free(i64) nounwind
declare i64 @nova_rt_arena_used(i64) nounwind
declare i64 @nova_rt_checked_add(i64, i64) nounwind
declare i64 @nova_rt_checked_sub(i64, i64) nounwind
declare i64 @nova_rt_checked_mul(i64, i64) nounwind
declare void @nova_rt_overflow_panic() nounwind
declare i64 @nova_rt_weak_create(i64) nounwind
declare i64 @nova_rt_weak_upgrade(i64) nounwind
declare i64 @nova_rt_weak_alive(i64) nounwind
declare void @nova_rt_weak_invalidate(i64) nounwind
declare void @nova_rt_process_link(i64, i64) nounwind
declare i64 @nova_rt_process_monitor(i64, i64) nounwind
declare void @nova_rt_process_demonitor(i64) nounwind
declare void @nova_rt_process_exit_notify(i64, i64) nounwind
declare void @nova_rt_stack_enter() nounwind
declare void @nova_rt_stack_exit() nounwind
declare void @nova_rt_stack_set_max(i64) nounwind
declare void @nova_rt_deprecated_warn(i64, i64) nounwind
declare void @nova_rt_log_fn_entry(i64) nounwind
declare void @nova_rt_log_fn_exit(i64) nounwind
declare i64 @nova_rt_str_repeat(i64, i64) nounwind
declare i64 @nova_rt_str_pad_left(i64, i64, i64) nounwind
declare i64 @nova_rt_str_pad_right(i64, i64, i64) nounwind
declare i64 @nova_rt_str_center(i64, i64, i64) nounwind
declare i64 @nova_rt_str_remove_prefix(i64, i64) nounwind
declare i64 @nova_rt_str_remove_suffix(i64, i64) nounwind
declare i64 @nova_rt_str_insert(i64, i64, i64) nounwind
declare i64 @nova_rt_str_reverse(i64) nounwind
declare i64 @nova_rt_str_chars(i64) nounwind
declare i64 @nova_rt_str_count_char(i64, i64) nounwind
declare i64 @nova_rt_cstr_of(i64) nounwind
declare i64 @nova_rt_null_ptr() nounwind
declare i64 @nova_rt_is_null(i64) nounwind
declare i64 @nova_rt_ptr_read(i64) nounwind
declare void @nova_rt_ptr_write(i64, i64) nounwind
declare i64 @nova_rt_ptr_read_u8(i64) nounwind readonly
declare i64 @nova_rt_ptr_read_i8(i64) nounwind readonly
declare i64 @nova_rt_ptr_read_u16(i64) nounwind readonly
declare i64 @nova_rt_ptr_read_i16(i64) nounwind readonly
declare i64 @nova_rt_ptr_read_u32(i64) nounwind readonly
declare i64 @nova_rt_ptr_read_i32(i64) nounwind readonly
declare i64 @nova_rt_ptr_read_u64(i64) nounwind readonly
declare i64 @nova_rt_ptr_read_f32(i64) nounwind readonly
declare i64 @nova_rt_ptr_read_f64(i64) nounwind readonly
declare i64 @nova_rt_ptr_write_u8(i64, i64) nounwind
declare i64 @nova_rt_ptr_write_u16(i64, i64) nounwind
declare i64 @nova_rt_ptr_write_u32(i64, i64) nounwind
declare i64 @nova_rt_ptr_write_u64(i64, i64) nounwind
declare i64 @nova_rt_ptr_write_f32(i64, i64) nounwind
declare i64 @nova_rt_ptr_write_f64(i64, i64) nounwind
declare i64 @nova_rt_offheap_get_f64(i64, i64) nounwind readonly
declare i64 @nova_rt_offheap_set_f64(i64, i64, i64) nounwind
declare i64 @nova_rt_ptr_add(i64, i64) nounwind
declare i64 @nova_rt_ptr_diff(i64, i64) nounwind
declare i64 @nova_rt_memcpy_unsafe(i64, i64, i64) nounwind
declare i64 @nova_rt_memset_unsafe(i64, i64, i64) nounwind
declare i64 @nova_rt_sizeof_ptr() nounwind
declare i64 @nova_rt_shutdown_requested() nounwind
declare i64 @nova_rt_reload_requested() nounwind
declare i64 @nova_rt_alloc_raw(i64) nounwind
declare void @nova_rt_free_raw(i64) nounwind
declare i64 @nova_rt_str_from_cstr(i64) nounwind
declare i64 @nova_rt_build_toml_parse(i64) nounwind
declare i64 @nova_rt_build_toml_format(i64) nounwind
declare i64 @nova_rt_build_get_sources(i64) nounwind
declare i64 @nova_rt_build_file_mtime(i64) nounwind
declare i64 @nova_rt_build_needs_rebuild(i64, i64) nounwind
declare i64 @nova_rt_build_changed_sources(i64, i64) nounwind
declare i64 @nova_rt_fmt_format(i64) nounwind
declare i64 @nova_rt_fmt_check(i64) nounwind
declare i64 @nova_rt_target_current() nounwind
declare i64 @nova_rt_target_list() nounwind
declare i64 @nova_rt_target_is_wasm(i64) nounwind
declare i64 @nova_rt_target_arch(i64) nounwind
declare i64 @nova_rt_bench_run(i64, i64, i64) nounwind
declare i64 @nova_rt_bench_report() nounwind
declare i64 @nova_rt_bench_reset() nounwind
declare i64 @nova_rt_cov_mark(i64, i64) nounwind
declare i64 @nova_rt_cov_get(i64, i64) nounwind
declare i64 @nova_rt_cov_report() nounwind
declare i64 @nova_rt_cov_reset() nounwind
declare i64 @nova_rt_cov_export_lcov(i64) nounwind
declare i64 @nova_rt_prof_start(i64) nounwind
declare i64 @nova_rt_prof_stop(i64) nounwind
declare i64 @nova_rt_prof_report() nounwind
declare i64 @nova_rt_prof_get_ns(i64) nounwind
declare i64 @nova_rt_prof_reset() nounwind
declare i64 @nova_rt_prof_export_flame(i64) nounwind
declare i64 @nova_rt_abi_version() nounwind
declare i64 @nova_rt_dap_log(i64, i64) nounwind
declare i64 @nova_rt_dap_breakpoint(i64, i64) nounwind
declare i64 @nova_rt_dap_send(i64) nounwind
declare i64 @nova_rt_doc_extract(i64) nounwind
declare i64 @nova_rt_doc_to_markdown(i64, i64) nounwind
declare i64 @nova_rt_doc_to_html(i64, i64) nounwind
declare i64 @nova_rt_doc_entry_count(i64) nounwind
declare i64 @nova_rt_tls_connect(i64, i64) nounwind
declare i64 @nova_rt_tls_connect_insecure(i64, i64) nounwind
declare i64 @nova_rt_tls_connect_alpn(i64, i64, i64) nounwind
declare i64 @nova_rt_tls_listen_alpn(i64, i64) nounwind
declare i64 @nova_rt_tls_alpn(i64) nounwind
declare i64 @nova_rt_tls_listen(i64, i64, i64) nounwind
declare i64 @nova_rt_tls_accept(i64) nounwind
declare i64 @nova_rt_tls_send(i64, i64) nounwind
declare i64 @nova_rt_tls_recv(i64, i64) nounwind
declare i64 @nova_rt_tls_close(i64) nounwind
declare i64 @nova_rt_ws_upgrade(i64) nounwind
declare i64 @nova_rt_ws_send(i64, i64) nounwind
declare i64 @nova_rt_ws_recv(i64, i64) nounwind
declare i64 @nova_rt_ws_close(i64) nounwind
declare i64 @nova_rt_node_connect(i64, i64) nounwind
declare i64 @nova_rt_node_send(i64, i64) nounwind
declare i64 @nova_rt_node_recv(i64, i64) nounwind
declare i64 @nova_rt_node_close(i64) nounwind
declare i64 @nova_rt_node_listen(i64) nounwind
declare i64 @nova_rt_node_accept(i64) nounwind
declare i64 @nova_rt_hot_reload_watch(i64) nounwind
declare i64 @nova_rt_hot_reload_check() nounwind
declare i64 @nova_rt_hot_reload_path(i64) nounwind
declare i64 @nova_rt_hot_load(i64) nounwind
declare i64 @nova_rt_hot_unload(i64) nounwind
declare i64 @nova_rt_hot_reload(i64) nounwind
declare i64 @nova_rt_hot_sym(i64, i64) nounwind
declare i64 @nova_rt_hot_call0(i64) nounwind
declare i64 @nova_rt_hot_call1(i64, i64) nounwind
declare i64 @nova_rt_hot_call2(i64, i64, i64) nounwind
declare i64 @nova_rt_hot_call3(i64, i64, i64, i64) nounwind
declare i64 @nova_rt_ws_init(i64) nounwind
declare i64 @nova_rt_ws_spawn(i64) nounwind
declare i64 @nova_rt_ws_task_count() nounwind
declare i64 @nova_rt_ws_steal_count() nounwind
declare i64 @nova_rt_ws_shutdown() nounwind
declare i64 @nova_rt_io_poll_create() nounwind
declare i64 @nova_rt_io_poll_add(i64, i64, i64) nounwind
declare i64 @nova_rt_io_poll_wait(i64, i64) nounwind
declare i64 @nova_rt_io_poll_remove(i64, i64) nounwind
declare i64 @nova_rt_io_poll_close(i64) nounwind
declare i64 @nova_rt_io_set_nonblocking(i64) nounwind
declare i64 @nova_rt_wasm_compile(i64) nounwind
declare i64 @nova_rt_wasm_run(i64) nounwind
declare i64 @nova_rt_wasm_free(i64) nounwind
declare i64 @nova_rt_gpu_alloc(i64) nounwind
declare i64 @nova_rt_gpu_free(i64) nounwind
declare i64 @nova_rt_gpu_write(i64, i64, i64) nounwind
declare i64 @nova_rt_gpu_read(i64, i64) nounwind
declare i64 @nova_rt_gpu_kernel_run(i64, i64, i64, i64) nounwind
declare i64 @nova_rt_gpu_sync() nounwind
declare i64 @nova_rt_json_encode(i64) nounwind
declare i64 @nova_rt_json_encode_float(i64) nounwind
declare i64 @nova_rt_json_encode_bool(i64) nounwind
declare i64 @nova_rt_json_decode(i64) nounwind
declare i64 @nova_rt_http_close(i64) nounwind
declare i64 @nova_rt_route_match(i64, i64) nounwind
declare i64 @nova_rt_arr_create(i64) nounwind
declare i64 @nova_rt_arr_free(i64) nounwind
declare i64 @nova_rt_arr_set(i64, i64, i64) nounwind
declare i64 @nova_rt_arr_get(i64, i64) nounwind
declare i64 @nova_rt_arr_fill(i64, i64) nounwind
declare i64 @nova_rt_arr_size(i64) nounwind
declare i64 @nova_rt_arr_add(i64, i64) nounwind
declare i64 @nova_rt_arr_dot(i64, i64) nounwind
declare i64 @nova_rt_ecs_world() nounwind
declare i64 @nova_rt_ecs_entity(i64) nounwind
declare i64 @nova_rt_ecs_set(i64, i64, i64, i64) nounwind
declare i64 @nova_rt_ecs_get(i64, i64, i64) nounwind
declare i64 @nova_rt_ecs_has(i64, i64, i64) nounwind
declare i64 @nova_rt_ecs_query(i64, i64) nounwind
declare i64 @nova_rt_ecs_destroy(i64, i64) nounwind
declare i64 @nova_rt_deploy_config(i64, i64) nounwind
declare i64 @nova_rt_deploy_validate(i64) nounwind
declare i64 @nova_rt_semver_compatible(i64, i64) nounwind

; ESCAPE semver_parse: allocs=2 escape=2 local=0
define i64 @semver_parse(i64 %p0) nounwind uwtable !dbg !200 {
entry:
  %slot.s = alloca i64, align 8, !dbg !201
  store i64 %p0, ptr %slot.s, align 8, !dbg !201
  %slot.parts = alloca i64, align 8, !dbg !201
  store i64 0, ptr %slot.parts, align 8, !dbg !201
  %r0 = load i64, ptr %slot.s, align 8, !dbg !202
  %r1.p = getelementptr inbounds [2 x i8], ptr @.str.0, i64 0, i64 0, !dbg !202
  %r1 = ptrtoint ptr %r1.p to i64, !dbg !202
  %r2 = call i64 @nova_rt_split(i64 %r0, i64 %r1), !dbg !202
  store i64 %r2, ptr %slot.parts, align 8, !dbg !202
  %r3 = add i64 %r2, 0, !dbg !203
  %r4.lp = inttoptr i64 %r3 to ptr, !dbg !203
  %r4.szp = getelementptr i64, ptr %r4.lp, i64 1, !dbg !203
  %r4 = load i64, ptr %r4.szp, align 8, !tbaa !6, !dbg !203
  %r5 = add i64 3, 0, !dbg !203
  %r6.cmp = icmp ne i64 %r4, %r5, !dbg !203
  %r6 = zext i1 %r6.cmp to i64, !dbg !203
  %br_then00 = icmp ne i64 %r6, 0, !dbg !203
  br i1 %br_then00, label %then0, label %else1, !dbg !203
then0:
  %r7 = add i64 0, 0, !dbg !204
  %r8 = add i64 0, 0, !dbg !204
  %r9 = add i64 0, 0, !dbg !204
  %r10.ptr = call ptr @nova_rt_hashed_struct_alloc(i64 32), !dbg !204
  %r10.thash = getelementptr i64, ptr %r10.ptr, i64 0, !dbg !204
  store i64 6952761171063, ptr %r10.thash, align 8, !dbg !204
  %r10.f0 = getelementptr i64, ptr %r10.ptr, i64 1, !dbg !204
  store i64 %r7, ptr %r10.f0, align 8, !dbg !204
  %r10.f1 = getelementptr i64, ptr %r10.ptr, i64 2, !dbg !204
  store i64 %r8, ptr %r10.f1, align 8, !dbg !204
  %r10.f2 = getelementptr i64, ptr %r10.ptr, i64 3, !dbg !204
  store i64 %r9, ptr %r10.f2, align 8, !dbg !204
  %r10 = ptrtoint ptr %r10.ptr to i64, !dbg !204
  ret i64 %r10, !dbg !204
else1:
  br label %endif2, !dbg !204
endif2:
  %r11 = load i64, ptr %slot.parts, align 8, !dbg !205
  %r12 = add i64 0, 0, !dbg !205
  %r13 = call i64 @nova_rt_index_get(i64 %r11, i64 %r12), !dbg !205
  %r14 = call i64 @nova_rt_to_int(i64 %r13), !dbg !205
  %r15 = load i64, ptr %slot.parts, align 8, !dbg !205
  %r16 = add i64 1, 0, !dbg !205
  %r17 = call i64 @nova_rt_index_get(i64 %r15, i64 %r16), !dbg !205
  %r18 = call i64 @nova_rt_to_int(i64 %r17), !dbg !205
  %r19 = load i64, ptr %slot.parts, align 8, !dbg !205
  %r20 = add i64 2, 0, !dbg !205
  %r21 = call i64 @nova_rt_index_get(i64 %r19, i64 %r20), !dbg !205
  %r22 = call i64 @nova_rt_to_int(i64 %r21), !dbg !205
  %r23.ptr = call ptr @nova_rt_hashed_struct_alloc(i64 32), !dbg !205
  %r23.thash = getelementptr i64, ptr %r23.ptr, i64 0, !dbg !205
  store i64 6952761171063, ptr %r23.thash, align 8, !dbg !205
  %r23.f0 = getelementptr i64, ptr %r23.ptr, i64 1, !dbg !205
  store i64 %r14, ptr %r23.f0, align 8, !dbg !205
  %r23.f1 = getelementptr i64, ptr %r23.ptr, i64 2, !dbg !205
  store i64 %r18, ptr %r23.f1, align 8, !dbg !205
  %r23.f2 = getelementptr i64, ptr %r23.ptr, i64 3, !dbg !205
  store i64 %r22, ptr %r23.f2, align 8, !dbg !205
  %r23 = ptrtoint ptr %r23.ptr to i64, !dbg !205
  ret i64 %r23, !dbg !205
}

; ESCAPE semver_str: allocs=0 escape=0 local=0
define i64 @semver_str(i64 %p0) nounwind uwtable !dbg !206 {
entry:
  %slot.v = alloca i64, align 8, !dbg !207
  store i64 %p0, ptr %slot.v, align 8, !dbg !207
  %r0 = load i64, ptr %slot.v, align 8, !dbg !208
  %r1.ptr = inttoptr i64 %r0 to ptr, !dbg !208
  %r1.gep = getelementptr i64, ptr %r1.ptr, i64 1, !dbg !208
  %r1 = load i64, ptr %r1.gep, align 8, !dbg !208
  %r2 = call i64 @nova_rt_int_to_str(i64 %r1), !dbg !208
  %r3.p = getelementptr inbounds [2 x i8], ptr @.str.0, i64 0, i64 0, !dbg !208
  %r3 = ptrtoint ptr %r3.p to i64, !dbg !208
  %r4 = call i64 @nova_rt_str_concat(i64 %r2, i64 %r3), !dbg !208
  call i64 @nova_rt_rc_drop_temp(i64 %r2), !dbg !208
  %r5 = load i64, ptr %slot.v, align 8, !dbg !208
  %r6.ptr = inttoptr i64 %r5 to ptr, !dbg !208
  %r6.gep = getelementptr i64, ptr %r6.ptr, i64 2, !dbg !208
  %r6 = load i64, ptr %r6.gep, align 8, !dbg !208
  %r7 = call i64 @nova_rt_int_to_str(i64 %r6), !dbg !208
  %r8 = call i64 @nova_rt_str_concat(i64 %r4, i64 %r7), !dbg !208
  call i64 @nova_rt_rc_drop_temp(i64 %r4), !dbg !208
  call i64 @nova_rt_rc_drop_temp(i64 %r7), !dbg !208
  %r9.p = getelementptr inbounds [2 x i8], ptr @.str.0, i64 0, i64 0, !dbg !208
  %r9 = ptrtoint ptr %r9.p to i64, !dbg !208
  %r10 = call i64 @nova_rt_str_concat(i64 %r8, i64 %r9), !dbg !208
  call i64 @nova_rt_rc_drop_temp(i64 %r8), !dbg !208
  %r11 = load i64, ptr %slot.v, align 8, !dbg !208
  %r12.ptr = inttoptr i64 %r11 to ptr, !dbg !208
  %r12.gep = getelementptr i64, ptr %r12.ptr, i64 3, !dbg !208
  %r12 = load i64, ptr %r12.gep, align 8, !dbg !208
  %r13 = call i64 @nova_rt_int_to_str(i64 %r12), !dbg !208
  %r14 = call i64 @nova_rt_str_concat(i64 %r10, i64 %r13), !dbg !208
  call i64 @nova_rt_rc_drop_temp(i64 %r10), !dbg !208
  call i64 @nova_rt_rc_drop_temp(i64 %r13), !dbg !208
  ret i64 %r14, !dbg !208
}

; ESCAPE semver_cmp: allocs=0 escape=0 local=0
define i64 @semver_cmp(i64 %p0, i64 %p1) nounwind uwtable !dbg !209 {
entry:
  %slot.a = alloca i64, align 8, !dbg !210
  store i64 %p0, ptr %slot.a, align 8, !dbg !210
  %slot.b = alloca i64, align 8, !dbg !210
  store i64 %p1, ptr %slot.b, align 8, !dbg !210
  %r0 = load i64, ptr %slot.a, align 8, !dbg !211
  %r1.ptr = inttoptr i64 %r0 to ptr, !dbg !211
  %r1.gep = getelementptr i64, ptr %r1.ptr, i64 1, !dbg !211
  %r1 = load i64, ptr %r1.gep, align 8, !dbg !211
  %r2 = load i64, ptr %slot.b, align 8, !dbg !211
  %r3.ptr = inttoptr i64 %r2 to ptr, !dbg !211
  %r3.gep = getelementptr i64, ptr %r3.ptr, i64 1, !dbg !211
  %r3 = load i64, ptr %r3.gep, align 8, !dbg !211
  %r4.cmp = icmp ne i64 %r1, %r3, !dbg !211
  %r4 = zext i1 %r4.cmp to i64, !dbg !211
  %br_then30 = icmp ne i64 %r4, 0, !dbg !211
  br i1 %br_then30, label %then3, label %else4, !dbg !211
then3:
  %r5 = load i64, ptr %slot.a, align 8, !dbg !212
  %r6.ptr = inttoptr i64 %r5 to ptr, !dbg !212
  %r6.gep = getelementptr i64, ptr %r6.ptr, i64 1, !dbg !212
  %r6 = load i64, ptr %r6.gep, align 8, !dbg !212
  %r7 = load i64, ptr %slot.b, align 8, !dbg !212
  %r8.ptr = inttoptr i64 %r7 to ptr, !dbg !212
  %r8.gep = getelementptr i64, ptr %r8.ptr, i64 1, !dbg !212
  %r8 = load i64, ptr %r8.gep, align 8, !dbg !212
  %r9 = sub i64 %r6, %r8, !dbg !212
  ret i64 %r9, !dbg !212
else4:
  br label %endif5, !dbg !212
endif5:
  %r10 = load i64, ptr %slot.a, align 8, !dbg !213
  %r11.ptr = inttoptr i64 %r10 to ptr, !dbg !213
  %r11.gep = getelementptr i64, ptr %r11.ptr, i64 2, !dbg !213
  %r11 = load i64, ptr %r11.gep, align 8, !dbg !213
  %r12 = load i64, ptr %slot.b, align 8, !dbg !213
  %r13.ptr = inttoptr i64 %r12 to ptr, !dbg !213
  %r13.gep = getelementptr i64, ptr %r13.ptr, i64 2, !dbg !213
  %r13 = load i64, ptr %r13.gep, align 8, !dbg !213
  %r14.cmp = icmp ne i64 %r11, %r13, !dbg !213
  %r14 = zext i1 %r14.cmp to i64, !dbg !213
  %br_then61 = icmp ne i64 %r14, 0, !dbg !213
  br i1 %br_then61, label %then6, label %else7, !dbg !213
then6:
  %r15 = load i64, ptr %slot.a, align 8, !dbg !214
  %r16.ptr = inttoptr i64 %r15 to ptr, !dbg !214
  %r16.gep = getelementptr i64, ptr %r16.ptr, i64 2, !dbg !214
  %r16 = load i64, ptr %r16.gep, align 8, !dbg !214
  %r17 = load i64, ptr %slot.b, align 8, !dbg !214
  %r18.ptr = inttoptr i64 %r17 to ptr, !dbg !214
  %r18.gep = getelementptr i64, ptr %r18.ptr, i64 2, !dbg !214
  %r18 = load i64, ptr %r18.gep, align 8, !dbg !214
  %r19 = sub i64 %r16, %r18, !dbg !214
  ret i64 %r19, !dbg !214
else7:
  br label %endif8, !dbg !214
endif8:
  %r20 = load i64, ptr %slot.a, align 8, !dbg !215
  %r21.ptr = inttoptr i64 %r20 to ptr, !dbg !215
  %r21.gep = getelementptr i64, ptr %r21.ptr, i64 3, !dbg !215
  %r21 = load i64, ptr %r21.gep, align 8, !dbg !215
  %r22 = load i64, ptr %slot.b, align 8, !dbg !215
  %r23.ptr = inttoptr i64 %r22 to ptr, !dbg !215
  %r23.gep = getelementptr i64, ptr %r23.ptr, i64 3, !dbg !215
  %r23 = load i64, ptr %r23.gep, align 8, !dbg !215
  %r24 = sub i64 %r21, %r23, !dbg !215
  ret i64 %r24, !dbg !215
}

; ESCAPE semver_gt: allocs=0 escape=0 local=0
define i64 @semver_gt(i64 %p0, i64 %p1) nounwind uwtable !dbg !216 {
entry:
  %slot.a = alloca i64, align 8, !dbg !217
  store i64 %p0, ptr %slot.a, align 8, !dbg !217
  %slot.b = alloca i64, align 8, !dbg !217
  store i64 %p1, ptr %slot.b, align 8, !dbg !217
  %r0 = load i64, ptr %slot.a, align 8, !dbg !218
  %r1 = load i64, ptr %slot.b, align 8, !dbg !218
  %r2 = call i64 @semver_cmp(i64 %r0, i64 %r1), !dbg !218
  %r3 = add i64 0, 0, !dbg !218
  %r4.cmp = icmp sgt i64 %r2, %r3, !dbg !218
  %r4 = zext i1 %r4.cmp to i64, !dbg !218
  ret i64 %r4, !dbg !218
}

; ESCAPE semver_gte: allocs=0 escape=0 local=0
define i64 @semver_gte(i64 %p0, i64 %p1) nounwind uwtable !dbg !219 {
entry:
  %slot.a = alloca i64, align 8, !dbg !220
  store i64 %p0, ptr %slot.a, align 8, !dbg !220
  %slot.b = alloca i64, align 8, !dbg !220
  store i64 %p1, ptr %slot.b, align 8, !dbg !220
  %r0 = load i64, ptr %slot.a, align 8, !dbg !221
  %r1 = load i64, ptr %slot.b, align 8, !dbg !221
  %r2 = call i64 @semver_cmp(i64 %r0, i64 %r1), !dbg !221
  %r3 = add i64 0, 0, !dbg !221
  %r4.cmp = icmp sge i64 %r2, %r3, !dbg !221
  %r4 = zext i1 %r4.cmp to i64, !dbg !221
  ret i64 %r4, !dbg !221
}

; ESCAPE semver_lt: allocs=0 escape=0 local=0
define i64 @semver_lt(i64 %p0, i64 %p1) nounwind uwtable !dbg !222 {
entry:
  %slot.a = alloca i64, align 8, !dbg !223
  store i64 %p0, ptr %slot.a, align 8, !dbg !223
  %slot.b = alloca i64, align 8, !dbg !223
  store i64 %p1, ptr %slot.b, align 8, !dbg !223
  %r0 = load i64, ptr %slot.a, align 8, !dbg !224
  %r1 = load i64, ptr %slot.b, align 8, !dbg !224
  %r2 = call i64 @semver_cmp(i64 %r0, i64 %r1), !dbg !224
  %r3 = add i64 0, 0, !dbg !224
  %r4.cmp = icmp slt i64 %r2, %r3, !dbg !224
  %r4 = zext i1 %r4.cmp to i64, !dbg !224
  ret i64 %r4, !dbg !224
}

; ESCAPE semver_eq: allocs=0 escape=0 local=0
define i64 @semver_eq(i64 %p0, i64 %p1) nounwind uwtable !dbg !225 {
entry:
  %slot.a = alloca i64, align 8, !dbg !226
  store i64 %p0, ptr %slot.a, align 8, !dbg !226
  %slot.b = alloca i64, align 8, !dbg !226
  store i64 %p1, ptr %slot.b, align 8, !dbg !226
  %r0 = load i64, ptr %slot.a, align 8, !dbg !227
  %r1 = load i64, ptr %slot.b, align 8, !dbg !227
  %r2 = call i64 @semver_cmp(i64 %r0, i64 %r1), !dbg !227
  %r3 = add i64 0, 0, !dbg !227
  %r4.cmp = icmp eq i64 %r2, %r3, !dbg !227
  %r4 = zext i1 %r4.cmp to i64, !dbg !227
  ret i64 %r4, !dbg !227
}

; ESCAPE semver_compatible: allocs=0 escape=0 local=0
define i64 @semver_compatible(i64 %p0, i64 %p1) nounwind uwtable !dbg !228 {
entry:
  %slot.a = alloca i64, align 8, !dbg !229
  store i64 %p0, ptr %slot.a, align 8, !dbg !229
  %slot.b = alloca i64, align 8, !dbg !229
  store i64 %p1, ptr %slot.b, align 8, !dbg !229
  %r0 = load i64, ptr %slot.a, align 8, !dbg !230
  %r1.ptr = inttoptr i64 %r0 to ptr, !dbg !230
  %r1.gep = getelementptr i64, ptr %r1.ptr, i64 1, !dbg !230
  %r1 = load i64, ptr %r1.gep, align 8, !dbg !230
  %r2 = load i64, ptr %slot.b, align 8, !dbg !230
  %r3.ptr = inttoptr i64 %r2 to ptr, !dbg !230
  %r3.gep = getelementptr i64, ptr %r3.ptr, i64 1, !dbg !230
  %r3 = load i64, ptr %r3.gep, align 8, !dbg !230
  %r4.cmp = icmp eq i64 %r1, %r3, !dbg !230
  %r4 = zext i1 %r4.cmp to i64, !dbg !230
  ret i64 %r4, !dbg !230
}

; ESCAPE SemVer__show: allocs=0 escape=0 local=0
define i64 @SemVer__show(i64 %p0) nounwind uwtable !dbg !231 {
entry:
  %slot.self = alloca i64, align 8, !dbg !232
  store i64 %p0, ptr %slot.self, align 8, !dbg !232
  %r0.p = getelementptr inbounds [9 x i8], ptr @.str.1, i64 0, i64 0, !dbg !233
  %r0 = ptrtoint ptr %r0.p to i64, !dbg !233
  %r1.p = getelementptr inbounds [9 x i8], ptr @.str.2, i64 0, i64 0, !dbg !233
  %r1 = ptrtoint ptr %r1.p to i64, !dbg !233
  %r2 = call i64 @nova_rt_str_concat(i64 %r0, i64 %r1), !dbg !233
  %r3 = load i64, ptr %slot.self, align 8, !dbg !233
  %r4.ptr = inttoptr i64 %r3 to ptr, !dbg !233
  %r4.gep = getelementptr i64, ptr %r4.ptr, i64 1, !dbg !233
  %r4 = load i64, ptr %r4.gep, align 8, !dbg !233
  %r5 = call i64 @nova_rt_int_to_str(i64 %r4), !dbg !233
  %r6 = call i64 @nova_rt_str_concat(i64 %r2, i64 %r5), !dbg !233
  call i64 @nova_rt_rc_drop_temp(i64 %r2), !dbg !233
  call i64 @nova_rt_rc_drop_temp(i64 %r5), !dbg !233
  %r7.p = getelementptr inbounds [10 x i8], ptr @.str.3, i64 0, i64 0, !dbg !233
  %r7 = ptrtoint ptr %r7.p to i64, !dbg !233
  %r8 = call i64 @nova_rt_str_concat(i64 %r6, i64 %r7), !dbg !233
  call i64 @nova_rt_rc_drop_temp(i64 %r6), !dbg !233
  %r9 = load i64, ptr %slot.self, align 8, !dbg !233
  %r10.ptr = inttoptr i64 %r9 to ptr, !dbg !233
  %r10.gep = getelementptr i64, ptr %r10.ptr, i64 2, !dbg !233
  %r10 = load i64, ptr %r10.gep, align 8, !dbg !233
  %r11 = call i64 @nova_rt_int_to_str(i64 %r10), !dbg !233
  %r12 = call i64 @nova_rt_str_concat(i64 %r8, i64 %r11), !dbg !233
  call i64 @nova_rt_rc_drop_temp(i64 %r8), !dbg !233
  call i64 @nova_rt_rc_drop_temp(i64 %r11), !dbg !233
  %r13.p = getelementptr inbounds [10 x i8], ptr @.str.4, i64 0, i64 0, !dbg !233
  %r13 = ptrtoint ptr %r13.p to i64, !dbg !233
  %r14 = call i64 @nova_rt_str_concat(i64 %r12, i64 %r13), !dbg !233
  call i64 @nova_rt_rc_drop_temp(i64 %r12), !dbg !233
  %r15 = load i64, ptr %slot.self, align 8, !dbg !233
  %r16.ptr = inttoptr i64 %r15 to ptr, !dbg !233
  %r16.gep = getelementptr i64, ptr %r16.ptr, i64 3, !dbg !233
  %r16 = load i64, ptr %r16.gep, align 8, !dbg !233
  %r17 = call i64 @nova_rt_int_to_str(i64 %r16), !dbg !233
  %r18 = call i64 @nova_rt_str_concat(i64 %r14, i64 %r17), !dbg !233
  call i64 @nova_rt_rc_drop_temp(i64 %r14), !dbg !233
  call i64 @nova_rt_rc_drop_temp(i64 %r17), !dbg !233
  %r19.p = getelementptr inbounds [3 x i8], ptr @.str.5, i64 0, i64 0, !dbg !233
  %r19 = ptrtoint ptr %r19.p to i64, !dbg !233
  %r20 = call i64 @nova_rt_str_concat(i64 %r18, i64 %r19), !dbg !233
  call i64 @nova_rt_rc_drop_temp(i64 %r18), !dbg !233
  ret i64 %r20, !dbg !233
}

; ESCAPE SemVer__to_json: allocs=0 escape=0 local=0
define i64 @SemVer__to_json(i64 %p0) nounwind uwtable !dbg !234 {
entry:
  %slot.self = alloca i64, align 8, !dbg !235
  store i64 %p0, ptr %slot.self, align 8, !dbg !235
  %r0.p = getelementptr inbounds [2 x i8], ptr @.str.6, i64 0, i64 0, !dbg !236
  %r0 = ptrtoint ptr %r0.p to i64, !dbg !236
  %r1.p = getelementptr inbounds [9 x i8], ptr @.str.7, i64 0, i64 0, !dbg !236
  %r1 = ptrtoint ptr %r1.p to i64, !dbg !236
  %r2 = call i64 @nova_rt_str_concat(i64 %r0, i64 %r1), !dbg !236
  %r3 = load i64, ptr %slot.self, align 8, !dbg !236
  %r4.ptr = inttoptr i64 %r3 to ptr, !dbg !236
  %r4.gep = getelementptr i64, ptr %r4.ptr, i64 1, !dbg !236
  %r4 = load i64, ptr %r4.gep, align 8, !dbg !236
  %r5 = call i64 @nova_rt_json_stringify(i64 %r4), !dbg !236
  %r6 = call i64 @nova_rt_str_concat(i64 %r2, i64 %r5), !dbg !236
  call i64 @nova_rt_rc_drop_temp(i64 %r2), !dbg !236
  %r7.p = getelementptr inbounds [10 x i8], ptr @.str.8, i64 0, i64 0, !dbg !236
  %r7 = ptrtoint ptr %r7.p to i64, !dbg !236
  %r8 = call i64 @nova_rt_str_concat(i64 %r6, i64 %r7), !dbg !236
  call i64 @nova_rt_rc_drop_temp(i64 %r6), !dbg !236
  %r9 = load i64, ptr %slot.self, align 8, !dbg !236
  %r10.ptr = inttoptr i64 %r9 to ptr, !dbg !236
  %r10.gep = getelementptr i64, ptr %r10.ptr, i64 2, !dbg !236
  %r10 = load i64, ptr %r10.gep, align 8, !dbg !236
  %r11 = call i64 @nova_rt_json_stringify(i64 %r10), !dbg !236
  %r12 = call i64 @nova_rt_str_concat(i64 %r8, i64 %r11), !dbg !236
  call i64 @nova_rt_rc_drop_temp(i64 %r8), !dbg !236
  %r13.p = getelementptr inbounds [10 x i8], ptr @.str.9, i64 0, i64 0, !dbg !236
  %r13 = ptrtoint ptr %r13.p to i64, !dbg !236
  %r14 = call i64 @nova_rt_str_concat(i64 %r12, i64 %r13), !dbg !236
  call i64 @nova_rt_rc_drop_temp(i64 %r12), !dbg !236
  %r15 = load i64, ptr %slot.self, align 8, !dbg !236
  %r16.ptr = inttoptr i64 %r15 to ptr, !dbg !236
  %r16.gep = getelementptr i64, ptr %r16.ptr, i64 3, !dbg !236
  %r16 = load i64, ptr %r16.gep, align 8, !dbg !236
  %r17 = call i64 @nova_rt_json_stringify(i64 %r16), !dbg !236
  %r18 = call i64 @nova_rt_str_concat(i64 %r14, i64 %r17), !dbg !236
  call i64 @nova_rt_rc_drop_temp(i64 %r14), !dbg !236
  %r19.p = getelementptr inbounds [2 x i8], ptr @.str.10, i64 0, i64 0, !dbg !236
  %r19 = ptrtoint ptr %r19.p to i64, !dbg !236
  %r20 = call i64 @nova_rt_str_concat(i64 %r18, i64 %r19), !dbg !236
  call i64 @nova_rt_rc_drop_temp(i64 %r18), !dbg !236
  ret i64 %r20, !dbg !236
}

; ESCAPE SemVer__from_json: allocs=5 escape=1 local=4
define i64 @SemVer__from_json(i64 %p0) nounwind uwtable !dbg !237 {
entry:
  %slot.d = alloca i64, align 8, !dbg !238
  store i64 %p0, ptr %slot.d, align 8, !dbg !238
  %slot._fj_major = alloca i64, align 8, !dbg !238
  store i64 0, ptr %slot._fj_major, align 8, !dbg !238
  %slot._fj_minor = alloca i64, align 8, !dbg !238
  store i64 0, ptr %slot._fj_minor, align 8, !dbg !238
  %slot._fj_patch = alloca i64, align 8, !dbg !238
  store i64 0, ptr %slot._fj_patch, align 8, !dbg !238
  %r0 = load i64, ptr %slot.d, align 8, !dbg !239
  %r1 = call i64 @nova_rt_type_name(i64 %r0), !dbg !239
  %r2.p = getelementptr inbounds [5 x i8], ptr @.str.11, i64 0, i64 0, !dbg !239
  %r2 = ptrtoint ptr %r2.p to i64, !dbg !239
  %r3 = call i64 @nova_rt_neq(i64 %r1, i64 %r2), !dbg !239
  %br_then90 = icmp ne i64 %r3, 0, !dbg !239
  br i1 %br_then90, label %then9, label %else10, !dbg !239
then9:
  %r4 = call i64 @nova_rt_dict_create(), !dbg !239
  store i64 %r4, ptr %slot.d, align 8, !dbg !239
  br label %endif11, !dbg !239
else10:
  br label %endif11, !dbg !239
endif11:
  %r6 = add i64 0, 0, !dbg !239
  %r5 = call i64 @nova_rt_list_create(), !dbg !239
  call i64 @nova_rt_list_append(i64 %r5, i64 %r6), !dbg !239
  %r7 = add i64 0, 0, !dbg !239
  %r8 = call i64 @nova_rt_list_get(i64 %r5, i64 %r7), !dbg !239
  store i64 %r8, ptr %slot._fj_major, align 8, !dbg !239
  %r9 = load i64, ptr %slot.d, align 8, !dbg !239
  %r10.p = getelementptr inbounds [6 x i8], ptr @.str.12, i64 0, i64 0, !dbg !239
  %r10 = ptrtoint ptr %r10.p to i64, !dbg !239
  %r11 = call i64 @nova_rt_contains(i64 %r9, i64 %r10), !dbg !239
  %br_then121 = icmp ne i64 %r11, 0, !dbg !239
  br i1 %br_then121, label %then12, label %else13, !dbg !239
then12:
  %r12 = load i64, ptr %slot.d, align 8, !dbg !239
  %r13.p = getelementptr inbounds [6 x i8], ptr @.str.12, i64 0, i64 0, !dbg !239
  %r13 = ptrtoint ptr %r13.p to i64, !dbg !239
  %r14 = call i64 @nova_rt_dict_get(i64 %r12, i64 %r13), !dbg !239
  store i64 %r14, ptr %slot._fj_major, align 8, !dbg !239
  br label %endif14, !dbg !239
else13:
  br label %endif14, !dbg !239
endif14:
  %r16 = add i64 0, 0, !dbg !239
  %r15 = call i64 @nova_rt_list_create(), !dbg !239
  call i64 @nova_rt_list_append(i64 %r15, i64 %r16), !dbg !239
  %r17 = add i64 0, 0, !dbg !239
  %r18 = call i64 @nova_rt_list_get(i64 %r15, i64 %r17), !dbg !239
  store i64 %r18, ptr %slot._fj_minor, align 8, !dbg !239
  %r19 = load i64, ptr %slot.d, align 8, !dbg !239
  %r20.p = getelementptr inbounds [6 x i8], ptr @.str.13, i64 0, i64 0, !dbg !239
  %r20 = ptrtoint ptr %r20.p to i64, !dbg !239
  %r21 = call i64 @nova_rt_contains(i64 %r19, i64 %r20), !dbg !239
  %br_then152 = icmp ne i64 %r21, 0, !dbg !239
  br i1 %br_then152, label %then15, label %else16, !dbg !239
then15:
  %r22 = load i64, ptr %slot.d, align 8, !dbg !239
  %r23.p = getelementptr inbounds [6 x i8], ptr @.str.13, i64 0, i64 0, !dbg !239
  %r23 = ptrtoint ptr %r23.p to i64, !dbg !239
  %r24 = call i64 @nova_rt_dict_get(i64 %r22, i64 %r23), !dbg !239
  store i64 %r24, ptr %slot._fj_minor, align 8, !dbg !239
  br label %endif17, !dbg !239
else16:
  br label %endif17, !dbg !239
endif17:
  %r26 = add i64 0, 0, !dbg !239
  %r25 = call i64 @nova_rt_list_create(), !dbg !239
  call i64 @nova_rt_list_append(i64 %r25, i64 %r26), !dbg !239
  %r27 = add i64 0, 0, !dbg !239
  %r28 = call i64 @nova_rt_list_get(i64 %r25, i64 %r27), !dbg !239
  store i64 %r28, ptr %slot._fj_patch, align 8, !dbg !239
  %r29 = load i64, ptr %slot.d, align 8, !dbg !239
  %r30.p = getelementptr inbounds [6 x i8], ptr @.str.14, i64 0, i64 0, !dbg !239
  %r30 = ptrtoint ptr %r30.p to i64, !dbg !239
  %r31 = call i64 @nova_rt_contains(i64 %r29, i64 %r30), !dbg !239
  %br_then183 = icmp ne i64 %r31, 0, !dbg !239
  br i1 %br_then183, label %then18, label %else19, !dbg !239
then18:
  %r32 = load i64, ptr %slot.d, align 8, !dbg !239
  %r33.p = getelementptr inbounds [6 x i8], ptr @.str.14, i64 0, i64 0, !dbg !239
  %r33 = ptrtoint ptr %r33.p to i64, !dbg !239
  %r34 = call i64 @nova_rt_dict_get(i64 %r32, i64 %r33), !dbg !239
  store i64 %r34, ptr %slot._fj_patch, align 8, !dbg !239
  br label %endif20, !dbg !239
else19:
  br label %endif20, !dbg !239
endif20:
  %r35 = load i64, ptr %slot._fj_major, align 8, !dbg !239
  %r36 = load i64, ptr %slot._fj_minor, align 8, !dbg !239
  %r37 = load i64, ptr %slot._fj_patch, align 8, !dbg !239
  %r38.ptr = call ptr @nova_rt_hashed_struct_alloc(i64 32), !dbg !239
  %r38.thash = getelementptr i64, ptr %r38.ptr, i64 0, !dbg !239
  store i64 6952761171063, ptr %r38.thash, align 8, !dbg !239
  %r38.f0 = getelementptr i64, ptr %r38.ptr, i64 1, !dbg !239
  store i64 %r35, ptr %r38.f0, align 8, !dbg !239
  %r38.f1 = getelementptr i64, ptr %r38.ptr, i64 2, !dbg !239
  store i64 %r36, ptr %r38.f1, align 8, !dbg !239
  %r38.f2 = getelementptr i64, ptr %r38.ptr, i64 3, !dbg !239
  store i64 %r37, ptr %r38.f2, align 8, !dbg !239
  %r38 = ptrtoint ptr %r38.ptr to i64, !dbg !239
  ret i64 %r38, !dbg !239
}

; ESCAPE SemVer__from_json_safe: allocs=0 escape=0 local=0
define i64 @SemVer__from_json_safe(i64 %p0) nounwind uwtable !dbg !240 {
entry:
  %slot._fjss = alloca i64, align 8, !dbg !241
  store i64 %p0, ptr %slot._fjss, align 8, !dbg !241
  %slot._fjsd = alloca i64, align 8, !dbg !241
  store i64 0, ptr %slot._fjsd, align 8, !dbg !241
  %r0 = load i64, ptr %slot._fjss, align 8, !dbg !242
  %r1 = call i64 @nova_rt_json_decode(i64 %r0), !dbg !242
  store i64 %r1, ptr %slot._fjsd, align 8, !dbg !242
  %r2 = add i64 %r1, 0, !dbg !242
  %r3 = call i64 @nova_rt_type_name(i64 %r2), !dbg !242
  %r4.p = getelementptr inbounds [5 x i8], ptr @.str.11, i64 0, i64 0, !dbg !242
  %r4 = ptrtoint ptr %r4.p to i64, !dbg !242
  %r5 = call i64 @nova_rt_neq(i64 %r3, i64 %r4), !dbg !242
  %br_then210 = icmp ne i64 %r5, 0, !dbg !242
  br i1 %br_then210, label %then21, label %else22, !dbg !242
then21:
  %r6.p = getelementptr inbounds [34 x i8], ptr @.str.15, i64 0, i64 0, !dbg !242
  %r6 = ptrtoint ptr %r6.p to i64, !dbg !242
  %r7 = call i64 @nova_rt_err(i64 %r6), !dbg !242
  ret i64 %r7, !dbg !242
else22:
  br label %endif23, !dbg !242
endif23:
  %r8 = load i64, ptr %slot._fjsd, align 8, !dbg !242
  %r9.p = getelementptr inbounds [6 x i8], ptr @.str.12, i64 0, i64 0, !dbg !242
  %r9 = ptrtoint ptr %r9.p to i64, !dbg !242
  %r10 = call i64 @nova_rt_contains(i64 %r8, i64 %r9), !dbg !242
  %br_then241 = icmp ne i64 %r10, 0, !dbg !242
  br i1 %br_then241, label %then24, label %else25, !dbg !242
then24:
  %r11 = load i64, ptr %slot._fjsd, align 8, !dbg !242
  %r12.p = getelementptr inbounds [6 x i8], ptr @.str.12, i64 0, i64 0, !dbg !242
  %r12 = ptrtoint ptr %r12.p to i64, !dbg !242
  %r13 = call i64 @nova_rt_index_get(i64 %r11, i64 %r12), !dbg !242
  %r14 = call i64 @nova_rt_type_name(i64 %r13), !dbg !242
  %r15.p = getelementptr inbounds [4 x i8], ptr @.str.16, i64 0, i64 0, !dbg !242
  %r15 = ptrtoint ptr %r15.p to i64, !dbg !242
  %r16 = call i64 @nova_rt_neq(i64 %r14, i64 %r15), !dbg !242
  %br_then272 = icmp ne i64 %r16, 0, !dbg !242
  br i1 %br_then272, label %then27, label %else28, !dbg !242
then27:
  %r17.p = getelementptr inbounds [34 x i8], ptr @.str.17, i64 0, i64 0, !dbg !242
  %r17 = ptrtoint ptr %r17.p to i64, !dbg !242
  %r18 = load i64, ptr %slot._fjsd, align 8, !dbg !242
  %r19.p = getelementptr inbounds [6 x i8], ptr @.str.12, i64 0, i64 0, !dbg !242
  %r19 = ptrtoint ptr %r19.p to i64, !dbg !242
  %r20 = call i64 @nova_rt_index_get(i64 %r18, i64 %r19), !dbg !242
  %r21 = call i64 @nova_rt_type_name(i64 %r20), !dbg !242
  %r22 = call i64 @nova_rt_str_concat(i64 %r17, i64 %r21), !dbg !242
  %r23 = call i64 @nova_rt_err(i64 %r22), !dbg !242
  ret i64 %r23, !dbg !242
else28:
  br label %endif29, !dbg !242
endif29:
  br label %endif26, !dbg !242
else25:
  br label %endif26, !dbg !242
endif26:
  %r24 = load i64, ptr %slot._fjsd, align 8, !dbg !242
  %r25.p = getelementptr inbounds [6 x i8], ptr @.str.13, i64 0, i64 0, !dbg !242
  %r25 = ptrtoint ptr %r25.p to i64, !dbg !242
  %r26 = call i64 @nova_rt_contains(i64 %r24, i64 %r25), !dbg !242
  %br_then303 = icmp ne i64 %r26, 0, !dbg !242
  br i1 %br_then303, label %then30, label %else31, !dbg !242
then30:
  %r27 = load i64, ptr %slot._fjsd, align 8, !dbg !242
  %r28.p = getelementptr inbounds [6 x i8], ptr @.str.13, i64 0, i64 0, !dbg !242
  %r28 = ptrtoint ptr %r28.p to i64, !dbg !242
  %r29 = call i64 @nova_rt_index_get(i64 %r27, i64 %r28), !dbg !242
  %r30 = call i64 @nova_rt_type_name(i64 %r29), !dbg !242
  %r31.p = getelementptr inbounds [4 x i8], ptr @.str.16, i64 0, i64 0, !dbg !242
  %r31 = ptrtoint ptr %r31.p to i64, !dbg !242
  %r32 = call i64 @nova_rt_neq(i64 %r30, i64 %r31), !dbg !242
  %br_then334 = icmp ne i64 %r32, 0, !dbg !242
  br i1 %br_then334, label %then33, label %else34, !dbg !242
then33:
  %r33.p = getelementptr inbounds [34 x i8], ptr @.str.18, i64 0, i64 0, !dbg !242
  %r33 = ptrtoint ptr %r33.p to i64, !dbg !242
  %r34 = load i64, ptr %slot._fjsd, align 8, !dbg !242
  %r35.p = getelementptr inbounds [6 x i8], ptr @.str.13, i64 0, i64 0, !dbg !242
  %r35 = ptrtoint ptr %r35.p to i64, !dbg !242
  %r36 = call i64 @nova_rt_index_get(i64 %r34, i64 %r35), !dbg !242
  %r37 = call i64 @nova_rt_type_name(i64 %r36), !dbg !242
  %r38 = call i64 @nova_rt_str_concat(i64 %r33, i64 %r37), !dbg !242
  %r39 = call i64 @nova_rt_err(i64 %r38), !dbg !242
  ret i64 %r39, !dbg !242
else34:
  br label %endif35, !dbg !242
endif35:
  br label %endif32, !dbg !242
else31:
  br label %endif32, !dbg !242
endif32:
  %r40 = load i64, ptr %slot._fjsd, align 8, !dbg !242
  %r41.p = getelementptr inbounds [6 x i8], ptr @.str.14, i64 0, i64 0, !dbg !242
  %r41 = ptrtoint ptr %r41.p to i64, !dbg !242
  %r42 = call i64 @nova_rt_contains(i64 %r40, i64 %r41), !dbg !242
  %br_then365 = icmp ne i64 %r42, 0, !dbg !242
  br i1 %br_then365, label %then36, label %else37, !dbg !242
then36:
  %r43 = load i64, ptr %slot._fjsd, align 8, !dbg !242
  %r44.p = getelementptr inbounds [6 x i8], ptr @.str.14, i64 0, i64 0, !dbg !242
  %r44 = ptrtoint ptr %r44.p to i64, !dbg !242
  %r45 = call i64 @nova_rt_index_get(i64 %r43, i64 %r44), !dbg !242
  %r46 = call i64 @nova_rt_type_name(i64 %r45), !dbg !242
  %r47.p = getelementptr inbounds [4 x i8], ptr @.str.16, i64 0, i64 0, !dbg !242
  %r47 = ptrtoint ptr %r47.p to i64, !dbg !242
  %r48 = call i64 @nova_rt_neq(i64 %r46, i64 %r47), !dbg !242
  %br_then396 = icmp ne i64 %r48, 0, !dbg !242
  br i1 %br_then396, label %then39, label %else40, !dbg !242
then39:
  %r49.p = getelementptr inbounds [34 x i8], ptr @.str.19, i64 0, i64 0, !dbg !242
  %r49 = ptrtoint ptr %r49.p to i64, !dbg !242
  %r50 = load i64, ptr %slot._fjsd, align 8, !dbg !242
  %r51.p = getelementptr inbounds [6 x i8], ptr @.str.14, i64 0, i64 0, !dbg !242
  %r51 = ptrtoint ptr %r51.p to i64, !dbg !242
  %r52 = call i64 @nova_rt_index_get(i64 %r50, i64 %r51), !dbg !242
  %r53 = call i64 @nova_rt_type_name(i64 %r52), !dbg !242
  %r54 = call i64 @nova_rt_str_concat(i64 %r49, i64 %r53), !dbg !242
  %r55 = call i64 @nova_rt_err(i64 %r54), !dbg !242
  ret i64 %r55, !dbg !242
else40:
  br label %endif41, !dbg !242
endif41:
  br label %endif38, !dbg !242
else37:
  br label %endif38, !dbg !242
endif38:
  %r56 = load i64, ptr %slot._fjsd, align 8, !dbg !242
  %r57 = call i64 @SemVer__from_json(i64 %r56), !dbg !242
  %r58 = call i64 @nova_rt_ok(i64 %r57), !dbg !242
  ret i64 %r58, !dbg !242
}

; ESCAPE SemVer__from_dict: allocs=5 escape=0 local=5
define i64 @SemVer__from_dict(i64 %p0) nounwind uwtable !dbg !243 {
entry:
  %slot.d = alloca i64, align 8, !dbg !244
  store i64 %p0, ptr %slot.d, align 8, !dbg !244
  %slot._fd_major = alloca i64, align 8, !dbg !244
  store i64 0, ptr %slot._fd_major, align 8, !dbg !244
  %slot._fdraw_major = alloca i64, align 8, !dbg !244
  store i64 0, ptr %slot._fdraw_major, align 8, !dbg !244
  %slot._fdv_major = alloca i64, align 8, !dbg !244
  store i64 0, ptr %slot._fdv_major, align 8, !dbg !244
  %slot._fde_major = alloca i64, align 8, !dbg !244
  store i64 0, ptr %slot._fde_major, align 8, !dbg !244
  %slot._fd_minor = alloca i64, align 8, !dbg !244
  store i64 0, ptr %slot._fd_minor, align 8, !dbg !244
  %slot._fdraw_minor = alloca i64, align 8, !dbg !244
  store i64 0, ptr %slot._fdraw_minor, align 8, !dbg !244
  %slot._fdv_minor = alloca i64, align 8, !dbg !244
  store i64 0, ptr %slot._fdv_minor, align 8, !dbg !244
  %slot._fde_minor = alloca i64, align 8, !dbg !244
  store i64 0, ptr %slot._fde_minor, align 8, !dbg !244
  %slot._fd_patch = alloca i64, align 8, !dbg !244
  store i64 0, ptr %slot._fd_patch, align 8, !dbg !244
  %slot._fdraw_patch = alloca i64, align 8, !dbg !244
  store i64 0, ptr %slot._fdraw_patch, align 8, !dbg !244
  %slot._fdv_patch = alloca i64, align 8, !dbg !244
  store i64 0, ptr %slot._fdv_patch, align 8, !dbg !244
  %slot._fde_patch = alloca i64, align 8, !dbg !244
  store i64 0, ptr %slot._fde_patch, align 8, !dbg !244
  %r0 = load i64, ptr %slot.d, align 8, !dbg !245
  %r1 = call i64 @nova_rt_type_name(i64 %r0), !dbg !245
  %r2.p = getelementptr inbounds [5 x i8], ptr @.str.11, i64 0, i64 0, !dbg !245
  %r2 = ptrtoint ptr %r2.p to i64, !dbg !245
  %r3 = call i64 @nova_rt_neq(i64 %r1, i64 %r2), !dbg !245
  %br_then420 = icmp ne i64 %r3, 0, !dbg !245
  br i1 %br_then420, label %then42, label %else43, !dbg !245
then42:
  %r4 = call i64 @nova_rt_dict_create(), !dbg !245
  store i64 %r4, ptr %slot.d, align 8, !dbg !245
  br label %endif44, !dbg !245
else43:
  br label %endif44, !dbg !245
endif44:
  %r6 = add i64 0, 0, !dbg !245
  %r5 = call i64 @nova_rt_list_create(), !dbg !245
  call i64 @nova_rt_list_append(i64 %r5, i64 %r6), !dbg !245
  %r7 = add i64 0, 0, !dbg !245
  %r8 = call i64 @nova_rt_list_get(i64 %r5, i64 %r7), !dbg !245
  store i64 %r8, ptr %slot._fd_major, align 8, !dbg !245
  %r9 = load i64, ptr %slot.d, align 8, !dbg !245
  %r10.p = getelementptr inbounds [6 x i8], ptr @.str.12, i64 0, i64 0, !dbg !245
  %r10 = ptrtoint ptr %r10.p to i64, !dbg !245
  %r11 = call i64 @nova_rt_contains(i64 %r9, i64 %r10), !dbg !245
  %br_then451 = icmp ne i64 %r11, 0, !dbg !245
  br i1 %br_then451, label %then45, label %else46, !dbg !245
then45:
  %r12 = load i64, ptr %slot.d, align 8, !dbg !245
  %r13.p = getelementptr inbounds [6 x i8], ptr @.str.12, i64 0, i64 0, !dbg !245
  %r13 = ptrtoint ptr %r13.p to i64, !dbg !245
  %r14 = call i64 @nova_rt_dict_get(i64 %r12, i64 %r13), !dbg !245
  store i64 %r14, ptr %slot._fdraw_major, align 8, !dbg !245
  %r15 = add i64 %r14, 0, !dbg !245
  %r16.p = getelementptr inbounds [1 x i8], ptr @.str.20, i64 0, i64 0, !dbg !245
  %r16 = ptrtoint ptr %r16.p to i64, !dbg !245
  %r17 = call i64 @nova_rt_neq(i64 %r15, i64 %r16), !dbg !245
  %br_then482 = icmp ne i64 %r17, 0, !dbg !245
  br i1 %br_then482, label %then48, label %else49, !dbg !245
then48:
  %r18 = load i64, ptr %slot._fdraw_major, align 8, !dbg !245
  %r19 = call i64 @nova_rt_parse_int_safe(i64 %r18), !dbg !245
  %r20.ptr = inttoptr i64 %r19 to ptr, !dbg !245
  %r20.gep = getelementptr i64, ptr %r20.ptr, i64 0, !dbg !245
  %r20 = load i64, ptr %r20.gep, align 8, !dbg !245
  %r21 = add i64 0, 0, !dbg !245
  %r22.cmp = icmp eq i64 %r20, %r21, !dbg !245
  %r22 = zext i1 %r22.cmp to i64, !dbg !245
  %br_marm_0523 = icmp ne i64 %r22, 0, !dbg !245
  br i1 %br_marm_0523, label %marm_052, label %mchk_154, !dbg !245
marm_052:
  %r23.ptr = inttoptr i64 %r19 to ptr, !dbg !245
  %r23.gep = getelementptr i64, ptr %r23.ptr, i64 1, !dbg !245
  %r23 = load i64, ptr %r23.gep, align 8, !dbg !245
  store i64 %r23, ptr %slot._fdv_major, align 8, !dbg !245
  %r24 = add i64 %r23, 0, !dbg !245
  store i64 %r24, ptr %slot._fd_major, align 8, !dbg !245
  br label %match_exit51, !dbg !245
mchk_154:
  %r25 = add i64 1, 0, !dbg !245
  %r26.cmp = icmp eq i64 %r20, %r25, !dbg !245
  %r26 = zext i1 %r26.cmp to i64, !dbg !245
  %br_marm_1534 = icmp ne i64 %r26, 0, !dbg !245
  br i1 %br_marm_1534, label %marm_153, label %match_fall55, !dbg !245
marm_153:
  %r27.ptr = inttoptr i64 %r19 to ptr, !dbg !245
  %r27.gep = getelementptr i64, ptr %r27.ptr, i64 1, !dbg !245
  %r27 = load i64, ptr %r27.gep, align 8, !dbg !245
  store i64 %r27, ptr %slot._fde_major, align 8, !dbg !245
  %r28.p = getelementptr inbounds [16 x i8], ptr @.str.21, i64 0, i64 0, !dbg !245
  %r28 = ptrtoint ptr %r28.p to i64, !dbg !245
  %r29 = add i64 %r27, 0, !dbg !245
  %r30 = call i64 @nova_rt_str_concat(i64 %r28, i64 %r29), !dbg !245
  %r31 = call i64 @nova_rt_err(i64 %r30), !dbg !245
  ret i64 %r31, !dbg !245
match_fall55:
  br label %match_exit51, !dbg !245
match_exit51:
  br label %endif50, !dbg !245
else49:
  br label %endif50, !dbg !245
endif50:
  br label %endif47, !dbg !245
else46:
  br label %endif47, !dbg !245
endif47:
  %r33 = add i64 0, 0, !dbg !245
  %r32 = call i64 @nova_rt_list_create(), !dbg !245
  call i64 @nova_rt_list_append(i64 %r32, i64 %r33), !dbg !245
  %r34 = add i64 0, 0, !dbg !245
  %r35 = call i64 @nova_rt_list_get(i64 %r32, i64 %r34), !dbg !245
  store i64 %r35, ptr %slot._fd_minor, align 8, !dbg !245
  %r36 = load i64, ptr %slot.d, align 8, !dbg !245
  %r37.p = getelementptr inbounds [6 x i8], ptr @.str.13, i64 0, i64 0, !dbg !245
  %r37 = ptrtoint ptr %r37.p to i64, !dbg !245
  %r38 = call i64 @nova_rt_contains(i64 %r36, i64 %r37), !dbg !245
  %br_then565 = icmp ne i64 %r38, 0, !dbg !245
  br i1 %br_then565, label %then56, label %else57, !dbg !245
then56:
  %r39 = load i64, ptr %slot.d, align 8, !dbg !245
  %r40.p = getelementptr inbounds [6 x i8], ptr @.str.13, i64 0, i64 0, !dbg !245
  %r40 = ptrtoint ptr %r40.p to i64, !dbg !245
  %r41 = call i64 @nova_rt_dict_get(i64 %r39, i64 %r40), !dbg !245
  store i64 %r41, ptr %slot._fdraw_minor, align 8, !dbg !245
  %r42 = add i64 %r41, 0, !dbg !245
  %r43.p = getelementptr inbounds [1 x i8], ptr @.str.20, i64 0, i64 0, !dbg !245
  %r43 = ptrtoint ptr %r43.p to i64, !dbg !245
  %r44 = call i64 @nova_rt_neq(i64 %r42, i64 %r43), !dbg !245
  %br_then596 = icmp ne i64 %r44, 0, !dbg !245
  br i1 %br_then596, label %then59, label %else60, !dbg !245
then59:
  %r45 = load i64, ptr %slot._fdraw_minor, align 8, !dbg !245
  %r46 = call i64 @nova_rt_parse_int_safe(i64 %r45), !dbg !245
  %r47.ptr = inttoptr i64 %r46 to ptr, !dbg !245
  %r47.gep = getelementptr i64, ptr %r47.ptr, i64 0, !dbg !245
  %r47 = load i64, ptr %r47.gep, align 8, !dbg !245
  %r48 = add i64 0, 0, !dbg !245
  %r49.cmp = icmp eq i64 %r47, %r48, !dbg !245
  %r49 = zext i1 %r49.cmp to i64, !dbg !245
  %br_marm_0637 = icmp ne i64 %r49, 0, !dbg !245
  br i1 %br_marm_0637, label %marm_063, label %mchk_165, !dbg !245
marm_063:
  %r50.ptr = inttoptr i64 %r46 to ptr, !dbg !245
  %r50.gep = getelementptr i64, ptr %r50.ptr, i64 1, !dbg !245
  %r50 = load i64, ptr %r50.gep, align 8, !dbg !245
  store i64 %r50, ptr %slot._fdv_minor, align 8, !dbg !245
  %r51 = add i64 %r50, 0, !dbg !245
  store i64 %r51, ptr %slot._fd_minor, align 8, !dbg !245
  br label %match_exit62, !dbg !245
mchk_165:
  %r52 = add i64 1, 0, !dbg !245
  %r53.cmp = icmp eq i64 %r47, %r52, !dbg !245
  %r53 = zext i1 %r53.cmp to i64, !dbg !245
  %br_marm_1648 = icmp ne i64 %r53, 0, !dbg !245
  br i1 %br_marm_1648, label %marm_164, label %match_fall66, !dbg !245
marm_164:
  %r54.ptr = inttoptr i64 %r46 to ptr, !dbg !245
  %r54.gep = getelementptr i64, ptr %r54.ptr, i64 1, !dbg !245
  %r54 = load i64, ptr %r54.gep, align 8, !dbg !245
  store i64 %r54, ptr %slot._fde_minor, align 8, !dbg !245
  %r55.p = getelementptr inbounds [16 x i8], ptr @.str.22, i64 0, i64 0, !dbg !245
  %r55 = ptrtoint ptr %r55.p to i64, !dbg !245
  %r56 = add i64 %r54, 0, !dbg !245
  %r57 = call i64 @nova_rt_str_concat(i64 %r55, i64 %r56), !dbg !245
  %r58 = call i64 @nova_rt_err(i64 %r57), !dbg !245
  ret i64 %r58, !dbg !245
match_fall66:
  br label %match_exit62, !dbg !245
match_exit62:
  br label %endif61, !dbg !245
else60:
  br label %endif61, !dbg !245
endif61:
  br label %endif58, !dbg !245
else57:
  br label %endif58, !dbg !245
endif58:
  %r60 = add i64 0, 0, !dbg !245
  %r59 = call i64 @nova_rt_list_create(), !dbg !245
  call i64 @nova_rt_list_append(i64 %r59, i64 %r60), !dbg !245
  %r61 = add i64 0, 0, !dbg !245
  %r62 = call i64 @nova_rt_list_get(i64 %r59, i64 %r61), !dbg !245
  store i64 %r62, ptr %slot._fd_patch, align 8, !dbg !245
  %r63 = load i64, ptr %slot.d, align 8, !dbg !245
  %r64.p = getelementptr inbounds [6 x i8], ptr @.str.14, i64 0, i64 0, !dbg !245
  %r64 = ptrtoint ptr %r64.p to i64, !dbg !245
  %r65 = call i64 @nova_rt_contains(i64 %r63, i64 %r64), !dbg !245
  %br_then679 = icmp ne i64 %r65, 0, !dbg !245
  br i1 %br_then679, label %then67, label %else68, !dbg !245
then67:
  %r66 = load i64, ptr %slot.d, align 8, !dbg !245
  %r67.p = getelementptr inbounds [6 x i8], ptr @.str.14, i64 0, i64 0, !dbg !245
  %r67 = ptrtoint ptr %r67.p to i64, !dbg !245
  %r68 = call i64 @nova_rt_dict_get(i64 %r66, i64 %r67), !dbg !245
  store i64 %r68, ptr %slot._fdraw_patch, align 8, !dbg !245
  %r69 = add i64 %r68, 0, !dbg !245
  %r70.p = getelementptr inbounds [1 x i8], ptr @.str.20, i64 0, i64 0, !dbg !245
  %r70 = ptrtoint ptr %r70.p to i64, !dbg !245
  %r71 = call i64 @nova_rt_neq(i64 %r69, i64 %r70), !dbg !245
  %br_then7010 = icmp ne i64 %r71, 0, !dbg !245
  br i1 %br_then7010, label %then70, label %else71, !dbg !245
then70:
  %r72 = load i64, ptr %slot._fdraw_patch, align 8, !dbg !245
  %r73 = call i64 @nova_rt_parse_int_safe(i64 %r72), !dbg !245
  %r74.ptr = inttoptr i64 %r73 to ptr, !dbg !245
  %r74.gep = getelementptr i64, ptr %r74.ptr, i64 0, !dbg !245
  %r74 = load i64, ptr %r74.gep, align 8, !dbg !245
  %r75 = add i64 0, 0, !dbg !245
  %r76.cmp = icmp eq i64 %r74, %r75, !dbg !245
  %r76 = zext i1 %r76.cmp to i64, !dbg !245
  %br_marm_07411 = icmp ne i64 %r76, 0, !dbg !245
  br i1 %br_marm_07411, label %marm_074, label %mchk_176, !dbg !245
marm_074:
  %r77.ptr = inttoptr i64 %r73 to ptr, !dbg !245
  %r77.gep = getelementptr i64, ptr %r77.ptr, i64 1, !dbg !245
  %r77 = load i64, ptr %r77.gep, align 8, !dbg !245
  store i64 %r77, ptr %slot._fdv_patch, align 8, !dbg !245
  %r78 = add i64 %r77, 0, !dbg !245
  store i64 %r78, ptr %slot._fd_patch, align 8, !dbg !245
  br label %match_exit73, !dbg !245
mchk_176:
  %r79 = add i64 1, 0, !dbg !245
  %r80.cmp = icmp eq i64 %r74, %r79, !dbg !245
  %r80 = zext i1 %r80.cmp to i64, !dbg !245
  %br_marm_17512 = icmp ne i64 %r80, 0, !dbg !245
  br i1 %br_marm_17512, label %marm_175, label %match_fall77, !dbg !245
marm_175:
  %r81.ptr = inttoptr i64 %r73 to ptr, !dbg !245
  %r81.gep = getelementptr i64, ptr %r81.ptr, i64 1, !dbg !245
  %r81 = load i64, ptr %r81.gep, align 8, !dbg !245
  store i64 %r81, ptr %slot._fde_patch, align 8, !dbg !245
  %r82.p = getelementptr inbounds [16 x i8], ptr @.str.23, i64 0, i64 0, !dbg !245
  %r82 = ptrtoint ptr %r82.p to i64, !dbg !245
  %r83 = add i64 %r81, 0, !dbg !245
  %r84 = call i64 @nova_rt_str_concat(i64 %r82, i64 %r83), !dbg !245
  %r85 = call i64 @nova_rt_err(i64 %r84), !dbg !245
  ret i64 %r85, !dbg !245
match_fall77:
  br label %match_exit73, !dbg !245
match_exit73:
  br label %endif72, !dbg !245
else71:
  br label %endif72, !dbg !245
endif72:
  br label %endif69, !dbg !245
else68:
  br label %endif69, !dbg !245
endif69:
  %r86 = load i64, ptr %slot._fd_major, align 8, !dbg !245
  %r87 = load i64, ptr %slot._fd_minor, align 8, !dbg !245
  %r88 = load i64, ptr %slot._fd_patch, align 8, !dbg !245
  %r89.ptr = call ptr @nova_rt_hashed_struct_alloc(i64 32), !dbg !245
  %r89.thash = getelementptr i64, ptr %r89.ptr, i64 0, !dbg !245
  store i64 6952761171063, ptr %r89.thash, align 8, !dbg !245
  %r89.f0 = getelementptr i64, ptr %r89.ptr, i64 1, !dbg !245
  store i64 %r86, ptr %r89.f0, align 8, !dbg !245
  %r89.f1 = getelementptr i64, ptr %r89.ptr, i64 2, !dbg !245
  store i64 %r87, ptr %r89.f1, align 8, !dbg !245
  %r89.f2 = getelementptr i64, ptr %r89.ptr, i64 3, !dbg !245
  store i64 %r88, ptr %r89.f2, align 8, !dbg !245
  %r89 = ptrtoint ptr %r89.ptr to i64, !dbg !245
  %r90 = call i64 @nova_rt_ok(i64 %r89), !dbg !245
  ret i64 %r90, !dbg !245
}

; ESCAPE SemVer__from_dict_list: allocs=1 escape=1 local=0
define i64 @SemVer__from_dict_list(i64 %p0) nounwind uwtable !dbg !246 {
entry:
  %slot.rows = alloca i64, align 8, !dbg !247
  store i64 %p0, ptr %slot.rows, align 8, !dbg !247
  %slot.out = alloca i64, align 8, !dbg !247
  store i64 0, ptr %slot.out, align 8, !dbg !247
  %slot.__for_idx_78 = alloca i64, align 8, !dbg !247
  store i64 0, ptr %slot.__for_idx_78, align 8, !dbg !247
  %slot.r = alloca i64, align 8, !dbg !247
  store i64 0, ptr %slot.r, align 8, !dbg !247
  %slot.one = alloca i64, align 8, !dbg !247
  store i64 0, ptr %slot.one, align 8, !dbg !247
  %r0 = call i64 @nova_rt_list_create(), !dbg !248
  store i64 %r0, ptr %slot.out, align 8, !dbg !248
  %r1 = load i64, ptr %slot.rows, align 8, !dbg !248
  %r2 = add i64 %r1, 0, !dbg !248
  %r3.lp = inttoptr i64 %r2 to ptr, !dbg !248
  %r3.szp = getelementptr i64, ptr %r3.lp, i64 1, !dbg !248
  %r3 = load i64, ptr %r3.szp, align 8, !tbaa !6, !dbg !248
  %r4 = add i64 0, 0, !dbg !248
  store i64 %r4, ptr %slot.__for_idx_78, align 8, !dbg !248
  br label %for_hdr78, !dbg !248
for_hdr78:
  %r5 = load i64, ptr %slot.__for_idx_78, align 8, !dbg !248
  %r6.cmp = icmp slt i64 %r5, %r3, !dbg !248
  %r6 = zext i1 %r6.cmp to i64, !dbg !248
  %br_for_body790 = icmp ne i64 %r6, 0, !dbg !248
  br i1 %br_for_body790, label %for_body79, label %for_exit81, !prof !90, !dbg !248
for_body79:
  %r7 = call i64 @nova_rt_list_get(i64 %r2, i64 %r5), !dbg !248
  store i64 %r7, ptr %slot.r, align 8, !dbg !248
  %r8 = add i64 %r7, 0, !dbg !248
  %r9 = call i64 @SemVer__from_dict(i64 %r8), !dbg !248
  store i64 %r9, ptr %slot.one, align 8, !dbg !248
  %r10 = add i64 %r9, 0, !dbg !248
  %r11 = call i64 @nova_rt_is_ok(i64 %r10), !dbg !248
  %br_then821 = icmp ne i64 %r11, 0, !dbg !248
  br i1 %br_then821, label %then82, label %else83, !dbg !248
then82:
  %r12 = load i64, ptr %slot.out, align 8, !dbg !248
  %r13 = load i64, ptr %slot.one, align 8, !dbg !248
  %r14 = call i64 @nova_rt_unwrap(i64 %r13), !dbg !248
  %r15 = call i64 @nova_rt_list_append(i64 %r12, i64 %r14), !dbg !248
  br label %endif84, !dbg !248
else83:
  br label %endif84, !dbg !248
endif84:
  br label %for_inc80, !dbg !248
for_inc80:
  %r16 = load i64, ptr %slot.__for_idx_78, align 8, !dbg !248
  %r17 = add i64 1, 0, !dbg !248
  %r18 = add i64 %r16, %r17, !dbg !248
  store i64 %r18, ptr %slot.__for_idx_78, align 8, !dbg !248
  br label %for_hdr78, !dbg !248
for_exit81:
  %r19 = load i64, ptr %slot.out, align 8, !dbg !248
  ret i64 %r19, !dbg !248
}

; ESCAPE SemVer__fields: allocs=1 escape=1 local=0
define i64 @SemVer__fields(i64 %p0) nounwind uwtable !dbg !249 {
entry:
  %slot.self = alloca i64, align 8, !dbg !250
  store i64 %p0, ptr %slot.self, align 8, !dbg !250
  %r1.p = getelementptr inbounds [6 x i8], ptr @.str.12, i64 0, i64 0, !dbg !251
  %r1 = ptrtoint ptr %r1.p to i64, !dbg !251
  %r2.p = getelementptr inbounds [6 x i8], ptr @.str.13, i64 0, i64 0, !dbg !251
  %r2 = ptrtoint ptr %r2.p to i64, !dbg !251
  %r3.p = getelementptr inbounds [6 x i8], ptr @.str.14, i64 0, i64 0, !dbg !251
  %r3 = ptrtoint ptr %r3.p to i64, !dbg !251
  %r0 = call i64 @nova_rt_list_create(), !dbg !251
  call i64 @nova_rt_list_append(i64 %r0, i64 %r1), !dbg !251
  call i64 @nova_rt_list_append(i64 %r0, i64 %r2), !dbg !251
  call i64 @nova_rt_list_append(i64 %r0, i64 %r3), !dbg !251
  ret i64 %r0, !dbg !251
}

; ESCAPE SemVer__type_name: allocs=0 escape=0 local=0
define i64 @SemVer__type_name(i64 %p0) nounwind uwtable !dbg !252 {
entry:
  %slot.self = alloca i64, align 8, !dbg !253
  store i64 %p0, ptr %slot.self, align 8, !dbg !253
  %r0.p = getelementptr inbounds [7 x i8], ptr @.str.24, i64 0, i64 0, !dbg !254
  %r0 = ptrtoint ptr %r0.p to i64, !dbg !254
  ret i64 %r0, !dbg !254
}

; ESCAPE SemVer__field_types: allocs=1 escape=1 local=0
define i64 @SemVer__field_types(i64 %p0) nounwind uwtable !dbg !255 {
entry:
  %slot.self = alloca i64, align 8, !dbg !256
  store i64 %p0, ptr %slot.self, align 8, !dbg !256
  %r1.p = getelementptr inbounds [4 x i8], ptr @.str.16, i64 0, i64 0, !dbg !257
  %r1 = ptrtoint ptr %r1.p to i64, !dbg !257
  %r2.p = getelementptr inbounds [4 x i8], ptr @.str.16, i64 0, i64 0, !dbg !257
  %r2 = ptrtoint ptr %r2.p to i64, !dbg !257
  %r3.p = getelementptr inbounds [4 x i8], ptr @.str.16, i64 0, i64 0, !dbg !257
  %r3 = ptrtoint ptr %r3.p to i64, !dbg !257
  %r0 = call i64 @nova_rt_list_create(), !dbg !257
  call i64 @nova_rt_list_append(i64 %r0, i64 %r1), !dbg !257
  call i64 @nova_rt_list_append(i64 %r0, i64 %r2), !dbg !257
  call i64 @nova_rt_list_append(i64 %r0, i64 %r3), !dbg !257
  ret i64 %r0, !dbg !257
}

; ESCAPE SemVer__field_names: allocs=1 escape=1 local=0
define i64 @SemVer__field_names(i64 %p0) nounwind uwtable !dbg !258 {
entry:
  %slot.self = alloca i64, align 8, !dbg !259
  store i64 %p0, ptr %slot.self, align 8, !dbg !259
  %r1.p = getelementptr inbounds [6 x i8], ptr @.str.12, i64 0, i64 0, !dbg !260
  %r1 = ptrtoint ptr %r1.p to i64, !dbg !260
  %r2.p = getelementptr inbounds [6 x i8], ptr @.str.13, i64 0, i64 0, !dbg !260
  %r2 = ptrtoint ptr %r2.p to i64, !dbg !260
  %r3.p = getelementptr inbounds [6 x i8], ptr @.str.14, i64 0, i64 0, !dbg !260
  %r3 = ptrtoint ptr %r3.p to i64, !dbg !260
  %r0 = call i64 @nova_rt_list_create(), !dbg !260
  call i64 @nova_rt_list_append(i64 %r0, i64 %r1), !dbg !260
  call i64 @nova_rt_list_append(i64 %r0, i64 %r2), !dbg !260
  call i64 @nova_rt_list_append(i64 %r0, i64 %r3), !dbg !260
  ret i64 %r0, !dbg !260
}

; ESCAPE SemVer__field_get: allocs=1 escape=0 local=1
define i64 @SemVer__field_get(i64 %p0, i64 %p1) nounwind uwtable !dbg !261 {
entry:
  %slot.self = alloca i64, align 8, !dbg !262
  store i64 %p0, ptr %slot.self, align 8, !dbg !262
  %slot.name = alloca i64, align 8, !dbg !262
  store i64 %p1, ptr %slot.name, align 8, !dbg !262
  %slot._fg_box = alloca i64, align 8, !dbg !262
  store i64 0, ptr %slot._fg_box, align 8, !dbg !262
  %r0 = call i64 @nova_rt_list_create(), !dbg !263
  store i64 %r0, ptr %slot._fg_box, align 8, !dbg !263
  %r1 = load i64, ptr %slot.name, align 8, !dbg !263
  %r2.p = getelementptr inbounds [6 x i8], ptr @.str.12, i64 0, i64 0, !dbg !263
  %r2 = ptrtoint ptr %r2.p to i64, !dbg !263
  %r3.p0 = inttoptr i64 %r1 to ptr, !dbg !263
  %r3.p1 = inttoptr i64 %r2 to ptr, !dbg !263
  %r3.sc = call i32 @strcmp(ptr %r3.p0, ptr %r3.p1), !dbg !263
  %r3.cmp = icmp eq i32 %r3.sc, 0, !dbg !263
  %r3 = zext i1 %r3.cmp to i64, !dbg !263
  %br_then850 = icmp ne i64 %r3, 0, !dbg !263
  br i1 %br_then850, label %then85, label %else86, !dbg !263
then85:
  %r4 = load i64, ptr %slot._fg_box, align 8, !dbg !263
  %r5 = load i64, ptr %slot.self, align 8, !dbg !263
  %r6.ptr = inttoptr i64 %r5 to ptr, !dbg !263
  %r6.gep = getelementptr i64, ptr %r6.ptr, i64 1, !dbg !263
  %r6 = load i64, ptr %r6.gep, align 8, !dbg !263
  %r7 = call i64 @nova_rt_list_append_no_rc(i64 %r4, i64 %r6), !dbg !263
  %r8 = load i64, ptr %slot._fg_box, align 8, !dbg !263
  %r9 = add i64 0, 0, !dbg !263
  %r10 = call i64 @nova_rt_list_get(i64 %r8, i64 %r9), !dbg !263
  %dl._fg_box1 = load i64, ptr %slot._fg_box, align 8, !dbg !262
  call i64 @nova_rt_list_free_local(i64 %dl._fg_box1), !dbg !262
  ret i64 %r10, !dbg !263
else86:
  br label %endif87, !dbg !263
endif87:
  %r11 = load i64, ptr %slot.name, align 8, !dbg !263
  %r12.p = getelementptr inbounds [6 x i8], ptr @.str.13, i64 0, i64 0, !dbg !263
  %r12 = ptrtoint ptr %r12.p to i64, !dbg !263
  %r13.p0 = inttoptr i64 %r11 to ptr, !dbg !263
  %r13.p1 = inttoptr i64 %r12 to ptr, !dbg !263
  %r13.sc = call i32 @strcmp(ptr %r13.p0, ptr %r13.p1), !dbg !263
  %r13.cmp = icmp eq i32 %r13.sc, 0, !dbg !263
  %r13 = zext i1 %r13.cmp to i64, !dbg !263
  %br_then882 = icmp ne i64 %r13, 0, !dbg !263
  br i1 %br_then882, label %then88, label %else89, !dbg !263
then88:
  %r14 = load i64, ptr %slot._fg_box, align 8, !dbg !263
  %r15 = load i64, ptr %slot.self, align 8, !dbg !263
  %r16.ptr = inttoptr i64 %r15 to ptr, !dbg !263
  %r16.gep = getelementptr i64, ptr %r16.ptr, i64 2, !dbg !263
  %r16 = load i64, ptr %r16.gep, align 8, !dbg !263
  %r17 = call i64 @nova_rt_list_append_no_rc(i64 %r14, i64 %r16), !dbg !263
  %r18 = load i64, ptr %slot._fg_box, align 8, !dbg !263
  %r19 = add i64 0, 0, !dbg !263
  %r20 = call i64 @nova_rt_list_get(i64 %r18, i64 %r19), !dbg !263
  ret i64 %r20, !dbg !263
else89:
  br label %endif90, !dbg !263
endif90:
  %r21 = load i64, ptr %slot.name, align 8, !dbg !263
  %r22.p = getelementptr inbounds [6 x i8], ptr @.str.14, i64 0, i64 0, !dbg !263
  %r22 = ptrtoint ptr %r22.p to i64, !dbg !263
  %r23.p0 = inttoptr i64 %r21 to ptr, !dbg !263
  %r23.p1 = inttoptr i64 %r22 to ptr, !dbg !263
  %r23.sc = call i32 @strcmp(ptr %r23.p0, ptr %r23.p1), !dbg !263
  %r23.cmp = icmp eq i32 %r23.sc, 0, !dbg !263
  %r23 = zext i1 %r23.cmp to i64, !dbg !263
  %br_then913 = icmp ne i64 %r23, 0, !dbg !263
  br i1 %br_then913, label %then91, label %else92, !dbg !263
then91:
  %r24 = load i64, ptr %slot._fg_box, align 8, !dbg !263
  %r25 = load i64, ptr %slot.self, align 8, !dbg !263
  %r26.ptr = inttoptr i64 %r25 to ptr, !dbg !263
  %r26.gep = getelementptr i64, ptr %r26.ptr, i64 3, !dbg !263
  %r26 = load i64, ptr %r26.gep, align 8, !dbg !263
  %r27 = call i64 @nova_rt_list_append_no_rc(i64 %r24, i64 %r26), !dbg !263
  %r28 = load i64, ptr %slot._fg_box, align 8, !dbg !263
  %r29 = add i64 0, 0, !dbg !263
  %r30 = call i64 @nova_rt_list_get(i64 %r28, i64 %r29), !dbg !263
  ret i64 %r30, !dbg !263
else92:
  br label %endif93, !dbg !263
endif93:
  %r31 = add i64 0, 0, !dbg !263
  ret i64 %r31, !dbg !263
}

; ESCAPE nova_main: allocs=0 escape=0 local=0
define i64 @nova_main() nounwind uwtable {
entry:
  ret i64 0
}

; ESCAPE SUMMARY: allocs=17 escape=7 local=10 (58% local, RC-elidable)
define i32 @main(i32 %argc, ptr %argv) nounwind uwtable {
entry:
  %argc64 = sext i32 %argc to i64
  %argv64 = ptrtoint ptr %argv to i64
  call void @nova_rt_init_args(i64 %argc64, i64 %argv64)
  ; RTTI: register struct type names + field metadata (hash-keyed, for json/show through any)
  %sreg.p0 = getelementptr inbounds [7 x i8], ptr @.str.24, i64 0, i64 0
  %sreg.pi0 = ptrtoint ptr %sreg.p0 to i64
  call void @nova_rt_register_struct_name(i64 6952761171063, i64 %sreg.pi0)
  call void @nova_rt_register_struct_meta(i64 6952761171063, i64 %sreg.pi0, i64 3)
  %sfld.n0 = getelementptr inbounds [6 x i8], ptr @.str.12, i64 0, i64 0
  %sfld.ni0 = ptrtoint ptr %sfld.n0 to i64
  %sfld.t0 = getelementptr inbounds [4 x i8], ptr @.str.16, i64 0, i64 0
  %sfld.ti0 = ptrtoint ptr %sfld.t0 to i64
  call void @nova_rt_register_struct_field(i64 6952761171063, i64 0, i64 %sfld.ni0, i64 %sfld.ti0)
  %sfld.n1 = getelementptr inbounds [6 x i8], ptr @.str.13, i64 0, i64 0
  %sfld.ni1 = ptrtoint ptr %sfld.n1 to i64
  %sfld.t1 = getelementptr inbounds [4 x i8], ptr @.str.16, i64 0, i64 0
  %sfld.ti1 = ptrtoint ptr %sfld.t1 to i64
  call void @nova_rt_register_struct_field(i64 6952761171063, i64 1, i64 %sfld.ni1, i64 %sfld.ti1)
  %sfld.n2 = getelementptr inbounds [6 x i8], ptr @.str.14, i64 0, i64 0
  %sfld.ni2 = ptrtoint ptr %sfld.n2 to i64
  %sfld.t2 = getelementptr inbounds [4 x i8], ptr @.str.16, i64 0, i64 0
  %sfld.ti2 = ptrtoint ptr %sfld.t2 to i64
  call void @nova_rt_register_struct_field(i64 6952761171063, i64 2, i64 %sfld.ni2, i64 %sfld.ti2)
  call void @nova_rt_main_dispatch(i64 ptrtoint (ptr @nova_main to i64))
  call void @nova_rt_wait_all()
  call void @nova_rt_cleanup()
  ret i32 0
}

; String constants
@.str.0 = private unnamed_addr constant [2 x i8] c".\00"
@.str.1 = private unnamed_addr constant [9 x i8] c"SemVer {\00"
@.str.2 = private unnamed_addr constant [9 x i8] c" major: \00"
@.str.3 = private unnamed_addr constant [10 x i8] c", minor: \00"
@.str.4 = private unnamed_addr constant [10 x i8] c", patch: \00"
@.str.5 = private unnamed_addr constant [3 x i8] c" }\00"
@.str.6 = private unnamed_addr constant [2 x i8] c"{\00"
@.str.7 = private unnamed_addr constant [9 x i8] c"\22major\22:\00"
@.str.8 = private unnamed_addr constant [10 x i8] c",\22minor\22:\00"
@.str.9 = private unnamed_addr constant [10 x i8] c",\22patch\22:\00"
@.str.10 = private unnamed_addr constant [2 x i8] c"}\00"
@.str.11 = private unnamed_addr constant [5 x i8] c"dict\00"
@.str.12 = private unnamed_addr constant [6 x i8] c"major\00"
@.str.13 = private unnamed_addr constant [6 x i8] c"minor\00"
@.str.14 = private unnamed_addr constant [6 x i8] c"patch\00"
@.str.15 = private unnamed_addr constant [34 x i8] c"expected a JSON object for SemVer\00"
@.str.16 = private unnamed_addr constant [4 x i8] c"int\00"
@.str.17 = private unnamed_addr constant [34 x i8] c"field 'major': expected int, got \00"
@.str.18 = private unnamed_addr constant [34 x i8] c"field 'minor': expected int, got \00"
@.str.19 = private unnamed_addr constant [34 x i8] c"field 'patch': expected int, got \00"
@.str.20 = private unnamed_addr constant [1 x i8] c"\00"
@.str.21 = private unnamed_addr constant [16 x i8] c"field 'major': \00"
@.str.22 = private unnamed_addr constant [16 x i8] c"field 'minor': \00"
@.str.23 = private unnamed_addr constant [16 x i8] c"field 'patch': \00"
@.str.24 = private unnamed_addr constant [7 x i8] c"SemVer\00"

; Debug metadata
!llvm.dbg.cu = !{!100}
!llvm.module.flags = !{!102, !103}

!100 = distinct !DICompileUnit(language: DW_LANG_C99, file: !101, producer: "NOVA Compiler", isOptimized: false, emissionKind: LineTablesOnly)
!101 = !DIFile(filename: "packages/pkg-semver/semver.nova", directory: ".")
!102 = !{i32 2, !"CodeView", i32 1}
!103 = !{i32 2, !"Debug Info Version", i32 3}
!104 = !DISubroutineType(types: !105)
!105 = !{null}
!200 = distinct !DISubprogram(name: "semver_parse", scope: !101, file: !101, line: 6, type: !104, scopeLine: 6, spFlags: DISPFlagDefinition, unit: !100)
!201 = !DILocation(line: 6, column: 0, scope: !200)
!206 = distinct !DISubprogram(name: "semver_str", scope: !101, file: !101, line: 12, type: !104, scopeLine: 12, spFlags: DISPFlagDefinition, unit: !100)
!207 = !DILocation(line: 12, column: 0, scope: !206)
!209 = distinct !DISubprogram(name: "semver_cmp", scope: !101, file: !101, line: 15, type: !104, scopeLine: 15, spFlags: DISPFlagDefinition, unit: !100)
!210 = !DILocation(line: 15, column: 0, scope: !209)
!216 = distinct !DISubprogram(name: "semver_gt", scope: !101, file: !101, line: 22, type: !104, scopeLine: 22, spFlags: DISPFlagDefinition, unit: !100)
!217 = !DILocation(line: 22, column: 0, scope: !216)
!219 = distinct !DISubprogram(name: "semver_gte", scope: !101, file: !101, line: 25, type: !104, scopeLine: 25, spFlags: DISPFlagDefinition, unit: !100)
!220 = !DILocation(line: 25, column: 0, scope: !219)
!222 = distinct !DISubprogram(name: "semver_lt", scope: !101, file: !101, line: 28, type: !104, scopeLine: 28, spFlags: DISPFlagDefinition, unit: !100)
!223 = !DILocation(line: 28, column: 0, scope: !222)
!225 = distinct !DISubprogram(name: "semver_eq", scope: !101, file: !101, line: 31, type: !104, scopeLine: 31, spFlags: DISPFlagDefinition, unit: !100)
!226 = !DILocation(line: 31, column: 0, scope: !225)
!228 = distinct !DISubprogram(name: "semver_compatible", scope: !101, file: !101, line: 34, type: !104, scopeLine: 34, spFlags: DISPFlagDefinition, unit: !100)
!229 = !DILocation(line: 34, column: 0, scope: !228)
!231 = distinct !DISubprogram(name: "SemVer__show", scope: !101, file: !101, line: 1, type: !104, scopeLine: 1, spFlags: DISPFlagDefinition, unit: !100)
!232 = !DILocation(line: 1, column: 0, scope: !231)
!234 = distinct !DISubprogram(name: "SemVer__to_json", scope: !101, file: !101, line: 1, type: !104, scopeLine: 1, spFlags: DISPFlagDefinition, unit: !100)
!235 = !DILocation(line: 1, column: 0, scope: !234)
!237 = distinct !DISubprogram(name: "SemVer__from_json", scope: !101, file: !101, line: 1, type: !104, scopeLine: 1, spFlags: DISPFlagDefinition, unit: !100)
!238 = !DILocation(line: 1, column: 0, scope: !237)
!240 = distinct !DISubprogram(name: "SemVer__from_json_safe", scope: !101, file: !101, line: 1, type: !104, scopeLine: 1, spFlags: DISPFlagDefinition, unit: !100)
!241 = !DILocation(line: 1, column: 0, scope: !240)
!243 = distinct !DISubprogram(name: "SemVer__from_dict", scope: !101, file: !101, line: 1, type: !104, scopeLine: 1, spFlags: DISPFlagDefinition, unit: !100)
!244 = !DILocation(line: 1, column: 0, scope: !243)
!246 = distinct !DISubprogram(name: "SemVer__from_dict_list", scope: !101, file: !101, line: 1, type: !104, scopeLine: 1, spFlags: DISPFlagDefinition, unit: !100)
!247 = !DILocation(line: 1, column: 0, scope: !246)
!249 = distinct !DISubprogram(name: "SemVer__fields", scope: !101, file: !101, line: 1, type: !104, scopeLine: 1, spFlags: DISPFlagDefinition, unit: !100)
!250 = !DILocation(line: 1, column: 0, scope: !249)
!252 = distinct !DISubprogram(name: "SemVer__type_name", scope: !101, file: !101, line: 1, type: !104, scopeLine: 1, spFlags: DISPFlagDefinition, unit: !100)
!253 = !DILocation(line: 1, column: 0, scope: !252)
!255 = distinct !DISubprogram(name: "SemVer__field_types", scope: !101, file: !101, line: 1, type: !104, scopeLine: 1, spFlags: DISPFlagDefinition, unit: !100)
!256 = !DILocation(line: 1, column: 0, scope: !255)
!258 = distinct !DISubprogram(name: "SemVer__field_names", scope: !101, file: !101, line: 1, type: !104, scopeLine: 1, spFlags: DISPFlagDefinition, unit: !100)
!259 = !DILocation(line: 1, column: 0, scope: !258)
!261 = distinct !DISubprogram(name: "SemVer__field_get", scope: !101, file: !101, line: 1, type: !104, scopeLine: 1, spFlags: DISPFlagDefinition, unit: !100)
!262 = !DILocation(line: 1, column: 0, scope: !261)
!202 = !DILocation(line: 7, column: 0, scope: !200)
!203 = !DILocation(line: 8, column: 0, scope: !200)
!204 = !DILocation(line: 9, column: 0, scope: !200)
!205 = !DILocation(line: 10, column: 0, scope: !200)
!208 = !DILocation(line: 13, column: 0, scope: !206)
!211 = !DILocation(line: 16, column: 0, scope: !209)
!212 = !DILocation(line: 17, column: 0, scope: !209)
!213 = !DILocation(line: 18, column: 0, scope: !209)
!214 = !DILocation(line: 19, column: 0, scope: !209)
!215 = !DILocation(line: 20, column: 0, scope: !209)
!218 = !DILocation(line: 23, column: 0, scope: !216)
!221 = !DILocation(line: 26, column: 0, scope: !219)
!224 = !DILocation(line: 29, column: 0, scope: !222)
!227 = !DILocation(line: 32, column: 0, scope: !225)
!230 = !DILocation(line: 35, column: 0, scope: !228)
!233 = !DILocation(line: 1, column: 0, scope: !231)
!236 = !DILocation(line: 1, column: 0, scope: !234)
!239 = !DILocation(line: 1, column: 0, scope: !237)
!242 = !DILocation(line: 1, column: 0, scope: !240)
!245 = !DILocation(line: 1, column: 0, scope: !243)
!248 = !DILocation(line: 1, column: 0, scope: !246)
!251 = !DILocation(line: 1, column: 0, scope: !249)
!254 = !DILocation(line: 1, column: 0, scope: !252)
!257 = !DILocation(line: 1, column: 0, scope: !255)
!260 = !DILocation(line: 1, column: 0, scope: !258)
!263 = !DILocation(line: 1, column: 0, scope: !261)

; TBAA metadata
!0 = !{!"NOVA TBAA"}
!1 = !{!"list_data_ptr", !0}
!2 = !{!1, !1, i64 0}
!3 = !{!"list_elem", !0}
!4 = !{!3, !3, i64 0}
!5 = !{!"list_size", !0}
!6 = !{!5, !5, i64 0}
!90 = !{!"branch_weights", i32 2000, i32 1}
