aliases_module_path="$(resolve_package_module_path "./aliases.sh")" || return 0

# shellcheck source=/dev/null
source "$aliases_module_path"
