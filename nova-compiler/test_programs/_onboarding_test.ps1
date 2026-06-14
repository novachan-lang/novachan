# Oracle: a fresh user can `nova run` a project from any cwd with NO env var (the first-download floor).
Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
$nova = (Resolve-Path ".\nova.exe").Path
$tmp = Join-Path $env:TEMP ("nova_onb_" + [System.IO.Path]::GetRandomFileName().Substring(0,6))
New-Item -ItemType Directory -Force -Path $tmp | Out-Null
Set-Content -Path (Join-Path $tmp "hello.nova") -Value "fn main()`n    print(`"Hello onboarding`")" -Encoding ASCII
$o1 = $env:NOVA_HOME; $o2 = $env:NOVA_RUNTIME; $env:NOVA_HOME=""; $env:NOVA_RUNTIME=""
$r = Invoke-Timed -FilePath $nova -Arguments "run hello.nova" -TimeoutMs 90000 -WorkingDirectory $tmp
$env:NOVA_HOME=$o1; $env:NOVA_RUNTIME=$o2
Write-Host ("exit=" + $r.ExitCode)
Write-Host ("stdout: " + $r.StdOut.Trim())
if ($r.StdErr.Trim()) { Write-Host ("stderr: " + $r.StdErr.Trim()) }
Remove-Item -Recurse -Force $tmp -ErrorAction SilentlyContinue
if ($r.ExitCode -eq 0 -and $r.StdOut -match "Hello onboarding") { Write-Host "ONBOARDING_OK" } else { Write-Host "ONBOARDING_FAIL"; exit 1 }
