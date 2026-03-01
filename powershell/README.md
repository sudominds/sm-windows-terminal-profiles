# PowerShell Terminal Bootstrap (Windows)

A modular PowerShell profile for bootstrapping a modern Windows terminal setup with:

- Better defaults (`ls`, `ll`, `cat`, `grep`, `find`, `cd`)
- Fuzzy navigation (`fzf`, repo picker)
- Git helpers (branch switch/delete UI, open remote in browser)
- Prompt and file manager integrations (`starship`, `yazi`)

## What This Profile Adds

After setup, these aliases/functions are available (when dependencies are installed):

- `ls`, `ll` -> `eza`
- `cat` -> `bat`
- `grep` -> `rg`
- `find` -> `fd`
- `y` -> launch `yazi`
- `repo` -> fuzzy jump to repositories
- `gb` -> interactive git branch switch/delete/fetch
- `gbo` -> open repo remote URL in browser

It also enables `fzf` keybindings when `PSFzf` is installed:

- `Ctrl+T` file picker
- `Ctrl+R` history search
- `Alt+C` directory jump

## Prerequisites

- Windows PowerShell 7+ (`pwsh`)
- `winget`

## Install Dependencies

Run in PowerShell:

```powershell
winget install --id Git.Git --source winget
winget install --id Neovim.Neovim --source winget
winget install --id Starship.Starship --source winget
winget install --id junegunn.fzf --source winget
winget install --id sharkdp.fd --source winget
winget install --id BurntSushi.ripgrep.MSVC --source winget
winget install --id sharkdp.bat --source winget
winget install --id eza-community.eza --source winget
winget install --id ajeetdsouza.zoxide --source winget
winget install --id sxyazi.yazi --source winget

Install-Module PSFzf -Scope CurrentUser -Force
Install-Module PSReadLine -Scope CurrentUser -Force
```

## Wire This Profile Into PowerShell

1. Create profile file if missing:

```powershell
if (-not (Test-Path $PROFILE)) {
  New-Item -ItemType File -Path $PROFILE -Force | Out-Null
}
```

2. Add this line to your PowerShell profile (`$PROFILE`):

```powershell
. "$HOME/.config/powershell/profile/main_profile.ps1"
```

If your repo is in a different folder, update that path accordingly.

## Optional Repo Search Settings

`repo` uses `GitRepoRootDir` and optional search depth:

```powershell
$env:GitRepoRootDir = "C:\Git;D:\Work\Repos"
$env:GitRepoSearchDepth = "4"
```

You can place these in `profile/environment_variables.ps1`.

## Layout

- `profile/main_profile.ps1` - main entrypoint
- `profile/main_profile.d/` - profile loaders and startup helpers
- `profile/functions/` - custom commands (`repo`, `git-branch`, `git-browser`)
- `profile/modules/<tool>/` - per-tool integration modules/config

## Troubleshooting

- On startup, missing dependencies are reported with copy/paste install commands.
- Re-run startup message any time with:

```powershell
Show-ProfileWelcome -Force
```
