$dir = $PSScriptRoot
$env:NOVA_NO_CACHE = "1"

Write-Host "=== Verify gen4_test.exe reproduces the fixpoint .ll from CURRENT source ==="
$expected = "af105e9048efd64a6796"

# Back up current nova_compiler.ll so we can compare
Copy-Item "$dir\nova_compiler.ll" "$dir\_pre_verify.ll" -Force

$t0 = Get-Date
$ps = New-Object System.Diagnostics.ProcessStartInfo
$ps.FileName = "$dir\gen4_test.exe"
$ps.Arguments = "nova_compiler.nova"
$ps.WorkingDirectory = $dir
$ps.UseShellExecute = $false
$ps.RedirectStandardOutput = $true
$ps.RedirectStandardError = $true
$ps.CreateNoWindow = $true
$pr = [System.Diagnostics.Process]::new()
$pr.StartInfo = $ps
$pr.Start() | Out-Null
$co = $pr.StandardOutput.ReadToEndAsync()
$ce = $pr.StandardError.ReadToEndAsync()
if (-not $pr.WaitForExit(450000)) {
    $pr.Kill(); $pr.WaitForExit(3000)
    Write-Host "gen4 TIMEOUT"; exit 1
}
[System.Threading.Tasks.Task]::WaitAll($co, $ce)
$t1 = Get-Date
Write-Host "compile: $([int]($t1-$t0).TotalSeconds)s exit=$($pr.ExitCode)"
if ($pr.ExitCode -ne 0) { Write-Host "FAIL: $($ce.Result)"; exit 1 }

$sha = (Get-FileHash "$dir\nova_compiler.ll" -Algorithm SHA256).Hash.Substring(0,20)
Write-Host "output .ll sha: $sha"
Write-Host "expected:      $expected"
if ($sha -eq $expected) {
    Write-Host "MATCH — gen4_test.exe is a verified fixpoint for CURRENT source" -ForegroundColor Green
} else {
    Write-Host "MISMATCH — gen4_test.exe output differs; full re-bootstrap needed" -ForegroundColor Yellow
}
