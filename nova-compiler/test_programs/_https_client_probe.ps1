# Linux HTTPS-client oracle: build with OpenSSL (-DNOVA_HAVE_OPENSSL + libssl) and
# fetch https://example.com over real TLS from inside a container.
Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
$Prog = "https_client_test"

$cr = Invoke-Timed -FilePath (Resolve-Path ".\gen3_test.exe").Path -Arguments "compile --target linux -o ${Prog}_linux.ll ${Prog}.nova" -TimeoutMs 90000
if ($cr.ExitCode -ne 0) { Write-Host "compile failed"; Write-Host $cr.StdErr; exit 1 }

@"
FROM debian:stable-slim AS build
RUN apt-get update && apt-get install -y --no-install-recommends clang libssl-dev ca-certificates && rm -rf /var/lib/apt/lists/*
WORKDIR /src
COPY ${Prog}_linux.ll output/nova_runtime.c ./
RUN clang -O2 -DNOVA_HAVE_OPENSSL -o prog ${Prog}_linux.ll nova_runtime.c -lpthread -lm -lssl -lcrypto -w
FROM debian:stable-slim
RUN apt-get update && apt-get install -y --no-install-recommends libssl3 ca-certificates && rm -rf /var/lib/apt/lists/*
COPY --from=build /src/prog /prog
CMD ["/prog"]
"@ | Set-Content "Dockerfile.https" -Encoding ascii

docker build -q -t nova-https-client -f Dockerfile.https . 2>&1 | Select-Object -Last 1
$out = (docker run --rm nova-https-client 2>&1 | Out-String)
Write-Host "=== output ==="
Write-Host $out.TrimEnd()
Remove-Item "Dockerfile.https","${Prog}_linux.ll" -Force -ErrorAction SilentlyContinue
if ($out -match 'FAIL|assert|error') { Write-Host "RESULT: FAIL"; exit 1 }
if ($out -notmatch 'https client test passed') { Write-Host "RESULT: FAIL"; exit 1 }
Write-Host "RESULT: PASS"
