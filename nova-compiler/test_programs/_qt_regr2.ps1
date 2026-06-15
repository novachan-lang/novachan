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

Get-ChildItem "$dir\*.nova" | ForEach-Object {
    $base = $_.BaseName
    if ($base -in $skipList) { $skip++; return }
    if ($base.StartsWith("_b_") -or $base.StartsWith("_qt_") -or $base.StartsWith("_bc_") -or $base.StartsWith("_bf_") -or $base.StartsWith("_lm_") -or $base.StartsWith("_sm_") -or $base.StartsWith("_vfy_")) { $skip++; return }
    $total++

    $ll = "$dir\$base.ll"
    Remove-Item $ll -Force -ErrorAction SilentlyContinue
    $p = Start-Process -FilePath $compiler -ArgumentList "$base.nova" `
        -NoNewWindow -PassThru -WorkingDirectory $dir `
        -RedirectStandardError "$dir\_reg_err.txt" -RedirectStandardOutput "$dir\_reg_out.txt"
    $ok = $p.WaitForExit(60000)
    if (-not $ok) { $p.Kill(); $fail++; $failures += "$base (TIMEOUT)"; return }
    if (-not (Test-Path $ll)) { $fail++; $failures += "$base (COMPILE)"; return }

    $exe = "$dir\$base.exe"
    & clang $ll $rtObj -o $exe -O2 @linkFlags 2>"$dir\_reg_lerr.txt"
    if ($LASTEXITCODE -ne 0) { $fail++; $failures += "$base (LINK)"; return }

    $r = Start-Process -FilePath $exe -NoNewWindow -PassThru -WorkingDirectory $dir `
        -RedirectStandardOutput "$dir\_reg_rout.txt" -RedirectStandardError "$dir\_reg_rerr.txt"
    $waited = $r.WaitForExit(30000)
    if (-not $waited) { $r.Kill(); $fail++; $failures += "$base (RUN TIMEOUT)"; return }
    $r.WaitForExit()
    $ec = $r.ExitCode
    if ($null -eq $ec -or $ec -ne 0) { $fail++; $failures += "$base (exit=$ec)"; return }

    $pass++
}

Write-Host ""
Write-Host "Full suite: $pass PASS, $fail FAIL, $skip SKIP (of $($total + $skip) total)"
if ($failures.Count -gt 0) {
    Write-Host ""
    Write-Host "Failures:"
    $failures | ForEach-Object { Write-Host "  $_" }
}
