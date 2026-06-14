/* iter-77: minimal C library linked into NOVA via @link_source("foo.c").
   Uses 64-bit ints (long long) to match NOVA's i64-everywhere calling convention
   exactly on both Windows (LLP64: long long = 64-bit) and Linux (LP64). With i64
   params + i64 return, the FFI needs no marshaling wrapper -- the NOVA call lowers
   straight to `call @foo_add`, and this object provides the symbol. */
long long foo_add(long long a, long long b) {
    return a + b;
}
