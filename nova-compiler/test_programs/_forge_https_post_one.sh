#!/bin/bash
# Reassembly gate: POST a 40000-byte body (~3 TLS records) to the NOVA HTTPS app server; the handler echoes
# the body length. PASS only if the server reassembled all 40000 bytes across records (old code = truncated).
cd "$(dirname "$0")" || exit 1
PORT="${1:-44333}"
powershell -ExecutionPolicy Bypass -File _fdb_one.ps1 forge_https_post_test >/dev/null 2>&1
[ -f forge_https_post_test.exe ] || { echo "BUILD-FAIL"; exit 1; }
rm -f _postsrv.txt _post1.txt _postbody.txt
head -c 40000 /dev/zero | tr '\0' 'A' > _postbody.txt
./forge_https_post_test.exe > _postsrv.txt 2>&1 &
SRV=$!
sleep 2
timeout 15 curl -sk --tls-max 1.3 --http1.1 -X POST --data-binary @_postbody.txt https://127.0.0.1:"$PORT"/echolen > _post1.txt 2>&1
wait $SRV 2>/dev/null
if grep -q "len=40000" _post1.txt && grep -q "HTTPS-POST-DONE" _postsrv.txt; then
    echo "PASS forge_https_post (40000-byte POST body reassembled across TLS records)"
else
    echo "FAIL forge_https_post"
    echo "--- response ---"; cat _post1.txt
    echo "--- server ---"; cat _postsrv.txt
fi
