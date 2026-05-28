Set-Location $PSScriptRoot
Copy-Item "output\nova_runtime.c" "nova_runtime.c" -Force

foreach ($t in @("trait_test", "float_test")) {
    if (Test-Path "$t.ll") { Remove-Item "$t.ll" -Force }

    # Compile with gen2
    $psi = New-Object System.Diagnostics.ProcessStartInfo
    $psi.FileName = (Resolve-Path ".\gen2_trait.exe").Path
    $psi.Arguments = "$t.nova"
    $psi.UseShellExecute = $false
    $psi.RedirectStandardOutput = $true
    $psi.RedirectStandardError = $true
    $psi.CreateNoWindow = $true
    $proc = [System.Diagnostics.Process]::Start($psi)
    $proc.WaitForExit(15000) | Out-Null

    if (-not (Test-Path "$t.ll")) {
        Write-Host "$t : COMPILE FAILED"
        continue
    }

    # Link
    & clang -O2 -o "$t.exe" "$t.ll" "nova_runtime.c" -lws2_32 2>$null
    if (-not (Test-Path "$t.exe")) {
        Write-Host "$t : LINK FAILED"
        Remove-Item "$t.ll" -Force -ErrorAction SilentlyContinue
        continue
    }

    # Run with timeout
    $rpsi = New-Object System.Diagnostics.ProcessStartInfo
    $rpsi.FileName = (Resolve-Path ".\$t.exe").Path
    $rpsi.UseShellExecute = $false
    $rpsi.RedirectStandardOutput = $true
    $rpsi.RedirectStandardError = $true
    $rpsi.CreateNoWindow = $true
    $rproc = [System.Diagnostics.Process]::Start($rpsi)
    $stdout = $rproc.StandardOutput.ReadToEnd()
    $rproc.WaitForExit(10000) | Out-Null

    Write-Host "=== $t output ==="
    Write-Host $stdout
    Write-Host "exit=$($rproc.ExitCode)"
    Write-Host ""

    Remove-Item "$t.ll" -Force -ErrorAction SilentlyContinue
    Remove-Item "$t.exe" -Force -ErrorAction SilentlyContinue
}

Remove-Item "nova_runtime.c" -Force -ErrorAction SilentlyContinue
