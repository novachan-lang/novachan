#!/bin/bash
# Crash-isolation gate: hit a PANICKING route, then a normal route. With the monitored sub-process the
# server contains the crash, drains, serves /ok, and RETURNS (prints PANIC-SERVED-DONE). Without it, the
# drain blocks forever on the crashed connection's missing done-signal -> the server hangs (no DONE).
cd "$(dirname "$0")" || exit 1
PORT=44337
powershell -ExecutionPolicy Bypass -File _fdb_one.ps1 forge_https_panic_test >/dev/null 2>&1
[ -f forge_https_panic_test.exe ] || { echo "BUILD-FAIL"; exit 1; }
rm -f _pansrv.txt _pan1.txt _pan2.txt
./forge_https_panic_test.exe > _pansrv.txt 2>&1 &
SRV=$!
sleep 2
timeout 8 curl -sk --tls-max 1.3 --http1.1 https://127.0.0.1:$PORT/crash > _pan1.txt 2>&1   # panics; connection dropped
timeout 8 curl -sk --tls-max 1.3 --http1.1 https://127.0.0.1:$PORT/ok > _pan2.txt 2>&1       # must still be served
sleep 2   # let the server drain + print DONE + exit (if it didn't hang)
kill $SRV 2>/dev/null
if grep -q "OK-AFTER-CRASH" _pan2.txt && grep -q "PANIC-SERVED-DONE" _pansrv.txt; then
    echo "PASS forge_https_panic (handler panic isolated: /ok served + server drained/returned, no hang)"
else
    echo "FAIL forge_https_panic (server hung on the panicked connection, or /ok not served)"
    echo "--- /crash ---"; cat _pan1.txt
    echo "--- /ok ---"; cat _pan2.txt
    echo "--- server ---"; cat _pansrv.txt
fi
