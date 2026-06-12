. "$PSScriptRoot\_proc_util.ps1"
$dir = $PSScriptRoot
$env:NOVA_NO_CACHE = "1"
foreach ($t in @("_p1","_p2")) {
    $c = Invoke-Timed -FilePath "$dir\gen4_test.exe" -Arguments "$t.nova" -TimeoutMs 60000
    if ($c.ExitCode -ne 0) { Write-Host "$t COMPILE-FAIL $($c.StdErr)"; continue }
    $l = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o `"$dir\$t.exe`" `"$dir\$t.ll`" `"$dir\output\nova_runtime.c`" $NovaLinkFlags -D_CRT_SECURE_NO_WARNINGS -w" -TimeoutMs 150000
    if ($l.ExitCode -ne 0) { Write-Host "$t LINK-FAIL $($l.StdErr)"; continue }
    foreach ($nc in @("1","2","4")) {
        if ($nc -eq "1") { Remove-Item Env:\NOVA_CARRIERS -ErrorAction SilentlyContinue } else { $env:NOVA_CARRIERS = $nc; $env:NOVA_CARRIER_STATS = "1" }
        # run each config 3x to catch intermittent hangs
        for ($rep = 1; $rep -le 3; $rep++) {
            $r = Invoke-Timed -FilePath "$dir\$t.exe" -TimeoutMs 20000
            $o = ($r.StdOut -replace "\s+"," ").Trim()
            $car = (($r.StdErr -split "`n") | Where-Object { $_ -match "carriers" }) -join " "
            Write-Host "$t N=$nc rep=$rep exit=$($r.ExitCode) to=$($r.TimedOut) | $o | $($car.Trim())"
        }
        Remove-Item Env:\NOVA_CARRIERS -ErrorAction SilentlyContinue
        Remove-Item Env:\NOVA_CARRIER_STATS -ErrorAction SilentlyContinue
    }
}
Write-Host "DONE"
