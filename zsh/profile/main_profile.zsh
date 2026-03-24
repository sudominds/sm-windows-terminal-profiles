# Only run in interactive shells.
case $- in
  *i*) ;;
  *) return 0 2>/dev/null || exit 0 ;;
esac

PROFILE_ROOT="${0:A:h}"

profile_parts=(
  "./main_profile.d/helpers.zsh"
  "./main_profile.d/load-environment.zsh"
  "./main_profile.d/load-package-modules.zsh"
  "./main_profile.d/load-functions.zsh"
  "./main_profile.d/load-aliases.zsh"
  "./main_profile.d/show-welcome.zsh"
  "./main_profile.d/show-missing-package-modules.zsh"
)

for profile_part in "${profile_parts[@]}"; do
  profile_part_path="$PROFILE_ROOT/${profile_part#./}"
  if [[ ! -f "$profile_part_path" ]]; then
    printf 'Warning: profile part was not found: %s\n' "$profile_part_path" >&2
    continue
  fi

  source "$profile_part_path"
done

show_profile_welcome
