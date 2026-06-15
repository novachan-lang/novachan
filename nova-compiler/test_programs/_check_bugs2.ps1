$dir = $PSScriptRoot
$env:NOVA_NO_CACHE = "1"
$compiler = "$dir\gen4_test_bak.exe"
if (-not (Test-Path $compiler)) { $compiler = "$dir\gen4_test.exe" }

$tests = @("test_dict_only", "test_spawn_call", "alloc_bench")
foreach ($t in $tests) {
    Write-Host "=== $t ==="
    $ps = New-Object System.Diagnostics.ProcessStartInfo
    $ps.FileName = $compiler; $ps.Arguments = "$t.nova"; $ps.WorkingDirectory = $dir
    $ps.UseShellExecute = $false; $ps.RedirectStandardOutput = $true; $ps.RedirectStandardError = $true; $ps.CreateNoWindow = $true
    $pr = [System.Diagnostics.Process]::new(); $pr.StartInfo = $ps
    $pr.Start() | Out-Null
    $stdout = $pr.StandardOutput.ReadToEndAsync()
    $stderr = $pr.StandardError.ReadToEndAsync()
    if (-not $pr.WaitForExit(60000)) { $pr.Kill(); $pr.WaitForExit(5000); Write-Host "TIMEOUT"; continue }
    [System.Threading.Tasks.Task]::WaitAll($stdout, $stderr)
    Write-Host $stdout.Result
    if ($stderr.Result.Length -gt 0) { Write-Host "STDERR: $($stderr.Result)" }
    Write-Host ""
}
