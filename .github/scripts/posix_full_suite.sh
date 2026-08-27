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

# ── enumerate tests: use the SAME canonical list Windows runs ──────────────────────────────
# The first version of this script globbed every .nova with its own main(). That was wrong, and
# the first macOS run proved it: 3771 "tests" discovered vs the 3590 Windows actually runs, and
# 205 failures dominated by files that are NOT positive tests --
#   * NEGATIVE tests (_aroute_nopath_neg, _atest_paramneg, _enum_payload_bad_test) where a
#     COMPILE FAILURE IS THE PASS CONDITION, scored here as a failure
#   * benchmarks (_bench_dispatch, _hof_bench, _cyc_overhead) that blow a 25s cap by design
#   * probes and scratch programs never meant to be gated
# The explicit arrays in _run_final_regression.ps1 exist precisely to make those distinctions.
# Reproducing the heuristic was never going to work; read the real list instead, so POSIX and
# Windows gate the IDENTICAL set and a difference in results means a platform difference.
python3 - "$NOVA_HOME/test_programs" > "$OUT/_tests.txt" <<'PYEOF'
import re, sys, os
tp = sys.argv[1]
src = open(os.path.join(tp, '_run_final_regression.ps1'), encoding='utf-8', errors='ignore').read()
names = []
for arr in ('core_tests','track7_tests','new_tests','domain_tests','concurrency_tests','server_tests'):
    m = re.search(r'\$' + arr + r'\s*=\s*@\((.*?)\)', src, re.S)
    if not m:
        continue
    names += [a or b for a, b in re.findall(r"'([^']+)'|\"([^\"]+)\"", m.group(1))]
mf = os.path.join(tp, '_orphan_coverage_manifest.txt')
if os.path.isfile(mf):
    for line in open(mf, encoding='utf-8', errors='ignore'):
        n = line.strip()
        if n and not n.startswith('#'):
            names.append(n)
# Excluded on Windows too (see _remote_gate.ps1): these hang or assume a spawn-dispatch
# protocol node_recv does not provide. Keeping them out means this job measures THE PORT
# rather than re-reporting a defect Windows already tracks separately.
skip = {'distributed_serialize_test', 'distributed_spawn_test'}
# SERVER tests must run SERIALLY. _run_final_regression.ps1 separates them for a documented
# reason: "they each run their OWN in-process green TCP server + client (real I/O). Running
# many concurrently starves the green server's scheduling under CPU load -> intermittent
# failures (they each pass reliably given the box to themselves)."
# Running them in the parallel pool is what produced the TIMEOUT cluster (demo_http_server_test,
# real_http_api, forge_ws_echo_test, forge_p256_test...) in the first clean POSIX run.
srv = re.search(r'\$server_tests\s*=\s*@\((.*?)\)', src, re.S)
server = set()
if srv:
    server = {a or b for a, b in re.findall(r"'([^']+)'|\"([^\"]+)\"", srv.group(1))}
seen = set()
par, ser = [], []
for n in names:
    if n in skip or n in seen:
        continue
    if not os.path.isfile(os.path.join(tp, n + '.nova')):
        continue          # absent source: Windows fails these loudly; here it is not our subject
    seen.add(n)
    (ser if n in server else par).append(n)
with open(os.path.join(tp, '_posix_res', '_serial.txt'), 'w') as f:
    f.write("\n".join(ser) + ("\n" if ser else ""))
sys.stderr.write("parallel=%d serial=%d\n" % (len(par), len(ser)))
for n in par:
    print(n)
PYEOF
TOTAL=$(( $(wc -l < "$OUT/_tests.txt" | tr -d ' ') + $(wc -l < "$OUT/_serial.txt" 2>/dev/null | tr -d ' ') ))
echo "canonical test list: $TOTAL tests (same source of truth as the Windows harness)"
[ "$TOTAL" -gt 3000 ] || { echo "::error title=posix-full::only $TOTAL tests resolved -- list extraction is broken, refusing to report a misleadingly small run"; exit 1; }

