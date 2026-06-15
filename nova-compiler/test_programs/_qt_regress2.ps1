$ErrorActionPreference = "Continue"
$dir = $PSScriptRoot
$env:NOVA_NO_CACHE = "1"
$linkFlags = @("-lws2_32","-ladvapi32","-D_CRT_SECURE_NO_WARNINGS","-w")
$rtSrc = "$dir\output\nova_runtime.c"

$pass = 0
$fail = 0
$total = 0
$failures = @()

foreach ($f in (Get-ChildItem -Path $dir -Filter "selfhost_test*.nova" | Sort-Object Name)) {
    $total++
    $bn = $f.BaseName
    Remove-Item "$dir\$bn.ll" -Force -ErrorAction SilentlyContinue
    $p = Start-Process -FilePath "$dir\gen4_test.exe" -ArgumentList $f.Name `
        -NoNewWindow -PassThru -WorkingDirectory $dir `
        -RedirectStandardError "$dir\_reg_e.txt" -RedirectStandardOutput "$dir\_reg_o.txt"
    $ok = $p.WaitForExit(60000)
    if (-not $ok) { $p.Kill(); $fail++; $failures += "TIMEOUT-COMPILE $($f.Name)"; continue }
    if (-not (Test-Path "$dir\$bn.ll")) { $fail++; $failures += "COMPILE-FAIL $($f.Name)"; continue }
    & clang "$dir\$bn.ll" $rtSrc -o "$dir\$bn.exe" -O2 @linkFlags 2>"$dir\_reg_le.txt"
    if ($LASTEXITCODE -ne 0) { $fail++; $failures += "LINK-FAIL $($f.Name)"; continue }
    $r = Start-Process -FilePath "$dir\$bn.exe" -NoNewWindow -PassThru -WorkingDirectory $dir `
        -RedirectStandardError "$dir\_reg_re.txt" -RedirectStandardOutput "$dir\_reg_ro.txt"
    $rok = $r.WaitForExit(15000)
    if (-not $rok) { $r.Kill(); $fail++; $failures += "TIMEOUT-RUN $($f.Name)"; continue }
    $err = ""
    if (Test-Path "$dir\_reg_re.txt") { $err = (Get-Content "$dir\_reg_re.txt" -Raw).Trim() }
    if ($err -match "Assertion failed" -or $err -match "segfault" -or $err -match "RUNTIME ERROR") {
        $fail++
        $failures += "RUNTIME $($f.Name): $err"
    } else {
        $pass++
    }
}

Write-Host "`n=== SELFHOST REGRESSION: $pass PASS / $fail FAIL / $total TOTAL ==="
if ($failures.Count -gt 0) {
    Write-Host "Failures:"
    foreach ($fmsg in $failures) { Write-Host "  $fmsg" }
}
