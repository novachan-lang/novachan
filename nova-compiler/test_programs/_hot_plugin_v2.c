#include <stdint.h>
#ifdef _WIN32
  #define EXPORT __declspec(dllexport)
#else
  #define EXPORT __attribute__((visibility("default")))
#endif
EXPORT int64_t hot_add(int64_t a, int64_t b) { return a + b + 1000; }
EXPORT int64_t hot_mul(int64_t a, int64_t b) { return a * b * 2; }
EXPORT int64_t hot_version(void) { return 2; }
