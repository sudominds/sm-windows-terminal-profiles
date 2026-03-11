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

## Optional Environment Variables

### Repo Search

`repo` uses `GIT_REPO_ROOT_DIR` and optional search depth:

```bash
export GIT_REPO_ROOT_DIR="$HOME/git;$HOME/work/repos"
export GIT_REPO_SEARCH_DEPTH="4"
```

The Bash profile also accepts the legacy `GitRepoRootDir` and `GitRepoSearchDepth` names for compatibility.

### Browser Opener

`gbo` / `git-browse` requires `GIT_BROWSE_OPEN_CMD` to open URLs in a browser. Use `{url}` as a placeholder:

```bash
export GIT_BROWSE_OPEN_CMD='wslview {url}'
```

More examples:

```bash
export GIT_BROWSE_OPEN_CMD='cmd.exe /C start "" {url}'
export GIT_BROWSE_OPEN_CMD='xdg-open {url}'
export GIT_BROWSE_OPEN_CMD='/mnt/c/Windows/System32/cmd.exe /C start "" {url}'
```

If `GIT_BROWSE_OPEN_CMD` (and `BROWSER`) are unset, the URL is printed to the terminal.

### Tool Config Overrides

The profile uses shared config files from the `shared/` directory at the repo root. You can override individual paths:

```bash
export BAT_CONFIG_DIR="/path/to/custom/bat"
export BAT_THEME="Catppuccin Mocha"
export BAT_STYLE="full"
export EZA_CONFIG_DIR="/path/to/custom/eza"
export STARSHIP_CONFIG="/path/to/custom/starship.toml"
export YAZI_CONFIG_HOME="/path/to/custom/yazi"
```

## What This Profile Adds

After setup, these aliases/functions are available when dependencies are installed:

- `ls`, `ll` -> `eza`
- `cat` -> `bat`
- `grep` -> `rg`
- `find` -> `fd`
- `y` -> launch `yazi`
- `repo` -> fuzzy jump to repositories
- `gb` / `git-branch` -> interactive git branch switch/delete/fetch
- `gbo` / `git-browse` -> open repo remote URL in browser
- `gitdiff` -> inspect or toggle `delta` side-by-side and line-number settings

If `fzf` shell integration is available:

- `Ctrl+T` file picker
- `Ctrl+R` history search
- `Alt+C` directory jump

## Optional Delta Git Config

If you want git to use the bundled `delta` config, add this to your `~/.gitconfig`:

```ini
[include]
    path = /path/to/sm-windows-terminal-profiles/shared/delta/delta.gitconfig
```
