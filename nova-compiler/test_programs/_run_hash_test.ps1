Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
Copy-Item "output\nova_runtime.c" "nova_runtime.c" -Force
$cr = Invoke-Timed -FilePath (Resolve-Path ".\gen2_move.exe").Path -Arguments "hash_test.nova" -TimeoutMs 30000
if ($cr.ExitCode -ne 0) { Write-Host "COMPILE FAIL"; exit 1 }
$lr = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o hash_test.exe hash_test.ll nova_runtime.c $NovaLinkFlags" -TimeoutMs 30000
if (!(Test-Path "hash_test.exe")) { Write-Host "LINK FAIL"; exit 1 }
$rr = Invoke-Timed -FilePath (Resolve-Path ".\hash_test.exe").Path -Arguments "" -TimeoutMs 10000
Write-Host "Exit: $($rr.ExitCode)"
if ($rr.StdOut) { Write-Host $rr.StdOut }
# Check IR for the const_int instruction
$hash_line = Select-String -Path "hash_test.ll" -Pattern "const|NTypeScheme|add i64.*0$" | ForEach-Object { $_.Line.Trim() } | Select-Object -First 5
Write-Host "IR: $hash_line"
Remove-Item "hash_test.nova","hash_test.ll","hash_test.exe","nova_runtime.c" -Force -ErrorAction SilentlyContinue
