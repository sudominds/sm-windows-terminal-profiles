$functionsPath = Join-Path $ProfileRoot "./functions/*.ps1"
Get-ChildItem $functionsPath | ForEach-Object { . $_.FullName }
