Set-Location $PSScriptRoot
Copy-Item "output\nova_runtime.c" "nova_runtime.c" -Force

$tests = @("mini_struct_test", "struct_test", "method_test", "defaults_test", "dict_test")

foreach ($t in $tests) {
    if (Test-Path "$t.ll") { Remove-Item "$t.ll" -Force }
    $psi = New-Object System.Diagnostics.ProcessStartInfo
    $psi.FileName = (Resolve-Path ".\gen2_trait.exe").Path
    $psi.Arguments = "$t.nova"
    $psi.UseShellExecute = $false
    $psi.RedirectStandardOutput = $true
    $psi.RedirectStandardError = $true
    $psi.CreateNoWindow = $true
    $proc = [System.Diagnostics.Process]::Start($psi)
    $stdout = $proc.StandardOutput.ReadToEndAsync()
    $stderr = $proc.StandardError.ReadToEndAsync()
    $done = $proc.WaitForExit(10000)
    if (!$done) { try { $proc.Kill() } catch {}; Write-Host "TIMEOUT $t"; continue }
    [System.Threading.Tasks.Task]::WaitAll($stdout, $stderr)
    $ll = Test-Path "$t.ll"
    Write-Host "$t : exit=$($proc.ExitCode) ll=$ll"
    if ($stderr.Result.Length -gt 0) { Write-Host "  ERR: $($stderr.Result.Substring(0, [Math]::Min(200, $stderr.Result.Length)))" }
}

Remove-Item "nova_runtime.c" -Force -ErrorAction SilentlyContinue
