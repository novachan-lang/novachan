Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
$env:NOVA_NO_CACHE = "1"
Write-Host "=== iter-93 DE-RISK: build gen4 from edited compiler + test NOVA arena builtins ==="
Write-Host "[1] gen3_test.exe -> gen4 (compile edited nova_compiler.nova)"
$r1 = Invoke-Timed -FilePath (Resolve-Path ".\gen3_test.exe").Path -Arguments "nova_compiler.nova" -TimeoutMs 900000
if ($r1.ExitCode -ne 0) { Write-Host "FAIL gen4 compile (exit=$($r1.ExitCode)) timedout=$($r1.TimedOut)"; Write-Host $r1.StdErr; exit 1 }
Copy-Item nova_compiler.ll _gen4.ll -Force
$l1 = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o _gen4.exe _gen4.ll output\nova_runtime.c $NovaLinkFlags -D_CRT_SECURE_NO_WARNINGS -w" -TimeoutMs 240000
if (!(Test-Path _gen4.exe)) { Write-Host "FAIL gen4 link"; exit 1 }
Write-Host "  _gen4.exe built ($((Get-Item _gen4.exe).Length) bytes)"

Write-Host "[2] gen4 compiles _arena_demo.nova (uses arena_enter/arena_exit builtins)"
$rd = Invoke-Timed -FilePath (Resolve-Path ".\_gen4.exe").Path -Arguments "_arena_demo.nova" -TimeoutMs 120000
if ($rd.ExitCode -ne 0) { Write-Host "FAIL demo COMPILE (exit=$($rd.ExitCode))"; Write-Host $rd.StdErr; exit 1 }
if (!(Test-Path _arena_demo.ll)) { Write-Host "FAIL: no _arena_demo.ll"; exit 1 }
$ld = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o _arena_demo.exe _arena_demo.ll output\nova_runtime.c $NovaLinkFlags -D_CRT_SECURE_NO_WARNINGS -w" -TimeoutMs 240000
if (!(Test-Path _arena_demo.exe)) { Write-Host "FAIL demo LINK"; exit 1 }
Write-Host "[3] run the demo (NOVA-level flat-memory proof):"
$rr = Invoke-Timed -FilePath (Resolve-Path ".\_arena_demo.exe").Path -Arguments "" -TimeoutMs 60000
Write-Host ("  " + $rr.StdOut.Trim())
Write-Host "  demo exit=$($rr.ExitCode) timedout=$($rr.TimedOut)"

Write-Host "[4] ASAN the demo (UAF/double-free gate on the arena scope path)"
& $ClangPath -fsanitize=address -g -O1 -o _arena_demo_asan.exe _arena_demo.ll output\nova_runtime.c $NovaLinkFlags -D_CRT_SECURE_NO_WARNINGS -w 2>$null
$env:ASAN_OPTIONS = "abort_on_error=0"
& ".\_arena_demo_asan.exe" 1>_adm_out.txt 2>_adm_err.txt
$ec = $LASTEXITCODE
$er = Get-Content _adm_err.txt -Raw -ErrorAction SilentlyContinue
if ($er -and ($er -match "ERROR: AddressSanitizer|heap-use-after-free|attempting double-free|heap-buffer-overflow")) {
  Write-Host "  *** ASAN FINDING ***"; Write-Host $er
} else { Write-Host "  demo ASAN clean (exit=$ec)" }

Write-Host "[5] sanity: gen4 still compiles+runs a normal program (leak_baseline_test)"
$rs = Invoke-Timed -FilePath (Resolve-Path ".\_gen4.exe").Path -Arguments "leak_baseline_test.nova" -TimeoutMs 120000
if ($rs.ExitCode -ne 0) { Write-Host "FAIL smoke compile (exit=$($rs.ExitCode))"; exit 1 }
$ls = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o _lb_smoke.exe leak_baseline_test.ll output\nova_runtime.c $NovaLinkFlags -D_CRT_SECURE_NO_WARNINGS -w" -TimeoutMs 240000
$rls = Invoke-Timed -FilePath (Resolve-Path ".\_lb_smoke.exe").Path -Arguments "" -TimeoutMs 60000
Write-Host ("  smoke: " + $rls.StdOut.Trim())
Remove-Item _arena_demo.exe,_arena_demo.ll,_arena_demo_asan.exe,_adm_out.txt,_adm_err.txt,_lb_smoke.exe,leak_baseline_test.ll -Force -ErrorAction SilentlyContinue
Write-Host "=== iter-93 DERISK DONE ==="
