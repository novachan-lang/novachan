param([string]$Src = "__xc")
Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
# Cross-compile a NOVA program to a Linux x86_64 ELF and RUN it in WSL Ubuntu -- the
# platform-independence oracle. Pipeline:
#   1. gen3 (Windows) compiles Src.nova -> Src.ll  (Windows target triple)
#   2. rewrite the .ll triple + datalayout to linux (m:w -> m:e; COFF -> ELF mangling)
#   3. Windows clang lowers the linux-.ll -> Src_linux.o (IR -> ELF object; no sysroot)
#   4. WSL gcc compiles nova_runtime.c (has linux headers) + links Src_linux.o -> ELF
#   5. WSL runs the ELF; caller asserts the stdout
$ErrorActionPreference = "Stop"

Write-Host "[1/5] gen3 compile $Src.nova -> $Src.ll"
Remove-Item "$Src.ll", "${Src}_linux.ll", "${Src}_linux.o" -Force -ErrorAction SilentlyContinue
$c = Invoke-Timed -FilePath ".\gen3_test.exe" -Arguments "$Src.nova" -TimeoutMs 120000 -WorkingDirectory $PSScriptRoot
if ($c.ExitCode -ne 0 -or !(Test-Path "$Src.ll")) { Write-Host "GEN3 FAIL exit=$($c.ExitCode)"; Write-Host $c.StdOut; exit 1 }

Write-Host "[2/5] rewrite .ll triple + datalayout -> linux"
$ll = Get-Content "$Src.ll" -Raw
$ll = $ll -replace 'target triple = "x86_64-pc-windows-msvc"', 'target triple = "x86_64-unknown-linux-gnu"'
$ll = $ll -replace 'target datalayout = "e-m:w-', 'target datalayout = "e-m:e-'
Set-Content "${Src}_linux.ll" -Value $ll -Encoding ASCII -NoNewline

Write-Host "[3/5] Windows clang lowers linux-.ll -> ELF object"
$o = Invoke-Timed -FilePath $ClangPath -Arguments "--target=x86_64-unknown-linux-gnu -O2 -c `"${Src}_linux.ll`" -o `"${Src}_linux.o`"" -TimeoutMs 120000 -WorkingDirectory $PSScriptRoot
if (!(Test-Path "${Src}_linux.o")) { Write-Host "CLANG IR->OBJ FAIL"; Write-Host $o.StdErr; exit 1 }

Write-Host "[4/5] + [5/5] WSL: gcc compile runtime + link + run"
$base = "/mnt/c/Users/mange/Crypto/AI/New folder/New folder/nova-compiler/test_programs"
$wcmd = "set -e; mkdir -p /tmp/novaxc; cd /tmp/novaxc; " +
        "cp '" + $base + "/output/nova_runtime.c' .; " +
        "cp '" + $base + "/${Src}_linux.o' .; " +
        "gcc -O2 -c nova_runtime.c -o nrt.o 2>/tmp/novaxc_cc.err; " +
        "gcc ${Src}_linux.o nrt.o -o ${Src}_linux -lpthread -lm -ldl 2>/tmp/novaxc_link.err; " +
        "echo '--- RUN ---'; ./${Src}_linux; echo \""--- exit=`$? ---\""; " +
        "file ${Src}_linux"
$r = & wsl -d Ubuntu -e bash -lc $wcmd 2>&1 | Out-String
Write-Host $r
