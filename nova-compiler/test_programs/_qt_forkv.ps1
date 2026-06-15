$dir = $PSScriptRoot
$env:NOVA_NO_CACHE = "1"
$linkFlags = @("-lws2_32","-ladvapi32","-D_CRT_SECURE_NO_WARNINGS","-w")
$rtSrc = "$dir\output\nova_runtime.c"

function Compile-And-Run($name) {
    Remove-Item "$dir\$name.ll" -Force -ErrorAction SilentlyContinue
    $psi = New-Object System.Diagnostics.ProcessStartInfo
    $psi.FileName = "$dir\gen4_test.exe"
    $psi.Arguments = "$name.nova"
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
    if (-not $exited) { try { $proc.Kill() } catch {}; Write-Host "[$name] COMPILE TIMEOUT"; return $false }
    if ($stderr) { Write-Host "[$name] COMPILE STDERR: $stderr" }
    if (-not (Test-Path "$dir\$name.ll")) { Write-Host "[$name] COMPILE FAILED"; return $false }

    & clang "$dir\$name.ll" $rtSrc -o "$dir\$name.exe" -O2 @linkFlags 2>"$dir\_fkv_lerr.txt"
    if ($LASTEXITCODE -ne 0) { Write-Host "[$name] LINK FAILED"; Get-Content "$dir\_fkv_lerr.txt"; return $false }

    $psi2 = New-Object System.Diagnostics.ProcessStartInfo
    $psi2.FileName = "$dir\$name.exe"
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
    Write-Host "[$name] EXIT: $($r.ExitCode)"
    Write-Host $rout
    if ($rerr) { Write-Host "[$name] STDERR: $rerr" }
    return ($r.ExitCode -eq 0)
}

Write-Host "=== Testing _for_kv_test ==="
$r1 = Compile-And-Run "_for_kv_test"

Write-Host ""
Write-Host "=== Testing for_index_test (regression) ==="
$r2 = Compile-And-Run "for_index_test"

Write-Host ""
if ($r1 -and $r2) { Write-Host "ALL PASS" } else { Write-Host "SOME FAILED" }
