#!/bin/bash
# Forge HTTPS gate: build the NOVA HTTPS server, start it, fetch a route with curl over TLS 1.3.
cd "$(dirname "$0")" || exit 1
PORT="${1:-44331}"
powershell -ExecutionPolicy Bypass -File _fdb_one.ps1 forge_https_test >/dev/null 2>&1
[ -f forge_https_test.exe ] || { echo "BUILD-FAIL"; exit 1; }
rm -f _srv_run.txt _cli_run.txt
./forge_https_test.exe > _srv_run.txt 2>&1 &
SRV=$!
sleep 2
timeout 15 curl -sk --tls-max 1.3 --http1.1 https://127.0.0.1:"$PORT"/ > _cli_run.txt 2>&1
wait $SRV 2>/dev/null
if grep -q "Hello from NOVA HTTPS" _cli_run.txt && grep -q "HTTPS-SERVED" _srv_run.txt; then
    echo "PASS forge_https (Forge route served over TLS 1.3, fetched by curl)"
else
    echo "FAIL forge_https"
    echo "--- curl ---"; cat _cli_run.txt
    echo "--- server ---"; cat _srv_run.txt
fi
