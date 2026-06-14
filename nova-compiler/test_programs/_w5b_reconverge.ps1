# 3-pass W5b-ON reconverge: NOVA_T8_DROP=1 on every compile. Tests if the W5b-on compiler reaches a
# stable fixpoint (gen5_w5b.ll == gen6_w5b.ll). Does NOT install (probe only); restores nothing (gen3 untouched).
Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
$LLVM = "C:\Program Files\LLVM\bin"
$env:NOVA_T8_DROP = "1"
$rt = "$PSScriptRoot\output\nova_runtime.c"
$lib = "-lws2_32 -lwinhttp -ladvapi32 -lbcrypt -D_CRT_SECURE_NO_WARNINGS -w"
function CompileSelf($exe, $outll) {
    Remove-Item nova_compiler.ll -Force -ErrorAction SilentlyContinue
    $r = Invoke-Timed -FilePath $exe -Arguments "nova_compiler.nova" -TimeoutMs 450000 -WorkingDirectory $PSScriptRoot
    if ($r.ExitCode -ne 0 -or !(Test-Path nova_compiler.ll)) { Write-Host "compile FAIL ($exe) exit=$($r.ExitCode)"; return $false }
    Copy-Item nova_compiler.ll $outll -Force; return $true
}
function Link($ll, $exe) {
    Remove-Item $exe -Force -ErrorAction SilentlyContinue
    Invoke-Timed -FilePath "$LLVM\clang.exe" -Arguments "-O2 -o $exe $ll `"$rt`" $lib" -TimeoutMs 240000 -WorkingDirectory $PSScriptRoot | Out-Null
    return (Test-Path $exe)
}
# pass1: gen3(default 1187CB94, W5b-on via env) -> p1
if (-not (CompileSelf (Resolve-Path ".\gen3_test.exe").Path "w5b_p1.ll")) { exit 1 }
if (-not (Link "w5b_p1.ll" "w5b_g4.exe")) { Write-Host "link g4 FAIL"; exit 1 }
# pass2: gen4_w5b -> p2 (gen5_w5b)
if (-not (CompileSelf "$PSScriptRoot\w5b_g4.exe" "w5b_p2.ll")) { exit 1 }
if (-not (Link "w5b_p2.ll" "w5b_g5.exe")) { Write-Host "link g5 FAIL"; exit 1 }
# pass3: gen5_w5b -> p3 (gen6_w5b)
if (-not (CompileSelf "$PSScriptRoot\w5b_g5.exe" "w5b_p3.ll")) { exit 1 }
$h5 = (Get-FileHash w5b_p2.ll -Algorithm SHA256).Hash
$h6 = (Get-FileHash w5b_p3.ll -Algorithm SHA256).Hash
Write-Host "gen5_w5b: $($h5.Substring(0,16))"
Write-Host "gen6_w5b: $($h6.Substring(0,16))"
if ($h5 -eq $h6) { Write-Host "W5B-RECONVERGE OK (gen5_w5b==gen6_w5b)" } else { Write-Host "W5B-RECONVERGE DIVERGES" }
# keep w5b_p2.ll / w5b_p3.ll for diffing if diverged; clean the exes
Remove-Item w5b_g4.exe, w5b_g5.exe, w5b_p1.ll -Force -ErrorAction SilentlyContinue
