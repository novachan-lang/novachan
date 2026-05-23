Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
Copy-Item "output\nova_runtime.c" "nova_runtime.c" -Force
$cr = Invoke-Timed -FilePath (Resolve-Path ".\gen2_move.exe").Path -Arguments "tensor_demo.nova" -TimeoutMs 60000
Write-Host "Compile exit: $($cr.ExitCode)"
if ($cr.StdOut) { Write-Host "stdout: $($cr.StdOut)" }
if ($cr.ExitCode -ne 0) {
    if ($cr.StdErr) { Write-Host "stderr: $($cr.StdErr)" }
    exit 1
}
$lr = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o tensor_demo.exe tensor_demo.ll nova_runtime.c -lws2_32" -TimeoutMs 60000
Write-Host "Link exit: $($lr.ExitCode)"
if (!(Test-Path "tensor_demo.exe")) { exit 1 }
$rr = Invoke-Timed -FilePath (Resolve-Path ".\tensor_demo.exe").Path -Arguments "" -TimeoutMs 30000
Write-Host "Run exit: $($rr.ExitCode)"
Write-Host "Output:"
Write-Host $rr.StdOut
Remove-Item "tensor_demo.ll","tensor_demo.exe","nova_runtime.c" -Force -ErrorAction SilentlyContinue
