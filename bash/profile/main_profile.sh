#!/usr/bin/env bash

# Only run in interactive shells.
case $- in
  *i*) ;;
  *) return 0 2>/dev/null || exit 0 ;;
esac

PROFILE_ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

profile_parts=(
  "./main_profile.d/helpers.sh"
  "./main_profile.d/load-environment.sh"
  "./main_profile.d/load-package-modules.sh"
  "./main_profile.d/load-functions.sh"
  "./main_profile.d/load-aliases.sh"
  "./main_profile.d/show-welcome.sh"
  "./main_profile.d/show-missing-package-modules.sh"
)

for profile_part in "${profile_parts[@]}"; do
  profile_part_path="$PROFILE_ROOT/${profile_part#./}"
  if [[ ! -f "$profile_part_path" ]]; then
    printf 'Warning: profile part was not found: %s\n' "$profile_part_path" >&2
    continue
  fi

  # shellcheck source=/dev/null
  source "$profile_part_path"
done

show_profile_welcome
