Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
Copy-Item "output\nova_runtime.c" "nova_runtime.c" -Force

$cr = Invoke-Timed -FilePath (Resolve-Path ".\gen2_move.exe").Path -Arguments "fpt_trace.nova" -TimeoutMs 30000
if ($cr.ExitCode -ne 0) {
    Write-Host "COMPILE FAIL"
    if ($cr.StdErr) { Write-Host $cr.StdErr.Substring(0, [Math]::Min(500, $cr.StdErr.Length)) }
    exit 1
}

$lr = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o fpt_trace.exe fpt_trace.ll nova_runtime.c $NovaLinkFlags" -TimeoutMs 30000
if (!(Test-Path "fpt_trace.exe")) { Write-Host "LINK FAIL"; exit 1 }

$rr = Invoke-Timed -FilePath (Resolve-Path ".\fpt_trace.exe").Path -Arguments "" -TimeoutMs 10000
Write-Host "Exit: $($rr.ExitCode)"
if ($rr.StdOut) { Write-Host $rr.StdOut }
if ($rr.StdErr) { Write-Host "STDERR: $($rr.StdErr.Substring(0, [Math]::Min(300, $rr.StdErr.Length)))" }

Remove-Item "fpt_trace.nova","fpt_trace.ll","fpt_trace.exe","nova_runtime.c" -Force -ErrorAction SilentlyContinue
