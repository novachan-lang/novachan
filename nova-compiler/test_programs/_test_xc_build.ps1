Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
# Oracle for first-class cross-compile: nova_build --target=x86_64-unknown-linux-gnu
# produces a Linux ELF that RUNS in WSL. Also confirms the default Windows build still
# works (the target=="" path is untouched).
Write-Host "=== NOVA_BUILD CROSS-COMPILE TEST ==="

Write-Host "[1] compile + link nova_build.exe"
Remove-Item nova_build.ll, nova_build.exe -Force -ErrorAction SilentlyContinue
$cr = Invoke-Timed -FilePath '.\gen3_test.exe' -Arguments 'nova_build.nova' -TimeoutMs 60000 -WorkingDirectory $PSScriptRoot
if ($cr.ExitCode -ne 0) { Write-Host "FAIL compile nova_build"; Write-Host $cr.StdOut; exit 1 }
$linkArgs = "-O2 -o `"nova_build.exe`" `"nova_build.ll`" `"output\nova_runtime.c`" $NovaLinkFlags -D_CRT_SECURE_NO_WARNINGS -w"
Invoke-Timed -FilePath $ClangPath -Arguments $linkArgs -TimeoutMs 90000 -WorkingDirectory $PSScriptRoot | Out-Null
if (!(Test-Path ".\nova_build.exe")) { Write-Host "FAIL link nova_build"; exit 1 }

Write-Host "[2] init project + stage compiler/runtime"
if (Test-Path "xc_project") { Remove-Item "xc_project" -Recurse -Force }
New-Item -ItemType Directory -Path "xc_project" -Force | Out-Null
Invoke-Timed -FilePath "$PSScriptRoot\nova_build.exe" -Arguments 'init hello_xc' -TimeoutMs 10000 -WorkingDirectory "$PSScriptRoot\xc_project" | Out-Null
if (!(Test-Path "xc_project\src\main.nova")) { Write-Host "FAIL init"; exit 1 }
Copy-Item ".\gen3_test.exe" "xc_project\" -Force
Copy-Item ".\output" "xc_project\output" -Recurse -Force

Write-Host "[3] default Windows build (target=='' path must be unbroken)"
$wb = Invoke-Timed -FilePath '.\nova_build.exe' -Arguments 'build xc_project' -TimeoutMs 60000 -WorkingDirectory $PSScriptRoot
if ($wb.ExitCode -ne 0 -or !(Test-Path "xc_project\build\hello_xc.exe")) { Write-Host "FAIL windows build"; Write-Host $wb.StdOut; exit 1 }
$wr = Invoke-Timed -FilePath '.\xc_project\build\hello_xc.exe' -Arguments '' -TimeoutMs 5000 -WorkingDirectory $PSScriptRoot
Write-Host ("  windows run: " + $wr.StdOut.Trim())

Write-Host "[4] CROSS build --target=x86_64-unknown-linux-gnu (WSL link backend)"
$xb = Invoke-Timed -FilePath '.\nova_build.exe' -Arguments 'build --force --target=x86_64-unknown-linux-gnu xc_project' -TimeoutMs 180000 -WorkingDirectory $PSScriptRoot
Write-Host ("  nova_build exit=" + $xb.ExitCode)
Write-Host $xb.StdOut.Trim()
if (!(Test-Path "xc_project\build\hello_xc")) { Write-Host "FAIL: no linux ELF produced"; exit 1 }

Write-Host "[5] run the Linux ELF in WSL"
$elf = "/mnt/c/Users/mange/Crypto/AI/New folder/New folder/nova-compiler/test_programs/xc_project/build/hello_xc"
$run = & wsl -d Ubuntu -e bash -lc "file '$elf' | sed 's/.*: //'; echo '--- run ---'; '$elf'; echo EXIT=`$?" 2>&1 | Out-String
Write-Host $run

Remove-Item "xc_project" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item nova_build.ll, nova_build.exe -Force -ErrorAction SilentlyContinue
if ($run -match "ELF 64-bit" -and $run -match "EXIT=0") { Write-Host "XC_BUILD_OK" } else { Write-Host "XC_BUILD_FAIL"; exit 1 }
