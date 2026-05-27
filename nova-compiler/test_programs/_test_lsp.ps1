Set-Location $PSScriptRoot

Write-Host "=== LSP Server Smoke Test ==="

# Build LSP messages
function Make-LspMessage($body) {
    $bytes = [System.Text.Encoding]::UTF8.GetBytes($body)
    return "Content-Length: $($bytes.Length)`r`n`r`n$body"
}

$initBody = '{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"capabilities":{}}}'
$initializedBody = '{"jsonrpc":"2.0","method":"initialized","params":{}}'
$shutdownBody = '{"jsonrpc":"2.0","id":2,"method":"shutdown","params":null}'
$exitBody = '{"jsonrpc":"2.0","method":"exit","params":null}'

$input = (Make-LspMessage $initBody) + (Make-LspMessage $initializedBody) + (Make-LspMessage $shutdownBody) + (Make-LspMessage $exitBody)

Write-Host "Input length: $($input.Length) bytes"

# Launch process with stdin redirect
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

# Write input to stdin then close
$proc.StandardInput.Write($input)
$proc.StandardInput.Flush()
$proc.StandardInput.Close()

# Read output async
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
    Write-Host $stdout.Substring(0, [Math]::Min(3000, $stdout.Length))
}
if ($stderr.Length -gt 0) {
    Write-Host "=== STDERR ==="
    Write-Host $stderr.Substring(0, [Math]::Min(1000, $stderr.Length))
}
