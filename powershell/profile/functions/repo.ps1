# Search for git repositories in a folder - select from list to cd to it
function Invoke-FindRepo {
    param(
        [Parameter(Position = 0)]
        [string]$Query,
        [Alias("Path")]
        [string[]]$Root,
        [switch]$Help,
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$CliArgs
    )

    # PowerShell may bind tokens like '--help' to the first positional arg ($Query).
    # If $Query looks like an option, feed it back into CLI-style parsing.
    if (-not [string]::IsNullOrWhiteSpace($Query) -and $Query -match "^-{1,2}") {
        $CliArgs = @($Query) + @($CliArgs)
        $Query = $null
    }

    if ($CliArgs) {
        $queryParts = @()
        for ($i = 0; $i -lt $CliArgs.Count; $i++) {
            $arg = $CliArgs[$i]

            if ($arg -eq "--help" -or $arg -eq "-h") {
                $Help = $true
                continue
            }

            if ($arg -like "--path=*") {
                $pathValue = $arg.Substring("--path=".Length)
                if (-not [string]::IsNullOrWhiteSpace($pathValue)) {
                    $Root += @($pathValue -split "[;,\r\n]+")
                }
                continue
            }

            if ($arg -eq "--path" -or $arg -eq "--root" -or $arg -eq "-p") {
                if ($i + 1 -ge $CliArgs.Count) {
                    Write-Warning "$arg requires a value."
                    return
                }
                $i++
                $Root += @($CliArgs[$i] -split "[;,\r\n]+")
                continue
            }

            $queryParts += $arg
        }

        if ($queryParts.Count -gt 0) {
            $Query = ($queryParts -join " ")
        }
    }

    if ($Help) {
        Write-Host "Usage:"
        Write-Host "  repo [query]"
        Write-Host "  repo [path]"
        Write-Host "  repo --path <path1,path2,...> [query]"
        Write-Host "  repo --path=<path1,path2,...> [query]"
        Write-Host "  repo -Root <path1,path2,...> [query]"
        Write-Host ""
        Write-Host "Environment settings:"
        Write-Host "  GitRepoRootDir      One or more roots separated by ';', ',' or newlines"
        Write-Host "  GitRepoSearchDepth  Search depth for .git folders (default: 4)"
        Write-Host ""
        Write-Host "Examples:"
        Write-Host "  `$env:GitRepoRootDir = 'C:\Git;D:\Work\Repos'"
        Write-Host "  `$env:GitRepoSearchDepth = '6'"
        Write-Host "  repo --help"
        Write-Host "  repo nvim"
        Write-Host "  repo C:\Git"
        Write-Host "  repo --path C:\Git,D:\Work\Repos dotfiles"
        Write-Host "  repo -Root C:\Git,D:\Work\Repos dotfiles"
        return
    }

    if ((-not $Root -or $Root.Count -eq 0) -and
        -not [string]::IsNullOrWhiteSpace($Query) -and
        (Test-Path -LiteralPath $Query -PathType Container)) {
        $Root = @($Query)
        $Query = $null
    }

    if (-not $Root -or $Root.Count -eq 0) {
        $Root = @(
            ($env:GitRepoRootDir -split "[;,\r\n]+" | Where-Object { -not [string]::IsNullOrWhiteSpace($_) })
        )
    }

    if (-not $Root -or $Root.Count -eq 0) {
        Write-Warning "No root path provided. Use --path 'C:\Git,D:\Work' or set `$env:GitRepoRootDir with ';' or ',' separators."
        return
    }

    $resolvedRoots = @()
    foreach ($rootCandidate in $Root) {
        if ([string]::IsNullOrWhiteSpace($rootCandidate)) {
            continue
        }

        if (-not (Test-Path -LiteralPath $rootCandidate -PathType Container)) {
            Write-Warning "Root path does not exist: $rootCandidate"
            continue
        }

        $resolvedRoots += (Resolve-Path -LiteralPath $rootCandidate).Path
    }
    $resolvedRoots = $resolvedRoots | Sort-Object -Unique

    if (-not $resolvedRoots -or $resolvedRoots.Count -eq 0) {
        Write-Warning "No valid root paths were found."
        return
    }

    $depth = 4
    if (-not [string]::IsNullOrWhiteSpace($env:GitRepoSearchDepth)) {
        $parsedDepth = 0
        if ([int]::TryParse($env:GitRepoSearchDepth, [ref]$parsedDepth) -and $parsedDepth -ge 1) {
            $depth = $parsedDepth
        }
        else {
            Write-Warning "GitRepoSearchDepth is invalid ('$($env:GitRepoSearchDepth)'). Falling back to depth $depth."
        }
    }

    $repos =
        $resolvedRoots |
        ForEach-Object {
            $currentRoot = $_
            fd --type d --hidden --no-ignore-vcs --max-depth $depth "^\.git$" -- $currentRoot |
                ForEach-Object {
                    [PSCustomObject]@{
                        Root = $currentRoot
                        Repo = Split-Path $_ -Parent
                    }
                }
        } |
        Sort-Object Repo -Unique

    if (-not $repos) {
        Write-Warning "No git repositories found under: $($resolvedRoots -join ', ')"
        return
    }

    if ($Query) {
        $repo_matches = $repos | Where-Object { $_.Repo -match $Query }

        if ($repo_matches.Count -eq 1) {
            Set-Location $repo_matches[0].Repo
            return
        }

        $repos = $repo_matches
    }

    $previewScriptPath = Join-Path $PSScriptRoot "repo_preview.ps1"
    $previewCmd = "& $previewScriptPath {2}"

    $picked =
        $repos |
        ForEach-Object {
            $display = $_.Repo.Replace($_.Root, "").TrimStart('\', '/')
            if ($resolvedRoots.Count -gt 1) {
                $rootTag = Split-Path -Leaf $_.Root
                $display = "[$rootTag] $display"
            }
            "$display`t$($_.Repo)"
        } |
        fzf --delimiter "`t" --with-nth 1 --query "$Query" --preview "$previewCmd"

    if ($picked) { Set-Location (($picked -split "`t", 2)[1]) }
}
