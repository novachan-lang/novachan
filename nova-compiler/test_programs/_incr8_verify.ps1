# Verify the NOVA_HOME/lib module-resolution fallback BEFORE the expensive reconverge:
# build gen4 from the edited nova_compiler.nova, then prove an out-of-tree project that
# `import forge` resolves forge ONLY via $NOVA_HOME/lib -- and FAILS when NOVA_HOME is unset
# (proving the resolution is genuinely the new fallback, not some other path). Kill-on-timeout.
Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"

Write-Host "[1] gen3 compiles edited nova_compiler.nova -> nova_compiler.ll ..."
Remove-Item nova_compiler.ll -Force -ErrorAction SilentlyContinue
$c = Invoke-Timed -FilePath ".\gen3_test.exe" -Arguments "nova_compiler.nova" -TimeoutMs 900000 -WorkingDirectory $PSScriptRoot
if ($c.ExitCode -ne 0 -or !(Test-Path nova_compiler.ll)) { Write-Host "COMPILE FAIL exit=$($c.ExitCode)"; if ($c.StdOut) { Write-Host ($c.StdOut.Substring(0,[Math]::Min(1500,$c.StdOut.Length))) }; exit 1 }

Write-Host "[2] link gen4_test.exe ..."
$l = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o gen4_test.exe nova_compiler.ll output\nova_runtime.c -lws2_32 -ladvapi32 -D_CRT_SECURE_NO_WARNINGS -w" -TimeoutMs 240000 -WorkingDirectory $PSScriptRoot
if (!(Test-Path gen4_test.exe)) { Write-Host "LINK gen4 FAIL"; exit 1 }
Invoke-Timed -FilePath $ClangPath -Arguments "-c -O2 output\nova_runtime.c -o output\nova_runtime.o -D_CRT_SECURE_NO_WARNINGS -w" -TimeoutMs 120000 -WorkingDirectory $PSScriptRoot | Out-Null
Write-Host "gen4 built OK"

# Fixture: $NOVA_HOME/lib/forge.nova (a copy), and an out-of-tree project dir with NO forge.
$home_dir = Join-Path $PSScriptRoot "_nh_home"
$lib_dir  = Join-Path $home_dir "lib"
$proj_dir = Join-Path $PSScriptRoot "_nh_proj"
New-Item -ItemType Directory -Force -Path $lib_dir | Out-Null
Copy-Item -Force (Join-Path $PSScriptRoot "forge.nova") (Join-Path $lib_dir "forge.nova")
$gen4 = Join-Path $PSScriptRoot "gen4_test.exe"
$rto  = Join-Path $PSScriptRoot "output\nova_runtime.o"

Write-Host "[3] NEGATIVE: compile app.nova from the project dir with NOVA_HOME UNSET (expect FAIL) ..."
Remove-Item (Join-Path $proj_dir "app.ll") -Force -ErrorAction SilentlyContinue
$env:NOVA_HOME = ""
$neg = Invoke-Timed -FilePath $gen4 -Arguments "app.nova" -TimeoutMs 60000 -WorkingDirectory $proj_dir
if (Test-Path (Join-Path $proj_dir "app.ll")) { Write-Host "UNEXPECTED: app.ll produced without NOVA_HOME -- forge resolved from elsewhere, test invalid"; } else { Write-Host "OK negative: forge NOT resolved without NOVA_HOME (exit=$($neg.ExitCode))" }

Write-Host "[4] POSITIVE: same compile with NOVA_HOME=$home_dir (expect resolve + run) ..."
Remove-Item (Join-Path $proj_dir "app.ll"), (Join-Path $proj_dir "app.exe") -Force -ErrorAction SilentlyContinue
$env:NOVA_HOME = $home_dir
$pc = Invoke-Timed -FilePath $gen4 -Arguments "app.nova" -TimeoutMs 60000 -WorkingDirectory $proj_dir
if (!(Test-Path (Join-Path $proj_dir "app.ll"))) { Write-Host "POSITIVE COMPILE FAIL exit=$($pc.ExitCode)"; if ($pc.StdOut) { Write-Host $pc.StdOut }; exit 1 }
$pl = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o app.exe app.ll `"$rto`" -lws2_32 -ladvapi32 -D_CRT_SECURE_NO_WARNINGS -w" -TimeoutMs 90000 -WorkingDirectory $proj_dir
if (!(Test-Path (Join-Path $proj_dir "app.exe"))) { Write-Host "POSITIVE LINK FAIL"; if ($pl.StdOut) { Write-Host $pl.StdOut }; exit 1 }
$pr = Invoke-Timed -FilePath (Join-Path $proj_dir "app.exe") -Arguments "" -TimeoutMs 15000 -WorkingDirectory $proj_dir
Write-Host "RUN: $($pr.StdOut)"
Write-Host "exit=$($pr.ExitCode)"
$env:NOVA_HOME = ""
