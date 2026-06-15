$dir = $PSScriptRoot
$env:NOVA_NO_CACHE = "1"
$linkFlags = @("-lws2_32","-ladvapi32","-D_CRT_SECURE_NO_WARNINGS","-w")
$rtSrc = "$dir\output\nova_runtime.c"

Write-Host "=== gen3 -> gen4 ==="
Remove-Item "$dir\nova_compiler.ll" -Force -ErrorAction SilentlyContinue
$psi = New-Object System.Diagnostics.ProcessStartInfo
$psi.FileName = "$dir\gen3_test.exe"
$psi.Arguments = "nova_compiler.nova"
$psi.WorkingDirectory = $dir
$psi.UseShellExecute = $false
$psi.RedirectStandardOutput = $true
$psi.RedirectStandardError = $true
$psi.CreateNoWindow = $true
$p = New-Object System.Diagnostics.Process
$p.StartInfo = $psi
$p.Start() | Out-Null
$p.StandardOutput.ReadToEnd() | Out-Null
$e = $p.StandardError.ReadToEnd()
$exited = $p.WaitForExit(450000)
if (-not $exited) { try { $p.Kill() } catch {}; Write-Host "gen3 TIMEOUT"; exit 1 }
if ($e) { Write-Host "gen3 ERR: $e" }
if (-not (Test-Path "$dir\nova_compiler.ll")) { Write-Host "gen3 FAILED"; exit 1 }
& clang "$dir\nova_compiler.ll" $rtSrc -o "$dir\gen4.exe" -O2 @linkFlags 2>"$dir\_bs_lerr.txt"
if ($LASTEXITCODE -ne 0) { Write-Host "gen4 LINK FAILED"; exit 1 }
Write-Host "gen4.exe built"

Write-Host "=== gen4 -> gen5 ==="
Remove-Item "$dir\nova_compiler.ll" -Force -ErrorAction SilentlyContinue
$psi2 = New-Object System.Diagnostics.ProcessStartInfo
$psi2.FileName = "$dir\gen4.exe"
$psi2.Arguments = "nova_compiler.nova"
$psi2.WorkingDirectory = $dir
$psi2.UseShellExecute = $false
$psi2.RedirectStandardOutput = $true
$psi2.RedirectStandardError = $true
$psi2.CreateNoWindow = $true
$p2 = New-Object System.Diagnostics.Process
$p2.StartInfo = $psi2
$p2.Start() | Out-Null
$o2 = $p2.StandardOutput.ReadToEnd()
$e2 = $p2.StandardError.ReadToEnd()
$exited2 = $p2.WaitForExit(120000)
if (-not $exited2) { try { $p2.Kill() } catch {}; Write-Host "gen4 TIMEOUT"; exit 1 }
if ($e2) { Write-Host "gen4 ERR: $e2" }
if (-not (Test-Path "$dir\nova_compiler.ll")) { Write-Host "gen4 FAILED"; Write-Host $o2; exit 1 }
Copy-Item "$dir\nova_compiler.ll" "$dir\gen5.ll" -Force
& clang "$dir\gen5.ll" $rtSrc -o "$dir\gen5.exe" -O2 @linkFlags 2>"$dir\_bs_lerr.txt"
if ($LASTEXITCODE -ne 0) { Write-Host "gen5 LINK FAILED"; exit 1 }
Write-Host "gen5.exe built"

Write-Host "=== gen5 -> gen6 ==="
Remove-Item "$dir\nova_compiler.ll" -Force -ErrorAction SilentlyContinue
$psi3 = New-Object System.Diagnostics.ProcessStartInfo
$psi3.FileName = "$dir\gen5.exe"
$psi3.Arguments = "nova_compiler.nova"
$psi3.WorkingDirectory = $dir
$psi3.UseShellExecute = $false
$psi3.RedirectStandardOutput = $true
$psi3.RedirectStandardError = $true
$psi3.CreateNoWindow = $true
$p3 = New-Object System.Diagnostics.Process
$p3.StartInfo = $psi3
$p3.Start() | Out-Null
$o3 = $p3.StandardOutput.ReadToEnd()
$e3 = $p3.StandardError.ReadToEnd()
$exited3 = $p3.WaitForExit(120000)
if (-not $exited3) { try { $p3.Kill() } catch {}; Write-Host "gen5 TIMEOUT"; exit 1 }
if ($e3) { Write-Host "gen5 ERR: $e3" }
if (-not (Test-Path "$dir\nova_compiler.ll")) { Write-Host "gen5 FAILED"; Write-Host $o3; exit 1 }
Copy-Item "$dir\nova_compiler.ll" "$dir\gen6.ll" -Force

$h5 = (Get-FileHash "$dir\gen5.ll" -Algorithm SHA256).Hash
$h6 = (Get-FileHash "$dir\gen6.ll" -Algorithm SHA256).Hash
Write-Host "gen5: $h5"
Write-Host "gen6: $h6"
if ($h5 -eq $h6) {
    Write-Host "CONVERGED"
    & clang "$dir\gen6.ll" $rtSrc -o "$dir\gen6.exe" -O2 @linkFlags 2>"$dir\_bs_lerr.txt"
    if ($LASTEXITCODE -ne 0) { Write-Host "gen6 LINK FAILED"; exit 1 }
    Copy-Item "$dir\gen6.exe" "$dir\gen4_test.exe" -Force
    Write-Host "INSTALLED"
} else {
    Write-Host "DIVERGED"; exit 1
}
