#!/bin/bash
# Concurrency gate: open a STALLED connection (connects but sends nothing, holding its TLS handshake read),
# then a FAST curl. With per-connection spawning the fast client is served despite the stall; with the old
# single-threaded accept loop it would be blocked (never accepted) and time out.
cd "$(dirname "$0")" || exit 1
PORT=44336
powershell -ExecutionPolicy Bypass -File _fdb_one.ps1 forge_https_conc_test >/dev/null 2>&1
[ -f forge_https_conc_test.exe ] || { echo "BUILD-FAIL"; exit 1; }
rm -f _concsrv.txt _conc1.txt
./forge_https_conc_test.exe > _concsrv.txt 2>&1 &
SRV=$!
sleep 2
# conn1: stalled -- connect, send nothing, hold for 12s
python -c "import socket,time;s=socket.socket();s.connect(('127.0.0.1',$PORT));time.sleep(12);s.close()" &
STALL=$!
sleep 1   # ensure the stalled connection is accepted first
# conn2: fast client -- must be served concurrently
timeout 8 curl -sk --tls-max 1.3 --http1.1 https://127.0.0.1:$PORT/hello > _conc1.txt 2>&1
kill $STALL 2>/dev/null
kill $SRV 2>/dev/null
if grep -q "CONCURRENT-OK" _conc1.txt; then
    echo "PASS forge_https_concurrent (fast client served despite a stalled connection -> per-conn spawning works)"
else
    echo "FAIL forge_https_concurrent (fast client blocked by the stalled connection)"
    echo "--- curl ---"; cat _conc1.txt
    echo "--- server ---"; cat _concsrv.txt
fi
