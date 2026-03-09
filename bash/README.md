# Bash Terminal Bootstrap (Linux / WSL)

A modular Bash profile that mirrors the PowerShell setup with:

- Better defaults (`ls`, `ll`, `cat`, `grep`, `find`, `cd`)
- Fuzzy navigation (`fzf`, repo picker)
- Git helpers (branch switch/delete UI, open remote in browser)
- Prompt and file manager integrations (`starship`, `yazi`)

## Wire This Profile Into Bash

Add this line to your `.bashrc`:

```bash
source "$HOME/path/to/sm-windows-terminal-profiles/bash/profile/main_profile.sh"
```

Update the path if the repo lives elsewhere.

## Optional Repo Search Settings

`repo` uses `GIT_REPO_ROOT_DIR` and optional search depth:

```bash
export GIT_REPO_ROOT_DIR="$HOME/git;$HOME/work/repos"
export GIT_REPO_SEARCH_DEPTH="4"
```

The Bash profile also accepts the legacy `GitRepoRootDir` and `GitRepoSearchDepth` names for compatibility.

## Optional Browser Settings

`gbo` / `git-browse` can use a custom browser opener:

```bash
export GIT_BROWSE_OPEN_CMD='wslview {url}'
```

Examples:

```bash
export GIT_BROWSE_OPEN_CMD='cmd.exe /C start "" {url}'
export GIT_BROWSE_OPEN_CMD='xdg-open {url}'
```

If `GIT_BROWSE_OPEN_CMD` is unset, the profile auto-detects `wslview` on WSL and otherwise falls back to `xdg-open`.

On WSL, if browser opening is inconsistent, set this explicitly:

```bash
export GIT_BROWSE_OPEN_CMD='wslview {url}'
```

If `wslview` is not installed, or if you do not import Windows paths into WSL, use the full Windows executable path instead:

```bash
export GIT_BROWSE_OPEN_CMD='/mnt/c/Windows/System32/cmd.exe /C start "" {url}'
export GIT_BROWSE_OPEN_CMD='"/mnt/c/Program Files/PowerShell/7/pwsh.exe" -NoProfile -Command Start-Process {url}'
```

## What This Profile Adds

After setup, these aliases/functions are available when dependencies are installed:

- `ls`, `ll` -> `eza`
- `cat` -> `bat`
- `grep` -> `rg`
- `find` -> `fd`
- `y` -> launch `yazi`
- `repo` -> fuzzy jump to repositories
- `gb` -> interactive git branch switch/delete/fetch
- `gbo` -> open repo remote URL in browser
- `gitdiff` -> inspect or toggle `delta` side-by-side and line-number settings

If `fzf` shell integration is available:

- `Ctrl+T` file picker
- `Ctrl+R` history search
- `Alt+C` directory jump

## Optional Delta Git Config

If you want git to use the bundled `delta` config, include this from your git config:

```ini
[include]
    path = ~/.config/sm-windows-terminal-profiles/bash/profile/modules/delta/delta.gitconfig
```
