Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
# Usage: dump_ll.ps1 <source.nova> <out.ll> [compiler.exe]
$src = $args[0]
$out = $args[1]
$compiler = ".\gen1_final_ipt.exe"
if ($args.Count -ge 3) { $compiler = ".\" + $args[2] }
Copy-Item $src "_dump_tmp.nova" -Force
$r = Invoke-Timed -FilePath (Resolve-Path $compiler).Path -Arguments "_dump_tmp.nova" -TimeoutMs 60000
if ($r.TimedOut) { Write-Host "COMPILE TIMED OUT (killed)"; Remove-Item "_dump_tmp.nova" -Force -EA SilentlyContinue; exit 1 }
Write-Host "--- compiler stdout ---"
Write-Host $r.StdOut
Write-Host "--- end stdout ---"
if (Test-Path "_dump_tmp.ll") {
    Move-Item "_dump_tmp.ll" $out -Force
    Write-Host "Wrote $out ($((Get-Item $out).Length) bytes), compiler exit=$($r.ExitCode)"
} else {
    Write-Host "No .ll produced. exit=$($r.ExitCode)"
    if ($r.StdErr) { Write-Host "STDERR: $($r.StdErr)" }
}
Remove-Item "_dump_tmp.nova" -Force -ErrorAction SilentlyContinue
