#!/bin/bash
# BEHAVIOUR DIFF — the safety net that makes a fast raise safe.
# Compiles an exercise program against the ORIGINAL module (from git HEAD) and against the
# WORKING-TREE module, then diffs the output. Identical output = the raise preserved behaviour.
#
# Usage: ./_hldiff.sh <std/path/mod> <exercise.nova>
#   ./_hldiff.sh std/core/list _listdiff.nova
cd "$(dirname "$0")"
export NOVA_HOME="c:/Users/mange/Crypto/AI/New folder/New folder/nova-compiler"
export NOVA_NO_CACHE=1
REPO="c:/Users/mange/Crypto/AI/New folder/New folder"
MOD="$1"; EX="$2"
[ -f "$EX" ] || { echo "DIFF-SKIP $MOD (no exercise program)"; exit 0; }
SRC="$REPO/$MOD.nova"
DST="$REPO/nova-compiler/$MOD.nova"
cp "$DST" /tmp/hl_new.nova
build() { rm -f _hd.ll _hd.exe; ./gen3_test.exe "$EX" _hd.ll >/dev/null 2>&1 \
  && clang -O1 -o _hd.exe _hd.ll ../compiler/nova_runtime.c -lws2_32 -lbcrypt -ladvapi32 -D_CRT_SECURE_NO_WARNINGS -w >/dev/null 2>&1 \
  && timeout 60 ./_hd.exe > "$1" 2>&1; }
( cd "$REPO" && git show "HEAD:$MOD.nova" > "$DST" 2>/dev/null )
build /tmp/hl_old.txt; OLD=$?
cp /tmp/hl_new.nova "$DST"
build /tmp/hl_new.txt; NEW=$?
rm -f _hd.ll _hd.exe
if [ $OLD -ne 0 ] && [ $NEW -eq 0 ]; then echo "DIFF-IMPROVED $MOD (original crashed/failed, raised version runs)"; exit 0; fi
if diff -q /tmp/hl_old.txt /tmp/hl_new.txt >/dev/null 2>&1; then echo "DIFF-OK $MOD (byte-identical)"; exit 0; fi
echo "DIFF-CHANGED $MOD  <-- BEHAVIOUR CHANGED, investigate"
diff /tmp/hl_old.txt /tmp/hl_new.txt | head -12
exit 1
