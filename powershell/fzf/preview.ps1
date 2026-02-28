param([string]$path)

$path = $path.Trim("'")

if (Test-Path -LiteralPath $path -PathType Container) {
    eza --tree --level=1 --icons --color=always --group-directories-first -- $path
    exit
}

$out = & bat --style=numbers --color=always --paging=never --line-range :300 -- $path 2>&1

if ($LASTEXITCODE -ne 0 -or $out -match "binary") 
{ 
	$path 
} 
else 
{ 
	$out 
}
