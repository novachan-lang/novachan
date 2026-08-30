# DARWIN-BEHAVIOUR MEMORY SWEEP — find the use-after-free class LOCALLY, in batch.
#
# WHY THIS EXISTS. Two bugs this campaign were "macOS bugs" that were nothing of the sort: they
# were live on every platform, and only Darwin exposed them because Darwin REUSES freed memory
# while Linux and Windows leave the bytes intact long enough to look correct.
#   * borrowed const char* in the coverage/profiler tables  (phase9_devx_test)
#   * the integer-read-as-string range check                (whole crypto cluster)
# Each one cost a full 90-minute CI round trip to find, because there is no macOS on this dev box.
# Fixing them one per cycle is a SERIAL SEARCH at 90 minutes a step, which is why progress felt
# like an endless drip even as the failure count collapsed 205 -> 59 -> 45 -> 0.
#
# glibc can be made to behave like Darwin: MALLOC_PERTURB_ fills freed memory with a byte pattern
# on free() and a different one on malloc(). A read through a dangling pointer then returns
# garbage HERE, in a container, in minutes -- instead of on a macOS runner an hour and a half away.
#
# This does NOT replace the macOS CI job. Darwin differs in more than malloc (page layout, image
# base, libSystem). It converts the LARGEST and most repeatedly-hit class from "found serially by
# CI" into "found in one local batch", which is the whole point.
#
# TWO MODES:
#   default        — a quick A/B pass: compile each test, run it clean and again under
#                    MALLOC_PERTURB_, and report only tests whose OUTPUT OR EXIT CODE DIFFERS. A
#                    difference is the signature of a read through freed memory. Fast, but it does
#                    its own minimal build, so tests needing the forge/prism lib sync, FFI link
#                    directives or sqlite are SKIPPED (counted and reported, never silently).
#   -Full          — runs the REAL .github/scripts/posix_full_suite.sh inside the container with
#                    MALLOC_PERTURB_ exported, so every test gets its proper setup. Slower
#                    (the whole suite), and the right thing to run before trusting a green macOS.
#
# Usage:  powershell -File ./_darwin_mem_sweep.ps1 [-Pattern '*_test'] [-Max 0] [-Full]
param([string]$Pattern = "*_test", [int]$Max = 0, [switch]$Full)
Set-Location $PSScriptRoot

$img  = "nova-posix-check:1"
$repo = (Resolve-Path "$PSScriptRoot\..\..").Path

$null = & docker info --format '{{.ServerVersion}}' 2>&1
if ($LASTEXITCODE -ne 0) { Write-Host "SKIP darwin-mem sweep: Docker daemon not available"; exit 0 }
$null = & docker image inspect $img 2>&1
if ($LASTEXITCODE -ne 0) { Write-Host "SKIP darwin-mem sweep: run _posix_typecheck.ps1 first to build $img"; exit 0 }

$env:MSYS_NO_PATHCONV = "1"

if ($Full) {
    # Delegate to the REAL suite so every test gets the setup it needs (lib sync, OpenSSL
    # detection, FFI link directives, sqlite pre-compile). MALLOC_PERTURB_ is exported into the
    # container, and the suite's test binaries inherit it — that is the entire trick.
    Write-Host "=== FULL suite under MALLOC_PERTURB_=165 (Darwin-like free() behaviour) ==="
    Write-Host "    this is the real posix_full_suite.sh, not a reduced harness"
    & docker run --rm -e MALLOC_PERTURB_=165 -e NOVA_SHARD_TOTAL=1 -e NOVA_SHARD_INDEX=0 `
        -v "${repo}:/src" -w /src $img bash .github/scripts/posix_full_suite.sh
    exit $LASTEXITCODE
}

# The whole sweep runs INSIDE one container: building the compiler per test would dominate.
# MALLOC_PERTURB_ is set only for the RUN, never for the build -- perturbing clang buys nothing
# and would just make the build slower.
$script = @'
set -u
cd /src/nova-compiler/compiler
clang -O2 -o /tmp/nova nova_compiler_linux.ll nova_runtime.c -lpthread -ldl -lm -Wno-everything 2>/dev/null
[ -x /tmp/nova ] || { echo "FATAL: could not build the Linux compiler from the seed"; exit 1; }
clang -c -O2 nova_runtime.c -o /tmp/rt.o -w 2>/dev/null || { echo "FATAL: runtime pre-compile failed"; exit 1; }
cd /src/nova-compiler/test_programs

ran=0; diff=0; skipped=0
for f in PATTERN.nova; do
  [ -f "$f" ] || continue
  n="${f%.nova}"
  MAXN
  rm -f "/tmp/$n.ll" "/tmp/$n.bin"
  NOVA_NO_CACHE=1 timeout -k 5 60 /tmp/nova "$f" "/tmp/$n.ll" >/dev/null 2>&1 || { skipped=$((skipped+1)); continue; }
  [ -f "/tmp/$n.ll" ] || { skipped=$((skipped+1)); continue; }
  clang -O1 -o "/tmp/$n.bin" "/tmp/$n.ll" /tmp/rt.o -lpthread -ldl -lm -w 2>/dev/null || { skipped=$((skipped+1)); continue; }

  # Baseline vs perturbed. Only a DIFFERENCE is interesting: a test that fails both ways is
  # failing for its own reasons and is not this class.
  timeout -k 5 60 "/tmp/$n.bin" >/tmp/a.out 2>&1; ra=$?
  MALLOC_PERTURB_=165 timeout -k 5 60 "/tmp/$n.bin" >/tmp/b.out 2>&1; rb=$?
  ran=$((ran+1))
  if [ "$ra" != "$rb" ] || ! cmp -s /tmp/a.out /tmp/b.out; then
    diff=$((diff+1))
    echo "  DIFF  $n   (clean exit=$ra, perturbed exit=$rb)"
    diff /tmp/a.out /tmp/b.out 2>/dev/null | head -4 | sed 's/^/        /'
  fi
  rm -f "/tmp/$n.ll" "/tmp/$n.bin"
done
echo ""
echo "darwin-mem sweep: $ran run, $diff DIFFER under MALLOC_PERTURB_, $skipped skipped (compile/link)"
[ "$diff" -gt 0 ] && exit 1
exit 0
'@
$script = $script.Replace("PATTERN", $Pattern)
$script = $script.Replace("MAXN", $(if ($Max -gt 0) { "[ `$ran -ge $Max ] && break" } else { ":" }))
$script = $script -replace "`r`n", "`n"

$tmp = Join-Path $env:TEMP "nova_darwin_sweep.sh"
[System.IO.File]::WriteAllText($tmp, $script)

Write-Host "=== Darwin-behaviour memory sweep (MALLOC_PERTURB_=165) ==="
& docker run --rm -v "${repo}:/src" -v "${tmp}:/tmp/sweep.sh" $img bash /tmp/sweep.sh
exit $LASTEXITCODE
