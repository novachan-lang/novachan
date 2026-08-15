/* NOVA minimal WASM runtime — compute-only, no IO/threads.
   All NOVA runtime functions that a pure-compute program might link against
   resolve to no-op stubs here. The host (JS) provides exit() via WASI. */

#include <stdint.h>

/* WASI exit — provided by the JS host */
void __wasi_proc_exit(int code);

void exit(int code) { __wasi_proc_exit(code); for(;;); }

/* The error globals are defined in the NOVA-generated .ll for WASM mode. */

/* Stubs: NOVA's IR-pipeline emits declares for many runtime functions even
   if the program doesn't use them. For pure-compute programs, these are
   never called — but the linker still needs them to resolve. */
/* ── Stack-depth guard (the ONLY overflow containment available here) ───────────
   Native targets contain a hardware stack overflow: SEH on Windows, a sigaltstack
   SIGSEGV handler on POSIX. WASM has NEITHER -- no signals, no SEH -- so an unbounded
   recursion hits the engine's own stack limit and becomes an opaque trap that takes the
   whole instance down with no diagnostic. This counter is what makes it a REPORTED,
   contained failure instead.

   It is emitted ONLY for wasm32/freestanding: adding a load/increment/compare/store to
   every function prologue and epilogue on native would be a permanent throughput cost for
   a hazard the guard page already catches for free. */
static int64_t nova_wasm_depth = 0;
static int64_t nova_wasm_depth_max = 8000;   /* well under a default 1MB engine stack */
int64_t nova_rt_stack_overflowed = 0;        /* readable by the host after a trap-free exit */

void nova_rt_stack_enter(void) {
    if (++nova_wasm_depth > nova_wasm_depth_max) {
        nova_rt_stack_overflowed = 1;
        nova_wasm_depth = 0;
        /* TRAP rather than exit(). Two reasons, both learned by measurement:
           - exit() routes through __wasi_proc_exit, so the guard would only work on a WASI
             host; a plain browser/embedder has no such import. The guard must not depend on
             one particular host ABI.
           - A JS host that throws from proc_exit does NOT unwind the wasm frames, so control
             returned into the `for(;;)` spin in exit() and the module HUNG instead of failing.
             A hang is strictly worse than the trap it was meant to replace.
           __builtin_trap lowers to the wasm `unreachable` instruction: immediate, host-agnostic,
           and reported as a clean RuntimeError. The exported nova_rt_stack_overflowed flag is
           what lets the host tell OUR guard apart from the engine running out of stack. */
        __builtin_trap();
    }
}

void nova_rt_stack_exit(void) {
    if (nova_wasm_depth > 0) --nova_wasm_depth;
}

int64_t nova_rt_stack_limit(int64_t n) {
    if (n > 0) nova_wasm_depth_max = n;
    return nova_wasm_depth_max;
}

/* ── REAL implementations, NOT stubs ──────────────────────────────────────────────
   Found 2026-08-15 by the first cross-target comparison ever run: `i % 2` returned 0 on
   wasm while native returned the right answer, so a Collatz loop took the even branch
   every time (16 steps native, 8 on wasm) and an odd-counter returned 0 instead of 5.

   The mechanism is worse than a wrong stub, and it is the reason this file must define
   every pure-scalar runtime function explicitly:
     1. nova_rt_mod was not defined here at all;
     2. `-Wl,--allow-undefined` makes the linker emit an undefined symbol as a wasm
        IMPORT rather than failing the link;
     3. the JS harness fills EVERY unresolved import with `() => 0n`.
   Net effect: any runtime function this file forgets silently becomes "returns 0" at
   instantiation, with no link error, no trap, and no test failure. Verified directly --
   the module's import list was exactly [env.nova_rt_mod].

   The permanent guard against the whole class is the import-count assertion in
   _wasm_exec_gate.ps1, not this one definition: a value comparison only catches the
   functions a test happens to exercise, whereas an unexpected import is caught for
   every function whether exercised or not.

   Semantics mirror nova_runtime.c:6976 exactly, INCLUDING the b == -1 special case,
   which exists to avoid the INT64_MIN % -1 undefined behaviour rather than for maths. */
int64_t nova_rt_mod(int64_t a, int64_t b) {
    if (b == 0) return 0;
    if (b == -1) return 0;
    return a % b;
}

#define STUB(name, sig) int64_t nova_rt_##name sig { return 0; }
#define STUB_VOID(name, sig) void nova_rt_##name sig { }

