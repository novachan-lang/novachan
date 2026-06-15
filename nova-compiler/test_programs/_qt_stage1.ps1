$dir = $PSScriptRoot
$env:NOVA_NO_CACHE = "1"
$gen3 = "$dir\gen3_test.exe"
$rtSrc = "$dir\output\nova_runtime.c"
$linkFlags = @("-lws2_32","-ladvapi32","-D_CRT_SECURE_NO_WARNINGS","-w")

function Invoke-Gen($exe, $label) {
    Remove-Item "$dir\nova_compiler.ll" -Force -ErrorAction SilentlyContinue
    $psi = New-Object System.Diagnostics.ProcessStartInfo
    $psi.FileName = $exe; $psi.Arguments = "nova_compiler.nova"; $psi.WorkingDirectory = $dir
    $psi.UseShellExecute = $false; $psi.RedirectStandardOutput = $true; $psi.RedirectStandardError = $true; $psi.CreateNoWindow = $true
    $p = [System.Diagnostics.Process]::new(); $p.StartInfo = $psi; $p.Start() | Out-Null
    $t = [System.Diagnostics.Stopwatch]::StartNew()
    $p.StandardOutput.ReadToEnd() | Out-Null; $ce = $p.StandardError.ReadToEnd()
    if (-not $p.WaitForExit(450000)) { try { $p.Kill() } catch {}; Write-Host "$label TIMEOUT"; exit 1 }
    $t.Stop(); Write-Host "$label $([int]$t.Elapsed.TotalSeconds)s exit=$($p.ExitCode)"
    if (-not (Test-Path "$dir\nova_compiler.ll")) { Write-Host "$label FAILED: $ce"; exit 1 }
}
function Run-One($compiler, $test, $rt) {
    Remove-Item "$dir\$test.ll" -Force -ErrorAction SilentlyContinue
    $ps = New-Object System.Diagnostics.ProcessStartInfo
    $ps.FileName = $compiler; $ps.Arguments = "$test.nova"; $ps.WorkingDirectory = $dir
    $ps.UseShellExecute = $false; $ps.RedirectStandardOutput = $true; $ps.RedirectStandardError = $true; $ps.CreateNoWindow = $true
    $pr = [System.Diagnostics.Process]::new(); $pr.StartInfo = $ps; $pr.Start() | Out-Null
    $co = $pr.StandardOutput.ReadToEnd(); $ce = $pr.StandardError.ReadToEnd()
    if (-not $pr.WaitForExit(60000)) { try { $pr.Kill() } catch {}; return "COMPILE_TIMEOUT" }
    if (-not (Test-Path "$dir\$test.ll")) { return "COMPILE_FAIL: $($ce.Trim())" }
    & clang "$dir\$test.ll" $rtSrc -o "$dir\$test.exe" -O2 @linkFlags 2>$null
    if ($LASTEXITCODE -ne 0) { return "LINK_FAIL" }
    $ps2 = New-Object System.Diagnostics.ProcessStartInfo
    $ps2.FileName = "$dir\$test.exe"; $ps2.WorkingDirectory = $dir
    $ps2.UseShellExecute = $false; $ps2.RedirectStandardOutput = $true; $ps2.RedirectStandardError = $true; $ps2.CreateNoWindow = $true
    $pr2 = [System.Diagnostics.Process]::new(); $pr2.StartInfo = $ps2; $pr2.Start() | Out-Null
    $o2 = $pr2.StandardOutput.ReadToEnd(); $pr2.StandardError.ReadToEnd() | Out-Null
    if (-not $pr2.WaitForExit(40000)) { try { $pr2.Kill() } catch {}; return "RUN_TIMEOUT" }
    if ($pr2.ExitCode -ne 0) { return "FAIL exit=$($pr2.ExitCode)" }
    return "PASS"
}

Write-Host "=== gen3 -> gen4 ==="; Invoke-Gen $gen3 "gen3"
& clang "$dir\nova_compiler.ll" $rtSrc -o "$dir\gen4_new.exe" -O2 @linkFlags 2>"$dir\_s1_lerr.txt"
if ($LASTEXITCODE -ne 0) { Write-Host "gen4 LINK FAILED"; Get-Content "$dir\_s1_lerr.txt" | Select-Object -First 20; exit 1 }
Write-Host "=== gen4 -> gen5 ==="; Invoke-Gen "$dir\gen4_new.exe" "gen4"
Copy-Item "$dir\nova_compiler.ll" "$dir\_gen5_s1.ll" -Force
$sha5 = (Get-FileHash "$dir\_gen5_s1.ll" -Algorithm SHA256).Hash; Write-Host "gen5 SHA: $sha5"
& clang "$dir\_gen5_s1.ll" $rtSrc -o "$dir\gen5_s1.exe" -O2 @linkFlags 2>$null
Write-Host "=== gen5 -> gen6 ==="; Invoke-Gen "$dir\gen5_s1.exe" "gen5"
$sha6 = (Get-FileHash "$dir\nova_compiler.ll" -Algorithm SHA256).Hash; Write-Host "gen6 SHA: $sha6"
if ($sha5 -ne $sha6) { Write-Host "DIVERGED"; exit 1 }
Write-Host "CONVERGED"; Copy-Item "$dir\gen4_new.exe" "$dir\gen4_test.exe" -Force; Write-Host "Installed gen4_test.exe"
$compiler = "$dir\gen4_test.exe"

Write-Host ""
Write-Host "struct_perf_test : $(Run-One $compiler 'struct_perf_test' $rtSrc)"

# Stage 1 win check: _dot_untyped must now emit native fmul (not nova_rt_mul)
Remove-Item "$dir\_dot_untyped.ll" -Force -ErrorAction SilentlyContinue
$psd = New-Object System.Diagnostics.ProcessStartInfo
$psd.FileName = $compiler; $psd.Arguments = "_dot_untyped.nova"; $psd.WorkingDirectory = $dir
$psd.UseShellExecute = $false; $psd.RedirectStandardOutput = $true; $psd.RedirectStandardError = $true; $psd.CreateNoWindow = $true
$prd = [System.Diagnostics.Process]::new(); $prd.StartInfo = $psd; $prd.Start() | Out-Null
$prd.StandardOutput.ReadToEnd() | Out-Null; $prd.StandardError.ReadToEnd() | Out-Null
$prd.WaitForExit(60000) | Out-Null
if (Test-Path "$dir\_dot_untyped.ll") {
    $body = Get-Content "$dir\_dot_untyped.ll" -Raw
    $hasFmul = $body -match 'fmul double'
    $hasDyn  = $body -match 'nova_rt_mul'
    Write-Host "STAGE1: _dot_untyped fmul=$hasFmul nova_rt_mul=$hasDyn"
} else { Write-Host "STAGE1: _dot_untyped COMPILE FAIL" }

Write-Host ""
Write-Host "=== bench (GATE 4/5 proxy) ==="
foreach ($b in @("num_bench","fib_bench")) {
    $r = Run-One $compiler $b $rtSrc
    Write-Host "$b : $r"
}

Write-Host ""
Write-Host "=== REGRESSION (selfhost) ==="
$pass = 0; $fail = 0
foreach ($f in (Get-ChildItem "$dir\selfhost_test*.nova" | Sort-Object Name)) {
    $r = Run-One $compiler $f.BaseName $rtSrc
    if ($r -eq "PASS") { $pass++ } else { Write-Host "$($f.BaseName): $r"; $fail++ }
}
Write-Host "Regression: $pass PASS, $fail fail"
if ($fail -gt 0) { Write-Host "GATE FAIL"; exit 1 }
Write-Host "ALL GREEN"
