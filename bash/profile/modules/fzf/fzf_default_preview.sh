#!/usr/bin/env bash

path="$1"
path="${path%\'}"
path="${path#\'}"

if [[ -d "$path" ]]; then
  if command -v eza >/dev/null 2>&1; then
    exec eza --tree --level=1 --icons --color=always --group-directories-first -- "$path"
  fi

  exec ls -la --color=always -- "$path"
fi

if ! command -v bat >/dev/null 2>&1; then
  exec sed -n '1,300p' -- "$path"
fi

out="$(bat --style=all --color=always --paging=never --line-range :300 -- "$path" 2>&1)"
status=$?

if [[ $status -ne 0 || "$out" == *binary* ]]; then
  printf '%s\n' "$path"
else
  printf '%s\n' "$out"
fi
