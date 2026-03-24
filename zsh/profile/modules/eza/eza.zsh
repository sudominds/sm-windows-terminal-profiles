initialize_eza() {
  export EZA_CONFIG_DIR="${EZA_CONFIG_DIR:-$PROFILE_ROOT/../../shared/eza}"
}

invoke_eza() {
  eza --icons=auto --group-directories-first "$@"
}

invoke_eza_long() {
  printf '\n'
  eza -lah --icons=auto --group-directories-first "$@"
}
