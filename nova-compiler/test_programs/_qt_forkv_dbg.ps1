$dir = $PSScriptRoot
$env:NOVA_NO_CACHE = "1"
$linkFlags = @("-lws2_32","-ladvapi32","-D_CRT_SECURE_NO_WARNINGS","-w")
$rtSrc = "$dir\output\nova_runtime.c"

Write-Host "=== Compile _for_kv_test ==="
Remove-Item "$dir\_for_kv_test.ll" -Force -ErrorAction SilentlyContinue
$psi = New-Object System.Diagnostics.ProcessStartInfo
$psi.FileName = "$dir\gen4_test.exe"
$psi.Arguments = "_for_kv_test.nova"
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
Write-Host "EXIT: $($proc.ExitCode)"
if ($stdout) { Write-Host "STDOUT: $stdout" }
if ($stderr) { Write-Host "STDERR: $stderr" }
Write-Host "LL EXISTS: $(Test-Path "$dir\_for_kv_test.ll")"

if (Test-Path "$dir\_for_kv_test.ll") {
    Write-Host ""
    Write-Host "=== Link _for_kv_test ==="
    & clang "$dir\_for_kv_test.ll" $rtSrc -o "$dir\_for_kv_test.exe" -O2 @linkFlags 2>&1
    Write-Host "LINK EXIT: $LASTEXITCODE"

    if ($LASTEXITCODE -eq 0) {
        Write-Host ""
        Write-Host "=== Run _for_kv_test ==="
        $psi2 = New-Object System.Diagnostics.ProcessStartInfo
        $psi2.FileName = "$dir\_for_kv_test.exe"
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
        Write-Host "EXIT: $($r.ExitCode)"
        Write-Host $rout
        if ($rerr) { Write-Host "STDERR: $rerr" }
    }
}

Write-Host ""
Write-Host "=== Compile for_index_test ==="
Remove-Item "$dir\for_index_test.ll" -Force -ErrorAction SilentlyContinue
$psi3 = New-Object System.Diagnostics.ProcessStartInfo
$psi3.FileName = "$dir\gen4_test.exe"
$psi3.Arguments = "for_index_test.nova"
$psi3.WorkingDirectory = $dir
$psi3.UseShellExecute = $false
$psi3.RedirectStandardOutput = $true
$psi3.RedirectStandardError = $true
$psi3.CreateNoWindow = $true
$proc3 = New-Object System.Diagnostics.Process
$proc3.StartInfo = $psi3
$proc3.Start() | Out-Null
$out3 = $proc3.StandardOutput.ReadToEnd()
$err3 = $proc3.StandardError.ReadToEnd()
$proc3.WaitForExit(60000) | Out-Null
Write-Host "EXIT: $($proc3.ExitCode)"
if ($out3) { Write-Host "STDOUT: $out3" }
if ($err3) { Write-Host "STDERR: $err3" }
Write-Host "LL EXISTS: $(Test-Path "$dir\for_index_test.ll")"

if (Test-Path "$dir\for_index_test.ll") {
    Write-Host ""
    Write-Host "=== Link for_index_test ==="
    & clang "$dir\for_index_test.ll" $rtSrc -o "$dir\for_index_test.exe" -O2 @linkFlags 2>&1
    Write-Host "LINK EXIT: $LASTEXITCODE"

    if ($LASTEXITCODE -eq 0) {
        Write-Host ""
        Write-Host "=== Run for_index_test ==="
        $psi4 = New-Object System.Diagnostics.ProcessStartInfo
        $psi4.FileName = "$dir\for_index_test.exe"
        $psi4.WorkingDirectory = $dir
        $psi4.UseShellExecute = $false
        $psi4.RedirectStandardOutput = $true
        $psi4.RedirectStandardError = $true
        $psi4.CreateNoWindow = $true
        $r4 = New-Object System.Diagnostics.Process
        $r4.StartInfo = $psi4
        $r4.Start() | Out-Null
        $rout4 = $r4.StandardOutput.ReadToEnd()
        $rerr4 = $r4.StandardError.ReadToEnd()
        $r4.WaitForExit(15000) | Out-Null
        Write-Host "EXIT: $($r4.ExitCode)"
        Write-Host $rout4
        if ($rerr4) { Write-Host "STDERR: $rerr4" }
    }
}
