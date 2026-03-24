invoke_find_repo() {
  local query=""
  local help_requested=0
  local -a roots=()
  local -a query_parts=()
  local root_value=""
  local -a resolved_roots=()
  local depth=4
  local root_candidate=""
  local preview_script_path="$PROFILE_ROOT/functions/repo_preview.zsh"
  local repos
  local repo_list
  local repo_matches
  local picked

  while (($# > 0)); do
    case "$1" in
      --help|-h)
        help_requested=1
        shift
        ;;
      --path=*|--root=*)
        root_value="${1#*=}"
        local -a parsed_roots=()
        IFS=',;' read -rA parsed_roots <<<"$root_value"
        roots+=("${parsed_roots[@]}")
        shift
        ;;
      --path|--root|-p)
        if (($# < 2)); then
          printf 'Warning: %s requires a value.\n' "$1" >&2
          return 1
        fi
        local -a parsed_roots=()
        IFS=',;' read -rA parsed_roots <<<"$2"
        roots+=("${parsed_roots[@]}")
        shift 2
        ;;
      *)
        query_parts+=("$1")
        shift
        ;;
    esac
  done

  if ((help_requested)); then
    cat <<'EOF'
Usage:
  repo [query]
  repo [path]
  repo --path <path1,path2,...> [query]
  repo --path=<path1,path2,...> [query]

Environment settings:
  GIT_REPO_ROOT_DIR      One or more roots separated by ';', ',' or newlines
  GIT_REPO_SEARCH_DEPTH  Search depth for .git folders (default: 4)

Compatibility settings:
  GitRepoRootDir
  GitRepoSearchDepth

Examples:
  export GIT_REPO_ROOT_DIR="$HOME/git;$HOME/work/repos"
  export GIT_REPO_SEARCH_DEPTH="6"
  repo --help
  repo nvim
  repo "$HOME/git"
  repo --path "$HOME/git,$HOME/work/repos" dotfiles
EOF
    return 0
  fi

  query="${query_parts[*]}"

  if ((${#roots[@]} == 0)) && [[ -n "$query" && -d "$query" ]]; then
    roots=("$query")
    query=""
  fi

  if ((${#roots[@]} == 0)); then
    root_value="${GIT_REPO_ROOT_DIR:-${GitRepoRootDir:-}}"
    if [[ -n "$root_value" ]]; then
      root_value="${root_value//$'\n'/;}"
      local -a parsed_roots=()
      IFS=',;' read -rA parsed_roots <<<"$root_value"
      roots+=("${parsed_roots[@]}")
    fi
  fi

  if ((${#roots[@]} == 0)); then
    printf "Warning: no root path provided. Use --path '$HOME/git,$HOME/work' or set GIT_REPO_ROOT_DIR.\n" >&2
    return 1
  fi

  for root_candidate in "${roots[@]}"; do
    [[ -z "$root_candidate" ]] && continue
    if [[ ! -d "$root_candidate" ]]; then
      printf 'Warning: root path does not exist: %s\n' "$root_candidate" >&2
      continue
    fi
    resolved_roots+=("$(cd -- "$root_candidate" && pwd)")
  done

  if ((${#resolved_roots[@]} == 0)); then
    printf 'Warning: no valid root paths were found.\n' >&2
    return 1
  fi

  resolved_roots=("${(@f)$(printf '%s\n' "${resolved_roots[@]}" | sort -u)}")

  if [[ -n "${GIT_REPO_SEARCH_DEPTH:-${GitRepoSearchDepth:-}}" ]]; then
    if [[ "${GIT_REPO_SEARCH_DEPTH:-${GitRepoSearchDepth:-}}" =~ ^[1-9][0-9]*$ ]]; then
      depth="${GIT_REPO_SEARCH_DEPTH:-${GitRepoSearchDepth:-}}"
    else
      printf "Warning: GIT_REPO_SEARCH_DEPTH is invalid ('%s'). Falling back to depth %s.\n" \
        "${GIT_REPO_SEARCH_DEPTH:-${GitRepoSearchDepth:-}}" "$depth" >&2
    fi
  fi

  if ! command_exists fd; then
    printf 'Warning: fd is required for repo discovery.\n' >&2
    return 1
  fi

  repos="$(
    for root_candidate in "${resolved_roots[@]}"; do
      fd --type d --hidden --no-ignore-vcs --max-depth "$depth" '^\.git$' -- "$root_candidate" 2>/dev/null |
        while IFS= read -r git_dir; do
          repo_dir="$git_dir"
          repo_dir="${repo_dir%$'\r'}"
          repo_dir="${repo_dir%/}"
          repo_dir="${repo_dir%/.git}"
          repo_dir="${repo_dir%.git}"
          printf '%s\t%s\n' "$root_candidate" "$repo_dir"
        done
    done | sort -t $'\t' -k2,2 -u
  )"

  if [[ -z "$repos" ]]; then
    printf 'Warning: no git repositories found under: %s\n' "$(IFS=', '; printf '%s' "${resolved_roots[*]}")" >&2
    return 1
  fi

  if [[ -n "$query" ]]; then
    repo_matches="$(printf '%s\n' "$repos" | grep -i -- "$query" || true)"
    if [[ -z "$repo_matches" ]]; then
      printf 'Warning: no repositories matched query: %s\n' "$query" >&2
      return 1
    fi

    if [[ "$(printf '%s\n' "$repo_matches" | wc -l)" -eq 1 ]]; then
      cd -- "${repo_matches#*$'\t'}" || return 1
      return 0
    fi

    repos="$repo_matches"
  fi

  repo_list="$(
    while IFS=$'\t' read -r root_candidate repo_dir; do
      display="${repo_dir#"$root_candidate"/}"
      if [[ "$repo_dir" == "$root_candidate" ]]; then
        display="$(basename "$repo_dir")"
      fi

      if ((${#resolved_roots[@]} > 1)); then
        display="[$(basename "$root_candidate")] $display"
      fi

      printf '%s\t%s\n' "$display" "$repo_dir"
    done <<<"$repos"
  )"

  picked="$(
    printf '%s\n' "$repo_list" |
      fzf --delimiter $'\t' --with-nth 1 --query "$query" --preview "$preview_script_path {2}"
  )"

  [[ -z "$picked" ]] && return 0

  cd -- "${picked#*$'\t'}" || return 1
}