STUB(list_create, (void))
STUB(deep_copy, (int64_t a))
STUB(list_create_filled, (int64_t a, int64_t b))
STUB(list_append, (int64_t a, int64_t b))
STUB(list_get, (int64_t a, int64_t b))
STUB(list_len, (int64_t a))
STUB(dict_create, (void))
STUB(dict_set, (int64_t a, int64_t b, int64_t c))
STUB(dict_get, (int64_t a, int64_t b))
STUB(dict_contains, (int64_t a, int64_t b))
STUB(str_concat, (int64_t a, int64_t b))
STUB(int_to_str, (int64_t a))
STUB(parse_int, (int64_t a))
STUB(len, (int64_t a))
STUB(len_any, (int64_t a))
STUB(ord, (int64_t a))
STUB(chr, (int64_t a))
STUB(contains, (int64_t a, int64_t b))
STUB(index_get, (int64_t a, int64_t b))
STUB(index_set, (int64_t a, int64_t b, int64_t c))
int64_t nova_rt_add(int64_t a, int64_t b) { return a + b; }
int64_t nova_rt_sub(int64_t a, int64_t b) { return a - b; }
int64_t nova_rt_mul(int64_t a, int64_t b) { return a * b; }
int64_t nova_rt_div(int64_t a, int64_t b) { return b == 0 ? 0 : a / b; }
int64_t nova_rt_eq(int64_t a, int64_t b) { return a == b ? 1 : 0; }
int64_t nova_rt_neq(int64_t a, int64_t b) { return a != b ? 1 : 0; }
int64_t nova_rt_abs(int64_t a) { return a < 0 ? -a : a; }
int64_t nova_rt_max(int64_t a, int64_t b) { return a > b ? a : b; }
int64_t nova_rt_min(int64_t a, int64_t b) { return a < b ? a : b; }
STUB(any_to_str, (int64_t a))
STUB(read_file, (int64_t a))
STUB(write_file, (int64_t a, int64_t b))
STUB(args, (void))
STUB(split, (int64_t a, int64_t b))
STUB(join, (int64_t a, int64_t b))
STUB(upper, (int64_t a))
STUB(lower, (int64_t a))
STUB(trim, (int64_t a))
STUB(replace, (int64_t a, int64_t b, int64_t c))
STUB(starts_with, (int64_t a, int64_t b))
STUB(ends_with, (int64_t a, int64_t b))
STUB(print_any, (int64_t a))
STUB(print_bool, (int64_t a))
STUB(print_float, (int64_t a))
STUB(print_int, (int64_t a))
STUB(print_str, (int64_t a))
STUB(float_bits, (int64_t a))
STUB(float_to_str, (int64_t a))
STUB(slice, (int64_t a, int64_t b, int64_t c))
STUB(slice_any, (int64_t a, int64_t b, int64_t c))
STUB(repeat, (int64_t a, int64_t b))
STUB(chars, (int64_t a))
STUB(time_ms, (void))
STUB(clock_ns, (void))
STUB_VOID(sleep_ms, (int64_t a))
STUB(type_of, (int64_t a))
STUB(range, (int64_t a))
STUB(range_from_to, (int64_t a, int64_t b))
STUB(dict_keys, (int64_t a))
STUB(dict_values, (int64_t a))
STUB(dict_items, (int64_t a))
STUB(for_iter_init, (int64_t a))
STUB(dict_has, (int64_t a, int64_t b))
STUB(dict_del, (int64_t a, int64_t b))
STUB(system, (int64_t a))
STUB(exec, (int64_t a))
STUB(create_string, (const char* a))
STUB(channel_create, (void))
STUB(channel_send, (int64_t a, int64_t b))
STUB(channel_send_move, (int64_t a, int64_t b))
STUB(channel_recv, (int64_t a))
STUB(channel_close, (int64_t a))
STUB(channel_select, (int64_t a, int64_t b))
STUB(select, (int64_t a))
STUB(channel_recv_timeout, (int64_t a, int64_t b))
STUB(spawn, (int64_t a, int64_t b))
STUB(monitor, (int64_t a))
STUB(parse_float, (int64_t a))
STUB(read_line, (void))
STUB(append_file, (int64_t a, int64_t b))
STUB(file_exists, (int64_t a))
STUB(find, (int64_t a, int64_t b))
STUB(list_concat, (int64_t a, int64_t b))
STUB(list_reverse, (int64_t a))
STUB(list_sort, (int64_t a))
STUB(list_slice, (int64_t a, int64_t b, int64_t c))
STUB(list_map, (int64_t a, int64_t b))
STUB(list_filter, (int64_t a, int64_t b))
STUB(http_get, (int64_t a))
STUB(http_post, (int64_t a, int64_t b, int64_t c))
STUB(mkdir, (int64_t a))
STUB(mkdir_p, (int64_t a))
STUB(path_join, (int64_t a, int64_t b))
STUB(path_exists, (int64_t a))
STUB(path_parent, (int64_t a))
STUB(path_name, (int64_t a))
STUB(read_bytes, (int64_t a))
STUB(write_raw, (int64_t a))
/* abs/max/min defined above with real semantics. */
STUB(sqrt, (int64_t a))
STUB(floor, (int64_t a))
STUB(ceil, (int64_t a))
STUB(pow, (int64_t a, int64_t b))
STUB(round, (int64_t a))
STUB(sin, (int64_t a))
STUB(cos, (int64_t a))
STUB(tan, (int64_t a))
STUB(log, (int64_t a))
STUB(log2, (int64_t a))
STUB(log10, (int64_t a))
STUB(exp, (int64_t a))
STUB(fabs, (int64_t a))
STUB(fmax, (int64_t a, int64_t b))
STUB(fmin, (int64_t a, int64_t b))
STUB(fmod, (int64_t a, int64_t b))
STUB(float_to_int, (int64_t a))
STUB(int_to_float, (int64_t a))
STUB(to_int, (int64_t a))
STUB(to_float, (int64_t a))
STUB(env, (int64_t a))
STUB(random_int, (int64_t a, int64_t b))
STUB(random_float, (void))
STUB(json_parse, (int64_t a))
STUB(json_stringify, (int64_t a))
STUB(regex_match, (int64_t a, int64_t b))
STUB(regex_find, (int64_t a, int64_t b))
STUB(regex_replace, (int64_t a, int64_t b, int64_t c))
STUB(regex_split, (int64_t a, int64_t b))
STUB(path_ext, (int64_t a))
STUB(tcp_connect, (int64_t a, int64_t b))
STUB(tcp_listen, (int64_t a))
STUB(tcp_accept, (int64_t a))
STUB(tcp_send, (int64_t a, int64_t b))
STUB(tcp_recv, (int64_t a))
STUB_VOID(tcp_close, (int64_t a))
STUB(bytes_create, (int64_t a))
STUB(bytes_get, (int64_t a, int64_t b))
STUB_VOID(bytes_set, (int64_t a, int64_t b, int64_t c))
STUB(bytes_len, (int64_t a))
STUB(bytes_slice, (int64_t a, int64_t b, int64_t c))
STUB(bytes_to_str, (int64_t a))
STUB(str_to_bytes, (int64_t a))
STUB(asin, (int64_t a))
STUB(acos, (int64_t a))
STUB(atan, (int64_t a))
STUB(atan2, (int64_t a, int64_t b))
STUB(int_pow, (int64_t a, int64_t b))
STUB(alloc_count, (void))
STUB(live_count, (void))
STUB(enumerate, (int64_t a))
STUB(zip, (int64_t a, int64_t b))
STUB(reduce, (int64_t a, int64_t b, int64_t c))
STUB(any_match, (int64_t a, int64_t b))
STUB(all_match, (int64_t a, int64_t b))
STUB(sum, (int64_t a))
STUB(index_of, (int64_t a, int64_t b))
STUB(sort_by, (int64_t a, int64_t b))
STUB(dict_merge, (int64_t a, int64_t b))
STUB(str_count, (int64_t a, int64_t b))
STUB(lstrip, (int64_t a))
STUB(rstrip, (int64_t a))
STUB(pad_left, (int64_t a, int64_t b, int64_t c))
STUB(pad_right, (int64_t a, int64_t b, int64_t c))
STUB(cwd, (void))
STUB(list_dir, (int64_t a))
STUB(hash, (int64_t a))
STUB(flatten, (int64_t a))
STUB(pmap, (int64_t a, int64_t b))
STUB(pfilter, (int64_t a, int64_t b))
STUB(pfor, (int64_t a, int64_t b, int64_t c))
STUB(cpu_count, (void))
STUB(http_listen, (int64_t a))
STUB(http_accept_raw, (int64_t a))
STUB_VOID(http_send_raw, (int64_t a, int64_t b))
STUB_VOID(exit, (int64_t a))
STUB_VOID(assert, (int64_t a, int64_t b))

/* puts/printf/strcmp — referenced by NOVA's runtime declares */
int puts(const char* s) { return 0; }
int printf(const char* fmt, ...) { return 0; }
int strcmp(const char* a, const char* b) { return 0; }
