$dir = $PSScriptRoot
$env:NOVA_NO_CACHE = "1"

Remove-Item "$dir\hello.ll" -Force -ErrorAction SilentlyContinue
$psi = New-Object System.Diagnostics.ProcessStartInfo
$psi.FileName = "$dir\gen4_test.exe"
$psi.Arguments = "hello.nova"
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
$exited = $proc.WaitForExit(60000)
Write-Host "EXITED: $exited"
Write-Host "EXIT CODE: $($proc.ExitCode)"
Write-Host "STDOUT len: $($stdout.Length)"
Write-Host "STDERR len: $($stderr.Length)"
if ($stderr.Length -gt 0 -and $stderr.Length -lt 500) { Write-Host "STDERR: $stderr" }
Write-Host "LL EXISTS: $(Test-Path "$dir\hello.ll")"
