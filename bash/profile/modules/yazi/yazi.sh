invoke_yazi() {
  local tmp
  local cwd

  tmp="$(mktemp)"
  yazi "$@" --cwd-file="$tmp"
  cwd="$(cat -- "$tmp" 2>/dev/null)"

  if [[ -n "$cwd" && "$cwd" != "$PWD" && -d "$cwd" ]]; then
    cd -- "$cwd" || return 1
  fi

  rm -f -- "$tmp"
}
