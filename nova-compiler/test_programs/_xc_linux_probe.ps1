Set-Location $PSScriptRoot
# Step A of the cross-compile probe: does nova_runtime.c compile clean under Linux gcc
# (WSL Ubuntu)? Reveals any Windows-only API leakage not guarded by #ifdef _WIN32.
$wslDir = "/mnt/c/Users/mange/Crypto/AI/New folder/New folder/nova-compiler/test_programs/output"
$cmd = "cd '" + $wslDir + "' && gcc -c nova_runtime.c -o /tmp/nrt_linux.o 2>/tmp/nrt_err.txt; echo EXIT=`$?; echo '--- first 40 diagnostic lines ---'; head -40 /tmp/nrt_err.txt; echo '--- error/warning counts ---'; grep -c 'error:' /tmp/nrt_err.txt; echo 'errors_above'; grep -c 'warning:' /tmp/nrt_err.txt; echo 'warnings_above'"
Write-Host "Running gcc -c nova_runtime.c in WSL Ubuntu..."
$out = & wsl -d Ubuntu -e bash -lc $cmd 2>&1 | Out-String
Write-Host $out