# ── run one test ───────────────────────────────────────────────────────────────────────────
# Timeouts MATCH the Windows worker (_test_worker.ps1) rather than being invented here:
# compile 150s, link 300s, run 60s. The first run used 25s for the run stage and reported
# TIMEOUT for tests that are simply SLOW BY DESIGN -- argon2 is a deliberately expensive KDF,
# and the benchmarks exist to burn CPU. A cap tighter than the reference harness does not
# measure the platform, it measures the cap.
run_one() {
  local t="$1"
  local ll="$OUT/$t.ll" exe="$OUT/$t.bin" log="$OUT/$t.log"
  if ! TMO 150 "$NOVA" compile -o "$ll" "$t.nova" >"$log" 2>&1; then echo "COMPILE" >"$OUT/$t.res"; return; fi

  # HONOUR THE FFI LINK DIRECTIVES the compiler emits into the .ll. The regression links
  # manually rather than shelling to nova_link, so it must obey the same markers -- exactly as
  # _test_worker.ps1 does on Windows. Omitting them is why the first macOS run reported LINK
  # failures for every FFI test (_kat_cdecl, _ffi_byval, _kat_ffi_float_ret, _kat_lfu_cache):
  # their C side was simply never compiled in. That was my harness, not the platform.
  local xsrc="" xlib="" sp obj op lb
  while IFS= read -r sp; do
    [ -f "$sp" ] || continue
    obj="$OUT/$(basename "$sp").o"
    # Rebuild only when the source is newer, matching the Windows semantics: an existence-only
    # check silently links a STALE object and surfaces as a misleading "undefined symbol".
    if [ ! -f "$obj" ] || [ "$sp" -nt "$obj" ]; then
      TMO 60 clang -c -O2 $EXTRA_CFLAGS "$sp" -o "$obj" -w >>"$log" 2>&1 || true
    fi
    [ -f "$obj" ] && xsrc="$xsrc $obj"
  done < <(sed -n 's/^; LINK_SOURCE: *//p' "$ll" | tr -d '\r')
  while IFS= read -r op; do
    [ -f "$op" ] && xsrc="$xsrc $op"
  done < <(sed -n 's/^; LINK_OBJECT: *//p' "$ll" | tr -d '\r')
  while IFS= read -r lb; do
    case "$lb" in m|pthread|dl|rt) continue ;; esac   # same skip list as the Windows worker
    xlib="$xlib -l$lb"
  done < <(sed -n 's/^; LINK_LIB: *//p' "$ll" | tr -d '\r')

  # sqlite3 is linked ONLY when the IR actually references it, mirroring Windows. Linking a
  # ~250k-line object into all 3,500 binaries otherwise is pure waste.
  local sq=""
  if [ -n "$SQLITE_OBJ" ] && grep -q '@sqlite3_' "$ll" 2>/dev/null; then sq="$SQLITE_OBJ"; fi

  if ! TMO 300 clang -O2 $EXTRA_CFLAGS -o "$exe" "$ll" "$OUT/nova_runtime.o" $sq $xsrc $LINKF $xlib -w >>"$log" 2>&1; then
    echo "LINK" >"$OUT/$t.res"; return
  fi
  if TMO 60 "./$exe" >>"$log" 2>&1; then
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
echo "running $(wc -l < "$OUT/_tests.txt" | tr -d ' ') tests with $JOBS parallel workers ..."
# `xargs -P` because a SERIAL pass over ~3,500 tests would run for hours and risk the job cap.
xargs -P "$JOBS" -I{} bash -c 'run_one "$@"' _ {} < "$OUT/_tests.txt"

# SERVER tests strictly one at a time, exactly as the Windows harness does. Each spins up its own
# in-process green TCP server plus client; several at once starve the green scheduler and they
# time out despite passing fine given the machine to themselves.
if [ -s "$OUT/_serial.txt" ]; then
  echo "running $(wc -l < "$OUT/_serial.txt" | tr -d ' ') SERVER tests serially ..."
  while read -r st; do [ -n "$st" ] && run_one "$st"; done < "$OUT/_serial.txt"
  cat "$OUT/_serial.txt" >> "$OUT/_tests.txt"
fi

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
