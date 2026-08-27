#!/usr/bin/env bash
# TIER 2 -- run the FULL NOVA test suite on a POSIX host (Linux / macOS).
#
# WHY THIS EXISTS. The linux-selfhosted / macos-selfhosted jobs run a HAND-LISTED 60-test core
# suite. That was never a design choice, it was a limitation: those jobs never synced forge/ and
# prism/ into $NOVA_HOME/lib, so ANY test doing `import forge...` could not resolve and had to be
# left out. Windows runs all ~3,590 because _proc_util.ps1 does that sync. So "NOVA works on
# three platforms" really meant "the COMPILER works on three platforms" -- the whole library and
# framework surface was Windows-only.
#
# Deliberately written in bash rather than reusing _run_final_regression.ps1. pwsh does exist on
# the runners, but that script is threaded with Windows-isms -- literal "$PSScriptRoot\..\x"
# backslash paths (on Unix `\` is a filename character, not a separator), .exe names, and
# ws2_32/advapi32 link flags. Porting it blind, with no local pwsh to test against, would be a
# guess. This reimplements the same contract in a way that can actually be reasoned about.
#
# CONTRACT: compile -> link -> run, assert exit 0 and no "FAIL assert" in output. One result file
# per test so a parallel run stays tallyable, and kill-on-timeout on every binary -- a hung test
# must never wedge the runner.
set -uo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$REPO_ROOT/nova-compiler"
export NOVA_HOME="$(pwd)"
export NOVA_NO_CACHE=1

NOVA="$NOVA_HOME/compiler/nova"
RUNTIME_SRC="$NOVA_HOME/compiler/nova_runtime.c"
[ -x "$NOVA" ] || { echo "::error title=posix-full::compiler not built at $NOVA"; exit 1; }

# ── platform-specific link flags ───────────────────────────────────────────────────────────
# The Windows equivalent is $NovaLinkFlags = "-lws2_32 -ladvapi32" in _proc_util.ps1. macOS folds
# pthread and dl into libSystem, so naming them is at best redundant and at worst an error.
case "$(uname -s)" in
  Darwin) LINKF="-lm"; EXTRA_CFLAGS="-D_DARWIN_C_SOURCE" ;;
  *)      LINKF="-lpthread -ldl -lm"; EXTRA_CFLAGS="" ;;
esac

# ── portable kill-on-timeout (macOS has no GNU `timeout`) ──────────────────────────────────
if   command -v timeout  >/dev/null 2>&1; then TMO() { timeout "$@"; }
elif command -v gtimeout >/dev/null 2>&1; then TMO() { gtimeout "$@"; }
else TMO() { perl -e 'alarm shift; exec @ARGV' "$@"; }
fi

