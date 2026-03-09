declare -ga missing_package_modules=()
declare -gA missing_package_install_commands=()

package_modules=(
  "eza:eza:./modules/eza/eza.sh::initialize_eza:Install via your package manager (package: eza)"
  "bat:bat:./modules/bat/bat.sh:::Install via your package manager (package: bat)"
  "delta:delta:./modules/delta/delta.sh:::Install via your package manager (package: git-delta or delta)"
  "fd:fd:./modules/fd/fd.sh:::Install via your package manager (package: fd-find or fd)"
  "fzf:fzf:./modules/fzf/fzf.sh:test_fzf_dependencies:initialize_fzf:Install via your package manager (package: fzf)"
  "rg:rg:./modules/ripgrep/ripgrep.sh:::Install via your package manager (package: ripgrep)"
  "starship:starship:./modules/starship/starship.sh:::Install via your package manager (package: starship)"
  "yazi:yazi:./modules/yazi/yazi.sh:::Install via your package manager (package: yazi)"
  "zoxide:zoxide:./modules/zoxide/zoxide.sh:::Install via your package manager (package: zoxide)"
  "less:less:./modules/less/less.sh:::Install via your package manager (package: less)"
)

for package_module in "${package_modules[@]}"; do
  IFS=":" read -r module_name module_command module_path test_function initialize_function install_command <<<"$package_module"

  if ! command_exists "$module_command"; then
    append_missing_package_module "$module_name" "$install_command"
    continue
  fi

  module_full_path="$(resolve_package_module_path "$module_path")" || continue

  # shellcheck source=/dev/null
  source "$module_full_path"

  if [[ -n "$test_function" ]]; then
    if ! declare -F "$test_function" >/dev/null; then
      printf 'Warning: test function was not found for %s: %s\n' "$module_name" "$test_function" >&2
    else
      "$test_function"
    fi
  fi

  if [[ -z "$initialize_function" ]]; then
    continue
  fi

  if ! declare -F "$initialize_function" >/dev/null; then
    printf 'Warning: initialization function was not found for %s: %s\n' "$module_name" "$initialize_function" >&2
    continue
  fi

  "$initialize_function"
done
