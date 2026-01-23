#!/usr/bin/env bash
set -euo pipefail

setup_git_include() {
  GIT_CONFIG="$HOME/.gitconfig"
  DOTFILES_GITCONFIG="$HOME/.config/git/.gitconfig"

  if [[ -f "$GIT_CONFIG" ]]; then
    if ! grep -qF "[include]" "$GIT_CONFIG" || ! grep -qF "path = $DOTFILES_GITCONFIG" "$GIT_CONFIG"; then
      {
        echo ""
        echo "[include]"
        echo "    path = $DOTFILES_GITCONFIG"
      } >> "$GIT_CONFIG"
    fi
  fi
}

setup_git_include