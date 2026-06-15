param([string]$Compiler, [string]$Source)
Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
$r = Invoke-Timed -FilePath $Compiler -Arguments $Source -TimeoutMs 30000 -WorkingDirectory $PSScriptRoot
if ($r.TimedOut) { Write-Host "COMPILE TIMEOUT"; exit 1 }
if ($r.ExitCode -ne 0) { Write-Host "COMPILE FAIL exit=$($r.ExitCode)"; if ($r.StdOut) { Write-Host $r.StdOut.Substring(0,[Math]::Min(2000,$r.StdOut.Length)) }; exit 1 }
$base = [System.IO.Path]::GetFileNameWithoutExtension($Source)
$ll = "$base.ll"
if (!(Test-Path $ll)) { Write-Host "NO .ll FILE"; exit 1 }
$exe = "$base.exe"
$link = "-O2 -o `"$exe`" `"$ll`" `"output\nova_runtime.c`" -lws2_32 -ladvapi32 -D_CRT_SECURE_NO_WARNINGS -w"
$cr = Invoke-Timed -FilePath 'clang' -Arguments $link -TimeoutMs 60000 -WorkingDirectory $PSScriptRoot
if ($cr.ExitCode -ne 0) { Write-Host "LINK FAIL"; if ($cr.StdOut) { Write-Host $cr.StdOut }; exit 1 }
Write-Host "=== Running $exe ==="
$rr = Invoke-Timed -FilePath ".\$exe" -Arguments '' -TimeoutMs 10000 -WorkingDirectory $PSScriptRoot
Write-Host "Exit: $($rr.ExitCode)"
if ($rr.StdOut) { Write-Host $rr.StdOut }
if ($rr.StdErr) { Write-Host "STDERR: $($rr.StdErr)" }
if ($rr.TimedOut) { Write-Host "RUN TIMEOUT" }
exit $rr.ExitCode
