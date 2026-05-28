Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
Copy-Item "output\nova_runtime.c" "nova_runtime.c" -Force

$cr = Invoke-Timed -FilePath (Resolve-Path ".\gen2_move.exe").Path -Arguments "dict_merge_test.nova" -TimeoutMs 30000
if ($cr.ExitCode -ne 0) {
    Write-Host "COMPILE FAIL"
    if ($cr.StdErr) { Write-Host $cr.StdErr.Substring(0, [Math]::Min(500, $cr.StdErr.Length)) }
    exit 1
}
Write-Host "Compiled OK"

$lr = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o dict_merge_test.exe dict_merge_test.ll nova_runtime.c $NovaLinkFlags" -TimeoutMs 30000
if (!(Test-Path "dict_merge_test.exe")) {
    Write-Host "LINK FAIL"
    exit 1
}

$rr = Invoke-Timed -FilePath (Resolve-Path ".\dict_merge_test.exe").Path -Arguments "" -TimeoutMs 10000
Write-Host "Exit: $($rr.ExitCode)"
if ($rr.StdOut) { Write-Host $rr.StdOut }
if ($rr.StdErr) { Write-Host "STDERR: $($rr.StdErr.Substring(0, [Math]::Min(200, $rr.StdErr.Length)))" }

Remove-Item "dict_merge_test.nova","dict_merge_test.ll","dict_merge_test.exe","nova_runtime.c" -Force -ErrorAction SilentlyContinue
