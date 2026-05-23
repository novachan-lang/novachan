Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"

# Check what nova_compiler.nova produces for the fuzz cases that should fail.
$files = @("unclosed_string", "bad_escape", "huge_int", "bad_indent", "mixed_tabs",
           "typo_ident", "unknown_field", "too_few_args", "duplicate_fn", "missing_fn_body", "no_main", "empty")

foreach ($name in $files) {
    $f = "$PSScriptRoot\fuzz_corpus\$name.nova"
    Write-Host "=== $name ==="
    $r = Invoke-Timed -FilePath (Resolve-Path ".\gen2_move.exe").Path -Arguments "`"$f`"" -TimeoutMs 15000
    Write-Host "exit: $($r.ExitCode)  out: $($r.StdOut.Trim())"
    if ($r.StdErr) { Write-Host "err: $($r.StdErr.Trim())" }
    Write-Host ""
}

# Cleanup
Get-ChildItem -Path "$PSScriptRoot\fuzz_corpus" -Filter "*.ll" -ErrorAction SilentlyContinue | Remove-Item -Force
