Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
Remove-Item nova_compiler.ll -Force -ErrorAction SilentlyContinue
Write-Host "Compiling nova_compiler.nova with gen3_test.exe..."
$r = Invoke-Timed -FilePath '.\gen3_test.exe' -Arguments 'nova_compiler.nova' -TimeoutMs 450000 -WorkingDirectory $PSScriptRoot
if ($r.TimedOut) { Write-Host "COMPILE TIMEOUT"; exit 1 }
if ($r.ExitCode -ne 0) { Write-Host "COMPILE FAIL exit=$($r.ExitCode)"; if ($r.StdOut) { Write-Host $r.StdOut.Substring(0,[Math]::Min(2000,$r.StdOut.Length)) }; exit 1 }
if (!(Test-Path nova_compiler.ll)) { Write-Host "NO .ll FILE"; exit 1 }
Write-Host "Linking to gen4_test.exe..."
$link = "-O2 -o gen4_test.exe nova_compiler.ll output\nova_runtime.o -lws2_32 -ladvapi32 -D_CRT_SECURE_NO_WARNINGS -w"
$cr = Invoke-Timed -FilePath 'clang' -Arguments $link -TimeoutMs 90000 -WorkingDirectory $PSScriptRoot
if ($cr.ExitCode -ne 0) { Write-Host "LINK FAIL"; if ($cr.StdOut) { Write-Host $cr.StdOut }; exit 1 }
$sz = (Get-Item gen4_test.exe).Length
Write-Host "gen4_test.exe ($sz bytes) built OK"
