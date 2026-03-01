# yazi 
$env:YAZI_CONFIG_HOME = Join-Path $PSScriptRoot "config"
$env:YAZI_FILE_ONE = "C:/Program Files/Git/usr/bin/file.exe"

function Invoke-Yazi {
    $tmp = (New-TemporaryFile).FullName
    yazi $args --cwd-file="$tmp"
    $cwd = Get-Content -Path $tmp -Encoding UTF8
    if ($null -ne $cwd -and $cwd -ne $PWD.Path -and (Test-Path -LiteralPath $cwd -PathType Container)) {
        Set-Location -LiteralPath (Resolve-Path -LiteralPath $cwd).Path
    }
    Remove-Item -Path $tmp
}

