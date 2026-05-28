Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"

if (Test-Path "gen2_trait.exe") { Remove-Item "gen2_trait.exe" -Force -ErrorAction SilentlyContinue }
Copy-Item "output\nova_runtime.c" "nova_runtime.c" -Force

# Step 1: gen1 compiles nova_compiler.nova -> nova_compiler.ll
$r = Invoke-Timed -FilePath (Resolve-Path ".\gen1_final_ipt.exe").Path `
                  -Arguments "nova_compiler.nova" -TimeoutMs 120000
if ($r.TimedOut) {
    Write-Host "FAILED: gen1 compile TIMED OUT (process killed)"
    Remove-Item "nova_runtime.c" -Force -ErrorAction SilentlyContinue
    exit 1
}
Write-Host "gen1 compile: exit=$($r.ExitCode) ll=$(Test-Path 'nova_compiler.ll')"
if ($r.StdErr.Length -gt 0) {
    Write-Host "ERR: $($r.StdErr.Substring(0, [Math]::Min(500, $r.StdErr.Length)))"
}
if (-not (Test-Path "nova_compiler.ll")) {
    Write-Host "FAILED: no .ll produced"
    Remove-Item "nova_runtime.c" -Force -ErrorAction SilentlyContinue
    exit 1
}

# Step 2: link with clang
$lr = Invoke-Timed -FilePath $ClangPath `
                   -Arguments "-O2 -o gen2_trait.exe nova_compiler.ll nova_runtime.c -lws2_32" `
                   -TimeoutMs 120000
if ($lr.TimedOut) { Write-Host "FAILED: clang link TIMED OUT (process killed)" }
Write-Host "clang exit: $($lr.ExitCode)  exe=$(Test-Path 'gen2_trait.exe')"
if (Test-Path "gen2_trait.exe") {
    Write-Host "gen2_trait.exe size: $((Get-Item 'gen2_trait.exe').Length) bytes"
}

Remove-Item "nova_runtime.c" -Force -ErrorAction SilentlyContinue
Remove-Item "nova_compiler.ll" -Force -ErrorAction SilentlyContinue
