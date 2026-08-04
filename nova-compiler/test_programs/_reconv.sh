#!/bin/bash
# 3-pass reconverge: gen4 -> gen5 -> gen6, require gen5.ll == gen6.ll (byte-identical fixpoint).
cd "$(dirname "$0")"
export NOVA_HOME="c:/Users/mange/Crypto/AI/New folder/New folder/nova-compiler" NOVA_NO_CACHE=1
SRC=../compiler/nova_compiler.nova
RT=../compiler/nova_runtime.c
LK="-lws2_32 -lbcrypt -ladvapi32 -D_CRT_SECURE_NO_WARNINGS -w"
echo "[$(date +%T)] gen4 -> gen5.ll"
rm -f _gen5.ll _gen5.exe _gen6.ll
timeout 1800 ./_gen4.exe $SRC _gen5.ll || { echo "FAIL: gen4 could not compile the compiler"; exit 1; }
timeout 1800 clang -O1 -o _gen5.exe _gen5.ll $RT $LK || { echo "FAIL: gen5 link"; exit 1; }
echo "[$(date +%T)] gen5 -> gen6.ll"
timeout 1800 ./_gen5.exe $SRC _gen6.ll || { echo "FAIL: gen5 could not compile the compiler"; exit 1; }
echo "[$(date +%T)] comparing"
if cmp -s _gen5.ll _gen6.ll; then
    echo "RECONVERGED: gen5.ll == gen6.ll  ($(wc -c < _gen5.ll) bytes)"
else
    echo "DIVERGED: gen5.ll != gen6.ll"
    echo "  gen5=$(wc -c < _gen5.ll)  gen6=$(wc -c < _gen6.ll)"
    diff <(head -50000 _gen5.ll) <(head -50000 _gen6.ll) | head -20
    exit 1
fi
