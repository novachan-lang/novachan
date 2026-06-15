$dir = $PSScriptRoot
$env:NOVA_NO_CACHE = "1"
$linkFlags = @("-lws2_32","-ladvapi32","-D_CRT_SECURE_NO_WARNINGS","-w")
$rtSrc = "$dir\output\nova_runtime.c"

Remove-Item "$dir\selfhost_test1.ll" -Force -ErrorAction SilentlyContinue
$p = Start-Process -FilePath "$dir\gen4_test.exe" -ArgumentList "selfhost_test1.nova" `
    -NoNewWindow -PassThru -WorkingDirectory $dir `
    -RedirectStandardError "$dir\_st1_err.txt" -RedirectStandardOutput "$dir\_st1_out.txt"
$p.WaitForExit(60000) | Out-Null
& clang "$dir\selfhost_test1.ll" $rtSrc -o "$dir\selfhost_test1.exe" -O2 @linkFlags 2>"$dir\_st1_lerr.txt"
$r = Start-Process -FilePath "$dir\selfhost_test1.exe" -NoNewWindow -PassThru -WorkingDirectory $dir `
    -RedirectStandardError "$dir\_st1_rerr.txt" -RedirectStandardOutput "$dir\_st1_rout.txt"
$r.WaitForExit(15000) | Out-Null
Write-Host "OUTPUT:"
Get-Content "$dir\_st1_rout.txt" -Raw
