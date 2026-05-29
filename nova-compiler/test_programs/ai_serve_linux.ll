; NOVA IR-Pipeline Compiler Output
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@__nova_error_flag = thread_local global i64 0
@__nova_error_msg = thread_local global i64 0

; Runtime declarations
declare i32 @puts(ptr) nounwind
declare i32 @printf(ptr, ...) nounwind
declare i32 @strcmp(ptr, ptr) nounwind readonly
declare i64 @nova_rt_list_create() nounwind
declare i64 @nova_rt_deep_copy(i64) nounwind
declare i64 @nova_rt_list_create_filled(i64, i64) nounwind
declare i64 @nova_rt_list_append(i64, i64) nounwind
declare i64 @nova_rt_list_append_fbox(i64, i64) nounwind
declare i64 @nova_rt_list_append_bbox(i64, i64) nounwind
declare i64 @nova_rt_box_bool(i64) nounwind
declare i64 @nova_rt_unbox(i64) nounwind
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
declare i64 @nova_rt_parse_int(i64) nounwind readonly
declare i64 @nova_rt_len(i64) nounwind readonly
declare i64 @nova_rt_len_any(i64) nounwind readonly
declare i64 @nova_rt_ord(i64) nounwind readonly
declare i64 @nova_rt_chr(i64) nounwind
declare i64 @nova_rt_contains(i64, i64) nounwind readonly
declare i64 @nova_rt_index_get(i64, i64) nounwind readonly
declare i64 @nova_rt_index_set(i64, i64, i64) nounwind
declare i64 @nova_rt_add(i64, i64) nounwind
declare i64 @nova_rt_sub(i64, i64) nounwind
declare i64 @nova_rt_mul(i64, i64) nounwind
declare i64 @nova_rt_div(i64, i64) nounwind
declare i64 @nova_rt_eq(i64, i64) nounwind readonly
declare i64 @nova_rt_neq(i64, i64) nounwind readonly
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
declare i64 @nova_rt_starts_with(i64, i64) nounwind readonly
declare i64 @nova_rt_ends_with(i64, i64) nounwind readonly
declare i64 @nova_rt_print_any(i64) nounwind
declare i64 @nova_rt_print_bool(i64) nounwind
declare i64 @nova_rt_print_float(i64) nounwind
declare i64 @nova_rt_print_int(i64) nounwind
declare i64 @nova_rt_print_str(i64) nounwind
declare i64 @nova_rt_float_bits(i64) nounwind
declare i64 @nova_rt_float_to_str(i64) nounwind
declare ptr @nova_rt_struct_alloc(i64) nounwind
declare i64 @nova_rt_slice(i64, i64, i64) nounwind
declare i64 @nova_rt_slice_any(i64, i64, i64) nounwind
declare i64 @nova_rt_repeat(i64, i64) nounwind
declare i64 @nova_rt_chars(i64) nounwind
declare i64 @nova_rt_time_ms() nounwind
declare i64 @nova_rt_sleep_ms(i64) nounwind
declare i64 @nova_rt_clock_ns() nounwind
declare i64 @nova_rt_type_of(i64) nounwind
declare i64 @nova_rt_range(i64) nounwind
declare i64 @nova_rt_range_from_to(i64, i64) nounwind
declare i64 @nova_rt_dict_keys(i64) nounwind readonly
declare i64 @nova_rt_dict_values(i64) nounwind readonly
declare i64 @nova_rt_dict_items(i64) nounwind readonly
declare i64 @nova_rt_for_iter_init(i64) nounwind
declare i64 @nova_rt_dict_has(i64, i64) nounwind readonly
declare i64 @nova_rt_dict_del(i64, i64) nounwind
declare i64 @nova_rt_system(i64) nounwind
declare i64 @nova_rt_exec(i64) nounwind
declare i64 @nova_rt_shell(i64) nounwind
declare i64 @nova_rt_create_string(ptr) nounwind
declare void @nova_rt_init_args(i64, i64) nounwind
declare void @nova_rt_wait_all() nounwind
declare void @nova_rt_cleanup() nounwind
declare i64 @nova_rt_channel_create() nounwind
declare i64 @nova_rt_channel_send(i64, i64) nounwind
declare i64 @nova_rt_channel_send_move(i64, i64) nounwind
declare i64 @nova_rt_channel_recv(i64) nounwind
declare i64 @nova_rt_channel_close(i64) nounwind
declare i64 @nova_rt_channel_select(i64, i64) nounwind
declare i64 @nova_rt_select(i64) nounwind
declare i64 @nova_rt_channel_recv_timeout(i64, i64) nounwind
declare i64 @nova_rt_spawn(i64, i64) nounwind
declare i64 @nova_rt_monitor(i64) nounwind
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
declare i64 @nova_rt_list_filter(i64, i64) nounwind
declare i64 @nova_rt_http_get(i64) nounwind
declare i64 @nova_rt_http_post(i64, i64, i64) nounwind
declare i64 @nova_rt_mkdir(i64) nounwind
declare i64 @nova_rt_mkdir_p(i64) nounwind
declare i64 @nova_rt_path_join(i64, i64) nounwind
declare i64 @nova_rt_path_exists(i64) nounwind readonly
declare i64 @nova_rt_path_parent(i64) nounwind readonly
declare i64 @nova_rt_path_name(i64) nounwind readonly
declare i64 @nova_rt_read_bytes(i64) nounwind
declare i64 @nova_rt_write_raw(i64) nounwind
declare i64 @nova_rt_abs(i64) nounwind readnone
declare i64 @nova_rt_max(i64, i64) nounwind readnone
declare i64 @nova_rt_min(i64, i64) nounwind readnone
declare i64 @nova_rt_sqrt(i64) nounwind readnone
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
declare i64 @nova_rt_fmod(i64, i64) nounwind readnone
declare i64 @nova_rt_float_to_int(i64) nounwind readnone
declare i64 @nova_rt_int_to_float(i64) nounwind readnone
declare i64 @nova_rt_to_int(i64) nounwind readnone
declare i64 @nova_rt_to_float(i64) nounwind readnone
declare i64 @nova_rt_env(i64) nounwind
declare i64 @nova_rt_random_int(i64, i64) nounwind
declare i64 @nova_rt_random_float() nounwind
declare i64 @nova_rt_json_parse(i64) nounwind
declare i64 @nova_rt_json_stringify(i64) nounwind
declare i64 @nova_rt_regex_match(i64, i64) nounwind
declare i64 @nova_rt_regex_find(i64, i64) nounwind
declare i64 @nova_rt_regex_replace(i64, i64, i64) nounwind
declare i64 @nova_rt_regex_split(i64, i64) nounwind
declare i64 @nova_rt_path_ext(i64) nounwind
declare i64 @nova_rt_tcp_connect(i64, i64) nounwind
declare i64 @nova_rt_tcp_listen(i64) nounwind
declare i64 @nova_rt_tcp_accept(i64) nounwind
declare i64 @nova_rt_tcp_send(i64, i64) nounwind
declare i64 @nova_rt_tcp_recv(i64) nounwind
declare i64 @nova_rt_udp_bind(i64) nounwind
declare i64 @nova_rt_udp_send(i64, i64, i64, i64) nounwind
declare i64 @nova_rt_udp_recv(i64) nounwind
declare void @nova_rt_tcp_close(i64) nounwind
declare i64 @nova_rt_bytes_create(i64) nounwind
declare i64 @nova_rt_bytes_get(i64, i64) nounwind
declare void @nova_rt_bytes_set(i64, i64, i64) nounwind
declare i64 @nova_rt_bytes_len(i64) nounwind
declare i64 @nova_rt_bytes_slice(i64, i64, i64) nounwind
declare i64 @nova_rt_bytes_to_str(i64) nounwind
declare i64 @nova_rt_str_to_bytes(i64) nounwind
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
declare i64 @nova_rt_list_min_f(i64) nounwind readonly
declare i64 @nova_rt_list_max_f(i64) nounwind readonly
declare i64 @nova_rt_set_create() nounwind
declare i64 @nova_rt_set_add(i64, i64) nounwind
declare i64 @nova_rt_set_has(i64, i64) nounwind readonly
declare i64 @nova_rt_set_remove(i64, i64) nounwind
declare i64 @nova_rt_set_len(i64) nounwind readonly
declare i64 @nova_rt_set_to_list(i64) nounwind
declare i64 @nova_rt_sum(i64) nounwind readonly
declare i64 @nova_rt_index_of(i64, i64) nounwind readonly
declare i64 @nova_rt_sort_by(i64, i64) nounwind
declare i64 @nova_rt_dict_merge(i64, i64) nounwind
declare i64 @nova_rt_str_count(i64, i64) nounwind readonly
declare i64 @nova_rt_lstrip(i64) nounwind
declare i64 @nova_rt_rstrip(i64) nounwind
declare i64 @nova_rt_pad_left(i64, i64, i64) nounwind
declare i64 @nova_rt_pad_right(i64, i64, i64) nounwind
declare i64 @nova_rt_cwd() nounwind
declare i64 @nova_rt_list_dir(i64) nounwind
declare i64 @nova_rt_hash(i64) nounwind readnone
declare i64 @nova_rt_sha256(i64) nounwind
declare i64 @nova_rt_sha256_bytes(i64, i64) nounwind
declare i64 @nova_rt_hmac_sha256(i64, i64) nounwind
declare i64 @nova_rt_hex_encode(i64) nounwind
declare i64 @nova_rt_hex_decode(i64) nounwind
declare i64 @nova_rt_base64_encode(i64) nounwind
declare i64 @nova_rt_base64_decode(i64) nounwind
declare i64 @nova_rt_uuid4() nounwind
declare i64 @nova_rt_random_bytes(i64) nounwind
declare i64 @nova_rt_dir_walk(i64) nounwind
declare i64 @nova_rt_flatten(i64) nounwind
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
declare i64 @nova_rt_tensor_to_list(i64) nounwind
declare i64 @nova_rt_ok(i64) nounwind
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
declare i64 @nova_rt_result_and_then(i64, i64) nounwind
declare i64 @nova_rt_result_or_else(i64, i64) nounwind
declare i64 @nova_rt_format(i64, i64) nounwind
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
declare i64 @nova_rt_cstr_of(i64) nounwind
declare i64 @nova_rt_null_ptr() nounwind
declare i64 @nova_rt_is_null(i64) nounwind
declare i64 @nova_rt_ptr_read(i64) nounwind
declare void @nova_rt_ptr_write(i64, i64) nounwind
declare i64 @nova_rt_ptr_add(i64, i64) nounwind
declare i64 @nova_rt_ptr_diff(i64, i64) nounwind
declare i64 @nova_rt_memcpy_unsafe(i64, i64, i64) nounwind
declare i64 @nova_rt_memset_unsafe(i64, i64, i64) nounwind
declare i64 @nova_rt_sizeof_ptr() nounwind
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
declare i64 @nova_rt_prof_start(i64) nounwind
declare i64 @nova_rt_prof_stop(i64) nounwind
declare i64 @nova_rt_prof_report() nounwind
declare i64 @nova_rt_prof_get_ns(i64) nounwind
declare i64 @nova_rt_prof_reset() nounwind
declare i64 @nova_rt_dap_log(i64, i64) nounwind
declare i64 @nova_rt_dap_breakpoint(i64, i64) nounwind
declare i64 @nova_rt_dap_send(i64) nounwind
declare i64 @nova_rt_doc_extract(i64) nounwind
declare i64 @nova_rt_doc_to_markdown(i64, i64) nounwind
declare i64 @nova_rt_doc_to_html(i64, i64) nounwind
declare i64 @nova_rt_doc_entry_count(i64) nounwind
declare i64 @nova_rt_tls_connect(i64, i64) nounwind
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