# ── install the framework into the toolchain stdlib ────────────────────────────────────────
# Mirrors _proc_util.ps1: forge/ and prism/ are FLATTENED into $NOVA_HOME/lib (every module has a
# globally-unique prefix, so `import forge_html` resolves from anywhere). std/ is already tracked
# under nova-compiler/std, so it needs no copy.
mkdir -p "$NOVA_HOME/lib"
cp -f "$REPO_ROOT"/forge/*.nova "$NOVA_HOME/lib/" 2>/dev/null || true
find "$REPO_ROOT/prism" -name '*.nova' -exec cp -f {} "$NOVA_HOME/lib/" \; 2>/dev/null || true
echo "lib/ modules: $(ls "$NOVA_HOME"/lib/*.nova 2>/dev/null | wc -l)  std/ modules: $(find "$NOVA_HOME/std" -name '*.nova' 2>/dev/null | wc -l)"

cd "$NOVA_HOME/test_programs"
OUT=_posix_res
rm -rf "$OUT"; mkdir -p "$OUT"

# ── pre-compile the shared objects once ────────────────────────────────────────────────────
# Same reason the PowerShell harness does it: recompiling nova_runtime.c (and the ~250k-line
# sqlite3 amalgamation) per test would dominate wall time entirely.
echo "pre-compiling runtime + sqlite3 ..."
clang -c -O2 $EXTRA_CFLAGS "$RUNTIME_SRC" -o "$OUT/nova_runtime.o" -w 2>"$OUT/_rt.log" \
  || { echo "::error title=posix-full::runtime pre-compile FAILED"; tail -5 "$OUT/_rt.log"; exit 1; }
SQLITE_SRC="$NOVA_HOME/compiler/sqlite3.c"
SQLITE_OBJ=""
if [ -f "$SQLITE_SRC" ]; then
  if clang -c -O2 -DSQLITE_THREADSAFE=0 "$SQLITE_SRC" -o "$OUT/sqlite3.o" -w 2>"$OUT/_sq.log"; then
    SQLITE_OBJ="$OUT/sqlite3.o"
  else
    echo "::notice title=posix-full::sqlite3 pre-compile failed; sqlite FFI tests will fail to link"
  fi
fi

# ── enumerate tests ────────────────────────────────────────────────────────────────────────
# A test is a .nova with its own main(). Everything else in this directory is a helper MODULE
# that is imported, not run -- compiling those as programs would produce meaningless failures.
: > "$OUT/_tests.txt"
for f in *.nova; do
  [ -f "$f" ] || continue
  t="${f%.nova}"
  grep -qE '^fn main\(' "$f" || continue
  case "$t" in
    # Known-broken and EXCLUDED ON WINDOWS TOO (see _remote_gate.ps1) -- they hang or assume a
    # spawn-dispatch protocol node_recv does not provide. Excluding them here keeps this job
    # measuring the port, not re-reporting a defect Windows already tracks separately.
    distributed_serialize_test|distributed_spawn_test) continue ;;
  esac
  echo "$t" >> "$OUT/_tests.txt"
done
TOTAL=$(wc -l < "$OUT/_tests.txt" | tr -d ' ')
echo "discovered $TOTAL runnable tests"

# ── run one test ───────────────────────────────────────────────────────────────────────────
run_one() {
  local t="$1"
  local ll="$OUT/$t.ll" exe="$OUT/$t.bin" log="$OUT/$t.log"
  if ! "$NOVA" compile -o "$ll" "$t.nova" >"$log" 2>&1; then echo "COMPILE" >"$OUT/$t.res"; return; fi
  if ! clang -O2 $EXTRA_CFLAGS -o "$exe" "$ll" "$OUT/nova_runtime.o" $SQLITE_OBJ $LINKF -w >>"$log" 2>&1; then
    echo "LINK" >"$OUT/$t.res"; return
  fi
  if TMO 25 "./$exe" >>"$log" 2>&1; then
    if grep -q "FAIL assert" "$log" 2>/dev/null; then echo "ASSERT" >"$OUT/$t.res"; else echo "PASS" >"$OUT/$t.res"; fi
  else
    local c=$?
    # 124 = GNU timeout, 142 = 128+SIGALRM from the perl fallback. Both mean "hung".
    if [ "$c" -eq 124 ] || [ "$c" -eq 142 ]; then echo "TIMEOUT" >"$OUT/$t.res"; else echo "RUN($c)" >"$OUT/$t.res"; fi
  fi
  rm -f "$ll" "$exe"
}
export -f run_one
export OUT NOVA LINKF EXTRA_CFLAGS SQLITE_OBJ
export -f TMO 2>/dev/null || true

JOBS="$(getconf _NPROCESSORS_ONLN 2>/dev/null || echo 2)"
echo "running with $JOBS parallel workers ..."
# `xargs -P` because a SERIAL pass over ~3,500 tests would run for hours and risk the job cap.
xargs -P "$JOBS" -I{} bash -c 'run_one "$@"' _ {} < "$OUT/_tests.txt"

# ── tally ──────────────────────────────────────────────────────────────────────────────────
PASS=0; FAIL=0; FAILED=""
while read -r t; do
  r="$(cat "$OUT/$t.res" 2>/dev/null || echo 'NORESULT')"
  if [ "$r" = "PASS" ]; then PASS=$((PASS+1)); else FAIL=$((FAIL+1)); FAILED="$FAILED $t($r)"; fi
done < "$OUT/_tests.txt"

echo "=== POSIX FULL SUITE: $PASS PASS, $FAIL FAIL (of $TOTAL) ==="
echo "::notice title=posix full suite::$PASS PASS, $FAIL FAIL of $TOTAL on $(uname -s)"
if [ "$FAIL" -gt 0 ]; then
  SHOWN=$(echo "$FAILED" | tr ' ' '\n' | grep -v '^$' | head -40 | tr '\n' ' ')
  echo "::error title=posix full suite failures (first 40 of $FAIL)::$SHOWN"
  echo "FAILURES:$FAILED"
  exit 1
fi
