/* Direct C harness for the builtin soundness sweep.
   Every case below crashed or corrupted memory before the fix. Built against
   nova_runtime.c so it exercises the real runtime with no compiler involved. */
#include <stdio.h>
#include <stdint.h>
#include <string.h>

void    nova_rt_init(void);
int64_t nova_rt_list_create(void);
int64_t nova_rt_list_append(int64_t, int64_t);
int64_t nova_rt_dict_create(void);
int64_t nova_rt_dict_set(int64_t, int64_t, int64_t);
int64_t nova_rt_create_string(void*);

int64_t nova_rt_list_flatten_map(int64_t);
int64_t nova_rt_str_truncate_ellipsis(int64_t, int64_t);
int64_t nova_rt_str_mul(int64_t, int64_t);
int64_t nova_rt_str_repeat_each(int64_t, int64_t);
int64_t nova_rt_str_replace_n(int64_t, int64_t, int64_t, int64_t);
int64_t nova_rt_str_tab_to_spaces(int64_t, int64_t);
int64_t nova_rt_str_pad_both(int64_t, int64_t, int64_t);
int64_t nova_rt_math_gcd(int64_t, int64_t);
int64_t nova_rt_math_lcm(int64_t, int64_t);
int64_t nova_rt_list_max_by_abs(int64_t);
int64_t nova_rt_list_min_by_abs(int64_t);
int64_t nova_rt_dict_to_query_string(int64_t);
int64_t nova_rt_dict_values_flat(int64_t);
int64_t nova_rt_list_sum_int(int64_t);
int64_t nova_rt_str_byte_count(int64_t);

static int pass = 0, fail = 0;
static void ck(int cond, const char* what) {
    if (cond) { pass++; }
    else { printf("FAIL %s\n", what); fail++; }
}
#define S(x) nova_rt_create_string((void*)(x))
static const char* cs(int64_t h) { return (const char*)(uintptr_t)h; }
static int streq(const char* a, const char* b) { return a && b && strcmp(a,b)==0; }

int main(void) {
    nova_rt_init();

    /* ---- wrong-type handles into container builtins ---------------------- */
    /* Before: elements 1,2,3 were cast to NovaList* and ->size read => deref
       of 0x1/0x2/0x3. Guaranteed segfault. */
    int64_t ints = nova_rt_list_create();
    nova_rt_list_append(ints, 1);
    nova_rt_list_append(ints, 2);
    nova_rt_list_append(ints, 3);
    int64_t fm = nova_rt_list_flatten_map(ints);
    ck(fm != 0, "flatten_map(list of scalars) survived");

    /* genuine nested list must still flatten */
    int64_t inner = nova_rt_list_create();
    nova_rt_list_append(inner, 7);
    nova_rt_list_append(inner, 8);
    int64_t outer = nova_rt_list_create();
    nova_rt_list_append(outer, inner);
    int64_t fm2 = nova_rt_list_flatten_map(outer);
    ck(nova_rt_list_sum_int(fm2) == 15, "flatten_map(nested) == 15");

    /* a scalar / string handed to list+dict builtins must not fault */
    ck(nova_rt_list_sum_int(42) == 0,            "list_sum_int(raw scalar) -> 0");
    ck(nova_rt_list_max_by_abs(42) == -1,        "list_max_by_abs(raw scalar) -> -1");
    ck(nova_rt_dict_values_flat(42) != 0,        "dict_values_flat(raw scalar) survived");
    int64_t str_h = S("not a list");
    ck(nova_rt_list_sum_int(str_h) == 0,         "list_sum_int(string handle) -> 0");
    ck(nova_rt_dict_to_query_string(str_h) != 0, "dict_to_query_string(string) survived");
    ck(nova_rt_list_flatten_map(str_h) != 0,     "flatten_map(string handle) survived");

    /* a list handed to a string builtin */
    ck(nova_rt_str_byte_count(ints) == 0,        "str_byte_count(list handle) -> 0");

    /* ---- negative length: buf[-5] = 0 heap underflow --------------------- */
    int64_t te = nova_rt_str_truncate_ellipsis(S("hello world"), -5);
    ck(te != 0, "truncate_ellipsis(-5) survived");
    int64_t te2 = nova_rt_str_truncate_ellipsis(S("hello world"), 8);
    ck(cs(te2) && strlen(cs(te2)) == 8, "truncate_ellipsis(8) len == 8");

    /* ---- size-arithmetic overflow: undersized malloc + full write loop ---- */
    ck(nova_rt_str_mul(S("ab"), (int64_t)1 << 62) != 0, "str_mul huge n refused safely");
    ck(streq(cs(nova_rt_str_mul(S("ab"), 3)), "ababab"), "str_mul normal == ababab");
    ck(nova_rt_str_repeat_each(S("abc"), (int64_t)1 << 62) != 0, "repeat_each huge n safe");
    ck(streq(cs(nova_rt_str_repeat_each(S("abc"), 2)), "aabbcc"), "repeat_each == aabbcc");
    ck(nova_rt_str_tab_to_spaces(S("a\tb"), (int64_t)1 << 62) != 0, "tab_to_spaces huge n safe");

    /* buf_cap was sized from max_n, the copy loop from real matches */
    ck(nova_rt_str_replace_n(S("aaa"), S("a"), S("bbbb"), 9223372036854775807LL) != 0,
       "replace_n huge max_n safe");
    ck(streq(cs(nova_rt_str_replace_n(S("aaa"), S("a"), S("bb"), 2)), "bbbba"),
       "replace_n normal == bbbba");

    /* ---- dict_to_query_string: memcpy len was unbounded by the 4096 buf --- */
    {
        char big[9000];
        for (int i = 0; i < 8999; i++) big[i] = 'k';
        big[8999] = 0;
        int64_t d = nova_rt_dict_create();
        nova_rt_dict_set(d, S(big), 1);
        ck(nova_rt_dict_to_query_string(d) != 0, "query_string with 9000-byte key survived");
    }

    /* ---- null fill / null subject in pad_both ---------------------------- */
    ck(nova_rt_str_pad_both(S("ab"), 6, S("-")) != 0, "pad_both normal");
    ck(nova_rt_str_pad_both(0, 6, 0) != 0,            "pad_both(null,null) survived");

    /* ---- INT64_MIN negation UB ------------------------------------------- */
    ck(nova_rt_math_gcd(12, 18) == 6,   "gcd(12,18) == 6");
    ck(nova_rt_math_gcd(-12, 18) == 6,  "gcd(-12,18) == 6");
    ck(nova_rt_math_gcd(INT64_MIN, 6) == 2, "gcd(INT64_MIN,6) == 2");
    ck(nova_rt_math_lcm(4, 6) == 12,    "lcm(4,6) == 12");
    ck(nova_rt_math_lcm(INT64_MIN, 6) > 0, "lcm(INT64_MIN,6) positive (saturated)");

    int64_t mn = nova_rt_list_create();
    nova_rt_list_append(mn, 5);
    nova_rt_list_append(mn, INT64_MIN);
    nova_rt_list_append(mn, 7);
    ck(nova_rt_list_max_by_abs(mn) == 1, "max_by_abs finds INT64_MIN as largest magnitude");
    ck(nova_rt_list_min_by_abs(mn) == 0, "min_by_abs finds 5 as smallest magnitude");

    printf("\nsoundness harness: %d passed, %d failed\n", pass, fail);
    return fail == 0 ? 0 : 1;
}
