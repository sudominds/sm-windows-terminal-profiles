# --------------------------
# bat
# ---------------------------
$env:BAT_PAGER = "auto"
$env:BAT_THEME = "Catppuccin Mocha"
$env:BAT_STYLE = "full"
$env:BAT_CONFIG_DIR = Join-Path $PSScriptRoot "config"

function Invoke-Bat {
    & "bat.exe" @args --pager="less -X -R"
}

