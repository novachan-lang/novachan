Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
# Oracle for demand-driven OpenSSL via nova_build's WSL cross-link: a TLS program
# cross-built to Linux must LINK with OpenSSL (-lssl -lcrypto + -DNOVA_HAVE_OPENSSL) and
# RUN; a plain (no-TLS) program must build WITHOUT OpenSSL (must-not-break / no over-link).
Write-Host "=== OpenSSL demand-driven cross-link test ==="

Write-Host "[1] build nova_build.exe"
Remove-Item nova_build.ll, nova_build.exe -Force -ErrorAction SilentlyContinue
$cr = Invoke-Timed -FilePath '.\gen3_test.exe' -Arguments 'nova_build.nova' -TimeoutMs 60000 -WorkingDirectory $PSScriptRoot
if ($cr.ExitCode -ne 0) { Write-Host "FAIL compile nova_build"; Write-Host $cr.StdOut; exit 1 }
$linkArgs = "-O2 -o `"nova_build.exe`" `"nova_build.ll`" `"output\nova_runtime.c`" $NovaLinkFlags -D_CRT_SECURE_NO_WARNINGS -w"
Invoke-Timed -FilePath $ClangPath -Arguments $linkArgs -TimeoutMs 90000 -WorkingDirectory $PSScriptRoot | Out-Null
if (!(Test-Path ".\nova_build.exe")) { Write-Host "FAIL link nova_build"; exit 1 }

Write-Host "[2] init TLS project"
if (Test-Path "ssl_proj") { Remove-Item "ssl_proj" -Recurse -Force }
New-Item -ItemType Directory -Path "ssl_proj" -Force | Out-Null
Invoke-Timed -FilePath "$PSScriptRoot\nova_build.exe" -Arguments 'init ssl_app' -TimeoutMs 10000 -WorkingDirectory "$PSScriptRoot\ssl_proj" | Out-Null
Copy-Item "_ssl_xc_main.nova" "ssl_proj\src\main.nova" -Force
Copy-Item ".\gen3_test.exe" "ssl_proj\" -Force
Copy-Item ".\output" "ssl_proj\output" -Recurse -Force

Write-Host "[3] CROSS build --target=x86_64-unknown-linux-gnu (demand -> OpenSSL)"
$xb = Invoke-Timed -FilePath '.\nova_build.exe' -Arguments 'build --force --target=x86_64-unknown-linux-gnu ssl_proj' -TimeoutMs 240000 -WorkingDirectory $PSScriptRoot
Write-Host ("  exit=" + $xb.ExitCode)
Write-Host $xb.StdOut.Trim()
if (!(Test-Path "ssl_proj\build\ssl_app")) { Write-Host "FAIL: no linux ELF (OpenSSL link failed?)"; Remove-Item "ssl_proj" -Recurse -Force -EA SilentlyContinue; exit 1 }

Write-Host "[4] run the Linux ELF in WSL"
$elf = "/mnt/c/Users/mange/Crypto/AI/New folder/New folder/nova-compiler/test_programs/ssl_proj/build/ssl_app"
$run = & wsl -d Ubuntu -e bash -lc "file '$elf' | sed 's/.*: //'; echo '--- run ---'; '$elf'; echo EXIT=`$?; echo '--- linked libs ---'; ldd '$elf' | grep -i ssl" 2>&1 | Out-String
Write-Host $run

Remove-Item "ssl_proj" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item nova_build.ll, nova_build.exe -Force -ErrorAction SilentlyContinue
if ($run -match "TLS_BUILD_OK" -and $run -match "ELF 64-bit" -and $run -match "libssl") { Write-Host "SSL_XC_OK" } else { Write-Host "SSL_XC_FAIL"; exit 1 }
