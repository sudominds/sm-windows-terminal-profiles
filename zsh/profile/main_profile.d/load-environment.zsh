environment_module_path="$(resolve_package_module_path "./environment_variables.zsh")" || return 0

source "$environment_module_path"