define i64 @softmax(i64 %p0) nounwind !dbg !200 {
entry:
  %slot.xs = alloca i64, align 8, !dbg !201
  store i64 %p0, ptr %slot.xs, align 8, !dbg !201
  %slot.m = alloca i64, align 8, !dbg !201
  store i64 0, ptr %slot.m, align 8, !dbg !201
  %slot.__for_idx_0 = alloca i64, align 8, !dbg !201
  store i64 0, ptr %slot.__for_idx_0, align 8, !dbg !201
  %slot.x = alloca i64, align 8, !dbg !201
  store i64 0, ptr %slot.x, align 8, !dbg !201
  %slot.exps = alloca i64, align 8, !dbg !201
  store i64 0, ptr %slot.exps, align 8, !dbg !201
  %slot.total = alloca i64, align 8, !dbg !201
  store i64 0, ptr %slot.total, align 8, !dbg !201
  %slot.__for_idx_6 = alloca i64, align 8, !dbg !201
  store i64 0, ptr %slot.__for_idx_6, align 8, !dbg !201
  %slot.e = alloca i64, align 8, !dbg !201
  store i64 0, ptr %slot.e, align 8, !dbg !201
  %r0 = load i64, ptr %slot.xs, align 8, !dbg !202
  %r1 = add i64 0, 0, !dbg !202
  %r2.lp = inttoptr i64 %r0 to ptr, !dbg !202
  %r2.dp = load ptr, ptr %r2.lp, align 8, !tbaa !2, !dbg !202
  %r2.ep = getelementptr i64, ptr %r2.dp, i64 %r1, !dbg !202
  %r2.lv = load i64, ptr %r2.ep, align 8, !tbaa !4, !dbg !202
  %r2 = call i64 @nova_rt_unbox(i64 %r2.lv), !dbg !202
  store i64 %r2, ptr %slot.m, align 8, !dbg !202
  %r3 = load i64, ptr %slot.xs, align 8, !dbg !203
  %r4 = add i64 %r3, 0, !dbg !203
  %r5.lp = inttoptr i64 %r4 to ptr, !dbg !203
  %r5.szp = getelementptr i64, ptr %r5.lp, i64 1, !dbg !203
  %r5 = load i64, ptr %r5.szp, align 8, !tbaa !6, !dbg !203
  %r6 = add i64 0, 0, !dbg !203
  store i64 %r6, ptr %slot.__for_idx_0, align 8, !dbg !203
  br label %for_hdr0, !dbg !203
for_hdr0:
  %r7 = load i64, ptr %slot.__for_idx_0, align 8, !dbg !203
  %r8.cmp = icmp slt i64 %r7, %r5, !dbg !203
  %r8 = zext i1 %r8.cmp to i64, !dbg !203
  %br_for_body1 = icmp ne i64 %r8, 0, !dbg !203
  br i1 %br_for_body1, label %for_body1, label %for_exit2, !prof !90, !dbg !203
for_body1:
  %r9.lp = inttoptr i64 %r4 to ptr, !dbg !203
  %r9.dp = load ptr, ptr %r9.lp, align 8, !tbaa !2, !dbg !203
  %r9.ep = getelementptr i64, ptr %r9.dp, i64 %r7, !dbg !203
  %r9.lv = load i64, ptr %r9.ep, align 8, !tbaa !4, !dbg !203
  %r9 = call i64 @nova_rt_unbox(i64 %r9.lv), !dbg !203
  store i64 %r9, ptr %slot.x, align 8, !dbg !203
  %r10 = add i64 %r9, 0, !dbg !204
  %r11 = load i64, ptr %slot.m, align 8, !dbg !204
  %r12.cmp = icmp sgt i64 %r10, %r11, !dbg !204
  %r12 = zext i1 %r12.cmp to i64, !dbg !204
  %br_then3 = icmp ne i64 %r12, 0, !dbg !204
  br i1 %br_then3, label %then3, label %else4, !dbg !204
then3:
  %r13 = load i64, ptr %slot.x, align 8, !dbg !205
  store i64 %r13, ptr %slot.m, align 8, !dbg !205
  br label %endif5, !dbg !205
else4:
  br label %endif5, !dbg !205
endif5:
  %r14 = load i64, ptr %slot.__for_idx_0, align 8, !dbg !205
  %r15 = add i64 1, 0, !dbg !205
  %r16 = add i64 %r14, %r15, !dbg !205
  store i64 %r16, ptr %slot.__for_idx_0, align 8, !dbg !205
  br label %for_hdr0, !dbg !205
for_exit2:
  %r17 = load i64, ptr %slot.xs, align 8, !dbg !206
  %r18 = load i64, ptr %slot.m, align 8, !dbg !206
  %r19.ptr = call ptr @nova_rt_struct_alloc(i64 16), !dbg !206
  %r19.tgep = getelementptr i64, ptr %r19.ptr, i64 0, !dbg !206
  %r19.tfn = ptrtoint ptr @__tramp_0 to i64, !dbg !206
  store i64 %r19.tfn, ptr %r19.tgep, align 8, !dbg !206
  %r19.c0 = getelementptr i64, ptr %r19.ptr, i64 1, !dbg !206
  store i64 %r18, ptr %r19.c0, align 8, !dbg !206
  %r19 = ptrtoint ptr %r19.ptr to i64, !dbg !206
  %r20 = call i64 @nova_rt_list_map(i64 %r17, i64 %r19), !dbg !206
  store i64 %r20, ptr %slot.exps, align 8, !dbg !206
  %r21 = add i64 0, 0, !dbg !207
  store i64 %r21, ptr %slot.total, align 8, !dbg !207
  %r22 = add i64 %r20, 0, !dbg !208
  %r23 = add i64 %r22, 0, !dbg !208
  %r24.lp = inttoptr i64 %r23 to ptr, !dbg !208
  %r24.szp = getelementptr i64, ptr %r24.lp, i64 1, !dbg !208
  %r24 = load i64, ptr %r24.szp, align 8, !tbaa !6, !dbg !208
  %r25 = add i64 0, 0, !dbg !208
  store i64 %r25, ptr %slot.__for_idx_6, align 8, !dbg !208
  br label %for_hdr6, !dbg !208
for_hdr6:
  %r26 = load i64, ptr %slot.__for_idx_6, align 8, !dbg !208
  %r27.cmp = icmp slt i64 %r26, %r24, !dbg !208
  %r27 = zext i1 %r27.cmp to i64, !dbg !208
  %br_for_body7 = icmp ne i64 %r27, 0, !dbg !208
  br i1 %br_for_body7, label %for_body7, label %for_exit8, !prof !90, !dbg !208
for_body7:
  %r28 = call i64 @nova_rt_index_get(i64 %r23, i64 %r26), !dbg !208
  store i64 %r28, ptr %slot.e, align 8, !dbg !208
  %r29 = load i64, ptr %slot.total, align 8, !dbg !209
  %r30 = add i64 %r28, 0, !dbg !209
  %r31 = call i64 @nova_rt_add(i64 %r29, i64 %r30), !dbg !209
  store i64 %r31, ptr %slot.total, align 8, !dbg !209
  %r32 = load i64, ptr %slot.__for_idx_6, align 8, !dbg !209
  %r33 = add i64 1, 0, !dbg !209
  %r34 = add i64 %r32, %r33, !dbg !209
  store i64 %r34, ptr %slot.__for_idx_6, align 8, !dbg !209
  br label %for_hdr6, !dbg !209
for_exit8:
  %r35 = load i64, ptr %slot.exps, align 8, !dbg !210
  %r36 = load i64, ptr %slot.total, align 8, !dbg !210
  %r37.ptr = call ptr @nova_rt_struct_alloc(i64 16), !dbg !210
  %r37.tgep = getelementptr i64, ptr %r37.ptr, i64 0, !dbg !210
  %r37.tfn = ptrtoint ptr @__tramp_1 to i64, !dbg !210
  store i64 %r37.tfn, ptr %r37.tgep, align 8, !dbg !210
  %r37.c0 = getelementptr i64, ptr %r37.ptr, i64 1, !dbg !210
  store i64 %r36, ptr %r37.c0, align 8, !dbg !210
  %r37 = ptrtoint ptr %r37.ptr to i64, !dbg !210
  %r38 = call i64 @nova_rt_list_map(i64 %r35, i64 %r37), !dbg !210
  ret i64 %r38, !dbg !210
}

