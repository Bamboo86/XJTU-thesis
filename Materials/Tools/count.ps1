$ErrorActionPreference = 'Stop'

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$root = Resolve-Path (Join-Path $scriptDir '..\..')
Set-Location $root

$tempFile = Join-Path $root 'main.charcnt'
Remove-Item $tempFile -Force -ErrorAction SilentlyContinue

try {
    foreach ($file in Get-ChildItem -Path 'Main_Spine' -Filter '*.tex' | Sort-Object Name) {
        Add-Content -Path $tempFile -Value ("\input Main_Spine/$($file.Name)")
    }

    foreach ($file in Get-ChildItem -Path 'Main_Miscellaneous' -Filter '*.tex' | Sort-Object Name) {
        Add-Content -Path $tempFile -Value ("\input Main_Miscellaneous/$($file.Name)")
    }

    texcount $tempFile -merge -char -sum
}
finally {
    Remove-Item $tempFile -Force -ErrorAction SilentlyContinue
}