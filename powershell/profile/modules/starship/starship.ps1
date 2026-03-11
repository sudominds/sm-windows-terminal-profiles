# ---------------------------
# Starship
# ---------------------------
$env:STARSHIP_CONFIG = if (-not $env:STARSHIP_CONFIG) { Join-Path $PSScriptRoot "..\..\..\..\shared\starship\starship.toml" | Resolve-Path } else { $env:STARSHIP_CONFIG }
Invoke-Expression (& starship init powershell)
