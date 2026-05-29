# Oracle for NOVA's own TLS server: generate a self-signed cert, build with OpenSSL,
# and run a NOVA TLS server<->client loopback in a container.
Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
$Prog = "tls_server_test"
$openssl = (Get-Command openssl -ErrorAction SilentlyContinue).Source
if (-not $openssl) { Write-Host "openssl not found"; exit 1 }

& $openssl req -x509 -newkey rsa:2048 -keyout key.pem -out cert.pem -days 1 -nodes -subj "/CN=localhost" 2>$null
if (!(Test-Path "cert.pem") -or !(Test-Path "key.pem")) { Write-Host "cert generation failed"; exit 1 }
Write-Host "generated self-signed cert.pem + key.pem"

$cr = Invoke-Timed -FilePath (Resolve-Path ".\gen3_test.exe").Path -Arguments "compile --target linux -o ${Prog}_linux.ll ${Prog}.nova" -TimeoutMs 90000
if ($cr.ExitCode -ne 0) { Write-Host "compile failed"; Write-Host $cr.StdErr; exit 1 }

@"
FROM debian:stable-slim AS build
RUN apt-get update && apt-get install -y --no-install-recommends clang libssl-dev && rm -rf /var/lib/apt/lists/*
WORKDIR /src
COPY ${Prog}_linux.ll output/nova_runtime.c ./
RUN clang -O2 -DNOVA_HAVE_OPENSSL -o prog ${Prog}_linux.ll nova_runtime.c -lpthread -lm -lssl -lcrypto -w
FROM debian:stable-slim
RUN apt-get update && apt-get install -y --no-install-recommends libssl3 && rm -rf /var/lib/apt/lists/*
WORKDIR /app
COPY --from=build /src/prog /app/prog
COPY cert.pem key.pem /app/
CMD ["/app/prog"]
"@ | Set-Content "Dockerfile.tls" -Encoding ascii

docker build -q -t nova-tls-server -f Dockerfile.tls . 2>&1 | Select-Object -Last 1
$out = (docker run --rm nova-tls-server 2>&1 | Out-String)
Write-Host "=== output ==="
Write-Host $out.TrimEnd()
Remove-Item "Dockerfile.tls","${Prog}_linux.ll","cert.pem","key.pem" -Force -ErrorAction SilentlyContinue
if ($out -match 'FAIL|assert|error') { Write-Host "RESULT: FAIL"; exit 1 }
if ($out -notmatch 'tls server loopback test passed') { Write-Host "RESULT: FAIL"; exit 1 }
Write-Host "RESULT: PASS"
