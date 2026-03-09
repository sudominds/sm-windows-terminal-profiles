#!/usr/bin/env bash

repo_path="$1"

[[ -z "$repo_path" || ! -d "$repo_path" ]] && exit 0

if command -v eza >/dev/null 2>&1; then
  exec eza --tree --level=1 --color=always --all --icons=auto -- "$repo_path"
fi

exec ls -la --color=always -- "$repo_path"
