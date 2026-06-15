$dir = $PSScriptRoot
$env:NOVA_NO_CACHE = "1"
$compiler = "$dir\gen4_test.exe"

$failures = @("hello_world","sieve","list_ops")
foreach ($t in $failures) {
    Write-Host "=== $t ==="
    $ps = New-Object System.Diagnostics.ProcessStartInfo
    $ps.FileName = $compiler; $ps.Arguments = "$t.nova"; $ps.WorkingDirectory = $dir
    $ps.UseShellExecute = $false; $ps.RedirectStandardOutput = $true; $ps.RedirectStandardError = $true; $ps.CreateNoWindow = $true
    $pr = [System.Diagnostics.Process]::new(); $pr.StartInfo = $ps
    $pr.Start() | Out-Null
    $out = $pr.StandardOutput.ReadToEnd()
    $err = $pr.StandardError.ReadToEnd()
    if (-not $pr.WaitForExit(60000)) { $pr.Kill(); Write-Host "TIMEOUT" }
    Write-Host "EXIT: $($pr.ExitCode)"
    if ($out.Length -gt 0) {
        $lines = $out -split "`n"
        $tail = $lines | Select-Object -Last 20
        Write-Host "STDOUT (last 20 lines):"
        foreach ($l in $tail) { Write-Host $l }
    }
    if ($err.Length -gt 0) {
        Write-Host "STDERR:"
        Write-Host $err.Substring(0, [Math]::Min(500, $err.Length))
    }
    Write-Host ""
}
