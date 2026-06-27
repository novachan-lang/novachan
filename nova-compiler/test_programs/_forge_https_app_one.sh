#!/bin/bash
# Forge HTTPS-app gate: build the routed Forge app HTTPS server, start it (serves 2 connections), fetch two
# routes with curl over TLS 1.3 -- a static route and a :param route -- and check both routed responses.
cd "$(dirname "$0")" || exit 1
PORT="${1:-44332}"
powershell -ExecutionPolicy Bypass -File _fdb_one.ps1 forge_https_app_test >/dev/null 2>&1
[ -f forge_https_app_test.exe ] || { echo "BUILD-FAIL"; exit 1; }
rm -f _appsrv.txt _app1.txt _app2.txt
./forge_https_app_test.exe > _appsrv.txt 2>&1 &
SRV=$!
sleep 2
timeout 12 curl -sk --tls-max 1.3 --http1.1 https://127.0.0.1:"$PORT"/hello > _app1.txt 2>&1
timeout 12 curl -sk --tls-max 1.3 --http1.1 https://127.0.0.1:"$PORT"/echo/world > _app2.txt 2>&1
wait $SRV 2>/dev/null
if grep -q "Routed Forge app over HTTPS" _app1.txt && grep -q "echo: world" _app2.txt && grep -q "HTTPS-APP-DONE" _appsrv.txt; then
    echo "PASS forge_https_app (routed Forge app: static + :param routes over TLS 1.3, 2 connections, fresh ephemeral per conn)"
else
    echo "FAIL forge_https_app"
    echo "--- /hello ---"; cat _app1.txt
    echo "--- /echo/world ---"; cat _app2.txt
    echo "--- server ---"; cat _appsrv.txt
fi
