$dir = $PSScriptRoot
$env:NOVA_NO_CACHE = "1"
$gen3 = "$dir\gen3_test.exe"
$rtSrc = "$dir\output\nova_runtime.c"
$linkFlags = @("-lws2_32","-ladvapi32","-D_CRT_SECURE_NO_WARNINGS","-w")

Write-Host "=== gen3 -> gen4 ==="
Remove-Item "$dir\nova_compiler.ll" -Force -ErrorAction SilentlyContinue
$psi = New-Object System.Diagnostics.ProcessStartInfo
$psi.FileName = $gen3
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
$p.StandardError.ReadToEnd() | Out-Null
$exited = $p.WaitForExit(450000)
if (-not $exited) { try { $p.Kill() } catch {}; Write-Host "gen3 TIMEOUT"; exit 1 }
if (-not (Test-Path "$dir\nova_compiler.ll")) { Write-Host "gen3 FAILED"; exit 1 }
& clang "$dir\nova_compiler.ll" $rtSrc -o "$dir\gen4.exe" -O2 @linkFlags 2>"$dir\_bw2_lerr.txt"
if ($LASTEXITCODE -ne 0) { Write-Host "gen4 LINK FAILED"; exit 1 }
Write-Host "gen4 built"

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
$p2.StandardOutput.ReadToEnd() | Out-Null
$p2.StandardError.ReadToEnd() | Out-Null
$exited2 = $p2.WaitForExit(120000)
if (-not $exited2) { try { $p2.Kill() } catch {}; Write-Host "gen4 TIMEOUT"; exit 1 }
if (-not (Test-Path "$dir\nova_compiler.ll")) { Write-Host "gen4 FAILED"; exit 1 }
Copy-Item "$dir\nova_compiler.ll" "$dir\gen5.ll" -Force
& clang "$dir\nova_compiler.ll" $rtSrc -o "$dir\gen5.exe" -O2 @linkFlags 2>"$dir\_bw2_lerr2.txt"
if ($LASTEXITCODE -ne 0) { Write-Host "gen5 LINK FAILED"; exit 1 }
Write-Host "gen5 built"

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
$p3.StandardOutput.ReadToEnd() | Out-Null
$p3.StandardError.ReadToEnd() | Out-Null
$exited3 = $p3.WaitForExit(120000)
if (-not $exited3) { try { $p3.Kill() } catch {}; Write-Host "gen5 TIMEOUT"; exit 1 }
if (-not (Test-Path "$dir\nova_compiler.ll")) { Write-Host "gen5 FAILED"; exit 1 }
Copy-Item "$dir\nova_compiler.ll" "$dir\gen6.ll" -Force

$h5 = (Get-FileHash "$dir\gen5.ll" -Algorithm SHA256).Hash
$h6 = (Get-FileHash "$dir\gen6.ll" -Algorithm SHA256).Hash
Write-Host "gen5.ll SHA256: $h5"
Write-Host "gen6.ll SHA256: $h6"
if ($h5 -eq $h6) {
    Write-Host "CONVERGED - gen5==gen6"
    & clang "$dir\nova_compiler.ll" $rtSrc -o "$dir\gen6.exe" -O2 @linkFlags 2>"$dir\_bw2_lerr3.txt"
    Copy-Item "$dir\gen6.exe" "$dir\gen4_test.exe" -Force
    Write-Host "Installed gen6 as gen4_test.exe"
} else {
    Write-Host "DIVERGED - gen5 != gen6"
    exit 1
}
Write-Host "BOOTSTRAP DONE"
