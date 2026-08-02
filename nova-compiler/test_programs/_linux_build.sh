#!/bin/bash
# Build + test the NOVA runtime on Linux. The object space's POSIX halves
# (mmap/mprotect/MAP_NORESERVE, posix_memalign, pthread_mutex) had NEVER been
# compiled before this script existed.
set -u
SRC="$1"          # directory containing nova_runtime.c
OUT=/tmp/novalinux
mkdir -p $OUT
cp "$SRC/nova_runtime.c" $OUT/ 2>/dev/null || { echo "COPY FAIL"; exit 1; }
echo "=== gcc -c (object space POSIX paths) ==="
gcc -c -O2 -o $OUT/rt.o $OUT/nova_runtime.c -w 2>&1 | head -25
echo "CC_EXIT=${PIPESTATUS[0]}"
ls -la $OUT/rt.o 2>/dev/null | head -1
