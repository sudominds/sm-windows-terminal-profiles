# ---------------------------
# fzf 
# ---------------------------

function Test-FzfDependencies {
    $missingDependencies = @()

    if (-not (Get-Command fd -ErrorAction SilentlyContinue)) {
        $missingDependencies += [PSCustomObject]@{
            Name = "fd"
            Type = "command"
            InstallCommand = "winget install --id sharkdp.fd --source winget -e"
        }
    }

    if (-not (Get-Module -ListAvailable -Name PSFzf)) {
        $missingDependencies += [PSCustomObject]@{
            Name = "PSFzf"
            Type = "psmodule"
            InstallCommand = "Install-Module PSFzf -Scope CurrentUser -Force"
        }
    }

    if (-not (Get-Module -ListAvailable -Name PSReadLine)) {
        $missingDependencies += [PSCustomObject]@{
            Name = "PSReadLine"
            Type = "psmodule"
            InstallCommand = "Install-Module PSReadLine -Scope CurrentUser -Force"
        }
    }

    return $missingDependencies
}

function Initialize-Fzf {
    $env:FZF_DEFAULT_COMMAND = 'fd.exe --type file --hidden --exclude .git --exclude bin --exclude obj --exclude node_modules'
    $env:FZF_DEFAULT_OPTS = @"
--height=40%
--layout=reverse
--border
--footer "Exit: ESC | Select: ENTER | Preview-up: ^u | Preview-down: ^d | Preview-hide: ^p" `
--preview='$PSScriptRoot\fzf_default_preview.ps1 {}' 
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
}

