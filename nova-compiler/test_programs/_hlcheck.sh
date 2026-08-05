#!/bin/bash
# Compile-check a NOVA module by importing it. Usage: ./_hlcheck.sh <module-import-path>
#   ./_hlcheck.sh forge_crypto
#   ./_hlcheck.sh std/matrix/matqr
# Exits 0 and prints OK, or prints the compiler errors and exits 1.
cd "$(dirname "$0")"
export NOVA_HOME="c:/Users/mange/Crypto/AI/New folder/New folder/nova-compiler"
export NOVA_NO_CACHE=1
M="$1"
T="_hlc_$(echo "$M" | tr '/' '_')"
printf 'import %s\nfn main()\n    print("ok")\n' "$M" > "$T.nova"
# TWO checks, because they are not equivalent:
#  (1) IMPORT the module -- proves it links and its exports resolve.
#  (2) Compile the module file DIRECTLY -- an IMPORTED module's body is NOT fully type-checked, so (1)
#      alone accepts real errors. Proven: a 2-argument call to a 3-parameter function compiles clean
#      when imported but fails E1003 when compiled directly; likewise `[c for c in someString]`
#      compiles when imported and SEGFAULTS at runtime. (1) alone missed both.
OUT=$(timeout 120 ./gen3_test.exe "$T.nova" "$T.ll" 2>&1)
RC=$?
SRCF="$NOVA_HOME/$M.nova"
[ -f "$SRCF" ] || SRCF="$NOVA_HOME/lib/$(basename "$M").nova"
if [ -f "$SRCF" ]; then
    cp "$SRCF" "${T}_direct.nova"
    OUT2=$(timeout 120 ./gen3_test.exe "${T}_direct.nova" "${T}_direct.ll" 2>&1)
    rm -f "${T}_direct.nova" "${T}_direct.ll"
    # A module with no main() cannot RUN, but it must still TYPE-CHECK; only error[ lines matter here.
    OUT="$OUT
$OUT2"
fi
rm -f "$T.nova" "$T.ll"
if echo "$OUT" | grep -q "error\["; then
    echo "FAIL $M"
    echo "$OUT" | grep "error\[" | head -8
    exit 1
fi
if [ $RC -ne 0 ]; then echo "FAIL $M (exit $RC)"; echo "$OUT" | head -5; exit 1; fi
echo "OK $M"
