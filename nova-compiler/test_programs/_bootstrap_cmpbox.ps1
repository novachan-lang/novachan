$dir = $PSScriptRoot
$env:NOVA_NO_CACHE = "1"

Write-Host "=== BOOTSTRAP: cmp-wbox fix ==="
Write-Host "Step 1: gen3 -> gen4 (compiling nova_compiler.nova)"

$t0 = Get-Date
$ps = New-Object System.Diagnostics.ProcessStartInfo
$ps.FileName = "$dir\gen3_test.exe"
$ps.Arguments = "nova_compiler.nova"
$ps.WorkingDirectory = $dir
$ps.UseShellExecute = $false
$ps.RedirectStandardOutput = $true
$ps.RedirectStandardError = $true
$ps.CreateNoWindow = $true
$pr = [System.Diagnostics.Process]::new()
$pr.StartInfo = $ps
$pr.Start() | Out-Null
$co = $pr.StandardOutput.ReadToEnd()
$ce = $pr.StandardError.ReadToEnd()
if (-not $pr.WaitForExit(450000)) {
    $pr.Kill(); Write-Host "gen3 TIMEOUT"; exit 1
}
if ($pr.ExitCode -ne 0) { Write-Host "gen3 FAIL: $ce"; exit 1 }
$t1 = Get-Date
Write-Host "gen3 compile: $([int]($t1-$t0).TotalSeconds)s"

Write-Host "Linking gen4..."
& clang -O2 -o "$dir\gen4_test.exe" "$dir\nova_compiler.ll" "$dir\output\nova_runtime.c" -lws2_32 -ladvapi32 -D_CRT_SECURE_NO_WARNINGS -w 2>$null
if (-not (Test-Path "$dir\gen4_test.exe")) { Write-Host "gen4 LINK FAIL"; exit 1 }
$sha4 = (Get-FileHash "$dir\gen4_test.exe" -Algorithm SHA256).Hash.Substring(0,16)
Write-Host "gen4 SHA: $sha4"

Write-Host "`nStep 2: gen4 -> gen5 (self-compile)"
$t2 = Get-Date
$ps2 = New-Object System.Diagnostics.ProcessStartInfo
$ps2.FileName = "$dir\gen4_test.exe"
$ps2.Arguments = "nova_compiler.nova"
$ps2.WorkingDirectory = $dir
$ps2.UseShellExecute = $false
$ps2.RedirectStandardOutput = $true
$ps2.RedirectStandardError = $true
$ps2.CreateNoWindow = $true
$pr2 = [System.Diagnostics.Process]::new()
$pr2.StartInfo = $ps2
$pr2.Start() | Out-Null
$co2 = $pr2.StandardOutput.ReadToEnd()
$ce2 = $pr2.StandardError.ReadToEnd()
if (-not $pr2.WaitForExit(450000)) {
    $pr2.Kill(); Write-Host "gen4 TIMEOUT"; exit 1
}
if ($pr2.ExitCode -ne 0) { Write-Host "gen4 FAIL: $ce2"; exit 1 }
$t3 = Get-Date
Write-Host "gen4 compile: $([int]($t3-$t2).TotalSeconds)s"

Copy-Item "$dir\nova_compiler.ll" "$dir\nova_compiler_gen5.ll" -Force
& clang -O2 -o "$dir\gen5_test.exe" "$dir\nova_compiler_gen5.ll" "$dir\output\nova_runtime.c" -lws2_32 -ladvapi32 -D_CRT_SECURE_NO_WARNINGS -w 2>$null
$sha5 = (Get-FileHash "$dir\gen5_test.exe" -Algorithm SHA256).Hash.Substring(0,16)
Write-Host "gen5 SHA: $sha5"

Write-Host "`nStep 3: gen5 -> gen6 (convergence)"
$ps3 = New-Object System.Diagnostics.ProcessStartInfo
$ps3.FileName = "$dir\gen5_test.exe"
$ps3.Arguments = "nova_compiler.nova"
$ps3.WorkingDirectory = $dir
$ps3.UseShellExecute = $false
$ps3.RedirectStandardOutput = $true
$ps3.RedirectStandardError = $true
$ps3.CreateNoWindow = $true
$pr3 = [System.Diagnostics.Process]::new()
$pr3.StartInfo = $ps3
$pr3.Start() | Out-Null
$co3 = $pr3.StandardOutput.ReadToEnd()
$ce3 = $pr3.StandardError.ReadToEnd()
if (-not $pr3.WaitForExit(450000)) {
    $pr3.Kill(); Write-Host "gen5 TIMEOUT"; exit 1
}
if ($pr3.ExitCode -ne 0) { Write-Host "gen5 FAIL: $ce3"; exit 1 }

Copy-Item "$dir\nova_compiler.ll" "$dir\nova_compiler_gen6.ll" -Force
& clang -O2 -o "$dir\gen6_test.exe" "$dir\nova_compiler_gen6.ll" "$dir\output\nova_runtime.c" -lws2_32 -ladvapi32 -D_CRT_SECURE_NO_WARNINGS -w 2>$null
$sha6 = (Get-FileHash "$dir\gen6_test.exe" -Algorithm SHA256).Hash.Substring(0,16)
Write-Host "gen6 SHA: $sha6"

if ($sha5 -eq $sha6) {
    Write-Host "CONVERGED" -ForegroundColor Green
    Copy-Item "$dir\gen5_test.exe" "$dir\gen4_test.exe" -Force
    Write-Host "Installed gen4_test.exe"
} else {
    Write-Host "DIVERGED: gen5=$sha5 gen6=$sha6" -ForegroundColor Red
    exit 1
}

