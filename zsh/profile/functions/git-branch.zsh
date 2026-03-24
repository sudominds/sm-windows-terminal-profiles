invoke_git_branch() {
  local delete_branch_key='alt-d'
  local fetch_key='alt-f'
  local current=""
  local local_branch_data=""
  local remote_branch_data=""
  local lines=""
  local line=""
  local name=""
  local upstream=""
  local track=""
  local star=""
  local label=""
  local ahead=0
  local behind=0
  local ab_text=""
  local out=""
  local key=""
  local picked=""
  local ref=""

  if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    printf 'Not inside a git repository.\n' >&2
    return 1
  fi

  while true; do
    current="$(git branch --show-current)"
    local_branch_data="$(git for-each-ref --sort=-committerdate --format='%(refname:short)%09%(upstream:short)%09%(upstream:track)' refs/heads)"
    remote_branch_data="$(git for-each-ref --sort=-committerdate --format='%(refname:short)' refs/remotes | grep -Ev '^(origin$|origin/HEAD|HEAD)$' || true)"
    lines=""

    while IFS=$'\t' read -r name upstream track; do
      [[ -z "$name" ]] && continue
      star=" "
      [[ "$name" == "$current" ]] && star="*"

      if [[ "$track" == *"[gone]"* ]]; then
        label=$'\033[31m[gne]\033[0m'
      elif [[ -n "$upstream" ]]; then
        label=$'\033[32m[trk]\033[0m'
      else
        label=$'\033[33m[lcl]\033[0m'
      fi

      ahead=0
      behind=0
      if [[ "$track" =~ ahead[[:space:]]+([0-9]+) ]]; then
        ahead="${match[1]}"
      fi
      if [[ "$track" =~ behind[[:space:]]+([0-9]+) ]]; then
        behind="${match[1]}"
      fi

      ab_text=""
      if ((ahead > 0 || behind > 0)); then
        ab_text="$(printf '↑%3d ↓%3d' "$ahead" "$behind")"
      fi

      lines+="${star} ${label} "$'\033[35m'"${ab_text}"$'\033[0m'" ${name}"$'\t'"${name}"$'\n'
    done <<<"$local_branch_data"

    while IFS= read -r line; do
      [[ -z "$line" ]] && continue
      lines+="  "$'\033[36m'"[rmt]"$'\033[0m'"  ${line}"$'\t'"${line}"$'\n'
    done <<<"$remote_branch_data"

    out="$(
      printf '%b' "$lines" |
        fzf \
          --ansi \
          --height=50% \
          --layout=reverse \
          --border \
          --preview-window 'right:60%:wrap' \
          --delimiter $'\t' \
          --with-nth 1 \
          --expect="$delete_branch_key,$fetch_key" \
          --footer "Exit: ESC | Select: ENT | Preview[up:^u][down:^d][hide:^p] | Delete: $delete_branch_key | Fetch: $fetch_key" \
          --border-label ' Git Branches ' \
          --preview "git --no-pager log --color=always -n 10 --pretty=format:'%C(magenta)%h%Creset %C(cyan)%cr%Creset %C(yellow)%an%Creset %C(auto)%d%Creset%n  %s%n' {2}"
    )"

    [[ -z "$out" ]] && return 0

    key="$(printf '%s\n' "$out" | sed -n '1p')"
    picked="$(printf '%s\n' "$out" | sed -n '2p')"
    [[ -z "$picked" ]] && continue

    if [[ "$key" == "$fetch_key" ]]; then
      printf '[git fetch --all --prune --tags]\n'
      git fetch --all --prune --tags
      sleep 0.3
      continue
    fi

    ref="${picked#*$'\t'}"
    [[ "$ref" == origin/* ]] && ref="${ref#origin/}"

    if [[ "$key" == "$delete_branch_key" ]]; then
      if [[ "$ref" == "$current" ]]; then
        printf 'Cannot delete current branch.\n' >&2
        sleep 1
        continue
      fi

      printf "Delete branch '%s'? (y/N) " "$ref"
      read -r response
      if [[ "$response" =~ ^[Yy]$ ]]; then
        git branch -d "$ref" && printf 'Deleted %s\n' "$ref"
      fi

      sleep 1
      continue
    fi

    if git show-ref --verify --quiet "refs/heads/$ref"; then
      git switch "$ref"
    else
      git switch --track "origin/$ref"
    fi

    return $?
  done
}
