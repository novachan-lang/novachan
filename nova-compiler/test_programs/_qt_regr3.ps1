$dir = $PSScriptRoot
$env:NOVA_NO_CACHE = "1"
$linkFlags = @("-lws2_32","-ladvapi32","-D_CRT_SECURE_NO_WARNINGS","-w")
$compiler = "$dir\gen4_test.exe"
$pass = 0; $fail = 0; $skip = 0; $total = 0
$failures = @()

$skipList = @("nova_compiler","import_multi_test","selfhost_tinyB",
    "gen4_test","gen4","nova","gen3_test","gen2_move",
    "_proc_util","_test_nova","__lsp_check__")

$rtObj = "$dir\_rt_cached.o"
if (-not (Test-Path $rtObj)) {
    & clang -c "$dir\output\nova_runtime.c" -o $rtObj -O2 -D_CRT_SECURE_NO_WARNINGS -w
}

function Run-WithTimeout($exePath, $cmdArgs, $workDir, $timeoutMs) {
    $psi = New-Object System.Diagnostics.ProcessStartInfo
    $psi.FileName = $exePath
    if ($cmdArgs) { $psi.Arguments = $cmdArgs }
    $psi.WorkingDirectory = $workDir
    $psi.UseShellExecute = $false
    $psi.RedirectStandardOutput = $true
    $psi.RedirectStandardError = $true
    $psi.CreateNoWindow = $true
    $proc = New-Object System.Diagnostics.Process
    $proc.StartInfo = $psi
    $proc.Start() | Out-Null
    $stdout = $proc.StandardOutput.ReadToEnd()
    $stderr = $proc.StandardError.ReadToEnd()
    $exited = $proc.WaitForExit($timeoutMs)
    if (-not $exited) {
        try { $proc.Kill() } catch {}
        return @{ ExitCode = -999; Stdout = $stdout; Stderr = $stderr; TimedOut = $true }
    }
    return @{ ExitCode = $proc.ExitCode; Stdout = $stdout; Stderr = $stderr; TimedOut = $false }
}

Get-ChildItem "$dir\*.nova" | ForEach-Object {
    $base = $_.BaseName
    if ($base -in $skipList) { $skip++; return }
    if ($base.StartsWith("_b_") -or $base.StartsWith("_qt_") -or $base.StartsWith("_bc_") -or $base.StartsWith("_bf_") -or $base.StartsWith("_lm_") -or $base.StartsWith("_sm_") -or $base.StartsWith("_vfy_")) { $skip++; return }
    $total++

    $ll = "$dir\$base.ll"
    Remove-Item $ll -Force -ErrorAction SilentlyContinue

    $cr = Run-WithTimeout $compiler $("$base.nova") $dir 60000
    if ($cr.TimedOut) { $fail++; $failures += "$base (TIMEOUT)"; return }
    if (-not (Test-Path $ll)) { $fail++; $failures += "$base (COMPILE)"; return }

    $exe = "$dir\$base.exe"
    & clang $ll $rtObj -o $exe -O2 @linkFlags 2>"$dir\_reg_lerr_$base.txt"
    if ($LASTEXITCODE -ne 0) { $fail++; $failures += "$base (LINK)"; return }

    $rr = Run-WithTimeout $exe $null $dir 30000
    if ($rr.TimedOut) { $fail++; $failures += "$base (RUN TIMEOUT)"; return }
    if ($rr.ExitCode -ne 0) { $fail++; $failures += "$base (exit=$($rr.ExitCode))"; return }

    $pass++
}

Write-Host ""
Write-Host "Full suite: $pass PASS, $fail FAIL, $skip SKIP (of $($total + $skip) total)"
if ($failures.Count -gt 0) {
    Write-Host ""
    Write-Host "Failures:"
    $failures | ForEach-Object { Write-Host "  $_" }
}
