param(
    [string]$RepoPath
)

if ([string]::IsNullOrWhiteSpace($RepoPath)) {
    return
}

if (-not (Test-Path -LiteralPath $RepoPath -PathType Container)) {
    return
}

if (Get-Command eza -ErrorAction SilentlyContinue) {
    eza --tree --level=1 --color=always --all --icons=auto -- $RepoPath
    return
}

Get-ChildItem -Force -LiteralPath $RepoPath |
    Select-Object -First 200 |
    Format-Table Mode, LastWriteTime, Length, Name -AutoSize
