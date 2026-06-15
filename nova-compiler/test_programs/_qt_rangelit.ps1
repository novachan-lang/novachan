$dir = $PSScriptRoot
$env:NOVA_NO_CACHE = "1"
$compiler = "$dir\gen4_test.exe"
$rtSrc = "$dir\output\nova_runtime.c"
$linkFlags = @("-lws2_32","-ladvapi32","-D_CRT_SECURE_NO_WARNINGS","-w")
$test = "_range_check"

Remove-Item "$dir\$test.ll" -Force -ErrorAction SilentlyContinue
$psi = New-Object System.Diagnostics.ProcessStartInfo
$psi.FileName = $compiler
$psi.Arguments = "$test.nova"
$psi.WorkingDirectory = $dir
$psi.UseShellExecute = $false
$psi.RedirectStandardOutput = $true
$psi.RedirectStandardError = $true
$psi.CreateNoWindow = $true
$p = New-Object System.Diagnostics.Process
$p.StartInfo = $psi
$p.Start() | Out-Null
$p.StandardOutput.ReadToEnd() | Out-Null
$p.StandardError.ReadToEnd() | Out-Null
$exited = $p.WaitForExit(60000)
if (-not $exited) { try { $p.Kill() } catch {}; Write-Host "COMPILE TIMEOUT"; exit 1 }
if (-not (Test-Path "$dir\$test.ll")) { Write-Host "COMPILE FAILED"; exit 1 }

& clang "$dir\$test.ll" $rtSrc -o "$dir\$test.exe" -O2 @linkFlags 2>"$dir\_rc_lerr.txt"
if ($LASTEXITCODE -ne 0) { Write-Host "LINK FAILED"; exit 1 }

$psi2 = New-Object System.Diagnostics.ProcessStartInfo
$psi2.FileName = "$dir\$test.exe"
$psi2.WorkingDirectory = $dir
$psi2.UseShellExecute = $false
$psi2.RedirectStandardOutput = $true
$psi2.RedirectStandardError = $true
$psi2.CreateNoWindow = $true
$p2 = New-Object System.Diagnostics.Process
$p2.StartInfo = $psi2
$p2.Start() | Out-Null
$out = $p2.StandardOutput.ReadToEnd()
$p2.StandardError.ReadToEnd() | Out-Null
$exited2 = $p2.WaitForExit(30000)
if (-not $exited2) { try { $p2.Kill() } catch {}; Write-Host "RUN TIMEOUT"; exit 1 }
Write-Host $out
if ($p2.ExitCode -ne 0) { Write-Host "EXIT CODE: $($p2.ExitCode)"; exit 1 }
Write-Host "PASS"
