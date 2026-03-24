setopt NULL_GLOB
for function_file in "$PROFILE_ROOT"/functions/*.zsh; do
  case "$(basename -- "$function_file")" in
    repo_preview.zsh)
      continue
      ;;
  esac

  source "$function_file"
done
unsetopt NULL_GLOB
