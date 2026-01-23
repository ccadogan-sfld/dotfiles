#!/bin/bash

setup_git_include() {

  GIT_CONFIG = "$HOME/.gitconfig"
  DOTFILES_GITCONFIG = "$HOME/.config/git/.gitconfig"

  if [[ -f $GIT_CONFIG]]; then
    if ! grep -q "\[include\]" $GIT_CONFIG || ! grep -q "path = $DOTFILES_GITCONFIG" "$GIT_CONFIG"; then
        {
        echo ""
        echo "[include]"
        echo "    path = $DOTFILES_GITCONFIG"
        } >> "$GIT_CONFIG"
    fi
}

setup_git_include