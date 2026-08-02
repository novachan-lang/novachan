#!/bin/bash
# ASAN sweep: compile each test with the live compiler, link against the prebuilt
# ASAN runtime object, run it, and report only genuine sanitizer findings.
export NOVA_HOME="c:/Users/mange/Crypto/AI/New folder/New folder/nova-compiler"
export NOVA_NO_CACHE=1
mkdir -p _asan_out
pass=0; skip=0; found=0
for t in "$@"; do
  b=$(basename "$t" .nova)
  timeout 120 ./gen3_test.exe "$t" "_asan_out/$b.ll" >/dev/null 2>&1 || { skip=$((skip+1)); echo "  [skip-compile] $b"; continue; }
  EXTRA_OBJS=""
  grep -q "@sqlite3_" "_asan_out/$b.ll" && EXTRA_OBJS="_sqlite_asan.o"
  timeout 180 clang -O1 -g -fsanitize=address -o "_asan_out/$b.exe" "_asan_out/$b.ll" _rt_asan.o $EXTRA_OBJS \
      -lws2_32 -lbcrypt -ladvapi32 -w >/dev/null 2>&1 || { skip=$((skip+1)); echo "  [skip-link] $b"; continue; }
  out=$(timeout 90 "./_asan_out/$b.exe" 2>&1)
  if echo "$out" | grep -q "AddressSanitizer:"; then
    found=$((found+1))
    echo "### ASAN FINDING: $b"
    echo "$out" | grep -E "ERROR: AddressSanitizer|READ of|WRITE of|#[0-9] .*nova_(rt_|rc_|mem_|heap_)" | head -6
  else
    pass=$((pass+1))
  fi
done
echo "--- asan sweep: $pass clean, $found WITH FINDINGS, $skip skipped ---"
