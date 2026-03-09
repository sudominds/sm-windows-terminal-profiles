environment_module_path="$(resolve_package_module_path "./environment_variables.sh")" || return 0

# shellcheck source=/dev/null
source "$environment_module_path"
