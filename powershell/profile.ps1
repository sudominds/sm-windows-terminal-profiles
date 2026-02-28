# Git for Windows
# Provides: git, less pager, file.exe (used by Yazi), Unix tools
#winget install --id Git.Git

# Neovim (your $EDITOR)
# Modern modal editor used by many CLI tools
#winget install --id Neovim.Neovim

# Starship prompt
# Fast, cross-shell prompt with git status, language versions, etc.
#winget install --id starship.starship

# fzf
# Interactive fuzzy finder (Ctrl+T, Ctrl+R, repo picker, etc.)
#winget install --id junegunn.fzf

# fd
# Extremely fast file finder (used instead of dir/Get-ChildItem)
#winget install --id sharkdp.fd

# ripgrep (rg)
# Blazing-fast text search across codebases
#winget install --id BurntSushi.ripgrep.MSVC

# bat
# cat replacement with syntax highlighting & previews
#winget install --id sharkdp.bat

# eza
# Modern ls replacement (icons, tree view, used in fzf preview)
#winget install --id eza-community.eza

# zoxide
# Smart cd replacement (learns and jumps to frequent directories)
#winget install --id ajeetdsouza.zoxide

# Yazi
# Terminal file manager with previews & navigation
#winget install --id sxyazi.yazi

# PSFzf (fzf keybindings & integration)
#Install-Module PSFzf -Scope CurrentUser -Force
#Install-Module PSReadLine -Scope CurrentUser -Force

#winget install --id Git.Git
#winget install --id Neovim.Neovim
#winget install --id starship.starship
#winget install --id junegunn.fzf
#winget install --id sharkdp.fd
#winget install --id BurntSushi.ripgrep.MSVC
#winget install --id sharkdp.bat
#winget install --id eza-community.eza
#winget install --id ajeetdsouza.zoxide
#winget install --id sxyazi.yazi
#Install-Module PSFzf -Scope CurrentUser -Force
#Install-Module PSReadLine -Scope CurrentUser -Force

# Only run in interactive shells
if (-not $Host.UI.RawUI) { return }

# ---------------------------
# Environment
# ---------------------------
$env:EDITOR = "nvim"
$env:PAGER  = "less"
$env:LANG   = "en_GB.UTF-8"
$env:YAZI_FILE_ONE = "C:/Program Files/Git/usr/bin/file.exe"
$env:SHELL = "pwsh"
$env:PATH = "$HOME\.local\bin;$env:PATH"
$env:GitRepoRootDir = "C:\Code\"


# ---------------------------
# Starship
# ---------------------------
$env:STARSHIP_CONFIG = "$HOME\.config\starship\starship.toml"
Invoke-Expression (& starship init powershell)

# ---------------------------
# fzf 
# ---------------------------
$env:FZF_DEFAULT_COMMAND = 'fd --type file --hidden --exclude .git --exclude bin --exclude obj --exclude node_modules'
$env:FZF_DEFAULT_OPTS = @"
--height=40%
--layout=reverse
--border
--ansi
--preview='$HOME\\.config\\fzf\\preview.ps1 {}' 
--bind 'ctrl-p:toggle-preview'
--bind 'ctrl-d:preview-down'
--bind 'ctrl-u:preview-up'
--preview-window=right:60%:wrap
"@

$env:FZF_CTRL_T_COMMAND = $env:FZF_DEFAULT_COMMAND
#$env:FZF_CTRL_T_OPTS = @"
#"@

#$env:FZF_ALT_C_OPTS = @"
#"@

#$env:FZF_CTRL_R_OPTS = @"
#"@

# Enable fzf keybindings in PowerShell via PSFzf
if (Get-Module -ListAvailable -Name PSFzf) {
    Import-Module PSFzf

    # Ctrl+T (files) and Alt+C (directories)
    Set-PsFzfOption -EnableAliasFuzzyEdit
    Set-PsFzfOption -EnableAliasFuzzyFasd
    Set-PsFzfOption -EnableAliasFuzzyHistory
    Set-PsFzfOption -EnableAliasFuzzyGitStatus

    Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r'
}

