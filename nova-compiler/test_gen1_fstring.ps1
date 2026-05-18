Set-Location "c:\Users\mange\Crypto\AI\New folder\New folder\nova-compiler"
$p = Start-Process -FilePath ".\gen1.exe" -ArgumentList "test_programs/test_fstring_subscript.nova" -NoNewWindow -PassThru -Wait -RedirectStandardOutput gen1_fs_out.txt -RedirectStandardError gen1_fs_err.txt
Write-Output ("Exit: " + $p.ExitCode)
if (Test-Path gen1_fs_out.txt) { Get-Content gen1_fs_out.txt }
if (Test-Path gen1_fs_err.txt) {
    $err = Get-Content gen1_fs_err.txt
    if ($err.Length -gt 0) { Write-Output "STDERR:"; $err }
}
