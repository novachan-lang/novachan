Set-Location $PSScriptRoot
Copy-Item "output\nova_runtime.c" "nova_runtime.c" -Force

# Test all the bisection cases that were failing
foreach ($t in @("mini5_test", "mini6_test", "mini7_test", "mini8_test")) {
    if (Test-Path "$t.ll") { Remove-Item "$t.ll" -Force }
    $psi = New-Object System.Diagnostics.ProcessStartInfo
    $psi.FileName = (Resolve-Path ".\gen2_trait.exe").Path
    $psi.Arguments = "$t.nova"
    $psi.UseShellExecute = $false
    $psi.RedirectStandardOutput = $true
    $psi.RedirectStandardError = $true
    $psi.CreateNoWindow = $true
    $proc = [System.Diagnostics.Process]::Start($psi)
    $stdout = $proc.StandardOutput.ReadToEnd()
    $stderr = $proc.StandardError.ReadToEnd()
    $proc.WaitForExit(10000) | Out-Null
    Write-Host "$t : exit=$($proc.ExitCode) ll=$(Test-Path "$t.ll")"
    if ($proc.ExitCode -ne 0 -and $stderr.Length -gt 0) {
        Write-Host "  ERR: $($stderr.Substring(0, [Math]::Min(200, $stderr.Length)))"
    }
    if (Test-Path "$t.ll") { Remove-Item "$t.ll" -Force }
}

Remove-Item "nova_runtime.c" -Force -ErrorAction SilentlyContinue
