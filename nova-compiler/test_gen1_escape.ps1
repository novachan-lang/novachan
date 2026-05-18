Set-Location "c:\Users\mange\Crypto\AI\New folder\New folder\nova-compiler"
$p = Start-Process -FilePath ".\gen1.exe" -ArgumentList "test_programs/test_pkg_get3.nova" -NoNewWindow -PassThru -Wait -RedirectStandardOutput gen1_esc_out.txt -RedirectStandardError gen1_esc_err.txt
Write-Output ("Exit: " + $p.ExitCode)
if (Test-Path gen1_esc_out.txt) { Get-Content gen1_esc_out.txt }
if (Test-Path gen1_esc_err.txt) {
    $err = Get-Content gen1_esc_err.txt
    if ($err.Length -gt 0) { Write-Output "STDERR:"; $err }
}
