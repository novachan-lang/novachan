# #35 const-fn-eval gate: `const X = fib(10)` is evaluated at COMPILE TIME (folded to a
# literal), the fold equals the runtime value, and bool/global cases fail closed to runtime.
$ErrorActionPreference = "Continue"
Remove-Item _s35_constfn.ll,_s35x.exe -ErrorAction SilentlyContinue
$env:NOVA_NO_CACHE = "1"
& .\gen3_test.exe _s35_constfn.nova *> $null
Remove-Item Env:NOVA_NO_CACHE -ErrorAction SilentlyContinue
if (-not (Test-Path _s35_constfn.ll)) { Write-Host "FAIL: #35 test did not compile"; exit 1 }
$ll = (Get-Content _s35_constfn.ll -Raw)
if ($ll -notmatch '3628800') { Write-Host "FAIL #35: fact(10) was NOT folded to 3628800 (const-fn-eval inactive)"; exit 1 }
if ($ll -notmatch '6765')    { Write-Host "FAIL #35: fib(20) was NOT folded to 6765"; exit 1 }
& clang -O2 -o _s35x.exe _s35_constfn.ll ../compiler/nova_runtime.c -lws2_32 -ladvapi32 -lkernel32 -D_CRT_SECURE_NO_WARNINGS -w 2>$null
if (-not (Test-Path _s35x.exe)) { Write-Host "FAIL #35: did not build"; exit 1 }
$o = "$env:TEMP\s35o.txt"
$p = Start-Process -FilePath (Resolve-Path ".\_s35x.exe").Path -PassThru -NoNewWindow -RedirectStandardOutput $o
if (-not $p.WaitForExit(15000)) { cmd /c "taskkill /F /T /PID $($p.Id)" | Out-Null; Write-Host "FAIL #35: hung"; exit 1 }
Remove-Item _s35_constfn.ll,_s35x.exe -ErrorAction SilentlyContinue
$out = (Get-Content $o -Raw)
if ($out -notmatch 'FIB20_OK' -or $out -notmatch 'FACT10_OK') { Write-Host "FAIL #35: fold != runtime:`n$out"; exit 1 }
if ($out -notmatch 'USES_OK') { Write-Host "FAIL #35: unknown-ident (global) fail-closed fallback broke:`n$out"; exit 1 }
Write-Host "PASS #35 const-fn-eval: fib(20)+fact(10) folded at compile time; fold==runtime; bool/global fail-closed"
exit 0
