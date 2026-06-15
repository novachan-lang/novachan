$dir = $PSScriptRoot
$env:NOVA_NO_CACHE = "1"
$LINK = "-lws2_32","-ladvapi32","-D_CRT_SECURE_NO_WARNINGS","-w"
$compiler = "$dir\gen4_test.exe"

function Compile-Run($name, $expectRun) {
    $ps = New-Object System.Diagnostics.ProcessStartInfo
    $ps.FileName = $compiler; $ps.Arguments = "$name.nova"; $ps.WorkingDirectory = $dir
    $ps.UseShellExecute = $false; $ps.RedirectStandardOutput = $true
    $ps.RedirectStandardError = $true; $ps.CreateNoWindow = $true
    $pr = [System.Diagnostics.Process]::new(); $pr.StartInfo = $ps
    $pr.Start() | Out-Null
    $co = $pr.StandardOutput.ReadToEndAsync(); $ce = $pr.StandardError.ReadToEndAsync()
    if (-not $pr.WaitForExit(60000)) { $pr.Kill(); $pr.WaitForExit(3000); Write-Host "$name : COMPILE TIMEOUT" -ForegroundColor Red; return }
    [System.Threading.Tasks.Task]::WaitAll($co, $ce)
    if ($pr.ExitCode -ne 0) { Write-Host "$name : COMPILE FAIL $($ce.Result)" -ForegroundColor Red; return }
    & clang -O2 -o "$dir\$name.exe" "$dir\$name.ll" "$dir\_rt_cached.o" @LINK 2>$null
    if (-not (Test-Path "$dir\$name.exe")) { Write-Host "$name : LINK FAIL" -ForegroundColor Red; return }
    if (-not $expectRun) { Write-Host "$name : COMPILED"; return }
    $ps2 = New-Object System.Diagnostics.ProcessStartInfo
    $ps2.FileName = "$dir\$name.exe"; $ps2.WorkingDirectory = $dir
    $ps2.UseShellExecute = $false; $ps2.RedirectStandardOutput = $true
    $ps2.RedirectStandardError = $true; $ps2.CreateNoWindow = $true
    $pr2 = [System.Diagnostics.Process]::new(); $pr2.StartInfo = $ps2
    $pr2.Start() | Out-Null
    $so = $pr2.StandardOutput.ReadToEndAsync(); $se = $pr2.StandardError.ReadToEndAsync()
    if (-not $pr2.WaitForExit(15000)) { $pr2.Kill(); $pr2.WaitForExit(3000); Write-Host "$name : RUN TIMEOUT" -ForegroundColor Red; return }
    [System.Threading.Tasks.Task]::WaitAll($so, $se)
    if ($pr2.ExitCode -eq 0) { Write-Host "$name : PASS" -ForegroundColor Green }
    else { Write-Host "$name : FAIL exit=$($pr2.ExitCode) $($se.Result)" -ForegroundColor Red }
}

Write-Host "=== PERF CHECK: sqrt-loop must have NO box_float in loop body ==="
$ps = New-Object System.Diagnostics.ProcessStartInfo
$ps.FileName = $compiler; $ps.Arguments = "_sqrt_loop_probe.nova"; $ps.WorkingDirectory = $dir
$ps.UseShellExecute = $false; $ps.RedirectStandardOutput = $true
$ps.RedirectStandardError = $true; $ps.CreateNoWindow = $true
$pr = [System.Diagnostics.Process]::new(); $pr.StartInfo = $ps
$pr.Start() | Out-Null
$co = $pr.StandardOutput.ReadToEndAsync(); $ce = $pr.StandardError.ReadToEndAsync()
if (-not $pr.WaitForExit(60000)) { $pr.Kill(); $pr.WaitForExit(3000); Write-Host "sqrt probe COMPILE TIMEOUT" }
[System.Threading.Tasks.Task]::WaitAll($co, $ce)
$boxCount = (Select-String -Path "$dir\_sqrt_loop_probe.ll" -Pattern 'nova_rt_box_float').Count
$sqrtCount = (Select-String -Path "$dir\_sqrt_loop_probe.ll" -Pattern 'nova_rt_sqrt').Count
Write-Host "sqrt-loop: box_float calls=$boxCount  sqrt calls=$sqrtCount"
if ($boxCount -le 1) { Write-Host "PERF OK: no per-iteration boxing (box_float decl only)" -ForegroundColor Green }
else { Write-Host "PERF REGRESSION: $boxCount box_float calls (boxing in loop)" -ForegroundColor Red }

Write-Host "`n=== FLOAT PRINT/STR/CMP SANITY ==="
Compile-Run "_float_print_test" $true

Write-Host "`n=== TARGETS ==="
foreach ($t in @("mathfx","simdx","embedx","geox")) { Compile-Run $t $true }
