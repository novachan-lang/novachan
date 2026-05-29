# Reusable Linux oracle: cross-compile a self-contained NOVA program to Linux IR,
# build + run it in a Docker container, and check its output. Usage:
#   _docker_run.ps1 -Prog http_client_test -Expect "loopback test passed"
param([Parameter(Mandatory)][string]$Prog, [string]$Expect = "passed")
Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"

$cr = Invoke-Timed -FilePath (Resolve-Path ".\gen3_test.exe").Path -Arguments "compile --target linux -o ${Prog}_linux.ll ${Prog}.nova" -TimeoutMs 90000
if ($cr.ExitCode -ne 0) { Write-Host "compile failed"; Write-Host $cr.StdErr; exit 1 }

@"
FROM debian:stable-slim AS build
RUN apt-get update && apt-get install -y --no-install-recommends clang && rm -rf /var/lib/apt/lists/*
WORKDIR /src
COPY ${Prog}_linux.ll output/nova_runtime.c ./
RUN clang -O2 -o prog ${Prog}_linux.ll nova_runtime.c -lpthread -lm -w
FROM debian:stable-slim
COPY --from=build /src/prog /prog
CMD ["/prog"]
"@ | Set-Content "Dockerfile.run" -Encoding ascii

docker build -q -t "nova-run-$($Prog.ToLower())" -f Dockerfile.run . 2>&1 | Select-Object -Last 1
$out = (docker run --rm "nova-run-$($Prog.ToLower())" 2>&1 | Out-String)
Write-Host "=== program output ==="
Write-Host $out.TrimEnd()
Remove-Item "Dockerfile.run","${Prog}_linux.ll" -Force -ErrorAction SilentlyContinue
if ($out -match 'FAIL|assert|error') { Write-Host "RESULT: FAIL"; exit 1 }
if ($out -notmatch [regex]::Escape($Expect)) { Write-Host "RESULT: FAIL (expected '$Expect')"; exit 1 }
Write-Host "RESULT: PASS"
