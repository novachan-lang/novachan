Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
# Broad Linux portability sweep: cross-build a representative batch of regression tests
# to Linux x86_64 ELF and RUN them in WSL Ubuntu. A test PASSES on Linux iff it exits 0
# (the regression tests self-assert via assert_*/exit(1), so exit 0 = correct behavior).
# Phase A (Windows): gen3 .nova -> .ll; rewrite triple+datalayout; clang lowers -> linux .o.
# Phase B (one WSL call): gcc builds nova_runtime.c ONCE, then links+runs each test
# (kill-on-timeout via linux `timeout`), run from the test dir so relative file inputs resolve.
$batch = @(
  'float_test','string_test','list_test','dict_test','closure_test','struct_test',
  'struct_advanced_test','match_test','match_advanced_test','enum_test','higher_order_test',
  'map_filter_test','generics_test','trait_test','string_methods_test','string_ops_test',
  'math_test','bitwise_test','range_test','type_conv_test','destructure_test','tuple_test',
  'error_test','match_guard_test','spawn_test','yield_test','dict_iter_test','tensor_churn_test',
  'ai_classify_test','json_float_test','json_decode_float_test','read_bytes_test','stdlib_test',
  'supervisor_test','string_index_test','string_iter_test','mixed_arith_test','str_identity_test',
  'mlp_inference_test','tensor_ops_test'
)
# clean old sweep artifacts
Get-ChildItem -Filter "*__lx.*" -ErrorAction SilentlyContinue | Remove-Item -Force -ErrorAction SilentlyContinue
Remove-Item "_xcs_list.txt" -Force -ErrorAction SilentlyContinue

$lowered = @()
foreach ($t in $batch) {
    if (!(Test-Path "$t.nova")) { Write-Host ("SKIP (no .nova): " + $t); continue }
    Remove-Item "$t.ll" -Force -ErrorAction SilentlyContinue
    $c = Invoke-Timed -FilePath ".\gen3_test.exe" -Arguments "$t.nova" -TimeoutMs 90000 -WorkingDirectory $PSScriptRoot
    if ($c.ExitCode -ne 0 -or !(Test-Path "$t.ll")) { Write-Host ("GEN3_FAIL: " + $t); continue }
    $ll = Get-Content "$t.ll" -Raw
    $ll = $ll -replace 'target triple = "x86_64-pc-windows-msvc"', 'target triple = "x86_64-unknown-linux-gnu"'
    $ll = $ll -replace 'target datalayout = "e-m:w-', 'target datalayout = "e-m:e-'
    Set-Content "${t}__lx.ll" -Value $ll -Encoding ASCII -NoNewline
    $o = Invoke-Timed -FilePath $ClangPath -Arguments "--target=x86_64-unknown-linux-gnu -O2 -c `"${t}__lx.ll`" -o `"${t}__lx.o`"" -TimeoutMs 90000 -WorkingDirectory $PSScriptRoot
    if (!(Test-Path "${t}__lx.o")) { Write-Host ("CLANG_LOWER_FAIL: " + $t); continue }
    Remove-Item "$t.ll","${t}__lx.ll" -Force -ErrorAction SilentlyContinue
    $lowered += $t
}
Set-Content "_xcs_list.txt" -Value ($lowered -join "`n") -Encoding ASCII
Write-Host ("Lowered to linux .o: " + $lowered.Count + " / " + $batch.Count)

# Force LF on the bash script (Windows checkout may CRLF it; CR breaks bash) and run it.
$shRaw = (Get-Content "_xc_sweep.sh" -Raw) -replace "`r`n", "`n"
Set-Content "_xc_sweep.sh" -Value $shRaw -Encoding ASCII -NoNewline
$base = "/mnt/c/Users/mange/Crypto/AI/New folder/New folder/nova-compiler/test_programs"
$shMnt = "$base/_xc_sweep.sh"
$r = & wsl -d Ubuntu -e bash $shMnt $base 2>&1 | Out-String
Write-Host $r
# cleanup windows-side .o
Get-ChildItem -Filter "*__lx.o" -ErrorAction SilentlyContinue | Remove-Item -Force -ErrorAction SilentlyContinue
