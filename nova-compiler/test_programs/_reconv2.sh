#!/bin/bash
cd "$(dirname "$0")"
export NOVA_HOME="c:/Users/mange/Crypto/AI/New folder/New folder/nova-compiler" NOVA_NO_CACHE=1
SRC=../compiler/nova_compiler.nova
RT=../compiler/nova_runtime.c
LK="-lws2_32 -lbcrypt -ladvapi32 -D_CRT_SECURE_NO_WARNINGS -w"
echo "[$(date +%T)] gen4c -> gen5b"
rm -f _gen5b.ll _gen5b.exe _gen6b.ll
timeout 2400 ./_gen4c.exe $SRC _gen5b.ll || { echo FAIL-gen5; exit 1; }
timeout 2400 clang -O1 -o _gen5b.exe _gen5b.ll $RT $LK || { echo FAIL-link; exit 1; }
echo "[$(date +%T)] gen5b -> gen6b"
timeout 2400 ./_gen5b.exe $SRC _gen6b.ll || { echo FAIL-gen6; exit 1; }
echo "[$(date +%T)] compare"
if cmp -s _gen5b.ll _gen6b.ll; then
  echo "RECONVERGED: gen5b.ll == gen6b.ll ($(wc -c < _gen5b.ll) bytes)"
else
  echo "DIVERGED"; echo "  gen5b=$(wc -c < _gen5b.ll) gen6b=$(wc -c < _gen6b.ll)"; exit 1
fi
