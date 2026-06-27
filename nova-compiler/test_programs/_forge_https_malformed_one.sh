#!/bin/bash
# Malformed-ClientHello robustness gate: send a garbage/truncated TLS handshake record (which would OOB-index
# the OLD _tlss_parse_ch), then a REAL request. PASS only if the server survived the garbage (no crash) AND
# still served the real request -- proving the bounds-hardened parser fails closed instead of panicking.
cd "$(dirname "$0")" || exit 1
PORT="${1:-44332}"
powershell -ExecutionPolicy Bypass -File _fdb_one.ps1 forge_https_app_test >/dev/null 2>&1
[ -f forge_https_app_test.exe ] || { echo "BUILD-FAIL"; exit 1; }
rm -f _mfsrv.txt _mf1.txt
./forge_https_app_test.exe > _mfsrv.txt 2>&1 &
SRV=$!
sleep 2
# Connection 1: a malformed ClientHello -- record(type=22,ver=0x0301,len=4) + truncated handshake body.
python -c "import socket;s=socket.socket();s.connect(('127.0.0.1',$PORT));s.send(bytes([0x16,0x03,0x01,0x00,0x04,0x01,0x00,0x00,0x00]));s.close()" 2>/dev/null
sleep 1
# Connection 2: a real request -- must still be served if the server survived the garbage.
timeout 12 curl -sk --tls-max 1.3 --http1.1 https://127.0.0.1:"$PORT"/hello > _mf1.txt 2>&1
wait $SRV 2>/dev/null
if grep -q "Routed Forge app over HTTPS" _mf1.txt && grep -q "HTTPS-APP-DONE" _mfsrv.txt; then
    echo "PASS forge_https_malformed (server survived a malformed ClientHello and still served a real request)"
else
    echo "FAIL forge_https_malformed (server may have crashed on malformed input)"
    echo "--- real request response ---"; cat _mf1.txt
    echo "--- server ---"; cat _mfsrv.txt
fi
