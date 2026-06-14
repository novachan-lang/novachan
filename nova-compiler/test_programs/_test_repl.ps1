Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
# REPL oracle for the iter-67 fix (gen2_move.exe -> gen3_test.exe compile + full link libs).
# The REPL wraps an expression line in print(...), so a self-contained expression validates
# the WHOLE pipeline: launch (gen3_test.exe repl) -> per line compile+link+run -> print.
#   6 * 7   -> print(6 * 7) -> 42
#   :quit
[System.IO.File]::WriteAllText("$PSScriptRoot\repl_in.txt", "6 * 7`n:quit`n")
Remove-Item repl_out.txt, repl_err.txt -Force -ErrorAction SilentlyContinue
$proc = Start-Process -FilePath "$PSScriptRoot\gen3_test.exe" -ArgumentList "repl" -WorkingDirectory $PSScriptRoot `
    -RedirectStandardInput "$PSScriptRoot\repl_in.txt" -RedirectStandardOutput "$PSScriptRoot\repl_out.txt" `
    -RedirectStandardError "$PSScriptRoot\repl_err.txt" -PassThru -NoNewWindow
if (-not $proc.WaitForExit(90000)) {
    try { $proc.Kill() } catch {}
    Write-Host "REPL TIMEOUT (killed)"
    exit 1
}
$out = ""
if (Test-Path repl_out.txt) { $out = (Get-Content repl_out.txt -Raw) -replace "`0", "" }
Write-Host "=== REPL OUTPUT ==="
Write-Host $out
$ok = ($out -match ">> 42") -and -not ($out -match "COMPILE_ERROR|LINK_ERROR|no \.ll produced")
Remove-Item repl_in.txt, repl_out.txt, repl_err.txt, repl_session.nova, repl_session.ll, repl_session.exe, repl.ll, repl.exe -Force -ErrorAction SilentlyContinue
if ($ok) { Write-Host "REPL_OK (6*7 -> 42 end-to-end)" } else { Write-Host "REPL_FAIL"; exit 1 }
