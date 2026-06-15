$dir = $PSScriptRoot
$env:NOVA_NO_CACHE = "1"
$linkFlags = @("-lws2_32","-ladvapi32","-D_CRT_SECURE_NO_WARNINGS","-w")
$rtSrc = "$dir\output\nova_runtime.c"

Remove-Item "$dir\_ergo_survey.ll" -Force -ErrorAction SilentlyContinue
$psi = New-Object System.Diagnostics.ProcessStartInfo
$psi.FileName = "$dir\gen4_test.exe"
$psi.Arguments = "_ergo_survey.nova"
$psi.WorkingDirectory = $dir
$psi.UseShellExecute = $false
$psi.RedirectStandardOutput = $true
$psi.RedirectStandardError = $true
$psi.CreateNoWindow = $true
$proc = New-Object System.Diagnostics.Process
$proc.StartInfo = $psi
$proc.Start() | Out-Null
$stdout = $proc.StandardOutput.ReadToEnd()
$stderr = $proc.StandardError.ReadToEnd()
$proc.WaitForExit(60000) | Out-Null
if ($stderr) { Write-Host "COMPILE STDERR: $stderr" }
if ($stdout) { Write-Host "COMPILE STDOUT: $stdout" }
if (-not (Test-Path "$dir\_ergo_survey.ll")) { Write-Host "COMPILE FAILED"; exit 1 }

& clang "$dir\_ergo_survey.ll" "$rtSrc" -o "$dir\_ergo_survey.exe" -O2 @linkFlags 2>"$dir\_es_lerr.txt"
if ($LASTEXITCODE -ne 0) { Write-Host "LINK FAILED"; Get-Content "$dir\_es_lerr.txt"; exit 1 }

$psi2 = New-Object System.Diagnostics.ProcessStartInfo
$psi2.FileName = "$dir\_ergo_survey.exe"
$psi2.WorkingDirectory = $dir
$psi2.UseShellExecute = $false
$psi2.RedirectStandardOutput = $true
$psi2.RedirectStandardError = $true
$psi2.CreateNoWindow = $true
$r = New-Object System.Diagnostics.Process
$r.StartInfo = $psi2
$r.Start() | Out-Null
$rout = $r.StandardOutput.ReadToEnd()
$rerr = $r.StandardError.ReadToEnd()
$r.WaitForExit(15000) | Out-Null
Write-Host "EXIT: $($r.ExitCode)"
Write-Host "OUTPUT:"
Write-Host $rout
if ($rerr) { Write-Host "STDERR: $rerr" }