define i64 @argmax(i64 %p0) nounwind !dbg !211 {
entry:
  %slot.xs = alloca i64, align 8, !dbg !212
  store i64 %p0, ptr %slot.xs, align 8, !dbg !212
  %slot.best = alloca i64, align 8, !dbg !212
  store i64 0, ptr %slot.best, align 8, !dbg !212
  %slot.bestv = alloca i64, align 8, !dbg !212
  store i64 0, ptr %slot.bestv, align 8, !dbg !212
  %slot.i = alloca i64, align 8, !dbg !212
  store i64 0, ptr %slot.i, align 8, !dbg !212
  %r0 = add i64 0, 0, !dbg !213
  store i64 %r0, ptr %slot.best, align 8, !dbg !213
  %r1 = load i64, ptr %slot.xs, align 8, !dbg !214
  %r2 = add i64 0, 0, !dbg !214
  %r3.lp = inttoptr i64 %r1 to ptr, !dbg !214
  %r3.dp = load ptr, ptr %r3.lp, align 8, !tbaa !2, !dbg !214
  %r3.ep = getelementptr i64, ptr %r3.dp, i64 %r2, !dbg !214
  %r3.lv = load i64, ptr %r3.ep, align 8, !tbaa !4, !dbg !214
  %r3 = call i64 @nova_rt_unbox(i64 %r3.lv), !dbg !214
  store i64 %r3, ptr %slot.bestv, align 8, !dbg !214
  %r4 = add i64 1, 0, !dbg !215
  store i64 %r4, ptr %slot.i, align 8, !dbg !215
  br label %while_hdr9, !dbg !216
while_hdr9:
  %r5 = load i64, ptr %slot.i, align 8, !dbg !216
  %r6 = load i64, ptr %slot.xs, align 8, !dbg !216
  %r7.lp = inttoptr i64 %r6 to ptr, !dbg !216
  %r7.szp = getelementptr i64, ptr %r7.lp, i64 1, !dbg !216
  %r7 = load i64, ptr %r7.szp, align 8, !tbaa !6, !dbg !216
  %r8.cmp = icmp slt i64 %r5, %r7, !dbg !216
  %r8 = zext i1 %r8.cmp to i64, !dbg !216
  %br_while_body10 = icmp ne i64 %r8, 0, !dbg !216
  br i1 %br_while_body10, label %while_body10, label %while_exit11, !prof !90, !dbg !216
while_body10:
  %r9 = load i64, ptr %slot.xs, align 8, !dbg !217
  %r10 = load i64, ptr %slot.i, align 8, !dbg !217
  %r11.lp = inttoptr i64 %r9 to ptr, !dbg !217
  %r11.dp = load ptr, ptr %r11.lp, align 8, !tbaa !2, !dbg !217
  %r11.ep = getelementptr i64, ptr %r11.dp, i64 %r10, !dbg !217
  %r11.lv = load i64, ptr %r11.ep, align 8, !tbaa !4, !dbg !217
  %r11 = call i64 @nova_rt_unbox(i64 %r11.lv), !dbg !217
  %r12 = load i64, ptr %slot.bestv, align 8, !dbg !217
  %r13.cmp = icmp sgt i64 %r11, %r12, !dbg !217
  %r13 = zext i1 %r13.cmp to i64, !dbg !217
  %br_then12 = icmp ne i64 %r13, 0, !dbg !217
  br i1 %br_then12, label %then12, label %else13, !dbg !217
then12:
  %r14 = load i64, ptr %slot.xs, align 8, !dbg !218
  %r15 = load i64, ptr %slot.i, align 8, !dbg !218
  %r16.lp = inttoptr i64 %r14 to ptr, !dbg !218
  %r16.dp = load ptr, ptr %r16.lp, align 8, !tbaa !2, !dbg !218
  %r16.ep = getelementptr i64, ptr %r16.dp, i64 %r15, !dbg !218
  %r16.lv = load i64, ptr %r16.ep, align 8, !tbaa !4, !dbg !218
  %r16 = call i64 @nova_rt_unbox(i64 %r16.lv), !dbg !218
  store i64 %r16, ptr %slot.bestv, align 8, !dbg !218
  %r17 = load i64, ptr %slot.i, align 8, !dbg !219
  store i64 %r17, ptr %slot.best, align 8, !dbg !219
  br label %endif14, !dbg !219
else13:
  br label %endif14, !dbg !219
endif14:
  %r18 = load i64, ptr %slot.i, align 8, !dbg !220
  %r19 = add i64 1, 0, !dbg !220
  %r20 = add i64 %r18, %r19, !dbg !220
  store i64 %r20, ptr %slot.i, align 8, !dbg !220
  br label %while_hdr9, !dbg !220
while_exit11:
  %r21 = load i64, ptr %slot.best, align 8, !dbg !221
  ret i64 %r21, !dbg !221
}

