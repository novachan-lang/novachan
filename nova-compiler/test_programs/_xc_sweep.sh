#!/bin/bash
# Phase B of the Linux portability sweep (invoked by _xc_sweep.ps1 via wsl bash).
# $1 = the /mnt path to the test_programs dir. Builds nova_runtime.o once, then for
# each test name in _xcs_list.txt: links its linux .o + runs it (kill-on-timeout),
# from the test dir so relative file inputs resolve. A test PASSES iff it exits 0.
base="$1"
mkdir -p /tmp/novaxc
cd /tmp/novaxc || exit 1
cp "$base/output/nova_runtime.c" .
echo "building nova_runtime.o (linux gcc, once)..."
if ! gcc -O2 -c nova_runtime.c -o nrt.o 2>/tmp/nrt_cc.err; then
  echo NRT_BUILD_FAIL
  tail -20 /tmp/nrt_cc.err
  exit 1
fi
echo "runtime built. linking + running tests..."
pass=0
fail=0
while IFS= read -r name; do
  name="${name%$'\r'}"          # strip a trailing CR (Windows CRLF in the list file)
  [ -z "$name" ] && continue
  if ! cp "$base/${name}__lx.o" /tmp/novaxc/ 2>/dev/null; then
    echo "RESULT $name NOOBJ"
    fail=$((fail+1))
    continue
  fi
  if gcc "/tmp/novaxc/${name}__lx.o" /tmp/novaxc/nrt.o -o "/tmp/novaxc/${name}__lx" -lpthread -lm -ldl 2>/tmp/lk.err; then
    out=$(cd "$base" && timeout 30 "/tmp/novaxc/${name}__lx" 2>&1)
    code=$?
    if [ $code -eq 0 ]; then
      echo "RESULT $name PASS"
      pass=$((pass+1))
    else
      echo "RESULT $name RUNFAIL=$code :: $(echo "$out" | tail -1)"
      fail=$((fail+1))
    fi
  else
    echo "RESULT $name LINKFAIL :: $(tail -1 /tmp/lk.err)"
    fail=$((fail+1))
  fi
done < "$base/_xcs_list.txt"
echo "SWEEP_TALLY pass=$pass fail=$fail"
