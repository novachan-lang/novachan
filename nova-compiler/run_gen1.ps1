Set-Location "c:\Users\mange\Crypto\AI\New folder\New folder\nova-compiler"
Write-Output "Running gen1 to compile nova_compiler.nova..."
$p = Start-Process -FilePath ".\gen1.exe" -ArgumentList "test_programs/nova_compiler.nova" -NoNewWindow -PassThru -RedirectStandardOutput gen1_out.txt -RedirectStandardError gen1_err.txt
$done = $p.WaitForExit(120000)
if (-not $done) {
    $p.Kill()
    Write-Output "TIMEOUT after 120s"
    exit 1
}
Write-Output ("gen1 exit code: " + $p.ExitCode)
if (Test-Path gen1_out.txt) {
    Write-Output "--- stdout ---"
    Get-Content gen1_out.txt | Select-Object -Last 10
}
if (Test-Path gen1_err.txt) {
    $err = Get-Content gen1_err.txt
    if ($err.Length -gt 0) {
        Write-Output "--- stderr ---"
        $err | Select-Object -Last 20
    }
}
