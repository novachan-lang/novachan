Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
$env:NOVA_NO_CACHE = "1"
$compiler = (Resolve-Path ".\gen3_test.exe").Path
$runtimeSrc = "$PSScriptRoot\output\nova_runtime.c"
$tests = @('float_test','list_test','string_test','closure_test','match_test','struct_test','dict_test','for_test','enum_test','range_test','tuple_test','defaults_test','named_args_test','comprehension_test','match_guard_test','method_test')
$pass = 0; $fail = 0; $failures = @()
foreach ($t in $tests) {
    $nova = "$PSScriptRoot\$t.nova"
    if (!(Test-Path $nova)) { continue }
    $cr = Invoke-Timed -FilePath $compiler -Arguments "$t.nova" -TimeoutMs 30000 -WorkingDirectory $PSScriptRoot
    if ($cr.ExitCode -ne 0) { $failures += "$t (COMPILE)"; $fail++; continue }
    $lr = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o $t.exe $t.ll $runtimeSrc $NovaLinkFlags -D_CRT_SECURE_NO_WARNINGS -w" -TimeoutMs 30000 -WorkingDirectory $PSScriptRoot
    if (!(Test-Path "$t.exe")) { $failures += "$t (LINK)"; $fail++; Remove-Item "$t.ll" -Force -ErrorAction SilentlyContinue; continue }
    $rr = Invoke-Timed -FilePath (Resolve-Path ".\$t.exe").Path -Arguments '' -TimeoutMs 10000 -WorkingDirectory $PSScriptRoot
    Remove-Item "$t.exe","$t.ll" -Force -ErrorAction SilentlyContinue
    if ($rr.ExitCode -ne 0) { $failures += "$t (RUN exit=$($rr.ExitCode))"; $fail++ } else { $pass++ }
}
Write-Host "Smoke: $pass PASS, $fail FAIL"
if ($failures.Count -gt 0) { foreach ($f in $failures) { Write-Host "  $f" }; exit 1 }