define i64 @load_matrix(i64 %p0) nounwind !dbg !222 {
entry:
  %slot.path = alloca i64, align 8, !dbg !223
  store i64 %p0, ptr %slot.path, align 8, !dbg !223
  %slot.content = alloca i64, align 8, !dbg !223
  store i64 0, ptr %slot.content, align 8, !dbg !223
  %slot.lines = alloca i64, align 8, !dbg !223
  store i64 0, ptr %slot.lines, align 8, !dbg !223
  %slot.dims = alloca i64, align 8, !dbg !223
  store i64 0, ptr %slot.dims, align 8, !dbg !223
  %slot.rows = alloca i64, align 8, !dbg !223
  store i64 0, ptr %slot.rows, align 8, !dbg !223
  %slot.cols = alloca i64, align 8, !dbg !223
  store i64 0, ptr %slot.cols, align 8, !dbg !223
  %slot.flat = alloca i64, align 8, !dbg !223
  store i64 0, ptr %slot.flat, align 8, !dbg !223
  %slot.r = alloca i64, align 8, !dbg !223
  store i64 0, ptr %slot.r, align 8, !dbg !223
  %slot.vals = alloca i64, align 8, !dbg !223
  store i64 0, ptr %slot.vals, align 8, !dbg !223
  %slot.__for_idx_18 = alloca i64, align 8, !dbg !223
  store i64 0, ptr %slot.__for_idx_18, align 8, !dbg !223
  %slot.v = alloca i64, align 8, !dbg !223
  store i64 0, ptr %slot.v, align 8, !dbg !223
  %r0 = load i64, ptr %slot.path, align 8, !dbg !224
  %r1 = call i64 @nova_rt_read_file(i64 %r0), !dbg !224
  store i64 %r1, ptr %slot.content, align 8, !dbg !224
  %r2 = add i64 %r1, 0, !dbg !225
  %r3.p = getelementptr inbounds [2 x i8], ptr @.str.0, i64 0, i64 0, !dbg !225
  %r3 = ptrtoint ptr %r3.p to i64, !dbg !225
  %r4 = call i64 @nova_rt_split(i64 %r2, i64 %r3), !dbg !225
  store i64 %r4, ptr %slot.lines, align 8, !dbg !225
  %r5 = add i64 %r4, 0, !dbg !226
  %r6 = add i64 0, 0, !dbg !226
  %r7 = call i64 @nova_rt_index_get(i64 %r5, i64 %r6), !dbg !226
  %r8.p = getelementptr inbounds [2 x i8], ptr @.str.1, i64 0, i64 0, !dbg !226
  %r8 = ptrtoint ptr %r8.p to i64, !dbg !226
  %r9 = call i64 @nova_rt_split(i64 %r7, i64 %r8), !dbg !226
  store i64 %r9, ptr %slot.dims, align 8, !dbg !226
  %r10 = add i64 %r9, 0, !dbg !227
  %r11 = add i64 0, 0, !dbg !227
  %r12 = call i64 @nova_rt_index_get(i64 %r10, i64 %r11), !dbg !227
  %r13 = call i64 @nova_rt_parse_int(i64 %r12), !dbg !227
  store i64 %r13, ptr %slot.rows, align 8, !dbg !227
  %r14 = add i64 %r9, 0, !dbg !228
  %r15 = add i64 1, 0, !dbg !228
  %r16 = call i64 @nova_rt_index_get(i64 %r14, i64 %r15), !dbg !228
  %r17 = call i64 @nova_rt_parse_int(i64 %r16), !dbg !228
  store i64 %r17, ptr %slot.cols, align 8, !dbg !228
  %r18 = call i64 @nova_rt_list_create(), !dbg !229
  store i64 %r18, ptr %slot.flat, align 8, !dbg !229
  %r19 = add i64 1, 0, !dbg !230
  store i64 %r19, ptr %slot.r, align 8, !dbg !230
  br label %while_hdr15, !dbg !231
while_hdr15:
  %r20 = load i64, ptr %slot.r, align 8, !dbg !231
  %r21 = load i64, ptr %slot.rows, align 8, !dbg !231
  %r22.cmp = icmp sle i64 %r20, %r21, !dbg !231
  %r22 = zext i1 %r22.cmp to i64, !dbg !231
  %br_while_body16 = icmp ne i64 %r22, 0, !dbg !231
  br i1 %br_while_body16, label %while_body16, label %while_exit17, !prof !90, !dbg !231
while_body16:
  %r23 = load i64, ptr %slot.lines, align 8, !dbg !232
  %r24 = load i64, ptr %slot.r, align 8, !dbg !232
  %r25 = call i64 @nova_rt_index_get(i64 %r23, i64 %r24), !dbg !232
  %r26.p = getelementptr inbounds [2 x i8], ptr @.str.1, i64 0, i64 0, !dbg !232
  %r26 = ptrtoint ptr %r26.p to i64, !dbg !232
  %r27 = call i64 @nova_rt_split(i64 %r25, i64 %r26), !dbg !232
  store i64 %r27, ptr %slot.vals, align 8, !dbg !232
  %r28 = add i64 %r27, 0, !dbg !233
  %r29 = add i64 %r28, 0, !dbg !233
  %r30.lp = inttoptr i64 %r29 to ptr, !dbg !233
  %r30.szp = getelementptr i64, ptr %r30.lp, i64 1, !dbg !233
  %r30 = load i64, ptr %r30.szp, align 8, !tbaa !6, !dbg !233
  %r31 = add i64 0, 0, !dbg !233
  store i64 %r31, ptr %slot.__for_idx_18, align 8, !dbg !233
  br label %for_hdr18, !dbg !233
for_hdr18:
  %r32 = load i64, ptr %slot.__for_idx_18, align 8, !dbg !233
  %r33.cmp = icmp slt i64 %r32, %r30, !dbg !233
  %r33 = zext i1 %r33.cmp to i64, !dbg !233
  %br_for_body19 = icmp ne i64 %r33, 0, !dbg !233
  br i1 %br_for_body19, label %for_body19, label %for_exit20, !prof !90, !dbg !233
for_body19:
  %r34 = call i64 @nova_rt_index_get(i64 %r29, i64 %r32), !dbg !233
  store i64 %r34, ptr %slot.v, align 8, !dbg !233
  %r35 = add i64 %r34, 0, !dbg !234
  %r36 = call i64 @nova_rt_len_any(i64 %r35), !dbg !234
  %r37 = add i64 0, 0, !dbg !234
  %r38.cmp = icmp sgt i64 %r36, %r37, !dbg !234
  %r38 = zext i1 %r38.cmp to i64, !dbg !234
  %br_then21 = icmp ne i64 %r38, 0, !dbg !234
  br i1 %br_then21, label %then21, label %else22, !dbg !234
then21:
  %r39 = load i64, ptr %slot.flat, align 8, !dbg !235
  %r40 = load i64, ptr %slot.v, align 8, !dbg !235
  %r41 = call i64 @nova_rt_parse_float(i64 %r40), !dbg !235
  %r42 = call i64 @nova_rt_list_append_fbox(i64 %r39, i64 %r41), !dbg !235
  br label %endif23, !dbg !235
else22:
  br label %endif23, !dbg !235
endif23:
  %r43 = load i64, ptr %slot.__for_idx_18, align 8, !dbg !235
  %r44 = add i64 1, 0, !dbg !235
  %r45 = add i64 %r43, %r44, !dbg !235
  store i64 %r45, ptr %slot.__for_idx_18, align 8, !dbg !235
  br label %for_hdr18, !dbg !235
for_exit20:
  %r46 = load i64, ptr %slot.r, align 8, !dbg !236
  %r47 = add i64 1, 0, !dbg !236
  %r48 = add i64 %r46, %r47, !dbg !236
  store i64 %r48, ptr %slot.r, align 8, !dbg !236
  br label %while_hdr15, !dbg !236
while_exit17:
  %r49 = load i64, ptr %slot.flat, align 8, !dbg !237
  %r51 = load i64, ptr %slot.rows, align 8, !dbg !237
  %r52 = load i64, ptr %slot.cols, align 8, !dbg !237
  %r50 = call i64 @nova_rt_list_create(), !dbg !237
  call i64 @nova_rt_list_append(i64 %r50, i64 %r51), !dbg !237
  call i64 @nova_rt_list_append(i64 %r50, i64 %r52), !dbg !237
  %r53 = call i64 @nova_rt_tensor_from_list(i64 %r49, i64 %r50), !dbg !237
  ret i64 %r53, !dbg !237
}

define i64 @predict(i64 %p0, i64 %p1) nounwind !dbg !238 {
entry:
  %slot.w = alloca i64, align 8, !dbg !239
  store i64 %p0, ptr %slot.w, align 8, !dbg !239
  %slot.features = alloca i64, align 8, !dbg !239
  store i64 %p1, ptr %slot.features, align 8, !dbg !239
  %slot.n = alloca i64, align 8, !dbg !239
  store i64 0, ptr %slot.n, align 8, !dbg !239
  %slot.x = alloca i64, align 8, !dbg !239
  store i64 0, ptr %slot.x, align 8, !dbg !239
  %slot.logits = alloca i64, align 8, !dbg !239
  store i64 0, ptr %slot.logits, align 8, !dbg !239
  %r0 = load i64, ptr %slot.features, align 8, !dbg !240
  %r1.lp = inttoptr i64 %r0 to ptr, !dbg !240
  %r1.szp = getelementptr i64, ptr %r1.lp, i64 1, !dbg !240
  %r1 = load i64, ptr %r1.szp, align 8, !tbaa !6, !dbg !240
  store i64 %r1, ptr %slot.n, align 8, !dbg !240
  %r2 = load i64, ptr %slot.features, align 8, !dbg !241
  %r4 = add i64 1, 0, !dbg !241
  %r5 = add i64 %r1, 0, !dbg !241
  %r3 = call i64 @nova_rt_list_create(), !dbg !241
  call i64 @nova_rt_list_append(i64 %r3, i64 %r4), !dbg !241
  call i64 @nova_rt_list_append(i64 %r3, i64 %r5), !dbg !241
  %r6 = call i64 @nova_rt_tensor_from_list(i64 %r2, i64 %r3), !dbg !241
  store i64 %r6, ptr %slot.x, align 8, !dbg !241
  %r7 = add i64 %r6, 0, !dbg !242
  %r8 = load i64, ptr %slot.w, align 8, !dbg !242
  %r9 = call i64 @nova_rt_tensor_matmul(i64 %r7, i64 %r8), !dbg !242
  %r10 = call i64 @nova_rt_tensor_to_list(i64 %r9), !dbg !242
  store i64 %r10, ptr %slot.logits, align 8, !dbg !242
  %r11 = add i64 %r10, 0, !dbg !243
  %r12 = call i64 @softmax(i64 %r11), !dbg !243
  %r13 = call i64 @argmax(i64 %r12), !dbg !243
  ret i64 %r13, !dbg !243
}

define i64 @req_method(i64 %p0) nounwind !dbg !244 {
entry:
  %slot.raw = alloca i64, align 8, !dbg !245
  store i64 %p0, ptr %slot.raw, align 8, !dbg !245
  %slot.sp = alloca i64, align 8, !dbg !245
  store i64 0, ptr %slot.sp, align 8, !dbg !245
  %r0 = load i64, ptr %slot.raw, align 8, !dbg !246
  %r1.p = getelementptr inbounds [2 x i8], ptr @.str.1, i64 0, i64 0, !dbg !246
  %r1 = ptrtoint ptr %r1.p to i64, !dbg !246
  %r2 = call i64 @nova_rt_find(i64 %r0, i64 %r1), !dbg !246
  store i64 %r2, ptr %slot.sp, align 8, !dbg !246
  %r3 = add i64 %r2, 0, !dbg !247
  %r4 = add i64 0, 0, !dbg !247
  %r5.cmp = icmp slt i64 %r3, %r4, !dbg !247
  %r5 = zext i1 %r5.cmp to i64, !dbg !247
  %br_then24 = icmp ne i64 %r5, 0, !dbg !247
  br i1 %br_then24, label %then24, label %else25, !dbg !247
then24:
  %r6.p = getelementptr inbounds [1 x i8], ptr @.str.2, i64 0, i64 0, !dbg !248
  %r6 = ptrtoint ptr %r6.p to i64, !dbg !248
  ret i64 %r6, !dbg !248
else25:
  br label %endif26, !dbg !248
endif26:
  %r7 = load i64, ptr %slot.raw, align 8, !dbg !249
  %r8 = add i64 0, 0, !dbg !249
  %r9 = load i64, ptr %slot.sp, align 8, !dbg !249
  %r10 = call i64 @nova_rt_slice(i64 %r7, i64 %r8, i64 %r9), !dbg !249
  ret i64 %r10, !dbg !249
}

