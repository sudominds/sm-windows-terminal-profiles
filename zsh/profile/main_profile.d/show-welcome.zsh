show_profile_welcome() {
  local force="${1:-}"
  local welcome_version="v1"
  local welcome_marker_path="$HOME/.zsh_profile_welcome_${welcome_version}"
  local lines=()

  if [[ "$force" != "--force" && -f "$welcome_marker_path" ]]; then
    return 0
  fi

  lines+=("")
  lines+=("Zsh profile loaded.")
  lines+=("")
  lines+=("Shortcuts:")

  command_exists ls && lines+=("  ls                 eza listing with icons")
  command_exists ll && lines+=("  ll                 long eza listing")
  command_exists y && lines+=("  y                  open yazi - terminal file browser")
  command_exists repo && lines+=("  repo               fuzzy jump to repository (repo --help)")
  command_exists git-branch && lines+=("  gb                 fuzzy switch/delete/fetch branches")
  command_exists git-browse && lines+=("  gbo                open current repo remote in browser")
  command_exists grep && lines+=("  grep/rg            alias to rg")
  command_exists find && lines+=("  find/fd            alias to fd")
  command_exists cat && lines+=("  cat/bat            alias to bat")

  if [[ -n "${FZF_CTRL_T_COMMAND:-}" ]]; then
    lines+=("")
    lines+=("Keybindings:")
    lines+=("  Ctrl+T             fzf file picker")
    lines+=("  Ctrl+R             fzf history search")
    lines+=("  Alt+C              fzf directory jump")
  fi

  lines+=("")
  lines+=("Run 'show_profile_welcome --force' to display this again.")

  printf '%s\n' "${lines[@]}"
  : >"$welcome_marker_path" 2>/dev/null || true
}
