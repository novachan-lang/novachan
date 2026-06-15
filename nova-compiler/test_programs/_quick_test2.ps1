param([string]$NovaFile, [int]$TimeoutMs = 5000)
$base = [System.IO.Path]::GetFileNameWithoutExtension($NovaFile)

# Compile
$null = & ./gen4_test.exe $NovaFile 2>&1
if (-not (Test-Path "$base.ll")) { Write-Host "Compile failed: no $base.ll"; exit 1 }

# Link (suppress warnings)
& clang -O2 -o "${base}_run.exe" "$base.ll" output/nova_runtime.c -lws2_32 -ladvapi32 2>$null
if (-not (Test-Path "${base}_run.exe")) { Write-Host "Link failed"; exit 1 }

# Run with timeout
$psi = New-Object System.Diagnostics.ProcessStartInfo
$psi.FileName = (Resolve-Path "./${base}_run.exe").Path
$psi.UseShellExecute = $false
$psi.RedirectStandardOutput = $true
$psi.RedirectStandardError = $true
$psi.CreateNoWindow = $true
$proc = [System.Diagnostics.Process]::Start($psi)
$stdout = $proc.StandardOutput.ReadToEndAsync()
$stderr = $proc.StandardError.ReadToEndAsync()
$exited = $proc.WaitForExit($TimeoutMs)
if (-not $exited) {
    $proc.Kill()
    Write-Host "TIMEOUT after ${TimeoutMs}ms"
    Write-Host "STDOUT so far: $($stdout.Result)"
    Write-Host "STDERR so far: $($stderr.Result)"
    exit 1
}
[System.Threading.Tasks.Task]::WaitAll($stdout, $stderr)
if ($stdout.Result) { Write-Host $stdout.Result }
if ($stderr.Result) { Write-Host "STDERR: $($stderr.Result)" }
Write-Host "EXIT: $($proc.ExitCode)"
