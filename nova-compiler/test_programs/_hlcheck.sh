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
OUT=$(timeout 120 ./gen3_test.exe "$T.nova" "$T.ll" 2>&1)
RC=$?
rm -f "$T.nova" "$T.ll"
if echo "$OUT" | grep -q "error\["; then
    echo "FAIL $M"
    echo "$OUT" | grep "error\[" | head -8
    exit 1
fi
if [ $RC -ne 0 ]; then echo "FAIL $M (exit $RC)"; echo "$OUT" | head -5; exit 1; fi
echo "OK $M"
