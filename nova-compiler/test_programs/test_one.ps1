param([string]$test)
Set-Location $PSScriptRoot
$t = $test -replace '\.nova$',''

Write-Host "Compiling $t.nova ..."
& .\gen1_final_ipt.exe "$t.nova" 2>&1 | Out-Null
if (!(Test-Path "$t.ll")) { Write-Host "FAIL: no .ll output"; exit 1 }

Write-Host "Linking $t.exe ..."
$proc = Start-Process -FilePath "clang" -ArgumentList "-O2 -o $t.exe $t.ll nova_runtime.c -lws2_32" -WorkingDirectory $PSScriptRoot -RedirectStandardOutput "nul" -RedirectStandardError "${t}_cerr.txt" -PassThru -NoNewWindow
$proc.WaitForExit(30000) | Out-Null

# Copy runtime if needed
if (!(Test-Path "nova_runtime.c")) {
    Copy-Item "output\nova_runtime.c" "nova_runtime.c" -Force
}

$proc = Start-Process -FilePath "clang" -ArgumentList "-O2 -o $t.exe $t.ll nova_runtime.c -lws2_32" -WorkingDirectory $PSScriptRoot -RedirectStandardOutput "nul" -RedirectStandardError "${t}_cerr.txt" -PassThru -NoNewWindow
$proc.WaitForExit(30000) | Out-Null

if (!(Test-Path "$t.exe")) {
    Write-Host "FAIL: link error"
    Get-Content "${t}_cerr.txt" -ErrorAction SilentlyContinue
    exit 1
}

Write-Host "Running $t.exe ..."
$psi = New-Object System.Diagnostics.ProcessStartInfo
$psi.FileName = (Resolve-Path ".\$t.exe").Path
$psi.UseShellExecute = $false
$psi.RedirectStandardOutput = $true
$psi.RedirectStandardError = $true
$psi.CreateNoWindow = $true
$p = [System.Diagnostics.Process]::Start($psi)
$stdout = $p.StandardOutput.ReadToEnd()
$stderr = $p.StandardError.ReadToEnd()
$done = $p.WaitForExit(5000)
if (!$done) { $p.Kill(); Write-Host "TIMEOUT"; exit 1 }
Write-Host "Exit code: $($p.ExitCode)"
Write-Host "--- Output ---"
Write-Host $stdout
if ($stderr) { Write-Host "--- Stderr ---"; Write-Host $stderr }
