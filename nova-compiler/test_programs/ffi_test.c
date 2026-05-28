#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

extern int64_t nova_rt_create_string(const char* data, int64_t len);

int64_t c_add(int64_t a, int64_t b) {
    return a + b;
}

int64_t c_multiply(int64_t a, int64_t b) {
    return a * b;
}

int64_t c_strlen_nova(int64_t s) {
    const char* str = (const char*)(uintptr_t)s;
    if (!str) return 0;
    return (int64_t)strlen(str);
}

int64_t c_to_upper(int64_t s) {
    const char* str = (const char*)(uintptr_t)s;
    if (!str) return nova_rt_create_string("", 0);
    size_t len = strlen(str);
    char* buf = (char*)malloc(len + 1);
    if (!buf) return nova_rt_create_string("", 0);
    for (size_t i = 0; i < len; i++) {
        buf[i] = (char)toupper((unsigned char)str[i]);
    }
    buf[len] = '\0';
    int64_t result = nova_rt_create_string(buf, (int64_t)len);
    free(buf);
    return result;
}
