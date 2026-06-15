Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"

$compiler = (Resolve-Path "$PSScriptRoot\gen3_test.exe").Path
$runtimeSrc = "$PSScriptRoot\output\nova_runtime.c"

$tests = @(
    'float_test','struct_test','match_test','spawn_test','closure_test',
    'dict_test','for_continue_test','match_result_test','debugx',
    'real_cli_grep','real_http_api','nova_fmt','protocol_builtin_test',
    'green_netpoll_test'
)

$pass = 0; $fail = 0
foreach ($t in $tests) {
    $nova = "$PSScriptRoot\$t.nova"
    $ll   = "$PSScriptRoot\$t.ll"
    $exe  = "$PSScriptRoot\$t.exe"

    if (!(Test-Path $nova)) { continue }

    $cr = Invoke-Timed -FilePath $compiler -Arguments "$t.nova" -TimeoutMs 60000 -WorkingDirectory $PSScriptRoot
    if ($cr.ExitCode -ne 0) { Write-Host "FAIL compile: $t"; $fail++; continue }
    if (!(Test-Path $ll)) { Write-Host "FAIL no-ll: $t"; $fail++; continue }

    $linkArgs = "-O2 -o `"$exe`" `"$ll`" `"$runtimeSrc`" $NovaLinkFlags -D_CRT_SECURE_NO_WARNINGS -w"
    $lr = Invoke-Timed -FilePath $ClangPath -Arguments $linkArgs -TimeoutMs 60000 -WorkingDirectory $PSScriptRoot
    if (!(Test-Path $exe)) { Write-Host "FAIL link: $t"; $fail++; Remove-Item $ll -Force -ea SilentlyContinue; continue }

    $rr = Invoke-Timed -FilePath $exe -Arguments '' -TimeoutMs 15000 -WorkingDirectory $PSScriptRoot
    Remove-Item $exe,$ll -Force -ea SilentlyContinue
    if ($rr.TimedOut -or $rr.ExitCode -ne 0) { Write-Host "FAIL run: $t (exit=$($rr.ExitCode))"; $fail++ }
    else { Write-Host "PASS $t"; $pass++ }
}
Write-Host ""
Write-Host "=== SMOKE: $pass PASS, $fail FAIL ==="
if ($fail -gt 0) { exit 1 }
