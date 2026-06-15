$dir = $PSScriptRoot
$env:NOVA_NO_CACHE = "1"
# Use the backup since gen4_test.exe is being rebuilt by bootstrap
$compiler = "$dir\gen4_test_bak.exe"
if (-not (Test-Path $compiler)) { $compiler = "$dir\gen4_test.exe" }

$tests = @("test_dict_only", "test_spawn_call", "test_spawn_multi", "alloc_bench", "multi_error_test")
foreach ($t in $tests) {
    if (-not (Test-Path "$dir\$t.nova")) { Write-Host "$t : MISSING"; continue }
    $ps = New-Object System.Diagnostics.ProcessStartInfo
    $ps.FileName = $compiler; $ps.Arguments = "$t.nova"; $ps.WorkingDirectory = $dir
    $ps.UseShellExecute = $false; $ps.RedirectStandardOutput = $true; $ps.RedirectStandardError = $true; $ps.CreateNoWindow = $true
    $pr = [System.Diagnostics.Process]::new(); $pr.StartInfo = $ps
    $pr.Start() | Out-Null
    $stdout = $pr.StandardOutput.ReadToEndAsync()
    $stderr = $pr.StandardError.ReadToEndAsync()
    if (-not $pr.WaitForExit(60000)) {
        $pr.Kill(); $pr.WaitForExit(5000)
        Write-Host "$t : TIMEOUT"; continue
    }
    [System.Threading.Tasks.Task]::WaitAll($stdout, $stderr)
    $co = $stdout.Result
    $ce = $stderr.Result
    if ($pr.ExitCode -ne 0) {
        Write-Host "$t : FAIL exit=$($pr.ExitCode)"
        if ($ce.Length -gt 0) {
            $clines = $ce -split "`n"
            foreach ($l in $clines[0..([Math]::Min(9, $clines.Count-1))]) { Write-Host "  ERR: $l" }
        }
        if ($co.Length -gt 0) {
            $last = ($co -split "`n") | Select-Object -Last 5
            foreach ($l in $last) { Write-Host "  OUT: $l" }
        }
    } else {
        # Try link+run
        & clang -O2 -o "$dir\$t.exe" "$dir\$t.ll" "$dir\_rt_cached.o" -lws2_32 -ladvapi32 -D_CRT_SECURE_NO_WARNINGS -w 2>$null
        if (-not (Test-Path "$dir\$t.exe")) { Write-Host "$t : LINK FAIL"; continue }
        $ps2 = New-Object System.Diagnostics.ProcessStartInfo
        $ps2.FileName = "$dir\$t.exe"; $ps2.WorkingDirectory = $dir
        $ps2.UseShellExecute = $false; $ps2.RedirectStandardOutput = $true; $ps2.RedirectStandardError = $true; $ps2.CreateNoWindow = $true
        $pr2 = [System.Diagnostics.Process]::new(); $pr2.StartInfo = $ps2
        $pr2.Start() | Out-Null
        $ro = $pr2.StandardOutput.ReadToEndAsync()
        $re = $pr2.StandardError.ReadToEndAsync()
        if (-not $pr2.WaitForExit(10000)) { $pr2.Kill(); Write-Host "$t : RUN TIMEOUT"; continue }
        [System.Threading.Tasks.Task]::WaitAll($ro, $re)
        if ($pr2.ExitCode -eq 0) { Write-Host "$t : PASS" } else {
            Write-Host "$t : RUN FAIL exit=$($pr2.ExitCode)"
            $rlines = $re.Result -split "`n"
            foreach ($l in $rlines[0..([Math]::Min(4, $rlines.Count-1))]) { Write-Host "  ERR: $l" }
        }
    }
}
