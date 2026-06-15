Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
$env:NOVA_NO_CACHE = "1"
$compiler = (Resolve-Path ".\gen3_test.exe").Path
$runtimeSrc = "$PSScriptRoot\output\nova_runtime.c"
Write-Host "Compiler: $compiler"
Write-Host "Runtime: $runtimeSrc (exists: $(Test-Path $runtimeSrc))"
Write-Host "ClangPath: $ClangPath"
Write-Host "NovaLinkFlags: $NovaLinkFlags"
$cr = Invoke-Timed -FilePath $compiler -Arguments "float_test.nova" -TimeoutMs 30000 -WorkingDirectory $PSScriptRoot
Write-Host "Compile exit: $($cr.ExitCode)"
Write-Host "float_test.ll exists: $(Test-Path 'float_test.ll')"
$linkArgs = "-O2 -o float_test.exe float_test.ll `"$runtimeSrc`" $NovaLinkFlags -D_CRT_SECURE_NO_WARNINGS -w"
Write-Host "Link args: $linkArgs"
$lr = Invoke-Timed -FilePath $ClangPath -Arguments $linkArgs -TimeoutMs 30000 -WorkingDirectory $PSScriptRoot
Write-Host "Link exit: $($lr.ExitCode)"
Write-Host "Link stdout: $($lr.StdOut)"
Write-Host "Link stderr: $($lr.StdErr)"
Write-Host "float_test.exe exists: $(Test-Path 'float_test.exe')"
if (Test-Path 'float_test.exe') {
    $rr = Invoke-Timed -FilePath (Resolve-Path ".\float_test.exe").Path -Arguments '' -TimeoutMs 5000 -WorkingDirectory $PSScriptRoot
    Write-Host "Run exit: $($rr.ExitCode)"
    Write-Host "Run stdout: $($rr.StdOut)"
}
Remove-Item float_test.exe,float_test.ll -Force -ErrorAction SilentlyContinue
