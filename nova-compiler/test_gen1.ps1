Set-Location "c:\Users\mange\Crypto\AI\New folder\New folder\nova-compiler"
Write-Output "Running gen1_o2.exe to compile nova_compiler.nova..."
$p = Start-Process -FilePath ".\gen1_o2.exe" -ArgumentList "test_programs/nova_compiler.nova" -NoNewWindow -PassThru -RedirectStandardOutput gen1_out.txt -RedirectStandardError gen1_err.txt
$done = $p.WaitForExit(300000)
if (-not $done) {
    $p.Kill()
    Write-Output "TIMEOUT after 300s"
    exit 1
}
Write-Output ("Exit: " + $p.ExitCode)
if (Test-Path gen1_out.txt) { Get-Content gen1_out.txt | Select-Object -Last 5 }
if (Test-Path gen1_err.txt) {
    $err = Get-Content gen1_err.txt
    if ($err.Length -gt 0) { Write-Output "STDERR:"; $err | Select-Object -Last 10 }
}
if (Test-Path "test_programs/nova_compiler.ll") {
    $lines = (Get-Content "test_programs/nova_compiler.ll").Length
    Write-Output "Output: $lines lines"
    Copy-Item "test_programs/nova_compiler.ll" gen2.ll -Force
    # Check for bad labels
    $bad = Select-String -Pattern 'label %%r' -Path gen2.ll
    if ($bad) {
        Write-Output "BAD LABELS found: $($bad.Count)"
        $bad | Select-Object -First 5
    } else {
        Write-Output "No bad labels!"
    }
}
