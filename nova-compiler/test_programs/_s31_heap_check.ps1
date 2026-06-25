# #31 heap profiler gate: NOVA_HEAP_PROFILE prints a per-tag allocation breakdown at exit.
$ErrorActionPreference = "Continue"
Remove-Item _heapprof_test.ll,_hp31.exe -ErrorAction SilentlyContinue
$env:NOVA_NO_CACHE = "1"
& .\gen3_test.exe _heapprof_test.nova *> $null
if (-not (Test-Path _heapprof_test.ll)) { Write-Host "FAIL: heapprof test did not compile"; exit 1 }
& clang -O2 -o _hp31.exe _heapprof_test.ll output/nova_runtime.c -lws2_32 -ladvapi32 -lkernel32 -D_CRT_SECURE_NO_WARNINGS -w 2>$null
if (-not (Test-Path _hp31.exe)) { Write-Host "FAIL: heapprof did not build"; exit 1 }
$env:NOVA_HEAP_PROFILE = "1"
$o = "$env:TEMP\hp31o.txt"; $e = "$env:TEMP\hp31e.txt"
$p = Start-Process -FilePath (Resolve-Path ".\_hp31.exe").Path -PassThru -NoNewWindow -RedirectStandardOutput $o -RedirectStandardError $e -Wait
Remove-Item Env:NOVA_HEAP_PROFILE,Env:NOVA_NO_CACHE -ErrorAction SilentlyContinue
Remove-Item _heapprof_test.ll,_hp31.exe -ErrorAction SilentlyContinue
$prof = ((Get-Content $e -Raw) | Out-String)
if ($prof -notmatch "heap profile") { Write-Host "FAIL: no heap profile emitted"; exit 1 }
if ($prof -notmatch "struct.*count=50") { Write-Host "FAIL: profile missing 'struct count=50':`n$prof"; exit 1 }
Write-Host "PASS #31 heap profiler: per-tag breakdown emitted (struct count=50) under NOVA_HEAP_PROFILE"
exit 0
