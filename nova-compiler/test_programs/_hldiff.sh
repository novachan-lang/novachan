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
# UNIQUE temp paths per invocation. These were fixed paths (/tmp/hl_old.txt etc), which meant
# two agents running this concurrently RESTORED EACH OTHER'S MODULE CONTENT into the wrong
# file -- observed live as modules "clobbered with unrelated content". Never share a temp path
# in a script that can run in parallel.
TAG="$(echo "$MOD" | tr '/' '_')_$$"
OLDT="/tmp/hl_old_$TAG.txt"; NEWT="/tmp/hl_new_$TAG.txt"; SAVE="/tmp/hl_save_$TAG.nova"
[ -f "$EX" ] || { echo "DIFF-SKIP $MOD (no exercise program)"; exit 0; }
SRC="$REPO/$MOD.nova"
DST="$REPO/nova-compiler/$MOD.nova"
cp "$DST" "$SAVE"
build() { rm -f _hd.ll _hd.exe; ./gen3_test.exe "$EX" "_hd_$TAG.ll" >/dev/null 2>&1 \
  && clang -O1 -o "_hd_$TAG.exe" "_hd_$TAG.ll" ../compiler/nova_runtime.c -lws2_32 -lbcrypt -ladvapi32 -D_CRT_SECURE_NO_WARNINGS -w >/dev/null 2>&1 \
  && timeout 60 "./_hd_$TAG.exe" > "$1" 2>&1; }
( cd "$REPO" && git show "HEAD:$MOD.nova" > "$DST" 2>/dev/null )
build "$OLDT"; OLD=$?
cp "$SAVE" "$DST"
build "$NEWT"; NEW=$?
rm -f "_hd_$TAG.ll" "_hd_$TAG.exe"
if [ $OLD -ne 0 ] && [ $NEW -eq 0 ]; then echo "DIFF-IMPROVED $MOD (original crashed/failed, raised version runs)"; exit 0; fi
if diff -q "$OLDT" "$NEWT" >/dev/null 2>&1; then echo "DIFF-OK $MOD (byte-identical)"; exit 0; fi
echo "DIFF-CHANGED $MOD  <-- BEHAVIOUR CHANGED, investigate"
diff "$OLDT" "$NEWT" | head -12
exit 1