define i64 @req_path(i64 %p0) nounwind !dbg !250 {
entry:
  %slot.raw = alloca i64, align 8, !dbg !251
  store i64 %p0, ptr %slot.raw, align 8, !dbg !251
  %slot.sp1 = alloca i64, align 8, !dbg !251
  store i64 0, ptr %slot.sp1, align 8, !dbg !251
  %slot.rest = alloca i64, align 8, !dbg !251
  store i64 0, ptr %slot.rest, align 8, !dbg !251
  %slot.sp2 = alloca i64, align 8, !dbg !251
  store i64 0, ptr %slot.sp2, align 8, !dbg !251
  %r0 = load i64, ptr %slot.raw, align 8, !dbg !252
  %r1.p = getelementptr inbounds [2 x i8], ptr @.str.1, i64 0, i64 0, !dbg !252
  %r1 = ptrtoint ptr %r1.p to i64, !dbg !252
  %r2 = call i64 @nova_rt_find(i64 %r0, i64 %r1), !dbg !252
  store i64 %r2, ptr %slot.sp1, align 8, !dbg !252
  %r3 = load i64, ptr %slot.raw, align 8, !dbg !253
  %r4 = add i64 %r2, 0, !dbg !253
  %r5 = add i64 1, 0, !dbg !253
  %r6 = add i64 %r4, %r5, !dbg !253
  %r7 = load i64, ptr %slot.raw, align 8, !dbg !253
  %r8 = call i64 @nova_rt_len_any(i64 %r7), !dbg !253
  %r9 = call i64 @nova_rt_slice(i64 %r3, i64 %r6, i64 %r8), !dbg !253
  store i64 %r9, ptr %slot.rest, align 8, !dbg !253
  %r10 = add i64 %r9, 0, !dbg !254
  %r11.p = getelementptr inbounds [2 x i8], ptr @.str.1, i64 0, i64 0, !dbg !254
  %r11 = ptrtoint ptr %r11.p to i64, !dbg !254
  %r12 = call i64 @nova_rt_find(i64 %r10, i64 %r11), !dbg !254
  store i64 %r12, ptr %slot.sp2, align 8, !dbg !254
  %r13 = add i64 %r12, 0, !dbg !255
  %r14 = add i64 0, 0, !dbg !255
  %r15.cmp = icmp slt i64 %r13, %r14, !dbg !255
  %r15 = zext i1 %r15.cmp to i64, !dbg !255
  %br_then27 = icmp ne i64 %r15, 0, !dbg !255
  br i1 %br_then27, label %then27, label %else28, !dbg !255
then27:
  %r16 = load i64, ptr %slot.rest, align 8, !dbg !256
  ret i64 %r16, !dbg !256
else28:
  br label %endif29, !dbg !256
endif29:
  %r17 = load i64, ptr %slot.rest, align 8, !dbg !257
  %r18 = add i64 0, 0, !dbg !257
  %r19 = load i64, ptr %slot.sp2, align 8, !dbg !257
  %r20 = call i64 @nova_rt_slice(i64 %r17, i64 %r18, i64 %r19), !dbg !257
  ret i64 %r20, !dbg !257
}

define i64 @req_body(i64 %p0) nounwind !dbg !258 {
entry:
  %slot.raw = alloca i64, align 8, !dbg !259
  store i64 %p0, ptr %slot.raw, align 8, !dbg !259
  %slot.idx = alloca i64, align 8, !dbg !259
  store i64 0, ptr %slot.idx, align 8, !dbg !259
  %r0 = load i64, ptr %slot.raw, align 8, !dbg !260
  %r1.p = getelementptr inbounds [5 x i8], ptr @.str.3, i64 0, i64 0, !dbg !260
  %r1 = ptrtoint ptr %r1.p to i64, !dbg !260
  %r2 = call i64 @nova_rt_find(i64 %r0, i64 %r1), !dbg !260
  store i64 %r2, ptr %slot.idx, align 8, !dbg !260
  %r3 = add i64 %r2, 0, !dbg !261
  %r4 = add i64 0, 0, !dbg !261
  %r5.cmp = icmp slt i64 %r3, %r4, !dbg !261
  %r5 = zext i1 %r5.cmp to i64, !dbg !261
  %br_then30 = icmp ne i64 %r5, 0, !dbg !261
  br i1 %br_then30, label %then30, label %else31, !dbg !261
then30:
  %r6.p = getelementptr inbounds [1 x i8], ptr @.str.2, i64 0, i64 0, !dbg !262
  %r6 = ptrtoint ptr %r6.p to i64, !dbg !262
  ret i64 %r6, !dbg !262
else31:
  br label %endif32, !dbg !262
endif32:
  %r7 = load i64, ptr %slot.raw, align 8, !dbg !263
  %r8 = load i64, ptr %slot.idx, align 8, !dbg !263
  %r9 = add i64 4, 0, !dbg !263
  %r10 = add i64 %r8, %r9, !dbg !263
  %r11 = load i64, ptr %slot.raw, align 8, !dbg !263
  %r12 = call i64 @nova_rt_len_any(i64 %r11), !dbg !263
  %r13 = call i64 @nova_rt_slice(i64 %r7, i64 %r10, i64 %r12), !dbg !263
  ret i64 %r13, !dbg !263
}

define i64 @build_response(i64 %p0, i64 %p1) nounwind !dbg !264 {
entry:
  %slot.status = alloca i64, align 8, !dbg !265
  store i64 %p0, ptr %slot.status, align 8, !dbg !265
  %slot.body = alloca i64, align 8, !dbg !265
  store i64 %p1, ptr %slot.body, align 8, !dbg !265
  %slot.sl = alloca i64, align 8, !dbg !265
  store i64 0, ptr %slot.sl, align 8, !dbg !265
  %r0.p = getelementptr inbounds [7 x i8], ptr @.str.4, i64 0, i64 0, !dbg !266
  %r0 = ptrtoint ptr %r0.p to i64, !dbg !266
  store i64 %r0, ptr %slot.sl, align 8, !dbg !266
  %r1 = load i64, ptr %slot.status, align 8, !dbg !267
  %r2 = add i64 404, 0, !dbg !267
  %r3.cmp = icmp eq i64 %r1, %r2, !dbg !267
  %r3 = zext i1 %r3.cmp to i64, !dbg !267
  %br_then33 = icmp ne i64 %r3, 0, !dbg !267
  br i1 %br_then33, label %then33, label %else34, !dbg !267
then33:
  %r4.p = getelementptr inbounds [14 x i8], ptr @.str.5, i64 0, i64 0, !dbg !268
  %r4 = ptrtoint ptr %r4.p to i64, !dbg !268
  store i64 %r4, ptr %slot.sl, align 8, !dbg !268
  br label %endif35, !dbg !268
else34:
  br label %endif35, !dbg !268
endif35:
  %r5.p = getelementptr inbounds [10 x i8], ptr @.str.6, i64 0, i64 0, !dbg !269
  %r5 = ptrtoint ptr %r5.p to i64, !dbg !269
  %r6 = load i64, ptr %slot.sl, align 8, !dbg !269
  %r7 = call i64 @nova_rt_str_concat(i64 %r5, i64 %r6), !dbg !269
  %r8.p = getelementptr inbounds [51 x i8], ptr @.str.7, i64 0, i64 0, !dbg !269
  %r8 = ptrtoint ptr %r8.p to i64, !dbg !269
  %r9 = call i64 @nova_rt_str_concat(i64 %r7, i64 %r8), !dbg !269
  %r10 = load i64, ptr %slot.body, align 8, !dbg !269
  %r11 = call i64 @nova_rt_len_any(i64 %r10), !dbg !269
  %r12 = call i64 @nova_rt_int_to_str(i64 %r11), !dbg !269
  %r13 = call i64 @nova_rt_str_concat(i64 %r9, i64 %r12), !dbg !269
  %r14.p = getelementptr inbounds [24 x i8], ptr @.str.8, i64 0, i64 0, !dbg !269
  %r14 = ptrtoint ptr %r14.p to i64, !dbg !269
  %r15 = call i64 @nova_rt_str_concat(i64 %r13, i64 %r14), !dbg !269
  %r16 = load i64, ptr %slot.body, align 8, !dbg !269
  %r17 = call i64 @nova_rt_str_concat(i64 %r15, i64 %r16), !dbg !269
  ret i64 %r17, !dbg !269
}

