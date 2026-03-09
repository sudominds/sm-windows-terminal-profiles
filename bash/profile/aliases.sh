set_if_function_alias() {
  local alias_name="$1"
  local function_name="$2"

  if declare -F "$function_name" >/dev/null; then
    alias "$alias_name"="$function_name"
  fi
}

set_if_command_alias() {
  local alias_name="$1"
  local command_name="$2"

  if command_exists "$command_name"; then
    alias "$alias_name"="$command_name"
  fi
}

set_if_function_alias ls invoke_eza
set_if_function_alias ll invoke_eza_long
set_if_command_alias cat bat
set_if_command_alias find fd
set_if_command_alias grep rg
set_if_function_alias y invoke_yazi
set_if_function_alias gb invoke_git_branch
set_if_function_alias gbo invoke_git_browse
set_if_function_alias repo invoke_find_repo
alias git-branch='invoke_git_branch'
alias git-browse='invoke_git_browse'
