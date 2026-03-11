# PowerShell Terminal Bootstrap (Windows / Linux)

A modular PowerShell profile for bootstrapping a modern terminal setup with:

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
- `gb` / `git-branch` -> interactive git branch switch/delete/fetch
- `gbo` / `git-browse` -> open repo remote URL in browser
- `gitdiff` -> inspect or toggle `delta` side-by-side and line-number settings

It also enables `fzf` keybindings when `PSFzf` is installed:

- `Ctrl+T` file picker
- `Ctrl+R` history search
- `Alt+C` directory jump

## Prerequisites

- PowerShell 7+ (`pwsh`)

## Install Dependencies

### Windows (winget)

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

### Linux

Install the same tools via your package manager (e.g. `apt`, `brew`, `pacman`).

## Wire This Profile Into PowerShell

1. Create profile file if missing:

```powershell
if (-not (Test-Path $PROFILE)) {
  New-Item -ItemType File -Path $PROFILE -Force | Out-Null
}
```

2. Add this line to your PowerShell profile (`$PROFILE`):

```powershell
. "$HOME/path/to/sm-windows-terminal-profiles/powershell/profile/main_profile.ps1"
```

If your repo is in a different folder, update that path accordingly.

## Optional Environment Variables

### Repo Search

`repo` uses `GitRepoRootDir` and optional search depth:

```powershell
$env:GitRepoRootDir = "C:\Git;D:\Work\Repos"
$env:GitRepoSearchDepth = "4"
```

You can place these in `profile/environment_variables.ps1`.

### Browser Opener

`gbo` / `git-browse` requires `GIT_BROWSE_OPEN_CMD` to open URLs in a browser. Use `{url}` as a placeholder:

```powershell
$env:GIT_BROWSE_OPEN_CMD = 'wslview {url}'
```

More examples:

```powershell
$env:GIT_BROWSE_OPEN_CMD = 'cmd.exe /C start "" {url}'
$env:GIT_BROWSE_OPEN_CMD = 'xdg-open {url}'
```

If `GIT_BROWSE_OPEN_CMD` is unset, the URL is printed to the terminal.

### Yazi on Windows

On Windows, yazi needs the `file` command for MIME type detection. It's not in PATH by default, but Git for Windows bundles a copy. Point yazi to it:

```powershell
$env:YAZI_FILE_ONE = "C:/Program Files/Git/usr/bin/file.exe"
```

This is not needed on Linux where `file` is available system-wide.

### Tool Config Overrides

The profile uses shared config files from the `shared/` directory at the repo root. You can override individual paths:

```powershell
$env:BAT_CONFIG_DIR = "C:\path\to\custom\bat"
$env:BAT_THEME = "Catppuccin Mocha"
$env:BAT_STYLE = "full"
$env:EZA_CONFIG_DIR = "C:\path\to\custom\eza"
$env:STARSHIP_CONFIG = "C:\path\to\custom\starship.toml"
$env:YAZI_CONFIG_HOME = "C:\path\to\custom\yazi"
```

## Optional Delta Git Config

If you want git to use the bundled `delta` config, add this to your `~/.gitconfig`:

```ini
[include]
    path = /path/to/sm-windows-terminal-profiles/shared/delta/delta.gitconfig
```

## Layout

- `profile/main_profile.ps1` - main entrypoint
- `profile/main_profile.d/` - profile loaders and startup helpers
- `profile/functions/` - custom commands (`repo`, `git-branch`, `git-browser`)
- `profile/modules/<tool>/` - per-tool integration modules
- `../shared/` - config files shared between PowerShell and Bash profiles

## Troubleshooting

- On startup, missing dependencies are reported with copy/paste install commands.
- Re-run startup message any time with:

```powershell
Show-ProfileWelcome -Force
```
