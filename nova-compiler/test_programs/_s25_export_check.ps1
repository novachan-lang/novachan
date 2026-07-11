# #25 @export gate: compile a NOVA @export library, link it into a PURE-C host, run, assert.
# Proves the C-ABI outbound direction (NOVA functions callable from C). Run from test_programs.
$ErrorActionPreference = "Continue"
$cc = ".\gen3_test.exe"; $clang = "clang"
Remove-Item _export_lib.ll,_export_lib.o,_rt25.o,_export_test.exe -ErrorAction SilentlyContinue
$env:NOVA_NO_CACHE = "1"
& $cc _export_lib.nova *> $null
if (-not (Test-Path _export_lib.ll)) { Write-Host "FAIL: lib did not compile"; exit 1 }
if ((Select-String -Path _export_lib.ll -Pattern 'define i32 @main\b' -Quiet)) { Write-Host "FAIL: @export lib still emits @main"; exit 1 }
if (-not (Select-String -Path _export_lib.ll -Pattern '@__nova_export_init' -Quiet)) { Write-Host "FAIL: missing __nova_export_init entry"; exit 1 }
& $clang -O2 -c _export_lib.ll -o _export_lib.o 2>$null
& $clang -O2 -c ../compiler/nova_runtime.c -o _rt25.o -D_CRT_SECURE_NO_WARNINGS -w 2>$null
& $clang -O2 -o _export_test.exe _export_driver.c _export_lib.o _rt25.o -lws2_32 -ladvapi32 -lkernel32 -D_CRT_SECURE_NO_WARNINGS -w 2>$null
if (-not (Test-Path _export_test.exe)) { Write-Host "FAIL: C host did not link against the NOVA @export lib"; exit 1 }
$o = "$env:TEMP\s25o.txt"
$p = Start-Process -FilePath (Resolve-Path ".\_export_test.exe").Path -PassThru -NoNewWindow -RedirectStandardOutput $o
if (-not $p.WaitForExit(15000)) { cmd /c "taskkill /F /T /PID $($p.Id)" | Out-Null; Write-Host "FAIL: @export test hung"; exit 1 }
Remove-Item Env:NOVA_NO_CACHE -ErrorAction SilentlyContinue
Remove-Item _export_lib.ll,_export_lib.o,_rt25.o,_export_test.exe -ErrorAction SilentlyContinue
# Verify by OUTPUT (Start-Process -PassThru does not reliably populate ExitCode): the C host
# computes add(3,4)+mul(5,6)+fib(10) = 7+30+55 = 92 and prints it.
$out = ((Get-Content $o -Raw) | Out-String).Trim()
if ($out -notmatch "= 92") { Write-Host "FAIL: @export host output was [$out] (expected '... = 92')"; exit 1 }
Write-Host "PASS #25 @export: $out"
exit 0
