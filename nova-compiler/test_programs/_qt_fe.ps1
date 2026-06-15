$dir = $PSScriptRoot
$env:NOVA_NO_CACHE = "1"
$compiler = "$dir\gen4_test.exe"
$rtSrc = "$dir\output\nova_runtime.c"
$linkFlags = @("-lws2_32","-ladvapi32","-D_CRT_SECURE_NO_WARNINGS","-w")
$test = "_forelse_test"
Remove-Item "$dir\$test.ll" -Force -ErrorAction SilentlyContinue
$psi = New-Object System.Diagnostics.ProcessStartInfo
$psi.FileName = $compiler; $psi.Arguments = "$test.nova"; $psi.WorkingDirectory = $dir
$psi.UseShellExecute = $false; $psi.RedirectStandardOutput = $true; $psi.RedirectStandardError = $true; $psi.CreateNoWindow = $true
$p = New-Object System.Diagnostics.Process; $p.StartInfo = $psi; $p.Start() | Out-Null
$co = $p.StandardOutput.ReadToEnd(); $ce = $p.StandardError.ReadToEnd()
$exited = $p.WaitForExit(60000)
if (-not $exited) { try { $p.Kill() } catch {}; Write-Host "COMPILE TIMEOUT"; exit 1 }
if ($ce) { Write-Host "STDERR: $ce" }
if (-not (Test-Path "$dir\$test.ll")) { Write-Host "COMPILE FAILED: $co"; exit 1 }
& clang "$dir\$test.ll" $rtSrc -o "$dir\$test.exe" -O2 @linkFlags 2>"$dir\_fe_lerr.txt"
if ($LASTEXITCODE -ne 0) { Write-Host "LINK FAILED"; exit 1 }
$psi2 = New-Object System.Diagnostics.ProcessStartInfo
$psi2.FileName = "$dir\$test.exe"; $psi2.WorkingDirectory = $dir
$psi2.UseShellExecute = $false; $psi2.RedirectStandardOutput = $true; $psi2.RedirectStandardError = $true; $psi2.CreateNoWindow = $true
$p2 = New-Object System.Diagnostics.Process; $p2.StartInfo = $psi2; $p2.Start() | Out-Null
$o2 = $p2.StandardOutput.ReadToEnd(); $e2 = $p2.StandardError.ReadToEnd()
$exited2 = $p2.WaitForExit(30000)
if (-not $exited2) { try { $p2.Kill() } catch {}; Write-Host "RUN TIMEOUT"; exit 1 }
Write-Host $o2.Trim()
if ($e2) { Write-Host "ERR: $e2" }
Write-Host "EXIT: $($p2.ExitCode)"
