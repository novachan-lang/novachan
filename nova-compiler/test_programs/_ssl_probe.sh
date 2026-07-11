#!/bin/bash
base="/mnt/c/Users/mange/Crypto/AI/New folder/New folder/nova-compiler/test_programs"
cd /tmp || exit 1
cp "$base/../compiler/nova_runtime.c" .
echo "compiling nova_runtime.c WITH -DNOVA_HAVE_OPENSSL (OpenSSL 3.x)..."
gcc -O2 -DNOVA_HAVE_OPENSSL -c nova_runtime.c -o nrt_ssl.o 2>/tmp/ssl_err.txt
echo "EXIT=$?"
echo "--- error count ---"
grep -c "error:" /tmp/ssl_err.txt
echo "--- first 25 diagnostic lines ---"
head -25 /tmp/ssl_err.txt
