export DELTA_PAGER="less -R"

gitdiff() {
  local side_by_side=""
  local line_numbers=""
  local show_help=0

  while [[ $# -gt 0 ]]; do
    case "$1" in
      --side-by-side)
        [[ $# -ge 2 ]] || {
          printf 'gitdiff: missing value for %s\n' "$1" >&2
          return 1
        }
        side_by_side="$2"
        shift 2
        ;;
      --line-numbers)
        [[ $# -ge 2 ]] || {
          printf 'gitdiff: missing value for %s\n' "$1" >&2
          return 1
        }
        line_numbers="$2"
        shift 2
        ;;
      -h|--help)
        show_help=1
        shift
        ;;
      *)
        printf 'gitdiff: unknown argument: %s\n' "$1" >&2
        return 1
        ;;
    esac
  done

  if [[ $show_help -eq 1 ]]; then
    printf 'gitdiff - configure delta diff options\n\n'
    printf 'Usage:\n'
    printf '  gitdiff\n'
    printf '  gitdiff --side-by-side <on|off>\n'
    printf '  gitdiff --line-numbers <on|off>\n'
    printf '  gitdiff --side-by-side <on|off> --line-numbers <on|off>\n'
    return 0
  fi

  if [[ -z "$side_by_side" && -z "$line_numbers" ]]; then
    _gitdiff_print_option 'delta.side-by-side'
    _gitdiff_print_option 'delta.line-numbers'
    return 0
  fi

  if [[ -n "$side_by_side" ]]; then
    _gitdiff_set_option 'delta.side-by-side' "$side_by_side" || return 1
  fi

  if [[ -n "$line_numbers" ]]; then
    _gitdiff_set_option 'delta.line-numbers' "$line_numbers" || return 1
  fi
}

_gitdiff_set_option() {
  local key="$1"
  local value="$2"
  local bool_value=""

  case "$value" in
    on) bool_value="true" ;;
    off) bool_value="false" ;;
    *)
      printf 'gitdiff: expected on|off for %s, got %s\n' "$key" "$value" >&2
      return 1
      ;;
  esac

  git config --global "$key" "$bool_value"
  printf '%s -> %s\n' "$key" "$value"
}

_gitdiff_print_option() {
  local key="$1"
  local value=""
  local display_value="off"

  value="$(git config --global --get "$key" 2>/dev/null || true)"
  if [[ "$value" == "true" ]]; then
    display_value="on"
  fi

  printf '%s = %s\n' "$key" "$display_value"
}
