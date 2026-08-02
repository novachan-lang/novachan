#!/bin/bash
set -u
SRC="$1"; TST="$2"; OUT=/tmp/novalinux; mkdir -p $OUT
cp "$SRC/nova_runtime.c" $OUT/ && cp "$TST/_linux_oa_test.c" $OUT/
cd $OUT
gcc -O1 -g -o oatest _linux_oa_test.c nova_runtime.c -lpthread -lm -w 2>&1 | head -20
[ -x ./oatest ] || { echo "LINK FAILED"; exit 1; }
./oatest; echo "EXIT=$?"
