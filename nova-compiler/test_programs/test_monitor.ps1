Set-Location $PSScriptRoot
Copy-Item "output\nova_runtime.c" "nova_runtime.c" -Force

Write-Host "Building gen2 with spawn-assign fix..."
if (Test-Path "nova_compiler.ll") { Remove-Item "nova_compiler.ll" -Force }
$p = Start-Process -FilePath ".\gen1_final_ipt.exe" -ArgumentList "nova_compiler.nova" -WorkingDirectory $PSScriptRoot -RedirectStandardOutput "nul" -RedirectStandardError "spawn_err.txt" -PassThru -NoNewWindow
$p.WaitForExit(60000) | Out-Null
if (!(Test-Path "nova_compiler.ll")) { Write-Host "FAIL: source compile"; Get-Content "spawn_err.txt"; exit 1 }
Move-Item "nova_compiler.ll" "gen2_spawn.ll" -Force

$p2 = Start-Process -FilePath "clang" -ArgumentList "-O2 -o gen2_spawn.exe gen2_spawn.ll nova_runtime.c -lws2_32" -WorkingDirectory $PSScriptRoot -RedirectStandardOutput "nul" -RedirectStandardError "spawn_cerr.txt" -PassThru -NoNewWindow
$p2.WaitForExit(120000) | Out-Null
if (!(Test-Path "gen2_spawn.exe")) { Write-Host "FAIL: link gen2"; Get-Content "spawn_cerr.txt"; exit 1 }
Write-Host "gen2_spawn.exe: $((Get-Item 'gen2_spawn.exe').Length) bytes"

foreach ($t in @("monitor_test", "monitor_multi_test")) {
    Write-Host ""
    Write-Host "=== $t ==="
    if (Test-Path "$t.ll") { Remove-Item "$t.ll" -Force }
    $p3 = Start-Process -FilePath ".\gen2_spawn.exe" -ArgumentList "$t.nova" -WorkingDirectory $PSScriptRoot -RedirectStandardOutput "nul" -RedirectStandardError "${t}_err.txt" -PassThru -NoNewWindow
    $p3.WaitForExit(15000) | Out-Null
    if (!(Test-Path "$t.ll")) {
        Write-Host "FAIL(compile): "; Get-Content "${t}_err.txt" -ErrorAction SilentlyContinue
        continue
    }
    Write-Host "Compiled OK: $((Get-Item "$t.ll").Length) bytes"
    $p4 = Start-Process -FilePath "clang" -ArgumentList "-O2 -o $t.exe $t.ll nova_runtime.c -lws2_32" -WorkingDirectory $PSScriptRoot -RedirectStandardOutput "nul" -RedirectStandardError "${t}_link_err.txt" -PassThru -NoNewWindow
    $p4.WaitForExit(30000) | Out-Null
    if (!(Test-Path "$t.exe")) { Write-Host "FAIL(link)"; Get-Content "${t}_link_err.txt"; continue }

    $psi = New-Object System.Diagnostics.ProcessStartInfo
    $psi.FileName = (Resolve-Path ".\$t.exe").Path
    $psi.UseShellExecute = $false
    $psi.RedirectStandardOutput = $true
    $psi.RedirectStandardError = $true
    $psi.CreateNoWindow = $true
    $proc = [System.Diagnostics.Process]::Start($psi)
    $stdout = $proc.StandardOutput.ReadToEnd()
    $stderr = $proc.StandardError.ReadToEnd()
    $done = $proc.WaitForExit(5000)
    if (!$done) { $proc.Kill(); Write-Host "TIMEOUT"; continue }
    Write-Host "Exit: $($proc.ExitCode)"
    Write-Host "Output: $stdout"
}

Remove-Item "nova_runtime.c" -Force -ErrorAction SilentlyContinue
