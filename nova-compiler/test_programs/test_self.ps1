Set-Location $PSScriptRoot
Copy-Item "output\nova_runtime.c" "nova_runtime.c" -Force

Write-Host "Building gen2 with implicit self support..."
if (Test-Path "nova_compiler.ll") { Remove-Item "nova_compiler.ll" -Force }
$p = Start-Process -FilePath ".\gen1_final_ipt.exe" -ArgumentList "nova_compiler.nova" -WorkingDirectory $PSScriptRoot -RedirectStandardOutput "gen2_cout.txt" -RedirectStandardError "gen2_cerr.txt" -PassThru -NoNewWindow
$done = $p.WaitForExit(60000)
if (!$done) { try { $p.Kill() } catch {}; Write-Host "TIMEOUT: gen2 compile"; exit 1 }
if (!(Test-Path "nova_compiler.ll")) { Write-Host "FAIL: gen2 compile"; Get-Content "gen2_cerr.txt" -ErrorAction SilentlyContinue; exit 1 }
Move-Item "nova_compiler.ll" "gen2_self.ll" -Force

$p2 = Start-Process -FilePath "clang" -ArgumentList "-O2 -o gen2_self.exe gen2_self.ll nova_runtime.c -lws2_32" -WorkingDirectory $PSScriptRoot -RedirectStandardOutput "nul" -RedirectStandardError "gen2_link_err.txt" -PassThru -NoNewWindow
$done2 = $p2.WaitForExit(120000)
if (!$done2) { try { $p2.Kill() } catch {}; Write-Host "TIMEOUT: gen2 link"; exit 1 }
if (!(Test-Path "gen2_self.exe")) { Write-Host "FAIL: gen2 link"; Get-Content "gen2_link_err.txt"; exit 1 }
Write-Host "gen2_self.exe: $((Get-Item 'gen2_self.exe').Length) bytes"

foreach ($t in @("method_test", "struct_methods_test")) {
    Write-Host ""
    Write-Host "=== $t ==="
    if (Test-Path "$t.ll") { Remove-Item "$t.ll" -Force }
    if (Test-Path "$t.exe") { Remove-Item "$t.exe" -Force }
    $p3 = Start-Process -FilePath ".\gen2_self.exe" -ArgumentList "$t.nova" -WorkingDirectory $PSScriptRoot -RedirectStandardOutput "${t}_cout.txt" -RedirectStandardError "${t}_cerr.txt" -PassThru -NoNewWindow
    $p3.WaitForExit(15000) | Out-Null
    if (!(Test-Path "$t.ll")) {
        Write-Host "FAIL(compile): $t"
        Get-Content "${t}_cerr.txt" -ErrorAction SilentlyContinue
        continue
    }
    Write-Host "Compiled OK"
    $p4 = Start-Process -FilePath "clang" -ArgumentList "-O2 -o $t.exe $t.ll nova_runtime.c -lws2_32" -WorkingDirectory $PSScriptRoot -RedirectStandardOutput "nul" -RedirectStandardError "${t}_link_err.txt" -PassThru -NoNewWindow
    $p4.WaitForExit(30000) | Out-Null
    if (!(Test-Path "$t.exe")) { Write-Host "FAIL(link): $t"; Get-Content "${t}_link_err.txt"; continue }

    $psi = New-Object System.Diagnostics.ProcessStartInfo
    $psi.FileName = (Resolve-Path ".\$t.exe").Path
    $psi.UseShellExecute = $false
    $psi.RedirectStandardOutput = $true
    $psi.RedirectStandardError = $true
    $psi.CreateNoWindow = $true
    $proc = [System.Diagnostics.Process]::Start($psi)
    $stdout = $proc.StandardOutput.ReadToEndAsync()
    $stderr = $proc.StandardError.ReadToEndAsync()
    $exited = $proc.WaitForExit(5000)
    if (!$exited) { try { $proc.Kill() } catch {}; Write-Host "TIMEOUT"; continue }
    [System.Threading.Tasks.Task]::WaitAll($stdout, $stderr)
    Write-Host "Exit: $($proc.ExitCode)"
    Write-Host "Output:"
    Write-Host $stdout.Result
    if ($stderr.Result.Length -gt 0) { Write-Host "STDERR: $($stderr.Result)" }
}

Remove-Item "nova_runtime.c" -Force -ErrorAction SilentlyContinue
