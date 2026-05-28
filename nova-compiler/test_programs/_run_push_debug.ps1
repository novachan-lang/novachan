Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
Copy-Item "output\nova_runtime.c" "nova_runtime.c" -Force

$cr = Invoke-Timed -FilePath (Resolve-Path ".\gen2_move.exe").Path -Arguments "push_debug.nova" -TimeoutMs 30000
if ($cr.ExitCode -ne 0) { Write-Host "COMPILE FAIL"; if ($cr.StdErr) { Write-Host $cr.StdErr }; exit 1 }

$lr = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o push_debug.exe push_debug.ll nova_runtime.c $NovaLinkFlags" -TimeoutMs 30000
if (!(Test-Path "push_debug.exe")) { Write-Host "LINK FAIL"; exit 1 }

$rr = Invoke-Timed -FilePath (Resolve-Path ".\push_debug.exe").Path -Arguments "" -TimeoutMs 10000
Write-Host "Exit: $($rr.ExitCode)"
if ($rr.StdOut) { Write-Host $rr.StdOut }
if ($rr.StdErr) { Write-Host "STDERR: $($rr.StdErr.Substring(0, [Math]::Min(300, $rr.StdErr.Length)))" }

Remove-Item "push_debug.nova","push_debug.ll","push_debug.exe","nova_runtime.c" -Force -ErrorAction SilentlyContinue
