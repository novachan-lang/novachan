$dir = $PSScriptRoot
$env:NOVA_NO_CACHE = "1"
$rtSrc = "$dir\output\nova_runtime.c"
$linkFlags = @("-lws2_32","-ladvapi32","-D_CRT_SECURE_NO_WARNINGS","-w")
$compiler = "$dir\gen4_test.exe"

$tests = @(
    "dict_float_test","dynfloat_box_test","float_list_ops_test","float_test",
    "floatcast_test","floatmath_test","intfloat_mixed_test","json_decode_float_test",
    "json_float_test","jsonfloat_rt_test","math_test","nested_float_test",
    "tensor_boxed_float_test","test_str_float","_vm_float_broad","value_model_golden",
    "math3d_test","stats_test","physics2d_test"
)

$pass = 0; $fail = 0; $skip = 0
foreach ($test in $tests) {
    if (-not (Test-Path "$dir\$test.nova")) { $skip++; continue }
    Remove-Item "$dir\$test.ll" -Force -ErrorAction SilentlyContinue
    $ps = New-Object System.Diagnostics.ProcessStartInfo
    $ps.FileName = $compiler; $ps.Arguments = "$test.nova"; $ps.WorkingDirectory = $dir
    $ps.UseShellExecute = $false; $ps.RedirectStandardOutput = $true; $ps.RedirectStandardError = $true; $ps.CreateNoWindow = $true
    $pr = [System.Diagnostics.Process]::new(); $pr.StartInfo = $ps; $pr.Start() | Out-Null
    $co = $pr.StandardOutput.ReadToEnd(); $ce = $pr.StandardError.ReadToEnd()
    $ex = $pr.WaitForExit(60000)
    if (-not $ex) { try { $pr.Kill() } catch {}; Write-Host "$test COMPILE_TIMEOUT"; $fail++; continue }
    if (-not (Test-Path "$dir\$test.ll")) { Write-Host "$test COMPILE_FAIL: $($ce.Trim())"; $fail++; continue }
    & clang "$dir\$test.ll" $rtSrc -o "$dir\$test.exe" -O2 @linkFlags 2>$null
    if ($LASTEXITCODE -ne 0) { Write-Host "$test LINK_FAIL"; $fail++; continue }
    $ps2 = New-Object System.Diagnostics.ProcessStartInfo
    $ps2.FileName = "$dir\$test.exe"; $ps2.WorkingDirectory = $dir
    $ps2.UseShellExecute = $false; $ps2.RedirectStandardOutput = $true; $ps2.RedirectStandardError = $true; $ps2.CreateNoWindow = $true
    $pr2 = [System.Diagnostics.Process]::new(); $pr2.StartInfo = $ps2; $pr2.Start() | Out-Null
    $o2 = $pr2.StandardOutput.ReadToEnd(); $e2 = $pr2.StandardError.ReadToEnd()
    $ex2 = $pr2.WaitForExit(30000)
    if (-not $ex2) { try { $pr2.Kill() } catch {}; Write-Host "$test RUN_TIMEOUT"; $fail++; continue }
    if ($pr2.ExitCode -ne 0) {
        Write-Host "$test FAIL (exit=$($pr2.ExitCode)) $($e2.Trim())"
        $fail++
    } else {
        Write-Host "$test PASS"
        $pass++
    }
}
Write-Host ""
Write-Host "Float-tests: $pass PASS, $fail FAIL, $skip skip"
if ($fail -gt 0) { exit 1 }
