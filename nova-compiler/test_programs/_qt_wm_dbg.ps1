$dir = $PSScriptRoot
$env:NOVA_NO_CACHE = "1"
$compiler = "$dir\gen4_test.exe"
$test = "_where_multi_test"

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
$co = $p.StandardOutput.ReadToEnd()
$ce = $p.StandardError.ReadToEnd()
$exited = $p.WaitForExit(60000)
if (-not $exited) { try { $p.Kill() } catch {}; Write-Host "TIMEOUT"; exit 1 }
Write-Host "STDOUT:`n$co"
Write-Host "STDERR:`n$ce"
Write-Host "EXIT: $($p.ExitCode)"
if (Test-Path "$dir\$test.ll") { Write-Host "LL EXISTS" } else { Write-Host "NO LL" }
