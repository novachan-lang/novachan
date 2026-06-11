$dir = $PSScriptRoot
$env:NOVA_NO_CACHE = "1"
$LINK = "-lws2_32","-ladvapi32","-D_CRT_SECURE_NO_WARNINGS","-w"

function Run-Compiler($exe, $srcArg, $label, $timeoutMs) {
    $ps = New-Object System.Diagnostics.ProcessStartInfo
    $ps.FileName = $exe; $ps.Arguments = $srcArg; $ps.WorkingDirectory = $dir
    $ps.UseShellExecute = $false; $ps.RedirectStandardOutput = $true
    $ps.RedirectStandardError = $true; $ps.CreateNoWindow = $true
    $pr = [System.Diagnostics.Process]::new(); $pr.StartInfo = $ps
    $t0 = Get-Date
    $pr.Start() | Out-Null
    $co = $pr.StandardOutput.ReadToEndAsync()
    $ce = $pr.StandardError.ReadToEndAsync()
    if (-not $pr.WaitForExit($timeoutMs)) {
        $pr.Kill(); $pr.WaitForExit(3000)
        Write-Host "$label TIMEOUT" -ForegroundColor Red; return $false
    }
    [System.Threading.Tasks.Task]::WaitAll($co, $ce)
    $secs = [int]((Get-Date)-$t0).TotalSeconds
    if ($pr.ExitCode -ne 0) { Write-Host "$label FAIL ($secs s): $($ce.Result)" -ForegroundColor Red; return $false }
    Write-Host "$label OK ($secs s)"
    return $true
}

Write-Host "=== CLEAN BOOTSTRAP (corrected .ll convergence check) ==="

# Stage 1: gen3 -> gen4
if (-not (Run-Compiler "$dir\gen3_test.exe" "nova_compiler.nova" "gen3->gen4 compile" 450000)) { exit 1 }
Copy-Item "$dir\nova_compiler.ll" "$dir\nova_compiler_gen4.ll" -Force
& clang -O2 -o "$dir\gen4_new.exe" "$dir\nova_compiler_gen4.ll" "$dir\output\nova_runtime.c" @LINK 2>$null
if (-not (Test-Path "$dir\gen4_new.exe")) { Write-Host "gen4 LINK FAIL"; exit 1 }
$ll4 = (Get-FileHash "$dir\nova_compiler_gen4.ll" -Algorithm SHA256).Hash.Substring(0,20)
Write-Host "gen4.ll sha: $ll4"

# Stage 2: gen4 -> gen5
if (-not (Run-Compiler "$dir\gen4_new.exe" "nova_compiler.nova" "gen4->gen5 compile" 450000)) { exit 1 }
Copy-Item "$dir\nova_compiler.ll" "$dir\nova_compiler_gen5.ll" -Force
& clang -O2 -o "$dir\gen5_new.exe" "$dir\nova_compiler_gen5.ll" "$dir\output\nova_runtime.c" @LINK 2>$null
if (-not (Test-Path "$dir\gen5_new.exe")) { Write-Host "gen5 LINK FAIL"; exit 1 }
$ll5 = (Get-FileHash "$dir\nova_compiler_gen5.ll" -Algorithm SHA256).Hash.Substring(0,20)
Write-Host "gen5.ll sha: $ll5"

# Stage 3: gen5 -> gen6
if (-not (Run-Compiler "$dir\gen5_new.exe" "nova_compiler.nova" "gen5->gen6 compile" 450000)) { exit 1 }
Copy-Item "$dir\nova_compiler.ll" "$dir\nova_compiler_gen6.ll" -Force
$ll6 = (Get-FileHash "$dir\nova_compiler_gen6.ll" -Algorithm SHA256).Hash.Substring(0,20)
Write-Host "gen6.ll sha: $ll6"

Write-Host ""
if ($ll5 -eq $ll6) {
    Write-Host "CONVERGED (.ll): gen5.ll == gen6.ll == $ll5" -ForegroundColor Green
    Copy-Item "$dir\gen5_new.exe" "$dir\gen4_test.exe" -Force
    Write-Host "Installed gen5_new.exe -> gen4_test.exe"
} else {
    Write-Host "NOT CONVERGED (.ll): gen5=$ll5 gen6=$ll6" -ForegroundColor Red
    exit 2
}

# Build runtime cache once for target/regression
Write-Host "`nBuilding _rt_cached.o..."
& clang -O2 -c -o "$dir\_rt_cached.o" "$dir\output\nova_runtime.c" -D_CRT_SECURE_NO_WARNINGS -w 2>$null
if (-not (Test-Path "$dir\_rt_cached.o")) { Write-Host "RT CACHE FAIL"; exit 1 }
Write-Host "OK"
Write-Host "BOOTSTRAP_DONE"