define i64 @nova_user_main() nounwind !dbg !270 {
entry:
  %slot.argv = alloca i64, align 8, !dbg !271
  store i64 0, ptr %slot.argv, align 8, !dbg !271
  %slot.port = alloca i64, align 8, !dbg !271
  store i64 0, ptr %slot.port, align 8, !dbg !271
  %slot.ep = alloca i64, align 8, !dbg !271
  store i64 0, ptr %slot.ep, align 8, !dbg !271
  %slot.ap = alloca i64, align 8, !dbg !271
  store i64 0, ptr %slot.ap, align 8, !dbg !271
  %slot.w = alloca i64, align 8, !dbg !271
  store i64 0, ptr %slot.w, align 8, !dbg !271
  %slot.sock = alloca i64, align 8, !dbg !271
  store i64 0, ptr %slot.sock, align 8, !dbg !271
  %slot.running = alloca i64, align 8, !dbg !271
  store i64 0, ptr %slot.running, align 8, !dbg !271
  %slot.conn = alloca i64, align 8, !dbg !271
  store i64 0, ptr %slot.conn, align 8, !dbg !271
  %slot.client = alloca i64, align 8, !dbg !271
  store i64 0, ptr %slot.client, align 8, !dbg !271
  %slot.raw = alloca i64, align 8, !dbg !271
  store i64 0, ptr %slot.raw, align 8, !dbg !271
  %slot.method = alloca i64, align 8, !dbg !271
  store i64 0, ptr %slot.method, align 8, !dbg !271
  %slot.path = alloca i64, align 8, !dbg !271
  store i64 0, ptr %slot.path, align 8, !dbg !271
  %slot.__sc_51 = alloca i64, align 8, !dbg !271
  store i64 0, ptr %slot.__sc_51, align 8, !dbg !271
  %slot.parsed = alloca i64, align 8, !dbg !271
  store i64 0, ptr %slot.parsed, align 8, !dbg !271
  %slot.features = alloca i64, align 8, !dbg !271
  store i64 0, ptr %slot.features, align 8, !dbg !271
  %slot.cls = alloca i64, align 8, !dbg !271
  store i64 0, ptr %slot.cls, align 8, !dbg !271
  %r0 = call i64 @nova_rt_args(), !dbg !272
  store i64 %r0, ptr %slot.argv, align 8, !dbg !272
  %r1 = add i64 8080, 0, !dbg !273
  store i64 %r1, ptr %slot.port, align 8, !dbg !273
  %r2.p = getelementptr inbounds [5 x i8], ptr @.str.9, i64 0, i64 0, !dbg !274
  %r2 = ptrtoint ptr %r2.p to i64, !dbg !274
  %r3 = call i64 @nova_rt_env(i64 %r2), !dbg !274
  %r4 = call i64 @nova_rt_parse_int(i64 %r3), !dbg !274
  store i64 %r4, ptr %slot.ep, align 8, !dbg !274
  %r5 = add i64 %r4, 0, !dbg !275
  %r6 = add i64 0, 0, !dbg !275
  %r7.cmp = icmp sgt i64 %r5, %r6, !dbg !275
  %r7 = zext i1 %r7.cmp to i64, !dbg !275
  %br_then36 = icmp ne i64 %r7, 0, !dbg !275
  br i1 %br_then36, label %then36, label %else37, !dbg !275
then36:
  %r8 = load i64, ptr %slot.ep, align 8, !dbg !276
  store i64 %r8, ptr %slot.port, align 8, !dbg !276
  br label %endif38, !dbg !276
else37:
  %r9 = load i64, ptr %slot.argv, align 8, !dbg !277
  %r10.lp = inttoptr i64 %r9 to ptr, !dbg !277
  %r10.szp = getelementptr i64, ptr %r10.lp, i64 1, !dbg !277
  %r10 = load i64, ptr %r10.szp, align 8, !tbaa !6, !dbg !277
  %r11 = add i64 1, 0, !dbg !277
  %r12.cmp = icmp sgt i64 %r10, %r11, !dbg !277
  %r12 = zext i1 %r12.cmp to i64, !dbg !277
  %br_then39 = icmp ne i64 %r12, 0, !dbg !277
  br i1 %br_then39, label %then39, label %else40, !dbg !277
then39:
  %r13 = load i64, ptr %slot.argv, align 8, !dbg !278
  %r14 = add i64 1, 0, !dbg !278
  %r15 = call i64 @nova_rt_index_get(i64 %r13, i64 %r14), !dbg !278
  %r16 = call i64 @nova_rt_parse_int(i64 %r15), !dbg !278
  store i64 %r16, ptr %slot.ap, align 8, !dbg !278
  %r17 = add i64 %r16, 0, !dbg !279
  %r18 = add i64 0, 0, !dbg !279
  %r19.cmp = icmp sgt i64 %r17, %r18, !dbg !279
  %r19 = zext i1 %r19.cmp to i64, !dbg !279
  %br_then42 = icmp ne i64 %r19, 0, !dbg !279
  br i1 %br_then42, label %then42, label %else43, !dbg !279
then42:
  %r20 = load i64, ptr %slot.ap, align 8, !dbg !280
  store i64 %r20, ptr %slot.port, align 8, !dbg !280
  br label %endif44, !dbg !280
else43:
  br label %endif44, !dbg !280
endif44:
  br label %endif41, !dbg !280
else40:
  br label %endif41, !dbg !280
endif41:
  br label %endif38, !dbg !280
endif38:
  %r21.p = getelementptr inbounds [12 x i8], ptr @.str.10, i64 0, i64 0, !dbg !281
  %r21 = ptrtoint ptr %r21.p to i64, !dbg !281
  %r22.p = getelementptr inbounds [29 x i8], ptr @.str.11, i64 0, i64 0, !dbg !281
  %r22 = ptrtoint ptr %r22.p to i64, !dbg !281
  %r23 = call i64 @nova_rt_write_file(i64 %r21, i64 %r22), !dbg !281
  %r24.p = getelementptr inbounds [12 x i8], ptr @.str.10, i64 0, i64 0, !dbg !282
  %r24 = ptrtoint ptr %r24.p to i64, !dbg !282
  %r25 = call i64 @load_matrix(i64 %r24), !dbg !282
  store i64 %r25, ptr %slot.w, align 8, !dbg !282
  %r26 = load i64, ptr %slot.port, align 8, !dbg !283
  %r27 = call i64 @nova_rt_http_listen(i64 %r26), !dbg !283
  store i64 %r27, ptr %slot.sock, align 8, !dbg !283
  %r28.p = getelementptr inbounds [34 x i8], ptr @.str.12, i64 0, i64 0, !dbg !284
  %r28 = ptrtoint ptr %r28.p to i64, !dbg !284
  %r29 = load i64, ptr %slot.port, align 8, !dbg !284
  %r30 = call i64 @nova_rt_any_to_str(i64 %r29), !dbg !284
  %r31 = call i64 @nova_rt_str_concat(i64 %r28, i64 %r30), !dbg !284
  %r32.p = getelementptr inbounds [1 x i8], ptr @.str.2, i64 0, i64 0, !dbg !284
  %r32 = ptrtoint ptr %r32.p to i64, !dbg !284
  %r33 = call i64 @nova_rt_str_concat(i64 %r31, i64 %r32), !dbg !284
  %r34 = call i64 @nova_rt_print_str(i64 %r33), !dbg !284
  %r35 = add i64 1, 0, !dbg !285
  store i64 %r35, ptr %slot.running, align 8, !dbg !285
  br label %while_hdr45, !dbg !286
while_hdr45:
  %r36 = load i64, ptr %slot.running, align 8, !dbg !286
  %r37 = add i64 1, 0, !dbg !286
  %r38.cmp = icmp eq i64 %r36, %r37, !dbg !286
  %r38 = zext i1 %r38.cmp to i64, !dbg !286
  %br_while_body46 = icmp ne i64 %r38, 0, !dbg !286
  br i1 %br_while_body46, label %while_body46, label %while_exit47, !prof !90, !dbg !286
while_body46:
  %r39 = load i64, ptr %slot.sock, align 8, !dbg !287
  %r40 = call i64 @nova_rt_http_accept_raw(i64 %r39), !dbg !287
  store i64 %r40, ptr %slot.conn, align 8, !dbg !287
  %r41 = add i64 %r40, 0, !dbg !288
  %r42 = call i64 @nova_rt_len_any(i64 %r41), !dbg !288
  %r43 = add i64 0, 0, !dbg !288
  %r44.cmp = icmp eq i64 %r42, %r43, !dbg !288
  %r44 = zext i1 %r44.cmp to i64, !dbg !288
  %br_then48 = icmp ne i64 %r44, 0, !dbg !288
  br i1 %br_then48, label %then48, label %else49, !dbg !288
then48:
  br label %while_hdr45, !dbg !289
else49:
  br label %endif50, !dbg !289
endif50:
  %r45 = load i64, ptr %slot.conn, align 8, !dbg !290
  %r46 = add i64 0, 0, !dbg !290
  %r47 = call i64 @nova_rt_index_get(i64 %r45, i64 %r46), !dbg !290
  store i64 %r47, ptr %slot.client, align 8, !dbg !290
  %r48 = load i64, ptr %slot.conn, align 8, !dbg !291
  %r49 = add i64 1, 0, !dbg !291
  %r50 = call i64 @nova_rt_index_get(i64 %r48, i64 %r49), !dbg !291
  store i64 %r50, ptr %slot.raw, align 8, !dbg !291
  %r51 = add i64 %r50, 0, !dbg !292
  %r52 = call i64 @req_method(i64 %r51), !dbg !292
  store i64 %r52, ptr %slot.method, align 8, !dbg !292
  %r53 = add i64 %r50, 0, !dbg !293
  %r54 = call i64 @req_path(i64 %r53), !dbg !293
  store i64 %r54, ptr %slot.path, align 8, !dbg !293
  %r55 = add i64 %r52, 0, !dbg !294
  %r56.p = getelementptr inbounds [5 x i8], ptr @.str.13, i64 0, i64 0, !dbg !294
  %r56 = ptrtoint ptr %r56.p to i64, !dbg !294
  %r57.p0 = inttoptr i64 %r55 to ptr, !dbg !294
  %r57.p1 = inttoptr i64 %r56 to ptr, !dbg !294
  %r57.sc = call i32 @strcmp(ptr %r57.p0, ptr %r57.p1), !dbg !294
  %r57.cmp = icmp eq i32 %r57.sc, 0, !dbg !294
  %r57 = zext i1 %r57.cmp to i64, !dbg !294
  store i64 %r57, ptr %slot.__sc_51, align 8, !dbg !294
  %br_and_rhs52 = icmp ne i64 %r57, 0, !dbg !294
  br i1 %br_and_rhs52, label %and_rhs52, label %and_merge53, !dbg !294
and_rhs52:
  %r58 = load i64, ptr %slot.path, align 8, !dbg !294
  %r59.p = getelementptr inbounds [9 x i8], ptr @.str.14, i64 0, i64 0, !dbg !294
  %r59 = ptrtoint ptr %r59.p to i64, !dbg !294
  %r60.p0 = inttoptr i64 %r58 to ptr, !dbg !294
  %r60.p1 = inttoptr i64 %r59 to ptr, !dbg !294
  %r60.sc = call i32 @strcmp(ptr %r60.p0, ptr %r60.p1), !dbg !294
  %r60.cmp = icmp eq i32 %r60.sc, 0, !dbg !294
  %r60 = zext i1 %r60.cmp to i64, !dbg !294
  store i64 %r60, ptr %slot.__sc_51, align 8, !dbg !294
  br label %and_merge53, !dbg !294
and_merge53:
  %r61 = load i64, ptr %slot.__sc_51, align 8, !dbg !294
  %br_then54 = icmp ne i64 %r61, 0, !dbg !294
  br i1 %br_then54, label %then54, label %else55, !dbg !294
then54:
  %r62 = load i64, ptr %slot.raw, align 8, !dbg !295
  %r63 = call i64 @req_body(i64 %r62), !dbg !295
  %r64 = call i64 @nova_rt_json_decode(i64 %r63), !dbg !295
  store i64 %r64, ptr %slot.parsed, align 8, !dbg !295
  %r65 = add i64 %r64, 0, !dbg !296
  %r66.p = getelementptr inbounds [9 x i8], ptr @.str.15, i64 0, i64 0, !dbg !296
  %r66 = ptrtoint ptr %r66.p to i64, !dbg !296
  %r67 = call i64 @nova_rt_index_get(i64 %r65, i64 %r66), !dbg !296
  store i64 %r67, ptr %slot.features, align 8, !dbg !296
  %r68 = load i64, ptr %slot.w, align 8, !dbg !297
  %r69 = add i64 %r67, 0, !dbg !297
  %r70 = call i64 @predict(i64 %r68, i64 %r69), !dbg !297
  store i64 %r70, ptr %slot.cls, align 8, !dbg !297
  %r71 = load i64, ptr %slot.client, align 8, !dbg !298
  %r72 = add i64 200, 0, !dbg !298
  %r73.p = getelementptr inbounds [11 x i8], ptr @.str.16, i64 0, i64 0, !dbg !298
  %r73 = ptrtoint ptr %r73.p to i64, !dbg !298
  %r74 = add i64 %r70, 0, !dbg !298
  %r75 = call i64 @nova_rt_any_to_str(i64 %r74), !dbg !298
  %r76 = call i64 @nova_rt_str_concat(i64 %r73, i64 %r75), !dbg !298
  %r77.p = getelementptr inbounds [2 x i8], ptr @.str.17, i64 0, i64 0, !dbg !298
  %r77 = ptrtoint ptr %r77.p to i64, !dbg !298
  %r78 = call i64 @nova_rt_str_concat(i64 %r76, i64 %r77), !dbg !298
  %r79 = call i64 @build_response(i64 %r72, i64 %r78), !dbg !298
  %r80 = call i64 @nova_rt_http_send_raw(i64 %r71, i64 %r79), !dbg !298
  br label %endif56, !dbg !298
else55:
  %r81 = load i64, ptr %slot.path, align 8, !dbg !299
  %r82.p = getelementptr inbounds [6 x i8], ptr @.str.18, i64 0, i64 0, !dbg !299
  %r82 = ptrtoint ptr %r82.p to i64, !dbg !299
  %r83.p0 = inttoptr i64 %r81 to ptr, !dbg !299
  %r83.p1 = inttoptr i64 %r82 to ptr, !dbg !299
  %r83.sc = call i32 @strcmp(ptr %r83.p0, ptr %r83.p1), !dbg !299
  %r83.cmp = icmp eq i32 %r83.sc, 0, !dbg !299
  %r83 = zext i1 %r83.cmp to i64, !dbg !299
  %br_then57 = icmp ne i64 %r83, 0, !dbg !299
  br i1 %br_then57, label %then57, label %else58, !dbg !299
then57:
  %r84 = load i64, ptr %slot.client, align 8, !dbg !300
  %r85 = add i64 200, 0, !dbg !300
  %r86.p = getelementptr inbounds [13 x i8], ptr @.str.19, i64 0, i64 0, !dbg !300
  %r86 = ptrtoint ptr %r86.p to i64, !dbg !300
  %r87 = call i64 @build_response(i64 %r85, i64 %r86), !dbg !300
  %r88 = call i64 @nova_rt_http_send_raw(i64 %r84, i64 %r87), !dbg !300
  %r89 = add i64 0, 0, !dbg !301
  store i64 %r89, ptr %slot.running, align 8, !dbg !301
  br label %endif59, !dbg !301
else58:
  %r90 = load i64, ptr %slot.client, align 8, !dbg !302
  %r91 = add i64 404, 0, !dbg !302
  %r92.p = getelementptr inbounds [23 x i8], ptr @.str.20, i64 0, i64 0, !dbg !302
  %r92 = ptrtoint ptr %r92.p to i64, !dbg !302
  %r93 = call i64 @build_response(i64 %r91, i64 %r92), !dbg !302
  %r94 = call i64 @nova_rt_http_send_raw(i64 %r90, i64 %r93), !dbg !302
  br label %endif59, !dbg !302
endif59:
  br label %endif56, !dbg !302
endif56:
  br label %while_hdr45, !dbg !302
while_exit47:
  ret i64 0, !dbg !302
}

