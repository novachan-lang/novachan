Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"

$compiler = (Resolve-Path ".\gen2_move.exe").Path
Copy-Item "output\nova_runtime.c" "nova_runtime.c" -Force

$tests = @("arena_test", "semver_test")
foreach ($t in $tests) {
    Write-Host "=== $t ==="
    $tc = Invoke-Timed -FilePath $compiler -Arguments "$t.nova" -TimeoutMs 30000
    if ($tc.ExitCode -ne 0) { Write-Host "COMPILE FAIL: $($tc.StdOut)"; continue }
    $tl = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o $t.exe $t.ll nova_runtime.c $NovaLinkFlags" -TimeoutMs 30000
    if (!(Test-Path "$t.exe")) { Write-Host "LINK FAIL"; continue }
    $tr = Invoke-Timed -FilePath (Resolve-Path ".\$t.exe").Path -Arguments "" -TimeoutMs 15000
    Write-Host "Exit: $($tr.ExitCode)"
    if ($tr.StdOut) { Write-Host $tr.StdOut }
    if ($tr.StdErr) { Write-Host "STDERR: $($tr.StdErr)" }
    Remove-Item "$t.exe","$t.ll" -Force -ErrorAction SilentlyContinue
}
Remove-Item "nova_runtime.c" -Force -ErrorAction SilentlyContinue
