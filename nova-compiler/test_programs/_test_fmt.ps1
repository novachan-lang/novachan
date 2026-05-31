Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"

Write-Host "=== FORMATTER IDEMPOTENCE TEST ==="

# Build nova_build.exe (hosts the formatter)
Write-Host "[1/5] Building nova_build.exe..."
Remove-Item nova_build.ll -Force -ErrorAction SilentlyContinue
$cr = Invoke-Timed -FilePath '.\gen3_test.exe' -Arguments 'nova_build.nova' -TimeoutMs 30000 -WorkingDirectory $PSScriptRoot
if ($cr.ExitCode -ne 0) { Write-Host "FAIL compile nova_build"; Write-Host $cr.StdOut; exit 1 }
$linkArgs = "-O2 -o `"nova_build.exe`" `"nova_build.ll`" `"output\nova_runtime.c`" $NovaLinkFlags -D_CRT_SECURE_NO_WARNINGS -w"
Invoke-Timed -FilePath $ClangPath -Arguments $linkArgs -TimeoutMs 30000 -WorkingDirectory $PSScriptRoot | Out-Null
if (!(Test-Path nova_build.exe)) { Write-Host "FAIL link"; exit 1 }
Write-Host "  OK"

# Create a messy but 4-space-structured source
$work = Join-Path $PSScriptRoot "test_fmt"
if (Test-Path $work) { Remove-Item $work -Recurse -Force }
New-Item -ItemType Directory -Path $work -Force | Out-Null
$src = Join-Path $work "messy.nova"
# Trailing whitespace + over-indented body (8 spaces -> should normalize to 4-multiple)
$content = "fn add(a: int, b: int) -> int   `n        a + b    `n`nfn main()`n    let x = add(3, 4)`n    print(str(x))`n"
[System.IO.File]::WriteAllText($src, $content)

Write-Host "[2/5] Format once..."
$f1 = Invoke-Timed -FilePath "$PSScriptRoot\nova_build.exe" -Arguments "fmt `"$src`"" -TimeoutMs 10000 -WorkingDirectory $PSScriptRoot
$after1 = Get-Content -Raw $src
Write-Host "  formatted output:"
$after1 -split "`n" | ForEach-Object { Write-Host "    |$_" }

Write-Host "[3/5] Format again (must be idempotent)..."
$f2 = Invoke-Timed -FilePath "$PSScriptRoot\nova_build.exe" -Arguments "fmt `"$src`"" -TimeoutMs 10000 -WorkingDirectory $PSScriptRoot
$after2 = Get-Content -Raw $src
if ($after1 -ne $after2) { Write-Host "FAIL: not idempotent"; exit 1 }
if (!($f2.StdOut -match "already formatted")) { Write-Host "WARN: second pass did not report 'already formatted' (still idempotent by content)"; }
Write-Host "  OK (idempotent)"

Write-Host "[4/5] No trailing whitespace remains..."
if ($after1 -match " `n" -or $after1 -match " $") { Write-Host "FAIL: trailing whitespace remains"; exit 1 }
Write-Host "  OK"

Write-Host "[5/5] Formatted source still compiles..."
Copy-Item ".\gen3_test.exe" "$work\" -Force
$cc = Invoke-Timed -FilePath "$work\gen3_test.exe" -Arguments 'messy.nova' -TimeoutMs 20000 -WorkingDirectory $work
if ($cc.ExitCode -ne 0) { Write-Host "FAIL: formatted source no longer compiles"; Write-Host $cc.StdOut; exit 1 }
Write-Host "  OK"

# Cleanup
Remove-Item $work -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item nova_build.ll, nova_build.exe -Force -ErrorAction SilentlyContinue

Write-Host "`n=== FORMATTER: ALL PASS ==="
