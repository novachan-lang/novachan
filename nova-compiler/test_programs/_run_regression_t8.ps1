$env:NOVA_TRACK8 = "1"
& "$PSScriptRoot\_run_final_regression.ps1"
$env:NOVA_TRACK8 = $null
