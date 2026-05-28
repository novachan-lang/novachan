Set-Location $PSScriptRoot
Copy-Item "output\nova_runtime.c" "nova_runtime.c" -Force

foreach ($t in @("mini5_test", "mini6_test")) {
    if (Test-Path "$t.ll") { Remove-Item "$t.ll" -Force }
    $psi = New-Object System.Diagnostics.ProcessStartInfo
    $psi.FileName = (Resolve-Path ".\gen2_trait.exe").Path
    $psi.Arguments = "$t.nova"
    $psi.UseShellExecute = $false
    $psi.RedirectStandardOutput = $true
    $psi.RedirectStandardError = $true
    $psi.CreateNoWindow = $true
    $proc = [System.Diagnostics.Process]::Start($psi)
    $proc.WaitForExit(10000) | Out-Null
    Write-Host "$t : exit=$($proc.ExitCode) ll=$(Test-Path "$t.ll")"
}

Remove-Item "nova_runtime.c" -Force -ErrorAction SilentlyContinue
