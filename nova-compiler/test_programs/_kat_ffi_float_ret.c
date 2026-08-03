/* C host for the extern float-return KAT. */
double ffi_half(double x)      { return x * 0.5; }
double ffi_const_pi(void)      { return 3.14159; }
long long ffi_add(long long a, long long b) { return a + b; }
