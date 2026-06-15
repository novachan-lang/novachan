$dir = $PSScriptRoot
# List all .nova test files (exclude compiler, repl, lsp check, and leading-underscore files)
$files = Get-ChildItem "$dir\*.nova" | Where-Object {
    $_.Name -ne 'nova_compiler.nova' -and
    $_.Name -ne 'repl.nova' -and
    $_.Name -ne '__lsp_check__.nova' -and
    $_.Name[0] -ne '_'
} | Sort-Object Name

Write-Host "Total non-underscore test files: $($files.Count)"
foreach ($f in $files) {
    Write-Host $f.BaseName
}
