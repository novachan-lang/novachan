Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
$gen = (Resolve-Path ".\gen3_test.exe").Path
$tmp = Join-Path $env:TEMP ("nova_onb_" + [System.IO.Path]::GetRandomFileName().Substring(0,6))
New-Item -ItemType Directory -Force -Path $tmp | Out-Null
Set-Content -Path (Join-Path $tmp "hello.nova") -Value "fn main()`n    print(`"Hello onboarding`")" -Encoding ASCII
# clear discovery env vars for THIS child only
$old1 = $env:NOVA_HOME; $old2 = $env:NOVA_RUNTIME; $env:NOVA_HOME=""; $env:NOVA_RUNTIME=""
Write-Host "tmp=$tmp (cwd will be here; no NOVA_HOME/NOVA_RUNTIME)"
$r = Invoke-Timed -FilePath $gen -Arguments "run hello.nova" -TimeoutMs 60000 -WorkingDirectory $tmp
Write-Host ("exit=" + $r.ExitCode)
Write-Host "--- stdout ---"; Write-Host $r.StdOut
Write-Host "--- stderr ---"; Write-Host $r.StdErr
$env:NOVA_HOME=$old1; $env:NOVA_RUNTIME=$old2
Remove-Item -Recurse -Force $tmp -ErrorAction SilentlyContinue
