Set-Location $PSScriptRoot

Write-Host "=== LSP Diagnostics Test ==="

function Make-LspMessage($body) {
    $bytes = [System.Text.Encoding]::UTF8.GetBytes($body)
    return "Content-Length: $($bytes.Length)`r`n`r`n$body"
}

# Test with a file that has a type error
$novaSource = "fn main()\n    let x = 42\n    let y = x + \`"hello\`"\n    print(y)\n"
$uri = "file:///C:/test/bad.nova"

$initBody = '{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"capabilities":{}}}'
$initializedBody = '{"jsonrpc":"2.0","method":"initialized","params":{}}'
$didOpenBody = '{"jsonrpc":"2.0","method":"textDocument/didOpen","params":{"textDocument":{"uri":"' + $uri + '","languageId":"nova","version":1,"text":"' + $novaSource + '"}}}'
$shutdownBody = '{"jsonrpc":"2.0","id":2,"method":"shutdown","params":null}'
$exitBody = '{"jsonrpc":"2.0","method":"exit","params":null}'

$input = (Make-LspMessage $initBody) + (Make-LspMessage $initializedBody) + (Make-LspMessage $didOpenBody) + (Make-LspMessage $shutdownBody) + (Make-LspMessage $exitBody)

Write-Host "Input length: $($input.Length) bytes"

$psi = New-Object System.Diagnostics.ProcessStartInfo
$psi.FileName = (Resolve-Path ".\gen2_move.exe").Path
$psi.Arguments = "lsp"
$psi.WorkingDirectory = $PSScriptRoot
$psi.UseShellExecute = $false
$psi.RedirectStandardInput = $true
$psi.RedirectStandardOutput = $true
$psi.RedirectStandardError = $true
$psi.CreateNoWindow = $true

$proc = [System.Diagnostics.Process]::Start($psi)

$proc.StandardInput.Write($input)
$proc.StandardInput.Flush()
$proc.StandardInput.Close()

$outTask = $proc.StandardOutput.ReadToEndAsync()
$errTask = $proc.StandardError.ReadToEndAsync()

$done = $proc.WaitForExit(15000)
if (-not $done) {
    try { $proc.Kill() } catch {}
    try { $proc.WaitForExit(5000) | Out-Null } catch {}
    Write-Host "TIMEOUT - killed"
} else {
    Write-Host "EXIT=$($proc.ExitCode)"
}

$stdout = $outTask.Result
$stderr = $errTask.Result

Write-Host "STDOUT length: $($stdout.Length)"
if ($stdout.Length -gt 0) {
    Write-Host "=== STDOUT ==="
    Write-Host $stdout
}
if ($stderr.Length -gt 0) {
    Write-Host "=== STDERR ==="
    Write-Host $stderr
}
