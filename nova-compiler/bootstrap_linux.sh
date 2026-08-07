#!/usr/bin/env bash
# Build NOVA natively on Linux from the checked-in bootstrap IR.
#
# THE CHICKEN-AND-EGG: NOVA's compiler is written in NOVA, so building it needs a NOVA compiler.
# One generation therefore ships as LLVM IR -- compiler/nova_compiler_linux.ll -- emitted with
# `--target linux` so it carries the ELF datalayout (e-m:e) rather than the Windows one (e-m:w).
# That IR + the C runtime is all you need; from there the compiler rebuilds itself.
#
#   ./bootstrap_linux.sh          # build ./nova
#   ./bootstrap_linux.sh --check  # also rebuild the compiler with itself and prove gen5 == gen6
#
# Requires: clang (to compile the IR) and a libc toolchain. No NOVA installation needed.
set -euo pipefail

cd "$(dirname "$0")/compiler"

BOOT_IR="nova_compiler_linux.ll"
RUNTIME="nova_runtime.c"
OUT="../nova"

command -v clang >/dev/null 2>&1 || { echo "error: clang not found. Install it (apt install clang)."; exit 1; }
[ -f "$BOOT_IR" ] || { echo "error: bootstrap IR missing: compiler/$BOOT_IR"; exit 1; }
[ -f "$RUNTIME" ] || { echo "error: runtime missing: compiler/$RUNTIME"; exit 1; }

# Guard against someone regenerating the seed on the wrong target -- a Windows-targeted IR would
# compile here and then produce subtly wrong code (wrong datalayout, wrong pointer/ABI handling).
grep -q 'x86_64-unknown-linux-gnu' "$BOOT_IR" || {
    echo "error: $BOOT_IR is not Linux-targeted. Regenerate with:"
    echo "       nova compile --target linux -o $BOOT_IR nova_compiler.nova"
    exit 1
}

echo "[1/2] compiling bootstrap IR + runtime -> nova"
clang -O2 -o "$OUT" "$BOOT_IR" "$RUNTIME" -lpthread -ldl -lm -Wno-everything

echo "[2/2] verifying"
"$OUT" --version

if [ "${1:-}" = "--check" ]; then
    echo
    echo "=== self-host check: rebuilding the compiler with itself ==="
    export NOVA_NO_CACHE=1
    tmp="$(mktemp -d)"
    trap 'rm -rf "$tmp"' EXIT
    # `nova <in.nova> <out.ll>` is POSITIONAL; bare `-o` is not a top-level flag.
    "$OUT" nova_compiler.nova "$tmp/gen5.ll"
    clang -O2 -o "$tmp/nova_gen5" "$tmp/gen5.ll" "$RUNTIME" -lpthread -ldl -lm -Wno-everything
    "$tmp/nova_gen5" nova_compiler.nova "$tmp/gen6.ll"
    if diff -q "$tmp/gen5.ll" "$tmp/gen6.ll" >/dev/null; then
        echo "RECONVERGED: gen5 == gen6 (byte-identical) -- native Linux self-hosting confirmed"
    else
        echo "DIVERGED: gen5 != gen6"
        diff "$tmp/gen5.ll" "$tmp/gen6.ll" | head -40
        exit 1
    fi
fi

echo
echo "Done. Binary at: $(cd .. && pwd)/nova"
echo "Try:  ./nova run <your-program>.nova"
