invoke_git_browse_open() {
  local url="$1"
  local opener_template="${GIT_BROWSE_OPEN_CMD:-${BROWSER:-}}"
  local opener_command=""

  if [[ -z "$opener_template" ]]; then
    return 1
  fi

  run_detached_command() {
    local command_string="$1"

    if command_exists setsid; then
      if setsid -f bash -lc "$command_string" >/dev/null 2>&1 </dev/null; then
        return 0
      fi
    fi

    nohup bash -lc "$command_string" >/dev/null 2>&1 </dev/null &
    disown "$!" 2>/dev/null || true
    return 0
  }

  if [[ "$opener_template" == *"{url}"* ]]; then
    opener_command="${opener_template//\{url\}/$url}"
  else
    opener_command="$opener_template \"$url\""
  fi

  run_detached_command "$opener_command"
  return 0
}

invoke_git_browse() {
  local url

  if ! url="$(git remote get-url origin 2>/dev/null)"; then
    printf 'No origin remote found.\n' >&2
    return 1
  fi

  if [[ "$url" =~ ^git@([^:]+):(.+)$ ]]; then
    url="https://${BASH_REMATCH[1]}/${BASH_REMATCH[2]}"
  fi

  url="$(printf '%s' "$url" | sed -E 's#^https://[^@]+@#https://#; s/\.git$//')"

  if invoke_git_browse_open "$url"; then
    return 0
  fi

  printf '%s\n' "$url"
  printf 'Set GIT_BROWSE_OPEN_CMD to open URLs automatically.\n'
  printf 'Example: export GIT_BROWSE_OPEN_CMD='\''wslview {url}'\''\n'
}
