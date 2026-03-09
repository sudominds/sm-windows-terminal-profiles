invoke_git_browse_open() {
  local url="$1"
  local opener_template="${GIT_BROWSE_OPEN_CMD:-${BROWSER:-}}"
  local opener_command=""

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

  if [[ -n "$opener_template" ]]; then
    if [[ "$opener_template" == *"{url}"* ]]; then
      opener_command="${opener_template//\{url\}/$url}"
    else
      opener_command="$opener_template \"$url\""
    fi

    run_detached_command "$opener_command"
    return 0
  fi

  if [[ -n "${WSL_DISTRO_NAME:-}" || -n "${WSL_INTEROP:-}" ]]; then
    if command_exists wslview; then
      run_detached_command "wslview \"$url\""
      return 0
    fi
  fi

  if command_exists xdg-open; then
    run_detached_command "xdg-open \"$url\""
    return 0
  fi

  if command_exists wslview; then
    run_detached_command "wslview \"$url\""
    return 0
  fi

  return 1
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

  printf 'No browser opener found. URL: %s\n' "$url"
}
