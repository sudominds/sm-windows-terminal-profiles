$env:PAGER  = "less"
$env:SHELL = "pwsh"

$SharedRoot = Join-Path $PSScriptRoot "..\..\shared" | Resolve-Path

$env:BAT_CONFIG_DIR = Join-Path $SharedRoot "bat"
$env:BAT_THEME = "Catppuccin Mocha"
$env:BAT_STYLE = "full"
$env:EZA_CONFIG_DIR = Join-Path $SharedRoot "eza"
$env:STARSHIP_CONFIG = Join-Path $SharedRoot "starship\starship.toml"
$env:YAZI_CONFIG_HOME = Join-Path $SharedRoot "yazi"

# Optional: repo roots for Invoke-FindRepo / repo alias (supports ';' or ',' separators)
# $env:GIT_REPO_ROOT_DIR = "$HOME/git;$HOME/work/repos"
# Optional: max search depth for repo discovery (default: 4)
# $env:GIT_REPO_SEARCH_DEPTH = "6"
# Optional: browser opener for git-browse / gbo. Use {url} to control placement.
# $env:GIT_BROWSE_OPEN_CMD = 'wslview {url}'
# $env:GIT_BROWSE_OPEN_CMD = 'cmd.exe /C start "" {url}'

# Windows only: yazi needs the 'file' command for MIME detection.
# Point this to the copy bundled with Git for Windows.
# $env:YAZI_FILE_ONE = "C:/Program Files/Git/usr/bin/file.exe"
