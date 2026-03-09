shopt -s nullglob
for function_file in "$PROFILE_ROOT"/functions/*.sh; do
  case "$(basename -- "$function_file")" in
    repo_preview.sh)
      continue
      ;;
  esac

  # shellcheck source=/dev/null
  source "$function_file"
done
shopt -u nullglob
