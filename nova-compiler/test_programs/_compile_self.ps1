Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"

$compiler = (Resolve-Path "$PSScriptRoot\gen3_test.exe").Path
$runtimeSrc = "$PSScriptRoot\output\nova_runtime.c"

Write-Host "=== Recompiling nova_compiler.nova ==="
$cr = Invoke-Timed -FilePath $compiler -Arguments "nova_compiler.nova" -TimeoutMs 120000 -WorkingDirectory $PSScriptRoot
if ($cr.TimedOut) {
    Write-Host "TIMEOUT compiling nova_compiler.nova"
    exit 1
}
if ($cr.ExitCode -ne 0) {
    Write-Host "FAIL compile (exit=$($cr.ExitCode))"
    Write-Host $cr.StdErr
    exit 1
}
if (!(Test-Path "$PSScriptRoot\nova_compiler.ll")) {
    Write-Host "FAIL: no nova_compiler.ll produced"
    exit 1
}
Write-Host "LL produced: $((Get-Item "$PSScriptRoot\nova_compiler.ll").Length) bytes"

$linkArgs = "-O2 -o `"$PSScriptRoot\gen3_w5b_new.exe`" `"$PSScriptRoot\nova_compiler.ll`" `"$runtimeSrc`" $NovaLinkFlags -D_CRT_SECURE_NO_WARNINGS -w"
$lr = Invoke-Timed -FilePath $ClangPath -Arguments $linkArgs -TimeoutMs 120000 -WorkingDirectory $PSScriptRoot
if (!(Test-Path "$PSScriptRoot\gen3_w5b_new.exe")) {
    Write-Host "FAIL link"
    exit 1
}
Write-Host "gen3_w5b_new.exe built: $((Get-Item "$PSScriptRoot\gen3_w5b_new.exe").Length) bytes"
Remove-Item "$PSScriptRoot\nova_compiler.ll" -Force -ErrorAction SilentlyContinue
Write-Host "=== Self-compile SUCCESS ==="
