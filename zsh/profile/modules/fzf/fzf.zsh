test_fzf_dependencies() {
  if ! command_exists fd; then
    append_missing_package_module "fd" "Install via your package manager (package: fd-find or fd)"
  fi
}

initialize_fzf() {
  local preview_script="$PROFILE_ROOT/modules/fzf/fzf_default_preview.zsh"
  local fzf_zsh_init=""

  export FZF_DEFAULT_COMMAND='fd --type file --hidden --exclude .git --exclude bin --exclude obj --exclude node_modules'
  export FZF_DEFAULT_OPTS="
--height=40%
--layout=reverse
--border
--footer='Exit: ESC | Select: ENTER | Preview-up: ^u | Preview-down: ^d | Preview-hide: ^p'
--preview='$preview_script {}'
--bind=ctrl-p:toggle-preview
--bind=ctrl-d:preview-down
--bind=ctrl-u:preview-up
--preview-window=right:60%:wrap
"
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

  if command_exists fzf; then
    fzf_zsh_init="$(fzf --zsh 2>/dev/null || true)"
    if [[ -n "$fzf_zsh_init" ]]; then
      eval "$fzf_zsh_init"
    fi
  fi
}