# ---------------------------
# zoxide (override cd)
# ---------------------------
Invoke-Expression (& { (zoxide init powershell --cmd cd | Out-String) })

# ---------------------------
# eza
# -------------------------
$env:EZA_CONFIG_DIR = "$HOME\.config\eza" 

function Invoke-Eza {
    eza --icons=auto @args
}
Set-Alias -Name ls -Value Invoke-Eza

function Invoke-EzaLong {
    eza -lah --icons=auto @args
}
Set-Alias -Name ll -Value Invoke-EzaLong

# --------------------------
# bat
# ---------------------------
$env:BAT_PAGER = "auto"
$env:BAT_THEME = "TwoDark"
$env:BAT_STYLE = "full"

function Invoke-Bat {
    bat @args
}
Set-Alias -Name cat -Value Invoke-Bat

# --------------------------
# ripgrep
# --------------------------
function Invoke-RipGrep {
    rg @args
}
Set-Alias -Name grep -Value Invoke-RipGrep

# --------------------------
# fd
# --------------------------
function Invoke-Fd {
    fd @args
}
Set-Alias -Name find -Value Invoke-Fd

# ---------------------------
# Functions
# ---------------------------
# Search for git repositories in a folder - select from list to cd to it
function repo {
    param([string]$query)

    $root = $env:GitRepoRootDir

    $repos =
        fd --type d --hidden --no-ignore-vcs --max-depth 4 "^\.git$" $root |
        ForEach-Object { Split-Path $_ -Parent } |
        Sort-Object -Unique

    if ($query) {
        $matches = $repos | Where-Object { $_ -match $query }

        if ($matches.Count -eq 1) {
            Set-Location $matches[0]
            return
        }

        $repos = $matches
    }

    $picked =
        $repos |
        ForEach-Object {
            $display = $_.Replace($root, "")
            "$display`t$_"
        } |
        fzf --delimiter "`t" --with-nth 1 --query "$query" --preview "eza --tree --level=1 --color=always --all --icons=auto {2}"

    if ($picked) { Set-Location (($picked -split "`t", 2)[1]) }
}

