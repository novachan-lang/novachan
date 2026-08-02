#!/bin/bash
set -u
SRC="$1"; TST="$2"; OUT=/tmp/novalinux; mkdir -p $OUT
cp "$SRC/nova_runtime.c" $OUT/ && cp "$TST/_linux_oa_test.c" $OUT/
cd $OUT
echo "=== gcc + AddressSanitizer (Linux) ==="
rm -f oatest_asan
gcc -O1 -g -fsanitize=address -o oatest_asan _linux_oa_test.c nova_runtime.c -lpthread -lm -w 2>&1 | head -15
rm -f ./oatest_asan.prev; [ -x ./oatest_asan ] || { echo "ASAN BUILD FAILED (not running a stale binary)"; exit 1; }
./oatest_asan 2>&1 | tail -25
echo "ASAN_EXIT=${PIPESTATUS[0]}"
echo "=== gcc -Wall -Wextra (second-opinion warnings on the object space) ==="
gcc -c -O2 -o /dev/null nova_runtime.c -Wall -Wextra 2>&1 | grep -iE "nova_oa_|object space|warning: .*(uninitial|overflow|bounds)" | head -12
echo "(warning scan done)"
