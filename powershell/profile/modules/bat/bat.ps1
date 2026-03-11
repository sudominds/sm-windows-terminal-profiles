# --------------------------
# bat
# ---------------------------
$env:BAT_PAGER = "less"
$env:BAT_PAGING = "auto"
$env:BAT_CONFIG_DIR = if (-not $env:BAT_CONFIG_DIR) { Join-Path $PSScriptRoot "..\..\..\..\shared\bat" | Resolve-Path } else { $env:BAT_CONFIG_DIR }
$env:BAT_THEME = if (-not $env:BAT_THEME) { "Catppuccin Mocha" } else { $env:BAT_THEME }
$env:BAT_STYLE = if (-not $env:BAT_STYLE) { "full" } else { $env:BAT_STYLE }
