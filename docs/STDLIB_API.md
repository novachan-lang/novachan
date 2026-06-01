# NOVA Stdlib API Reference

Every function listed below is a built-in available in any `.nova` file without `import`. Signatures use NOVA's optional-annotation form. Generic type variables `T`, `U` appear lowercase in real signatures (NOVA's compiler infers them).

The runtime functions are implemented in `nova-compiler/test_programs/output/nova_runtime.c`. Total count: ~250 distinct stdlib entries grouped into the categories below.

## Contents

1. [I/O and console](#io-and-console)
2. [Strings](#strings)
3. [Lists](#lists)
4. [Dicts](#dicts)
5. [Sets](#sets)
6. [Math and numeric conversion](#math-and-numeric-conversion)
7. [Time and date](#time-and-date)
8. [Filesystem](#filesystem)
9. [Network](#network)
10. [HTTP](#http)
11. [Subprocess and environment](#subprocess-and-environment)
12. [Random](#random)
13. [Hashing and crypto](#hashing-and-crypto)
14. [Regex](#regex)
15. [JSON](#json)
16. [Bytes and buffers](#bytes-and-buffers)
17. [Iterators](#iterators)
18. [Concurrency](#concurrency)
19. [Tensors](#tensors)
20. [Result and Option](#result-and-option)
21. [Errors and assertions](#errors-and-assertions)
22. [Test framework](#test-framework)
23. [Specialized containers](#specialized-containers)
24. [Logging](#logging)
25. [Profiling and coverage](#profiling-and-coverage)
26. [Memory primitives](#memory-primitives)
27. [Package manager](#package-manager)
28. [Distributed (remote)](#distributed-remote)
29. [GPU](#gpu)
30. [WebAssembly](#webassembly)

---

## I/O and console

| Function | Signature | Description |
|---|---|---|
| `print(x)` | `T -> unit` | Write any value to stdout with newline. |
| `write_raw(s)` | `string -> unit` | Write a string to stdout without a newline. |
| `stdout_write(s)` | `string -> unit` | Same as `write_raw`. |
| `input()` | `() -> string` | Read a line from stdin (blocks). |
| `read_line()` | `() -> string` | Same as `input`. |
| `stdin_read_n(n)` | `int -> string` | Read exactly n bytes from stdin. |

## Strings

| Function | Signature | Description |
|---|---|---|
| `len(s)` | `string -> int` | Length in bytes. |
| `upper(s)` | `string -> string` | ASCII uppercase. |
| `lower(s)` | `string -> string` | ASCII lowercase. |
| `trim(s)` | `string -> string` | Strip leading and trailing whitespace. |
| `lstrip(s)` | `string -> string` | Strip leading whitespace. |
| `rstrip(s)` | `string -> string` | Strip trailing whitespace. |
| `split(s, sep)` | `string, string -> list<string>` | Split on separator. |
| `join(xs, sep)` | `list<string>, string -> string` | Join list with separator. |
| `replace(s, old, new)` | `string, string, string -> string` | Replace all occurrences. |
| `slice(s, a, b)` | `string, int, int -> string` | Substring `[a, b)`. |
| `find(s, sub)` | `string, string -> int` | Index of first match or -1. |
| `repeat(s, n)` | `string, int -> string` | Concatenate n copies. |
| `chars(s)` | `string -> list<string>` | Split into single-character strings. |
| `contains(s, sub)` | `string, string -> bool` | Substring containment. |
| `starts_with(s, p)` | `string, string -> bool` | Prefix test. |
| `ends_with(s, p)` | `string, string -> bool` | Suffix test. |
| `str_count(s, sub)` | `string, string -> int` | Non-overlapping match count. |
| `pad_left(s, n, ch)` | `string, int, int -> string` | Pad on left to width n with char ch. |
| `pad_right(s, n, ch)` | `string, int, int -> string` | Pad on right. |
| `center(s, n, ch)` | `string, int, int -> string` | Centre to width n. |
| `format(fmt, args)` | `string, list -> string` | C-style format. `%s`, `%d`, `%f`. |
| `ord(ch)` | `string -> int` | First byte as integer. |
| `chr(n)` | `int -> string` | Single-character string from byte. |
| `hex(n)` | `int -> string` | Hexadecimal representation. |
| `oct(n)` | `int -> string` | Octal representation. |
| `bin(n)` | `int -> string` | Binary representation. |
| `parse_int(s)` | `string -> int` | Decimal parse. |
| `parse_float(s)` | `string -> float` | Float parse. |

## Lists

| Function | Signature | Description |
|---|---|---|
| `len(xs)` | `list<T> -> int` | Element count. |
| `push(xs, v)` | `list<T>, T -> unit` | Append at end. |
| `range(n)` | `int -> list<int>` | `[0, 1, ..., n-1]`. |
| `range(a, b)` | `int, int -> list<int>` | `[a, a+1, ..., b-1]`. |
| `range(a, b, step)` | `int, int, int -> list<int>` | Strided range. |
| `sort(xs)` | `list<T> -> list<T>` | Stable sort (ascending). |
| `list_sort(xs)` | `list<T> -> list<T>` | Same as `sort`. |
| `sort_by(xs, key)` | `list<T>, T -> int -> list<T>` | Sort by key function. |
| `reverse(xs)` | `list<T> -> list<T>` | Reverse. |
| `list_reverse(xs)` | `list<T> -> list<T>` | Same as `reverse`. |
| `list_concat(a, b)` | `list<T>, list<T> -> list<T>` | Concatenation. |
| `list_slice(xs, a, b)` | `list<T>, int, int -> list<T>` | Range slice. |
| `list_create_filled(n, v)` | `int, T -> list<T>` | n copies of v. |
| `flatten(xss)` | `list<list<T>> -> list<T>` | Single-level flatten. |
| `enumerate(xs)` | `list<T> -> list<[int, T]>` | Pair each element with its index. |
| `zip(xs, ys)` | `list<T>, list<U> -> list<[T, U]>` | Zip two lists. |
| `map(xs, f)` | `list<T>, T -> U -> list<U>` | Eagerly map. |
| `filter(xs, p)` | `list<T>, T -> bool -> list<T>` | Eagerly filter. |
| `reduce(xs, f, init)` | `list<T>, (U, T) -> U, U -> U` | Left fold. |
| `sum(xs)` | `list<int> -> int` | Sum of ints. |
| `list_min(xs)` | `list<T> -> T` | Minimum. |
| `list_max(xs)` | `list<T> -> T` | Maximum. |
| `any(xs)` | `list<bool> -> bool` | At least one true. |
| `all(xs)` | `list<bool> -> bool` | All true. |
| `any_match(xs, p)` | `list<T>, T -> bool -> bool` | At least one matches predicate. |
| `all_match(xs, p)` | `list<T>, T -> bool -> bool` | All match predicate. |
| `index_of(xs, v)` | `list<T>, T -> int` | Index or -1. |

## Dicts

| Function | Signature | Description |
|---|---|---|
| `len(d)` | `dict<K, V> -> int` | Entry count. |
| `keys(d)` | `dict<K, V> -> list<K>` | All keys. |
| `values(d)` | `dict<K, V> -> list<V>` | All values. |
| `contains(d, k)` | `dict<K, V>, K -> bool` | Key present. |
| `del(d, k)` | `dict<K, V>, K -> unit` | Remove key. |
| `dict_merge(a, b)` | `dict, dict -> dict` | Right-biased merge. |

## Sets

| Function | Signature | Description |
|---|---|---|
| `set_create()` | `() -> set` | Empty set. |
| `set_add(s, v)` | `set, T -> bool` | Returns true if newly added. |
| `set_has(s, v)` | `set, T -> bool` | Membership. |
| `set_remove(s, v)` | `set, T -> bool` | Returns true if removed. |
| `set_len(s)` | `set -> int` | Cardinality. |
| `set_to_list(s)` | `set -> list<T>` | Materialise as a list. |

## Math and numeric conversion

| Function | Signature | Description |
|---|---|---|
| `abs(x)` | `T -> T` | Absolute value (int or float). |
| `min(a, b)` / `max(a, b)` | `T, T -> T` | Pairwise min/max. |
| `int(x)` | `T -> int` | Convert to int. |
| `float(x)` | `T -> float` | Convert to float. |
| `bool(x)` | `T -> bool` | Convert to bool (truthiness). |
| `str(x)` | `T -> string` | Convert to string. |
| `any_to_str(x)` | `T -> string` | Like `str` but more permissive. |
| `int_pow(b, e)` | `int, int -> int` | Integer exponentiation. |
| `sqrt(x)` | `float -> float` | Square root. |
| `pow(b, e)` | `float, float -> float` | Float exponentiation. |
| `floor(x)` | `float -> int` | Round toward -∞. |
| `ceil(x)` | `float -> int` | Round toward +∞. |
| `round(x)` | `float -> int` | Round to nearest (ties even). |
| `float_to_int(x)` | `float -> int` | Truncating conversion. |
| `int_to_float(x)` | `int -> float` | Exact conversion. |
| `checked_add(a, b)` | `int, int -> int` | Sum or set error on overflow. |
| `checked_sub(a, b)` | `int, int -> int` | Difference or error. |
| `checked_mul(a, b)` | `int, int -> int` | Product or error. |

## Time and date

| Function | Signature | Description |
|---|---|---|
| `time_ms()` | `() -> int` | Current Unix time in milliseconds. |
| `clock_ns()` | `() -> int` | High-resolution monotonic clock in nanoseconds. |
| `sleep(ms)` | `int -> unit` | Sleep for ms milliseconds. |
| `datetime_now()` | `() -> string` | ISO 8601 timestamp string. |
| `datetime_timestamp()` | `() -> int` | Seconds since epoch. |
| `datetime_format(ts, fmt)` | `int, string -> string` | strftime-style format. |
| `datetime_parse(s, fmt)` | `string, string -> int` | strptime-style parse to epoch. |
| `datetime_year/month/day/hour/minute/second/weekday(ts)` | `int -> int` | Components. |
| `datetime_diff(a, b)` | `int, int -> int` | a - b in seconds. |
| `datetime_add_days(ts, n)` | `int, int -> int` | Add days. |
| `datetime_add_hours(ts, n)` | `int, int -> int` | Add hours. |

## Filesystem

| Function | Signature | Description |
|---|---|---|
| `read_file(path)` | `string -> string` | Read whole file as string. |
| `write_file(path, content)` | `string, string -> unit` | Replace file with content. |
| `append_file(path, content)` | `string, string -> unit` | Append to file. |
| `read_bytes(path)` | `string -> bytes` | Raw byte array. |
| `file_exists(path)` | `string -> bool` | Existence test. |
| `path_exists(path)` | `string -> int` | 1 if exists. |
| `mkdir(path)` | `string -> int` | Create one directory. |
| `mkdir_p(path)` | `string -> int` | Create with intermediates. |
| `path_join(a, b)` | `string, string -> string` | Platform-aware join. |
| `path_parent(path)` | `string -> string` | Containing directory. |
| `path_name(path)` | `string -> string` | Base name. |
| `path_ext(path)` | `string -> string` | Extension including leading dot. |
| `cwd()` | `() -> string` | Current working directory. |
| `list_dir(path)` | `string -> list<string>` | Single-level listing. |
| `dir_walk(path)` | `string -> list<string>` | Recursive walk. |

## Network

| Function | Signature | Description |
|---|---|---|
| `tcp_connect(host, port)` | `string, int -> int` | Returns a TCP handle. |
| `tcp_listen(port)` | `int -> int` | Bind and listen on port. |
| `tcp_accept(server)` | `int -> int` | Accept next client. |
| `tcp_send(client, data)` | `int, string -> int` | Bytes sent or -1. |
| `tcp_recv(client)` | `int -> string` | Read until close or zero. |
| `tcp_close(handle)` | `int -> unit` | Close handle. |
| `udp_bind(port)` | `int -> int` | Open a UDP socket. |
| `udp_send(sock, host, port, data)` | `int, string, int, string -> int` | Send datagram. |
| `udp_recv(sock)` | `int -> string` | Receive one datagram. |

## HTTP

| Function | Signature | Description |
|---|---|---|
| `http_get(url)` | `string -> string` | GET, returns body (or error sets flag). |
| `http_post(url, body, content_type)` | `string, string, string -> string` | POST. |
| `http_listen(port)` | `int -> int` | Low-level listener. |
| `http_accept_raw(server)` | `int -> [int, string]` | Returns `[client_fd, raw_request]`. |
| `http_read_request(client)` | `int -> string` | Read full HTTP/1.1 request. |
| `http_send_raw(client, resp)` | `int, string -> unit` | Write raw response. |

## Subprocess and environment

| Function | Signature | Description |
|---|---|---|
| `system(cmd)` | `string -> int` | Run via shell, return exit code. |
| `exec(cmd)` | `string -> string` | Run, capture stdout. |
| `shell(cmd)` | `string -> string` | Same as `exec`. |
| `env(name)` | `string -> string` | Get environment variable. |
| `set_env(name, value)` | `string, string -> int` | Set env in current process. |
| `args()` | `() -> list<string>` | argv. |
| `exit(code)` | `int -> never` | Process exit. |
| `cpu_count()` | `() -> int` | Logical CPU count. |

## Random

| Function | Signature | Description |
|---|---|---|
| `random_int(lo, hi)` | `int, int -> int` | Uniform in [lo, hi]. |
| `random_float()` | `() -> float` | Uniform in [0.0, 1.0). |
| `random_bytes(n)` | `int -> string` | Cryptographically strong random bytes. |

## Hashing and crypto

| Function | Signature | Description |
|---|---|---|
| `hash(x)` | `T -> int` | 64-bit hash of any value. |
| `hex_encode(s)` | `string -> string` | Lowercase hex of bytes. |
| `hex_decode(s)` | `string -> string` | Reverse of `hex_encode`. |

For SHA-256, AES, or other cryptographic primitives, use the `sentinel` framework (see `FRAMEWORKS.md`).

## Regex

| Function | Signature | Description |
|---|---|---|
| `regex_match(s, pat)` | `string, string -> bool` | Whole-string match. |
| `regex_find(s, pat)` | `string, string -> string` | First match (empty if none). |
| `regex_replace(s, pat, rep)` | `string, string, string -> string` | Replace all matches. |
| `regex_split(s, pat)` | `string, string -> list<string>` | Split on pattern. |

Pattern syntax: a subset of PCRE — `.`, `*`, `+`, `?`, `[...]`, `^`, `$`, `\d`, `\w`, `\s`, `|`, `(...)`.

## JSON

| Function | Signature | Description |
|---|---|---|
| `json_parse(s)` | `string -> any` | Parse to a dict/list/string/float/bool. |
| `json_stringify(x)` | `T -> string` | Serialise. |

## Bytes and buffers

| Function | Signature | Description |
|---|---|---|
| `bytes(n)` | `int -> bytes` | Allocate n zero bytes. |
| `bytes_create(n)` | `int -> bytes` | Same. |
| `bytes_get(b, i)` | `bytes, int -> int` | Byte at index. |
| `bytes_set(b, i, v)` | `bytes, int, int -> unit` | Mutate byte. |
| `bytes_len(b)` | `bytes -> int` | Length. |
| `bytes_slice(b, a, c)` | `bytes, int, int -> bytes` | `[a, c)` slice. |
| `bytes_to_str(b)` | `bytes -> string` | Reinterpret as UTF-8. |
| `str_to_bytes(s)` | `string -> bytes` | UTF-8 byte array. |
| `buffer()` | `() -> buffer` | Empty string builder. |
| `buffer_cap(n)` | `int -> buffer` | Pre-sized builder. |
| `buf_append(b, s)` | `buffer, string -> unit` | Append string. |
| `buf_append_char/int/float(b, v)` | `buffer, ? -> unit` | Append by type. |
| `buf_str(b)` / `buf_to_str(b)` | `buffer -> string` | Build string. |
| `buf_len(b)` | `buffer -> int` | Current byte length. |
| `buf_clear(b)` | `buffer -> unit` | Reset to empty. |

`buffer` is O(1) amortised append — use it for any loop that builds a string.

## Iterators

Lazy iterators over a list, range, or chain. They produce one value at a time and avoid materialising intermediate lists.

| Function | Signature | Description |
|---|---|---|
| `iter(xs)` | `list<T> -> iter<T>` | List → iterator. |
| `iter_range(a, b)` | `int, int -> iter<int>` | Range iterator. |
| `iter_range_step(a, b, s)` | `int, int, int -> iter<int>` | Strided. |
| `iter_map(it, f)` | `iter<T>, T -> U -> iter<U>` | Lazy map. |
| `iter_filter(it, p)` | `iter<T>, T -> bool -> iter<T>` | Lazy filter. |
| `iter_take(it, n)` | `iter<T>, int -> iter<T>` | First n. |
| `iter_skip(it, n)` | `iter<T>, int -> iter<T>` | Drop first n. |
| `iter_zip(a, b)` | `iter, iter -> iter` | Pair-wise zip. |
| `iter_chain(a, b)` | `iter, iter -> iter` | Concatenate two iterators. |
| `iter_enumerate(it)` | `iter<T> -> iter<[int, T]>` | Add indices. |
| `iter_flat_map(it, f)` | `iter, T -> iter -> iter` | Map then flatten. |
| `iter_next(it)` | `iter<T> -> Option<T>` | One step. |
| `iter_collect(it)` | `iter<T> -> list<T>` | Materialise. |
| `iter_reduce(it, init, f)` | `iter<T>, U, (U, T) -> U -> U` | Left fold. |
| `iter_for_each(it, f)` | `iter<T>, T -> unit -> unit` | Side-effect loop. |
| `iter_count(it)` | `iter -> int` | Consume and count. |
| `iter_sum(it)` | `iter<int> -> int` | Consume and sum. |
| `iter_any(it, p)` | `iter<T>, T -> bool -> bool` | Short-circuit any. |
| `iter_all(it, p)` | `iter<T>, T -> bool -> bool` | Short-circuit all. |
| `iter_find(it, p)` | `iter<T>, T -> bool -> Option<T>` | First match. |

## Concurrency

| Function | Signature | Description |
|---|---|---|
| `channel()` | `() -> channel<T>` | Unbuffered channel. |
| `send(ch, v)` | `channel<T>, T -> unit` | Send (blocks if no receiver). |
| `receive(ch)` | `channel<T> -> T` | Receive (blocks). |
| `recv(ch)` | `channel<T> -> T` | Same as `receive`. |
| `recv_timeout(ch, ms)` | `channel<T>, int -> T` | Receive with timeout. |
| `close(ch)` | `channel<T> -> unit` | Close (further receives return zero / signal). |
| `select(chs)` | `list<channel> -> any` | Wait on any of the listed channels. |
| `monitor(p)` | `process<T> -> any` | Watch a process for exit. |
| `process_link(a, b)` | `process, process -> unit` | Link processes for cascade. |
| `process_monitor(a, b)` | `process, process -> int` | Set up a monitor reference. |
| `process_demonitor(ref)` | `int -> unit` | Tear down monitor. |
| `process_exit_notify(p, msg)` | `process, T -> unit` | Send a message on exit. |
| `pmap(xs, f)` | `list<T>, T -> U -> list<U>` | Parallel map. |
| `pfilter(xs, p)` | `list<T>, T -> bool -> list<T>` | Parallel filter. |
| `pfor(start, end, body)` | `int, int, int -> unit -> unit` | Parallel for-loop. |
| `async(f)` | `T -> any` | Schedule as task. |
| `await(t)` | `any -> T` | Block until task resolves. |
| `await_all(ts)` | `list -> list` | Await all. |
| `await_any(ts)` | `list -> any` | Await first. |

## Tensors

| Function | Signature | Description |
|---|---|---|
| `tensor_zeros(shape)` | `list<int> -> tensor` | All-zero tensor. |
| `tensor_from_list(data, shape)` | `list<float>, list<int> -> tensor` | Materialise tensor. |
| `tensor_shape(t)` | `tensor -> list<int>` | Shape vector. |
| `tensor_size(t)` | `tensor -> int` | Total element count. |
| `tensor_rank(t)` | `tensor -> int` | Number of dimensions. |
| `tensor_get(t, idx)` | `tensor, list<int> -> float` | Element. |
| `tensor_set(t, idx, v)` | `tensor, list<int>, float -> unit` | In-place set. |
| `tensor_add(a, b)` | `tensor, tensor -> tensor` | Element-wise sum. |
| `tensor_mul(a, b)` | `tensor, tensor -> tensor` | Element-wise product. |
| `tensor_scale(t, k)` | `tensor, float -> tensor` | Scalar multiply. |
| `tensor_matmul(a, b)` | `tensor, tensor -> tensor` | Matrix multiplication. |
| `tensor_sum(t)` | `tensor -> float` | Sum of all elements. |
| `tensor_relu(t)` | `tensor -> tensor` | Element-wise max(0, x). |
| `tensor_to_list(t)` | `tensor -> list<float>` | Flat list. |

## Result and Option

| Function | Signature | Description |
|---|---|---|
| `ok(v)` | `T -> Result<T, E>` | Successful value. |
| `err(e)` | `E -> Result<T, E>` | Failure. |
| `is_ok(r)` | `Result -> bool` | Success test. |
| `is_err(r)` | `Result -> bool` | Failure test. |
| `unwrap(r)` | `Result<T, E> -> T` | Extract or error. |
| `unwrap_err(r)` | `Result<T, E> -> E` | Extract error or error. |
| `unwrap_or(r, default)` | `Result<T, E>, T -> T` | Default on err. |
| `result_tag(r)` | `Result -> int` | 0 = ok, 1 = err. |
| `result_map(r, f)` | `Result<T, E>, T -> U -> Result<U, E>` | Map ok side. |
| `result_map_err(r, f)` | `Result<T, E>, E -> F -> Result<T, F>` | Map err side. |
| `and_then(r, f)` | `Result<T, E>, T -> Result<U, E> -> Result<U, E>` | Monadic bind. |
| `or_else(r, f)` | `Result<T, E>, E -> Result<T, F> -> Result<T, F>` | Recover on err. |
| `some(v)` | `T -> Option<T>` | Wrap value. |
| `none()` | `() -> Option<T>` | Empty option. |
| `is_some(o)` / `is_none(o)` | `Option -> bool` | Discriminate. |

## Errors and assertions

| Function | Signature | Description |
|---|---|---|
| `error(msg)` | `string -> any` | Set the thread-local error flag. |
| `assert(cond, msg)` | `bool, string -> unit` | Fail with message if false. |
| `assert_eq(a, b)` | `T, T -> int` | Returns 1 on pass, 0 on fail. |
| `assert_ne(a, b)` | `T, T -> int` | Inequality. |
| `assert_true(x)` / `assert_false(x)` | `bool -> int` | Truth. |
| `assert_near(a, b, eps)` | `float, float, float -> int` | Float approx. |
| `assert_approx(a, b, eps)` | `float, float, float -> int` | Synonym. |
| `assert_contains(coll, v)` | `any, any -> int` | Membership. |
| `assert_throws(thunk, msg)` | `() -> T, string -> int` | Expect an error. |

## Test framework

| Function | Signature | Description |
|---|---|---|
| `test_run(name, body)` | `string, () -> unit -> int` | Run a named test. |
| `test_run_tap(name, body, idx)` | `string, () -> unit, int -> int` | TAP output. |
| `test_summary()` | `() -> int` | Print pass/fail summary, return exit code. |
| `test_reset()` | `() -> int` | Reset state. |

## Specialized containers

### Priority queue (min-heap)

| Function | Signature |
|---|---|
| `pq_create()` | `() -> pq` |
| `pq_push(q, priority, v)` | `pq, int, T -> unit` |
| `pq_pop(q)` | `pq -> T` |
| `pq_peek(q)` | `pq -> T` |
| `pq_peek_priority(q)` | `pq -> int` |
| `pq_len(q)` / `pq_is_empty(q)` | size / empty |

### Deque

| Function | Signature |
|---|---|
| `deque_create()` | `() -> deque` |
| `deque_push_back(d, v)` / `deque_push_front` | append on either end |
| `deque_pop_back(d)` / `deque_pop_front(d)` | pop either end |
| `deque_front(d)` / `deque_back(d)` | peek without pop |
| `deque_get(d, i)` | random access |
| `deque_len(d)` / `deque_is_empty(d)` / `deque_to_list(d)` | meta |

### Sorted string-map (smap)

| Function | Signature |
|---|---|
| `smap_create()` | `() -> smap` |
| `smap_set/get/has/del` | string → value ops |
| `smap_len(m)` / `smap_keys(m)` / `smap_values(m)` | iteration |
| `smap_range(m, lo, hi)` | key range scan |

### LRU cache

| Function | Signature |
|---|---|
| `lru_create(cap)` | `int -> lru` |
| `lru_get(c, k)` / `lru_has(c, k)` / `lru_put(c, k, v)` | normal cache ops |
| `lru_len(c)` / `lru_cap(c)` | size info |
| `lru_hits(c)` / `lru_misses(c)` | hit counters |

### Counter (multiset)

| Function | Signature |
|---|---|
| `counter_create()` | `() -> counter` |
| `counter_inc(c, k)` | bump by 1 |
| `counter_add(c, k, n)` | bump by n |
| `counter_get(c, k)` | count of k |
| `counter_total(c)` | sum of all counts |
| `counter_most_common(c, n)` | top-n keys |

### Ring buffer

| Function | Signature |
|---|---|
| `ringbuf_create(cap)` | `int -> ringbuf` |
| `ringbuf_push(r, v)` / `ringbuf_pop(r)` | enqueue / dequeue |
| `ringbuf_len(r)` / `ringbuf_cap(r)` / `ringbuf_is_full(r)` | meta |

## Logging

| Function | Signature | Description |
|---|---|---|
| `log_trace/debug/info/warn/error/fatal(msg, ctx)` | `string, any -> unit` | Six log levels. |
| `log_set_level(n)` | `int -> unit` | Threshold (0 = trace, 5 = fatal). |
| `log_get_level()` | `() -> int` | Current threshold. |
| `log_set_json(flag)` | `int -> unit` | Toggle JSON output. |

## Profiling and coverage

| Function | Signature | Description |
|---|---|---|
| `prof_enter(name)` | `string -> int` | Begin a sample region. |
| `prof_exit(name)` | `string -> int` | End the region. |
| `prof_dump()` | `() -> unit` | Print profile to stderr. |
| `cov_hit(file, line)` | `string, int -> int` | Mark a line as executed. |
| `cov_dump()` | `() -> unit` | Print coverage. |

## Memory primitives

| Function | Signature | Description |
|---|---|---|
| `set_arena_mode(flag)` | `int -> unit` | Globally enable arena mode (all RC no-op). |
| `is_arena_mode()` | `() -> bool` | Query. |
| `arena_create()` | `() -> arena` | New bump arena. |
| `arena_alloc(a, n)` | `arena, int -> ptr` | Allocate from arena. |
| `arena_reset(a)` | `arena -> unit` | Reset cursor. |
| `arena_free(a)` | `arena -> unit` | Free the arena. |
| `arena_used(a)` | `arena -> int` | Bytes used. |
| `list_free_local(xs)` | `list<T> -> int` | Track 8 W5 manual drop. |
| `dict_free_local(d)` | `dict -> int` | Track 8 W5 manual drop. |
| `alloc_count()` / `live_count()` | `() -> int` | Total allocs / currently alive. |
| `rc_stats_dump()` | `() -> unit` | Print rc_inc / rc_dec counters. |
| `weak_create(v)` | `T -> weak` | Weak reference. |
| `weak_upgrade(w)` | `weak -> Option<T>` | Try to get strong ref. |
| `weak_alive(w)` | `weak -> bool` | Liveness check. |
| `weak_invalidate(w)` | `weak -> unit` | Mark stale. |

## Package manager

| Function | Signature | Description |
|---|---|---|
| `semver_parse(s)` | `string -> [major, minor, patch]` | Parse. |
| `semver_compare(a, b)` | `string, string -> int` | Standard compare. |
| `semver_satisfies(v, range)` | `string, string -> bool` | Range test. |
| `semver_format(v)` | `string -> string` | Canonical form. |
| `lockfile_read(path)` | `string -> any` | Parse a `nova.lock`. |
| `lockfile_write(path, data)` | `string, any -> int` | Write a lockfile. |
| `pkg_resolve(deps, registry)` | `any, any -> any` | Solve dependencies. |

## Distributed (remote)

| Function | Signature | Description |
|---|---|---|
| `node_listen(port)` | `int -> node` | Start a node service. |
| `node_connect(addr)` | `string -> node` | Connect to a remote node. |
| `remote_send(node, v)` | `node, T -> int` | Send to remote node. |
| `remote_recv(node)` | `node -> T` | Receive. |
| `remote_close(node)` | `node -> unit` | Close. |
| `remote_spawn(node, fn, args)` | `node, string, list -> int` | Spawn process on remote. |
| `serialize(v)` | `T -> bytes` | Stable binary form. |
| `deserialize(b)` | `bytes -> T` | Reverse. |

## GPU

| Function | Signature | Description |
|---|---|---|
| `gpu_available()` | `() -> bool` | Detect GPU runtime. |
| `gpu_vadd_floats(a, b)` | `list<float>, list<float> -> list<float>` | Element-wise add (sample kernel). |

The GPU runtime is currently OpenCL-backed where available; falls back to CPU.

## WebAssembly

NOVA can compile a subset of itself to WebAssembly. The runtime exposes:

| Function | Signature | Description |
|---|---|---|
| (loaded via `phase12_wasm_gpu_test.nova`) | | WASM module load/call helpers. |

See `nova-compiler/test_programs/phase12_wasm_gpu_test.nova` for the working example.

## Domain modules (Phase 11/13)

Shipped as standalone, fully-tested NOVA source modules under
`nova-compiler/test_programs/`. Each is self-contained and compiles with the
bundled compiler. Copy the module into your project or import the functions you need.

### `math3d` — 3D linear algebra

Vectors are float lists (`[x,y,z]`); `mat4` is a flat 16-float row-major list.

| Function | Description |
|---|---|
| `v3(x,y,z)`, `v3_add/sub`, `v3_scale(v,s)` | vec3 construction & arithmetic |
| `v3_dot`, `v3_cross`, `v3_length`, `v3_normalize` | products, magnitude, unit (zero-safe) |
| `v3_lerp(a,b,t)`, `v3_distance(a,b)` | interpolation, distance |
| `v2`, `v2_add/sub`, `v2_dot`, `v2_length` | vec2 ops |
| `mat4_identity`, `mat4_mul(a,b)` | 4×4 matrix, general multiply |
| `mat4_translate(x,y,z)`, `mat4_scale(x,y,z)`, `mat4_transform_v3(m,v)` | transforms |
| `deg_to_rad`, `rad_to_deg`, `clampf(v,lo,hi)` | helpers |

### `ecs` — Entity-Component-System

| Function | Description |
|---|---|
| `world_new()` | create a world |
| `entity_create(w)` | fresh monotonic entity id (never reused) |
| `entity_destroy(w,eid)` / `entity_alive(w,eid)` | lifecycle (alive-gated) |
| `component_set/get/has(w,eid,name,...)` | attach/read components |
| `entities_with(w,name)` | query eids having a component |
| `entity_count(w)` | living entity count |

### `crypto_util` — high-level crypto

Wraps the `sha256` / `hmac_sha256` / `crc32` / `base64` / `random_bytes` builtins.
`crc32` is CRC-32/ISO-HDLC correct (`crc32("123456789")==0xCBF43926`).

| Function | Description |
|---|---|
| `hash_hex(s)` | SHA-256 hex |
| `checksum(s)` | CRC-32 int |
| `hmac_sign(key,msg)` / `hmac_verify(key,msg,sig)` | HMAC-SHA256 sign/verify |
| `b64(s)` / `b64_decode_to_str(b)` | base64 round-trip |
| `token(n)` | random hex token |

### `netutil` — HTTP/URL parsing (no sockets needed)

| Function | Description |
|---|---|
| `parse_host_port("h:p")` | `[host, port_int]` |
| `build_http_request(method,path,host)` | HTTP/1.1 request string |
| `parse_http_status_line(line)` | `[version, code_int, reason]` |
| `parse_query_string("a=1&b=2")` | dict of string values |
| `url_join(base,path)` | single-slash join |
| `ip_to_int(ip)` / `int_to_ip(n)` | 32-bit round-trip |

### `compress_rle` — run-length compression

| Function | Description |
|---|---|
| `rle_encode(s)` / `rle_decode(s)` | unambiguous RLE; `decode(encode(x))==x` for all ASCII |
| `bytes_pack(ints)` / `bytes_unpack(s)` | int-list ↔ string (bytes 1..255) |

> **Float note for module authors:** NOVA's `float()` builtin must not be used to
> coerce a value that may already be a float (it reinterprets the bits). Use
> `x * 1.0` for a correct int-or-float → float coercion. The domain modules
> follow this via a local `_f(x)` helper.

---

For non-stdlib helpers shipped as separate modules (Forge HTTP server, Cortex AI, Pulse data pipeline, Mesh distributed, Sentinel security, Ops devops, Reactor games, Prism GUI, Edge embedded), see `FRAMEWORKS.md`.
