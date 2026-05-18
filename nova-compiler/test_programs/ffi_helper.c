#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

// Simple C functions callable from NOVA via @extern

int64_t c_add(int64_t a, int64_t b) {
    return a + b;
}

int64_t c_multiply(int64_t a, int64_t b) {
    return a * b;
}

int64_t c_strlen_nova(int64_t str_ptr) {
    const char* s = (const char*)(uintptr_t)str_ptr;
    if (!s) return 0;
    return (int64_t)strlen(s);
}

int64_t c_to_upper(int64_t str_ptr) {
    const char* s = (const char*)(uintptr_t)str_ptr;
    if (!s) return (int64_t)(uintptr_t)"";
    size_t len = strlen(s);
    char* result = (char*)malloc(len + 1);
    if (!result) return (int64_t)(uintptr_t)"";
    for (size_t i = 0; i < len; i++) {
        result[i] = (s[i] >= 'a' && s[i] <= 'z') ? s[i] - 32 : s[i];
    }
    result[len] = 0;
    return (int64_t)(uintptr_t)result;
}
