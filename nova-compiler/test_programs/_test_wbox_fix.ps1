$dir = $PSScriptRoot
$env:NOVA_NO_CACHE = "1"
$compiler = "$dir\gen4_test.exe"

$tests = @(
    @{ name="simdx"; file="simdx.nova"; expect="vec_norm" },
    @{ name="geox"; file="geox.nova"; expect="NY-LA" },
    @{ name="mathfx"; file="mathfx.nova"; expect="sqrt" },
    @{ name="embedx"; file="embedx.nova"; expect="embed" }
)

foreach ($t in $tests) {
    Write-Host "`n=== $($t.name) ===" -ForegroundColor Cyan
    $ps = New-Object System.Diagnostics.ProcessStartInfo
    $ps.FileName = $compiler; $ps.Arguments = $t.file; $ps.WorkingDirectory = $dir
    $ps.UseShellExecute = $false; $ps.RedirectStandardOutput = $true
    $ps.RedirectStandardError = $true; $ps.CreateNoWindow = $true
    $pr = [System.Diagnostics.Process]::new(); $pr.StartInfo = $ps
    $pr.Start() | Out-Null
    $co = $pr.StandardOutput.ReadToEnd(); $ce = $pr.StandardError.ReadToEnd()
    if (-not $pr.WaitForExit(60000)) { $pr.Kill(); Write-Host "COMPILE TIMEOUT"; continue }
    if ($pr.ExitCode -ne 0) { Write-Host "COMPILE FAIL: stdout=[$co] err=[$ce]"; continue }

    $llFile = "$dir\$($t.name).ll"
    if (-not (Test-Path $llFile)) { Write-Host "NO .ll FILE at $llFile"; continue }

    & clang -O2 -o "$dir\$($t.name).exe" $llFile "$dir\_rt_cached.o" -lws2_32 -ladvapi32 -D_CRT_SECURE_NO_WARNINGS -w 2>$null
    if (-not (Test-Path "$dir\$($t.name).exe")) { Write-Host "LINK FAIL"; continue }

    $ps2 = New-Object System.Diagnostics.ProcessStartInfo
    $ps2.FileName = "$dir\$($t.name).exe"; $ps2.WorkingDirectory = $dir
    $ps2.UseShellExecute = $false; $ps2.RedirectStandardOutput = $true
    $ps2.RedirectStandardError = $true; $ps2.CreateNoWindow = $true
    $pr2 = [System.Diagnostics.Process]::new(); $pr2.StartInfo = $ps2
    $pr2.Start() | Out-Null
    $sout = $pr2.StandardOutput.ReadToEndAsync()
    $serr = $pr2.StandardError.ReadToEndAsync()
    if (-not $pr2.WaitForExit(15000)) {
        $pr2.Kill(); $pr2.WaitForExit(3000)
        [System.Threading.Tasks.Task]::WaitAll($sout, $serr)
        Write-Host "RUN TIMEOUT"
        Write-Host "OUT: $($sout.Result)"
        continue
    }
    [System.Threading.Tasks.Task]::WaitAll($sout, $serr)
    $output = $sout.Result
    $lines = $output -split "`n" | ForEach-Object { $_.Trim() } | Where-Object { $_ }
    $last8 = ($lines | Select-Object -Last 8) -join "`n"
    Write-Host $last8
    if ($pr2.ExitCode -eq 0) {
        Write-Host "$($t.name) : PASS (exit=0)" -ForegroundColor Green
    } else {
        Write-Host "$($t.name) : FAIL (exit=$($pr2.ExitCode))" -ForegroundColor Red
    }
}
