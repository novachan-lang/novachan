Set-Location $PSScriptRoot

Write-Host "=== LSP Clean File Test ==="

function Make-LspMessage($body) {
    $bytes = [System.Text.Encoding]::UTF8.GetBytes($body)
    return "Content-Length: $($bytes.Length)`r`n`r`n$body"
}

# Valid NOVA code - should produce zero diagnostics
$novaSource = "fn main()\n    let x = 42\n    print(x)\n"
$uri = "file:///C:/test/good.nova"

$initBody = '{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"capabilities":{}}}'
$initializedBody = '{"jsonrpc":"2.0","method":"initialized","params":{}}'
$didOpenBody = '{"jsonrpc":"2.0","method":"textDocument/didOpen","params":{"textDocument":{"uri":"' + $uri + '","languageId":"nova","version":1,"text":"' + $novaSource + '"}}}'
$shutdownBody = '{"jsonrpc":"2.0","id":2,"method":"shutdown","params":null}'
$exitBody = '{"jsonrpc":"2.0","method":"exit","params":null}'

$input = (Make-LspMessage $initBody) + (Make-LspMessage $initializedBody) + (Make-LspMessage $didOpenBody) + (Make-LspMessage $shutdownBody) + (Make-LspMessage $exitBody)

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

# Check if diagnostics array is empty
if ($stdout -match '"diagnostics":\[\]') {
    Write-Host "PASS: Valid file produces empty diagnostics"
} elseif ($stdout -match '"diagnostics":\[') {
    Write-Host "FAIL: Valid file produced unexpected diagnostics"
} else {
    Write-Host "WARN: Could not find diagnostics in output"
}

Write-Host "STDOUT: $stdout"
