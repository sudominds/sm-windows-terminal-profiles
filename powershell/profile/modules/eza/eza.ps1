# ---------------------------
# eza
# -------------------------

function Initialize-Eza {
    $env:EZA_CONFIG_DIR = if (-not $env:EZA_CONFIG_DIR) { Join-Path $PSScriptRoot "..\..\..\..\shared\eza" | Resolve-Path } else { $env:EZA_CONFIG_DIR }

    function global:Invoke-Eza {
       & "eza" --icons=auto --group-directories-first @args
    }

    function global:Invoke-EzaLong {
		    Write-Host ""
        & "eza" -lah --icons=auto --group-directories-first @args
    }
}
