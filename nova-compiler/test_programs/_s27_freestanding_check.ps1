# #27 no_std gate: the core value allocator runs freestanding (static buffer, no libc malloc).
# Compile a struct-heavy compute program with -DNOVA_FREESTANDING and assert correctness.
$ErrorActionPreference = "Continue"
Remove-Item _freestanding_test.ll,_fs_free.exe -ErrorAction SilentlyContinue
$env:NOVA_NO_CACHE = "1"
& .\gen3_test.exe _freestanding_test.nova *> $null
if (-not (Test-Path _freestanding_test.ll)) { Write-Host "FAIL: freestanding test did not compile"; exit 1 }
& clang -O2 -DNOVA_FREESTANDING -o _fs_free.exe _freestanding_test.ll ../compiler/nova_runtime.c -lws2_32 -ladvapi32 -lkernel32 -D_CRT_SECURE_NO_WARNINGS -w 2>$null
if (-not (Test-Path _fs_free.exe)) { Write-Host "FAIL: freestanding runtime did not build"; exit 1 }
$o = "$env:TEMP\s27o.txt"
$p = Start-Process -FilePath (Resolve-Path ".\_fs_free.exe").Path -PassThru -NoNewWindow -RedirectStandardOutput $o
if (-not $p.WaitForExit(15000)) { cmd /c "taskkill /F /T /PID $($p.Id)" | Out-Null; Write-Host "FAIL: freestanding test hung"; exit 1 }
Remove-Item Env:NOVA_NO_CACHE -ErrorAction SilentlyContinue
Remove-Item _freestanding_test.ll,_fs_free.exe -ErrorAction SilentlyContinue
$out = ((Get-Content $o -Raw) | Out-String).Trim()
if ($out -notmatch "1498500") { Write-Host "FAIL: freestanding output was [$out] (expected 1498500)"; exit 1 }
Write-Host "PASS #27 freestanding allocator: build(1000) = $out (static buffer, no libc malloc for core objects)"
exit 0
