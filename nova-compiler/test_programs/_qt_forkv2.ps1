$dir = $PSScriptRoot
$env:NOVA_NO_CACHE = "1"
$linkFlags = @("-lws2_32","-ladvapi32","-D_CRT_SECURE_NO_WARNINGS","-w")
$rtSrc = "$dir\output\nova_runtime.c"

Write-Host "=== Compile for_index_test (regression with old compiler + new runtime) ==="
Remove-Item "$dir\for_index_test.ll" -Force -ErrorAction SilentlyContinue
$psi = New-Object System.Diagnostics.ProcessStartInfo
$psi.FileName = "$dir\gen4_test.exe"
$psi.Arguments = "for_index_test.nova"
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
Write-Host "COMPILE EXIT: $($proc.ExitCode)"
if ($stderr) { Write-Host "STDERR: $stderr" }

if (Test-Path "$dir\for_index_test.ll") {
    & clang "$dir\for_index_test.ll" $rtSrc -o "$dir\for_index_test.exe" -O2 @linkFlags 2>&1
    Write-Host "LINK EXIT: $LASTEXITCODE"
    if ($LASTEXITCODE -eq 0) {
        $psi2 = New-Object System.Diagnostics.ProcessStartInfo
        $psi2.FileName = "$dir\for_index_test.exe"
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
        Write-Host "RUN EXIT: $($r.ExitCode)"
        Write-Host $rout
        if ($rerr) { Write-Host "STDERR: $rerr" }
    }
} else {
    Write-Host "COMPILE FAILED - no .ll"
}

Write-Host ""
Write-Host "=== Compile nova_compiler.nova (precheck) ==="
Remove-Item "$dir\nova_compiler.ll" -Force -ErrorAction SilentlyContinue
$psi3 = New-Object System.Diagnostics.ProcessStartInfo
$psi3.FileName = "$dir\gen3_test.exe"
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
$exited = $p3.WaitForExit(450000)
if (-not $exited) { try { $p3.Kill() } catch {}; Write-Host "gen3 TIMEOUT"; exit 1 }
Write-Host "gen3 EXIT: $($p3.ExitCode)"
if ($o3) { Write-Host $o3 }
if ($e3) { Write-Host "STDERR: $e3" }
Write-Host "LL EXISTS: $(Test-Path "$dir\nova_compiler.ll")"
