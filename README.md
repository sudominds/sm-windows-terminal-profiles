# sm-windows-terminal-profiles

Terminal profile setup with modular PowerShell and Bash entrypoints, custom functions, and tool modules.

Docs:
- [PowerShell](./powershell/README.md)
- [Bash](./bash/README.md)

## Shared Config

Both profiles use a common `shared/` directory for tool configurations (themes, keymaps, etc.):

```
shared/
├── bat/          # bat config + Catppuccin Mocha syntax theme
├── delta/        # delta gitconfig + catppuccin theme
├── eza/          # eza color theme
├── starship/     # starship prompt config
└── yazi/         # yazi file manager config + theme
```

### Delta Git Config

To use the bundled `delta` diff viewer config, add this to your `~/.gitconfig`:

```ini
[include]
    path = /path/to/sm-windows-terminal-profiles/shared/delta/delta.gitconfig
```

### Environment Variables

Both profiles support the following optional environment variables:

| Variable | Description | Example |
|---|---|---|
| `GIT_BROWSE_OPEN_CMD` | Browser opener for `gbo`. Use `{url}` as placeholder | `wslview {url}` |
| `GIT_REPO_ROOT_DIR` | Repo roots for `repo` (`;` or `,` separated) | `$HOME/git;$HOME/work` |
| `GIT_REPO_SEARCH_DEPTH` | Max depth for repo discovery (default: 4) | `6` |
| `BAT_CONFIG_DIR` | Override bat config directory | |
| `BAT_THEME` | Override bat theme (default: Catppuccin Mocha) | |
| `BAT_STYLE` | Override bat style (default: full) | |
| `EZA_CONFIG_DIR` | Override eza config directory | |
| `STARSHIP_CONFIG` | Override starship config path | |
| `YAZI_CONFIG_HOME` | Override yazi config directory | |
| `YAZI_FILE_ONE` | Path to `file` command (Windows only — see below) | `C:/Program Files/Git/usr/bin/file.exe` |

The PowerShell `repo` function also accepts `GitRepoRootDir` and `GitRepoSearchDepth`.

### Yazi on Windows

On Windows, yazi needs the `file` command for MIME type detection. It's not in PATH by default, but Git for Windows bundles a copy:

```powershell
$env:YAZI_FILE_ONE = "C:/Program Files/Git/usr/bin/file.exe"
```

This is not needed on Linux where `file` is available system-wide.

## Functions

### `repo`
Fuzzy-find git repositories and jump to the selected repo directory.

Source: [powershell/profile/functions/repo.ps1](./powershell/profile/functions/repo.ps1)

![repo](./screenshots/repo.png)

### `git-branch` (`gb`)
Interactive branch switch/delete/fetch workflow with preview and local/remote branch status.

Source: [powershell/profile/functions/git-branch.ps1](./powershell/profile/functions/git-branch.ps1)

![git-branch](./screenshots/git-branch.png)

## Modules

### `fzf`
Fuzzy finder integration for files, history, and interactive pickers.

GitHub: https://github.com/junegunn/fzf

![fzf](./screenshots/fzf.png)

### `fd`
Fast modern replacement for `find`, used for repository and file discovery.

GitHub: https://github.com/sharkdp/fd

![fd](./screenshots/fd.png)

### `eza`
Modern `ls` replacement with icons and better defaults.

GitHub: https://github.com/eza-community/eza

![eza](./screenshots/eza.png)

### `bat`
Syntax-highlighted `cat` replacement used in previews and file output.

GitHub: https://github.com/sharkdp/bat

![bat](./screenshots/bat.png)

### `ripgrep`
Fast recursive search integration (used as `grep` replacement).

GitHub: https://github.com/BurntSushi/ripgrep

![ripgrep](./screenshots/ripgrep.png)

### `zoxide`
Smarter directory navigation integrated with `cd`.

GitHub: https://github.com/ajeetdsouza/zoxide

![zoxide](./screenshots/zoxide.png)

### `starship`
Cross-shell prompt configuration shared by PowerShell and Bash.

GitHub: https://github.com/starship/starship

![starship](./screenshots/starship.png)

### `yazi`
Terminal file manager integration with cwd handoff back to the shell.

GitHub: https://github.com/sxyazi/yazi

![yazi](./screenshots/yazi.png)
