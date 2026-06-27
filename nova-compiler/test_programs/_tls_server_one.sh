#!/bin/bash
# Live TLS 1.3 server gate: build the NOVA server, start it (it accepts one connection), run
# `openssl s_client -tls1_3` against it, and confirm both sides complete the handshake.
cd "$(dirname "$0")" || exit 1
PORT="${1:-44331}"
powershell -ExecutionPolicy Bypass -File _fdb_one.ps1 forge_tls_server_test >/dev/null 2>&1
[ -f forge_tls_server_test.exe ] || { echo "BUILD-FAIL"; exit 1; }
rm -f _srv_run.txt _cli_run.txt
./forge_tls_server_test.exe > _srv_run.txt 2>&1 &
SRV=$!
sleep 2
timeout 15 openssl s_client -connect 127.0.0.1:"$PORT" -tls1_3 </dev/null > _cli_run.txt 2>&1
wait $SRV 2>/dev/null
if grep -q "TLS_AES_128_GCM_SHA256" _cli_run.txt && grep -q "SERVER-HANDSHAKE-OK" _srv_run.txt; then
    echo "PASS forge_tls_server (full TLS 1.3 handshake vs openssl s_client)"
else
    echo "FAIL forge_tls_server"
    echo "--- s_client tail ---"; tail -6 _cli_run.txt
    echo "--- nova server ---"; cat _srv_run.txt
fi
