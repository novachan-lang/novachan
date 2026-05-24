Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
$compiler = (Resolve-Path ".\gen2_move.exe").Path
Copy-Item "output\nova_runtime.c" "nova_runtime.c" -Force

$cr = Invoke-Timed -FilePath $compiler -Arguments "arena_test.nova" -TimeoutMs 30000
if ($cr.ExitCode -ne 0) { Write-Host "COMPILE FAIL: $($cr.StdOut)"; exit 1 }

# Check the IR to see how set_arena_mode is called
Write-Host "=== arena_mode calls in .ll ==="
Select-String -Path "arena_test.ll" -Pattern "arena_mode" | ForEach-Object { Write-Host $_.Line.Trim() }

$tl = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o arena_test.exe arena_test.ll nova_runtime.c $NovaLinkFlags" -TimeoutMs 30000
if (!(Test-Path "arena_test.exe")) { Write-Host "LINK FAIL"; exit 1 }

$tr = Invoke-Timed -FilePath (Resolve-Path ".\arena_test.exe").Path -Arguments "" -TimeoutMs 15000
Write-Host "`nExit: $($tr.ExitCode)"
if ($tr.StdOut) { Write-Host $tr.StdOut }
if ($tr.StdErr) { Write-Host "STDERR: $($tr.StdErr)" }

Remove-Item "arena_test.exe","arena_test.ll","nova_runtime.c" -Force -ErrorAction SilentlyContinue
