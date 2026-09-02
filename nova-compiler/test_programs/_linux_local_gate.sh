#!/bin/bash
# Link + RUN cross-compiled NOVA tests on real Linux. Catches ELF/assembler and
# Linux-runtime faults BEFORE anything reaches CI.
SP="/mnt/c/Users/mange/AppData/Local/Temp/claude/c--Users-mange-Crypto-AI-New-folder-New-folder/95756d95-6c7b-4f8e-89f3-258795f1c59b/scratchpad"
CD="/mnt/c/Users/mange/Crypto/AI/New folder/New folder/nova-compiler/compiler"
cp "$CD/nova_runtime.c" /tmp/rt.c || exit 1
export NOVA_HOME="/mnt/c/Users/mange/Crypto/AI/New folder/New folder/nova-compiler"
PASS=0; FAIL=0; FAILED=""
for ll in "$SP"/lll/*.ll; do
  t=$(basename "$ll" .ll)
  if ! clang -O1 -o "/tmp/$t" "$ll" /tmp/rt.c -lpthread -ldl -lm -Wno-everything 2>/tmp/l_$t.log; then
    echo "LINK-FAIL $t :: $(grep -m1 error /tmp/l_$t.log | cut -c1-160)"
    FAIL=$((FAIL+1)); FAILED="$FAILED $t(LINK)"; continue
  fi
  timeout 60 "/tmp/$t" >/tmp/o_$t.log 2>&1
  rc=$?
  if [ $rc -eq 0 ]; then
    PASS=$((PASS+1))
  else
    echo "RUN-FAIL $t rc=$rc :: $(tail -2 /tmp/o_$t.log | tr '\n' ' ' | cut -c1-200)"
    FAIL=$((FAIL+1)); FAILED="$FAILED $t(RUN:$rc)"
  fi
done
echo "=== LINUX LOCAL GATE: $PASS PASS, $FAIL FAIL ==="
[ -n "$FAILED" ] && echo "failed:$FAILED"
