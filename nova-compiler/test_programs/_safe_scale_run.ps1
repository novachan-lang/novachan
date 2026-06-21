# SAFE scale-test runner. Launches a test exe and watches its Private Bytes; force-kills (taskkill /F /T,
# the only kill proven to work on this machine -- WaitForExit does NOT kill) if memory exceeds a HARD cap
# OR a timeout elapses. Designed so a scale/runaway test can NEVER exhaust this 16GB machine (it runs other
# projects). Default cap 2GB = 4x the largest planned test (~480MB) and far below system RAM.
param(
  [Parameter(Mandatory=$true)][string]$Exe,
  [int]$TimeoutSec = 60,
  [long]$MaxBytes = 2147483648,   # 2 GB hard per-process cap
  [int]$SampleMs = 100
)
$ErrorActionPreference = "Continue"
if (-not (Test-Path $Exe)) { Write-Host "RESULT exit=-2 reason=NO_EXE peakMB=0 wallMs=0"; exit 2 }
$Exe = (Resolve-Path $Exe).Path    # Start-Process needs an absolute path (won't search CWD for a bare name)
$out = "$Exe.scaleout.txt"
$err = "$Exe.scaleerr.txt"
$p = Start-Process -FilePath $Exe -PassThru -NoNewWindow -RedirectStandardOutput $out -RedirectStandardError $err
$peak = [long]0
$sw = [System.Diagnostics.Stopwatch]::StartNew()
$reason = "exited"
$killed = $false
while ($true) {
  Start-Sleep -Milliseconds $SampleMs
  $proc = Get-Process -Id $p.Id -ErrorAction SilentlyContinue
  if (-not $proc) { break }                      # process exited on its own
  $pb = [long]$proc.PrivateMemorySize64
  if ($pb -gt $peak) { $peak = $pb }
  if ($pb -gt $MaxBytes) {
    $reason = "MEMORY_CAP_$([math]::Round($pb/1MB))MB"
    cmd /c "taskkill /F /T /PID $($p.Id)" | Out-Null
    $killed = $true; break
  }
  if ($sw.Elapsed.TotalSeconds -gt $TimeoutSec) {
    $reason = "TIMEOUT_${TimeoutSec}s"
    cmd /c "taskkill /F /T /PID $($p.Id)" | Out-Null
    $killed = $true; break
  }
}
$sw.Stop()
$exit = -1
if (-not $killed) { try { $p.WaitForExit(); $exit = $p.ExitCode } catch { $exit = -3 } }
$peakMB = [math]::Round($peak / 1MB, 1)
$wall = [math]::Round($sw.Elapsed.TotalMilliseconds, 0)
Write-Host "RESULT exit=$exit reason=$reason peakMB=$peakMB wallMs=$wall"
if (Test-Path $out) { Write-Host "--- stdout (tail) ---"; Get-Content $out -Tail 6 }
if ((Test-Path $err) -and (Get-Item $err).Length -gt 0) { Write-Host "--- stderr (tail) ---"; Get-Content $err -Tail 4 }