# list branches in git rrepository and select to change
function git-branch {

    if (-not (git rev-parse --is-inside-work-tree 2>$null)) {
        Write-Host "Not inside a git repository." -ForegroundColor Yellow
        return
    }

    $deleteBranchKey = "alt-d"
	$fetchKey = "alt-f"

    while ($true) {

        $current = git branch --show-current

        # locals: name + upstream + tracking status (e.g. "[ahead 2]", "[behind 1]", "[ahead 1, behind 3]", "[gone]")
        $locals = git for-each-ref `
            --sort=-committerdate `
            --format="%(refname:short)`t%(upstream:short)`t%(upstream:track)" `
            refs/heads

        $remotes = git for-each-ref `
            --sort=-committerdate `
            --format="%(refname:short)" `
            refs/remotes |
            Where-Object { $_ -notmatch '^(origin$|origin/HEAD|HEAD)$' }

        $lines = @(
            foreach ($line in $locals) {
                $name, $up, $track = $line -split "`t", 3
                $star = if ($name -eq $current) { "*" } else { " " }

                # status label
                if ($track -match '\[gone\]') {
                    $label = "`e[31m[gne]`e[0m"   # red
                }
                elseif ($up) {
                    $label = "`e[32m[trk]`e[0m"    # green
                }
                else {
                    $label = "`e[33m[lcl]`e[0m"    # yellow
                }

                # ahead/behind numbers
                $ahead = 0
                $behind = 0
                if ($track) {
                    if ($track -match 'ahead\s+(\d+)')  { $ahead  = [int]$matches[1] }
                    if ($track -match 'behind\s+(\d+)') { $behind = [int]$matches[1] }
                }

                # fixed-width AB column so things line up
                # e.g. "↑ 12 ↓  3" (always same width)
                $abText = ""  # 8 spaces when nothing
                if ($ahead -gt 0 -or $behind -gt 0) {
                    $abText = ("↑{0,3} ↓{1,3}" -f $ahead, $behind)
                }
                $ab = "`e[35m$abText`e[0m"  # magenta

                # Display<TAB>Ref
                "$star $label $ab $name`t$name"
            }

            foreach ($ref in $remotes) {
                "  `e[36m[rmt]`e[0m  $ref`t$ref"  # cyan; keep spacing similar
            }
        )

        $out = $lines | fzf `
            --ansi `
            --height=50% --layout=reverse --border `
            --preview-border sharp `
            --preview-window "right:60%:wrap" `
            --delimiter "`t" --with-nth 1 `
			--expect="$deleteBranchKey,$fetchKey" `
            --footer "Pre-up: ^u | Pre-down: ^d | Pre-hide: ^p | Switch: ENTER | Delete: $deleteBranchKey | Fetch: $fetchKey" `
            --border-label " Git Branches " `
            --preview "git --no-pager log --color=always -n 10 --pretty=format:'%C(magenta)%h%Creset %C(cyan)%cr%Creset %C(yellow)%an%Creset %C(auto)%d%Creset%n  %s%n' {2}"

        if (-not $out) { return }

        $key = $out[0]
        $picked = $out[1]
        if (-not $picked) { continue }

		if ($key -eq $fetchKey) {
			Write-Host "[git fetch --all --prune --tags]" -ForegroundColor DarkGray
				git fetch --all --prune --tags
				Start-Sleep -Milliseconds 300
				continue
		}

        $ref = ($picked -split "`t", 2)[1]

        # normalize remote branch names for switching/deleting
        if ($ref -like "origin/*") {
            $ref = $ref -replace '^origin/', ''
        }

        # Alt+D → delete branch
        if ($key -eq $deleteBranchKey) {

            if ($ref -eq $current) {
                Write-Host "Cannot delete current branch." -ForegroundColor Red
                Start-Sleep 1
                continue
            }

            Write-Host ""
            Write-Host "Delete branch '$ref'? (y/N)" -ForegroundColor Yellow
            $response = Read-Host

            if ($response -match '^[Yy]$') {
                git branch -d $ref
                Write-Host "Deleted $ref" -ForegroundColor Red
            }

            Start-Sleep 1
            continue
        }

		git show-ref --verify --quiet "refs/heads/$ref"
			$localExists = ($LASTEXITCODE -eq 0)

			if ($localExists) {
				git switch $ref
			} else {
				git switch --track "origin/$ref"
			}

        return
    }
}

# open git repo in a browser
function git-browse {
    try {
        $url = git remote get-url origin 2>$null
        if (-not $url) {
            Write-Host "No origin remote found." -ForegroundColor Yellow
            return
        }

        # convert SSH → HTTPS
        if ($url -match "^git@([^:]+):(.+)$") {
            $url = "https://$($Matches[1])/$($Matches[2])"
        }

        # remove embedded username (Azure DevOps etc.)
        $url = $url -replace "^https://[^@]+@", "https://"

        # remove .git suffix
        $url = $url -replace "\.git$", ""

        Start-Process $url
    }
    catch {
        Write-Host "Not inside a git repository." -ForegroundColor Red
    }
}

# yazi alias - when exiting will cd to the directory
#Set-Alias -Name y -Value yazi
function y {
    $tmp = (New-TemporaryFile).FullName
    yazi $args --cwd-file="$tmp"
    $cwd = Get-Content -Path $tmp -Encoding UTF8
    if ($cwd -ne $null -and $cwd -ne $PWD.Path -and (Test-Path -LiteralPath $cwd -PathType Container)) {
        Set-Location -LiteralPath (Resolve-Path -LiteralPath $cwd).Path
    }
    Remove-Item -Path $tmp
} 
