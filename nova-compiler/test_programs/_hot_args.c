#include <stdint.h>
#ifdef _WIN32
  #define EXPORT __declspec(dllexport)
#else
  #define EXPORT __attribute__((visibility("default")))
#endif
EXPORT int64_t hot_calc(int64_t a, int64_t b, int64_t c) { return a * b + c; }
EXPORT int64_t hot_id(int64_t x) { return x; }
