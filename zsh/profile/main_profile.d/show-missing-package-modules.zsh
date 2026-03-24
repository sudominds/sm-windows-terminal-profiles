show_missing_package_modules() {
  local -A seen_names=()
  local missing_name
  local install_command

  [[ ${#missing_package_modules[@]} -eq 0 ]] && return 0

  printf 'Warning: some package dependencies are missing.\n' >&2
  printf 'Install guidance:\n'

  for missing_name in "${missing_package_modules[@]}"; do
    [[ -n "${seen_names[$missing_name]:-}" ]] && continue
    seen_names[$missing_name]=1

    install_command="${missing_package_install_commands[$missing_name]}"
    if [[ -n "$install_command" ]]; then
      printf '  %s: %s\n' "$missing_name" "$install_command"
    else
      printf '  %s\n' "$missing_name"
    fi
  done
}

show_missing_package_modules
