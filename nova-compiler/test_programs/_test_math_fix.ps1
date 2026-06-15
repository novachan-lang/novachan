$dir = $PSScriptRoot
$env:NOVA_NO_CACHE = "1"

function Invoke-Timed($exe, $argList, $label, $timeout, $wd) {
    $ps = New-Object System.Diagnostics.ProcessStartInfo
    $ps.FileName = $exe; $ps.Arguments = $argList; $ps.WorkingDirectory = $wd
    $ps.UseShellExecute = $false; $ps.RedirectStandardOutput = $true; $ps.RedirectStandardError = $true; $ps.CreateNoWindow = $true
    $pr = [System.Diagnostics.Process]::new(); $pr.StartInfo = $ps
    $pr.Start() | Out-Null
    $stdout = $pr.StandardOutput.ReadToEndAsync()
    $stderr = $pr.StandardError.ReadToEndAsync()
    if (-not $pr.WaitForExit($timeout)) {
        $pr.Kill(); $pr.WaitForExit(5000)
        Write-Host "$label TIMEOUT"
        return @{ exit = -1; out = ""; err = "TIMEOUT" }
    }
    [System.Threading.Tasks.Task]::WaitAll($stdout, $stderr)
    return @{ exit = $pr.ExitCode; out = $stdout.Result; err = $stderr.Result }
}

$tests = @("mathfx", "simdx", "embedx", "geox", "float_test", "floatmath_test", "math_test", "float_list_ops_test")
foreach ($t in $tests) {
    if (-not (Test-Path "$dir\$t.nova")) { Write-Host "$t : MISSING"; continue }
    $r = Invoke-Timed "$dir\gen4_test.exe" "$t.nova" "compile_$t" 60000 $dir
    if ($r.exit -ne 0) { Write-Host "$t : COMPILE FAIL"; continue }
    & clang -O2 -o "$dir\$t.exe" "$dir\$t.ll" "$dir\_rt_cached.o" -lws2_32 -ladvapi32 -D_CRT_SECURE_NO_WARNINGS -w 2>$null
    if (-not (Test-Path "$dir\$t.exe")) { Write-Host "$t : LINK FAIL"; continue }
    $rt = Invoke-Timed "$dir\$t.exe" "" "${t}_run" 15000 $dir
    if ($rt.exit -eq 0) { Write-Host "$t : PASS" } else {
        Write-Host "$t : FAIL exit=$($rt.exit)"
        if ($rt.err.Length -gt 0) { Write-Host "  ERR: $($rt.err.Substring(0, [Math]::Min(300, $rt.err.Length)))" }
        if ($rt.out.Length -gt 0) {
            $last = ($rt.out -split "`n") | Select-Object -Last 5
            foreach ($l in $last) { Write-Host "  OUT: $l" }
        }
    }
}
