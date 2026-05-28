Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"

function Make-Msg($body) {
    $bytes = [System.Text.Encoding]::UTF8.GetBytes($body)
    $len = $bytes.Length
    "Content-Length: $len`r`n`r`n$body"
}

# A NOVA file with a deliberate syntax error: missing closing )
$nova_code = "fn main()`n    let x = (1 + 2`n    print(x)`n"

# Escape for JSON string value
$escaped = $nova_code -replace '\\','\\' -replace '"','\"' -replace "`n",'\n' -replace "`r",'\r' -replace "`t",'\t'

$init     = Make-Msg '{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"processId":null,"rootUri":null,"capabilities":{}}}'
$inited   = Make-Msg '{"jsonrpc":"2.0","method":"initialized","params":{}}'
$didopen  = Make-Msg "{`"jsonrpc`":`"2.0`",`"method`":`"textDocument/didOpen`",`"params`":{`"textDocument`":{`"uri`":`"file:///test.nova`",`"languageId`":`"nova`",`"version`":1,`"text`":`"$escaped`"}}}"
$shutdown = Make-Msg '{"jsonrpc":"2.0","id":2,"method":"shutdown"}'
$exit_m   = Make-Msg '{"jsonrpc":"2.0","method":"exit"}'

$all_input = $init + $inited + $didopen + $shutdown + $exit_m

$compiler_abs = (Resolve-Path ".\gen2_move.exe").Path

$psi = New-Object System.Diagnostics.ProcessStartInfo
$psi.FileName = (Resolve-Path ".\lsp_server.exe").Path
$psi.Arguments = "`"$compiler_abs`""
$psi.UseShellExecute = $false
$psi.RedirectStandardInput = $true
$psi.RedirectStandardOutput = $true
$psi.RedirectStandardError = $true

$proc = [System.Diagnostics.Process]::Start($psi)
$proc.StandardInput.Write($all_input)
$proc.StandardInput.Close()

$stdout = $proc.StandardOutput.ReadToEnd()
$stderr = $proc.StandardError.ReadToEnd()
$proc.WaitForExit(10000) | Out-Null

Write-Host "=== LSP stdout (responses) ==="
Write-Host $stdout
Write-Host "=== LSP stderr (server log) ==="
Write-Host $stderr
Write-Host "=== Exit code: $($proc.ExitCode) ==="