Write-Host "`n=== TARGET TESTS ==="
$targets = @("mathfx", "simdx", "embedx", "geox")
foreach ($t in $targets) {
    $ps4 = New-Object System.Diagnostics.ProcessStartInfo
    $ps4.FileName = "$dir\gen4_test.exe"; $ps4.Arguments = "$t.nova"; $ps4.WorkingDirectory = $dir
    $ps4.UseShellExecute = $false; $ps4.RedirectStandardOutput = $true
    $ps4.RedirectStandardError = $true; $ps4.CreateNoWindow = $true
    $pr4 = [System.Diagnostics.Process]::new(); $pr4.StartInfo = $ps4
    $pr4.Start() | Out-Null
    $co4 = $pr4.StandardOutput.ReadToEnd(); $ce4 = $pr4.StandardError.ReadToEnd()
    if (-not $pr4.WaitForExit(60000)) { $pr4.Kill(); Write-Host "$t : COMPILE TIMEOUT" -ForegroundColor Red; continue }
    if ($pr4.ExitCode -ne 0) { Write-Host "$t : COMPILE FAIL" -ForegroundColor Red; continue }

    & clang -O2 -o "$dir\$t.exe" "$dir\$t.ll" "$dir\_rt_cached.o" -lws2_32 -ladvapi32 -D_CRT_SECURE_NO_WARNINGS -w 2>$null
    if (-not (Test-Path "$dir\$t.exe")) { Write-Host "$t : LINK FAIL" -ForegroundColor Red; continue }

    $ps5 = New-Object System.Diagnostics.ProcessStartInfo
    $ps5.FileName = "$dir\$t.exe"; $ps5.WorkingDirectory = $dir
    $ps5.UseShellExecute = $false; $ps5.RedirectStandardOutput = $true
    $ps5.RedirectStandardError = $true; $ps5.CreateNoWindow = $true
    $pr5 = [System.Diagnostics.Process]::new(); $pr5.StartInfo = $ps5
    $pr5.Start() | Out-Null
    $so5 = $pr5.StandardOutput.ReadToEndAsync()
    $se5 = $pr5.StandardError.ReadToEndAsync()
    if (-not $pr5.WaitForExit(15000)) {
        $pr5.Kill(); $pr5.WaitForExit(3000)
        [System.Threading.Tasks.Task]::WaitAll($so5, $se5)
        Write-Host "$t : RUN TIMEOUT" -ForegroundColor Red; continue
    }
    [System.Threading.Tasks.Task]::WaitAll($so5, $se5)
    if ($pr5.ExitCode -eq 0) {
        Write-Host "$t : PASS" -ForegroundColor Green
    } else {
        $errOut = $se5.Result
        if ($errOut.Length -gt 0) { $errOut = " ($errOut)" }
        Write-Host "$t : FAIL exit=$($pr5.ExitCode)$errOut" -ForegroundColor Red
    }
}

Write-Host "`n=== CORE REGRESSION ==="
$coreDir = "$dir\core_tests"
$pass = 0; $fail = 0; $failList = @()
if (Test-Path $coreDir) {
    $tests = Get-ChildItem "$coreDir\*.nova" | Select-Object -ExpandProperty Name
    foreach ($tf in $tests) {
        $tname = [IO.Path]::GetFileNameWithoutExtension($tf)
        $ps6 = New-Object System.Diagnostics.ProcessStartInfo
        $ps6.FileName = "$dir\gen4_test.exe"; $ps6.Arguments = $tf; $ps6.WorkingDirectory = $coreDir
        $ps6.UseShellExecute = $false; $ps6.RedirectStandardOutput = $true
        $ps6.RedirectStandardError = $true; $ps6.CreateNoWindow = $true
        $pr6 = [System.Diagnostics.Process]::new(); $pr6.StartInfo = $ps6
        $pr6.Start() | Out-Null
        $co6 = $pr6.StandardOutput.ReadToEnd(); $ce6 = $pr6.StandardError.ReadToEnd()
        if (-not $pr6.WaitForExit(30000)) { $pr6.Kill(); $fail++; $failList += $tname; continue }
        if ($pr6.ExitCode -ne 0) { $fail++; $failList += "$tname(compile)"; continue }

        & clang -O2 -o "$coreDir\$tname.exe" "$coreDir\$tname.ll" "$dir\_rt_cached.o" -lws2_32 -ladvapi32 -D_CRT_SECURE_NO_WARNINGS -w 2>$null
        if (-not (Test-Path "$coreDir\$tname.exe")) { $fail++; $failList += "$tname(link)"; continue }

        $ps7 = New-Object System.Diagnostics.ProcessStartInfo
        $ps7.FileName = "$coreDir\$tname.exe"; $ps7.WorkingDirectory = $coreDir
        $ps7.UseShellExecute = $false; $ps7.RedirectStandardOutput = $true
        $ps7.RedirectStandardError = $true; $ps7.CreateNoWindow = $true
        $pr7 = [System.Diagnostics.Process]::new(); $pr7.StartInfo = $ps7
        $pr7.Start() | Out-Null
        $so7 = $pr7.StandardOutput.ReadToEndAsync()
        $se7 = $pr7.StandardError.ReadToEndAsync()
        if (-not $pr7.WaitForExit(15000)) {
            $pr7.Kill(); $pr7.WaitForExit(3000)
            [System.Threading.Tasks.Task]::WaitAll($so7, $se7)
            $fail++; $failList += "$tname(timeout)"; continue
        }
        [System.Threading.Tasks.Task]::WaitAll($so7, $se7)
        if ($pr7.ExitCode -eq 0) { $pass++ } else { $fail++; $failList += "$tname(exit=$($pr7.ExitCode))" }
    }
}
Write-Host "Core: $pass PASS, $fail FAIL"
if ($failList.Count -gt 0) { Write-Host "FAILED: $($failList -join ', ')" -ForegroundColor Red }
