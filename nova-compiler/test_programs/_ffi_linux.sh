#!/bin/bash
set -u
SRC="$1"; TST="$2"; OUT=/tmp/novaffi; mkdir -p $OUT
cp "$SRC/nova_runtime.c" $OUT/ && cp "$TST/_fb_linux.o" $OUT/ && cp "$TST/_ffi_byval_host.c" $OUT/
cd $OUT
gcc -O1 -o ffitest _fb_linux.o _ffi_byval_host.c nova_runtime.c -lpthread -lm -w 2>&1 | head -8
[ -x ./ffitest ] || { echo "BUILD FAILED"; exit 1; }
echo "arch=$(uname -m)  (SysV: <=16-byte structs go in REGISTERS, not by reference)"
./ffitest
