$dir = $PSScriptRoot
$env:NOVA_NO_CACHE = "1"
$compiler = "$dir\gen4_test.exe"

$tests = @("test_dict_only", "test_spawn_call", "test_spawn_multi", "diag_fstring4", "test_return_context", "alloc_bench")
foreach ($t in $tests) {
    $ps = New-Object System.Diagnostics.ProcessStartInfo
    $ps.FileName = $compiler; $ps.Arguments = "$t.nova"; $ps.WorkingDirectory = $dir
    $ps.UseShellExecute = $false; $ps.RedirectStandardOutput = $true; $ps.RedirectStandardError = $true; $ps.CreateNoWindow = $true
    $pr = [System.Diagnostics.Process]::new(); $pr.StartInfo = $ps
    $pr.Start() | Out-Null
    $cout = $pr.StandardOutput.ReadToEnd()
    $cerr = $pr.StandardError.ReadToEnd()
    if (-not $pr.WaitForExit(60000)) { $pr.Kill(); Write-Host "$t : TIMEOUT"; continue }
    if ($pr.ExitCode -ne 0) {
        Write-Host "$t : FAIL exit=$($pr.ExitCode)"
        if ($cerr.Length -gt 0) { Write-Host "  $($cerr.Substring(0, [Math]::Min(300, $cerr.Length)))" }
        if ($cout.Length -gt 0) {
            $last = ($cout -split "`n") | Select-Object -Last 5
            Write-Host "  STDOUT tail:"
            foreach ($l in $last) { Write-Host "    $l" }
        }
    } else {
        Write-Host "$t : OK (exit=0)"
    }
}
