$dir = $PSScriptRoot
$env:NOVA_NO_CACHE = "1"
$compiler = "$dir\gen4_test.exe"
$rtSrc = "$dir\output\nova_runtime.c"
$linkFlags = @("-lws2_32","-ladvapi32","-D_CRT_SECURE_NO_WARNINGS","-w")

$pass = 0; $fail = 0; $skip = 0; $total = 0
$failures = @()

$files = Get-ChildItem -Path $dir -Filter "selfhost_test*.nova" | Sort-Object Name
foreach ($f in $files) {
    $total++
    $bn = $f.BaseName
    Remove-Item "$dir\$bn.ll" -Force -ErrorAction SilentlyContinue
    $psi = New-Object System.Diagnostics.ProcessStartInfo
    $psi.FileName = $compiler
    $psi.Arguments = $f.Name
    $psi.WorkingDirectory = $dir
    $psi.UseShellExecute = $false
    $psi.RedirectStandardOutput = $true
    $psi.RedirectStandardError = $true
    $psi.CreateNoWindow = $true
    $p = New-Object System.Diagnostics.Process
    $p.StartInfo = $psi
    $p.Start() | Out-Null
    $p.StandardOutput.ReadToEnd() | Out-Null
    $p.StandardError.ReadToEnd() | Out-Null
    $exited = $p.WaitForExit(60000)
    if (-not $exited) { try { $p.Kill() } catch {}; $fail++; $failures += "TIMEOUT-COMPILE $bn"; continue }
    if (-not (Test-Path "$dir\$bn.ll")) { $fail++; $failures += "COMPILE $bn"; continue }
    & clang "$dir\$bn.ll" $rtSrc -o "$dir\$bn.exe" -O2 @linkFlags 2>"$dir\_rec_le.txt"
    if ($LASTEXITCODE -ne 0) { $fail++; $failures += "LINK $bn"; continue }
    $psi2 = New-Object System.Diagnostics.ProcessStartInfo
    $psi2.FileName = "$dir\$bn.exe"
    $psi2.WorkingDirectory = $dir
    $psi2.UseShellExecute = $false
    $psi2.RedirectStandardOutput = $true
    $psi2.RedirectStandardError = $true
    $psi2.CreateNoWindow = $true
    $p2 = New-Object System.Diagnostics.Process
    $p2.StartInfo = $psi2
    $p2.Start() | Out-Null
    $p2.StandardOutput.ReadToEnd() | Out-Null
    $p2.StandardError.ReadToEnd() | Out-Null
    $exited2 = $p2.WaitForExit(15000)
    if (-not $exited2) { try { $p2.Kill() } catch {}; $fail++; $failures += "TIMEOUT-RUN $bn"; continue }
    if ($p2.ExitCode -ne 0) { $fail++; $failures += "FAIL $bn (exit=$($p2.ExitCode))"; continue }
    $pass++
}

Write-Host "=== REGRESSION: $pass PASS / $fail FAIL / $total TOTAL ==="
if ($failures.Count -gt 0) {
    Write-Host "Failures:"
    foreach ($fmsg in $failures) { Write-Host "  $fmsg" }
}
