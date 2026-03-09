# ---------------------------
# eza
# -------------------------

function Initialize-Eza {
    $env:EZA_CONFIG_DIR = Join-Path $PSScriptRoot "config"

    function global:Invoke-Eza {
       & "eza.exe" --icons=auto --group-directories-first @args
    }
    
    function global:Invoke-EzaLong {
		    Write-Host ""
        & "eza.exe" -lah --icons=auto --group-directories-first @args
    }
}
