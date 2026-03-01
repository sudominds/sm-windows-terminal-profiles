# --------------------------
# bat
# ---------------------------
$env:BAT_PAGER = "auto"
$env:BAT_THEME = "TwoDark"
$env:BAT_STYLE = "full"

function Invoke-Bat {
    bat @args
}

