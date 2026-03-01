# ---------------------------
# Starship
# ---------------------------
$env:STARSHIP_CONFIG = "$PSScriptRoot\config\starship.toml"
Invoke-Expression (& starship init powershell)
