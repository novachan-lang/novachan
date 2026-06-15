$dir = $PSScriptRoot
$env:NOVA_NO_CACHE = "1"
$compiler = "$dir\gen4_test.exe"
$rtSrc = "$dir\output\nova_runtime.c"
$linkFlags = @("-lws2_32","-ladvapi32","-D_CRT_SECURE_NO_WARNINGS","-w")

Remove-Item "$dir\_multi_let_test.ll" -Force -ErrorAction SilentlyContinue
$psi = New-Object System.Diagnostics.ProcessStartInfo
$psi.FileName = $compiler
$psi.Arguments = "_multi_let_test.nova"
$psi.WorkingDirectory = $dir
$psi.UseShellExecute = $false
$psi.RedirectStandardOutput = $true
$psi.RedirectStandardError = $true
$psi.CreateNoWindow = $true
$p = New-Object System.Diagnostics.Process
$p.StartInfo = $psi
$p.Start() | Out-Null
$o = $p.StandardOutput.ReadToEnd()
$e = $p.StandardError.ReadToEnd()
$exited = $p.WaitForExit(60000)
if (-not $exited) { try { $p.Kill() } catch {}; Write-Host "TIMEOUT"; exit 1 }
if ($e) { Write-Host "STDERR: $e" }
if (-not (Test-Path "$dir\_multi_let_test.ll")) { Write-Host "COMPILE FAILED"; Write-Host $o; exit 1 }
Write-Host "Compiled OK"

& clang "$dir\_multi_let_test.ll" $rtSrc -o "$dir\_multi_let_test.exe" -O2 @linkFlags 2>"$dir\_mlt_lerr.txt"
if ($LASTEXITCODE -ne 0) { Write-Host "LINK FAILED"; exit 1 }
Write-Host "Linked OK"

$psi2 = New-Object System.Diagnostics.ProcessStartInfo
$psi2.FileName = "$dir\_multi_let_test.exe"
$psi2.WorkingDirectory = $dir
$psi2.UseShellExecute = $false
$psi2.RedirectStandardOutput = $true
$psi2.RedirectStandardError = $true
$psi2.CreateNoWindow = $true
$p2 = New-Object System.Diagnostics.Process
$p2.StartInfo = $psi2
$p2.Start() | Out-Null
$o2 = $p2.StandardOutput.ReadToEnd()
$e2 = $p2.StandardError.ReadToEnd()
$exited2 = $p2.WaitForExit(30000)
if (-not $exited2) { try { $p2.Kill() } catch {}; Write-Host "RUN TIMEOUT"; exit 1 }
if ($e2) { Write-Host "RUN STDERR: $e2" }
Write-Host $o2
if ($p2.ExitCode -ne 0) { Write-Host "EXIT CODE: $($p2.ExitCode)"; exit 1 }
Write-Host "ALL PASSED"
