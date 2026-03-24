resolve_package_module_path() {
  local module_path="$1"
  local module_full_path="$PROFILE_ROOT/${module_path#./}"

  if [[ ! -f "$module_full_path" ]]; then
    printf 'Warning: module path was not found: %s\n' "$module_full_path" >&2
    return 1
  fi

  printf '%s\n' "$module_full_path"
}

append_missing_package_module() {
  local name="$1"
  local install_command="${2:-}"

  missing_package_modules+=("$name")
  missing_package_install_commands[$name]="$install_command"
}

command_exists() {
  command -v "$1" >/dev/null 2>&1
}
