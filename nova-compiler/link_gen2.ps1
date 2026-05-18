Set-Location "c:\Users\mange\Crypto\AI\New folder\New folder\nova-compiler"
$rtPath = "bench/nova_runtime.c"
$linkProc = Start-Process -FilePath "clang" -ArgumentList "-O2 -w gen2.ll $rtPath -o gen2.exe -lws2_32 -lwinhttp" -NoNewWindow -PassThru -Wait -RedirectStandardOutput link2_out.txt -RedirectStandardError link2_err.txt
Write-Output ("clang exit: " + $linkProc.ExitCode)
if ($linkProc.ExitCode -ne 0) {
    if (Test-Path link2_err.txt) {
        $err = Get-Content link2_err.txt
        $undef = $err | Select-String "undefined symbol:" | ForEach-Object { $_.Line -replace '.*undefined symbol: ', '' }
        $unique = $undef | Sort-Object -Unique
        Write-Output "Undefined symbols:"
        $unique
    }
}
