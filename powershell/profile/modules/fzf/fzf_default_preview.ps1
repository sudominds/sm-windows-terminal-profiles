param([string]$path)

$path = $path.Trim("'")

if (Test-Path -LiteralPath $path -PathType Container) {
    if (Get-Command eza -ErrorAction SilentlyContinue) {
        eza --tree --level=1 --icons --color=always --group-directories-first -- $path
    }
    else {
        Get-ChildItem -LiteralPath $path -Force -ErrorAction SilentlyContinue |
            Select-Object -First 200 |
            Format-Table -Property Mode, LastWriteTime, Length, Name -AutoSize
    }
    exit
}

if (-not (Get-Command bat -ErrorAction SilentlyContinue)) {
    Get-Content -LiteralPath $path -TotalCount 300 -ErrorAction SilentlyContinue
    exit
}

$out = & bat --style=all --color=always --paging=never --line-range :300 -- $path 2>&1

if ($LASTEXITCODE -ne 0 -or $out -match "binary") 
{ 
	$path 
} 
else 
{ 
	$out 
}
