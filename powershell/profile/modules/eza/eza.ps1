# ---------------------------
# eza
# -------------------------

function Initialize-Eza {
    $env:EZA_CONFIG_DIR = Join-Path $PSScriptRoot "config"

    function global:Invoke-Eza {
        eza --icons=auto @args
    }
    
    function global:Invoke-EzaLong {
        eza -lah --icons=auto @args
    }
}