define i64 @__lambda_0(i64 %p0, i64 %p1) nounwind {
entry:
  %slot.m = alloca i64, align 8
  store i64 %p0, ptr %slot.m, align 8
  %slot.x = alloca i64, align 8
  store i64 %p1, ptr %slot.x, align 8
  %r0 = load i64, ptr %slot.x, align 8
  %r1 = load i64, ptr %slot.m, align 8
  %r2 = call i64 @nova_rt_sub(i64 %r0, i64 %r1)
  %r3 = call i64 @nova_rt_exp(i64 %r2)
  ret i64 %r3
}

define i64 @__lambda_1(i64 %p0, i64 %p1) nounwind {
entry:
  %slot.total = alloca i64, align 8
  store i64 %p0, ptr %slot.total, align 8
  %slot.e = alloca i64, align 8
  store i64 %p1, ptr %slot.e, align 8
  %r0 = load i64, ptr %slot.e, align 8
  %r1 = load i64, ptr %slot.total, align 8
  %r2 = call i64 @nova_rt_div(i64 %r0, i64 %r1)
  ret i64 %r2
}

define i64 @nova_main() nounwind {
entry:
  %r0 = call i64 @nova_user_main()
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

define i64 @__tramp_1(i64 %record, i64 %p0) nounwind {
entry:
  %rec_ptr = inttoptr i64 %record to ptr
  %cap0_ptr = getelementptr i64, ptr %rec_ptr, i64 1
  %cap0 = load i64, ptr %cap0_ptr, align 8
  %result = call i64 @__lambda_1(i64 %cap0, i64 %p0)
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

; String constants
@.str.0 = private unnamed_addr constant [2 x i8] c"\0A\00"
@.str.1 = private unnamed_addr constant [2 x i8] c" \00"
@.str.2 = private unnamed_addr constant [1 x i8] c"\00"
@.str.3 = private unnamed_addr constant [5 x i8] c"\0D\0A\0D\0A\00"
@.str.4 = private unnamed_addr constant [7 x i8] c"200 OK\00"
@.str.5 = private unnamed_addr constant [14 x i8] c"404 Not Found\00"
@.str.6 = private unnamed_addr constant [10 x i8] c"HTTP/1.1 \00"
@.str.7 = private unnamed_addr constant [51 x i8] c"\0D\0AContent-Type: application/json\0D\0AContent-Length: \00"
@.str.8 = private unnamed_addr constant [24 x i8] c"\0D\0AConnection: close\0D\0A\0D\0A\00"
@.str.9 = private unnamed_addr constant [5 x i8] c"PORT\00"
@.str.10 = private unnamed_addr constant [12 x i8] c"serve_w.txt\00"
@.str.11 = private unnamed_addr constant [29 x i8] c"2 3\0A1.0 2.0 0.0\0A0.0 1.0 1.0\0A\00"
@.str.12 = private unnamed_addr constant [34 x i8] c"AI inference server listening on \00"
@.str.13 = private unnamed_addr constant [5 x i8] c"POST\00"
@.str.14 = private unnamed_addr constant [9 x i8] c"/predict\00"
@.str.15 = private unnamed_addr constant [9 x i8] c"features\00"
@.str.16 = private unnamed_addr constant [11 x i8] c"{\22class\22: \00"
@.str.17 = private unnamed_addr constant [2 x i8] c"}\00"
@.str.18 = private unnamed_addr constant [6 x i8] c"/stop\00"
@.str.19 = private unnamed_addr constant [13 x i8] c"{\22ok\22: true}\00"
@.str.20 = private unnamed_addr constant [23 x i8] c"{\22error\22: \22not found\22}\00"

; Debug metadata
!llvm.dbg.cu = !{!100}
!llvm.module.flags = !{!102, !103}

!100 = distinct !DICompileUnit(language: DW_LANG_C99, file: !101, producer: "NOVA Compiler", isOptimized: false, emissionKind: LineTablesOnly)
!101 = !DIFile(filename: "ai_serve.nova", directory: ".")
!102 = !{i32 7, !"Dwarf Version", i32 4}
!103 = !{i32 2, !"Debug Info Version", i32 3}
!104 = !DISubroutineType(types: !105)
!105 = !{null}
!200 = distinct !DISubprogram(name: "softmax", scope: !101, file: !101, line: 5, type: !104, scopeLine: 5, spFlags: DISPFlagDefinition, unit: !100)
!201 = !DILocation(line: 5, column: 0, scope: !200)
!211 = distinct !DISubprogram(name: "argmax", scope: !101, file: !101, line: 16, type: !104, scopeLine: 16, spFlags: DISPFlagDefinition, unit: !100)
!212 = !DILocation(line: 16, column: 0, scope: !211)
!222 = distinct !DISubprogram(name: "load_matrix", scope: !101, file: !101, line: 27, type: !104, scopeLine: 27, spFlags: DISPFlagDefinition, unit: !100)
!223 = !DILocation(line: 27, column: 0, scope: !222)
!238 = distinct !DISubprogram(name: "predict", scope: !101, file: !101, line: 43, type: !104, scopeLine: 43, spFlags: DISPFlagDefinition, unit: !100)
!239 = !DILocation(line: 43, column: 0, scope: !238)
!244 = distinct !DISubprogram(name: "req_method", scope: !101, file: !101, line: 49, type: !104, scopeLine: 49, spFlags: DISPFlagDefinition, unit: !100)
!245 = !DILocation(line: 49, column: 0, scope: !244)
!250 = distinct !DISubprogram(name: "req_path", scope: !101, file: !101, line: 55, type: !104, scopeLine: 55, spFlags: DISPFlagDefinition, unit: !100)
!251 = !DILocation(line: 55, column: 0, scope: !250)
!258 = distinct !DISubprogram(name: "req_body", scope: !101, file: !101, line: 63, type: !104, scopeLine: 63, spFlags: DISPFlagDefinition, unit: !100)
!259 = !DILocation(line: 63, column: 0, scope: !258)
!264 = distinct !DISubprogram(name: "build_response", scope: !101, file: !101, line: 69, type: !104, scopeLine: 69, spFlags: DISPFlagDefinition, unit: !100)
!265 = !DILocation(line: 69, column: 0, scope: !264)
!270 = distinct !DISubprogram(name: "nova_user_main", scope: !101, file: !101, line: 75, type: !104, scopeLine: 75, spFlags: DISPFlagDefinition, unit: !100)
!271 = !DILocation(line: 75, column: 0, scope: !270)
!202 = !DILocation(line: 6, column: 0, scope: !200)
!203 = !DILocation(line: 7, column: 0, scope: !200)
!204 = !DILocation(line: 8, column: 0, scope: !200)
!205 = !DILocation(line: 9, column: 0, scope: !200)
!206 = !DILocation(line: 10, column: 0, scope: !200)
!207 = !DILocation(line: 11, column: 0, scope: !200)
!208 = !DILocation(line: 12, column: 0, scope: !200)
!209 = !DILocation(line: 13, column: 0, scope: !200)
!210 = !DILocation(line: 14, column: 0, scope: !200)
!213 = !DILocation(line: 17, column: 0, scope: !211)
!214 = !DILocation(line: 18, column: 0, scope: !211)
!215 = !DILocation(line: 19, column: 0, scope: !211)
!216 = !DILocation(line: 20, column: 0, scope: !211)
!217 = !DILocation(line: 21, column: 0, scope: !211)
!218 = !DILocation(line: 22, column: 0, scope: !211)
!219 = !DILocation(line: 23, column: 0, scope: !211)
!220 = !DILocation(line: 24, column: 0, scope: !211)
!221 = !DILocation(line: 25, column: 0, scope: !211)
!224 = !DILocation(line: 28, column: 0, scope: !222)
!225 = !DILocation(line: 29, column: 0, scope: !222)
!226 = !DILocation(line: 30, column: 0, scope: !222)
!227 = !DILocation(line: 31, column: 0, scope: !222)
!228 = !DILocation(line: 32, column: 0, scope: !222)
!229 = !DILocation(line: 33, column: 0, scope: !222)
!230 = !DILocation(line: 34, column: 0, scope: !222)
!231 = !DILocation(line: 35, column: 0, scope: !222)
!232 = !DILocation(line: 36, column: 0, scope: !222)
!233 = !DILocation(line: 37, column: 0, scope: !222)
!234 = !DILocation(line: 38, column: 0, scope: !222)
!235 = !DILocation(line: 39, column: 0, scope: !222)
!236 = !DILocation(line: 40, column: 0, scope: !222)
!237 = !DILocation(line: 41, column: 0, scope: !222)
!240 = !DILocation(line: 44, column: 0, scope: !238)
!241 = !DILocation(line: 45, column: 0, scope: !238)
!242 = !DILocation(line: 46, column: 0, scope: !238)
!243 = !DILocation(line: 47, column: 0, scope: !238)
!246 = !DILocation(line: 50, column: 0, scope: !244)
!247 = !DILocation(line: 51, column: 0, scope: !244)
!248 = !DILocation(line: 52, column: 0, scope: !244)
!249 = !DILocation(line: 53, column: 0, scope: !244)
!252 = !DILocation(line: 56, column: 0, scope: !250)
!253 = !DILocation(line: 57, column: 0, scope: !250)
!254 = !DILocation(line: 58, column: 0, scope: !250)
!255 = !DILocation(line: 59, column: 0, scope: !250)
!256 = !DILocation(line: 60, column: 0, scope: !250)
!257 = !DILocation(line: 61, column: 0, scope: !250)
!260 = !DILocation(line: 64, column: 0, scope: !258)
!261 = !DILocation(line: 65, column: 0, scope: !258)
!262 = !DILocation(line: 66, column: 0, scope: !258)
!263 = !DILocation(line: 67, column: 0, scope: !258)
!266 = !DILocation(line: 70, column: 0, scope: !264)
!267 = !DILocation(line: 71, column: 0, scope: !264)
!268 = !DILocation(line: 72, column: 0, scope: !264)
!269 = !DILocation(line: 73, column: 0, scope: !264)
!272 = !DILocation(line: 76, column: 0, scope: !270)
!273 = !DILocation(line: 80, column: 0, scope: !270)
!274 = !DILocation(line: 81, column: 0, scope: !270)
!275 = !DILocation(line: 82, column: 0, scope: !270)
!276 = !DILocation(line: 83, column: 0, scope: !270)
!277 = !DILocation(line: 84, column: 0, scope: !270)
!278 = !DILocation(line: 85, column: 0, scope: !270)
!279 = !DILocation(line: 86, column: 0, scope: !270)
!280 = !DILocation(line: 87, column: 0, scope: !270)
!281 = !DILocation(line: 89, column: 0, scope: !270)
!282 = !DILocation(line: 90, column: 0, scope: !270)
!283 = !DILocation(line: 91, column: 0, scope: !270)
!284 = !DILocation(line: 92, column: 0, scope: !270)
!285 = !DILocation(line: 93, column: 0, scope: !270)
!286 = !DILocation(line: 94, column: 0, scope: !270)
!287 = !DILocation(line: 95, column: 0, scope: !270)
!288 = !DILocation(line: 96, column: 0, scope: !270)
!289 = !DILocation(line: 97, column: 0, scope: !270)
!290 = !DILocation(line: 98, column: 0, scope: !270)
!291 = !DILocation(line: 99, column: 0, scope: !270)
!292 = !DILocation(line: 100, column: 0, scope: !270)
!293 = !DILocation(line: 101, column: 0, scope: !270)
!294 = !DILocation(line: 102, column: 0, scope: !270)
!295 = !DILocation(line: 103, column: 0, scope: !270)
!296 = !DILocation(line: 104, column: 0, scope: !270)
!297 = !DILocation(line: 105, column: 0, scope: !270)
!298 = !DILocation(line: 106, column: 0, scope: !270)
!299 = !DILocation(line: 107, column: 0, scope: !270)
!300 = !DILocation(line: 108, column: 0, scope: !270)
!301 = !DILocation(line: 109, column: 0, scope: !270)
!302 = !DILocation(line: 111, column: 0, scope: !270)

; TBAA metadata
!0 = !{!"NOVA TBAA"}
!1 = !{!"list_data_ptr", !0}
!2 = !{!1, !1, i64 0}
!3 = !{!"list_elem", !0}
!4 = !{!3, !3, i64 0}
!5 = !{!"list_size", !0}
!6 = !{!5, !5, i64 0}
!90 = !{!"branch_weights", i32 2000, i32 1}
