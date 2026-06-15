# Install (or refresh) the Forge framework into the toolchain stdlib so `import forge` resolves
# from $NOVA_HOME/lib for ANY project on disk. Copies the single canonical source
# <repo>/forge/forge.nova -> <repo>/nova-compiler/lib/forge.nova. The test harness
# (_proc_util.ps1) does this automatically on every run; this script is the standalone entry
# point (e.g. for a future `nova build` / installer to call).
Set-Location $PSScriptRoot
$nova_home  = (Resolve-Path "$PSScriptRoot\..").Path
$canonical  = Join-Path $nova_home "..\forge\forge.nova"
$installed  = Join-Path $nova_home "lib\forge.nova"
if (!(Test-Path $canonical)) { Write-Host "MISSING canonical source: $canonical"; exit 1 }
New-Item -ItemType Directory -Force -Path (Split-Path $installed) | Out-Null
Copy-Item -Force $canonical $installed
Write-Host "Installed forge -> $installed"
Write-Host "NOVA_HOME = $nova_home"
